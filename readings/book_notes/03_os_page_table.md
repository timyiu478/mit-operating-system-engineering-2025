# Notes

## Device register

Q. Page 35 says "The kernel maps all physical RAM and device registers at virtual addresses equal to the physical addresses". What is device register?

Device registers are small pieces of memory inside hardware devices (e.g. interrupt devices) that the CPU uses to control, configure, and communicate with that device.

They live at the physical addresses that are chosen by the board (designer).

These addresses are outside normal RAM.

## kernel virtual addresses that aren’t direct-mapped

* The trampoline page.
    * Why? allow each user process maps to the code that switch the satp register to kernel page table?
* The kernel stack pages.
    * Why? easy to provide guard pages?


---

# Exercises

1. Parse RISC-V’s device tree to find the amount of physical memory the computer has.

2. The functions copyin and copyinstr walk the user page table in software. Set up

the kernel page table so that the kernel has the user program mapped, and copyin and

copyinstr can use memcpy to copy system call arguments into kernel space, relying on

the hardware to do the page table walk.

3. Modify xv6 to use super pages for the kernel.

4. Unix implementations of exec traditionally include special handling for shell scripts. If the

file to execute begins with the text #!, then the first line is taken to be a program to run to

interpret the file. For example, if exec is called to run myprog arg1 and myprog ’s first

line is #!/interp, then exec runs /interp with command line /interp myprog arg1.

Implement support for this convention in xv6.

5. Implement address space layout randomization for the kernel.

