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

* [spinlock.c](https://github.com/timyiu478/mit-operating-system-engineering-2025/blob/3c51af4168cbfc21f32b19ceb6e4406f7d620a88/xv6-labs-2025/kernel/spinlock.c)

### Design Choices

* Memory Model of all atomic operation is `__ATOMIC_SEQ_CST`: enforces total ordering with all other __ATOMIC_SEQ_CST operations.
* In `rwlock` struct, use one `state` variable to pack 3 information: writer active flag, writer pending flag, and number of readers

### Key Challenges for me

* How to prevent reader sneaked ahead of waiting writer

## Key takeaways

* A single-word reader/writer spin lock
