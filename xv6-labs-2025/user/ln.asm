
user/_ln:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/stat.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	1000                	addi	s0,sp,32
  if(argc != 3){
   8:	478d                	li	a5,3
   a:	00f50d63          	beq	a0,a5,24 <main+0x24>
   e:	e426                	sd	s1,8(sp)
    fprintf(2, "Usage: ln old new\n");
  10:	00001597          	auipc	a1,0x1
  14:	92058593          	addi	a1,a1,-1760 # 930 <malloc+0xf8>
  18:	4509                	li	a0,2
  1a:	73c000ef          	jal	756 <fprintf>
    exit(1);
  1e:	4505                	li	a0,1
  20:	2e4000ef          	jal	304 <exit>
  24:	e426                	sd	s1,8(sp)
  26:	84ae                	mv	s1,a1
  }
  if(link(argv[1], argv[2]) < 0)
  28:	698c                	ld	a1,16(a1)
  2a:	6488                	ld	a0,8(s1)
  2c:	338000ef          	jal	364 <link>
  30:	00054563          	bltz	a0,3a <main+0x3a>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  exit(0);
  34:	4501                	li	a0,0
  36:	2ce000ef          	jal	304 <exit>
    fprintf(2, "link %s %s: failed\n", argv[1], argv[2]);
  3a:	6894                	ld	a3,16(s1)
  3c:	6490                	ld	a2,8(s1)
  3e:	00001597          	auipc	a1,0x1
  42:	90a58593          	addi	a1,a1,-1782 # 948 <malloc+0x110>
  46:	4509                	li	a0,2
  48:	70e000ef          	jal	756 <fprintf>
  4c:	b7e5                	j	34 <main+0x34>

000000000000004e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  4e:	1141                	addi	sp,sp,-16
  50:	e406                	sd	ra,8(sp)
  52:	e022                	sd	s0,0(sp)
  54:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  56:	fabff0ef          	jal	0 <main>
  exit(r);
  5a:	2aa000ef          	jal	304 <exit>

000000000000005e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  5e:	1141                	addi	sp,sp,-16
  60:	e406                	sd	ra,8(sp)
  62:	e022                	sd	s0,0(sp)
  64:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  66:	87aa                	mv	a5,a0
  68:	0585                	addi	a1,a1,1
  6a:	0785                	addi	a5,a5,1
  6c:	fff5c703          	lbu	a4,-1(a1)
  70:	fee78fa3          	sb	a4,-1(a5)
  74:	fb75                	bnez	a4,68 <strcpy+0xa>
    ;
  return os;
}
  76:	60a2                	ld	ra,8(sp)
  78:	6402                	ld	s0,0(sp)
  7a:	0141                	addi	sp,sp,16
  7c:	8082                	ret

000000000000007e <strcmp>:

int
strcmp(const char *p, const char *q)
{
  7e:	1141                	addi	sp,sp,-16
  80:	e406                	sd	ra,8(sp)
  82:	e022                	sd	s0,0(sp)
  84:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  86:	00054783          	lbu	a5,0(a0)
  8a:	cb91                	beqz	a5,9e <strcmp+0x20>
  8c:	0005c703          	lbu	a4,0(a1)
  90:	00f71763          	bne	a4,a5,9e <strcmp+0x20>
    p++, q++;
  94:	0505                	addi	a0,a0,1
  96:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  98:	00054783          	lbu	a5,0(a0)
  9c:	fbe5                	bnez	a5,8c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  9e:	0005c503          	lbu	a0,0(a1)
}
  a2:	40a7853b          	subw	a0,a5,a0
  a6:	60a2                	ld	ra,8(sp)
  a8:	6402                	ld	s0,0(sp)
  aa:	0141                	addi	sp,sp,16
  ac:	8082                	ret

00000000000000ae <strlen>:

uint
strlen(const char *s)
{
  ae:	1141                	addi	sp,sp,-16
  b0:	e406                	sd	ra,8(sp)
  b2:	e022                	sd	s0,0(sp)
  b4:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  b6:	00054783          	lbu	a5,0(a0)
  ba:	cf91                	beqz	a5,d6 <strlen+0x28>
  bc:	00150793          	addi	a5,a0,1
  c0:	86be                	mv	a3,a5
  c2:	0785                	addi	a5,a5,1
  c4:	fff7c703          	lbu	a4,-1(a5)
  c8:	ff65                	bnez	a4,c0 <strlen+0x12>
  ca:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ce:	60a2                	ld	ra,8(sp)
  d0:	6402                	ld	s0,0(sp)
  d2:	0141                	addi	sp,sp,16
  d4:	8082                	ret
  for(n = 0; s[n]; n++)
  d6:	4501                	li	a0,0
  d8:	bfdd                	j	ce <strlen+0x20>

00000000000000da <memset>:

void*
memset(void *dst, int c, uint n)
{
  da:	1141                	addi	sp,sp,-16
  dc:	e406                	sd	ra,8(sp)
  de:	e022                	sd	s0,0(sp)
  e0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  e2:	ca19                	beqz	a2,f8 <memset+0x1e>
  e4:	87aa                	mv	a5,a0
  e6:	1602                	slli	a2,a2,0x20
  e8:	9201                	srli	a2,a2,0x20
  ea:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  ee:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  f2:	0785                	addi	a5,a5,1
  f4:	fee79de3          	bne	a5,a4,ee <memset+0x14>
  }
  return dst;
}
  f8:	60a2                	ld	ra,8(sp)
  fa:	6402                	ld	s0,0(sp)
  fc:	0141                	addi	sp,sp,16
  fe:	8082                	ret

0000000000000100 <strchr>:

char*
strchr(const char *s, char c)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  for(; *s; s++)
 108:	00054783          	lbu	a5,0(a0)
 10c:	cf81                	beqz	a5,124 <strchr+0x24>
    if(*s == c)
 10e:	00f58763          	beq	a1,a5,11c <strchr+0x1c>
  for(; *s; s++)
 112:	0505                	addi	a0,a0,1
 114:	00054783          	lbu	a5,0(a0)
 118:	fbfd                	bnez	a5,10e <strchr+0xe>
      return (char*)s;
  return 0;
 11a:	4501                	li	a0,0
}
 11c:	60a2                	ld	ra,8(sp)
 11e:	6402                	ld	s0,0(sp)
 120:	0141                	addi	sp,sp,16
 122:	8082                	ret
  return 0;
 124:	4501                	li	a0,0
 126:	bfdd                	j	11c <strchr+0x1c>

0000000000000128 <gets>:

char*
gets(char *buf, int max)
{
 128:	711d                	addi	sp,sp,-96
 12a:	ec86                	sd	ra,88(sp)
 12c:	e8a2                	sd	s0,80(sp)
 12e:	e4a6                	sd	s1,72(sp)
 130:	e0ca                	sd	s2,64(sp)
 132:	fc4e                	sd	s3,56(sp)
 134:	f852                	sd	s4,48(sp)
 136:	f456                	sd	s5,40(sp)
 138:	f05a                	sd	s6,32(sp)
 13a:	ec5e                	sd	s7,24(sp)
 13c:	e862                	sd	s8,16(sp)
 13e:	1080                	addi	s0,sp,96
 140:	8baa                	mv	s7,a0
 142:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 144:	892a                	mv	s2,a0
 146:	4481                	li	s1,0
    cc = read(0, &c, 1);
 148:	faf40b13          	addi	s6,s0,-81
 14c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 14e:	8c26                	mv	s8,s1
 150:	0014899b          	addiw	s3,s1,1
 154:	84ce                	mv	s1,s3
 156:	0349d463          	bge	s3,s4,17e <gets+0x56>
    cc = read(0, &c, 1);
 15a:	8656                	mv	a2,s5
 15c:	85da                	mv	a1,s6
 15e:	4501                	li	a0,0
 160:	1bc000ef          	jal	31c <read>
    if(cc < 1)
 164:	00a05d63          	blez	a0,17e <gets+0x56>
      break;
    buf[i++] = c;
 168:	faf44783          	lbu	a5,-81(s0)
 16c:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 170:	0905                	addi	s2,s2,1
 172:	ff678713          	addi	a4,a5,-10
 176:	c319                	beqz	a4,17c <gets+0x54>
 178:	17cd                	addi	a5,a5,-13
 17a:	fbf1                	bnez	a5,14e <gets+0x26>
    buf[i++] = c;
 17c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 17e:	9c5e                	add	s8,s8,s7
 180:	000c0023          	sb	zero,0(s8)
  return buf;
}
 184:	855e                	mv	a0,s7
 186:	60e6                	ld	ra,88(sp)
 188:	6446                	ld	s0,80(sp)
 18a:	64a6                	ld	s1,72(sp)
 18c:	6906                	ld	s2,64(sp)
 18e:	79e2                	ld	s3,56(sp)
 190:	7a42                	ld	s4,48(sp)
 192:	7aa2                	ld	s5,40(sp)
 194:	7b02                	ld	s6,32(sp)
 196:	6be2                	ld	s7,24(sp)
 198:	6c42                	ld	s8,16(sp)
 19a:	6125                	addi	sp,sp,96
 19c:	8082                	ret

000000000000019e <stat>:

int
stat(const char *n, struct stat *st)
{
 19e:	1101                	addi	sp,sp,-32
 1a0:	ec06                	sd	ra,24(sp)
 1a2:	e822                	sd	s0,16(sp)
 1a4:	e04a                	sd	s2,0(sp)
 1a6:	1000                	addi	s0,sp,32
 1a8:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1aa:	4581                	li	a1,0
 1ac:	198000ef          	jal	344 <open>
  if(fd < 0)
 1b0:	02054263          	bltz	a0,1d4 <stat+0x36>
 1b4:	e426                	sd	s1,8(sp)
 1b6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1b8:	85ca                	mv	a1,s2
 1ba:	1a2000ef          	jal	35c <fstat>
 1be:	892a                	mv	s2,a0
  close(fd);
 1c0:	8526                	mv	a0,s1
 1c2:	16a000ef          	jal	32c <close>
  return r;
 1c6:	64a2                	ld	s1,8(sp)
}
 1c8:	854a                	mv	a0,s2
 1ca:	60e2                	ld	ra,24(sp)
 1cc:	6442                	ld	s0,16(sp)
 1ce:	6902                	ld	s2,0(sp)
 1d0:	6105                	addi	sp,sp,32
 1d2:	8082                	ret
    return -1;
 1d4:	57fd                	li	a5,-1
 1d6:	893e                	mv	s2,a5
 1d8:	bfc5                	j	1c8 <stat+0x2a>

00000000000001da <atoi>:

int
atoi(const char *s)
{
 1da:	1141                	addi	sp,sp,-16
 1dc:	e406                	sd	ra,8(sp)
 1de:	e022                	sd	s0,0(sp)
 1e0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1e2:	00054683          	lbu	a3,0(a0)
 1e6:	fd06879b          	addiw	a5,a3,-48
 1ea:	0ff7f793          	zext.b	a5,a5
 1ee:	4625                	li	a2,9
 1f0:	02f66963          	bltu	a2,a5,222 <atoi+0x48>
 1f4:	872a                	mv	a4,a0
  n = 0;
 1f6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1f8:	0705                	addi	a4,a4,1
 1fa:	0025179b          	slliw	a5,a0,0x2
 1fe:	9fa9                	addw	a5,a5,a0
 200:	0017979b          	slliw	a5,a5,0x1
 204:	9fb5                	addw	a5,a5,a3
 206:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 20a:	00074683          	lbu	a3,0(a4)
 20e:	fd06879b          	addiw	a5,a3,-48
 212:	0ff7f793          	zext.b	a5,a5
 216:	fef671e3          	bgeu	a2,a5,1f8 <atoi+0x1e>
  return n;
}
 21a:	60a2                	ld	ra,8(sp)
 21c:	6402                	ld	s0,0(sp)
 21e:	0141                	addi	sp,sp,16
 220:	8082                	ret
  n = 0;
 222:	4501                	li	a0,0
 224:	bfdd                	j	21a <atoi+0x40>

0000000000000226 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 226:	1141                	addi	sp,sp,-16
 228:	e406                	sd	ra,8(sp)
 22a:	e022                	sd	s0,0(sp)
 22c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 22e:	02b57563          	bgeu	a0,a1,258 <memmove+0x32>
    while(n-- > 0)
 232:	00c05f63          	blez	a2,250 <memmove+0x2a>
 236:	1602                	slli	a2,a2,0x20
 238:	9201                	srli	a2,a2,0x20
 23a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 23e:	872a                	mv	a4,a0
      *dst++ = *src++;
 240:	0585                	addi	a1,a1,1
 242:	0705                	addi	a4,a4,1
 244:	fff5c683          	lbu	a3,-1(a1)
 248:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 24c:	fee79ae3          	bne	a5,a4,240 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 250:	60a2                	ld	ra,8(sp)
 252:	6402                	ld	s0,0(sp)
 254:	0141                	addi	sp,sp,16
 256:	8082                	ret
    while(n-- > 0)
 258:	fec05ce3          	blez	a2,250 <memmove+0x2a>
    dst += n;
 25c:	00c50733          	add	a4,a0,a2
    src += n;
 260:	95b2                	add	a1,a1,a2
 262:	fff6079b          	addiw	a5,a2,-1
 266:	1782                	slli	a5,a5,0x20
 268:	9381                	srli	a5,a5,0x20
 26a:	fff7c793          	not	a5,a5
 26e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 270:	15fd                	addi	a1,a1,-1
 272:	177d                	addi	a4,a4,-1
 274:	0005c683          	lbu	a3,0(a1)
 278:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 27c:	fef71ae3          	bne	a4,a5,270 <memmove+0x4a>
 280:	bfc1                	j	250 <memmove+0x2a>

0000000000000282 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 282:	1141                	addi	sp,sp,-16
 284:	e406                	sd	ra,8(sp)
 286:	e022                	sd	s0,0(sp)
 288:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 28a:	c61d                	beqz	a2,2b8 <memcmp+0x36>
 28c:	1602                	slli	a2,a2,0x20
 28e:	9201                	srli	a2,a2,0x20
 290:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 294:	00054783          	lbu	a5,0(a0)
 298:	0005c703          	lbu	a4,0(a1)
 29c:	00e79863          	bne	a5,a4,2ac <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2a0:	0505                	addi	a0,a0,1
    p2++;
 2a2:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2a4:	fed518e3          	bne	a0,a3,294 <memcmp+0x12>
  }
  return 0;
 2a8:	4501                	li	a0,0
 2aa:	a019                	j	2b0 <memcmp+0x2e>
      return *p1 - *p2;
 2ac:	40e7853b          	subw	a0,a5,a4
}
 2b0:	60a2                	ld	ra,8(sp)
 2b2:	6402                	ld	s0,0(sp)
 2b4:	0141                	addi	sp,sp,16
 2b6:	8082                	ret
  return 0;
 2b8:	4501                	li	a0,0
 2ba:	bfdd                	j	2b0 <memcmp+0x2e>

00000000000002bc <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2c4:	f63ff0ef          	jal	226 <memmove>
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret

00000000000002d0 <sbrk>:

char *
sbrk(int n) {
 2d0:	1141                	addi	sp,sp,-16
 2d2:	e406                	sd	ra,8(sp)
 2d4:	e022                	sd	s0,0(sp)
 2d6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2d8:	4585                	li	a1,1
 2da:	0b2000ef          	jal	38c <sys_sbrk>
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <sbrklazy>:

char *
sbrklazy(int n) {
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2ee:	4589                	li	a1,2
 2f0:	09c000ef          	jal	38c <sys_sbrk>
}
 2f4:	60a2                	ld	ra,8(sp)
 2f6:	6402                	ld	s0,0(sp)
 2f8:	0141                	addi	sp,sp,16
 2fa:	8082                	ret

00000000000002fc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2fc:	4885                	li	a7,1
 ecall
 2fe:	00000073          	ecall
 ret
 302:	8082                	ret

0000000000000304 <exit>:
.global exit
exit:
 li a7, SYS_exit
 304:	4889                	li	a7,2
 ecall
 306:	00000073          	ecall
 ret
 30a:	8082                	ret

000000000000030c <wait>:
.global wait
wait:
 li a7, SYS_wait
 30c:	488d                	li	a7,3
 ecall
 30e:	00000073          	ecall
 ret
 312:	8082                	ret

0000000000000314 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 314:	4891                	li	a7,4
 ecall
 316:	00000073          	ecall
 ret
 31a:	8082                	ret

000000000000031c <read>:
.global read
read:
 li a7, SYS_read
 31c:	4895                	li	a7,5
 ecall
 31e:	00000073          	ecall
 ret
 322:	8082                	ret

0000000000000324 <write>:
.global write
write:
 li a7, SYS_write
 324:	48c1                	li	a7,16
 ecall
 326:	00000073          	ecall
 ret
 32a:	8082                	ret

000000000000032c <close>:
.global close
close:
 li a7, SYS_close
 32c:	48d5                	li	a7,21
 ecall
 32e:	00000073          	ecall
 ret
 332:	8082                	ret

0000000000000334 <kill>:
.global kill
kill:
 li a7, SYS_kill
 334:	4899                	li	a7,6
 ecall
 336:	00000073          	ecall
 ret
 33a:	8082                	ret

000000000000033c <exec>:
.global exec
exec:
 li a7, SYS_exec
 33c:	489d                	li	a7,7
 ecall
 33e:	00000073          	ecall
 ret
 342:	8082                	ret

0000000000000344 <open>:
.global open
open:
 li a7, SYS_open
 344:	48bd                	li	a7,15
 ecall
 346:	00000073          	ecall
 ret
 34a:	8082                	ret

000000000000034c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 34c:	48c5                	li	a7,17
 ecall
 34e:	00000073          	ecall
 ret
 352:	8082                	ret

0000000000000354 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 354:	48c9                	li	a7,18
 ecall
 356:	00000073          	ecall
 ret
 35a:	8082                	ret

000000000000035c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 35c:	48a1                	li	a7,8
 ecall
 35e:	00000073          	ecall
 ret
 362:	8082                	ret

0000000000000364 <link>:
.global link
link:
 li a7, SYS_link
 364:	48cd                	li	a7,19
 ecall
 366:	00000073          	ecall
 ret
 36a:	8082                	ret

000000000000036c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 36c:	48d1                	li	a7,20
 ecall
 36e:	00000073          	ecall
 ret
 372:	8082                	ret

0000000000000374 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 374:	48a5                	li	a7,9
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <dup>:
.global dup
dup:
 li a7, SYS_dup
 37c:	48a9                	li	a7,10
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 384:	48ad                	li	a7,11
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 38c:	48b1                	li	a7,12
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <pause>:
.global pause
pause:
 li a7, SYS_pause
 394:	48b5                	li	a7,13
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 39c:	48b9                	li	a7,14
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3a4:	48f5                	li	a7,29
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 3ac:	48f9                	li	a7,30
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <send>:
.global send
send:
 li a7, SYS_send
 3b4:	48fd                	li	a7,31
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <recv>:
.global recv
recv:
 li a7, SYS_recv
 3bc:	02000893          	li	a7,32
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 3c6:	02100893          	li	a7,33
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 3d0:	02200893          	li	a7,34
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3da:	1101                	addi	sp,sp,-32
 3dc:	ec06                	sd	ra,24(sp)
 3de:	e822                	sd	s0,16(sp)
 3e0:	1000                	addi	s0,sp,32
 3e2:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3e6:	4605                	li	a2,1
 3e8:	fef40593          	addi	a1,s0,-17
 3ec:	f39ff0ef          	jal	324 <write>
}
 3f0:	60e2                	ld	ra,24(sp)
 3f2:	6442                	ld	s0,16(sp)
 3f4:	6105                	addi	sp,sp,32
 3f6:	8082                	ret

00000000000003f8 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3f8:	715d                	addi	sp,sp,-80
 3fa:	e486                	sd	ra,72(sp)
 3fc:	e0a2                	sd	s0,64(sp)
 3fe:	f84a                	sd	s2,48(sp)
 400:	f44e                	sd	s3,40(sp)
 402:	0880                	addi	s0,sp,80
 404:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 406:	c6d1                	beqz	a3,492 <printint+0x9a>
 408:	0805d563          	bgez	a1,492 <printint+0x9a>
    neg = 1;
    x = -xx;
 40c:	40b005b3          	neg	a1,a1
    neg = 1;
 410:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 412:	fb840993          	addi	s3,s0,-72
  neg = 0;
 416:	86ce                	mv	a3,s3
  i = 0;
 418:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 41a:	00000817          	auipc	a6,0x0
 41e:	54e80813          	addi	a6,a6,1358 # 968 <digits>
 422:	88ba                	mv	a7,a4
 424:	0017051b          	addiw	a0,a4,1
 428:	872a                	mv	a4,a0
 42a:	02c5f7b3          	remu	a5,a1,a2
 42e:	97c2                	add	a5,a5,a6
 430:	0007c783          	lbu	a5,0(a5)
 434:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 438:	87ae                	mv	a5,a1
 43a:	02c5d5b3          	divu	a1,a1,a2
 43e:	0685                	addi	a3,a3,1
 440:	fec7f1e3          	bgeu	a5,a2,422 <printint+0x2a>
  if(neg)
 444:	00030c63          	beqz	t1,45c <printint+0x64>
    buf[i++] = '-';
 448:	fd050793          	addi	a5,a0,-48
 44c:	00878533          	add	a0,a5,s0
 450:	02d00793          	li	a5,45
 454:	fef50423          	sb	a5,-24(a0)
 458:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 45c:	02e05563          	blez	a4,486 <printint+0x8e>
 460:	fc26                	sd	s1,56(sp)
 462:	377d                	addiw	a4,a4,-1
 464:	00e984b3          	add	s1,s3,a4
 468:	19fd                	addi	s3,s3,-1
 46a:	99ba                	add	s3,s3,a4
 46c:	1702                	slli	a4,a4,0x20
 46e:	9301                	srli	a4,a4,0x20
 470:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 474:	0004c583          	lbu	a1,0(s1)
 478:	854a                	mv	a0,s2
 47a:	f61ff0ef          	jal	3da <putc>
  while(--i >= 0)
 47e:	14fd                	addi	s1,s1,-1
 480:	ff349ae3          	bne	s1,s3,474 <printint+0x7c>
 484:	74e2                	ld	s1,56(sp)
}
 486:	60a6                	ld	ra,72(sp)
 488:	6406                	ld	s0,64(sp)
 48a:	7942                	ld	s2,48(sp)
 48c:	79a2                	ld	s3,40(sp)
 48e:	6161                	addi	sp,sp,80
 490:	8082                	ret
  neg = 0;
 492:	4301                	li	t1,0
 494:	bfbd                	j	412 <printint+0x1a>

0000000000000496 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 496:	711d                	addi	sp,sp,-96
 498:	ec86                	sd	ra,88(sp)
 49a:	e8a2                	sd	s0,80(sp)
 49c:	e4a6                	sd	s1,72(sp)
 49e:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4a0:	0005c483          	lbu	s1,0(a1)
 4a4:	22048363          	beqz	s1,6ca <vprintf+0x234>
 4a8:	e0ca                	sd	s2,64(sp)
 4aa:	fc4e                	sd	s3,56(sp)
 4ac:	f852                	sd	s4,48(sp)
 4ae:	f456                	sd	s5,40(sp)
 4b0:	f05a                	sd	s6,32(sp)
 4b2:	ec5e                	sd	s7,24(sp)
 4b4:	e862                	sd	s8,16(sp)
 4b6:	8b2a                	mv	s6,a0
 4b8:	8a2e                	mv	s4,a1
 4ba:	8bb2                	mv	s7,a2
  state = 0;
 4bc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4be:	4901                	li	s2,0
 4c0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c6:	06400c13          	li	s8,100
 4ca:	a00d                	j	4ec <vprintf+0x56>
        putc(fd, c0);
 4cc:	85a6                	mv	a1,s1
 4ce:	855a                	mv	a0,s6
 4d0:	f0bff0ef          	jal	3da <putc>
 4d4:	a019                	j	4da <vprintf+0x44>
    } else if(state == '%'){
 4d6:	03598363          	beq	s3,s5,4fc <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4da:	0019079b          	addiw	a5,s2,1
 4de:	893e                	mv	s2,a5
 4e0:	873e                	mv	a4,a5
 4e2:	97d2                	add	a5,a5,s4
 4e4:	0007c483          	lbu	s1,0(a5)
 4e8:	1c048a63          	beqz	s1,6bc <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4ec:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4f0:	fe0993e3          	bnez	s3,4d6 <vprintf+0x40>
      if(c0 == '%'){
 4f4:	fd579ce3          	bne	a5,s5,4cc <vprintf+0x36>
        state = '%';
 4f8:	89be                	mv	s3,a5
 4fa:	b7c5                	j	4da <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4fc:	00ea06b3          	add	a3,s4,a4
 500:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 504:	1c060863          	beqz	a2,6d4 <vprintf+0x23e>
      if(c0 == 'd'){
 508:	03878763          	beq	a5,s8,536 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50c:	f9478693          	addi	a3,a5,-108
 510:	0016b693          	seqz	a3,a3
 514:	f9c60593          	addi	a1,a2,-100
 518:	e99d                	bnez	a1,54e <vprintf+0xb8>
 51a:	ca95                	beqz	a3,54e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 51c:	008b8493          	addi	s1,s7,8
 520:	4685                	li	a3,1
 522:	4629                	li	a2,10
 524:	000bb583          	ld	a1,0(s7)
 528:	855a                	mv	a0,s6
 52a:	ecfff0ef          	jal	3f8 <printint>
        i += 1;
 52e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 530:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 532:	4981                	li	s3,0
 534:	b75d                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 536:	008b8493          	addi	s1,s7,8
 53a:	4685                	li	a3,1
 53c:	4629                	li	a2,10
 53e:	000ba583          	lw	a1,0(s7)
 542:	855a                	mv	a0,s6
 544:	eb5ff0ef          	jal	3f8 <printint>
 548:	8ba6                	mv	s7,s1
      state = 0;
 54a:	4981                	li	s3,0
 54c:	b779                	j	4da <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 54e:	9752                	add	a4,a4,s4
 550:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 554:	f9460713          	addi	a4,a2,-108
 558:	00173713          	seqz	a4,a4
 55c:	8f75                	and	a4,a4,a3
 55e:	f9c58513          	addi	a0,a1,-100
 562:	18051363          	bnez	a0,6e8 <vprintf+0x252>
 566:	18070163          	beqz	a4,6e8 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56a:	008b8493          	addi	s1,s7,8
 56e:	4685                	li	a3,1
 570:	4629                	li	a2,10
 572:	000bb583          	ld	a1,0(s7)
 576:	855a                	mv	a0,s6
 578:	e81ff0ef          	jal	3f8 <printint>
        i += 2;
 57c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 57e:	8ba6                	mv	s7,s1
      state = 0;
 580:	4981                	li	s3,0
        i += 2;
 582:	bfa1                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 584:	008b8493          	addi	s1,s7,8
 588:	4681                	li	a3,0
 58a:	4629                	li	a2,10
 58c:	000be583          	lwu	a1,0(s7)
 590:	855a                	mv	a0,s6
 592:	e67ff0ef          	jal	3f8 <printint>
 596:	8ba6                	mv	s7,s1
      state = 0;
 598:	4981                	li	s3,0
 59a:	b781                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59c:	008b8493          	addi	s1,s7,8
 5a0:	4681                	li	a3,0
 5a2:	4629                	li	a2,10
 5a4:	000bb583          	ld	a1,0(s7)
 5a8:	855a                	mv	a0,s6
 5aa:	e4fff0ef          	jal	3f8 <printint>
        i += 1;
 5ae:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b0:	8ba6                	mv	s7,s1
      state = 0;
 5b2:	4981                	li	s3,0
 5b4:	b71d                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b6:	008b8493          	addi	s1,s7,8
 5ba:	4681                	li	a3,0
 5bc:	4629                	li	a2,10
 5be:	000bb583          	ld	a1,0(s7)
 5c2:	855a                	mv	a0,s6
 5c4:	e35ff0ef          	jal	3f8 <printint>
        i += 2;
 5c8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ca:	8ba6                	mv	s7,s1
      state = 0;
 5cc:	4981                	li	s3,0
        i += 2;
 5ce:	b731                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5d0:	008b8493          	addi	s1,s7,8
 5d4:	4681                	li	a3,0
 5d6:	4641                	li	a2,16
 5d8:	000be583          	lwu	a1,0(s7)
 5dc:	855a                	mv	a0,s6
 5de:	e1bff0ef          	jal	3f8 <printint>
 5e2:	8ba6                	mv	s7,s1
      state = 0;
 5e4:	4981                	li	s3,0
 5e6:	bdd5                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e8:	008b8493          	addi	s1,s7,8
 5ec:	4681                	li	a3,0
 5ee:	4641                	li	a2,16
 5f0:	000bb583          	ld	a1,0(s7)
 5f4:	855a                	mv	a0,s6
 5f6:	e03ff0ef          	jal	3f8 <printint>
        i += 1;
 5fa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fc:	8ba6                	mv	s7,s1
      state = 0;
 5fe:	4981                	li	s3,0
 600:	bde9                	j	4da <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 602:	008b8493          	addi	s1,s7,8
 606:	4681                	li	a3,0
 608:	4641                	li	a2,16
 60a:	000bb583          	ld	a1,0(s7)
 60e:	855a                	mv	a0,s6
 610:	de9ff0ef          	jal	3f8 <printint>
        i += 2;
 614:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 616:	8ba6                	mv	s7,s1
      state = 0;
 618:	4981                	li	s3,0
        i += 2;
 61a:	b5c1                	j	4da <vprintf+0x44>
 61c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 61e:	008b8793          	addi	a5,s7,8
 622:	8cbe                	mv	s9,a5
 624:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 628:	03000593          	li	a1,48
 62c:	855a                	mv	a0,s6
 62e:	dadff0ef          	jal	3da <putc>
  putc(fd, 'x');
 632:	07800593          	li	a1,120
 636:	855a                	mv	a0,s6
 638:	da3ff0ef          	jal	3da <putc>
 63c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63e:	00000b97          	auipc	s7,0x0
 642:	32ab8b93          	addi	s7,s7,810 # 968 <digits>
 646:	03c9d793          	srli	a5,s3,0x3c
 64a:	97de                	add	a5,a5,s7
 64c:	0007c583          	lbu	a1,0(a5)
 650:	855a                	mv	a0,s6
 652:	d89ff0ef          	jal	3da <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 656:	0992                	slli	s3,s3,0x4
 658:	34fd                	addiw	s1,s1,-1
 65a:	f4f5                	bnez	s1,646 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 65c:	8be6                	mv	s7,s9
      state = 0;
 65e:	4981                	li	s3,0
 660:	6ca2                	ld	s9,8(sp)
 662:	bda5                	j	4da <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 664:	008b8493          	addi	s1,s7,8
 668:	000bc583          	lbu	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	d6dff0ef          	jal	3da <putc>
 672:	8ba6                	mv	s7,s1
      state = 0;
 674:	4981                	li	s3,0
 676:	b595                	j	4da <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 678:	008b8993          	addi	s3,s7,8
 67c:	000bb483          	ld	s1,0(s7)
 680:	cc91                	beqz	s1,69c <vprintf+0x206>
        for(; *s; s++)
 682:	0004c583          	lbu	a1,0(s1)
 686:	c985                	beqz	a1,6b6 <vprintf+0x220>
          putc(fd, *s);
 688:	855a                	mv	a0,s6
 68a:	d51ff0ef          	jal	3da <putc>
        for(; *s; s++)
 68e:	0485                	addi	s1,s1,1
 690:	0004c583          	lbu	a1,0(s1)
 694:	f9f5                	bnez	a1,688 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 696:	8bce                	mv	s7,s3
      state = 0;
 698:	4981                	li	s3,0
 69a:	b581                	j	4da <vprintf+0x44>
          s = "(null)";
 69c:	00000497          	auipc	s1,0x0
 6a0:	2c448493          	addi	s1,s1,708 # 960 <malloc+0x128>
        for(; *s; s++)
 6a4:	02800593          	li	a1,40
 6a8:	b7c5                	j	688 <vprintf+0x1f2>
        putc(fd, '%');
 6aa:	85be                	mv	a1,a5
 6ac:	855a                	mv	a0,s6
 6ae:	d2dff0ef          	jal	3da <putc>
      state = 0;
 6b2:	4981                	li	s3,0
 6b4:	b51d                	j	4da <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b505                	j	4da <vprintf+0x44>
 6bc:	6906                	ld	s2,64(sp)
 6be:	79e2                	ld	s3,56(sp)
 6c0:	7a42                	ld	s4,48(sp)
 6c2:	7aa2                	ld	s5,40(sp)
 6c4:	7b02                	ld	s6,32(sp)
 6c6:	6be2                	ld	s7,24(sp)
 6c8:	6c42                	ld	s8,16(sp)
    }
  }
}
 6ca:	60e6                	ld	ra,88(sp)
 6cc:	6446                	ld	s0,80(sp)
 6ce:	64a6                	ld	s1,72(sp)
 6d0:	6125                	addi	sp,sp,96
 6d2:	8082                	ret
      if(c0 == 'd'){
 6d4:	06400713          	li	a4,100
 6d8:	e4e78fe3          	beq	a5,a4,536 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6dc:	f9478693          	addi	a3,a5,-108
 6e0:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6e4:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e6:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6e8:	07500513          	li	a0,117
 6ec:	e8a78ce3          	beq	a5,a0,584 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6f0:	f8b60513          	addi	a0,a2,-117
 6f4:	e119                	bnez	a0,6fa <vprintf+0x264>
 6f6:	ea0693e3          	bnez	a3,59c <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6fa:	f8b58513          	addi	a0,a1,-117
 6fe:	e119                	bnez	a0,704 <vprintf+0x26e>
 700:	ea071be3          	bnez	a4,5b6 <vprintf+0x120>
      } else if(c0 == 'x'){
 704:	07800513          	li	a0,120
 708:	eca784e3          	beq	a5,a0,5d0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 70c:	f8860613          	addi	a2,a2,-120
 710:	e219                	bnez	a2,716 <vprintf+0x280>
 712:	ec069be3          	bnez	a3,5e8 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 716:	f8858593          	addi	a1,a1,-120
 71a:	e199                	bnez	a1,720 <vprintf+0x28a>
 71c:	ee0713e3          	bnez	a4,602 <vprintf+0x16c>
      } else if(c0 == 'p'){
 720:	07000713          	li	a4,112
 724:	eee78ce3          	beq	a5,a4,61c <vprintf+0x186>
      } else if(c0 == 'c'){
 728:	06300713          	li	a4,99
 72c:	f2e78ce3          	beq	a5,a4,664 <vprintf+0x1ce>
      } else if(c0 == 's'){
 730:	07300713          	li	a4,115
 734:	f4e782e3          	beq	a5,a4,678 <vprintf+0x1e2>
      } else if(c0 == '%'){
 738:	02500713          	li	a4,37
 73c:	f6e787e3          	beq	a5,a4,6aa <vprintf+0x214>
        putc(fd, '%');
 740:	02500593          	li	a1,37
 744:	855a                	mv	a0,s6
 746:	c95ff0ef          	jal	3da <putc>
        putc(fd, c0);
 74a:	85a6                	mv	a1,s1
 74c:	855a                	mv	a0,s6
 74e:	c8dff0ef          	jal	3da <putc>
      state = 0;
 752:	4981                	li	s3,0
 754:	b359                	j	4da <vprintf+0x44>

0000000000000756 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 756:	715d                	addi	sp,sp,-80
 758:	ec06                	sd	ra,24(sp)
 75a:	e822                	sd	s0,16(sp)
 75c:	1000                	addi	s0,sp,32
 75e:	e010                	sd	a2,0(s0)
 760:	e414                	sd	a3,8(s0)
 762:	e818                	sd	a4,16(s0)
 764:	ec1c                	sd	a5,24(s0)
 766:	03043023          	sd	a6,32(s0)
 76a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76e:	8622                	mv	a2,s0
 770:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 774:	d23ff0ef          	jal	496 <vprintf>
}
 778:	60e2                	ld	ra,24(sp)
 77a:	6442                	ld	s0,16(sp)
 77c:	6161                	addi	sp,sp,80
 77e:	8082                	ret

0000000000000780 <printf>:

void
printf(const char *fmt, ...)
{
 780:	711d                	addi	sp,sp,-96
 782:	ec06                	sd	ra,24(sp)
 784:	e822                	sd	s0,16(sp)
 786:	1000                	addi	s0,sp,32
 788:	e40c                	sd	a1,8(s0)
 78a:	e810                	sd	a2,16(s0)
 78c:	ec14                	sd	a3,24(s0)
 78e:	f018                	sd	a4,32(s0)
 790:	f41c                	sd	a5,40(s0)
 792:	03043823          	sd	a6,48(s0)
 796:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 79a:	00840613          	addi	a2,s0,8
 79e:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a2:	85aa                	mv	a1,a0
 7a4:	4505                	li	a0,1
 7a6:	cf1ff0ef          	jal	496 <vprintf>
}
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6125                	addi	sp,sp,96
 7b0:	8082                	ret

00000000000007b2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b2:	1141                	addi	sp,sp,-16
 7b4:	e406                	sd	ra,8(sp)
 7b6:	e022                	sd	s0,0(sp)
 7b8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7ba:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7be:	00001797          	auipc	a5,0x1
 7c2:	8427b783          	ld	a5,-1982(a5) # 1000 <freep>
 7c6:	a039                	j	7d4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c8:	6398                	ld	a4,0(a5)
 7ca:	00e7e463          	bltu	a5,a4,7d2 <free+0x20>
 7ce:	00e6ea63          	bltu	a3,a4,7e2 <free+0x30>
{
 7d2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d4:	fed7fae3          	bgeu	a5,a3,7c8 <free+0x16>
 7d8:	6398                	ld	a4,0(a5)
 7da:	00e6e463          	bltu	a3,a4,7e2 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7de:	fee7eae3          	bltu	a5,a4,7d2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e2:	ff852583          	lw	a1,-8(a0)
 7e6:	6390                	ld	a2,0(a5)
 7e8:	02059813          	slli	a6,a1,0x20
 7ec:	01c85713          	srli	a4,a6,0x1c
 7f0:	9736                	add	a4,a4,a3
 7f2:	02e60563          	beq	a2,a4,81c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7f6:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7fa:	4790                	lw	a2,8(a5)
 7fc:	02061593          	slli	a1,a2,0x20
 800:	01c5d713          	srli	a4,a1,0x1c
 804:	973e                	add	a4,a4,a5
 806:	02e68263          	beq	a3,a4,82a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 80a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80c:	00000717          	auipc	a4,0x0
 810:	7ef73a23          	sd	a5,2036(a4) # 1000 <freep>
}
 814:	60a2                	ld	ra,8(sp)
 816:	6402                	ld	s0,0(sp)
 818:	0141                	addi	sp,sp,16
 81a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 81c:	4618                	lw	a4,8(a2)
 81e:	9f2d                	addw	a4,a4,a1
 820:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 824:	6398                	ld	a4,0(a5)
 826:	6310                	ld	a2,0(a4)
 828:	b7f9                	j	7f6 <free+0x44>
    p->s.size += bp->s.size;
 82a:	ff852703          	lw	a4,-8(a0)
 82e:	9f31                	addw	a4,a4,a2
 830:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 832:	ff053683          	ld	a3,-16(a0)
 836:	bfd1                	j	80a <free+0x58>

0000000000000838 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 838:	7139                	addi	sp,sp,-64
 83a:	fc06                	sd	ra,56(sp)
 83c:	f822                	sd	s0,48(sp)
 83e:	f04a                	sd	s2,32(sp)
 840:	ec4e                	sd	s3,24(sp)
 842:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 844:	02051993          	slli	s3,a0,0x20
 848:	0209d993          	srli	s3,s3,0x20
 84c:	09bd                	addi	s3,s3,15
 84e:	0049d993          	srli	s3,s3,0x4
 852:	2985                	addiw	s3,s3,1
 854:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 856:	00000517          	auipc	a0,0x0
 85a:	7aa53503          	ld	a0,1962(a0) # 1000 <freep>
 85e:	c905                	beqz	a0,88e <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 860:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 862:	4798                	lw	a4,8(a5)
 864:	09377663          	bgeu	a4,s3,8f0 <malloc+0xb8>
 868:	f426                	sd	s1,40(sp)
 86a:	e852                	sd	s4,16(sp)
 86c:	e456                	sd	s5,8(sp)
 86e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 870:	8a4e                	mv	s4,s3
 872:	6705                	lui	a4,0x1
 874:	00e9f363          	bgeu	s3,a4,87a <malloc+0x42>
 878:	6a05                	lui	s4,0x1
 87a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 882:	00000497          	auipc	s1,0x0
 886:	77e48493          	addi	s1,s1,1918 # 1000 <freep>
  if(p == SBRK_ERROR)
 88a:	5afd                	li	s5,-1
 88c:	a83d                	j	8ca <malloc+0x92>
 88e:	f426                	sd	s1,40(sp)
 890:	e852                	sd	s4,16(sp)
 892:	e456                	sd	s5,8(sp)
 894:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 896:	00000797          	auipc	a5,0x0
 89a:	77a78793          	addi	a5,a5,1914 # 1010 <base>
 89e:	00000717          	auipc	a4,0x0
 8a2:	76f73123          	sd	a5,1890(a4) # 1000 <freep>
 8a6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8ac:	b7d1                	j	870 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ae:	6398                	ld	a4,0(a5)
 8b0:	e118                	sd	a4,0(a0)
 8b2:	a899                	j	908 <malloc+0xd0>
  hp->s.size = nu;
 8b4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b8:	0541                	addi	a0,a0,16
 8ba:	ef9ff0ef          	jal	7b2 <free>
  return freep;
 8be:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8c0:	c125                	beqz	a0,920 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c4:	4798                	lw	a4,8(a5)
 8c6:	03277163          	bgeu	a4,s2,8e8 <malloc+0xb0>
    if(p == freep)
 8ca:	6098                	ld	a4,0(s1)
 8cc:	853e                	mv	a0,a5
 8ce:	fef71ae3          	bne	a4,a5,8c2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d2:	8552                	mv	a0,s4
 8d4:	9fdff0ef          	jal	2d0 <sbrk>
  if(p == SBRK_ERROR)
 8d8:	fd551ee3          	bne	a0,s5,8b4 <malloc+0x7c>
        return 0;
 8dc:	4501                	li	a0,0
 8de:	74a2                	ld	s1,40(sp)
 8e0:	6a42                	ld	s4,16(sp)
 8e2:	6aa2                	ld	s5,8(sp)
 8e4:	6b02                	ld	s6,0(sp)
 8e6:	a03d                	j	914 <malloc+0xdc>
 8e8:	74a2                	ld	s1,40(sp)
 8ea:	6a42                	ld	s4,16(sp)
 8ec:	6aa2                	ld	s5,8(sp)
 8ee:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8f0:	fae90fe3          	beq	s2,a4,8ae <malloc+0x76>
        p->s.size -= nunits;
 8f4:	4137073b          	subw	a4,a4,s3
 8f8:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8fa:	02071693          	slli	a3,a4,0x20
 8fe:	01c6d713          	srli	a4,a3,0x1c
 902:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 904:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 908:	00000717          	auipc	a4,0x0
 90c:	6ea73c23          	sd	a0,1784(a4) # 1000 <freep>
      return (void*)(p + 1);
 910:	01078513          	addi	a0,a5,16
  }
}
 914:	70e2                	ld	ra,56(sp)
 916:	7442                	ld	s0,48(sp)
 918:	7902                	ld	s2,32(sp)
 91a:	69e2                	ld	s3,24(sp)
 91c:	6121                	addi	sp,sp,64
 91e:	8082                	ret
 920:	74a2                	ld	s1,40(sp)
 922:	6a42                	ld	s4,16(sp)
 924:	6aa2                	ld	s5,8(sp)
 926:	6b02                	ld	s6,0(sp)
 928:	b7f5                	j	914 <malloc+0xdc>
