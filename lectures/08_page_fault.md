Goal: implement virtual memory features (lazy allocation, COW fork, demand paging, mmap) using page fault

Q. What are things that page fault give us?

* A chance to change the mapping of virtual address to physical address dynamically.

Lazy allocation:

* Why lazy allocation? application often ask more memory than it needs
* How?
    * (1) sbrk(n) just update the p->sz to p->sz + n
    * (2) page fault but VA < p->sz => kalloc(), update page table, restart instruction

Zero fill on demand:

* zero page: a page that fills with all zero.
* How? 
    * (1) map all zero virtual pages to one read-only zero page
    * (2) page fault
        * check if the user is trying to write to the read-only zero page?
        * create a new writable zero page
        * update the page table
        * restat the instruction

Copy On Write Fork:

* Why CoW Fork? 
    * Shell: fork() -> child: exec()
    * the child just copied the parent address space and then immediately replace it
* How?
    * (1) child's VA maps to parent's PA. change both parent and child PTEs to read-only **and a CoW bit**
    * (2) page fault
        * copy a the page that trigger page fault
        * maps to the new page with read/write
        * restart the instruction
    * (3) free page
        * challenge: not only one process maps to one page
        * when free? reference count = 0

Demand Paging:
    
* Why demand paging? 
    * exec() needs to read data from file
    * read data from file is expensive
    * the binary may larger than the physical memory
* How?
    * If out-of-memory,
        * evict a page
            * which page to evict? Prefer LRU, Non-dirty
                * Why non-dirty?
                    * do not need to write back to the file
                * clock algorithm: https://web.stanford.edu/class/archive/cs/cs111/cs111.1232/lectures/25/Lecture25.pdf
        * use the just free page
        * restart instruction

Memory Mapped Files:

* Idea: map (part of) file into the user address space so that the user can use load/store instruction to manipulate the file instead of read()/write() system calls
* Why?
    * Avoids explicit data copying between kernel and user space
    * ...
