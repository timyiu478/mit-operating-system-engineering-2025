# Question

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


