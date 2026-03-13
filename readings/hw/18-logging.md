# Question

For this lecture, read the kernel files kernel/log.c. You may find Chapter 10
(in particular, Sections 10.4-10.6) of the book useful in understanding the
logging code.

To understand how the log is used, insert the following line of code before the
log_write statement in the function writei() in kernel/fs.c:

printf("log write %d: %d %d %d\n", addr, bp->blockno, off, n);
Run make clean and then make qemu, and at the xv6 shell prompt run the
following command:

$ echo hi > f

You should see output similiar to this:

log write 47: 47 368 16
log write 936: 936 0 2
log write 936: 936 2 1

The output indicates that log_write is called three times for this shell
command. Why is log_write called 3 times? What does each log_write write? Does
the first write above correspond to updating the root directory and the other
two writes correspond to writing file f? (Feel free to add more print
statements to the kernel to help you to answer the question.)
