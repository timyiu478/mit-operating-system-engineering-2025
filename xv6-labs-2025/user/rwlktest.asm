
user/_rwlktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/types.h"
#include "user/user.h"

int
main(void)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
   a:	4491                	li	s1,4
  int ncpu = 4;

  for (int i = 0; i < ncpu; i++) {
    if (fork() == 0) {
   c:	2fc000ef          	jal	308 <fork>
  10:	c911                	beqz	a0,24 <main+0x24>
  for (int i = 0; i < ncpu; i++) {
  12:	34fd                	addiw	s1,s1,-1
  14:	fce5                	bnez	s1,c <main+0xc>
  16:	f04a                	sd	s2,32(sp)
  18:	ec4e                	sd	s3,24(sp)
  1a:	4491                	li	s1,4
      int r = rwlktest();
      exit(r);
    }
  }

  int passed = 0;
  1c:	4901                	li	s2,0
  for (int i = 0; i < ncpu; i++) {
    int status;
    wait(&status);
  1e:	fcc40993          	addi	s3,s0,-52
  22:	a809                	j	34 <main+0x34>
  24:	f04a                	sd	s2,32(sp)
  26:	ec4e                	sd	s3,24(sp)
      int r = rwlktest();
  28:	3be000ef          	jal	3e6 <rwlktest>
      exit(r);
  2c:	2e4000ef          	jal	310 <exit>
  for (int i = 0; i < ncpu; i++) {
  30:	34fd                	addiw	s1,s1,-1
  32:	c889                	beqz	s1,44 <main+0x44>
    wait(&status);
  34:	854e                	mv	a0,s3
  36:	2e2000ef          	jal	318 <wait>
    if (status == 0)
  3a:	fcc42783          	lw	a5,-52(s0)
  3e:	fbed                	bnez	a5,30 <main+0x30>
      passed++;
  40:	2905                	addiw	s2,s2,1
  42:	b7fd                	j	30 <main+0x30>
  }

  printf("rwlktest: %d/%d CPUs succeeded\n", passed, ncpu);
  44:	4611                	li	a2,4
  46:	85ca                	mv	a1,s2
  48:	00001517          	auipc	a0,0x1
  4c:	97850513          	addi	a0,a0,-1672 # 9c0 <statistics+0x76>
  50:	750000ef          	jal	7a0 <printf>
  exit(0);
  54:	4501                	li	a0,0
  56:	2ba000ef          	jal	310 <exit>

000000000000005a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  5a:	1141                	addi	sp,sp,-16
  5c:	e406                	sd	ra,8(sp)
  5e:	e022                	sd	s0,0(sp)
  60:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  62:	f9fff0ef          	jal	0 <main>
  exit(r);
  66:	2aa000ef          	jal	310 <exit>

000000000000006a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  6a:	1141                	addi	sp,sp,-16
  6c:	e406                	sd	ra,8(sp)
  6e:	e022                	sd	s0,0(sp)
  70:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  72:	87aa                	mv	a5,a0
  74:	0585                	addi	a1,a1,1
  76:	0785                	addi	a5,a5,1
  78:	fff5c703          	lbu	a4,-1(a1)
  7c:	fee78fa3          	sb	a4,-1(a5)
  80:	fb75                	bnez	a4,74 <strcpy+0xa>
    ;
  return os;
}
  82:	60a2                	ld	ra,8(sp)
  84:	6402                	ld	s0,0(sp)
  86:	0141                	addi	sp,sp,16
  88:	8082                	ret

000000000000008a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8a:	1141                	addi	sp,sp,-16
  8c:	e406                	sd	ra,8(sp)
  8e:	e022                	sd	s0,0(sp)
  90:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  92:	00054783          	lbu	a5,0(a0)
  96:	cb91                	beqz	a5,aa <strcmp+0x20>
  98:	0005c703          	lbu	a4,0(a1)
  9c:	00f71763          	bne	a4,a5,aa <strcmp+0x20>
    p++, q++;
  a0:	0505                	addi	a0,a0,1
  a2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  a4:	00054783          	lbu	a5,0(a0)
  a8:	fbe5                	bnez	a5,98 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  aa:	0005c503          	lbu	a0,0(a1)
}
  ae:	40a7853b          	subw	a0,a5,a0
  b2:	60a2                	ld	ra,8(sp)
  b4:	6402                	ld	s0,0(sp)
  b6:	0141                	addi	sp,sp,16
  b8:	8082                	ret

00000000000000ba <strlen>:

uint
strlen(const char *s)
{
  ba:	1141                	addi	sp,sp,-16
  bc:	e406                	sd	ra,8(sp)
  be:	e022                	sd	s0,0(sp)
  c0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  c2:	00054783          	lbu	a5,0(a0)
  c6:	cf91                	beqz	a5,e2 <strlen+0x28>
  c8:	00150793          	addi	a5,a0,1
  cc:	86be                	mv	a3,a5
  ce:	0785                	addi	a5,a5,1
  d0:	fff7c703          	lbu	a4,-1(a5)
  d4:	ff65                	bnez	a4,cc <strlen+0x12>
  d6:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  da:	60a2                	ld	ra,8(sp)
  dc:	6402                	ld	s0,0(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret
  for(n = 0; s[n]; n++)
  e2:	4501                	li	a0,0
  e4:	bfdd                	j	da <strlen+0x20>

00000000000000e6 <memset>:

void*
memset(void *dst, int c, uint n)
{
  e6:	1141                	addi	sp,sp,-16
  e8:	e406                	sd	ra,8(sp)
  ea:	e022                	sd	s0,0(sp)
  ec:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
  ee:	ca19                	beqz	a2,104 <memset+0x1e>
  f0:	87aa                	mv	a5,a0
  f2:	1602                	slli	a2,a2,0x20
  f4:	9201                	srli	a2,a2,0x20
  f6:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
  fa:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
  fe:	0785                	addi	a5,a5,1
 100:	fee79de3          	bne	a5,a4,fa <memset+0x14>
  }
  return dst;
}
 104:	60a2                	ld	ra,8(sp)
 106:	6402                	ld	s0,0(sp)
 108:	0141                	addi	sp,sp,16
 10a:	8082                	ret

000000000000010c <strchr>:

char*
strchr(const char *s, char c)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  for(; *s; s++)
 114:	00054783          	lbu	a5,0(a0)
 118:	cf81                	beqz	a5,130 <strchr+0x24>
    if(*s == c)
 11a:	00f58763          	beq	a1,a5,128 <strchr+0x1c>
  for(; *s; s++)
 11e:	0505                	addi	a0,a0,1
 120:	00054783          	lbu	a5,0(a0)
 124:	fbfd                	bnez	a5,11a <strchr+0xe>
      return (char*)s;
  return 0;
 126:	4501                	li	a0,0
}
 128:	60a2                	ld	ra,8(sp)
 12a:	6402                	ld	s0,0(sp)
 12c:	0141                	addi	sp,sp,16
 12e:	8082                	ret
  return 0;
 130:	4501                	li	a0,0
 132:	bfdd                	j	128 <strchr+0x1c>

0000000000000134 <gets>:

char*
gets(char *buf, int max)
{
 134:	711d                	addi	sp,sp,-96
 136:	ec86                	sd	ra,88(sp)
 138:	e8a2                	sd	s0,80(sp)
 13a:	e4a6                	sd	s1,72(sp)
 13c:	e0ca                	sd	s2,64(sp)
 13e:	fc4e                	sd	s3,56(sp)
 140:	f852                	sd	s4,48(sp)
 142:	f456                	sd	s5,40(sp)
 144:	f05a                	sd	s6,32(sp)
 146:	ec5e                	sd	s7,24(sp)
 148:	e862                	sd	s8,16(sp)
 14a:	1080                	addi	s0,sp,96
 14c:	8baa                	mv	s7,a0
 14e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 150:	892a                	mv	s2,a0
 152:	4481                	li	s1,0
    cc = read(0, &c, 1);
 154:	faf40b13          	addi	s6,s0,-81
 158:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 15a:	8c26                	mv	s8,s1
 15c:	0014899b          	addiw	s3,s1,1
 160:	84ce                	mv	s1,s3
 162:	0349d463          	bge	s3,s4,18a <gets+0x56>
    cc = read(0, &c, 1);
 166:	8656                	mv	a2,s5
 168:	85da                	mv	a1,s6
 16a:	4501                	li	a0,0
 16c:	1bc000ef          	jal	328 <read>
    if(cc < 1)
 170:	00a05d63          	blez	a0,18a <gets+0x56>
      break;
    buf[i++] = c;
 174:	faf44783          	lbu	a5,-81(s0)
 178:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 17c:	0905                	addi	s2,s2,1
 17e:	ff678713          	addi	a4,a5,-10
 182:	c319                	beqz	a4,188 <gets+0x54>
 184:	17cd                	addi	a5,a5,-13
 186:	fbf1                	bnez	a5,15a <gets+0x26>
    buf[i++] = c;
 188:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 18a:	9c5e                	add	s8,s8,s7
 18c:	000c0023          	sb	zero,0(s8)
  return buf;
}
 190:	855e                	mv	a0,s7
 192:	60e6                	ld	ra,88(sp)
 194:	6446                	ld	s0,80(sp)
 196:	64a6                	ld	s1,72(sp)
 198:	6906                	ld	s2,64(sp)
 19a:	79e2                	ld	s3,56(sp)
 19c:	7a42                	ld	s4,48(sp)
 19e:	7aa2                	ld	s5,40(sp)
 1a0:	7b02                	ld	s6,32(sp)
 1a2:	6be2                	ld	s7,24(sp)
 1a4:	6c42                	ld	s8,16(sp)
 1a6:	6125                	addi	sp,sp,96
 1a8:	8082                	ret

00000000000001aa <stat>:

int
stat(const char *n, struct stat *st)
{
 1aa:	1101                	addi	sp,sp,-32
 1ac:	ec06                	sd	ra,24(sp)
 1ae:	e822                	sd	s0,16(sp)
 1b0:	e04a                	sd	s2,0(sp)
 1b2:	1000                	addi	s0,sp,32
 1b4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1b6:	4581                	li	a1,0
 1b8:	198000ef          	jal	350 <open>
  if(fd < 0)
 1bc:	02054263          	bltz	a0,1e0 <stat+0x36>
 1c0:	e426                	sd	s1,8(sp)
 1c2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1c4:	85ca                	mv	a1,s2
 1c6:	1a2000ef          	jal	368 <fstat>
 1ca:	892a                	mv	s2,a0
  close(fd);
 1cc:	8526                	mv	a0,s1
 1ce:	16a000ef          	jal	338 <close>
  return r;
 1d2:	64a2                	ld	s1,8(sp)
}
 1d4:	854a                	mv	a0,s2
 1d6:	60e2                	ld	ra,24(sp)
 1d8:	6442                	ld	s0,16(sp)
 1da:	6902                	ld	s2,0(sp)
 1dc:	6105                	addi	sp,sp,32
 1de:	8082                	ret
    return -1;
 1e0:	57fd                	li	a5,-1
 1e2:	893e                	mv	s2,a5
 1e4:	bfc5                	j	1d4 <stat+0x2a>

00000000000001e6 <atoi>:

int
atoi(const char *s)
{
 1e6:	1141                	addi	sp,sp,-16
 1e8:	e406                	sd	ra,8(sp)
 1ea:	e022                	sd	s0,0(sp)
 1ec:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 1ee:	00054683          	lbu	a3,0(a0)
 1f2:	fd06879b          	addiw	a5,a3,-48
 1f6:	0ff7f793          	zext.b	a5,a5
 1fa:	4625                	li	a2,9
 1fc:	02f66963          	bltu	a2,a5,22e <atoi+0x48>
 200:	872a                	mv	a4,a0
  n = 0;
 202:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 204:	0705                	addi	a4,a4,1
 206:	0025179b          	slliw	a5,a0,0x2
 20a:	9fa9                	addw	a5,a5,a0
 20c:	0017979b          	slliw	a5,a5,0x1
 210:	9fb5                	addw	a5,a5,a3
 212:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 216:	00074683          	lbu	a3,0(a4)
 21a:	fd06879b          	addiw	a5,a3,-48
 21e:	0ff7f793          	zext.b	a5,a5
 222:	fef671e3          	bgeu	a2,a5,204 <atoi+0x1e>
  return n;
}
 226:	60a2                	ld	ra,8(sp)
 228:	6402                	ld	s0,0(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret
  n = 0;
 22e:	4501                	li	a0,0
 230:	bfdd                	j	226 <atoi+0x40>

0000000000000232 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 232:	1141                	addi	sp,sp,-16
 234:	e406                	sd	ra,8(sp)
 236:	e022                	sd	s0,0(sp)
 238:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 23a:	02b57563          	bgeu	a0,a1,264 <memmove+0x32>
    while(n-- > 0)
 23e:	00c05f63          	blez	a2,25c <memmove+0x2a>
 242:	1602                	slli	a2,a2,0x20
 244:	9201                	srli	a2,a2,0x20
 246:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 24a:	872a                	mv	a4,a0
      *dst++ = *src++;
 24c:	0585                	addi	a1,a1,1
 24e:	0705                	addi	a4,a4,1
 250:	fff5c683          	lbu	a3,-1(a1)
 254:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 258:	fee79ae3          	bne	a5,a4,24c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 25c:	60a2                	ld	ra,8(sp)
 25e:	6402                	ld	s0,0(sp)
 260:	0141                	addi	sp,sp,16
 262:	8082                	ret
    while(n-- > 0)
 264:	fec05ce3          	blez	a2,25c <memmove+0x2a>
    dst += n;
 268:	00c50733          	add	a4,a0,a2
    src += n;
 26c:	95b2                	add	a1,a1,a2
 26e:	fff6079b          	addiw	a5,a2,-1
 272:	1782                	slli	a5,a5,0x20
 274:	9381                	srli	a5,a5,0x20
 276:	fff7c793          	not	a5,a5
 27a:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 27c:	15fd                	addi	a1,a1,-1
 27e:	177d                	addi	a4,a4,-1
 280:	0005c683          	lbu	a3,0(a1)
 284:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 288:	fef71ae3          	bne	a4,a5,27c <memmove+0x4a>
 28c:	bfc1                	j	25c <memmove+0x2a>

000000000000028e <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 296:	c61d                	beqz	a2,2c4 <memcmp+0x36>
 298:	1602                	slli	a2,a2,0x20
 29a:	9201                	srli	a2,a2,0x20
 29c:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2a0:	00054783          	lbu	a5,0(a0)
 2a4:	0005c703          	lbu	a4,0(a1)
 2a8:	00e79863          	bne	a5,a4,2b8 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2ac:	0505                	addi	a0,a0,1
    p2++;
 2ae:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2b0:	fed518e3          	bne	a0,a3,2a0 <memcmp+0x12>
  }
  return 0;
 2b4:	4501                	li	a0,0
 2b6:	a019                	j	2bc <memcmp+0x2e>
      return *p1 - *p2;
 2b8:	40e7853b          	subw	a0,a5,a4
}
 2bc:	60a2                	ld	ra,8(sp)
 2be:	6402                	ld	s0,0(sp)
 2c0:	0141                	addi	sp,sp,16
 2c2:	8082                	ret
  return 0;
 2c4:	4501                	li	a0,0
 2c6:	bfdd                	j	2bc <memcmp+0x2e>

00000000000002c8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2c8:	1141                	addi	sp,sp,-16
 2ca:	e406                	sd	ra,8(sp)
 2cc:	e022                	sd	s0,0(sp)
 2ce:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2d0:	f63ff0ef          	jal	232 <memmove>
}
 2d4:	60a2                	ld	ra,8(sp)
 2d6:	6402                	ld	s0,0(sp)
 2d8:	0141                	addi	sp,sp,16
 2da:	8082                	ret

00000000000002dc <sbrk>:

char *
sbrk(int n) {
 2dc:	1141                	addi	sp,sp,-16
 2de:	e406                	sd	ra,8(sp)
 2e0:	e022                	sd	s0,0(sp)
 2e2:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2e4:	4585                	li	a1,1
 2e6:	0b2000ef          	jal	398 <sys_sbrk>
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <sbrklazy>:

char *
sbrklazy(int n) {
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 2fa:	4589                	li	a1,2
 2fc:	09c000ef          	jal	398 <sys_sbrk>
}
 300:	60a2                	ld	ra,8(sp)
 302:	6402                	ld	s0,0(sp)
 304:	0141                	addi	sp,sp,16
 306:	8082                	ret

0000000000000308 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 308:	4885                	li	a7,1
 ecall
 30a:	00000073          	ecall
 ret
 30e:	8082                	ret

0000000000000310 <exit>:
.global exit
exit:
 li a7, SYS_exit
 310:	4889                	li	a7,2
 ecall
 312:	00000073          	ecall
 ret
 316:	8082                	ret

0000000000000318 <wait>:
.global wait
wait:
 li a7, SYS_wait
 318:	488d                	li	a7,3
 ecall
 31a:	00000073          	ecall
 ret
 31e:	8082                	ret

0000000000000320 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 320:	4891                	li	a7,4
 ecall
 322:	00000073          	ecall
 ret
 326:	8082                	ret

0000000000000328 <read>:
.global read
read:
 li a7, SYS_read
 328:	4895                	li	a7,5
 ecall
 32a:	00000073          	ecall
 ret
 32e:	8082                	ret

0000000000000330 <write>:
.global write
write:
 li a7, SYS_write
 330:	48c1                	li	a7,16
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <close>:
.global close
close:
 li a7, SYS_close
 338:	48d5                	li	a7,21
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <kill>:
.global kill
kill:
 li a7, SYS_kill
 340:	4899                	li	a7,6
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <exec>:
.global exec
exec:
 li a7, SYS_exec
 348:	489d                	li	a7,7
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <open>:
.global open
open:
 li a7, SYS_open
 350:	48bd                	li	a7,15
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 358:	48c5                	li	a7,17
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 360:	48c9                	li	a7,18
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 368:	48a1                	li	a7,8
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <link>:
.global link
link:
 li a7, SYS_link
 370:	48cd                	li	a7,19
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 378:	48d1                	li	a7,20
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 380:	48a5                	li	a7,9
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <dup>:
.global dup
dup:
 li a7, SYS_dup
 388:	48a9                	li	a7,10
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 390:	48ad                	li	a7,11
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 398:	48b1                	li	a7,12
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3a0:	48b5                	li	a7,13
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3a8:	48b9                	li	a7,14
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3b0:	48f5                	li	a7,29
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 3b8:	48f9                	li	a7,30
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <send>:
.global send
send:
 li a7, SYS_send
 3c0:	48fd                	li	a7,31
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <recv>:
.global recv
recv:
 li a7, SYS_recv
 3c8:	02000893          	li	a7,32
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 3d2:	02100893          	li	a7,33
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 3dc:	02200893          	li	a7,34
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 3e6:	02300893          	li	a7,35
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 3f0:	02400893          	li	a7,36
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3fa:	1101                	addi	sp,sp,-32
 3fc:	ec06                	sd	ra,24(sp)
 3fe:	e822                	sd	s0,16(sp)
 400:	1000                	addi	s0,sp,32
 402:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 406:	4605                	li	a2,1
 408:	fef40593          	addi	a1,s0,-17
 40c:	f25ff0ef          	jal	330 <write>
}
 410:	60e2                	ld	ra,24(sp)
 412:	6442                	ld	s0,16(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret

0000000000000418 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 418:	715d                	addi	sp,sp,-80
 41a:	e486                	sd	ra,72(sp)
 41c:	e0a2                	sd	s0,64(sp)
 41e:	f84a                	sd	s2,48(sp)
 420:	f44e                	sd	s3,40(sp)
 422:	0880                	addi	s0,sp,80
 424:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 426:	c6d1                	beqz	a3,4b2 <printint+0x9a>
 428:	0805d563          	bgez	a1,4b2 <printint+0x9a>
    neg = 1;
    x = -xx;
 42c:	40b005b3          	neg	a1,a1
    neg = 1;
 430:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 432:	fb840993          	addi	s3,s0,-72
  neg = 0;
 436:	86ce                	mv	a3,s3
  i = 0;
 438:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 43a:	00000817          	auipc	a6,0x0
 43e:	5d680813          	addi	a6,a6,1494 # a10 <digits>
 442:	88ba                	mv	a7,a4
 444:	0017051b          	addiw	a0,a4,1
 448:	872a                	mv	a4,a0
 44a:	02c5f7b3          	remu	a5,a1,a2
 44e:	97c2                	add	a5,a5,a6
 450:	0007c783          	lbu	a5,0(a5)
 454:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 458:	87ae                	mv	a5,a1
 45a:	02c5d5b3          	divu	a1,a1,a2
 45e:	0685                	addi	a3,a3,1
 460:	fec7f1e3          	bgeu	a5,a2,442 <printint+0x2a>
  if(neg)
 464:	00030c63          	beqz	t1,47c <printint+0x64>
    buf[i++] = '-';
 468:	fd050793          	addi	a5,a0,-48
 46c:	00878533          	add	a0,a5,s0
 470:	02d00793          	li	a5,45
 474:	fef50423          	sb	a5,-24(a0)
 478:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 47c:	02e05563          	blez	a4,4a6 <printint+0x8e>
 480:	fc26                	sd	s1,56(sp)
 482:	377d                	addiw	a4,a4,-1
 484:	00e984b3          	add	s1,s3,a4
 488:	19fd                	addi	s3,s3,-1
 48a:	99ba                	add	s3,s3,a4
 48c:	1702                	slli	a4,a4,0x20
 48e:	9301                	srli	a4,a4,0x20
 490:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 494:	0004c583          	lbu	a1,0(s1)
 498:	854a                	mv	a0,s2
 49a:	f61ff0ef          	jal	3fa <putc>
  while(--i >= 0)
 49e:	14fd                	addi	s1,s1,-1
 4a0:	ff349ae3          	bne	s1,s3,494 <printint+0x7c>
 4a4:	74e2                	ld	s1,56(sp)
}
 4a6:	60a6                	ld	ra,72(sp)
 4a8:	6406                	ld	s0,64(sp)
 4aa:	7942                	ld	s2,48(sp)
 4ac:	79a2                	ld	s3,40(sp)
 4ae:	6161                	addi	sp,sp,80
 4b0:	8082                	ret
  neg = 0;
 4b2:	4301                	li	t1,0
 4b4:	bfbd                	j	432 <printint+0x1a>

00000000000004b6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4b6:	711d                	addi	sp,sp,-96
 4b8:	ec86                	sd	ra,88(sp)
 4ba:	e8a2                	sd	s0,80(sp)
 4bc:	e4a6                	sd	s1,72(sp)
 4be:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4c0:	0005c483          	lbu	s1,0(a1)
 4c4:	22048363          	beqz	s1,6ea <vprintf+0x234>
 4c8:	e0ca                	sd	s2,64(sp)
 4ca:	fc4e                	sd	s3,56(sp)
 4cc:	f852                	sd	s4,48(sp)
 4ce:	f456                	sd	s5,40(sp)
 4d0:	f05a                	sd	s6,32(sp)
 4d2:	ec5e                	sd	s7,24(sp)
 4d4:	e862                	sd	s8,16(sp)
 4d6:	8b2a                	mv	s6,a0
 4d8:	8a2e                	mv	s4,a1
 4da:	8bb2                	mv	s7,a2
  state = 0;
 4dc:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4de:	4901                	li	s2,0
 4e0:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4e2:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4e6:	06400c13          	li	s8,100
 4ea:	a00d                	j	50c <vprintf+0x56>
        putc(fd, c0);
 4ec:	85a6                	mv	a1,s1
 4ee:	855a                	mv	a0,s6
 4f0:	f0bff0ef          	jal	3fa <putc>
 4f4:	a019                	j	4fa <vprintf+0x44>
    } else if(state == '%'){
 4f6:	03598363          	beq	s3,s5,51c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4fa:	0019079b          	addiw	a5,s2,1
 4fe:	893e                	mv	s2,a5
 500:	873e                	mv	a4,a5
 502:	97d2                	add	a5,a5,s4
 504:	0007c483          	lbu	s1,0(a5)
 508:	1c048a63          	beqz	s1,6dc <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 50c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 510:	fe0993e3          	bnez	s3,4f6 <vprintf+0x40>
      if(c0 == '%'){
 514:	fd579ce3          	bne	a5,s5,4ec <vprintf+0x36>
        state = '%';
 518:	89be                	mv	s3,a5
 51a:	b7c5                	j	4fa <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 51c:	00ea06b3          	add	a3,s4,a4
 520:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 524:	1c060863          	beqz	a2,6f4 <vprintf+0x23e>
      if(c0 == 'd'){
 528:	03878763          	beq	a5,s8,556 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 52c:	f9478693          	addi	a3,a5,-108
 530:	0016b693          	seqz	a3,a3
 534:	f9c60593          	addi	a1,a2,-100
 538:	e99d                	bnez	a1,56e <vprintf+0xb8>
 53a:	ca95                	beqz	a3,56e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 53c:	008b8493          	addi	s1,s7,8
 540:	4685                	li	a3,1
 542:	4629                	li	a2,10
 544:	000bb583          	ld	a1,0(s7)
 548:	855a                	mv	a0,s6
 54a:	ecfff0ef          	jal	418 <printint>
        i += 1;
 54e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 550:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 552:	4981                	li	s3,0
 554:	b75d                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 556:	008b8493          	addi	s1,s7,8
 55a:	4685                	li	a3,1
 55c:	4629                	li	a2,10
 55e:	000ba583          	lw	a1,0(s7)
 562:	855a                	mv	a0,s6
 564:	eb5ff0ef          	jal	418 <printint>
 568:	8ba6                	mv	s7,s1
      state = 0;
 56a:	4981                	li	s3,0
 56c:	b779                	j	4fa <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 56e:	9752                	add	a4,a4,s4
 570:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 574:	f9460713          	addi	a4,a2,-108
 578:	00173713          	seqz	a4,a4
 57c:	8f75                	and	a4,a4,a3
 57e:	f9c58513          	addi	a0,a1,-100
 582:	18051363          	bnez	a0,708 <vprintf+0x252>
 586:	18070163          	beqz	a4,708 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	008b8493          	addi	s1,s7,8
 58e:	4685                	li	a3,1
 590:	4629                	li	a2,10
 592:	000bb583          	ld	a1,0(s7)
 596:	855a                	mv	a0,s6
 598:	e81ff0ef          	jal	418 <printint>
        i += 2;
 59c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 59e:	8ba6                	mv	s7,s1
      state = 0;
 5a0:	4981                	li	s3,0
        i += 2;
 5a2:	bfa1                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5a4:	008b8493          	addi	s1,s7,8
 5a8:	4681                	li	a3,0
 5aa:	4629                	li	a2,10
 5ac:	000be583          	lwu	a1,0(s7)
 5b0:	855a                	mv	a0,s6
 5b2:	e67ff0ef          	jal	418 <printint>
 5b6:	8ba6                	mv	s7,s1
      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b781                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4681                	li	a3,0
 5c2:	4629                	li	a2,10
 5c4:	000bb583          	ld	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e4fff0ef          	jal	418 <printint>
        i += 1;
 5ce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
 5d4:	b71d                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000bb583          	ld	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e35ff0ef          	jal	418 <printint>
        i += 2;
 5e8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ea:	8ba6                	mv	s7,s1
      state = 0;
 5ec:	4981                	li	s3,0
        i += 2;
 5ee:	b731                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4681                	li	a3,0
 5f6:	4641                	li	a2,16
 5f8:	000be583          	lwu	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e1bff0ef          	jal	418 <printint>
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
 606:	bdd5                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4641                	li	a2,16
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e03ff0ef          	jal	418 <printint>
        i += 1;
 61a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	bde9                	j	4fa <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	de9ff0ef          	jal	418 <printint>
        i += 2;
 634:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
        i += 2;
 63a:	b5c1                	j	4fa <vprintf+0x44>
 63c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 63e:	008b8793          	addi	a5,s7,8
 642:	8cbe                	mv	s9,a5
 644:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 648:	03000593          	li	a1,48
 64c:	855a                	mv	a0,s6
 64e:	dadff0ef          	jal	3fa <putc>
  putc(fd, 'x');
 652:	07800593          	li	a1,120
 656:	855a                	mv	a0,s6
 658:	da3ff0ef          	jal	3fa <putc>
 65c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 65e:	00000b97          	auipc	s7,0x0
 662:	3b2b8b93          	addi	s7,s7,946 # a10 <digits>
 666:	03c9d793          	srli	a5,s3,0x3c
 66a:	97de                	add	a5,a5,s7
 66c:	0007c583          	lbu	a1,0(a5)
 670:	855a                	mv	a0,s6
 672:	d89ff0ef          	jal	3fa <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 676:	0992                	slli	s3,s3,0x4
 678:	34fd                	addiw	s1,s1,-1
 67a:	f4f5                	bnez	s1,666 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 67c:	8be6                	mv	s7,s9
      state = 0;
 67e:	4981                	li	s3,0
 680:	6ca2                	ld	s9,8(sp)
 682:	bda5                	j	4fa <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 684:	008b8493          	addi	s1,s7,8
 688:	000bc583          	lbu	a1,0(s7)
 68c:	855a                	mv	a0,s6
 68e:	d6dff0ef          	jal	3fa <putc>
 692:	8ba6                	mv	s7,s1
      state = 0;
 694:	4981                	li	s3,0
 696:	b595                	j	4fa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 698:	008b8993          	addi	s3,s7,8
 69c:	000bb483          	ld	s1,0(s7)
 6a0:	cc91                	beqz	s1,6bc <vprintf+0x206>
        for(; *s; s++)
 6a2:	0004c583          	lbu	a1,0(s1)
 6a6:	c985                	beqz	a1,6d6 <vprintf+0x220>
          putc(fd, *s);
 6a8:	855a                	mv	a0,s6
 6aa:	d51ff0ef          	jal	3fa <putc>
        for(; *s; s++)
 6ae:	0485                	addi	s1,s1,1
 6b0:	0004c583          	lbu	a1,0(s1)
 6b4:	f9f5                	bnez	a1,6a8 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6b6:	8bce                	mv	s7,s3
      state = 0;
 6b8:	4981                	li	s3,0
 6ba:	b581                	j	4fa <vprintf+0x44>
          s = "(null)";
 6bc:	00000497          	auipc	s1,0x0
 6c0:	32448493          	addi	s1,s1,804 # 9e0 <statistics+0x96>
        for(; *s; s++)
 6c4:	02800593          	li	a1,40
 6c8:	b7c5                	j	6a8 <vprintf+0x1f2>
        putc(fd, '%');
 6ca:	85be                	mv	a1,a5
 6cc:	855a                	mv	a0,s6
 6ce:	d2dff0ef          	jal	3fa <putc>
      state = 0;
 6d2:	4981                	li	s3,0
 6d4:	b51d                	j	4fa <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6d6:	8bce                	mv	s7,s3
      state = 0;
 6d8:	4981                	li	s3,0
 6da:	b505                	j	4fa <vprintf+0x44>
 6dc:	6906                	ld	s2,64(sp)
 6de:	79e2                	ld	s3,56(sp)
 6e0:	7a42                	ld	s4,48(sp)
 6e2:	7aa2                	ld	s5,40(sp)
 6e4:	7b02                	ld	s6,32(sp)
 6e6:	6be2                	ld	s7,24(sp)
 6e8:	6c42                	ld	s8,16(sp)
    }
  }
}
 6ea:	60e6                	ld	ra,88(sp)
 6ec:	6446                	ld	s0,80(sp)
 6ee:	64a6                	ld	s1,72(sp)
 6f0:	6125                	addi	sp,sp,96
 6f2:	8082                	ret
      if(c0 == 'd'){
 6f4:	06400713          	li	a4,100
 6f8:	e4e78fe3          	beq	a5,a4,556 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6fc:	f9478693          	addi	a3,a5,-108
 700:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 704:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 706:	4701                	li	a4,0
      } else if(c0 == 'u'){
 708:	07500513          	li	a0,117
 70c:	e8a78ce3          	beq	a5,a0,5a4 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 710:	f8b60513          	addi	a0,a2,-117
 714:	e119                	bnez	a0,71a <vprintf+0x264>
 716:	ea0693e3          	bnez	a3,5bc <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 71a:	f8b58513          	addi	a0,a1,-117
 71e:	e119                	bnez	a0,724 <vprintf+0x26e>
 720:	ea071be3          	bnez	a4,5d6 <vprintf+0x120>
      } else if(c0 == 'x'){
 724:	07800513          	li	a0,120
 728:	eca784e3          	beq	a5,a0,5f0 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 72c:	f8860613          	addi	a2,a2,-120
 730:	e219                	bnez	a2,736 <vprintf+0x280>
 732:	ec069be3          	bnez	a3,608 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 736:	f8858593          	addi	a1,a1,-120
 73a:	e199                	bnez	a1,740 <vprintf+0x28a>
 73c:	ee0713e3          	bnez	a4,622 <vprintf+0x16c>
      } else if(c0 == 'p'){
 740:	07000713          	li	a4,112
 744:	eee78ce3          	beq	a5,a4,63c <vprintf+0x186>
      } else if(c0 == 'c'){
 748:	06300713          	li	a4,99
 74c:	f2e78ce3          	beq	a5,a4,684 <vprintf+0x1ce>
      } else if(c0 == 's'){
 750:	07300713          	li	a4,115
 754:	f4e782e3          	beq	a5,a4,698 <vprintf+0x1e2>
      } else if(c0 == '%'){
 758:	02500713          	li	a4,37
 75c:	f6e787e3          	beq	a5,a4,6ca <vprintf+0x214>
        putc(fd, '%');
 760:	02500593          	li	a1,37
 764:	855a                	mv	a0,s6
 766:	c95ff0ef          	jal	3fa <putc>
        putc(fd, c0);
 76a:	85a6                	mv	a1,s1
 76c:	855a                	mv	a0,s6
 76e:	c8dff0ef          	jal	3fa <putc>
      state = 0;
 772:	4981                	li	s3,0
 774:	b359                	j	4fa <vprintf+0x44>

0000000000000776 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 776:	715d                	addi	sp,sp,-80
 778:	ec06                	sd	ra,24(sp)
 77a:	e822                	sd	s0,16(sp)
 77c:	1000                	addi	s0,sp,32
 77e:	e010                	sd	a2,0(s0)
 780:	e414                	sd	a3,8(s0)
 782:	e818                	sd	a4,16(s0)
 784:	ec1c                	sd	a5,24(s0)
 786:	03043023          	sd	a6,32(s0)
 78a:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 78e:	8622                	mv	a2,s0
 790:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 794:	d23ff0ef          	jal	4b6 <vprintf>
}
 798:	60e2                	ld	ra,24(sp)
 79a:	6442                	ld	s0,16(sp)
 79c:	6161                	addi	sp,sp,80
 79e:	8082                	ret

00000000000007a0 <printf>:

void
printf(const char *fmt, ...)
{
 7a0:	711d                	addi	sp,sp,-96
 7a2:	ec06                	sd	ra,24(sp)
 7a4:	e822                	sd	s0,16(sp)
 7a6:	1000                	addi	s0,sp,32
 7a8:	e40c                	sd	a1,8(s0)
 7aa:	e810                	sd	a2,16(s0)
 7ac:	ec14                	sd	a3,24(s0)
 7ae:	f018                	sd	a4,32(s0)
 7b0:	f41c                	sd	a5,40(s0)
 7b2:	03043823          	sd	a6,48(s0)
 7b6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ba:	00840613          	addi	a2,s0,8
 7be:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7c2:	85aa                	mv	a1,a0
 7c4:	4505                	li	a0,1
 7c6:	cf1ff0ef          	jal	4b6 <vprintf>
}
 7ca:	60e2                	ld	ra,24(sp)
 7cc:	6442                	ld	s0,16(sp)
 7ce:	6125                	addi	sp,sp,96
 7d0:	8082                	ret

00000000000007d2 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7d2:	1141                	addi	sp,sp,-16
 7d4:	e406                	sd	ra,8(sp)
 7d6:	e022                	sd	s0,0(sp)
 7d8:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7da:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7de:	00001797          	auipc	a5,0x1
 7e2:	8227b783          	ld	a5,-2014(a5) # 1000 <freep>
 7e6:	a039                	j	7f4 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7e8:	6398                	ld	a4,0(a5)
 7ea:	00e7e463          	bltu	a5,a4,7f2 <free+0x20>
 7ee:	00e6ea63          	bltu	a3,a4,802 <free+0x30>
{
 7f2:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7f4:	fed7fae3          	bgeu	a5,a3,7e8 <free+0x16>
 7f8:	6398                	ld	a4,0(a5)
 7fa:	00e6e463          	bltu	a3,a4,802 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7fe:	fee7eae3          	bltu	a5,a4,7f2 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 802:	ff852583          	lw	a1,-8(a0)
 806:	6390                	ld	a2,0(a5)
 808:	02059813          	slli	a6,a1,0x20
 80c:	01c85713          	srli	a4,a6,0x1c
 810:	9736                	add	a4,a4,a3
 812:	02e60563          	beq	a2,a4,83c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 816:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 81a:	4790                	lw	a2,8(a5)
 81c:	02061593          	slli	a1,a2,0x20
 820:	01c5d713          	srli	a4,a1,0x1c
 824:	973e                	add	a4,a4,a5
 826:	02e68263          	beq	a3,a4,84a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 82a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 82c:	00000717          	auipc	a4,0x0
 830:	7cf73a23          	sd	a5,2004(a4) # 1000 <freep>
}
 834:	60a2                	ld	ra,8(sp)
 836:	6402                	ld	s0,0(sp)
 838:	0141                	addi	sp,sp,16
 83a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 83c:	4618                	lw	a4,8(a2)
 83e:	9f2d                	addw	a4,a4,a1
 840:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 844:	6398                	ld	a4,0(a5)
 846:	6310                	ld	a2,0(a4)
 848:	b7f9                	j	816 <free+0x44>
    p->s.size += bp->s.size;
 84a:	ff852703          	lw	a4,-8(a0)
 84e:	9f31                	addw	a4,a4,a2
 850:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 852:	ff053683          	ld	a3,-16(a0)
 856:	bfd1                	j	82a <free+0x58>

0000000000000858 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 858:	7139                	addi	sp,sp,-64
 85a:	fc06                	sd	ra,56(sp)
 85c:	f822                	sd	s0,48(sp)
 85e:	f04a                	sd	s2,32(sp)
 860:	ec4e                	sd	s3,24(sp)
 862:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 864:	02051993          	slli	s3,a0,0x20
 868:	0209d993          	srli	s3,s3,0x20
 86c:	09bd                	addi	s3,s3,15
 86e:	0049d993          	srli	s3,s3,0x4
 872:	2985                	addiw	s3,s3,1
 874:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 876:	00000517          	auipc	a0,0x0
 87a:	78a53503          	ld	a0,1930(a0) # 1000 <freep>
 87e:	c905                	beqz	a0,8ae <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 880:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 882:	4798                	lw	a4,8(a5)
 884:	09377663          	bgeu	a4,s3,910 <malloc+0xb8>
 888:	f426                	sd	s1,40(sp)
 88a:	e852                	sd	s4,16(sp)
 88c:	e456                	sd	s5,8(sp)
 88e:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 890:	8a4e                	mv	s4,s3
 892:	6705                	lui	a4,0x1
 894:	00e9f363          	bgeu	s3,a4,89a <malloc+0x42>
 898:	6a05                	lui	s4,0x1
 89a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 89e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8a2:	00000497          	auipc	s1,0x0
 8a6:	75e48493          	addi	s1,s1,1886 # 1000 <freep>
  if(p == SBRK_ERROR)
 8aa:	5afd                	li	s5,-1
 8ac:	a83d                	j	8ea <malloc+0x92>
 8ae:	f426                	sd	s1,40(sp)
 8b0:	e852                	sd	s4,16(sp)
 8b2:	e456                	sd	s5,8(sp)
 8b4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8b6:	00000797          	auipc	a5,0x0
 8ba:	75a78793          	addi	a5,a5,1882 # 1010 <base>
 8be:	00000717          	auipc	a4,0x0
 8c2:	74f73123          	sd	a5,1858(a4) # 1000 <freep>
 8c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8cc:	b7d1                	j	890 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ce:	6398                	ld	a4,0(a5)
 8d0:	e118                	sd	a4,0(a0)
 8d2:	a899                	j	928 <malloc+0xd0>
  hp->s.size = nu;
 8d4:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8d8:	0541                	addi	a0,a0,16
 8da:	ef9ff0ef          	jal	7d2 <free>
  return freep;
 8de:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8e0:	c125                	beqz	a0,940 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e4:	4798                	lw	a4,8(a5)
 8e6:	03277163          	bgeu	a4,s2,908 <malloc+0xb0>
    if(p == freep)
 8ea:	6098                	ld	a4,0(s1)
 8ec:	853e                	mv	a0,a5
 8ee:	fef71ae3          	bne	a4,a5,8e2 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8f2:	8552                	mv	a0,s4
 8f4:	9e9ff0ef          	jal	2dc <sbrk>
  if(p == SBRK_ERROR)
 8f8:	fd551ee3          	bne	a0,s5,8d4 <malloc+0x7c>
        return 0;
 8fc:	4501                	li	a0,0
 8fe:	74a2                	ld	s1,40(sp)
 900:	6a42                	ld	s4,16(sp)
 902:	6aa2                	ld	s5,8(sp)
 904:	6b02                	ld	s6,0(sp)
 906:	a03d                	j	934 <malloc+0xdc>
 908:	74a2                	ld	s1,40(sp)
 90a:	6a42                	ld	s4,16(sp)
 90c:	6aa2                	ld	s5,8(sp)
 90e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 910:	fae90fe3          	beq	s2,a4,8ce <malloc+0x76>
        p->s.size -= nunits;
 914:	4137073b          	subw	a4,a4,s3
 918:	c798                	sw	a4,8(a5)
        p += p->s.size;
 91a:	02071693          	slli	a3,a4,0x20
 91e:	01c6d713          	srli	a4,a3,0x1c
 922:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 924:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 928:	00000717          	auipc	a4,0x0
 92c:	6ca73c23          	sd	a0,1752(a4) # 1000 <freep>
      return (void*)(p + 1);
 930:	01078513          	addi	a0,a5,16
  }
}
 934:	70e2                	ld	ra,56(sp)
 936:	7442                	ld	s0,48(sp)
 938:	7902                	ld	s2,32(sp)
 93a:	69e2                	ld	s3,24(sp)
 93c:	6121                	addi	sp,sp,64
 93e:	8082                	ret
 940:	74a2                	ld	s1,40(sp)
 942:	6a42                	ld	s4,16(sp)
 944:	6aa2                	ld	s5,8(sp)
 946:	6b02                	ld	s6,0(sp)
 948:	b7f5                	j	934 <malloc+0xdc>

000000000000094a <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 94a:	7179                	addi	sp,sp,-48
 94c:	f406                	sd	ra,40(sp)
 94e:	f022                	sd	s0,32(sp)
 950:	ec26                	sd	s1,24(sp)
 952:	e84a                	sd	s2,16(sp)
 954:	e44e                	sd	s3,8(sp)
 956:	e052                	sd	s4,0(sp)
 958:	1800                	addi	s0,sp,48
 95a:	8a2a                	mv	s4,a0
 95c:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 95e:	4581                	li	a1,0
 960:	00000517          	auipc	a0,0x0
 964:	08850513          	addi	a0,a0,136 # 9e8 <statistics+0x9e>
 968:	9e9ff0ef          	jal	350 <open>
  if(fd < 0) {
 96c:	02054e63          	bltz	a0,9a8 <statistics+0x5e>
 970:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 972:	4481                	li	s1,0
 974:	01205e63          	blez	s2,990 <statistics+0x46>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 978:	4099063b          	subw	a2,s2,s1
 97c:	009a05b3          	add	a1,s4,s1
 980:	854e                	mv	a0,s3
 982:	9a7ff0ef          	jal	328 <read>
 986:	00054563          	bltz	a0,990 <statistics+0x46>
      break;
    }
    i += n;
 98a:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 98c:	ff24c6e3          	blt	s1,s2,978 <statistics+0x2e>
  }
  close(fd);
 990:	854e                	mv	a0,s3
 992:	9a7ff0ef          	jal	338 <close>
  return i;
}
 996:	8526                	mv	a0,s1
 998:	70a2                	ld	ra,40(sp)
 99a:	7402                	ld	s0,32(sp)
 99c:	64e2                	ld	s1,24(sp)
 99e:	6942                	ld	s2,16(sp)
 9a0:	69a2                	ld	s3,8(sp)
 9a2:	6a02                	ld	s4,0(sp)
 9a4:	6145                	addi	sp,sp,48
 9a6:	8082                	ret
      fprintf(2, "stats: open failed\n");
 9a8:	00000597          	auipc	a1,0x0
 9ac:	05058593          	addi	a1,a1,80 # 9f8 <statistics+0xae>
 9b0:	4509                	li	a0,2
 9b2:	dc5ff0ef          	jal	776 <fprintf>
      exit(1);
 9b6:	4505                	li	a0,1
 9b8:	959ff0ef          	jal	310 <exit>
