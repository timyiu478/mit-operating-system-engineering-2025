
user/_attack:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <attack>:
#define DATASIZE (4096)
#define MAXATTEMPT (20)

void 
attack()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  // sbrk() to allocate memory may receive pages that have data in them from previous uses
  char *b = sbrk(DATASIZE);
   e:	6505                	lui	a0,0x1
  10:	2e6000ef          	jal	2f6 <sbrk>
  14:	84aa                	mv	s1,a0

  for (int i=0; i < DATASIZE; i++) {
  16:	6905                	lui	s2,0x1
  18:	992a                	add	s2,s2,a0
    char *c = b + i;
    if (strcmp(c, "This may help.") == 0) {
  1a:	00001997          	auipc	s3,0x1
  1e:	91698993          	addi	s3,s3,-1770 # 930 <malloc+0xfa>
  22:	85ce                	mv	a1,s3
  24:	8526                	mv	a0,s1
  26:	07e000ef          	jal	a4 <strcmp>
  2a:	c509                	beqz	a0,34 <attack+0x34>
  for (int i=0; i < DATASIZE; i++) {
  2c:	0485                	addi	s1,s1,1
  2e:	ff249ae3          	bne	s1,s2,22 <attack+0x22>
  32:	a809                	j	44 <attack+0x44>
      c += 16;
      printf("%s\n", c);
  34:	01048593          	addi	a1,s1,16
  38:	00001517          	auipc	a0,0x1
  3c:	90850513          	addi	a0,a0,-1784 # 940 <malloc+0x10a>
  40:	73e000ef          	jal	77e <printf>
      return;
    }
  }
}
  44:	70a2                	ld	ra,40(sp)
  46:	7402                	ld	s0,32(sp)
  48:	64e2                	ld	s1,24(sp)
  4a:	6942                	ld	s2,16(sp)
  4c:	69a2                	ld	s3,8(sp)
  4e:	6145                	addi	sp,sp,48
  50:	8082                	ret

0000000000000052 <main>:

int
main(int argc, char *argv[])
{
  52:	1101                	addi	sp,sp,-32
  54:	ec06                	sd	ra,24(sp)
  56:	e822                	sd	s0,16(sp)
  58:	e426                	sd	s1,8(sp)
  5a:	1000                	addi	s0,sp,32
  5c:	44d1                	li	s1,20
  for (int i=0; i < MAXATTEMPT; i++) {
    attack();
  5e:	fa3ff0ef          	jal	0 <attack>
  for (int i=0; i < MAXATTEMPT; i++) {
  62:	34fd                	addiw	s1,s1,-1
  64:	fced                	bnez	s1,5e <main+0xc>
  }

  return 0;
}
  66:	4501                	li	a0,0
  68:	60e2                	ld	ra,24(sp)
  6a:	6442                	ld	s0,16(sp)
  6c:	64a2                	ld	s1,8(sp)
  6e:	6105                	addi	sp,sp,32
  70:	8082                	ret

0000000000000072 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  72:	1141                	addi	sp,sp,-16
  74:	e406                	sd	ra,8(sp)
  76:	e022                	sd	s0,0(sp)
  78:	0800                	addi	s0,sp,16
  extern int main();
  main();
  7a:	fd9ff0ef          	jal	52 <main>
  exit(0);
  7e:	4501                	li	a0,0
  80:	2aa000ef          	jal	32a <exit>

0000000000000084 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  84:	1141                	addi	sp,sp,-16
  86:	e406                	sd	ra,8(sp)
  88:	e022                	sd	s0,0(sp)
  8a:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  8c:	87aa                	mv	a5,a0
  8e:	0585                	addi	a1,a1,1
  90:	0785                	addi	a5,a5,1
  92:	fff5c703          	lbu	a4,-1(a1)
  96:	fee78fa3          	sb	a4,-1(a5)
  9a:	fb75                	bnez	a4,8e <strcpy+0xa>
    ;
  return os;
}
  9c:	60a2                	ld	ra,8(sp)
  9e:	6402                	ld	s0,0(sp)
  a0:	0141                	addi	sp,sp,16
  a2:	8082                	ret

00000000000000a4 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  a4:	1141                	addi	sp,sp,-16
  a6:	e406                	sd	ra,8(sp)
  a8:	e022                	sd	s0,0(sp)
  aa:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ac:	00054783          	lbu	a5,0(a0)
  b0:	cb91                	beqz	a5,c4 <strcmp+0x20>
  b2:	0005c703          	lbu	a4,0(a1)
  b6:	00f71763          	bne	a4,a5,c4 <strcmp+0x20>
    p++, q++;
  ba:	0505                	addi	a0,a0,1
  bc:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  be:	00054783          	lbu	a5,0(a0)
  c2:	fbe5                	bnez	a5,b2 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  c4:	0005c503          	lbu	a0,0(a1)
}
  c8:	40a7853b          	subw	a0,a5,a0
  cc:	60a2                	ld	ra,8(sp)
  ce:	6402                	ld	s0,0(sp)
  d0:	0141                	addi	sp,sp,16
  d2:	8082                	ret

00000000000000d4 <strlen>:

uint
strlen(const char *s)
{
  d4:	1141                	addi	sp,sp,-16
  d6:	e406                	sd	ra,8(sp)
  d8:	e022                	sd	s0,0(sp)
  da:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  dc:	00054783          	lbu	a5,0(a0)
  e0:	cf91                	beqz	a5,fc <strlen+0x28>
  e2:	00150793          	addi	a5,a0,1
  e6:	86be                	mv	a3,a5
  e8:	0785                	addi	a5,a5,1
  ea:	fff7c703          	lbu	a4,-1(a5)
  ee:	ff65                	bnez	a4,e6 <strlen+0x12>
  f0:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret
  for(n = 0; s[n]; n++)
  fc:	4501                	li	a0,0
  fe:	bfdd                	j	f4 <strlen+0x20>

0000000000000100 <memset>:

void*
memset(void *dst, int c, uint n)
{
 100:	1141                	addi	sp,sp,-16
 102:	e406                	sd	ra,8(sp)
 104:	e022                	sd	s0,0(sp)
 106:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 108:	ca19                	beqz	a2,11e <memset+0x1e>
 10a:	87aa                	mv	a5,a0
 10c:	1602                	slli	a2,a2,0x20
 10e:	9201                	srli	a2,a2,0x20
 110:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 114:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 118:	0785                	addi	a5,a5,1
 11a:	fee79de3          	bne	a5,a4,114 <memset+0x14>
  }
  return dst;
}
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strchr>:

char*
strchr(const char *s, char c)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  for(; *s; s++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf81                	beqz	a5,14a <strchr+0x24>
    if(*s == c)
 134:	00f58763          	beq	a1,a5,142 <strchr+0x1c>
  for(; *s; s++)
 138:	0505                	addi	a0,a0,1
 13a:	00054783          	lbu	a5,0(a0)
 13e:	fbfd                	bnez	a5,134 <strchr+0xe>
      return (char*)s;
  return 0;
 140:	4501                	li	a0,0
}
 142:	60a2                	ld	ra,8(sp)
 144:	6402                	ld	s0,0(sp)
 146:	0141                	addi	sp,sp,16
 148:	8082                	ret
  return 0;
 14a:	4501                	li	a0,0
 14c:	bfdd                	j	142 <strchr+0x1c>

000000000000014e <gets>:

char*
gets(char *buf, int max)
{
 14e:	711d                	addi	sp,sp,-96
 150:	ec86                	sd	ra,88(sp)
 152:	e8a2                	sd	s0,80(sp)
 154:	e4a6                	sd	s1,72(sp)
 156:	e0ca                	sd	s2,64(sp)
 158:	fc4e                	sd	s3,56(sp)
 15a:	f852                	sd	s4,48(sp)
 15c:	f456                	sd	s5,40(sp)
 15e:	f05a                	sd	s6,32(sp)
 160:	ec5e                	sd	s7,24(sp)
 162:	e862                	sd	s8,16(sp)
 164:	1080                	addi	s0,sp,96
 166:	8baa                	mv	s7,a0
 168:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 16a:	892a                	mv	s2,a0
 16c:	4481                	li	s1,0
    cc = read(0, &c, 1);
 16e:	faf40b13          	addi	s6,s0,-81
 172:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 174:	8c26                	mv	s8,s1
 176:	0014899b          	addiw	s3,s1,1
 17a:	84ce                	mv	s1,s3
 17c:	0349d463          	bge	s3,s4,1a4 <gets+0x56>
    cc = read(0, &c, 1);
 180:	8656                	mv	a2,s5
 182:	85da                	mv	a1,s6
 184:	4501                	li	a0,0
 186:	1bc000ef          	jal	342 <read>
    if(cc < 1)
 18a:	00a05d63          	blez	a0,1a4 <gets+0x56>
      break;
    buf[i++] = c;
 18e:	faf44783          	lbu	a5,-81(s0)
 192:	00f90023          	sb	a5,0(s2) # 1000 <freep>
    if(c == '\n' || c == '\r')
 196:	0905                	addi	s2,s2,1
 198:	ff678713          	addi	a4,a5,-10
 19c:	c319                	beqz	a4,1a2 <gets+0x54>
 19e:	17cd                	addi	a5,a5,-13
 1a0:	fbf1                	bnez	a5,174 <gets+0x26>
    buf[i++] = c;
 1a2:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1a4:	9c5e                	add	s8,s8,s7
 1a6:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1aa:	855e                	mv	a0,s7
 1ac:	60e6                	ld	ra,88(sp)
 1ae:	6446                	ld	s0,80(sp)
 1b0:	64a6                	ld	s1,72(sp)
 1b2:	6906                	ld	s2,64(sp)
 1b4:	79e2                	ld	s3,56(sp)
 1b6:	7a42                	ld	s4,48(sp)
 1b8:	7aa2                	ld	s5,40(sp)
 1ba:	7b02                	ld	s6,32(sp)
 1bc:	6be2                	ld	s7,24(sp)
 1be:	6c42                	ld	s8,16(sp)
 1c0:	6125                	addi	sp,sp,96
 1c2:	8082                	ret

00000000000001c4 <stat>:

int
stat(const char *n, struct stat *st)
{
 1c4:	1101                	addi	sp,sp,-32
 1c6:	ec06                	sd	ra,24(sp)
 1c8:	e822                	sd	s0,16(sp)
 1ca:	e04a                	sd	s2,0(sp)
 1cc:	1000                	addi	s0,sp,32
 1ce:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1d0:	4581                	li	a1,0
 1d2:	198000ef          	jal	36a <open>
  if(fd < 0)
 1d6:	02054263          	bltz	a0,1fa <stat+0x36>
 1da:	e426                	sd	s1,8(sp)
 1dc:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1de:	85ca                	mv	a1,s2
 1e0:	1a2000ef          	jal	382 <fstat>
 1e4:	892a                	mv	s2,a0
  close(fd);
 1e6:	8526                	mv	a0,s1
 1e8:	16a000ef          	jal	352 <close>
  return r;
 1ec:	64a2                	ld	s1,8(sp)
}
 1ee:	854a                	mv	a0,s2
 1f0:	60e2                	ld	ra,24(sp)
 1f2:	6442                	ld	s0,16(sp)
 1f4:	6902                	ld	s2,0(sp)
 1f6:	6105                	addi	sp,sp,32
 1f8:	8082                	ret
    return -1;
 1fa:	57fd                	li	a5,-1
 1fc:	893e                	mv	s2,a5
 1fe:	bfc5                	j	1ee <stat+0x2a>

0000000000000200 <atoi>:

int
atoi(const char *s)
{
 200:	1141                	addi	sp,sp,-16
 202:	e406                	sd	ra,8(sp)
 204:	e022                	sd	s0,0(sp)
 206:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 208:	00054683          	lbu	a3,0(a0)
 20c:	fd06879b          	addiw	a5,a3,-48
 210:	0ff7f793          	zext.b	a5,a5
 214:	4625                	li	a2,9
 216:	02f66963          	bltu	a2,a5,248 <atoi+0x48>
 21a:	872a                	mv	a4,a0
  n = 0;
 21c:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 21e:	0705                	addi	a4,a4,1
 220:	0025179b          	slliw	a5,a0,0x2
 224:	9fa9                	addw	a5,a5,a0
 226:	0017979b          	slliw	a5,a5,0x1
 22a:	9fb5                	addw	a5,a5,a3
 22c:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 230:	00074683          	lbu	a3,0(a4)
 234:	fd06879b          	addiw	a5,a3,-48
 238:	0ff7f793          	zext.b	a5,a5
 23c:	fef671e3          	bgeu	a2,a5,21e <atoi+0x1e>
  return n;
}
 240:	60a2                	ld	ra,8(sp)
 242:	6402                	ld	s0,0(sp)
 244:	0141                	addi	sp,sp,16
 246:	8082                	ret
  n = 0;
 248:	4501                	li	a0,0
 24a:	bfdd                	j	240 <atoi+0x40>

000000000000024c <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 254:	02b57563          	bgeu	a0,a1,27e <memmove+0x32>
    while(n-- > 0)
 258:	00c05f63          	blez	a2,276 <memmove+0x2a>
 25c:	1602                	slli	a2,a2,0x20
 25e:	9201                	srli	a2,a2,0x20
 260:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 264:	872a                	mv	a4,a0
      *dst++ = *src++;
 266:	0585                	addi	a1,a1,1
 268:	0705                	addi	a4,a4,1
 26a:	fff5c683          	lbu	a3,-1(a1)
 26e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 272:	fee79ae3          	bne	a5,a4,266 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 276:	60a2                	ld	ra,8(sp)
 278:	6402                	ld	s0,0(sp)
 27a:	0141                	addi	sp,sp,16
 27c:	8082                	ret
    while(n-- > 0)
 27e:	fec05ce3          	blez	a2,276 <memmove+0x2a>
    dst += n;
 282:	00c50733          	add	a4,a0,a2
    src += n;
 286:	95b2                	add	a1,a1,a2
 288:	fff6079b          	addiw	a5,a2,-1
 28c:	1782                	slli	a5,a5,0x20
 28e:	9381                	srli	a5,a5,0x20
 290:	fff7c793          	not	a5,a5
 294:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 296:	15fd                	addi	a1,a1,-1
 298:	177d                	addi	a4,a4,-1
 29a:	0005c683          	lbu	a3,0(a1)
 29e:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2a2:	fef71ae3          	bne	a4,a5,296 <memmove+0x4a>
 2a6:	bfc1                	j	276 <memmove+0x2a>

00000000000002a8 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2b0:	c61d                	beqz	a2,2de <memcmp+0x36>
 2b2:	1602                	slli	a2,a2,0x20
 2b4:	9201                	srli	a2,a2,0x20
 2b6:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2ba:	00054783          	lbu	a5,0(a0)
 2be:	0005c703          	lbu	a4,0(a1)
 2c2:	00e79863          	bne	a5,a4,2d2 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2c6:	0505                	addi	a0,a0,1
    p2++;
 2c8:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2ca:	fed518e3          	bne	a0,a3,2ba <memcmp+0x12>
  }
  return 0;
 2ce:	4501                	li	a0,0
 2d0:	a019                	j	2d6 <memcmp+0x2e>
      return *p1 - *p2;
 2d2:	40e7853b          	subw	a0,a5,a4
}
 2d6:	60a2                	ld	ra,8(sp)
 2d8:	6402                	ld	s0,0(sp)
 2da:	0141                	addi	sp,sp,16
 2dc:	8082                	ret
  return 0;
 2de:	4501                	li	a0,0
 2e0:	bfdd                	j	2d6 <memcmp+0x2e>

00000000000002e2 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2e2:	1141                	addi	sp,sp,-16
 2e4:	e406                	sd	ra,8(sp)
 2e6:	e022                	sd	s0,0(sp)
 2e8:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2ea:	f63ff0ef          	jal	24c <memmove>
}
 2ee:	60a2                	ld	ra,8(sp)
 2f0:	6402                	ld	s0,0(sp)
 2f2:	0141                	addi	sp,sp,16
 2f4:	8082                	ret

00000000000002f6 <sbrk>:

char *
sbrk(int n) {
 2f6:	1141                	addi	sp,sp,-16
 2f8:	e406                	sd	ra,8(sp)
 2fa:	e022                	sd	s0,0(sp)
 2fc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 2fe:	4585                	li	a1,1
 300:	0b2000ef          	jal	3b2 <sys_sbrk>
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret

000000000000030c <sbrklazy>:

char *
sbrklazy(int n) {
 30c:	1141                	addi	sp,sp,-16
 30e:	e406                	sd	ra,8(sp)
 310:	e022                	sd	s0,0(sp)
 312:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 314:	4589                	li	a1,2
 316:	09c000ef          	jal	3b2 <sys_sbrk>
}
 31a:	60a2                	ld	ra,8(sp)
 31c:	6402                	ld	s0,0(sp)
 31e:	0141                	addi	sp,sp,16
 320:	8082                	ret

0000000000000322 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 322:	4885                	li	a7,1
 ecall
 324:	00000073          	ecall
 ret
 328:	8082                	ret

000000000000032a <exit>:
.global exit
exit:
 li a7, SYS_exit
 32a:	4889                	li	a7,2
 ecall
 32c:	00000073          	ecall
 ret
 330:	8082                	ret

0000000000000332 <wait>:
.global wait
wait:
 li a7, SYS_wait
 332:	488d                	li	a7,3
 ecall
 334:	00000073          	ecall
 ret
 338:	8082                	ret

000000000000033a <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 33a:	4891                	li	a7,4
 ecall
 33c:	00000073          	ecall
 ret
 340:	8082                	ret

0000000000000342 <read>:
.global read
read:
 li a7, SYS_read
 342:	4895                	li	a7,5
 ecall
 344:	00000073          	ecall
 ret
 348:	8082                	ret

000000000000034a <write>:
.global write
write:
 li a7, SYS_write
 34a:	48c1                	li	a7,16
 ecall
 34c:	00000073          	ecall
 ret
 350:	8082                	ret

0000000000000352 <close>:
.global close
close:
 li a7, SYS_close
 352:	48d5                	li	a7,21
 ecall
 354:	00000073          	ecall
 ret
 358:	8082                	ret

000000000000035a <kill>:
.global kill
kill:
 li a7, SYS_kill
 35a:	4899                	li	a7,6
 ecall
 35c:	00000073          	ecall
 ret
 360:	8082                	ret

0000000000000362 <exec>:
.global exec
exec:
 li a7, SYS_exec
 362:	489d                	li	a7,7
 ecall
 364:	00000073          	ecall
 ret
 368:	8082                	ret

000000000000036a <open>:
.global open
open:
 li a7, SYS_open
 36a:	48bd                	li	a7,15
 ecall
 36c:	00000073          	ecall
 ret
 370:	8082                	ret

0000000000000372 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 372:	48c5                	li	a7,17
 ecall
 374:	00000073          	ecall
 ret
 378:	8082                	ret

000000000000037a <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 37a:	48c9                	li	a7,18
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 382:	48a1                	li	a7,8
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <link>:
.global link
link:
 li a7, SYS_link
 38a:	48cd                	li	a7,19
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 392:	48d1                	li	a7,20
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 39a:	48a5                	li	a7,9
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3a2:	48a9                	li	a7,10
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3aa:	48ad                	li	a7,11
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3b2:	48b1                	li	a7,12
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <pause>:
.global pause
pause:
 li a7, SYS_pause
 3ba:	48b5                	li	a7,13
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3c2:	48b9                	li	a7,14
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
 3ca:	48d9                	li	a7,22
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3d2:	1101                	addi	sp,sp,-32
 3d4:	ec06                	sd	ra,24(sp)
 3d6:	e822                	sd	s0,16(sp)
 3d8:	1000                	addi	s0,sp,32
 3da:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3de:	4605                	li	a2,1
 3e0:	fef40593          	addi	a1,s0,-17
 3e4:	f67ff0ef          	jal	34a <write>
}
 3e8:	60e2                	ld	ra,24(sp)
 3ea:	6442                	ld	s0,16(sp)
 3ec:	6105                	addi	sp,sp,32
 3ee:	8082                	ret

00000000000003f0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3f0:	715d                	addi	sp,sp,-80
 3f2:	e486                	sd	ra,72(sp)
 3f4:	e0a2                	sd	s0,64(sp)
 3f6:	f84a                	sd	s2,48(sp)
 3f8:	f44e                	sd	s3,40(sp)
 3fa:	0880                	addi	s0,sp,80
 3fc:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3fe:	cac1                	beqz	a3,48e <printint+0x9e>
 400:	0805d763          	bgez	a1,48e <printint+0x9e>
    neg = 1;
    x = -xx;
 404:	40b005bb          	negw	a1,a1
    neg = 1;
 408:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 40a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 40e:	86ce                	mv	a3,s3
  i = 0;
 410:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 412:	00000817          	auipc	a6,0x0
 416:	53e80813          	addi	a6,a6,1342 # 950 <digits>
 41a:	88ba                	mv	a7,a4
 41c:	0017051b          	addiw	a0,a4,1
 420:	872a                	mv	a4,a0
 422:	02c5f7bb          	remuw	a5,a1,a2
 426:	1782                	slli	a5,a5,0x20
 428:	9381                	srli	a5,a5,0x20
 42a:	97c2                	add	a5,a5,a6
 42c:	0007c783          	lbu	a5,0(a5)
 430:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 434:	87ae                	mv	a5,a1
 436:	02c5d5bb          	divuw	a1,a1,a2
 43a:	0685                	addi	a3,a3,1
 43c:	fcc7ffe3          	bgeu	a5,a2,41a <printint+0x2a>
  if(neg)
 440:	00030c63          	beqz	t1,458 <printint+0x68>
    buf[i++] = '-';
 444:	fd050793          	addi	a5,a0,-48
 448:	00878533          	add	a0,a5,s0
 44c:	02d00793          	li	a5,45
 450:	fef50423          	sb	a5,-24(a0)
 454:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 458:	02e05563          	blez	a4,482 <printint+0x92>
 45c:	fc26                	sd	s1,56(sp)
 45e:	377d                	addiw	a4,a4,-1
 460:	00e984b3          	add	s1,s3,a4
 464:	19fd                	addi	s3,s3,-1
 466:	99ba                	add	s3,s3,a4
 468:	1702                	slli	a4,a4,0x20
 46a:	9301                	srli	a4,a4,0x20
 46c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 470:	0004c583          	lbu	a1,0(s1)
 474:	854a                	mv	a0,s2
 476:	f5dff0ef          	jal	3d2 <putc>
  while(--i >= 0)
 47a:	14fd                	addi	s1,s1,-1
 47c:	ff349ae3          	bne	s1,s3,470 <printint+0x80>
 480:	74e2                	ld	s1,56(sp)
}
 482:	60a6                	ld	ra,72(sp)
 484:	6406                	ld	s0,64(sp)
 486:	7942                	ld	s2,48(sp)
 488:	79a2                	ld	s3,40(sp)
 48a:	6161                	addi	sp,sp,80
 48c:	8082                	ret
    x = xx;
 48e:	2581                	sext.w	a1,a1
  neg = 0;
 490:	4301                	li	t1,0
 492:	bfa5                	j	40a <printint+0x1a>

0000000000000494 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 494:	711d                	addi	sp,sp,-96
 496:	ec86                	sd	ra,88(sp)
 498:	e8a2                	sd	s0,80(sp)
 49a:	e4a6                	sd	s1,72(sp)
 49c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 49e:	0005c483          	lbu	s1,0(a1)
 4a2:	22048363          	beqz	s1,6c8 <vprintf+0x234>
 4a6:	e0ca                	sd	s2,64(sp)
 4a8:	fc4e                	sd	s3,56(sp)
 4aa:	f852                	sd	s4,48(sp)
 4ac:	f456                	sd	s5,40(sp)
 4ae:	f05a                	sd	s6,32(sp)
 4b0:	ec5e                	sd	s7,24(sp)
 4b2:	e862                	sd	s8,16(sp)
 4b4:	8b2a                	mv	s6,a0
 4b6:	8a2e                	mv	s4,a1
 4b8:	8bb2                	mv	s7,a2
  state = 0;
 4ba:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4bc:	4901                	li	s2,0
 4be:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4c0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4c4:	06400c13          	li	s8,100
 4c8:	a00d                	j	4ea <vprintf+0x56>
        putc(fd, c0);
 4ca:	85a6                	mv	a1,s1
 4cc:	855a                	mv	a0,s6
 4ce:	f05ff0ef          	jal	3d2 <putc>
 4d2:	a019                	j	4d8 <vprintf+0x44>
    } else if(state == '%'){
 4d4:	03598363          	beq	s3,s5,4fa <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4d8:	0019079b          	addiw	a5,s2,1
 4dc:	893e                	mv	s2,a5
 4de:	873e                	mv	a4,a5
 4e0:	97d2                	add	a5,a5,s4
 4e2:	0007c483          	lbu	s1,0(a5)
 4e6:	1c048a63          	beqz	s1,6ba <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4ea:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4ee:	fe0993e3          	bnez	s3,4d4 <vprintf+0x40>
      if(c0 == '%'){
 4f2:	fd579ce3          	bne	a5,s5,4ca <vprintf+0x36>
        state = '%';
 4f6:	89be                	mv	s3,a5
 4f8:	b7c5                	j	4d8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 4fa:	00ea06b3          	add	a3,s4,a4
 4fe:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 502:	1c060863          	beqz	a2,6d2 <vprintf+0x23e>
      if(c0 == 'd'){
 506:	03878763          	beq	a5,s8,534 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 50a:	f9478693          	addi	a3,a5,-108
 50e:	0016b693          	seqz	a3,a3
 512:	f9c60593          	addi	a1,a2,-100
 516:	e99d                	bnez	a1,54c <vprintf+0xb8>
 518:	ca95                	beqz	a3,54c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 51a:	008b8493          	addi	s1,s7,8
 51e:	4685                	li	a3,1
 520:	4629                	li	a2,10
 522:	000bb583          	ld	a1,0(s7)
 526:	855a                	mv	a0,s6
 528:	ec9ff0ef          	jal	3f0 <printint>
        i += 1;
 52c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 52e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 530:	4981                	li	s3,0
 532:	b75d                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 534:	008b8493          	addi	s1,s7,8
 538:	4685                	li	a3,1
 53a:	4629                	li	a2,10
 53c:	000ba583          	lw	a1,0(s7)
 540:	855a                	mv	a0,s6
 542:	eafff0ef          	jal	3f0 <printint>
 546:	8ba6                	mv	s7,s1
      state = 0;
 548:	4981                	li	s3,0
 54a:	b779                	j	4d8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 54c:	9752                	add	a4,a4,s4
 54e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 552:	f9460713          	addi	a4,a2,-108
 556:	00173713          	seqz	a4,a4
 55a:	8f75                	and	a4,a4,a3
 55c:	f9c58513          	addi	a0,a1,-100
 560:	18051363          	bnez	a0,6e6 <vprintf+0x252>
 564:	18070163          	beqz	a4,6e6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 568:	008b8493          	addi	s1,s7,8
 56c:	4685                	li	a3,1
 56e:	4629                	li	a2,10
 570:	000bb583          	ld	a1,0(s7)
 574:	855a                	mv	a0,s6
 576:	e7bff0ef          	jal	3f0 <printint>
        i += 2;
 57a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 57c:	8ba6                	mv	s7,s1
      state = 0;
 57e:	4981                	li	s3,0
        i += 2;
 580:	bfa1                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 582:	008b8493          	addi	s1,s7,8
 586:	4681                	li	a3,0
 588:	4629                	li	a2,10
 58a:	000be583          	lwu	a1,0(s7)
 58e:	855a                	mv	a0,s6
 590:	e61ff0ef          	jal	3f0 <printint>
 594:	8ba6                	mv	s7,s1
      state = 0;
 596:	4981                	li	s3,0
 598:	b781                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 59a:	008b8493          	addi	s1,s7,8
 59e:	4681                	li	a3,0
 5a0:	4629                	li	a2,10
 5a2:	000bb583          	ld	a1,0(s7)
 5a6:	855a                	mv	a0,s6
 5a8:	e49ff0ef          	jal	3f0 <printint>
        i += 1;
 5ac:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5ae:	8ba6                	mv	s7,s1
      state = 0;
 5b0:	4981                	li	s3,0
 5b2:	b71d                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5b4:	008b8493          	addi	s1,s7,8
 5b8:	4681                	li	a3,0
 5ba:	4629                	li	a2,10
 5bc:	000bb583          	ld	a1,0(s7)
 5c0:	855a                	mv	a0,s6
 5c2:	e2fff0ef          	jal	3f0 <printint>
        i += 2;
 5c6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c8:	8ba6                	mv	s7,s1
      state = 0;
 5ca:	4981                	li	s3,0
        i += 2;
 5cc:	b731                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5ce:	008b8493          	addi	s1,s7,8
 5d2:	4681                	li	a3,0
 5d4:	4641                	li	a2,16
 5d6:	000be583          	lwu	a1,0(s7)
 5da:	855a                	mv	a0,s6
 5dc:	e15ff0ef          	jal	3f0 <printint>
 5e0:	8ba6                	mv	s7,s1
      state = 0;
 5e2:	4981                	li	s3,0
 5e4:	bdd5                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5e6:	008b8493          	addi	s1,s7,8
 5ea:	4681                	li	a3,0
 5ec:	4641                	li	a2,16
 5ee:	000bb583          	ld	a1,0(s7)
 5f2:	855a                	mv	a0,s6
 5f4:	dfdff0ef          	jal	3f0 <printint>
        i += 1;
 5f8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 5fa:	8ba6                	mv	s7,s1
      state = 0;
 5fc:	4981                	li	s3,0
 5fe:	bde9                	j	4d8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 600:	008b8493          	addi	s1,s7,8
 604:	4681                	li	a3,0
 606:	4641                	li	a2,16
 608:	000bb583          	ld	a1,0(s7)
 60c:	855a                	mv	a0,s6
 60e:	de3ff0ef          	jal	3f0 <printint>
        i += 2;
 612:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 614:	8ba6                	mv	s7,s1
      state = 0;
 616:	4981                	li	s3,0
        i += 2;
 618:	b5c1                	j	4d8 <vprintf+0x44>
 61a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 61c:	008b8793          	addi	a5,s7,8
 620:	8cbe                	mv	s9,a5
 622:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 626:	03000593          	li	a1,48
 62a:	855a                	mv	a0,s6
 62c:	da7ff0ef          	jal	3d2 <putc>
  putc(fd, 'x');
 630:	07800593          	li	a1,120
 634:	855a                	mv	a0,s6
 636:	d9dff0ef          	jal	3d2 <putc>
 63a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 63c:	00000b97          	auipc	s7,0x0
 640:	314b8b93          	addi	s7,s7,788 # 950 <digits>
 644:	03c9d793          	srli	a5,s3,0x3c
 648:	97de                	add	a5,a5,s7
 64a:	0007c583          	lbu	a1,0(a5)
 64e:	855a                	mv	a0,s6
 650:	d83ff0ef          	jal	3d2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 654:	0992                	slli	s3,s3,0x4
 656:	34fd                	addiw	s1,s1,-1
 658:	f4f5                	bnez	s1,644 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 65a:	8be6                	mv	s7,s9
      state = 0;
 65c:	4981                	li	s3,0
 65e:	6ca2                	ld	s9,8(sp)
 660:	bda5                	j	4d8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 662:	008b8493          	addi	s1,s7,8
 666:	000bc583          	lbu	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	d67ff0ef          	jal	3d2 <putc>
 670:	8ba6                	mv	s7,s1
      state = 0;
 672:	4981                	li	s3,0
 674:	b595                	j	4d8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 676:	008b8993          	addi	s3,s7,8
 67a:	000bb483          	ld	s1,0(s7)
 67e:	cc91                	beqz	s1,69a <vprintf+0x206>
        for(; *s; s++)
 680:	0004c583          	lbu	a1,0(s1)
 684:	c985                	beqz	a1,6b4 <vprintf+0x220>
          putc(fd, *s);
 686:	855a                	mv	a0,s6
 688:	d4bff0ef          	jal	3d2 <putc>
        for(; *s; s++)
 68c:	0485                	addi	s1,s1,1
 68e:	0004c583          	lbu	a1,0(s1)
 692:	f9f5                	bnez	a1,686 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 694:	8bce                	mv	s7,s3
      state = 0;
 696:	4981                	li	s3,0
 698:	b581                	j	4d8 <vprintf+0x44>
          s = "(null)";
 69a:	00000497          	auipc	s1,0x0
 69e:	2ae48493          	addi	s1,s1,686 # 948 <malloc+0x112>
        for(; *s; s++)
 6a2:	02800593          	li	a1,40
 6a6:	b7c5                	j	686 <vprintf+0x1f2>
        putc(fd, '%');
 6a8:	85be                	mv	a1,a5
 6aa:	855a                	mv	a0,s6
 6ac:	d27ff0ef          	jal	3d2 <putc>
      state = 0;
 6b0:	4981                	li	s3,0
 6b2:	b51d                	j	4d8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6b4:	8bce                	mv	s7,s3
      state = 0;
 6b6:	4981                	li	s3,0
 6b8:	b505                	j	4d8 <vprintf+0x44>
 6ba:	6906                	ld	s2,64(sp)
 6bc:	79e2                	ld	s3,56(sp)
 6be:	7a42                	ld	s4,48(sp)
 6c0:	7aa2                	ld	s5,40(sp)
 6c2:	7b02                	ld	s6,32(sp)
 6c4:	6be2                	ld	s7,24(sp)
 6c6:	6c42                	ld	s8,16(sp)
    }
  }
}
 6c8:	60e6                	ld	ra,88(sp)
 6ca:	6446                	ld	s0,80(sp)
 6cc:	64a6                	ld	s1,72(sp)
 6ce:	6125                	addi	sp,sp,96
 6d0:	8082                	ret
      if(c0 == 'd'){
 6d2:	06400713          	li	a4,100
 6d6:	e4e78fe3          	beq	a5,a4,534 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6da:	f9478693          	addi	a3,a5,-108
 6de:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6e2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6e4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6e6:	07500513          	li	a0,117
 6ea:	e8a78ce3          	beq	a5,a0,582 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6ee:	f8b60513          	addi	a0,a2,-117
 6f2:	e119                	bnez	a0,6f8 <vprintf+0x264>
 6f4:	ea0693e3          	bnez	a3,59a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 6f8:	f8b58513          	addi	a0,a1,-117
 6fc:	e119                	bnez	a0,702 <vprintf+0x26e>
 6fe:	ea071be3          	bnez	a4,5b4 <vprintf+0x120>
      } else if(c0 == 'x'){
 702:	07800513          	li	a0,120
 706:	eca784e3          	beq	a5,a0,5ce <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 70a:	f8860613          	addi	a2,a2,-120
 70e:	e219                	bnez	a2,714 <vprintf+0x280>
 710:	ec069be3          	bnez	a3,5e6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 714:	f8858593          	addi	a1,a1,-120
 718:	e199                	bnez	a1,71e <vprintf+0x28a>
 71a:	ee0713e3          	bnez	a4,600 <vprintf+0x16c>
      } else if(c0 == 'p'){
 71e:	07000713          	li	a4,112
 722:	eee78ce3          	beq	a5,a4,61a <vprintf+0x186>
      } else if(c0 == 'c'){
 726:	06300713          	li	a4,99
 72a:	f2e78ce3          	beq	a5,a4,662 <vprintf+0x1ce>
      } else if(c0 == 's'){
 72e:	07300713          	li	a4,115
 732:	f4e782e3          	beq	a5,a4,676 <vprintf+0x1e2>
      } else if(c0 == '%'){
 736:	02500713          	li	a4,37
 73a:	f6e787e3          	beq	a5,a4,6a8 <vprintf+0x214>
        putc(fd, '%');
 73e:	02500593          	li	a1,37
 742:	855a                	mv	a0,s6
 744:	c8fff0ef          	jal	3d2 <putc>
        putc(fd, c0);
 748:	85a6                	mv	a1,s1
 74a:	855a                	mv	a0,s6
 74c:	c87ff0ef          	jal	3d2 <putc>
      state = 0;
 750:	4981                	li	s3,0
 752:	b359                	j	4d8 <vprintf+0x44>

0000000000000754 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 754:	715d                	addi	sp,sp,-80
 756:	ec06                	sd	ra,24(sp)
 758:	e822                	sd	s0,16(sp)
 75a:	1000                	addi	s0,sp,32
 75c:	e010                	sd	a2,0(s0)
 75e:	e414                	sd	a3,8(s0)
 760:	e818                	sd	a4,16(s0)
 762:	ec1c                	sd	a5,24(s0)
 764:	03043023          	sd	a6,32(s0)
 768:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 76c:	8622                	mv	a2,s0
 76e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 772:	d23ff0ef          	jal	494 <vprintf>
}
 776:	60e2                	ld	ra,24(sp)
 778:	6442                	ld	s0,16(sp)
 77a:	6161                	addi	sp,sp,80
 77c:	8082                	ret

000000000000077e <printf>:

void
printf(const char *fmt, ...)
{
 77e:	711d                	addi	sp,sp,-96
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	1000                	addi	s0,sp,32
 786:	e40c                	sd	a1,8(s0)
 788:	e810                	sd	a2,16(s0)
 78a:	ec14                	sd	a3,24(s0)
 78c:	f018                	sd	a4,32(s0)
 78e:	f41c                	sd	a5,40(s0)
 790:	03043823          	sd	a6,48(s0)
 794:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 798:	00840613          	addi	a2,s0,8
 79c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7a0:	85aa                	mv	a1,a0
 7a2:	4505                	li	a0,1
 7a4:	cf1ff0ef          	jal	494 <vprintf>
}
 7a8:	60e2                	ld	ra,24(sp)
 7aa:	6442                	ld	s0,16(sp)
 7ac:	6125                	addi	sp,sp,96
 7ae:	8082                	ret

00000000000007b0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7b0:	1141                	addi	sp,sp,-16
 7b2:	e406                	sd	ra,8(sp)
 7b4:	e022                	sd	s0,0(sp)
 7b6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7b8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7bc:	00001797          	auipc	a5,0x1
 7c0:	8447b783          	ld	a5,-1980(a5) # 1000 <freep>
 7c4:	a039                	j	7d2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7c6:	6398                	ld	a4,0(a5)
 7c8:	00e7e463          	bltu	a5,a4,7d0 <free+0x20>
 7cc:	00e6ea63          	bltu	a3,a4,7e0 <free+0x30>
{
 7d0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7d2:	fed7fae3          	bgeu	a5,a3,7c6 <free+0x16>
 7d6:	6398                	ld	a4,0(a5)
 7d8:	00e6e463          	bltu	a3,a4,7e0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7dc:	fee7eae3          	bltu	a5,a4,7d0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7e0:	ff852583          	lw	a1,-8(a0)
 7e4:	6390                	ld	a2,0(a5)
 7e6:	02059813          	slli	a6,a1,0x20
 7ea:	01c85713          	srli	a4,a6,0x1c
 7ee:	9736                	add	a4,a4,a3
 7f0:	02e60563          	beq	a2,a4,81a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 7f4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 7f8:	4790                	lw	a2,8(a5)
 7fa:	02061593          	slli	a1,a2,0x20
 7fe:	01c5d713          	srli	a4,a1,0x1c
 802:	973e                	add	a4,a4,a5
 804:	02e68263          	beq	a3,a4,828 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 808:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 80a:	00000717          	auipc	a4,0x0
 80e:	7ef73b23          	sd	a5,2038(a4) # 1000 <freep>
}
 812:	60a2                	ld	ra,8(sp)
 814:	6402                	ld	s0,0(sp)
 816:	0141                	addi	sp,sp,16
 818:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 81a:	4618                	lw	a4,8(a2)
 81c:	9f2d                	addw	a4,a4,a1
 81e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 822:	6398                	ld	a4,0(a5)
 824:	6310                	ld	a2,0(a4)
 826:	b7f9                	j	7f4 <free+0x44>
    p->s.size += bp->s.size;
 828:	ff852703          	lw	a4,-8(a0)
 82c:	9f31                	addw	a4,a4,a2
 82e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 830:	ff053683          	ld	a3,-16(a0)
 834:	bfd1                	j	808 <free+0x58>

0000000000000836 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 836:	7139                	addi	sp,sp,-64
 838:	fc06                	sd	ra,56(sp)
 83a:	f822                	sd	s0,48(sp)
 83c:	f04a                	sd	s2,32(sp)
 83e:	ec4e                	sd	s3,24(sp)
 840:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 842:	02051993          	slli	s3,a0,0x20
 846:	0209d993          	srli	s3,s3,0x20
 84a:	09bd                	addi	s3,s3,15
 84c:	0049d993          	srli	s3,s3,0x4
 850:	2985                	addiw	s3,s3,1
 852:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 854:	00000517          	auipc	a0,0x0
 858:	7ac53503          	ld	a0,1964(a0) # 1000 <freep>
 85c:	c905                	beqz	a0,88c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 85e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 860:	4798                	lw	a4,8(a5)
 862:	09377663          	bgeu	a4,s3,8ee <malloc+0xb8>
 866:	f426                	sd	s1,40(sp)
 868:	e852                	sd	s4,16(sp)
 86a:	e456                	sd	s5,8(sp)
 86c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 86e:	8a4e                	mv	s4,s3
 870:	6705                	lui	a4,0x1
 872:	00e9f363          	bgeu	s3,a4,878 <malloc+0x42>
 876:	6a05                	lui	s4,0x1
 878:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 87c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 880:	00000497          	auipc	s1,0x0
 884:	78048493          	addi	s1,s1,1920 # 1000 <freep>
  if(p == SBRK_ERROR)
 888:	5afd                	li	s5,-1
 88a:	a83d                	j	8c8 <malloc+0x92>
 88c:	f426                	sd	s1,40(sp)
 88e:	e852                	sd	s4,16(sp)
 890:	e456                	sd	s5,8(sp)
 892:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 894:	00000797          	auipc	a5,0x0
 898:	77c78793          	addi	a5,a5,1916 # 1010 <base>
 89c:	00000717          	auipc	a4,0x0
 8a0:	76f73223          	sd	a5,1892(a4) # 1000 <freep>
 8a4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8a6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8aa:	b7d1                	j	86e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ac:	6398                	ld	a4,0(a5)
 8ae:	e118                	sd	a4,0(a0)
 8b0:	a899                	j	906 <malloc+0xd0>
  hp->s.size = nu;
 8b2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8b6:	0541                	addi	a0,a0,16
 8b8:	ef9ff0ef          	jal	7b0 <free>
  return freep;
 8bc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8be:	c125                	beqz	a0,91e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8c0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8c2:	4798                	lw	a4,8(a5)
 8c4:	03277163          	bgeu	a4,s2,8e6 <malloc+0xb0>
    if(p == freep)
 8c8:	6098                	ld	a4,0(s1)
 8ca:	853e                	mv	a0,a5
 8cc:	fef71ae3          	bne	a4,a5,8c0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8d0:	8552                	mv	a0,s4
 8d2:	a25ff0ef          	jal	2f6 <sbrk>
  if(p == SBRK_ERROR)
 8d6:	fd551ee3          	bne	a0,s5,8b2 <malloc+0x7c>
        return 0;
 8da:	4501                	li	a0,0
 8dc:	74a2                	ld	s1,40(sp)
 8de:	6a42                	ld	s4,16(sp)
 8e0:	6aa2                	ld	s5,8(sp)
 8e2:	6b02                	ld	s6,0(sp)
 8e4:	a03d                	j	912 <malloc+0xdc>
 8e6:	74a2                	ld	s1,40(sp)
 8e8:	6a42                	ld	s4,16(sp)
 8ea:	6aa2                	ld	s5,8(sp)
 8ec:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8ee:	fae90fe3          	beq	s2,a4,8ac <malloc+0x76>
        p->s.size -= nunits;
 8f2:	4137073b          	subw	a4,a4,s3
 8f6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 8f8:	02071693          	slli	a3,a4,0x20
 8fc:	01c6d713          	srli	a4,a3,0x1c
 900:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 902:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 906:	00000717          	auipc	a4,0x0
 90a:	6ea73d23          	sd	a0,1786(a4) # 1000 <freep>
      return (void*)(p + 1);
 90e:	01078513          	addi	a0,a5,16
  }
}
 912:	70e2                	ld	ra,56(sp)
 914:	7442                	ld	s0,48(sp)
 916:	7902                	ld	s2,32(sp)
 918:	69e2                	ld	s3,24(sp)
 91a:	6121                	addi	sp,sp,64
 91c:	8082                	ret
 91e:	74a2                	ld	s1,40(sp)
 920:	6a42                	ld	s4,16(sp)
 922:	6aa2                	ld	s5,8(sp)
 924:	6b02                	ld	s6,0(sp)
 926:	b7f5                	j	912 <malloc+0xdc>
