# Question

For this lecture, read the following files in the xv6 kernel implementation:

* kernel/console.c
* kernel/uart.c
* kernel/kernelvec.S

Look for the line

```
tx_busy = 0;
```

in uartintr() in kernel/uart.c. Delete that line. Run the kernel with make
qemu. What happens? Why?

You may find Chapter 6 of the book useful in understanding interrupts and
device drivers.

# Answer
