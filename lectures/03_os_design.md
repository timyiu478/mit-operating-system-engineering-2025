Goal: Strong Isolation

Implementation: OS + hardware support(kernel/user mode, virtual memory)

* kernel mode: can run privileged CPU instruction 
    * e.g. set up page table register, disable clock interrupt

---

Strawnman Design 1: no OS, use library to encapsulate the hareware interaction

User code can decide to use their own way (e.g. modified library) to interact with the hardware

=> need to trust the user code => no strong isolation

* If one of the user program contain infinite loop, then cooperative scheduling won't work. => can't context switch
* corrupt other process/users resources such as address space and files

