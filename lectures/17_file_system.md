Interesting Points of File system:

* useful abstraction
* crash recovery
* disk layout
* performace: storage devices are slow
    * buffer cache
    * concurrency

API examples:

* fd = open("x/y", ...)
    * "x/y" is human readable filename
* write(fd, "abc", 3)
    * offset is hidden
* link("x/y", "a/b")
    * multiple file names point to the same file


Layer view of File System:

[  names/fds    ]
[  inode        ]
[  icache       ]
[  Logging      ]
[  Buffer Cache ]
[    Disk       ]

Hard Disk Interface for CPU:

* read/write a block number (for write, give the data as well via DMA) => can
  think it as a big array

Sleeplock:

* sleeplock owner can be sleep/yield!
    * because it does not hold a spinlock.

```c
void
acquiresleep(struct sleeplock *lk)
{
    acquire(&lk->lk);                     // protect check + set of locked field

    while (lk->locked)                    // re-check needed because wakeup is broadcast
        sleep(lk, &lk->lk);               // sleep releases lk->lk atomically; one process returns at a time

    lk->locked = 1;                       // now we own it — only one process reaches here
    lk->pid    = myproc()->pid;
    release(&lk->lk);                     // now others can check the (new) locked value
}

void
releasesleep(struct sleeplock *lk)
{
    acquire(&lk->lk);
    lk->locked = 0;                       // release ownership (only the holder does this)
    lk->pid    = 0;
    wakeup(lk);                           // wake all sleepers — they will re-check under lk->lk
    release(&lk->lk);
}
```

Locks:

* to modify, the buffer cache, the process needs to hold bcache.lock
* to modify, the block (buffer/ in-memory) , the process needs to hold b.lock

Invarients of the buffer cache:

* A given block number appears at most once (or exactly once if cached) in the buffer cache.

Buffer cache stores data blocks. inode cache is stored in `itable` (its defined in fs.c):

```c
177 struct {
178   struct spinlock lock;
179   struct inode inode[NINODE];
180 } itable;
181
```
