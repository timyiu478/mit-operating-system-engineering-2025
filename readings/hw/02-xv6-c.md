# Question

This lecture will focus on aspects of the C programming language that you might not have seen before, that are particularly relevant for a kernel implementation and that you will encounter in the xv6 kernel code. Read the following sections of The C programming language (second edition) by Kernighan and Ritchie:

Section 2.9 (bitwise operators)
Section 5.1 (pointers and addresses)
Section 5.2 (pointers and function arguments)
Section 5.3 (pointers and arrays)
Section 5.4 (address arithmetic)
Section 5.5 (character pointers and functions)
Section 5.6 (pointer arrays; pointers to pointers)
Section 6.4 (pointers to structures)

Consider the following fragment of C code, on a 32-bit system:

```
struct f {
  int a;
  char b[32];
};

struct g {
  char *c;
  int d[4];
};

struct h {
  struct f *f;
  struct g g;
};

struct h *h;
```

Suppose that the value of h is 0x1000. Figure out the values of the following expressions, or explain why it's not possible to figure them out:

```
1. &h->g.d[2]
2. &h->f->a
3. &h->g.c
4. &h->g.c[10]
```
