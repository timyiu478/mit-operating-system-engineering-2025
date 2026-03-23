Motivation: Many interesting user-level algorithms want finer-grained or application-specific control over memory mappings and page faults.

Proposed VM Primitives:

* TRAP: handle page fault in user mode
* PROT1/N: decrease accessibility  e.g. RW -> R
* UNPROT: increase accessibility e.g. R -> RW
* DIRTY: return a list of dirty pages
* MAP2: map the same physical page into 2 different virtual addresses with different protection levels in the same address space

Unix Today's User VM Primitives:

* mmap
* unmap
* mprotect
* sigaction

VM Implementation:

* Address Space: Page Table + Virtual Memory Area
* Virtual Memory Area: contiguous range of addresses and permissions backed by the same object (e.g. file descriptor)

User-level Trap Implementation:

> similar to sigalarm lab

1. PTE marked as invalid
2. Page fault -> CPU jumps to kernel trap's interupt handler
3. Kernel saves the trapframe
4. Asks the VM system what to do?
    * look at VMA or installed user-level handler
5. Upcall into user-level handler
6. User code returns to kernel mode
7. Kernel resumes interupt process

Further Study: Garbage collection
