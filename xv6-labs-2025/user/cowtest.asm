
user/_cowtest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <simpletest>:
// allocate more than half of physical memory,
// then fork. this will fail in the default
// kernel, which does not support copy-on-write.
void
simpletest()
{
   0:	7179                	addi	sp,sp,-48
   2:	f406                	sd	ra,40(sp)
   4:	f022                	sd	s0,32(sp)
   6:	ec26                	sd	s1,24(sp)
   8:	e84a                	sd	s2,16(sp)
   a:	e44e                	sd	s3,8(sp)
   c:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = (phys_size / 3) * 2;

  printf("simple: ");
   e:	00001517          	auipc	a0,0x1
  12:	d2250513          	addi	a0,a0,-734 # d30 <malloc+0xf2>
  16:	371000ef          	jal	b86 <printf>
  
  char *p = sbrk(sz);
  1a:	05555537          	lui	a0,0x5555
  1e:	55450513          	addi	a0,a0,1364 # 5555554 <base+0x5550544>
  22:	6ea000ef          	jal	70c <sbrk>
  if(p == (char*)0xffffffffffffffffL){
  26:	57fd                	li	a5,-1
  28:	04f50b63          	beq	a0,a5,7e <simpletest+0x7e>
  2c:	84aa                	mv	s1,a0
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  for(char *q = p; q < p + sz; q += 4096){
  2e:	05556937          	lui	s2,0x5556
  32:	992a                	add	s2,s2,a0
  34:	6985                	lui	s3,0x1
    *(int*)q = getpid();
  36:	78a000ef          	jal	7c0 <getpid>
  3a:	c088                	sw	a0,0(s1)
  for(char *q = p; q < p + sz; q += 4096){
  3c:	94ce                	add	s1,s1,s3
  3e:	fe991ce3          	bne	s2,s1,36 <simpletest+0x36>
  }

  int pid = fork();
  42:	6f6000ef          	jal	738 <fork>
  if(pid < 0){
  46:	04054963          	bltz	a0,98 <simpletest+0x98>
    printf("fork() failed\n");
    exit(-1);
  }

  if(pid == 0)
  4a:	c125                	beqz	a0,aa <simpletest+0xaa>
    exit(0);

  wait(0);
  4c:	4501                	li	a0,0
  4e:	6fa000ef          	jal	748 <wait>

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
  52:	faaab537          	lui	a0,0xfaaab
  56:	aac50513          	addi	a0,a0,-1364 # fffffffffaaaaaac <base+0xfffffffffaaa5a9c>
  5a:	6b2000ef          	jal	70c <sbrk>
  5e:	57fd                	li	a5,-1
  60:	04f50763          	beq	a0,a5,ae <simpletest+0xae>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
  64:	00001517          	auipc	a0,0x1
  68:	d1c50513          	addi	a0,a0,-740 # d80 <malloc+0x142>
  6c:	31b000ef          	jal	b86 <printf>
}
  70:	70a2                	ld	ra,40(sp)
  72:	7402                	ld	s0,32(sp)
  74:	64e2                	ld	s1,24(sp)
  76:	6942                	ld	s2,16(sp)
  78:	69a2                	ld	s3,8(sp)
  7a:	6145                	addi	sp,sp,48
  7c:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
  7e:	055555b7          	lui	a1,0x5555
  82:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  86:	00001517          	auipc	a0,0x1
  8a:	cba50513          	addi	a0,a0,-838 # d40 <malloc+0x102>
  8e:	2f9000ef          	jal	b86 <printf>
    exit(-1);
  92:	557d                	li	a0,-1
  94:	6ac000ef          	jal	740 <exit>
    printf("fork() failed\n");
  98:	00001517          	auipc	a0,0x1
  9c:	cc050513          	addi	a0,a0,-832 # d58 <malloc+0x11a>
  a0:	2e7000ef          	jal	b86 <printf>
    exit(-1);
  a4:	557d                	li	a0,-1
  a6:	69a000ef          	jal	740 <exit>
    exit(0);
  aa:	696000ef          	jal	740 <exit>
    printf("sbrk(-%d) failed\n", sz);
  ae:	055555b7          	lui	a1,0x5555
  b2:	55458593          	addi	a1,a1,1364 # 5555554 <base+0x5550544>
  b6:	00001517          	auipc	a0,0x1
  ba:	cb250513          	addi	a0,a0,-846 # d68 <malloc+0x12a>
  be:	2c9000ef          	jal	b86 <printf>
    exit(-1);
  c2:	557d                	li	a0,-1
  c4:	67c000ef          	jal	740 <exit>

00000000000000c8 <threetest>:
// this causes more than half of physical memory
// to be allocated, so it also checks whether
// copied pages are freed.
void
threetest()
{
  c8:	7179                	addi	sp,sp,-48
  ca:	f406                	sd	ra,40(sp)
  cc:	f022                	sd	s0,32(sp)
  ce:	ec26                	sd	s1,24(sp)
  d0:	e84a                	sd	s2,16(sp)
  d2:	e44e                	sd	s3,8(sp)
  d4:	e052                	sd	s4,0(sp)
  d6:	1800                	addi	s0,sp,48
  uint64 phys_size = PHYSTOP - KERNBASE;
  int sz = phys_size / 4;
  int pid1, pid2;

  printf("three: ");
  d8:	00001517          	auipc	a0,0x1
  dc:	cb050513          	addi	a0,a0,-848 # d88 <malloc+0x14a>
  e0:	2a7000ef          	jal	b86 <printf>
  
  char *p = sbrk(sz);
  e4:	02000537          	lui	a0,0x2000
  e8:	624000ef          	jal	70c <sbrk>
  ec:	84aa                	mv	s1,a0
  if(p == (char*)0xffffffffffffffffL){
  ee:	57fd                	li	a5,-1
  f0:	06f50863          	beq	a0,a5,160 <threetest+0x98>
    printf("sbrk(%d) failed\n", sz);
    exit(-1);
  }

  pid1 = fork();
  f4:	644000ef          	jal	738 <fork>
  if(pid1 < 0){
  f8:	06054f63          	bltz	a0,176 <threetest+0xae>
    printf("fork failed\n");
    exit(-1);
  }
  if(pid1 == 0){
  fc:	c551                	beqz	a0,188 <threetest+0xc0>
      *(int*)q = 9999;
    }
    exit(0);
  }

  for(char *q = p; q < p + sz; q += 4096){
  fe:	020009b7          	lui	s3,0x2000
 102:	99a6                	add	s3,s3,s1
 104:	8926                	mv	s2,s1
 106:	6a05                	lui	s4,0x1
    *(int*)q = getpid();
 108:	6b8000ef          	jal	7c0 <getpid>
 10c:	00a92023          	sw	a0,0(s2) # 5556000 <base+0x5550ff0>
  for(char *q = p; q < p + sz; q += 4096){
 110:	9952                	add	s2,s2,s4
 112:	ff391be3          	bne	s2,s3,108 <threetest+0x40>
  }

  wait(0);
 116:	4501                	li	a0,0
 118:	630000ef          	jal	748 <wait>

  pause(1);
 11c:	4505                	li	a0,1
 11e:	6b2000ef          	jal	7d0 <pause>

  for(char *q = p; q < p + sz; q += 4096){
 122:	6a05                	lui	s4,0x1
    if(*(int*)q != getpid()){
 124:	0004a903          	lw	s2,0(s1)
 128:	698000ef          	jal	7c0 <getpid>
 12c:	0ca91c63          	bne	s2,a0,204 <threetest+0x13c>
  for(char *q = p; q < p + sz; q += 4096){
 130:	94d2                	add	s1,s1,s4
 132:	ff3499e3          	bne	s1,s3,124 <threetest+0x5c>
      printf("wrong content\n");
      exit(-1);
    }
  }

  if(sbrk(-sz) == (char*)0xffffffffffffffffL){
 136:	fe000537          	lui	a0,0xfe000
 13a:	5d2000ef          	jal	70c <sbrk>
 13e:	57fd                	li	a5,-1
 140:	0cf50b63          	beq	a0,a5,216 <threetest+0x14e>
    printf("sbrk(-%d) failed\n", sz);
    exit(-1);
  }

  printf("ok\n");
 144:	00001517          	auipc	a0,0x1
 148:	c3c50513          	addi	a0,a0,-964 # d80 <malloc+0x142>
 14c:	23b000ef          	jal	b86 <printf>
}
 150:	70a2                	ld	ra,40(sp)
 152:	7402                	ld	s0,32(sp)
 154:	64e2                	ld	s1,24(sp)
 156:	6942                	ld	s2,16(sp)
 158:	69a2                	ld	s3,8(sp)
 15a:	6a02                	ld	s4,0(sp)
 15c:	6145                	addi	sp,sp,48
 15e:	8082                	ret
    printf("sbrk(%d) failed\n", sz);
 160:	020005b7          	lui	a1,0x2000
 164:	00001517          	auipc	a0,0x1
 168:	bdc50513          	addi	a0,a0,-1060 # d40 <malloc+0x102>
 16c:	21b000ef          	jal	b86 <printf>
    exit(-1);
 170:	8526                	mv	a0,s1
 172:	5ce000ef          	jal	740 <exit>
    printf("fork failed\n");
 176:	00001517          	auipc	a0,0x1
 17a:	c1a50513          	addi	a0,a0,-998 # d90 <malloc+0x152>
 17e:	209000ef          	jal	b86 <printf>
    exit(-1);
 182:	557d                	li	a0,-1
 184:	5bc000ef          	jal	740 <exit>
    pid2 = fork();
 188:	5b0000ef          	jal	738 <fork>
    if(pid2 < 0){
 18c:	02054c63          	bltz	a0,1c4 <threetest+0xfc>
    if(pid2 == 0){
 190:	e139                	bnez	a0,1d6 <threetest+0x10e>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 192:	0199a9b7          	lui	s3,0x199a
 196:	99a6                	add	s3,s3,s1
 198:	8926                	mv	s2,s1
 19a:	6a05                	lui	s4,0x1
        *(int*)q = getpid();
 19c:	624000ef          	jal	7c0 <getpid>
 1a0:	00a92023          	sw	a0,0(s2)
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 1a4:	9952                	add	s2,s2,s4
 1a6:	ff391be3          	bne	s2,s3,19c <threetest+0xd4>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 1aa:	6a05                	lui	s4,0x1
        if(*(int*)q != getpid()){
 1ac:	0004a903          	lw	s2,0(s1)
 1b0:	610000ef          	jal	7c0 <getpid>
 1b4:	02a91f63          	bne	s2,a0,1f2 <threetest+0x12a>
      for(char *q = p; q < p + (sz/5)*4; q += 4096){
 1b8:	94d2                	add	s1,s1,s4
 1ba:	ff3499e3          	bne	s1,s3,1ac <threetest+0xe4>
      exit(-1);
 1be:	557d                	li	a0,-1
 1c0:	580000ef          	jal	740 <exit>
      printf("fork failed");
 1c4:	00001517          	auipc	a0,0x1
 1c8:	bdc50513          	addi	a0,a0,-1060 # da0 <malloc+0x162>
 1cc:	1bb000ef          	jal	b86 <printf>
      exit(-1);
 1d0:	557d                	li	a0,-1
 1d2:	56e000ef          	jal	740 <exit>
    for(char *q = p; q < p + (sz/2); q += 4096){
 1d6:	01000737          	lui	a4,0x1000
 1da:	9726                	add	a4,a4,s1
      *(int*)q = 9999;
 1dc:	6789                	lui	a5,0x2
 1de:	70f78793          	addi	a5,a5,1807 # 270f <buf+0x6ff>
    for(char *q = p; q < p + (sz/2); q += 4096){
 1e2:	6685                	lui	a3,0x1
      *(int*)q = 9999;
 1e4:	c09c                	sw	a5,0(s1)
    for(char *q = p; q < p + (sz/2); q += 4096){
 1e6:	94b6                	add	s1,s1,a3
 1e8:	fee49ee3          	bne	s1,a4,1e4 <threetest+0x11c>
    exit(0);
 1ec:	4501                	li	a0,0
 1ee:	552000ef          	jal	740 <exit>
          printf("wrong content\n");
 1f2:	00001517          	auipc	a0,0x1
 1f6:	bbe50513          	addi	a0,a0,-1090 # db0 <malloc+0x172>
 1fa:	18d000ef          	jal	b86 <printf>
          exit(-1);
 1fe:	557d                	li	a0,-1
 200:	540000ef          	jal	740 <exit>
      printf("wrong content\n");
 204:	00001517          	auipc	a0,0x1
 208:	bac50513          	addi	a0,a0,-1108 # db0 <malloc+0x172>
 20c:	17b000ef          	jal	b86 <printf>
      exit(-1);
 210:	557d                	li	a0,-1
 212:	52e000ef          	jal	740 <exit>
    printf("sbrk(-%d) failed\n", sz);
 216:	020005b7          	lui	a1,0x2000
 21a:	00001517          	auipc	a0,0x1
 21e:	b4e50513          	addi	a0,a0,-1202 # d68 <malloc+0x12a>
 222:	165000ef          	jal	b86 <printf>
    exit(-1);
 226:	557d                	li	a0,-1
 228:	518000ef          	jal	740 <exit>

000000000000022c <filetest>:
char junk3[4096];

// test whether copyout() simulates COW faults.
void
filetest()
{
 22c:	7139                	addi	sp,sp,-64
 22e:	fc06                	sd	ra,56(sp)
 230:	f822                	sd	s0,48(sp)
 232:	f426                	sd	s1,40(sp)
 234:	f04a                	sd	s2,32(sp)
 236:	ec4e                	sd	s3,24(sp)
 238:	e852                	sd	s4,16(sp)
 23a:	0080                	addi	s0,sp,64
  enum { N = 4 };
  
  printf("file: ");
 23c:	00001517          	auipc	a0,0x1
 240:	b8450513          	addi	a0,a0,-1148 # dc0 <malloc+0x182>
 244:	143000ef          	jal	b86 <printf>
  
  buf[0] = 99;
 248:	06300793          	li	a5,99
 24c:	00002717          	auipc	a4,0x2
 250:	dcf70223          	sb	a5,-572(a4) # 2010 <buf>

  for(int i = 0; i < N; i++){
 254:	fc042423          	sw	zero,-56(s0)
    if(pipe(fds) != 0){
 258:	00001497          	auipc	s1,0x1
 25c:	da848493          	addi	s1,s1,-600 # 1000 <fds>
        printf("error: read the wrong value %d; expected %d\n", j, i);
        exit(1);
      }
      exit(0);
    }
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 260:	fc840a13          	addi	s4,s0,-56
 264:	4911                	li	s2,4
  for(int i = 0; i < N; i++){
 266:	498d                	li	s3,3
    if(pipe(fds) != 0){
 268:	8526                	mv	a0,s1
 26a:	4e6000ef          	jal	750 <pipe>
 26e:	e925                	bnez	a0,2de <filetest+0xb2>
    int pid = fork();
 270:	4c8000ef          	jal	738 <fork>
    if(pid < 0){
 274:	06054e63          	bltz	a0,2f0 <filetest+0xc4>
    if(pid == 0){
 278:	c549                	beqz	a0,302 <filetest+0xd6>
    if(write(fds[1], &i, sizeof(i)) != sizeof(i)){
 27a:	864a                	mv	a2,s2
 27c:	85d2                	mv	a1,s4
 27e:	40c8                	lw	a0,4(s1)
 280:	4e0000ef          	jal	760 <write>
 284:	0f251063          	bne	a0,s2,364 <filetest+0x138>
  for(int i = 0; i < N; i++){
 288:	fc842783          	lw	a5,-56(s0)
 28c:	2785                	addiw	a5,a5,1
 28e:	fcf42423          	sw	a5,-56(s0)
 292:	fcf9dbe3          	bge	s3,a5,268 <filetest+0x3c>
      printf("error: write failed\n");
      exit(-1);
    }
  }

  int xstatus = 0;
 296:	fc042623          	sw	zero,-52(s0)
 29a:	4491                	li	s1,4
  for(int i = 0; i < N; i++) {
    wait(&xstatus);
 29c:	fcc40913          	addi	s2,s0,-52
 2a0:	854a                	mv	a0,s2
 2a2:	4a6000ef          	jal	748 <wait>
    if(xstatus != 0) {
 2a6:	fcc42783          	lw	a5,-52(s0)
 2aa:	0c079663          	bnez	a5,376 <filetest+0x14a>
  for(int i = 0; i < N; i++) {
 2ae:	34fd                	addiw	s1,s1,-1
 2b0:	f8e5                	bnez	s1,2a0 <filetest+0x74>
      exit(1);
    }
  }

  if(buf[0] != 99){
 2b2:	00002717          	auipc	a4,0x2
 2b6:	d5e74703          	lbu	a4,-674(a4) # 2010 <buf>
 2ba:	06300793          	li	a5,99
 2be:	0af71f63          	bne	a4,a5,37c <filetest+0x150>
    printf("error: child overwrote parent\n");
    exit(1);
  }

  printf("ok\n");
 2c2:	00001517          	auipc	a0,0x1
 2c6:	abe50513          	addi	a0,a0,-1346 # d80 <malloc+0x142>
 2ca:	0bd000ef          	jal	b86 <printf>
}
 2ce:	70e2                	ld	ra,56(sp)
 2d0:	7442                	ld	s0,48(sp)
 2d2:	74a2                	ld	s1,40(sp)
 2d4:	7902                	ld	s2,32(sp)
 2d6:	69e2                	ld	s3,24(sp)
 2d8:	6a42                	ld	s4,16(sp)
 2da:	6121                	addi	sp,sp,64
 2dc:	8082                	ret
      printf("pipe() failed\n");
 2de:	00001517          	auipc	a0,0x1
 2e2:	aea50513          	addi	a0,a0,-1302 # dc8 <malloc+0x18a>
 2e6:	0a1000ef          	jal	b86 <printf>
      exit(-1);
 2ea:	557d                	li	a0,-1
 2ec:	454000ef          	jal	740 <exit>
      printf("fork failed\n");
 2f0:	00001517          	auipc	a0,0x1
 2f4:	aa050513          	addi	a0,a0,-1376 # d90 <malloc+0x152>
 2f8:	08f000ef          	jal	b86 <printf>
      exit(-1);
 2fc:	557d                	li	a0,-1
 2fe:	442000ef          	jal	740 <exit>
      pause(1);
 302:	4505                	li	a0,1
 304:	4cc000ef          	jal	7d0 <pause>
      if(read(fds[0], buf, sizeof(i)) != sizeof(i)){
 308:	4611                	li	a2,4
 30a:	00002597          	auipc	a1,0x2
 30e:	d0658593          	addi	a1,a1,-762 # 2010 <buf>
 312:	00001517          	auipc	a0,0x1
 316:	cee52503          	lw	a0,-786(a0) # 1000 <fds>
 31a:	43e000ef          	jal	758 <read>
 31e:	4791                	li	a5,4
 320:	02f51663          	bne	a0,a5,34c <filetest+0x120>
      pause(1);
 324:	4505                	li	a0,1
 326:	4aa000ef          	jal	7d0 <pause>
      int j = *(int*)buf;
 32a:	00002597          	auipc	a1,0x2
 32e:	ce65a583          	lw	a1,-794(a1) # 2010 <buf>
      if(j != i){
 332:	fc842603          	lw	a2,-56(s0)
 336:	02b60463          	beq	a2,a1,35e <filetest+0x132>
        printf("error: read the wrong value %d; expected %d\n", j, i);
 33a:	00001517          	auipc	a0,0x1
 33e:	ab650513          	addi	a0,a0,-1354 # df0 <malloc+0x1b2>
 342:	045000ef          	jal	b86 <printf>
        exit(1);
 346:	4505                	li	a0,1
 348:	3f8000ef          	jal	740 <exit>
        printf("error: read failed\n");
 34c:	00001517          	auipc	a0,0x1
 350:	a8c50513          	addi	a0,a0,-1396 # dd8 <malloc+0x19a>
 354:	033000ef          	jal	b86 <printf>
        exit(1);
 358:	4505                	li	a0,1
 35a:	3e6000ef          	jal	740 <exit>
      exit(0);
 35e:	4501                	li	a0,0
 360:	3e0000ef          	jal	740 <exit>
      printf("error: write failed\n");
 364:	00001517          	auipc	a0,0x1
 368:	abc50513          	addi	a0,a0,-1348 # e20 <malloc+0x1e2>
 36c:	01b000ef          	jal	b86 <printf>
      exit(-1);
 370:	557d                	li	a0,-1
 372:	3ce000ef          	jal	740 <exit>
      exit(1);
 376:	4505                	li	a0,1
 378:	3c8000ef          	jal	740 <exit>
    printf("error: child overwrote parent\n");
 37c:	00001517          	auipc	a0,0x1
 380:	abc50513          	addi	a0,a0,-1348 # e38 <malloc+0x1fa>
 384:	003000ef          	jal	b86 <printf>
    exit(1);
 388:	4505                	li	a0,1
 38a:	3b6000ef          	jal	740 <exit>

000000000000038e <forkforktest>:
//
// try to expose races in page reference counting.
//
void
forkforktest()
{
 38e:	715d                	addi	sp,sp,-80
 390:	e486                	sd	ra,72(sp)
 392:	e0a2                	sd	s0,64(sp)
 394:	fc26                	sd	s1,56(sp)
 396:	f84a                	sd	s2,48(sp)
 398:	f44e                	sd	s3,40(sp)
 39a:	f052                	sd	s4,32(sp)
 39c:	ec56                	sd	s5,24(sp)
 39e:	0880                	addi	s0,sp,80
  printf("forkfork: ");
 3a0:	00001517          	auipc	a0,0x1
 3a4:	ab850513          	addi	a0,a0,-1352 # e58 <malloc+0x21a>
 3a8:	7de000ef          	jal	b86 <printf>

  int sz = 256 * 4096;
  char *p = sbrk(sz);
 3ac:	00100537          	lui	a0,0x100
 3b0:	35c000ef          	jal	70c <sbrk>
 3b4:	8aaa                	mv	s5,a0
  memset(p, 27, sz);
 3b6:	00100637          	lui	a2,0x100
 3ba:	45ed                	li	a1,27
 3bc:	15a000ef          	jal	516 <memset>
 3c0:	06400993          	li	s3,100
{
 3c4:	4a0d                	li	s4,3
      }
    }

    for(int nc = 0; nc < children; nc++){
      int st;
      wait(&st);
 3c6:	fbc40913          	addi	s2,s0,-68
{
 3ca:	84d2                	mv	s1,s4
      if(fork() == 0){
 3cc:	36c000ef          	jal	738 <fork>
 3d0:	cd39                	beqz	a0,42e <forkforktest+0xa0>
    for(int nc = 0; nc < children; nc++){
 3d2:	34fd                	addiw	s1,s1,-1
 3d4:	fce5                	bnez	s1,3cc <forkforktest+0x3e>
      wait(&st);
 3d6:	854a                	mv	a0,s2
 3d8:	370000ef          	jal	748 <wait>
 3dc:	854a                	mv	a0,s2
 3de:	36a000ef          	jal	748 <wait>
 3e2:	854a                	mv	a0,s2
 3e4:	364000ef          	jal	748 <wait>
  for(int iter = 0; iter < 100; iter++){
 3e8:	39fd                	addiw	s3,s3,-1 # 1999fff <base+0x1994fef>
 3ea:	fe0990e3          	bnez	s3,3ca <forkforktest+0x3c>
    }
  }

  pause(5);
 3ee:	4515                	li	a0,5
 3f0:	3e0000ef          	jal	7d0 <pause>
  for(int i = 0; i < sz; i += 4096){
 3f4:	87d6                	mv	a5,s5
 3f6:	00100737          	lui	a4,0x100
 3fa:	00ea86b3          	add	a3,s5,a4
    if(p[i] != 27){
 3fe:	45ed                	li	a1,27
  for(int i = 0; i < sz; i += 4096){
 400:	6605                	lui	a2,0x1
    if(p[i] != 27){
 402:	0007c703          	lbu	a4,0(a5)
 406:	02b71e63          	bne	a4,a1,442 <forkforktest+0xb4>
  for(int i = 0; i < sz; i += 4096){
 40a:	97b2                	add	a5,a5,a2
 40c:	fef69be3          	bne	a3,a5,402 <forkforktest+0x74>
      printf("error: parent's memory was modified!\n");
      exit(1);
    }
  }

  printf("ok\n");
 410:	00001517          	auipc	a0,0x1
 414:	97050513          	addi	a0,a0,-1680 # d80 <malloc+0x142>
 418:	76e000ef          	jal	b86 <printf>
}
 41c:	60a6                	ld	ra,72(sp)
 41e:	6406                	ld	s0,64(sp)
 420:	74e2                	ld	s1,56(sp)
 422:	7942                	ld	s2,48(sp)
 424:	79a2                	ld	s3,40(sp)
 426:	7a02                	ld	s4,32(sp)
 428:	6ae2                	ld	s5,24(sp)
 42a:	6161                	addi	sp,sp,80
 42c:	8082                	ret
        pause(2);
 42e:	4509                	li	a0,2
 430:	3a0000ef          	jal	7d0 <pause>
        fork();
 434:	304000ef          	jal	738 <fork>
        fork();
 438:	300000ef          	jal	738 <fork>
        exit(0);
 43c:	4501                	li	a0,0
 43e:	302000ef          	jal	740 <exit>
      printf("error: parent's memory was modified!\n");
 442:	00001517          	auipc	a0,0x1
 446:	a2650513          	addi	a0,a0,-1498 # e68 <malloc+0x22a>
 44a:	73c000ef          	jal	b86 <printf>
      exit(1);
 44e:	4505                	li	a0,1
 450:	2f0000ef          	jal	740 <exit>

0000000000000454 <main>:

int
main(int argc, char *argv[])
{
 454:	1141                	addi	sp,sp,-16
 456:	e406                	sd	ra,8(sp)
 458:	e022                	sd	s0,0(sp)
 45a:	0800                	addi	s0,sp,16
  simpletest();
 45c:	ba5ff0ef          	jal	0 <simpletest>

  // check that the first simpletest() freed the physical memory.
  simpletest();
 460:	ba1ff0ef          	jal	0 <simpletest>

  threetest();
 464:	c65ff0ef          	jal	c8 <threetest>
  threetest();
 468:	c61ff0ef          	jal	c8 <threetest>
  threetest();
 46c:	c5dff0ef          	jal	c8 <threetest>

  filetest();
 470:	dbdff0ef          	jal	22c <filetest>

  forkforktest();
 474:	f1bff0ef          	jal	38e <forkforktest>

  printf("ALL COW TESTS PASSED\n");
 478:	00001517          	auipc	a0,0x1
 47c:	a1850513          	addi	a0,a0,-1512 # e90 <malloc+0x252>
 480:	706000ef          	jal	b86 <printf>

  exit(0);
 484:	4501                	li	a0,0
 486:	2ba000ef          	jal	740 <exit>

000000000000048a <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 48a:	1141                	addi	sp,sp,-16
 48c:	e406                	sd	ra,8(sp)
 48e:	e022                	sd	s0,0(sp)
 490:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 492:	fc3ff0ef          	jal	454 <main>
  exit(r);
 496:	2aa000ef          	jal	740 <exit>

000000000000049a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 49a:	1141                	addi	sp,sp,-16
 49c:	e406                	sd	ra,8(sp)
 49e:	e022                	sd	s0,0(sp)
 4a0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 4a2:	87aa                	mv	a5,a0
 4a4:	0585                	addi	a1,a1,1
 4a6:	0785                	addi	a5,a5,1
 4a8:	fff5c703          	lbu	a4,-1(a1)
 4ac:	fee78fa3          	sb	a4,-1(a5)
 4b0:	fb75                	bnez	a4,4a4 <strcpy+0xa>
    ;
  return os;
}
 4b2:	60a2                	ld	ra,8(sp)
 4b4:	6402                	ld	s0,0(sp)
 4b6:	0141                	addi	sp,sp,16
 4b8:	8082                	ret

00000000000004ba <strcmp>:

int
strcmp(const char *p, const char *q)
{
 4ba:	1141                	addi	sp,sp,-16
 4bc:	e406                	sd	ra,8(sp)
 4be:	e022                	sd	s0,0(sp)
 4c0:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 4c2:	00054783          	lbu	a5,0(a0)
 4c6:	cb91                	beqz	a5,4da <strcmp+0x20>
 4c8:	0005c703          	lbu	a4,0(a1)
 4cc:	00f71763          	bne	a4,a5,4da <strcmp+0x20>
    p++, q++;
 4d0:	0505                	addi	a0,a0,1
 4d2:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 4d4:	00054783          	lbu	a5,0(a0)
 4d8:	fbe5                	bnez	a5,4c8 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 4da:	0005c503          	lbu	a0,0(a1)
}
 4de:	40a7853b          	subw	a0,a5,a0
 4e2:	60a2                	ld	ra,8(sp)
 4e4:	6402                	ld	s0,0(sp)
 4e6:	0141                	addi	sp,sp,16
 4e8:	8082                	ret

00000000000004ea <strlen>:

uint
strlen(const char *s)
{
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e406                	sd	ra,8(sp)
 4ee:	e022                	sd	s0,0(sp)
 4f0:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 4f2:	00054783          	lbu	a5,0(a0)
 4f6:	cf91                	beqz	a5,512 <strlen+0x28>
 4f8:	00150793          	addi	a5,a0,1
 4fc:	86be                	mv	a3,a5
 4fe:	0785                	addi	a5,a5,1
 500:	fff7c703          	lbu	a4,-1(a5)
 504:	ff65                	bnez	a4,4fc <strlen+0x12>
 506:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 50a:	60a2                	ld	ra,8(sp)
 50c:	6402                	ld	s0,0(sp)
 50e:	0141                	addi	sp,sp,16
 510:	8082                	ret
  for(n = 0; s[n]; n++)
 512:	4501                	li	a0,0
 514:	bfdd                	j	50a <strlen+0x20>

0000000000000516 <memset>:

void*
memset(void *dst, int c, uint n)
{
 516:	1141                	addi	sp,sp,-16
 518:	e406                	sd	ra,8(sp)
 51a:	e022                	sd	s0,0(sp)
 51c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 51e:	ca19                	beqz	a2,534 <memset+0x1e>
 520:	87aa                	mv	a5,a0
 522:	1602                	slli	a2,a2,0x20
 524:	9201                	srli	a2,a2,0x20
 526:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 52a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 52e:	0785                	addi	a5,a5,1
 530:	fee79de3          	bne	a5,a4,52a <memset+0x14>
  }
  return dst;
}
 534:	60a2                	ld	ra,8(sp)
 536:	6402                	ld	s0,0(sp)
 538:	0141                	addi	sp,sp,16
 53a:	8082                	ret

000000000000053c <strchr>:

char*
strchr(const char *s, char c)
{
 53c:	1141                	addi	sp,sp,-16
 53e:	e406                	sd	ra,8(sp)
 540:	e022                	sd	s0,0(sp)
 542:	0800                	addi	s0,sp,16
  for(; *s; s++)
 544:	00054783          	lbu	a5,0(a0)
 548:	cf81                	beqz	a5,560 <strchr+0x24>
    if(*s == c)
 54a:	00f58763          	beq	a1,a5,558 <strchr+0x1c>
  for(; *s; s++)
 54e:	0505                	addi	a0,a0,1
 550:	00054783          	lbu	a5,0(a0)
 554:	fbfd                	bnez	a5,54a <strchr+0xe>
      return (char*)s;
  return 0;
 556:	4501                	li	a0,0
}
 558:	60a2                	ld	ra,8(sp)
 55a:	6402                	ld	s0,0(sp)
 55c:	0141                	addi	sp,sp,16
 55e:	8082                	ret
  return 0;
 560:	4501                	li	a0,0
 562:	bfdd                	j	558 <strchr+0x1c>

0000000000000564 <gets>:

char*
gets(char *buf, int max)
{
 564:	711d                	addi	sp,sp,-96
 566:	ec86                	sd	ra,88(sp)
 568:	e8a2                	sd	s0,80(sp)
 56a:	e4a6                	sd	s1,72(sp)
 56c:	e0ca                	sd	s2,64(sp)
 56e:	fc4e                	sd	s3,56(sp)
 570:	f852                	sd	s4,48(sp)
 572:	f456                	sd	s5,40(sp)
 574:	f05a                	sd	s6,32(sp)
 576:	ec5e                	sd	s7,24(sp)
 578:	e862                	sd	s8,16(sp)
 57a:	1080                	addi	s0,sp,96
 57c:	8baa                	mv	s7,a0
 57e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 580:	892a                	mv	s2,a0
 582:	4481                	li	s1,0
    cc = read(0, &c, 1);
 584:	faf40b13          	addi	s6,s0,-81
 588:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 58a:	8c26                	mv	s8,s1
 58c:	0014899b          	addiw	s3,s1,1
 590:	84ce                	mv	s1,s3
 592:	0349d463          	bge	s3,s4,5ba <gets+0x56>
    cc = read(0, &c, 1);
 596:	8656                	mv	a2,s5
 598:	85da                	mv	a1,s6
 59a:	4501                	li	a0,0
 59c:	1bc000ef          	jal	758 <read>
    if(cc < 1)
 5a0:	00a05d63          	blez	a0,5ba <gets+0x56>
      break;
    buf[i++] = c;
 5a4:	faf44783          	lbu	a5,-81(s0)
 5a8:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 5ac:	0905                	addi	s2,s2,1
 5ae:	ff678713          	addi	a4,a5,-10
 5b2:	c319                	beqz	a4,5b8 <gets+0x54>
 5b4:	17cd                	addi	a5,a5,-13
 5b6:	fbf1                	bnez	a5,58a <gets+0x26>
    buf[i++] = c;
 5b8:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 5ba:	9c5e                	add	s8,s8,s7
 5bc:	000c0023          	sb	zero,0(s8)
  return buf;
}
 5c0:	855e                	mv	a0,s7
 5c2:	60e6                	ld	ra,88(sp)
 5c4:	6446                	ld	s0,80(sp)
 5c6:	64a6                	ld	s1,72(sp)
 5c8:	6906                	ld	s2,64(sp)
 5ca:	79e2                	ld	s3,56(sp)
 5cc:	7a42                	ld	s4,48(sp)
 5ce:	7aa2                	ld	s5,40(sp)
 5d0:	7b02                	ld	s6,32(sp)
 5d2:	6be2                	ld	s7,24(sp)
 5d4:	6c42                	ld	s8,16(sp)
 5d6:	6125                	addi	sp,sp,96
 5d8:	8082                	ret

00000000000005da <stat>:

int
stat(const char *n, struct stat *st)
{
 5da:	1101                	addi	sp,sp,-32
 5dc:	ec06                	sd	ra,24(sp)
 5de:	e822                	sd	s0,16(sp)
 5e0:	e04a                	sd	s2,0(sp)
 5e2:	1000                	addi	s0,sp,32
 5e4:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 5e6:	4581                	li	a1,0
 5e8:	198000ef          	jal	780 <open>
  if(fd < 0)
 5ec:	02054263          	bltz	a0,610 <stat+0x36>
 5f0:	e426                	sd	s1,8(sp)
 5f2:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 5f4:	85ca                	mv	a1,s2
 5f6:	1a2000ef          	jal	798 <fstat>
 5fa:	892a                	mv	s2,a0
  close(fd);
 5fc:	8526                	mv	a0,s1
 5fe:	16a000ef          	jal	768 <close>
  return r;
 602:	64a2                	ld	s1,8(sp)
}
 604:	854a                	mv	a0,s2
 606:	60e2                	ld	ra,24(sp)
 608:	6442                	ld	s0,16(sp)
 60a:	6902                	ld	s2,0(sp)
 60c:	6105                	addi	sp,sp,32
 60e:	8082                	ret
    return -1;
 610:	57fd                	li	a5,-1
 612:	893e                	mv	s2,a5
 614:	bfc5                	j	604 <stat+0x2a>

0000000000000616 <atoi>:

int
atoi(const char *s)
{
 616:	1141                	addi	sp,sp,-16
 618:	e406                	sd	ra,8(sp)
 61a:	e022                	sd	s0,0(sp)
 61c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 61e:	00054683          	lbu	a3,0(a0)
 622:	fd06879b          	addiw	a5,a3,-48 # fd0 <digits+0x120>
 626:	0ff7f793          	zext.b	a5,a5
 62a:	4625                	li	a2,9
 62c:	02f66963          	bltu	a2,a5,65e <atoi+0x48>
 630:	872a                	mv	a4,a0
  n = 0;
 632:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 634:	0705                	addi	a4,a4,1 # 100001 <base+0xfaff1>
 636:	0025179b          	slliw	a5,a0,0x2
 63a:	9fa9                	addw	a5,a5,a0
 63c:	0017979b          	slliw	a5,a5,0x1
 640:	9fb5                	addw	a5,a5,a3
 642:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 646:	00074683          	lbu	a3,0(a4)
 64a:	fd06879b          	addiw	a5,a3,-48
 64e:	0ff7f793          	zext.b	a5,a5
 652:	fef671e3          	bgeu	a2,a5,634 <atoi+0x1e>
  return n;
}
 656:	60a2                	ld	ra,8(sp)
 658:	6402                	ld	s0,0(sp)
 65a:	0141                	addi	sp,sp,16
 65c:	8082                	ret
  n = 0;
 65e:	4501                	li	a0,0
 660:	bfdd                	j	656 <atoi+0x40>

0000000000000662 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 662:	1141                	addi	sp,sp,-16
 664:	e406                	sd	ra,8(sp)
 666:	e022                	sd	s0,0(sp)
 668:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 66a:	02b57563          	bgeu	a0,a1,694 <memmove+0x32>
    while(n-- > 0)
 66e:	00c05f63          	blez	a2,68c <memmove+0x2a>
 672:	1602                	slli	a2,a2,0x20
 674:	9201                	srli	a2,a2,0x20
 676:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 67a:	872a                	mv	a4,a0
      *dst++ = *src++;
 67c:	0585                	addi	a1,a1,1
 67e:	0705                	addi	a4,a4,1
 680:	fff5c683          	lbu	a3,-1(a1)
 684:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 688:	fee79ae3          	bne	a5,a4,67c <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 68c:	60a2                	ld	ra,8(sp)
 68e:	6402                	ld	s0,0(sp)
 690:	0141                	addi	sp,sp,16
 692:	8082                	ret
    while(n-- > 0)
 694:	fec05ce3          	blez	a2,68c <memmove+0x2a>
    dst += n;
 698:	00c50733          	add	a4,a0,a2
    src += n;
 69c:	95b2                	add	a1,a1,a2
 69e:	fff6079b          	addiw	a5,a2,-1 # fff <digits+0x14f>
 6a2:	1782                	slli	a5,a5,0x20
 6a4:	9381                	srli	a5,a5,0x20
 6a6:	fff7c793          	not	a5,a5
 6aa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 6ac:	15fd                	addi	a1,a1,-1
 6ae:	177d                	addi	a4,a4,-1
 6b0:	0005c683          	lbu	a3,0(a1)
 6b4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 6b8:	fef71ae3          	bne	a4,a5,6ac <memmove+0x4a>
 6bc:	bfc1                	j	68c <memmove+0x2a>

00000000000006be <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 6be:	1141                	addi	sp,sp,-16
 6c0:	e406                	sd	ra,8(sp)
 6c2:	e022                	sd	s0,0(sp)
 6c4:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 6c6:	c61d                	beqz	a2,6f4 <memcmp+0x36>
 6c8:	1602                	slli	a2,a2,0x20
 6ca:	9201                	srli	a2,a2,0x20
 6cc:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 6d0:	00054783          	lbu	a5,0(a0)
 6d4:	0005c703          	lbu	a4,0(a1)
 6d8:	00e79863          	bne	a5,a4,6e8 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 6dc:	0505                	addi	a0,a0,1
    p2++;
 6de:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 6e0:	fed518e3          	bne	a0,a3,6d0 <memcmp+0x12>
  }
  return 0;
 6e4:	4501                	li	a0,0
 6e6:	a019                	j	6ec <memcmp+0x2e>
      return *p1 - *p2;
 6e8:	40e7853b          	subw	a0,a5,a4
}
 6ec:	60a2                	ld	ra,8(sp)
 6ee:	6402                	ld	s0,0(sp)
 6f0:	0141                	addi	sp,sp,16
 6f2:	8082                	ret
  return 0;
 6f4:	4501                	li	a0,0
 6f6:	bfdd                	j	6ec <memcmp+0x2e>

00000000000006f8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 6f8:	1141                	addi	sp,sp,-16
 6fa:	e406                	sd	ra,8(sp)
 6fc:	e022                	sd	s0,0(sp)
 6fe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 700:	f63ff0ef          	jal	662 <memmove>
}
 704:	60a2                	ld	ra,8(sp)
 706:	6402                	ld	s0,0(sp)
 708:	0141                	addi	sp,sp,16
 70a:	8082                	ret

000000000000070c <sbrk>:

char *
sbrk(int n) {
 70c:	1141                	addi	sp,sp,-16
 70e:	e406                	sd	ra,8(sp)
 710:	e022                	sd	s0,0(sp)
 712:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 714:	4585                	li	a1,1
 716:	0b2000ef          	jal	7c8 <sys_sbrk>
}
 71a:	60a2                	ld	ra,8(sp)
 71c:	6402                	ld	s0,0(sp)
 71e:	0141                	addi	sp,sp,16
 720:	8082                	ret

0000000000000722 <sbrklazy>:

char *
sbrklazy(int n) {
 722:	1141                	addi	sp,sp,-16
 724:	e406                	sd	ra,8(sp)
 726:	e022                	sd	s0,0(sp)
 728:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 72a:	4589                	li	a1,2
 72c:	09c000ef          	jal	7c8 <sys_sbrk>
}
 730:	60a2                	ld	ra,8(sp)
 732:	6402                	ld	s0,0(sp)
 734:	0141                	addi	sp,sp,16
 736:	8082                	ret

0000000000000738 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 738:	4885                	li	a7,1
 ecall
 73a:	00000073          	ecall
 ret
 73e:	8082                	ret

0000000000000740 <exit>:
.global exit
exit:
 li a7, SYS_exit
 740:	4889                	li	a7,2
 ecall
 742:	00000073          	ecall
 ret
 746:	8082                	ret

0000000000000748 <wait>:
.global wait
wait:
 li a7, SYS_wait
 748:	488d                	li	a7,3
 ecall
 74a:	00000073          	ecall
 ret
 74e:	8082                	ret

0000000000000750 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 750:	4891                	li	a7,4
 ecall
 752:	00000073          	ecall
 ret
 756:	8082                	ret

0000000000000758 <read>:
.global read
read:
 li a7, SYS_read
 758:	4895                	li	a7,5
 ecall
 75a:	00000073          	ecall
 ret
 75e:	8082                	ret

0000000000000760 <write>:
.global write
write:
 li a7, SYS_write
 760:	48c1                	li	a7,16
 ecall
 762:	00000073          	ecall
 ret
 766:	8082                	ret

0000000000000768 <close>:
.global close
close:
 li a7, SYS_close
 768:	48d5                	li	a7,21
 ecall
 76a:	00000073          	ecall
 ret
 76e:	8082                	ret

0000000000000770 <kill>:
.global kill
kill:
 li a7, SYS_kill
 770:	4899                	li	a7,6
 ecall
 772:	00000073          	ecall
 ret
 776:	8082                	ret

0000000000000778 <exec>:
.global exec
exec:
 li a7, SYS_exec
 778:	489d                	li	a7,7
 ecall
 77a:	00000073          	ecall
 ret
 77e:	8082                	ret

0000000000000780 <open>:
.global open
open:
 li a7, SYS_open
 780:	48bd                	li	a7,15
 ecall
 782:	00000073          	ecall
 ret
 786:	8082                	ret

0000000000000788 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 788:	48c5                	li	a7,17
 ecall
 78a:	00000073          	ecall
 ret
 78e:	8082                	ret

0000000000000790 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 790:	48c9                	li	a7,18
 ecall
 792:	00000073          	ecall
 ret
 796:	8082                	ret

0000000000000798 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 798:	48a1                	li	a7,8
 ecall
 79a:	00000073          	ecall
 ret
 79e:	8082                	ret

00000000000007a0 <link>:
.global link
link:
 li a7, SYS_link
 7a0:	48cd                	li	a7,19
 ecall
 7a2:	00000073          	ecall
 ret
 7a6:	8082                	ret

00000000000007a8 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 7a8:	48d1                	li	a7,20
 ecall
 7aa:	00000073          	ecall
 ret
 7ae:	8082                	ret

00000000000007b0 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 7b0:	48a5                	li	a7,9
 ecall
 7b2:	00000073          	ecall
 ret
 7b6:	8082                	ret

00000000000007b8 <dup>:
.global dup
dup:
 li a7, SYS_dup
 7b8:	48a9                	li	a7,10
 ecall
 7ba:	00000073          	ecall
 ret
 7be:	8082                	ret

00000000000007c0 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 7c0:	48ad                	li	a7,11
 ecall
 7c2:	00000073          	ecall
 ret
 7c6:	8082                	ret

00000000000007c8 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 7c8:	48b1                	li	a7,12
 ecall
 7ca:	00000073          	ecall
 ret
 7ce:	8082                	ret

00000000000007d0 <pause>:
.global pause
pause:
 li a7, SYS_pause
 7d0:	48b5                	li	a7,13
 ecall
 7d2:	00000073          	ecall
 ret
 7d6:	8082                	ret

00000000000007d8 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 7d8:	48b9                	li	a7,14
 ecall
 7da:	00000073          	ecall
 ret
 7de:	8082                	ret

00000000000007e0 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 7e0:	1101                	addi	sp,sp,-32
 7e2:	ec06                	sd	ra,24(sp)
 7e4:	e822                	sd	s0,16(sp)
 7e6:	1000                	addi	s0,sp,32
 7e8:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 7ec:	4605                	li	a2,1
 7ee:	fef40593          	addi	a1,s0,-17
 7f2:	f6fff0ef          	jal	760 <write>
}
 7f6:	60e2                	ld	ra,24(sp)
 7f8:	6442                	ld	s0,16(sp)
 7fa:	6105                	addi	sp,sp,32
 7fc:	8082                	ret

00000000000007fe <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 7fe:	715d                	addi	sp,sp,-80
 800:	e486                	sd	ra,72(sp)
 802:	e0a2                	sd	s0,64(sp)
 804:	f84a                	sd	s2,48(sp)
 806:	f44e                	sd	s3,40(sp)
 808:	0880                	addi	s0,sp,80
 80a:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 80c:	c6d1                	beqz	a3,898 <printint+0x9a>
 80e:	0805d563          	bgez	a1,898 <printint+0x9a>
    neg = 1;
    x = -xx;
 812:	40b005b3          	neg	a1,a1
    neg = 1;
 816:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 818:	fb840993          	addi	s3,s0,-72
  neg = 0;
 81c:	86ce                	mv	a3,s3
  i = 0;
 81e:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 820:	00000817          	auipc	a6,0x0
 824:	69080813          	addi	a6,a6,1680 # eb0 <digits>
 828:	88ba                	mv	a7,a4
 82a:	0017051b          	addiw	a0,a4,1
 82e:	872a                	mv	a4,a0
 830:	02c5f7b3          	remu	a5,a1,a2
 834:	97c2                	add	a5,a5,a6
 836:	0007c783          	lbu	a5,0(a5)
 83a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 83e:	87ae                	mv	a5,a1
 840:	02c5d5b3          	divu	a1,a1,a2
 844:	0685                	addi	a3,a3,1
 846:	fec7f1e3          	bgeu	a5,a2,828 <printint+0x2a>
  if(neg)
 84a:	00030c63          	beqz	t1,862 <printint+0x64>
    buf[i++] = '-';
 84e:	fd050793          	addi	a5,a0,-48
 852:	00878533          	add	a0,a5,s0
 856:	02d00793          	li	a5,45
 85a:	fef50423          	sb	a5,-24(a0)
 85e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 862:	02e05563          	blez	a4,88c <printint+0x8e>
 866:	fc26                	sd	s1,56(sp)
 868:	377d                	addiw	a4,a4,-1
 86a:	00e984b3          	add	s1,s3,a4
 86e:	19fd                	addi	s3,s3,-1
 870:	99ba                	add	s3,s3,a4
 872:	1702                	slli	a4,a4,0x20
 874:	9301                	srli	a4,a4,0x20
 876:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 87a:	0004c583          	lbu	a1,0(s1)
 87e:	854a                	mv	a0,s2
 880:	f61ff0ef          	jal	7e0 <putc>
  while(--i >= 0)
 884:	14fd                	addi	s1,s1,-1
 886:	ff349ae3          	bne	s1,s3,87a <printint+0x7c>
 88a:	74e2                	ld	s1,56(sp)
}
 88c:	60a6                	ld	ra,72(sp)
 88e:	6406                	ld	s0,64(sp)
 890:	7942                	ld	s2,48(sp)
 892:	79a2                	ld	s3,40(sp)
 894:	6161                	addi	sp,sp,80
 896:	8082                	ret
  neg = 0;
 898:	4301                	li	t1,0
 89a:	bfbd                	j	818 <printint+0x1a>

000000000000089c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 89c:	711d                	addi	sp,sp,-96
 89e:	ec86                	sd	ra,88(sp)
 8a0:	e8a2                	sd	s0,80(sp)
 8a2:	e4a6                	sd	s1,72(sp)
 8a4:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 8a6:	0005c483          	lbu	s1,0(a1)
 8aa:	22048363          	beqz	s1,ad0 <vprintf+0x234>
 8ae:	e0ca                	sd	s2,64(sp)
 8b0:	fc4e                	sd	s3,56(sp)
 8b2:	f852                	sd	s4,48(sp)
 8b4:	f456                	sd	s5,40(sp)
 8b6:	f05a                	sd	s6,32(sp)
 8b8:	ec5e                	sd	s7,24(sp)
 8ba:	e862                	sd	s8,16(sp)
 8bc:	8b2a                	mv	s6,a0
 8be:	8a2e                	mv	s4,a1
 8c0:	8bb2                	mv	s7,a2
  state = 0;
 8c2:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 8c4:	4901                	li	s2,0
 8c6:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 8c8:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 8cc:	06400c13          	li	s8,100
 8d0:	a00d                	j	8f2 <vprintf+0x56>
        putc(fd, c0);
 8d2:	85a6                	mv	a1,s1
 8d4:	855a                	mv	a0,s6
 8d6:	f0bff0ef          	jal	7e0 <putc>
 8da:	a019                	j	8e0 <vprintf+0x44>
    } else if(state == '%'){
 8dc:	03598363          	beq	s3,s5,902 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 8e0:	0019079b          	addiw	a5,s2,1
 8e4:	893e                	mv	s2,a5
 8e6:	873e                	mv	a4,a5
 8e8:	97d2                	add	a5,a5,s4
 8ea:	0007c483          	lbu	s1,0(a5)
 8ee:	1c048a63          	beqz	s1,ac2 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 8f2:	0004879b          	sext.w	a5,s1
    if(state == 0){
 8f6:	fe0993e3          	bnez	s3,8dc <vprintf+0x40>
      if(c0 == '%'){
 8fa:	fd579ce3          	bne	a5,s5,8d2 <vprintf+0x36>
        state = '%';
 8fe:	89be                	mv	s3,a5
 900:	b7c5                	j	8e0 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 902:	00ea06b3          	add	a3,s4,a4
 906:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 90a:	1c060863          	beqz	a2,ada <vprintf+0x23e>
      if(c0 == 'd'){
 90e:	03878763          	beq	a5,s8,93c <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 912:	f9478693          	addi	a3,a5,-108
 916:	0016b693          	seqz	a3,a3
 91a:	f9c60593          	addi	a1,a2,-100
 91e:	e99d                	bnez	a1,954 <vprintf+0xb8>
 920:	ca95                	beqz	a3,954 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 922:	008b8493          	addi	s1,s7,8
 926:	4685                	li	a3,1
 928:	4629                	li	a2,10
 92a:	000bb583          	ld	a1,0(s7)
 92e:	855a                	mv	a0,s6
 930:	ecfff0ef          	jal	7fe <printint>
        i += 1;
 934:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 936:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 938:	4981                	li	s3,0
 93a:	b75d                	j	8e0 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 93c:	008b8493          	addi	s1,s7,8
 940:	4685                	li	a3,1
 942:	4629                	li	a2,10
 944:	000ba583          	lw	a1,0(s7)
 948:	855a                	mv	a0,s6
 94a:	eb5ff0ef          	jal	7fe <printint>
 94e:	8ba6                	mv	s7,s1
      state = 0;
 950:	4981                	li	s3,0
 952:	b779                	j	8e0 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 954:	9752                	add	a4,a4,s4
 956:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 95a:	f9460713          	addi	a4,a2,-108
 95e:	00173713          	seqz	a4,a4
 962:	8f75                	and	a4,a4,a3
 964:	f9c58513          	addi	a0,a1,-100
 968:	18051363          	bnez	a0,aee <vprintf+0x252>
 96c:	18070163          	beqz	a4,aee <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 970:	008b8493          	addi	s1,s7,8
 974:	4685                	li	a3,1
 976:	4629                	li	a2,10
 978:	000bb583          	ld	a1,0(s7)
 97c:	855a                	mv	a0,s6
 97e:	e81ff0ef          	jal	7fe <printint>
        i += 2;
 982:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 984:	8ba6                	mv	s7,s1
      state = 0;
 986:	4981                	li	s3,0
        i += 2;
 988:	bfa1                	j	8e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 98a:	008b8493          	addi	s1,s7,8
 98e:	4681                	li	a3,0
 990:	4629                	li	a2,10
 992:	000be583          	lwu	a1,0(s7)
 996:	855a                	mv	a0,s6
 998:	e67ff0ef          	jal	7fe <printint>
 99c:	8ba6                	mv	s7,s1
      state = 0;
 99e:	4981                	li	s3,0
 9a0:	b781                	j	8e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9a2:	008b8493          	addi	s1,s7,8
 9a6:	4681                	li	a3,0
 9a8:	4629                	li	a2,10
 9aa:	000bb583          	ld	a1,0(s7)
 9ae:	855a                	mv	a0,s6
 9b0:	e4fff0ef          	jal	7fe <printint>
        i += 1;
 9b4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 9b6:	8ba6                	mv	s7,s1
      state = 0;
 9b8:	4981                	li	s3,0
 9ba:	b71d                	j	8e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 9bc:	008b8493          	addi	s1,s7,8
 9c0:	4681                	li	a3,0
 9c2:	4629                	li	a2,10
 9c4:	000bb583          	ld	a1,0(s7)
 9c8:	855a                	mv	a0,s6
 9ca:	e35ff0ef          	jal	7fe <printint>
        i += 2;
 9ce:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 9d0:	8ba6                	mv	s7,s1
      state = 0;
 9d2:	4981                	li	s3,0
        i += 2;
 9d4:	b731                	j	8e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 9d6:	008b8493          	addi	s1,s7,8
 9da:	4681                	li	a3,0
 9dc:	4641                	li	a2,16
 9de:	000be583          	lwu	a1,0(s7)
 9e2:	855a                	mv	a0,s6
 9e4:	e1bff0ef          	jal	7fe <printint>
 9e8:	8ba6                	mv	s7,s1
      state = 0;
 9ea:	4981                	li	s3,0
 9ec:	bdd5                	j	8e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 9ee:	008b8493          	addi	s1,s7,8
 9f2:	4681                	li	a3,0
 9f4:	4641                	li	a2,16
 9f6:	000bb583          	ld	a1,0(s7)
 9fa:	855a                	mv	a0,s6
 9fc:	e03ff0ef          	jal	7fe <printint>
        i += 1;
 a00:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 a02:	8ba6                	mv	s7,s1
      state = 0;
 a04:	4981                	li	s3,0
 a06:	bde9                	j	8e0 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 a08:	008b8493          	addi	s1,s7,8
 a0c:	4681                	li	a3,0
 a0e:	4641                	li	a2,16
 a10:	000bb583          	ld	a1,0(s7)
 a14:	855a                	mv	a0,s6
 a16:	de9ff0ef          	jal	7fe <printint>
        i += 2;
 a1a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 a1c:	8ba6                	mv	s7,s1
      state = 0;
 a1e:	4981                	li	s3,0
        i += 2;
 a20:	b5c1                	j	8e0 <vprintf+0x44>
 a22:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 a24:	008b8793          	addi	a5,s7,8
 a28:	8cbe                	mv	s9,a5
 a2a:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 a2e:	03000593          	li	a1,48
 a32:	855a                	mv	a0,s6
 a34:	dadff0ef          	jal	7e0 <putc>
  putc(fd, 'x');
 a38:	07800593          	li	a1,120
 a3c:	855a                	mv	a0,s6
 a3e:	da3ff0ef          	jal	7e0 <putc>
 a42:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 a44:	00000b97          	auipc	s7,0x0
 a48:	46cb8b93          	addi	s7,s7,1132 # eb0 <digits>
 a4c:	03c9d793          	srli	a5,s3,0x3c
 a50:	97de                	add	a5,a5,s7
 a52:	0007c583          	lbu	a1,0(a5)
 a56:	855a                	mv	a0,s6
 a58:	d89ff0ef          	jal	7e0 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 a5c:	0992                	slli	s3,s3,0x4
 a5e:	34fd                	addiw	s1,s1,-1
 a60:	f4f5                	bnez	s1,a4c <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 a62:	8be6                	mv	s7,s9
      state = 0;
 a64:	4981                	li	s3,0
 a66:	6ca2                	ld	s9,8(sp)
 a68:	bda5                	j	8e0 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 a6a:	008b8493          	addi	s1,s7,8
 a6e:	000bc583          	lbu	a1,0(s7)
 a72:	855a                	mv	a0,s6
 a74:	d6dff0ef          	jal	7e0 <putc>
 a78:	8ba6                	mv	s7,s1
      state = 0;
 a7a:	4981                	li	s3,0
 a7c:	b595                	j	8e0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 a7e:	008b8993          	addi	s3,s7,8
 a82:	000bb483          	ld	s1,0(s7)
 a86:	cc91                	beqz	s1,aa2 <vprintf+0x206>
        for(; *s; s++)
 a88:	0004c583          	lbu	a1,0(s1)
 a8c:	c985                	beqz	a1,abc <vprintf+0x220>
          putc(fd, *s);
 a8e:	855a                	mv	a0,s6
 a90:	d51ff0ef          	jal	7e0 <putc>
        for(; *s; s++)
 a94:	0485                	addi	s1,s1,1
 a96:	0004c583          	lbu	a1,0(s1)
 a9a:	f9f5                	bnez	a1,a8e <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 a9c:	8bce                	mv	s7,s3
      state = 0;
 a9e:	4981                	li	s3,0
 aa0:	b581                	j	8e0 <vprintf+0x44>
          s = "(null)";
 aa2:	00000497          	auipc	s1,0x0
 aa6:	40648493          	addi	s1,s1,1030 # ea8 <malloc+0x26a>
        for(; *s; s++)
 aaa:	02800593          	li	a1,40
 aae:	b7c5                	j	a8e <vprintf+0x1f2>
        putc(fd, '%');
 ab0:	85be                	mv	a1,a5
 ab2:	855a                	mv	a0,s6
 ab4:	d2dff0ef          	jal	7e0 <putc>
      state = 0;
 ab8:	4981                	li	s3,0
 aba:	b51d                	j	8e0 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 abc:	8bce                	mv	s7,s3
      state = 0;
 abe:	4981                	li	s3,0
 ac0:	b505                	j	8e0 <vprintf+0x44>
 ac2:	6906                	ld	s2,64(sp)
 ac4:	79e2                	ld	s3,56(sp)
 ac6:	7a42                	ld	s4,48(sp)
 ac8:	7aa2                	ld	s5,40(sp)
 aca:	7b02                	ld	s6,32(sp)
 acc:	6be2                	ld	s7,24(sp)
 ace:	6c42                	ld	s8,16(sp)
    }
  }
}
 ad0:	60e6                	ld	ra,88(sp)
 ad2:	6446                	ld	s0,80(sp)
 ad4:	64a6                	ld	s1,72(sp)
 ad6:	6125                	addi	sp,sp,96
 ad8:	8082                	ret
      if(c0 == 'd'){
 ada:	06400713          	li	a4,100
 ade:	e4e78fe3          	beq	a5,a4,93c <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 ae2:	f9478693          	addi	a3,a5,-108
 ae6:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 aea:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 aec:	4701                	li	a4,0
      } else if(c0 == 'u'){
 aee:	07500513          	li	a0,117
 af2:	e8a78ce3          	beq	a5,a0,98a <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 af6:	f8b60513          	addi	a0,a2,-117
 afa:	e119                	bnez	a0,b00 <vprintf+0x264>
 afc:	ea0693e3          	bnez	a3,9a2 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 b00:	f8b58513          	addi	a0,a1,-117
 b04:	e119                	bnez	a0,b0a <vprintf+0x26e>
 b06:	ea071be3          	bnez	a4,9bc <vprintf+0x120>
      } else if(c0 == 'x'){
 b0a:	07800513          	li	a0,120
 b0e:	eca784e3          	beq	a5,a0,9d6 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 b12:	f8860613          	addi	a2,a2,-120
 b16:	e219                	bnez	a2,b1c <vprintf+0x280>
 b18:	ec069be3          	bnez	a3,9ee <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 b1c:	f8858593          	addi	a1,a1,-120
 b20:	e199                	bnez	a1,b26 <vprintf+0x28a>
 b22:	ee0713e3          	bnez	a4,a08 <vprintf+0x16c>
      } else if(c0 == 'p'){
 b26:	07000713          	li	a4,112
 b2a:	eee78ce3          	beq	a5,a4,a22 <vprintf+0x186>
      } else if(c0 == 'c'){
 b2e:	06300713          	li	a4,99
 b32:	f2e78ce3          	beq	a5,a4,a6a <vprintf+0x1ce>
      } else if(c0 == 's'){
 b36:	07300713          	li	a4,115
 b3a:	f4e782e3          	beq	a5,a4,a7e <vprintf+0x1e2>
      } else if(c0 == '%'){
 b3e:	02500713          	li	a4,37
 b42:	f6e787e3          	beq	a5,a4,ab0 <vprintf+0x214>
        putc(fd, '%');
 b46:	02500593          	li	a1,37
 b4a:	855a                	mv	a0,s6
 b4c:	c95ff0ef          	jal	7e0 <putc>
        putc(fd, c0);
 b50:	85a6                	mv	a1,s1
 b52:	855a                	mv	a0,s6
 b54:	c8dff0ef          	jal	7e0 <putc>
      state = 0;
 b58:	4981                	li	s3,0
 b5a:	b359                	j	8e0 <vprintf+0x44>

0000000000000b5c <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 b5c:	715d                	addi	sp,sp,-80
 b5e:	ec06                	sd	ra,24(sp)
 b60:	e822                	sd	s0,16(sp)
 b62:	1000                	addi	s0,sp,32
 b64:	e010                	sd	a2,0(s0)
 b66:	e414                	sd	a3,8(s0)
 b68:	e818                	sd	a4,16(s0)
 b6a:	ec1c                	sd	a5,24(s0)
 b6c:	03043023          	sd	a6,32(s0)
 b70:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 b74:	8622                	mv	a2,s0
 b76:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 b7a:	d23ff0ef          	jal	89c <vprintf>
}
 b7e:	60e2                	ld	ra,24(sp)
 b80:	6442                	ld	s0,16(sp)
 b82:	6161                	addi	sp,sp,80
 b84:	8082                	ret

0000000000000b86 <printf>:

void
printf(const char *fmt, ...)
{
 b86:	711d                	addi	sp,sp,-96
 b88:	ec06                	sd	ra,24(sp)
 b8a:	e822                	sd	s0,16(sp)
 b8c:	1000                	addi	s0,sp,32
 b8e:	e40c                	sd	a1,8(s0)
 b90:	e810                	sd	a2,16(s0)
 b92:	ec14                	sd	a3,24(s0)
 b94:	f018                	sd	a4,32(s0)
 b96:	f41c                	sd	a5,40(s0)
 b98:	03043823          	sd	a6,48(s0)
 b9c:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 ba0:	00840613          	addi	a2,s0,8
 ba4:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 ba8:	85aa                	mv	a1,a0
 baa:	4505                	li	a0,1
 bac:	cf1ff0ef          	jal	89c <vprintf>
}
 bb0:	60e2                	ld	ra,24(sp)
 bb2:	6442                	ld	s0,16(sp)
 bb4:	6125                	addi	sp,sp,96
 bb6:	8082                	ret

0000000000000bb8 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 bb8:	1141                	addi	sp,sp,-16
 bba:	e406                	sd	ra,8(sp)
 bbc:	e022                	sd	s0,0(sp)
 bbe:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 bc0:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bc4:	00000797          	auipc	a5,0x0
 bc8:	4447b783          	ld	a5,1092(a5) # 1008 <freep>
 bcc:	a039                	j	bda <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 bce:	6398                	ld	a4,0(a5)
 bd0:	00e7e463          	bltu	a5,a4,bd8 <free+0x20>
 bd4:	00e6ea63          	bltu	a3,a4,be8 <free+0x30>
{
 bd8:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 bda:	fed7fae3          	bgeu	a5,a3,bce <free+0x16>
 bde:	6398                	ld	a4,0(a5)
 be0:	00e6e463          	bltu	a3,a4,be8 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 be4:	fee7eae3          	bltu	a5,a4,bd8 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 be8:	ff852583          	lw	a1,-8(a0)
 bec:	6390                	ld	a2,0(a5)
 bee:	02059813          	slli	a6,a1,0x20
 bf2:	01c85713          	srli	a4,a6,0x1c
 bf6:	9736                	add	a4,a4,a3
 bf8:	02e60563          	beq	a2,a4,c22 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 bfc:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 c00:	4790                	lw	a2,8(a5)
 c02:	02061593          	slli	a1,a2,0x20
 c06:	01c5d713          	srli	a4,a1,0x1c
 c0a:	973e                	add	a4,a4,a5
 c0c:	02e68263          	beq	a3,a4,c30 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 c10:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 c12:	00000717          	auipc	a4,0x0
 c16:	3ef73b23          	sd	a5,1014(a4) # 1008 <freep>
}
 c1a:	60a2                	ld	ra,8(sp)
 c1c:	6402                	ld	s0,0(sp)
 c1e:	0141                	addi	sp,sp,16
 c20:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 c22:	4618                	lw	a4,8(a2)
 c24:	9f2d                	addw	a4,a4,a1
 c26:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 c2a:	6398                	ld	a4,0(a5)
 c2c:	6310                	ld	a2,0(a4)
 c2e:	b7f9                	j	bfc <free+0x44>
    p->s.size += bp->s.size;
 c30:	ff852703          	lw	a4,-8(a0)
 c34:	9f31                	addw	a4,a4,a2
 c36:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 c38:	ff053683          	ld	a3,-16(a0)
 c3c:	bfd1                	j	c10 <free+0x58>

0000000000000c3e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 c3e:	7139                	addi	sp,sp,-64
 c40:	fc06                	sd	ra,56(sp)
 c42:	f822                	sd	s0,48(sp)
 c44:	f04a                	sd	s2,32(sp)
 c46:	ec4e                	sd	s3,24(sp)
 c48:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 c4a:	02051993          	slli	s3,a0,0x20
 c4e:	0209d993          	srli	s3,s3,0x20
 c52:	09bd                	addi	s3,s3,15
 c54:	0049d993          	srli	s3,s3,0x4
 c58:	2985                	addiw	s3,s3,1
 c5a:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 c5c:	00000517          	auipc	a0,0x0
 c60:	3ac53503          	ld	a0,940(a0) # 1008 <freep>
 c64:	c905                	beqz	a0,c94 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 c66:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 c68:	4798                	lw	a4,8(a5)
 c6a:	09377663          	bgeu	a4,s3,cf6 <malloc+0xb8>
 c6e:	f426                	sd	s1,40(sp)
 c70:	e852                	sd	s4,16(sp)
 c72:	e456                	sd	s5,8(sp)
 c74:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 c76:	8a4e                	mv	s4,s3
 c78:	6705                	lui	a4,0x1
 c7a:	00e9f363          	bgeu	s3,a4,c80 <malloc+0x42>
 c7e:	6a05                	lui	s4,0x1
 c80:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 c84:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 c88:	00000497          	auipc	s1,0x0
 c8c:	38048493          	addi	s1,s1,896 # 1008 <freep>
  if(p == SBRK_ERROR)
 c90:	5afd                	li	s5,-1
 c92:	a83d                	j	cd0 <malloc+0x92>
 c94:	f426                	sd	s1,40(sp)
 c96:	e852                	sd	s4,16(sp)
 c98:	e456                	sd	s5,8(sp)
 c9a:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 c9c:	00004797          	auipc	a5,0x4
 ca0:	37478793          	addi	a5,a5,884 # 5010 <base>
 ca4:	00000717          	auipc	a4,0x0
 ca8:	36f73223          	sd	a5,868(a4) # 1008 <freep>
 cac:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 cae:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 cb2:	b7d1                	j	c76 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 cb4:	6398                	ld	a4,0(a5)
 cb6:	e118                	sd	a4,0(a0)
 cb8:	a899                	j	d0e <malloc+0xd0>
  hp->s.size = nu;
 cba:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 cbe:	0541                	addi	a0,a0,16
 cc0:	ef9ff0ef          	jal	bb8 <free>
  return freep;
 cc4:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 cc6:	c125                	beqz	a0,d26 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 cc8:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 cca:	4798                	lw	a4,8(a5)
 ccc:	03277163          	bgeu	a4,s2,cee <malloc+0xb0>
    if(p == freep)
 cd0:	6098                	ld	a4,0(s1)
 cd2:	853e                	mv	a0,a5
 cd4:	fef71ae3          	bne	a4,a5,cc8 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 cd8:	8552                	mv	a0,s4
 cda:	a33ff0ef          	jal	70c <sbrk>
  if(p == SBRK_ERROR)
 cde:	fd551ee3          	bne	a0,s5,cba <malloc+0x7c>
        return 0;
 ce2:	4501                	li	a0,0
 ce4:	74a2                	ld	s1,40(sp)
 ce6:	6a42                	ld	s4,16(sp)
 ce8:	6aa2                	ld	s5,8(sp)
 cea:	6b02                	ld	s6,0(sp)
 cec:	a03d                	j	d1a <malloc+0xdc>
 cee:	74a2                	ld	s1,40(sp)
 cf0:	6a42                	ld	s4,16(sp)
 cf2:	6aa2                	ld	s5,8(sp)
 cf4:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 cf6:	fae90fe3          	beq	s2,a4,cb4 <malloc+0x76>
        p->s.size -= nunits;
 cfa:	4137073b          	subw	a4,a4,s3
 cfe:	c798                	sw	a4,8(a5)
        p += p->s.size;
 d00:	02071693          	slli	a3,a4,0x20
 d04:	01c6d713          	srli	a4,a3,0x1c
 d08:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 d0a:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 d0e:	00000717          	auipc	a4,0x0
 d12:	2ea73d23          	sd	a0,762(a4) # 1008 <freep>
      return (void*)(p + 1);
 d16:	01078513          	addi	a0,a5,16
  }
}
 d1a:	70e2                	ld	ra,56(sp)
 d1c:	7442                	ld	s0,48(sp)
 d1e:	7902                	ld	s2,32(sp)
 d20:	69e2                	ld	s3,24(sp)
 d22:	6121                	addi	sp,sp,64
 d24:	8082                	ret
 d26:	74a2                	ld	s1,40(sp)
 d28:	6a42                	ld	s4,16(sp)
 d2a:	6aa2                	ld	s5,8(sp)
 d2c:	6b02                	ld	s6,0(sp)
 d2e:	b7f5                	j	d1a <malloc+0xdc>
