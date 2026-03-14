
user/_kalloctest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <ntas>:
  test4();
  exit(0);
}

int ntas(int print)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
  int n;
  char *c;

  if (statistics(buf, SZ) <= 0) {
   e:	6585                	lui	a1,0x1
  10:	00002517          	auipc	a0,0x2
  14:	00050513          	mv	a0,a0
  18:	707000ef          	jal	f1e <statistics>
  1c:	02a05763          	blez	a0,4a <ntas+0x4a>
    fprintf(2, "ntas: no stats\n");
  }
  c = strchr(buf, '=');
  20:	03d00593          	li	a1,61
  24:	00002517          	auipc	a0,0x2
  28:	fec50513          	addi	a0,a0,-20 # 2010 <buf>
  2c:	6b4000ef          	jal	6e0 <strchr>
  n = atoi(c+2);
  30:	0509                	addi	a0,a0,2
  32:	788000ef          	jal	7ba <atoi>
  36:	84aa                	mv	s1,a0
  if(print)
  38:	02091163          	bnez	s2,5a <ntas+0x5a>
    printf("%s", buf);
  return n;
}
  3c:	8526                	mv	a0,s1
  3e:	60e2                	ld	ra,24(sp)
  40:	6442                	ld	s0,16(sp)
  42:	64a2                	ld	s1,8(sp)
  44:	6902                	ld	s2,0(sp)
  46:	6105                	addi	sp,sp,32
  48:	8082                	ret
    fprintf(2, "ntas: no stats\n");
  4a:	00001597          	auipc	a1,0x1
  4e:	f4658593          	addi	a1,a1,-186 # f90 <statistics+0x72>
  52:	4509                	li	a0,2
  54:	4f7000ef          	jal	d4a <fprintf>
  58:	b7e1                	j	20 <ntas+0x20>
    printf("%s", buf);
  5a:	00002597          	auipc	a1,0x2
  5e:	fb658593          	addi	a1,a1,-74 # 2010 <buf>
  62:	00001517          	auipc	a0,0x1
  66:	f3e50513          	addi	a0,a0,-194 # fa0 <statistics+0x82>
  6a:	50b000ef          	jal	d74 <printf>
  6e:	b7f9                	j	3c <ntas+0x3c>

0000000000000070 <test1>:

// Test concurrent kallocs and kfrees
void test1(void)
{
  70:	715d                	addi	sp,sp,-80
  72:	e486                	sd	ra,72(sp)
  74:	e0a2                	sd	s0,64(sp)
  76:	fc26                	sd	s1,56(sp)
  78:	0880                	addi	s0,sp,80
  void *a, *a1;
  int n, m;

  printf("start test1\n");  
  7a:	00001517          	auipc	a0,0x1
  7e:	f2e50513          	addi	a0,a0,-210 # fa8 <statistics+0x8a>
  82:	4f3000ef          	jal	d74 <printf>
  m = ntas(0);
  86:	4501                	li	a0,0
  88:	f79ff0ef          	jal	0 <ntas>
  8c:	84aa                	mv	s1,a0
  for(int i = 0; i < NCHILD; i++){
    int pid = fork();
  8e:	04f000ef          	jal	8dc <fork>
    if(pid < 0){
  92:	06054063          	bltz	a0,f2 <test1+0x82>
      printf("fork failed");
      exit(-1);
    }
    if(pid == 0){
  96:	c93d                	beqz	a0,10c <test1+0x9c>
    int pid = fork();
  98:	045000ef          	jal	8dc <fork>
    if(pid < 0){
  9c:	04054b63          	bltz	a0,f2 <test1+0x82>
    if(pid == 0){
  a0:	c535                	beqz	a0,10c <test1+0x9c>
        }
      }
      exit(0);
    }
  }
  int status = 0;
  a2:	fa042e23          	sw	zero,-68(s0)
  for(int i = 0; i < NCHILD; i++){
    wait(&status);
  a6:	fbc40513          	addi	a0,s0,-68
  aa:	043000ef          	jal	8ec <wait>
    if (status != 0) {
  ae:	fbc42783          	lw	a5,-68(s0)
  b2:	e3d5                	bnez	a5,156 <test1+0xe6>
    wait(&status);
  b4:	fbc40513          	addi	a0,s0,-68
  b8:	035000ef          	jal	8ec <wait>
    if (status != 0) {
  bc:	fbc42783          	lw	a5,-68(s0)
  c0:	ebd9                	bnez	a5,156 <test1+0xe6>
      printf("FAIL: a child failed\n");
      exit(1);
    }
  }
  printf("test1 results:\n");
  c2:	00001517          	auipc	a0,0x1
  c6:	f3650513          	addi	a0,a0,-202 # ff8 <statistics+0xda>
  ca:	4ab000ef          	jal	d74 <printf>
  n = ntas(1);
  ce:	4505                	li	a0,1
  d0:	f31ff0ef          	jal	0 <ntas>
  if(n-m < 10) 
  d4:	9d05                	subw	a0,a0,s1
  d6:	47a5                	li	a5,9
  d8:	08a7cc63          	blt	a5,a0,170 <test1+0x100>
    printf("test1 OK\n");
  dc:	00001517          	auipc	a0,0x1
  e0:	f2c50513          	addi	a0,a0,-212 # 1008 <statistics+0xea>
  e4:	491000ef          	jal	d74 <printf>
  else
    printf("test1 FAIL\n");
}
  e8:	60a6                	ld	ra,72(sp)
  ea:	6406                	ld	s0,64(sp)
  ec:	74e2                	ld	s1,56(sp)
  ee:	6161                	addi	sp,sp,80
  f0:	8082                	ret
  f2:	f84a                	sd	s2,48(sp)
  f4:	f44e                	sd	s3,40(sp)
  f6:	f052                	sd	s4,32(sp)
  f8:	ec56                	sd	s5,24(sp)
      printf("fork failed");
  fa:	00001517          	auipc	a0,0x1
  fe:	ebe50513          	addi	a0,a0,-322 # fb8 <statistics+0x9a>
 102:	473000ef          	jal	d74 <printf>
      exit(-1);
 106:	557d                	li	a0,-1
 108:	7dc000ef          	jal	8e4 <exit>
 10c:	f84a                	sd	s2,48(sp)
 10e:	f44e                	sd	s3,40(sp)
 110:	f052                	sd	s4,32(sp)
 112:	ec56                	sd	s5,24(sp)
{
 114:	6961                	lui	s2,0x18
 116:	6a090913          	addi	s2,s2,1696 # 186a0 <base+0x15690>
        a = sbrk(4096);
 11a:	6985                	lui	s3,0x1
        *(int *)(a+4) = 1;
 11c:	4a85                	li	s5,1
        a1 = sbrk(-4096);
 11e:	7a7d                	lui	s4,0xfffff
        a = sbrk(4096);
 120:	854e                	mv	a0,s3
 122:	78e000ef          	jal	8b0 <sbrk>
 126:	84aa                	mv	s1,a0
        *(int *)(a+4) = 1;
 128:	01552223          	sw	s5,4(a0)
        a1 = sbrk(-4096);
 12c:	8552                	mv	a0,s4
 12e:	782000ef          	jal	8b0 <sbrk>
        if (a1 != a + 4096) {
 132:	94ce                	add	s1,s1,s3
 134:	00951863          	bne	a0,s1,144 <test1+0xd4>
      for(i = 0; i < N1; i++) {
 138:	397d                	addiw	s2,s2,-1
 13a:	fe0913e3          	bnez	s2,120 <test1+0xb0>
      exit(0);
 13e:	4501                	li	a0,0
 140:	7a4000ef          	jal	8e4 <exit>
          printf("test1: FAIL wrong sbrk\n");
 144:	00001517          	auipc	a0,0x1
 148:	e8450513          	addi	a0,a0,-380 # fc8 <statistics+0xaa>
 14c:	429000ef          	jal	d74 <printf>
          exit(1);
 150:	4505                	li	a0,1
 152:	792000ef          	jal	8e4 <exit>
 156:	f84a                	sd	s2,48(sp)
 158:	f44e                	sd	s3,40(sp)
 15a:	f052                	sd	s4,32(sp)
 15c:	ec56                	sd	s5,24(sp)
      printf("FAIL: a child failed\n");
 15e:	00001517          	auipc	a0,0x1
 162:	e8250513          	addi	a0,a0,-382 # fe0 <statistics+0xc2>
 166:	40f000ef          	jal	d74 <printf>
      exit(1);
 16a:	4505                	li	a0,1
 16c:	778000ef          	jal	8e4 <exit>
    printf("test1 FAIL\n");
 170:	00001517          	auipc	a0,0x1
 174:	ea850513          	addi	a0,a0,-344 # 1018 <statistics+0xfa>
 178:	3fd000ef          	jal	d74 <printf>
}
 17c:	b7b5                	j	e8 <test1+0x78>

000000000000017e <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
 17e:	7179                	addi	sp,sp,-48
 180:	f406                	sd	ra,40(sp)
 182:	f022                	sd	s0,32(sp)
 184:	ec26                	sd	s1,24(sp)
 186:	e84a                	sd	s2,16(sp)
 188:	e44e                	sd	s3,8(sp)
 18a:	e052                	sd	s4,0(sp)
 18c:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
 18e:	4501                	li	a0,0
 190:	720000ef          	jal	8b0 <sbrk>
 194:	8a2a                	mv	s4,a0
  int n = 0;
 196:	4481                	li	s1,0
  while(1){
    char *a = sbrk(PGSIZE);
 198:	6985                	lui	s3,0x1
    if(a == SBRK_ERROR){
 19a:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
 19c:	854e                	mv	a0,s3
 19e:	712000ef          	jal	8b0 <sbrk>
    if(a == SBRK_ERROR){
 1a2:	01250463          	beq	a0,s2,1aa <countfree+0x2c>
      break;
    }
    n += 1;
 1a6:	2485                	addiw	s1,s1,1
  while(1){
 1a8:	bfd5                	j	19c <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));
 1aa:	4501                	li	a0,0
 1ac:	704000ef          	jal	8b0 <sbrk>
 1b0:	40aa053b          	subw	a0,s4,a0
 1b4:	6fc000ef          	jal	8b0 <sbrk>
  return n;
}
 1b8:	8526                	mv	a0,s1
 1ba:	70a2                	ld	ra,40(sp)
 1bc:	7402                	ld	s0,32(sp)
 1be:	64e2                	ld	s1,24(sp)
 1c0:	6942                	ld	s2,16(sp)
 1c2:	69a2                	ld	s3,8(sp)
 1c4:	6a02                	ld	s4,0(sp)
 1c6:	6145                	addi	sp,sp,48
 1c8:	8082                	ret

00000000000001ca <test2>:
void test2() {
 1ca:	715d                	addi	sp,sp,-80
 1cc:	e486                	sd	ra,72(sp)
 1ce:	e0a2                	sd	s0,64(sp)
 1d0:	fc26                	sd	s1,56(sp)
 1d2:	f84a                	sd	s2,48(sp)
 1d4:	f44e                	sd	s3,40(sp)
 1d6:	f052                	sd	s4,32(sp)
 1d8:	ec56                	sd	s5,24(sp)
 1da:	e85a                	sd	s6,16(sp)
 1dc:	e45e                	sd	s7,8(sp)
 1de:	e062                	sd	s8,0(sp)
 1e0:	0880                	addi	s0,sp,80
  int free0 = countfree();
 1e2:	f9dff0ef          	jal	17e <countfree>
 1e6:	84aa                	mv	s1,a0
  printf("start test2\n");  
 1e8:	00001517          	auipc	a0,0x1
 1ec:	e4050513          	addi	a0,a0,-448 # 1028 <statistics+0x10a>
 1f0:	385000ef          	jal	d74 <printf>
  printf("total free number of pages: %d (out of %d)\n", free0, n);
 1f4:	6621                	lui	a2,0x8
 1f6:	85a6                	mv	a1,s1
 1f8:	00001517          	auipc	a0,0x1
 1fc:	e4050513          	addi	a0,a0,-448 # 1038 <statistics+0x11a>
 200:	375000ef          	jal	d74 <printf>
  if (free0 < NPAGES2) {
 204:	07f00793          	li	a5,127
 208:	0297dd63          	bge	a5,s1,242 <test2+0x78>
  uint64 sz0 = (uint64) sbrk((free0 - NPAGES2) * PGSIZE);
 20c:	00c49513          	slli	a0,s1,0xc
 210:	fff807b7          	lui	a5,0xfff80
 214:	9d3d                	addw	a0,a0,a5
 216:	69a000ef          	jal	8b0 <sbrk>
 21a:	8c2a                	mv	s8,a0
  if (sz0 == (uint64) SBRK_ERROR) {
 21c:	57fd                	li	a5,-1
  for (int i = 0; i < N2; i++) {
 21e:	4901                	li	s2,0
  if (sz0 == (uint64) SBRK_ERROR) {
 220:	02f50a63          	beq	a0,a5,254 <test2+0x8a>
    if((i+1) % 100 == 0)
 224:	51eb89b7          	lui	s3,0x51eb8
 228:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51eb550f>
 22c:	06400a93          	li	s5,100
      printf(".");
 230:	00001b97          	auipc	s7,0x1
 234:	e88b8b93          	addi	s7,s7,-376 # 10b8 <statistics+0x19a>
    if(free1 != free0) {
 238:	08000a13          	li	s4,128
  for (int i = 0; i < N2; i++) {
 23c:	3e800b13          	li	s6,1000
 240:	a03d                	j	26e <test2+0xa4>
    printf("test2 FAILED: not enough free memory");
 242:	00001517          	auipc	a0,0x1
 246:	e2650513          	addi	a0,a0,-474 # 1068 <statistics+0x14a>
 24a:	32b000ef          	jal	d74 <printf>
    exit(1);
 24e:	4505                	li	a0,1
 250:	694000ef          	jal	8e4 <exit>
    printf("test2 FAILED: cannot allocate memory");
 254:	00001517          	auipc	a0,0x1
 258:	e3c50513          	addi	a0,a0,-452 # 1090 <statistics+0x172>
 25c:	319000ef          	jal	d74 <printf>
    exit(1);
 260:	4505                	li	a0,1
 262:	682000ef          	jal	8e4 <exit>
    if(free1 != free0) {
 266:	03449863          	bne	s1,s4,296 <test2+0xcc>
  for (int i = 0; i < N2; i++) {
 26a:	05690263          	beq	s2,s6,2ae <test2+0xe4>
    free1 = countfree();
 26e:	f11ff0ef          	jal	17e <countfree>
 272:	84aa                	mv	s1,a0
    if((i+1) % 100 == 0)
 274:	0019071b          	addiw	a4,s2,1
 278:	893a                	mv	s2,a4
 27a:	033707b3          	mul	a5,a4,s3
 27e:	9795                	srai	a5,a5,0x25
 280:	41f7569b          	sraiw	a3,a4,0x1f
 284:	9f95                	subw	a5,a5,a3
 286:	02fa87bb          	mulw	a5,s5,a5
 28a:	9f1d                	subw	a4,a4,a5
 28c:	ff69                	bnez	a4,266 <test2+0x9c>
      printf(".");
 28e:	855e                	mv	a0,s7
 290:	2e5000ef          	jal	d74 <printf>
 294:	bfc9                	j	266 <test2+0x9c>
      printf("test2 FAIL: losing pages %d %d\n", free0, free1);
 296:	8626                	mv	a2,s1
 298:	08000593          	li	a1,128
 29c:	00001517          	auipc	a0,0x1
 2a0:	e2450513          	addi	a0,a0,-476 # 10c0 <statistics+0x1a2>
 2a4:	2d1000ef          	jal	d74 <printf>
      exit(1);
 2a8:	4505                	li	a0,1
 2aa:	63a000ef          	jal	8e4 <exit>
  sbrk(-((uint64)sbrk(0) - sz0));
 2ae:	4501                	li	a0,0
 2b0:	600000ef          	jal	8b0 <sbrk>
 2b4:	40ac053b          	subw	a0,s8,a0
 2b8:	5f8000ef          	jal	8b0 <sbrk>
  printf("\ntest2 OK\n");  
 2bc:	00001517          	auipc	a0,0x1
 2c0:	e2450513          	addi	a0,a0,-476 # 10e0 <statistics+0x1c2>
 2c4:	2b1000ef          	jal	d74 <printf>
}
 2c8:	60a6                	ld	ra,72(sp)
 2ca:	6406                	ld	s0,64(sp)
 2cc:	74e2                	ld	s1,56(sp)
 2ce:	7942                	ld	s2,48(sp)
 2d0:	79a2                	ld	s3,40(sp)
 2d2:	7a02                	ld	s4,32(sp)
 2d4:	6ae2                	ld	s5,24(sp)
 2d6:	6b42                	ld	s6,16(sp)
 2d8:	6ba2                	ld	s7,8(sp)
 2da:	6c02                	ld	s8,0(sp)
 2dc:	6161                	addi	sp,sp,80
 2de:	8082                	ret

00000000000002e0 <test3>:
{
 2e0:	7139                	addi	sp,sp,-64
 2e2:	fc06                	sd	ra,56(sp)
 2e4:	f822                	sd	s0,48(sp)
 2e6:	f426                	sd	s1,40(sp)
 2e8:	f04a                	sd	s2,32(sp)
 2ea:	0080                	addi	s0,sp,64
  printf("start test3\n");
 2ec:	00001517          	auipc	a0,0x1
 2f0:	e0450513          	addi	a0,a0,-508 # 10f0 <statistics+0x1d2>
 2f4:	281000ef          	jal	d74 <printf>
  int free0 = countfree();
 2f8:	e87ff0ef          	jal	17e <countfree>
 2fc:	892a                	mv	s2,a0
    pid = fork();
 2fe:	5de000ef          	jal	8dc <fork>
    if(pid < 0){
 302:	04054b63          	bltz	a0,358 <test3+0x78>
    if(pid == 0){
 306:	c525                	beqz	a0,36e <test3+0x8e>
    pid = fork();
 308:	5d4000ef          	jal	8dc <fork>
 30c:	84aa                	mv	s1,a0
    if(pid < 0){
 30e:	04054563          	bltz	a0,358 <test3+0x78>
    if(pid == 0){
 312:	0c050d63          	beqz	a0,3ec <test3+0x10c>
  int status = 0;
 316:	fc042623          	sw	zero,-52(s0)
    wait(&status);
 31a:	fcc40513          	addi	a0,s0,-52
 31e:	5ce000ef          	jal	8ec <wait>
    if (status != 0) {
 322:	fcc42783          	lw	a5,-52(s0)
 326:	0c079663          	bnez	a5,3f2 <test3+0x112>
  kill(pid);
 32a:	8526                	mv	a0,s1
 32c:	5e8000ef          	jal	914 <kill>
  wait(&status);
 330:	fcc40513          	addi	a0,s0,-52
 334:	5b8000ef          	jal	8ec <wait>
  int free1 = countfree();
 338:	e47ff0ef          	jal	17e <countfree>
  if (free0 != free1) {
 33c:	0ca91663          	bne	s2,a0,408 <test3+0x128>
  printf("\ntest3 OK\n");
 340:	00001517          	auipc	a0,0x1
 344:	e0050513          	addi	a0,a0,-512 # 1140 <statistics+0x222>
 348:	22d000ef          	jal	d74 <printf>
}
 34c:	70e2                	ld	ra,56(sp)
 34e:	7442                	ld	s0,48(sp)
 350:	74a2                	ld	s1,40(sp)
 352:	7902                	ld	s2,32(sp)
 354:	6121                	addi	sp,sp,64
 356:	8082                	ret
 358:	ec4e                	sd	s3,24(sp)
 35a:	e852                	sd	s4,16(sp)
      printf("fork failed");
 35c:	00001517          	auipc	a0,0x1
 360:	c5c50513          	addi	a0,a0,-932 # fb8 <statistics+0x9a>
 364:	211000ef          	jal	d74 <printf>
      exit(-1);
 368:	557d                	li	a0,-1
 36a:	57a000ef          	jal	8e4 <exit>
 36e:	ec4e                	sd	s3,24(sp)
 370:	e852                	sd	s4,16(sp)
    if(pid == 0){
 372:	4485                	li	s1,1
          if ((i + 1) % 1000 == 0) {
 374:	106259b7          	lui	s3,0x10625
 378:	dd398993          	addi	s3,s3,-557 # 10624dd3 <base+0x10621dc3>
 37c:	3e800a13          	li	s4,1000
        for(i = 0; i < N3; i++) {
 380:	6909                	lui	s2,0x2
 382:	71190913          	addi	s2,s2,1809 # 2711 <buf+0x701>
 386:	a811                	j	39a <test3+0xba>
            sbrk(4096);
 388:	6505                	lui	a0,0x1
 38a:	526000ef          	jal	8b0 <sbrk>
            exit(0);
 38e:	4501                	li	a0,0
 390:	554000ef          	jal	8e4 <exit>
        for(i = 0; i < N3; i++) {
 394:	2485                	addiw	s1,s1,1
 396:	03248f63          	beq	s1,s2,3d4 <test3+0xf4>
          int cpid = fork();
 39a:	542000ef          	jal	8dc <fork>
          if (cpid < 0) {
 39e:	fe054be3          	bltz	a0,394 <test3+0xb4>
          if (cpid == 0) {
 3a2:	d17d                	beqz	a0,388 <test3+0xa8>
          int status = 0;
 3a4:	fc042423          	sw	zero,-56(s0)
          wait(&status);
 3a8:	fc840513          	addi	a0,s0,-56
 3ac:	540000ef          	jal	8ec <wait>
          if ((i + 1) % 1000 == 0) {
 3b0:	033487b3          	mul	a5,s1,s3
 3b4:	9799                	srai	a5,a5,0x26
 3b6:	41f4d71b          	sraiw	a4,s1,0x1f
 3ba:	9f99                	subw	a5,a5,a4
 3bc:	02fa07bb          	mulw	a5,s4,a5
 3c0:	40f487bb          	subw	a5,s1,a5
 3c4:	fbe1                	bnez	a5,394 <test3+0xb4>
            printf(".");
 3c6:	00001517          	auipc	a0,0x1
 3ca:	cf250513          	addi	a0,a0,-782 # 10b8 <statistics+0x19a>
 3ce:	1a7000ef          	jal	d74 <printf>
 3d2:	b7c9                	j	394 <test3+0xb4>
        printf("child done %d\n", i);
 3d4:	6589                	lui	a1,0x2
 3d6:	71058593          	addi	a1,a1,1808 # 2710 <buf+0x700>
 3da:	00001517          	auipc	a0,0x1
 3de:	d2650513          	addi	a0,a0,-730 # 1100 <statistics+0x1e2>
 3e2:	193000ef          	jal	d74 <printf>
        exit(0);
 3e6:	4501                	li	a0,0
 3e8:	4fc000ef          	jal	8e4 <exit>
          countfree();
 3ec:	d93ff0ef          	jal	17e <countfree>
        while (1) {
 3f0:	bff5                	j	3ec <test3+0x10c>
 3f2:	ec4e                	sd	s3,24(sp)
 3f4:	e852                	sd	s4,16(sp)
      printf("a child failed\n");
 3f6:	00001517          	auipc	a0,0x1
 3fa:	d1a50513          	addi	a0,a0,-742 # 1110 <statistics+0x1f2>
 3fe:	177000ef          	jal	d74 <printf>
      exit(1);
 402:	4505                	li	a0,1
 404:	4e0000ef          	jal	8e4 <exit>
 408:	ec4e                	sd	s3,24(sp)
 40a:	e852                	sd	s4,16(sp)
    printf("test3 FAIL: losing pages %d %d\n", free0, free1);
 40c:	862a                	mv	a2,a0
 40e:	85ca                	mv	a1,s2
 410:	00001517          	auipc	a0,0x1
 414:	d1050513          	addi	a0,a0,-752 # 1120 <statistics+0x202>
 418:	15d000ef          	jal	d74 <printf>
    exit(1);
 41c:	4505                	li	a0,1
 41e:	4c6000ef          	jal	8e4 <exit>

0000000000000422 <test4>:
{
 422:	7159                	addi	sp,sp,-112
 424:	f486                	sd	ra,104(sp)
 426:	f0a2                	sd	s0,96(sp)
 428:	e8ca                	sd	s2,80(sp)
 42a:	e4ce                	sd	s3,72(sp)
 42c:	e0d2                	sd	s4,64(sp)
 42e:	fc56                	sd	s5,56(sp)
 430:	1880                	addi	s0,sp,112
  m = ntas(0);
 432:	4501                	li	a0,0
 434:	bcdff0ef          	jal	0 <ntas>
 438:	8a2a                	mv	s4,a0
  printf("start test4\n");
 43a:	00001517          	auipc	a0,0x1
 43e:	d1650513          	addi	a0,a0,-746 # 1150 <statistics+0x232>
 442:	133000ef          	jal	d74 <printf>
  int npages = countfree();
 446:	d39ff0ef          	jal	17e <countfree>
 44a:	8aaa                	mv	s5,a0
  if (npages < 100) {
 44c:	06300793          	li	a5,99
  for(int i = 0; i < NCHILD4; i++){
 450:	4901                	li	s2,0
 452:	4991                	li	s3,4
  if (npages < 100) {
 454:	06a7dc63          	bge	a5,a0,4cc <test4+0xaa>
 458:	eca6                	sd	s1,88(sp)
    pid = fork();
 45a:	482000ef          	jal	8dc <fork>
 45e:	84aa                	mv	s1,a0
    if(pid < 0){
 460:	08054563          	bltz	a0,4ea <test4+0xc8>
    if(pid == 0){
 464:	c145                	beqz	a0,504 <test4+0xe2>
  for(int i = 0; i < NCHILD4; i++){
 466:	2905                	addiw	s2,s2,1
 468:	ff3919e3          	bne	s2,s3,45a <test4+0x38>
  int status = 0;
 46c:	f8042e23          	sw	zero,-100(s0)
 470:	490d                	li	s2,3
    wait(&status);
 472:	f9c40993          	addi	s3,s0,-100
 476:	854e                	mv	a0,s3
 478:	474000ef          	jal	8ec <wait>
    if (status != 0) {
 47c:	f9c42783          	lw	a5,-100(s0)
 480:	16079363          	bnez	a5,5e6 <test4+0x1c4>
  for(int i = 0; i < NCHILD4-1; i++){
 484:	397d                	addiw	s2,s2,-1
 486:	fe0918e3          	bnez	s2,476 <test4+0x54>
  kill(pid);
 48a:	8526                	mv	a0,s1
 48c:	488000ef          	jal	914 <kill>
  wait(&status);
 490:	f9c40513          	addi	a0,s0,-100
 494:	458000ef          	jal	8ec <wait>
  n = ntas(1);
 498:	4505                	li	a0,1
 49a:	b67ff0ef          	jal	0 <ntas>
 49e:	862a                	mv	a2,a0
  if(n-m < (NCHILD4-1)*10000)
 4a0:	4145073b          	subw	a4,a0,s4
 4a4:	679d                	lui	a5,0x7
 4a6:	52f78793          	addi	a5,a5,1327 # 752f <base+0x451f>
 4aa:	14e7cb63          	blt	a5,a4,600 <test4+0x1de>
    printf("\ntest4 OK\n");
 4ae:	00001517          	auipc	a0,0x1
 4b2:	d0a50513          	addi	a0,a0,-758 # 11b8 <statistics+0x29a>
 4b6:	0bf000ef          	jal	d74 <printf>
 4ba:	64e6                	ld	s1,88(sp)
}
 4bc:	70a6                	ld	ra,104(sp)
 4be:	7406                	ld	s0,96(sp)
 4c0:	6946                	ld	s2,80(sp)
 4c2:	69a6                	ld	s3,72(sp)
 4c4:	6a06                	ld	s4,64(sp)
 4c6:	7ae2                	ld	s5,56(sp)
 4c8:	6165                	addi	sp,sp,112
 4ca:	8082                	ret
 4cc:	eca6                	sd	s1,88(sp)
 4ce:	f85a                	sd	s6,48(sp)
 4d0:	f45e                	sd	s7,40(sp)
 4d2:	f062                	sd	s8,32(sp)
 4d4:	ec66                	sd	s9,24(sp)
    printf("too few pages: %d\n", npages);
 4d6:	85aa                	mv	a1,a0
 4d8:	00001517          	auipc	a0,0x1
 4dc:	c8850513          	addi	a0,a0,-888 # 1160 <statistics+0x242>
 4e0:	095000ef          	jal	d74 <printf>
    exit(-1);
 4e4:	557d                	li	a0,-1
 4e6:	3fe000ef          	jal	8e4 <exit>
 4ea:	f85a                	sd	s6,48(sp)
 4ec:	f45e                	sd	s7,40(sp)
 4ee:	f062                	sd	s8,32(sp)
 4f0:	ec66                	sd	s9,24(sp)
      printf("fork failed");
 4f2:	00001517          	auipc	a0,0x1
 4f6:	ac650513          	addi	a0,a0,-1338 # fb8 <statistics+0x9a>
 4fa:	07b000ef          	jal	d74 <printf>
      exit(-1);
 4fe:	557d                	li	a0,-1
 500:	3e4000ef          	jal	8e4 <exit>
      cpupin(i);
 504:	854a                	mv	a0,s2
 506:	4be000ef          	jal	9c4 <cpupin>
      if (i < NCHILD4-1) {
 50a:	4789                	li	a5,2
 50c:	4485                	li	s1,1
 50e:	0327c663          	blt	a5,s2,53a <test4+0x118>
 512:	f85a                	sd	s6,48(sp)
 514:	f45e                	sd	s7,40(sp)
 516:	f062                	sd	s8,32(sp)
 518:	ec66                	sd	s9,24(sp)
          a = (uint64) sbrk(4096);
 51a:	6905                	lui	s2,0x1
          if(a == 0xffffffffffffffff){
 51c:	59fd                	li	s3,-1
          *(int *)(a+4) = 1;
 51e:	8ba6                	mv	s7,s1
          a1 = (uint64) sbrk(-4096);
 520:	7b7d                	lui	s6,0xfffff
          if ((i + 1) % 10000 == 0) {
 522:	68db9ab7          	lui	s5,0x68db9
 526:	bada8a93          	addi	s5,s5,-1107 # 68db8bad <base+0x68db5b9d>
 52a:	6a09                	lui	s4,0x2
 52c:	710a0a1b          	addiw	s4,s4,1808 # 2710 <buf+0x700>
            printf(".");
 530:	00001c17          	auipc	s8,0x1
 534:	b88c0c13          	addi	s8,s8,-1144 # 10b8 <statistics+0x19a>
 538:	a825                	j	570 <test4+0x14e>
 53a:	f85a                	sd	s6,48(sp)
 53c:	f45e                	sd	s7,40(sp)
 53e:	f062                	sd	s8,32(sp)
 540:	ec66                	sd	s9,24(sp)
  npages -= (NCHILD4-1)*100;
 542:	ed4a8a9b          	addiw	s5,s5,-300
          a = (uint64) sbrk(npages*4096);
 546:	00ca949b          	slliw	s1,s5,0xc
 54a:	409009bb          	negw	s3,s1
          if(a == 0xffffffffffffffff){
 54e:	597d                	li	s2,-1
 550:	a8a5                	j	5c8 <test4+0x1a6>
            printf("test3 FAIL: wrong sbrk\n");
 552:	00001517          	auipc	a0,0x1
 556:	c2650513          	addi	a0,a0,-986 # 1178 <statistics+0x25a>
 55a:	01b000ef          	jal	d74 <printf>
            exit(1);
 55e:	4505                	li	a0,1
 560:	384000ef          	jal	8e4 <exit>
        for(i = 0; i < N4; i++) {
 564:	2485                	addiw	s1,s1,1
 566:	67e1                	lui	a5,0x18
 568:	6a178793          	addi	a5,a5,1697 # 186a1 <base+0x15691>
 56c:	02f48f63          	beq	s1,a5,5aa <test4+0x188>
          a = (uint64) sbrk(4096);
 570:	854a                	mv	a0,s2
 572:	33e000ef          	jal	8b0 <sbrk>
 576:	8caa                	mv	s9,a0
          if(a == 0xffffffffffffffff){
 578:	ff3506e3          	beq	a0,s3,564 <test4+0x142>
          *(int *)(a+4) = 1;
 57c:	01752223          	sw	s7,4(a0)
          a1 = (uint64) sbrk(-4096);
 580:	855a                	mv	a0,s6
 582:	32e000ef          	jal	8b0 <sbrk>
          if (a1 != a + 4096) {
 586:	9cca                	add	s9,s9,s2
 588:	fd9515e3          	bne	a0,s9,552 <test4+0x130>
          if ((i + 1) % 10000 == 0) {
 58c:	035487b3          	mul	a5,s1,s5
 590:	97b1                	srai	a5,a5,0x2c
 592:	41f4d71b          	sraiw	a4,s1,0x1f
 596:	9f99                	subw	a5,a5,a4
 598:	02fa07bb          	mulw	a5,s4,a5
 59c:	40f487bb          	subw	a5,s1,a5
 5a0:	f3f1                	bnez	a5,564 <test4+0x142>
            printf(".");
 5a2:	8562                	mv	a0,s8
 5a4:	7d0000ef          	jal	d74 <printf>
 5a8:	bf75                	j	564 <test4+0x142>
        printf("child done %d\n", i);
 5aa:	65e1                	lui	a1,0x18
 5ac:	6a058593          	addi	a1,a1,1696 # 186a0 <base+0x15690>
 5b0:	00001517          	auipc	a0,0x1
 5b4:	b5050513          	addi	a0,a0,-1200 # 1100 <statistics+0x1e2>
 5b8:	7bc000ef          	jal	d74 <printf>
        exit(0);
 5bc:	4501                	li	a0,0
 5be:	326000ef          	jal	8e4 <exit>
          sbrk(-npages*4096);
 5c2:	854e                	mv	a0,s3
 5c4:	2ec000ef          	jal	8b0 <sbrk>
          a = (uint64) sbrk(npages*4096);
 5c8:	8526                	mv	a0,s1
 5ca:	2e6000ef          	jal	8b0 <sbrk>
          if(a == 0xffffffffffffffff){
 5ce:	ff251ae3          	bne	a0,s2,5c2 <test4+0x1a0>
            printf("test4 FAIL: cannot allocate %d pages\n", npages);
 5d2:	85d6                	mv	a1,s5
 5d4:	00001517          	auipc	a0,0x1
 5d8:	bbc50513          	addi	a0,a0,-1092 # 1190 <statistics+0x272>
 5dc:	798000ef          	jal	d74 <printf>
            exit(1);
 5e0:	4505                	li	a0,1
 5e2:	302000ef          	jal	8e4 <exit>
 5e6:	f85a                	sd	s6,48(sp)
 5e8:	f45e                	sd	s7,40(sp)
 5ea:	f062                	sd	s8,32(sp)
 5ec:	ec66                	sd	s9,24(sp)
      printf("a child failed\n");
 5ee:	00001517          	auipc	a0,0x1
 5f2:	b2250513          	addi	a0,a0,-1246 # 1110 <statistics+0x1f2>
 5f6:	77e000ef          	jal	d74 <printf>
      exit(1);
 5fa:	4505                	li	a0,1
 5fc:	2e8000ef          	jal	8e4 <exit>
    printf("test4 FAIL m %d n %d\n", m, n);
 600:	85d2                	mv	a1,s4
 602:	00001517          	auipc	a0,0x1
 606:	bc650513          	addi	a0,a0,-1082 # 11c8 <statistics+0x2aa>
 60a:	76a000ef          	jal	d74 <printf>
}
 60e:	b575                	j	4ba <test4+0x98>

0000000000000610 <main>:
{
 610:	1141                	addi	sp,sp,-16
 612:	e406                	sd	ra,8(sp)
 614:	e022                	sd	s0,0(sp)
 616:	0800                	addi	s0,sp,16
  test1();
 618:	a59ff0ef          	jal	70 <test1>
  test2();
 61c:	bafff0ef          	jal	1ca <test2>
  test3();
 620:	cc1ff0ef          	jal	2e0 <test3>
  test4();
 624:	dffff0ef          	jal	422 <test4>
  exit(0);
 628:	4501                	li	a0,0
 62a:	2ba000ef          	jal	8e4 <exit>

000000000000062e <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 62e:	1141                	addi	sp,sp,-16
 630:	e406                	sd	ra,8(sp)
 632:	e022                	sd	s0,0(sp)
 634:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 636:	fdbff0ef          	jal	610 <main>
  exit(r);
 63a:	2aa000ef          	jal	8e4 <exit>

000000000000063e <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 63e:	1141                	addi	sp,sp,-16
 640:	e406                	sd	ra,8(sp)
 642:	e022                	sd	s0,0(sp)
 644:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 646:	87aa                	mv	a5,a0
 648:	0585                	addi	a1,a1,1
 64a:	0785                	addi	a5,a5,1
 64c:	fff5c703          	lbu	a4,-1(a1)
 650:	fee78fa3          	sb	a4,-1(a5)
 654:	fb75                	bnez	a4,648 <strcpy+0xa>
    ;
  return os;
}
 656:	60a2                	ld	ra,8(sp)
 658:	6402                	ld	s0,0(sp)
 65a:	0141                	addi	sp,sp,16
 65c:	8082                	ret

000000000000065e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 65e:	1141                	addi	sp,sp,-16
 660:	e406                	sd	ra,8(sp)
 662:	e022                	sd	s0,0(sp)
 664:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 666:	00054783          	lbu	a5,0(a0)
 66a:	cb91                	beqz	a5,67e <strcmp+0x20>
 66c:	0005c703          	lbu	a4,0(a1)
 670:	00f71763          	bne	a4,a5,67e <strcmp+0x20>
    p++, q++;
 674:	0505                	addi	a0,a0,1
 676:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 678:	00054783          	lbu	a5,0(a0)
 67c:	fbe5                	bnez	a5,66c <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 67e:	0005c503          	lbu	a0,0(a1)
}
 682:	40a7853b          	subw	a0,a5,a0
 686:	60a2                	ld	ra,8(sp)
 688:	6402                	ld	s0,0(sp)
 68a:	0141                	addi	sp,sp,16
 68c:	8082                	ret

000000000000068e <strlen>:

uint
strlen(const char *s)
{
 68e:	1141                	addi	sp,sp,-16
 690:	e406                	sd	ra,8(sp)
 692:	e022                	sd	s0,0(sp)
 694:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 696:	00054783          	lbu	a5,0(a0)
 69a:	cf91                	beqz	a5,6b6 <strlen+0x28>
 69c:	00150793          	addi	a5,a0,1
 6a0:	86be                	mv	a3,a5
 6a2:	0785                	addi	a5,a5,1
 6a4:	fff7c703          	lbu	a4,-1(a5)
 6a8:	ff65                	bnez	a4,6a0 <strlen+0x12>
 6aa:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 6ae:	60a2                	ld	ra,8(sp)
 6b0:	6402                	ld	s0,0(sp)
 6b2:	0141                	addi	sp,sp,16
 6b4:	8082                	ret
  for(n = 0; s[n]; n++)
 6b6:	4501                	li	a0,0
 6b8:	bfdd                	j	6ae <strlen+0x20>

00000000000006ba <memset>:

void*
memset(void *dst, int c, uint n)
{
 6ba:	1141                	addi	sp,sp,-16
 6bc:	e406                	sd	ra,8(sp)
 6be:	e022                	sd	s0,0(sp)
 6c0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 6c2:	ca19                	beqz	a2,6d8 <memset+0x1e>
 6c4:	87aa                	mv	a5,a0
 6c6:	1602                	slli	a2,a2,0x20
 6c8:	9201                	srli	a2,a2,0x20
 6ca:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 6ce:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 6d2:	0785                	addi	a5,a5,1
 6d4:	fee79de3          	bne	a5,a4,6ce <memset+0x14>
  }
  return dst;
}
 6d8:	60a2                	ld	ra,8(sp)
 6da:	6402                	ld	s0,0(sp)
 6dc:	0141                	addi	sp,sp,16
 6de:	8082                	ret

00000000000006e0 <strchr>:

char*
strchr(const char *s, char c)
{
 6e0:	1141                	addi	sp,sp,-16
 6e2:	e406                	sd	ra,8(sp)
 6e4:	e022                	sd	s0,0(sp)
 6e6:	0800                	addi	s0,sp,16
  for(; *s; s++)
 6e8:	00054783          	lbu	a5,0(a0)
 6ec:	cf81                	beqz	a5,704 <strchr+0x24>
    if(*s == c)
 6ee:	00f58763          	beq	a1,a5,6fc <strchr+0x1c>
  for(; *s; s++)
 6f2:	0505                	addi	a0,a0,1
 6f4:	00054783          	lbu	a5,0(a0)
 6f8:	fbfd                	bnez	a5,6ee <strchr+0xe>
      return (char*)s;
  return 0;
 6fa:	4501                	li	a0,0
}
 6fc:	60a2                	ld	ra,8(sp)
 6fe:	6402                	ld	s0,0(sp)
 700:	0141                	addi	sp,sp,16
 702:	8082                	ret
  return 0;
 704:	4501                	li	a0,0
 706:	bfdd                	j	6fc <strchr+0x1c>

0000000000000708 <gets>:

char*
gets(char *buf, int max)
{
 708:	711d                	addi	sp,sp,-96
 70a:	ec86                	sd	ra,88(sp)
 70c:	e8a2                	sd	s0,80(sp)
 70e:	e4a6                	sd	s1,72(sp)
 710:	e0ca                	sd	s2,64(sp)
 712:	fc4e                	sd	s3,56(sp)
 714:	f852                	sd	s4,48(sp)
 716:	f456                	sd	s5,40(sp)
 718:	f05a                	sd	s6,32(sp)
 71a:	ec5e                	sd	s7,24(sp)
 71c:	e862                	sd	s8,16(sp)
 71e:	1080                	addi	s0,sp,96
 720:	8baa                	mv	s7,a0
 722:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 724:	892a                	mv	s2,a0
 726:	4481                	li	s1,0
    cc = read(0, &c, 1);
 728:	faf40b13          	addi	s6,s0,-81
 72c:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 72e:	8c26                	mv	s8,s1
 730:	0014899b          	addiw	s3,s1,1
 734:	84ce                	mv	s1,s3
 736:	0349d463          	bge	s3,s4,75e <gets+0x56>
    cc = read(0, &c, 1);
 73a:	8656                	mv	a2,s5
 73c:	85da                	mv	a1,s6
 73e:	4501                	li	a0,0
 740:	1bc000ef          	jal	8fc <read>
    if(cc < 1)
 744:	00a05d63          	blez	a0,75e <gets+0x56>
      break;
    buf[i++] = c;
 748:	faf44783          	lbu	a5,-81(s0)
 74c:	00f90023          	sb	a5,0(s2) # 1000 <statistics+0xe2>
    if(c == '\n' || c == '\r')
 750:	0905                	addi	s2,s2,1
 752:	ff678713          	addi	a4,a5,-10
 756:	c319                	beqz	a4,75c <gets+0x54>
 758:	17cd                	addi	a5,a5,-13
 75a:	fbf1                	bnez	a5,72e <gets+0x26>
    buf[i++] = c;
 75c:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 75e:	9c5e                	add	s8,s8,s7
 760:	000c0023          	sb	zero,0(s8)
  return buf;
}
 764:	855e                	mv	a0,s7
 766:	60e6                	ld	ra,88(sp)
 768:	6446                	ld	s0,80(sp)
 76a:	64a6                	ld	s1,72(sp)
 76c:	6906                	ld	s2,64(sp)
 76e:	79e2                	ld	s3,56(sp)
 770:	7a42                	ld	s4,48(sp)
 772:	7aa2                	ld	s5,40(sp)
 774:	7b02                	ld	s6,32(sp)
 776:	6be2                	ld	s7,24(sp)
 778:	6c42                	ld	s8,16(sp)
 77a:	6125                	addi	sp,sp,96
 77c:	8082                	ret

000000000000077e <stat>:

int
stat(const char *n, struct stat *st)
{
 77e:	1101                	addi	sp,sp,-32
 780:	ec06                	sd	ra,24(sp)
 782:	e822                	sd	s0,16(sp)
 784:	e04a                	sd	s2,0(sp)
 786:	1000                	addi	s0,sp,32
 788:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 78a:	4581                	li	a1,0
 78c:	198000ef          	jal	924 <open>
  if(fd < 0)
 790:	02054263          	bltz	a0,7b4 <stat+0x36>
 794:	e426                	sd	s1,8(sp)
 796:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 798:	85ca                	mv	a1,s2
 79a:	1a2000ef          	jal	93c <fstat>
 79e:	892a                	mv	s2,a0
  close(fd);
 7a0:	8526                	mv	a0,s1
 7a2:	16a000ef          	jal	90c <close>
  return r;
 7a6:	64a2                	ld	s1,8(sp)
}
 7a8:	854a                	mv	a0,s2
 7aa:	60e2                	ld	ra,24(sp)
 7ac:	6442                	ld	s0,16(sp)
 7ae:	6902                	ld	s2,0(sp)
 7b0:	6105                	addi	sp,sp,32
 7b2:	8082                	ret
    return -1;
 7b4:	57fd                	li	a5,-1
 7b6:	893e                	mv	s2,a5
 7b8:	bfc5                	j	7a8 <stat+0x2a>

00000000000007ba <atoi>:

int
atoi(const char *s)
{
 7ba:	1141                	addi	sp,sp,-16
 7bc:	e406                	sd	ra,8(sp)
 7be:	e022                	sd	s0,0(sp)
 7c0:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 7c2:	00054683          	lbu	a3,0(a0)
 7c6:	fd06879b          	addiw	a5,a3,-48
 7ca:	0ff7f793          	zext.b	a5,a5
 7ce:	4625                	li	a2,9
 7d0:	02f66963          	bltu	a2,a5,802 <atoi+0x48>
 7d4:	872a                	mv	a4,a0
  n = 0;
 7d6:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 7d8:	0705                	addi	a4,a4,1
 7da:	0025179b          	slliw	a5,a0,0x2
 7de:	9fa9                	addw	a5,a5,a0
 7e0:	0017979b          	slliw	a5,a5,0x1
 7e4:	9fb5                	addw	a5,a5,a3
 7e6:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 7ea:	00074683          	lbu	a3,0(a4)
 7ee:	fd06879b          	addiw	a5,a3,-48
 7f2:	0ff7f793          	zext.b	a5,a5
 7f6:	fef671e3          	bgeu	a2,a5,7d8 <atoi+0x1e>
  return n;
}
 7fa:	60a2                	ld	ra,8(sp)
 7fc:	6402                	ld	s0,0(sp)
 7fe:	0141                	addi	sp,sp,16
 800:	8082                	ret
  n = 0;
 802:	4501                	li	a0,0
 804:	bfdd                	j	7fa <atoi+0x40>

0000000000000806 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 806:	1141                	addi	sp,sp,-16
 808:	e406                	sd	ra,8(sp)
 80a:	e022                	sd	s0,0(sp)
 80c:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 80e:	02b57563          	bgeu	a0,a1,838 <memmove+0x32>
    while(n-- > 0)
 812:	00c05f63          	blez	a2,830 <memmove+0x2a>
 816:	1602                	slli	a2,a2,0x20
 818:	9201                	srli	a2,a2,0x20
 81a:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 81e:	872a                	mv	a4,a0
      *dst++ = *src++;
 820:	0585                	addi	a1,a1,1
 822:	0705                	addi	a4,a4,1
 824:	fff5c683          	lbu	a3,-1(a1)
 828:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 82c:	fee79ae3          	bne	a5,a4,820 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 830:	60a2                	ld	ra,8(sp)
 832:	6402                	ld	s0,0(sp)
 834:	0141                	addi	sp,sp,16
 836:	8082                	ret
    while(n-- > 0)
 838:	fec05ce3          	blez	a2,830 <memmove+0x2a>
    dst += n;
 83c:	00c50733          	add	a4,a0,a2
    src += n;
 840:	95b2                	add	a1,a1,a2
 842:	fff6079b          	addiw	a5,a2,-1 # 7fff <base+0x4fef>
 846:	1782                	slli	a5,a5,0x20
 848:	9381                	srli	a5,a5,0x20
 84a:	fff7c793          	not	a5,a5
 84e:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 850:	15fd                	addi	a1,a1,-1
 852:	177d                	addi	a4,a4,-1
 854:	0005c683          	lbu	a3,0(a1)
 858:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 85c:	fef71ae3          	bne	a4,a5,850 <memmove+0x4a>
 860:	bfc1                	j	830 <memmove+0x2a>

0000000000000862 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 862:	1141                	addi	sp,sp,-16
 864:	e406                	sd	ra,8(sp)
 866:	e022                	sd	s0,0(sp)
 868:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 86a:	c61d                	beqz	a2,898 <memcmp+0x36>
 86c:	1602                	slli	a2,a2,0x20
 86e:	9201                	srli	a2,a2,0x20
 870:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 874:	00054783          	lbu	a5,0(a0)
 878:	0005c703          	lbu	a4,0(a1)
 87c:	00e79863          	bne	a5,a4,88c <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 880:	0505                	addi	a0,a0,1
    p2++;
 882:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 884:	fed518e3          	bne	a0,a3,874 <memcmp+0x12>
  }
  return 0;
 888:	4501                	li	a0,0
 88a:	a019                	j	890 <memcmp+0x2e>
      return *p1 - *p2;
 88c:	40e7853b          	subw	a0,a5,a4
}
 890:	60a2                	ld	ra,8(sp)
 892:	6402                	ld	s0,0(sp)
 894:	0141                	addi	sp,sp,16
 896:	8082                	ret
  return 0;
 898:	4501                	li	a0,0
 89a:	bfdd                	j	890 <memcmp+0x2e>

000000000000089c <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 89c:	1141                	addi	sp,sp,-16
 89e:	e406                	sd	ra,8(sp)
 8a0:	e022                	sd	s0,0(sp)
 8a2:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 8a4:	f63ff0ef          	jal	806 <memmove>
}
 8a8:	60a2                	ld	ra,8(sp)
 8aa:	6402                	ld	s0,0(sp)
 8ac:	0141                	addi	sp,sp,16
 8ae:	8082                	ret

00000000000008b0 <sbrk>:

char *
sbrk(int n) {
 8b0:	1141                	addi	sp,sp,-16
 8b2:	e406                	sd	ra,8(sp)
 8b4:	e022                	sd	s0,0(sp)
 8b6:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 8b8:	4585                	li	a1,1
 8ba:	0b2000ef          	jal	96c <sys_sbrk>
}
 8be:	60a2                	ld	ra,8(sp)
 8c0:	6402                	ld	s0,0(sp)
 8c2:	0141                	addi	sp,sp,16
 8c4:	8082                	ret

00000000000008c6 <sbrklazy>:

char *
sbrklazy(int n) {
 8c6:	1141                	addi	sp,sp,-16
 8c8:	e406                	sd	ra,8(sp)
 8ca:	e022                	sd	s0,0(sp)
 8cc:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 8ce:	4589                	li	a1,2
 8d0:	09c000ef          	jal	96c <sys_sbrk>
}
 8d4:	60a2                	ld	ra,8(sp)
 8d6:	6402                	ld	s0,0(sp)
 8d8:	0141                	addi	sp,sp,16
 8da:	8082                	ret

00000000000008dc <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 8dc:	4885                	li	a7,1
 ecall
 8de:	00000073          	ecall
 ret
 8e2:	8082                	ret

00000000000008e4 <exit>:
.global exit
exit:
 li a7, SYS_exit
 8e4:	4889                	li	a7,2
 ecall
 8e6:	00000073          	ecall
 ret
 8ea:	8082                	ret

00000000000008ec <wait>:
.global wait
wait:
 li a7, SYS_wait
 8ec:	488d                	li	a7,3
 ecall
 8ee:	00000073          	ecall
 ret
 8f2:	8082                	ret

00000000000008f4 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 8f4:	4891                	li	a7,4
 ecall
 8f6:	00000073          	ecall
 ret
 8fa:	8082                	ret

00000000000008fc <read>:
.global read
read:
 li a7, SYS_read
 8fc:	4895                	li	a7,5
 ecall
 8fe:	00000073          	ecall
 ret
 902:	8082                	ret

0000000000000904 <write>:
.global write
write:
 li a7, SYS_write
 904:	48c1                	li	a7,16
 ecall
 906:	00000073          	ecall
 ret
 90a:	8082                	ret

000000000000090c <close>:
.global close
close:
 li a7, SYS_close
 90c:	48d5                	li	a7,21
 ecall
 90e:	00000073          	ecall
 ret
 912:	8082                	ret

0000000000000914 <kill>:
.global kill
kill:
 li a7, SYS_kill
 914:	4899                	li	a7,6
 ecall
 916:	00000073          	ecall
 ret
 91a:	8082                	ret

000000000000091c <exec>:
.global exec
exec:
 li a7, SYS_exec
 91c:	489d                	li	a7,7
 ecall
 91e:	00000073          	ecall
 ret
 922:	8082                	ret

0000000000000924 <open>:
.global open
open:
 li a7, SYS_open
 924:	48bd                	li	a7,15
 ecall
 926:	00000073          	ecall
 ret
 92a:	8082                	ret

000000000000092c <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 92c:	48c5                	li	a7,17
 ecall
 92e:	00000073          	ecall
 ret
 932:	8082                	ret

0000000000000934 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 934:	48c9                	li	a7,18
 ecall
 936:	00000073          	ecall
 ret
 93a:	8082                	ret

000000000000093c <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 93c:	48a1                	li	a7,8
 ecall
 93e:	00000073          	ecall
 ret
 942:	8082                	ret

0000000000000944 <link>:
.global link
link:
 li a7, SYS_link
 944:	48cd                	li	a7,19
 ecall
 946:	00000073          	ecall
 ret
 94a:	8082                	ret

000000000000094c <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 94c:	48d1                	li	a7,20
 ecall
 94e:	00000073          	ecall
 ret
 952:	8082                	ret

0000000000000954 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 954:	48a5                	li	a7,9
 ecall
 956:	00000073          	ecall
 ret
 95a:	8082                	ret

000000000000095c <dup>:
.global dup
dup:
 li a7, SYS_dup
 95c:	48a9                	li	a7,10
 ecall
 95e:	00000073          	ecall
 ret
 962:	8082                	ret

0000000000000964 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 964:	48ad                	li	a7,11
 ecall
 966:	00000073          	ecall
 ret
 96a:	8082                	ret

000000000000096c <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 96c:	48b1                	li	a7,12
 ecall
 96e:	00000073          	ecall
 ret
 972:	8082                	ret

0000000000000974 <pause>:
.global pause
pause:
 li a7, SYS_pause
 974:	48b5                	li	a7,13
 ecall
 976:	00000073          	ecall
 ret
 97a:	8082                	ret

000000000000097c <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 97c:	48b9                	li	a7,14
 ecall
 97e:	00000073          	ecall
 ret
 982:	8082                	ret

0000000000000984 <bind>:
.global bind
bind:
 li a7, SYS_bind
 984:	48f5                	li	a7,29
 ecall
 986:	00000073          	ecall
 ret
 98a:	8082                	ret

000000000000098c <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 98c:	48f9                	li	a7,30
 ecall
 98e:	00000073          	ecall
 ret
 992:	8082                	ret

0000000000000994 <send>:
.global send
send:
 li a7, SYS_send
 994:	48fd                	li	a7,31
 ecall
 996:	00000073          	ecall
 ret
 99a:	8082                	ret

000000000000099c <recv>:
.global recv
recv:
 li a7, SYS_recv
 99c:	02000893          	li	a7,32
 ecall
 9a0:	00000073          	ecall
 ret
 9a4:	8082                	ret

00000000000009a6 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 9a6:	02100893          	li	a7,33
 ecall
 9aa:	00000073          	ecall
 ret
 9ae:	8082                	ret

00000000000009b0 <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 9b0:	02200893          	li	a7,34
 ecall
 9b4:	00000073          	ecall
 ret
 9b8:	8082                	ret

00000000000009ba <rwlktest>:
.global rwlktest
rwlktest:
 li a7, SYS_rwlktest
 9ba:	02300893          	li	a7,35
 ecall
 9be:	00000073          	ecall
 ret
 9c2:	8082                	ret

00000000000009c4 <cpupin>:
.global cpupin
cpupin:
 li a7, SYS_cpupin
 9c4:	02400893          	li	a7,36
 ecall
 9c8:	00000073          	ecall
 ret
 9cc:	8082                	ret

00000000000009ce <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 9ce:	1101                	addi	sp,sp,-32
 9d0:	ec06                	sd	ra,24(sp)
 9d2:	e822                	sd	s0,16(sp)
 9d4:	1000                	addi	s0,sp,32
 9d6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 9da:	4605                	li	a2,1
 9dc:	fef40593          	addi	a1,s0,-17
 9e0:	f25ff0ef          	jal	904 <write>
}
 9e4:	60e2                	ld	ra,24(sp)
 9e6:	6442                	ld	s0,16(sp)
 9e8:	6105                	addi	sp,sp,32
 9ea:	8082                	ret

00000000000009ec <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 9ec:	715d                	addi	sp,sp,-80
 9ee:	e486                	sd	ra,72(sp)
 9f0:	e0a2                	sd	s0,64(sp)
 9f2:	f84a                	sd	s2,48(sp)
 9f4:	f44e                	sd	s3,40(sp)
 9f6:	0880                	addi	s0,sp,80
 9f8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 9fa:	c6d1                	beqz	a3,a86 <printint+0x9a>
 9fc:	0805d563          	bgez	a1,a86 <printint+0x9a>
    neg = 1;
    x = -xx;
 a00:	40b005b3          	neg	a1,a1
    neg = 1;
 a04:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 a06:	fb840993          	addi	s3,s0,-72
  neg = 0;
 a0a:	86ce                	mv	a3,s3
  i = 0;
 a0c:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 a0e:	00001817          	auipc	a6,0x1
 a12:	80280813          	addi	a6,a6,-2046 # 1210 <digits>
 a16:	88ba                	mv	a7,a4
 a18:	0017051b          	addiw	a0,a4,1
 a1c:	872a                	mv	a4,a0
 a1e:	02c5f7b3          	remu	a5,a1,a2
 a22:	97c2                	add	a5,a5,a6
 a24:	0007c783          	lbu	a5,0(a5)
 a28:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 a2c:	87ae                	mv	a5,a1
 a2e:	02c5d5b3          	divu	a1,a1,a2
 a32:	0685                	addi	a3,a3,1
 a34:	fec7f1e3          	bgeu	a5,a2,a16 <printint+0x2a>
  if(neg)
 a38:	00030c63          	beqz	t1,a50 <printint+0x64>
    buf[i++] = '-';
 a3c:	fd050793          	addi	a5,a0,-48
 a40:	00878533          	add	a0,a5,s0
 a44:	02d00793          	li	a5,45
 a48:	fef50423          	sb	a5,-24(a0)
 a4c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 a50:	02e05563          	blez	a4,a7a <printint+0x8e>
 a54:	fc26                	sd	s1,56(sp)
 a56:	377d                	addiw	a4,a4,-1
 a58:	00e984b3          	add	s1,s3,a4
 a5c:	19fd                	addi	s3,s3,-1
 a5e:	99ba                	add	s3,s3,a4
 a60:	1702                	slli	a4,a4,0x20
 a62:	9301                	srli	a4,a4,0x20
 a64:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 a68:	0004c583          	lbu	a1,0(s1)
 a6c:	854a                	mv	a0,s2
 a6e:	f61ff0ef          	jal	9ce <putc>
  while(--i >= 0)
 a72:	14fd                	addi	s1,s1,-1
 a74:	ff349ae3          	bne	s1,s3,a68 <printint+0x7c>
 a78:	74e2                	ld	s1,56(sp)
}
 a7a:	60a6                	ld	ra,72(sp)
 a7c:	6406                	ld	s0,64(sp)
 a7e:	7942                	ld	s2,48(sp)
 a80:	79a2                	ld	s3,40(sp)
 a82:	6161                	addi	sp,sp,80
 a84:	8082                	ret
  neg = 0;
 a86:	4301                	li	t1,0
 a88:	bfbd                	j	a06 <printint+0x1a>

0000000000000a8a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 a8a:	711d                	addi	sp,sp,-96
 a8c:	ec86                	sd	ra,88(sp)
 a8e:	e8a2                	sd	s0,80(sp)
 a90:	e4a6                	sd	s1,72(sp)
 a92:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 a94:	0005c483          	lbu	s1,0(a1)
 a98:	22048363          	beqz	s1,cbe <vprintf+0x234>
 a9c:	e0ca                	sd	s2,64(sp)
 a9e:	fc4e                	sd	s3,56(sp)
 aa0:	f852                	sd	s4,48(sp)
 aa2:	f456                	sd	s5,40(sp)
 aa4:	f05a                	sd	s6,32(sp)
 aa6:	ec5e                	sd	s7,24(sp)
 aa8:	e862                	sd	s8,16(sp)
 aaa:	8b2a                	mv	s6,a0
 aac:	8a2e                	mv	s4,a1
 aae:	8bb2                	mv	s7,a2
  state = 0;
 ab0:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 ab2:	4901                	li	s2,0
 ab4:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 ab6:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 aba:	06400c13          	li	s8,100
 abe:	a00d                	j	ae0 <vprintf+0x56>
        putc(fd, c0);
 ac0:	85a6                	mv	a1,s1
 ac2:	855a                	mv	a0,s6
 ac4:	f0bff0ef          	jal	9ce <putc>
 ac8:	a019                	j	ace <vprintf+0x44>
    } else if(state == '%'){
 aca:	03598363          	beq	s3,s5,af0 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 ace:	0019079b          	addiw	a5,s2,1
 ad2:	893e                	mv	s2,a5
 ad4:	873e                	mv	a4,a5
 ad6:	97d2                	add	a5,a5,s4
 ad8:	0007c483          	lbu	s1,0(a5)
 adc:	1c048a63          	beqz	s1,cb0 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 ae0:	0004879b          	sext.w	a5,s1
    if(state == 0){
 ae4:	fe0993e3          	bnez	s3,aca <vprintf+0x40>
      if(c0 == '%'){
 ae8:	fd579ce3          	bne	a5,s5,ac0 <vprintf+0x36>
        state = '%';
 aec:	89be                	mv	s3,a5
 aee:	b7c5                	j	ace <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 af0:	00ea06b3          	add	a3,s4,a4
 af4:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 af8:	1c060863          	beqz	a2,cc8 <vprintf+0x23e>
      if(c0 == 'd'){
 afc:	03878763          	beq	a5,s8,b2a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 b00:	f9478693          	addi	a3,a5,-108
 b04:	0016b693          	seqz	a3,a3
 b08:	f9c60593          	addi	a1,a2,-100
 b0c:	e99d                	bnez	a1,b42 <vprintf+0xb8>
 b0e:	ca95                	beqz	a3,b42 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 b10:	008b8493          	addi	s1,s7,8
 b14:	4685                	li	a3,1
 b16:	4629                	li	a2,10
 b18:	000bb583          	ld	a1,0(s7)
 b1c:	855a                	mv	a0,s6
 b1e:	ecfff0ef          	jal	9ec <printint>
        i += 1;
 b22:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 b24:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 b26:	4981                	li	s3,0
 b28:	b75d                	j	ace <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 b2a:	008b8493          	addi	s1,s7,8
 b2e:	4685                	li	a3,1
 b30:	4629                	li	a2,10
 b32:	000ba583          	lw	a1,0(s7)
 b36:	855a                	mv	a0,s6
 b38:	eb5ff0ef          	jal	9ec <printint>
 b3c:	8ba6                	mv	s7,s1
      state = 0;
 b3e:	4981                	li	s3,0
 b40:	b779                	j	ace <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 b42:	9752                	add	a4,a4,s4
 b44:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 b48:	f9460713          	addi	a4,a2,-108
 b4c:	00173713          	seqz	a4,a4
 b50:	8f75                	and	a4,a4,a3
 b52:	f9c58513          	addi	a0,a1,-100
 b56:	18051363          	bnez	a0,cdc <vprintf+0x252>
 b5a:	18070163          	beqz	a4,cdc <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 b5e:	008b8493          	addi	s1,s7,8
 b62:	4685                	li	a3,1
 b64:	4629                	li	a2,10
 b66:	000bb583          	ld	a1,0(s7)
 b6a:	855a                	mv	a0,s6
 b6c:	e81ff0ef          	jal	9ec <printint>
        i += 2;
 b70:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 b72:	8ba6                	mv	s7,s1
      state = 0;
 b74:	4981                	li	s3,0
        i += 2;
 b76:	bfa1                	j	ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 b78:	008b8493          	addi	s1,s7,8
 b7c:	4681                	li	a3,0
 b7e:	4629                	li	a2,10
 b80:	000be583          	lwu	a1,0(s7)
 b84:	855a                	mv	a0,s6
 b86:	e67ff0ef          	jal	9ec <printint>
 b8a:	8ba6                	mv	s7,s1
      state = 0;
 b8c:	4981                	li	s3,0
 b8e:	b781                	j	ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 b90:	008b8493          	addi	s1,s7,8
 b94:	4681                	li	a3,0
 b96:	4629                	li	a2,10
 b98:	000bb583          	ld	a1,0(s7)
 b9c:	855a                	mv	a0,s6
 b9e:	e4fff0ef          	jal	9ec <printint>
        i += 1;
 ba2:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 ba4:	8ba6                	mv	s7,s1
      state = 0;
 ba6:	4981                	li	s3,0
 ba8:	b71d                	j	ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 baa:	008b8493          	addi	s1,s7,8
 bae:	4681                	li	a3,0
 bb0:	4629                	li	a2,10
 bb2:	000bb583          	ld	a1,0(s7)
 bb6:	855a                	mv	a0,s6
 bb8:	e35ff0ef          	jal	9ec <printint>
        i += 2;
 bbc:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 bbe:	8ba6                	mv	s7,s1
      state = 0;
 bc0:	4981                	li	s3,0
        i += 2;
 bc2:	b731                	j	ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 bc4:	008b8493          	addi	s1,s7,8
 bc8:	4681                	li	a3,0
 bca:	4641                	li	a2,16
 bcc:	000be583          	lwu	a1,0(s7)
 bd0:	855a                	mv	a0,s6
 bd2:	e1bff0ef          	jal	9ec <printint>
 bd6:	8ba6                	mv	s7,s1
      state = 0;
 bd8:	4981                	li	s3,0
 bda:	bdd5                	j	ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 bdc:	008b8493          	addi	s1,s7,8
 be0:	4681                	li	a3,0
 be2:	4641                	li	a2,16
 be4:	000bb583          	ld	a1,0(s7)
 be8:	855a                	mv	a0,s6
 bea:	e03ff0ef          	jal	9ec <printint>
        i += 1;
 bee:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 bf0:	8ba6                	mv	s7,s1
      state = 0;
 bf2:	4981                	li	s3,0
 bf4:	bde9                	j	ace <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 bf6:	008b8493          	addi	s1,s7,8
 bfa:	4681                	li	a3,0
 bfc:	4641                	li	a2,16
 bfe:	000bb583          	ld	a1,0(s7)
 c02:	855a                	mv	a0,s6
 c04:	de9ff0ef          	jal	9ec <printint>
        i += 2;
 c08:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 c0a:	8ba6                	mv	s7,s1
      state = 0;
 c0c:	4981                	li	s3,0
        i += 2;
 c0e:	b5c1                	j	ace <vprintf+0x44>
 c10:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 c12:	008b8793          	addi	a5,s7,8
 c16:	8cbe                	mv	s9,a5
 c18:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 c1c:	03000593          	li	a1,48
 c20:	855a                	mv	a0,s6
 c22:	dadff0ef          	jal	9ce <putc>
  putc(fd, 'x');
 c26:	07800593          	li	a1,120
 c2a:	855a                	mv	a0,s6
 c2c:	da3ff0ef          	jal	9ce <putc>
 c30:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 c32:	00000b97          	auipc	s7,0x0
 c36:	5deb8b93          	addi	s7,s7,1502 # 1210 <digits>
 c3a:	03c9d793          	srli	a5,s3,0x3c
 c3e:	97de                	add	a5,a5,s7
 c40:	0007c583          	lbu	a1,0(a5)
 c44:	855a                	mv	a0,s6
 c46:	d89ff0ef          	jal	9ce <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 c4a:	0992                	slli	s3,s3,0x4
 c4c:	34fd                	addiw	s1,s1,-1
 c4e:	f4f5                	bnez	s1,c3a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 c50:	8be6                	mv	s7,s9
      state = 0;
 c52:	4981                	li	s3,0
 c54:	6ca2                	ld	s9,8(sp)
 c56:	bda5                	j	ace <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 c58:	008b8493          	addi	s1,s7,8
 c5c:	000bc583          	lbu	a1,0(s7)
 c60:	855a                	mv	a0,s6
 c62:	d6dff0ef          	jal	9ce <putc>
 c66:	8ba6                	mv	s7,s1
      state = 0;
 c68:	4981                	li	s3,0
 c6a:	b595                	j	ace <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 c6c:	008b8993          	addi	s3,s7,8
 c70:	000bb483          	ld	s1,0(s7)
 c74:	cc91                	beqz	s1,c90 <vprintf+0x206>
        for(; *s; s++)
 c76:	0004c583          	lbu	a1,0(s1)
 c7a:	c985                	beqz	a1,caa <vprintf+0x220>
          putc(fd, *s);
 c7c:	855a                	mv	a0,s6
 c7e:	d51ff0ef          	jal	9ce <putc>
        for(; *s; s++)
 c82:	0485                	addi	s1,s1,1
 c84:	0004c583          	lbu	a1,0(s1)
 c88:	f9f5                	bnez	a1,c7c <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 c8a:	8bce                	mv	s7,s3
      state = 0;
 c8c:	4981                	li	s3,0
 c8e:	b581                	j	ace <vprintf+0x44>
          s = "(null)";
 c90:	00000497          	auipc	s1,0x0
 c94:	55048493          	addi	s1,s1,1360 # 11e0 <statistics+0x2c2>
        for(; *s; s++)
 c98:	02800593          	li	a1,40
 c9c:	b7c5                	j	c7c <vprintf+0x1f2>
        putc(fd, '%');
 c9e:	85be                	mv	a1,a5
 ca0:	855a                	mv	a0,s6
 ca2:	d2dff0ef          	jal	9ce <putc>
      state = 0;
 ca6:	4981                	li	s3,0
 ca8:	b51d                	j	ace <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 caa:	8bce                	mv	s7,s3
      state = 0;
 cac:	4981                	li	s3,0
 cae:	b505                	j	ace <vprintf+0x44>
 cb0:	6906                	ld	s2,64(sp)
 cb2:	79e2                	ld	s3,56(sp)
 cb4:	7a42                	ld	s4,48(sp)
 cb6:	7aa2                	ld	s5,40(sp)
 cb8:	7b02                	ld	s6,32(sp)
 cba:	6be2                	ld	s7,24(sp)
 cbc:	6c42                	ld	s8,16(sp)
    }
  }
}
 cbe:	60e6                	ld	ra,88(sp)
 cc0:	6446                	ld	s0,80(sp)
 cc2:	64a6                	ld	s1,72(sp)
 cc4:	6125                	addi	sp,sp,96
 cc6:	8082                	ret
      if(c0 == 'd'){
 cc8:	06400713          	li	a4,100
 ccc:	e4e78fe3          	beq	a5,a4,b2a <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 cd0:	f9478693          	addi	a3,a5,-108
 cd4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 cd8:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 cda:	4701                	li	a4,0
      } else if(c0 == 'u'){
 cdc:	07500513          	li	a0,117
 ce0:	e8a78ce3          	beq	a5,a0,b78 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 ce4:	f8b60513          	addi	a0,a2,-117
 ce8:	e119                	bnez	a0,cee <vprintf+0x264>
 cea:	ea0693e3          	bnez	a3,b90 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 cee:	f8b58513          	addi	a0,a1,-117
 cf2:	e119                	bnez	a0,cf8 <vprintf+0x26e>
 cf4:	ea071be3          	bnez	a4,baa <vprintf+0x120>
      } else if(c0 == 'x'){
 cf8:	07800513          	li	a0,120
 cfc:	eca784e3          	beq	a5,a0,bc4 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 d00:	f8860613          	addi	a2,a2,-120
 d04:	e219                	bnez	a2,d0a <vprintf+0x280>
 d06:	ec069be3          	bnez	a3,bdc <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 d0a:	f8858593          	addi	a1,a1,-120
 d0e:	e199                	bnez	a1,d14 <vprintf+0x28a>
 d10:	ee0713e3          	bnez	a4,bf6 <vprintf+0x16c>
      } else if(c0 == 'p'){
 d14:	07000713          	li	a4,112
 d18:	eee78ce3          	beq	a5,a4,c10 <vprintf+0x186>
      } else if(c0 == 'c'){
 d1c:	06300713          	li	a4,99
 d20:	f2e78ce3          	beq	a5,a4,c58 <vprintf+0x1ce>
      } else if(c0 == 's'){
 d24:	07300713          	li	a4,115
 d28:	f4e782e3          	beq	a5,a4,c6c <vprintf+0x1e2>
      } else if(c0 == '%'){
 d2c:	02500713          	li	a4,37
 d30:	f6e787e3          	beq	a5,a4,c9e <vprintf+0x214>
        putc(fd, '%');
 d34:	02500593          	li	a1,37
 d38:	855a                	mv	a0,s6
 d3a:	c95ff0ef          	jal	9ce <putc>
        putc(fd, c0);
 d3e:	85a6                	mv	a1,s1
 d40:	855a                	mv	a0,s6
 d42:	c8dff0ef          	jal	9ce <putc>
      state = 0;
 d46:	4981                	li	s3,0
 d48:	b359                	j	ace <vprintf+0x44>

0000000000000d4a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 d4a:	715d                	addi	sp,sp,-80
 d4c:	ec06                	sd	ra,24(sp)
 d4e:	e822                	sd	s0,16(sp)
 d50:	1000                	addi	s0,sp,32
 d52:	e010                	sd	a2,0(s0)
 d54:	e414                	sd	a3,8(s0)
 d56:	e818                	sd	a4,16(s0)
 d58:	ec1c                	sd	a5,24(s0)
 d5a:	03043023          	sd	a6,32(s0)
 d5e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 d62:	8622                	mv	a2,s0
 d64:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 d68:	d23ff0ef          	jal	a8a <vprintf>
}
 d6c:	60e2                	ld	ra,24(sp)
 d6e:	6442                	ld	s0,16(sp)
 d70:	6161                	addi	sp,sp,80
 d72:	8082                	ret

0000000000000d74 <printf>:

void
printf(const char *fmt, ...)
{
 d74:	711d                	addi	sp,sp,-96
 d76:	ec06                	sd	ra,24(sp)
 d78:	e822                	sd	s0,16(sp)
 d7a:	1000                	addi	s0,sp,32
 d7c:	e40c                	sd	a1,8(s0)
 d7e:	e810                	sd	a2,16(s0)
 d80:	ec14                	sd	a3,24(s0)
 d82:	f018                	sd	a4,32(s0)
 d84:	f41c                	sd	a5,40(s0)
 d86:	03043823          	sd	a6,48(s0)
 d8a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 d8e:	00840613          	addi	a2,s0,8
 d92:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 d96:	85aa                	mv	a1,a0
 d98:	4505                	li	a0,1
 d9a:	cf1ff0ef          	jal	a8a <vprintf>
}
 d9e:	60e2                	ld	ra,24(sp)
 da0:	6442                	ld	s0,16(sp)
 da2:	6125                	addi	sp,sp,96
 da4:	8082                	ret

0000000000000da6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 da6:	1141                	addi	sp,sp,-16
 da8:	e406                	sd	ra,8(sp)
 daa:	e022                	sd	s0,0(sp)
 dac:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 dae:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 db2:	00001797          	auipc	a5,0x1
 db6:	24e7b783          	ld	a5,590(a5) # 2000 <freep>
 dba:	a039                	j	dc8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 dbc:	6398                	ld	a4,0(a5)
 dbe:	00e7e463          	bltu	a5,a4,dc6 <free+0x20>
 dc2:	00e6ea63          	bltu	a3,a4,dd6 <free+0x30>
{
 dc6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 dc8:	fed7fae3          	bgeu	a5,a3,dbc <free+0x16>
 dcc:	6398                	ld	a4,0(a5)
 dce:	00e6e463          	bltu	a3,a4,dd6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 dd2:	fee7eae3          	bltu	a5,a4,dc6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 dd6:	ff852583          	lw	a1,-8(a0)
 dda:	6390                	ld	a2,0(a5)
 ddc:	02059813          	slli	a6,a1,0x20
 de0:	01c85713          	srli	a4,a6,0x1c
 de4:	9736                	add	a4,a4,a3
 de6:	02e60563          	beq	a2,a4,e10 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 dea:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 dee:	4790                	lw	a2,8(a5)
 df0:	02061593          	slli	a1,a2,0x20
 df4:	01c5d713          	srli	a4,a1,0x1c
 df8:	973e                	add	a4,a4,a5
 dfa:	02e68263          	beq	a3,a4,e1e <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 dfe:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 e00:	00001717          	auipc	a4,0x1
 e04:	20f73023          	sd	a5,512(a4) # 2000 <freep>
}
 e08:	60a2                	ld	ra,8(sp)
 e0a:	6402                	ld	s0,0(sp)
 e0c:	0141                	addi	sp,sp,16
 e0e:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 e10:	4618                	lw	a4,8(a2)
 e12:	9f2d                	addw	a4,a4,a1
 e14:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 e18:	6398                	ld	a4,0(a5)
 e1a:	6310                	ld	a2,0(a4)
 e1c:	b7f9                	j	dea <free+0x44>
    p->s.size += bp->s.size;
 e1e:	ff852703          	lw	a4,-8(a0)
 e22:	9f31                	addw	a4,a4,a2
 e24:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 e26:	ff053683          	ld	a3,-16(a0)
 e2a:	bfd1                	j	dfe <free+0x58>

0000000000000e2c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 e2c:	7139                	addi	sp,sp,-64
 e2e:	fc06                	sd	ra,56(sp)
 e30:	f822                	sd	s0,48(sp)
 e32:	f04a                	sd	s2,32(sp)
 e34:	ec4e                	sd	s3,24(sp)
 e36:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 e38:	02051993          	slli	s3,a0,0x20
 e3c:	0209d993          	srli	s3,s3,0x20
 e40:	09bd                	addi	s3,s3,15
 e42:	0049d993          	srli	s3,s3,0x4
 e46:	2985                	addiw	s3,s3,1
 e48:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 e4a:	00001517          	auipc	a0,0x1
 e4e:	1b653503          	ld	a0,438(a0) # 2000 <freep>
 e52:	c905                	beqz	a0,e82 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 e54:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 e56:	4798                	lw	a4,8(a5)
 e58:	09377663          	bgeu	a4,s3,ee4 <malloc+0xb8>
 e5c:	f426                	sd	s1,40(sp)
 e5e:	e852                	sd	s4,16(sp)
 e60:	e456                	sd	s5,8(sp)
 e62:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 e64:	8a4e                	mv	s4,s3
 e66:	6705                	lui	a4,0x1
 e68:	00e9f363          	bgeu	s3,a4,e6e <malloc+0x42>
 e6c:	6a05                	lui	s4,0x1
 e6e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 e72:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 e76:	00001497          	auipc	s1,0x1
 e7a:	18a48493          	addi	s1,s1,394 # 2000 <freep>
  if(p == SBRK_ERROR)
 e7e:	5afd                	li	s5,-1
 e80:	a83d                	j	ebe <malloc+0x92>
 e82:	f426                	sd	s1,40(sp)
 e84:	e852                	sd	s4,16(sp)
 e86:	e456                	sd	s5,8(sp)
 e88:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 e8a:	00002797          	auipc	a5,0x2
 e8e:	18678793          	addi	a5,a5,390 # 3010 <base>
 e92:	00001717          	auipc	a4,0x1
 e96:	16f73723          	sd	a5,366(a4) # 2000 <freep>
 e9a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 e9c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ea0:	b7d1                	j	e64 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 ea2:	6398                	ld	a4,0(a5)
 ea4:	e118                	sd	a4,0(a0)
 ea6:	a899                	j	efc <malloc+0xd0>
  hp->s.size = nu;
 ea8:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 eac:	0541                	addi	a0,a0,16
 eae:	ef9ff0ef          	jal	da6 <free>
  return freep;
 eb2:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 eb4:	c125                	beqz	a0,f14 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 eb6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 eb8:	4798                	lw	a4,8(a5)
 eba:	03277163          	bgeu	a4,s2,edc <malloc+0xb0>
    if(p == freep)
 ebe:	6098                	ld	a4,0(s1)
 ec0:	853e                	mv	a0,a5
 ec2:	fef71ae3          	bne	a4,a5,eb6 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 ec6:	8552                	mv	a0,s4
 ec8:	9e9ff0ef          	jal	8b0 <sbrk>
  if(p == SBRK_ERROR)
 ecc:	fd551ee3          	bne	a0,s5,ea8 <malloc+0x7c>
        return 0;
 ed0:	4501                	li	a0,0
 ed2:	74a2                	ld	s1,40(sp)
 ed4:	6a42                	ld	s4,16(sp)
 ed6:	6aa2                	ld	s5,8(sp)
 ed8:	6b02                	ld	s6,0(sp)
 eda:	a03d                	j	f08 <malloc+0xdc>
 edc:	74a2                	ld	s1,40(sp)
 ede:	6a42                	ld	s4,16(sp)
 ee0:	6aa2                	ld	s5,8(sp)
 ee2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 ee4:	fae90fe3          	beq	s2,a4,ea2 <malloc+0x76>
        p->s.size -= nunits;
 ee8:	4137073b          	subw	a4,a4,s3
 eec:	c798                	sw	a4,8(a5)
        p += p->s.size;
 eee:	02071693          	slli	a3,a4,0x20
 ef2:	01c6d713          	srli	a4,a3,0x1c
 ef6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 ef8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 efc:	00001717          	auipc	a4,0x1
 f00:	10a73223          	sd	a0,260(a4) # 2000 <freep>
      return (void*)(p + 1);
 f04:	01078513          	addi	a0,a5,16
  }
}
 f08:	70e2                	ld	ra,56(sp)
 f0a:	7442                	ld	s0,48(sp)
 f0c:	7902                	ld	s2,32(sp)
 f0e:	69e2                	ld	s3,24(sp)
 f10:	6121                	addi	sp,sp,64
 f12:	8082                	ret
 f14:	74a2                	ld	s1,40(sp)
 f16:	6a42                	ld	s4,16(sp)
 f18:	6aa2                	ld	s5,8(sp)
 f1a:	6b02                	ld	s6,0(sp)
 f1c:	b7f5                	j	f08 <malloc+0xdc>

0000000000000f1e <statistics>:
#include "kernel/fcntl.h"
#include "user/user.h"

int
statistics(void *buf, int sz)
{
 f1e:	7179                	addi	sp,sp,-48
 f20:	f406                	sd	ra,40(sp)
 f22:	f022                	sd	s0,32(sp)
 f24:	ec26                	sd	s1,24(sp)
 f26:	e84a                	sd	s2,16(sp)
 f28:	e44e                	sd	s3,8(sp)
 f2a:	e052                	sd	s4,0(sp)
 f2c:	1800                	addi	s0,sp,48
 f2e:	8a2a                	mv	s4,a0
 f30:	892e                	mv	s2,a1
  int fd, i, n;
  
  fd = open("statistics", O_RDONLY);
 f32:	4581                	li	a1,0
 f34:	00000517          	auipc	a0,0x0
 f38:	2b450513          	addi	a0,a0,692 # 11e8 <statistics+0x2ca>
 f3c:	9e9ff0ef          	jal	924 <open>
  if(fd < 0) {
 f40:	02054e63          	bltz	a0,f7c <statistics+0x5e>
 f44:	89aa                	mv	s3,a0
      fprintf(2, "stats: open failed\n");
      exit(1);
  }
  for (i = 0; i < sz; ) {
 f46:	4481                	li	s1,0
 f48:	01205e63          	blez	s2,f64 <statistics+0x46>
    if ((n = read(fd, buf+i, sz-i)) < 0) {
 f4c:	4099063b          	subw	a2,s2,s1
 f50:	009a05b3          	add	a1,s4,s1
 f54:	854e                	mv	a0,s3
 f56:	9a7ff0ef          	jal	8fc <read>
 f5a:	00054563          	bltz	a0,f64 <statistics+0x46>
      break;
    }
    i += n;
 f5e:	9ca9                	addw	s1,s1,a0
  for (i = 0; i < sz; ) {
 f60:	ff24c6e3          	blt	s1,s2,f4c <statistics+0x2e>
  }
  close(fd);
 f64:	854e                	mv	a0,s3
 f66:	9a7ff0ef          	jal	90c <close>
  return i;
}
 f6a:	8526                	mv	a0,s1
 f6c:	70a2                	ld	ra,40(sp)
 f6e:	7402                	ld	s0,32(sp)
 f70:	64e2                	ld	s1,24(sp)
 f72:	6942                	ld	s2,16(sp)
 f74:	69a2                	ld	s3,8(sp)
 f76:	6a02                	ld	s4,0(sp)
 f78:	6145                	addi	sp,sp,48
 f7a:	8082                	ret
      fprintf(2, "stats: open failed\n");
 f7c:	00000597          	auipc	a1,0x0
 f80:	27c58593          	addi	a1,a1,636 # 11f8 <statistics+0x2da>
 f84:	4509                	li	a0,2
 f86:	dc5ff0ef          	jal	d4a <fprintf>
      exit(1);
 f8a:	4505                	li	a0,1
 f8c:	959ff0ef          	jal	8e4 <exit>
