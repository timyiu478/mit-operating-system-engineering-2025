Challenge: crash can lead to on-disk file system to incorrect state

* Why? FS operation is multi-steps operation in disk level
* Does it matter? What are the risks?   
    * Lose inode
    * Lose data block

Lose inode case:

* inode does not appear in any directory => can't find/delete it
* Can we switch the order of 3. and 2. to solve the problem?
    * No. The inode was not initialised/marked as used.
    * It is possible two users/files share the same inode.

```
$ echo "hi" > x
// open file
write: 33 // 1. allocate inode for x
write: 33 // 2. init inode for x
<-------------------------------------- power failure
write: 46 // 3. record x in / directory's data block
write: 32 // 4. update root inode
write: 33 // 5. update inode x
```

Lose data block/Share data block case:

* what if we move 4. before 1. and power failure before 1.?
    * two or more inodes shares the same inode

```
// write "hi" to file x
write: 45  // 1. set alloc bit in bitmap block
<-------------------------------------- power failure
write: 595 // 2. write h to allocated data block
write: 595 // 3. write i to allocated data block
write: 33  // 4. size update, bn0
```

Solution: Logging

* Properties: atomic, fast recovery, high performance

* Scheme: 
    * log write
    * commit op
    * install
    * clean log

Why this scheme is good?

* this scheme requires the operation is idempotent
* and read/write operation is idempotent

```
log write
<-------------------------------------- power failure => do nothing
commit op
<-------------------------------------- power failure => install after reboot
install
<-------------------------------------- power failure => re-install after reboot
clean log
<-------------------------------------- power failure => do nothing
```

Commit Point:

```c
100 // Write in-memory log header to disk.
101 // This is the true point at which the
102 // current transaction commits.
103 static void
104 write_head(void)
105 {
106   struct buf *buf = bread(log.dev, log.start);
107   struct logheader *hb = (struct logheader *) (buf->data);
108   int i;
109   hb->n = log.lh.n;
110   for (i = 0; i < log.lh.n; i++) {
111     hb->block[i] = log.lh.block[i];
112   }
113   bwrite(buf);
// <---------------------- Here: Commit Point
114   brelse(buf);
115 }
```

xv6 logging is low performance: 

* it write data twice

Chllenges:

* buffer eviction:
    * when a buffer evicts, it will write to its home location
        * if a crash happens before other operations of the same transaction is completed, the atomicity will be broken
    * solution: don't evict the buffers that are in log/transaction => implementation: use [bpin()](https://github.com/timyiu478/mit-operating-system-engineering-2025/blob/file-system/xv6-labs-2025/kernel/log.c#L232) to increase the ref count of the buffer to make sure the ref count would be 0 and buffer with > 0 ref count won't be evicted.

* file operation must fits in the log
    * log size is 30
    * at most 30 - 1 block writes
    * what are file operations need many blocks?
        * huge file write
            * implementation: [split the write to multiple write transactions](https://github.com/timyiu478/mit-operating-system-engineering-2025/blob/file-system/xv6-labs-2025/kernel/file.c#L149-L154)
                * its OK since the filewrite() semantic does not gaurantee atomicity
    * concurrent fs calls
        * needs all of them fit in the log
        * only commit when they all are completed
        * solution (group commit): [control number of concurrent transactions](https://github.com/timyiu478/mit-operating-system-engineering-2025/blob/file-system/xv6-labs-2025/kernel/log.c#L134) and [commit when outstanding = 0](https://github.com/timyiu478/mit-operating-system-engineering-2025/blob/file-system/xv6-labs-2025/kernel/log.c#L156) 
