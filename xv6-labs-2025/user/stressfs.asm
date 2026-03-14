
user/_stressfs:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"

int
main(int argc, char *argv[])
{
   0:	dc010113          	addi	sp,sp,-576
   4:	22113c23          	sd	ra,568(sp)
   8:	22813823          	sd	s0,560(sp)
   c:	22913423          	sd	s1,552(sp)
  10:	23213023          	sd	s2,544(sp)
  14:	21313c23          	sd	s3,536(sp)
  18:	21413823          	sd	s4,528(sp)
  1c:	0480                	addi	s0,sp,576
  int fd, i;
  char path[] = "stressfs0";
  1e:	00001797          	auipc	a5,0x1
  22:	a6278793          	addi	a5,a5,-1438 # a80 <statistics+0xa8>
  26:	6398                	ld	a4,0(a5)
  28:	fce43023          	sd	a4,-64(s0)
  2c:	0087d783          	lhu	a5,8(a5)
  30:	fcf41423          	sh	a5,-56(s0)
  char data[512];

  printf("stressfs starting\n");
  34:	00001517          	auipc	a0,0x1
  38:	a1c50513          	addi	a0,a0,-1508 # a50 <statistics+0x78>
  3c:	7f2000ef          	jal	82e <printf>
  memset(data, 'a', sizeof(data));
  40:	20000613          	li	a2,512
  44:	06100593          	li	a1,97
  48:	dc040513          	addi	a0,s0,-576
  4c:	128000ef          	jal	174 <memset>

  for(i = 0; i < 4; i++)
  50:	4481                	li	s1,0
  52:	4911                	li	s2,4
    if(fork() > 0)
  54:	342000ef          	jal	396 <fork>
  58:	00a04563          	bgtz	a0,62 <main+0x62>
  for(i = 0; i < 4; i++)
  5c:	2485                	addiw	s1,s1,1
  5e:	ff249be3          	bne	s1,s2,54 <main+0x54>
      break;

  printf("write %d\n", i);
  62:	85a6                	mv	a1,s1
  64:	00001517          	auipc	a0,0x1
  68:	a0450513          	addi	a0,a0,-1532 # a68 <statistics+0x90>
  6c:	7c2000ef          	jal	82e <printf>

  path[8] += i;
  70:	fc844783          	lbu	a5,-56(s0)
  74:	9fa5                	addw	a5,a5,s1
  76:	fcf40423          	sb	a5,-56(s0)
  fd = open(path, O_CREATE | O_RDWR);
  7a:	20200593          	li	a1,514
  7e:	fc040513          	addi	a0,s0,-64
  82:	35c000ef          	jal	3de <open>
  86:	892a                	mv	s2,a0
  88:	44d1                	li	s1,20
  for(i = 0; i < 20; i++)
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  8a:	dc040a13          	addi	s4,s0,-576
  8e:	20000993          	li	s3,512
  92:	864e                	mv	a2,s3
  94:	85d2                	mv	a1,s4
  96:	854a                	mv	a0,s2
  98:	326000ef          	jal	3be <write>
  for(i = 0; i < 20; i++)
  9c:	34fd                	addiw	s1,s1,-1
  9e:	f8f5                	bnez	s1,92 <main+0x92>
  close(fd);
  a0:	854a                	mv	a0,s2
  a2:	324000ef          	jal	3c6 <close>

  printf("read\n");
  a6:	00001517          	auipc	a0,0x1
  aa:	9d250513          	addi	a0,a0,-1582 # a78 <statistics+0xa0>
  ae:	780000ef          	jal	82e <printf>

  fd = open(path, O_RDONLY);
  b2:	4581                	li	a1,0
  b4:	fc040513          	addi	a0,s0,-64
  b8:	326000ef          	jal	3de <open>
  bc:	892a                	mv	s2,a0
  be:	44d1                	li	s1,20
  for (i = 0; i < 20; i++)
    read(fd, data, sizeof(data));
  c0:	dc040a13          	addi	s4,s0,-576
  c4:	20000993          	li	s3,512
  c8:	864e                	mv	a2,s3
  ca:	85d2                	mv	a1,s4
  cc:	854a                	mv	a0,s2
  ce:	2e8000ef          	jal	3b6 <read>
  for (i = 0; i < 20; i++)
  d2:	34fd                	addiw	s1,s1,-1
  d4:	f8f5                	bnez	s1,c8 <main+0xc8>
  close(fd);
  d6:	854a                	mv	a0,s2
  d8:	2ee000ef          	jal	3c6 <close>

  wait(0);
  dc:	4501                	li	a0,0
  de:	2c8000ef          	jal	3a6 <wait>

  exit(0);
  e2:	4501                	li	a0,0
  e4:	2ba000ef          	jal	39e <exit>

00000000000000e8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  e8:	1141                	addi	sp,sp,-16
  ea:	e406                	sd	ra,8(sp)
  ec:	e022                	sd	s0,0(sp)
  ee:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  f0:	f11ff0ef          	jal	0 <main>
  exit(r);
  f4:	2aa000ef          	jal	39e <exit>

00000000000000f8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  f8:	1141                	addi	sp,sp,-16
  fa:	e406                	sd	ra,8(sp)
  fc:	e022                	sd	s0,0(sp)
  fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 100:	87aa                	mv	a5,a0
 102:	0585                	addi	a1,a1,1
 104:	0785                	addi	a5,a5,1
 106:	fff5c703          	lbu	a4,-1(a1)
 10a:	fee78fa3          	sb	a4,-1(a5)
 10e:	fb75                	bnez	a4,102 <strcpy+0xa>
    ;
  return os;
}
 110:	60a2                	ld	ra,8(sp)
 112:	6402                	ld	s0,0(sp)
 114:	0141                	addi	sp,sp,16
 116:	8082                	ret

0000000000000118 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 118:	1141                	addi	sp,sp,-16
 11a:	e406                	sd	ra,8(sp)
 11c:	e022                	sd	s0,0(sp)
 11e:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 120:	00054783          	lbu	a5,0(a0)
 124:	cb91                	beqz	a5,138 <strcmp+0x20>
 126:	0005c703          	lbu	a4,0(a1)
 12a:	00f71763          	bne	a4,a5,138 <strcmp+0x20>
    p++, q++;
 12e:	0505                	addi	a0,a0,1
 130:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 132:	00054783          	lbu	a5,0(a0)
 136:	fbe5                	bnez	a5,126 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 138:	0005c503          	lbu	a0,0(a1)
}
 13c:	40a7853b          	subw	a0,a5,a0
 140:	60a2                	ld	ra,8(sp)
 142:	6402                	ld	s0,0(sp)
 144:	0141                	addi	sp,sp,16
 146:	8082                	ret

0000000000000148 <strlen>:

uint
strlen(const char *s)
{
 148:	1141                	addi	sp,sp,-16
 14a:	e406                	sd	ra,8(sp)
 14c:	e022                	sd	s0,0(sp)
 14e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 150:	00054783          	lbu	a5,0(a0)
 154:	cf91                	beqz	a5,170 <strlen+0x28>
 156:	00150793          	addi	a5,a0,1
 15a:	86be                	mv	a3,a5
 15c:	0785                	addi	a5,a5,1
 15e:	fff7c703          	lbu	a4,-1(a5)
 162:	ff65                	bnez	a4,15a <strlen+0x12>
 164:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 168:	60a2                	ld	ra,8(sp)
 16a:	6402                	ld	s0,0(sp)
 16c:	0141                	addi	sp,sp,16
 16e:	8082                	ret
  for(n = 0; s[n]; n++)
 170:	4501                	li	a0,0
 172:	bfdd                	j	168 <strlen+0x20>

0000000000000174 <memset>:

void*
memset(void *dst, int c, uint n)
{
 174:	1141                	addi	sp,sp,-16
 176:	e406                	sd	ra,8(sp)
 178:	e022                	sd	s0,0(sp)
 17a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 17c:	ca19                	beqz	a2,192 <memset+0x1e>
 17e:	87aa                	mv	a5,a0
 180:	1602                	slli	a2,a2,0x20
 182:	9201                	srli	a2,a2,0x20
 184:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 188:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 18c:	0785                	addi	a5,a5,1
 18e:	fee79de3          	bne	a5,a4,188 <memset+0x14>
  }
  return dst;
}
 192:	60a2                	ld	ra,8(sp)
 194:	6402                	ld	s0,0(sp)
 196:	0141                	addi	sp,sp,16
 198:	8082                	ret

000000000000019a <strchr>:

char*
strchr(const char *s, char c)
{
 19a:	1141                	addi	sp,sp,-16
 19c:	e406                	sd	ra,8(sp)
 19e:	e022                	sd	s0,0(sp)
 1a0:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1a2:	00054783          	lbu	a5,0(a0)
 1a6:	cf81                	beqz	a5,1be <strchr+0x24>
    if(*s == c)
 1a8:	00f58763          	beq	a1,a5,1b6 <strchr+0x1c>
  for(; *s; s++)
 1ac:	0505                	addi	a0,a0,1
 1ae:	00054783          	lbu	a5,0(a0)
 1b2:	fbfd                	bnez	a5,1a8 <strchr+0xe>
      return (char*)s;
  return 0;
 1b4:	4501                	li	a0,0
}
 1b6:	60a2                	ld	ra,8(sp)
 1b8:	6402                	ld	s0,0(sp)
 1ba:	0141                	addi	sp,sp,16
 1bc:	8082                	ret
  return 0;
 1be:	4501                	li	a0,0
 1c0:	bfdd                	j	1b6 <strchr+0x1c>

00000000000001c2 <gets>:

char*
gets(char *buf, int max)
{
 1c2:	711d                	addi	sp,sp,-96
 1c4:	ec86                	sd	ra,88(sp)
 1c6:	e8a2                	sd	s0,80(sp)
 1c8:	e4a6                	sd	s1,72(sp)
 1ca:	e0ca                	sd	s2,64(sp)
 1cc:	fc4e                	sd	s3,56(sp)
 1ce:	f852                	sd	s4,48(sp)
 1d0:	f456                	sd	s5,40(sp)
 1d2:	f05a                	sd	s6,32(sp)
 1d4:	ec5e                	sd	s7,24(sp)
 1d6:	e862                	sd	s8,16(sp)
 1d8:	1080                	addi	s0,sp,96
 1da:	8baa                	mv	s7,a0
 1dc:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1de:	892a                	mv	s2,a0
 1e0:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1e2:	faf40b13          	addi	s6,s0,-81
 1e6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1e8:	8c26                	mv	s8,s1
 1ea:	0014899b          	addiw	s3,s1,1
 1ee:	84ce                	mv	s1,s3
 1f0:	0349d463          	bge	s3,s4,218 <gets+0x56>
    cc = read(0, &c, 1);
 1f4:	8656                	mv	a2,s5
 1f6:	85da                	mv	a1,s6
 1f8:	4501                	li	a0,0
 1fa:	1bc000ef          	jal	3b6 <read>
    if(cc < 1)
 1fe:	00a05d63          	blez	a0,218 <gets+0x56>
      break;
    buf[i++] = c;
 202:	faf44783          	lbu	a5,-81(s0)
 206:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 20a:	0905                	addi	s2,s2,1
 20c:	ff678713          	addi	a4,a5,-10
 210:	c319                	beqz	a4,216 <gets+0x54>
 212:	17cd                	addi	a5,a5,-13
 214:	fbf1                	bnez	a5,1e8 <gets+0x26>
    buf[i++] = c;
 216:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 218:	9c5e                	add	s8,s8,s7
 21a:	000c0023          	sb	zero,0(s8)
  return buf;
}
 21e:	855e                	mv	a0,s7
 220:	60e6                	ld	ra,88(sp)
 222:	6446                	ld	s0,80(sp)
 224:	64a6                	ld	s1,72(sp)
 226:	6906                	ld	s2,64(sp)
 228:	79e2                	ld	s3,56(sp)
 22a:	7a42                	ld	s4,48(sp)
 22c:	7aa2                	ld	s5,40(sp)
 22e:	7b02                	ld	s6,32(sp)
 230:	6be2                	ld	s7,24(sp)
 232:	6c42                	ld	s8,16(sp)
 234:	6125                	addi	sp,sp,96
 236:	8082                	ret

0000000000000238 <stat>:

int
stat(const char *n, struct stat *st)
{
 238:	1101                	addi	sp,sp,-32
 23a:	ec06                	sd	ra,24(sp)
 23c:	e822                	sd	s0,16(sp)
 23e:	e04a                	sd	s2,0(sp)
 240:	1000                	addi	s0,sp,32
 242:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 244:	4581                	li	a1,0
 246:	198000ef          	jal	3de <open>
  if(fd < 0)
 24a:	02054263          	bltz	a0,26e <stat+0x36>
 24e:	e426                	sd	s1,8(sp)
 250:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 252:	85ca                	mv	a1,s2
 254:	1a2000ef          	jal	3f6 <fstat>
 258:	892a                	mv	s2,a0
  close(fd);
 25a:	8526                	mv	a0,s1
 25c:	16a000ef          	jal	3c6 <close>
  return r;
 260:	64a2                	ld	s1,8(sp)
}
 262:	854a                	mv	a0,s2
 264:	60e2                	ld	ra,24(sp)
 266:	6442                	ld	s0,16(sp)
 268:	6902                	ld	s2,0(sp)
 26a:	6105                	addi	sp,sp,32
 26c:	8082                	ret
    return -1;
 26e:	57fd                	li	a5,-1
 270:	893e                	mv	s2,a5
 272:	bfc5                	j	262 <stat+0x2a>

0000000000000274 <atoi>:

int
atoi(const char *s)
{
 274:	1141                	addi	sp,sp,-16
 276:	e406                	sd	ra,8(sp)
 278:	e022                	sd	s0,0(sp)
 27a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 27c:	00054683          	lbu	a3,0(a0)
 280:	fd06879b          	addiw	a5,a3,-48
 284:	0ff7f793          	zext.b	a5,a5
 288:	4625                	li	a2,9
 28a:	02f66963          	bltu	a2,a5,2bc <atoi+0x48>
 28e:	872a                	mv	a4,a0
  n = 0;
 290:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 292:	0705                	addi	a4,a4,1
 294:	0025179b          	slliw	a5,a0,0x2
 298:	9fa9                	addw	a5,a5,a0
 29a:	0017979b          	slliw	a5,a5,0x1
 29e:	9fb5                	addw	a5,a5,a3
 2a0:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2a4:	00074683          	lbu	a3,0(a4)
 2a8:	fd06879b          	addiw	a5,a3,-48
 2ac:	0ff7f793          	zext.b	a5,a5
 2b0:	fef671e3          	bgeu	a2,a5,292 <atoi+0x1e>
  return n;
}
 2b4:	60a2                	ld	ra,8(sp)
 2b6:	6402                	ld	s0,0(sp)
 2b8:	0141                	addi	sp,sp,16
 2ba:	8082                	ret
  n = 0;
 2bc:	4501                	li	a0,0
 2be:	bfdd                	j	2b4 <atoi+0x40>

00000000000002c0 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2c0:	1141                	addi	sp,sp,-16
 2c2:	e406                	sd	ra,8(sp)
 2c4:	e022                	sd	s0,0(sp)
 2c6:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2c8:	02b57563          	bgeu	a0,a1,2f2 <memmove+0x32>
    while(n-- > 0)
 2cc:	00c05f63          	blez	a2,2ea <memmove+0x2a>
 2d0:	1602                	slli	a2,a2,0x20
 2d2:	9201                	srli	a2,a2,0x20
 2d4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2d8:	872a                	mv	a4,a0
      *dst++ = *src++;
 2da:	0585                	addi	a1,a1,1
 2dc:	0705                	addi	a4,a4,1
 2de:	fff5c683          	lbu	a3,-1(a1)
 2e2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2e6:	fee79ae3          	bne	a5,a4,2da <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
    while(n-- > 0)
 2f2:	fec05ce3          	blez	a2,2ea <memmove+0x2a>
    dst += n;
 2f6:	00c50733          	add	a4,a0,a2
    src += n;
 2fa:	95b2                	add	a1,a1,a2
 2fc:	fff6079b          	addiw	a5,a2,-1
 300:	1782                	slli	a5,a5,0x20
 302:	9381                	srli	a5,a5,0x20
 304:	fff7c793          	not	a5,a5
 308:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 30a:	15fd                	addi	a1,a1,-1
 30c:	177d                	addi	a4,a4,-1
 30e:	0005c683          	lbu	a3,0(a1)
 312:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 316:	fef71ae3          	bne	a4,a5,30a <memmove+0x4a>
 31a:	bfc1                	j	2ea <memmove+0x2a>

000000000000031c <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 31c:	1141                	addi	sp,sp,-16
 31e:	e406                	sd	ra,8(sp)
 320:	e022                	sd	s0,0(sp)
 322:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 324:	c61d                	beqz	a2,352 <memcmp+0x36>
 326:	1602                	slli	a2,a2,0x20
 328:	9201                	srli	a2,a2,0x20
 32a:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 32e:	00054783          	lbu	a5,0(a0)
 332:	0005c703          	lbu	a4,0(a1)
 336:	00e79863          	bne	a5,a4,346 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 33a:	0505                	addi	a0,a0,1
    p2++;
 33c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 33e:	fed518e3          	bne	a0,a3,32e <memcmp+0x12>
  }
  return 0;
 342:	4501                	li	a0,0
 344:	a019                	j	34a <memcmp+0x2e>
      return *p1 - *p2;
 346:	40e7853b          	subw	a0,a5,a4
}
 34a:	60a2                	ld	ra,8(sp)
 34c:	6402                	ld	s0,0(sp)
 34e:	0141                	addi	sp,sp,16
 350:	8082                	ret
  return 0;
 352:	4501                	li	a0,0
 354:	bfdd                	j	34a <memcmp+0x2e>

0000000000000356 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 356:	1141                	addi	sp,sp,-16
 358:	e406                	sd	ra,8(sp)
 35a:	e022                	sd	s0,0(sp)
 35c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 35e:	f63ff0ef          	jal	2c0 <memmove>
}
 362:	60a2                	ld	ra,8(sp)
 364:	6402                	ld	s0,0(sp)
 366:	0141                	addi	sp,sp,16
 368:	8082                	ret

000000000000036a <sbrk>:

char *
sbrk(int n) {
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 372:	4585                	li	a1,1
 374:	0b2000ef          	jal	426 <sys_sbrk>
}
 378:	60a2                	ld	ra,8(sp)
 37a:	6402                	ld	s0,0(sp)
 37c:	0141                	addi	sp,sp,16
 37e:	8082                	ret

0000000000000380 <sbrklazy>:

char *
sbrklazy(int n) {
 380:	1141                	addi	sp,sp,-16
 382:	e406                	sd	ra,8(sp)
 384:	e022                	sd	s0,0(sp)
 386:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 388:	4589                	li	a1,2
 38a:	09c000ef          	jal	426 <sys_sbrk>
}
 38e:	60a2                	ld	ra,8(sp)
 390:	6402                	ld	s0,0(sp)
 392:	0141                	addi	sp,sp,16
 394:	8082                	ret

0000000000000396 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 396:	4885                	li	a7,1
 ecall
 398:	00000073          	ecall
 ret
 39c:	8082                	ret

000000000000039e <exit>:
.global exit
exit:
 li a7, SYS_exit
 39e:	4889                	li	a7,2
 ecall
 3a0:	00000073          	ecall
 ret
 3a4:	8082                	ret

00000000000003a6 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3a6:	488d                	li	a7,3
 ecall
 3a8:	00000073          	ecall
 ret
 3ac:	8082                	ret

00000000000003ae <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3ae:	4891                	li	a7,4
 ecall
 3b0:	00000073          	ecall
 ret
 3b4:	8082                	ret

00000000000003b6 <read>:
.global read
read:
 li a7, SYS_read
 3b6:	4895                	li	a7,5
 ecall
 3b8:	00000073          	ecall
 ret
 3bc:	8082                	ret

00000000000003be <write>:
.global write
write:
 li a7, SYS_write
 3be:	48c1                	li	a7,16
 ecall
 3c0:	00000073          	ecall
 ret
 3c4:	8082                	ret

00000000000003c6 <close>:
.global close
close:
 li a7, SYS_close
 3c6:	48d5                	li	a7,21
 ecall
 3c8:	00000073          	ecall
 ret
 3cc:	8082                	ret

00000000000003ce <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ce:	4899                	li	a7,6
 ecall
 3d0:	00000073          	ecall
 ret
 3d4:	8082                	ret

00000000000003d6 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3d6:	489d                	li	a7,7
 ecall
 3d8:	00000073          	ecall
 ret
 3dc:	8082                	ret

00000000000003de <open>:
.global open
open:
 li a7, SYS_open
 3de:	48bd                	li	a7,15
 ecall
 3e0:	00000073          	ecall
 ret
 3e4:	8082                	ret

00000000000003e6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3e6:	48c5                	li	a7,17
 ecall
 3e8:	00000073          	ecall
 ret
 3ec:	8082                	ret

00000000000003ee <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3ee:	48c9                	li	a7,18
 ecall
 3f0:	00000073          	ecall
 ret
 3f4:	8082                	ret

00000000000003f6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3f6:	48a1                	li	a7,8
 ecall
 3f8:	00000073          	ecall
 ret
 3fc:	8082                	ret

00000000000003fe <link>:
.global link
link:
 li a7, SYS_link
 3fe:	48cd                	li	a7,19
 ecall
 400:	00000073          	ecall
 ret
 404:	8082                	ret

0000000000000406 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 406:	48d1                	li	a7,20
 ecall
 408:	00000073          	ecall
 ret
 40c:	8082                	ret

000000000000040e <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 40e:	48a5                	li	a7,9
 ecall
 410:	00000073          	ecall
 ret
 414:	8082                	ret

0000000000000416 <dup>:
.global dup
dup:
 li a7, SYS_dup
 416:	48a9                	li	a7,10
 ecall
 418:	00000073          	ecall
 ret
 41c:	8082                	ret

000000000000041e <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 41e:	48ad                	li	a7,11
 ecall
 420:	00000073          	ecall
 ret
 424:	8082                	ret

0000000000000426 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 426:	48b1                	li	a7,12
 ecall
 428:	00000073          	ecall
 ret
 42c:	8082                	ret

000000000000042e <pause>:
.global pause
pause:
 li a7, SYS_pause
 42e:	48b5                	li	a7,13
 ecall
 430:	00000073          	ecall
 ret
 434:	8082                	ret

0000000000000436 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 436:	48b9                	li	a7,14
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <bind>:
.global bind
bind:
 li a7, SYS_bind
 43e:	48f5                	li	a7,29
 ecall
 440:	00000073          	ecall
 ret
 444:	8082                	ret

0000000000000446 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 446:	48f9                	li	a7,30
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <send>:
.global send
send:
 li a7, SYS_send
 44e:	48fd                	li	a7,31
 ecall
 450:	00000073          	ecall
 ret
 454:	8082                	ret

0000000000000456 <recv>:
.global recv
recv:
 li a7, SYS_recv
 456:	02000893          	li	a7,32
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 460:	02100893          	li	a7,33
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 46a:	02200893          	li	a7,34
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 474:	02300893          	li	a7,35
 ecall
 478:	00000073          	ecall
 ret
 47c:	8082                	ret

000000000000047e <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 47e:	02400893          	li	a7,36
 ecall
 482:	00000073          	ecall
 ret
 486:	8082                	ret

0000000000000488 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 488:	1101                	addi	sp,sp,-32
 48a:	ec06                	sd	ra,24(sp)
 48c:	e822                	sd	s0,16(sp)
 48e:	1000                	addi	s0,sp,32
 490:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 494:	4605                	li	a2,1
 496:	fef40593          	addi	a1,s0,-17
 49a:	f25ff0ef          	jal	3be <write>
}
 49e:	60e2                	ld	ra,24(sp)
 4a0:	6442                	ld	s0,16(sp)
 4a2:	6105                	addi	sp,sp,32
 4a4:	8082                	ret

00000000000004a6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4a6:	715d                	addi	sp,sp,-80
 4a8:	e486                	sd	ra,72(sp)
 4aa:	e0a2                	sd	s0,64(sp)
 4ac:	f84a                	sd	s2,48(sp)
 4ae:	f44e                	sd	s3,40(sp)
 4b0:	0880                	addi	s0,sp,80
 4b2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4b4:	c6d1                	beqz	a3,540 <printint+0x9a>
 4b6:	0805d563          	bgez	a1,540 <printint+0x9a>
    neg = 1;
    x = -xx;
 4ba:	40b005b3          	neg	a1,a1
    neg = 1;
 4be:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4c0:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4c4:	86ce                	mv	a3,s3
  i = 0;
 4c6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4c8:	00000817          	auipc	a6,0x0
 4cc:	5f880813          	addi	a6,a6,1528 # ac0 <digits>
 4d0:	88ba                	mv	a7,a4
 4d2:	0017051b          	addiw	a0,a4,1
 4d6:	872a                	mv	a4,a0
 4d8:	02c5f7b3          	remu	a5,a1,a2
 4dc:	97c2                	add	a5,a5,a6
 4de:	0007c783          	lbu	a5,0(a5)
 4e2:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4e6:	87ae                	mv	a5,a1
 4e8:	02c5d5b3          	divu	a1,a1,a2
 4ec:	0685                	addi	a3,a3,1
 4ee:	fec7f1e3          	bgeu	a5,a2,4d0 <printint+0x2a>
  if(neg)
 4f2:	00030c63          	beqz	t1,50a <printint+0x64>
    buf[i++] = '-';
 4f6:	fd050793          	addi	a5,a0,-48
 4fa:	00878533          	add	a0,a5,s0
 4fe:	02d00793          	li	a5,45
 502:	fef50423          	sb	a5,-24(a0)
 506:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 50a:	02e05563          	blez	a4,534 <printint+0x8e>
 50e:	fc26                	sd	s1,56(sp)
 510:	377d                	addiw	a4,a4,-1
 512:	00e984b3          	add	s1,s3,a4
 516:	19fd                	addi	s3,s3,-1
 518:	99ba                	add	s3,s3,a4
 51a:	1702                	slli	a4,a4,0x20
 51c:	9301                	srli	a4,a4,0x20
 51e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 522:	0004c583          	lbu	a1,0(s1)
 526:	854a                	mv	a0,s2
 528:	f61ff0ef          	jal	488 <putc>
  while(--i >= 0)
 52c:	14fd                	addi	s1,s1,-1
 52e:	ff349ae3          	bne	s1,s3,522 <printint+0x7c>
 532:	74e2                	ld	s1,56(sp)
}
 534:	60a6                	ld	ra,72(sp)
 536:	6406                	ld	s0,64(sp)
 538:	7942                	ld	s2,48(sp)
 53a:	79a2                	ld	s3,40(sp)
 53c:	6161                	addi	sp,sp,80
 53e:	8082                	ret
  neg = 0;
 540:	4301                	li	t1,0
 542:	bfbd                	j	4c0 <printint+0x1a>

0000000000000544 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 544:	711d                	addi	sp,sp,-96
 546:	ec86                	sd	ra,88(sp)
 548:	e8a2                	sd	s0,80(sp)
 54a:	e4a6                	sd	s1,72(sp)
 54c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 54e:	0005c483          	lbu	s1,0(a1)
 552:	22048363          	beqz	s1,778 <vprintf+0x234>
 556:	e0ca                	sd	s2,64(sp)
 558:	fc4e                	sd	s3,56(sp)
 55a:	f852                	sd	s4,48(sp)
 55c:	f456                	sd	s5,40(sp)
 55e:	f05a                	sd	s6,32(sp)
 560:	ec5e                	sd	s7,24(sp)
 562:	e862                	sd	s8,16(sp)
 564:	8b2a                	mv	s6,a0
 566:	8a2e                	mv	s4,a1
 568:	8bb2                	mv	s7,a2
  state = 0;
 56a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 56c:	4901                	li	s2,0
 56e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 570:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 574:	06400c13          	li	s8,100
 578:	a00d                	j	59a <vprintf+0x56>
        putc(fd, c0);
 57a:	85a6                	mv	a1,s1
 57c:	855a                	mv	a0,s6
 57e:	f0bff0ef          	jal	488 <putc>
 582:	a019                	j	588 <vprintf+0x44>
    } else if(state == '%'){
 584:	03598363          	beq	s3,s5,5aa <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 588:	0019079b          	addiw	a5,s2,1
 58c:	893e                	mv	s2,a5
 58e:	873e                	mv	a4,a5
 590:	97d2                	add	a5,a5,s4
 592:	0007c483          	lbu	s1,0(a5)
 596:	1c048a63          	beqz	s1,76a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 59a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 59e:	fe0993e3          	bnez	s3,584 <vprintf+0x40>
      if(c0 == '%'){
 5a2:	fd579ce3          	bne	a5,s5,57a <vprintf+0x36>
        state = '%';
 5a6:	89be                	mv	s3,a5
 5a8:	b7c5                	j	588 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5aa:	00ea06b3          	add	a3,s4,a4
 5ae:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5b2:	1c060863          	beqz	a2,782 <vprintf+0x23e>
      if(c0 == 'd'){
 5b6:	03878763          	beq	a5,s8,5e4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5ba:	f9478693          	addi	a3,a5,-108
 5be:	0016b693          	seqz	a3,a3
 5c2:	f9c60593          	addi	a1,a2,-100
 5c6:	e99d                	bnez	a1,5fc <vprintf+0xb8>
 5c8:	ca95                	beqz	a3,5fc <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ca:	008b8493          	addi	s1,s7,8
 5ce:	4685                	li	a3,1
 5d0:	4629                	li	a2,10
 5d2:	000bb583          	ld	a1,0(s7)
 5d6:	855a                	mv	a0,s6
 5d8:	ecfff0ef          	jal	4a6 <printint>
        i += 1;
 5dc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5de:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5e0:	4981                	li	s3,0
 5e2:	b75d                	j	588 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000ba583          	lw	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	eb5ff0ef          	jal	4a6 <printint>
 5f6:	8ba6                	mv	s7,s1
      state = 0;
 5f8:	4981                	li	s3,0
 5fa:	b779                	j	588 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5fc:	9752                	add	a4,a4,s4
 5fe:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 602:	f9460713          	addi	a4,a2,-108
 606:	00173713          	seqz	a4,a4
 60a:	8f75                	and	a4,a4,a3
 60c:	f9c58513          	addi	a0,a1,-100
 610:	18051363          	bnez	a0,796 <vprintf+0x252>
 614:	18070163          	beqz	a4,796 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 618:	008b8493          	addi	s1,s7,8
 61c:	4685                	li	a3,1
 61e:	4629                	li	a2,10
 620:	000bb583          	ld	a1,0(s7)
 624:	855a                	mv	a0,s6
 626:	e81ff0ef          	jal	4a6 <printint>
        i += 2;
 62a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 62c:	8ba6                	mv	s7,s1
      state = 0;
 62e:	4981                	li	s3,0
        i += 2;
 630:	bfa1                	j	588 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 632:	008b8493          	addi	s1,s7,8
 636:	4681                	li	a3,0
 638:	4629                	li	a2,10
 63a:	000be583          	lwu	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	e67ff0ef          	jal	4a6 <printint>
 644:	8ba6                	mv	s7,s1
      state = 0;
 646:	4981                	li	s3,0
 648:	b781                	j	588 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 64a:	008b8493          	addi	s1,s7,8
 64e:	4681                	li	a3,0
 650:	4629                	li	a2,10
 652:	000bb583          	ld	a1,0(s7)
 656:	855a                	mv	a0,s6
 658:	e4fff0ef          	jal	4a6 <printint>
        i += 1;
 65c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 65e:	8ba6                	mv	s7,s1
      state = 0;
 660:	4981                	li	s3,0
 662:	b71d                	j	588 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 664:	008b8493          	addi	s1,s7,8
 668:	4681                	li	a3,0
 66a:	4629                	li	a2,10
 66c:	000bb583          	ld	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	e35ff0ef          	jal	4a6 <printint>
        i += 2;
 676:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	8ba6                	mv	s7,s1
      state = 0;
 67a:	4981                	li	s3,0
        i += 2;
 67c:	b731                	j	588 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 67e:	008b8493          	addi	s1,s7,8
 682:	4681                	li	a3,0
 684:	4641                	li	a2,16
 686:	000be583          	lwu	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	e1bff0ef          	jal	4a6 <printint>
 690:	8ba6                	mv	s7,s1
      state = 0;
 692:	4981                	li	s3,0
 694:	bdd5                	j	588 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 696:	008b8493          	addi	s1,s7,8
 69a:	4681                	li	a3,0
 69c:	4641                	li	a2,16
 69e:	000bb583          	ld	a1,0(s7)
 6a2:	855a                	mv	a0,s6
 6a4:	e03ff0ef          	jal	4a6 <printint>
        i += 1;
 6a8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6aa:	8ba6                	mv	s7,s1
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bde9                	j	588 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b0:	008b8493          	addi	s1,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4641                	li	a2,16
 6b8:	000bb583          	ld	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	de9ff0ef          	jal	4a6 <printint>
        i += 2;
 6c2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c4:	8ba6                	mv	s7,s1
      state = 0;
 6c6:	4981                	li	s3,0
        i += 2;
 6c8:	b5c1                	j	588 <vprintf+0x44>
 6ca:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6cc:	008b8793          	addi	a5,s7,8
 6d0:	8cbe                	mv	s9,a5
 6d2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6d6:	03000593          	li	a1,48
 6da:	855a                	mv	a0,s6
 6dc:	dadff0ef          	jal	488 <putc>
  putc(fd, 'x');
 6e0:	07800593          	li	a1,120
 6e4:	855a                	mv	a0,s6
 6e6:	da3ff0ef          	jal	488 <putc>
 6ea:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6ec:	00000b97          	auipc	s7,0x0
 6f0:	3d4b8b93          	addi	s7,s7,980 # ac0 <digits>
 6f4:	03c9d793          	srli	a5,s3,0x3c
 6f8:	97de                	add	a5,a5,s7
 6fa:	0007c583          	lbu	a1,0(a5)
 6fe:	855a                	mv	a0,s6
 700:	d89ff0ef          	jal	488 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 704:	0992                	slli	s3,s3,0x4
 706:	34fd                	addiw	s1,s1,-1
 708:	f4f5                	bnez	s1,6f4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 70a:	8be6                	mv	s7,s9
      state = 0;
 70c:	4981                	li	s3,0
 70e:	6ca2                	ld	s9,8(sp)
 710:	bda5                	j	588 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 712:	008b8493          	addi	s1,s7,8
 716:	000bc583          	lbu	a1,0(s7)
 71a:	855a                	mv	a0,s6
 71c:	d6dff0ef          	jal	488 <putc>
 720:	8ba6                	mv	s7,s1
      state = 0;
 722:	4981                	li	s3,0
 724:	b595                	j	588 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 726:	008b8993          	addi	s3,s7,8
 72a:	000bb483          	ld	s1,0(s7)
 72e:	cc91                	beqz	s1,74a <vprintf+0x206>
        for(; *s; s++)
 730:	0004c583          	lbu	a1,0(s1)
 734:	c985                	beqz	a1,764 <vprintf+0x220>
          putc(fd, *s);
 736:	855a                	mv	a0,s6
 738:	d51ff0ef          	jal	488 <putc>
        for(; *s; s++)
 73c:	0485                	addi	s1,s1,1
 73e:	0004c583          	lbu	a1,0(s1)
 742:	f9f5                	bnez	a1,736 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 744:	8bce                	mv	s7,s3
      state = 0;
 746:	4981                	li	s3,0
 748:	b581                	j	588 <vprintf+0x44>
          s = "(null)";
 74a:	00000497          	auipc	s1,0x0
 74e:	34648493          	addi	s1,s1,838 # a90 <statistics+0xb8>
        for(; *s; s++)
 752:	02800593          	li	a1,40
 756:	b7c5                	j	736 <vprintf+0x1f2>
        putc(fd, '%');
 758:	85be                	mv	a1,a5
 75a:	855a                	mv	a0,s6
 75c:	d2dff0ef          	jal	488 <putc>
      state = 0;
 760:	4981                	li	s3,0
 762:	b51d                	j	588 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 764:	8bce                	mv	s7,s3
      state = 0;
 766:	4981                	li	s3,0
 768:	b505                	j	588 <vprintf+0x44>
 76a:	6906                	ld	s2,64(sp)
 76c:	79e2                	ld	s3,56(sp)
 76e:	7a42                	ld	s4,48(sp)
 770:	7aa2                	ld	s5,40(sp)
 772:	7b02                	ld	s6,32(sp)
 774:	6be2                	ld	s7,24(sp)
 776:	6c42                	ld	s8,16(sp)
    }
  }
}
 778:	60e6                	ld	ra,88(sp)
 77a:	6446                	ld	s0,80(sp)
 77c:	64a6                	ld	s1,72(sp)
 77e:	6125                	addi	sp,sp,96
 780:	8082                	ret
      if(c0 == 'd'){
 782:	06400713          	li	a4,100
 786:	e4e78fe3          	beq	a5,a4,5e4 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 78a:	f9478693          	addi	a3,a5,-108
 78e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 792:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 794:	4701                	li	a4,0
      } else if(c0 == 'u'){
 796:	07500513          	li	a0,117
 79a:	e8a78ce3          	beq	a5,a0,632 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 79e:	f8b60513          	addi	a0,a2,-117
 7a2:	e119                	bnez	a0,7a8 <vprintf+0x264>
 7a4:	ea0693e3          	bnez	a3,64a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7a8:	f8b58513          	addi	a0,a1,-117
 7ac:	e119                	bnez	a0,7b2 <vprintf+0x26e>
 7ae:	ea071be3          	bnez	a4,664 <vprintf+0x120>
      } else if(c0 == 'x'){
 7b2:	07800513          	li	a0,120
 7b6:	eca784e3          	beq	a5,a0,67e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7ba:	f8860613          	addi	a2,a2,-120
 7be:	e219                	bnez	a2,7c4 <vprintf+0x280>
 7c0:	ec069be3          	bnez	a3,696 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7c4:	f8858593          	addi	a1,a1,-120
 7c8:	e199                	bnez	a1,7ce <vprintf+0x28a>
 7ca:	ee0713e3          	bnez	a4,6b0 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7ce:	07000713          	li	a4,112
 7d2:	eee78ce3          	beq	a5,a4,6ca <vprintf+0x186>
      } else if(c0 == 'c'){
 7d6:	06300713          	li	a4,99
 7da:	f2e78ce3          	beq	a5,a4,712 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7de:	07300713          	li	a4,115
 7e2:	f4e782e3          	beq	a5,a4,726 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7e6:	02500713          	li	a4,37
 7ea:	f6e787e3          	beq	a5,a4,758 <vprintf+0x214>
        putc(fd, '%');
 7ee:	02500593          	li	a1,37
 7f2:	855a                	mv	a0,s6
 7f4:	c95ff0ef          	jal	488 <putc>
        putc(fd, c0);
 7f8:	85a6                	mv	a1,s1
 7fa:	855a                	mv	a0,s6
 7fc:	c8dff0ef          	jal	488 <putc>
      state = 0;
 800:	4981                	li	s3,0
 802:	b359                	j	588 <vprintf+0x44>

0000000000000804 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 804:	715d                	addi	sp,sp,-80
 806:	ec06                	sd	ra,24(sp)
 808:	e822                	sd	s0,16(sp)
 80a:	1000                	addi	s0,sp,32
 80c:	e010                	sd	a2,0(s0)
 80e:	e414                	sd	a3,8(s0)
 810:	e818                	sd	a4,16(s0)
 812:	ec1c                	sd	a5,24(s0)
 814:	03043023          	sd	a6,32(s0)
 818:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 81c:	8622                	mv	a2,s0
 81e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 822:	d23ff0ef          	jal	544 <vprintf>
}
 826:	60e2                	ld	ra,24(sp)
 828:	6442                	ld	s0,16(sp)
 82a:	6161                	addi	sp,sp,80
 82c:	8082                	ret

000000000000082e <printf>:

void
printf(const char *fmt, ...)
{
 82e:	711d                	addi	sp,sp,-96
 830:	ec06                	sd	ra,24(sp)
 832:	e822                	sd	s0,16(sp)
 834:	1000                	addi	s0,sp,32
 836:	e40c                	sd	a1,8(s0)
 838:	e810                	sd	a2,16(s0)
 83a:	ec14                	sd	a3,24(s0)
 83c:	f018                	sd	a4,32(s0)
 83e:	f41c                	sd	a5,40(s0)
 840:	03043823          	sd	a6,48(s0)
 844:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 848:	00840613          	addi	a2,s0,8
 84c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 850:	85aa                	mv	a1,a0
 852:	4505                	li	a0,1
 854:	cf1ff0ef          	jal	544 <vprintf>
}
 858:	60e2                	ld	ra,24(sp)
 85a:	6442                	ld	s0,16(sp)
 85c:	6125                	addi	sp,sp,96
 85e:	8082                	ret

0000000000000860 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 860:	1141                	addi	sp,sp,-16
 862:	e406                	sd	ra,8(sp)
 864:	e022                	sd	s0,0(sp)
 866:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 868:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 86c:	00000797          	auipc	a5,0x0
 870:	7947b783          	ld	a5,1940(a5) # 1000 <freep>
 874:	a039                	j	882 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 876:	6398                	ld	a4,0(a5)
 878:	00e7e463          	bltu	a5,a4,880 <free+0x20>
 87c:	00e6ea63          	bltu	a3,a4,890 <free+0x30>
{
 880:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 882:	fed7fae3          	bgeu	a5,a3,876 <free+0x16>
 886:	6398                	ld	a4,0(a5)
 888:	00e6e463          	bltu	a3,a4,890 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 88c:	fee7eae3          	bltu	a5,a4,880 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 890:	ff852583          	lw	a1,-8(a0)
 894:	6390                	ld	a2,0(a5)
 896:	02059813          	slli	a6,a1,0x20
 89a:	01c85713          	srli	a4,a6,0x1c
 89e:	9736                	add	a4,a4,a3
 8a0:	02e60563          	beq	a2,a4,8ca <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8a4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8a8:	4790                	lw	a2,8(a5)
 8aa:	02061593          	slli	a1,a2,0x20
 8ae:	01c5d713          	srli	a4,a1,0x1c
 8b2:	973e                	add	a4,a4,a5
 8b4:	02e68263          	beq	a3,a4,8d8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8b8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8ba:	00000717          	auipc	a4,0x0
 8be:	74f73323          	sd	a5,1862(a4) # 1000 <freep>
}
 8c2:	60a2                	ld	ra,8(sp)
 8c4:	6402                	ld	s0,0(sp)
 8c6:	0141                	addi	sp,sp,16
 8c8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8ca:	4618                	lw	a4,8(a2)
 8cc:	9f2d                	addw	a4,a4,a1
 8ce:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8d2:	6398                	ld	a4,0(a5)
 8d4:	6310                	ld	a2,0(a4)
 8d6:	b7f9                	j	8a4 <free+0x44>
    p->s.size += bp->s.size;
 8d8:	ff852703          	lw	a4,-8(a0)
 8dc:	9f31                	addw	a4,a4,a2
 8de:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8e0:	ff053683          	ld	a3,-16(a0)
 8e4:	bfd1                	j	8b8 <free+0x58>

00000000000008e6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8e6:	7139                	addi	sp,sp,-64
 8e8:	fc06                	sd	ra,56(sp)
 8ea:	f822                	sd	s0,48(sp)
 8ec:	f04a                	sd	s2,32(sp)
 8ee:	ec4e                	sd	s3,24(sp)
 8f0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8f2:	02051993          	slli	s3,a0,0x20
 8f6:	0209d993          	srli	s3,s3,0x20
 8fa:	09bd                	addi	s3,s3,15
 8fc:	0049d993          	srli	s3,s3,0x4
 900:	2985                	addiw	s3,s3,1
 902:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 904:	00000517          	auipc	a0,0x0
 908:	6fc53503          	ld	a0,1788(a0) # 1000 <freep>
 90c:	c905                	beqz	a0,93c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 90e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 910:	4798                	lw	a4,8(a5)
 912:	09377663          	bgeu	a4,s3,99e <malloc+0xb8>
 916:	f426                	sd	s1,40(sp)
 918:	e852                	sd	s4,16(sp)
 91a:	e456                	sd	s5,8(sp)
 91c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 91e:	8a4e                	mv	s4,s3
 920:	6705                	lui	a4,0x1
 922:	00e9f363          	bgeu	s3,a4,928 <malloc+0x42>
 926:	6a05                	lui	s4,0x1
 928:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 92c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 930:	00000497          	auipc	s1,0x0
 934:	6d048493          	addi	s1,s1,1744 # 1000 <freep>
  if(p == SBRK_ERROR)
 938:	5afd                	li	s5,-1
 93a:	a83d                	j	978 <malloc+0x92>
 93c:	f426                	sd	s1,40(sp)
 93e:	e852                	sd	s4,16(sp)
 940:	e456                	sd	s5,8(sp)
 942:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 944:	00000797          	auipc	a5,0x0
 948:	6cc78793          	addi	a5,a5,1740 # 1010 <base>
 94c:	00000717          	auipc	a4,0x0
 950:	6af73a23          	sd	a5,1716(a4) # 1000 <freep>
 954:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 956:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 95a:	b7d1                	j	91e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 95c:	6398                	ld	a4,0(a5)
 95e:	e118                	sd	a4,0(a0)
 960:	a899                	j	9b6 <malloc+0xd0>
  hp->s.size = nu;
 962:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 966:	0541                	addi	a0,a0,16
 968:	ef9ff0ef          	jal	860 <free>
  return freep;
 96c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 96e:	c125                	beqz	a0,9ce <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 970:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 972:	4798                	lw	a4,8(a5)
 974:	03277163          	bgeu	a4,s2,996 <malloc+0xb0>
    if(p == freep)
 978:	6098                	ld	a4,0(s1)
 97a:	853e                	mv	a0,a5
 97c:	fef71ae3          	bne	a4,a5,970 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 980:	8552                	mv	a0,s4
 982:	9e9ff0ef          	jal	36a <sbrk>
  if(p == SBRK_ERROR)
 986:	fd551ee3          	bne	a0,s5,962 <malloc+0x7c>
        return 0;
 98a:	4501                	li	a0,0
 98c:	74a2                	ld	s1,40(sp)
 98e:	6a42                	ld	s4,16(sp)
 990:	6aa2                	ld	s5,8(sp)
 992:	6b02                	ld	s6,0(sp)
 994:	a03d                	j	9c2 <malloc+0xdc>
 996:	74a2                	ld	s1,40(sp)
 998:	6a42                	ld	s4,16(sp)
 99a:	6aa2                	ld	s5,8(sp)
 99c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 99e:	fae90fe3          	beq	s2,a4,95c <malloc+0x76>
        p->s.size -= nunits;
 9a2:	4137073b          	subw	a4,a4,s3
 9a6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9a8:	02071693          	slli	a3,a4,0x20
 9ac:	01c6d713          	srli	a4,a3,0x1c
 9b0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9b2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9b6:	00000717          	auipc	a4,0x0
 9ba:	64a73523          	sd	a0,1610(a4) # 1000 <freep>
      return (void*)(p + 1);
 9be:	01078513          	addi	a0,a5,16
  }
}
 9c2:	70e2                	ld	ra,56(sp)
 9c4:	7442                	ld	s0,48(sp)
 9c6:	7902                	ld	s2,32(sp)
 9c8:	69e2                	ld	s3,24(sp)
 9ca:	6121                	addi	sp,sp,64
 9cc:	8082                	ret
 9ce:	74a2                	ld	s1,40(sp)
 9d0:	6a42                	ld	s4,16(sp)
 9d2:	6aa2                	ld	s5,8(sp)
 9d4:	6b02                	ld	s6,0(sp)
 9d6:	b7f5                	j	9c2 <malloc+0xdc>

00000000000009d8 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 9d8:	7179                	addi	sp,sp,-48
 9da:	f406                	sd	ra,40(sp)
 9dc:	f022                	sd	s0,32(sp)
 9de:	ec26                	sd	s1,24(sp)
 9e0:	e84a                	sd	s2,16(sp)
 9e2:	e44e                	sd	s3,8(sp)
 9e4:	e052                	sd	s4,0(sp)
 9e6:	1800                	addi	s0,sp,48
 9e8:	8a2a                	mv	s4,a0
 9ea:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 9ec:	4581                	li	a1,0
 9ee:	00000517          	auipc	a0,0x0
 9f2:	0aa50513          	addi	a0,a0,170 # a98 <statistics+0xc0>
 9f6:	9e9ff0ef          	jal	3de <open>
  if(fd < 0) {
 9fa:	02054e63          	bltz	a0,a36 <statistics+0x5e>
 9fe:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 a00:	4481                	li	s1,0
 a02:	01205e63          	blez	s2,a1e <statistics+0x46>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 a06:	4099063b          	subw	a2,s2,s1
 a0a:	009a05b3          	add	a1,s4,s1
 a0e:	854e                	mv	a0,s3
 a10:	9a7ff0ef          	jal	3b6 <read>
 a14:	00054563          	bltz	a0,a1e <statistics+0x46>
      break;
    }
    i += n;
 a18:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 a1a:	ff24c6e3          	blt	s1,s2,a06 <statistics+0x2e>
  }
  close(fd);
 a1e:	854e                	mv	a0,s3
 a20:	9a7ff0ef          	jal	3c6 <close>
  return i;
}
 a24:	8526                	mv	a0,s1
 a26:	70a2                	ld	ra,40(sp)
 a28:	7402                	ld	s0,32(sp)
 a2a:	64e2                	ld	s1,24(sp)
 a2c:	6942                	ld	s2,16(sp)
 a2e:	69a2                	ld	s3,8(sp)
 a30:	6a02                	ld	s4,0(sp)
 a32:	6145                	addi	sp,sp,48
 a34:	8082                	ret
      fprintf(2, "stats: open failed\n");
 a36:	00000597          	auipc	a1,0x0
 a3a:	07258593          	addi	a1,a1,114 # aa8 <statistics+0xd0>
 a3e:	4509                	li	a0,2
 a40:	dc5ff0ef          	jal	804 <fprintf>
      exit(1);
 a44:	4505                	li	a0,1
 a46:	959ff0ef          	jal	39e <exit>
