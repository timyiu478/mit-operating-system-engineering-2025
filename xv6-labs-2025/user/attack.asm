
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
   c:	e052                	sd	s4,0(sp)
   e:	1800                	addi	s0,sp,48
  // sbrk() to allocate memory may receive pages that have data in them from previous uses
  char *b = sbrk(DATASIZE);
  10:	6505                	lui	a0,0x1
  12:	2f2000ef          	jal	304 <sbrk>
  16:	84aa                	mv	s1,a0

  for (int i=0; i < DATASIZE; i++) {
  18:	6905                	lui	s2,0x1
  1a:	992a                	add	s2,s2,a0
    char *c = b + i;
    if (strcmp(c, "This may help.") == 0) {
  1c:	00001997          	auipc	s3,0x1
  20:	92498993          	addi	s3,s3,-1756 # 940 <malloc+0xfc>
  24:	a021                	j	2c <attack+0x2c>
  for (int i=0; i < DATASIZE; i++) {
  26:	0485                	addi	s1,s1,1
  28:	03248463          	beq	s1,s2,50 <attack+0x50>
    if (strcmp(c, "This may help.") == 0) {
  2c:	85ce                	mv	a1,s3
  2e:	8526                	mv	a0,s1
  30:	082000ef          	jal	b2 <strcmp>
  34:	f96d                	bnez	a0,26 <attack+0x26>
      c += 16;
  36:	01048a13          	addi	s4,s1,16
      if (strlen(c) > 0) {
  3a:	8552                	mv	a0,s4
  3c:	0a6000ef          	jal	e2 <strlen>
  40:	d17d                	beqz	a0,26 <attack+0x26>
        printf("%s\n", c);
  42:	85d2                	mv	a1,s4
  44:	00001517          	auipc	a0,0x1
  48:	90c50513          	addi	a0,a0,-1780 # 950 <malloc+0x10c>
  4c:	740000ef          	jal	78c <printf>
        return;
      }
    }
  }
}
  50:	70a2                	ld	ra,40(sp)
  52:	7402                	ld	s0,32(sp)
  54:	64e2                	ld	s1,24(sp)
  56:	6942                	ld	s2,16(sp)
  58:	69a2                	ld	s3,8(sp)
  5a:	6a02                	ld	s4,0(sp)
  5c:	6145                	addi	sp,sp,48
  5e:	8082                	ret

0000000000000060 <main>:

int
main(int argc, char *argv[])
{
  60:	1101                	addi	sp,sp,-32
  62:	ec06                	sd	ra,24(sp)
  64:	e822                	sd	s0,16(sp)
  66:	e426                	sd	s1,8(sp)
  68:	1000                	addi	s0,sp,32
  6a:	44d1                	li	s1,20
  for (int i=0; i < MAXATTEMPT; i++) {
    attack();
  6c:	f95ff0ef          	jal	0 <attack>
  for (int i=0; i < MAXATTEMPT; i++) {
  70:	34fd                	addiw	s1,s1,-1
  72:	fced                	bnez	s1,6c <main+0xc>
  }

  return 0;
}
  74:	4501                	li	a0,0
  76:	60e2                	ld	ra,24(sp)
  78:	6442                	ld	s0,16(sp)
  7a:	64a2                	ld	s1,8(sp)
  7c:	6105                	addi	sp,sp,32
  7e:	8082                	ret

0000000000000080 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  80:	1141                	addi	sp,sp,-16
  82:	e406                	sd	ra,8(sp)
  84:	e022                	sd	s0,0(sp)
  86:	0800                	addi	s0,sp,16
  extern int main();
  main();
  88:	fd9ff0ef          	jal	60 <main>
  exit(0);
  8c:	4501                	li	a0,0
  8e:	2aa000ef          	jal	338 <exit>

0000000000000092 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  92:	1141                	addi	sp,sp,-16
  94:	e406                	sd	ra,8(sp)
  96:	e022                	sd	s0,0(sp)
  98:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  9a:	87aa                	mv	a5,a0
  9c:	0585                	addi	a1,a1,1
  9e:	0785                	addi	a5,a5,1
  a0:	fff5c703          	lbu	a4,-1(a1)
  a4:	fee78fa3          	sb	a4,-1(a5)
  a8:	fb75                	bnez	a4,9c <strcpy+0xa>
    ;
  return os;
}
  aa:	60a2                	ld	ra,8(sp)
  ac:	6402                	ld	s0,0(sp)
  ae:	0141                	addi	sp,sp,16
  b0:	8082                	ret

00000000000000b2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  b2:	1141                	addi	sp,sp,-16
  b4:	e406                	sd	ra,8(sp)
  b6:	e022                	sd	s0,0(sp)
  b8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  ba:	00054783          	lbu	a5,0(a0)
  be:	cb91                	beqz	a5,d2 <strcmp+0x20>
  c0:	0005c703          	lbu	a4,0(a1)
  c4:	00f71763          	bne	a4,a5,d2 <strcmp+0x20>
    p++, q++;
  c8:	0505                	addi	a0,a0,1
  ca:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
  cc:	00054783          	lbu	a5,0(a0)
  d0:	fbe5                	bnez	a5,c0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
  d2:	0005c503          	lbu	a0,0(a1)
}
  d6:	40a7853b          	subw	a0,a5,a0
  da:	60a2                	ld	ra,8(sp)
  dc:	6402                	ld	s0,0(sp)
  de:	0141                	addi	sp,sp,16
  e0:	8082                	ret

00000000000000e2 <strlen>:

uint
strlen(const char *s)
{
  e2:	1141                	addi	sp,sp,-16
  e4:	e406                	sd	ra,8(sp)
  e6:	e022                	sd	s0,0(sp)
  e8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
  ea:	00054783          	lbu	a5,0(a0)
  ee:	cf91                	beqz	a5,10a <strlen+0x28>
  f0:	00150793          	addi	a5,a0,1
  f4:	86be                	mv	a3,a5
  f6:	0785                	addi	a5,a5,1
  f8:	fff7c703          	lbu	a4,-1(a5)
  fc:	ff65                	bnez	a4,f4 <strlen+0x12>
  fe:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 102:	60a2                	ld	ra,8(sp)
 104:	6402                	ld	s0,0(sp)
 106:	0141                	addi	sp,sp,16
 108:	8082                	ret
  for(n = 0; s[n]; n++)
 10a:	4501                	li	a0,0
 10c:	bfdd                	j	102 <strlen+0x20>

000000000000010e <memset>:

void*
memset(void *dst, int c, uint n)
{
 10e:	1141                	addi	sp,sp,-16
 110:	e406                	sd	ra,8(sp)
 112:	e022                	sd	s0,0(sp)
 114:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 116:	ca19                	beqz	a2,12c <memset+0x1e>
 118:	87aa                	mv	a5,a0
 11a:	1602                	slli	a2,a2,0x20
 11c:	9201                	srli	a2,a2,0x20
 11e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 122:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 126:	0785                	addi	a5,a5,1
 128:	fee79de3          	bne	a5,a4,122 <memset+0x14>
  }
  return dst;
}
 12c:	60a2                	ld	ra,8(sp)
 12e:	6402                	ld	s0,0(sp)
 130:	0141                	addi	sp,sp,16
 132:	8082                	ret

0000000000000134 <strchr>:

char*
strchr(const char *s, char c)
{
 134:	1141                	addi	sp,sp,-16
 136:	e406                	sd	ra,8(sp)
 138:	e022                	sd	s0,0(sp)
 13a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 13c:	00054783          	lbu	a5,0(a0)
 140:	cf81                	beqz	a5,158 <strchr+0x24>
    if(*s == c)
 142:	00f58763          	beq	a1,a5,150 <strchr+0x1c>
  for(; *s; s++)
 146:	0505                	addi	a0,a0,1
 148:	00054783          	lbu	a5,0(a0)
 14c:	fbfd                	bnez	a5,142 <strchr+0xe>
      return (char*)s;
  return 0;
 14e:	4501                	li	a0,0
}
 150:	60a2                	ld	ra,8(sp)
 152:	6402                	ld	s0,0(sp)
 154:	0141                	addi	sp,sp,16
 156:	8082                	ret
  return 0;
 158:	4501                	li	a0,0
 15a:	bfdd                	j	150 <strchr+0x1c>

000000000000015c <gets>:

char*
gets(char *buf, int max)
{
 15c:	711d                	addi	sp,sp,-96
 15e:	ec86                	sd	ra,88(sp)
 160:	e8a2                	sd	s0,80(sp)
 162:	e4a6                	sd	s1,72(sp)
 164:	e0ca                	sd	s2,64(sp)
 166:	fc4e                	sd	s3,56(sp)
 168:	f852                	sd	s4,48(sp)
 16a:	f456                	sd	s5,40(sp)
 16c:	f05a                	sd	s6,32(sp)
 16e:	ec5e                	sd	s7,24(sp)
 170:	e862                	sd	s8,16(sp)
 172:	1080                	addi	s0,sp,96
 174:	8baa                	mv	s7,a0
 176:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 178:	892a                	mv	s2,a0
 17a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 17c:	faf40b13          	addi	s6,s0,-81
 180:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 182:	8c26                	mv	s8,s1
 184:	0014899b          	addiw	s3,s1,1
 188:	84ce                	mv	s1,s3
 18a:	0349d463          	bge	s3,s4,1b2 <gets+0x56>
    cc = read(0, &c, 1);
 18e:	8656                	mv	a2,s5
 190:	85da                	mv	a1,s6
 192:	4501                	li	a0,0
 194:	1bc000ef          	jal	350 <read>
    if(cc < 1)
 198:	00a05d63          	blez	a0,1b2 <gets+0x56>
      break;
    buf[i++] = c;
 19c:	faf44783          	lbu	a5,-81(s0)
 1a0:	00f90023          	sb	a5,0(s2) # 1000 <freep>
    if(c == '\n' || c == '\r')
 1a4:	0905                	addi	s2,s2,1
 1a6:	ff678713          	addi	a4,a5,-10
 1aa:	c319                	beqz	a4,1b0 <gets+0x54>
 1ac:	17cd                	addi	a5,a5,-13
 1ae:	fbf1                	bnez	a5,182 <gets+0x26>
    buf[i++] = c;
 1b0:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1b2:	9c5e                	add	s8,s8,s7
 1b4:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1b8:	855e                	mv	a0,s7
 1ba:	60e6                	ld	ra,88(sp)
 1bc:	6446                	ld	s0,80(sp)
 1be:	64a6                	ld	s1,72(sp)
 1c0:	6906                	ld	s2,64(sp)
 1c2:	79e2                	ld	s3,56(sp)
 1c4:	7a42                	ld	s4,48(sp)
 1c6:	7aa2                	ld	s5,40(sp)
 1c8:	7b02                	ld	s6,32(sp)
 1ca:	6be2                	ld	s7,24(sp)
 1cc:	6c42                	ld	s8,16(sp)
 1ce:	6125                	addi	sp,sp,96
 1d0:	8082                	ret

00000000000001d2 <stat>:

int
stat(const char *n, struct stat *st)
{
 1d2:	1101                	addi	sp,sp,-32
 1d4:	ec06                	sd	ra,24(sp)
 1d6:	e822                	sd	s0,16(sp)
 1d8:	e04a                	sd	s2,0(sp)
 1da:	1000                	addi	s0,sp,32
 1dc:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 1de:	4581                	li	a1,0
 1e0:	198000ef          	jal	378 <open>
  if(fd < 0)
 1e4:	02054263          	bltz	a0,208 <stat+0x36>
 1e8:	e426                	sd	s1,8(sp)
 1ea:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 1ec:	85ca                	mv	a1,s2
 1ee:	1a2000ef          	jal	390 <fstat>
 1f2:	892a                	mv	s2,a0
  close(fd);
 1f4:	8526                	mv	a0,s1
 1f6:	16a000ef          	jal	360 <close>
  return r;
 1fa:	64a2                	ld	s1,8(sp)
}
 1fc:	854a                	mv	a0,s2
 1fe:	60e2                	ld	ra,24(sp)
 200:	6442                	ld	s0,16(sp)
 202:	6902                	ld	s2,0(sp)
 204:	6105                	addi	sp,sp,32
 206:	8082                	ret
    return -1;
 208:	57fd                	li	a5,-1
 20a:	893e                	mv	s2,a5
 20c:	bfc5                	j	1fc <stat+0x2a>

000000000000020e <atoi>:

int
atoi(const char *s)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e406                	sd	ra,8(sp)
 212:	e022                	sd	s0,0(sp)
 214:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 216:	00054683          	lbu	a3,0(a0)
 21a:	fd06879b          	addiw	a5,a3,-48
 21e:	0ff7f793          	zext.b	a5,a5
 222:	4625                	li	a2,9
 224:	02f66963          	bltu	a2,a5,256 <atoi+0x48>
 228:	872a                	mv	a4,a0
  n = 0;
 22a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 22c:	0705                	addi	a4,a4,1
 22e:	0025179b          	slliw	a5,a0,0x2
 232:	9fa9                	addw	a5,a5,a0
 234:	0017979b          	slliw	a5,a5,0x1
 238:	9fb5                	addw	a5,a5,a3
 23a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 23e:	00074683          	lbu	a3,0(a4)
 242:	fd06879b          	addiw	a5,a3,-48
 246:	0ff7f793          	zext.b	a5,a5
 24a:	fef671e3          	bgeu	a2,a5,22c <atoi+0x1e>
  return n;
}
 24e:	60a2                	ld	ra,8(sp)
 250:	6402                	ld	s0,0(sp)
 252:	0141                	addi	sp,sp,16
 254:	8082                	ret
  n = 0;
 256:	4501                	li	a0,0
 258:	bfdd                	j	24e <atoi+0x40>

000000000000025a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 262:	02b57563          	bgeu	a0,a1,28c <memmove+0x32>
    while(n-- > 0)
 266:	00c05f63          	blez	a2,284 <memmove+0x2a>
 26a:	1602                	slli	a2,a2,0x20
 26c:	9201                	srli	a2,a2,0x20
 26e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 272:	872a                	mv	a4,a0
      *dst++ = *src++;
 274:	0585                	addi	a1,a1,1
 276:	0705                	addi	a4,a4,1
 278:	fff5c683          	lbu	a3,-1(a1)
 27c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 280:	fee79ae3          	bne	a5,a4,274 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 284:	60a2                	ld	ra,8(sp)
 286:	6402                	ld	s0,0(sp)
 288:	0141                	addi	sp,sp,16
 28a:	8082                	ret
    while(n-- > 0)
 28c:	fec05ce3          	blez	a2,284 <memmove+0x2a>
    dst += n;
 290:	00c50733          	add	a4,a0,a2
    src += n;
 294:	95b2                	add	a1,a1,a2
 296:	fff6079b          	addiw	a5,a2,-1
 29a:	1782                	slli	a5,a5,0x20
 29c:	9381                	srli	a5,a5,0x20
 29e:	fff7c793          	not	a5,a5
 2a2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2a4:	15fd                	addi	a1,a1,-1
 2a6:	177d                	addi	a4,a4,-1
 2a8:	0005c683          	lbu	a3,0(a1)
 2ac:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2b0:	fef71ae3          	bne	a4,a5,2a4 <memmove+0x4a>
 2b4:	bfc1                	j	284 <memmove+0x2a>

00000000000002b6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2b6:	1141                	addi	sp,sp,-16
 2b8:	e406                	sd	ra,8(sp)
 2ba:	e022                	sd	s0,0(sp)
 2bc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 2be:	c61d                	beqz	a2,2ec <memcmp+0x36>
 2c0:	1602                	slli	a2,a2,0x20
 2c2:	9201                	srli	a2,a2,0x20
 2c4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 2c8:	00054783          	lbu	a5,0(a0)
 2cc:	0005c703          	lbu	a4,0(a1)
 2d0:	00e79863          	bne	a5,a4,2e0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 2d4:	0505                	addi	a0,a0,1
    p2++;
 2d6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 2d8:	fed518e3          	bne	a0,a3,2c8 <memcmp+0x12>
  }
  return 0;
 2dc:	4501                	li	a0,0
 2de:	a019                	j	2e4 <memcmp+0x2e>
      return *p1 - *p2;
 2e0:	40e7853b          	subw	a0,a5,a4
}
 2e4:	60a2                	ld	ra,8(sp)
 2e6:	6402                	ld	s0,0(sp)
 2e8:	0141                	addi	sp,sp,16
 2ea:	8082                	ret
  return 0;
 2ec:	4501                	li	a0,0
 2ee:	bfdd                	j	2e4 <memcmp+0x2e>

00000000000002f0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 2f0:	1141                	addi	sp,sp,-16
 2f2:	e406                	sd	ra,8(sp)
 2f4:	e022                	sd	s0,0(sp)
 2f6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 2f8:	f63ff0ef          	jal	25a <memmove>
}
 2fc:	60a2                	ld	ra,8(sp)
 2fe:	6402                	ld	s0,0(sp)
 300:	0141                	addi	sp,sp,16
 302:	8082                	ret

0000000000000304 <sbrk>:

char *
sbrk(int n) {
 304:	1141                	addi	sp,sp,-16
 306:	e406                	sd	ra,8(sp)
 308:	e022                	sd	s0,0(sp)
 30a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 30c:	4585                	li	a1,1
 30e:	0b2000ef          	jal	3c0 <sys_sbrk>
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret

000000000000031a <sbrklazy>:

char *
sbrklazy(int n) {
 31a:	1141                	addi	sp,sp,-16
 31c:	e406                	sd	ra,8(sp)
 31e:	e022                	sd	s0,0(sp)
 320:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 322:	4589                	li	a1,2
 324:	09c000ef          	jal	3c0 <sys_sbrk>
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret

0000000000000330 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 330:	4885                	li	a7,1
 ecall
 332:	00000073          	ecall
 ret
 336:	8082                	ret

0000000000000338 <exit>:
.global exit
exit:
 li a7, SYS_exit
 338:	4889                	li	a7,2
 ecall
 33a:	00000073          	ecall
 ret
 33e:	8082                	ret

0000000000000340 <wait>:
.global wait
wait:
 li a7, SYS_wait
 340:	488d                	li	a7,3
 ecall
 342:	00000073          	ecall
 ret
 346:	8082                	ret

0000000000000348 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 348:	4891                	li	a7,4
 ecall
 34a:	00000073          	ecall
 ret
 34e:	8082                	ret

0000000000000350 <read>:
.global read
read:
 li a7, SYS_read
 350:	4895                	li	a7,5
 ecall
 352:	00000073          	ecall
 ret
 356:	8082                	ret

0000000000000358 <write>:
.global write
write:
 li a7, SYS_write
 358:	48c1                	li	a7,16
 ecall
 35a:	00000073          	ecall
 ret
 35e:	8082                	ret

0000000000000360 <close>:
.global close
close:
 li a7, SYS_close
 360:	48d5                	li	a7,21
 ecall
 362:	00000073          	ecall
 ret
 366:	8082                	ret

0000000000000368 <kill>:
.global kill
kill:
 li a7, SYS_kill
 368:	4899                	li	a7,6
 ecall
 36a:	00000073          	ecall
 ret
 36e:	8082                	ret

0000000000000370 <exec>:
.global exec
exec:
 li a7, SYS_exec
 370:	489d                	li	a7,7
 ecall
 372:	00000073          	ecall
 ret
 376:	8082                	ret

0000000000000378 <open>:
.global open
open:
 li a7, SYS_open
 378:	48bd                	li	a7,15
 ecall
 37a:	00000073          	ecall
 ret
 37e:	8082                	ret

0000000000000380 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 380:	48c5                	li	a7,17
 ecall
 382:	00000073          	ecall
 ret
 386:	8082                	ret

0000000000000388 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 388:	48c9                	li	a7,18
 ecall
 38a:	00000073          	ecall
 ret
 38e:	8082                	ret

0000000000000390 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 390:	48a1                	li	a7,8
 ecall
 392:	00000073          	ecall
 ret
 396:	8082                	ret

0000000000000398 <link>:
.global link
link:
 li a7, SYS_link
 398:	48cd                	li	a7,19
 ecall
 39a:	00000073          	ecall
 ret
 39e:	8082                	ret

00000000000003a0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3a0:	48d1                	li	a7,20
 ecall
 3a2:	00000073          	ecall
 ret
 3a6:	8082                	ret

00000000000003a8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3a8:	48a5                	li	a7,9
 ecall
 3aa:	00000073          	ecall
 ret
 3ae:	8082                	ret

00000000000003b0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3b0:	48a9                	li	a7,10
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3b8:	48ad                	li	a7,11
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 3c0:	48b1                	li	a7,12
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 3c8:	48b5                	li	a7,13
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 3d0:	48b9                	li	a7,14
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
 3d8:	48d9                	li	a7,22
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 3e0:	1101                	addi	sp,sp,-32
 3e2:	ec06                	sd	ra,24(sp)
 3e4:	e822                	sd	s0,16(sp)
 3e6:	1000                	addi	s0,sp,32
 3e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 3ec:	4605                	li	a2,1
 3ee:	fef40593          	addi	a1,s0,-17
 3f2:	f67ff0ef          	jal	358 <write>
}
 3f6:	60e2                	ld	ra,24(sp)
 3f8:	6442                	ld	s0,16(sp)
 3fa:	6105                	addi	sp,sp,32
 3fc:	8082                	ret

00000000000003fe <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 3fe:	715d                	addi	sp,sp,-80
 400:	e486                	sd	ra,72(sp)
 402:	e0a2                	sd	s0,64(sp)
 404:	f84a                	sd	s2,48(sp)
 406:	f44e                	sd	s3,40(sp)
 408:	0880                	addi	s0,sp,80
 40a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 40c:	cac1                	beqz	a3,49c <printint+0x9e>
 40e:	0805d763          	bgez	a1,49c <printint+0x9e>
    neg = 1;
    x = -xx;
 412:	40b005bb          	negw	a1,a1
    neg = 1;
 416:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 418:	fb840993          	addi	s3,s0,-72
  neg = 0;
 41c:	86ce                	mv	a3,s3
  i = 0;
 41e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 420:	00000817          	auipc	a6,0x0
 424:	54080813          	addi	a6,a6,1344 # 960 <digits>
 428:	88ba                	mv	a7,a4
 42a:	0017051b          	addiw	a0,a4,1
 42e:	872a                	mv	a4,a0
 430:	02c5f7bb          	remuw	a5,a1,a2
 434:	1782                	slli	a5,a5,0x20
 436:	9381                	srli	a5,a5,0x20
 438:	97c2                	add	a5,a5,a6
 43a:	0007c783          	lbu	a5,0(a5)
 43e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 442:	87ae                	mv	a5,a1
 444:	02c5d5bb          	divuw	a1,a1,a2
 448:	0685                	addi	a3,a3,1
 44a:	fcc7ffe3          	bgeu	a5,a2,428 <printint+0x2a>
  if(neg)
 44e:	00030c63          	beqz	t1,466 <printint+0x68>
    buf[i++] = '-';
 452:	fd050793          	addi	a5,a0,-48
 456:	00878533          	add	a0,a5,s0
 45a:	02d00793          	li	a5,45
 45e:	fef50423          	sb	a5,-24(a0)
 462:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 466:	02e05563          	blez	a4,490 <printint+0x92>
 46a:	fc26                	sd	s1,56(sp)
 46c:	377d                	addiw	a4,a4,-1
 46e:	00e984b3          	add	s1,s3,a4
 472:	19fd                	addi	s3,s3,-1
 474:	99ba                	add	s3,s3,a4
 476:	1702                	slli	a4,a4,0x20
 478:	9301                	srli	a4,a4,0x20
 47a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 47e:	0004c583          	lbu	a1,0(s1)
 482:	854a                	mv	a0,s2
 484:	f5dff0ef          	jal	3e0 <putc>
  while(--i >= 0)
 488:	14fd                	addi	s1,s1,-1
 48a:	ff349ae3          	bne	s1,s3,47e <printint+0x80>
 48e:	74e2                	ld	s1,56(sp)
}
 490:	60a6                	ld	ra,72(sp)
 492:	6406                	ld	s0,64(sp)
 494:	7942                	ld	s2,48(sp)
 496:	79a2                	ld	s3,40(sp)
 498:	6161                	addi	sp,sp,80
 49a:	8082                	ret
    x = xx;
 49c:	2581                	sext.w	a1,a1
  neg = 0;
 49e:	4301                	li	t1,0
 4a0:	bfa5                	j	418 <printint+0x1a>

00000000000004a2 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 4a2:	711d                	addi	sp,sp,-96
 4a4:	ec86                	sd	ra,88(sp)
 4a6:	e8a2                	sd	s0,80(sp)
 4a8:	e4a6                	sd	s1,72(sp)
 4aa:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 4ac:	0005c483          	lbu	s1,0(a1)
 4b0:	22048363          	beqz	s1,6d6 <vprintf+0x234>
 4b4:	e0ca                	sd	s2,64(sp)
 4b6:	fc4e                	sd	s3,56(sp)
 4b8:	f852                	sd	s4,48(sp)
 4ba:	f456                	sd	s5,40(sp)
 4bc:	f05a                	sd	s6,32(sp)
 4be:	ec5e                	sd	s7,24(sp)
 4c0:	e862                	sd	s8,16(sp)
 4c2:	8b2a                	mv	s6,a0
 4c4:	8a2e                	mv	s4,a1
 4c6:	8bb2                	mv	s7,a2
  state = 0;
 4c8:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 4ca:	4901                	li	s2,0
 4cc:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 4ce:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 4d2:	06400c13          	li	s8,100
 4d6:	a00d                	j	4f8 <vprintf+0x56>
        putc(fd, c0);
 4d8:	85a6                	mv	a1,s1
 4da:	855a                	mv	a0,s6
 4dc:	f05ff0ef          	jal	3e0 <putc>
 4e0:	a019                	j	4e6 <vprintf+0x44>
    } else if(state == '%'){
 4e2:	03598363          	beq	s3,s5,508 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 4e6:	0019079b          	addiw	a5,s2,1
 4ea:	893e                	mv	s2,a5
 4ec:	873e                	mv	a4,a5
 4ee:	97d2                	add	a5,a5,s4
 4f0:	0007c483          	lbu	s1,0(a5)
 4f4:	1c048a63          	beqz	s1,6c8 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 4f8:	0004879b          	sext.w	a5,s1
    if(state == 0){
 4fc:	fe0993e3          	bnez	s3,4e2 <vprintf+0x40>
      if(c0 == '%'){
 500:	fd579ce3          	bne	a5,s5,4d8 <vprintf+0x36>
        state = '%';
 504:	89be                	mv	s3,a5
 506:	b7c5                	j	4e6 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 508:	00ea06b3          	add	a3,s4,a4
 50c:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 510:	1c060863          	beqz	a2,6e0 <vprintf+0x23e>
      if(c0 == 'd'){
 514:	03878763          	beq	a5,s8,542 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 518:	f9478693          	addi	a3,a5,-108
 51c:	0016b693          	seqz	a3,a3
 520:	f9c60593          	addi	a1,a2,-100
 524:	e99d                	bnez	a1,55a <vprintf+0xb8>
 526:	ca95                	beqz	a3,55a <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 528:	008b8493          	addi	s1,s7,8
 52c:	4685                	li	a3,1
 52e:	4629                	li	a2,10
 530:	000bb583          	ld	a1,0(s7)
 534:	855a                	mv	a0,s6
 536:	ec9ff0ef          	jal	3fe <printint>
        i += 1;
 53a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 53c:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 53e:	4981                	li	s3,0
 540:	b75d                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 542:	008b8493          	addi	s1,s7,8
 546:	4685                	li	a3,1
 548:	4629                	li	a2,10
 54a:	000ba583          	lw	a1,0(s7)
 54e:	855a                	mv	a0,s6
 550:	eafff0ef          	jal	3fe <printint>
 554:	8ba6                	mv	s7,s1
      state = 0;
 556:	4981                	li	s3,0
 558:	b779                	j	4e6 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 55a:	9752                	add	a4,a4,s4
 55c:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 560:	f9460713          	addi	a4,a2,-108
 564:	00173713          	seqz	a4,a4
 568:	8f75                	and	a4,a4,a3
 56a:	f9c58513          	addi	a0,a1,-100
 56e:	18051363          	bnez	a0,6f4 <vprintf+0x252>
 572:	18070163          	beqz	a4,6f4 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 576:	008b8493          	addi	s1,s7,8
 57a:	4685                	li	a3,1
 57c:	4629                	li	a2,10
 57e:	000bb583          	ld	a1,0(s7)
 582:	855a                	mv	a0,s6
 584:	e7bff0ef          	jal	3fe <printint>
        i += 2;
 588:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 58a:	8ba6                	mv	s7,s1
      state = 0;
 58c:	4981                	li	s3,0
        i += 2;
 58e:	bfa1                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 590:	008b8493          	addi	s1,s7,8
 594:	4681                	li	a3,0
 596:	4629                	li	a2,10
 598:	000be583          	lwu	a1,0(s7)
 59c:	855a                	mv	a0,s6
 59e:	e61ff0ef          	jal	3fe <printint>
 5a2:	8ba6                	mv	s7,s1
      state = 0;
 5a4:	4981                	li	s3,0
 5a6:	b781                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5a8:	008b8493          	addi	s1,s7,8
 5ac:	4681                	li	a3,0
 5ae:	4629                	li	a2,10
 5b0:	000bb583          	ld	a1,0(s7)
 5b4:	855a                	mv	a0,s6
 5b6:	e49ff0ef          	jal	3fe <printint>
        i += 1;
 5ba:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 5bc:	8ba6                	mv	s7,s1
      state = 0;
 5be:	4981                	li	s3,0
 5c0:	b71d                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 5c2:	008b8493          	addi	s1,s7,8
 5c6:	4681                	li	a3,0
 5c8:	4629                	li	a2,10
 5ca:	000bb583          	ld	a1,0(s7)
 5ce:	855a                	mv	a0,s6
 5d0:	e2fff0ef          	jal	3fe <printint>
        i += 2;
 5d4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 5d6:	8ba6                	mv	s7,s1
      state = 0;
 5d8:	4981                	li	s3,0
        i += 2;
 5da:	b731                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 5dc:	008b8493          	addi	s1,s7,8
 5e0:	4681                	li	a3,0
 5e2:	4641                	li	a2,16
 5e4:	000be583          	lwu	a1,0(s7)
 5e8:	855a                	mv	a0,s6
 5ea:	e15ff0ef          	jal	3fe <printint>
 5ee:	8ba6                	mv	s7,s1
      state = 0;
 5f0:	4981                	li	s3,0
 5f2:	bdd5                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 5f4:	008b8493          	addi	s1,s7,8
 5f8:	4681                	li	a3,0
 5fa:	4641                	li	a2,16
 5fc:	000bb583          	ld	a1,0(s7)
 600:	855a                	mv	a0,s6
 602:	dfdff0ef          	jal	3fe <printint>
        i += 1;
 606:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 608:	8ba6                	mv	s7,s1
      state = 0;
 60a:	4981                	li	s3,0
 60c:	bde9                	j	4e6 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 60e:	008b8493          	addi	s1,s7,8
 612:	4681                	li	a3,0
 614:	4641                	li	a2,16
 616:	000bb583          	ld	a1,0(s7)
 61a:	855a                	mv	a0,s6
 61c:	de3ff0ef          	jal	3fe <printint>
        i += 2;
 620:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 622:	8ba6                	mv	s7,s1
      state = 0;
 624:	4981                	li	s3,0
        i += 2;
 626:	b5c1                	j	4e6 <vprintf+0x44>
 628:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 62a:	008b8793          	addi	a5,s7,8
 62e:	8cbe                	mv	s9,a5
 630:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 634:	03000593          	li	a1,48
 638:	855a                	mv	a0,s6
 63a:	da7ff0ef          	jal	3e0 <putc>
  putc(fd, 'x');
 63e:	07800593          	li	a1,120
 642:	855a                	mv	a0,s6
 644:	d9dff0ef          	jal	3e0 <putc>
 648:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 64a:	00000b97          	auipc	s7,0x0
 64e:	316b8b93          	addi	s7,s7,790 # 960 <digits>
 652:	03c9d793          	srli	a5,s3,0x3c
 656:	97de                	add	a5,a5,s7
 658:	0007c583          	lbu	a1,0(a5)
 65c:	855a                	mv	a0,s6
 65e:	d83ff0ef          	jal	3e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 662:	0992                	slli	s3,s3,0x4
 664:	34fd                	addiw	s1,s1,-1
 666:	f4f5                	bnez	s1,652 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 668:	8be6                	mv	s7,s9
      state = 0;
 66a:	4981                	li	s3,0
 66c:	6ca2                	ld	s9,8(sp)
 66e:	bda5                	j	4e6 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 670:	008b8493          	addi	s1,s7,8
 674:	000bc583          	lbu	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	d67ff0ef          	jal	3e0 <putc>
 67e:	8ba6                	mv	s7,s1
      state = 0;
 680:	4981                	li	s3,0
 682:	b595                	j	4e6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 684:	008b8993          	addi	s3,s7,8
 688:	000bb483          	ld	s1,0(s7)
 68c:	cc91                	beqz	s1,6a8 <vprintf+0x206>
        for(; *s; s++)
 68e:	0004c583          	lbu	a1,0(s1)
 692:	c985                	beqz	a1,6c2 <vprintf+0x220>
          putc(fd, *s);
 694:	855a                	mv	a0,s6
 696:	d4bff0ef          	jal	3e0 <putc>
        for(; *s; s++)
 69a:	0485                	addi	s1,s1,1
 69c:	0004c583          	lbu	a1,0(s1)
 6a0:	f9f5                	bnez	a1,694 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 6a2:	8bce                	mv	s7,s3
      state = 0;
 6a4:	4981                	li	s3,0
 6a6:	b581                	j	4e6 <vprintf+0x44>
          s = "(null)";
 6a8:	00000497          	auipc	s1,0x0
 6ac:	2b048493          	addi	s1,s1,688 # 958 <malloc+0x114>
        for(; *s; s++)
 6b0:	02800593          	li	a1,40
 6b4:	b7c5                	j	694 <vprintf+0x1f2>
        putc(fd, '%');
 6b6:	85be                	mv	a1,a5
 6b8:	855a                	mv	a0,s6
 6ba:	d27ff0ef          	jal	3e0 <putc>
      state = 0;
 6be:	4981                	li	s3,0
 6c0:	b51d                	j	4e6 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6c2:	8bce                	mv	s7,s3
      state = 0;
 6c4:	4981                	li	s3,0
 6c6:	b505                	j	4e6 <vprintf+0x44>
 6c8:	6906                	ld	s2,64(sp)
 6ca:	79e2                	ld	s3,56(sp)
 6cc:	7a42                	ld	s4,48(sp)
 6ce:	7aa2                	ld	s5,40(sp)
 6d0:	7b02                	ld	s6,32(sp)
 6d2:	6be2                	ld	s7,24(sp)
 6d4:	6c42                	ld	s8,16(sp)
    }
  }
}
 6d6:	60e6                	ld	ra,88(sp)
 6d8:	6446                	ld	s0,80(sp)
 6da:	64a6                	ld	s1,72(sp)
 6dc:	6125                	addi	sp,sp,96
 6de:	8082                	ret
      if(c0 == 'd'){
 6e0:	06400713          	li	a4,100
 6e4:	e4e78fe3          	beq	a5,a4,542 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 6e8:	f9478693          	addi	a3,a5,-108
 6ec:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 6f0:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f2:	4701                	li	a4,0
      } else if(c0 == 'u'){
 6f4:	07500513          	li	a0,117
 6f8:	e8a78ce3          	beq	a5,a0,590 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 6fc:	f8b60513          	addi	a0,a2,-117
 700:	e119                	bnez	a0,706 <vprintf+0x264>
 702:	ea0693e3          	bnez	a3,5a8 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 706:	f8b58513          	addi	a0,a1,-117
 70a:	e119                	bnez	a0,710 <vprintf+0x26e>
 70c:	ea071be3          	bnez	a4,5c2 <vprintf+0x120>
      } else if(c0 == 'x'){
 710:	07800513          	li	a0,120
 714:	eca784e3          	beq	a5,a0,5dc <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 718:	f8860613          	addi	a2,a2,-120
 71c:	e219                	bnez	a2,722 <vprintf+0x280>
 71e:	ec069be3          	bnez	a3,5f4 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 722:	f8858593          	addi	a1,a1,-120
 726:	e199                	bnez	a1,72c <vprintf+0x28a>
 728:	ee0713e3          	bnez	a4,60e <vprintf+0x16c>
      } else if(c0 == 'p'){
 72c:	07000713          	li	a4,112
 730:	eee78ce3          	beq	a5,a4,628 <vprintf+0x186>
      } else if(c0 == 'c'){
 734:	06300713          	li	a4,99
 738:	f2e78ce3          	beq	a5,a4,670 <vprintf+0x1ce>
      } else if(c0 == 's'){
 73c:	07300713          	li	a4,115
 740:	f4e782e3          	beq	a5,a4,684 <vprintf+0x1e2>
      } else if(c0 == '%'){
 744:	02500713          	li	a4,37
 748:	f6e787e3          	beq	a5,a4,6b6 <vprintf+0x214>
        putc(fd, '%');
 74c:	02500593          	li	a1,37
 750:	855a                	mv	a0,s6
 752:	c8fff0ef          	jal	3e0 <putc>
        putc(fd, c0);
 756:	85a6                	mv	a1,s1
 758:	855a                	mv	a0,s6
 75a:	c87ff0ef          	jal	3e0 <putc>
      state = 0;
 75e:	4981                	li	s3,0
 760:	b359                	j	4e6 <vprintf+0x44>

0000000000000762 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 762:	715d                	addi	sp,sp,-80
 764:	ec06                	sd	ra,24(sp)
 766:	e822                	sd	s0,16(sp)
 768:	1000                	addi	s0,sp,32
 76a:	e010                	sd	a2,0(s0)
 76c:	e414                	sd	a3,8(s0)
 76e:	e818                	sd	a4,16(s0)
 770:	ec1c                	sd	a5,24(s0)
 772:	03043023          	sd	a6,32(s0)
 776:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 77a:	8622                	mv	a2,s0
 77c:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 780:	d23ff0ef          	jal	4a2 <vprintf>
}
 784:	60e2                	ld	ra,24(sp)
 786:	6442                	ld	s0,16(sp)
 788:	6161                	addi	sp,sp,80
 78a:	8082                	ret

000000000000078c <printf>:

void
printf(const char *fmt, ...)
{
 78c:	711d                	addi	sp,sp,-96
 78e:	ec06                	sd	ra,24(sp)
 790:	e822                	sd	s0,16(sp)
 792:	1000                	addi	s0,sp,32
 794:	e40c                	sd	a1,8(s0)
 796:	e810                	sd	a2,16(s0)
 798:	ec14                	sd	a3,24(s0)
 79a:	f018                	sd	a4,32(s0)
 79c:	f41c                	sd	a5,40(s0)
 79e:	03043823          	sd	a6,48(s0)
 7a2:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 7a6:	00840613          	addi	a2,s0,8
 7aa:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 7ae:	85aa                	mv	a1,a0
 7b0:	4505                	li	a0,1
 7b2:	cf1ff0ef          	jal	4a2 <vprintf>
}
 7b6:	60e2                	ld	ra,24(sp)
 7b8:	6442                	ld	s0,16(sp)
 7ba:	6125                	addi	sp,sp,96
 7bc:	8082                	ret

00000000000007be <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 7be:	1141                	addi	sp,sp,-16
 7c0:	e406                	sd	ra,8(sp)
 7c2:	e022                	sd	s0,0(sp)
 7c4:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 7c6:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7ca:	00001797          	auipc	a5,0x1
 7ce:	8367b783          	ld	a5,-1994(a5) # 1000 <freep>
 7d2:	a039                	j	7e0 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7d4:	6398                	ld	a4,0(a5)
 7d6:	00e7e463          	bltu	a5,a4,7de <free+0x20>
 7da:	00e6ea63          	bltu	a3,a4,7ee <free+0x30>
{
 7de:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 7e0:	fed7fae3          	bgeu	a5,a3,7d4 <free+0x16>
 7e4:	6398                	ld	a4,0(a5)
 7e6:	00e6e463          	bltu	a3,a4,7ee <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 7ea:	fee7eae3          	bltu	a5,a4,7de <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 7ee:	ff852583          	lw	a1,-8(a0)
 7f2:	6390                	ld	a2,0(a5)
 7f4:	02059813          	slli	a6,a1,0x20
 7f8:	01c85713          	srli	a4,a6,0x1c
 7fc:	9736                	add	a4,a4,a3
 7fe:	02e60563          	beq	a2,a4,828 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 802:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 806:	4790                	lw	a2,8(a5)
 808:	02061593          	slli	a1,a2,0x20
 80c:	01c5d713          	srli	a4,a1,0x1c
 810:	973e                	add	a4,a4,a5
 812:	02e68263          	beq	a3,a4,836 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 816:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 818:	00000717          	auipc	a4,0x0
 81c:	7ef73423          	sd	a5,2024(a4) # 1000 <freep>
}
 820:	60a2                	ld	ra,8(sp)
 822:	6402                	ld	s0,0(sp)
 824:	0141                	addi	sp,sp,16
 826:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 828:	4618                	lw	a4,8(a2)
 82a:	9f2d                	addw	a4,a4,a1
 82c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 830:	6398                	ld	a4,0(a5)
 832:	6310                	ld	a2,0(a4)
 834:	b7f9                	j	802 <free+0x44>
    p->s.size += bp->s.size;
 836:	ff852703          	lw	a4,-8(a0)
 83a:	9f31                	addw	a4,a4,a2
 83c:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 83e:	ff053683          	ld	a3,-16(a0)
 842:	bfd1                	j	816 <free+0x58>

0000000000000844 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 844:	7139                	addi	sp,sp,-64
 846:	fc06                	sd	ra,56(sp)
 848:	f822                	sd	s0,48(sp)
 84a:	f04a                	sd	s2,32(sp)
 84c:	ec4e                	sd	s3,24(sp)
 84e:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 850:	02051993          	slli	s3,a0,0x20
 854:	0209d993          	srli	s3,s3,0x20
 858:	09bd                	addi	s3,s3,15
 85a:	0049d993          	srli	s3,s3,0x4
 85e:	2985                	addiw	s3,s3,1
 860:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 862:	00000517          	auipc	a0,0x0
 866:	79e53503          	ld	a0,1950(a0) # 1000 <freep>
 86a:	c905                	beqz	a0,89a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 86c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 86e:	4798                	lw	a4,8(a5)
 870:	09377663          	bgeu	a4,s3,8fc <malloc+0xb8>
 874:	f426                	sd	s1,40(sp)
 876:	e852                	sd	s4,16(sp)
 878:	e456                	sd	s5,8(sp)
 87a:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 87c:	8a4e                	mv	s4,s3
 87e:	6705                	lui	a4,0x1
 880:	00e9f363          	bgeu	s3,a4,886 <malloc+0x42>
 884:	6a05                	lui	s4,0x1
 886:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 88a:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 88e:	00000497          	auipc	s1,0x0
 892:	77248493          	addi	s1,s1,1906 # 1000 <freep>
  if(p == SBRK_ERROR)
 896:	5afd                	li	s5,-1
 898:	a83d                	j	8d6 <malloc+0x92>
 89a:	f426                	sd	s1,40(sp)
 89c:	e852                	sd	s4,16(sp)
 89e:	e456                	sd	s5,8(sp)
 8a0:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 8a2:	00000797          	auipc	a5,0x0
 8a6:	76e78793          	addi	a5,a5,1902 # 1010 <base>
 8aa:	00000717          	auipc	a4,0x0
 8ae:	74f73b23          	sd	a5,1878(a4) # 1000 <freep>
 8b2:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 8b4:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 8b8:	b7d1                	j	87c <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 8ba:	6398                	ld	a4,0(a5)
 8bc:	e118                	sd	a4,0(a0)
 8be:	a899                	j	914 <malloc+0xd0>
  hp->s.size = nu;
 8c0:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 8c4:	0541                	addi	a0,a0,16
 8c6:	ef9ff0ef          	jal	7be <free>
  return freep;
 8ca:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 8cc:	c125                	beqz	a0,92c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8ce:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8d0:	4798                	lw	a4,8(a5)
 8d2:	03277163          	bgeu	a4,s2,8f4 <malloc+0xb0>
    if(p == freep)
 8d6:	6098                	ld	a4,0(s1)
 8d8:	853e                	mv	a0,a5
 8da:	fef71ae3          	bne	a4,a5,8ce <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 8de:	8552                	mv	a0,s4
 8e0:	a25ff0ef          	jal	304 <sbrk>
  if(p == SBRK_ERROR)
 8e4:	fd551ee3          	bne	a0,s5,8c0 <malloc+0x7c>
        return 0;
 8e8:	4501                	li	a0,0
 8ea:	74a2                	ld	s1,40(sp)
 8ec:	6a42                	ld	s4,16(sp)
 8ee:	6aa2                	ld	s5,8(sp)
 8f0:	6b02                	ld	s6,0(sp)
 8f2:	a03d                	j	920 <malloc+0xdc>
 8f4:	74a2                	ld	s1,40(sp)
 8f6:	6a42                	ld	s4,16(sp)
 8f8:	6aa2                	ld	s5,8(sp)
 8fa:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 8fc:	fae90fe3          	beq	s2,a4,8ba <malloc+0x76>
        p->s.size -= nunits;
 900:	4137073b          	subw	a4,a4,s3
 904:	c798                	sw	a4,8(a5)
        p += p->s.size;
 906:	02071693          	slli	a3,a4,0x20
 90a:	01c6d713          	srli	a4,a3,0x1c
 90e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 910:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 914:	00000717          	auipc	a4,0x0
 918:	6ea73623          	sd	a0,1772(a4) # 1000 <freep>
      return (void*)(p + 1);
 91c:	01078513          	addi	a0,a5,16
  }
}
 920:	70e2                	ld	ra,56(sp)
 922:	7442                	ld	s0,48(sp)
 924:	7902                	ld	s2,32(sp)
 926:	69e2                	ld	s3,24(sp)
 928:	6121                	addi	sp,sp,64
 92a:	8082                	ret
 92c:	74a2                	ld	s1,40(sp)
 92e:	6a42                	ld	s4,16(sp)
 930:	6aa2                	ld	s5,8(sp)
 932:	6b02                	ld	s6,0(sp)
 934:	b7f5                	j	920 <malloc+0xdc>
