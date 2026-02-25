# Lab: page tables

Lab detail: https://pdos.csail.mit.edu/6.1810/2025/labs/pgtbl.html

# 1. Inspect a user-process page table

The output of print_pgtbl:

```
va 0 pte 0x21FCF45B pa 0x87F3D000 perm 0x5B
va 1000 pte 0x21FCE85B pa 0x87F3A000 perm 0x5B
...
va 0xFFFFD000 pte 0x0 pa 0x0 perm 0x0
va 0xFFFFE000 pte 0x21FD80C7 pa 0x87F60000 perm 0xC7
va 0xFFFFF000 pte 0x20001C4B pa 0x80007000 perm 0x4B
```

Q. For every page table entry in the print_pgtbl output, explain what it logically contains and what its permission bits are. Figure 3.4 in the xv6 book might be helpful, although note that the figure might have a slightly different set of pages than process that's being inspected here. Note that xv6 doesn't place the virtual pages consecutively in physical memory.

Permission bits:

```
7 6 5 4 3 2 1 0
D A G U X W R V

D: Dirty
A: Accessed
G: Global
U: User
X: Executable
W: Writable
R: Readable
V: Valid
```

```
va 0 pte 0x21FCF45B pa 0x87F3D000 perm 0x5B          // Binary format: 01011011 => meaning flags: A,U,X,R,V
                                                     // va 0: text segment

va 1000 pte 0x21FCE85B pa 0x87F3A000 perm 0x5B       // Binary format: 01011011 => meaning flags: A,U,X,R,V
                                                     // va 1000: also text segment
...
va 0xFFFFD000 pte 0x0 pa 0x0 perm 0x0                // no permission
                                                     // pte 0x0: unused page

va 0xFFFFE000 pte 0x21FD80C7 pa 0x87F60000 perm 0xC7 // Binary format: 11000111 => meaning flags: D,A,W,R,V
                                                     // va 0xFFFFE000 = lower page of trampoline page: trapframe page

va 0xFFFFF000 pte 0x20001C4B pa 0x80007000 perm 0x4B // Binary format: 01001011 => meaning flags: A,X,R,V
                                                     // va 0xFFFFF000 = MAXVA - PGSIZE: so this page is trampoline
```

References: figure 3.2 and figure 3.4 of the xv6 book

# 2. Speed up system calls

## Task: optimize the getpid() system call in xv6

Related source code:

* kernel/proc.c
* kernel/proc.h

Implementation:

1. add a new member `struct usyscall  *usyscall` in the `struct proc` so that we can free the USYSCALL page when the process is unused:

```c
struct proc {
  ...
  struct usyscall  *usyscall;  // USYSCALL page
  ...
};
```

2. when allocating a process, (1) allocate a usyscall page and (2) add a new page table entry to map the USYSCALL page just below the trapframe page

```c
  // Allocate a usyscall page.
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    freeproc(p);
    release(&p->lock);
    return 0;
  }
```

```
  // map the USYSCALL page just below the trapframe page, for
  // storing struct usyscall
  if(mappages(pagetable, USYSCALL, PGSIZE,
             (uint64)(p->usyscall), PTE_R | PTE_U) < 0){
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    uvmfree(pagetable, 0);
    return 0;
  }
```

3. update the freeproc() function to free the USYSCALL page

```
  if(p->usyscall)
    kfree((void*)p->usyscall);
  p->usyscall = 0;
```

4. update the proc_freepagetable() function to free the page table entry

```
proc_freepagetable(pagetable_t pagetable, uint64 sz)
{
  ...
  uvmunmap(pagetable, USYSCALL, 1, 0);
  ...
}
```

## Q. Which other xv6 system call(s) could be made faster using this shared page? Explain how.

I cant think other xv6 system call(s) could be made faster using this **(read-only)** shared page.

# 3. Print a page table

**DEMO**: https://docs.google.com/videos/d/1dN4FoMZvgBTlzOmtybAa5X70w9oLEayta0C8maz7Tkc/play

source code: 

```c
145 void
146 vmprint(pagetable_t pagetable) {
147   printf("page table %p\n", pagetable);
148
149   // For loop the l2 page table
150   for(uint64 l2 = 0; l2 < 512; l2++){
151     pte_t pte = pagetable[l2];
152     if((pte & PTE_V) == 0){
153       continue;
154     }
155     uint64 va = l2 << 30;
156     pagetable_t l1pa = (pagetable_t) PTE2PA(pte);
157     printf(".. %p: pte %p pa %p\n", (void *)va, (void *)pte, (void *)l1pa);
158
159     // For loop the l1 page table
160     for(uint64 l1 = 0; l1 < 512; l1++){
161       pte_t pte = l1pa[l1];
162       if((pte & PTE_V) == 0){
163         continue;
164       }
165       uint64 l1va = va | (l1 << 21);
166       pagetable_t l0pa = (pagetable_t) PTE2PA(pte);
167       printf(".. .. %p: pte %p pa %p\n", (void *)l1va, (void *)pte, (void *)l0pa);
168       // For loop the l0 page table
169       for(uint64 l0 = 0; l0 < 512; l0++){
170         pte_t pte = l0pa[l0];
171         if((pte & PTE_V) == 0){
172           continue;
173         }
174         uint64 l0va = l1va | (l0 << 12);
175         uint64 pa = PTE2PA(pte);
176         printf(".. .. .. %p: pte %p pa %p\n", (void *)l0va, (void *)pte, (void *)pa);
177       }
178     }
179   }
180
181 }
```

Reference: figure 3.2 of the xv6 book

# 4. Use superpages

Requirements:

* If a user program calls sbrk() with a size of 2 megabytes or more, and the newly created address range includes one or more areas that are two-megabyte-aligned and at least two megabytes in size, the kernel should use a single superpage (instead of hundreds of ordinary pages)
* When sbrk frees a superpage partially (e.g., freeing the last 4096 bytes of a superpage), you will need to "demote" a super page into regular pages.

Attack Plan:

1. separate free memory region into two physical memory areas: (1) 4-KB pages and (2) 2-MB pages

```
PHYSTOP ---------->|------------------|
                   |                  |
                   |  16 * 2-MB pages |
                   |                  |
SMALLPGSTOP ------>|------------------|
                   |                  |
                   |  4-kB pages      | 
                   |                  |
end -------------->|------------------|
```

2. update kalloc.c to initialize the free pages and add `superalloc()` and `superfree()` functions

3. create superwalk() to return level 1 PTE that corresponding to virtual address va

4. update uvmalloc() to allocate super pages when newsz >= SUPERPGSIZE and use superwalk() to find the PTE

5. update walk() to the return the level of the returned PTE

6. update uvmdealloc() to the demotion of changing superpage into regular pages

Test result: https://docs.google.com/videos/u/0/d/1wkRfzBbpSY1UYmDYTH8ttY6cFBdoQ3JtYILXz5OooLo/play

Implementation Tips:

* A PTE is considered a leaf (maps actual memory) if PTE_V == 1 (valid) and At least one of PTE_R, PTE_W, or PTE_X is 1 (i.e., RWX != 000)
* Do NOT need to convert or "move" any existing 4 KiB pages into 2 MB superpages
* read the pgtbltest.c to learn about how many physical memory we need to allocate for storing 2 MB pages

Implementation Challenges:

* How can uvmunmap know the pte returned from walk() is a 2 MB pte or a 4kb pte?
* The if condition of triggering the superpage demotion

The uvmunmap() assumption:

The callers(e.g. uvmdealloc()) of the uvmunmap() will not set the following unmap range:

```
superpage:   [--------------------------------]   <= 2 MB
unmap range:           [----------]               <=  starts in middle, ends in middle
                   a                  dealloc_end
```

Note: **the implementation is not bug-free, even though it passes all the tests!**
