
user/_attack:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "user/user.h"
#include "kernel/riscv.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  // Your code here.

  exit(1);
   8:	4505                	li	a0,1
   a:	2bc000ef          	jal	2c6 <exit>

000000000000000e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
   e:	1141                	addi	sp,sp,-16
  10:	e406                	sd	ra,8(sp)
  12:	e022                	sd	s0,0(sp)
  14:	0800                	addi	s0,sp,16
  extern int main();
  main();
  16:	febff0ef          	jal	0 <main>
  exit(0);
  1a:	4501                	li	a0,0
  1c:	2aa000ef          	jal	2c6 <exit>

0000000000000020 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  20:	1141                	addi	sp,sp,-16
  22:	e406                	sd	ra,8(sp)
  24:	e022                	sd	s0,0(sp)
  26:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  28:	87aa                	mv	a5,a0
  2a:	0585                	addi	a1,a1,1
  2c:	0785                	addi	a5,a5,1
  2e:	fff5c703          	lbu	a4,-1(a1)
  32:	fee78fa3          	sb	a4,-1(a5)
  36:	fb75                	bnez	a4,2a <strcpy+0xa>
    ;
  return os;
}
  38:	60a2                	ld	ra,8(sp)
  3a:	6402                	ld	s0,0(sp)
  3c:	0141                	addi	sp,sp,16
  3e:	8082                	ret

0000000000000040 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  40:	1141                	addi	sp,sp,-16
  42:	e406                	sd	ra,8(sp)
  44:	e022                	sd	s0,0(sp)
  46:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  48:	00054783          	lbu	a5,0(a0)
  4c:	cb91                	beqz	a5,60 <strcmp+0x20>
  4e:	0005c703          	lbu	a4,0(a1)
  52:	00f71763          	bne	a4,a5,60 <strcmp+0x20>
    p++, q++;
  56:	0505                	addi	a0,a0,1
  58:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  5a:	00054783          	lbu	a5,0(a0)
  5e:	fbe5                	bnez	a5,4e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  60:	0005c503          	lbu	a0,0(a1)
}
  64:	40a7853b          	subw	a0,a5,a0
  68:	60a2                	ld	ra,8(sp)
  6a:	6402                	ld	s0,0(sp)
  6c:	0141                	addi	sp,sp,16
  6e:	8082                	ret

0000000000000070 <strlen>:

uint
strlen(const char *s)
{
  70:	1141                	addi	sp,sp,-16
  72:	e406                	sd	ra,8(sp)
  74:	e022                	sd	s0,0(sp)
  76:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  78:	00054783          	lbu	a5,0(a0)
  7c:	cf91                	beqz	a5,98 <strlen+0x28>
  7e:	00150793          	addi	a5,a0,1
  82:	86be                	mv	a3,a5
  84:	0785                	addi	a5,a5,1
  86:	fff7c703          	lbu	a4,-1(a5)
  8a:	ff65                	bnez	a4,82 <strlen+0x12>
  8c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  90:	60a2                	ld	ra,8(sp)
  92:	6402                	ld	s0,0(sp)
  94:	0141                	addi	sp,sp,16
  96:	8082                	ret
  for(n = 0; s[n]; n++)
  98:	4501                	li	a0,0
  9a:	bfdd                	j	90 <strlen+0x20>

000000000000009c <memset>:

void*
memset(void *dst, int c, uint n)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  a4:	ca19                	beqz	a2,ba <memset+0x1e>
  a6:	87aa                	mv	a5,a0
  a8:	1602                	slli	a2,a2,0x20
  aa:	9201                	srli	a2,a2,0x20
  ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  b4:	0785                	addi	a5,a5,1
  b6:	fee79de3          	bne	a5,a4,b0 <memset+0x14>
  }
  return dst;
}
  ba:	60a2                	ld	ra,8(sp)
  bc:	6402                	ld	s0,0(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret

00000000000000c2 <strchr>:

char*
strchr(const char *s, char c)
{
  c2:	1141                	addi	sp,sp,-16
  c4:	e406                	sd	ra,8(sp)
  c6:	e022                	sd	s0,0(sp)
  c8:	0800                	addi	s0,sp,16
  for(; *s; s++)
  ca:	00054783          	lbu	a5,0(a0)
  ce:	cf81                	beqz	a5,e6 <strchr+0x24>
    if(*s == c)
  d0:	00f58763          	beq	a1,a5,de <strchr+0x1c>
  for(; *s; s++)
  d4:	0505                	addi	a0,a0,1
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbfd                	bnez	a5,d0 <strchr+0xe>
      return (char*)s;
  return 0;
  dc:	4501                	li	a0,0
}
  de:	60a2                	ld	ra,8(sp)
  e0:	6402                	ld	s0,0(sp)
  e2:	0141                	addi	sp,sp,16
  e4:	8082                	ret
  return 0;
  e6:	4501                	li	a0,0
  e8:	bfdd                	j	de <strchr+0x1c>

00000000000000ea <gets>:

char*
gets(char *buf, int max)
{
  ea:	711d                	addi	sp,sp,-96
  ec:	ec86                	sd	ra,88(sp)
  ee:	e8a2                	sd	s0,80(sp)
  f0:	e4a6                	sd	s1,72(sp)
  f2:	e0ca                	sd	s2,64(sp)
  f4:	fc4e                	sd	s3,56(sp)
  f6:	f852                	sd	s4,48(sp)
  f8:	f456                	sd	s5,40(sp)
  fa:	f05a                	sd	s6,32(sp)
  fc:	ec5e                	sd	s7,24(sp)
  fe:	e862                	sd	s8,16(sp)
 100:	1080                	addi	s0,sp,96
 102:	8baa                	mv	s7,a0
 104:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 106:	892a                	mv	s2,a0
 108:	4481                	li	s1,0
    cc = read(0, &c, 1);
 10a:	faf40b13          	addi	s6,s0,-81
 10e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 110:	8c26                	mv	s8,s1
 112:	0014899b          	addiw	s3,s1,1
 116:	84ce                	mv	s1,s3
 118:	0349d463          	bge	s3,s4,140 <gets+0x56>
    cc = read(0, &c, 1);
 11c:	8656                	mv	a2,s5
 11e:	85da                	mv	a1,s6
 120:	4501                	li	a0,0
 122:	1bc000ef          	jal	2de <read>
    if(cc < 1)
 126:	00a05d63          	blez	a0,140 <gets+0x56>
      break;
    buf[i++] = c;
 12a:	faf44783          	lbu	a5,-81(s0)
 12e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 132:	0905                	addi	s2,s2,1
 134:	ff678713          	addi	a4,a5,-10
 138:	c319                	beqz	a4,13e <gets+0x54>
 13a:	17cd                	addi	a5,a5,-13
 13c:	fbf1                	bnez	a5,110 <gets+0x26>
    buf[i++] = c;
 13e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 140:	9c5e                	add	s8,s8,s7
 142:	000c0023          	sb	zero,0(s8)
  return buf;
}
 146:	855e                	mv	a0,s7
 148:	60e6                	ld	ra,88(sp)
 14a:	6446                	ld	s0,80(sp)
 14c:	64a6                	ld	s1,72(sp)
 14e:	6906                	ld	s2,64(sp)
 150:	79e2                	ld	s3,56(sp)
 152:	7a42                	ld	s4,48(sp)
 154:	7aa2                	ld	s5,40(sp)
 156:	7b02                	ld	s6,32(sp)
 158:	6be2                	ld	s7,24(sp)
 15a:	6c42                	ld	s8,16(sp)
 15c:	6125                	addi	sp,sp,96
 15e:	8082                	ret

0000000000000160 <stat>:

int
stat(const char *n, struct stat *st)
{
 160:	1101                	addi	sp,sp,-32
 162:	ec06                	sd	ra,24(sp)
 164:	e822                	sd	s0,16(sp)
 166:	e04a                	sd	s2,0(sp)
 168:	1000                	addi	s0,sp,32
 16a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16c:	4581                	li	a1,0
 16e:	198000ef          	jal	306 <open>
  if(fd < 0)
 172:	02054263          	bltz	a0,196 <stat+0x36>
 176:	e426                	sd	s1,8(sp)
 178:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 17a:	85ca                	mv	a1,s2
 17c:	1a2000ef          	jal	31e <fstat>
 180:	892a                	mv	s2,a0
  close(fd);
 182:	8526                	mv	a0,s1
 184:	16a000ef          	jal	2ee <close>
  return r;
 188:	64a2                	ld	s1,8(sp)
}
 18a:	854a                	mv	a0,s2
 18c:	60e2                	ld	ra,24(sp)
 18e:	6442                	ld	s0,16(sp)
 190:	6902                	ld	s2,0(sp)
 192:	6105                	addi	sp,sp,32
 194:	8082                	ret
    return -1;
 196:	57fd                	li	a5,-1
 198:	893e                	mv	s2,a5
 19a:	bfc5                	j	18a <stat+0x2a>

000000000000019c <atoi>:

int
atoi(const char *s)
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1a4:	00054683          	lbu	a3,0(a0)
 1a8:	fd06879b          	addiw	a5,a3,-48
 1ac:	0ff7f793          	zext.b	a5,a5
 1b0:	4625                	li	a2,9
 1b2:	02f66963          	bltu	a2,a5,1e4 <atoi+0x48>
 1b6:	872a                	mv	a4,a0
  n = 0;
 1b8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1ba:	0705                	addi	a4,a4,1
 1bc:	0025179b          	slliw	a5,a0,0x2
 1c0:	9fa9                	addw	a5,a5,a0
 1c2:	0017979b          	slliw	a5,a5,0x1
 1c6:	9fb5                	addw	a5,a5,a3
 1c8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1cc:	00074683          	lbu	a3,0(a4)
 1d0:	fd06879b          	addiw	a5,a3,-48
 1d4:	0ff7f793          	zext.b	a5,a5
 1d8:	fef671e3          	bgeu	a2,a5,1ba <atoi+0x1e>
  return n;
}
 1dc:	60a2                	ld	ra,8(sp)
 1de:	6402                	ld	s0,0(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  n = 0;
 1e4:	4501                	li	a0,0
 1e6:	bfdd                	j	1dc <atoi+0x40>

00000000000001e8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e406                	sd	ra,8(sp)
 1ec:	e022                	sd	s0,0(sp)
 1ee:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1f0:	02b57563          	bgeu	a0,a1,21a <memmove+0x32>
    while(n-- > 0)
 1f4:	00c05f63          	blez	a2,212 <memmove+0x2a>
 1f8:	1602                	slli	a2,a2,0x20
 1fa:	9201                	srli	a2,a2,0x20
 1fc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 200:	872a                	mv	a4,a0
      *dst++ = *src++;
 202:	0585                	addi	a1,a1,1
 204:	0705                	addi	a4,a4,1
 206:	fff5c683          	lbu	a3,-1(a1)
 20a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 20e:	fee79ae3          	bne	a5,a4,202 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 212:	60a2                	ld	ra,8(sp)
 214:	6402                	ld	s0,0(sp)
 216:	0141                	addi	sp,sp,16
 218:	8082                	ret
    while(n-- > 0)
 21a:	fec05ce3          	blez	a2,212 <memmove+0x2a>
    dst += n;
 21e:	00c50733          	add	a4,a0,a2
    src += n;
 222:	95b2                	add	a1,a1,a2
 224:	fff6079b          	addiw	a5,a2,-1
 228:	1782                	slli	a5,a5,0x20
 22a:	9381                	srli	a5,a5,0x20
 22c:	fff7c793          	not	a5,a5
 230:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 232:	15fd                	addi	a1,a1,-1
 234:	177d                	addi	a4,a4,-1
 236:	0005c683          	lbu	a3,0(a1)
 23a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 23e:	fef71ae3          	bne	a4,a5,232 <memmove+0x4a>
 242:	bfc1                	j	212 <memmove+0x2a>

0000000000000244 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 244:	1141                	addi	sp,sp,-16
 246:	e406                	sd	ra,8(sp)
 248:	e022                	sd	s0,0(sp)
 24a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 24c:	c61d                	beqz	a2,27a <memcmp+0x36>
 24e:	1602                	slli	a2,a2,0x20
 250:	9201                	srli	a2,a2,0x20
 252:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 256:	00054783          	lbu	a5,0(a0)
 25a:	0005c703          	lbu	a4,0(a1)
 25e:	00e79863          	bne	a5,a4,26e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 262:	0505                	addi	a0,a0,1
    p2++;
 264:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 266:	fed518e3          	bne	a0,a3,256 <memcmp+0x12>
  }
  return 0;
 26a:	4501                	li	a0,0
 26c:	a019                	j	272 <memcmp+0x2e>
      return *p1 - *p2;
 26e:	40e7853b          	subw	a0,a5,a4
}
 272:	60a2                	ld	ra,8(sp)
 274:	6402                	ld	s0,0(sp)
 276:	0141                	addi	sp,sp,16
 278:	8082                	ret
  return 0;
 27a:	4501                	li	a0,0
 27c:	bfdd                	j	272 <memcmp+0x2e>

000000000000027e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 27e:	1141                	addi	sp,sp,-16
 280:	e406                	sd	ra,8(sp)
 282:	e022                	sd	s0,0(sp)
 284:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 286:	f63ff0ef          	jal	1e8 <memmove>
}
 28a:	60a2                	ld	ra,8(sp)
 28c:	6402                	ld	s0,0(sp)
 28e:	0141                	addi	sp,sp,16
 290:	8082                	ret

0000000000000292 <sbrk>:

char *
sbrk(int n) {
 292:	1141                	addi	sp,sp,-16
 294:	e406                	sd	ra,8(sp)
 296:	e022                	sd	s0,0(sp)
 298:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 29a:	4585                	li	a1,1
 29c:	0b2000ef          	jal	34e <sys_sbrk>
}
 2a0:	60a2                	ld	ra,8(sp)
 2a2:	6402                	ld	s0,0(sp)
 2a4:	0141                	addi	sp,sp,16
 2a6:	8082                	ret

00000000000002a8 <sbrklazy>:

char *
sbrklazy(int n) {
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2b0:	4589                	li	a1,2
 2b2:	09c000ef          	jal	34e <sys_sbrk>
}
 2b6:	60a2                	ld	ra,8(sp)
 2b8:	6402                	ld	s0,0(sp)
 2ba:	0141                	addi	sp,sp,16
 2bc:	8082                	ret

00000000000002be <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2be:	4885                	li	a7,1
 ecall
 2c0:	00000073          	ecall
 ret
 2c4:	8082                	ret

00000000000002c6 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2c6:	4889                	li	a7,2
 ecall
 2c8:	00000073          	ecall
 ret
 2cc:	8082                	ret

00000000000002ce <wait>:
.global wait
wait:
 li a7, SYS_wait
 2ce:	488d                	li	a7,3
 ecall
 2d0:	00000073          	ecall
 ret
 2d4:	8082                	ret

00000000000002d6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2d6:	4891                	li	a7,4
 ecall
 2d8:	00000073          	ecall
 ret
 2dc:	8082                	ret

00000000000002de <read>:
.global read
read:
 li a7, SYS_read
 2de:	4895                	li	a7,5
 ecall
 2e0:	00000073          	ecall
 ret
 2e4:	8082                	ret

00000000000002e6 <write>:
.global write
write:
 li a7, SYS_write
 2e6:	48c1                	li	a7,16
 ecall
 2e8:	00000073          	ecall
 ret
 2ec:	8082                	ret

00000000000002ee <close>:
.global close
close:
 li a7, SYS_close
 2ee:	48d5                	li	a7,21
 ecall
 2f0:	00000073          	ecall
 ret
 2f4:	8082                	ret

00000000000002f6 <kill>:
.global kill
kill:
 li a7, SYS_kill
 2f6:	4899                	li	a7,6
 ecall
 2f8:	00000073          	ecall
 ret
 2fc:	8082                	ret

00000000000002fe <exec>:
.global exec
exec:
 li a7, SYS_exec
 2fe:	489d                	li	a7,7
 ecall
 300:	00000073          	ecall
 ret
 304:	8082                	ret

0000000000000306 <open>:
.global open
open:
 li a7, SYS_open
 306:	48bd                	li	a7,15
 ecall
 308:	00000073          	ecall
 ret
 30c:	8082                	ret

000000000000030e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 30e:	48c5                	li	a7,17
 ecall
 310:	00000073          	ecall
 ret
 314:	8082                	ret

0000000000000316 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 316:	48c9                	li	a7,18
 ecall
 318:	00000073          	ecall
 ret
 31c:	8082                	ret

000000000000031e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 31e:	48a1                	li	a7,8
 ecall
 320:	00000073          	ecall
 ret
 324:	8082                	ret

0000000000000326 <link>:
.global link
link:
 li a7, SYS_link
 326:	48cd                	li	a7,19
 ecall
 328:	00000073          	ecall
 ret
 32c:	8082                	ret

000000000000032e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 32e:	48d1                	li	a7,20
 ecall
 330:	00000073          	ecall
 ret
 334:	8082                	ret

0000000000000336 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 336:	48a5                	li	a7,9
 ecall
 338:	00000073          	ecall
 ret
 33c:	8082                	ret

000000000000033e <dup>:
.global dup
dup:
 li a7, SYS_dup
 33e:	48a9                	li	a7,10
 ecall
 340:	00000073          	ecall
 ret
 344:	8082                	ret

0000000000000346 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 346:	48ad                	li	a7,11
 ecall
 348:	00000073          	ecall
 ret
 34c:	8082                	ret

000000000000034e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 34e:	48b1                	li	a7,12
 ecall
 350:	00000073          	ecall
 ret
 354:	8082                	ret

0000000000000356 <pause>:
.global pause
pause:
 li a7, SYS_pause
 356:	48b5                	li	a7,13
 ecall
 358:	00000073          	ecall
 ret
 35c:	8082                	ret

000000000000035e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 35e:	48b9                	li	a7,14
 ecall
 360:	00000073          	ecall
 ret
 364:	8082                	ret

0000000000000366 <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
 366:	48d9                	li	a7,22
 ecall
 368:	00000073          	ecall
 ret
 36c:	8082                	ret

000000000000036e <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 36e:	1101                	addi	sp,sp,-32
 370:	ec06                	sd	ra,24(sp)
 372:	e822                	sd	s0,16(sp)
 374:	1000                	addi	s0,sp,32
 376:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 37a:	4605                	li	a2,1
 37c:	fef40593          	addi	a1,s0,-17
 380:	f67ff0ef          	jal	2e6 <write>
}
 384:	60e2                	ld	ra,24(sp)
 386:	6442                	ld	s0,16(sp)
 388:	6105                	addi	sp,sp,32
 38a:	8082                	ret

000000000000038c <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 38c:	715d                	addi	sp,sp,-80
 38e:	e486                	sd	ra,72(sp)
 390:	e0a2                	sd	s0,64(sp)
 392:	f84a                	sd	s2,48(sp)
 394:	f44e                	sd	s3,40(sp)
 396:	0880                	addi	s0,sp,80
 398:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 39a:	cac1                	beqz	a3,42a <printint+0x9e>
 39c:	0805d763          	bgez	a1,42a <printint+0x9e>
    neg = 1;
    x = -xx;
 3a0:	40b005bb          	negw	a1,a1
    neg = 1;
 3a4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3a6:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3aa:	86ce                	mv	a3,s3
  i = 0;
 3ac:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ae:	00000817          	auipc	a6,0x0
 3b2:	52a80813          	addi	a6,a6,1322 # 8d8 <digits>
 3b6:	88ba                	mv	a7,a4
 3b8:	0017051b          	addiw	a0,a4,1
 3bc:	872a                	mv	a4,a0
 3be:	02c5f7bb          	remuw	a5,a1,a2
 3c2:	1782                	slli	a5,a5,0x20
 3c4:	9381                	srli	a5,a5,0x20
 3c6:	97c2                	add	a5,a5,a6
 3c8:	0007c783          	lbu	a5,0(a5)
 3cc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3d0:	87ae                	mv	a5,a1
 3d2:	02c5d5bb          	divuw	a1,a1,a2
 3d6:	0685                	addi	a3,a3,1
 3d8:	fcc7ffe3          	bgeu	a5,a2,3b6 <printint+0x2a>
  if(neg)
 3dc:	00030c63          	beqz	t1,3f4 <printint+0x68>
    buf[i++] = '-';
 3e0:	fd050793          	addi	a5,a0,-48
 3e4:	00878533          	add	a0,a5,s0
 3e8:	02d00793          	li	a5,45
 3ec:	fef50423          	sb	a5,-24(a0)
 3f0:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 3f4:	02e05563          	blez	a4,41e <printint+0x92>
 3f8:	fc26                	sd	s1,56(sp)
 3fa:	377d                	addiw	a4,a4,-1
 3fc:	00e984b3          	add	s1,s3,a4
 400:	19fd                	addi	s3,s3,-1
 402:	99ba                	add	s3,s3,a4
 404:	1702                	slli	a4,a4,0x20
 406:	9301                	srli	a4,a4,0x20
 408:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 40c:	0004c583          	lbu	a1,0(s1)
 410:	854a                	mv	a0,s2
 412:	f5dff0ef          	jal	36e <putc>
  while(--i >= 0)
 416:	14fd                	addi	s1,s1,-1
 418:	ff349ae3          	bne	s1,s3,40c <printint+0x80>
 41c:	74e2                	ld	s1,56(sp)
}
 41e:	60a6                	ld	ra,72(sp)
 420:	6406                	ld	s0,64(sp)
 422:	7942                	ld	s2,48(sp)
 424:	79a2                	ld	s3,40(sp)
 426:	6161                	addi	sp,sp,80
 428:	8082                	ret
    x = xx;
 42a:	2581                	sext.w	a1,a1
  neg = 0;
 42c:	4301                	li	t1,0
 42e:	bfa5                	j	3a6 <printint+0x1a>

0000000000000430 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 430:	711d                	addi	sp,sp,-96
 432:	ec86                	sd	ra,88(sp)
 434:	e8a2                	sd	s0,80(sp)
 436:	e4a6                	sd	s1,72(sp)
 438:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 43a:	0005c483          	lbu	s1,0(a1)
 43e:	22048363          	beqz	s1,664 <vprintf+0x234>
 442:	e0ca                	sd	s2,64(sp)
 444:	fc4e                	sd	s3,56(sp)
 446:	f852                	sd	s4,48(sp)
 448:	f456                	sd	s5,40(sp)
 44a:	f05a                	sd	s6,32(sp)
 44c:	ec5e                	sd	s7,24(sp)
 44e:	e862                	sd	s8,16(sp)
 450:	8b2a                	mv	s6,a0
 452:	8a2e                	mv	s4,a1
 454:	8bb2                	mv	s7,a2
  state = 0;
 456:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 458:	4901                	li	s2,0
 45a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 45c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 460:	06400c13          	li	s8,100
 464:	a00d                	j	486 <vprintf+0x56>
        putc(fd, c0);
 466:	85a6                	mv	a1,s1
 468:	855a                	mv	a0,s6
 46a:	f05ff0ef          	jal	36e <putc>
 46e:	a019                	j	474 <vprintf+0x44>
    } else if(state == '%'){
 470:	03598363          	beq	s3,s5,496 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 474:	0019079b          	addiw	a5,s2,1
 478:	893e                	mv	s2,a5
 47a:	873e                	mv	a4,a5
 47c:	97d2                	add	a5,a5,s4
 47e:	0007c483          	lbu	s1,0(a5)
 482:	1c048a63          	beqz	s1,656 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 486:	0004879b          	sext.w	a5,s1
    if(state == 0){
 48a:	fe0993e3          	bnez	s3,470 <vprintf+0x40>
      if(c0 == '%'){
 48e:	fd579ce3          	bne	a5,s5,466 <vprintf+0x36>
        state = '%';
 492:	89be                	mv	s3,a5
 494:	b7c5                	j	474 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 496:	00ea06b3          	add	a3,s4,a4
 49a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 49e:	1c060863          	beqz	a2,66e <vprintf+0x23e>
      if(c0 == 'd'){
 4a2:	03878763          	beq	a5,s8,4d0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4a6:	f9478693          	addi	a3,a5,-108
 4aa:	0016b693          	seqz	a3,a3
 4ae:	f9c60593          	addi	a1,a2,-100
 4b2:	e99d                	bnez	a1,4e8 <vprintf+0xb8>
 4b4:	ca95                	beqz	a3,4e8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4b6:	008b8493          	addi	s1,s7,8
 4ba:	4685                	li	a3,1
 4bc:	4629                	li	a2,10
 4be:	000bb583          	ld	a1,0(s7)
 4c2:	855a                	mv	a0,s6
 4c4:	ec9ff0ef          	jal	38c <printint>
        i += 1;
 4c8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ca:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4cc:	4981                	li	s3,0
 4ce:	b75d                	j	474 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4d0:	008b8493          	addi	s1,s7,8
 4d4:	4685                	li	a3,1
 4d6:	4629                	li	a2,10
 4d8:	000ba583          	lw	a1,0(s7)
 4dc:	855a                	mv	a0,s6
 4de:	eafff0ef          	jal	38c <printint>
 4e2:	8ba6                	mv	s7,s1
      state = 0;
 4e4:	4981                	li	s3,0
 4e6:	b779                	j	474 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 4e8:	9752                	add	a4,a4,s4
 4ea:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 4ee:	f9460713          	addi	a4,a2,-108
 4f2:	00173713          	seqz	a4,a4
 4f6:	8f75                	and	a4,a4,a3
 4f8:	f9c58513          	addi	a0,a1,-100
 4fc:	18051363          	bnez	a0,682 <vprintf+0x252>
 500:	18070163          	beqz	a4,682 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 504:	008b8493          	addi	s1,s7,8
 508:	4685                	li	a3,1
 50a:	4629                	li	a2,10
 50c:	000bb583          	ld	a1,0(s7)
 510:	855a                	mv	a0,s6
 512:	e7bff0ef          	jal	38c <printint>
        i += 2;
 516:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 518:	8ba6                	mv	s7,s1
      state = 0;
 51a:	4981                	li	s3,0
        i += 2;
 51c:	bfa1                	j	474 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 51e:	008b8493          	addi	s1,s7,8
 522:	4681                	li	a3,0
 524:	4629                	li	a2,10
 526:	000be583          	lwu	a1,0(s7)
 52a:	855a                	mv	a0,s6
 52c:	e61ff0ef          	jal	38c <printint>
 530:	8ba6                	mv	s7,s1
      state = 0;
 532:	4981                	li	s3,0
 534:	b781                	j	474 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 536:	008b8493          	addi	s1,s7,8
 53a:	4681                	li	a3,0
 53c:	4629                	li	a2,10
 53e:	000bb583          	ld	a1,0(s7)
 542:	855a                	mv	a0,s6
 544:	e49ff0ef          	jal	38c <printint>
        i += 1;
 548:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 54a:	8ba6                	mv	s7,s1
      state = 0;
 54c:	4981                	li	s3,0
 54e:	b71d                	j	474 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 550:	008b8493          	addi	s1,s7,8
 554:	4681                	li	a3,0
 556:	4629                	li	a2,10
 558:	000bb583          	ld	a1,0(s7)
 55c:	855a                	mv	a0,s6
 55e:	e2fff0ef          	jal	38c <printint>
        i += 2;
 562:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 564:	8ba6                	mv	s7,s1
      state = 0;
 566:	4981                	li	s3,0
        i += 2;
 568:	b731                	j	474 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 56a:	008b8493          	addi	s1,s7,8
 56e:	4681                	li	a3,0
 570:	4641                	li	a2,16
 572:	000be583          	lwu	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e15ff0ef          	jal	38c <printint>
 57c:	8ba6                	mv	s7,s1
      state = 0;
 57e:	4981                	li	s3,0
 580:	bdd5                	j	474 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 582:	008b8493          	addi	s1,s7,8
 586:	4681                	li	a3,0
 588:	4641                	li	a2,16
 58a:	000bb583          	ld	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	dfdff0ef          	jal	38c <printint>
        i += 1;
 594:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 596:	8ba6                	mv	s7,s1
      state = 0;
 598:	4981                	li	s3,0
 59a:	bde9                	j	474 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 59c:	008b8493          	addi	s1,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4641                	li	a2,16
 5a4:	000bb583          	ld	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	de3ff0ef          	jal	38c <printint>
        i += 2;
 5ae:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b0:	8ba6                	mv	s7,s1
      state = 0;
 5b2:	4981                	li	s3,0
        i += 2;
 5b4:	b5c1                	j	474 <vprintf+0x44>
 5b6:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5b8:	008b8793          	addi	a5,s7,8
 5bc:	8cbe                	mv	s9,a5
 5be:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5c2:	03000593          	li	a1,48
 5c6:	855a                	mv	a0,s6
 5c8:	da7ff0ef          	jal	36e <putc>
  putc(fd, 'x');
 5cc:	07800593          	li	a1,120
 5d0:	855a                	mv	a0,s6
 5d2:	d9dff0ef          	jal	36e <putc>
 5d6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5d8:	00000b97          	auipc	s7,0x0
 5dc:	300b8b93          	addi	s7,s7,768 # 8d8 <digits>
 5e0:	03c9d793          	srli	a5,s3,0x3c
 5e4:	97de                	add	a5,a5,s7
 5e6:	0007c583          	lbu	a1,0(a5)
 5ea:	855a                	mv	a0,s6
 5ec:	d83ff0ef          	jal	36e <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 5f0:	0992                	slli	s3,s3,0x4
 5f2:	34fd                	addiw	s1,s1,-1
 5f4:	f4f5                	bnez	s1,5e0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 5f6:	8be6                	mv	s7,s9
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	6ca2                	ld	s9,8(sp)
 5fc:	bda5                	j	474 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 5fe:	008b8493          	addi	s1,s7,8
 602:	000bc583          	lbu	a1,0(s7)
 606:	855a                	mv	a0,s6
 608:	d67ff0ef          	jal	36e <putc>
 60c:	8ba6                	mv	s7,s1
      state = 0;
 60e:	4981                	li	s3,0
 610:	b595                	j	474 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 612:	008b8993          	addi	s3,s7,8
 616:	000bb483          	ld	s1,0(s7)
 61a:	cc91                	beqz	s1,636 <vprintf+0x206>
        for(; *s; s++)
 61c:	0004c583          	lbu	a1,0(s1)
 620:	c985                	beqz	a1,650 <vprintf+0x220>
          putc(fd, *s);
 622:	855a                	mv	a0,s6
 624:	d4bff0ef          	jal	36e <putc>
        for(; *s; s++)
 628:	0485                	addi	s1,s1,1
 62a:	0004c583          	lbu	a1,0(s1)
 62e:	f9f5                	bnez	a1,622 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 630:	8bce                	mv	s7,s3
      state = 0;
 632:	4981                	li	s3,0
 634:	b581                	j	474 <vprintf+0x44>
          s = "(null)";
 636:	00000497          	auipc	s1,0x0
 63a:	29a48493          	addi	s1,s1,666 # 8d0 <malloc+0xfe>
        for(; *s; s++)
 63e:	02800593          	li	a1,40
 642:	b7c5                	j	622 <vprintf+0x1f2>
        putc(fd, '%');
 644:	85be                	mv	a1,a5
 646:	855a                	mv	a0,s6
 648:	d27ff0ef          	jal	36e <putc>
      state = 0;
 64c:	4981                	li	s3,0
 64e:	b51d                	j	474 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 650:	8bce                	mv	s7,s3
      state = 0;
 652:	4981                	li	s3,0
 654:	b505                	j	474 <vprintf+0x44>
 656:	6906                	ld	s2,64(sp)
 658:	79e2                	ld	s3,56(sp)
 65a:	7a42                	ld	s4,48(sp)
 65c:	7aa2                	ld	s5,40(sp)
 65e:	7b02                	ld	s6,32(sp)
 660:	6be2                	ld	s7,24(sp)
 662:	6c42                	ld	s8,16(sp)
    }
  }
}
 664:	60e6                	ld	ra,88(sp)
 666:	6446                	ld	s0,80(sp)
 668:	64a6                	ld	s1,72(sp)
 66a:	6125                	addi	sp,sp,96
 66c:	8082                	ret
      if(c0 == 'd'){
 66e:	06400713          	li	a4,100
 672:	e4e78fe3          	beq	a5,a4,4d0 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 676:	f9478693          	addi	a3,a5,-108
 67a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 67e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 680:	4701                	li	a4,0
      } else if(c0 == 'u'){
 682:	07500513          	li	a0,117
 686:	e8a78ce3          	beq	a5,a0,51e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 68a:	f8b60513          	addi	a0,a2,-117
 68e:	e119                	bnez	a0,694 <vprintf+0x264>
 690:	ea0693e3          	bnez	a3,536 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 694:	f8b58513          	addi	a0,a1,-117
 698:	e119                	bnez	a0,69e <vprintf+0x26e>
 69a:	ea071be3          	bnez	a4,550 <vprintf+0x120>
      } else if(c0 == 'x'){
 69e:	07800513          	li	a0,120
 6a2:	eca784e3          	beq	a5,a0,56a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6a6:	f8860613          	addi	a2,a2,-120
 6aa:	e219                	bnez	a2,6b0 <vprintf+0x280>
 6ac:	ec069be3          	bnez	a3,582 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6b0:	f8858593          	addi	a1,a1,-120
 6b4:	e199                	bnez	a1,6ba <vprintf+0x28a>
 6b6:	ee0713e3          	bnez	a4,59c <vprintf+0x16c>
      } else if(c0 == 'p'){
 6ba:	07000713          	li	a4,112
 6be:	eee78ce3          	beq	a5,a4,5b6 <vprintf+0x186>
      } else if(c0 == 'c'){
 6c2:	06300713          	li	a4,99
 6c6:	f2e78ce3          	beq	a5,a4,5fe <vprintf+0x1ce>
      } else if(c0 == 's'){
 6ca:	07300713          	li	a4,115
 6ce:	f4e782e3          	beq	a5,a4,612 <vprintf+0x1e2>
      } else if(c0 == '%'){
 6d2:	02500713          	li	a4,37
 6d6:	f6e787e3          	beq	a5,a4,644 <vprintf+0x214>
        putc(fd, '%');
 6da:	02500593          	li	a1,37
 6de:	855a                	mv	a0,s6
 6e0:	c8fff0ef          	jal	36e <putc>
        putc(fd, c0);
 6e4:	85a6                	mv	a1,s1
 6e6:	855a                	mv	a0,s6
 6e8:	c87ff0ef          	jal	36e <putc>
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b359                	j	474 <vprintf+0x44>

00000000000006f0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 6f0:	715d                	addi	sp,sp,-80
 6f2:	ec06                	sd	ra,24(sp)
 6f4:	e822                	sd	s0,16(sp)
 6f6:	1000                	addi	s0,sp,32
 6f8:	e010                	sd	a2,0(s0)
 6fa:	e414                	sd	a3,8(s0)
 6fc:	e818                	sd	a4,16(s0)
 6fe:	ec1c                	sd	a5,24(s0)
 700:	03043023          	sd	a6,32(s0)
 704:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 708:	8622                	mv	a2,s0
 70a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 70e:	d23ff0ef          	jal	430 <vprintf>
}
 712:	60e2                	ld	ra,24(sp)
 714:	6442                	ld	s0,16(sp)
 716:	6161                	addi	sp,sp,80
 718:	8082                	ret

000000000000071a <printf>:

void
printf(const char *fmt, ...)
{
 71a:	711d                	addi	sp,sp,-96
 71c:	ec06                	sd	ra,24(sp)
 71e:	e822                	sd	s0,16(sp)
 720:	1000                	addi	s0,sp,32
 722:	e40c                	sd	a1,8(s0)
 724:	e810                	sd	a2,16(s0)
 726:	ec14                	sd	a3,24(s0)
 728:	f018                	sd	a4,32(s0)
 72a:	f41c                	sd	a5,40(s0)
 72c:	03043823          	sd	a6,48(s0)
 730:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 734:	00840613          	addi	a2,s0,8
 738:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 73c:	85aa                	mv	a1,a0
 73e:	4505                	li	a0,1
 740:	cf1ff0ef          	jal	430 <vprintf>
}
 744:	60e2                	ld	ra,24(sp)
 746:	6442                	ld	s0,16(sp)
 748:	6125                	addi	sp,sp,96
 74a:	8082                	ret

000000000000074c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 74c:	1141                	addi	sp,sp,-16
 74e:	e406                	sd	ra,8(sp)
 750:	e022                	sd	s0,0(sp)
 752:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 754:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 758:	00001797          	auipc	a5,0x1
 75c:	8a87b783          	ld	a5,-1880(a5) # 1000 <freep>
 760:	a039                	j	76e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 762:	6398                	ld	a4,0(a5)
 764:	00e7e463          	bltu	a5,a4,76c <free+0x20>
 768:	00e6ea63          	bltu	a3,a4,77c <free+0x30>
{
 76c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 76e:	fed7fae3          	bgeu	a5,a3,762 <free+0x16>
 772:	6398                	ld	a4,0(a5)
 774:	00e6e463          	bltu	a3,a4,77c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 778:	fee7eae3          	bltu	a5,a4,76c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 77c:	ff852583          	lw	a1,-8(a0)
 780:	6390                	ld	a2,0(a5)
 782:	02059813          	slli	a6,a1,0x20
 786:	01c85713          	srli	a4,a6,0x1c
 78a:	9736                	add	a4,a4,a3
 78c:	02e60563          	beq	a2,a4,7b6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 790:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 794:	4790                	lw	a2,8(a5)
 796:	02061593          	slli	a1,a2,0x20
 79a:	01c5d713          	srli	a4,a1,0x1c
 79e:	973e                	add	a4,a4,a5
 7a0:	02e68263          	beq	a3,a4,7c4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7a4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7a6:	00001717          	auipc	a4,0x1
 7aa:	84f73d23          	sd	a5,-1958(a4) # 1000 <freep>
}
 7ae:	60a2                	ld	ra,8(sp)
 7b0:	6402                	ld	s0,0(sp)
 7b2:	0141                	addi	sp,sp,16
 7b4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7b6:	4618                	lw	a4,8(a2)
 7b8:	9f2d                	addw	a4,a4,a1
 7ba:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7be:	6398                	ld	a4,0(a5)
 7c0:	6310                	ld	a2,0(a4)
 7c2:	b7f9                	j	790 <free+0x44>
    p->s.size += bp->s.size;
 7c4:	ff852703          	lw	a4,-8(a0)
 7c8:	9f31                	addw	a4,a4,a2
 7ca:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7cc:	ff053683          	ld	a3,-16(a0)
 7d0:	bfd1                	j	7a4 <free+0x58>

00000000000007d2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7d2:	7139                	addi	sp,sp,-64
 7d4:	fc06                	sd	ra,56(sp)
 7d6:	f822                	sd	s0,48(sp)
 7d8:	f04a                	sd	s2,32(sp)
 7da:	ec4e                	sd	s3,24(sp)
 7dc:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 7de:	02051993          	slli	s3,a0,0x20
 7e2:	0209d993          	srli	s3,s3,0x20
 7e6:	09bd                	addi	s3,s3,15
 7e8:	0049d993          	srli	s3,s3,0x4
 7ec:	2985                	addiw	s3,s3,1
 7ee:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 7f0:	00001517          	auipc	a0,0x1
 7f4:	81053503          	ld	a0,-2032(a0) # 1000 <freep>
 7f8:	c905                	beqz	a0,828 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 7fa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 7fc:	4798                	lw	a4,8(a5)
 7fe:	09377663          	bgeu	a4,s3,88a <malloc+0xb8>
 802:	f426                	sd	s1,40(sp)
 804:	e852                	sd	s4,16(sp)
 806:	e456                	sd	s5,8(sp)
 808:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 80a:	8a4e                	mv	s4,s3
 80c:	6705                	lui	a4,0x1
 80e:	00e9f363          	bgeu	s3,a4,814 <malloc+0x42>
 812:	6a05                	lui	s4,0x1
 814:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 818:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 81c:	00000497          	auipc	s1,0x0
 820:	7e448493          	addi	s1,s1,2020 # 1000 <freep>
  if(p == SBRK_ERROR)
 824:	5afd                	li	s5,-1
 826:	a83d                	j	864 <malloc+0x92>
 828:	f426                	sd	s1,40(sp)
 82a:	e852                	sd	s4,16(sp)
 82c:	e456                	sd	s5,8(sp)
 82e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 830:	00000797          	auipc	a5,0x0
 834:	7e078793          	addi	a5,a5,2016 # 1010 <base>
 838:	00000717          	auipc	a4,0x0
 83c:	7cf73423          	sd	a5,1992(a4) # 1000 <freep>
 840:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 842:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 846:	b7d1                	j	80a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 848:	6398                	ld	a4,0(a5)
 84a:	e118                	sd	a4,0(a0)
 84c:	a899                	j	8a2 <malloc+0xd0>
  hp->s.size = nu;
 84e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 852:	0541                	addi	a0,a0,16
 854:	ef9ff0ef          	jal	74c <free>
  return freep;
 858:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 85a:	c125                	beqz	a0,8ba <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 85e:	4798                	lw	a4,8(a5)
 860:	03277163          	bgeu	a4,s2,882 <malloc+0xb0>
    if(p == freep)
 864:	6098                	ld	a4,0(s1)
 866:	853e                	mv	a0,a5
 868:	fef71ae3          	bne	a4,a5,85c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 86c:	8552                	mv	a0,s4
 86e:	a25ff0ef          	jal	292 <sbrk>
  if(p == SBRK_ERROR)
 872:	fd551ee3          	bne	a0,s5,84e <malloc+0x7c>
        return 0;
 876:	4501                	li	a0,0
 878:	74a2                	ld	s1,40(sp)
 87a:	6a42                	ld	s4,16(sp)
 87c:	6aa2                	ld	s5,8(sp)
 87e:	6b02                	ld	s6,0(sp)
 880:	a03d                	j	8ae <malloc+0xdc>
 882:	74a2                	ld	s1,40(sp)
 884:	6a42                	ld	s4,16(sp)
 886:	6aa2                	ld	s5,8(sp)
 888:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 88a:	fae90fe3          	beq	s2,a4,848 <malloc+0x76>
        p->s.size -= nunits;
 88e:	4137073b          	subw	a4,a4,s3
 892:	c798                	sw	a4,8(a5)
        p += p->s.size;
 894:	02071693          	slli	a3,a4,0x20
 898:	01c6d713          	srli	a4,a3,0x1c
 89c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 89e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8a2:	00000717          	auipc	a4,0x0
 8a6:	74a73f23          	sd	a0,1886(a4) # 1000 <freep>
      return (void*)(p + 1);
 8aa:	01078513          	addi	a0,a5,16
  }
}
 8ae:	70e2                	ld	ra,56(sp)
 8b0:	7442                	ld	s0,48(sp)
 8b2:	7902                	ld	s2,32(sp)
 8b4:	69e2                	ld	s3,24(sp)
 8b6:	6121                	addi	sp,sp,64
 8b8:	8082                	ret
 8ba:	74a2                	ld	s1,40(sp)
 8bc:	6a42                	ld	s4,16(sp)
 8be:	6aa2                	ld	s5,8(sp)
 8c0:	6b02                	ld	s6,0(sp)
 8c2:	b7f5                	j	8ae <malloc+0xdc>
