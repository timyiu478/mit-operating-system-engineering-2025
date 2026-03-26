# Note: Scheduling

Q. Where does swtch(X, Y)'s ret return to?

The return address of the loaded Y context, which is the address after the last call swtch() by Y.

Q. Why not directly switch from process A to process B? Why do we need a scheduler thread?

It is possible there is a situation that no process currently wants to run on CPU.
The process A swtich to nowhere if we don't have a scheduler thread.

Q. How to prevent schedule the same process on different CPUs?

1. The scheluder acquires the p->lock for each iteration of the loop of finding RUNNABLE process
and change it to RUNNING. 

https://github.com/mit-pdos/xv6-riscv/blob/riscv//kernel/proc.c#L441-L446

2. the process A who wants to give up the CPU will acquire the lock before calling swtch
    * See Figure 8.2
    * make sure process A thread releases the lock after scheduler is completey running
    * prevent race condition of one CPU c is saving CPU registers of A and
      another CPU c' is loading A context into CPU registers since it observes A is RUNNABLE and selects to run it
        * c' restores partially-saved registers
        * both CPU c and c' share the same stack (before c loads the stack pointer scheduler thread)
