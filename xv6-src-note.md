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

---

# fs.c

function naming conventions:

* iget: inode get => find/create a cached inode, ref++
* iput: inode put/**release** => ref--/clean cached inode
* idup: inode duplicate => ref++

---

# fs.c

The comments right after pipe, ip, off, and major are telling when these feilds are meaningful.
E.g. file->off is meaningful if file tpye is FD_INODE.

```c
  1 struct file {
  2 enum { FD_NONE, FD_PIPE, FD_INODE, FD_DEVICE } type;
  3 int ref; // reference count
  4 char readable;
  5 char writable;
  6 struct pipe *pipe; // FD_PIPE
  7 struct inode *ip; // FD_INODE and FD_DEVICE
  8 uint off; // FD_INODE
  9 short major; // FD_DEVICE
 10 };
```

---

# log.c

log block vs cache block:

* log.lh.block[tail] is a pointer points to the block number given by log_write() function. It lives data region on disk.
* log.start is the log block number
    * we can see this value is initialised as sb->logstart in line 60
 

```c
 53 void
 54 initlog(int dev, struct superblock *sb)
 55 {
 56   if (sizeof(struct logheader) >= BSIZE)
 57     panic("initlog: too big logheader");
 58
 59   initlock(&log.lock, "log");
 60   log.start = sb->logstart;
 61   log.dev = dev;
 62   recover_from_log();
 63 }
...
...
178 // Copy modified blocks from cache to log.
179 static void
180 write_log(void)
181 {
182   int tail;
183
184   for (tail = 0; tail < log.lh.n; tail++) {
185     struct buf *to = bread(log.dev, log.start+tail+1); // log block
186     struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
187     memmove(to->data, from->data, BSIZE);
188     bwrite(to);  // write the log
189     brelse(from);
190     brelse(to);
191   }
192 }
```

