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

Observation: the first user process `init.c` printed the first character `i` on screen and then stopped.

Why? The processes trying to print get permanently blocked in `uartwrite()`.

The `tx_busy` is used to tell `uartwrite()` function whether UART is busy sending.

If we remove `tx_busy = 0` in the `uartintr()` function then `tx_busy` stays = 1 permanently after the first transmit-complete interrupt arrives, because we no longer reset it to 0.

Then the subsequent call of `uartwrite()` will be blocked forever by while loop since `tx_busy != 0` is always true.

```console
(gdb) x/s buf
0x3fffffdeb0:   "n\337\377\377?"
(gdb) p /x tx_busy
$9 = 0x1
(gdb) where
#0  uartwrite (buf=buf@entry=0x3fffffdeb0 "n\337\377\377?", n=n@entry=1) at
kernel/uart.c:87
#1  0x00000000800051ec in consolewrite (user_src=1, src=16095, n=1) at
kernel/console.c:70
#2  0x000000008000399e in filewrite (f=0x80237a40 <ftable+24>, addr=16095, n=1)
at kernel/file.c:147
#3  0x000000008000437a in sys_write () at kernel/sysfile.c:94
#4  0x0000000080001fe2 in syscall () at kernel/syscall.c:141
#5  0x0000000080001d6c in usertrap () at kernel/trap.c:68
#6  0x0000003ffffff09c in ?? ()
(gdb) list .
82      {
83        acquire(&tx_lock);
84
85        int i = 0;
86        while(i < n){
87          while(tx_busy != 0){
88            // wait for a UART transmit-complete interrupt
89            // to set tx_busy to 0.
90            sleep(&tx_chan, &tx_lock);
91          }
```
