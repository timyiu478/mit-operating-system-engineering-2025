## Question

For this lecture, read the following files in the xv6 kernel implementation:

kernel/proc.h
kernel/defs.h
kernel/entry.S
kernel/main.c
user/init.c
and also skim the implementation of processes in the following files:

kernel/proc.c
kernel/exec.c

Suppose that an xv6 kernel has used up all of the struct proc entries in the struct proc proc[NPROC] table (i.e., none of them have state == UNUSED). What happens if one of the processes calls exec()? What happens if one of the processes calls fork()? What happens if one of the processes calls kill() on an existing PID and then calls fork()?

You may find chapter 2 of the book useful in understanding the overall kernel structure and what a process implementation looks like.

## Answer

If one of the processes calls exec(), The call succeeds (assuming sufficient free memory is available for the new program image). exec() replaces the memory contents (text, data, BSS, stack, etc.) of the calling process with the new executable. It reuses the samestruct proc entry (same PID), so it does not require or consume an additional process slot. The process table remains completely full after the call.


If one of the processes calls fork(), the call fails. fork() invokes allocproc() to find a free process entry. Since none exist (allocproc() returns 0), fork() returns -1 to the user program, indicating failure due to no available process slots. No child process is created.


If a process calls kill() on an existing PID and then calls fork():

* kill() sets the target process’s p->killed = 1. If the target is sleeping, kill() also wakes it (changes its state to RUNNABLE) so it can notice the kill signal soon.
* The next time the killed process traps from user mode to kernel mode (e.g., due to a timer interrupt, syscall, or page fault), usertrap() checks p->killed. If set, it calls exit(-1).
* exit() cleans up the process (closes files, frees memory regions, etc.), sets its state to ZOMBIE, notifies the parent (via wakeup), and calls sched() to yield to the scheduler.
* The process slot remains occupied in the ZOMBIE state until the parent (or init) calls wait() on that PID. Only then does wait() call freeproc(), which resets the entry to state = UNUSED.
* Therefore, a subsequent fork() by any process still fails (returns -1) because the table remains full — the killed process is now a zombie and its slot is not yet reclaimed.
