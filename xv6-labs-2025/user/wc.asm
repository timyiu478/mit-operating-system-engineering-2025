
user/_wc:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <wc>:

char buf[512];

void
wc(int fd, char *name)
{
   0:	7119                	addi	sp,sp,-128
   2:	fc86                	sd	ra,120(sp)
   4:	f8a2                	sd	s0,112(sp)
   6:	f4a6                	sd	s1,104(sp)
   8:	f0ca                	sd	s2,96(sp)
   a:	ecce                	sd	s3,88(sp)
   c:	e8d2                	sd	s4,80(sp)
   e:	e4d6                	sd	s5,72(sp)
  10:	e0da                	sd	s6,64(sp)
  12:	fc5e                	sd	s7,56(sp)
  14:	f862                	sd	s8,48(sp)
  16:	f466                	sd	s9,40(sp)
  18:	f06a                	sd	s10,32(sp)
  1a:	ec6e                	sd	s11,24(sp)
  1c:	0100                	addi	s0,sp,128
  1e:	f8a43423          	sd	a0,-120(s0)
  22:	f8b43023          	sd	a1,-128(s0)
  int i, n;
  int l, w, c, inword;

  l = w = c = 0;
  inword = 0;
  26:	4901                	li	s2,0
  l = w = c = 0;
  28:	4c81                	li	s9,0
  2a:	4c01                	li	s8,0
  2c:	4b81                	li	s7,0
  while((n = read(fd, buf, sizeof(buf))) > 0){
  2e:	20000d93          	li	s11,512
  32:	00001d17          	auipc	s10,0x1
  36:	fded0d13          	addi	s10,s10,-34 # 1010 <buf>
    for(i=0; i<n; i++){
      c++;
      if(buf[i] == '\n')
  3a:	4aa9                	li	s5,10
        l++;
      if(strchr(" \r\t\n\v", buf[i]))
  3c:	00001a17          	auipc	s4,0x1
  40:	a04a0a13          	addi	s4,s4,-1532 # a40 <malloc+0xfa>
  while((n = read(fd, buf, sizeof(buf))) > 0){
  44:	a035                	j	70 <wc+0x70>
      if(strchr(" \r\t\n\v", buf[i]))
  46:	8552                	mv	a0,s4
  48:	1c6000ef          	jal	20e <strchr>
  4c:	c919                	beqz	a0,62 <wc+0x62>
        inword = 0;
  4e:	4901                	li	s2,0
    for(i=0; i<n; i++){
  50:	0485                	addi	s1,s1,1
  52:	01348d63          	beq	s1,s3,6c <wc+0x6c>
      if(buf[i] == '\n')
  56:	0004c583          	lbu	a1,0(s1)
  5a:	ff5596e3          	bne	a1,s5,46 <wc+0x46>
        l++;
  5e:	2b85                	addiw	s7,s7,1
  60:	b7dd                	j	46 <wc+0x46>
      else if(!inword){
  62:	fe0917e3          	bnez	s2,50 <wc+0x50>
        w++;
  66:	2c05                	addiw	s8,s8,1
        inword = 1;
  68:	4905                	li	s2,1
  6a:	b7dd                	j	50 <wc+0x50>
  6c:	019b0cbb          	addw	s9,s6,s9
  while((n = read(fd, buf, sizeof(buf))) > 0){
  70:	866e                	mv	a2,s11
  72:	85ea                	mv	a1,s10
  74:	f8843503          	ld	a0,-120(s0)
  78:	3b2000ef          	jal	42a <read>
  7c:	8b2a                	mv	s6,a0
  7e:	00a05963          	blez	a0,90 <wc+0x90>
  82:	00001497          	auipc	s1,0x1
  86:	f8e48493          	addi	s1,s1,-114 # 1010 <buf>
  8a:	009b09b3          	add	s3,s6,s1
  8e:	b7e1                	j	56 <wc+0x56>
      }
    }
  }
  if(n < 0){
  90:	02054c63          	bltz	a0,c8 <wc+0xc8>
    printf("wc: read error\n");
    exit(1);
  }
  printf("%d %d %d %s\n", l, w, c, name);
  94:	f8043703          	ld	a4,-128(s0)
  98:	86e6                	mv	a3,s9
  9a:	8662                	mv	a2,s8
  9c:	85de                	mv	a1,s7
  9e:	00001517          	auipc	a0,0x1
  a2:	9c250513          	addi	a0,a0,-1598 # a60 <malloc+0x11a>
  a6:	7e8000ef          	jal	88e <printf>
}
  aa:	70e6                	ld	ra,120(sp)
  ac:	7446                	ld	s0,112(sp)
  ae:	74a6                	ld	s1,104(sp)
  b0:	7906                	ld	s2,96(sp)
  b2:	69e6                	ld	s3,88(sp)
  b4:	6a46                	ld	s4,80(sp)
  b6:	6aa6                	ld	s5,72(sp)
  b8:	6b06                	ld	s6,64(sp)
  ba:	7be2                	ld	s7,56(sp)
  bc:	7c42                	ld	s8,48(sp)
  be:	7ca2                	ld	s9,40(sp)
  c0:	7d02                	ld	s10,32(sp)
  c2:	6de2                	ld	s11,24(sp)
  c4:	6109                	addi	sp,sp,128
  c6:	8082                	ret
    printf("wc: read error\n");
  c8:	00001517          	auipc	a0,0x1
  cc:	98850513          	addi	a0,a0,-1656 # a50 <malloc+0x10a>
  d0:	7be000ef          	jal	88e <printf>
    exit(1);
  d4:	4505                	li	a0,1
  d6:	33c000ef          	jal	412 <exit>

00000000000000da <main>:

int
main(int argc, char *argv[])
{
  da:	7179                	addi	sp,sp,-48
  dc:	f406                	sd	ra,40(sp)
  de:	f022                	sd	s0,32(sp)
  e0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
  e2:	4785                	li	a5,1
  e4:	04a7d463          	bge	a5,a0,12c <main+0x52>
  e8:	ec26                	sd	s1,24(sp)
  ea:	e84a                	sd	s2,16(sp)
  ec:	e44e                	sd	s3,8(sp)
  ee:	00858913          	addi	s2,a1,8
  f2:	ffe5099b          	addiw	s3,a0,-2
  f6:	02099793          	slli	a5,s3,0x20
  fa:	01d7d993          	srli	s3,a5,0x1d
  fe:	05c1                	addi	a1,a1,16
 100:	99ae                	add	s3,s3,a1
    wc(0, "");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 102:	4581                	li	a1,0
 104:	00093503          	ld	a0,0(s2)
 108:	34a000ef          	jal	452 <open>
 10c:	84aa                	mv	s1,a0
 10e:	02054c63          	bltz	a0,146 <main+0x6c>
      printf("wc: cannot open %s\n", argv[i]);
      exit(1);
    }
    wc(fd, argv[i]);
 112:	00093583          	ld	a1,0(s2)
 116:	eebff0ef          	jal	0 <wc>
    close(fd);
 11a:	8526                	mv	a0,s1
 11c:	31e000ef          	jal	43a <close>
  for(i = 1; i < argc; i++){
 120:	0921                	addi	s2,s2,8
 122:	ff3910e3          	bne	s2,s3,102 <main+0x28>
  }
  exit(0);
 126:	4501                	li	a0,0
 128:	2ea000ef          	jal	412 <exit>
 12c:	ec26                	sd	s1,24(sp)
 12e:	e84a                	sd	s2,16(sp)
 130:	e44e                	sd	s3,8(sp)
    wc(0, "");
 132:	00001597          	auipc	a1,0x1
 136:	91658593          	addi	a1,a1,-1770 # a48 <malloc+0x102>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2d0000ef          	jal	412 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	92650513          	addi	a0,a0,-1754 # a70 <malloc+0x12a>
 152:	73c000ef          	jal	88e <printf>
      exit(1);
 156:	4505                	li	a0,1
 158:	2ba000ef          	jal	412 <exit>

000000000000015c <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 164:	f77ff0ef          	jal	da <main>
  exit(r);
 168:	2aa000ef          	jal	412 <exit>

000000000000016c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e406                	sd	ra,8(sp)
 170:	e022                	sd	s0,0(sp)
 172:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 174:	87aa                	mv	a5,a0
 176:	0585                	addi	a1,a1,1
 178:	0785                	addi	a5,a5,1
 17a:	fff5c703          	lbu	a4,-1(a1)
 17e:	fee78fa3          	sb	a4,-1(a5)
 182:	fb75                	bnez	a4,176 <strcpy+0xa>
    ;
  return os;
}
 184:	60a2                	ld	ra,8(sp)
 186:	6402                	ld	s0,0(sp)
 188:	0141                	addi	sp,sp,16
 18a:	8082                	ret

000000000000018c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 18c:	1141                	addi	sp,sp,-16
 18e:	e406                	sd	ra,8(sp)
 190:	e022                	sd	s0,0(sp)
 192:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 194:	00054783          	lbu	a5,0(a0)
 198:	cb91                	beqz	a5,1ac <strcmp+0x20>
 19a:	0005c703          	lbu	a4,0(a1)
 19e:	00f71763          	bne	a4,a5,1ac <strcmp+0x20>
    p++, q++;
 1a2:	0505                	addi	a0,a0,1
 1a4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 1a6:	00054783          	lbu	a5,0(a0)
 1aa:	fbe5                	bnez	a5,19a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 1ac:	0005c503          	lbu	a0,0(a1)
}
 1b0:	40a7853b          	subw	a0,a5,a0
 1b4:	60a2                	ld	ra,8(sp)
 1b6:	6402                	ld	s0,0(sp)
 1b8:	0141                	addi	sp,sp,16
 1ba:	8082                	ret

00000000000001bc <strlen>:

uint
strlen(const char *s)
{
 1bc:	1141                	addi	sp,sp,-16
 1be:	e406                	sd	ra,8(sp)
 1c0:	e022                	sd	s0,0(sp)
 1c2:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 1c4:	00054783          	lbu	a5,0(a0)
 1c8:	cf91                	beqz	a5,1e4 <strlen+0x28>
 1ca:	00150793          	addi	a5,a0,1
 1ce:	86be                	mv	a3,a5
 1d0:	0785                	addi	a5,a5,1
 1d2:	fff7c703          	lbu	a4,-1(a5)
 1d6:	ff65                	bnez	a4,1ce <strlen+0x12>
 1d8:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 1dc:	60a2                	ld	ra,8(sp)
 1de:	6402                	ld	s0,0(sp)
 1e0:	0141                	addi	sp,sp,16
 1e2:	8082                	ret
  for(n = 0; s[n]; n++)
 1e4:	4501                	li	a0,0
 1e6:	bfdd                	j	1dc <strlen+0x20>

00000000000001e8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 1e8:	1141                	addi	sp,sp,-16
 1ea:	e406                	sd	ra,8(sp)
 1ec:	e022                	sd	s0,0(sp)
 1ee:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 1f0:	ca19                	beqz	a2,206 <memset+0x1e>
 1f2:	87aa                	mv	a5,a0
 1f4:	1602                	slli	a2,a2,0x20
 1f6:	9201                	srli	a2,a2,0x20
 1f8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 1fc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 200:	0785                	addi	a5,a5,1
 202:	fee79de3          	bne	a5,a4,1fc <memset+0x14>
  }
  return dst;
}
 206:	60a2                	ld	ra,8(sp)
 208:	6402                	ld	s0,0(sp)
 20a:	0141                	addi	sp,sp,16
 20c:	8082                	ret

000000000000020e <strchr>:

char*
strchr(const char *s, char c)
{
 20e:	1141                	addi	sp,sp,-16
 210:	e406                	sd	ra,8(sp)
 212:	e022                	sd	s0,0(sp)
 214:	0800                	addi	s0,sp,16
  for(; *s; s++)
 216:	00054783          	lbu	a5,0(a0)
 21a:	cf81                	beqz	a5,232 <strchr+0x24>
    if(*s == c)
 21c:	00f58763          	beq	a1,a5,22a <strchr+0x1c>
  for(; *s; s++)
 220:	0505                	addi	a0,a0,1
 222:	00054783          	lbu	a5,0(a0)
 226:	fbfd                	bnez	a5,21c <strchr+0xe>
      return (char*)s;
  return 0;
 228:	4501                	li	a0,0
}
 22a:	60a2                	ld	ra,8(sp)
 22c:	6402                	ld	s0,0(sp)
 22e:	0141                	addi	sp,sp,16
 230:	8082                	ret
  return 0;
 232:	4501                	li	a0,0
 234:	bfdd                	j	22a <strchr+0x1c>

0000000000000236 <gets>:

char*
gets(char *buf, int max)
{
 236:	711d                	addi	sp,sp,-96
 238:	ec86                	sd	ra,88(sp)
 23a:	e8a2                	sd	s0,80(sp)
 23c:	e4a6                	sd	s1,72(sp)
 23e:	e0ca                	sd	s2,64(sp)
 240:	fc4e                	sd	s3,56(sp)
 242:	f852                	sd	s4,48(sp)
 244:	f456                	sd	s5,40(sp)
 246:	f05a                	sd	s6,32(sp)
 248:	ec5e                	sd	s7,24(sp)
 24a:	e862                	sd	s8,16(sp)
 24c:	1080                	addi	s0,sp,96
 24e:	8baa                	mv	s7,a0
 250:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 252:	892a                	mv	s2,a0
 254:	4481                	li	s1,0
    cc = read(0, &c, 1);
 256:	faf40b13          	addi	s6,s0,-81
 25a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 25c:	8c26                	mv	s8,s1
 25e:	0014899b          	addiw	s3,s1,1
 262:	84ce                	mv	s1,s3
 264:	0349d463          	bge	s3,s4,28c <gets+0x56>
    cc = read(0, &c, 1);
 268:	8656                	mv	a2,s5
 26a:	85da                	mv	a1,s6
 26c:	4501                	li	a0,0
 26e:	1bc000ef          	jal	42a <read>
    if(cc < 1)
 272:	00a05d63          	blez	a0,28c <gets+0x56>
      break;
    buf[i++] = c;
 276:	faf44783          	lbu	a5,-81(s0)
 27a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 27e:	0905                	addi	s2,s2,1
 280:	ff678713          	addi	a4,a5,-10
 284:	c319                	beqz	a4,28a <gets+0x54>
 286:	17cd                	addi	a5,a5,-13
 288:	fbf1                	bnez	a5,25c <gets+0x26>
    buf[i++] = c;
 28a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 28c:	9c5e                	add	s8,s8,s7
 28e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 292:	855e                	mv	a0,s7
 294:	60e6                	ld	ra,88(sp)
 296:	6446                	ld	s0,80(sp)
 298:	64a6                	ld	s1,72(sp)
 29a:	6906                	ld	s2,64(sp)
 29c:	79e2                	ld	s3,56(sp)
 29e:	7a42                	ld	s4,48(sp)
 2a0:	7aa2                	ld	s5,40(sp)
 2a2:	7b02                	ld	s6,32(sp)
 2a4:	6be2                	ld	s7,24(sp)
 2a6:	6c42                	ld	s8,16(sp)
 2a8:	6125                	addi	sp,sp,96
 2aa:	8082                	ret

00000000000002ac <stat>:

int
stat(const char *n, struct stat *st)
{
 2ac:	1101                	addi	sp,sp,-32
 2ae:	ec06                	sd	ra,24(sp)
 2b0:	e822                	sd	s0,16(sp)
 2b2:	e04a                	sd	s2,0(sp)
 2b4:	1000                	addi	s0,sp,32
 2b6:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 2b8:	4581                	li	a1,0
 2ba:	198000ef          	jal	452 <open>
  if(fd < 0)
 2be:	02054263          	bltz	a0,2e2 <stat+0x36>
 2c2:	e426                	sd	s1,8(sp)
 2c4:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 2c6:	85ca                	mv	a1,s2
 2c8:	1a2000ef          	jal	46a <fstat>
 2cc:	892a                	mv	s2,a0
  close(fd);
 2ce:	8526                	mv	a0,s1
 2d0:	16a000ef          	jal	43a <close>
  return r;
 2d4:	64a2                	ld	s1,8(sp)
}
 2d6:	854a                	mv	a0,s2
 2d8:	60e2                	ld	ra,24(sp)
 2da:	6442                	ld	s0,16(sp)
 2dc:	6902                	ld	s2,0(sp)
 2de:	6105                	addi	sp,sp,32
 2e0:	8082                	ret
    return -1;
 2e2:	57fd                	li	a5,-1
 2e4:	893e                	mv	s2,a5
 2e6:	bfc5                	j	2d6 <stat+0x2a>

00000000000002e8 <atoi>:

int
atoi(const char *s)
{
 2e8:	1141                	addi	sp,sp,-16
 2ea:	e406                	sd	ra,8(sp)
 2ec:	e022                	sd	s0,0(sp)
 2ee:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 2f0:	00054683          	lbu	a3,0(a0)
 2f4:	fd06879b          	addiw	a5,a3,-48
 2f8:	0ff7f793          	zext.b	a5,a5
 2fc:	4625                	li	a2,9
 2fe:	02f66963          	bltu	a2,a5,330 <atoi+0x48>
 302:	872a                	mv	a4,a0
  n = 0;
 304:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 306:	0705                	addi	a4,a4,1
 308:	0025179b          	slliw	a5,a0,0x2
 30c:	9fa9                	addw	a5,a5,a0
 30e:	0017979b          	slliw	a5,a5,0x1
 312:	9fb5                	addw	a5,a5,a3
 314:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 318:	00074683          	lbu	a3,0(a4)
 31c:	fd06879b          	addiw	a5,a3,-48
 320:	0ff7f793          	zext.b	a5,a5
 324:	fef671e3          	bgeu	a2,a5,306 <atoi+0x1e>
  return n;
}
 328:	60a2                	ld	ra,8(sp)
 32a:	6402                	ld	s0,0(sp)
 32c:	0141                	addi	sp,sp,16
 32e:	8082                	ret
  n = 0;
 330:	4501                	li	a0,0
 332:	bfdd                	j	328 <atoi+0x40>

0000000000000334 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 334:	1141                	addi	sp,sp,-16
 336:	e406                	sd	ra,8(sp)
 338:	e022                	sd	s0,0(sp)
 33a:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 33c:	02b57563          	bgeu	a0,a1,366 <memmove+0x32>
    while(n-- > 0)
 340:	00c05f63          	blez	a2,35e <memmove+0x2a>
 344:	1602                	slli	a2,a2,0x20
 346:	9201                	srli	a2,a2,0x20
 348:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 34c:	872a                	mv	a4,a0
      *dst++ = *src++;
 34e:	0585                	addi	a1,a1,1
 350:	0705                	addi	a4,a4,1
 352:	fff5c683          	lbu	a3,-1(a1)
 356:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 35a:	fee79ae3          	bne	a5,a4,34e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
    while(n-- > 0)
 366:	fec05ce3          	blez	a2,35e <memmove+0x2a>
    dst += n;
 36a:	00c50733          	add	a4,a0,a2
    src += n;
 36e:	95b2                	add	a1,a1,a2
 370:	fff6079b          	addiw	a5,a2,-1
 374:	1782                	slli	a5,a5,0x20
 376:	9381                	srli	a5,a5,0x20
 378:	fff7c793          	not	a5,a5
 37c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 37e:	15fd                	addi	a1,a1,-1
 380:	177d                	addi	a4,a4,-1
 382:	0005c683          	lbu	a3,0(a1)
 386:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 38a:	fef71ae3          	bne	a4,a5,37e <memmove+0x4a>
 38e:	bfc1                	j	35e <memmove+0x2a>

0000000000000390 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 390:	1141                	addi	sp,sp,-16
 392:	e406                	sd	ra,8(sp)
 394:	e022                	sd	s0,0(sp)
 396:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 398:	c61d                	beqz	a2,3c6 <memcmp+0x36>
 39a:	1602                	slli	a2,a2,0x20
 39c:	9201                	srli	a2,a2,0x20
 39e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 3a2:	00054783          	lbu	a5,0(a0)
 3a6:	0005c703          	lbu	a4,0(a1)
 3aa:	00e79863          	bne	a5,a4,3ba <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 3ae:	0505                	addi	a0,a0,1
    p2++;
 3b0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 3b2:	fed518e3          	bne	a0,a3,3a2 <memcmp+0x12>
  }
  return 0;
 3b6:	4501                	li	a0,0
 3b8:	a019                	j	3be <memcmp+0x2e>
      return *p1 - *p2;
 3ba:	40e7853b          	subw	a0,a5,a4
}
 3be:	60a2                	ld	ra,8(sp)
 3c0:	6402                	ld	s0,0(sp)
 3c2:	0141                	addi	sp,sp,16
 3c4:	8082                	ret
  return 0;
 3c6:	4501                	li	a0,0
 3c8:	bfdd                	j	3be <memcmp+0x2e>

00000000000003ca <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 3ca:	1141                	addi	sp,sp,-16
 3cc:	e406                	sd	ra,8(sp)
 3ce:	e022                	sd	s0,0(sp)
 3d0:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 3d2:	f63ff0ef          	jal	334 <memmove>
}
 3d6:	60a2                	ld	ra,8(sp)
 3d8:	6402                	ld	s0,0(sp)
 3da:	0141                	addi	sp,sp,16
 3dc:	8082                	ret

00000000000003de <sbrk>:

char *
sbrk(int n) {
 3de:	1141                	addi	sp,sp,-16
 3e0:	e406                	sd	ra,8(sp)
 3e2:	e022                	sd	s0,0(sp)
 3e4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 3e6:	4585                	li	a1,1
 3e8:	0b2000ef          	jal	49a <sys_sbrk>
}
 3ec:	60a2                	ld	ra,8(sp)
 3ee:	6402                	ld	s0,0(sp)
 3f0:	0141                	addi	sp,sp,16
 3f2:	8082                	ret

00000000000003f4 <sbrklazy>:

char *
sbrklazy(int n) {
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e406                	sd	ra,8(sp)
 3f8:	e022                	sd	s0,0(sp)
 3fa:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 3fc:	4589                	li	a1,2
 3fe:	09c000ef          	jal	49a <sys_sbrk>
}
 402:	60a2                	ld	ra,8(sp)
 404:	6402                	ld	s0,0(sp)
 406:	0141                	addi	sp,sp,16
 408:	8082                	ret

000000000000040a <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 40a:	4885                	li	a7,1
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <exit>:
.global exit
exit:
 li a7, SYS_exit
 412:	4889                	li	a7,2
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <wait>:
.global wait
wait:
 li a7, SYS_wait
 41a:	488d                	li	a7,3
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 422:	4891                	li	a7,4
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <read>:
.global read
read:
 li a7, SYS_read
 42a:	4895                	li	a7,5
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <write>:
.global write
write:
 li a7, SYS_write
 432:	48c1                	li	a7,16
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <close>:
.global close
close:
 li a7, SYS_close
 43a:	48d5                	li	a7,21
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <kill>:
.global kill
kill:
 li a7, SYS_kill
 442:	4899                	li	a7,6
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <exec>:
.global exec
exec:
 li a7, SYS_exec
 44a:	489d                	li	a7,7
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <open>:
.global open
open:
 li a7, SYS_open
 452:	48bd                	li	a7,15
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 45a:	48c5                	li	a7,17
 ecall
 45c:	00000073          	ecall
 ret
 460:	8082                	ret

0000000000000462 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 462:	48c9                	li	a7,18
 ecall
 464:	00000073          	ecall
 ret
 468:	8082                	ret

000000000000046a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 46a:	48a1                	li	a7,8
 ecall
 46c:	00000073          	ecall
 ret
 470:	8082                	ret

0000000000000472 <link>:
.global link
link:
 li a7, SYS_link
 472:	48cd                	li	a7,19
 ecall
 474:	00000073          	ecall
 ret
 478:	8082                	ret

000000000000047a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 47a:	48d1                	li	a7,20
 ecall
 47c:	00000073          	ecall
 ret
 480:	8082                	ret

0000000000000482 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 482:	48a5                	li	a7,9
 ecall
 484:	00000073          	ecall
 ret
 488:	8082                	ret

000000000000048a <dup>:
.global dup
dup:
 li a7, SYS_dup
 48a:	48a9                	li	a7,10
 ecall
 48c:	00000073          	ecall
 ret
 490:	8082                	ret

0000000000000492 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 492:	48ad                	li	a7,11
 ecall
 494:	00000073          	ecall
 ret
 498:	8082                	ret

000000000000049a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 49a:	48b1                	li	a7,12
 ecall
 49c:	00000073          	ecall
 ret
 4a0:	8082                	ret

00000000000004a2 <pause>:
.global pause
pause:
 li a7, SYS_pause
 4a2:	48b5                	li	a7,13
 ecall
 4a4:	00000073          	ecall
 ret
 4a8:	8082                	ret

00000000000004aa <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 4aa:	48b9                	li	a7,14
 ecall
 4ac:	00000073          	ecall
 ret
 4b0:	8082                	ret

00000000000004b2 <bind>:
.global bind
bind:
 li a7, SYS_bind
 4b2:	48f5                	li	a7,29
 ecall
 4b4:	00000073          	ecall
 ret
 4b8:	8082                	ret

00000000000004ba <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 4ba:	48f9                	li	a7,30
 ecall
 4bc:	00000073          	ecall
 ret
 4c0:	8082                	ret

00000000000004c2 <send>:
.global send
send:
 li a7, SYS_send
 4c2:	48fd                	li	a7,31
 ecall
 4c4:	00000073          	ecall
 ret
 4c8:	8082                	ret

00000000000004ca <recv>:
.global recv
recv:
 li a7, SYS_recv
 4ca:	02000893          	li	a7,32
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 4d4:	02100893          	li	a7,33
 ecall
 4d8:	00000073          	ecall
 ret
 4dc:	8082                	ret

00000000000004de <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 4de:	02200893          	li	a7,34
 ecall
 4e2:	00000073          	ecall
 ret
 4e6:	8082                	ret

00000000000004e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4e8:	1101                	addi	sp,sp,-32
 4ea:	ec06                	sd	ra,24(sp)
 4ec:	e822                	sd	s0,16(sp)
 4ee:	1000                	addi	s0,sp,32
 4f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 4f4:	4605                	li	a2,1
 4f6:	fef40593          	addi	a1,s0,-17
 4fa:	f39ff0ef          	jal	432 <write>
}
 4fe:	60e2                	ld	ra,24(sp)
 500:	6442                	ld	s0,16(sp)
 502:	6105                	addi	sp,sp,32
 504:	8082                	ret

0000000000000506 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 506:	715d                	addi	sp,sp,-80
 508:	e486                	sd	ra,72(sp)
 50a:	e0a2                	sd	s0,64(sp)
 50c:	f84a                	sd	s2,48(sp)
 50e:	f44e                	sd	s3,40(sp)
 510:	0880                	addi	s0,sp,80
 512:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 514:	c6d1                	beqz	a3,5a0 <printint+0x9a>
 516:	0805d563          	bgez	a1,5a0 <printint+0x9a>
    neg = 1;
    x = -xx;
 51a:	40b005b3          	neg	a1,a1
    neg = 1;
 51e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 520:	fb840993          	addi	s3,s0,-72
  neg = 0;
 524:	86ce                	mv	a3,s3
  i = 0;
 526:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 528:	00000817          	auipc	a6,0x0
 52c:	56880813          	addi	a6,a6,1384 # a90 <digits>
 530:	88ba                	mv	a7,a4
 532:	0017051b          	addiw	a0,a4,1
 536:	872a                	mv	a4,a0
 538:	02c5f7b3          	remu	a5,a1,a2
 53c:	97c2                	add	a5,a5,a6
 53e:	0007c783          	lbu	a5,0(a5)
 542:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 546:	87ae                	mv	a5,a1
 548:	02c5d5b3          	divu	a1,a1,a2
 54c:	0685                	addi	a3,a3,1
 54e:	fec7f1e3          	bgeu	a5,a2,530 <printint+0x2a>
  if(neg)
 552:	00030c63          	beqz	t1,56a <printint+0x64>
    buf[i++] = '-';
 556:	fd050793          	addi	a5,a0,-48
 55a:	00878533          	add	a0,a5,s0
 55e:	02d00793          	li	a5,45
 562:	fef50423          	sb	a5,-24(a0)
 566:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 56a:	02e05563          	blez	a4,594 <printint+0x8e>
 56e:	fc26                	sd	s1,56(sp)
 570:	377d                	addiw	a4,a4,-1
 572:	00e984b3          	add	s1,s3,a4
 576:	19fd                	addi	s3,s3,-1
 578:	99ba                	add	s3,s3,a4
 57a:	1702                	slli	a4,a4,0x20
 57c:	9301                	srli	a4,a4,0x20
 57e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 582:	0004c583          	lbu	a1,0(s1)
 586:	854a                	mv	a0,s2
 588:	f61ff0ef          	jal	4e8 <putc>
  while(--i >= 0)
 58c:	14fd                	addi	s1,s1,-1
 58e:	ff349ae3          	bne	s1,s3,582 <printint+0x7c>
 592:	74e2                	ld	s1,56(sp)
}
 594:	60a6                	ld	ra,72(sp)
 596:	6406                	ld	s0,64(sp)
 598:	7942                	ld	s2,48(sp)
 59a:	79a2                	ld	s3,40(sp)
 59c:	6161                	addi	sp,sp,80
 59e:	8082                	ret
  neg = 0;
 5a0:	4301                	li	t1,0
 5a2:	bfbd                	j	520 <printint+0x1a>

00000000000005a4 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5a4:	711d                	addi	sp,sp,-96
 5a6:	ec86                	sd	ra,88(sp)
 5a8:	e8a2                	sd	s0,80(sp)
 5aa:	e4a6                	sd	s1,72(sp)
 5ac:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5ae:	0005c483          	lbu	s1,0(a1)
 5b2:	22048363          	beqz	s1,7d8 <vprintf+0x234>
 5b6:	e0ca                	sd	s2,64(sp)
 5b8:	fc4e                	sd	s3,56(sp)
 5ba:	f852                	sd	s4,48(sp)
 5bc:	f456                	sd	s5,40(sp)
 5be:	f05a                	sd	s6,32(sp)
 5c0:	ec5e                	sd	s7,24(sp)
 5c2:	e862                	sd	s8,16(sp)
 5c4:	8b2a                	mv	s6,a0
 5c6:	8a2e                	mv	s4,a1
 5c8:	8bb2                	mv	s7,a2
  state = 0;
 5ca:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5cc:	4901                	li	s2,0
 5ce:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5d0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5d4:	06400c13          	li	s8,100
 5d8:	a00d                	j	5fa <vprintf+0x56>
        putc(fd, c0);
 5da:	85a6                	mv	a1,s1
 5dc:	855a                	mv	a0,s6
 5de:	f0bff0ef          	jal	4e8 <putc>
 5e2:	a019                	j	5e8 <vprintf+0x44>
    } else if(state == '%'){
 5e4:	03598363          	beq	s3,s5,60a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5e8:	0019079b          	addiw	a5,s2,1
 5ec:	893e                	mv	s2,a5
 5ee:	873e                	mv	a4,a5
 5f0:	97d2                	add	a5,a5,s4
 5f2:	0007c483          	lbu	s1,0(a5)
 5f6:	1c048a63          	beqz	s1,7ca <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 5fa:	0004879b          	sext.w	a5,s1
    if(state == 0){
 5fe:	fe0993e3          	bnez	s3,5e4 <vprintf+0x40>
      if(c0 == '%'){
 602:	fd579ce3          	bne	a5,s5,5da <vprintf+0x36>
        state = '%';
 606:	89be                	mv	s3,a5
 608:	b7c5                	j	5e8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 60a:	00ea06b3          	add	a3,s4,a4
 60e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 612:	1c060863          	beqz	a2,7e2 <vprintf+0x23e>
      if(c0 == 'd'){
 616:	03878763          	beq	a5,s8,644 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 61a:	f9478693          	addi	a3,a5,-108
 61e:	0016b693          	seqz	a3,a3
 622:	f9c60593          	addi	a1,a2,-100
 626:	e99d                	bnez	a1,65c <vprintf+0xb8>
 628:	ca95                	beqz	a3,65c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 62a:	008b8493          	addi	s1,s7,8
 62e:	4685                	li	a3,1
 630:	4629                	li	a2,10
 632:	000bb583          	ld	a1,0(s7)
 636:	855a                	mv	a0,s6
 638:	ecfff0ef          	jal	506 <printint>
        i += 1;
 63c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 640:	4981                	li	s3,0
 642:	b75d                	j	5e8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 644:	008b8493          	addi	s1,s7,8
 648:	4685                	li	a3,1
 64a:	4629                	li	a2,10
 64c:	000ba583          	lw	a1,0(s7)
 650:	855a                	mv	a0,s6
 652:	eb5ff0ef          	jal	506 <printint>
 656:	8ba6                	mv	s7,s1
      state = 0;
 658:	4981                	li	s3,0
 65a:	b779                	j	5e8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 65c:	9752                	add	a4,a4,s4
 65e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 662:	f9460713          	addi	a4,a2,-108
 666:	00173713          	seqz	a4,a4
 66a:	8f75                	and	a4,a4,a3
 66c:	f9c58513          	addi	a0,a1,-100
 670:	18051363          	bnez	a0,7f6 <vprintf+0x252>
 674:	18070163          	beqz	a4,7f6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 678:	008b8493          	addi	s1,s7,8
 67c:	4685                	li	a3,1
 67e:	4629                	li	a2,10
 680:	000bb583          	ld	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	e81ff0ef          	jal	506 <printint>
        i += 2;
 68a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	8ba6                	mv	s7,s1
      state = 0;
 68e:	4981                	li	s3,0
        i += 2;
 690:	bfa1                	j	5e8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 692:	008b8493          	addi	s1,s7,8
 696:	4681                	li	a3,0
 698:	4629                	li	a2,10
 69a:	000be583          	lwu	a1,0(s7)
 69e:	855a                	mv	a0,s6
 6a0:	e67ff0ef          	jal	506 <printint>
 6a4:	8ba6                	mv	s7,s1
      state = 0;
 6a6:	4981                	li	s3,0
 6a8:	b781                	j	5e8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6aa:	008b8493          	addi	s1,s7,8
 6ae:	4681                	li	a3,0
 6b0:	4629                	li	a2,10
 6b2:	000bb583          	ld	a1,0(s7)
 6b6:	855a                	mv	a0,s6
 6b8:	e4fff0ef          	jal	506 <printint>
        i += 1;
 6bc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	8ba6                	mv	s7,s1
      state = 0;
 6c0:	4981                	li	s3,0
 6c2:	b71d                	j	5e8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6c4:	008b8493          	addi	s1,s7,8
 6c8:	4681                	li	a3,0
 6ca:	4629                	li	a2,10
 6cc:	000bb583          	ld	a1,0(s7)
 6d0:	855a                	mv	a0,s6
 6d2:	e35ff0ef          	jal	506 <printint>
        i += 2;
 6d6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d8:	8ba6                	mv	s7,s1
      state = 0;
 6da:	4981                	li	s3,0
        i += 2;
 6dc:	b731                	j	5e8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6de:	008b8493          	addi	s1,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4641                	li	a2,16
 6e6:	000be583          	lwu	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	e1bff0ef          	jal	506 <printint>
 6f0:	8ba6                	mv	s7,s1
      state = 0;
 6f2:	4981                	li	s3,0
 6f4:	bdd5                	j	5e8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 6f6:	008b8493          	addi	s1,s7,8
 6fa:	4681                	li	a3,0
 6fc:	4641                	li	a2,16
 6fe:	000bb583          	ld	a1,0(s7)
 702:	855a                	mv	a0,s6
 704:	e03ff0ef          	jal	506 <printint>
        i += 1;
 708:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	8ba6                	mv	s7,s1
      state = 0;
 70c:	4981                	li	s3,0
 70e:	bde9                	j	5e8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 710:	008b8493          	addi	s1,s7,8
 714:	4681                	li	a3,0
 716:	4641                	li	a2,16
 718:	000bb583          	ld	a1,0(s7)
 71c:	855a                	mv	a0,s6
 71e:	de9ff0ef          	jal	506 <printint>
        i += 2;
 722:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 724:	8ba6                	mv	s7,s1
      state = 0;
 726:	4981                	li	s3,0
        i += 2;
 728:	b5c1                	j	5e8 <vprintf+0x44>
 72a:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 72c:	008b8793          	addi	a5,s7,8
 730:	8cbe                	mv	s9,a5
 732:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 736:	03000593          	li	a1,48
 73a:	855a                	mv	a0,s6
 73c:	dadff0ef          	jal	4e8 <putc>
  putc(fd, 'x');
 740:	07800593          	li	a1,120
 744:	855a                	mv	a0,s6
 746:	da3ff0ef          	jal	4e8 <putc>
 74a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 74c:	00000b97          	auipc	s7,0x0
 750:	344b8b93          	addi	s7,s7,836 # a90 <digits>
 754:	03c9d793          	srli	a5,s3,0x3c
 758:	97de                	add	a5,a5,s7
 75a:	0007c583          	lbu	a1,0(a5)
 75e:	855a                	mv	a0,s6
 760:	d89ff0ef          	jal	4e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 764:	0992                	slli	s3,s3,0x4
 766:	34fd                	addiw	s1,s1,-1
 768:	f4f5                	bnez	s1,754 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 76a:	8be6                	mv	s7,s9
      state = 0;
 76c:	4981                	li	s3,0
 76e:	6ca2                	ld	s9,8(sp)
 770:	bda5                	j	5e8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 772:	008b8493          	addi	s1,s7,8
 776:	000bc583          	lbu	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	d6dff0ef          	jal	4e8 <putc>
 780:	8ba6                	mv	s7,s1
      state = 0;
 782:	4981                	li	s3,0
 784:	b595                	j	5e8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 786:	008b8993          	addi	s3,s7,8
 78a:	000bb483          	ld	s1,0(s7)
 78e:	cc91                	beqz	s1,7aa <vprintf+0x206>
        for(; *s; s++)
 790:	0004c583          	lbu	a1,0(s1)
 794:	c985                	beqz	a1,7c4 <vprintf+0x220>
          putc(fd, *s);
 796:	855a                	mv	a0,s6
 798:	d51ff0ef          	jal	4e8 <putc>
        for(; *s; s++)
 79c:	0485                	addi	s1,s1,1
 79e:	0004c583          	lbu	a1,0(s1)
 7a2:	f9f5                	bnez	a1,796 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 7a4:	8bce                	mv	s7,s3
      state = 0;
 7a6:	4981                	li	s3,0
 7a8:	b581                	j	5e8 <vprintf+0x44>
          s = "(null)";
 7aa:	00000497          	auipc	s1,0x0
 7ae:	2de48493          	addi	s1,s1,734 # a88 <malloc+0x142>
        for(; *s; s++)
 7b2:	02800593          	li	a1,40
 7b6:	b7c5                	j	796 <vprintf+0x1f2>
        putc(fd, '%');
 7b8:	85be                	mv	a1,a5
 7ba:	855a                	mv	a0,s6
 7bc:	d2dff0ef          	jal	4e8 <putc>
      state = 0;
 7c0:	4981                	li	s3,0
 7c2:	b51d                	j	5e8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7c4:	8bce                	mv	s7,s3
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	b505                	j	5e8 <vprintf+0x44>
 7ca:	6906                	ld	s2,64(sp)
 7cc:	79e2                	ld	s3,56(sp)
 7ce:	7a42                	ld	s4,48(sp)
 7d0:	7aa2                	ld	s5,40(sp)
 7d2:	7b02                	ld	s6,32(sp)
 7d4:	6be2                	ld	s7,24(sp)
 7d6:	6c42                	ld	s8,16(sp)
    }
  }
}
 7d8:	60e6                	ld	ra,88(sp)
 7da:	6446                	ld	s0,80(sp)
 7dc:	64a6                	ld	s1,72(sp)
 7de:	6125                	addi	sp,sp,96
 7e0:	8082                	ret
      if(c0 == 'd'){
 7e2:	06400713          	li	a4,100
 7e6:	e4e78fe3          	beq	a5,a4,644 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7ea:	f9478693          	addi	a3,a5,-108
 7ee:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 7f2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 7f4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 7f6:	07500513          	li	a0,117
 7fa:	e8a78ce3          	beq	a5,a0,692 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 7fe:	f8b60513          	addi	a0,a2,-117
 802:	e119                	bnez	a0,808 <vprintf+0x264>
 804:	ea0693e3          	bnez	a3,6aa <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 808:	f8b58513          	addi	a0,a1,-117
 80c:	e119                	bnez	a0,812 <vprintf+0x26e>
 80e:	ea071be3          	bnez	a4,6c4 <vprintf+0x120>
      } else if(c0 == 'x'){
 812:	07800513          	li	a0,120
 816:	eca784e3          	beq	a5,a0,6de <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 81a:	f8860613          	addi	a2,a2,-120
 81e:	e219                	bnez	a2,824 <vprintf+0x280>
 820:	ec069be3          	bnez	a3,6f6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 824:	f8858593          	addi	a1,a1,-120
 828:	e199                	bnez	a1,82e <vprintf+0x28a>
 82a:	ee0713e3          	bnez	a4,710 <vprintf+0x16c>
      } else if(c0 == 'p'){
 82e:	07000713          	li	a4,112
 832:	eee78ce3          	beq	a5,a4,72a <vprintf+0x186>
      } else if(c0 == 'c'){
 836:	06300713          	li	a4,99
 83a:	f2e78ce3          	beq	a5,a4,772 <vprintf+0x1ce>
      } else if(c0 == 's'){
 83e:	07300713          	li	a4,115
 842:	f4e782e3          	beq	a5,a4,786 <vprintf+0x1e2>
      } else if(c0 == '%'){
 846:	02500713          	li	a4,37
 84a:	f6e787e3          	beq	a5,a4,7b8 <vprintf+0x214>
        putc(fd, '%');
 84e:	02500593          	li	a1,37
 852:	855a                	mv	a0,s6
 854:	c95ff0ef          	jal	4e8 <putc>
        putc(fd, c0);
 858:	85a6                	mv	a1,s1
 85a:	855a                	mv	a0,s6
 85c:	c8dff0ef          	jal	4e8 <putc>
      state = 0;
 860:	4981                	li	s3,0
 862:	b359                	j	5e8 <vprintf+0x44>

0000000000000864 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 864:	715d                	addi	sp,sp,-80
 866:	ec06                	sd	ra,24(sp)
 868:	e822                	sd	s0,16(sp)
 86a:	1000                	addi	s0,sp,32
 86c:	e010                	sd	a2,0(s0)
 86e:	e414                	sd	a3,8(s0)
 870:	e818                	sd	a4,16(s0)
 872:	ec1c                	sd	a5,24(s0)
 874:	03043023          	sd	a6,32(s0)
 878:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 87c:	8622                	mv	a2,s0
 87e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 882:	d23ff0ef          	jal	5a4 <vprintf>
}
 886:	60e2                	ld	ra,24(sp)
 888:	6442                	ld	s0,16(sp)
 88a:	6161                	addi	sp,sp,80
 88c:	8082                	ret

000000000000088e <printf>:

void
printf(const char *fmt, ...)
{
 88e:	711d                	addi	sp,sp,-96
 890:	ec06                	sd	ra,24(sp)
 892:	e822                	sd	s0,16(sp)
 894:	1000                	addi	s0,sp,32
 896:	e40c                	sd	a1,8(s0)
 898:	e810                	sd	a2,16(s0)
 89a:	ec14                	sd	a3,24(s0)
 89c:	f018                	sd	a4,32(s0)
 89e:	f41c                	sd	a5,40(s0)
 8a0:	03043823          	sd	a6,48(s0)
 8a4:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8a8:	00840613          	addi	a2,s0,8
 8ac:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8b0:	85aa                	mv	a1,a0
 8b2:	4505                	li	a0,1
 8b4:	cf1ff0ef          	jal	5a4 <vprintf>
}
 8b8:	60e2                	ld	ra,24(sp)
 8ba:	6442                	ld	s0,16(sp)
 8bc:	6125                	addi	sp,sp,96
 8be:	8082                	ret

00000000000008c0 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8c0:	1141                	addi	sp,sp,-16
 8c2:	e406                	sd	ra,8(sp)
 8c4:	e022                	sd	s0,0(sp)
 8c6:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8c8:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8cc:	00000797          	auipc	a5,0x0
 8d0:	7347b783          	ld	a5,1844(a5) # 1000 <freep>
 8d4:	a039                	j	8e2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8d6:	6398                	ld	a4,0(a5)
 8d8:	00e7e463          	bltu	a5,a4,8e0 <free+0x20>
 8dc:	00e6ea63          	bltu	a3,a4,8f0 <free+0x30>
{
 8e0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e2:	fed7fae3          	bgeu	a5,a3,8d6 <free+0x16>
 8e6:	6398                	ld	a4,0(a5)
 8e8:	00e6e463          	bltu	a3,a4,8f0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ec:	fee7eae3          	bltu	a5,a4,8e0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 8f0:	ff852583          	lw	a1,-8(a0)
 8f4:	6390                	ld	a2,0(a5)
 8f6:	02059813          	slli	a6,a1,0x20
 8fa:	01c85713          	srli	a4,a6,0x1c
 8fe:	9736                	add	a4,a4,a3
 900:	02e60563          	beq	a2,a4,92a <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 904:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 908:	4790                	lw	a2,8(a5)
 90a:	02061593          	slli	a1,a2,0x20
 90e:	01c5d713          	srli	a4,a1,0x1c
 912:	973e                	add	a4,a4,a5
 914:	02e68263          	beq	a3,a4,938 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 918:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 91a:	00000717          	auipc	a4,0x0
 91e:	6ef73323          	sd	a5,1766(a4) # 1000 <freep>
}
 922:	60a2                	ld	ra,8(sp)
 924:	6402                	ld	s0,0(sp)
 926:	0141                	addi	sp,sp,16
 928:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 92a:	4618                	lw	a4,8(a2)
 92c:	9f2d                	addw	a4,a4,a1
 92e:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 932:	6398                	ld	a4,0(a5)
 934:	6310                	ld	a2,0(a4)
 936:	b7f9                	j	904 <free+0x44>
    p->s.size += bp->s.size;
 938:	ff852703          	lw	a4,-8(a0)
 93c:	9f31                	addw	a4,a4,a2
 93e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 940:	ff053683          	ld	a3,-16(a0)
 944:	bfd1                	j	918 <free+0x58>

0000000000000946 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 946:	7139                	addi	sp,sp,-64
 948:	fc06                	sd	ra,56(sp)
 94a:	f822                	sd	s0,48(sp)
 94c:	f04a                	sd	s2,32(sp)
 94e:	ec4e                	sd	s3,24(sp)
 950:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 952:	02051993          	slli	s3,a0,0x20
 956:	0209d993          	srli	s3,s3,0x20
 95a:	09bd                	addi	s3,s3,15
 95c:	0049d993          	srli	s3,s3,0x4
 960:	2985                	addiw	s3,s3,1
 962:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 964:	00000517          	auipc	a0,0x0
 968:	69c53503          	ld	a0,1692(a0) # 1000 <freep>
 96c:	c905                	beqz	a0,99c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 96e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 970:	4798                	lw	a4,8(a5)
 972:	09377663          	bgeu	a4,s3,9fe <malloc+0xb8>
 976:	f426                	sd	s1,40(sp)
 978:	e852                	sd	s4,16(sp)
 97a:	e456                	sd	s5,8(sp)
 97c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 97e:	8a4e                	mv	s4,s3
 980:	6705                	lui	a4,0x1
 982:	00e9f363          	bgeu	s3,a4,988 <malloc+0x42>
 986:	6a05                	lui	s4,0x1
 988:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 98c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 990:	00000497          	auipc	s1,0x0
 994:	67048493          	addi	s1,s1,1648 # 1000 <freep>
  if(p == SBRK_ERROR)
 998:	5afd                	li	s5,-1
 99a:	a83d                	j	9d8 <malloc+0x92>
 99c:	f426                	sd	s1,40(sp)
 99e:	e852                	sd	s4,16(sp)
 9a0:	e456                	sd	s5,8(sp)
 9a2:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9a4:	00001797          	auipc	a5,0x1
 9a8:	86c78793          	addi	a5,a5,-1940 # 1210 <base>
 9ac:	00000717          	auipc	a4,0x0
 9b0:	64f73a23          	sd	a5,1620(a4) # 1000 <freep>
 9b4:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9b6:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ba:	b7d1                	j	97e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9bc:	6398                	ld	a4,0(a5)
 9be:	e118                	sd	a4,0(a0)
 9c0:	a899                	j	a16 <malloc+0xd0>
  hp->s.size = nu;
 9c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9c6:	0541                	addi	a0,a0,16
 9c8:	ef9ff0ef          	jal	8c0 <free>
  return freep;
 9cc:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9ce:	c125                	beqz	a0,a2e <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9d0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9d2:	4798                	lw	a4,8(a5)
 9d4:	03277163          	bgeu	a4,s2,9f6 <malloc+0xb0>
    if(p == freep)
 9d8:	6098                	ld	a4,0(s1)
 9da:	853e                	mv	a0,a5
 9dc:	fef71ae3          	bne	a4,a5,9d0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9e0:	8552                	mv	a0,s4
 9e2:	9fdff0ef          	jal	3de <sbrk>
  if(p == SBRK_ERROR)
 9e6:	fd551ee3          	bne	a0,s5,9c2 <malloc+0x7c>
        return 0;
 9ea:	4501                	li	a0,0
 9ec:	74a2                	ld	s1,40(sp)
 9ee:	6a42                	ld	s4,16(sp)
 9f0:	6aa2                	ld	s5,8(sp)
 9f2:	6b02                	ld	s6,0(sp)
 9f4:	a03d                	j	a22 <malloc+0xdc>
 9f6:	74a2                	ld	s1,40(sp)
 9f8:	6a42                	ld	s4,16(sp)
 9fa:	6aa2                	ld	s5,8(sp)
 9fc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 9fe:	fae90fe3          	beq	s2,a4,9bc <malloc+0x76>
        p->s.size -= nunits;
 a02:	4137073b          	subw	a4,a4,s3
 a06:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a08:	02071693          	slli	a3,a4,0x20
 a0c:	01c6d713          	srli	a4,a3,0x1c
 a10:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a12:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a16:	00000717          	auipc	a4,0x0
 a1a:	5ea73523          	sd	a0,1514(a4) # 1000 <freep>
      return (void*)(p + 1);
 a1e:	01078513          	addi	a0,a5,16
  }
}
 a22:	70e2                	ld	ra,56(sp)
 a24:	7442                	ld	s0,48(sp)
 a26:	7902                	ld	s2,32(sp)
 a28:	69e2                	ld	s3,24(sp)
 a2a:	6121                	addi	sp,sp,64
 a2c:	8082                	ret
 a2e:	74a2                	ld	s1,40(sp)
 a30:	6a42                	ld	s4,16(sp)
 a32:	6aa2                	ld	s5,8(sp)
 a34:	6b02                	ld	s6,0(sp)
 a36:	b7f5                	j	a22 <malloc+0xdc>
