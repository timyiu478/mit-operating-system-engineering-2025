
user/_sandbox:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <usage>:
#include "kernel/types.h"
#include "kernel/stat.h"
#include "kernel/syscall.h"
#include "user/user.h"

void usage(char *s) {
   0:	1141                	addi	sp,sp,-16
   2:	e406                	sd	ra,8(sp)
   4:	e022                	sd	s0,0(sp)
   6:	0800                	addi	s0,sp,16
   8:	862a                	mv	a2,a0
  fprintf(2, "Usage: %s <mask> <path> <command>\n", s);
   a:	00001597          	auipc	a1,0x1
   e:	9a658593          	addi	a1,a1,-1626 # 9b0 <malloc+0xf2>
  12:	4509                	li	a0,2
  14:	7c8000ef          	jal	7dc <fprintf>
  exit(1);
  18:	4505                	li	a0,1
  1a:	398000ef          	jal	3b2 <exit>

000000000000001e <main>:

// Sandbox a command by disallowing system calls in mask and
// system calls that are using path
int
main(int argc, char *argv[])
{
  1e:	712d                	addi	sp,sp,-288
  20:	ee06                	sd	ra,280(sp)
  22:	ea22                	sd	s0,272(sp)
  24:	e626                	sd	s1,264(sp)
  26:	1200                	addi	s0,sp,288
  28:	84ae                	mv	s1,a1
  int i;
  int n = 2;
  int mask = 1;
  char *nargv[MAXARG];

  if(argc < 4) {
  2a:	478d                	li	a5,3
  2c:	08a7d463          	bge	a5,a0,b4 <main+0x96>
    usage(argv[0]);
  }

  if(argv[mask][0] < '0' || argv[mask][0] > '9'){
  30:	659c                	ld	a5,8(a1)
  32:	0007c783          	lbu	a5,0(a5)
  36:	fd07879b          	addiw	a5,a5,-48
  3a:	0ff7f793          	zext.b	a5,a5
  3e:	4725                	li	a4,9
  40:	06f76d63          	bltu	a4,a5,ba <main+0x9c>
  }

  n += 1; // skip path
    
  // strip off the first n arguments to sandbox
  for(i = n; i < argc && i < MAXARG; i++){
  44:	01858693          	addi	a3,a1,24
  48:	ee040713          	addi	a4,s0,-288
  4c:	460d                	li	a2,3
    nargv[i-n] = argv[i];
  4e:	629c                	ld	a5,0(a3)
  50:	e31c                	sd	a5,0(a4)
  for(i = n; i < argc && i < MAXARG; i++){
  52:	0016079b          	addiw	a5,a2,1
  56:	863e                	mv	a2,a5
  58:	06a1                	addi	a3,a3,8
  5a:	0721                	addi	a4,a4,8
  5c:	00a7d563          	bge	a5,a0,66 <main+0x48>
  60:	0207a793          	slti	a5,a5,32
  64:	f7ed                	bnez	a5,4e <main+0x30>
  }
  nargv[argc-n] = 0;
  66:	3575                	addiw	a0,a0,-3
  68:	050e                	slli	a0,a0,0x3
  6a:	fe050793          	addi	a5,a0,-32
  6e:	00878533          	add	a0,a5,s0
  72:	f0053023          	sd	zero,-256(a0)

  int pid = fork();
  76:	334000ef          	jal	3aa <fork>
  if(pid < 0) {
  7a:	04054363          	bltz	a0,c0 <main+0xa2>
    printf("%s: exec fork failed\n", argv[0]);
    exit(1);
  }
  if(pid == 0) {
  7e:	e52d                	bnez	a0,e8 <main+0xca>
    if (interpose(atoi(argv[mask]), argv[mask+1]) < 0) {
  80:	6488                	ld	a0,8(s1)
  82:	206000ef          	jal	288 <atoi>
  86:	688c                	ld	a1,16(s1)
  88:	3ca000ef          	jal	452 <interpose>
  8c:	04054463          	bltz	a0,d4 <main+0xb6>
      printf("%s: interpose failed", argv[0]);
      exit(1);
    }
    exec(nargv[0], nargv);
  90:	ee040593          	addi	a1,s0,-288
  94:	ee043503          	ld	a0,-288(s0)
  98:	352000ef          	jal	3ea <exec>
    printf("%s: exec %s failed\n", argv[0], nargv[0]);
  9c:	ee043603          	ld	a2,-288(s0)
  a0:	608c                	ld	a1,0(s1)
  a2:	00001517          	auipc	a0,0x1
  a6:	96650513          	addi	a0,a0,-1690 # a08 <malloc+0x14a>
  aa:	75c000ef          	jal	806 <printf>
    exit(1);
  ae:	4505                	li	a0,1
  b0:	302000ef          	jal	3b2 <exit>
    usage(argv[0]);
  b4:	6188                	ld	a0,0(a1)
  b6:	f4bff0ef          	jal	0 <usage>
    usage(argv[0]);
  ba:	6188                	ld	a0,0(a1)
  bc:	f45ff0ef          	jal	0 <usage>
    printf("%s: exec fork failed\n", argv[0]);
  c0:	608c                	ld	a1,0(s1)
  c2:	00001517          	auipc	a0,0x1
  c6:	91650513          	addi	a0,a0,-1770 # 9d8 <malloc+0x11a>
  ca:	73c000ef          	jal	806 <printf>
    exit(1);
  ce:	4505                	li	a0,1
  d0:	2e2000ef          	jal	3b2 <exit>
      printf("%s: interpose failed", argv[0]);
  d4:	608c                	ld	a1,0(s1)
  d6:	00001517          	auipc	a0,0x1
  da:	91a50513          	addi	a0,a0,-1766 # 9f0 <malloc+0x132>
  de:	728000ef          	jal	806 <printf>
      exit(1);
  e2:	4505                	li	a0,1
  e4:	2ce000ef          	jal	3b2 <exit>
  } else {
    wait(0);
  e8:	4501                	li	a0,0
  ea:	2d0000ef          	jal	3ba <wait>
  }
  
  return 0;
}
  ee:	4501                	li	a0,0
  f0:	60f2                	ld	ra,280(sp)
  f2:	6452                	ld	s0,272(sp)
  f4:	64b2                	ld	s1,264(sp)
  f6:	6115                	addi	sp,sp,288
  f8:	8082                	ret

00000000000000fa <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
  fa:	1141                	addi	sp,sp,-16
  fc:	e406                	sd	ra,8(sp)
  fe:	e022                	sd	s0,0(sp)
 100:	0800                	addi	s0,sp,16
  extern int main();
  main();
 102:	f1dff0ef          	jal	1e <main>
  exit(0);
 106:	4501                	li	a0,0
 108:	2aa000ef          	jal	3b2 <exit>

000000000000010c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 10c:	1141                	addi	sp,sp,-16
 10e:	e406                	sd	ra,8(sp)
 110:	e022                	sd	s0,0(sp)
 112:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 114:	87aa                	mv	a5,a0
 116:	0585                	addi	a1,a1,1
 118:	0785                	addi	a5,a5,1
 11a:	fff5c703          	lbu	a4,-1(a1)
 11e:	fee78fa3          	sb	a4,-1(a5)
 122:	fb75                	bnez	a4,116 <strcpy+0xa>
    ;
  return os;
}
 124:	60a2                	ld	ra,8(sp)
 126:	6402                	ld	s0,0(sp)
 128:	0141                	addi	sp,sp,16
 12a:	8082                	ret

000000000000012c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 12c:	1141                	addi	sp,sp,-16
 12e:	e406                	sd	ra,8(sp)
 130:	e022                	sd	s0,0(sp)
 132:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 134:	00054783          	lbu	a5,0(a0)
 138:	cb91                	beqz	a5,14c <strcmp+0x20>
 13a:	0005c703          	lbu	a4,0(a1)
 13e:	00f71763          	bne	a4,a5,14c <strcmp+0x20>
    p++, q++;
 142:	0505                	addi	a0,a0,1
 144:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 146:	00054783          	lbu	a5,0(a0)
 14a:	fbe5                	bnez	a5,13a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 14c:	0005c503          	lbu	a0,0(a1)
}
 150:	40a7853b          	subw	a0,a5,a0
 154:	60a2                	ld	ra,8(sp)
 156:	6402                	ld	s0,0(sp)
 158:	0141                	addi	sp,sp,16
 15a:	8082                	ret

000000000000015c <strlen>:

uint
strlen(const char *s)
{
 15c:	1141                	addi	sp,sp,-16
 15e:	e406                	sd	ra,8(sp)
 160:	e022                	sd	s0,0(sp)
 162:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 164:	00054783          	lbu	a5,0(a0)
 168:	cf91                	beqz	a5,184 <strlen+0x28>
 16a:	00150793          	addi	a5,a0,1
 16e:	86be                	mv	a3,a5
 170:	0785                	addi	a5,a5,1
 172:	fff7c703          	lbu	a4,-1(a5)
 176:	ff65                	bnez	a4,16e <strlen+0x12>
 178:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 17c:	60a2                	ld	ra,8(sp)
 17e:	6402                	ld	s0,0(sp)
 180:	0141                	addi	sp,sp,16
 182:	8082                	ret
  for(n = 0; s[n]; n++)
 184:	4501                	li	a0,0
 186:	bfdd                	j	17c <strlen+0x20>

0000000000000188 <memset>:

void*
memset(void *dst, int c, uint n)
{
 188:	1141                	addi	sp,sp,-16
 18a:	e406                	sd	ra,8(sp)
 18c:	e022                	sd	s0,0(sp)
 18e:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 190:	ca19                	beqz	a2,1a6 <memset+0x1e>
 192:	87aa                	mv	a5,a0
 194:	1602                	slli	a2,a2,0x20
 196:	9201                	srli	a2,a2,0x20
 198:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 19c:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 1a0:	0785                	addi	a5,a5,1
 1a2:	fee79de3          	bne	a5,a4,19c <memset+0x14>
  }
  return dst;
}
 1a6:	60a2                	ld	ra,8(sp)
 1a8:	6402                	ld	s0,0(sp)
 1aa:	0141                	addi	sp,sp,16
 1ac:	8082                	ret

00000000000001ae <strchr>:

char*
strchr(const char *s, char c)
{
 1ae:	1141                	addi	sp,sp,-16
 1b0:	e406                	sd	ra,8(sp)
 1b2:	e022                	sd	s0,0(sp)
 1b4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 1b6:	00054783          	lbu	a5,0(a0)
 1ba:	cf81                	beqz	a5,1d2 <strchr+0x24>
    if(*s == c)
 1bc:	00f58763          	beq	a1,a5,1ca <strchr+0x1c>
  for(; *s; s++)
 1c0:	0505                	addi	a0,a0,1
 1c2:	00054783          	lbu	a5,0(a0)
 1c6:	fbfd                	bnez	a5,1bc <strchr+0xe>
      return (char*)s;
  return 0;
 1c8:	4501                	li	a0,0
}
 1ca:	60a2                	ld	ra,8(sp)
 1cc:	6402                	ld	s0,0(sp)
 1ce:	0141                	addi	sp,sp,16
 1d0:	8082                	ret
  return 0;
 1d2:	4501                	li	a0,0
 1d4:	bfdd                	j	1ca <strchr+0x1c>

00000000000001d6 <gets>:

char*
gets(char *buf, int max)
{
 1d6:	711d                	addi	sp,sp,-96
 1d8:	ec86                	sd	ra,88(sp)
 1da:	e8a2                	sd	s0,80(sp)
 1dc:	e4a6                	sd	s1,72(sp)
 1de:	e0ca                	sd	s2,64(sp)
 1e0:	fc4e                	sd	s3,56(sp)
 1e2:	f852                	sd	s4,48(sp)
 1e4:	f456                	sd	s5,40(sp)
 1e6:	f05a                	sd	s6,32(sp)
 1e8:	ec5e                	sd	s7,24(sp)
 1ea:	e862                	sd	s8,16(sp)
 1ec:	1080                	addi	s0,sp,96
 1ee:	8baa                	mv	s7,a0
 1f0:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1f2:	892a                	mv	s2,a0
 1f4:	4481                	li	s1,0
    cc = read(0, &c, 1);
 1f6:	faf40b13          	addi	s6,s0,-81
 1fa:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 1fc:	8c26                	mv	s8,s1
 1fe:	0014899b          	addiw	s3,s1,1
 202:	84ce                	mv	s1,s3
 204:	0349d463          	bge	s3,s4,22c <gets+0x56>
    cc = read(0, &c, 1);
 208:	8656                	mv	a2,s5
 20a:	85da                	mv	a1,s6
 20c:	4501                	li	a0,0
 20e:	1bc000ef          	jal	3ca <read>
    if(cc < 1)
 212:	00a05d63          	blez	a0,22c <gets+0x56>
      break;
    buf[i++] = c;
 216:	faf44783          	lbu	a5,-81(s0)
 21a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 21e:	0905                	addi	s2,s2,1
 220:	ff678713          	addi	a4,a5,-10
 224:	c319                	beqz	a4,22a <gets+0x54>
 226:	17cd                	addi	a5,a5,-13
 228:	fbf1                	bnez	a5,1fc <gets+0x26>
    buf[i++] = c;
 22a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 22c:	9c5e                	add	s8,s8,s7
 22e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 232:	855e                	mv	a0,s7
 234:	60e6                	ld	ra,88(sp)
 236:	6446                	ld	s0,80(sp)
 238:	64a6                	ld	s1,72(sp)
 23a:	6906                	ld	s2,64(sp)
 23c:	79e2                	ld	s3,56(sp)
 23e:	7a42                	ld	s4,48(sp)
 240:	7aa2                	ld	s5,40(sp)
 242:	7b02                	ld	s6,32(sp)
 244:	6be2                	ld	s7,24(sp)
 246:	6c42                	ld	s8,16(sp)
 248:	6125                	addi	sp,sp,96
 24a:	8082                	ret

000000000000024c <stat>:

int
stat(const char *n, struct stat *st)
{
 24c:	1101                	addi	sp,sp,-32
 24e:	ec06                	sd	ra,24(sp)
 250:	e822                	sd	s0,16(sp)
 252:	e04a                	sd	s2,0(sp)
 254:	1000                	addi	s0,sp,32
 256:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 258:	4581                	li	a1,0
 25a:	198000ef          	jal	3f2 <open>
  if(fd < 0)
 25e:	02054263          	bltz	a0,282 <stat+0x36>
 262:	e426                	sd	s1,8(sp)
 264:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 266:	85ca                	mv	a1,s2
 268:	1a2000ef          	jal	40a <fstat>
 26c:	892a                	mv	s2,a0
  close(fd);
 26e:	8526                	mv	a0,s1
 270:	16a000ef          	jal	3da <close>
  return r;
 274:	64a2                	ld	s1,8(sp)
}
 276:	854a                	mv	a0,s2
 278:	60e2                	ld	ra,24(sp)
 27a:	6442                	ld	s0,16(sp)
 27c:	6902                	ld	s2,0(sp)
 27e:	6105                	addi	sp,sp,32
 280:	8082                	ret
    return -1;
 282:	57fd                	li	a5,-1
 284:	893e                	mv	s2,a5
 286:	bfc5                	j	276 <stat+0x2a>

0000000000000288 <atoi>:

int
atoi(const char *s)
{
 288:	1141                	addi	sp,sp,-16
 28a:	e406                	sd	ra,8(sp)
 28c:	e022                	sd	s0,0(sp)
 28e:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 290:	00054683          	lbu	a3,0(a0)
 294:	fd06879b          	addiw	a5,a3,-48
 298:	0ff7f793          	zext.b	a5,a5
 29c:	4625                	li	a2,9
 29e:	02f66963          	bltu	a2,a5,2d0 <atoi+0x48>
 2a2:	872a                	mv	a4,a0
  n = 0;
 2a4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 2a6:	0705                	addi	a4,a4,1
 2a8:	0025179b          	slliw	a5,a0,0x2
 2ac:	9fa9                	addw	a5,a5,a0
 2ae:	0017979b          	slliw	a5,a5,0x1
 2b2:	9fb5                	addw	a5,a5,a3
 2b4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 2b8:	00074683          	lbu	a3,0(a4)
 2bc:	fd06879b          	addiw	a5,a3,-48
 2c0:	0ff7f793          	zext.b	a5,a5
 2c4:	fef671e3          	bgeu	a2,a5,2a6 <atoi+0x1e>
  return n;
}
 2c8:	60a2                	ld	ra,8(sp)
 2ca:	6402                	ld	s0,0(sp)
 2cc:	0141                	addi	sp,sp,16
 2ce:	8082                	ret
  n = 0;
 2d0:	4501                	li	a0,0
 2d2:	bfdd                	j	2c8 <atoi+0x40>

00000000000002d4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 2d4:	1141                	addi	sp,sp,-16
 2d6:	e406                	sd	ra,8(sp)
 2d8:	e022                	sd	s0,0(sp)
 2da:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 2dc:	02b57563          	bgeu	a0,a1,306 <memmove+0x32>
    while(n-- > 0)
 2e0:	00c05f63          	blez	a2,2fe <memmove+0x2a>
 2e4:	1602                	slli	a2,a2,0x20
 2e6:	9201                	srli	a2,a2,0x20
 2e8:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 2ec:	872a                	mv	a4,a0
      *dst++ = *src++;
 2ee:	0585                	addi	a1,a1,1
 2f0:	0705                	addi	a4,a4,1
 2f2:	fff5c683          	lbu	a3,-1(a1)
 2f6:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 2fa:	fee79ae3          	bne	a5,a4,2ee <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 2fe:	60a2                	ld	ra,8(sp)
 300:	6402                	ld	s0,0(sp)
 302:	0141                	addi	sp,sp,16
 304:	8082                	ret
    while(n-- > 0)
 306:	fec05ce3          	blez	a2,2fe <memmove+0x2a>
    dst += n;
 30a:	00c50733          	add	a4,a0,a2
    src += n;
 30e:	95b2                	add	a1,a1,a2
 310:	fff6079b          	addiw	a5,a2,-1
 314:	1782                	slli	a5,a5,0x20
 316:	9381                	srli	a5,a5,0x20
 318:	fff7c793          	not	a5,a5
 31c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 31e:	15fd                	addi	a1,a1,-1
 320:	177d                	addi	a4,a4,-1
 322:	0005c683          	lbu	a3,0(a1)
 326:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 32a:	fef71ae3          	bne	a4,a5,31e <memmove+0x4a>
 32e:	bfc1                	j	2fe <memmove+0x2a>

0000000000000330 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 330:	1141                	addi	sp,sp,-16
 332:	e406                	sd	ra,8(sp)
 334:	e022                	sd	s0,0(sp)
 336:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 338:	c61d                	beqz	a2,366 <memcmp+0x36>
 33a:	1602                	slli	a2,a2,0x20
 33c:	9201                	srli	a2,a2,0x20
 33e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 342:	00054783          	lbu	a5,0(a0)
 346:	0005c703          	lbu	a4,0(a1)
 34a:	00e79863          	bne	a5,a4,35a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 34e:	0505                	addi	a0,a0,1
    p2++;
 350:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 352:	fed518e3          	bne	a0,a3,342 <memcmp+0x12>
  }
  return 0;
 356:	4501                	li	a0,0
 358:	a019                	j	35e <memcmp+0x2e>
      return *p1 - *p2;
 35a:	40e7853b          	subw	a0,a5,a4
}
 35e:	60a2                	ld	ra,8(sp)
 360:	6402                	ld	s0,0(sp)
 362:	0141                	addi	sp,sp,16
 364:	8082                	ret
  return 0;
 366:	4501                	li	a0,0
 368:	bfdd                	j	35e <memcmp+0x2e>

000000000000036a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 36a:	1141                	addi	sp,sp,-16
 36c:	e406                	sd	ra,8(sp)
 36e:	e022                	sd	s0,0(sp)
 370:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 372:	f63ff0ef          	jal	2d4 <memmove>
}
 376:	60a2                	ld	ra,8(sp)
 378:	6402                	ld	s0,0(sp)
 37a:	0141                	addi	sp,sp,16
 37c:	8082                	ret

000000000000037e <sbrk>:

char *
sbrk(int n) {
 37e:	1141                	addi	sp,sp,-16
 380:	e406                	sd	ra,8(sp)
 382:	e022                	sd	s0,0(sp)
 384:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 386:	4585                	li	a1,1
 388:	0b2000ef          	jal	43a <sys_sbrk>
}
 38c:	60a2                	ld	ra,8(sp)
 38e:	6402                	ld	s0,0(sp)
 390:	0141                	addi	sp,sp,16
 392:	8082                	ret

0000000000000394 <sbrklazy>:

char *
sbrklazy(int n) {
 394:	1141                	addi	sp,sp,-16
 396:	e406                	sd	ra,8(sp)
 398:	e022                	sd	s0,0(sp)
 39a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 39c:	4589                	li	a1,2
 39e:	09c000ef          	jal	43a <sys_sbrk>
}
 3a2:	60a2                	ld	ra,8(sp)
 3a4:	6402                	ld	s0,0(sp)
 3a6:	0141                	addi	sp,sp,16
 3a8:	8082                	ret

00000000000003aa <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 3aa:	4885                	li	a7,1
 ecall
 3ac:	00000073          	ecall
 ret
 3b0:	8082                	ret

00000000000003b2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 3b2:	4889                	li	a7,2
 ecall
 3b4:	00000073          	ecall
 ret
 3b8:	8082                	ret

00000000000003ba <wait>:
.global wait
wait:
 li a7, SYS_wait
 3ba:	488d                	li	a7,3
 ecall
 3bc:	00000073          	ecall
 ret
 3c0:	8082                	ret

00000000000003c2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 3c2:	4891                	li	a7,4
 ecall
 3c4:	00000073          	ecall
 ret
 3c8:	8082                	ret

00000000000003ca <read>:
.global read
read:
 li a7, SYS_read
 3ca:	4895                	li	a7,5
 ecall
 3cc:	00000073          	ecall
 ret
 3d0:	8082                	ret

00000000000003d2 <write>:
.global write
write:
 li a7, SYS_write
 3d2:	48c1                	li	a7,16
 ecall
 3d4:	00000073          	ecall
 ret
 3d8:	8082                	ret

00000000000003da <close>:
.global close
close:
 li a7, SYS_close
 3da:	48d5                	li	a7,21
 ecall
 3dc:	00000073          	ecall
 ret
 3e0:	8082                	ret

00000000000003e2 <kill>:
.global kill
kill:
 li a7, SYS_kill
 3e2:	4899                	li	a7,6
 ecall
 3e4:	00000073          	ecall
 ret
 3e8:	8082                	ret

00000000000003ea <exec>:
.global exec
exec:
 li a7, SYS_exec
 3ea:	489d                	li	a7,7
 ecall
 3ec:	00000073          	ecall
 ret
 3f0:	8082                	ret

00000000000003f2 <open>:
.global open
open:
 li a7, SYS_open
 3f2:	48bd                	li	a7,15
 ecall
 3f4:	00000073          	ecall
 ret
 3f8:	8082                	ret

00000000000003fa <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 3fa:	48c5                	li	a7,17
 ecall
 3fc:	00000073          	ecall
 ret
 400:	8082                	ret

0000000000000402 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 402:	48c9                	li	a7,18
 ecall
 404:	00000073          	ecall
 ret
 408:	8082                	ret

000000000000040a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 40a:	48a1                	li	a7,8
 ecall
 40c:	00000073          	ecall
 ret
 410:	8082                	ret

0000000000000412 <link>:
.global link
link:
 li a7, SYS_link
 412:	48cd                	li	a7,19
 ecall
 414:	00000073          	ecall
 ret
 418:	8082                	ret

000000000000041a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 41a:	48d1                	li	a7,20
 ecall
 41c:	00000073          	ecall
 ret
 420:	8082                	ret

0000000000000422 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 422:	48a5                	li	a7,9
 ecall
 424:	00000073          	ecall
 ret
 428:	8082                	ret

000000000000042a <dup>:
.global dup
dup:
 li a7, SYS_dup
 42a:	48a9                	li	a7,10
 ecall
 42c:	00000073          	ecall
 ret
 430:	8082                	ret

0000000000000432 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 432:	48ad                	li	a7,11
 ecall
 434:	00000073          	ecall
 ret
 438:	8082                	ret

000000000000043a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 43a:	48b1                	li	a7,12
 ecall
 43c:	00000073          	ecall
 ret
 440:	8082                	ret

0000000000000442 <pause>:
.global pause
pause:
 li a7, SYS_pause
 442:	48b5                	li	a7,13
 ecall
 444:	00000073          	ecall
 ret
 448:	8082                	ret

000000000000044a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 44a:	48b9                	li	a7,14
 ecall
 44c:	00000073          	ecall
 ret
 450:	8082                	ret

0000000000000452 <interpose>:
.global interpose
interpose:
 li a7, SYS_interpose
 452:	48d9                	li	a7,22
 ecall
 454:	00000073          	ecall
 ret
 458:	8082                	ret

000000000000045a <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 45a:	1101                	addi	sp,sp,-32
 45c:	ec06                	sd	ra,24(sp)
 45e:	e822                	sd	s0,16(sp)
 460:	1000                	addi	s0,sp,32
 462:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 466:	4605                	li	a2,1
 468:	fef40593          	addi	a1,s0,-17
 46c:	f67ff0ef          	jal	3d2 <write>
}
 470:	60e2                	ld	ra,24(sp)
 472:	6442                	ld	s0,16(sp)
 474:	6105                	addi	sp,sp,32
 476:	8082                	ret

0000000000000478 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 478:	715d                	addi	sp,sp,-80
 47a:	e486                	sd	ra,72(sp)
 47c:	e0a2                	sd	s0,64(sp)
 47e:	f84a                	sd	s2,48(sp)
 480:	f44e                	sd	s3,40(sp)
 482:	0880                	addi	s0,sp,80
 484:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 486:	cac1                	beqz	a3,516 <printint+0x9e>
 488:	0805d763          	bgez	a1,516 <printint+0x9e>
    neg = 1;
    x = -xx;
 48c:	40b005bb          	negw	a1,a1
    neg = 1;
 490:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 492:	fb840993          	addi	s3,s0,-72
  neg = 0;
 496:	86ce                	mv	a3,s3
  i = 0;
 498:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 49a:	00000817          	auipc	a6,0x0
 49e:	58e80813          	addi	a6,a6,1422 # a28 <digits>
 4a2:	88ba                	mv	a7,a4
 4a4:	0017051b          	addiw	a0,a4,1
 4a8:	872a                	mv	a4,a0
 4aa:	02c5f7bb          	remuw	a5,a1,a2
 4ae:	1782                	slli	a5,a5,0x20
 4b0:	9381                	srli	a5,a5,0x20
 4b2:	97c2                	add	a5,a5,a6
 4b4:	0007c783          	lbu	a5,0(a5)
 4b8:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 4bc:	87ae                	mv	a5,a1
 4be:	02c5d5bb          	divuw	a1,a1,a2
 4c2:	0685                	addi	a3,a3,1
 4c4:	fcc7ffe3          	bgeu	a5,a2,4a2 <printint+0x2a>
  if(neg)
 4c8:	00030c63          	beqz	t1,4e0 <printint+0x68>
    buf[i++] = '-';
 4cc:	fd050793          	addi	a5,a0,-48
 4d0:	00878533          	add	a0,a5,s0
 4d4:	02d00793          	li	a5,45
 4d8:	fef50423          	sb	a5,-24(a0)
 4dc:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 4e0:	02e05563          	blez	a4,50a <printint+0x92>
 4e4:	fc26                	sd	s1,56(sp)
 4e6:	377d                	addiw	a4,a4,-1
 4e8:	00e984b3          	add	s1,s3,a4
 4ec:	19fd                	addi	s3,s3,-1
 4ee:	99ba                	add	s3,s3,a4
 4f0:	1702                	slli	a4,a4,0x20
 4f2:	9301                	srli	a4,a4,0x20
 4f4:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 4f8:	0004c583          	lbu	a1,0(s1)
 4fc:	854a                	mv	a0,s2
 4fe:	f5dff0ef          	jal	45a <putc>
  while(--i >= 0)
 502:	14fd                	addi	s1,s1,-1
 504:	ff349ae3          	bne	s1,s3,4f8 <printint+0x80>
 508:	74e2                	ld	s1,56(sp)
}
 50a:	60a6                	ld	ra,72(sp)
 50c:	6406                	ld	s0,64(sp)
 50e:	7942                	ld	s2,48(sp)
 510:	79a2                	ld	s3,40(sp)
 512:	6161                	addi	sp,sp,80
 514:	8082                	ret
    x = xx;
 516:	2581                	sext.w	a1,a1
  neg = 0;
 518:	4301                	li	t1,0
 51a:	bfa5                	j	492 <printint+0x1a>

000000000000051c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 51c:	711d                	addi	sp,sp,-96
 51e:	ec86                	sd	ra,88(sp)
 520:	e8a2                	sd	s0,80(sp)
 522:	e4a6                	sd	s1,72(sp)
 524:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 526:	0005c483          	lbu	s1,0(a1)
 52a:	22048363          	beqz	s1,750 <vprintf+0x234>
 52e:	e0ca                	sd	s2,64(sp)
 530:	fc4e                	sd	s3,56(sp)
 532:	f852                	sd	s4,48(sp)
 534:	f456                	sd	s5,40(sp)
 536:	f05a                	sd	s6,32(sp)
 538:	ec5e                	sd	s7,24(sp)
 53a:	e862                	sd	s8,16(sp)
 53c:	8b2a                	mv	s6,a0
 53e:	8a2e                	mv	s4,a1
 540:	8bb2                	mv	s7,a2
  state = 0;
 542:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 544:	4901                	li	s2,0
 546:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 548:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 54c:	06400c13          	li	s8,100
 550:	a00d                	j	572 <vprintf+0x56>
        putc(fd, c0);
 552:	85a6                	mv	a1,s1
 554:	855a                	mv	a0,s6
 556:	f05ff0ef          	jal	45a <putc>
 55a:	a019                	j	560 <vprintf+0x44>
    } else if(state == '%'){
 55c:	03598363          	beq	s3,s5,582 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 560:	0019079b          	addiw	a5,s2,1
 564:	893e                	mv	s2,a5
 566:	873e                	mv	a4,a5
 568:	97d2                	add	a5,a5,s4
 56a:	0007c483          	lbu	s1,0(a5)
 56e:	1c048a63          	beqz	s1,742 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 572:	0004879b          	sext.w	a5,s1
    if(state == 0){
 576:	fe0993e3          	bnez	s3,55c <vprintf+0x40>
      if(c0 == '%'){
 57a:	fd579ce3          	bne	a5,s5,552 <vprintf+0x36>
        state = '%';
 57e:	89be                	mv	s3,a5
 580:	b7c5                	j	560 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 582:	00ea06b3          	add	a3,s4,a4
 586:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 58a:	1c060863          	beqz	a2,75a <vprintf+0x23e>
      if(c0 == 'd'){
 58e:	03878763          	beq	a5,s8,5bc <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 592:	f9478693          	addi	a3,a5,-108
 596:	0016b693          	seqz	a3,a3
 59a:	f9c60593          	addi	a1,a2,-100
 59e:	e99d                	bnez	a1,5d4 <vprintf+0xb8>
 5a0:	ca95                	beqz	a3,5d4 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5a2:	008b8493          	addi	s1,s7,8
 5a6:	4685                	li	a3,1
 5a8:	4629                	li	a2,10
 5aa:	000bb583          	ld	a1,0(s7)
 5ae:	855a                	mv	a0,s6
 5b0:	ec9ff0ef          	jal	478 <printint>
        i += 1;
 5b4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 5b6:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 5b8:	4981                	li	s3,0
 5ba:	b75d                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 5bc:	008b8493          	addi	s1,s7,8
 5c0:	4685                	li	a3,1
 5c2:	4629                	li	a2,10
 5c4:	000ba583          	lw	a1,0(s7)
 5c8:	855a                	mv	a0,s6
 5ca:	eafff0ef          	jal	478 <printint>
 5ce:	8ba6                	mv	s7,s1
      state = 0;
 5d0:	4981                	li	s3,0
 5d2:	b779                	j	560 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 5d4:	9752                	add	a4,a4,s4
 5d6:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 5da:	f9460713          	addi	a4,a2,-108
 5de:	00173713          	seqz	a4,a4
 5e2:	8f75                	and	a4,a4,a3
 5e4:	f9c58513          	addi	a0,a1,-100
 5e8:	18051363          	bnez	a0,76e <vprintf+0x252>
 5ec:	18070163          	beqz	a4,76e <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 5f0:	008b8493          	addi	s1,s7,8
 5f4:	4685                	li	a3,1
 5f6:	4629                	li	a2,10
 5f8:	000bb583          	ld	a1,0(s7)
 5fc:	855a                	mv	a0,s6
 5fe:	e7bff0ef          	jal	478 <printint>
        i += 2;
 602:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 604:	8ba6                	mv	s7,s1
      state = 0;
 606:	4981                	li	s3,0
        i += 2;
 608:	bfa1                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 60a:	008b8493          	addi	s1,s7,8
 60e:	4681                	li	a3,0
 610:	4629                	li	a2,10
 612:	000be583          	lwu	a1,0(s7)
 616:	855a                	mv	a0,s6
 618:	e61ff0ef          	jal	478 <printint>
 61c:	8ba6                	mv	s7,s1
      state = 0;
 61e:	4981                	li	s3,0
 620:	b781                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 622:	008b8493          	addi	s1,s7,8
 626:	4681                	li	a3,0
 628:	4629                	li	a2,10
 62a:	000bb583          	ld	a1,0(s7)
 62e:	855a                	mv	a0,s6
 630:	e49ff0ef          	jal	478 <printint>
        i += 1;
 634:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 636:	8ba6                	mv	s7,s1
      state = 0;
 638:	4981                	li	s3,0
 63a:	b71d                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 63c:	008b8493          	addi	s1,s7,8
 640:	4681                	li	a3,0
 642:	4629                	li	a2,10
 644:	000bb583          	ld	a1,0(s7)
 648:	855a                	mv	a0,s6
 64a:	e2fff0ef          	jal	478 <printint>
        i += 2;
 64e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 650:	8ba6                	mv	s7,s1
      state = 0;
 652:	4981                	li	s3,0
        i += 2;
 654:	b731                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 656:	008b8493          	addi	s1,s7,8
 65a:	4681                	li	a3,0
 65c:	4641                	li	a2,16
 65e:	000be583          	lwu	a1,0(s7)
 662:	855a                	mv	a0,s6
 664:	e15ff0ef          	jal	478 <printint>
 668:	8ba6                	mv	s7,s1
      state = 0;
 66a:	4981                	li	s3,0
 66c:	bdd5                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 66e:	008b8493          	addi	s1,s7,8
 672:	4681                	li	a3,0
 674:	4641                	li	a2,16
 676:	000bb583          	ld	a1,0(s7)
 67a:	855a                	mv	a0,s6
 67c:	dfdff0ef          	jal	478 <printint>
        i += 1;
 680:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 682:	8ba6                	mv	s7,s1
      state = 0;
 684:	4981                	li	s3,0
 686:	bde9                	j	560 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 688:	008b8493          	addi	s1,s7,8
 68c:	4681                	li	a3,0
 68e:	4641                	li	a2,16
 690:	000bb583          	ld	a1,0(s7)
 694:	855a                	mv	a0,s6
 696:	de3ff0ef          	jal	478 <printint>
        i += 2;
 69a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 69c:	8ba6                	mv	s7,s1
      state = 0;
 69e:	4981                	li	s3,0
        i += 2;
 6a0:	b5c1                	j	560 <vprintf+0x44>
 6a2:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 6a4:	008b8793          	addi	a5,s7,8
 6a8:	8cbe                	mv	s9,a5
 6aa:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 6ae:	03000593          	li	a1,48
 6b2:	855a                	mv	a0,s6
 6b4:	da7ff0ef          	jal	45a <putc>
  putc(fd, 'x');
 6b8:	07800593          	li	a1,120
 6bc:	855a                	mv	a0,s6
 6be:	d9dff0ef          	jal	45a <putc>
 6c2:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 6c4:	00000b97          	auipc	s7,0x0
 6c8:	364b8b93          	addi	s7,s7,868 # a28 <digits>
 6cc:	03c9d793          	srli	a5,s3,0x3c
 6d0:	97de                	add	a5,a5,s7
 6d2:	0007c583          	lbu	a1,0(a5)
 6d6:	855a                	mv	a0,s6
 6d8:	d83ff0ef          	jal	45a <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 6dc:	0992                	slli	s3,s3,0x4
 6de:	34fd                	addiw	s1,s1,-1
 6e0:	f4f5                	bnez	s1,6cc <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 6e2:	8be6                	mv	s7,s9
      state = 0;
 6e4:	4981                	li	s3,0
 6e6:	6ca2                	ld	s9,8(sp)
 6e8:	bda5                	j	560 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 6ea:	008b8493          	addi	s1,s7,8
 6ee:	000bc583          	lbu	a1,0(s7)
 6f2:	855a                	mv	a0,s6
 6f4:	d67ff0ef          	jal	45a <putc>
 6f8:	8ba6                	mv	s7,s1
      state = 0;
 6fa:	4981                	li	s3,0
 6fc:	b595                	j	560 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 6fe:	008b8993          	addi	s3,s7,8
 702:	000bb483          	ld	s1,0(s7)
 706:	cc91                	beqz	s1,722 <vprintf+0x206>
        for(; *s; s++)
 708:	0004c583          	lbu	a1,0(s1)
 70c:	c985                	beqz	a1,73c <vprintf+0x220>
          putc(fd, *s);
 70e:	855a                	mv	a0,s6
 710:	d4bff0ef          	jal	45a <putc>
        for(; *s; s++)
 714:	0485                	addi	s1,s1,1
 716:	0004c583          	lbu	a1,0(s1)
 71a:	f9f5                	bnez	a1,70e <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 71c:	8bce                	mv	s7,s3
      state = 0;
 71e:	4981                	li	s3,0
 720:	b581                	j	560 <vprintf+0x44>
          s = "(null)";
 722:	00000497          	auipc	s1,0x0
 726:	2fe48493          	addi	s1,s1,766 # a20 <malloc+0x162>
        for(; *s; s++)
 72a:	02800593          	li	a1,40
 72e:	b7c5                	j	70e <vprintf+0x1f2>
        putc(fd, '%');
 730:	85be                	mv	a1,a5
 732:	855a                	mv	a0,s6
 734:	d27ff0ef          	jal	45a <putc>
      state = 0;
 738:	4981                	li	s3,0
 73a:	b51d                	j	560 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 73c:	8bce                	mv	s7,s3
      state = 0;
 73e:	4981                	li	s3,0
 740:	b505                	j	560 <vprintf+0x44>
 742:	6906                	ld	s2,64(sp)
 744:	79e2                	ld	s3,56(sp)
 746:	7a42                	ld	s4,48(sp)
 748:	7aa2                	ld	s5,40(sp)
 74a:	7b02                	ld	s6,32(sp)
 74c:	6be2                	ld	s7,24(sp)
 74e:	6c42                	ld	s8,16(sp)
    }
  }
}
 750:	60e6                	ld	ra,88(sp)
 752:	6446                	ld	s0,80(sp)
 754:	64a6                	ld	s1,72(sp)
 756:	6125                	addi	sp,sp,96
 758:	8082                	ret
      if(c0 == 'd'){
 75a:	06400713          	li	a4,100
 75e:	e4e78fe3          	beq	a5,a4,5bc <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 762:	f9478693          	addi	a3,a5,-108
 766:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 76a:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 76c:	4701                	li	a4,0
      } else if(c0 == 'u'){
 76e:	07500513          	li	a0,117
 772:	e8a78ce3          	beq	a5,a0,60a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 776:	f8b60513          	addi	a0,a2,-117
 77a:	e119                	bnez	a0,780 <vprintf+0x264>
 77c:	ea0693e3          	bnez	a3,622 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 780:	f8b58513          	addi	a0,a1,-117
 784:	e119                	bnez	a0,78a <vprintf+0x26e>
 786:	ea071be3          	bnez	a4,63c <vprintf+0x120>
      } else if(c0 == 'x'){
 78a:	07800513          	li	a0,120
 78e:	eca784e3          	beq	a5,a0,656 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 792:	f8860613          	addi	a2,a2,-120
 796:	e219                	bnez	a2,79c <vprintf+0x280>
 798:	ec069be3          	bnez	a3,66e <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 79c:	f8858593          	addi	a1,a1,-120
 7a0:	e199                	bnez	a1,7a6 <vprintf+0x28a>
 7a2:	ee0713e3          	bnez	a4,688 <vprintf+0x16c>
      } else if(c0 == 'p'){
 7a6:	07000713          	li	a4,112
 7aa:	eee78ce3          	beq	a5,a4,6a2 <vprintf+0x186>
      } else if(c0 == 'c'){
 7ae:	06300713          	li	a4,99
 7b2:	f2e78ce3          	beq	a5,a4,6ea <vprintf+0x1ce>
      } else if(c0 == 's'){
 7b6:	07300713          	li	a4,115
 7ba:	f4e782e3          	beq	a5,a4,6fe <vprintf+0x1e2>
      } else if(c0 == '%'){
 7be:	02500713          	li	a4,37
 7c2:	f6e787e3          	beq	a5,a4,730 <vprintf+0x214>
        putc(fd, '%');
 7c6:	02500593          	li	a1,37
 7ca:	855a                	mv	a0,s6
 7cc:	c8fff0ef          	jal	45a <putc>
        putc(fd, c0);
 7d0:	85a6                	mv	a1,s1
 7d2:	855a                	mv	a0,s6
 7d4:	c87ff0ef          	jal	45a <putc>
      state = 0;
 7d8:	4981                	li	s3,0
 7da:	b359                	j	560 <vprintf+0x44>

00000000000007dc <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 7dc:	715d                	addi	sp,sp,-80
 7de:	ec06                	sd	ra,24(sp)
 7e0:	e822                	sd	s0,16(sp)
 7e2:	1000                	addi	s0,sp,32
 7e4:	e010                	sd	a2,0(s0)
 7e6:	e414                	sd	a3,8(s0)
 7e8:	e818                	sd	a4,16(s0)
 7ea:	ec1c                	sd	a5,24(s0)
 7ec:	03043023          	sd	a6,32(s0)
 7f0:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 7f4:	8622                	mv	a2,s0
 7f6:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 7fa:	d23ff0ef          	jal	51c <vprintf>
}
 7fe:	60e2                	ld	ra,24(sp)
 800:	6442                	ld	s0,16(sp)
 802:	6161                	addi	sp,sp,80
 804:	8082                	ret

0000000000000806 <printf>:

void
printf(const char *fmt, ...)
{
 806:	711d                	addi	sp,sp,-96
 808:	ec06                	sd	ra,24(sp)
 80a:	e822                	sd	s0,16(sp)
 80c:	1000                	addi	s0,sp,32
 80e:	e40c                	sd	a1,8(s0)
 810:	e810                	sd	a2,16(s0)
 812:	ec14                	sd	a3,24(s0)
 814:	f018                	sd	a4,32(s0)
 816:	f41c                	sd	a5,40(s0)
 818:	03043823          	sd	a6,48(s0)
 81c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 820:	00840613          	addi	a2,s0,8
 824:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 828:	85aa                	mv	a1,a0
 82a:	4505                	li	a0,1
 82c:	cf1ff0ef          	jal	51c <vprintf>
}
 830:	60e2                	ld	ra,24(sp)
 832:	6442                	ld	s0,16(sp)
 834:	6125                	addi	sp,sp,96
 836:	8082                	ret

0000000000000838 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 838:	1141                	addi	sp,sp,-16
 83a:	e406                	sd	ra,8(sp)
 83c:	e022                	sd	s0,0(sp)
 83e:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 840:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 844:	00000797          	auipc	a5,0x0
 848:	7bc7b783          	ld	a5,1980(a5) # 1000 <freep>
 84c:	a039                	j	85a <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 84e:	6398                	ld	a4,0(a5)
 850:	00e7e463          	bltu	a5,a4,858 <free+0x20>
 854:	00e6ea63          	bltu	a3,a4,868 <free+0x30>
{
 858:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 85a:	fed7fae3          	bgeu	a5,a3,84e <free+0x16>
 85e:	6398                	ld	a4,0(a5)
 860:	00e6e463          	bltu	a3,a4,868 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 864:	fee7eae3          	bltu	a5,a4,858 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 868:	ff852583          	lw	a1,-8(a0)
 86c:	6390                	ld	a2,0(a5)
 86e:	02059813          	slli	a6,a1,0x20
 872:	01c85713          	srli	a4,a6,0x1c
 876:	9736                	add	a4,a4,a3
 878:	02e60563          	beq	a2,a4,8a2 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 87c:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 880:	4790                	lw	a2,8(a5)
 882:	02061593          	slli	a1,a2,0x20
 886:	01c5d713          	srli	a4,a1,0x1c
 88a:	973e                	add	a4,a4,a5
 88c:	02e68263          	beq	a3,a4,8b0 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 890:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 892:	00000717          	auipc	a4,0x0
 896:	76f73723          	sd	a5,1902(a4) # 1000 <freep>
}
 89a:	60a2                	ld	ra,8(sp)
 89c:	6402                	ld	s0,0(sp)
 89e:	0141                	addi	sp,sp,16
 8a0:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 8a2:	4618                	lw	a4,8(a2)
 8a4:	9f2d                	addw	a4,a4,a1
 8a6:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 8aa:	6398                	ld	a4,0(a5)
 8ac:	6310                	ld	a2,0(a4)
 8ae:	b7f9                	j	87c <free+0x44>
    p->s.size += bp->s.size;
 8b0:	ff852703          	lw	a4,-8(a0)
 8b4:	9f31                	addw	a4,a4,a2
 8b6:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 8b8:	ff053683          	ld	a3,-16(a0)
 8bc:	bfd1                	j	890 <free+0x58>

00000000000008be <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 8be:	7139                	addi	sp,sp,-64
 8c0:	fc06                	sd	ra,56(sp)
 8c2:	f822                	sd	s0,48(sp)
 8c4:	f04a                	sd	s2,32(sp)
 8c6:	ec4e                	sd	s3,24(sp)
 8c8:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 8ca:	02051993          	slli	s3,a0,0x20
 8ce:	0209d993          	srli	s3,s3,0x20
 8d2:	09bd                	addi	s3,s3,15
 8d4:	0049d993          	srli	s3,s3,0x4
 8d8:	2985                	addiw	s3,s3,1
 8da:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 8dc:	00000517          	auipc	a0,0x0
 8e0:	72453503          	ld	a0,1828(a0) # 1000 <freep>
 8e4:	c905                	beqz	a0,914 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 8e6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 8e8:	4798                	lw	a4,8(a5)
 8ea:	09377663          	bgeu	a4,s3,976 <malloc+0xb8>
 8ee:	f426                	sd	s1,40(sp)
 8f0:	e852                	sd	s4,16(sp)
 8f2:	e456                	sd	s5,8(sp)
 8f4:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 8f6:	8a4e                	mv	s4,s3
 8f8:	6705                	lui	a4,0x1
 8fa:	00e9f363          	bgeu	s3,a4,900 <malloc+0x42>
 8fe:	6a05                	lui	s4,0x1
 900:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 904:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 908:	00000497          	auipc	s1,0x0
 90c:	6f848493          	addi	s1,s1,1784 # 1000 <freep>
  if(p == SBRK_ERROR)
 910:	5afd                	li	s5,-1
 912:	a83d                	j	950 <malloc+0x92>
 914:	f426                	sd	s1,40(sp)
 916:	e852                	sd	s4,16(sp)
 918:	e456                	sd	s5,8(sp)
 91a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 91c:	00000797          	auipc	a5,0x0
 920:	6f478793          	addi	a5,a5,1780 # 1010 <base>
 924:	00000717          	auipc	a4,0x0
 928:	6cf73e23          	sd	a5,1756(a4) # 1000 <freep>
 92c:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 92e:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 932:	b7d1                	j	8f6 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 934:	6398                	ld	a4,0(a5)
 936:	e118                	sd	a4,0(a0)
 938:	a899                	j	98e <malloc+0xd0>
  hp->s.size = nu;
 93a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 93e:	0541                	addi	a0,a0,16
 940:	ef9ff0ef          	jal	838 <free>
  return freep;
 944:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 946:	c125                	beqz	a0,9a6 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 948:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 94a:	4798                	lw	a4,8(a5)
 94c:	03277163          	bgeu	a4,s2,96e <malloc+0xb0>
    if(p == freep)
 950:	6098                	ld	a4,0(s1)
 952:	853e                	mv	a0,a5
 954:	fef71ae3          	bne	a4,a5,948 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 958:	8552                	mv	a0,s4
 95a:	a25ff0ef          	jal	37e <sbrk>
  if(p == SBRK_ERROR)
 95e:	fd551ee3          	bne	a0,s5,93a <malloc+0x7c>
        return 0;
 962:	4501                	li	a0,0
 964:	74a2                	ld	s1,40(sp)
 966:	6a42                	ld	s4,16(sp)
 968:	6aa2                	ld	s5,8(sp)
 96a:	6b02                	ld	s6,0(sp)
 96c:	a03d                	j	99a <malloc+0xdc>
 96e:	74a2                	ld	s1,40(sp)
 970:	6a42                	ld	s4,16(sp)
 972:	6aa2                	ld	s5,8(sp)
 974:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 976:	fae90fe3          	beq	s2,a4,934 <malloc+0x76>
        p->s.size -= nunits;
 97a:	4137073b          	subw	a4,a4,s3
 97e:	c798                	sw	a4,8(a5)
        p += p->s.size;
 980:	02071693          	slli	a3,a4,0x20
 984:	01c6d713          	srli	a4,a3,0x1c
 988:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 98a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 98e:	00000717          	auipc	a4,0x0
 992:	66a73923          	sd	a0,1650(a4) # 1000 <freep>
      return (void*)(p + 1);
 996:	01078513          	addi	a0,a5,16
  }
}
 99a:	70e2                	ld	ra,56(sp)
 99c:	7442                	ld	s0,48(sp)
 99e:	7902                	ld	s2,32(sp)
 9a0:	69e2                	ld	s3,24(sp)
 9a2:	6121                	addi	sp,sp,64
 9a4:	8082                	ret
 9a6:	74a2                	ld	s1,40(sp)
 9a8:	6a42                	ld	s4,16(sp)
 9aa:	6aa2                	ld	s5,8(sp)
 9ac:	6b02                	ld	s6,0(sp)
 9ae:	b7f5                	j	99a <malloc+0xdc>
