# Lab: locks

## Details

See https://pdos.csail.mit.edu/6.1810/2025/labs/lock.html

## DEMOs

* **Memory Allocator**: https://docs.google.com/videos/d/1nqKO5dCQvafiNflgtpFhGSSCptKCaKYIjx2J97hxvUU/play  
* **Read-write Lock**: https://docs.google.com/videos/d/1cyuTFfBWgDwrvBmMQO1r3vYfVis2WJuItwntMxZCHBc/play

## Memory Allocator

### Related Source Code

* [kalloc.c](https://github.com/timyiu478/mit-operating-system-engineering-2025/blob/3c51af4168cbfc21f32b19ceb6e4406f7d620a88/xv6-labs-2025/kernel/kalloc.c)

### Mistakes I made

#### Deadlock

If both two CPU free lists have no memory, and they try to steal memory from each other, the following code will cause **deadlock**:

```c
acquire(&kmems[cid].lock);
r = kmems[cid].freelist;
if(r)
  kmems[cid].freelist = r->next;
else { // steal free page from other CPU's free-list
  for (int i=0; i < NCPU; i++) {
    if (i == cid)
      continue;
    acquire(&kmems[i].lock);
    r = kmems[i].freelist;
    if(r)
      kmems[i].freelist = r->next;
    release(&kmems[i].lock);
    if(r)
      break;
  }
}
release(&kmems[cid].lock);
```

## Read-write Spinlock

Implementation reference: https://joeduffyblog.com/2009/01/29/a-singleword-readerwriter-spin-lock/

### Related Source Code

https://github.com/timyiu478/mit-operating-system-engineering-2025/commit/ab5be3317d0f4a558b5d451c8a68b8c8f0e8e573#diff-03856391f98d43b0a2cb65739196f429f02d3404f5bca94e81597a30ca0ed3b6

### Design Choices

* Memory Model of all atomic operation is `__ATOMIC_SEQ_CST`: enforces total ordering with all other __ATOMIC_SEQ_CST operations.
* In `rwlock` struct, use one `state` variable to pack 3 information: writer active flag, writer pending flag, and number of readers

### Key Challenges for me

* How to prevent reader sneaked ahead of waiting writer
    * To solve this challenge, we have to make sure when there is at least one pending writer, the writer-active flag and the writer-pending flag are NOT both equal to 0

### Possible operations that can change the state

Invariant: when there is at least one pending writer, the writer-active flag and the writer-pending flag are NOT both equal to 0

* <=: assign value to variable

| Operation                              | Who calls it          | Effect on flags & pending_writers count                                      | Does invariant still hold after? |
|----------------------------------------|-----------------------|-------------------------------------------------------------------------------|----------------------------------|
| Reader acquire (successful)            | any reader            | reader count += 1, flags unchanged                                            | Yes (pending_writers unchanged)  |
| Reader release                         | any reader            | reader count -= 1, flags unchanged                                            | Yes                              |
| First writer announces interest        | a writer              | PENDING_BIT <= 1 (via fetch_or)                                               | Yes — PENDING_BIT = 1            |
| Subsequent writers announce            | another writer        | PENDING_BIT <= 1 
| Writer spins (waiting for readers=0)   | waiting writer        | no change to state or pending count                                           | Yes                              |
| A writer successfully claims lock      | one waiting writer    | WRITER_BIT <= 1 and PENDING_BIT <= 0 <br>pending_writers -= 1 for this writer  | Yes — WRITER_BIT = 1             |
| Writer releases lock                   | holding writer        | WRITER_BIT <= 0<br>pending_writers unchanged (others still pending)           | Yes — **if pending_writers >= 1 then PENDING_BIT was already 1 and stays 1** |

## Key takeaways

* A single-word reader/writer spin lock
