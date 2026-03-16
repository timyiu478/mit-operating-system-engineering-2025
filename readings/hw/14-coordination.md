# Question

For this lecture, read the code for sleep() and wakeup() in kernel/proc.c;
uartwrite() and uartintr() in kernel/uart.c; and all of kernel/pipe.c.

Look for this line in uartwrite() and comment it out:

```
sleep(&tx_chan, &tx_lock);
```

Start xv6 with make qemu. What goes wrong? Why?

You will likely find gdb helpful.


Optional challenge: can you modify uartwrite() to work better (perhaps continue

for a few more characters of output), without calling sleep()?

You may find Chapter 9 of the book useful in understanding sleep and wakeup.

# Answer

If we comment the `sleep(&tx_chan, &tx_lock)`, the lock `tx_lock` will not be released by `uartwrite()` and the process will not yield the CPU when `tx_busy` is not equal to 0.

```c
 80 void
 81 uartwrite(char buf[], int n)
 82 {
 83   acquire(&tx_lock);
 84
 85   int i = 0;
 86   while(i < n){
 87     while(tx_busy != 0){
 88       // wait for a UART transmit-complete interrupt
 89       // to set tx_busy to 0.
 90       // sleep(&tx_chan, &tx_lock);
 91     }
 92
 93     WriteReg(THR, buf[i]);
 94     i += 1;
 95     tx_busy = 1;
 96   }
 97
 98   release(&tx_lock);
 99 }
```

The `tx_busy` will be set to 0 by the `uartintr()` function.

However, it requires to acquire the lock `tx_lock` before changing the `tx_busy` to 0.

Thus, the above while loop never exits and no further transmission ever happens.

```c
139 // handle a uart interrupt, raised because input has
140 // arrived, or the uart is ready for more output, or
141 // both. called from devintr().
142 void
143 uartintr(void)
144 {
145   ReadReg(ISR); // acknowledge the interrupt
146
147   acquire(&tx_lock);
148   if(ReadReg(LSR) & LSR_TX_IDLE){
149     // UART finished transmitting; wake up sending thread.
150     tx_busy = 0;
151     wakeup(&tx_chan);
152   }
153   release(&tx_lock);
154
155   // read and process incoming characters.
156   while(1){
157     int c = uartgetc();
158     if(c == -1)
159       break;
160     consoleintr(c);
161   }
162 }
```
