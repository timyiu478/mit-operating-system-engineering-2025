# Note

## Lazy allocation

Application examples that they do not know how much memory they needs and they will allocate the memory more than they need:

* process user inputs

Overheads:

* pagefault => user/kernel transition

## Copy-on-write Fork

* No copy is needed if the process incurs **store** page fault.
    * when can happen? e.g. exec()

# Exercise 

1. Write a user program that grows its address space by one byte by calling sbrk(1). Run the program and investigate the page table for the program before the call to sbrk and after the call to sbrk. How much space has the kernel allocated? What does the PTE for the new memory contain?
