# operating-system-engineering

Design and implementation of operating systems, and their use as a foundation for systems programming. Topics include virtual memory; file systems; threads; context switches; kernels; interrupts; system calls; interprocess communication; coordination, and interaction between software and hardware. 

# Hands-On Programming Projects

> [!IMPORTANT]
> The code here is offered as a learning aid to help you build intuition and see one possible way of solving the problem. Readers are strongly encouraged to engage actively with the material and develop their own independent implementations.

My completed projects at a glance:

1. Xv6 and Unix utilities - [demo](lab-writeups/01_utilities.md)
2. System calls - [demo](lab-writeups/02_sys_calls.md)
3. Page tables - [demo](lab-writeups/03_page_tables.md)
4. User-level interrupt/fault handlers - [demo](lab-writeups/04_trap.md)
5. Copy-on-Write Fork - [demo](lab-writeups/05_cow.md)
6. Network Driver - [demo](lab-writeups/06_net_driver.md)
7. Per-CPU freelists & Read-write lock - [demo](lab-writeups/07_locks.md)
8. File System - [demo](lab-writeups/08_file_system.md)

# Key Takeaways

* The combination of page table and page fault handling is powerful. It can be used to build many virtual memory features, such as lazy allocation, copy-on-write fork, and on-demand paging.
* In xv6, swtch() never returns to its caller's next instruction in the old thread — instead, by restoring the target thread's saved return address (ra) and executing ret, it resumes right after the point where that thread last called swtch() to give up the CPU.
* The xv6 logging system design and implementation:
    * The logheader.block[] array encodes three key pieces of information for each logged block: redo order, location of the logged (new) data, and destination (home location) on disk
    * To clean the log, we only have to zero out the count field of the log header block. No real pruning!
    * Implementation challeges: buffer eviction, file operation must fits in the log, and concurrent fs calls
