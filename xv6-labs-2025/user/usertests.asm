
user/_usertests:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <copyinstr1>:
}

// what if you pass ridiculous string pointers to system calls?
void
copyinstr1(char *s)
{
       0:	711d                	addi	sp,sp,-96
       2:	ec86                	sd	ra,88(sp)
       4:	e8a2                	sd	s0,80(sp)
       6:	e4a6                	sd	s1,72(sp)
       8:	e0ca                	sd	s2,64(sp)
       a:	fc4e                	sd	s3,56(sp)
       c:	f852                	sd	s4,48(sp)
       e:	1080                	addi	s0,sp,96
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
      10:	00008797          	auipc	a5,0x8
      14:	97878793          	addi	a5,a5,-1672 # 7988 <malloc+0x2586>
      18:	638c                	ld	a1,0(a5)
      1a:	6790                	ld	a2,8(a5)
      1c:	6b94                	ld	a3,16(a5)
      1e:	6f98                	ld	a4,24(a5)
      20:	fab43423          	sd	a1,-88(s0)
      24:	fac43823          	sd	a2,-80(s0)
      28:	fad43c23          	sd	a3,-72(s0)
      2c:	fce43023          	sd	a4,-64(s0)
      30:	739c                	ld	a5,32(a5)
      32:	fcf43423          	sd	a5,-56(s0)
                     0xffffffffffffffff };

  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      36:	fa840493          	addi	s1,s0,-88
      3a:	fd040a13          	addi	s4,s0,-48
    uint64 addr = addrs[ai];

    int fd = open((char *)addr, O_CREATE|O_WRONLY);
      3e:	20100993          	li	s3,513
      42:	0004b903          	ld	s2,0(s1)
      46:	85ce                	mv	a1,s3
      48:	854a                	mv	a0,s2
      4a:	6f3040ef          	jal	4f3c <open>
    if(fd >= 0){
      4e:	00055d63          	bgez	a0,68 <copyinstr1+0x68>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
      52:	04a1                	addi	s1,s1,8
      54:	ff4497e3          	bne	s1,s4,42 <copyinstr1+0x42>
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      exit(1);
    }
  }
}
      58:	60e6                	ld	ra,88(sp)
      5a:	6446                	ld	s0,80(sp)
      5c:	64a6                	ld	s1,72(sp)
      5e:	6906                	ld	s2,64(sp)
      60:	79e2                	ld	s3,56(sp)
      62:	7a42                	ld	s4,48(sp)
      64:	6125                	addi	sp,sp,96
      66:	8082                	ret
      printf("open(%p) returned %d, not -1\n", (void*)addr, fd);
      68:	862a                	mv	a2,a0
      6a:	85ca                	mv	a1,s2
      6c:	00005517          	auipc	a0,0x5
      70:	49450513          	addi	a0,a0,1172 # 5500 <malloc+0xfe>
      74:	2d6050ef          	jal	534a <printf>
      exit(1);
      78:	4505                	li	a0,1
      7a:	683040ef          	jal	4efc <exit>

000000000000007e <bsstest>:
void
bsstest(char *s)
{
  int i;

  for(i = 0; i < sizeof(uninit); i++){
      7e:	00009797          	auipc	a5,0x9
      82:	51a78793          	addi	a5,a5,1306 # 9598 <uninit>
      86:	0000c697          	auipc	a3,0xc
      8a:	c2268693          	addi	a3,a3,-990 # bca8 <buf>
    if(uninit[i] != '\0'){
      8e:	0007c703          	lbu	a4,0(a5)
      92:	e709                	bnez	a4,9c <bsstest+0x1e>
  for(i = 0; i < sizeof(uninit); i++){
      94:	0785                	addi	a5,a5,1
      96:	fed79ce3          	bne	a5,a3,8e <bsstest+0x10>
      9a:	8082                	ret
{
      9c:	1141                	addi	sp,sp,-16
      9e:	e406                	sd	ra,8(sp)
      a0:	e022                	sd	s0,0(sp)
      a2:	0800                	addi	s0,sp,16
      printf("%s: bss test failed\n", s);
      a4:	85aa                	mv	a1,a0
      a6:	00005517          	auipc	a0,0x5
      aa:	47a50513          	addi	a0,a0,1146 # 5520 <malloc+0x11e>
      ae:	29c050ef          	jal	534a <printf>
      exit(1);
      b2:	4505                	li	a0,1
      b4:	649040ef          	jal	4efc <exit>

00000000000000b8 <opentest>:
{
      b8:	1101                	addi	sp,sp,-32
      ba:	ec06                	sd	ra,24(sp)
      bc:	e822                	sd	s0,16(sp)
      be:	e426                	sd	s1,8(sp)
      c0:	1000                	addi	s0,sp,32
      c2:	84aa                	mv	s1,a0
  fd = open("echo", 0);
      c4:	4581                	li	a1,0
      c6:	00005517          	auipc	a0,0x5
      ca:	47250513          	addi	a0,a0,1138 # 5538 <malloc+0x136>
      ce:	66f040ef          	jal	4f3c <open>
  if(fd < 0){
      d2:	02054263          	bltz	a0,f6 <opentest+0x3e>
  close(fd);
      d6:	64f040ef          	jal	4f24 <close>
  fd = open("doesnotexist", 0);
      da:	4581                	li	a1,0
      dc:	00005517          	auipc	a0,0x5
      e0:	47c50513          	addi	a0,a0,1148 # 5558 <malloc+0x156>
      e4:	659040ef          	jal	4f3c <open>
  if(fd >= 0){
      e8:	02055163          	bgez	a0,10a <opentest+0x52>
}
      ec:	60e2                	ld	ra,24(sp)
      ee:	6442                	ld	s0,16(sp)
      f0:	64a2                	ld	s1,8(sp)
      f2:	6105                	addi	sp,sp,32
      f4:	8082                	ret
    printf("%s: open echo failed!\n", s);
      f6:	85a6                	mv	a1,s1
      f8:	00005517          	auipc	a0,0x5
      fc:	44850513          	addi	a0,a0,1096 # 5540 <malloc+0x13e>
     100:	24a050ef          	jal	534a <printf>
    exit(1);
     104:	4505                	li	a0,1
     106:	5f7040ef          	jal	4efc <exit>
    printf("%s: open doesnotexist succeeded!\n", s);
     10a:	85a6                	mv	a1,s1
     10c:	00005517          	auipc	a0,0x5
     110:	45c50513          	addi	a0,a0,1116 # 5568 <malloc+0x166>
     114:	236050ef          	jal	534a <printf>
    exit(1);
     118:	4505                	li	a0,1
     11a:	5e3040ef          	jal	4efc <exit>

000000000000011e <truncate2>:
{
     11e:	7179                	addi	sp,sp,-48
     120:	f406                	sd	ra,40(sp)
     122:	f022                	sd	s0,32(sp)
     124:	ec26                	sd	s1,24(sp)
     126:	e84a                	sd	s2,16(sp)
     128:	e44e                	sd	s3,8(sp)
     12a:	1800                	addi	s0,sp,48
     12c:	89aa                	mv	s3,a0
  unlink("truncfile");
     12e:	00005517          	auipc	a0,0x5
     132:	46250513          	addi	a0,a0,1122 # 5590 <malloc+0x18e>
     136:	617040ef          	jal	4f4c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_TRUNC|O_WRONLY);
     13a:	60100593          	li	a1,1537
     13e:	00005517          	auipc	a0,0x5
     142:	45250513          	addi	a0,a0,1106 # 5590 <malloc+0x18e>
     146:	5f7040ef          	jal	4f3c <open>
     14a:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     14c:	4611                	li	a2,4
     14e:	00005597          	auipc	a1,0x5
     152:	45258593          	addi	a1,a1,1106 # 55a0 <malloc+0x19e>
     156:	5c7040ef          	jal	4f1c <write>
  int fd2 = open("truncfile", O_TRUNC|O_WRONLY);
     15a:	40100593          	li	a1,1025
     15e:	00005517          	auipc	a0,0x5
     162:	43250513          	addi	a0,a0,1074 # 5590 <malloc+0x18e>
     166:	5d7040ef          	jal	4f3c <open>
     16a:	892a                	mv	s2,a0
  int n = write(fd1, "x", 1);
     16c:	4605                	li	a2,1
     16e:	00005597          	auipc	a1,0x5
     172:	43a58593          	addi	a1,a1,1082 # 55a8 <malloc+0x1a6>
     176:	8526                	mv	a0,s1
     178:	5a5040ef          	jal	4f1c <write>
  if(n != -1){
     17c:	57fd                	li	a5,-1
     17e:	02f51563          	bne	a0,a5,1a8 <truncate2+0x8a>
  unlink("truncfile");
     182:	00005517          	auipc	a0,0x5
     186:	40e50513          	addi	a0,a0,1038 # 5590 <malloc+0x18e>
     18a:	5c3040ef          	jal	4f4c <unlink>
  close(fd1);
     18e:	8526                	mv	a0,s1
     190:	595040ef          	jal	4f24 <close>
  close(fd2);
     194:	854a                	mv	a0,s2
     196:	58f040ef          	jal	4f24 <close>
}
     19a:	70a2                	ld	ra,40(sp)
     19c:	7402                	ld	s0,32(sp)
     19e:	64e2                	ld	s1,24(sp)
     1a0:	6942                	ld	s2,16(sp)
     1a2:	69a2                	ld	s3,8(sp)
     1a4:	6145                	addi	sp,sp,48
     1a6:	8082                	ret
    printf("%s: write returned %d, expected -1\n", s, n);
     1a8:	862a                	mv	a2,a0
     1aa:	85ce                	mv	a1,s3
     1ac:	00005517          	auipc	a0,0x5
     1b0:	40450513          	addi	a0,a0,1028 # 55b0 <malloc+0x1ae>
     1b4:	196050ef          	jal	534a <printf>
    exit(1);
     1b8:	4505                	li	a0,1
     1ba:	543040ef          	jal	4efc <exit>

00000000000001be <createtest>:
{
     1be:	7139                	addi	sp,sp,-64
     1c0:	fc06                	sd	ra,56(sp)
     1c2:	f822                	sd	s0,48(sp)
     1c4:	f426                	sd	s1,40(sp)
     1c6:	f04a                	sd	s2,32(sp)
     1c8:	ec4e                	sd	s3,24(sp)
     1ca:	e852                	sd	s4,16(sp)
     1cc:	0080                	addi	s0,sp,64
  name[0] = 'a';
     1ce:	06100793          	li	a5,97
     1d2:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     1d6:	fc040523          	sb	zero,-54(s0)
     1da:	03000493          	li	s1,48
    fd = open(name, O_CREATE|O_RDWR);
     1de:	fc840a13          	addi	s4,s0,-56
     1e2:	20200993          	li	s3,514
  for(i = 0; i < N; i++){
     1e6:	06400913          	li	s2,100
    name[1] = '0' + i;
     1ea:	fc9404a3          	sb	s1,-55(s0)
    fd = open(name, O_CREATE|O_RDWR);
     1ee:	85ce                	mv	a1,s3
     1f0:	8552                	mv	a0,s4
     1f2:	54b040ef          	jal	4f3c <open>
    close(fd);
     1f6:	52f040ef          	jal	4f24 <close>
  for(i = 0; i < N; i++){
     1fa:	2485                	addiw	s1,s1,1
     1fc:	0ff4f493          	zext.b	s1,s1
     200:	ff2495e3          	bne	s1,s2,1ea <createtest+0x2c>
  name[0] = 'a';
     204:	06100793          	li	a5,97
     208:	fcf40423          	sb	a5,-56(s0)
  name[2] = '\0';
     20c:	fc040523          	sb	zero,-54(s0)
     210:	03000493          	li	s1,48
    unlink(name);
     214:	fc840993          	addi	s3,s0,-56
  for(i = 0; i < N; i++){
     218:	06400913          	li	s2,100
    name[1] = '0' + i;
     21c:	fc9404a3          	sb	s1,-55(s0)
    unlink(name);
     220:	854e                	mv	a0,s3
     222:	52b040ef          	jal	4f4c <unlink>
  for(i = 0; i < N; i++){
     226:	2485                	addiw	s1,s1,1
     228:	0ff4f493          	zext.b	s1,s1
     22c:	ff2498e3          	bne	s1,s2,21c <createtest+0x5e>
}
     230:	70e2                	ld	ra,56(sp)
     232:	7442                	ld	s0,48(sp)
     234:	74a2                	ld	s1,40(sp)
     236:	7902                	ld	s2,32(sp)
     238:	69e2                	ld	s3,24(sp)
     23a:	6a42                	ld	s4,16(sp)
     23c:	6121                	addi	sp,sp,64
     23e:	8082                	ret

0000000000000240 <bigwrite>:
{
     240:	711d                	addi	sp,sp,-96
     242:	ec86                	sd	ra,88(sp)
     244:	e8a2                	sd	s0,80(sp)
     246:	e4a6                	sd	s1,72(sp)
     248:	e0ca                	sd	s2,64(sp)
     24a:	fc4e                	sd	s3,56(sp)
     24c:	f852                	sd	s4,48(sp)
     24e:	f456                	sd	s5,40(sp)
     250:	f05a                	sd	s6,32(sp)
     252:	ec5e                	sd	s7,24(sp)
     254:	e862                	sd	s8,16(sp)
     256:	e466                	sd	s9,8(sp)
     258:	1080                	addi	s0,sp,96
     25a:	8caa                	mv	s9,a0
  unlink("bigwrite");
     25c:	00005517          	auipc	a0,0x5
     260:	37c50513          	addi	a0,a0,892 # 55d8 <malloc+0x1d6>
     264:	4e9040ef          	jal	4f4c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     268:	1f300493          	li	s1,499
    fd = open("bigwrite", O_CREATE | O_RDWR);
     26c:	20200b93          	li	s7,514
     270:	00005a17          	auipc	s4,0x5
     274:	368a0a13          	addi	s4,s4,872 # 55d8 <malloc+0x1d6>
     278:	4b09                	li	s6,2
      int cc = write(fd, buf, sz);
     27a:	0000c997          	auipc	s3,0xc
     27e:	a2e98993          	addi	s3,s3,-1490 # bca8 <buf>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     282:	6a8d                	lui	s5,0x3
     284:	1c9a8a93          	addi	s5,s5,457 # 31c9 <subdir+0x4c3>
    fd = open("bigwrite", O_CREATE | O_RDWR);
     288:	85de                	mv	a1,s7
     28a:	8552                	mv	a0,s4
     28c:	4b1040ef          	jal	4f3c <open>
     290:	892a                	mv	s2,a0
    if(fd < 0){
     292:	04054463          	bltz	a0,2da <bigwrite+0x9a>
     296:	8c5a                	mv	s8,s6
      int cc = write(fd, buf, sz);
     298:	8626                	mv	a2,s1
     29a:	85ce                	mv	a1,s3
     29c:	854a                	mv	a0,s2
     29e:	47f040ef          	jal	4f1c <write>
      if(cc != sz){
     2a2:	04951663          	bne	a0,s1,2ee <bigwrite+0xae>
    for(i = 0; i < 2; i++){
     2a6:	3c7d                	addiw	s8,s8,-1
     2a8:	fe0c18e3          	bnez	s8,298 <bigwrite+0x58>
    close(fd);
     2ac:	854a                	mv	a0,s2
     2ae:	477040ef          	jal	4f24 <close>
    unlink("bigwrite");
     2b2:	8552                	mv	a0,s4
     2b4:	499040ef          	jal	4f4c <unlink>
  for(sz = 499; sz < (MAXOPBLOCKS+2)*BSIZE; sz += 471){
     2b8:	1d74849b          	addiw	s1,s1,471
     2bc:	fd5496e3          	bne	s1,s5,288 <bigwrite+0x48>
}
     2c0:	60e6                	ld	ra,88(sp)
     2c2:	6446                	ld	s0,80(sp)
     2c4:	64a6                	ld	s1,72(sp)
     2c6:	6906                	ld	s2,64(sp)
     2c8:	79e2                	ld	s3,56(sp)
     2ca:	7a42                	ld	s4,48(sp)
     2cc:	7aa2                	ld	s5,40(sp)
     2ce:	7b02                	ld	s6,32(sp)
     2d0:	6be2                	ld	s7,24(sp)
     2d2:	6c42                	ld	s8,16(sp)
     2d4:	6ca2                	ld	s9,8(sp)
     2d6:	6125                	addi	sp,sp,96
     2d8:	8082                	ret
      printf("%s: cannot create bigwrite\n", s);
     2da:	85e6                	mv	a1,s9
     2dc:	00005517          	auipc	a0,0x5
     2e0:	30c50513          	addi	a0,a0,780 # 55e8 <malloc+0x1e6>
     2e4:	066050ef          	jal	534a <printf>
      exit(1);
     2e8:	4505                	li	a0,1
     2ea:	413040ef          	jal	4efc <exit>
        printf("%s: write(%d) ret %d\n", s, sz, cc);
     2ee:	86aa                	mv	a3,a0
     2f0:	8626                	mv	a2,s1
     2f2:	85e6                	mv	a1,s9
     2f4:	00005517          	auipc	a0,0x5
     2f8:	31450513          	addi	a0,a0,788 # 5608 <malloc+0x206>
     2fc:	04e050ef          	jal	534a <printf>
        exit(1);
     300:	4505                	li	a0,1
     302:	3fb040ef          	jal	4efc <exit>

0000000000000306 <badwrite>:
// file is deleted? if the kernel has this bug, it will panic: balloc:
// out of blocks. assumed_free may need to be raised to be more than
// the number of free blocks. this test takes a long time.
void
badwrite(char *s)
{
     306:	7139                	addi	sp,sp,-64
     308:	fc06                	sd	ra,56(sp)
     30a:	f822                	sd	s0,48(sp)
     30c:	f426                	sd	s1,40(sp)
     30e:	f04a                	sd	s2,32(sp)
     310:	ec4e                	sd	s3,24(sp)
     312:	e852                	sd	s4,16(sp)
     314:	e456                	sd	s5,8(sp)
     316:	e05a                	sd	s6,0(sp)
     318:	0080                	addi	s0,sp,64
  int assumed_free = 600;
  
  unlink("junk");
     31a:	00005517          	auipc	a0,0x5
     31e:	30650513          	addi	a0,a0,774 # 5620 <malloc+0x21e>
     322:	42b040ef          	jal	4f4c <unlink>
     326:	25800913          	li	s2,600
  for(int i = 0; i < assumed_free; i++){
    int fd = open("junk", O_CREATE|O_WRONLY);
     32a:	20100a93          	li	s5,513
     32e:	00005997          	auipc	s3,0x5
     332:	2f298993          	addi	s3,s3,754 # 5620 <malloc+0x21e>
    if(fd < 0){
      printf("open junk failed\n");
      exit(1);
    }
    write(fd, (char*)0xffffffffffL, 1);
     336:	4b05                	li	s6,1
     338:	5a7d                	li	s4,-1
     33a:	018a5a13          	srli	s4,s4,0x18
    int fd = open("junk", O_CREATE|O_WRONLY);
     33e:	85d6                	mv	a1,s5
     340:	854e                	mv	a0,s3
     342:	3fb040ef          	jal	4f3c <open>
     346:	84aa                	mv	s1,a0
    if(fd < 0){
     348:	04054d63          	bltz	a0,3a2 <badwrite+0x9c>
    write(fd, (char*)0xffffffffffL, 1);
     34c:	865a                	mv	a2,s6
     34e:	85d2                	mv	a1,s4
     350:	3cd040ef          	jal	4f1c <write>
    close(fd);
     354:	8526                	mv	a0,s1
     356:	3cf040ef          	jal	4f24 <close>
    unlink("junk");
     35a:	854e                	mv	a0,s3
     35c:	3f1040ef          	jal	4f4c <unlink>
  for(int i = 0; i < assumed_free; i++){
     360:	397d                	addiw	s2,s2,-1
     362:	fc091ee3          	bnez	s2,33e <badwrite+0x38>
  }

  int fd = open("junk", O_CREATE|O_WRONLY);
     366:	20100593          	li	a1,513
     36a:	00005517          	auipc	a0,0x5
     36e:	2b650513          	addi	a0,a0,694 # 5620 <malloc+0x21e>
     372:	3cb040ef          	jal	4f3c <open>
     376:	84aa                	mv	s1,a0
  if(fd < 0){
     378:	02054e63          	bltz	a0,3b4 <badwrite+0xae>
    printf("open junk failed\n");
    exit(1);
  }
  if(write(fd, "x", 1) != 1){
     37c:	4605                	li	a2,1
     37e:	00005597          	auipc	a1,0x5
     382:	22a58593          	addi	a1,a1,554 # 55a8 <malloc+0x1a6>
     386:	397040ef          	jal	4f1c <write>
     38a:	4785                	li	a5,1
     38c:	02f50d63          	beq	a0,a5,3c6 <badwrite+0xc0>
    printf("write failed\n");
     390:	00005517          	auipc	a0,0x5
     394:	2b050513          	addi	a0,a0,688 # 5640 <malloc+0x23e>
     398:	7b3040ef          	jal	534a <printf>
    exit(1);
     39c:	4505                	li	a0,1
     39e:	35f040ef          	jal	4efc <exit>
      printf("open junk failed\n");
     3a2:	00005517          	auipc	a0,0x5
     3a6:	28650513          	addi	a0,a0,646 # 5628 <malloc+0x226>
     3aa:	7a1040ef          	jal	534a <printf>
      exit(1);
     3ae:	4505                	li	a0,1
     3b0:	34d040ef          	jal	4efc <exit>
    printf("open junk failed\n");
     3b4:	00005517          	auipc	a0,0x5
     3b8:	27450513          	addi	a0,a0,628 # 5628 <malloc+0x226>
     3bc:	78f040ef          	jal	534a <printf>
    exit(1);
     3c0:	4505                	li	a0,1
     3c2:	33b040ef          	jal	4efc <exit>
  }
  close(fd);
     3c6:	8526                	mv	a0,s1
     3c8:	35d040ef          	jal	4f24 <close>
  unlink("junk");
     3cc:	00005517          	auipc	a0,0x5
     3d0:	25450513          	addi	a0,a0,596 # 5620 <malloc+0x21e>
     3d4:	379040ef          	jal	4f4c <unlink>

  exit(0);
     3d8:	4501                	li	a0,0
     3da:	323040ef          	jal	4efc <exit>

00000000000003de <outofinodes>:
  }
}

void
outofinodes(char *s)
{
     3de:	711d                	addi	sp,sp,-96
     3e0:	ec86                	sd	ra,88(sp)
     3e2:	e8a2                	sd	s0,80(sp)
     3e4:	e4a6                	sd	s1,72(sp)
     3e6:	e0ca                	sd	s2,64(sp)
     3e8:	fc4e                	sd	s3,56(sp)
     3ea:	f852                	sd	s4,48(sp)
     3ec:	f456                	sd	s5,40(sp)
     3ee:	1080                	addi	s0,sp,96
  int nzz = 32*32;
  for(int i = 0; i < nzz; i++){
     3f0:	4481                	li	s1,0
    char name[32];
    name[0] = 'z';
     3f2:	07a00993          	li	s3,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     3f6:	fa040913          	addi	s2,s0,-96
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     3fa:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
     3fe:	40000a93          	li	s5,1024
    name[0] = 'z';
     402:	fb340023          	sb	s3,-96(s0)
    name[1] = 'z';
     406:	fb3400a3          	sb	s3,-95(s0)
    name[2] = '0' + (i / 32);
     40a:	41f4d71b          	sraiw	a4,s1,0x1f
     40e:	01b7571b          	srliw	a4,a4,0x1b
     412:	009707bb          	addw	a5,a4,s1
     416:	4057d69b          	sraiw	a3,a5,0x5
     41a:	0306869b          	addiw	a3,a3,48
     41e:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     422:	8bfd                	andi	a5,a5,31
     424:	9f99                	subw	a5,a5,a4
     426:	0307879b          	addiw	a5,a5,48
     42a:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     42e:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     432:	854a                	mv	a0,s2
     434:	319040ef          	jal	4f4c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
     438:	85d2                	mv	a1,s4
     43a:	854a                	mv	a0,s2
     43c:	301040ef          	jal	4f3c <open>
    if(fd < 0){
     440:	00054763          	bltz	a0,44e <outofinodes+0x70>
      // failure is eventually expected.
      break;
    }
    close(fd);
     444:	2e1040ef          	jal	4f24 <close>
  for(int i = 0; i < nzz; i++){
     448:	2485                	addiw	s1,s1,1
     44a:	fb549ce3          	bne	s1,s5,402 <outofinodes+0x24>
     44e:	4481                	li	s1,0
  }

  for(int i = 0; i < nzz; i++){
    char name[32];
    name[0] = 'z';
     450:	07a00913          	li	s2,122
    name[1] = 'z';
    name[2] = '0' + (i / 32);
    name[3] = '0' + (i % 32);
    name[4] = '\0';
    unlink(name);
     454:	fa040a13          	addi	s4,s0,-96
  for(int i = 0; i < nzz; i++){
     458:	40000993          	li	s3,1024
    name[0] = 'z';
     45c:	fb240023          	sb	s2,-96(s0)
    name[1] = 'z';
     460:	fb2400a3          	sb	s2,-95(s0)
    name[2] = '0' + (i / 32);
     464:	41f4d71b          	sraiw	a4,s1,0x1f
     468:	01b7571b          	srliw	a4,a4,0x1b
     46c:	009707bb          	addw	a5,a4,s1
     470:	4057d69b          	sraiw	a3,a5,0x5
     474:	0306869b          	addiw	a3,a3,48
     478:	fad40123          	sb	a3,-94(s0)
    name[3] = '0' + (i % 32);
     47c:	8bfd                	andi	a5,a5,31
     47e:	9f99                	subw	a5,a5,a4
     480:	0307879b          	addiw	a5,a5,48
     484:	faf401a3          	sb	a5,-93(s0)
    name[4] = '\0';
     488:	fa040223          	sb	zero,-92(s0)
    unlink(name);
     48c:	8552                	mv	a0,s4
     48e:	2bf040ef          	jal	4f4c <unlink>
  for(int i = 0; i < nzz; i++){
     492:	2485                	addiw	s1,s1,1
     494:	fd3494e3          	bne	s1,s3,45c <outofinodes+0x7e>
  }
}
     498:	60e6                	ld	ra,88(sp)
     49a:	6446                	ld	s0,80(sp)
     49c:	64a6                	ld	s1,72(sp)
     49e:	6906                	ld	s2,64(sp)
     4a0:	79e2                	ld	s3,56(sp)
     4a2:	7a42                	ld	s4,48(sp)
     4a4:	7aa2                	ld	s5,40(sp)
     4a6:	6125                	addi	sp,sp,96
     4a8:	8082                	ret

00000000000004aa <copyin>:
{
     4aa:	7175                	addi	sp,sp,-144
     4ac:	e506                	sd	ra,136(sp)
     4ae:	e122                	sd	s0,128(sp)
     4b0:	fca6                	sd	s1,120(sp)
     4b2:	f8ca                	sd	s2,112(sp)
     4b4:	f4ce                	sd	s3,104(sp)
     4b6:	f0d2                	sd	s4,96(sp)
     4b8:	ecd6                	sd	s5,88(sp)
     4ba:	e8da                	sd	s6,80(sp)
     4bc:	e4de                	sd	s7,72(sp)
     4be:	e0e2                	sd	s8,64(sp)
     4c0:	fc66                	sd	s9,56(sp)
     4c2:	0900                	addi	s0,sp,144
  uint64 addrs[] = { 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     4c4:	00007797          	auipc	a5,0x7
     4c8:	4c478793          	addi	a5,a5,1220 # 7988 <malloc+0x2586>
     4cc:	638c                	ld	a1,0(a5)
     4ce:	6790                	ld	a2,8(a5)
     4d0:	6b94                	ld	a3,16(a5)
     4d2:	6f98                	ld	a4,24(a5)
     4d4:	f6b43c23          	sd	a1,-136(s0)
     4d8:	f8c43023          	sd	a2,-128(s0)
     4dc:	f8d43423          	sd	a3,-120(s0)
     4e0:	f8e43823          	sd	a4,-112(s0)
     4e4:	739c                	ld	a5,32(a5)
     4e6:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     4ea:	f7840913          	addi	s2,s0,-136
     4ee:	fa040c93          	addi	s9,s0,-96
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     4f2:	20100b13          	li	s6,513
     4f6:	00005a97          	auipc	s5,0x5
     4fa:	15aa8a93          	addi	s5,s5,346 # 5650 <malloc+0x24e>
    int n = write(fd, (void*)addr, 8192);
     4fe:	6a09                	lui	s4,0x2
    n = write(1, (char*)addr, 8192);
     500:	4c05                	li	s8,1
    if(pipe(fds) < 0){
     502:	f7040b93          	addi	s7,s0,-144
    uint64 addr = addrs[ai];
     506:	00093983          	ld	s3,0(s2)
    int fd = open("copyin1", O_CREATE|O_WRONLY);
     50a:	85da                	mv	a1,s6
     50c:	8556                	mv	a0,s5
     50e:	22f040ef          	jal	4f3c <open>
     512:	84aa                	mv	s1,a0
    if(fd < 0){
     514:	06054a63          	bltz	a0,588 <copyin+0xde>
    int n = write(fd, (void*)addr, 8192);
     518:	8652                	mv	a2,s4
     51a:	85ce                	mv	a1,s3
     51c:	201040ef          	jal	4f1c <write>
    if(n >= 0){
     520:	06055d63          	bgez	a0,59a <copyin+0xf0>
    close(fd);
     524:	8526                	mv	a0,s1
     526:	1ff040ef          	jal	4f24 <close>
    unlink("copyin1");
     52a:	8556                	mv	a0,s5
     52c:	221040ef          	jal	4f4c <unlink>
    n = write(1, (char*)addr, 8192);
     530:	8652                	mv	a2,s4
     532:	85ce                	mv	a1,s3
     534:	8562                	mv	a0,s8
     536:	1e7040ef          	jal	4f1c <write>
    if(n > 0){
     53a:	06a04b63          	bgtz	a0,5b0 <copyin+0x106>
    if(pipe(fds) < 0){
     53e:	855e                	mv	a0,s7
     540:	1cd040ef          	jal	4f0c <pipe>
     544:	08054163          	bltz	a0,5c6 <copyin+0x11c>
    n = write(fds[1], (char*)addr, 8192);
     548:	8652                	mv	a2,s4
     54a:	85ce                	mv	a1,s3
     54c:	f7442503          	lw	a0,-140(s0)
     550:	1cd040ef          	jal	4f1c <write>
    if(n > 0){
     554:	08a04263          	bgtz	a0,5d8 <copyin+0x12e>
    close(fds[0]);
     558:	f7042503          	lw	a0,-144(s0)
     55c:	1c9040ef          	jal	4f24 <close>
    close(fds[1]);
     560:	f7442503          	lw	a0,-140(s0)
     564:	1c1040ef          	jal	4f24 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     568:	0921                	addi	s2,s2,8
     56a:	f9991ee3          	bne	s2,s9,506 <copyin+0x5c>
}
     56e:	60aa                	ld	ra,136(sp)
     570:	640a                	ld	s0,128(sp)
     572:	74e6                	ld	s1,120(sp)
     574:	7946                	ld	s2,112(sp)
     576:	79a6                	ld	s3,104(sp)
     578:	7a06                	ld	s4,96(sp)
     57a:	6ae6                	ld	s5,88(sp)
     57c:	6b46                	ld	s6,80(sp)
     57e:	6ba6                	ld	s7,72(sp)
     580:	6c06                	ld	s8,64(sp)
     582:	7ce2                	ld	s9,56(sp)
     584:	6149                	addi	sp,sp,144
     586:	8082                	ret
      printf("open(copyin1) failed\n");
     588:	00005517          	auipc	a0,0x5
     58c:	0d050513          	addi	a0,a0,208 # 5658 <malloc+0x256>
     590:	5bb040ef          	jal	534a <printf>
      exit(1);
     594:	4505                	li	a0,1
     596:	167040ef          	jal	4efc <exit>
      printf("write(fd, %p, 8192) returned %d, not -1\n", (void*)addr, n);
     59a:	862a                	mv	a2,a0
     59c:	85ce                	mv	a1,s3
     59e:	00005517          	auipc	a0,0x5
     5a2:	0d250513          	addi	a0,a0,210 # 5670 <malloc+0x26e>
     5a6:	5a5040ef          	jal	534a <printf>
      exit(1);
     5aa:	4505                	li	a0,1
     5ac:	151040ef          	jal	4efc <exit>
      printf("write(1, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5b0:	862a                	mv	a2,a0
     5b2:	85ce                	mv	a1,s3
     5b4:	00005517          	auipc	a0,0x5
     5b8:	0ec50513          	addi	a0,a0,236 # 56a0 <malloc+0x29e>
     5bc:	58f040ef          	jal	534a <printf>
      exit(1);
     5c0:	4505                	li	a0,1
     5c2:	13b040ef          	jal	4efc <exit>
      printf("pipe() failed\n");
     5c6:	00005517          	auipc	a0,0x5
     5ca:	10a50513          	addi	a0,a0,266 # 56d0 <malloc+0x2ce>
     5ce:	57d040ef          	jal	534a <printf>
      exit(1);
     5d2:	4505                	li	a0,1
     5d4:	129040ef          	jal	4efc <exit>
      printf("write(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     5d8:	862a                	mv	a2,a0
     5da:	85ce                	mv	a1,s3
     5dc:	00005517          	auipc	a0,0x5
     5e0:	10450513          	addi	a0,a0,260 # 56e0 <malloc+0x2de>
     5e4:	567040ef          	jal	534a <printf>
      exit(1);
     5e8:	4505                	li	a0,1
     5ea:	113040ef          	jal	4efc <exit>

00000000000005ee <copyout>:
{
     5ee:	7135                	addi	sp,sp,-160
     5f0:	ed06                	sd	ra,152(sp)
     5f2:	e922                	sd	s0,144(sp)
     5f4:	e526                	sd	s1,136(sp)
     5f6:	e14a                	sd	s2,128(sp)
     5f8:	fcce                	sd	s3,120(sp)
     5fa:	f8d2                	sd	s4,112(sp)
     5fc:	f4d6                	sd	s5,104(sp)
     5fe:	f0da                	sd	s6,96(sp)
     600:	ecde                	sd	s7,88(sp)
     602:	e8e2                	sd	s8,80(sp)
     604:	e4e6                	sd	s9,72(sp)
     606:	1100                	addi	s0,sp,160
  uint64 addrs[] = { 0LL, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
     608:	00007797          	auipc	a5,0x7
     60c:	38078793          	addi	a5,a5,896 # 7988 <malloc+0x2586>
     610:	7788                	ld	a0,40(a5)
     612:	7b8c                	ld	a1,48(a5)
     614:	7f90                	ld	a2,56(a5)
     616:	63b4                	ld	a3,64(a5)
     618:	67b8                	ld	a4,72(a5)
     61a:	f6a43823          	sd	a0,-144(s0)
     61e:	f6b43c23          	sd	a1,-136(s0)
     622:	f8c43023          	sd	a2,-128(s0)
     626:	f8d43423          	sd	a3,-120(s0)
     62a:	f8e43823          	sd	a4,-112(s0)
     62e:	6bbc                	ld	a5,80(a5)
     630:	f8f43c23          	sd	a5,-104(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     634:	f7040913          	addi	s2,s0,-144
     638:	fa040c93          	addi	s9,s0,-96
    int fd = open("README", 0);
     63c:	00005b17          	auipc	s6,0x5
     640:	0d4b0b13          	addi	s6,s6,212 # 5710 <malloc+0x30e>
    int n = read(fd, (void*)addr, 8192);
     644:	6a89                	lui	s5,0x2
    if(pipe(fds) < 0){
     646:	f6840c13          	addi	s8,s0,-152
    n = write(fds[1], "x", 1);
     64a:	4a05                	li	s4,1
     64c:	00005b97          	auipc	s7,0x5
     650:	f5cb8b93          	addi	s7,s7,-164 # 55a8 <malloc+0x1a6>
    uint64 addr = addrs[ai];
     654:	00093983          	ld	s3,0(s2)
    int fd = open("README", 0);
     658:	4581                	li	a1,0
     65a:	855a                	mv	a0,s6
     65c:	0e1040ef          	jal	4f3c <open>
     660:	84aa                	mv	s1,a0
    if(fd < 0){
     662:	06054863          	bltz	a0,6d2 <copyout+0xe4>
    int n = read(fd, (void*)addr, 8192);
     666:	8656                	mv	a2,s5
     668:	85ce                	mv	a1,s3
     66a:	0ab040ef          	jal	4f14 <read>
    if(n > 0){
     66e:	06a04b63          	bgtz	a0,6e4 <copyout+0xf6>
    close(fd);
     672:	8526                	mv	a0,s1
     674:	0b1040ef          	jal	4f24 <close>
    if(pipe(fds) < 0){
     678:	8562                	mv	a0,s8
     67a:	093040ef          	jal	4f0c <pipe>
     67e:	06054e63          	bltz	a0,6fa <copyout+0x10c>
    n = write(fds[1], "x", 1);
     682:	8652                	mv	a2,s4
     684:	85de                	mv	a1,s7
     686:	f6c42503          	lw	a0,-148(s0)
     68a:	093040ef          	jal	4f1c <write>
    if(n != 1){
     68e:	07451f63          	bne	a0,s4,70c <copyout+0x11e>
    n = read(fds[0], (void*)addr, 8192);
     692:	8656                	mv	a2,s5
     694:	85ce                	mv	a1,s3
     696:	f6842503          	lw	a0,-152(s0)
     69a:	07b040ef          	jal	4f14 <read>
    if(n > 0){
     69e:	08a04063          	bgtz	a0,71e <copyout+0x130>
    close(fds[0]);
     6a2:	f6842503          	lw	a0,-152(s0)
     6a6:	07f040ef          	jal	4f24 <close>
    close(fds[1]);
     6aa:	f6c42503          	lw	a0,-148(s0)
     6ae:	077040ef          	jal	4f24 <close>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
     6b2:	0921                	addi	s2,s2,8
     6b4:	fb9910e3          	bne	s2,s9,654 <copyout+0x66>
}
     6b8:	60ea                	ld	ra,152(sp)
     6ba:	644a                	ld	s0,144(sp)
     6bc:	64aa                	ld	s1,136(sp)
     6be:	690a                	ld	s2,128(sp)
     6c0:	79e6                	ld	s3,120(sp)
     6c2:	7a46                	ld	s4,112(sp)
     6c4:	7aa6                	ld	s5,104(sp)
     6c6:	7b06                	ld	s6,96(sp)
     6c8:	6be6                	ld	s7,88(sp)
     6ca:	6c46                	ld	s8,80(sp)
     6cc:	6ca6                	ld	s9,72(sp)
     6ce:	610d                	addi	sp,sp,160
     6d0:	8082                	ret
      printf("open(README) failed\n");
     6d2:	00005517          	auipc	a0,0x5
     6d6:	04650513          	addi	a0,a0,70 # 5718 <malloc+0x316>
     6da:	471040ef          	jal	534a <printf>
      exit(1);
     6de:	4505                	li	a0,1
     6e0:	01d040ef          	jal	4efc <exit>
      printf("read(fd, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     6e4:	862a                	mv	a2,a0
     6e6:	85ce                	mv	a1,s3
     6e8:	00005517          	auipc	a0,0x5
     6ec:	04850513          	addi	a0,a0,72 # 5730 <malloc+0x32e>
     6f0:	45b040ef          	jal	534a <printf>
      exit(1);
     6f4:	4505                	li	a0,1
     6f6:	007040ef          	jal	4efc <exit>
      printf("pipe() failed\n");
     6fa:	00005517          	auipc	a0,0x5
     6fe:	fd650513          	addi	a0,a0,-42 # 56d0 <malloc+0x2ce>
     702:	449040ef          	jal	534a <printf>
      exit(1);
     706:	4505                	li	a0,1
     708:	7f4040ef          	jal	4efc <exit>
      printf("pipe write failed\n");
     70c:	00005517          	auipc	a0,0x5
     710:	05450513          	addi	a0,a0,84 # 5760 <malloc+0x35e>
     714:	437040ef          	jal	534a <printf>
      exit(1);
     718:	4505                	li	a0,1
     71a:	7e2040ef          	jal	4efc <exit>
      printf("read(pipe, %p, 8192) returned %d, not -1 or 0\n", (void*)addr, n);
     71e:	862a                	mv	a2,a0
     720:	85ce                	mv	a1,s3
     722:	00005517          	auipc	a0,0x5
     726:	05650513          	addi	a0,a0,86 # 5778 <malloc+0x376>
     72a:	421040ef          	jal	534a <printf>
      exit(1);
     72e:	4505                	li	a0,1
     730:	7cc040ef          	jal	4efc <exit>

0000000000000734 <truncate1>:
{
     734:	711d                	addi	sp,sp,-96
     736:	ec86                	sd	ra,88(sp)
     738:	e8a2                	sd	s0,80(sp)
     73a:	e4a6                	sd	s1,72(sp)
     73c:	e0ca                	sd	s2,64(sp)
     73e:	fc4e                	sd	s3,56(sp)
     740:	f852                	sd	s4,48(sp)
     742:	f456                	sd	s5,40(sp)
     744:	1080                	addi	s0,sp,96
     746:	8a2a                	mv	s4,a0
  unlink("truncfile");
     748:	00005517          	auipc	a0,0x5
     74c:	e4850513          	addi	a0,a0,-440 # 5590 <malloc+0x18e>
     750:	7fc040ef          	jal	4f4c <unlink>
  int fd1 = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
     754:	60100593          	li	a1,1537
     758:	00005517          	auipc	a0,0x5
     75c:	e3850513          	addi	a0,a0,-456 # 5590 <malloc+0x18e>
     760:	7dc040ef          	jal	4f3c <open>
     764:	84aa                	mv	s1,a0
  write(fd1, "abcd", 4);
     766:	4611                	li	a2,4
     768:	00005597          	auipc	a1,0x5
     76c:	e3858593          	addi	a1,a1,-456 # 55a0 <malloc+0x19e>
     770:	7ac040ef          	jal	4f1c <write>
  close(fd1);
     774:	8526                	mv	a0,s1
     776:	7ae040ef          	jal	4f24 <close>
  int fd2 = open("truncfile", O_RDONLY);
     77a:	4581                	li	a1,0
     77c:	00005517          	auipc	a0,0x5
     780:	e1450513          	addi	a0,a0,-492 # 5590 <malloc+0x18e>
     784:	7b8040ef          	jal	4f3c <open>
     788:	84aa                	mv	s1,a0
  int n = read(fd2, buf, sizeof(buf));
     78a:	02000613          	li	a2,32
     78e:	fa040593          	addi	a1,s0,-96
     792:	782040ef          	jal	4f14 <read>
  if(n != 4){
     796:	4791                	li	a5,4
     798:	0af51863          	bne	a0,a5,848 <truncate1+0x114>
  fd1 = open("truncfile", O_WRONLY|O_TRUNC);
     79c:	40100593          	li	a1,1025
     7a0:	00005517          	auipc	a0,0x5
     7a4:	df050513          	addi	a0,a0,-528 # 5590 <malloc+0x18e>
     7a8:	794040ef          	jal	4f3c <open>
     7ac:	89aa                	mv	s3,a0
  int fd3 = open("truncfile", O_RDONLY);
     7ae:	4581                	li	a1,0
     7b0:	00005517          	auipc	a0,0x5
     7b4:	de050513          	addi	a0,a0,-544 # 5590 <malloc+0x18e>
     7b8:	784040ef          	jal	4f3c <open>
     7bc:	892a                	mv	s2,a0
  n = read(fd3, buf, sizeof(buf));
     7be:	02000613          	li	a2,32
     7c2:	fa040593          	addi	a1,s0,-96
     7c6:	74e040ef          	jal	4f14 <read>
     7ca:	8aaa                	mv	s5,a0
  if(n != 0){
     7cc:	e949                	bnez	a0,85e <truncate1+0x12a>
  n = read(fd2, buf, sizeof(buf));
     7ce:	02000613          	li	a2,32
     7d2:	fa040593          	addi	a1,s0,-96
     7d6:	8526                	mv	a0,s1
     7d8:	73c040ef          	jal	4f14 <read>
     7dc:	8aaa                	mv	s5,a0
  if(n != 0){
     7de:	e155                	bnez	a0,882 <truncate1+0x14e>
  write(fd1, "abcdef", 6);
     7e0:	4619                	li	a2,6
     7e2:	00005597          	auipc	a1,0x5
     7e6:	02658593          	addi	a1,a1,38 # 5808 <malloc+0x406>
     7ea:	854e                	mv	a0,s3
     7ec:	730040ef          	jal	4f1c <write>
  n = read(fd3, buf, sizeof(buf));
     7f0:	02000613          	li	a2,32
     7f4:	fa040593          	addi	a1,s0,-96
     7f8:	854a                	mv	a0,s2
     7fa:	71a040ef          	jal	4f14 <read>
  if(n != 6){
     7fe:	4799                	li	a5,6
     800:	0af51363          	bne	a0,a5,8a6 <truncate1+0x172>
  n = read(fd2, buf, sizeof(buf));
     804:	02000613          	li	a2,32
     808:	fa040593          	addi	a1,s0,-96
     80c:	8526                	mv	a0,s1
     80e:	706040ef          	jal	4f14 <read>
  if(n != 2){
     812:	4789                	li	a5,2
     814:	0af51463          	bne	a0,a5,8bc <truncate1+0x188>
  unlink("truncfile");
     818:	00005517          	auipc	a0,0x5
     81c:	d7850513          	addi	a0,a0,-648 # 5590 <malloc+0x18e>
     820:	72c040ef          	jal	4f4c <unlink>
  close(fd1);
     824:	854e                	mv	a0,s3
     826:	6fe040ef          	jal	4f24 <close>
  close(fd2);
     82a:	8526                	mv	a0,s1
     82c:	6f8040ef          	jal	4f24 <close>
  close(fd3);
     830:	854a                	mv	a0,s2
     832:	6f2040ef          	jal	4f24 <close>
}
     836:	60e6                	ld	ra,88(sp)
     838:	6446                	ld	s0,80(sp)
     83a:	64a6                	ld	s1,72(sp)
     83c:	6906                	ld	s2,64(sp)
     83e:	79e2                	ld	s3,56(sp)
     840:	7a42                	ld	s4,48(sp)
     842:	7aa2                	ld	s5,40(sp)
     844:	6125                	addi	sp,sp,96
     846:	8082                	ret
    printf("%s: read %d bytes, wanted 4\n", s, n);
     848:	862a                	mv	a2,a0
     84a:	85d2                	mv	a1,s4
     84c:	00005517          	auipc	a0,0x5
     850:	f5c50513          	addi	a0,a0,-164 # 57a8 <malloc+0x3a6>
     854:	2f7040ef          	jal	534a <printf>
    exit(1);
     858:	4505                	li	a0,1
     85a:	6a2040ef          	jal	4efc <exit>
    printf("aaa fd3=%d\n", fd3);
     85e:	85ca                	mv	a1,s2
     860:	00005517          	auipc	a0,0x5
     864:	f6850513          	addi	a0,a0,-152 # 57c8 <malloc+0x3c6>
     868:	2e3040ef          	jal	534a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     86c:	8656                	mv	a2,s5
     86e:	85d2                	mv	a1,s4
     870:	00005517          	auipc	a0,0x5
     874:	f6850513          	addi	a0,a0,-152 # 57d8 <malloc+0x3d6>
     878:	2d3040ef          	jal	534a <printf>
    exit(1);
     87c:	4505                	li	a0,1
     87e:	67e040ef          	jal	4efc <exit>
    printf("bbb fd2=%d\n", fd2);
     882:	85a6                	mv	a1,s1
     884:	00005517          	auipc	a0,0x5
     888:	f7450513          	addi	a0,a0,-140 # 57f8 <malloc+0x3f6>
     88c:	2bf040ef          	jal	534a <printf>
    printf("%s: read %d bytes, wanted 0\n", s, n);
     890:	8656                	mv	a2,s5
     892:	85d2                	mv	a1,s4
     894:	00005517          	auipc	a0,0x5
     898:	f4450513          	addi	a0,a0,-188 # 57d8 <malloc+0x3d6>
     89c:	2af040ef          	jal	534a <printf>
    exit(1);
     8a0:	4505                	li	a0,1
     8a2:	65a040ef          	jal	4efc <exit>
    printf("%s: read %d bytes, wanted 6\n", s, n);
     8a6:	862a                	mv	a2,a0
     8a8:	85d2                	mv	a1,s4
     8aa:	00005517          	auipc	a0,0x5
     8ae:	f6650513          	addi	a0,a0,-154 # 5810 <malloc+0x40e>
     8b2:	299040ef          	jal	534a <printf>
    exit(1);
     8b6:	4505                	li	a0,1
     8b8:	644040ef          	jal	4efc <exit>
    printf("%s: read %d bytes, wanted 2\n", s, n);
     8bc:	862a                	mv	a2,a0
     8be:	85d2                	mv	a1,s4
     8c0:	00005517          	auipc	a0,0x5
     8c4:	f7050513          	addi	a0,a0,-144 # 5830 <malloc+0x42e>
     8c8:	283040ef          	jal	534a <printf>
    exit(1);
     8cc:	4505                	li	a0,1
     8ce:	62e040ef          	jal	4efc <exit>

00000000000008d2 <writetest>:
{
     8d2:	715d                	addi	sp,sp,-80
     8d4:	e486                	sd	ra,72(sp)
     8d6:	e0a2                	sd	s0,64(sp)
     8d8:	fc26                	sd	s1,56(sp)
     8da:	f84a                	sd	s2,48(sp)
     8dc:	f44e                	sd	s3,40(sp)
     8de:	f052                	sd	s4,32(sp)
     8e0:	ec56                	sd	s5,24(sp)
     8e2:	e85a                	sd	s6,16(sp)
     8e4:	e45e                	sd	s7,8(sp)
     8e6:	0880                	addi	s0,sp,80
     8e8:	8baa                	mv	s7,a0
  fd = open("small", O_CREATE|O_RDWR);
     8ea:	20200593          	li	a1,514
     8ee:	00005517          	auipc	a0,0x5
     8f2:	f6250513          	addi	a0,a0,-158 # 5850 <malloc+0x44e>
     8f6:	646040ef          	jal	4f3c <open>
  if(fd < 0){
     8fa:	08054f63          	bltz	a0,998 <writetest+0xc6>
     8fe:	89aa                	mv	s3,a0
     900:	4901                	li	s2,0
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     902:	44a9                	li	s1,10
     904:	00005a17          	auipc	s4,0x5
     908:	f74a0a13          	addi	s4,s4,-140 # 5878 <malloc+0x476>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     90c:	00005b17          	auipc	s6,0x5
     910:	fa4b0b13          	addi	s6,s6,-92 # 58b0 <malloc+0x4ae>
  for(i = 0; i < N; i++){
     914:	06400a93          	li	s5,100
    if(write(fd, "aaaaaaaaaa", SZ) != SZ){
     918:	8626                	mv	a2,s1
     91a:	85d2                	mv	a1,s4
     91c:	854e                	mv	a0,s3
     91e:	5fe040ef          	jal	4f1c <write>
     922:	08951563          	bne	a0,s1,9ac <writetest+0xda>
    if(write(fd, "bbbbbbbbbb", SZ) != SZ){
     926:	8626                	mv	a2,s1
     928:	85da                	mv	a1,s6
     92a:	854e                	mv	a0,s3
     92c:	5f0040ef          	jal	4f1c <write>
     930:	08951963          	bne	a0,s1,9c2 <writetest+0xf0>
  for(i = 0; i < N; i++){
     934:	2905                	addiw	s2,s2,1
     936:	ff5911e3          	bne	s2,s5,918 <writetest+0x46>
  close(fd);
     93a:	854e                	mv	a0,s3
     93c:	5e8040ef          	jal	4f24 <close>
  fd = open("small", O_RDONLY);
     940:	4581                	li	a1,0
     942:	00005517          	auipc	a0,0x5
     946:	f0e50513          	addi	a0,a0,-242 # 5850 <malloc+0x44e>
     94a:	5f2040ef          	jal	4f3c <open>
     94e:	84aa                	mv	s1,a0
  if(fd < 0){
     950:	08054463          	bltz	a0,9d8 <writetest+0x106>
  i = read(fd, buf, N*SZ*2);
     954:	7d000613          	li	a2,2000
     958:	0000b597          	auipc	a1,0xb
     95c:	35058593          	addi	a1,a1,848 # bca8 <buf>
     960:	5b4040ef          	jal	4f14 <read>
  if(i != N*SZ*2){
     964:	7d000793          	li	a5,2000
     968:	08f51263          	bne	a0,a5,9ec <writetest+0x11a>
  close(fd);
     96c:	8526                	mv	a0,s1
     96e:	5b6040ef          	jal	4f24 <close>
  if(unlink("small") < 0){
     972:	00005517          	auipc	a0,0x5
     976:	ede50513          	addi	a0,a0,-290 # 5850 <malloc+0x44e>
     97a:	5d2040ef          	jal	4f4c <unlink>
     97e:	08054163          	bltz	a0,a00 <writetest+0x12e>
}
     982:	60a6                	ld	ra,72(sp)
     984:	6406                	ld	s0,64(sp)
     986:	74e2                	ld	s1,56(sp)
     988:	7942                	ld	s2,48(sp)
     98a:	79a2                	ld	s3,40(sp)
     98c:	7a02                	ld	s4,32(sp)
     98e:	6ae2                	ld	s5,24(sp)
     990:	6b42                	ld	s6,16(sp)
     992:	6ba2                	ld	s7,8(sp)
     994:	6161                	addi	sp,sp,80
     996:	8082                	ret
    printf("%s: error: creat small failed!\n", s);
     998:	85de                	mv	a1,s7
     99a:	00005517          	auipc	a0,0x5
     99e:	ebe50513          	addi	a0,a0,-322 # 5858 <malloc+0x456>
     9a2:	1a9040ef          	jal	534a <printf>
    exit(1);
     9a6:	4505                	li	a0,1
     9a8:	554040ef          	jal	4efc <exit>
      printf("%s: error: write aa %d new file failed\n", s, i);
     9ac:	864a                	mv	a2,s2
     9ae:	85de                	mv	a1,s7
     9b0:	00005517          	auipc	a0,0x5
     9b4:	ed850513          	addi	a0,a0,-296 # 5888 <malloc+0x486>
     9b8:	193040ef          	jal	534a <printf>
      exit(1);
     9bc:	4505                	li	a0,1
     9be:	53e040ef          	jal	4efc <exit>
      printf("%s: error: write bb %d new file failed\n", s, i);
     9c2:	864a                	mv	a2,s2
     9c4:	85de                	mv	a1,s7
     9c6:	00005517          	auipc	a0,0x5
     9ca:	efa50513          	addi	a0,a0,-262 # 58c0 <malloc+0x4be>
     9ce:	17d040ef          	jal	534a <printf>
      exit(1);
     9d2:	4505                	li	a0,1
     9d4:	528040ef          	jal	4efc <exit>
    printf("%s: error: open small failed!\n", s);
     9d8:	85de                	mv	a1,s7
     9da:	00005517          	auipc	a0,0x5
     9de:	f0e50513          	addi	a0,a0,-242 # 58e8 <malloc+0x4e6>
     9e2:	169040ef          	jal	534a <printf>
    exit(1);
     9e6:	4505                	li	a0,1
     9e8:	514040ef          	jal	4efc <exit>
    printf("%s: read failed\n", s);
     9ec:	85de                	mv	a1,s7
     9ee:	00005517          	auipc	a0,0x5
     9f2:	f1a50513          	addi	a0,a0,-230 # 5908 <malloc+0x506>
     9f6:	155040ef          	jal	534a <printf>
    exit(1);
     9fa:	4505                	li	a0,1
     9fc:	500040ef          	jal	4efc <exit>
    printf("%s: unlink small failed\n", s);
     a00:	85de                	mv	a1,s7
     a02:	00005517          	auipc	a0,0x5
     a06:	f1e50513          	addi	a0,a0,-226 # 5920 <malloc+0x51e>
     a0a:	141040ef          	jal	534a <printf>
    exit(1);
     a0e:	4505                	li	a0,1
     a10:	4ec040ef          	jal	4efc <exit>

0000000000000a14 <writebig>:
{
     a14:	7139                	addi	sp,sp,-64
     a16:	fc06                	sd	ra,56(sp)
     a18:	f822                	sd	s0,48(sp)
     a1a:	f426                	sd	s1,40(sp)
     a1c:	f04a                	sd	s2,32(sp)
     a1e:	ec4e                	sd	s3,24(sp)
     a20:	e852                	sd	s4,16(sp)
     a22:	e456                	sd	s5,8(sp)
     a24:	e05a                	sd	s6,0(sp)
     a26:	0080                	addi	s0,sp,64
     a28:	8b2a                	mv	s6,a0
  fd = open("big", O_CREATE|O_RDWR);
     a2a:	20200593          	li	a1,514
     a2e:	00005517          	auipc	a0,0x5
     a32:	f1250513          	addi	a0,a0,-238 # 5940 <malloc+0x53e>
     a36:	506040ef          	jal	4f3c <open>
  if(fd < 0){
     a3a:	06054b63          	bltz	a0,ab0 <writebig+0x9c>
     a3e:	8a2a                	mv	s4,a0
     a40:	4481                	li	s1,0
    ((int*)buf)[0] = i;
     a42:	0000b997          	auipc	s3,0xb
     a46:	26698993          	addi	s3,s3,614 # bca8 <buf>
    if(write(fd, buf, BSIZE) != BSIZE){
     a4a:	40000913          	li	s2,1024
  for(i = 0; i < MAXFILE; i++){
     a4e:	6ac1                	lui	s5,0x10
     a50:	10ba8a93          	addi	s5,s5,267 # 1010b <base+0x1463>
    ((int*)buf)[0] = i;
     a54:	0099a023          	sw	s1,0(s3)
    if(write(fd, buf, BSIZE) != BSIZE){
     a58:	864a                	mv	a2,s2
     a5a:	85ce                	mv	a1,s3
     a5c:	8552                	mv	a0,s4
     a5e:	4be040ef          	jal	4f1c <write>
     a62:	07251163          	bne	a0,s2,ac4 <writebig+0xb0>
  for(i = 0; i < MAXFILE; i++){
     a66:	2485                	addiw	s1,s1,1
     a68:	ff5496e3          	bne	s1,s5,a54 <writebig+0x40>
  close(fd);
     a6c:	8552                	mv	a0,s4
     a6e:	4b6040ef          	jal	4f24 <close>
  fd = open("big", O_RDONLY);
     a72:	4581                	li	a1,0
     a74:	00005517          	auipc	a0,0x5
     a78:	ecc50513          	addi	a0,a0,-308 # 5940 <malloc+0x53e>
     a7c:	4c0040ef          	jal	4f3c <open>
     a80:	8a2a                	mv	s4,a0
  n = 0;
     a82:	4481                	li	s1,0
    i = read(fd, buf, BSIZE);
     a84:	40000993          	li	s3,1024
     a88:	0000b917          	auipc	s2,0xb
     a8c:	22090913          	addi	s2,s2,544 # bca8 <buf>
  if(fd < 0){
     a90:	04054563          	bltz	a0,ada <writebig+0xc6>
    i = read(fd, buf, BSIZE);
     a94:	864e                	mv	a2,s3
     a96:	85ca                	mv	a1,s2
     a98:	8552                	mv	a0,s4
     a9a:	47a040ef          	jal	4f14 <read>
    if(i == 0){
     a9e:	c921                	beqz	a0,aee <writebig+0xda>
    } else if(i != BSIZE){
     aa0:	09351c63          	bne	a0,s3,b38 <writebig+0x124>
    if(((int*)buf)[0] != n){
     aa4:	00092683          	lw	a3,0(s2)
     aa8:	0a969363          	bne	a3,s1,b4e <writebig+0x13a>
    n++;
     aac:	2485                	addiw	s1,s1,1
    i = read(fd, buf, BSIZE);
     aae:	b7dd                	j	a94 <writebig+0x80>
    printf("%s: error: creat big failed!\n", s);
     ab0:	85da                	mv	a1,s6
     ab2:	00005517          	auipc	a0,0x5
     ab6:	e9650513          	addi	a0,a0,-362 # 5948 <malloc+0x546>
     aba:	091040ef          	jal	534a <printf>
    exit(1);
     abe:	4505                	li	a0,1
     ac0:	43c040ef          	jal	4efc <exit>
      printf("%s: error: write big file failed i=%d\n", s, i);
     ac4:	8626                	mv	a2,s1
     ac6:	85da                	mv	a1,s6
     ac8:	00005517          	auipc	a0,0x5
     acc:	ea050513          	addi	a0,a0,-352 # 5968 <malloc+0x566>
     ad0:	07b040ef          	jal	534a <printf>
      exit(1);
     ad4:	4505                	li	a0,1
     ad6:	426040ef          	jal	4efc <exit>
    printf("%s: error: open big failed!\n", s);
     ada:	85da                	mv	a1,s6
     adc:	00005517          	auipc	a0,0x5
     ae0:	eb450513          	addi	a0,a0,-332 # 5990 <malloc+0x58e>
     ae4:	067040ef          	jal	534a <printf>
    exit(1);
     ae8:	4505                	li	a0,1
     aea:	412040ef          	jal	4efc <exit>
      if(n != MAXFILE){
     aee:	67c1                	lui	a5,0x10
     af0:	10b78793          	addi	a5,a5,267 # 1010b <base+0x1463>
     af4:	02f49763          	bne	s1,a5,b22 <writebig+0x10e>
  close(fd);
     af8:	8552                	mv	a0,s4
     afa:	42a040ef          	jal	4f24 <close>
  if(unlink("big") < 0){
     afe:	00005517          	auipc	a0,0x5
     b02:	e4250513          	addi	a0,a0,-446 # 5940 <malloc+0x53e>
     b06:	446040ef          	jal	4f4c <unlink>
     b0a:	04054d63          	bltz	a0,b64 <writebig+0x150>
}
     b0e:	70e2                	ld	ra,56(sp)
     b10:	7442                	ld	s0,48(sp)
     b12:	74a2                	ld	s1,40(sp)
     b14:	7902                	ld	s2,32(sp)
     b16:	69e2                	ld	s3,24(sp)
     b18:	6a42                	ld	s4,16(sp)
     b1a:	6aa2                	ld	s5,8(sp)
     b1c:	6b02                	ld	s6,0(sp)
     b1e:	6121                	addi	sp,sp,64
     b20:	8082                	ret
        printf("%s: read only %d blocks from big", s, n);
     b22:	8626                	mv	a2,s1
     b24:	85da                	mv	a1,s6
     b26:	00005517          	auipc	a0,0x5
     b2a:	e8a50513          	addi	a0,a0,-374 # 59b0 <malloc+0x5ae>
     b2e:	01d040ef          	jal	534a <printf>
        exit(1);
     b32:	4505                	li	a0,1
     b34:	3c8040ef          	jal	4efc <exit>
      printf("%s: read failed %d\n", s, i);
     b38:	862a                	mv	a2,a0
     b3a:	85da                	mv	a1,s6
     b3c:	00005517          	auipc	a0,0x5
     b40:	e9c50513          	addi	a0,a0,-356 # 59d8 <malloc+0x5d6>
     b44:	007040ef          	jal	534a <printf>
      exit(1);
     b48:	4505                	li	a0,1
     b4a:	3b2040ef          	jal	4efc <exit>
      printf("%s: read content of block %d is %d\n", s,
     b4e:	8626                	mv	a2,s1
     b50:	85da                	mv	a1,s6
     b52:	00005517          	auipc	a0,0x5
     b56:	e9e50513          	addi	a0,a0,-354 # 59f0 <malloc+0x5ee>
     b5a:	7f0040ef          	jal	534a <printf>
      exit(1);
     b5e:	4505                	li	a0,1
     b60:	39c040ef          	jal	4efc <exit>
    printf("%s: unlink big failed\n", s);
     b64:	85da                	mv	a1,s6
     b66:	00005517          	auipc	a0,0x5
     b6a:	eb250513          	addi	a0,a0,-334 # 5a18 <malloc+0x616>
     b6e:	7dc040ef          	jal	534a <printf>
    exit(1);
     b72:	4505                	li	a0,1
     b74:	388040ef          	jal	4efc <exit>

0000000000000b78 <unlinkread>:
{
     b78:	7179                	addi	sp,sp,-48
     b7a:	f406                	sd	ra,40(sp)
     b7c:	f022                	sd	s0,32(sp)
     b7e:	ec26                	sd	s1,24(sp)
     b80:	e84a                	sd	s2,16(sp)
     b82:	e44e                	sd	s3,8(sp)
     b84:	1800                	addi	s0,sp,48
     b86:	89aa                	mv	s3,a0
  fd = open("unlinkread", O_CREATE | O_RDWR);
     b88:	20200593          	li	a1,514
     b8c:	00005517          	auipc	a0,0x5
     b90:	ea450513          	addi	a0,a0,-348 # 5a30 <malloc+0x62e>
     b94:	3a8040ef          	jal	4f3c <open>
  if(fd < 0){
     b98:	0a054f63          	bltz	a0,c56 <unlinkread+0xde>
     b9c:	84aa                	mv	s1,a0
  write(fd, "hello", SZ);
     b9e:	4615                	li	a2,5
     ba0:	00005597          	auipc	a1,0x5
     ba4:	ec058593          	addi	a1,a1,-320 # 5a60 <malloc+0x65e>
     ba8:	374040ef          	jal	4f1c <write>
  close(fd);
     bac:	8526                	mv	a0,s1
     bae:	376040ef          	jal	4f24 <close>
  fd = open("unlinkread", O_RDWR);
     bb2:	4589                	li	a1,2
     bb4:	00005517          	auipc	a0,0x5
     bb8:	e7c50513          	addi	a0,a0,-388 # 5a30 <malloc+0x62e>
     bbc:	380040ef          	jal	4f3c <open>
     bc0:	84aa                	mv	s1,a0
  if(fd < 0){
     bc2:	0a054463          	bltz	a0,c6a <unlinkread+0xf2>
  if(unlink("unlinkread") != 0){
     bc6:	00005517          	auipc	a0,0x5
     bca:	e6a50513          	addi	a0,a0,-406 # 5a30 <malloc+0x62e>
     bce:	37e040ef          	jal	4f4c <unlink>
     bd2:	e555                	bnez	a0,c7e <unlinkread+0x106>
  fd1 = open("unlinkread", O_CREATE | O_RDWR);
     bd4:	20200593          	li	a1,514
     bd8:	00005517          	auipc	a0,0x5
     bdc:	e5850513          	addi	a0,a0,-424 # 5a30 <malloc+0x62e>
     be0:	35c040ef          	jal	4f3c <open>
     be4:	892a                	mv	s2,a0
  write(fd1, "yyy", 3);
     be6:	460d                	li	a2,3
     be8:	00005597          	auipc	a1,0x5
     bec:	ec058593          	addi	a1,a1,-320 # 5aa8 <malloc+0x6a6>
     bf0:	32c040ef          	jal	4f1c <write>
  close(fd1);
     bf4:	854a                	mv	a0,s2
     bf6:	32e040ef          	jal	4f24 <close>
  if(read(fd, buf, sizeof(buf)) != SZ){
     bfa:	660d                	lui	a2,0x3
     bfc:	0000b597          	auipc	a1,0xb
     c00:	0ac58593          	addi	a1,a1,172 # bca8 <buf>
     c04:	8526                	mv	a0,s1
     c06:	30e040ef          	jal	4f14 <read>
     c0a:	4795                	li	a5,5
     c0c:	08f51363          	bne	a0,a5,c92 <unlinkread+0x11a>
  if(buf[0] != 'h'){
     c10:	0000b717          	auipc	a4,0xb
     c14:	09874703          	lbu	a4,152(a4) # bca8 <buf>
     c18:	06800793          	li	a5,104
     c1c:	08f71563          	bne	a4,a5,ca6 <unlinkread+0x12e>
  if(write(fd, buf, 10) != 10){
     c20:	4629                	li	a2,10
     c22:	0000b597          	auipc	a1,0xb
     c26:	08658593          	addi	a1,a1,134 # bca8 <buf>
     c2a:	8526                	mv	a0,s1
     c2c:	2f0040ef          	jal	4f1c <write>
     c30:	47a9                	li	a5,10
     c32:	08f51463          	bne	a0,a5,cba <unlinkread+0x142>
  close(fd);
     c36:	8526                	mv	a0,s1
     c38:	2ec040ef          	jal	4f24 <close>
  unlink("unlinkread");
     c3c:	00005517          	auipc	a0,0x5
     c40:	df450513          	addi	a0,a0,-524 # 5a30 <malloc+0x62e>
     c44:	308040ef          	jal	4f4c <unlink>
}
     c48:	70a2                	ld	ra,40(sp)
     c4a:	7402                	ld	s0,32(sp)
     c4c:	64e2                	ld	s1,24(sp)
     c4e:	6942                	ld	s2,16(sp)
     c50:	69a2                	ld	s3,8(sp)
     c52:	6145                	addi	sp,sp,48
     c54:	8082                	ret
    printf("%s: create unlinkread failed\n", s);
     c56:	85ce                	mv	a1,s3
     c58:	00005517          	auipc	a0,0x5
     c5c:	de850513          	addi	a0,a0,-536 # 5a40 <malloc+0x63e>
     c60:	6ea040ef          	jal	534a <printf>
    exit(1);
     c64:	4505                	li	a0,1
     c66:	296040ef          	jal	4efc <exit>
    printf("%s: open unlinkread failed\n", s);
     c6a:	85ce                	mv	a1,s3
     c6c:	00005517          	auipc	a0,0x5
     c70:	dfc50513          	addi	a0,a0,-516 # 5a68 <malloc+0x666>
     c74:	6d6040ef          	jal	534a <printf>
    exit(1);
     c78:	4505                	li	a0,1
     c7a:	282040ef          	jal	4efc <exit>
    printf("%s: unlink unlinkread failed\n", s);
     c7e:	85ce                	mv	a1,s3
     c80:	00005517          	auipc	a0,0x5
     c84:	e0850513          	addi	a0,a0,-504 # 5a88 <malloc+0x686>
     c88:	6c2040ef          	jal	534a <printf>
    exit(1);
     c8c:	4505                	li	a0,1
     c8e:	26e040ef          	jal	4efc <exit>
    printf("%s: unlinkread read failed", s);
     c92:	85ce                	mv	a1,s3
     c94:	00005517          	auipc	a0,0x5
     c98:	e1c50513          	addi	a0,a0,-484 # 5ab0 <malloc+0x6ae>
     c9c:	6ae040ef          	jal	534a <printf>
    exit(1);
     ca0:	4505                	li	a0,1
     ca2:	25a040ef          	jal	4efc <exit>
    printf("%s: unlinkread wrong data\n", s);
     ca6:	85ce                	mv	a1,s3
     ca8:	00005517          	auipc	a0,0x5
     cac:	e2850513          	addi	a0,a0,-472 # 5ad0 <malloc+0x6ce>
     cb0:	69a040ef          	jal	534a <printf>
    exit(1);
     cb4:	4505                	li	a0,1
     cb6:	246040ef          	jal	4efc <exit>
    printf("%s: unlinkread write failed\n", s);
     cba:	85ce                	mv	a1,s3
     cbc:	00005517          	auipc	a0,0x5
     cc0:	e3450513          	addi	a0,a0,-460 # 5af0 <malloc+0x6ee>
     cc4:	686040ef          	jal	534a <printf>
    exit(1);
     cc8:	4505                	li	a0,1
     cca:	232040ef          	jal	4efc <exit>

0000000000000cce <linktest>:
{
     cce:	1101                	addi	sp,sp,-32
     cd0:	ec06                	sd	ra,24(sp)
     cd2:	e822                	sd	s0,16(sp)
     cd4:	e426                	sd	s1,8(sp)
     cd6:	e04a                	sd	s2,0(sp)
     cd8:	1000                	addi	s0,sp,32
     cda:	892a                	mv	s2,a0
  unlink("lf1");
     cdc:	00005517          	auipc	a0,0x5
     ce0:	e3450513          	addi	a0,a0,-460 # 5b10 <malloc+0x70e>
     ce4:	268040ef          	jal	4f4c <unlink>
  unlink("lf2");
     ce8:	00005517          	auipc	a0,0x5
     cec:	e3050513          	addi	a0,a0,-464 # 5b18 <malloc+0x716>
     cf0:	25c040ef          	jal	4f4c <unlink>
  fd = open("lf1", O_CREATE|O_RDWR);
     cf4:	20200593          	li	a1,514
     cf8:	00005517          	auipc	a0,0x5
     cfc:	e1850513          	addi	a0,a0,-488 # 5b10 <malloc+0x70e>
     d00:	23c040ef          	jal	4f3c <open>
  if(fd < 0){
     d04:	0c054f63          	bltz	a0,de2 <linktest+0x114>
     d08:	84aa                	mv	s1,a0
  if(write(fd, "hello", SZ) != SZ){
     d0a:	4615                	li	a2,5
     d0c:	00005597          	auipc	a1,0x5
     d10:	d5458593          	addi	a1,a1,-684 # 5a60 <malloc+0x65e>
     d14:	208040ef          	jal	4f1c <write>
     d18:	4795                	li	a5,5
     d1a:	0cf51e63          	bne	a0,a5,df6 <linktest+0x128>
  close(fd);
     d1e:	8526                	mv	a0,s1
     d20:	204040ef          	jal	4f24 <close>
  if(link("lf1", "lf2") < 0){
     d24:	00005597          	auipc	a1,0x5
     d28:	df458593          	addi	a1,a1,-524 # 5b18 <malloc+0x716>
     d2c:	00005517          	auipc	a0,0x5
     d30:	de450513          	addi	a0,a0,-540 # 5b10 <malloc+0x70e>
     d34:	228040ef          	jal	4f5c <link>
     d38:	0c054963          	bltz	a0,e0a <linktest+0x13c>
  unlink("lf1");
     d3c:	00005517          	auipc	a0,0x5
     d40:	dd450513          	addi	a0,a0,-556 # 5b10 <malloc+0x70e>
     d44:	208040ef          	jal	4f4c <unlink>
  if(open("lf1", 0) >= 0){
     d48:	4581                	li	a1,0
     d4a:	00005517          	auipc	a0,0x5
     d4e:	dc650513          	addi	a0,a0,-570 # 5b10 <malloc+0x70e>
     d52:	1ea040ef          	jal	4f3c <open>
     d56:	0c055463          	bgez	a0,e1e <linktest+0x150>
  fd = open("lf2", 0);
     d5a:	4581                	li	a1,0
     d5c:	00005517          	auipc	a0,0x5
     d60:	dbc50513          	addi	a0,a0,-580 # 5b18 <malloc+0x716>
     d64:	1d8040ef          	jal	4f3c <open>
     d68:	84aa                	mv	s1,a0
  if(fd < 0){
     d6a:	0c054463          	bltz	a0,e32 <linktest+0x164>
  if(read(fd, buf, sizeof(buf)) != SZ){
     d6e:	660d                	lui	a2,0x3
     d70:	0000b597          	auipc	a1,0xb
     d74:	f3858593          	addi	a1,a1,-200 # bca8 <buf>
     d78:	19c040ef          	jal	4f14 <read>
     d7c:	4795                	li	a5,5
     d7e:	0cf51463          	bne	a0,a5,e46 <linktest+0x178>
  close(fd);
     d82:	8526                	mv	a0,s1
     d84:	1a0040ef          	jal	4f24 <close>
  if(link("lf2", "lf2") >= 0){
     d88:	00005597          	auipc	a1,0x5
     d8c:	d9058593          	addi	a1,a1,-624 # 5b18 <malloc+0x716>
     d90:	852e                	mv	a0,a1
     d92:	1ca040ef          	jal	4f5c <link>
     d96:	0c055263          	bgez	a0,e5a <linktest+0x18c>
  unlink("lf2");
     d9a:	00005517          	auipc	a0,0x5
     d9e:	d7e50513          	addi	a0,a0,-642 # 5b18 <malloc+0x716>
     da2:	1aa040ef          	jal	4f4c <unlink>
  if(link("lf2", "lf1") >= 0){
     da6:	00005597          	auipc	a1,0x5
     daa:	d6a58593          	addi	a1,a1,-662 # 5b10 <malloc+0x70e>
     dae:	00005517          	auipc	a0,0x5
     db2:	d6a50513          	addi	a0,a0,-662 # 5b18 <malloc+0x716>
     db6:	1a6040ef          	jal	4f5c <link>
     dba:	0a055a63          	bgez	a0,e6e <linktest+0x1a0>
  if(link(".", "lf1") >= 0){
     dbe:	00005597          	auipc	a1,0x5
     dc2:	d5258593          	addi	a1,a1,-686 # 5b10 <malloc+0x70e>
     dc6:	00005517          	auipc	a0,0x5
     dca:	e5a50513          	addi	a0,a0,-422 # 5c20 <malloc+0x81e>
     dce:	18e040ef          	jal	4f5c <link>
     dd2:	0a055863          	bgez	a0,e82 <linktest+0x1b4>
}
     dd6:	60e2                	ld	ra,24(sp)
     dd8:	6442                	ld	s0,16(sp)
     dda:	64a2                	ld	s1,8(sp)
     ddc:	6902                	ld	s2,0(sp)
     dde:	6105                	addi	sp,sp,32
     de0:	8082                	ret
    printf("%s: create lf1 failed\n", s);
     de2:	85ca                	mv	a1,s2
     de4:	00005517          	auipc	a0,0x5
     de8:	d3c50513          	addi	a0,a0,-708 # 5b20 <malloc+0x71e>
     dec:	55e040ef          	jal	534a <printf>
    exit(1);
     df0:	4505                	li	a0,1
     df2:	10a040ef          	jal	4efc <exit>
    printf("%s: write lf1 failed\n", s);
     df6:	85ca                	mv	a1,s2
     df8:	00005517          	auipc	a0,0x5
     dfc:	d4050513          	addi	a0,a0,-704 # 5b38 <malloc+0x736>
     e00:	54a040ef          	jal	534a <printf>
    exit(1);
     e04:	4505                	li	a0,1
     e06:	0f6040ef          	jal	4efc <exit>
    printf("%s: link lf1 lf2 failed\n", s);
     e0a:	85ca                	mv	a1,s2
     e0c:	00005517          	auipc	a0,0x5
     e10:	d4450513          	addi	a0,a0,-700 # 5b50 <malloc+0x74e>
     e14:	536040ef          	jal	534a <printf>
    exit(1);
     e18:	4505                	li	a0,1
     e1a:	0e2040ef          	jal	4efc <exit>
    printf("%s: unlinked lf1 but it is still there!\n", s);
     e1e:	85ca                	mv	a1,s2
     e20:	00005517          	auipc	a0,0x5
     e24:	d5050513          	addi	a0,a0,-688 # 5b70 <malloc+0x76e>
     e28:	522040ef          	jal	534a <printf>
    exit(1);
     e2c:	4505                	li	a0,1
     e2e:	0ce040ef          	jal	4efc <exit>
    printf("%s: open lf2 failed\n", s);
     e32:	85ca                	mv	a1,s2
     e34:	00005517          	auipc	a0,0x5
     e38:	d6c50513          	addi	a0,a0,-660 # 5ba0 <malloc+0x79e>
     e3c:	50e040ef          	jal	534a <printf>
    exit(1);
     e40:	4505                	li	a0,1
     e42:	0ba040ef          	jal	4efc <exit>
    printf("%s: read lf2 failed\n", s);
     e46:	85ca                	mv	a1,s2
     e48:	00005517          	auipc	a0,0x5
     e4c:	d7050513          	addi	a0,a0,-656 # 5bb8 <malloc+0x7b6>
     e50:	4fa040ef          	jal	534a <printf>
    exit(1);
     e54:	4505                	li	a0,1
     e56:	0a6040ef          	jal	4efc <exit>
    printf("%s: link lf2 lf2 succeeded! oops\n", s);
     e5a:	85ca                	mv	a1,s2
     e5c:	00005517          	auipc	a0,0x5
     e60:	d7450513          	addi	a0,a0,-652 # 5bd0 <malloc+0x7ce>
     e64:	4e6040ef          	jal	534a <printf>
    exit(1);
     e68:	4505                	li	a0,1
     e6a:	092040ef          	jal	4efc <exit>
    printf("%s: link non-existent succeeded! oops\n", s);
     e6e:	85ca                	mv	a1,s2
     e70:	00005517          	auipc	a0,0x5
     e74:	d8850513          	addi	a0,a0,-632 # 5bf8 <malloc+0x7f6>
     e78:	4d2040ef          	jal	534a <printf>
    exit(1);
     e7c:	4505                	li	a0,1
     e7e:	07e040ef          	jal	4efc <exit>
    printf("%s: link . lf1 succeeded! oops\n", s);
     e82:	85ca                	mv	a1,s2
     e84:	00005517          	auipc	a0,0x5
     e88:	da450513          	addi	a0,a0,-604 # 5c28 <malloc+0x826>
     e8c:	4be040ef          	jal	534a <printf>
    exit(1);
     e90:	4505                	li	a0,1
     e92:	06a040ef          	jal	4efc <exit>

0000000000000e96 <validatetest>:
{
     e96:	7139                	addi	sp,sp,-64
     e98:	fc06                	sd	ra,56(sp)
     e9a:	f822                	sd	s0,48(sp)
     e9c:	f426                	sd	s1,40(sp)
     e9e:	f04a                	sd	s2,32(sp)
     ea0:	ec4e                	sd	s3,24(sp)
     ea2:	e852                	sd	s4,16(sp)
     ea4:	e456                	sd	s5,8(sp)
     ea6:	e05a                	sd	s6,0(sp)
     ea8:	0080                	addi	s0,sp,64
     eaa:	8b2a                	mv	s6,a0
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eac:	4481                	li	s1,0
    if(link("nosuchfile", (char*)p) != -1){
     eae:	00005997          	auipc	s3,0x5
     eb2:	d9a98993          	addi	s3,s3,-614 # 5c48 <malloc+0x846>
     eb6:	597d                	li	s2,-1
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eb8:	6a85                	lui	s5,0x1
     eba:	00114a37          	lui	s4,0x114
    if(link("nosuchfile", (char*)p) != -1){
     ebe:	85a6                	mv	a1,s1
     ec0:	854e                	mv	a0,s3
     ec2:	09a040ef          	jal	4f5c <link>
     ec6:	01251f63          	bne	a0,s2,ee4 <validatetest+0x4e>
  for(p = 0; p <= (uint)hi; p += PGSIZE){
     eca:	94d6                	add	s1,s1,s5
     ecc:	ff4499e3          	bne	s1,s4,ebe <validatetest+0x28>
}
     ed0:	70e2                	ld	ra,56(sp)
     ed2:	7442                	ld	s0,48(sp)
     ed4:	74a2                	ld	s1,40(sp)
     ed6:	7902                	ld	s2,32(sp)
     ed8:	69e2                	ld	s3,24(sp)
     eda:	6a42                	ld	s4,16(sp)
     edc:	6aa2                	ld	s5,8(sp)
     ede:	6b02                	ld	s6,0(sp)
     ee0:	6121                	addi	sp,sp,64
     ee2:	8082                	ret
      printf("%s: link should not succeed\n", s);
     ee4:	85da                	mv	a1,s6
     ee6:	00005517          	auipc	a0,0x5
     eea:	d7250513          	addi	a0,a0,-654 # 5c58 <malloc+0x856>
     eee:	45c040ef          	jal	534a <printf>
      exit(1);
     ef2:	4505                	li	a0,1
     ef4:	008040ef          	jal	4efc <exit>

0000000000000ef8 <bigdir>:
{
     ef8:	711d                	addi	sp,sp,-96
     efa:	ec86                	sd	ra,88(sp)
     efc:	e8a2                	sd	s0,80(sp)
     efe:	e4a6                	sd	s1,72(sp)
     f00:	e0ca                	sd	s2,64(sp)
     f02:	fc4e                	sd	s3,56(sp)
     f04:	f852                	sd	s4,48(sp)
     f06:	f456                	sd	s5,40(sp)
     f08:	f05a                	sd	s6,32(sp)
     f0a:	ec5e                	sd	s7,24(sp)
     f0c:	1080                	addi	s0,sp,96
     f0e:	8baa                	mv	s7,a0
  unlink("bd");
     f10:	00005517          	auipc	a0,0x5
     f14:	d6850513          	addi	a0,a0,-664 # 5c78 <malloc+0x876>
     f18:	034040ef          	jal	4f4c <unlink>
  fd = open("bd", O_CREATE);
     f1c:	20000593          	li	a1,512
     f20:	00005517          	auipc	a0,0x5
     f24:	d5850513          	addi	a0,a0,-680 # 5c78 <malloc+0x876>
     f28:	014040ef          	jal	4f3c <open>
  if(fd < 0){
     f2c:	0c054463          	bltz	a0,ff4 <bigdir+0xfc>
  close(fd);
     f30:	7f5030ef          	jal	4f24 <close>
  for(i = 0; i < N; i++){
     f34:	4901                	li	s2,0
    name[0] = 'x';
     f36:	07800a93          	li	s5,120
    if(link("bd", name) != 0){
     f3a:	fa040a13          	addi	s4,s0,-96
     f3e:	00005997          	auipc	s3,0x5
     f42:	d3a98993          	addi	s3,s3,-710 # 5c78 <malloc+0x876>
  for(i = 0; i < N; i++){
     f46:	1f400b13          	li	s6,500
    name[0] = 'x';
     f4a:	fb540023          	sb	s5,-96(s0)
    name[1] = '0' + (i / 64);
     f4e:	41f9571b          	sraiw	a4,s2,0x1f
     f52:	01a7571b          	srliw	a4,a4,0x1a
     f56:	012707bb          	addw	a5,a4,s2
     f5a:	4067d69b          	sraiw	a3,a5,0x6
     f5e:	0306869b          	addiw	a3,a3,48
     f62:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     f66:	03f7f793          	andi	a5,a5,63
     f6a:	9f99                	subw	a5,a5,a4
     f6c:	0307879b          	addiw	a5,a5,48
     f70:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     f74:	fa0401a3          	sb	zero,-93(s0)
    if(link("bd", name) != 0){
     f78:	85d2                	mv	a1,s4
     f7a:	854e                	mv	a0,s3
     f7c:	7e1030ef          	jal	4f5c <link>
     f80:	84aa                	mv	s1,a0
     f82:	e159                	bnez	a0,1008 <bigdir+0x110>
  for(i = 0; i < N; i++){
     f84:	2905                	addiw	s2,s2,1
     f86:	fd6912e3          	bne	s2,s6,f4a <bigdir+0x52>
  unlink("bd");
     f8a:	00005517          	auipc	a0,0x5
     f8e:	cee50513          	addi	a0,a0,-786 # 5c78 <malloc+0x876>
     f92:	7bb030ef          	jal	4f4c <unlink>
    name[0] = 'x';
     f96:	07800993          	li	s3,120
    if(unlink(name) != 0){
     f9a:	fa040913          	addi	s2,s0,-96
  for(i = 0; i < N; i++){
     f9e:	1f400a13          	li	s4,500
    name[0] = 'x';
     fa2:	fb340023          	sb	s3,-96(s0)
    name[1] = '0' + (i / 64);
     fa6:	41f4d71b          	sraiw	a4,s1,0x1f
     faa:	01a7571b          	srliw	a4,a4,0x1a
     fae:	009707bb          	addw	a5,a4,s1
     fb2:	4067d69b          	sraiw	a3,a5,0x6
     fb6:	0306869b          	addiw	a3,a3,48
     fba:	fad400a3          	sb	a3,-95(s0)
    name[2] = '0' + (i % 64);
     fbe:	03f7f793          	andi	a5,a5,63
     fc2:	9f99                	subw	a5,a5,a4
     fc4:	0307879b          	addiw	a5,a5,48
     fc8:	faf40123          	sb	a5,-94(s0)
    name[3] = '\0';
     fcc:	fa0401a3          	sb	zero,-93(s0)
    if(unlink(name) != 0){
     fd0:	854a                	mv	a0,s2
     fd2:	77b030ef          	jal	4f4c <unlink>
     fd6:	e531                	bnez	a0,1022 <bigdir+0x12a>
  for(i = 0; i < N; i++){
     fd8:	2485                	addiw	s1,s1,1
     fda:	fd4494e3          	bne	s1,s4,fa2 <bigdir+0xaa>
}
     fde:	60e6                	ld	ra,88(sp)
     fe0:	6446                	ld	s0,80(sp)
     fe2:	64a6                	ld	s1,72(sp)
     fe4:	6906                	ld	s2,64(sp)
     fe6:	79e2                	ld	s3,56(sp)
     fe8:	7a42                	ld	s4,48(sp)
     fea:	7aa2                	ld	s5,40(sp)
     fec:	7b02                	ld	s6,32(sp)
     fee:	6be2                	ld	s7,24(sp)
     ff0:	6125                	addi	sp,sp,96
     ff2:	8082                	ret
    printf("%s: bigdir create failed\n", s);
     ff4:	85de                	mv	a1,s7
     ff6:	00005517          	auipc	a0,0x5
     ffa:	c8a50513          	addi	a0,a0,-886 # 5c80 <malloc+0x87e>
     ffe:	34c040ef          	jal	534a <printf>
    exit(1);
    1002:	4505                	li	a0,1
    1004:	6f9030ef          	jal	4efc <exit>
      printf("%s: bigdir i=%d link(bd, %s) failed\n", s, i, name);
    1008:	fa040693          	addi	a3,s0,-96
    100c:	864a                	mv	a2,s2
    100e:	85de                	mv	a1,s7
    1010:	00005517          	auipc	a0,0x5
    1014:	c9050513          	addi	a0,a0,-880 # 5ca0 <malloc+0x89e>
    1018:	332040ef          	jal	534a <printf>
      exit(1);
    101c:	4505                	li	a0,1
    101e:	6df030ef          	jal	4efc <exit>
      printf("%s: bigdir unlink failed", s);
    1022:	85de                	mv	a1,s7
    1024:	00005517          	auipc	a0,0x5
    1028:	ca450513          	addi	a0,a0,-860 # 5cc8 <malloc+0x8c6>
    102c:	31e040ef          	jal	534a <printf>
      exit(1);
    1030:	4505                	li	a0,1
    1032:	6cb030ef          	jal	4efc <exit>

0000000000001036 <pgbug>:
{
    1036:	7179                	addi	sp,sp,-48
    1038:	f406                	sd	ra,40(sp)
    103a:	f022                	sd	s0,32(sp)
    103c:	ec26                	sd	s1,24(sp)
    103e:	1800                	addi	s0,sp,48
  argv[0] = 0;
    1040:	fc043c23          	sd	zero,-40(s0)
  exec(big, argv);
    1044:	00007497          	auipc	s1,0x7
    1048:	fbc48493          	addi	s1,s1,-68 # 8000 <big>
    104c:	fd840593          	addi	a1,s0,-40
    1050:	6088                	ld	a0,0(s1)
    1052:	6e3030ef          	jal	4f34 <exec>
  pipe(big);
    1056:	6088                	ld	a0,0(s1)
    1058:	6b5030ef          	jal	4f0c <pipe>
  exit(0);
    105c:	4501                	li	a0,0
    105e:	69f030ef          	jal	4efc <exit>

0000000000001062 <badarg>:
{
    1062:	7139                	addi	sp,sp,-64
    1064:	fc06                	sd	ra,56(sp)
    1066:	f822                	sd	s0,48(sp)
    1068:	f426                	sd	s1,40(sp)
    106a:	f04a                	sd	s2,32(sp)
    106c:	ec4e                	sd	s3,24(sp)
    106e:	e852                	sd	s4,16(sp)
    1070:	0080                	addi	s0,sp,64
    1072:	64b1                	lui	s1,0xc
    1074:	35048493          	addi	s1,s1,848 # c350 <buf+0x6a8>
    argv[0] = (char*)0xffffffff;
    1078:	597d                	li	s2,-1
    107a:	02095913          	srli	s2,s2,0x20
    exec("echo", argv);
    107e:	fc040a13          	addi	s4,s0,-64
    1082:	00004997          	auipc	s3,0x4
    1086:	4b698993          	addi	s3,s3,1206 # 5538 <malloc+0x136>
    argv[0] = (char*)0xffffffff;
    108a:	fd243023          	sd	s2,-64(s0)
    argv[1] = 0;
    108e:	fc043423          	sd	zero,-56(s0)
    exec("echo", argv);
    1092:	85d2                	mv	a1,s4
    1094:	854e                	mv	a0,s3
    1096:	69f030ef          	jal	4f34 <exec>
  for(int i = 0; i < 50000; i++){
    109a:	34fd                	addiw	s1,s1,-1
    109c:	f4fd                	bnez	s1,108a <badarg+0x28>
  exit(0);
    109e:	4501                	li	a0,0
    10a0:	65d030ef          	jal	4efc <exit>

00000000000010a4 <copyinstr2>:
{
    10a4:	7155                	addi	sp,sp,-208
    10a6:	e586                	sd	ra,200(sp)
    10a8:	e1a2                	sd	s0,192(sp)
    10aa:	0980                	addi	s0,sp,208
  for(int i = 0; i < MAXPATH; i++)
    10ac:	f6840793          	addi	a5,s0,-152
    10b0:	fe840693          	addi	a3,s0,-24
    b[i] = 'x';
    10b4:	07800713          	li	a4,120
    10b8:	00e78023          	sb	a4,0(a5)
  for(int i = 0; i < MAXPATH; i++)
    10bc:	0785                	addi	a5,a5,1
    10be:	fed79de3          	bne	a5,a3,10b8 <copyinstr2+0x14>
  b[MAXPATH] = '\0';
    10c2:	fe040423          	sb	zero,-24(s0)
  int ret = unlink(b);
    10c6:	f6840513          	addi	a0,s0,-152
    10ca:	683030ef          	jal	4f4c <unlink>
  if(ret != -1){
    10ce:	57fd                	li	a5,-1
    10d0:	0cf51263          	bne	a0,a5,1194 <copyinstr2+0xf0>
  int fd = open(b, O_CREATE | O_WRONLY);
    10d4:	20100593          	li	a1,513
    10d8:	f6840513          	addi	a0,s0,-152
    10dc:	661030ef          	jal	4f3c <open>
  if(fd != -1){
    10e0:	57fd                	li	a5,-1
    10e2:	0cf51563          	bne	a0,a5,11ac <copyinstr2+0x108>
  ret = link(b, b);
    10e6:	f6840513          	addi	a0,s0,-152
    10ea:	85aa                	mv	a1,a0
    10ec:	671030ef          	jal	4f5c <link>
  if(ret != -1){
    10f0:	57fd                	li	a5,-1
    10f2:	0cf51963          	bne	a0,a5,11c4 <copyinstr2+0x120>
  char *args[] = { "xx", 0 };
    10f6:	00006797          	auipc	a5,0x6
    10fa:	d2278793          	addi	a5,a5,-734 # 6e18 <malloc+0x1a16>
    10fe:	f4f43c23          	sd	a5,-168(s0)
    1102:	f6043023          	sd	zero,-160(s0)
  ret = exec(b, args);
    1106:	f5840593          	addi	a1,s0,-168
    110a:	f6840513          	addi	a0,s0,-152
    110e:	627030ef          	jal	4f34 <exec>
  if(ret != -1){
    1112:	57fd                	li	a5,-1
    1114:	0cf51563          	bne	a0,a5,11de <copyinstr2+0x13a>
  int pid = fork();
    1118:	5dd030ef          	jal	4ef4 <fork>
  if(pid < 0){
    111c:	0c054d63          	bltz	a0,11f6 <copyinstr2+0x152>
  if(pid == 0){
    1120:	0e051863          	bnez	a0,1210 <copyinstr2+0x16c>
    1124:	00007797          	auipc	a5,0x7
    1128:	46c78793          	addi	a5,a5,1132 # 8590 <big.0>
    112c:	00008697          	auipc	a3,0x8
    1130:	46468693          	addi	a3,a3,1124 # 9590 <big.0+0x1000>
      big[i] = 'x';
    1134:	07800713          	li	a4,120
    1138:	00e78023          	sb	a4,0(a5)
    for(int i = 0; i < PGSIZE; i++)
    113c:	0785                	addi	a5,a5,1
    113e:	fed79de3          	bne	a5,a3,1138 <copyinstr2+0x94>
    big[PGSIZE] = '\0';
    1142:	00008797          	auipc	a5,0x8
    1146:	44078723          	sb	zero,1102(a5) # 9590 <big.0+0x1000>
    char *args2[] = { big, big, big, 0 };
    114a:	00007797          	auipc	a5,0x7
    114e:	83e78793          	addi	a5,a5,-1986 # 7988 <malloc+0x2586>
    1152:	6fb0                	ld	a2,88(a5)
    1154:	73b4                	ld	a3,96(a5)
    1156:	77b8                	ld	a4,104(a5)
    1158:	f2c43823          	sd	a2,-208(s0)
    115c:	f2d43c23          	sd	a3,-200(s0)
    1160:	f4e43023          	sd	a4,-192(s0)
    1164:	7bbc                	ld	a5,112(a5)
    1166:	f4f43423          	sd	a5,-184(s0)
    ret = exec("echo", args2);
    116a:	f3040593          	addi	a1,s0,-208
    116e:	00004517          	auipc	a0,0x4
    1172:	3ca50513          	addi	a0,a0,970 # 5538 <malloc+0x136>
    1176:	5bf030ef          	jal	4f34 <exec>
    if(ret != -1){
    117a:	57fd                	li	a5,-1
    117c:	08f50663          	beq	a0,a5,1208 <copyinstr2+0x164>
      printf("exec(echo, BIG) returned %d, not -1\n", fd);
    1180:	85be                	mv	a1,a5
    1182:	00005517          	auipc	a0,0x5
    1186:	bee50513          	addi	a0,a0,-1042 # 5d70 <malloc+0x96e>
    118a:	1c0040ef          	jal	534a <printf>
      exit(1);
    118e:	4505                	li	a0,1
    1190:	56d030ef          	jal	4efc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    1194:	862a                	mv	a2,a0
    1196:	f6840593          	addi	a1,s0,-152
    119a:	00005517          	auipc	a0,0x5
    119e:	b4e50513          	addi	a0,a0,-1202 # 5ce8 <malloc+0x8e6>
    11a2:	1a8040ef          	jal	534a <printf>
    exit(1);
    11a6:	4505                	li	a0,1
    11a8:	555030ef          	jal	4efc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    11ac:	862a                	mv	a2,a0
    11ae:	f6840593          	addi	a1,s0,-152
    11b2:	00005517          	auipc	a0,0x5
    11b6:	b5650513          	addi	a0,a0,-1194 # 5d08 <malloc+0x906>
    11ba:	190040ef          	jal	534a <printf>
    exit(1);
    11be:	4505                	li	a0,1
    11c0:	53d030ef          	jal	4efc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    11c4:	f6840593          	addi	a1,s0,-152
    11c8:	86aa                	mv	a3,a0
    11ca:	862e                	mv	a2,a1
    11cc:	00005517          	auipc	a0,0x5
    11d0:	b5c50513          	addi	a0,a0,-1188 # 5d28 <malloc+0x926>
    11d4:	176040ef          	jal	534a <printf>
    exit(1);
    11d8:	4505                	li	a0,1
    11da:	523030ef          	jal	4efc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    11de:	863e                	mv	a2,a5
    11e0:	f6840593          	addi	a1,s0,-152
    11e4:	00005517          	auipc	a0,0x5
    11e8:	b6c50513          	addi	a0,a0,-1172 # 5d50 <malloc+0x94e>
    11ec:	15e040ef          	jal	534a <printf>
    exit(1);
    11f0:	4505                	li	a0,1
    11f2:	50b030ef          	jal	4efc <exit>
    printf("fork failed\n");
    11f6:	00006517          	auipc	a0,0x6
    11fa:	17a50513          	addi	a0,a0,378 # 7370 <malloc+0x1f6e>
    11fe:	14c040ef          	jal	534a <printf>
    exit(1);
    1202:	4505                	li	a0,1
    1204:	4f9030ef          	jal	4efc <exit>
    exit(747); // OK
    1208:	2eb00513          	li	a0,747
    120c:	4f1030ef          	jal	4efc <exit>
  int st = 0;
    1210:	f4042a23          	sw	zero,-172(s0)
  wait(&st);
    1214:	f5440513          	addi	a0,s0,-172
    1218:	4ed030ef          	jal	4f04 <wait>
  if(st != 747){
    121c:	f5442703          	lw	a4,-172(s0)
    1220:	2eb00793          	li	a5,747
    1224:	00f71663          	bne	a4,a5,1230 <copyinstr2+0x18c>
}
    1228:	60ae                	ld	ra,200(sp)
    122a:	640e                	ld	s0,192(sp)
    122c:	6169                	addi	sp,sp,208
    122e:	8082                	ret
    printf("exec(echo, BIG) succeeded, should have failed\n");
    1230:	00005517          	auipc	a0,0x5
    1234:	b6850513          	addi	a0,a0,-1176 # 5d98 <malloc+0x996>
    1238:	112040ef          	jal	534a <printf>
    exit(1);
    123c:	4505                	li	a0,1
    123e:	4bf030ef          	jal	4efc <exit>

0000000000001242 <truncate3>:
{
    1242:	7175                	addi	sp,sp,-144
    1244:	e506                	sd	ra,136(sp)
    1246:	e122                	sd	s0,128(sp)
    1248:	fc66                	sd	s9,56(sp)
    124a:	0900                	addi	s0,sp,144
    124c:	8caa                	mv	s9,a0
  close(open("truncfile", O_CREATE|O_TRUNC|O_WRONLY));
    124e:	60100593          	li	a1,1537
    1252:	00004517          	auipc	a0,0x4
    1256:	33e50513          	addi	a0,a0,830 # 5590 <malloc+0x18e>
    125a:	4e3030ef          	jal	4f3c <open>
    125e:	4c7030ef          	jal	4f24 <close>
  pid = fork();
    1262:	493030ef          	jal	4ef4 <fork>
  if(pid < 0){
    1266:	06054d63          	bltz	a0,12e0 <truncate3+0x9e>
  if(pid == 0){
    126a:	e171                	bnez	a0,132e <truncate3+0xec>
    126c:	fca6                	sd	s1,120(sp)
    126e:	f8ca                	sd	s2,112(sp)
    1270:	f4ce                	sd	s3,104(sp)
    1272:	f0d2                	sd	s4,96(sp)
    1274:	ecd6                	sd	s5,88(sp)
    1276:	e8da                	sd	s6,80(sp)
    1278:	e4de                	sd	s7,72(sp)
    127a:	e0e2                	sd	s8,64(sp)
    127c:	06400913          	li	s2,100
      int fd = open("truncfile", O_WRONLY);
    1280:	4a85                	li	s5,1
    1282:	00004997          	auipc	s3,0x4
    1286:	30e98993          	addi	s3,s3,782 # 5590 <malloc+0x18e>
      int n = write(fd, "1234567890", 10);
    128a:	4a29                	li	s4,10
    128c:	00005b17          	auipc	s6,0x5
    1290:	b6cb0b13          	addi	s6,s6,-1172 # 5df8 <malloc+0x9f6>
      read(fd, buf, sizeof(buf));
    1294:	f7840c13          	addi	s8,s0,-136
    1298:	02000b93          	li	s7,32
      int fd = open("truncfile", O_WRONLY);
    129c:	85d6                	mv	a1,s5
    129e:	854e                	mv	a0,s3
    12a0:	49d030ef          	jal	4f3c <open>
    12a4:	84aa                	mv	s1,a0
      if(fd < 0){
    12a6:	04054f63          	bltz	a0,1304 <truncate3+0xc2>
      int n = write(fd, "1234567890", 10);
    12aa:	8652                	mv	a2,s4
    12ac:	85da                	mv	a1,s6
    12ae:	46f030ef          	jal	4f1c <write>
      if(n != 10){
    12b2:	07451363          	bne	a0,s4,1318 <truncate3+0xd6>
      close(fd);
    12b6:	8526                	mv	a0,s1
    12b8:	46d030ef          	jal	4f24 <close>
      fd = open("truncfile", O_RDONLY);
    12bc:	4581                	li	a1,0
    12be:	854e                	mv	a0,s3
    12c0:	47d030ef          	jal	4f3c <open>
    12c4:	84aa                	mv	s1,a0
      read(fd, buf, sizeof(buf));
    12c6:	865e                	mv	a2,s7
    12c8:	85e2                	mv	a1,s8
    12ca:	44b030ef          	jal	4f14 <read>
      close(fd);
    12ce:	8526                	mv	a0,s1
    12d0:	455030ef          	jal	4f24 <close>
    for(int i = 0; i < 100; i++){
    12d4:	397d                	addiw	s2,s2,-1
    12d6:	fc0913e3          	bnez	s2,129c <truncate3+0x5a>
    exit(0);
    12da:	4501                	li	a0,0
    12dc:	421030ef          	jal	4efc <exit>
    12e0:	fca6                	sd	s1,120(sp)
    12e2:	f8ca                	sd	s2,112(sp)
    12e4:	f4ce                	sd	s3,104(sp)
    12e6:	f0d2                	sd	s4,96(sp)
    12e8:	ecd6                	sd	s5,88(sp)
    12ea:	e8da                	sd	s6,80(sp)
    12ec:	e4de                	sd	s7,72(sp)
    12ee:	e0e2                	sd	s8,64(sp)
    printf("%s: fork failed\n", s);
    12f0:	85e6                	mv	a1,s9
    12f2:	00005517          	auipc	a0,0x5
    12f6:	ad650513          	addi	a0,a0,-1322 # 5dc8 <malloc+0x9c6>
    12fa:	050040ef          	jal	534a <printf>
    exit(1);
    12fe:	4505                	li	a0,1
    1300:	3fd030ef          	jal	4efc <exit>
        printf("%s: open failed\n", s);
    1304:	85e6                	mv	a1,s9
    1306:	00005517          	auipc	a0,0x5
    130a:	ada50513          	addi	a0,a0,-1318 # 5de0 <malloc+0x9de>
    130e:	03c040ef          	jal	534a <printf>
        exit(1);
    1312:	4505                	li	a0,1
    1314:	3e9030ef          	jal	4efc <exit>
        printf("%s: write got %d, expected 10\n", s, n);
    1318:	862a                	mv	a2,a0
    131a:	85e6                	mv	a1,s9
    131c:	00005517          	auipc	a0,0x5
    1320:	aec50513          	addi	a0,a0,-1300 # 5e08 <malloc+0xa06>
    1324:	026040ef          	jal	534a <printf>
        exit(1);
    1328:	4505                	li	a0,1
    132a:	3d3030ef          	jal	4efc <exit>
    132e:	fca6                	sd	s1,120(sp)
    1330:	f8ca                	sd	s2,112(sp)
    1332:	f4ce                	sd	s3,104(sp)
    1334:	f0d2                	sd	s4,96(sp)
    1336:	ecd6                	sd	s5,88(sp)
    1338:	e8da                	sd	s6,80(sp)
    133a:	09600913          	li	s2,150
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    133e:	60100a93          	li	s5,1537
    1342:	00004a17          	auipc	s4,0x4
    1346:	24ea0a13          	addi	s4,s4,590 # 5590 <malloc+0x18e>
    int n = write(fd, "xxx", 3);
    134a:	498d                	li	s3,3
    134c:	00005b17          	auipc	s6,0x5
    1350:	adcb0b13          	addi	s6,s6,-1316 # 5e28 <malloc+0xa26>
    int fd = open("truncfile", O_CREATE|O_WRONLY|O_TRUNC);
    1354:	85d6                	mv	a1,s5
    1356:	8552                	mv	a0,s4
    1358:	3e5030ef          	jal	4f3c <open>
    135c:	84aa                	mv	s1,a0
    if(fd < 0){
    135e:	02054e63          	bltz	a0,139a <truncate3+0x158>
    int n = write(fd, "xxx", 3);
    1362:	864e                	mv	a2,s3
    1364:	85da                	mv	a1,s6
    1366:	3b7030ef          	jal	4f1c <write>
    if(n != 3){
    136a:	05351463          	bne	a0,s3,13b2 <truncate3+0x170>
    close(fd);
    136e:	8526                	mv	a0,s1
    1370:	3b5030ef          	jal	4f24 <close>
  for(int i = 0; i < 150; i++){
    1374:	397d                	addiw	s2,s2,-1
    1376:	fc091fe3          	bnez	s2,1354 <truncate3+0x112>
    137a:	e4de                	sd	s7,72(sp)
    137c:	e0e2                	sd	s8,64(sp)
  wait(&xstatus);
    137e:	f9c40513          	addi	a0,s0,-100
    1382:	383030ef          	jal	4f04 <wait>
  unlink("truncfile");
    1386:	00004517          	auipc	a0,0x4
    138a:	20a50513          	addi	a0,a0,522 # 5590 <malloc+0x18e>
    138e:	3bf030ef          	jal	4f4c <unlink>
  exit(xstatus);
    1392:	f9c42503          	lw	a0,-100(s0)
    1396:	367030ef          	jal	4efc <exit>
    139a:	e4de                	sd	s7,72(sp)
    139c:	e0e2                	sd	s8,64(sp)
      printf("%s: open failed\n", s);
    139e:	85e6                	mv	a1,s9
    13a0:	00005517          	auipc	a0,0x5
    13a4:	a4050513          	addi	a0,a0,-1472 # 5de0 <malloc+0x9de>
    13a8:	7a3030ef          	jal	534a <printf>
      exit(1);
    13ac:	4505                	li	a0,1
    13ae:	34f030ef          	jal	4efc <exit>
    13b2:	e4de                	sd	s7,72(sp)
    13b4:	e0e2                	sd	s8,64(sp)
      printf("%s: write got %d, expected 3\n", s, n);
    13b6:	862a                	mv	a2,a0
    13b8:	85e6                	mv	a1,s9
    13ba:	00005517          	auipc	a0,0x5
    13be:	a7650513          	addi	a0,a0,-1418 # 5e30 <malloc+0xa2e>
    13c2:	789030ef          	jal	534a <printf>
      exit(1);
    13c6:	4505                	li	a0,1
    13c8:	335030ef          	jal	4efc <exit>

00000000000013cc <exectest>:
{
    13cc:	715d                	addi	sp,sp,-80
    13ce:	e486                	sd	ra,72(sp)
    13d0:	e0a2                	sd	s0,64(sp)
    13d2:	f84a                	sd	s2,48(sp)
    13d4:	0880                	addi	s0,sp,80
    13d6:	892a                	mv	s2,a0
  char *echoargv[] = { "echo", "OK", 0 };
    13d8:	00004797          	auipc	a5,0x4
    13dc:	16078793          	addi	a5,a5,352 # 5538 <malloc+0x136>
    13e0:	fcf43023          	sd	a5,-64(s0)
    13e4:	00005797          	auipc	a5,0x5
    13e8:	a6c78793          	addi	a5,a5,-1428 # 5e50 <malloc+0xa4e>
    13ec:	fcf43423          	sd	a5,-56(s0)
    13f0:	fc043823          	sd	zero,-48(s0)
  unlink("echo-ok");
    13f4:	00005517          	auipc	a0,0x5
    13f8:	a6450513          	addi	a0,a0,-1436 # 5e58 <malloc+0xa56>
    13fc:	351030ef          	jal	4f4c <unlink>
  pid = fork();
    1400:	2f5030ef          	jal	4ef4 <fork>
  if(pid < 0) {
    1404:	02054f63          	bltz	a0,1442 <exectest+0x76>
    1408:	fc26                	sd	s1,56(sp)
    140a:	84aa                	mv	s1,a0
  if(pid == 0) {
    140c:	e935                	bnez	a0,1480 <exectest+0xb4>
    close(1);
    140e:	4505                	li	a0,1
    1410:	315030ef          	jal	4f24 <close>
    fd = open("echo-ok", O_CREATE|O_WRONLY);
    1414:	20100593          	li	a1,513
    1418:	00005517          	auipc	a0,0x5
    141c:	a4050513          	addi	a0,a0,-1472 # 5e58 <malloc+0xa56>
    1420:	31d030ef          	jal	4f3c <open>
    if(fd < 0) {
    1424:	02054a63          	bltz	a0,1458 <exectest+0x8c>
    if(fd != 1) {
    1428:	4785                	li	a5,1
    142a:	04f50163          	beq	a0,a5,146c <exectest+0xa0>
      printf("%s: wrong fd\n", s);
    142e:	85ca                	mv	a1,s2
    1430:	00005517          	auipc	a0,0x5
    1434:	a4850513          	addi	a0,a0,-1464 # 5e78 <malloc+0xa76>
    1438:	713030ef          	jal	534a <printf>
      exit(1);
    143c:	4505                	li	a0,1
    143e:	2bf030ef          	jal	4efc <exit>
    1442:	fc26                	sd	s1,56(sp)
     printf("%s: fork failed\n", s);
    1444:	85ca                	mv	a1,s2
    1446:	00005517          	auipc	a0,0x5
    144a:	98250513          	addi	a0,a0,-1662 # 5dc8 <malloc+0x9c6>
    144e:	6fd030ef          	jal	534a <printf>
     exit(1);
    1452:	4505                	li	a0,1
    1454:	2a9030ef          	jal	4efc <exit>
      printf("%s: create failed\n", s);
    1458:	85ca                	mv	a1,s2
    145a:	00005517          	auipc	a0,0x5
    145e:	a0650513          	addi	a0,a0,-1530 # 5e60 <malloc+0xa5e>
    1462:	6e9030ef          	jal	534a <printf>
      exit(1);
    1466:	4505                	li	a0,1
    1468:	295030ef          	jal	4efc <exit>
    if(exec("echo", echoargv) < 0){
    146c:	fc040593          	addi	a1,s0,-64
    1470:	00004517          	auipc	a0,0x4
    1474:	0c850513          	addi	a0,a0,200 # 5538 <malloc+0x136>
    1478:	2bd030ef          	jal	4f34 <exec>
    147c:	00054d63          	bltz	a0,1496 <exectest+0xca>
  if (wait(&xstatus) != pid) {
    1480:	fdc40513          	addi	a0,s0,-36
    1484:	281030ef          	jal	4f04 <wait>
    1488:	02951163          	bne	a0,s1,14aa <exectest+0xde>
  if(xstatus != 0)
    148c:	fdc42503          	lw	a0,-36(s0)
    1490:	c50d                	beqz	a0,14ba <exectest+0xee>
    exit(xstatus);
    1492:	26b030ef          	jal	4efc <exit>
      printf("%s: exec echo failed\n", s);
    1496:	85ca                	mv	a1,s2
    1498:	00005517          	auipc	a0,0x5
    149c:	9f050513          	addi	a0,a0,-1552 # 5e88 <malloc+0xa86>
    14a0:	6ab030ef          	jal	534a <printf>
      exit(1);
    14a4:	4505                	li	a0,1
    14a6:	257030ef          	jal	4efc <exit>
    printf("%s: wait failed!\n", s);
    14aa:	85ca                	mv	a1,s2
    14ac:	00005517          	auipc	a0,0x5
    14b0:	9f450513          	addi	a0,a0,-1548 # 5ea0 <malloc+0xa9e>
    14b4:	697030ef          	jal	534a <printf>
    14b8:	bfd1                	j	148c <exectest+0xc0>
  fd = open("echo-ok", O_RDONLY);
    14ba:	4581                	li	a1,0
    14bc:	00005517          	auipc	a0,0x5
    14c0:	99c50513          	addi	a0,a0,-1636 # 5e58 <malloc+0xa56>
    14c4:	279030ef          	jal	4f3c <open>
  if(fd < 0) {
    14c8:	02054463          	bltz	a0,14f0 <exectest+0x124>
  if (read(fd, buf, 2) != 2) {
    14cc:	4609                	li	a2,2
    14ce:	fb840593          	addi	a1,s0,-72
    14d2:	243030ef          	jal	4f14 <read>
    14d6:	4789                	li	a5,2
    14d8:	02f50663          	beq	a0,a5,1504 <exectest+0x138>
    printf("%s: read failed\n", s);
    14dc:	85ca                	mv	a1,s2
    14de:	00004517          	auipc	a0,0x4
    14e2:	42a50513          	addi	a0,a0,1066 # 5908 <malloc+0x506>
    14e6:	665030ef          	jal	534a <printf>
    exit(1);
    14ea:	4505                	li	a0,1
    14ec:	211030ef          	jal	4efc <exit>
    printf("%s: open failed\n", s);
    14f0:	85ca                	mv	a1,s2
    14f2:	00005517          	auipc	a0,0x5
    14f6:	8ee50513          	addi	a0,a0,-1810 # 5de0 <malloc+0x9de>
    14fa:	651030ef          	jal	534a <printf>
    exit(1);
    14fe:	4505                	li	a0,1
    1500:	1fd030ef          	jal	4efc <exit>
  unlink("echo-ok");
    1504:	00005517          	auipc	a0,0x5
    1508:	95450513          	addi	a0,a0,-1708 # 5e58 <malloc+0xa56>
    150c:	241030ef          	jal	4f4c <unlink>
  if(buf[0] == 'O' && buf[1] == 'K')
    1510:	fb844703          	lbu	a4,-72(s0)
    1514:	04f00793          	li	a5,79
    1518:	00f71863          	bne	a4,a5,1528 <exectest+0x15c>
    151c:	fb944703          	lbu	a4,-71(s0)
    1520:	04b00793          	li	a5,75
    1524:	00f70c63          	beq	a4,a5,153c <exectest+0x170>
    printf("%s: wrong output\n", s);
    1528:	85ca                	mv	a1,s2
    152a:	00005517          	auipc	a0,0x5
    152e:	98e50513          	addi	a0,a0,-1650 # 5eb8 <malloc+0xab6>
    1532:	619030ef          	jal	534a <printf>
    exit(1);
    1536:	4505                	li	a0,1
    1538:	1c5030ef          	jal	4efc <exit>
    exit(0);
    153c:	4501                	li	a0,0
    153e:	1bf030ef          	jal	4efc <exit>

0000000000001542 <pipe1>:
{
    1542:	711d                	addi	sp,sp,-96
    1544:	ec86                	sd	ra,88(sp)
    1546:	e8a2                	sd	s0,80(sp)
    1548:	e862                	sd	s8,16(sp)
    154a:	1080                	addi	s0,sp,96
    154c:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    154e:	fa840513          	addi	a0,s0,-88
    1552:	1bb030ef          	jal	4f0c <pipe>
    1556:	e925                	bnez	a0,15c6 <pipe1+0x84>
    1558:	e4a6                	sd	s1,72(sp)
    155a:	fc4e                	sd	s3,56(sp)
    155c:	84aa                	mv	s1,a0
  pid = fork();
    155e:	197030ef          	jal	4ef4 <fork>
    1562:	89aa                	mv	s3,a0
  if(pid == 0){
    1564:	c151                	beqz	a0,15e8 <pipe1+0xa6>
  } else if(pid > 0){
    1566:	16a05063          	blez	a0,16c6 <pipe1+0x184>
    156a:	e0ca                	sd	s2,64(sp)
    156c:	f852                	sd	s4,48(sp)
    close(fds[1]);
    156e:	fac42503          	lw	a0,-84(s0)
    1572:	1b3030ef          	jal	4f24 <close>
    total = 0;
    1576:	89a6                	mv	s3,s1
    cc = 1;
    1578:	4905                	li	s2,1
    while((n = read(fds[0], buf, cc)) > 0){
    157a:	0000aa17          	auipc	s4,0xa
    157e:	72ea0a13          	addi	s4,s4,1838 # bca8 <buf>
    1582:	864a                	mv	a2,s2
    1584:	85d2                	mv	a1,s4
    1586:	fa842503          	lw	a0,-88(s0)
    158a:	18b030ef          	jal	4f14 <read>
    158e:	85aa                	mv	a1,a0
    1590:	0ea05963          	blez	a0,1682 <pipe1+0x140>
    1594:	0000a797          	auipc	a5,0xa
    1598:	71478793          	addi	a5,a5,1812 # bca8 <buf>
    159c:	00b4863b          	addw	a2,s1,a1
        if((buf[i] & 0xff) != (seq++ & 0xff)){
    15a0:	0007c683          	lbu	a3,0(a5)
    15a4:	0ff4f713          	zext.b	a4,s1
    15a8:	0ae69d63          	bne	a3,a4,1662 <pipe1+0x120>
    15ac:	2485                	addiw	s1,s1,1
      for(i = 0; i < n; i++){
    15ae:	0785                	addi	a5,a5,1
    15b0:	fec498e3          	bne	s1,a2,15a0 <pipe1+0x5e>
      total += n;
    15b4:	00b989bb          	addw	s3,s3,a1
      cc = cc * 2;
    15b8:	0019191b          	slliw	s2,s2,0x1
      if(cc > sizeof(buf))
    15bc:	678d                	lui	a5,0x3
    15be:	fd27f2e3          	bgeu	a5,s2,1582 <pipe1+0x40>
        cc = sizeof(buf);
    15c2:	893e                	mv	s2,a5
    15c4:	bf7d                	j	1582 <pipe1+0x40>
    15c6:	e4a6                	sd	s1,72(sp)
    15c8:	e0ca                	sd	s2,64(sp)
    15ca:	fc4e                	sd	s3,56(sp)
    15cc:	f852                	sd	s4,48(sp)
    15ce:	f456                	sd	s5,40(sp)
    15d0:	f05a                	sd	s6,32(sp)
    15d2:	ec5e                	sd	s7,24(sp)
    printf("%s: pipe() failed\n", s);
    15d4:	85e2                	mv	a1,s8
    15d6:	00005517          	auipc	a0,0x5
    15da:	8fa50513          	addi	a0,a0,-1798 # 5ed0 <malloc+0xace>
    15de:	56d030ef          	jal	534a <printf>
    exit(1);
    15e2:	4505                	li	a0,1
    15e4:	119030ef          	jal	4efc <exit>
    15e8:	e0ca                	sd	s2,64(sp)
    15ea:	f852                	sd	s4,48(sp)
    15ec:	f456                	sd	s5,40(sp)
    15ee:	f05a                	sd	s6,32(sp)
    15f0:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    15f2:	fa842503          	lw	a0,-88(s0)
    15f6:	12f030ef          	jal	4f24 <close>
    for(n = 0; n < N; n++){
    15fa:	0000ab17          	auipc	s6,0xa
    15fe:	6aeb0b13          	addi	s6,s6,1710 # bca8 <buf>
    1602:	416004bb          	negw	s1,s6
    1606:	0ff4f493          	zext.b	s1,s1
    160a:	409b0913          	addi	s2,s6,1033
      if(write(fds[1], buf, SZ) != SZ){
    160e:	40900a13          	li	s4,1033
    1612:	8bda                	mv	s7,s6
    for(n = 0; n < N; n++){
    1614:	6a85                	lui	s5,0x1
    1616:	42da8a93          	addi	s5,s5,1069 # 142d <exectest+0x61>
{
    161a:	87da                	mv	a5,s6
        buf[i] = seq++;
    161c:	0097873b          	addw	a4,a5,s1
    1620:	00e78023          	sb	a4,0(a5) # 3000 <subdir+0x2fa>
      for(i = 0; i < SZ; i++)
    1624:	0785                	addi	a5,a5,1
    1626:	ff279be3          	bne	a5,s2,161c <pipe1+0xda>
      if(write(fds[1], buf, SZ) != SZ){
    162a:	8652                	mv	a2,s4
    162c:	85de                	mv	a1,s7
    162e:	fac42503          	lw	a0,-84(s0)
    1632:	0eb030ef          	jal	4f1c <write>
    1636:	01451c63          	bne	a0,s4,164e <pipe1+0x10c>
    163a:	4099899b          	addiw	s3,s3,1033
    for(n = 0; n < N; n++){
    163e:	24a5                	addiw	s1,s1,9
    1640:	0ff4f493          	zext.b	s1,s1
    1644:	fd599be3          	bne	s3,s5,161a <pipe1+0xd8>
    exit(0);
    1648:	4501                	li	a0,0
    164a:	0b3030ef          	jal	4efc <exit>
        printf("%s: pipe1 oops 1\n", s);
    164e:	85e2                	mv	a1,s8
    1650:	00005517          	auipc	a0,0x5
    1654:	89850513          	addi	a0,a0,-1896 # 5ee8 <malloc+0xae6>
    1658:	4f3030ef          	jal	534a <printf>
        exit(1);
    165c:	4505                	li	a0,1
    165e:	09f030ef          	jal	4efc <exit>
          printf("%s: pipe1 oops 2\n", s);
    1662:	85e2                	mv	a1,s8
    1664:	00005517          	auipc	a0,0x5
    1668:	89c50513          	addi	a0,a0,-1892 # 5f00 <malloc+0xafe>
    166c:	4df030ef          	jal	534a <printf>
          return;
    1670:	64a6                	ld	s1,72(sp)
    1672:	6906                	ld	s2,64(sp)
    1674:	79e2                	ld	s3,56(sp)
    1676:	7a42                	ld	s4,48(sp)
}
    1678:	60e6                	ld	ra,88(sp)
    167a:	6446                	ld	s0,80(sp)
    167c:	6c42                	ld	s8,16(sp)
    167e:	6125                	addi	sp,sp,96
    1680:	8082                	ret
    if(total != N * SZ){
    1682:	6785                	lui	a5,0x1
    1684:	42d78793          	addi	a5,a5,1069 # 142d <exectest+0x61>
    1688:	02f98063          	beq	s3,a5,16a8 <pipe1+0x166>
    168c:	f456                	sd	s5,40(sp)
    168e:	f05a                	sd	s6,32(sp)
    1690:	ec5e                	sd	s7,24(sp)
      printf("%s: pipe1 oops 3 total %d\n", s, total);
    1692:	864e                	mv	a2,s3
    1694:	85e2                	mv	a1,s8
    1696:	00005517          	auipc	a0,0x5
    169a:	88250513          	addi	a0,a0,-1918 # 5f18 <malloc+0xb16>
    169e:	4ad030ef          	jal	534a <printf>
      exit(1);
    16a2:	4505                	li	a0,1
    16a4:	059030ef          	jal	4efc <exit>
    16a8:	f456                	sd	s5,40(sp)
    16aa:	f05a                	sd	s6,32(sp)
    16ac:	ec5e                	sd	s7,24(sp)
    close(fds[0]);
    16ae:	fa842503          	lw	a0,-88(s0)
    16b2:	073030ef          	jal	4f24 <close>
    wait(&xstatus);
    16b6:	fa440513          	addi	a0,s0,-92
    16ba:	04b030ef          	jal	4f04 <wait>
    exit(xstatus);
    16be:	fa442503          	lw	a0,-92(s0)
    16c2:	03b030ef          	jal	4efc <exit>
    16c6:	e0ca                	sd	s2,64(sp)
    16c8:	f852                	sd	s4,48(sp)
    16ca:	f456                	sd	s5,40(sp)
    16cc:	f05a                	sd	s6,32(sp)
    16ce:	ec5e                	sd	s7,24(sp)
    printf("%s: fork() failed\n", s);
    16d0:	85e2                	mv	a1,s8
    16d2:	00005517          	auipc	a0,0x5
    16d6:	86650513          	addi	a0,a0,-1946 # 5f38 <malloc+0xb36>
    16da:	471030ef          	jal	534a <printf>
    exit(1);
    16de:	4505                	li	a0,1
    16e0:	01d030ef          	jal	4efc <exit>

00000000000016e4 <exitwait>:
{
    16e4:	715d                	addi	sp,sp,-80
    16e6:	e486                	sd	ra,72(sp)
    16e8:	e0a2                	sd	s0,64(sp)
    16ea:	fc26                	sd	s1,56(sp)
    16ec:	f84a                	sd	s2,48(sp)
    16ee:	f44e                	sd	s3,40(sp)
    16f0:	f052                	sd	s4,32(sp)
    16f2:	ec56                	sd	s5,24(sp)
    16f4:	0880                	addi	s0,sp,80
    16f6:	8aaa                	mv	s5,a0
  for(i = 0; i < 100; i++){
    16f8:	4901                	li	s2,0
      if(wait(&xstate) != pid){
    16fa:	fbc40993          	addi	s3,s0,-68
  for(i = 0; i < 100; i++){
    16fe:	06400a13          	li	s4,100
    pid = fork();
    1702:	7f2030ef          	jal	4ef4 <fork>
    1706:	84aa                	mv	s1,a0
    if(pid < 0){
    1708:	02054863          	bltz	a0,1738 <exitwait+0x54>
    if(pid){
    170c:	c525                	beqz	a0,1774 <exitwait+0x90>
      if(wait(&xstate) != pid){
    170e:	854e                	mv	a0,s3
    1710:	7f4030ef          	jal	4f04 <wait>
    1714:	02951c63          	bne	a0,s1,174c <exitwait+0x68>
      if(i != xstate) {
    1718:	fbc42783          	lw	a5,-68(s0)
    171c:	05279263          	bne	a5,s2,1760 <exitwait+0x7c>
  for(i = 0; i < 100; i++){
    1720:	2905                	addiw	s2,s2,1
    1722:	ff4910e3          	bne	s2,s4,1702 <exitwait+0x1e>
}
    1726:	60a6                	ld	ra,72(sp)
    1728:	6406                	ld	s0,64(sp)
    172a:	74e2                	ld	s1,56(sp)
    172c:	7942                	ld	s2,48(sp)
    172e:	79a2                	ld	s3,40(sp)
    1730:	7a02                	ld	s4,32(sp)
    1732:	6ae2                	ld	s5,24(sp)
    1734:	6161                	addi	sp,sp,80
    1736:	8082                	ret
      printf("%s: fork failed\n", s);
    1738:	85d6                	mv	a1,s5
    173a:	00004517          	auipc	a0,0x4
    173e:	68e50513          	addi	a0,a0,1678 # 5dc8 <malloc+0x9c6>
    1742:	409030ef          	jal	534a <printf>
      exit(1);
    1746:	4505                	li	a0,1
    1748:	7b4030ef          	jal	4efc <exit>
        printf("%s: wait wrong pid\n", s);
    174c:	85d6                	mv	a1,s5
    174e:	00005517          	auipc	a0,0x5
    1752:	80250513          	addi	a0,a0,-2046 # 5f50 <malloc+0xb4e>
    1756:	3f5030ef          	jal	534a <printf>
        exit(1);
    175a:	4505                	li	a0,1
    175c:	7a0030ef          	jal	4efc <exit>
        printf("%s: wait wrong exit status\n", s);
    1760:	85d6                	mv	a1,s5
    1762:	00005517          	auipc	a0,0x5
    1766:	80650513          	addi	a0,a0,-2042 # 5f68 <malloc+0xb66>
    176a:	3e1030ef          	jal	534a <printf>
        exit(1);
    176e:	4505                	li	a0,1
    1770:	78c030ef          	jal	4efc <exit>
      exit(i);
    1774:	854a                	mv	a0,s2
    1776:	786030ef          	jal	4efc <exit>

000000000000177a <twochildren>:
{
    177a:	1101                	addi	sp,sp,-32
    177c:	ec06                	sd	ra,24(sp)
    177e:	e822                	sd	s0,16(sp)
    1780:	e426                	sd	s1,8(sp)
    1782:	e04a                	sd	s2,0(sp)
    1784:	1000                	addi	s0,sp,32
    1786:	892a                	mv	s2,a0
    1788:	3e800493          	li	s1,1000
    int pid1 = fork();
    178c:	768030ef          	jal	4ef4 <fork>
    if(pid1 < 0){
    1790:	02054663          	bltz	a0,17bc <twochildren+0x42>
    if(pid1 == 0){
    1794:	cd15                	beqz	a0,17d0 <twochildren+0x56>
      int pid2 = fork();
    1796:	75e030ef          	jal	4ef4 <fork>
      if(pid2 < 0){
    179a:	02054d63          	bltz	a0,17d4 <twochildren+0x5a>
      if(pid2 == 0){
    179e:	c529                	beqz	a0,17e8 <twochildren+0x6e>
        wait(0);
    17a0:	4501                	li	a0,0
    17a2:	762030ef          	jal	4f04 <wait>
        wait(0);
    17a6:	4501                	li	a0,0
    17a8:	75c030ef          	jal	4f04 <wait>
  for(int i = 0; i < 1000; i++){
    17ac:	34fd                	addiw	s1,s1,-1
    17ae:	fcf9                	bnez	s1,178c <twochildren+0x12>
}
    17b0:	60e2                	ld	ra,24(sp)
    17b2:	6442                	ld	s0,16(sp)
    17b4:	64a2                	ld	s1,8(sp)
    17b6:	6902                	ld	s2,0(sp)
    17b8:	6105                	addi	sp,sp,32
    17ba:	8082                	ret
      printf("%s: fork failed\n", s);
    17bc:	85ca                	mv	a1,s2
    17be:	00004517          	auipc	a0,0x4
    17c2:	60a50513          	addi	a0,a0,1546 # 5dc8 <malloc+0x9c6>
    17c6:	385030ef          	jal	534a <printf>
      exit(1);
    17ca:	4505                	li	a0,1
    17cc:	730030ef          	jal	4efc <exit>
      exit(0);
    17d0:	72c030ef          	jal	4efc <exit>
        printf("%s: fork failed\n", s);
    17d4:	85ca                	mv	a1,s2
    17d6:	00004517          	auipc	a0,0x4
    17da:	5f250513          	addi	a0,a0,1522 # 5dc8 <malloc+0x9c6>
    17de:	36d030ef          	jal	534a <printf>
        exit(1);
    17e2:	4505                	li	a0,1
    17e4:	718030ef          	jal	4efc <exit>
        exit(0);
    17e8:	714030ef          	jal	4efc <exit>

00000000000017ec <forkfork>:
{
    17ec:	7179                	addi	sp,sp,-48
    17ee:	f406                	sd	ra,40(sp)
    17f0:	f022                	sd	s0,32(sp)
    17f2:	ec26                	sd	s1,24(sp)
    17f4:	1800                	addi	s0,sp,48
    17f6:	84aa                	mv	s1,a0
    int pid = fork();
    17f8:	6fc030ef          	jal	4ef4 <fork>
    if(pid < 0){
    17fc:	02054b63          	bltz	a0,1832 <forkfork+0x46>
    if(pid == 0){
    1800:	c139                	beqz	a0,1846 <forkfork+0x5a>
    int pid = fork();
    1802:	6f2030ef          	jal	4ef4 <fork>
    if(pid < 0){
    1806:	02054663          	bltz	a0,1832 <forkfork+0x46>
    if(pid == 0){
    180a:	cd15                	beqz	a0,1846 <forkfork+0x5a>
    wait(&xstatus);
    180c:	fdc40513          	addi	a0,s0,-36
    1810:	6f4030ef          	jal	4f04 <wait>
    if(xstatus != 0) {
    1814:	fdc42783          	lw	a5,-36(s0)
    1818:	ebb9                	bnez	a5,186e <forkfork+0x82>
    wait(&xstatus);
    181a:	fdc40513          	addi	a0,s0,-36
    181e:	6e6030ef          	jal	4f04 <wait>
    if(xstatus != 0) {
    1822:	fdc42783          	lw	a5,-36(s0)
    1826:	e7a1                	bnez	a5,186e <forkfork+0x82>
}
    1828:	70a2                	ld	ra,40(sp)
    182a:	7402                	ld	s0,32(sp)
    182c:	64e2                	ld	s1,24(sp)
    182e:	6145                	addi	sp,sp,48
    1830:	8082                	ret
      printf("%s: fork failed", s);
    1832:	85a6                	mv	a1,s1
    1834:	00004517          	auipc	a0,0x4
    1838:	75450513          	addi	a0,a0,1876 # 5f88 <malloc+0xb86>
    183c:	30f030ef          	jal	534a <printf>
      exit(1);
    1840:	4505                	li	a0,1
    1842:	6ba030ef          	jal	4efc <exit>
{
    1846:	0c800493          	li	s1,200
        int pid1 = fork();
    184a:	6aa030ef          	jal	4ef4 <fork>
        if(pid1 < 0){
    184e:	00054b63          	bltz	a0,1864 <forkfork+0x78>
        if(pid1 == 0){
    1852:	cd01                	beqz	a0,186a <forkfork+0x7e>
        wait(0);
    1854:	4501                	li	a0,0
    1856:	6ae030ef          	jal	4f04 <wait>
      for(int j = 0; j < 200; j++){
    185a:	34fd                	addiw	s1,s1,-1
    185c:	f4fd                	bnez	s1,184a <forkfork+0x5e>
      exit(0);
    185e:	4501                	li	a0,0
    1860:	69c030ef          	jal	4efc <exit>
          exit(1);
    1864:	4505                	li	a0,1
    1866:	696030ef          	jal	4efc <exit>
          exit(0);
    186a:	692030ef          	jal	4efc <exit>
      printf("%s: fork in child failed", s);
    186e:	85a6                	mv	a1,s1
    1870:	00004517          	auipc	a0,0x4
    1874:	72850513          	addi	a0,a0,1832 # 5f98 <malloc+0xb96>
    1878:	2d3030ef          	jal	534a <printf>
      exit(1);
    187c:	4505                	li	a0,1
    187e:	67e030ef          	jal	4efc <exit>

0000000000001882 <reparent2>:
{
    1882:	1101                	addi	sp,sp,-32
    1884:	ec06                	sd	ra,24(sp)
    1886:	e822                	sd	s0,16(sp)
    1888:	e426                	sd	s1,8(sp)
    188a:	1000                	addi	s0,sp,32
    188c:	32000493          	li	s1,800
    int pid1 = fork();
    1890:	664030ef          	jal	4ef4 <fork>
    if(pid1 < 0){
    1894:	00054b63          	bltz	a0,18aa <reparent2+0x28>
    if(pid1 == 0){
    1898:	c115                	beqz	a0,18bc <reparent2+0x3a>
    wait(0);
    189a:	4501                	li	a0,0
    189c:	668030ef          	jal	4f04 <wait>
  for(int i = 0; i < 800; i++){
    18a0:	34fd                	addiw	s1,s1,-1
    18a2:	f4fd                	bnez	s1,1890 <reparent2+0xe>
  exit(0);
    18a4:	4501                	li	a0,0
    18a6:	656030ef          	jal	4efc <exit>
      printf("fork failed\n");
    18aa:	00006517          	auipc	a0,0x6
    18ae:	ac650513          	addi	a0,a0,-1338 # 7370 <malloc+0x1f6e>
    18b2:	299030ef          	jal	534a <printf>
      exit(1);
    18b6:	4505                	li	a0,1
    18b8:	644030ef          	jal	4efc <exit>
      fork();
    18bc:	638030ef          	jal	4ef4 <fork>
      fork();
    18c0:	634030ef          	jal	4ef4 <fork>
      exit(0);
    18c4:	4501                	li	a0,0
    18c6:	636030ef          	jal	4efc <exit>

00000000000018ca <createdelete>:
{
    18ca:	7135                	addi	sp,sp,-160
    18cc:	ed06                	sd	ra,152(sp)
    18ce:	e922                	sd	s0,144(sp)
    18d0:	e526                	sd	s1,136(sp)
    18d2:	e14a                	sd	s2,128(sp)
    18d4:	fcce                	sd	s3,120(sp)
    18d6:	f8d2                	sd	s4,112(sp)
    18d8:	f4d6                	sd	s5,104(sp)
    18da:	f0da                	sd	s6,96(sp)
    18dc:	ecde                	sd	s7,88(sp)
    18de:	e8e2                	sd	s8,80(sp)
    18e0:	e4e6                	sd	s9,72(sp)
    18e2:	e0ea                	sd	s10,64(sp)
    18e4:	fc6e                	sd	s11,56(sp)
    18e6:	1100                	addi	s0,sp,160
    18e8:	8daa                	mv	s11,a0
  for(pi = 0; pi < NCHILD; pi++){
    18ea:	4901                	li	s2,0
    18ec:	4991                	li	s3,4
    pid = fork();
    18ee:	606030ef          	jal	4ef4 <fork>
    18f2:	84aa                	mv	s1,a0
    if(pid < 0){
    18f4:	04054063          	bltz	a0,1934 <createdelete+0x6a>
    if(pid == 0){
    18f8:	c921                	beqz	a0,1948 <createdelete+0x7e>
  for(pi = 0; pi < NCHILD; pi++){
    18fa:	2905                	addiw	s2,s2,1
    18fc:	ff3919e3          	bne	s2,s3,18ee <createdelete+0x24>
    1900:	4491                	li	s1,4
    wait(&xstatus);
    1902:	f6c40913          	addi	s2,s0,-148
    1906:	854a                	mv	a0,s2
    1908:	5fc030ef          	jal	4f04 <wait>
    if(xstatus != 0)
    190c:	f6c42a83          	lw	s5,-148(s0)
    1910:	0c0a9263          	bnez	s5,19d4 <createdelete+0x10a>
  for(pi = 0; pi < NCHILD; pi++){
    1914:	34fd                	addiw	s1,s1,-1
    1916:	f8e5                	bnez	s1,1906 <createdelete+0x3c>
  name[0] = name[1] = name[2] = 0;
    1918:	f6040923          	sb	zero,-142(s0)
    191c:	03000913          	li	s2,48
    1920:	5a7d                	li	s4,-1
      if((i == 0 || i >= N/2) && fd < 0){
    1922:	4d25                	li	s10,9
    1924:	07000c93          	li	s9,112
      fd = open(name, 0);
    1928:	f7040c13          	addi	s8,s0,-144
      } else if((i >= 1 && i < N/2) && fd >= 0){
    192c:	4ba1                	li	s7,8
    for(pi = 0; pi < NCHILD; pi++){
    192e:	07400b13          	li	s6,116
    1932:	aa39                	j	1a50 <createdelete+0x186>
      printf("%s: fork failed\n", s);
    1934:	85ee                	mv	a1,s11
    1936:	00004517          	auipc	a0,0x4
    193a:	49250513          	addi	a0,a0,1170 # 5dc8 <malloc+0x9c6>
    193e:	20d030ef          	jal	534a <printf>
      exit(1);
    1942:	4505                	li	a0,1
    1944:	5b8030ef          	jal	4efc <exit>
      name[0] = 'p' + pi;
    1948:	0709091b          	addiw	s2,s2,112
    194c:	f7240823          	sb	s2,-144(s0)
      name[2] = '\0';
    1950:	f6040923          	sb	zero,-142(s0)
        fd = open(name, O_CREATE | O_RDWR);
    1954:	f7040913          	addi	s2,s0,-144
    1958:	20200993          	li	s3,514
      for(i = 0; i < N; i++){
    195c:	4a51                	li	s4,20
    195e:	a815                	j	1992 <createdelete+0xc8>
          printf("%s: create failed\n", s);
    1960:	85ee                	mv	a1,s11
    1962:	00004517          	auipc	a0,0x4
    1966:	4fe50513          	addi	a0,a0,1278 # 5e60 <malloc+0xa5e>
    196a:	1e1030ef          	jal	534a <printf>
          exit(1);
    196e:	4505                	li	a0,1
    1970:	58c030ef          	jal	4efc <exit>
          name[1] = '0' + (i / 2);
    1974:	01f4d79b          	srliw	a5,s1,0x1f
    1978:	9fa5                	addw	a5,a5,s1
    197a:	4017d79b          	sraiw	a5,a5,0x1
    197e:	0307879b          	addiw	a5,a5,48
    1982:	f6f408a3          	sb	a5,-143(s0)
          if(unlink(name) < 0){
    1986:	854a                	mv	a0,s2
    1988:	5c4030ef          	jal	4f4c <unlink>
    198c:	02054a63          	bltz	a0,19c0 <createdelete+0xf6>
      for(i = 0; i < N; i++){
    1990:	2485                	addiw	s1,s1,1
        name[1] = '0' + i;
    1992:	0304879b          	addiw	a5,s1,48
    1996:	f6f408a3          	sb	a5,-143(s0)
        fd = open(name, O_CREATE | O_RDWR);
    199a:	85ce                	mv	a1,s3
    199c:	854a                	mv	a0,s2
    199e:	59e030ef          	jal	4f3c <open>
        if(fd < 0){
    19a2:	fa054fe3          	bltz	a0,1960 <createdelete+0x96>
        close(fd);
    19a6:	57e030ef          	jal	4f24 <close>
        if(i > 0 && (i % 2 ) == 0){
    19aa:	fe9053e3          	blez	s1,1990 <createdelete+0xc6>
    19ae:	0014f793          	andi	a5,s1,1
    19b2:	d3e9                	beqz	a5,1974 <createdelete+0xaa>
      for(i = 0; i < N; i++){
    19b4:	2485                	addiw	s1,s1,1
    19b6:	fd449ee3          	bne	s1,s4,1992 <createdelete+0xc8>
      exit(0);
    19ba:	4501                	li	a0,0
    19bc:	540030ef          	jal	4efc <exit>
            printf("%s: unlink failed\n", s);
    19c0:	85ee                	mv	a1,s11
    19c2:	00004517          	auipc	a0,0x4
    19c6:	5f650513          	addi	a0,a0,1526 # 5fb8 <malloc+0xbb6>
    19ca:	181030ef          	jal	534a <printf>
            exit(1);
    19ce:	4505                	li	a0,1
    19d0:	52c030ef          	jal	4efc <exit>
      exit(1);
    19d4:	4505                	li	a0,1
    19d6:	526030ef          	jal	4efc <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    19da:	054bf263          	bgeu	s7,s4,1a1e <createdelete+0x154>
      if(fd >= 0)
    19de:	04055e63          	bgez	a0,1a3a <createdelete+0x170>
    for(pi = 0; pi < NCHILD; pi++){
    19e2:	2485                	addiw	s1,s1,1
    19e4:	0ff4f493          	zext.b	s1,s1
    19e8:	05648c63          	beq	s1,s6,1a40 <createdelete+0x176>
      name[0] = 'p' + pi;
    19ec:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    19f0:	f72408a3          	sb	s2,-143(s0)
      fd = open(name, 0);
    19f4:	4581                	li	a1,0
    19f6:	8562                	mv	a0,s8
    19f8:	544030ef          	jal	4f3c <open>
      if((i == 0 || i >= N/2) && fd < 0){
    19fc:	01f5579b          	srliw	a5,a0,0x1f
    1a00:	dfe9                	beqz	a5,19da <createdelete+0x110>
    1a02:	fc098ce3          	beqz	s3,19da <createdelete+0x110>
        printf("%s: oops createdelete %s didn't exist\n", s, name);
    1a06:	f7040613          	addi	a2,s0,-144
    1a0a:	85ee                	mv	a1,s11
    1a0c:	00004517          	auipc	a0,0x4
    1a10:	5c450513          	addi	a0,a0,1476 # 5fd0 <malloc+0xbce>
    1a14:	137030ef          	jal	534a <printf>
        exit(1);
    1a18:	4505                	li	a0,1
    1a1a:	4e2030ef          	jal	4efc <exit>
      } else if((i >= 1 && i < N/2) && fd >= 0){
    1a1e:	fc0542e3          	bltz	a0,19e2 <createdelete+0x118>
        printf("%s: oops createdelete %s did exist\n", s, name);
    1a22:	f7040613          	addi	a2,s0,-144
    1a26:	85ee                	mv	a1,s11
    1a28:	00004517          	auipc	a0,0x4
    1a2c:	5d050513          	addi	a0,a0,1488 # 5ff8 <malloc+0xbf6>
    1a30:	11b030ef          	jal	534a <printf>
        exit(1);
    1a34:	4505                	li	a0,1
    1a36:	4c6030ef          	jal	4efc <exit>
        close(fd);
    1a3a:	4ea030ef          	jal	4f24 <close>
    1a3e:	b755                	j	19e2 <createdelete+0x118>
  for(i = 0; i < N; i++){
    1a40:	2a85                	addiw	s5,s5,1
    1a42:	2a05                	addiw	s4,s4,1
    1a44:	2905                	addiw	s2,s2,1
    1a46:	0ff97913          	zext.b	s2,s2
    1a4a:	47d1                	li	a5,20
    1a4c:	00fa8a63          	beq	s5,a5,1a60 <createdelete+0x196>
      if((i == 0 || i >= N/2) && fd < 0){
    1a50:	001ab993          	seqz	s3,s5
    1a54:	015d27b3          	slt	a5,s10,s5
    1a58:	00f9e9b3          	or	s3,s3,a5
    1a5c:	84e6                	mv	s1,s9
    1a5e:	b779                	j	19ec <createdelete+0x122>
    1a60:	03000913          	li	s2,48
  name[0] = name[1] = name[2] = 0;
    1a64:	07000b13          	li	s6,112
      unlink(name);
    1a68:	f7040a13          	addi	s4,s0,-144
    for(pi = 0; pi < NCHILD; pi++){
    1a6c:	07400993          	li	s3,116
  for(i = 0; i < N; i++){
    1a70:	04400a93          	li	s5,68
  name[0] = name[1] = name[2] = 0;
    1a74:	84da                	mv	s1,s6
      name[0] = 'p' + pi;
    1a76:	f6940823          	sb	s1,-144(s0)
      name[1] = '0' + i;
    1a7a:	f72408a3          	sb	s2,-143(s0)
      unlink(name);
    1a7e:	8552                	mv	a0,s4
    1a80:	4cc030ef          	jal	4f4c <unlink>
    for(pi = 0; pi < NCHILD; pi++){
    1a84:	2485                	addiw	s1,s1,1
    1a86:	0ff4f493          	zext.b	s1,s1
    1a8a:	ff3496e3          	bne	s1,s3,1a76 <createdelete+0x1ac>
  for(i = 0; i < N; i++){
    1a8e:	2905                	addiw	s2,s2,1
    1a90:	0ff97913          	zext.b	s2,s2
    1a94:	ff5910e3          	bne	s2,s5,1a74 <createdelete+0x1aa>
}
    1a98:	60ea                	ld	ra,152(sp)
    1a9a:	644a                	ld	s0,144(sp)
    1a9c:	64aa                	ld	s1,136(sp)
    1a9e:	690a                	ld	s2,128(sp)
    1aa0:	79e6                	ld	s3,120(sp)
    1aa2:	7a46                	ld	s4,112(sp)
    1aa4:	7aa6                	ld	s5,104(sp)
    1aa6:	7b06                	ld	s6,96(sp)
    1aa8:	6be6                	ld	s7,88(sp)
    1aaa:	6c46                	ld	s8,80(sp)
    1aac:	6ca6                	ld	s9,72(sp)
    1aae:	6d06                	ld	s10,64(sp)
    1ab0:	7de2                	ld	s11,56(sp)
    1ab2:	610d                	addi	sp,sp,160
    1ab4:	8082                	ret

0000000000001ab6 <linkunlink>:
{
    1ab6:	711d                	addi	sp,sp,-96
    1ab8:	ec86                	sd	ra,88(sp)
    1aba:	e8a2                	sd	s0,80(sp)
    1abc:	e4a6                	sd	s1,72(sp)
    1abe:	e0ca                	sd	s2,64(sp)
    1ac0:	fc4e                	sd	s3,56(sp)
    1ac2:	f852                	sd	s4,48(sp)
    1ac4:	f456                	sd	s5,40(sp)
    1ac6:	f05a                	sd	s6,32(sp)
    1ac8:	ec5e                	sd	s7,24(sp)
    1aca:	e862                	sd	s8,16(sp)
    1acc:	e466                	sd	s9,8(sp)
    1ace:	e06a                	sd	s10,0(sp)
    1ad0:	1080                	addi	s0,sp,96
    1ad2:	84aa                	mv	s1,a0
  unlink("x");
    1ad4:	00004517          	auipc	a0,0x4
    1ad8:	ad450513          	addi	a0,a0,-1324 # 55a8 <malloc+0x1a6>
    1adc:	470030ef          	jal	4f4c <unlink>
  pid = fork();
    1ae0:	414030ef          	jal	4ef4 <fork>
  if(pid < 0){
    1ae4:	04054363          	bltz	a0,1b2a <linkunlink+0x74>
    1ae8:	8d2a                	mv	s10,a0
  unsigned int x = (pid ? 1 : 97);
    1aea:	06100913          	li	s2,97
    1aee:	c111                	beqz	a0,1af2 <linkunlink+0x3c>
    1af0:	4905                	li	s2,1
    1af2:	06400493          	li	s1,100
    x = x * 1103515245 + 12345;
    1af6:	41c65ab7          	lui	s5,0x41c65
    1afa:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c561c5>
    1afe:	6a0d                	lui	s4,0x3
    1b00:	039a0a1b          	addiw	s4,s4,57 # 3039 <subdir+0x333>
    if((x % 3) == 0){
    1b04:	000ab9b7          	lui	s3,0xab
    1b08:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0x9be03>
    1b0c:	09b2                	slli	s3,s3,0xc
    1b0e:	aab98993          	addi	s3,s3,-1365
    } else if((x % 3) == 1){
    1b12:	4b85                	li	s7,1
      unlink("x");
    1b14:	00004b17          	auipc	s6,0x4
    1b18:	a94b0b13          	addi	s6,s6,-1388 # 55a8 <malloc+0x1a6>
      link("cat", "x");
    1b1c:	00004c97          	auipc	s9,0x4
    1b20:	504c8c93          	addi	s9,s9,1284 # 6020 <malloc+0xc1e>
      close(open("x", O_RDWR | O_CREATE));
    1b24:	20200c13          	li	s8,514
    1b28:	a03d                	j	1b56 <linkunlink+0xa0>
    printf("%s: fork failed\n", s);
    1b2a:	85a6                	mv	a1,s1
    1b2c:	00004517          	auipc	a0,0x4
    1b30:	29c50513          	addi	a0,a0,668 # 5dc8 <malloc+0x9c6>
    1b34:	017030ef          	jal	534a <printf>
    exit(1);
    1b38:	4505                	li	a0,1
    1b3a:	3c2030ef          	jal	4efc <exit>
      close(open("x", O_RDWR | O_CREATE));
    1b3e:	85e2                	mv	a1,s8
    1b40:	855a                	mv	a0,s6
    1b42:	3fa030ef          	jal	4f3c <open>
    1b46:	3de030ef          	jal	4f24 <close>
    1b4a:	a021                	j	1b52 <linkunlink+0x9c>
      unlink("x");
    1b4c:	855a                	mv	a0,s6
    1b4e:	3fe030ef          	jal	4f4c <unlink>
  for(i = 0; i < 100; i++){
    1b52:	34fd                	addiw	s1,s1,-1
    1b54:	c885                	beqz	s1,1b84 <linkunlink+0xce>
    x = x * 1103515245 + 12345;
    1b56:	035907bb          	mulw	a5,s2,s5
    1b5a:	00fa07bb          	addw	a5,s4,a5
    1b5e:	893e                	mv	s2,a5
    if((x % 3) == 0){
    1b60:	02079713          	slli	a4,a5,0x20
    1b64:	9301                	srli	a4,a4,0x20
    1b66:	03370733          	mul	a4,a4,s3
    1b6a:	9305                	srli	a4,a4,0x21
    1b6c:	0017169b          	slliw	a3,a4,0x1
    1b70:	9f35                	addw	a4,a4,a3
    1b72:	9f99                	subw	a5,a5,a4
    1b74:	d7e9                	beqz	a5,1b3e <linkunlink+0x88>
    } else if((x % 3) == 1){
    1b76:	fd779be3          	bne	a5,s7,1b4c <linkunlink+0x96>
      link("cat", "x");
    1b7a:	85da                	mv	a1,s6
    1b7c:	8566                	mv	a0,s9
    1b7e:	3de030ef          	jal	4f5c <link>
    1b82:	bfc1                	j	1b52 <linkunlink+0x9c>
  if(pid)
    1b84:	020d0363          	beqz	s10,1baa <linkunlink+0xf4>
    wait(0);
    1b88:	4501                	li	a0,0
    1b8a:	37a030ef          	jal	4f04 <wait>
}
    1b8e:	60e6                	ld	ra,88(sp)
    1b90:	6446                	ld	s0,80(sp)
    1b92:	64a6                	ld	s1,72(sp)
    1b94:	6906                	ld	s2,64(sp)
    1b96:	79e2                	ld	s3,56(sp)
    1b98:	7a42                	ld	s4,48(sp)
    1b9a:	7aa2                	ld	s5,40(sp)
    1b9c:	7b02                	ld	s6,32(sp)
    1b9e:	6be2                	ld	s7,24(sp)
    1ba0:	6c42                	ld	s8,16(sp)
    1ba2:	6ca2                	ld	s9,8(sp)
    1ba4:	6d02                	ld	s10,0(sp)
    1ba6:	6125                	addi	sp,sp,96
    1ba8:	8082                	ret
    exit(0);
    1baa:	4501                	li	a0,0
    1bac:	350030ef          	jal	4efc <exit>

0000000000001bb0 <forktest>:
{
    1bb0:	7179                	addi	sp,sp,-48
    1bb2:	f406                	sd	ra,40(sp)
    1bb4:	f022                	sd	s0,32(sp)
    1bb6:	ec26                	sd	s1,24(sp)
    1bb8:	e84a                	sd	s2,16(sp)
    1bba:	e44e                	sd	s3,8(sp)
    1bbc:	1800                	addi	s0,sp,48
    1bbe:	89aa                	mv	s3,a0
  for(n=0; n<N; n++){
    1bc0:	4481                	li	s1,0
    1bc2:	3e800913          	li	s2,1000
    pid = fork();
    1bc6:	32e030ef          	jal	4ef4 <fork>
    if(pid < 0)
    1bca:	06054063          	bltz	a0,1c2a <forktest+0x7a>
    if(pid == 0)
    1bce:	cd11                	beqz	a0,1bea <forktest+0x3a>
  for(n=0; n<N; n++){
    1bd0:	2485                	addiw	s1,s1,1
    1bd2:	ff249ae3          	bne	s1,s2,1bc6 <forktest+0x16>
    printf("%s: fork claimed to work 1000 times!\n", s);
    1bd6:	85ce                	mv	a1,s3
    1bd8:	00004517          	auipc	a0,0x4
    1bdc:	49850513          	addi	a0,a0,1176 # 6070 <malloc+0xc6e>
    1be0:	76a030ef          	jal	534a <printf>
    exit(1);
    1be4:	4505                	li	a0,1
    1be6:	316030ef          	jal	4efc <exit>
      exit(0);
    1bea:	312030ef          	jal	4efc <exit>
    printf("%s: no fork at all!\n", s);
    1bee:	85ce                	mv	a1,s3
    1bf0:	00004517          	auipc	a0,0x4
    1bf4:	43850513          	addi	a0,a0,1080 # 6028 <malloc+0xc26>
    1bf8:	752030ef          	jal	534a <printf>
    exit(1);
    1bfc:	4505                	li	a0,1
    1bfe:	2fe030ef          	jal	4efc <exit>
      printf("%s: wait stopped early\n", s);
    1c02:	85ce                	mv	a1,s3
    1c04:	00004517          	auipc	a0,0x4
    1c08:	43c50513          	addi	a0,a0,1084 # 6040 <malloc+0xc3e>
    1c0c:	73e030ef          	jal	534a <printf>
      exit(1);
    1c10:	4505                	li	a0,1
    1c12:	2ea030ef          	jal	4efc <exit>
    printf("%s: wait got too many\n", s);
    1c16:	85ce                	mv	a1,s3
    1c18:	00004517          	auipc	a0,0x4
    1c1c:	44050513          	addi	a0,a0,1088 # 6058 <malloc+0xc56>
    1c20:	72a030ef          	jal	534a <printf>
    exit(1);
    1c24:	4505                	li	a0,1
    1c26:	2d6030ef          	jal	4efc <exit>
  if (n == 0) {
    1c2a:	d0f1                	beqz	s1,1bee <forktest+0x3e>
  for(; n > 0; n--){
    1c2c:	00905963          	blez	s1,1c3e <forktest+0x8e>
    if(wait(0) < 0){
    1c30:	4501                	li	a0,0
    1c32:	2d2030ef          	jal	4f04 <wait>
    1c36:	fc0546e3          	bltz	a0,1c02 <forktest+0x52>
  for(; n > 0; n--){
    1c3a:	34fd                	addiw	s1,s1,-1
    1c3c:	f8f5                	bnez	s1,1c30 <forktest+0x80>
  if(wait(0) != -1){
    1c3e:	4501                	li	a0,0
    1c40:	2c4030ef          	jal	4f04 <wait>
    1c44:	57fd                	li	a5,-1
    1c46:	fcf518e3          	bne	a0,a5,1c16 <forktest+0x66>
}
    1c4a:	70a2                	ld	ra,40(sp)
    1c4c:	7402                	ld	s0,32(sp)
    1c4e:	64e2                	ld	s1,24(sp)
    1c50:	6942                	ld	s2,16(sp)
    1c52:	69a2                	ld	s3,8(sp)
    1c54:	6145                	addi	sp,sp,48
    1c56:	8082                	ret

0000000000001c58 <kernmem>:
{
    1c58:	715d                	addi	sp,sp,-80
    1c5a:	e486                	sd	ra,72(sp)
    1c5c:	e0a2                	sd	s0,64(sp)
    1c5e:	fc26                	sd	s1,56(sp)
    1c60:	f84a                	sd	s2,48(sp)
    1c62:	f44e                	sd	s3,40(sp)
    1c64:	f052                	sd	s4,32(sp)
    1c66:	ec56                	sd	s5,24(sp)
    1c68:	e85a                	sd	s6,16(sp)
    1c6a:	0880                	addi	s0,sp,80
    1c6c:	8b2a                	mv	s6,a0
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c6e:	4485                	li	s1,1
    1c70:	04fe                	slli	s1,s1,0x1f
    wait(&xstatus);
    1c72:	fbc40a93          	addi	s5,s0,-68
    if(xstatus != -1)  // did kernel kill child?
    1c76:	5a7d                	li	s4,-1
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1c78:	69b1                	lui	s3,0xc
    1c7a:	35098993          	addi	s3,s3,848 # c350 <buf+0x6a8>
    1c7e:	1003d937          	lui	s2,0x1003d
    1c82:	090e                	slli	s2,s2,0x3
    1c84:	48090913          	addi	s2,s2,1152 # 1003d480 <base+0x1002e7d8>
    pid = fork();
    1c88:	26c030ef          	jal	4ef4 <fork>
    if(pid < 0){
    1c8c:	02054763          	bltz	a0,1cba <kernmem+0x62>
    if(pid == 0){
    1c90:	cd1d                	beqz	a0,1cce <kernmem+0x76>
    wait(&xstatus);
    1c92:	8556                	mv	a0,s5
    1c94:	270030ef          	jal	4f04 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1c98:	fbc42783          	lw	a5,-68(s0)
    1c9c:	05479663          	bne	a5,s4,1ce8 <kernmem+0x90>
  for(a = (char*)(KERNBASE); a < (char*) (KERNBASE+2000000); a += 50000){
    1ca0:	94ce                	add	s1,s1,s3
    1ca2:	ff2493e3          	bne	s1,s2,1c88 <kernmem+0x30>
}
    1ca6:	60a6                	ld	ra,72(sp)
    1ca8:	6406                	ld	s0,64(sp)
    1caa:	74e2                	ld	s1,56(sp)
    1cac:	7942                	ld	s2,48(sp)
    1cae:	79a2                	ld	s3,40(sp)
    1cb0:	7a02                	ld	s4,32(sp)
    1cb2:	6ae2                	ld	s5,24(sp)
    1cb4:	6b42                	ld	s6,16(sp)
    1cb6:	6161                	addi	sp,sp,80
    1cb8:	8082                	ret
      printf("%s: fork failed\n", s);
    1cba:	85da                	mv	a1,s6
    1cbc:	00004517          	auipc	a0,0x4
    1cc0:	10c50513          	addi	a0,a0,268 # 5dc8 <malloc+0x9c6>
    1cc4:	686030ef          	jal	534a <printf>
      exit(1);
    1cc8:	4505                	li	a0,1
    1cca:	232030ef          	jal	4efc <exit>
      printf("%s: oops could read %p = %x\n", s, a, *a);
    1cce:	0004c683          	lbu	a3,0(s1)
    1cd2:	8626                	mv	a2,s1
    1cd4:	85da                	mv	a1,s6
    1cd6:	00004517          	auipc	a0,0x4
    1cda:	3c250513          	addi	a0,a0,962 # 6098 <malloc+0xc96>
    1cde:	66c030ef          	jal	534a <printf>
      exit(1);
    1ce2:	4505                	li	a0,1
    1ce4:	218030ef          	jal	4efc <exit>
      exit(1);
    1ce8:	4505                	li	a0,1
    1cea:	212030ef          	jal	4efc <exit>

0000000000001cee <MAXVAplus>:
{
    1cee:	7139                	addi	sp,sp,-64
    1cf0:	fc06                	sd	ra,56(sp)
    1cf2:	f822                	sd	s0,48(sp)
    1cf4:	0080                	addi	s0,sp,64
  volatile uint64 a = MAXVA;
    1cf6:	4785                	li	a5,1
    1cf8:	179a                	slli	a5,a5,0x26
    1cfa:	fcf43423          	sd	a5,-56(s0)
  for( ; a != 0; a <<= 1){
    1cfe:	fc843783          	ld	a5,-56(s0)
    1d02:	cf9d                	beqz	a5,1d40 <MAXVAplus+0x52>
    1d04:	f426                	sd	s1,40(sp)
    1d06:	f04a                	sd	s2,32(sp)
    1d08:	ec4e                	sd	s3,24(sp)
    1d0a:	89aa                	mv	s3,a0
    wait(&xstatus);
    1d0c:	fc440913          	addi	s2,s0,-60
    if(xstatus != -1)  // did kernel kill child?
    1d10:	54fd                	li	s1,-1
    pid = fork();
    1d12:	1e2030ef          	jal	4ef4 <fork>
    if(pid < 0){
    1d16:	02054963          	bltz	a0,1d48 <MAXVAplus+0x5a>
    if(pid == 0){
    1d1a:	c129                	beqz	a0,1d5c <MAXVAplus+0x6e>
    wait(&xstatus);
    1d1c:	854a                	mv	a0,s2
    1d1e:	1e6030ef          	jal	4f04 <wait>
    if(xstatus != -1)  // did kernel kill child?
    1d22:	fc442783          	lw	a5,-60(s0)
    1d26:	04979d63          	bne	a5,s1,1d80 <MAXVAplus+0x92>
  for( ; a != 0; a <<= 1){
    1d2a:	fc843783          	ld	a5,-56(s0)
    1d2e:	0786                	slli	a5,a5,0x1
    1d30:	fcf43423          	sd	a5,-56(s0)
    1d34:	fc843783          	ld	a5,-56(s0)
    1d38:	ffe9                	bnez	a5,1d12 <MAXVAplus+0x24>
    1d3a:	74a2                	ld	s1,40(sp)
    1d3c:	7902                	ld	s2,32(sp)
    1d3e:	69e2                	ld	s3,24(sp)
}
    1d40:	70e2                	ld	ra,56(sp)
    1d42:	7442                	ld	s0,48(sp)
    1d44:	6121                	addi	sp,sp,64
    1d46:	8082                	ret
      printf("%s: fork failed\n", s);
    1d48:	85ce                	mv	a1,s3
    1d4a:	00004517          	auipc	a0,0x4
    1d4e:	07e50513          	addi	a0,a0,126 # 5dc8 <malloc+0x9c6>
    1d52:	5f8030ef          	jal	534a <printf>
      exit(1);
    1d56:	4505                	li	a0,1
    1d58:	1a4030ef          	jal	4efc <exit>
      *(char*)a = 99;
    1d5c:	fc843783          	ld	a5,-56(s0)
    1d60:	06300713          	li	a4,99
    1d64:	00e78023          	sb	a4,0(a5)
      printf("%s: oops wrote %p\n", s, (void*)a);
    1d68:	fc843603          	ld	a2,-56(s0)
    1d6c:	85ce                	mv	a1,s3
    1d6e:	00004517          	auipc	a0,0x4
    1d72:	34a50513          	addi	a0,a0,842 # 60b8 <malloc+0xcb6>
    1d76:	5d4030ef          	jal	534a <printf>
      exit(1);
    1d7a:	4505                	li	a0,1
    1d7c:	180030ef          	jal	4efc <exit>
      exit(1);
    1d80:	4505                	li	a0,1
    1d82:	17a030ef          	jal	4efc <exit>

0000000000001d86 <stacktest>:
{
    1d86:	7179                	addi	sp,sp,-48
    1d88:	f406                	sd	ra,40(sp)
    1d8a:	f022                	sd	s0,32(sp)
    1d8c:	ec26                	sd	s1,24(sp)
    1d8e:	1800                	addi	s0,sp,48
    1d90:	84aa                	mv	s1,a0
  pid = fork();
    1d92:	162030ef          	jal	4ef4 <fork>
  if(pid == 0) {
    1d96:	cd11                	beqz	a0,1db2 <stacktest+0x2c>
  } else if(pid < 0){
    1d98:	02054c63          	bltz	a0,1dd0 <stacktest+0x4a>
  wait(&xstatus);
    1d9c:	fdc40513          	addi	a0,s0,-36
    1da0:	164030ef          	jal	4f04 <wait>
  if(xstatus == -1)  // kernel killed child?
    1da4:	fdc42503          	lw	a0,-36(s0)
    1da8:	57fd                	li	a5,-1
    1daa:	02f50d63          	beq	a0,a5,1de4 <stacktest+0x5e>
    exit(xstatus);
    1dae:	14e030ef          	jal	4efc <exit>

static inline uint64
r_sp()
{
  uint64 x;
  asm volatile("mv %0, sp" : "=r" (x) );
    1db2:	878a                	mv	a5,sp
    printf("%s: stacktest: read below stack %d\n", s, *sp);
    1db4:	80078793          	addi	a5,a5,-2048
    1db8:	8007c603          	lbu	a2,-2048(a5)
    1dbc:	85a6                	mv	a1,s1
    1dbe:	00004517          	auipc	a0,0x4
    1dc2:	31250513          	addi	a0,a0,786 # 60d0 <malloc+0xcce>
    1dc6:	584030ef          	jal	534a <printf>
    exit(1);
    1dca:	4505                	li	a0,1
    1dcc:	130030ef          	jal	4efc <exit>
    printf("%s: fork failed\n", s);
    1dd0:	85a6                	mv	a1,s1
    1dd2:	00004517          	auipc	a0,0x4
    1dd6:	ff650513          	addi	a0,a0,-10 # 5dc8 <malloc+0x9c6>
    1dda:	570030ef          	jal	534a <printf>
    exit(1);
    1dde:	4505                	li	a0,1
    1de0:	11c030ef          	jal	4efc <exit>
    exit(0);
    1de4:	4501                	li	a0,0
    1de6:	116030ef          	jal	4efc <exit>

0000000000001dea <nowrite>:
{
    1dea:	7159                	addi	sp,sp,-112
    1dec:	f486                	sd	ra,104(sp)
    1dee:	f0a2                	sd	s0,96(sp)
    1df0:	eca6                	sd	s1,88(sp)
    1df2:	e8ca                	sd	s2,80(sp)
    1df4:	e4ce                	sd	s3,72(sp)
    1df6:	e0d2                	sd	s4,64(sp)
    1df8:	1880                	addi	s0,sp,112
    1dfa:	8a2a                	mv	s4,a0
  uint64 addrs[] = { 0, 0x80000000LL, 0x3fffffe000, 0x3ffffff000, 0x4000000000,
    1dfc:	00006797          	auipc	a5,0x6
    1e00:	b8c78793          	addi	a5,a5,-1140 # 7988 <malloc+0x2586>
    1e04:	7788                	ld	a0,40(a5)
    1e06:	7b8c                	ld	a1,48(a5)
    1e08:	7f90                	ld	a2,56(a5)
    1e0a:	63b4                	ld	a3,64(a5)
    1e0c:	67b8                	ld	a4,72(a5)
    1e0e:	f8a43c23          	sd	a0,-104(s0)
    1e12:	fab43023          	sd	a1,-96(s0)
    1e16:	fac43423          	sd	a2,-88(s0)
    1e1a:	fad43823          	sd	a3,-80(s0)
    1e1e:	fae43c23          	sd	a4,-72(s0)
    1e22:	6bbc                	ld	a5,80(a5)
    1e24:	fcf43023          	sd	a5,-64(s0)
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e28:	4481                	li	s1,0
    wait(&xstatus);
    1e2a:	fcc40913          	addi	s2,s0,-52
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e2e:	4999                	li	s3,6
    pid = fork();
    1e30:	0c4030ef          	jal	4ef4 <fork>
    if(pid == 0) {
    1e34:	cd19                	beqz	a0,1e52 <nowrite+0x68>
    } else if(pid < 0){
    1e36:	04054163          	bltz	a0,1e78 <nowrite+0x8e>
    wait(&xstatus);
    1e3a:	854a                	mv	a0,s2
    1e3c:	0c8030ef          	jal	4f04 <wait>
    if(xstatus == 0){
    1e40:	fcc42783          	lw	a5,-52(s0)
    1e44:	c7a1                	beqz	a5,1e8c <nowrite+0xa2>
  for(int ai = 0; ai < sizeof(addrs)/sizeof(addrs[0]); ai++){
    1e46:	2485                	addiw	s1,s1,1
    1e48:	ff3494e3          	bne	s1,s3,1e30 <nowrite+0x46>
  exit(0);
    1e4c:	4501                	li	a0,0
    1e4e:	0ae030ef          	jal	4efc <exit>
      volatile int *addr = (int *) addrs[ai];
    1e52:	048e                	slli	s1,s1,0x3
    1e54:	fd048793          	addi	a5,s1,-48
    1e58:	008784b3          	add	s1,a5,s0
    1e5c:	fc84b603          	ld	a2,-56(s1)
      *addr = 10;
    1e60:	47a9                	li	a5,10
    1e62:	c21c                	sw	a5,0(a2)
      printf("%s: write to %p did not fail!\n", s, addr);
    1e64:	85d2                	mv	a1,s4
    1e66:	00004517          	auipc	a0,0x4
    1e6a:	29250513          	addi	a0,a0,658 # 60f8 <malloc+0xcf6>
    1e6e:	4dc030ef          	jal	534a <printf>
      exit(0);
    1e72:	4501                	li	a0,0
    1e74:	088030ef          	jal	4efc <exit>
      printf("%s: fork failed\n", s);
    1e78:	85d2                	mv	a1,s4
    1e7a:	00004517          	auipc	a0,0x4
    1e7e:	f4e50513          	addi	a0,a0,-178 # 5dc8 <malloc+0x9c6>
    1e82:	4c8030ef          	jal	534a <printf>
      exit(1);
    1e86:	4505                	li	a0,1
    1e88:	074030ef          	jal	4efc <exit>
      exit(1);
    1e8c:	4505                	li	a0,1
    1e8e:	06e030ef          	jal	4efc <exit>

0000000000001e92 <manywrites>:
{
    1e92:	7159                	addi	sp,sp,-112
    1e94:	f486                	sd	ra,104(sp)
    1e96:	f0a2                	sd	s0,96(sp)
    1e98:	eca6                	sd	s1,88(sp)
    1e9a:	e8ca                	sd	s2,80(sp)
    1e9c:	e4ce                	sd	s3,72(sp)
    1e9e:	ec66                	sd	s9,24(sp)
    1ea0:	1880                	addi	s0,sp,112
    1ea2:	8caa                	mv	s9,a0
  for(int ci = 0; ci < nchildren; ci++){
    1ea4:	4901                	li	s2,0
    1ea6:	4991                	li	s3,4
    int pid = fork();
    1ea8:	04c030ef          	jal	4ef4 <fork>
    1eac:	84aa                	mv	s1,a0
    if(pid < 0){
    1eae:	02054c63          	bltz	a0,1ee6 <manywrites+0x54>
    if(pid == 0){
    1eb2:	c929                	beqz	a0,1f04 <manywrites+0x72>
  for(int ci = 0; ci < nchildren; ci++){
    1eb4:	2905                	addiw	s2,s2,1
    1eb6:	ff3919e3          	bne	s2,s3,1ea8 <manywrites+0x16>
    1eba:	4491                	li	s1,4
    wait(&st);
    1ebc:	f9840913          	addi	s2,s0,-104
    int st = 0;
    1ec0:	f8042c23          	sw	zero,-104(s0)
    wait(&st);
    1ec4:	854a                	mv	a0,s2
    1ec6:	03e030ef          	jal	4f04 <wait>
    if(st != 0)
    1eca:	f9842503          	lw	a0,-104(s0)
    1ece:	0e051763          	bnez	a0,1fbc <manywrites+0x12a>
  for(int ci = 0; ci < nchildren; ci++){
    1ed2:	34fd                	addiw	s1,s1,-1
    1ed4:	f4f5                	bnez	s1,1ec0 <manywrites+0x2e>
    1ed6:	e0d2                	sd	s4,64(sp)
    1ed8:	fc56                	sd	s5,56(sp)
    1eda:	f85a                	sd	s6,48(sp)
    1edc:	f45e                	sd	s7,40(sp)
    1ede:	f062                	sd	s8,32(sp)
    1ee0:	e86a                	sd	s10,16(sp)
  exit(0);
    1ee2:	01a030ef          	jal	4efc <exit>
    1ee6:	e0d2                	sd	s4,64(sp)
    1ee8:	fc56                	sd	s5,56(sp)
    1eea:	f85a                	sd	s6,48(sp)
    1eec:	f45e                	sd	s7,40(sp)
    1eee:	f062                	sd	s8,32(sp)
    1ef0:	e86a                	sd	s10,16(sp)
      printf("fork failed\n");
    1ef2:	00005517          	auipc	a0,0x5
    1ef6:	47e50513          	addi	a0,a0,1150 # 7370 <malloc+0x1f6e>
    1efa:	450030ef          	jal	534a <printf>
      exit(1);
    1efe:	4505                	li	a0,1
    1f00:	7fd020ef          	jal	4efc <exit>
    1f04:	e0d2                	sd	s4,64(sp)
    1f06:	fc56                	sd	s5,56(sp)
    1f08:	f85a                	sd	s6,48(sp)
    1f0a:	f45e                	sd	s7,40(sp)
    1f0c:	f062                	sd	s8,32(sp)
    1f0e:	e86a                	sd	s10,16(sp)
      name[0] = 'b';
    1f10:	06200793          	li	a5,98
    1f14:	f8f40c23          	sb	a5,-104(s0)
      name[1] = 'a' + ci;
    1f18:	0619079b          	addiw	a5,s2,97
    1f1c:	f8f40ca3          	sb	a5,-103(s0)
      name[2] = '\0';
    1f20:	f8040d23          	sb	zero,-102(s0)
      unlink(name);
    1f24:	f9840513          	addi	a0,s0,-104
    1f28:	024030ef          	jal	4f4c <unlink>
    1f2c:	47f9                	li	a5,30
    1f2e:	8d3e                	mv	s10,a5
          int fd = open(name, O_CREATE | O_RDWR);
    1f30:	f9840b93          	addi	s7,s0,-104
    1f34:	20200b13          	li	s6,514
          int cc = write(fd, buf, sz);
    1f38:	6a8d                	lui	s5,0x3
    1f3a:	0000ac17          	auipc	s8,0xa
    1f3e:	d6ec0c13          	addi	s8,s8,-658 # bca8 <buf>
        for(int i = 0; i < ci+1; i++){
    1f42:	8a26                	mv	s4,s1
    1f44:	02094563          	bltz	s2,1f6e <manywrites+0xdc>
          int fd = open(name, O_CREATE | O_RDWR);
    1f48:	85da                	mv	a1,s6
    1f4a:	855e                	mv	a0,s7
    1f4c:	7f1020ef          	jal	4f3c <open>
    1f50:	89aa                	mv	s3,a0
          if(fd < 0){
    1f52:	02054d63          	bltz	a0,1f8c <manywrites+0xfa>
          int cc = write(fd, buf, sz);
    1f56:	8656                	mv	a2,s5
    1f58:	85e2                	mv	a1,s8
    1f5a:	7c3020ef          	jal	4f1c <write>
          if(cc != sz){
    1f5e:	05551363          	bne	a0,s5,1fa4 <manywrites+0x112>
          close(fd);
    1f62:	854e                	mv	a0,s3
    1f64:	7c1020ef          	jal	4f24 <close>
        for(int i = 0; i < ci+1; i++){
    1f68:	2a05                	addiw	s4,s4,1
    1f6a:	fd495fe3          	bge	s2,s4,1f48 <manywrites+0xb6>
        unlink(name);
    1f6e:	f9840513          	addi	a0,s0,-104
    1f72:	7db020ef          	jal	4f4c <unlink>
      for(int iters = 0; iters < howmany; iters++){
    1f76:	fffd079b          	addiw	a5,s10,-1
    1f7a:	8d3e                	mv	s10,a5
    1f7c:	f3f9                	bnez	a5,1f42 <manywrites+0xb0>
      unlink(name);
    1f7e:	f9840513          	addi	a0,s0,-104
    1f82:	7cb020ef          	jal	4f4c <unlink>
      exit(0);
    1f86:	4501                	li	a0,0
    1f88:	775020ef          	jal	4efc <exit>
            printf("%s: cannot create %s\n", s, name);
    1f8c:	f9840613          	addi	a2,s0,-104
    1f90:	85e6                	mv	a1,s9
    1f92:	00004517          	auipc	a0,0x4
    1f96:	18650513          	addi	a0,a0,390 # 6118 <malloc+0xd16>
    1f9a:	3b0030ef          	jal	534a <printf>
            exit(1);
    1f9e:	4505                	li	a0,1
    1fa0:	75d020ef          	jal	4efc <exit>
            printf("%s: write(%d) ret %d\n", s, sz, cc);
    1fa4:	86aa                	mv	a3,a0
    1fa6:	660d                	lui	a2,0x3
    1fa8:	85e6                	mv	a1,s9
    1faa:	00003517          	auipc	a0,0x3
    1fae:	65e50513          	addi	a0,a0,1630 # 5608 <malloc+0x206>
    1fb2:	398030ef          	jal	534a <printf>
            exit(1);
    1fb6:	4505                	li	a0,1
    1fb8:	745020ef          	jal	4efc <exit>
    1fbc:	e0d2                	sd	s4,64(sp)
    1fbe:	fc56                	sd	s5,56(sp)
    1fc0:	f85a                	sd	s6,48(sp)
    1fc2:	f45e                	sd	s7,40(sp)
    1fc4:	f062                	sd	s8,32(sp)
    1fc6:	e86a                	sd	s10,16(sp)
      exit(st);
    1fc8:	735020ef          	jal	4efc <exit>

0000000000001fcc <copyinstr3>:
{
    1fcc:	7179                	addi	sp,sp,-48
    1fce:	f406                	sd	ra,40(sp)
    1fd0:	f022                	sd	s0,32(sp)
    1fd2:	ec26                	sd	s1,24(sp)
    1fd4:	1800                	addi	s0,sp,48
  sbrk(8192);
    1fd6:	6509                	lui	a0,0x2
    1fd8:	6f1020ef          	jal	4ec8 <sbrk>
  uint64 top = (uint64) sbrk(0);
    1fdc:	4501                	li	a0,0
    1fde:	6eb020ef          	jal	4ec8 <sbrk>
  if((top % PGSIZE) != 0){
    1fe2:	03451793          	slli	a5,a0,0x34
    1fe6:	e7bd                	bnez	a5,2054 <copyinstr3+0x88>
  top = (uint64) sbrk(0);
    1fe8:	4501                	li	a0,0
    1fea:	6df020ef          	jal	4ec8 <sbrk>
  if(top % PGSIZE){
    1fee:	03451793          	slli	a5,a0,0x34
    1ff2:	ebad                	bnez	a5,2064 <copyinstr3+0x98>
  char *b = (char *) (top - 1);
    1ff4:	fff50493          	addi	s1,a0,-1 # 1fff <copyinstr3+0x33>
  *b = 'x';
    1ff8:	07800793          	li	a5,120
    1ffc:	fef50fa3          	sb	a5,-1(a0)
  int ret = unlink(b);
    2000:	8526                	mv	a0,s1
    2002:	74b020ef          	jal	4f4c <unlink>
  if(ret != -1){
    2006:	57fd                	li	a5,-1
    2008:	06f51763          	bne	a0,a5,2076 <copyinstr3+0xaa>
  int fd = open(b, O_CREATE | O_WRONLY);
    200c:	20100593          	li	a1,513
    2010:	8526                	mv	a0,s1
    2012:	72b020ef          	jal	4f3c <open>
  if(fd != -1){
    2016:	57fd                	li	a5,-1
    2018:	06f51a63          	bne	a0,a5,208c <copyinstr3+0xc0>
  ret = link(b, b);
    201c:	85a6                	mv	a1,s1
    201e:	8526                	mv	a0,s1
    2020:	73d020ef          	jal	4f5c <link>
  if(ret != -1){
    2024:	57fd                	li	a5,-1
    2026:	06f51e63          	bne	a0,a5,20a2 <copyinstr3+0xd6>
  char *args[] = { "xx", 0 };
    202a:	00005797          	auipc	a5,0x5
    202e:	dee78793          	addi	a5,a5,-530 # 6e18 <malloc+0x1a16>
    2032:	fcf43823          	sd	a5,-48(s0)
    2036:	fc043c23          	sd	zero,-40(s0)
  ret = exec(b, args);
    203a:	fd040593          	addi	a1,s0,-48
    203e:	8526                	mv	a0,s1
    2040:	6f5020ef          	jal	4f34 <exec>
  if(ret != -1){
    2044:	57fd                	li	a5,-1
    2046:	06f51a63          	bne	a0,a5,20ba <copyinstr3+0xee>
}
    204a:	70a2                	ld	ra,40(sp)
    204c:	7402                	ld	s0,32(sp)
    204e:	64e2                	ld	s1,24(sp)
    2050:	6145                	addi	sp,sp,48
    2052:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    2054:	0347d513          	srli	a0,a5,0x34
    2058:	6785                	lui	a5,0x1
    205a:	40a7853b          	subw	a0,a5,a0
    205e:	66b020ef          	jal	4ec8 <sbrk>
    2062:	b759                	j	1fe8 <copyinstr3+0x1c>
    printf("oops\n");
    2064:	00004517          	auipc	a0,0x4
    2068:	0cc50513          	addi	a0,a0,204 # 6130 <malloc+0xd2e>
    206c:	2de030ef          	jal	534a <printf>
    exit(1);
    2070:	4505                	li	a0,1
    2072:	68b020ef          	jal	4efc <exit>
    printf("unlink(%s) returned %d, not -1\n", b, ret);
    2076:	862a                	mv	a2,a0
    2078:	85a6                	mv	a1,s1
    207a:	00004517          	auipc	a0,0x4
    207e:	c6e50513          	addi	a0,a0,-914 # 5ce8 <malloc+0x8e6>
    2082:	2c8030ef          	jal	534a <printf>
    exit(1);
    2086:	4505                	li	a0,1
    2088:	675020ef          	jal	4efc <exit>
    printf("open(%s) returned %d, not -1\n", b, fd);
    208c:	862a                	mv	a2,a0
    208e:	85a6                	mv	a1,s1
    2090:	00004517          	auipc	a0,0x4
    2094:	c7850513          	addi	a0,a0,-904 # 5d08 <malloc+0x906>
    2098:	2b2030ef          	jal	534a <printf>
    exit(1);
    209c:	4505                	li	a0,1
    209e:	65f020ef          	jal	4efc <exit>
    printf("link(%s, %s) returned %d, not -1\n", b, b, ret);
    20a2:	86aa                	mv	a3,a0
    20a4:	8626                	mv	a2,s1
    20a6:	85a6                	mv	a1,s1
    20a8:	00004517          	auipc	a0,0x4
    20ac:	c8050513          	addi	a0,a0,-896 # 5d28 <malloc+0x926>
    20b0:	29a030ef          	jal	534a <printf>
    exit(1);
    20b4:	4505                	li	a0,1
    20b6:	647020ef          	jal	4efc <exit>
    printf("exec(%s) returned %d, not -1\n", b, fd);
    20ba:	863e                	mv	a2,a5
    20bc:	85a6                	mv	a1,s1
    20be:	00004517          	auipc	a0,0x4
    20c2:	c9250513          	addi	a0,a0,-878 # 5d50 <malloc+0x94e>
    20c6:	284030ef          	jal	534a <printf>
    exit(1);
    20ca:	4505                	li	a0,1
    20cc:	631020ef          	jal	4efc <exit>

00000000000020d0 <rwsbrk>:
{
    20d0:	1101                	addi	sp,sp,-32
    20d2:	ec06                	sd	ra,24(sp)
    20d4:	e822                	sd	s0,16(sp)
    20d6:	1000                	addi	s0,sp,32
  uint64 a = (uint64) sbrk(8192);
    20d8:	6509                	lui	a0,0x2
    20da:	5ef020ef          	jal	4ec8 <sbrk>
  if(a == (uint64) SBRK_ERROR) {
    20de:	57fd                	li	a5,-1
    20e0:	04f50a63          	beq	a0,a5,2134 <rwsbrk+0x64>
    20e4:	e426                	sd	s1,8(sp)
    20e6:	84aa                	mv	s1,a0
  if (sbrk(-8192) == SBRK_ERROR) {
    20e8:	7579                	lui	a0,0xffffe
    20ea:	5df020ef          	jal	4ec8 <sbrk>
    20ee:	57fd                	li	a5,-1
    20f0:	04f50d63          	beq	a0,a5,214a <rwsbrk+0x7a>
    20f4:	e04a                	sd	s2,0(sp)
  fd = open("rwsbrk", O_CREATE|O_WRONLY);
    20f6:	20100593          	li	a1,513
    20fa:	00004517          	auipc	a0,0x4
    20fe:	07650513          	addi	a0,a0,118 # 6170 <malloc+0xd6e>
    2102:	63b020ef          	jal	4f3c <open>
    2106:	892a                	mv	s2,a0
  if(fd < 0){
    2108:	04054b63          	bltz	a0,215e <rwsbrk+0x8e>
  n = write(fd, (void*)(a+PGSIZE), 1024);
    210c:	6785                	lui	a5,0x1
    210e:	94be                	add	s1,s1,a5
    2110:	40000613          	li	a2,1024
    2114:	85a6                	mv	a1,s1
    2116:	607020ef          	jal	4f1c <write>
    211a:	862a                	mv	a2,a0
  if(n >= 0){
    211c:	04054a63          	bltz	a0,2170 <rwsbrk+0xa0>
    printf("write(fd, %p, 1024) returned %d, not -1\n", (void*)a+PGSIZE, n);
    2120:	85a6                	mv	a1,s1
    2122:	00004517          	auipc	a0,0x4
    2126:	06e50513          	addi	a0,a0,110 # 6190 <malloc+0xd8e>
    212a:	220030ef          	jal	534a <printf>
    exit(1);
    212e:	4505                	li	a0,1
    2130:	5cd020ef          	jal	4efc <exit>
    2134:	e426                	sd	s1,8(sp)
    2136:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) failed\n");
    2138:	00004517          	auipc	a0,0x4
    213c:	00050513          	mv	a0,a0
    2140:	20a030ef          	jal	534a <printf>
    exit(1);
    2144:	4505                	li	a0,1
    2146:	5b7020ef          	jal	4efc <exit>
    214a:	e04a                	sd	s2,0(sp)
    printf("sbrk(rwsbrk) shrink failed\n");
    214c:	00004517          	auipc	a0,0x4
    2150:	00450513          	addi	a0,a0,4 # 6150 <malloc+0xd4e>
    2154:	1f6030ef          	jal	534a <printf>
    exit(1);
    2158:	4505                	li	a0,1
    215a:	5a3020ef          	jal	4efc <exit>
    printf("open(rwsbrk) failed\n");
    215e:	00004517          	auipc	a0,0x4
    2162:	01a50513          	addi	a0,a0,26 # 6178 <malloc+0xd76>
    2166:	1e4030ef          	jal	534a <printf>
    exit(1);
    216a:	4505                	li	a0,1
    216c:	591020ef          	jal	4efc <exit>
  close(fd);
    2170:	854a                	mv	a0,s2
    2172:	5b3020ef          	jal	4f24 <close>
  unlink("rwsbrk");
    2176:	00004517          	auipc	a0,0x4
    217a:	ffa50513          	addi	a0,a0,-6 # 6170 <malloc+0xd6e>
    217e:	5cf020ef          	jal	4f4c <unlink>
  fd = open("README", O_RDONLY);
    2182:	4581                	li	a1,0
    2184:	00003517          	auipc	a0,0x3
    2188:	58c50513          	addi	a0,a0,1420 # 5710 <malloc+0x30e>
    218c:	5b1020ef          	jal	4f3c <open>
    2190:	892a                	mv	s2,a0
  if(fd < 0){
    2192:	02054363          	bltz	a0,21b8 <rwsbrk+0xe8>
  n = read(fd, (void*)(a+PGSIZE), 10);
    2196:	4629                	li	a2,10
    2198:	85a6                	mv	a1,s1
    219a:	57b020ef          	jal	4f14 <read>
    219e:	862a                	mv	a2,a0
  if(n >= 0){
    21a0:	02054563          	bltz	a0,21ca <rwsbrk+0xfa>
    printf("read(fd, %p, 10) returned %d, not -1\n", (void*)a+PGSIZE, n);
    21a4:	85a6                	mv	a1,s1
    21a6:	00004517          	auipc	a0,0x4
    21aa:	01a50513          	addi	a0,a0,26 # 61c0 <malloc+0xdbe>
    21ae:	19c030ef          	jal	534a <printf>
    exit(1);
    21b2:	4505                	li	a0,1
    21b4:	549020ef          	jal	4efc <exit>
    printf("open(README) failed\n");
    21b8:	00003517          	auipc	a0,0x3
    21bc:	56050513          	addi	a0,a0,1376 # 5718 <malloc+0x316>
    21c0:	18a030ef          	jal	534a <printf>
    exit(1);
    21c4:	4505                	li	a0,1
    21c6:	537020ef          	jal	4efc <exit>
  close(fd);
    21ca:	854a                	mv	a0,s2
    21cc:	559020ef          	jal	4f24 <close>
  exit(0);
    21d0:	4501                	li	a0,0
    21d2:	52b020ef          	jal	4efc <exit>

00000000000021d6 <sbrkbasic>:
{
    21d6:	715d                	addi	sp,sp,-80
    21d8:	e486                	sd	ra,72(sp)
    21da:	e0a2                	sd	s0,64(sp)
    21dc:	ec56                	sd	s5,24(sp)
    21de:	0880                	addi	s0,sp,80
    21e0:	8aaa                	mv	s5,a0
  pid = fork();
    21e2:	513020ef          	jal	4ef4 <fork>
  if(pid < 0){
    21e6:	02054c63          	bltz	a0,221e <sbrkbasic+0x48>
  if(pid == 0){
    21ea:	ed31                	bnez	a0,2246 <sbrkbasic+0x70>
    a = sbrk(TOOMUCH);
    21ec:	40000537          	lui	a0,0x40000
    21f0:	4d9020ef          	jal	4ec8 <sbrk>
    if(a == (char*)SBRK_ERROR){
    21f4:	57fd                	li	a5,-1
    21f6:	04f50163          	beq	a0,a5,2238 <sbrkbasic+0x62>
    21fa:	fc26                	sd	s1,56(sp)
    21fc:	f84a                	sd	s2,48(sp)
    21fe:	f44e                	sd	s3,40(sp)
    2200:	f052                	sd	s4,32(sp)
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    2202:	400007b7          	lui	a5,0x40000
    2206:	97aa                	add	a5,a5,a0
      *b = 99;
    2208:	06300693          	li	a3,99
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    220c:	6705                	lui	a4,0x1
      *b = 99;
    220e:	00d50023          	sb	a3,0(a0) # 40000000 <base+0x3fff1358>
    for(b = a; b < a+TOOMUCH; b += PGSIZE){
    2212:	953a                	add	a0,a0,a4
    2214:	fef51de3          	bne	a0,a5,220e <sbrkbasic+0x38>
    exit(1);
    2218:	4505                	li	a0,1
    221a:	4e3020ef          	jal	4efc <exit>
    221e:	fc26                	sd	s1,56(sp)
    2220:	f84a                	sd	s2,48(sp)
    2222:	f44e                	sd	s3,40(sp)
    2224:	f052                	sd	s4,32(sp)
    printf("fork failed in sbrkbasic\n");
    2226:	00004517          	auipc	a0,0x4
    222a:	fc250513          	addi	a0,a0,-62 # 61e8 <malloc+0xde6>
    222e:	11c030ef          	jal	534a <printf>
    exit(1);
    2232:	4505                	li	a0,1
    2234:	4c9020ef          	jal	4efc <exit>
    2238:	fc26                	sd	s1,56(sp)
    223a:	f84a                	sd	s2,48(sp)
    223c:	f44e                	sd	s3,40(sp)
    223e:	f052                	sd	s4,32(sp)
      exit(0);
    2240:	4501                	li	a0,0
    2242:	4bb020ef          	jal	4efc <exit>
  wait(&xstatus);
    2246:	fbc40513          	addi	a0,s0,-68
    224a:	4bb020ef          	jal	4f04 <wait>
  if(xstatus == 1){
    224e:	fbc42703          	lw	a4,-68(s0)
    2252:	4785                	li	a5,1
    2254:	02f70063          	beq	a4,a5,2274 <sbrkbasic+0x9e>
    2258:	fc26                	sd	s1,56(sp)
    225a:	f84a                	sd	s2,48(sp)
    225c:	f44e                	sd	s3,40(sp)
    225e:	f052                	sd	s4,32(sp)
  a = sbrk(0);
    2260:	4501                	li	a0,0
    2262:	467020ef          	jal	4ec8 <sbrk>
    2266:	84aa                	mv	s1,a0
  for(i = 0; i < 5000; i++){
    2268:	4901                	li	s2,0
    b = sbrk(1);
    226a:	4985                	li	s3,1
  for(i = 0; i < 5000; i++){
    226c:	6a05                	lui	s4,0x1
    226e:	388a0a13          	addi	s4,s4,904 # 1388 <truncate3+0x146>
    2272:	a005                	j	2292 <sbrkbasic+0xbc>
    2274:	fc26                	sd	s1,56(sp)
    2276:	f84a                	sd	s2,48(sp)
    2278:	f44e                	sd	s3,40(sp)
    227a:	f052                	sd	s4,32(sp)
    printf("%s: too much memory allocated!\n", s);
    227c:	85d6                	mv	a1,s5
    227e:	00004517          	auipc	a0,0x4
    2282:	f8a50513          	addi	a0,a0,-118 # 6208 <malloc+0xe06>
    2286:	0c4030ef          	jal	534a <printf>
    exit(1);
    228a:	4505                	li	a0,1
    228c:	471020ef          	jal	4efc <exit>
    2290:	84be                	mv	s1,a5
    b = sbrk(1);
    2292:	854e                	mv	a0,s3
    2294:	435020ef          	jal	4ec8 <sbrk>
    if(b != a){
    2298:	04951163          	bne	a0,s1,22da <sbrkbasic+0x104>
    *b = 1;
    229c:	01348023          	sb	s3,0(s1)
    a = b + 1;
    22a0:	00148793          	addi	a5,s1,1
  for(i = 0; i < 5000; i++){
    22a4:	2905                	addiw	s2,s2,1
    22a6:	ff4915e3          	bne	s2,s4,2290 <sbrkbasic+0xba>
  pid = fork();
    22aa:	44b020ef          	jal	4ef4 <fork>
    22ae:	892a                	mv	s2,a0
  if(pid < 0){
    22b0:	04054263          	bltz	a0,22f4 <sbrkbasic+0x11e>
  c = sbrk(1);
    22b4:	4505                	li	a0,1
    22b6:	413020ef          	jal	4ec8 <sbrk>
  c = sbrk(1);
    22ba:	4505                	li	a0,1
    22bc:	40d020ef          	jal	4ec8 <sbrk>
  if(c != a + 1){
    22c0:	0489                	addi	s1,s1,2
    22c2:	04950363          	beq	a0,s1,2308 <sbrkbasic+0x132>
    printf("%s: sbrk test failed post-fork\n", s);
    22c6:	85d6                	mv	a1,s5
    22c8:	00004517          	auipc	a0,0x4
    22cc:	fa050513          	addi	a0,a0,-96 # 6268 <malloc+0xe66>
    22d0:	07a030ef          	jal	534a <printf>
    exit(1);
    22d4:	4505                	li	a0,1
    22d6:	427020ef          	jal	4efc <exit>
      printf("%s: sbrk test failed %d %p %p\n", s, i, a, b);
    22da:	872a                	mv	a4,a0
    22dc:	86a6                	mv	a3,s1
    22de:	864a                	mv	a2,s2
    22e0:	85d6                	mv	a1,s5
    22e2:	00004517          	auipc	a0,0x4
    22e6:	f4650513          	addi	a0,a0,-186 # 6228 <malloc+0xe26>
    22ea:	060030ef          	jal	534a <printf>
      exit(1);
    22ee:	4505                	li	a0,1
    22f0:	40d020ef          	jal	4efc <exit>
    printf("%s: sbrk test fork failed\n", s);
    22f4:	85d6                	mv	a1,s5
    22f6:	00004517          	auipc	a0,0x4
    22fa:	f5250513          	addi	a0,a0,-174 # 6248 <malloc+0xe46>
    22fe:	04c030ef          	jal	534a <printf>
    exit(1);
    2302:	4505                	li	a0,1
    2304:	3f9020ef          	jal	4efc <exit>
  if(pid == 0)
    2308:	00091563          	bnez	s2,2312 <sbrkbasic+0x13c>
    exit(0);
    230c:	4501                	li	a0,0
    230e:	3ef020ef          	jal	4efc <exit>
  wait(&xstatus);
    2312:	fbc40513          	addi	a0,s0,-68
    2316:	3ef020ef          	jal	4f04 <wait>
  exit(xstatus);
    231a:	fbc42503          	lw	a0,-68(s0)
    231e:	3df020ef          	jal	4efc <exit>

0000000000002322 <sbrkmuch>:
{
    2322:	7179                	addi	sp,sp,-48
    2324:	f406                	sd	ra,40(sp)
    2326:	f022                	sd	s0,32(sp)
    2328:	ec26                	sd	s1,24(sp)
    232a:	e84a                	sd	s2,16(sp)
    232c:	e44e                	sd	s3,8(sp)
    232e:	e052                	sd	s4,0(sp)
    2330:	1800                	addi	s0,sp,48
    2332:	89aa                	mv	s3,a0
  oldbrk = sbrk(0);
    2334:	4501                	li	a0,0
    2336:	393020ef          	jal	4ec8 <sbrk>
    233a:	892a                	mv	s2,a0
  a = sbrk(0);
    233c:	4501                	li	a0,0
    233e:	38b020ef          	jal	4ec8 <sbrk>
    2342:	84aa                	mv	s1,a0
  p = sbrk(amt);
    2344:	06400537          	lui	a0,0x6400
    2348:	9d05                	subw	a0,a0,s1
    234a:	37f020ef          	jal	4ec8 <sbrk>
  if (p != a) {
    234e:	08a49963          	bne	s1,a0,23e0 <sbrkmuch+0xbe>
  *lastaddr = 99;
    2352:	064007b7          	lui	a5,0x6400
    2356:	06300713          	li	a4,99
    235a:	fee78fa3          	sb	a4,-1(a5) # 63fffff <base+0x63f1357>
  a = sbrk(0);
    235e:	4501                	li	a0,0
    2360:	369020ef          	jal	4ec8 <sbrk>
    2364:	84aa                	mv	s1,a0
  c = sbrk(-PGSIZE);
    2366:	757d                	lui	a0,0xfffff
    2368:	361020ef          	jal	4ec8 <sbrk>
  if(c == (char*)SBRK_ERROR){
    236c:	57fd                	li	a5,-1
    236e:	08f50363          	beq	a0,a5,23f4 <sbrkmuch+0xd2>
  c = sbrk(0);
    2372:	4501                	li	a0,0
    2374:	355020ef          	jal	4ec8 <sbrk>
  if(c != a - PGSIZE){
    2378:	80048793          	addi	a5,s1,-2048
    237c:	80078793          	addi	a5,a5,-2048
    2380:	08f51463          	bne	a0,a5,2408 <sbrkmuch+0xe6>
  a = sbrk(0);
    2384:	4501                	li	a0,0
    2386:	343020ef          	jal	4ec8 <sbrk>
    238a:	84aa                	mv	s1,a0
  c = sbrk(PGSIZE);
    238c:	6505                	lui	a0,0x1
    238e:	33b020ef          	jal	4ec8 <sbrk>
    2392:	8a2a                	mv	s4,a0
  if(c != a || sbrk(0) != a + PGSIZE){
    2394:	08a49663          	bne	s1,a0,2420 <sbrkmuch+0xfe>
    2398:	4501                	li	a0,0
    239a:	32f020ef          	jal	4ec8 <sbrk>
    239e:	6785                	lui	a5,0x1
    23a0:	97a6                	add	a5,a5,s1
    23a2:	06f51f63          	bne	a0,a5,2420 <sbrkmuch+0xfe>
  if(*lastaddr == 99){
    23a6:	064007b7          	lui	a5,0x6400
    23aa:	fff7c703          	lbu	a4,-1(a5) # 63fffff <base+0x63f1357>
    23ae:	06300793          	li	a5,99
    23b2:	08f70363          	beq	a4,a5,2438 <sbrkmuch+0x116>
  a = sbrk(0);
    23b6:	4501                	li	a0,0
    23b8:	311020ef          	jal	4ec8 <sbrk>
    23bc:	84aa                	mv	s1,a0
  c = sbrk(-(sbrk(0) - oldbrk));
    23be:	4501                	li	a0,0
    23c0:	309020ef          	jal	4ec8 <sbrk>
    23c4:	40a9053b          	subw	a0,s2,a0
    23c8:	301020ef          	jal	4ec8 <sbrk>
  if(c != a){
    23cc:	08a49063          	bne	s1,a0,244c <sbrkmuch+0x12a>
}
    23d0:	70a2                	ld	ra,40(sp)
    23d2:	7402                	ld	s0,32(sp)
    23d4:	64e2                	ld	s1,24(sp)
    23d6:	6942                	ld	s2,16(sp)
    23d8:	69a2                	ld	s3,8(sp)
    23da:	6a02                	ld	s4,0(sp)
    23dc:	6145                	addi	sp,sp,48
    23de:	8082                	ret
    printf("%s: sbrk test failed to grow big address space; enough phys mem?\n", s);
    23e0:	85ce                	mv	a1,s3
    23e2:	00004517          	auipc	a0,0x4
    23e6:	ea650513          	addi	a0,a0,-346 # 6288 <malloc+0xe86>
    23ea:	761020ef          	jal	534a <printf>
    exit(1);
    23ee:	4505                	li	a0,1
    23f0:	30d020ef          	jal	4efc <exit>
    printf("%s: sbrk could not deallocate\n", s);
    23f4:	85ce                	mv	a1,s3
    23f6:	00004517          	auipc	a0,0x4
    23fa:	eda50513          	addi	a0,a0,-294 # 62d0 <malloc+0xece>
    23fe:	74d020ef          	jal	534a <printf>
    exit(1);
    2402:	4505                	li	a0,1
    2404:	2f9020ef          	jal	4efc <exit>
    printf("%s: sbrk deallocation produced wrong address, a %p c %p\n", s, a, c);
    2408:	86aa                	mv	a3,a0
    240a:	8626                	mv	a2,s1
    240c:	85ce                	mv	a1,s3
    240e:	00004517          	auipc	a0,0x4
    2412:	ee250513          	addi	a0,a0,-286 # 62f0 <malloc+0xeee>
    2416:	735020ef          	jal	534a <printf>
    exit(1);
    241a:	4505                	li	a0,1
    241c:	2e1020ef          	jal	4efc <exit>
    printf("%s: sbrk re-allocation failed, a %p c %p\n", s, a, c);
    2420:	86d2                	mv	a3,s4
    2422:	8626                	mv	a2,s1
    2424:	85ce                	mv	a1,s3
    2426:	00004517          	auipc	a0,0x4
    242a:	f0a50513          	addi	a0,a0,-246 # 6330 <malloc+0xf2e>
    242e:	71d020ef          	jal	534a <printf>
    exit(1);
    2432:	4505                	li	a0,1
    2434:	2c9020ef          	jal	4efc <exit>
    printf("%s: sbrk de-allocation didn't really deallocate\n", s);
    2438:	85ce                	mv	a1,s3
    243a:	00004517          	auipc	a0,0x4
    243e:	f2650513          	addi	a0,a0,-218 # 6360 <malloc+0xf5e>
    2442:	709020ef          	jal	534a <printf>
    exit(1);
    2446:	4505                	li	a0,1
    2448:	2b5020ef          	jal	4efc <exit>
    printf("%s: sbrk downsize failed, a %p c %p\n", s, a, c);
    244c:	86aa                	mv	a3,a0
    244e:	8626                	mv	a2,s1
    2450:	85ce                	mv	a1,s3
    2452:	00004517          	auipc	a0,0x4
    2456:	f4650513          	addi	a0,a0,-186 # 6398 <malloc+0xf96>
    245a:	6f1020ef          	jal	534a <printf>
    exit(1);
    245e:	4505                	li	a0,1
    2460:	29d020ef          	jal	4efc <exit>

0000000000002464 <sbrkarg>:
{
    2464:	7179                	addi	sp,sp,-48
    2466:	f406                	sd	ra,40(sp)
    2468:	f022                	sd	s0,32(sp)
    246a:	ec26                	sd	s1,24(sp)
    246c:	e84a                	sd	s2,16(sp)
    246e:	e44e                	sd	s3,8(sp)
    2470:	1800                	addi	s0,sp,48
    2472:	89aa                	mv	s3,a0
  a = sbrk(PGSIZE);
    2474:	6505                	lui	a0,0x1
    2476:	253020ef          	jal	4ec8 <sbrk>
    247a:	892a                	mv	s2,a0
  fd = open("sbrk", O_CREATE|O_WRONLY);
    247c:	20100593          	li	a1,513
    2480:	00004517          	auipc	a0,0x4
    2484:	f4050513          	addi	a0,a0,-192 # 63c0 <malloc+0xfbe>
    2488:	2b5020ef          	jal	4f3c <open>
    248c:	84aa                	mv	s1,a0
  unlink("sbrk");
    248e:	00004517          	auipc	a0,0x4
    2492:	f3250513          	addi	a0,a0,-206 # 63c0 <malloc+0xfbe>
    2496:	2b7020ef          	jal	4f4c <unlink>
  if(fd < 0)  {
    249a:	0204c963          	bltz	s1,24cc <sbrkarg+0x68>
  if ((n = write(fd, a, PGSIZE)) < 0) {
    249e:	6605                	lui	a2,0x1
    24a0:	85ca                	mv	a1,s2
    24a2:	8526                	mv	a0,s1
    24a4:	279020ef          	jal	4f1c <write>
    24a8:	02054c63          	bltz	a0,24e0 <sbrkarg+0x7c>
  close(fd);
    24ac:	8526                	mv	a0,s1
    24ae:	277020ef          	jal	4f24 <close>
  a = sbrk(PGSIZE);
    24b2:	6505                	lui	a0,0x1
    24b4:	215020ef          	jal	4ec8 <sbrk>
  if(pipe((int *) a) != 0){
    24b8:	255020ef          	jal	4f0c <pipe>
    24bc:	ed05                	bnez	a0,24f4 <sbrkarg+0x90>
}
    24be:	70a2                	ld	ra,40(sp)
    24c0:	7402                	ld	s0,32(sp)
    24c2:	64e2                	ld	s1,24(sp)
    24c4:	6942                	ld	s2,16(sp)
    24c6:	69a2                	ld	s3,8(sp)
    24c8:	6145                	addi	sp,sp,48
    24ca:	8082                	ret
    printf("%s: open sbrk failed\n", s);
    24cc:	85ce                	mv	a1,s3
    24ce:	00004517          	auipc	a0,0x4
    24d2:	efa50513          	addi	a0,a0,-262 # 63c8 <malloc+0xfc6>
    24d6:	675020ef          	jal	534a <printf>
    exit(1);
    24da:	4505                	li	a0,1
    24dc:	221020ef          	jal	4efc <exit>
    printf("%s: write sbrk failed\n", s);
    24e0:	85ce                	mv	a1,s3
    24e2:	00004517          	auipc	a0,0x4
    24e6:	efe50513          	addi	a0,a0,-258 # 63e0 <malloc+0xfde>
    24ea:	661020ef          	jal	534a <printf>
    exit(1);
    24ee:	4505                	li	a0,1
    24f0:	20d020ef          	jal	4efc <exit>
    printf("%s: pipe() failed\n", s);
    24f4:	85ce                	mv	a1,s3
    24f6:	00004517          	auipc	a0,0x4
    24fa:	9da50513          	addi	a0,a0,-1574 # 5ed0 <malloc+0xace>
    24fe:	64d020ef          	jal	534a <printf>
    exit(1);
    2502:	4505                	li	a0,1
    2504:	1f9020ef          	jal	4efc <exit>

0000000000002508 <argptest>:
{
    2508:	1101                	addi	sp,sp,-32
    250a:	ec06                	sd	ra,24(sp)
    250c:	e822                	sd	s0,16(sp)
    250e:	e426                	sd	s1,8(sp)
    2510:	e04a                	sd	s2,0(sp)
    2512:	1000                	addi	s0,sp,32
    2514:	892a                	mv	s2,a0
  fd = open("init", O_RDONLY);
    2516:	4581                	li	a1,0
    2518:	00004517          	auipc	a0,0x4
    251c:	ee050513          	addi	a0,a0,-288 # 63f8 <malloc+0xff6>
    2520:	21d020ef          	jal	4f3c <open>
  if (fd < 0) {
    2524:	02054563          	bltz	a0,254e <argptest+0x46>
    2528:	84aa                	mv	s1,a0
  read(fd, sbrk(0) - 1, -1);
    252a:	4501                	li	a0,0
    252c:	19d020ef          	jal	4ec8 <sbrk>
    2530:	567d                	li	a2,-1
    2532:	00c505b3          	add	a1,a0,a2
    2536:	8526                	mv	a0,s1
    2538:	1dd020ef          	jal	4f14 <read>
  close(fd);
    253c:	8526                	mv	a0,s1
    253e:	1e7020ef          	jal	4f24 <close>
}
    2542:	60e2                	ld	ra,24(sp)
    2544:	6442                	ld	s0,16(sp)
    2546:	64a2                	ld	s1,8(sp)
    2548:	6902                	ld	s2,0(sp)
    254a:	6105                	addi	sp,sp,32
    254c:	8082                	ret
    printf("%s: open failed\n", s);
    254e:	85ca                	mv	a1,s2
    2550:	00004517          	auipc	a0,0x4
    2554:	89050513          	addi	a0,a0,-1904 # 5de0 <malloc+0x9de>
    2558:	5f3020ef          	jal	534a <printf>
    exit(1);
    255c:	4505                	li	a0,1
    255e:	19f020ef          	jal	4efc <exit>

0000000000002562 <sbrkbugs>:
{
    2562:	1141                	addi	sp,sp,-16
    2564:	e406                	sd	ra,8(sp)
    2566:	e022                	sd	s0,0(sp)
    2568:	0800                	addi	s0,sp,16
  int pid = fork();
    256a:	18b020ef          	jal	4ef4 <fork>
  if(pid < 0){
    256e:	00054c63          	bltz	a0,2586 <sbrkbugs+0x24>
  if(pid == 0){
    2572:	e11d                	bnez	a0,2598 <sbrkbugs+0x36>
    int sz = (uint64) sbrk(0);
    2574:	155020ef          	jal	4ec8 <sbrk>
    sbrk(-sz);
    2578:	40a0053b          	negw	a0,a0
    257c:	14d020ef          	jal	4ec8 <sbrk>
    exit(0);
    2580:	4501                	li	a0,0
    2582:	17b020ef          	jal	4efc <exit>
    printf("fork failed\n");
    2586:	00005517          	auipc	a0,0x5
    258a:	dea50513          	addi	a0,a0,-534 # 7370 <malloc+0x1f6e>
    258e:	5bd020ef          	jal	534a <printf>
    exit(1);
    2592:	4505                	li	a0,1
    2594:	169020ef          	jal	4efc <exit>
  wait(0);
    2598:	4501                	li	a0,0
    259a:	16b020ef          	jal	4f04 <wait>
  pid = fork();
    259e:	157020ef          	jal	4ef4 <fork>
  if(pid < 0){
    25a2:	00054f63          	bltz	a0,25c0 <sbrkbugs+0x5e>
  if(pid == 0){
    25a6:	e515                	bnez	a0,25d2 <sbrkbugs+0x70>
    int sz = (uint64) sbrk(0);
    25a8:	121020ef          	jal	4ec8 <sbrk>
    sbrk(-(sz - 3500));
    25ac:	6785                	lui	a5,0x1
    25ae:	dac7879b          	addiw	a5,a5,-596 # dac <linktest+0xde>
    25b2:	40a7853b          	subw	a0,a5,a0
    25b6:	113020ef          	jal	4ec8 <sbrk>
    exit(0);
    25ba:	4501                	li	a0,0
    25bc:	141020ef          	jal	4efc <exit>
    printf("fork failed\n");
    25c0:	00005517          	auipc	a0,0x5
    25c4:	db050513          	addi	a0,a0,-592 # 7370 <malloc+0x1f6e>
    25c8:	583020ef          	jal	534a <printf>
    exit(1);
    25cc:	4505                	li	a0,1
    25ce:	12f020ef          	jal	4efc <exit>
  wait(0);
    25d2:	4501                	li	a0,0
    25d4:	131020ef          	jal	4f04 <wait>
  pid = fork();
    25d8:	11d020ef          	jal	4ef4 <fork>
  if(pid < 0){
    25dc:	02054263          	bltz	a0,2600 <sbrkbugs+0x9e>
  if(pid == 0){
    25e0:	e90d                	bnez	a0,2612 <sbrkbugs+0xb0>
    sbrk((10*PGSIZE + 2048) - (uint64)sbrk(0));
    25e2:	0e7020ef          	jal	4ec8 <sbrk>
    25e6:	67ad                	lui	a5,0xb
    25e8:	8007879b          	addiw	a5,a5,-2048 # a800 <uninit+0x1268>
    25ec:	40a7853b          	subw	a0,a5,a0
    25f0:	0d9020ef          	jal	4ec8 <sbrk>
    sbrk(-10);
    25f4:	5559                	li	a0,-10
    25f6:	0d3020ef          	jal	4ec8 <sbrk>
    exit(0);
    25fa:	4501                	li	a0,0
    25fc:	101020ef          	jal	4efc <exit>
    printf("fork failed\n");
    2600:	00005517          	auipc	a0,0x5
    2604:	d7050513          	addi	a0,a0,-656 # 7370 <malloc+0x1f6e>
    2608:	543020ef          	jal	534a <printf>
    exit(1);
    260c:	4505                	li	a0,1
    260e:	0ef020ef          	jal	4efc <exit>
  wait(0);
    2612:	4501                	li	a0,0
    2614:	0f1020ef          	jal	4f04 <wait>
  exit(0);
    2618:	4501                	li	a0,0
    261a:	0e3020ef          	jal	4efc <exit>

000000000000261e <sbrklast>:
{
    261e:	7179                	addi	sp,sp,-48
    2620:	f406                	sd	ra,40(sp)
    2622:	f022                	sd	s0,32(sp)
    2624:	ec26                	sd	s1,24(sp)
    2626:	e84a                	sd	s2,16(sp)
    2628:	e44e                	sd	s3,8(sp)
    262a:	e052                	sd	s4,0(sp)
    262c:	1800                	addi	s0,sp,48
  uint64 top = (uint64) sbrk(0);
    262e:	4501                	li	a0,0
    2630:	099020ef          	jal	4ec8 <sbrk>
  if((top % PGSIZE) != 0)
    2634:	03451793          	slli	a5,a0,0x34
    2638:	ebad                	bnez	a5,26aa <sbrklast+0x8c>
  sbrk(PGSIZE);
    263a:	6505                	lui	a0,0x1
    263c:	08d020ef          	jal	4ec8 <sbrk>
  sbrk(10);
    2640:	4529                	li	a0,10
    2642:	087020ef          	jal	4ec8 <sbrk>
  sbrk(-20);
    2646:	5531                	li	a0,-20
    2648:	081020ef          	jal	4ec8 <sbrk>
  top = (uint64) sbrk(0);
    264c:	4501                	li	a0,0
    264e:	07b020ef          	jal	4ec8 <sbrk>
    2652:	84aa                	mv	s1,a0
  char *p = (char *) (top - 64);
    2654:	fc050913          	addi	s2,a0,-64 # fc0 <bigdir+0xc8>
  p[0] = 'x';
    2658:	07800993          	li	s3,120
    265c:	fd350023          	sb	s3,-64(a0)
  p[1] = '\0';
    2660:	fc0500a3          	sb	zero,-63(a0)
  int fd = open(p, O_RDWR|O_CREATE);
    2664:	20200593          	li	a1,514
    2668:	854a                	mv	a0,s2
    266a:	0d3020ef          	jal	4f3c <open>
    266e:	8a2a                	mv	s4,a0
  write(fd, p, 1);
    2670:	4605                	li	a2,1
    2672:	85ca                	mv	a1,s2
    2674:	0a9020ef          	jal	4f1c <write>
  close(fd);
    2678:	8552                	mv	a0,s4
    267a:	0ab020ef          	jal	4f24 <close>
  fd = open(p, O_RDWR);
    267e:	4589                	li	a1,2
    2680:	854a                	mv	a0,s2
    2682:	0bb020ef          	jal	4f3c <open>
  p[0] = '\0';
    2686:	fc048023          	sb	zero,-64(s1)
  read(fd, p, 1);
    268a:	4605                	li	a2,1
    268c:	85ca                	mv	a1,s2
    268e:	087020ef          	jal	4f14 <read>
  if(p[0] != 'x')
    2692:	fc04c783          	lbu	a5,-64(s1)
    2696:	03379263          	bne	a5,s3,26ba <sbrklast+0x9c>
}
    269a:	70a2                	ld	ra,40(sp)
    269c:	7402                	ld	s0,32(sp)
    269e:	64e2                	ld	s1,24(sp)
    26a0:	6942                	ld	s2,16(sp)
    26a2:	69a2                	ld	s3,8(sp)
    26a4:	6a02                	ld	s4,0(sp)
    26a6:	6145                	addi	sp,sp,48
    26a8:	8082                	ret
    sbrk(PGSIZE - (top % PGSIZE));
    26aa:	0347d513          	srli	a0,a5,0x34
    26ae:	6785                	lui	a5,0x1
    26b0:	40a7853b          	subw	a0,a5,a0
    26b4:	015020ef          	jal	4ec8 <sbrk>
    26b8:	b749                	j	263a <sbrklast+0x1c>
    exit(1);
    26ba:	4505                	li	a0,1
    26bc:	041020ef          	jal	4efc <exit>

00000000000026c0 <sbrk8000>:
{
    26c0:	1141                	addi	sp,sp,-16
    26c2:	e406                	sd	ra,8(sp)
    26c4:	e022                	sd	s0,0(sp)
    26c6:	0800                	addi	s0,sp,16
  sbrk(0x80000004);
    26c8:	80000537          	lui	a0,0x80000
    26cc:	0511                	addi	a0,a0,4 # ffffffff80000004 <base+0xffffffff7fff135c>
    26ce:	7fa020ef          	jal	4ec8 <sbrk>
  volatile char *top = sbrk(0);
    26d2:	4501                	li	a0,0
    26d4:	7f4020ef          	jal	4ec8 <sbrk>
  *(top-1) = *(top-1) + 1;
    26d8:	fff54783          	lbu	a5,-1(a0)
    26dc:	0785                	addi	a5,a5,1 # 1001 <bigdir+0x109>
    26de:	0ff7f793          	zext.b	a5,a5
    26e2:	fef50fa3          	sb	a5,-1(a0)
}
    26e6:	60a2                	ld	ra,8(sp)
    26e8:	6402                	ld	s0,0(sp)
    26ea:	0141                	addi	sp,sp,16
    26ec:	8082                	ret

00000000000026ee <execout>:
{
    26ee:	711d                	addi	sp,sp,-96
    26f0:	ec86                	sd	ra,88(sp)
    26f2:	e8a2                	sd	s0,80(sp)
    26f4:	e4a6                	sd	s1,72(sp)
    26f6:	e0ca                	sd	s2,64(sp)
    26f8:	fc4e                	sd	s3,56(sp)
    26fa:	1080                	addi	s0,sp,96
  for(int avail = 0; avail < 15; avail++){
    26fc:	4901                	li	s2,0
    26fe:	49bd                	li	s3,15
    int pid = fork();
    2700:	7f4020ef          	jal	4ef4 <fork>
    2704:	84aa                	mv	s1,a0
    if(pid < 0){
    2706:	00054e63          	bltz	a0,2722 <execout+0x34>
    } else if(pid == 0){
    270a:	c51d                	beqz	a0,2738 <execout+0x4a>
      wait((int*)0);
    270c:	4501                	li	a0,0
    270e:	7f6020ef          	jal	4f04 <wait>
  for(int avail = 0; avail < 15; avail++){
    2712:	2905                	addiw	s2,s2,1
    2714:	ff3916e3          	bne	s2,s3,2700 <execout+0x12>
    2718:	f852                	sd	s4,48(sp)
    271a:	f456                	sd	s5,40(sp)
  exit(0);
    271c:	4501                	li	a0,0
    271e:	7de020ef          	jal	4efc <exit>
    2722:	f852                	sd	s4,48(sp)
    2724:	f456                	sd	s5,40(sp)
      printf("fork failed\n");
    2726:	00005517          	auipc	a0,0x5
    272a:	c4a50513          	addi	a0,a0,-950 # 7370 <malloc+0x1f6e>
    272e:	41d020ef          	jal	534a <printf>
      exit(1);
    2732:	4505                	li	a0,1
    2734:	7c8020ef          	jal	4efc <exit>
    2738:	f852                	sd	s4,48(sp)
    273a:	f456                	sd	s5,40(sp)
        char *a = sbrk(PGSIZE);
    273c:	6985                	lui	s3,0x1
        if(a == SBRK_ERROR)
    273e:	5a7d                	li	s4,-1
        *(a + PGSIZE - 1) = 1;
    2740:	4a85                	li	s5,1
        char *a = sbrk(PGSIZE);
    2742:	854e                	mv	a0,s3
    2744:	784020ef          	jal	4ec8 <sbrk>
        if(a == SBRK_ERROR)
    2748:	01450663          	beq	a0,s4,2754 <execout+0x66>
        *(a + PGSIZE - 1) = 1;
    274c:	954e                	add	a0,a0,s3
    274e:	ff550fa3          	sb	s5,-1(a0)
      while(1){
    2752:	bfc5                	j	2742 <execout+0x54>
        sbrk(-PGSIZE);
    2754:	79fd                	lui	s3,0xfffff
      for(int i = 0; i < avail; i++)
    2756:	01205863          	blez	s2,2766 <execout+0x78>
        sbrk(-PGSIZE);
    275a:	854e                	mv	a0,s3
    275c:	76c020ef          	jal	4ec8 <sbrk>
      for(int i = 0; i < avail; i++)
    2760:	2485                	addiw	s1,s1,1
    2762:	ff249ce3          	bne	s1,s2,275a <execout+0x6c>
      close(1);
    2766:	4505                	li	a0,1
    2768:	7bc020ef          	jal	4f24 <close>
      char *args[] = { "echo", "x", 0 };
    276c:	00003797          	auipc	a5,0x3
    2770:	dcc78793          	addi	a5,a5,-564 # 5538 <malloc+0x136>
    2774:	faf43423          	sd	a5,-88(s0)
    2778:	00003797          	auipc	a5,0x3
    277c:	e3078793          	addi	a5,a5,-464 # 55a8 <malloc+0x1a6>
    2780:	faf43823          	sd	a5,-80(s0)
    2784:	fa043c23          	sd	zero,-72(s0)
      exec("echo", args);
    2788:	fa840593          	addi	a1,s0,-88
    278c:	00003517          	auipc	a0,0x3
    2790:	dac50513          	addi	a0,a0,-596 # 5538 <malloc+0x136>
    2794:	7a0020ef          	jal	4f34 <exec>
      exit(0);
    2798:	4501                	li	a0,0
    279a:	762020ef          	jal	4efc <exit>

000000000000279e <fourteen>:
{
    279e:	1101                	addi	sp,sp,-32
    27a0:	ec06                	sd	ra,24(sp)
    27a2:	e822                	sd	s0,16(sp)
    27a4:	e426                	sd	s1,8(sp)
    27a6:	1000                	addi	s0,sp,32
    27a8:	84aa                	mv	s1,a0
  if(mkdir("12345678901234") != 0){
    27aa:	00004517          	auipc	a0,0x4
    27ae:	e2650513          	addi	a0,a0,-474 # 65d0 <malloc+0x11ce>
    27b2:	7b2020ef          	jal	4f64 <mkdir>
    27b6:	e555                	bnez	a0,2862 <fourteen+0xc4>
  if(mkdir("12345678901234/123456789012345") != 0){
    27b8:	00004517          	auipc	a0,0x4
    27bc:	c7050513          	addi	a0,a0,-912 # 6428 <malloc+0x1026>
    27c0:	7a4020ef          	jal	4f64 <mkdir>
    27c4:	e94d                	bnez	a0,2876 <fourteen+0xd8>
  fd = open("123456789012345/123456789012345/123456789012345", O_CREATE);
    27c6:	20000593          	li	a1,512
    27ca:	00004517          	auipc	a0,0x4
    27ce:	cb650513          	addi	a0,a0,-842 # 6480 <malloc+0x107e>
    27d2:	76a020ef          	jal	4f3c <open>
  if(fd < 0){
    27d6:	0a054a63          	bltz	a0,288a <fourteen+0xec>
  close(fd);
    27da:	74a020ef          	jal	4f24 <close>
  fd = open("12345678901234/12345678901234/12345678901234", 0);
    27de:	4581                	li	a1,0
    27e0:	00004517          	auipc	a0,0x4
    27e4:	d1850513          	addi	a0,a0,-744 # 64f8 <malloc+0x10f6>
    27e8:	754020ef          	jal	4f3c <open>
  if(fd < 0){
    27ec:	0a054963          	bltz	a0,289e <fourteen+0x100>
  close(fd);
    27f0:	734020ef          	jal	4f24 <close>
  if(mkdir("12345678901234/12345678901234") == 0){
    27f4:	00004517          	auipc	a0,0x4
    27f8:	d7450513          	addi	a0,a0,-652 # 6568 <malloc+0x1166>
    27fc:	768020ef          	jal	4f64 <mkdir>
    2800:	c94d                	beqz	a0,28b2 <fourteen+0x114>
  if(mkdir("123456789012345/12345678901234") == 0){
    2802:	00004517          	auipc	a0,0x4
    2806:	dbe50513          	addi	a0,a0,-578 # 65c0 <malloc+0x11be>
    280a:	75a020ef          	jal	4f64 <mkdir>
    280e:	cd45                	beqz	a0,28c6 <fourteen+0x128>
  unlink("123456789012345/12345678901234");
    2810:	00004517          	auipc	a0,0x4
    2814:	db050513          	addi	a0,a0,-592 # 65c0 <malloc+0x11be>
    2818:	734020ef          	jal	4f4c <unlink>
  unlink("12345678901234/12345678901234");
    281c:	00004517          	auipc	a0,0x4
    2820:	d4c50513          	addi	a0,a0,-692 # 6568 <malloc+0x1166>
    2824:	728020ef          	jal	4f4c <unlink>
  unlink("12345678901234/12345678901234/12345678901234");
    2828:	00004517          	auipc	a0,0x4
    282c:	cd050513          	addi	a0,a0,-816 # 64f8 <malloc+0x10f6>
    2830:	71c020ef          	jal	4f4c <unlink>
  unlink("123456789012345/123456789012345/123456789012345");
    2834:	00004517          	auipc	a0,0x4
    2838:	c4c50513          	addi	a0,a0,-948 # 6480 <malloc+0x107e>
    283c:	710020ef          	jal	4f4c <unlink>
  unlink("12345678901234/123456789012345");
    2840:	00004517          	auipc	a0,0x4
    2844:	be850513          	addi	a0,a0,-1048 # 6428 <malloc+0x1026>
    2848:	704020ef          	jal	4f4c <unlink>
  unlink("12345678901234");
    284c:	00004517          	auipc	a0,0x4
    2850:	d8450513          	addi	a0,a0,-636 # 65d0 <malloc+0x11ce>
    2854:	6f8020ef          	jal	4f4c <unlink>
}
    2858:	60e2                	ld	ra,24(sp)
    285a:	6442                	ld	s0,16(sp)
    285c:	64a2                	ld	s1,8(sp)
    285e:	6105                	addi	sp,sp,32
    2860:	8082                	ret
    printf("%s: mkdir 12345678901234 failed\n", s);
    2862:	85a6                	mv	a1,s1
    2864:	00004517          	auipc	a0,0x4
    2868:	b9c50513          	addi	a0,a0,-1124 # 6400 <malloc+0xffe>
    286c:	2df020ef          	jal	534a <printf>
    exit(1);
    2870:	4505                	li	a0,1
    2872:	68a020ef          	jal	4efc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 failed\n", s);
    2876:	85a6                	mv	a1,s1
    2878:	00004517          	auipc	a0,0x4
    287c:	bd050513          	addi	a0,a0,-1072 # 6448 <malloc+0x1046>
    2880:	2cb020ef          	jal	534a <printf>
    exit(1);
    2884:	4505                	li	a0,1
    2886:	676020ef          	jal	4efc <exit>
    printf("%s: create 123456789012345/123456789012345/123456789012345 failed\n", s);
    288a:	85a6                	mv	a1,s1
    288c:	00004517          	auipc	a0,0x4
    2890:	c2450513          	addi	a0,a0,-988 # 64b0 <malloc+0x10ae>
    2894:	2b7020ef          	jal	534a <printf>
    exit(1);
    2898:	4505                	li	a0,1
    289a:	662020ef          	jal	4efc <exit>
    printf("%s: open 12345678901234/12345678901234/12345678901234 failed\n", s);
    289e:	85a6                	mv	a1,s1
    28a0:	00004517          	auipc	a0,0x4
    28a4:	c8850513          	addi	a0,a0,-888 # 6528 <malloc+0x1126>
    28a8:	2a3020ef          	jal	534a <printf>
    exit(1);
    28ac:	4505                	li	a0,1
    28ae:	64e020ef          	jal	4efc <exit>
    printf("%s: mkdir 12345678901234/12345678901234 succeeded!\n", s);
    28b2:	85a6                	mv	a1,s1
    28b4:	00004517          	auipc	a0,0x4
    28b8:	cd450513          	addi	a0,a0,-812 # 6588 <malloc+0x1186>
    28bc:	28f020ef          	jal	534a <printf>
    exit(1);
    28c0:	4505                	li	a0,1
    28c2:	63a020ef          	jal	4efc <exit>
    printf("%s: mkdir 12345678901234/123456789012345 succeeded!\n", s);
    28c6:	85a6                	mv	a1,s1
    28c8:	00004517          	auipc	a0,0x4
    28cc:	d1850513          	addi	a0,a0,-744 # 65e0 <malloc+0x11de>
    28d0:	27b020ef          	jal	534a <printf>
    exit(1);
    28d4:	4505                	li	a0,1
    28d6:	626020ef          	jal	4efc <exit>

00000000000028da <diskfull>:
{
    28da:	b6010113          	addi	sp,sp,-1184
    28de:	48113c23          	sd	ra,1176(sp)
    28e2:	48813823          	sd	s0,1168(sp)
    28e6:	48913423          	sd	s1,1160(sp)
    28ea:	49213023          	sd	s2,1152(sp)
    28ee:	47313c23          	sd	s3,1144(sp)
    28f2:	47413823          	sd	s4,1136(sp)
    28f6:	47513423          	sd	s5,1128(sp)
    28fa:	47613023          	sd	s6,1120(sp)
    28fe:	45713c23          	sd	s7,1112(sp)
    2902:	45813823          	sd	s8,1104(sp)
    2906:	45913423          	sd	s9,1096(sp)
    290a:	45a13023          	sd	s10,1088(sp)
    290e:	43b13c23          	sd	s11,1080(sp)
    2912:	4a010413          	addi	s0,sp,1184
    2916:	b6a43423          	sd	a0,-1176(s0)
  unlink("diskfulldir");
    291a:	00004517          	auipc	a0,0x4
    291e:	cfe50513          	addi	a0,a0,-770 # 6618 <malloc+0x1216>
    2922:	62a020ef          	jal	4f4c <unlink>
    2926:	03000a93          	li	s5,48
    name[0] = 'b';
    292a:	06200d93          	li	s11,98
    name[1] = 'i';
    292e:	06900d13          	li	s10,105
    name[2] = 'g';
    2932:	06700c93          	li	s9,103
    unlink(name);
    2936:	b7040b13          	addi	s6,s0,-1168
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    293a:	60200c13          	li	s8,1538
    293e:	6bc1                	lui	s7,0x10
    2940:	10bb8b93          	addi	s7,s7,267 # 1010b <base+0x1463>
      if(write(fd, buf, BSIZE) != BSIZE){
    2944:	b9040a13          	addi	s4,s0,-1136
    2948:	aa8d                	j	2aba <diskfull+0x1e0>
      printf("%s: could not create file %s\n", s, name);
    294a:	b7040613          	addi	a2,s0,-1168
    294e:	b6843583          	ld	a1,-1176(s0)
    2952:	00004517          	auipc	a0,0x4
    2956:	cd650513          	addi	a0,a0,-810 # 6628 <malloc+0x1226>
    295a:	1f1020ef          	jal	534a <printf>
      break;
    295e:	a039                	j	296c <diskfull+0x92>
        close(fd);
    2960:	854e                	mv	a0,s3
    2962:	5c2020ef          	jal	4f24 <close>
    close(fd);
    2966:	854e                	mv	a0,s3
    2968:	5bc020ef          	jal	4f24 <close>
  for(int i = 0; i < nzz; i++){
    296c:	4481                	li	s1,0
    name[0] = 'z';
    296e:	07a00993          	li	s3,122
    unlink(name);
    2972:	b9040913          	addi	s2,s0,-1136
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2976:	60200a13          	li	s4,1538
  for(int i = 0; i < nzz; i++){
    297a:	08000a93          	li	s5,128
    name[0] = 'z';
    297e:	b9340823          	sb	s3,-1136(s0)
    name[1] = 'z';
    2982:	b93408a3          	sb	s3,-1135(s0)
    name[2] = '0' + (i / 32);
    2986:	41f4d71b          	sraiw	a4,s1,0x1f
    298a:	01b7571b          	srliw	a4,a4,0x1b
    298e:	009707bb          	addw	a5,a4,s1
    2992:	4057d69b          	sraiw	a3,a5,0x5
    2996:	0306869b          	addiw	a3,a3,48
    299a:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    299e:	8bfd                	andi	a5,a5,31
    29a0:	9f99                	subw	a5,a5,a4
    29a2:	0307879b          	addiw	a5,a5,48
    29a6:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    29aa:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    29ae:	854a                	mv	a0,s2
    29b0:	59c020ef          	jal	4f4c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    29b4:	85d2                	mv	a1,s4
    29b6:	854a                	mv	a0,s2
    29b8:	584020ef          	jal	4f3c <open>
    if(fd < 0)
    29bc:	00054763          	bltz	a0,29ca <diskfull+0xf0>
    close(fd);
    29c0:	564020ef          	jal	4f24 <close>
  for(int i = 0; i < nzz; i++){
    29c4:	2485                	addiw	s1,s1,1
    29c6:	fb549ce3          	bne	s1,s5,297e <diskfull+0xa4>
  if(mkdir("diskfulldir") == 0)
    29ca:	00004517          	auipc	a0,0x4
    29ce:	c4e50513          	addi	a0,a0,-946 # 6618 <malloc+0x1216>
    29d2:	592020ef          	jal	4f64 <mkdir>
    29d6:	12050363          	beqz	a0,2afc <diskfull+0x222>
  unlink("diskfulldir");
    29da:	00004517          	auipc	a0,0x4
    29de:	c3e50513          	addi	a0,a0,-962 # 6618 <malloc+0x1216>
    29e2:	56a020ef          	jal	4f4c <unlink>
  for(int i = 0; i < nzz; i++){
    29e6:	4481                	li	s1,0
    name[0] = 'z';
    29e8:	07a00913          	li	s2,122
    unlink(name);
    29ec:	b9040a13          	addi	s4,s0,-1136
  for(int i = 0; i < nzz; i++){
    29f0:	08000993          	li	s3,128
    name[0] = 'z';
    29f4:	b9240823          	sb	s2,-1136(s0)
    name[1] = 'z';
    29f8:	b92408a3          	sb	s2,-1135(s0)
    name[2] = '0' + (i / 32);
    29fc:	41f4d71b          	sraiw	a4,s1,0x1f
    2a00:	01b7571b          	srliw	a4,a4,0x1b
    2a04:	009707bb          	addw	a5,a4,s1
    2a08:	4057d69b          	sraiw	a3,a5,0x5
    2a0c:	0306869b          	addiw	a3,a3,48
    2a10:	b8d40923          	sb	a3,-1134(s0)
    name[3] = '0' + (i % 32);
    2a14:	8bfd                	andi	a5,a5,31
    2a16:	9f99                	subw	a5,a5,a4
    2a18:	0307879b          	addiw	a5,a5,48
    2a1c:	b8f409a3          	sb	a5,-1133(s0)
    name[4] = '\0';
    2a20:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a24:	8552                	mv	a0,s4
    2a26:	526020ef          	jal	4f4c <unlink>
  for(int i = 0; i < nzz; i++){
    2a2a:	2485                	addiw	s1,s1,1
    2a2c:	fd3494e3          	bne	s1,s3,29f4 <diskfull+0x11a>
    2a30:	03000493          	li	s1,48
    name[0] = 'b';
    2a34:	06200b13          	li	s6,98
    name[1] = 'i';
    2a38:	06900a93          	li	s5,105
    name[2] = 'g';
    2a3c:	06700a13          	li	s4,103
    unlink(name);
    2a40:	b9040993          	addi	s3,s0,-1136
  for(int i = 0; '0' + i < 0177; i++){
    2a44:	07f00913          	li	s2,127
    name[0] = 'b';
    2a48:	b9640823          	sb	s6,-1136(s0)
    name[1] = 'i';
    2a4c:	b95408a3          	sb	s5,-1135(s0)
    name[2] = 'g';
    2a50:	b9440923          	sb	s4,-1134(s0)
    name[3] = '0' + i;
    2a54:	b89409a3          	sb	s1,-1133(s0)
    name[4] = '\0';
    2a58:	b8040a23          	sb	zero,-1132(s0)
    unlink(name);
    2a5c:	854e                	mv	a0,s3
    2a5e:	4ee020ef          	jal	4f4c <unlink>
  for(int i = 0; '0' + i < 0177; i++){
    2a62:	2485                	addiw	s1,s1,1
    2a64:	0ff4f493          	zext.b	s1,s1
    2a68:	ff2490e3          	bne	s1,s2,2a48 <diskfull+0x16e>
}
    2a6c:	49813083          	ld	ra,1176(sp)
    2a70:	49013403          	ld	s0,1168(sp)
    2a74:	48813483          	ld	s1,1160(sp)
    2a78:	48013903          	ld	s2,1152(sp)
    2a7c:	47813983          	ld	s3,1144(sp)
    2a80:	47013a03          	ld	s4,1136(sp)
    2a84:	46813a83          	ld	s5,1128(sp)
    2a88:	46013b03          	ld	s6,1120(sp)
    2a8c:	45813b83          	ld	s7,1112(sp)
    2a90:	45013c03          	ld	s8,1104(sp)
    2a94:	44813c83          	ld	s9,1096(sp)
    2a98:	44013d03          	ld	s10,1088(sp)
    2a9c:	43813d83          	ld	s11,1080(sp)
    2aa0:	4a010113          	addi	sp,sp,1184
    2aa4:	8082                	ret
    close(fd);
    2aa6:	854e                	mv	a0,s3
    2aa8:	47c020ef          	jal	4f24 <close>
  for(fi = 0; done == 0 && '0' + fi < 0177; fi++){
    2aac:	2a85                	addiw	s5,s5,1 # 3001 <subdir+0x2fb>
    2aae:	0ffafa93          	zext.b	s5,s5
    2ab2:	07f00793          	li	a5,127
    2ab6:	eafa8be3          	beq	s5,a5,296c <diskfull+0x92>
    name[0] = 'b';
    2aba:	b7b40823          	sb	s11,-1168(s0)
    name[1] = 'i';
    2abe:	b7a408a3          	sb	s10,-1167(s0)
    name[2] = 'g';
    2ac2:	b7940923          	sb	s9,-1166(s0)
    name[3] = '0' + fi;
    2ac6:	b75409a3          	sb	s5,-1165(s0)
    name[4] = '\0';
    2aca:	b6040a23          	sb	zero,-1164(s0)
    unlink(name);
    2ace:	855a                	mv	a0,s6
    2ad0:	47c020ef          	jal	4f4c <unlink>
    int fd = open(name, O_CREATE|O_RDWR|O_TRUNC);
    2ad4:	85e2                	mv	a1,s8
    2ad6:	855a                	mv	a0,s6
    2ad8:	464020ef          	jal	4f3c <open>
    2adc:	89aa                	mv	s3,a0
    if(fd < 0){
    2ade:	e60546e3          	bltz	a0,294a <diskfull+0x70>
    2ae2:	84de                	mv	s1,s7
      if(write(fd, buf, BSIZE) != BSIZE){
    2ae4:	40000913          	li	s2,1024
    2ae8:	864a                	mv	a2,s2
    2aea:	85d2                	mv	a1,s4
    2aec:	854e                	mv	a0,s3
    2aee:	42e020ef          	jal	4f1c <write>
    2af2:	e72517e3          	bne	a0,s2,2960 <diskfull+0x86>
    for(int i = 0; i < MAXFILE; i++){
    2af6:	34fd                	addiw	s1,s1,-1
    2af8:	f8e5                	bnez	s1,2ae8 <diskfull+0x20e>
    2afa:	b775                	j	2aa6 <diskfull+0x1cc>
    printf("%s: mkdir(diskfulldir) unexpectedly succeeded!\n", s);
    2afc:	b6843583          	ld	a1,-1176(s0)
    2b00:	00004517          	auipc	a0,0x4
    2b04:	b4850513          	addi	a0,a0,-1208 # 6648 <malloc+0x1246>
    2b08:	043020ef          	jal	534a <printf>
    2b0c:	b5f9                	j	29da <diskfull+0x100>

0000000000002b0e <iputtest>:
{
    2b0e:	1101                	addi	sp,sp,-32
    2b10:	ec06                	sd	ra,24(sp)
    2b12:	e822                	sd	s0,16(sp)
    2b14:	e426                	sd	s1,8(sp)
    2b16:	1000                	addi	s0,sp,32
    2b18:	84aa                	mv	s1,a0
  if(mkdir("iputdir") < 0){
    2b1a:	00004517          	auipc	a0,0x4
    2b1e:	b5e50513          	addi	a0,a0,-1186 # 6678 <malloc+0x1276>
    2b22:	442020ef          	jal	4f64 <mkdir>
    2b26:	02054f63          	bltz	a0,2b64 <iputtest+0x56>
  if(chdir("iputdir") < 0){
    2b2a:	00004517          	auipc	a0,0x4
    2b2e:	b4e50513          	addi	a0,a0,-1202 # 6678 <malloc+0x1276>
    2b32:	43a020ef          	jal	4f6c <chdir>
    2b36:	04054163          	bltz	a0,2b78 <iputtest+0x6a>
  if(unlink("../iputdir") < 0){
    2b3a:	00004517          	auipc	a0,0x4
    2b3e:	b7e50513          	addi	a0,a0,-1154 # 66b8 <malloc+0x12b6>
    2b42:	40a020ef          	jal	4f4c <unlink>
    2b46:	04054363          	bltz	a0,2b8c <iputtest+0x7e>
  if(chdir("/") < 0){
    2b4a:	00004517          	auipc	a0,0x4
    2b4e:	b9e50513          	addi	a0,a0,-1122 # 66e8 <malloc+0x12e6>
    2b52:	41a020ef          	jal	4f6c <chdir>
    2b56:	04054563          	bltz	a0,2ba0 <iputtest+0x92>
}
    2b5a:	60e2                	ld	ra,24(sp)
    2b5c:	6442                	ld	s0,16(sp)
    2b5e:	64a2                	ld	s1,8(sp)
    2b60:	6105                	addi	sp,sp,32
    2b62:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2b64:	85a6                	mv	a1,s1
    2b66:	00004517          	auipc	a0,0x4
    2b6a:	b1a50513          	addi	a0,a0,-1254 # 6680 <malloc+0x127e>
    2b6e:	7dc020ef          	jal	534a <printf>
    exit(1);
    2b72:	4505                	li	a0,1
    2b74:	388020ef          	jal	4efc <exit>
    printf("%s: chdir iputdir failed\n", s);
    2b78:	85a6                	mv	a1,s1
    2b7a:	00004517          	auipc	a0,0x4
    2b7e:	b1e50513          	addi	a0,a0,-1250 # 6698 <malloc+0x1296>
    2b82:	7c8020ef          	jal	534a <printf>
    exit(1);
    2b86:	4505                	li	a0,1
    2b88:	374020ef          	jal	4efc <exit>
    printf("%s: unlink ../iputdir failed\n", s);
    2b8c:	85a6                	mv	a1,s1
    2b8e:	00004517          	auipc	a0,0x4
    2b92:	b3a50513          	addi	a0,a0,-1222 # 66c8 <malloc+0x12c6>
    2b96:	7b4020ef          	jal	534a <printf>
    exit(1);
    2b9a:	4505                	li	a0,1
    2b9c:	360020ef          	jal	4efc <exit>
    printf("%s: chdir / failed\n", s);
    2ba0:	85a6                	mv	a1,s1
    2ba2:	00004517          	auipc	a0,0x4
    2ba6:	b4e50513          	addi	a0,a0,-1202 # 66f0 <malloc+0x12ee>
    2baa:	7a0020ef          	jal	534a <printf>
    exit(1);
    2bae:	4505                	li	a0,1
    2bb0:	34c020ef          	jal	4efc <exit>

0000000000002bb4 <exitiputtest>:
{
    2bb4:	7179                	addi	sp,sp,-48
    2bb6:	f406                	sd	ra,40(sp)
    2bb8:	f022                	sd	s0,32(sp)
    2bba:	ec26                	sd	s1,24(sp)
    2bbc:	1800                	addi	s0,sp,48
    2bbe:	84aa                	mv	s1,a0
  pid = fork();
    2bc0:	334020ef          	jal	4ef4 <fork>
  if(pid < 0){
    2bc4:	02054e63          	bltz	a0,2c00 <exitiputtest+0x4c>
  if(pid == 0){
    2bc8:	e541                	bnez	a0,2c50 <exitiputtest+0x9c>
    if(mkdir("iputdir") < 0){
    2bca:	00004517          	auipc	a0,0x4
    2bce:	aae50513          	addi	a0,a0,-1362 # 6678 <malloc+0x1276>
    2bd2:	392020ef          	jal	4f64 <mkdir>
    2bd6:	02054f63          	bltz	a0,2c14 <exitiputtest+0x60>
    if(chdir("iputdir") < 0){
    2bda:	00004517          	auipc	a0,0x4
    2bde:	a9e50513          	addi	a0,a0,-1378 # 6678 <malloc+0x1276>
    2be2:	38a020ef          	jal	4f6c <chdir>
    2be6:	04054163          	bltz	a0,2c28 <exitiputtest+0x74>
    if(unlink("../iputdir") < 0){
    2bea:	00004517          	auipc	a0,0x4
    2bee:	ace50513          	addi	a0,a0,-1330 # 66b8 <malloc+0x12b6>
    2bf2:	35a020ef          	jal	4f4c <unlink>
    2bf6:	04054363          	bltz	a0,2c3c <exitiputtest+0x88>
    exit(0);
    2bfa:	4501                	li	a0,0
    2bfc:	300020ef          	jal	4efc <exit>
    printf("%s: fork failed\n", s);
    2c00:	85a6                	mv	a1,s1
    2c02:	00003517          	auipc	a0,0x3
    2c06:	1c650513          	addi	a0,a0,454 # 5dc8 <malloc+0x9c6>
    2c0a:	740020ef          	jal	534a <printf>
    exit(1);
    2c0e:	4505                	li	a0,1
    2c10:	2ec020ef          	jal	4efc <exit>
      printf("%s: mkdir failed\n", s);
    2c14:	85a6                	mv	a1,s1
    2c16:	00004517          	auipc	a0,0x4
    2c1a:	a6a50513          	addi	a0,a0,-1430 # 6680 <malloc+0x127e>
    2c1e:	72c020ef          	jal	534a <printf>
      exit(1);
    2c22:	4505                	li	a0,1
    2c24:	2d8020ef          	jal	4efc <exit>
      printf("%s: child chdir failed\n", s);
    2c28:	85a6                	mv	a1,s1
    2c2a:	00004517          	auipc	a0,0x4
    2c2e:	ade50513          	addi	a0,a0,-1314 # 6708 <malloc+0x1306>
    2c32:	718020ef          	jal	534a <printf>
      exit(1);
    2c36:	4505                	li	a0,1
    2c38:	2c4020ef          	jal	4efc <exit>
      printf("%s: unlink ../iputdir failed\n", s);
    2c3c:	85a6                	mv	a1,s1
    2c3e:	00004517          	auipc	a0,0x4
    2c42:	a8a50513          	addi	a0,a0,-1398 # 66c8 <malloc+0x12c6>
    2c46:	704020ef          	jal	534a <printf>
      exit(1);
    2c4a:	4505                	li	a0,1
    2c4c:	2b0020ef          	jal	4efc <exit>
  wait(&xstatus);
    2c50:	fdc40513          	addi	a0,s0,-36
    2c54:	2b0020ef          	jal	4f04 <wait>
  exit(xstatus);
    2c58:	fdc42503          	lw	a0,-36(s0)
    2c5c:	2a0020ef          	jal	4efc <exit>

0000000000002c60 <dirtest>:
{
    2c60:	1101                	addi	sp,sp,-32
    2c62:	ec06                	sd	ra,24(sp)
    2c64:	e822                	sd	s0,16(sp)
    2c66:	e426                	sd	s1,8(sp)
    2c68:	1000                	addi	s0,sp,32
    2c6a:	84aa                	mv	s1,a0
  if(mkdir("dir0") < 0){
    2c6c:	00004517          	auipc	a0,0x4
    2c70:	ab450513          	addi	a0,a0,-1356 # 6720 <malloc+0x131e>
    2c74:	2f0020ef          	jal	4f64 <mkdir>
    2c78:	02054f63          	bltz	a0,2cb6 <dirtest+0x56>
  if(chdir("dir0") < 0){
    2c7c:	00004517          	auipc	a0,0x4
    2c80:	aa450513          	addi	a0,a0,-1372 # 6720 <malloc+0x131e>
    2c84:	2e8020ef          	jal	4f6c <chdir>
    2c88:	04054163          	bltz	a0,2cca <dirtest+0x6a>
  if(chdir("..") < 0){
    2c8c:	00004517          	auipc	a0,0x4
    2c90:	ab450513          	addi	a0,a0,-1356 # 6740 <malloc+0x133e>
    2c94:	2d8020ef          	jal	4f6c <chdir>
    2c98:	04054363          	bltz	a0,2cde <dirtest+0x7e>
  if(unlink("dir0") < 0){
    2c9c:	00004517          	auipc	a0,0x4
    2ca0:	a8450513          	addi	a0,a0,-1404 # 6720 <malloc+0x131e>
    2ca4:	2a8020ef          	jal	4f4c <unlink>
    2ca8:	04054563          	bltz	a0,2cf2 <dirtest+0x92>
}
    2cac:	60e2                	ld	ra,24(sp)
    2cae:	6442                	ld	s0,16(sp)
    2cb0:	64a2                	ld	s1,8(sp)
    2cb2:	6105                	addi	sp,sp,32
    2cb4:	8082                	ret
    printf("%s: mkdir failed\n", s);
    2cb6:	85a6                	mv	a1,s1
    2cb8:	00004517          	auipc	a0,0x4
    2cbc:	9c850513          	addi	a0,a0,-1592 # 6680 <malloc+0x127e>
    2cc0:	68a020ef          	jal	534a <printf>
    exit(1);
    2cc4:	4505                	li	a0,1
    2cc6:	236020ef          	jal	4efc <exit>
    printf("%s: chdir dir0 failed\n", s);
    2cca:	85a6                	mv	a1,s1
    2ccc:	00004517          	auipc	a0,0x4
    2cd0:	a5c50513          	addi	a0,a0,-1444 # 6728 <malloc+0x1326>
    2cd4:	676020ef          	jal	534a <printf>
    exit(1);
    2cd8:	4505                	li	a0,1
    2cda:	222020ef          	jal	4efc <exit>
    printf("%s: chdir .. failed\n", s);
    2cde:	85a6                	mv	a1,s1
    2ce0:	00004517          	auipc	a0,0x4
    2ce4:	a6850513          	addi	a0,a0,-1432 # 6748 <malloc+0x1346>
    2ce8:	662020ef          	jal	534a <printf>
    exit(1);
    2cec:	4505                	li	a0,1
    2cee:	20e020ef          	jal	4efc <exit>
    printf("%s: unlink dir0 failed\n", s);
    2cf2:	85a6                	mv	a1,s1
    2cf4:	00004517          	auipc	a0,0x4
    2cf8:	a6c50513          	addi	a0,a0,-1428 # 6760 <malloc+0x135e>
    2cfc:	64e020ef          	jal	534a <printf>
    exit(1);
    2d00:	4505                	li	a0,1
    2d02:	1fa020ef          	jal	4efc <exit>

0000000000002d06 <subdir>:
{
    2d06:	1101                	addi	sp,sp,-32
    2d08:	ec06                	sd	ra,24(sp)
    2d0a:	e822                	sd	s0,16(sp)
    2d0c:	e426                	sd	s1,8(sp)
    2d0e:	e04a                	sd	s2,0(sp)
    2d10:	1000                	addi	s0,sp,32
    2d12:	892a                	mv	s2,a0
  unlink("ff");
    2d14:	00004517          	auipc	a0,0x4
    2d18:	b9450513          	addi	a0,a0,-1132 # 68a8 <malloc+0x14a6>
    2d1c:	230020ef          	jal	4f4c <unlink>
  if(mkdir("dd") != 0){
    2d20:	00004517          	auipc	a0,0x4
    2d24:	a5850513          	addi	a0,a0,-1448 # 6778 <malloc+0x1376>
    2d28:	23c020ef          	jal	4f64 <mkdir>
    2d2c:	2e051263          	bnez	a0,3010 <subdir+0x30a>
  fd = open("dd/ff", O_CREATE | O_RDWR);
    2d30:	20200593          	li	a1,514
    2d34:	00004517          	auipc	a0,0x4
    2d38:	a6450513          	addi	a0,a0,-1436 # 6798 <malloc+0x1396>
    2d3c:	200020ef          	jal	4f3c <open>
    2d40:	84aa                	mv	s1,a0
  if(fd < 0){
    2d42:	2e054163          	bltz	a0,3024 <subdir+0x31e>
  write(fd, "ff", 2);
    2d46:	4609                	li	a2,2
    2d48:	00004597          	auipc	a1,0x4
    2d4c:	b6058593          	addi	a1,a1,-1184 # 68a8 <malloc+0x14a6>
    2d50:	1cc020ef          	jal	4f1c <write>
  close(fd);
    2d54:	8526                	mv	a0,s1
    2d56:	1ce020ef          	jal	4f24 <close>
  if(unlink("dd") >= 0){
    2d5a:	00004517          	auipc	a0,0x4
    2d5e:	a1e50513          	addi	a0,a0,-1506 # 6778 <malloc+0x1376>
    2d62:	1ea020ef          	jal	4f4c <unlink>
    2d66:	2c055963          	bgez	a0,3038 <subdir+0x332>
  if(mkdir("/dd/dd") != 0){
    2d6a:	00004517          	auipc	a0,0x4
    2d6e:	a8650513          	addi	a0,a0,-1402 # 67f0 <malloc+0x13ee>
    2d72:	1f2020ef          	jal	4f64 <mkdir>
    2d76:	2c051b63          	bnez	a0,304c <subdir+0x346>
  fd = open("dd/dd/ff", O_CREATE | O_RDWR);
    2d7a:	20200593          	li	a1,514
    2d7e:	00004517          	auipc	a0,0x4
    2d82:	a9a50513          	addi	a0,a0,-1382 # 6818 <malloc+0x1416>
    2d86:	1b6020ef          	jal	4f3c <open>
    2d8a:	84aa                	mv	s1,a0
  if(fd < 0){
    2d8c:	2c054a63          	bltz	a0,3060 <subdir+0x35a>
  write(fd, "FF", 2);
    2d90:	4609                	li	a2,2
    2d92:	00004597          	auipc	a1,0x4
    2d96:	ab658593          	addi	a1,a1,-1354 # 6848 <malloc+0x1446>
    2d9a:	182020ef          	jal	4f1c <write>
  close(fd);
    2d9e:	8526                	mv	a0,s1
    2da0:	184020ef          	jal	4f24 <close>
  fd = open("dd/dd/../ff", 0);
    2da4:	4581                	li	a1,0
    2da6:	00004517          	auipc	a0,0x4
    2daa:	aaa50513          	addi	a0,a0,-1366 # 6850 <malloc+0x144e>
    2dae:	18e020ef          	jal	4f3c <open>
    2db2:	84aa                	mv	s1,a0
  if(fd < 0){
    2db4:	2c054063          	bltz	a0,3074 <subdir+0x36e>
  cc = read(fd, buf, sizeof(buf));
    2db8:	660d                	lui	a2,0x3
    2dba:	00009597          	auipc	a1,0x9
    2dbe:	eee58593          	addi	a1,a1,-274 # bca8 <buf>
    2dc2:	152020ef          	jal	4f14 <read>
  if(cc != 2 || buf[0] != 'f'){
    2dc6:	4789                	li	a5,2
    2dc8:	2cf51063          	bne	a0,a5,3088 <subdir+0x382>
    2dcc:	00009717          	auipc	a4,0x9
    2dd0:	edc74703          	lbu	a4,-292(a4) # bca8 <buf>
    2dd4:	06600793          	li	a5,102
    2dd8:	2af71863          	bne	a4,a5,3088 <subdir+0x382>
  close(fd);
    2ddc:	8526                	mv	a0,s1
    2dde:	146020ef          	jal	4f24 <close>
  if(link("dd/dd/ff", "dd/dd/ffff") != 0){
    2de2:	00004597          	auipc	a1,0x4
    2de6:	abe58593          	addi	a1,a1,-1346 # 68a0 <malloc+0x149e>
    2dea:	00004517          	auipc	a0,0x4
    2dee:	a2e50513          	addi	a0,a0,-1490 # 6818 <malloc+0x1416>
    2df2:	16a020ef          	jal	4f5c <link>
    2df6:	2a051363          	bnez	a0,309c <subdir+0x396>
  if(unlink("dd/dd/ff") != 0){
    2dfa:	00004517          	auipc	a0,0x4
    2dfe:	a1e50513          	addi	a0,a0,-1506 # 6818 <malloc+0x1416>
    2e02:	14a020ef          	jal	4f4c <unlink>
    2e06:	2a051563          	bnez	a0,30b0 <subdir+0x3aa>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e0a:	4581                	li	a1,0
    2e0c:	00004517          	auipc	a0,0x4
    2e10:	a0c50513          	addi	a0,a0,-1524 # 6818 <malloc+0x1416>
    2e14:	128020ef          	jal	4f3c <open>
    2e18:	2a055663          	bgez	a0,30c4 <subdir+0x3be>
  if(chdir("dd") != 0){
    2e1c:	00004517          	auipc	a0,0x4
    2e20:	95c50513          	addi	a0,a0,-1700 # 6778 <malloc+0x1376>
    2e24:	148020ef          	jal	4f6c <chdir>
    2e28:	2a051863          	bnez	a0,30d8 <subdir+0x3d2>
  if(chdir("dd/../../dd") != 0){
    2e2c:	00004517          	auipc	a0,0x4
    2e30:	b0c50513          	addi	a0,a0,-1268 # 6938 <malloc+0x1536>
    2e34:	138020ef          	jal	4f6c <chdir>
    2e38:	2a051a63          	bnez	a0,30ec <subdir+0x3e6>
  if(chdir("dd/../../../dd") != 0){
    2e3c:	00004517          	auipc	a0,0x4
    2e40:	b2c50513          	addi	a0,a0,-1236 # 6968 <malloc+0x1566>
    2e44:	128020ef          	jal	4f6c <chdir>
    2e48:	2a051c63          	bnez	a0,3100 <subdir+0x3fa>
  if(chdir("./..") != 0){
    2e4c:	00004517          	auipc	a0,0x4
    2e50:	b5450513          	addi	a0,a0,-1196 # 69a0 <malloc+0x159e>
    2e54:	118020ef          	jal	4f6c <chdir>
    2e58:	2a051e63          	bnez	a0,3114 <subdir+0x40e>
  fd = open("dd/dd/ffff", 0);
    2e5c:	4581                	li	a1,0
    2e5e:	00004517          	auipc	a0,0x4
    2e62:	a4250513          	addi	a0,a0,-1470 # 68a0 <malloc+0x149e>
    2e66:	0d6020ef          	jal	4f3c <open>
    2e6a:	84aa                	mv	s1,a0
  if(fd < 0){
    2e6c:	2a054e63          	bltz	a0,3128 <subdir+0x422>
  if(read(fd, buf, sizeof(buf)) != 2){
    2e70:	660d                	lui	a2,0x3
    2e72:	00009597          	auipc	a1,0x9
    2e76:	e3658593          	addi	a1,a1,-458 # bca8 <buf>
    2e7a:	09a020ef          	jal	4f14 <read>
    2e7e:	4789                	li	a5,2
    2e80:	2af51e63          	bne	a0,a5,313c <subdir+0x436>
  close(fd);
    2e84:	8526                	mv	a0,s1
    2e86:	09e020ef          	jal	4f24 <close>
  if(open("dd/dd/ff", O_RDONLY) >= 0){
    2e8a:	4581                	li	a1,0
    2e8c:	00004517          	auipc	a0,0x4
    2e90:	98c50513          	addi	a0,a0,-1652 # 6818 <malloc+0x1416>
    2e94:	0a8020ef          	jal	4f3c <open>
    2e98:	2a055c63          	bgez	a0,3150 <subdir+0x44a>
  if(open("dd/ff/ff", O_CREATE|O_RDWR) >= 0){
    2e9c:	20200593          	li	a1,514
    2ea0:	00004517          	auipc	a0,0x4
    2ea4:	b9050513          	addi	a0,a0,-1136 # 6a30 <malloc+0x162e>
    2ea8:	094020ef          	jal	4f3c <open>
    2eac:	2a055c63          	bgez	a0,3164 <subdir+0x45e>
  if(open("dd/xx/ff", O_CREATE|O_RDWR) >= 0){
    2eb0:	20200593          	li	a1,514
    2eb4:	00004517          	auipc	a0,0x4
    2eb8:	bac50513          	addi	a0,a0,-1108 # 6a60 <malloc+0x165e>
    2ebc:	080020ef          	jal	4f3c <open>
    2ec0:	2a055c63          	bgez	a0,3178 <subdir+0x472>
  if(open("dd", O_CREATE) >= 0){
    2ec4:	20000593          	li	a1,512
    2ec8:	00004517          	auipc	a0,0x4
    2ecc:	8b050513          	addi	a0,a0,-1872 # 6778 <malloc+0x1376>
    2ed0:	06c020ef          	jal	4f3c <open>
    2ed4:	2a055c63          	bgez	a0,318c <subdir+0x486>
  if(open("dd", O_RDWR) >= 0){
    2ed8:	4589                	li	a1,2
    2eda:	00004517          	auipc	a0,0x4
    2ede:	89e50513          	addi	a0,a0,-1890 # 6778 <malloc+0x1376>
    2ee2:	05a020ef          	jal	4f3c <open>
    2ee6:	2a055d63          	bgez	a0,31a0 <subdir+0x49a>
  if(open("dd", O_WRONLY) >= 0){
    2eea:	4585                	li	a1,1
    2eec:	00004517          	auipc	a0,0x4
    2ef0:	88c50513          	addi	a0,a0,-1908 # 6778 <malloc+0x1376>
    2ef4:	048020ef          	jal	4f3c <open>
    2ef8:	2a055e63          	bgez	a0,31b4 <subdir+0x4ae>
  if(link("dd/ff/ff", "dd/dd/xx") == 0){
    2efc:	00004597          	auipc	a1,0x4
    2f00:	bf458593          	addi	a1,a1,-1036 # 6af0 <malloc+0x16ee>
    2f04:	00004517          	auipc	a0,0x4
    2f08:	b2c50513          	addi	a0,a0,-1236 # 6a30 <malloc+0x162e>
    2f0c:	050020ef          	jal	4f5c <link>
    2f10:	2a050c63          	beqz	a0,31c8 <subdir+0x4c2>
  if(link("dd/xx/ff", "dd/dd/xx") == 0){
    2f14:	00004597          	auipc	a1,0x4
    2f18:	bdc58593          	addi	a1,a1,-1060 # 6af0 <malloc+0x16ee>
    2f1c:	00004517          	auipc	a0,0x4
    2f20:	b4450513          	addi	a0,a0,-1212 # 6a60 <malloc+0x165e>
    2f24:	038020ef          	jal	4f5c <link>
    2f28:	2a050a63          	beqz	a0,31dc <subdir+0x4d6>
  if(link("dd/ff", "dd/dd/ffff") == 0){
    2f2c:	00004597          	auipc	a1,0x4
    2f30:	97458593          	addi	a1,a1,-1676 # 68a0 <malloc+0x149e>
    2f34:	00004517          	auipc	a0,0x4
    2f38:	86450513          	addi	a0,a0,-1948 # 6798 <malloc+0x1396>
    2f3c:	020020ef          	jal	4f5c <link>
    2f40:	2a050863          	beqz	a0,31f0 <subdir+0x4ea>
  if(mkdir("dd/ff/ff") == 0){
    2f44:	00004517          	auipc	a0,0x4
    2f48:	aec50513          	addi	a0,a0,-1300 # 6a30 <malloc+0x162e>
    2f4c:	018020ef          	jal	4f64 <mkdir>
    2f50:	2a050a63          	beqz	a0,3204 <subdir+0x4fe>
  if(mkdir("dd/xx/ff") == 0){
    2f54:	00004517          	auipc	a0,0x4
    2f58:	b0c50513          	addi	a0,a0,-1268 # 6a60 <malloc+0x165e>
    2f5c:	008020ef          	jal	4f64 <mkdir>
    2f60:	2a050c63          	beqz	a0,3218 <subdir+0x512>
  if(mkdir("dd/dd/ffff") == 0){
    2f64:	00004517          	auipc	a0,0x4
    2f68:	93c50513          	addi	a0,a0,-1732 # 68a0 <malloc+0x149e>
    2f6c:	7f9010ef          	jal	4f64 <mkdir>
    2f70:	2a050e63          	beqz	a0,322c <subdir+0x526>
  if(unlink("dd/xx/ff") == 0){
    2f74:	00004517          	auipc	a0,0x4
    2f78:	aec50513          	addi	a0,a0,-1300 # 6a60 <malloc+0x165e>
    2f7c:	7d1010ef          	jal	4f4c <unlink>
    2f80:	2c050063          	beqz	a0,3240 <subdir+0x53a>
  if(unlink("dd/ff/ff") == 0){
    2f84:	00004517          	auipc	a0,0x4
    2f88:	aac50513          	addi	a0,a0,-1364 # 6a30 <malloc+0x162e>
    2f8c:	7c1010ef          	jal	4f4c <unlink>
    2f90:	2c050263          	beqz	a0,3254 <subdir+0x54e>
  if(chdir("dd/ff") == 0){
    2f94:	00004517          	auipc	a0,0x4
    2f98:	80450513          	addi	a0,a0,-2044 # 6798 <malloc+0x1396>
    2f9c:	7d1010ef          	jal	4f6c <chdir>
    2fa0:	2c050463          	beqz	a0,3268 <subdir+0x562>
  if(chdir("dd/xx") == 0){
    2fa4:	00004517          	auipc	a0,0x4
    2fa8:	c9c50513          	addi	a0,a0,-868 # 6c40 <malloc+0x183e>
    2fac:	7c1010ef          	jal	4f6c <chdir>
    2fb0:	2c050663          	beqz	a0,327c <subdir+0x576>
  if(unlink("dd/dd/ffff") != 0){
    2fb4:	00004517          	auipc	a0,0x4
    2fb8:	8ec50513          	addi	a0,a0,-1812 # 68a0 <malloc+0x149e>
    2fbc:	791010ef          	jal	4f4c <unlink>
    2fc0:	2c051863          	bnez	a0,3290 <subdir+0x58a>
  if(unlink("dd/ff") != 0){
    2fc4:	00003517          	auipc	a0,0x3
    2fc8:	7d450513          	addi	a0,a0,2004 # 6798 <malloc+0x1396>
    2fcc:	781010ef          	jal	4f4c <unlink>
    2fd0:	2c051a63          	bnez	a0,32a4 <subdir+0x59e>
  if(unlink("dd") == 0){
    2fd4:	00003517          	auipc	a0,0x3
    2fd8:	7a450513          	addi	a0,a0,1956 # 6778 <malloc+0x1376>
    2fdc:	771010ef          	jal	4f4c <unlink>
    2fe0:	2c050c63          	beqz	a0,32b8 <subdir+0x5b2>
  if(unlink("dd/dd") < 0){
    2fe4:	00004517          	auipc	a0,0x4
    2fe8:	ccc50513          	addi	a0,a0,-820 # 6cb0 <malloc+0x18ae>
    2fec:	761010ef          	jal	4f4c <unlink>
    2ff0:	2c054e63          	bltz	a0,32cc <subdir+0x5c6>
  if(unlink("dd") < 0){
    2ff4:	00003517          	auipc	a0,0x3
    2ff8:	78450513          	addi	a0,a0,1924 # 6778 <malloc+0x1376>
    2ffc:	751010ef          	jal	4f4c <unlink>
    3000:	2e054063          	bltz	a0,32e0 <subdir+0x5da>
}
    3004:	60e2                	ld	ra,24(sp)
    3006:	6442                	ld	s0,16(sp)
    3008:	64a2                	ld	s1,8(sp)
    300a:	6902                	ld	s2,0(sp)
    300c:	6105                	addi	sp,sp,32
    300e:	8082                	ret
    printf("%s: mkdir dd failed\n", s);
    3010:	85ca                	mv	a1,s2
    3012:	00003517          	auipc	a0,0x3
    3016:	76e50513          	addi	a0,a0,1902 # 6780 <malloc+0x137e>
    301a:	330020ef          	jal	534a <printf>
    exit(1);
    301e:	4505                	li	a0,1
    3020:	6dd010ef          	jal	4efc <exit>
    printf("%s: create dd/ff failed\n", s);
    3024:	85ca                	mv	a1,s2
    3026:	00003517          	auipc	a0,0x3
    302a:	77a50513          	addi	a0,a0,1914 # 67a0 <malloc+0x139e>
    302e:	31c020ef          	jal	534a <printf>
    exit(1);
    3032:	4505                	li	a0,1
    3034:	6c9010ef          	jal	4efc <exit>
    printf("%s: unlink dd (non-empty dir) succeeded!\n", s);
    3038:	85ca                	mv	a1,s2
    303a:	00003517          	auipc	a0,0x3
    303e:	78650513          	addi	a0,a0,1926 # 67c0 <malloc+0x13be>
    3042:	308020ef          	jal	534a <printf>
    exit(1);
    3046:	4505                	li	a0,1
    3048:	6b5010ef          	jal	4efc <exit>
    printf("%s: subdir mkdir dd/dd failed\n", s);
    304c:	85ca                	mv	a1,s2
    304e:	00003517          	auipc	a0,0x3
    3052:	7aa50513          	addi	a0,a0,1962 # 67f8 <malloc+0x13f6>
    3056:	2f4020ef          	jal	534a <printf>
    exit(1);
    305a:	4505                	li	a0,1
    305c:	6a1010ef          	jal	4efc <exit>
    printf("%s: create dd/dd/ff failed\n", s);
    3060:	85ca                	mv	a1,s2
    3062:	00003517          	auipc	a0,0x3
    3066:	7c650513          	addi	a0,a0,1990 # 6828 <malloc+0x1426>
    306a:	2e0020ef          	jal	534a <printf>
    exit(1);
    306e:	4505                	li	a0,1
    3070:	68d010ef          	jal	4efc <exit>
    printf("%s: open dd/dd/../ff failed\n", s);
    3074:	85ca                	mv	a1,s2
    3076:	00003517          	auipc	a0,0x3
    307a:	7ea50513          	addi	a0,a0,2026 # 6860 <malloc+0x145e>
    307e:	2cc020ef          	jal	534a <printf>
    exit(1);
    3082:	4505                	li	a0,1
    3084:	679010ef          	jal	4efc <exit>
    printf("%s: dd/dd/../ff wrong content\n", s);
    3088:	85ca                	mv	a1,s2
    308a:	00003517          	auipc	a0,0x3
    308e:	7f650513          	addi	a0,a0,2038 # 6880 <malloc+0x147e>
    3092:	2b8020ef          	jal	534a <printf>
    exit(1);
    3096:	4505                	li	a0,1
    3098:	665010ef          	jal	4efc <exit>
    printf("%s: link dd/dd/ff dd/dd/ffff failed\n", s);
    309c:	85ca                	mv	a1,s2
    309e:	00004517          	auipc	a0,0x4
    30a2:	81250513          	addi	a0,a0,-2030 # 68b0 <malloc+0x14ae>
    30a6:	2a4020ef          	jal	534a <printf>
    exit(1);
    30aa:	4505                	li	a0,1
    30ac:	651010ef          	jal	4efc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    30b0:	85ca                	mv	a1,s2
    30b2:	00004517          	auipc	a0,0x4
    30b6:	82650513          	addi	a0,a0,-2010 # 68d8 <malloc+0x14d6>
    30ba:	290020ef          	jal	534a <printf>
    exit(1);
    30be:	4505                	li	a0,1
    30c0:	63d010ef          	jal	4efc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded\n", s);
    30c4:	85ca                	mv	a1,s2
    30c6:	00004517          	auipc	a0,0x4
    30ca:	83250513          	addi	a0,a0,-1998 # 68f8 <malloc+0x14f6>
    30ce:	27c020ef          	jal	534a <printf>
    exit(1);
    30d2:	4505                	li	a0,1
    30d4:	629010ef          	jal	4efc <exit>
    printf("%s: chdir dd failed\n", s);
    30d8:	85ca                	mv	a1,s2
    30da:	00004517          	auipc	a0,0x4
    30de:	84650513          	addi	a0,a0,-1978 # 6920 <malloc+0x151e>
    30e2:	268020ef          	jal	534a <printf>
    exit(1);
    30e6:	4505                	li	a0,1
    30e8:	615010ef          	jal	4efc <exit>
    printf("%s: chdir dd/../../dd failed\n", s);
    30ec:	85ca                	mv	a1,s2
    30ee:	00004517          	auipc	a0,0x4
    30f2:	85a50513          	addi	a0,a0,-1958 # 6948 <malloc+0x1546>
    30f6:	254020ef          	jal	534a <printf>
    exit(1);
    30fa:	4505                	li	a0,1
    30fc:	601010ef          	jal	4efc <exit>
    printf("%s: chdir dd/../../../dd failed\n", s);
    3100:	85ca                	mv	a1,s2
    3102:	00004517          	auipc	a0,0x4
    3106:	87650513          	addi	a0,a0,-1930 # 6978 <malloc+0x1576>
    310a:	240020ef          	jal	534a <printf>
    exit(1);
    310e:	4505                	li	a0,1
    3110:	5ed010ef          	jal	4efc <exit>
    printf("%s: chdir ./.. failed\n", s);
    3114:	85ca                	mv	a1,s2
    3116:	00004517          	auipc	a0,0x4
    311a:	89250513          	addi	a0,a0,-1902 # 69a8 <malloc+0x15a6>
    311e:	22c020ef          	jal	534a <printf>
    exit(1);
    3122:	4505                	li	a0,1
    3124:	5d9010ef          	jal	4efc <exit>
    printf("%s: open dd/dd/ffff failed\n", s);
    3128:	85ca                	mv	a1,s2
    312a:	00004517          	auipc	a0,0x4
    312e:	89650513          	addi	a0,a0,-1898 # 69c0 <malloc+0x15be>
    3132:	218020ef          	jal	534a <printf>
    exit(1);
    3136:	4505                	li	a0,1
    3138:	5c5010ef          	jal	4efc <exit>
    printf("%s: read dd/dd/ffff wrong len\n", s);
    313c:	85ca                	mv	a1,s2
    313e:	00004517          	auipc	a0,0x4
    3142:	8a250513          	addi	a0,a0,-1886 # 69e0 <malloc+0x15de>
    3146:	204020ef          	jal	534a <printf>
    exit(1);
    314a:	4505                	li	a0,1
    314c:	5b1010ef          	jal	4efc <exit>
    printf("%s: open (unlinked) dd/dd/ff succeeded!\n", s);
    3150:	85ca                	mv	a1,s2
    3152:	00004517          	auipc	a0,0x4
    3156:	8ae50513          	addi	a0,a0,-1874 # 6a00 <malloc+0x15fe>
    315a:	1f0020ef          	jal	534a <printf>
    exit(1);
    315e:	4505                	li	a0,1
    3160:	59d010ef          	jal	4efc <exit>
    printf("%s: create dd/ff/ff succeeded!\n", s);
    3164:	85ca                	mv	a1,s2
    3166:	00004517          	auipc	a0,0x4
    316a:	8da50513          	addi	a0,a0,-1830 # 6a40 <malloc+0x163e>
    316e:	1dc020ef          	jal	534a <printf>
    exit(1);
    3172:	4505                	li	a0,1
    3174:	589010ef          	jal	4efc <exit>
    printf("%s: create dd/xx/ff succeeded!\n", s);
    3178:	85ca                	mv	a1,s2
    317a:	00004517          	auipc	a0,0x4
    317e:	8f650513          	addi	a0,a0,-1802 # 6a70 <malloc+0x166e>
    3182:	1c8020ef          	jal	534a <printf>
    exit(1);
    3186:	4505                	li	a0,1
    3188:	575010ef          	jal	4efc <exit>
    printf("%s: create dd succeeded!\n", s);
    318c:	85ca                	mv	a1,s2
    318e:	00004517          	auipc	a0,0x4
    3192:	90250513          	addi	a0,a0,-1790 # 6a90 <malloc+0x168e>
    3196:	1b4020ef          	jal	534a <printf>
    exit(1);
    319a:	4505                	li	a0,1
    319c:	561010ef          	jal	4efc <exit>
    printf("%s: open dd rdwr succeeded!\n", s);
    31a0:	85ca                	mv	a1,s2
    31a2:	00004517          	auipc	a0,0x4
    31a6:	90e50513          	addi	a0,a0,-1778 # 6ab0 <malloc+0x16ae>
    31aa:	1a0020ef          	jal	534a <printf>
    exit(1);
    31ae:	4505                	li	a0,1
    31b0:	54d010ef          	jal	4efc <exit>
    printf("%s: open dd wronly succeeded!\n", s);
    31b4:	85ca                	mv	a1,s2
    31b6:	00004517          	auipc	a0,0x4
    31ba:	91a50513          	addi	a0,a0,-1766 # 6ad0 <malloc+0x16ce>
    31be:	18c020ef          	jal	534a <printf>
    exit(1);
    31c2:	4505                	li	a0,1
    31c4:	539010ef          	jal	4efc <exit>
    printf("%s: link dd/ff/ff dd/dd/xx succeeded!\n", s);
    31c8:	85ca                	mv	a1,s2
    31ca:	00004517          	auipc	a0,0x4
    31ce:	93650513          	addi	a0,a0,-1738 # 6b00 <malloc+0x16fe>
    31d2:	178020ef          	jal	534a <printf>
    exit(1);
    31d6:	4505                	li	a0,1
    31d8:	525010ef          	jal	4efc <exit>
    printf("%s: link dd/xx/ff dd/dd/xx succeeded!\n", s);
    31dc:	85ca                	mv	a1,s2
    31de:	00004517          	auipc	a0,0x4
    31e2:	94a50513          	addi	a0,a0,-1718 # 6b28 <malloc+0x1726>
    31e6:	164020ef          	jal	534a <printf>
    exit(1);
    31ea:	4505                	li	a0,1
    31ec:	511010ef          	jal	4efc <exit>
    printf("%s: link dd/ff dd/dd/ffff succeeded!\n", s);
    31f0:	85ca                	mv	a1,s2
    31f2:	00004517          	auipc	a0,0x4
    31f6:	95e50513          	addi	a0,a0,-1698 # 6b50 <malloc+0x174e>
    31fa:	150020ef          	jal	534a <printf>
    exit(1);
    31fe:	4505                	li	a0,1
    3200:	4fd010ef          	jal	4efc <exit>
    printf("%s: mkdir dd/ff/ff succeeded!\n", s);
    3204:	85ca                	mv	a1,s2
    3206:	00004517          	auipc	a0,0x4
    320a:	97250513          	addi	a0,a0,-1678 # 6b78 <malloc+0x1776>
    320e:	13c020ef          	jal	534a <printf>
    exit(1);
    3212:	4505                	li	a0,1
    3214:	4e9010ef          	jal	4efc <exit>
    printf("%s: mkdir dd/xx/ff succeeded!\n", s);
    3218:	85ca                	mv	a1,s2
    321a:	00004517          	auipc	a0,0x4
    321e:	97e50513          	addi	a0,a0,-1666 # 6b98 <malloc+0x1796>
    3222:	128020ef          	jal	534a <printf>
    exit(1);
    3226:	4505                	li	a0,1
    3228:	4d5010ef          	jal	4efc <exit>
    printf("%s: mkdir dd/dd/ffff succeeded!\n", s);
    322c:	85ca                	mv	a1,s2
    322e:	00004517          	auipc	a0,0x4
    3232:	98a50513          	addi	a0,a0,-1654 # 6bb8 <malloc+0x17b6>
    3236:	114020ef          	jal	534a <printf>
    exit(1);
    323a:	4505                	li	a0,1
    323c:	4c1010ef          	jal	4efc <exit>
    printf("%s: unlink dd/xx/ff succeeded!\n", s);
    3240:	85ca                	mv	a1,s2
    3242:	00004517          	auipc	a0,0x4
    3246:	99e50513          	addi	a0,a0,-1634 # 6be0 <malloc+0x17de>
    324a:	100020ef          	jal	534a <printf>
    exit(1);
    324e:	4505                	li	a0,1
    3250:	4ad010ef          	jal	4efc <exit>
    printf("%s: unlink dd/ff/ff succeeded!\n", s);
    3254:	85ca                	mv	a1,s2
    3256:	00004517          	auipc	a0,0x4
    325a:	9aa50513          	addi	a0,a0,-1622 # 6c00 <malloc+0x17fe>
    325e:	0ec020ef          	jal	534a <printf>
    exit(1);
    3262:	4505                	li	a0,1
    3264:	499010ef          	jal	4efc <exit>
    printf("%s: chdir dd/ff succeeded!\n", s);
    3268:	85ca                	mv	a1,s2
    326a:	00004517          	auipc	a0,0x4
    326e:	9b650513          	addi	a0,a0,-1610 # 6c20 <malloc+0x181e>
    3272:	0d8020ef          	jal	534a <printf>
    exit(1);
    3276:	4505                	li	a0,1
    3278:	485010ef          	jal	4efc <exit>
    printf("%s: chdir dd/xx succeeded!\n", s);
    327c:	85ca                	mv	a1,s2
    327e:	00004517          	auipc	a0,0x4
    3282:	9ca50513          	addi	a0,a0,-1590 # 6c48 <malloc+0x1846>
    3286:	0c4020ef          	jal	534a <printf>
    exit(1);
    328a:	4505                	li	a0,1
    328c:	471010ef          	jal	4efc <exit>
    printf("%s: unlink dd/dd/ff failed\n", s);
    3290:	85ca                	mv	a1,s2
    3292:	00003517          	auipc	a0,0x3
    3296:	64650513          	addi	a0,a0,1606 # 68d8 <malloc+0x14d6>
    329a:	0b0020ef          	jal	534a <printf>
    exit(1);
    329e:	4505                	li	a0,1
    32a0:	45d010ef          	jal	4efc <exit>
    printf("%s: unlink dd/ff failed\n", s);
    32a4:	85ca                	mv	a1,s2
    32a6:	00004517          	auipc	a0,0x4
    32aa:	9c250513          	addi	a0,a0,-1598 # 6c68 <malloc+0x1866>
    32ae:	09c020ef          	jal	534a <printf>
    exit(1);
    32b2:	4505                	li	a0,1
    32b4:	449010ef          	jal	4efc <exit>
    printf("%s: unlink non-empty dd succeeded!\n", s);
    32b8:	85ca                	mv	a1,s2
    32ba:	00004517          	auipc	a0,0x4
    32be:	9ce50513          	addi	a0,a0,-1586 # 6c88 <malloc+0x1886>
    32c2:	088020ef          	jal	534a <printf>
    exit(1);
    32c6:	4505                	li	a0,1
    32c8:	435010ef          	jal	4efc <exit>
    printf("%s: unlink dd/dd failed\n", s);
    32cc:	85ca                	mv	a1,s2
    32ce:	00004517          	auipc	a0,0x4
    32d2:	9ea50513          	addi	a0,a0,-1558 # 6cb8 <malloc+0x18b6>
    32d6:	074020ef          	jal	534a <printf>
    exit(1);
    32da:	4505                	li	a0,1
    32dc:	421010ef          	jal	4efc <exit>
    printf("%s: unlink dd failed\n", s);
    32e0:	85ca                	mv	a1,s2
    32e2:	00004517          	auipc	a0,0x4
    32e6:	9f650513          	addi	a0,a0,-1546 # 6cd8 <malloc+0x18d6>
    32ea:	060020ef          	jal	534a <printf>
    exit(1);
    32ee:	4505                	li	a0,1
    32f0:	40d010ef          	jal	4efc <exit>

00000000000032f4 <rmdot>:
{
    32f4:	1101                	addi	sp,sp,-32
    32f6:	ec06                	sd	ra,24(sp)
    32f8:	e822                	sd	s0,16(sp)
    32fa:	e426                	sd	s1,8(sp)
    32fc:	1000                	addi	s0,sp,32
    32fe:	84aa                	mv	s1,a0
  if(mkdir("dots") != 0){
    3300:	00004517          	auipc	a0,0x4
    3304:	9f050513          	addi	a0,a0,-1552 # 6cf0 <malloc+0x18ee>
    3308:	45d010ef          	jal	4f64 <mkdir>
    330c:	e53d                	bnez	a0,337a <rmdot+0x86>
  if(chdir("dots") != 0){
    330e:	00004517          	auipc	a0,0x4
    3312:	9e250513          	addi	a0,a0,-1566 # 6cf0 <malloc+0x18ee>
    3316:	457010ef          	jal	4f6c <chdir>
    331a:	e935                	bnez	a0,338e <rmdot+0x9a>
  if(unlink(".") == 0){
    331c:	00003517          	auipc	a0,0x3
    3320:	90450513          	addi	a0,a0,-1788 # 5c20 <malloc+0x81e>
    3324:	429010ef          	jal	4f4c <unlink>
    3328:	cd2d                	beqz	a0,33a2 <rmdot+0xae>
  if(unlink("..") == 0){
    332a:	00003517          	auipc	a0,0x3
    332e:	41650513          	addi	a0,a0,1046 # 6740 <malloc+0x133e>
    3332:	41b010ef          	jal	4f4c <unlink>
    3336:	c141                	beqz	a0,33b6 <rmdot+0xc2>
  if(chdir("/") != 0){
    3338:	00003517          	auipc	a0,0x3
    333c:	3b050513          	addi	a0,a0,944 # 66e8 <malloc+0x12e6>
    3340:	42d010ef          	jal	4f6c <chdir>
    3344:	e159                	bnez	a0,33ca <rmdot+0xd6>
  if(unlink("dots/.") == 0){
    3346:	00004517          	auipc	a0,0x4
    334a:	a1250513          	addi	a0,a0,-1518 # 6d58 <malloc+0x1956>
    334e:	3ff010ef          	jal	4f4c <unlink>
    3352:	c551                	beqz	a0,33de <rmdot+0xea>
  if(unlink("dots/..") == 0){
    3354:	00004517          	auipc	a0,0x4
    3358:	a2c50513          	addi	a0,a0,-1492 # 6d80 <malloc+0x197e>
    335c:	3f1010ef          	jal	4f4c <unlink>
    3360:	c949                	beqz	a0,33f2 <rmdot+0xfe>
  if(unlink("dots") != 0){
    3362:	00004517          	auipc	a0,0x4
    3366:	98e50513          	addi	a0,a0,-1650 # 6cf0 <malloc+0x18ee>
    336a:	3e3010ef          	jal	4f4c <unlink>
    336e:	ed41                	bnez	a0,3406 <rmdot+0x112>
}
    3370:	60e2                	ld	ra,24(sp)
    3372:	6442                	ld	s0,16(sp)
    3374:	64a2                	ld	s1,8(sp)
    3376:	6105                	addi	sp,sp,32
    3378:	8082                	ret
    printf("%s: mkdir dots failed\n", s);
    337a:	85a6                	mv	a1,s1
    337c:	00004517          	auipc	a0,0x4
    3380:	97c50513          	addi	a0,a0,-1668 # 6cf8 <malloc+0x18f6>
    3384:	7c7010ef          	jal	534a <printf>
    exit(1);
    3388:	4505                	li	a0,1
    338a:	373010ef          	jal	4efc <exit>
    printf("%s: chdir dots failed\n", s);
    338e:	85a6                	mv	a1,s1
    3390:	00004517          	auipc	a0,0x4
    3394:	98050513          	addi	a0,a0,-1664 # 6d10 <malloc+0x190e>
    3398:	7b3010ef          	jal	534a <printf>
    exit(1);
    339c:	4505                	li	a0,1
    339e:	35f010ef          	jal	4efc <exit>
    printf("%s: rm . worked!\n", s);
    33a2:	85a6                	mv	a1,s1
    33a4:	00004517          	auipc	a0,0x4
    33a8:	98450513          	addi	a0,a0,-1660 # 6d28 <malloc+0x1926>
    33ac:	79f010ef          	jal	534a <printf>
    exit(1);
    33b0:	4505                	li	a0,1
    33b2:	34b010ef          	jal	4efc <exit>
    printf("%s: rm .. worked!\n", s);
    33b6:	85a6                	mv	a1,s1
    33b8:	00004517          	auipc	a0,0x4
    33bc:	98850513          	addi	a0,a0,-1656 # 6d40 <malloc+0x193e>
    33c0:	78b010ef          	jal	534a <printf>
    exit(1);
    33c4:	4505                	li	a0,1
    33c6:	337010ef          	jal	4efc <exit>
    printf("%s: chdir / failed\n", s);
    33ca:	85a6                	mv	a1,s1
    33cc:	00003517          	auipc	a0,0x3
    33d0:	32450513          	addi	a0,a0,804 # 66f0 <malloc+0x12ee>
    33d4:	777010ef          	jal	534a <printf>
    exit(1);
    33d8:	4505                	li	a0,1
    33da:	323010ef          	jal	4efc <exit>
    printf("%s: unlink dots/. worked!\n", s);
    33de:	85a6                	mv	a1,s1
    33e0:	00004517          	auipc	a0,0x4
    33e4:	98050513          	addi	a0,a0,-1664 # 6d60 <malloc+0x195e>
    33e8:	763010ef          	jal	534a <printf>
    exit(1);
    33ec:	4505                	li	a0,1
    33ee:	30f010ef          	jal	4efc <exit>
    printf("%s: unlink dots/.. worked!\n", s);
    33f2:	85a6                	mv	a1,s1
    33f4:	00004517          	auipc	a0,0x4
    33f8:	99450513          	addi	a0,a0,-1644 # 6d88 <malloc+0x1986>
    33fc:	74f010ef          	jal	534a <printf>
    exit(1);
    3400:	4505                	li	a0,1
    3402:	2fb010ef          	jal	4efc <exit>
    printf("%s: unlink dots failed!\n", s);
    3406:	85a6                	mv	a1,s1
    3408:	00004517          	auipc	a0,0x4
    340c:	9a050513          	addi	a0,a0,-1632 # 6da8 <malloc+0x19a6>
    3410:	73b010ef          	jal	534a <printf>
    exit(1);
    3414:	4505                	li	a0,1
    3416:	2e7010ef          	jal	4efc <exit>

000000000000341a <dirfile>:
{
    341a:	1101                	addi	sp,sp,-32
    341c:	ec06                	sd	ra,24(sp)
    341e:	e822                	sd	s0,16(sp)
    3420:	e426                	sd	s1,8(sp)
    3422:	e04a                	sd	s2,0(sp)
    3424:	1000                	addi	s0,sp,32
    3426:	892a                	mv	s2,a0
  fd = open("dirfile", O_CREATE);
    3428:	20000593          	li	a1,512
    342c:	00004517          	auipc	a0,0x4
    3430:	99c50513          	addi	a0,a0,-1636 # 6dc8 <malloc+0x19c6>
    3434:	309010ef          	jal	4f3c <open>
  if(fd < 0){
    3438:	0c054563          	bltz	a0,3502 <dirfile+0xe8>
  close(fd);
    343c:	2e9010ef          	jal	4f24 <close>
  if(chdir("dirfile") == 0){
    3440:	00004517          	auipc	a0,0x4
    3444:	98850513          	addi	a0,a0,-1656 # 6dc8 <malloc+0x19c6>
    3448:	325010ef          	jal	4f6c <chdir>
    344c:	c569                	beqz	a0,3516 <dirfile+0xfc>
  fd = open("dirfile/xx", 0);
    344e:	4581                	li	a1,0
    3450:	00004517          	auipc	a0,0x4
    3454:	9c050513          	addi	a0,a0,-1600 # 6e10 <malloc+0x1a0e>
    3458:	2e5010ef          	jal	4f3c <open>
  if(fd >= 0){
    345c:	0c055763          	bgez	a0,352a <dirfile+0x110>
  fd = open("dirfile/xx", O_CREATE);
    3460:	20000593          	li	a1,512
    3464:	00004517          	auipc	a0,0x4
    3468:	9ac50513          	addi	a0,a0,-1620 # 6e10 <malloc+0x1a0e>
    346c:	2d1010ef          	jal	4f3c <open>
  if(fd >= 0){
    3470:	0c055763          	bgez	a0,353e <dirfile+0x124>
  if(mkdir("dirfile/xx") == 0){
    3474:	00004517          	auipc	a0,0x4
    3478:	99c50513          	addi	a0,a0,-1636 # 6e10 <malloc+0x1a0e>
    347c:	2e9010ef          	jal	4f64 <mkdir>
    3480:	0c050963          	beqz	a0,3552 <dirfile+0x138>
  if(unlink("dirfile/xx") == 0){
    3484:	00004517          	auipc	a0,0x4
    3488:	98c50513          	addi	a0,a0,-1652 # 6e10 <malloc+0x1a0e>
    348c:	2c1010ef          	jal	4f4c <unlink>
    3490:	0c050b63          	beqz	a0,3566 <dirfile+0x14c>
  if(link("README", "dirfile/xx") == 0){
    3494:	00004597          	auipc	a1,0x4
    3498:	97c58593          	addi	a1,a1,-1668 # 6e10 <malloc+0x1a0e>
    349c:	00002517          	auipc	a0,0x2
    34a0:	27450513          	addi	a0,a0,628 # 5710 <malloc+0x30e>
    34a4:	2b9010ef          	jal	4f5c <link>
    34a8:	0c050963          	beqz	a0,357a <dirfile+0x160>
  if(unlink("dirfile") != 0){
    34ac:	00004517          	auipc	a0,0x4
    34b0:	91c50513          	addi	a0,a0,-1764 # 6dc8 <malloc+0x19c6>
    34b4:	299010ef          	jal	4f4c <unlink>
    34b8:	0c051b63          	bnez	a0,358e <dirfile+0x174>
  fd = open(".", O_RDWR);
    34bc:	4589                	li	a1,2
    34be:	00002517          	auipc	a0,0x2
    34c2:	76250513          	addi	a0,a0,1890 # 5c20 <malloc+0x81e>
    34c6:	277010ef          	jal	4f3c <open>
  if(fd >= 0){
    34ca:	0c055c63          	bgez	a0,35a2 <dirfile+0x188>
  fd = open(".", 0);
    34ce:	4581                	li	a1,0
    34d0:	00002517          	auipc	a0,0x2
    34d4:	75050513          	addi	a0,a0,1872 # 5c20 <malloc+0x81e>
    34d8:	265010ef          	jal	4f3c <open>
    34dc:	84aa                	mv	s1,a0
  if(write(fd, "x", 1) > 0){
    34de:	4605                	li	a2,1
    34e0:	00002597          	auipc	a1,0x2
    34e4:	0c858593          	addi	a1,a1,200 # 55a8 <malloc+0x1a6>
    34e8:	235010ef          	jal	4f1c <write>
    34ec:	0ca04563          	bgtz	a0,35b6 <dirfile+0x19c>
  close(fd);
    34f0:	8526                	mv	a0,s1
    34f2:	233010ef          	jal	4f24 <close>
}
    34f6:	60e2                	ld	ra,24(sp)
    34f8:	6442                	ld	s0,16(sp)
    34fa:	64a2                	ld	s1,8(sp)
    34fc:	6902                	ld	s2,0(sp)
    34fe:	6105                	addi	sp,sp,32
    3500:	8082                	ret
    printf("%s: create dirfile failed\n", s);
    3502:	85ca                	mv	a1,s2
    3504:	00004517          	auipc	a0,0x4
    3508:	8cc50513          	addi	a0,a0,-1844 # 6dd0 <malloc+0x19ce>
    350c:	63f010ef          	jal	534a <printf>
    exit(1);
    3510:	4505                	li	a0,1
    3512:	1eb010ef          	jal	4efc <exit>
    printf("%s: chdir dirfile succeeded!\n", s);
    3516:	85ca                	mv	a1,s2
    3518:	00004517          	auipc	a0,0x4
    351c:	8d850513          	addi	a0,a0,-1832 # 6df0 <malloc+0x19ee>
    3520:	62b010ef          	jal	534a <printf>
    exit(1);
    3524:	4505                	li	a0,1
    3526:	1d7010ef          	jal	4efc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    352a:	85ca                	mv	a1,s2
    352c:	00004517          	auipc	a0,0x4
    3530:	8f450513          	addi	a0,a0,-1804 # 6e20 <malloc+0x1a1e>
    3534:	617010ef          	jal	534a <printf>
    exit(1);
    3538:	4505                	li	a0,1
    353a:	1c3010ef          	jal	4efc <exit>
    printf("%s: create dirfile/xx succeeded!\n", s);
    353e:	85ca                	mv	a1,s2
    3540:	00004517          	auipc	a0,0x4
    3544:	8e050513          	addi	a0,a0,-1824 # 6e20 <malloc+0x1a1e>
    3548:	603010ef          	jal	534a <printf>
    exit(1);
    354c:	4505                	li	a0,1
    354e:	1af010ef          	jal	4efc <exit>
    printf("%s: mkdir dirfile/xx succeeded!\n", s);
    3552:	85ca                	mv	a1,s2
    3554:	00004517          	auipc	a0,0x4
    3558:	8f450513          	addi	a0,a0,-1804 # 6e48 <malloc+0x1a46>
    355c:	5ef010ef          	jal	534a <printf>
    exit(1);
    3560:	4505                	li	a0,1
    3562:	19b010ef          	jal	4efc <exit>
    printf("%s: unlink dirfile/xx succeeded!\n", s);
    3566:	85ca                	mv	a1,s2
    3568:	00004517          	auipc	a0,0x4
    356c:	90850513          	addi	a0,a0,-1784 # 6e70 <malloc+0x1a6e>
    3570:	5db010ef          	jal	534a <printf>
    exit(1);
    3574:	4505                	li	a0,1
    3576:	187010ef          	jal	4efc <exit>
    printf("%s: link to dirfile/xx succeeded!\n", s);
    357a:	85ca                	mv	a1,s2
    357c:	00004517          	auipc	a0,0x4
    3580:	91c50513          	addi	a0,a0,-1764 # 6e98 <malloc+0x1a96>
    3584:	5c7010ef          	jal	534a <printf>
    exit(1);
    3588:	4505                	li	a0,1
    358a:	173010ef          	jal	4efc <exit>
    printf("%s: unlink dirfile failed!\n", s);
    358e:	85ca                	mv	a1,s2
    3590:	00004517          	auipc	a0,0x4
    3594:	93050513          	addi	a0,a0,-1744 # 6ec0 <malloc+0x1abe>
    3598:	5b3010ef          	jal	534a <printf>
    exit(1);
    359c:	4505                	li	a0,1
    359e:	15f010ef          	jal	4efc <exit>
    printf("%s: open . for writing succeeded!\n", s);
    35a2:	85ca                	mv	a1,s2
    35a4:	00004517          	auipc	a0,0x4
    35a8:	93c50513          	addi	a0,a0,-1732 # 6ee0 <malloc+0x1ade>
    35ac:	59f010ef          	jal	534a <printf>
    exit(1);
    35b0:	4505                	li	a0,1
    35b2:	14b010ef          	jal	4efc <exit>
    printf("%s: write . succeeded!\n", s);
    35b6:	85ca                	mv	a1,s2
    35b8:	00004517          	auipc	a0,0x4
    35bc:	95050513          	addi	a0,a0,-1712 # 6f08 <malloc+0x1b06>
    35c0:	58b010ef          	jal	534a <printf>
    exit(1);
    35c4:	4505                	li	a0,1
    35c6:	137010ef          	jal	4efc <exit>

00000000000035ca <iref>:
{
    35ca:	715d                	addi	sp,sp,-80
    35cc:	e486                	sd	ra,72(sp)
    35ce:	e0a2                	sd	s0,64(sp)
    35d0:	fc26                	sd	s1,56(sp)
    35d2:	f84a                	sd	s2,48(sp)
    35d4:	f44e                	sd	s3,40(sp)
    35d6:	f052                	sd	s4,32(sp)
    35d8:	ec56                	sd	s5,24(sp)
    35da:	e85a                	sd	s6,16(sp)
    35dc:	e45e                	sd	s7,8(sp)
    35de:	0880                	addi	s0,sp,80
    35e0:	8baa                	mv	s7,a0
    35e2:	03300913          	li	s2,51
    if(mkdir("irefd") != 0){
    35e6:	00004a97          	auipc	s5,0x4
    35ea:	93aa8a93          	addi	s5,s5,-1734 # 6f20 <malloc+0x1b1e>
    mkdir("");
    35ee:	00003497          	auipc	s1,0x3
    35f2:	43a48493          	addi	s1,s1,1082 # 6a28 <malloc+0x1626>
    link("README", "");
    35f6:	00002b17          	auipc	s6,0x2
    35fa:	11ab0b13          	addi	s6,s6,282 # 5710 <malloc+0x30e>
    fd = open("", O_CREATE);
    35fe:	20000a13          	li	s4,512
    fd = open("xx", O_CREATE);
    3602:	00004997          	auipc	s3,0x4
    3606:	81698993          	addi	s3,s3,-2026 # 6e18 <malloc+0x1a16>
    360a:	a835                	j	3646 <iref+0x7c>
      printf("%s: mkdir irefd failed\n", s);
    360c:	85de                	mv	a1,s7
    360e:	00004517          	auipc	a0,0x4
    3612:	91a50513          	addi	a0,a0,-1766 # 6f28 <malloc+0x1b26>
    3616:	535010ef          	jal	534a <printf>
      exit(1);
    361a:	4505                	li	a0,1
    361c:	0e1010ef          	jal	4efc <exit>
      printf("%s: chdir irefd failed\n", s);
    3620:	85de                	mv	a1,s7
    3622:	00004517          	auipc	a0,0x4
    3626:	91e50513          	addi	a0,a0,-1762 # 6f40 <malloc+0x1b3e>
    362a:	521010ef          	jal	534a <printf>
      exit(1);
    362e:	4505                	li	a0,1
    3630:	0cd010ef          	jal	4efc <exit>
      close(fd);
    3634:	0f1010ef          	jal	4f24 <close>
    3638:	a825                	j	3670 <iref+0xa6>
    unlink("xx");
    363a:	854e                	mv	a0,s3
    363c:	111010ef          	jal	4f4c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    3640:	397d                	addiw	s2,s2,-1
    3642:	04090063          	beqz	s2,3682 <iref+0xb8>
    if(mkdir("irefd") != 0){
    3646:	8556                	mv	a0,s5
    3648:	11d010ef          	jal	4f64 <mkdir>
    364c:	f161                	bnez	a0,360c <iref+0x42>
    if(chdir("irefd") != 0){
    364e:	8556                	mv	a0,s5
    3650:	11d010ef          	jal	4f6c <chdir>
    3654:	f571                	bnez	a0,3620 <iref+0x56>
    mkdir("");
    3656:	8526                	mv	a0,s1
    3658:	10d010ef          	jal	4f64 <mkdir>
    link("README", "");
    365c:	85a6                	mv	a1,s1
    365e:	855a                	mv	a0,s6
    3660:	0fd010ef          	jal	4f5c <link>
    fd = open("", O_CREATE);
    3664:	85d2                	mv	a1,s4
    3666:	8526                	mv	a0,s1
    3668:	0d5010ef          	jal	4f3c <open>
    if(fd >= 0)
    366c:	fc0554e3          	bgez	a0,3634 <iref+0x6a>
    fd = open("xx", O_CREATE);
    3670:	85d2                	mv	a1,s4
    3672:	854e                	mv	a0,s3
    3674:	0c9010ef          	jal	4f3c <open>
    if(fd >= 0)
    3678:	fc0541e3          	bltz	a0,363a <iref+0x70>
      close(fd);
    367c:	0a9010ef          	jal	4f24 <close>
    3680:	bf6d                	j	363a <iref+0x70>
    3682:	03300493          	li	s1,51
    chdir("..");
    3686:	00003997          	auipc	s3,0x3
    368a:	0ba98993          	addi	s3,s3,186 # 6740 <malloc+0x133e>
    unlink("irefd");
    368e:	00004917          	auipc	s2,0x4
    3692:	89290913          	addi	s2,s2,-1902 # 6f20 <malloc+0x1b1e>
    chdir("..");
    3696:	854e                	mv	a0,s3
    3698:	0d5010ef          	jal	4f6c <chdir>
    unlink("irefd");
    369c:	854a                	mv	a0,s2
    369e:	0af010ef          	jal	4f4c <unlink>
  for(i = 0; i < NINODE + 1; i++){
    36a2:	34fd                	addiw	s1,s1,-1
    36a4:	f8ed                	bnez	s1,3696 <iref+0xcc>
  chdir("/");
    36a6:	00003517          	auipc	a0,0x3
    36aa:	04250513          	addi	a0,a0,66 # 66e8 <malloc+0x12e6>
    36ae:	0bf010ef          	jal	4f6c <chdir>
}
    36b2:	60a6                	ld	ra,72(sp)
    36b4:	6406                	ld	s0,64(sp)
    36b6:	74e2                	ld	s1,56(sp)
    36b8:	7942                	ld	s2,48(sp)
    36ba:	79a2                	ld	s3,40(sp)
    36bc:	7a02                	ld	s4,32(sp)
    36be:	6ae2                	ld	s5,24(sp)
    36c0:	6b42                	ld	s6,16(sp)
    36c2:	6ba2                	ld	s7,8(sp)
    36c4:	6161                	addi	sp,sp,80
    36c6:	8082                	ret

00000000000036c8 <openiputtest>:
{
    36c8:	7179                	addi	sp,sp,-48
    36ca:	f406                	sd	ra,40(sp)
    36cc:	f022                	sd	s0,32(sp)
    36ce:	ec26                	sd	s1,24(sp)
    36d0:	1800                	addi	s0,sp,48
    36d2:	84aa                	mv	s1,a0
  if(mkdir("oidir") < 0){
    36d4:	00004517          	auipc	a0,0x4
    36d8:	88450513          	addi	a0,a0,-1916 # 6f58 <malloc+0x1b56>
    36dc:	089010ef          	jal	4f64 <mkdir>
    36e0:	02054a63          	bltz	a0,3714 <openiputtest+0x4c>
  pid = fork();
    36e4:	011010ef          	jal	4ef4 <fork>
  if(pid < 0){
    36e8:	04054063          	bltz	a0,3728 <openiputtest+0x60>
  if(pid == 0){
    36ec:	e939                	bnez	a0,3742 <openiputtest+0x7a>
    int fd = open("oidir", O_RDWR);
    36ee:	4589                	li	a1,2
    36f0:	00004517          	auipc	a0,0x4
    36f4:	86850513          	addi	a0,a0,-1944 # 6f58 <malloc+0x1b56>
    36f8:	045010ef          	jal	4f3c <open>
    if(fd >= 0){
    36fc:	04054063          	bltz	a0,373c <openiputtest+0x74>
      printf("%s: open directory for write succeeded\n", s);
    3700:	85a6                	mv	a1,s1
    3702:	00004517          	auipc	a0,0x4
    3706:	87650513          	addi	a0,a0,-1930 # 6f78 <malloc+0x1b76>
    370a:	441010ef          	jal	534a <printf>
      exit(1);
    370e:	4505                	li	a0,1
    3710:	7ec010ef          	jal	4efc <exit>
    printf("%s: mkdir oidir failed\n", s);
    3714:	85a6                	mv	a1,s1
    3716:	00004517          	auipc	a0,0x4
    371a:	84a50513          	addi	a0,a0,-1974 # 6f60 <malloc+0x1b5e>
    371e:	42d010ef          	jal	534a <printf>
    exit(1);
    3722:	4505                	li	a0,1
    3724:	7d8010ef          	jal	4efc <exit>
    printf("%s: fork failed\n", s);
    3728:	85a6                	mv	a1,s1
    372a:	00002517          	auipc	a0,0x2
    372e:	69e50513          	addi	a0,a0,1694 # 5dc8 <malloc+0x9c6>
    3732:	419010ef          	jal	534a <printf>
    exit(1);
    3736:	4505                	li	a0,1
    3738:	7c4010ef          	jal	4efc <exit>
    exit(0);
    373c:	4501                	li	a0,0
    373e:	7be010ef          	jal	4efc <exit>
  pause(1);
    3742:	4505                	li	a0,1
    3744:	049010ef          	jal	4f8c <pause>
  if(unlink("oidir") != 0){
    3748:	00004517          	auipc	a0,0x4
    374c:	81050513          	addi	a0,a0,-2032 # 6f58 <malloc+0x1b56>
    3750:	7fc010ef          	jal	4f4c <unlink>
    3754:	c919                	beqz	a0,376a <openiputtest+0xa2>
    printf("%s: unlink failed\n", s);
    3756:	85a6                	mv	a1,s1
    3758:	00003517          	auipc	a0,0x3
    375c:	86050513          	addi	a0,a0,-1952 # 5fb8 <malloc+0xbb6>
    3760:	3eb010ef          	jal	534a <printf>
    exit(1);
    3764:	4505                	li	a0,1
    3766:	796010ef          	jal	4efc <exit>
  wait(&xstatus);
    376a:	fdc40513          	addi	a0,s0,-36
    376e:	796010ef          	jal	4f04 <wait>
  exit(xstatus);
    3772:	fdc42503          	lw	a0,-36(s0)
    3776:	786010ef          	jal	4efc <exit>

000000000000377a <forkforkfork>:
{
    377a:	1101                	addi	sp,sp,-32
    377c:	ec06                	sd	ra,24(sp)
    377e:	e822                	sd	s0,16(sp)
    3780:	e426                	sd	s1,8(sp)
    3782:	1000                	addi	s0,sp,32
    3784:	84aa                	mv	s1,a0
  unlink("stopforking");
    3786:	00004517          	auipc	a0,0x4
    378a:	81a50513          	addi	a0,a0,-2022 # 6fa0 <malloc+0x1b9e>
    378e:	7be010ef          	jal	4f4c <unlink>
  int pid = fork();
    3792:	762010ef          	jal	4ef4 <fork>
  if(pid < 0){
    3796:	02054b63          	bltz	a0,37cc <forkforkfork+0x52>
  if(pid == 0){
    379a:	c139                	beqz	a0,37e0 <forkforkfork+0x66>
  pause(20); // two seconds
    379c:	4551                	li	a0,20
    379e:	7ee010ef          	jal	4f8c <pause>
  close(open("stopforking", O_CREATE|O_RDWR));
    37a2:	20200593          	li	a1,514
    37a6:	00003517          	auipc	a0,0x3
    37aa:	7fa50513          	addi	a0,a0,2042 # 6fa0 <malloc+0x1b9e>
    37ae:	78e010ef          	jal	4f3c <open>
    37b2:	772010ef          	jal	4f24 <close>
  wait(0);
    37b6:	4501                	li	a0,0
    37b8:	74c010ef          	jal	4f04 <wait>
  pause(10); // one second
    37bc:	4529                	li	a0,10
    37be:	7ce010ef          	jal	4f8c <pause>
}
    37c2:	60e2                	ld	ra,24(sp)
    37c4:	6442                	ld	s0,16(sp)
    37c6:	64a2                	ld	s1,8(sp)
    37c8:	6105                	addi	sp,sp,32
    37ca:	8082                	ret
    printf("%s: fork failed", s);
    37cc:	85a6                	mv	a1,s1
    37ce:	00002517          	auipc	a0,0x2
    37d2:	7ba50513          	addi	a0,a0,1978 # 5f88 <malloc+0xb86>
    37d6:	375010ef          	jal	534a <printf>
    exit(1);
    37da:	4505                	li	a0,1
    37dc:	720010ef          	jal	4efc <exit>
      int fd = open("stopforking", 0);
    37e0:	4581                	li	a1,0
    37e2:	00003517          	auipc	a0,0x3
    37e6:	7be50513          	addi	a0,a0,1982 # 6fa0 <malloc+0x1b9e>
    37ea:	752010ef          	jal	4f3c <open>
      if(fd >= 0){
    37ee:	02055163          	bgez	a0,3810 <forkforkfork+0x96>
      if(fork() < 0){
    37f2:	702010ef          	jal	4ef4 <fork>
    37f6:	fe0555e3          	bgez	a0,37e0 <forkforkfork+0x66>
        close(open("stopforking", O_CREATE|O_RDWR));
    37fa:	20200593          	li	a1,514
    37fe:	00003517          	auipc	a0,0x3
    3802:	7a250513          	addi	a0,a0,1954 # 6fa0 <malloc+0x1b9e>
    3806:	736010ef          	jal	4f3c <open>
    380a:	71a010ef          	jal	4f24 <close>
    380e:	bfc9                	j	37e0 <forkforkfork+0x66>
        exit(0);
    3810:	4501                	li	a0,0
    3812:	6ea010ef          	jal	4efc <exit>

0000000000003816 <killstatus>:
{
    3816:	715d                	addi	sp,sp,-80
    3818:	e486                	sd	ra,72(sp)
    381a:	e0a2                	sd	s0,64(sp)
    381c:	fc26                	sd	s1,56(sp)
    381e:	f84a                	sd	s2,48(sp)
    3820:	f44e                	sd	s3,40(sp)
    3822:	f052                	sd	s4,32(sp)
    3824:	ec56                	sd	s5,24(sp)
    3826:	e85a                	sd	s6,16(sp)
    3828:	0880                	addi	s0,sp,80
    382a:	8b2a                	mv	s6,a0
    382c:	06400913          	li	s2,100
    pause(1);
    3830:	4a85                	li	s5,1
    wait(&xst);
    3832:	fbc40a13          	addi	s4,s0,-68
    if(xst != -1) {
    3836:	59fd                	li	s3,-1
    int pid1 = fork();
    3838:	6bc010ef          	jal	4ef4 <fork>
    383c:	84aa                	mv	s1,a0
    if(pid1 < 0){
    383e:	02054663          	bltz	a0,386a <killstatus+0x54>
    if(pid1 == 0){
    3842:	cd15                	beqz	a0,387e <killstatus+0x68>
    pause(1);
    3844:	8556                	mv	a0,s5
    3846:	746010ef          	jal	4f8c <pause>
    kill(pid1);
    384a:	8526                	mv	a0,s1
    384c:	6e0010ef          	jal	4f2c <kill>
    wait(&xst);
    3850:	8552                	mv	a0,s4
    3852:	6b2010ef          	jal	4f04 <wait>
    if(xst != -1) {
    3856:	fbc42783          	lw	a5,-68(s0)
    385a:	03379563          	bne	a5,s3,3884 <killstatus+0x6e>
  for(int i = 0; i < 100; i++){
    385e:	397d                	addiw	s2,s2,-1
    3860:	fc091ce3          	bnez	s2,3838 <killstatus+0x22>
  exit(0);
    3864:	4501                	li	a0,0
    3866:	696010ef          	jal	4efc <exit>
      printf("%s: fork failed\n", s);
    386a:	85da                	mv	a1,s6
    386c:	00002517          	auipc	a0,0x2
    3870:	55c50513          	addi	a0,a0,1372 # 5dc8 <malloc+0x9c6>
    3874:	2d7010ef          	jal	534a <printf>
      exit(1);
    3878:	4505                	li	a0,1
    387a:	682010ef          	jal	4efc <exit>
        getpid();
    387e:	6fe010ef          	jal	4f7c <getpid>
      while(1) {
    3882:	bff5                	j	387e <killstatus+0x68>
       printf("%s: status should be -1\n", s);
    3884:	85da                	mv	a1,s6
    3886:	00003517          	auipc	a0,0x3
    388a:	72a50513          	addi	a0,a0,1834 # 6fb0 <malloc+0x1bae>
    388e:	2bd010ef          	jal	534a <printf>
       exit(1);
    3892:	4505                	li	a0,1
    3894:	668010ef          	jal	4efc <exit>

0000000000003898 <preempt>:
{
    3898:	7139                	addi	sp,sp,-64
    389a:	fc06                	sd	ra,56(sp)
    389c:	f822                	sd	s0,48(sp)
    389e:	f426                	sd	s1,40(sp)
    38a0:	f04a                	sd	s2,32(sp)
    38a2:	ec4e                	sd	s3,24(sp)
    38a4:	e852                	sd	s4,16(sp)
    38a6:	0080                	addi	s0,sp,64
    38a8:	892a                	mv	s2,a0
  pid1 = fork();
    38aa:	64a010ef          	jal	4ef4 <fork>
  if(pid1 < 0) {
    38ae:	00054563          	bltz	a0,38b8 <preempt+0x20>
    38b2:	84aa                	mv	s1,a0
  if(pid1 == 0)
    38b4:	ed01                	bnez	a0,38cc <preempt+0x34>
    for(;;)
    38b6:	a001                	j	38b6 <preempt+0x1e>
    printf("%s: fork failed", s);
    38b8:	85ca                	mv	a1,s2
    38ba:	00002517          	auipc	a0,0x2
    38be:	6ce50513          	addi	a0,a0,1742 # 5f88 <malloc+0xb86>
    38c2:	289010ef          	jal	534a <printf>
    exit(1);
    38c6:	4505                	li	a0,1
    38c8:	634010ef          	jal	4efc <exit>
  pid2 = fork();
    38cc:	628010ef          	jal	4ef4 <fork>
    38d0:	89aa                	mv	s3,a0
  if(pid2 < 0) {
    38d2:	00054463          	bltz	a0,38da <preempt+0x42>
  if(pid2 == 0)
    38d6:	ed01                	bnez	a0,38ee <preempt+0x56>
    for(;;)
    38d8:	a001                	j	38d8 <preempt+0x40>
    printf("%s: fork failed\n", s);
    38da:	85ca                	mv	a1,s2
    38dc:	00002517          	auipc	a0,0x2
    38e0:	4ec50513          	addi	a0,a0,1260 # 5dc8 <malloc+0x9c6>
    38e4:	267010ef          	jal	534a <printf>
    exit(1);
    38e8:	4505                	li	a0,1
    38ea:	612010ef          	jal	4efc <exit>
  pipe(pfds);
    38ee:	fc840513          	addi	a0,s0,-56
    38f2:	61a010ef          	jal	4f0c <pipe>
  pid3 = fork();
    38f6:	5fe010ef          	jal	4ef4 <fork>
    38fa:	8a2a                	mv	s4,a0
  if(pid3 < 0) {
    38fc:	02054863          	bltz	a0,392c <preempt+0x94>
  if(pid3 == 0){
    3900:	e921                	bnez	a0,3950 <preempt+0xb8>
    close(pfds[0]);
    3902:	fc842503          	lw	a0,-56(s0)
    3906:	61e010ef          	jal	4f24 <close>
    if(write(pfds[1], "x", 1) != 1)
    390a:	4605                	li	a2,1
    390c:	00002597          	auipc	a1,0x2
    3910:	c9c58593          	addi	a1,a1,-868 # 55a8 <malloc+0x1a6>
    3914:	fcc42503          	lw	a0,-52(s0)
    3918:	604010ef          	jal	4f1c <write>
    391c:	4785                	li	a5,1
    391e:	02f51163          	bne	a0,a5,3940 <preempt+0xa8>
    close(pfds[1]);
    3922:	fcc42503          	lw	a0,-52(s0)
    3926:	5fe010ef          	jal	4f24 <close>
    for(;;)
    392a:	a001                	j	392a <preempt+0x92>
     printf("%s: fork failed\n", s);
    392c:	85ca                	mv	a1,s2
    392e:	00002517          	auipc	a0,0x2
    3932:	49a50513          	addi	a0,a0,1178 # 5dc8 <malloc+0x9c6>
    3936:	215010ef          	jal	534a <printf>
     exit(1);
    393a:	4505                	li	a0,1
    393c:	5c0010ef          	jal	4efc <exit>
      printf("%s: preempt write error", s);
    3940:	85ca                	mv	a1,s2
    3942:	00003517          	auipc	a0,0x3
    3946:	68e50513          	addi	a0,a0,1678 # 6fd0 <malloc+0x1bce>
    394a:	201010ef          	jal	534a <printf>
    394e:	bfd1                	j	3922 <preempt+0x8a>
  close(pfds[1]);
    3950:	fcc42503          	lw	a0,-52(s0)
    3954:	5d0010ef          	jal	4f24 <close>
  if(read(pfds[0], buf, sizeof(buf)) != 1){
    3958:	660d                	lui	a2,0x3
    395a:	00008597          	auipc	a1,0x8
    395e:	34e58593          	addi	a1,a1,846 # bca8 <buf>
    3962:	fc842503          	lw	a0,-56(s0)
    3966:	5ae010ef          	jal	4f14 <read>
    396a:	4785                	li	a5,1
    396c:	02f50163          	beq	a0,a5,398e <preempt+0xf6>
    printf("%s: preempt read error", s);
    3970:	85ca                	mv	a1,s2
    3972:	00003517          	auipc	a0,0x3
    3976:	67650513          	addi	a0,a0,1654 # 6fe8 <malloc+0x1be6>
    397a:	1d1010ef          	jal	534a <printf>
}
    397e:	70e2                	ld	ra,56(sp)
    3980:	7442                	ld	s0,48(sp)
    3982:	74a2                	ld	s1,40(sp)
    3984:	7902                	ld	s2,32(sp)
    3986:	69e2                	ld	s3,24(sp)
    3988:	6a42                	ld	s4,16(sp)
    398a:	6121                	addi	sp,sp,64
    398c:	8082                	ret
  close(pfds[0]);
    398e:	fc842503          	lw	a0,-56(s0)
    3992:	592010ef          	jal	4f24 <close>
  printf("kill... ");
    3996:	00003517          	auipc	a0,0x3
    399a:	66a50513          	addi	a0,a0,1642 # 7000 <malloc+0x1bfe>
    399e:	1ad010ef          	jal	534a <printf>
  kill(pid1);
    39a2:	8526                	mv	a0,s1
    39a4:	588010ef          	jal	4f2c <kill>
  kill(pid2);
    39a8:	854e                	mv	a0,s3
    39aa:	582010ef          	jal	4f2c <kill>
  kill(pid3);
    39ae:	8552                	mv	a0,s4
    39b0:	57c010ef          	jal	4f2c <kill>
  printf("wait... ");
    39b4:	00003517          	auipc	a0,0x3
    39b8:	65c50513          	addi	a0,a0,1628 # 7010 <malloc+0x1c0e>
    39bc:	18f010ef          	jal	534a <printf>
  wait(0);
    39c0:	4501                	li	a0,0
    39c2:	542010ef          	jal	4f04 <wait>
  wait(0);
    39c6:	4501                	li	a0,0
    39c8:	53c010ef          	jal	4f04 <wait>
  wait(0);
    39cc:	4501                	li	a0,0
    39ce:	536010ef          	jal	4f04 <wait>
    39d2:	b775                	j	397e <preempt+0xe6>

00000000000039d4 <reparent>:
{
    39d4:	7179                	addi	sp,sp,-48
    39d6:	f406                	sd	ra,40(sp)
    39d8:	f022                	sd	s0,32(sp)
    39da:	ec26                	sd	s1,24(sp)
    39dc:	e84a                	sd	s2,16(sp)
    39de:	e44e                	sd	s3,8(sp)
    39e0:	e052                	sd	s4,0(sp)
    39e2:	1800                	addi	s0,sp,48
    39e4:	89aa                	mv	s3,a0
  int master_pid = getpid();
    39e6:	596010ef          	jal	4f7c <getpid>
    39ea:	8a2a                	mv	s4,a0
    39ec:	0c800913          	li	s2,200
    int pid = fork();
    39f0:	504010ef          	jal	4ef4 <fork>
    39f4:	84aa                	mv	s1,a0
    if(pid < 0){
    39f6:	00054e63          	bltz	a0,3a12 <reparent+0x3e>
    if(pid){
    39fa:	c121                	beqz	a0,3a3a <reparent+0x66>
      if(wait(0) != pid){
    39fc:	4501                	li	a0,0
    39fe:	506010ef          	jal	4f04 <wait>
    3a02:	02951263          	bne	a0,s1,3a26 <reparent+0x52>
  for(int i = 0; i < 200; i++){
    3a06:	397d                	addiw	s2,s2,-1
    3a08:	fe0914e3          	bnez	s2,39f0 <reparent+0x1c>
  exit(0);
    3a0c:	4501                	li	a0,0
    3a0e:	4ee010ef          	jal	4efc <exit>
      printf("%s: fork failed\n", s);
    3a12:	85ce                	mv	a1,s3
    3a14:	00002517          	auipc	a0,0x2
    3a18:	3b450513          	addi	a0,a0,948 # 5dc8 <malloc+0x9c6>
    3a1c:	12f010ef          	jal	534a <printf>
      exit(1);
    3a20:	4505                	li	a0,1
    3a22:	4da010ef          	jal	4efc <exit>
        printf("%s: wait wrong pid\n", s);
    3a26:	85ce                	mv	a1,s3
    3a28:	00002517          	auipc	a0,0x2
    3a2c:	52850513          	addi	a0,a0,1320 # 5f50 <malloc+0xb4e>
    3a30:	11b010ef          	jal	534a <printf>
        exit(1);
    3a34:	4505                	li	a0,1
    3a36:	4c6010ef          	jal	4efc <exit>
      int pid2 = fork();
    3a3a:	4ba010ef          	jal	4ef4 <fork>
      if(pid2 < 0){
    3a3e:	00054563          	bltz	a0,3a48 <reparent+0x74>
      exit(0);
    3a42:	4501                	li	a0,0
    3a44:	4b8010ef          	jal	4efc <exit>
        kill(master_pid);
    3a48:	8552                	mv	a0,s4
    3a4a:	4e2010ef          	jal	4f2c <kill>
        exit(1);
    3a4e:	4505                	li	a0,1
    3a50:	4ac010ef          	jal	4efc <exit>

0000000000003a54 <sbrkfail>:
{
    3a54:	7175                	addi	sp,sp,-144
    3a56:	e506                	sd	ra,136(sp)
    3a58:	e122                	sd	s0,128(sp)
    3a5a:	fca6                	sd	s1,120(sp)
    3a5c:	f8ca                	sd	s2,112(sp)
    3a5e:	f4ce                	sd	s3,104(sp)
    3a60:	f0d2                	sd	s4,96(sp)
    3a62:	ecd6                	sd	s5,88(sp)
    3a64:	e8da                	sd	s6,80(sp)
    3a66:	e4de                	sd	s7,72(sp)
    3a68:	e0e2                	sd	s8,64(sp)
    3a6a:	0900                	addi	s0,sp,144
    3a6c:	8c2a                	mv	s8,a0
  if(pipe(fds) != 0){
    3a6e:	fa040513          	addi	a0,s0,-96
    3a72:	49a010ef          	jal	4f0c <pipe>
    3a76:	ed01                	bnez	a0,3a8e <sbrkfail+0x3a>
    3a78:	8baa                	mv	s7,a0
    3a7a:	f7040493          	addi	s1,s0,-144
    3a7e:	f9840993          	addi	s3,s0,-104
    3a82:	8926                	mv	s2,s1
    if(pids[i] != -1) {
    3a84:	5a7d                	li	s4,-1
      read(fds[0], &scratch, 1);
    3a86:	f9f40b13          	addi	s6,s0,-97
    3a8a:	4a85                	li	s5,1
    3a8c:	a095                	j	3af0 <sbrkfail+0x9c>
    printf("%s: pipe() failed\n", s);
    3a8e:	85e2                	mv	a1,s8
    3a90:	00002517          	auipc	a0,0x2
    3a94:	44050513          	addi	a0,a0,1088 # 5ed0 <malloc+0xace>
    3a98:	0b3010ef          	jal	534a <printf>
    exit(1);
    3a9c:	4505                	li	a0,1
    3a9e:	45e010ef          	jal	4efc <exit>
      if (sbrk(BIG - (uint64)sbrk(0)) ==  (char*)SBRK_ERROR)
    3aa2:	426010ef          	jal	4ec8 <sbrk>
    3aa6:	064007b7          	lui	a5,0x6400
    3aaa:	40a7853b          	subw	a0,a5,a0
    3aae:	41a010ef          	jal	4ec8 <sbrk>
    3ab2:	57fd                	li	a5,-1
    3ab4:	02f50163          	beq	a0,a5,3ad6 <sbrkfail+0x82>
        write(fds[1], "1", 1);
    3ab8:	4605                	li	a2,1
    3aba:	00004597          	auipc	a1,0x4
    3abe:	bf658593          	addi	a1,a1,-1034 # 76b0 <malloc+0x22ae>
    3ac2:	fa442503          	lw	a0,-92(s0)
    3ac6:	456010ef          	jal	4f1c <write>
      for(;;) pause(1000);
    3aca:	3e800493          	li	s1,1000
    3ace:	8526                	mv	a0,s1
    3ad0:	4bc010ef          	jal	4f8c <pause>
    3ad4:	bfed                	j	3ace <sbrkfail+0x7a>
        write(fds[1], "0", 1);
    3ad6:	4605                	li	a2,1
    3ad8:	00003597          	auipc	a1,0x3
    3adc:	54858593          	addi	a1,a1,1352 # 7020 <malloc+0x1c1e>
    3ae0:	fa442503          	lw	a0,-92(s0)
    3ae4:	438010ef          	jal	4f1c <write>
    3ae8:	b7cd                	j	3aca <sbrkfail+0x76>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3aea:	0911                	addi	s2,s2,4
    3aec:	03390a63          	beq	s2,s3,3b20 <sbrkfail+0xcc>
    if((pids[i] = fork()) == 0){
    3af0:	404010ef          	jal	4ef4 <fork>
    3af4:	00a92023          	sw	a0,0(s2)
    3af8:	d54d                	beqz	a0,3aa2 <sbrkfail+0x4e>
    if(pids[i] != -1) {
    3afa:	ff4508e3          	beq	a0,s4,3aea <sbrkfail+0x96>
      read(fds[0], &scratch, 1);
    3afe:	8656                	mv	a2,s5
    3b00:	85da                	mv	a1,s6
    3b02:	fa042503          	lw	a0,-96(s0)
    3b06:	40e010ef          	jal	4f14 <read>
      if(scratch == '0')
    3b0a:	f9f44783          	lbu	a5,-97(s0)
    3b0e:	fd078793          	addi	a5,a5,-48 # 63fffd0 <base+0x63f1328>
    3b12:	0017b793          	seqz	a5,a5
    3b16:	00fbe7b3          	or	a5,s7,a5
    3b1a:	00078b9b          	sext.w	s7,a5
    3b1e:	b7f1                	j	3aea <sbrkfail+0x96>
  if(!failed) {
    3b20:	000b8863          	beqz	s7,3b30 <sbrkfail+0xdc>
  c = sbrk(PGSIZE);
    3b24:	6505                	lui	a0,0x1
    3b26:	3a2010ef          	jal	4ec8 <sbrk>
    3b2a:	8a2a                	mv	s4,a0
    if(pids[i] == -1)
    3b2c:	597d                	li	s2,-1
    3b2e:	a821                	j	3b46 <sbrkfail+0xf2>
    printf("%s: no allocation failed; allocate more?\n", s);
    3b30:	85e2                	mv	a1,s8
    3b32:	00003517          	auipc	a0,0x3
    3b36:	4f650513          	addi	a0,a0,1270 # 7028 <malloc+0x1c26>
    3b3a:	011010ef          	jal	534a <printf>
    3b3e:	b7dd                	j	3b24 <sbrkfail+0xd0>
  for(i = 0; i < sizeof(pids)/sizeof(pids[0]); i++){
    3b40:	0491                	addi	s1,s1,4
    3b42:	01348b63          	beq	s1,s3,3b58 <sbrkfail+0x104>
    if(pids[i] == -1)
    3b46:	4088                	lw	a0,0(s1)
    3b48:	ff250ce3          	beq	a0,s2,3b40 <sbrkfail+0xec>
    kill(pids[i]);
    3b4c:	3e0010ef          	jal	4f2c <kill>
    wait(0);
    3b50:	4501                	li	a0,0
    3b52:	3b2010ef          	jal	4f04 <wait>
    3b56:	b7ed                	j	3b40 <sbrkfail+0xec>
  if(c == (char*)SBRK_ERROR){
    3b58:	57fd                	li	a5,-1
    3b5a:	02fa0a63          	beq	s4,a5,3b8e <sbrkfail+0x13a>
  pid = fork();
    3b5e:	396010ef          	jal	4ef4 <fork>
  if(pid < 0){
    3b62:	04054063          	bltz	a0,3ba2 <sbrkfail+0x14e>
  if(pid == 0){
    3b66:	e939                	bnez	a0,3bbc <sbrkfail+0x168>
    a = sbrk(10*BIG);
    3b68:	3e800537          	lui	a0,0x3e800
    3b6c:	35c010ef          	jal	4ec8 <sbrk>
    if(a == (char*)SBRK_ERROR){
    3b70:	57fd                	li	a5,-1
    3b72:	04f50263          	beq	a0,a5,3bb6 <sbrkfail+0x162>
    printf("%s: allocate a lot of memory succeeded %d\n", s, 10*BIG);
    3b76:	3e800637          	lui	a2,0x3e800
    3b7a:	85e2                	mv	a1,s8
    3b7c:	00003517          	auipc	a0,0x3
    3b80:	4fc50513          	addi	a0,a0,1276 # 7078 <malloc+0x1c76>
    3b84:	7c6010ef          	jal	534a <printf>
    exit(1);
    3b88:	4505                	li	a0,1
    3b8a:	372010ef          	jal	4efc <exit>
    printf("%s: failed sbrk leaked memory\n", s);
    3b8e:	85e2                	mv	a1,s8
    3b90:	00003517          	auipc	a0,0x3
    3b94:	4c850513          	addi	a0,a0,1224 # 7058 <malloc+0x1c56>
    3b98:	7b2010ef          	jal	534a <printf>
    exit(1);
    3b9c:	4505                	li	a0,1
    3b9e:	35e010ef          	jal	4efc <exit>
    printf("%s: fork failed\n", s);
    3ba2:	85e2                	mv	a1,s8
    3ba4:	00002517          	auipc	a0,0x2
    3ba8:	22450513          	addi	a0,a0,548 # 5dc8 <malloc+0x9c6>
    3bac:	79e010ef          	jal	534a <printf>
    exit(1);
    3bb0:	4505                	li	a0,1
    3bb2:	34a010ef          	jal	4efc <exit>
      exit(0);
    3bb6:	4501                	li	a0,0
    3bb8:	344010ef          	jal	4efc <exit>
  wait(&xstatus);
    3bbc:	fac40513          	addi	a0,s0,-84
    3bc0:	344010ef          	jal	4f04 <wait>
  if(xstatus != 0)
    3bc4:	fac42783          	lw	a5,-84(s0)
    3bc8:	ef89                	bnez	a5,3be2 <sbrkfail+0x18e>
}
    3bca:	60aa                	ld	ra,136(sp)
    3bcc:	640a                	ld	s0,128(sp)
    3bce:	74e6                	ld	s1,120(sp)
    3bd0:	7946                	ld	s2,112(sp)
    3bd2:	79a6                	ld	s3,104(sp)
    3bd4:	7a06                	ld	s4,96(sp)
    3bd6:	6ae6                	ld	s5,88(sp)
    3bd8:	6b46                	ld	s6,80(sp)
    3bda:	6ba6                	ld	s7,72(sp)
    3bdc:	6c06                	ld	s8,64(sp)
    3bde:	6149                	addi	sp,sp,144
    3be0:	8082                	ret
    exit(1);
    3be2:	4505                	li	a0,1
    3be4:	318010ef          	jal	4efc <exit>

0000000000003be8 <mem>:
{
    3be8:	7139                	addi	sp,sp,-64
    3bea:	fc06                	sd	ra,56(sp)
    3bec:	f822                	sd	s0,48(sp)
    3bee:	f426                	sd	s1,40(sp)
    3bf0:	f04a                	sd	s2,32(sp)
    3bf2:	ec4e                	sd	s3,24(sp)
    3bf4:	0080                	addi	s0,sp,64
    3bf6:	89aa                	mv	s3,a0
  if((pid = fork()) == 0){
    3bf8:	2fc010ef          	jal	4ef4 <fork>
    m1 = 0;
    3bfc:	4481                	li	s1,0
    while((m2 = malloc(10001)) != 0){
    3bfe:	6909                	lui	s2,0x2
    3c00:	71190913          	addi	s2,s2,1809 # 2711 <execout+0x23>
  if((pid = fork()) == 0){
    3c04:	cd11                	beqz	a0,3c20 <mem+0x38>
    wait(&xstatus);
    3c06:	fcc40513          	addi	a0,s0,-52
    3c0a:	2fa010ef          	jal	4f04 <wait>
    if(xstatus == -1){
    3c0e:	fcc42503          	lw	a0,-52(s0)
    3c12:	57fd                	li	a5,-1
    3c14:	04f50363          	beq	a0,a5,3c5a <mem+0x72>
    exit(xstatus);
    3c18:	2e4010ef          	jal	4efc <exit>
      *(char**)m2 = m1;
    3c1c:	e104                	sd	s1,0(a0)
      m1 = m2;
    3c1e:	84aa                	mv	s1,a0
    while((m2 = malloc(10001)) != 0){
    3c20:	854a                	mv	a0,s2
    3c22:	7e0010ef          	jal	5402 <malloc>
    3c26:	f97d                	bnez	a0,3c1c <mem+0x34>
    while(m1){
    3c28:	c491                	beqz	s1,3c34 <mem+0x4c>
      m2 = *(char**)m1;
    3c2a:	8526                	mv	a0,s1
    3c2c:	6084                	ld	s1,0(s1)
      free(m1);
    3c2e:	74e010ef          	jal	537c <free>
    while(m1){
    3c32:	fce5                	bnez	s1,3c2a <mem+0x42>
    m1 = malloc(1024*20);
    3c34:	6515                	lui	a0,0x5
    3c36:	7cc010ef          	jal	5402 <malloc>
    if(m1 == 0){
    3c3a:	c511                	beqz	a0,3c46 <mem+0x5e>
    free(m1);
    3c3c:	740010ef          	jal	537c <free>
    exit(0);
    3c40:	4501                	li	a0,0
    3c42:	2ba010ef          	jal	4efc <exit>
      printf("%s: couldn't allocate mem?!!\n", s);
    3c46:	85ce                	mv	a1,s3
    3c48:	00003517          	auipc	a0,0x3
    3c4c:	46050513          	addi	a0,a0,1120 # 70a8 <malloc+0x1ca6>
    3c50:	6fa010ef          	jal	534a <printf>
      exit(1);
    3c54:	4505                	li	a0,1
    3c56:	2a6010ef          	jal	4efc <exit>
      exit(0);
    3c5a:	4501                	li	a0,0
    3c5c:	2a0010ef          	jal	4efc <exit>

0000000000003c60 <sharedfd>:
{
    3c60:	7159                	addi	sp,sp,-112
    3c62:	f486                	sd	ra,104(sp)
    3c64:	f0a2                	sd	s0,96(sp)
    3c66:	eca6                	sd	s1,88(sp)
    3c68:	f85a                	sd	s6,48(sp)
    3c6a:	1880                	addi	s0,sp,112
    3c6c:	84aa                	mv	s1,a0
    3c6e:	8b2a                	mv	s6,a0
  unlink("sharedfd");
    3c70:	00003517          	auipc	a0,0x3
    3c74:	45850513          	addi	a0,a0,1112 # 70c8 <malloc+0x1cc6>
    3c78:	2d4010ef          	jal	4f4c <unlink>
  fd = open("sharedfd", O_CREATE|O_RDWR);
    3c7c:	20200593          	li	a1,514
    3c80:	00003517          	auipc	a0,0x3
    3c84:	44850513          	addi	a0,a0,1096 # 70c8 <malloc+0x1cc6>
    3c88:	2b4010ef          	jal	4f3c <open>
  if(fd < 0){
    3c8c:	04054863          	bltz	a0,3cdc <sharedfd+0x7c>
    3c90:	e8ca                	sd	s2,80(sp)
    3c92:	e4ce                	sd	s3,72(sp)
    3c94:	e0d2                	sd	s4,64(sp)
    3c96:	fc56                	sd	s5,56(sp)
    3c98:	89aa                	mv	s3,a0
  pid = fork();
    3c9a:	25a010ef          	jal	4ef4 <fork>
    3c9e:	8aaa                	mv	s5,a0
  memset(buf, pid==0?'c':'p', sizeof(buf));
    3ca0:	07000593          	li	a1,112
    3ca4:	e119                	bnez	a0,3caa <sharedfd+0x4a>
    3ca6:	06300593          	li	a1,99
    3caa:	4629                	li	a2,10
    3cac:	fa040513          	addi	a0,s0,-96
    3cb0:	022010ef          	jal	4cd2 <memset>
    3cb4:	3e800493          	li	s1,1000
    if(write(fd, buf, sizeof(buf)) != sizeof(buf)){
    3cb8:	fa040a13          	addi	s4,s0,-96
    3cbc:	4929                	li	s2,10
    3cbe:	864a                	mv	a2,s2
    3cc0:	85d2                	mv	a1,s4
    3cc2:	854e                	mv	a0,s3
    3cc4:	258010ef          	jal	4f1c <write>
    3cc8:	03251963          	bne	a0,s2,3cfa <sharedfd+0x9a>
  for(i = 0; i < N; i++){
    3ccc:	34fd                	addiw	s1,s1,-1
    3cce:	f8e5                	bnez	s1,3cbe <sharedfd+0x5e>
  if(pid == 0) {
    3cd0:	040a9063          	bnez	s5,3d10 <sharedfd+0xb0>
    3cd4:	f45e                	sd	s7,40(sp)
    exit(0);
    3cd6:	4501                	li	a0,0
    3cd8:	224010ef          	jal	4efc <exit>
    3cdc:	e8ca                	sd	s2,80(sp)
    3cde:	e4ce                	sd	s3,72(sp)
    3ce0:	e0d2                	sd	s4,64(sp)
    3ce2:	fc56                	sd	s5,56(sp)
    3ce4:	f45e                	sd	s7,40(sp)
    printf("%s: cannot open sharedfd for writing", s);
    3ce6:	85a6                	mv	a1,s1
    3ce8:	00003517          	auipc	a0,0x3
    3cec:	3f050513          	addi	a0,a0,1008 # 70d8 <malloc+0x1cd6>
    3cf0:	65a010ef          	jal	534a <printf>
    exit(1);
    3cf4:	4505                	li	a0,1
    3cf6:	206010ef          	jal	4efc <exit>
    3cfa:	f45e                	sd	s7,40(sp)
      printf("%s: write sharedfd failed\n", s);
    3cfc:	85da                	mv	a1,s6
    3cfe:	00003517          	auipc	a0,0x3
    3d02:	40250513          	addi	a0,a0,1026 # 7100 <malloc+0x1cfe>
    3d06:	644010ef          	jal	534a <printf>
      exit(1);
    3d0a:	4505                	li	a0,1
    3d0c:	1f0010ef          	jal	4efc <exit>
    wait(&xstatus);
    3d10:	f9c40513          	addi	a0,s0,-100
    3d14:	1f0010ef          	jal	4f04 <wait>
    if(xstatus != 0)
    3d18:	f9c42a03          	lw	s4,-100(s0)
    3d1c:	000a0663          	beqz	s4,3d28 <sharedfd+0xc8>
    3d20:	f45e                	sd	s7,40(sp)
      exit(xstatus);
    3d22:	8552                	mv	a0,s4
    3d24:	1d8010ef          	jal	4efc <exit>
    3d28:	f45e                	sd	s7,40(sp)
  close(fd);
    3d2a:	854e                	mv	a0,s3
    3d2c:	1f8010ef          	jal	4f24 <close>
  fd = open("sharedfd", 0);
    3d30:	4581                	li	a1,0
    3d32:	00003517          	auipc	a0,0x3
    3d36:	39650513          	addi	a0,a0,918 # 70c8 <malloc+0x1cc6>
    3d3a:	202010ef          	jal	4f3c <open>
    3d3e:	8baa                	mv	s7,a0
  nc = np = 0;
    3d40:	89d2                	mv	s3,s4
  if(fd < 0){
    3d42:	02054363          	bltz	a0,3d68 <sharedfd+0x108>
    3d46:	faa40913          	addi	s2,s0,-86
      if(buf[i] == 'c')
    3d4a:	06300493          	li	s1,99
      if(buf[i] == 'p')
    3d4e:	07000a93          	li	s5,112
  while((n = read(fd, buf, sizeof(buf))) > 0){
    3d52:	4629                	li	a2,10
    3d54:	fa040593          	addi	a1,s0,-96
    3d58:	855e                	mv	a0,s7
    3d5a:	1ba010ef          	jal	4f14 <read>
    3d5e:	02a05b63          	blez	a0,3d94 <sharedfd+0x134>
    3d62:	fa040793          	addi	a5,s0,-96
    3d66:	a839                	j	3d84 <sharedfd+0x124>
    printf("%s: cannot open sharedfd for reading\n", s);
    3d68:	85da                	mv	a1,s6
    3d6a:	00003517          	auipc	a0,0x3
    3d6e:	3b650513          	addi	a0,a0,950 # 7120 <malloc+0x1d1e>
    3d72:	5d8010ef          	jal	534a <printf>
    exit(1);
    3d76:	4505                	li	a0,1
    3d78:	184010ef          	jal	4efc <exit>
        nc++;
    3d7c:	2a05                	addiw	s4,s4,1
    for(i = 0; i < sizeof(buf); i++){
    3d7e:	0785                	addi	a5,a5,1
    3d80:	fd2789e3          	beq	a5,s2,3d52 <sharedfd+0xf2>
      if(buf[i] == 'c')
    3d84:	0007c703          	lbu	a4,0(a5)
    3d88:	fe970ae3          	beq	a4,s1,3d7c <sharedfd+0x11c>
      if(buf[i] == 'p')
    3d8c:	ff5719e3          	bne	a4,s5,3d7e <sharedfd+0x11e>
        np++;
    3d90:	2985                	addiw	s3,s3,1
    3d92:	b7f5                	j	3d7e <sharedfd+0x11e>
  close(fd);
    3d94:	855e                	mv	a0,s7
    3d96:	18e010ef          	jal	4f24 <close>
  unlink("sharedfd");
    3d9a:	00003517          	auipc	a0,0x3
    3d9e:	32e50513          	addi	a0,a0,814 # 70c8 <malloc+0x1cc6>
    3da2:	1aa010ef          	jal	4f4c <unlink>
  if(nc == N*SZ && np == N*SZ){
    3da6:	6789                	lui	a5,0x2
    3da8:	71078793          	addi	a5,a5,1808 # 2710 <execout+0x22>
    3dac:	00fa1763          	bne	s4,a5,3dba <sharedfd+0x15a>
    3db0:	01499563          	bne	s3,s4,3dba <sharedfd+0x15a>
    exit(0);
    3db4:	4501                	li	a0,0
    3db6:	146010ef          	jal	4efc <exit>
    printf("%s: nc/np test fails\n", s);
    3dba:	85da                	mv	a1,s6
    3dbc:	00003517          	auipc	a0,0x3
    3dc0:	38c50513          	addi	a0,a0,908 # 7148 <malloc+0x1d46>
    3dc4:	586010ef          	jal	534a <printf>
    exit(1);
    3dc8:	4505                	li	a0,1
    3dca:	132010ef          	jal	4efc <exit>

0000000000003dce <fourfiles>:
{
    3dce:	7135                	addi	sp,sp,-160
    3dd0:	ed06                	sd	ra,152(sp)
    3dd2:	e922                	sd	s0,144(sp)
    3dd4:	e526                	sd	s1,136(sp)
    3dd6:	e14a                	sd	s2,128(sp)
    3dd8:	fcce                	sd	s3,120(sp)
    3dda:	f8d2                	sd	s4,112(sp)
    3ddc:	f4d6                	sd	s5,104(sp)
    3dde:	f0da                	sd	s6,96(sp)
    3de0:	ecde                	sd	s7,88(sp)
    3de2:	e8e2                	sd	s8,80(sp)
    3de4:	e4e6                	sd	s9,72(sp)
    3de6:	e0ea                	sd	s10,64(sp)
    3de8:	fc6e                	sd	s11,56(sp)
    3dea:	1100                	addi	s0,sp,160
    3dec:	8caa                	mv	s9,a0
  char *names[] = { "f0", "f1", "f2", "f3" };
    3dee:	00003797          	auipc	a5,0x3
    3df2:	37278793          	addi	a5,a5,882 # 7160 <malloc+0x1d5e>
    3df6:	f6f43823          	sd	a5,-144(s0)
    3dfa:	00003797          	auipc	a5,0x3
    3dfe:	36e78793          	addi	a5,a5,878 # 7168 <malloc+0x1d66>
    3e02:	f6f43c23          	sd	a5,-136(s0)
    3e06:	00003797          	auipc	a5,0x3
    3e0a:	36a78793          	addi	a5,a5,874 # 7170 <malloc+0x1d6e>
    3e0e:	f8f43023          	sd	a5,-128(s0)
    3e12:	00003797          	auipc	a5,0x3
    3e16:	36678793          	addi	a5,a5,870 # 7178 <malloc+0x1d76>
    3e1a:	f8f43423          	sd	a5,-120(s0)
  for(pi = 0; pi < NCHILD; pi++){
    3e1e:	f7040b93          	addi	s7,s0,-144
  char *names[] = { "f0", "f1", "f2", "f3" };
    3e22:	895e                	mv	s2,s7
  for(pi = 0; pi < NCHILD; pi++){
    3e24:	4481                	li	s1,0
    3e26:	4a11                	li	s4,4
    fname = names[pi];
    3e28:	00093983          	ld	s3,0(s2)
    unlink(fname);
    3e2c:	854e                	mv	a0,s3
    3e2e:	11e010ef          	jal	4f4c <unlink>
    pid = fork();
    3e32:	0c2010ef          	jal	4ef4 <fork>
    if(pid < 0){
    3e36:	04054063          	bltz	a0,3e76 <fourfiles+0xa8>
    if(pid == 0){
    3e3a:	c921                	beqz	a0,3e8a <fourfiles+0xbc>
  for(pi = 0; pi < NCHILD; pi++){
    3e3c:	2485                	addiw	s1,s1,1
    3e3e:	0921                	addi	s2,s2,8
    3e40:	ff4494e3          	bne	s1,s4,3e28 <fourfiles+0x5a>
    3e44:	4491                	li	s1,4
    wait(&xstatus);
    3e46:	f6c40913          	addi	s2,s0,-148
    3e4a:	854a                	mv	a0,s2
    3e4c:	0b8010ef          	jal	4f04 <wait>
    if(xstatus != 0)
    3e50:	f6c42b03          	lw	s6,-148(s0)
    3e54:	0a0b1463          	bnez	s6,3efc <fourfiles+0x12e>
  for(pi = 0; pi < NCHILD; pi++){
    3e58:	34fd                	addiw	s1,s1,-1
    3e5a:	f8e5                	bnez	s1,3e4a <fourfiles+0x7c>
    3e5c:	03000493          	li	s1,48
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3e60:	6a8d                	lui	s5,0x3
    3e62:	00008a17          	auipc	s4,0x8
    3e66:	e46a0a13          	addi	s4,s4,-442 # bca8 <buf>
    if(total != N*SZ){
    3e6a:	6d05                	lui	s10,0x1
    3e6c:	770d0d13          	addi	s10,s10,1904 # 1770 <exitwait+0x8c>
  for(i = 0; i < NCHILD; i++){
    3e70:	03400d93          	li	s11,52
    3e74:	a86d                	j	3f2e <fourfiles+0x160>
      printf("%s: fork failed\n", s);
    3e76:	85e6                	mv	a1,s9
    3e78:	00002517          	auipc	a0,0x2
    3e7c:	f5050513          	addi	a0,a0,-176 # 5dc8 <malloc+0x9c6>
    3e80:	4ca010ef          	jal	534a <printf>
      exit(1);
    3e84:	4505                	li	a0,1
    3e86:	076010ef          	jal	4efc <exit>
      fd = open(fname, O_CREATE | O_RDWR);
    3e8a:	20200593          	li	a1,514
    3e8e:	854e                	mv	a0,s3
    3e90:	0ac010ef          	jal	4f3c <open>
    3e94:	892a                	mv	s2,a0
      if(fd < 0){
    3e96:	04054063          	bltz	a0,3ed6 <fourfiles+0x108>
      memset(buf, '0'+pi, SZ);
    3e9a:	1f400613          	li	a2,500
    3e9e:	0304859b          	addiw	a1,s1,48
    3ea2:	00008517          	auipc	a0,0x8
    3ea6:	e0650513          	addi	a0,a0,-506 # bca8 <buf>
    3eaa:	629000ef          	jal	4cd2 <memset>
    3eae:	44b1                	li	s1,12
        if((n = write(fd, buf, SZ)) != SZ){
    3eb0:	1f400993          	li	s3,500
    3eb4:	00008a17          	auipc	s4,0x8
    3eb8:	df4a0a13          	addi	s4,s4,-524 # bca8 <buf>
    3ebc:	864e                	mv	a2,s3
    3ebe:	85d2                	mv	a1,s4
    3ec0:	854a                	mv	a0,s2
    3ec2:	05a010ef          	jal	4f1c <write>
    3ec6:	85aa                	mv	a1,a0
    3ec8:	03351163          	bne	a0,s3,3eea <fourfiles+0x11c>
      for(i = 0; i < N; i++){
    3ecc:	34fd                	addiw	s1,s1,-1
    3ece:	f4fd                	bnez	s1,3ebc <fourfiles+0xee>
      exit(0);
    3ed0:	4501                	li	a0,0
    3ed2:	02a010ef          	jal	4efc <exit>
        printf("%s: create failed\n", s);
    3ed6:	85e6                	mv	a1,s9
    3ed8:	00002517          	auipc	a0,0x2
    3edc:	f8850513          	addi	a0,a0,-120 # 5e60 <malloc+0xa5e>
    3ee0:	46a010ef          	jal	534a <printf>
        exit(1);
    3ee4:	4505                	li	a0,1
    3ee6:	016010ef          	jal	4efc <exit>
          printf("write failed %d\n", n);
    3eea:	00003517          	auipc	a0,0x3
    3eee:	29650513          	addi	a0,a0,662 # 7180 <malloc+0x1d7e>
    3ef2:	458010ef          	jal	534a <printf>
          exit(1);
    3ef6:	4505                	li	a0,1
    3ef8:	004010ef          	jal	4efc <exit>
      exit(xstatus);
    3efc:	855a                	mv	a0,s6
    3efe:	7ff000ef          	jal	4efc <exit>
          printf("%s: wrong char\n", s);
    3f02:	85e6                	mv	a1,s9
    3f04:	00003517          	auipc	a0,0x3
    3f08:	29450513          	addi	a0,a0,660 # 7198 <malloc+0x1d96>
    3f0c:	43e010ef          	jal	534a <printf>
          exit(1);
    3f10:	4505                	li	a0,1
    3f12:	7eb000ef          	jal	4efc <exit>
    close(fd);
    3f16:	854e                	mv	a0,s3
    3f18:	00c010ef          	jal	4f24 <close>
    if(total != N*SZ){
    3f1c:	05a91863          	bne	s2,s10,3f6c <fourfiles+0x19e>
    unlink(fname);
    3f20:	8562                	mv	a0,s8
    3f22:	02a010ef          	jal	4f4c <unlink>
  for(i = 0; i < NCHILD; i++){
    3f26:	0ba1                	addi	s7,s7,8
    3f28:	2485                	addiw	s1,s1,1
    3f2a:	05b48b63          	beq	s1,s11,3f80 <fourfiles+0x1b2>
    fname = names[i];
    3f2e:	000bbc03          	ld	s8,0(s7)
    fd = open(fname, 0);
    3f32:	4581                	li	a1,0
    3f34:	8562                	mv	a0,s8
    3f36:	006010ef          	jal	4f3c <open>
    3f3a:	89aa                	mv	s3,a0
    total = 0;
    3f3c:	895a                	mv	s2,s6
    while((n = read(fd, buf, sizeof(buf))) > 0){
    3f3e:	8656                	mv	a2,s5
    3f40:	85d2                	mv	a1,s4
    3f42:	854e                	mv	a0,s3
    3f44:	7d1000ef          	jal	4f14 <read>
    3f48:	fca057e3          	blez	a0,3f16 <fourfiles+0x148>
    3f4c:	00008797          	auipc	a5,0x8
    3f50:	d5c78793          	addi	a5,a5,-676 # bca8 <buf>
    3f54:	00f506b3          	add	a3,a0,a5
        if(buf[j] != '0'+i){
    3f58:	0007c703          	lbu	a4,0(a5)
    3f5c:	fa9713e3          	bne	a4,s1,3f02 <fourfiles+0x134>
      for(j = 0; j < n; j++){
    3f60:	0785                	addi	a5,a5,1
    3f62:	fed79be3          	bne	a5,a3,3f58 <fourfiles+0x18a>
      total += n;
    3f66:	00a9093b          	addw	s2,s2,a0
    3f6a:	bfd1                	j	3f3e <fourfiles+0x170>
      printf("wrong length %d\n", total);
    3f6c:	85ca                	mv	a1,s2
    3f6e:	00003517          	auipc	a0,0x3
    3f72:	23a50513          	addi	a0,a0,570 # 71a8 <malloc+0x1da6>
    3f76:	3d4010ef          	jal	534a <printf>
      exit(1);
    3f7a:	4505                	li	a0,1
    3f7c:	781000ef          	jal	4efc <exit>
}
    3f80:	60ea                	ld	ra,152(sp)
    3f82:	644a                	ld	s0,144(sp)
    3f84:	64aa                	ld	s1,136(sp)
    3f86:	690a                	ld	s2,128(sp)
    3f88:	79e6                	ld	s3,120(sp)
    3f8a:	7a46                	ld	s4,112(sp)
    3f8c:	7aa6                	ld	s5,104(sp)
    3f8e:	7b06                	ld	s6,96(sp)
    3f90:	6be6                	ld	s7,88(sp)
    3f92:	6c46                	ld	s8,80(sp)
    3f94:	6ca6                	ld	s9,72(sp)
    3f96:	6d06                	ld	s10,64(sp)
    3f98:	7de2                	ld	s11,56(sp)
    3f9a:	610d                	addi	sp,sp,160
    3f9c:	8082                	ret

0000000000003f9e <concreate>:
{
    3f9e:	7171                	addi	sp,sp,-176
    3fa0:	f506                	sd	ra,168(sp)
    3fa2:	f122                	sd	s0,160(sp)
    3fa4:	ed26                	sd	s1,152(sp)
    3fa6:	e94a                	sd	s2,144(sp)
    3fa8:	e54e                	sd	s3,136(sp)
    3faa:	e152                	sd	s4,128(sp)
    3fac:	fcd6                	sd	s5,120(sp)
    3fae:	f8da                	sd	s6,112(sp)
    3fb0:	f4de                	sd	s7,104(sp)
    3fb2:	f0e2                	sd	s8,96(sp)
    3fb4:	ece6                	sd	s9,88(sp)
    3fb6:	e8ea                	sd	s10,80(sp)
    3fb8:	1900                	addi	s0,sp,176
    3fba:	8d2a                	mv	s10,a0
  file[0] = 'C';
    3fbc:	04300793          	li	a5,67
    3fc0:	f8f40c23          	sb	a5,-104(s0)
  file[2] = '\0';
    3fc4:	f8040d23          	sb	zero,-102(s0)
  for(i = 0; i < N; i++){
    3fc8:	4901                	li	s2,0
    unlink(file);
    3fca:	f9840993          	addi	s3,s0,-104
    if(pid && (i % 3) == 1){
    3fce:	55555b37          	lui	s6,0x55555
    3fd2:	556b0b13          	addi	s6,s6,1366 # 55555556 <base+0x555468ae>
    3fd6:	4b85                	li	s7,1
      fd = open(file, O_CREATE | O_RDWR);
    3fd8:	20200c13          	li	s8,514
      link("C0", file);
    3fdc:	00003c97          	auipc	s9,0x3
    3fe0:	1e4c8c93          	addi	s9,s9,484 # 71c0 <malloc+0x1dbe>
      wait(&xstatus);
    3fe4:	f5c40a93          	addi	s5,s0,-164
  for(i = 0; i < N; i++){
    3fe8:	02800a13          	li	s4,40
    3fec:	ac25                	j	4224 <concreate+0x286>
      link("C0", file);
    3fee:	85ce                	mv	a1,s3
    3ff0:	8566                	mv	a0,s9
    3ff2:	76b000ef          	jal	4f5c <link>
    if(pid == 0) {
    3ff6:	ac29                	j	4210 <concreate+0x272>
    } else if(pid == 0 && (i % 5) == 1){
    3ff8:	666667b7          	lui	a5,0x66666
    3ffc:	66778793          	addi	a5,a5,1639 # 66666667 <base+0x666579bf>
    4000:	02f907b3          	mul	a5,s2,a5
    4004:	9785                	srai	a5,a5,0x21
    4006:	41f9571b          	sraiw	a4,s2,0x1f
    400a:	9f99                	subw	a5,a5,a4
    400c:	0027971b          	slliw	a4,a5,0x2
    4010:	9fb9                	addw	a5,a5,a4
    4012:	40f9093b          	subw	s2,s2,a5
    4016:	4785                	li	a5,1
    4018:	02f90563          	beq	s2,a5,4042 <concreate+0xa4>
      fd = open(file, O_CREATE | O_RDWR);
    401c:	20200593          	li	a1,514
    4020:	f9840513          	addi	a0,s0,-104
    4024:	719000ef          	jal	4f3c <open>
      if(fd < 0){
    4028:	1c055f63          	bgez	a0,4206 <concreate+0x268>
        printf("concreate create %s failed\n", file);
    402c:	f9840593          	addi	a1,s0,-104
    4030:	00003517          	auipc	a0,0x3
    4034:	19850513          	addi	a0,a0,408 # 71c8 <malloc+0x1dc6>
    4038:	312010ef          	jal	534a <printf>
        exit(1);
    403c:	4505                	li	a0,1
    403e:	6bf000ef          	jal	4efc <exit>
      link("C0", file);
    4042:	f9840593          	addi	a1,s0,-104
    4046:	00003517          	auipc	a0,0x3
    404a:	17a50513          	addi	a0,a0,378 # 71c0 <malloc+0x1dbe>
    404e:	70f000ef          	jal	4f5c <link>
      exit(0);
    4052:	4501                	li	a0,0
    4054:	6a9000ef          	jal	4efc <exit>
        exit(1);
    4058:	4505                	li	a0,1
    405a:	6a3000ef          	jal	4efc <exit>
  memset(fa, 0, sizeof(fa));
    405e:	02800613          	li	a2,40
    4062:	4581                	li	a1,0
    4064:	f7040513          	addi	a0,s0,-144
    4068:	46b000ef          	jal	4cd2 <memset>
  fd = open(".", 0);
    406c:	4581                	li	a1,0
    406e:	00002517          	auipc	a0,0x2
    4072:	bb250513          	addi	a0,a0,-1102 # 5c20 <malloc+0x81e>
    4076:	6c7000ef          	jal	4f3c <open>
    407a:	892a                	mv	s2,a0
  n = 0;
    407c:	8b26                	mv	s6,s1
  while(read(fd, &de, sizeof(de)) > 0){
    407e:	f6040a13          	addi	s4,s0,-160
    4082:	49c1                	li	s3,16
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    4084:	04300a93          	li	s5,67
      if(i < 0 || i >= sizeof(fa)){
    4088:	02700b93          	li	s7,39
      fa[i] = 1;
    408c:	4c05                	li	s8,1
  while(read(fd, &de, sizeof(de)) > 0){
    408e:	864e                	mv	a2,s3
    4090:	85d2                	mv	a1,s4
    4092:	854a                	mv	a0,s2
    4094:	681000ef          	jal	4f14 <read>
    4098:	06a05763          	blez	a0,4106 <concreate+0x168>
    if(de.inum == 0)
    409c:	f6045783          	lhu	a5,-160(s0)
    40a0:	d7fd                	beqz	a5,408e <concreate+0xf0>
    if(de.name[0] == 'C' && de.name[2] == '\0'){
    40a2:	f6244783          	lbu	a5,-158(s0)
    40a6:	ff5794e3          	bne	a5,s5,408e <concreate+0xf0>
    40aa:	f6444783          	lbu	a5,-156(s0)
    40ae:	f3e5                	bnez	a5,408e <concreate+0xf0>
      i = de.name[1] - '0';
    40b0:	f6344783          	lbu	a5,-157(s0)
    40b4:	fd07879b          	addiw	a5,a5,-48
      if(i < 0 || i >= sizeof(fa)){
    40b8:	00fbef63          	bltu	s7,a5,40d6 <concreate+0x138>
      if(fa[i]){
    40bc:	fa078713          	addi	a4,a5,-96
    40c0:	9722                	add	a4,a4,s0
    40c2:	fd074703          	lbu	a4,-48(a4)
    40c6:	e705                	bnez	a4,40ee <concreate+0x150>
      fa[i] = 1;
    40c8:	fa078793          	addi	a5,a5,-96
    40cc:	97a2                	add	a5,a5,s0
    40ce:	fd878823          	sb	s8,-48(a5)
      n++;
    40d2:	2b05                	addiw	s6,s6,1
    40d4:	bf6d                	j	408e <concreate+0xf0>
        printf("%s: concreate weird file %s\n", s, de.name);
    40d6:	f6240613          	addi	a2,s0,-158
    40da:	85ea                	mv	a1,s10
    40dc:	00003517          	auipc	a0,0x3
    40e0:	10c50513          	addi	a0,a0,268 # 71e8 <malloc+0x1de6>
    40e4:	266010ef          	jal	534a <printf>
        exit(1);
    40e8:	4505                	li	a0,1
    40ea:	613000ef          	jal	4efc <exit>
        printf("%s: concreate duplicate file %s\n", s, de.name);
    40ee:	f6240613          	addi	a2,s0,-158
    40f2:	85ea                	mv	a1,s10
    40f4:	00003517          	auipc	a0,0x3
    40f8:	11450513          	addi	a0,a0,276 # 7208 <malloc+0x1e06>
    40fc:	24e010ef          	jal	534a <printf>
        exit(1);
    4100:	4505                	li	a0,1
    4102:	5fb000ef          	jal	4efc <exit>
  close(fd);
    4106:	854a                	mv	a0,s2
    4108:	61d000ef          	jal	4f24 <close>
  if(n != N){
    410c:	02800793          	li	a5,40
    4110:	00fb1a63          	bne	s6,a5,4124 <concreate+0x186>
    if(((i % 3) == 0 && pid == 0) ||
    4114:	55555a37          	lui	s4,0x55555
    4118:	556a0a13          	addi	s4,s4,1366 # 55555556 <base+0x555468ae>
      close(open(file, 0));
    411c:	f9840993          	addi	s3,s0,-104
  for(i = 0; i < N; i++){
    4120:	8ada                	mv	s5,s6
    4122:	a049                	j	41a4 <concreate+0x206>
    printf("%s: concreate not enough files in directory listing\n", s);
    4124:	85ea                	mv	a1,s10
    4126:	00003517          	auipc	a0,0x3
    412a:	10a50513          	addi	a0,a0,266 # 7230 <malloc+0x1e2e>
    412e:	21c010ef          	jal	534a <printf>
    exit(1);
    4132:	4505                	li	a0,1
    4134:	5c9000ef          	jal	4efc <exit>
      printf("%s: fork failed\n", s);
    4138:	85ea                	mv	a1,s10
    413a:	00002517          	auipc	a0,0x2
    413e:	c8e50513          	addi	a0,a0,-882 # 5dc8 <malloc+0x9c6>
    4142:	208010ef          	jal	534a <printf>
      exit(1);
    4146:	4505                	li	a0,1
    4148:	5b5000ef          	jal	4efc <exit>
      close(open(file, 0));
    414c:	4581                	li	a1,0
    414e:	854e                	mv	a0,s3
    4150:	5ed000ef          	jal	4f3c <open>
    4154:	5d1000ef          	jal	4f24 <close>
      close(open(file, 0));
    4158:	4581                	li	a1,0
    415a:	854e                	mv	a0,s3
    415c:	5e1000ef          	jal	4f3c <open>
    4160:	5c5000ef          	jal	4f24 <close>
      close(open(file, 0));
    4164:	4581                	li	a1,0
    4166:	854e                	mv	a0,s3
    4168:	5d5000ef          	jal	4f3c <open>
    416c:	5b9000ef          	jal	4f24 <close>
      close(open(file, 0));
    4170:	4581                	li	a1,0
    4172:	854e                	mv	a0,s3
    4174:	5c9000ef          	jal	4f3c <open>
    4178:	5ad000ef          	jal	4f24 <close>
      close(open(file, 0));
    417c:	4581                	li	a1,0
    417e:	854e                	mv	a0,s3
    4180:	5bd000ef          	jal	4f3c <open>
    4184:	5a1000ef          	jal	4f24 <close>
      close(open(file, 0));
    4188:	4581                	li	a1,0
    418a:	854e                	mv	a0,s3
    418c:	5b1000ef          	jal	4f3c <open>
    4190:	595000ef          	jal	4f24 <close>
    if(pid == 0)
    4194:	06090663          	beqz	s2,4200 <concreate+0x262>
      wait(0);
    4198:	4501                	li	a0,0
    419a:	56b000ef          	jal	4f04 <wait>
  for(i = 0; i < N; i++){
    419e:	2485                	addiw	s1,s1,1
    41a0:	0d548163          	beq	s1,s5,4262 <concreate+0x2c4>
    file[1] = '0' + i;
    41a4:	0304879b          	addiw	a5,s1,48
    41a8:	f8f40ca3          	sb	a5,-103(s0)
    pid = fork();
    41ac:	549000ef          	jal	4ef4 <fork>
    41b0:	892a                	mv	s2,a0
    if(pid < 0){
    41b2:	f80543e3          	bltz	a0,4138 <concreate+0x19a>
    if(((i % 3) == 0 && pid == 0) ||
    41b6:	03448733          	mul	a4,s1,s4
    41ba:	9301                	srli	a4,a4,0x20
    41bc:	41f4d79b          	sraiw	a5,s1,0x1f
    41c0:	9f1d                	subw	a4,a4,a5
    41c2:	0017179b          	slliw	a5,a4,0x1
    41c6:	9fb9                	addw	a5,a5,a4
    41c8:	40f487bb          	subw	a5,s1,a5
    41cc:	00a7e733          	or	a4,a5,a0
    41d0:	2701                	sext.w	a4,a4
    41d2:	df2d                	beqz	a4,414c <concreate+0x1ae>
       ((i % 3) == 1 && pid != 0)){
    41d4:	c119                	beqz	a0,41da <concreate+0x23c>
    if(((i % 3) == 0 && pid == 0) ||
    41d6:	17fd                	addi	a5,a5,-1
       ((i % 3) == 1 && pid != 0)){
    41d8:	dbb5                	beqz	a5,414c <concreate+0x1ae>
      unlink(file);
    41da:	854e                	mv	a0,s3
    41dc:	571000ef          	jal	4f4c <unlink>
      unlink(file);
    41e0:	854e                	mv	a0,s3
    41e2:	56b000ef          	jal	4f4c <unlink>
      unlink(file);
    41e6:	854e                	mv	a0,s3
    41e8:	565000ef          	jal	4f4c <unlink>
      unlink(file);
    41ec:	854e                	mv	a0,s3
    41ee:	55f000ef          	jal	4f4c <unlink>
      unlink(file);
    41f2:	854e                	mv	a0,s3
    41f4:	559000ef          	jal	4f4c <unlink>
      unlink(file);
    41f8:	854e                	mv	a0,s3
    41fa:	553000ef          	jal	4f4c <unlink>
    41fe:	bf59                	j	4194 <concreate+0x1f6>
      exit(0);
    4200:	4501                	li	a0,0
    4202:	4fb000ef          	jal	4efc <exit>
      close(fd);
    4206:	51f000ef          	jal	4f24 <close>
    if(pid == 0) {
    420a:	b5a1                	j	4052 <concreate+0xb4>
      close(fd);
    420c:	519000ef          	jal	4f24 <close>
      wait(&xstatus);
    4210:	8556                	mv	a0,s5
    4212:	4f3000ef          	jal	4f04 <wait>
      if(xstatus != 0)
    4216:	f5c42483          	lw	s1,-164(s0)
    421a:	e2049fe3          	bnez	s1,4058 <concreate+0xba>
  for(i = 0; i < N; i++){
    421e:	2905                	addiw	s2,s2,1
    4220:	e3490fe3          	beq	s2,s4,405e <concreate+0xc0>
    file[1] = '0' + i;
    4224:	0309079b          	addiw	a5,s2,48
    4228:	f8f40ca3          	sb	a5,-103(s0)
    unlink(file);
    422c:	854e                	mv	a0,s3
    422e:	51f000ef          	jal	4f4c <unlink>
    pid = fork();
    4232:	4c3000ef          	jal	4ef4 <fork>
    if(pid && (i % 3) == 1){
    4236:	dc0501e3          	beqz	a0,3ff8 <concreate+0x5a>
    423a:	036907b3          	mul	a5,s2,s6
    423e:	9381                	srli	a5,a5,0x20
    4240:	41f9571b          	sraiw	a4,s2,0x1f
    4244:	9f99                	subw	a5,a5,a4
    4246:	0017971b          	slliw	a4,a5,0x1
    424a:	9fb9                	addw	a5,a5,a4
    424c:	40f907bb          	subw	a5,s2,a5
    4250:	d9778fe3          	beq	a5,s7,3fee <concreate+0x50>
      fd = open(file, O_CREATE | O_RDWR);
    4254:	85e2                	mv	a1,s8
    4256:	854e                	mv	a0,s3
    4258:	4e5000ef          	jal	4f3c <open>
      if(fd < 0){
    425c:	fa0558e3          	bgez	a0,420c <concreate+0x26e>
    4260:	b3f1                	j	402c <concreate+0x8e>
}
    4262:	70aa                	ld	ra,168(sp)
    4264:	740a                	ld	s0,160(sp)
    4266:	64ea                	ld	s1,152(sp)
    4268:	694a                	ld	s2,144(sp)
    426a:	69aa                	ld	s3,136(sp)
    426c:	6a0a                	ld	s4,128(sp)
    426e:	7ae6                	ld	s5,120(sp)
    4270:	7b46                	ld	s6,112(sp)
    4272:	7ba6                	ld	s7,104(sp)
    4274:	7c06                	ld	s8,96(sp)
    4276:	6ce6                	ld	s9,88(sp)
    4278:	6d46                	ld	s10,80(sp)
    427a:	614d                	addi	sp,sp,176
    427c:	8082                	ret

000000000000427e <bigfile>:
{
    427e:	7139                	addi	sp,sp,-64
    4280:	fc06                	sd	ra,56(sp)
    4282:	f822                	sd	s0,48(sp)
    4284:	f426                	sd	s1,40(sp)
    4286:	f04a                	sd	s2,32(sp)
    4288:	ec4e                	sd	s3,24(sp)
    428a:	e852                	sd	s4,16(sp)
    428c:	e456                	sd	s5,8(sp)
    428e:	e05a                	sd	s6,0(sp)
    4290:	0080                	addi	s0,sp,64
    4292:	8b2a                	mv	s6,a0
  unlink("bigfile.dat");
    4294:	00003517          	auipc	a0,0x3
    4298:	fd450513          	addi	a0,a0,-44 # 7268 <malloc+0x1e66>
    429c:	4b1000ef          	jal	4f4c <unlink>
  fd = open("bigfile.dat", O_CREATE | O_RDWR);
    42a0:	20200593          	li	a1,514
    42a4:	00003517          	auipc	a0,0x3
    42a8:	fc450513          	addi	a0,a0,-60 # 7268 <malloc+0x1e66>
    42ac:	491000ef          	jal	4f3c <open>
  if(fd < 0){
    42b0:	08054a63          	bltz	a0,4344 <bigfile+0xc6>
    42b4:	8a2a                	mv	s4,a0
    42b6:	4481                	li	s1,0
    memset(buf, i, SZ);
    42b8:	25800913          	li	s2,600
    42bc:	00008997          	auipc	s3,0x8
    42c0:	9ec98993          	addi	s3,s3,-1556 # bca8 <buf>
  for(i = 0; i < N; i++){
    42c4:	4ad1                	li	s5,20
    memset(buf, i, SZ);
    42c6:	864a                	mv	a2,s2
    42c8:	85a6                	mv	a1,s1
    42ca:	854e                	mv	a0,s3
    42cc:	207000ef          	jal	4cd2 <memset>
    if(write(fd, buf, SZ) != SZ){
    42d0:	864a                	mv	a2,s2
    42d2:	85ce                	mv	a1,s3
    42d4:	8552                	mv	a0,s4
    42d6:	447000ef          	jal	4f1c <write>
    42da:	07251f63          	bne	a0,s2,4358 <bigfile+0xda>
  for(i = 0; i < N; i++){
    42de:	2485                	addiw	s1,s1,1
    42e0:	ff5493e3          	bne	s1,s5,42c6 <bigfile+0x48>
  close(fd);
    42e4:	8552                	mv	a0,s4
    42e6:	43f000ef          	jal	4f24 <close>
  fd = open("bigfile.dat", 0);
    42ea:	4581                	li	a1,0
    42ec:	00003517          	auipc	a0,0x3
    42f0:	f7c50513          	addi	a0,a0,-132 # 7268 <malloc+0x1e66>
    42f4:	449000ef          	jal	4f3c <open>
    42f8:	8aaa                	mv	s5,a0
  total = 0;
    42fa:	4a01                	li	s4,0
  for(i = 0; ; i++){
    42fc:	4481                	li	s1,0
    cc = read(fd, buf, SZ/2);
    42fe:	12c00993          	li	s3,300
    4302:	00008917          	auipc	s2,0x8
    4306:	9a690913          	addi	s2,s2,-1626 # bca8 <buf>
  if(fd < 0){
    430a:	06054163          	bltz	a0,436c <bigfile+0xee>
    cc = read(fd, buf, SZ/2);
    430e:	864e                	mv	a2,s3
    4310:	85ca                	mv	a1,s2
    4312:	8556                	mv	a0,s5
    4314:	401000ef          	jal	4f14 <read>
    if(cc < 0){
    4318:	06054463          	bltz	a0,4380 <bigfile+0x102>
    if(cc == 0)
    431c:	c145                	beqz	a0,43bc <bigfile+0x13e>
    if(cc != SZ/2){
    431e:	07351b63          	bne	a0,s3,4394 <bigfile+0x116>
    if(buf[0] != i/2 || buf[SZ/2-1] != i/2){
    4322:	01f4d79b          	srliw	a5,s1,0x1f
    4326:	9fa5                	addw	a5,a5,s1
    4328:	4017d79b          	sraiw	a5,a5,0x1
    432c:	00094703          	lbu	a4,0(s2)
    4330:	06f71c63          	bne	a4,a5,43a8 <bigfile+0x12a>
    4334:	12b94703          	lbu	a4,299(s2)
    4338:	06f71863          	bne	a4,a5,43a8 <bigfile+0x12a>
    total += cc;
    433c:	12ca0a1b          	addiw	s4,s4,300
  for(i = 0; ; i++){
    4340:	2485                	addiw	s1,s1,1
    cc = read(fd, buf, SZ/2);
    4342:	b7f1                	j	430e <bigfile+0x90>
    printf("%s: cannot create bigfile", s);
    4344:	85da                	mv	a1,s6
    4346:	00003517          	auipc	a0,0x3
    434a:	f3250513          	addi	a0,a0,-206 # 7278 <malloc+0x1e76>
    434e:	7fd000ef          	jal	534a <printf>
    exit(1);
    4352:	4505                	li	a0,1
    4354:	3a9000ef          	jal	4efc <exit>
      printf("%s: write bigfile failed\n", s);
    4358:	85da                	mv	a1,s6
    435a:	00003517          	auipc	a0,0x3
    435e:	f3e50513          	addi	a0,a0,-194 # 7298 <malloc+0x1e96>
    4362:	7e9000ef          	jal	534a <printf>
      exit(1);
    4366:	4505                	li	a0,1
    4368:	395000ef          	jal	4efc <exit>
    printf("%s: cannot open bigfile\n", s);
    436c:	85da                	mv	a1,s6
    436e:	00003517          	auipc	a0,0x3
    4372:	f4a50513          	addi	a0,a0,-182 # 72b8 <malloc+0x1eb6>
    4376:	7d5000ef          	jal	534a <printf>
    exit(1);
    437a:	4505                	li	a0,1
    437c:	381000ef          	jal	4efc <exit>
      printf("%s: read bigfile failed\n", s);
    4380:	85da                	mv	a1,s6
    4382:	00003517          	auipc	a0,0x3
    4386:	f5650513          	addi	a0,a0,-170 # 72d8 <malloc+0x1ed6>
    438a:	7c1000ef          	jal	534a <printf>
      exit(1);
    438e:	4505                	li	a0,1
    4390:	36d000ef          	jal	4efc <exit>
      printf("%s: short read bigfile\n", s);
    4394:	85da                	mv	a1,s6
    4396:	00003517          	auipc	a0,0x3
    439a:	f6250513          	addi	a0,a0,-158 # 72f8 <malloc+0x1ef6>
    439e:	7ad000ef          	jal	534a <printf>
      exit(1);
    43a2:	4505                	li	a0,1
    43a4:	359000ef          	jal	4efc <exit>
      printf("%s: read bigfile wrong data\n", s);
    43a8:	85da                	mv	a1,s6
    43aa:	00003517          	auipc	a0,0x3
    43ae:	f6650513          	addi	a0,a0,-154 # 7310 <malloc+0x1f0e>
    43b2:	799000ef          	jal	534a <printf>
      exit(1);
    43b6:	4505                	li	a0,1
    43b8:	345000ef          	jal	4efc <exit>
  close(fd);
    43bc:	8556                	mv	a0,s5
    43be:	367000ef          	jal	4f24 <close>
  if(total != N*SZ){
    43c2:	678d                	lui	a5,0x3
    43c4:	ee078793          	addi	a5,a5,-288 # 2ee0 <subdir+0x1da>
    43c8:	02fa1263          	bne	s4,a5,43ec <bigfile+0x16e>
  unlink("bigfile.dat");
    43cc:	00003517          	auipc	a0,0x3
    43d0:	e9c50513          	addi	a0,a0,-356 # 7268 <malloc+0x1e66>
    43d4:	379000ef          	jal	4f4c <unlink>
}
    43d8:	70e2                	ld	ra,56(sp)
    43da:	7442                	ld	s0,48(sp)
    43dc:	74a2                	ld	s1,40(sp)
    43de:	7902                	ld	s2,32(sp)
    43e0:	69e2                	ld	s3,24(sp)
    43e2:	6a42                	ld	s4,16(sp)
    43e4:	6aa2                	ld	s5,8(sp)
    43e6:	6b02                	ld	s6,0(sp)
    43e8:	6121                	addi	sp,sp,64
    43ea:	8082                	ret
    printf("%s: read bigfile wrong total\n", s);
    43ec:	85da                	mv	a1,s6
    43ee:	00003517          	auipc	a0,0x3
    43f2:	f4250513          	addi	a0,a0,-190 # 7330 <malloc+0x1f2e>
    43f6:	755000ef          	jal	534a <printf>
    exit(1);
    43fa:	4505                	li	a0,1
    43fc:	301000ef          	jal	4efc <exit>

0000000000004400 <bigargtest>:
{
    4400:	7121                	addi	sp,sp,-448
    4402:	ff06                	sd	ra,440(sp)
    4404:	fb22                	sd	s0,432(sp)
    4406:	f726                	sd	s1,424(sp)
    4408:	0380                	addi	s0,sp,448
    440a:	84aa                	mv	s1,a0
  unlink("bigarg-ok");
    440c:	00003517          	auipc	a0,0x3
    4410:	f4450513          	addi	a0,a0,-188 # 7350 <malloc+0x1f4e>
    4414:	339000ef          	jal	4f4c <unlink>
  pid = fork();
    4418:	2dd000ef          	jal	4ef4 <fork>
  if(pid == 0){
    441c:	c915                	beqz	a0,4450 <bigargtest+0x50>
  } else if(pid < 0){
    441e:	08054c63          	bltz	a0,44b6 <bigargtest+0xb6>
  wait(&xstatus);
    4422:	fdc40513          	addi	a0,s0,-36
    4426:	2df000ef          	jal	4f04 <wait>
  if(xstatus != 0)
    442a:	fdc42503          	lw	a0,-36(s0)
    442e:	ed51                	bnez	a0,44ca <bigargtest+0xca>
  fd = open("bigarg-ok", 0);
    4430:	4581                	li	a1,0
    4432:	00003517          	auipc	a0,0x3
    4436:	f1e50513          	addi	a0,a0,-226 # 7350 <malloc+0x1f4e>
    443a:	303000ef          	jal	4f3c <open>
  if(fd < 0){
    443e:	08054863          	bltz	a0,44ce <bigargtest+0xce>
  close(fd);
    4442:	2e3000ef          	jal	4f24 <close>
}
    4446:	70fa                	ld	ra,440(sp)
    4448:	745a                	ld	s0,432(sp)
    444a:	74ba                	ld	s1,424(sp)
    444c:	6139                	addi	sp,sp,448
    444e:	8082                	ret
    memset(big, ' ', sizeof(big));
    4450:	19000613          	li	a2,400
    4454:	02000593          	li	a1,32
    4458:	e4840513          	addi	a0,s0,-440
    445c:	077000ef          	jal	4cd2 <memset>
    big[sizeof(big)-1] = '\0';
    4460:	fc040ba3          	sb	zero,-41(s0)
    for(i = 0; i < MAXARG-1; i++)
    4464:	00004797          	auipc	a5,0x4
    4468:	02c78793          	addi	a5,a5,44 # 8490 <args.1>
    446c:	00004697          	auipc	a3,0x4
    4470:	11c68693          	addi	a3,a3,284 # 8588 <args.1+0xf8>
      args[i] = big;
    4474:	e4840713          	addi	a4,s0,-440
    4478:	e398                	sd	a4,0(a5)
    for(i = 0; i < MAXARG-1; i++)
    447a:	07a1                	addi	a5,a5,8
    447c:	fed79ee3          	bne	a5,a3,4478 <bigargtest+0x78>
    args[MAXARG-1] = 0;
    4480:	00004797          	auipc	a5,0x4
    4484:	1007b423          	sd	zero,264(a5) # 8588 <args.1+0xf8>
    exec("echo", args);
    4488:	00004597          	auipc	a1,0x4
    448c:	00858593          	addi	a1,a1,8 # 8490 <args.1>
    4490:	00001517          	auipc	a0,0x1
    4494:	0a850513          	addi	a0,a0,168 # 5538 <malloc+0x136>
    4498:	29d000ef          	jal	4f34 <exec>
    fd = open("bigarg-ok", O_CREATE);
    449c:	20000593          	li	a1,512
    44a0:	00003517          	auipc	a0,0x3
    44a4:	eb050513          	addi	a0,a0,-336 # 7350 <malloc+0x1f4e>
    44a8:	295000ef          	jal	4f3c <open>
    close(fd);
    44ac:	279000ef          	jal	4f24 <close>
    exit(0);
    44b0:	4501                	li	a0,0
    44b2:	24b000ef          	jal	4efc <exit>
    printf("%s: bigargtest: fork failed\n", s);
    44b6:	85a6                	mv	a1,s1
    44b8:	00003517          	auipc	a0,0x3
    44bc:	ea850513          	addi	a0,a0,-344 # 7360 <malloc+0x1f5e>
    44c0:	68b000ef          	jal	534a <printf>
    exit(1);
    44c4:	4505                	li	a0,1
    44c6:	237000ef          	jal	4efc <exit>
    exit(xstatus);
    44ca:	233000ef          	jal	4efc <exit>
    printf("%s: bigarg test failed!\n", s);
    44ce:	85a6                	mv	a1,s1
    44d0:	00003517          	auipc	a0,0x3
    44d4:	eb050513          	addi	a0,a0,-336 # 7380 <malloc+0x1f7e>
    44d8:	673000ef          	jal	534a <printf>
    exit(1);
    44dc:	4505                	li	a0,1
    44de:	21f000ef          	jal	4efc <exit>

00000000000044e2 <lazy_alloc>:
{
    44e2:	1141                	addi	sp,sp,-16
    44e4:	e406                	sd	ra,8(sp)
    44e6:	e022                	sd	s0,0(sp)
    44e8:	0800                	addi	s0,sp,16
  prev_end = sbrklazy(REGION_SZ);
    44ea:	40000537          	lui	a0,0x40000
    44ee:	1f1000ef          	jal	4ede <sbrklazy>
  if (prev_end == (char *) SBRK_ERROR) {
    44f2:	57fd                	li	a5,-1
    44f4:	02f50a63          	beq	a0,a5,4528 <lazy_alloc+0x46>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    44f8:	6605                	lui	a2,0x1
    44fa:	962a                	add	a2,a2,a0
    44fc:	400017b7          	lui	a5,0x40001
    4500:	00f50733          	add	a4,a0,a5
    4504:	87b2                	mv	a5,a2
    4506:	000406b7          	lui	a3,0x40
    *(char **)i = i;
    450a:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE)
    450c:	97b6                	add	a5,a5,a3
    450e:	fee79ee3          	bne	a5,a4,450a <lazy_alloc+0x28>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    4512:	000406b7          	lui	a3,0x40
    if (*(char **)i != i) {
    4516:	621c                	ld	a5,0(a2)
    4518:	02c79163          	bne	a5,a2,453a <lazy_alloc+0x58>
  for (i = prev_end + PGSIZE; i < new_end; i += 64 * PGSIZE) {
    451c:	9636                	add	a2,a2,a3
    451e:	fee61ce3          	bne	a2,a4,4516 <lazy_alloc+0x34>
  exit(0);
    4522:	4501                	li	a0,0
    4524:	1d9000ef          	jal	4efc <exit>
    printf("sbrklazy() failed\n");
    4528:	00003517          	auipc	a0,0x3
    452c:	e7850513          	addi	a0,a0,-392 # 73a0 <malloc+0x1f9e>
    4530:	61b000ef          	jal	534a <printf>
    exit(1);
    4534:	4505                	li	a0,1
    4536:	1c7000ef          	jal	4efc <exit>
      printf("failed to read value from memory\n");
    453a:	00003517          	auipc	a0,0x3
    453e:	e7e50513          	addi	a0,a0,-386 # 73b8 <malloc+0x1fb6>
    4542:	609000ef          	jal	534a <printf>
      exit(1);
    4546:	4505                	li	a0,1
    4548:	1b5000ef          	jal	4efc <exit>

000000000000454c <lazy_unmap>:
{
    454c:	7139                	addi	sp,sp,-64
    454e:	fc06                	sd	ra,56(sp)
    4550:	f822                	sd	s0,48(sp)
    4552:	0080                	addi	s0,sp,64
  prev_end = sbrklazy(REGION_SZ);
    4554:	40000537          	lui	a0,0x40000
    4558:	187000ef          	jal	4ede <sbrklazy>
  if (prev_end == (char*)SBRK_ERROR) {
    455c:	57fd                	li	a5,-1
    455e:	04f50863          	beq	a0,a5,45ae <lazy_unmap+0x62>
    4562:	f426                	sd	s1,40(sp)
    4564:	f04a                	sd	s2,32(sp)
    4566:	ec4e                	sd	s3,24(sp)
    4568:	e852                	sd	s4,16(sp)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    456a:	6905                	lui	s2,0x1
    456c:	992a                	add	s2,s2,a0
    456e:	400017b7          	lui	a5,0x40001
    4572:	00f504b3          	add	s1,a0,a5
    4576:	87ca                	mv	a5,s2
    4578:	01000737          	lui	a4,0x1000
    *(char **)i = i;
    457c:	e39c                	sd	a5,0(a5)
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE)
    457e:	97ba                	add	a5,a5,a4
    4580:	fe979ee3          	bne	a5,s1,457c <lazy_unmap+0x30>
      wait(&status);
    4584:	fcc40993          	addi	s3,s0,-52
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    4588:	01000a37          	lui	s4,0x1000
    pid = fork();
    458c:	169000ef          	jal	4ef4 <fork>
    if (pid < 0) {
    4590:	02054c63          	bltz	a0,45c8 <lazy_unmap+0x7c>
    } else if (pid == 0) {
    4594:	c139                	beqz	a0,45da <lazy_unmap+0x8e>
      wait(&status);
    4596:	854e                	mv	a0,s3
    4598:	16d000ef          	jal	4f04 <wait>
      if (status == 0) {
    459c:	fcc42783          	lw	a5,-52(s0)
    45a0:	c7b1                	beqz	a5,45ec <lazy_unmap+0xa0>
  for (i = prev_end + PGSIZE; i < new_end; i += PGSIZE * PGSIZE) {
    45a2:	9952                	add	s2,s2,s4
    45a4:	fe9914e3          	bne	s2,s1,458c <lazy_unmap+0x40>
  exit(0);
    45a8:	4501                	li	a0,0
    45aa:	153000ef          	jal	4efc <exit>
    45ae:	f426                	sd	s1,40(sp)
    45b0:	f04a                	sd	s2,32(sp)
    45b2:	ec4e                	sd	s3,24(sp)
    45b4:	e852                	sd	s4,16(sp)
    printf("sbrklazy() failed\n");
    45b6:	00003517          	auipc	a0,0x3
    45ba:	dea50513          	addi	a0,a0,-534 # 73a0 <malloc+0x1f9e>
    45be:	58d000ef          	jal	534a <printf>
    exit(1);
    45c2:	4505                	li	a0,1
    45c4:	139000ef          	jal	4efc <exit>
      printf("error forking\n");
    45c8:	00003517          	auipc	a0,0x3
    45cc:	e1850513          	addi	a0,a0,-488 # 73e0 <malloc+0x1fde>
    45d0:	57b000ef          	jal	534a <printf>
      exit(1);
    45d4:	4505                	li	a0,1
    45d6:	127000ef          	jal	4efc <exit>
      sbrklazy(-1L * REGION_SZ);
    45da:	c0000537          	lui	a0,0xc0000
    45de:	101000ef          	jal	4ede <sbrklazy>
      *(char **)i = i;
    45e2:	01293023          	sd	s2,0(s2) # 1000 <bigdir+0x108>
      exit(0);
    45e6:	4501                	li	a0,0
    45e8:	115000ef          	jal	4efc <exit>
        printf("memory not unmapped\n");
    45ec:	00003517          	auipc	a0,0x3
    45f0:	e0450513          	addi	a0,a0,-508 # 73f0 <malloc+0x1fee>
    45f4:	557000ef          	jal	534a <printf>
        exit(1);
    45f8:	4505                	li	a0,1
    45fa:	103000ef          	jal	4efc <exit>

00000000000045fe <lazy_copy>:
{
    45fe:	7119                	addi	sp,sp,-128
    4600:	fc86                	sd	ra,120(sp)
    4602:	f8a2                	sd	s0,112(sp)
    4604:	f4a6                	sd	s1,104(sp)
    4606:	f0ca                	sd	s2,96(sp)
    4608:	ecce                	sd	s3,88(sp)
    460a:	e8d2                	sd	s4,80(sp)
    460c:	e4d6                	sd	s5,72(sp)
    460e:	e0da                	sd	s6,64(sp)
    4610:	fc5e                	sd	s7,56(sp)
    4612:	0100                	addi	s0,sp,128
    char *p = sbrk(0);
    4614:	4501                	li	a0,0
    4616:	0b3000ef          	jal	4ec8 <sbrk>
    461a:	84aa                	mv	s1,a0
    sbrklazy(4*PGSIZE);
    461c:	6511                	lui	a0,0x4
    461e:	0c1000ef          	jal	4ede <sbrklazy>
    open(p + 8192, 0);
    4622:	4581                	li	a1,0
    4624:	6509                	lui	a0,0x2
    4626:	9526                	add	a0,a0,s1
    4628:	115000ef          	jal	4f3c <open>
    void *xx = sbrk(0);
    462c:	4501                	li	a0,0
    462e:	09b000ef          	jal	4ec8 <sbrk>
    4632:	84aa                	mv	s1,a0
    void *ret = sbrk(-(((uint64) xx)+1));
    4634:	fff54513          	not	a0,a0
    4638:	2501                	sext.w	a0,a0
    463a:	08f000ef          	jal	4ec8 <sbrk>
    if(ret != xx){
    463e:	00a48c63          	beq	s1,a0,4656 <lazy_copy+0x58>
    4642:	85aa                	mv	a1,a0
      printf("sbrk(sbrk(0)+1) returned %p, not old sz\n", ret);
    4644:	00003517          	auipc	a0,0x3
    4648:	dc450513          	addi	a0,a0,-572 # 7408 <malloc+0x2006>
    464c:	4ff000ef          	jal	534a <printf>
      exit(1);
    4650:	4505                	li	a0,1
    4652:	0ab000ef          	jal	4efc <exit>
  unsigned long bad[] = {
    4656:	00003797          	auipc	a5,0x3
    465a:	33278793          	addi	a5,a5,818 # 7988 <malloc+0x2586>
    465e:	7fa8                	ld	a0,120(a5)
    4660:	63cc                	ld	a1,128(a5)
    4662:	67d0                	ld	a2,136(a5)
    4664:	6bd4                	ld	a3,144(a5)
    4666:	6fd8                	ld	a4,152(a5)
    4668:	f8a43023          	sd	a0,-128(s0)
    466c:	f8b43423          	sd	a1,-120(s0)
    4670:	f8c43823          	sd	a2,-112(s0)
    4674:	f8d43c23          	sd	a3,-104(s0)
    4678:	fae43023          	sd	a4,-96(s0)
    467c:	73dc                	ld	a5,160(a5)
    467e:	faf43423          	sd	a5,-88(s0)
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    4682:	f8040913          	addi	s2,s0,-128
    int fd = open("README", 0);
    4686:	00001a97          	auipc	s5,0x1
    468a:	08aa8a93          	addi	s5,s5,138 # 5710 <malloc+0x30e>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    468e:	20000a13          	li	s4,512
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    4692:	60200b93          	li	s7,1538
    4696:	00001b17          	auipc	s6,0x1
    469a:	f8ab0b13          	addi	s6,s6,-118 # 5620 <malloc+0x21e>
    int fd = open("README", 0);
    469e:	4581                	li	a1,0
    46a0:	8556                	mv	a0,s5
    46a2:	09b000ef          	jal	4f3c <open>
    46a6:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    46a8:	04054563          	bltz	a0,46f2 <lazy_copy+0xf4>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    46ac:	00093983          	ld	s3,0(s2)
    46b0:	8652                	mv	a2,s4
    46b2:	85ce                	mv	a1,s3
    46b4:	061000ef          	jal	4f14 <read>
    46b8:	04055663          	bgez	a0,4704 <lazy_copy+0x106>
    close(fd);
    46bc:	8526                	mv	a0,s1
    46be:	067000ef          	jal	4f24 <close>
    fd = open("junk", O_CREATE|O_RDWR|O_TRUNC);
    46c2:	85de                	mv	a1,s7
    46c4:	855a                	mv	a0,s6
    46c6:	077000ef          	jal	4f3c <open>
    46ca:	84aa                	mv	s1,a0
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    46cc:	04054563          	bltz	a0,4716 <lazy_copy+0x118>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    46d0:	8652                	mv	a2,s4
    46d2:	85ce                	mv	a1,s3
    46d4:	049000ef          	jal	4f1c <write>
    46d8:	04055863          	bgez	a0,4728 <lazy_copy+0x12a>
    close(fd);
    46dc:	8526                	mv	a0,s1
    46de:	047000ef          	jal	4f24 <close>
  for(int i = 0; i < sizeof(bad)/sizeof(bad[0]); i++){
    46e2:	0921                	addi	s2,s2,8
    46e4:	fb040793          	addi	a5,s0,-80
    46e8:	faf91be3          	bne	s2,a5,469e <lazy_copy+0xa0>
  exit(0);
    46ec:	4501                	li	a0,0
    46ee:	00f000ef          	jal	4efc <exit>
    if(fd < 0) { printf("cannot open README\n"); exit(1); }
    46f2:	00003517          	auipc	a0,0x3
    46f6:	d4650513          	addi	a0,a0,-698 # 7438 <malloc+0x2036>
    46fa:	451000ef          	jal	534a <printf>
    46fe:	4505                	li	a0,1
    4700:	7fc000ef          	jal	4efc <exit>
    if(read(fd, (char*)bad[i], 512) >= 0) { printf("read succeeded\n");  exit(1); }
    4704:	00003517          	auipc	a0,0x3
    4708:	d4c50513          	addi	a0,a0,-692 # 7450 <malloc+0x204e>
    470c:	43f000ef          	jal	534a <printf>
    4710:	4505                	li	a0,1
    4712:	7ea000ef          	jal	4efc <exit>
    if(fd < 0) { printf("cannot open junk\n"); exit(1); }
    4716:	00003517          	auipc	a0,0x3
    471a:	d4a50513          	addi	a0,a0,-694 # 7460 <malloc+0x205e>
    471e:	42d000ef          	jal	534a <printf>
    4722:	4505                	li	a0,1
    4724:	7d8000ef          	jal	4efc <exit>
    if(write(fd, (char*)bad[i], 512) >= 0) { printf("write succeeded\n"); exit(1); }
    4728:	00003517          	auipc	a0,0x3
    472c:	d5050513          	addi	a0,a0,-688 # 7478 <malloc+0x2076>
    4730:	41b000ef          	jal	534a <printf>
    4734:	4505                	li	a0,1
    4736:	7c6000ef          	jal	4efc <exit>

000000000000473a <fsfull>:
{
    473a:	7171                	addi	sp,sp,-176
    473c:	f506                	sd	ra,168(sp)
    473e:	f122                	sd	s0,160(sp)
    4740:	ed26                	sd	s1,152(sp)
    4742:	e94a                	sd	s2,144(sp)
    4744:	e54e                	sd	s3,136(sp)
    4746:	e152                	sd	s4,128(sp)
    4748:	fcd6                	sd	s5,120(sp)
    474a:	f8da                	sd	s6,112(sp)
    474c:	f4de                	sd	s7,104(sp)
    474e:	f0e2                	sd	s8,96(sp)
    4750:	ece6                	sd	s9,88(sp)
    4752:	e8ea                	sd	s10,80(sp)
    4754:	e4ee                	sd	s11,72(sp)
    4756:	1900                	addi	s0,sp,176
  printf("fsfull test\n");
    4758:	00003517          	auipc	a0,0x3
    475c:	d3850513          	addi	a0,a0,-712 # 7490 <malloc+0x208e>
    4760:	3eb000ef          	jal	534a <printf>
  for(nfiles = 0; ; nfiles++){
    4764:	4481                	li	s1,0
    name[0] = 'f';
    4766:	06600d93          	li	s11,102
    name[1] = '0' + nfiles / 1000;
    476a:	10625cb7          	lui	s9,0x10625
    476e:	dd3c8c93          	addi	s9,s9,-557 # 10624dd3 <base+0x1061612b>
    name[2] = '0' + (nfiles % 1000) / 100;
    4772:	51eb8ab7          	lui	s5,0x51eb8
    4776:	51fa8a93          	addi	s5,s5,1311 # 51eb851f <base+0x51ea9877>
    name[3] = '0' + (nfiles % 100) / 10;
    477a:	66666a37          	lui	s4,0x66666
    477e:	667a0a13          	addi	s4,s4,1639 # 66666667 <base+0x666579bf>
    printf("writing %s\n", name);
    4782:	f5040d13          	addi	s10,s0,-176
    name[0] = 'f';
    4786:	f5b40823          	sb	s11,-176(s0)
    name[1] = '0' + nfiles / 1000;
    478a:	039487b3          	mul	a5,s1,s9
    478e:	9799                	srai	a5,a5,0x26
    4790:	41f4d69b          	sraiw	a3,s1,0x1f
    4794:	9f95                	subw	a5,a5,a3
    4796:	0307871b          	addiw	a4,a5,48
    479a:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    479e:	3e800713          	li	a4,1000
    47a2:	02f707bb          	mulw	a5,a4,a5
    47a6:	40f487bb          	subw	a5,s1,a5
    47aa:	03578733          	mul	a4,a5,s5
    47ae:	9715                	srai	a4,a4,0x25
    47b0:	41f7d79b          	sraiw	a5,a5,0x1f
    47b4:	40f707bb          	subw	a5,a4,a5
    47b8:	0307879b          	addiw	a5,a5,48
    47bc:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    47c0:	035487b3          	mul	a5,s1,s5
    47c4:	9795                	srai	a5,a5,0x25
    47c6:	9f95                	subw	a5,a5,a3
    47c8:	06400713          	li	a4,100
    47cc:	02f707bb          	mulw	a5,a4,a5
    47d0:	40f487bb          	subw	a5,s1,a5
    47d4:	03478733          	mul	a4,a5,s4
    47d8:	9709                	srai	a4,a4,0x22
    47da:	41f7d79b          	sraiw	a5,a5,0x1f
    47de:	40f707bb          	subw	a5,a4,a5
    47e2:	0307879b          	addiw	a5,a5,48
    47e6:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    47ea:	03448733          	mul	a4,s1,s4
    47ee:	9709                	srai	a4,a4,0x22
    47f0:	9f15                	subw	a4,a4,a3
    47f2:	0027179b          	slliw	a5,a4,0x2
    47f6:	9fb9                	addw	a5,a5,a4
    47f8:	0017979b          	slliw	a5,a5,0x1
    47fc:	40f487bb          	subw	a5,s1,a5
    4800:	0307879b          	addiw	a5,a5,48
    4804:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    4808:	f4040aa3          	sb	zero,-171(s0)
    printf("writing %s\n", name);
    480c:	85ea                	mv	a1,s10
    480e:	00003517          	auipc	a0,0x3
    4812:	c9250513          	addi	a0,a0,-878 # 74a0 <malloc+0x209e>
    4816:	335000ef          	jal	534a <printf>
    int fd = open(name, O_CREATE|O_RDWR);
    481a:	20200593          	li	a1,514
    481e:	856a                	mv	a0,s10
    4820:	71c000ef          	jal	4f3c <open>
    4824:	892a                	mv	s2,a0
    if(fd < 0){
    4826:	0e055b63          	bgez	a0,491c <fsfull+0x1e2>
      printf("open %s failed\n", name);
    482a:	f5040593          	addi	a1,s0,-176
    482e:	00003517          	auipc	a0,0x3
    4832:	c8250513          	addi	a0,a0,-894 # 74b0 <malloc+0x20ae>
    4836:	315000ef          	jal	534a <printf>
  while(nfiles >= 0){
    483a:	0a04cc63          	bltz	s1,48f2 <fsfull+0x1b8>
    name[0] = 'f';
    483e:	06600c13          	li	s8,102
    name[1] = '0' + nfiles / 1000;
    4842:	10625a37          	lui	s4,0x10625
    4846:	dd3a0a13          	addi	s4,s4,-557 # 10624dd3 <base+0x1061612b>
    name[2] = '0' + (nfiles % 1000) / 100;
    484a:	3e800b93          	li	s7,1000
    484e:	51eb89b7          	lui	s3,0x51eb8
    4852:	51f98993          	addi	s3,s3,1311 # 51eb851f <base+0x51ea9877>
    name[3] = '0' + (nfiles % 100) / 10;
    4856:	06400b13          	li	s6,100
    485a:	66666937          	lui	s2,0x66666
    485e:	66790913          	addi	s2,s2,1639 # 66666667 <base+0x666579bf>
    unlink(name);
    4862:	f5040a93          	addi	s5,s0,-176
    name[0] = 'f';
    4866:	f5840823          	sb	s8,-176(s0)
    name[1] = '0' + nfiles / 1000;
    486a:	034487b3          	mul	a5,s1,s4
    486e:	9799                	srai	a5,a5,0x26
    4870:	41f4d69b          	sraiw	a3,s1,0x1f
    4874:	9f95                	subw	a5,a5,a3
    4876:	0307871b          	addiw	a4,a5,48
    487a:	f4e408a3          	sb	a4,-175(s0)
    name[2] = '0' + (nfiles % 1000) / 100;
    487e:	02fb87bb          	mulw	a5,s7,a5
    4882:	40f487bb          	subw	a5,s1,a5
    4886:	03378733          	mul	a4,a5,s3
    488a:	9715                	srai	a4,a4,0x25
    488c:	41f7d79b          	sraiw	a5,a5,0x1f
    4890:	40f707bb          	subw	a5,a4,a5
    4894:	0307879b          	addiw	a5,a5,48
    4898:	f4f40923          	sb	a5,-174(s0)
    name[3] = '0' + (nfiles % 100) / 10;
    489c:	033487b3          	mul	a5,s1,s3
    48a0:	9795                	srai	a5,a5,0x25
    48a2:	9f95                	subw	a5,a5,a3
    48a4:	02fb07bb          	mulw	a5,s6,a5
    48a8:	40f487bb          	subw	a5,s1,a5
    48ac:	03278733          	mul	a4,a5,s2
    48b0:	9709                	srai	a4,a4,0x22
    48b2:	41f7d79b          	sraiw	a5,a5,0x1f
    48b6:	40f707bb          	subw	a5,a4,a5
    48ba:	0307879b          	addiw	a5,a5,48
    48be:	f4f409a3          	sb	a5,-173(s0)
    name[4] = '0' + (nfiles % 10);
    48c2:	03248733          	mul	a4,s1,s2
    48c6:	9709                	srai	a4,a4,0x22
    48c8:	9f15                	subw	a4,a4,a3
    48ca:	0027179b          	slliw	a5,a4,0x2
    48ce:	9fb9                	addw	a5,a5,a4
    48d0:	0017979b          	slliw	a5,a5,0x1
    48d4:	40f487bb          	subw	a5,s1,a5
    48d8:	0307879b          	addiw	a5,a5,48
    48dc:	f4f40a23          	sb	a5,-172(s0)
    name[5] = '\0';
    48e0:	f4040aa3          	sb	zero,-171(s0)
    unlink(name);
    48e4:	8556                	mv	a0,s5
    48e6:	666000ef          	jal	4f4c <unlink>
    nfiles--;
    48ea:	34fd                	addiw	s1,s1,-1
  while(nfiles >= 0){
    48ec:	57fd                	li	a5,-1
    48ee:	f6f49ce3          	bne	s1,a5,4866 <fsfull+0x12c>
  printf("fsfull test finished\n");
    48f2:	00003517          	auipc	a0,0x3
    48f6:	bde50513          	addi	a0,a0,-1058 # 74d0 <malloc+0x20ce>
    48fa:	251000ef          	jal	534a <printf>
}
    48fe:	70aa                	ld	ra,168(sp)
    4900:	740a                	ld	s0,160(sp)
    4902:	64ea                	ld	s1,152(sp)
    4904:	694a                	ld	s2,144(sp)
    4906:	69aa                	ld	s3,136(sp)
    4908:	6a0a                	ld	s4,128(sp)
    490a:	7ae6                	ld	s5,120(sp)
    490c:	7b46                	ld	s6,112(sp)
    490e:	7ba6                	ld	s7,104(sp)
    4910:	7c06                	ld	s8,96(sp)
    4912:	6ce6                	ld	s9,88(sp)
    4914:	6d46                	ld	s10,80(sp)
    4916:	6da6                	ld	s11,72(sp)
    4918:	614d                	addi	sp,sp,176
    491a:	8082                	ret
    int total = 0;
    491c:	4981                	li	s3,0
      int cc = write(fd, buf, BSIZE);
    491e:	40000c13          	li	s8,1024
    4922:	00007b97          	auipc	s7,0x7
    4926:	386b8b93          	addi	s7,s7,902 # bca8 <buf>
      if(cc < BSIZE)
    492a:	3ff00b13          	li	s6,1023
      int cc = write(fd, buf, BSIZE);
    492e:	8662                	mv	a2,s8
    4930:	85de                	mv	a1,s7
    4932:	854a                	mv	a0,s2
    4934:	5e8000ef          	jal	4f1c <write>
      if(cc < BSIZE)
    4938:	00ab5563          	bge	s6,a0,4942 <fsfull+0x208>
      total += cc;
    493c:	00a989bb          	addw	s3,s3,a0
    while(1){
    4940:	b7fd                	j	492e <fsfull+0x1f4>
    printf("wrote %d bytes\n", total);
    4942:	85ce                	mv	a1,s3
    4944:	00003517          	auipc	a0,0x3
    4948:	b7c50513          	addi	a0,a0,-1156 # 74c0 <malloc+0x20be>
    494c:	1ff000ef          	jal	534a <printf>
    close(fd);
    4950:	854a                	mv	a0,s2
    4952:	5d2000ef          	jal	4f24 <close>
    if(total == 0)
    4956:	ee0982e3          	beqz	s3,483a <fsfull+0x100>
  for(nfiles = 0; ; nfiles++){
    495a:	2485                	addiw	s1,s1,1
    495c:	b52d                	j	4786 <fsfull+0x4c>

000000000000495e <run>:
//

// run each test in its own process. run returns 1 if child's exit()
// indicates success.
int
run(void f(char *), char *s) {
    495e:	7179                	addi	sp,sp,-48
    4960:	f406                	sd	ra,40(sp)
    4962:	f022                	sd	s0,32(sp)
    4964:	ec26                	sd	s1,24(sp)
    4966:	e84a                	sd	s2,16(sp)
    4968:	1800                	addi	s0,sp,48
    496a:	84aa                	mv	s1,a0
    496c:	892e                	mv	s2,a1
  int pid;
  int xstatus;

  printf("test %s: ", s);
    496e:	00003517          	auipc	a0,0x3
    4972:	b7a50513          	addi	a0,a0,-1158 # 74e8 <malloc+0x20e6>
    4976:	1d5000ef          	jal	534a <printf>
  if((pid = fork()) < 0) {
    497a:	57a000ef          	jal	4ef4 <fork>
    497e:	02054a63          	bltz	a0,49b2 <run+0x54>
    printf("runtest: fork error\n");
    exit(1);
  }
  if(pid == 0) {
    4982:	c129                	beqz	a0,49c4 <run+0x66>
    f(s);
    exit(0);
  } else {
    wait(&xstatus);
    4984:	fdc40513          	addi	a0,s0,-36
    4988:	57c000ef          	jal	4f04 <wait>
    if(xstatus != 0) 
    498c:	fdc42783          	lw	a5,-36(s0)
    4990:	cf9d                	beqz	a5,49ce <run+0x70>
      printf("FAILED\n");
    4992:	00003517          	auipc	a0,0x3
    4996:	b7e50513          	addi	a0,a0,-1154 # 7510 <malloc+0x210e>
    499a:	1b1000ef          	jal	534a <printf>
    else
      printf("OK\n");
    return xstatus == 0;
    499e:	fdc42503          	lw	a0,-36(s0)
  }
}
    49a2:	00153513          	seqz	a0,a0
    49a6:	70a2                	ld	ra,40(sp)
    49a8:	7402                	ld	s0,32(sp)
    49aa:	64e2                	ld	s1,24(sp)
    49ac:	6942                	ld	s2,16(sp)
    49ae:	6145                	addi	sp,sp,48
    49b0:	8082                	ret
    printf("runtest: fork error\n");
    49b2:	00003517          	auipc	a0,0x3
    49b6:	b4650513          	addi	a0,a0,-1210 # 74f8 <malloc+0x20f6>
    49ba:	191000ef          	jal	534a <printf>
    exit(1);
    49be:	4505                	li	a0,1
    49c0:	53c000ef          	jal	4efc <exit>
    f(s);
    49c4:	854a                	mv	a0,s2
    49c6:	9482                	jalr	s1
    exit(0);
    49c8:	4501                	li	a0,0
    49ca:	532000ef          	jal	4efc <exit>
      printf("OK\n");
    49ce:	00003517          	auipc	a0,0x3
    49d2:	b4a50513          	addi	a0,a0,-1206 # 7518 <malloc+0x2116>
    49d6:	175000ef          	jal	534a <printf>
    49da:	b7d1                	j	499e <run+0x40>

00000000000049dc <runtests>:

int
runtests(struct test *tests, char *justone, int continuous) {
    49dc:	7179                	addi	sp,sp,-48
    49de:	f406                	sd	ra,40(sp)
    49e0:	f022                	sd	s0,32(sp)
    49e2:	ec26                	sd	s1,24(sp)
    49e4:	e44e                	sd	s3,8(sp)
    49e6:	1800                	addi	s0,sp,48
    49e8:	84aa                	mv	s1,a0
  int ntests = 0;
  for (struct test *t = tests; t->s != 0; t++) {
    49ea:	6508                	ld	a0,8(a0)
    49ec:	cd29                	beqz	a0,4a46 <runtests+0x6a>
    49ee:	e84a                	sd	s2,16(sp)
    49f0:	e052                	sd	s4,0(sp)
    49f2:	892e                	mv	s2,a1
    if((justone == 0) || strcmp(t->s, justone) == 0) {
      ntests++;
      if(!run(t->f, t->s)){
        if(continuous != 2){
    49f4:	1679                	addi	a2,a2,-2 # ffe <bigdir+0x106>
    49f6:	00c03a33          	snez	s4,a2
  int ntests = 0;
    49fa:	4981                	li	s3,0
    49fc:	a029                	j	4a06 <runtests+0x2a>
      ntests++;
    49fe:	2985                	addiw	s3,s3,1
  for (struct test *t = tests; t->s != 0; t++) {
    4a00:	04c1                	addi	s1,s1,16
    4a02:	6488                	ld	a0,8(s1)
    4a04:	c905                	beqz	a0,4a34 <runtests+0x58>
    if((justone == 0) || strcmp(t->s, justone) == 0) {
    4a06:	00090663          	beqz	s2,4a12 <runtests+0x36>
    4a0a:	85ca                	mv	a1,s2
    4a0c:	26a000ef          	jal	4c76 <strcmp>
    4a10:	f965                	bnez	a0,4a00 <runtests+0x24>
      if(!run(t->f, t->s)){
    4a12:	648c                	ld	a1,8(s1)
    4a14:	6088                	ld	a0,0(s1)
    4a16:	f49ff0ef          	jal	495e <run>
        if(continuous != 2){
    4a1a:	f175                	bnez	a0,49fe <runtests+0x22>
    4a1c:	fe0a01e3          	beqz	s4,49fe <runtests+0x22>
          printf("SOME TESTS FAILED\n");
    4a20:	00003517          	auipc	a0,0x3
    4a24:	b0050513          	addi	a0,a0,-1280 # 7520 <malloc+0x211e>
    4a28:	123000ef          	jal	534a <printf>
          return -1;
    4a2c:	59fd                	li	s3,-1
    4a2e:	6942                	ld	s2,16(sp)
    4a30:	6a02                	ld	s4,0(sp)
    4a32:	a019                	j	4a38 <runtests+0x5c>
    4a34:	6942                	ld	s2,16(sp)
    4a36:	6a02                	ld	s4,0(sp)
        }
      }
    }
  }
  return ntests;
}
    4a38:	854e                	mv	a0,s3
    4a3a:	70a2                	ld	ra,40(sp)
    4a3c:	7402                	ld	s0,32(sp)
    4a3e:	64e2                	ld	s1,24(sp)
    4a40:	69a2                	ld	s3,8(sp)
    4a42:	6145                	addi	sp,sp,48
    4a44:	8082                	ret
  return ntests;
    4a46:	4981                	li	s3,0
    4a48:	bfc5                	j	4a38 <runtests+0x5c>

0000000000004a4a <countfree>:


// use sbrk() to count how many free physical memory pages there are.
int
countfree()
{
    4a4a:	7179                	addi	sp,sp,-48
    4a4c:	f406                	sd	ra,40(sp)
    4a4e:	f022                	sd	s0,32(sp)
    4a50:	ec26                	sd	s1,24(sp)
    4a52:	e84a                	sd	s2,16(sp)
    4a54:	e44e                	sd	s3,8(sp)
    4a56:	e052                	sd	s4,0(sp)
    4a58:	1800                	addi	s0,sp,48
  int n = 0;
  uint64 sz0 = (uint64)sbrk(0);
    4a5a:	4501                	li	a0,0
    4a5c:	46c000ef          	jal	4ec8 <sbrk>
    4a60:	8a2a                	mv	s4,a0
  int n = 0;
    4a62:	4481                	li	s1,0
  while(1){
    char *a = sbrk(PGSIZE);
    4a64:	6985                	lui	s3,0x1
    if(a == SBRK_ERROR){
    4a66:	597d                	li	s2,-1
    char *a = sbrk(PGSIZE);
    4a68:	854e                	mv	a0,s3
    4a6a:	45e000ef          	jal	4ec8 <sbrk>
    if(a == SBRK_ERROR){
    4a6e:	01250463          	beq	a0,s2,4a76 <countfree+0x2c>
      break;
    }
    n += 1;
    4a72:	2485                	addiw	s1,s1,1
  while(1){
    4a74:	bfd5                	j	4a68 <countfree+0x1e>
  }
  sbrk(-((uint64)sbrk(0) - sz0));  
    4a76:	4501                	li	a0,0
    4a78:	450000ef          	jal	4ec8 <sbrk>
    4a7c:	40aa053b          	subw	a0,s4,a0
    4a80:	448000ef          	jal	4ec8 <sbrk>
  return n;
}
    4a84:	8526                	mv	a0,s1
    4a86:	70a2                	ld	ra,40(sp)
    4a88:	7402                	ld	s0,32(sp)
    4a8a:	64e2                	ld	s1,24(sp)
    4a8c:	6942                	ld	s2,16(sp)
    4a8e:	69a2                	ld	s3,8(sp)
    4a90:	6a02                	ld	s4,0(sp)
    4a92:	6145                	addi	sp,sp,48
    4a94:	8082                	ret

0000000000004a96 <drivetests>:

int
drivetests(int quick, int continuous, char *justone) {
    4a96:	7159                	addi	sp,sp,-112
    4a98:	f486                	sd	ra,104(sp)
    4a9a:	f0a2                	sd	s0,96(sp)
    4a9c:	eca6                	sd	s1,88(sp)
    4a9e:	e8ca                	sd	s2,80(sp)
    4aa0:	e4ce                	sd	s3,72(sp)
    4aa2:	e0d2                	sd	s4,64(sp)
    4aa4:	fc56                	sd	s5,56(sp)
    4aa6:	f85a                	sd	s6,48(sp)
    4aa8:	f45e                	sd	s7,40(sp)
    4aaa:	f062                	sd	s8,32(sp)
    4aac:	ec66                	sd	s9,24(sp)
    4aae:	e86a                	sd	s10,16(sp)
    4ab0:	e46e                	sd	s11,8(sp)
    4ab2:	1880                	addi	s0,sp,112
    4ab4:	8aaa                	mv	s5,a0
    4ab6:	89ae                	mv	s3,a1
    4ab8:	8a32                	mv	s4,a2
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
      if(continuous != 2) {
        return 1;
      }
    }
    if (justone != 0 && ntests == 0) {
    4aba:	00c03d33          	snez	s10,a2
    printf("usertests starting\n");
    4abe:	00003c17          	auipc	s8,0x3
    4ac2:	a7ac0c13          	addi	s8,s8,-1414 # 7538 <malloc+0x2136>
    n = runtests(quicktests, justone, continuous);
    4ac6:	00003b97          	auipc	s7,0x3
    4aca:	54ab8b93          	addi	s7,s7,1354 # 8010 <quicktests>
      if(continuous != 2) {
    4ace:	4b09                	li	s6,2
      n = runtests(slowtests, justone, continuous);
    4ad0:	00004c97          	auipc	s9,0x4
    4ad4:	940c8c93          	addi	s9,s9,-1728 # 8410 <slowtests>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4ad8:	00003d97          	auipc	s11,0x3
    4adc:	a98d8d93          	addi	s11,s11,-1384 # 7570 <malloc+0x216e>
    4ae0:	a82d                	j	4b1a <drivetests+0x84>
      if(continuous != 2) {
    4ae2:	0b699363          	bne	s3,s6,4b88 <drivetests+0xf2>
    int ntests = 0;
    4ae6:	4481                	li	s1,0
    4ae8:	a0b9                	j	4b36 <drivetests+0xa0>
        printf("usertests slow tests starting\n");
    4aea:	00003517          	auipc	a0,0x3
    4aee:	a6650513          	addi	a0,a0,-1434 # 7550 <malloc+0x214e>
    4af2:	059000ef          	jal	534a <printf>
    4af6:	a0a1                	j	4b3e <drivetests+0xa8>
        if(continuous != 2) {
    4af8:	05698b63          	beq	s3,s6,4b4e <drivetests+0xb8>
          return 1;
    4afc:	4505                	li	a0,1
    4afe:	a0b5                	j	4b6a <drivetests+0xd4>
      printf("FAILED -- lost some free pages %d (out of %d)\n", free1, free0);
    4b00:	864a                	mv	a2,s2
    4b02:	85aa                	mv	a1,a0
    4b04:	856e                	mv	a0,s11
    4b06:	045000ef          	jal	534a <printf>
      if(continuous != 2) {
    4b0a:	09699163          	bne	s3,s6,4b8c <drivetests+0xf6>
    if (justone != 0 && ntests == 0) {
    4b0e:	e491                	bnez	s1,4b1a <drivetests+0x84>
    4b10:	000d0563          	beqz	s10,4b1a <drivetests+0x84>
    4b14:	a0a1                	j	4b5c <drivetests+0xc6>
      printf("NO TESTS EXECUTED\n");
      return 1;
    }
  } while(continuous);
    4b16:	06098d63          	beqz	s3,4b90 <drivetests+0xfa>
    printf("usertests starting\n");
    4b1a:	8562                	mv	a0,s8
    4b1c:	02f000ef          	jal	534a <printf>
    int free0 = countfree();
    4b20:	f2bff0ef          	jal	4a4a <countfree>
    4b24:	892a                	mv	s2,a0
    n = runtests(quicktests, justone, continuous);
    4b26:	864e                	mv	a2,s3
    4b28:	85d2                	mv	a1,s4
    4b2a:	855e                	mv	a0,s7
    4b2c:	eb1ff0ef          	jal	49dc <runtests>
    4b30:	84aa                	mv	s1,a0
    if (n < 0) {
    4b32:	fa0548e3          	bltz	a0,4ae2 <drivetests+0x4c>
    if(!quick) {
    4b36:	000a9c63          	bnez	s5,4b4e <drivetests+0xb8>
      if (justone == 0)
    4b3a:	fa0a08e3          	beqz	s4,4aea <drivetests+0x54>
      n = runtests(slowtests, justone, continuous);
    4b3e:	864e                	mv	a2,s3
    4b40:	85d2                	mv	a1,s4
    4b42:	8566                	mv	a0,s9
    4b44:	e99ff0ef          	jal	49dc <runtests>
      if (n < 0) {
    4b48:	fa0548e3          	bltz	a0,4af8 <drivetests+0x62>
        ntests += n;
    4b4c:	9ca9                	addw	s1,s1,a0
    if((free1 = countfree()) < free0) {
    4b4e:	efdff0ef          	jal	4a4a <countfree>
    4b52:	fb2547e3          	blt	a0,s2,4b00 <drivetests+0x6a>
    if (justone != 0 && ntests == 0) {
    4b56:	f0e1                	bnez	s1,4b16 <drivetests+0x80>
    4b58:	fa0d0fe3          	beqz	s10,4b16 <drivetests+0x80>
      printf("NO TESTS EXECUTED\n");
    4b5c:	00003517          	auipc	a0,0x3
    4b60:	a4450513          	addi	a0,a0,-1468 # 75a0 <malloc+0x219e>
    4b64:	7e6000ef          	jal	534a <printf>
      return 1;
    4b68:	4505                	li	a0,1
  return 0;
}
    4b6a:	70a6                	ld	ra,104(sp)
    4b6c:	7406                	ld	s0,96(sp)
    4b6e:	64e6                	ld	s1,88(sp)
    4b70:	6946                	ld	s2,80(sp)
    4b72:	69a6                	ld	s3,72(sp)
    4b74:	6a06                	ld	s4,64(sp)
    4b76:	7ae2                	ld	s5,56(sp)
    4b78:	7b42                	ld	s6,48(sp)
    4b7a:	7ba2                	ld	s7,40(sp)
    4b7c:	7c02                	ld	s8,32(sp)
    4b7e:	6ce2                	ld	s9,24(sp)
    4b80:	6d42                	ld	s10,16(sp)
    4b82:	6da2                	ld	s11,8(sp)
    4b84:	6165                	addi	sp,sp,112
    4b86:	8082                	ret
        return 1;
    4b88:	4505                	li	a0,1
    4b8a:	b7c5                	j	4b6a <drivetests+0xd4>
        return 1;
    4b8c:	4505                	li	a0,1
    4b8e:	bff1                	j	4b6a <drivetests+0xd4>
  return 0;
    4b90:	854e                	mv	a0,s3
    4b92:	bfe1                	j	4b6a <drivetests+0xd4>

0000000000004b94 <main>:

int
main(int argc, char *argv[])
{
    4b94:	1101                	addi	sp,sp,-32
    4b96:	ec06                	sd	ra,24(sp)
    4b98:	e822                	sd	s0,16(sp)
    4b9a:	e426                	sd	s1,8(sp)
    4b9c:	e04a                	sd	s2,0(sp)
    4b9e:	1000                	addi	s0,sp,32
    4ba0:	84aa                	mv	s1,a0
  int continuous = 0;
  int quick = 0;
  char *justone = 0;

  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4ba2:	4789                	li	a5,2
    4ba4:	00f50e63          	beq	a0,a5,4bc0 <main+0x2c>
    continuous = 1;
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    continuous = 2;
  } else if(argc == 2 && argv[1][0] != '-'){
    justone = argv[1];
  } else if(argc > 1){
    4ba8:	4785                	li	a5,1
    4baa:	06a7c663          	blt	a5,a0,4c16 <main+0x82>
  char *justone = 0;
    4bae:	4601                	li	a2,0
  int quick = 0;
    4bb0:	4501                	li	a0,0
  int continuous = 0;
    4bb2:	4581                	li	a1,0
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    exit(1);
  }
  if (drivetests(quick, continuous, justone)) {
    4bb4:	ee3ff0ef          	jal	4a96 <drivetests>
    4bb8:	cd35                	beqz	a0,4c34 <main+0xa0>
    exit(1);
    4bba:	4505                	li	a0,1
    4bbc:	340000ef          	jal	4efc <exit>
    4bc0:	892e                	mv	s2,a1
  if(argc == 2 && strcmp(argv[1], "-q") == 0){
    4bc2:	00003597          	auipc	a1,0x3
    4bc6:	9f658593          	addi	a1,a1,-1546 # 75b8 <malloc+0x21b6>
    4bca:	00893503          	ld	a0,8(s2)
    4bce:	0a8000ef          	jal	4c76 <strcmp>
    4bd2:	85aa                	mv	a1,a0
    4bd4:	e501                	bnez	a0,4bdc <main+0x48>
  char *justone = 0;
    4bd6:	4601                	li	a2,0
    quick = 1;
    4bd8:	4505                	li	a0,1
    4bda:	bfe9                	j	4bb4 <main+0x20>
  } else if(argc == 2 && strcmp(argv[1], "-c") == 0){
    4bdc:	00003597          	auipc	a1,0x3
    4be0:	9e458593          	addi	a1,a1,-1564 # 75c0 <malloc+0x21be>
    4be4:	00893503          	ld	a0,8(s2)
    4be8:	08e000ef          	jal	4c76 <strcmp>
    4bec:	cd15                	beqz	a0,4c28 <main+0x94>
  } else if(argc == 2 && strcmp(argv[1], "-C") == 0){
    4bee:	00003597          	auipc	a1,0x3
    4bf2:	a2258593          	addi	a1,a1,-1502 # 7610 <malloc+0x220e>
    4bf6:	00893503          	ld	a0,8(s2)
    4bfa:	07c000ef          	jal	4c76 <strcmp>
    4bfe:	c905                	beqz	a0,4c2e <main+0x9a>
  } else if(argc == 2 && argv[1][0] != '-'){
    4c00:	00893603          	ld	a2,8(s2)
    4c04:	00064703          	lbu	a4,0(a2)
    4c08:	02d00793          	li	a5,45
    4c0c:	00f70563          	beq	a4,a5,4c16 <main+0x82>
  int quick = 0;
    4c10:	4501                	li	a0,0
  int continuous = 0;
    4c12:	4581                	li	a1,0
    4c14:	b745                	j	4bb4 <main+0x20>
    printf("Usage: usertests [-c] [-C] [-q] [testname]\n");
    4c16:	00003517          	auipc	a0,0x3
    4c1a:	9b250513          	addi	a0,a0,-1614 # 75c8 <malloc+0x21c6>
    4c1e:	72c000ef          	jal	534a <printf>
    exit(1);
    4c22:	4505                	li	a0,1
    4c24:	2d8000ef          	jal	4efc <exit>
  char *justone = 0;
    4c28:	4601                	li	a2,0
    continuous = 1;
    4c2a:	4585                	li	a1,1
    4c2c:	b761                	j	4bb4 <main+0x20>
    continuous = 2;
    4c2e:	85a6                	mv	a1,s1
  char *justone = 0;
    4c30:	4601                	li	a2,0
    4c32:	b749                	j	4bb4 <main+0x20>
  }
  printf("ALL TESTS PASSED\n");
    4c34:	00003517          	auipc	a0,0x3
    4c38:	9c450513          	addi	a0,a0,-1596 # 75f8 <malloc+0x21f6>
    4c3c:	70e000ef          	jal	534a <printf>
  exit(0);
    4c40:	4501                	li	a0,0
    4c42:	2ba000ef          	jal	4efc <exit>

0000000000004c46 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    4c46:	1141                	addi	sp,sp,-16
    4c48:	e406                	sd	ra,8(sp)
    4c4a:	e022                	sd	s0,0(sp)
    4c4c:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    4c4e:	f47ff0ef          	jal	4b94 <main>
  exit(r);
    4c52:	2aa000ef          	jal	4efc <exit>

0000000000004c56 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    4c56:	1141                	addi	sp,sp,-16
    4c58:	e406                	sd	ra,8(sp)
    4c5a:	e022                	sd	s0,0(sp)
    4c5c:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    4c5e:	87aa                	mv	a5,a0
    4c60:	0585                	addi	a1,a1,1
    4c62:	0785                	addi	a5,a5,1
    4c64:	fff5c703          	lbu	a4,-1(a1)
    4c68:	fee78fa3          	sb	a4,-1(a5)
    4c6c:	fb75                	bnez	a4,4c60 <strcpy+0xa>
    ;
  return os;
}
    4c6e:	60a2                	ld	ra,8(sp)
    4c70:	6402                	ld	s0,0(sp)
    4c72:	0141                	addi	sp,sp,16
    4c74:	8082                	ret

0000000000004c76 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    4c76:	1141                	addi	sp,sp,-16
    4c78:	e406                	sd	ra,8(sp)
    4c7a:	e022                	sd	s0,0(sp)
    4c7c:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    4c7e:	00054783          	lbu	a5,0(a0)
    4c82:	cb91                	beqz	a5,4c96 <strcmp+0x20>
    4c84:	0005c703          	lbu	a4,0(a1)
    4c88:	00f71763          	bne	a4,a5,4c96 <strcmp+0x20>
    p++, q++;
    4c8c:	0505                	addi	a0,a0,1
    4c8e:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    4c90:	00054783          	lbu	a5,0(a0)
    4c94:	fbe5                	bnez	a5,4c84 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    4c96:	0005c503          	lbu	a0,0(a1)
}
    4c9a:	40a7853b          	subw	a0,a5,a0
    4c9e:	60a2                	ld	ra,8(sp)
    4ca0:	6402                	ld	s0,0(sp)
    4ca2:	0141                	addi	sp,sp,16
    4ca4:	8082                	ret

0000000000004ca6 <strlen>:

uint
strlen(const char *s)
{
    4ca6:	1141                	addi	sp,sp,-16
    4ca8:	e406                	sd	ra,8(sp)
    4caa:	e022                	sd	s0,0(sp)
    4cac:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    4cae:	00054783          	lbu	a5,0(a0)
    4cb2:	cf91                	beqz	a5,4cce <strlen+0x28>
    4cb4:	00150793          	addi	a5,a0,1
    4cb8:	86be                	mv	a3,a5
    4cba:	0785                	addi	a5,a5,1
    4cbc:	fff7c703          	lbu	a4,-1(a5)
    4cc0:	ff65                	bnez	a4,4cb8 <strlen+0x12>
    4cc2:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    4cc6:	60a2                	ld	ra,8(sp)
    4cc8:	6402                	ld	s0,0(sp)
    4cca:	0141                	addi	sp,sp,16
    4ccc:	8082                	ret
  for(n = 0; s[n]; n++)
    4cce:	4501                	li	a0,0
    4cd0:	bfdd                	j	4cc6 <strlen+0x20>

0000000000004cd2 <memset>:

void*
memset(void *dst, int c, uint n)
{
    4cd2:	1141                	addi	sp,sp,-16
    4cd4:	e406                	sd	ra,8(sp)
    4cd6:	e022                	sd	s0,0(sp)
    4cd8:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    4cda:	ca19                	beqz	a2,4cf0 <memset+0x1e>
    4cdc:	87aa                	mv	a5,a0
    4cde:	1602                	slli	a2,a2,0x20
    4ce0:	9201                	srli	a2,a2,0x20
    4ce2:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    4ce6:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    4cea:	0785                	addi	a5,a5,1
    4cec:	fee79de3          	bne	a5,a4,4ce6 <memset+0x14>
  }
  return dst;
}
    4cf0:	60a2                	ld	ra,8(sp)
    4cf2:	6402                	ld	s0,0(sp)
    4cf4:	0141                	addi	sp,sp,16
    4cf6:	8082                	ret

0000000000004cf8 <strchr>:

char*
strchr(const char *s, char c)
{
    4cf8:	1141                	addi	sp,sp,-16
    4cfa:	e406                	sd	ra,8(sp)
    4cfc:	e022                	sd	s0,0(sp)
    4cfe:	0800                	addi	s0,sp,16
  for(; *s; s++)
    4d00:	00054783          	lbu	a5,0(a0)
    4d04:	cf81                	beqz	a5,4d1c <strchr+0x24>
    if(*s == c)
    4d06:	00f58763          	beq	a1,a5,4d14 <strchr+0x1c>
  for(; *s; s++)
    4d0a:	0505                	addi	a0,a0,1
    4d0c:	00054783          	lbu	a5,0(a0)
    4d10:	fbfd                	bnez	a5,4d06 <strchr+0xe>
      return (char*)s;
  return 0;
    4d12:	4501                	li	a0,0
}
    4d14:	60a2                	ld	ra,8(sp)
    4d16:	6402                	ld	s0,0(sp)
    4d18:	0141                	addi	sp,sp,16
    4d1a:	8082                	ret
  return 0;
    4d1c:	4501                	li	a0,0
    4d1e:	bfdd                	j	4d14 <strchr+0x1c>

0000000000004d20 <gets>:

char*
gets(char *buf, int max)
{
    4d20:	711d                	addi	sp,sp,-96
    4d22:	ec86                	sd	ra,88(sp)
    4d24:	e8a2                	sd	s0,80(sp)
    4d26:	e4a6                	sd	s1,72(sp)
    4d28:	e0ca                	sd	s2,64(sp)
    4d2a:	fc4e                	sd	s3,56(sp)
    4d2c:	f852                	sd	s4,48(sp)
    4d2e:	f456                	sd	s5,40(sp)
    4d30:	f05a                	sd	s6,32(sp)
    4d32:	ec5e                	sd	s7,24(sp)
    4d34:	e862                	sd	s8,16(sp)
    4d36:	1080                	addi	s0,sp,96
    4d38:	8baa                	mv	s7,a0
    4d3a:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    4d3c:	892a                	mv	s2,a0
    4d3e:	4481                	li	s1,0
    cc = read(0, &c, 1);
    4d40:	faf40b13          	addi	s6,s0,-81
    4d44:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
    4d46:	8c26                	mv	s8,s1
    4d48:	0014899b          	addiw	s3,s1,1
    4d4c:	84ce                	mv	s1,s3
    4d4e:	0349d463          	bge	s3,s4,4d76 <gets+0x56>
    cc = read(0, &c, 1);
    4d52:	8656                	mv	a2,s5
    4d54:	85da                	mv	a1,s6
    4d56:	4501                	li	a0,0
    4d58:	1bc000ef          	jal	4f14 <read>
    if(cc < 1)
    4d5c:	00a05d63          	blez	a0,4d76 <gets+0x56>
      break;
    buf[i++] = c;
    4d60:	faf44783          	lbu	a5,-81(s0)
    4d64:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
    4d68:	0905                	addi	s2,s2,1
    4d6a:	ff678713          	addi	a4,a5,-10
    4d6e:	c319                	beqz	a4,4d74 <gets+0x54>
    4d70:	17cd                	addi	a5,a5,-13
    4d72:	fbf1                	bnez	a5,4d46 <gets+0x26>
    buf[i++] = c;
    4d74:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    4d76:	9c5e                	add	s8,s8,s7
    4d78:	000c0023          	sb	zero,0(s8)
  return buf;
}
    4d7c:	855e                	mv	a0,s7
    4d7e:	60e6                	ld	ra,88(sp)
    4d80:	6446                	ld	s0,80(sp)
    4d82:	64a6                	ld	s1,72(sp)
    4d84:	6906                	ld	s2,64(sp)
    4d86:	79e2                	ld	s3,56(sp)
    4d88:	7a42                	ld	s4,48(sp)
    4d8a:	7aa2                	ld	s5,40(sp)
    4d8c:	7b02                	ld	s6,32(sp)
    4d8e:	6be2                	ld	s7,24(sp)
    4d90:	6c42                	ld	s8,16(sp)
    4d92:	6125                	addi	sp,sp,96
    4d94:	8082                	ret

0000000000004d96 <stat>:

int
stat(const char *n, struct stat *st)
{
    4d96:	1101                	addi	sp,sp,-32
    4d98:	ec06                	sd	ra,24(sp)
    4d9a:	e822                	sd	s0,16(sp)
    4d9c:	e04a                	sd	s2,0(sp)
    4d9e:	1000                	addi	s0,sp,32
    4da0:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    4da2:	4581                	li	a1,0
    4da4:	198000ef          	jal	4f3c <open>
  if(fd < 0)
    4da8:	02054263          	bltz	a0,4dcc <stat+0x36>
    4dac:	e426                	sd	s1,8(sp)
    4dae:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    4db0:	85ca                	mv	a1,s2
    4db2:	1a2000ef          	jal	4f54 <fstat>
    4db6:	892a                	mv	s2,a0
  close(fd);
    4db8:	8526                	mv	a0,s1
    4dba:	16a000ef          	jal	4f24 <close>
  return r;
    4dbe:	64a2                	ld	s1,8(sp)
}
    4dc0:	854a                	mv	a0,s2
    4dc2:	60e2                	ld	ra,24(sp)
    4dc4:	6442                	ld	s0,16(sp)
    4dc6:	6902                	ld	s2,0(sp)
    4dc8:	6105                	addi	sp,sp,32
    4dca:	8082                	ret
    return -1;
    4dcc:	57fd                	li	a5,-1
    4dce:	893e                	mv	s2,a5
    4dd0:	bfc5                	j	4dc0 <stat+0x2a>

0000000000004dd2 <atoi>:

int
atoi(const char *s)
{
    4dd2:	1141                	addi	sp,sp,-16
    4dd4:	e406                	sd	ra,8(sp)
    4dd6:	e022                	sd	s0,0(sp)
    4dd8:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    4dda:	00054683          	lbu	a3,0(a0)
    4dde:	fd06879b          	addiw	a5,a3,-48 # 3ffd0 <base+0x31328>
    4de2:	0ff7f793          	zext.b	a5,a5
    4de6:	4625                	li	a2,9
    4de8:	02f66963          	bltu	a2,a5,4e1a <atoi+0x48>
    4dec:	872a                	mv	a4,a0
  n = 0;
    4dee:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    4df0:	0705                	addi	a4,a4,1 # 1000001 <base+0xff1359>
    4df2:	0025179b          	slliw	a5,a0,0x2
    4df6:	9fa9                	addw	a5,a5,a0
    4df8:	0017979b          	slliw	a5,a5,0x1
    4dfc:	9fb5                	addw	a5,a5,a3
    4dfe:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    4e02:	00074683          	lbu	a3,0(a4)
    4e06:	fd06879b          	addiw	a5,a3,-48
    4e0a:	0ff7f793          	zext.b	a5,a5
    4e0e:	fef671e3          	bgeu	a2,a5,4df0 <atoi+0x1e>
  return n;
}
    4e12:	60a2                	ld	ra,8(sp)
    4e14:	6402                	ld	s0,0(sp)
    4e16:	0141                	addi	sp,sp,16
    4e18:	8082                	ret
  n = 0;
    4e1a:	4501                	li	a0,0
    4e1c:	bfdd                	j	4e12 <atoi+0x40>

0000000000004e1e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    4e1e:	1141                	addi	sp,sp,-16
    4e20:	e406                	sd	ra,8(sp)
    4e22:	e022                	sd	s0,0(sp)
    4e24:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    4e26:	02b57563          	bgeu	a0,a1,4e50 <memmove+0x32>
    while(n-- > 0)
    4e2a:	00c05f63          	blez	a2,4e48 <memmove+0x2a>
    4e2e:	1602                	slli	a2,a2,0x20
    4e30:	9201                	srli	a2,a2,0x20
    4e32:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    4e36:	872a                	mv	a4,a0
      *dst++ = *src++;
    4e38:	0585                	addi	a1,a1,1
    4e3a:	0705                	addi	a4,a4,1
    4e3c:	fff5c683          	lbu	a3,-1(a1)
    4e40:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    4e44:	fee79ae3          	bne	a5,a4,4e38 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    4e48:	60a2                	ld	ra,8(sp)
    4e4a:	6402                	ld	s0,0(sp)
    4e4c:	0141                	addi	sp,sp,16
    4e4e:	8082                	ret
    while(n-- > 0)
    4e50:	fec05ce3          	blez	a2,4e48 <memmove+0x2a>
    dst += n;
    4e54:	00c50733          	add	a4,a0,a2
    src += n;
    4e58:	95b2                	add	a1,a1,a2
    4e5a:	fff6079b          	addiw	a5,a2,-1
    4e5e:	1782                	slli	a5,a5,0x20
    4e60:	9381                	srli	a5,a5,0x20
    4e62:	fff7c793          	not	a5,a5
    4e66:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    4e68:	15fd                	addi	a1,a1,-1
    4e6a:	177d                	addi	a4,a4,-1
    4e6c:	0005c683          	lbu	a3,0(a1)
    4e70:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    4e74:	fef71ae3          	bne	a4,a5,4e68 <memmove+0x4a>
    4e78:	bfc1                	j	4e48 <memmove+0x2a>

0000000000004e7a <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    4e7a:	1141                	addi	sp,sp,-16
    4e7c:	e406                	sd	ra,8(sp)
    4e7e:	e022                	sd	s0,0(sp)
    4e80:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    4e82:	c61d                	beqz	a2,4eb0 <memcmp+0x36>
    4e84:	1602                	slli	a2,a2,0x20
    4e86:	9201                	srli	a2,a2,0x20
    4e88:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    4e8c:	00054783          	lbu	a5,0(a0)
    4e90:	0005c703          	lbu	a4,0(a1)
    4e94:	00e79863          	bne	a5,a4,4ea4 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    4e98:	0505                	addi	a0,a0,1
    p2++;
    4e9a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    4e9c:	fed518e3          	bne	a0,a3,4e8c <memcmp+0x12>
  }
  return 0;
    4ea0:	4501                	li	a0,0
    4ea2:	a019                	j	4ea8 <memcmp+0x2e>
      return *p1 - *p2;
    4ea4:	40e7853b          	subw	a0,a5,a4
}
    4ea8:	60a2                	ld	ra,8(sp)
    4eaa:	6402                	ld	s0,0(sp)
    4eac:	0141                	addi	sp,sp,16
    4eae:	8082                	ret
  return 0;
    4eb0:	4501                	li	a0,0
    4eb2:	bfdd                	j	4ea8 <memcmp+0x2e>

0000000000004eb4 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    4eb4:	1141                	addi	sp,sp,-16
    4eb6:	e406                	sd	ra,8(sp)
    4eb8:	e022                	sd	s0,0(sp)
    4eba:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    4ebc:	f63ff0ef          	jal	4e1e <memmove>
}
    4ec0:	60a2                	ld	ra,8(sp)
    4ec2:	6402                	ld	s0,0(sp)
    4ec4:	0141                	addi	sp,sp,16
    4ec6:	8082                	ret

0000000000004ec8 <sbrk>:

char *
sbrk(int n) {
    4ec8:	1141                	addi	sp,sp,-16
    4eca:	e406                	sd	ra,8(sp)
    4ecc:	e022                	sd	s0,0(sp)
    4ece:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    4ed0:	4585                	li	a1,1
    4ed2:	0b2000ef          	jal	4f84 <sys_sbrk>
}
    4ed6:	60a2                	ld	ra,8(sp)
    4ed8:	6402                	ld	s0,0(sp)
    4eda:	0141                	addi	sp,sp,16
    4edc:	8082                	ret

0000000000004ede <sbrklazy>:

char *
sbrklazy(int n) {
    4ede:	1141                	addi	sp,sp,-16
    4ee0:	e406                	sd	ra,8(sp)
    4ee2:	e022                	sd	s0,0(sp)
    4ee4:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    4ee6:	4589                	li	a1,2
    4ee8:	09c000ef          	jal	4f84 <sys_sbrk>
}
    4eec:	60a2                	ld	ra,8(sp)
    4eee:	6402                	ld	s0,0(sp)
    4ef0:	0141                	addi	sp,sp,16
    4ef2:	8082                	ret

0000000000004ef4 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    4ef4:	4885                	li	a7,1
 ecall
    4ef6:	00000073          	ecall
 ret
    4efa:	8082                	ret

0000000000004efc <exit>:
.global exit
exit:
 li a7, SYS_exit
    4efc:	4889                	li	a7,2
 ecall
    4efe:	00000073          	ecall
 ret
    4f02:	8082                	ret

0000000000004f04 <wait>:
.global wait
wait:
 li a7, SYS_wait
    4f04:	488d                	li	a7,3
 ecall
    4f06:	00000073          	ecall
 ret
    4f0a:	8082                	ret

0000000000004f0c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    4f0c:	4891                	li	a7,4
 ecall
    4f0e:	00000073          	ecall
 ret
    4f12:	8082                	ret

0000000000004f14 <read>:
.global read
read:
 li a7, SYS_read
    4f14:	4895                	li	a7,5
 ecall
    4f16:	00000073          	ecall
 ret
    4f1a:	8082                	ret

0000000000004f1c <write>:
.global write
write:
 li a7, SYS_write
    4f1c:	48c1                	li	a7,16
 ecall
    4f1e:	00000073          	ecall
 ret
    4f22:	8082                	ret

0000000000004f24 <close>:
.global close
close:
 li a7, SYS_close
    4f24:	48d5                	li	a7,21
 ecall
    4f26:	00000073          	ecall
 ret
    4f2a:	8082                	ret

0000000000004f2c <kill>:
.global kill
kill:
 li a7, SYS_kill
    4f2c:	4899                	li	a7,6
 ecall
    4f2e:	00000073          	ecall
 ret
    4f32:	8082                	ret

0000000000004f34 <exec>:
.global exec
exec:
 li a7, SYS_exec
    4f34:	489d                	li	a7,7
 ecall
    4f36:	00000073          	ecall
 ret
    4f3a:	8082                	ret

0000000000004f3c <open>:
.global open
open:
 li a7, SYS_open
    4f3c:	48bd                	li	a7,15
 ecall
    4f3e:	00000073          	ecall
 ret
    4f42:	8082                	ret

0000000000004f44 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    4f44:	48c5                	li	a7,17
 ecall
    4f46:	00000073          	ecall
 ret
    4f4a:	8082                	ret

0000000000004f4c <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    4f4c:	48c9                	li	a7,18
 ecall
    4f4e:	00000073          	ecall
 ret
    4f52:	8082                	ret

0000000000004f54 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    4f54:	48a1                	li	a7,8
 ecall
    4f56:	00000073          	ecall
 ret
    4f5a:	8082                	ret

0000000000004f5c <link>:
.global link
link:
 li a7, SYS_link
    4f5c:	48cd                	li	a7,19
 ecall
    4f5e:	00000073          	ecall
 ret
    4f62:	8082                	ret

0000000000004f64 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    4f64:	48d1                	li	a7,20
 ecall
    4f66:	00000073          	ecall
 ret
    4f6a:	8082                	ret

0000000000004f6c <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    4f6c:	48a5                	li	a7,9
 ecall
    4f6e:	00000073          	ecall
 ret
    4f72:	8082                	ret

0000000000004f74 <dup>:
.global dup
dup:
 li a7, SYS_dup
    4f74:	48a9                	li	a7,10
 ecall
    4f76:	00000073          	ecall
 ret
    4f7a:	8082                	ret

0000000000004f7c <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    4f7c:	48ad                	li	a7,11
 ecall
    4f7e:	00000073          	ecall
 ret
    4f82:	8082                	ret

0000000000004f84 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    4f84:	48b1                	li	a7,12
 ecall
    4f86:	00000073          	ecall
 ret
    4f8a:	8082                	ret

0000000000004f8c <pause>:
.global pause
pause:
 li a7, SYS_pause
    4f8c:	48b5                	li	a7,13
 ecall
    4f8e:	00000073          	ecall
 ret
    4f92:	8082                	ret

0000000000004f94 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    4f94:	48b9                	li	a7,14
 ecall
    4f96:	00000073          	ecall
 ret
    4f9a:	8082                	ret

0000000000004f9c <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
    4f9c:	48d9                	li	a7,22
 ecall
    4f9e:	00000073          	ecall
 ret
    4fa2:	8082                	ret

0000000000004fa4 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    4fa4:	1101                	addi	sp,sp,-32
    4fa6:	ec06                	sd	ra,24(sp)
    4fa8:	e822                	sd	s0,16(sp)
    4faa:	1000                	addi	s0,sp,32
    4fac:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    4fb0:	4605                	li	a2,1
    4fb2:	fef40593          	addi	a1,s0,-17
    4fb6:	f67ff0ef          	jal	4f1c <write>
}
    4fba:	60e2                	ld	ra,24(sp)
    4fbc:	6442                	ld	s0,16(sp)
    4fbe:	6105                	addi	sp,sp,32
    4fc0:	8082                	ret

0000000000004fc2 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    4fc2:	715d                	addi	sp,sp,-80
    4fc4:	e486                	sd	ra,72(sp)
    4fc6:	e0a2                	sd	s0,64(sp)
    4fc8:	f84a                	sd	s2,48(sp)
    4fca:	f44e                	sd	s3,40(sp)
    4fcc:	0880                	addi	s0,sp,80
    4fce:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    4fd0:	c6d1                	beqz	a3,505c <printint+0x9a>
    4fd2:	0805d563          	bgez	a1,505c <printint+0x9a>
    neg = 1;
    x = -xx;
    4fd6:	40b005b3          	neg	a1,a1
    neg = 1;
    4fda:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    4fdc:	fb840993          	addi	s3,s0,-72
  neg = 0;
    4fe0:	86ce                	mv	a3,s3
  i = 0;
    4fe2:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    4fe4:	00003817          	auipc	a6,0x3
    4fe8:	a4c80813          	addi	a6,a6,-1460 # 7a30 <digits>
    4fec:	88ba                	mv	a7,a4
    4fee:	0017051b          	addiw	a0,a4,1
    4ff2:	872a                	mv	a4,a0
    4ff4:	02c5f7b3          	remu	a5,a1,a2
    4ff8:	97c2                	add	a5,a5,a6
    4ffa:	0007c783          	lbu	a5,0(a5)
    4ffe:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    5002:	87ae                	mv	a5,a1
    5004:	02c5d5b3          	divu	a1,a1,a2
    5008:	0685                	addi	a3,a3,1
    500a:	fec7f1e3          	bgeu	a5,a2,4fec <printint+0x2a>
  if(neg)
    500e:	00030c63          	beqz	t1,5026 <printint+0x64>
    buf[i++] = '-';
    5012:	fd050793          	addi	a5,a0,-48
    5016:	00878533          	add	a0,a5,s0
    501a:	02d00793          	li	a5,45
    501e:	fef50423          	sb	a5,-24(a0)
    5022:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    5026:	02e05563          	blez	a4,5050 <printint+0x8e>
    502a:	fc26                	sd	s1,56(sp)
    502c:	377d                	addiw	a4,a4,-1
    502e:	00e984b3          	add	s1,s3,a4
    5032:	19fd                	addi	s3,s3,-1 # fff <bigdir+0x107>
    5034:	99ba                	add	s3,s3,a4
    5036:	1702                	slli	a4,a4,0x20
    5038:	9301                	srli	a4,a4,0x20
    503a:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    503e:	0004c583          	lbu	a1,0(s1)
    5042:	854a                	mv	a0,s2
    5044:	f61ff0ef          	jal	4fa4 <putc>
  while(--i >= 0)
    5048:	14fd                	addi	s1,s1,-1
    504a:	ff349ae3          	bne	s1,s3,503e <printint+0x7c>
    504e:	74e2                	ld	s1,56(sp)
}
    5050:	60a6                	ld	ra,72(sp)
    5052:	6406                	ld	s0,64(sp)
    5054:	7942                	ld	s2,48(sp)
    5056:	79a2                	ld	s3,40(sp)
    5058:	6161                	addi	sp,sp,80
    505a:	8082                	ret
  neg = 0;
    505c:	4301                	li	t1,0
    505e:	bfbd                	j	4fdc <printint+0x1a>

0000000000005060 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    5060:	711d                	addi	sp,sp,-96
    5062:	ec86                	sd	ra,88(sp)
    5064:	e8a2                	sd	s0,80(sp)
    5066:	e4a6                	sd	s1,72(sp)
    5068:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    506a:	0005c483          	lbu	s1,0(a1)
    506e:	22048363          	beqz	s1,5294 <vprintf+0x234>
    5072:	e0ca                	sd	s2,64(sp)
    5074:	fc4e                	sd	s3,56(sp)
    5076:	f852                	sd	s4,48(sp)
    5078:	f456                	sd	s5,40(sp)
    507a:	f05a                	sd	s6,32(sp)
    507c:	ec5e                	sd	s7,24(sp)
    507e:	e862                	sd	s8,16(sp)
    5080:	8b2a                	mv	s6,a0
    5082:	8a2e                	mv	s4,a1
    5084:	8bb2                	mv	s7,a2
  state = 0;
    5086:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    5088:	4901                	li	s2,0
    508a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    508c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    5090:	06400c13          	li	s8,100
    5094:	a00d                	j	50b6 <vprintf+0x56>
        putc(fd, c0);
    5096:	85a6                	mv	a1,s1
    5098:	855a                	mv	a0,s6
    509a:	f0bff0ef          	jal	4fa4 <putc>
    509e:	a019                	j	50a4 <vprintf+0x44>
    } else if(state == '%'){
    50a0:	03598363          	beq	s3,s5,50c6 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
    50a4:	0019079b          	addiw	a5,s2,1
    50a8:	893e                	mv	s2,a5
    50aa:	873e                	mv	a4,a5
    50ac:	97d2                	add	a5,a5,s4
    50ae:	0007c483          	lbu	s1,0(a5)
    50b2:	1c048a63          	beqz	s1,5286 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    50b6:	0004879b          	sext.w	a5,s1
    if(state == 0){
    50ba:	fe0993e3          	bnez	s3,50a0 <vprintf+0x40>
      if(c0 == '%'){
    50be:	fd579ce3          	bne	a5,s5,5096 <vprintf+0x36>
        state = '%';
    50c2:	89be                	mv	s3,a5
    50c4:	b7c5                	j	50a4 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
    50c6:	00ea06b3          	add	a3,s4,a4
    50ca:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
    50ce:	1c060863          	beqz	a2,529e <vprintf+0x23e>
      if(c0 == 'd'){
    50d2:	03878763          	beq	a5,s8,5100 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    50d6:	f9478693          	addi	a3,a5,-108
    50da:	0016b693          	seqz	a3,a3
    50de:	f9c60593          	addi	a1,a2,-100
    50e2:	e99d                	bnez	a1,5118 <vprintf+0xb8>
    50e4:	ca95                	beqz	a3,5118 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    50e6:	008b8493          	addi	s1,s7,8
    50ea:	4685                	li	a3,1
    50ec:	4629                	li	a2,10
    50ee:	000bb583          	ld	a1,0(s7)
    50f2:	855a                	mv	a0,s6
    50f4:	ecfff0ef          	jal	4fc2 <printint>
        i += 1;
    50f8:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    50fa:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    50fc:	4981                	li	s3,0
    50fe:	b75d                	j	50a4 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    5100:	008b8493          	addi	s1,s7,8
    5104:	4685                	li	a3,1
    5106:	4629                	li	a2,10
    5108:	000ba583          	lw	a1,0(s7)
    510c:	855a                	mv	a0,s6
    510e:	eb5ff0ef          	jal	4fc2 <printint>
    5112:	8ba6                	mv	s7,s1
      state = 0;
    5114:	4981                	li	s3,0
    5116:	b779                	j	50a4 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
    5118:	9752                	add	a4,a4,s4
    511a:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    511e:	f9460713          	addi	a4,a2,-108
    5122:	00173713          	seqz	a4,a4
    5126:	8f75                	and	a4,a4,a3
    5128:	f9c58513          	addi	a0,a1,-100
    512c:	18051363          	bnez	a0,52b2 <vprintf+0x252>
    5130:	18070163          	beqz	a4,52b2 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    5134:	008b8493          	addi	s1,s7,8
    5138:	4685                	li	a3,1
    513a:	4629                	li	a2,10
    513c:	000bb583          	ld	a1,0(s7)
    5140:	855a                	mv	a0,s6
    5142:	e81ff0ef          	jal	4fc2 <printint>
        i += 2;
    5146:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    5148:	8ba6                	mv	s7,s1
      state = 0;
    514a:	4981                	li	s3,0
        i += 2;
    514c:	bfa1                	j	50a4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    514e:	008b8493          	addi	s1,s7,8
    5152:	4681                	li	a3,0
    5154:	4629                	li	a2,10
    5156:	000be583          	lwu	a1,0(s7)
    515a:	855a                	mv	a0,s6
    515c:	e67ff0ef          	jal	4fc2 <printint>
    5160:	8ba6                	mv	s7,s1
      state = 0;
    5162:	4981                	li	s3,0
    5164:	b781                	j	50a4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5166:	008b8493          	addi	s1,s7,8
    516a:	4681                	li	a3,0
    516c:	4629                	li	a2,10
    516e:	000bb583          	ld	a1,0(s7)
    5172:	855a                	mv	a0,s6
    5174:	e4fff0ef          	jal	4fc2 <printint>
        i += 1;
    5178:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    517a:	8ba6                	mv	s7,s1
      state = 0;
    517c:	4981                	li	s3,0
    517e:	b71d                	j	50a4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    5180:	008b8493          	addi	s1,s7,8
    5184:	4681                	li	a3,0
    5186:	4629                	li	a2,10
    5188:	000bb583          	ld	a1,0(s7)
    518c:	855a                	mv	a0,s6
    518e:	e35ff0ef          	jal	4fc2 <printint>
        i += 2;
    5192:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    5194:	8ba6                	mv	s7,s1
      state = 0;
    5196:	4981                	li	s3,0
        i += 2;
    5198:	b731                	j	50a4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    519a:	008b8493          	addi	s1,s7,8
    519e:	4681                	li	a3,0
    51a0:	4641                	li	a2,16
    51a2:	000be583          	lwu	a1,0(s7)
    51a6:	855a                	mv	a0,s6
    51a8:	e1bff0ef          	jal	4fc2 <printint>
    51ac:	8ba6                	mv	s7,s1
      state = 0;
    51ae:	4981                	li	s3,0
    51b0:	bdd5                	j	50a4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    51b2:	008b8493          	addi	s1,s7,8
    51b6:	4681                	li	a3,0
    51b8:	4641                	li	a2,16
    51ba:	000bb583          	ld	a1,0(s7)
    51be:	855a                	mv	a0,s6
    51c0:	e03ff0ef          	jal	4fc2 <printint>
        i += 1;
    51c4:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    51c6:	8ba6                	mv	s7,s1
      state = 0;
    51c8:	4981                	li	s3,0
    51ca:	bde9                	j	50a4 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    51cc:	008b8493          	addi	s1,s7,8
    51d0:	4681                	li	a3,0
    51d2:	4641                	li	a2,16
    51d4:	000bb583          	ld	a1,0(s7)
    51d8:	855a                	mv	a0,s6
    51da:	de9ff0ef          	jal	4fc2 <printint>
        i += 2;
    51de:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    51e0:	8ba6                	mv	s7,s1
      state = 0;
    51e2:	4981                	li	s3,0
        i += 2;
    51e4:	b5c1                	j	50a4 <vprintf+0x44>
    51e6:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    51e8:	008b8793          	addi	a5,s7,8
    51ec:	8cbe                	mv	s9,a5
    51ee:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    51f2:	03000593          	li	a1,48
    51f6:	855a                	mv	a0,s6
    51f8:	dadff0ef          	jal	4fa4 <putc>
  putc(fd, 'x');
    51fc:	07800593          	li	a1,120
    5200:	855a                	mv	a0,s6
    5202:	da3ff0ef          	jal	4fa4 <putc>
    5206:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    5208:	00003b97          	auipc	s7,0x3
    520c:	828b8b93          	addi	s7,s7,-2008 # 7a30 <digits>
    5210:	03c9d793          	srli	a5,s3,0x3c
    5214:	97de                	add	a5,a5,s7
    5216:	0007c583          	lbu	a1,0(a5)
    521a:	855a                	mv	a0,s6
    521c:	d89ff0ef          	jal	4fa4 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    5220:	0992                	slli	s3,s3,0x4
    5222:	34fd                	addiw	s1,s1,-1
    5224:	f4f5                	bnez	s1,5210 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    5226:	8be6                	mv	s7,s9
      state = 0;
    5228:	4981                	li	s3,0
    522a:	6ca2                	ld	s9,8(sp)
    522c:	bda5                	j	50a4 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    522e:	008b8493          	addi	s1,s7,8
    5232:	000bc583          	lbu	a1,0(s7)
    5236:	855a                	mv	a0,s6
    5238:	d6dff0ef          	jal	4fa4 <putc>
    523c:	8ba6                	mv	s7,s1
      state = 0;
    523e:	4981                	li	s3,0
    5240:	b595                	j	50a4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    5242:	008b8993          	addi	s3,s7,8
    5246:	000bb483          	ld	s1,0(s7)
    524a:	cc91                	beqz	s1,5266 <vprintf+0x206>
        for(; *s; s++)
    524c:	0004c583          	lbu	a1,0(s1)
    5250:	c985                	beqz	a1,5280 <vprintf+0x220>
          putc(fd, *s);
    5252:	855a                	mv	a0,s6
    5254:	d51ff0ef          	jal	4fa4 <putc>
        for(; *s; s++)
    5258:	0485                	addi	s1,s1,1
    525a:	0004c583          	lbu	a1,0(s1)
    525e:	f9f5                	bnez	a1,5252 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    5260:	8bce                	mv	s7,s3
      state = 0;
    5262:	4981                	li	s3,0
    5264:	b581                	j	50a4 <vprintf+0x44>
          s = "(null)";
    5266:	00002497          	auipc	s1,0x2
    526a:	71a48493          	addi	s1,s1,1818 # 7980 <malloc+0x257e>
        for(; *s; s++)
    526e:	02800593          	li	a1,40
    5272:	b7c5                	j	5252 <vprintf+0x1f2>
        putc(fd, '%');
    5274:	85be                	mv	a1,a5
    5276:	855a                	mv	a0,s6
    5278:	d2dff0ef          	jal	4fa4 <putc>
      state = 0;
    527c:	4981                	li	s3,0
    527e:	b51d                	j	50a4 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    5280:	8bce                	mv	s7,s3
      state = 0;
    5282:	4981                	li	s3,0
    5284:	b505                	j	50a4 <vprintf+0x44>
    5286:	6906                	ld	s2,64(sp)
    5288:	79e2                	ld	s3,56(sp)
    528a:	7a42                	ld	s4,48(sp)
    528c:	7aa2                	ld	s5,40(sp)
    528e:	7b02                	ld	s6,32(sp)
    5290:	6be2                	ld	s7,24(sp)
    5292:	6c42                	ld	s8,16(sp)
    }
  }
}
    5294:	60e6                	ld	ra,88(sp)
    5296:	6446                	ld	s0,80(sp)
    5298:	64a6                	ld	s1,72(sp)
    529a:	6125                	addi	sp,sp,96
    529c:	8082                	ret
      if(c0 == 'd'){
    529e:	06400713          	li	a4,100
    52a2:	e4e78fe3          	beq	a5,a4,5100 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    52a6:	f9478693          	addi	a3,a5,-108
    52aa:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    52ae:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    52b0:	4701                	li	a4,0
      } else if(c0 == 'u'){
    52b2:	07500513          	li	a0,117
    52b6:	e8a78ce3          	beq	a5,a0,514e <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    52ba:	f8b60513          	addi	a0,a2,-117
    52be:	e119                	bnez	a0,52c4 <vprintf+0x264>
    52c0:	ea0693e3          	bnez	a3,5166 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    52c4:	f8b58513          	addi	a0,a1,-117
    52c8:	e119                	bnez	a0,52ce <vprintf+0x26e>
    52ca:	ea071be3          	bnez	a4,5180 <vprintf+0x120>
      } else if(c0 == 'x'){
    52ce:	07800513          	li	a0,120
    52d2:	eca784e3          	beq	a5,a0,519a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    52d6:	f8860613          	addi	a2,a2,-120
    52da:	e219                	bnez	a2,52e0 <vprintf+0x280>
    52dc:	ec069be3          	bnez	a3,51b2 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    52e0:	f8858593          	addi	a1,a1,-120
    52e4:	e199                	bnez	a1,52ea <vprintf+0x28a>
    52e6:	ee0713e3          	bnez	a4,51cc <vprintf+0x16c>
      } else if(c0 == 'p'){
    52ea:	07000713          	li	a4,112
    52ee:	eee78ce3          	beq	a5,a4,51e6 <vprintf+0x186>
      } else if(c0 == 'c'){
    52f2:	06300713          	li	a4,99
    52f6:	f2e78ce3          	beq	a5,a4,522e <vprintf+0x1ce>
      } else if(c0 == 's'){
    52fa:	07300713          	li	a4,115
    52fe:	f4e782e3          	beq	a5,a4,5242 <vprintf+0x1e2>
      } else if(c0 == '%'){
    5302:	02500713          	li	a4,37
    5306:	f6e787e3          	beq	a5,a4,5274 <vprintf+0x214>
        putc(fd, '%');
    530a:	02500593          	li	a1,37
    530e:	855a                	mv	a0,s6
    5310:	c95ff0ef          	jal	4fa4 <putc>
        putc(fd, c0);
    5314:	85a6                	mv	a1,s1
    5316:	855a                	mv	a0,s6
    5318:	c8dff0ef          	jal	4fa4 <putc>
      state = 0;
    531c:	4981                	li	s3,0
    531e:	b359                	j	50a4 <vprintf+0x44>

0000000000005320 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    5320:	715d                	addi	sp,sp,-80
    5322:	ec06                	sd	ra,24(sp)
    5324:	e822                	sd	s0,16(sp)
    5326:	1000                	addi	s0,sp,32
    5328:	e010                	sd	a2,0(s0)
    532a:	e414                	sd	a3,8(s0)
    532c:	e818                	sd	a4,16(s0)
    532e:	ec1c                	sd	a5,24(s0)
    5330:	03043023          	sd	a6,32(s0)
    5334:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    5338:	8622                	mv	a2,s0
    533a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    533e:	d23ff0ef          	jal	5060 <vprintf>
}
    5342:	60e2                	ld	ra,24(sp)
    5344:	6442                	ld	s0,16(sp)
    5346:	6161                	addi	sp,sp,80
    5348:	8082                	ret

000000000000534a <printf>:

void
printf(const char *fmt, ...)
{
    534a:	711d                	addi	sp,sp,-96
    534c:	ec06                	sd	ra,24(sp)
    534e:	e822                	sd	s0,16(sp)
    5350:	1000                	addi	s0,sp,32
    5352:	e40c                	sd	a1,8(s0)
    5354:	e810                	sd	a2,16(s0)
    5356:	ec14                	sd	a3,24(s0)
    5358:	f018                	sd	a4,32(s0)
    535a:	f41c                	sd	a5,40(s0)
    535c:	03043823          	sd	a6,48(s0)
    5360:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    5364:	00840613          	addi	a2,s0,8
    5368:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    536c:	85aa                	mv	a1,a0
    536e:	4505                	li	a0,1
    5370:	cf1ff0ef          	jal	5060 <vprintf>
}
    5374:	60e2                	ld	ra,24(sp)
    5376:	6442                	ld	s0,16(sp)
    5378:	6125                	addi	sp,sp,96
    537a:	8082                	ret

000000000000537c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    537c:	1141                	addi	sp,sp,-16
    537e:	e406                	sd	ra,8(sp)
    5380:	e022                	sd	s0,0(sp)
    5382:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    5384:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    5388:	00003797          	auipc	a5,0x3
    538c:	0f87b783          	ld	a5,248(a5) # 8480 <freep>
    5390:	a039                	j	539e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    5392:	6398                	ld	a4,0(a5)
    5394:	00e7e463          	bltu	a5,a4,539c <free+0x20>
    5398:	00e6ea63          	bltu	a3,a4,53ac <free+0x30>
{
    539c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    539e:	fed7fae3          	bgeu	a5,a3,5392 <free+0x16>
    53a2:	6398                	ld	a4,0(a5)
    53a4:	00e6e463          	bltu	a3,a4,53ac <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    53a8:	fee7eae3          	bltu	a5,a4,539c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    53ac:	ff852583          	lw	a1,-8(a0)
    53b0:	6390                	ld	a2,0(a5)
    53b2:	02059813          	slli	a6,a1,0x20
    53b6:	01c85713          	srli	a4,a6,0x1c
    53ba:	9736                	add	a4,a4,a3
    53bc:	02e60563          	beq	a2,a4,53e6 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    53c0:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    53c4:	4790                	lw	a2,8(a5)
    53c6:	02061593          	slli	a1,a2,0x20
    53ca:	01c5d713          	srli	a4,a1,0x1c
    53ce:	973e                	add	a4,a4,a5
    53d0:	02e68263          	beq	a3,a4,53f4 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    53d4:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    53d6:	00003717          	auipc	a4,0x3
    53da:	0af73523          	sd	a5,170(a4) # 8480 <freep>
}
    53de:	60a2                	ld	ra,8(sp)
    53e0:	6402                	ld	s0,0(sp)
    53e2:	0141                	addi	sp,sp,16
    53e4:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    53e6:	4618                	lw	a4,8(a2)
    53e8:	9f2d                	addw	a4,a4,a1
    53ea:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    53ee:	6398                	ld	a4,0(a5)
    53f0:	6310                	ld	a2,0(a4)
    53f2:	b7f9                	j	53c0 <free+0x44>
    p->s.size += bp->s.size;
    53f4:	ff852703          	lw	a4,-8(a0)
    53f8:	9f31                	addw	a4,a4,a2
    53fa:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    53fc:	ff053683          	ld	a3,-16(a0)
    5400:	bfd1                	j	53d4 <free+0x58>

0000000000005402 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    5402:	7139                	addi	sp,sp,-64
    5404:	fc06                	sd	ra,56(sp)
    5406:	f822                	sd	s0,48(sp)
    5408:	f04a                	sd	s2,32(sp)
    540a:	ec4e                	sd	s3,24(sp)
    540c:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    540e:	02051993          	slli	s3,a0,0x20
    5412:	0209d993          	srli	s3,s3,0x20
    5416:	09bd                	addi	s3,s3,15
    5418:	0049d993          	srli	s3,s3,0x4
    541c:	2985                	addiw	s3,s3,1
    541e:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    5420:	00003517          	auipc	a0,0x3
    5424:	06053503          	ld	a0,96(a0) # 8480 <freep>
    5428:	c905                	beqz	a0,5458 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    542a:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    542c:	4798                	lw	a4,8(a5)
    542e:	09377663          	bgeu	a4,s3,54ba <malloc+0xb8>
    5432:	f426                	sd	s1,40(sp)
    5434:	e852                	sd	s4,16(sp)
    5436:	e456                	sd	s5,8(sp)
    5438:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    543a:	8a4e                	mv	s4,s3
    543c:	6705                	lui	a4,0x1
    543e:	00e9f363          	bgeu	s3,a4,5444 <malloc+0x42>
    5442:	6a05                	lui	s4,0x1
    5444:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    5448:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    544c:	00003497          	auipc	s1,0x3
    5450:	03448493          	addi	s1,s1,52 # 8480 <freep>
  if(p == SBRK_ERROR)
    5454:	5afd                	li	s5,-1
    5456:	a83d                	j	5494 <malloc+0x92>
    5458:	f426                	sd	s1,40(sp)
    545a:	e852                	sd	s4,16(sp)
    545c:	e456                	sd	s5,8(sp)
    545e:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    5460:	0000a797          	auipc	a5,0xa
    5464:	84878793          	addi	a5,a5,-1976 # eca8 <base>
    5468:	00003717          	auipc	a4,0x3
    546c:	00f73c23          	sd	a5,24(a4) # 8480 <freep>
    5470:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    5472:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    5476:	b7d1                	j	543a <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    5478:	6398                	ld	a4,0(a5)
    547a:	e118                	sd	a4,0(a0)
    547c:	a899                	j	54d2 <malloc+0xd0>
  hp->s.size = nu;
    547e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    5482:	0541                	addi	a0,a0,16
    5484:	ef9ff0ef          	jal	537c <free>
  return freep;
    5488:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    548a:	c125                	beqz	a0,54ea <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    548c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    548e:	4798                	lw	a4,8(a5)
    5490:	03277163          	bgeu	a4,s2,54b2 <malloc+0xb0>
    if(p == freep)
    5494:	6098                	ld	a4,0(s1)
    5496:	853e                	mv	a0,a5
    5498:	fef71ae3          	bne	a4,a5,548c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    549c:	8552                	mv	a0,s4
    549e:	a2bff0ef          	jal	4ec8 <sbrk>
  if(p == SBRK_ERROR)
    54a2:	fd551ee3          	bne	a0,s5,547e <malloc+0x7c>
        return 0;
    54a6:	4501                	li	a0,0
    54a8:	74a2                	ld	s1,40(sp)
    54aa:	6a42                	ld	s4,16(sp)
    54ac:	6aa2                	ld	s5,8(sp)
    54ae:	6b02                	ld	s6,0(sp)
    54b0:	a03d                	j	54de <malloc+0xdc>
    54b2:	74a2                	ld	s1,40(sp)
    54b4:	6a42                	ld	s4,16(sp)
    54b6:	6aa2                	ld	s5,8(sp)
    54b8:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    54ba:	fae90fe3          	beq	s2,a4,5478 <malloc+0x76>
        p->s.size -= nunits;
    54be:	4137073b          	subw	a4,a4,s3
    54c2:	c798                	sw	a4,8(a5)
        p += p->s.size;
    54c4:	02071693          	slli	a3,a4,0x20
    54c8:	01c6d713          	srli	a4,a3,0x1c
    54cc:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    54ce:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    54d2:	00003717          	auipc	a4,0x3
    54d6:	faa73723          	sd	a0,-82(a4) # 8480 <freep>
      return (void*)(p + 1);
    54da:	01078513          	addi	a0,a5,16
  }
}
    54de:	70e2                	ld	ra,56(sp)
    54e0:	7442                	ld	s0,48(sp)
    54e2:	7902                	ld	s2,32(sp)
    54e4:	69e2                	ld	s3,24(sp)
    54e6:	6121                	addi	sp,sp,64
    54e8:	8082                	ret
    54ea:	74a2                	ld	s1,40(sp)
    54ec:	6a42                	ld	s4,16(sp)
    54ee:	6aa2                	ld	s5,8(sp)
    54f0:	6b02                	ld	s6,0(sp)
    54f2:	b7f5                	j	54de <malloc+0xdc>
