# Lab: page tables

Lab detail: https://pdos.csail.mit.edu/6.1810/2025/labs/pgtbl.html

# 1. Inspect a user-process page table

The output of print_pgtbl:

```
va 0 pte 0x21FCF45B pa 0x87F3D000 perm 0x5B
va 1000 pte 0x21FCE85B pa 0x87F3A000 perm 0x5B
...
va 0xFFFFD000 pte 0x0 pa 0x0 perm 0x0
va 0xFFFFE000 pte 0x21FD80C7 pa 0x87F60000 perm 0xC7
va 0xFFFFF000 pte 0x20001C4B pa 0x80007000 perm 0x4B
```

Q. For every page table entry in the print_pgtbl output, explain what it logically contains and what its permission bits are. Figure 3.4 in the xv6 book might be helpful, although note that the figure might have a slightly different set of pages than process that's being inspected here. Note that xv6 doesn't place the virtual pages consecutively in physical memory.

Permission bits:

```
7 6 5 4 3 2 1 0
D A G U X W R V

D: Dirty
A: Accessed
G: Global
U: User
X: Executable
W: Writable
R: Readable
V: Valid
```

```
va 0 pte 0x21FCF45B pa 0x87F3D000 perm 0x5B          // Binary format: 01011011 => meaning flags: A,U,X,R,V
                                                     // va 0: text segment

va 1000 pte 0x21FCE85B pa 0x87F3A000 perm 0x5B       // Binary format: 01011011 => meaning flags: A,U,X,R,V
                                                     // va 1000: also text segment
...
va 0xFFFFD000 pte 0x0 pa 0x0 perm 0x0                // no permission
                                                     // pte 0x0: unused page

va 0xFFFFE000 pte 0x21FD80C7 pa 0x87F60000 perm 0xC7 // Binary format: 11000111 => meaning flags: D,A,W,R,V
                                                     // va 0xFFFFE000 = lower page of trampoline page: trapframe page

va 0xFFFFF000 pte 0x20001C4B pa 0x80007000 perm 0x4B // Binary format: 01001011 => meaning flags: A,X,R,V
                                                     // va 0xFFFFF000 = MAXVA - PGSIZE: so this page is trampoline
```

References: figure 3.2 and figure 3.4 of the xv6 book

# 2. Speed up system calls

## Task: optimize the getpid() system call in xv6



## Q. Which other xv6 system call(s) could be made faster using this shared page? Explain how.



# 3. Print a page table

# 4. Use superpages
