Console read:

* Uuser process read from the circular buffer
* Who put byte into the buffer? console interrupt
* Who call console interrupt? uartint() calls console interrupt for each byte it reads
* Why this design?
    * The console driver can process input even if no process is waiting to read it

Concurrency dangers:
    * two user processes in different CPU call consoleread()
    * the hardware might deliver a console interrupt on a (different) CPU while consoleread is executing

Kernel Trap:
    * interrupt is kept disable
    * only one interrupt being handled at a time on that hart until the current trap handler finishes

devintr():
    * if Timer interrrupt:
        * clockintr():
            * wakeup(&tick)
                * wakeup any processes waiting in the pause system call
                * &tick is the processes sleeping channel
            * schedule the next timer interrupt
        * return 2
    * if 2:
        * yield()

DMA: Direct Memory Access
    * devices can read/write memory like CPU
    * e.g. network card, disk controller
