## Notes

Machine mode vs supervisor mode

Figure 2.3: Layout of a process’s virtual address space:

At the top of the address space xv6 places a trampoline page (4096 bytes) and a trapframe page.  Xv6 uses these two pages to transition into the kernel and back; the trampoline page contains the code to transition in and out of the kernel, and the trapframe is where the kernel saves the process’s user registers, as Chapter 4 explains.

Process struct:

* What is kernel stack? A stack for running kernel code when its enter kernel mode
* Why use kernel stack? 
    * a process can "block" in the kernel while k
* What is data page?
* What is sleeping on chan?

```c
struct proc {
  struct spinlock lock;

  // p->lock must be held when using these:
  enum procstate state;        // Process state
  void *chan;                  // If non-zero, sleeping on chan
  int killed;                  // If non-zero, have been killed
  int xstate;                  // Exit status to be returned to parent's wait
  int pid;                     // Process ID

  // wait_lock must be held when using this:
  struct proc *parent;         // Parent process

  // these are private to the process, so p->lock need not be held.
  uint64 kstack;               // Virtual address of kernel stack
  uint64 sz;                   // Size of process memory (bytes)
  pagetable_t pagetable;       // User page table
  struct trapframe *trapframe; // data page for trampoline.S
  struct context context;      // swtch() here to run process
  struct file *ofile[NOFILE];  // Open files
  struct inode *cwd;           // Current directory
  char name[16];               // Process name (debugging)
};
```


---

## Exercises

1. Add a system call to xv6 that returns the amount of free memory available
