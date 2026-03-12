# An xv6 device driver for a network interface card (NIC)

## Lab details

See https://pdos.csail.mit.edu/6.1810/2025/labs/net.html

## DEMO

Watch https://docs.google.com/videos/d/1aX9uGzmhp_Qd23MEbY2lsk_VeZzW9JcC_lz2VPPoaJo/play

## Related Source Code

* [e1000.c]()
* [net.c]()
* [proc.h]()
* [proc.c]()

## Mistakes I made

* I forgot to use `ntohs()` to re-arrange the bytes of `inudp->dport` in `ip_rx()` function.
* The pointer arugments in `sys_recv()` is user virtual addresses. Assigning the values into them via direct address dereferencing is wrong. We should use `copyout()` to copy them from the kernel to the current user process.
* I thought the child does not inherit the parent's binded ports by fork(). I can find this wrong assumption because I failed the ping3() test case defined in `nettest.c` and I looked the source code of ping3().

## Design Choices

* Each port has its own ring buffer `port2Ring[port]` and we use `port2Ring[port].r` as the process's sleep channel when the process calls  `sys_recv()` and the receive queue is empty. This allows us to wake up the only correct process when the packet with `dport=port` has arrived. 
* To support binded ports inheritance, the field `int  bindedports[MAXBPORTS]` is added in the `struct proc`.

## Questions I had when I was working on this lab

Q. How can the e1000 know which rx descriptor is the first unused?

It uses the head pointer of the ring structure.

As packets arrive, they are stored in memory and the head pointer is **incremented by hardware**.

Ref: section 3.2.6 of E1000 Software Developer's Manual

