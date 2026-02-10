## Question

For this lecture, read the xv6 implementation of a simple Unix program, cat, available here. How does the system keep track of the connection between the string filename argv[i] passed to open(), and the resulting integer file descriptor fd? What does the integer file descriptor number refer to?

You might find it helpful to read chapter 1 of the xv6 book, which provides an overview of a Unix-like operating system. For your amusement, you can also watch a historic AT&T film about Unix.

## Answer

To keep track of the connection between the string filename `argv[i]` passed to `open()`, the system will create a new entry in the Open File Table for the file corresponding to the filename `argv[i]` which this entry stores the information for accessing the corresponding file such as inode number, file offset, access mode, and reference count. Then the system will create a new a entry in the File Descriptor Table of the process who call `open()`. This entry value is a pointer refer the newly created entry in the Open File Table and the entry key is the resulting integer file descriptor `fd`.

```
File Descriptor Table (per-process) --> Open File Table (system-wise for all processes) --> Inode
```
