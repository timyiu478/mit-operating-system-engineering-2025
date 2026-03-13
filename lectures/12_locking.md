Q. Why multicore?

* can have parallelism
* no improvement on processor frequency => no performance improvement on single core performance

Q. When to lock?

* Conservative: >= 2 processes access a shared data structure

Q. Any problem of the following auto locking implementation?

* rename(d1/x, d2/y);
    * (1) lock d1; erase x; release d1;
    * (2) lock d2; erase y; release d2;

The problem is another process can observe the file does not exist if it look
at the point that step (1) is finished and before step (2) is executed.

This probably related the design of 2 phrase locking?

* Growing phase: acquire all locks you will ever need (here: both d1 and d2).
* Shrinking phase: only after that, release locks. No new locks may be acquired after the first release.

Lock Perspectives:

* avoid lost update
* make multiple steps operation atomic
* maintain invariants
    * e.g.
        * total money in the system remains constant
        * uart.c: no two processes write to the same empty slot
        

Lock Tensions:

* avoid deadlock => may requires global lock acquisition ordering => break module abstraction of the use of locks
* want to improve performance => reduce contention of the lock => split the data structure => best split is a challenge

Q. Why does acquire() function need to turn off interrupt?

what if device interrupt, and interrupt handler needs the same lock? Deadlock!

__sync_synchronize(): 

* prevents re-order by telling CPU and C compile do not move instructions past to __sync_synchronize()
* example usecase:
    1. acquired lock
    2. __sync_synchronize()
    3. criticial section
    4. __sync_synchronize()
    5. release lock
* (2) ensures the instructions in critical section are all executed after lock is acquired / lock acquisition instructions must run before critical section instructions
* (4) ensures the instructions in critical section are all executed before lock is released
