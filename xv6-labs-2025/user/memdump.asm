
user/_memdump:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <memdump>:
  exit(0);
}

void
memdump(char *fmt, char *data)
{
   0:	711d                	addi	sp,sp,-96
   2:	ec86                	sd	ra,88(sp)
   4:	e8a2                	sd	s0,80(sp)
   6:	e4a6                	sd	s1,72(sp)
   8:	e0ca                	sd	s2,64(sp)
   a:	fc4e                	sd	s3,56(sp)
   c:	f852                	sd	s4,48(sp)
   e:	f456                	sd	s5,40(sp)
  10:	f05a                	sd	s6,32(sp)
  12:	ec5e                	sd	s7,24(sp)
  14:	e862                	sd	s8,16(sp)
  16:	1080                	addi	s0,sp,96
  18:	89aa                	mv	s3,a0
  1a:	892e                	mv	s2,a1
  for (int i = 0; i < strlen(fmt); i++) {
  1c:	4481                	li	s1,0
  1e:	02000a93          	li	s5,32
  22:	00001a17          	auipc	s4,0x1
  26:	c06a0a13          	addi	s4,s4,-1018 # c28 <malloc+0x1dc>
      memcpy(&p, data, 8);
      printf("%s\n", p);
      data += 8;
    } // S: the rest of the data contains the bytes of a null-terminated C string; print the string.
    else if (fmt[i] == 'S') {
      printf("%s\n", data);
  2a:	00001c17          	auipc	s8,0x1
  2e:	b2ec0c13          	addi	s8,s8,-1234 # b58 <malloc+0x10c>
      memcpy(&p, data, 8);
  32:	fa840b13          	addi	s6,s0,-88
  36:	4ba1                	li	s7,8
  for (int i = 0; i < strlen(fmt); i++) {
  38:	a005                	j	58 <memdump+0x58>
      memcpy(&n, data, 4);
  3a:	4611                	li	a2,4
  3c:	85ca                	mv	a1,s2
  3e:	855a                	mv	a0,s6
  40:	4c0000ef          	jal	500 <memcpy>
      printf("%d\n", n);
  44:	fa842583          	lw	a1,-88(s0)
  48:	00001517          	auipc	a0,0x1
  4c:	af850513          	addi	a0,a0,-1288 # b40 <malloc+0xf4>
  50:	145000ef          	jal	994 <printf>
      data += 4;
  54:	0911                	addi	s2,s2,4
  for (int i = 0; i < strlen(fmt); i++) {
  56:	0485                	addi	s1,s1,1
  58:	854e                	mv	a0,s3
  5a:	298000ef          	jal	2f2 <strlen>
  5e:	0004879b          	sext.w	a5,s1
  62:	0aa7f063          	bgeu	a5,a0,102 <memdump+0x102>
    if (fmt[i] == 'i') {
  66:	009987b3          	add	a5,s3,s1
  6a:	0007c783          	lbu	a5,0(a5)
  6e:	fad7879b          	addiw	a5,a5,-83
  72:	0ff7f713          	zext.b	a4,a5
  76:	feeae0e3          	bltu	s5,a4,56 <memdump+0x56>
  7a:	00271793          	slli	a5,a4,0x2
  7e:	97d2                	add	a5,a5,s4
  80:	439c                	lw	a5,0(a5)
  82:	97d2                	add	a5,a5,s4
  84:	8782                	jr	a5
      memcpy(&n, data, 8);
  86:	865e                	mv	a2,s7
  88:	85ca                	mv	a1,s2
  8a:	855a                	mv	a0,s6
  8c:	474000ef          	jal	500 <memcpy>
      printf("%llx\n", n);
  90:	fa843583          	ld	a1,-88(s0)
  94:	00001517          	auipc	a0,0x1
  98:	ab450513          	addi	a0,a0,-1356 # b48 <malloc+0xfc>
  9c:	0f9000ef          	jal	994 <printf>
      data += 8;
  a0:	0921                	addi	s2,s2,8
  a2:	bf55                	j	56 <memdump+0x56>
      memcpy(&n, data, 2);
  a4:	4609                	li	a2,2
  a6:	85ca                	mv	a1,s2
  a8:	855a                	mv	a0,s6
  aa:	456000ef          	jal	500 <memcpy>
      printf("%d\n", n);
  ae:	fa841583          	lh	a1,-88(s0)
  b2:	00001517          	auipc	a0,0x1
  b6:	a8e50513          	addi	a0,a0,-1394 # b40 <malloc+0xf4>
  ba:	0db000ef          	jal	994 <printf>
      data += 2;
  be:	0909                	addi	s2,s2,2
  c0:	bf59                	j	56 <memdump+0x56>
      memcpy(&c, data, 1);
  c2:	4605                	li	a2,1
  c4:	85ca                	mv	a1,s2
  c6:	855a                	mv	a0,s6
  c8:	438000ef          	jal	500 <memcpy>
      printf("%c\n", c);
  cc:	fa844583          	lbu	a1,-88(s0)
  d0:	00001517          	auipc	a0,0x1
  d4:	a8050513          	addi	a0,a0,-1408 # b50 <malloc+0x104>
  d8:	0bd000ef          	jal	994 <printf>
      data += 1;
  dc:	0905                	addi	s2,s2,1
  de:	bfa5                	j	56 <memdump+0x56>
      memcpy(&p, data, 8);
  e0:	865e                	mv	a2,s7
  e2:	85ca                	mv	a1,s2
  e4:	855a                	mv	a0,s6
  e6:	41a000ef          	jal	500 <memcpy>
      printf("%s\n", p);
  ea:	fa843583          	ld	a1,-88(s0)
  ee:	8562                	mv	a0,s8
  f0:	0a5000ef          	jal	994 <printf>
      data += 8;
  f4:	0921                	addi	s2,s2,8
  f6:	b785                	j	56 <memdump+0x56>
      printf("%s\n", data);
  f8:	85ca                	mv	a1,s2
  fa:	8562                	mv	a0,s8
  fc:	099000ef          	jal	994 <printf>
 100:	bf99                	j	56 <memdump+0x56>
    }
  }
}
 102:	60e6                	ld	ra,88(sp)
 104:	6446                	ld	s0,80(sp)
 106:	64a6                	ld	s1,72(sp)
 108:	6906                	ld	s2,64(sp)
 10a:	79e2                	ld	s3,56(sp)
 10c:	7a42                	ld	s4,48(sp)
 10e:	7aa2                	ld	s5,40(sp)
 110:	7b02                	ld	s6,32(sp)
 112:	6be2                	ld	s7,24(sp)
 114:	6c42                	ld	s8,16(sp)
 116:	6125                	addi	sp,sp,96
 118:	8082                	ret

000000000000011a <main>:
{
 11a:	db010113          	addi	sp,sp,-592
 11e:	24113423          	sd	ra,584(sp)
 122:	24813023          	sd	s0,576(sp)
 126:	22913c23          	sd	s1,568(sp)
 12a:	23213823          	sd	s2,560(sp)
 12e:	23313423          	sd	s3,552(sp)
 132:	23413023          	sd	s4,544(sp)
 136:	21513c23          	sd	s5,536(sp)
 13a:	0c80                	addi	s0,sp,592
  if(argc == 1){
 13c:	4785                	li	a5,1
 13e:	00f50f63          	beq	a0,a5,15c <main+0x42>
 142:	8aae                	mv	s5,a1
  } else if(argc == 2){
 144:	4789                	li	a5,2
 146:	0ef50f63          	beq	a0,a5,244 <main+0x12a>
    printf("Usage: memdump [format]\n");
 14a:	00001517          	auipc	a0,0x1
 14e:	ab650513          	addi	a0,a0,-1354 # c00 <malloc+0x1b4>
 152:	043000ef          	jal	994 <printf>
    exit(1);
 156:	4505                	li	a0,1
 158:	3f0000ef          	jal	548 <exit>
    printf("Example 1:\n");
 15c:	00001517          	auipc	a0,0x1
 160:	a0450513          	addi	a0,a0,-1532 # b60 <malloc+0x114>
 164:	031000ef          	jal	994 <printf>
    int a[2] = { 61810, 2025 };
 168:	67bd                	lui	a5,0xf
 16a:	17278793          	addi	a5,a5,370 # f172 <base+0xe162>
 16e:	daf42823          	sw	a5,-592(s0)
 172:	7e900793          	li	a5,2025
 176:	daf42a23          	sw	a5,-588(s0)
    memdump("ii", (char*) a);
 17a:	db040593          	addi	a1,s0,-592
 17e:	00001517          	auipc	a0,0x1
 182:	9f250513          	addi	a0,a0,-1550 # b70 <malloc+0x124>
 186:	e7bff0ef          	jal	0 <memdump>
    printf("Example 2:\n");
 18a:	00001517          	auipc	a0,0x1
 18e:	9ee50513          	addi	a0,a0,-1554 # b78 <malloc+0x12c>
 192:	003000ef          	jal	994 <printf>
    memdump("S", "a string");
 196:	00001597          	auipc	a1,0x1
 19a:	9f258593          	addi	a1,a1,-1550 # b88 <malloc+0x13c>
 19e:	00001517          	auipc	a0,0x1
 1a2:	9fa50513          	addi	a0,a0,-1542 # b98 <malloc+0x14c>
 1a6:	e5bff0ef          	jal	0 <memdump>
    printf("Example 3:\n");
 1aa:	00001517          	auipc	a0,0x1
 1ae:	9f650513          	addi	a0,a0,-1546 # ba0 <malloc+0x154>
 1b2:	7e2000ef          	jal	994 <printf>
    char *s = "another";
 1b6:	00001797          	auipc	a5,0x1
 1ba:	9fa78793          	addi	a5,a5,-1542 # bb0 <malloc+0x164>
 1be:	daf43c23          	sd	a5,-584(s0)
    memdump("s", (char *) &s);
 1c2:	db840593          	addi	a1,s0,-584
 1c6:	00001517          	auipc	a0,0x1
 1ca:	9f250513          	addi	a0,a0,-1550 # bb8 <malloc+0x16c>
 1ce:	e33ff0ef          	jal	0 <memdump>
    example.ptr = "hello";
 1d2:	00001797          	auipc	a5,0x1
 1d6:	9ee78793          	addi	a5,a5,-1554 # bc0 <malloc+0x174>
 1da:	dcf43023          	sd	a5,-576(s0)
    example.num1 = 1819438967;
 1de:	6c7277b7          	lui	a5,0x6c727
 1e2:	f7778793          	addi	a5,a5,-137 # 6c726f77 <base+0x6c725f67>
 1e6:	dcf42423          	sw	a5,-568(s0)
    example.num2 = 100;
 1ea:	06400793          	li	a5,100
 1ee:	dcf41623          	sh	a5,-564(s0)
    example.byte = 'z';
 1f2:	07a00793          	li	a5,122
 1f6:	dcf40723          	sb	a5,-562(s0)
    strcpy(example.bytes, "xyzzy");
 1fa:	dc040493          	addi	s1,s0,-576
 1fe:	00001597          	auipc	a1,0x1
 202:	9ca58593          	addi	a1,a1,-1590 # bc8 <malloc+0x17c>
 206:	dcf40513          	addi	a0,s0,-561
 20a:	098000ef          	jal	2a2 <strcpy>
    printf("Example 4:\n");
 20e:	00001517          	auipc	a0,0x1
 212:	9c250513          	addi	a0,a0,-1598 # bd0 <malloc+0x184>
 216:	77e000ef          	jal	994 <printf>
    memdump("pihcS", (char*) &example);
 21a:	85a6                	mv	a1,s1
 21c:	00001517          	auipc	a0,0x1
 220:	9c450513          	addi	a0,a0,-1596 # be0 <malloc+0x194>
 224:	dddff0ef          	jal	0 <memdump>
    printf("Example 5:\n");
 228:	00001517          	auipc	a0,0x1
 22c:	9c050513          	addi	a0,a0,-1600 # be8 <malloc+0x19c>
 230:	764000ef          	jal	994 <printf>
    memdump("sccccc", (char*) &example);
 234:	85a6                	mv	a1,s1
 236:	00001517          	auipc	a0,0x1
 23a:	9c250513          	addi	a0,a0,-1598 # bf8 <malloc+0x1ac>
 23e:	dc3ff0ef          	jal	0 <memdump>
 242:	a0a1                	j	28a <main+0x170>
    memset(data, '\0', sizeof(data));
 244:	20000613          	li	a2,512
 248:	4581                	li	a1,0
 24a:	dc040513          	addi	a0,s0,-576
 24e:	0d0000ef          	jal	31e <memset>
    int n = 0;
 252:	4481                	li	s1,0
    while(n < sizeof(data)){
 254:	4601                	li	a2,0
      int nn = read(0, data + n, sizeof(data) - n);
 256:	20000993          	li	s3,512
 25a:	dc040913          	addi	s2,s0,-576
    while(n < sizeof(data)){
 25e:	1ff00a13          	li	s4,511
      int nn = read(0, data + n, sizeof(data) - n);
 262:	40c9863b          	subw	a2,s3,a2
 266:	009905b3          	add	a1,s2,s1
 26a:	4501                	li	a0,0
 26c:	2f4000ef          	jal	560 <read>
      if(nn <= 0)
 270:	00a05763          	blez	a0,27e <main+0x164>
      n += nn;
 274:	0095063b          	addw	a2,a0,s1
 278:	84b2                	mv	s1,a2
    while(n < sizeof(data)){
 27a:	feca74e3          	bgeu	s4,a2,262 <main+0x148>
    memdump(argv[1], data);
 27e:	dc040593          	addi	a1,s0,-576
 282:	008ab503          	ld	a0,8(s5)
 286:	d7bff0ef          	jal	0 <memdump>
  exit(0);
 28a:	4501                	li	a0,0
 28c:	2bc000ef          	jal	548 <exit>

0000000000000290 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 290:	1141                	addi	sp,sp,-16
 292:	e406                	sd	ra,8(sp)
 294:	e022                	sd	s0,0(sp)
 296:	0800                	addi	s0,sp,16
  extern int main();
  main();
 298:	e83ff0ef          	jal	11a <main>
  exit(0);
 29c:	4501                	li	a0,0
 29e:	2aa000ef          	jal	548 <exit>

00000000000002a2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2a2:	1141                	addi	sp,sp,-16
 2a4:	e406                	sd	ra,8(sp)
 2a6:	e022                	sd	s0,0(sp)
 2a8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2aa:	87aa                	mv	a5,a0
 2ac:	0585                	addi	a1,a1,1
 2ae:	0785                	addi	a5,a5,1
 2b0:	fff5c703          	lbu	a4,-1(a1)
 2b4:	fee78fa3          	sb	a4,-1(a5)
 2b8:	fb75                	bnez	a4,2ac <strcpy+0xa>
    ;
  return os;
}
 2ba:	60a2                	ld	ra,8(sp)
 2bc:	6402                	ld	s0,0(sp)
 2be:	0141                	addi	sp,sp,16
 2c0:	8082                	ret

00000000000002c2 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2c2:	1141                	addi	sp,sp,-16
 2c4:	e406                	sd	ra,8(sp)
 2c6:	e022                	sd	s0,0(sp)
 2c8:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ca:	00054783          	lbu	a5,0(a0)
 2ce:	cb91                	beqz	a5,2e2 <strcmp+0x20>
 2d0:	0005c703          	lbu	a4,0(a1)
 2d4:	00f71763          	bne	a4,a5,2e2 <strcmp+0x20>
    p++, q++;
 2d8:	0505                	addi	a0,a0,1
 2da:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 2dc:	00054783          	lbu	a5,0(a0)
 2e0:	fbe5                	bnez	a5,2d0 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 2e2:	0005c503          	lbu	a0,0(a1)
}
 2e6:	40a7853b          	subw	a0,a5,a0
 2ea:	60a2                	ld	ra,8(sp)
 2ec:	6402                	ld	s0,0(sp)
 2ee:	0141                	addi	sp,sp,16
 2f0:	8082                	ret

00000000000002f2 <strlen>:

uint
strlen(const char *s)
{
 2f2:	1141                	addi	sp,sp,-16
 2f4:	e406                	sd	ra,8(sp)
 2f6:	e022                	sd	s0,0(sp)
 2f8:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 2fa:	00054783          	lbu	a5,0(a0)
 2fe:	cf91                	beqz	a5,31a <strlen+0x28>
 300:	00150793          	addi	a5,a0,1
 304:	86be                	mv	a3,a5
 306:	0785                	addi	a5,a5,1
 308:	fff7c703          	lbu	a4,-1(a5)
 30c:	ff65                	bnez	a4,304 <strlen+0x12>
 30e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 312:	60a2                	ld	ra,8(sp)
 314:	6402                	ld	s0,0(sp)
 316:	0141                	addi	sp,sp,16
 318:	8082                	ret
  for(n = 0; s[n]; n++)
 31a:	4501                	li	a0,0
 31c:	bfdd                	j	312 <strlen+0x20>

000000000000031e <memset>:

void*
memset(void *dst, int c, uint n)
{
 31e:	1141                	addi	sp,sp,-16
 320:	e406                	sd	ra,8(sp)
 322:	e022                	sd	s0,0(sp)
 324:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 326:	ca19                	beqz	a2,33c <memset+0x1e>
 328:	87aa                	mv	a5,a0
 32a:	1602                	slli	a2,a2,0x20
 32c:	9201                	srli	a2,a2,0x20
 32e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 332:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 336:	0785                	addi	a5,a5,1
 338:	fee79de3          	bne	a5,a4,332 <memset+0x14>
  }
  return dst;
}
 33c:	60a2                	ld	ra,8(sp)
 33e:	6402                	ld	s0,0(sp)
 340:	0141                	addi	sp,sp,16
 342:	8082                	ret

0000000000000344 <strchr>:

char*
strchr(const char *s, char c)
{
 344:	1141                	addi	sp,sp,-16
 346:	e406                	sd	ra,8(sp)
 348:	e022                	sd	s0,0(sp)
 34a:	0800                	addi	s0,sp,16
  for(; *s; s++)
 34c:	00054783          	lbu	a5,0(a0)
 350:	cf81                	beqz	a5,368 <strchr+0x24>
    if(*s == c)
 352:	00f58763          	beq	a1,a5,360 <strchr+0x1c>
  for(; *s; s++)
 356:	0505                	addi	a0,a0,1
 358:	00054783          	lbu	a5,0(a0)
 35c:	fbfd                	bnez	a5,352 <strchr+0xe>
      return (char*)s;
  return 0;
 35e:	4501                	li	a0,0
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret
  return 0;
 368:	4501                	li	a0,0
 36a:	bfdd                	j	360 <strchr+0x1c>

000000000000036c <gets>:

char*
gets(char *buf, int max)
{
 36c:	711d                	addi	sp,sp,-96
 36e:	ec86                	sd	ra,88(sp)
 370:	e8a2                	sd	s0,80(sp)
 372:	e4a6                	sd	s1,72(sp)
 374:	e0ca                	sd	s2,64(sp)
 376:	fc4e                	sd	s3,56(sp)
 378:	f852                	sd	s4,48(sp)
 37a:	f456                	sd	s5,40(sp)
 37c:	f05a                	sd	s6,32(sp)
 37e:	ec5e                	sd	s7,24(sp)
 380:	e862                	sd	s8,16(sp)
 382:	1080                	addi	s0,sp,96
 384:	8baa                	mv	s7,a0
 386:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 388:	892a                	mv	s2,a0
 38a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 38c:	faf40b13          	addi	s6,s0,-81
 390:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 392:	8c26                	mv	s8,s1
 394:	0014899b          	addiw	s3,s1,1
 398:	84ce                	mv	s1,s3
 39a:	0349d463          	bge	s3,s4,3c2 <gets+0x56>
    cc = read(0, &c, 1);
 39e:	8656                	mv	a2,s5
 3a0:	85da                	mv	a1,s6
 3a2:	4501                	li	a0,0
 3a4:	1bc000ef          	jal	560 <read>
    if(cc < 1)
 3a8:	00a05d63          	blez	a0,3c2 <gets+0x56>
      break;
    buf[i++] = c;
 3ac:	faf44783          	lbu	a5,-81(s0)
 3b0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3b4:	0905                	addi	s2,s2,1
 3b6:	ff678713          	addi	a4,a5,-10
 3ba:	c319                	beqz	a4,3c0 <gets+0x54>
 3bc:	17cd                	addi	a5,a5,-13
 3be:	fbf1                	bnez	a5,392 <gets+0x26>
    buf[i++] = c;
 3c0:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 3c2:	9c5e                	add	s8,s8,s7
 3c4:	000c0023          	sb	zero,0(s8)
  return buf;
}
 3c8:	855e                	mv	a0,s7
 3ca:	60e6                	ld	ra,88(sp)
 3cc:	6446                	ld	s0,80(sp)
 3ce:	64a6                	ld	s1,72(sp)
 3d0:	6906                	ld	s2,64(sp)
 3d2:	79e2                	ld	s3,56(sp)
 3d4:	7a42                	ld	s4,48(sp)
 3d6:	7aa2                	ld	s5,40(sp)
 3d8:	7b02                	ld	s6,32(sp)
 3da:	6be2                	ld	s7,24(sp)
 3dc:	6c42                	ld	s8,16(sp)
 3de:	6125                	addi	sp,sp,96
 3e0:	8082                	ret

00000000000003e2 <stat>:

int
stat(const char *n, struct stat *st)
{
 3e2:	1101                	addi	sp,sp,-32
 3e4:	ec06                	sd	ra,24(sp)
 3e6:	e822                	sd	s0,16(sp)
 3e8:	e04a                	sd	s2,0(sp)
 3ea:	1000                	addi	s0,sp,32
 3ec:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 3ee:	4581                	li	a1,0
 3f0:	198000ef          	jal	588 <open>
  if(fd < 0)
 3f4:	02054263          	bltz	a0,418 <stat+0x36>
 3f8:	e426                	sd	s1,8(sp)
 3fa:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 3fc:	85ca                	mv	a1,s2
 3fe:	1a2000ef          	jal	5a0 <fstat>
 402:	892a                	mv	s2,a0
  close(fd);
 404:	8526                	mv	a0,s1
 406:	16a000ef          	jal	570 <close>
  return r;
 40a:	64a2                	ld	s1,8(sp)
}
 40c:	854a                	mv	a0,s2
 40e:	60e2                	ld	ra,24(sp)
 410:	6442                	ld	s0,16(sp)
 412:	6902                	ld	s2,0(sp)
 414:	6105                	addi	sp,sp,32
 416:	8082                	ret
    return -1;
 418:	57fd                	li	a5,-1
 41a:	893e                	mv	s2,a5
 41c:	bfc5                	j	40c <stat+0x2a>

000000000000041e <atoi>:

int
atoi(const char *s)
{
 41e:	1141                	addi	sp,sp,-16
 420:	e406                	sd	ra,8(sp)
 422:	e022                	sd	s0,0(sp)
 424:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 426:	00054683          	lbu	a3,0(a0)
 42a:	fd06879b          	addiw	a5,a3,-48
 42e:	0ff7f793          	zext.b	a5,a5
 432:	4625                	li	a2,9
 434:	02f66963          	bltu	a2,a5,466 <atoi+0x48>
 438:	872a                	mv	a4,a0
  n = 0;
 43a:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 43c:	0705                	addi	a4,a4,1
 43e:	0025179b          	slliw	a5,a0,0x2
 442:	9fa9                	addw	a5,a5,a0
 444:	0017979b          	slliw	a5,a5,0x1
 448:	9fb5                	addw	a5,a5,a3
 44a:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 44e:	00074683          	lbu	a3,0(a4)
 452:	fd06879b          	addiw	a5,a3,-48
 456:	0ff7f793          	zext.b	a5,a5
 45a:	fef671e3          	bgeu	a2,a5,43c <atoi+0x1e>
  return n;
}
 45e:	60a2                	ld	ra,8(sp)
 460:	6402                	ld	s0,0(sp)
 462:	0141                	addi	sp,sp,16
 464:	8082                	ret
  n = 0;
 466:	4501                	li	a0,0
 468:	bfdd                	j	45e <atoi+0x40>

000000000000046a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 46a:	1141                	addi	sp,sp,-16
 46c:	e406                	sd	ra,8(sp)
 46e:	e022                	sd	s0,0(sp)
 470:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 472:	02b57563          	bgeu	a0,a1,49c <memmove+0x32>
    while(n-- > 0)
 476:	00c05f63          	blez	a2,494 <memmove+0x2a>
 47a:	1602                	slli	a2,a2,0x20
 47c:	9201                	srli	a2,a2,0x20
 47e:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 482:	872a                	mv	a4,a0
      *dst++ = *src++;
 484:	0585                	addi	a1,a1,1
 486:	0705                	addi	a4,a4,1
 488:	fff5c683          	lbu	a3,-1(a1)
 48c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 490:	fee79ae3          	bne	a5,a4,484 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 494:	60a2                	ld	ra,8(sp)
 496:	6402                	ld	s0,0(sp)
 498:	0141                	addi	sp,sp,16
 49a:	8082                	ret
    while(n-- > 0)
 49c:	fec05ce3          	blez	a2,494 <memmove+0x2a>
    dst += n;
 4a0:	00c50733          	add	a4,a0,a2
    src += n;
 4a4:	95b2                	add	a1,a1,a2
 4a6:	fff6079b          	addiw	a5,a2,-1
 4aa:	1782                	slli	a5,a5,0x20
 4ac:	9381                	srli	a5,a5,0x20
 4ae:	fff7c793          	not	a5,a5
 4b2:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4b4:	15fd                	addi	a1,a1,-1
 4b6:	177d                	addi	a4,a4,-1
 4b8:	0005c683          	lbu	a3,0(a1)
 4bc:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4c0:	fef71ae3          	bne	a4,a5,4b4 <memmove+0x4a>
 4c4:	bfc1                	j	494 <memmove+0x2a>

00000000000004c6 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4c6:	1141                	addi	sp,sp,-16
 4c8:	e406                	sd	ra,8(sp)
 4ca:	e022                	sd	s0,0(sp)
 4cc:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4ce:	c61d                	beqz	a2,4fc <memcmp+0x36>
 4d0:	1602                	slli	a2,a2,0x20
 4d2:	9201                	srli	a2,a2,0x20
 4d4:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4d8:	00054783          	lbu	a5,0(a0)
 4dc:	0005c703          	lbu	a4,0(a1)
 4e0:	00e79863          	bne	a5,a4,4f0 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 4e4:	0505                	addi	a0,a0,1
    p2++;
 4e6:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 4e8:	fed518e3          	bne	a0,a3,4d8 <memcmp+0x12>
  }
  return 0;
 4ec:	4501                	li	a0,0
 4ee:	a019                	j	4f4 <memcmp+0x2e>
      return *p1 - *p2;
 4f0:	40e7853b          	subw	a0,a5,a4
}
 4f4:	60a2                	ld	ra,8(sp)
 4f6:	6402                	ld	s0,0(sp)
 4f8:	0141                	addi	sp,sp,16
 4fa:	8082                	ret
  return 0;
 4fc:	4501                	li	a0,0
 4fe:	bfdd                	j	4f4 <memcmp+0x2e>

0000000000000500 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 500:	1141                	addi	sp,sp,-16
 502:	e406                	sd	ra,8(sp)
 504:	e022                	sd	s0,0(sp)
 506:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 508:	f63ff0ef          	jal	46a <memmove>
}
 50c:	60a2                	ld	ra,8(sp)
 50e:	6402                	ld	s0,0(sp)
 510:	0141                	addi	sp,sp,16
 512:	8082                	ret

0000000000000514 <sbrk>:

char *
sbrk(int n) {
 514:	1141                	addi	sp,sp,-16
 516:	e406                	sd	ra,8(sp)
 518:	e022                	sd	s0,0(sp)
 51a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 51c:	4585                	li	a1,1
 51e:	0b2000ef          	jal	5d0 <sys_sbrk>
}
 522:	60a2                	ld	ra,8(sp)
 524:	6402                	ld	s0,0(sp)
 526:	0141                	addi	sp,sp,16
 528:	8082                	ret

000000000000052a <sbrklazy>:

char *
sbrklazy(int n) {
 52a:	1141                	addi	sp,sp,-16
 52c:	e406                	sd	ra,8(sp)
 52e:	e022                	sd	s0,0(sp)
 530:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 532:	4589                	li	a1,2
 534:	09c000ef          	jal	5d0 <sys_sbrk>
}
 538:	60a2                	ld	ra,8(sp)
 53a:	6402                	ld	s0,0(sp)
 53c:	0141                	addi	sp,sp,16
 53e:	8082                	ret

0000000000000540 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 540:	4885                	li	a7,1
 ecall
 542:	00000073          	ecall
 ret
 546:	8082                	ret

0000000000000548 <exit>:
.global exit
exit:
 li a7, SYS_exit
 548:	4889                	li	a7,2
 ecall
 54a:	00000073          	ecall
 ret
 54e:	8082                	ret

0000000000000550 <wait>:
.global wait
wait:
 li a7, SYS_wait
 550:	488d                	li	a7,3
 ecall
 552:	00000073          	ecall
 ret
 556:	8082                	ret

0000000000000558 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 558:	4891                	li	a7,4
 ecall
 55a:	00000073          	ecall
 ret
 55e:	8082                	ret

0000000000000560 <read>:
.global read
read:
 li a7, SYS_read
 560:	4895                	li	a7,5
 ecall
 562:	00000073          	ecall
 ret
 566:	8082                	ret

0000000000000568 <write>:
.global write
write:
 li a7, SYS_write
 568:	48c1                	li	a7,16
 ecall
 56a:	00000073          	ecall
 ret
 56e:	8082                	ret

0000000000000570 <close>:
.global close
close:
 li a7, SYS_close
 570:	48d5                	li	a7,21
 ecall
 572:	00000073          	ecall
 ret
 576:	8082                	ret

0000000000000578 <kill>:
.global kill
kill:
 li a7, SYS_kill
 578:	4899                	li	a7,6
 ecall
 57a:	00000073          	ecall
 ret
 57e:	8082                	ret

0000000000000580 <exec>:
.global exec
exec:
 li a7, SYS_exec
 580:	489d                	li	a7,7
 ecall
 582:	00000073          	ecall
 ret
 586:	8082                	ret

0000000000000588 <open>:
.global open
open:
 li a7, SYS_open
 588:	48bd                	li	a7,15
 ecall
 58a:	00000073          	ecall
 ret
 58e:	8082                	ret

0000000000000590 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 590:	48c5                	li	a7,17
 ecall
 592:	00000073          	ecall
 ret
 596:	8082                	ret

0000000000000598 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 598:	48c9                	li	a7,18
 ecall
 59a:	00000073          	ecall
 ret
 59e:	8082                	ret

00000000000005a0 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5a0:	48a1                	li	a7,8
 ecall
 5a2:	00000073          	ecall
 ret
 5a6:	8082                	ret

00000000000005a8 <link>:
.global link
link:
 li a7, SYS_link
 5a8:	48cd                	li	a7,19
 ecall
 5aa:	00000073          	ecall
 ret
 5ae:	8082                	ret

00000000000005b0 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5b0:	48d1                	li	a7,20
 ecall
 5b2:	00000073          	ecall
 ret
 5b6:	8082                	ret

00000000000005b8 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5b8:	48a5                	li	a7,9
 ecall
 5ba:	00000073          	ecall
 ret
 5be:	8082                	ret

00000000000005c0 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5c0:	48a9                	li	a7,10
 ecall
 5c2:	00000073          	ecall
 ret
 5c6:	8082                	ret

00000000000005c8 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5c8:	48ad                	li	a7,11
 ecall
 5ca:	00000073          	ecall
 ret
 5ce:	8082                	ret

00000000000005d0 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5d0:	48b1                	li	a7,12
 ecall
 5d2:	00000073          	ecall
 ret
 5d6:	8082                	ret

00000000000005d8 <pause>:
.global pause
pause:
 li a7, SYS_pause
 5d8:	48b5                	li	a7,13
 ecall
 5da:	00000073          	ecall
 ret
 5de:	8082                	ret

00000000000005e0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 5e0:	48b9                	li	a7,14
 ecall
 5e2:	00000073          	ecall
 ret
 5e6:	8082                	ret

00000000000005e8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 5e8:	1101                	addi	sp,sp,-32
 5ea:	ec06                	sd	ra,24(sp)
 5ec:	e822                	sd	s0,16(sp)
 5ee:	1000                	addi	s0,sp,32
 5f0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 5f4:	4605                	li	a2,1
 5f6:	fef40593          	addi	a1,s0,-17
 5fa:	f6fff0ef          	jal	568 <write>
}
 5fe:	60e2                	ld	ra,24(sp)
 600:	6442                	ld	s0,16(sp)
 602:	6105                	addi	sp,sp,32
 604:	8082                	ret

0000000000000606 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 606:	715d                	addi	sp,sp,-80
 608:	e486                	sd	ra,72(sp)
 60a:	e0a2                	sd	s0,64(sp)
 60c:	f84a                	sd	s2,48(sp)
 60e:	f44e                	sd	s3,40(sp)
 610:	0880                	addi	s0,sp,80
 612:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 614:	cac1                	beqz	a3,6a4 <printint+0x9e>
 616:	0805d763          	bgez	a1,6a4 <printint+0x9e>
    neg = 1;
    x = -xx;
 61a:	40b005bb          	negw	a1,a1
    neg = 1;
 61e:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 620:	fb840993          	addi	s3,s0,-72
  neg = 0;
 624:	86ce                	mv	a3,s3
  i = 0;
 626:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 628:	00000817          	auipc	a6,0x0
 62c:	68880813          	addi	a6,a6,1672 # cb0 <digits>
 630:	88ba                	mv	a7,a4
 632:	0017051b          	addiw	a0,a4,1
 636:	872a                	mv	a4,a0
 638:	02c5f7bb          	remuw	a5,a1,a2
 63c:	1782                	slli	a5,a5,0x20
 63e:	9381                	srli	a5,a5,0x20
 640:	97c2                	add	a5,a5,a6
 642:	0007c783          	lbu	a5,0(a5)
 646:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 64a:	87ae                	mv	a5,a1
 64c:	02c5d5bb          	divuw	a1,a1,a2
 650:	0685                	addi	a3,a3,1
 652:	fcc7ffe3          	bgeu	a5,a2,630 <printint+0x2a>
  if(neg)
 656:	00030c63          	beqz	t1,66e <printint+0x68>
    buf[i++] = '-';
 65a:	fd050793          	addi	a5,a0,-48
 65e:	00878533          	add	a0,a5,s0
 662:	02d00793          	li	a5,45
 666:	fef50423          	sb	a5,-24(a0)
 66a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 66e:	02e05563          	blez	a4,698 <printint+0x92>
 672:	fc26                	sd	s1,56(sp)
 674:	377d                	addiw	a4,a4,-1
 676:	00e984b3          	add	s1,s3,a4
 67a:	19fd                	addi	s3,s3,-1
 67c:	99ba                	add	s3,s3,a4
 67e:	1702                	slli	a4,a4,0x20
 680:	9301                	srli	a4,a4,0x20
 682:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 686:	0004c583          	lbu	a1,0(s1)
 68a:	854a                	mv	a0,s2
 68c:	f5dff0ef          	jal	5e8 <putc>
  while(--i >= 0)
 690:	14fd                	addi	s1,s1,-1
 692:	ff349ae3          	bne	s1,s3,686 <printint+0x80>
 696:	74e2                	ld	s1,56(sp)
}
 698:	60a6                	ld	ra,72(sp)
 69a:	6406                	ld	s0,64(sp)
 69c:	7942                	ld	s2,48(sp)
 69e:	79a2                	ld	s3,40(sp)
 6a0:	6161                	addi	sp,sp,80
 6a2:	8082                	ret
    x = xx;
 6a4:	2581                	sext.w	a1,a1
  neg = 0;
 6a6:	4301                	li	t1,0
 6a8:	bfa5                	j	620 <printint+0x1a>

00000000000006aa <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6aa:	711d                	addi	sp,sp,-96
 6ac:	ec86                	sd	ra,88(sp)
 6ae:	e8a2                	sd	s0,80(sp)
 6b0:	e4a6                	sd	s1,72(sp)
 6b2:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6b4:	0005c483          	lbu	s1,0(a1)
 6b8:	22048363          	beqz	s1,8de <vprintf+0x234>
 6bc:	e0ca                	sd	s2,64(sp)
 6be:	fc4e                	sd	s3,56(sp)
 6c0:	f852                	sd	s4,48(sp)
 6c2:	f456                	sd	s5,40(sp)
 6c4:	f05a                	sd	s6,32(sp)
 6c6:	ec5e                	sd	s7,24(sp)
 6c8:	e862                	sd	s8,16(sp)
 6ca:	8b2a                	mv	s6,a0
 6cc:	8a2e                	mv	s4,a1
 6ce:	8bb2                	mv	s7,a2
  state = 0;
 6d0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6d2:	4901                	li	s2,0
 6d4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6d6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6da:	06400c13          	li	s8,100
 6de:	a00d                	j	700 <vprintf+0x56>
        putc(fd, c0);
 6e0:	85a6                	mv	a1,s1
 6e2:	855a                	mv	a0,s6
 6e4:	f05ff0ef          	jal	5e8 <putc>
 6e8:	a019                	j	6ee <vprintf+0x44>
    } else if(state == '%'){
 6ea:	03598363          	beq	s3,s5,710 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 6ee:	0019079b          	addiw	a5,s2,1
 6f2:	893e                	mv	s2,a5
 6f4:	873e                	mv	a4,a5
 6f6:	97d2                	add	a5,a5,s4
 6f8:	0007c483          	lbu	s1,0(a5)
 6fc:	1c048a63          	beqz	s1,8d0 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 700:	0004879b          	sext.w	a5,s1
    if(state == 0){
 704:	fe0993e3          	bnez	s3,6ea <vprintf+0x40>
      if(c0 == '%'){
 708:	fd579ce3          	bne	a5,s5,6e0 <vprintf+0x36>
        state = '%';
 70c:	89be                	mv	s3,a5
 70e:	b7c5                	j	6ee <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 710:	00ea06b3          	add	a3,s4,a4
 714:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 718:	1c060863          	beqz	a2,8e8 <vprintf+0x23e>
      if(c0 == 'd'){
 71c:	03878763          	beq	a5,s8,74a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 720:	f9478693          	addi	a3,a5,-108
 724:	0016b693          	seqz	a3,a3
 728:	f9c60593          	addi	a1,a2,-100
 72c:	e99d                	bnez	a1,762 <vprintf+0xb8>
 72e:	ca95                	beqz	a3,762 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 730:	008b8493          	addi	s1,s7,8
 734:	4685                	li	a3,1
 736:	4629                	li	a2,10
 738:	000bb583          	ld	a1,0(s7)
 73c:	855a                	mv	a0,s6
 73e:	ec9ff0ef          	jal	606 <printint>
        i += 1;
 742:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 744:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 746:	4981                	li	s3,0
 748:	b75d                	j	6ee <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 74a:	008b8493          	addi	s1,s7,8
 74e:	4685                	li	a3,1
 750:	4629                	li	a2,10
 752:	000ba583          	lw	a1,0(s7)
 756:	855a                	mv	a0,s6
 758:	eafff0ef          	jal	606 <printint>
 75c:	8ba6                	mv	s7,s1
      state = 0;
 75e:	4981                	li	s3,0
 760:	b779                	j	6ee <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 762:	9752                	add	a4,a4,s4
 764:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 768:	f9460713          	addi	a4,a2,-108
 76c:	00173713          	seqz	a4,a4
 770:	8f75                	and	a4,a4,a3
 772:	f9c58513          	addi	a0,a1,-100
 776:	18051363          	bnez	a0,8fc <vprintf+0x252>
 77a:	18070163          	beqz	a4,8fc <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 77e:	008b8493          	addi	s1,s7,8
 782:	4685                	li	a3,1
 784:	4629                	li	a2,10
 786:	000bb583          	ld	a1,0(s7)
 78a:	855a                	mv	a0,s6
 78c:	e7bff0ef          	jal	606 <printint>
        i += 2;
 790:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 792:	8ba6                	mv	s7,s1
      state = 0;
 794:	4981                	li	s3,0
        i += 2;
 796:	bfa1                	j	6ee <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 798:	008b8493          	addi	s1,s7,8
 79c:	4681                	li	a3,0
 79e:	4629                	li	a2,10
 7a0:	000be583          	lwu	a1,0(s7)
 7a4:	855a                	mv	a0,s6
 7a6:	e61ff0ef          	jal	606 <printint>
 7aa:	8ba6                	mv	s7,s1
      state = 0;
 7ac:	4981                	li	s3,0
 7ae:	b781                	j	6ee <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7b0:	008b8493          	addi	s1,s7,8
 7b4:	4681                	li	a3,0
 7b6:	4629                	li	a2,10
 7b8:	000bb583          	ld	a1,0(s7)
 7bc:	855a                	mv	a0,s6
 7be:	e49ff0ef          	jal	606 <printint>
        i += 1;
 7c2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7c4:	8ba6                	mv	s7,s1
      state = 0;
 7c6:	4981                	li	s3,0
 7c8:	b71d                	j	6ee <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ca:	008b8493          	addi	s1,s7,8
 7ce:	4681                	li	a3,0
 7d0:	4629                	li	a2,10
 7d2:	000bb583          	ld	a1,0(s7)
 7d6:	855a                	mv	a0,s6
 7d8:	e2fff0ef          	jal	606 <printint>
        i += 2;
 7dc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 7de:	8ba6                	mv	s7,s1
      state = 0;
 7e0:	4981                	li	s3,0
        i += 2;
 7e2:	b731                	j	6ee <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 7e4:	008b8493          	addi	s1,s7,8
 7e8:	4681                	li	a3,0
 7ea:	4641                	li	a2,16
 7ec:	000be583          	lwu	a1,0(s7)
 7f0:	855a                	mv	a0,s6
 7f2:	e15ff0ef          	jal	606 <printint>
 7f6:	8ba6                	mv	s7,s1
      state = 0;
 7f8:	4981                	li	s3,0
 7fa:	bdd5                	j	6ee <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 7fc:	008b8493          	addi	s1,s7,8
 800:	4681                	li	a3,0
 802:	4641                	li	a2,16
 804:	000bb583          	ld	a1,0(s7)
 808:	855a                	mv	a0,s6
 80a:	dfdff0ef          	jal	606 <printint>
        i += 1;
 80e:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 810:	8ba6                	mv	s7,s1
      state = 0;
 812:	4981                	li	s3,0
 814:	bde9                	j	6ee <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 816:	008b8493          	addi	s1,s7,8
 81a:	4681                	li	a3,0
 81c:	4641                	li	a2,16
 81e:	000bb583          	ld	a1,0(s7)
 822:	855a                	mv	a0,s6
 824:	de3ff0ef          	jal	606 <printint>
        i += 2;
 828:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 82a:	8ba6                	mv	s7,s1
      state = 0;
 82c:	4981                	li	s3,0
        i += 2;
 82e:	b5c1                	j	6ee <vprintf+0x44>
 830:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 832:	008b8793          	addi	a5,s7,8
 836:	8cbe                	mv	s9,a5
 838:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 83c:	03000593          	li	a1,48
 840:	855a                	mv	a0,s6
 842:	da7ff0ef          	jal	5e8 <putc>
  putc(fd, 'x');
 846:	07800593          	li	a1,120
 84a:	855a                	mv	a0,s6
 84c:	d9dff0ef          	jal	5e8 <putc>
 850:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 852:	00000b97          	auipc	s7,0x0
 856:	45eb8b93          	addi	s7,s7,1118 # cb0 <digits>
 85a:	03c9d793          	srli	a5,s3,0x3c
 85e:	97de                	add	a5,a5,s7
 860:	0007c583          	lbu	a1,0(a5)
 864:	855a                	mv	a0,s6
 866:	d83ff0ef          	jal	5e8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 86a:	0992                	slli	s3,s3,0x4
 86c:	34fd                	addiw	s1,s1,-1
 86e:	f4f5                	bnez	s1,85a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 870:	8be6                	mv	s7,s9
      state = 0;
 872:	4981                	li	s3,0
 874:	6ca2                	ld	s9,8(sp)
 876:	bda5                	j	6ee <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 878:	008b8493          	addi	s1,s7,8
 87c:	000bc583          	lbu	a1,0(s7)
 880:	855a                	mv	a0,s6
 882:	d67ff0ef          	jal	5e8 <putc>
 886:	8ba6                	mv	s7,s1
      state = 0;
 888:	4981                	li	s3,0
 88a:	b595                	j	6ee <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 88c:	008b8993          	addi	s3,s7,8
 890:	000bb483          	ld	s1,0(s7)
 894:	cc91                	beqz	s1,8b0 <vprintf+0x206>
        for(; *s; s++)
 896:	0004c583          	lbu	a1,0(s1)
 89a:	c985                	beqz	a1,8ca <vprintf+0x220>
          putc(fd, *s);
 89c:	855a                	mv	a0,s6
 89e:	d4bff0ef          	jal	5e8 <putc>
        for(; *s; s++)
 8a2:	0485                	addi	s1,s1,1
 8a4:	0004c583          	lbu	a1,0(s1)
 8a8:	f9f5                	bnez	a1,89c <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 8aa:	8bce                	mv	s7,s3
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	b581                	j	6ee <vprintf+0x44>
          s = "(null)";
 8b0:	00000497          	auipc	s1,0x0
 8b4:	37048493          	addi	s1,s1,880 # c20 <malloc+0x1d4>
        for(; *s; s++)
 8b8:	02800593          	li	a1,40
 8bc:	b7c5                	j	89c <vprintf+0x1f2>
        putc(fd, '%');
 8be:	85be                	mv	a1,a5
 8c0:	855a                	mv	a0,s6
 8c2:	d27ff0ef          	jal	5e8 <putc>
      state = 0;
 8c6:	4981                	li	s3,0
 8c8:	b51d                	j	6ee <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 8ca:	8bce                	mv	s7,s3
      state = 0;
 8cc:	4981                	li	s3,0
 8ce:	b505                	j	6ee <vprintf+0x44>
 8d0:	6906                	ld	s2,64(sp)
 8d2:	79e2                	ld	s3,56(sp)
 8d4:	7a42                	ld	s4,48(sp)
 8d6:	7aa2                	ld	s5,40(sp)
 8d8:	7b02                	ld	s6,32(sp)
 8da:	6be2                	ld	s7,24(sp)
 8dc:	6c42                	ld	s8,16(sp)
    }
  }
}
 8de:	60e6                	ld	ra,88(sp)
 8e0:	6446                	ld	s0,80(sp)
 8e2:	64a6                	ld	s1,72(sp)
 8e4:	6125                	addi	sp,sp,96
 8e6:	8082                	ret
      if(c0 == 'd'){
 8e8:	06400713          	li	a4,100
 8ec:	e4e78fe3          	beq	a5,a4,74a <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 8f0:	f9478693          	addi	a3,a5,-108
 8f4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 8f8:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 8fa:	4701                	li	a4,0
      } else if(c0 == 'u'){
 8fc:	07500513          	li	a0,117
 900:	e8a78ce3          	beq	a5,a0,798 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 904:	f8b60513          	addi	a0,a2,-117
 908:	e119                	bnez	a0,90e <vprintf+0x264>
 90a:	ea0693e3          	bnez	a3,7b0 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 90e:	f8b58513          	addi	a0,a1,-117
 912:	e119                	bnez	a0,918 <vprintf+0x26e>
 914:	ea071be3          	bnez	a4,7ca <vprintf+0x120>
      } else if(c0 == 'x'){
 918:	07800513          	li	a0,120
 91c:	eca784e3          	beq	a5,a0,7e4 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 920:	f8860613          	addi	a2,a2,-120
 924:	e219                	bnez	a2,92a <vprintf+0x280>
 926:	ec069be3          	bnez	a3,7fc <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 92a:	f8858593          	addi	a1,a1,-120
 92e:	e199                	bnez	a1,934 <vprintf+0x28a>
 930:	ee0713e3          	bnez	a4,816 <vprintf+0x16c>
      } else if(c0 == 'p'){
 934:	07000713          	li	a4,112
 938:	eee78ce3          	beq	a5,a4,830 <vprintf+0x186>
      } else if(c0 == 'c'){
 93c:	06300713          	li	a4,99
 940:	f2e78ce3          	beq	a5,a4,878 <vprintf+0x1ce>
      } else if(c0 == 's'){
 944:	07300713          	li	a4,115
 948:	f4e782e3          	beq	a5,a4,88c <vprintf+0x1e2>
      } else if(c0 == '%'){
 94c:	02500713          	li	a4,37
 950:	f6e787e3          	beq	a5,a4,8be <vprintf+0x214>
        putc(fd, '%');
 954:	02500593          	li	a1,37
 958:	855a                	mv	a0,s6
 95a:	c8fff0ef          	jal	5e8 <putc>
        putc(fd, c0);
 95e:	85a6                	mv	a1,s1
 960:	855a                	mv	a0,s6
 962:	c87ff0ef          	jal	5e8 <putc>
      state = 0;
 966:	4981                	li	s3,0
 968:	b359                	j	6ee <vprintf+0x44>

000000000000096a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 96a:	715d                	addi	sp,sp,-80
 96c:	ec06                	sd	ra,24(sp)
 96e:	e822                	sd	s0,16(sp)
 970:	1000                	addi	s0,sp,32
 972:	e010                	sd	a2,0(s0)
 974:	e414                	sd	a3,8(s0)
 976:	e818                	sd	a4,16(s0)
 978:	ec1c                	sd	a5,24(s0)
 97a:	03043023          	sd	a6,32(s0)
 97e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 982:	8622                	mv	a2,s0
 984:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 988:	d23ff0ef          	jal	6aa <vprintf>
}
 98c:	60e2                	ld	ra,24(sp)
 98e:	6442                	ld	s0,16(sp)
 990:	6161                	addi	sp,sp,80
 992:	8082                	ret

0000000000000994 <printf>:

void
printf(const char *fmt, ...)
{
 994:	711d                	addi	sp,sp,-96
 996:	ec06                	sd	ra,24(sp)
 998:	e822                	sd	s0,16(sp)
 99a:	1000                	addi	s0,sp,32
 99c:	e40c                	sd	a1,8(s0)
 99e:	e810                	sd	a2,16(s0)
 9a0:	ec14                	sd	a3,24(s0)
 9a2:	f018                	sd	a4,32(s0)
 9a4:	f41c                	sd	a5,40(s0)
 9a6:	03043823          	sd	a6,48(s0)
 9aa:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9ae:	00840613          	addi	a2,s0,8
 9b2:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9b6:	85aa                	mv	a1,a0
 9b8:	4505                	li	a0,1
 9ba:	cf1ff0ef          	jal	6aa <vprintf>
}
 9be:	60e2                	ld	ra,24(sp)
 9c0:	6442                	ld	s0,16(sp)
 9c2:	6125                	addi	sp,sp,96
 9c4:	8082                	ret

00000000000009c6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9c6:	1141                	addi	sp,sp,-16
 9c8:	e406                	sd	ra,8(sp)
 9ca:	e022                	sd	s0,0(sp)
 9cc:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9ce:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9d2:	00000797          	auipc	a5,0x0
 9d6:	62e7b783          	ld	a5,1582(a5) # 1000 <freep>
 9da:	a039                	j	9e8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9dc:	6398                	ld	a4,0(a5)
 9de:	00e7e463          	bltu	a5,a4,9e6 <free+0x20>
 9e2:	00e6ea63          	bltu	a3,a4,9f6 <free+0x30>
{
 9e6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9e8:	fed7fae3          	bgeu	a5,a3,9dc <free+0x16>
 9ec:	6398                	ld	a4,0(a5)
 9ee:	00e6e463          	bltu	a3,a4,9f6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 9f2:	fee7eae3          	bltu	a5,a4,9e6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 9f6:	ff852583          	lw	a1,-8(a0)
 9fa:	6390                	ld	a2,0(a5)
 9fc:	02059813          	slli	a6,a1,0x20
 a00:	01c85713          	srli	a4,a6,0x1c
 a04:	9736                	add	a4,a4,a3
 a06:	02e60563          	beq	a2,a4,a30 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a0a:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a0e:	4790                	lw	a2,8(a5)
 a10:	02061593          	slli	a1,a2,0x20
 a14:	01c5d713          	srli	a4,a1,0x1c
 a18:	973e                	add	a4,a4,a5
 a1a:	02e68263          	beq	a3,a4,a3e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a1e:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a20:	00000717          	auipc	a4,0x0
 a24:	5ef73023          	sd	a5,1504(a4) # 1000 <freep>
}
 a28:	60a2                	ld	ra,8(sp)
 a2a:	6402                	ld	s0,0(sp)
 a2c:	0141                	addi	sp,sp,16
 a2e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a30:	4618                	lw	a4,8(a2)
 a32:	9f2d                	addw	a4,a4,a1
 a34:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a38:	6398                	ld	a4,0(a5)
 a3a:	6310                	ld	a2,0(a4)
 a3c:	b7f9                	j	a0a <free+0x44>
    p->s.size += bp->s.size;
 a3e:	ff852703          	lw	a4,-8(a0)
 a42:	9f31                	addw	a4,a4,a2
 a44:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a46:	ff053683          	ld	a3,-16(a0)
 a4a:	bfd1                	j	a1e <free+0x58>

0000000000000a4c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a4c:	7139                	addi	sp,sp,-64
 a4e:	fc06                	sd	ra,56(sp)
 a50:	f822                	sd	s0,48(sp)
 a52:	f04a                	sd	s2,32(sp)
 a54:	ec4e                	sd	s3,24(sp)
 a56:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a58:	02051993          	slli	s3,a0,0x20
 a5c:	0209d993          	srli	s3,s3,0x20
 a60:	09bd                	addi	s3,s3,15
 a62:	0049d993          	srli	s3,s3,0x4
 a66:	2985                	addiw	s3,s3,1
 a68:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a6a:	00000517          	auipc	a0,0x0
 a6e:	59653503          	ld	a0,1430(a0) # 1000 <freep>
 a72:	c905                	beqz	a0,aa2 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a74:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a76:	4798                	lw	a4,8(a5)
 a78:	09377663          	bgeu	a4,s3,b04 <malloc+0xb8>
 a7c:	f426                	sd	s1,40(sp)
 a7e:	e852                	sd	s4,16(sp)
 a80:	e456                	sd	s5,8(sp)
 a82:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 a84:	8a4e                	mv	s4,s3
 a86:	6705                	lui	a4,0x1
 a88:	00e9f363          	bgeu	s3,a4,a8e <malloc+0x42>
 a8c:	6a05                	lui	s4,0x1
 a8e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 a92:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 a96:	00000497          	auipc	s1,0x0
 a9a:	56a48493          	addi	s1,s1,1386 # 1000 <freep>
  if(p == SBRK_ERROR)
 a9e:	5afd                	li	s5,-1
 aa0:	a83d                	j	ade <malloc+0x92>
 aa2:	f426                	sd	s1,40(sp)
 aa4:	e852                	sd	s4,16(sp)
 aa6:	e456                	sd	s5,8(sp)
 aa8:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 aaa:	00000797          	auipc	a5,0x0
 aae:	56678793          	addi	a5,a5,1382 # 1010 <base>
 ab2:	00000717          	auipc	a4,0x0
 ab6:	54f73723          	sd	a5,1358(a4) # 1000 <freep>
 aba:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 abc:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ac0:	b7d1                	j	a84 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 ac2:	6398                	ld	a4,0(a5)
 ac4:	e118                	sd	a4,0(a0)
 ac6:	a899                	j	b1c <malloc+0xd0>
  hp->s.size = nu;
 ac8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 acc:	0541                	addi	a0,a0,16
 ace:	ef9ff0ef          	jal	9c6 <free>
  return freep;
 ad2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 ad4:	c125                	beqz	a0,b34 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 ad6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 ad8:	4798                	lw	a4,8(a5)
 ada:	03277163          	bgeu	a4,s2,afc <malloc+0xb0>
    if(p == freep)
 ade:	6098                	ld	a4,0(s1)
 ae0:	853e                	mv	a0,a5
 ae2:	fef71ae3          	bne	a4,a5,ad6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ae6:	8552                	mv	a0,s4
 ae8:	a2dff0ef          	jal	514 <sbrk>
  if(p == SBRK_ERROR)
 aec:	fd551ee3          	bne	a0,s5,ac8 <malloc+0x7c>
        return 0;
 af0:	4501                	li	a0,0
 af2:	74a2                	ld	s1,40(sp)
 af4:	6a42                	ld	s4,16(sp)
 af6:	6aa2                	ld	s5,8(sp)
 af8:	6b02                	ld	s6,0(sp)
 afa:	a03d                	j	b28 <malloc+0xdc>
 afc:	74a2                	ld	s1,40(sp)
 afe:	6a42                	ld	s4,16(sp)
 b00:	6aa2                	ld	s5,8(sp)
 b02:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b04:	fae90fe3          	beq	s2,a4,ac2 <malloc+0x76>
        p->s.size -= nunits;
 b08:	4137073b          	subw	a4,a4,s3
 b0c:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b0e:	02071693          	slli	a3,a4,0x20
 b12:	01c6d713          	srli	a4,a3,0x1c
 b16:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b18:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b1c:	00000717          	auipc	a4,0x0
 b20:	4ea73223          	sd	a0,1252(a4) # 1000 <freep>
      return (void*)(p + 1);
 b24:	01078513          	addi	a0,a5,16
  }
}
 b28:	70e2                	ld	ra,56(sp)
 b2a:	7442                	ld	s0,48(sp)
 b2c:	7902                	ld	s2,32(sp)
 b2e:	69e2                	ld	s3,24(sp)
 b30:	6121                	addi	sp,sp,64
 b32:	8082                	ret
 b34:	74a2                	ld	s1,40(sp)
 b36:	6a42                	ld	s4,16(sp)
 b38:	6aa2                	ld	s5,8(sp)
 b3a:	6b02                	ld	s6,0(sp)
 b3c:	b7f5                	j	b28 <malloc+0xdc>
