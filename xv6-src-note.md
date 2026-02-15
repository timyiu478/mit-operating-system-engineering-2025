# entry.S

Q. Is the `stack0` only used in the machine mode?


---

# proc.h

context.ra: the return address (RA register value) saved in the process's kernel context structure

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

