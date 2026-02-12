
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:
#include "kernel/fs.h"
#include "kernel/fcntl.h"


// Find all the files in a directory tree with a specific name
void find(char *dir, char *name) {
   0:	d8010113          	addi	sp,sp,-640
   4:	26113c23          	sd	ra,632(sp)
   8:	26813823          	sd	s0,624(sp)
   c:	25613023          	sd	s6,576(sp)
  10:	23713c23          	sd	s7,568(sp)
  14:	0500                	addi	s0,sp,640
  16:	8b2a                	mv	s6,a0
  18:	8bae                	mv	s7,a1
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(dir, O_RDONLY)) < 0){
  1a:	4581                	li	a1,0
  1c:	4a8000ef          	jal	4c4 <open>
  20:	0c054a63          	bltz	a0,f4 <find+0xf4>
  24:	26913423          	sd	s1,616(sp)
  28:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", dir);
    return;
  }

  if(fstat(fd, &st) < 0){
  2a:	d8840593          	addi	a1,s0,-632
  2e:	4ae000ef          	jal	4dc <fstat>
  32:	0c054a63          	bltz	a0,106 <find+0x106>
    fprintf(2, "find: cannot stat %s\n", dir);
    close(fd);
    return;
  }

  switch(st.type){
  36:	d9041703          	lh	a4,-624(s0)
  3a:	4785                	li	a5,1
  3c:	14f71763          	bne	a4,a5,18a <find+0x18a>
  40:	27213023          	sd	s2,608(sp)
  44:	25313c23          	sd	s3,600(sp)
  48:	25413823          	sd	s4,592(sp)
    case T_DIR:
      // Read each director entry
      while(read(fd, &de, sizeof(de)) == sizeof(de)){
  4c:	da040993          	addi	s3,s0,-608
  50:	4941                	li	s2,16
        // skip empty slot or "." or ".."
        if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
  52:	da240a13          	addi	s4,s0,-606
      while(read(fd, &de, sizeof(de)) == sizeof(de)){
  56:	864a                	mv	a2,s2
  58:	85ce                	mv	a1,s3
  5a:	8526                	mv	a0,s1
  5c:	440000ef          	jal	49c <read>
  60:	0f251f63          	bne	a0,s2,15e <find+0x15e>
        if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
  64:	da045783          	lhu	a5,-608(s0)
  68:	d7fd                	beqz	a5,56 <find+0x56>
  6a:	00001597          	auipc	a1,0x1
  6e:	a4e58593          	addi	a1,a1,-1458 # ab8 <malloc+0x130>
  72:	8552                	mv	a0,s4
  74:	18a000ef          	jal	1fe <strcmp>
  78:	dd79                	beqz	a0,56 <find+0x56>
  7a:	00001597          	auipc	a1,0x1
  7e:	a4658593          	addi	a1,a1,-1466 # ac0 <malloc+0x138>
  82:	da240513          	addi	a0,s0,-606
  86:	178000ef          	jal	1fe <strcmp>
  8a:	d571                	beqz	a0,56 <find+0x56>
  8c:	25513423          	sd	s5,584(sp)
          continue;
        
        strcpy(buf, dir);
  90:	85da                	mv	a1,s6
  92:	db040513          	addi	a0,s0,-592
  96:	148000ef          	jal	1de <strcpy>
        p = buf+strlen(buf);
  9a:	db040513          	addi	a0,s0,-592
  9e:	190000ef          	jal	22e <strlen>
  a2:	1502                	slli	a0,a0,0x20
  a4:	9101                	srli	a0,a0,0x20
  a6:	db040793          	addi	a5,s0,-592
  aa:	97aa                	add	a5,a5,a0
  ac:	8abe                	mv	s5,a5
        *p++ = '/';
  ae:	02f00793          	li	a5,47
  b2:	00fa8023          	sb	a5,0(s5)
        memmove(p, de.name, DIRSIZ);
  b6:	4639                	li	a2,14
  b8:	da240593          	addi	a1,s0,-606
  bc:	001a8513          	addi	a0,s5,1
  c0:	2e6000ef          	jal	3a6 <memmove>
        p[DIRSIZ] = 0;
  c4:	000a87a3          	sb	zero,15(s5)

        if (stat(buf, &st) < 0) {
  c8:	d8840593          	addi	a1,s0,-632
  cc:	db040513          	addi	a0,s0,-592
  d0:	24e000ef          	jal	31e <stat>
  d4:	04054763          	bltz	a0,122 <find+0x122>
          printf("find: cannot stat %s\n", buf);
          continue;
        }

        // Call find recursively
        if (st.type == T_DIR) {
  d8:	d9041703          	lh	a4,-624(s0)
  dc:	4785                	li	a5,1
  de:	04f70d63          	beq	a4,a5,138 <find+0x138>
          find(buf, name);
        } else if (strcmp(de.name, name) == 0) {
  e2:	85de                	mv	a1,s7
  e4:	da240513          	addi	a0,s0,-606
  e8:	116000ef          	jal	1fe <strcmp>
  ec:	cd31                	beqz	a0,148 <find+0x148>
  ee:	24813a83          	ld	s5,584(sp)
  f2:	b795                	j	56 <find+0x56>
    fprintf(2, "find: cannot open %s\n", dir);
  f4:	865a                	mv	a2,s6
  f6:	00001597          	auipc	a1,0x1
  fa:	98a58593          	addi	a1,a1,-1654 # a80 <malloc+0xf8>
  fe:	4509                	li	a0,2
 100:	7a6000ef          	jal	8a6 <fprintf>
    return;
 104:	a885                	j	174 <find+0x174>
    fprintf(2, "find: cannot stat %s\n", dir);
 106:	865a                	mv	a2,s6
 108:	00001597          	auipc	a1,0x1
 10c:	99858593          	addi	a1,a1,-1640 # aa0 <malloc+0x118>
 110:	4509                	li	a0,2
 112:	794000ef          	jal	8a6 <fprintf>
    close(fd);
 116:	8526                	mv	a0,s1
 118:	394000ef          	jal	4ac <close>
    return;
 11c:	26813483          	ld	s1,616(sp)
 120:	a891                	j	174 <find+0x174>
          printf("find: cannot stat %s\n", buf);
 122:	db040593          	addi	a1,s0,-592
 126:	00001517          	auipc	a0,0x1
 12a:	97a50513          	addi	a0,a0,-1670 # aa0 <malloc+0x118>
 12e:	7a2000ef          	jal	8d0 <printf>
          continue;
 132:	24813a83          	ld	s5,584(sp)
 136:	b705                	j	56 <find+0x56>
          find(buf, name);
 138:	85de                	mv	a1,s7
 13a:	db040513          	addi	a0,s0,-592
 13e:	ec3ff0ef          	jal	0 <find>
 142:	24813a83          	ld	s5,584(sp)
 146:	bf01                	j	56 <find+0x56>
          printf("%s\n", buf);
 148:	db040593          	addi	a1,s0,-592
 14c:	00001517          	auipc	a0,0x1
 150:	97c50513          	addi	a0,a0,-1668 # ac8 <malloc+0x140>
 154:	77c000ef          	jal	8d0 <printf>
 158:	24813a83          	ld	s5,584(sp)
 15c:	bded                	j	56 <find+0x56>
 15e:	26013903          	ld	s2,608(sp)
 162:	25813983          	ld	s3,600(sp)
 166:	25013a03          	ld	s4,592(sp)
      break;
    default:
      fprintf(2, "find: invalid argument - %s is not directory\n", dir);
  }

  close(fd);
 16a:	8526                	mv	a0,s1
 16c:	340000ef          	jal	4ac <close>
 170:	26813483          	ld	s1,616(sp)
}
 174:	27813083          	ld	ra,632(sp)
 178:	27013403          	ld	s0,624(sp)
 17c:	24013b03          	ld	s6,576(sp)
 180:	23813b83          	ld	s7,568(sp)
 184:	28010113          	addi	sp,sp,640
 188:	8082                	ret
      fprintf(2, "find: invalid argument - %s is not directory\n", dir);
 18a:	865a                	mv	a2,s6
 18c:	00001597          	auipc	a1,0x1
 190:	94458593          	addi	a1,a1,-1724 # ad0 <malloc+0x148>
 194:	4509                	li	a0,2
 196:	710000ef          	jal	8a6 <fprintf>
 19a:	bfc1                	j	16a <find+0x16a>

000000000000019c <main>:

int
main(int argc, char *argv[])
{
 19c:	1141                	addi	sp,sp,-16
 19e:	e406                	sd	ra,8(sp)
 1a0:	e022                	sd	s0,0(sp)
 1a2:	0800                	addi	s0,sp,16
  if(argc != 3){
 1a4:	470d                	li	a4,3
 1a6:	00e50b63          	beq	a0,a4,1bc <main+0x20>
    printf("Usage: find <directory> <name>\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	95650513          	addi	a0,a0,-1706 # b00 <malloc+0x178>
 1b2:	71e000ef          	jal	8d0 <printf>
    exit(1);
 1b6:	4505                	li	a0,1
 1b8:	2cc000ef          	jal	484 <exit>
 1bc:	87ae                	mv	a5,a1
  }

  find(argv[1], argv[2]);
 1be:	698c                	ld	a1,16(a1)
 1c0:	6788                	ld	a0,8(a5)
 1c2:	e3fff0ef          	jal	0 <find>

  exit(0);
 1c6:	4501                	li	a0,0
 1c8:	2bc000ef          	jal	484 <exit>

00000000000001cc <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 1cc:	1141                	addi	sp,sp,-16
 1ce:	e406                	sd	ra,8(sp)
 1d0:	e022                	sd	s0,0(sp)
 1d2:	0800                	addi	s0,sp,16
  extern int main();
  main();
 1d4:	fc9ff0ef          	jal	19c <main>
  exit(0);
 1d8:	4501                	li	a0,0
 1da:	2aa000ef          	jal	484 <exit>

00000000000001de <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 1de:	1141                	addi	sp,sp,-16
 1e0:	e406                	sd	ra,8(sp)
 1e2:	e022                	sd	s0,0(sp)
 1e4:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 1e6:	87aa                	mv	a5,a0
 1e8:	0585                	addi	a1,a1,1
 1ea:	0785                	addi	a5,a5,1
 1ec:	fff5c703          	lbu	a4,-1(a1)
 1f0:	fee78fa3          	sb	a4,-1(a5)
 1f4:	fb75                	bnez	a4,1e8 <strcpy+0xa>
    ;
  return os;
}
 1f6:	60a2                	ld	ra,8(sp)
 1f8:	6402                	ld	s0,0(sp)
 1fa:	0141                	addi	sp,sp,16
 1fc:	8082                	ret

00000000000001fe <strcmp>:

int
strcmp(const char *p, const char *q)
{
 1fe:	1141                	addi	sp,sp,-16
 200:	e406                	sd	ra,8(sp)
 202:	e022                	sd	s0,0(sp)
 204:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 206:	00054783          	lbu	a5,0(a0)
 20a:	cb91                	beqz	a5,21e <strcmp+0x20>
 20c:	0005c703          	lbu	a4,0(a1)
 210:	00f71763          	bne	a4,a5,21e <strcmp+0x20>
    p++, q++;
 214:	0505                	addi	a0,a0,1
 216:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 218:	00054783          	lbu	a5,0(a0)
 21c:	fbe5                	bnez	a5,20c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 21e:	0005c503          	lbu	a0,0(a1)
}
 222:	40a7853b          	subw	a0,a5,a0
 226:	60a2                	ld	ra,8(sp)
 228:	6402                	ld	s0,0(sp)
 22a:	0141                	addi	sp,sp,16
 22c:	8082                	ret

000000000000022e <strlen>:

uint
strlen(const char *s)
{
 22e:	1141                	addi	sp,sp,-16
 230:	e406                	sd	ra,8(sp)
 232:	e022                	sd	s0,0(sp)
 234:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 236:	00054783          	lbu	a5,0(a0)
 23a:	cf91                	beqz	a5,256 <strlen+0x28>
 23c:	00150793          	addi	a5,a0,1
 240:	86be                	mv	a3,a5
 242:	0785                	addi	a5,a5,1
 244:	fff7c703          	lbu	a4,-1(a5)
 248:	ff65                	bnez	a4,240 <strlen+0x12>
 24a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 24e:	60a2                	ld	ra,8(sp)
 250:	6402                	ld	s0,0(sp)
 252:	0141                	addi	sp,sp,16
 254:	8082                	ret
  for(n = 0; s[n]; n++)
 256:	4501                	li	a0,0
 258:	bfdd                	j	24e <strlen+0x20>

000000000000025a <memset>:

void*
memset(void *dst, int c, uint n)
{
 25a:	1141                	addi	sp,sp,-16
 25c:	e406                	sd	ra,8(sp)
 25e:	e022                	sd	s0,0(sp)
 260:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 262:	ca19                	beqz	a2,278 <memset+0x1e>
 264:	87aa                	mv	a5,a0
 266:	1602                	slli	a2,a2,0x20
 268:	9201                	srli	a2,a2,0x20
 26a:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 26e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 272:	0785                	addi	a5,a5,1
 274:	fee79de3          	bne	a5,a4,26e <memset+0x14>
  }
  return dst;
}
 278:	60a2                	ld	ra,8(sp)
 27a:	6402                	ld	s0,0(sp)
 27c:	0141                	addi	sp,sp,16
 27e:	8082                	ret

0000000000000280 <strchr>:

char*
strchr(const char *s, char c)
{
 280:	1141                	addi	sp,sp,-16
 282:	e406                	sd	ra,8(sp)
 284:	e022                	sd	s0,0(sp)
 286:	0800                	addi	s0,sp,16
  for(; *s; s++)
 288:	00054783          	lbu	a5,0(a0)
 28c:	cf81                	beqz	a5,2a4 <strchr+0x24>
    if(*s == c)
 28e:	00f58763          	beq	a1,a5,29c <strchr+0x1c>
  for(; *s; s++)
 292:	0505                	addi	a0,a0,1
 294:	00054783          	lbu	a5,0(a0)
 298:	fbfd                	bnez	a5,28e <strchr+0xe>
      return (char*)s;
  return 0;
 29a:	4501                	li	a0,0
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  return 0;
 2a4:	4501                	li	a0,0
 2a6:	bfdd                	j	29c <strchr+0x1c>

00000000000002a8 <gets>:

char*
gets(char *buf, int max)
{
 2a8:	711d                	addi	sp,sp,-96
 2aa:	ec86                	sd	ra,88(sp)
 2ac:	e8a2                	sd	s0,80(sp)
 2ae:	e4a6                	sd	s1,72(sp)
 2b0:	e0ca                	sd	s2,64(sp)
 2b2:	fc4e                	sd	s3,56(sp)
 2b4:	f852                	sd	s4,48(sp)
 2b6:	f456                	sd	s5,40(sp)
 2b8:	f05a                	sd	s6,32(sp)
 2ba:	ec5e                	sd	s7,24(sp)
 2bc:	e862                	sd	s8,16(sp)
 2be:	1080                	addi	s0,sp,96
 2c0:	8baa                	mv	s7,a0
 2c2:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 2c4:	892a                	mv	s2,a0
 2c6:	4481                	li	s1,0
    cc = read(0, &c, 1);
 2c8:	faf40b13          	addi	s6,s0,-81
 2cc:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 2ce:	8c26                	mv	s8,s1
 2d0:	0014899b          	addiw	s3,s1,1
 2d4:	84ce                	mv	s1,s3
 2d6:	0349d463          	bge	s3,s4,2fe <gets+0x56>
    cc = read(0, &c, 1);
 2da:	8656                	mv	a2,s5
 2dc:	85da                	mv	a1,s6
 2de:	4501                	li	a0,0
 2e0:	1bc000ef          	jal	49c <read>
    if(cc < 1)
 2e4:	00a05d63          	blez	a0,2fe <gets+0x56>
      break;
    buf[i++] = c;
 2e8:	faf44783          	lbu	a5,-81(s0)
 2ec:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 2f0:	0905                	addi	s2,s2,1
 2f2:	ff678713          	addi	a4,a5,-10
 2f6:	c319                	beqz	a4,2fc <gets+0x54>
 2f8:	17cd                	addi	a5,a5,-13
 2fa:	fbf1                	bnez	a5,2ce <gets+0x26>
    buf[i++] = c;
 2fc:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 2fe:	9c5e                	add	s8,s8,s7
 300:	000c0023          	sb	zero,0(s8)
  return buf;
}
 304:	855e                	mv	a0,s7
 306:	60e6                	ld	ra,88(sp)
 308:	6446                	ld	s0,80(sp)
 30a:	64a6                	ld	s1,72(sp)
 30c:	6906                	ld	s2,64(sp)
 30e:	79e2                	ld	s3,56(sp)
 310:	7a42                	ld	s4,48(sp)
 312:	7aa2                	ld	s5,40(sp)
 314:	7b02                	ld	s6,32(sp)
 316:	6be2                	ld	s7,24(sp)
 318:	6c42                	ld	s8,16(sp)
 31a:	6125                	addi	sp,sp,96
 31c:	8082                	ret

000000000000031e <stat>:

int
stat(const char *n, struct stat *st)
{
 31e:	1101                	addi	sp,sp,-32
 320:	ec06                	sd	ra,24(sp)
 322:	e822                	sd	s0,16(sp)
 324:	e04a                	sd	s2,0(sp)
 326:	1000                	addi	s0,sp,32
 328:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 32a:	4581                	li	a1,0
 32c:	198000ef          	jal	4c4 <open>
  if(fd < 0)
 330:	02054263          	bltz	a0,354 <stat+0x36>
 334:	e426                	sd	s1,8(sp)
 336:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 338:	85ca                	mv	a1,s2
 33a:	1a2000ef          	jal	4dc <fstat>
 33e:	892a                	mv	s2,a0
  close(fd);
 340:	8526                	mv	a0,s1
 342:	16a000ef          	jal	4ac <close>
  return r;
 346:	64a2                	ld	s1,8(sp)
}
 348:	854a                	mv	a0,s2
 34a:	60e2                	ld	ra,24(sp)
 34c:	6442                	ld	s0,16(sp)
 34e:	6902                	ld	s2,0(sp)
 350:	6105                	addi	sp,sp,32
 352:	8082                	ret
    return -1;
 354:	57fd                	li	a5,-1
 356:	893e                	mv	s2,a5
 358:	bfc5                	j	348 <stat+0x2a>

000000000000035a <atoi>:

int
atoi(const char *s)
{
 35a:	1141                	addi	sp,sp,-16
 35c:	e406                	sd	ra,8(sp)
 35e:	e022                	sd	s0,0(sp)
 360:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 362:	00054683          	lbu	a3,0(a0)
 366:	fd06879b          	addiw	a5,a3,-48
 36a:	0ff7f793          	zext.b	a5,a5
 36e:	4625                	li	a2,9
 370:	02f66963          	bltu	a2,a5,3a2 <atoi+0x48>
 374:	872a                	mv	a4,a0
  n = 0;
 376:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 378:	0705                	addi	a4,a4,1
 37a:	0025179b          	slliw	a5,a0,0x2
 37e:	9fa9                	addw	a5,a5,a0
 380:	0017979b          	slliw	a5,a5,0x1
 384:	9fb5                	addw	a5,a5,a3
 386:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 38a:	00074683          	lbu	a3,0(a4)
 38e:	fd06879b          	addiw	a5,a3,-48
 392:	0ff7f793          	zext.b	a5,a5
 396:	fef671e3          	bgeu	a2,a5,378 <atoi+0x1e>
  return n;
}
 39a:	60a2                	ld	ra,8(sp)
 39c:	6402                	ld	s0,0(sp)
 39e:	0141                	addi	sp,sp,16
 3a0:	8082                	ret
  n = 0;
 3a2:	4501                	li	a0,0
 3a4:	bfdd                	j	39a <atoi+0x40>

00000000000003a6 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3a6:	1141                	addi	sp,sp,-16
 3a8:	e406                	sd	ra,8(sp)
 3aa:	e022                	sd	s0,0(sp)
 3ac:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3ae:	02b57563          	bgeu	a0,a1,3d8 <memmove+0x32>
    while(n-- > 0)
 3b2:	00c05f63          	blez	a2,3d0 <memmove+0x2a>
 3b6:	1602                	slli	a2,a2,0x20
 3b8:	9201                	srli	a2,a2,0x20
 3ba:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 3be:	872a                	mv	a4,a0
      *dst++ = *src++;
 3c0:	0585                	addi	a1,a1,1
 3c2:	0705                	addi	a4,a4,1
 3c4:	fff5c683          	lbu	a3,-1(a1)
 3c8:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 3cc:	fee79ae3          	bne	a5,a4,3c0 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 3d0:	60a2                	ld	ra,8(sp)
 3d2:	6402                	ld	s0,0(sp)
 3d4:	0141                	addi	sp,sp,16
 3d6:	8082                	ret
    while(n-- > 0)
 3d8:	fec05ce3          	blez	a2,3d0 <memmove+0x2a>
    dst += n;
 3dc:	00c50733          	add	a4,a0,a2
    src += n;
 3e0:	95b2                	add	a1,a1,a2
 3e2:	fff6079b          	addiw	a5,a2,-1
 3e6:	1782                	slli	a5,a5,0x20
 3e8:	9381                	srli	a5,a5,0x20
 3ea:	fff7c793          	not	a5,a5
 3ee:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 3f0:	15fd                	addi	a1,a1,-1
 3f2:	177d                	addi	a4,a4,-1
 3f4:	0005c683          	lbu	a3,0(a1)
 3f8:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 3fc:	fef71ae3          	bne	a4,a5,3f0 <memmove+0x4a>
 400:	bfc1                	j	3d0 <memmove+0x2a>

0000000000000402 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 402:	1141                	addi	sp,sp,-16
 404:	e406                	sd	ra,8(sp)
 406:	e022                	sd	s0,0(sp)
 408:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 40a:	c61d                	beqz	a2,438 <memcmp+0x36>
 40c:	1602                	slli	a2,a2,0x20
 40e:	9201                	srli	a2,a2,0x20
 410:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 414:	00054783          	lbu	a5,0(a0)
 418:	0005c703          	lbu	a4,0(a1)
 41c:	00e79863          	bne	a5,a4,42c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 420:	0505                	addi	a0,a0,1
    p2++;
 422:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 424:	fed518e3          	bne	a0,a3,414 <memcmp+0x12>
  }
  return 0;
 428:	4501                	li	a0,0
 42a:	a019                	j	430 <memcmp+0x2e>
      return *p1 - *p2;
 42c:	40e7853b          	subw	a0,a5,a4
}
 430:	60a2                	ld	ra,8(sp)
 432:	6402                	ld	s0,0(sp)
 434:	0141                	addi	sp,sp,16
 436:	8082                	ret
  return 0;
 438:	4501                	li	a0,0
 43a:	bfdd                	j	430 <memcmp+0x2e>

000000000000043c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 43c:	1141                	addi	sp,sp,-16
 43e:	e406                	sd	ra,8(sp)
 440:	e022                	sd	s0,0(sp)
 442:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 444:	f63ff0ef          	jal	3a6 <memmove>
}
 448:	60a2                	ld	ra,8(sp)
 44a:	6402                	ld	s0,0(sp)
 44c:	0141                	addi	sp,sp,16
 44e:	8082                	ret

0000000000000450 <sbrk>:

char *
sbrk(int n) {
 450:	1141                	addi	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 458:	4585                	li	a1,1
 45a:	0b2000ef          	jal	50c <sys_sbrk>
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret

0000000000000466 <sbrklazy>:

char *
sbrklazy(int n) {
 466:	1141                	addi	sp,sp,-16
 468:	e406                	sd	ra,8(sp)
 46a:	e022                	sd	s0,0(sp)
 46c:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 46e:	4589                	li	a1,2
 470:	09c000ef          	jal	50c <sys_sbrk>
}
 474:	60a2                	ld	ra,8(sp)
 476:	6402                	ld	s0,0(sp)
 478:	0141                	addi	sp,sp,16
 47a:	8082                	ret

000000000000047c <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 47c:	4885                	li	a7,1
 ecall
 47e:	00000073          	ecall
 ret
 482:	8082                	ret

0000000000000484 <exit>:
.global exit
exit:
 li a7, SYS_exit
 484:	4889                	li	a7,2
 ecall
 486:	00000073          	ecall
 ret
 48a:	8082                	ret

000000000000048c <wait>:
.global wait
wait:
 li a7, SYS_wait
 48c:	488d                	li	a7,3
 ecall
 48e:	00000073          	ecall
 ret
 492:	8082                	ret

0000000000000494 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 494:	4891                	li	a7,4
 ecall
 496:	00000073          	ecall
 ret
 49a:	8082                	ret

000000000000049c <read>:
.global read
read:
 li a7, SYS_read
 49c:	4895                	li	a7,5
 ecall
 49e:	00000073          	ecall
 ret
 4a2:	8082                	ret

00000000000004a4 <write>:
.global write
write:
 li a7, SYS_write
 4a4:	48c1                	li	a7,16
 ecall
 4a6:	00000073          	ecall
 ret
 4aa:	8082                	ret

00000000000004ac <close>:
.global close
close:
 li a7, SYS_close
 4ac:	48d5                	li	a7,21
 ecall
 4ae:	00000073          	ecall
 ret
 4b2:	8082                	ret

00000000000004b4 <kill>:
.global kill
kill:
 li a7, SYS_kill
 4b4:	4899                	li	a7,6
 ecall
 4b6:	00000073          	ecall
 ret
 4ba:	8082                	ret

00000000000004bc <exec>:
.global exec
exec:
 li a7, SYS_exec
 4bc:	489d                	li	a7,7
 ecall
 4be:	00000073          	ecall
 ret
 4c2:	8082                	ret

00000000000004c4 <open>:
.global open
open:
 li a7, SYS_open
 4c4:	48bd                	li	a7,15
 ecall
 4c6:	00000073          	ecall
 ret
 4ca:	8082                	ret

00000000000004cc <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 4cc:	48c5                	li	a7,17
 ecall
 4ce:	00000073          	ecall
 ret
 4d2:	8082                	ret

00000000000004d4 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 4d4:	48c9                	li	a7,18
 ecall
 4d6:	00000073          	ecall
 ret
 4da:	8082                	ret

00000000000004dc <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 4dc:	48a1                	li	a7,8
 ecall
 4de:	00000073          	ecall
 ret
 4e2:	8082                	ret

00000000000004e4 <link>:
.global link
link:
 li a7, SYS_link
 4e4:	48cd                	li	a7,19
 ecall
 4e6:	00000073          	ecall
 ret
 4ea:	8082                	ret

00000000000004ec <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 4ec:	48d1                	li	a7,20
 ecall
 4ee:	00000073          	ecall
 ret
 4f2:	8082                	ret

00000000000004f4 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 4f4:	48a5                	li	a7,9
 ecall
 4f6:	00000073          	ecall
 ret
 4fa:	8082                	ret

00000000000004fc <dup>:
.global dup
dup:
 li a7, SYS_dup
 4fc:	48a9                	li	a7,10
 ecall
 4fe:	00000073          	ecall
 ret
 502:	8082                	ret

0000000000000504 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 504:	48ad                	li	a7,11
 ecall
 506:	00000073          	ecall
 ret
 50a:	8082                	ret

000000000000050c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 50c:	48b1                	li	a7,12
 ecall
 50e:	00000073          	ecall
 ret
 512:	8082                	ret

0000000000000514 <pause>:
.global pause
pause:
 li a7, SYS_pause
 514:	48b5                	li	a7,13
 ecall
 516:	00000073          	ecall
 ret
 51a:	8082                	ret

000000000000051c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 51c:	48b9                	li	a7,14
 ecall
 51e:	00000073          	ecall
 ret
 522:	8082                	ret

0000000000000524 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 524:	1101                	addi	sp,sp,-32
 526:	ec06                	sd	ra,24(sp)
 528:	e822                	sd	s0,16(sp)
 52a:	1000                	addi	s0,sp,32
 52c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 530:	4605                	li	a2,1
 532:	fef40593          	addi	a1,s0,-17
 536:	f6fff0ef          	jal	4a4 <write>
}
 53a:	60e2                	ld	ra,24(sp)
 53c:	6442                	ld	s0,16(sp)
 53e:	6105                	addi	sp,sp,32
 540:	8082                	ret

0000000000000542 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 542:	715d                	addi	sp,sp,-80
 544:	e486                	sd	ra,72(sp)
 546:	e0a2                	sd	s0,64(sp)
 548:	f84a                	sd	s2,48(sp)
 54a:	f44e                	sd	s3,40(sp)
 54c:	0880                	addi	s0,sp,80
 54e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 550:	cac1                	beqz	a3,5e0 <printint+0x9e>
 552:	0805d763          	bgez	a1,5e0 <printint+0x9e>
    neg = 1;
    x = -xx;
 556:	40b005bb          	negw	a1,a1
    neg = 1;
 55a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 55c:	fb840993          	addi	s3,s0,-72
  neg = 0;
 560:	86ce                	mv	a3,s3
  i = 0;
 562:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 564:	00000817          	auipc	a6,0x0
 568:	5c480813          	addi	a6,a6,1476 # b28 <digits>
 56c:	88ba                	mv	a7,a4
 56e:	0017051b          	addiw	a0,a4,1
 572:	872a                	mv	a4,a0
 574:	02c5f7bb          	remuw	a5,a1,a2
 578:	1782                	slli	a5,a5,0x20
 57a:	9381                	srli	a5,a5,0x20
 57c:	97c2                	add	a5,a5,a6
 57e:	0007c783          	lbu	a5,0(a5)
 582:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 586:	87ae                	mv	a5,a1
 588:	02c5d5bb          	divuw	a1,a1,a2
 58c:	0685                	addi	a3,a3,1
 58e:	fcc7ffe3          	bgeu	a5,a2,56c <printint+0x2a>
  if(neg)
 592:	00030c63          	beqz	t1,5aa <printint+0x68>
    buf[i++] = '-';
 596:	fd050793          	addi	a5,a0,-48
 59a:	00878533          	add	a0,a5,s0
 59e:	02d00793          	li	a5,45
 5a2:	fef50423          	sb	a5,-24(a0)
 5a6:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 5aa:	02e05563          	blez	a4,5d4 <printint+0x92>
 5ae:	fc26                	sd	s1,56(sp)
 5b0:	377d                	addiw	a4,a4,-1
 5b2:	00e984b3          	add	s1,s3,a4
 5b6:	19fd                	addi	s3,s3,-1
 5b8:	99ba                	add	s3,s3,a4
 5ba:	1702                	slli	a4,a4,0x20
 5bc:	9301                	srli	a4,a4,0x20
 5be:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 5c2:	0004c583          	lbu	a1,0(s1)
 5c6:	854a                	mv	a0,s2
 5c8:	f5dff0ef          	jal	524 <putc>
  while(--i >= 0)
 5cc:	14fd                	addi	s1,s1,-1
 5ce:	ff349ae3          	bne	s1,s3,5c2 <printint+0x80>
 5d2:	74e2                	ld	s1,56(sp)
}
 5d4:	60a6                	ld	ra,72(sp)
 5d6:	6406                	ld	s0,64(sp)
 5d8:	7942                	ld	s2,48(sp)
 5da:	79a2                	ld	s3,40(sp)
 5dc:	6161                	addi	sp,sp,80
 5de:	8082                	ret
    x = xx;
 5e0:	2581                	sext.w	a1,a1
  neg = 0;
 5e2:	4301                	li	t1,0
 5e4:	bfa5                	j	55c <printint+0x1a>

00000000000005e6 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 5e6:	711d                	addi	sp,sp,-96
 5e8:	ec86                	sd	ra,88(sp)
 5ea:	e8a2                	sd	s0,80(sp)
 5ec:	e4a6                	sd	s1,72(sp)
 5ee:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 5f0:	0005c483          	lbu	s1,0(a1)
 5f4:	22048363          	beqz	s1,81a <vprintf+0x234>
 5f8:	e0ca                	sd	s2,64(sp)
 5fa:	fc4e                	sd	s3,56(sp)
 5fc:	f852                	sd	s4,48(sp)
 5fe:	f456                	sd	s5,40(sp)
 600:	f05a                	sd	s6,32(sp)
 602:	ec5e                	sd	s7,24(sp)
 604:	e862                	sd	s8,16(sp)
 606:	8b2a                	mv	s6,a0
 608:	8a2e                	mv	s4,a1
 60a:	8bb2                	mv	s7,a2
  state = 0;
 60c:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 60e:	4901                	li	s2,0
 610:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 612:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 616:	06400c13          	li	s8,100
 61a:	a00d                	j	63c <vprintf+0x56>
        putc(fd, c0);
 61c:	85a6                	mv	a1,s1
 61e:	855a                	mv	a0,s6
 620:	f05ff0ef          	jal	524 <putc>
 624:	a019                	j	62a <vprintf+0x44>
    } else if(state == '%'){
 626:	03598363          	beq	s3,s5,64c <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 62a:	0019079b          	addiw	a5,s2,1
 62e:	893e                	mv	s2,a5
 630:	873e                	mv	a4,a5
 632:	97d2                	add	a5,a5,s4
 634:	0007c483          	lbu	s1,0(a5)
 638:	1c048a63          	beqz	s1,80c <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 63c:	0004879b          	sext.w	a5,s1
    if(state == 0){
 640:	fe0993e3          	bnez	s3,626 <vprintf+0x40>
      if(c0 == '%'){
 644:	fd579ce3          	bne	a5,s5,61c <vprintf+0x36>
        state = '%';
 648:	89be                	mv	s3,a5
 64a:	b7c5                	j	62a <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 64c:	00ea06b3          	add	a3,s4,a4
 650:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 654:	1c060863          	beqz	a2,824 <vprintf+0x23e>
      if(c0 == 'd'){
 658:	03878763          	beq	a5,s8,686 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 65c:	f9478693          	addi	a3,a5,-108
 660:	0016b693          	seqz	a3,a3
 664:	f9c60593          	addi	a1,a2,-100
 668:	e99d                	bnez	a1,69e <vprintf+0xb8>
 66a:	ca95                	beqz	a3,69e <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 66c:	008b8493          	addi	s1,s7,8
 670:	4685                	li	a3,1
 672:	4629                	li	a2,10
 674:	000bb583          	ld	a1,0(s7)
 678:	855a                	mv	a0,s6
 67a:	ec9ff0ef          	jal	542 <printint>
        i += 1;
 67e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 680:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 682:	4981                	li	s3,0
 684:	b75d                	j	62a <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 686:	008b8493          	addi	s1,s7,8
 68a:	4685                	li	a3,1
 68c:	4629                	li	a2,10
 68e:	000ba583          	lw	a1,0(s7)
 692:	855a                	mv	a0,s6
 694:	eafff0ef          	jal	542 <printint>
 698:	8ba6                	mv	s7,s1
      state = 0;
 69a:	4981                	li	s3,0
 69c:	b779                	j	62a <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 69e:	9752                	add	a4,a4,s4
 6a0:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6a4:	f9460713          	addi	a4,a2,-108
 6a8:	00173713          	seqz	a4,a4
 6ac:	8f75                	and	a4,a4,a3
 6ae:	f9c58513          	addi	a0,a1,-100
 6b2:	18051363          	bnez	a0,838 <vprintf+0x252>
 6b6:	18070163          	beqz	a4,838 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ba:	008b8493          	addi	s1,s7,8
 6be:	4685                	li	a3,1
 6c0:	4629                	li	a2,10
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	e7bff0ef          	jal	542 <printint>
        i += 2;
 6cc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ce:	8ba6                	mv	s7,s1
      state = 0;
 6d0:	4981                	li	s3,0
        i += 2;
 6d2:	bfa1                	j	62a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	4681                	li	a3,0
 6da:	4629                	li	a2,10
 6dc:	000be583          	lwu	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	e61ff0ef          	jal	542 <printint>
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b781                	j	62a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 6ec:	008b8493          	addi	s1,s7,8
 6f0:	4681                	li	a3,0
 6f2:	4629                	li	a2,10
 6f4:	000bb583          	ld	a1,0(s7)
 6f8:	855a                	mv	a0,s6
 6fa:	e49ff0ef          	jal	542 <printint>
        i += 1;
 6fe:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 700:	8ba6                	mv	s7,s1
      state = 0;
 702:	4981                	li	s3,0
 704:	b71d                	j	62a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 706:	008b8493          	addi	s1,s7,8
 70a:	4681                	li	a3,0
 70c:	4629                	li	a2,10
 70e:	000bb583          	ld	a1,0(s7)
 712:	855a                	mv	a0,s6
 714:	e2fff0ef          	jal	542 <printint>
        i += 2;
 718:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 71a:	8ba6                	mv	s7,s1
      state = 0;
 71c:	4981                	li	s3,0
        i += 2;
 71e:	b731                	j	62a <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 720:	008b8493          	addi	s1,s7,8
 724:	4681                	li	a3,0
 726:	4641                	li	a2,16
 728:	000be583          	lwu	a1,0(s7)
 72c:	855a                	mv	a0,s6
 72e:	e15ff0ef          	jal	542 <printint>
 732:	8ba6                	mv	s7,s1
      state = 0;
 734:	4981                	li	s3,0
 736:	bdd5                	j	62a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 738:	008b8493          	addi	s1,s7,8
 73c:	4681                	li	a3,0
 73e:	4641                	li	a2,16
 740:	000bb583          	ld	a1,0(s7)
 744:	855a                	mv	a0,s6
 746:	dfdff0ef          	jal	542 <printint>
        i += 1;
 74a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 74c:	8ba6                	mv	s7,s1
      state = 0;
 74e:	4981                	li	s3,0
 750:	bde9                	j	62a <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 752:	008b8493          	addi	s1,s7,8
 756:	4681                	li	a3,0
 758:	4641                	li	a2,16
 75a:	000bb583          	ld	a1,0(s7)
 75e:	855a                	mv	a0,s6
 760:	de3ff0ef          	jal	542 <printint>
        i += 2;
 764:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 766:	8ba6                	mv	s7,s1
      state = 0;
 768:	4981                	li	s3,0
        i += 2;
 76a:	b5c1                	j	62a <vprintf+0x44>
 76c:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 76e:	008b8793          	addi	a5,s7,8
 772:	8cbe                	mv	s9,a5
 774:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 778:	03000593          	li	a1,48
 77c:	855a                	mv	a0,s6
 77e:	da7ff0ef          	jal	524 <putc>
  putc(fd, 'x');
 782:	07800593          	li	a1,120
 786:	855a                	mv	a0,s6
 788:	d9dff0ef          	jal	524 <putc>
 78c:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 78e:	00000b97          	auipc	s7,0x0
 792:	39ab8b93          	addi	s7,s7,922 # b28 <digits>
 796:	03c9d793          	srli	a5,s3,0x3c
 79a:	97de                	add	a5,a5,s7
 79c:	0007c583          	lbu	a1,0(a5)
 7a0:	855a                	mv	a0,s6
 7a2:	d83ff0ef          	jal	524 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7a6:	0992                	slli	s3,s3,0x4
 7a8:	34fd                	addiw	s1,s1,-1
 7aa:	f4f5                	bnez	s1,796 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 7ac:	8be6                	mv	s7,s9
      state = 0;
 7ae:	4981                	li	s3,0
 7b0:	6ca2                	ld	s9,8(sp)
 7b2:	bda5                	j	62a <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 7b4:	008b8493          	addi	s1,s7,8
 7b8:	000bc583          	lbu	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	d67ff0ef          	jal	524 <putc>
 7c2:	8ba6                	mv	s7,s1
      state = 0;
 7c4:	4981                	li	s3,0
 7c6:	b595                	j	62a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 7c8:	008b8993          	addi	s3,s7,8
 7cc:	000bb483          	ld	s1,0(s7)
 7d0:	cc91                	beqz	s1,7ec <vprintf+0x206>
        for(; *s; s++)
 7d2:	0004c583          	lbu	a1,0(s1)
 7d6:	c985                	beqz	a1,806 <vprintf+0x220>
          putc(fd, *s);
 7d8:	855a                	mv	a0,s6
 7da:	d4bff0ef          	jal	524 <putc>
        for(; *s; s++)
 7de:	0485                	addi	s1,s1,1
 7e0:	0004c583          	lbu	a1,0(s1)
 7e4:	f9f5                	bnez	a1,7d8 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 7e6:	8bce                	mv	s7,s3
      state = 0;
 7e8:	4981                	li	s3,0
 7ea:	b581                	j	62a <vprintf+0x44>
          s = "(null)";
 7ec:	00000497          	auipc	s1,0x0
 7f0:	33448493          	addi	s1,s1,820 # b20 <malloc+0x198>
        for(; *s; s++)
 7f4:	02800593          	li	a1,40
 7f8:	b7c5                	j	7d8 <vprintf+0x1f2>
        putc(fd, '%');
 7fa:	85be                	mv	a1,a5
 7fc:	855a                	mv	a0,s6
 7fe:	d27ff0ef          	jal	524 <putc>
      state = 0;
 802:	4981                	li	s3,0
 804:	b51d                	j	62a <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 806:	8bce                	mv	s7,s3
      state = 0;
 808:	4981                	li	s3,0
 80a:	b505                	j	62a <vprintf+0x44>
 80c:	6906                	ld	s2,64(sp)
 80e:	79e2                	ld	s3,56(sp)
 810:	7a42                	ld	s4,48(sp)
 812:	7aa2                	ld	s5,40(sp)
 814:	7b02                	ld	s6,32(sp)
 816:	6be2                	ld	s7,24(sp)
 818:	6c42                	ld	s8,16(sp)
    }
  }
}
 81a:	60e6                	ld	ra,88(sp)
 81c:	6446                	ld	s0,80(sp)
 81e:	64a6                	ld	s1,72(sp)
 820:	6125                	addi	sp,sp,96
 822:	8082                	ret
      if(c0 == 'd'){
 824:	06400713          	li	a4,100
 828:	e4e78fe3          	beq	a5,a4,686 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 82c:	f9478693          	addi	a3,a5,-108
 830:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 834:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 836:	4701                	li	a4,0
      } else if(c0 == 'u'){
 838:	07500513          	li	a0,117
 83c:	e8a78ce3          	beq	a5,a0,6d4 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 840:	f8b60513          	addi	a0,a2,-117
 844:	e119                	bnez	a0,84a <vprintf+0x264>
 846:	ea0693e3          	bnez	a3,6ec <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 84a:	f8b58513          	addi	a0,a1,-117
 84e:	e119                	bnez	a0,854 <vprintf+0x26e>
 850:	ea071be3          	bnez	a4,706 <vprintf+0x120>
      } else if(c0 == 'x'){
 854:	07800513          	li	a0,120
 858:	eca784e3          	beq	a5,a0,720 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 85c:	f8860613          	addi	a2,a2,-120
 860:	e219                	bnez	a2,866 <vprintf+0x280>
 862:	ec069be3          	bnez	a3,738 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 866:	f8858593          	addi	a1,a1,-120
 86a:	e199                	bnez	a1,870 <vprintf+0x28a>
 86c:	ee0713e3          	bnez	a4,752 <vprintf+0x16c>
      } else if(c0 == 'p'){
 870:	07000713          	li	a4,112
 874:	eee78ce3          	beq	a5,a4,76c <vprintf+0x186>
      } else if(c0 == 'c'){
 878:	06300713          	li	a4,99
 87c:	f2e78ce3          	beq	a5,a4,7b4 <vprintf+0x1ce>
      } else if(c0 == 's'){
 880:	07300713          	li	a4,115
 884:	f4e782e3          	beq	a5,a4,7c8 <vprintf+0x1e2>
      } else if(c0 == '%'){
 888:	02500713          	li	a4,37
 88c:	f6e787e3          	beq	a5,a4,7fa <vprintf+0x214>
        putc(fd, '%');
 890:	02500593          	li	a1,37
 894:	855a                	mv	a0,s6
 896:	c8fff0ef          	jal	524 <putc>
        putc(fd, c0);
 89a:	85a6                	mv	a1,s1
 89c:	855a                	mv	a0,s6
 89e:	c87ff0ef          	jal	524 <putc>
      state = 0;
 8a2:	4981                	li	s3,0
 8a4:	b359                	j	62a <vprintf+0x44>

00000000000008a6 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8a6:	715d                	addi	sp,sp,-80
 8a8:	ec06                	sd	ra,24(sp)
 8aa:	e822                	sd	s0,16(sp)
 8ac:	1000                	addi	s0,sp,32
 8ae:	e010                	sd	a2,0(s0)
 8b0:	e414                	sd	a3,8(s0)
 8b2:	e818                	sd	a4,16(s0)
 8b4:	ec1c                	sd	a5,24(s0)
 8b6:	03043023          	sd	a6,32(s0)
 8ba:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 8be:	8622                	mv	a2,s0
 8c0:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 8c4:	d23ff0ef          	jal	5e6 <vprintf>
}
 8c8:	60e2                	ld	ra,24(sp)
 8ca:	6442                	ld	s0,16(sp)
 8cc:	6161                	addi	sp,sp,80
 8ce:	8082                	ret

00000000000008d0 <printf>:

void
printf(const char *fmt, ...)
{
 8d0:	711d                	addi	sp,sp,-96
 8d2:	ec06                	sd	ra,24(sp)
 8d4:	e822                	sd	s0,16(sp)
 8d6:	1000                	addi	s0,sp,32
 8d8:	e40c                	sd	a1,8(s0)
 8da:	e810                	sd	a2,16(s0)
 8dc:	ec14                	sd	a3,24(s0)
 8de:	f018                	sd	a4,32(s0)
 8e0:	f41c                	sd	a5,40(s0)
 8e2:	03043823          	sd	a6,48(s0)
 8e6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 8ea:	00840613          	addi	a2,s0,8
 8ee:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 8f2:	85aa                	mv	a1,a0
 8f4:	4505                	li	a0,1
 8f6:	cf1ff0ef          	jal	5e6 <vprintf>
}
 8fa:	60e2                	ld	ra,24(sp)
 8fc:	6442                	ld	s0,16(sp)
 8fe:	6125                	addi	sp,sp,96
 900:	8082                	ret

0000000000000902 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 902:	1141                	addi	sp,sp,-16
 904:	e406                	sd	ra,8(sp)
 906:	e022                	sd	s0,0(sp)
 908:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 90a:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 90e:	00000797          	auipc	a5,0x0
 912:	6f27b783          	ld	a5,1778(a5) # 1000 <freep>
 916:	a039                	j	924 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 918:	6398                	ld	a4,0(a5)
 91a:	00e7e463          	bltu	a5,a4,922 <free+0x20>
 91e:	00e6ea63          	bltu	a3,a4,932 <free+0x30>
{
 922:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 924:	fed7fae3          	bgeu	a5,a3,918 <free+0x16>
 928:	6398                	ld	a4,0(a5)
 92a:	00e6e463          	bltu	a3,a4,932 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 92e:	fee7eae3          	bltu	a5,a4,922 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 932:	ff852583          	lw	a1,-8(a0)
 936:	6390                	ld	a2,0(a5)
 938:	02059813          	slli	a6,a1,0x20
 93c:	01c85713          	srli	a4,a6,0x1c
 940:	9736                	add	a4,a4,a3
 942:	02e60563          	beq	a2,a4,96c <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 946:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 94a:	4790                	lw	a2,8(a5)
 94c:	02061593          	slli	a1,a2,0x20
 950:	01c5d713          	srli	a4,a1,0x1c
 954:	973e                	add	a4,a4,a5
 956:	02e68263          	beq	a3,a4,97a <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 95a:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 95c:	00000717          	auipc	a4,0x0
 960:	6af73223          	sd	a5,1700(a4) # 1000 <freep>
}
 964:	60a2                	ld	ra,8(sp)
 966:	6402                	ld	s0,0(sp)
 968:	0141                	addi	sp,sp,16
 96a:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 96c:	4618                	lw	a4,8(a2)
 96e:	9f2d                	addw	a4,a4,a1
 970:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 974:	6398                	ld	a4,0(a5)
 976:	6310                	ld	a2,0(a4)
 978:	b7f9                	j	946 <free+0x44>
    p->s.size += bp->s.size;
 97a:	ff852703          	lw	a4,-8(a0)
 97e:	9f31                	addw	a4,a4,a2
 980:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 982:	ff053683          	ld	a3,-16(a0)
 986:	bfd1                	j	95a <free+0x58>

0000000000000988 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 988:	7139                	addi	sp,sp,-64
 98a:	fc06                	sd	ra,56(sp)
 98c:	f822                	sd	s0,48(sp)
 98e:	f04a                	sd	s2,32(sp)
 990:	ec4e                	sd	s3,24(sp)
 992:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 994:	02051993          	slli	s3,a0,0x20
 998:	0209d993          	srli	s3,s3,0x20
 99c:	09bd                	addi	s3,s3,15
 99e:	0049d993          	srli	s3,s3,0x4
 9a2:	2985                	addiw	s3,s3,1
 9a4:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9a6:	00000517          	auipc	a0,0x0
 9aa:	65a53503          	ld	a0,1626(a0) # 1000 <freep>
 9ae:	c905                	beqz	a0,9de <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9b0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 9b2:	4798                	lw	a4,8(a5)
 9b4:	09377663          	bgeu	a4,s3,a40 <malloc+0xb8>
 9b8:	f426                	sd	s1,40(sp)
 9ba:	e852                	sd	s4,16(sp)
 9bc:	e456                	sd	s5,8(sp)
 9be:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 9c0:	8a4e                	mv	s4,s3
 9c2:	6705                	lui	a4,0x1
 9c4:	00e9f363          	bgeu	s3,a4,9ca <malloc+0x42>
 9c8:	6a05                	lui	s4,0x1
 9ca:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 9ce:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 9d2:	00000497          	auipc	s1,0x0
 9d6:	62e48493          	addi	s1,s1,1582 # 1000 <freep>
  if(p == SBRK_ERROR)
 9da:	5afd                	li	s5,-1
 9dc:	a83d                	j	a1a <malloc+0x92>
 9de:	f426                	sd	s1,40(sp)
 9e0:	e852                	sd	s4,16(sp)
 9e2:	e456                	sd	s5,8(sp)
 9e4:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 9e6:	00000797          	auipc	a5,0x0
 9ea:	62a78793          	addi	a5,a5,1578 # 1010 <base>
 9ee:	00000717          	auipc	a4,0x0
 9f2:	60f73923          	sd	a5,1554(a4) # 1000 <freep>
 9f6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 9f8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 9fc:	b7d1                	j	9c0 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 9fe:	6398                	ld	a4,0(a5)
 a00:	e118                	sd	a4,0(a0)
 a02:	a899                	j	a58 <malloc+0xd0>
  hp->s.size = nu;
 a04:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a08:	0541                	addi	a0,a0,16
 a0a:	ef9ff0ef          	jal	902 <free>
  return freep;
 a0e:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a10:	c125                	beqz	a0,a70 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a12:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a14:	4798                	lw	a4,8(a5)
 a16:	03277163          	bgeu	a4,s2,a38 <malloc+0xb0>
    if(p == freep)
 a1a:	6098                	ld	a4,0(s1)
 a1c:	853e                	mv	a0,a5
 a1e:	fef71ae3          	bne	a4,a5,a12 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a22:	8552                	mv	a0,s4
 a24:	a2dff0ef          	jal	450 <sbrk>
  if(p == SBRK_ERROR)
 a28:	fd551ee3          	bne	a0,s5,a04 <malloc+0x7c>
        return 0;
 a2c:	4501                	li	a0,0
 a2e:	74a2                	ld	s1,40(sp)
 a30:	6a42                	ld	s4,16(sp)
 a32:	6aa2                	ld	s5,8(sp)
 a34:	6b02                	ld	s6,0(sp)
 a36:	a03d                	j	a64 <malloc+0xdc>
 a38:	74a2                	ld	s1,40(sp)
 a3a:	6a42                	ld	s4,16(sp)
 a3c:	6aa2                	ld	s5,8(sp)
 a3e:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a40:	fae90fe3          	beq	s2,a4,9fe <malloc+0x76>
        p->s.size -= nunits;
 a44:	4137073b          	subw	a4,a4,s3
 a48:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a4a:	02071693          	slli	a3,a4,0x20
 a4e:	01c6d713          	srli	a4,a3,0x1c
 a52:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 a54:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 a58:	00000717          	auipc	a4,0x0
 a5c:	5aa73423          	sd	a0,1448(a4) # 1000 <freep>
      return (void*)(p + 1);
 a60:	01078513          	addi	a0,a5,16
  }
}
 a64:	70e2                	ld	ra,56(sp)
 a66:	7442                	ld	s0,48(sp)
 a68:	7902                	ld	s2,32(sp)
 a6a:	69e2                	ld	s3,24(sp)
 a6c:	6121                	addi	sp,sp,64
 a6e:	8082                	ret
 a70:	74a2                	ld	s1,40(sp)
 a72:	6a42                	ld	s4,16(sp)
 a74:	6aa2                	ld	s5,8(sp)
 a76:	6b02                	ld	s6,0(sp)
 a78:	b7f5                	j	a64 <malloc+0xdc>
