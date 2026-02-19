# Question

For this lecture, read the following files in the xv6 kernel implementation:

* kernel/memlayout.h
* kernel/vm.c
* kernel/kalloc.c
* kernel/riscv.h
* kernel/exec.c

In exec.c:loadseg(), the kernel looks up a physical address pa and then directly passes it to readi(), which writes data to that address as if it was a pointer. How is the kernel able to write to physical memory addresses, rather than virtual memory addresses? What line of code allows this to work?

You may find chapter 3 of the book useful in understanding how the kernel uses page tables.

# Answer

The kernel is able to write directly to physical memory addresses (using pa as if it were a normal pointer) because of direct mapping.

This direct mapping is set up in kvminit() (in kernel/vm.c), specifically by the calls to kvmmap() that create identity mappings for physical memory regions.
