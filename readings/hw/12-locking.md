# Question

For this lecture, read the following files in the xv6 kernel implementation:

* kernel/spinlock.h
* kernel/spinlock.c

You may find Chapter 7 of the book useful in understanding locking.

In kernel/spinlock.c, comment out or delete these lines in acquire():

```
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    ;
```

and replace them with

```
  while(*(volatile int *) &lk->locked != 0)
    ;
  lk->locked = 1;
```

Use gdb to help explore the result when you boot xv6 and run a few commands, or run usertests. You may have to boot a few times to see a problem. What goes wrong? Why?

# Answer

## Why goes wrong?

The kernel panics with "panic: release" (from release() in spinlock.c), because a CPU attempts to release a spinlock that it does not own according to the debug metadata (lk->cpu != mycpu()).

```
xv6 kernel is booting

hart 1 starting
panic: release
```

## Why does this happen?

The modified acquire() is not atomic:

```
while(*(volatile int *) &lk->locked != 0)
  ;
lk->locked = 1;
```

It is possible that more than one process on different CPUs see `lk->locked == 0` such that they can leave the while loop `while(*(volatile int *) &lk->locked != 0)`. 

Then more than one process can access the critical section and the last one who call `lk->cpu = mycpu();` is the one who own the lock from kernel perspective. It can call release() without panic.

## GDB

The gdb shows a kernel process in one CPU tried to release a lock that was released (by another process in another CPU).

```
(gdb) p lk->cpu
$20 = (struct cpu *) 0x0
(gdb) p lk->locked
$21 = 0
(gdb) where
#0  holding (lk=lk@entry=0x80009600 <proc+1824>) at kernel/spinlock.c:339
#1  0x00000000800066ec in release (lk=lk@entry=0x80009600 <proc+1824>) at kernel/spinlock.c:101
#2  0x00000000800012e6 in scheduler () at kernel/proc.c:466
#3  0x000000008000035a in main () at kernel/main.c:57
```
