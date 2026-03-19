
user/_symlinktest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <stat_slink>:
}

// stat a symbolic link using O_NOFOLLOW
static int
stat_slink(char *pn, struct stat *st)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	1000                	addi	s0,sp,32
       a:	84ae                	mv	s1,a1
  int fd = open(pn, O_RDONLY | O_NOFOLLOW);
       c:	6585                	lui	a1,0x1
       e:	80058593          	addi	a1,a1,-2048 # 800 <main+0x7ca>
      12:	335000ef          	jal	b46 <open>
  if(fd < 0)
      16:	00054e63          	bltz	a0,32 <stat_slink+0x32>
    return -1;
  if(fstat(fd, st) != 0)
      1a:	85a6                	mv	a1,s1
      1c:	343000ef          	jal	b5e <fstat>
      20:	00a03533          	snez	a0,a0
      24:	40a0053b          	negw	a0,a0
    return -1;
  return 0;
}
      28:	60e2                	ld	ra,24(sp)
      2a:	6442                	ld	s0,16(sp)
      2c:	64a2                	ld	s1,8(sp)
      2e:	6105                	addi	sp,sp,32
      30:	8082                	ret
    return -1;
      32:	557d                	li	a0,-1
      34:	bfd5                	j	28 <stat_slink+0x28>

0000000000000036 <main>:
{
      36:	7131                	addi	sp,sp,-192
      38:	fd06                	sd	ra,184(sp)
      3a:	f922                	sd	s0,176(sp)
      3c:	f526                	sd	s1,168(sp)
      3e:	f14a                	sd	s2,160(sp)
      40:	ed4e                	sd	s3,152(sp)
      42:	e952                	sd	s4,144(sp)
      44:	e556                	sd	s5,136(sp)
      46:	e15a                	sd	s6,128(sp)
      48:	fcde                	sd	s7,120(sp)
      4a:	f8e2                	sd	s8,112(sp)
      4c:	0180                	addi	s0,sp,192
  unlink("/testsymlink/a");
      4e:	00001517          	auipc	a0,0x1
      52:	0b250513          	addi	a0,a0,178 # 1100 <malloc+0xf4>
      56:	301000ef          	jal	b56 <unlink>
  unlink("/testsymlink/b");
      5a:	00001517          	auipc	a0,0x1
      5e:	0be50513          	addi	a0,a0,190 # 1118 <malloc+0x10c>
      62:	2f5000ef          	jal	b56 <unlink>
  unlink("/testsymlink/c");
      66:	00001517          	auipc	a0,0x1
      6a:	0c250513          	addi	a0,a0,194 # 1128 <malloc+0x11c>
      6e:	2e9000ef          	jal	b56 <unlink>
  unlink("/testsymlink/1");
      72:	00001517          	auipc	a0,0x1
      76:	0c650513          	addi	a0,a0,198 # 1138 <malloc+0x12c>
      7a:	2dd000ef          	jal	b56 <unlink>
  unlink("/testsymlink/2");
      7e:	00001517          	auipc	a0,0x1
      82:	0ca50513          	addi	a0,a0,202 # 1148 <malloc+0x13c>
      86:	2d1000ef          	jal	b56 <unlink>
  unlink("/testsymlink/3");
      8a:	00001517          	auipc	a0,0x1
      8e:	0ce50513          	addi	a0,a0,206 # 1158 <malloc+0x14c>
      92:	2c5000ef          	jal	b56 <unlink>
  unlink("/testsymlink/4");
      96:	00001517          	auipc	a0,0x1
      9a:	0d250513          	addi	a0,a0,210 # 1168 <malloc+0x15c>
      9e:	2b9000ef          	jal	b56 <unlink>
  unlink("/testsymlink/z");
      a2:	00001517          	auipc	a0,0x1
      a6:	0d650513          	addi	a0,a0,214 # 1178 <malloc+0x16c>
      aa:	2ad000ef          	jal	b56 <unlink>
  unlink("/testsymlink/y");
      ae:	00001517          	auipc	a0,0x1
      b2:	0da50513          	addi	a0,a0,218 # 1188 <malloc+0x17c>
      b6:	2a1000ef          	jal	b56 <unlink>
  for(int i = 0; i < NINODE+2; i++){
      ba:	4901                	li	s2,0
    memset(name, 0, sizeof(name));
      bc:	f8040a13          	addi	s4,s0,-128
      c0:	02000c13          	li	s8,32
    strcpy(name, base);
      c4:	00001997          	auipc	s3,0x1
      c8:	0d498993          	addi	s3,s3,212 # 1198 <malloc+0x18c>
    name[strlen(base)+0] = 'a' + (i / 26);
      cc:	4ec4fab7          	lui	s5,0x4ec4f
      d0:	c4fa8a93          	addi	s5,s5,-945 # 4ec4ec4f <base+0x4ec4cc3f>
    name[strlen(base)+1] = 'a' + (i % 26);
      d4:	4be9                	li	s7,26
  for(int i = 0; i < NINODE+2; i++){
      d6:	03400b13          	li	s6,52
    memset(name, 0, sizeof(name));
      da:	8662                	mv	a2,s8
      dc:	4581                	li	a1,0
      de:	8552                	mv	a0,s4
      e0:	7fc000ef          	jal	8dc <memset>
    strcpy(name, base);
      e4:	85ce                	mv	a1,s3
      e6:	8552                	mv	a0,s4
      e8:	778000ef          	jal	860 <strcpy>
    name[strlen(base)+0] = 'a' + (i / 26);
      ec:	854e                	mv	a0,s3
      ee:	7c2000ef          	jal	8b0 <strlen>
      f2:	1502                	slli	a0,a0,0x20
      f4:	9101                	srli	a0,a0,0x20
      f6:	fa050793          	addi	a5,a0,-96
      fa:	00878533          	add	a0,a5,s0
      fe:	035904b3          	mul	s1,s2,s5
     102:	948d                	srai	s1,s1,0x23
     104:	41f9579b          	sraiw	a5,s2,0x1f
     108:	9c9d                	subw	s1,s1,a5
     10a:	0614879b          	addiw	a5,s1,97
     10e:	fef50023          	sb	a5,-32(a0)
    name[strlen(base)+1] = 'a' + (i % 26);
     112:	854e                	mv	a0,s3
     114:	79c000ef          	jal	8b0 <strlen>
     118:	2505                	addiw	a0,a0,1
     11a:	1502                	slli	a0,a0,0x20
     11c:	9101                	srli	a0,a0,0x20
     11e:	fa050793          	addi	a5,a0,-96
     122:	00878533          	add	a0,a5,s0
     126:	029b84bb          	mulw	s1,s7,s1
     12a:	409904bb          	subw	s1,s2,s1
     12e:	0614849b          	addiw	s1,s1,97
     132:	fe950023          	sb	s1,-32(a0)
    unlink(name);
     136:	8552                	mv	a0,s4
     138:	21f000ef          	jal	b56 <unlink>
  for(int i = 0; i < NINODE+2; i++){
     13c:	2905                	addiw	s2,s2,1
     13e:	f9691ee3          	bne	s2,s6,da <main+0xa4>
  unlink("/testsymlink");
     142:	00001517          	auipc	a0,0x1
     146:	06650513          	addi	a0,a0,102 # 11a8 <malloc+0x19c>
     14a:	20d000ef          	jal	b56 <unlink>

static void
testsymlink(void)
{
  int r, fd1 = -1, fd2 = -1;
  char buf[4] = {'a', 'b', 'c', 'd'};
     14e:	646367b7          	lui	a5,0x64636
     152:	26178793          	addi	a5,a5,609 # 64636261 <base+0x64634251>
     156:	f4f42823          	sw	a5,-176(s0)
  char c = 0, c2 = 0;
     15a:	f4040723          	sb	zero,-178(s0)
     15e:	f40407a3          	sb	zero,-177(s0)
  struct stat st;
    
  printf("Start: test symlinks\n");
     162:	00001517          	auipc	a0,0x1
     166:	05650513          	addi	a0,a0,86 # 11b8 <malloc+0x1ac>
     16a:	5eb000ef          	jal	f54 <printf>

  mkdir("/testsymlink");
     16e:	00001517          	auipc	a0,0x1
     172:	03a50513          	addi	a0,a0,58 # 11a8 <malloc+0x19c>
     176:	1f9000ef          	jal	b6e <mkdir>

  fd1 = open("/testsymlink/a", O_CREATE | O_RDWR);
     17a:	20200593          	li	a1,514
     17e:	00001517          	auipc	a0,0x1
     182:	f8250513          	addi	a0,a0,-126 # 1100 <malloc+0xf4>
     186:	1c1000ef          	jal	b46 <open>
     18a:	84aa                	mv	s1,a0
  if(fd1 < 0) fail("failed to open a");
     18c:	0c054463          	bltz	a0,254 <main+0x21e>

  r = symlink("/testsymlink/a", "/testsymlink/b");
     190:	00001597          	auipc	a1,0x1
     194:	f8858593          	addi	a1,a1,-120 # 1118 <malloc+0x10c>
     198:	00001517          	auipc	a0,0x1
     19c:	f6850513          	addi	a0,a0,-152 # 1100 <malloc+0xf4>
     1a0:	207000ef          	jal	ba6 <symlink>
  if(r < 0)
     1a4:	0c054563          	bltz	a0,26e <main+0x238>
    fail("symlink b -> a failed");

  if(write(fd1, buf, sizeof(buf)) != 4)
     1a8:	4611                	li	a2,4
     1aa:	f5040593          	addi	a1,s0,-176
     1ae:	8526                	mv	a0,s1
     1b0:	177000ef          	jal	b26 <write>
     1b4:	4791                	li	a5,4
     1b6:	0cf50963          	beq	a0,a5,288 <main+0x252>
    fail("failed to write to a");
     1ba:	00001517          	auipc	a0,0x1
     1be:	05650513          	addi	a0,a0,86 # 1210 <malloc+0x204>
     1c2:	593000ef          	jal	f54 <printf>
     1c6:	4785                	li	a5,1
     1c8:	00002717          	auipc	a4,0x2
     1cc:	e2f72c23          	sw	a5,-456(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     1d0:	597d                	li	s2,-1
  close(fd1);
  fd1 = -1;

  printf("test symlinks: ok\n");
done:
  close(fd1);
     1d2:	8526                	mv	a0,s1
     1d4:	15b000ef          	jal	b2e <close>
  close(fd2);
     1d8:	854a                	mv	a0,s2
     1da:	155000ef          	jal	b2e <close>
  int pid, i;
  int fd;
  struct stat st;
  int nchild = 2;

  printf("Start: test concurrent symlinks\n");
     1de:	00001517          	auipc	a0,0x1
     1e2:	41a50513          	addi	a0,a0,1050 # 15f8 <malloc+0x5ec>
     1e6:	56f000ef          	jal	f54 <printf>
    
  fd = open("/testsymlink/z", O_CREATE | O_RDWR);
     1ea:	20200593          	li	a1,514
     1ee:	00001517          	auipc	a0,0x1
     1f2:	f8a50513          	addi	a0,a0,-118 # 1178 <malloc+0x16c>
     1f6:	151000ef          	jal	b46 <open>
  if(fd < 0) {
     1fa:	58054063          	bltz	a0,77a <main+0x744>
    printf("FAILED: open failed");
    exit(1);
  }
  close(fd);
     1fe:	131000ef          	jal	b2e <close>

  for(int j = 0; j < nchild; j++) {
    pid = fork();
     202:	0fd000ef          	jal	afe <fork>
    if(pid < 0){
     206:	58054463          	bltz	a0,78e <main+0x758>
      printf("FAILED: fork failed\n");
      exit(1);
    }
    if(pid == 0) {
     20a:	58050c63          	beqz	a0,7a2 <main+0x76c>
    pid = fork();
     20e:	0f1000ef          	jal	afe <fork>
    if(pid < 0){
     212:	56054e63          	bltz	a0,78e <main+0x758>
    if(pid == 0) {
     216:	58050663          	beqz	a0,7a2 <main+0x76c>
    }
  }

  int r;
  for(int j = 0; j < nchild; j++) {
    wait(&r);
     21a:	f8040513          	addi	a0,s0,-128
     21e:	0f1000ef          	jal	b0e <wait>
    if(r != 0) {
     222:	f8042783          	lw	a5,-128(s0)
     226:	60079b63          	bnez	a5,83c <main+0x806>
    wait(&r);
     22a:	f8040513          	addi	a0,s0,-128
     22e:	0e1000ef          	jal	b0e <wait>
    if(r != 0) {
     232:	f8042783          	lw	a5,-128(s0)
     236:	60079363          	bnez	a5,83c <main+0x806>
     23a:	f4e6                	sd	s9,104(sp)
      printf("test concurrent symlinks: failed\n");
      exit(1);
    }
  }
  printf("test concurrent symlinks: ok\n");
     23c:	00001517          	auipc	a0,0x1
     240:	46450513          	addi	a0,a0,1124 # 16a0 <malloc+0x694>
     244:	511000ef          	jal	f54 <printf>
  exit(failed);
     248:	00002517          	auipc	a0,0x2
     24c:	db852503          	lw	a0,-584(a0) # 2000 <failed>
     250:	0b7000ef          	jal	b06 <exit>
  if(fd1 < 0) fail("failed to open a");
     254:	00001517          	auipc	a0,0x1
     258:	f7c50513          	addi	a0,a0,-132 # 11d0 <malloc+0x1c4>
     25c:	4f9000ef          	jal	f54 <printf>
     260:	4785                	li	a5,1
     262:	00002717          	auipc	a4,0x2
     266:	d8f72f23          	sw	a5,-610(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     26a:	597d                	li	s2,-1
  if(fd1 < 0) fail("failed to open a");
     26c:	b79d                	j	1d2 <main+0x19c>
    fail("symlink b -> a failed");
     26e:	00001517          	auipc	a0,0x1
     272:	f8250513          	addi	a0,a0,-126 # 11f0 <malloc+0x1e4>
     276:	4df000ef          	jal	f54 <printf>
     27a:	4785                	li	a5,1
     27c:	00002717          	auipc	a4,0x2
     280:	d8f72223          	sw	a5,-636(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     284:	597d                	li	s2,-1
    fail("symlink b -> a failed");
     286:	b7b1                	j	1d2 <main+0x19c>
  if (stat_slink("/testsymlink/b", &st) != 0)
     288:	f6840593          	addi	a1,s0,-152
     28c:	00001517          	auipc	a0,0x1
     290:	e8c50513          	addi	a0,a0,-372 # 1118 <malloc+0x10c>
     294:	d6dff0ef          	jal	0 <stat_slink>
     298:	e11d                	bnez	a0,2be <main+0x288>
  if(st.type != T_SYMLINK)
     29a:	f7041703          	lh	a4,-144(s0)
     29e:	4791                	li	a5,4
     2a0:	02f70c63          	beq	a4,a5,2d8 <main+0x2a2>
    fail("b isn't a symlink");
     2a4:	00001517          	auipc	a0,0x1
     2a8:	fac50513          	addi	a0,a0,-84 # 1250 <malloc+0x244>
     2ac:	4a9000ef          	jal	f54 <printf>
     2b0:	4785                	li	a5,1
     2b2:	00002717          	auipc	a4,0x2
     2b6:	d4f72723          	sw	a5,-690(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     2ba:	597d                	li	s2,-1
    fail("b isn't a symlink");
     2bc:	bf19                	j	1d2 <main+0x19c>
    fail("failed to stat b");
     2be:	00001517          	auipc	a0,0x1
     2c2:	f7250513          	addi	a0,a0,-142 # 1230 <malloc+0x224>
     2c6:	48f000ef          	jal	f54 <printf>
     2ca:	4785                	li	a5,1
     2cc:	00002717          	auipc	a4,0x2
     2d0:	d2f72a23          	sw	a5,-716(a4) # 2000 <failed>
  int r, fd1 = -1, fd2 = -1;
     2d4:	597d                	li	s2,-1
    fail("failed to stat b");
     2d6:	bdf5                	j	1d2 <main+0x19c>
  fd2 = open("/testsymlink/b", O_RDWR);
     2d8:	4589                	li	a1,2
     2da:	00001517          	auipc	a0,0x1
     2de:	e3e50513          	addi	a0,a0,-450 # 1118 <malloc+0x10c>
     2e2:	065000ef          	jal	b46 <open>
     2e6:	892a                	mv	s2,a0
  if(fd2 < 0)
     2e8:	02054963          	bltz	a0,31a <main+0x2e4>
  read(fd2, &c, 1);
     2ec:	4605                	li	a2,1
     2ee:	f4e40593          	addi	a1,s0,-178
     2f2:	02d000ef          	jal	b1e <read>
  if (c != 'a')
     2f6:	f4e44703          	lbu	a4,-178(s0)
     2fa:	06100793          	li	a5,97
     2fe:	02f70a63          	beq	a4,a5,332 <main+0x2fc>
    fail("failed to read bytes from b");
     302:	00001517          	auipc	a0,0x1
     306:	f8e50513          	addi	a0,a0,-114 # 1290 <malloc+0x284>
     30a:	44b000ef          	jal	f54 <printf>
     30e:	4785                	li	a5,1
     310:	00002717          	auipc	a4,0x2
     314:	cef72823          	sw	a5,-784(a4) # 2000 <failed>
     318:	bd6d                	j	1d2 <main+0x19c>
    fail("failed to open b");
     31a:	00001517          	auipc	a0,0x1
     31e:	f5650513          	addi	a0,a0,-170 # 1270 <malloc+0x264>
     322:	433000ef          	jal	f54 <printf>
     326:	4785                	li	a5,1
     328:	00002717          	auipc	a4,0x2
     32c:	ccf72c23          	sw	a5,-808(a4) # 2000 <failed>
     330:	b54d                	j	1d2 <main+0x19c>
  unlink("/testsymlink/a");
     332:	00001517          	auipc	a0,0x1
     336:	dce50513          	addi	a0,a0,-562 # 1100 <malloc+0xf4>
     33a:	01d000ef          	jal	b56 <unlink>
  if(open("/testsymlink/b", O_RDWR) >= 0)
     33e:	4589                	li	a1,2
     340:	00001517          	auipc	a0,0x1
     344:	dd850513          	addi	a0,a0,-552 # 1118 <malloc+0x10c>
     348:	7fe000ef          	jal	b46 <open>
     34c:	0e055b63          	bgez	a0,442 <main+0x40c>
  r = symlink("/testsymlink/b", "/testsymlink/a");
     350:	00001597          	auipc	a1,0x1
     354:	db058593          	addi	a1,a1,-592 # 1100 <malloc+0xf4>
     358:	00001517          	auipc	a0,0x1
     35c:	dc050513          	addi	a0,a0,-576 # 1118 <malloc+0x10c>
     360:	047000ef          	jal	ba6 <symlink>
  if(r < 0)
     364:	0e054b63          	bltz	a0,45a <main+0x424>
  r = open("/testsymlink/b", O_RDWR);
     368:	4589                	li	a1,2
     36a:	00001517          	auipc	a0,0x1
     36e:	dae50513          	addi	a0,a0,-594 # 1118 <malloc+0x10c>
     372:	7d4000ef          	jal	b46 <open>
  if(r >= 0)
     376:	0e055e63          	bgez	a0,472 <main+0x43c>
  r = symlink("/testsymlink/nonexistent", "/testsymlink/c");
     37a:	00001597          	auipc	a1,0x1
     37e:	dae58593          	addi	a1,a1,-594 # 1128 <malloc+0x11c>
     382:	00001517          	auipc	a0,0x1
     386:	fce50513          	addi	a0,a0,-50 # 1350 <malloc+0x344>
     38a:	01d000ef          	jal	ba6 <symlink>
  if(r != 0)
     38e:	0e051e63          	bnez	a0,48a <main+0x454>
  r = symlink("/testsymlink/2", "/testsymlink/1");
     392:	00001597          	auipc	a1,0x1
     396:	da658593          	addi	a1,a1,-602 # 1138 <malloc+0x12c>
     39a:	00001517          	auipc	a0,0x1
     39e:	dae50513          	addi	a0,a0,-594 # 1148 <malloc+0x13c>
     3a2:	005000ef          	jal	ba6 <symlink>
  if(r) fail("Failed to link 1->2");
     3a6:	0e051e63          	bnez	a0,4a2 <main+0x46c>
  r = symlink("/testsymlink/3", "/testsymlink/2");
     3aa:	00001597          	auipc	a1,0x1
     3ae:	d9e58593          	addi	a1,a1,-610 # 1148 <malloc+0x13c>
     3b2:	00001517          	auipc	a0,0x1
     3b6:	da650513          	addi	a0,a0,-602 # 1158 <malloc+0x14c>
     3ba:	7ec000ef          	jal	ba6 <symlink>
  if(r) fail("Failed to link 2->3");
     3be:	0e051e63          	bnez	a0,4ba <main+0x484>
  r = symlink("/testsymlink/4", "/testsymlink/3");
     3c2:	00001597          	auipc	a1,0x1
     3c6:	d9658593          	addi	a1,a1,-618 # 1158 <malloc+0x14c>
     3ca:	00001517          	auipc	a0,0x1
     3ce:	d9e50513          	addi	a0,a0,-610 # 1168 <malloc+0x15c>
     3d2:	7d4000ef          	jal	ba6 <symlink>
     3d6:	89aa                	mv	s3,a0
  if(r) fail("Failed to link 3->4");
     3d8:	0e051d63          	bnez	a0,4d2 <main+0x49c>
  close(fd1);
     3dc:	8526                	mv	a0,s1
     3de:	750000ef          	jal	b2e <close>
  close(fd2);
     3e2:	854a                	mv	a0,s2
     3e4:	74a000ef          	jal	b2e <close>
  fd1 = open("/testsymlink/4", O_CREATE | O_RDWR);
     3e8:	20200593          	li	a1,514
     3ec:	00001517          	auipc	a0,0x1
     3f0:	d7c50513          	addi	a0,a0,-644 # 1168 <malloc+0x15c>
     3f4:	752000ef          	jal	b46 <open>
     3f8:	84aa                	mv	s1,a0
  if(fd1<0) fail("Failed to create 4\n");
     3fa:	0e054863          	bltz	a0,4ea <main+0x4b4>
  fd2 = open("/testsymlink/1", O_RDWR);
     3fe:	4589                	li	a1,2
     400:	00001517          	auipc	a0,0x1
     404:	d3850513          	addi	a0,a0,-712 # 1138 <malloc+0x12c>
     408:	73e000ef          	jal	b46 <open>
     40c:	892a                	mv	s2,a0
  if(fd2<0) fail("Failed to open 1\n");
     40e:	0e054b63          	bltz	a0,504 <main+0x4ce>
  c = '#';
     412:	02300793          	li	a5,35
     416:	f4f40723          	sb	a5,-178(s0)
  r = write(fd2, &c, 1);
     41a:	4605                	li	a2,1
     41c:	f4e40593          	addi	a1,s0,-178
     420:	706000ef          	jal	b26 <write>
  if(r!=1) fail("Failed to write to 1\n");
     424:	4785                	li	a5,1
     426:	0ef50b63          	beq	a0,a5,51c <main+0x4e6>
     42a:	00001517          	auipc	a0,0x1
     42e:	02650513          	addi	a0,a0,38 # 1450 <malloc+0x444>
     432:	323000ef          	jal	f54 <printf>
     436:	4785                	li	a5,1
     438:	00002717          	auipc	a4,0x2
     43c:	bcf72423          	sw	a5,-1080(a4) # 2000 <failed>
     440:	bb49                	j	1d2 <main+0x19c>
    fail("Should not be able to open b after deleting a");
     442:	00001517          	auipc	a0,0x1
     446:	e7650513          	addi	a0,a0,-394 # 12b8 <malloc+0x2ac>
     44a:	30b000ef          	jal	f54 <printf>
     44e:	4785                	li	a5,1
     450:	00002717          	auipc	a4,0x2
     454:	baf72823          	sw	a5,-1104(a4) # 2000 <failed>
     458:	bbad                	j	1d2 <main+0x19c>
    fail("symlink a -> b failed");
     45a:	00001517          	auipc	a0,0x1
     45e:	e9650513          	addi	a0,a0,-362 # 12f0 <malloc+0x2e4>
     462:	2f3000ef          	jal	f54 <printf>
     466:	4785                	li	a5,1
     468:	00002717          	auipc	a4,0x2
     46c:	b8f72c23          	sw	a5,-1128(a4) # 2000 <failed>
     470:	b38d                	j	1d2 <main+0x19c>
    fail("Should not be able to open b (cycle b->a->b->..)\n");
     472:	00001517          	auipc	a0,0x1
     476:	e9e50513          	addi	a0,a0,-354 # 1310 <malloc+0x304>
     47a:	2db000ef          	jal	f54 <printf>
     47e:	4785                	li	a5,1
     480:	00002717          	auipc	a4,0x2
     484:	b8f72023          	sw	a5,-1152(a4) # 2000 <failed>
     488:	b3a9                	j	1d2 <main+0x19c>
    fail("Symlinking to nonexistent file should succeed\n");
     48a:	00001517          	auipc	a0,0x1
     48e:	ee650513          	addi	a0,a0,-282 # 1370 <malloc+0x364>
     492:	2c3000ef          	jal	f54 <printf>
     496:	4785                	li	a5,1
     498:	00002717          	auipc	a4,0x2
     49c:	b6f72423          	sw	a5,-1176(a4) # 2000 <failed>
     4a0:	bb0d                	j	1d2 <main+0x19c>
  if(r) fail("Failed to link 1->2");
     4a2:	00001517          	auipc	a0,0x1
     4a6:	f0e50513          	addi	a0,a0,-242 # 13b0 <malloc+0x3a4>
     4aa:	2ab000ef          	jal	f54 <printf>
     4ae:	4785                	li	a5,1
     4b0:	00002717          	auipc	a4,0x2
     4b4:	b4f72823          	sw	a5,-1200(a4) # 2000 <failed>
     4b8:	bb29                	j	1d2 <main+0x19c>
  if(r) fail("Failed to link 2->3");
     4ba:	00001517          	auipc	a0,0x1
     4be:	f1650513          	addi	a0,a0,-234 # 13d0 <malloc+0x3c4>
     4c2:	293000ef          	jal	f54 <printf>
     4c6:	4785                	li	a5,1
     4c8:	00002717          	auipc	a4,0x2
     4cc:	b2f72c23          	sw	a5,-1224(a4) # 2000 <failed>
     4d0:	b309                	j	1d2 <main+0x19c>
  if(r) fail("Failed to link 3->4");
     4d2:	00001517          	auipc	a0,0x1
     4d6:	f1e50513          	addi	a0,a0,-226 # 13f0 <malloc+0x3e4>
     4da:	27b000ef          	jal	f54 <printf>
     4de:	4785                	li	a5,1
     4e0:	00002717          	auipc	a4,0x2
     4e4:	b2f72023          	sw	a5,-1248(a4) # 2000 <failed>
     4e8:	b1ed                	j	1d2 <main+0x19c>
  if(fd1<0) fail("Failed to create 4\n");
     4ea:	00001517          	auipc	a0,0x1
     4ee:	f2650513          	addi	a0,a0,-218 # 1410 <malloc+0x404>
     4f2:	263000ef          	jal	f54 <printf>
     4f6:	4785                	li	a5,1
     4f8:	00002717          	auipc	a4,0x2
     4fc:	b0f72423          	sw	a5,-1272(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     500:	597d                	li	s2,-1
  if(fd1<0) fail("Failed to create 4\n");
     502:	b9c1                	j	1d2 <main+0x19c>
  if(fd2<0) fail("Failed to open 1\n");
     504:	00001517          	auipc	a0,0x1
     508:	f2c50513          	addi	a0,a0,-212 # 1430 <malloc+0x424>
     50c:	249000ef          	jal	f54 <printf>
     510:	4785                	li	a5,1
     512:	00002717          	auipc	a4,0x2
     516:	aef72723          	sw	a5,-1298(a4) # 2000 <failed>
     51a:	b965                	j	1d2 <main+0x19c>
  r = read(fd1, &c2, 1);
     51c:	4605                	li	a2,1
     51e:	f4f40593          	addi	a1,s0,-177
     522:	8526                	mv	a0,s1
     524:	5fa000ef          	jal	b1e <read>
  if(r!=1) fail("Failed to read from 4\n");
     528:	4785                	li	a5,1
     52a:	02f51463          	bne	a0,a5,552 <main+0x51c>
  if(c!=c2)
     52e:	f4e44703          	lbu	a4,-178(s0)
     532:	f4f44783          	lbu	a5,-177(s0)
     536:	02f70a63          	beq	a4,a5,56a <main+0x534>
    fail("Value read from 4 differed from value written to 1\n");
     53a:	00001517          	auipc	a0,0x1
     53e:	f5e50513          	addi	a0,a0,-162 # 1498 <malloc+0x48c>
     542:	213000ef          	jal	f54 <printf>
     546:	4785                	li	a5,1
     548:	00002717          	auipc	a4,0x2
     54c:	aaf72c23          	sw	a5,-1352(a4) # 2000 <failed>
     550:	b149                	j	1d2 <main+0x19c>
  if(r!=1) fail("Failed to read from 4\n");
     552:	00001517          	auipc	a0,0x1
     556:	f1e50513          	addi	a0,a0,-226 # 1470 <malloc+0x464>
     55a:	1fb000ef          	jal	f54 <printf>
     55e:	4785                	li	a5,1
     560:	00002717          	auipc	a4,0x2
     564:	aaf72023          	sw	a5,-1376(a4) # 2000 <failed>
     568:	b1ad                	j	1d2 <main+0x19c>
  close(fd1);
     56a:	8526                	mv	a0,s1
     56c:	5c2000ef          	jal	b2e <close>
  close(fd2);
     570:	854a                	mv	a0,s2
     572:	5bc000ef          	jal	b2e <close>
    memset(name, 0, sizeof(name));
     576:	f8040a13          	addi	s4,s0,-128
     57a:	02000c13          	li	s8,32
    strcpy(name, base);
     57e:	00001497          	auipc	s1,0x1
     582:	c1a48493          	addi	s1,s1,-998 # 1198 <malloc+0x18c>
    name[strlen(base)+0] = 'a' + (i / 26);
     586:	4ae9                	li	s5,26
    r = symlink("/testsymlink/4", name);
     588:	00001b97          	auipc	s7,0x1
     58c:	be0b8b93          	addi	s7,s7,-1056 # 1168 <malloc+0x15c>
  for(int i = 0; i < NINODE+2; i++){
     590:	03400b13          	li	s6,52
    memset(name, 0, sizeof(name));
     594:	8662                	mv	a2,s8
     596:	4581                	li	a1,0
     598:	8552                	mv	a0,s4
     59a:	342000ef          	jal	8dc <memset>
    strcpy(name, base);
     59e:	85a6                	mv	a1,s1
     5a0:	8552                	mv	a0,s4
     5a2:	2be000ef          	jal	860 <strcpy>
    name[strlen(base)+0] = 'a' + (i / 26);
     5a6:	8526                	mv	a0,s1
     5a8:	308000ef          	jal	8b0 <strlen>
     5ac:	02051793          	slli	a5,a0,0x20
     5b0:	9381                	srli	a5,a5,0x20
     5b2:	fa078793          	addi	a5,a5,-96
     5b6:	97a2                	add	a5,a5,s0
     5b8:	0359c73b          	divw	a4,s3,s5
     5bc:	0617071b          	addiw	a4,a4,97
     5c0:	fee78023          	sb	a4,-32(a5)
    name[strlen(base)+1] = 'a' + (i % 26);
     5c4:	8526                	mv	a0,s1
     5c6:	2ea000ef          	jal	8b0 <strlen>
     5ca:	0015079b          	addiw	a5,a0,1
     5ce:	1782                	slli	a5,a5,0x20
     5d0:	9381                	srli	a5,a5,0x20
     5d2:	fa078793          	addi	a5,a5,-96
     5d6:	97a2                	add	a5,a5,s0
     5d8:	0359e73b          	remw	a4,s3,s5
     5dc:	0617071b          	addiw	a4,a4,97
     5e0:	fee78023          	sb	a4,-32(a5)
    r = symlink("/testsymlink/4", name);
     5e4:	85d2                	mv	a1,s4
     5e6:	855e                	mv	a0,s7
     5e8:	5be000ef          	jal	ba6 <symlink>
     5ec:	892a                	mv	s2,a0
    if(r) fail("symlink() failed in many test");
     5ee:	0e051f63          	bnez	a0,6ec <main+0x6b6>
  for(int i = 0; i < NINODE+2; i++){
     5f2:	2985                	addiw	s3,s3,1
     5f4:	fb6990e3          	bne	s3,s6,594 <main+0x55e>
     5f8:	f4e6                	sd	s9,104(sp)
    memset(name, 0, sizeof(name));
     5fa:	f8040a13          	addi	s4,s0,-128
     5fe:	02000c93          	li	s9,32
    strcpy(name, base);
     602:	00001997          	auipc	s3,0x1
     606:	b9698993          	addi	s3,s3,-1130 # 1198 <malloc+0x18c>
    name[strlen(base)+0] = 'a' + (i / 26);
     60a:	4ae9                	li	s5,26
    if(read(fd1, buf, sizeof(buf)) != 1)
     60c:	f5840c13          	addi	s8,s0,-168
     610:	4bc1                	li	s7,16
     612:	4b05                	li	s6,1
    memset(name, 0, sizeof(name));
     614:	8666                	mv	a2,s9
     616:	4581                	li	a1,0
     618:	8552                	mv	a0,s4
     61a:	2c2000ef          	jal	8dc <memset>
    strcpy(name, base);
     61e:	85ce                	mv	a1,s3
     620:	8552                	mv	a0,s4
     622:	23e000ef          	jal	860 <strcpy>
    name[strlen(base)+0] = 'a' + (i / 26);
     626:	854e                	mv	a0,s3
     628:	288000ef          	jal	8b0 <strlen>
     62c:	02051793          	slli	a5,a0,0x20
     630:	9381                	srli	a5,a5,0x20
     632:	fa078793          	addi	a5,a5,-96
     636:	97a2                	add	a5,a5,s0
     638:	0359473b          	divw	a4,s2,s5
     63c:	0617071b          	addiw	a4,a4,97
     640:	fee78023          	sb	a4,-32(a5)
    name[strlen(base)+1] = 'a' + (i % 26);
     644:	854e                	mv	a0,s3
     646:	26a000ef          	jal	8b0 <strlen>
     64a:	0015079b          	addiw	a5,a0,1
     64e:	1782                	slli	a5,a5,0x20
     650:	9381                	srli	a5,a5,0x20
     652:	fa078793          	addi	a5,a5,-96
     656:	97a2                	add	a5,a5,s0
     658:	0359673b          	remw	a4,s2,s5
     65c:	0617071b          	addiw	a4,a4,97
     660:	fee78023          	sb	a4,-32(a5)
    fd1 = open(name, O_RDONLY);
     664:	4581                	li	a1,0
     666:	8552                	mv	a0,s4
     668:	4de000ef          	jal	b46 <open>
     66c:	84aa                	mv	s1,a0
    if(fd1 < 0)
     66e:	08054d63          	bltz	a0,708 <main+0x6d2>
    buf[0] = '\0';
     672:	f4040c23          	sb	zero,-168(s0)
    if(read(fd1, buf, sizeof(buf)) != 1)
     676:	865e                	mv	a2,s7
     678:	85e2                	mv	a1,s8
     67a:	4a4000ef          	jal	b1e <read>
     67e:	0b651363          	bne	a0,s6,724 <main+0x6ee>
    if(buf[0] != '#')
     682:	f5844703          	lbu	a4,-168(s0)
     686:	02300793          	li	a5,35
     68a:	0af71463          	bne	a4,a5,732 <main+0x6fc>
    close(fd1);
     68e:	8526                	mv	a0,s1
     690:	49e000ef          	jal	b2e <close>
  for(int i = 0; i < NINODE+2; i++){
     694:	2905                	addiw	s2,s2,1
     696:	03400793          	li	a5,52
     69a:	f6f91de3          	bne	s2,a5,614 <main+0x5de>
  unlink("/testsymlink/a");
     69e:	00001517          	auipc	a0,0x1
     6a2:	a6250513          	addi	a0,a0,-1438 # 1100 <malloc+0xf4>
     6a6:	4b0000ef          	jal	b56 <unlink>
  if(symlink("/README", "/testsymlink/a") != 0)
     6aa:	00001597          	auipc	a1,0x1
     6ae:	a5658593          	addi	a1,a1,-1450 # 1100 <malloc+0xf4>
     6b2:	00001517          	auipc	a0,0x1
     6b6:	ec650513          	addi	a0,a0,-314 # 1578 <malloc+0x56c>
     6ba:	4ec000ef          	jal	ba6 <symlink>
     6be:	e149                	bnez	a0,740 <main+0x70a>
  fd1 = open("/testsymlink/a", O_RDONLY);
     6c0:	4581                	li	a1,0
     6c2:	00001517          	auipc	a0,0x1
     6c6:	a3e50513          	addi	a0,a0,-1474 # 1100 <malloc+0xf4>
     6ca:	47c000ef          	jal	b46 <open>
     6ce:	84aa                	mv	s1,a0
  if(fd1 < 0)
     6d0:	08054763          	bltz	a0,75e <main+0x728>
  close(fd1);
     6d4:	45a000ef          	jal	b2e <close>
  printf("test symlinks: ok\n");
     6d8:	00001517          	auipc	a0,0x1
     6dc:	f0850513          	addi	a0,a0,-248 # 15e0 <malloc+0x5d4>
     6e0:	075000ef          	jal	f54 <printf>
  fd1 = fd2 = -1;
     6e4:	54fd                	li	s1,-1
  fd1 = -1;
     6e6:	8926                	mv	s2,s1
     6e8:	7ca6                	ld	s9,104(sp)
     6ea:	b4e5                	j	1d2 <main+0x19c>
    if(r) fail("symlink() failed in many test");
     6ec:	00001517          	auipc	a0,0x1
     6f0:	dec50513          	addi	a0,a0,-532 # 14d8 <malloc+0x4cc>
     6f4:	061000ef          	jal	f54 <printf>
     6f8:	4785                	li	a5,1
     6fa:	00002717          	auipc	a4,0x2
     6fe:	90f72323          	sw	a5,-1786(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     702:	597d                	li	s2,-1
     704:	84ca                	mv	s1,s2
     706:	b4f1                	j	1d2 <main+0x19c>
      fail("open() failed in many test");
     708:	00001517          	auipc	a0,0x1
     70c:	df850513          	addi	a0,a0,-520 # 1500 <malloc+0x4f4>
     710:	045000ef          	jal	f54 <printf>
     714:	4785                	li	a5,1
     716:	00002717          	auipc	a4,0x2
     71a:	8ef72523          	sw	a5,-1814(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     71e:	597d                	li	s2,-1
     720:	7ca6                	ld	s9,104(sp)
     722:	bc45                	j	1d2 <main+0x19c>
      fail("read() failed in many test");
     724:	00001517          	auipc	a0,0x1
     728:	e0450513          	addi	a0,a0,-508 # 1528 <malloc+0x51c>
     72c:	029000ef          	jal	f54 <printf>
     730:	b7d5                	j	714 <main+0x6de>
      fail("wrong content in many test");
     732:	00001517          	auipc	a0,0x1
     736:	e1e50513          	addi	a0,a0,-482 # 1550 <malloc+0x544>
     73a:	01b000ef          	jal	f54 <printf>
     73e:	bfd9                	j	714 <main+0x6de>
    fail("could not link to /README");
     740:	00001517          	auipc	a0,0x1
     744:	e4050513          	addi	a0,a0,-448 # 1580 <malloc+0x574>
     748:	00d000ef          	jal	f54 <printf>
     74c:	4785                	li	a5,1
     74e:	00002717          	auipc	a4,0x2
     752:	8af72923          	sw	a5,-1870(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     756:	597d                	li	s2,-1
    fail("could not link to /README");
     758:	84ca                	mv	s1,s2
     75a:	7ca6                	ld	s9,104(sp)
     75c:	bc9d                	j	1d2 <main+0x19c>
    fail("could not open symlink pointing to /README");
     75e:	00001517          	auipc	a0,0x1
     762:	e4a50513          	addi	a0,a0,-438 # 15a8 <malloc+0x59c>
     766:	7ee000ef          	jal	f54 <printf>
     76a:	4785                	li	a5,1
     76c:	00002717          	auipc	a4,0x2
     770:	88f72a23          	sw	a5,-1900(a4) # 2000 <failed>
  fd1 = fd2 = -1;
     774:	597d                	li	s2,-1
    fail("could not open symlink pointing to /README");
     776:	7ca6                	ld	s9,104(sp)
     778:	bca9                	j	1d2 <main+0x19c>
     77a:	f4e6                	sd	s9,104(sp)
    printf("FAILED: open failed");
     77c:	00001517          	auipc	a0,0x1
     780:	ea450513          	addi	a0,a0,-348 # 1620 <malloc+0x614>
     784:	7d0000ef          	jal	f54 <printf>
    exit(1);
     788:	4505                	li	a0,1
     78a:	37c000ef          	jal	b06 <exit>
     78e:	f4e6                	sd	s9,104(sp)
      printf("FAILED: fork failed\n");
     790:	00001517          	auipc	a0,0x1
     794:	ea850513          	addi	a0,a0,-344 # 1638 <malloc+0x62c>
     798:	7bc000ef          	jal	f54 <printf>
      exit(1);
     79c:	4505                	li	a0,1
     79e:	368000ef          	jal	b06 <exit>
     7a2:	f4e6                	sd	s9,104(sp)
  fd1 = -1;
     7a4:	06400493          	li	s1,100
     7a8:	06100c93          	li	s9,97
        x = x * 1103515245 + 12345;
     7ac:	41c65ab7          	lui	s5,0x41c65
     7b0:	e6da8a9b          	addiw	s5,s5,-403 # 41c64e6d <base+0x41c62e5d>
     7b4:	6a0d                	lui	s4,0x3
     7b6:	039a0a1b          	addiw	s4,s4,57 # 3039 <base+0x1029>
        if((x % 3) == 0) {
     7ba:	000ab9b7          	lui	s3,0xab
     7be:	aab98993          	addi	s3,s3,-1365 # aaaab <base+0xa8a9b>
     7c2:	09b2                	slli	s3,s3,0xc
     7c4:	aab98993          	addi	s3,s3,-1365
          unlink("/testsymlink/y");
     7c8:	00001917          	auipc	s2,0x1
     7cc:	9c090913          	addi	s2,s2,-1600 # 1188 <malloc+0x17c>
          symlink("/testsymlink/z", "/testsymlink/y");
     7d0:	00001b97          	auipc	s7,0x1
     7d4:	9a8b8b93          	addi	s7,s7,-1624 # 1178 <malloc+0x16c>
          if (stat_slink("/testsymlink/y", &st) == 0) {
     7d8:	f8040b13          	addi	s6,s0,-128
            if(st.type != T_SYMLINK) {
     7dc:	4c11                	li	s8,4
     7de:	a031                	j	7ea <main+0x7b4>
          unlink("/testsymlink/y");
     7e0:	854a                	mv	a0,s2
     7e2:	374000ef          	jal	b56 <unlink>
      for(i = 0; i < 100; i++){
     7e6:	34fd                	addiw	s1,s1,-1
     7e8:	c4b9                	beqz	s1,836 <main+0x800>
        x = x * 1103515245 + 12345;
     7ea:	035c87bb          	mulw	a5,s9,s5
     7ee:	00fa07bb          	addw	a5,s4,a5
     7f2:	8cbe                	mv	s9,a5
        if((x % 3) == 0) {
     7f4:	02079713          	slli	a4,a5,0x20
     7f8:	9301                	srli	a4,a4,0x20
     7fa:	03370733          	mul	a4,a4,s3
     7fe:	9305                	srli	a4,a4,0x21
     800:	0017169b          	slliw	a3,a4,0x1
     804:	9f35                	addw	a4,a4,a3
     806:	9f99                	subw	a5,a5,a4
     808:	ffe1                	bnez	a5,7e0 <main+0x7aa>
          symlink("/testsymlink/z", "/testsymlink/y");
     80a:	85ca                	mv	a1,s2
     80c:	855e                	mv	a0,s7
     80e:	398000ef          	jal	ba6 <symlink>
          if (stat_slink("/testsymlink/y", &st) == 0) {
     812:	85da                	mv	a1,s6
     814:	854a                	mv	a0,s2
     816:	feaff0ef          	jal	0 <stat_slink>
     81a:	f571                	bnez	a0,7e6 <main+0x7b0>
            if(st.type != T_SYMLINK) {
     81c:	f8841583          	lh	a1,-120(s0)
     820:	fd8583e3          	beq	a1,s8,7e6 <main+0x7b0>
              printf("FAILED: type %d not a symbolic link\n", st.type);
     824:	00001517          	auipc	a0,0x1
     828:	e2c50513          	addi	a0,a0,-468 # 1650 <malloc+0x644>
     82c:	728000ef          	jal	f54 <printf>
              exit(1);
     830:	4505                	li	a0,1
     832:	2d4000ef          	jal	b06 <exit>
      exit(0);
     836:	4501                	li	a0,0
     838:	2ce000ef          	jal	b06 <exit>
     83c:	f4e6                	sd	s9,104(sp)
      printf("test concurrent symlinks: failed\n");
     83e:	00001517          	auipc	a0,0x1
     842:	e3a50513          	addi	a0,a0,-454 # 1678 <malloc+0x66c>
     846:	70e000ef          	jal	f54 <printf>
      exit(1);
     84a:	4505                	li	a0,1
     84c:	2ba000ef          	jal	b06 <exit>

0000000000000850 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     850:	1141                	addi	sp,sp,-16
     852:	e406                	sd	ra,8(sp)
     854:	e022                	sd	s0,0(sp)
     856:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     858:	fdeff0ef          	jal	36 <main>
  exit(r);
     85c:	2aa000ef          	jal	b06 <exit>

0000000000000860 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     860:	1141                	addi	sp,sp,-16
     862:	e406                	sd	ra,8(sp)
     864:	e022                	sd	s0,0(sp)
     866:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     868:	87aa                	mv	a5,a0
     86a:	0585                	addi	a1,a1,1
     86c:	0785                	addi	a5,a5,1
     86e:	fff5c703          	lbu	a4,-1(a1)
     872:	fee78fa3          	sb	a4,-1(a5)
     876:	fb75                	bnez	a4,86a <strcpy+0xa>
    ;
  return os;
}
     878:	60a2                	ld	ra,8(sp)
     87a:	6402                	ld	s0,0(sp)
     87c:	0141                	addi	sp,sp,16
     87e:	8082                	ret

0000000000000880 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     880:	1141                	addi	sp,sp,-16
     882:	e406                	sd	ra,8(sp)
     884:	e022                	sd	s0,0(sp)
     886:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     888:	00054783          	lbu	a5,0(a0)
     88c:	cb91                	beqz	a5,8a0 <strcmp+0x20>
     88e:	0005c703          	lbu	a4,0(a1)
     892:	00f71763          	bne	a4,a5,8a0 <strcmp+0x20>
    p++, q++;
     896:	0505                	addi	a0,a0,1
     898:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     89a:	00054783          	lbu	a5,0(a0)
     89e:	fbe5                	bnez	a5,88e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     8a0:	0005c503          	lbu	a0,0(a1)
}
     8a4:	40a7853b          	subw	a0,a5,a0
     8a8:	60a2                	ld	ra,8(sp)
     8aa:	6402                	ld	s0,0(sp)
     8ac:	0141                	addi	sp,sp,16
     8ae:	8082                	ret

00000000000008b0 <strlen>:

uint
strlen(const char *s)
{
     8b0:	1141                	addi	sp,sp,-16
     8b2:	e406                	sd	ra,8(sp)
     8b4:	e022                	sd	s0,0(sp)
     8b6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     8b8:	00054783          	lbu	a5,0(a0)
     8bc:	cf91                	beqz	a5,8d8 <strlen+0x28>
     8be:	00150793          	addi	a5,a0,1
     8c2:	86be                	mv	a3,a5
     8c4:	0785                	addi	a5,a5,1
     8c6:	fff7c703          	lbu	a4,-1(a5)
     8ca:	ff65                	bnez	a4,8c2 <strlen+0x12>
     8cc:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     8d0:	60a2                	ld	ra,8(sp)
     8d2:	6402                	ld	s0,0(sp)
     8d4:	0141                	addi	sp,sp,16
     8d6:	8082                	ret
  for(n = 0; s[n]; n++)
     8d8:	4501                	li	a0,0
     8da:	bfdd                	j	8d0 <strlen+0x20>

00000000000008dc <memset>:

void*
memset(void *dst, int c, uint n)
{
     8dc:	1141                	addi	sp,sp,-16
     8de:	e406                	sd	ra,8(sp)
     8e0:	e022                	sd	s0,0(sp)
     8e2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     8e4:	ca19                	beqz	a2,8fa <memset+0x1e>
     8e6:	87aa                	mv	a5,a0
     8e8:	1602                	slli	a2,a2,0x20
     8ea:	9201                	srli	a2,a2,0x20
     8ec:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     8f0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     8f4:	0785                	addi	a5,a5,1
     8f6:	fee79de3          	bne	a5,a4,8f0 <memset+0x14>
  }
  return dst;
}
     8fa:	60a2                	ld	ra,8(sp)
     8fc:	6402                	ld	s0,0(sp)
     8fe:	0141                	addi	sp,sp,16
     900:	8082                	ret

0000000000000902 <strchr>:

char*
strchr(const char *s, char c)
{
     902:	1141                	addi	sp,sp,-16
     904:	e406                	sd	ra,8(sp)
     906:	e022                	sd	s0,0(sp)
     908:	0800                	addi	s0,sp,16
  for(; *s; s++)
     90a:	00054783          	lbu	a5,0(a0)
     90e:	cf81                	beqz	a5,926 <strchr+0x24>
    if(*s == c)
     910:	00f58763          	beq	a1,a5,91e <strchr+0x1c>
  for(; *s; s++)
     914:	0505                	addi	a0,a0,1
     916:	00054783          	lbu	a5,0(a0)
     91a:	fbfd                	bnez	a5,910 <strchr+0xe>
      return (char*)s;
  return 0;
     91c:	4501                	li	a0,0
}
     91e:	60a2                	ld	ra,8(sp)
     920:	6402                	ld	s0,0(sp)
     922:	0141                	addi	sp,sp,16
     924:	8082                	ret
  return 0;
     926:	4501                	li	a0,0
     928:	bfdd                	j	91e <strchr+0x1c>

000000000000092a <gets>:

char*
gets(char *buf, int max)
{
     92a:	711d                	addi	sp,sp,-96
     92c:	ec86                	sd	ra,88(sp)
     92e:	e8a2                	sd	s0,80(sp)
     930:	e4a6                	sd	s1,72(sp)
     932:	e0ca                	sd	s2,64(sp)
     934:	fc4e                	sd	s3,56(sp)
     936:	f852                	sd	s4,48(sp)
     938:	f456                	sd	s5,40(sp)
     93a:	f05a                	sd	s6,32(sp)
     93c:	ec5e                	sd	s7,24(sp)
     93e:	e862                	sd	s8,16(sp)
     940:	1080                	addi	s0,sp,96
     942:	8baa                	mv	s7,a0
     944:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     946:	892a                	mv	s2,a0
     948:	4481                	li	s1,0
    cc = read(0, &c, 1);
     94a:	faf40b13          	addi	s6,s0,-81
     94e:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     950:	8c26                	mv	s8,s1
     952:	0014899b          	addiw	s3,s1,1
     956:	84ce                	mv	s1,s3
     958:	0349d463          	bge	s3,s4,980 <gets+0x56>
    cc = read(0, &c, 1);
     95c:	8656                	mv	a2,s5
     95e:	85da                	mv	a1,s6
     960:	4501                	li	a0,0
     962:	1bc000ef          	jal	b1e <read>
    if(cc < 1)
     966:	00a05d63          	blez	a0,980 <gets+0x56>
      break;
    buf[i++] = c;
     96a:	faf44783          	lbu	a5,-81(s0)
     96e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     972:	0905                	addi	s2,s2,1
     974:	ff678713          	addi	a4,a5,-10
     978:	c319                	beqz	a4,97e <gets+0x54>
     97a:	17cd                	addi	a5,a5,-13
     97c:	fbf1                	bnez	a5,950 <gets+0x26>
    buf[i++] = c;
     97e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     980:	9c5e                	add	s8,s8,s7
     982:	000c0023          	sb	zero,0(s8)
  return buf;
}
     986:	855e                	mv	a0,s7
     988:	60e6                	ld	ra,88(sp)
     98a:	6446                	ld	s0,80(sp)
     98c:	64a6                	ld	s1,72(sp)
     98e:	6906                	ld	s2,64(sp)
     990:	79e2                	ld	s3,56(sp)
     992:	7a42                	ld	s4,48(sp)
     994:	7aa2                	ld	s5,40(sp)
     996:	7b02                	ld	s6,32(sp)
     998:	6be2                	ld	s7,24(sp)
     99a:	6c42                	ld	s8,16(sp)
     99c:	6125                	addi	sp,sp,96
     99e:	8082                	ret

00000000000009a0 <stat>:

int
stat(const char *n, struct stat *st)
{
     9a0:	1101                	addi	sp,sp,-32
     9a2:	ec06                	sd	ra,24(sp)
     9a4:	e822                	sd	s0,16(sp)
     9a6:	e04a                	sd	s2,0(sp)
     9a8:	1000                	addi	s0,sp,32
     9aa:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     9ac:	4581                	li	a1,0
     9ae:	198000ef          	jal	b46 <open>
  if(fd < 0)
     9b2:	02054263          	bltz	a0,9d6 <stat+0x36>
     9b6:	e426                	sd	s1,8(sp)
     9b8:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     9ba:	85ca                	mv	a1,s2
     9bc:	1a2000ef          	jal	b5e <fstat>
     9c0:	892a                	mv	s2,a0
  close(fd);
     9c2:	8526                	mv	a0,s1
     9c4:	16a000ef          	jal	b2e <close>
  return r;
     9c8:	64a2                	ld	s1,8(sp)
}
     9ca:	854a                	mv	a0,s2
     9cc:	60e2                	ld	ra,24(sp)
     9ce:	6442                	ld	s0,16(sp)
     9d0:	6902                	ld	s2,0(sp)
     9d2:	6105                	addi	sp,sp,32
     9d4:	8082                	ret
    return -1;
     9d6:	57fd                	li	a5,-1
     9d8:	893e                	mv	s2,a5
     9da:	bfc5                	j	9ca <stat+0x2a>

00000000000009dc <atoi>:

int
atoi(const char *s)
{
     9dc:	1141                	addi	sp,sp,-16
     9de:	e406                	sd	ra,8(sp)
     9e0:	e022                	sd	s0,0(sp)
     9e2:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     9e4:	00054683          	lbu	a3,0(a0)
     9e8:	fd06879b          	addiw	a5,a3,-48
     9ec:	0ff7f793          	zext.b	a5,a5
     9f0:	4625                	li	a2,9
     9f2:	02f66963          	bltu	a2,a5,a24 <atoi+0x48>
     9f6:	872a                	mv	a4,a0
  n = 0;
     9f8:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     9fa:	0705                	addi	a4,a4,1
     9fc:	0025179b          	slliw	a5,a0,0x2
     a00:	9fa9                	addw	a5,a5,a0
     a02:	0017979b          	slliw	a5,a5,0x1
     a06:	9fb5                	addw	a5,a5,a3
     a08:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     a0c:	00074683          	lbu	a3,0(a4)
     a10:	fd06879b          	addiw	a5,a3,-48
     a14:	0ff7f793          	zext.b	a5,a5
     a18:	fef671e3          	bgeu	a2,a5,9fa <atoi+0x1e>
  return n;
}
     a1c:	60a2                	ld	ra,8(sp)
     a1e:	6402                	ld	s0,0(sp)
     a20:	0141                	addi	sp,sp,16
     a22:	8082                	ret
  n = 0;
     a24:	4501                	li	a0,0
     a26:	bfdd                	j	a1c <atoi+0x40>

0000000000000a28 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     a28:	1141                	addi	sp,sp,-16
     a2a:	e406                	sd	ra,8(sp)
     a2c:	e022                	sd	s0,0(sp)
     a2e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     a30:	02b57563          	bgeu	a0,a1,a5a <memmove+0x32>
    while(n-- > 0)
     a34:	00c05f63          	blez	a2,a52 <memmove+0x2a>
     a38:	1602                	slli	a2,a2,0x20
     a3a:	9201                	srli	a2,a2,0x20
     a3c:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     a40:	872a                	mv	a4,a0
      *dst++ = *src++;
     a42:	0585                	addi	a1,a1,1
     a44:	0705                	addi	a4,a4,1
     a46:	fff5c683          	lbu	a3,-1(a1)
     a4a:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     a4e:	fee79ae3          	bne	a5,a4,a42 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     a52:	60a2                	ld	ra,8(sp)
     a54:	6402                	ld	s0,0(sp)
     a56:	0141                	addi	sp,sp,16
     a58:	8082                	ret
    while(n-- > 0)
     a5a:	fec05ce3          	blez	a2,a52 <memmove+0x2a>
    dst += n;
     a5e:	00c50733          	add	a4,a0,a2
    src += n;
     a62:	95b2                	add	a1,a1,a2
     a64:	fff6079b          	addiw	a5,a2,-1
     a68:	1782                	slli	a5,a5,0x20
     a6a:	9381                	srli	a5,a5,0x20
     a6c:	fff7c793          	not	a5,a5
     a70:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     a72:	15fd                	addi	a1,a1,-1
     a74:	177d                	addi	a4,a4,-1
     a76:	0005c683          	lbu	a3,0(a1)
     a7a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     a7e:	fef71ae3          	bne	a4,a5,a72 <memmove+0x4a>
     a82:	bfc1                	j	a52 <memmove+0x2a>

0000000000000a84 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     a84:	1141                	addi	sp,sp,-16
     a86:	e406                	sd	ra,8(sp)
     a88:	e022                	sd	s0,0(sp)
     a8a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     a8c:	c61d                	beqz	a2,aba <memcmp+0x36>
     a8e:	1602                	slli	a2,a2,0x20
     a90:	9201                	srli	a2,a2,0x20
     a92:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     a96:	00054783          	lbu	a5,0(a0)
     a9a:	0005c703          	lbu	a4,0(a1)
     a9e:	00e79863          	bne	a5,a4,aae <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     aa2:	0505                	addi	a0,a0,1
    p2++;
     aa4:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     aa6:	fed518e3          	bne	a0,a3,a96 <memcmp+0x12>
  }
  return 0;
     aaa:	4501                	li	a0,0
     aac:	a019                	j	ab2 <memcmp+0x2e>
      return *p1 - *p2;
     aae:	40e7853b          	subw	a0,a5,a4
}
     ab2:	60a2                	ld	ra,8(sp)
     ab4:	6402                	ld	s0,0(sp)
     ab6:	0141                	addi	sp,sp,16
     ab8:	8082                	ret
  return 0;
     aba:	4501                	li	a0,0
     abc:	bfdd                	j	ab2 <memcmp+0x2e>

0000000000000abe <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     abe:	1141                	addi	sp,sp,-16
     ac0:	e406                	sd	ra,8(sp)
     ac2:	e022                	sd	s0,0(sp)
     ac4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     ac6:	f63ff0ef          	jal	a28 <memmove>
}
     aca:	60a2                	ld	ra,8(sp)
     acc:	6402                	ld	s0,0(sp)
     ace:	0141                	addi	sp,sp,16
     ad0:	8082                	ret

0000000000000ad2 <sbrk>:

char *
sbrk(int n) {
     ad2:	1141                	addi	sp,sp,-16
     ad4:	e406                	sd	ra,8(sp)
     ad6:	e022                	sd	s0,0(sp)
     ad8:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     ada:	4585                	li	a1,1
     adc:	0b2000ef          	jal	b8e <sys_sbrk>
}
     ae0:	60a2                	ld	ra,8(sp)
     ae2:	6402                	ld	s0,0(sp)
     ae4:	0141                	addi	sp,sp,16
     ae6:	8082                	ret

0000000000000ae8 <sbrklazy>:

char *
sbrklazy(int n) {
     ae8:	1141                	addi	sp,sp,-16
     aea:	e406                	sd	ra,8(sp)
     aec:	e022                	sd	s0,0(sp)
     aee:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     af0:	4589                	li	a1,2
     af2:	09c000ef          	jal	b8e <sys_sbrk>
}
     af6:	60a2                	ld	ra,8(sp)
     af8:	6402                	ld	s0,0(sp)
     afa:	0141                	addi	sp,sp,16
     afc:	8082                	ret

0000000000000afe <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     afe:	4885                	li	a7,1
 ecall
     b00:	00000073          	ecall
 ret
     b04:	8082                	ret

0000000000000b06 <exit>:
.global exit
exit:
 li a7, SYS_exit
     b06:	4889                	li	a7,2
 ecall
     b08:	00000073          	ecall
 ret
     b0c:	8082                	ret

0000000000000b0e <wait>:
.global wait
wait:
 li a7, SYS_wait
     b0e:	488d                	li	a7,3
 ecall
     b10:	00000073          	ecall
 ret
     b14:	8082                	ret

0000000000000b16 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     b16:	4891                	li	a7,4
 ecall
     b18:	00000073          	ecall
 ret
     b1c:	8082                	ret

0000000000000b1e <read>:
.global read
read:
 li a7, SYS_read
     b1e:	4895                	li	a7,5
 ecall
     b20:	00000073          	ecall
 ret
     b24:	8082                	ret

0000000000000b26 <write>:
.global write
write:
 li a7, SYS_write
     b26:	48c1                	li	a7,16
 ecall
     b28:	00000073          	ecall
 ret
     b2c:	8082                	ret

0000000000000b2e <close>:
.global close
close:
 li a7, SYS_close
     b2e:	48d5                	li	a7,21
 ecall
     b30:	00000073          	ecall
 ret
     b34:	8082                	ret

0000000000000b36 <kill>:
.global kill
kill:
 li a7, SYS_kill
     b36:	4899                	li	a7,6
 ecall
     b38:	00000073          	ecall
 ret
     b3c:	8082                	ret

0000000000000b3e <exec>:
.global exec
exec:
 li a7, SYS_exec
     b3e:	489d                	li	a7,7
 ecall
     b40:	00000073          	ecall
 ret
     b44:	8082                	ret

0000000000000b46 <open>:
.global open
open:
 li a7, SYS_open
     b46:	48bd                	li	a7,15
 ecall
     b48:	00000073          	ecall
 ret
     b4c:	8082                	ret

0000000000000b4e <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     b4e:	48c5                	li	a7,17
 ecall
     b50:	00000073          	ecall
 ret
     b54:	8082                	ret

0000000000000b56 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     b56:	48c9                	li	a7,18
 ecall
     b58:	00000073          	ecall
 ret
     b5c:	8082                	ret

0000000000000b5e <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     b5e:	48a1                	li	a7,8
 ecall
     b60:	00000073          	ecall
 ret
     b64:	8082                	ret

0000000000000b66 <link>:
.global link
link:
 li a7, SYS_link
     b66:	48cd                	li	a7,19
 ecall
     b68:	00000073          	ecall
 ret
     b6c:	8082                	ret

0000000000000b6e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     b6e:	48d1                	li	a7,20
 ecall
     b70:	00000073          	ecall
 ret
     b74:	8082                	ret

0000000000000b76 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     b76:	48a5                	li	a7,9
 ecall
     b78:	00000073          	ecall
 ret
     b7c:	8082                	ret

0000000000000b7e <dup>:
.global dup
dup:
 li a7, SYS_dup
     b7e:	48a9                	li	a7,10
 ecall
     b80:	00000073          	ecall
 ret
     b84:	8082                	ret

0000000000000b86 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     b86:	48ad                	li	a7,11
 ecall
     b88:	00000073          	ecall
 ret
     b8c:	8082                	ret

0000000000000b8e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
     b8e:	48b1                	li	a7,12
 ecall
     b90:	00000073          	ecall
 ret
     b94:	8082                	ret

0000000000000b96 <pause>:
.global pause
pause:
 li a7, SYS_pause
     b96:	48b5                	li	a7,13
 ecall
     b98:	00000073          	ecall
 ret
     b9c:	8082                	ret

0000000000000b9e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     b9e:	48b9                	li	a7,14
 ecall
     ba0:	00000073          	ecall
 ret
     ba4:	8082                	ret

0000000000000ba6 <symlink>:
.global symlink
symlink:
 li a7, SYS_symlink
     ba6:	48d9                	li	a7,22
 ecall
     ba8:	00000073          	ecall
 ret
     bac:	8082                	ret

0000000000000bae <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     bae:	1101                	addi	sp,sp,-32
     bb0:	ec06                	sd	ra,24(sp)
     bb2:	e822                	sd	s0,16(sp)
     bb4:	1000                	addi	s0,sp,32
     bb6:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     bba:	4605                	li	a2,1
     bbc:	fef40593          	addi	a1,s0,-17
     bc0:	f67ff0ef          	jal	b26 <write>
}
     bc4:	60e2                	ld	ra,24(sp)
     bc6:	6442                	ld	s0,16(sp)
     bc8:	6105                	addi	sp,sp,32
     bca:	8082                	ret

0000000000000bcc <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
     bcc:	715d                	addi	sp,sp,-80
     bce:	e486                	sd	ra,72(sp)
     bd0:	e0a2                	sd	s0,64(sp)
     bd2:	f84a                	sd	s2,48(sp)
     bd4:	f44e                	sd	s3,40(sp)
     bd6:	0880                	addi	s0,sp,80
     bd8:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
     bda:	c6d1                	beqz	a3,c66 <printint+0x9a>
     bdc:	0805d563          	bgez	a1,c66 <printint+0x9a>
    neg = 1;
    x = -xx;
     be0:	40b005b3          	neg	a1,a1
    neg = 1;
     be4:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
     be6:	fb840993          	addi	s3,s0,-72
  neg = 0;
     bea:	86ce                	mv	a3,s3
  i = 0;
     bec:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     bee:	00001817          	auipc	a6,0x1
     bf2:	ada80813          	addi	a6,a6,-1318 # 16c8 <digits>
     bf6:	88ba                	mv	a7,a4
     bf8:	0017051b          	addiw	a0,a4,1
     bfc:	872a                	mv	a4,a0
     bfe:	02c5f7b3          	remu	a5,a1,a2
     c02:	97c2                	add	a5,a5,a6
     c04:	0007c783          	lbu	a5,0(a5)
     c08:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     c0c:	87ae                	mv	a5,a1
     c0e:	02c5d5b3          	divu	a1,a1,a2
     c12:	0685                	addi	a3,a3,1
     c14:	fec7f1e3          	bgeu	a5,a2,bf6 <printint+0x2a>
  if(neg)
     c18:	00030c63          	beqz	t1,c30 <printint+0x64>
    buf[i++] = '-';
     c1c:	fd050793          	addi	a5,a0,-48
     c20:	00878533          	add	a0,a5,s0
     c24:	02d00793          	li	a5,45
     c28:	fef50423          	sb	a5,-24(a0)
     c2c:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
     c30:	02e05563          	blez	a4,c5a <printint+0x8e>
     c34:	fc26                	sd	s1,56(sp)
     c36:	377d                	addiw	a4,a4,-1
     c38:	00e984b3          	add	s1,s3,a4
     c3c:	19fd                	addi	s3,s3,-1
     c3e:	99ba                	add	s3,s3,a4
     c40:	1702                	slli	a4,a4,0x20
     c42:	9301                	srli	a4,a4,0x20
     c44:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     c48:	0004c583          	lbu	a1,0(s1)
     c4c:	854a                	mv	a0,s2
     c4e:	f61ff0ef          	jal	bae <putc>
  while(--i >= 0)
     c52:	14fd                	addi	s1,s1,-1
     c54:	ff349ae3          	bne	s1,s3,c48 <printint+0x7c>
     c58:	74e2                	ld	s1,56(sp)
}
     c5a:	60a6                	ld	ra,72(sp)
     c5c:	6406                	ld	s0,64(sp)
     c5e:	7942                	ld	s2,48(sp)
     c60:	79a2                	ld	s3,40(sp)
     c62:	6161                	addi	sp,sp,80
     c64:	8082                	ret
  neg = 0;
     c66:	4301                	li	t1,0
     c68:	bfbd                	j	be6 <printint+0x1a>

0000000000000c6a <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     c6a:	711d                	addi	sp,sp,-96
     c6c:	ec86                	sd	ra,88(sp)
     c6e:	e8a2                	sd	s0,80(sp)
     c70:	e4a6                	sd	s1,72(sp)
     c72:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     c74:	0005c483          	lbu	s1,0(a1)
     c78:	22048363          	beqz	s1,e9e <vprintf+0x234>
     c7c:	e0ca                	sd	s2,64(sp)
     c7e:	fc4e                	sd	s3,56(sp)
     c80:	f852                	sd	s4,48(sp)
     c82:	f456                	sd	s5,40(sp)
     c84:	f05a                	sd	s6,32(sp)
     c86:	ec5e                	sd	s7,24(sp)
     c88:	e862                	sd	s8,16(sp)
     c8a:	8b2a                	mv	s6,a0
     c8c:	8a2e                	mv	s4,a1
     c8e:	8bb2                	mv	s7,a2
  state = 0;
     c90:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
     c92:	4901                	li	s2,0
     c94:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
     c96:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
     c9a:	06400c13          	li	s8,100
     c9e:	a00d                	j	cc0 <vprintf+0x56>
        putc(fd, c0);
     ca0:	85a6                	mv	a1,s1
     ca2:	855a                	mv	a0,s6
     ca4:	f0bff0ef          	jal	bae <putc>
     ca8:	a019                	j	cae <vprintf+0x44>
    } else if(state == '%'){
     caa:	03598363          	beq	s3,s5,cd0 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
     cae:	0019079b          	addiw	a5,s2,1
     cb2:	893e                	mv	s2,a5
     cb4:	873e                	mv	a4,a5
     cb6:	97d2                	add	a5,a5,s4
     cb8:	0007c483          	lbu	s1,0(a5)
     cbc:	1c048a63          	beqz	s1,e90 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
     cc0:	0004879b          	sext.w	a5,s1
    if(state == 0){
     cc4:	fe0993e3          	bnez	s3,caa <vprintf+0x40>
      if(c0 == '%'){
     cc8:	fd579ce3          	bne	a5,s5,ca0 <vprintf+0x36>
        state = '%';
     ccc:	89be                	mv	s3,a5
     cce:	b7c5                	j	cae <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
     cd0:	00ea06b3          	add	a3,s4,a4
     cd4:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
     cd8:	1c060863          	beqz	a2,ea8 <vprintf+0x23e>
      if(c0 == 'd'){
     cdc:	03878763          	beq	a5,s8,d0a <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
     ce0:	f9478693          	addi	a3,a5,-108
     ce4:	0016b693          	seqz	a3,a3
     ce8:	f9c60593          	addi	a1,a2,-100
     cec:	e99d                	bnez	a1,d22 <vprintf+0xb8>
     cee:	ca95                	beqz	a3,d22 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
     cf0:	008b8493          	addi	s1,s7,8
     cf4:	4685                	li	a3,1
     cf6:	4629                	li	a2,10
     cf8:	000bb583          	ld	a1,0(s7)
     cfc:	855a                	mv	a0,s6
     cfe:	ecfff0ef          	jal	bcc <printint>
        i += 1;
     d02:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
     d04:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
     d06:	4981                	li	s3,0
     d08:	b75d                	j	cae <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
     d0a:	008b8493          	addi	s1,s7,8
     d0e:	4685                	li	a3,1
     d10:	4629                	li	a2,10
     d12:	000ba583          	lw	a1,0(s7)
     d16:	855a                	mv	a0,s6
     d18:	eb5ff0ef          	jal	bcc <printint>
     d1c:	8ba6                	mv	s7,s1
      state = 0;
     d1e:	4981                	li	s3,0
     d20:	b779                	j	cae <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
     d22:	9752                	add	a4,a4,s4
     d24:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     d28:	f9460713          	addi	a4,a2,-108
     d2c:	00173713          	seqz	a4,a4
     d30:	8f75                	and	a4,a4,a3
     d32:	f9c58513          	addi	a0,a1,-100
     d36:	18051363          	bnez	a0,ebc <vprintf+0x252>
     d3a:	18070163          	beqz	a4,ebc <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
     d3e:	008b8493          	addi	s1,s7,8
     d42:	4685                	li	a3,1
     d44:	4629                	li	a2,10
     d46:	000bb583          	ld	a1,0(s7)
     d4a:	855a                	mv	a0,s6
     d4c:	e81ff0ef          	jal	bcc <printint>
        i += 2;
     d50:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
     d52:	8ba6                	mv	s7,s1
      state = 0;
     d54:	4981                	li	s3,0
        i += 2;
     d56:	bfa1                	j	cae <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
     d58:	008b8493          	addi	s1,s7,8
     d5c:	4681                	li	a3,0
     d5e:	4629                	li	a2,10
     d60:	000be583          	lwu	a1,0(s7)
     d64:	855a                	mv	a0,s6
     d66:	e67ff0ef          	jal	bcc <printint>
     d6a:	8ba6                	mv	s7,s1
      state = 0;
     d6c:	4981                	li	s3,0
     d6e:	b781                	j	cae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d70:	008b8493          	addi	s1,s7,8
     d74:	4681                	li	a3,0
     d76:	4629                	li	a2,10
     d78:	000bb583          	ld	a1,0(s7)
     d7c:	855a                	mv	a0,s6
     d7e:	e4fff0ef          	jal	bcc <printint>
        i += 1;
     d82:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
     d84:	8ba6                	mv	s7,s1
      state = 0;
     d86:	4981                	li	s3,0
     d88:	b71d                	j	cae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
     d8a:	008b8493          	addi	s1,s7,8
     d8e:	4681                	li	a3,0
     d90:	4629                	li	a2,10
     d92:	000bb583          	ld	a1,0(s7)
     d96:	855a                	mv	a0,s6
     d98:	e35ff0ef          	jal	bcc <printint>
        i += 2;
     d9c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
     d9e:	8ba6                	mv	s7,s1
      state = 0;
     da0:	4981                	li	s3,0
        i += 2;
     da2:	b731                	j	cae <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
     da4:	008b8493          	addi	s1,s7,8
     da8:	4681                	li	a3,0
     daa:	4641                	li	a2,16
     dac:	000be583          	lwu	a1,0(s7)
     db0:	855a                	mv	a0,s6
     db2:	e1bff0ef          	jal	bcc <printint>
     db6:	8ba6                	mv	s7,s1
      state = 0;
     db8:	4981                	li	s3,0
     dba:	bdd5                	j	cae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     dbc:	008b8493          	addi	s1,s7,8
     dc0:	4681                	li	a3,0
     dc2:	4641                	li	a2,16
     dc4:	000bb583          	ld	a1,0(s7)
     dc8:	855a                	mv	a0,s6
     dca:	e03ff0ef          	jal	bcc <printint>
        i += 1;
     dce:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
     dd0:	8ba6                	mv	s7,s1
      state = 0;
     dd2:	4981                	li	s3,0
     dd4:	bde9                	j	cae <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
     dd6:	008b8493          	addi	s1,s7,8
     dda:	4681                	li	a3,0
     ddc:	4641                	li	a2,16
     dde:	000bb583          	ld	a1,0(s7)
     de2:	855a                	mv	a0,s6
     de4:	de9ff0ef          	jal	bcc <printint>
        i += 2;
     de8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
     dea:	8ba6                	mv	s7,s1
      state = 0;
     dec:	4981                	li	s3,0
        i += 2;
     dee:	b5c1                	j	cae <vprintf+0x44>
     df0:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
     df2:	008b8793          	addi	a5,s7,8
     df6:	8cbe                	mv	s9,a5
     df8:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
     dfc:	03000593          	li	a1,48
     e00:	855a                	mv	a0,s6
     e02:	dadff0ef          	jal	bae <putc>
  putc(fd, 'x');
     e06:	07800593          	li	a1,120
     e0a:	855a                	mv	a0,s6
     e0c:	da3ff0ef          	jal	bae <putc>
     e10:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e12:	00001b97          	auipc	s7,0x1
     e16:	8b6b8b93          	addi	s7,s7,-1866 # 16c8 <digits>
     e1a:	03c9d793          	srli	a5,s3,0x3c
     e1e:	97de                	add	a5,a5,s7
     e20:	0007c583          	lbu	a1,0(a5)
     e24:	855a                	mv	a0,s6
     e26:	d89ff0ef          	jal	bae <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e2a:	0992                	slli	s3,s3,0x4
     e2c:	34fd                	addiw	s1,s1,-1
     e2e:	f4f5                	bnez	s1,e1a <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
     e30:	8be6                	mv	s7,s9
      state = 0;
     e32:	4981                	li	s3,0
     e34:	6ca2                	ld	s9,8(sp)
     e36:	bda5                	j	cae <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
     e38:	008b8493          	addi	s1,s7,8
     e3c:	000bc583          	lbu	a1,0(s7)
     e40:	855a                	mv	a0,s6
     e42:	d6dff0ef          	jal	bae <putc>
     e46:	8ba6                	mv	s7,s1
      state = 0;
     e48:	4981                	li	s3,0
     e4a:	b595                	j	cae <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     e4c:	008b8993          	addi	s3,s7,8
     e50:	000bb483          	ld	s1,0(s7)
     e54:	cc91                	beqz	s1,e70 <vprintf+0x206>
        for(; *s; s++)
     e56:	0004c583          	lbu	a1,0(s1)
     e5a:	c985                	beqz	a1,e8a <vprintf+0x220>
          putc(fd, *s);
     e5c:	855a                	mv	a0,s6
     e5e:	d51ff0ef          	jal	bae <putc>
        for(; *s; s++)
     e62:	0485                	addi	s1,s1,1
     e64:	0004c583          	lbu	a1,0(s1)
     e68:	f9f5                	bnez	a1,e5c <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
     e6a:	8bce                	mv	s7,s3
      state = 0;
     e6c:	4981                	li	s3,0
     e6e:	b581                	j	cae <vprintf+0x44>
          s = "(null)";
     e70:	00001497          	auipc	s1,0x1
     e74:	85048493          	addi	s1,s1,-1968 # 16c0 <malloc+0x6b4>
        for(; *s; s++)
     e78:	02800593          	li	a1,40
     e7c:	b7c5                	j	e5c <vprintf+0x1f2>
        putc(fd, '%');
     e7e:	85be                	mv	a1,a5
     e80:	855a                	mv	a0,s6
     e82:	d2dff0ef          	jal	bae <putc>
      state = 0;
     e86:	4981                	li	s3,0
     e88:	b51d                	j	cae <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
     e8a:	8bce                	mv	s7,s3
      state = 0;
     e8c:	4981                	li	s3,0
     e8e:	b505                	j	cae <vprintf+0x44>
     e90:	6906                	ld	s2,64(sp)
     e92:	79e2                	ld	s3,56(sp)
     e94:	7a42                	ld	s4,48(sp)
     e96:	7aa2                	ld	s5,40(sp)
     e98:	7b02                	ld	s6,32(sp)
     e9a:	6be2                	ld	s7,24(sp)
     e9c:	6c42                	ld	s8,16(sp)
    }
  }
}
     e9e:	60e6                	ld	ra,88(sp)
     ea0:	6446                	ld	s0,80(sp)
     ea2:	64a6                	ld	s1,72(sp)
     ea4:	6125                	addi	sp,sp,96
     ea6:	8082                	ret
      if(c0 == 'd'){
     ea8:	06400713          	li	a4,100
     eac:	e4e78fe3          	beq	a5,a4,d0a <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
     eb0:	f9478693          	addi	a3,a5,-108
     eb4:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
     eb8:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
     eba:	4701                	li	a4,0
      } else if(c0 == 'u'){
     ebc:	07500513          	li	a0,117
     ec0:	e8a78ce3          	beq	a5,a0,d58 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
     ec4:	f8b60513          	addi	a0,a2,-117
     ec8:	e119                	bnez	a0,ece <vprintf+0x264>
     eca:	ea0693e3          	bnez	a3,d70 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
     ece:	f8b58513          	addi	a0,a1,-117
     ed2:	e119                	bnez	a0,ed8 <vprintf+0x26e>
     ed4:	ea071be3          	bnez	a4,d8a <vprintf+0x120>
      } else if(c0 == 'x'){
     ed8:	07800513          	li	a0,120
     edc:	eca784e3          	beq	a5,a0,da4 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
     ee0:	f8860613          	addi	a2,a2,-120
     ee4:	e219                	bnez	a2,eea <vprintf+0x280>
     ee6:	ec069be3          	bnez	a3,dbc <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
     eea:	f8858593          	addi	a1,a1,-120
     eee:	e199                	bnez	a1,ef4 <vprintf+0x28a>
     ef0:	ee0713e3          	bnez	a4,dd6 <vprintf+0x16c>
      } else if(c0 == 'p'){
     ef4:	07000713          	li	a4,112
     ef8:	eee78ce3          	beq	a5,a4,df0 <vprintf+0x186>
      } else if(c0 == 'c'){
     efc:	06300713          	li	a4,99
     f00:	f2e78ce3          	beq	a5,a4,e38 <vprintf+0x1ce>
      } else if(c0 == 's'){
     f04:	07300713          	li	a4,115
     f08:	f4e782e3          	beq	a5,a4,e4c <vprintf+0x1e2>
      } else if(c0 == '%'){
     f0c:	02500713          	li	a4,37
     f10:	f6e787e3          	beq	a5,a4,e7e <vprintf+0x214>
        putc(fd, '%');
     f14:	02500593          	li	a1,37
     f18:	855a                	mv	a0,s6
     f1a:	c95ff0ef          	jal	bae <putc>
        putc(fd, c0);
     f1e:	85a6                	mv	a1,s1
     f20:	855a                	mv	a0,s6
     f22:	c8dff0ef          	jal	bae <putc>
      state = 0;
     f26:	4981                	li	s3,0
     f28:	b359                	j	cae <vprintf+0x44>

0000000000000f2a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f2a:	715d                	addi	sp,sp,-80
     f2c:	ec06                	sd	ra,24(sp)
     f2e:	e822                	sd	s0,16(sp)
     f30:	1000                	addi	s0,sp,32
     f32:	e010                	sd	a2,0(s0)
     f34:	e414                	sd	a3,8(s0)
     f36:	e818                	sd	a4,16(s0)
     f38:	ec1c                	sd	a5,24(s0)
     f3a:	03043023          	sd	a6,32(s0)
     f3e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f42:	8622                	mv	a2,s0
     f44:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f48:	d23ff0ef          	jal	c6a <vprintf>
}
     f4c:	60e2                	ld	ra,24(sp)
     f4e:	6442                	ld	s0,16(sp)
     f50:	6161                	addi	sp,sp,80
     f52:	8082                	ret

0000000000000f54 <printf>:

void
printf(const char *fmt, ...)
{
     f54:	711d                	addi	sp,sp,-96
     f56:	ec06                	sd	ra,24(sp)
     f58:	e822                	sd	s0,16(sp)
     f5a:	1000                	addi	s0,sp,32
     f5c:	e40c                	sd	a1,8(s0)
     f5e:	e810                	sd	a2,16(s0)
     f60:	ec14                	sd	a3,24(s0)
     f62:	f018                	sd	a4,32(s0)
     f64:	f41c                	sd	a5,40(s0)
     f66:	03043823          	sd	a6,48(s0)
     f6a:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f6e:	00840613          	addi	a2,s0,8
     f72:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f76:	85aa                	mv	a1,a0
     f78:	4505                	li	a0,1
     f7a:	cf1ff0ef          	jal	c6a <vprintf>
}
     f7e:	60e2                	ld	ra,24(sp)
     f80:	6442                	ld	s0,16(sp)
     f82:	6125                	addi	sp,sp,96
     f84:	8082                	ret

0000000000000f86 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f86:	1141                	addi	sp,sp,-16
     f88:	e406                	sd	ra,8(sp)
     f8a:	e022                	sd	s0,0(sp)
     f8c:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f8e:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f92:	00001797          	auipc	a5,0x1
     f96:	0767b783          	ld	a5,118(a5) # 2008 <freep>
     f9a:	a039                	j	fa8 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     f9c:	6398                	ld	a4,0(a5)
     f9e:	00e7e463          	bltu	a5,a4,fa6 <free+0x20>
     fa2:	00e6ea63          	bltu	a3,a4,fb6 <free+0x30>
{
     fa6:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fa8:	fed7fae3          	bgeu	a5,a3,f9c <free+0x16>
     fac:	6398                	ld	a4,0(a5)
     fae:	00e6e463          	bltu	a3,a4,fb6 <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fb2:	fee7eae3          	bltu	a5,a4,fa6 <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
     fb6:	ff852583          	lw	a1,-8(a0)
     fba:	6390                	ld	a2,0(a5)
     fbc:	02059813          	slli	a6,a1,0x20
     fc0:	01c85713          	srli	a4,a6,0x1c
     fc4:	9736                	add	a4,a4,a3
     fc6:	02e60563          	beq	a2,a4,ff0 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
     fca:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
     fce:	4790                	lw	a2,8(a5)
     fd0:	02061593          	slli	a1,a2,0x20
     fd4:	01c5d713          	srli	a4,a1,0x1c
     fd8:	973e                	add	a4,a4,a5
     fda:	02e68263          	beq	a3,a4,ffe <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
     fde:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
     fe0:	00001717          	auipc	a4,0x1
     fe4:	02f73423          	sd	a5,40(a4) # 2008 <freep>
}
     fe8:	60a2                	ld	ra,8(sp)
     fea:	6402                	ld	s0,0(sp)
     fec:	0141                	addi	sp,sp,16
     fee:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
     ff0:	4618                	lw	a4,8(a2)
     ff2:	9f2d                	addw	a4,a4,a1
     ff4:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     ff8:	6398                	ld	a4,0(a5)
     ffa:	6310                	ld	a2,0(a4)
     ffc:	b7f9                	j	fca <free+0x44>
    p->s.size += bp->s.size;
     ffe:	ff852703          	lw	a4,-8(a0)
    1002:	9f31                	addw	a4,a4,a2
    1004:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1006:	ff053683          	ld	a3,-16(a0)
    100a:	bfd1                	j	fde <free+0x58>

000000000000100c <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    100c:	7139                	addi	sp,sp,-64
    100e:	fc06                	sd	ra,56(sp)
    1010:	f822                	sd	s0,48(sp)
    1012:	f04a                	sd	s2,32(sp)
    1014:	ec4e                	sd	s3,24(sp)
    1016:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1018:	02051993          	slli	s3,a0,0x20
    101c:	0209d993          	srli	s3,s3,0x20
    1020:	09bd                	addi	s3,s3,15
    1022:	0049d993          	srli	s3,s3,0x4
    1026:	2985                	addiw	s3,s3,1
    1028:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    102a:	00001517          	auipc	a0,0x1
    102e:	fde53503          	ld	a0,-34(a0) # 2008 <freep>
    1032:	c905                	beqz	a0,1062 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1034:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1036:	4798                	lw	a4,8(a5)
    1038:	09377663          	bgeu	a4,s3,10c4 <malloc+0xb8>
    103c:	f426                	sd	s1,40(sp)
    103e:	e852                	sd	s4,16(sp)
    1040:	e456                	sd	s5,8(sp)
    1042:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1044:	8a4e                	mv	s4,s3
    1046:	6705                	lui	a4,0x1
    1048:	00e9f363          	bgeu	s3,a4,104e <malloc+0x42>
    104c:	6a05                	lui	s4,0x1
    104e:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1052:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1056:	00001497          	auipc	s1,0x1
    105a:	fb248493          	addi	s1,s1,-78 # 2008 <freep>
  if(p == SBRK_ERROR)
    105e:	5afd                	li	s5,-1
    1060:	a83d                	j	109e <malloc+0x92>
    1062:	f426                	sd	s1,40(sp)
    1064:	e852                	sd	s4,16(sp)
    1066:	e456                	sd	s5,8(sp)
    1068:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    106a:	00001797          	auipc	a5,0x1
    106e:	fa678793          	addi	a5,a5,-90 # 2010 <base>
    1072:	00001717          	auipc	a4,0x1
    1076:	f8f73b23          	sd	a5,-106(a4) # 2008 <freep>
    107a:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    107c:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1080:	b7d1                	j	1044 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1082:	6398                	ld	a4,0(a5)
    1084:	e118                	sd	a4,0(a0)
    1086:	a899                	j	10dc <malloc+0xd0>
  hp->s.size = nu;
    1088:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    108c:	0541                	addi	a0,a0,16
    108e:	ef9ff0ef          	jal	f86 <free>
  return freep;
    1092:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1094:	c125                	beqz	a0,10f4 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1096:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1098:	4798                	lw	a4,8(a5)
    109a:	03277163          	bgeu	a4,s2,10bc <malloc+0xb0>
    if(p == freep)
    109e:	6098                	ld	a4,0(s1)
    10a0:	853e                	mv	a0,a5
    10a2:	fef71ae3          	bne	a4,a5,1096 <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    10a6:	8552                	mv	a0,s4
    10a8:	a2bff0ef          	jal	ad2 <sbrk>
  if(p == SBRK_ERROR)
    10ac:	fd551ee3          	bne	a0,s5,1088 <malloc+0x7c>
        return 0;
    10b0:	4501                	li	a0,0
    10b2:	74a2                	ld	s1,40(sp)
    10b4:	6a42                	ld	s4,16(sp)
    10b6:	6aa2                	ld	s5,8(sp)
    10b8:	6b02                	ld	s6,0(sp)
    10ba:	a03d                	j	10e8 <malloc+0xdc>
    10bc:	74a2                	ld	s1,40(sp)
    10be:	6a42                	ld	s4,16(sp)
    10c0:	6aa2                	ld	s5,8(sp)
    10c2:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    10c4:	fae90fe3          	beq	s2,a4,1082 <malloc+0x76>
        p->s.size -= nunits;
    10c8:	4137073b          	subw	a4,a4,s3
    10cc:	c798                	sw	a4,8(a5)
        p += p->s.size;
    10ce:	02071693          	slli	a3,a4,0x20
    10d2:	01c6d713          	srli	a4,a3,0x1c
    10d6:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    10d8:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    10dc:	00001717          	auipc	a4,0x1
    10e0:	f2a73623          	sd	a0,-212(a4) # 2008 <freep>
      return (void*)(p + 1);
    10e4:	01078513          	addi	a0,a5,16
  }
}
    10e8:	70e2                	ld	ra,56(sp)
    10ea:	7442                	ld	s0,48(sp)
    10ec:	7902                	ld	s2,32(sp)
    10ee:	69e2                	ld	s3,24(sp)
    10f0:	6121                	addi	sp,sp,64
    10f2:	8082                	ret
    10f4:	74a2                	ld	s1,40(sp)
    10f6:	6a42                	ld	s4,16(sp)
    10f8:	6aa2                	ld	s5,8(sp)
    10fa:	6b02                	ld	s6,0(sp)
    10fc:	b7f5                	j	10e8 <malloc+0xdc>
