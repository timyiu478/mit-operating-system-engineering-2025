
user/_nettest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <txone>:
// this packet, and you can also see what
// happened with tcpdump -XXnr packets.pcap
//
void
txone()
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	1000                	addi	s0,sp,32
  printf("txone: sending one packet\n");
       8:	00002517          	auipc	a0,0x2
       c:	f9850513          	addi	a0,a0,-104 # 1fa0 <malloc+0xfe>
      10:	5db010ef          	jal	1dea <printf>
  uint32 dst = 0x0A000202; // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  buf[0] = 't';
      14:	07400793          	li	a5,116
      18:	fef40423          	sb	a5,-24(s0)
  buf[1] = 'x';
      1c:	07800793          	li	a5,120
      20:	fef404a3          	sb	a5,-23(s0)
  buf[2] = 'o';
      24:	06f00793          	li	a5,111
      28:	fef40523          	sb	a5,-22(s0)
  buf[3] = 'n';
      2c:	06e00793          	li	a5,110
      30:	fef405a3          	sb	a5,-21(s0)
  buf[4] = 'e';
      34:	06500793          	li	a5,101
      38:	fef40623          	sb	a5,-20(s0)
  if(send(2003, dst, dport, buf, 5) < 0){
      3c:	4715                	li	a4,5
      3e:	fe840693          	addi	a3,s0,-24
      42:	6619                	lui	a2,0x6
      44:	40060613          	addi	a2,a2,1024 # 6400 <base+0x31f0>
      48:	0a0005b7          	lui	a1,0xa000
      4c:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
      50:	7d300513          	li	a0,2003
      54:	1cb010ef          	jal	1a1e <send>
      58:	00054663          	bltz	a0,64 <txone+0x64>
    printf("txone: send() failed\n");
  }
}
      5c:	60e2                	ld	ra,24(sp)
      5e:	6442                	ld	s0,16(sp)
      60:	6105                	addi	sp,sp,32
      62:	8082                	ret
    printf("txone: send() failed\n");
      64:	00002517          	auipc	a0,0x2
      68:	f5c50513          	addi	a0,a0,-164 # 1fc0 <malloc+0x11e>
      6c:	57f010ef          	jal	1dea <printf>
}
      70:	b7f5                	j	5c <txone+0x5c>

0000000000000072 <rx>:
// outside of qemu, run
//   ./nettest.py rx
//
int
rx(char *name)
{
      72:	7151                	addi	sp,sp,-240
      74:	f586                	sd	ra,232(sp)
      76:	f1a2                	sd	s0,224(sp)
      78:	eda6                	sd	s1,216(sp)
      7a:	e9ca                	sd	s2,208(sp)
      7c:	e5ce                	sd	s3,200(sp)
      7e:	e1d2                	sd	s4,192(sp)
      80:	fd56                	sd	s5,184(sp)
      82:	f95a                	sd	s6,176(sp)
      84:	f55e                	sd	s7,168(sp)
      86:	f162                	sd	s8,160(sp)
      88:	ed66                	sd	s9,152(sp)
      8a:	1980                	addi	s0,sp,240
      8c:	8caa                	mv	s9,a0
  bind(2000);
      8e:	7d000513          	li	a0,2000
      92:	17d010ef          	jal	1a0e <bind>
      96:	4a91                	li	s5,4

  int lastseq = -1;
      98:	5a7d                	li	s4,-1

  while(ok < 4){
    char ibuf[128];
    uint32 src;
    uint16 sport;
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
      9a:	f2040993          	addi	s3,s0,-224
      9e:	f1a40b93          	addi	s7,s0,-230
      a2:	f1c40b13          	addi	s6,s0,-228
    if(cc < 0){
      fprintf(2, "nettest %s: recv() failed\n", name);
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
      a6:	0a000937          	lui	s2,0xa000
      aa:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffcff2>
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
      ae:	07f00713          	li	a4,127
      b2:	86ce                	mv	a3,s3
      b4:	865e                	mv	a2,s7
      b6:	85da                	mv	a1,s6
      b8:	7d000513          	li	a0,2000
      bc:	16b010ef          	jal	1a26 <recv>
      c0:	84aa                	mv	s1,a0
    if(cc < 0){
      c2:	10054763          	bltz	a0,1d0 <rx+0x15e>
    if(src != 0x0A000202){ // 10.0.2.2
      c6:	f1c42583          	lw	a1,-228(s0)
      ca:	11259c63          	bne	a1,s2,1e2 <rx+0x170>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("packet 1")){
      ce:	00002517          	auipc	a0,0x2
      d2:	f4250513          	addi	a0,a0,-190 # 2010 <malloc+0x16e>
      d6:	642010ef          	jal	1718 <strlen>
      da:	10a4eb63          	bltu	s1,a0,1f0 <rx+0x17e>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("packet xxxxxx")){
      de:	00002517          	auipc	a0,0x2
      e2:	f5a50513          	addi	a0,a0,-166 # 2038 <malloc+0x196>
      e6:	632010ef          	jal	1718 <strlen>
      ea:	10956b63          	bltu	a0,s1,200 <rx+0x18e>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "packet ", strlen("packet ")) != 0){
      ee:	00002517          	auipc	a0,0x2
      f2:	f7250513          	addi	a0,a0,-142 # 2060 <malloc+0x1be>
      f6:	622010ef          	jal	1718 <strlen>
      fa:	862a                	mv	a2,a0
      fc:	00002597          	auipc	a1,0x2
     100:	f6458593          	addi	a1,a1,-156 # 2060 <malloc+0x1be>
     104:	854e                	mv	a0,s3
     106:	7e6010ef          	jal	18ec <memcmp>
     10a:	10051363          	bnez	a0,210 <rx+0x19e>
      printf("packet doesn't start with packet\n");
      return 0;
    }

    ibuf[cc] = '\0';
     10e:	fb048793          	addi	a5,s1,-80
     112:	ff040713          	addi	a4,s0,-16
     116:	97ba                	add	a5,a5,a4
     118:	f8078023          	sb	zero,-128(a5)
#define isdigit(x) ((x) >= '0' && (x) <= '9')
    if(!isdigit(ibuf[7])){
     11c:	f2744583          	lbu	a1,-217(s0)
     120:	fd05879b          	addiw	a5,a1,-48
     124:	0ff7f793          	zext.b	a5,a5
     128:	4725                	li	a4,9
     12a:	0ef76a63          	bltu	a4,a5,21e <rx+0x1ac>
      printf("packet doesn't contain a number\n");
      return 0;
    }
    for(int i = 7; i < cc; i++){
     12e:	479d                	li	a5,7
     130:	0297d663          	bge	a5,s1,15c <rx+0xea>
     134:	f2740713          	addi	a4,s0,-217
     138:	34e1                	addiw	s1,s1,-8
     13a:	1482                	slli	s1,s1,0x20
     13c:	9081                	srli	s1,s1,0x20
     13e:	f2840693          	addi	a3,s0,-216
     142:	96a6                	add	a3,a3,s1
      if(!isdigit(ibuf[i])){
     144:	4625                	li	a2,9
     146:	00074783          	lbu	a5,0(a4)
     14a:	fd07879b          	addiw	a5,a5,-48
     14e:	0ff7f793          	zext.b	a5,a5
     152:	0cf66d63          	bltu	a2,a5,22c <rx+0x1ba>
    for(int i = 7; i < cc; i++){
     156:	0705                	addi	a4,a4,1
     158:	fed717e3          	bne	a4,a3,146 <rx+0xd4>
        printf("packet contains non-digits in the number\n");
        return 0;
      }
    }
    int seq = ibuf[7] - '0';
     15c:	fd05859b          	addiw	a1,a1,-48
     160:	872e                	mv	a4,a1
    if(isdigit(ibuf[8])){
     162:	f2844783          	lbu	a5,-216(s0)
     166:	fd07869b          	addiw	a3,a5,-48
     16a:	0ff6f693          	zext.b	a3,a3
     16e:	4625                	li	a2,9
     170:	02d66c63          	bltu	a2,a3,1a8 <rx+0x136>
      seq *= 10;
     174:	0025971b          	slliw	a4,a1,0x2
     178:	9f2d                	addw	a4,a4,a1
     17a:	0017171b          	slliw	a4,a4,0x1
      seq += ibuf[8] - '0';
     17e:	fd07879b          	addiw	a5,a5,-48
     182:	9fb9                	addw	a5,a5,a4
     184:	873e                	mv	a4,a5
      if(isdigit(ibuf[9])){
     186:	f2944603          	lbu	a2,-215(s0)
     18a:	fd06069b          	addiw	a3,a2,-48
     18e:	0ff6f693          	zext.b	a3,a3
     192:	45a5                	li	a1,9
     194:	00d5ea63          	bltu	a1,a3,1a8 <rx+0x136>
        seq *= 10;
     198:	0027971b          	slliw	a4,a5,0x2
     19c:	9f3d                	addw	a4,a4,a5
     19e:	0017171b          	slliw	a4,a4,0x1
        seq += ibuf[9] - '0';
     1a2:	fd06061b          	addiw	a2,a2,-48
     1a6:	9f31                	addw	a4,a4,a2
      }
    }

    if(lastseq != -1){
     1a8:	57fd                	li	a5,-1
     1aa:	00fa0563          	beq	s4,a5,1b4 <rx+0x142>
      if(seq != lastseq + 1){
     1ae:	2a05                	addiw	s4,s4,1
     1b0:	0aea1263          	bne	s4,a4,254 <rx+0x1e2>
  while(ok < 4){
     1b4:	3afd                	addiw	s5,s5,-1
     1b6:	000a9b63          	bnez	s5,1cc <rx+0x15a>
    lastseq = seq;
    
    ok += 1;
  }

  printf("%s: OK\n", name);
     1ba:	85e6                	mv	a1,s9
     1bc:	00002517          	auipc	a0,0x2
     1c0:	f4c50513          	addi	a0,a0,-180 # 2108 <malloc+0x266>
     1c4:	427010ef          	jal	1dea <printf>

  return 1;
     1c8:	4505                	li	a0,1
     1ca:	a885                	j	23a <rx+0x1c8>
     1cc:	8a3a                	mv	s4,a4
     1ce:	b5c5                	j	ae <rx+0x3c>
      fprintf(2, "nettest %s: recv() failed\n", name);
     1d0:	8666                	mv	a2,s9
     1d2:	00002597          	auipc	a1,0x2
     1d6:	e0658593          	addi	a1,a1,-506 # 1fd8 <malloc+0x136>
     1da:	4509                	li	a0,2
     1dc:	3e5010ef          	jal	1dc0 <fprintf>
      return 0;
     1e0:	a8a1                	j	238 <rx+0x1c6>
      printf("wrong ip src %x\n", src);
     1e2:	00002517          	auipc	a0,0x2
     1e6:	e1650513          	addi	a0,a0,-490 # 1ff8 <malloc+0x156>
     1ea:	401010ef          	jal	1dea <printf>
      return 0;
     1ee:	a0a9                	j	238 <rx+0x1c6>
      printf("len %d too short\n", cc);
     1f0:	85a6                	mv	a1,s1
     1f2:	00002517          	auipc	a0,0x2
     1f6:	e2e50513          	addi	a0,a0,-466 # 2020 <malloc+0x17e>
     1fa:	3f1010ef          	jal	1dea <printf>
      return 0;
     1fe:	a82d                	j	238 <rx+0x1c6>
      printf("len %d too long\n", cc);
     200:	85a6                	mv	a1,s1
     202:	00002517          	auipc	a0,0x2
     206:	e4650513          	addi	a0,a0,-442 # 2048 <malloc+0x1a6>
     20a:	3e1010ef          	jal	1dea <printf>
      return 0;
     20e:	a02d                	j	238 <rx+0x1c6>
      printf("packet doesn't start with packet\n");
     210:	00002517          	auipc	a0,0x2
     214:	e5850513          	addi	a0,a0,-424 # 2068 <malloc+0x1c6>
     218:	3d3010ef          	jal	1dea <printf>
      return 0;
     21c:	a831                	j	238 <rx+0x1c6>
      printf("packet doesn't contain a number\n");
     21e:	00002517          	auipc	a0,0x2
     222:	e7250513          	addi	a0,a0,-398 # 2090 <malloc+0x1ee>
     226:	3c5010ef          	jal	1dea <printf>
      return 0;
     22a:	a039                	j	238 <rx+0x1c6>
        printf("packet contains non-digits in the number\n");
     22c:	00002517          	auipc	a0,0x2
     230:	e8c50513          	addi	a0,a0,-372 # 20b8 <malloc+0x216>
     234:	3b7010ef          	jal	1dea <printf>
      return 0;
     238:	4501                	li	a0,0
}
     23a:	70ae                	ld	ra,232(sp)
     23c:	740e                	ld	s0,224(sp)
     23e:	64ee                	ld	s1,216(sp)
     240:	694e                	ld	s2,208(sp)
     242:	69ae                	ld	s3,200(sp)
     244:	6a0e                	ld	s4,192(sp)
     246:	7aea                	ld	s5,184(sp)
     248:	7b4a                	ld	s6,176(sp)
     24a:	7baa                	ld	s7,168(sp)
     24c:	7c0a                	ld	s8,160(sp)
     24e:	6cea                	ld	s9,152(sp)
     250:	616d                	addi	sp,sp,240
     252:	8082                	ret
        printf("got seq %d, expecting %d\n", seq, lastseq + 1);
     254:	8652                	mv	a2,s4
     256:	85ba                	mv	a1,a4
     258:	00002517          	auipc	a0,0x2
     25c:	e9050513          	addi	a0,a0,-368 # 20e8 <malloc+0x246>
     260:	38b010ef          	jal	1dea <printf>
        return 0;
     264:	bfd1                	j	238 <rx+0x1c6>

0000000000000266 <rx2>:
// outside of qemu, run
//   ./nettest.py rx2
//
int
rx2()
{
     266:	7111                	addi	sp,sp,-256
     268:	fd86                	sd	ra,248(sp)
     26a:	f9a2                	sd	s0,240(sp)
     26c:	f5a6                	sd	s1,232(sp)
     26e:	f1ca                	sd	s2,224(sp)
     270:	edce                	sd	s3,216(sp)
     272:	e9d2                	sd	s4,208(sp)
     274:	e5d6                	sd	s5,200(sp)
     276:	e1da                	sd	s6,192(sp)
     278:	fd5e                	sd	s7,184(sp)
     27a:	f962                	sd	s8,176(sp)
     27c:	f566                	sd	s9,168(sp)
     27e:	f16a                	sd	s10,160(sp)
     280:	0200                	addi	s0,sp,256
  bind(2000);
     282:	7d000513          	li	a0,2000
     286:	788010ef          	jal	1a0e <bind>
  bind(2001);
     28a:	7d100513          	li	a0,2001
     28e:	780010ef          	jal	1a0e <bind>
     292:	490d                	li	s2,3

  for(int i = 0; i < 3; i++){
    char ibuf[128];
    uint32 src;
    uint16 sport;
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     294:	f1040993          	addi	s3,s0,-240
     298:	f0a40c93          	addi	s9,s0,-246
     29c:	f0c40c13          	addi	s8,s0,-244
     2a0:	07f00b93          	li	s7,127
     2a4:	7d000b13          	li	s6,2000
    if(cc < 0){
      fprintf(2, "nettest rx2: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     2a8:	0a000ab7          	lui	s5,0xa000
     2ac:	202a8a93          	addi	s5,s5,514 # a000202 <base+0x9ffcff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("one 1")){
     2b0:	00002d17          	auipc	s10,0x2
     2b4:	e80d0d13          	addi	s10,s10,-384 # 2130 <malloc+0x28e>
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     2b8:	875e                	mv	a4,s7
     2ba:	86ce                	mv	a3,s3
     2bc:	8666                	mv	a2,s9
     2be:	85e2                	mv	a1,s8
     2c0:	855a                	mv	a0,s6
     2c2:	764010ef          	jal	1a26 <recv>
     2c6:	84aa                	mv	s1,a0
    if(cc < 0){
     2c8:	18054263          	bltz	a0,44c <rx2+0x1e6>
    if(src != 0x0A000202){ // 10.0.2.2
     2cc:	f0c42583          	lw	a1,-244(s0)
     2d0:	19559763          	bne	a1,s5,45e <rx2+0x1f8>
    if(cc < strlen("one 1")){
     2d4:	856a                	mv	a0,s10
     2d6:	442010ef          	jal	1718 <strlen>
     2da:	18a4e963          	bltu	s1,a0,46c <rx2+0x206>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("one xxxxxx")){
     2de:	00002517          	auipc	a0,0x2
     2e2:	e5a50513          	addi	a0,a0,-422 # 2138 <malloc+0x296>
     2e6:	432010ef          	jal	1718 <strlen>
     2ea:	18956963          	bltu	a0,s1,47c <rx2+0x216>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "one ", strlen("one ")) != 0){
     2ee:	00002517          	auipc	a0,0x2
     2f2:	e5a50513          	addi	a0,a0,-422 # 2148 <malloc+0x2a6>
     2f6:	422010ef          	jal	1718 <strlen>
     2fa:	862a                	mv	a2,a0
     2fc:	00002597          	auipc	a1,0x2
     300:	e4c58593          	addi	a1,a1,-436 # 2148 <malloc+0x2a6>
     304:	854e                	mv	a0,s3
     306:	5e6010ef          	jal	18ec <memcmp>
     30a:	8a2a                	mv	s4,a0
     30c:	18051063          	bnez	a0,48c <rx2+0x226>
  for(int i = 0; i < 3; i++){
     310:	397d                	addiw	s2,s2,-1
     312:	fa0913e3          	bnez	s2,2b8 <rx2+0x52>
     316:	ed6e                	sd	s11,152(sp)
     318:	498d                	li	s3,3

  for(int i = 0; i < 3; i++){
    char ibuf[128];
    uint32 src;
    uint16 sport;
    int cc = recv(2001, &src, &sport, ibuf, sizeof(ibuf)-1);
     31a:	f1040a93          	addi	s5,s0,-240
     31e:	f0a40d13          	addi	s10,s0,-246
     322:	f0c40c93          	addi	s9,s0,-244
     326:	07f00c13          	li	s8,127
     32a:	7d100b93          	li	s7,2001
    if(cc < 0){
      fprintf(2, "nettest rx2: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     32e:	0a000b37          	lui	s6,0xa000
     332:	202b0b13          	addi	s6,s6,514 # a000202 <base+0x9ffcff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("one 1")){
     336:	00002d97          	auipc	s11,0x2
     33a:	dfad8d93          	addi	s11,s11,-518 # 2130 <malloc+0x28e>
    int cc = recv(2001, &src, &sport, ibuf, sizeof(ibuf)-1);
     33e:	8762                	mv	a4,s8
     340:	86d6                	mv	a3,s5
     342:	866a                	mv	a2,s10
     344:	85e6                	mv	a1,s9
     346:	855e                	mv	a0,s7
     348:	6de010ef          	jal	1a26 <recv>
     34c:	84aa                	mv	s1,a0
    if(cc < 0){
     34e:	14054663          	bltz	a0,49a <rx2+0x234>
    if(src != 0x0A000202){ // 10.0.2.2
     352:	f0c42583          	lw	a1,-244(s0)
     356:	15659b63          	bne	a1,s6,4ac <rx2+0x246>
    if(cc < strlen("one 1")){
     35a:	856e                	mv	a0,s11
     35c:	3bc010ef          	jal	1718 <strlen>
     360:	14a4ee63          	bltu	s1,a0,4bc <rx2+0x256>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("one xxxxxx")){
     364:	00002517          	auipc	a0,0x2
     368:	dd450513          	addi	a0,a0,-556 # 2138 <malloc+0x296>
     36c:	3ac010ef          	jal	1718 <strlen>
     370:	14956f63          	bltu	a0,s1,4ce <rx2+0x268>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "two ", strlen("two ")) != 0){
     374:	00002517          	auipc	a0,0x2
     378:	dfc50513          	addi	a0,a0,-516 # 2170 <malloc+0x2ce>
     37c:	39c010ef          	jal	1718 <strlen>
     380:	862a                	mv	a2,a0
     382:	00002597          	auipc	a1,0x2
     386:	dee58593          	addi	a1,a1,-530 # 2170 <malloc+0x2ce>
     38a:	8556                	mv	a0,s5
     38c:	560010ef          	jal	18ec <memcmp>
     390:	892a                	mv	s2,a0
     392:	14051763          	bnez	a0,4e0 <rx2+0x27a>
  for(int i = 0; i < 3; i++){
     396:	39fd                	addiw	s3,s3,-1
     398:	fa0993e3          	bnez	s3,33e <rx2+0xd8>
     39c:	498d                	li	s3,3

  for(int i = 0; i < 3; i++){
    char ibuf[128];
    uint32 src;
    uint16 sport;
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     39e:	f1040a13          	addi	s4,s0,-240
     3a2:	f0a40c93          	addi	s9,s0,-246
     3a6:	f0c40c13          	addi	s8,s0,-244
     3aa:	07f00b93          	li	s7,127
     3ae:	7d000b13          	li	s6,2000
    if(cc < 0){
      fprintf(2, "nettest rx2: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     3b2:	0a000ab7          	lui	s5,0xa000
     3b6:	202a8a93          	addi	s5,s5,514 # a000202 <base+0x9ffcff2>
      printf("wrong ip src %x\n", src);
      return 0;
    }

    if(cc < strlen("one 1")){
     3ba:	00002d17          	auipc	s10,0x2
     3be:	d76d0d13          	addi	s10,s10,-650 # 2130 <malloc+0x28e>
    int cc = recv(2000, &src, &sport, ibuf, sizeof(ibuf)-1);
     3c2:	875e                	mv	a4,s7
     3c4:	86d2                	mv	a3,s4
     3c6:	8666                	mv	a2,s9
     3c8:	85e2                	mv	a1,s8
     3ca:	855a                	mv	a0,s6
     3cc:	65a010ef          	jal	1a26 <recv>
     3d0:	84aa                	mv	s1,a0
    if(cc < 0){
     3d2:	10054f63          	bltz	a0,4f0 <rx2+0x28a>
    if(src != 0x0A000202){ // 10.0.2.2
     3d6:	f0c42583          	lw	a1,-244(s0)
     3da:	13559563          	bne	a1,s5,504 <rx2+0x29e>
    if(cc < strlen("one 1")){
     3de:	856a                	mv	a0,s10
     3e0:	338010ef          	jal	1718 <strlen>
     3e4:	12a4e763          	bltu	s1,a0,512 <rx2+0x2ac>
      printf("len %d too short\n", cc);
      return 0;
    }

    if(cc > strlen("one xxxxxx")){
     3e8:	00002517          	auipc	a0,0x2
     3ec:	d5050513          	addi	a0,a0,-688 # 2138 <malloc+0x296>
     3f0:	328010ef          	jal	1718 <strlen>
     3f4:	12956763          	bltu	a0,s1,522 <rx2+0x2bc>
      printf("len %d too long\n", cc);
      return 0;
    }

    if(memcmp(ibuf, "one ", strlen("one ")) != 0){
     3f8:	00002517          	auipc	a0,0x2
     3fc:	d5050513          	addi	a0,a0,-688 # 2148 <malloc+0x2a6>
     400:	318010ef          	jal	1718 <strlen>
     404:	862a                	mv	a2,a0
     406:	00002597          	auipc	a1,0x2
     40a:	d4258593          	addi	a1,a1,-702 # 2148 <malloc+0x2a6>
     40e:	8552                	mv	a0,s4
     410:	4dc010ef          	jal	18ec <memcmp>
     414:	10051f63          	bnez	a0,532 <rx2+0x2cc>
  for(int i = 0; i < 3; i++){
     418:	39fd                	addiw	s3,s3,-1
     41a:	fa0994e3          	bnez	s3,3c2 <rx2+0x15c>
      printf("packet doesn't start with one\n");
      return 0;
    }
  }

  printf("rx2: OK\n");
     41e:	00002517          	auipc	a0,0x2
     422:	d7a50513          	addi	a0,a0,-646 # 2198 <malloc+0x2f6>
     426:	1c5010ef          	jal	1dea <printf>

  return 1;
     42a:	4a05                	li	s4,1
     42c:	6dea                	ld	s11,152(sp)
}
     42e:	8552                	mv	a0,s4
     430:	70ee                	ld	ra,248(sp)
     432:	744e                	ld	s0,240(sp)
     434:	74ae                	ld	s1,232(sp)
     436:	790e                	ld	s2,224(sp)
     438:	69ee                	ld	s3,216(sp)
     43a:	6a4e                	ld	s4,208(sp)
     43c:	6aae                	ld	s5,200(sp)
     43e:	6b0e                	ld	s6,192(sp)
     440:	7bea                	ld	s7,184(sp)
     442:	7c4a                	ld	s8,176(sp)
     444:	7caa                	ld	s9,168(sp)
     446:	7d0a                	ld	s10,160(sp)
     448:	6111                	addi	sp,sp,256
     44a:	8082                	ret
      fprintf(2, "nettest rx2: recv() failed\n");
     44c:	00002597          	auipc	a1,0x2
     450:	cc458593          	addi	a1,a1,-828 # 2110 <malloc+0x26e>
     454:	4509                	li	a0,2
     456:	16b010ef          	jal	1dc0 <fprintf>
      return 0;
     45a:	4a01                	li	s4,0
     45c:	bfc9                	j	42e <rx2+0x1c8>
      printf("wrong ip src %x\n", src);
     45e:	00002517          	auipc	a0,0x2
     462:	b9a50513          	addi	a0,a0,-1126 # 1ff8 <malloc+0x156>
     466:	185010ef          	jal	1dea <printf>
      return 0;
     46a:	bfc5                	j	45a <rx2+0x1f4>
      printf("len %d too short\n", cc);
     46c:	85a6                	mv	a1,s1
     46e:	00002517          	auipc	a0,0x2
     472:	bb250513          	addi	a0,a0,-1102 # 2020 <malloc+0x17e>
     476:	175010ef          	jal	1dea <printf>
      return 0;
     47a:	b7c5                	j	45a <rx2+0x1f4>
      printf("len %d too long\n", cc);
     47c:	85a6                	mv	a1,s1
     47e:	00002517          	auipc	a0,0x2
     482:	bca50513          	addi	a0,a0,-1078 # 2048 <malloc+0x1a6>
     486:	165010ef          	jal	1dea <printf>
      return 0;
     48a:	bfc1                	j	45a <rx2+0x1f4>
      printf("packet doesn't start with one\n");
     48c:	00002517          	auipc	a0,0x2
     490:	cc450513          	addi	a0,a0,-828 # 2150 <malloc+0x2ae>
     494:	157010ef          	jal	1dea <printf>
      return 0;
     498:	b7c9                	j	45a <rx2+0x1f4>
      fprintf(2, "nettest rx2: recv() failed\n");
     49a:	00002597          	auipc	a1,0x2
     49e:	c7658593          	addi	a1,a1,-906 # 2110 <malloc+0x26e>
     4a2:	4509                	li	a0,2
     4a4:	11d010ef          	jal	1dc0 <fprintf>
      return 0;
     4a8:	6dea                	ld	s11,152(sp)
     4aa:	b751                	j	42e <rx2+0x1c8>
      printf("wrong ip src %x\n", src);
     4ac:	00002517          	auipc	a0,0x2
     4b0:	b4c50513          	addi	a0,a0,-1204 # 1ff8 <malloc+0x156>
     4b4:	137010ef          	jal	1dea <printf>
      return 0;
     4b8:	6dea                	ld	s11,152(sp)
     4ba:	bf95                	j	42e <rx2+0x1c8>
      printf("len %d too short\n", cc);
     4bc:	85a6                	mv	a1,s1
     4be:	00002517          	auipc	a0,0x2
     4c2:	b6250513          	addi	a0,a0,-1182 # 2020 <malloc+0x17e>
     4c6:	125010ef          	jal	1dea <printf>
      return 0;
     4ca:	6dea                	ld	s11,152(sp)
     4cc:	b78d                	j	42e <rx2+0x1c8>
      printf("len %d too long\n", cc);
     4ce:	85a6                	mv	a1,s1
     4d0:	00002517          	auipc	a0,0x2
     4d4:	b7850513          	addi	a0,a0,-1160 # 2048 <malloc+0x1a6>
     4d8:	113010ef          	jal	1dea <printf>
      return 0;
     4dc:	6dea                	ld	s11,152(sp)
     4de:	bf81                	j	42e <rx2+0x1c8>
      printf("packet doesn't start with two\n");
     4e0:	00002517          	auipc	a0,0x2
     4e4:	c9850513          	addi	a0,a0,-872 # 2178 <malloc+0x2d6>
     4e8:	103010ef          	jal	1dea <printf>
      return 0;
     4ec:	6dea                	ld	s11,152(sp)
     4ee:	b781                	j	42e <rx2+0x1c8>
      fprintf(2, "nettest rx2: recv() failed\n");
     4f0:	00002597          	auipc	a1,0x2
     4f4:	c2058593          	addi	a1,a1,-992 # 2110 <malloc+0x26e>
     4f8:	4509                	li	a0,2
     4fa:	0c7010ef          	jal	1dc0 <fprintf>
      return 0;
     4fe:	8a4a                	mv	s4,s2
     500:	6dea                	ld	s11,152(sp)
     502:	b735                	j	42e <rx2+0x1c8>
      printf("wrong ip src %x\n", src);
     504:	00002517          	auipc	a0,0x2
     508:	af450513          	addi	a0,a0,-1292 # 1ff8 <malloc+0x156>
     50c:	0df010ef          	jal	1dea <printf>
      return 0;
     510:	b7fd                	j	4fe <rx2+0x298>
      printf("len %d too short\n", cc);
     512:	85a6                	mv	a1,s1
     514:	00002517          	auipc	a0,0x2
     518:	b0c50513          	addi	a0,a0,-1268 # 2020 <malloc+0x17e>
     51c:	0cf010ef          	jal	1dea <printf>
      return 0;
     520:	bff9                	j	4fe <rx2+0x298>
      printf("len %d too long\n", cc);
     522:	85a6                	mv	a1,s1
     524:	00002517          	auipc	a0,0x2
     528:	b2450513          	addi	a0,a0,-1244 # 2048 <malloc+0x1a6>
     52c:	0bf010ef          	jal	1dea <printf>
      return 0;
     530:	b7f9                	j	4fe <rx2+0x298>
      printf("packet doesn't start with one\n");
     532:	00002517          	auipc	a0,0x2
     536:	c1e50513          	addi	a0,a0,-994 # 2150 <malloc+0x2ae>
     53a:	0b1010ef          	jal	1dea <printf>
      return 0;
     53e:	b7c1                	j	4fe <rx2+0x298>

0000000000000540 <tx>:
//
// send some UDP packets to nettest.py tx.
//
int
tx()
{
     540:	711d                	addi	sp,sp,-96
     542:	ec86                	sd	ra,88(sp)
     544:	e8a2                	sd	s0,80(sp)
     546:	e4a6                	sd	s1,72(sp)
     548:	e0ca                	sd	s2,64(sp)
     54a:	fc4e                	sd	s3,56(sp)
     54c:	f852                	sd	s4,48(sp)
     54e:	f456                	sd	s5,40(sp)
     550:	f05a                	sd	s6,32(sp)
     552:	ec5e                	sd	s7,24(sp)
     554:	e862                	sd	s8,16(sp)
     556:	1080                	addi	s0,sp,96
     558:	03000493          	li	s1,48
  for(int ii = 0; ii < 5; ii++){
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 't';
     55c:	07400b93          	li	s7,116
    buf[1] = ' ';
     560:	02000b13          	li	s6,32
    buf[2] = '0' + ii;
    if(send(2000, dst, dport, buf, 3) < 0){
     564:	fa840a93          	addi	s5,s0,-88
     568:	4a0d                	li	s4,3
     56a:	6999                	lui	s3,0x6
     56c:	40098993          	addi	s3,s3,1024 # 6400 <base+0x31f0>
     570:	0a000937          	lui	s2,0xa000
     574:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffcff2>
     578:	7d000c13          	li	s8,2000
    buf[0] = 't';
     57c:	fb740423          	sb	s7,-88(s0)
    buf[1] = ' ';
     580:	fb6404a3          	sb	s6,-87(s0)
    buf[2] = '0' + ii;
     584:	fa940523          	sb	s1,-86(s0)
    if(send(2000, dst, dport, buf, 3) < 0){
     588:	8752                	mv	a4,s4
     58a:	86d6                	mv	a3,s5
     58c:	864e                	mv	a2,s3
     58e:	85ca                	mv	a1,s2
     590:	8562                	mv	a0,s8
     592:	48c010ef          	jal	1a1e <send>
     596:	02054963          	bltz	a0,5c8 <tx+0x88>
      printf("send() failed\n");
      return 0;
    }
    pause(10);
     59a:	4529                	li	a0,10
     59c:	462010ef          	jal	19fe <pause>
  for(int ii = 0; ii < 5; ii++){
     5a0:	2485                	addiw	s1,s1,1
     5a2:	0ff4f493          	zext.b	s1,s1
     5a6:	03500793          	li	a5,53
     5aa:	fcf499e3          	bne	s1,a5,57c <tx+0x3c>
  }

  // can't actually tell if the packets arrived.
  return 1;
     5ae:	4505                	li	a0,1
}
     5b0:	60e6                	ld	ra,88(sp)
     5b2:	6446                	ld	s0,80(sp)
     5b4:	64a6                	ld	s1,72(sp)
     5b6:	6906                	ld	s2,64(sp)
     5b8:	79e2                	ld	s3,56(sp)
     5ba:	7a42                	ld	s4,48(sp)
     5bc:	7aa2                	ld	s5,40(sp)
     5be:	7b02                	ld	s6,32(sp)
     5c0:	6be2                	ld	s7,24(sp)
     5c2:	6c42                	ld	s8,16(sp)
     5c4:	6125                	addi	sp,sp,96
     5c6:	8082                	ret
      printf("send() failed\n");
     5c8:	00002517          	auipc	a0,0x2
     5cc:	be050513          	addi	a0,a0,-1056 # 21a8 <malloc+0x306>
     5d0:	01b010ef          	jal	1dea <printf>
      return 0;
     5d4:	4501                	li	a0,0
     5d6:	bfe9                	j	5b0 <tx+0x70>

00000000000005d8 <ping0>:
// expect a reply.
// nettest.py ping must be started first.
//
int
ping0()
{
     5d8:	7171                	addi	sp,sp,-176
     5da:	f506                	sd	ra,168(sp)
     5dc:	f122                	sd	s0,160(sp)
     5de:	ed26                	sd	s1,152(sp)
     5e0:	e94a                	sd	s2,144(sp)
     5e2:	1900                	addi	s0,sp,176
  printf("ping0: starting\n");
     5e4:	00002517          	auipc	a0,0x2
     5e8:	bd450513          	addi	a0,a0,-1068 # 21b8 <malloc+0x316>
     5ec:	7fe010ef          	jal	1dea <printf>

  bind(2004);
     5f0:	7d400513          	li	a0,2004
     5f4:	41a010ef          	jal	1a0e <bind>
  
  uint32 dst = 0x0A000202; // 10.0.2.2
  int dport = NET_TESTS_PORT;
  char buf[5];
  memcpy(buf, "ping0", sizeof(buf));
     5f8:	fd840493          	addi	s1,s0,-40
     5fc:	4615                	li	a2,5
     5fe:	00002597          	auipc	a1,0x2
     602:	bd258593          	addi	a1,a1,-1070 # 21d0 <malloc+0x32e>
     606:	8526                	mv	a0,s1
     608:	31e010ef          	jal	1926 <memcpy>
  if(send(2004, dst, dport, buf, sizeof(buf)) < 0){
     60c:	4715                	li	a4,5
     60e:	86a6                	mv	a3,s1
     610:	6619                	lui	a2,0x6
     612:	40060613          	addi	a2,a2,1024 # 6400 <base+0x31f0>
     616:	0a0005b7          	lui	a1,0xa000
     61a:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
     61e:	7d400513          	li	a0,2004
     622:	3fc010ef          	jal	1a1e <send>
     626:	06054663          	bltz	a0,692 <ping0+0xba>
    printf("ping0: send() failed\n");
    return 0;
  }

  char ibuf[128];
  uint32 src = 0;
     62a:	f4042a23          	sw	zero,-172(s0)
  uint16 sport = 0;
     62e:	f4041923          	sh	zero,-174(s0)
  memset(ibuf, 0, sizeof(ibuf));
     632:	f5840493          	addi	s1,s0,-168
     636:	08000613          	li	a2,128
     63a:	4581                	li	a1,0
     63c:	8526                	mv	a0,s1
     63e:	106010ef          	jal	1744 <memset>
  int cc = recv(2004, &src, &sport, ibuf, sizeof(ibuf)-1);
     642:	07f00713          	li	a4,127
     646:	86a6                	mv	a3,s1
     648:	f5240613          	addi	a2,s0,-174
     64c:	f5440593          	addi	a1,s0,-172
     650:	7d400513          	li	a0,2004
     654:	3d2010ef          	jal	1a26 <recv>
     658:	84aa                	mv	s1,a0
  if(cc < 0){
     65a:	04054a63          	bltz	a0,6ae <ping0+0xd6>
    fprintf(2, "ping0: recv() failed\n");
    return 0;
  }
  
  if(src != 0x0A000202){ // 10.0.2.2
     65e:	f5442583          	lw	a1,-172(s0)
     662:	0a0007b7          	lui	a5,0xa000
     666:	20278793          	addi	a5,a5,514 # a000202 <base+0x9ffcff2>
     66a:	04f59b63          	bne	a1,a5,6c0 <ping0+0xe8>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
    return 0;
  }
  
  if(sport != NET_TESTS_PORT){
     66e:	f5245583          	lhu	a1,-174(s0)
     672:	0005871b          	sext.w	a4,a1
     676:	6799                	lui	a5,0x6
     678:	40078793          	addi	a5,a5,1024 # 6400 <base+0x31f0>
     67c:	04f70b63          	beq	a4,a5,6d2 <ping0+0xfa>
    printf("ping0: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
     680:	863e                	mv	a2,a5
     682:	00002517          	auipc	a0,0x2
     686:	bae50513          	addi	a0,a0,-1106 # 2230 <malloc+0x38e>
     68a:	760010ef          	jal	1dea <printf>
    return 0;
     68e:	4901                	li	s2,0
     690:	a801                	j	6a0 <ping0+0xc8>
    printf("ping0: send() failed\n");
     692:	00002517          	auipc	a0,0x2
     696:	b4650513          	addi	a0,a0,-1210 # 21d8 <malloc+0x336>
     69a:	750010ef          	jal	1dea <printf>
    return 0;
     69e:	4901                	li	s2,0
  }

  printf("ping0: OK\n");

  return 1;
}
     6a0:	854a                	mv	a0,s2
     6a2:	70aa                	ld	ra,168(sp)
     6a4:	740a                	ld	s0,160(sp)
     6a6:	64ea                	ld	s1,152(sp)
     6a8:	694a                	ld	s2,144(sp)
     6aa:	614d                	addi	sp,sp,176
     6ac:	8082                	ret
    fprintf(2, "ping0: recv() failed\n");
     6ae:	00002597          	auipc	a1,0x2
     6b2:	b4258593          	addi	a1,a1,-1214 # 21f0 <malloc+0x34e>
     6b6:	4509                	li	a0,2
     6b8:	708010ef          	jal	1dc0 <fprintf>
    return 0;
     6bc:	4901                	li	s2,0
     6be:	b7cd                	j	6a0 <ping0+0xc8>
    printf("ping0: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     6c0:	863e                	mv	a2,a5
     6c2:	00002517          	auipc	a0,0x2
     6c6:	b4650513          	addi	a0,a0,-1210 # 2208 <malloc+0x366>
     6ca:	720010ef          	jal	1dea <printf>
    return 0;
     6ce:	4901                	li	s2,0
     6d0:	bfc1                	j	6a0 <ping0+0xc8>
  if(memcmp(buf, ibuf, sizeof(buf)) != 0){
     6d2:	4615                	li	a2,5
     6d4:	f5840593          	addi	a1,s0,-168
     6d8:	fd840513          	addi	a0,s0,-40
     6dc:	210010ef          	jal	18ec <memcmp>
     6e0:	892a                	mv	s2,a0
     6e2:	ed09                	bnez	a0,6fc <ping0+0x124>
  if(cc != sizeof(buf)){
     6e4:	4795                	li	a5,5
     6e6:	02f48363          	beq	s1,a5,70c <ping0+0x134>
    printf("ping0: wrong length %d, expecting %ld\n", cc, sizeof(buf));
     6ea:	863e                	mv	a2,a5
     6ec:	85a6                	mv	a1,s1
     6ee:	00002517          	auipc	a0,0x2
     6f2:	b8250513          	addi	a0,a0,-1150 # 2270 <malloc+0x3ce>
     6f6:	6f4010ef          	jal	1dea <printf>
    return 0;
     6fa:	b75d                	j	6a0 <ping0+0xc8>
    printf("ping0: wrong content\n");
     6fc:	00002517          	auipc	a0,0x2
     700:	b5c50513          	addi	a0,a0,-1188 # 2258 <malloc+0x3b6>
     704:	6e6010ef          	jal	1dea <printf>
    return 0;
     708:	4901                	li	s2,0
     70a:	bf59                	j	6a0 <ping0+0xc8>
  printf("ping0: OK\n");
     70c:	00002517          	auipc	a0,0x2
     710:	b8c50513          	addi	a0,a0,-1140 # 2298 <malloc+0x3f6>
     714:	6d6010ef          	jal	1dea <printf>
  return 1;
     718:	4785                	li	a5,1
     71a:	893e                	mv	s2,a5
     71c:	b751                	j	6a0 <ping0+0xc8>

000000000000071e <ping1>:
// expect a reply to each.
// nettest.py ping must be started first.
//
int
ping1()
{
     71e:	7151                	addi	sp,sp,-240
     720:	f586                	sd	ra,232(sp)
     722:	f1a2                	sd	s0,224(sp)
     724:	eda6                	sd	s1,216(sp)
     726:	e9ca                	sd	s2,208(sp)
     728:	e5ce                	sd	s3,200(sp)
     72a:	e1d2                	sd	s4,192(sp)
     72c:	fd56                	sd	s5,184(sp)
     72e:	f95a                	sd	s6,176(sp)
     730:	f55e                	sd	s7,168(sp)
     732:	f162                	sd	s8,160(sp)
     734:	ed66                	sd	s9,152(sp)
     736:	1980                	addi	s0,sp,240
  printf("ping1: starting\n");
     738:	00002517          	auipc	a0,0x2
     73c:	b7050513          	addi	a0,a0,-1168 # 22a8 <malloc+0x406>
     740:	6aa010ef          	jal	1dea <printf>

  bind(2005);
     744:	7d500513          	li	a0,2005
     748:	2c6010ef          	jal	1a0e <bind>
     74c:	03000493          	li	s1,48
  
  for(int ii = 0; ii < 20; ii++){
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[3];
    buf[0] = 'p';
     750:	07000c93          	li	s9,112
    buf[1] = ' ';
     754:	02000c13          	li	s8,32
    buf[2] = '0' + ii;
    if(send(2005, dst, dport, buf, 3) < 0){
     758:	f1840b93          	addi	s7,s0,-232
     75c:	498d                	li	s3,3
     75e:	6a99                	lui	s5,0x6
     760:	400a8a93          	addi	s5,s5,1024 # 6400 <base+0x31f0>
     764:	0a000a37          	lui	s4,0xa000
     768:	202a0a13          	addi	s4,s4,514 # a000202 <base+0x9ffcff2>
     76c:	7d500b13          	li	s6,2005
    buf[0] = 'p';
     770:	f1940c23          	sb	s9,-232(s0)
    buf[1] = ' ';
     774:	f1840ca3          	sb	s8,-231(s0)
    buf[2] = '0' + ii;
     778:	f0940d23          	sb	s1,-230(s0)
    if(send(2005, dst, dport, buf, 3) < 0){
     77c:	874e                	mv	a4,s3
     77e:	86de                	mv	a3,s7
     780:	8656                	mv	a2,s5
     782:	85d2                	mv	a1,s4
     784:	855a                	mv	a0,s6
     786:	298010ef          	jal	1a1e <send>
     78a:	06054d63          	bltz	a0,804 <ping1+0xe6>
      printf("ping1: send() failed\n");
      return 0;
    }

    char ibuf[128];
    uint32 src = 0;
     78e:	f0042e23          	sw	zero,-228(s0)
    uint16 sport = 0;
     792:	f0041b23          	sh	zero,-234(s0)
    memset(ibuf, 0, sizeof(ibuf));
     796:	f2040913          	addi	s2,s0,-224
     79a:	08000613          	li	a2,128
     79e:	4581                	li	a1,0
     7a0:	854a                	mv	a0,s2
     7a2:	7a3000ef          	jal	1744 <memset>
    int cc = recv(2005, &src, &sport, ibuf, sizeof(ibuf)-1);
     7a6:	07f00713          	li	a4,127
     7aa:	86ca                	mv	a3,s2
     7ac:	f1640613          	addi	a2,s0,-234
     7b0:	f1c40593          	addi	a1,s0,-228
     7b4:	855a                	mv	a0,s6
     7b6:	270010ef          	jal	1a26 <recv>
     7ba:	892a                	mv	s2,a0
    if(cc < 0){
     7bc:	06054863          	bltz	a0,82c <ping1+0x10e>
      fprintf(2, "ping1: recv() failed\n");
      return 0;
    }

    if(src != 0x0A000202){ // 10.0.2.2
     7c0:	f1c42583          	lw	a1,-228(s0)
     7c4:	07459c63          	bne	a1,s4,83c <ping1+0x11e>
      printf("ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
      return 0;
    }

    if(sport != NET_TESTS_PORT){
     7c8:	f1645583          	lhu	a1,-234(s0)
     7cc:	0005879b          	sext.w	a5,a1
     7d0:	09579163          	bne	a5,s5,852 <ping1+0x134>
      printf("ping1: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
      return 0;
    }

    if(memcmp(buf, ibuf, 3) != 0){
     7d4:	864e                	mv	a2,s3
     7d6:	f2040593          	addi	a1,s0,-224
     7da:	855e                	mv	a0,s7
     7dc:	110010ef          	jal	18ec <memcmp>
     7e0:	e159                	bnez	a0,866 <ping1+0x148>
      printf("ping1: wrong content\n");
      return 0;
    }

    if(cc != 3){
     7e2:	09391963          	bne	s2,s3,874 <ping1+0x156>
  for(int ii = 0; ii < 20; ii++){
     7e6:	2485                	addiw	s1,s1,1
     7e8:	0ff4f493          	zext.b	s1,s1
     7ec:	04400793          	li	a5,68
     7f0:	f8f490e3          	bne	s1,a5,770 <ping1+0x52>
      printf("ping1: wrong length %d, expecting 3\n", cc);
      return 0;
    }
  }

  printf("ping1: OK\n");
     7f4:	00002517          	auipc	a0,0x2
     7f8:	b8c50513          	addi	a0,a0,-1140 # 2380 <malloc+0x4de>
     7fc:	5ee010ef          	jal	1dea <printf>

  return 1;
     800:	4505                	li	a0,1
     802:	a801                	j	812 <ping1+0xf4>
      printf("ping1: send() failed\n");
     804:	00002517          	auipc	a0,0x2
     808:	abc50513          	addi	a0,a0,-1348 # 22c0 <malloc+0x41e>
     80c:	5de010ef          	jal	1dea <printf>
      return 0;
     810:	4501                	li	a0,0
}
     812:	70ae                	ld	ra,232(sp)
     814:	740e                	ld	s0,224(sp)
     816:	64ee                	ld	s1,216(sp)
     818:	694e                	ld	s2,208(sp)
     81a:	69ae                	ld	s3,200(sp)
     81c:	6a0e                	ld	s4,192(sp)
     81e:	7aea                	ld	s5,184(sp)
     820:	7b4a                	ld	s6,176(sp)
     822:	7baa                	ld	s7,168(sp)
     824:	7c0a                	ld	s8,160(sp)
     826:	6cea                	ld	s9,152(sp)
     828:	616d                	addi	sp,sp,240
     82a:	8082                	ret
      fprintf(2, "ping1: recv() failed\n");
     82c:	00002597          	auipc	a1,0x2
     830:	aac58593          	addi	a1,a1,-1364 # 22d8 <malloc+0x436>
     834:	4509                	li	a0,2
     836:	58a010ef          	jal	1dc0 <fprintf>
      return 0;
     83a:	bfd9                	j	810 <ping1+0xf2>
      printf("ping1: wrong ip src %x, expecting %x\n", src, 0x0A000202);
     83c:	0a000637          	lui	a2,0xa000
     840:	20260613          	addi	a2,a2,514 # a000202 <base+0x9ffcff2>
     844:	00002517          	auipc	a0,0x2
     848:	aac50513          	addi	a0,a0,-1364 # 22f0 <malloc+0x44e>
     84c:	59e010ef          	jal	1dea <printf>
      return 0;
     850:	b7c1                	j	810 <ping1+0xf2>
      printf("ping1: wrong sport %d, expecting %d\n", sport, NET_TESTS_PORT);
     852:	6619                	lui	a2,0x6
     854:	40060613          	addi	a2,a2,1024 # 6400 <base+0x31f0>
     858:	00002517          	auipc	a0,0x2
     85c:	ac050513          	addi	a0,a0,-1344 # 2318 <malloc+0x476>
     860:	58a010ef          	jal	1dea <printf>
      return 0;
     864:	b775                	j	810 <ping1+0xf2>
      printf("ping1: wrong content\n");
     866:	00002517          	auipc	a0,0x2
     86a:	ada50513          	addi	a0,a0,-1318 # 2340 <malloc+0x49e>
     86e:	57c010ef          	jal	1dea <printf>
      return 0;
     872:	bf79                	j	810 <ping1+0xf2>
      printf("ping1: wrong length %d, expecting 3\n", cc);
     874:	85ca                	mv	a1,s2
     876:	00002517          	auipc	a0,0x2
     87a:	ae250513          	addi	a0,a0,-1310 # 2358 <malloc+0x4b6>
     87e:	56c010ef          	jal	1dea <printf>
      return 0;
     882:	b779                	j	810 <ping1+0xf2>

0000000000000884 <ping2>:
// expect a reply to each to appear on the correct port.
// nettest.py ping must be started first.
//
int
ping2()
{
     884:	7151                	addi	sp,sp,-240
     886:	f586                	sd	ra,232(sp)
     888:	f1a2                	sd	s0,224(sp)
     88a:	eda6                	sd	s1,216(sp)
     88c:	e9ca                	sd	s2,208(sp)
     88e:	e5ce                	sd	s3,200(sp)
     890:	e1d2                	sd	s4,192(sp)
     892:	fd56                	sd	s5,184(sp)
     894:	f95a                	sd	s6,176(sp)
     896:	f55e                	sd	s7,168(sp)
     898:	f162                	sd	s8,160(sp)
     89a:	ed66                	sd	s9,152(sp)
     89c:	1980                	addi	s0,sp,240
  printf("ping2: starting\n");
     89e:	00002517          	auipc	a0,0x2
     8a2:	af250513          	addi	a0,a0,-1294 # 2390 <malloc+0x4ee>
     8a6:	544010ef          	jal	1dea <printf>
  
  bind(2006);
     8aa:	7d600513          	li	a0,2006
     8ae:	160010ef          	jal	1a0e <bind>
  bind(2007);
     8b2:	7d700513          	li	a0,2007
     8b6:	158010ef          	jal	1a0e <bind>
  
  for(int ii = 0; ii < 5; ii++){
     8ba:	4901                	li	s2,0
    for(int port = 2006; port <= 2007; port++){
     8bc:	7d600993          	li	s3,2006
      uint32 dst = 0x0A000202; // 10.0.2.2
      int dport = NET_TESTS_PORT;
      char buf[4];
      buf[0] = 'p';
     8c0:	07000b13          	li	s6,112
      buf[1] = ' ';
     8c4:	02000a93          	li	s5,32
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
      buf[3] = '!';
     8c8:	02100c93          	li	s9,33
      if(send(port, dst, dport, buf, 4) < 0){
     8cc:	f2040c13          	addi	s8,s0,-224
     8d0:	4b91                	li	s7,4
    for(int port = 2006; port <= 2007; port++){
     8d2:	84ce                	mv	s1,s3
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     8d4:	04190a1b          	addiw	s4,s2,65
      buf[0] = 'p';
     8d8:	f3640023          	sb	s6,-224(s0)
      buf[1] = ' ';
     8dc:	f35400a3          	sb	s5,-223(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     8e0:	19348463          	beq	s1,s3,a68 <ping2+0x1e4>
     8e4:	f3440123          	sb	s4,-222(s0)
      buf[3] = '!';
     8e8:	f39401a3          	sb	s9,-221(s0)
      if(send(port, dst, dport, buf, 4) < 0){
     8ec:	875e                	mv	a4,s7
     8ee:	86e2                	mv	a3,s8
     8f0:	6619                	lui	a2,0x6
     8f2:	40060613          	addi	a2,a2,1024 # 6400 <base+0x31f0>
     8f6:	0a0005b7          	lui	a1,0xa000
     8fa:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
     8fe:	03049513          	slli	a0,s1,0x30
     902:	9141                	srli	a0,a0,0x30
     904:	11a010ef          	jal	1a1e <send>
     908:	10054163          	bltz	a0,a0a <ping2+0x186>
    for(int port = 2006; port <= 2007; port++){
     90c:	2485                	addiw	s1,s1,1
     90e:	7d800793          	li	a5,2008
     912:	fcf493e3          	bne	s1,a5,8d8 <ping2+0x54>
  for(int ii = 0; ii < 5; ii++){
     916:	2905                	addiw	s2,s2,1
     918:	4795                	li	a5,5
     91a:	faf91ce3          	bne	s2,a5,8d2 <ping2+0x4e>
     91e:	e96a                	sd	s10,144(sp)
        return 0;
      }
    }
  }

  for(int port = 2006; port <= 2007; port++){
     920:	7d600a13          	li	s4,2006
    for(int ii = 0; ii < 5; ii++){
      char ibuf[128];
      uint32 src = 0;
      uint16 sport = 0;
      memset(ibuf, 0, sizeof(ibuf));
     924:	f2040913          	addi	s2,s0,-224
     928:	08000c93          	li	s9,128
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf)-1);
     92c:	f1640c13          	addi	s8,s0,-234
     930:	f1c40b93          	addi	s7,s0,-228
      if(cc < 0){
        fprintf(2, "ping2: recv() failed\n");
        return 0;
      }
      
      if(src != 0x0A000202){ // 10.0.2.2
     934:	0a0009b7          	lui	s3,0xa000
     938:	20298993          	addi	s3,s3,514 # a000202 <base+0x9ffcff2>
    for(int ii = 0; ii < 5; ii++){
     93c:	82aa0793          	addi	a5,s4,-2006
     940:	04100493          	li	s1,65
     944:	e399                	bnez	a5,94a <ping2+0xc6>
     946:	06100493          	li	s1,97
     94a:	0ff4f493          	zext.b	s1,s1
     94e:	00548d13          	addi	s10,s1,5
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf)-1);
     952:	030a1b13          	slli	s6,s4,0x30
     956:	030b5b13          	srli	s6,s6,0x30
     95a:	07f00a93          	li	s5,127
      uint32 src = 0;
     95e:	f0042e23          	sw	zero,-228(s0)
      uint16 sport = 0;
     962:	f0041b23          	sh	zero,-234(s0)
      memset(ibuf, 0, sizeof(ibuf));
     966:	8666                	mv	a2,s9
     968:	4581                	li	a1,0
     96a:	854a                	mv	a0,s2
     96c:	5d9000ef          	jal	1744 <memset>
      int cc = recv(port, &src, &sport, ibuf, sizeof(ibuf)-1);
     970:	8756                	mv	a4,s5
     972:	86ca                	mv	a3,s2
     974:	8662                	mv	a2,s8
     976:	85de                	mv	a1,s7
     978:	855a                	mv	a0,s6
     97a:	0ac010ef          	jal	1a26 <recv>
      if(cc < 0){
     97e:	08054e63          	bltz	a0,a1a <ping2+0x196>
      if(src != 0x0A000202){ // 10.0.2.2
     982:	f1c42583          	lw	a1,-228(s0)
     986:	0b359463          	bne	a1,s3,a2e <ping2+0x1aa>
        printf("ping2: wrong ip src %x\n", src);
        return 0;
      }
      
      if(sport != NET_TESTS_PORT){
     98a:	f1645583          	lhu	a1,-234(s0)
     98e:	0005871b          	sext.w	a4,a1
     992:	6799                	lui	a5,0x6
     994:	40078793          	addi	a5,a5,1024 # 6400 <base+0x31f0>
     998:	0af71263          	bne	a4,a5,a3c <ping2+0x1b8>
        printf("ping2: wrong sport %d\n", sport);
        return 0;
      }
      
      if(cc != 4){
     99c:	4791                	li	a5,4
     99e:	0af51663          	bne	a0,a5,a4a <ping2+0x1c6>
      }

      // printf("port=%d ii=%d: %c%c%c\n", port, ii, ibuf[0], ibuf[1], ibuf[2]);

      char buf[4];
      buf[0] = 'p';
     9a2:	07000793          	li	a5,112
     9a6:	f0f40c23          	sb	a5,-232(s0)
      buf[1] = ' ';
     9aa:	02000793          	li	a5,32
     9ae:	f0f40ca3          	sb	a5,-231(s0)
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     9b2:	f0940d23          	sb	s1,-230(s0)
      buf[3] = '!';
     9b6:	02100793          	li	a5,33
     9ba:	f0f40da3          	sb	a5,-229(s0)

      if(memcmp(buf, ibuf, 3) != 0){
     9be:	460d                	li	a2,3
     9c0:	85ca                	mv	a1,s2
     9c2:	f1840513          	addi	a0,s0,-232
     9c6:	727000ef          	jal	18ec <memcmp>
     9ca:	e941                	bnez	a0,a5a <ping2+0x1d6>
    for(int ii = 0; ii < 5; ii++){
     9cc:	2485                	addiw	s1,s1,1
     9ce:	0ff4f493          	zext.b	s1,s1
     9d2:	f9a496e3          	bne	s1,s10,95e <ping2+0xda>
  for(int port = 2006; port <= 2007; port++){
     9d6:	2a05                	addiw	s4,s4,1
     9d8:	7d800793          	li	a5,2008
     9dc:	f6fa10e3          	bne	s4,a5,93c <ping2+0xb8>
        return 0;
      }
    }
  }

  printf("ping2: OK\n");
     9e0:	00002517          	auipc	a0,0x2
     9e4:	a5850513          	addi	a0,a0,-1448 # 2438 <malloc+0x596>
     9e8:	402010ef          	jal	1dea <printf>

  return 1;
     9ec:	4505                	li	a0,1
     9ee:	6d4a                	ld	s10,144(sp)
}
     9f0:	70ae                	ld	ra,232(sp)
     9f2:	740e                	ld	s0,224(sp)
     9f4:	64ee                	ld	s1,216(sp)
     9f6:	694e                	ld	s2,208(sp)
     9f8:	69ae                	ld	s3,200(sp)
     9fa:	6a0e                	ld	s4,192(sp)
     9fc:	7aea                	ld	s5,184(sp)
     9fe:	7b4a                	ld	s6,176(sp)
     a00:	7baa                	ld	s7,168(sp)
     a02:	7c0a                	ld	s8,160(sp)
     a04:	6cea                	ld	s9,152(sp)
     a06:	616d                	addi	sp,sp,240
     a08:	8082                	ret
        printf("ping2: send() failed\n");
     a0a:	00002517          	auipc	a0,0x2
     a0e:	99e50513          	addi	a0,a0,-1634 # 23a8 <malloc+0x506>
     a12:	3d8010ef          	jal	1dea <printf>
        return 0;
     a16:	4501                	li	a0,0
     a18:	bfe1                	j	9f0 <ping2+0x16c>
        fprintf(2, "ping2: recv() failed\n");
     a1a:	00002597          	auipc	a1,0x2
     a1e:	9a658593          	addi	a1,a1,-1626 # 23c0 <malloc+0x51e>
     a22:	4509                	li	a0,2
     a24:	39c010ef          	jal	1dc0 <fprintf>
        return 0;
     a28:	4501                	li	a0,0
     a2a:	6d4a                	ld	s10,144(sp)
     a2c:	b7d1                	j	9f0 <ping2+0x16c>
        printf("ping2: wrong ip src %x\n", src);
     a2e:	00002517          	auipc	a0,0x2
     a32:	9aa50513          	addi	a0,a0,-1622 # 23d8 <malloc+0x536>
     a36:	3b4010ef          	jal	1dea <printf>
        return 0;
     a3a:	b7fd                	j	a28 <ping2+0x1a4>
        printf("ping2: wrong sport %d\n", sport);
     a3c:	00002517          	auipc	a0,0x2
     a40:	9b450513          	addi	a0,a0,-1612 # 23f0 <malloc+0x54e>
     a44:	3a6010ef          	jal	1dea <printf>
        return 0;
     a48:	b7c5                	j	a28 <ping2+0x1a4>
        printf("ping2: wrong length %d\n", cc);
     a4a:	85aa                	mv	a1,a0
     a4c:	00002517          	auipc	a0,0x2
     a50:	9bc50513          	addi	a0,a0,-1604 # 2408 <malloc+0x566>
     a54:	396010ef          	jal	1dea <printf>
        return 0;
     a58:	bfc1                	j	a28 <ping2+0x1a4>
        printf("ping2: wrong content\n");
     a5a:	00002517          	auipc	a0,0x2
     a5e:	9c650513          	addi	a0,a0,-1594 # 2420 <malloc+0x57e>
     a62:	388010ef          	jal	1dea <printf>
        return 0;
     a66:	b7c9                	j	a28 <ping2+0x1a4>
      buf[2] = (port == 2006 ? 'a' : 'A') + ii;
     a68:	0619079b          	addiw	a5,s2,97
     a6c:	f2f40123          	sb	a5,-222(s0)
      buf[3] = '!';
     a70:	f39401a3          	sb	s9,-221(s0)
      if(send(port, dst, dport, buf, 4) < 0){
     a74:	875e                	mv	a4,s7
     a76:	86e2                	mv	a3,s8
     a78:	6619                	lui	a2,0x6
     a7a:	40060613          	addi	a2,a2,1024 # 6400 <base+0x31f0>
     a7e:	0a0005b7          	lui	a1,0xa000
     a82:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
     a86:	03049513          	slli	a0,s1,0x30
     a8a:	9141                	srli	a0,a0,0x30
     a8c:	793000ef          	jal	1a1e <send>
     a90:	f6054de3          	bltz	a0,a0a <ping2+0x186>
    for(int port = 2006; port <= 2007; port++){
     a94:	2485                	addiw	s1,s1,1
     a96:	b589                	j	8d8 <ping2+0x54>

0000000000000a98 <ping3>:
// check that port 2008 had a finite queue length (dropped some).
// nettest.py ping must be started first.
//
int
ping3()
{
     a98:	7151                	addi	sp,sp,-240
     a9a:	f586                	sd	ra,232(sp)
     a9c:	f1a2                	sd	s0,224(sp)
     a9e:	eda6                	sd	s1,216(sp)
     aa0:	1980                	addi	s0,sp,240
  printf("ping3: starting\n");
     aa2:	00002517          	auipc	a0,0x2
     aa6:	9a650513          	addi	a0,a0,-1626 # 2448 <malloc+0x5a6>
     aaa:	340010ef          	jal	1dea <printf>
  
  bind(2008);
     aae:	7d800513          	li	a0,2008
     ab2:	75d000ef          	jal	1a0e <bind>
  bind(2009);
     ab6:	7d900513          	li	a0,2009
     aba:	755000ef          	jal	1a0e <bind>
  //
  {
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     abe:	07000793          	li	a5,112
     ac2:	f2f40423          	sb	a5,-216(s0)
    buf[1] = ' ';
     ac6:	02000793          	li	a5,32
     aca:	f2f404a3          	sb	a5,-215(s0)
    buf[2] = 'A';
     ace:	04100793          	li	a5,65
     ad2:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '!';
     ad6:	02100793          	li	a5,33
     ada:	f2f405a3          	sb	a5,-213(s0)
    if(send(2009, dst, dport, buf, 4) < 0){
     ade:	4711                	li	a4,4
     ae0:	f2840693          	addi	a3,s0,-216
     ae4:	6619                	lui	a2,0x6
     ae6:	40060613          	addi	a2,a2,1024 # 6400 <base+0x31f0>
     aea:	0a0005b7          	lui	a1,0xa000
     aee:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
     af2:	7d900513          	li	a0,2009
     af6:	729000ef          	jal	1a1e <send>
     afa:	1c054b63          	bltz	a0,cd0 <ping3+0x238>
     afe:	e9ca                	sd	s2,208(sp)
     b00:	e5ce                	sd	s3,200(sp)
     b02:	e1d2                	sd	s4,192(sp)
     b04:	fd56                	sd	s5,184(sp)
     b06:	f95a                	sd	s6,176(sp)
     b08:	f55e                	sd	s7,168(sp)
     b0a:	f162                	sd	s8,160(sp)
      printf("ping3: send() failed\n");
      return 0;
    }
  }
  pause(1);
     b0c:	4505                	li	a0,1
     b0e:	6f1000ef          	jal	19fe <pause>
  //
  // send so many packets from 2008 and 2010 that some of the
  // replies must be dropped due to the requirement
  // for finite maximum queueing.
  //
  for(int ii = 0; ii < 257; ii++){
     b12:	4481                	li	s1,0
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     b14:	07000c13          	li	s8,112
    buf[1] = ' ';
     b18:	02000b93          	li	s7,32
    buf[2] = 'a' + ii;
    buf[3] = '!';
     b1c:	02100b13          	li	s6,33
    int port = 2008 + (ii % 2) * 2;
    if(send(port, dst, dport, buf, 4) < 0){
     b20:	f2840a93          	addi	s5,s0,-216
     b24:	4a11                	li	s4,4
     b26:	6999                	lui	s3,0x6
     b28:	40098993          	addi	s3,s3,1024 # 6400 <base+0x31f0>
     b2c:	0a000937          	lui	s2,0xa000
     b30:	20290913          	addi	s2,s2,514 # a000202 <base+0x9ffcff2>
    buf[0] = 'p';
     b34:	f3840423          	sb	s8,-216(s0)
    buf[1] = ' ';
     b38:	f37404a3          	sb	s7,-215(s0)
    buf[2] = 'a' + ii;
     b3c:	0614879b          	addiw	a5,s1,97
     b40:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '!';
     b44:	f36405a3          	sb	s6,-213(s0)
    int port = 2008 + (ii % 2) * 2;
     b48:	41f4d79b          	sraiw	a5,s1,0x1f
     b4c:	01f7d79b          	srliw	a5,a5,0x1f
     b50:	0097853b          	addw	a0,a5,s1
     b54:	8905                	andi	a0,a0,1
     b56:	9d1d                	subw	a0,a0,a5
     b58:	0506                	slli	a0,a0,0x1
     b5a:	7d85051b          	addiw	a0,a0,2008
    if(send(port, dst, dport, buf, 4) < 0){
     b5e:	1542                	slli	a0,a0,0x30
     b60:	9141                	srli	a0,a0,0x30
     b62:	8752                	mv	a4,s4
     b64:	86d6                	mv	a3,s5
     b66:	864e                	mv	a2,s3
     b68:	85ca                	mv	a1,s2
     b6a:	6b5000ef          	jal	1a1e <send>
     b6e:	16054963          	bltz	a0,ce0 <ping3+0x248>
  for(int ii = 0; ii < 257; ii++){
     b72:	2485                	addiw	s1,s1,1
     b74:	10100793          	li	a5,257
     b78:	faf49ee3          	bne	s1,a5,b34 <ping3+0x9c>
      printf("ping3: send() failed\n");
      return 0;
    }
  }
  pause(1);
     b7c:	4505                	li	a0,1
     b7e:	681000ef          	jal	19fe <pause>
  //
  {
    uint32 dst = 0x0A000202; // 10.0.2.2
    int dport = NET_TESTS_PORT;
    char buf[4];
    buf[0] = 'p';
     b82:	07000793          	li	a5,112
     b86:	f2f40423          	sb	a5,-216(s0)
    buf[1] = ' ';
     b8a:	02000793          	li	a5,32
     b8e:	f2f404a3          	sb	a5,-215(s0)
    buf[2] = 'B';
     b92:	04200793          	li	a5,66
     b96:	f2f40523          	sb	a5,-214(s0)
    buf[3] = '!';
     b9a:	02100793          	li	a5,33
     b9e:	f2f405a3          	sb	a5,-213(s0)
    if(send(2009, dst, dport, buf, 4) < 0){
     ba2:	4711                	li	a4,4
     ba4:	f2840693          	addi	a3,s0,-216
     ba8:	6619                	lui	a2,0x6
     baa:	40060613          	addi	a2,a2,1024 # 6400 <base+0x31f0>
     bae:	0a0005b7          	lui	a1,0xa000
     bb2:	20258593          	addi	a1,a1,514 # a000202 <base+0x9ffcff2>
     bb6:	7d900513          	li	a0,2009
     bba:	665000ef          	jal	1a1e <send>
     bbe:	04100913          	li	s2,65
     bc2:	14054363          	bltz	a0,d08 <ping3+0x270>
  //
  for(int ii = 0; ii < 2; ii++){
    char ibuf[128];
    uint32 src = 0;
    uint16 sport = 0;
    memset(ibuf, 0, sizeof(ibuf));
     bc6:	f2840993          	addi	s3,s0,-216
    int cc = recv(2009, &src, &sport, ibuf, sizeof(ibuf)-1);
     bca:	f1e40c13          	addi	s8,s0,-226
     bce:	f2440b93          	addi	s7,s0,-220
     bd2:	07f00b13          	li	s6,127
     bd6:	7d900a93          	li	s5,2009
    if(cc < 0){
      fprintf(2, "ping3: recv() failed\n");
      return 0;
    }
    
    if(src != 0x0A000202){ // 10.0.2.2
     bda:	0a000a37          	lui	s4,0xa000
     bde:	202a0a13          	addi	s4,s4,514 # a000202 <base+0x9ffcff2>
    uint32 src = 0;
     be2:	f2042223          	sw	zero,-220(s0)
    uint16 sport = 0;
     be6:	f0041f23          	sh	zero,-226(s0)
    memset(ibuf, 0, sizeof(ibuf));
     bea:	08000613          	li	a2,128
     bee:	4581                	li	a1,0
     bf0:	854e                	mv	a0,s3
     bf2:	353000ef          	jal	1744 <memset>
    int cc = recv(2009, &src, &sport, ibuf, sizeof(ibuf)-1);
     bf6:	875a                	mv	a4,s6
     bf8:	86ce                	mv	a3,s3
     bfa:	8662                	mv	a2,s8
     bfc:	85de                	mv	a1,s7
     bfe:	8556                	mv	a0,s5
     c00:	627000ef          	jal	1a26 <recv>
    if(cc < 0){
     c04:	12054163          	bltz	a0,d26 <ping3+0x28e>
    if(src != 0x0A000202){ // 10.0.2.2
     c08:	f2442583          	lw	a1,-220(s0)
     c0c:	13459d63          	bne	a1,s4,d46 <ping3+0x2ae>
      printf("ping3: wrong ip src %x\n", src);
      return 0;
    }
    
    if(sport != NET_TESTS_PORT){
     c10:	f1e45583          	lhu	a1,-226(s0)
     c14:	0005871b          	sext.w	a4,a1
     c18:	6799                	lui	a5,0x6
     c1a:	40078793          	addi	a5,a5,1024 # 6400 <base+0x31f0>
     c1e:	12f71b63          	bne	a4,a5,d54 <ping3+0x2bc>
      printf("ping3: wrong sport %d\n", sport);
      return 0;
    }
      
    if(cc != 4){
     c22:	4791                	li	a5,4
     c24:	12f51f63          	bne	a0,a5,d62 <ping3+0x2ca>
    }

    // printf("port=%d ii=%d: %c%c%c\n", port, ii, ibuf[0], ibuf[1], ibuf[2]);

    char buf[4];
    buf[0] = 'p';
     c28:	07000793          	li	a5,112
     c2c:	f2f40023          	sb	a5,-224(s0)
    buf[1] = ' ';
     c30:	02000793          	li	a5,32
     c34:	f2f400a3          	sb	a5,-223(s0)
    buf[2] = 'A' + ii;
     c38:	f3240123          	sb	s2,-222(s0)
    buf[3] = '!';
     c3c:	02100793          	li	a5,33
     c40:	f2f401a3          	sb	a5,-221(s0)
    
    if(memcmp(buf, ibuf, 3) != 0){
     c44:	460d                	li	a2,3
     c46:	85ce                	mv	a1,s3
     c48:	f2040513          	addi	a0,s0,-224
     c4c:	4a1000ef          	jal	18ec <memcmp>
     c50:	84aa                	mv	s1,a0
     c52:	12051063          	bnez	a0,d72 <ping3+0x2da>
  for(int ii = 0; ii < 2; ii++){
     c56:	2905                	addiw	s2,s2,1
     c58:	0ff97913          	zext.b	s2,s2
     c5c:	04300793          	li	a5,67
     c60:	f8f911e3          	bne	s2,a5,be2 <ping3+0x14a>

  //
  // now count how many replies were queued for 2008.
  //
  int fds[2];
  pipe(fds);
     c64:	fa840513          	addi	a0,s0,-88
     c68:	517000ef          	jal	197e <pipe>
  int pid = fork();
     c6c:	4fb000ef          	jal	1966 <fork>
     c70:	89aa                	mv	s3,a0
  if(pid == 0){
     c72:	10050763          	beqz	a0,d80 <ping3+0x2e8>
      }
      write(fds[1], "x", 1);
    }
    exit(0);
  }
  close(fds[1]);
     c76:	fac42503          	lw	a0,-84(s0)
     c7a:	51d000ef          	jal	1996 <close>

  pause(5);
     c7e:	4515                	li	a0,5
     c80:	57f000ef          	jal	19fe <pause>
  static char nbuf[512];
  int n = read(fds[0], nbuf, sizeof(nbuf));
     c84:	20000613          	li	a2,512
     c88:	00002597          	auipc	a1,0x2
     c8c:	38858593          	addi	a1,a1,904 # 3010 <nbuf.0>
     c90:	fa842503          	lw	a0,-88(s0)
     c94:	4f3000ef          	jal	1986 <read>
     c98:	892a                	mv	s2,a0
  close(fds[0]);
     c9a:	fa842503          	lw	a0,-88(s0)
     c9e:	4f9000ef          	jal	1996 <close>
  kill(pid);
     ca2:	854e                	mv	a0,s3
     ca4:	4fb000ef          	jal	199e <kill>

  n -= 1; // the ":"
     ca8:	fff9059b          	addiw	a1,s2,-1
  if(n > 16){
     cac:	47c1                	li	a5,16
     cae:	14b7c863          	blt	a5,a1,dfe <ping3+0x366>
    printf("ping3: too many packets (%d) were queued on a UDP port\n", n);
    return 0;
  }

  printf("ping3: OK\n");
     cb2:	00002517          	auipc	a0,0x2
     cb6:	89e50513          	addi	a0,a0,-1890 # 2550 <malloc+0x6ae>
     cba:	130010ef          	jal	1dea <printf>

  return 1;
     cbe:	4485                	li	s1,1
     cc0:	694e                	ld	s2,208(sp)
     cc2:	69ae                	ld	s3,200(sp)
     cc4:	6a0e                	ld	s4,192(sp)
     cc6:	7aea                	ld	s5,184(sp)
     cc8:	7b4a                	ld	s6,176(sp)
     cca:	7baa                	ld	s7,168(sp)
     ccc:	7c0a                	ld	s8,160(sp)
     cce:	a03d                	j	cfc <ping3+0x264>
      printf("ping3: send() failed\n");
     cd0:	00001517          	auipc	a0,0x1
     cd4:	79050513          	addi	a0,a0,1936 # 2460 <malloc+0x5be>
     cd8:	112010ef          	jal	1dea <printf>
      return 0;
     cdc:	4481                	li	s1,0
     cde:	a839                	j	cfc <ping3+0x264>
      printf("ping3: send() failed\n");
     ce0:	00001517          	auipc	a0,0x1
     ce4:	78050513          	addi	a0,a0,1920 # 2460 <malloc+0x5be>
     ce8:	102010ef          	jal	1dea <printf>
      return 0;
     cec:	4481                	li	s1,0
     cee:	694e                	ld	s2,208(sp)
     cf0:	69ae                	ld	s3,200(sp)
     cf2:	6a0e                	ld	s4,192(sp)
     cf4:	7aea                	ld	s5,184(sp)
     cf6:	7b4a                	ld	s6,176(sp)
     cf8:	7baa                	ld	s7,168(sp)
     cfa:	7c0a                	ld	s8,160(sp)
}
     cfc:	8526                	mv	a0,s1
     cfe:	70ae                	ld	ra,232(sp)
     d00:	740e                	ld	s0,224(sp)
     d02:	64ee                	ld	s1,216(sp)
     d04:	616d                	addi	sp,sp,240
     d06:	8082                	ret
      printf("ping3: send() failed\n");
     d08:	00001517          	auipc	a0,0x1
     d0c:	75850513          	addi	a0,a0,1880 # 2460 <malloc+0x5be>
     d10:	0da010ef          	jal	1dea <printf>
      return 0;
     d14:	4481                	li	s1,0
     d16:	694e                	ld	s2,208(sp)
     d18:	69ae                	ld	s3,200(sp)
     d1a:	6a0e                	ld	s4,192(sp)
     d1c:	7aea                	ld	s5,184(sp)
     d1e:	7b4a                	ld	s6,176(sp)
     d20:	7baa                	ld	s7,168(sp)
     d22:	7c0a                	ld	s8,160(sp)
     d24:	bfe1                	j	cfc <ping3+0x264>
      fprintf(2, "ping3: recv() failed\n");
     d26:	00001597          	auipc	a1,0x1
     d2a:	75258593          	addi	a1,a1,1874 # 2478 <malloc+0x5d6>
     d2e:	4509                	li	a0,2
     d30:	090010ef          	jal	1dc0 <fprintf>
      return 0;
     d34:	4481                	li	s1,0
     d36:	694e                	ld	s2,208(sp)
     d38:	69ae                	ld	s3,200(sp)
     d3a:	6a0e                	ld	s4,192(sp)
     d3c:	7aea                	ld	s5,184(sp)
     d3e:	7b4a                	ld	s6,176(sp)
     d40:	7baa                	ld	s7,168(sp)
     d42:	7c0a                	ld	s8,160(sp)
     d44:	bf65                	j	cfc <ping3+0x264>
      printf("ping3: wrong ip src %x\n", src);
     d46:	00001517          	auipc	a0,0x1
     d4a:	74a50513          	addi	a0,a0,1866 # 2490 <malloc+0x5ee>
     d4e:	09c010ef          	jal	1dea <printf>
      return 0;
     d52:	b7cd                	j	d34 <ping3+0x29c>
      printf("ping3: wrong sport %d\n", sport);
     d54:	00001517          	auipc	a0,0x1
     d58:	75450513          	addi	a0,a0,1876 # 24a8 <malloc+0x606>
     d5c:	08e010ef          	jal	1dea <printf>
      return 0;
     d60:	bfd1                	j	d34 <ping3+0x29c>
      printf("ping3: wrong length %d\n", cc);
     d62:	85aa                	mv	a1,a0
     d64:	00001517          	auipc	a0,0x1
     d68:	75c50513          	addi	a0,a0,1884 # 24c0 <malloc+0x61e>
     d6c:	07e010ef          	jal	1dea <printf>
      return 0;
     d70:	b7d1                	j	d34 <ping3+0x29c>
      printf("ping3: wrong content\n");
     d72:	00001517          	auipc	a0,0x1
     d76:	76650513          	addi	a0,a0,1894 # 24d8 <malloc+0x636>
     d7a:	070010ef          	jal	1dea <printf>
      return 0;
     d7e:	bf5d                	j	d34 <ping3+0x29c>
    close(fds[0]);
     d80:	fa842503          	lw	a0,-88(s0)
     d84:	413000ef          	jal	1996 <close>
    write(fds[1], ":", 1); // ensure parent's read() doesn't block
     d88:	4605                	li	a2,1
     d8a:	00001597          	auipc	a1,0x1
     d8e:	76658593          	addi	a1,a1,1894 # 24f0 <malloc+0x64e>
     d92:	fac42503          	lw	a0,-84(s0)
     d96:	3f9000ef          	jal	198e <write>
      memset(ibuf, 0, sizeof(ibuf));
     d9a:	f2840493          	addi	s1,s0,-216
     d9e:	08000b93          	li	s7,128
      int cc = recv(2008, &src, &sport, ibuf, sizeof(ibuf)-1);
     da2:	f2040b13          	addi	s6,s0,-224
     da6:	f2440a93          	addi	s5,s0,-220
     daa:	07f00a13          	li	s4,127
     dae:	7d800993          	li	s3,2008
      write(fds[1], "x", 1);
     db2:	4905                	li	s2,1
     db4:	a811                	j	dc8 <ping3+0x330>
     db6:	864a                	mv	a2,s2
     db8:	00001597          	auipc	a1,0x1
     dbc:	75858593          	addi	a1,a1,1880 # 2510 <malloc+0x66e>
     dc0:	fac42503          	lw	a0,-84(s0)
     dc4:	3cb000ef          	jal	198e <write>
      uint32 src = 0;
     dc8:	f2042223          	sw	zero,-220(s0)
      uint16 sport = 0;
     dcc:	f2041023          	sh	zero,-224(s0)
      memset(ibuf, 0, sizeof(ibuf));
     dd0:	865e                	mv	a2,s7
     dd2:	4581                	li	a1,0
     dd4:	8526                	mv	a0,s1
     dd6:	16f000ef          	jal	1744 <memset>
      int cc = recv(2008, &src, &sport, ibuf, sizeof(ibuf)-1);
     dda:	8752                	mv	a4,s4
     ddc:	86a6                	mv	a3,s1
     dde:	865a                	mv	a2,s6
     de0:	85d6                	mv	a1,s5
     de2:	854e                	mv	a0,s3
     de4:	443000ef          	jal	1a26 <recv>
      if(cc < 0){
     de8:	fc0557e3          	bgez	a0,db6 <ping3+0x31e>
        printf("ping3: recv failed\n");
     dec:	00001517          	auipc	a0,0x1
     df0:	70c50513          	addi	a0,a0,1804 # 24f8 <malloc+0x656>
     df4:	7f7000ef          	jal	1dea <printf>
    exit(0);
     df8:	4501                	li	a0,0
     dfa:	375000ef          	jal	196e <exit>
    printf("ping3: too many packets (%d) were queued on a UDP port\n", n);
     dfe:	00001517          	auipc	a0,0x1
     e02:	71a50513          	addi	a0,a0,1818 # 2518 <malloc+0x676>
     e06:	7e5000ef          	jal	1dea <printf>
    return 0;
     e0a:	694e                	ld	s2,208(sp)
     e0c:	69ae                	ld	s3,200(sp)
     e0e:	6a0e                	ld	s4,192(sp)
     e10:	7aea                	ld	s5,184(sp)
     e12:	7b4a                	ld	s6,176(sp)
     e14:	7baa                	ld	s7,168(sp)
     e16:	7c0a                	ld	s8,160(sp)
     e18:	b5d5                	j	cfc <ping3+0x264>

0000000000000e1a <encode_qname>:

// Encode a DNS name
void
encode_qname(char *qn, char *host)
{
     e1a:	7139                	addi	sp,sp,-64
     e1c:	fc06                	sd	ra,56(sp)
     e1e:	f822                	sd	s0,48(sp)
     e20:	f426                	sd	s1,40(sp)
     e22:	f04a                	sd	s2,32(sp)
     e24:	ec4e                	sd	s3,24(sp)
     e26:	e852                	sd	s4,16(sp)
     e28:	e456                	sd	s5,8(sp)
     e2a:	0080                	addi	s0,sp,64
     e2c:	8aaa                	mv	s5,a0
     e2e:	892e                	mv	s2,a1
  char *l = host; 
  
  for(char *c = host; c < host+strlen(host)+1; c++) {
     e30:	84ae                	mv	s1,a1
  char *l = host; 
     e32:	8a2e                	mv	s4,a1
    if(*c == '.') {
     e34:	02e00993          	li	s3,46
  for(char *c = host; c < host+strlen(host)+1; c++) {
     e38:	a029                	j	e42 <encode_qname+0x28>
      *qn++ = (char) (c-l);
     e3a:	8ab2                	mv	s5,a2
      for(char *d = l; d < c; d++) {
        *qn++ = *d;
      }
      l = c+1; // skip .
     e3c:	00148a13          	addi	s4,s1,1
  for(char *c = host; c < host+strlen(host)+1; c++) {
     e40:	0485                	addi	s1,s1,1
     e42:	854a                	mv	a0,s2
     e44:	0d5000ef          	jal	1718 <strlen>
     e48:	02051793          	slli	a5,a0,0x20
     e4c:	9381                	srli	a5,a5,0x20
     e4e:	0785                	addi	a5,a5,1
     e50:	97ca                	add	a5,a5,s2
     e52:	02f4fc63          	bgeu	s1,a5,e8a <encode_qname+0x70>
    if(*c == '.') {
     e56:	0004c783          	lbu	a5,0(s1)
     e5a:	ff3793e3          	bne	a5,s3,e40 <encode_qname+0x26>
      *qn++ = (char) (c-l);
     e5e:	001a8613          	addi	a2,s5,1
     e62:	414487b3          	sub	a5,s1,s4
     e66:	00fa8023          	sb	a5,0(s5)
      for(char *d = l; d < c; d++) {
     e6a:	fc9a78e3          	bgeu	s4,s1,e3a <encode_qname+0x20>
     e6e:	87d2                	mv	a5,s4
      *qn++ = (char) (c-l);
     e70:	8732                	mv	a4,a2
        *qn++ = *d;
     e72:	0705                	addi	a4,a4,1
     e74:	0007c683          	lbu	a3,0(a5)
     e78:	fed70fa3          	sb	a3,-1(a4)
      for(char *d = l; d < c; d++) {
     e7c:	0785                	addi	a5,a5,1
     e7e:	fef49ae3          	bne	s1,a5,e72 <encode_qname+0x58>
     e82:	9626                	add	a2,a2,s1
     e84:	41460ab3          	sub	s5,a2,s4
     e88:	bf55                	j	e3c <encode_qname+0x22>
    }
  }
  *qn = '\0';
     e8a:	000a8023          	sb	zero,0(s5)
}
     e8e:	70e2                	ld	ra,56(sp)
     e90:	7442                	ld	s0,48(sp)
     e92:	74a2                	ld	s1,40(sp)
     e94:	7902                	ld	s2,32(sp)
     e96:	69e2                	ld	s3,24(sp)
     e98:	6a42                	ld	s4,16(sp)
     e9a:	6aa2                	ld	s5,8(sp)
     e9c:	6121                	addi	sp,sp,64
     e9e:	8082                	ret

0000000000000ea0 <decode_qname>:

// Decode a DNS name
void
decode_qname(char *qn, int max)
{
  char *qnMax = qn + max;
     ea0:	95aa                	add	a1,a1,a0
      break;
    for(int i = 0; i < l; i++) {
      *qn = *(qn+1);
      qn++;
    }
    *qn++ = '.';
     ea2:	02e00813          	li	a6,46
    if(qn >= qnMax){
     ea6:	02b57a63          	bgeu	a0,a1,eda <decode_qname+0x3a>
    int l = *qn;
     eaa:	00054683          	lbu	a3,0(a0)
    if(l == 0)
     eae:	c2b9                	beqz	a3,ef4 <decode_qname+0x54>
     eb0:	fff6861b          	addiw	a2,a3,-1
     eb4:	1602                	slli	a2,a2,0x20
     eb6:	9201                	srli	a2,a2,0x20
     eb8:	96aa                	add	a3,a3,a0
     eba:	87aa                	mv	a5,a0
      *qn = *(qn+1);
     ebc:	0017c703          	lbu	a4,1(a5)
     ec0:	00e78023          	sb	a4,0(a5)
      qn++;
     ec4:	0785                	addi	a5,a5,1
    for(int i = 0; i < l; i++) {
     ec6:	fed79be3          	bne	a5,a3,ebc <decode_qname+0x1c>
     eca:	87aa                	mv	a5,a0
     ecc:	9532                	add	a0,a0,a2
    *qn++ = '.';
     ece:	0509                	addi	a0,a0,2
     ed0:	97b2                	add	a5,a5,a2
     ed2:	010780a3          	sb	a6,1(a5)
    if(qn >= qnMax){
     ed6:	fcb56ae3          	bltu	a0,a1,eaa <decode_qname+0xa>
{
     eda:	1141                	addi	sp,sp,-16
     edc:	e406                	sd	ra,8(sp)
     ede:	e022                	sd	s0,0(sp)
     ee0:	0800                	addi	s0,sp,16
      printf("invalid DNS reply\n");
     ee2:	00001517          	auipc	a0,0x1
     ee6:	67e50513          	addi	a0,a0,1662 # 2560 <malloc+0x6be>
     eea:	701000ef          	jal	1dea <printf>
      exit(1);
     eee:	4505                	li	a0,1
     ef0:	27f000ef          	jal	196e <exit>
     ef4:	8082                	ret

0000000000000ef6 <dns_req>:
}

// Make a DNS request
int
dns_req(uint8 *obuf)
{
     ef6:	7179                	addi	sp,sp,-48
     ef8:	f406                	sd	ra,40(sp)
     efa:	f022                	sd	s0,32(sp)
     efc:	ec26                	sd	s1,24(sp)
     efe:	e84a                	sd	s2,16(sp)
     f00:	e44e                	sd	s3,8(sp)
     f02:	1800                	addi	s0,sp,48
  int len = 0;
  
  struct dns *hdr = (struct dns *) obuf;
  hdr->id = htons(6828);
     f04:	47e9                	li	a5,26
     f06:	00f50023          	sb	a5,0(a0)
     f0a:	fac00793          	li	a5,-84
     f0e:	00f500a3          	sb	a5,1(a0)
  hdr->rd = 1;
     f12:	00254783          	lbu	a5,2(a0)
     f16:	0017e793          	ori	a5,a5,1
     f1a:	00f50123          	sb	a5,2(a0)
  hdr->qdcount = htons(1);
     f1e:	00050223          	sb	zero,4(a0)
     f22:	4905                	li	s2,1
     f24:	012502a3          	sb	s2,5(a0)
  
  len += sizeof(struct dns);
  
  // qname part of question
  char *qname = (char *) (obuf + sizeof(struct dns));
     f28:	00c50493          	addi	s1,a0,12
  char *s = "pdos.csail.mit.edu.";
  encode_qname(qname, s);
     f2c:	00001597          	auipc	a1,0x1
     f30:	64c58593          	addi	a1,a1,1612 # 2578 <malloc+0x6d6>
     f34:	8526                	mv	a0,s1
     f36:	ee5ff0ef          	jal	e1a <encode_qname>
  len += strlen(qname) + 1;
     f3a:	8526                	mv	a0,s1
     f3c:	7dc000ef          	jal	1718 <strlen>
     f40:	89aa                	mv	s3,a0

  // constants part of question
  struct dns_question *h = (struct dns_question *) (qname+strlen(qname)+1);
     f42:	8526                	mv	a0,s1
     f44:	7d4000ef          	jal	1718 <strlen>
     f48:	02051793          	slli	a5,a0,0x20
     f4c:	9381                	srli	a5,a5,0x20
     f4e:	97ca                	add	a5,a5,s2
     f50:	94be                	add	s1,s1,a5
  h->qtype = htons(0x1);
     f52:	00048023          	sb	zero,0(s1)
     f56:	012480a3          	sb	s2,1(s1)
  h->qclass = htons(0x1);
     f5a:	00048123          	sb	zero,2(s1)
     f5e:	012481a3          	sb	s2,3(s1)

  len += sizeof(struct dns_question);
  return len;
}
     f62:	0119851b          	addiw	a0,s3,17
     f66:	70a2                	ld	ra,40(sp)
     f68:	7402                	ld	s0,32(sp)
     f6a:	64e2                	ld	s1,24(sp)
     f6c:	6942                	ld	s2,16(sp)
     f6e:	69a2                	ld	s3,8(sp)
     f70:	6145                	addi	sp,sp,48
     f72:	8082                	ret

0000000000000f74 <dns_rep>:

// Process DNS response
int
dns_rep(uint8 *ibuf, int cc)
{
     f74:	7159                	addi	sp,sp,-112
     f76:	f486                	sd	ra,104(sp)
     f78:	f0a2                	sd	s0,96(sp)
     f7a:	e86a                	sd	s10,16(sp)
     f7c:	1880                	addi	s0,sp,112
  struct dns *hdr = (struct dns *) ibuf;
  int len;
  char *qname = 0;
  int record = 0;

  if(cc < sizeof(struct dns)){
     f7e:	47ad                	li	a5,11
     f80:	0cb7f163          	bgeu	a5,a1,1042 <dns_rep+0xce>
     f84:	e8ca                	sd	s2,80(sp)
     f86:	f85a                	sd	s6,48(sp)
     f88:	892a                	mv	s2,a0
     f8a:	8b2e                	mv	s6,a1
    printf("DNS reply too short\n");
    return 0;
  }

  if(!hdr->qr) {
     f8c:	00250783          	lb	a5,2(a0)
     f90:	0c07d163          	bgez	a5,1052 <dns_rep+0xde>
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
    return 0;
  }

  if(hdr->id != htons(6828)){
     f94:	00054703          	lbu	a4,0(a0)
     f98:	00154783          	lbu	a5,1(a0)
     f9c:	07a2                	slli	a5,a5,0x8
     f9e:	00e7e6b3          	or	a3,a5,a4
     fa2:	672d                	lui	a4,0xb
     fa4:	c1a70713          	addi	a4,a4,-998 # ac1a <base+0x7a0a>
     fa8:	0ee69163          	bne	a3,a4,108a <dns_rep+0x116>
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
    return 0;
  }
  
  if(hdr->rcode != 0) {
     fac:	00354783          	lbu	a5,3(a0)
     fb0:	8bbd                	andi	a5,a5,15
     fb2:	0e079d63          	bnez	a5,10ac <dns_rep+0x138>
     fb6:	eca6                	sd	s1,88(sp)
     fb8:	e4ce                	sd	s3,72(sp)
     fba:	e0d2                	sd	s4,64(sp)
  //printf("nscount: %x\n", ntohs(hdr->nscount));
  //printf("arcount: %x\n", ntohs(hdr->arcount));
  
  len = sizeof(struct dns);

  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     fbc:	00454703          	lbu	a4,4(a0)
     fc0:	00554783          	lbu	a5,5(a0)
     fc4:	07a2                	slli	a5,a5,0x8
     fc6:	8fd9                	or	a5,a5,a4
     fc8:	4a01                	li	s4,0
  len = sizeof(struct dns);
     fca:	44b1                	li	s1,12
  char *qname = 0;
     fcc:	4981                	li	s3,0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     fce:	cf85                	beqz	a5,1006 <dns_rep+0x92>
    char *qn = (char *) (ibuf+len);
     fd0:	009909b3          	add	s3,s2,s1
    qname = qn;
    decode_qname(qn, cc - len);
     fd4:	409b05bb          	subw	a1,s6,s1
     fd8:	854e                	mv	a0,s3
     fda:	ec7ff0ef          	jal	ea0 <decode_qname>
    len += strlen(qn)+1;
     fde:	854e                	mv	a0,s3
     fe0:	738000ef          	jal	1718 <strlen>
    len += sizeof(struct dns_question);
     fe4:	2515                	addiw	a0,a0,5
     fe6:	9ca9                	addw	s1,s1,a0
  for(int i =0; i < ntohs(hdr->qdcount); i++) {
     fe8:	2a05                	addiw	s4,s4,1
     fea:	00494703          	lbu	a4,4(s2)
     fee:	00594783          	lbu	a5,5(s2)
     ff2:	07a2                	slli	a5,a5,0x8
     ff4:	8f5d                	or	a4,a4,a5
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
     ff6:	83a1                	srli	a5,a5,0x8
     ff8:	0087171b          	slliw	a4,a4,0x8
     ffc:	9fb9                	addw	a5,a5,a4
     ffe:	17c2                	slli	a5,a5,0x30
    1000:	93c1                	srli	a5,a5,0x30
    1002:	fcfa47e3          	blt	s4,a5,fd0 <dns_rep+0x5c>
  }

  for(int i = 0; i < ntohs(hdr->ancount); i++) {
    1006:	00694703          	lbu	a4,6(s2)
    100a:	00794783          	lbu	a5,7(s2)
    100e:	07a2                	slli	a5,a5,0x8
    1010:	8fd9                	or	a5,a5,a4
    1012:	24078f63          	beqz	a5,1270 <dns_rep+0x2fc>
    1016:	fc56                	sd	s5,56(sp)
    1018:	f45e                	sd	s7,40(sp)
    101a:	f062                	sd	s8,32(sp)
    101c:	ec66                	sd	s9,24(sp)
    101e:	e46e                	sd	s11,8(sp)
    1020:	00002797          	auipc	a5,0x2
    1024:	8f878793          	addi	a5,a5,-1800 # 2918 <malloc+0xa76>
    1028:	00098363          	beqz	s3,102e <dns_rep+0xba>
    102c:	87ce                	mv	a5,s3
    102e:	8dbe                	mv	s11,a5
    1030:	4a81                	li	s5,0
  int record = 0;
    1032:	4d01                	li	s10,0
      return 0;
    }
    
    char *qn = (char *) (ibuf+len);

    if((int) qn[0] > 63) {  // compression?
    1034:	03f00c13          	li	s8,63
    }
      
    struct dns_data *d = (struct dns_data *) (ibuf+len);
    len += sizeof(struct dns_data);
    //printf("type %d ttl %d len %d\n", ntohs(d->type), ntohl(d->ttl), ntohs(d->len));
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
    1038:	10000b93          	li	s7,256
    103c:	40000c93          	li	s9,1024
    1040:	a211                	j	1144 <dns_rep+0x1d0>
    printf("DNS reply too short\n");
    1042:	00001517          	auipc	a0,0x1
    1046:	54e50513          	addi	a0,a0,1358 # 2590 <malloc+0x6ee>
    104a:	5a1000ef          	jal	1dea <printf>
    return 0;
    104e:	4d01                	li	s10,0
    1050:	a03d                	j	107e <dns_rep+0x10a>
    printf("Not a DNS reply for %d\n", ntohs(hdr->id));
    1052:	00054703          	lbu	a4,0(a0)
    1056:	00154783          	lbu	a5,1(a0)
    105a:	07a2                	slli	a5,a5,0x8
    105c:	8f5d                	or	a4,a4,a5
    105e:	83a1                	srli	a5,a5,0x8
    1060:	0087171b          	slliw	a4,a4,0x8
    1064:	00e785bb          	addw	a1,a5,a4
    1068:	15c2                	slli	a1,a1,0x30
    106a:	91c1                	srli	a1,a1,0x30
    106c:	00001517          	auipc	a0,0x1
    1070:	53c50513          	addi	a0,a0,1340 # 25a8 <malloc+0x706>
    1074:	577000ef          	jal	1dea <printf>
    return 0;
    1078:	4d01                	li	s10,0
    107a:	6946                	ld	s2,80(sp)
    107c:	7b42                	ld	s6,48(sp)
    printf("dns: didn't receive an arecord\n");
    return 0;
  }

  return 1;
}
    107e:	856a                	mv	a0,s10
    1080:	70a6                	ld	ra,104(sp)
    1082:	7406                	ld	s0,96(sp)
    1084:	6d42                	ld	s10,16(sp)
    1086:	6165                	addi	sp,sp,112
    1088:	8082                	ret
    108a:	0086d59b          	srliw	a1,a3,0x8
    108e:	0086969b          	slliw	a3,a3,0x8
    1092:	9db5                	addw	a1,a1,a3
    printf("DNS wrong id: %d\n", ntohs(hdr->id));
    1094:	15c2                	slli	a1,a1,0x30
    1096:	91c1                	srli	a1,a1,0x30
    1098:	00001517          	auipc	a0,0x1
    109c:	52850513          	addi	a0,a0,1320 # 25c0 <malloc+0x71e>
    10a0:	54b000ef          	jal	1dea <printf>
    return 0;
    10a4:	4d01                	li	s10,0
    10a6:	6946                	ld	s2,80(sp)
    10a8:	7b42                	ld	s6,48(sp)
    10aa:	bfd1                	j	107e <dns_rep+0x10a>
    printf("DNS rcode error: %x\n", hdr->rcode);
    10ac:	00354583          	lbu	a1,3(a0)
    10b0:	89bd                	andi	a1,a1,15
    10b2:	00001517          	auipc	a0,0x1
    10b6:	52650513          	addi	a0,a0,1318 # 25d8 <malloc+0x736>
    10ba:	531000ef          	jal	1dea <printf>
    return 0;
    10be:	4d01                	li	s10,0
    10c0:	6946                	ld	s2,80(sp)
    10c2:	7b42                	ld	s6,48(sp)
    10c4:	bf6d                	j	107e <dns_rep+0x10a>
      printf("dns: invalid DNS reply\n");
    10c6:	00001517          	auipc	a0,0x1
    10ca:	52a50513          	addi	a0,a0,1322 # 25f0 <malloc+0x74e>
    10ce:	51d000ef          	jal	1dea <printf>
      return 0;
    10d2:	4d01                	li	s10,0
    10d4:	64e6                	ld	s1,88(sp)
    10d6:	6946                	ld	s2,80(sp)
    10d8:	69a6                	ld	s3,72(sp)
    10da:	6a06                	ld	s4,64(sp)
    10dc:	7ae2                	ld	s5,56(sp)
    10de:	7b42                	ld	s6,48(sp)
    10e0:	7ba2                	ld	s7,40(sp)
    10e2:	7c02                	ld	s8,32(sp)
    10e4:	6ce2                	ld	s9,24(sp)
    10e6:	6da2                	ld	s11,8(sp)
    10e8:	bf59                	j	107e <dns_rep+0x10a>
      decode_qname(qn, cc - len);
    10ea:	409b05bb          	subw	a1,s6,s1
    10ee:	854e                	mv	a0,s3
    10f0:	db1ff0ef          	jal	ea0 <decode_qname>
      len += strlen(qn)+1;
    10f4:	854e                	mv	a0,s3
    10f6:	622000ef          	jal	1718 <strlen>
    10fa:	2485                	addiw	s1,s1,1
    10fc:	00a489bb          	addw	s3,s1,a0
    1100:	a8a1                	j	1158 <dns_rep+0x1e4>
        printf("dns: wrong ip address");
    1102:	00001517          	auipc	a0,0x1
    1106:	52e50513          	addi	a0,a0,1326 # 2630 <malloc+0x78e>
    110a:	4e1000ef          	jal	1dea <printf>
        return 0;
    110e:	4d01                	li	s10,0
    1110:	64e6                	ld	s1,88(sp)
    1112:	6946                	ld	s2,80(sp)
    1114:	69a6                	ld	s3,72(sp)
    1116:	6a06                	ld	s4,64(sp)
    1118:	7ae2                	ld	s5,56(sp)
    111a:	7b42                	ld	s6,48(sp)
    111c:	7ba2                	ld	s7,40(sp)
    111e:	7c02                	ld	s8,32(sp)
    1120:	6ce2                	ld	s9,24(sp)
    1122:	6da2                	ld	s11,8(sp)
    1124:	bfa9                	j	107e <dns_rep+0x10a>
  for(int i = 0; i < ntohs(hdr->ancount); i++) {
    1126:	2a85                	addiw	s5,s5,1
    1128:	00694703          	lbu	a4,6(s2)
    112c:	00794783          	lbu	a5,7(s2)
    1130:	07a2                	slli	a5,a5,0x8
    1132:	8f5d                	or	a4,a4,a5
    1134:	83a1                	srli	a5,a5,0x8
    1136:	0087171b          	slliw	a4,a4,0x8
    113a:	9fb9                	addw	a5,a5,a4
    113c:	17c2                	slli	a5,a5,0x30
    113e:	93c1                	srli	a5,a5,0x30
    1140:	0afad463          	bge	s5,a5,11e8 <dns_rep+0x274>
    if(len >= cc){
    1144:	f964d1e3          	bge	s1,s6,10c6 <dns_rep+0x152>
    char *qn = (char *) (ibuf+len);
    1148:	009909b3          	add	s3,s2,s1
    if((int) qn[0] > 63) {  // compression?
    114c:	0009c783          	lbu	a5,0(s3)
    1150:	f8fc7de3          	bgeu	s8,a5,10ea <dns_rep+0x176>
      len += 2;
    1154:	0024899b          	addiw	s3,s1,2
    struct dns_data *d = (struct dns_data *) (ibuf+len);
    1158:	01390733          	add	a4,s2,s3
    len += sizeof(struct dns_data);
    115c:	00a98a1b          	addiw	s4,s3,10
    1160:	84d2                	mv	s1,s4
    if(ntohs(d->type) == ARECORD && ntohs(d->len) == 4) {
    1162:	00074683          	lbu	a3,0(a4)
    1166:	00174783          	lbu	a5,1(a4)
    116a:	07a2                	slli	a5,a5,0x8
    116c:	8fd5                	or	a5,a5,a3
    116e:	fb779ce3          	bne	a5,s7,1126 <dns_rep+0x1b2>
    1172:	00874683          	lbu	a3,8(a4)
    1176:	00974783          	lbu	a5,9(a4)
    117a:	07a2                	slli	a5,a5,0x8
    117c:	8fd5                	or	a5,a5,a3
    117e:	fb9794e3          	bne	a5,s9,1126 <dns_rep+0x1b2>
      printf("DNS arecord for %s is ", qname ? qname : "" );
    1182:	85ee                	mv	a1,s11
    1184:	00001517          	auipc	a0,0x1
    1188:	48450513          	addi	a0,a0,1156 # 2608 <malloc+0x766>
    118c:	45f000ef          	jal	1dea <printf>
      uint8 *ip = (ibuf+len);
    1190:	9a4a                	add	s4,s4,s2
      printf("%d.%d.%d.%d\n", ip[0], ip[1], ip[2], ip[3]);
    1192:	003a4703          	lbu	a4,3(s4)
    1196:	002a4683          	lbu	a3,2(s4)
    119a:	001a4603          	lbu	a2,1(s4)
    119e:	000a4583          	lbu	a1,0(s4)
    11a2:	00001517          	auipc	a0,0x1
    11a6:	47e50513          	addi	a0,a0,1150 # 2620 <malloc+0x77e>
    11aa:	441000ef          	jal	1dea <printf>
      if(ip[0] != 128 || ip[1] != 52 || ip[2] != 129 || ip[3] != 126) {
    11ae:	000a4783          	lbu	a5,0(s4)
    11b2:	08000713          	li	a4,128
    11b6:	f4e796e3          	bne	a5,a4,1102 <dns_rep+0x18e>
    11ba:	001a4783          	lbu	a5,1(s4)
    11be:	03400713          	li	a4,52
    11c2:	f4e790e3          	bne	a5,a4,1102 <dns_rep+0x18e>
    11c6:	002a4703          	lbu	a4,2(s4)
    11ca:	08100793          	li	a5,129
    11ce:	f2f71ae3          	bne	a4,a5,1102 <dns_rep+0x18e>
    11d2:	003a4703          	lbu	a4,3(s4)
    11d6:	07e00793          	li	a5,126
    11da:	f2f714e3          	bne	a4,a5,1102 <dns_rep+0x18e>
      len += 4;
    11de:	00e9849b          	addiw	s1,s3,14
      record = 1;
    11e2:	4785                	li	a5,1
    11e4:	8d3e                	mv	s10,a5
    11e6:	b781                	j	1126 <dns_rep+0x1b2>
    11e8:	7ae2                	ld	s5,56(sp)
    11ea:	7ba2                	ld	s7,40(sp)
    11ec:	7c02                	ld	s8,32(sp)
    11ee:	6ce2                	ld	s9,24(sp)
    11f0:	6da2                	ld	s11,8(sp)
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
    11f2:	00a94703          	lbu	a4,10(s2)
    11f6:	00b94783          	lbu	a5,11(s2)
    11fa:	07a2                	slli	a5,a5,0x8
    11fc:	8fd9                	or	a5,a5,a4
    11fe:	cfb9                	beqz	a5,125c <dns_rep+0x2e8>
    1200:	0087d59b          	srliw	a1,a5,0x8
    1204:	0087979b          	slliw	a5,a5,0x8
    1208:	9dbd                	addw	a1,a1,a5
    120a:	15c2                	slli	a1,a1,0x30
    120c:	91c1                	srli	a1,a1,0x30
    120e:	4681                	li	a3,0
    if(ntohs(d->type) != 41) {
    1210:	650d                	lui	a0,0x3
    1212:	90050513          	addi	a0,a0,-1792 # 2900 <malloc+0xa5e>
    if(*qn != 0) {
    1216:	009907b3          	add	a5,s2,s1
    121a:	0007c783          	lbu	a5,0(a5)
    121e:	ebb9                	bnez	a5,1274 <dns_rep+0x300>
    len += 1;
    1220:	0014879b          	addiw	a5,s1,1
    struct dns_data *d = (struct dns_data *) (ibuf+len);
    1224:	97ca                	add	a5,a5,s2
    if(ntohs(d->type) != 41) {
    1226:	0007c603          	lbu	a2,0(a5)
    122a:	0017c703          	lbu	a4,1(a5)
    122e:	0722                	slli	a4,a4,0x8
    1230:	8f51                	or	a4,a4,a2
    1232:	04a71e63          	bne	a4,a0,128e <dns_rep+0x31a>
    len += sizeof(struct dns_data);
    1236:	24ad                	addiw	s1,s1,11
    len += ntohs(d->len);
    1238:	0087c703          	lbu	a4,8(a5)
    123c:	0097c783          	lbu	a5,9(a5)
    1240:	07a2                	slli	a5,a5,0x8
    1242:	8f5d                	or	a4,a4,a5
    1244:	83a1                	srli	a5,a5,0x8
    1246:	0087171b          	slliw	a4,a4,0x8
    124a:	9fb9                	addw	a5,a5,a4
    124c:	0107979b          	slliw	a5,a5,0x10
    1250:	0107d79b          	srliw	a5,a5,0x10
    1254:	9cbd                	addw	s1,s1,a5
  for(int i = 0; i < ntohs(hdr->arcount); i++) {
    1256:	2685                	addiw	a3,a3,1
    1258:	fab6cfe3          	blt	a3,a1,1216 <dns_rep+0x2a2>
  if(len != cc) {
    125c:	049b1663          	bne	s6,s1,12a8 <dns_rep+0x334>
  if(!record) {
    1260:	060d0363          	beqz	s10,12c6 <dns_rep+0x352>
    1264:	64e6                	ld	s1,88(sp)
    1266:	6946                	ld	s2,80(sp)
    1268:	69a6                	ld	s3,72(sp)
    126a:	6a06                	ld	s4,64(sp)
    126c:	7b42                	ld	s6,48(sp)
    126e:	bd01                	j	107e <dns_rep+0x10a>
  int record = 0;
    1270:	4d01                	li	s10,0
    1272:	b741                	j	11f2 <dns_rep+0x27e>
      printf("dns: invalid name for EDNS\n");
    1274:	00001517          	auipc	a0,0x1
    1278:	3d450513          	addi	a0,a0,980 # 2648 <malloc+0x7a6>
    127c:	36f000ef          	jal	1dea <printf>
      return 0;
    1280:	4d01                	li	s10,0
    1282:	64e6                	ld	s1,88(sp)
    1284:	6946                	ld	s2,80(sp)
    1286:	69a6                	ld	s3,72(sp)
    1288:	6a06                	ld	s4,64(sp)
    128a:	7b42                	ld	s6,48(sp)
    128c:	bbcd                	j	107e <dns_rep+0x10a>
      printf("dns: invalid type for EDNS\n");
    128e:	00001517          	auipc	a0,0x1
    1292:	3da50513          	addi	a0,a0,986 # 2668 <malloc+0x7c6>
    1296:	355000ef          	jal	1dea <printf>
      return 0;
    129a:	4d01                	li	s10,0
    129c:	64e6                	ld	s1,88(sp)
    129e:	6946                	ld	s2,80(sp)
    12a0:	69a6                	ld	s3,72(sp)
    12a2:	6a06                	ld	s4,64(sp)
    12a4:	7b42                	ld	s6,48(sp)
    12a6:	bbe1                	j	107e <dns_rep+0x10a>
    printf("dns: processed %d data bytes but received %d\n", len, cc);
    12a8:	865a                	mv	a2,s6
    12aa:	85a6                	mv	a1,s1
    12ac:	00001517          	auipc	a0,0x1
    12b0:	3dc50513          	addi	a0,a0,988 # 2688 <malloc+0x7e6>
    12b4:	337000ef          	jal	1dea <printf>
    return 0;
    12b8:	4d01                	li	s10,0
    12ba:	64e6                	ld	s1,88(sp)
    12bc:	6946                	ld	s2,80(sp)
    12be:	69a6                	ld	s3,72(sp)
    12c0:	6a06                	ld	s4,64(sp)
    12c2:	7b42                	ld	s6,48(sp)
    12c4:	bb6d                	j	107e <dns_rep+0x10a>
    printf("dns: didn't receive an arecord\n");
    12c6:	00001517          	auipc	a0,0x1
    12ca:	3f250513          	addi	a0,a0,1010 # 26b8 <malloc+0x816>
    12ce:	31d000ef          	jal	1dea <printf>
    12d2:	64e6                	ld	s1,88(sp)
    12d4:	6946                	ld	s2,80(sp)
    12d6:	69a6                	ld	s3,72(sp)
    12d8:	6a06                	ld	s4,64(sp)
    12da:	7b42                	ld	s6,48(sp)
    return 0;
    12dc:	b34d                	j	107e <dns_rep+0x10a>

00000000000012de <dns>:

int
dns()
{
    12de:	1101                	addi	sp,sp,-32
    12e0:	ec06                	sd	ra,24(sp)
    12e2:	e822                	sd	s0,16(sp)
    12e4:	e426                	sd	s1,8(sp)
    12e6:	e04a                	sd	s2,0(sp)
    12e8:	1000                	addi	s0,sp,32
    12ea:	82010113          	addi	sp,sp,-2016
  uint8 obuf[N];
  uint8 ibuf[N];
  uint32 dst;
  int len;

  printf("dns: starting\n");
    12ee:	00001517          	auipc	a0,0x1
    12f2:	3ea50513          	addi	a0,a0,1002 # 26d8 <malloc+0x836>
    12f6:	2f5000ef          	jal	1dea <printf>

  memset(obuf, 0, N);
    12fa:	bf840493          	addi	s1,s0,-1032
    12fe:	3e800613          	li	a2,1000
    1302:	4581                	li	a1,0
    1304:	8526                	mv	a0,s1
    1306:	43e000ef          	jal	1744 <memset>
  memset(ibuf, 0, N);
    130a:	3e800613          	li	a2,1000
    130e:	4581                	li	a1,0
    1310:	81040513          	addi	a0,s0,-2032
    1314:	430000ef          	jal	1744 <memset>
  
  // 8.8.8.8: google's name server
  dst = (8 << 24) | (8 << 16) | (8 << 8) | (8 << 0);

  len = dns_req(obuf);
    1318:	8526                	mv	a0,s1
    131a:	bddff0ef          	jal	ef6 <dns_req>
    131e:	892a                	mv	s2,a0
  
  bind(10000);
    1320:	6509                	lui	a0,0x2
    1322:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x86e>
    1326:	6e8000ef          	jal	1a0e <bind>
  
  if(send(10000, dst, 53, (char*)obuf, len) < 0){
    132a:	874a                	mv	a4,s2
    132c:	86a6                	mv	a3,s1
    132e:	03500613          	li	a2,53
    1332:	080815b7          	lui	a1,0x8081
    1336:	80858593          	addi	a1,a1,-2040 # 8080808 <base+0x807d5f8>
    133a:	6509                	lui	a0,0x2
    133c:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x86e>
    1340:	6de000ef          	jal	1a1e <send>
    1344:	02054f63          	bltz	a0,1382 <dns+0xa4>
    return 0;
  }

  uint32 src;
  uint16 sport;
  int cc = recv(10000, &src, &sport, (char*)ibuf, sizeof(ibuf));
    1348:	3e800713          	li	a4,1000
    134c:	81040693          	addi	a3,s0,-2032
    1350:	80a40613          	addi	a2,s0,-2038
    1354:	80c40593          	addi	a1,s0,-2036
    1358:	6509                	lui	a0,0x2
    135a:	71050513          	addi	a0,a0,1808 # 2710 <malloc+0x86e>
    135e:	6c8000ef          	jal	1a26 <recv>
    1362:	85aa                	mv	a1,a0
  if(cc < 0){
    1364:	02054863          	bltz	a0,1394 <dns+0xb6>
    fprintf(2, "dns: recv() failed\n");
    return 0;
  }

  if(dns_rep(ibuf, cc)){
    1368:	81040513          	addi	a0,s0,-2032
    136c:	c09ff0ef          	jal	f74 <dns_rep>
    1370:	e91d                	bnez	a0,13a6 <dns+0xc8>
    printf("dns: OK\n");
    return 1;
  } else {
    return 0;
  }
}  
    1372:	7e010113          	addi	sp,sp,2016
    1376:	60e2                	ld	ra,24(sp)
    1378:	6442                	ld	s0,16(sp)
    137a:	64a2                	ld	s1,8(sp)
    137c:	6902                	ld	s2,0(sp)
    137e:	6105                	addi	sp,sp,32
    1380:	8082                	ret
    fprintf(2, "dns: send() failed\n");
    1382:	00001597          	auipc	a1,0x1
    1386:	36658593          	addi	a1,a1,870 # 26e8 <malloc+0x846>
    138a:	4509                	li	a0,2
    138c:	235000ef          	jal	1dc0 <fprintf>
    return 0;
    1390:	4501                	li	a0,0
    1392:	b7c5                	j	1372 <dns+0x94>
    fprintf(2, "dns: recv() failed\n");
    1394:	00001597          	auipc	a1,0x1
    1398:	36c58593          	addi	a1,a1,876 # 2700 <malloc+0x85e>
    139c:	4509                	li	a0,2
    139e:	223000ef          	jal	1dc0 <fprintf>
    return 0;
    13a2:	4501                	li	a0,0
    13a4:	b7f9                	j	1372 <dns+0x94>
    printf("dns: OK\n");
    13a6:	00001517          	auipc	a0,0x1
    13aa:	37250513          	addi	a0,a0,882 # 2718 <malloc+0x876>
    13ae:	23d000ef          	jal	1dea <printf>
    return 1;
    13b2:	4505                	li	a0,1
    13b4:	bf7d                	j	1372 <dns+0x94>

00000000000013b6 <usage>:

void
usage()
{
    13b6:	1141                	addi	sp,sp,-16
    13b8:	e406                	sd	ra,8(sp)
    13ba:	e022                	sd	s0,0(sp)
    13bc:	0800                	addi	s0,sp,16
  printf("Usage: nettest txone\n");
    13be:	00001517          	auipc	a0,0x1
    13c2:	36a50513          	addi	a0,a0,874 # 2728 <malloc+0x886>
    13c6:	225000ef          	jal	1dea <printf>
  printf("       nettest tx\n");
    13ca:	00001517          	auipc	a0,0x1
    13ce:	37650513          	addi	a0,a0,886 # 2740 <malloc+0x89e>
    13d2:	219000ef          	jal	1dea <printf>
  printf("       nettest rx\n");
    13d6:	00001517          	auipc	a0,0x1
    13da:	38250513          	addi	a0,a0,898 # 2758 <malloc+0x8b6>
    13de:	20d000ef          	jal	1dea <printf>
  printf("       nettest rx2\n");
    13e2:	00001517          	auipc	a0,0x1
    13e6:	38e50513          	addi	a0,a0,910 # 2770 <malloc+0x8ce>
    13ea:	201000ef          	jal	1dea <printf>
  printf("       nettest rxburst\n");
    13ee:	00001517          	auipc	a0,0x1
    13f2:	39a50513          	addi	a0,a0,922 # 2788 <malloc+0x8e6>
    13f6:	1f5000ef          	jal	1dea <printf>
  printf("       nettest ping1\n");
    13fa:	00001517          	auipc	a0,0x1
    13fe:	3a650513          	addi	a0,a0,934 # 27a0 <malloc+0x8fe>
    1402:	1e9000ef          	jal	1dea <printf>
  printf("       nettest ping2\n");
    1406:	00001517          	auipc	a0,0x1
    140a:	3b250513          	addi	a0,a0,946 # 27b8 <malloc+0x916>
    140e:	1dd000ef          	jal	1dea <printf>
  printf("       nettest ping3\n");
    1412:	00001517          	auipc	a0,0x1
    1416:	3be50513          	addi	a0,a0,958 # 27d0 <malloc+0x92e>
    141a:	1d1000ef          	jal	1dea <printf>
  printf("       nettest dns\n");
    141e:	00001517          	auipc	a0,0x1
    1422:	3ca50513          	addi	a0,a0,970 # 27e8 <malloc+0x946>
    1426:	1c5000ef          	jal	1dea <printf>
  printf("       nettest grade\n");
    142a:	00001517          	auipc	a0,0x1
    142e:	3d650513          	addi	a0,a0,982 # 2800 <malloc+0x95e>
    1432:	1b9000ef          	jal	1dea <printf>
  exit(1);
    1436:	4505                	li	a0,1
    1438:	536000ef          	jal	196e <exit>

000000000000143c <countfree>:
// because out of memory with lazy allocation results in the process
// taking a fault and being killed, fork and report back.
//
int
countfree()
{
    143c:	7139                	addi	sp,sp,-64
    143e:	fc06                	sd	ra,56(sp)
    1440:	f822                	sd	s0,48(sp)
    1442:	0080                	addi	s0,sp,64
  int fds[2];

  if(pipe(fds) < 0){
    1444:	fc840513          	addi	a0,s0,-56
    1448:	536000ef          	jal	197e <pipe>
    144c:	04054f63          	bltz	a0,14aa <countfree+0x6e>
    printf("pipe() failed in countfree()\n");
    exit(1);
  }
  
  int pid = fork();
    1450:	516000ef          	jal	1966 <fork>

  if(pid < 0){
    1454:	06054863          	bltz	a0,14c4 <countfree+0x88>
    printf("fork failed in countfree()\n");
    exit(1);
  }

  if(pid == 0){
    1458:	e551                	bnez	a0,14e4 <countfree+0xa8>
    145a:	f426                	sd	s1,40(sp)
    145c:	f04a                	sd	s2,32(sp)
    145e:	ec4e                	sd	s3,24(sp)
    1460:	e852                	sd	s4,16(sp)
    close(fds[0]);
    1462:	fc842503          	lw	a0,-56(s0)
    1466:	530000ef          	jal	1996 <close>
    
    while(1){
      uint64 a = (uint64) sbrk(4096);
    146a:	6905                	lui	s2,0x1
      if(a == 0xffffffffffffffff){
    146c:	59fd                	li	s3,-1
        break;
      }

      // modify the memory to make sure it's really allocated.
      *(char *)(a + 4096 - 1) = 1;
    146e:	4485                	li	s1,1

      // report back one more page.
      if(write(fds[1], "x", 1) != 1){
    1470:	00001a17          	auipc	s4,0x1
    1474:	0a0a0a13          	addi	s4,s4,160 # 2510 <malloc+0x66e>
      uint64 a = (uint64) sbrk(4096);
    1478:	854a                	mv	a0,s2
    147a:	4c0000ef          	jal	193a <sbrk>
      if(a == 0xffffffffffffffff){
    147e:	07350063          	beq	a0,s3,14de <countfree+0xa2>
      *(char *)(a + 4096 - 1) = 1;
    1482:	954a                	add	a0,a0,s2
    1484:	fe950fa3          	sb	s1,-1(a0)
      if(write(fds[1], "x", 1) != 1){
    1488:	8626                	mv	a2,s1
    148a:	85d2                	mv	a1,s4
    148c:	fcc42503          	lw	a0,-52(s0)
    1490:	4fe000ef          	jal	198e <write>
    1494:	fe9502e3          	beq	a0,s1,1478 <countfree+0x3c>
        printf("write() failed in countfree()\n");
    1498:	00001517          	auipc	a0,0x1
    149c:	3c050513          	addi	a0,a0,960 # 2858 <malloc+0x9b6>
    14a0:	14b000ef          	jal	1dea <printf>
        exit(1);
    14a4:	4505                	li	a0,1
    14a6:	4c8000ef          	jal	196e <exit>
    14aa:	f426                	sd	s1,40(sp)
    14ac:	f04a                	sd	s2,32(sp)
    14ae:	ec4e                	sd	s3,24(sp)
    14b0:	e852                	sd	s4,16(sp)
    printf("pipe() failed in countfree()\n");
    14b2:	00001517          	auipc	a0,0x1
    14b6:	36650513          	addi	a0,a0,870 # 2818 <malloc+0x976>
    14ba:	131000ef          	jal	1dea <printf>
    exit(1);
    14be:	4505                	li	a0,1
    14c0:	4ae000ef          	jal	196e <exit>
    14c4:	f426                	sd	s1,40(sp)
    14c6:	f04a                	sd	s2,32(sp)
    14c8:	ec4e                	sd	s3,24(sp)
    14ca:	e852                	sd	s4,16(sp)
    printf("fork failed in countfree()\n");
    14cc:	00001517          	auipc	a0,0x1
    14d0:	36c50513          	addi	a0,a0,876 # 2838 <malloc+0x996>
    14d4:	117000ef          	jal	1dea <printf>
    exit(1);
    14d8:	4505                	li	a0,1
    14da:	494000ef          	jal	196e <exit>
      }
    }

    exit(0);
    14de:	4501                	li	a0,0
    14e0:	48e000ef          	jal	196e <exit>
    14e4:	f426                	sd	s1,40(sp)
    14e6:	f04a                	sd	s2,32(sp)
    14e8:	ec4e                	sd	s3,24(sp)
  }

  close(fds[1]);
    14ea:	fcc42503          	lw	a0,-52(s0)
    14ee:	4a8000ef          	jal	1996 <close>

  int n = 0;
    14f2:	4481                	li	s1,0
  while(1){
    char c;
    int cc = read(fds[0], &c, 1);
    14f4:	fc740993          	addi	s3,s0,-57
    14f8:	4905                	li	s2,1
    14fa:	864a                	mv	a2,s2
    14fc:	85ce                	mv	a1,s3
    14fe:	fc842503          	lw	a0,-56(s0)
    1502:	484000ef          	jal	1986 <read>
    if(cc < 0){
    1506:	00054563          	bltz	a0,1510 <countfree+0xd4>
      printf("read() failed in countfree()\n");
      exit(1);
    }
    if(cc == 0)
    150a:	cd09                	beqz	a0,1524 <countfree+0xe8>
      break;
    n += 1;
    150c:	2485                	addiw	s1,s1,1
  while(1){
    150e:	b7f5                	j	14fa <countfree+0xbe>
    1510:	e852                	sd	s4,16(sp)
      printf("read() failed in countfree()\n");
    1512:	00001517          	auipc	a0,0x1
    1516:	36650513          	addi	a0,a0,870 # 2878 <malloc+0x9d6>
    151a:	0d1000ef          	jal	1dea <printf>
      exit(1);
    151e:	4505                	li	a0,1
    1520:	44e000ef          	jal	196e <exit>
  }

  close(fds[0]);
    1524:	fc842503          	lw	a0,-56(s0)
    1528:	46e000ef          	jal	1996 <close>
  wait((int*)0);
    152c:	4501                	li	a0,0
    152e:	448000ef          	jal	1976 <wait>
  
  return n;
}
    1532:	8526                	mv	a0,s1
    1534:	74a2                	ld	s1,40(sp)
    1536:	7902                	ld	s2,32(sp)
    1538:	69e2                	ld	s3,24(sp)
    153a:	70e2                	ld	ra,56(sp)
    153c:	7442                	ld	s0,48(sp)
    153e:	6121                	addi	sp,sp,64
    1540:	8082                	ret

0000000000001542 <main>:

int
main(int argc, char *argv[])
{
    1542:	1101                	addi	sp,sp,-32
    1544:	ec06                	sd	ra,24(sp)
    1546:	e822                	sd	s0,16(sp)
    1548:	1000                	addi	s0,sp,32
  if(argc != 2)
    154a:	4789                	li	a5,2
    154c:	00f50563          	beq	a0,a5,1556 <main+0x14>
    1550:	e426                	sd	s1,8(sp)
    usage();
    1552:	e65ff0ef          	jal	13b6 <usage>
    1556:	e426                	sd	s1,8(sp)
    1558:	84ae                	mv	s1,a1

  if(strcmp(argv[1], "txone") == 0){
    155a:	00001597          	auipc	a1,0x1
    155e:	33e58593          	addi	a1,a1,830 # 2898 <malloc+0x9f6>
    1562:	6488                	ld	a0,8(s1)
    1564:	184000ef          	jal	16e8 <strcmp>
    1568:	e511                	bnez	a0,1574 <main+0x32>
    txone();
    156a:	a97fe0ef          	jal	0 <txone>
    dns();
  } else {
    usage();
  }

  exit(0);
    156e:	4501                	li	a0,0
    1570:	3fe000ef          	jal	196e <exit>
  } else if(strcmp(argv[1], "rx") == 0 || strcmp(argv[1], "rxburst") == 0){
    1574:	00001597          	auipc	a1,0x1
    1578:	32c58593          	addi	a1,a1,812 # 28a0 <malloc+0x9fe>
    157c:	6488                	ld	a0,8(s1)
    157e:	16a000ef          	jal	16e8 <strcmp>
    1582:	c909                	beqz	a0,1594 <main+0x52>
    1584:	00001597          	auipc	a1,0x1
    1588:	32458593          	addi	a1,a1,804 # 28a8 <malloc+0xa06>
    158c:	6488                	ld	a0,8(s1)
    158e:	15a000ef          	jal	16e8 <strcmp>
    1592:	e509                	bnez	a0,159c <main+0x5a>
    rx(argv[1]);
    1594:	6488                	ld	a0,8(s1)
    1596:	addfe0ef          	jal	72 <rx>
    159a:	bfd1                	j	156e <main+0x2c>
  } else if(strcmp(argv[1], "rx2") == 0){
    159c:	00001597          	auipc	a1,0x1
    15a0:	31458593          	addi	a1,a1,788 # 28b0 <malloc+0xa0e>
    15a4:	6488                	ld	a0,8(s1)
    15a6:	142000ef          	jal	16e8 <strcmp>
    15aa:	e501                	bnez	a0,15b2 <main+0x70>
    rx2();
    15ac:	cbbfe0ef          	jal	266 <rx2>
    15b0:	bf7d                	j	156e <main+0x2c>
  } else if(strcmp(argv[1], "tx") == 0){
    15b2:	00001597          	auipc	a1,0x1
    15b6:	30658593          	addi	a1,a1,774 # 28b8 <malloc+0xa16>
    15ba:	6488                	ld	a0,8(s1)
    15bc:	12c000ef          	jal	16e8 <strcmp>
    15c0:	e501                	bnez	a0,15c8 <main+0x86>
    tx();
    15c2:	f7ffe0ef          	jal	540 <tx>
    15c6:	b765                	j	156e <main+0x2c>
  } else if(strcmp(argv[1], "ping0") == 0){
    15c8:	00001597          	auipc	a1,0x1
    15cc:	c0858593          	addi	a1,a1,-1016 # 21d0 <malloc+0x32e>
    15d0:	6488                	ld	a0,8(s1)
    15d2:	116000ef          	jal	16e8 <strcmp>
    15d6:	e501                	bnez	a0,15de <main+0x9c>
    ping0();
    15d8:	800ff0ef          	jal	5d8 <ping0>
    15dc:	bf49                	j	156e <main+0x2c>
  } else if(strcmp(argv[1], "ping1") == 0){
    15de:	00001597          	auipc	a1,0x1
    15e2:	2e258593          	addi	a1,a1,738 # 28c0 <malloc+0xa1e>
    15e6:	6488                	ld	a0,8(s1)
    15e8:	100000ef          	jal	16e8 <strcmp>
    15ec:	e501                	bnez	a0,15f4 <main+0xb2>
    ping1();
    15ee:	930ff0ef          	jal	71e <ping1>
    15f2:	bfb5                	j	156e <main+0x2c>
  } else if(strcmp(argv[1], "ping2") == 0){
    15f4:	00001597          	auipc	a1,0x1
    15f8:	2d458593          	addi	a1,a1,724 # 28c8 <malloc+0xa26>
    15fc:	6488                	ld	a0,8(s1)
    15fe:	0ea000ef          	jal	16e8 <strcmp>
    1602:	e501                	bnez	a0,160a <main+0xc8>
    ping2();
    1604:	a80ff0ef          	jal	884 <ping2>
    1608:	b79d                	j	156e <main+0x2c>
  } else if(strcmp(argv[1], "ping3") == 0){
    160a:	00001597          	auipc	a1,0x1
    160e:	2c658593          	addi	a1,a1,710 # 28d0 <malloc+0xa2e>
    1612:	6488                	ld	a0,8(s1)
    1614:	0d4000ef          	jal	16e8 <strcmp>
    1618:	e501                	bnez	a0,1620 <main+0xde>
    ping3();
    161a:	c7eff0ef          	jal	a98 <ping3>
    161e:	bf81                	j	156e <main+0x2c>
  } else if(strcmp(argv[1], "grade") == 0){
    1620:	00001597          	auipc	a1,0x1
    1624:	2b858593          	addi	a1,a1,696 # 28d8 <malloc+0xa36>
    1628:	6488                	ld	a0,8(s1)
    162a:	0be000ef          	jal	16e8 <strcmp>
    162e:	e925                	bnez	a0,169e <main+0x15c>
    int free0 = countfree();
    1630:	e0dff0ef          	jal	143c <countfree>
    1634:	84aa                	mv	s1,a0
    txone();
    1636:	9cbfe0ef          	jal	0 <txone>
    pause(2);
    163a:	4509                	li	a0,2
    163c:	3c2000ef          	jal	19fe <pause>
    ping0();
    1640:	f99fe0ef          	jal	5d8 <ping0>
    pause(2);
    1644:	4509                	li	a0,2
    1646:	3b8000ef          	jal	19fe <pause>
    ping1();
    164a:	8d4ff0ef          	jal	71e <ping1>
    pause(2);
    164e:	4509                	li	a0,2
    1650:	3ae000ef          	jal	19fe <pause>
    ping2();
    1654:	a30ff0ef          	jal	884 <ping2>
    pause(2);
    1658:	4509                	li	a0,2
    165a:	3a4000ef          	jal	19fe <pause>
    ping3();
    165e:	c3aff0ef          	jal	a98 <ping3>
    pause(2);
    1662:	4509                	li	a0,2
    1664:	39a000ef          	jal	19fe <pause>
    dns();
    1668:	c77ff0ef          	jal	12de <dns>
    pause(2);
    166c:	4509                	li	a0,2
    166e:	390000ef          	jal	19fe <pause>
    if ((free1 = countfree()) + 32 < free0) {
    1672:	dcbff0ef          	jal	143c <countfree>
    1676:	85aa                	mv	a1,a0
    1678:	0205079b          	addiw	a5,a0,32
    167c:	0097da63          	bge	a5,s1,1690 <main+0x14e>
      printf("free: FAILED -- lost too many free pages %d (out of %d)\n", free1, free0);
    1680:	8626                	mv	a2,s1
    1682:	00001517          	auipc	a0,0x1
    1686:	25e50513          	addi	a0,a0,606 # 28e0 <malloc+0xa3e>
    168a:	760000ef          	jal	1dea <printf>
    168e:	b5c5                	j	156e <main+0x2c>
      printf("free: OK\n");
    1690:	00001517          	auipc	a0,0x1
    1694:	29050513          	addi	a0,a0,656 # 2920 <malloc+0xa7e>
    1698:	752000ef          	jal	1dea <printf>
    169c:	bdc9                	j	156e <main+0x2c>
  } else if(strcmp(argv[1], "dns") == 0){
    169e:	00001597          	auipc	a1,0x1
    16a2:	29258593          	addi	a1,a1,658 # 2930 <malloc+0xa8e>
    16a6:	6488                	ld	a0,8(s1)
    16a8:	040000ef          	jal	16e8 <strcmp>
    16ac:	e501                	bnez	a0,16b4 <main+0x172>
    dns();
    16ae:	c31ff0ef          	jal	12de <dns>
    16b2:	bd75                	j	156e <main+0x2c>
    usage();
    16b4:	d03ff0ef          	jal	13b6 <usage>

00000000000016b8 <start>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
start(int argc, char **argv)
{
    16b8:	1141                	addi	sp,sp,-16
    16ba:	e406                	sd	ra,8(sp)
    16bc:	e022                	sd	s0,0(sp)
    16be:	0800                	addi	s0,sp,16
  int r;
  extern int main(int argc, char **argv);
  r = main(argc, argv);
    16c0:	e83ff0ef          	jal	1542 <main>
  exit(r);
    16c4:	2aa000ef          	jal	196e <exit>

00000000000016c8 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
    16c8:	1141                	addi	sp,sp,-16
    16ca:	e406                	sd	ra,8(sp)
    16cc:	e022                	sd	s0,0(sp)
    16ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
    16d0:	87aa                	mv	a5,a0
    16d2:	0585                	addi	a1,a1,1
    16d4:	0785                	addi	a5,a5,1
    16d6:	fff5c703          	lbu	a4,-1(a1)
    16da:	fee78fa3          	sb	a4,-1(a5)
    16de:	fb75                	bnez	a4,16d2 <strcpy+0xa>
    ;
  return os;
}
    16e0:	60a2                	ld	ra,8(sp)
    16e2:	6402                	ld	s0,0(sp)
    16e4:	0141                	addi	sp,sp,16
    16e6:	8082                	ret

00000000000016e8 <strcmp>:

int
strcmp(const char *p, const char *q)
{
    16e8:	1141                	addi	sp,sp,-16
    16ea:	e406                	sd	ra,8(sp)
    16ec:	e022                	sd	s0,0(sp)
    16ee:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
    16f0:	00054783          	lbu	a5,0(a0)
    16f4:	cb91                	beqz	a5,1708 <strcmp+0x20>
    16f6:	0005c703          	lbu	a4,0(a1)
    16fa:	00f71763          	bne	a4,a5,1708 <strcmp+0x20>
    p++, q++;
    16fe:	0505                	addi	a0,a0,1
    1700:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
    1702:	00054783          	lbu	a5,0(a0)
    1706:	fbe5                	bnez	a5,16f6 <strcmp+0xe>
  return (uchar)*p - (uchar)*q;
    1708:	0005c503          	lbu	a0,0(a1)
}
    170c:	40a7853b          	subw	a0,a5,a0
    1710:	60a2                	ld	ra,8(sp)
    1712:	6402                	ld	s0,0(sp)
    1714:	0141                	addi	sp,sp,16
    1716:	8082                	ret

0000000000001718 <strlen>:

uint
strlen(const char *s)
{
    1718:	1141                	addi	sp,sp,-16
    171a:	e406                	sd	ra,8(sp)
    171c:	e022                	sd	s0,0(sp)
    171e:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    1720:	00054783          	lbu	a5,0(a0)
    1724:	cf91                	beqz	a5,1740 <strlen+0x28>
    1726:	00150793          	addi	a5,a0,1
    172a:	86be                	mv	a3,a5
    172c:	0785                	addi	a5,a5,1
    172e:	fff7c703          	lbu	a4,-1(a5)
    1732:	ff65                	bnez	a4,172a <strlen+0x12>
    1734:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    1738:	60a2                	ld	ra,8(sp)
    173a:	6402                	ld	s0,0(sp)
    173c:	0141                	addi	sp,sp,16
    173e:	8082                	ret
  for(n = 0; s[n]; n++)
    1740:	4501                	li	a0,0
    1742:	bfdd                	j	1738 <strlen+0x20>

0000000000001744 <memset>:

void*
memset(void *dst, int c, uint n)
{
    1744:	1141                	addi	sp,sp,-16
    1746:	e406                	sd	ra,8(sp)
    1748:	e022                	sd	s0,0(sp)
    174a:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    174c:	ca19                	beqz	a2,1762 <memset+0x1e>
    174e:	87aa                	mv	a5,a0
    1750:	1602                	slli	a2,a2,0x20
    1752:	9201                	srli	a2,a2,0x20
    1754:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    1758:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    175c:	0785                	addi	a5,a5,1
    175e:	fee79de3          	bne	a5,a4,1758 <memset+0x14>
  }
  return dst;
}
    1762:	60a2                	ld	ra,8(sp)
    1764:	6402                	ld	s0,0(sp)
    1766:	0141                	addi	sp,sp,16
    1768:	8082                	ret

000000000000176a <strchr>:

char*
strchr(const char *s, char c)
{
    176a:	1141                	addi	sp,sp,-16
    176c:	e406                	sd	ra,8(sp)
    176e:	e022                	sd	s0,0(sp)
    1770:	0800                	addi	s0,sp,16
  for(; *s; s++)
    1772:	00054783          	lbu	a5,0(a0)
    1776:	cf81                	beqz	a5,178e <strchr+0x24>
    if(*s == c)
    1778:	00f58763          	beq	a1,a5,1786 <strchr+0x1c>
  for(; *s; s++)
    177c:	0505                	addi	a0,a0,1
    177e:	00054783          	lbu	a5,0(a0)
    1782:	fbfd                	bnez	a5,1778 <strchr+0xe>
      return (char*)s;
  return 0;
    1784:	4501                	li	a0,0
}
    1786:	60a2                	ld	ra,8(sp)
    1788:	6402                	ld	s0,0(sp)
    178a:	0141                	addi	sp,sp,16
    178c:	8082                	ret
  return 0;
    178e:	4501                	li	a0,0
    1790:	bfdd                	j	1786 <strchr+0x1c>

0000000000001792 <gets>:

char*
gets(char *buf, int max)
{
    1792:	711d                	addi	sp,sp,-96
    1794:	ec86                	sd	ra,88(sp)
    1796:	e8a2                	sd	s0,80(sp)
    1798:	e4a6                	sd	s1,72(sp)
    179a:	e0ca                	sd	s2,64(sp)
    179c:	fc4e                	sd	s3,56(sp)
    179e:	f852                	sd	s4,48(sp)
    17a0:	f456                	sd	s5,40(sp)
    17a2:	f05a                	sd	s6,32(sp)
    17a4:	ec5e                	sd	s7,24(sp)
    17a6:	e862                	sd	s8,16(sp)
    17a8:	1080                	addi	s0,sp,96
    17aa:	8baa                	mv	s7,a0
    17ac:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
    17ae:	892a                	mv	s2,a0
    17b0:	4481                	li	s1,0
    cc = read(0, &c, 1);
    17b2:	faf40b13          	addi	s6,s0,-81
    17b6:	4a85                	li	s5,1
  for(i=0; i+1 < max; ){
    17b8:	8c26                	mv	s8,s1
    17ba:	0014899b          	addiw	s3,s1,1
    17be:	84ce                	mv	s1,s3
    17c0:	0349d463          	bge	s3,s4,17e8 <gets+0x56>
    cc = read(0, &c, 1);
    17c4:	8656                	mv	a2,s5
    17c6:	85da                	mv	a1,s6
    17c8:	4501                	li	a0,0
    17ca:	1bc000ef          	jal	1986 <read>
    if(cc < 1)
    17ce:	00a05d63          	blez	a0,17e8 <gets+0x56>
      break;
    buf[i++] = c;
    17d2:	faf44783          	lbu	a5,-81(s0)
    17d6:	00f90023          	sb	a5,0(s2) # 1000 <dns_rep+0x8c>
    if(c == '\n' || c == '\r')
    17da:	0905                	addi	s2,s2,1
    17dc:	ff678713          	addi	a4,a5,-10
    17e0:	c319                	beqz	a4,17e6 <gets+0x54>
    17e2:	17cd                	addi	a5,a5,-13
    17e4:	fbf1                	bnez	a5,17b8 <gets+0x26>
    buf[i++] = c;
    17e6:	8c4e                	mv	s8,s3
      break;
  }
  buf[i] = '\0';
    17e8:	9c5e                	add	s8,s8,s7
    17ea:	000c0023          	sb	zero,0(s8)
  return buf;
}
    17ee:	855e                	mv	a0,s7
    17f0:	60e6                	ld	ra,88(sp)
    17f2:	6446                	ld	s0,80(sp)
    17f4:	64a6                	ld	s1,72(sp)
    17f6:	6906                	ld	s2,64(sp)
    17f8:	79e2                	ld	s3,56(sp)
    17fa:	7a42                	ld	s4,48(sp)
    17fc:	7aa2                	ld	s5,40(sp)
    17fe:	7b02                	ld	s6,32(sp)
    1800:	6be2                	ld	s7,24(sp)
    1802:	6c42                	ld	s8,16(sp)
    1804:	6125                	addi	sp,sp,96
    1806:	8082                	ret

0000000000001808 <stat>:

int
stat(const char *n, struct stat *st)
{
    1808:	1101                	addi	sp,sp,-32
    180a:	ec06                	sd	ra,24(sp)
    180c:	e822                	sd	s0,16(sp)
    180e:	e04a                	sd	s2,0(sp)
    1810:	1000                	addi	s0,sp,32
    1812:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
    1814:	4581                	li	a1,0
    1816:	198000ef          	jal	19ae <open>
  if(fd < 0)
    181a:	02054263          	bltz	a0,183e <stat+0x36>
    181e:	e426                	sd	s1,8(sp)
    1820:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
    1822:	85ca                	mv	a1,s2
    1824:	1a2000ef          	jal	19c6 <fstat>
    1828:	892a                	mv	s2,a0
  close(fd);
    182a:	8526                	mv	a0,s1
    182c:	16a000ef          	jal	1996 <close>
  return r;
    1830:	64a2                	ld	s1,8(sp)
}
    1832:	854a                	mv	a0,s2
    1834:	60e2                	ld	ra,24(sp)
    1836:	6442                	ld	s0,16(sp)
    1838:	6902                	ld	s2,0(sp)
    183a:	6105                	addi	sp,sp,32
    183c:	8082                	ret
    return -1;
    183e:	57fd                	li	a5,-1
    1840:	893e                	mv	s2,a5
    1842:	bfc5                	j	1832 <stat+0x2a>

0000000000001844 <atoi>:

int
atoi(const char *s)
{
    1844:	1141                	addi	sp,sp,-16
    1846:	e406                	sd	ra,8(sp)
    1848:	e022                	sd	s0,0(sp)
    184a:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
    184c:	00054683          	lbu	a3,0(a0)
    1850:	fd06879b          	addiw	a5,a3,-48
    1854:	0ff7f793          	zext.b	a5,a5
    1858:	4625                	li	a2,9
    185a:	02f66963          	bltu	a2,a5,188c <atoi+0x48>
    185e:	872a                	mv	a4,a0
  n = 0;
    1860:	4501                	li	a0,0
    n = n*10 + *s++ - '0';
    1862:	0705                	addi	a4,a4,1
    1864:	0025179b          	slliw	a5,a0,0x2
    1868:	9fa9                	addw	a5,a5,a0
    186a:	0017979b          	slliw	a5,a5,0x1
    186e:	9fb5                	addw	a5,a5,a3
    1870:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
    1874:	00074683          	lbu	a3,0(a4)
    1878:	fd06879b          	addiw	a5,a3,-48
    187c:	0ff7f793          	zext.b	a5,a5
    1880:	fef671e3          	bgeu	a2,a5,1862 <atoi+0x1e>
  return n;
}
    1884:	60a2                	ld	ra,8(sp)
    1886:	6402                	ld	s0,0(sp)
    1888:	0141                	addi	sp,sp,16
    188a:	8082                	ret
  n = 0;
    188c:	4501                	li	a0,0
    188e:	bfdd                	j	1884 <atoi+0x40>

0000000000001890 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
    1890:	1141                	addi	sp,sp,-16
    1892:	e406                	sd	ra,8(sp)
    1894:	e022                	sd	s0,0(sp)
    1896:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
    1898:	02b57563          	bgeu	a0,a1,18c2 <memmove+0x32>
    while(n-- > 0)
    189c:	00c05f63          	blez	a2,18ba <memmove+0x2a>
    18a0:	1602                	slli	a2,a2,0x20
    18a2:	9201                	srli	a2,a2,0x20
    18a4:	00c507b3          	add	a5,a0,a2
  dst = vdst;
    18a8:	872a                	mv	a4,a0
      *dst++ = *src++;
    18aa:	0585                	addi	a1,a1,1
    18ac:	0705                	addi	a4,a4,1
    18ae:	fff5c683          	lbu	a3,-1(a1)
    18b2:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    18b6:	fee79ae3          	bne	a5,a4,18aa <memmove+0x1a>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
    18ba:	60a2                	ld	ra,8(sp)
    18bc:	6402                	ld	s0,0(sp)
    18be:	0141                	addi	sp,sp,16
    18c0:	8082                	ret
    while(n-- > 0)
    18c2:	fec05ce3          	blez	a2,18ba <memmove+0x2a>
    dst += n;
    18c6:	00c50733          	add	a4,a0,a2
    src += n;
    18ca:	95b2                	add	a1,a1,a2
    18cc:	fff6079b          	addiw	a5,a2,-1
    18d0:	1782                	slli	a5,a5,0x20
    18d2:	9381                	srli	a5,a5,0x20
    18d4:	fff7c793          	not	a5,a5
    18d8:	97ba                	add	a5,a5,a4
      *--dst = *--src;
    18da:	15fd                	addi	a1,a1,-1
    18dc:	177d                	addi	a4,a4,-1
    18de:	0005c683          	lbu	a3,0(a1)
    18e2:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
    18e6:	fef71ae3          	bne	a4,a5,18da <memmove+0x4a>
    18ea:	bfc1                	j	18ba <memmove+0x2a>

00000000000018ec <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
    18ec:	1141                	addi	sp,sp,-16
    18ee:	e406                	sd	ra,8(sp)
    18f0:	e022                	sd	s0,0(sp)
    18f2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
    18f4:	c61d                	beqz	a2,1922 <memcmp+0x36>
    18f6:	1602                	slli	a2,a2,0x20
    18f8:	9201                	srli	a2,a2,0x20
    18fa:	00c506b3          	add	a3,a0,a2
    if (*p1 != *p2) {
    18fe:	00054783          	lbu	a5,0(a0)
    1902:	0005c703          	lbu	a4,0(a1)
    1906:	00e79863          	bne	a5,a4,1916 <memcmp+0x2a>
      return *p1 - *p2;
    }
    p1++;
    190a:	0505                	addi	a0,a0,1
    p2++;
    190c:	0585                	addi	a1,a1,1
  while (n-- > 0) {
    190e:	fed518e3          	bne	a0,a3,18fe <memcmp+0x12>
  }
  return 0;
    1912:	4501                	li	a0,0
    1914:	a019                	j	191a <memcmp+0x2e>
      return *p1 - *p2;
    1916:	40e7853b          	subw	a0,a5,a4
}
    191a:	60a2                	ld	ra,8(sp)
    191c:	6402                	ld	s0,0(sp)
    191e:	0141                	addi	sp,sp,16
    1920:	8082                	ret
  return 0;
    1922:	4501                	li	a0,0
    1924:	bfdd                	j	191a <memcmp+0x2e>

0000000000001926 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
    1926:	1141                	addi	sp,sp,-16
    1928:	e406                	sd	ra,8(sp)
    192a:	e022                	sd	s0,0(sp)
    192c:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    192e:	f63ff0ef          	jal	1890 <memmove>
}
    1932:	60a2                	ld	ra,8(sp)
    1934:	6402                	ld	s0,0(sp)
    1936:	0141                	addi	sp,sp,16
    1938:	8082                	ret

000000000000193a <sbrk>:

char *
sbrk(int n) {
    193a:	1141                	addi	sp,sp,-16
    193c:	e406                	sd	ra,8(sp)
    193e:	e022                	sd	s0,0(sp)
    1940:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_EAGER);
    1942:	4585                	li	a1,1
    1944:	0b2000ef          	jal	19f6 <sys_sbrk>
}
    1948:	60a2                	ld	ra,8(sp)
    194a:	6402                	ld	s0,0(sp)
    194c:	0141                	addi	sp,sp,16
    194e:	8082                	ret

0000000000001950 <sbrklazy>:

char *
sbrklazy(int n) {
    1950:	1141                	addi	sp,sp,-16
    1952:	e406                	sd	ra,8(sp)
    1954:	e022                	sd	s0,0(sp)
    1956:	0800                	addi	s0,sp,16
  return sys_sbrk(n, SBRK_LAZY);
    1958:	4589                	li	a1,2
    195a:	09c000ef          	jal	19f6 <sys_sbrk>
}
    195e:	60a2                	ld	ra,8(sp)
    1960:	6402                	ld	s0,0(sp)
    1962:	0141                	addi	sp,sp,16
    1964:	8082                	ret

0000000000001966 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
    1966:	4885                	li	a7,1
 ecall
    1968:	00000073          	ecall
 ret
    196c:	8082                	ret

000000000000196e <exit>:
.global exit
exit:
 li a7, SYS_exit
    196e:	4889                	li	a7,2
 ecall
    1970:	00000073          	ecall
 ret
    1974:	8082                	ret

0000000000001976 <wait>:
.global wait
wait:
 li a7, SYS_wait
    1976:	488d                	li	a7,3
 ecall
    1978:	00000073          	ecall
 ret
    197c:	8082                	ret

000000000000197e <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
    197e:	4891                	li	a7,4
 ecall
    1980:	00000073          	ecall
 ret
    1984:	8082                	ret

0000000000001986 <read>:
.global read
read:
 li a7, SYS_read
    1986:	4895                	li	a7,5
 ecall
    1988:	00000073          	ecall
 ret
    198c:	8082                	ret

000000000000198e <write>:
.global write
write:
 li a7, SYS_write
    198e:	48c1                	li	a7,16
 ecall
    1990:	00000073          	ecall
 ret
    1994:	8082                	ret

0000000000001996 <close>:
.global close
close:
 li a7, SYS_close
    1996:	48d5                	li	a7,21
 ecall
    1998:	00000073          	ecall
 ret
    199c:	8082                	ret

000000000000199e <kill>:
.global kill
kill:
 li a7, SYS_kill
    199e:	4899                	li	a7,6
 ecall
    19a0:	00000073          	ecall
 ret
    19a4:	8082                	ret

00000000000019a6 <exec>:
.global exec
exec:
 li a7, SYS_exec
    19a6:	489d                	li	a7,7
 ecall
    19a8:	00000073          	ecall
 ret
    19ac:	8082                	ret

00000000000019ae <open>:
.global open
open:
 li a7, SYS_open
    19ae:	48bd                	li	a7,15
 ecall
    19b0:	00000073          	ecall
 ret
    19b4:	8082                	ret

00000000000019b6 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
    19b6:	48c5                	li	a7,17
 ecall
    19b8:	00000073          	ecall
 ret
    19bc:	8082                	ret

00000000000019be <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
    19be:	48c9                	li	a7,18
 ecall
    19c0:	00000073          	ecall
 ret
    19c4:	8082                	ret

00000000000019c6 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
    19c6:	48a1                	li	a7,8
 ecall
    19c8:	00000073          	ecall
 ret
    19cc:	8082                	ret

00000000000019ce <link>:
.global link
link:
 li a7, SYS_link
    19ce:	48cd                	li	a7,19
 ecall
    19d0:	00000073          	ecall
 ret
    19d4:	8082                	ret

00000000000019d6 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
    19d6:	48d1                	li	a7,20
 ecall
    19d8:	00000073          	ecall
 ret
    19dc:	8082                	ret

00000000000019de <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
    19de:	48a5                	li	a7,9
 ecall
    19e0:	00000073          	ecall
 ret
    19e4:	8082                	ret

00000000000019e6 <dup>:
.global dup
dup:
 li a7, SYS_dup
    19e6:	48a9                	li	a7,10
 ecall
    19e8:	00000073          	ecall
 ret
    19ec:	8082                	ret

00000000000019ee <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
    19ee:	48ad                	li	a7,11
 ecall
    19f0:	00000073          	ecall
 ret
    19f4:	8082                	ret

00000000000019f6 <sys_sbrk>:
.global sys_sbrk
sys_sbrk:
 li a7, SYS_sbrk
    19f6:	48b1                	li	a7,12
 ecall
    19f8:	00000073          	ecall
 ret
    19fc:	8082                	ret

00000000000019fe <pause>:
.global pause
pause:
 li a7, SYS_pause
    19fe:	48b5                	li	a7,13
 ecall
    1a00:	00000073          	ecall
 ret
    1a04:	8082                	ret

0000000000001a06 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
    1a06:	48b9                	li	a7,14
 ecall
    1a08:	00000073          	ecall
 ret
    1a0c:	8082                	ret

0000000000001a0e <bind>:
.global bind
bind:
 li a7, SYS_bind
    1a0e:	48f5                	li	a7,29
 ecall
    1a10:	00000073          	ecall
 ret
    1a14:	8082                	ret

0000000000001a16 <unbind>:
.global unbind
unbind:
 li a7, SYS_unbind
    1a16:	48f9                	li	a7,30
 ecall
    1a18:	00000073          	ecall
 ret
    1a1c:	8082                	ret

0000000000001a1e <send>:
.global send
send:
 li a7, SYS_send
    1a1e:	48fd                	li	a7,31
 ecall
    1a20:	00000073          	ecall
 ret
    1a24:	8082                	ret

0000000000001a26 <recv>:
.global recv
recv:
 li a7, SYS_recv
    1a26:	02000893          	li	a7,32
 ecall
    1a2a:	00000073          	ecall
 ret
    1a2e:	8082                	ret

0000000000001a30 <pgpte>:
.global pgpte
pgpte:
 li a7, SYS_pgpte
    1a30:	02100893          	li	a7,33
 ecall
    1a34:	00000073          	ecall
 ret
    1a38:	8082                	ret

0000000000001a3a <kpgtbl>:
.global kpgtbl
kpgtbl:
 li a7, SYS_kpgtbl
    1a3a:	02200893          	li	a7,34
 ecall
    1a3e:	00000073          	ecall
 ret
    1a42:	8082                	ret

0000000000001a44 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
    1a44:	1101                	addi	sp,sp,-32
    1a46:	ec06                	sd	ra,24(sp)
    1a48:	e822                	sd	s0,16(sp)
    1a4a:	1000                	addi	s0,sp,32
    1a4c:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
    1a50:	4605                	li	a2,1
    1a52:	fef40593          	addi	a1,s0,-17
    1a56:	f39ff0ef          	jal	198e <write>
}
    1a5a:	60e2                	ld	ra,24(sp)
    1a5c:	6442                	ld	s0,16(sp)
    1a5e:	6105                	addi	sp,sp,32
    1a60:	8082                	ret

0000000000001a62 <printint>:

static void
printint(int fd, long long xx, int base, int sgn)
{
    1a62:	715d                	addi	sp,sp,-80
    1a64:	e486                	sd	ra,72(sp)
    1a66:	e0a2                	sd	s0,64(sp)
    1a68:	f84a                	sd	s2,48(sp)
    1a6a:	f44e                	sd	s3,40(sp)
    1a6c:	0880                	addi	s0,sp,80
    1a6e:	892a                	mv	s2,a0
  char buf[20];
  int i, neg;
  unsigned long long x;

  neg = 0;
  if(sgn && xx < 0){
    1a70:	c6d1                	beqz	a3,1afc <printint+0x9a>
    1a72:	0805d563          	bgez	a1,1afc <printint+0x9a>
    neg = 1;
    x = -xx;
    1a76:	40b005b3          	neg	a1,a1
    neg = 1;
    1a7a:	4305                	li	t1,1
  } else {
    x = xx;
  }

  i = 0;
    1a7c:	fb840993          	addi	s3,s0,-72
  neg = 0;
    1a80:	86ce                	mv	a3,s3
  i = 0;
    1a82:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
    1a84:	00001817          	auipc	a6,0x1
    1a88:	ebc80813          	addi	a6,a6,-324 # 2940 <digits>
    1a8c:	88ba                	mv	a7,a4
    1a8e:	0017051b          	addiw	a0,a4,1
    1a92:	872a                	mv	a4,a0
    1a94:	02c5f7b3          	remu	a5,a1,a2
    1a98:	97c2                	add	a5,a5,a6
    1a9a:	0007c783          	lbu	a5,0(a5)
    1a9e:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
    1aa2:	87ae                	mv	a5,a1
    1aa4:	02c5d5b3          	divu	a1,a1,a2
    1aa8:	0685                	addi	a3,a3,1
    1aaa:	fec7f1e3          	bgeu	a5,a2,1a8c <printint+0x2a>
  if(neg)
    1aae:	00030c63          	beqz	t1,1ac6 <printint+0x64>
    buf[i++] = '-';
    1ab2:	fd050793          	addi	a5,a0,-48
    1ab6:	00878533          	add	a0,a5,s0
    1aba:	02d00793          	li	a5,45
    1abe:	fef50423          	sb	a5,-24(a0)
    1ac2:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    1ac6:	02e05563          	blez	a4,1af0 <printint+0x8e>
    1aca:	fc26                	sd	s1,56(sp)
    1acc:	377d                	addiw	a4,a4,-1
    1ace:	00e984b3          	add	s1,s3,a4
    1ad2:	19fd                	addi	s3,s3,-1
    1ad4:	99ba                	add	s3,s3,a4
    1ad6:	1702                	slli	a4,a4,0x20
    1ad8:	9301                	srli	a4,a4,0x20
    1ada:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
    1ade:	0004c583          	lbu	a1,0(s1)
    1ae2:	854a                	mv	a0,s2
    1ae4:	f61ff0ef          	jal	1a44 <putc>
  while(--i >= 0)
    1ae8:	14fd                	addi	s1,s1,-1
    1aea:	ff349ae3          	bne	s1,s3,1ade <printint+0x7c>
    1aee:	74e2                	ld	s1,56(sp)
}
    1af0:	60a6                	ld	ra,72(sp)
    1af2:	6406                	ld	s0,64(sp)
    1af4:	7942                	ld	s2,48(sp)
    1af6:	79a2                	ld	s3,40(sp)
    1af8:	6161                	addi	sp,sp,80
    1afa:	8082                	ret
  neg = 0;
    1afc:	4301                	li	t1,0
    1afe:	bfbd                	j	1a7c <printint+0x1a>

0000000000001b00 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %c, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
    1b00:	711d                	addi	sp,sp,-96
    1b02:	ec86                	sd	ra,88(sp)
    1b04:	e8a2                	sd	s0,80(sp)
    1b06:	e4a6                	sd	s1,72(sp)
    1b08:	1080                	addi	s0,sp,96
  char *s;
  int c0, c1, c2, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
    1b0a:	0005c483          	lbu	s1,0(a1)
    1b0e:	22048363          	beqz	s1,1d34 <vprintf+0x234>
    1b12:	e0ca                	sd	s2,64(sp)
    1b14:	fc4e                	sd	s3,56(sp)
    1b16:	f852                	sd	s4,48(sp)
    1b18:	f456                	sd	s5,40(sp)
    1b1a:	f05a                	sd	s6,32(sp)
    1b1c:	ec5e                	sd	s7,24(sp)
    1b1e:	e862                	sd	s8,16(sp)
    1b20:	8b2a                	mv	s6,a0
    1b22:	8a2e                	mv	s4,a1
    1b24:	8bb2                	mv	s7,a2
  state = 0;
    1b26:	4981                	li	s3,0
  for(i = 0; fmt[i]; i++){
    1b28:	4901                	li	s2,0
    1b2a:	4701                	li	a4,0
      if(c0 == '%'){
        state = '%';
      } else {
        putc(fd, c0);
      }
    } else if(state == '%'){
    1b2c:	02500a93          	li	s5,37
      c1 = c2 = 0;
      if(c0) c1 = fmt[i+1] & 0xff;
      if(c1) c2 = fmt[i+2] & 0xff;
      if(c0 == 'd'){
    1b30:	06400c13          	li	s8,100
    1b34:	a00d                	j	1b56 <vprintf+0x56>
        putc(fd, c0);
    1b36:	85a6                	mv	a1,s1
    1b38:	855a                	mv	a0,s6
    1b3a:	f0bff0ef          	jal	1a44 <putc>
    1b3e:	a019                	j	1b44 <vprintf+0x44>
    } else if(state == '%'){
    1b40:	03598363          	beq	s3,s5,1b66 <vprintf+0x66>
  for(i = 0; fmt[i]; i++){
    1b44:	0019079b          	addiw	a5,s2,1
    1b48:	893e                	mv	s2,a5
    1b4a:	873e                	mv	a4,a5
    1b4c:	97d2                	add	a5,a5,s4
    1b4e:	0007c483          	lbu	s1,0(a5)
    1b52:	1c048a63          	beqz	s1,1d26 <vprintf+0x226>
    c0 = fmt[i] & 0xff;
    1b56:	0004879b          	sext.w	a5,s1
    if(state == 0){
    1b5a:	fe0993e3          	bnez	s3,1b40 <vprintf+0x40>
      if(c0 == '%'){
    1b5e:	fd579ce3          	bne	a5,s5,1b36 <vprintf+0x36>
        state = '%';
    1b62:	89be                	mv	s3,a5
    1b64:	b7c5                	j	1b44 <vprintf+0x44>
      if(c0) c1 = fmt[i+1] & 0xff;
    1b66:	00ea06b3          	add	a3,s4,a4
    1b6a:	0016c603          	lbu	a2,1(a3)
      if(c1) c2 = fmt[i+2] & 0xff;
    1b6e:	1c060863          	beqz	a2,1d3e <vprintf+0x23e>
      if(c0 == 'd'){
    1b72:	03878763          	beq	a5,s8,1ba0 <vprintf+0xa0>
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c0 == 'l' && c1 == 'd'){
    1b76:	f9478693          	addi	a3,a5,-108
    1b7a:	0016b693          	seqz	a3,a3
    1b7e:	f9c60593          	addi	a1,a2,-100
    1b82:	e99d                	bnez	a1,1bb8 <vprintf+0xb8>
    1b84:	ca95                	beqz	a3,1bb8 <vprintf+0xb8>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1b86:	008b8493          	addi	s1,s7,8
    1b8a:	4685                	li	a3,1
    1b8c:	4629                	li	a2,10
    1b8e:	000bb583          	ld	a1,0(s7)
    1b92:	855a                	mv	a0,s6
    1b94:	ecfff0ef          	jal	1a62 <printint>
        i += 1;
    1b98:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 1);
    1b9a:	8ba6                	mv	s7,s1
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
        putc(fd, c0);
      }

      state = 0;
    1b9c:	4981                	li	s3,0
    1b9e:	b75d                	j	1b44 <vprintf+0x44>
        printint(fd, va_arg(ap, int), 10, 1);
    1ba0:	008b8493          	addi	s1,s7,8
    1ba4:	4685                	li	a3,1
    1ba6:	4629                	li	a2,10
    1ba8:	000ba583          	lw	a1,0(s7)
    1bac:	855a                	mv	a0,s6
    1bae:	eb5ff0ef          	jal	1a62 <printint>
    1bb2:	8ba6                	mv	s7,s1
      state = 0;
    1bb4:	4981                	li	s3,0
    1bb6:	b779                	j	1b44 <vprintf+0x44>
      if(c1) c2 = fmt[i+2] & 0xff;
    1bb8:	9752                	add	a4,a4,s4
    1bba:	00274583          	lbu	a1,2(a4)
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1bbe:	f9460713          	addi	a4,a2,-108
    1bc2:	00173713          	seqz	a4,a4
    1bc6:	8f75                	and	a4,a4,a3
    1bc8:	f9c58513          	addi	a0,a1,-100
    1bcc:	18051363          	bnez	a0,1d52 <vprintf+0x252>
    1bd0:	18070163          	beqz	a4,1d52 <vprintf+0x252>
        printint(fd, va_arg(ap, uint64), 10, 1);
    1bd4:	008b8493          	addi	s1,s7,8
    1bd8:	4685                	li	a3,1
    1bda:	4629                	li	a2,10
    1bdc:	000bb583          	ld	a1,0(s7)
    1be0:	855a                	mv	a0,s6
    1be2:	e81ff0ef          	jal	1a62 <printint>
        i += 2;
    1be6:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 1);
    1be8:	8ba6                	mv	s7,s1
      state = 0;
    1bea:	4981                	li	s3,0
        i += 2;
    1bec:	bfa1                	j	1b44 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 10, 0);
    1bee:	008b8493          	addi	s1,s7,8
    1bf2:	4681                	li	a3,0
    1bf4:	4629                	li	a2,10
    1bf6:	000be583          	lwu	a1,0(s7)
    1bfa:	855a                	mv	a0,s6
    1bfc:	e67ff0ef          	jal	1a62 <printint>
    1c00:	8ba6                	mv	s7,s1
      state = 0;
    1c02:	4981                	li	s3,0
    1c04:	b781                	j	1b44 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1c06:	008b8493          	addi	s1,s7,8
    1c0a:	4681                	li	a3,0
    1c0c:	4629                	li	a2,10
    1c0e:	000bb583          	ld	a1,0(s7)
    1c12:	855a                	mv	a0,s6
    1c14:	e4fff0ef          	jal	1a62 <printint>
        i += 1;
    1c18:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 10, 0);
    1c1a:	8ba6                	mv	s7,s1
      state = 0;
    1c1c:	4981                	li	s3,0
    1c1e:	b71d                	j	1b44 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 10, 0);
    1c20:	008b8493          	addi	s1,s7,8
    1c24:	4681                	li	a3,0
    1c26:	4629                	li	a2,10
    1c28:	000bb583          	ld	a1,0(s7)
    1c2c:	855a                	mv	a0,s6
    1c2e:	e35ff0ef          	jal	1a62 <printint>
        i += 2;
    1c32:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 10, 0);
    1c34:	8ba6                	mv	s7,s1
      state = 0;
    1c36:	4981                	li	s3,0
        i += 2;
    1c38:	b731                	j	1b44 <vprintf+0x44>
        printint(fd, va_arg(ap, uint32), 16, 0);
    1c3a:	008b8493          	addi	s1,s7,8
    1c3e:	4681                	li	a3,0
    1c40:	4641                	li	a2,16
    1c42:	000be583          	lwu	a1,0(s7)
    1c46:	855a                	mv	a0,s6
    1c48:	e1bff0ef          	jal	1a62 <printint>
    1c4c:	8ba6                	mv	s7,s1
      state = 0;
    1c4e:	4981                	li	s3,0
    1c50:	bdd5                	j	1b44 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1c52:	008b8493          	addi	s1,s7,8
    1c56:	4681                	li	a3,0
    1c58:	4641                	li	a2,16
    1c5a:	000bb583          	ld	a1,0(s7)
    1c5e:	855a                	mv	a0,s6
    1c60:	e03ff0ef          	jal	1a62 <printint>
        i += 1;
    1c64:	2905                	addiw	s2,s2,1
        printint(fd, va_arg(ap, uint64), 16, 0);
    1c66:	8ba6                	mv	s7,s1
      state = 0;
    1c68:	4981                	li	s3,0
    1c6a:	bde9                	j	1b44 <vprintf+0x44>
        printint(fd, va_arg(ap, uint64), 16, 0);
    1c6c:	008b8493          	addi	s1,s7,8
    1c70:	4681                	li	a3,0
    1c72:	4641                	li	a2,16
    1c74:	000bb583          	ld	a1,0(s7)
    1c78:	855a                	mv	a0,s6
    1c7a:	de9ff0ef          	jal	1a62 <printint>
        i += 2;
    1c7e:	2909                	addiw	s2,s2,2
        printint(fd, va_arg(ap, uint64), 16, 0);
    1c80:	8ba6                	mv	s7,s1
      state = 0;
    1c82:	4981                	li	s3,0
        i += 2;
    1c84:	b5c1                	j	1b44 <vprintf+0x44>
    1c86:	e466                	sd	s9,8(sp)
        printptr(fd, va_arg(ap, uint64));
    1c88:	008b8793          	addi	a5,s7,8
    1c8c:	8cbe                	mv	s9,a5
    1c8e:	000bb983          	ld	s3,0(s7)
  putc(fd, '0');
    1c92:	03000593          	li	a1,48
    1c96:	855a                	mv	a0,s6
    1c98:	dadff0ef          	jal	1a44 <putc>
  putc(fd, 'x');
    1c9c:	07800593          	li	a1,120
    1ca0:	855a                	mv	a0,s6
    1ca2:	da3ff0ef          	jal	1a44 <putc>
    1ca6:	44c1                	li	s1,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
    1ca8:	00001b97          	auipc	s7,0x1
    1cac:	c98b8b93          	addi	s7,s7,-872 # 2940 <digits>
    1cb0:	03c9d793          	srli	a5,s3,0x3c
    1cb4:	97de                	add	a5,a5,s7
    1cb6:	0007c583          	lbu	a1,0(a5)
    1cba:	855a                	mv	a0,s6
    1cbc:	d89ff0ef          	jal	1a44 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    1cc0:	0992                	slli	s3,s3,0x4
    1cc2:	34fd                	addiw	s1,s1,-1
    1cc4:	f4f5                	bnez	s1,1cb0 <vprintf+0x1b0>
        printptr(fd, va_arg(ap, uint64));
    1cc6:	8be6                	mv	s7,s9
      state = 0;
    1cc8:	4981                	li	s3,0
    1cca:	6ca2                	ld	s9,8(sp)
    1ccc:	bda5                	j	1b44 <vprintf+0x44>
        putc(fd, va_arg(ap, uint32));
    1cce:	008b8493          	addi	s1,s7,8
    1cd2:	000bc583          	lbu	a1,0(s7)
    1cd6:	855a                	mv	a0,s6
    1cd8:	d6dff0ef          	jal	1a44 <putc>
    1cdc:	8ba6                	mv	s7,s1
      state = 0;
    1cde:	4981                	li	s3,0
    1ce0:	b595                	j	1b44 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    1ce2:	008b8993          	addi	s3,s7,8
    1ce6:	000bb483          	ld	s1,0(s7)
    1cea:	cc91                	beqz	s1,1d06 <vprintf+0x206>
        for(; *s; s++)
    1cec:	0004c583          	lbu	a1,0(s1)
    1cf0:	c985                	beqz	a1,1d20 <vprintf+0x220>
          putc(fd, *s);
    1cf2:	855a                	mv	a0,s6
    1cf4:	d51ff0ef          	jal	1a44 <putc>
        for(; *s; s++)
    1cf8:	0485                	addi	s1,s1,1
    1cfa:	0004c583          	lbu	a1,0(s1)
    1cfe:	f9f5                	bnez	a1,1cf2 <vprintf+0x1f2>
        if((s = va_arg(ap, char*)) == 0)
    1d00:	8bce                	mv	s7,s3
      state = 0;
    1d02:	4981                	li	s3,0
    1d04:	b581                	j	1b44 <vprintf+0x44>
          s = "(null)";
    1d06:	00001497          	auipc	s1,0x1
    1d0a:	c3248493          	addi	s1,s1,-974 # 2938 <malloc+0xa96>
        for(; *s; s++)
    1d0e:	02800593          	li	a1,40
    1d12:	b7c5                	j	1cf2 <vprintf+0x1f2>
        putc(fd, '%');
    1d14:	85be                	mv	a1,a5
    1d16:	855a                	mv	a0,s6
    1d18:	d2dff0ef          	jal	1a44 <putc>
      state = 0;
    1d1c:	4981                	li	s3,0
    1d1e:	b51d                	j	1b44 <vprintf+0x44>
        if((s = va_arg(ap, char*)) == 0)
    1d20:	8bce                	mv	s7,s3
      state = 0;
    1d22:	4981                	li	s3,0
    1d24:	b505                	j	1b44 <vprintf+0x44>
    1d26:	6906                	ld	s2,64(sp)
    1d28:	79e2                	ld	s3,56(sp)
    1d2a:	7a42                	ld	s4,48(sp)
    1d2c:	7aa2                	ld	s5,40(sp)
    1d2e:	7b02                	ld	s6,32(sp)
    1d30:	6be2                	ld	s7,24(sp)
    1d32:	6c42                	ld	s8,16(sp)
    }
  }
}
    1d34:	60e6                	ld	ra,88(sp)
    1d36:	6446                	ld	s0,80(sp)
    1d38:	64a6                	ld	s1,72(sp)
    1d3a:	6125                	addi	sp,sp,96
    1d3c:	8082                	ret
      if(c0 == 'd'){
    1d3e:	06400713          	li	a4,100
    1d42:	e4e78fe3          	beq	a5,a4,1ba0 <vprintf+0xa0>
      } else if(c0 == 'l' && c1 == 'd'){
    1d46:	f9478693          	addi	a3,a5,-108
    1d4a:	0016b693          	seqz	a3,a3
      c1 = c2 = 0;
    1d4e:	85b2                	mv	a1,a2
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    1d50:	4701                	li	a4,0
      } else if(c0 == 'u'){
    1d52:	07500513          	li	a0,117
    1d56:	e8a78ce3          	beq	a5,a0,1bee <vprintf+0xee>
      } else if(c0 == 'l' && c1 == 'u'){
    1d5a:	f8b60513          	addi	a0,a2,-117
    1d5e:	e119                	bnez	a0,1d64 <vprintf+0x264>
    1d60:	ea0693e3          	bnez	a3,1c06 <vprintf+0x106>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    1d64:	f8b58513          	addi	a0,a1,-117
    1d68:	e119                	bnez	a0,1d6e <vprintf+0x26e>
    1d6a:	ea071be3          	bnez	a4,1c20 <vprintf+0x120>
      } else if(c0 == 'x'){
    1d6e:	07800513          	li	a0,120
    1d72:	eca784e3          	beq	a5,a0,1c3a <vprintf+0x13a>
      } else if(c0 == 'l' && c1 == 'x'){
    1d76:	f8860613          	addi	a2,a2,-120
    1d7a:	e219                	bnez	a2,1d80 <vprintf+0x280>
    1d7c:	ec069be3          	bnez	a3,1c52 <vprintf+0x152>
      } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    1d80:	f8858593          	addi	a1,a1,-120
    1d84:	e199                	bnez	a1,1d8a <vprintf+0x28a>
    1d86:	ee0713e3          	bnez	a4,1c6c <vprintf+0x16c>
      } else if(c0 == 'p'){
    1d8a:	07000713          	li	a4,112
    1d8e:	eee78ce3          	beq	a5,a4,1c86 <vprintf+0x186>
      } else if(c0 == 'c'){
    1d92:	06300713          	li	a4,99
    1d96:	f2e78ce3          	beq	a5,a4,1cce <vprintf+0x1ce>
      } else if(c0 == 's'){
    1d9a:	07300713          	li	a4,115
    1d9e:	f4e782e3          	beq	a5,a4,1ce2 <vprintf+0x1e2>
      } else if(c0 == '%'){
    1da2:	02500713          	li	a4,37
    1da6:	f6e787e3          	beq	a5,a4,1d14 <vprintf+0x214>
        putc(fd, '%');
    1daa:	02500593          	li	a1,37
    1dae:	855a                	mv	a0,s6
    1db0:	c95ff0ef          	jal	1a44 <putc>
        putc(fd, c0);
    1db4:	85a6                	mv	a1,s1
    1db6:	855a                	mv	a0,s6
    1db8:	c8dff0ef          	jal	1a44 <putc>
      state = 0;
    1dbc:	4981                	li	s3,0
    1dbe:	b359                	j	1b44 <vprintf+0x44>

0000000000001dc0 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
    1dc0:	715d                	addi	sp,sp,-80
    1dc2:	ec06                	sd	ra,24(sp)
    1dc4:	e822                	sd	s0,16(sp)
    1dc6:	1000                	addi	s0,sp,32
    1dc8:	e010                	sd	a2,0(s0)
    1dca:	e414                	sd	a3,8(s0)
    1dcc:	e818                	sd	a4,16(s0)
    1dce:	ec1c                	sd	a5,24(s0)
    1dd0:	03043023          	sd	a6,32(s0)
    1dd4:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
    1dd8:	8622                	mv	a2,s0
    1dda:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
    1dde:	d23ff0ef          	jal	1b00 <vprintf>
}
    1de2:	60e2                	ld	ra,24(sp)
    1de4:	6442                	ld	s0,16(sp)
    1de6:	6161                	addi	sp,sp,80
    1de8:	8082                	ret

0000000000001dea <printf>:

void
printf(const char *fmt, ...)
{
    1dea:	711d                	addi	sp,sp,-96
    1dec:	ec06                	sd	ra,24(sp)
    1dee:	e822                	sd	s0,16(sp)
    1df0:	1000                	addi	s0,sp,32
    1df2:	e40c                	sd	a1,8(s0)
    1df4:	e810                	sd	a2,16(s0)
    1df6:	ec14                	sd	a3,24(s0)
    1df8:	f018                	sd	a4,32(s0)
    1dfa:	f41c                	sd	a5,40(s0)
    1dfc:	03043823          	sd	a6,48(s0)
    1e00:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
    1e04:	00840613          	addi	a2,s0,8
    1e08:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
    1e0c:	85aa                	mv	a1,a0
    1e0e:	4505                	li	a0,1
    1e10:	cf1ff0ef          	jal	1b00 <vprintf>
}
    1e14:	60e2                	ld	ra,24(sp)
    1e16:	6442                	ld	s0,16(sp)
    1e18:	6125                	addi	sp,sp,96
    1e1a:	8082                	ret

0000000000001e1c <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
    1e1c:	1141                	addi	sp,sp,-16
    1e1e:	e406                	sd	ra,8(sp)
    1e20:	e022                	sd	s0,0(sp)
    1e22:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
    1e24:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1e28:	00001797          	auipc	a5,0x1
    1e2c:	1d87b783          	ld	a5,472(a5) # 3000 <freep>
    1e30:	a039                	j	1e3e <free+0x22>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1e32:	6398                	ld	a4,0(a5)
    1e34:	00e7e463          	bltu	a5,a4,1e3c <free+0x20>
    1e38:	00e6ea63          	bltu	a3,a4,1e4c <free+0x30>
{
    1e3c:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1e3e:	fed7fae3          	bgeu	a5,a3,1e32 <free+0x16>
    1e42:	6398                	ld	a4,0(a5)
    1e44:	00e6e463          	bltu	a3,a4,1e4c <free+0x30>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1e48:	fee7eae3          	bltu	a5,a4,1e3c <free+0x20>
      break;
  if(bp + bp->s.size == p->s.ptr){
    1e4c:	ff852583          	lw	a1,-8(a0)
    1e50:	6390                	ld	a2,0(a5)
    1e52:	02059813          	slli	a6,a1,0x20
    1e56:	01c85713          	srli	a4,a6,0x1c
    1e5a:	9736                	add	a4,a4,a3
    1e5c:	02e60563          	beq	a2,a4,1e86 <free+0x6a>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
    1e60:	fec53823          	sd	a2,-16(a0)
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    1e64:	4790                	lw	a2,8(a5)
    1e66:	02061593          	slli	a1,a2,0x20
    1e6a:	01c5d713          	srli	a4,a1,0x1c
    1e6e:	973e                	add	a4,a4,a5
    1e70:	02e68263          	beq	a3,a4,1e94 <free+0x78>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
    1e74:	e394                	sd	a3,0(a5)
  } else
    p->s.ptr = bp;
  freep = p;
    1e76:	00001717          	auipc	a4,0x1
    1e7a:	18f73523          	sd	a5,394(a4) # 3000 <freep>
}
    1e7e:	60a2                	ld	ra,8(sp)
    1e80:	6402                	ld	s0,0(sp)
    1e82:	0141                	addi	sp,sp,16
    1e84:	8082                	ret
    bp->s.size += p->s.ptr->s.size;
    1e86:	4618                	lw	a4,8(a2)
    1e88:	9f2d                	addw	a4,a4,a1
    1e8a:	fee52c23          	sw	a4,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
    1e8e:	6398                	ld	a4,0(a5)
    1e90:	6310                	ld	a2,0(a4)
    1e92:	b7f9                	j	1e60 <free+0x44>
    p->s.size += bp->s.size;
    1e94:	ff852703          	lw	a4,-8(a0)
    1e98:	9f31                	addw	a4,a4,a2
    1e9a:	c798                	sw	a4,8(a5)
    p->s.ptr = bp->s.ptr;
    1e9c:	ff053683          	ld	a3,-16(a0)
    1ea0:	bfd1                	j	1e74 <free+0x58>

0000000000001ea2 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1ea2:	7139                	addi	sp,sp,-64
    1ea4:	fc06                	sd	ra,56(sp)
    1ea6:	f822                	sd	s0,48(sp)
    1ea8:	f04a                	sd	s2,32(sp)
    1eaa:	ec4e                	sd	s3,24(sp)
    1eac:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1eae:	02051993          	slli	s3,a0,0x20
    1eb2:	0209d993          	srli	s3,s3,0x20
    1eb6:	09bd                	addi	s3,s3,15
    1eb8:	0049d993          	srli	s3,s3,0x4
    1ebc:	2985                	addiw	s3,s3,1
    1ebe:	894e                	mv	s2,s3
  if((prevp = freep) == 0){
    1ec0:	00001517          	auipc	a0,0x1
    1ec4:	14053503          	ld	a0,320(a0) # 3000 <freep>
    1ec8:	c905                	beqz	a0,1ef8 <malloc+0x56>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1eca:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1ecc:	4798                	lw	a4,8(a5)
    1ece:	09377663          	bgeu	a4,s3,1f5a <malloc+0xb8>
    1ed2:	f426                	sd	s1,40(sp)
    1ed4:	e852                	sd	s4,16(sp)
    1ed6:	e456                	sd	s5,8(sp)
    1ed8:	e05a                	sd	s6,0(sp)
  if(nu < 4096)
    1eda:	8a4e                	mv	s4,s3
    1edc:	6705                	lui	a4,0x1
    1ede:	00e9f363          	bgeu	s3,a4,1ee4 <malloc+0x42>
    1ee2:	6a05                	lui	s4,0x1
    1ee4:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    1ee8:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1eec:	00001497          	auipc	s1,0x1
    1ef0:	11448493          	addi	s1,s1,276 # 3000 <freep>
  if(p == SBRK_ERROR)
    1ef4:	5afd                	li	s5,-1
    1ef6:	a83d                	j	1f34 <malloc+0x92>
    1ef8:	f426                	sd	s1,40(sp)
    1efa:	e852                	sd	s4,16(sp)
    1efc:	e456                	sd	s5,8(sp)
    1efe:	e05a                	sd	s6,0(sp)
    base.s.ptr = freep = prevp = &base;
    1f00:	00001797          	auipc	a5,0x1
    1f04:	31078793          	addi	a5,a5,784 # 3210 <base>
    1f08:	00001717          	auipc	a4,0x1
    1f0c:	0ef73c23          	sd	a5,248(a4) # 3000 <freep>
    1f10:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1f12:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1f16:	b7d1                	j	1eda <malloc+0x38>
        prevp->s.ptr = p->s.ptr;
    1f18:	6398                	ld	a4,0(a5)
    1f1a:	e118                	sd	a4,0(a0)
    1f1c:	a899                	j	1f72 <malloc+0xd0>
  hp->s.size = nu;
    1f1e:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    1f22:	0541                	addi	a0,a0,16
    1f24:	ef9ff0ef          	jal	1e1c <free>
  return freep;
    1f28:	6088                	ld	a0,0(s1)
      if((p = morecore(nunits)) == 0)
    1f2a:	c125                	beqz	a0,1f8a <malloc+0xe8>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1f2c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1f2e:	4798                	lw	a4,8(a5)
    1f30:	03277163          	bgeu	a4,s2,1f52 <malloc+0xb0>
    if(p == freep)
    1f34:	6098                	ld	a4,0(s1)
    1f36:	853e                	mv	a0,a5
    1f38:	fef71ae3          	bne	a4,a5,1f2c <malloc+0x8a>
  p = sbrk(nu * sizeof(Header));
    1f3c:	8552                	mv	a0,s4
    1f3e:	9fdff0ef          	jal	193a <sbrk>
  if(p == SBRK_ERROR)
    1f42:	fd551ee3          	bne	a0,s5,1f1e <malloc+0x7c>
        return 0;
    1f46:	4501                	li	a0,0
    1f48:	74a2                	ld	s1,40(sp)
    1f4a:	6a42                	ld	s4,16(sp)
    1f4c:	6aa2                	ld	s5,8(sp)
    1f4e:	6b02                	ld	s6,0(sp)
    1f50:	a03d                	j	1f7e <malloc+0xdc>
    1f52:	74a2                	ld	s1,40(sp)
    1f54:	6a42                	ld	s4,16(sp)
    1f56:	6aa2                	ld	s5,8(sp)
    1f58:	6b02                	ld	s6,0(sp)
      if(p->s.size == nunits)
    1f5a:	fae90fe3          	beq	s2,a4,1f18 <malloc+0x76>
        p->s.size -= nunits;
    1f5e:	4137073b          	subw	a4,a4,s3
    1f62:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1f64:	02071693          	slli	a3,a4,0x20
    1f68:	01c6d713          	srli	a4,a3,0x1c
    1f6c:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1f6e:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    1f72:	00001717          	auipc	a4,0x1
    1f76:	08a73723          	sd	a0,142(a4) # 3000 <freep>
      return (void*)(p + 1);
    1f7a:	01078513          	addi	a0,a5,16
  }
}
    1f7e:	70e2                	ld	ra,56(sp)
    1f80:	7442                	ld	s0,48(sp)
    1f82:	7902                	ld	s2,32(sp)
    1f84:	69e2                	ld	s3,24(sp)
    1f86:	6121                	addi	sp,sp,64
    1f88:	8082                	ret
    1f8a:	74a2                	ld	s1,40(sp)
    1f8c:	6a42                	ld	s4,16(sp)
    1f8e:	6aa2                	ld	s5,8(sp)
    1f90:	6b02                	ld	s6,0(sp)
    1f92:	b7f5                	j	1f7e <malloc+0xdc>
