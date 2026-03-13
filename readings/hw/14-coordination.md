# Question

For this lecture, read the code for sleep() and wakeup() in kernel/proc.c;
uartwrite() and uartintr() in kernel/uart.c; and all of kernel/pipe.c.

Look for this line in uartwrite() and comment it out:

    sleep(&tx_chan, &tx_lock);

Start xv6 with make qemu. What goes wrong? Why?

You will likely find gdb helpful.


Optional challenge: can you modify uartwrite() to work better (perhaps continue
for a few more characters of output), without calling sleep()?

You may find Chapter 9 of the book useful in understanding sleep and wakeup.

# Answer
