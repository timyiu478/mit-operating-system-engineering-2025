## Exercise

Write a program that uses UNIX system calls to “ping-pong” a byte between two processes over a pair of pipes, one for each direction. Measure the program’s performance, in exchanges per second.


source code: [pingpong.c](/Users/timyiu/operating-system-engineering/exercises/pingpong.c)

```
❯ gcc pingpong.c
❯ time ./a.out
pg./a.out  0.05s user 0.03s system 17% cpu 0.452 total
```
