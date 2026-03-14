
user/_logstress:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
main(int argc, char **argv)
{
  int fd, n;
  enum { N = 250, SZ=2000 };
  
  for (int i = 1; i < argc; i++){
   0:	4785                	li	a5,1
   2:	0ea7de63          	bge	a5,a0,fe <main+0xfe>
{
   6:	7139                	addi	sp,sp,-64
   8:	fc06                	sd	ra,56(sp)
   a:	f822                	sd	s0,48(sp)
   c:	f426                	sd	s1,40(sp)
   e:	f04a                	sd	s2,32(sp)
  10:	ec4e                	sd	s3,24(sp)
  12:	e852                	sd	s4,16(sp)
  14:	0080                	addi	s0,sp,64
  16:	892a                	mv	s2,a0
  18:	8a2e                	mv	s4,a1
  for (int i = 1; i < argc; i++){
  1a:	84be                	mv	s1,a5
  1c:	a011                	j	20 <main+0x20>
  1e:	84be                	mv	s1,a5
    int pid1 = fork();
  20:	390000ef          	jal	3b0 <fork>
    if(pid1 < 0){
  24:	00054b63          	bltz	a0,3a <main+0x3a>
      printf("%s: fork failed\n", argv[0]);
      exit(1);
    }
    if(pid1 == 0) {
  28:	c505                	beqz	a0,50 <main+0x50>
  for (int i = 1; i < argc; i++){
  2a:	0014879b          	addiw	a5,s1,1
  2e:	fef918e3          	bne	s2,a5,1e <main+0x1e>
      }
      exit(0);
    }
  }
  int xstatus;
  for(int i = 1; i < argc; i++){
  32:	4905                	li	s2,1
    wait(&xstatus);
  34:	fcc40993          	addi	s3,s0,-52
  38:	a871                	j	d4 <main+0xd4>
      printf("%s: fork failed\n", argv[0]);
  3a:	000a3583          	ld	a1,0(s4)
  3e:	00001517          	auipc	a0,0x1
  42:	a3250513          	addi	a0,a0,-1486 # a70 <statistics+0x7e>
  46:	003000ef          	jal	848 <printf>
      exit(1);
  4a:	4505                	li	a0,1
  4c:	36c000ef          	jal	3b8 <exit>
      fd = open(argv[i], O_CREATE | O_RDWR);
  50:	00349913          	slli	s2,s1,0x3
  54:	9952                	add	s2,s2,s4
  56:	20200593          	li	a1,514
  5a:	00093503          	ld	a0,0(s2)
  5e:	39a000ef          	jal	3f8 <open>
  62:	89aa                	mv	s3,a0
      if(fd < 0){
  64:	04054063          	bltz	a0,a4 <main+0xa4>
      memset(buf, '0'+i, SZ);
  68:	7d000613          	li	a2,2000
  6c:	0304859b          	addiw	a1,s1,48
  70:	00001517          	auipc	a0,0x1
  74:	fa050513          	addi	a0,a0,-96 # 1010 <buf>
  78:	116000ef          	jal	18e <memset>
  7c:	0fa00493          	li	s1,250
        if((n = write(fd, buf, SZ)) != SZ){
  80:	7d000913          	li	s2,2000
  84:	00001a17          	auipc	s4,0x1
  88:	f8ca0a13          	addi	s4,s4,-116 # 1010 <buf>
  8c:	864a                	mv	a2,s2
  8e:	85d2                	mv	a1,s4
  90:	854e                	mv	a0,s3
  92:	346000ef          	jal	3d8 <write>
  96:	03251463          	bne	a0,s2,be <main+0xbe>
      for(i = 0; i < N; i++){
  9a:	34fd                	addiw	s1,s1,-1
  9c:	f8e5                	bnez	s1,8c <main+0x8c>
      exit(0);
  9e:	4501                	li	a0,0
  a0:	318000ef          	jal	3b8 <exit>
        printf("%s: create %s failed\n", argv[0], argv[i]);
  a4:	00093603          	ld	a2,0(s2)
  a8:	000a3583          	ld	a1,0(s4)
  ac:	00001517          	auipc	a0,0x1
  b0:	9dc50513          	addi	a0,a0,-1572 # a88 <statistics+0x96>
  b4:	794000ef          	jal	848 <printf>
        exit(1);
  b8:	4505                	li	a0,1
  ba:	2fe000ef          	jal	3b8 <exit>
          printf("write failed %d\n", n);
  be:	85aa                	mv	a1,a0
  c0:	00001517          	auipc	a0,0x1
  c4:	9e050513          	addi	a0,a0,-1568 # aa0 <statistics+0xae>
  c8:	780000ef          	jal	848 <printf>
          exit(1);
  cc:	4505                	li	a0,1
  ce:	2ea000ef          	jal	3b8 <exit>
  d2:	893e                	mv	s2,a5
    wait(&xstatus);
  d4:	854e                	mv	a0,s3
  d6:	2ea000ef          	jal	3c0 <wait>
    if(xstatus != 0)
  da:	fcc42503          	lw	a0,-52(s0)
  de:	ed11                	bnez	a0,fa <main+0xfa>
  for(int i = 1; i < argc; i++){
  e0:	0019079b          	addiw	a5,s2,1
  e4:	ff2497e3          	bne	s1,s2,d2 <main+0xd2>
      exit(xstatus);
  }
  return 0;
}
  e8:	4501                	li	a0,0
  ea:	70e2                	ld	ra,56(sp)
  ec:	7442                	ld	s0,48(sp)
  ee:	74a2                	ld	s1,40(sp)
  f0:	7902                	ld	s2,32(sp)
  f2:	69e2                	ld	s3,24(sp)
  f4:	6a42                	ld	s4,16(sp)
  f6:	6121                	addi	sp,sp,64
  f8:	8082                	ret
      exit(xstatus);
  fa:	2be000ef          	jal	3b8 <exit>
}
  fe:	4501                	li	a0,0
 100:	8082                	ret

0000000000000102 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 102:	1141                	addi	sp,sp,-16
 104:	e406                	sd	ra,8(sp)
 106:	e022                	sd	s0,0(sp)
 108:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 10a:	ef7ff0ef          	jal	0 <main>
  exit(r);
 10e:	2aa000ef          	jal	3b8 <exit>

0000000000000112 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 112:	1141                	addi	sp,sp,-16
 114:	e406                	sd	ra,8(sp)
 116:	e022                	sd	s0,0(sp)
 118:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 11a:	87aa                	mv	a5,a0
 11c:	0585                	addi	a1,a1,1
 11e:	0785                	addi	a5,a5,1
 120:	fff5c703          	lbu	a4,-1(a1)
 124:	fee78fa3          	sb	a4,-1(a5)
 128:	fb75                	bnez	a4,11c <strcpy+0xa>
    ;
  return os;
}
 12a:	60a2                	ld	ra,8(sp)
 12c:	6402                	ld	s0,0(sp)
 12e:	0141                	addi	sp,sp,16
 130:	8082                	ret

0000000000000132 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 132:	1141                	addi	sp,sp,-16
 134:	e406                	sd	ra,8(sp)
 136:	e022                	sd	s0,0(sp)
 138:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 13a:	00054783          	lbu	a5,0(a0)
 13e:	cb91                	beqz	a5,152 <strcmp+0x20>
 140:	0005c703          	lbu	a4,0(a1)
 144:	00f71763          	bne	a4,a5,152 <strcmp+0x20>
    p++, q++;
 148:	0505                	addi	a0,a0,1
 14a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 14c:	00054783          	lbu	a5,0(a0)
 150:	fbe5                	bnez	a5,140 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 152:	0005c503          	lbu	a0,0(a1)
}
 156:	40a7853b          	subw	a0,a5,a0
 15a:	60a2                	ld	ra,8(sp)
 15c:	6402                	ld	s0,0(sp)
 15e:	0141                	addi	sp,sp,16
 160:	8082                	ret

0000000000000162 <strlen>:

uint
strlen(const char *s)
{
 162:	1141                	addi	sp,sp,-16
 164:	e406                	sd	ra,8(sp)
 166:	e022                	sd	s0,0(sp)
 168:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 16a:	00054783          	lbu	a5,0(a0)
 16e:	cf91                	beqz	a5,18a <strlen+0x28>
 170:	00150793          	addi	a5,a0,1
 174:	86be                	mv	a3,a5
 176:	0785                	addi	a5,a5,1
 178:	fff7c703          	lbu	a4,-1(a5)
 17c:	ff65                	bnez	a4,174 <strlen+0x12>
 17e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 182:	60a2                	ld	ra,8(sp)
 184:	6402                	ld	s0,0(sp)
 186:	0141                	addi	sp,sp,16
 188:	8082                	ret
  for(n = 0; s[n]; n++)
 18a:	4501                	li	a0,0
 18c:	bfdd                	j	182 <strlen+0x20>

000000000000018e <memset>:

void*
memset(void *dst, int c, uint n)
{
 18e:	1141                	addi	sp,sp,-16
 190:	e406                	sd	ra,8(sp)
 192:	e022                	sd	s0,0(sp)
 194:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 196:	ca19                	beqz	a2,1ac <memset+0x1e>
 198:	87aa                	mv	a5,a0
 19a:	1602                	slli	a2,a2,0x20
 19c:	9201                	srli	a2,a2,0x20
 19e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1a2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a6:	0785                	addi	a5,a5,1
 1a8:	fee79de3          	bne	a5,a4,1a2 <memset+0x14>
  }
  return dst;
}
 1ac:	60a2                	ld	ra,8(sp)
 1ae:	6402                	ld	s0,0(sp)
 1b0:	0141                	addi	sp,sp,16
 1b2:	8082                	ret

00000000000001b4 <strchr>:

char*
strchr(const char *s, char c)
{
 1b4:	1141                	addi	sp,sp,-16
 1b6:	e406                	sd	ra,8(sp)
 1b8:	e022                	sd	s0,0(sp)
 1ba:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1bc:	00054783          	lbu	a5,0(a0)
 1c0:	cf81                	beqz	a5,1d8 <strchr+0x24>
    if(*s == c)
 1c2:	00f58763          	beq	a1,a5,1d0 <strchr+0x1c>
  for(; *s; s++)
 1c6:	0505                	addi	a0,a0,1
 1c8:	00054783          	lbu	a5,0(a0)
 1cc:	fbfd                	bnez	a5,1c2 <strchr+0xe>
      return (char*)s;
  return 0;
 1ce:	4501                	li	a0,0
}
 1d0:	60a2                	ld	ra,8(sp)
 1d2:	6402                	ld	s0,0(sp)
 1d4:	0141                	addi	sp,sp,16
 1d6:	8082                	ret
  return 0;
 1d8:	4501                	li	a0,0
 1da:	bfdd                	j	1d0 <strchr+0x1c>

00000000000001dc <gets>:

char*
gets(char *buf, int max)
{
 1dc:	711d                	addi	sp,sp,-96
 1de:	ec86                	sd	ra,88(sp)
 1e0:	e8a2                	sd	s0,80(sp)
 1e2:	e4a6                	sd	s1,72(sp)
 1e4:	e0ca                	sd	s2,64(sp)
 1e6:	fc4e                	sd	s3,56(sp)
 1e8:	f852                	sd	s4,48(sp)
 1ea:	f456                	sd	s5,40(sp)
 1ec:	f05a                	sd	s6,32(sp)
 1ee:	ec5e                	sd	s7,24(sp)
 1f0:	e862                	sd	s8,16(sp)
 1f2:	1080                	addi	s0,sp,96
 1f4:	8baa                	mv	s7,a0
 1f6:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f8:	892a                	mv	s2,a0
 1fa:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1fc:	faf40b13          	addi	s6,s0,-81
 200:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 202:	8c26                	mv	s8,s1
 204:	0014899b          	addiw	s3,s1,1
 208:	84ce                	mv	s1,s3
 20a:	0349d463          	bge	s3,s4,232 <gets+0x56>
    cc = read(0, &c, 1);
 20e:	8656                	mv	a2,s5
 210:	85da                	mv	a1,s6
 212:	4501                	li	a0,0
 214:	1bc000ef          	jal	3d0 <read>
    if(cc < 1)
 218:	00a05d63          	blez	a0,232 <gets+0x56>
      break;
    buf[i++] = c;
 21c:	faf44783          	lbu	a5,-81(s0)
 220:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 224:	0905                	addi	s2,s2,1
 226:	ff678713          	addi	a4,a5,-10
 22a:	c319                	beqz	a4,230 <gets+0x54>
 22c:	17cd                	addi	a5,a5,-13
 22e:	fbf1                	bnez	a5,202 <gets+0x26>
    buf[i++] = c;
 230:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 232:	9c5e                	add	s8,s8,s7
 234:	000c0023          	sb	zero,0(s8)
  return buf;
}
 238:	855e                	mv	a0,s7
 23a:	60e6                	ld	ra,88(sp)
 23c:	6446                	ld	s0,80(sp)
 23e:	64a6                	ld	s1,72(sp)
 240:	6906                	ld	s2,64(sp)
 242:	79e2                	ld	s3,56(sp)
 244:	7a42                	ld	s4,48(sp)
 246:	7aa2                	ld	s5,40(sp)
 248:	7b02                	ld	s6,32(sp)
 24a:	6be2                	ld	s7,24(sp)
 24c:	6c42                	ld	s8,16(sp)
 24e:	6125                	addi	sp,sp,96
 250:	8082                	ret

0000000000000252 <stat>:

int
stat(const char *n, struct stat *st)
{
 252:	1101                	addi	sp,sp,-32
 254:	ec06                	sd	ra,24(sp)
 256:	e822                	sd	s0,16(sp)
 258:	e04a                	sd	s2,0(sp)
 25a:	1000                	addi	s0,sp,32
 25c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 25e:	4581                	li	a1,0
 260:	198000ef          	jal	3f8 <open>
  if(fd < 0)
 264:	02054263          	bltz	a0,288 <stat+0x36>
 268:	e426                	sd	s1,8(sp)
 26a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 26c:	85ca                	mv	a1,s2
 26e:	1a2000ef          	jal	410 <fstat>
 272:	892a                	mv	s2,a0
  close(fd);
 274:	8526                	mv	a0,s1
 276:	16a000ef          	jal	3e0 <close>
  return r;
 27a:	64a2                	ld	s1,8(sp)
}
 27c:	854a                	mv	a0,s2
 27e:	60e2                	ld	ra,24(sp)
 280:	6442                	ld	s0,16(sp)
 282:	6902                	ld	s2,0(sp)
 284:	6105                	addi	sp,sp,32
 286:	8082                	ret
    return -1;
 288:	57fd                	li	a5,-1
 28a:	893e                	mv	s2,a5
 28c:	bfc5                	j	27c <stat+0x2a>

000000000000028e <atoi>:

int
atoi(const char *s)
{
 28e:	1141                	addi	sp,sp,-16
 290:	e406                	sd	ra,8(sp)
 292:	e022                	sd	s0,0(sp)
 294:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 296:	00054683          	lbu	a3,0(a0)
 29a:	fd06879b          	addiw	a5,a3,-48
 29e:	0ff7f793          	zext.b	a5,a5
 2a2:	4625                	li	a2,9
 2a4:	02f66963          	bltu	a2,a5,2d6 <atoi+0x48>
 2a8:	872a                	mv	a4,a0
  n = 0;
 2aa:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2ac:	0705                	addi	a4,a4,1
 2ae:	0025179b          	slliw	a5,a0,0x2
 2b2:	9fa9                	addw	a5,a5,a0
 2b4:	0017979b          	slliw	a5,a5,0x1
 2b8:	9fb5                	addw	a5,a5,a3
 2ba:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2be:	00074683          	lbu	a3,0(a4)
 2c2:	fd06879b          	addiw	a5,a3,-48
 2c6:	0ff7f793          	zext.b	a5,a5
 2ca:	fef671e3          	bgeu	a2,a5,2ac <atoi+0x1e>
  return n;
}
 2ce:	60a2                	ld	ra,8(sp)
 2d0:	6402                	ld	s0,0(sp)
 2d2:	0141                	addi	sp,sp,16
 2d4:	8082                	ret
  n = 0;
 2d6:	4501                	li	a0,0
 2d8:	bfdd                	j	2ce <atoi+0x40>

00000000000002da <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2da:	1141                	addi	sp,sp,-16
 2dc:	e406                	sd	ra,8(sp)
 2de:	e022                	sd	s0,0(sp)
 2e0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2e2:	02b57563          	bgeu	a0,a1,30c <memmove+0x32>
    while(n-- > 0)
 2e6:	00c05f63          	blez	a2,304 <memmove+0x2a>
 2ea:	1602                	slli	a2,a2,0x20
 2ec:	9201                	srli	a2,a2,0x20
 2ee:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2f2:	872a                	mv	a4,a0
      *dst++ = *src++;
 2f4:	0585                	addi	a1,a1,1
 2f6:	0705                	addi	a4,a4,1
 2f8:	fff5c683          	lbu	a3,-1(a1)
 2fc:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 300:	fee79ae3          	bne	a5,a4,2f4 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 304:	60a2                	ld	ra,8(sp)
 306:	6402                	ld	s0,0(sp)
 308:	0141                	addi	sp,sp,16
 30a:	8082                	ret
    while(n-- > 0)
 30c:	fec05ce3          	blez	a2,304 <memmove+0x2a>
    dst += n;
 310:	00c50733          	add	a4,a0,a2
    src += n;
 314:	95b2                	add	a1,a1,a2
 316:	fff6079b          	addiw	a5,a2,-1
 31a:	1782                	slli	a5,a5,0x20
 31c:	9381                	srli	a5,a5,0x20
 31e:	fff7c793          	not	a5,a5
 322:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 324:	15fd                	addi	a1,a1,-1
 326:	177d                	addi	a4,a4,-1
 328:	0005c683          	lbu	a3,0(a1)
 32c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 330:	fef71ae3          	bne	a4,a5,324 <memmove+0x4a>
 334:	bfc1                	j	304 <memmove+0x2a>

0000000000000336 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 336:	1141                	addi	sp,sp,-16
 338:	e406                	sd	ra,8(sp)
 33a:	e022                	sd	s0,0(sp)
 33c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 33e:	c61d                	beqz	a2,36c <memcmp+0x36>
 340:	1602                	slli	a2,a2,0x20
 342:	9201                	srli	a2,a2,0x20
 344:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 348:	00054783          	lbu	a5,0(a0)
 34c:	0005c703          	lbu	a4,0(a1)
 350:	00e79863          	bne	a5,a4,360 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 354:	0505                	addi	a0,a0,1
    p2++;
 356:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 358:	fed518e3          	bne	a0,a3,348 <memcmp+0x12>
  }
  return 0;
 35c:	4501                	li	a0,0
 35e:	a019                	j	364 <memcmp+0x2e>
      return *p1 - *p2;
 360:	40e7853b          	subw	a0,a5,a4
}
 364:	60a2                	ld	ra,8(sp)
 366:	6402                	ld	s0,0(sp)
 368:	0141                	addi	sp,sp,16
 36a:	8082                	ret
  return 0;
 36c:	4501                	li	a0,0
 36e:	bfdd                	j	364 <memcmp+0x2e>

0000000000000370 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 370:	1141                	addi	sp,sp,-16
 372:	e406                	sd	ra,8(sp)
 374:	e022                	sd	s0,0(sp)
 376:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 378:	f63ff0ef          	jal	2da <memmove>
}
 37c:	60a2                	ld	ra,8(sp)
 37e:	6402                	ld	s0,0(sp)
 380:	0141                	addi	sp,sp,16
 382:	8082                	ret

0000000000000384 <sbrk>:

char *
sbrk(int n) {
 384:	1141                	addi	sp,sp,-16
 386:	e406                	sd	ra,8(sp)
 388:	e022                	sd	s0,0(sp)
 38a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 38c:	4585                	li	a1,1
 38e:	0b2000ef          	jal	440 <sys_sbrk>
}
 392:	60a2                	ld	ra,8(sp)
 394:	6402                	ld	s0,0(sp)
 396:	0141                	addi	sp,sp,16
 398:	8082                	ret

000000000000039a <sbrklazy>:

char *
sbrklazy(int n) {
 39a:	1141                	addi	sp,sp,-16
 39c:	e406                	sd	ra,8(sp)
 39e:	e022                	sd	s0,0(sp)
 3a0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3a2:	4589                	li	a1,2
 3a4:	09c000ef          	jal	440 <sys_sbrk>
}
 3a8:	60a2                	ld	ra,8(sp)
 3aa:	6402                	ld	s0,0(sp)
 3ac:	0141                	addi	sp,sp,16
 3ae:	8082                	ret

00000000000003b0 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3b0:	4885                	li	a7,1
 ecall
 3b2:	00000073          	ecall
 ret
 3b6:	8082                	ret

00000000000003b8 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b8:	4889                	li	a7,2
 ecall
 3ba:	00000073          	ecall
 ret
 3be:	8082                	ret

00000000000003c0 <wait>:
.global wait
wait:
 li a7, SYS_wait
 3c0:	488d                	li	a7,3
 ecall
 3c2:	00000073          	ecall
 ret
 3c6:	8082                	ret

00000000000003c8 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c8:	4891                	li	a7,4
 ecall
 3ca:	00000073          	ecall
 ret
 3ce:	8082                	ret

00000000000003d0 <read>:
.global read
read:
 li a7, SYS_read
 3d0:	4895                	li	a7,5
 ecall
 3d2:	00000073          	ecall
 ret
 3d6:	8082                	ret

00000000000003d8 <write>:
.global write
write:
 li a7, SYS_write
 3d8:	48c1                	li	a7,16
 ecall
 3da:	00000073          	ecall
 ret
 3de:	8082                	ret

00000000000003e0 <close>:
.global close
close:
 li a7, SYS_close
 3e0:	48d5                	li	a7,21
 ecall
 3e2:	00000073          	ecall
 ret
 3e6:	8082                	ret

00000000000003e8 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e8:	4899                	li	a7,6
 ecall
 3ea:	00000073          	ecall
 ret
 3ee:	8082                	ret

00000000000003f0 <exec>:
.global exec
exec:
 li a7, SYS_exec
 3f0:	489d                	li	a7,7
 ecall
 3f2:	00000073          	ecall
 ret
 3f6:	8082                	ret

00000000000003f8 <open>:
.global open
open:
 li a7, SYS_open
 3f8:	48bd                	li	a7,15
 ecall
 3fa:	00000073          	ecall
 ret
 3fe:	8082                	ret

0000000000000400 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 400:	48c5                	li	a7,17
 ecall
 402:	00000073          	ecall
 ret
 406:	8082                	ret

0000000000000408 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 408:	48c9                	li	a7,18
 ecall
 40a:	00000073          	ecall
 ret
 40e:	8082                	ret

0000000000000410 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 410:	48a1                	li	a7,8
 ecall
 412:	00000073          	ecall
 ret
 416:	8082                	ret

0000000000000418 <link>:
.global link
link:
 li a7, SYS_link
 418:	48cd                	li	a7,19
 ecall
 41a:	00000073          	ecall
 ret
 41e:	8082                	ret

0000000000000420 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 420:	48d1                	li	a7,20
 ecall
 422:	00000073          	ecall
 ret
 426:	8082                	ret

0000000000000428 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 428:	48a5                	li	a7,9
 ecall
 42a:	00000073          	ecall
 ret
 42e:	8082                	ret

0000000000000430 <dup>:
.global dup
dup:
 li a7, SYS_dup
 430:	48a9                	li	a7,10
 ecall
 432:	00000073          	ecall
 ret
 436:	8082                	ret

0000000000000438 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 438:	48ad                	li	a7,11
 ecall
 43a:	00000073          	ecall
 ret
 43e:	8082                	ret

0000000000000440 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 440:	48b1                	li	a7,12
 ecall
 442:	00000073          	ecall
 ret
 446:	8082                	ret

0000000000000448 <pause>:
.global pause
pause:
 li a7, SYS_pause
 448:	48b5                	li	a7,13
 ecall
 44a:	00000073          	ecall
 ret
 44e:	8082                	ret

0000000000000450 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 450:	48b9                	li	a7,14
 ecall
 452:	00000073          	ecall
 ret
 456:	8082                	ret

0000000000000458 <bind>:
.global bind
bind:
 li a7, SYS_bind
 458:	48f5                	li	a7,29
 ecall
 45a:	00000073          	ecall
 ret
 45e:	8082                	ret

0000000000000460 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 460:	48f9                	li	a7,30
 ecall
 462:	00000073          	ecall
 ret
 466:	8082                	ret

0000000000000468 <send>:
.global send
send:
 li a7, SYS_send
 468:	48fd                	li	a7,31
 ecall
 46a:	00000073          	ecall
 ret
 46e:	8082                	ret

0000000000000470 <recv>:
.global recv
recv:
 li a7, SYS_recv
 470:	02000893          	li	a7,32
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 47a:	02100893          	li	a7,33
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 484:	02200893          	li	a7,34
 ecall
 488:	00000073          	ecall
 ret
 48c:	8082                	ret

000000000000048e <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 48e:	02300893          	li	a7,35
 ecall
 492:	00000073          	ecall
 ret
 496:	8082                	ret

0000000000000498 <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 498:	02400893          	li	a7,36
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4a2:	1101                	addi	sp,sp,-32
 4a4:	ec06                	sd	ra,24(sp)
 4a6:	e822                	sd	s0,16(sp)
 4a8:	1000                	addi	s0,sp,32
 4aa:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4ae:	4605                	li	a2,1
 4b0:	fef40593          	addi	a1,s0,-17
 4b4:	f25ff0ef          	jal	3d8 <write>
}
 4b8:	60e2                	ld	ra,24(sp)
 4ba:	6442                	ld	s0,16(sp)
 4bc:	6105                	addi	sp,sp,32
 4be:	8082                	ret

00000000000004c0 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 4c0:	715d                	addi	sp,sp,-80
 4c2:	e486                	sd	ra,72(sp)
 4c4:	e0a2                	sd	s0,64(sp)
 4c6:	f84a                	sd	s2,48(sp)
 4c8:	f44e                	sd	s3,40(sp)
 4ca:	0880                	addi	s0,sp,80
 4cc:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 4ce:	c6d1                	beqz	a3,55a <printint+0x9a>
 4d0:	0805d563          	bgez	a1,55a <printint+0x9a>
    neg = 1;
    x = -xx;
 4d4:	40b005b3          	neg	a1,a1
    neg = 1;
 4d8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 4da:	fb840993          	addi	s3,s0,-72
  neg = 0;
 4de:	86ce                	mv	a3,s3
  i = 0;
 4e0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 4e2:	00000817          	auipc	a6,0x0
 4e6:	60680813          	addi	a6,a6,1542 # ae8 <digits>
 4ea:	88ba                	mv	a7,a4
 4ec:	0017051b          	addiw	a0,a4,1
 4f0:	872a                	mv	a4,a0
 4f2:	02c5f7b3          	remu	a5,a1,a2
 4f6:	97c2                	add	a5,a5,a6
 4f8:	0007c783          	lbu	a5,0(a5)
 4fc:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 500:	87ae                	mv	a5,a1
 502:	02c5d5b3          	divu	a1,a1,a2
 506:	0685                	addi	a3,a3,1
 508:	fec7f1e3          	bgeu	a5,a2,4ea <printint+0x2a>
  if(neg)
 50c:	00030c63          	beqz	t1,524 <printint+0x64>
    buf[i++] = '-';
 510:	fd050793          	addi	a5,a0,-48
 514:	00878533          	add	a0,a5,s0
 518:	02d00793          	li	a5,45
 51c:	fef50423          	sb	a5,-24(a0)
 520:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 524:	02e05563          	blez	a4,54e <printint+0x8e>
 528:	fc26                	sd	s1,56(sp)
 52a:	377d                	addiw	a4,a4,-1
 52c:	00e984b3          	add	s1,s3,a4
 530:	19fd                	addi	s3,s3,-1
 532:	99ba                	add	s3,s3,a4
 534:	1702                	slli	a4,a4,0x20
 536:	9301                	srli	a4,a4,0x20
 538:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 53c:	0004c583          	lbu	a1,0(s1)
 540:	854a                	mv	a0,s2
 542:	f61ff0ef          	jal	4a2 <putc>
  while(--i >= 0)
 546:	14fd                	addi	s1,s1,-1
 548:	ff349ae3          	bne	s1,s3,53c <printint+0x7c>
 54c:	74e2                	ld	s1,56(sp)
}
 54e:	60a6                	ld	ra,72(sp)
 550:	6406                	ld	s0,64(sp)
 552:	7942                	ld	s2,48(sp)
 554:	79a2                	ld	s3,40(sp)
 556:	6161                	addi	sp,sp,80
 558:	8082                	ret
  neg = 0;
 55a:	4301                	li	t1,0
 55c:	bfbd                	j	4da <printint+0x1a>

000000000000055e <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 55e:	711d                	addi	sp,sp,-96
 560:	ec86                	sd	ra,88(sp)
 562:	e8a2                	sd	s0,80(sp)
 564:	e4a6                	sd	s1,72(sp)
 566:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 568:	0005c483          	lbu	s1,0(a1)
 56c:	22048363          	beqz	s1,792 <vprintf+0x234>
 570:	e0ca                	sd	s2,64(sp)
 572:	fc4e                	sd	s3,56(sp)
 574:	f852                	sd	s4,48(sp)
 576:	f456                	sd	s5,40(sp)
 578:	f05a                	sd	s6,32(sp)
 57a:	ec5e                	sd	s7,24(sp)
 57c:	e862                	sd	s8,16(sp)
 57e:	8b2a                	mv	s6,a0
 580:	8a2e                	mv	s4,a1
 582:	8bb2                	mv	s7,a2
  state = 0;
 584:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 586:	4901                	li	s2,0
 588:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 58a:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 58e:	06400c13          	li	s8,100
 592:	a00d                	j	5b4 <vprintf+0x56>
        putc(fd, c0);
 594:	85a6                	mv	a1,s1
 596:	855a                	mv	a0,s6
 598:	f0bff0ef          	jal	4a2 <putc>
 59c:	a019                	j	5a2 <vprintf+0x44>
    } else if(state == '%'){
 59e:	03598363          	beq	s3,s5,5c4 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5a2:	0019079b          	addiw	a5,s2,1
 5a6:	893e                	mv	s2,a5
 5a8:	873e                	mv	a4,a5
 5aa:	97d2                	add	a5,a5,s4
 5ac:	0007c483          	lbu	s1,0(a5)
 5b0:	1c048a63          	beqz	s1,784 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5b4:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5b8:	fe0993e3          	bnez	s3,59e <vprintf+0x40>
      if(c0 == '%'){
 5bc:	fd579ce3          	bne	a5,s5,594 <vprintf+0x36>
        state = '%';
 5c0:	89be                	mv	s3,a5
 5c2:	b7c5                	j	5a2 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 5c4:	00ea06b3          	add	a3,s4,a4
 5c8:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 5cc:	1c060863          	beqz	a2,79c <vprintf+0x23e>
      if(c0 == 'd'){
 5d0:	03878763          	beq	a5,s8,5fe <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 5d4:	f9478693          	addi	a3,a5,-108
 5d8:	0016b693          	seqz	a3,a3
 5dc:	f9c60593          	addi	a1,a2,-100
 5e0:	e99d                	bnez	a1,616 <vprintf+0xb8>
 5e2:	ca95                	beqz	a3,616 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5e4:	008b8493          	addi	s1,s7,8
 5e8:	4685                	li	a3,1
 5ea:	4629                	li	a2,10
 5ec:	000bb583          	ld	a1,0(s7)
 5f0:	855a                	mv	a0,s6
 5f2:	ecfff0ef          	jal	4c0 <printint>
        i += 1;
 5f6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f8:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5fa:	4981                	li	s3,0
 5fc:	b75d                	j	5a2 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5fe:	008b8493          	addi	s1,s7,8
 602:	4685                	li	a3,1
 604:	4629                	li	a2,10
 606:	000ba583          	lw	a1,0(s7)
 60a:	855a                	mv	a0,s6
 60c:	eb5ff0ef          	jal	4c0 <printint>
 610:	8ba6                	mv	s7,s1
      state = 0;
 612:	4981                	li	s3,0
 614:	b779                	j	5a2 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 616:	9752                	add	a4,a4,s4
 618:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 61c:	f9460713          	addi	a4,a2,-108
 620:	00173713          	seqz	a4,a4
 624:	8f75                	and	a4,a4,a3
 626:	f9c58513          	addi	a0,a1,-100
 62a:	18051363          	bnez	a0,7b0 <vprintf+0x252>
 62e:	18070163          	beqz	a4,7b0 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 632:	008b8493          	addi	s1,s7,8
 636:	4685                	li	a3,1
 638:	4629                	li	a2,10
 63a:	000bb583          	ld	a1,0(s7)
 63e:	855a                	mv	a0,s6
 640:	e81ff0ef          	jal	4c0 <printint>
        i += 2;
 644:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 646:	8ba6                	mv	s7,s1
      state = 0;
 648:	4981                	li	s3,0
        i += 2;
 64a:	bfa1                	j	5a2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 64c:	008b8493          	addi	s1,s7,8
 650:	4681                	li	a3,0
 652:	4629                	li	a2,10
 654:	000be583          	lwu	a1,0(s7)
 658:	855a                	mv	a0,s6
 65a:	e67ff0ef          	jal	4c0 <printint>
 65e:	8ba6                	mv	s7,s1
      state = 0;
 660:	4981                	li	s3,0
 662:	b781                	j	5a2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 664:	008b8493          	addi	s1,s7,8
 668:	4681                	li	a3,0
 66a:	4629                	li	a2,10
 66c:	000bb583          	ld	a1,0(s7)
 670:	855a                	mv	a0,s6
 672:	e4fff0ef          	jal	4c0 <printint>
        i += 1;
 676:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 678:	8ba6                	mv	s7,s1
      state = 0;
 67a:	4981                	li	s3,0
 67c:	b71d                	j	5a2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 67e:	008b8493          	addi	s1,s7,8
 682:	4681                	li	a3,0
 684:	4629                	li	a2,10
 686:	000bb583          	ld	a1,0(s7)
 68a:	855a                	mv	a0,s6
 68c:	e35ff0ef          	jal	4c0 <printint>
        i += 2;
 690:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 692:	8ba6                	mv	s7,s1
      state = 0;
 694:	4981                	li	s3,0
        i += 2;
 696:	b731                	j	5a2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 698:	008b8493          	addi	s1,s7,8
 69c:	4681                	li	a3,0
 69e:	4641                	li	a2,16
 6a0:	000be583          	lwu	a1,0(s7)
 6a4:	855a                	mv	a0,s6
 6a6:	e1bff0ef          	jal	4c0 <printint>
 6aa:	8ba6                	mv	s7,s1
      state = 0;
 6ac:	4981                	li	s3,0
 6ae:	bdd5                	j	5a2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6b0:	008b8493          	addi	s1,s7,8
 6b4:	4681                	li	a3,0
 6b6:	4641                	li	a2,16
 6b8:	000bb583          	ld	a1,0(s7)
 6bc:	855a                	mv	a0,s6
 6be:	e03ff0ef          	jal	4c0 <printint>
        i += 1;
 6c2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 6c4:	8ba6                	mv	s7,s1
      state = 0;
 6c6:	4981                	li	s3,0
 6c8:	bde9                	j	5a2 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6ca:	008b8493          	addi	s1,s7,8
 6ce:	4681                	li	a3,0
 6d0:	4641                	li	a2,16
 6d2:	000bb583          	ld	a1,0(s7)
 6d6:	855a                	mv	a0,s6
 6d8:	de9ff0ef          	jal	4c0 <printint>
        i += 2;
 6dc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 6de:	8ba6                	mv	s7,s1
      state = 0;
 6e0:	4981                	li	s3,0
        i += 2;
 6e2:	b5c1                	j	5a2 <vprintf+0x44>
 6e4:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6e6:	008b8793          	addi	a5,s7,8
 6ea:	8cbe                	mv	s9,a5
 6ec:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6f0:	03000593          	li	a1,48
 6f4:	855a                	mv	a0,s6
 6f6:	dadff0ef          	jal	4a2 <putc>
  putc(fd, 'x');
 6fa:	07800593          	li	a1,120
 6fe:	855a                	mv	a0,s6
 700:	da3ff0ef          	jal	4a2 <putc>
 704:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 706:	00000b97          	auipc	s7,0x0
 70a:	3e2b8b93          	addi	s7,s7,994 # ae8 <digits>
 70e:	03c9d793          	srli	a5,s3,0x3c
 712:	97de                	add	a5,a5,s7
 714:	0007c583          	lbu	a1,0(a5)
 718:	855a                	mv	a0,s6
 71a:	d89ff0ef          	jal	4a2 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 71e:	0992                	slli	s3,s3,0x4
 720:	34fd                	addiw	s1,s1,-1
 722:	f4f5                	bnez	s1,70e <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 724:	8be6                	mv	s7,s9
      state = 0;
 726:	4981                	li	s3,0
 728:	6ca2                	ld	s9,8(sp)
 72a:	bda5                	j	5a2 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 72c:	008b8493          	addi	s1,s7,8
 730:	000bc583          	lbu	a1,0(s7)
 734:	855a                	mv	a0,s6
 736:	d6dff0ef          	jal	4a2 <putc>
 73a:	8ba6                	mv	s7,s1
      state = 0;
 73c:	4981                	li	s3,0
 73e:	b595                	j	5a2 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 740:	008b8993          	addi	s3,s7,8
 744:	000bb483          	ld	s1,0(s7)
 748:	cc91                	beqz	s1,764 <vprintf+0x206>
        for(; *s; s++)
 74a:	0004c583          	lbu	a1,0(s1)
 74e:	c985                	beqz	a1,77e <vprintf+0x220>
          putc(fd, *s);
 750:	855a                	mv	a0,s6
 752:	d51ff0ef          	jal	4a2 <putc>
        for(; *s; s++)
 756:	0485                	addi	s1,s1,1
 758:	0004c583          	lbu	a1,0(s1)
 75c:	f9f5                	bnez	a1,750 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 75e:	8bce                	mv	s7,s3
      state = 0;
 760:	4981                	li	s3,0
 762:	b581                	j	5a2 <vprintf+0x44>
          s = "(null)";
 764:	00000497          	auipc	s1,0x0
 768:	35448493          	addi	s1,s1,852 # ab8 <statistics+0xc6>
        for(; *s; s++)
 76c:	02800593          	li	a1,40
 770:	b7c5                	j	750 <vprintf+0x1f2>
        putc(fd, '%');
 772:	85be                	mv	a1,a5
 774:	855a                	mv	a0,s6
 776:	d2dff0ef          	jal	4a2 <putc>
      state = 0;
 77a:	4981                	li	s3,0
 77c:	b51d                	j	5a2 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 77e:	8bce                	mv	s7,s3
      state = 0;
 780:	4981                	li	s3,0
 782:	b505                	j	5a2 <vprintf+0x44>
 784:	6906                	ld	s2,64(sp)
 786:	79e2                	ld	s3,56(sp)
 788:	7a42                	ld	s4,48(sp)
 78a:	7aa2                	ld	s5,40(sp)
 78c:	7b02                	ld	s6,32(sp)
 78e:	6be2                	ld	s7,24(sp)
 790:	6c42                	ld	s8,16(sp)
    }
  }
}
 792:	60e6                	ld	ra,88(sp)
 794:	6446                	ld	s0,80(sp)
 796:	64a6                	ld	s1,72(sp)
 798:	6125                	addi	sp,sp,96
 79a:	8082                	ret
      if(c0 == 'd'){
 79c:	06400713          	li	a4,100
 7a0:	e4e78fe3          	beq	a5,a4,5fe <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7a4:	f9478693          	addi	a3,a5,-108
 7a8:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7ac:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7ae:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7b0:	07500513          	li	a0,117
 7b4:	e8a78ce3          	beq	a5,a0,64c <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7b8:	f8b60513          	addi	a0,a2,-117
 7bc:	e119                	bnez	a0,7c2 <vprintf+0x264>
 7be:	ea0693e3          	bnez	a3,664 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 7c2:	f8b58513          	addi	a0,a1,-117
 7c6:	e119                	bnez	a0,7cc <vprintf+0x26e>
 7c8:	ea071be3          	bnez	a4,67e <vprintf+0x120>
      } else if(c0 == 'x'){
 7cc:	07800513          	li	a0,120
 7d0:	eca784e3          	beq	a5,a0,698 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 7d4:	f8860613          	addi	a2,a2,-120
 7d8:	e219                	bnez	a2,7de <vprintf+0x280>
 7da:	ec069be3          	bnez	a3,6b0 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 7de:	f8858593          	addi	a1,a1,-120
 7e2:	e199                	bnez	a1,7e8 <vprintf+0x28a>
 7e4:	ee0713e3          	bnez	a4,6ca <vprintf+0x16c>
      } else if(c0 == 'p'){
 7e8:	07000713          	li	a4,112
 7ec:	eee78ce3          	beq	a5,a4,6e4 <vprintf+0x186>
      } else if(c0 == 'c'){
 7f0:	06300713          	li	a4,99
 7f4:	f2e78ce3          	beq	a5,a4,72c <vprintf+0x1ce>
      } else if(c0 == 's'){
 7f8:	07300713          	li	a4,115
 7fc:	f4e782e3          	beq	a5,a4,740 <vprintf+0x1e2>
      } else if(c0 == '%'){
 800:	02500713          	li	a4,37
 804:	f6e787e3          	beq	a5,a4,772 <vprintf+0x214>
        putc(fd, '%');
 808:	02500593          	li	a1,37
 80c:	855a                	mv	a0,s6
 80e:	c95ff0ef          	jal	4a2 <putc>
        putc(fd, c0);
 812:	85a6                	mv	a1,s1
 814:	855a                	mv	a0,s6
 816:	c8dff0ef          	jal	4a2 <putc>
      state = 0;
 81a:	4981                	li	s3,0
 81c:	b359                	j	5a2 <vprintf+0x44>

000000000000081e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 81e:	715d                	addi	sp,sp,-80
 820:	ec06                	sd	ra,24(sp)
 822:	e822                	sd	s0,16(sp)
 824:	1000                	addi	s0,sp,32
 826:	e010                	sd	a2,0(s0)
 828:	e414                	sd	a3,8(s0)
 82a:	e818                	sd	a4,16(s0)
 82c:	ec1c                	sd	a5,24(s0)
 82e:	03043023          	sd	a6,32(s0)
 832:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 836:	8622                	mv	a2,s0
 838:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 83c:	d23ff0ef          	jal	55e <vprintf>
}
 840:	60e2                	ld	ra,24(sp)
 842:	6442                	ld	s0,16(sp)
 844:	6161                	addi	sp,sp,80
 846:	8082                	ret

0000000000000848 <printf>:

void
printf(const char *fmt, ...)
{
 848:	711d                	addi	sp,sp,-96
 84a:	ec06                	sd	ra,24(sp)
 84c:	e822                	sd	s0,16(sp)
 84e:	1000                	addi	s0,sp,32
 850:	e40c                	sd	a1,8(s0)
 852:	e810                	sd	a2,16(s0)
 854:	ec14                	sd	a3,24(s0)
 856:	f018                	sd	a4,32(s0)
 858:	f41c                	sd	a5,40(s0)
 85a:	03043823          	sd	a6,48(s0)
 85e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 862:	00840613          	addi	a2,s0,8
 866:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 86a:	85aa                	mv	a1,a0
 86c:	4505                	li	a0,1
 86e:	cf1ff0ef          	jal	55e <vprintf>
}
 872:	60e2                	ld	ra,24(sp)
 874:	6442                	ld	s0,16(sp)
 876:	6125                	addi	sp,sp,96
 878:	8082                	ret

000000000000087a <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 87a:	1141                	addi	sp,sp,-16
 87c:	e406                	sd	ra,8(sp)
 87e:	e022                	sd	s0,0(sp)
 880:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 882:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 886:	00000797          	auipc	a5,0x0
 88a:	77a7b783          	ld	a5,1914(a5) # 1000 <freep>
 88e:	a039                	j	89c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 890:	6398                	ld	a4,0(a5)
 892:	00e7e463          	bltu	a5,a4,89a <free+0x20>
 896:	00e6ea63          	bltu	a3,a4,8aa <free+0x30>
{
 89a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 89c:	fed7fae3          	bgeu	a5,a3,890 <free+0x16>
 8a0:	6398                	ld	a4,0(a5)
 8a2:	00e6e463          	bltu	a3,a4,8aa <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8a6:	fee7eae3          	bltu	a5,a4,89a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8aa:	ff852583          	lw	a1,-8(a0)
 8ae:	6390                	ld	a2,0(a5)
 8b0:	02059813          	slli	a6,a1,0x20
 8b4:	01c85713          	srli	a4,a6,0x1c
 8b8:	9736                	add	a4,a4,a3
 8ba:	02e60563          	beq	a2,a4,8e4 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 8be:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 8c2:	4790                	lw	a2,8(a5)
 8c4:	02061593          	slli	a1,a2,0x20
 8c8:	01c5d713          	srli	a4,a1,0x1c
 8cc:	973e                	add	a4,a4,a5
 8ce:	02e68263          	beq	a3,a4,8f2 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 8d2:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 8d4:	00000717          	auipc	a4,0x0
 8d8:	72f73623          	sd	a5,1836(a4) # 1000 <freep>
}
 8dc:	60a2                	ld	ra,8(sp)
 8de:	6402                	ld	s0,0(sp)
 8e0:	0141                	addi	sp,sp,16
 8e2:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8e4:	4618                	lw	a4,8(a2)
 8e6:	9f2d                	addw	a4,a4,a1
 8e8:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8ec:	6398                	ld	a4,0(a5)
 8ee:	6310                	ld	a2,0(a4)
 8f0:	b7f9                	j	8be <free+0x44>
    p->s.size += bp->s.size;
 8f2:	ff852703          	lw	a4,-8(a0)
 8f6:	9f31                	addw	a4,a4,a2
 8f8:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8fa:	ff053683          	ld	a3,-16(a0)
 8fe:	bfd1                	j	8d2 <free+0x58>

0000000000000900 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 900:	7139                	addi	sp,sp,-64
 902:	fc06                	sd	ra,56(sp)
 904:	f822                	sd	s0,48(sp)
 906:	f04a                	sd	s2,32(sp)
 908:	ec4e                	sd	s3,24(sp)
 90a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 90c:	02051993          	slli	s3,a0,0x20
 910:	0209d993          	srli	s3,s3,0x20
 914:	09bd                	addi	s3,s3,15
 916:	0049d993          	srli	s3,s3,0x4
 91a:	2985                	addiw	s3,s3,1
 91c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 91e:	00000517          	auipc	a0,0x0
 922:	6e253503          	ld	a0,1762(a0) # 1000 <freep>
 926:	c905                	beqz	a0,956 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 928:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 92a:	4798                	lw	a4,8(a5)
 92c:	09377663          	bgeu	a4,s3,9b8 <malloc+0xb8>
 930:	f426                	sd	s1,40(sp)
 932:	e852                	sd	s4,16(sp)
 934:	e456                	sd	s5,8(sp)
 936:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 938:	8a4e                	mv	s4,s3
 93a:	6705                	lui	a4,0x1
 93c:	00e9f363          	bgeu	s3,a4,942 <malloc+0x42>
 940:	6a05                	lui	s4,0x1
 942:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 946:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 94a:	00000497          	auipc	s1,0x0
 94e:	6b648493          	addi	s1,s1,1718 # 1000 <freep>
  if(p == SBRK_ERROR)
 952:	5afd                	li	s5,-1
 954:	a83d                	j	992 <malloc+0x92>
 956:	f426                	sd	s1,40(sp)
 958:	e852                	sd	s4,16(sp)
 95a:	e456                	sd	s5,8(sp)
 95c:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 95e:	00001797          	auipc	a5,0x1
 962:	8aa78793          	addi	a5,a5,-1878 # 1208 <base>
 966:	00000717          	auipc	a4,0x0
 96a:	68f73d23          	sd	a5,1690(a4) # 1000 <freep>
 96e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 970:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 974:	b7d1                	j	938 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 976:	6398                	ld	a4,0(a5)
 978:	e118                	sd	a4,0(a0)
 97a:	a899                	j	9d0 <malloc+0xd0>
  hp->s.size = nu;
 97c:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 980:	0541                	addi	a0,a0,16
 982:	ef9ff0ef          	jal	87a <free>
  return freep;
 986:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 988:	c125                	beqz	a0,9e8 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 98a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 98c:	4798                	lw	a4,8(a5)
 98e:	03277163          	bgeu	a4,s2,9b0 <malloc+0xb0>
    if(p == freep)
 992:	6098                	ld	a4,0(s1)
 994:	853e                	mv	a0,a5
 996:	fef71ae3          	bne	a4,a5,98a <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 99a:	8552                	mv	a0,s4
 99c:	9e9ff0ef          	jal	384 <sbrk>
  if(p == SBRK_ERROR)
 9a0:	fd551ee3          	bne	a0,s5,97c <malloc+0x7c>
        return 0;
 9a4:	4501                	li	a0,0
 9a6:	74a2                	ld	s1,40(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
 9ae:	a03d                	j	9dc <malloc+0xdc>
 9b0:	74a2                	ld	s1,40(sp)
 9b2:	6a42                	ld	s4,16(sp)
 9b4:	6aa2                	ld	s5,8(sp)
 9b6:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9b8:	fae90fe3          	beq	s2,a4,976 <malloc+0x76>
        p->s.size -= nunits;
 9bc:	4137073b          	subw	a4,a4,s3
 9c0:	c798                	sw	a4,8(a5)
        p += p->s.size;
 9c2:	02071693          	slli	a3,a4,0x20
 9c6:	01c6d713          	srli	a4,a3,0x1c
 9ca:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 9cc:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 9d0:	00000717          	auipc	a4,0x0
 9d4:	62a73823          	sd	a0,1584(a4) # 1000 <freep>
      return (void*)(p + 1);
 9d8:	01078513          	addi	a0,a5,16
  }
}
 9dc:	70e2                	ld	ra,56(sp)
 9de:	7442                	ld	s0,48(sp)
 9e0:	7902                	ld	s2,32(sp)
 9e2:	69e2                	ld	s3,24(sp)
 9e4:	6121                	addi	sp,sp,64
 9e6:	8082                	ret
 9e8:	74a2                	ld	s1,40(sp)
 9ea:	6a42                	ld	s4,16(sp)
 9ec:	6aa2                	ld	s5,8(sp)
 9ee:	6b02                	ld	s6,0(sp)
 9f0:	b7f5                	j	9dc <malloc+0xdc>

00000000000009f2 <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 9f2:	7179                	addi	sp,sp,-48
 9f4:	f406                	sd	ra,40(sp)
 9f6:	f022                	sd	s0,32(sp)
 9f8:	ec26                	sd	s1,24(sp)
 9fa:	e84a                	sd	s2,16(sp)
 9fc:	e44e                	sd	s3,8(sp)
 9fe:	e052                	sd	s4,0(sp)
 a00:	1800                	addi	s0,sp,48
 a02:	8a2a                	mv	s4,a0
 a04:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 a06:	4581                	li	a1,0
 a08:	00000517          	auipc	a0,0x0
 a0c:	0b850513          	addi	a0,a0,184 # ac0 <statistics+0xce>
 a10:	9e9ff0ef          	jal	3f8 <open>
  if(fd < 0) {
 a14:	02054e63          	bltz	a0,a50 <statistics+0x5e>
 a18:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 a1a:	4481                	li	s1,0
 a1c:	01205e63          	blez	s2,a38 <statistics+0x46>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 a20:	4099063b          	subw	a2,s2,s1
 a24:	009a05b3          	add	a1,s4,s1
 a28:	854e                	mv	a0,s3
 a2a:	9a7ff0ef          	jal	3d0 <read>
 a2e:	00054563          	bltz	a0,a38 <statistics+0x46>
      break;
    }
    i += n;
 a32:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 a34:	ff24c6e3          	blt	s1,s2,a20 <statistics+0x2e>
  }
  close(fd);
 a38:	854e                	mv	a0,s3
 a3a:	9a7ff0ef          	jal	3e0 <close>
  return i;
}
 a3e:	8526                	mv	a0,s1
 a40:	70a2                	ld	ra,40(sp)
 a42:	7402                	ld	s0,32(sp)
 a44:	64e2                	ld	s1,24(sp)
 a46:	6942                	ld	s2,16(sp)
 a48:	69a2                	ld	s3,8(sp)
 a4a:	6a02                	ld	s4,0(sp)
 a4c:	6145                	addi	sp,sp,48
 a4e:	8082                	ret
      fprintf(2, "stats: open failed\n");
 a50:	00000597          	auipc	a1,0x0
 a54:	08058593          	addi	a1,a1,128 # ad0 <statistics+0xde>
 a58:	4509                	li	a0,2
 a5a:	dc5ff0ef          	jal	81e <fprintf>
      exit(1);
 a5e:	4505                	li	a0,1
 a60:	959ff0ef          	jal	3b8 <exit>
