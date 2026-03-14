
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
  40:	a84a0a13          	addi	s4,s4,-1404 # ac0 <statistics+0x74>
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
  a2:	a4250513          	addi	a0,a0,-1470 # ae0 <statistics+0x94>
  a6:	7fc000ef          	jal	8a2 <printf>
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
  cc:	a0850513          	addi	a0,a0,-1528 # ad0 <statistics+0x84>
  d0:	7d2000ef          	jal	8a2 <printf>
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
 136:	99658593          	addi	a1,a1,-1642 # ac8 <statistics+0x7c>
 13a:	4501                	li	a0,0
 13c:	ec5ff0ef          	jal	0 <wc>
    exit(0);
 140:	4501                	li	a0,0
 142:	2d0000ef          	jal	412 <exit>
      printf("wc: cannot open %s\n", argv[i]);
 146:	00093583          	ld	a1,0(s2)
 14a:	00001517          	auipc	a0,0x1
 14e:	9a650513          	addi	a0,a0,-1626 # af0 <statistics+0xa4>
 152:	750000ef          	jal	8a2 <printf>
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

00000000000004e8 <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 4e8:	02300893          	li	a7,35
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 4f2:	02400893          	li	a7,36
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 4fc:	1101                	addi	sp,sp,-32
 4fe:	ec06                	sd	ra,24(sp)
 500:	e822                	sd	s0,16(sp)
 502:	1000                	addi	s0,sp,32
 504:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 508:	4605                	li	a2,1
 50a:	fef40593          	addi	a1,s0,-17
 50e:	f25ff0ef          	jal	432 <write>
}
 512:	60e2                	ld	ra,24(sp)
 514:	6442                	ld	s0,16(sp)
 516:	6105                	addi	sp,sp,32
 518:	8082                	ret

000000000000051a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 51a:	715d                	addi	sp,sp,-80
 51c:	e486                	sd	ra,72(sp)
 51e:	e0a2                	sd	s0,64(sp)
 520:	f84a                	sd	s2,48(sp)
 522:	f44e                	sd	s3,40(sp)
 524:	0880                	addi	s0,sp,80
 526:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 528:	c6d1                	beqz	a3,5b4 <printint+0x9a>
 52a:	0805d563          	bgez	a1,5b4 <printint+0x9a>
    neg = 1;
    x = -xx;
 52e:	40b005b3          	neg	a1,a1
    neg = 1;
 532:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 534:	fb840993          	addi	s3,s0,-72
  neg = 0;
 538:	86ce                	mv	a3,s3
  i = 0;
 53a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 53c:	00000817          	auipc	a6,0x0
 540:	5fc80813          	addi	a6,a6,1532 # b38 <digits>
 544:	88ba                	mv	a7,a4
 546:	0017051b          	addiw	a0,a4,1
 54a:	872a                	mv	a4,a0
 54c:	02c5f7b3          	remu	a5,a1,a2
 550:	97c2                	add	a5,a5,a6
 552:	0007c783          	lbu	a5,0(a5)
 556:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 55a:	87ae                	mv	a5,a1
 55c:	02c5d5b3          	divu	a1,a1,a2
 560:	0685                	addi	a3,a3,1
 562:	fec7f1e3          	bgeu	a5,a2,544 <printint+0x2a>
  if(neg)
 566:	00030c63          	beqz	t1,57e <printint+0x64>
    buf[i++] = '-';
 56a:	fd050793          	addi	a5,a0,-48
 56e:	00878533          	add	a0,a5,s0
 572:	02d00793          	li	a5,45
 576:	fef50423          	sb	a5,-24(a0)
 57a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 57e:	02e05563          	blez	a4,5a8 <printint+0x8e>
 582:	fc26                	sd	s1,56(sp)
 584:	377d                	addiw	a4,a4,-1
 586:	00e984b3          	add	s1,s3,a4
 58a:	19fd                	addi	s3,s3,-1
 58c:	99ba                	add	s3,s3,a4
 58e:	1702                	slli	a4,a4,0x20
 590:	9301                	srli	a4,a4,0x20
 592:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 596:	0004c583          	lbu	a1,0(s1)
 59a:	854a                	mv	a0,s2
 59c:	f61ff0ef          	jal	4fc <putc>
  while(--i >= 0)
 5a0:	14fd                	addi	s1,s1,-1
 5a2:	ff349ae3          	bne	s1,s3,596 <printint+0x7c>
 5a6:	74e2                	ld	s1,56(sp)
}
 5a8:	60a6                	ld	ra,72(sp)
 5aa:	6406                	ld	s0,64(sp)
 5ac:	7942                	ld	s2,48(sp)
 5ae:	79a2                	ld	s3,40(sp)
 5b0:	6161                	addi	sp,sp,80
 5b2:	8082                	ret
  neg = 0;
 5b4:	4301                	li	t1,0
 5b6:	bfbd                	j	534 <printint+0x1a>

00000000000005b8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5b8:	711d                	addi	sp,sp,-96
 5ba:	ec86                	sd	ra,88(sp)
 5bc:	e8a2                	sd	s0,80(sp)
 5be:	e4a6                	sd	s1,72(sp)
 5c0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5c2:	0005c483          	lbu	s1,0(a1)
 5c6:	22048363          	beqz	s1,7ec <vprintf+0x234>
 5ca:	e0ca                	sd	s2,64(sp)
 5cc:	fc4e                	sd	s3,56(sp)
 5ce:	f852                	sd	s4,48(sp)
 5d0:	f456                	sd	s5,40(sp)
 5d2:	f05a                	sd	s6,32(sp)
 5d4:	ec5e                	sd	s7,24(sp)
 5d6:	e862                	sd	s8,16(sp)
 5d8:	8b2a                	mv	s6,a0
 5da:	8a2e                	mv	s4,a1
 5dc:	8bb2                	mv	s7,a2
  state = 0;
 5de:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 5e0:	4901                	li	s2,0
 5e2:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 5e4:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 5e8:	06400c13          	li	s8,100
 5ec:	a00d                	j	60e <vprintf+0x56>
        putc(fd, c0);
 5ee:	85a6                	mv	a1,s1
 5f0:	855a                	mv	a0,s6
 5f2:	f0bff0ef          	jal	4fc <putc>
 5f6:	a019                	j	5fc <vprintf+0x44>
    } else if(state == '%'){
 5f8:	03598363          	beq	s3,s5,61e <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 5fc:	0019079b          	addiw	a5,s2,1
 600:	893e                	mv	s2,a5
 602:	873e                	mv	a4,a5
 604:	97d2                	add	a5,a5,s4
 606:	0007c483          	lbu	s1,0(a5)
 60a:	1c048a63          	beqz	s1,7de <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 60e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 612:	fe0993e3          	bnez	s3,5f8 <vprintf+0x40>
      if(c0 == '%'){
 616:	fd579ce3          	bne	a5,s5,5ee <vprintf+0x36>
        state = '%';
 61a:	89be                	mv	s3,a5
 61c:	b7c5                	j	5fc <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 61e:	00ea06b3          	add	a3,s4,a4
 622:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 626:	1c060863          	beqz	a2,7f6 <vprintf+0x23e>
      if(c0 == 'd'){
 62a:	03878763          	beq	a5,s8,658 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 62e:	f9478693          	addi	a3,a5,-108
 632:	0016b693          	seqz	a3,a3
 636:	f9c60593          	addi	a1,a2,-100
 63a:	e99d                	bnez	a1,670 <vprintf+0xb8>
 63c:	ca95                	beqz	a3,670 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 63e:	008b8493          	addi	s1,s7,8
 642:	4685                	li	a3,1
 644:	4629                	li	a2,10
 646:	000bb583          	ld	a1,0(s7)
 64a:	855a                	mv	a0,s6
 64c:	ecfff0ef          	jal	51a <printint>
        i += 1;
 650:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 652:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 654:	4981                	li	s3,0
 656:	b75d                	j	5fc <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 658:	008b8493          	addi	s1,s7,8
 65c:	4685                	li	a3,1
 65e:	4629                	li	a2,10
 660:	000ba583          	lw	a1,0(s7)
 664:	855a                	mv	a0,s6
 666:	eb5ff0ef          	jal	51a <printint>
 66a:	8ba6                	mv	s7,s1
      state = 0;
 66c:	4981                	li	s3,0
 66e:	b779                	j	5fc <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 670:	9752                	add	a4,a4,s4
 672:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 676:	f9460713          	addi	a4,a2,-108
 67a:	00173713          	seqz	a4,a4
 67e:	8f75                	and	a4,a4,a3
 680:	f9c58513          	addi	a0,a1,-100
 684:	18051363          	bnez	a0,80a <vprintf+0x252>
 688:	18070163          	beqz	a4,80a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 68c:	008b8493          	addi	s1,s7,8
 690:	4685                	li	a3,1
 692:	4629                	li	a2,10
 694:	000bb583          	ld	a1,0(s7)
 698:	855a                	mv	a0,s6
 69a:	e81ff0ef          	jal	51a <printint>
        i += 2;
 69e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6a0:	8ba6                	mv	s7,s1
      state = 0;
 6a2:	4981                	li	s3,0
        i += 2;
 6a4:	bfa1                	j	5fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6a6:	008b8493          	addi	s1,s7,8
 6aa:	4681                	li	a3,0
 6ac:	4629                	li	a2,10
 6ae:	000be583          	lwu	a1,0(s7)
 6b2:	855a                	mv	a0,s6
 6b4:	e67ff0ef          	jal	51a <printint>
 6b8:	8ba6                	mv	s7,s1
      state = 0;
 6ba:	4981                	li	s3,0
 6bc:	b781                	j	5fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6be:	008b8493          	addi	s1,s7,8
 6c2:	4681                	li	a3,0
 6c4:	4629                	li	a2,10
 6c6:	000bb583          	ld	a1,0(s7)
 6ca:	855a                	mv	a0,s6
 6cc:	e4fff0ef          	jal	51a <printint>
        i += 1;
 6d0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d2:	8ba6                	mv	s7,s1
      state = 0;
 6d4:	4981                	li	s3,0
 6d6:	b71d                	j	5fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6d8:	008b8493          	addi	s1,s7,8
 6dc:	4681                	li	a3,0
 6de:	4629                	li	a2,10
 6e0:	000bb583          	ld	a1,0(s7)
 6e4:	855a                	mv	a0,s6
 6e6:	e35ff0ef          	jal	51a <printint>
        i += 2;
 6ea:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ec:	8ba6                	mv	s7,s1
      state = 0;
 6ee:	4981                	li	s3,0
        i += 2;
 6f0:	b731                	j	5fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 6f2:	008b8493          	addi	s1,s7,8
 6f6:	4681                	li	a3,0
 6f8:	4641                	li	a2,16
 6fa:	000be583          	lwu	a1,0(s7)
 6fe:	855a                	mv	a0,s6
 700:	e1bff0ef          	jal	51a <printint>
 704:	8ba6                	mv	s7,s1
      state = 0;
 706:	4981                	li	s3,0
 708:	bdd5                	j	5fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 70a:	008b8493          	addi	s1,s7,8
 70e:	4681                	li	a3,0
 710:	4641                	li	a2,16
 712:	000bb583          	ld	a1,0(s7)
 716:	855a                	mv	a0,s6
 718:	e03ff0ef          	jal	51a <printint>
        i += 1;
 71c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 71e:	8ba6                	mv	s7,s1
      state = 0;
 720:	4981                	li	s3,0
 722:	bde9                	j	5fc <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 724:	008b8493          	addi	s1,s7,8
 728:	4681                	li	a3,0
 72a:	4641                	li	a2,16
 72c:	000bb583          	ld	a1,0(s7)
 730:	855a                	mv	a0,s6
 732:	de9ff0ef          	jal	51a <printint>
        i += 2;
 736:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 738:	8ba6                	mv	s7,s1
      state = 0;
 73a:	4981                	li	s3,0
        i += 2;
 73c:	b5c1                	j	5fc <vprintf+0x44>
 73e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 740:	008b8793          	addi	a5,s7,8
 744:	8cbe                	mv	s9,a5
 746:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 74a:	03000593          	li	a1,48
 74e:	855a                	mv	a0,s6
 750:	dadff0ef          	jal	4fc <putc>
  putc(fd, 'x');
 754:	07800593          	li	a1,120
 758:	855a                	mv	a0,s6
 75a:	da3ff0ef          	jal	4fc <putc>
 75e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 760:	00000b97          	auipc	s7,0x0
 764:	3d8b8b93          	addi	s7,s7,984 # b38 <digits>
 768:	03c9d793          	srli	a5,s3,0x3c
 76c:	97de                	add	a5,a5,s7
 76e:	0007c583          	lbu	a1,0(a5)
 772:	855a                	mv	a0,s6
 774:	d89ff0ef          	jal	4fc <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 778:	0992                	slli	s3,s3,0x4
 77a:	34fd                	addiw	s1,s1,-1
 77c:	f4f5                	bnez	s1,768 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 77e:	8be6                	mv	s7,s9
      state = 0;
 780:	4981                	li	s3,0
 782:	6ca2                	ld	s9,8(sp)
 784:	bda5                	j	5fc <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 786:	008b8493          	addi	s1,s7,8
 78a:	000bc583          	lbu	a1,0(s7)
 78e:	855a                	mv	a0,s6
 790:	d6dff0ef          	jal	4fc <putc>
 794:	8ba6                	mv	s7,s1
      state = 0;
 796:	4981                	li	s3,0
 798:	b595                	j	5fc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 79a:	008b8993          	addi	s3,s7,8
 79e:	000bb483          	ld	s1,0(s7)
 7a2:	cc91                	beqz	s1,7be <vprintf+0x206>
        for(; *s; s++)
 7a4:	0004c583          	lbu	a1,0(s1)
 7a8:	c985                	beqz	a1,7d8 <vprintf+0x220>
          putc(fd, *s);
 7aa:	855a                	mv	a0,s6
 7ac:	d51ff0ef          	jal	4fc <putc>
        for(; *s; s++)
 7b0:	0485                	addi	s1,s1,1
 7b2:	0004c583          	lbu	a1,0(s1)
 7b6:	f9f5                	bnez	a1,7aa <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 7b8:	8bce                	mv	s7,s3
      state = 0;
 7ba:	4981                	li	s3,0
 7bc:	b581                	j	5fc <vprintf+0x44>
          s = "(null)";
 7be:	00000497          	auipc	s1,0x0
 7c2:	34a48493          	addi	s1,s1,842 # b08 <statistics+0xbc>
        for(; *s; s++)
 7c6:	02800593          	li	a1,40
 7ca:	b7c5                	j	7aa <vprintf+0x1f2>
        putc(fd, '%');
 7cc:	85be                	mv	a1,a5
 7ce:	855a                	mv	a0,s6
 7d0:	d2dff0ef          	jal	4fc <putc>
      state = 0;
 7d4:	4981                	li	s3,0
 7d6:	b51d                	j	5fc <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7d8:	8bce                	mv	s7,s3
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b505                	j	5fc <vprintf+0x44>
 7de:	6906                	ld	s2,64(sp)
 7e0:	79e2                	ld	s3,56(sp)
 7e2:	7a42                	ld	s4,48(sp)
 7e4:	7aa2                	ld	s5,40(sp)
 7e6:	7b02                	ld	s6,32(sp)
 7e8:	6be2                	ld	s7,24(sp)
 7ea:	6c42                	ld	s8,16(sp)
    }
  }
}
 7ec:	60e6                	ld	ra,88(sp)
 7ee:	6446                	ld	s0,80(sp)
 7f0:	64a6                	ld	s1,72(sp)
 7f2:	6125                	addi	sp,sp,96
 7f4:	8082                	ret
      if(c0 == 'd'){
 7f6:	06400713          	li	a4,100
 7fa:	e4e78fe3          	beq	a5,a4,658 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 7fe:	f9478693          	addi	a3,a5,-108
 802:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 806:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 808:	4701                	li	a4,0
      } else if(c0 == 'u'){
 80a:	07500513          	li	a0,117
 80e:	e8a78ce3          	beq	a5,a0,6a6 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 812:	f8b60513          	addi	a0,a2,-117
 816:	e119                	bnez	a0,81c <vprintf+0x264>
 818:	ea0693e3          	bnez	a3,6be <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 81c:	f8b58513          	addi	a0,a1,-117
 820:	e119                	bnez	a0,826 <vprintf+0x26e>
 822:	ea071be3          	bnez	a4,6d8 <vprintf+0x120>
      } else if(c0 == 'x'){
 826:	07800513          	li	a0,120
 82a:	eca784e3          	beq	a5,a0,6f2 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 82e:	f8860613          	addi	a2,a2,-120
 832:	e219                	bnez	a2,838 <vprintf+0x280>
 834:	ec069be3          	bnez	a3,70a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 838:	f8858593          	addi	a1,a1,-120
 83c:	e199                	bnez	a1,842 <vprintf+0x28a>
 83e:	ee0713e3          	bnez	a4,724 <vprintf+0x16c>
      } else if(c0 == 'p'){
 842:	07000713          	li	a4,112
 846:	eee78ce3          	beq	a5,a4,73e <vprintf+0x186>
      } else if(c0 == 'c'){
 84a:	06300713          	li	a4,99
 84e:	f2e78ce3          	beq	a5,a4,786 <vprintf+0x1ce>
      } else if(c0 == 's'){
 852:	07300713          	li	a4,115
 856:	f4e782e3          	beq	a5,a4,79a <vprintf+0x1e2>
      } else if(c0 == '%'){
 85a:	02500713          	li	a4,37
 85e:	f6e787e3          	beq	a5,a4,7cc <vprintf+0x214>
        putc(fd, '%');
 862:	02500593          	li	a1,37
 866:	855a                	mv	a0,s6
 868:	c95ff0ef          	jal	4fc <putc>
        putc(fd, c0);
 86c:	85a6                	mv	a1,s1
 86e:	855a                	mv	a0,s6
 870:	c8dff0ef          	jal	4fc <putc>
      state = 0;
 874:	4981                	li	s3,0
 876:	b359                	j	5fc <vprintf+0x44>

0000000000000878 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 878:	715d                	addi	sp,sp,-80
 87a:	ec06                	sd	ra,24(sp)
 87c:	e822                	sd	s0,16(sp)
 87e:	1000                	addi	s0,sp,32
 880:	e010                	sd	a2,0(s0)
 882:	e414                	sd	a3,8(s0)
 884:	e818                	sd	a4,16(s0)
 886:	ec1c                	sd	a5,24(s0)
 888:	03043023          	sd	a6,32(s0)
 88c:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 890:	8622                	mv	a2,s0
 892:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 896:	d23ff0ef          	jal	5b8 <vprintf>
}
 89a:	60e2                	ld	ra,24(sp)
 89c:	6442                	ld	s0,16(sp)
 89e:	6161                	addi	sp,sp,80
 8a0:	8082                	ret

00000000000008a2 <printf>:

void
printf(const char *fmt, ...)
{
 8a2:	711d                	addi	sp,sp,-96
 8a4:	ec06                	sd	ra,24(sp)
 8a6:	e822                	sd	s0,16(sp)
 8a8:	1000                	addi	s0,sp,32
 8aa:	e40c                	sd	a1,8(s0)
 8ac:	e810                	sd	a2,16(s0)
 8ae:	ec14                	sd	a3,24(s0)
 8b0:	f018                	sd	a4,32(s0)
 8b2:	f41c                	sd	a5,40(s0)
 8b4:	03043823          	sd	a6,48(s0)
 8b8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8bc:	00840613          	addi	a2,s0,8
 8c0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8c4:	85aa                	mv	a1,a0
 8c6:	4505                	li	a0,1
 8c8:	cf1ff0ef          	jal	5b8 <vprintf>
}
 8cc:	60e2                	ld	ra,24(sp)
 8ce:	6442                	ld	s0,16(sp)
 8d0:	6125                	addi	sp,sp,96
 8d2:	8082                	ret

00000000000008d4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8d4:	1141                	addi	sp,sp,-16
 8d6:	e406                	sd	ra,8(sp)
 8d8:	e022                	sd	s0,0(sp)
 8da:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8dc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8e0:	00000797          	auipc	a5,0x0
 8e4:	7207b783          	ld	a5,1824(a5) # 1000 <freep>
 8e8:	a039                	j	8f6 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 8ea:	6398                	ld	a4,0(a5)
 8ec:	00e7e463          	bltu	a5,a4,8f4 <free+0x20>
 8f0:	00e6ea63          	bltu	a3,a4,904 <free+0x30>
{
 8f4:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 8f6:	fed7fae3          	bgeu	a5,a3,8ea <free+0x16>
 8fa:	6398                	ld	a4,0(a5)
 8fc:	00e6e463          	bltu	a3,a4,904 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 900:	fee7eae3          	bltu	a5,a4,8f4 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 904:	ff852583          	lw	a1,-8(a0)
 908:	6390                	ld	a2,0(a5)
 90a:	02059813          	slli	a6,a1,0x20
 90e:	01c85713          	srli	a4,a6,0x1c
 912:	9736                	add	a4,a4,a3
 914:	02e60563          	beq	a2,a4,93e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 918:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 91c:	4790                	lw	a2,8(a5)
 91e:	02061593          	slli	a1,a2,0x20
 922:	01c5d713          	srli	a4,a1,0x1c
 926:	973e                	add	a4,a4,a5
 928:	02e68263          	beq	a3,a4,94c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 92c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 92e:	00000717          	auipc	a4,0x0
 932:	6cf73923          	sd	a5,1746(a4) # 1000 <freep>
}
 936:	60a2                	ld	ra,8(sp)
 938:	6402                	ld	s0,0(sp)
 93a:	0141                	addi	sp,sp,16
 93c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 93e:	4618                	lw	a4,8(a2)
 940:	9f2d                	addw	a4,a4,a1
 942:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	6398                	ld	a4,0(a5)
 948:	6310                	ld	a2,0(a4)
 94a:	b7f9                	j	918 <free+0x44>
    p->s.size += bp->s.size;
 94c:	ff852703          	lw	a4,-8(a0)
 950:	9f31                	addw	a4,a4,a2
 952:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 954:	ff053683          	ld	a3,-16(a0)
 958:	bfd1                	j	92c <free+0x58>

000000000000095a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 95a:	7139                	addi	sp,sp,-64
 95c:	fc06                	sd	ra,56(sp)
 95e:	f822                	sd	s0,48(sp)
 960:	f04a                	sd	s2,32(sp)
 962:	ec4e                	sd	s3,24(sp)
 964:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 966:	02051993          	slli	s3,a0,0x20
 96a:	0209d993          	srli	s3,s3,0x20
 96e:	09bd                	addi	s3,s3,15
 970:	0049d993          	srli	s3,s3,0x4
 974:	2985                	addiw	s3,s3,1
 976:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 978:	00000517          	auipc	a0,0x0
 97c:	68853503          	ld	a0,1672(a0) # 1000 <freep>
 980:	c905                	beqz	a0,9b0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 982:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 984:	4798                	lw	a4,8(a5)
 986:	09377663          	bgeu	a4,s3,a12 <malloc+0xb8>
 98a:	f426                	sd	s1,40(sp)
 98c:	e852                	sd	s4,16(sp)
 98e:	e456                	sd	s5,8(sp)
 990:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 992:	8a4e                	mv	s4,s3
 994:	6705                	lui	a4,0x1
 996:	00e9f363          	bgeu	s3,a4,99c <malloc+0x42>
 99a:	6a05                	lui	s4,0x1
 99c:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9a0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9a4:	00000497          	auipc	s1,0x0
 9a8:	65c48493          	addi	s1,s1,1628 # 1000 <freep>
  if(p == SBRK_ERROR)
 9ac:	5afd                	li	s5,-1
 9ae:	a83d                	j	9ec <malloc+0x92>
 9b0:	f426                	sd	s1,40(sp)
 9b2:	e852                	sd	s4,16(sp)
 9b4:	e456                	sd	s5,8(sp)
 9b6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9b8:	00001797          	auipc	a5,0x1
 9bc:	85878793          	addi	a5,a5,-1960 # 1210 <base>
 9c0:	00000717          	auipc	a4,0x0
 9c4:	64f73023          	sd	a5,1600(a4) # 1000 <freep>
 9c8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ca:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ce:	b7d1                	j	992 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9d0:	6398                	ld	a4,0(a5)
 9d2:	e118                	sd	a4,0(a0)
 9d4:	a899                	j	a2a <malloc+0xd0>
  hp->s.size = nu;
 9d6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9da:	0541                	addi	a0,a0,16
 9dc:	ef9ff0ef          	jal	8d4 <free>
  return freep;
 9e0:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 9e2:	c125                	beqz	a0,a42 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9e4:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9e6:	4798                	lw	a4,8(a5)
 9e8:	03277163          	bgeu	a4,s2,a0a <malloc+0xb0>
    if(p == freep)
 9ec:	6098                	ld	a4,0(s1)
 9ee:	853e                	mv	a0,a5
 9f0:	fef71ae3          	bne	a4,a5,9e4 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 9f4:	8552                	mv	a0,s4
 9f6:	9e9ff0ef          	jal	3de <sbrk>
  if(p == SBRK_ERROR)
 9fa:	fd551ee3          	bne	a0,s5,9d6 <malloc+0x7c>
        return 0;
 9fe:	4501                	li	a0,0
 a00:	74a2                	ld	s1,40(sp)
 a02:	6a42                	ld	s4,16(sp)
 a04:	6aa2                	ld	s5,8(sp)
 a06:	6b02                	ld	s6,0(sp)
 a08:	a03d                	j	a36 <malloc+0xdc>
 a0a:	74a2                	ld	s1,40(sp)
 a0c:	6a42                	ld	s4,16(sp)
 a0e:	6aa2                	ld	s5,8(sp)
 a10:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a12:	fae90fe3          	beq	s2,a4,9d0 <malloc+0x76>
        p->s.size -= nunits;
 a16:	4137073b          	subw	a4,a4,s3
 a1a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a1c:	02071693          	slli	a3,a4,0x20
 a20:	01c6d713          	srli	a4,a3,0x1c
 a24:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a26:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a2a:	00000717          	auipc	a4,0x0
 a2e:	5ca73b23          	sd	a0,1494(a4) # 1000 <freep>
      return (void*)(p + 1);
 a32:	01078513          	addi	a0,a5,16
  }
}
 a36:	70e2                	ld	ra,56(sp)
 a38:	7442                	ld	s0,48(sp)
 a3a:	7902                	ld	s2,32(sp)
 a3c:	69e2                	ld	s3,24(sp)
 a3e:	6121                	addi	sp,sp,64
 a40:	8082                	ret
 a42:	74a2                	ld	s1,40(sp)
 a44:	6a42                	ld	s4,16(sp)
 a46:	6aa2                	ld	s5,8(sp)
 a48:	6b02                	ld	s6,0(sp)
 a4a:	b7f5                	j	a36 <malloc+0xdc>

0000000000000a4c <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 a4c:	7179                	addi	sp,sp,-48
 a4e:	f406                	sd	ra,40(sp)
 a50:	f022                	sd	s0,32(sp)
 a52:	ec26                	sd	s1,24(sp)
 a54:	e84a                	sd	s2,16(sp)
 a56:	e44e                	sd	s3,8(sp)
 a58:	e052                	sd	s4,0(sp)
 a5a:	1800                	addi	s0,sp,48
 a5c:	8a2a                	mv	s4,a0
 a5e:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 a60:	4581                	li	a1,0
 a62:	00000517          	auipc	a0,0x0
 a66:	0ae50513          	addi	a0,a0,174 # b10 <statistics+0xc4>
 a6a:	9e9ff0ef          	jal	452 <open>
  if(fd < 0) {
 a6e:	02054e63          	bltz	a0,aaa <statistics+0x5e>
 a72:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 a74:	4481                	li	s1,0
 a76:	01205e63          	blez	s2,a92 <statistics+0x46>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 a7a:	4099063b          	subw	a2,s2,s1
 a7e:	009a05b3          	add	a1,s4,s1
 a82:	854e                	mv	a0,s3
 a84:	9a7ff0ef          	jal	42a <read>
 a88:	00054563          	bltz	a0,a92 <statistics+0x46>
      break;
    }
    i += n;
 a8c:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 a8e:	ff24c6e3          	blt	s1,s2,a7a <statistics+0x2e>
  }
  close(fd);
 a92:	854e                	mv	a0,s3
 a94:	9a7ff0ef          	jal	43a <close>
  return i;
}
 a98:	8526                	mv	a0,s1
 a9a:	70a2                	ld	ra,40(sp)
 a9c:	7402                	ld	s0,32(sp)
 a9e:	64e2                	ld	s1,24(sp)
 aa0:	6942                	ld	s2,16(sp)
 aa2:	69a2                	ld	s3,8(sp)
 aa4:	6a02                	ld	s4,0(sp)
 aa6:	6145                	addi	sp,sp,48
 aa8:	8082                	ret
      fprintf(2, "stats: open failed\n");
 aaa:	00000597          	auipc	a1,0x0
 aae:	07658593          	addi	a1,a1,118 # b20 <statistics+0xd4>
 ab2:	4509                	li	a0,2
 ab4:	dc5ff0ef          	jal	878 <fprintf>
      exit(1);
 ab8:	4505                	li	a0,1
 aba:	959ff0ef          	jal	412 <exit>
