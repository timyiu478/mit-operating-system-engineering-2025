#include "types.h"
#include "riscv.h"
#include "defs.h"
#include "param.h"
#include "memlayout.h"
#include "spinlock.h"
#include "sleeplock.h"
#include "proc.h"
#include "vm.h"
#include "fs.h"
#include "file.h"
#include "fcntl.h"


uint64
sys_exit(void)
{
  int n;
  argint(0, &n);
  kexit(n);
  return 0;  // not reached
}

uint64
sys_getpid(void)
{
  return myproc()->pid;
}

uint64
sys_fork(void)
{
  return kfork();
}

uint64
sys_wait(void)
{
  uint64 p;
  argaddr(0, &p);
  return kwait(p);
}

uint64
sys_sbrk(void)
{
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
  argint(1, &t);
  addr = myproc()->sz;

  if(t == SBRK_EAGER || n < 0) {
    if(growproc(n) < 0) {
      return -1;
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
      return -1;
    myproc()->sz += n;
  }
  return addr;
}

uint64
sys_pause(void)
{
  int n;
  uint ticks0;

  argint(0, &n);
  if(n < 0)
    n = 0;
  acquire(&tickslock);
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
  }
  release(&tickslock);
  return 0;
}

uint64
sys_kill(void)
{
  int pid;

  argint(0, &pid);
  return kkill(pid);
}

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
  uint xticks;

  acquire(&tickslock);
  xticks = ticks;
  release(&tickslock);
  return xticks;
}

uint64
sys_mmap(void)
{
  uint64 addr;
  int len, prot, flags, fd, offset;

  argaddr(0, &addr);
  argint(1, &len);
  argint(2, &prot);
  argint(3, &flags);
  argint(4, &fd);
  argint(5, &offset);

  if (len == 0)
    return -1;

  if (addr != 0) {
    printf("mmap: only support addr = 0");
    return -1;
  }

  struct proc *p = myproc();

  if (((prot & PROT_READ) > 0) & !p->ofile[fd]->readable) {
    // printf("mmap: target file is not readable\n");
    return -1;
  }
  if (((prot & PROT_WRITE) > 0) & !p->ofile[fd]->writable & (flags & MAP_SHARED)) {
    // printf("mmap: target file is not writable\n");
    return -1;
  }

  // Allocate new virtual pages 
  uint64 size = PGROUNDUP(len);
  uint64 start = PGROUNDDOWN(p->mmap_base - size);

  // Check if address overlap with other memory regions
  if (start < p->sz || start >= TRAPFRAME) {
    return -1;
  }

  // Find free vma
  int i = 0;
  for (; i < NVMA; i++) {
    if (p->vma[i].valid == 0)
      break;
  }
  if (i == NVMA) {
    return -1;
  }

  // Set and use the free VMA slot
  p->vma[i].start  = start;
  p->vma[i].end    = start + size;
  p->vma[i].f   = filedup(p->ofile[fd]);
  p->vma[i].offset = offset;
  p->vma[i].prot   = prot;
  p->vma[i].flags  = flags;
  p->vma[i].valid  = 1;

  // Move the mmap top downward for the next mapping
  p->mmap_base = start;

  return start;
}

// Assumption: either unmap at the start, or at the end, or the whole region 
// (but not punch a hole in the middle of a region)
uint64
sys_munmap(void)
{
  uint64 addr, end;
  int len;

  argaddr(0, &addr);
  argint(1, &len);

  if (addr == 0 || len == 0 || (addr % PGSIZE) != 0)
    return -1;

  end = PGROUNDUP(addr + len);

  struct proc *p = myproc();

  for (uint i=0; i < NVMA; i++) {
    struct VMA *vma = &p->vma[i];

    if (vma->valid == 0 || vma->end <= addr || vma->start >= end)
      continue;

    if (uvmunmap_vma(p->pagetable, vma, addr, end) == -1)
      return -1;
    break;
  }

  if (addr == p->mmap_base) {
    p->mmap_base = end;
  }

  return 0;
}
