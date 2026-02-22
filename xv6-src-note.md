# entry.S

Q. Is the `stack0` only used in the machine mode?


---

# proc.h

* context.ra: the return address (RA register value) saved in the process's kernel context structure

* p->sz:
    * growproc() ensure that the size sz cant grow larger than TRAPFRAME: https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/proc.c#L244-L246
    * initial size is https://github.com/mit-pdos/xv6-riscv/blob/riscv/kernel/exec.c#L89-L91

---

# proc.c

wfi: wait for interrupt


---

# boot call chain

How to invoke the first user process (init):

```
QEMU → _entry (entry.S, asm, machine mode)
       ↓ (call)
     start() (start.c, C, machine mode)
       ↓ (sets mepc = main, then mret)
     main() (main.c, C, supervisor mode)
       ↓
     userinit() (proc.c) 
        => allocaproc() => forkret() 
                             => kexec("/init")
```

* The kernel code, data, and initial stack must already be located at the correct physical memory addresses before the paging is enabled.

---

# vm.c

kvminithart():

* why calling sfence_vma() can wait for previous writes to page table memory to finish?
* each CPU has its own satp register? Yes
