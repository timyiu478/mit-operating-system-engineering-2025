# Question

For this lecture, read the kernel files kernel/log.c. You may find Chapter 10
(in particular, Sections 10.4-10.6) of the book useful in understanding the
logging code.

To understand how the log is used, insert the following line of code before the log_write statement in the function writei() in kernel/fs.c:

```
printf("log write %d: %d %d %d\n", addr, bp->blockno, off, n);
```

Run make clean and then make qemu, and at the xv6 shell prompt run the
following command:

```
$ echo hi > f
```

You should see output similiar to this:

```
log write 47: 47 368 16
log write 936: 936 0 2
log write 936: 936 2 1
```

The output indicates that log_write is called three times for this shell
command. Why is log_write called 3 times? What does each log_write write? Does
the first write above correspond to updating the root directory and the other
two writes correspond to writing file f? (Feel free to add more print
statements to the kernel to help you to answer the question.)

# Answer

The first write above correspond to updating the root directory and the other two writes correspond to writing file f.

The shell code will open the file f when it runs the redirection with O_CREATE flag by calling open(). The open() function will call create() to create the file. The create() will allocate a new inode by calling iupdate() and link it to the parent directory which is root by call dirlink() => writei().

The first write to file f is "hi" to offset 0.
The second write to file f is "\n" to offset 2.

We can verify the writes to file f by the offset and the size in print statements, `cat f` command and `echo.c` implementation.

console:

```console
$ echo hi > f
log write 71: 71 384 16
log write 1017: 1017 0 2
log write 1017: 1017 2 1
$ cat f
hi
```

shell.c:

```c
83   case REDIR:
84     rcmd = (struct redircmd*)cmd;
85     close(rcmd->fd);
86     if(open(rcmd->file, rcmd->mode) < 0){
87       fprintf(2, "open %s failed\n", rcmd->file);
88       exit(1);
89     }
90     runcmd(rcmd->cmd);
91     break;
...
...
394     case '>':
395       cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE|O_TRUNC, 1);
```

fs.c:dirlink:

```c
665 // Write a new directory entry (name, inum) into the directory dp.
666 // Returns 0 on success, -1 on failure (e.g. out of disk blocks).
667 int
668 dirlink(struct inode *dp, char *name, uint inum)
669 {
670   int off;
671   struct dirent de;
672   struct inode *ip;
673
674   // Check that name is not present.
675   if((ip = dirlookup(dp, name, 0)) != 0){
676     iput(ip);
677     return -1;
678   }
679
680   // Look for an empty dirent.
681   for(off = 0; off < dp->size; off += sizeof(de)){
682     if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
683       panic("dirlink read");
684     if(de.inum == 0)
685       break;
686   }
687
688   strncpy(de.name, name, DIRSIZ);
689   de.inum = inum;
690   if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
691     return -1;
692
693   return 0;
694 }
```

echo.c:

```c
#include "kernel/types.h"
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
  int i;

  for(i = 1; i < argc; i++){
    write(1, argv[i], strlen(argv[i]));
    if(i + 1 < argc){
      write(1, " ", 1);
    } else {
      write(1, "\n", 1);
    }
  }
  exit(0);
}
```
