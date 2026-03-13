# Notes

Invarients of linked list:

* list points to the first element of the list
* each element's next field points to the next element of the list


Locks in xv6:

* coarse-grained:
    * free-list: one lock for all CPUs
* fine-grained:
    * file lock: lock per file
* others: see Figure 7.3

An example to show why CPU never hold the lock with interrupts enabled:

syspause(): acquired ticklock -> clock interrupt: acquire(&ticklock)

Xv6 re-enables interrupts when a CPU holds no spinlocks => need to keep track
of # of nested locks are acquired:

https://github.com/mit-pdos/xv6-riscv/blob/riscv//kernel/spinlock.c#L84-L113


# Exercises

## 1. Comment out the calls to acquire and release in kalloc (3027). This seems like it should cause problems for kernel code that calls kalloc; what symptoms do you expect to see? When you run xv6, do you see these symptoms? How about when running usertests?  If you don’t see a problem, why not? See if you can provoke a problem by inserting dummy loops into the critical section of kalloc.

Expect:

* allocate the same free page more than once 
    * cause double free
    * or use after free

running usertests: 

```
test lazy_unmap: usertrap(): unexpected scause 0xf pid=6579
            sepc=0x45dc stval=0x12000
usertrap(): unexpected scause 0xf pid=6580
            sepc=0x45dc stval=0x1012000
usertrap(): unexpected scause 0xf pid=6581
            sepc=0x45dc stval=0x2012000
usertrap(): unexpected scause 0xf pid=6582
            sepc=0x45dc stval=0x3012000
usertrap(): unexpected scause 0xf pid=6583
            sepc=0x45dc stval=0x4012000
usertrap(): unexpected scause 0xf pid=6584
            sepc=0x45dc stval=0x5012000
usertrap(): unexpected scause 0xf pid=6585
            sepc=0x45dc stval=0x6012000
```
 
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
