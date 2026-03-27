# Sleep and wakeup

Q. Why sleep() needs the conditional lock arugment/not release the lock before calling sleep()?

To prevent the possibility of a wakeup() is executed between the conditional check and the call to sleep.
The possible consequence of this possibility is no one wakeup the sleep (lost wake up).

sleep() will release the conditonal lock only after it acquire the p->lock and p->lock can prevent the execution of wakeup().
=> the going-to-sleep process holds at least 1 lock beforing changing p->state = SLEEPING.

Figure 9.1 shows an example of how do p->lock and conditional lock overlap.

Q. Why is sleep always called inside a loop that re-checks the condition?

1. multiple processes can sleep on the same channel.
2. wakeup() will wake up all of them.
3. The waked up process can make the condition not true again.

kexit, kill and kwait:

* kexit: reparent(p) -> wakeup(p->parent) -> p->state = ZOMBIE -> jump to scheduler thread
    * why wakeup(p->parent) before p->state = ZOMBIE is safe?
        * the parent's cant return from sleep(p, &wait_lk) before child's kexit change p->state to ZOMBIE because child release the wait_lk after the state change.
        * the parent's kwait can't examine the state of its child without acquiring the child process lock
        * child's process lock is released by the scheduler
* kwait: sleep(p, &wait_lk) -> found ZOMBIE -> freeproc(pp)
* kkill: pp->killed = 1 -> pp->state = RUNNABLE (wakeup the process)
    * pp->state = RUNNABLE => scheduler thread will schedule this process => return from sched() => can return from sleep()
    * challenge: sleep are always wrapped in a while loop that re-tests the condition after sleep returns
        * add p->killed in the condition
            * https://github.com/mit-pdos/xv6-riscv/blob/riscv//kernel/pipe.c#L84 
        * atomic operation does not add p->killed in the condition
            * https://github.com/mit-pdos/xv6-riscv/blob/riscv//kernel/virtio_disk.c#L285
    
Read world:

* Linux's sleep uses sleep queue instead of sleep channel
