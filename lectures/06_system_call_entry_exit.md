Registers:

* STVEC: Supervisor Trap Vector Base Address Register
    * holds the base address of the trap vector table for supervisor-mode traps (exceptions and interrupts)
    * e.g. ecall -> set STVEC to the address of trampoline
* SEPC: Supervisor Exception Program Counter
    * This register captures the program counter (PC) of the instruction that caused or was interrupted by a trap taken into S-mode.
    * After handling the trap, software can use an SRET instruction to return to the address in SEPC.
* SSCRATCH: Supervisor Scratch Register
    * It is a general-purpose scratch register available to supervisor-mode trap handlers. 
    * In user mode, $sscratch stores the address of trapframe

What are the privileges we gain from supervisor mode?

1. read and write control registers e.g. SATP, STVEC
2. use PTE that is supervisor-only or withour user-mode flag

What are things ecall does?

1. change mode from user to supervisor
2. save the programming counter

```
(gdb) p /x $sepc
$7 = 0xcaa
(gdb) p /x $pc
$8 = 0x3ffffff00 // we are in kernel mode since this address is not supervisor-only
```

3. change the STVEC register
4. jump to the instruction tat STVEC points to

Why not ecall do more e.g. save user registers, change page table register?

risc-v designers want to allow maximum flexibility e.g. 

* some system calls might not need to switch page table register.
* different system calls might need to save different registers but NOT ALL.


The challenges of system entry:

1. We don't know the address of the kernel page table
2. We needs some spare registers to switch page tables

sol: use trapframe page

Why does the kernel not store the user registers in the user stack?

The kernel does not sure about whether the user program has a stack or no idea about how to use the stack.

In trap.c line 52, why we need to store the user program counter into trapframe when we stored the user program counter in $sepc?

We might switch to another process p2 and p2 might trigger a system call such the ecall will overwrite $sepc.

What are things sret does?

1. switch mode from kernel to user
2. copy $sepc to $pc
3. enable interrupt
