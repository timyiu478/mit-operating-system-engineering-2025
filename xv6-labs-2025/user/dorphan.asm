
user/_dorphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	1000                	addi	s0,sp,32
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)

  if(mkdir("dd") != 0){
   c:	00001517          	auipc	a0,0x1
  10:	9e450513          	addi	a0,a0,-1564 # 9f0 <statistics+0x74>
  14:	396000ef          	jal	3aa <mkdir>
  18:	c919                	beqz	a0,2e <main+0x2e>
    printf("%s: mkdir dd failed\n", s);
  1a:	85a6                	mv	a1,s1
  1c:	00001517          	auipc	a0,0x1
  20:	9dc50513          	addi	a0,a0,-1572 # 9f8 <statistics+0x7c>
  24:	7ae000ef          	jal	7d2 <printf>
    exit(1);
  28:	4505                	li	a0,1
  2a:	318000ef          	jal	342 <exit>
  }

  if(chdir("dd") != 0){
  2e:	00001517          	auipc	a0,0x1
  32:	9c250513          	addi	a0,a0,-1598 # 9f0 <statistics+0x74>
  36:	37c000ef          	jal	3b2 <chdir>
  3a:	c919                	beqz	a0,50 <main+0x50>
    printf("%s: chdir dd failed\n", s);
  3c:	85a6                	mv	a1,s1
  3e:	00001517          	auipc	a0,0x1
  42:	9d250513          	addi	a0,a0,-1582 # a10 <statistics+0x94>
  46:	78c000ef          	jal	7d2 <printf>
    exit(1);
  4a:	4505                	li	a0,1
  4c:	2f6000ef          	jal	342 <exit>
  }

  if (unlink("../dd") < 0) {
  50:	00001517          	auipc	a0,0x1
  54:	9d850513          	addi	a0,a0,-1576 # a28 <statistics+0xac>
  58:	33a000ef          	jal	392 <unlink>
  5c:	00054e63          	bltz	a0,78 <main+0x78>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  printf("wait for kill and reclaim\n");
  60:	00001517          	auipc	a0,0x1
  64:	9e850513          	addi	a0,a0,-1560 # a48 <statistics+0xcc>
  68:	76a000ef          	jal	7d2 <printf>
  // sit around until killed
  for(;;) pause(1000);
  6c:	3e800493          	li	s1,1000
  70:	8526                	mv	a0,s1
  72:	360000ef          	jal	3d2 <pause>
  76:	bfed                	j	70 <main+0x70>
    printf("%s: unlink failed\n", s);
  78:	85a6                	mv	a1,s1
  7a:	00001517          	auipc	a0,0x1
  7e:	9b650513          	addi	a0,a0,-1610 # a30 <statistics+0xb4>
  82:	750000ef          	jal	7d2 <printf>
    exit(1);
  86:	4505                	li	a0,1
  88:	2ba000ef          	jal	342 <exit>

000000000000008c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  8c:	1141                	addi	sp,sp,-16
  8e:	e406                	sd	ra,8(sp)
  90:	e022                	sd	s0,0(sp)
  92:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  94:	f6dff0ef          	jal	0 <main>
  exit(r);
  98:	2aa000ef          	jal	342 <exit>

000000000000009c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  9c:	1141                	addi	sp,sp,-16
  9e:	e406                	sd	ra,8(sp)
  a0:	e022                	sd	s0,0(sp)
  a2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  a4:	87aa                	mv	a5,a0
  a6:	0585                	addi	a1,a1,1
  a8:	0785                	addi	a5,a5,1
  aa:	fff5c703          	lbu	a4,-1(a1)
  ae:	fee78fa3          	sb	a4,-1(a5)
  b2:	fb75                	bnez	a4,a6 <strcpy+0xa>
    ;
  return os;
}
  b4:	60a2                	ld	ra,8(sp)
  b6:	6402                	ld	s0,0(sp)
  b8:	0141                	addi	sp,sp,16
  ba:	8082                	ret

00000000000000bc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  bc:	1141                	addi	sp,sp,-16
  be:	e406                	sd	ra,8(sp)
  c0:	e022                	sd	s0,0(sp)
  c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  c4:	00054783          	lbu	a5,0(a0)
  c8:	cb91                	beqz	a5,dc <strcmp+0x20>
  ca:	0005c703          	lbu	a4,0(a1)
  ce:	00f71763          	bne	a4,a5,dc <strcmp+0x20>
    p++, q++;
  d2:	0505                	addi	a0,a0,1
  d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  d6:	00054783          	lbu	a5,0(a0)
  da:	fbe5                	bnez	a5,ca <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  dc:	0005c503          	lbu	a0,0(a1)
}
  e0:	40a7853b          	subw	a0,a5,a0
  e4:	60a2                	ld	ra,8(sp)
  e6:	6402                	ld	s0,0(sp)
  e8:	0141                	addi	sp,sp,16
  ea:	8082                	ret

00000000000000ec <strlen>:

uint
strlen(const char *s)
{
  ec:	1141                	addi	sp,sp,-16
  ee:	e406                	sd	ra,8(sp)
  f0:	e022                	sd	s0,0(sp)
  f2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  f4:	00054783          	lbu	a5,0(a0)
  f8:	cf91                	beqz	a5,114 <strlen+0x28>
  fa:	00150793          	addi	a5,a0,1
  fe:	86be                	mv	a3,a5
 100:	0785                	addi	a5,a5,1
 102:	fff7c703          	lbu	a4,-1(a5)
 106:	ff65                	bnez	a4,fe <strlen+0x12>
 108:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 10c:	60a2                	ld	ra,8(sp)
 10e:	6402                	ld	s0,0(sp)
 110:	0141                	addi	sp,sp,16
 112:	8082                	ret
  for(n = 0; s[n]; n++)
 114:	4501                	li	a0,0
 116:	bfdd                	j	10c <strlen+0x20>

0000000000000118 <memset>:

void*
memset(void *dst, int c, uint n)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 120:	ca19                	beqz	a2,136 <memset+0x1e>
 122:	87aa                	mv	a5,a0
 124:	1602                	slli	a2,a2,0x20
 126:	9201                	srli	a2,a2,0x20
 128:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 12c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 130:	0785                	addi	a5,a5,1
 132:	fee79de3          	bne	a5,a4,12c <memset+0x14>
  }
  return dst;
}
 136:	60a2                	ld	ra,8(sp)
 138:	6402                	ld	s0,0(sp)
 13a:	0141                	addi	sp,sp,16
 13c:	8082                	ret

000000000000013e <strchr>:

char*
strchr(const char *s, char c)
{
 13e:	1141                	addi	sp,sp,-16
 140:	e406                	sd	ra,8(sp)
 142:	e022                	sd	s0,0(sp)
 144:	0800                	addi	s0,sp,16
  for(; *s; s++)
 146:	00054783          	lbu	a5,0(a0)
 14a:	cf81                	beqz	a5,162 <strchr+0x24>
    if(*s == c)
 14c:	00f58763          	beq	a1,a5,15a <strchr+0x1c>
  for(; *s; s++)
 150:	0505                	addi	a0,a0,1
 152:	00054783          	lbu	a5,0(a0)
 156:	fbfd                	bnez	a5,14c <strchr+0xe>
      return (char*)s;
  return 0;
 158:	4501                	li	a0,0
}
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret
  return 0;
 162:	4501                	li	a0,0
 164:	bfdd                	j	15a <strchr+0x1c>

0000000000000166 <gets>:

char*
gets(char *buf, int max)
{
 166:	711d                	addi	sp,sp,-96
 168:	ec86                	sd	ra,88(sp)
 16a:	e8a2                	sd	s0,80(sp)
 16c:	e4a6                	sd	s1,72(sp)
 16e:	e0ca                	sd	s2,64(sp)
 170:	fc4e                	sd	s3,56(sp)
 172:	f852                	sd	s4,48(sp)
 174:	f456                	sd	s5,40(sp)
 176:	f05a                	sd	s6,32(sp)
 178:	ec5e                	sd	s7,24(sp)
 17a:	e862                	sd	s8,16(sp)
 17c:	1080                	addi	s0,sp,96
 17e:	8baa                	mv	s7,a0
 180:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 182:	892a                	mv	s2,a0
 184:	4481                	li	s1,0
    cc = read(0, &c, 1);
 186:	faf40b13          	addi	s6,s0,-81
 18a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 18c:	8c26                	mv	s8,s1
 18e:	0014899b          	addiw	s3,s1,1
 192:	84ce                	mv	s1,s3
 194:	0349d463          	bge	s3,s4,1bc <gets+0x56>
    cc = read(0, &c, 1);
 198:	8656                	mv	a2,s5
 19a:	85da                	mv	a1,s6
 19c:	4501                	li	a0,0
 19e:	1bc000ef          	jal	35a <read>
    if(cc < 1)
 1a2:	00a05d63          	blez	a0,1bc <gets+0x56>
      break;
    buf[i++] = c;
 1a6:	faf44783          	lbu	a5,-81(s0)
 1aa:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ae:	0905                	addi	s2,s2,1
 1b0:	ff678713          	addi	a4,a5,-10
 1b4:	c319                	beqz	a4,1ba <gets+0x54>
 1b6:	17cd                	addi	a5,a5,-13
 1b8:	fbf1                	bnez	a5,18c <gets+0x26>
    buf[i++] = c;
 1ba:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1bc:	9c5e                	add	s8,s8,s7
 1be:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1c2:	855e                	mv	a0,s7
 1c4:	60e6                	ld	ra,88(sp)
 1c6:	6446                	ld	s0,80(sp)
 1c8:	64a6                	ld	s1,72(sp)
 1ca:	6906                	ld	s2,64(sp)
 1cc:	79e2                	ld	s3,56(sp)
 1ce:	7a42                	ld	s4,48(sp)
 1d0:	7aa2                	ld	s5,40(sp)
 1d2:	7b02                	ld	s6,32(sp)
 1d4:	6be2                	ld	s7,24(sp)
 1d6:	6c42                	ld	s8,16(sp)
 1d8:	6125                	addi	sp,sp,96
 1da:	8082                	ret

00000000000001dc <stat>:

int
stat(const char *n, struct stat *st)
{
 1dc:	1101                	addi	sp,sp,-32
 1de:	ec06                	sd	ra,24(sp)
 1e0:	e822                	sd	s0,16(sp)
 1e2:	e04a                	sd	s2,0(sp)
 1e4:	1000                	addi	s0,sp,32
 1e6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1e8:	4581                	li	a1,0
 1ea:	198000ef          	jal	382 <open>
  if(fd < 0)
 1ee:	02054263          	bltz	a0,212 <stat+0x36>
 1f2:	e426                	sd	s1,8(sp)
 1f4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1f6:	85ca                	mv	a1,s2
 1f8:	1a2000ef          	jal	39a <fstat>
 1fc:	892a                	mv	s2,a0
  close(fd);
 1fe:	8526                	mv	a0,s1
 200:	16a000ef          	jal	36a <close>
  return r;
 204:	64a2                	ld	s1,8(sp)
}
 206:	854a                	mv	a0,s2
 208:	60e2                	ld	ra,24(sp)
 20a:	6442                	ld	s0,16(sp)
 20c:	6902                	ld	s2,0(sp)
 20e:	6105                	addi	sp,sp,32
 210:	8082                	ret
    return -1;
 212:	57fd                	li	a5,-1
 214:	893e                	mv	s2,a5
 216:	bfc5                	j	206 <stat+0x2a>

0000000000000218 <atoi>:

int
atoi(const char *s)
{
 218:	1141                	addi	sp,sp,-16
 21a:	e406                	sd	ra,8(sp)
 21c:	e022                	sd	s0,0(sp)
 21e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 220:	00054683          	lbu	a3,0(a0)
 224:	fd06879b          	addiw	a5,a3,-48
 228:	0ff7f793          	zext.b	a5,a5
 22c:	4625                	li	a2,9
 22e:	02f66963          	bltu	a2,a5,260 <atoi+0x48>
 232:	872a                	mv	a4,a0
  n = 0;
 234:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 236:	0705                	addi	a4,a4,1
 238:	0025179b          	slliw	a5,a0,0x2
 23c:	9fa9                	addw	a5,a5,a0
 23e:	0017979b          	slliw	a5,a5,0x1
 242:	9fb5                	addw	a5,a5,a3
 244:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 248:	00074683          	lbu	a3,0(a4)
 24c:	fd06879b          	addiw	a5,a3,-48
 250:	0ff7f793          	zext.b	a5,a5
 254:	fef671e3          	bgeu	a2,a5,236 <atoi+0x1e>
  return n;
}
 258:	60a2                	ld	ra,8(sp)
 25a:	6402                	ld	s0,0(sp)
 25c:	0141                	addi	sp,sp,16
 25e:	8082                	ret
  n = 0;
 260:	4501                	li	a0,0
 262:	bfdd                	j	258 <atoi+0x40>

0000000000000264 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 264:	1141                	addi	sp,sp,-16
 266:	e406                	sd	ra,8(sp)
 268:	e022                	sd	s0,0(sp)
 26a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 26c:	02b57563          	bgeu	a0,a1,296 <memmove+0x32>
    while(n-- > 0)
 270:	00c05f63          	blez	a2,28e <memmove+0x2a>
 274:	1602                	slli	a2,a2,0x20
 276:	9201                	srli	a2,a2,0x20
 278:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 27c:	872a                	mv	a4,a0
      *dst++ = *src++;
 27e:	0585                	addi	a1,a1,1
 280:	0705                	addi	a4,a4,1
 282:	fff5c683          	lbu	a3,-1(a1)
 286:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 28a:	fee79ae3          	bne	a5,a4,27e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 28e:	60a2                	ld	ra,8(sp)
 290:	6402                	ld	s0,0(sp)
 292:	0141                	addi	sp,sp,16
 294:	8082                	ret
    while(n-- > 0)
 296:	fec05ce3          	blez	a2,28e <memmove+0x2a>
    dst += n;
 29a:	00c50733          	add	a4,a0,a2
    src += n;
 29e:	95b2                	add	a1,a1,a2
 2a0:	fff6079b          	addiw	a5,a2,-1
 2a4:	1782                	slli	a5,a5,0x20
 2a6:	9381                	srli	a5,a5,0x20
 2a8:	fff7c793          	not	a5,a5
 2ac:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ae:	15fd                	addi	a1,a1,-1
 2b0:	177d                	addi	a4,a4,-1
 2b2:	0005c683          	lbu	a3,0(a1)
 2b6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2ba:	fef71ae3          	bne	a4,a5,2ae <memmove+0x4a>
 2be:	bfc1                	j	28e <memmove+0x2a>

00000000000002c0 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2c8:	c61d                	beqz	a2,2f6 <memcmp+0x36>
 2ca:	1602                	slli	a2,a2,0x20
 2cc:	9201                	srli	a2,a2,0x20
 2ce:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2d2:	00054783          	lbu	a5,0(a0)
 2d6:	0005c703          	lbu	a4,0(a1)
 2da:	00e79863          	bne	a5,a4,2ea <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2de:	0505                	addi	a0,a0,1
    p2++;
 2e0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2e2:	fed518e3          	bne	a0,a3,2d2 <memcmp+0x12>
  }
  return 0;
 2e6:	4501                	li	a0,0
 2e8:	a019                	j	2ee <memcmp+0x2e>
      return *p1 - *p2;
 2ea:	40e7853b          	subw	a0,a5,a4
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret
  return 0;
 2f6:	4501                	li	a0,0
 2f8:	bfdd                	j	2ee <memcmp+0x2e>

00000000000002fa <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 302:	f63ff0ef          	jal	264 <memmove>
}
 306:	60a2                	ld	ra,8(sp)
 308:	6402                	ld	s0,0(sp)
 30a:	0141                	addi	sp,sp,16
 30c:	8082                	ret

000000000000030e <sbrk>:

char *
sbrk(int n) {
 30e:	1141                	addi	sp,sp,-16
 310:	e406                	sd	ra,8(sp)
 312:	e022                	sd	s0,0(sp)
 314:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 316:	4585                	li	a1,1
 318:	0b2000ef          	jal	3ca <sys_sbrk>
}
 31c:	60a2                	ld	ra,8(sp)
 31e:	6402                	ld	s0,0(sp)
 320:	0141                	addi	sp,sp,16
 322:	8082                	ret

0000000000000324 <sbrklazy>:

char *
sbrklazy(int n) {
 324:	1141                	addi	sp,sp,-16
 326:	e406                	sd	ra,8(sp)
 328:	e022                	sd	s0,0(sp)
 32a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 32c:	4589                	li	a1,2
 32e:	09c000ef          	jal	3ca <sys_sbrk>
}
 332:	60a2                	ld	ra,8(sp)
 334:	6402                	ld	s0,0(sp)
 336:	0141                	addi	sp,sp,16
 338:	8082                	ret

000000000000033a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 33a:	4885                	li	a7,1
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <exit>:
.global exit
exit:
 li a7, SYS_exit
 342:	4889                	li	a7,2
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <wait>:
.global wait
wait:
 li a7, SYS_wait
 34a:	488d                	li	a7,3
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 352:	4891                	li	a7,4
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <read>:
.global read
read:
 li a7, SYS_read
 35a:	4895                	li	a7,5
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <write>:
.global write
write:
 li a7, SYS_write
 362:	48c1                	li	a7,16
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <close>:
.global close
close:
 li a7, SYS_close
 36a:	48d5                	li	a7,21
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <kill>:
.global kill
kill:
 li a7, SYS_kill
 372:	4899                	li	a7,6
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <exec>:
.global exec
exec:
 li a7, SYS_exec
 37a:	489d                	li	a7,7
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <open>:
.global open
open:
 li a7, SYS_open
 382:	48bd                	li	a7,15
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 38a:	48c5                	li	a7,17
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 392:	48c9                	li	a7,18
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 39a:	48a1                	li	a7,8
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <link>:
.global link
link:
 li a7, SYS_link
 3a2:	48cd                	li	a7,19
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3aa:	48d1                	li	a7,20
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3b2:	48a5                	li	a7,9
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <dup>:
.global dup
dup:
 li a7, SYS_dup
 3ba:	48a9                	li	a7,10
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3c2:	48ad                	li	a7,11
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3ca:	48b1                	li	a7,12
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3d2:	48b5                	li	a7,13
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3da:	48b9                	li	a7,14
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <bind>:
.global bind
bind:
 li a7, SYS_bind
 3e2:	48f5                	li	a7,29
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 3ea:	48f9                	li	a7,30
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <send>:
.global send
send:
 li a7, SYS_send
 3f2:	48fd                	li	a7,31
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <recv>:
.global recv
recv:
 li a7, SYS_recv
 3fa:	02000893          	li	a7,32
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 404:	02100893          	li	a7,33
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 40e:	02200893          	li	a7,34
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 418:	02300893          	li	a7,35
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 422:	02400893          	li	a7,36
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 42c:	1101                	addi	sp,sp,-32
 42e:	ec06                	sd	ra,24(sp)
 430:	e822                	sd	s0,16(sp)
 432:	1000                	addi	s0,sp,32
 434:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 438:	4605                	li	a2,1
 43a:	fef40593          	addi	a1,s0,-17
 43e:	f25ff0ef          	jal	362 <write>
}
 442:	60e2                	ld	ra,24(sp)
 444:	6442                	ld	s0,16(sp)
 446:	6105                	addi	sp,sp,32
 448:	8082                	ret

000000000000044a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 44a:	715d                	addi	sp,sp,-80
 44c:	e486                	sd	ra,72(sp)
 44e:	e0a2                	sd	s0,64(sp)
 450:	f84a                	sd	s2,48(sp)
 452:	f44e                	sd	s3,40(sp)
 454:	0880                	addi	s0,sp,80
 456:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 458:	c6d1                	beqz	a3,4e4 <printint+0x9a>
 45a:	0805d563          	bgez	a1,4e4 <printint+0x9a>
    neg = 1;
    x = -xx;
 45e:	40b005b3          	neg	a1,a1
    neg = 1;
 462:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 464:	fb840993          	addi	s3,s0,-72
  neg = 0;
 468:	86ce                	mv	a3,s3
  i = 0;
 46a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 46c:	00000817          	auipc	a6,0x0
 470:	62c80813          	addi	a6,a6,1580 # a98 <digits>
 474:	88ba                	mv	a7,a4
 476:	0017051b          	addiw	a0,a4,1
 47a:	872a                	mv	a4,a0
 47c:	02c5f7b3          	remu	a5,a1,a2
 480:	97c2                	add	a5,a5,a6
 482:	0007c783          	lbu	a5,0(a5)
 486:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 48a:	87ae                	mv	a5,a1
 48c:	02c5d5b3          	divu	a1,a1,a2
 490:	0685                	addi	a3,a3,1
 492:	fec7f1e3          	bgeu	a5,a2,474 <printint+0x2a>
  if(neg)
 496:	00030c63          	beqz	t1,4ae <printint+0x64>
    buf[i++] = '-';
 49a:	fd050793          	addi	a5,a0,-48
 49e:	00878533          	add	a0,a5,s0
 4a2:	02d00793          	li	a5,45
 4a6:	fef50423          	sb	a5,-24(a0)
 4aa:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4ae:	02e05563          	blez	a4,4d8 <printint+0x8e>
 4b2:	fc26                	sd	s1,56(sp)
 4b4:	377d                	addiw	a4,a4,-1
 4b6:	00e984b3          	add	s1,s3,a4
 4ba:	19fd                	addi	s3,s3,-1
 4bc:	99ba                	add	s3,s3,a4
 4be:	1702                	slli	a4,a4,0x20
 4c0:	9301                	srli	a4,a4,0x20
 4c2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4c6:	0004c583          	lbu	a1,0(s1)
 4ca:	854a                	mv	a0,s2
 4cc:	f61ff0ef          	jal	42c <putc>
  while(--i >= 0)
 4d0:	14fd                	addi	s1,s1,-1
 4d2:	ff349ae3          	bne	s1,s3,4c6 <printint+0x7c>
 4d6:	74e2                	ld	s1,56(sp)
}
 4d8:	60a6                	ld	ra,72(sp)
 4da:	6406                	ld	s0,64(sp)
 4dc:	7942                	ld	s2,48(sp)
 4de:	79a2                	ld	s3,40(sp)
 4e0:	6161                	addi	sp,sp,80
 4e2:	8082                	ret
  neg = 0;
 4e4:	4301                	li	t1,0
 4e6:	bfbd                	j	464 <printint+0x1a>

00000000000004e8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4e8:	711d                	addi	sp,sp,-96
 4ea:	ec86                	sd	ra,88(sp)
 4ec:	e8a2                	sd	s0,80(sp)
 4ee:	e4a6                	sd	s1,72(sp)
 4f0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4f2:	0005c483          	lbu	s1,0(a1)
 4f6:	22048363          	beqz	s1,71c <vprintf+0x234>
 4fa:	e0ca                	sd	s2,64(sp)
 4fc:	fc4e                	sd	s3,56(sp)
 4fe:	f852                	sd	s4,48(sp)
 500:	f456                	sd	s5,40(sp)
 502:	f05a                	sd	s6,32(sp)
 504:	ec5e                	sd	s7,24(sp)
 506:	e862                	sd	s8,16(sp)
 508:	8b2a                	mv	s6,a0
 50a:	8a2e                	mv	s4,a1
 50c:	8bb2                	mv	s7,a2
  state = 0;
 50e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 510:	4901                	li	s2,0
 512:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 514:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 518:	06400c13          	li	s8,100
 51c:	a00d                	j	53e <vprintf+0x56>
        putc(fd, c0);
 51e:	85a6                	mv	a1,s1
 520:	855a                	mv	a0,s6
 522:	f0bff0ef          	jal	42c <putc>
 526:	a019                	j	52c <vprintf+0x44>
    } else if(state == '%'){
 528:	03598363          	beq	s3,s5,54e <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 52c:	0019079b          	addiw	a5,s2,1
 530:	893e                	mv	s2,a5
 532:	873e                	mv	a4,a5
 534:	97d2                	add	a5,a5,s4
 536:	0007c483          	lbu	s1,0(a5)
 53a:	1c048a63          	beqz	s1,70e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 53e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 542:	fe0993e3          	bnez	s3,528 <vprintf+0x40>
      if(c0 == '%'){
 546:	fd579ce3          	bne	a5,s5,51e <vprintf+0x36>
        state = '%';
 54a:	89be                	mv	s3,a5
 54c:	b7c5                	j	52c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 54e:	00ea06b3          	add	a3,s4,a4
 552:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 556:	1c060863          	beqz	a2,726 <vprintf+0x23e>
      if(c0 == 'd'){
 55a:	03878763          	beq	a5,s8,588 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 55e:	f9478693          	addi	a3,a5,-108
 562:	0016b693          	seqz	a3,a3
 566:	f9c60593          	addi	a1,a2,-100
 56a:	e99d                	bnez	a1,5a0 <vprintf+0xb8>
 56c:	ca95                	beqz	a3,5a0 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 56e:	008b8493          	addi	s1,s7,8
 572:	4685                	li	a3,1
 574:	4629                	li	a2,10
 576:	000bb583          	ld	a1,0(s7)
 57a:	855a                	mv	a0,s6
 57c:	ecfff0ef          	jal	44a <printint>
        i += 1;
 580:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 582:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 584:	4981                	li	s3,0
 586:	b75d                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 588:	008b8493          	addi	s1,s7,8
 58c:	4685                	li	a3,1
 58e:	4629                	li	a2,10
 590:	000ba583          	lw	a1,0(s7)
 594:	855a                	mv	a0,s6
 596:	eb5ff0ef          	jal	44a <printint>
 59a:	8ba6                	mv	s7,s1
      state = 0;
 59c:	4981                	li	s3,0
 59e:	b779                	j	52c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5a0:	9752                	add	a4,a4,s4
 5a2:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5a6:	f9460713          	addi	a4,a2,-108
 5aa:	00173713          	seqz	a4,a4
 5ae:	8f75                	and	a4,a4,a3
 5b0:	f9c58513          	addi	a0,a1,-100
 5b4:	18051363          	bnez	a0,73a <vprintf+0x252>
 5b8:	18070163          	beqz	a4,73a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000bb583          	ld	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	e81ff0ef          	jal	44a <printint>
        i += 2;
 5ce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5d0:	8ba6                	mv	s7,s1
      state = 0;
 5d2:	4981                	li	s3,0
        i += 2;
 5d4:	bfa1                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5d6:	008b8493          	addi	s1,s7,8
 5da:	4681                	li	a3,0
 5dc:	4629                	li	a2,10
 5de:	000be583          	lwu	a1,0(s7)
 5e2:	855a                	mv	a0,s6
 5e4:	e67ff0ef          	jal	44a <printint>
 5e8:	8ba6                	mv	s7,s1
      state = 0;
 5ea:	4981                	li	s3,0
 5ec:	b781                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ee:	008b8493          	addi	s1,s7,8
 5f2:	4681                	li	a3,0
 5f4:	4629                	li	a2,10
 5f6:	000bb583          	ld	a1,0(s7)
 5fa:	855a                	mv	a0,s6
 5fc:	e4fff0ef          	jal	44a <printint>
        i += 1;
 600:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 602:	8ba6                	mv	s7,s1
      state = 0;
 604:	4981                	li	s3,0
 606:	b71d                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 608:	008b8493          	addi	s1,s7,8
 60c:	4681                	li	a3,0
 60e:	4629                	li	a2,10
 610:	000bb583          	ld	a1,0(s7)
 614:	855a                	mv	a0,s6
 616:	e35ff0ef          	jal	44a <printint>
        i += 2;
 61a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
        i += 2;
 620:	b731                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4641                	li	a2,16
 62a:	000be583          	lwu	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e1bff0ef          	jal	44a <printint>
 634:	8ba6                	mv	s7,s1
      state = 0;
 636:	4981                	li	s3,0
 638:	bdd5                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 63a:	008b8493          	addi	s1,s7,8
 63e:	4681                	li	a3,0
 640:	4641                	li	a2,16
 642:	000bb583          	ld	a1,0(s7)
 646:	855a                	mv	a0,s6
 648:	e03ff0ef          	jal	44a <printint>
        i += 1;
 64c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 64e:	8ba6                	mv	s7,s1
      state = 0;
 650:	4981                	li	s3,0
 652:	bde9                	j	52c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 654:	008b8493          	addi	s1,s7,8
 658:	4681                	li	a3,0
 65a:	4641                	li	a2,16
 65c:	000bb583          	ld	a1,0(s7)
 660:	855a                	mv	a0,s6
 662:	de9ff0ef          	jal	44a <printint>
        i += 2;
 666:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
        i += 2;
 66c:	b5c1                	j	52c <vprintf+0x44>
 66e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 670:	008b8793          	addi	a5,s7,8
 674:	8cbe                	mv	s9,a5
 676:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 67a:	03000593          	li	a1,48
 67e:	855a                	mv	a0,s6
 680:	dadff0ef          	jal	42c <putc>
  putc(fd, 'x');
 684:	07800593          	li	a1,120
 688:	855a                	mv	a0,s6
 68a:	da3ff0ef          	jal	42c <putc>
 68e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 690:	00000b97          	auipc	s7,0x0
 694:	408b8b93          	addi	s7,s7,1032 # a98 <digits>
 698:	03c9d793          	srli	a5,s3,0x3c
 69c:	97de                	add	a5,a5,s7
 69e:	0007c583          	lbu	a1,0(a5)
 6a2:	855a                	mv	a0,s6
 6a4:	d89ff0ef          	jal	42c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6a8:	0992                	slli	s3,s3,0x4
 6aa:	34fd                	addiw	s1,s1,-1
 6ac:	f4f5                	bnez	s1,698 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6ae:	8be6                	mv	s7,s9
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	6ca2                	ld	s9,8(sp)
 6b4:	bda5                	j	52c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6b6:	008b8493          	addi	s1,s7,8
 6ba:	000bc583          	lbu	a1,0(s7)
 6be:	855a                	mv	a0,s6
 6c0:	d6dff0ef          	jal	42c <putc>
 6c4:	8ba6                	mv	s7,s1
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	b595                	j	52c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6ca:	008b8993          	addi	s3,s7,8
 6ce:	000bb483          	ld	s1,0(s7)
 6d2:	cc91                	beqz	s1,6ee <vprintf+0x206>
        for(; *s; s++)
 6d4:	0004c583          	lbu	a1,0(s1)
 6d8:	c985                	beqz	a1,708 <vprintf+0x220>
          putc(fd, *s);
 6da:	855a                	mv	a0,s6
 6dc:	d51ff0ef          	jal	42c <putc>
        for(; *s; s++)
 6e0:	0485                	addi	s1,s1,1
 6e2:	0004c583          	lbu	a1,0(s1)
 6e6:	f9f5                	bnez	a1,6da <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6e8:	8bce                	mv	s7,s3
      state = 0;
 6ea:	4981                	li	s3,0
 6ec:	b581                	j	52c <vprintf+0x44>
          s = "(null)";
 6ee:	00000497          	auipc	s1,0x0
 6f2:	37a48493          	addi	s1,s1,890 # a68 <statistics+0xec>
        for(; *s; s++)
 6f6:	02800593          	li	a1,40
 6fa:	b7c5                	j	6da <vprintf+0x1f2>
        putc(fd, '%');
 6fc:	85be                	mv	a1,a5
 6fe:	855a                	mv	a0,s6
 700:	d2dff0ef          	jal	42c <putc>
      state = 0;
 704:	4981                	li	s3,0
 706:	b51d                	j	52c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 708:	8bce                	mv	s7,s3
      state = 0;
 70a:	4981                	li	s3,0
 70c:	b505                	j	52c <vprintf+0x44>
 70e:	6906                	ld	s2,64(sp)
 710:	79e2                	ld	s3,56(sp)
 712:	7a42                	ld	s4,48(sp)
 714:	7aa2                	ld	s5,40(sp)
 716:	7b02                	ld	s6,32(sp)
 718:	6be2                	ld	s7,24(sp)
 71a:	6c42                	ld	s8,16(sp)
    }
  }
}
 71c:	60e6                	ld	ra,88(sp)
 71e:	6446                	ld	s0,80(sp)
 720:	64a6                	ld	s1,72(sp)
 722:	6125                	addi	sp,sp,96
 724:	8082                	ret
      if(c0 == 'd'){
 726:	06400713          	li	a4,100
 72a:	e4e78fe3          	beq	a5,a4,588 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 72e:	f9478693          	addi	a3,a5,-108
 732:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 736:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 738:	4701                	li	a4,0
      } else if(c0 == 'u'){
 73a:	07500513          	li	a0,117
 73e:	e8a78ce3          	beq	a5,a0,5d6 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 742:	f8b60513          	addi	a0,a2,-117
 746:	e119                	bnez	a0,74c <vprintf+0x264>
 748:	ea0693e3          	bnez	a3,5ee <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 74c:	f8b58513          	addi	a0,a1,-117
 750:	e119                	bnez	a0,756 <vprintf+0x26e>
 752:	ea071be3          	bnez	a4,608 <vprintf+0x120>
      } else if(c0 == 'x'){
 756:	07800513          	li	a0,120
 75a:	eca784e3          	beq	a5,a0,622 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 75e:	f8860613          	addi	a2,a2,-120
 762:	e219                	bnez	a2,768 <vprintf+0x280>
 764:	ec069be3          	bnez	a3,63a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 768:	f8858593          	addi	a1,a1,-120
 76c:	e199                	bnez	a1,772 <vprintf+0x28a>
 76e:	ee0713e3          	bnez	a4,654 <vprintf+0x16c>
      } else if(c0 == 'p'){
 772:	07000713          	li	a4,112
 776:	eee78ce3          	beq	a5,a4,66e <vprintf+0x186>
      } else if(c0 == 'c'){
 77a:	06300713          	li	a4,99
 77e:	f2e78ce3          	beq	a5,a4,6b6 <vprintf+0x1ce>
      } else if(c0 == 's'){
 782:	07300713          	li	a4,115
 786:	f4e782e3          	beq	a5,a4,6ca <vprintf+0x1e2>
      } else if(c0 == '%'){
 78a:	02500713          	li	a4,37
 78e:	f6e787e3          	beq	a5,a4,6fc <vprintf+0x214>
        putc(fd, '%');
 792:	02500593          	li	a1,37
 796:	855a                	mv	a0,s6
 798:	c95ff0ef          	jal	42c <putc>
        putc(fd, c0);
 79c:	85a6                	mv	a1,s1
 79e:	855a                	mv	a0,s6
 7a0:	c8dff0ef          	jal	42c <putc>
      state = 0;
 7a4:	4981                	li	s3,0
 7a6:	b359                	j	52c <vprintf+0x44>

00000000000007a8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7a8:	715d                	addi	sp,sp,-80
 7aa:	ec06                	sd	ra,24(sp)
 7ac:	e822                	sd	s0,16(sp)
 7ae:	1000                	addi	s0,sp,32
 7b0:	e010                	sd	a2,0(s0)
 7b2:	e414                	sd	a3,8(s0)
 7b4:	e818                	sd	a4,16(s0)
 7b6:	ec1c                	sd	a5,24(s0)
 7b8:	03043023          	sd	a6,32(s0)
 7bc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7c0:	8622                	mv	a2,s0
 7c2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7c6:	d23ff0ef          	jal	4e8 <vprintf>
}
 7ca:	60e2                	ld	ra,24(sp)
 7cc:	6442                	ld	s0,16(sp)
 7ce:	6161                	addi	sp,sp,80
 7d0:	8082                	ret

00000000000007d2 <printf>:

void
printf(const char *fmt, ...)
{
 7d2:	711d                	addi	sp,sp,-96
 7d4:	ec06                	sd	ra,24(sp)
 7d6:	e822                	sd	s0,16(sp)
 7d8:	1000                	addi	s0,sp,32
 7da:	e40c                	sd	a1,8(s0)
 7dc:	e810                	sd	a2,16(s0)
 7de:	ec14                	sd	a3,24(s0)
 7e0:	f018                	sd	a4,32(s0)
 7e2:	f41c                	sd	a5,40(s0)
 7e4:	03043823          	sd	a6,48(s0)
 7e8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7ec:	00840613          	addi	a2,s0,8
 7f0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7f4:	85aa                	mv	a1,a0
 7f6:	4505                	li	a0,1
 7f8:	cf1ff0ef          	jal	4e8 <vprintf>
}
 7fc:	60e2                	ld	ra,24(sp)
 7fe:	6442                	ld	s0,16(sp)
 800:	6125                	addi	sp,sp,96
 802:	8082                	ret

0000000000000804 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 804:	1141                	addi	sp,sp,-16
 806:	e406                	sd	ra,8(sp)
 808:	e022                	sd	s0,0(sp)
 80a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 80c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 810:	00000797          	auipc	a5,0x0
 814:	7f07b783          	ld	a5,2032(a5) # 1000 <freep>
 818:	a039                	j	826 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 81a:	6398                	ld	a4,0(a5)
 81c:	00e7e463          	bltu	a5,a4,824 <free+0x20>
 820:	00e6ea63          	bltu	a3,a4,834 <free+0x30>
{
 824:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 826:	fed7fae3          	bgeu	a5,a3,81a <free+0x16>
 82a:	6398                	ld	a4,0(a5)
 82c:	00e6e463          	bltu	a3,a4,834 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 830:	fee7eae3          	bltu	a5,a4,824 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 834:	ff852583          	lw	a1,-8(a0)
 838:	6390                	ld	a2,0(a5)
 83a:	02059813          	slli	a6,a1,0x20
 83e:	01c85713          	srli	a4,a6,0x1c
 842:	9736                	add	a4,a4,a3
 844:	02e60563          	beq	a2,a4,86e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 848:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 84c:	4790                	lw	a2,8(a5)
 84e:	02061593          	slli	a1,a2,0x20
 852:	01c5d713          	srli	a4,a1,0x1c
 856:	973e                	add	a4,a4,a5
 858:	02e68263          	beq	a3,a4,87c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 85c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 85e:	00000717          	auipc	a4,0x0
 862:	7af73123          	sd	a5,1954(a4) # 1000 <freep>
}
 866:	60a2                	ld	ra,8(sp)
 868:	6402                	ld	s0,0(sp)
 86a:	0141                	addi	sp,sp,16
 86c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 86e:	4618                	lw	a4,8(a2)
 870:	9f2d                	addw	a4,a4,a1
 872:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 876:	6398                	ld	a4,0(a5)
 878:	6310                	ld	a2,0(a4)
 87a:	b7f9                	j	848 <free+0x44>
    p->s.size += bp->s.size;
 87c:	ff852703          	lw	a4,-8(a0)
 880:	9f31                	addw	a4,a4,a2
 882:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 884:	ff053683          	ld	a3,-16(a0)
 888:	bfd1                	j	85c <free+0x58>

000000000000088a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 88a:	7139                	addi	sp,sp,-64
 88c:	fc06                	sd	ra,56(sp)
 88e:	f822                	sd	s0,48(sp)
 890:	f04a                	sd	s2,32(sp)
 892:	ec4e                	sd	s3,24(sp)
 894:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 896:	02051993          	slli	s3,a0,0x20
 89a:	0209d993          	srli	s3,s3,0x20
 89e:	09bd                	addi	s3,s3,15
 8a0:	0049d993          	srli	s3,s3,0x4
 8a4:	2985                	addiw	s3,s3,1
 8a6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8a8:	00000517          	auipc	a0,0x0
 8ac:	75853503          	ld	a0,1880(a0) # 1000 <freep>
 8b0:	c905                	beqz	a0,8e0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8b2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8b4:	4798                	lw	a4,8(a5)
 8b6:	09377663          	bgeu	a4,s3,942 <malloc+0xb8>
 8ba:	f426                	sd	s1,40(sp)
 8bc:	e852                	sd	s4,16(sp)
 8be:	e456                	sd	s5,8(sp)
 8c0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8c2:	8a4e                	mv	s4,s3
 8c4:	6705                	lui	a4,0x1
 8c6:	00e9f363          	bgeu	s3,a4,8cc <malloc+0x42>
 8ca:	6a05                	lui	s4,0x1
 8cc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8d0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8d4:	00000497          	auipc	s1,0x0
 8d8:	72c48493          	addi	s1,s1,1836 # 1000 <freep>
  if(p == SBRK_ERROR)
 8dc:	5afd                	li	s5,-1
 8de:	a83d                	j	91c <malloc+0x92>
 8e0:	f426                	sd	s1,40(sp)
 8e2:	e852                	sd	s4,16(sp)
 8e4:	e456                	sd	s5,8(sp)
 8e6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8e8:	00001797          	auipc	a5,0x1
 8ec:	92078793          	addi	a5,a5,-1760 # 1208 <base>
 8f0:	00000717          	auipc	a4,0x0
 8f4:	70f73823          	sd	a5,1808(a4) # 1000 <freep>
 8f8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8fa:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8fe:	b7d1                	j	8c2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 900:	6398                	ld	a4,0(a5)
 902:	e118                	sd	a4,0(a0)
 904:	a899                	j	95a <malloc+0xd0>
  hp->s.size = nu;
 906:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 90a:	0541                	addi	a0,a0,16
 90c:	ef9ff0ef          	jal	804 <free>
  return freep;
 910:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 912:	c125                	beqz	a0,972 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 914:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 916:	4798                	lw	a4,8(a5)
 918:	03277163          	bgeu	a4,s2,93a <malloc+0xb0>
    if(p == freep)
 91c:	6098                	ld	a4,0(s1)
 91e:	853e                	mv	a0,a5
 920:	fef71ae3          	bne	a4,a5,914 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 924:	8552                	mv	a0,s4
 926:	9e9ff0ef          	jal	30e <sbrk>
  if(p == SBRK_ERROR)
 92a:	fd551ee3          	bne	a0,s5,906 <malloc+0x7c>
        return 0;
 92e:	4501                	li	a0,0
 930:	74a2                	ld	s1,40(sp)
 932:	6a42                	ld	s4,16(sp)
 934:	6aa2                	ld	s5,8(sp)
 936:	6b02                	ld	s6,0(sp)
 938:	a03d                	j	966 <malloc+0xdc>
 93a:	74a2                	ld	s1,40(sp)
 93c:	6a42                	ld	s4,16(sp)
 93e:	6aa2                	ld	s5,8(sp)
 940:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 942:	fae90fe3          	beq	s2,a4,900 <malloc+0x76>
        p->s.size -= nunits;
 946:	4137073b          	subw	a4,a4,s3
 94a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 94c:	02071693          	slli	a3,a4,0x20
 950:	01c6d713          	srli	a4,a3,0x1c
 954:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 956:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 95a:	00000717          	auipc	a4,0x0
 95e:	6aa73323          	sd	a0,1702(a4) # 1000 <freep>
      return (void*)(p + 1);
 962:	01078513          	addi	a0,a5,16
  }
}
 966:	70e2                	ld	ra,56(sp)
 968:	7442                	ld	s0,48(sp)
 96a:	7902                	ld	s2,32(sp)
 96c:	69e2                	ld	s3,24(sp)
 96e:	6121                	addi	sp,sp,64
 970:	8082                	ret
 972:	74a2                	ld	s1,40(sp)
 974:	6a42                	ld	s4,16(sp)
 976:	6aa2                	ld	s5,8(sp)
 978:	6b02                	ld	s6,0(sp)
 97a:	b7f5                	j	966 <malloc+0xdc>

000000000000097c <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 97c:	7179                	addi	sp,sp,-48
 97e:	f406                	sd	ra,40(sp)
 980:	f022                	sd	s0,32(sp)
 982:	ec26                	sd	s1,24(sp)
 984:	e84a                	sd	s2,16(sp)
 986:	e44e                	sd	s3,8(sp)
 988:	e052                	sd	s4,0(sp)
 98a:	1800                	addi	s0,sp,48
 98c:	8a2a                	mv	s4,a0
 98e:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 990:	4581                	li	a1,0
 992:	00000517          	auipc	a0,0x0
 996:	0de50513          	addi	a0,a0,222 # a70 <statistics+0xf4>
 99a:	9e9ff0ef          	jal	382 <open>
  if(fd < 0) {
 99e:	02054e63          	bltz	a0,9da <statistics+0x5e>
 9a2:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 9a4:	4481                	li	s1,0
 9a6:	01205e63          	blez	s2,9c2 <statistics+0x46>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 9aa:	4099063b          	subw	a2,s2,s1
 9ae:	009a05b3          	add	a1,s4,s1
 9b2:	854e                	mv	a0,s3
 9b4:	9a7ff0ef          	jal	35a <read>
 9b8:	00054563          	bltz	a0,9c2 <statistics+0x46>
      break;
    }
    i += n;
 9bc:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 9be:	ff24c6e3          	blt	s1,s2,9aa <statistics+0x2e>
  }
  close(fd);
 9c2:	854e                	mv	a0,s3
 9c4:	9a7ff0ef          	jal	36a <close>
  return i;
}
 9c8:	8526                	mv	a0,s1
 9ca:	70a2                	ld	ra,40(sp)
 9cc:	7402                	ld	s0,32(sp)
 9ce:	64e2                	ld	s1,24(sp)
 9d0:	6942                	ld	s2,16(sp)
 9d2:	69a2                	ld	s3,8(sp)
 9d4:	6a02                	ld	s4,0(sp)
 9d6:	6145                	addi	sp,sp,48
 9d8:	8082                	ret
      fprintf(2, "stats: open failed\n");
 9da:	00000597          	auipc	a1,0x0
 9de:	0a658593          	addi	a1,a1,166 # a80 <statistics+0x104>
 9e2:	4509                	li	a0,2
 9e4:	dc5ff0ef          	jal	7a8 <fprintf>
      exit(1);
 9e8:	4505                	li	a0,1
 9ea:	959ff0ef          	jal	342 <exit>
