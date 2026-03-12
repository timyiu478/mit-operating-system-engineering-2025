# Notes



# Exercises
 
## 2. Suppose that you instead commented out the locking in kfree (after restoring locking in kalloc). What might now go wrong? Is lack of locks in kfree less harmful than in kalloc?

what might go wrong: 

* some of the free pages can be lost because of the following sequence of instruction execution:

```
r->next = kmem.freelist; // core 1
r->next = kmem.freelist; // core 2
kmem.freelist = r;       // core 1
kmem.freelist = r;       // core 2
```

* the kalloc() instructions and kfree() instructions can run concurrently.

```

Free Page->Free Page->Free Page
^     ^
|     |
|     kalloc()
|
Kfree()
```


running usertests:

```
test reparent2: scause=0xd sepc=0x80000110 stval=0xe4a6e8a2ec86711d
panic: kerneltrap
```

## 3. If two CPUs call kalloc at the same time, one will have to wait for the other, which is bad for performance. Modify kalloc.c to have more parallelism, so that simultaneous calls to kalloc from different CPUs can proceed without waiting for each other.
