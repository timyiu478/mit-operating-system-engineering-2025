# Note

Buffer cache: 

* not only for caching disk blocks 
* but also synchronize access to them: only one kernel thread can modify the block
    * how? 
        * each block cache has a lock. the lock acquisition is hidden the bget(). call brelse() to release the lock.
        * at most one cache per disk sector
        * b->refcount protects buffer will not be recycled

mkfs:

* build the initial disk layout: [boot|superblock|log|inode|bitmap|data]
    * by updating the superblock, init inode structure, free bitmapa, creating root directory
* https://github.com/mit-pdos/xv6-riscv/blob/riscv/mkfs/mkfs.c

The advantages of group commit:

* more concurrent file writes

Logging:

* log_write:
    * log absorption: only the last write of the data block is recorded
        * how? allocate that block the same slot in the log
        * https://github.com/mit-pdos/xv6-riscv/blob/riscv//kernel/log.c#L226-L230
    * note: log write order does not matter


# Exercise

## 1. Why panic in balloc? Can xv6 recover?



## 2. Why panic in ialloc? Can xv6 recover?

## 3. Why doesn’t filealloc panic when it runs out of files? Why is this more common and therefore worth handling?

## 4. Suppose the file corresponding to ip gets unlinked by another process between sys_link ’s calls to iunlock(ip) and dirlink. Will the link be created correctly? Why or why not?

## 5. create makes four function calls (one to ialloc and three to dirlink) that it requires to succeed. If any doesn’t, create calls panic. Why is this acceptable? Why can’t any of those four calls fail?

## 6. sys_chdir calls iunlock(ip) before iput(cp->cwd), which might try to lock cp->cwd, yet postponing iunlock(ip) until after the iput would not cause deadlocks. Why not?

