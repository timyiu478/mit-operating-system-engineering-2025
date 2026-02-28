# Lab: traps

Detail: https://pdos.csail.mit.edu/6.1810/2025/labs/traps.html

# 1. RISC-V assembly

Q. Which registers contain arguments to functions? For example, which register holds 13 in main's call to printf?

The registers a0, a1, a2 contain arguments to functions.

The register a2 holds 12 in main's call to printf.
The register a1 holds f(8)+1 in main's call to printf.
The register a0 holds address of the format string in main's call to printf.

Q. Where is the call to function f in the assembly code for main? Where is the call to g? (Hint: the compiler may inline functions.)

There is no call to f (or to g) in main.

* f(x) was then inlined into main, so the whole expression f(8)+1 was turned into the constant 12.
* There is no call to g because the function f in the assembly code is substituted to the function g's assembly code.

Q. At what address is the function printf located?

Address 0x73e is the function printf located.

Q. Run the following code.

```
unsigned int i = 0x00646c72;
printf("H%x Wo%s", 57616, (char *) &i);
```
      
What is the output? Here's an ASCII table that maps bytes to characters.
The output depends on that fact that the RISC-V is little-endian. If the RISC-V
were instead big-endian what would you set i to in order to yield the same
output? Would you need to change 57616 to a different value?

Here's a description of little- and big-endian and a more whimsical
description.

Output: HE110 World

hex representation of 57616:

```
(gdb) p /x 57616
$1 = 0xe110
```

xv6 is little-endian where the lower signifiant bit is stored in lower memory address:

```
(gdb) p /c 0x00646c72
$4 = 114 'r'
(gdb) p /c 0x00646c
$5 = 108 'l'
(gdb) p /c 0x0064
$6 = 100 'd'
(gdb) p /c 0x00
$7 = 0 '\000'
```

Q. In the following code, what is going to be printed after 'y='? (note: the answer is not a specific value.) Why does this happen?

```
printf("x=%d y=%d", 3);
```

Assume the program can be complier. 

It will print the value that register a2 holds.

# 2. Backtrace



# 3. Alarm
