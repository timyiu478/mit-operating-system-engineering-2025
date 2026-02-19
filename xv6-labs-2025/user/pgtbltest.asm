
user/_pgtbltest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:

char *testname = "???";

void
err(char *why)
{
   0:	1101                	addi	sp,sp,-32
   2:	ec06                	sd	ra,24(sp)
   4:	e822                	sd	s0,16(sp)
   6:	e426                	sd	s1,8(sp)
   8:	e04a                	sd	s2,0(sp)
   a:	1000                	addi	s0,sp,32
   c:	892a                	mv	s2,a0
  printf("pgtbltest: %s failed: %s, pid=%d\n", testname, why, getpid());
   e:	00002497          	auipc	s1,0x2
  12:	ff24b483          	ld	s1,-14(s1) # 2000 <testname>
  16:	04d000ef          	jal	862 <getpid>
  1a:	86aa                	mv	a3,a0
  1c:	864a                	mv	a2,s2
  1e:	85a6                	mv	a1,s1
  20:	00001517          	auipc	a0,0x1
  24:	df050513          	addi	a0,a0,-528 # e10 <malloc+0xfa>
  28:	437000ef          	jal	c5e <printf>
  exit(1);
  2c:	4505                	li	a0,1
  2e:	7b4000ef          	jal	7e2 <exit>

0000000000000032 <print_pte>:
}

void
print_pte(uint64 va)
{
  32:	1101                	addi	sp,sp,-32
  34:	ec06                	sd	ra,24(sp)
  36:	e822                	sd	s0,16(sp)
  38:	e426                	sd	s1,8(sp)
  3a:	1000                	addi	s0,sp,32
  3c:	84aa                	mv	s1,a0
    pte_t pte = (pte_t) pgpte((void *) va);
  3e:	067000ef          	jal	8a4 <pgpte>
  42:	862a                	mv	a2,a0
    printf("va 0x%lx pte 0x%lx pa 0x%lx perm 0x%lx\n", va, pte, PTE2PA(pte), PTE_FLAGS(pte));
  44:	00a55693          	srli	a3,a0,0xa
  48:	3ff57713          	andi	a4,a0,1023
  4c:	06b2                	slli	a3,a3,0xc
  4e:	85a6                	mv	a1,s1
  50:	00001517          	auipc	a0,0x1
  54:	de850513          	addi	a0,a0,-536 # e38 <malloc+0x122>
  58:	407000ef          	jal	c5e <printf>
}
  5c:	60e2                	ld	ra,24(sp)
  5e:	6442                	ld	s0,16(sp)
  60:	64a2                	ld	s1,8(sp)
  62:	6105                	addi	sp,sp,32
  64:	8082                	ret

0000000000000066 <print_pgtbl>:

void
print_pgtbl()
{
  66:	7179                	addi	sp,sp,-48
  68:	f406                	sd	ra,40(sp)
  6a:	f022                	sd	s0,32(sp)
  6c:	ec26                	sd	s1,24(sp)
  6e:	e84a                	sd	s2,16(sp)
  70:	e44e                	sd	s3,8(sp)
  72:	1800                	addi	s0,sp,48
  printf("print_pgtbl starting\n");
  74:	00001517          	auipc	a0,0x1
  78:	dec50513          	addi	a0,a0,-532 # e60 <malloc+0x14a>
  7c:	3e3000ef          	jal	c5e <printf>
  80:	4481                	li	s1,0
  for (uint64 i = 0; i < 10; i++) {
  82:	6985                	lui	s3,0x1
  84:	6929                	lui	s2,0xa
    print_pte(i * PGSIZE);
  86:	8526                	mv	a0,s1
  88:	fabff0ef          	jal	32 <print_pte>
  for (uint64 i = 0; i < 10; i++) {
  8c:	94ce                	add	s1,s1,s3
  8e:	ff249ce3          	bne	s1,s2,86 <print_pgtbl+0x20>
  92:	020004b7          	lui	s1,0x2000
  96:	14ed                	addi	s1,s1,-5 # 1fffffb <base+0x1ffdfdb>
  98:	04b6                	slli	s1,s1,0xd
  }
  uint64 top = MAXVA/PGSIZE;
  for (uint64 i = top-10; i < top; i++) {
  9a:	6985                	lui	s3,0x1
  9c:	4905                	li	s2,1
  9e:	191a                	slli	s2,s2,0x26
    print_pte(i * PGSIZE);
  a0:	8526                	mv	a0,s1
  a2:	f91ff0ef          	jal	32 <print_pte>
  for (uint64 i = top-10; i < top; i++) {
  a6:	94ce                	add	s1,s1,s3
  a8:	ff249ce3          	bne	s1,s2,a0 <print_pgtbl+0x3a>
  }
  printf("print_pgtbl: OK\n");
  ac:	00001517          	auipc	a0,0x1
  b0:	dcc50513          	addi	a0,a0,-564 # e78 <malloc+0x162>
  b4:	3ab000ef          	jal	c5e <printf>
}
  b8:	70a2                	ld	ra,40(sp)
  ba:	7402                	ld	s0,32(sp)
  bc:	64e2                	ld	s1,24(sp)
  be:	6942                	ld	s2,16(sp)
  c0:	69a2                	ld	s3,8(sp)
  c2:	6145                	addi	sp,sp,48
  c4:	8082                	ret

00000000000000c6 <ugetpid_test>:

void
ugetpid_test()
{
  c6:	7139                	addi	sp,sp,-64
  c8:	fc06                	sd	ra,56(sp)
  ca:	f822                	sd	s0,48(sp)
  cc:	f426                	sd	s1,40(sp)
  ce:	f04a                	sd	s2,32(sp)
  d0:	ec4e                	sd	s3,24(sp)
  d2:	0080                	addi	s0,sp,64
  int i;

  printf("ugetpid_test starting\n");
  d4:	00001517          	auipc	a0,0x1
  d8:	dbc50513          	addi	a0,a0,-580 # e90 <malloc+0x17a>
  dc:	383000ef          	jal	c5e <printf>
  testname = "ugetpid_test";
  e0:	00001797          	auipc	a5,0x1
  e4:	dc878793          	addi	a5,a5,-568 # ea8 <malloc+0x192>
  e8:	00002717          	auipc	a4,0x2
  ec:	f0f73c23          	sd	a5,-232(a4) # 2000 <testname>

  if(getpid() != ugetpid())
  f0:	772000ef          	jal	862 <getpid>
  f4:	89aa                	mv	s3,a0
  f6:	6ca000ef          	jal	7c0 <ugetpid>
  fa:	04000493          	li	s1,64
    err("mismatched PID #1");

  for (i = 0; i < 64; i++) {
    int ret = fork();
    if (ret != 0) {
      wait(&ret);
  fe:	fcc40913          	addi	s2,s0,-52
  if(getpid() != ugetpid())
 102:	02a99c63          	bne	s3,a0,13a <ugetpid_test+0x74>
    int ret = fork();
 106:	6d4000ef          	jal	7da <fork>
 10a:	fca42623          	sw	a0,-52(s0)
    if (ret != 0) {
 10e:	cd1d                	beqz	a0,14c <ugetpid_test+0x86>
      wait(&ret);
 110:	854a                	mv	a0,s2
 112:	6d8000ef          	jal	7ea <wait>
      if (ret != 0)
 116:	fcc42783          	lw	a5,-52(s0)
 11a:	e795                	bnez	a5,146 <ugetpid_test+0x80>
  for (i = 0; i < 64; i++) {
 11c:	34fd                	addiw	s1,s1,-1
 11e:	f4e5                	bnez	s1,106 <ugetpid_test+0x40>
    }
    if (getpid() != ugetpid())
      err("mismatched PID #2");
    exit(0);
  }
  printf("ugetpid_test: OK\n");
 120:	00001517          	auipc	a0,0x1
 124:	dc850513          	addi	a0,a0,-568 # ee8 <malloc+0x1d2>
 128:	337000ef          	jal	c5e <printf>
}
 12c:	70e2                	ld	ra,56(sp)
 12e:	7442                	ld	s0,48(sp)
 130:	74a2                	ld	s1,40(sp)
 132:	7902                	ld	s2,32(sp)
 134:	69e2                	ld	s3,24(sp)
 136:	6121                	addi	sp,sp,64
 138:	8082                	ret
    err("mismatched PID #1");
 13a:	00001517          	auipc	a0,0x1
 13e:	d7e50513          	addi	a0,a0,-642 # eb8 <malloc+0x1a2>
 142:	ebfff0ef          	jal	0 <err>
        exit(1);
 146:	4505                	li	a0,1
 148:	69a000ef          	jal	7e2 <exit>
    if (getpid() != ugetpid())
 14c:	716000ef          	jal	862 <getpid>
 150:	84aa                	mv	s1,a0
 152:	66e000ef          	jal	7c0 <ugetpid>
 156:	00a48863          	beq	s1,a0,166 <ugetpid_test+0xa0>
      err("mismatched PID #2");
 15a:	00001517          	auipc	a0,0x1
 15e:	d7650513          	addi	a0,a0,-650 # ed0 <malloc+0x1ba>
 162:	e9fff0ef          	jal	0 <err>
    exit(0);
 166:	4501                	li	a0,0
 168:	67a000ef          	jal	7e2 <exit>

000000000000016c <print_kpgtbl>:

void
print_kpgtbl()
{
 16c:	1141                	addi	sp,sp,-16
 16e:	e406                	sd	ra,8(sp)
 170:	e022                	sd	s0,0(sp)
 172:	0800                	addi	s0,sp,16
  printf("print_kpgtbl starting\n");
 174:	00001517          	auipc	a0,0x1
 178:	d8c50513          	addi	a0,a0,-628 # f00 <malloc+0x1ea>
 17c:	2e3000ef          	jal	c5e <printf>
  kpgtbl();
 180:	72e000ef          	jal	8ae <kpgtbl>
  printf("print_kpgtbl: OK\n");
 184:	00001517          	auipc	a0,0x1
 188:	d9450513          	addi	a0,a0,-620 # f18 <malloc+0x202>
 18c:	2d3000ef          	jal	c5e <printf>
}
 190:	60a2                	ld	ra,8(sp)
 192:	6402                	ld	s0,0(sp)
 194:	0141                	addi	sp,sp,16
 196:	8082                	ret

0000000000000198 <supercheck>:


void
supercheck(char *end)
{
 198:	7139                	addi	sp,sp,-64
 19a:	fc06                	sd	ra,56(sp)
 19c:	f822                	sd	s0,48(sp)
 19e:	f426                	sd	s1,40(sp)
 1a0:	f04a                	sd	s2,32(sp)
 1a2:	ec4e                	sd	s3,24(sp)
 1a4:	e852                	sd	s4,16(sp)
 1a6:	e456                	sd	s5,8(sp)
 1a8:	e05a                	sd	s6,0(sp)
 1aa:	0080                	addi	s0,sp,64
  pte_t last_pte = 0;
  uint64 a = (uint64) end;
  uint64 s = SUPERPGROUNDUP(a);
 1ac:	002009b7          	lui	s3,0x200
 1b0:	19fd                	addi	s3,s3,-1 # 1fffff <base+0x1fdfdf>
 1b2:	99aa                	add	s3,s3,a0
 1b4:	ffe007b7          	lui	a5,0xffe00
 1b8:	00f9f9b3          	and	s3,s3,a5

  for (; a < s; a += PGSIZE) {
 1bc:	01357b63          	bgeu	a0,s3,1d2 <supercheck+0x3a>
 1c0:	84aa                	mv	s1,a0
 1c2:	6905                	lui	s2,0x1
    pte_t pte = (pte_t) pgpte((void *) a);
 1c4:	8526                	mv	a0,s1
 1c6:	6de000ef          	jal	8a4 <pgpte>
    if (pte == 0) {
 1ca:	c105                	beqz	a0,1ea <supercheck+0x52>
  for (; a < s; a += PGSIZE) {
 1cc:	94ca                	add	s1,s1,s2
 1ce:	ff34ebe3          	bltu	s1,s3,1c4 <supercheck+0x2c>
      err("no pte");
    }
  }

  for (uint64 p = s;  p < s + 512 * PGSIZE; p += PGSIZE) {
 1d2:	ffe007b7          	lui	a5,0xffe00
 1d6:	06f9f263          	bgeu	s3,a5,23a <supercheck+0xa2>
 1da:	00200a37          	lui	s4,0x200
 1de:	9a4e                	add	s4,s4,s3
 1e0:	84ce                	mv	s1,s3
  pte_t last_pte = 0;
 1e2:	4501                	li	a0,0
    if(pte == 0)
      err("no pte");
    if ((uint64) last_pte != 0 && pte != last_pte) {
        err("pte different");
    }
    if((pte & PTE_V) == 0 || (pte & PTE_R) == 0 || (pte & PTE_W) == 0){
 1e4:	4a9d                	li	s5,7
  for (uint64 p = s;  p < s + 512 * PGSIZE; p += PGSIZE) {
 1e6:	6b05                	lui	s6,0x1
 1e8:	a025                	j	210 <supercheck+0x78>
      err("no pte");
 1ea:	00001517          	auipc	a0,0x1
 1ee:	d4650513          	addi	a0,a0,-698 # f30 <malloc+0x21a>
 1f2:	e0fff0ef          	jal	0 <err>
      err("no pte");
 1f6:	00001517          	auipc	a0,0x1
 1fa:	d3a50513          	addi	a0,a0,-710 # f30 <malloc+0x21a>
 1fe:	e03ff0ef          	jal	0 <err>
    if((pte & PTE_V) == 0 || (pte & PTE_R) == 0 || (pte & PTE_W) == 0){
 202:	00757793          	andi	a5,a0,7
 206:	03579463          	bne	a5,s5,22e <supercheck+0x96>
  for (uint64 p = s;  p < s + 512 * PGSIZE; p += PGSIZE) {
 20a:	94da                	add	s1,s1,s6
 20c:	0344f763          	bgeu	s1,s4,23a <supercheck+0xa2>
    pte_t pte = (pte_t) pgpte((void *) p);
 210:	892a                	mv	s2,a0
 212:	8526                	mv	a0,s1
 214:	690000ef          	jal	8a4 <pgpte>
    if(pte == 0)
 218:	dd79                	beqz	a0,1f6 <supercheck+0x5e>
    if ((uint64) last_pte != 0 && pte != last_pte) {
 21a:	fe0904e3          	beqz	s2,202 <supercheck+0x6a>
 21e:	ff2502e3          	beq	a0,s2,202 <supercheck+0x6a>
        err("pte different");
 222:	00001517          	auipc	a0,0x1
 226:	d1650513          	addi	a0,a0,-746 # f38 <malloc+0x222>
 22a:	dd7ff0ef          	jal	0 <err>
      err("pte wrong");
 22e:	00001517          	auipc	a0,0x1
 232:	d1a50513          	addi	a0,a0,-742 # f48 <malloc+0x232>
 236:	dcbff0ef          	jal	0 <err>
  pte_t last_pte = 0;
 23a:	4781                	li	a5,0
    }
    last_pte = pte;
  }

  for(int i = 0; i < 512 * PGSIZE; i += PGSIZE){
 23c:	6605                	lui	a2,0x1
 23e:	002006b7          	lui	a3,0x200
    *(int*)(s+i) = i;
 242:	01378733          	add	a4,a5,s3
 246:	c31c                	sw	a5,0(a4)
  for(int i = 0; i < 512 * PGSIZE; i += PGSIZE){
 248:	97b2                	add	a5,a5,a2
 24a:	fed79ce3          	bne	a5,a3,242 <supercheck+0xaa>
 24e:	4781                	li	a5,0
  }

  for(int i = 0; i < 512 * PGSIZE; i += PGSIZE){
 250:	6585                	lui	a1,0x1
 252:	00200637          	lui	a2,0x200
    if(*(int*)(s+i) != i)
 256:	01378733          	add	a4,a5,s3
 25a:	4314                	lw	a3,0(a4)
 25c:	0007871b          	sext.w	a4,a5
 260:	00e69f63          	bne	a3,a4,27e <supercheck+0xe6>
  for(int i = 0; i < 512 * PGSIZE; i += PGSIZE){
 264:	97ae                	add	a5,a5,a1
 266:	fec798e3          	bne	a5,a2,256 <supercheck+0xbe>
      err("wrong value");
  }
}
 26a:	70e2                	ld	ra,56(sp)
 26c:	7442                	ld	s0,48(sp)
 26e:	74a2                	ld	s1,40(sp)
 270:	7902                	ld	s2,32(sp)
 272:	69e2                	ld	s3,24(sp)
 274:	6a42                	ld	s4,16(sp)
 276:	6aa2                	ld	s5,8(sp)
 278:	6b02                	ld	s6,0(sp)
 27a:	6121                	addi	sp,sp,64
 27c:	8082                	ret
      err("wrong value");
 27e:	00001517          	auipc	a0,0x1
 282:	cda50513          	addi	a0,a0,-806 # f58 <malloc+0x242>
 286:	d7bff0ef          	jal	0 <err>

000000000000028a <superpg_fork>:

void
superpg_fork()
{
 28a:	7179                	addi	sp,sp,-48
 28c:	f406                	sd	ra,40(sp)
 28e:	f022                	sd	s0,32(sp)
 290:	ec26                	sd	s1,24(sp)
 292:	1800                	addi	s0,sp,48
  int pid;
  
  printf("superpg_fork starting\n");
 294:	00001517          	auipc	a0,0x1
 298:	cd450513          	addi	a0,a0,-812 # f68 <malloc+0x252>
 29c:	1c3000ef          	jal	c5e <printf>
  testname = "superpg_fork";
 2a0:	00001797          	auipc	a5,0x1
 2a4:	ce078793          	addi	a5,a5,-800 # f80 <malloc+0x26a>
 2a8:	00002717          	auipc	a4,0x2
 2ac:	d4f73c23          	sd	a5,-680(a4) # 2000 <testname>
  
  char *end = sbrk(SZ);
 2b0:	01000537          	lui	a0,0x1000
 2b4:	4e0000ef          	jal	794 <sbrk>
  if (end == 0 || end == SBRK_ERROR)
 2b8:	fff50713          	addi	a4,a0,-1 # ffffff <base+0xffdfdf>
 2bc:	57f5                	li	a5,-3
 2be:	04e7e963          	bltu	a5,a4,310 <superpg_fork+0x86>
 2c2:	84aa                	mv	s1,a0
    err("sbrk failed");

  // check if parent has super pages
  supercheck(end);
 2c4:	ed5ff0ef          	jal	198 <supercheck>
  if((pid = fork()) < 0) {
 2c8:	512000ef          	jal	7da <fork>
 2cc:	04054863          	bltz	a0,31c <superpg_fork+0x92>
    err("fork");
  } else if(pid == 0) {
 2d0:	cd21                	beqz	a0,328 <superpg_fork+0x9e>
    // check if child's address space has super pages
    supercheck(end);
    exit(0);
  } else {
    int status;
    wait(&status);
 2d2:	fdc40513          	addi	a0,s0,-36
 2d6:	514000ef          	jal	7ea <wait>
    if (status != 0) {
 2da:	fdc42783          	lw	a5,-36(s0)
 2de:	ebb9                	bnez	a5,334 <superpg_fork+0xaa>
      exit(0);
    }
  }

  // free super pages
  sbrk(-SZ);
 2e0:	ff000537          	lui	a0,0xff000
 2e4:	4b0000ef          	jal	794 <sbrk>
  if((pid = fork()) < 0) {
 2e8:	4f2000ef          	jal	7da <fork>
 2ec:	04054763          	bltz	a0,33a <superpg_fork+0xb0>
    err("fork");
  } else if(pid == 0) {
 2f0:	e939                	bnez	a0,346 <superpg_fork+0xbc>
    // reference freed memory; this should result in page fault and
    // the kernel should kill the child.
    * (end + 1) = '9'; 
 2f2:	03900793          	li	a5,57
 2f6:	00f480a3          	sb	a5,1(s1)
    if (status == 0) {
      err("child was able to reference free memory\n");
      exit(1);
    }
  }  
  printf("superpg_fork: OK\n");  
 2fa:	00001517          	auipc	a0,0x1
 2fe:	cd650513          	addi	a0,a0,-810 # fd0 <malloc+0x2ba>
 302:	15d000ef          	jal	c5e <printf>
}
 306:	70a2                	ld	ra,40(sp)
 308:	7402                	ld	s0,32(sp)
 30a:	64e2                	ld	s1,24(sp)
 30c:	6145                	addi	sp,sp,48
 30e:	8082                	ret
    err("sbrk failed");
 310:	00001517          	auipc	a0,0x1
 314:	c8050513          	addi	a0,a0,-896 # f90 <malloc+0x27a>
 318:	ce9ff0ef          	jal	0 <err>
    err("fork");
 31c:	00001517          	auipc	a0,0x1
 320:	c6c50513          	addi	a0,a0,-916 # f88 <malloc+0x272>
 324:	cddff0ef          	jal	0 <err>
    supercheck(end);
 328:	8526                	mv	a0,s1
 32a:	e6fff0ef          	jal	198 <supercheck>
    exit(0);
 32e:	4501                	li	a0,0
 330:	4b2000ef          	jal	7e2 <exit>
      exit(0);
 334:	4501                	li	a0,0
 336:	4ac000ef          	jal	7e2 <exit>
    err("fork");
 33a:	00001517          	auipc	a0,0x1
 33e:	c4e50513          	addi	a0,a0,-946 # f88 <malloc+0x272>
 342:	cbfff0ef          	jal	0 <err>
    wait(&status);
 346:	fdc40513          	addi	a0,s0,-36
 34a:	4a0000ef          	jal	7ea <wait>
    if (status == 0) {
 34e:	fdc42783          	lw	a5,-36(s0)
 352:	f7c5                	bnez	a5,2fa <superpg_fork+0x70>
      err("child was able to reference free memory\n");
 354:	00001517          	auipc	a0,0x1
 358:	c4c50513          	addi	a0,a0,-948 # fa0 <malloc+0x28a>
 35c:	ca5ff0ef          	jal	0 <err>

0000000000000360 <superpg_free>:

void
superpg_free()
{
 360:	7139                	addi	sp,sp,-64
 362:	fc06                	sd	ra,56(sp)
 364:	f822                	sd	s0,48(sp)
 366:	f426                	sd	s1,40(sp)
 368:	f04a                	sd	s2,32(sp)
 36a:	ec4e                	sd	s3,24(sp)
 36c:	0080                	addi	s0,sp,64
  int pid;
  
  printf("superpg_free starting\n");
 36e:	00001517          	auipc	a0,0x1
 372:	c7a50513          	addi	a0,a0,-902 # fe8 <malloc+0x2d2>
 376:	0e9000ef          	jal	c5e <printf>
  testname = "superpg_free";
 37a:	00001797          	auipc	a5,0x1
 37e:	c8678793          	addi	a5,a5,-890 # 1000 <malloc+0x2ea>
 382:	00002717          	auipc	a4,0x2
 386:	c6f73f23          	sd	a5,-898(a4) # 2000 <testname>

  char *end = sbrk(SZ);
 38a:	01000537          	lui	a0,0x1000
 38e:	406000ef          	jal	794 <sbrk>
  if (end == 0 || end == SBRK_ERROR)
 392:	157d                	addi	a0,a0,-1 # ffffff <base+0xffdfdf>
 394:	57f5                	li	a5,-3
 396:	0ea7e463          	bltu	a5,a0,47e <superpg_free+0x11e>
    err("sbrk failed");

  // free pages beyond a super page
  char *a = sbrk(0);
 39a:	4501                	li	a0,0
 39c:	3f8000ef          	jal	794 <sbrk>
  uint64 s = SUPERPGROUNDDOWN((uint64) a);
 3a0:	00200737          	lui	a4,0x200
 3a4:	fff70793          	addi	a5,a4,-1 # 1fffff <base+0x1fdfdf>
 3a8:	97aa                	add	a5,a5,a0
 3aa:	ffe006b7          	lui	a3,0xffe00
 3ae:	8ff5                	and	a5,a5,a3
 3b0:	8f99                	sub	a5,a5,a4
  sbrk(-((uint64) a-s));
 3b2:	40a7853b          	subw	a0,a5,a0
 3b6:	3de000ef          	jal	794 <sbrk>
  a = sbrk(0);
 3ba:	4501                	li	a0,0
 3bc:	3d8000ef          	jal	794 <sbrk>
 3c0:	84aa                	mv	s1,a0

  pte_t pte1 = (pte_t) pgpte((void *) a-PGSIZE);
 3c2:	80050513          	addi	a0,a0,-2048
 3c6:	80050513          	addi	a0,a0,-2048
 3ca:	4da000ef          	jal	8a4 <pgpte>
 3ce:	892a                	mv	s2,a0
  pte_t pte2 = (pte_t) pgpte((void *) a-2*PGSIZE);
 3d0:	7579                	lui	a0,0xffffe
 3d2:	9526                	add	a0,a0,s1
 3d4:	4d0000ef          	jal	8a4 <pgpte>
  if (pte1 != pte2) {
 3d8:	0aa91963          	bne	s2,a0,48a <superpg_free+0x12a>
    err("not a super page");
  }
  
  // write to the last 8192-byte section of a super page
  * (a - PGSIZE + 1) = '8';
 3dc:	797d                	lui	s2,0xfffff
 3de:	012487b3          	add	a5,s1,s2
 3e2:	03800713          	li	a4,56
 3e6:	00e780a3          	sb	a4,1(a5)
  * (a - 2*PGSIZE + 1) = '9';
 3ea:	77f9                	lui	a5,0xffffe
 3ec:	94be                	add	s1,s1,a5
 3ee:	03900993          	li	s3,57
 3f2:	013480a3          	sb	s3,1(s1)

  // free last 4096 bytes of a super page
  sbrk(-PGSIZE);
 3f6:	854a                	mv	a0,s2
 3f8:	39c000ef          	jal	794 <sbrk>
  a = sbrk(0);
 3fc:	4501                	li	a0,0
 3fe:	396000ef          	jal	794 <sbrk>
 402:	84aa                	mv	s1,a0

  if (*(a - PGSIZE + 1) != '9') {
 404:	992a                	add	s2,s2,a0
 406:	00194783          	lbu	a5,1(s2) # fffffffffffff001 <base+0xffffffffffffcfe1>
 40a:	09379663          	bne	a5,s3,496 <superpg_free+0x136>
    err("lost content after freeing part of super page");
  }

  if((pid = fork()) < 0) {
 40e:	3cc000ef          	jal	7da <fork>
 412:	08054863          	bltz	a0,4a2 <superpg_free+0x142>
    err("fork");
  } else if(pid == 0) {
 416:	ed51                	bnez	a0,4b2 <superpg_free+0x152>
     // the memory at address a shouldn't be in the child's address
     // space, since the parent freed it. The following reference
     // should result in page fault and the kernel should kill the
     // child.
    if (* (a + 1) == '9') {
 418:	0014c703          	lbu	a4,1(s1)
 41c:	03900793          	li	a5,57
 420:	08f70763          	beq	a4,a5,4ae <superpg_free+0x14e>
      err("child was able to reference free memory\n");
      exit(1);
    }
  }

  pte1 = (pte_t) pgpte((void *) a);
 424:	8526                	mv	a0,s1
 426:	47e000ef          	jal	8a4 <pgpte>
  if(pte1 != 0) {
 42a:	e14d                	bnez	a0,4cc <superpg_free+0x16c>
    err("pte for freed memory is valid");
  }

  s = SUPERPGROUNDDOWN((uint64) a);
 42c:	002007b7          	lui	a5,0x200
 430:	fff78993          	addi	s3,a5,-1 # 1fffff <base+0x1fdfdf>
 434:	99a6                	add	s3,s3,s1
 436:	ffe00737          	lui	a4,0xffe00
 43a:	00e9f9b3          	and	s3,s3,a4
 43e:	40f989b3          	sub	s3,s3,a5
  for (; (uint64) a > s; a -= PGSIZE) {
 442:	0299f163          	bgeu	s3,s1,464 <superpg_free+0x104>
    a = sbrk(-PGSIZE);
 446:	797d                	lui	s2,0xfffff
 448:	854a                	mv	a0,s2
 44a:	34a000ef          	jal	794 <sbrk>
 44e:	84aa                	mv	s1,a0
    pte1 = (pte_t) pgpte(sbrk(0));
 450:	4501                	li	a0,0
 452:	342000ef          	jal	794 <sbrk>
 456:	44e000ef          	jal	8a4 <pgpte>
    if(pte1 != 0) {
 45a:	ed3d                	bnez	a0,4d8 <superpg_free+0x178>
  for (; (uint64) a > s; a -= PGSIZE) {
 45c:	01248533          	add	a0,s1,s2
 460:	fea9e4e3          	bltu	s3,a0,448 <superpg_free+0xe8>
      err("page hasn't been freed");
    }
  }
  
  printf("superpg_free: OK\n");  
 464:	00001517          	auipc	a0,0x1
 468:	c2c50513          	addi	a0,a0,-980 # 1090 <malloc+0x37a>
 46c:	7f2000ef          	jal	c5e <printf>
}
 470:	70e2                	ld	ra,56(sp)
 472:	7442                	ld	s0,48(sp)
 474:	74a2                	ld	s1,40(sp)
 476:	7902                	ld	s2,32(sp)
 478:	69e2                	ld	s3,24(sp)
 47a:	6121                	addi	sp,sp,64
 47c:	8082                	ret
    err("sbrk failed");
 47e:	00001517          	auipc	a0,0x1
 482:	b1250513          	addi	a0,a0,-1262 # f90 <malloc+0x27a>
 486:	b7bff0ef          	jal	0 <err>
    err("not a super page");
 48a:	00001517          	auipc	a0,0x1
 48e:	b8650513          	addi	a0,a0,-1146 # 1010 <malloc+0x2fa>
 492:	b6fff0ef          	jal	0 <err>
    err("lost content after freeing part of super page");
 496:	00001517          	auipc	a0,0x1
 49a:	b9250513          	addi	a0,a0,-1134 # 1028 <malloc+0x312>
 49e:	b63ff0ef          	jal	0 <err>
    err("fork");
 4a2:	00001517          	auipc	a0,0x1
 4a6:	ae650513          	addi	a0,a0,-1306 # f88 <malloc+0x272>
 4aa:	b57ff0ef          	jal	0 <err>
      exit(0);
 4ae:	334000ef          	jal	7e2 <exit>
    wait(&status);
 4b2:	fcc40513          	addi	a0,s0,-52
 4b6:	334000ef          	jal	7ea <wait>
    if (status == 0) {
 4ba:	fcc42783          	lw	a5,-52(s0)
 4be:	f3bd                	bnez	a5,424 <superpg_free+0xc4>
      err("child was able to reference free memory\n");
 4c0:	00001517          	auipc	a0,0x1
 4c4:	ae050513          	addi	a0,a0,-1312 # fa0 <malloc+0x28a>
 4c8:	b39ff0ef          	jal	0 <err>
    err("pte for freed memory is valid");
 4cc:	00001517          	auipc	a0,0x1
 4d0:	b8c50513          	addi	a0,a0,-1140 # 1058 <malloc+0x342>
 4d4:	b2dff0ef          	jal	0 <err>
      err("page hasn't been freed");
 4d8:	00001517          	auipc	a0,0x1
 4dc:	ba050513          	addi	a0,a0,-1120 # 1078 <malloc+0x362>
 4e0:	b21ff0ef          	jal	0 <err>

00000000000004e4 <main>:
{
 4e4:	1141                	addi	sp,sp,-16
 4e6:	e406                	sd	ra,8(sp)
 4e8:	e022                	sd	s0,0(sp)
 4ea:	0800                	addi	s0,sp,16
  print_pgtbl();
 4ec:	b7bff0ef          	jal	66 <print_pgtbl>
  ugetpid_test();
 4f0:	bd7ff0ef          	jal	c6 <ugetpid_test>
  print_kpgtbl();
 4f4:	c79ff0ef          	jal	16c <print_kpgtbl>
  superpg_fork();
 4f8:	d93ff0ef          	jal	28a <superpg_fork>
  superpg_free();
 4fc:	e65ff0ef          	jal	360 <superpg_free>
  printf("pgtbltest: all tests succeeded\n");
 500:	00001517          	auipc	a0,0x1
 504:	ba850513          	addi	a0,a0,-1112 # 10a8 <malloc+0x392>
 508:	756000ef          	jal	c5e <printf>
  exit(0);
 50c:	4501                	li	a0,0
 50e:	2d4000ef          	jal	7e2 <exit>

0000000000000512 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
 512:	1141                	addi	sp,sp,-16
 514:	e406                	sd	ra,8(sp)
 516:	e022                	sd	s0,0(sp)
 518:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
 51a:	fcbff0ef          	jal	4e4 <main>
  exit(r);
 51e:	2c4000ef          	jal	7e2 <exit>

0000000000000522 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 522:	1141                	addi	sp,sp,-16
 524:	e406                	sd	ra,8(sp)
 526:	e022                	sd	s0,0(sp)
 528:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 52a:	87aa                	mv	a5,a0
 52c:	0585                	addi	a1,a1,1 # 1001 <malloc+0x2eb>
 52e:	0785                	addi	a5,a5,1
 530:	fff5c703          	lbu	a4,-1(a1)
 534:	fee78fa3          	sb	a4,-1(a5)
 538:	fb75                	bnez	a4,52c <strcpy+0xa>
    ;
  return os;
}
 53a:	60a2                	ld	ra,8(sp)
 53c:	6402                	ld	s0,0(sp)
 53e:	0141                	addi	sp,sp,16
 540:	8082                	ret

0000000000000542 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 542:	1141                	addi	sp,sp,-16
 544:	e406                	sd	ra,8(sp)
 546:	e022                	sd	s0,0(sp)
 548:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 54a:	00054783          	lbu	a5,0(a0)
 54e:	cb91                	beqz	a5,562 <strcmp+0x20>
 550:	0005c703          	lbu	a4,0(a1)
 554:	00f71763          	bne	a4,a5,562 <strcmp+0x20>
    p++, q++;
 558:	0505                	addi	a0,a0,1
 55a:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 55c:	00054783          	lbu	a5,0(a0)
 560:	fbe5                	bnez	a5,550 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 562:	0005c503          	lbu	a0,0(a1)
}
 566:	40a7853b          	subw	a0,a5,a0
 56a:	60a2                	ld	ra,8(sp)
 56c:	6402                	ld	s0,0(sp)
 56e:	0141                	addi	sp,sp,16
 570:	8082                	ret

0000000000000572 <strlen>:

uint
strlen(const char *s)
{
 572:	1141                	addi	sp,sp,-16
 574:	e406                	sd	ra,8(sp)
 576:	e022                	sd	s0,0(sp)
 578:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 57a:	00054783          	lbu	a5,0(a0)
 57e:	cf91                	beqz	a5,59a <strlen+0x28>
 580:	00150793          	addi	a5,a0,1
 584:	86be                	mv	a3,a5
 586:	0785                	addi	a5,a5,1
 588:	fff7c703          	lbu	a4,-1(a5)
 58c:	ff65                	bnez	a4,584 <strlen+0x12>
 58e:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 592:	60a2                	ld	ra,8(sp)
 594:	6402                	ld	s0,0(sp)
 596:	0141                	addi	sp,sp,16
 598:	8082                	ret
  for(n = 0; s[n]; n++)
 59a:	4501                	li	a0,0
 59c:	bfdd                	j	592 <strlen+0x20>

000000000000059e <memset>:

void*
memset(void *dst, int c, uint n)
{
 59e:	1141                	addi	sp,sp,-16
 5a0:	e406                	sd	ra,8(sp)
 5a2:	e022                	sd	s0,0(sp)
 5a4:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 5a6:	ca19                	beqz	a2,5bc <memset+0x1e>
 5a8:	87aa                	mv	a5,a0
 5aa:	1602                	slli	a2,a2,0x20
 5ac:	9201                	srli	a2,a2,0x20
 5ae:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 5b2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 5b6:	0785                	addi	a5,a5,1
 5b8:	fee79de3          	bne	a5,a4,5b2 <memset+0x14>
  }
  return dst;
}
 5bc:	60a2                	ld	ra,8(sp)
 5be:	6402                	ld	s0,0(sp)
 5c0:	0141                	addi	sp,sp,16
 5c2:	8082                	ret

00000000000005c4 <strchr>:

char*
strchr(const char *s, char c)
{
 5c4:	1141                	addi	sp,sp,-16
 5c6:	e406                	sd	ra,8(sp)
 5c8:	e022                	sd	s0,0(sp)
 5ca:	0800                	addi	s0,sp,16
  for(; *s; s++)
 5cc:	00054783          	lbu	a5,0(a0)
 5d0:	cf81                	beqz	a5,5e8 <strchr+0x24>
    if(*s == c)
 5d2:	00f58763          	beq	a1,a5,5e0 <strchr+0x1c>
  for(; *s; s++)
 5d6:	0505                	addi	a0,a0,1
 5d8:	00054783          	lbu	a5,0(a0)
 5dc:	fbfd                	bnez	a5,5d2 <strchr+0xe>
      return (char*)s;
  return 0;
 5de:	4501                	li	a0,0
}
 5e0:	60a2                	ld	ra,8(sp)
 5e2:	6402                	ld	s0,0(sp)
 5e4:	0141                	addi	sp,sp,16
 5e6:	8082                	ret
  return 0;
 5e8:	4501                	li	a0,0
 5ea:	bfdd                	j	5e0 <strchr+0x1c>

00000000000005ec <gets>:

char*
gets(char *buf, int max)
{
 5ec:	711d                	addi	sp,sp,-96
 5ee:	ec86                	sd	ra,88(sp)
 5f0:	e8a2                	sd	s0,80(sp)
 5f2:	e4a6                	sd	s1,72(sp)
 5f4:	e0ca                	sd	s2,64(sp)
 5f6:	fc4e                	sd	s3,56(sp)
 5f8:	f852                	sd	s4,48(sp)
 5fa:	f456                	sd	s5,40(sp)
 5fc:	f05a                	sd	s6,32(sp)
 5fe:	ec5e                	sd	s7,24(sp)
 600:	e862                	sd	s8,16(sp)
 602:	1080                	addi	s0,sp,96
 604:	8baa                	mv	s7,a0
 606:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 608:	892a                	mv	s2,a0
 60a:	4481                	li	s1,0
    cc = read(0, &c, 1);
 60c:	faf40b13          	addi	s6,s0,-81
 610:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 612:	8c26                	mv	s8,s1
 614:	0014899b          	addiw	s3,s1,1
 618:	84ce                	mv	s1,s3
 61a:	0349d463          	bge	s3,s4,642 <gets+0x56>
    cc = read(0, &c, 1);
 61e:	8656                	mv	a2,s5
 620:	85da                	mv	a1,s6
 622:	4501                	li	a0,0
 624:	1d6000ef          	jal	7fa <read>
    if(cc < 1)
 628:	00a05d63          	blez	a0,642 <gets+0x56>
      break;
    buf[i++] = c;
 62c:	faf44783          	lbu	a5,-81(s0)
 630:	00f90023          	sb	a5,0(s2) # fffffffffffff000 <base+0xffffffffffffcfe0>
    if(c == '\n' || c == '\r')
 634:	0905                	addi	s2,s2,1
 636:	ff678713          	addi	a4,a5,-10
 63a:	c319                	beqz	a4,640 <gets+0x54>
 63c:	17cd                	addi	a5,a5,-13
 63e:	fbf1                	bnez	a5,612 <gets+0x26>
    buf[i++] = c;
 640:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 642:	9c5e                	add	s8,s8,s7
 644:	000c0023          	sb	zero,0(s8)
  return buf;
}
 648:	855e                	mv	a0,s7
 64a:	60e6                	ld	ra,88(sp)
 64c:	6446                	ld	s0,80(sp)
 64e:	64a6                	ld	s1,72(sp)
 650:	6906                	ld	s2,64(sp)
 652:	79e2                	ld	s3,56(sp)
 654:	7a42                	ld	s4,48(sp)
 656:	7aa2                	ld	s5,40(sp)
 658:	7b02                	ld	s6,32(sp)
 65a:	6be2                	ld	s7,24(sp)
 65c:	6c42                	ld	s8,16(sp)
 65e:	6125                	addi	sp,sp,96
 660:	8082                	ret

0000000000000662 <stat>:

int
stat(const char *n, struct stat *st)
{
 662:	1101                	addi	sp,sp,-32
 664:	ec06                	sd	ra,24(sp)
 666:	e822                	sd	s0,16(sp)
 668:	e04a                	sd	s2,0(sp)
 66a:	1000                	addi	s0,sp,32
 66c:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 66e:	4581                	li	a1,0
 670:	1b2000ef          	jal	822 <open>
  if(fd < 0)
 674:	02054263          	bltz	a0,698 <stat+0x36>
 678:	e426                	sd	s1,8(sp)
 67a:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 67c:	85ca                	mv	a1,s2
 67e:	1bc000ef          	jal	83a <fstat>
 682:	892a                	mv	s2,a0
  close(fd);
 684:	8526                	mv	a0,s1
 686:	184000ef          	jal	80a <close>
  return r;
 68a:	64a2                	ld	s1,8(sp)
}
 68c:	854a                	mv	a0,s2
 68e:	60e2                	ld	ra,24(sp)
 690:	6442                	ld	s0,16(sp)
 692:	6902                	ld	s2,0(sp)
 694:	6105                	addi	sp,sp,32
 696:	8082                	ret
    return -1;
 698:	57fd                	li	a5,-1
 69a:	893e                	mv	s2,a5
 69c:	bfc5                	j	68c <stat+0x2a>

000000000000069e <atoi>:

int
atoi(const char *s)
{
 69e:	1141                	addi	sp,sp,-16
 6a0:	e406                	sd	ra,8(sp)
 6a2:	e022                	sd	s0,0(sp)
 6a4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 6a6:	00054683          	lbu	a3,0(a0)
 6aa:	fd06879b          	addiw	a5,a3,-48 # ffffffffffdfffd0 <base+0xffffffffffdfdfb0>
 6ae:	0ff7f793          	zext.b	a5,a5
 6b2:	4625                	li	a2,9
 6b4:	02f66963          	bltu	a2,a5,6e6 <atoi+0x48>
 6b8:	872a                	mv	a4,a0
  n = 0;
 6ba:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 6bc:	0705                	addi	a4,a4,1 # ffffffffffe00001 <base+0xffffffffffdfdfe1>
 6be:	0025179b          	slliw	a5,a0,0x2
 6c2:	9fa9                	addw	a5,a5,a0
 6c4:	0017979b          	slliw	a5,a5,0x1
 6c8:	9fb5                	addw	a5,a5,a3
 6ca:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 6ce:	00074683          	lbu	a3,0(a4)
 6d2:	fd06879b          	addiw	a5,a3,-48
 6d6:	0ff7f793          	zext.b	a5,a5
 6da:	fef671e3          	bgeu	a2,a5,6bc <atoi+0x1e>
  return n;
}
 6de:	60a2                	ld	ra,8(sp)
 6e0:	6402                	ld	s0,0(sp)
 6e2:	0141                	addi	sp,sp,16
 6e4:	8082                	ret
  n = 0;
 6e6:	4501                	li	a0,0
 6e8:	bfdd                	j	6de <atoi+0x40>

00000000000006ea <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 6ea:	1141                	addi	sp,sp,-16
 6ec:	e406                	sd	ra,8(sp)
 6ee:	e022                	sd	s0,0(sp)
 6f0:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 6f2:	02b57563          	bgeu	a0,a1,71c <memmove+0x32>
    while(n-- > 0)
 6f6:	00c05f63          	blez	a2,714 <memmove+0x2a>
 6fa:	1602                	slli	a2,a2,0x20
 6fc:	9201                	srli	a2,a2,0x20
 6fe:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 702:	872a                	mv	a4,a0
      *dst++ = *src++;
 704:	0585                	addi	a1,a1,1
 706:	0705                	addi	a4,a4,1
 708:	fff5c683          	lbu	a3,-1(a1)
 70c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 710:	fee79ae3          	bne	a5,a4,704 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 714:	60a2                	ld	ra,8(sp)
 716:	6402                	ld	s0,0(sp)
 718:	0141                	addi	sp,sp,16
 71a:	8082                	ret
    while(n-- > 0)
 71c:	fec05ce3          	blez	a2,714 <memmove+0x2a>
    dst += n;
 720:	00c50733          	add	a4,a0,a2
    src += n;
 724:	95b2                	add	a1,a1,a2
 726:	fff6079b          	addiw	a5,a2,-1 # 1fffff <base+0x1fdfdf>
 72a:	1782                	slli	a5,a5,0x20
 72c:	9381                	srli	a5,a5,0x20
 72e:	fff7c793          	not	a5,a5
 732:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 734:	15fd                	addi	a1,a1,-1
 736:	177d                	addi	a4,a4,-1
 738:	0005c683          	lbu	a3,0(a1)
 73c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 740:	fef71ae3          	bne	a4,a5,734 <memmove+0x4a>
 744:	bfc1                	j	714 <memmove+0x2a>

0000000000000746 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 746:	1141                	addi	sp,sp,-16
 748:	e406                	sd	ra,8(sp)
 74a:	e022                	sd	s0,0(sp)
 74c:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 74e:	c61d                	beqz	a2,77c <memcmp+0x36>
 750:	1602                	slli	a2,a2,0x20
 752:	9201                	srli	a2,a2,0x20
 754:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 758:	00054783          	lbu	a5,0(a0)
 75c:	0005c703          	lbu	a4,0(a1)
 760:	00e79863          	bne	a5,a4,770 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 764:	0505                	addi	a0,a0,1
    p2++;
 766:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 768:	fed518e3          	bne	a0,a3,758 <memcmp+0x12>
  }
  return 0;
 76c:	4501                	li	a0,0
 76e:	a019                	j	774 <memcmp+0x2e>
      return *p1 - *p2;
 770:	40e7853b          	subw	a0,a5,a4
}
 774:	60a2                	ld	ra,8(sp)
 776:	6402                	ld	s0,0(sp)
 778:	0141                	addi	sp,sp,16
 77a:	8082                	ret
  return 0;
 77c:	4501                	li	a0,0
 77e:	bfdd                	j	774 <memcmp+0x2e>

0000000000000780 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 780:	1141                	addi	sp,sp,-16
 782:	e406                	sd	ra,8(sp)
 784:	e022                	sd	s0,0(sp)
 786:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 788:	f63ff0ef          	jal	6ea <memmove>
}
 78c:	60a2                	ld	ra,8(sp)
 78e:	6402                	ld	s0,0(sp)
 790:	0141                	addi	sp,sp,16
 792:	8082                	ret

0000000000000794 <sbrk>:

char *
sbrk(int n) {
 794:	1141                	addi	sp,sp,-16
 796:	e406                	sd	ra,8(sp)
 798:	e022                	sd	s0,0(sp)
 79a:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 79c:	4585                	li	a1,1
 79e:	0cc000ef          	jal	86a <sys_sbrk>
}
 7a2:	60a2                	ld	ra,8(sp)
 7a4:	6402                	ld	s0,0(sp)
 7a6:	0141                	addi	sp,sp,16
 7a8:	8082                	ret

00000000000007aa <sbrklazy>:

char *
sbrklazy(int n) {
 7aa:	1141                	addi	sp,sp,-16
 7ac:	e406                	sd	ra,8(sp)
 7ae:	e022                	sd	s0,0(sp)
 7b0:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 7b2:	4589                	li	a1,2
 7b4:	0b6000ef          	jal	86a <sys_sbrk>
}
 7b8:	60a2                	ld	ra,8(sp)
 7ba:	6402                	ld	s0,0(sp)
 7bc:	0141                	addi	sp,sp,16
 7be:	8082                	ret

00000000000007c0 <ugetpid>:

#ifdef LAB_PGTBL
int
ugetpid(void)
{
 7c0:	1141                	addi	sp,sp,-16
 7c2:	e406                	sd	ra,8(sp)
 7c4:	e022                	sd	s0,0(sp)
 7c6:	0800                	addi	s0,sp,16
  struct usyscall *u = (struct usyscall *)USYSCALL;
  return u->pid;
 7c8:	040007b7          	lui	a5,0x4000
 7cc:	17f5                	addi	a5,a5,-3 # 3fffffd <base+0x3ffdfdd>
 7ce:	07b2                	slli	a5,a5,0xc
}
 7d0:	4388                	lw	a0,0(a5)
 7d2:	60a2                	ld	ra,8(sp)
 7d4:	6402                	ld	s0,0(sp)
 7d6:	0141                	addi	sp,sp,16
 7d8:	8082                	ret

00000000000007da <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 7da:	4885                	li	a7,1
 ecall
 7dc:	00000073          	ecall
 ret
 7e0:	8082                	ret

00000000000007e2 <exit>:
.global exit
exit:
 li a7, SYS_exit
 7e2:	4889                	li	a7,2
 ecall
 7e4:	00000073          	ecall
 ret
 7e8:	8082                	ret

00000000000007ea <wait>:
.global wait
wait:
 li a7, SYS_wait
 7ea:	488d                	li	a7,3
 ecall
 7ec:	00000073          	ecall
 ret
 7f0:	8082                	ret

00000000000007f2 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 7f2:	4891                	li	a7,4
 ecall
 7f4:	00000073          	ecall
 ret
 7f8:	8082                	ret

00000000000007fa <read>:
.global read
read:
 li a7, SYS_read
 7fa:	4895                	li	a7,5
 ecall
 7fc:	00000073          	ecall
 ret
 800:	8082                	ret

0000000000000802 <write>:
.global write
write:
 li a7, SYS_write
 802:	48c1                	li	a7,16
 ecall
 804:	00000073          	ecall
 ret
 808:	8082                	ret

000000000000080a <close>:
.global close
close:
 li a7, SYS_close
 80a:	48d5                	li	a7,21
 ecall
 80c:	00000073          	ecall
 ret
 810:	8082                	ret

0000000000000812 <kill>:
.global kill
kill:
 li a7, SYS_kill
 812:	4899                	li	a7,6
 ecall
 814:	00000073          	ecall
 ret
 818:	8082                	ret

000000000000081a <exec>:
.global exec
exec:
 li a7, SYS_exec
 81a:	489d                	li	a7,7
 ecall
 81c:	00000073          	ecall
 ret
 820:	8082                	ret

0000000000000822 <open>:
.global open
open:
 li a7, SYS_open
 822:	48bd                	li	a7,15
 ecall
 824:	00000073          	ecall
 ret
 828:	8082                	ret

000000000000082a <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 82a:	48c5                	li	a7,17
 ecall
 82c:	00000073          	ecall
 ret
 830:	8082                	ret

0000000000000832 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 832:	48c9                	li	a7,18
 ecall
 834:	00000073          	ecall
 ret
 838:	8082                	ret

000000000000083a <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 83a:	48a1                	li	a7,8
 ecall
 83c:	00000073          	ecall
 ret
 840:	8082                	ret

0000000000000842 <link>:
.global link
link:
 li a7, SYS_link
 842:	48cd                	li	a7,19
 ecall
 844:	00000073          	ecall
 ret
 848:	8082                	ret

000000000000084a <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 84a:	48d1                	li	a7,20
 ecall
 84c:	00000073          	ecall
 ret
 850:	8082                	ret

0000000000000852 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 852:	48a5                	li	a7,9
 ecall
 854:	00000073          	ecall
 ret
 858:	8082                	ret

000000000000085a <dup>:
.global dup
dup:
 li a7, SYS_dup
 85a:	48a9                	li	a7,10
 ecall
 85c:	00000073          	ecall
 ret
 860:	8082                	ret

0000000000000862 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 862:	48ad                	li	a7,11
 ecall
 864:	00000073          	ecall
 ret
 868:	8082                	ret

000000000000086a <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 86a:	48b1                	li	a7,12
 ecall
 86c:	00000073          	ecall
 ret
 870:	8082                	ret

0000000000000872 <pause>:
.global pause
pause:
 li a7, SYS_pause
 872:	48b5                	li	a7,13
 ecall
 874:	00000073          	ecall
 ret
 878:	8082                	ret

000000000000087a <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 87a:	48b9                	li	a7,14
 ecall
 87c:	00000073          	ecall
 ret
 880:	8082                	ret

0000000000000882 <bind>:
.global bind
bind:
 li a7, SYS_bind
 882:	48f5                	li	a7,29
 ecall
 884:	00000073          	ecall
 ret
 888:	8082                	ret

000000000000088a <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
 88a:	48f9                	li	a7,30
 ecall
 88c:	00000073          	ecall
 ret
 890:	8082                	ret

0000000000000892 <send>:
.global send
send:
 li a7, SYS_send
 892:	48fd                	li	a7,31
 ecall
 894:	00000073          	ecall
 ret
 898:	8082                	ret

000000000000089a <recv>:
.global recv
recv:
 li a7, SYS_recv
 89a:	02000893          	li	a7,32
 ecall
 89e:	00000073          	ecall
 ret
 8a2:	8082                	ret

00000000000008a4 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
 8a4:	02100893          	li	a7,33
 ecall
 8a8:	00000073          	ecall
 ret
 8ac:	8082                	ret

00000000000008ae <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
 8ae:	02200893          	li	a7,34
 ecall
 8b2:	00000073          	ecall
 ret
 8b6:	8082                	ret

00000000000008b8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 8b8:	1101                	addi	sp,sp,-32
 8ba:	ec06                	sd	ra,24(sp)
 8bc:	e822                	sd	s0,16(sp)
 8be:	1000                	addi	s0,sp,32
 8c0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 8c4:	4605                	li	a2,1
 8c6:	fef40593          	addi	a1,s0,-17
 8ca:	f39ff0ef          	jal	802 <write>
}
 8ce:	60e2                	ld	ra,24(sp)
 8d0:	6442                	ld	s0,16(sp)
 8d2:	6105                	addi	sp,sp,32
 8d4:	8082                	ret

00000000000008d6 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 8d6:	715d                	addi	sp,sp,-80
 8d8:	e486                	sd	ra,72(sp)
 8da:	e0a2                	sd	s0,64(sp)
 8dc:	f84a                	sd	s2,48(sp)
 8de:	f44e                	sd	s3,40(sp)
 8e0:	0880                	addi	s0,sp,80
 8e2:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
 8e4:	c6d1                	beqz	a3,970 <printint+0x9a>
 8e6:	0805d563          	bgez	a1,970 <printint+0x9a>
    neg = 1;
    x = -xx;
 8ea:	40b005b3          	neg	a1,a1
    neg = 1;
 8ee:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 8f0:	fb840993          	addi	s3,s0,-72
  neg = 0;
 8f4:	86ce                	mv	a3,s3
  i = 0;
 8f6:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 8f8:	00000817          	auipc	a6,0x0
 8fc:	7e080813          	addi	a6,a6,2016 # 10d8 <digits>
 900:	88ba                	mv	a7,a4
 902:	0017051b          	addiw	a0,a4,1
 906:	872a                	mv	a4,a0
 908:	02c5f7b3          	remu	a5,a1,a2
 90c:	97c2                	add	a5,a5,a6
 90e:	0007c783          	lbu	a5,0(a5)
 912:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 916:	87ae                	mv	a5,a1
 918:	02c5d5b3          	divu	a1,a1,a2
 91c:	0685                	addi	a3,a3,1
 91e:	fec7f1e3          	bgeu	a5,a2,900 <printint+0x2a>
  if(neg)
 922:	00030c63          	beqz	t1,93a <printint+0x64>
    buf[i++] = '-';
 926:	fd050793          	addi	a5,a0,-48
 92a:	00878533          	add	a0,a5,s0
 92e:	02d00793          	li	a5,45
 932:	fef50423          	sb	a5,-24(a0)
 936:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 93a:	02e05563          	blez	a4,964 <printint+0x8e>
 93e:	fc26                	sd	s1,56(sp)
 940:	377d                	addiw	a4,a4,-1
 942:	00e984b3          	add	s1,s3,a4
 946:	19fd                	addi	s3,s3,-1
 948:	99ba                	add	s3,s3,a4
 94a:	1702                	slli	a4,a4,0x20
 94c:	9301                	srli	a4,a4,0x20
 94e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 952:	0004c583          	lbu	a1,0(s1)
 956:	854a                	mv	a0,s2
 958:	f61ff0ef          	jal	8b8 <putc>
  while(--i >= 0)
 95c:	14fd                	addi	s1,s1,-1
 95e:	ff349ae3          	bne	s1,s3,952 <printint+0x7c>
 962:	74e2                	ld	s1,56(sp)
}
 964:	60a6                	ld	ra,72(sp)
 966:	6406                	ld	s0,64(sp)
 968:	7942                	ld	s2,48(sp)
 96a:	79a2                	ld	s3,40(sp)
 96c:	6161                	addi	sp,sp,80
 96e:	8082                	ret
  neg = 0;
 970:	4301                	li	t1,0
 972:	bfbd                	j	8f0 <printint+0x1a>

0000000000000974 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 974:	711d                	addi	sp,sp,-96
 976:	ec86                	sd	ra,88(sp)
 978:	e8a2                	sd	s0,80(sp)
 97a:	e4a6                	sd	s1,72(sp)
 97c:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 97e:	0005c483          	lbu	s1,0(a1)
 982:	22048363          	beqz	s1,ba8 <vprintf+0x234>
 986:	e0ca                	sd	s2,64(sp)
 988:	fc4e                	sd	s3,56(sp)
 98a:	f852                	sd	s4,48(sp)
 98c:	f456                	sd	s5,40(sp)
 98e:	f05a                	sd	s6,32(sp)
 990:	ec5e                	sd	s7,24(sp)
 992:	e862                	sd	s8,16(sp)
 994:	8b2a                	mv	s6,a0
 996:	8a2e                	mv	s4,a1
 998:	8bb2                	mv	s7,a2
  state = 0;
 99a:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 99c:	4901                	li	s2,0
 99e:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 9a0:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 9a4:	06400c13          	li	s8,100
 9a8:	a00d                	j	9ca <vprintf+0x56>
        putc(fd, c0);
 9aa:	85a6                	mv	a1,s1
 9ac:	855a                	mv	a0,s6
 9ae:	f0bff0ef          	jal	8b8 <putc>
 9b2:	a019                	j	9b8 <vprintf+0x44>
    } else if(state == '%'){
 9b4:	03598363          	beq	s3,s5,9da <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 9b8:	0019079b          	addiw	a5,s2,1
 9bc:	893e                	mv	s2,a5
 9be:	873e                	mv	a4,a5
 9c0:	97d2                	add	a5,a5,s4
 9c2:	0007c483          	lbu	s1,0(a5)
 9c6:	1c048a63          	beqz	s1,b9a <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 9ca:	0004879b          	sext.w	a5,s1
    if(state == 0){
 9ce:	fe0993e3          	bnez	s3,9b4 <vprintf+0x40>
      if(c0 == '%'){
 9d2:	fd579ce3          	bne	a5,s5,9aa <vprintf+0x36>
        state = '%';
 9d6:	89be                	mv	s3,a5
 9d8:	b7c5                	j	9b8 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 9da:	00ea06b3          	add	a3,s4,a4
 9de:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 9e2:	1c060863          	beqz	a2,bb2 <vprintf+0x23e>
      if(c0 == 'd'){
 9e6:	03878763          	beq	a5,s8,a14 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 9ea:	f9478693          	addi	a3,a5,-108
 9ee:	0016b693          	seqz	a3,a3
 9f2:	f9c60593          	addi	a1,a2,-100
 9f6:	e99d                	bnez	a1,a2c <vprintf+0xb8>
 9f8:	ca95                	beqz	a3,a2c <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 9fa:	008b8493          	addi	s1,s7,8
 9fe:	4685                	li	a3,1
 a00:	4629                	li	a2,10
 a02:	000bb583          	ld	a1,0(s7)
 a06:	855a                	mv	a0,s6
 a08:	ecfff0ef          	jal	8d6 <printint>
        i += 1;
 a0c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 a0e:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 a10:	4981                	li	s3,0
 a12:	b75d                	j	9b8 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 a14:	008b8493          	addi	s1,s7,8
 a18:	4685                	li	a3,1
 a1a:	4629                	li	a2,10
 a1c:	000ba583          	lw	a1,0(s7)
 a20:	855a                	mv	a0,s6
 a22:	eb5ff0ef          	jal	8d6 <printint>
 a26:	8ba6                	mv	s7,s1
      state = 0;
 a28:	4981                	li	s3,0
 a2a:	b779                	j	9b8 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 a2c:	9752                	add	a4,a4,s4
 a2e:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 a32:	f9460713          	addi	a4,a2,-108
 a36:	00173713          	seqz	a4,a4
 a3a:	8f75                	and	a4,a4,a3
 a3c:	f9c58513          	addi	a0,a1,-100
 a40:	18051363          	bnez	a0,bc6 <vprintf+0x252>
 a44:	18070163          	beqz	a4,bc6 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 a48:	008b8493          	addi	s1,s7,8
 a4c:	4685                	li	a3,1
 a4e:	4629                	li	a2,10
 a50:	000bb583          	ld	a1,0(s7)
 a54:	855a                	mv	a0,s6
 a56:	e81ff0ef          	jal	8d6 <printint>
        i += 2;
 a5a:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 a5c:	8ba6                	mv	s7,s1
      state = 0;
 a5e:	4981                	li	s3,0
        i += 2;
 a60:	bfa1                	j	9b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 a62:	008b8493          	addi	s1,s7,8
 a66:	4681                	li	a3,0
 a68:	4629                	li	a2,10
 a6a:	000be583          	lwu	a1,0(s7)
 a6e:	855a                	mv	a0,s6
 a70:	e67ff0ef          	jal	8d6 <printint>
 a74:	8ba6                	mv	s7,s1
      state = 0;
 a76:	4981                	li	s3,0
 a78:	b781                	j	9b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a7a:	008b8493          	addi	s1,s7,8
 a7e:	4681                	li	a3,0
 a80:	4629                	li	a2,10
 a82:	000bb583          	ld	a1,0(s7)
 a86:	855a                	mv	a0,s6
 a88:	e4fff0ef          	jal	8d6 <printint>
        i += 1;
 a8c:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 a8e:	8ba6                	mv	s7,s1
      state = 0;
 a90:	4981                	li	s3,0
 a92:	b71d                	j	9b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 a94:	008b8493          	addi	s1,s7,8
 a98:	4681                	li	a3,0
 a9a:	4629                	li	a2,10
 a9c:	000bb583          	ld	a1,0(s7)
 aa0:	855a                	mv	a0,s6
 aa2:	e35ff0ef          	jal	8d6 <printint>
        i += 2;
 aa6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 aa8:	8ba6                	mv	s7,s1
      state = 0;
 aaa:	4981                	li	s3,0
        i += 2;
 aac:	b731                	j	9b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 aae:	008b8493          	addi	s1,s7,8
 ab2:	4681                	li	a3,0
 ab4:	4641                	li	a2,16
 ab6:	000be583          	lwu	a1,0(s7)
 aba:	855a                	mv	a0,s6
 abc:	e1bff0ef          	jal	8d6 <printint>
 ac0:	8ba6                	mv	s7,s1
      state = 0;
 ac2:	4981                	li	s3,0
 ac4:	bdd5                	j	9b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ac6:	008b8493          	addi	s1,s7,8
 aca:	4681                	li	a3,0
 acc:	4641                	li	a2,16
 ace:	000bb583          	ld	a1,0(s7)
 ad2:	855a                	mv	a0,s6
 ad4:	e03ff0ef          	jal	8d6 <printint>
        i += 1;
 ad8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 ada:	8ba6                	mv	s7,s1
      state = 0;
 adc:	4981                	li	s3,0
 ade:	bde9                	j	9b8 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 ae0:	008b8493          	addi	s1,s7,8
 ae4:	4681                	li	a3,0
 ae6:	4641                	li	a2,16
 ae8:	000bb583          	ld	a1,0(s7)
 aec:	855a                	mv	a0,s6
 aee:	de9ff0ef          	jal	8d6 <printint>
        i += 2;
 af2:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 af4:	8ba6                	mv	s7,s1
      state = 0;
 af6:	4981                	li	s3,0
        i += 2;
 af8:	b5c1                	j	9b8 <vprintf+0x44>
 afa:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 afc:	008b8793          	addi	a5,s7,8
 b00:	8cbe                	mv	s9,a5
 b02:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 b06:	03000593          	li	a1,48
 b0a:	855a                	mv	a0,s6
 b0c:	dadff0ef          	jal	8b8 <putc>
  putc(fd, 'x');
 b10:	07800593          	li	a1,120
 b14:	855a                	mv	a0,s6
 b16:	da3ff0ef          	jal	8b8 <putc>
 b1a:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 b1c:	00000b97          	auipc	s7,0x0
 b20:	5bcb8b93          	addi	s7,s7,1468 # 10d8 <digits>
 b24:	03c9d793          	srli	a5,s3,0x3c
 b28:	97de                	add	a5,a5,s7
 b2a:	0007c583          	lbu	a1,0(a5)
 b2e:	855a                	mv	a0,s6
 b30:	d89ff0ef          	jal	8b8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 b34:	0992                	slli	s3,s3,0x4
 b36:	34fd                	addiw	s1,s1,-1
 b38:	f4f5                	bnez	s1,b24 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 b3a:	8be6                	mv	s7,s9
      state = 0;
 b3c:	4981                	li	s3,0
 b3e:	6ca2                	ld	s9,8(sp)
 b40:	bda5                	j	9b8 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 b42:	008b8493          	addi	s1,s7,8
 b46:	000bc583          	lbu	a1,0(s7)
 b4a:	855a                	mv	a0,s6
 b4c:	d6dff0ef          	jal	8b8 <putc>
 b50:	8ba6                	mv	s7,s1
      state = 0;
 b52:	4981                	li	s3,0
 b54:	b595                	j	9b8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 b56:	008b8993          	addi	s3,s7,8
 b5a:	000bb483          	ld	s1,0(s7)
 b5e:	cc91                	beqz	s1,b7a <vprintf+0x206>
        for(; *s; s++)
 b60:	0004c583          	lbu	a1,0(s1)
 b64:	c985                	beqz	a1,b94 <vprintf+0x220>
          putc(fd, *s);
 b66:	855a                	mv	a0,s6
 b68:	d51ff0ef          	jal	8b8 <putc>
        for(; *s; s++)
 b6c:	0485                	addi	s1,s1,1
 b6e:	0004c583          	lbu	a1,0(s1)
 b72:	f9f5                	bnez	a1,b66 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 b74:	8bce                	mv	s7,s3
      state = 0;
 b76:	4981                	li	s3,0
 b78:	b581                	j	9b8 <vprintf+0x44>
          s = "(null)";
 b7a:	00000497          	auipc	s1,0x0
 b7e:	55648493          	addi	s1,s1,1366 # 10d0 <malloc+0x3ba>
        for(; *s; s++)
 b82:	02800593          	li	a1,40
 b86:	b7c5                	j	b66 <vprintf+0x1f2>
        putc(fd, '%');
 b88:	85be                	mv	a1,a5
 b8a:	855a                	mv	a0,s6
 b8c:	d2dff0ef          	jal	8b8 <putc>
      state = 0;
 b90:	4981                	li	s3,0
 b92:	b51d                	j	9b8 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 b94:	8bce                	mv	s7,s3
      state = 0;
 b96:	4981                	li	s3,0
 b98:	b505                	j	9b8 <vprintf+0x44>
 b9a:	6906                	ld	s2,64(sp)
 b9c:	79e2                	ld	s3,56(sp)
 b9e:	7a42                	ld	s4,48(sp)
 ba0:	7aa2                	ld	s5,40(sp)
 ba2:	7b02                	ld	s6,32(sp)
 ba4:	6be2                	ld	s7,24(sp)
 ba6:	6c42                	ld	s8,16(sp)
    }
  }
}
 ba8:	60e6                	ld	ra,88(sp)
 baa:	6446                	ld	s0,80(sp)
 bac:	64a6                	ld	s1,72(sp)
 bae:	6125                	addi	sp,sp,96
 bb0:	8082                	ret
      if(c0 == 'd'){
 bb2:	06400713          	li	a4,100
 bb6:	e4e78fe3          	beq	a5,a4,a14 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 bba:	f9478693          	addi	a3,a5,-108
 bbe:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 bc2:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 bc4:	4701                	li	a4,0
      } else if(c0 == 'u'){
 bc6:	07500513          	li	a0,117
 bca:	e8a78ce3          	beq	a5,a0,a62 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 bce:	f8b60513          	addi	a0,a2,-117
 bd2:	e119                	bnez	a0,bd8 <vprintf+0x264>
 bd4:	ea0693e3          	bnez	a3,a7a <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 bd8:	f8b58513          	addi	a0,a1,-117
 bdc:	e119                	bnez	a0,be2 <vprintf+0x26e>
 bde:	ea071be3          	bnez	a4,a94 <vprintf+0x120>
      } else if(c0 == 'x'){
 be2:	07800513          	li	a0,120
 be6:	eca784e3          	beq	a5,a0,aae <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 bea:	f8860613          	addi	a2,a2,-120
 bee:	e219                	bnez	a2,bf4 <vprintf+0x280>
 bf0:	ec069be3          	bnez	a3,ac6 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 bf4:	f8858593          	addi	a1,a1,-120
 bf8:	e199                	bnez	a1,bfe <vprintf+0x28a>
 bfa:	ee0713e3          	bnez	a4,ae0 <vprintf+0x16c>
      } else if(c0 == 'p'){
 bfe:	07000713          	li	a4,112
 c02:	eee78ce3          	beq	a5,a4,afa <vprintf+0x186>
      } else if(c0 == 'c'){
 c06:	06300713          	li	a4,99
 c0a:	f2e78ce3          	beq	a5,a4,b42 <vprintf+0x1ce>
      } else if(c0 == 's'){
 c0e:	07300713          	li	a4,115
 c12:	f4e782e3          	beq	a5,a4,b56 <vprintf+0x1e2>
      } else if(c0 == '%'){
 c16:	02500713          	li	a4,37
 c1a:	f6e787e3          	beq	a5,a4,b88 <vprintf+0x214>
        putc(fd, '%');
 c1e:	02500593          	li	a1,37
 c22:	855a                	mv	a0,s6
 c24:	c95ff0ef          	jal	8b8 <putc>
        putc(fd, c0);
 c28:	85a6                	mv	a1,s1
 c2a:	855a                	mv	a0,s6
 c2c:	c8dff0ef          	jal	8b8 <putc>
      state = 0;
 c30:	4981                	li	s3,0
 c32:	b359                	j	9b8 <vprintf+0x44>

0000000000000c34 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 c34:	715d                	addi	sp,sp,-80
 c36:	ec06                	sd	ra,24(sp)
 c38:	e822                	sd	s0,16(sp)
 c3a:	1000                	addi	s0,sp,32
 c3c:	e010                	sd	a2,0(s0)
 c3e:	e414                	sd	a3,8(s0)
 c40:	e818                	sd	a4,16(s0)
 c42:	ec1c                	sd	a5,24(s0)
 c44:	03043023          	sd	a6,32(s0)
 c48:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 c4c:	8622                	mv	a2,s0
 c4e:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 c52:	d23ff0ef          	jal	974 <vprintf>
}
 c56:	60e2                	ld	ra,24(sp)
 c58:	6442                	ld	s0,16(sp)
 c5a:	6161                	addi	sp,sp,80
 c5c:	8082                	ret

0000000000000c5e <printf>:

void
printf(const char *fmt, ...)
{
 c5e:	711d                	addi	sp,sp,-96
 c60:	ec06                	sd	ra,24(sp)
 c62:	e822                	sd	s0,16(sp)
 c64:	1000                	addi	s0,sp,32
 c66:	e40c                	sd	a1,8(s0)
 c68:	e810                	sd	a2,16(s0)
 c6a:	ec14                	sd	a3,24(s0)
 c6c:	f018                	sd	a4,32(s0)
 c6e:	f41c                	sd	a5,40(s0)
 c70:	03043823          	sd	a6,48(s0)
 c74:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 c78:	00840613          	addi	a2,s0,8
 c7c:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 c80:	85aa                	mv	a1,a0
 c82:	4505                	li	a0,1
 c84:	cf1ff0ef          	jal	974 <vprintf>
}
 c88:	60e2                	ld	ra,24(sp)
 c8a:	6442                	ld	s0,16(sp)
 c8c:	6125                	addi	sp,sp,96
 c8e:	8082                	ret

0000000000000c90 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 c90:	1141                	addi	sp,sp,-16
 c92:	e406                	sd	ra,8(sp)
 c94:	e022                	sd	s0,0(sp)
 c96:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 c98:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 c9c:	00001797          	auipc	a5,0x1
 ca0:	3747b783          	ld	a5,884(a5) # 2010 <freep>
 ca4:	a039                	j	cb2 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 ca6:	6398                	ld	a4,0(a5)
 ca8:	00e7e463          	bltu	a5,a4,cb0 <free+0x20>
 cac:	00e6ea63          	bltu	a3,a4,cc0 <free+0x30>
{
 cb0:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 cb2:	fed7fae3          	bgeu	a5,a3,ca6 <free+0x16>
 cb6:	6398                	ld	a4,0(a5)
 cb8:	00e6e463          	bltu	a3,a4,cc0 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 cbc:	fee7eae3          	bltu	a5,a4,cb0 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 cc0:	ff852583          	lw	a1,-8(a0)
 cc4:	6390                	ld	a2,0(a5)
 cc6:	02059813          	slli	a6,a1,0x20
 cca:	01c85713          	srli	a4,a6,0x1c
 cce:	9736                	add	a4,a4,a3
 cd0:	02e60563          	beq	a2,a4,cfa <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 cd4:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 cd8:	4790                	lw	a2,8(a5)
 cda:	02061593          	slli	a1,a2,0x20
 cde:	01c5d713          	srli	a4,a1,0x1c
 ce2:	973e                	add	a4,a4,a5
 ce4:	02e68263          	beq	a3,a4,d08 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 ce8:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 cea:	00001717          	auipc	a4,0x1
 cee:	32f73323          	sd	a5,806(a4) # 2010 <freep>
}
 cf2:	60a2                	ld	ra,8(sp)
 cf4:	6402                	ld	s0,0(sp)
 cf6:	0141                	addi	sp,sp,16
 cf8:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 cfa:	4618                	lw	a4,8(a2)
 cfc:	9f2d                	addw	a4,a4,a1
 cfe:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 d02:	6398                	ld	a4,0(a5)
 d04:	6310                	ld	a2,0(a4)
 d06:	b7f9                	j	cd4 <free+0x44>
    p->s.size += bp->s.size;
 d08:	ff852703          	lw	a4,-8(a0)
 d0c:	9f31                	addw	a4,a4,a2
 d0e:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 d10:	ff053683          	ld	a3,-16(a0)
 d14:	bfd1                	j	ce8 <free+0x58>

0000000000000d16 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 d16:	7139                	addi	sp,sp,-64
 d18:	fc06                	sd	ra,56(sp)
 d1a:	f822                	sd	s0,48(sp)
 d1c:	f04a                	sd	s2,32(sp)
 d1e:	ec4e                	sd	s3,24(sp)
 d20:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 d22:	02051993          	slli	s3,a0,0x20
 d26:	0209d993          	srli	s3,s3,0x20
 d2a:	09bd                	addi	s3,s3,15
 d2c:	0049d993          	srli	s3,s3,0x4
 d30:	2985                	addiw	s3,s3,1
 d32:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 d34:	00001517          	auipc	a0,0x1
 d38:	2dc53503          	ld	a0,732(a0) # 2010 <freep>
 d3c:	c905                	beqz	a0,d6c <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 d3e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 d40:	4798                	lw	a4,8(a5)
 d42:	09377663          	bgeu	a4,s3,dce <malloc+0xb8>
 d46:	f426                	sd	s1,40(sp)
 d48:	e852                	sd	s4,16(sp)
 d4a:	e456                	sd	s5,8(sp)
 d4c:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 d4e:	8a4e                	mv	s4,s3
 d50:	6705                	lui	a4,0x1
 d52:	00e9f363          	bgeu	s3,a4,d58 <malloc+0x42>
 d56:	6a05                	lui	s4,0x1
 d58:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 d5c:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 d60:	00001497          	auipc	s1,0x1
 d64:	2b048493          	addi	s1,s1,688 # 2010 <freep>
  if(p == SBRK_ERROR)
 d68:	5afd                	li	s5,-1
 d6a:	a83d                	j	da8 <malloc+0x92>
 d6c:	f426                	sd	s1,40(sp)
 d6e:	e852                	sd	s4,16(sp)
 d70:	e456                	sd	s5,8(sp)
 d72:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 d74:	00001797          	auipc	a5,0x1
 d78:	2ac78793          	addi	a5,a5,684 # 2020 <base>
 d7c:	00001717          	auipc	a4,0x1
 d80:	28f73a23          	sd	a5,660(a4) # 2010 <freep>
 d84:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 d86:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 d8a:	b7d1                	j	d4e <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 d8c:	6398                	ld	a4,0(a5)
 d8e:	e118                	sd	a4,0(a0)
 d90:	a899                	j	de6 <malloc+0xd0>
  hp->s.size = nu;
 d92:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 d96:	0541                	addi	a0,a0,16
 d98:	ef9ff0ef          	jal	c90 <free>
  return freep;
 d9c:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 d9e:	c125                	beqz	a0,dfe <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 da0:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 da2:	4798                	lw	a4,8(a5)
 da4:	03277163          	bgeu	a4,s2,dc6 <malloc+0xb0>
    if(p == freep)
 da8:	6098                	ld	a4,0(s1)
 daa:	853e                	mv	a0,a5
 dac:	fef71ae3          	bne	a4,a5,da0 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 db0:	8552                	mv	a0,s4
 db2:	9e3ff0ef          	jal	794 <sbrk>
  if(p == SBRK_ERROR)
 db6:	fd551ee3          	bne	a0,s5,d92 <malloc+0x7c>
        return 0;
 dba:	4501                	li	a0,0
 dbc:	74a2                	ld	s1,40(sp)
 dbe:	6a42                	ld	s4,16(sp)
 dc0:	6aa2                	ld	s5,8(sp)
 dc2:	6b02                	ld	s6,0(sp)
 dc4:	a03d                	j	df2 <malloc+0xdc>
 dc6:	74a2                	ld	s1,40(sp)
 dc8:	6a42                	ld	s4,16(sp)
 dca:	6aa2                	ld	s5,8(sp)
 dcc:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 dce:	fae90fe3          	beq	s2,a4,d8c <malloc+0x76>
        p->s.size -= nunits;
 dd2:	4137073b          	subw	a4,a4,s3
 dd6:	c798                	sw	a4,8(a5)
        p += p->s.size;
 dd8:	02071693          	slli	a3,a4,0x20
 ddc:	01c6d713          	srli	a4,a3,0x1c
 de0:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 de2:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 de6:	00001717          	auipc	a4,0x1
 dea:	22a73523          	sd	a0,554(a4) # 2010 <freep>
      return (void*)(p + 1);
 dee:	01078513          	addi	a0,a5,16
  }
}
 df2:	70e2                	ld	ra,56(sp)
 df4:	7442                	ld	s0,48(sp)
 df6:	7902                	ld	s2,32(sp)
 df8:	69e2                	ld	s3,24(sp)
 dfa:	6121                	addi	sp,sp,64
 dfc:	8082                	ret
 dfe:	74a2                	ld	s1,40(sp)
 e00:	6a42                	ld	s4,16(sp)
 e02:	6aa2                	ld	s5,8(sp)
 e04:	6b02                	ld	s6,0(sp)
 e06:	b7f5                	j	df2 <malloc+0xdc>
