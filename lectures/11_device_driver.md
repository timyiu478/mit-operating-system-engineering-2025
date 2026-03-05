* Lecture Goal: focus on external interrupt

* Interrupt vs system call:
    * interrupt is asynchronous: the intterrupt handler may have nothing to do
      with the **current running process**
    * interrupt has much more concurrency: different hardware components (CPU,
      network card, uart...) are doing things in parallel
    * each device has its own program manual

* Interrupt handler does **NOT run in any process context**

* IRQ: **I**nterrupt **R**e**q**uest

* Top level driver vs low level driver:
    * top level:
        * interface between OS and user
    * low level:
        * directly touches the hardware registers via memory-mapped I/O to talk
          with specific device/chip

* Interrupt and conccurency:
    * devices and CPU are running in parallel
        * producer/consumer parallelism
        * e.g. uart.c
    * top level drivers and low level drivers are running in parallel
        * locks
        * e.g. console.c
