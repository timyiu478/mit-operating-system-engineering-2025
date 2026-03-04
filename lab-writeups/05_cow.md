# Copy-on-Write Fork for xv6

## Lab Details

See https://pdos.csail.mit.edu/6.1810/2025/labs/cow.html

## DEMO

Watch https://docs.google.com/videos/d/1trSb8H29tkMxJog2Y59Yl4Ec25nMF5C_i2SyZZUvaJo/play

## Related Source Code

See https://github.com/timyiu478/mit-operating-system-engineering-2025/commit/f80eeefaf15912ae04a88f4e71ffea7cccff8be7

## Design Choices

* The 8-bit in the RISC-V PTE is used for determining whether it is a CoW mapping.
* We use a global array `refcount` in kalloc.c to store the reference counts of the pages. This global variable will be stored in the address below the start address of the dynamic allocation region, so we do not have to worry about allocating a page for storing the reference counts. 

## Questions I have when I was implementing this feature

Q1. If text is read-only, how can exec() write new code into it?

The exec() never writes into the old text.
It creates a new address space.
It deletes the old address space after its prepared the new address space successfully.

Source code: https://github.com/timyiu478/mit-operating-system-engineering-2025/blob/pgtbl_lab/xv6-labs-2025/kernel/exec.c#L27

## Mistake I made

I somehow made the increase reference count function is invoked only if the page is writable.
We should call it even if the page is read-only because those pages are also mapped by the child.

```diff
if((flags & PTE_C) && !(flags & PTE_W)){
  *pte = PA2PTE(pa) | flags;
  sfence_vma();
-  kincref(pa);
}
+  kincref(pa);
```

If we made this mistake, we may see the illegal instruction exception like this:

```console
$ ls
.              1 1 1024
..             1 1 1024
README         2 2 2425
cat            2 3 38128
echo           2 4 36912
forktest       2 5 18200
grep           2 6 41696
init           2 7 37296
kill           2 8 36840
ln             2 9 36632
ls             2 10 40256
mkdir          2 11 36904
rm             2 12 36888
sh             2 13 60848
stressfs       2 14 37768
usertests      2 15 193024
grind          2 16 53408
wc             2 17 39160
zombie         2 18 36168
logstress      2 19 38920
forphan        2 20 37672
dorphan        2 21 37104
cowtest        2 22 45680
console        3 23 0
usertrap(): unexpected scause 0x2 pid=2
            sepc=0x1000 stval=0x2000
            process name=sh
double free pa: 0x0000000087f42000
panic: kfree
QEMU: Terminated
```

I found this root cause by rereading my implementation multiple times... 
I tried to give my implementation to the free-tier LLM models (e.g. Grok) to review, but they were unable to discover it.

