* We can view xv6 kernel as a multi-core parallel shared memory program.
    * each user process has its own kernel thread

* Thread:
    * one serial execution
    * state: pc, registers, stack

* Lecture Goal: How to build thread switch system

* Kinds of thread:
    * shared memory?
        * one way to distinguish process and thread
        * e.g.
            * share memory: xv6, linux user process (can be allowed)
            * NOT share memory: xv6's user process

* Other ways to share the same CPU for many tasks:
    * event-driven programming

* Thread swtich system challenges:
    * which process should switch to? scheduling
    * What states should we save and restore?
    * when to switch?
        * user process actively tell the scheduler that is can be switched
        * compute-bound process

* How to distinguish a process that can run on CPU but is not running and a process that does not want to be scheduled?
    * process state: RUNNABLE vs SLEEPING

* What things are process context stored for thread switching? 
    * kernel's CPU state: return address, general registers
    * check proc.h
    * Why do not store in trapframe?
        * Simplify/Clarity: trapframe is used to store things that only for mode switch

* Where is the scheduler context stored?
    * cpu->context => per CPU instead of per-process
    * check proc.h

* What is the meaning of context switch?
    * P1 kernel context -> scheduler context -> P1/P2 kernel context
    * switch function: swtch.S

* In swtch.S, why does it not store the program counter?
    * the program counter has no actual information
    * the program counter is about the swtch function
    * **what we care about is the return address (the caller of swtch(): the instruction immediately after calling swtch())**

* In swtch.S, why does it only store 14 registers?
    * swtch() called as a C function call 
    * the C compiler will help to store the caller saved registers.
