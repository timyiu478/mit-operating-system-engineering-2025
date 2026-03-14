
user/_init:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char *argv[] = { "sh", 0 };

int
main(void)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
  int pid, wpid;

  if(open("console", O_RDWR) < 0){
   c:	4589                	li	a1,2
   e:	00001517          	auipc	a0,0x1
  12:	a2250513          	addi	a0,a0,-1502 # a30 <statistics+0x74>
  16:	3ac000ef          	jal	3c2 <open>
  1a:	04054563          	bltz	a0,64 <main+0x64>
    mknod("console", CONSOLE, 0);
    mknod("statistics", STATS, 0);
    open("console", O_RDWR);
  }
  dup(0);  // stdout
  1e:	4501                	li	a0,0
  20:	3da000ef          	jal	3fa <dup>
  dup(0);  // stderr
  24:	4501                	li	a0,0
  26:	3d4000ef          	jal	3fa <dup>

  for(;;){
    printf("init: starting sh\n");
  2a:	00001917          	auipc	s2,0x1
  2e:	a1e90913          	addi	s2,s2,-1506 # a48 <statistics+0x8c>
  32:	854a                	mv	a0,s2
  34:	7de000ef          	jal	812 <printf>
    pid = fork();
  38:	342000ef          	jal	37a <fork>
  3c:	84aa                	mv	s1,a0
    if(pid < 0){
  3e:	04054b63          	bltz	a0,94 <main+0x94>
      printf("init: fork failed\n");
      exit(1);
    }
    if(pid == 0){
  42:	c135                	beqz	a0,a6 <main+0xa6>
    }

    for(;;){
      // this call to wait() returns if the shell exits,
      // or if a parentless process exits.
      wpid = wait((int *) 0);
  44:	4501                	li	a0,0
  46:	344000ef          	jal	38a <wait>
      if(wpid == pid){
  4a:	fea484e3          	beq	s1,a0,32 <main+0x32>
        // the shell exited; restart it.
        break;
      } else if(wpid < 0){
  4e:	fe055be3          	bgez	a0,44 <main+0x44>
        printf("init: wait returned an error\n");
  52:	00001517          	auipc	a0,0x1
  56:	a4650513          	addi	a0,a0,-1466 # a98 <statistics+0xdc>
  5a:	7b8000ef          	jal	812 <printf>
        exit(1);
  5e:	4505                	li	a0,1
  60:	322000ef          	jal	382 <exit>
    mknod("console", CONSOLE, 0);
  64:	4601                	li	a2,0
  66:	4585                	li	a1,1
  68:	00001517          	auipc	a0,0x1
  6c:	9c850513          	addi	a0,a0,-1592 # a30 <statistics+0x74>
  70:	35a000ef          	jal	3ca <mknod>
    mknod("statistics", STATS, 0);
  74:	4601                	li	a2,0
  76:	4589                	li	a1,2
  78:	00001517          	auipc	a0,0x1
  7c:	9c050513          	addi	a0,a0,-1600 # a38 <statistics+0x7c>
  80:	34a000ef          	jal	3ca <mknod>
    open("console", O_RDWR);
  84:	4589                	li	a1,2
  86:	00001517          	auipc	a0,0x1
  8a:	9aa50513          	addi	a0,a0,-1622 # a30 <statistics+0x74>
  8e:	334000ef          	jal	3c2 <open>
  92:	b771                	j	1e <main+0x1e>
      printf("init: fork failed\n");
  94:	00001517          	auipc	a0,0x1
  98:	9cc50513          	addi	a0,a0,-1588 # a60 <statistics+0xa4>
  9c:	776000ef          	jal	812 <printf>
      exit(1);
  a0:	4505                	li	a0,1
  a2:	2e0000ef          	jal	382 <exit>
      exec("sh", argv);
  a6:	00001597          	auipc	a1,0x1
  aa:	f5a58593          	addi	a1,a1,-166 # 1000 <argv>
  ae:	00001517          	auipc	a0,0x1
  b2:	9ca50513          	addi	a0,a0,-1590 # a78 <statistics+0xbc>
  b6:	304000ef          	jal	3ba <exec>
      printf("init: exec sh failed\n");
  ba:	00001517          	auipc	a0,0x1
  be:	9c650513          	addi	a0,a0,-1594 # a80 <statistics+0xc4>
  c2:	750000ef          	jal	812 <printf>
      exit(1);
  c6:	4505                	li	a0,1
  c8:	2ba000ef          	jal	382 <exit>

00000000000000cc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  cc:	1141                	addi	sp,sp,-16
  ce:	e406                	sd	ra,8(sp)
  d0:	e022                	sd	s0,0(sp)
  d2:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  d4:	f2dff0ef          	jal	0 <main>
  exit(r);
  d8:	2aa000ef          	jal	382 <exit>

00000000000000dc <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  dc:	1141                	addi	sp,sp,-16
  de:	e406                	sd	ra,8(sp)
  e0:	e022                	sd	s0,0(sp)
  e2:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  e4:	87aa                	mv	a5,a0
  e6:	0585                	addi	a1,a1,1
  e8:	0785                	addi	a5,a5,1
  ea:	fff5c703          	lbu	a4,-1(a1)
  ee:	fee78fa3          	sb	a4,-1(a5)
  f2:	fb75                	bnez	a4,e6 <strcpy+0xa>
    ;
  return os;
}
  f4:	60a2                	ld	ra,8(sp)
  f6:	6402                	ld	s0,0(sp)
  f8:	0141                	addi	sp,sp,16
  fa:	8082                	ret

00000000000000fc <strcmp>:

int
strcmp(const char *p, const char *q)
{
  fc:	1141                	addi	sp,sp,-16
  fe:	e406                	sd	ra,8(sp)
 100:	e022                	sd	s0,0(sp)
 102:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 104:	00054783          	lbu	a5,0(a0)
 108:	cb91                	beqz	a5,11c <strcmp+0x20>
 10a:	0005c703          	lbu	a4,0(a1)
 10e:	00f71763          	bne	a4,a5,11c <strcmp+0x20>
    p++, q++;
 112:	0505                	addi	a0,a0,1
 114:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 116:	00054783          	lbu	a5,0(a0)
 11a:	fbe5                	bnez	a5,10a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 11c:	0005c503          	lbu	a0,0(a1)
}
 120:	40a7853b          	subw	a0,a5,a0
 124:	60a2                	ld	ra,8(sp)
 126:	6402                	ld	s0,0(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strlen>:

uint
strlen(const char *s)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e406                	sd	ra,8(sp)
 130:	e022                	sd	s0,0(sp)
 132:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 134:	00054783          	lbu	a5,0(a0)
 138:	cf91                	beqz	a5,154 <strlen+0x28>
 13a:	00150793          	addi	a5,a0,1
 13e:	86be                	mv	a3,a5
 140:	0785                	addi	a5,a5,1
 142:	fff7c703          	lbu	a4,-1(a5)
 146:	ff65                	bnez	a4,13e <strlen+0x12>
 148:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 14c:	60a2                	ld	ra,8(sp)
 14e:	6402                	ld	s0,0(sp)
 150:	0141                	addi	sp,sp,16
 152:	8082                	ret
  for(n = 0; s[n]; n++)
 154:	4501                	li	a0,0
 156:	bfdd                	j	14c <strlen+0x20>

0000000000000158 <memset>:

void*
memset(void *dst, int c, uint n)
{
 158:	1141                	addi	sp,sp,-16
 15a:	e406                	sd	ra,8(sp)
 15c:	e022                	sd	s0,0(sp)
 15e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 160:	ca19                	beqz	a2,176 <memset+0x1e>
 162:	87aa                	mv	a5,a0
 164:	1602                	slli	a2,a2,0x20
 166:	9201                	srli	a2,a2,0x20
 168:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 16c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 170:	0785                	addi	a5,a5,1
 172:	fee79de3          	bne	a5,a4,16c <memset+0x14>
  }
  return dst;
}
 176:	60a2                	ld	ra,8(sp)
 178:	6402                	ld	s0,0(sp)
 17a:	0141                	addi	sp,sp,16
 17c:	8082                	ret

000000000000017e <strchr>:

char*
strchr(const char *s, char c)
{
 17e:	1141                	addi	sp,sp,-16
 180:	e406                	sd	ra,8(sp)
 182:	e022                	sd	s0,0(sp)
 184:	0800                	addi	s0,sp,16
  for(; *s; s++)
 186:	00054783          	lbu	a5,0(a0)
 18a:	cf81                	beqz	a5,1a2 <strchr+0x24>
    if(*s == c)
 18c:	00f58763          	beq	a1,a5,19a <strchr+0x1c>
  for(; *s; s++)
 190:	0505                	addi	a0,a0,1
 192:	00054783          	lbu	a5,0(a0)
 196:	fbfd                	bnez	a5,18c <strchr+0xe>
      return (char*)s;
  return 0;
 198:	4501                	li	a0,0
}
 19a:	60a2                	ld	ra,8(sp)
 19c:	6402                	ld	s0,0(sp)
 19e:	0141                	addi	sp,sp,16
 1a0:	8082                	ret
  return 0;
 1a2:	4501                	li	a0,0
 1a4:	bfdd                	j	19a <strchr+0x1c>

00000000000001a6 <gets>:

char*
gets(char *buf, int max)
{
 1a6:	711d                	addi	sp,sp,-96
 1a8:	ec86                	sd	ra,88(sp)
 1aa:	e8a2                	sd	s0,80(sp)
 1ac:	e4a6                	sd	s1,72(sp)
 1ae:	e0ca                	sd	s2,64(sp)
 1b0:	fc4e                	sd	s3,56(sp)
 1b2:	f852                	sd	s4,48(sp)
 1b4:	f456                	sd	s5,40(sp)
 1b6:	f05a                	sd	s6,32(sp)
 1b8:	ec5e                	sd	s7,24(sp)
 1ba:	e862                	sd	s8,16(sp)
 1bc:	1080                	addi	s0,sp,96
 1be:	8baa                	mv	s7,a0
 1c0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c2:	892a                	mv	s2,a0
 1c4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c6:	faf40b13          	addi	s6,s0,-81
 1ca:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1cc:	8c26                	mv	s8,s1
 1ce:	0014899b          	addiw	s3,s1,1
 1d2:	84ce                	mv	s1,s3
 1d4:	0349d463          	bge	s3,s4,1fc <gets+0x56>
    cc = read(0, &c, 1);
 1d8:	8656                	mv	a2,s5
 1da:	85da                	mv	a1,s6
 1dc:	4501                	li	a0,0
 1de:	1bc000ef          	jal	39a <read>
    if(cc < 1)
 1e2:	00a05d63          	blez	a0,1fc <gets+0x56>
      break;
    buf[i++] = c;
 1e6:	faf44783          	lbu	a5,-81(s0)
 1ea:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1ee:	0905                	addi	s2,s2,1
 1f0:	ff678713          	addi	a4,a5,-10
 1f4:	c319                	beqz	a4,1fa <gets+0x54>
 1f6:	17cd                	addi	a5,a5,-13
 1f8:	fbf1                	bnez	a5,1cc <gets+0x26>
    buf[i++] = c;
 1fa:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1fc:	9c5e                	add	s8,s8,s7
 1fe:	000c0023          	sb	zero,0(s8)
  return buf;
}
 202:	855e                	mv	a0,s7
 204:	60e6                	ld	ra,88(sp)
 206:	6446                	ld	s0,80(sp)
 208:	64a6                	ld	s1,72(sp)
 20a:	6906                	ld	s2,64(sp)
 20c:	79e2                	ld	s3,56(sp)
 20e:	7a42                	ld	s4,48(sp)
 210:	7aa2                	ld	s5,40(sp)
 212:	7b02                	ld	s6,32(sp)
 214:	6be2                	ld	s7,24(sp)
 216:	6c42                	ld	s8,16(sp)
 218:	6125                	addi	sp,sp,96
 21a:	8082                	ret

000000000000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	1101                	addi	sp,sp,-32
 21e:	ec06                	sd	ra,24(sp)
 220:	e822                	sd	s0,16(sp)
 222:	e04a                	sd	s2,0(sp)
 224:	1000                	addi	s0,sp,32
 226:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 228:	4581                	li	a1,0
 22a:	198000ef          	jal	3c2 <open>
  if(fd < 0)
 22e:	02054263          	bltz	a0,252 <stat+0x36>
 232:	e426                	sd	s1,8(sp)
 234:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 236:	85ca                	mv	a1,s2
 238:	1a2000ef          	jal	3da <fstat>
 23c:	892a                	mv	s2,a0
  close(fd);
 23e:	8526                	mv	a0,s1
 240:	16a000ef          	jal	3aa <close>
  return r;
 244:	64a2                	ld	s1,8(sp)
}
 246:	854a                	mv	a0,s2
 248:	60e2                	ld	ra,24(sp)
 24a:	6442                	ld	s0,16(sp)
 24c:	6902                	ld	s2,0(sp)
 24e:	6105                	addi	sp,sp,32
 250:	8082                	ret
    return -1;
 252:	57fd                	li	a5,-1
 254:	893e                	mv	s2,a5
 256:	bfc5                	j	246 <stat+0x2a>

0000000000000258 <atoi>:

int
atoi(const char *s)
{
 258:	1141                	addi	sp,sp,-16
 25a:	e406                	sd	ra,8(sp)
 25c:	e022                	sd	s0,0(sp)
 25e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 260:	00054683          	lbu	a3,0(a0)
 264:	fd06879b          	addiw	a5,a3,-48
 268:	0ff7f793          	zext.b	a5,a5
 26c:	4625                	li	a2,9
 26e:	02f66963          	bltu	a2,a5,2a0 <atoi+0x48>
 272:	872a                	mv	a4,a0
  n = 0;
 274:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 276:	0705                	addi	a4,a4,1
 278:	0025179b          	slliw	a5,a0,0x2
 27c:	9fa9                	addw	a5,a5,a0
 27e:	0017979b          	slliw	a5,a5,0x1
 282:	9fb5                	addw	a5,a5,a3
 284:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 288:	00074683          	lbu	a3,0(a4)
 28c:	fd06879b          	addiw	a5,a3,-48
 290:	0ff7f793          	zext.b	a5,a5
 294:	fef671e3          	bgeu	a2,a5,276 <atoi+0x1e>
  return n;
}
 298:	60a2                	ld	ra,8(sp)
 29a:	6402                	ld	s0,0(sp)
 29c:	0141                	addi	sp,sp,16
 29e:	8082                	ret
  n = 0;
 2a0:	4501                	li	a0,0
 2a2:	bfdd                	j	298 <atoi+0x40>

00000000000002a4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2a4:	1141                	addi	sp,sp,-16
 2a6:	e406                	sd	ra,8(sp)
 2a8:	e022                	sd	s0,0(sp)
 2aa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2ac:	02b57563          	bgeu	a0,a1,2d6 <memmove+0x32>
    while(n-- > 0)
 2b0:	00c05f63          	blez	a2,2ce <memmove+0x2a>
 2b4:	1602                	slli	a2,a2,0x20
 2b6:	9201                	srli	a2,a2,0x20
 2b8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2bc:	872a                	mv	a4,a0
      *dst++ = *src++;
 2be:	0585                	addi	a1,a1,1
 2c0:	0705                	addi	a4,a4,1
 2c2:	fff5c683          	lbu	a3,-1(a1)
 2c6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2ca:	fee79ae3          	bne	a5,a4,2be <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
    while(n-- > 0)
 2d6:	fec05ce3          	blez	a2,2ce <memmove+0x2a>
    dst += n;
 2da:	00c50733          	add	a4,a0,a2
    src += n;
 2de:	95b2                	add	a1,a1,a2
 2e0:	fff6079b          	addiw	a5,a2,-1
 2e4:	1782                	slli	a5,a5,0x20
 2e6:	9381                	srli	a5,a5,0x20
 2e8:	fff7c793          	not	a5,a5
 2ec:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2ee:	15fd                	addi	a1,a1,-1
 2f0:	177d                	addi	a4,a4,-1
 2f2:	0005c683          	lbu	a3,0(a1)
 2f6:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2fa:	fef71ae3          	bne	a4,a5,2ee <memmove+0x4a>
 2fe:	bfc1                	j	2ce <memmove+0x2a>

0000000000000300 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 300:	1141                	addi	sp,sp,-16
 302:	e406                	sd	ra,8(sp)
 304:	e022                	sd	s0,0(sp)
 306:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 308:	c61d                	beqz	a2,336 <memcmp+0x36>
 30a:	1602                	slli	a2,a2,0x20
 30c:	9201                	srli	a2,a2,0x20
 30e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 312:	00054783          	lbu	a5,0(a0)
 316:	0005c703          	lbu	a4,0(a1)
 31a:	00e79863          	bne	a5,a4,32a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 31e:	0505                	addi	a0,a0,1
    p2++;
 320:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 322:	fed518e3          	bne	a0,a3,312 <memcmp+0x12>
  }
  return 0;
 326:	4501                	li	a0,0
 328:	a019                	j	32e <memcmp+0x2e>
      return *p1 - *p2;
 32a:	40e7853b          	subw	a0,a5,a4
}
 32e:	60a2                	ld	ra,8(sp)
 330:	6402                	ld	s0,0(sp)
 332:	0141                	addi	sp,sp,16
 334:	8082                	ret
  return 0;
 336:	4501                	li	a0,0
 338:	bfdd                	j	32e <memcmp+0x2e>

000000000000033a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 33a:	1141                	addi	sp,sp,-16
 33c:	e406                	sd	ra,8(sp)
 33e:	e022                	sd	s0,0(sp)
 340:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 342:	f63ff0ef          	jal	2a4 <memmove>
}
 346:	60a2                	ld	ra,8(sp)
 348:	6402                	ld	s0,0(sp)
 34a:	0141                	addi	sp,sp,16
 34c:	8082                	ret

000000000000034e <sbrk>:

char *
sbrk(int n) {
 34e:	1141                	addi	sp,sp,-16
 350:	e406                	sd	ra,8(sp)
 352:	e022                	sd	s0,0(sp)
 354:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 356:	4585                	li	a1,1
 358:	0b2000ef          	jal	40a <sys_sbrk>
}
 35c:	60a2                	ld	ra,8(sp)
 35e:	6402                	ld	s0,0(sp)
 360:	0141                	addi	sp,sp,16
 362:	8082                	ret

0000000000000364 <sbrklazy>:

char *
sbrklazy(int n) {
 364:	1141                	addi	sp,sp,-16
 366:	e406                	sd	ra,8(sp)
 368:	e022                	sd	s0,0(sp)
 36a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 36c:	4589                	li	a1,2
 36e:	09c000ef          	jal	40a <sys_sbrk>
}
 372:	60a2                	ld	ra,8(sp)
 374:	6402                	ld	s0,0(sp)
 376:	0141                	addi	sp,sp,16
 378:	8082                	ret

000000000000037a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 37a:	4885                	li	a7,1
 ecall
 37c:	00000073          	ecall
 ret
 380:	8082                	ret

0000000000000382 <exit>:
.global exit
exit:
 li a7, SYS_exit
 382:	4889                	li	a7,2
 ecall
 384:	00000073          	ecall
 ret
 388:	8082                	ret

000000000000038a <wait>:
.global wait
wait:
 li a7, SYS_wait
 38a:	488d                	li	a7,3
 ecall
 38c:	00000073          	ecall
 ret
 390:	8082                	ret

0000000000000392 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 392:	4891                	li	a7,4
 ecall
 394:	00000073          	ecall
 ret
 398:	8082                	ret

000000000000039a <read>:
.global read
read:
 li a7, SYS_read
 39a:	4895                	li	a7,5
 ecall
 39c:	00000073          	ecall
 ret
 3a0:	8082                	ret

00000000000003a2 <write>:
.global write
write:
 li a7, SYS_write
 3a2:	48c1                	li	a7,16
 ecall
 3a4:	00000073          	ecall
 ret
 3a8:	8082                	ret

00000000000003aa <close>:
.global close
close:
 li a7, SYS_close
 3aa:	48d5                	li	a7,21
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3b2:	4899                	li	a7,6
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ba:	489d                	li	a7,7
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <open>:
.global open
open:
 li a7, SYS_open
 3c2:	48bd                	li	a7,15
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3ca:	48c5                	li	a7,17
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3d2:	48c9                	li	a7,18
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3da:	48a1                	li	a7,8
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <link>:
.global link
link:
 li a7, SYS_link
 3e2:	48cd                	li	a7,19
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3ea:	48d1                	li	a7,20
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3f2:	48a5                	li	a7,9
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <dup>:
.global dup
dup:
 li a7, SYS_dup
 3fa:	48a9                	li	a7,10
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 402:	48ad                	li	a7,11
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 40a:	48b1                	li	a7,12
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <pause>:
.global pause
pause:
 li a7, SYS_pause
 412:	48b5                	li	a7,13
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 41a:	48b9                	li	a7,14
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <bind>:
.global bind
bind:
 li a7, SYS_bind
 422:	48f5                	li	a7,29
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 42a:	48f9                	li	a7,30
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <send>:
.global send
send:
 li a7, SYS_send
 432:	48fd                	li	a7,31
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <recv>:
.global recv
recv:
 li a7, SYS_recv
 43a:	02000893          	li	a7,32
 ecall
 43e:	00000073          	ecall
 ret
 442:	8082                	ret

0000000000000444 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 444:	02100893          	li	a7,33
 ecall
 448:	00000073          	ecall
 ret
 44c:	8082                	ret

000000000000044e <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 44e:	02200893          	li	a7,34
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 458:	02300893          	li	a7,35
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 462:	02400893          	li	a7,36
 ecall
 466:	00000073          	ecall
 ret
 46a:	8082                	ret

000000000000046c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 46c:	1101                	addi	sp,sp,-32
 46e:	ec06                	sd	ra,24(sp)
 470:	e822                	sd	s0,16(sp)
 472:	1000                	addi	s0,sp,32
 474:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 478:	4605                	li	a2,1
 47a:	fef40593          	addi	a1,s0,-17
 47e:	f25ff0ef          	jal	3a2 <write>
}
 482:	60e2                	ld	ra,24(sp)
 484:	6442                	ld	s0,16(sp)
 486:	6105                	addi	sp,sp,32
 488:	8082                	ret

000000000000048a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 48a:	715d                	addi	sp,sp,-80
 48c:	e486                	sd	ra,72(sp)
 48e:	e0a2                	sd	s0,64(sp)
 490:	f84a                	sd	s2,48(sp)
 492:	f44e                	sd	s3,40(sp)
 494:	0880                	addi	s0,sp,80
 496:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 498:	c6d1                	beqz	a3,524 <printint+0x9a>
 49a:	0805d563          	bgez	a1,524 <printint+0x9a>
    neg = 1;
    x = -xx;
 49e:	40b005b3          	neg	a1,a1
    neg = 1;
 4a2:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4a4:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4a8:	86ce                	mv	a3,s3
  i = 0;
 4aa:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4ac:	00000817          	auipc	a6,0x0
 4b0:	62c80813          	addi	a6,a6,1580 # ad8 <digits>
 4b4:	88ba                	mv	a7,a4
 4b6:	0017051b          	addiw	a0,a4,1
 4ba:	872a                	mv	a4,a0
 4bc:	02c5f7b3          	remu	a5,a1,a2
 4c0:	97c2                	add	a5,a5,a6
 4c2:	0007c783          	lbu	a5,0(a5)
 4c6:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4ca:	87ae                	mv	a5,a1
 4cc:	02c5d5b3          	divu	a1,a1,a2
 4d0:	0685                	addi	a3,a3,1
 4d2:	fec7f1e3          	bgeu	a5,a2,4b4 <printint+0x2a>
  if(neg)
 4d6:	00030c63          	beqz	t1,4ee <printint+0x64>
    buf[i++] = '-';
 4da:	fd050793          	addi	a5,a0,-48
 4de:	00878533          	add	a0,a5,s0
 4e2:	02d00793          	li	a5,45
 4e6:	fef50423          	sb	a5,-24(a0)
 4ea:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4ee:	02e05563          	blez	a4,518 <printint+0x8e>
 4f2:	fc26                	sd	s1,56(sp)
 4f4:	377d                	addiw	a4,a4,-1
 4f6:	00e984b3          	add	s1,s3,a4
 4fa:	19fd                	addi	s3,s3,-1
 4fc:	99ba                	add	s3,s3,a4
 4fe:	1702                	slli	a4,a4,0x20
 500:	9301                	srli	a4,a4,0x20
 502:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 506:	0004c583          	lbu	a1,0(s1)
 50a:	854a                	mv	a0,s2
 50c:	f61ff0ef          	jal	46c <putc>
  while(--i >= 0)
 510:	14fd                	addi	s1,s1,-1
 512:	ff349ae3          	bne	s1,s3,506 <printint+0x7c>
 516:	74e2                	ld	s1,56(sp)
}
 518:	60a6                	ld	ra,72(sp)
 51a:	6406                	ld	s0,64(sp)
 51c:	7942                	ld	s2,48(sp)
 51e:	79a2                	ld	s3,40(sp)
 520:	6161                	addi	sp,sp,80
 522:	8082                	ret
  neg = 0;
 524:	4301                	li	t1,0
 526:	bfbd                	j	4a4 <printint+0x1a>

0000000000000528 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 528:	711d                	addi	sp,sp,-96
 52a:	ec86                	sd	ra,88(sp)
 52c:	e8a2                	sd	s0,80(sp)
 52e:	e4a6                	sd	s1,72(sp)
 530:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 532:	0005c483          	lbu	s1,0(a1)
 536:	22048363          	beqz	s1,75c <vprintf+0x234>
 53a:	e0ca                	sd	s2,64(sp)
 53c:	fc4e                	sd	s3,56(sp)
 53e:	f852                	sd	s4,48(sp)
 540:	f456                	sd	s5,40(sp)
 542:	f05a                	sd	s6,32(sp)
 544:	ec5e                	sd	s7,24(sp)
 546:	e862                	sd	s8,16(sp)
 548:	8b2a                	mv	s6,a0
 54a:	8a2e                	mv	s4,a1
 54c:	8bb2                	mv	s7,a2
  state = 0;
 54e:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 550:	4901                	li	s2,0
 552:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 554:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 558:	06400c13          	li	s8,100
 55c:	a00d                	j	57e <vprintf+0x56>
        putc(fd, c0);
 55e:	85a6                	mv	a1,s1
 560:	855a                	mv	a0,s6
 562:	f0bff0ef          	jal	46c <putc>
 566:	a019                	j	56c <vprintf+0x44>
    } else if(state == '%'){
 568:	03598363          	beq	s3,s5,58e <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 56c:	0019079b          	addiw	a5,s2,1
 570:	893e                	mv	s2,a5
 572:	873e                	mv	a4,a5
 574:	97d2                	add	a5,a5,s4
 576:	0007c483          	lbu	s1,0(a5)
 57a:	1c048a63          	beqz	s1,74e <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 57e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 582:	fe0993e3          	bnez	s3,568 <vprintf+0x40>
      if(c0 == '%'){
 586:	fd579ce3          	bne	a5,s5,55e <vprintf+0x36>
        state = '%';
 58a:	89be                	mv	s3,a5
 58c:	b7c5                	j	56c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 58e:	00ea06b3          	add	a3,s4,a4
 592:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 596:	1c060863          	beqz	a2,766 <vprintf+0x23e>
      if(c0 == 'd'){
 59a:	03878763          	beq	a5,s8,5c8 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 59e:	f9478693          	addi	a3,a5,-108
 5a2:	0016b693          	seqz	a3,a3
 5a6:	f9c60593          	addi	a1,a2,-100
 5aa:	e99d                	bnez	a1,5e0 <vprintf+0xb8>
 5ac:	ca95                	beqz	a3,5e0 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000bb583          	ld	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	ecfff0ef          	jal	48a <printint>
        i += 1;
 5c0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5c2:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5c4:	4981                	li	s3,0
 5c6:	b75d                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5c8:	008b8493          	addi	s1,s7,8
 5cc:	4685                	li	a3,1
 5ce:	4629                	li	a2,10
 5d0:	000ba583          	lw	a1,0(s7)
 5d4:	855a                	mv	a0,s6
 5d6:	eb5ff0ef          	jal	48a <printint>
 5da:	8ba6                	mv	s7,s1
      state = 0;
 5dc:	4981                	li	s3,0
 5de:	b779                	j	56c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5e0:	9752                	add	a4,a4,s4
 5e2:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5e6:	f9460713          	addi	a4,a2,-108
 5ea:	00173713          	seqz	a4,a4
 5ee:	8f75                	and	a4,a4,a3
 5f0:	f9c58513          	addi	a0,a1,-100
 5f4:	18051363          	bnez	a0,77a <vprintf+0x252>
 5f8:	18070163          	beqz	a4,77a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5fc:	008b8493          	addi	s1,s7,8
 600:	4685                	li	a3,1
 602:	4629                	li	a2,10
 604:	000bb583          	ld	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	e81ff0ef          	jal	48a <printint>
        i += 2;
 60e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 610:	8ba6                	mv	s7,s1
      state = 0;
 612:	4981                	li	s3,0
        i += 2;
 614:	bfa1                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 616:	008b8493          	addi	s1,s7,8
 61a:	4681                	li	a3,0
 61c:	4629                	li	a2,10
 61e:	000be583          	lwu	a1,0(s7)
 622:	855a                	mv	a0,s6
 624:	e67ff0ef          	jal	48a <printint>
 628:	8ba6                	mv	s7,s1
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b781                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	008b8493          	addi	s1,s7,8
 632:	4681                	li	a3,0
 634:	4629                	li	a2,10
 636:	000bb583          	ld	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	e4fff0ef          	jal	48a <printint>
        i += 1;
 640:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
 646:	b71d                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 648:	008b8493          	addi	s1,s7,8
 64c:	4681                	li	a3,0
 64e:	4629                	li	a2,10
 650:	000bb583          	ld	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	e35ff0ef          	jal	48a <printint>
        i += 2;
 65a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 65c:	8ba6                	mv	s7,s1
      state = 0;
 65e:	4981                	li	s3,0
        i += 2;
 660:	b731                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 662:	008b8493          	addi	s1,s7,8
 666:	4681                	li	a3,0
 668:	4641                	li	a2,16
 66a:	000be583          	lwu	a1,0(s7)
 66e:	855a                	mv	a0,s6
 670:	e1bff0ef          	jal	48a <printint>
 674:	8ba6                	mv	s7,s1
      state = 0;
 676:	4981                	li	s3,0
 678:	bdd5                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 67a:	008b8493          	addi	s1,s7,8
 67e:	4681                	li	a3,0
 680:	4641                	li	a2,16
 682:	000bb583          	ld	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	e03ff0ef          	jal	48a <printint>
        i += 1;
 68c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 68e:	8ba6                	mv	s7,s1
      state = 0;
 690:	4981                	li	s3,0
 692:	bde9                	j	56c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 694:	008b8493          	addi	s1,s7,8
 698:	4681                	li	a3,0
 69a:	4641                	li	a2,16
 69c:	000bb583          	ld	a1,0(s7)
 6a0:	855a                	mv	a0,s6
 6a2:	de9ff0ef          	jal	48a <printint>
        i += 2;
 6a6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6a8:	8ba6                	mv	s7,s1
      state = 0;
 6aa:	4981                	li	s3,0
        i += 2;
 6ac:	b5c1                	j	56c <vprintf+0x44>
 6ae:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6b0:	008b8793          	addi	a5,s7,8
 6b4:	8cbe                	mv	s9,a5
 6b6:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ba:	03000593          	li	a1,48
 6be:	855a                	mv	a0,s6
 6c0:	dadff0ef          	jal	46c <putc>
  putc(fd, 'x');
 6c4:	07800593          	li	a1,120
 6c8:	855a                	mv	a0,s6
 6ca:	da3ff0ef          	jal	46c <putc>
 6ce:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6d0:	00000b97          	auipc	s7,0x0
 6d4:	408b8b93          	addi	s7,s7,1032 # ad8 <digits>
 6d8:	03c9d793          	srli	a5,s3,0x3c
 6dc:	97de                	add	a5,a5,s7
 6de:	0007c583          	lbu	a1,0(a5)
 6e2:	855a                	mv	a0,s6
 6e4:	d89ff0ef          	jal	46c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6e8:	0992                	slli	s3,s3,0x4
 6ea:	34fd                	addiw	s1,s1,-1
 6ec:	f4f5                	bnez	s1,6d8 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6ee:	8be6                	mv	s7,s9
      state = 0;
 6f0:	4981                	li	s3,0
 6f2:	6ca2                	ld	s9,8(sp)
 6f4:	bda5                	j	56c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6f6:	008b8493          	addi	s1,s7,8
 6fa:	000bc583          	lbu	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	d6dff0ef          	jal	46c <putc>
 704:	8ba6                	mv	s7,s1
      state = 0;
 706:	4981                	li	s3,0
 708:	b595                	j	56c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 70a:	008b8993          	addi	s3,s7,8
 70e:	000bb483          	ld	s1,0(s7)
 712:	cc91                	beqz	s1,72e <vprintf+0x206>
        for(; *s; s++)
 714:	0004c583          	lbu	a1,0(s1)
 718:	c985                	beqz	a1,748 <vprintf+0x220>
          putc(fd, *s);
 71a:	855a                	mv	a0,s6
 71c:	d51ff0ef          	jal	46c <putc>
        for(; *s; s++)
 720:	0485                	addi	s1,s1,1
 722:	0004c583          	lbu	a1,0(s1)
 726:	f9f5                	bnez	a1,71a <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 728:	8bce                	mv	s7,s3
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b581                	j	56c <vprintf+0x44>
          s = "(null)";
 72e:	00000497          	auipc	s1,0x0
 732:	38a48493          	addi	s1,s1,906 # ab8 <statistics+0xfc>
        for(; *s; s++)
 736:	02800593          	li	a1,40
 73a:	b7c5                	j	71a <vprintf+0x1f2>
        putc(fd, '%');
 73c:	85be                	mv	a1,a5
 73e:	855a                	mv	a0,s6
 740:	d2dff0ef          	jal	46c <putc>
      state = 0;
 744:	4981                	li	s3,0
 746:	b51d                	j	56c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 748:	8bce                	mv	s7,s3
      state = 0;
 74a:	4981                	li	s3,0
 74c:	b505                	j	56c <vprintf+0x44>
 74e:	6906                	ld	s2,64(sp)
 750:	79e2                	ld	s3,56(sp)
 752:	7a42                	ld	s4,48(sp)
 754:	7aa2                	ld	s5,40(sp)
 756:	7b02                	ld	s6,32(sp)
 758:	6be2                	ld	s7,24(sp)
 75a:	6c42                	ld	s8,16(sp)
    }
  }
}
 75c:	60e6                	ld	ra,88(sp)
 75e:	6446                	ld	s0,80(sp)
 760:	64a6                	ld	s1,72(sp)
 762:	6125                	addi	sp,sp,96
 764:	8082                	ret
      if(c0 == 'd'){
 766:	06400713          	li	a4,100
 76a:	e4e78fe3          	beq	a5,a4,5c8 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 76e:	f9478693          	addi	a3,a5,-108
 772:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 776:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 778:	4701                	li	a4,0
      } else if(c0 == 'u'){
 77a:	07500513          	li	a0,117
 77e:	e8a78ce3          	beq	a5,a0,616 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 782:	f8b60513          	addi	a0,a2,-117
 786:	e119                	bnez	a0,78c <vprintf+0x264>
 788:	ea0693e3          	bnez	a3,62e <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 78c:	f8b58513          	addi	a0,a1,-117
 790:	e119                	bnez	a0,796 <vprintf+0x26e>
 792:	ea071be3          	bnez	a4,648 <vprintf+0x120>
      } else if(c0 == 'x'){
 796:	07800513          	li	a0,120
 79a:	eca784e3          	beq	a5,a0,662 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 79e:	f8860613          	addi	a2,a2,-120
 7a2:	e219                	bnez	a2,7a8 <vprintf+0x280>
 7a4:	ec069be3          	bnez	a3,67a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7a8:	f8858593          	addi	a1,a1,-120
 7ac:	e199                	bnez	a1,7b2 <vprintf+0x28a>
 7ae:	ee0713e3          	bnez	a4,694 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7b2:	07000713          	li	a4,112
 7b6:	eee78ce3          	beq	a5,a4,6ae <vprintf+0x186>
      } else if(c0 == 'c'){
 7ba:	06300713          	li	a4,99
 7be:	f2e78ce3          	beq	a5,a4,6f6 <vprintf+0x1ce>
      } else if(c0 == 's'){
 7c2:	07300713          	li	a4,115
 7c6:	f4e782e3          	beq	a5,a4,70a <vprintf+0x1e2>
      } else if(c0 == '%'){
 7ca:	02500713          	li	a4,37
 7ce:	f6e787e3          	beq	a5,a4,73c <vprintf+0x214>
        putc(fd, '%');
 7d2:	02500593          	li	a1,37
 7d6:	855a                	mv	a0,s6
 7d8:	c95ff0ef          	jal	46c <putc>
        putc(fd, c0);
 7dc:	85a6                	mv	a1,s1
 7de:	855a                	mv	a0,s6
 7e0:	c8dff0ef          	jal	46c <putc>
      state = 0;
 7e4:	4981                	li	s3,0
 7e6:	b359                	j	56c <vprintf+0x44>

00000000000007e8 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7e8:	715d                	addi	sp,sp,-80
 7ea:	ec06                	sd	ra,24(sp)
 7ec:	e822                	sd	s0,16(sp)
 7ee:	1000                	addi	s0,sp,32
 7f0:	e010                	sd	a2,0(s0)
 7f2:	e414                	sd	a3,8(s0)
 7f4:	e818                	sd	a4,16(s0)
 7f6:	ec1c                	sd	a5,24(s0)
 7f8:	03043023          	sd	a6,32(s0)
 7fc:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 800:	8622                	mv	a2,s0
 802:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 806:	d23ff0ef          	jal	528 <vprintf>
}
 80a:	60e2                	ld	ra,24(sp)
 80c:	6442                	ld	s0,16(sp)
 80e:	6161                	addi	sp,sp,80
 810:	8082                	ret

0000000000000812 <printf>:

void
printf(const char *fmt, ...)
{
 812:	711d                	addi	sp,sp,-96
 814:	ec06                	sd	ra,24(sp)
 816:	e822                	sd	s0,16(sp)
 818:	1000                	addi	s0,sp,32
 81a:	e40c                	sd	a1,8(s0)
 81c:	e810                	sd	a2,16(s0)
 81e:	ec14                	sd	a3,24(s0)
 820:	f018                	sd	a4,32(s0)
 822:	f41c                	sd	a5,40(s0)
 824:	03043823          	sd	a6,48(s0)
 828:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 82c:	00840613          	addi	a2,s0,8
 830:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 834:	85aa                	mv	a1,a0
 836:	4505                	li	a0,1
 838:	cf1ff0ef          	jal	528 <vprintf>
}
 83c:	60e2                	ld	ra,24(sp)
 83e:	6442                	ld	s0,16(sp)
 840:	6125                	addi	sp,sp,96
 842:	8082                	ret

0000000000000844 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 844:	1141                	addi	sp,sp,-16
 846:	e406                	sd	ra,8(sp)
 848:	e022                	sd	s0,0(sp)
 84a:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 84c:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 850:	00000797          	auipc	a5,0x0
 854:	7c07b783          	ld	a5,1984(a5) # 1010 <freep>
 858:	a039                	j	866 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 85a:	6398                	ld	a4,0(a5)
 85c:	00e7e463          	bltu	a5,a4,864 <free+0x20>
 860:	00e6ea63          	bltu	a3,a4,874 <free+0x30>
{
 864:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 866:	fed7fae3          	bgeu	a5,a3,85a <free+0x16>
 86a:	6398                	ld	a4,0(a5)
 86c:	00e6e463          	bltu	a3,a4,874 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 870:	fee7eae3          	bltu	a5,a4,864 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 874:	ff852583          	lw	a1,-8(a0)
 878:	6390                	ld	a2,0(a5)
 87a:	02059813          	slli	a6,a1,0x20
 87e:	01c85713          	srli	a4,a6,0x1c
 882:	9736                	add	a4,a4,a3
 884:	02e60563          	beq	a2,a4,8ae <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 888:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 88c:	4790                	lw	a2,8(a5)
 88e:	02061593          	slli	a1,a2,0x20
 892:	01c5d713          	srli	a4,a1,0x1c
 896:	973e                	add	a4,a4,a5
 898:	02e68263          	beq	a3,a4,8bc <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 89c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 89e:	00000717          	auipc	a4,0x0
 8a2:	76f73923          	sd	a5,1906(a4) # 1010 <freep>
}
 8a6:	60a2                	ld	ra,8(sp)
 8a8:	6402                	ld	s0,0(sp)
 8aa:	0141                	addi	sp,sp,16
 8ac:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8ae:	4618                	lw	a4,8(a2)
 8b0:	9f2d                	addw	a4,a4,a1
 8b2:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8b6:	6398                	ld	a4,0(a5)
 8b8:	6310                	ld	a2,0(a4)
 8ba:	b7f9                	j	888 <free+0x44>
    p->s.size += bp->s.size;
 8bc:	ff852703          	lw	a4,-8(a0)
 8c0:	9f31                	addw	a4,a4,a2
 8c2:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8c4:	ff053683          	ld	a3,-16(a0)
 8c8:	bfd1                	j	89c <free+0x58>

00000000000008ca <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8ca:	7139                	addi	sp,sp,-64
 8cc:	fc06                	sd	ra,56(sp)
 8ce:	f822                	sd	s0,48(sp)
 8d0:	f04a                	sd	s2,32(sp)
 8d2:	ec4e                	sd	s3,24(sp)
 8d4:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8d6:	02051993          	slli	s3,a0,0x20
 8da:	0209d993          	srli	s3,s3,0x20
 8de:	09bd                	addi	s3,s3,15
 8e0:	0049d993          	srli	s3,s3,0x4
 8e4:	2985                	addiw	s3,s3,1
 8e6:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8e8:	00000517          	auipc	a0,0x0
 8ec:	72853503          	ld	a0,1832(a0) # 1010 <freep>
 8f0:	c905                	beqz	a0,920 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8f2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8f4:	4798                	lw	a4,8(a5)
 8f6:	09377663          	bgeu	a4,s3,982 <malloc+0xb8>
 8fa:	f426                	sd	s1,40(sp)
 8fc:	e852                	sd	s4,16(sp)
 8fe:	e456                	sd	s5,8(sp)
 900:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 902:	8a4e                	mv	s4,s3
 904:	6705                	lui	a4,0x1
 906:	00e9f363          	bgeu	s3,a4,90c <malloc+0x42>
 90a:	6a05                	lui	s4,0x1
 90c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 910:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 914:	00000497          	auipc	s1,0x0
 918:	6fc48493          	addi	s1,s1,1788 # 1010 <freep>
  if(p == SBRK_ERROR)
 91c:	5afd                	li	s5,-1
 91e:	a83d                	j	95c <malloc+0x92>
 920:	f426                	sd	s1,40(sp)
 922:	e852                	sd	s4,16(sp)
 924:	e456                	sd	s5,8(sp)
 926:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 928:	00000797          	auipc	a5,0x0
 92c:	6f878793          	addi	a5,a5,1784 # 1020 <base>
 930:	00000717          	auipc	a4,0x0
 934:	6ef73023          	sd	a5,1760(a4) # 1010 <freep>
 938:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 93a:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 93e:	b7d1                	j	902 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 940:	6398                	ld	a4,0(a5)
 942:	e118                	sd	a4,0(a0)
 944:	a899                	j	99a <malloc+0xd0>
  hp->s.size = nu;
 946:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 94a:	0541                	addi	a0,a0,16
 94c:	ef9ff0ef          	jal	844 <free>
  return freep;
 950:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 952:	c125                	beqz	a0,9b2 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 954:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 956:	4798                	lw	a4,8(a5)
 958:	03277163          	bgeu	a4,s2,97a <malloc+0xb0>
    if(p == freep)
 95c:	6098                	ld	a4,0(s1)
 95e:	853e                	mv	a0,a5
 960:	fef71ae3          	bne	a4,a5,954 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 964:	8552                	mv	a0,s4
 966:	9e9ff0ef          	jal	34e <sbrk>
  if(p == SBRK_ERROR)
 96a:	fd551ee3          	bne	a0,s5,946 <malloc+0x7c>
        return 0;
 96e:	4501                	li	a0,0
 970:	74a2                	ld	s1,40(sp)
 972:	6a42                	ld	s4,16(sp)
 974:	6aa2                	ld	s5,8(sp)
 976:	6b02                	ld	s6,0(sp)
 978:	a03d                	j	9a6 <malloc+0xdc>
 97a:	74a2                	ld	s1,40(sp)
 97c:	6a42                	ld	s4,16(sp)
 97e:	6aa2                	ld	s5,8(sp)
 980:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 982:	fae90fe3          	beq	s2,a4,940 <malloc+0x76>
        p->s.size -= nunits;
 986:	4137073b          	subw	a4,a4,s3
 98a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 98c:	02071693          	slli	a3,a4,0x20
 990:	01c6d713          	srli	a4,a3,0x1c
 994:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 996:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 99a:	00000717          	auipc	a4,0x0
 99e:	66a73b23          	sd	a0,1654(a4) # 1010 <freep>
      return (void*)(p + 1);
 9a2:	01078513          	addi	a0,a5,16
  }
}
 9a6:	70e2                	ld	ra,56(sp)
 9a8:	7442                	ld	s0,48(sp)
 9aa:	7902                	ld	s2,32(sp)
 9ac:	69e2                	ld	s3,24(sp)
 9ae:	6121                	addi	sp,sp,64
 9b0:	8082                	ret
 9b2:	74a2                	ld	s1,40(sp)
 9b4:	6a42                	ld	s4,16(sp)
 9b6:	6aa2                	ld	s5,8(sp)
 9b8:	6b02                	ld	s6,0(sp)
 9ba:	b7f5                	j	9a6 <malloc+0xdc>

00000000000009bc <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 9bc:	7179                	addi	sp,sp,-48
 9be:	f406                	sd	ra,40(sp)
 9c0:	f022                	sd	s0,32(sp)
 9c2:	ec26                	sd	s1,24(sp)
 9c4:	e84a                	sd	s2,16(sp)
 9c6:	e44e                	sd	s3,8(sp)
 9c8:	e052                	sd	s4,0(sp)
 9ca:	1800                	addi	s0,sp,48
 9cc:	8a2a                	mv	s4,a0
 9ce:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 9d0:	4581                	li	a1,0
 9d2:	00000517          	auipc	a0,0x0
 9d6:	06650513          	addi	a0,a0,102 # a38 <statistics+0x7c>
 9da:	9e9ff0ef          	jal	3c2 <open>
  if(fd < 0) {
 9de:	02054e63          	bltz	a0,a1a <statistics+0x5e>
 9e2:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 9e4:	4481                	li	s1,0
 9e6:	01205e63          	blez	s2,a02 <statistics+0x46>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 9ea:	4099063b          	subw	a2,s2,s1
 9ee:	009a05b3          	add	a1,s4,s1
 9f2:	854e                	mv	a0,s3
 9f4:	9a7ff0ef          	jal	39a <read>
 9f8:	00054563          	bltz	a0,a02 <statistics+0x46>
      break;
    }
    i += n;
 9fc:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 9fe:	ff24c6e3          	blt	s1,s2,9ea <statistics+0x2e>
  }
  close(fd);
 a02:	854e                	mv	a0,s3
 a04:	9a7ff0ef          	jal	3aa <close>
  return i;
}
 a08:	8526                	mv	a0,s1
 a0a:	70a2                	ld	ra,40(sp)
 a0c:	7402                	ld	s0,32(sp)
 a0e:	64e2                	ld	s1,24(sp)
 a10:	6942                	ld	s2,16(sp)
 a12:	69a2                	ld	s3,8(sp)
 a14:	6a02                	ld	s4,0(sp)
 a16:	6145                	addi	sp,sp,48
 a18:	8082                	ret
      fprintf(2, "stats: open failed\n");
 a1a:	00000597          	auipc	a1,0x0
 a1e:	0a658593          	addi	a1,a1,166 # ac0 <statistics+0x104>
 a22:	4509                	li	a0,2
 a24:	dc5ff0ef          	jal	7e8 <fprintf>
      exit(1);
 a28:	4505                	li	a0,1
 a2a:	959ff0ef          	jal	382 <exit>
