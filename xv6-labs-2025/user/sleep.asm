
user/_sleep:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(int argc, char *argv[])
{
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
  if(argc != 2){
   8:	4789                	li	a5,2
   a:	00f50c63          	beq	a0,a5,22 <main+0x22>
    fprintf(2, "Usage: sleep second\n");
   e:	00001597          	auipc	a1,0x1
  12:	8e258593          	addi	a1,a1,-1822 # 8f0 <malloc+0xfc>
  16:	853e                	mv	a0,a5
  18:	6fa000ef          	jal	712 <fprintf>
    exit(1);
  1c:	4505                	li	a0,1
  1e:	2d2000ef          	jal	2f0 <exit>
  }
  
  int second = atoi(argv[1]);
  22:	6588                	ld	a0,8(a1)
  24:	1a2000ef          	jal	1c6 <atoi>

  // 10 tick per second
  pause(second * 10);
  28:	47a9                	li	a5,10
  2a:	02a7853b          	mulw	a0,a5,a0
  2e:	352000ef          	jal	380 <pause>

  exit(0);
  32:	4501                	li	a0,0
  34:	2bc000ef          	jal	2f0 <exit>

0000000000000038 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  38:	1141                	addi	sp,sp,-16
  3a:	e406                	sd	ra,8(sp)
  3c:	e022                	sd	s0,0(sp)
  3e:	0800                	addi	s0,sp,16
  extern int main();
  main();
  40:	fc1ff0ef          	jal	0 <main>
  exit(0);
  44:	4501                	li	a0,0
  46:	2aa000ef          	jal	2f0 <exit>

000000000000004a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  4a:	1141                	addi	sp,sp,-16
  4c:	e406                	sd	ra,8(sp)
  4e:	e022                	sd	s0,0(sp)
  50:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  52:	87aa                	mv	a5,a0
  54:	0585                	addi	a1,a1,1
  56:	0785                	addi	a5,a5,1
  58:	fff5c703          	lbu	a4,-1(a1)
  5c:	fee78fa3          	sb	a4,-1(a5)
  60:	fb75                	bnez	a4,54 <strcpy+0xa>
    ;
  return os;
}
  62:	60a2                	ld	ra,8(sp)
  64:	6402                	ld	s0,0(sp)
  66:	0141                	addi	sp,sp,16
  68:	8082                	ret

000000000000006a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  6a:	1141                	addi	sp,sp,-16
  6c:	e406                	sd	ra,8(sp)
  6e:	e022                	sd	s0,0(sp)
  70:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  72:	00054783          	lbu	a5,0(a0)
  76:	cb91                	beqz	a5,8a <strcmp+0x20>
  78:	0005c703          	lbu	a4,0(a1)
  7c:	00f71763          	bne	a4,a5,8a <strcmp+0x20>
    p++, q++;
  80:	0505                	addi	a0,a0,1
  82:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  84:	00054783          	lbu	a5,0(a0)
  88:	fbe5                	bnez	a5,78 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  8a:	0005c503          	lbu	a0,0(a1)
}
  8e:	40a7853b          	subw	a0,a5,a0
  92:	60a2                	ld	ra,8(sp)
  94:	6402                	ld	s0,0(sp)
  96:	0141                	addi	sp,sp,16
  98:	8082                	ret

000000000000009a <strlen>:

uint
strlen(const char *s)
{
  9a:	1141                	addi	sp,sp,-16
  9c:	e406                	sd	ra,8(sp)
  9e:	e022                	sd	s0,0(sp)
  a0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  a2:	00054783          	lbu	a5,0(a0)
  a6:	cf91                	beqz	a5,c2 <strlen+0x28>
  a8:	00150793          	addi	a5,a0,1
  ac:	86be                	mv	a3,a5
  ae:	0785                	addi	a5,a5,1
  b0:	fff7c703          	lbu	a4,-1(a5)
  b4:	ff65                	bnez	a4,ac <strlen+0x12>
  b6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  ba:	60a2                	ld	ra,8(sp)
  bc:	6402                	ld	s0,0(sp)
  be:	0141                	addi	sp,sp,16
  c0:	8082                	ret
  for(n = 0; s[n]; n++)
  c2:	4501                	li	a0,0
  c4:	bfdd                	j	ba <strlen+0x20>

00000000000000c6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ce:	ca19                	beqz	a2,e4 <memset+0x1e>
  d0:	87aa                	mv	a5,a0
  d2:	1602                	slli	a2,a2,0x20
  d4:	9201                	srli	a2,a2,0x20
  d6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  da:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  de:	0785                	addi	a5,a5,1
  e0:	fee79de3          	bne	a5,a4,da <memset+0x14>
  }
  return dst;
}
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strchr>:

char*
strchr(const char *s, char c)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  for(; *s; s++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cf81                	beqz	a5,110 <strchr+0x24>
    if(*s == c)
  fa:	00f58763          	beq	a1,a5,108 <strchr+0x1c>
  for(; *s; s++)
  fe:	0505                	addi	a0,a0,1
 100:	00054783          	lbu	a5,0(a0)
 104:	fbfd                	bnez	a5,fa <strchr+0xe>
      return (char*)s;
  return 0;
 106:	4501                	li	a0,0
}
 108:	60a2                	ld	ra,8(sp)
 10a:	6402                	ld	s0,0(sp)
 10c:	0141                	addi	sp,sp,16
 10e:	8082                	ret
  return 0;
 110:	4501                	li	a0,0
 112:	bfdd                	j	108 <strchr+0x1c>

0000000000000114 <gets>:

char*
gets(char *buf, int max)
{
 114:	711d                	addi	sp,sp,-96
 116:	ec86                	sd	ra,88(sp)
 118:	e8a2                	sd	s0,80(sp)
 11a:	e4a6                	sd	s1,72(sp)
 11c:	e0ca                	sd	s2,64(sp)
 11e:	fc4e                	sd	s3,56(sp)
 120:	f852                	sd	s4,48(sp)
 122:	f456                	sd	s5,40(sp)
 124:	f05a                	sd	s6,32(sp)
 126:	ec5e                	sd	s7,24(sp)
 128:	e862                	sd	s8,16(sp)
 12a:	1080                	addi	s0,sp,96
 12c:	8baa                	mv	s7,a0
 12e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 130:	892a                	mv	s2,a0
 132:	4481                	li	s1,0
    cc = read(0, &c, 1);
 134:	faf40b13          	addi	s6,s0,-81
 138:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 13a:	8c26                	mv	s8,s1
 13c:	0014899b          	addiw	s3,s1,1
 140:	84ce                	mv	s1,s3
 142:	0349d463          	bge	s3,s4,16a <gets+0x56>
    cc = read(0, &c, 1);
 146:	8656                	mv	a2,s5
 148:	85da                	mv	a1,s6
 14a:	4501                	li	a0,0
 14c:	1bc000ef          	jal	308 <read>
    if(cc < 1)
 150:	00a05d63          	blez	a0,16a <gets+0x56>
      break;
    buf[i++] = c;
 154:	faf44783          	lbu	a5,-81(s0)
 158:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 15c:	0905                	addi	s2,s2,1
 15e:	ff678713          	addi	a4,a5,-10
 162:	c319                	beqz	a4,168 <gets+0x54>
 164:	17cd                	addi	a5,a5,-13
 166:	fbf1                	bnez	a5,13a <gets+0x26>
    buf[i++] = c;
 168:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 16a:	9c5e                	add	s8,s8,s7
 16c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 170:	855e                	mv	a0,s7
 172:	60e6                	ld	ra,88(sp)
 174:	6446                	ld	s0,80(sp)
 176:	64a6                	ld	s1,72(sp)
 178:	6906                	ld	s2,64(sp)
 17a:	79e2                	ld	s3,56(sp)
 17c:	7a42                	ld	s4,48(sp)
 17e:	7aa2                	ld	s5,40(sp)
 180:	7b02                	ld	s6,32(sp)
 182:	6be2                	ld	s7,24(sp)
 184:	6c42                	ld	s8,16(sp)
 186:	6125                	addi	sp,sp,96
 188:	8082                	ret

000000000000018a <stat>:

int
stat(const char *n, struct stat *st)
{
 18a:	1101                	addi	sp,sp,-32
 18c:	ec06                	sd	ra,24(sp)
 18e:	e822                	sd	s0,16(sp)
 190:	e04a                	sd	s2,0(sp)
 192:	1000                	addi	s0,sp,32
 194:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 196:	4581                	li	a1,0
 198:	198000ef          	jal	330 <open>
  if(fd < 0)
 19c:	02054263          	bltz	a0,1c0 <stat+0x36>
 1a0:	e426                	sd	s1,8(sp)
 1a2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1a4:	85ca                	mv	a1,s2
 1a6:	1a2000ef          	jal	348 <fstat>
 1aa:	892a                	mv	s2,a0
  close(fd);
 1ac:	8526                	mv	a0,s1
 1ae:	16a000ef          	jal	318 <close>
  return r;
 1b2:	64a2                	ld	s1,8(sp)
}
 1b4:	854a                	mv	a0,s2
 1b6:	60e2                	ld	ra,24(sp)
 1b8:	6442                	ld	s0,16(sp)
 1ba:	6902                	ld	s2,0(sp)
 1bc:	6105                	addi	sp,sp,32
 1be:	8082                	ret
    return -1;
 1c0:	57fd                	li	a5,-1
 1c2:	893e                	mv	s2,a5
 1c4:	bfc5                	j	1b4 <stat+0x2a>

00000000000001c6 <atoi>:

int
atoi(const char *s)
{
 1c6:	1141                	addi	sp,sp,-16
 1c8:	e406                	sd	ra,8(sp)
 1ca:	e022                	sd	s0,0(sp)
 1cc:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ce:	00054683          	lbu	a3,0(a0)
 1d2:	fd06879b          	addiw	a5,a3,-48
 1d6:	0ff7f793          	zext.b	a5,a5
 1da:	4625                	li	a2,9
 1dc:	02f66963          	bltu	a2,a5,20e <atoi+0x48>
 1e0:	872a                	mv	a4,a0
  n = 0;
 1e2:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 1e4:	0705                	addi	a4,a4,1
 1e6:	0025179b          	slliw	a5,a0,0x2
 1ea:	9fa9                	addw	a5,a5,a0
 1ec:	0017979b          	slliw	a5,a5,0x1
 1f0:	9fb5                	addw	a5,a5,a3
 1f2:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 1f6:	00074683          	lbu	a3,0(a4)
 1fa:	fd06879b          	addiw	a5,a3,-48
 1fe:	0ff7f793          	zext.b	a5,a5
 202:	fef671e3          	bgeu	a2,a5,1e4 <atoi+0x1e>
  return n;
}
 206:	60a2                	ld	ra,8(sp)
 208:	6402                	ld	s0,0(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret
  n = 0;
 20e:	4501                	li	a0,0
 210:	bfdd                	j	206 <atoi+0x40>

0000000000000212 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 212:	1141                	addi	sp,sp,-16
 214:	e406                	sd	ra,8(sp)
 216:	e022                	sd	s0,0(sp)
 218:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 21a:	02b57563          	bgeu	a0,a1,244 <memmove+0x32>
    while(n-- > 0)
 21e:	00c05f63          	blez	a2,23c <memmove+0x2a>
 222:	1602                	slli	a2,a2,0x20
 224:	9201                	srli	a2,a2,0x20
 226:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 22a:	872a                	mv	a4,a0
      *dst++ = *src++;
 22c:	0585                	addi	a1,a1,1
 22e:	0705                	addi	a4,a4,1
 230:	fff5c683          	lbu	a3,-1(a1)
 234:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 238:	fee79ae3          	bne	a5,a4,22c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 23c:	60a2                	ld	ra,8(sp)
 23e:	6402                	ld	s0,0(sp)
 240:	0141                	addi	sp,sp,16
 242:	8082                	ret
    while(n-- > 0)
 244:	fec05ce3          	blez	a2,23c <memmove+0x2a>
    dst += n;
 248:	00c50733          	add	a4,a0,a2
    src += n;
 24c:	95b2                	add	a1,a1,a2
 24e:	fff6079b          	addiw	a5,a2,-1
 252:	1782                	slli	a5,a5,0x20
 254:	9381                	srli	a5,a5,0x20
 256:	fff7c793          	not	a5,a5
 25a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 25c:	15fd                	addi	a1,a1,-1
 25e:	177d                	addi	a4,a4,-1
 260:	0005c683          	lbu	a3,0(a1)
 264:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 268:	fef71ae3          	bne	a4,a5,25c <memmove+0x4a>
 26c:	bfc1                	j	23c <memmove+0x2a>

000000000000026e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 26e:	1141                	addi	sp,sp,-16
 270:	e406                	sd	ra,8(sp)
 272:	e022                	sd	s0,0(sp)
 274:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 276:	c61d                	beqz	a2,2a4 <memcmp+0x36>
 278:	1602                	slli	a2,a2,0x20
 27a:	9201                	srli	a2,a2,0x20
 27c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 280:	00054783          	lbu	a5,0(a0)
 284:	0005c703          	lbu	a4,0(a1)
 288:	00e79863          	bne	a5,a4,298 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 28c:	0505                	addi	a0,a0,1
    p2++;
 28e:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 290:	fed518e3          	bne	a0,a3,280 <memcmp+0x12>
  }
  return 0;
 294:	4501                	li	a0,0
 296:	a019                	j	29c <memcmp+0x2e>
      return *p1 - *p2;
 298:	40e7853b          	subw	a0,a5,a4
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfdd                	j	29c <memcmp+0x2e>

00000000000002a8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2b0:	f63ff0ef          	jal	212 <memmove>
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret

00000000000002bc <sbrk>:

char *
sbrk(int n) {
 2bc:	1141                	addi	sp,sp,-16
 2be:	e406                	sd	ra,8(sp)
 2c0:	e022                	sd	s0,0(sp)
 2c2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2c4:	4585                	li	a1,1
 2c6:	0b2000ef          	jal	378 <sys_sbrk>
}
 2ca:	60a2                	ld	ra,8(sp)
 2cc:	6402                	ld	s0,0(sp)
 2ce:	0141                	addi	sp,sp,16
 2d0:	8082                	ret

00000000000002d2 <sbrklazy>:

char *
sbrklazy(int n) {
 2d2:	1141                	addi	sp,sp,-16
 2d4:	e406                	sd	ra,8(sp)
 2d6:	e022                	sd	s0,0(sp)
 2d8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2da:	4589                	li	a1,2
 2dc:	09c000ef          	jal	378 <sys_sbrk>
}
 2e0:	60a2                	ld	ra,8(sp)
 2e2:	6402                	ld	s0,0(sp)
 2e4:	0141                	addi	sp,sp,16
 2e6:	8082                	ret

00000000000002e8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 2e8:	4885                	li	a7,1
 ecall
 2ea:	00000073          	ecall
 ret
 2ee:	8082                	ret

00000000000002f0 <exit>:
.global exit
exit:
 li a7, SYS_exit
 2f0:	4889                	li	a7,2
 ecall
 2f2:	00000073          	ecall
 ret
 2f6:	8082                	ret

00000000000002f8 <wait>:
.global wait
wait:
 li a7, SYS_wait
 2f8:	488d                	li	a7,3
 ecall
 2fa:	00000073          	ecall
 ret
 2fe:	8082                	ret

0000000000000300 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 300:	4891                	li	a7,4
 ecall
 302:	00000073          	ecall
 ret
 306:	8082                	ret

0000000000000308 <read>:
.global read
read:
 li a7, SYS_read
 308:	4895                	li	a7,5
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <write>:
.global write
write:
 li a7, SYS_write
 310:	48c1                	li	a7,16
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <close>:
.global close
close:
 li a7, SYS_close
 318:	48d5                	li	a7,21
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <kill>:
.global kill
kill:
 li a7, SYS_kill
 320:	4899                	li	a7,6
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <exec>:
.global exec
exec:
 li a7, SYS_exec
 328:	489d                	li	a7,7
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <open>:
.global open
open:
 li a7, SYS_open
 330:	48bd                	li	a7,15
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 338:	48c5                	li	a7,17
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 340:	48c9                	li	a7,18
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 348:	48a1                	li	a7,8
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <link>:
.global link
link:
 li a7, SYS_link
 350:	48cd                	li	a7,19
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 358:	48d1                	li	a7,20
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 360:	48a5                	li	a7,9
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <dup>:
.global dup
dup:
 li a7, SYS_dup
 368:	48a9                	li	a7,10
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 370:	48ad                	li	a7,11
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 378:	48b1                	li	a7,12
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <pause>:
.global pause
pause:
 li a7, SYS_pause
 380:	48b5                	li	a7,13
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 388:	48b9                	li	a7,14
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 390:	1101                	addi	sp,sp,-32
 392:	ec06                	sd	ra,24(sp)
 394:	e822                	sd	s0,16(sp)
 396:	1000                	addi	s0,sp,32
 398:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 39c:	4605                	li	a2,1
 39e:	fef40593          	addi	a1,s0,-17
 3a2:	f6fff0ef          	jal	310 <write>
}
 3a6:	60e2                	ld	ra,24(sp)
 3a8:	6442                	ld	s0,16(sp)
 3aa:	6105                	addi	sp,sp,32
 3ac:	8082                	ret

00000000000003ae <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3ae:	715d                	addi	sp,sp,-80
 3b0:	e486                	sd	ra,72(sp)
 3b2:	e0a2                	sd	s0,64(sp)
 3b4:	f84a                	sd	s2,48(sp)
 3b6:	f44e                	sd	s3,40(sp)
 3b8:	0880                	addi	s0,sp,80
 3ba:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3bc:	cac1                	beqz	a3,44c <printint+0x9e>
 3be:	0805d763          	bgez	a1,44c <printint+0x9e>
    neg = 1;
    x = -xx;
 3c2:	40b005bb          	negw	a1,a1
    neg = 1;
 3c6:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 3c8:	fb840993          	addi	s3,s0,-72
  neg = 0;
 3cc:	86ce                	mv	a3,s3
  i = 0;
 3ce:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 3d0:	00000817          	auipc	a6,0x0
 3d4:	54080813          	addi	a6,a6,1344 # 910 <digits>
 3d8:	88ba                	mv	a7,a4
 3da:	0017051b          	addiw	a0,a4,1
 3de:	872a                	mv	a4,a0
 3e0:	02c5f7bb          	remuw	a5,a1,a2
 3e4:	1782                	slli	a5,a5,0x20
 3e6:	9381                	srli	a5,a5,0x20
 3e8:	97c2                	add	a5,a5,a6
 3ea:	0007c783          	lbu	a5,0(a5)
 3ee:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 3f2:	87ae                	mv	a5,a1
 3f4:	02c5d5bb          	divuw	a1,a1,a2
 3f8:	0685                	addi	a3,a3,1
 3fa:	fcc7ffe3          	bgeu	a5,a2,3d8 <printint+0x2a>
  if(neg)
 3fe:	00030c63          	beqz	t1,416 <printint+0x68>
    buf[i++] = '-';
 402:	fd050793          	addi	a5,a0,-48
 406:	00878533          	add	a0,a5,s0
 40a:	02d00793          	li	a5,45
 40e:	fef50423          	sb	a5,-24(a0)
 412:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 416:	02e05563          	blez	a4,440 <printint+0x92>
 41a:	fc26                	sd	s1,56(sp)
 41c:	377d                	addiw	a4,a4,-1
 41e:	00e984b3          	add	s1,s3,a4
 422:	19fd                	addi	s3,s3,-1
 424:	99ba                	add	s3,s3,a4
 426:	1702                	slli	a4,a4,0x20
 428:	9301                	srli	a4,a4,0x20
 42a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 42e:	0004c583          	lbu	a1,0(s1)
 432:	854a                	mv	a0,s2
 434:	f5dff0ef          	jal	390 <putc>
  while(--i >= 0)
 438:	14fd                	addi	s1,s1,-1
 43a:	ff349ae3          	bne	s1,s3,42e <printint+0x80>
 43e:	74e2                	ld	s1,56(sp)
}
 440:	60a6                	ld	ra,72(sp)
 442:	6406                	ld	s0,64(sp)
 444:	7942                	ld	s2,48(sp)
 446:	79a2                	ld	s3,40(sp)
 448:	6161                	addi	sp,sp,80
 44a:	8082                	ret
    x = xx;
 44c:	2581                	sext.w	a1,a1
  neg = 0;
 44e:	4301                	li	t1,0
 450:	bfa5                	j	3c8 <printint+0x1a>

0000000000000452 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 452:	711d                	addi	sp,sp,-96
 454:	ec86                	sd	ra,88(sp)
 456:	e8a2                	sd	s0,80(sp)
 458:	e4a6                	sd	s1,72(sp)
 45a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 45c:	0005c483          	lbu	s1,0(a1)
 460:	22048363          	beqz	s1,686 <vprintf+0x234>
 464:	e0ca                	sd	s2,64(sp)
 466:	fc4e                	sd	s3,56(sp)
 468:	f852                	sd	s4,48(sp)
 46a:	f456                	sd	s5,40(sp)
 46c:	f05a                	sd	s6,32(sp)
 46e:	ec5e                	sd	s7,24(sp)
 470:	e862                	sd	s8,16(sp)
 472:	8b2a                	mv	s6,a0
 474:	8a2e                	mv	s4,a1
 476:	8bb2                	mv	s7,a2
  state = 0;
 478:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 47a:	4901                	li	s2,0
 47c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 47e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 482:	06400c13          	li	s8,100
 486:	a00d                	j	4a8 <vprintf+0x56>
        putc(fd, c0);
 488:	85a6                	mv	a1,s1
 48a:	855a                	mv	a0,s6
 48c:	f05ff0ef          	jal	390 <putc>
 490:	a019                	j	496 <vprintf+0x44>
    } else if(state == '%'){
 492:	03598363          	beq	s3,s5,4b8 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 496:	0019079b          	addiw	a5,s2,1
 49a:	893e                	mv	s2,a5
 49c:	873e                	mv	a4,a5
 49e:	97d2                	add	a5,a5,s4
 4a0:	0007c483          	lbu	s1,0(a5)
 4a4:	1c048a63          	beqz	s1,678 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4a8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ac:	fe0993e3          	bnez	s3,492 <vprintf+0x40>
      if(c0 == '%'){
 4b0:	fd579ce3          	bne	a5,s5,488 <vprintf+0x36>
        state = '%';
 4b4:	89be                	mv	s3,a5
 4b6:	b7c5                	j	496 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4b8:	00ea06b3          	add	a3,s4,a4
 4bc:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 4c0:	1c060863          	beqz	a2,690 <vprintf+0x23e>
      if(c0 == 'd'){
 4c4:	03878763          	beq	a5,s8,4f2 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 4c8:	f9478693          	addi	a3,a5,-108
 4cc:	0016b693          	seqz	a3,a3
 4d0:	f9c60593          	addi	a1,a2,-100
 4d4:	e99d                	bnez	a1,50a <vprintf+0xb8>
 4d6:	ca95                	beqz	a3,50a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 4d8:	008b8493          	addi	s1,s7,8
 4dc:	4685                	li	a3,1
 4de:	4629                	li	a2,10
 4e0:	000bb583          	ld	a1,0(s7)
 4e4:	855a                	mv	a0,s6
 4e6:	ec9ff0ef          	jal	3ae <printint>
        i += 1;
 4ea:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 4ec:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 4ee:	4981                	li	s3,0
 4f0:	b75d                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 4f2:	008b8493          	addi	s1,s7,8
 4f6:	4685                	li	a3,1
 4f8:	4629                	li	a2,10
 4fa:	000ba583          	lw	a1,0(s7)
 4fe:	855a                	mv	a0,s6
 500:	eafff0ef          	jal	3ae <printint>
 504:	8ba6                	mv	s7,s1
      state = 0;
 506:	4981                	li	s3,0
 508:	b779                	j	496 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 50a:	9752                	add	a4,a4,s4
 50c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 510:	f9460713          	addi	a4,a2,-108
 514:	00173713          	seqz	a4,a4
 518:	8f75                	and	a4,a4,a3
 51a:	f9c58513          	addi	a0,a1,-100
 51e:	18051363          	bnez	a0,6a4 <vprintf+0x252>
 522:	18070163          	beqz	a4,6a4 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 526:	008b8493          	addi	s1,s7,8
 52a:	4685                	li	a3,1
 52c:	4629                	li	a2,10
 52e:	000bb583          	ld	a1,0(s7)
 532:	855a                	mv	a0,s6
 534:	e7bff0ef          	jal	3ae <printint>
        i += 2;
 538:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 53a:	8ba6                	mv	s7,s1
      state = 0;
 53c:	4981                	li	s3,0
        i += 2;
 53e:	bfa1                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 540:	008b8493          	addi	s1,s7,8
 544:	4681                	li	a3,0
 546:	4629                	li	a2,10
 548:	000be583          	lwu	a1,0(s7)
 54c:	855a                	mv	a0,s6
 54e:	e61ff0ef          	jal	3ae <printint>
 552:	8ba6                	mv	s7,s1
      state = 0;
 554:	4981                	li	s3,0
 556:	b781                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 558:	008b8493          	addi	s1,s7,8
 55c:	4681                	li	a3,0
 55e:	4629                	li	a2,10
 560:	000bb583          	ld	a1,0(s7)
 564:	855a                	mv	a0,s6
 566:	e49ff0ef          	jal	3ae <printint>
        i += 1;
 56a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 56c:	8ba6                	mv	s7,s1
      state = 0;
 56e:	4981                	li	s3,0
 570:	b71d                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 572:	008b8493          	addi	s1,s7,8
 576:	4681                	li	a3,0
 578:	4629                	li	a2,10
 57a:	000bb583          	ld	a1,0(s7)
 57e:	855a                	mv	a0,s6
 580:	e2fff0ef          	jal	3ae <printint>
        i += 2;
 584:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 586:	8ba6                	mv	s7,s1
      state = 0;
 588:	4981                	li	s3,0
        i += 2;
 58a:	b731                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 58c:	008b8493          	addi	s1,s7,8
 590:	4681                	li	a3,0
 592:	4641                	li	a2,16
 594:	000be583          	lwu	a1,0(s7)
 598:	855a                	mv	a0,s6
 59a:	e15ff0ef          	jal	3ae <printint>
 59e:	8ba6                	mv	s7,s1
      state = 0;
 5a0:	4981                	li	s3,0
 5a2:	bdd5                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4641                	li	a2,16
 5ac:	000bb583          	ld	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	dfdff0ef          	jal	3ae <printint>
        i += 1;
 5b6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5b8:	8ba6                	mv	s7,s1
      state = 0;
 5ba:	4981                	li	s3,0
 5bc:	bde9                	j	496 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5be:	008b8493          	addi	s1,s7,8
 5c2:	4681                	li	a3,0
 5c4:	4641                	li	a2,16
 5c6:	000bb583          	ld	a1,0(s7)
 5ca:	855a                	mv	a0,s6
 5cc:	de3ff0ef          	jal	3ae <printint>
        i += 2;
 5d0:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 5d2:	8ba6                	mv	s7,s1
      state = 0;
 5d4:	4981                	li	s3,0
        i += 2;
 5d6:	b5c1                	j	496 <vprintf+0x44>
 5d8:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 5da:	008b8793          	addi	a5,s7,8
 5de:	8cbe                	mv	s9,a5
 5e0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 5e4:	03000593          	li	a1,48
 5e8:	855a                	mv	a0,s6
 5ea:	da7ff0ef          	jal	390 <putc>
  putc(fd, 'x');
 5ee:	07800593          	li	a1,120
 5f2:	855a                	mv	a0,s6
 5f4:	d9dff0ef          	jal	390 <putc>
 5f8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 5fa:	00000b97          	auipc	s7,0x0
 5fe:	316b8b93          	addi	s7,s7,790 # 910 <digits>
 602:	03c9d793          	srli	a5,s3,0x3c
 606:	97de                	add	a5,a5,s7
 608:	0007c583          	lbu	a1,0(a5)
 60c:	855a                	mv	a0,s6
 60e:	d83ff0ef          	jal	390 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 612:	0992                	slli	s3,s3,0x4
 614:	34fd                	addiw	s1,s1,-1
 616:	f4f5                	bnez	s1,602 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 618:	8be6                	mv	s7,s9
      state = 0;
 61a:	4981                	li	s3,0
 61c:	6ca2                	ld	s9,8(sp)
 61e:	bda5                	j	496 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 620:	008b8493          	addi	s1,s7,8
 624:	000bc583          	lbu	a1,0(s7)
 628:	855a                	mv	a0,s6
 62a:	d67ff0ef          	jal	390 <putc>
 62e:	8ba6                	mv	s7,s1
      state = 0;
 630:	4981                	li	s3,0
 632:	b595                	j	496 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 634:	008b8993          	addi	s3,s7,8
 638:	000bb483          	ld	s1,0(s7)
 63c:	cc91                	beqz	s1,658 <vprintf+0x206>
        for(; *s; s++)
 63e:	0004c583          	lbu	a1,0(s1)
 642:	c985                	beqz	a1,672 <vprintf+0x220>
          putc(fd, *s);
 644:	855a                	mv	a0,s6
 646:	d4bff0ef          	jal	390 <putc>
        for(; *s; s++)
 64a:	0485                	addi	s1,s1,1
 64c:	0004c583          	lbu	a1,0(s1)
 650:	f9f5                	bnez	a1,644 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 652:	8bce                	mv	s7,s3
      state = 0;
 654:	4981                	li	s3,0
 656:	b581                	j	496 <vprintf+0x44>
          s = "(null)";
 658:	00000497          	auipc	s1,0x0
 65c:	2b048493          	addi	s1,s1,688 # 908 <malloc+0x114>
        for(; *s; s++)
 660:	02800593          	li	a1,40
 664:	b7c5                	j	644 <vprintf+0x1f2>
        putc(fd, '%');
 666:	85be                	mv	a1,a5
 668:	855a                	mv	a0,s6
 66a:	d27ff0ef          	jal	390 <putc>
      state = 0;
 66e:	4981                	li	s3,0
 670:	b51d                	j	496 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 672:	8bce                	mv	s7,s3
      state = 0;
 674:	4981                	li	s3,0
 676:	b505                	j	496 <vprintf+0x44>
 678:	6906                	ld	s2,64(sp)
 67a:	79e2                	ld	s3,56(sp)
 67c:	7a42                	ld	s4,48(sp)
 67e:	7aa2                	ld	s5,40(sp)
 680:	7b02                	ld	s6,32(sp)
 682:	6be2                	ld	s7,24(sp)
 684:	6c42                	ld	s8,16(sp)
    }
  }
}
 686:	60e6                	ld	ra,88(sp)
 688:	6446                	ld	s0,80(sp)
 68a:	64a6                	ld	s1,72(sp)
 68c:	6125                	addi	sp,sp,96
 68e:	8082                	ret
      if(c0 == 'd'){
 690:	06400713          	li	a4,100
 694:	e4e78fe3          	beq	a5,a4,4f2 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 698:	f9478693          	addi	a3,a5,-108
 69c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6a0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6a4:	07500513          	li	a0,117
 6a8:	e8a78ce3          	beq	a5,a0,540 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6ac:	f8b60513          	addi	a0,a2,-117
 6b0:	e119                	bnez	a0,6b6 <vprintf+0x264>
 6b2:	ea0693e3          	bnez	a3,558 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6b6:	f8b58513          	addi	a0,a1,-117
 6ba:	e119                	bnez	a0,6c0 <vprintf+0x26e>
 6bc:	ea071be3          	bnez	a4,572 <vprintf+0x120>
      } else if(c0 == 'x'){
 6c0:	07800513          	li	a0,120
 6c4:	eca784e3          	beq	a5,a0,58c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 6c8:	f8860613          	addi	a2,a2,-120
 6cc:	e219                	bnez	a2,6d2 <vprintf+0x280>
 6ce:	ec069be3          	bnez	a3,5a4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 6d2:	f8858593          	addi	a1,a1,-120
 6d6:	e199                	bnez	a1,6dc <vprintf+0x28a>
 6d8:	ee0713e3          	bnez	a4,5be <vprintf+0x16c>
      } else if(c0 == 'p'){
 6dc:	07000713          	li	a4,112
 6e0:	eee78ce3          	beq	a5,a4,5d8 <vprintf+0x186>
      } else if(c0 == 'c'){
 6e4:	06300713          	li	a4,99
 6e8:	f2e78ce3          	beq	a5,a4,620 <vprintf+0x1ce>
      } else if(c0 == 's'){
 6ec:	07300713          	li	a4,115
 6f0:	f4e782e3          	beq	a5,a4,634 <vprintf+0x1e2>
      } else if(c0 == '%'){
 6f4:	02500713          	li	a4,37
 6f8:	f6e787e3          	beq	a5,a4,666 <vprintf+0x214>
        putc(fd, '%');
 6fc:	02500593          	li	a1,37
 700:	855a                	mv	a0,s6
 702:	c8fff0ef          	jal	390 <putc>
        putc(fd, c0);
 706:	85a6                	mv	a1,s1
 708:	855a                	mv	a0,s6
 70a:	c87ff0ef          	jal	390 <putc>
      state = 0;
 70e:	4981                	li	s3,0
 710:	b359                	j	496 <vprintf+0x44>

0000000000000712 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 712:	715d                	addi	sp,sp,-80
 714:	ec06                	sd	ra,24(sp)
 716:	e822                	sd	s0,16(sp)
 718:	1000                	addi	s0,sp,32
 71a:	e010                	sd	a2,0(s0)
 71c:	e414                	sd	a3,8(s0)
 71e:	e818                	sd	a4,16(s0)
 720:	ec1c                	sd	a5,24(s0)
 722:	03043023          	sd	a6,32(s0)
 726:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 72a:	8622                	mv	a2,s0
 72c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 730:	d23ff0ef          	jal	452 <vprintf>
}
 734:	60e2                	ld	ra,24(sp)
 736:	6442                	ld	s0,16(sp)
 738:	6161                	addi	sp,sp,80
 73a:	8082                	ret

000000000000073c <printf>:

void
printf(const char *fmt, ...)
{
 73c:	711d                	addi	sp,sp,-96
 73e:	ec06                	sd	ra,24(sp)
 740:	e822                	sd	s0,16(sp)
 742:	1000                	addi	s0,sp,32
 744:	e40c                	sd	a1,8(s0)
 746:	e810                	sd	a2,16(s0)
 748:	ec14                	sd	a3,24(s0)
 74a:	f018                	sd	a4,32(s0)
 74c:	f41c                	sd	a5,40(s0)
 74e:	03043823          	sd	a6,48(s0)
 752:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 756:	00840613          	addi	a2,s0,8
 75a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 75e:	85aa                	mv	a1,a0
 760:	4505                	li	a0,1
 762:	cf1ff0ef          	jal	452 <vprintf>
}
 766:	60e2                	ld	ra,24(sp)
 768:	6442                	ld	s0,16(sp)
 76a:	6125                	addi	sp,sp,96
 76c:	8082                	ret

000000000000076e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 76e:	1141                	addi	sp,sp,-16
 770:	e406                	sd	ra,8(sp)
 772:	e022                	sd	s0,0(sp)
 774:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 776:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 77a:	00001797          	auipc	a5,0x1
 77e:	8867b783          	ld	a5,-1914(a5) # 1000 <freep>
 782:	a039                	j	790 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 784:	6398                	ld	a4,0(a5)
 786:	00e7e463          	bltu	a5,a4,78e <free+0x20>
 78a:	00e6ea63          	bltu	a3,a4,79e <free+0x30>
{
 78e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 790:	fed7fae3          	bgeu	a5,a3,784 <free+0x16>
 794:	6398                	ld	a4,0(a5)
 796:	00e6e463          	bltu	a3,a4,79e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 79a:	fee7eae3          	bltu	a5,a4,78e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 79e:	ff852583          	lw	a1,-8(a0)
 7a2:	6390                	ld	a2,0(a5)
 7a4:	02059813          	slli	a6,a1,0x20
 7a8:	01c85713          	srli	a4,a6,0x1c
 7ac:	9736                	add	a4,a4,a3
 7ae:	02e60563          	beq	a2,a4,7d8 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7b2:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7b6:	4790                	lw	a2,8(a5)
 7b8:	02061593          	slli	a1,a2,0x20
 7bc:	01c5d713          	srli	a4,a1,0x1c
 7c0:	973e                	add	a4,a4,a5
 7c2:	02e68263          	beq	a3,a4,7e6 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 7c6:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 7c8:	00001717          	auipc	a4,0x1
 7cc:	82f73c23          	sd	a5,-1992(a4) # 1000 <freep>
}
 7d0:	60a2                	ld	ra,8(sp)
 7d2:	6402                	ld	s0,0(sp)
 7d4:	0141                	addi	sp,sp,16
 7d6:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 7d8:	4618                	lw	a4,8(a2)
 7da:	9f2d                	addw	a4,a4,a1
 7dc:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 7e0:	6398                	ld	a4,0(a5)
 7e2:	6310                	ld	a2,0(a4)
 7e4:	b7f9                	j	7b2 <free+0x44>
    p->s.size += bp->s.size;
 7e6:	ff852703          	lw	a4,-8(a0)
 7ea:	9f31                	addw	a4,a4,a2
 7ec:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 7ee:	ff053683          	ld	a3,-16(a0)
 7f2:	bfd1                	j	7c6 <free+0x58>

00000000000007f4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 7f4:	7139                	addi	sp,sp,-64
 7f6:	fc06                	sd	ra,56(sp)
 7f8:	f822                	sd	s0,48(sp)
 7fa:	f04a                	sd	s2,32(sp)
 7fc:	ec4e                	sd	s3,24(sp)
 7fe:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 800:	02051993          	slli	s3,a0,0x20
 804:	0209d993          	srli	s3,s3,0x20
 808:	09bd                	addi	s3,s3,15
 80a:	0049d993          	srli	s3,s3,0x4
 80e:	2985                	addiw	s3,s3,1
 810:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 812:	00000517          	auipc	a0,0x0
 816:	7ee53503          	ld	a0,2030(a0) # 1000 <freep>
 81a:	c905                	beqz	a0,84a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 81c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 81e:	4798                	lw	a4,8(a5)
 820:	09377663          	bgeu	a4,s3,8ac <malloc+0xb8>
 824:	f426                	sd	s1,40(sp)
 826:	e852                	sd	s4,16(sp)
 828:	e456                	sd	s5,8(sp)
 82a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 82c:	8a4e                	mv	s4,s3
 82e:	6705                	lui	a4,0x1
 830:	00e9f363          	bgeu	s3,a4,836 <malloc+0x42>
 834:	6a05                	lui	s4,0x1
 836:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 83a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 83e:	00000497          	auipc	s1,0x0
 842:	7c248493          	addi	s1,s1,1986 # 1000 <freep>
  if(p == SBRK_ERROR)
 846:	5afd                	li	s5,-1
 848:	a83d                	j	886 <malloc+0x92>
 84a:	f426                	sd	s1,40(sp)
 84c:	e852                	sd	s4,16(sp)
 84e:	e456                	sd	s5,8(sp)
 850:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 852:	00000797          	auipc	a5,0x0
 856:	7be78793          	addi	a5,a5,1982 # 1010 <base>
 85a:	00000717          	auipc	a4,0x0
 85e:	7af73323          	sd	a5,1958(a4) # 1000 <freep>
 862:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 864:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 868:	b7d1                	j	82c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 86a:	6398                	ld	a4,0(a5)
 86c:	e118                	sd	a4,0(a0)
 86e:	a899                	j	8c4 <malloc+0xd0>
  hp->s.size = nu;
 870:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 874:	0541                	addi	a0,a0,16
 876:	ef9ff0ef          	jal	76e <free>
  return freep;
 87a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 87c:	c125                	beqz	a0,8dc <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 87e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 880:	4798                	lw	a4,8(a5)
 882:	03277163          	bgeu	a4,s2,8a4 <malloc+0xb0>
    if(p == freep)
 886:	6098                	ld	a4,0(s1)
 888:	853e                	mv	a0,a5
 88a:	fef71ae3          	bne	a4,a5,87e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 88e:	8552                	mv	a0,s4
 890:	a2dff0ef          	jal	2bc <sbrk>
  if(p == SBRK_ERROR)
 894:	fd551ee3          	bne	a0,s5,870 <malloc+0x7c>
        return 0;
 898:	4501                	li	a0,0
 89a:	74a2                	ld	s1,40(sp)
 89c:	6a42                	ld	s4,16(sp)
 89e:	6aa2                	ld	s5,8(sp)
 8a0:	6b02                	ld	s6,0(sp)
 8a2:	a03d                	j	8d0 <malloc+0xdc>
 8a4:	74a2                	ld	s1,40(sp)
 8a6:	6a42                	ld	s4,16(sp)
 8a8:	6aa2                	ld	s5,8(sp)
 8aa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ac:	fae90fe3          	beq	s2,a4,86a <malloc+0x76>
        p->s.size -= nunits;
 8b0:	4137073b          	subw	a4,a4,s3
 8b4:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8b6:	02071693          	slli	a3,a4,0x20
 8ba:	01c6d713          	srli	a4,a3,0x1c
 8be:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 8c0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 8c4:	00000717          	auipc	a4,0x0
 8c8:	72a73e23          	sd	a0,1852(a4) # 1000 <freep>
      return (void*)(p + 1);
 8cc:	01078513          	addi	a0,a5,16
  }
}
 8d0:	70e2                	ld	ra,56(sp)
 8d2:	7442                	ld	s0,48(sp)
 8d4:	7902                	ld	s2,32(sp)
 8d6:	69e2                	ld	s3,24(sp)
 8d8:	6121                	addi	sp,sp,64
 8da:	8082                	ret
 8dc:	74a2                	ld	s1,40(sp)
 8de:	6a42                	ld	s4,16(sp)
 8e0:	6aa2                	ld	s5,8(sp)
 8e2:	6b02                	ld	s6,0(sp)
 8e4:	b7f5                	j	8d0 <malloc+0xdc>
