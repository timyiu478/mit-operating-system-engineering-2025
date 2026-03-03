# Question

For this lecture, read the following files in the xv6 kernel implementation:

* kernel/sysproc.c:sbrk()
* kernel/trap.c:usertrap()
* kernel/vm.c:vmfault()

vm.c:copyout() calls vmfault when dstva isn't mapped. Describe a scenario in which dstva isn't mapped? That is, give a list of system calls that a process can make to triggers this case.

You may find chapter 5 of the book useful in understanding page faults.

# Answer

The application first calls sbrk(n).  This only increases p->sz; it does not allocate physical memory or create PTEs for the new virtual addresses. 

Let addr be the address returned by sbrk().

The process can then call read(f, addr, n).

Because addr lies in the lazily-allocated region and is not yet mapped, the kernel path sys_read() => fileread() => readi() => either_copyout() => copyout() sees an invalid/unmapped dstva and calls vmfault() to allocate the page.
