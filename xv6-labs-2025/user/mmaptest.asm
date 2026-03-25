
user/_mmaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:
  exit(0);
}

void
err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	1000                	addi	s0,sp,32
       a:	84aa                	mv	s1,a0
  printf("mmaptest failure: %s, pid=%d\n", why, getpid());
       c:	01a010ef          	jal	1026 <getpid>
      10:	862a                	mv	a2,a0
      12:	85a6                	mv	a1,s1
      14:	00001517          	auipc	a0,0x1
      18:	59c50513          	addi	a0,a0,1436 # 15b0 <malloc+0xfc>
      1c:	3e0010ef          	jal	13fc <printf>
  exit(1);
      20:	4505                	li	a0,1
      22:	785000ef          	jal	fa6 <exit>

0000000000000026 <_v1>:
//
// check the content of the two mapped pages.
//
void
_v1(char *p)
{
      26:	1141                	addi	sp,sp,-16
      28:	e406                	sd	ra,8(sp)
      2a:	e022                	sd	s0,0(sp)
      2c:	0800                	addi	s0,sp,16
  int i;
  for (i = 0; i < PGSIZE*2; i++) {
      2e:	4581                	li	a1,0
    if (i < PGSIZE + (PGSIZE/2)) {
      30:	6785                	lui	a5,0x1
      32:	7ff78793          	addi	a5,a5,2047 # 17ff <malloc+0x34b>
  for (i = 0; i < PGSIZE*2; i++) {
      36:	6689                	lui	a3,0x2
      if (p[i] != 'A') {
      38:	04100713          	li	a4,65
      3c:	a025                	j	64 <_v1+0x3e>
        printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
      3e:	00001517          	auipc	a0,0x1
      42:	59a50513          	addi	a0,a0,1434 # 15d8 <malloc+0x124>
      46:	3b6010ef          	jal	13fc <printf>
        err("v1 mismatch (1)");
      4a:	00001517          	auipc	a0,0x1
      4e:	5b650513          	addi	a0,a0,1462 # 1600 <malloc+0x14c>
      52:	fafff0ef          	jal	0 <err>
      }
    } else {
      if (p[i] != 0) {
      56:	00054603          	lbu	a2,0(a0)
      5a:	ee11                	bnez	a2,76 <_v1+0x50>
  for (i = 0; i < PGSIZE*2; i++) {
      5c:	2585                	addiw	a1,a1,1
      5e:	02d58863          	beq	a1,a3,8e <_v1+0x68>
      62:	0505                	addi	a0,a0,1
    if (i < PGSIZE + (PGSIZE/2)) {
      64:	feb7c9e3          	blt	a5,a1,56 <_v1+0x30>
      if (p[i] != 'A') {
      68:	00054603          	lbu	a2,0(a0)
      6c:	fce619e3          	bne	a2,a4,3e <_v1+0x18>
  for (i = 0; i < PGSIZE*2; i++) {
      70:	2585                	addiw	a1,a1,1
      72:	0505                	addi	a0,a0,1
      74:	bfc5                	j	64 <_v1+0x3e>
        printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      76:	00001517          	auipc	a0,0x1
      7a:	59a50513          	addi	a0,a0,1434 # 1610 <malloc+0x15c>
      7e:	37e010ef          	jal	13fc <printf>
        err("v1 mismatch (2)");
      82:	00001517          	auipc	a0,0x1
      86:	5b650513          	addi	a0,a0,1462 # 1638 <malloc+0x184>
      8a:	f77ff0ef          	jal	0 <err>
      }
    }
  }
}
      8e:	60a2                	ld	ra,8(sp)
      90:	6402                	ld	s0,0(sp)
      92:	0141                	addi	sp,sp,16
      94:	8082                	ret

0000000000000096 <makefile>:
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void
makefile(const char *f)
{
      96:	7179                	addi	sp,sp,-48
      98:	f406                	sd	ra,40(sp)
      9a:	f022                	sd	s0,32(sp)
      9c:	ec26                	sd	s1,24(sp)
      9e:	e84a                	sd	s2,16(sp)
      a0:	e44e                	sd	s3,8(sp)
      a2:	e052                	sd	s4,0(sp)
      a4:	1800                	addi	s0,sp,48
      a6:	84aa                	mv	s1,a0
  int i;
  int n = PGSIZE/BSIZE;

  unlink(f);
      a8:	74f000ef          	jal	ff6 <unlink>
  int fd = open(f, O_WRONLY | O_CREATE);
      ac:	20100593          	li	a1,513
      b0:	8526                	mv	a0,s1
      b2:	735000ef          	jal	fe6 <open>
  if (fd == -1)
      b6:	57fd                	li	a5,-1
      b8:	04f50b63          	beq	a0,a5,10e <makefile+0x78>
      bc:	89aa                	mv	s3,a0
    err("open");
  memset(buf, 'A', BSIZE);
      be:	40000613          	li	a2,1024
      c2:	04100593          	li	a1,65
      c6:	00002517          	auipc	a0,0x2
      ca:	f4a50513          	addi	a0,a0,-182 # 2010 <buf>
      ce:	4af000ef          	jal	d7c <memset>
      d2:	4499                	li	s1,6
  // write 1.5 page
  for (i = 0; i < n + n/2; i++) {
    if (write(fd, buf, BSIZE) != BSIZE)
      d4:	40000913          	li	s2,1024
      d8:	00002a17          	auipc	s4,0x2
      dc:	f38a0a13          	addi	s4,s4,-200 # 2010 <buf>
      e0:	864a                	mv	a2,s2
      e2:	85d2                	mv	a1,s4
      e4:	854e                	mv	a0,s3
      e6:	6e1000ef          	jal	fc6 <write>
      ea:	03251863          	bne	a0,s2,11a <makefile+0x84>
  for (i = 0; i < n + n/2; i++) {
      ee:	34fd                	addiw	s1,s1,-1
      f0:	f8e5                	bnez	s1,e0 <makefile+0x4a>
      err("write 0 makefile");
  }
  if (close(fd) == -1)
      f2:	854e                	mv	a0,s3
      f4:	6db000ef          	jal	fce <close>
      f8:	57fd                	li	a5,-1
      fa:	02f50663          	beq	a0,a5,126 <makefile+0x90>
    err("close");
}
      fe:	70a2                	ld	ra,40(sp)
     100:	7402                	ld	s0,32(sp)
     102:	64e2                	ld	s1,24(sp)
     104:	6942                	ld	s2,16(sp)
     106:	69a2                	ld	s3,8(sp)
     108:	6a02                	ld	s4,0(sp)
     10a:	6145                	addi	sp,sp,48
     10c:	8082                	ret
    err("open");
     10e:	00001517          	auipc	a0,0x1
     112:	53a50513          	addi	a0,a0,1338 # 1648 <malloc+0x194>
     116:	eebff0ef          	jal	0 <err>
      err("write 0 makefile");
     11a:	00001517          	auipc	a0,0x1
     11e:	53650513          	addi	a0,a0,1334 # 1650 <malloc+0x19c>
     122:	edfff0ef          	jal	0 <err>
    err("close");
     126:	00001517          	auipc	a0,0x1
     12a:	54250513          	addi	a0,a0,1346 # 1668 <malloc+0x1b4>
     12e:	ed3ff0ef          	jal	0 <err>

0000000000000132 <mmap_test>:

void
mmap_test(void)
{
     132:	7179                	addi	sp,sp,-48
     134:	f406                	sd	ra,40(sp)
     136:	f022                	sd	s0,32(sp)
     138:	ec26                	sd	s1,24(sp)
     13a:	e84a                	sd	s2,16(sp)
     13c:	e44e                	sd	s3,8(sp)
     13e:	1800                	addi	s0,sp,48
  //
  // create a file with known content, map it into memory, check that
  // the mapped memory has the same bytes as originally written to the
  // file.
  //
  makefile(f);
     140:	00001517          	auipc	a0,0x1
     144:	53050513          	addi	a0,a0,1328 # 1670 <malloc+0x1bc>
     148:	f4fff0ef          	jal	96 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     14c:	4581                	li	a1,0
     14e:	00001517          	auipc	a0,0x1
     152:	52250513          	addi	a0,a0,1314 # 1670 <malloc+0x1bc>
     156:	691000ef          	jal	fe6 <open>
     15a:	57fd                	li	a5,-1
     15c:	4af50d63          	beq	a0,a5,616 <mmap_test+0x4e4>
     160:	84aa                	mv	s1,a0
    err("open (1)");

  printf("test basic mmap\n");
     162:	00001517          	auipc	a0,0x1
     166:	52e50513          	addi	a0,a0,1326 # 1690 <malloc+0x1dc>
     16a:	292010ef          	jal	13fc <printf>
  // same file (of course in this case updates are prohibited
  // due to PROT_READ). the fifth argument is the file descriptor
  // of the file to be mapped. the last argument is the starting
  // offset in the file.
  //
  char *p = mmap(0, PGSIZE*2, PROT_READ, MAP_PRIVATE, fd, 0);
     16e:	4781                	li	a5,0
     170:	8726                	mv	a4,s1
     172:	4689                	li	a3,2
     174:	4605                	li	a2,1
     176:	6589                	lui	a1,0x2
     178:	4501                	li	a0,0
     17a:	6cd000ef          	jal	1046 <mmap>
     17e:	892a                	mv	s2,a0
  if (p == MAP_FAILED)
     180:	57fd                	li	a5,-1
     182:	4af50063          	beq	a0,a5,622 <mmap_test+0x4f0>
    err("mmap (1)");
  _v1(p);
     186:	ea1ff0ef          	jal	26 <_v1>
  printf("test basic mmap: OK\n");
     18a:	00001517          	auipc	a0,0x1
     18e:	52e50513          	addi	a0,a0,1326 # 16b8 <malloc+0x204>
     192:	26a010ef          	jal	13fc <printf>
  if (munmap(p, PGSIZE*2) == -1)
     196:	6589                	lui	a1,0x2
     198:	854a                	mv	a0,s2
     19a:	6b5000ef          	jal	104e <munmap>
     19e:	57fd                	li	a5,-1
     1a0:	48f50763          	beq	a0,a5,62e <mmap_test+0x4fc>
    err("munmap (1)");

  printf("test basic mmap: OK\n");
     1a4:	00001517          	auipc	a0,0x1
     1a8:	51450513          	addi	a0,a0,1300 # 16b8 <malloc+0x204>
     1ac:	250010ef          	jal	13fc <printf>

  printf("test mmap private\n");
     1b0:	00001517          	auipc	a0,0x1
     1b4:	53050513          	addi	a0,a0,1328 # 16e0 <malloc+0x22c>
     1b8:	244010ef          	jal	13fc <printf>
  // should be able to map file opened read-only with private writable
  // mapping
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     1bc:	4781                	li	a5,0
     1be:	8726                	mv	a4,s1
     1c0:	4689                	li	a3,2
     1c2:	460d                	li	a2,3
     1c4:	6589                	lui	a1,0x2
     1c6:	4501                	li	a0,0
     1c8:	67f000ef          	jal	1046 <mmap>
     1cc:	892a                	mv	s2,a0
  if (p == MAP_FAILED)
     1ce:	57fd                	li	a5,-1
     1d0:	46f50563          	beq	a0,a5,63a <mmap_test+0x508>
    err("mmap (2)");
  if (close(fd) == -1)
     1d4:	8526                	mv	a0,s1
     1d6:	5f9000ef          	jal	fce <close>
     1da:	57fd                	li	a5,-1
     1dc:	46f50563          	beq	a0,a5,646 <mmap_test+0x514>
    err("close (1)");
  _v1(p);
     1e0:	854a                	mv	a0,s2
     1e2:	e45ff0ef          	jal	26 <_v1>
  for (i = 0; i < PGSIZE*2; i++)
     1e6:	87ca                	mv	a5,s2
     1e8:	6709                	lui	a4,0x2
     1ea:	974a                	add	a4,a4,s2
    p[i] = 'Z';
     1ec:	05a00693          	li	a3,90
     1f0:	00d78023          	sb	a3,0(a5)
  for (i = 0; i < PGSIZE*2; i++)
     1f4:	0785                	addi	a5,a5,1
     1f6:	fef71de3          	bne	a4,a5,1f0 <mmap_test+0xbe>
  if (munmap(p, PGSIZE*2) == -1)
     1fa:	6589                	lui	a1,0x2
     1fc:	854a                	mv	a0,s2
     1fe:	651000ef          	jal	104e <munmap>
     202:	57fd                	li	a5,-1
     204:	44f50763          	beq	a0,a5,652 <mmap_test+0x520>
    err("munmap (2)");
  close(fd);
     208:	8526                	mv	a0,s1
     20a:	5c5000ef          	jal	fce <close>

  // file should not have been modified.
  if((fd = open(f, O_RDONLY)) < 0) err("open");
     20e:	4581                	li	a1,0
     210:	00001517          	auipc	a0,0x1
     214:	46050513          	addi	a0,a0,1120 # 1670 <malloc+0x1bc>
     218:	5cf000ef          	jal	fe6 <open>
     21c:	84aa                	mv	s1,a0
     21e:	44054063          	bltz	a0,65e <mmap_test+0x52c>
  if(read(fd, buf, PGSIZE) != PGSIZE) err("read");
     222:	6605                	lui	a2,0x1
     224:	00002597          	auipc	a1,0x2
     228:	dec58593          	addi	a1,a1,-532 # 2010 <buf>
     22c:	593000ef          	jal	fbe <read>
     230:	6785                	lui	a5,0x1
     232:	42f51c63          	bne	a0,a5,66a <mmap_test+0x538>
  if(buf[0] != 'A')
     236:	00002717          	auipc	a4,0x2
     23a:	dda74703          	lbu	a4,-550(a4) # 2010 <buf>
     23e:	04100793          	li	a5,65
     242:	42f71a63          	bne	a4,a5,676 <mmap_test+0x544>
    err("write to MAP_PRIVATE was written to file");
  if(read(fd, buf, PGSIZE) != PGSIZE/2) err("read");
     246:	6605                	lui	a2,0x1
     248:	00002597          	auipc	a1,0x2
     24c:	dc858593          	addi	a1,a1,-568 # 2010 <buf>
     250:	8526                	mv	a0,s1
     252:	56d000ef          	jal	fbe <read>
     256:	8005079b          	addiw	a5,a0,-2048
     25a:	42079463          	bnez	a5,682 <mmap_test+0x550>
  if(buf[0] != 'A')
     25e:	00002717          	auipc	a4,0x2
     262:	db274703          	lbu	a4,-590(a4) # 2010 <buf>
     266:	04100793          	li	a5,65
     26a:	42f71263          	bne	a4,a5,68e <mmap_test+0x55c>
    err("write to MAP_PRIVATE was written to file");
  close(fd);
     26e:	8526                	mv	a0,s1
     270:	55f000ef          	jal	fce <close>

  printf("test mmap private: OK\n");
     274:	00001517          	auipc	a0,0x1
     278:	4ec50513          	addi	a0,a0,1260 # 1760 <malloc+0x2ac>
     27c:	180010ef          	jal	13fc <printf>

  printf("test mmap read-only\n");
     280:	00001517          	auipc	a0,0x1
     284:	4f850513          	addi	a0,a0,1272 # 1778 <malloc+0x2c4>
     288:	174010ef          	jal	13fc <printf>

  // check that mmap doesn't allow read/write mapping of a
  // file opened read-only.
  if ((fd = open(f, O_RDONLY)) == -1)
     28c:	4581                	li	a1,0
     28e:	00001517          	auipc	a0,0x1
     292:	3e250513          	addi	a0,a0,994 # 1670 <malloc+0x1bc>
     296:	551000ef          	jal	fe6 <open>
     29a:	84aa                	mv	s1,a0
     29c:	57fd                	li	a5,-1
     29e:	3ef50e63          	beq	a0,a5,69a <mmap_test+0x568>
    err("open (2)");
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2a2:	4781                	li	a5,0
     2a4:	872a                	mv	a4,a0
     2a6:	4685                	li	a3,1
     2a8:	460d                	li	a2,3
     2aa:	6589                	lui	a1,0x2
     2ac:	4501                	li	a0,0
     2ae:	599000ef          	jal	1046 <mmap>
  if (p != MAP_FAILED)
     2b2:	57fd                	li	a5,-1
     2b4:	3ef51963          	bne	a0,a5,6a6 <mmap_test+0x574>
    err("mmap (3)");
  if (close(fd) == -1)
     2b8:	8526                	mv	a0,s1
     2ba:	515000ef          	jal	fce <close>
     2be:	57fd                	li	a5,-1
     2c0:	3ef50963          	beq	a0,a5,6b2 <mmap_test+0x580>
    err("close (2)");

  printf("test mmap read-only: OK\n");
     2c4:	00001517          	auipc	a0,0x1
     2c8:	4fc50513          	addi	a0,a0,1276 # 17c0 <malloc+0x30c>
     2cc:	130010ef          	jal	13fc <printf>

  printf("test mmap read/write\n");
     2d0:	00001517          	auipc	a0,0x1
     2d4:	51050513          	addi	a0,a0,1296 # 17e0 <malloc+0x32c>
     2d8:	124010ef          	jal	13fc <printf>

  // check that mmap does allow read/write mapping of a
  // file opened read/write.
  if ((fd = open(f, O_RDWR)) == -1)
     2dc:	4589                	li	a1,2
     2de:	00001517          	auipc	a0,0x1
     2e2:	39250513          	addi	a0,a0,914 # 1670 <malloc+0x1bc>
     2e6:	501000ef          	jal	fe6 <open>
     2ea:	84aa                	mv	s1,a0
     2ec:	57fd                	li	a5,-1
     2ee:	3cf50863          	beq	a0,a5,6be <mmap_test+0x58c>
    err("open (3)");
  p = mmap(0, PGSIZE*3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2f2:	4781                	li	a5,0
     2f4:	872a                	mv	a4,a0
     2f6:	4685                	li	a3,1
     2f8:	460d                	li	a2,3
     2fa:	658d                	lui	a1,0x3
     2fc:	4501                	li	a0,0
     2fe:	549000ef          	jal	1046 <mmap>
     302:	892a                	mv	s2,a0
  if (p == MAP_FAILED)
     304:	57fd                	li	a5,-1
     306:	3cf50263          	beq	a0,a5,6ca <mmap_test+0x598>
    err("mmap (4)");
  if (close(fd) == -1)
     30a:	8526                	mv	a0,s1
     30c:	4c3000ef          	jal	fce <close>
     310:	57fd                	li	a5,-1
     312:	3cf50263          	beq	a0,a5,6d6 <mmap_test+0x5a4>
    err("close (3)");

  // check that the mapping still works after close(fd).
  _v1(p);
     316:	854a                	mv	a0,s2
     318:	d0fff0ef          	jal	26 <_v1>

  // write the mapped memory.
  for (i = 0; i < PGSIZE; i++)
     31c:	6785                	lui	a5,0x1
     31e:	97ca                	add	a5,a5,s2
  _v1(p);
     320:	874a                	mv	a4,s2
    p[i] = 'B';
     322:	04200693          	li	a3,66
     326:	00d70023          	sb	a3,0(a4)
  for (i = 0; i < PGSIZE; i++)
     32a:	0705                	addi	a4,a4,1
     32c:	fee79de3          	bne	a5,a4,326 <mmap_test+0x1f4>
     330:	6709                	lui	a4,0x2
     332:	974a                	add	a4,a4,s2
  for (i = PGSIZE; i < PGSIZE*2; i++)
    p[i] = 'C';
     334:	04300693          	li	a3,67
     338:	00d78023          	sb	a3,0(a5) # 1000 <fstat+0x2>
  for (i = PGSIZE; i < PGSIZE*2; i++)
     33c:	0785                	addi	a5,a5,1
     33e:	fef71de3          	bne	a4,a5,338 <mmap_test+0x206>

  // unmap just the first two of three pages of mapped memory.
  if (munmap(p, PGSIZE*2) == -1)
     342:	6589                	lui	a1,0x2
     344:	854a                	mv	a0,s2
     346:	509000ef          	jal	104e <munmap>
     34a:	57fd                	li	a5,-1
     34c:	38f50b63          	beq	a0,a5,6e2 <mmap_test+0x5b0>
    err("munmap (3)");

  printf("test mmap read/write: OK\n");
     350:	00001517          	auipc	a0,0x1
     354:	4e850513          	addi	a0,a0,1256 # 1838 <malloc+0x384>
     358:	0a4010ef          	jal	13fc <printf>

  printf("test mmap dirty\n");
     35c:	00001517          	auipc	a0,0x1
     360:	4fc50513          	addi	a0,a0,1276 # 1858 <malloc+0x3a4>
     364:	098010ef          	jal	13fc <printf>

  // check that the writes to the mapped memory were
  // written to the file.
  if ((fd = open(f, O_RDONLY)) == -1)
     368:	4581                	li	a1,0
     36a:	00001517          	auipc	a0,0x1
     36e:	30650513          	addi	a0,a0,774 # 1670 <malloc+0x1bc>
     372:	475000ef          	jal	fe6 <open>
     376:	89aa                	mv	s3,a0
     378:	57fd                	li	a5,-1
     37a:	36f50a63          	beq	a0,a5,6ee <mmap_test+0x5bc>
    err("open (4)");
  if(read(fd, buf, PGSIZE) != PGSIZE)
     37e:	6605                	lui	a2,0x1
     380:	00002597          	auipc	a1,0x2
     384:	c9058593          	addi	a1,a1,-880 # 2010 <buf>
     388:	437000ef          	jal	fbe <read>
     38c:	6785                	lui	a5,0x1
     38e:	36f51663          	bne	a0,a5,6fa <mmap_test+0x5c8>
     392:	00002497          	auipc	s1,0x2
     396:	c7e48493          	addi	s1,s1,-898 # 2010 <buf>
     39a:	00003617          	auipc	a2,0x3
     39e:	c7660613          	addi	a2,a2,-906 # 3010 <base>
     3a2:	87a6                	mv	a5,s1
    err("dirty read #1");
  for (i = 0; i < PGSIZE; i++){
    if (buf[i] != 'B')
     3a4:	04200693          	li	a3,66
     3a8:	0007c703          	lbu	a4,0(a5) # 1000 <fstat+0x2>
     3ac:	34d71d63          	bne	a4,a3,706 <mmap_test+0x5d4>
  for (i = 0; i < PGSIZE; i++){
     3b0:	0785                	addi	a5,a5,1
     3b2:	fec79be3          	bne	a5,a2,3a8 <mmap_test+0x276>
      err("file page 0 does not contain modifications");
  }
  if(read(fd, buf, PGSIZE) != PGSIZE/2)
     3b6:	6605                	lui	a2,0x1
     3b8:	00002597          	auipc	a1,0x2
     3bc:	c5858593          	addi	a1,a1,-936 # 2010 <buf>
     3c0:	854e                	mv	a0,s3
     3c2:	3fd000ef          	jal	fbe <read>
     3c6:	8005079b          	addiw	a5,a0,-2048
     3ca:	34079463          	bnez	a5,712 <mmap_test+0x5e0>
     3ce:	7ff48713          	addi	a4,s1,2047
     3d2:	0705                	addi	a4,a4,1 # 2001 <freep+0x1>
    err("dirty read #2");
  for (i = 0; i < PGSIZE/2; i++){
    if (buf[i] != 'C')
     3d4:	04300693          	li	a3,67
     3d8:	0004c783          	lbu	a5,0(s1)
     3dc:	34d79163          	bne	a5,a3,71e <mmap_test+0x5ec>
  for (i = 0; i < PGSIZE/2; i++){
     3e0:	0485                	addi	s1,s1,1
     3e2:	fee49be3          	bne	s1,a4,3d8 <mmap_test+0x2a6>
      err("file page 1 does not contain modifications");
  }
  if (close(fd) == -1)
     3e6:	854e                	mv	a0,s3
     3e8:	3e7000ef          	jal	fce <close>
     3ec:	57fd                	li	a5,-1
     3ee:	32f50e63          	beq	a0,a5,72a <mmap_test+0x5f8>
    err("close (4)");

  printf("test mmap dirty: OK\n");
     3f2:	00001517          	auipc	a0,0x1
     3f6:	51e50513          	addi	a0,a0,1310 # 1910 <malloc+0x45c>
     3fa:	002010ef          	jal	13fc <printf>

  printf("test not-mapped unmap\n");
     3fe:	00001517          	auipc	a0,0x1
     402:	52a50513          	addi	a0,a0,1322 # 1928 <malloc+0x474>
     406:	7f7000ef          	jal	13fc <printf>

  // unmap the rest of the mapped memory.
  if (munmap(p+PGSIZE*2, PGSIZE) == -1)
     40a:	6585                	lui	a1,0x1
     40c:	6509                	lui	a0,0x2
     40e:	954a                	add	a0,a0,s2
     410:	43f000ef          	jal	104e <munmap>
     414:	57fd                	li	a5,-1
     416:	32f50063          	beq	a0,a5,736 <mmap_test+0x604>
    err("munmap (4)");

  printf("test not-mapped unmap: OK\n");
     41a:	00001517          	auipc	a0,0x1
     41e:	53650513          	addi	a0,a0,1334 # 1950 <malloc+0x49c>
     422:	7db000ef          	jal	13fc <printf>

  printf("test lazy access\n");
     426:	00001517          	auipc	a0,0x1
     42a:	54a50513          	addi	a0,a0,1354 # 1970 <malloc+0x4bc>
     42e:	7cf000ef          	jal	13fc <printf>

  if(unlink(f) != 0) err("unlink");
     432:	00001517          	auipc	a0,0x1
     436:	23e50513          	addi	a0,a0,574 # 1670 <malloc+0x1bc>
     43a:	3bd000ef          	jal	ff6 <unlink>
     43e:	30051263          	bnez	a0,742 <mmap_test+0x610>
  makefile(f);
     442:	00001517          	auipc	a0,0x1
     446:	22e50513          	addi	a0,a0,558 # 1670 <malloc+0x1bc>
     44a:	c4dff0ef          	jal	96 <makefile>

  if ((fd = open(f, O_RDWR)) == -1)
     44e:	4589                	li	a1,2
     450:	00001517          	auipc	a0,0x1
     454:	22050513          	addi	a0,a0,544 # 1670 <malloc+0x1bc>
     458:	38f000ef          	jal	fe6 <open>
     45c:	892a                	mv	s2,a0
     45e:	57fd                	li	a5,-1
     460:	2ef50763          	beq	a0,a5,74e <mmap_test+0x61c>
    err("open");
  p = mmap(0, PGSIZE*2, PROT_READ|PROT_WRITE, MAP_SHARED, fd, 0);
     464:	4781                	li	a5,0
     466:	872a                	mv	a4,a0
     468:	4685                	li	a3,1
     46a:	460d                	li	a2,3
     46c:	6589                	lui	a1,0x2
     46e:	4501                	li	a0,0
     470:	3d7000ef          	jal	1046 <mmap>
     474:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     476:	57fd                	li	a5,-1
     478:	2ef50163          	beq	a0,a5,75a <mmap_test+0x628>
    err("mmap");
  close(fd);
     47c:	854a                	mv	a0,s2
     47e:	351000ef          	jal	fce <close>
  // mmap() should not have read the file at this point,
  // so that the file modification we're about to make
  // ought to be visible to a subsequent read of the
  // mapped memory.

  if((fd = open(f, O_RDWR)) == -1)
     482:	4589                	li	a1,2
     484:	00001517          	auipc	a0,0x1
     488:	1ec50513          	addi	a0,a0,492 # 1670 <malloc+0x1bc>
     48c:	35b000ef          	jal	fe6 <open>
     490:	892a                	mv	s2,a0
     492:	57fd                	li	a5,-1
     494:	2cf50963          	beq	a0,a5,766 <mmap_test+0x634>
    err("open");
  if(write(fd, "m", 1) != 1)
     498:	4605                	li	a2,1
     49a:	00001597          	auipc	a1,0x1
     49e:	4fe58593          	addi	a1,a1,1278 # 1998 <malloc+0x4e4>
     4a2:	325000ef          	jal	fc6 <write>
     4a6:	4785                	li	a5,1
     4a8:	2cf51563          	bne	a0,a5,772 <mmap_test+0x640>
    err("write");
  close(fd);
     4ac:	854a                	mv	a0,s2
     4ae:	321000ef          	jal	fce <close>

  if(*p != 'm')
     4b2:	0004c703          	lbu	a4,0(s1)
     4b6:	06d00793          	li	a5,109
     4ba:	2cf71263          	bne	a4,a5,77e <mmap_test+0x64c>
    err("read was not lazy");

  if(munmap(p, PGSIZE*2) == -1)
     4be:	6589                	lui	a1,0x2
     4c0:	8526                	mv	a0,s1
     4c2:	38d000ef          	jal	104e <munmap>
     4c6:	57fd                	li	a5,-1
     4c8:	2cf50163          	beq	a0,a5,78a <mmap_test+0x658>
    err("munmap");

  printf("test lazy access: OK\n");
     4cc:	00001517          	auipc	a0,0x1
     4d0:	4fc50513          	addi	a0,a0,1276 # 19c8 <malloc+0x514>
     4d4:	729000ef          	jal	13fc <printf>

  printf("test mmap two files\n");
     4d8:	00001517          	auipc	a0,0x1
     4dc:	50850513          	addi	a0,a0,1288 # 19e0 <malloc+0x52c>
     4e0:	71d000ef          	jal	13fc <printf>

  //
  // mmap two different files at the same time.
  //
  int fd1;
  if((fd1 = open("mmap1", O_RDWR|O_CREATE)) < 0)
     4e4:	20200593          	li	a1,514
     4e8:	00001517          	auipc	a0,0x1
     4ec:	51050513          	addi	a0,a0,1296 # 19f8 <malloc+0x544>
     4f0:	2f7000ef          	jal	fe6 <open>
     4f4:	84aa                	mv	s1,a0
     4f6:	2a054063          	bltz	a0,796 <mmap_test+0x664>
    err("open (5)");
  if(write(fd1, "12345", 5) != 5)
     4fa:	4615                	li	a2,5
     4fc:	00001597          	auipc	a1,0x1
     500:	51458593          	addi	a1,a1,1300 # 1a10 <malloc+0x55c>
     504:	2c3000ef          	jal	fc6 <write>
     508:	4795                	li	a5,5
     50a:	28f51c63          	bne	a0,a5,7a2 <mmap_test+0x670>
    err("write (1)");
  char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     50e:	4781                	li	a5,0
     510:	8726                	mv	a4,s1
     512:	4689                	li	a3,2
     514:	4605                	li	a2,1
     516:	6585                	lui	a1,0x1
     518:	4501                	li	a0,0
     51a:	32d000ef          	jal	1046 <mmap>
     51e:	89aa                	mv	s3,a0
  if(p1 == MAP_FAILED)
     520:	57fd                	li	a5,-1
     522:	28f50663          	beq	a0,a5,7ae <mmap_test+0x67c>
    err("mmap (5)");
  if (close(fd1) == -1)
     526:	8526                	mv	a0,s1
     528:	2a7000ef          	jal	fce <close>
     52c:	57fd                	li	a5,-1
     52e:	28f50663          	beq	a0,a5,7ba <mmap_test+0x688>
    err("close (5)");
  if (unlink("mmap1") == -1)
     532:	00001517          	auipc	a0,0x1
     536:	4c650513          	addi	a0,a0,1222 # 19f8 <malloc+0x544>
     53a:	2bd000ef          	jal	ff6 <unlink>
     53e:	57fd                	li	a5,-1
     540:	28f50363          	beq	a0,a5,7c6 <mmap_test+0x694>
    err("unlink (1)");

  int fd2;
  if((fd2 = open("mmap2", O_RDWR|O_CREATE)) < 0)
     544:	20200593          	li	a1,514
     548:	00001517          	auipc	a0,0x1
     54c:	51050513          	addi	a0,a0,1296 # 1a58 <malloc+0x5a4>
     550:	297000ef          	jal	fe6 <open>
     554:	892a                	mv	s2,a0
     556:	26054e63          	bltz	a0,7d2 <mmap_test+0x6a0>
    err("open (6)");
  if(write(fd2, "67890", 5) != 5)
     55a:	4615                	li	a2,5
     55c:	00001597          	auipc	a1,0x1
     560:	51458593          	addi	a1,a1,1300 # 1a70 <malloc+0x5bc>
     564:	263000ef          	jal	fc6 <write>
     568:	4795                	li	a5,5
     56a:	26f51a63          	bne	a0,a5,7de <mmap_test+0x6ac>
    err("write (2)");
  char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     56e:	4781                	li	a5,0
     570:	874a                	mv	a4,s2
     572:	4689                	li	a3,2
     574:	4605                	li	a2,1
     576:	6585                	lui	a1,0x1
     578:	4501                	li	a0,0
     57a:	2cd000ef          	jal	1046 <mmap>
     57e:	84aa                	mv	s1,a0
  if(p2 == MAP_FAILED)
     580:	57fd                	li	a5,-1
     582:	26f50463          	beq	a0,a5,7ea <mmap_test+0x6b8>
    err("mmap (6)");
  if (close(fd2) == -1)
     586:	854a                	mv	a0,s2
     588:	247000ef          	jal	fce <close>
     58c:	57fd                	li	a5,-1
     58e:	26f50463          	beq	a0,a5,7f6 <mmap_test+0x6c4>
    err("close (6)");
  if (unlink("mmap2") == -1)
     592:	00001517          	auipc	a0,0x1
     596:	4c650513          	addi	a0,a0,1222 # 1a58 <malloc+0x5a4>
     59a:	25d000ef          	jal	ff6 <unlink>
     59e:	57fd                	li	a5,-1
     5a0:	26f50163          	beq	a0,a5,802 <mmap_test+0x6d0>
    err("unlink (2)");

  if(memcmp(p1, "12345", 5) != 0)
     5a4:	4615                	li	a2,5
     5a6:	00001597          	auipc	a1,0x1
     5aa:	46a58593          	addi	a1,a1,1130 # 1a10 <malloc+0x55c>
     5ae:	854e                	mv	a0,s3
     5b0:	175000ef          	jal	f24 <memcmp>
     5b4:	24051d63          	bnez	a0,80e <mmap_test+0x6dc>
    err("mmap1 mismatch");
  if(memcmp(p2, "67890", 5) != 0)
     5b8:	4615                	li	a2,5
     5ba:	00001597          	auipc	a1,0x1
     5be:	4b658593          	addi	a1,a1,1206 # 1a70 <malloc+0x5bc>
     5c2:	8526                	mv	a0,s1
     5c4:	161000ef          	jal	f24 <memcmp>
     5c8:	24051963          	bnez	a0,81a <mmap_test+0x6e8>
    err("mmap2 mismatch");

  if (munmap(p1, PGSIZE) == -1)
     5cc:	6585                	lui	a1,0x1
     5ce:	854e                	mv	a0,s3
     5d0:	27f000ef          	jal	104e <munmap>
     5d4:	57fd                	li	a5,-1
     5d6:	24f50863          	beq	a0,a5,826 <mmap_test+0x6f4>
    err("munmap (5)");
  if(memcmp(p2, "67890", 5) != 0)
     5da:	4615                	li	a2,5
     5dc:	00001597          	auipc	a1,0x1
     5e0:	49458593          	addi	a1,a1,1172 # 1a70 <malloc+0x5bc>
     5e4:	8526                	mv	a0,s1
     5e6:	13f000ef          	jal	f24 <memcmp>
     5ea:	24051463          	bnez	a0,832 <mmap_test+0x700>
    err("mmap2 mismatch (2)");
  if (munmap(p2, PGSIZE) == -1)
     5ee:	6585                	lui	a1,0x1
     5f0:	8526                	mv	a0,s1
     5f2:	25d000ef          	jal	104e <munmap>
     5f6:	57fd                	li	a5,-1
     5f8:	24f50363          	beq	a0,a5,83e <mmap_test+0x70c>
    err("munmap (6)");

  printf("test mmap two files: OK\n");
     5fc:	00001517          	auipc	a0,0x1
     600:	51450513          	addi	a0,a0,1300 # 1b10 <malloc+0x65c>
     604:	5f9000ef          	jal	13fc <printf>
}
     608:	70a2                	ld	ra,40(sp)
     60a:	7402                	ld	s0,32(sp)
     60c:	64e2                	ld	s1,24(sp)
     60e:	6942                	ld	s2,16(sp)
     610:	69a2                	ld	s3,8(sp)
     612:	6145                	addi	sp,sp,48
     614:	8082                	ret
    err("open (1)");
     616:	00001517          	auipc	a0,0x1
     61a:	06a50513          	addi	a0,a0,106 # 1680 <malloc+0x1cc>
     61e:	9e3ff0ef          	jal	0 <err>
    err("mmap (1)");
     622:	00001517          	auipc	a0,0x1
     626:	08650513          	addi	a0,a0,134 # 16a8 <malloc+0x1f4>
     62a:	9d7ff0ef          	jal	0 <err>
    err("munmap (1)");
     62e:	00001517          	auipc	a0,0x1
     632:	0a250513          	addi	a0,a0,162 # 16d0 <malloc+0x21c>
     636:	9cbff0ef          	jal	0 <err>
    err("mmap (2)");
     63a:	00001517          	auipc	a0,0x1
     63e:	0be50513          	addi	a0,a0,190 # 16f8 <malloc+0x244>
     642:	9bfff0ef          	jal	0 <err>
    err("close (1)");
     646:	00001517          	auipc	a0,0x1
     64a:	0c250513          	addi	a0,a0,194 # 1708 <malloc+0x254>
     64e:	9b3ff0ef          	jal	0 <err>
    err("munmap (2)");
     652:	00001517          	auipc	a0,0x1
     656:	0c650513          	addi	a0,a0,198 # 1718 <malloc+0x264>
     65a:	9a7ff0ef          	jal	0 <err>
  if((fd = open(f, O_RDONLY)) < 0) err("open");
     65e:	00001517          	auipc	a0,0x1
     662:	fea50513          	addi	a0,a0,-22 # 1648 <malloc+0x194>
     666:	99bff0ef          	jal	0 <err>
  if(read(fd, buf, PGSIZE) != PGSIZE) err("read");
     66a:	00001517          	auipc	a0,0x1
     66e:	0be50513          	addi	a0,a0,190 # 1728 <malloc+0x274>
     672:	98fff0ef          	jal	0 <err>
    err("write to MAP_PRIVATE was written to file");
     676:	00001517          	auipc	a0,0x1
     67a:	0ba50513          	addi	a0,a0,186 # 1730 <malloc+0x27c>
     67e:	983ff0ef          	jal	0 <err>
  if(read(fd, buf, PGSIZE) != PGSIZE/2) err("read");
     682:	00001517          	auipc	a0,0x1
     686:	0a650513          	addi	a0,a0,166 # 1728 <malloc+0x274>
     68a:	977ff0ef          	jal	0 <err>
    err("write to MAP_PRIVATE was written to file");
     68e:	00001517          	auipc	a0,0x1
     692:	0a250513          	addi	a0,a0,162 # 1730 <malloc+0x27c>
     696:	96bff0ef          	jal	0 <err>
    err("open (2)");
     69a:	00001517          	auipc	a0,0x1
     69e:	0f650513          	addi	a0,a0,246 # 1790 <malloc+0x2dc>
     6a2:	95fff0ef          	jal	0 <err>
    err("mmap (3)");
     6a6:	00001517          	auipc	a0,0x1
     6aa:	0fa50513          	addi	a0,a0,250 # 17a0 <malloc+0x2ec>
     6ae:	953ff0ef          	jal	0 <err>
    err("close (2)");
     6b2:	00001517          	auipc	a0,0x1
     6b6:	0fe50513          	addi	a0,a0,254 # 17b0 <malloc+0x2fc>
     6ba:	947ff0ef          	jal	0 <err>
    err("open (3)");
     6be:	00001517          	auipc	a0,0x1
     6c2:	13a50513          	addi	a0,a0,314 # 17f8 <malloc+0x344>
     6c6:	93bff0ef          	jal	0 <err>
    err("mmap (4)");
     6ca:	00001517          	auipc	a0,0x1
     6ce:	13e50513          	addi	a0,a0,318 # 1808 <malloc+0x354>
     6d2:	92fff0ef          	jal	0 <err>
    err("close (3)");
     6d6:	00001517          	auipc	a0,0x1
     6da:	14250513          	addi	a0,a0,322 # 1818 <malloc+0x364>
     6de:	923ff0ef          	jal	0 <err>
    err("munmap (3)");
     6e2:	00001517          	auipc	a0,0x1
     6e6:	14650513          	addi	a0,a0,326 # 1828 <malloc+0x374>
     6ea:	917ff0ef          	jal	0 <err>
    err("open (4)");
     6ee:	00001517          	auipc	a0,0x1
     6f2:	18250513          	addi	a0,a0,386 # 1870 <malloc+0x3bc>
     6f6:	90bff0ef          	jal	0 <err>
    err("dirty read #1");
     6fa:	00001517          	auipc	a0,0x1
     6fe:	18650513          	addi	a0,a0,390 # 1880 <malloc+0x3cc>
     702:	8ffff0ef          	jal	0 <err>
      err("file page 0 does not contain modifications");
     706:	00001517          	auipc	a0,0x1
     70a:	18a50513          	addi	a0,a0,394 # 1890 <malloc+0x3dc>
     70e:	8f3ff0ef          	jal	0 <err>
    err("dirty read #2");
     712:	00001517          	auipc	a0,0x1
     716:	1ae50513          	addi	a0,a0,430 # 18c0 <malloc+0x40c>
     71a:	8e7ff0ef          	jal	0 <err>
      err("file page 1 does not contain modifications");
     71e:	00001517          	auipc	a0,0x1
     722:	1b250513          	addi	a0,a0,434 # 18d0 <malloc+0x41c>
     726:	8dbff0ef          	jal	0 <err>
    err("close (4)");
     72a:	00001517          	auipc	a0,0x1
     72e:	1d650513          	addi	a0,a0,470 # 1900 <malloc+0x44c>
     732:	8cfff0ef          	jal	0 <err>
    err("munmap (4)");
     736:	00001517          	auipc	a0,0x1
     73a:	20a50513          	addi	a0,a0,522 # 1940 <malloc+0x48c>
     73e:	8c3ff0ef          	jal	0 <err>
  if(unlink(f) != 0) err("unlink");
     742:	00001517          	auipc	a0,0x1
     746:	24650513          	addi	a0,a0,582 # 1988 <malloc+0x4d4>
     74a:	8b7ff0ef          	jal	0 <err>
    err("open");
     74e:	00001517          	auipc	a0,0x1
     752:	efa50513          	addi	a0,a0,-262 # 1648 <malloc+0x194>
     756:	8abff0ef          	jal	0 <err>
    err("mmap");
     75a:	00001517          	auipc	a0,0x1
     75e:	23650513          	addi	a0,a0,566 # 1990 <malloc+0x4dc>
     762:	89fff0ef          	jal	0 <err>
    err("open");
     766:	00001517          	auipc	a0,0x1
     76a:	ee250513          	addi	a0,a0,-286 # 1648 <malloc+0x194>
     76e:	893ff0ef          	jal	0 <err>
    err("write");
     772:	00001517          	auipc	a0,0x1
     776:	22e50513          	addi	a0,a0,558 # 19a0 <malloc+0x4ec>
     77a:	887ff0ef          	jal	0 <err>
    err("read was not lazy");
     77e:	00001517          	auipc	a0,0x1
     782:	22a50513          	addi	a0,a0,554 # 19a8 <malloc+0x4f4>
     786:	87bff0ef          	jal	0 <err>
    err("munmap");
     78a:	00001517          	auipc	a0,0x1
     78e:	23650513          	addi	a0,a0,566 # 19c0 <malloc+0x50c>
     792:	86fff0ef          	jal	0 <err>
    err("open (5)");
     796:	00001517          	auipc	a0,0x1
     79a:	26a50513          	addi	a0,a0,618 # 1a00 <malloc+0x54c>
     79e:	863ff0ef          	jal	0 <err>
    err("write (1)");
     7a2:	00001517          	auipc	a0,0x1
     7a6:	27650513          	addi	a0,a0,630 # 1a18 <malloc+0x564>
     7aa:	857ff0ef          	jal	0 <err>
    err("mmap (5)");
     7ae:	00001517          	auipc	a0,0x1
     7b2:	27a50513          	addi	a0,a0,634 # 1a28 <malloc+0x574>
     7b6:	84bff0ef          	jal	0 <err>
    err("close (5)");
     7ba:	00001517          	auipc	a0,0x1
     7be:	27e50513          	addi	a0,a0,638 # 1a38 <malloc+0x584>
     7c2:	83fff0ef          	jal	0 <err>
    err("unlink (1)");
     7c6:	00001517          	auipc	a0,0x1
     7ca:	28250513          	addi	a0,a0,642 # 1a48 <malloc+0x594>
     7ce:	833ff0ef          	jal	0 <err>
    err("open (6)");
     7d2:	00001517          	auipc	a0,0x1
     7d6:	28e50513          	addi	a0,a0,654 # 1a60 <malloc+0x5ac>
     7da:	827ff0ef          	jal	0 <err>
    err("write (2)");
     7de:	00001517          	auipc	a0,0x1
     7e2:	29a50513          	addi	a0,a0,666 # 1a78 <malloc+0x5c4>
     7e6:	81bff0ef          	jal	0 <err>
    err("mmap (6)");
     7ea:	00001517          	auipc	a0,0x1
     7ee:	29e50513          	addi	a0,a0,670 # 1a88 <malloc+0x5d4>
     7f2:	80fff0ef          	jal	0 <err>
    err("close (6)");
     7f6:	00001517          	auipc	a0,0x1
     7fa:	2a250513          	addi	a0,a0,674 # 1a98 <malloc+0x5e4>
     7fe:	803ff0ef          	jal	0 <err>
    err("unlink (2)");
     802:	00001517          	auipc	a0,0x1
     806:	2a650513          	addi	a0,a0,678 # 1aa8 <malloc+0x5f4>
     80a:	ff6ff0ef          	jal	0 <err>
    err("mmap1 mismatch");
     80e:	00001517          	auipc	a0,0x1
     812:	2aa50513          	addi	a0,a0,682 # 1ab8 <malloc+0x604>
     816:	feaff0ef          	jal	0 <err>
    err("mmap2 mismatch");
     81a:	00001517          	auipc	a0,0x1
     81e:	2ae50513          	addi	a0,a0,686 # 1ac8 <malloc+0x614>
     822:	fdeff0ef          	jal	0 <err>
    err("munmap (5)");
     826:	00001517          	auipc	a0,0x1
     82a:	2b250513          	addi	a0,a0,690 # 1ad8 <malloc+0x624>
     82e:	fd2ff0ef          	jal	0 <err>
    err("mmap2 mismatch (2)");
     832:	00001517          	auipc	a0,0x1
     836:	2b650513          	addi	a0,a0,694 # 1ae8 <malloc+0x634>
     83a:	fc6ff0ef          	jal	0 <err>
    err("munmap (6)");
     83e:	00001517          	auipc	a0,0x1
     842:	2c250513          	addi	a0,a0,706 # 1b00 <malloc+0x64c>
     846:	fbaff0ef          	jal	0 <err>

000000000000084a <fork_test>:
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void
fork_test(void)
{
     84a:	7179                	addi	sp,sp,-48
     84c:	f406                	sd	ra,40(sp)
     84e:	f022                	sd	s0,32(sp)
     850:	ec26                	sd	s1,24(sp)
     852:	e84a                	sd	s2,16(sp)
     854:	1800                	addi	s0,sp,48
  int fd;
  int pid;
  const char * const f = "mmap.dur";

  printf("test fork\n");
     856:	00001517          	auipc	a0,0x1
     85a:	2da50513          	addi	a0,a0,730 # 1b30 <malloc+0x67c>
     85e:	39f000ef          	jal	13fc <printf>

  // mmap the file twice.
  makefile(f);
     862:	00001517          	auipc	a0,0x1
     866:	e0e50513          	addi	a0,a0,-498 # 1670 <malloc+0x1bc>
     86a:	82dff0ef          	jal	96 <makefile>
  if ((fd = open(f, O_RDONLY)) == -1)
     86e:	4581                	li	a1,0
     870:	00001517          	auipc	a0,0x1
     874:	e0050513          	addi	a0,a0,-512 # 1670 <malloc+0x1bc>
     878:	76e000ef          	jal	fe6 <open>
     87c:	57fd                	li	a5,-1
     87e:	06f50e63          	beq	a0,a5,8fa <fork_test+0xb0>
     882:	892a                	mv	s2,a0
    err("open (7)");
  if (unlink(f) == -1)
     884:	00001517          	auipc	a0,0x1
     888:	dec50513          	addi	a0,a0,-532 # 1670 <malloc+0x1bc>
     88c:	76a000ef          	jal	ff6 <unlink>
     890:	57fd                	li	a5,-1
     892:	06f50a63          	beq	a0,a5,906 <fork_test+0xbc>
    err("unlink (3)");
  char *p1 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     896:	4781                	li	a5,0
     898:	874a                	mv	a4,s2
     89a:	4685                	li	a3,1
     89c:	8636                	mv	a2,a3
     89e:	6589                	lui	a1,0x2
     8a0:	4501                	li	a0,0
     8a2:	7a4000ef          	jal	1046 <mmap>
     8a6:	84aa                	mv	s1,a0
  if (p1 == MAP_FAILED)
     8a8:	57fd                	li	a5,-1
     8aa:	06f50463          	beq	a0,a5,912 <fork_test+0xc8>
    err("mmap (7)");
  char *p2 = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     8ae:	4781                	li	a5,0
     8b0:	874a                	mv	a4,s2
     8b2:	4685                	li	a3,1
     8b4:	8636                	mv	a2,a3
     8b6:	6589                	lui	a1,0x2
     8b8:	4501                	li	a0,0
     8ba:	78c000ef          	jal	1046 <mmap>
     8be:	892a                	mv	s2,a0
  if (p2 == MAP_FAILED)
     8c0:	57fd                	li	a5,-1
     8c2:	04f50e63          	beq	a0,a5,91e <fork_test+0xd4>
    err("mmap (8)");

  // read just 2nd page.
  if(*(p1+PGSIZE) != 'A')
     8c6:	6785                	lui	a5,0x1
     8c8:	97a6                	add	a5,a5,s1
     8ca:	0007c703          	lbu	a4,0(a5) # 1000 <fstat+0x2>
     8ce:	04100793          	li	a5,65
     8d2:	04f71c63          	bne	a4,a5,92a <fork_test+0xe0>
    err("fork mismatch (1)");

  if((pid = fork()) < 0)
     8d6:	6c8000ef          	jal	f9e <fork>
     8da:	04054e63          	bltz	a0,936 <fork_test+0xec>
    err("fork");
  if (pid == 0) {
     8de:	e925                	bnez	a0,94e <fork_test+0x104>
    _v1(p1);
     8e0:	8526                	mv	a0,s1
     8e2:	f44ff0ef          	jal	26 <_v1>
    if (munmap(p1, PGSIZE) == -1) // just the first page
     8e6:	6585                	lui	a1,0x1
     8e8:	8526                	mv	a0,s1
     8ea:	764000ef          	jal	104e <munmap>
     8ee:	57fd                	li	a5,-1
     8f0:	04f50963          	beq	a0,a5,942 <fork_test+0xf8>
      err("munmap (7)");
    exit(0); // tell the parent that the mapping looks OK.
     8f4:	4501                	li	a0,0
     8f6:	6b0000ef          	jal	fa6 <exit>
    err("open (7)");
     8fa:	00001517          	auipc	a0,0x1
     8fe:	24650513          	addi	a0,a0,582 # 1b40 <malloc+0x68c>
     902:	efeff0ef          	jal	0 <err>
    err("unlink (3)");
     906:	00001517          	auipc	a0,0x1
     90a:	24a50513          	addi	a0,a0,586 # 1b50 <malloc+0x69c>
     90e:	ef2ff0ef          	jal	0 <err>
    err("mmap (7)");
     912:	00001517          	auipc	a0,0x1
     916:	24e50513          	addi	a0,a0,590 # 1b60 <malloc+0x6ac>
     91a:	ee6ff0ef          	jal	0 <err>
    err("mmap (8)");
     91e:	00001517          	auipc	a0,0x1
     922:	25250513          	addi	a0,a0,594 # 1b70 <malloc+0x6bc>
     926:	edaff0ef          	jal	0 <err>
    err("fork mismatch (1)");
     92a:	00001517          	auipc	a0,0x1
     92e:	25650513          	addi	a0,a0,598 # 1b80 <malloc+0x6cc>
     932:	eceff0ef          	jal	0 <err>
    err("fork");
     936:	00001517          	auipc	a0,0x1
     93a:	26250513          	addi	a0,a0,610 # 1b98 <malloc+0x6e4>
     93e:	ec2ff0ef          	jal	0 <err>
      err("munmap (7)");
     942:	00001517          	auipc	a0,0x1
     946:	25e50513          	addi	a0,a0,606 # 1ba0 <malloc+0x6ec>
     94a:	eb6ff0ef          	jal	0 <err>
  }

  int status = -1;
     94e:	57fd                	li	a5,-1
     950:	fcf42e23          	sw	a5,-36(s0)
  wait(&status);
     954:	fdc40513          	addi	a0,s0,-36
     958:	656000ef          	jal	fae <wait>

  if(status != 0){
     95c:	fdc42783          	lw	a5,-36(s0)
     960:	e39d                	bnez	a5,986 <fork_test+0x13c>
    printf("fork_test failed\n");
    exit(1);
  }

  // check that the parent's mappings are still there.
  _v1(p1);
     962:	8526                	mv	a0,s1
     964:	ec2ff0ef          	jal	26 <_v1>
  _v1(p2);
     968:	854a                	mv	a0,s2
     96a:	ebcff0ef          	jal	26 <_v1>

  printf("test fork: OK\n");
     96e:	00001517          	auipc	a0,0x1
     972:	25a50513          	addi	a0,a0,602 # 1bc8 <malloc+0x714>
     976:	287000ef          	jal	13fc <printf>
}
     97a:	70a2                	ld	ra,40(sp)
     97c:	7402                	ld	s0,32(sp)
     97e:	64e2                	ld	s1,24(sp)
     980:	6942                	ld	s2,16(sp)
     982:	6145                	addi	sp,sp,48
     984:	8082                	ret
    printf("fork_test failed\n");
     986:	00001517          	auipc	a0,0x1
     98a:	22a50513          	addi	a0,a0,554 # 1bb0 <malloc+0x6fc>
     98e:	26f000ef          	jal	13fc <printf>
    exit(1);
     992:	4505                	li	a0,1
     994:	612000ef          	jal	fa6 <exit>

0000000000000998 <more_test>:

void
more_test()
{
     998:	7179                	addi	sp,sp,-48
     99a:	f406                	sd	ra,40(sp)
     99c:	f022                	sd	s0,32(sp)
     99e:	ec26                	sd	s1,24(sp)
     9a0:	e84a                	sd	s2,16(sp)
     9a2:	1800                	addi	s0,sp,48
  int fd, pid;
  char *p;
  const char * const f = "mmap.dur";
  
  printf("test munmap prevents access\n");
     9a4:	00001517          	auipc	a0,0x1
     9a8:	23450513          	addi	a0,a0,564 # 1bd8 <malloc+0x724>
     9ac:	251000ef          	jal	13fc <printf>
  
  makefile(f);
     9b0:	00001517          	auipc	a0,0x1
     9b4:	cc050513          	addi	a0,a0,-832 # 1670 <malloc+0x1bc>
     9b8:	edeff0ef          	jal	96 <makefile>
  if ((fd = open(f, O_RDWR)) == -1)
     9bc:	4589                	li	a1,2
     9be:	00001517          	auipc	a0,0x1
     9c2:	cb250513          	addi	a0,a0,-846 # 1670 <malloc+0x1bc>
     9c6:	620000ef          	jal	fe6 <open>
     9ca:	57fd                	li	a5,-1
     9cc:	06f50e63          	beq	a0,a5,a48 <more_test+0xb0>
     9d0:	892a                	mv	s2,a0
    err("open");
  p = mmap(0, PGSIZE*2, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     9d2:	4781                	li	a5,0
     9d4:	872a                	mv	a4,a0
     9d6:	4685                	li	a3,1
     9d8:	460d                	li	a2,3
     9da:	6589                	lui	a1,0x2
     9dc:	4501                	li	a0,0
     9de:	668000ef          	jal	1046 <mmap>
     9e2:	84aa                	mv	s1,a0
  if (p == MAP_FAILED)
     9e4:	57fd                	li	a5,-1
     9e6:	06f50763          	beq	a0,a5,a54 <more_test+0xbc>
    err("mmap");
  close(fd);
     9ea:	854a                	mv	a0,s2
     9ec:	5e2000ef          	jal	fce <close>

  *p = 'X';
     9f0:	05800793          	li	a5,88
     9f4:	00f48023          	sb	a5,0(s1)
  *(p+PGSIZE) = 'Y';
     9f8:	6785                	lui	a5,0x1
     9fa:	97a6                	add	a5,a5,s1
     9fc:	05900713          	li	a4,89
     a00:	00e78023          	sb	a4,0(a5) # 1000 <fstat+0x2>

  pid = fork();
     a04:	59a000ef          	jal	f9e <fork>
  if(pid < 0) err("fork");
     a08:	04054c63          	bltz	a0,a60 <more_test+0xc8>
  if(pid == 0){
     a0c:	e535                	bnez	a0,a78 <more_test+0xe0>
    *p = 'a';
     a0e:	06100793          	li	a5,97
     a12:	00f48023          	sb	a5,0(s1)
    *(p+PGSIZE) = 'b';
     a16:	6505                	lui	a0,0x1
     a18:	9526                	add	a0,a0,s1
     a1a:	06200793          	li	a5,98
     a1e:	00f50023          	sb	a5,0(a0) # 1000 <fstat+0x2>
    if(munmap(p+PGSIZE, PGSIZE) == -1)
     a22:	6585                	lui	a1,0x1
     a24:	62a000ef          	jal	104e <munmap>
     a28:	57fd                	li	a5,-1
     a2a:	04f50163          	beq	a0,a5,a6c <more_test+0xd4>
      err("munmap");
    // this should cause a fatal fault
    printf("*(p+PGSIZE) = %x\n", *(p+PGSIZE));
     a2e:	6785                	lui	a5,0x1
     a30:	97a6                	add	a5,a5,s1
     a32:	0007c583          	lbu	a1,0(a5) # 1000 <fstat+0x2>
     a36:	00001517          	auipc	a0,0x1
     a3a:	1c250513          	addi	a0,a0,450 # 1bf8 <malloc+0x744>
     a3e:	1bf000ef          	jal	13fc <printf>
    exit(0);
     a42:	4501                	li	a0,0
     a44:	562000ef          	jal	fa6 <exit>
    err("open");
     a48:	00001517          	auipc	a0,0x1
     a4c:	c0050513          	addi	a0,a0,-1024 # 1648 <malloc+0x194>
     a50:	db0ff0ef          	jal	0 <err>
    err("mmap");
     a54:	00001517          	auipc	a0,0x1
     a58:	f3c50513          	addi	a0,a0,-196 # 1990 <malloc+0x4dc>
     a5c:	da4ff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     a60:	00001517          	auipc	a0,0x1
     a64:	13850513          	addi	a0,a0,312 # 1b98 <malloc+0x6e4>
     a68:	d98ff0ef          	jal	0 <err>
      err("munmap");
     a6c:	00001517          	auipc	a0,0x1
     a70:	f5450513          	addi	a0,a0,-172 # 19c0 <malloc+0x50c>
     a74:	d8cff0ef          	jal	0 <err>
  }
  int st = 0;
     a78:	fc042e23          	sw	zero,-36(s0)
  wait(&st);
     a7c:	fdc40513          	addi	a0,s0,-36
     a80:	52e000ef          	jal	fae <wait>
  if(st != -1)
     a84:	fdc42703          	lw	a4,-36(s0)
     a88:	57fd                	li	a5,-1
     a8a:	04f71363          	bne	a4,a5,ad0 <more_test+0x138>
    err("child #1 read unmapped memory");

  pid = fork();
     a8e:	510000ef          	jal	f9e <fork>
  if(pid < 0) err("fork");
     a92:	04054563          	bltz	a0,adc <more_test+0x144>
  if(pid == 0){
     a96:	ed39                	bnez	a0,af4 <more_test+0x15c>
    *p = 'c';
     a98:	06300793          	li	a5,99
     a9c:	00f48023          	sb	a5,0(s1)
    *(p+PGSIZE) = 'd';
     aa0:	6785                	lui	a5,0x1
     aa2:	97a6                	add	a5,a5,s1
     aa4:	06400713          	li	a4,100
     aa8:	00e78023          	sb	a4,0(a5) # 1000 <fstat+0x2>
    if(munmap(p, PGSIZE) == -1)
     aac:	6585                	lui	a1,0x1
     aae:	8526                	mv	a0,s1
     ab0:	59e000ef          	jal	104e <munmap>
     ab4:	57fd                	li	a5,-1
     ab6:	02f50963          	beq	a0,a5,ae8 <more_test+0x150>
      err("munmap");
    // this should cause a fatal fault
    printf("*p = %x\n", *p);
     aba:	0004c583          	lbu	a1,0(s1)
     abe:	00001517          	auipc	a0,0x1
     ac2:	17250513          	addi	a0,a0,370 # 1c30 <malloc+0x77c>
     ac6:	137000ef          	jal	13fc <printf>
    exit(0);
     aca:	4501                	li	a0,0
     acc:	4da000ef          	jal	fa6 <exit>
    err("child #1 read unmapped memory");
     ad0:	00001517          	auipc	a0,0x1
     ad4:	14050513          	addi	a0,a0,320 # 1c10 <malloc+0x75c>
     ad8:	d28ff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     adc:	00001517          	auipc	a0,0x1
     ae0:	0bc50513          	addi	a0,a0,188 # 1b98 <malloc+0x6e4>
     ae4:	d1cff0ef          	jal	0 <err>
      err("munmap");
     ae8:	00001517          	auipc	a0,0x1
     aec:	ed850513          	addi	a0,a0,-296 # 19c0 <malloc+0x50c>
     af0:	d10ff0ef          	jal	0 <err>
  }
  st = 0;
     af4:	fc042e23          	sw	zero,-36(s0)
  wait(&st);
     af8:	fdc40513          	addi	a0,s0,-36
     afc:	4b2000ef          	jal	fae <wait>
  if(st != -1)
     b00:	fdc42703          	lw	a4,-36(s0)
     b04:	57fd                	li	a5,-1
     b06:	10f71363          	bne	a4,a5,c0c <more_test+0x274>
    err("child #2 read unmapped memory");

  // parent should still be able to access the memory.
  *p = 'P';
     b0a:	05000793          	li	a5,80
     b0e:	00f48023          	sb	a5,0(s1)
  *(p+PGSIZE) = 'Q';
     b12:	6785                	lui	a5,0x1
     b14:	97a6                	add	a5,a5,s1
     b16:	05100713          	li	a4,81
     b1a:	00e78023          	sb	a4,0(a5) # 1000 <fstat+0x2>

  if(munmap(p, PGSIZE) == -1)
     b1e:	6585                	lui	a1,0x1
     b20:	8526                	mv	a0,s1
     b22:	52c000ef          	jal	104e <munmap>
     b26:	57fd                	li	a5,-1
     b28:	0ef50863          	beq	a0,a5,c18 <more_test+0x280>
    err("munmap");

  *(p+PGSIZE) = 'R';
     b2c:	6785                	lui	a5,0x1
     b2e:	00f48533          	add	a0,s1,a5
     b32:	05200793          	li	a5,82
     b36:	00f50023          	sb	a5,0(a0)
  if(munmap(p+PGSIZE, PGSIZE) == -1)
     b3a:	6585                	lui	a1,0x1
     b3c:	512000ef          	jal	104e <munmap>
     b40:	57fd                	li	a5,-1
     b42:	0ef50163          	beq	a0,a5,c24 <more_test+0x28c>
    err("munmap");

  // read the file, check that the first page starts
  // with P and the second page with R.
  fd = open(f, O_RDONLY);
     b46:	4581                	li	a1,0
     b48:	00001517          	auipc	a0,0x1
     b4c:	b2850513          	addi	a0,a0,-1240 # 1670 <malloc+0x1bc>
     b50:	496000ef          	jal	fe6 <open>
     b54:	84aa                	mv	s1,a0
  if(fd < 0) err("open");
     b56:	0c054d63          	bltz	a0,c30 <more_test+0x298>
  if(read(fd, buf, PGSIZE) != PGSIZE) err("read");
     b5a:	6605                	lui	a2,0x1
     b5c:	00001597          	auipc	a1,0x1
     b60:	4b458593          	addi	a1,a1,1204 # 2010 <buf>
     b64:	45a000ef          	jal	fbe <read>
     b68:	6785                	lui	a5,0x1
     b6a:	0cf51963          	bne	a0,a5,c3c <more_test+0x2a4>
  if(buf[0] != 'P') err("first byte of file is wrong");
     b6e:	00001717          	auipc	a4,0x1
     b72:	4a274703          	lbu	a4,1186(a4) # 2010 <buf>
     b76:	05000793          	li	a5,80
     b7a:	0cf71763          	bne	a4,a5,c48 <more_test+0x2b0>
  if(read(fd, buf, PGSIZE) != PGSIZE/2) err("read");
     b7e:	6605                	lui	a2,0x1
     b80:	00001597          	auipc	a1,0x1
     b84:	49058593          	addi	a1,a1,1168 # 2010 <buf>
     b88:	8526                	mv	a0,s1
     b8a:	434000ef          	jal	fbe <read>
     b8e:	8005051b          	addiw	a0,a0,-2048
     b92:	e169                	bnez	a0,c54 <more_test+0x2bc>
  if(buf[0] != 'R') err("first byte of 2nd page of file is wrong");
     b94:	00001717          	auipc	a4,0x1
     b98:	47c74703          	lbu	a4,1148(a4) # 2010 <buf>
     b9c:	05200793          	li	a5,82
     ba0:	0cf71063          	bne	a4,a5,c60 <more_test+0x2c8>
  close(fd);
     ba4:	8526                	mv	a0,s1
     ba6:	428000ef          	jal	fce <close>

  printf("test munmap prevents access: OK\n");
     baa:	00001517          	auipc	a0,0x1
     bae:	0fe50513          	addi	a0,a0,254 # 1ca8 <malloc+0x7f4>
     bb2:	04b000ef          	jal	13fc <printf>

  printf("test writes to read-only mapped memory\n");
     bb6:	00001517          	auipc	a0,0x1
     bba:	11a50513          	addi	a0,a0,282 # 1cd0 <malloc+0x81c>
     bbe:	03f000ef          	jal	13fc <printf>

  makefile(f);
     bc2:	00001517          	auipc	a0,0x1
     bc6:	aae50513          	addi	a0,a0,-1362 # 1670 <malloc+0x1bc>
     bca:	cccff0ef          	jal	96 <makefile>

  pid = fork();
     bce:	3d0000ef          	jal	f9e <fork>
  if(pid < 0) err("fork");
     bd2:	08054d63          	bltz	a0,c6c <more_test+0x2d4>
  if(pid == 0){
     bd6:	ed4d                	bnez	a0,c90 <more_test+0x2f8>
    if ((fd = open(f, O_RDWR)) == -1)
     bd8:	4589                	li	a1,2
     bda:	00001517          	auipc	a0,0x1
     bde:	a9650513          	addi	a0,a0,-1386 # 1670 <malloc+0x1bc>
     be2:	404000ef          	jal	fe6 <open>
     be6:	872a                	mv	a4,a0
     be8:	57fd                	li	a5,-1
     bea:	08f50763          	beq	a0,a5,c78 <more_test+0x2e0>
      err("open");
    p = mmap(0, PGSIZE*2, PROT_READ, MAP_SHARED, fd, 0);
     bee:	4781                	li	a5,0
     bf0:	4685                	li	a3,1
     bf2:	8636                	mv	a2,a3
     bf4:	6589                	lui	a1,0x2
     bf6:	4501                	li	a0,0
     bf8:	44e000ef          	jal	1046 <mmap>
    if (p == MAP_FAILED)
     bfc:	57fd                	li	a5,-1
     bfe:	08f50363          	beq	a0,a5,c84 <more_test+0x2ec>
      err("mmap");
    // this should cause a fatal fault
    *p = 0;
     c02:	00050023          	sb	zero,0(a0)
    exit(*p);
     c06:	4501                	li	a0,0
     c08:	39e000ef          	jal	fa6 <exit>
    err("child #2 read unmapped memory");
     c0c:	00001517          	auipc	a0,0x1
     c10:	03450513          	addi	a0,a0,52 # 1c40 <malloc+0x78c>
     c14:	becff0ef          	jal	0 <err>
    err("munmap");
     c18:	00001517          	auipc	a0,0x1
     c1c:	da850513          	addi	a0,a0,-600 # 19c0 <malloc+0x50c>
     c20:	be0ff0ef          	jal	0 <err>
    err("munmap");
     c24:	00001517          	auipc	a0,0x1
     c28:	d9c50513          	addi	a0,a0,-612 # 19c0 <malloc+0x50c>
     c2c:	bd4ff0ef          	jal	0 <err>
  if(fd < 0) err("open");
     c30:	00001517          	auipc	a0,0x1
     c34:	a1850513          	addi	a0,a0,-1512 # 1648 <malloc+0x194>
     c38:	bc8ff0ef          	jal	0 <err>
  if(read(fd, buf, PGSIZE) != PGSIZE) err("read");
     c3c:	00001517          	auipc	a0,0x1
     c40:	aec50513          	addi	a0,a0,-1300 # 1728 <malloc+0x274>
     c44:	bbcff0ef          	jal	0 <err>
  if(buf[0] != 'P') err("first byte of file is wrong");
     c48:	00001517          	auipc	a0,0x1
     c4c:	01850513          	addi	a0,a0,24 # 1c60 <malloc+0x7ac>
     c50:	bb0ff0ef          	jal	0 <err>
  if(read(fd, buf, PGSIZE) != PGSIZE/2) err("read");
     c54:	00001517          	auipc	a0,0x1
     c58:	ad450513          	addi	a0,a0,-1324 # 1728 <malloc+0x274>
     c5c:	ba4ff0ef          	jal	0 <err>
  if(buf[0] != 'R') err("first byte of 2nd page of file is wrong");
     c60:	00001517          	auipc	a0,0x1
     c64:	02050513          	addi	a0,a0,32 # 1c80 <malloc+0x7cc>
     c68:	b98ff0ef          	jal	0 <err>
  if(pid < 0) err("fork");
     c6c:	00001517          	auipc	a0,0x1
     c70:	f2c50513          	addi	a0,a0,-212 # 1b98 <malloc+0x6e4>
     c74:	b8cff0ef          	jal	0 <err>
      err("open");
     c78:	00001517          	auipc	a0,0x1
     c7c:	9d050513          	addi	a0,a0,-1584 # 1648 <malloc+0x194>
     c80:	b80ff0ef          	jal	0 <err>
      err("mmap");
     c84:	00001517          	auipc	a0,0x1
     c88:	d0c50513          	addi	a0,a0,-756 # 1990 <malloc+0x4dc>
     c8c:	b74ff0ef          	jal	0 <err>
  }

  st = 0;
     c90:	fc042e23          	sw	zero,-36(s0)
  wait(&st);
     c94:	fdc40513          	addi	a0,s0,-36
     c98:	316000ef          	jal	fae <wait>
  if(st != -1)
     c9c:	fdc42703          	lw	a4,-36(s0)
     ca0:	57fd                	li	a5,-1
     ca2:	00f71e63          	bne	a4,a5,cbe <more_test+0x326>
    err("child wrote read-only mapping");

  printf("test writes to read-only mapped memory: OK\n");
     ca6:	00001517          	auipc	a0,0x1
     caa:	07250513          	addi	a0,a0,114 # 1d18 <malloc+0x864>
     cae:	74e000ef          	jal	13fc <printf>
}
     cb2:	70a2                	ld	ra,40(sp)
     cb4:	7402                	ld	s0,32(sp)
     cb6:	64e2                	ld	s1,24(sp)
     cb8:	6942                	ld	s2,16(sp)
     cba:	6145                	addi	sp,sp,48
     cbc:	8082                	ret
    err("child wrote read-only mapping");
     cbe:	00001517          	auipc	a0,0x1
     cc2:	03a50513          	addi	a0,a0,58 # 1cf8 <malloc+0x844>
     cc6:	b3aff0ef          	jal	0 <err>

0000000000000cca <main>:
{
     cca:	1141                	addi	sp,sp,-16
     ccc:	e406                	sd	ra,8(sp)
     cce:	e022                	sd	s0,0(sp)
     cd0:	0800                	addi	s0,sp,16
  mmap_test();
     cd2:	c60ff0ef          	jal	132 <mmap_test>
  fork_test();
     cd6:	b75ff0ef          	jal	84a <fork_test>
  more_test();
     cda:	cbfff0ef          	jal	998 <more_test>
  printf("mmaptest: all tests succeeded\n");
     cde:	00001517          	auipc	a0,0x1
     ce2:	06a50513          	addi	a0,a0,106 # 1d48 <malloc+0x894>
     ce6:	716000ef          	jal	13fc <printf>
  exit(0);
     cea:	4501                	li	a0,0
     cec:	2ba000ef          	jal	fa6 <exit>

0000000000000cf0 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
     cf0:	1141                	addi	sp,sp,-16
     cf2:	e406                	sd	ra,8(sp)
     cf4:	e022                	sd	s0,0(sp)
     cf6:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
     cf8:	fd3ff0ef          	jal	cca <main>
  exit(r);
     cfc:	2aa000ef          	jal	fa6 <exit>

0000000000000d00 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     d00:	1141                	addi	sp,sp,-16
     d02:	e406                	sd	ra,8(sp)
     d04:	e022                	sd	s0,0(sp)
     d06:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     d08:	87aa                	mv	a5,a0
     d0a:	0585                	addi	a1,a1,1 # 2001 <freep+0x1>
     d0c:	0785                	addi	a5,a5,1 # 1001 <fstat+0x3>
     d0e:	fff5c703          	lbu	a4,-1(a1)
     d12:	fee78fa3          	sb	a4,-1(a5)
     d16:	fb75                	bnez	a4,d0a <strcpy+0xa>
    ;
  return os;
}
     d18:	60a2                	ld	ra,8(sp)
     d1a:	6402                	ld	s0,0(sp)
     d1c:	0141                	addi	sp,sp,16
     d1e:	8082                	ret

0000000000000d20 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     d20:	1141                	addi	sp,sp,-16
     d22:	e406                	sd	ra,8(sp)
     d24:	e022                	sd	s0,0(sp)
     d26:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     d28:	00054783          	lbu	a5,0(a0)
     d2c:	cb91                	beqz	a5,d40 <strcmp+0x20>
     d2e:	0005c703          	lbu	a4,0(a1)
     d32:	00f71763          	bne	a4,a5,d40 <strcmp+0x20>
    p++, q++;
     d36:	0505                	addi	a0,a0,1
     d38:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     d3a:	00054783          	lbu	a5,0(a0)
     d3e:	fbe5                	bnez	a5,d2e <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
     d40:	0005c503          	lbu	a0,0(a1)
}
     d44:	40a7853b          	subw	a0,a5,a0
     d48:	60a2                	ld	ra,8(sp)
     d4a:	6402                	ld	s0,0(sp)
     d4c:	0141                	addi	sp,sp,16
     d4e:	8082                	ret

0000000000000d50 <strlen>:

uint
strlen(const char *s)
{
     d50:	1141                	addi	sp,sp,-16
     d52:	e406                	sd	ra,8(sp)
     d54:	e022                	sd	s0,0(sp)
     d56:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     d58:	00054783          	lbu	a5,0(a0)
     d5c:	cf91                	beqz	a5,d78 <strlen+0x28>
     d5e:	00150793          	addi	a5,a0,1
     d62:	86be                	mv	a3,a5
     d64:	0785                	addi	a5,a5,1
     d66:	fff7c703          	lbu	a4,-1(a5)
     d6a:	ff65                	bnez	a4,d62 <strlen+0x12>
     d6c:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
     d70:	60a2                	ld	ra,8(sp)
     d72:	6402                	ld	s0,0(sp)
     d74:	0141                	addi	sp,sp,16
     d76:	8082                	ret
  for(n = 0; s[n]; n++)
     d78:	4501                	li	a0,0
     d7a:	bfdd                	j	d70 <strlen+0x20>

0000000000000d7c <memset>:

void*
memset(void *dst, int c, uint n)
{
     d7c:	1141                	addi	sp,sp,-16
     d7e:	e406                	sd	ra,8(sp)
     d80:	e022                	sd	s0,0(sp)
     d82:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     d84:	ca19                	beqz	a2,d9a <memset+0x1e>
     d86:	87aa                	mv	a5,a0
     d88:	1602                	slli	a2,a2,0x20
     d8a:	9201                	srli	a2,a2,0x20
     d8c:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
     d90:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     d94:	0785                	addi	a5,a5,1
     d96:	fee79de3          	bne	a5,a4,d90 <memset+0x14>
  }
  return dst;
}
     d9a:	60a2                	ld	ra,8(sp)
     d9c:	6402                	ld	s0,0(sp)
     d9e:	0141                	addi	sp,sp,16
     da0:	8082                	ret

0000000000000da2 <strchr>:

char*
strchr(const char *s, char c)
{
     da2:	1141                	addi	sp,sp,-16
     da4:	e406                	sd	ra,8(sp)
     da6:	e022                	sd	s0,0(sp)
     da8:	0800                	addi	s0,sp,16
  for(; *s; s++)
     daa:	00054783          	lbu	a5,0(a0)
     dae:	cf81                	beqz	a5,dc6 <strchr+0x24>
    if(*s == c)
     db0:	00f58763          	beq	a1,a5,dbe <strchr+0x1c>
  for(; *s; s++)
     db4:	0505                	addi	a0,a0,1
     db6:	00054783          	lbu	a5,0(a0)
     dba:	fbfd                	bnez	a5,db0 <strchr+0xe>
      return (char*)s;
  return 0;
     dbc:	4501                	li	a0,0
}
     dbe:	60a2                	ld	ra,8(sp)
     dc0:	6402                	ld	s0,0(sp)
     dc2:	0141                	addi	sp,sp,16
     dc4:	8082                	ret
  return 0;
     dc6:	4501                	li	a0,0
     dc8:	bfdd                	j	dbe <strchr+0x1c>

0000000000000dca <gets>:

char*
gets(char *buf, int max)
{
     dca:	711d                	addi	sp,sp,-96
     dcc:	ec86                	sd	ra,88(sp)
     dce:	e8a2                	sd	s0,80(sp)
     dd0:	e4a6                	sd	s1,72(sp)
     dd2:	e0ca                	sd	s2,64(sp)
     dd4:	fc4e                	sd	s3,56(sp)
     dd6:	f852                	sd	s4,48(sp)
     dd8:	f456                	sd	s5,40(sp)
     dda:	f05a                	sd	s6,32(sp)
     ddc:	ec5e                	sd	s7,24(sp)
     dde:	e862                	sd	s8,16(sp)
     de0:	1080                	addi	s0,sp,96
     de2:	8baa                	mv	s7,a0
     de4:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     de6:	892a                	mv	s2,a0
     de8:	4481                	li	s1,0
    cc = read(0, &c, 1);
     dea:	faf40b13          	addi	s6,s0,-81
     dee:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
     df0:	8c26                	mv	s8,s1
     df2:	0014899b          	addiw	s3,s1,1
     df6:	84ce                	mv	s1,s3
     df8:	0349d463          	bge	s3,s4,e20 <gets+0x56>
    cc = read(0, &c, 1);
     dfc:	8656                	mv	a2,s5
     dfe:	85da                	mv	a1,s6
     e00:	4501                	li	a0,0
     e02:	1bc000ef          	jal	fbe <read>
    if(cc < 1)
     e06:	00a05d63          	blez	a0,e20 <gets+0x56>
      break;
    buf[i++] = c;
     e0a:	faf44783          	lbu	a5,-81(s0)
     e0e:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     e12:	0905                	addi	s2,s2,1
     e14:	ff678713          	addi	a4,a5,-10
     e18:	c319                	beqz	a4,e1e <gets+0x54>
     e1a:	17cd                	addi	a5,a5,-13
     e1c:	fbf1                	bnez	a5,df0 <gets+0x26>
    buf[i++] = c;
     e1e:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
     e20:	9c5e                	add	s8,s8,s7
     e22:	000c0023          	sb	zero,0(s8)
  return buf;
}
     e26:	855e                	mv	a0,s7
     e28:	60e6                	ld	ra,88(sp)
     e2a:	6446                	ld	s0,80(sp)
     e2c:	64a6                	ld	s1,72(sp)
     e2e:	6906                	ld	s2,64(sp)
     e30:	79e2                	ld	s3,56(sp)
     e32:	7a42                	ld	s4,48(sp)
     e34:	7aa2                	ld	s5,40(sp)
     e36:	7b02                	ld	s6,32(sp)
     e38:	6be2                	ld	s7,24(sp)
     e3a:	6c42                	ld	s8,16(sp)
     e3c:	6125                	addi	sp,sp,96
     e3e:	8082                	ret

0000000000000e40 <stat>:

int
stat(const char *n, struct stat *st)
{
     e40:	1101                	addi	sp,sp,-32
     e42:	ec06                	sd	ra,24(sp)
     e44:	e822                	sd	s0,16(sp)
     e46:	e04a                	sd	s2,0(sp)
     e48:	1000                	addi	s0,sp,32
     e4a:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     e4c:	4581                	li	a1,0
     e4e:	198000ef          	jal	fe6 <open>
  if(fd < 0)
     e52:	02054263          	bltz	a0,e76 <stat+0x36>
     e56:	e426                	sd	s1,8(sp)
     e58:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     e5a:	85ca                	mv	a1,s2
     e5c:	1a2000ef          	jal	ffe <fstat>
     e60:	892a                	mv	s2,a0
  close(fd);
     e62:	8526                	mv	a0,s1
     e64:	16a000ef          	jal	fce <close>
  return r;
     e68:	64a2                	ld	s1,8(sp)
}
     e6a:	854a                	mv	a0,s2
     e6c:	60e2                	ld	ra,24(sp)
     e6e:	6442                	ld	s0,16(sp)
     e70:	6902                	ld	s2,0(sp)
     e72:	6105                	addi	sp,sp,32
     e74:	8082                	ret
    return -1;
     e76:	57fd                	li	a5,-1
     e78:	893e                	mv	s2,a5
     e7a:	bfc5                	j	e6a <stat+0x2a>

0000000000000e7c <atoi>:

int
atoi(const char *s)
{
     e7c:	1141                	addi	sp,sp,-16
     e7e:	e406                	sd	ra,8(sp)
     e80:	e022                	sd	s0,0(sp)
     e82:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     e84:	00054683          	lbu	a3,0(a0)
     e88:	fd06879b          	addiw	a5,a3,-48 # 1fd0 <digits+0x260>
     e8c:	0ff7f793          	zext.b	a5,a5
     e90:	4625                	li	a2,9
     e92:	02f66963          	bltu	a2,a5,ec4 <atoi+0x48>
     e96:	872a                	mv	a4,a0
  n = 0;
     e98:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
     e9a:	0705                	addi	a4,a4,1
     e9c:	0025179b          	slliw	a5,a0,0x2
     ea0:	9fa9                	addw	a5,a5,a0
     ea2:	0017979b          	slliw	a5,a5,0x1
     ea6:	9fb5                	addw	a5,a5,a3
     ea8:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     eac:	00074683          	lbu	a3,0(a4)
     eb0:	fd06879b          	addiw	a5,a3,-48
     eb4:	0ff7f793          	zext.b	a5,a5
     eb8:	fef671e3          	bgeu	a2,a5,e9a <atoi+0x1e>
  return n;
}
     ebc:	60a2                	ld	ra,8(sp)
     ebe:	6402                	ld	s0,0(sp)
     ec0:	0141                	addi	sp,sp,16
     ec2:	8082                	ret
  n = 0;
     ec4:	4501                	li	a0,0
     ec6:	bfdd                	j	ebc <atoi+0x40>

0000000000000ec8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     ec8:	1141                	addi	sp,sp,-16
     eca:	e406                	sd	ra,8(sp)
     ecc:	e022                	sd	s0,0(sp)
     ece:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     ed0:	02b57563          	bgeu	a0,a1,efa <memmove+0x32>
    while(n-- > 0)
     ed4:	00c05f63          	blez	a2,ef2 <memmove+0x2a>
     ed8:	1602                	slli	a2,a2,0x20
     eda:	9201                	srli	a2,a2,0x20
     edc:	00c507b3          	add	a5,a0,a2
  dst = vdst;
     ee0:	872a                	mv	a4,a0
      *dst++ = *src++;
     ee2:	0585                	addi	a1,a1,1
     ee4:	0705                	addi	a4,a4,1
     ee6:	fff5c683          	lbu	a3,-1(a1)
     eea:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     eee:	fee79ae3          	bne	a5,a4,ee2 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     ef2:	60a2                	ld	ra,8(sp)
     ef4:	6402                	ld	s0,0(sp)
     ef6:	0141                	addi	sp,sp,16
     ef8:	8082                	ret
    while(n-- > 0)
     efa:	fec05ce3          	blez	a2,ef2 <memmove+0x2a>
    dst += n;
     efe:	00c50733          	add	a4,a0,a2
    src += n;
     f02:	95b2                	add	a1,a1,a2
     f04:	fff6079b          	addiw	a5,a2,-1 # fff <fstat+0x1>
     f08:	1782                	slli	a5,a5,0x20
     f0a:	9381                	srli	a5,a5,0x20
     f0c:	fff7c793          	not	a5,a5
     f10:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     f12:	15fd                	addi	a1,a1,-1
     f14:	177d                	addi	a4,a4,-1
     f16:	0005c683          	lbu	a3,0(a1)
     f1a:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     f1e:	fef71ae3          	bne	a4,a5,f12 <memmove+0x4a>
     f22:	bfc1                	j	ef2 <memmove+0x2a>

0000000000000f24 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     f24:	1141                	addi	sp,sp,-16
     f26:	e406                	sd	ra,8(sp)
     f28:	e022                	sd	s0,0(sp)
     f2a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     f2c:	c61d                	beqz	a2,f5a <memcmp+0x36>
     f2e:	1602                	slli	a2,a2,0x20
     f30:	9201                	srli	a2,a2,0x20
     f32:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
     f36:	00054783          	lbu	a5,0(a0)
     f3a:	0005c703          	lbu	a4,0(a1)
     f3e:	00e79863          	bne	a5,a4,f4e <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
     f42:	0505                	addi	a0,a0,1
    p2++;
     f44:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     f46:	fed518e3          	bne	a0,a3,f36 <memcmp+0x12>
  }
  return 0;
     f4a:	4501                	li	a0,0
     f4c:	a019                	j	f52 <memcmp+0x2e>
      return *p1 - *p2;
     f4e:	40e7853b          	subw	a0,a5,a4
}
     f52:	60a2                	ld	ra,8(sp)
     f54:	6402                	ld	s0,0(sp)
     f56:	0141                	addi	sp,sp,16
     f58:	8082                	ret
  return 0;
     f5a:	4501                	li	a0,0
     f5c:	bfdd                	j	f52 <memcmp+0x2e>

0000000000000f5e <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     f5e:	1141                	addi	sp,sp,-16
     f60:	e406                	sd	ra,8(sp)
     f62:	e022                	sd	s0,0(sp)
     f64:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     f66:	f63ff0ef          	jal	ec8 <memmove>
}
     f6a:	60a2                	ld	ra,8(sp)
     f6c:	6402                	ld	s0,0(sp)
     f6e:	0141                	addi	sp,sp,16
     f70:	8082                	ret

0000000000000f72 <sbrk>:

char *
sbrk(int n) {
     f72:	1141                	addi	sp,sp,-16
     f74:	e406                	sd	ra,8(sp)
     f76:	e022                	sd	s0,0(sp)
     f78:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
     f7a:	4585                	li	a1,1
     f7c:	0b2000ef          	jal	102e <sys_sbrk>
}
     f80:	60a2                	ld	ra,8(sp)
     f82:	6402                	ld	s0,0(sp)
     f84:	0141                	addi	sp,sp,16
     f86:	8082                	ret

0000000000000f88 <sbrklazy>:

char *
sbrklazy(int n) {
     f88:	1141                	addi	sp,sp,-16
     f8a:	e406                	sd	ra,8(sp)
     f8c:	e022                	sd	s0,0(sp)
     f8e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
     f90:	4589                	li	a1,2
     f92:	09c000ef          	jal	102e <sys_sbrk>
}
     f96:	60a2                	ld	ra,8(sp)
     f98:	6402                	ld	s0,0(sp)
     f9a:	0141                	addi	sp,sp,16
     f9c:	8082                	ret

0000000000000f9e <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     f9e:	4885                	li	a7,1
 ecall
     fa0:	00000073          	ecall
 ret
     fa4:	8082                	ret

0000000000000fa6 <exit>:
.global exit
exit:
 li a7, SYS_exit
     fa6:	4889                	li	a7,2
 ecall
     fa8:	00000073          	ecall
 ret
     fac:	8082                	ret

0000000000000fae <wait>:
.global wait
wait:
 li a7, SYS_wait
     fae:	488d                	li	a7,3
 ecall
     fb0:	00000073          	ecall
 ret
     fb4:	8082                	ret

0000000000000fb6 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     fb6:	4891                	li	a7,4
 ecall
     fb8:	00000073          	ecall
 ret
     fbc:	8082                	ret

0000000000000fbe <read>:
.global read
read:
 li a7, SYS_read
     fbe:	4895                	li	a7,5
 ecall
     fc0:	00000073          	ecall
 ret
     fc4:	8082                	ret

0000000000000fc6 <write>:
.global write
write:
 li a7, SYS_write
     fc6:	48c1                	li	a7,16
 ecall
     fc8:	00000073          	ecall
 ret
     fcc:	8082                	ret

0000000000000fce <close>:
.global close
close:
 li a7, SYS_close
     fce:	48d5                	li	a7,21
 ecall
     fd0:	00000073          	ecall
 ret
     fd4:	8082                	ret

0000000000000fd6 <kill>:
.global kill
kill:
 li a7, SYS_kill
     fd6:	4899                	li	a7,6
 ecall
     fd8:	00000073          	ecall
 ret
     fdc:	8082                	ret

0000000000000fde <exec>:
.global exec
exec:
 li a7, SYS_exec
     fde:	489d                	li	a7,7
 ecall
     fe0:	00000073          	ecall
 ret
     fe4:	8082                	ret

0000000000000fe6 <open>:
.global open
open:
 li a7, SYS_open
     fe6:	48bd                	li	a7,15
 ecall
     fe8:	00000073          	ecall
 ret
     fec:	8082                	ret

0000000000000fee <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     fee:	48c5                	li	a7,17
 ecall
     ff0:	00000073          	ecall
 ret
     ff4:	8082                	ret

0000000000000ff6 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     ff6:	48c9                	li	a7,18
 ecall
     ff8:	00000073          	ecall
 ret
     ffc:	8082                	ret

0000000000000ffe <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     ffe:	48a1                	li	a7,8
 ecall
    1000:	00000073          	ecall
 ret
    1004:	8082                	ret

0000000000001006 <link>:
.global link
link:
 li a7, SYS_link
    1006:	48cd                	li	a7,19
 ecall
    1008:	00000073          	ecall
 ret
    100c:	8082                	ret

000000000000100e <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    100e:	48d1                	li	a7,20
 ecall
    1010:	00000073          	ecall
 ret
    1014:	8082                	ret

0000000000001016 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    1016:	48a5                	li	a7,9
 ecall
    1018:	00000073          	ecall
 ret
    101c:	8082                	ret

000000000000101e <dup>:
.global dup
dup:
 li a7, SYS_dup
    101e:	48a9                	li	a7,10
 ecall
    1020:	00000073          	ecall
 ret
    1024:	8082                	ret

0000000000001026 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    1026:	48ad                	li	a7,11
 ecall
    1028:	00000073          	ecall
 ret
    102c:	8082                	ret

000000000000102e <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    102e:	48b1                	li	a7,12
 ecall
    1030:	00000073          	ecall
 ret
    1034:	8082                	ret

0000000000001036 <pause>:
.global pause
pause:
 li a7, SYS_pause
    1036:	48b5                	li	a7,13
 ecall
    1038:	00000073          	ecall
 ret
    103c:	8082                	ret

000000000000103e <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    103e:	48b9                	li	a7,14
 ecall
    1040:	00000073          	ecall
 ret
    1044:	8082                	ret

0000000000001046 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
    1046:	48d9                	li	a7,22
 ecall
    1048:	00000073          	ecall
 ret
    104c:	8082                	ret

000000000000104e <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
    104e:	48dd                	li	a7,23
 ecall
    1050:	00000073          	ecall
 ret
    1054:	8082                	ret

0000000000001056 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1056:	1101                	addi	sp,sp,-32
    1058:	ec06                	sd	ra,24(sp)
    105a:	e822                	sd	s0,16(sp)
    105c:	1000                	addi	s0,sp,32
    105e:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1062:	4605                	li	a2,1
    1064:	fef40593          	addi	a1,s0,-17
    1068:	f5fff0ef          	jal	fc6 <write>
}
    106c:	60e2                	ld	ra,24(sp)
    106e:	6442                	ld	s0,16(sp)
    1070:	6105                	addi	sp,sp,32
    1072:	8082                	ret

0000000000001074 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    1074:	715d                	addi	sp,sp,-80
    1076:	e486                	sd	ra,72(sp)
    1078:	e0a2                	sd	s0,64(sp)
    107a:	f84a                	sd	s2,48(sp)
    107c:	f44e                	sd	s3,40(sp)
    107e:	0880                	addi	s0,sp,80
    1080:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    1082:	c6d1                	beqz	a3,110e <printint+0x9a>
    1084:	0805d563          	bgez	a1,110e <printint+0x9a>
    neg = 1;
    x = -xx;
    1088:	40b005b3          	neg	a1,a1
    neg = 1;
    108c:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    108e:	fb840993          	addi	s3,s0,-72
  neg = 0;
    1092:	86ce                	mv	a3,s3
  i = 0;
    1094:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1096:	00001817          	auipc	a6,0x1
    109a:	cda80813          	addi	a6,a6,-806 # 1d70 <digits>
    109e:	88ba                	mv	a7,a4
    10a0:	0017051b          	addiw	a0,a4,1
    10a4:	872a                	mv	a4,a0
    10a6:	02c5f7b3          	remu	a5,a1,a2
    10aa:	97c2                	add	a5,a5,a6
    10ac:	0007c783          	lbu	a5,0(a5)
    10b0:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    10b4:	87ae                	mv	a5,a1
    10b6:	02c5d5b3          	divu	a1,a1,a2
    10ba:	0685                	addi	a3,a3,1
    10bc:	fec7f1e3          	bgeu	a5,a2,109e <printint+0x2a>
  if(neg)
    10c0:	00030c63          	beqz	t1,10d8 <printint+0x64>
    buf[i++] = '-';
    10c4:	fd050793          	addi	a5,a0,-48
    10c8:	00878533          	add	a0,a5,s0
    10cc:	02d00793          	li	a5,45
    10d0:	fef50423          	sb	a5,-24(a0)
    10d4:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    10d8:	02e05563          	blez	a4,1102 <printint+0x8e>
    10dc:	fc26                	sd	s1,56(sp)
    10de:	377d                	addiw	a4,a4,-1
    10e0:	00e984b3          	add	s1,s3,a4
    10e4:	19fd                	addi	s3,s3,-1
    10e6:	99ba                	add	s3,s3,a4
    10e8:	1702                	slli	a4,a4,0x20
    10ea:	9301                	srli	a4,a4,0x20
    10ec:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    10f0:	0004c583          	lbu	a1,0(s1)
    10f4:	854a                	mv	a0,s2
    10f6:	f61ff0ef          	jal	1056 <putc>
  while(--i >= 0)
    10fa:	14fd                	addi	s1,s1,-1
    10fc:	ff349ae3          	bne	s1,s3,10f0 <printint+0x7c>
    1100:	74e2                	ld	s1,56(sp)
}
    1102:	60a6                	ld	ra,72(sp)
    1104:	6406                	ld	s0,64(sp)
    1106:	7942                	ld	s2,48(sp)
    1108:	79a2                	ld	s3,40(sp)
    110a:	6161                	addi	sp,sp,80
    110c:	8082                	ret
  neg = 0;
    110e:	4301                	li	t1,0
    1110:	bfbd                	j	108e <printint+0x1a>

0000000000001112 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1112:	711d                	addi	sp,sp,-96
    1114:	ec86                	sd	ra,88(sp)
    1116:	e8a2                	sd	s0,80(sp)
    1118:	e4a6                	sd	s1,72(sp)
    111a:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    111c:	0005c483          	lbu	s1,0(a1)
    1120:	22048363          	beqz	s1,1346 <vprintf+0x234>
    1124:	e0ca                	sd	s2,64(sp)
    1126:	fc4e                	sd	s3,56(sp)
    1128:	f852                	sd	s4,48(sp)
    112a:	f456                	sd	s5,40(sp)
    112c:	f05a                	sd	s6,32(sp)
    112e:	ec5e                	sd	s7,24(sp)
    1130:	e862                	sd	s8,16(sp)
    1132:	8b2a                	mv	s6,a0
    1134:	8a2e                	mv	s4,a1
    1136:	8bb2                	mv	s7,a2
  state = 0;
    1138:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    113a:	4901                	li	s2,0
    113c:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    113e:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1142:	06400c13          	li	s8,100
    1146:	a00d                	j	1168 <vprintf+0x56>
        putc(fd, c0);
    1148:	85a6                	mv	a1,s1
    114a:	855a                	mv	a0,s6
    114c:	f0bff0ef          	jal	1056 <putc>
    1150:	a019                	j	1156 <vprintf+0x44>
    } else if(state == '%'){
    1152:	03598363          	beq	s3,s5,1178 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
    1156:	0019079b          	addiw	a5,s2,1
    115a:	893e                	mv	s2,a5
    115c:	873e                	mv	a4,a5
    115e:	97d2                	add	a5,a5,s4
    1160:	0007c483          	lbu	s1,0(a5)
    1164:	1c048a63          	beqz	s1,1338 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    1168:	0004879b          	sext.w	a5,s1
    if(state == 0){
    116c:	fe0993e3          	bnez	s3,1152 <vprintf+0x40>
      if(c0 == '%'){
    1170:	fd579ce3          	bne	a5,s5,1148 <vprintf+0x36>
        state = '%';
    1174:	89be                	mv	s3,a5
    1176:	b7c5                	j	1156 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
    1178:	00ea06b3          	add	a3,s4,a4
    117c:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
    1180:	1c060863          	beqz	a2,1350 <vprintf+0x23e>
      if(c0 == 'd'){
    1184:	03878763          	beq	a5,s8,11b2 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1188:	f9478693          	addi	a3,a5,-108
    118c:	0016b693          	seqz	a3,a3
    1190:	f9c60593          	addi	a1,a2,-100
    1194:	e99d                	bnez	a1,11ca <vprintf+0xb8>
    1196:	ca95                	beqz	a3,11ca <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1198:	008b8493          	addi	s1,s7,8
    119c:	4685                	li	a3,1
    119e:	4629                	li	a2,10
    11a0:	000bb583          	ld	a1,0(s7)
    11a4:	855a                	mv	a0,s6
    11a6:	ecfff0ef          	jal	1074 <printint>
        i += 1;
    11aa:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    11ac:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    11ae:	4981                	li	s3,0
    11b0:	b75d                	j	1156 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    11b2:	008b8493          	addi	s1,s7,8
    11b6:	4685                	li	a3,1
    11b8:	4629                	li	a2,10
    11ba:	000ba583          	lw	a1,0(s7)
    11be:	855a                	mv	a0,s6
    11c0:	eb5ff0ef          	jal	1074 <printint>
    11c4:	8ba6                	mv	s7,s1
      state = 0;
    11c6:	4981                	li	s3,0
    11c8:	b779                	j	1156 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
    11ca:	9752                	add	a4,a4,s4
    11cc:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    11d0:	f9460713          	addi	a4,a2,-108
    11d4:	00173713          	seqz	a4,a4
    11d8:	8f75                	and	a4,a4,a3
    11da:	f9c58513          	addi	a0,a1,-100
    11de:	18051363          	bnez	a0,1364 <vprintf+0x252>
    11e2:	18070163          	beqz	a4,1364 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    11e6:	008b8493          	addi	s1,s7,8
    11ea:	4685                	li	a3,1
    11ec:	4629                	li	a2,10
    11ee:	000bb583          	ld	a1,0(s7)
    11f2:	855a                	mv	a0,s6
    11f4:	e81ff0ef          	jal	1074 <printint>
        i += 2;
    11f8:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    11fa:	8ba6                	mv	s7,s1
      state = 0;
    11fc:	4981                	li	s3,0
        i += 2;
    11fe:	bfa1                	j	1156 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    1200:	008b8493          	addi	s1,s7,8
    1204:	4681                	li	a3,0
    1206:	4629                	li	a2,10
    1208:	000be583          	lwu	a1,0(s7)
    120c:	855a                	mv	a0,s6
    120e:	e67ff0ef          	jal	1074 <printint>
    1212:	8ba6                	mv	s7,s1
      state = 0;
    1214:	4981                	li	s3,0
    1216:	b781                	j	1156 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1218:	008b8493          	addi	s1,s7,8
    121c:	4681                	li	a3,0
    121e:	4629                	li	a2,10
    1220:	000bb583          	ld	a1,0(s7)
    1224:	855a                	mv	a0,s6
    1226:	e4fff0ef          	jal	1074 <printint>
        i += 1;
    122a:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    122c:	8ba6                	mv	s7,s1
      state = 0;
    122e:	4981                	li	s3,0
    1230:	b71d                	j	1156 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1232:	008b8493          	addi	s1,s7,8
    1236:	4681                	li	a3,0
    1238:	4629                	li	a2,10
    123a:	000bb583          	ld	a1,0(s7)
    123e:	855a                	mv	a0,s6
    1240:	e35ff0ef          	jal	1074 <printint>
        i += 2;
    1244:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1246:	8ba6                	mv	s7,s1
      state = 0;
    1248:	4981                	li	s3,0
        i += 2;
    124a:	b731                	j	1156 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    124c:	008b8493          	addi	s1,s7,8
    1250:	4681                	li	a3,0
    1252:	4641                	li	a2,16
    1254:	000be583          	lwu	a1,0(s7)
    1258:	855a                	mv	a0,s6
    125a:	e1bff0ef          	jal	1074 <printint>
    125e:	8ba6                	mv	s7,s1
      state = 0;
    1260:	4981                	li	s3,0
    1262:	bdd5                	j	1156 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1264:	008b8493          	addi	s1,s7,8
    1268:	4681                	li	a3,0
    126a:	4641                	li	a2,16
    126c:	000bb583          	ld	a1,0(s7)
    1270:	855a                	mv	a0,s6
    1272:	e03ff0ef          	jal	1074 <printint>
        i += 1;
    1276:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1278:	8ba6                	mv	s7,s1
      state = 0;
    127a:	4981                	li	s3,0
    127c:	bde9                	j	1156 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    127e:	008b8493          	addi	s1,s7,8
    1282:	4681                	li	a3,0
    1284:	4641                	li	a2,16
    1286:	000bb583          	ld	a1,0(s7)
    128a:	855a                	mv	a0,s6
    128c:	de9ff0ef          	jal	1074 <printint>
        i += 2;
    1290:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1292:	8ba6                	mv	s7,s1
      state = 0;
    1294:	4981                	li	s3,0
        i += 2;
    1296:	b5c1                	j	1156 <vprintf+0x44>
    1298:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    129a:	008b8793          	addi	a5,s7,8
    129e:	8cbe                	mv	s9,a5
    12a0:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    12a4:	03000593          	li	a1,48
    12a8:	855a                	mv	a0,s6
    12aa:	dadff0ef          	jal	1056 <putc>
  putc(fd, 'x');
    12ae:	07800593          	li	a1,120
    12b2:	855a                	mv	a0,s6
    12b4:	da3ff0ef          	jal	1056 <putc>
    12b8:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    12ba:	00001b97          	auipc	s7,0x1
    12be:	ab6b8b93          	addi	s7,s7,-1354 # 1d70 <digits>
    12c2:	03c9d793          	srli	a5,s3,0x3c
    12c6:	97de                	add	a5,a5,s7
    12c8:	0007c583          	lbu	a1,0(a5)
    12cc:	855a                	mv	a0,s6
    12ce:	d89ff0ef          	jal	1056 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    12d2:	0992                	slli	s3,s3,0x4
    12d4:	34fd                	addiw	s1,s1,-1
    12d6:	f4f5                	bnez	s1,12c2 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    12d8:	8be6                	mv	s7,s9
      state = 0;
    12da:	4981                	li	s3,0
    12dc:	6ca2                	ld	s9,8(sp)
    12de:	bda5                	j	1156 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    12e0:	008b8493          	addi	s1,s7,8
    12e4:	000bc583          	lbu	a1,0(s7)
    12e8:	855a                	mv	a0,s6
    12ea:	d6dff0ef          	jal	1056 <putc>
    12ee:	8ba6                	mv	s7,s1
      state = 0;
    12f0:	4981                	li	s3,0
    12f2:	b595                	j	1156 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    12f4:	008b8993          	addi	s3,s7,8
    12f8:	000bb483          	ld	s1,0(s7)
    12fc:	cc91                	beqz	s1,1318 <vprintf+0x206>
        for(; *s; s++)
    12fe:	0004c583          	lbu	a1,0(s1)
    1302:	c985                	beqz	a1,1332 <vprintf+0x220>
          putc(fd, *s);
    1304:	855a                	mv	a0,s6
    1306:	d51ff0ef          	jal	1056 <putc>
        for(; *s; s++)
    130a:	0485                	addi	s1,s1,1
    130c:	0004c583          	lbu	a1,0(s1)
    1310:	f9f5                	bnez	a1,1304 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    1312:	8bce                	mv	s7,s3
      state = 0;
    1314:	4981                	li	s3,0
    1316:	b581                	j	1156 <vprintf+0x44>
          s = "(null)";
    1318:	00001497          	auipc	s1,0x1
    131c:	a5048493          	addi	s1,s1,-1456 # 1d68 <malloc+0x8b4>
        for(; *s; s++)
    1320:	02800593          	li	a1,40
    1324:	b7c5                	j	1304 <vprintf+0x1f2>
        putc(fd, '%');
    1326:	85be                	mv	a1,a5
    1328:	855a                	mv	a0,s6
    132a:	d2dff0ef          	jal	1056 <putc>
      state = 0;
    132e:	4981                	li	s3,0
    1330:	b51d                	j	1156 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    1332:	8bce                	mv	s7,s3
      state = 0;
    1334:	4981                	li	s3,0
    1336:	b505                	j	1156 <vprintf+0x44>
    1338:	6906                	ld	s2,64(sp)
    133a:	79e2                	ld	s3,56(sp)
    133c:	7a42                	ld	s4,48(sp)
    133e:	7aa2                	ld	s5,40(sp)
    1340:	7b02                	ld	s6,32(sp)
    1342:	6be2                	ld	s7,24(sp)
    1344:	6c42                	ld	s8,16(sp)
    }
  }
}
    1346:	60e6                	ld	ra,88(sp)
    1348:	6446                	ld	s0,80(sp)
    134a:	64a6                	ld	s1,72(sp)
    134c:	6125                	addi	sp,sp,96
    134e:	8082                	ret
      if(c0 == 'd'){
    1350:	06400713          	li	a4,100
    1354:	e4e78fe3          	beq	a5,a4,11b2 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    1358:	f9478693          	addi	a3,a5,-108
    135c:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    1360:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1362:	4701                	li	a4,0
      } else if(c0 == 'u'){
    1364:	07500513          	li	a0,117
    1368:	e8a78ce3          	beq	a5,a0,1200 <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    136c:	f8b60513          	addi	a0,a2,-117
    1370:	e119                	bnez	a0,1376 <vprintf+0x264>
    1372:	ea0693e3          	bnez	a3,1218 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1376:	f8b58513          	addi	a0,a1,-117
    137a:	e119                	bnez	a0,1380 <vprintf+0x26e>
    137c:	ea071be3          	bnez	a4,1232 <vprintf+0x120>
      } else if(c0 == 'x'){
    1380:	07800513          	li	a0,120
    1384:	eca784e3          	beq	a5,a0,124c <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    1388:	f8860613          	addi	a2,a2,-120
    138c:	e219                	bnez	a2,1392 <vprintf+0x280>
    138e:	ec069be3          	bnez	a3,1264 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1392:	f8858593          	addi	a1,a1,-120
    1396:	e199                	bnez	a1,139c <vprintf+0x28a>
    1398:	ee0713e3          	bnez	a4,127e <vprintf+0x16c>
      } else if(c0 == 'p'){
    139c:	07000713          	li	a4,112
    13a0:	eee78ce3          	beq	a5,a4,1298 <vprintf+0x186>
      } else if(c0 == 'c'){
    13a4:	06300713          	li	a4,99
    13a8:	f2e78ce3          	beq	a5,a4,12e0 <vprintf+0x1ce>
      } else if(c0 == 's'){
    13ac:	07300713          	li	a4,115
    13b0:	f4e782e3          	beq	a5,a4,12f4 <vprintf+0x1e2>
      } else if(c0 == '%'){
    13b4:	02500713          	li	a4,37
    13b8:	f6e787e3          	beq	a5,a4,1326 <vprintf+0x214>
        putc(fd, '%');
    13bc:	02500593          	li	a1,37
    13c0:	855a                	mv	a0,s6
    13c2:	c95ff0ef          	jal	1056 <putc>
        putc(fd, c0);
    13c6:	85a6                	mv	a1,s1
    13c8:	855a                	mv	a0,s6
    13ca:	c8dff0ef          	jal	1056 <putc>
      state = 0;
    13ce:	4981                	li	s3,0
    13d0:	b359                	j	1156 <vprintf+0x44>

00000000000013d2 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    13d2:	715d                	addi	sp,sp,-80
    13d4:	ec06                	sd	ra,24(sp)
    13d6:	e822                	sd	s0,16(sp)
    13d8:	1000                	addi	s0,sp,32
    13da:	e010                	sd	a2,0(s0)
    13dc:	e414                	sd	a3,8(s0)
    13de:	e818                	sd	a4,16(s0)
    13e0:	ec1c                	sd	a5,24(s0)
    13e2:	03043023          	sd	a6,32(s0)
    13e6:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    13ea:	8622                	mv	a2,s0
    13ec:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    13f0:	d23ff0ef          	jal	1112 <vprintf>
}
    13f4:	60e2                	ld	ra,24(sp)
    13f6:	6442                	ld	s0,16(sp)
    13f8:	6161                	addi	sp,sp,80
    13fa:	8082                	ret

00000000000013fc <printf>:

void
printf(const char *fmt, ...)
{
    13fc:	711d                	addi	sp,sp,-96
    13fe:	ec06                	sd	ra,24(sp)
    1400:	e822                	sd	s0,16(sp)
    1402:	1000                	addi	s0,sp,32
    1404:	e40c                	sd	a1,8(s0)
    1406:	e810                	sd	a2,16(s0)
    1408:	ec14                	sd	a3,24(s0)
    140a:	f018                	sd	a4,32(s0)
    140c:	f41c                	sd	a5,40(s0)
    140e:	03043823          	sd	a6,48(s0)
    1412:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1416:	00840613          	addi	a2,s0,8
    141a:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    141e:	85aa                	mv	a1,a0
    1420:	4505                	li	a0,1
    1422:	cf1ff0ef          	jal	1112 <vprintf>
}
    1426:	60e2                	ld	ra,24(sp)
    1428:	6442                	ld	s0,16(sp)
    142a:	6125                	addi	sp,sp,96
    142c:	8082                	ret

000000000000142e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    142e:	1141                	addi	sp,sp,-16
    1430:	e406                	sd	ra,8(sp)
    1432:	e022                	sd	s0,0(sp)
    1434:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1436:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    143a:	00001797          	auipc	a5,0x1
    143e:	bc67b783          	ld	a5,-1082(a5) # 2000 <freep>
    1442:	a039                	j	1450 <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1444:	6398                	ld	a4,0(a5)
    1446:	00e7e463          	bltu	a5,a4,144e <free+0x20>
    144a:	00e6ea63          	bltu	a3,a4,145e <free+0x30>
{
    144e:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1450:	fed7fae3          	bgeu	a5,a3,1444 <free+0x16>
    1454:	6398                	ld	a4,0(a5)
    1456:	00e6e463          	bltu	a3,a4,145e <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    145a:	fee7eae3          	bltu	a5,a4,144e <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    145e:	ff852583          	lw	a1,-8(a0)
    1462:	6390                	ld	a2,0(a5)
    1464:	02059813          	slli	a6,a1,0x20
    1468:	01c85713          	srli	a4,a6,0x1c
    146c:	9736                	add	a4,a4,a3
    146e:	02e60563          	beq	a2,a4,1498 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1472:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1476:	4790                	lw	a2,8(a5)
    1478:	02061593          	slli	a1,a2,0x20
    147c:	01c5d713          	srli	a4,a1,0x1c
    1480:	973e                	add	a4,a4,a5
    1482:	02e68263          	beq	a3,a4,14a6 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1486:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1488:	00001717          	auipc	a4,0x1
    148c:	b6f73c23          	sd	a5,-1160(a4) # 2000 <freep>
}
    1490:	60a2                	ld	ra,8(sp)
    1492:	6402                	ld	s0,0(sp)
    1494:	0141                	addi	sp,sp,16
    1496:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1498:	4618                	lw	a4,8(a2)
    149a:	9f2d                	addw	a4,a4,a1
    149c:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    14a0:	6398                	ld	a4,0(a5)
    14a2:	6310                	ld	a2,0(a4)
    14a4:	b7f9                	j	1472 <free+0x44>
    p->s.size += bp->s.size;
    14a6:	ff852703          	lw	a4,-8(a0)
    14aa:	9f31                	addw	a4,a4,a2
    14ac:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    14ae:	ff053683          	ld	a3,-16(a0)
    14b2:	bfd1                	j	1486 <free+0x58>

00000000000014b4 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    14b4:	7139                	addi	sp,sp,-64
    14b6:	fc06                	sd	ra,56(sp)
    14b8:	f822                	sd	s0,48(sp)
    14ba:	f04a                	sd	s2,32(sp)
    14bc:	ec4e                	sd	s3,24(sp)
    14be:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    14c0:	02051993          	slli	s3,a0,0x20
    14c4:	0209d993          	srli	s3,s3,0x20
    14c8:	09bd                	addi	s3,s3,15
    14ca:	0049d993          	srli	s3,s3,0x4
    14ce:	2985                	addiw	s3,s3,1
    14d0:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    14d2:	00001517          	auipc	a0,0x1
    14d6:	b2e53503          	ld	a0,-1234(a0) # 2000 <freep>
    14da:	c905                	beqz	a0,150a <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    14dc:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    14de:	4798                	lw	a4,8(a5)
    14e0:	09377663          	bgeu	a4,s3,156c <malloc+0xb8>
    14e4:	f426                	sd	s1,40(sp)
    14e6:	e852                	sd	s4,16(sp)
    14e8:	e456                	sd	s5,8(sp)
    14ea:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    14ec:	8a4e                	mv	s4,s3
    14ee:	6705                	lui	a4,0x1
    14f0:	00e9f363          	bgeu	s3,a4,14f6 <malloc+0x42>
    14f4:	6a05                	lui	s4,0x1
    14f6:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    14fa:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    14fe:	00001497          	auipc	s1,0x1
    1502:	b0248493          	addi	s1,s1,-1278 # 2000 <freep>
  if(p == SBRK_ERROR)
    1506:	5afd                	li	s5,-1
    1508:	a83d                	j	1546 <malloc+0x92>
    150a:	f426                	sd	s1,40(sp)
    150c:	e852                	sd	s4,16(sp)
    150e:	e456                	sd	s5,8(sp)
    1510:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1512:	00002797          	auipc	a5,0x2
    1516:	afe78793          	addi	a5,a5,-1282 # 3010 <base>
    151a:	00001717          	auipc	a4,0x1
    151e:	aef73323          	sd	a5,-1306(a4) # 2000 <freep>
    1522:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1524:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1528:	b7d1                	j	14ec <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    152a:	6398                	ld	a4,0(a5)
    152c:	e118                	sd	a4,0(a0)
    152e:	a899                	j	1584 <malloc+0xd0>
  hp->s.size = nu;
    1530:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1534:	0541                	addi	a0,a0,16
    1536:	ef9ff0ef          	jal	142e <free>
  return freep;
    153a:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    153c:	c125                	beqz	a0,159c <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    153e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1540:	4798                	lw	a4,8(a5)
    1542:	03277163          	bgeu	a4,s2,1564 <malloc+0xb0>
    if(p == freep)
    1546:	6098                	ld	a4,0(s1)
    1548:	853e                	mv	a0,a5
    154a:	fef71ae3          	bne	a4,a5,153e <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    154e:	8552                	mv	a0,s4
    1550:	a23ff0ef          	jal	f72 <sbrk>
  if(p == SBRK_ERROR)
    1554:	fd551ee3          	bne	a0,s5,1530 <malloc+0x7c>
        return 0;
    1558:	4501                	li	a0,0
    155a:	74a2                	ld	s1,40(sp)
    155c:	6a42                	ld	s4,16(sp)
    155e:	6aa2                	ld	s5,8(sp)
    1560:	6b02                	ld	s6,0(sp)
    1562:	a03d                	j	1590 <malloc+0xdc>
    1564:	74a2                	ld	s1,40(sp)
    1566:	6a42                	ld	s4,16(sp)
    1568:	6aa2                	ld	s5,8(sp)
    156a:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    156c:	fae90fe3          	beq	s2,a4,152a <malloc+0x76>
        p->s.size -= nunits;
    1570:	4137073b          	subw	a4,a4,s3
    1574:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1576:	02071693          	slli	a3,a4,0x20
    157a:	01c6d713          	srli	a4,a3,0x1c
    157e:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1580:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1584:	00001717          	auipc	a4,0x1
    1588:	a6a73e23          	sd	a0,-1412(a4) # 2000 <freep>
      return (void*)(p + 1);
    158c:	01078513          	addi	a0,a5,16
  }
}
    1590:	70e2                	ld	ra,56(sp)
    1592:	7442                	ld	s0,48(sp)
    1594:	7902                	ld	s2,32(sp)
    1596:	69e2                	ld	s3,24(sp)
    1598:	6121                	addi	sp,sp,64
    159a:	8082                	ret
    159c:	74a2                	ld	s1,40(sp)
    159e:	6a42                	ld	s4,16(sp)
    15a0:	6aa2                	ld	s5,8(sp)
    15a2:	6b02                	ld	s6,0(sp)
    15a4:	b7f5                	j	1590 <malloc+0xdc>
