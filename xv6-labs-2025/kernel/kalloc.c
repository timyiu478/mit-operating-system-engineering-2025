// Physical memory allocator, for user processes,
// kernel stacks, page-table pages,
// and pipe buffers. Allocates whole 4096-byte pages.

#include "types.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "riscv.h"
#include "defs.h"

#define NPAGES (PHYSTOP/PGSIZE)

void freerange(void *pa_start, void *pa_end);

extern char end[]; // first address after kernel.
                   // defined by kernel.ld.

struct run {
  struct run *next;
};

struct {
  struct spinlock lock;
  struct run *freelist;
} kmem;

static int refcount[NPAGES];

void
kinit()
{
  initlock(&kmem.lock, "kmem");
  freerange(end, (void*)PHYSTOP);
}

void
freerange(void *pa_start, void *pa_end)
{
  char *p;
  p = (char*)PGROUNDUP((uint64)pa_start);
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    refcount[PA2IDX(p)] = 1;
    kfree(p);
  }
}

// Free the page of physical memory pointed at by pa
// if --refcount[PA2IDX(pa) == 0,
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
  struct run *r;
  int idx;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) {
    printf("invalid pa: %p\n", pa);
    panic("kfree");
  }

  idx = PA2IDX((uint64)pa);

  acquire(&kmem.lock);
  if(refcount[idx] == 0) { // double free?
    printf("double free pa: %p\n", pa);
    panic("kfree");
  }
  refcount[idx]--;
  if(refcount[idx] == 0) {
    // Fill with junk to catch dangling refs.
    memset(pa, 1, PGSIZE);

    r = (struct run*)pa;
  
    r->next = kmem.freelist;
    kmem.freelist = r;
  }
  release(&kmem.lock);
}

// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
  struct run *r;

  acquire(&kmem.lock);
  r = kmem.freelist;
  if(r) {
    kmem.freelist = r->next;
    if (refcount[PA2IDX((uint64)r)]) {
      printf("ref count of %p is %d != 1 when kalloc\n", (void *)r, refcount[PA2IDX((uint64)r)]);
      panic("kalloc");
    }
    refcount[PA2IDX((uint64)r)] = 1;
  }
  release(&kmem.lock);

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
  return (void*)r;
}

// Increase the reference count of the physical memory page by 1
// Expected caller: vm.c:uvmcopy()
void
kincref(uint64 pa)
{
  acquire(&kmem.lock);
  refcount[PA2IDX(pa)]++;
  release(&kmem.lock);
}

// Get reference count of pa
int
kref(uint64 pa)
{
  return refcount[PA2IDX(pa)];
}
