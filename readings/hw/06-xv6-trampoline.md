# Question

For this lecture, read the following files in the xv6 kernel implementation:

- kernel/riscv.h
- kernel/trampoline.S
- kernel/trap.c

Build the xv6 kernel:

```
$ make kernel/kernel 
```

Open the file kernel/kernel.asm, and look for the line _trampoline, which is where the file trampoline.S is loaded. You will find at address 80006092 the instruction that loads the kernel page table (the exact addresses may be different ):

```
0000000080006000 <_trampoline>:
    80006000:   14051073                csrw    sscratch,a0
        ...
	...
    80006092:   18031073                csrw    satp,t1
    80006096:   12000073                sfence.vma
        ...
```

After the CPU executes csrw satp, t1, the CPU will translate 0x80006096, which holds the next instruction, using the kernel page table (t1 holds the address of the kernel page table; see trampoline.S). How come that this address 0x80006096 in both the user and the kernel page table translates to a physical address that holds sfence.vma?
You may find chapter 4 of the book useful in understanding how transition between user space and kernel space on a RISC-V CPU.

# Answer

The reason why the address 0x80006096 in both the user and the kernel page table translates to a physical address that holds sfence.vma is this address is in the trampoline page and the virtual-to-physical mapping for the trampoline virtual address is identical in both user and kernel page tables.
