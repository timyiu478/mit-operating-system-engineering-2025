
user/_find:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <find>:


// Find all the files in a directory tree with a specific name
// argc: # of arguments of the -exec
// argv: the arguments of the -exec
void find(char *dir, char *name, int argc, char *argv[]) {
   0:	d7010113          	addi	sp,sp,-656
   4:	28113423          	sd	ra,648(sp)
   8:	28813023          	sd	s0,640(sp)
   c:	26913c23          	sd	s1,632(sp)
  10:	27213823          	sd	s2,624(sp)
  14:	27313423          	sd	s3,616(sp)
  18:	27413023          	sd	s4,608(sp)
  1c:	25513c23          	sd	s5,600(sp)
  20:	25613823          	sd	s6,592(sp)
  24:	25713423          	sd	s7,584(sp)
  28:	25813023          	sd	s8,576(sp)
  2c:	23913c23          	sd	s9,568(sp)
  30:	23a13823          	sd	s10,560(sp)
  34:	0d00                	addi	s0,sp,656
  36:	8b2a                	mv	s6,a0
  38:	8c2e                	mv	s8,a1
  3a:	8bb2                	mv	s7,a2
  3c:	8cb6                	mv	s9,a3
  char buf[512], *p;
  int fd;
  struct dirent de;
  struct stat st;

  if((fd = open(dir, O_RDONLY)) < 0){
  3e:	4581                	li	a1,0
  40:	56c000ef          	jal	5ac <open>
  44:	12054263          	bltz	a0,168 <find+0x168>
  48:	84aa                	mv	s1,a0
    fprintf(2, "find: cannot open %s\n", dir);
    return;
  }

  if(fstat(fd, &st) < 0){
  4a:	d7840593          	addi	a1,s0,-648
  4e:	576000ef          	jal	5c4 <fstat>
  52:	12054463          	bltz	a0,17a <find+0x17a>
    fprintf(2, "find: cannot stat %s\n", dir);
    close(fd);
    return;
  }

  switch(st.type){
  56:	d8041703          	lh	a4,-640(s0)
  5a:	4785                	li	a5,1
  5c:	16f71a63          	bne	a4,a5,1d0 <find+0x1d0>
    case T_DIR:
      // Read each director entry
      while(read(fd, &de, sizeof(de)) == sizeof(de)){
  60:	d9040993          	addi	s3,s0,-624
  64:	4941                	li	s2,16
        // skip empty slot or "." or ".."
        if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
  66:	d9240a13          	addi	s4,s0,-622
      while(read(fd, &de, sizeof(de)) == sizeof(de)){
  6a:	864a                	mv	a2,s2
  6c:	85ce                	mv	a1,s3
  6e:	8526                	mv	a0,s1
  70:	514000ef          	jal	584 <read>
  74:	17251663          	bne	a0,s2,1e0 <find+0x1e0>
        if (de.inum == 0 || strcmp(de.name, ".") == 0 || strcmp(de.name, "..") == 0)
  78:	d9045783          	lhu	a5,-624(s0)
  7c:	d7fd                	beqz	a5,6a <find+0x6a>
  7e:	00001597          	auipc	a1,0x1
  82:	b2a58593          	addi	a1,a1,-1238 # ba8 <malloc+0x138>
  86:	8552                	mv	a0,s4
  88:	25e000ef          	jal	2e6 <strcmp>
  8c:	dd79                	beqz	a0,6a <find+0x6a>
  8e:	00001597          	auipc	a1,0x1
  92:	b2258593          	addi	a1,a1,-1246 # bb0 <malloc+0x140>
  96:	d9240513          	addi	a0,s0,-622
  9a:	24c000ef          	jal	2e6 <strcmp>
  9e:	d571                	beqz	a0,6a <find+0x6a>
          continue;
        
        strcpy(buf, dir);
  a0:	85da                	mv	a1,s6
  a2:	da040513          	addi	a0,s0,-608
  a6:	220000ef          	jal	2c6 <strcpy>
        p = buf+strlen(buf);
  aa:	da040513          	addi	a0,s0,-608
  ae:	268000ef          	jal	316 <strlen>
  b2:	1502                	slli	a0,a0,0x20
  b4:	9101                	srli	a0,a0,0x20
  b6:	da040793          	addi	a5,s0,-608
  ba:	97aa                	add	a5,a5,a0
  bc:	8abe                	mv	s5,a5
        *p++ = '/';
  be:	02f00793          	li	a5,47
  c2:	00fa8023          	sb	a5,0(s5)
        memmove(p, de.name, DIRSIZ);
  c6:	4639                	li	a2,14
  c8:	d9240593          	addi	a1,s0,-622
  cc:	001a8513          	addi	a0,s5,1
  d0:	3be000ef          	jal	48e <memmove>
        p[DIRSIZ] = 0;
  d4:	000a87a3          	sb	zero,15(s5)

        if (stat(buf, &st) < 0) {
  d8:	d7840593          	addi	a1,s0,-648
  dc:	da040513          	addi	a0,s0,-608
  e0:	326000ef          	jal	406 <stat>
  e4:	0a054763          	bltz	a0,192 <find+0x192>
          printf("find: cannot stat %s\n", buf);
          continue;
        }

        // Call find recursively
        if (st.type == T_DIR) {
  e8:	d8041703          	lh	a4,-640(s0)
  ec:	4785                	li	a5,1
  ee:	0af70b63          	beq	a4,a5,1a4 <find+0x1a4>
          find(buf, name, argc, argv);
        } else if (strcmp(de.name, name) == 0) {
  f2:	85e2                	mv	a1,s8
  f4:	d9240513          	addi	a0,s0,-622
  f8:	1ee000ef          	jal	2e6 <strcmp>
  fc:	f53d                	bnez	a0,6a <find+0x6a>
  fe:	8d0a                	mv	s10,sp
          // no -exec arugment
          if (argc == 0) {
 100:	0a0b8a63          	beqz	s7,1b4 <find+0x1b4>
            printf("%s\n", buf);
            continue;
          }

          char *a[argc+2];
 104:	002b869b          	addiw	a3,s7,2
 108:	068e                	slli	a3,a3,0x3
 10a:	00f68793          	addi	a5,a3,15
 10e:	9bc1                	andi	a5,a5,-16
 110:	40f10133          	sub	sp,sp,a5
 114:	870a                	mv	a4,sp
 116:	858a                	mv	a1,sp
          for (int i=0; i < argc; i++){
 118:	01705c63          	blez	s7,130 <find+0x130>
 11c:	87e6                	mv	a5,s9
 11e:	16c1                	addi	a3,a3,-16
 120:	01968633          	add	a2,a3,s9
            a[i] = argv[i]; 
 124:	6394                	ld	a3,0(a5)
 126:	e314                	sd	a3,0(a4)
          for (int i=0; i < argc; i++){
 128:	07a1                	addi	a5,a5,8
 12a:	0721                	addi	a4,a4,8
 12c:	fec79ce3          	bne	a5,a2,124 <find+0x124>
          }
          a[argc] = buf;
 130:	003b9793          	slli	a5,s7,0x3
 134:	8aae                	mv	s5,a1
 136:	97ae                	add	a5,a5,a1
 138:	da040713          	addi	a4,s0,-608
 13c:	e398                	sd	a4,0(a5)
          a[argc+1] = NULL;
 13e:	0007b423          	sd	zero,8(a5)

          int pid = fork();
 142:	422000ef          	jal	564 <fork>

          if (pid == 0) {
 146:	e141                	bnez	a0,1c6 <find+0x1c6>
            // execute command
            int ret = exec(a[0], a);
 148:	85d6                	mv	a1,s5
 14a:	000ab503          	ld	a0,0(s5)
 14e:	456000ef          	jal	5a4 <exec>
            if (ret != 0) {
 152:	cd2d                	beqz	a0,1cc <find+0x1cc>
              fprintf(2, "find: failed to execute command - %s\n", argv[0]);
 154:	000cb603          	ld	a2,0(s9)
 158:	00001597          	auipc	a1,0x1
 15c:	a6858593          	addi	a1,a1,-1432 # bc0 <malloc+0x150>
 160:	4509                	li	a0,2
 162:	02d000ef          	jal	98e <fprintf>
 166:	a09d                	j	1cc <find+0x1cc>
    fprintf(2, "find: cannot open %s\n", dir);
 168:	865a                	mv	a2,s6
 16a:	00001597          	auipc	a1,0x1
 16e:	a0658593          	addi	a1,a1,-1530 # b70 <malloc+0x100>
 172:	4509                	li	a0,2
 174:	01b000ef          	jal	98e <fprintf>
    return;
 178:	a0bd                	j	1e6 <find+0x1e6>
    fprintf(2, "find: cannot stat %s\n", dir);
 17a:	865a                	mv	a2,s6
 17c:	00001597          	auipc	a1,0x1
 180:	a1458593          	addi	a1,a1,-1516 # b90 <malloc+0x120>
 184:	4509                	li	a0,2
 186:	009000ef          	jal	98e <fprintf>
    close(fd);
 18a:	8526                	mv	a0,s1
 18c:	408000ef          	jal	594 <close>
    return;
 190:	a899                	j	1e6 <find+0x1e6>
          printf("find: cannot stat %s\n", buf);
 192:	da040593          	addi	a1,s0,-608
 196:	00001517          	auipc	a0,0x1
 19a:	9fa50513          	addi	a0,a0,-1542 # b90 <malloc+0x120>
 19e:	01b000ef          	jal	9b8 <printf>
          continue;
 1a2:	b5e1                	j	6a <find+0x6a>
          find(buf, name, argc, argv);
 1a4:	86e6                	mv	a3,s9
 1a6:	865e                	mv	a2,s7
 1a8:	85e2                	mv	a1,s8
 1aa:	da040513          	addi	a0,s0,-608
 1ae:	e53ff0ef          	jal	0 <find>
 1b2:	bd65                	j	6a <find+0x6a>
            printf("%s\n", buf);
 1b4:	da040593          	addi	a1,s0,-608
 1b8:	00001517          	auipc	a0,0x1
 1bc:	a0050513          	addi	a0,a0,-1536 # bb8 <malloc+0x148>
 1c0:	7f8000ef          	jal	9b8 <printf>
            continue;
 1c4:	b55d                	j	6a <find+0x6a>
            }
          } else {
            wait(0);
 1c6:	4501                	li	a0,0
 1c8:	3ac000ef          	jal	574 <wait>
 1cc:	816a                	mv	sp,s10
 1ce:	bd71                	j	6a <find+0x6a>
        }
      }

      break;
    default:
      fprintf(2, "find: invalid argument - %s is not directory\n", dir);
 1d0:	865a                	mv	a2,s6
 1d2:	00001597          	auipc	a1,0x1
 1d6:	a1658593          	addi	a1,a1,-1514 # be8 <malloc+0x178>
 1da:	4509                	li	a0,2
 1dc:	7b2000ef          	jal	98e <fprintf>
  }

  close(fd);
 1e0:	8526                	mv	a0,s1
 1e2:	3b2000ef          	jal	594 <close>
}
 1e6:	d7040113          	addi	sp,s0,-656
 1ea:	28813083          	ld	ra,648(sp)
 1ee:	28013403          	ld	s0,640(sp)
 1f2:	27813483          	ld	s1,632(sp)
 1f6:	27013903          	ld	s2,624(sp)
 1fa:	26813983          	ld	s3,616(sp)
 1fe:	26013a03          	ld	s4,608(sp)
 202:	25813a83          	ld	s5,600(sp)
 206:	25013b03          	ld	s6,592(sp)
 20a:	24813b83          	ld	s7,584(sp)
 20e:	24013c03          	ld	s8,576(sp)
 212:	23813c83          	ld	s9,568(sp)
 216:	23013d03          	ld	s10,560(sp)
 21a:	29010113          	addi	sp,sp,656
 21e:	8082                	ret

0000000000000220 <main>:

int
main(int argc, char *argv[])
{
 220:	1101                	addi	sp,sp,-32
 222:	ec06                	sd	ra,24(sp)
 224:	e822                	sd	s0,16(sp)
 226:	1000                	addi	s0,sp,32
  if (argc < 3) {
 228:	4789                	li	a5,2
 22a:	02a7de63          	bge	a5,a0,266 <main+0x46>
 22e:	e426                	sd	s1,8(sp)
 230:	e04a                	sd	s2,0(sp)
 232:	84aa                	mv	s1,a0
 234:	892e                	mv	s2,a1
    printf("Usage: find <directory> <name> [-exec command]\n");
    exit(1);
  }
  
  if (argc == 3) {
 236:	478d                	li	a5,3
 238:	04f50263          	beq	a0,a5,27c <main+0x5c>
    find(argv[1], argv[2], 0, argv);
    exit(0);
  }

  if (argc >= 5 && strcmp(argv[3], "-exec") == 0 && strlen(argv[4]) > 0) {
 23c:	4791                	li	a5,4
 23e:	00a7db63          	bge	a5,a0,254 <main+0x34>
 242:	00001597          	auipc	a1,0x1
 246:	a0658593          	addi	a1,a1,-1530 # c48 <malloc+0x1d8>
 24a:	01893503          	ld	a0,24(s2)
 24e:	098000ef          	jal	2e6 <strcmp>
 252:	cd1d                	beqz	a0,290 <main+0x70>
    find(argv[1], argv[2], argc - 4, argv+4);
  } else {
    printf("Usage: find <directory> <name> [-exec command]\n");
 254:	00001517          	auipc	a0,0x1
 258:	9c450513          	addi	a0,a0,-1596 # c18 <malloc+0x1a8>
 25c:	75c000ef          	jal	9b8 <printf>
    exit(1);
 260:	4505                	li	a0,1
 262:	30a000ef          	jal	56c <exit>
 266:	e426                	sd	s1,8(sp)
 268:	e04a                	sd	s2,0(sp)
    printf("Usage: find <directory> <name> [-exec command]\n");
 26a:	00001517          	auipc	a0,0x1
 26e:	9ae50513          	addi	a0,a0,-1618 # c18 <malloc+0x1a8>
 272:	746000ef          	jal	9b8 <printf>
    exit(1);
 276:	4505                	li	a0,1
 278:	2f4000ef          	jal	56c <exit>
    find(argv[1], argv[2], 0, argv);
 27c:	86ae                	mv	a3,a1
 27e:	4601                	li	a2,0
 280:	698c                	ld	a1,16(a1)
 282:	00893503          	ld	a0,8(s2)
 286:	d7bff0ef          	jal	0 <find>
    exit(0);
 28a:	4501                	li	a0,0
 28c:	2e0000ef          	jal	56c <exit>
  if (argc >= 5 && strcmp(argv[3], "-exec") == 0 && strlen(argv[4]) > 0) {
 290:	02093503          	ld	a0,32(s2)
 294:	082000ef          	jal	316 <strlen>
 298:	dd55                	beqz	a0,254 <main+0x34>
    find(argv[1], argv[2], argc - 4, argv+4);
 29a:	02090693          	addi	a3,s2,32
 29e:	ffc4861b          	addiw	a2,s1,-4
 2a2:	01093583          	ld	a1,16(s2)
 2a6:	00893503          	ld	a0,8(s2)
 2aa:	d57ff0ef          	jal	0 <find>
  }

  exit(0);
 2ae:	4501                	li	a0,0
 2b0:	2bc000ef          	jal	56c <exit>

00000000000002b4 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start()
{
 2b4:	1141                	addi	sp,sp,-16
 2b6:	e406                	sd	ra,8(sp)
 2b8:	e022                	sd	s0,0(sp)
 2ba:	0800                	addi	s0,sp,16
  extern int main();
  main();
 2bc:	f65ff0ef          	jal	220 <main>
  exit(0);
 2c0:	4501                	li	a0,0
 2c2:	2aa000ef          	jal	56c <exit>

00000000000002c6 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
 2c6:	1141                	addi	sp,sp,-16
 2c8:	e406                	sd	ra,8(sp)
 2ca:	e022                	sd	s0,0(sp)
 2cc:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 2ce:	87aa                	mv	a5,a0
 2d0:	0585                	addi	a1,a1,1
 2d2:	0785                	addi	a5,a5,1
 2d4:	fff5c703          	lbu	a4,-1(a1)
 2d8:	fee78fa3          	sb	a4,-1(a5)
 2dc:	fb75                	bnez	a4,2d0 <strcpy+0xa>
    ;
  return os;
}
 2de:	60a2                	ld	ra,8(sp)
 2e0:	6402                	ld	s0,0(sp)
 2e2:	0141                	addi	sp,sp,16
 2e4:	8082                	ret

00000000000002e6 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 2e6:	1141                	addi	sp,sp,-16
 2e8:	e406                	sd	ra,8(sp)
 2ea:	e022                	sd	s0,0(sp)
 2ec:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
 2ee:	00054783          	lbu	a5,0(a0)
 2f2:	cb91                	beqz	a5,306 <strcmp+0x20>
 2f4:	0005c703          	lbu	a4,0(a1)
 2f8:	00f71763          	bne	a4,a5,306 <strcmp+0x20>
    p++, q++;
 2fc:	0505                	addi	a0,a0,1
 2fe:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
 300:	00054783          	lbu	a5,0(a0)
 304:	fbe5                	bnez	a5,2f4 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
 306:	0005c503          	lbu	a0,0(a1)
}
 30a:	40a7853b          	subw	a0,a5,a0
 30e:	60a2                	ld	ra,8(sp)
 310:	6402                	ld	s0,0(sp)
 312:	0141                	addi	sp,sp,16
 314:	8082                	ret

0000000000000316 <strlen>:

uint
strlen(const char *s)
{
 316:	1141                	addi	sp,sp,-16
 318:	e406                	sd	ra,8(sp)
 31a:	e022                	sd	s0,0(sp)
 31c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
 31e:	00054783          	lbu	a5,0(a0)
 322:	cf91                	beqz	a5,33e <strlen+0x28>
 324:	00150793          	addi	a5,a0,1
 328:	86be                	mv	a3,a5
 32a:	0785                	addi	a5,a5,1
 32c:	fff7c703          	lbu	a4,-1(a5)
 330:	ff65                	bnez	a4,328 <strlen+0x12>
 332:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
 336:	60a2                	ld	ra,8(sp)
 338:	6402                	ld	s0,0(sp)
 33a:	0141                	addi	sp,sp,16
 33c:	8082                	ret
  for(n = 0; s[n]; n++)
 33e:	4501                	li	a0,0
 340:	bfdd                	j	336 <strlen+0x20>

0000000000000342 <memset>:

void*
memset(void *dst, int c, uint n)
{
 342:	1141                	addi	sp,sp,-16
 344:	e406                	sd	ra,8(sp)
 346:	e022                	sd	s0,0(sp)
 348:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
 34a:	ca19                	beqz	a2,360 <memset+0x1e>
 34c:	87aa                	mv	a5,a0
 34e:	1602                	slli	a2,a2,0x20
 350:	9201                	srli	a2,a2,0x20
 352:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
 356:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
 35a:	0785                	addi	a5,a5,1
 35c:	fee79de3          	bne	a5,a4,356 <memset+0x14>
  }
  return dst;
}
 360:	60a2                	ld	ra,8(sp)
 362:	6402                	ld	s0,0(sp)
 364:	0141                	addi	sp,sp,16
 366:	8082                	ret

0000000000000368 <strchr>:

char*
strchr(const char *s, char c)
{
 368:	1141                	addi	sp,sp,-16
 36a:	e406                	sd	ra,8(sp)
 36c:	e022                	sd	s0,0(sp)
 36e:	0800                	addi	s0,sp,16
  for(; *s; s++)
 370:	00054783          	lbu	a5,0(a0)
 374:	cf81                	beqz	a5,38c <strchr+0x24>
    if(*s == c)
 376:	00f58763          	beq	a1,a5,384 <strchr+0x1c>
  for(; *s; s++)
 37a:	0505                	addi	a0,a0,1
 37c:	00054783          	lbu	a5,0(a0)
 380:	fbfd                	bnez	a5,376 <strchr+0xe>
      return (char*)s;
  return 0;
 382:	4501                	li	a0,0
}
 384:	60a2                	ld	ra,8(sp)
 386:	6402                	ld	s0,0(sp)
 388:	0141                	addi	sp,sp,16
 38a:	8082                	ret
  return 0;
 38c:	4501                	li	a0,0
 38e:	bfdd                	j	384 <strchr+0x1c>

0000000000000390 <gets>:

char*
gets(char *buf, int max)
{
 390:	711d                	addi	sp,sp,-96
 392:	ec86                	sd	ra,88(sp)
 394:	e8a2                	sd	s0,80(sp)
 396:	e4a6                	sd	s1,72(sp)
 398:	e0ca                	sd	s2,64(sp)
 39a:	fc4e                	sd	s3,56(sp)
 39c:	f852                	sd	s4,48(sp)
 39e:	f456                	sd	s5,40(sp)
 3a0:	f05a                	sd	s6,32(sp)
 3a2:	ec5e                	sd	s7,24(sp)
 3a4:	e862                	sd	s8,16(sp)
 3a6:	1080                	addi	s0,sp,96
 3a8:	8baa                	mv	s7,a0
 3aa:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 3ac:	892a                	mv	s2,a0
 3ae:	4481                	li	s1,0
    cc = read(0, &c, 1);
 3b0:	faf40b13          	addi	s6,s0,-81
 3b4:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
 3b6:	8c26                	mv	s8,s1
 3b8:	0014899b          	addiw	s3,s1,1
 3bc:	84ce                	mv	s1,s3
 3be:	0349d463          	bge	s3,s4,3e6 <gets+0x56>
    cc = read(0, &c, 1);
 3c2:	8656                	mv	a2,s5
 3c4:	85da                	mv	a1,s6
 3c6:	4501                	li	a0,0
 3c8:	1bc000ef          	jal	584 <read>
    if(cc < 1)
 3cc:	00a05d63          	blez	a0,3e6 <gets+0x56>
      break;
    buf[i++] = c;
 3d0:	faf44783          	lbu	a5,-81(s0)
 3d4:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
 3d8:	0905                	addi	s2,s2,1
 3da:	ff678713          	addi	a4,a5,-10
 3de:	c319                	beqz	a4,3e4 <gets+0x54>
 3e0:	17cd                	addi	a5,a5,-13
 3e2:	fbf1                	bnez	a5,3b6 <gets+0x26>
    buf[i++] = c;
 3e4:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
 3e6:	9c5e                	add	s8,s8,s7
 3e8:	000c0023          	sb	zero,0(s8)
  return buf;
}
 3ec:	855e                	mv	a0,s7
 3ee:	60e6                	ld	ra,88(sp)
 3f0:	6446                	ld	s0,80(sp)
 3f2:	64a6                	ld	s1,72(sp)
 3f4:	6906                	ld	s2,64(sp)
 3f6:	79e2                	ld	s3,56(sp)
 3f8:	7a42                	ld	s4,48(sp)
 3fa:	7aa2                	ld	s5,40(sp)
 3fc:	7b02                	ld	s6,32(sp)
 3fe:	6be2                	ld	s7,24(sp)
 400:	6c42                	ld	s8,16(sp)
 402:	6125                	addi	sp,sp,96
 404:	8082                	ret

0000000000000406 <stat>:

int
stat(const char *n, struct stat *st)
{
 406:	1101                	addi	sp,sp,-32
 408:	ec06                	sd	ra,24(sp)
 40a:	e822                	sd	s0,16(sp)
 40c:	e04a                	sd	s2,0(sp)
 40e:	1000                	addi	s0,sp,32
 410:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 412:	4581                	li	a1,0
 414:	198000ef          	jal	5ac <open>
  if(fd < 0)
 418:	02054263          	bltz	a0,43c <stat+0x36>
 41c:	e426                	sd	s1,8(sp)
 41e:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
 420:	85ca                	mv	a1,s2
 422:	1a2000ef          	jal	5c4 <fstat>
 426:	892a                	mv	s2,a0
  close(fd);
 428:	8526                	mv	a0,s1
 42a:	16a000ef          	jal	594 <close>
  return r;
 42e:	64a2                	ld	s1,8(sp)
}
 430:	854a                	mv	a0,s2
 432:	60e2                	ld	ra,24(sp)
 434:	6442                	ld	s0,16(sp)
 436:	6902                	ld	s2,0(sp)
 438:	6105                	addi	sp,sp,32
 43a:	8082                	ret
    return -1;
 43c:	57fd                	li	a5,-1
 43e:	893e                	mv	s2,a5
 440:	bfc5                	j	430 <stat+0x2a>

0000000000000442 <atoi>:

int
atoi(const char *s)
{
 442:	1141                	addi	sp,sp,-16
 444:	e406                	sd	ra,8(sp)
 446:	e022                	sd	s0,0(sp)
 448:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
 44a:	00054683          	lbu	a3,0(a0)
 44e:	fd06879b          	addiw	a5,a3,-48
 452:	0ff7f793          	zext.b	a5,a5
 456:	4625                	li	a2,9
 458:	02f66963          	bltu	a2,a5,48a <atoi+0x48>
 45c:	872a                	mv	a4,a0
  n = 0;
 45e:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
 460:	0705                	addi	a4,a4,1
 462:	0025179b          	slliw	a5,a0,0x2
 466:	9fa9                	addw	a5,a5,a0
 468:	0017979b          	slliw	a5,a5,0x1
 46c:	9fb5                	addw	a5,a5,a3
 46e:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
 472:	00074683          	lbu	a3,0(a4)
 476:	fd06879b          	addiw	a5,a3,-48
 47a:	0ff7f793          	zext.b	a5,a5
 47e:	fef671e3          	bgeu	a2,a5,460 <atoi+0x1e>
  return n;
}
 482:	60a2                	ld	ra,8(sp)
 484:	6402                	ld	s0,0(sp)
 486:	0141                	addi	sp,sp,16
 488:	8082                	ret
  n = 0;
 48a:	4501                	li	a0,0
 48c:	bfdd                	j	482 <atoi+0x40>

000000000000048e <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 48e:	1141                	addi	sp,sp,-16
 490:	e406                	sd	ra,8(sp)
 492:	e022                	sd	s0,0(sp)
 494:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
 496:	02b57563          	bgeu	a0,a1,4c0 <memmove+0x32>
    while(n-- > 0)
 49a:	00c05f63          	blez	a2,4b8 <memmove+0x2a>
 49e:	1602                	slli	a2,a2,0x20
 4a0:	9201                	srli	a2,a2,0x20
 4a2:	00c507b3          	add	a5,a0,a2
  dst = vdst;
 4a6:	872a                	mv	a4,a0
      *dst++ = *src++;
 4a8:	0585                	addi	a1,a1,1
 4aa:	0705                	addi	a4,a4,1
 4ac:	fff5c683          	lbu	a3,-1(a1)
 4b0:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
 4b4:	fee79ae3          	bne	a5,a4,4a8 <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
 4b8:	60a2                	ld	ra,8(sp)
 4ba:	6402                	ld	s0,0(sp)
 4bc:	0141                	addi	sp,sp,16
 4be:	8082                	ret
    while(n-- > 0)
 4c0:	fec05ce3          	blez	a2,4b8 <memmove+0x2a>
    dst += n;
 4c4:	00c50733          	add	a4,a0,a2
    src += n;
 4c8:	95b2                	add	a1,a1,a2
 4ca:	fff6079b          	addiw	a5,a2,-1
 4ce:	1782                	slli	a5,a5,0x20
 4d0:	9381                	srli	a5,a5,0x20
 4d2:	fff7c793          	not	a5,a5
 4d6:	97ba                	add	a5,a5,a4
      *--dst = *--src;
 4d8:	15fd                	addi	a1,a1,-1
 4da:	177d                	addi	a4,a4,-1
 4dc:	0005c683          	lbu	a3,0(a1)
 4e0:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
 4e4:	fef71ae3          	bne	a4,a5,4d8 <memmove+0x4a>
 4e8:	bfc1                	j	4b8 <memmove+0x2a>

00000000000004ea <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
 4ea:	1141                	addi	sp,sp,-16
 4ec:	e406                	sd	ra,8(sp)
 4ee:	e022                	sd	s0,0(sp)
 4f0:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
 4f2:	c61d                	beqz	a2,520 <memcmp+0x36>
 4f4:	1602                	slli	a2,a2,0x20
 4f6:	9201                	srli	a2,a2,0x20
 4f8:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
 4fc:	00054783          	lbu	a5,0(a0)
 500:	0005c703          	lbu	a4,0(a1)
 504:	00e79863          	bne	a5,a4,514 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
 508:	0505                	addi	a0,a0,1
    p2++;
 50a:	0585                	addi	a1,a1,1
  while (n-- > 0) {
 50c:	fed518e3          	bne	a0,a3,4fc <memcmp+0x12>
  }
  return 0;
 510:	4501                	li	a0,0
 512:	a019                	j	518 <memcmp+0x2e>
      return *p1 - *p2;
 514:	40e7853b          	subw	a0,a5,a4
}
 518:	60a2                	ld	ra,8(sp)
 51a:	6402                	ld	s0,0(sp)
 51c:	0141                	addi	sp,sp,16
 51e:	8082                	ret
  return 0;
 520:	4501                	li	a0,0
 522:	bfdd                	j	518 <memcmp+0x2e>

0000000000000524 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
 524:	1141                	addi	sp,sp,-16
 526:	e406                	sd	ra,8(sp)
 528:	e022                	sd	s0,0(sp)
 52a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
 52c:	f63ff0ef          	jal	48e <memmove>
}
 530:	60a2                	ld	ra,8(sp)
 532:	6402                	ld	s0,0(sp)
 534:	0141                	addi	sp,sp,16
 536:	8082                	ret

0000000000000538 <sbrk>:

char *
sbrk(int n) {
 538:	1141                	addi	sp,sp,-16
 53a:	e406                	sd	ra,8(sp)
 53c:	e022                	sd	s0,0(sp)
 53e:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
 540:	4585                	li	a1,1
 542:	0b2000ef          	jal	5f4 <sys_sbrk>
}
 546:	60a2                	ld	ra,8(sp)
 548:	6402                	ld	s0,0(sp)
 54a:	0141                	addi	sp,sp,16
 54c:	8082                	ret

000000000000054e <sbrklazy>:

char *
sbrklazy(int n) {
 54e:	1141                	addi	sp,sp,-16
 550:	e406                	sd	ra,8(sp)
 552:	e022                	sd	s0,0(sp)
 554:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
 556:	4589                	li	a1,2
 558:	09c000ef          	jal	5f4 <sys_sbrk>
}
 55c:	60a2                	ld	ra,8(sp)
 55e:	6402                	ld	s0,0(sp)
 560:	0141                	addi	sp,sp,16
 562:	8082                	ret

0000000000000564 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
 564:	4885                	li	a7,1
 ecall
 566:	00000073          	ecall
 ret
 56a:	8082                	ret

000000000000056c <exit>:
.global exit
exit:
 li a7, SYS_exit
 56c:	4889                	li	a7,2
 ecall
 56e:	00000073          	ecall
 ret
 572:	8082                	ret

0000000000000574 <wait>:
.global wait
wait:
 li a7, SYS_wait
 574:	488d                	li	a7,3
 ecall
 576:	00000073          	ecall
 ret
 57a:	8082                	ret

000000000000057c <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
 57c:	4891                	li	a7,4
 ecall
 57e:	00000073          	ecall
 ret
 582:	8082                	ret

0000000000000584 <read>:
.global read
read:
 li a7, SYS_read
 584:	4895                	li	a7,5
 ecall
 586:	00000073          	ecall
 ret
 58a:	8082                	ret

000000000000058c <write>:
.global write
write:
 li a7, SYS_write
 58c:	48c1                	li	a7,16
 ecall
 58e:	00000073          	ecall
 ret
 592:	8082                	ret

0000000000000594 <close>:
.global close
close:
 li a7, SYS_close
 594:	48d5                	li	a7,21
 ecall
 596:	00000073          	ecall
 ret
 59a:	8082                	ret

000000000000059c <kill>:
.global kill
kill:
 li a7, SYS_kill
 59c:	4899                	li	a7,6
 ecall
 59e:	00000073          	ecall
 ret
 5a2:	8082                	ret

00000000000005a4 <exec>:
.global exec
exec:
 li a7, SYS_exec
 5a4:	489d                	li	a7,7
 ecall
 5a6:	00000073          	ecall
 ret
 5aa:	8082                	ret

00000000000005ac <open>:
.global open
open:
 li a7, SYS_open
 5ac:	48bd                	li	a7,15
 ecall
 5ae:	00000073          	ecall
 ret
 5b2:	8082                	ret

00000000000005b4 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
 5b4:	48c5                	li	a7,17
 ecall
 5b6:	00000073          	ecall
 ret
 5ba:	8082                	ret

00000000000005bc <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
 5bc:	48c9                	li	a7,18
 ecall
 5be:	00000073          	ecall
 ret
 5c2:	8082                	ret

00000000000005c4 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
 5c4:	48a1                	li	a7,8
 ecall
 5c6:	00000073          	ecall
 ret
 5ca:	8082                	ret

00000000000005cc <link>:
.global link
link:
 li a7, SYS_link
 5cc:	48cd                	li	a7,19
 ecall
 5ce:	00000073          	ecall
 ret
 5d2:	8082                	ret

00000000000005d4 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
 5d4:	48d1                	li	a7,20
 ecall
 5d6:	00000073          	ecall
 ret
 5da:	8082                	ret

00000000000005dc <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
 5dc:	48a5                	li	a7,9
 ecall
 5de:	00000073          	ecall
 ret
 5e2:	8082                	ret

00000000000005e4 <dup>:
.global dup
dup:
 li a7, SYS_dup
 5e4:	48a9                	li	a7,10
 ecall
 5e6:	00000073          	ecall
 ret
 5ea:	8082                	ret

00000000000005ec <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
 5ec:	48ad                	li	a7,11
 ecall
 5ee:	00000073          	ecall
 ret
 5f2:	8082                	ret

00000000000005f4 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
 5f4:	48b1                	li	a7,12
 ecall
 5f6:	00000073          	ecall
 ret
 5fa:	8082                	ret

00000000000005fc <pause>:
.global pause
pause:
 li a7, SYS_pause
 5fc:	48b5                	li	a7,13
 ecall
 5fe:	00000073          	ecall
 ret
 602:	8082                	ret

0000000000000604 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
 604:	48b9                	li	a7,14
 ecall
 606:	00000073          	ecall
 ret
 60a:	8082                	ret

000000000000060c <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
 60c:	1101                	addi	sp,sp,-32
 60e:	ec06                	sd	ra,24(sp)
 610:	e822                	sd	s0,16(sp)
 612:	1000                	addi	s0,sp,32
 614:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
 618:	4605                	li	a2,1
 61a:	fef40593          	addi	a1,s0,-17
 61e:	f6fff0ef          	jal	58c <write>
}
 622:	60e2                	ld	ra,24(sp)
 624:	6442                	ld	s0,16(sp)
 626:	6105                	addi	sp,sp,32
 628:	8082                	ret

000000000000062a <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
 62a:	715d                	addi	sp,sp,-80
 62c:	e486                	sd	ra,72(sp)
 62e:	e0a2                	sd	s0,64(sp)
 630:	f84a                	sd	s2,48(sp)
 632:	f44e                	sd	s3,40(sp)
 634:	0880                	addi	s0,sp,80
 636:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 638:	cac1                	beqz	a3,6c8 <printint+0x9e>
 63a:	0805d763          	bgez	a1,6c8 <printint+0x9e>
    neg = 1;
    x = -xx;
 63e:	40b005bb          	negw	a1,a1
    neg = 1;
 642:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
 644:	fb840993          	addi	s3,s0,-72
  neg = 0;
 648:	86ce                	mv	a3,s3
  i = 0;
 64a:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
 64c:	00000817          	auipc	a6,0x0
 650:	60c80813          	addi	a6,a6,1548 # c58 <digits>
 654:	88ba                	mv	a7,a4
 656:	0017051b          	addiw	a0,a4,1
 65a:	872a                	mv	a4,a0
 65c:	02c5f7bb          	remuw	a5,a1,a2
 660:	1782                	slli	a5,a5,0x20
 662:	9381                	srli	a5,a5,0x20
 664:	97c2                	add	a5,a5,a6
 666:	0007c783          	lbu	a5,0(a5)
 66a:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
 66e:	87ae                	mv	a5,a1
 670:	02c5d5bb          	divuw	a1,a1,a2
 674:	0685                	addi	a3,a3,1
 676:	fcc7ffe3          	bgeu	a5,a2,654 <printint+0x2a>
  if(neg)
 67a:	00030c63          	beqz	t1,692 <printint+0x68>
    buf[i++] = '-';
 67e:	fd050793          	addi	a5,a0,-48
 682:	00878533          	add	a0,a5,s0
 686:	02d00793          	li	a5,45
 68a:	fef50423          	sb	a5,-24(a0)
 68e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
 692:	02e05563          	blez	a4,6bc <printint+0x92>
 696:	fc26                	sd	s1,56(sp)
 698:	377d                	addiw	a4,a4,-1
 69a:	00e984b3          	add	s1,s3,a4
 69e:	19fd                	addi	s3,s3,-1
 6a0:	99ba                	add	s3,s3,a4
 6a2:	1702                	slli	a4,a4,0x20
 6a4:	9301                	srli	a4,a4,0x20
 6a6:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
 6aa:	0004c583          	lbu	a1,0(s1)
 6ae:	854a                	mv	a0,s2
 6b0:	f5dff0ef          	jal	60c <putc>
  while(--i >= 0)
 6b4:	14fd                	addi	s1,s1,-1
 6b6:	ff349ae3          	bne	s1,s3,6aa <printint+0x80>
 6ba:	74e2                	ld	s1,56(sp)
}
 6bc:	60a6                	ld	ra,72(sp)
 6be:	6406                	ld	s0,64(sp)
 6c0:	7942                	ld	s2,48(sp)
 6c2:	79a2                	ld	s3,40(sp)
 6c4:	6161                	addi	sp,sp,80
 6c6:	8082                	ret
    x = xx;
 6c8:	2581                	sext.w	a1,a1
  neg = 0;
 6ca:	4301                	li	t1,0
 6cc:	bfa5                	j	644 <printint+0x1a>

00000000000006ce <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
 6ce:	711d                	addi	sp,sp,-96
 6d0:	ec86                	sd	ra,88(sp)
 6d2:	e8a2                	sd	s0,80(sp)
 6d4:	e4a6                	sd	s1,72(sp)
 6d6:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
 6d8:	0005c483          	lbu	s1,0(a1)
 6dc:	22048363          	beqz	s1,902 <vprintf+0x234>
 6e0:	e0ca                	sd	s2,64(sp)
 6e2:	fc4e                	sd	s3,56(sp)
 6e4:	f852                	sd	s4,48(sp)
 6e6:	f456                	sd	s5,40(sp)
 6e8:	f05a                	sd	s6,32(sp)
 6ea:	ec5e                	sd	s7,24(sp)
 6ec:	e862                	sd	s8,16(sp)
 6ee:	8b2a                	mv	s6,a0
 6f0:	8a2e                	mv	s4,a1
 6f2:	8bb2                	mv	s7,a2
  state = 0;
 6f4:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
 6f6:	4901                	li	s2,0
 6f8:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
 6fa:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
 6fe:	06400c13          	li	s8,100
 702:	a00d                	j	724 <vprintf+0x56>
        putc(fd, c0);
 704:	85a6                	mv	a1,s1
 706:	855a                	mv	a0,s6
 708:	f05ff0ef          	jal	60c <putc>
 70c:	a019                	j	712 <vprintf+0x44>
    } else if(state == '%'){
 70e:	03598363          	beq	s3,s5,734 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
 712:	0019079b          	addiw	a5,s2,1
 716:	893e                	mv	s2,a5
 718:	873e                	mv	a4,a5
 71a:	97d2                	add	a5,a5,s4
 71c:	0007c483          	lbu	s1,0(a5)
 720:	1c048a63          	beqz	s1,8f4 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
 724:	0004879b          	sext.w	a5,s1
    if(state == 0){
 728:	fe0993e3          	bnez	s3,70e <vprintf+0x40>
      if(c0 == '%'){
 72c:	fd579ce3          	bne	a5,s5,704 <vprintf+0x36>
        state = '%';
 730:	89be                	mv	s3,a5
 732:	b7c5                	j	712 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
 734:	00ea06b3          	add	a3,s4,a4
 738:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
 73c:	1c060863          	beqz	a2,90c <vprintf+0x23e>
      if(c0 == 'd'){
 740:	03878763          	beq	a5,s8,76e <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
 744:	f9478693          	addi	a3,a5,-108
 748:	0016b693          	seqz	a3,a3
 74c:	f9c60593          	addi	a1,a2,-100
 750:	e99d                	bnez	a1,786 <vprintf+0xb8>
 752:	ca95                	beqz	a3,786 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
 754:	008b8493          	addi	s1,s7,8
 758:	4685                	li	a3,1
 75a:	4629                	li	a2,10
 75c:	000bb583          	ld	a1,0(s7)
 760:	855a                	mv	a0,s6
 762:	ec9ff0ef          	jal	62a <printint>
        i += 1;
 766:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
 768:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
 76a:	4981                	li	s3,0
 76c:	b75d                	j	712 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
 76e:	008b8493          	addi	s1,s7,8
 772:	4685                	li	a3,1
 774:	4629                	li	a2,10
 776:	000ba583          	lw	a1,0(s7)
 77a:	855a                	mv	a0,s6
 77c:	eafff0ef          	jal	62a <printint>
 780:	8ba6                	mv	s7,s1
      state = 0;
 782:	4981                	li	s3,0
 784:	b779                	j	712 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
 786:	9752                	add	a4,a4,s4
 788:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 78c:	f9460713          	addi	a4,a2,-108
 790:	00173713          	seqz	a4,a4
 794:	8f75                	and	a4,a4,a3
 796:	f9c58513          	addi	a0,a1,-100
 79a:	18051363          	bnez	a0,920 <vprintf+0x252>
 79e:	18070163          	beqz	a4,920 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
 7a2:	008b8493          	addi	s1,s7,8
 7a6:	4685                	li	a3,1
 7a8:	4629                	li	a2,10
 7aa:	000bb583          	ld	a1,0(s7)
 7ae:	855a                	mv	a0,s6
 7b0:	e7bff0ef          	jal	62a <printint>
        i += 2;
 7b4:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
 7b6:	8ba6                	mv	s7,s1
      state = 0;
 7b8:	4981                	li	s3,0
        i += 2;
 7ba:	bfa1                	j	712 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
 7bc:	008b8493          	addi	s1,s7,8
 7c0:	4681                	li	a3,0
 7c2:	4629                	li	a2,10
 7c4:	000be583          	lwu	a1,0(s7)
 7c8:	855a                	mv	a0,s6
 7ca:	e61ff0ef          	jal	62a <printint>
 7ce:	8ba6                	mv	s7,s1
      state = 0;
 7d0:	4981                	li	s3,0
 7d2:	b781                	j	712 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7d4:	008b8493          	addi	s1,s7,8
 7d8:	4681                	li	a3,0
 7da:	4629                	li	a2,10
 7dc:	000bb583          	ld	a1,0(s7)
 7e0:	855a                	mv	a0,s6
 7e2:	e49ff0ef          	jal	62a <printint>
        i += 1;
 7e6:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
 7e8:	8ba6                	mv	s7,s1
      state = 0;
 7ea:	4981                	li	s3,0
 7ec:	b71d                	j	712 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
 7ee:	008b8493          	addi	s1,s7,8
 7f2:	4681                	li	a3,0
 7f4:	4629                	li	a2,10
 7f6:	000bb583          	ld	a1,0(s7)
 7fa:	855a                	mv	a0,s6
 7fc:	e2fff0ef          	jal	62a <printint>
        i += 2;
 800:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
 802:	8ba6                	mv	s7,s1
      state = 0;
 804:	4981                	li	s3,0
        i += 2;
 806:	b731                	j	712 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
 808:	008b8493          	addi	s1,s7,8
 80c:	4681                	li	a3,0
 80e:	4641                	li	a2,16
 810:	000be583          	lwu	a1,0(s7)
 814:	855a                	mv	a0,s6
 816:	e15ff0ef          	jal	62a <printint>
 81a:	8ba6                	mv	s7,s1
      state = 0;
 81c:	4981                	li	s3,0
 81e:	bdd5                	j	712 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 820:	008b8493          	addi	s1,s7,8
 824:	4681                	li	a3,0
 826:	4641                	li	a2,16
 828:	000bb583          	ld	a1,0(s7)
 82c:	855a                	mv	a0,s6
 82e:	dfdff0ef          	jal	62a <printint>
        i += 1;
 832:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
 834:	8ba6                	mv	s7,s1
      state = 0;
 836:	4981                	li	s3,0
 838:	bde9                	j	712 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
 83a:	008b8493          	addi	s1,s7,8
 83e:	4681                	li	a3,0
 840:	4641                	li	a2,16
 842:	000bb583          	ld	a1,0(s7)
 846:	855a                	mv	a0,s6
 848:	de3ff0ef          	jal	62a <printint>
        i += 2;
 84c:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
 84e:	8ba6                	mv	s7,s1
      state = 0;
 850:	4981                	li	s3,0
        i += 2;
 852:	b5c1                	j	712 <vprintf+0x44>
 854:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
 856:	008b8793          	addi	a5,s7,8
 85a:	8cbe                	mv	s9,a5
 85c:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
 860:	03000593          	li	a1,48
 864:	855a                	mv	a0,s6
 866:	da7ff0ef          	jal	60c <putc>
  putc(fd, 'x');
 86a:	07800593          	li	a1,120
 86e:	855a                	mv	a0,s6
 870:	d9dff0ef          	jal	60c <putc>
 874:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
 876:	00000b97          	auipc	s7,0x0
 87a:	3e2b8b93          	addi	s7,s7,994 # c58 <digits>
 87e:	03c9d793          	srli	a5,s3,0x3c
 882:	97de                	add	a5,a5,s7
 884:	0007c583          	lbu	a1,0(a5)
 888:	855a                	mv	a0,s6
 88a:	d83ff0ef          	jal	60c <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
 88e:	0992                	slli	s3,s3,0x4
 890:	34fd                	addiw	s1,s1,-1
 892:	f4f5                	bnez	s1,87e <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
 894:	8be6                	mv	s7,s9
      state = 0;
 896:	4981                	li	s3,0
 898:	6ca2                	ld	s9,8(sp)
 89a:	bda5                	j	712 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
 89c:	008b8493          	addi	s1,s7,8
 8a0:	000bc583          	lbu	a1,0(s7)
 8a4:	855a                	mv	a0,s6
 8a6:	d67ff0ef          	jal	60c <putc>
 8aa:	8ba6                	mv	s7,s1
      state = 0;
 8ac:	4981                	li	s3,0
 8ae:	b595                	j	712 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 8b0:	008b8993          	addi	s3,s7,8
 8b4:	000bb483          	ld	s1,0(s7)
 8b8:	cc91                	beqz	s1,8d4 <vprintf+0x206>
        for(; *s; s++)
 8ba:	0004c583          	lbu	a1,0(s1)
 8be:	c985                	beqz	a1,8ee <vprintf+0x220>
          putc(fd, *s);
 8c0:	855a                	mv	a0,s6
 8c2:	d4bff0ef          	jal	60c <putc>
        for(; *s; s++)
 8c6:	0485                	addi	s1,s1,1
 8c8:	0004c583          	lbu	a1,0(s1)
 8cc:	f9f5                	bnez	a1,8c0 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
 8ce:	8bce                	mv	s7,s3
      state = 0;
 8d0:	4981                	li	s3,0
 8d2:	b581                	j	712 <vprintf+0x44>
          s = "(null)";
 8d4:	00000497          	auipc	s1,0x0
 8d8:	37c48493          	addi	s1,s1,892 # c50 <malloc+0x1e0>
        for(; *s; s++)
 8dc:	02800593          	li	a1,40
 8e0:	b7c5                	j	8c0 <vprintf+0x1f2>
        putc(fd, '%');
 8e2:	85be                	mv	a1,a5
 8e4:	855a                	mv	a0,s6
 8e6:	d27ff0ef          	jal	60c <putc>
      state = 0;
 8ea:	4981                	li	s3,0
 8ec:	b51d                	j	712 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
 8ee:	8bce                	mv	s7,s3
      state = 0;
 8f0:	4981                	li	s3,0
 8f2:	b505                	j	712 <vprintf+0x44>
 8f4:	6906                	ld	s2,64(sp)
 8f6:	79e2                	ld	s3,56(sp)
 8f8:	7a42                	ld	s4,48(sp)
 8fa:	7aa2                	ld	s5,40(sp)
 8fc:	7b02                	ld	s6,32(sp)
 8fe:	6be2                	ld	s7,24(sp)
 900:	6c42                	ld	s8,16(sp)
    }
  }
}
 902:	60e6                	ld	ra,88(sp)
 904:	6446                	ld	s0,80(sp)
 906:	64a6                	ld	s1,72(sp)
 908:	6125                	addi	sp,sp,96
 90a:	8082                	ret
      if(c0 == 'd'){
 90c:	06400713          	li	a4,100
 910:	e4e78fe3          	beq	a5,a4,76e <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
 914:	f9478693          	addi	a3,a5,-108
 918:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
 91c:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
 91e:	4701                	li	a4,0
      } else if(c0 == 'u'){
 920:	07500513          	li	a0,117
 924:	e8a78ce3          	beq	a5,a0,7bc <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
 928:	f8b60513          	addi	a0,a2,-117
 92c:	e119                	bnez	a0,932 <vprintf+0x264>
 92e:	ea0693e3          	bnez	a3,7d4 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
 932:	f8b58513          	addi	a0,a1,-117
 936:	e119                	bnez	a0,93c <vprintf+0x26e>
 938:	ea071be3          	bnez	a4,7ee <vprintf+0x120>
      } else if(c0 == 'x'){
 93c:	07800513          	li	a0,120
 940:	eca784e3          	beq	a5,a0,808 <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
 944:	f8860613          	addi	a2,a2,-120
 948:	e219                	bnez	a2,94e <vprintf+0x280>
 94a:	ec069be3          	bnez	a3,820 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
 94e:	f8858593          	addi	a1,a1,-120
 952:	e199                	bnez	a1,958 <vprintf+0x28a>
 954:	ee0713e3          	bnez	a4,83a <vprintf+0x16c>
      } else if(c0 == 'p'){
 958:	07000713          	li	a4,112
 95c:	eee78ce3          	beq	a5,a4,854 <vprintf+0x186>
      } else if(c0 == 'c'){
 960:	06300713          	li	a4,99
 964:	f2e78ce3          	beq	a5,a4,89c <vprintf+0x1ce>
      } else if(c0 == 's'){
 968:	07300713          	li	a4,115
 96c:	f4e782e3          	beq	a5,a4,8b0 <vprintf+0x1e2>
      } else if(c0 == '%'){
 970:	02500713          	li	a4,37
 974:	f6e787e3          	beq	a5,a4,8e2 <vprintf+0x214>
        putc(fd, '%');
 978:	02500593          	li	a1,37
 97c:	855a                	mv	a0,s6
 97e:	c8fff0ef          	jal	60c <putc>
        putc(fd, c0);
 982:	85a6                	mv	a1,s1
 984:	855a                	mv	a0,s6
 986:	c87ff0ef          	jal	60c <putc>
      state = 0;
 98a:	4981                	li	s3,0
 98c:	b359                	j	712 <vprintf+0x44>

000000000000098e <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
 98e:	715d                	addi	sp,sp,-80
 990:	ec06                	sd	ra,24(sp)
 992:	e822                	sd	s0,16(sp)
 994:	1000                	addi	s0,sp,32
 996:	e010                	sd	a2,0(s0)
 998:	e414                	sd	a3,8(s0)
 99a:	e818                	sd	a4,16(s0)
 99c:	ec1c                	sd	a5,24(s0)
 99e:	03043023          	sd	a6,32(s0)
 9a2:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
 9a6:	8622                	mv	a2,s0
 9a8:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
 9ac:	d23ff0ef          	jal	6ce <vprintf>
}
 9b0:	60e2                	ld	ra,24(sp)
 9b2:	6442                	ld	s0,16(sp)
 9b4:	6161                	addi	sp,sp,80
 9b6:	8082                	ret

00000000000009b8 <printf>:

void
printf(const char *fmt, ...)
{
 9b8:	711d                	addi	sp,sp,-96
 9ba:	ec06                	sd	ra,24(sp)
 9bc:	e822                	sd	s0,16(sp)
 9be:	1000                	addi	s0,sp,32
 9c0:	e40c                	sd	a1,8(s0)
 9c2:	e810                	sd	a2,16(s0)
 9c4:	ec14                	sd	a3,24(s0)
 9c6:	f018                	sd	a4,32(s0)
 9c8:	f41c                	sd	a5,40(s0)
 9ca:	03043823          	sd	a6,48(s0)
 9ce:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
 9d2:	00840613          	addi	a2,s0,8
 9d6:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
 9da:	85aa                	mv	a1,a0
 9dc:	4505                	li	a0,1
 9de:	cf1ff0ef          	jal	6ce <vprintf>
}
 9e2:	60e2                	ld	ra,24(sp)
 9e4:	6442                	ld	s0,16(sp)
 9e6:	6125                	addi	sp,sp,96
 9e8:	8082                	ret

00000000000009ea <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 9ea:	1141                	addi	sp,sp,-16
 9ec:	e406                	sd	ra,8(sp)
 9ee:	e022                	sd	s0,0(sp)
 9f0:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
 9f2:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 9f6:	00000797          	auipc	a5,0x0
 9fa:	60a7b783          	ld	a5,1546(a5) # 1000 <freep>
 9fe:	a039                	j	a0c <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a00:	6398                	ld	a4,0(a5)
 a02:	00e7e463          	bltu	a5,a4,a0a <free+0x20>
 a06:	00e6ea63          	bltu	a3,a4,a1a <free+0x30>
{
 a0a:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 a0c:	fed7fae3          	bgeu	a5,a3,a00 <free+0x16>
 a10:	6398                	ld	a4,0(a5)
 a12:	00e6e463          	bltu	a3,a4,a1a <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 a16:	fee7eae3          	bltu	a5,a4,a0a <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
 a1a:	ff852583          	lw	a1,-8(a0)
 a1e:	6390                	ld	a2,0(a5)
 a20:	02059813          	slli	a6,a1,0x20
 a24:	01c85713          	srli	a4,a6,0x1c
 a28:	9736                	add	a4,a4,a3
 a2a:	02e60563          	beq	a2,a4,a54 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
 a2e:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
 a32:	4790                	lw	a2,8(a5)
 a34:	02061593          	slli	a1,a2,0x20
 a38:	01c5d713          	srli	a4,a1,0x1c
 a3c:	973e                	add	a4,a4,a5
 a3e:	02e68263          	beq	a3,a4,a62 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
 a42:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
 a44:	00000717          	auipc	a4,0x0
 a48:	5af73e23          	sd	a5,1468(a4) # 1000 <freep>
}
 a4c:	60a2                	ld	ra,8(sp)
 a4e:	6402                	ld	s0,0(sp)
 a50:	0141                	addi	sp,sp,16
 a52:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
 a54:	4618                	lw	a4,8(a2)
 a56:	9f2d                	addw	a4,a4,a1
 a58:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
 a5c:	6398                	ld	a4,0(a5)
 a5e:	6310                	ld	a2,0(a4)
 a60:	b7f9                	j	a2e <free+0x44>
    p->s.size += bp->s.size;
 a62:	ff852703          	lw	a4,-8(a0)
 a66:	9f31                	addw	a4,a4,a2
 a68:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
 a6a:	ff053683          	ld	a3,-16(a0)
 a6e:	bfd1                	j	a42 <free+0x58>

0000000000000a70 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
 a70:	7139                	addi	sp,sp,-64
 a72:	fc06                	sd	ra,56(sp)
 a74:	f822                	sd	s0,48(sp)
 a76:	f04a                	sd	s2,32(sp)
 a78:	ec4e                	sd	s3,24(sp)
 a7a:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 a7c:	02051993          	slli	s3,a0,0x20
 a80:	0209d993          	srli	s3,s3,0x20
 a84:	09bd                	addi	s3,s3,15
 a86:	0049d993          	srli	s3,s3,0x4
 a8a:	2985                	addiw	s3,s3,1
 a8c:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
 a8e:	00000517          	auipc	a0,0x0
 a92:	57253503          	ld	a0,1394(a0) # 1000 <freep>
 a96:	c905                	beqz	a0,ac6 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 a98:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 a9a:	4798                	lw	a4,8(a5)
 a9c:	09377663          	bgeu	a4,s3,b28 <malloc+0xb8>
 aa0:	f426                	sd	s1,40(sp)
 aa2:	e852                	sd	s4,16(sp)
 aa4:	e456                	sd	s5,8(sp)
 aa6:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
 aa8:	8a4e                	mv	s4,s3
 aaa:	6705                	lui	a4,0x1
 aac:	00e9f363          	bgeu	s3,a4,ab2 <malloc+0x42>
 ab0:	6a05                	lui	s4,0x1
 ab2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
 ab6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
 aba:	00000497          	auipc	s1,0x0
 abe:	54648493          	addi	s1,s1,1350 # 1000 <freep>
  if(p == SBRK_ERROR)
 ac2:	5afd                	li	s5,-1
 ac4:	a83d                	j	b02 <malloc+0x92>
 ac6:	f426                	sd	s1,40(sp)
 ac8:	e852                	sd	s4,16(sp)
 aca:	e456                	sd	s5,8(sp)
 acc:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
 ace:	00000797          	auipc	a5,0x0
 ad2:	54278793          	addi	a5,a5,1346 # 1010 <base>
 ad6:	00000717          	auipc	a4,0x0
 ada:	52f73523          	sd	a5,1322(a4) # 1000 <freep>
 ade:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
 ae0:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
 ae4:	b7d1                	j	aa8 <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
 ae6:	6398                	ld	a4,0(a5)
 ae8:	e118                	sd	a4,0(a0)
 aea:	a899                	j	b40 <malloc+0xd0>
  hp->s.size = nu;
 aec:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
 af0:	0541                	addi	a0,a0,16
 af2:	ef9ff0ef          	jal	9ea <free>
  return freep;
 af6:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
 af8:	c125                	beqz	a0,b58 <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 afa:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
 afc:	4798                	lw	a4,8(a5)
 afe:	03277163          	bgeu	a4,s2,b20 <malloc+0xb0>
    if(p == freep)
 b02:	6098                	ld	a4,0(s1)
 b04:	853e                	mv	a0,a5
 b06:	fef71ae3          	bne	a4,a5,afa <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
 b0a:	8552                	mv	a0,s4
 b0c:	a2dff0ef          	jal	538 <sbrk>
  if(p == SBRK_ERROR)
 b10:	fd551ee3          	bne	a0,s5,aec <malloc+0x7c>
        return 0;
 b14:	4501                	li	a0,0
 b16:	74a2                	ld	s1,40(sp)
 b18:	6a42                	ld	s4,16(sp)
 b1a:	6aa2                	ld	s5,8(sp)
 b1c:	6b02                	ld	s6,0(sp)
 b1e:	a03d                	j	b4c <malloc+0xdc>
 b20:	74a2                	ld	s1,40(sp)
 b22:	6a42                	ld	s4,16(sp)
 b24:	6aa2                	ld	s5,8(sp)
 b26:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
 b28:	fae90fe3          	beq	s2,a4,ae6 <malloc+0x76>
        p->s.size -= nunits;
 b2c:	4137073b          	subw	a4,a4,s3
 b30:	c798                	sw	a4,8(a5)
        p += p->s.size;
 b32:	02071693          	slli	a3,a4,0x20
 b36:	01c6d713          	srli	a4,a3,0x1c
 b3a:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
 b3c:	0137a423          	sw	s3,8(a5)
      freep = prevp;
 b40:	00000717          	auipc	a4,0x0
 b44:	4ca73023          	sd	a0,1216(a4) # 1000 <freep>
      return (void*)(p + 1);
 b48:	01078513          	addi	a0,a5,16
  }
}
 b4c:	70e2                	ld	ra,56(sp)
 b4e:	7442                	ld	s0,48(sp)
 b50:	7902                	ld	s2,32(sp)
 b52:	69e2                	ld	s3,24(sp)
 b54:	6121                	addi	sp,sp,64
 b56:	8082                	ret
 b58:	74a2                	ld	s1,40(sp)
 b5a:	6a42                	ld	s4,16(sp)
 b5c:	6aa2                	ld	s5,8(sp)
 b5e:	6b02                	ld	s6,0(sp)
 b60:	b7f5                	j	b4c <malloc+0xdc>
