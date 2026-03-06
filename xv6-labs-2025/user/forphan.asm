
user/_forphan:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:

char buf[BUFSZ];

int
main(int argc, char **argv)
{
   0:	7139                	addi	sp,sp,-64
   2:	fc06                	sd	ra,56(sp)
   4:	f822                	sd	s0,48(sp)
   6:	f426                	sd	s1,40(sp)
   8:	0080                	addi	s0,sp,64
  int fd = 0;
  char *s = argv[0];
   a:	6184                	ld	s1,0(a1)
  struct stat st;
  char *ff = "file0";
  
  if ((fd = open(ff, O_CREATE|O_WRONLY)) < 0) {
   c:	20100593          	li	a1,513
  10:	00001517          	auipc	a0,0x1
  14:	9a050513          	addi	a0,a0,-1632 # 9b0 <malloc+0x100>
  18:	3a4000ef          	jal	3bc <open>
  1c:	04054463          	bltz	a0,64 <main+0x64>
    printf("%s: open failed\n", s);
    exit(1);
  }
  if(fstat(fd, &st) < 0){
  20:	fc840593          	addi	a1,s0,-56
  24:	3b0000ef          	jal	3d4 <fstat>
  28:	04054863          	bltz	a0,78 <main+0x78>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
    exit(1);
  }
  if (unlink(ff) < 0) {
  2c:	00001517          	auipc	a0,0x1
  30:	98450513          	addi	a0,a0,-1660 # 9b0 <malloc+0x100>
  34:	398000ef          	jal	3cc <unlink>
  38:	04054f63          	bltz	a0,96 <main+0x96>
    printf("%s: unlink failed\n", s);
    exit(1);
  }
  if (open(ff, O_RDONLY) != -1) {
  3c:	4581                	li	a1,0
  3e:	00001517          	auipc	a0,0x1
  42:	97250513          	addi	a0,a0,-1678 # 9b0 <malloc+0x100>
  46:	376000ef          	jal	3bc <open>
  4a:	57fd                	li	a5,-1
  4c:	04f50f63          	beq	a0,a5,aa <main+0xaa>
    printf("%s: open successed\n", s);
  50:	85a6                	mv	a1,s1
  52:	00001517          	auipc	a0,0x1
  56:	9be50513          	addi	a0,a0,-1602 # a10 <malloc+0x160>
  5a:	79e000ef          	jal	7f8 <printf>
    exit(1);
  5e:	4505                	li	a0,1
  60:	31c000ef          	jal	37c <exit>
    printf("%s: open failed\n", s);
  64:	85a6                	mv	a1,s1
  66:	00001517          	auipc	a0,0x1
  6a:	95a50513          	addi	a0,a0,-1702 # 9c0 <malloc+0x110>
  6e:	78a000ef          	jal	7f8 <printf>
    exit(1);
  72:	4505                	li	a0,1
  74:	308000ef          	jal	37c <exit>
    fprintf(2, "%s: cannot stat %s\n", s, "ff");
  78:	00001697          	auipc	a3,0x1
  7c:	96068693          	addi	a3,a3,-1696 # 9d8 <malloc+0x128>
  80:	8626                	mv	a2,s1
  82:	00001597          	auipc	a1,0x1
  86:	95e58593          	addi	a1,a1,-1698 # 9e0 <malloc+0x130>
  8a:	4509                	li	a0,2
  8c:	742000ef          	jal	7ce <fprintf>
    exit(1);
  90:	4505                	li	a0,1
  92:	2ea000ef          	jal	37c <exit>
    printf("%s: unlink failed\n", s);
  96:	85a6                	mv	a1,s1
  98:	00001517          	auipc	a0,0x1
  9c:	96050513          	addi	a0,a0,-1696 # 9f8 <malloc+0x148>
  a0:	758000ef          	jal	7f8 <printf>
    exit(1);
  a4:	4505                	li	a0,1
  a6:	2d6000ef          	jal	37c <exit>
  }
  printf("wait for kill and reclaim %d\n", st.ino);
  aa:	fcc42583          	lw	a1,-52(s0)
  ae:	00001517          	auipc	a0,0x1
  b2:	97a50513          	addi	a0,a0,-1670 # a28 <malloc+0x178>
  b6:	742000ef          	jal	7f8 <printf>
  // sit around until killed
  for(;;) pause(1000);
  ba:	3e800493          	li	s1,1000
  be:	8526                	mv	a0,s1
  c0:	34c000ef          	jal	40c <pause>
  c4:	bfed                	j	be <main+0xbe>

00000000000000c6 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
  c6:	1141                	addi	sp,sp,-16
  c8:	e406                	sd	ra,8(sp)
  ca:	e022                	sd	s0,0(sp)
  cc:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
  ce:	f33ff0ef          	jal	0 <main>
  exit(r);
  d2:	2aa000ef          	jal	37c <exit>

00000000000000d6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
  d6:	1141                	addi	sp,sp,-16
  d8:	e406                	sd	ra,8(sp)
  da:	e022                	sd	s0,0(sp)
  dc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  de:	87aa                	mv	a5,a0
  e0:	0585                	addi	a1,a1,1
  e2:	0785                	addi	a5,a5,1
  e4:	fff5c703          	lbu	a4,-1(a1)
  e8:	fee78fa3          	sb	a4,-1(a5)
  ec:	fb75                	bnez	a4,e0 <strcpy+0xa>
    ;
  return os;
}
  ee:	60a2                	ld	ra,8(sp)
  f0:	6402                	ld	s0,0(sp)
  f2:	0141                	addi	sp,sp,16
  f4:	8082                	ret

00000000000000f6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  f6:	1141                	addi	sp,sp,-16
  f8:	e406                	sd	ra,8(sp)
  fa:	e022                	sd	s0,0(sp)
  fc:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
  fe:	00054783          	lbu	a5,0(a0)
 102:	cb91                	beqz	a5,116 <strcmp+0x20>
 104:	0005c703          	lbu	a4,0(a1)
 108:	00f71763          	bne	a4,a5,116 <strcmp+0x20>
    p++, q++;
 10c:	0505                	addi	a0,a0,1
 10e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 110:	00054783          	lbu	a5,0(a0)
 114:	fbe5                	bnez	a5,104 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 116:	0005c503          	lbu	a0,0(a1)
}
 11a:	40a7853b          	subw	a0,a5,a0
 11e:	60a2                	ld	ra,8(sp)
 120:	6402                	ld	s0,0(sp)
 122:	0141                	addi	sp,sp,16
 124:	8082                	ret

0000000000000126 <strlen>:

uint
strlen(const char *s)
{
 126:	1141                	addi	sp,sp,-16
 128:	e406                	sd	ra,8(sp)
 12a:	e022                	sd	s0,0(sp)
 12c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 12e:	00054783          	lbu	a5,0(a0)
 132:	cf91                	beqz	a5,14e <strlen+0x28>
 134:	00150793          	addi	a5,a0,1
 138:	86be                	mv	a3,a5
 13a:	0785                	addi	a5,a5,1
 13c:	fff7c703          	lbu	a4,-1(a5)
 140:	ff65                	bnez	a4,138 <strlen+0x12>
 142:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 146:	60a2                	ld	ra,8(sp)
 148:	6402                	ld	s0,0(sp)
 14a:	0141                	addi	sp,sp,16
 14c:	8082                	ret
  for(n = 0; s[n]; n++)
 14e:	4501                	li	a0,0
 150:	bfdd                	j	146 <strlen+0x20>

0000000000000152 <memset>:

void*
memset(void *dst, int c, uint n)
{
 152:	1141                	addi	sp,sp,-16
 154:	e406                	sd	ra,8(sp)
 156:	e022                	sd	s0,0(sp)
 158:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 15a:	ca19                	beqz	a2,170 <memset+0x1e>
 15c:	87aa                	mv	a5,a0
 15e:	1602                	slli	a2,a2,0x20
 160:	9201                	srli	a2,a2,0x20
 162:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 166:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 16a:	0785                	addi	a5,a5,1
 16c:	fee79de3          	bne	a5,a4,166 <memset+0x14>
  }
  return dst;
}
 170:	60a2                	ld	ra,8(sp)
 172:	6402                	ld	s0,0(sp)
 174:	0141                	addi	sp,sp,16
 176:	8082                	ret

0000000000000178 <strchr>:

char*
strchr(const char *s, char c)
{
 178:	1141                	addi	sp,sp,-16
 17a:	e406                	sd	ra,8(sp)
 17c:	e022                	sd	s0,0(sp)
 17e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 180:	00054783          	lbu	a5,0(a0)
 184:	cf81                	beqz	a5,19c <strchr+0x24>
    if(*s == c)
 186:	00f58763          	beq	a1,a5,194 <strchr+0x1c>
  for(; *s; s++)
 18a:	0505                	addi	a0,a0,1
 18c:	00054783          	lbu	a5,0(a0)
 190:	fbfd                	bnez	a5,186 <strchr+0xe>
      return (char*)s;
  return 0;
 192:	4501                	li	a0,0
}
 194:	60a2                	ld	ra,8(sp)
 196:	6402                	ld	s0,0(sp)
 198:	0141                	addi	sp,sp,16
 19a:	8082                	ret
  return 0;
 19c:	4501                	li	a0,0
 19e:	bfdd                	j	194 <strchr+0x1c>

00000000000001a0 <gets>:

char*
gets(char *buf, int max)
{
 1a0:	711d                	addi	sp,sp,-96
 1a2:	ec86                	sd	ra,88(sp)
 1a4:	e8a2                	sd	s0,80(sp)
 1a6:	e4a6                	sd	s1,72(sp)
 1a8:	e0ca                	sd	s2,64(sp)
 1aa:	fc4e                	sd	s3,56(sp)
 1ac:	f852                	sd	s4,48(sp)
 1ae:	f456                	sd	s5,40(sp)
 1b0:	f05a                	sd	s6,32(sp)
 1b2:	ec5e                	sd	s7,24(sp)
 1b4:	e862                	sd	s8,16(sp)
 1b6:	1080                	addi	s0,sp,96
 1b8:	8baa                	mv	s7,a0
 1ba:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1bc:	892a                	mv	s2,a0
 1be:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1c0:	faf40b13          	addi	s6,s0,-81
 1c4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1c6:	8c26                	mv	s8,s1
 1c8:	0014899b          	addiw	s3,s1,1
 1cc:	84ce                	mv	s1,s3
 1ce:	0349d463          	bge	s3,s4,1f6 <gets+0x56>
    cc = read(0, &c, 1);
 1d2:	8656                	mv	a2,s5
 1d4:	85da                	mv	a1,s6
 1d6:	4501                	li	a0,0
 1d8:	1bc000ef          	jal	394 <read>
    if(cc < 1)
 1dc:	00a05d63          	blez	a0,1f6 <gets+0x56>
      break;
    buf[i++] = c;
 1e0:	faf44783          	lbu	a5,-81(s0)
 1e4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 1e8:	0905                	addi	s2,s2,1
 1ea:	ff678713          	addi	a4,a5,-10
 1ee:	c319                	beqz	a4,1f4 <gets+0x54>
 1f0:	17cd                	addi	a5,a5,-13
 1f2:	fbf1                	bnez	a5,1c6 <gets+0x26>
    buf[i++] = c;
 1f4:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 1f6:	9c5e                	add	s8,s8,s7
 1f8:	000c0023          	sb	zero,0(s8)
  return buf;
}
 1fc:	855e                	mv	a0,s7
 1fe:	60e6                	ld	ra,88(sp)
 200:	6446                	ld	s0,80(sp)
 202:	64a6                	ld	s1,72(sp)
 204:	6906                	ld	s2,64(sp)
 206:	79e2                	ld	s3,56(sp)
 208:	7a42                	ld	s4,48(sp)
 20a:	7aa2                	ld	s5,40(sp)
 20c:	7b02                	ld	s6,32(sp)
 20e:	6be2                	ld	s7,24(sp)
 210:	6c42                	ld	s8,16(sp)
 212:	6125                	addi	sp,sp,96
 214:	8082                	ret

0000000000000216 <stat>:

int
stat(const char *n, struct stat *st)
{
 216:	1101                	addi	sp,sp,-32
 218:	ec06                	sd	ra,24(sp)
 21a:	e822                	sd	s0,16(sp)
 21c:	e04a                	sd	s2,0(sp)
 21e:	1000                	addi	s0,sp,32
 220:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 222:	4581                	li	a1,0
 224:	198000ef          	jal	3bc <open>
  if(fd < 0)
 228:	02054263          	bltz	a0,24c <stat+0x36>
 22c:	e426                	sd	s1,8(sp)
 22e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 230:	85ca                	mv	a1,s2
 232:	1a2000ef          	jal	3d4 <fstat>
 236:	892a                	mv	s2,a0
  close(fd);
 238:	8526                	mv	a0,s1
 23a:	16a000ef          	jal	3a4 <close>
  return r;
 23e:	64a2                	ld	s1,8(sp)
}
 240:	854a                	mv	a0,s2
 242:	60e2                	ld	ra,24(sp)
 244:	6442                	ld	s0,16(sp)
 246:	6902                	ld	s2,0(sp)
 248:	6105                	addi	sp,sp,32
 24a:	8082                	ret
    return -1;
 24c:	57fd                	li	a5,-1
 24e:	893e                	mv	s2,a5
 250:	bfc5                	j	240 <stat+0x2a>

0000000000000252 <atoi>:

int
atoi(const char *s)
{
 252:	1141                	addi	sp,sp,-16
 254:	e406                	sd	ra,8(sp)
 256:	e022                	sd	s0,0(sp)
 258:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 25a:	00054683          	lbu	a3,0(a0)
 25e:	fd06879b          	addiw	a5,a3,-48
 262:	0ff7f793          	zext.b	a5,a5
 266:	4625                	li	a2,9
 268:	02f66963          	bltu	a2,a5,29a <atoi+0x48>
 26c:	872a                	mv	a4,a0
  n = 0;
 26e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 270:	0705                	addi	a4,a4,1
 272:	0025179b          	slliw	a5,a0,0x2
 276:	9fa9                	addw	a5,a5,a0
 278:	0017979b          	slliw	a5,a5,0x1
 27c:	9fb5                	addw	a5,a5,a3
 27e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 282:	00074683          	lbu	a3,0(a4)
 286:	fd06879b          	addiw	a5,a3,-48
 28a:	0ff7f793          	zext.b	a5,a5
 28e:	fef671e3          	bgeu	a2,a5,270 <atoi+0x1e>
  return n;
}
 292:	60a2                	ld	ra,8(sp)
 294:	6402                	ld	s0,0(sp)
 296:	0141                	addi	sp,sp,16
 298:	8082                	ret
  n = 0;
 29a:	4501                	li	a0,0
 29c:	bfdd                	j	292 <atoi+0x40>

000000000000029e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 29e:	1141                	addi	sp,sp,-16
 2a0:	e406                	sd	ra,8(sp)
 2a2:	e022                	sd	s0,0(sp)
 2a4:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2a6:	02b57563          	bgeu	a0,a1,2d0 <memmove+0x32>
    while(n-- > 0)
 2aa:	00c05f63          	blez	a2,2c8 <memmove+0x2a>
 2ae:	1602                	slli	a2,a2,0x20
 2b0:	9201                	srli	a2,a2,0x20
 2b2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2b6:	872a                	mv	a4,a0
      *dst++ = *src++;
 2b8:	0585                	addi	a1,a1,1
 2ba:	0705                	addi	a4,a4,1
 2bc:	fff5c683          	lbu	a3,-1(a1)
 2c0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2c4:	fee79ae3          	bne	a5,a4,2b8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
    while(n-- > 0)
 2d0:	fec05ce3          	blez	a2,2c8 <memmove+0x2a>
    dst += n;
 2d4:	00c50733          	add	a4,a0,a2
    src += n;
 2d8:	95b2                	add	a1,a1,a2
 2da:	fff6079b          	addiw	a5,a2,-1
 2de:	1782                	slli	a5,a5,0x20
 2e0:	9381                	srli	a5,a5,0x20
 2e2:	fff7c793          	not	a5,a5
 2e6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 2e8:	15fd                	addi	a1,a1,-1
 2ea:	177d                	addi	a4,a4,-1
 2ec:	0005c683          	lbu	a3,0(a1)
 2f0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 2f4:	fef71ae3          	bne	a4,a5,2e8 <memmove+0x4a>
 2f8:	bfc1                	j	2c8 <memmove+0x2a>

00000000000002fa <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 2fa:	1141                	addi	sp,sp,-16
 2fc:	e406                	sd	ra,8(sp)
 2fe:	e022                	sd	s0,0(sp)
 300:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 302:	c61d                	beqz	a2,330 <memcmp+0x36>
 304:	1602                	slli	a2,a2,0x20
 306:	9201                	srli	a2,a2,0x20
 308:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 30c:	00054783          	lbu	a5,0(a0)
 310:	0005c703          	lbu	a4,0(a1)
 314:	00e79863          	bne	a5,a4,324 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 318:	0505                	addi	a0,a0,1
    p2++;
 31a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 31c:	fed518e3          	bne	a0,a3,30c <memcmp+0x12>
  }
  return 0;
 320:	4501                	li	a0,0
 322:	a019                	j	328 <memcmp+0x2e>
      return *p1 - *p2;
 324:	40e7853b          	subw	a0,a5,a4
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  return 0;
 330:	4501                	li	a0,0
 332:	bfdd                	j	328 <memcmp+0x2e>

0000000000000334 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e406                	sd	ra,8(sp)
 338:	e022                	sd	s0,0(sp)
 33a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 33c:	f63ff0ef          	jal	29e <memmove>
}
 340:	60a2                	ld	ra,8(sp)
 342:	6402                	ld	s0,0(sp)
 344:	0141                	addi	sp,sp,16
 346:	8082                	ret

0000000000000348 <sbrk>:

char *
sbrk(int n) {
 348:	1141                	addi	sp,sp,-16
 34a:	e406                	sd	ra,8(sp)
 34c:	e022                	sd	s0,0(sp)
 34e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 350:	4585                	li	a1,1
 352:	0b2000ef          	jal	404 <sys_sbrk>
}
 356:	60a2                	ld	ra,8(sp)
 358:	6402                	ld	s0,0(sp)
 35a:	0141                	addi	sp,sp,16
 35c:	8082                	ret

000000000000035e <sbrklazy>:

char *
sbrklazy(int n) {
 35e:	1141                	addi	sp,sp,-16
 360:	e406                	sd	ra,8(sp)
 362:	e022                	sd	s0,0(sp)
 364:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 366:	4589                	li	a1,2
 368:	09c000ef          	jal	404 <sys_sbrk>
}
 36c:	60a2                	ld	ra,8(sp)
 36e:	6402                	ld	s0,0(sp)
 370:	0141                	addi	sp,sp,16
 372:	8082                	ret

0000000000000374 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 374:	4885                	li	a7,1
 ecall
 376:	00000073          	ecall
 ret
 37a:	8082                	ret

000000000000037c <exit>:
.global exit
exit:
 li a7, SYS_exit
 37c:	4889                	li	a7,2
 ecall
 37e:	00000073          	ecall
 ret
 382:	8082                	ret

0000000000000384 <wait>:
.global wait
wait:
 li a7, SYS_wait
 384:	488d                	li	a7,3
 ecall
 386:	00000073          	ecall
 ret
 38a:	8082                	ret

000000000000038c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 38c:	4891                	li	a7,4
 ecall
 38e:	00000073          	ecall
 ret
 392:	8082                	ret

0000000000000394 <read>:
.global read
read:
 li a7, SYS_read
 394:	4895                	li	a7,5
 ecall
 396:	00000073          	ecall
 ret
 39a:	8082                	ret

000000000000039c <write>:
.global write
write:
 li a7, SYS_write
 39c:	48c1                	li	a7,16
 ecall
 39e:	00000073          	ecall
 ret
 3a2:	8082                	ret

00000000000003a4 <close>:
.global close
close:
 li a7, SYS_close
 3a4:	48d5                	li	a7,21
 ecall
 3a6:	00000073          	ecall
 ret
 3aa:	8082                	ret

00000000000003ac <kill>:
.global kill
kill:
 li a7, SYS_kill
 3ac:	4899                	li	a7,6
 ecall
 3ae:	00000073          	ecall
 ret
 3b2:	8082                	ret

00000000000003b4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3b4:	489d                	li	a7,7
 ecall
 3b6:	00000073          	ecall
 ret
 3ba:	8082                	ret

00000000000003bc <open>:
.global open
open:
 li a7, SYS_open
 3bc:	48bd                	li	a7,15
 ecall
 3be:	00000073          	ecall
 ret
 3c2:	8082                	ret

00000000000003c4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3c4:	48c5                	li	a7,17
 ecall
 3c6:	00000073          	ecall
 ret
 3ca:	8082                	ret

00000000000003cc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 3cc:	48c9                	li	a7,18
 ecall
 3ce:	00000073          	ecall
 ret
 3d2:	8082                	ret

00000000000003d4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 3d4:	48a1                	li	a7,8
 ecall
 3d6:	00000073          	ecall
 ret
 3da:	8082                	ret

00000000000003dc <link>:
.global link
link:
 li a7, SYS_link
 3dc:	48cd                	li	a7,19
 ecall
 3de:	00000073          	ecall
 ret
 3e2:	8082                	ret

00000000000003e4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 3e4:	48d1                	li	a7,20
 ecall
 3e6:	00000073          	ecall
 ret
 3ea:	8082                	ret

00000000000003ec <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 3ec:	48a5                	li	a7,9
 ecall
 3ee:	00000073          	ecall
 ret
 3f2:	8082                	ret

00000000000003f4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 3f4:	48a9                	li	a7,10
 ecall
 3f6:	00000073          	ecall
 ret
 3fa:	8082                	ret

00000000000003fc <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 3fc:	48ad                	li	a7,11
 ecall
 3fe:	00000073          	ecall
 ret
 402:	8082                	ret

0000000000000404 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 404:	48b1                	li	a7,12
 ecall
 406:	00000073          	ecall
 ret
 40a:	8082                	ret

000000000000040c <pause>:
.global pause
pause:
 li a7, SYS_pause
 40c:	48b5                	li	a7,13
 ecall
 40e:	00000073          	ecall
 ret
 412:	8082                	ret

0000000000000414 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 414:	48b9                	li	a7,14
 ecall
 416:	00000073          	ecall
 ret
 41a:	8082                	ret

000000000000041c <bind>:
.global bind
bind:
 li a7, SYS_bind
 41c:	48f5                	li	a7,29
 ecall
 41e:	00000073          	ecall
 ret
 422:	8082                	ret

0000000000000424 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 424:	48f9                	li	a7,30
 ecall
 426:	00000073          	ecall
 ret
 42a:	8082                	ret

000000000000042c <send>:
.global send
send:
 li a7, SYS_send
 42c:	48fd                	li	a7,31
 ecall
 42e:	00000073          	ecall
 ret
 432:	8082                	ret

0000000000000434 <recv>:
.global recv
recv:
 li a7, SYS_recv
 434:	02000893          	li	a7,32
 ecall
 438:	00000073          	ecall
 ret
 43c:	8082                	ret

000000000000043e <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 43e:	02100893          	li	a7,33
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 448:	02200893          	li	a7,34
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 452:	1101                	addi	sp,sp,-32
 454:	ec06                	sd	ra,24(sp)
 456:	e822                	sd	s0,16(sp)
 458:	1000                	addi	s0,sp,32
 45a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 45e:	4605                	li	a2,1
 460:	fef40593          	addi	a1,s0,-17
 464:	f39ff0ef          	jal	39c <write>
}
 468:	60e2                	ld	ra,24(sp)
 46a:	6442                	ld	s0,16(sp)
 46c:	6105                	addi	sp,sp,32
 46e:	8082                	ret

0000000000000470 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 470:	715d                	addi	sp,sp,-80
 472:	e486                	sd	ra,72(sp)
 474:	e0a2                	sd	s0,64(sp)
 476:	f84a                	sd	s2,48(sp)
 478:	f44e                	sd	s3,40(sp)
 47a:	0880                	addi	s0,sp,80
 47c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 47e:	c6d1                	beqz	a3,50a <printint+0x9a>
 480:	0805d563          	bgez	a1,50a <printint+0x9a>
    neg = 1;
    x = -xx;
 484:	40b005b3          	neg	a1,a1
    neg = 1;
 488:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 48a:	fb840993          	addi	s3,s0,-72
  neg = 0;
 48e:	86ce                	mv	a3,s3
  i = 0;
 490:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 492:	00000817          	auipc	a6,0x0
 496:	5be80813          	addi	a6,a6,1470 # a50 <digits>
 49a:	88ba                	mv	a7,a4
 49c:	0017051b          	addiw	a0,a4,1
 4a0:	872a                	mv	a4,a0
 4a2:	02c5f7b3          	remu	a5,a1,a2
 4a6:	97c2                	add	a5,a5,a6
 4a8:	0007c783          	lbu	a5,0(a5)
 4ac:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4b0:	87ae                	mv	a5,a1
 4b2:	02c5d5b3          	divu	a1,a1,a2
 4b6:	0685                	addi	a3,a3,1
 4b8:	fec7f1e3          	bgeu	a5,a2,49a <printint+0x2a>
  if(neg)
 4bc:	00030c63          	beqz	t1,4d4 <printint+0x64>
    buf[i++] = '-';
 4c0:	fd050793          	addi	a5,a0,-48
 4c4:	00878533          	add	a0,a5,s0
 4c8:	02d00793          	li	a5,45
 4cc:	fef50423          	sb	a5,-24(a0)
 4d0:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4d4:	02e05563          	blez	a4,4fe <printint+0x8e>
 4d8:	fc26                	sd	s1,56(sp)
 4da:	377d                	addiw	a4,a4,-1
 4dc:	00e984b3          	add	s1,s3,a4
 4e0:	19fd                	addi	s3,s3,-1
 4e2:	99ba                	add	s3,s3,a4
 4e4:	1702                	slli	a4,a4,0x20
 4e6:	9301                	srli	a4,a4,0x20
 4e8:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4ec:	0004c583          	lbu	a1,0(s1)
 4f0:	854a                	mv	a0,s2
 4f2:	f61ff0ef          	jal	452 <putc>
  while(--i >= 0)
 4f6:	14fd                	addi	s1,s1,-1
 4f8:	ff349ae3          	bne	s1,s3,4ec <printint+0x7c>
 4fc:	74e2                	ld	s1,56(sp)
}
 4fe:	60a6                	ld	ra,72(sp)
 500:	6406                	ld	s0,64(sp)
 502:	7942                	ld	s2,48(sp)
 504:	79a2                	ld	s3,40(sp)
 506:	6161                	addi	sp,sp,80
 508:	8082                	ret
  neg = 0;
 50a:	4301                	li	t1,0
 50c:	bfbd                	j	48a <printint+0x1a>

000000000000050e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 50e:	711d                	addi	sp,sp,-96
 510:	ec86                	sd	ra,88(sp)
 512:	e8a2                	sd	s0,80(sp)
 514:	e4a6                	sd	s1,72(sp)
 516:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 518:	0005c483          	lbu	s1,0(a1)
 51c:	22048363          	beqz	s1,742 <vprintf+0x234>
 520:	e0ca                	sd	s2,64(sp)
 522:	fc4e                	sd	s3,56(sp)
 524:	f852                	sd	s4,48(sp)
 526:	f456                	sd	s5,40(sp)
 528:	f05a                	sd	s6,32(sp)
 52a:	ec5e                	sd	s7,24(sp)
 52c:	e862                	sd	s8,16(sp)
 52e:	8b2a                	mv	s6,a0
 530:	8a2e                	mv	s4,a1
 532:	8bb2                	mv	s7,a2
  state = 0;
 534:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 536:	4901                	li	s2,0
 538:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 53a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 53e:	06400c13          	li	s8,100
 542:	a00d                	j	564 <vprintf+0x56>
        putc(fd, c0);
 544:	85a6                	mv	a1,s1
 546:	855a                	mv	a0,s6
 548:	f0bff0ef          	jal	452 <putc>
 54c:	a019                	j	552 <vprintf+0x44>
    } else if(state == '%'){
 54e:	03598363          	beq	s3,s5,574 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 552:	0019079b          	addiw	a5,s2,1
 556:	893e                	mv	s2,a5
 558:	873e                	mv	a4,a5
 55a:	97d2                	add	a5,a5,s4
 55c:	0007c483          	lbu	s1,0(a5)
 560:	1c048a63          	beqz	s1,734 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 564:	0004879b          	sext.w	a5,s1
    if(state == 0){
 568:	fe0993e3          	bnez	s3,54e <vprintf+0x40>
      if(c0 == '%'){
 56c:	fd579ce3          	bne	a5,s5,544 <vprintf+0x36>
        state = '%';
 570:	89be                	mv	s3,a5
 572:	b7c5                	j	552 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 574:	00ea06b3          	add	a3,s4,a4
 578:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 57c:	1c060863          	beqz	a2,74c <vprintf+0x23e>
      if(c0 == 'd'){
 580:	03878763          	beq	a5,s8,5ae <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 584:	f9478693          	addi	a3,a5,-108
 588:	0016b693          	seqz	a3,a3
 58c:	f9c60593          	addi	a1,a2,-100
 590:	e99d                	bnez	a1,5c6 <vprintf+0xb8>
 592:	ca95                	beqz	a3,5c6 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 594:	008b8493          	addi	s1,s7,8
 598:	4685                	li	a3,1
 59a:	4629                	li	a2,10
 59c:	000bb583          	ld	a1,0(s7)
 5a0:	855a                	mv	a0,s6
 5a2:	ecfff0ef          	jal	470 <printint>
        i += 1;
 5a6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a8:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5aa:	4981                	li	s3,0
 5ac:	b75d                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5ae:	008b8493          	addi	s1,s7,8
 5b2:	4685                	li	a3,1
 5b4:	4629                	li	a2,10
 5b6:	000ba583          	lw	a1,0(s7)
 5ba:	855a                	mv	a0,s6
 5bc:	eb5ff0ef          	jal	470 <printint>
 5c0:	8ba6                	mv	s7,s1
      state = 0;
 5c2:	4981                	li	s3,0
 5c4:	b779                	j	552 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5c6:	9752                	add	a4,a4,s4
 5c8:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5cc:	f9460713          	addi	a4,a2,-108
 5d0:	00173713          	seqz	a4,a4
 5d4:	8f75                	and	a4,a4,a3
 5d6:	f9c58513          	addi	a0,a1,-100
 5da:	18051363          	bnez	a0,760 <vprintf+0x252>
 5de:	18070163          	beqz	a4,760 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e2:	008b8493          	addi	s1,s7,8
 5e6:	4685                	li	a3,1
 5e8:	4629                	li	a2,10
 5ea:	000bb583          	ld	a1,0(s7)
 5ee:	855a                	mv	a0,s6
 5f0:	e81ff0ef          	jal	470 <printint>
        i += 2;
 5f4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f6:	8ba6                	mv	s7,s1
      state = 0;
 5f8:	4981                	li	s3,0
        i += 2;
 5fa:	bfa1                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 5fc:	008b8493          	addi	s1,s7,8
 600:	4681                	li	a3,0
 602:	4629                	li	a2,10
 604:	000be583          	lwu	a1,0(s7)
 608:	855a                	mv	a0,s6
 60a:	e67ff0ef          	jal	470 <printint>
 60e:	8ba6                	mv	s7,s1
      state = 0;
 610:	4981                	li	s3,0
 612:	b781                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 614:	008b8493          	addi	s1,s7,8
 618:	4681                	li	a3,0
 61a:	4629                	li	a2,10
 61c:	000bb583          	ld	a1,0(s7)
 620:	855a                	mv	a0,s6
 622:	e4fff0ef          	jal	470 <printint>
        i += 1;
 626:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 628:	8ba6                	mv	s7,s1
      state = 0;
 62a:	4981                	li	s3,0
 62c:	b71d                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 62e:	008b8493          	addi	s1,s7,8
 632:	4681                	li	a3,0
 634:	4629                	li	a2,10
 636:	000bb583          	ld	a1,0(s7)
 63a:	855a                	mv	a0,s6
 63c:	e35ff0ef          	jal	470 <printint>
        i += 2;
 640:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 642:	8ba6                	mv	s7,s1
      state = 0;
 644:	4981                	li	s3,0
        i += 2;
 646:	b731                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 648:	008b8493          	addi	s1,s7,8
 64c:	4681                	li	a3,0
 64e:	4641                	li	a2,16
 650:	000be583          	lwu	a1,0(s7)
 654:	855a                	mv	a0,s6
 656:	e1bff0ef          	jal	470 <printint>
 65a:	8ba6                	mv	s7,s1
      state = 0;
 65c:	4981                	li	s3,0
 65e:	bdd5                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 660:	008b8493          	addi	s1,s7,8
 664:	4681                	li	a3,0
 666:	4641                	li	a2,16
 668:	000bb583          	ld	a1,0(s7)
 66c:	855a                	mv	a0,s6
 66e:	e03ff0ef          	jal	470 <printint>
        i += 1;
 672:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 674:	8ba6                	mv	s7,s1
      state = 0;
 676:	4981                	li	s3,0
 678:	bde9                	j	552 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 67a:	008b8493          	addi	s1,s7,8
 67e:	4681                	li	a3,0
 680:	4641                	li	a2,16
 682:	000bb583          	ld	a1,0(s7)
 686:	855a                	mv	a0,s6
 688:	de9ff0ef          	jal	470 <printint>
        i += 2;
 68c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 68e:	8ba6                	mv	s7,s1
      state = 0;
 690:	4981                	li	s3,0
        i += 2;
 692:	b5c1                	j	552 <vprintf+0x44>
 694:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 696:	008b8793          	addi	a5,s7,8
 69a:	8cbe                	mv	s9,a5
 69c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6a0:	03000593          	li	a1,48
 6a4:	855a                	mv	a0,s6
 6a6:	dadff0ef          	jal	452 <putc>
  putc(fd, 'x');
 6aa:	07800593          	li	a1,120
 6ae:	855a                	mv	a0,s6
 6b0:	da3ff0ef          	jal	452 <putc>
 6b4:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6b6:	00000b97          	auipc	s7,0x0
 6ba:	39ab8b93          	addi	s7,s7,922 # a50 <digits>
 6be:	03c9d793          	srli	a5,s3,0x3c
 6c2:	97de                	add	a5,a5,s7
 6c4:	0007c583          	lbu	a1,0(a5)
 6c8:	855a                	mv	a0,s6
 6ca:	d89ff0ef          	jal	452 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6ce:	0992                	slli	s3,s3,0x4
 6d0:	34fd                	addiw	s1,s1,-1
 6d2:	f4f5                	bnez	s1,6be <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6d4:	8be6                	mv	s7,s9
      state = 0;
 6d6:	4981                	li	s3,0
 6d8:	6ca2                	ld	s9,8(sp)
 6da:	bda5                	j	552 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6dc:	008b8493          	addi	s1,s7,8
 6e0:	000bc583          	lbu	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	d6dff0ef          	jal	452 <putc>
 6ea:	8ba6                	mv	s7,s1
      state = 0;
 6ec:	4981                	li	s3,0
 6ee:	b595                	j	552 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6f0:	008b8993          	addi	s3,s7,8
 6f4:	000bb483          	ld	s1,0(s7)
 6f8:	cc91                	beqz	s1,714 <vprintf+0x206>
        for(; *s; s++)
 6fa:	0004c583          	lbu	a1,0(s1)
 6fe:	c985                	beqz	a1,72e <vprintf+0x220>
          putc(fd, *s);
 700:	855a                	mv	a0,s6
 702:	d51ff0ef          	jal	452 <putc>
        for(; *s; s++)
 706:	0485                	addi	s1,s1,1
 708:	0004c583          	lbu	a1,0(s1)
 70c:	f9f5                	bnez	a1,700 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 70e:	8bce                	mv	s7,s3
      state = 0;
 710:	4981                	li	s3,0
 712:	b581                	j	552 <vprintf+0x44>
          s = "(null)";
 714:	00000497          	auipc	s1,0x0
 718:	33448493          	addi	s1,s1,820 # a48 <malloc+0x198>
        for(; *s; s++)
 71c:	02800593          	li	a1,40
 720:	b7c5                	j	700 <vprintf+0x1f2>
        putc(fd, '%');
 722:	85be                	mv	a1,a5
 724:	855a                	mv	a0,s6
 726:	d2dff0ef          	jal	452 <putc>
      state = 0;
 72a:	4981                	li	s3,0
 72c:	b51d                	j	552 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 72e:	8bce                	mv	s7,s3
      state = 0;
 730:	4981                	li	s3,0
 732:	b505                	j	552 <vprintf+0x44>
 734:	6906                	ld	s2,64(sp)
 736:	79e2                	ld	s3,56(sp)
 738:	7a42                	ld	s4,48(sp)
 73a:	7aa2                	ld	s5,40(sp)
 73c:	7b02                	ld	s6,32(sp)
 73e:	6be2                	ld	s7,24(sp)
 740:	6c42                	ld	s8,16(sp)
    }
  }
}
 742:	60e6                	ld	ra,88(sp)
 744:	6446                	ld	s0,80(sp)
 746:	64a6                	ld	s1,72(sp)
 748:	6125                	addi	sp,sp,96
 74a:	8082                	ret
      if(c0 == 'd'){
 74c:	06400713          	li	a4,100
 750:	e4e78fe3          	beq	a5,a4,5ae <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 754:	f9478693          	addi	a3,a5,-108
 758:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 75c:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 75e:	4701                	li	a4,0
      } else if(c0 == 'u'){
 760:	07500513          	li	a0,117
 764:	e8a78ce3          	beq	a5,a0,5fc <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 768:	f8b60513          	addi	a0,a2,-117
 76c:	e119                	bnez	a0,772 <vprintf+0x264>
 76e:	ea0693e3          	bnez	a3,614 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 772:	f8b58513          	addi	a0,a1,-117
 776:	e119                	bnez	a0,77c <vprintf+0x26e>
 778:	ea071be3          	bnez	a4,62e <vprintf+0x120>
      } else if(c0 == 'x'){
 77c:	07800513          	li	a0,120
 780:	eca784e3          	beq	a5,a0,648 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 784:	f8860613          	addi	a2,a2,-120
 788:	e219                	bnez	a2,78e <vprintf+0x280>
 78a:	ec069be3          	bnez	a3,660 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 78e:	f8858593          	addi	a1,a1,-120
 792:	e199                	bnez	a1,798 <vprintf+0x28a>
 794:	ee0713e3          	bnez	a4,67a <vprintf+0x16c>
      } else if(c0 == 'p'){
 798:	07000713          	li	a4,112
 79c:	eee78ce3          	beq	a5,a4,694 <vprintf+0x186>
      } else if(c0 == 'c'){
 7a0:	06300713          	li	a4,99
 7a4:	f2e78ce3          	beq	a5,a4,6dc <vprintf+0x1ce>
      } else if(c0 == 's'){
 7a8:	07300713          	li	a4,115
 7ac:	f4e782e3          	beq	a5,a4,6f0 <vprintf+0x1e2>
      } else if(c0 == '%'){
 7b0:	02500713          	li	a4,37
 7b4:	f6e787e3          	beq	a5,a4,722 <vprintf+0x214>
        putc(fd, '%');
 7b8:	02500593          	li	a1,37
 7bc:	855a                	mv	a0,s6
 7be:	c95ff0ef          	jal	452 <putc>
        putc(fd, c0);
 7c2:	85a6                	mv	a1,s1
 7c4:	855a                	mv	a0,s6
 7c6:	c8dff0ef          	jal	452 <putc>
      state = 0;
 7ca:	4981                	li	s3,0
 7cc:	b359                	j	552 <vprintf+0x44>

00000000000007ce <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7ce:	715d                	addi	sp,sp,-80
 7d0:	ec06                	sd	ra,24(sp)
 7d2:	e822                	sd	s0,16(sp)
 7d4:	1000                	addi	s0,sp,32
 7d6:	e010                	sd	a2,0(s0)
 7d8:	e414                	sd	a3,8(s0)
 7da:	e818                	sd	a4,16(s0)
 7dc:	ec1c                	sd	a5,24(s0)
 7de:	03043023          	sd	a6,32(s0)
 7e2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7e6:	8622                	mv	a2,s0
 7e8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7ec:	d23ff0ef          	jal	50e <vprintf>
}
 7f0:	60e2                	ld	ra,24(sp)
 7f2:	6442                	ld	s0,16(sp)
 7f4:	6161                	addi	sp,sp,80
 7f6:	8082                	ret

00000000000007f8 <printf>:

void
printf(const char *fmt, ...)
{
 7f8:	711d                	addi	sp,sp,-96
 7fa:	ec06                	sd	ra,24(sp)
 7fc:	e822                	sd	s0,16(sp)
 7fe:	1000                	addi	s0,sp,32
 800:	e40c                	sd	a1,8(s0)
 802:	e810                	sd	a2,16(s0)
 804:	ec14                	sd	a3,24(s0)
 806:	f018                	sd	a4,32(s0)
 808:	f41c                	sd	a5,40(s0)
 80a:	03043823          	sd	a6,48(s0)
 80e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 812:	00840613          	addi	a2,s0,8
 816:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 81a:	85aa                	mv	a1,a0
 81c:	4505                	li	a0,1
 81e:	cf1ff0ef          	jal	50e <vprintf>
}
 822:	60e2                	ld	ra,24(sp)
 824:	6442                	ld	s0,16(sp)
 826:	6125                	addi	sp,sp,96
 828:	8082                	ret

000000000000082a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 82a:	1141                	addi	sp,sp,-16
 82c:	e406                	sd	ra,8(sp)
 82e:	e022                	sd	s0,0(sp)
 830:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 832:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 836:	00000797          	auipc	a5,0x0
 83a:	7ca7b783          	ld	a5,1994(a5) # 1000 <freep>
 83e:	a039                	j	84c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 840:	6398                	ld	a4,0(a5)
 842:	00e7e463          	bltu	a5,a4,84a <free+0x20>
 846:	00e6ea63          	bltu	a3,a4,85a <free+0x30>
{
 84a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 84c:	fed7fae3          	bgeu	a5,a3,840 <free+0x16>
 850:	6398                	ld	a4,0(a5)
 852:	00e6e463          	bltu	a3,a4,85a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 856:	fee7eae3          	bltu	a5,a4,84a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 85a:	ff852583          	lw	a1,-8(a0)
 85e:	6390                	ld	a2,0(a5)
 860:	02059813          	slli	a6,a1,0x20
 864:	01c85713          	srli	a4,a6,0x1c
 868:	9736                	add	a4,a4,a3
 86a:	02e60563          	beq	a2,a4,894 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 86e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 872:	4790                	lw	a2,8(a5)
 874:	02061593          	slli	a1,a2,0x20
 878:	01c5d713          	srli	a4,a1,0x1c
 87c:	973e                	add	a4,a4,a5
 87e:	02e68263          	beq	a3,a4,8a2 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 882:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 884:	00000717          	auipc	a4,0x0
 888:	76f73e23          	sd	a5,1916(a4) # 1000 <freep>
}
 88c:	60a2                	ld	ra,8(sp)
 88e:	6402                	ld	s0,0(sp)
 890:	0141                	addi	sp,sp,16
 892:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 894:	4618                	lw	a4,8(a2)
 896:	9f2d                	addw	a4,a4,a1
 898:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 89c:	6398                	ld	a4,0(a5)
 89e:	6310                	ld	a2,0(a4)
 8a0:	b7f9                	j	86e <free+0x44>
    p->s.size += bp->s.size;
 8a2:	ff852703          	lw	a4,-8(a0)
 8a6:	9f31                	addw	a4,a4,a2
 8a8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8aa:	ff053683          	ld	a3,-16(a0)
 8ae:	bfd1                	j	882 <free+0x58>

00000000000008b0 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8b0:	7139                	addi	sp,sp,-64
 8b2:	fc06                	sd	ra,56(sp)
 8b4:	f822                	sd	s0,48(sp)
 8b6:	f04a                	sd	s2,32(sp)
 8b8:	ec4e                	sd	s3,24(sp)
 8ba:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8bc:	02051993          	slli	s3,a0,0x20
 8c0:	0209d993          	srli	s3,s3,0x20
 8c4:	09bd                	addi	s3,s3,15
 8c6:	0049d993          	srli	s3,s3,0x4
 8ca:	2985                	addiw	s3,s3,1
 8cc:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8ce:	00000517          	auipc	a0,0x0
 8d2:	73253503          	ld	a0,1842(a0) # 1000 <freep>
 8d6:	c905                	beqz	a0,906 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8d8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8da:	4798                	lw	a4,8(a5)
 8dc:	09377663          	bgeu	a4,s3,968 <malloc+0xb8>
 8e0:	f426                	sd	s1,40(sp)
 8e2:	e852                	sd	s4,16(sp)
 8e4:	e456                	sd	s5,8(sp)
 8e6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8e8:	8a4e                	mv	s4,s3
 8ea:	6705                	lui	a4,0x1
 8ec:	00e9f363          	bgeu	s3,a4,8f2 <malloc+0x42>
 8f0:	6a05                	lui	s4,0x1
 8f2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 8f6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 8fa:	00000497          	auipc	s1,0x0
 8fe:	70648493          	addi	s1,s1,1798 # 1000 <freep>
  if(p == SBRK_ERROR)
 902:	5afd                	li	s5,-1
 904:	a83d                	j	942 <malloc+0x92>
 906:	f426                	sd	s1,40(sp)
 908:	e852                	sd	s4,16(sp)
 90a:	e456                	sd	s5,8(sp)
 90c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 90e:	00001797          	auipc	a5,0x1
 912:	8fa78793          	addi	a5,a5,-1798 # 1208 <base>
 916:	00000717          	auipc	a4,0x0
 91a:	6ef73523          	sd	a5,1770(a4) # 1000 <freep>
 91e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 920:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 924:	b7d1                	j	8e8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 926:	6398                	ld	a4,0(a5)
 928:	e118                	sd	a4,0(a0)
 92a:	a899                	j	980 <malloc+0xd0>
  hp->s.size = nu;
 92c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 930:	0541                	addi	a0,a0,16
 932:	ef9ff0ef          	jal	82a <free>
  return freep;
 936:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 938:	c125                	beqz	a0,998 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 93a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 93c:	4798                	lw	a4,8(a5)
 93e:	03277163          	bgeu	a4,s2,960 <malloc+0xb0>
    if(p == freep)
 942:	6098                	ld	a4,0(s1)
 944:	853e                	mv	a0,a5
 946:	fef71ae3          	bne	a4,a5,93a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 94a:	8552                	mv	a0,s4
 94c:	9fdff0ef          	jal	348 <sbrk>
  if(p == SBRK_ERROR)
 950:	fd551ee3          	bne	a0,s5,92c <malloc+0x7c>
        return 0;
 954:	4501                	li	a0,0
 956:	74a2                	ld	s1,40(sp)
 958:	6a42                	ld	s4,16(sp)
 95a:	6aa2                	ld	s5,8(sp)
 95c:	6b02                	ld	s6,0(sp)
 95e:	a03d                	j	98c <malloc+0xdc>
 960:	74a2                	ld	s1,40(sp)
 962:	6a42                	ld	s4,16(sp)
 964:	6aa2                	ld	s5,8(sp)
 966:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 968:	fae90fe3          	beq	s2,a4,926 <malloc+0x76>
        p->s.size -= nunits;
 96c:	4137073b          	subw	a4,a4,s3
 970:	c798                	sw	a4,8(a5)
        p += p->s.size;
 972:	02071693          	slli	a3,a4,0x20
 976:	01c6d713          	srli	a4,a3,0x1c
 97a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 97c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 980:	00000717          	auipc	a4,0x0
 984:	68a73023          	sd	a0,1664(a4) # 1000 <freep>
      return (void*)(p + 1);
 988:	01078513          	addi	a0,a5,16
  }
}
 98c:	70e2                	ld	ra,56(sp)
 98e:	7442                	ld	s0,48(sp)
 990:	7902                	ld	s2,32(sp)
 992:	69e2                	ld	s3,24(sp)
 994:	6121                	addi	sp,sp,64
 996:	8082                	ret
 998:	74a2                	ld	s1,40(sp)
 99a:	6a42                	ld	s4,16(sp)
 99c:	6aa2                	ld	s5,8(sp)
 99e:	6b02                	ld	s6,0(sp)
 9a0:	b7f5                	j	98c <malloc+0xdc>
