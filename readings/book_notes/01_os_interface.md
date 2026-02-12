## Notes

1. How does the kernel use the hardware protection mechanisms provided by CPU? Why can't the user program raise the hardware privilege and then access the hardware directly?

User => Kernel: No direct instruction exists to change the protection register. Only through hardware trap gates (syscall, interrupt, exception) => CPU enforces the switch
Kernel => User: Kernel uses privileged return instructions (sysret, iret, eret) => CPU allows lowering privilege because the code is already trusted (running in Ring 0)

2. How to avoid the wastefulness of duplicate a process and then immediately replace it?

```
fork()
exec()
```

Optimize the `fork()` implementation using *copy-op-write* (See xv6 book section 5)

3. How to call system calls?

(1) put arugments and the syscall index number into some registers.
(2) call CPU instruction `syscall`.

=> not normal function calls!

Slide 15: https://www.cs.cornell.edu/courses/cs3410/2018fa/schedule/slides/14-ecf.pdf

4. Where does OS live?

OS lives in the same address space as the user process => no context switch!

Slide 19, 24: https://www.cs.cornell.edu/courses/cs3410/2018fa/schedule/slides/14-ecf.pdf

5. Processes cannot fetch and execute OS code in user mode because:

(1) All memory accesses (when paging is enabled) go through the MMU.
(2) The MMU translates virtual addresses to physical addresses via page-table lookup.
(3) Kernel/OS code resides in pages marked supervisor-only (U/S = 0 in the PTE).
(4) The MMU denies access to supervisor-only pages when the CPU is in user mode, triggering a page fault.

Slide 22: https://www.cs.cornell.edu/courses/cs3410/2018fa/schedule/slides/14-ecf.pdf

6. Pipeline vs Temporary File

(1) Pipeline is automatically cleanup
(2) Pipeline can support arbitrary long streams of data
(3) Pipeline can support parrallel execution of pipe stages

---

## Exercise

Write a program that uses UNIX system calls to “ping-pong” a byte between two processes over a pair of pipes, one for each direction. Measure the program’s performance, in exchanges per second.


source code: [pingpong.c](/Users/timyiu/operating-system-engineering/exercises/pingpong.c)

```
❯ gcc pingpong.c
❯ time ./a.out
pg./a.out  0.05s user 0.03s system 17% cpu 0.452 total
```
