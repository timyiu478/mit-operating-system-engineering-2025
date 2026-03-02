* Q. Why xv6 handles all traps?
    * system call: user calls xv6
    * interrupt: for islation => only xv6 can use/work with the devices
    * exception (user/kernel): ??

* Vector: the assembly code that first handles the trap

* Q. Why seperate two trap paths: one trap from user space, one trap from kernel space?
    * trap from user space requires page table switch and stack pointer switch while trap from kernel space does not
    * RISC-V hardware does not do it for flexibility reason
    * kernel trap can save registers onto current stack of the interrupted kernel thread

* Design Constraint of xv6's trap handling because of RISC-V does not switch page table
    * trap handler code in stvec must have a valid mapping in user page table
    * trap handler cdoe needs to switch to kernel page table and be able to continue executing after the switch
        * => kernel page table also have a valid mapping points to by stvec
    * Solution: a trampoline page

* The useful values stored in trapframe after initialising it:
    * kernel stack address
    * kernel page table address
        * cost: 8 bytes extra per process
    * usertrap function address
    * CPU hartid

* copyinstr: an example of safe copy from user-space src address to dst address
    * https://github.com/mit-pdos/xv6-riscv/blob/riscv//kernel/vm.c#L410

* Q. What will a kernel-mode process do when it receives a timer interrupt?
    * it will yield to give another thread a chance to run
    * there is **no mode change** back to user mode as part of the yield itself!

