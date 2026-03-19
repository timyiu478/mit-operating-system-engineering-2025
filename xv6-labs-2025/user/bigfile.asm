
user/_bigfile:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <main>:
#include "kernel/fcntl.h"
#include "kernel/fs.h"

int
main()
{
   0:	bb010113          	addi	sp,sp,-1104
   4:	44113423          	sd	ra,1096(sp)
   8:	44813023          	sd	s0,1088(sp)
   c:	45010413          	addi	s0,sp,1104
  char buf[BSIZE];
  int fd, i, blocks, readblocks;

  fd = open("big.file", O_CREATE | O_WRONLY);
  10:	20100593          	li	a1,513
  14:	00001517          	auipc	a0,0x1
  18:	a5c50513          	addi	a0,a0,-1444 # a70 <malloc+0xf6>
  1c:	498000ef          	jal	4b4 <open>
  if(fd < 0){
  20:	06054a63          	bltz	a0,94 <main+0x94>
  24:	42913c23          	sd	s1,1080(sp)
  28:	43213823          	sd	s2,1072(sp)
  2c:	43313423          	sd	s3,1064(sp)
  30:	43413023          	sd	s4,1056(sp)
  34:	41513c23          	sd	s5,1048(sp)
  38:	41613823          	sd	s6,1040(sp)
  3c:	41713423          	sd	s7,1032(sp)
  40:	892a                	mv	s2,a0
  42:	4481                	li	s1,0
  }

  blocks = 0;
  while(1){
    *(int*)buf = blocks;
    int cc = write(fd, buf, sizeof(buf));
  44:	bb040a93          	addi	s5,s0,-1104
  48:	40000a13          	li	s4,1024
    if(cc <= 0)
      break;
    blocks++;
    if (blocks % 100 == 0)
  4c:	51eb89b7          	lui	s3,0x51eb8
  50:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51eb750f>
  54:	06400b13          	li	s6,100
      printf(".");
  58:	00001b97          	auipc	s7,0x1
  5c:	a58b8b93          	addi	s7,s7,-1448 # ab0 <malloc+0x136>
    *(int*)buf = blocks;
  60:	ba942823          	sw	s1,-1104(s0)
    int cc = write(fd, buf, sizeof(buf));
  64:	8652                	mv	a2,s4
  66:	85d6                	mv	a1,s5
  68:	854a                	mv	a0,s2
  6a:	42a000ef          	jal	494 <write>
    if(cc <= 0)
  6e:	04a05a63          	blez	a0,c2 <main+0xc2>
    blocks++;
  72:	0014871b          	addiw	a4,s1,1
  76:	84ba                	mv	s1,a4
    if (blocks % 100 == 0)
  78:	033707b3          	mul	a5,a4,s3
  7c:	9795                	srai	a5,a5,0x25
  7e:	41f7569b          	sraiw	a3,a4,0x1f
  82:	9f95                	subw	a5,a5,a3
  84:	02fb07bb          	mulw	a5,s6,a5
  88:	9f1d                	subw	a4,a4,a5
  8a:	fb79                	bnez	a4,60 <main+0x60>
      printf(".");
  8c:	855e                	mv	a0,s7
  8e:	035000ef          	jal	8c2 <printf>
  92:	b7f9                	j	60 <main+0x60>
  94:	42913c23          	sd	s1,1080(sp)
  98:	43213823          	sd	s2,1072(sp)
  9c:	43313423          	sd	s3,1064(sp)
  a0:	43413023          	sd	s4,1056(sp)
  a4:	41513c23          	sd	s5,1048(sp)
  a8:	41613823          	sd	s6,1040(sp)
  ac:	41713423          	sd	s7,1032(sp)
    printf("bigfile: cannot open big.file for writing\n");
  b0:	00001517          	auipc	a0,0x1
  b4:	9d050513          	addi	a0,a0,-1584 # a80 <malloc+0x106>
  b8:	00b000ef          	jal	8c2 <printf>
    exit(-1);
  bc:	557d                	li	a0,-1
  be:	3b6000ef          	jal	474 <exit>
  }

  printf("\nwrote %d blocks\n", blocks);
  c2:	85a6                	mv	a1,s1
  c4:	00001517          	auipc	a0,0x1
  c8:	9f450513          	addi	a0,a0,-1548 # ab8 <malloc+0x13e>
  cc:	7f6000ef          	jal	8c2 <printf>
  if(blocks != 65803) {
  d0:	67c1                	lui	a5,0x10
  d2:	10b78793          	addi	a5,a5,267 # 1010b <base+0xf0fb>
  d6:	00f48b63          	beq	s1,a5,ec <main+0xec>
    printf("bigfile: file is too small\n");
  da:	00001517          	auipc	a0,0x1
  de:	9f650513          	addi	a0,a0,-1546 # ad0 <malloc+0x156>
  e2:	7e0000ef          	jal	8c2 <printf>
    exit(-1);
  e6:	557d                	li	a0,-1
  e8:	38c000ef          	jal	474 <exit>
  }
  
  close(fd);
  ec:	854a                	mv	a0,s2
  ee:	3ae000ef          	jal	49c <close>
  fd = open("big.file", O_RDONLY);
  f2:	4581                	li	a1,0
  f4:	00001517          	auipc	a0,0x1
  f8:	97c50513          	addi	a0,a0,-1668 # a70 <malloc+0xf6>
  fc:	3b8000ef          	jal	4b4 <open>
 100:	892a                	mv	s2,a0
  printf("reading bigfile\n");
 102:	00001517          	auipc	a0,0x1
 106:	9ee50513          	addi	a0,a0,-1554 # af0 <malloc+0x176>
 10a:	7b8000ef          	jal	8c2 <printf>
  if(fd < 0){
    printf("bigfile: cannot re-open big.file for reading\n");
    exit(-1);
  }
  readblocks = 0;
 10e:	4481                	li	s1,0
  if(fd < 0){
 110:	02094063          	bltz	s2,130 <main+0x130>
  for(i = 0; i < blocks; i++){
    int cc = read(fd, buf, sizeof(buf));
 114:	bb040b13          	addi	s6,s0,-1104
 118:	40000a93          	li	s5,1024
      printf("bigfile: read the wrong data (%d) for block %d\n",
             *(int*)buf, i);
      exit(-1);
    }
    readblocks++;
    if (readblocks % 100 == 0)
 11c:	51eb8a37          	lui	s4,0x51eb8
 120:	51fa0a13          	addi	s4,s4,1311 # 51eb851f <base+0x51eb750f>
 124:	06400b93          	li	s7,100
  for(i = 0; i < blocks; i++){
 128:	69c1                	lui	s3,0x10
 12a:	10b98993          	addi	s3,s3,267 # 1010b <base+0xf0fb>
 12e:	a081                	j	16e <main+0x16e>
    printf("bigfile: cannot re-open big.file for reading\n");
 130:	00001517          	auipc	a0,0x1
 134:	9d850513          	addi	a0,a0,-1576 # b08 <malloc+0x18e>
 138:	78a000ef          	jal	8c2 <printf>
    exit(-1);
 13c:	557d                	li	a0,-1
 13e:	336000ef          	jal	474 <exit>
      printf("bigfile: read error at block %d\n", i);
 142:	85a6                	mv	a1,s1
 144:	00001517          	auipc	a0,0x1
 148:	9f450513          	addi	a0,a0,-1548 # b38 <malloc+0x1be>
 14c:	776000ef          	jal	8c2 <printf>
      exit(-1);
 150:	557d                	li	a0,-1
 152:	322000ef          	jal	474 <exit>
      printf("bigfile: read the wrong data (%d) for block %d\n",
 156:	8626                	mv	a2,s1
 158:	00001517          	auipc	a0,0x1
 15c:	a0850513          	addi	a0,a0,-1528 # b60 <malloc+0x1e6>
 160:	762000ef          	jal	8c2 <printf>
      exit(-1);
 164:	557d                	li	a0,-1
 166:	30e000ef          	jal	474 <exit>
  for(i = 0; i < blocks; i++){
 16a:	05348163          	beq	s1,s3,1ac <main+0x1ac>
    int cc = read(fd, buf, sizeof(buf));
 16e:	8656                	mv	a2,s5
 170:	85da                	mv	a1,s6
 172:	854a                	mv	a0,s2
 174:	318000ef          	jal	48c <read>
    if(cc <= 0){
 178:	fca055e3          	blez	a0,142 <main+0x142>
    if(*(int*)buf != i){
 17c:	bb042583          	lw	a1,-1104(s0)
 180:	fc959be3          	bne	a1,s1,156 <main+0x156>
    readblocks++;
 184:	0014871b          	addiw	a4,s1,1
 188:	84ba                	mv	s1,a4
    if (readblocks % 100 == 0)
 18a:	034707b3          	mul	a5,a4,s4
 18e:	9795                	srai	a5,a5,0x25
 190:	41f7569b          	sraiw	a3,a4,0x1f
 194:	9f95                	subw	a5,a5,a3
 196:	02fb87bb          	mulw	a5,s7,a5
 19a:	9f1d                	subw	a4,a4,a5
 19c:	f779                	bnez	a4,16a <main+0x16a>
      printf(".");
 19e:	00001517          	auipc	a0,0x1
 1a2:	91250513          	addi	a0,a0,-1774 # ab0 <malloc+0x136>
 1a6:	71c000ef          	jal	8c2 <printf>
 1aa:	b7c1                	j	16a <main+0x16a>
  }

  printf("\nbigfile done; ok\n"); 
 1ac:	00001517          	auipc	a0,0x1
 1b0:	9e450513          	addi	a0,a0,-1564 # b90 <malloc+0x216>
 1b4:	70e000ef          	jal	8c2 <printf>

  exit(0);
 1b8:	4501                	li	a0,0
 1ba:	2ba000ef          	jal	474 <exit>

00000000000001be <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 1be:	1141                	addi	sp,sp,-16
 1c0:	e406                	sd	ra,8(sp)
 1c2:	e022                	sd	s0,0(sp)
 1c4:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 1c6:	e3bff0ef          	jal	0 <main>
  exit(r);
 1ca:	2aa000ef          	jal	474 <exit>

00000000000001ce <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1ce:	1141                	addi	sp,sp,-16
 1d0:	e406                	sd	ra,8(sp)
 1d2:	e022                	sd	s0,0(sp)
 1d4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1d6:	87aa                	mv	a5,a0
 1d8:	0585                	addi	a1,a1,1
 1da:	0785                	addi	a5,a5,1
 1dc:	fff5c703          	lbu	a4,-1(a1)
 1e0:	fee78fa3          	sb	a4,-1(a5)
 1e4:	fb75                	bnez	a4,1d8 <strcpy+0xa>
    ;
  return os;
}
 1e6:	60a2                	ld	ra,8(sp)
 1e8:	6402                	ld	s0,0(sp)
 1ea:	0141                	addi	sp,sp,16
 1ec:	8082                	ret

00000000000001ee <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1ee:	1141                	addi	sp,sp,-16
 1f0:	e406                	sd	ra,8(sp)
 1f2:	e022                	sd	s0,0(sp)
 1f4:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 1f6:	00054783          	lbu	a5,0(a0)
 1fa:	cb91                	beqz	a5,20e <strcmp+0x20>
 1fc:	0005c703          	lbu	a4,0(a1)
 200:	00f71763          	bne	a4,a5,20e <strcmp+0x20>
    p++, q++;
 204:	0505                	addi	a0,a0,1
 206:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 208:	00054783          	lbu	a5,0(a0)
 20c:	fbe5                	bnez	a5,1fc <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 20e:	0005c503          	lbu	a0,0(a1)
}
 212:	40a7853b          	subw	a0,a5,a0
 216:	60a2                	ld	ra,8(sp)
 218:	6402                	ld	s0,0(sp)
 21a:	0141                	addi	sp,sp,16
 21c:	8082                	ret

000000000000021e <strlen>:

uint
strlen(const char *s)
{
 21e:	1141                	addi	sp,sp,-16
 220:	e406                	sd	ra,8(sp)
 222:	e022                	sd	s0,0(sp)
 224:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 226:	00054783          	lbu	a5,0(a0)
 22a:	cf91                	beqz	a5,246 <strlen+0x28>
 22c:	00150793          	addi	a5,a0,1
 230:	86be                	mv	a3,a5
 232:	0785                	addi	a5,a5,1
 234:	fff7c703          	lbu	a4,-1(a5)
 238:	ff65                	bnez	a4,230 <strlen+0x12>
 23a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 23e:	60a2                	ld	ra,8(sp)
 240:	6402                	ld	s0,0(sp)
 242:	0141                	addi	sp,sp,16
 244:	8082                	ret
  for(n = 0; s[n]; n++)
 246:	4501                	li	a0,0
 248:	bfdd                	j	23e <strlen+0x20>

000000000000024a <memset>:

void*
memset(void *dst, int c, uint n)
{
 24a:	1141                	addi	sp,sp,-16
 24c:	e406                	sd	ra,8(sp)
 24e:	e022                	sd	s0,0(sp)
 250:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 252:	ca19                	beqz	a2,268 <memset+0x1e>
 254:	87aa                	mv	a5,a0
 256:	1602                	slli	a2,a2,0x20
 258:	9201                	srli	a2,a2,0x20
 25a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 25e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 262:	0785                	addi	a5,a5,1
 264:	fee79de3          	bne	a5,a4,25e <memset+0x14>
  }
  return dst;
}
 268:	60a2                	ld	ra,8(sp)
 26a:	6402                	ld	s0,0(sp)
 26c:	0141                	addi	sp,sp,16
 26e:	8082                	ret

0000000000000270 <strchr>:

char*
strchr(const char *s, char c)
{
 270:	1141                	addi	sp,sp,-16
 272:	e406                	sd	ra,8(sp)
 274:	e022                	sd	s0,0(sp)
 276:	0800                	addi	s0,sp,16
  for(; *s; s++)
 278:	00054783          	lbu	a5,0(a0)
 27c:	cf81                	beqz	a5,294 <strchr+0x24>
    if(*s == c)
 27e:	00f58763          	beq	a1,a5,28c <strchr+0x1c>
  for(; *s; s++)
 282:	0505                	addi	a0,a0,1
 284:	00054783          	lbu	a5,0(a0)
 288:	fbfd                	bnez	a5,27e <strchr+0xe>
      return (char*)s;
  return 0;
 28a:	4501                	li	a0,0
}
 28c:	60a2                	ld	ra,8(sp)
 28e:	6402                	ld	s0,0(sp)
 290:	0141                	addi	sp,sp,16
 292:	8082                	ret
  return 0;
 294:	4501                	li	a0,0
 296:	bfdd                	j	28c <strchr+0x1c>

0000000000000298 <gets>:

char*
gets(char *buf, int max)
{
 298:	711d                	addi	sp,sp,-96
 29a:	ec86                	sd	ra,88(sp)
 29c:	e8a2                	sd	s0,80(sp)
 29e:	e4a6                	sd	s1,72(sp)
 2a0:	e0ca                	sd	s2,64(sp)
 2a2:	fc4e                	sd	s3,56(sp)
 2a4:	f852                	sd	s4,48(sp)
 2a6:	f456                	sd	s5,40(sp)
 2a8:	f05a                	sd	s6,32(sp)
 2aa:	ec5e                	sd	s7,24(sp)
 2ac:	e862                	sd	s8,16(sp)
 2ae:	1080                	addi	s0,sp,96
 2b0:	8baa                	mv	s7,a0
 2b2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2b4:	892a                	mv	s2,a0
 2b6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2b8:	faf40b13          	addi	s6,s0,-81
 2bc:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 2be:	8c26                	mv	s8,s1
 2c0:	0014899b          	addiw	s3,s1,1
 2c4:	84ce                	mv	s1,s3
 2c6:	0349d463          	bge	s3,s4,2ee <gets+0x56>
    cc = read(0, &c, 1);
 2ca:	8656                	mv	a2,s5
 2cc:	85da                	mv	a1,s6
 2ce:	4501                	li	a0,0
 2d0:	1bc000ef          	jal	48c <read>
    if(cc < 1)
 2d4:	00a05d63          	blez	a0,2ee <gets+0x56>
      break;
    buf[i++] = c;
 2d8:	faf44783          	lbu	a5,-81(s0)
 2dc:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2e0:	0905                	addi	s2,s2,1
 2e2:	ff678713          	addi	a4,a5,-10
 2e6:	c319                	beqz	a4,2ec <gets+0x54>
 2e8:	17cd                	addi	a5,a5,-13
 2ea:	fbf1                	bnez	a5,2be <gets+0x26>
    buf[i++] = c;
 2ec:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2ee:	9c5e                	add	s8,s8,s7
 2f0:	000c0023          	sb	zero,0(s8)
  return buf;
}
 2f4:	855e                	mv	a0,s7
 2f6:	60e6                	ld	ra,88(sp)
 2f8:	6446                	ld	s0,80(sp)
 2fa:	64a6                	ld	s1,72(sp)
 2fc:	6906                	ld	s2,64(sp)
 2fe:	79e2                	ld	s3,56(sp)
 300:	7a42                	ld	s4,48(sp)
 302:	7aa2                	ld	s5,40(sp)
 304:	7b02                	ld	s6,32(sp)
 306:	6be2                	ld	s7,24(sp)
 308:	6c42                	ld	s8,16(sp)
 30a:	6125                	addi	sp,sp,96
 30c:	8082                	ret

000000000000030e <stat>:

int
stat(const char *n, struct stat *st)
{
 30e:	1101                	addi	sp,sp,-32
 310:	ec06                	sd	ra,24(sp)
 312:	e822                	sd	s0,16(sp)
 314:	e04a                	sd	s2,0(sp)
 316:	1000                	addi	s0,sp,32
 318:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 31a:	4581                	li	a1,0
 31c:	198000ef          	jal	4b4 <open>
  if(fd < 0)
 320:	02054263          	bltz	a0,344 <stat+0x36>
 324:	e426                	sd	s1,8(sp)
 326:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 328:	85ca                	mv	a1,s2
 32a:	1a2000ef          	jal	4cc <fstat>
 32e:	892a                	mv	s2,a0
  close(fd);
 330:	8526                	mv	a0,s1
 332:	16a000ef          	jal	49c <close>
  return r;
 336:	64a2                	ld	s1,8(sp)
}
 338:	854a                	mv	a0,s2
 33a:	60e2                	ld	ra,24(sp)
 33c:	6442                	ld	s0,16(sp)
 33e:	6902                	ld	s2,0(sp)
 340:	6105                	addi	sp,sp,32
 342:	8082                	ret
    return -1;
 344:	57fd                	li	a5,-1
 346:	893e                	mv	s2,a5
 348:	bfc5                	j	338 <stat+0x2a>

000000000000034a <atoi>:

int
atoi(const char *s)
{
 34a:	1141                	addi	sp,sp,-16
 34c:	e406                	sd	ra,8(sp)
 34e:	e022                	sd	s0,0(sp)
 350:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 352:	00054683          	lbu	a3,0(a0)
 356:	fd06879b          	addiw	a5,a3,-48
 35a:	0ff7f793          	zext.b	a5,a5
 35e:	4625                	li	a2,9
 360:	02f66963          	bltu	a2,a5,392 <atoi+0x48>
 364:	872a                	mv	a4,a0
  n = 0;
 366:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 368:	0705                	addi	a4,a4,1
 36a:	0025179b          	slliw	a5,a0,0x2
 36e:	9fa9                	addw	a5,a5,a0
 370:	0017979b          	slliw	a5,a5,0x1
 374:	9fb5                	addw	a5,a5,a3
 376:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 37a:	00074683          	lbu	a3,0(a4)
 37e:	fd06879b          	addiw	a5,a3,-48
 382:	0ff7f793          	zext.b	a5,a5
 386:	fef671e3          	bgeu	a2,a5,368 <atoi+0x1e>
  return n;
}
 38a:	60a2                	ld	ra,8(sp)
 38c:	6402                	ld	s0,0(sp)
 38e:	0141                	addi	sp,sp,16
 390:	8082                	ret
  n = 0;
 392:	4501                	li	a0,0
 394:	bfdd                	j	38a <atoi+0x40>

0000000000000396 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 396:	1141                	addi	sp,sp,-16
 398:	e406                	sd	ra,8(sp)
 39a:	e022                	sd	s0,0(sp)
 39c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 39e:	02b57563          	bgeu	a0,a1,3c8 <memmove+0x32>
    while(n-- > 0)
 3a2:	00c05f63          	blez	a2,3c0 <memmove+0x2a>
 3a6:	1602                	slli	a2,a2,0x20
 3a8:	9201                	srli	a2,a2,0x20
 3aa:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3ae:	872a                	mv	a4,a0
      *dst++ = *src++;
 3b0:	0585                	addi	a1,a1,1
 3b2:	0705                	addi	a4,a4,1
 3b4:	fff5c683          	lbu	a3,-1(a1)
 3b8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3bc:	fee79ae3          	bne	a5,a4,3b0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3c0:	60a2                	ld	ra,8(sp)
 3c2:	6402                	ld	s0,0(sp)
 3c4:	0141                	addi	sp,sp,16
 3c6:	8082                	ret
    while(n-- > 0)
 3c8:	fec05ce3          	blez	a2,3c0 <memmove+0x2a>
    dst += n;
 3cc:	00c50733          	add	a4,a0,a2
    src += n;
 3d0:	95b2                	add	a1,a1,a2
 3d2:	fff6079b          	addiw	a5,a2,-1
 3d6:	1782                	slli	a5,a5,0x20
 3d8:	9381                	srli	a5,a5,0x20
 3da:	fff7c793          	not	a5,a5
 3de:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3e0:	15fd                	addi	a1,a1,-1
 3e2:	177d                	addi	a4,a4,-1
 3e4:	0005c683          	lbu	a3,0(a1)
 3e8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3ec:	fef71ae3          	bne	a4,a5,3e0 <memmove+0x4a>
 3f0:	bfc1                	j	3c0 <memmove+0x2a>

00000000000003f2 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 3f2:	1141                	addi	sp,sp,-16
 3f4:	e406                	sd	ra,8(sp)
 3f6:	e022                	sd	s0,0(sp)
 3f8:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 3fa:	c61d                	beqz	a2,428 <memcmp+0x36>
 3fc:	1602                	slli	a2,a2,0x20
 3fe:	9201                	srli	a2,a2,0x20
 400:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 404:	00054783          	lbu	a5,0(a0)
 408:	0005c703          	lbu	a4,0(a1)
 40c:	00e79863          	bne	a5,a4,41c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 410:	0505                	addi	a0,a0,1
    p2++;
 412:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 414:	fed518e3          	bne	a0,a3,404 <memcmp+0x12>
  }
  return 0;
 418:	4501                	li	a0,0
 41a:	a019                	j	420 <memcmp+0x2e>
      return *p1 - *p2;
 41c:	40e7853b          	subw	a0,a5,a4
}
 420:	60a2                	ld	ra,8(sp)
 422:	6402                	ld	s0,0(sp)
 424:	0141                	addi	sp,sp,16
 426:	8082                	ret
  return 0;
 428:	4501                	li	a0,0
 42a:	bfdd                	j	420 <memcmp+0x2e>

000000000000042c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 42c:	1141                	addi	sp,sp,-16
 42e:	e406                	sd	ra,8(sp)
 430:	e022                	sd	s0,0(sp)
 432:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 434:	f63ff0ef          	jal	396 <memmove>
}
 438:	60a2                	ld	ra,8(sp)
 43a:	6402                	ld	s0,0(sp)
 43c:	0141                	addi	sp,sp,16
 43e:	8082                	ret

0000000000000440 <sbrk>:

char *
sbrk(int n) {
 440:	1141                	addi	sp,sp,-16
 442:	e406                	sd	ra,8(sp)
 444:	e022                	sd	s0,0(sp)
 446:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 448:	4585                	li	a1,1
 44a:	0b2000ef          	jal	4fc <sys_sbrk>
}
 44e:	60a2                	ld	ra,8(sp)
 450:	6402                	ld	s0,0(sp)
 452:	0141                	addi	sp,sp,16
 454:	8082                	ret

0000000000000456 <sbrklazy>:

char *
sbrklazy(int n) {
 456:	1141                	addi	sp,sp,-16
 458:	e406                	sd	ra,8(sp)
 45a:	e022                	sd	s0,0(sp)
 45c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 45e:	4589                	li	a1,2
 460:	09c000ef          	jal	4fc <sys_sbrk>
}
 464:	60a2                	ld	ra,8(sp)
 466:	6402                	ld	s0,0(sp)
 468:	0141                	addi	sp,sp,16
 46a:	8082                	ret

000000000000046c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 46c:	4885                	li	a7,1
 ecall
 46e:	00000073          	ecall
 ret
 472:	8082                	ret

0000000000000474 <exit>:
.global exit
exit:
 li a7, SYS_exit
 474:	4889                	li	a7,2
 ecall
 476:	00000073          	ecall
 ret
 47a:	8082                	ret

000000000000047c <wait>:
.global wait
wait:
 li a7, SYS_wait
 47c:	488d                	li	a7,3
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 484:	4891                	li	a7,4
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <read>:
.global read
read:
 li a7, SYS_read
 48c:	4895                	li	a7,5
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <write>:
.global write
write:
 li a7, SYS_write
 494:	48c1                	li	a7,16
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <close>:
.global close
close:
 li a7, SYS_close
 49c:	48d5                	li	a7,21
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4a4:	4899                	li	a7,6
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <exec>:
.global exec
exec:
 li a7, SYS_exec
 4ac:	489d                	li	a7,7
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <open>:
.global open
open:
 li a7, SYS_open
 4b4:	48bd                	li	a7,15
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4bc:	48c5                	li	a7,17
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4c4:	48c9                	li	a7,18
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4cc:	48a1                	li	a7,8
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <link>:
.global link
link:
 li a7, SYS_link
 4d4:	48cd                	li	a7,19
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4dc:	48d1                	li	a7,20
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4e4:	48a5                	li	a7,9
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <dup>:
.global dup
dup:
 li a7, SYS_dup
 4ec:	48a9                	li	a7,10
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 4f4:	48ad                	li	a7,11
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 4fc:	48b1                	li	a7,12
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <pause>:
.global pause
pause:
 li a7, SYS_pause
 504:	48b5                	li	a7,13
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 50c:	48b9                	li	a7,14
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
 514:	48d9                	li	a7,22
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 51c:	1101                	addi	sp,sp,-32
 51e:	ec06                	sd	ra,24(sp)
 520:	e822                	sd	s0,16(sp)
 522:	1000                	addi	s0,sp,32
 524:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 528:	4605                	li	a2,1
 52a:	fef40593          	addi	a1,s0,-17
 52e:	f67ff0ef          	jal	494 <write>
}
 532:	60e2                	ld	ra,24(sp)
 534:	6442                	ld	s0,16(sp)
 536:	6105                	addi	sp,sp,32
 538:	8082                	ret

000000000000053a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 53a:	715d                	addi	sp,sp,-80
 53c:	e486                	sd	ra,72(sp)
 53e:	e0a2                	sd	s0,64(sp)
 540:	f84a                	sd	s2,48(sp)
 542:	f44e                	sd	s3,40(sp)
 544:	0880                	addi	s0,sp,80
 546:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 548:	c6d1                	beqz	a3,5d4 <printint+0x9a>
 54a:	0805d563          	bgez	a1,5d4 <printint+0x9a>
    neg = 1;
    x = -xx;
 54e:	40b005b3          	neg	a1,a1
    neg = 1;
 552:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 554:	fb840993          	addi	s3,s0,-72
  neg = 0;
 558:	86ce                	mv	a3,s3
  i = 0;
 55a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 55c:	00000817          	auipc	a6,0x0
 560:	65480813          	addi	a6,a6,1620 # bb0 <digits>
 564:	88ba                	mv	a7,a4
 566:	0017051b          	addiw	a0,a4,1
 56a:	872a                	mv	a4,a0
 56c:	02c5f7b3          	remu	a5,a1,a2
 570:	97c2                	add	a5,a5,a6
 572:	0007c783          	lbu	a5,0(a5)
 576:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 57a:	87ae                	mv	a5,a1
 57c:	02c5d5b3          	divu	a1,a1,a2
 580:	0685                	addi	a3,a3,1
 582:	fec7f1e3          	bgeu	a5,a2,564 <printint+0x2a>
  if(neg)
 586:	00030c63          	beqz	t1,59e <printint+0x64>
    buf[i++] = '-';
 58a:	fd050793          	addi	a5,a0,-48
 58e:	00878533          	add	a0,a5,s0
 592:	02d00793          	li	a5,45
 596:	fef50423          	sb	a5,-24(a0)
 59a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 59e:	02e05563          	blez	a4,5c8 <printint+0x8e>
 5a2:	fc26                	sd	s1,56(sp)
 5a4:	377d                	addiw	a4,a4,-1
 5a6:	00e984b3          	add	s1,s3,a4
 5aa:	19fd                	addi	s3,s3,-1
 5ac:	99ba                	add	s3,s3,a4
 5ae:	1702                	slli	a4,a4,0x20
 5b0:	9301                	srli	a4,a4,0x20
 5b2:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5b6:	0004c583          	lbu	a1,0(s1)
 5ba:	854a                	mv	a0,s2
 5bc:	f61ff0ef          	jal	51c <putc>
  while(--i >= 0)
 5c0:	14fd                	addi	s1,s1,-1
 5c2:	ff349ae3          	bne	s1,s3,5b6 <printint+0x7c>
 5c6:	74e2                	ld	s1,56(sp)
}
 5c8:	60a6                	ld	ra,72(sp)
 5ca:	6406                	ld	s0,64(sp)
 5cc:	7942                	ld	s2,48(sp)
 5ce:	79a2                	ld	s3,40(sp)
 5d0:	6161                	addi	sp,sp,80
 5d2:	8082                	ret
  neg = 0;
 5d4:	4301                	li	t1,0
 5d6:	bfbd                	j	554 <printint+0x1a>

00000000000005d8 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5d8:	711d                	addi	sp,sp,-96
 5da:	ec86                	sd	ra,88(sp)
 5dc:	e8a2                	sd	s0,80(sp)
 5de:	e4a6                	sd	s1,72(sp)
 5e0:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5e2:	0005c483          	lbu	s1,0(a1)
 5e6:	22048363          	beqz	s1,80c <vprintf+0x234>
 5ea:	e0ca                	sd	s2,64(sp)
 5ec:	fc4e                	sd	s3,56(sp)
 5ee:	f852                	sd	s4,48(sp)
 5f0:	f456                	sd	s5,40(sp)
 5f2:	f05a                	sd	s6,32(sp)
 5f4:	ec5e                	sd	s7,24(sp)
 5f6:	e862                	sd	s8,16(sp)
 5f8:	8b2a                	mv	s6,a0
 5fa:	8a2e                	mv	s4,a1
 5fc:	8bb2                	mv	s7,a2
  state = 0;
 5fe:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 600:	4901                	li	s2,0
 602:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 604:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 608:	06400c13          	li	s8,100
 60c:	a00d                	j	62e <vprintf+0x56>
        putc(fd, c0);
 60e:	85a6                	mv	a1,s1
 610:	855a                	mv	a0,s6
 612:	f0bff0ef          	jal	51c <putc>
 616:	a019                	j	61c <vprintf+0x44>
    } else if(state == '%'){
 618:	03598363          	beq	s3,s5,63e <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 61c:	0019079b          	addiw	a5,s2,1
 620:	893e                	mv	s2,a5
 622:	873e                	mv	a4,a5
 624:	97d2                	add	a5,a5,s4
 626:	0007c483          	lbu	s1,0(a5)
 62a:	1c048a63          	beqz	s1,7fe <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 62e:	0004879b          	sext.w	a5,s1
    if(state == 0){
 632:	fe0993e3          	bnez	s3,618 <vprintf+0x40>
      if(c0 == '%'){
 636:	fd579ce3          	bne	a5,s5,60e <vprintf+0x36>
        state = '%';
 63a:	89be                	mv	s3,a5
 63c:	b7c5                	j	61c <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 63e:	00ea06b3          	add	a3,s4,a4
 642:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 646:	1c060863          	beqz	a2,816 <vprintf+0x23e>
      if(c0 == 'd'){
 64a:	03878763          	beq	a5,s8,678 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 64e:	f9478693          	addi	a3,a5,-108
 652:	0016b693          	seqz	a3,a3
 656:	f9c60593          	addi	a1,a2,-100
 65a:	e99d                	bnez	a1,690 <vprintf+0xb8>
 65c:	ca95                	beqz	a3,690 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 65e:	008b8493          	addi	s1,s7,8
 662:	4685                	li	a3,1
 664:	4629                	li	a2,10
 666:	000bb583          	ld	a1,0(s7)
 66a:	855a                	mv	a0,s6
 66c:	ecfff0ef          	jal	53a <printint>
        i += 1;
 670:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 672:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 674:	4981                	li	s3,0
 676:	b75d                	j	61c <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 678:	008b8493          	addi	s1,s7,8
 67c:	4685                	li	a3,1
 67e:	4629                	li	a2,10
 680:	000ba583          	lw	a1,0(s7)
 684:	855a                	mv	a0,s6
 686:	eb5ff0ef          	jal	53a <printint>
 68a:	8ba6                	mv	s7,s1
      state = 0;
 68c:	4981                	li	s3,0
 68e:	b779                	j	61c <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 690:	9752                	add	a4,a4,s4
 692:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 696:	f9460713          	addi	a4,a2,-108
 69a:	00173713          	seqz	a4,a4
 69e:	8f75                	and	a4,a4,a3
 6a0:	f9c58513          	addi	a0,a1,-100
 6a4:	18051363          	bnez	a0,82a <vprintf+0x252>
 6a8:	18070163          	beqz	a4,82a <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ac:	008b8493          	addi	s1,s7,8
 6b0:	4685                	li	a3,1
 6b2:	4629                	li	a2,10
 6b4:	000bb583          	ld	a1,0(s7)
 6b8:	855a                	mv	a0,s6
 6ba:	e81ff0ef          	jal	53a <printint>
        i += 2;
 6be:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6c0:	8ba6                	mv	s7,s1
      state = 0;
 6c2:	4981                	li	s3,0
        i += 2;
 6c4:	bfa1                	j	61c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6c6:	008b8493          	addi	s1,s7,8
 6ca:	4681                	li	a3,0
 6cc:	4629                	li	a2,10
 6ce:	000be583          	lwu	a1,0(s7)
 6d2:	855a                	mv	a0,s6
 6d4:	e67ff0ef          	jal	53a <printint>
 6d8:	8ba6                	mv	s7,s1
      state = 0;
 6da:	4981                	li	s3,0
 6dc:	b781                	j	61c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6de:	008b8493          	addi	s1,s7,8
 6e2:	4681                	li	a3,0
 6e4:	4629                	li	a2,10
 6e6:	000bb583          	ld	a1,0(s7)
 6ea:	855a                	mv	a0,s6
 6ec:	e4fff0ef          	jal	53a <printint>
        i += 1;
 6f0:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f2:	8ba6                	mv	s7,s1
      state = 0;
 6f4:	4981                	li	s3,0
 6f6:	b71d                	j	61c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6f8:	008b8493          	addi	s1,s7,8
 6fc:	4681                	li	a3,0
 6fe:	4629                	li	a2,10
 700:	000bb583          	ld	a1,0(s7)
 704:	855a                	mv	a0,s6
 706:	e35ff0ef          	jal	53a <printint>
        i += 2;
 70a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 70c:	8ba6                	mv	s7,s1
      state = 0;
 70e:	4981                	li	s3,0
        i += 2;
 710:	b731                	j	61c <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 712:	008b8493          	addi	s1,s7,8
 716:	4681                	li	a3,0
 718:	4641                	li	a2,16
 71a:	000be583          	lwu	a1,0(s7)
 71e:	855a                	mv	a0,s6
 720:	e1bff0ef          	jal	53a <printint>
 724:	8ba6                	mv	s7,s1
      state = 0;
 726:	4981                	li	s3,0
 728:	bdd5                	j	61c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 72a:	008b8493          	addi	s1,s7,8
 72e:	4681                	li	a3,0
 730:	4641                	li	a2,16
 732:	000bb583          	ld	a1,0(s7)
 736:	855a                	mv	a0,s6
 738:	e03ff0ef          	jal	53a <printint>
        i += 1;
 73c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 73e:	8ba6                	mv	s7,s1
      state = 0;
 740:	4981                	li	s3,0
 742:	bde9                	j	61c <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 744:	008b8493          	addi	s1,s7,8
 748:	4681                	li	a3,0
 74a:	4641                	li	a2,16
 74c:	000bb583          	ld	a1,0(s7)
 750:	855a                	mv	a0,s6
 752:	de9ff0ef          	jal	53a <printint>
        i += 2;
 756:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 758:	8ba6                	mv	s7,s1
      state = 0;
 75a:	4981                	li	s3,0
        i += 2;
 75c:	b5c1                	j	61c <vprintf+0x44>
 75e:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 760:	008b8793          	addi	a5,s7,8
 764:	8cbe                	mv	s9,a5
 766:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 76a:	03000593          	li	a1,48
 76e:	855a                	mv	a0,s6
 770:	dadff0ef          	jal	51c <putc>
  putc(fd, 'x');
 774:	07800593          	li	a1,120
 778:	855a                	mv	a0,s6
 77a:	da3ff0ef          	jal	51c <putc>
 77e:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 780:	00000b97          	auipc	s7,0x0
 784:	430b8b93          	addi	s7,s7,1072 # bb0 <digits>
 788:	03c9d793          	srli	a5,s3,0x3c
 78c:	97de                	add	a5,a5,s7
 78e:	0007c583          	lbu	a1,0(a5)
 792:	855a                	mv	a0,s6
 794:	d89ff0ef          	jal	51c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 798:	0992                	slli	s3,s3,0x4
 79a:	34fd                	addiw	s1,s1,-1
 79c:	f4f5                	bnez	s1,788 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 79e:	8be6                	mv	s7,s9
      state = 0;
 7a0:	4981                	li	s3,0
 7a2:	6ca2                	ld	s9,8(sp)
 7a4:	bda5                	j	61c <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 7a6:	008b8493          	addi	s1,s7,8
 7aa:	000bc583          	lbu	a1,0(s7)
 7ae:	855a                	mv	a0,s6
 7b0:	d6dff0ef          	jal	51c <putc>
 7b4:	8ba6                	mv	s7,s1
      state = 0;
 7b6:	4981                	li	s3,0
 7b8:	b595                	j	61c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7ba:	008b8993          	addi	s3,s7,8
 7be:	000bb483          	ld	s1,0(s7)
 7c2:	cc91                	beqz	s1,7de <vprintf+0x206>
        for(; *s; s++)
 7c4:	0004c583          	lbu	a1,0(s1)
 7c8:	c985                	beqz	a1,7f8 <vprintf+0x220>
          putc(fd, *s);
 7ca:	855a                	mv	a0,s6
 7cc:	d51ff0ef          	jal	51c <putc>
        for(; *s; s++)
 7d0:	0485                	addi	s1,s1,1
 7d2:	0004c583          	lbu	a1,0(s1)
 7d6:	f9f5                	bnez	a1,7ca <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 7d8:	8bce                	mv	s7,s3
      state = 0;
 7da:	4981                	li	s3,0
 7dc:	b581                	j	61c <vprintf+0x44>
          s = "(null)";
 7de:	00000497          	auipc	s1,0x0
 7e2:	3ca48493          	addi	s1,s1,970 # ba8 <malloc+0x22e>
        for(; *s; s++)
 7e6:	02800593          	li	a1,40
 7ea:	b7c5                	j	7ca <vprintf+0x1f2>
        putc(fd, '%');
 7ec:	85be                	mv	a1,a5
 7ee:	855a                	mv	a0,s6
 7f0:	d2dff0ef          	jal	51c <putc>
      state = 0;
 7f4:	4981                	li	s3,0
 7f6:	b51d                	j	61c <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7f8:	8bce                	mv	s7,s3
      state = 0;
 7fa:	4981                	li	s3,0
 7fc:	b505                	j	61c <vprintf+0x44>
 7fe:	6906                	ld	s2,64(sp)
 800:	79e2                	ld	s3,56(sp)
 802:	7a42                	ld	s4,48(sp)
 804:	7aa2                	ld	s5,40(sp)
 806:	7b02                	ld	s6,32(sp)
 808:	6be2                	ld	s7,24(sp)
 80a:	6c42                	ld	s8,16(sp)
    }
  }
}
 80c:	60e6                	ld	ra,88(sp)
 80e:	6446                	ld	s0,80(sp)
 810:	64a6                	ld	s1,72(sp)
 812:	6125                	addi	sp,sp,96
 814:	8082                	ret
      if(c0 == 'd'){
 816:	06400713          	li	a4,100
 81a:	e4e78fe3          	beq	a5,a4,678 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 81e:	f9478693          	addi	a3,a5,-108
 822:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 826:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 828:	4701                	li	a4,0
      } else if(c0 == 'u'){
 82a:	07500513          	li	a0,117
 82e:	e8a78ce3          	beq	a5,a0,6c6 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 832:	f8b60513          	addi	a0,a2,-117
 836:	e119                	bnez	a0,83c <vprintf+0x264>
 838:	ea0693e3          	bnez	a3,6de <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 83c:	f8b58513          	addi	a0,a1,-117
 840:	e119                	bnez	a0,846 <vprintf+0x26e>
 842:	ea071be3          	bnez	a4,6f8 <vprintf+0x120>
      } else if(c0 == 'x'){
 846:	07800513          	li	a0,120
 84a:	eca784e3          	beq	a5,a0,712 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 84e:	f8860613          	addi	a2,a2,-120
 852:	e219                	bnez	a2,858 <vprintf+0x280>
 854:	ec069be3          	bnez	a3,72a <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 858:	f8858593          	addi	a1,a1,-120
 85c:	e199                	bnez	a1,862 <vprintf+0x28a>
 85e:	ee0713e3          	bnez	a4,744 <vprintf+0x16c>
      } else if(c0 == 'p'){
 862:	07000713          	li	a4,112
 866:	eee78ce3          	beq	a5,a4,75e <vprintf+0x186>
      } else if(c0 == 'c'){
 86a:	06300713          	li	a4,99
 86e:	f2e78ce3          	beq	a5,a4,7a6 <vprintf+0x1ce>
      } else if(c0 == 's'){
 872:	07300713          	li	a4,115
 876:	f4e782e3          	beq	a5,a4,7ba <vprintf+0x1e2>
      } else if(c0 == '%'){
 87a:	02500713          	li	a4,37
 87e:	f6e787e3          	beq	a5,a4,7ec <vprintf+0x214>
        putc(fd, '%');
 882:	02500593          	li	a1,37
 886:	855a                	mv	a0,s6
 888:	c95ff0ef          	jal	51c <putc>
        putc(fd, c0);
 88c:	85a6                	mv	a1,s1
 88e:	855a                	mv	a0,s6
 890:	c8dff0ef          	jal	51c <putc>
      state = 0;
 894:	4981                	li	s3,0
 896:	b359                	j	61c <vprintf+0x44>

0000000000000898 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 898:	715d                	addi	sp,sp,-80
 89a:	ec06                	sd	ra,24(sp)
 89c:	e822                	sd	s0,16(sp)
 89e:	1000                	addi	s0,sp,32
 8a0:	e010                	sd	a2,0(s0)
 8a2:	e414                	sd	a3,8(s0)
 8a4:	e818                	sd	a4,16(s0)
 8a6:	ec1c                	sd	a5,24(s0)
 8a8:	03043023          	sd	a6,32(s0)
 8ac:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8b0:	8622                	mv	a2,s0
 8b2:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8b6:	d23ff0ef          	jal	5d8 <vprintf>
}
 8ba:	60e2                	ld	ra,24(sp)
 8bc:	6442                	ld	s0,16(sp)
 8be:	6161                	addi	sp,sp,80
 8c0:	8082                	ret

00000000000008c2 <printf>:

void
printf(const char *fmt, ...)
{
 8c2:	711d                	addi	sp,sp,-96
 8c4:	ec06                	sd	ra,24(sp)
 8c6:	e822                	sd	s0,16(sp)
 8c8:	1000                	addi	s0,sp,32
 8ca:	e40c                	sd	a1,8(s0)
 8cc:	e810                	sd	a2,16(s0)
 8ce:	ec14                	sd	a3,24(s0)
 8d0:	f018                	sd	a4,32(s0)
 8d2:	f41c                	sd	a5,40(s0)
 8d4:	03043823          	sd	a6,48(s0)
 8d8:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8dc:	00840613          	addi	a2,s0,8
 8e0:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8e4:	85aa                	mv	a1,a0
 8e6:	4505                	li	a0,1
 8e8:	cf1ff0ef          	jal	5d8 <vprintf>
}
 8ec:	60e2                	ld	ra,24(sp)
 8ee:	6442                	ld	s0,16(sp)
 8f0:	6125                	addi	sp,sp,96
 8f2:	8082                	ret

00000000000008f4 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 8f4:	1141                	addi	sp,sp,-16
 8f6:	e406                	sd	ra,8(sp)
 8f8:	e022                	sd	s0,0(sp)
 8fa:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 8fc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 900:	00000797          	auipc	a5,0x0
 904:	7007b783          	ld	a5,1792(a5) # 1000 <freep>
 908:	a039                	j	916 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 90a:	6398                	ld	a4,0(a5)
 90c:	00e7e463          	bltu	a5,a4,914 <free+0x20>
 910:	00e6ea63          	bltu	a3,a4,924 <free+0x30>
{
 914:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 916:	fed7fae3          	bgeu	a5,a3,90a <free+0x16>
 91a:	6398                	ld	a4,0(a5)
 91c:	00e6e463          	bltu	a3,a4,924 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 920:	fee7eae3          	bltu	a5,a4,914 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 924:	ff852583          	lw	a1,-8(a0)
 928:	6390                	ld	a2,0(a5)
 92a:	02059813          	slli	a6,a1,0x20
 92e:	01c85713          	srli	a4,a6,0x1c
 932:	9736                	add	a4,a4,a3
 934:	02e60563          	beq	a2,a4,95e <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 938:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 93c:	4790                	lw	a2,8(a5)
 93e:	02061593          	slli	a1,a2,0x20
 942:	01c5d713          	srli	a4,a1,0x1c
 946:	973e                	add	a4,a4,a5
 948:	02e68263          	beq	a3,a4,96c <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 94c:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 94e:	00000717          	auipc	a4,0x0
 952:	6af73923          	sd	a5,1714(a4) # 1000 <freep>
}
 956:	60a2                	ld	ra,8(sp)
 958:	6402                	ld	s0,0(sp)
 95a:	0141                	addi	sp,sp,16
 95c:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 95e:	4618                	lw	a4,8(a2)
 960:	9f2d                	addw	a4,a4,a1
 962:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 966:	6398                	ld	a4,0(a5)
 968:	6310                	ld	a2,0(a4)
 96a:	b7f9                	j	938 <free+0x44>
    p->s.size += bp->s.size;
 96c:	ff852703          	lw	a4,-8(a0)
 970:	9f31                	addw	a4,a4,a2
 972:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 974:	ff053683          	ld	a3,-16(a0)
 978:	bfd1                	j	94c <free+0x58>

000000000000097a <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 97a:	7139                	addi	sp,sp,-64
 97c:	fc06                	sd	ra,56(sp)
 97e:	f822                	sd	s0,48(sp)
 980:	f04a                	sd	s2,32(sp)
 982:	ec4e                	sd	s3,24(sp)
 984:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 986:	02051993          	slli	s3,a0,0x20
 98a:	0209d993          	srli	s3,s3,0x20
 98e:	09bd                	addi	s3,s3,15
 990:	0049d993          	srli	s3,s3,0x4
 994:	2985                	addiw	s3,s3,1
 996:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 998:	00000517          	auipc	a0,0x0
 99c:	66853503          	ld	a0,1640(a0) # 1000 <freep>
 9a0:	c905                	beqz	a0,9d0 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9a2:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9a4:	4798                	lw	a4,8(a5)
 9a6:	09377663          	bgeu	a4,s3,a32 <malloc+0xb8>
 9aa:	f426                	sd	s1,40(sp)
 9ac:	e852                	sd	s4,16(sp)
 9ae:	e456                	sd	s5,8(sp)
 9b0:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9b2:	8a4e                	mv	s4,s3
 9b4:	6705                	lui	a4,0x1
 9b6:	00e9f363          	bgeu	s3,a4,9bc <malloc+0x42>
 9ba:	6a05                	lui	s4,0x1
 9bc:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9c0:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9c4:	00000497          	auipc	s1,0x0
 9c8:	63c48493          	addi	s1,s1,1596 # 1000 <freep>
  if(p == SBRK_ERROR)
 9cc:	5afd                	li	s5,-1
 9ce:	a83d                	j	a0c <malloc+0x92>
 9d0:	f426                	sd	s1,40(sp)
 9d2:	e852                	sd	s4,16(sp)
 9d4:	e456                	sd	s5,8(sp)
 9d6:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9d8:	00000797          	auipc	a5,0x0
 9dc:	63878793          	addi	a5,a5,1592 # 1010 <base>
 9e0:	00000717          	auipc	a4,0x0
 9e4:	62f73023          	sd	a5,1568(a4) # 1000 <freep>
 9e8:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9ea:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9ee:	b7d1                	j	9b2 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9f0:	6398                	ld	a4,0(a5)
 9f2:	e118                	sd	a4,0(a0)
 9f4:	a899                	j	a4a <malloc+0xd0>
  hp->s.size = nu;
 9f6:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 9fa:	0541                	addi	a0,a0,16
 9fc:	ef9ff0ef          	jal	8f4 <free>
  return freep;
 a00:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a02:	c125                	beqz	a0,a62 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a04:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a06:	4798                	lw	a4,8(a5)
 a08:	03277163          	bgeu	a4,s2,a2a <malloc+0xb0>
    if(p == freep)
 a0c:	6098                	ld	a4,0(s1)
 a0e:	853e                	mv	a0,a5
 a10:	fef71ae3          	bne	a4,a5,a04 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a14:	8552                	mv	a0,s4
 a16:	a2bff0ef          	jal	440 <sbrk>
  if(p == SBRK_ERROR)
 a1a:	fd551ee3          	bne	a0,s5,9f6 <malloc+0x7c>
        return 0;
 a1e:	4501                	li	a0,0
 a20:	74a2                	ld	s1,40(sp)
 a22:	6a42                	ld	s4,16(sp)
 a24:	6aa2                	ld	s5,8(sp)
 a26:	6b02                	ld	s6,0(sp)
 a28:	a03d                	j	a56 <malloc+0xdc>
 a2a:	74a2                	ld	s1,40(sp)
 a2c:	6a42                	ld	s4,16(sp)
 a2e:	6aa2                	ld	s5,8(sp)
 a30:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a32:	fae90fe3          	beq	s2,a4,9f0 <malloc+0x76>
        p->s.size -= nunits;
 a36:	4137073b          	subw	a4,a4,s3
 a3a:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a3c:	02071693          	slli	a3,a4,0x20
 a40:	01c6d713          	srli	a4,a3,0x1c
 a44:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a46:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a4a:	00000717          	auipc	a4,0x0
 a4e:	5aa73b23          	sd	a0,1462(a4) # 1000 <freep>
      return (void*)(p + 1);
 a52:	01078513          	addi	a0,a5,16
  }
}
 a56:	70e2                	ld	ra,56(sp)
 a58:	7442                	ld	s0,48(sp)
 a5a:	7902                	ld	s2,32(sp)
 a5c:	69e2                	ld	s3,24(sp)
 a5e:	6121                	addi	sp,sp,64
 a60:	8082                	ret
 a62:	74a2                	ld	s1,40(sp)
 a64:	6a42                	ld	s4,16(sp)
 a66:	6aa2                	ld	s5,8(sp)
 a68:	6b02                	ld	s6,0(sp)
 a6a:	b7f5                	j	a56 <malloc+0xdc>
