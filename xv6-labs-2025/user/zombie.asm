
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

00000000000003aa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3aa:	1101                	addi	sp,sp,-32
 3ac:	ec06                	sd	ra,24(sp)
 3ae:	e822                	sd	s0,16(sp)
 3b0:	1000                	addi	s0,sp,32
 3b2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3b6:	4605                	li	a2,1
 3b8:	fef40593          	addi	a1,s0,-17
 3bc:	f39ff0ef          	jal	2f4 <write>
}
 3c0:	60e2                	ld	ra,24(sp)
 3c2:	6442                	ld	s0,16(sp)
 3c4:	6105                	addi	sp,sp,32
 3c6:	8082                	ret

00000000000003c8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3c8:	715d                	addi	sp,sp,-80
 3ca:	e486                	sd	ra,72(sp)
 3cc:	e0a2                	sd	s0,64(sp)
 3ce:	f84a                	sd	s2,48(sp)
 3d0:	f44e                	sd	s3,40(sp)
 3d2:	0880                	addi	s0,sp,80
 3d4:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 3d6:	c6d1                	beqz	a3,462 <printint+0x9a>
 3d8:	0805d563          	bgez	a1,462 <printint+0x9a>
    neg = 1;
    x = -xx;
 3dc:	40b005b3          	neg	a1,a1
    neg = 1;
 3e0:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3e2:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3e6:	86ce                	mv	a3,s3
  i = 0;
 3e8:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3ea:	00000817          	auipc	a6,0x0
 3ee:	51e80813          	addi	a6,a6,1310 # 908 <digits>
 3f2:	88ba                	mv	a7,a4
 3f4:	0017051b          	addiw	a0,a4,1
 3f8:	872a                	mv	a4,a0
 3fa:	02c5f7b3          	remu	a5,a1,a2
 3fe:	97c2                	add	a5,a5,a6
 400:	0007c783          	lbu	a5,0(a5)
 404:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 408:	87ae                	mv	a5,a1
 40a:	02c5d5b3          	divu	a1,a1,a2
 40e:	0685                	addi	a3,a3,1
 410:	fec7f1e3          	bgeu	a5,a2,3f2 <printint+0x2a>
  if(neg)
 414:	00030c63          	beqz	t1,42c <printint+0x64>
    buf[i++] = '-';
 418:	fd050793          	addi	a5,a0,-48
 41c:	00878533          	add	a0,a5,s0
 420:	02d00793          	li	a5,45
 424:	fef50423          	sb	a5,-24(a0)
 428:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 42c:	02e05563          	blez	a4,456 <printint+0x8e>
 430:	fc26                	sd	s1,56(sp)
 432:	377d                	addiw	a4,a4,-1
 434:	00e984b3          	add	s1,s3,a4
 438:	19fd                	addi	s3,s3,-1
 43a:	99ba                	add	s3,s3,a4
 43c:	1702                	slli	a4,a4,0x20
 43e:	9301                	srli	a4,a4,0x20
 440:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 444:	0004c583          	lbu	a1,0(s1)
 448:	854a                	mv	a0,s2
 44a:	f61ff0ef          	jal	3aa <putc>
  while(--i >= 0)
 44e:	14fd                	addi	s1,s1,-1
 450:	ff349ae3          	bne	s1,s3,444 <printint+0x7c>
 454:	74e2                	ld	s1,56(sp)
}
 456:	60a6                	ld	ra,72(sp)
 458:	6406                	ld	s0,64(sp)
 45a:	7942                	ld	s2,48(sp)
 45c:	79a2                	ld	s3,40(sp)
 45e:	6161                	addi	sp,sp,80
 460:	8082                	ret
  neg = 0;
 462:	4301                	li	t1,0
 464:	bfbd                	j	3e2 <printint+0x1a>

0000000000000466 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 466:	711d                	addi	sp,sp,-96
 468:	ec86                	sd	ra,88(sp)
 46a:	e8a2                	sd	s0,80(sp)
 46c:	e4a6                	sd	s1,72(sp)
 46e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 470:	0005c483          	lbu	s1,0(a1)
 474:	22048363          	beqz	s1,69a <vprintf+0x234>
 478:	e0ca                	sd	s2,64(sp)
 47a:	fc4e                	sd	s3,56(sp)
 47c:	f852                	sd	s4,48(sp)
 47e:	f456                	sd	s5,40(sp)
 480:	f05a                	sd	s6,32(sp)
 482:	ec5e                	sd	s7,24(sp)
 484:	e862                	sd	s8,16(sp)
 486:	8b2a                	mv	s6,a0
 488:	8a2e                	mv	s4,a1
 48a:	8bb2                	mv	s7,a2
  state = 0;
 48c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 48e:	4901                	li	s2,0
 490:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 492:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 496:	06400c13          	li	s8,100
 49a:	a00d                	j	4bc <vprintf+0x56>
        putc(fd, c0);
 49c:	85a6                	mv	a1,s1
 49e:	855a                	mv	a0,s6
 4a0:	f0bff0ef          	jal	3aa <putc>
 4a4:	a019                	j	4aa <vprintf+0x44>
    } else if(state == '%'){
 4a6:	03598363          	beq	s3,s5,4cc <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4aa:	0019079b          	addiw	a5,s2,1
 4ae:	893e                	mv	s2,a5
 4b0:	873e                	mv	a4,a5
 4b2:	97d2                	add	a5,a5,s4
 4b4:	0007c483          	lbu	s1,0(a5)
 4b8:	1c048a63          	beqz	s1,68c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4bc:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4c0:	fe0993e3          	bnez	s3,4a6 <vprintf+0x40>
      if(c0 == '%'){
 4c4:	fd579ce3          	bne	a5,s5,49c <vprintf+0x36>
        state = '%';
 4c8:	89be                	mv	s3,a5
 4ca:	b7c5                	j	4aa <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4cc:	00ea06b3          	add	a3,s4,a4
 4d0:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4d4:	1c060863          	beqz	a2,6a4 <vprintf+0x23e>
      if(c0 == 'd'){
 4d8:	03878763          	beq	a5,s8,506 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4dc:	f9478693          	addi	a3,a5,-108
 4e0:	0016b693          	seqz	a3,a3
 4e4:	f9c60593          	addi	a1,a2,-100
 4e8:	e99d                	bnez	a1,51e <vprintf+0xb8>
 4ea:	ca95                	beqz	a3,51e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ec:	008b8493          	addi	s1,s7,8
 4f0:	4685                	li	a3,1
 4f2:	4629                	li	a2,10
 4f4:	000bb583          	ld	a1,0(s7)
 4f8:	855a                	mv	a0,s6
 4fa:	ecfff0ef          	jal	3c8 <printint>
        i += 1;
 4fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 500:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 502:	4981                	li	s3,0
 504:	b75d                	j	4aa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 506:	008b8493          	addi	s1,s7,8
 50a:	4685                	li	a3,1
 50c:	4629                	li	a2,10
 50e:	000ba583          	lw	a1,0(s7)
 512:	855a                	mv	a0,s6
 514:	eb5ff0ef          	jal	3c8 <printint>
 518:	8ba6                	mv	s7,s1
      state = 0;
 51a:	4981                	li	s3,0
 51c:	b779                	j	4aa <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 51e:	9752                	add	a4,a4,s4
 520:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 524:	f9460713          	addi	a4,a2,-108
 528:	00173713          	seqz	a4,a4
 52c:	8f75                	and	a4,a4,a3
 52e:	f9c58513          	addi	a0,a1,-100
 532:	18051363          	bnez	a0,6b8 <vprintf+0x252>
 536:	18070163          	beqz	a4,6b8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53a:	008b8493          	addi	s1,s7,8
 53e:	4685                	li	a3,1
 540:	4629                	li	a2,10
 542:	000bb583          	ld	a1,0(s7)
 546:	855a                	mv	a0,s6
 548:	e81ff0ef          	jal	3c8 <printint>
        i += 2;
 54c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 54e:	8ba6                	mv	s7,s1
      state = 0;
 550:	4981                	li	s3,0
        i += 2;
 552:	bfa1                	j	4aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 554:	008b8493          	addi	s1,s7,8
 558:	4681                	li	a3,0
 55a:	4629                	li	a2,10
 55c:	000be583          	lwu	a1,0(s7)
 560:	855a                	mv	a0,s6
 562:	e67ff0ef          	jal	3c8 <printint>
 566:	8ba6                	mv	s7,s1
      state = 0;
 568:	4981                	li	s3,0
 56a:	b781                	j	4aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 56c:	008b8493          	addi	s1,s7,8
 570:	4681                	li	a3,0
 572:	4629                	li	a2,10
 574:	000bb583          	ld	a1,0(s7)
 578:	855a                	mv	a0,s6
 57a:	e4fff0ef          	jal	3c8 <printint>
        i += 1;
 57e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 580:	8ba6                	mv	s7,s1
      state = 0;
 582:	4981                	li	s3,0
 584:	b71d                	j	4aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	008b8493          	addi	s1,s7,8
 58a:	4681                	li	a3,0
 58c:	4629                	li	a2,10
 58e:	000bb583          	ld	a1,0(s7)
 592:	855a                	mv	a0,s6
 594:	e35ff0ef          	jal	3c8 <printint>
        i += 2;
 598:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	8ba6                	mv	s7,s1
      state = 0;
 59c:	4981                	li	s3,0
        i += 2;
 59e:	b731                	j	4aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5a0:	008b8493          	addi	s1,s7,8
 5a4:	4681                	li	a3,0
 5a6:	4641                	li	a2,16
 5a8:	000be583          	lwu	a1,0(s7)
 5ac:	855a                	mv	a0,s6
 5ae:	e1bff0ef          	jal	3c8 <printint>
 5b2:	8ba6                	mv	s7,s1
      state = 0;
 5b4:	4981                	li	s3,0
 5b6:	bdd5                	j	4aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	008b8493          	addi	s1,s7,8
 5bc:	4681                	li	a3,0
 5be:	4641                	li	a2,16
 5c0:	000bb583          	ld	a1,0(s7)
 5c4:	855a                	mv	a0,s6
 5c6:	e03ff0ef          	jal	3c8 <printint>
        i += 1;
 5ca:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5cc:	8ba6                	mv	s7,s1
      state = 0;
 5ce:	4981                	li	s3,0
 5d0:	bde9                	j	4aa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d2:	008b8493          	addi	s1,s7,8
 5d6:	4681                	li	a3,0
 5d8:	4641                	li	a2,16
 5da:	000bb583          	ld	a1,0(s7)
 5de:	855a                	mv	a0,s6
 5e0:	de9ff0ef          	jal	3c8 <printint>
        i += 2;
 5e4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e6:	8ba6                	mv	s7,s1
      state = 0;
 5e8:	4981                	li	s3,0
        i += 2;
 5ea:	b5c1                	j	4aa <vprintf+0x44>
 5ec:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5ee:	008b8793          	addi	a5,s7,8
 5f2:	8cbe                	mv	s9,a5
 5f4:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5f8:	03000593          	li	a1,48
 5fc:	855a                	mv	a0,s6
 5fe:	dadff0ef          	jal	3aa <putc>
  putc(fd, 'x');
 602:	07800593          	li	a1,120
 606:	855a                	mv	a0,s6
 608:	da3ff0ef          	jal	3aa <putc>
 60c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 60e:	00000b97          	auipc	s7,0x0
 612:	2fab8b93          	addi	s7,s7,762 # 908 <digits>
 616:	03c9d793          	srli	a5,s3,0x3c
 61a:	97de                	add	a5,a5,s7
 61c:	0007c583          	lbu	a1,0(a5)
 620:	855a                	mv	a0,s6
 622:	d89ff0ef          	jal	3aa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 626:	0992                	slli	s3,s3,0x4
 628:	34fd                	addiw	s1,s1,-1
 62a:	f4f5                	bnez	s1,616 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 62c:	8be6                	mv	s7,s9
      state = 0;
 62e:	4981                	li	s3,0
 630:	6ca2                	ld	s9,8(sp)
 632:	bda5                	j	4aa <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 634:	008b8493          	addi	s1,s7,8
 638:	000bc583          	lbu	a1,0(s7)
 63c:	855a                	mv	a0,s6
 63e:	d6dff0ef          	jal	3aa <putc>
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
 646:	b595                	j	4aa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 648:	008b8993          	addi	s3,s7,8
 64c:	000bb483          	ld	s1,0(s7)
 650:	cc91                	beqz	s1,66c <vprintf+0x206>
        for(; *s; s++)
 652:	0004c583          	lbu	a1,0(s1)
 656:	c985                	beqz	a1,686 <vprintf+0x220>
          putc(fd, *s);
 658:	855a                	mv	a0,s6
 65a:	d51ff0ef          	jal	3aa <putc>
        for(; *s; s++)
 65e:	0485                	addi	s1,s1,1
 660:	0004c583          	lbu	a1,0(s1)
 664:	f9f5                	bnez	a1,658 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 666:	8bce                	mv	s7,s3
      state = 0;
 668:	4981                	li	s3,0
 66a:	b581                	j	4aa <vprintf+0x44>
          s = "(null)";
 66c:	00000497          	auipc	s1,0x0
 670:	29448493          	addi	s1,s1,660 # 900 <malloc+0xf8>
        for(; *s; s++)
 674:	02800593          	li	a1,40
 678:	b7c5                	j	658 <vprintf+0x1f2>
        putc(fd, '%');
 67a:	85be                	mv	a1,a5
 67c:	855a                	mv	a0,s6
 67e:	d2dff0ef          	jal	3aa <putc>
      state = 0;
 682:	4981                	li	s3,0
 684:	b51d                	j	4aa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 686:	8bce                	mv	s7,s3
      state = 0;
 688:	4981                	li	s3,0
 68a:	b505                	j	4aa <vprintf+0x44>
 68c:	6906                	ld	s2,64(sp)
 68e:	79e2                	ld	s3,56(sp)
 690:	7a42                	ld	s4,48(sp)
 692:	7aa2                	ld	s5,40(sp)
 694:	7b02                	ld	s6,32(sp)
 696:	6be2                	ld	s7,24(sp)
 698:	6c42                	ld	s8,16(sp)
    }
  }
}
 69a:	60e6                	ld	ra,88(sp)
 69c:	6446                	ld	s0,80(sp)
 69e:	64a6                	ld	s1,72(sp)
 6a0:	6125                	addi	sp,sp,96
 6a2:	8082                	ret
      if(c0 == 'd'){
 6a4:	06400713          	li	a4,100
 6a8:	e4e78fe3          	beq	a5,a4,506 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6ac:	f9478693          	addi	a3,a5,-108
 6b0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6b4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6b6:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6b8:	07500513          	li	a0,117
 6bc:	e8a78ce3          	beq	a5,a0,554 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6c0:	f8b60513          	addi	a0,a2,-117
 6c4:	e119                	bnez	a0,6ca <vprintf+0x264>
 6c6:	ea0693e3          	bnez	a3,56c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6ca:	f8b58513          	addi	a0,a1,-117
 6ce:	e119                	bnez	a0,6d4 <vprintf+0x26e>
 6d0:	ea071be3          	bnez	a4,586 <vprintf+0x120>
      } else if(c0 == 'x'){
 6d4:	07800513          	li	a0,120
 6d8:	eca784e3          	beq	a5,a0,5a0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6dc:	f8860613          	addi	a2,a2,-120
 6e0:	e219                	bnez	a2,6e6 <vprintf+0x280>
 6e2:	ec069be3          	bnez	a3,5b8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6e6:	f8858593          	addi	a1,a1,-120
 6ea:	e199                	bnez	a1,6f0 <vprintf+0x28a>
 6ec:	ee0713e3          	bnez	a4,5d2 <vprintf+0x16c>
      } else if(c0 == 'p'){
 6f0:	07000713          	li	a4,112
 6f4:	eee78ce3          	beq	a5,a4,5ec <vprintf+0x186>
      } else if(c0 == 'c'){
 6f8:	06300713          	li	a4,99
 6fc:	f2e78ce3          	beq	a5,a4,634 <vprintf+0x1ce>
      } else if(c0 == 's'){
 700:	07300713          	li	a4,115
 704:	f4e782e3          	beq	a5,a4,648 <vprintf+0x1e2>
      } else if(c0 == '%'){
 708:	02500713          	li	a4,37
 70c:	f6e787e3          	beq	a5,a4,67a <vprintf+0x214>
        putc(fd, '%');
 710:	02500593          	li	a1,37
 714:	855a                	mv	a0,s6
 716:	c95ff0ef          	jal	3aa <putc>
        putc(fd, c0);
 71a:	85a6                	mv	a1,s1
 71c:	855a                	mv	a0,s6
 71e:	c8dff0ef          	jal	3aa <putc>
      state = 0;
 722:	4981                	li	s3,0
 724:	b359                	j	4aa <vprintf+0x44>

0000000000000726 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 726:	715d                	addi	sp,sp,-80
 728:	ec06                	sd	ra,24(sp)
 72a:	e822                	sd	s0,16(sp)
 72c:	1000                	addi	s0,sp,32
 72e:	e010                	sd	a2,0(s0)
 730:	e414                	sd	a3,8(s0)
 732:	e818                	sd	a4,16(s0)
 734:	ec1c                	sd	a5,24(s0)
 736:	03043023          	sd	a6,32(s0)
 73a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 73e:	8622                	mv	a2,s0
 740:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 744:	d23ff0ef          	jal	466 <vprintf>
}
 748:	60e2                	ld	ra,24(sp)
 74a:	6442                	ld	s0,16(sp)
 74c:	6161                	addi	sp,sp,80
 74e:	8082                	ret

0000000000000750 <printf>:

void
printf(const char *fmt, ...)
{
 750:	711d                	addi	sp,sp,-96
 752:	ec06                	sd	ra,24(sp)
 754:	e822                	sd	s0,16(sp)
 756:	1000                	addi	s0,sp,32
 758:	e40c                	sd	a1,8(s0)
 75a:	e810                	sd	a2,16(s0)
 75c:	ec14                	sd	a3,24(s0)
 75e:	f018                	sd	a4,32(s0)
 760:	f41c                	sd	a5,40(s0)
 762:	03043823          	sd	a6,48(s0)
 766:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 76a:	00840613          	addi	a2,s0,8
 76e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 772:	85aa                	mv	a1,a0
 774:	4505                	li	a0,1
 776:	cf1ff0ef          	jal	466 <vprintf>
}
 77a:	60e2                	ld	ra,24(sp)
 77c:	6442                	ld	s0,16(sp)
 77e:	6125                	addi	sp,sp,96
 780:	8082                	ret

0000000000000782 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 782:	1141                	addi	sp,sp,-16
 784:	e406                	sd	ra,8(sp)
 786:	e022                	sd	s0,0(sp)
 788:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 78a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 78e:	00001797          	auipc	a5,0x1
 792:	8727b783          	ld	a5,-1934(a5) # 1000 <freep>
 796:	a039                	j	7a4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 798:	6398                	ld	a4,0(a5)
 79a:	00e7e463          	bltu	a5,a4,7a2 <free+0x20>
 79e:	00e6ea63          	bltu	a3,a4,7b2 <free+0x30>
{
 7a2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7a4:	fed7fae3          	bgeu	a5,a3,798 <free+0x16>
 7a8:	6398                	ld	a4,0(a5)
 7aa:	00e6e463          	bltu	a3,a4,7b2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ae:	fee7eae3          	bltu	a5,a4,7a2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7b2:	ff852583          	lw	a1,-8(a0)
 7b6:	6390                	ld	a2,0(a5)
 7b8:	02059813          	slli	a6,a1,0x20
 7bc:	01c85713          	srli	a4,a6,0x1c
 7c0:	9736                	add	a4,a4,a3
 7c2:	02e60563          	beq	a2,a4,7ec <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7c6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7ca:	4790                	lw	a2,8(a5)
 7cc:	02061593          	slli	a1,a2,0x20
 7d0:	01c5d713          	srli	a4,a1,0x1c
 7d4:	973e                	add	a4,a4,a5
 7d6:	02e68263          	beq	a3,a4,7fa <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7da:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7dc:	00001717          	auipc	a4,0x1
 7e0:	82f73223          	sd	a5,-2012(a4) # 1000 <freep>
}
 7e4:	60a2                	ld	ra,8(sp)
 7e6:	6402                	ld	s0,0(sp)
 7e8:	0141                	addi	sp,sp,16
 7ea:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7ec:	4618                	lw	a4,8(a2)
 7ee:	9f2d                	addw	a4,a4,a1
 7f0:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	6398                	ld	a4,0(a5)
 7f6:	6310                	ld	a2,0(a4)
 7f8:	b7f9                	j	7c6 <free+0x44>
    p->s.size += bp->s.size;
 7fa:	ff852703          	lw	a4,-8(a0)
 7fe:	9f31                	addw	a4,a4,a2
 800:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 802:	ff053683          	ld	a3,-16(a0)
 806:	bfd1                	j	7da <free+0x58>

0000000000000808 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 808:	7139                	addi	sp,sp,-64
 80a:	fc06                	sd	ra,56(sp)
 80c:	f822                	sd	s0,48(sp)
 80e:	f04a                	sd	s2,32(sp)
 810:	ec4e                	sd	s3,24(sp)
 812:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 814:	02051993          	slli	s3,a0,0x20
 818:	0209d993          	srli	s3,s3,0x20
 81c:	09bd                	addi	s3,s3,15
 81e:	0049d993          	srli	s3,s3,0x4
 822:	2985                	addiw	s3,s3,1
 824:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 826:	00000517          	auipc	a0,0x0
 82a:	7da53503          	ld	a0,2010(a0) # 1000 <freep>
 82e:	c905                	beqz	a0,85e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 830:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 832:	4798                	lw	a4,8(a5)
 834:	09377663          	bgeu	a4,s3,8c0 <malloc+0xb8>
 838:	f426                	sd	s1,40(sp)
 83a:	e852                	sd	s4,16(sp)
 83c:	e456                	sd	s5,8(sp)
 83e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 840:	8a4e                	mv	s4,s3
 842:	6705                	lui	a4,0x1
 844:	00e9f363          	bgeu	s3,a4,84a <malloc+0x42>
 848:	6a05                	lui	s4,0x1
 84a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 84e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 852:	00000497          	auipc	s1,0x0
 856:	7ae48493          	addi	s1,s1,1966 # 1000 <freep>
  if(p == SBRK_ERROR)
 85a:	5afd                	li	s5,-1
 85c:	a83d                	j	89a <malloc+0x92>
 85e:	f426                	sd	s1,40(sp)
 860:	e852                	sd	s4,16(sp)
 862:	e456                	sd	s5,8(sp)
 864:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 866:	00000797          	auipc	a5,0x0
 86a:	7aa78793          	addi	a5,a5,1962 # 1010 <base>
 86e:	00000717          	auipc	a4,0x0
 872:	78f73923          	sd	a5,1938(a4) # 1000 <freep>
 876:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 878:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 87c:	b7d1                	j	840 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 87e:	6398                	ld	a4,0(a5)
 880:	e118                	sd	a4,0(a0)
 882:	a899                	j	8d8 <malloc+0xd0>
  hp->s.size = nu;
 884:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 888:	0541                	addi	a0,a0,16
 88a:	ef9ff0ef          	jal	782 <free>
  return freep;
 88e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 890:	c125                	beqz	a0,8f0 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 892:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 894:	4798                	lw	a4,8(a5)
 896:	03277163          	bgeu	a4,s2,8b8 <malloc+0xb0>
    if(p == freep)
 89a:	6098                	ld	a4,0(s1)
 89c:	853e                	mv	a0,a5
 89e:	fef71ae3          	bne	a4,a5,892 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8a2:	8552                	mv	a0,s4
 8a4:	9fdff0ef          	jal	2a0 <sbrk>
  if(p == SBRK_ERROR)
 8a8:	fd551ee3          	bne	a0,s5,884 <malloc+0x7c>
        return 0;
 8ac:	4501                	li	a0,0
 8ae:	74a2                	ld	s1,40(sp)
 8b0:	6a42                	ld	s4,16(sp)
 8b2:	6aa2                	ld	s5,8(sp)
 8b4:	6b02                	ld	s6,0(sp)
 8b6:	a03d                	j	8e4 <malloc+0xdc>
 8b8:	74a2                	ld	s1,40(sp)
 8ba:	6a42                	ld	s4,16(sp)
 8bc:	6aa2                	ld	s5,8(sp)
 8be:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8c0:	fae90fe3          	beq	s2,a4,87e <malloc+0x76>
        p->s.size -= nunits;
 8c4:	4137073b          	subw	a4,a4,s3
 8c8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8ca:	02071693          	slli	a3,a4,0x20
 8ce:	01c6d713          	srli	a4,a3,0x1c
 8d2:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8d4:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8d8:	00000717          	auipc	a4,0x0
 8dc:	72a73423          	sd	a0,1832(a4) # 1000 <freep>
      return (void*)(p + 1);
 8e0:	01078513          	addi	a0,a5,16
  }
}
 8e4:	70e2                	ld	ra,56(sp)
 8e6:	7442                	ld	s0,48(sp)
 8e8:	7902                	ld	s2,32(sp)
 8ea:	69e2                	ld	s3,24(sp)
 8ec:	6121                	addi	sp,sp,64
 8ee:	8082                	ret
 8f0:	74a2                	ld	s1,40(sp)
 8f2:	6a42                	ld	s4,16(sp)
 8f4:	6aa2                	ld	s5,8(sp)
 8f6:	6b02                	ld	s6,0(sp)
 8f8:	b7f5                	j	8e4 <malloc+0xdc>
