# Lab: system calls

In the last lab you used system calls to write a few utilities. In this lab you will add a new system call to xv6, which will help you understand how they work and will expose you to some of the internals of the xv6 kernel. You will add more system calls in later labs.

Lab detail: https://pdos.csail.mit.edu/6.1810/2025/labs/syscall.html

# Using GDB

Q. Looking at the backtrace output, which function called syscall?

The usertrap function called syscall.

```
(gdb) bt
#0  syscall () at kernel/syscall.c:133
#1  0x0000000080001ac2 in usertrap () at kernel/trap.c:68
#2  0x0000003ffffff09c in ?? ()
```

Q. What is the value of p->trapframe->a7 and what does that value represent? (Hint: look at user/init.c, the first user program xv6 starts, and its compiled assembly user/init.asm.)

The value is 0xf. It represent the syscall number of `open` according to [kernel/syscall.h](../xv6-labs-2025/kernel/syscall.h) and the first instruction of [user/init.c](../xv6-labs-2025/user/init.c).

```
(gdb) p /x p->trapframe->a7
#3 0xf
```

Q. What was the previous mode that the CPU was in?

```
(gdb) p /x $sstatus
#4 0x200000022
```

The SPP bit indicates the privilege level at which a hart was executing before entering supervisor mode. When a trap is taken, SPP is set to 0 if the trap originated from user mode, or 1 otherwise.

According to the [figure 4.2 of RISC-V priviledged instructions document](../reading/riscv-privileged-20211203.pdf#page=76.72), the index 8 of $sstatus stores SPP bit.

The gdb command shows the SPP bit is 0. So the CPU was in user mode.

Q. Write down the assembly instruction the kernel is panicing at. Which register corresponds to the variable num?

1. replace the statement num = p->trapframe->a7; with num = * (int *) 0;

2. run `make qemu`:

```
xv6 kernel is booting

hart 2 starting
hart 1 starting
scause=0xd sepc=0x80001d30 stval=0x0
panic: kerneltrap
```

3. search for the sepc value printed for the panic you just saw in the file kernel/kernel.asm

register: a4

```
❯ grep 80001d30 kernel/kernel.asm
    80001d30:	00002703          	lw	a4,0(zero) # 0 <_entry-0x80000000>
```

4. fire up gdb, set a breakpoint at the faulting epca, and confirm that the faulting assembly instruction is the same as the one you found above

I confirmed the faulting assembly instruction is the same as the one I found above.

Q. Why does the kernel crash? Hint: look at figure 3-3 in the text; is address 0 mapped in the kernel address space? Is that confirmed by the value in scause above? (See description of scause in RISC-V privileged instructions)

Address 0 is NOT mapped in the kernel address space. The kernel base address is 0x80000000.

The scause register value is 0xd. This represents *Load page fault* according to [table 4.2 of RISC-V priviledged instructions document](../reading/riscv-privileged-20211203.pdf).

Q. What is the name of the process that was running when the kernel paniced? What is its process id (pid)?

The process name is init and its pid is 1.
 
```
(gdb) p p->name
$1 = "init", '\000' <repeats 11 times>
(gdb) p p->pid
$1 = 1
```

# Sandbox with allowed pathnames

Demo: https://docs.google.com/videos/d/1y_22WZ1cB6Vaj-srdaV-my1rE7fOQr_PspA2xnxB700/play

Implementation Tips:

* How to check if the system call must be rejected: `p->mask & (1 << num)) > 0`.
* The kernel has a string library.

Test results:

```
== Test sandbox_mask ==
$ make qemu-gdb
sandbox_mask: OK (10.4s)
== Test sandbox_fork ==
$ make qemu-gdb
sandbox_fork: OK (0.8s)
== Test sandbox_path ==
$ make qemu-gdb
sandbox_path: OK (1.4s)
== Test sandbox_most ==
$ make qemu-gdb
sandbox_most: OK (0.7s)
== Test sandbox_minus ==
$ make qemu-gdb
sandbox_minus: OK (0.9s)
```


# Attack xv6

Demo: https://docs.google.com/videos/d/1RM-QBXFb2dKL8EyWxIAYm7EyVEgNBfcvU490IFMP5GE/play

Test results:

```
❯ ./grade-lab-syscall attack
make: `kernel/kernel' is up to date.
== Test attack == attack: OK (1.8s)
```

# Key takeways

* the syscall execution path
