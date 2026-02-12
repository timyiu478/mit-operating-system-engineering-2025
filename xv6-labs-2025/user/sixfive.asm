
user/_sixfive:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <sixfive>:
#include "kernel/fcntl.h"
#include "user/user.h"

void
sixfive(int fd)
{
   0:	7159                	addi	sp,sp,-112
   2:	f486                	sd	ra,104(sp)
   4:	f0a2                	sd	s0,96(sp)
   6:	eca6                	sd	s1,88(sp)
   8:	e8ca                	sd	s2,80(sp)
   a:	e4ce                	sd	s3,72(sp)
   c:	e0d2                	sd	s4,64(sp)
   e:	fc56                	sd	s5,56(sp)
  10:	f85a                	sd	s6,48(sp)
  12:	f45e                	sd	s7,40(sp)
  14:	f062                	sd	s8,32(sp)
  16:	ec66                	sd	s9,24(sp)
  18:	e86a                	sd	s10,16(sp)
  1a:	1880                	addi	s0,sp,112
  1c:	8a2a                	mv	s4,a0
  int n;
  int num = 0;

  char c[1];

  bool isNum = false;
  1e:	4a81                	li	s5,0
  int num = 0;
  20:	4481                	li	s1,0

  while((n = read(fd, &c[0], 1)) > 0) {
  22:	f9840913          	addi	s2,s0,-104
  26:	4985                	li	s3,1
    if (strchr(&c[0], ' ') || strchr(&c[0], '-') || strchr(&c[0], '\r') || strchr(&c[0], '\t') || strchr(&c[0], '\n') || strchr(&c[0], '.') || strchr(&c[0], '/')) {
  28:	02000b93          	li	s7,32
      if ((num % 6 == 0 || num % 5 == 0) && isNum == true) {
  2c:	2aaabb37          	lui	s6,0x2aaab
  30:	aabb0b13          	addi	s6,s6,-1365 # 2aaaaaab <base+0x2aaa9a9b>
        fprintf(1, "%d\n", num);
  34:	00001c97          	auipc	s9,0x1
  38:	a9cc8c93          	addi	s9,s9,-1380 # ad0 <malloc+0xfa>
      if ((num % 6 == 0 || num % 5 == 0) && isNum == true) {
  3c:	66666c37          	lui	s8,0x66666
  40:	667c0c13          	addi	s8,s8,1639 # 66666667 <base+0x66665657>
    if (strchr(&c[0], ' ') || strchr(&c[0], '-') || strchr(&c[0], '\r') || strchr(&c[0], '\t') || strchr(&c[0], '\n') || strchr(&c[0], '.') || strchr(&c[0], '/')) {
  44:	02d00d13          	li	s10,45
  while((n = read(fd, &c[0], 1)) > 0) {
  48:	a895                	j	bc <sixfive+0xbc>
    if (strchr(&c[0], ' ') || strchr(&c[0], '-') || strchr(&c[0], '\r') || strchr(&c[0], '\t') || strchr(&c[0], '\n') || strchr(&c[0], '.') || strchr(&c[0], '/')) {
  4a:	85ea                	mv	a1,s10
  4c:	854a                	mv	a0,s2
  4e:	280000ef          	jal	2ce <strchr>
  52:	e149                	bnez	a0,d4 <sixfive+0xd4>
  54:	45b5                	li	a1,13
  56:	f9840513          	addi	a0,s0,-104
  5a:	274000ef          	jal	2ce <strchr>
  5e:	e93d                	bnez	a0,d4 <sixfive+0xd4>
  60:	45a5                	li	a1,9
  62:	f9840513          	addi	a0,s0,-104
  66:	268000ef          	jal	2ce <strchr>
  6a:	e52d                	bnez	a0,d4 <sixfive+0xd4>
  6c:	45a9                	li	a1,10
  6e:	f9840513          	addi	a0,s0,-104
  72:	25c000ef          	jal	2ce <strchr>
  76:	ed39                	bnez	a0,d4 <sixfive+0xd4>
  78:	02e00593          	li	a1,46
  7c:	f9840513          	addi	a0,s0,-104
  80:	24e000ef          	jal	2ce <strchr>
  84:	e921                	bnez	a0,d4 <sixfive+0xd4>
  86:	02f00593          	li	a1,47
  8a:	f9840513          	addi	a0,s0,-104
  8e:	240000ef          	jal	2ce <strchr>
  92:	e129                	bnez	a0,d4 <sixfive+0xd4>
      }
      isNum = false;
      num = 0;
    } else {
      int d = atoi(&c[0]);
  94:	f9840513          	addi	a0,s0,-104
  98:	310000ef          	jal	3a8 <atoi>
      if (d >= 0 && d < 10) {
  9c:	4725                	li	a4,9
  9e:	08a76063          	bltu	a4,a0,11e <sixfive+0x11e>
        if (num == 0) {
  a2:	0014b713          	seqz	a4,s1
  a6:	00eaeab3          	or	s5,s5,a4
          isNum = true;
        }
        num *= 10;
  aa:	4729                	li	a4,10
  ac:	02e4873b          	mulw	a4,s1,a4
        num += d;
  b0:	00e504bb          	addw	s1,a0,a4
  b4:	a021                	j	bc <sixfive+0xbc>
      if ((num % 6 == 0 || num % 5 == 0) && isNum == true) {
  b6:	040a9c63          	bnez	s5,10e <sixfive+0x10e>
      num = 0;
  ba:	4481                	li	s1,0
  while((n = read(fd, &c[0], 1)) > 0) {
  bc:	864e                	mv	a2,s3
  be:	85ca                	mv	a1,s2
  c0:	8552                	mv	a0,s4
  c2:	428000ef          	jal	4ea <read>
  c6:	04a05f63          	blez	a0,124 <sixfive+0x124>
    if (strchr(&c[0], ' ') || strchr(&c[0], '-') || strchr(&c[0], '\r') || strchr(&c[0], '\t') || strchr(&c[0], '\n') || strchr(&c[0], '.') || strchr(&c[0], '/')) {
  ca:	85de                	mv	a1,s7
  cc:	854a                	mv	a0,s2
  ce:	200000ef          	jal	2ce <strchr>
  d2:	dd25                	beqz	a0,4a <sixfive+0x4a>
      if ((num % 6 == 0 || num % 5 == 0) && isNum == true) {
  d4:	03648733          	mul	a4,s1,s6
  d8:	9301                	srli	a4,a4,0x20
  da:	41f4d79b          	sraiw	a5,s1,0x1f
  de:	9f1d                	subw	a4,a4,a5
  e0:	0017179b          	slliw	a5,a4,0x1
  e4:	9fb9                	addw	a5,a5,a4
  e6:	0017979b          	slliw	a5,a5,0x1
  ea:	40f487bb          	subw	a5,s1,a5
  ee:	d7e1                	beqz	a5,b6 <sixfive+0xb6>
  f0:	038487b3          	mul	a5,s1,s8
  f4:	9785                	srai	a5,a5,0x21
  f6:	41f4d71b          	sraiw	a4,s1,0x1f
  fa:	9f99                	subw	a5,a5,a4
  fc:	0027971b          	slliw	a4,a5,0x2
 100:	9fb9                	addw	a5,a5,a4
 102:	40f487bb          	subw	a5,s1,a5
 106:	dbc5                	beqz	a5,b6 <sixfive+0xb6>
      isNum = false;
 108:	4a81                	li	s5,0
      num = 0;
 10a:	4481                	li	s1,0
 10c:	bf45                	j	bc <sixfive+0xbc>
        fprintf(1, "%d\n", num);
 10e:	8626                	mv	a2,s1
 110:	85e6                	mv	a1,s9
 112:	854e                	mv	a0,s3
 114:	7e0000ef          	jal	8f4 <fprintf>
      isNum = false;
 118:	4a81                	li	s5,0
      num = 0;
 11a:	4481                	li	s1,0
 11c:	b745                	j	bc <sixfive+0xbc>
      } else {
        num = 0;
        isNum = false;
 11e:	4a81                	li	s5,0
        num = 0;
 120:	4481                	li	s1,0
 122:	bf69                	j	bc <sixfive+0xbc>
      }
    }
  }

  if ((num % 6 == 0 || num % 5 == 0) && isNum == true) {
 124:	2aaab7b7          	lui	a5,0x2aaab
 128:	aab78793          	addi	a5,a5,-1365 # 2aaaaaab <base+0x2aaa9a9b>
 12c:	02f487b3          	mul	a5,s1,a5
 130:	9381                	srli	a5,a5,0x20
 132:	41f4d71b          	sraiw	a4,s1,0x1f
 136:	9f99                	subw	a5,a5,a4
 138:	0017971b          	slliw	a4,a5,0x1
 13c:	9fb9                	addw	a5,a5,a4
 13e:	0017979b          	slliw	a5,a5,0x1
 142:	40f487bb          	subw	a5,s1,a5
 146:	c38d                	beqz	a5,168 <sixfive+0x168>
 148:	666667b7          	lui	a5,0x66666
 14c:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x66665657>
 150:	02f487b3          	mul	a5,s1,a5
 154:	9785                	srai	a5,a5,0x21
 156:	41f4d71b          	sraiw	a4,s1,0x1f
 15a:	9f99                	subw	a5,a5,a4
 15c:	0027971b          	slliw	a4,a5,0x2
 160:	9fb9                	addw	a5,a5,a4
 162:	40f487bb          	subw	a5,s1,a5
 166:	e399                	bnez	a5,16c <sixfive+0x16c>
 168:	020a9063          	bnez	s5,188 <sixfive+0x188>
    fprintf(1, "%d\n", num);
  }
}
 16c:	70a6                	ld	ra,104(sp)
 16e:	7406                	ld	s0,96(sp)
 170:	64e6                	ld	s1,88(sp)
 172:	6946                	ld	s2,80(sp)
 174:	69a6                	ld	s3,72(sp)
 176:	6a06                	ld	s4,64(sp)
 178:	7ae2                	ld	s5,56(sp)
 17a:	7b42                	ld	s6,48(sp)
 17c:	7ba2                	ld	s7,40(sp)
 17e:	7c02                	ld	s8,32(sp)
 180:	6ce2                	ld	s9,24(sp)
 182:	6d42                	ld	s10,16(sp)
 184:	6165                	addi	sp,sp,112
 186:	8082                	ret
    fprintf(1, "%d\n", num);
 188:	8626                	mv	a2,s1
 18a:	00001597          	auipc	a1,0x1
 18e:	94658593          	addi	a1,a1,-1722 # ad0 <malloc+0xfa>
 192:	4505                	li	a0,1
 194:	760000ef          	jal	8f4 <fprintf>
}
 198:	bfd1                	j	16c <sixfive+0x16c>

000000000000019a <main>:

int
main(int argc, char *argv[])
{
 19a:	7179                	addi	sp,sp,-48
 19c:	f406                	sd	ra,40(sp)
 19e:	f022                	sd	s0,32(sp)
 1a0:	1800                	addi	s0,sp,48
  int fd, i;

  if(argc <= 1){
 1a2:	4785                	li	a5,1
 1a4:	04a7d263          	bge	a5,a0,1e8 <main+0x4e>
 1a8:	ec26                	sd	s1,24(sp)
 1aa:	e84a                	sd	s2,16(sp)
 1ac:	e44e                	sd	s3,8(sp)
 1ae:	00858913          	addi	s2,a1,8
 1b2:	ffe5099b          	addiw	s3,a0,-2
 1b6:	02099793          	slli	a5,s3,0x20
 1ba:	01d7d993          	srli	s3,a5,0x1d
 1be:	05c1                	addi	a1,a1,16
 1c0:	99ae                	add	s3,s3,a1
    fprintf(2, "usage: sixfive file...\n");
    exit(0);
  }

  for(i = 1; i < argc; i++){
    if((fd = open(argv[i], O_RDONLY)) < 0){
 1c2:	4581                	li	a1,0
 1c4:	00093503          	ld	a0,0(s2)
 1c8:	34a000ef          	jal	512 <open>
 1cc:	84aa                	mv	s1,a0
 1ce:	02054a63          	bltz	a0,202 <main+0x68>
      fprintf(2, "sixfive: cannot open %s\n", argv[i]);
      exit(1);
    }
    sixfive(fd);
 1d2:	e2fff0ef          	jal	0 <sixfive>
    close(fd);
 1d6:	8526                	mv	a0,s1
 1d8:	322000ef          	jal	4fa <close>
  for(i = 1; i < argc; i++){
 1dc:	0921                	addi	s2,s2,8
 1de:	ff3912e3          	bne	s2,s3,1c2 <main+0x28>
  }
  exit(0);
 1e2:	4501                	li	a0,0
 1e4:	2ee000ef          	jal	4d2 <exit>
 1e8:	ec26                	sd	s1,24(sp)
 1ea:	e84a                	sd	s2,16(sp)
 1ec:	e44e                	sd	s3,8(sp)
    fprintf(2, "usage: sixfive file...\n");
 1ee:	00001597          	auipc	a1,0x1
 1f2:	8ea58593          	addi	a1,a1,-1814 # ad8 <malloc+0x102>
 1f6:	4509                	li	a0,2
 1f8:	6fc000ef          	jal	8f4 <fprintf>
    exit(0);
 1fc:	4501                	li	a0,0
 1fe:	2d4000ef          	jal	4d2 <exit>
      fprintf(2, "sixfive: cannot open %s\n", argv[i]);
 202:	00093603          	ld	a2,0(s2)
 206:	00001597          	auipc	a1,0x1
 20a:	8ea58593          	addi	a1,a1,-1814 # af0 <malloc+0x11a>
 20e:	4509                	li	a0,2
 210:	6e4000ef          	jal	8f4 <fprintf>
      exit(1);
 214:	4505                	li	a0,1
 216:	2bc000ef          	jal	4d2 <exit>

000000000000021a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 21a:	1141                	addi	sp,sp,-16
 21c:	e406                	sd	ra,8(sp)
 21e:	e022                	sd	s0,0(sp)
 220:	0800                	addi	s0,sp,16
  extern int main();
  main();
 222:	f79ff0ef          	jal	19a <main>
  exit(0);
 226:	4501                	li	a0,0
 228:	2aa000ef          	jal	4d2 <exit>

000000000000022c <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 22c:	1141                	addi	sp,sp,-16
 22e:	e406                	sd	ra,8(sp)
 230:	e022                	sd	s0,0(sp)
 232:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 234:	87aa                	mv	a5,a0
 236:	0585                	addi	a1,a1,1
 238:	0785                	addi	a5,a5,1
 23a:	fff5c703          	lbu	a4,-1(a1)
 23e:	fee78fa3          	sb	a4,-1(a5)
 242:	fb75                	bnez	a4,236 <strcpy+0xa>
    ;
  return os;
}
 244:	60a2                	ld	ra,8(sp)
 246:	6402                	ld	s0,0(sp)
 248:	0141                	addi	sp,sp,16
 24a:	8082                	ret

000000000000024c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 24c:	1141                	addi	sp,sp,-16
 24e:	e406                	sd	ra,8(sp)
 250:	e022                	sd	s0,0(sp)
 252:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 254:	00054783          	lbu	a5,0(a0)
 258:	cb91                	beqz	a5,26c <strcmp+0x20>
 25a:	0005c703          	lbu	a4,0(a1)
 25e:	00f71763          	bne	a4,a5,26c <strcmp+0x20>
    p++, q++;
 262:	0505                	addi	a0,a0,1
 264:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 266:	00054783          	lbu	a5,0(a0)
 26a:	fbe5                	bnez	a5,25a <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 26c:	0005c503          	lbu	a0,0(a1)
}
 270:	40a7853b          	subw	a0,a5,a0
 274:	60a2                	ld	ra,8(sp)
 276:	6402                	ld	s0,0(sp)
 278:	0141                	addi	sp,sp,16
 27a:	8082                	ret

000000000000027c <strlen>:

uint
strlen(const char *s)
{
 27c:	1141                	addi	sp,sp,-16
 27e:	e406                	sd	ra,8(sp)
 280:	e022                	sd	s0,0(sp)
 282:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 284:	00054783          	lbu	a5,0(a0)
 288:	cf91                	beqz	a5,2a4 <strlen+0x28>
 28a:	00150793          	addi	a5,a0,1
 28e:	86be                	mv	a3,a5
 290:	0785                	addi	a5,a5,1
 292:	fff7c703          	lbu	a4,-1(a5)
 296:	ff65                	bnez	a4,28e <strlen+0x12>
 298:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 29c:	60a2                	ld	ra,8(sp)
 29e:	6402                	ld	s0,0(sp)
 2a0:	0141                	addi	sp,sp,16
 2a2:	8082                	ret
  for(n = 0; s[n]; n++)
 2a4:	4501                	li	a0,0
 2a6:	bfdd                	j	29c <strlen+0x20>

00000000000002a8 <memset>:

void*
memset(void *dst, int c, uint n)
{
 2a8:	1141                	addi	sp,sp,-16
 2aa:	e406                	sd	ra,8(sp)
 2ac:	e022                	sd	s0,0(sp)
 2ae:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 2b0:	ca19                	beqz	a2,2c6 <memset+0x1e>
 2b2:	87aa                	mv	a5,a0
 2b4:	1602                	slli	a2,a2,0x20
 2b6:	9201                	srli	a2,a2,0x20
 2b8:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 2bc:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 2c0:	0785                	addi	a5,a5,1
 2c2:	fee79de3          	bne	a5,a4,2bc <memset+0x14>
  }
  return dst;
}
 2c6:	60a2                	ld	ra,8(sp)
 2c8:	6402                	ld	s0,0(sp)
 2ca:	0141                	addi	sp,sp,16
 2cc:	8082                	ret

00000000000002ce <strchr>:

char*
strchr(const char *s, char c)
{
 2ce:	1141                	addi	sp,sp,-16
 2d0:	e406                	sd	ra,8(sp)
 2d2:	e022                	sd	s0,0(sp)
 2d4:	0800                	addi	s0,sp,16
  for(; *s; s++)
 2d6:	00054783          	lbu	a5,0(a0)
 2da:	cf81                	beqz	a5,2f2 <strchr+0x24>
    if(*s == c)
 2dc:	00f58763          	beq	a1,a5,2ea <strchr+0x1c>
  for(; *s; s++)
 2e0:	0505                	addi	a0,a0,1
 2e2:	00054783          	lbu	a5,0(a0)
 2e6:	fbfd                	bnez	a5,2dc <strchr+0xe>
      return (char*)s;
  return 0;
 2e8:	4501                	li	a0,0
}
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret
  return 0;
 2f2:	4501                	li	a0,0
 2f4:	bfdd                	j	2ea <strchr+0x1c>

00000000000002f6 <gets>:

char*
gets(char *buf, int max)
{
 2f6:	711d                	addi	sp,sp,-96
 2f8:	ec86                	sd	ra,88(sp)
 2fa:	e8a2                	sd	s0,80(sp)
 2fc:	e4a6                	sd	s1,72(sp)
 2fe:	e0ca                	sd	s2,64(sp)
 300:	fc4e                	sd	s3,56(sp)
 302:	f852                	sd	s4,48(sp)
 304:	f456                	sd	s5,40(sp)
 306:	f05a                	sd	s6,32(sp)
 308:	ec5e                	sd	s7,24(sp)
 30a:	e862                	sd	s8,16(sp)
 30c:	1080                	addi	s0,sp,96
 30e:	8baa                	mv	s7,a0
 310:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 312:	892a                	mv	s2,a0
 314:	4481                	li	s1,0
    cc = read(0, &c, 1);
 316:	faf40b13          	addi	s6,s0,-81
 31a:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 31c:	8c26                	mv	s8,s1
 31e:	0014899b          	addiw	s3,s1,1
 322:	84ce                	mv	s1,s3
 324:	0349d463          	bge	s3,s4,34c <gets+0x56>
    cc = read(0, &c, 1);
 328:	8656                	mv	a2,s5
 32a:	85da                	mv	a1,s6
 32c:	4501                	li	a0,0
 32e:	1bc000ef          	jal	4ea <read>
    if(cc < 1)
 332:	00a05d63          	blez	a0,34c <gets+0x56>
      break;
    buf[i++] = c;
 336:	faf44783          	lbu	a5,-81(s0)
 33a:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 33e:	0905                	addi	s2,s2,1
 340:	ff678713          	addi	a4,a5,-10
 344:	c319                	beqz	a4,34a <gets+0x54>
 346:	17cd                	addi	a5,a5,-13
 348:	fbf1                	bnez	a5,31c <gets+0x26>
    buf[i++] = c;
 34a:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 34c:	9c5e                	add	s8,s8,s7
 34e:	000c0023          	sb	zero,0(s8)
  return buf;
}
 352:	855e                	mv	a0,s7
 354:	60e6                	ld	ra,88(sp)
 356:	6446                	ld	s0,80(sp)
 358:	64a6                	ld	s1,72(sp)
 35a:	6906                	ld	s2,64(sp)
 35c:	79e2                	ld	s3,56(sp)
 35e:	7a42                	ld	s4,48(sp)
 360:	7aa2                	ld	s5,40(sp)
 362:	7b02                	ld	s6,32(sp)
 364:	6be2                	ld	s7,24(sp)
 366:	6c42                	ld	s8,16(sp)
 368:	6125                	addi	sp,sp,96
 36a:	8082                	ret

000000000000036c <stat>:

int
stat(const char *n, struct stat *st)
{
 36c:	1101                	addi	sp,sp,-32
 36e:	ec06                	sd	ra,24(sp)
 370:	e822                	sd	s0,16(sp)
 372:	e04a                	sd	s2,0(sp)
 374:	1000                	addi	s0,sp,32
 376:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 378:	4581                	li	a1,0
 37a:	198000ef          	jal	512 <open>
  if(fd < 0)
 37e:	02054263          	bltz	a0,3a2 <stat+0x36>
 382:	e426                	sd	s1,8(sp)
 384:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 386:	85ca                	mv	a1,s2
 388:	1a2000ef          	jal	52a <fstat>
 38c:	892a                	mv	s2,a0
  close(fd);
 38e:	8526                	mv	a0,s1
 390:	16a000ef          	jal	4fa <close>
  return r;
 394:	64a2                	ld	s1,8(sp)
}
 396:	854a                	mv	a0,s2
 398:	60e2                	ld	ra,24(sp)
 39a:	6442                	ld	s0,16(sp)
 39c:	6902                	ld	s2,0(sp)
 39e:	6105                	addi	sp,sp,32
 3a0:	8082                	ret
    return -1;
 3a2:	57fd                	li	a5,-1
 3a4:	893e                	mv	s2,a5
 3a6:	bfc5                	j	396 <stat+0x2a>

00000000000003a8 <atoi>:

int
atoi(const char *s)
{
 3a8:	1141                	addi	sp,sp,-16
 3aa:	e406                	sd	ra,8(sp)
 3ac:	e022                	sd	s0,0(sp)
 3ae:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 3b0:	00054683          	lbu	a3,0(a0)
 3b4:	fd06879b          	addiw	a5,a3,-48
 3b8:	0ff7f793          	zext.b	a5,a5
 3bc:	4625                	li	a2,9
 3be:	02f66963          	bltu	a2,a5,3f0 <atoi+0x48>
 3c2:	872a                	mv	a4,a0
  n = 0;
 3c4:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 3c6:	0705                	addi	a4,a4,1
 3c8:	0025179b          	slliw	a5,a0,0x2
 3cc:	9fa9                	addw	a5,a5,a0
 3ce:	0017979b          	slliw	a5,a5,0x1
 3d2:	9fb5                	addw	a5,a5,a3
 3d4:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 3d8:	00074683          	lbu	a3,0(a4)
 3dc:	fd06879b          	addiw	a5,a3,-48
 3e0:	0ff7f793          	zext.b	a5,a5
 3e4:	fef671e3          	bgeu	a2,a5,3c6 <atoi+0x1e>
  return n;
}
 3e8:	60a2                	ld	ra,8(sp)
 3ea:	6402                	ld	s0,0(sp)
 3ec:	0141                	addi	sp,sp,16
 3ee:	8082                	ret
  n = 0;
 3f0:	4501                	li	a0,0
 3f2:	bfdd                	j	3e8 <atoi+0x40>

00000000000003f4 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 3f4:	1141                	addi	sp,sp,-16
 3f6:	e406                	sd	ra,8(sp)
 3f8:	e022                	sd	s0,0(sp)
 3fa:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 3fc:	02b57563          	bgeu	a0,a1,426 <memmove+0x32>
    while(n-- > 0)
 400:	00c05f63          	blez	a2,41e <memmove+0x2a>
 404:	1602                	slli	a2,a2,0x20
 406:	9201                	srli	a2,a2,0x20
 408:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 40c:	872a                	mv	a4,a0
      *dst++ = *src++;
 40e:	0585                	addi	a1,a1,1
 410:	0705                	addi	a4,a4,1
 412:	fff5c683          	lbu	a3,-1(a1)
 416:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 41a:	fee79ae3          	bne	a5,a4,40e <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 41e:	60a2                	ld	ra,8(sp)
 420:	6402                	ld	s0,0(sp)
 422:	0141                	addi	sp,sp,16
 424:	8082                	ret
    while(n-- > 0)
 426:	fec05ce3          	blez	a2,41e <memmove+0x2a>
    dst += n;
 42a:	00c50733          	add	a4,a0,a2
    src += n;
 42e:	95b2                	add	a1,a1,a2
 430:	fff6079b          	addiw	a5,a2,-1
 434:	1782                	slli	a5,a5,0x20
 436:	9381                	srli	a5,a5,0x20
 438:	fff7c793          	not	a5,a5
 43c:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 43e:	15fd                	addi	a1,a1,-1
 440:	177d                	addi	a4,a4,-1
 442:	0005c683          	lbu	a3,0(a1)
 446:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 44a:	fef71ae3          	bne	a4,a5,43e <memmove+0x4a>
 44e:	bfc1                	j	41e <memmove+0x2a>

0000000000000450 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 450:	1141                	addi	sp,sp,-16
 452:	e406                	sd	ra,8(sp)
 454:	e022                	sd	s0,0(sp)
 456:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 458:	c61d                	beqz	a2,486 <memcmp+0x36>
 45a:	1602                	slli	a2,a2,0x20
 45c:	9201                	srli	a2,a2,0x20
 45e:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 462:	00054783          	lbu	a5,0(a0)
 466:	0005c703          	lbu	a4,0(a1)
 46a:	00e79863          	bne	a5,a4,47a <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 46e:	0505                	addi	a0,a0,1
    p2++;
 470:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 472:	fed518e3          	bne	a0,a3,462 <memcmp+0x12>
  }
  return 0;
 476:	4501                	li	a0,0
 478:	a019                	j	47e <memcmp+0x2e>
      return *p1 - *p2;
 47a:	40e7853b          	subw	a0,a5,a4
}
 47e:	60a2                	ld	ra,8(sp)
 480:	6402                	ld	s0,0(sp)
 482:	0141                	addi	sp,sp,16
 484:	8082                	ret
  return 0;
 486:	4501                	li	a0,0
 488:	bfdd                	j	47e <memcmp+0x2e>

000000000000048a <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 48a:	1141                	addi	sp,sp,-16
 48c:	e406                	sd	ra,8(sp)
 48e:	e022                	sd	s0,0(sp)
 490:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 492:	f63ff0ef          	jal	3f4 <memmove>
}
 496:	60a2                	ld	ra,8(sp)
 498:	6402                	ld	s0,0(sp)
 49a:	0141                	addi	sp,sp,16
 49c:	8082                	ret

000000000000049e <sbrk>:

char *
sbrk(int n) {
 49e:	1141                	addi	sp,sp,-16
 4a0:	e406                	sd	ra,8(sp)
 4a2:	e022                	sd	s0,0(sp)
 4a4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 4a6:	4585                	li	a1,1
 4a8:	0b2000ef          	jal	55a <sys_sbrk>
}
 4ac:	60a2                	ld	ra,8(sp)
 4ae:	6402                	ld	s0,0(sp)
 4b0:	0141                	addi	sp,sp,16
 4b2:	8082                	ret

00000000000004b4 <sbrklazy>:

char *
sbrklazy(int n) {
 4b4:	1141                	addi	sp,sp,-16
 4b6:	e406                	sd	ra,8(sp)
 4b8:	e022                	sd	s0,0(sp)
 4ba:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 4bc:	4589                	li	a1,2
 4be:	09c000ef          	jal	55a <sys_sbrk>
}
 4c2:	60a2                	ld	ra,8(sp)
 4c4:	6402                	ld	s0,0(sp)
 4c6:	0141                	addi	sp,sp,16
 4c8:	8082                	ret

00000000000004ca <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 4ca:	4885                	li	a7,1
 ecall
 4cc:	00000073          	ecall
 ret
 4d0:	8082                	ret

00000000000004d2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 4d2:	4889                	li	a7,2
 ecall
 4d4:	00000073          	ecall
 ret
 4d8:	8082                	ret

00000000000004da <wait>:
.global wait
wait:
 li a7, SYS_wait
 4da:	488d                	li	a7,3
 ecall
 4dc:	00000073          	ecall
 ret
 4e0:	8082                	ret

00000000000004e2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 4e2:	4891                	li	a7,4
 ecall
 4e4:	00000073          	ecall
 ret
 4e8:	8082                	ret

00000000000004ea <read>:
.global read
read:
 li a7, SYS_read
 4ea:	4895                	li	a7,5
 ecall
 4ec:	00000073          	ecall
 ret
 4f0:	8082                	ret

00000000000004f2 <write>:
.global write
write:
 li a7, SYS_write
 4f2:	48c1                	li	a7,16
 ecall
 4f4:	00000073          	ecall
 ret
 4f8:	8082                	ret

00000000000004fa <close>:
.global close
close:
 li a7, SYS_close
 4fa:	48d5                	li	a7,21
 ecall
 4fc:	00000073          	ecall
 ret
 500:	8082                	ret

0000000000000502 <kill>:
.global kill
kill:
 li a7, SYS_kill
 502:	4899                	li	a7,6
 ecall
 504:	00000073          	ecall
 ret
 508:	8082                	ret

000000000000050a <exec>:
.global exec
exec:
 li a7, SYS_exec
 50a:	489d                	li	a7,7
 ecall
 50c:	00000073          	ecall
 ret
 510:	8082                	ret

0000000000000512 <open>:
.global open
open:
 li a7, SYS_open
 512:	48bd                	li	a7,15
 ecall
 514:	00000073          	ecall
 ret
 518:	8082                	ret

000000000000051a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 51a:	48c5                	li	a7,17
 ecall
 51c:	00000073          	ecall
 ret
 520:	8082                	ret

0000000000000522 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 522:	48c9                	li	a7,18
 ecall
 524:	00000073          	ecall
 ret
 528:	8082                	ret

000000000000052a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 52a:	48a1                	li	a7,8
 ecall
 52c:	00000073          	ecall
 ret
 530:	8082                	ret

0000000000000532 <link>:
.global link
link:
 li a7, SYS_link
 532:	48cd                	li	a7,19
 ecall
 534:	00000073          	ecall
 ret
 538:	8082                	ret

000000000000053a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 53a:	48d1                	li	a7,20
 ecall
 53c:	00000073          	ecall
 ret
 540:	8082                	ret

0000000000000542 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 542:	48a5                	li	a7,9
 ecall
 544:	00000073          	ecall
 ret
 548:	8082                	ret

000000000000054a <dup>:
.global dup
dup:
 li a7, SYS_dup
 54a:	48a9                	li	a7,10
 ecall
 54c:	00000073          	ecall
 ret
 550:	8082                	ret

0000000000000552 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 552:	48ad                	li	a7,11
 ecall
 554:	00000073          	ecall
 ret
 558:	8082                	ret

000000000000055a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 55a:	48b1                	li	a7,12
 ecall
 55c:	00000073          	ecall
 ret
 560:	8082                	ret

0000000000000562 <pause>:
.global pause
pause:
 li a7, SYS_pause
 562:	48b5                	li	a7,13
 ecall
 564:	00000073          	ecall
 ret
 568:	8082                	ret

000000000000056a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 56a:	48b9                	li	a7,14
 ecall
 56c:	00000073          	ecall
 ret
 570:	8082                	ret

0000000000000572 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 572:	1101                	addi	sp,sp,-32
 574:	ec06                	sd	ra,24(sp)
 576:	e822                	sd	s0,16(sp)
 578:	1000                	addi	s0,sp,32
 57a:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 57e:	4605                	li	a2,1
 580:	fef40593          	addi	a1,s0,-17
 584:	f6fff0ef          	jal	4f2 <write>
}
 588:	60e2                	ld	ra,24(sp)
 58a:	6442                	ld	s0,16(sp)
 58c:	6105                	addi	sp,sp,32
 58e:	8082                	ret

0000000000000590 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 590:	715d                	addi	sp,sp,-80
 592:	e486                	sd	ra,72(sp)
 594:	e0a2                	sd	s0,64(sp)
 596:	f84a                	sd	s2,48(sp)
 598:	f44e                	sd	s3,40(sp)
 59a:	0880                	addi	s0,sp,80
 59c:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 59e:	cac1                	beqz	a3,62e <printint+0x9e>
 5a0:	0805d763          	bgez	a1,62e <printint+0x9e>
    neg = 1;
    x = -xx;
 5a4:	40b005bb          	negw	a1,a1
    neg = 1;
 5a8:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 5aa:	fb840993          	addi	s3,s0,-72
  neg = 0;
 5ae:	86ce                	mv	a3,s3
  i = 0;
 5b0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 5b2:	00000817          	auipc	a6,0x0
 5b6:	56680813          	addi	a6,a6,1382 # b18 <digits>
 5ba:	88ba                	mv	a7,a4
 5bc:	0017051b          	addiw	a0,a4,1
 5c0:	872a                	mv	a4,a0
 5c2:	02c5f7bb          	remuw	a5,a1,a2
 5c6:	1782                	slli	a5,a5,0x20
 5c8:	9381                	srli	a5,a5,0x20
 5ca:	97c2                	add	a5,a5,a6
 5cc:	0007c783          	lbu	a5,0(a5)
 5d0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 5d4:	87ae                	mv	a5,a1
 5d6:	02c5d5bb          	divuw	a1,a1,a2
 5da:	0685                	addi	a3,a3,1
 5dc:	fcc7ffe3          	bgeu	a5,a2,5ba <printint+0x2a>
  if(neg)
 5e0:	00030c63          	beqz	t1,5f8 <printint+0x68>
    buf[i++] = '-';
 5e4:	fd050793          	addi	a5,a0,-48
 5e8:	00878533          	add	a0,a5,s0
 5ec:	02d00793          	li	a5,45
 5f0:	fef50423          	sb	a5,-24(a0)
 5f4:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 5f8:	02e05563          	blez	a4,622 <printint+0x92>
 5fc:	fc26                	sd	s1,56(sp)
 5fe:	377d                	addiw	a4,a4,-1
 600:	00e984b3          	add	s1,s3,a4
 604:	19fd                	addi	s3,s3,-1
 606:	99ba                	add	s3,s3,a4
 608:	1702                	slli	a4,a4,0x20
 60a:	9301                	srli	a4,a4,0x20
 60c:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 610:	0004c583          	lbu	a1,0(s1)
 614:	854a                	mv	a0,s2
 616:	f5dff0ef          	jal	572 <putc>
  while(--i >= 0)
 61a:	14fd                	addi	s1,s1,-1
 61c:	ff349ae3          	bne	s1,s3,610 <printint+0x80>
 620:	74e2                	ld	s1,56(sp)
}
 622:	60a6                	ld	ra,72(sp)
 624:	6406                	ld	s0,64(sp)
 626:	7942                	ld	s2,48(sp)
 628:	79a2                	ld	s3,40(sp)
 62a:	6161                	addi	sp,sp,80
 62c:	8082                	ret
    x = xx;
 62e:	2581                	sext.w	a1,a1
  neg = 0;
 630:	4301                	li	t1,0
 632:	bfa5                	j	5aa <printint+0x1a>

0000000000000634 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 634:	711d                	addi	sp,sp,-96
 636:	ec86                	sd	ra,88(sp)
 638:	e8a2                	sd	s0,80(sp)
 63a:	e4a6                	sd	s1,72(sp)
 63c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 63e:	0005c483          	lbu	s1,0(a1)
 642:	22048363          	beqz	s1,868 <vprintf+0x234>
 646:	e0ca                	sd	s2,64(sp)
 648:	fc4e                	sd	s3,56(sp)
 64a:	f852                	sd	s4,48(sp)
 64c:	f456                	sd	s5,40(sp)
 64e:	f05a                	sd	s6,32(sp)
 650:	ec5e                	sd	s7,24(sp)
 652:	e862                	sd	s8,16(sp)
 654:	8b2a                	mv	s6,a0
 656:	8a2e                	mv	s4,a1
 658:	8bb2                	mv	s7,a2
  state = 0;
 65a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 65c:	4901                	li	s2,0
 65e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 660:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 664:	06400c13          	li	s8,100
 668:	a00d                	j	68a <vprintf+0x56>
        putc(fd, c0);
 66a:	85a6                	mv	a1,s1
 66c:	855a                	mv	a0,s6
 66e:	f05ff0ef          	jal	572 <putc>
 672:	a019                	j	678 <vprintf+0x44>
    } else if(state == '%'){
 674:	03598363          	beq	s3,s5,69a <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 678:	0019079b          	addiw	a5,s2,1
 67c:	893e                	mv	s2,a5
 67e:	873e                	mv	a4,a5
 680:	97d2                	add	a5,a5,s4
 682:	0007c483          	lbu	s1,0(a5)
 686:	1c048a63          	beqz	s1,85a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 68a:	0004879b          	sext.w	a5,s1
    if(state == 0){
 68e:	fe0993e3          	bnez	s3,674 <vprintf+0x40>
      if(c0 == '%'){
 692:	fd579ce3          	bne	a5,s5,66a <vprintf+0x36>
        state = '%';
 696:	89be                	mv	s3,a5
 698:	b7c5                	j	678 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 69a:	00ea06b3          	add	a3,s4,a4
 69e:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 6a2:	1c060863          	beqz	a2,872 <vprintf+0x23e>
      if(c0 == 'd'){
 6a6:	03878763          	beq	a5,s8,6d4 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 6aa:	f9478693          	addi	a3,a5,-108
 6ae:	0016b693          	seqz	a3,a3
 6b2:	f9c60593          	addi	a1,a2,-100
 6b6:	e99d                	bnez	a1,6ec <vprintf+0xb8>
 6b8:	ca95                	beqz	a3,6ec <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ba:	008b8493          	addi	s1,s7,8
 6be:	4685                	li	a3,1
 6c0:	4629                	li	a2,10
 6c2:	000bb583          	ld	a1,0(s7)
 6c6:	855a                	mv	a0,s6
 6c8:	ec9ff0ef          	jal	590 <printint>
        i += 1;
 6cc:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 6ce:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 6d0:	4981                	li	s3,0
 6d2:	b75d                	j	678 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 6d4:	008b8493          	addi	s1,s7,8
 6d8:	4685                	li	a3,1
 6da:	4629                	li	a2,10
 6dc:	000ba583          	lw	a1,0(s7)
 6e0:	855a                	mv	a0,s6
 6e2:	eafff0ef          	jal	590 <printint>
 6e6:	8ba6                	mv	s7,s1
      state = 0;
 6e8:	4981                	li	s3,0
 6ea:	b779                	j	678 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 6ec:	9752                	add	a4,a4,s4
 6ee:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 6f2:	f9460713          	addi	a4,a2,-108
 6f6:	00173713          	seqz	a4,a4
 6fa:	8f75                	and	a4,a4,a3
 6fc:	f9c58513          	addi	a0,a1,-100
 700:	18051363          	bnez	a0,886 <vprintf+0x252>
 704:	18070163          	beqz	a4,886 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 708:	008b8493          	addi	s1,s7,8
 70c:	4685                	li	a3,1
 70e:	4629                	li	a2,10
 710:	000bb583          	ld	a1,0(s7)
 714:	855a                	mv	a0,s6
 716:	e7bff0ef          	jal	590 <printint>
        i += 2;
 71a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 71c:	8ba6                	mv	s7,s1
      state = 0;
 71e:	4981                	li	s3,0
        i += 2;
 720:	bfa1                	j	678 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 722:	008b8493          	addi	s1,s7,8
 726:	4681                	li	a3,0
 728:	4629                	li	a2,10
 72a:	000be583          	lwu	a1,0(s7)
 72e:	855a                	mv	a0,s6
 730:	e61ff0ef          	jal	590 <printint>
 734:	8ba6                	mv	s7,s1
      state = 0;
 736:	4981                	li	s3,0
 738:	b781                	j	678 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 73a:	008b8493          	addi	s1,s7,8
 73e:	4681                	li	a3,0
 740:	4629                	li	a2,10
 742:	000bb583          	ld	a1,0(s7)
 746:	855a                	mv	a0,s6
 748:	e49ff0ef          	jal	590 <printint>
        i += 1;
 74c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 74e:	8ba6                	mv	s7,s1
      state = 0;
 750:	4981                	li	s3,0
 752:	b71d                	j	678 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 754:	008b8493          	addi	s1,s7,8
 758:	4681                	li	a3,0
 75a:	4629                	li	a2,10
 75c:	000bb583          	ld	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	e2fff0ef          	jal	590 <printint>
        i += 2;
 766:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 768:	8ba6                	mv	s7,s1
      state = 0;
 76a:	4981                	li	s3,0
        i += 2;
 76c:	b731                	j	678 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 76e:	008b8493          	addi	s1,s7,8
 772:	4681                	li	a3,0
 774:	4641                	li	a2,16
 776:	000be583          	lwu	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	e15ff0ef          	jal	590 <printint>
 780:	8ba6                	mv	s7,s1
      state = 0;
 782:	4981                	li	s3,0
 784:	bdd5                	j	678 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 786:	008b8493          	addi	s1,s7,8
 78a:	4681                	li	a3,0
 78c:	4641                	li	a2,16
 78e:	000bb583          	ld	a1,0(s7)
 792:	855a                	mv	a0,s6
 794:	dfdff0ef          	jal	590 <printint>
        i += 1;
 798:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 79a:	8ba6                	mv	s7,s1
      state = 0;
 79c:	4981                	li	s3,0
 79e:	bde9                	j	678 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7a0:	008b8493          	addi	s1,s7,8
 7a4:	4681                	li	a3,0
 7a6:	4641                	li	a2,16
 7a8:	000bb583          	ld	a1,0(s7)
 7ac:	855a                	mv	a0,s6
 7ae:	de3ff0ef          	jal	590 <printint>
        i += 2;
 7b2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 7b4:	8ba6                	mv	s7,s1
      state = 0;
 7b6:	4981                	li	s3,0
        i += 2;
 7b8:	b5c1                	j	678 <vprintf+0x44>
 7ba:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 7bc:	008b8793          	addi	a5,s7,8
 7c0:	8cbe                	mv	s9,a5
 7c2:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 7c6:	03000593          	li	a1,48
 7ca:	855a                	mv	a0,s6
 7cc:	da7ff0ef          	jal	572 <putc>
  putc(fd, 'x');
 7d0:	07800593          	li	a1,120
 7d4:	855a                	mv	a0,s6
 7d6:	d9dff0ef          	jal	572 <putc>
 7da:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 7dc:	00000b97          	auipc	s7,0x0
 7e0:	33cb8b93          	addi	s7,s7,828 # b18 <digits>
 7e4:	03c9d793          	srli	a5,s3,0x3c
 7e8:	97de                	add	a5,a5,s7
 7ea:	0007c583          	lbu	a1,0(a5)
 7ee:	855a                	mv	a0,s6
 7f0:	d83ff0ef          	jal	572 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 7f4:	0992                	slli	s3,s3,0x4
 7f6:	34fd                	addiw	s1,s1,-1
 7f8:	f4f5                	bnez	s1,7e4 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 7fa:	8be6                	mv	s7,s9
      state = 0;
 7fc:	4981                	li	s3,0
 7fe:	6ca2                	ld	s9,8(sp)
 800:	bda5                	j	678 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 802:	008b8493          	addi	s1,s7,8
 806:	000bc583          	lbu	a1,0(s7)
 80a:	855a                	mv	a0,s6
 80c:	d67ff0ef          	jal	572 <putc>
 810:	8ba6                	mv	s7,s1
      state = 0;
 812:	4981                	li	s3,0
 814:	b595                	j	678 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 816:	008b8993          	addi	s3,s7,8
 81a:	000bb483          	ld	s1,0(s7)
 81e:	cc91                	beqz	s1,83a <vprintf+0x206>
        for(; *s; s++)
 820:	0004c583          	lbu	a1,0(s1)
 824:	c985                	beqz	a1,854 <vprintf+0x220>
          putc(fd, *s);
 826:	855a                	mv	a0,s6
 828:	d4bff0ef          	jal	572 <putc>
        for(; *s; s++)
 82c:	0485                	addi	s1,s1,1
 82e:	0004c583          	lbu	a1,0(s1)
 832:	f9f5                	bnez	a1,826 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 834:	8bce                	mv	s7,s3
      state = 0;
 836:	4981                	li	s3,0
 838:	b581                	j	678 <vprintf+0x44>
          s = "(null)";
 83a:	00000497          	auipc	s1,0x0
 83e:	2d648493          	addi	s1,s1,726 # b10 <malloc+0x13a>
        for(; *s; s++)
 842:	02800593          	li	a1,40
 846:	b7c5                	j	826 <vprintf+0x1f2>
        putc(fd, '%');
 848:	85be                	mv	a1,a5
 84a:	855a                	mv	a0,s6
 84c:	d27ff0ef          	jal	572 <putc>
      state = 0;
 850:	4981                	li	s3,0
 852:	b51d                	j	678 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 854:	8bce                	mv	s7,s3
      state = 0;
 856:	4981                	li	s3,0
 858:	b505                	j	678 <vprintf+0x44>
 85a:	6906                	ld	s2,64(sp)
 85c:	79e2                	ld	s3,56(sp)
 85e:	7a42                	ld	s4,48(sp)
 860:	7aa2                	ld	s5,40(sp)
 862:	7b02                	ld	s6,32(sp)
 864:	6be2                	ld	s7,24(sp)
 866:	6c42                	ld	s8,16(sp)
    }
  }
}
 868:	60e6                	ld	ra,88(sp)
 86a:	6446                	ld	s0,80(sp)
 86c:	64a6                	ld	s1,72(sp)
 86e:	6125                	addi	sp,sp,96
 870:	8082                	ret
      if(c0 == 'd'){
 872:	06400713          	li	a4,100
 876:	e4e78fe3          	beq	a5,a4,6d4 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 87a:	f9478693          	addi	a3,a5,-108
 87e:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 882:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 884:	4701                	li	a4,0
      } else if(c0 == 'u'){
 886:	07500513          	li	a0,117
 88a:	e8a78ce3          	beq	a5,a0,722 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 88e:	f8b60513          	addi	a0,a2,-117
 892:	e119                	bnez	a0,898 <vprintf+0x264>
 894:	ea0693e3          	bnez	a3,73a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 898:	f8b58513          	addi	a0,a1,-117
 89c:	e119                	bnez	a0,8a2 <vprintf+0x26e>
 89e:	ea071be3          	bnez	a4,754 <vprintf+0x120>
      } else if(c0 == 'x'){
 8a2:	07800513          	li	a0,120
 8a6:	eca784e3          	beq	a5,a0,76e <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 8aa:	f8860613          	addi	a2,a2,-120
 8ae:	e219                	bnez	a2,8b4 <vprintf+0x280>
 8b0:	ec069be3          	bnez	a3,786 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 8b4:	f8858593          	addi	a1,a1,-120
 8b8:	e199                	bnez	a1,8be <vprintf+0x28a>
 8ba:	ee0713e3          	bnez	a4,7a0 <vprintf+0x16c>
      } else if(c0 == 'p'){
 8be:	07000713          	li	a4,112
 8c2:	eee78ce3          	beq	a5,a4,7ba <vprintf+0x186>
      } else if(c0 == 'c'){
 8c6:	06300713          	li	a4,99
 8ca:	f2e78ce3          	beq	a5,a4,802 <vprintf+0x1ce>
      } else if(c0 == 's'){
 8ce:	07300713          	li	a4,115
 8d2:	f4e782e3          	beq	a5,a4,816 <vprintf+0x1e2>
      } else if(c0 == '%'){
 8d6:	02500713          	li	a4,37
 8da:	f6e787e3          	beq	a5,a4,848 <vprintf+0x214>
        putc(fd, '%');
 8de:	02500593          	li	a1,37
 8e2:	855a                	mv	a0,s6
 8e4:	c8fff0ef          	jal	572 <putc>
        putc(fd, c0);
 8e8:	85a6                	mv	a1,s1
 8ea:	855a                	mv	a0,s6
 8ec:	c87ff0ef          	jal	572 <putc>
      state = 0;
 8f0:	4981                	li	s3,0
 8f2:	b359                	j	678 <vprintf+0x44>

00000000000008f4 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 8f4:	715d                	addi	sp,sp,-80
 8f6:	ec06                	sd	ra,24(sp)
 8f8:	e822                	sd	s0,16(sp)
 8fa:	1000                	addi	s0,sp,32
 8fc:	e010                	sd	a2,0(s0)
 8fe:	e414                	sd	a3,8(s0)
 900:	e818                	sd	a4,16(s0)
 902:	ec1c                	sd	a5,24(s0)
 904:	03043023          	sd	a6,32(s0)
 908:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 90c:	8622                	mv	a2,s0
 90e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 912:	d23ff0ef          	jal	634 <vprintf>
}
 916:	60e2                	ld	ra,24(sp)
 918:	6442                	ld	s0,16(sp)
 91a:	6161                	addi	sp,sp,80
 91c:	8082                	ret

000000000000091e <printf>:

void
printf(const char *fmt, ...)
{
 91e:	711d                	addi	sp,sp,-96
 920:	ec06                	sd	ra,24(sp)
 922:	e822                	sd	s0,16(sp)
 924:	1000                	addi	s0,sp,32
 926:	e40c                	sd	a1,8(s0)
 928:	e810                	sd	a2,16(s0)
 92a:	ec14                	sd	a3,24(s0)
 92c:	f018                	sd	a4,32(s0)
 92e:	f41c                	sd	a5,40(s0)
 930:	03043823          	sd	a6,48(s0)
 934:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 938:	00840613          	addi	a2,s0,8
 93c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 940:	85aa                	mv	a1,a0
 942:	4505                	li	a0,1
 944:	cf1ff0ef          	jal	634 <vprintf>
}
 948:	60e2                	ld	ra,24(sp)
 94a:	6442                	ld	s0,16(sp)
 94c:	6125                	addi	sp,sp,96
 94e:	8082                	ret

0000000000000950 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 950:	1141                	addi	sp,sp,-16
 952:	e406                	sd	ra,8(sp)
 954:	e022                	sd	s0,0(sp)
 956:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 958:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 95c:	00000797          	auipc	a5,0x0
 960:	6a47b783          	ld	a5,1700(a5) # 1000 <freep>
 964:	a039                	j	972 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 966:	6398                	ld	a4,0(a5)
 968:	00e7e463          	bltu	a5,a4,970 <free+0x20>
 96c:	00e6ea63          	bltu	a3,a4,980 <free+0x30>
{
 970:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 972:	fed7fae3          	bgeu	a5,a3,966 <free+0x16>
 976:	6398                	ld	a4,0(a5)
 978:	00e6e463          	bltu	a3,a4,980 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 97c:	fee7eae3          	bltu	a5,a4,970 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 980:	ff852583          	lw	a1,-8(a0)
 984:	6390                	ld	a2,0(a5)
 986:	02059813          	slli	a6,a1,0x20
 98a:	01c85713          	srli	a4,a6,0x1c
 98e:	9736                	add	a4,a4,a3
 990:	02e60563          	beq	a2,a4,9ba <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 994:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 998:	4790                	lw	a2,8(a5)
 99a:	02061593          	slli	a1,a2,0x20
 99e:	01c5d713          	srli	a4,a1,0x1c
 9a2:	973e                	add	a4,a4,a5
 9a4:	02e68263          	beq	a3,a4,9c8 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 9a8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 9aa:	00000717          	auipc	a4,0x0
 9ae:	64f73b23          	sd	a5,1622(a4) # 1000 <freep>
}
 9b2:	60a2                	ld	ra,8(sp)
 9b4:	6402                	ld	s0,0(sp)
 9b6:	0141                	addi	sp,sp,16
 9b8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 9ba:	4618                	lw	a4,8(a2)
 9bc:	9f2d                	addw	a4,a4,a1
 9be:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 9c2:	6398                	ld	a4,0(a5)
 9c4:	6310                	ld	a2,0(a4)
 9c6:	b7f9                	j	994 <free+0x44>
    p->s.size += bp->s.size;
 9c8:	ff852703          	lw	a4,-8(a0)
 9cc:	9f31                	addw	a4,a4,a2
 9ce:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 9d0:	ff053683          	ld	a3,-16(a0)
 9d4:	bfd1                	j	9a8 <free+0x58>

00000000000009d6 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 9d6:	7139                	addi	sp,sp,-64
 9d8:	fc06                	sd	ra,56(sp)
 9da:	f822                	sd	s0,48(sp)
 9dc:	f04a                	sd	s2,32(sp)
 9de:	ec4e                	sd	s3,24(sp)
 9e0:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 9e2:	02051993          	slli	s3,a0,0x20
 9e6:	0209d993          	srli	s3,s3,0x20
 9ea:	09bd                	addi	s3,s3,15
 9ec:	0049d993          	srli	s3,s3,0x4
 9f0:	2985                	addiw	s3,s3,1
 9f2:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 9f4:	00000517          	auipc	a0,0x0
 9f8:	60c53503          	ld	a0,1548(a0) # 1000 <freep>
 9fc:	c905                	beqz	a0,a2c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 9fe:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a00:	4798                	lw	a4,8(a5)
 a02:	09377663          	bgeu	a4,s3,a8e <malloc+0xb8>
 a06:	f426                	sd	s1,40(sp)
 a08:	e852                	sd	s4,16(sp)
 a0a:	e456                	sd	s5,8(sp)
 a0c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a0e:	8a4e                	mv	s4,s3
 a10:	6705                	lui	a4,0x1
 a12:	00e9f363          	bgeu	s3,a4,a18 <malloc+0x42>
 a16:	6a05                	lui	s4,0x1
 a18:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a1c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a20:	00000497          	auipc	s1,0x0
 a24:	5e048493          	addi	s1,s1,1504 # 1000 <freep>
  if(p == SBRK_ERROR)
 a28:	5afd                	li	s5,-1
 a2a:	a83d                	j	a68 <malloc+0x92>
 a2c:	f426                	sd	s1,40(sp)
 a2e:	e852                	sd	s4,16(sp)
 a30:	e456                	sd	s5,8(sp)
 a32:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 a34:	00000797          	auipc	a5,0x0
 a38:	5dc78793          	addi	a5,a5,1500 # 1010 <base>
 a3c:	00000717          	auipc	a4,0x0
 a40:	5cf73223          	sd	a5,1476(a4) # 1000 <freep>
 a44:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 a46:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 a4a:	b7d1                	j	a0e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 a4c:	6398                	ld	a4,0(a5)
 a4e:	e118                	sd	a4,0(a0)
 a50:	a899                	j	aa6 <malloc+0xd0>
  hp->s.size = nu;
 a52:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 a56:	0541                	addi	a0,a0,16
 a58:	ef9ff0ef          	jal	950 <free>
  return freep;
 a5c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 a5e:	c125                	beqz	a0,abe <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a60:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a62:	4798                	lw	a4,8(a5)
 a64:	03277163          	bgeu	a4,s2,a86 <malloc+0xb0>
    if(p == freep)
 a68:	6098                	ld	a4,0(s1)
 a6a:	853e                	mv	a0,a5
 a6c:	fef71ae3          	bne	a4,a5,a60 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 a70:	8552                	mv	a0,s4
 a72:	a2dff0ef          	jal	49e <sbrk>
  if(p == SBRK_ERROR)
 a76:	fd551ee3          	bne	a0,s5,a52 <malloc+0x7c>
        return 0;
 a7a:	4501                	li	a0,0
 a7c:	74a2                	ld	s1,40(sp)
 a7e:	6a42                	ld	s4,16(sp)
 a80:	6aa2                	ld	s5,8(sp)
 a82:	6b02                	ld	s6,0(sp)
 a84:	a03d                	j	ab2 <malloc+0xdc>
 a86:	74a2                	ld	s1,40(sp)
 a88:	6a42                	ld	s4,16(sp)
 a8a:	6aa2                	ld	s5,8(sp)
 a8c:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 a8e:	fae90fe3          	beq	s2,a4,a4c <malloc+0x76>
        p->s.size -= nunits;
 a92:	4137073b          	subw	a4,a4,s3
 a96:	c798                	sw	a4,8(a5)
        p += p->s.size;
 a98:	02071693          	slli	a3,a4,0x20
 a9c:	01c6d713          	srli	a4,a3,0x1c
 aa0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 aa2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 aa6:	00000717          	auipc	a4,0x0
 aaa:	54a73d23          	sd	a0,1370(a4) # 1000 <freep>
      return (void*)(p + 1);
 aae:	01078513          	addi	a0,a5,16
  }
}
 ab2:	70e2                	ld	ra,56(sp)
 ab4:	7442                	ld	s0,48(sp)
 ab6:	7902                	ld	s2,32(sp)
 ab8:	69e2                	ld	s3,24(sp)
 aba:	6121                	addi	sp,sp,64
 abc:	8082                	ret
 abe:	74a2                	ld	s1,40(sp)
 ac0:	6a42                	ld	s4,16(sp)
 ac2:	6aa2                	ld	s5,8(sp)
 ac4:	6b02                	ld	s6,0(sp)
 ac6:	b7f5                	j	ab2 <malloc+0xdc>
