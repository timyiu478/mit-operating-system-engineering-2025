
user/_zombie:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(void)
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(fork() > 0)
   8:	2c4000ef          	jal	2cc <fork>
   c:	00a04563          	bgtz	a0,16 <main+0x16>
    pause(5);  // Let child exit before parent.
  exit(0);
  10:	4501                	li	a0,0
  12:	2c2000ef          	jal	2d4 <exit>
    pause(5);  // Let child exit before parent.
  16:	4515                	li	a0,5
  18:	34c000ef          	jal	364 <pause>
  1c:	bfd5                	j	10 <main+0x10>

000000000000001e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  1e:	1141                	addi	sp,sp,-16
  20:	e406                	sd	ra,8(sp)
  22:	e022                	sd	s0,0(sp)
  24:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  26:	fdbff0ef          	jal	0 <main>
  exit(r);
  2a:	2aa000ef          	jal	2d4 <exit>

000000000000002e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  2e:	1141                	addi	sp,sp,-16
  30:	e406                	sd	ra,8(sp)
  32:	e022                	sd	s0,0(sp)
  34:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  36:	87aa                	mv	a5,a0
  38:	0585                	addi	a1,a1,1
  3a:	0785                	addi	a5,a5,1
  3c:	fff5c703          	lbu	a4,-1(a1)
  40:	fee78fa3          	sb	a4,-1(a5)
  44:	fb75                	bnez	a4,38 <strcpy+0xa>
    ;
  return os;
}
  46:	60a2                	ld	ra,8(sp)
  48:	6402                	ld	s0,0(sp)
  4a:	0141                	addi	sp,sp,16
  4c:	8082                	ret

000000000000004e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  56:	00054783          	lbu	a5,0(a0)
  5a:	cb91                	beqz	a5,6e <strcmp+0x20>
  5c:	0005c703          	lbu	a4,0(a1)
  60:	00f71763          	bne	a4,a5,6e <strcmp+0x20>
    p++, q++;
  64:	0505                	addi	a0,a0,1
  66:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  68:	00054783          	lbu	a5,0(a0)
  6c:	fbe5                	bnez	a5,5c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  6e:	0005c503          	lbu	a0,0(a1)
}
  72:	40a7853b          	subw	a0,a5,a0
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strlen>:

uint
strlen(const char *s)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cf91                	beqz	a5,a6 <strlen+0x28>
  8c:	00150793          	addi	a5,a0,1
  90:	86be                	mv	a3,a5
  92:	0785                	addi	a5,a5,1
  94:	fff7c703          	lbu	a4,-1(a5)
  98:	ff65                	bnez	a4,90 <strlen+0x12>
  9a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  9e:	60a2                	ld	ra,8(sp)
  a0:	6402                	ld	s0,0(sp)
  a2:	0141                	addi	sp,sp,16
  a4:	8082                	ret
  for(n = 0; s[n]; n++)
  a6:	4501                	li	a0,0
  a8:	bfdd                	j	9e <strlen+0x20>

00000000000000aa <memset>:

void*
memset(void *dst, int c, uint n)
{
  aa:	1141                	addi	sp,sp,-16
  ac:	e406                	sd	ra,8(sp)
  ae:	e022                	sd	s0,0(sp)
  b0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  b2:	ca19                	beqz	a2,c8 <memset+0x1e>
  b4:	87aa                	mv	a5,a0
  b6:	1602                	slli	a2,a2,0x20
  b8:	9201                	srli	a2,a2,0x20
  ba:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  be:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  c2:	0785                	addi	a5,a5,1
  c4:	fee79de3          	bne	a5,a4,be <memset+0x14>
  }
  return dst;
}
  c8:	60a2                	ld	ra,8(sp)
  ca:	6402                	ld	s0,0(sp)
  cc:	0141                	addi	sp,sp,16
  ce:	8082                	ret

00000000000000d0 <strchr>:

char*
strchr(const char *s, char c)
{
  d0:	1141                	addi	sp,sp,-16
  d2:	e406                	sd	ra,8(sp)
  d4:	e022                	sd	s0,0(sp)
  d6:	0800                	addi	s0,sp,16
  for(; *s; s++)
  d8:	00054783          	lbu	a5,0(a0)
  dc:	cf81                	beqz	a5,f4 <strchr+0x24>
    if(*s == c)
  de:	00f58763          	beq	a1,a5,ec <strchr+0x1c>
  for(; *s; s++)
  e2:	0505                	addi	a0,a0,1
  e4:	00054783          	lbu	a5,0(a0)
  e8:	fbfd                	bnez	a5,de <strchr+0xe>
      return (char*)s;
  return 0;
  ea:	4501                	li	a0,0
}
  ec:	60a2                	ld	ra,8(sp)
  ee:	6402                	ld	s0,0(sp)
  f0:	0141                	addi	sp,sp,16
  f2:	8082                	ret
  return 0;
  f4:	4501                	li	a0,0
  f6:	bfdd                	j	ec <strchr+0x1c>

00000000000000f8 <gets>:

char*
gets(char *buf, int max)
{
  f8:	711d                	addi	sp,sp,-96
  fa:	ec86                	sd	ra,88(sp)
  fc:	e8a2                	sd	s0,80(sp)
  fe:	e4a6                	sd	s1,72(sp)
 100:	e0ca                	sd	s2,64(sp)
 102:	fc4e                	sd	s3,56(sp)
 104:	f852                	sd	s4,48(sp)
 106:	f456                	sd	s5,40(sp)
 108:	f05a                	sd	s6,32(sp)
 10a:	ec5e                	sd	s7,24(sp)
 10c:	e862                	sd	s8,16(sp)
 10e:	1080                	addi	s0,sp,96
 110:	8baa                	mv	s7,a0
 112:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 114:	892a                	mv	s2,a0
 116:	4481                	li	s1,0
    cc = read(0, &c, 1);
 118:	faf40b13          	addi	s6,s0,-81
 11c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 11e:	8c26                	mv	s8,s1
 120:	0014899b          	addiw	s3,s1,1
 124:	84ce                	mv	s1,s3
 126:	0349d463          	bge	s3,s4,14e <gets+0x56>
    cc = read(0, &c, 1);
 12a:	8656                	mv	a2,s5
 12c:	85da                	mv	a1,s6
 12e:	4501                	li	a0,0
 130:	1bc000ef          	jal	2ec <read>
    if(cc < 1)
 134:	00a05d63          	blez	a0,14e <gets+0x56>
      break;
    buf[i++] = c;
 138:	faf44783          	lbu	a5,-81(s0)
 13c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 140:	0905                	addi	s2,s2,1
 142:	ff678713          	addi	a4,a5,-10
 146:	c319                	beqz	a4,14c <gets+0x54>
 148:	17cd                	addi	a5,a5,-13
 14a:	fbf1                	bnez	a5,11e <gets+0x26>
    buf[i++] = c;
 14c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 14e:	9c5e                	add	s8,s8,s7
 150:	000c0023          	sb	zero,0(s8)
  return buf;
}
 154:	855e                	mv	a0,s7
 156:	60e6                	ld	ra,88(sp)
 158:	6446                	ld	s0,80(sp)
 15a:	64a6                	ld	s1,72(sp)
 15c:	6906                	ld	s2,64(sp)
 15e:	79e2                	ld	s3,56(sp)
 160:	7a42                	ld	s4,48(sp)
 162:	7aa2                	ld	s5,40(sp)
 164:	7b02                	ld	s6,32(sp)
 166:	6be2                	ld	s7,24(sp)
 168:	6c42                	ld	s8,16(sp)
 16a:	6125                	addi	sp,sp,96
 16c:	8082                	ret

000000000000016e <stat>:

int
stat(const char *n, struct stat *st)
{
 16e:	1101                	addi	sp,sp,-32
 170:	ec06                	sd	ra,24(sp)
 172:	e822                	sd	s0,16(sp)
 174:	e04a                	sd	s2,0(sp)
 176:	1000                	addi	s0,sp,32
 178:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 17a:	4581                	li	a1,0
 17c:	198000ef          	jal	314 <open>
  if(fd < 0)
 180:	02054263          	bltz	a0,1a4 <stat+0x36>
 184:	e426                	sd	s1,8(sp)
 186:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 188:	85ca                	mv	a1,s2
 18a:	1a2000ef          	jal	32c <fstat>
 18e:	892a                	mv	s2,a0
  close(fd);
 190:	8526                	mv	a0,s1
 192:	16a000ef          	jal	2fc <close>
  return r;
 196:	64a2                	ld	s1,8(sp)
}
 198:	854a                	mv	a0,s2
 19a:	60e2                	ld	ra,24(sp)
 19c:	6442                	ld	s0,16(sp)
 19e:	6902                	ld	s2,0(sp)
 1a0:	6105                	addi	sp,sp,32
 1a2:	8082                	ret
    return -1;
 1a4:	57fd                	li	a5,-1
 1a6:	893e                	mv	s2,a5
 1a8:	bfc5                	j	198 <stat+0x2a>

00000000000001aa <atoi>:

int
atoi(const char *s)
{
 1aa:	1141                	addi	sp,sp,-16
 1ac:	e406                	sd	ra,8(sp)
 1ae:	e022                	sd	s0,0(sp)
 1b0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1b2:	00054683          	lbu	a3,0(a0)
 1b6:	fd06879b          	addiw	a5,a3,-48
 1ba:	0ff7f793          	zext.b	a5,a5
 1be:	4625                	li	a2,9
 1c0:	02f66963          	bltu	a2,a5,1f2 <atoi+0x48>
 1c4:	872a                	mv	a4,a0
  n = 0;
 1c6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1c8:	0705                	addi	a4,a4,1
 1ca:	0025179b          	slliw	a5,a0,0x2
 1ce:	9fa9                	addw	a5,a5,a0
 1d0:	0017979b          	slliw	a5,a5,0x1
 1d4:	9fb5                	addw	a5,a5,a3
 1d6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1da:	00074683          	lbu	a3,0(a4)
 1de:	fd06879b          	addiw	a5,a3,-48
 1e2:	0ff7f793          	zext.b	a5,a5
 1e6:	fef671e3          	bgeu	a2,a5,1c8 <atoi+0x1e>
  return n;
}
 1ea:	60a2                	ld	ra,8(sp)
 1ec:	6402                	ld	s0,0(sp)
 1ee:	0141                	addi	sp,sp,16
 1f0:	8082                	ret
  n = 0;
 1f2:	4501                	li	a0,0
 1f4:	bfdd                	j	1ea <atoi+0x40>

00000000000001f6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1f6:	1141                	addi	sp,sp,-16
 1f8:	e406                	sd	ra,8(sp)
 1fa:	e022                	sd	s0,0(sp)
 1fc:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 1fe:	02b57563          	bgeu	a0,a1,228 <memmove+0x32>
    while(n-- > 0)
 202:	00c05f63          	blez	a2,220 <memmove+0x2a>
 206:	1602                	slli	a2,a2,0x20
 208:	9201                	srli	a2,a2,0x20
 20a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 20e:	872a                	mv	a4,a0
      *dst++ = *src++;
 210:	0585                	addi	a1,a1,1
 212:	0705                	addi	a4,a4,1
 214:	fff5c683          	lbu	a3,-1(a1)
 218:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 21c:	fee79ae3          	bne	a5,a4,210 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 220:	60a2                	ld	ra,8(sp)
 222:	6402                	ld	s0,0(sp)
 224:	0141                	addi	sp,sp,16
 226:	8082                	ret
    while(n-- > 0)
 228:	fec05ce3          	blez	a2,220 <memmove+0x2a>
    dst += n;
 22c:	00c50733          	add	a4,a0,a2
    src += n;
 230:	95b2                	add	a1,a1,a2
 232:	fff6079b          	addiw	a5,a2,-1
 236:	1782                	slli	a5,a5,0x20
 238:	9381                	srli	a5,a5,0x20
 23a:	fff7c793          	not	a5,a5
 23e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 240:	15fd                	addi	a1,a1,-1
 242:	177d                	addi	a4,a4,-1
 244:	0005c683          	lbu	a3,0(a1)
 248:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 24c:	fef71ae3          	bne	a4,a5,240 <memmove+0x4a>
 250:	bfc1                	j	220 <memmove+0x2a>

0000000000000252 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 252:	1141                	addi	sp,sp,-16
 254:	e406                	sd	ra,8(sp)
 256:	e022                	sd	s0,0(sp)
 258:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 25a:	c61d                	beqz	a2,288 <memcmp+0x36>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 264:	00054783          	lbu	a5,0(a0)
 268:	0005c703          	lbu	a4,0(a1)
 26c:	00e79863          	bne	a5,a4,27c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 270:	0505                	addi	a0,a0,1
    p2++;
 272:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 274:	fed518e3          	bne	a0,a3,264 <memcmp+0x12>
  }
  return 0;
 278:	4501                	li	a0,0
 27a:	a019                	j	280 <memcmp+0x2e>
      return *p1 - *p2;
 27c:	40e7853b          	subw	a0,a5,a4
}
 280:	60a2                	ld	ra,8(sp)
 282:	6402                	ld	s0,0(sp)
 284:	0141                	addi	sp,sp,16
 286:	8082                	ret
  return 0;
 288:	4501                	li	a0,0
 28a:	bfdd                	j	280 <memcmp+0x2e>

000000000000028c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 28c:	1141                	addi	sp,sp,-16
 28e:	e406                	sd	ra,8(sp)
 290:	e022                	sd	s0,0(sp)
 292:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 294:	f63ff0ef          	jal	1f6 <memmove>
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret

00000000000002a0 <sbrk>:

char *
sbrk(int n) {
 2a0:	1141                	addi	sp,sp,-16
 2a2:	e406                	sd	ra,8(sp)
 2a4:	e022                	sd	s0,0(sp)
 2a6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2a8:	4585                	li	a1,1
 2aa:	0b2000ef          	jal	35c <sys_sbrk>
}
 2ae:	60a2                	ld	ra,8(sp)
 2b0:	6402                	ld	s0,0(sp)
 2b2:	0141                	addi	sp,sp,16
 2b4:	8082                	ret

00000000000002b6 <sbrklazy>:

char *
sbrklazy(int n) {
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2be:	4589                	li	a1,2
 2c0:	09c000ef          	jal	35c <sys_sbrk>
}
 2c4:	60a2                	ld	ra,8(sp)
 2c6:	6402                	ld	s0,0(sp)
 2c8:	0141                	addi	sp,sp,16
 2ca:	8082                	ret

00000000000002cc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2cc:	4885                	li	a7,1
 ecall
 2ce:	00000073          	ecall
 ret
 2d2:	8082                	ret

00000000000002d4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2d4:	4889                	li	a7,2
 ecall
 2d6:	00000073          	ecall
 ret
 2da:	8082                	ret

00000000000002dc <wait>:
.global wait
wait:
 li a7, SYS_wait
 2dc:	488d                	li	a7,3
 ecall
 2de:	00000073          	ecall
 ret
 2e2:	8082                	ret

00000000000002e4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 2e4:	4891                	li	a7,4
 ecall
 2e6:	00000073          	ecall
 ret
 2ea:	8082                	ret

00000000000002ec <read>:
.global read
read:
 li a7, SYS_read
 2ec:	4895                	li	a7,5
 ecall
 2ee:	00000073          	ecall
 ret
 2f2:	8082                	ret

00000000000002f4 <write>:
.global write
write:
 li a7, SYS_write
 2f4:	48c1                	li	a7,16
 ecall
 2f6:	00000073          	ecall
 ret
 2fa:	8082                	ret

00000000000002fc <close>:
.global close
close:
 li a7, SYS_close
 2fc:	48d5                	li	a7,21
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <kill>:
.global kill
kill:
 li a7, SYS_kill
 304:	4899                	li	a7,6
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <exec>:
.global exec
exec:
 li a7, SYS_exec
 30c:	489d                	li	a7,7
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <open>:
.global open
open:
 li a7, SYS_open
 314:	48bd                	li	a7,15
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 31c:	48c5                	li	a7,17
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 324:	48c9                	li	a7,18
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 32c:	48a1                	li	a7,8
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <link>:
.global link
link:
 li a7, SYS_link
 334:	48cd                	li	a7,19
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 33c:	48d1                	li	a7,20
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 344:	48a5                	li	a7,9
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <dup>:
.global dup
dup:
 li a7, SYS_dup
 34c:	48a9                	li	a7,10
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 354:	48ad                	li	a7,11
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 35c:	48b1                	li	a7,12
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <pause>:
.global pause
pause:
 li a7, SYS_pause
 364:	48b5                	li	a7,13
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 36c:	48b9                	li	a7,14
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <bind>:
.global bind
bind:
 li a7, SYS_bind
 374:	48f5                	li	a7,29
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 37c:	48f9                	li	a7,30
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <send>:
.global send
send:
 li a7, SYS_send
 384:	48fd                	li	a7,31
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <recv>:
.global recv
recv:
 li a7, SYS_recv
 38c:	02000893          	li	a7,32
 ecall
 390:	00000073          	ecall
 ret
 394:	8082                	ret

0000000000000396 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 396:	02100893          	li	a7,33
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 3a0:	02200893          	li	a7,34
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 3aa:	02300893          	li	a7,35
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 3b4:	02400893          	li	a7,36
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3be:	1101                	addi	sp,sp,-32
 3c0:	ec06                	sd	ra,24(sp)
 3c2:	e822                	sd	s0,16(sp)
 3c4:	1000                	addi	s0,sp,32
 3c6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ca:	4605                	li	a2,1
 3cc:	fef40593          	addi	a1,s0,-17
 3d0:	f25ff0ef          	jal	2f4 <write>
}
 3d4:	60e2                	ld	ra,24(sp)
 3d6:	6442                	ld	s0,16(sp)
 3d8:	6105                	addi	sp,sp,32
 3da:	8082                	ret

00000000000003dc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3dc:	715d                	addi	sp,sp,-80
 3de:	e486                	sd	ra,72(sp)
 3e0:	e0a2                	sd	s0,64(sp)
 3e2:	f84a                	sd	s2,48(sp)
 3e4:	f44e                	sd	s3,40(sp)
 3e6:	0880                	addi	s0,sp,80
 3e8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3ea:	c6d1                	beqz	a3,476 <printint+0x9a>
 3ec:	0805d563          	bgez	a1,476 <printint+0x9a>
    neg = 1;
    x = -xx;
 3f0:	40b005b3          	neg	a1,a1
    neg = 1;
 3f4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3f6:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3fa:	86ce                	mv	a3,s3
  i = 0;
 3fc:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3fe:	00000817          	auipc	a6,0x0
 402:	5b280813          	addi	a6,a6,1458 # 9b0 <digits>
 406:	88ba                	mv	a7,a4
 408:	0017051b          	addiw	a0,a4,1
 40c:	872a                	mv	a4,a0
 40e:	02c5f7b3          	remu	a5,a1,a2
 412:	97c2                	add	a5,a5,a6
 414:	0007c783          	lbu	a5,0(a5)
 418:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 41c:	87ae                	mv	a5,a1
 41e:	02c5d5b3          	divu	a1,a1,a2
 422:	0685                	addi	a3,a3,1
 424:	fec7f1e3          	bgeu	a5,a2,406 <printint+0x2a>
  if(neg)
 428:	00030c63          	beqz	t1,440 <printint+0x64>
    buf[i++] = '-';
 42c:	fd050793          	addi	a5,a0,-48
 430:	00878533          	add	a0,a5,s0
 434:	02d00793          	li	a5,45
 438:	fef50423          	sb	a5,-24(a0)
 43c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 440:	02e05563          	blez	a4,46a <printint+0x8e>
 444:	fc26                	sd	s1,56(sp)
 446:	377d                	addiw	a4,a4,-1
 448:	00e984b3          	add	s1,s3,a4
 44c:	19fd                	addi	s3,s3,-1
 44e:	99ba                	add	s3,s3,a4
 450:	1702                	slli	a4,a4,0x20
 452:	9301                	srli	a4,a4,0x20
 454:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 458:	0004c583          	lbu	a1,0(s1)
 45c:	854a                	mv	a0,s2
 45e:	f61ff0ef          	jal	3be <putc>
  while(--i >= 0)
 462:	14fd                	addi	s1,s1,-1
 464:	ff349ae3          	bne	s1,s3,458 <printint+0x7c>
 468:	74e2                	ld	s1,56(sp)
}
 46a:	60a6                	ld	ra,72(sp)
 46c:	6406                	ld	s0,64(sp)
 46e:	7942                	ld	s2,48(sp)
 470:	79a2                	ld	s3,40(sp)
 472:	6161                	addi	sp,sp,80
 474:	8082                	ret
  neg = 0;
 476:	4301                	li	t1,0
 478:	bfbd                	j	3f6 <printint+0x1a>

000000000000047a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 47a:	711d                	addi	sp,sp,-96
 47c:	ec86                	sd	ra,88(sp)
 47e:	e8a2                	sd	s0,80(sp)
 480:	e4a6                	sd	s1,72(sp)
 482:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 484:	0005c483          	lbu	s1,0(a1)
 488:	22048363          	beqz	s1,6ae <vprintf+0x234>
 48c:	e0ca                	sd	s2,64(sp)
 48e:	fc4e                	sd	s3,56(sp)
 490:	f852                	sd	s4,48(sp)
 492:	f456                	sd	s5,40(sp)
 494:	f05a                	sd	s6,32(sp)
 496:	ec5e                	sd	s7,24(sp)
 498:	e862                	sd	s8,16(sp)
 49a:	8b2a                	mv	s6,a0
 49c:	8a2e                	mv	s4,a1
 49e:	8bb2                	mv	s7,a2
  state = 0;
 4a0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4a2:	4901                	li	s2,0
 4a4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4a6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4aa:	06400c13          	li	s8,100
 4ae:	a00d                	j	4d0 <vprintf+0x56>
        putc(fd, c0);
 4b0:	85a6                	mv	a1,s1
 4b2:	855a                	mv	a0,s6
 4b4:	f0bff0ef          	jal	3be <putc>
 4b8:	a019                	j	4be <vprintf+0x44>
    } else if(state == '%'){
 4ba:	03598363          	beq	s3,s5,4e0 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4be:	0019079b          	addiw	a5,s2,1
 4c2:	893e                	mv	s2,a5
 4c4:	873e                	mv	a4,a5
 4c6:	97d2                	add	a5,a5,s4
 4c8:	0007c483          	lbu	s1,0(a5)
 4cc:	1c048a63          	beqz	s1,6a0 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4d0:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4d4:	fe0993e3          	bnez	s3,4ba <vprintf+0x40>
      if(c0 == '%'){
 4d8:	fd579ce3          	bne	a5,s5,4b0 <vprintf+0x36>
        state = '%';
 4dc:	89be                	mv	s3,a5
 4de:	b7c5                	j	4be <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4e0:	00ea06b3          	add	a3,s4,a4
 4e4:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4e8:	1c060863          	beqz	a2,6b8 <vprintf+0x23e>
      if(c0 == 'd'){
 4ec:	03878763          	beq	a5,s8,51a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4f0:	f9478693          	addi	a3,a5,-108
 4f4:	0016b693          	seqz	a3,a3
 4f8:	f9c60593          	addi	a1,a2,-100
 4fc:	e99d                	bnez	a1,532 <vprintf+0xb8>
 4fe:	ca95                	beqz	a3,532 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 500:	008b8493          	addi	s1,s7,8
 504:	4685                	li	a3,1
 506:	4629                	li	a2,10
 508:	000bb583          	ld	a1,0(s7)
 50c:	855a                	mv	a0,s6
 50e:	ecfff0ef          	jal	3dc <printint>
        i += 1;
 512:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 514:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 516:	4981                	li	s3,0
 518:	b75d                	j	4be <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 51a:	008b8493          	addi	s1,s7,8
 51e:	4685                	li	a3,1
 520:	4629                	li	a2,10
 522:	000ba583          	lw	a1,0(s7)
 526:	855a                	mv	a0,s6
 528:	eb5ff0ef          	jal	3dc <printint>
 52c:	8ba6                	mv	s7,s1
      state = 0;
 52e:	4981                	li	s3,0
 530:	b779                	j	4be <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 532:	9752                	add	a4,a4,s4
 534:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 538:	f9460713          	addi	a4,a2,-108
 53c:	00173713          	seqz	a4,a4
 540:	8f75                	and	a4,a4,a3
 542:	f9c58513          	addi	a0,a1,-100
 546:	18051363          	bnez	a0,6cc <vprintf+0x252>
 54a:	18070163          	beqz	a4,6cc <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 54e:	008b8493          	addi	s1,s7,8
 552:	4685                	li	a3,1
 554:	4629                	li	a2,10
 556:	000bb583          	ld	a1,0(s7)
 55a:	855a                	mv	a0,s6
 55c:	e81ff0ef          	jal	3dc <printint>
        i += 2;
 560:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 562:	8ba6                	mv	s7,s1
      state = 0;
 564:	4981                	li	s3,0
        i += 2;
 566:	bfa1                	j	4be <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 568:	008b8493          	addi	s1,s7,8
 56c:	4681                	li	a3,0
 56e:	4629                	li	a2,10
 570:	000be583          	lwu	a1,0(s7)
 574:	855a                	mv	a0,s6
 576:	e67ff0ef          	jal	3dc <printint>
 57a:	8ba6                	mv	s7,s1
      state = 0;
 57c:	4981                	li	s3,0
 57e:	b781                	j	4be <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 580:	008b8493          	addi	s1,s7,8
 584:	4681                	li	a3,0
 586:	4629                	li	a2,10
 588:	000bb583          	ld	a1,0(s7)
 58c:	855a                	mv	a0,s6
 58e:	e4fff0ef          	jal	3dc <printint>
        i += 1;
 592:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 594:	8ba6                	mv	s7,s1
      state = 0;
 596:	4981                	li	s3,0
 598:	b71d                	j	4be <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	008b8493          	addi	s1,s7,8
 59e:	4681                	li	a3,0
 5a0:	4629                	li	a2,10
 5a2:	000bb583          	ld	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	e35ff0ef          	jal	3dc <printint>
        i += 2;
 5ac:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	8ba6                	mv	s7,s1
      state = 0;
 5b0:	4981                	li	s3,0
        i += 2;
 5b2:	b731                	j	4be <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4641                	li	a2,16
 5bc:	000be583          	lwu	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e1bff0ef          	jal	3dc <printint>
 5c6:	8ba6                	mv	s7,s1
      state = 0;
 5c8:	4981                	li	s3,0
 5ca:	bdd5                	j	4be <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5cc:	008b8493          	addi	s1,s7,8
 5d0:	4681                	li	a3,0
 5d2:	4641                	li	a2,16
 5d4:	000bb583          	ld	a1,0(s7)
 5d8:	855a                	mv	a0,s6
 5da:	e03ff0ef          	jal	3dc <printint>
        i += 1;
 5de:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e0:	8ba6                	mv	s7,s1
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bde9                	j	4be <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e6:	008b8493          	addi	s1,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4641                	li	a2,16
 5ee:	000bb583          	ld	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	de9ff0ef          	jal	3dc <printint>
        i += 2;
 5f8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fa:	8ba6                	mv	s7,s1
      state = 0;
 5fc:	4981                	li	s3,0
        i += 2;
 5fe:	b5c1                	j	4be <vprintf+0x44>
 600:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 602:	008b8793          	addi	a5,s7,8
 606:	8cbe                	mv	s9,a5
 608:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 60c:	03000593          	li	a1,48
 610:	855a                	mv	a0,s6
 612:	dadff0ef          	jal	3be <putc>
  putc(fd, 'x');
 616:	07800593          	li	a1,120
 61a:	855a                	mv	a0,s6
 61c:	da3ff0ef          	jal	3be <putc>
 620:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 622:	00000b97          	auipc	s7,0x0
 626:	38eb8b93          	addi	s7,s7,910 # 9b0 <digits>
 62a:	03c9d793          	srli	a5,s3,0x3c
 62e:	97de                	add	a5,a5,s7
 630:	0007c583          	lbu	a1,0(a5)
 634:	855a                	mv	a0,s6
 636:	d89ff0ef          	jal	3be <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 63a:	0992                	slli	s3,s3,0x4
 63c:	34fd                	addiw	s1,s1,-1
 63e:	f4f5                	bnez	s1,62a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 640:	8be6                	mv	s7,s9
      state = 0;
 642:	4981                	li	s3,0
 644:	6ca2                	ld	s9,8(sp)
 646:	bda5                	j	4be <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 648:	008b8493          	addi	s1,s7,8
 64c:	000bc583          	lbu	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	d6dff0ef          	jal	3be <putc>
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
 65a:	b595                	j	4be <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 65c:	008b8993          	addi	s3,s7,8
 660:	000bb483          	ld	s1,0(s7)
 664:	cc91                	beqz	s1,680 <vprintf+0x206>
        for(; *s; s++)
 666:	0004c583          	lbu	a1,0(s1)
 66a:	c985                	beqz	a1,69a <vprintf+0x220>
          putc(fd, *s);
 66c:	855a                	mv	a0,s6
 66e:	d51ff0ef          	jal	3be <putc>
        for(; *s; s++)
 672:	0485                	addi	s1,s1,1
 674:	0004c583          	lbu	a1,0(s1)
 678:	f9f5                	bnez	a1,66c <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 67a:	8bce                	mv	s7,s3
      state = 0;
 67c:	4981                	li	s3,0
 67e:	b581                	j	4be <vprintf+0x44>
          s = "(null)";
 680:	00000497          	auipc	s1,0x0
 684:	30048493          	addi	s1,s1,768 # 980 <statistics+0x72>
        for(; *s; s++)
 688:	02800593          	li	a1,40
 68c:	b7c5                	j	66c <vprintf+0x1f2>
        putc(fd, '%');
 68e:	85be                	mv	a1,a5
 690:	855a                	mv	a0,s6
 692:	d2dff0ef          	jal	3be <putc>
      state = 0;
 696:	4981                	li	s3,0
 698:	b51d                	j	4be <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 69a:	8bce                	mv	s7,s3
      state = 0;
 69c:	4981                	li	s3,0
 69e:	b505                	j	4be <vprintf+0x44>
 6a0:	6906                	ld	s2,64(sp)
 6a2:	79e2                	ld	s3,56(sp)
 6a4:	7a42                	ld	s4,48(sp)
 6a6:	7aa2                	ld	s5,40(sp)
 6a8:	7b02                	ld	s6,32(sp)
 6aa:	6be2                	ld	s7,24(sp)
 6ac:	6c42                	ld	s8,16(sp)
    }
  }
}
 6ae:	60e6                	ld	ra,88(sp)
 6b0:	6446                	ld	s0,80(sp)
 6b2:	64a6                	ld	s1,72(sp)
 6b4:	6125                	addi	sp,sp,96
 6b6:	8082                	ret
      if(c0 == 'd'){
 6b8:	06400713          	li	a4,100
 6bc:	e4e78fe3          	beq	a5,a4,51a <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6c0:	f9478693          	addi	a3,a5,-108
 6c4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6c8:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6ca:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6cc:	07500513          	li	a0,117
 6d0:	e8a78ce3          	beq	a5,a0,568 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6d4:	f8b60513          	addi	a0,a2,-117
 6d8:	e119                	bnez	a0,6de <vprintf+0x264>
 6da:	ea0693e3          	bnez	a3,580 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6de:	f8b58513          	addi	a0,a1,-117
 6e2:	e119                	bnez	a0,6e8 <vprintf+0x26e>
 6e4:	ea071be3          	bnez	a4,59a <vprintf+0x120>
      } else if(c0 == 'x'){
 6e8:	07800513          	li	a0,120
 6ec:	eca784e3          	beq	a5,a0,5b4 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6f0:	f8860613          	addi	a2,a2,-120
 6f4:	e219                	bnez	a2,6fa <vprintf+0x280>
 6f6:	ec069be3          	bnez	a3,5cc <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6fa:	f8858593          	addi	a1,a1,-120
 6fe:	e199                	bnez	a1,704 <vprintf+0x28a>
 700:	ee0713e3          	bnez	a4,5e6 <vprintf+0x16c>
      } else if(c0 == 'p'){
 704:	07000713          	li	a4,112
 708:	eee78ce3          	beq	a5,a4,600 <vprintf+0x186>
      } else if(c0 == 'c'){
 70c:	06300713          	li	a4,99
 710:	f2e78ce3          	beq	a5,a4,648 <vprintf+0x1ce>
      } else if(c0 == 's'){
 714:	07300713          	li	a4,115
 718:	f4e782e3          	beq	a5,a4,65c <vprintf+0x1e2>
      } else if(c0 == '%'){
 71c:	02500713          	li	a4,37
 720:	f6e787e3          	beq	a5,a4,68e <vprintf+0x214>
        putc(fd, '%');
 724:	02500593          	li	a1,37
 728:	855a                	mv	a0,s6
 72a:	c95ff0ef          	jal	3be <putc>
        putc(fd, c0);
 72e:	85a6                	mv	a1,s1
 730:	855a                	mv	a0,s6
 732:	c8dff0ef          	jal	3be <putc>
      state = 0;
 736:	4981                	li	s3,0
 738:	b359                	j	4be <vprintf+0x44>

000000000000073a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 73a:	715d                	addi	sp,sp,-80
 73c:	ec06                	sd	ra,24(sp)
 73e:	e822                	sd	s0,16(sp)
 740:	1000                	addi	s0,sp,32
 742:	e010                	sd	a2,0(s0)
 744:	e414                	sd	a3,8(s0)
 746:	e818                	sd	a4,16(s0)
 748:	ec1c                	sd	a5,24(s0)
 74a:	03043023          	sd	a6,32(s0)
 74e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 752:	8622                	mv	a2,s0
 754:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 758:	d23ff0ef          	jal	47a <vprintf>
}
 75c:	60e2                	ld	ra,24(sp)
 75e:	6442                	ld	s0,16(sp)
 760:	6161                	addi	sp,sp,80
 762:	8082                	ret

0000000000000764 <printf>:

void
printf(const char *fmt, ...)
{
 764:	711d                	addi	sp,sp,-96
 766:	ec06                	sd	ra,24(sp)
 768:	e822                	sd	s0,16(sp)
 76a:	1000                	addi	s0,sp,32
 76c:	e40c                	sd	a1,8(s0)
 76e:	e810                	sd	a2,16(s0)
 770:	ec14                	sd	a3,24(s0)
 772:	f018                	sd	a4,32(s0)
 774:	f41c                	sd	a5,40(s0)
 776:	03043823          	sd	a6,48(s0)
 77a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 77e:	00840613          	addi	a2,s0,8
 782:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 786:	85aa                	mv	a1,a0
 788:	4505                	li	a0,1
 78a:	cf1ff0ef          	jal	47a <vprintf>
}
 78e:	60e2                	ld	ra,24(sp)
 790:	6442                	ld	s0,16(sp)
 792:	6125                	addi	sp,sp,96
 794:	8082                	ret

0000000000000796 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 796:	1141                	addi	sp,sp,-16
 798:	e406                	sd	ra,8(sp)
 79a:	e022                	sd	s0,0(sp)
 79c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 79e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a2:	00001797          	auipc	a5,0x1
 7a6:	85e7b783          	ld	a5,-1954(a5) # 1000 <freep>
 7aa:	a039                	j	7b8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ac:	6398                	ld	a4,0(a5)
 7ae:	00e7e463          	bltu	a5,a4,7b6 <free+0x20>
 7b2:	00e6ea63          	bltu	a3,a4,7c6 <free+0x30>
{
 7b6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7b8:	fed7fae3          	bgeu	a5,a3,7ac <free+0x16>
 7bc:	6398                	ld	a4,0(a5)
 7be:	00e6e463          	bltu	a3,a4,7c6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c2:	fee7eae3          	bltu	a5,a4,7b6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7c6:	ff852583          	lw	a1,-8(a0)
 7ca:	6390                	ld	a2,0(a5)
 7cc:	02059813          	slli	a6,a1,0x20
 7d0:	01c85713          	srli	a4,a6,0x1c
 7d4:	9736                	add	a4,a4,a3
 7d6:	02e60563          	beq	a2,a4,800 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7da:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7de:	4790                	lw	a2,8(a5)
 7e0:	02061593          	slli	a1,a2,0x20
 7e4:	01c5d713          	srli	a4,a1,0x1c
 7e8:	973e                	add	a4,a4,a5
 7ea:	02e68263          	beq	a3,a4,80e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7ee:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7f0:	00001717          	auipc	a4,0x1
 7f4:	80f73823          	sd	a5,-2032(a4) # 1000 <freep>
}
 7f8:	60a2                	ld	ra,8(sp)
 7fa:	6402                	ld	s0,0(sp)
 7fc:	0141                	addi	sp,sp,16
 7fe:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 800:	4618                	lw	a4,8(a2)
 802:	9f2d                	addw	a4,a4,a1
 804:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 808:	6398                	ld	a4,0(a5)
 80a:	6310                	ld	a2,0(a4)
 80c:	b7f9                	j	7da <free+0x44>
    p->s.size += bp->s.size;
 80e:	ff852703          	lw	a4,-8(a0)
 812:	9f31                	addw	a4,a4,a2
 814:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 816:	ff053683          	ld	a3,-16(a0)
 81a:	bfd1                	j	7ee <free+0x58>

000000000000081c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 81c:	7139                	addi	sp,sp,-64
 81e:	fc06                	sd	ra,56(sp)
 820:	f822                	sd	s0,48(sp)
 822:	f04a                	sd	s2,32(sp)
 824:	ec4e                	sd	s3,24(sp)
 826:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 828:	02051993          	slli	s3,a0,0x20
 82c:	0209d993          	srli	s3,s3,0x20
 830:	09bd                	addi	s3,s3,15
 832:	0049d993          	srli	s3,s3,0x4
 836:	2985                	addiw	s3,s3,1
 838:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 83a:	00000517          	auipc	a0,0x0
 83e:	7c653503          	ld	a0,1990(a0) # 1000 <freep>
 842:	c905                	beqz	a0,872 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 844:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 846:	4798                	lw	a4,8(a5)
 848:	09377663          	bgeu	a4,s3,8d4 <malloc+0xb8>
 84c:	f426                	sd	s1,40(sp)
 84e:	e852                	sd	s4,16(sp)
 850:	e456                	sd	s5,8(sp)
 852:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 854:	8a4e                	mv	s4,s3
 856:	6705                	lui	a4,0x1
 858:	00e9f363          	bgeu	s3,a4,85e <malloc+0x42>
 85c:	6a05                	lui	s4,0x1
 85e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 862:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 866:	00000497          	auipc	s1,0x0
 86a:	79a48493          	addi	s1,s1,1946 # 1000 <freep>
  if(p == SBRK_ERROR)
 86e:	5afd                	li	s5,-1
 870:	a83d                	j	8ae <malloc+0x92>
 872:	f426                	sd	s1,40(sp)
 874:	e852                	sd	s4,16(sp)
 876:	e456                	sd	s5,8(sp)
 878:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 87a:	00000797          	auipc	a5,0x0
 87e:	79678793          	addi	a5,a5,1942 # 1010 <base>
 882:	00000717          	auipc	a4,0x0
 886:	76f73f23          	sd	a5,1918(a4) # 1000 <freep>
 88a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 88c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 890:	b7d1                	j	854 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 892:	6398                	ld	a4,0(a5)
 894:	e118                	sd	a4,0(a0)
 896:	a899                	j	8ec <malloc+0xd0>
  hp->s.size = nu;
 898:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 89c:	0541                	addi	a0,a0,16
 89e:	ef9ff0ef          	jal	796 <free>
  return freep;
 8a2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8a4:	c125                	beqz	a0,904 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8a6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8a8:	4798                	lw	a4,8(a5)
 8aa:	03277163          	bgeu	a4,s2,8cc <malloc+0xb0>
    if(p == freep)
 8ae:	6098                	ld	a4,0(s1)
 8b0:	853e                	mv	a0,a5
 8b2:	fef71ae3          	bne	a4,a5,8a6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8b6:	8552                	mv	a0,s4
 8b8:	9e9ff0ef          	jal	2a0 <sbrk>
  if(p == SBRK_ERROR)
 8bc:	fd551ee3          	bne	a0,s5,898 <malloc+0x7c>
        return 0;
 8c0:	4501                	li	a0,0
 8c2:	74a2                	ld	s1,40(sp)
 8c4:	6a42                	ld	s4,16(sp)
 8c6:	6aa2                	ld	s5,8(sp)
 8c8:	6b02                	ld	s6,0(sp)
 8ca:	a03d                	j	8f8 <malloc+0xdc>
 8cc:	74a2                	ld	s1,40(sp)
 8ce:	6a42                	ld	s4,16(sp)
 8d0:	6aa2                	ld	s5,8(sp)
 8d2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8d4:	fae90fe3          	beq	s2,a4,892 <malloc+0x76>
        p->s.size -= nunits;
 8d8:	4137073b          	subw	a4,a4,s3
 8dc:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8de:	02071693          	slli	a3,a4,0x20
 8e2:	01c6d713          	srli	a4,a3,0x1c
 8e6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8e8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8ec:	00000717          	auipc	a4,0x0
 8f0:	70a73a23          	sd	a0,1812(a4) # 1000 <freep>
      return (void*)(p + 1);
 8f4:	01078513          	addi	a0,a5,16
  }
}
 8f8:	70e2                	ld	ra,56(sp)
 8fa:	7442                	ld	s0,48(sp)
 8fc:	7902                	ld	s2,32(sp)
 8fe:	69e2                	ld	s3,24(sp)
 900:	6121                	addi	sp,sp,64
 902:	8082                	ret
 904:	74a2                	ld	s1,40(sp)
 906:	6a42                	ld	s4,16(sp)
 908:	6aa2                	ld	s5,8(sp)
 90a:	6b02                	ld	s6,0(sp)
 90c:	b7f5                	j	8f8 <malloc+0xdc>

000000000000090e <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 90e:	7179                	addi	sp,sp,-48
 910:	f406                	sd	ra,40(sp)
 912:	f022                	sd	s0,32(sp)
 914:	ec26                	sd	s1,24(sp)
 916:	e84a                	sd	s2,16(sp)
 918:	e44e                	sd	s3,8(sp)
 91a:	e052                	sd	s4,0(sp)
 91c:	1800                	addi	s0,sp,48
 91e:	8a2a                	mv	s4,a0
 920:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 922:	4581                	li	a1,0
 924:	00000517          	auipc	a0,0x0
 928:	06450513          	addi	a0,a0,100 # 988 <statistics+0x7a>
 92c:	9e9ff0ef          	jal	314 <open>
  if(fd < 0) {
 930:	02054e63          	bltz	a0,96c <statistics+0x5e>
 934:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 936:	4481                	li	s1,0
 938:	01205e63          	blez	s2,954 <statistics+0x46>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 93c:	4099063b          	subw	a2,s2,s1
 940:	009a05b3          	add	a1,s4,s1
 944:	854e                	mv	a0,s3
 946:	9a7ff0ef          	jal	2ec <read>
 94a:	00054563          	bltz	a0,954 <statistics+0x46>
      break;
    }
    i += n;
 94e:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 950:	ff24c6e3          	blt	s1,s2,93c <statistics+0x2e>
  }
  close(fd);
 954:	854e                	mv	a0,s3
 956:	9a7ff0ef          	jal	2fc <close>
  return i;
}
 95a:	8526                	mv	a0,s1
 95c:	70a2                	ld	ra,40(sp)
 95e:	7402                	ld	s0,32(sp)
 960:	64e2                	ld	s1,24(sp)
 962:	6942                	ld	s2,16(sp)
 964:	69a2                	ld	s3,8(sp)
 966:	6a02                	ld	s4,0(sp)
 968:	6145                	addi	sp,sp,48
 96a:	8082                	ret
      fprintf(2, "stats: open failed\n");
 96c:	00000597          	auipc	a1,0x0
 970:	02c58593          	addi	a1,a1,44 # 998 <statistics+0x8a>
 974:	4509                	li	a0,2
 976:	dc5ff0ef          	jal	73a <fprintf>
      exit(1);
 97a:	4505                	li	a0,1
 97c:	959ff0ef          	jal	2d4 <exit>
