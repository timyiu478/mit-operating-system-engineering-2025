# Lab: Xv6 and Unix utilities

Lab detail: https://pdos.csail.mit.edu/6.1810/2025/labs/util.html

## Demo

The short demo to show how to use the following implemented utilities:
 
* sleep
* memdump
* sixfive
* find

Demo video link: https://docs.google.com/videos/d/1MPORcAV7mKmOqRd2Ryp8TNzqulrNfSYHXuKfG2g9GMA/edit?usp=sharing

## Related source code

* [sleep.c](../xv6-labs-2025/user/sleep.c)
* [memdump.c](../xv6-labs-2025/user/memdump.c)
* [sixfive.c](../xv6-labs-2025/user/sixfive.c)
* [find.c](../xv6-labs-2025/user/find.c)

## Mistakes I made

To support the `-exec cmd …` feature in find, I used the `exec(const char* path, char* const argv[])` system call to run the specified command.
However, I initially overlooked a key convention: the first element of the argument array (`argv[0]`) should conventionally point to the name/path of the program being executed.
For example, when running

`find . abc -exec echo 123`

and finding the file `abc`, the executed command became effectively

`echo abc`

instead of the expected

`echo 123 abc`

— so only `abc` was printed, not `123 abc`.
