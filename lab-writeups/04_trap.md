# Lab: traps

Detail: https://pdos.csail.mit.edu/6.1810/2025/labs/traps.html

# 1. RISC-V assembly

Q. Which registers contain arguments to functions? For example, which register holds 13 in main's call to printf?

The registers a0, a1, a2 contain arguments to functions.

The register a2 holds 12 in main's call to printf.
The register a1 holds f(8)+1 in main's call to printf.
The register a0 holds address of the format string in main's call to printf.

Q. Where is the call to function f in the assembly code for main? Where is the call to g? (Hint: the compiler may inline functions.)

There is no call to f (or to g) in main.

* f(x) was then inlined into main, so the whole expression f(8)+1 was turned into the constant 12.
* There is no call to g because the function f in the assembly code is substituted to the function g's assembly code.

Q. At what address is the function printf located?

Address 0x73e is the function printf located.

Q. Run the following code.

```
unsigned int i = 0x00646c72;
printf("H%x Wo%s", 57616, (char *) &i);
```
      
What is the output? Here's an ASCII table that maps bytes to characters.
The output depends on that fact that the RISC-V is little-endian. If the RISC-V
were instead big-endian what would you set i to in order to yield the same
output? Would you need to change 57616 to a different value?

Here's a description of little- and big-endian and a more whimsical
description.

Output: HE110 World

hex representation of 57616:

```
(gdb) p /x 57616
$1 = 0xe110
```

xv6 is little-endian where the lower signifiant bit is stored in lower memory address:

```
(gdb) p /c 0x00646c72
$4 = 114 'r'
(gdb) p /c 0x00646c
$5 = 108 'l'
(gdb) p /c 0x0064
$6 = 100 'd'
(gdb) p /c 0x00
$7 = 0 '\000'
```

Q. In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen?

```
printf("x=%d y=%d", 3);
```

Assume the program can be complier. 

It will print the value that register a2 holds.

# 2. Backtrace

DEMO: https://docs.google.com/videos/d/1B8hMRi2w194GB9qKZXVOa2tIJDxAm-IeN7xu5j-elhk/play

Tips:

* We are back tracing the kernel stack rather than user stack!
* Stack frame, visually: https://pdos.csail.mit.edu/6.828/2024/lec/l-riscv-cc-slides.pdf

# 3. Alarm

**DEMO:** https://docs.google.com/videos/d/1UIaA-eDPuJf5uu1zyKBF97c9nKmaU8a_d1nFiEQAVP4/play

Related source code: 

The core idea of invoke handler and resume interrupt code:

When a process's alarm interval expires:

1. We save the current trapframe (the complete user state at the moment the timer interrupt occurred) into p->saved_trapframe. This allows us to restore the original user context later.
2. We redirect execution to the user-defined handler by setting trapframe->epc = p->alarm_handler.

When the user alarm handler finishes and calls the sigreturn() system call, sys_sigreturn() is invoked. This function re-arm the alarm by setting p->ticks = 0. Also, It copies the saved_trapframe back into the current trapframe. As a result, when the system call returns **(via the normal syscall return path)**, the process resumes exactly at the instruction where it was originally interrupted by the timer.

To prevent sys_sigreturn() from overwriting the original value in a0 (which the interrupted user code may be using), sys_sigreturn() returns the value that was in trapframe->a0 at the time the alarm fired (i.e., the saved a0).

Implementation Challenges:

* resume interrupted code

Tips:

* The definition of tick: one hardware timer interrupt rather than raw CPU clock time.
* We call the user-level interrupt handler in user mode because if we call the hanlder in kernel mode,
    * the handler now can use the privilege instructions which can break the system isolation.
    * wrong page table: the user’s handler function lives at a user virtual address.
