
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0001b117          	auipc	sp,0x1b
    80000004:	7f010113          	addi	sp,sp,2032 # 8001b7f0 <stack0>
        li a0, 1024*4
    80000008:	6505                	lui	a0,0x1
        csrr a1, mhartid
    8000000a:	f14025f3          	csrr	a1,mhartid
        addi a1, a1, 1
    8000000e:	0585                	addi	a1,a1,1
        mul a0, a0, a1
    80000010:	02b50533          	mul	a0,a0,a1
        add sp, sp, a0
    80000014:	912a                	add	sp,sp,a0
        # jump to start() in start.c
        call start
    80000016:	314050ef          	jal	8000532a <start>

000000008000001a <spin>:
spin:
        j spin
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	7139                	addi	sp,sp,-64
    8000001e:	fc06                	sd	ra,56(sp)
    80000020:	f822                	sd	s0,48(sp)
    80000022:	f426                	sd	s1,40(sp)
    80000024:	f04a                	sd	s2,32(sp)
    80000026:	ec4e                	sd	s3,24(sp)
    80000028:	e852                	sd	s4,16(sp)
    8000002a:	e456                	sd	s5,8(sp)
    8000002c:	0080                	addi	s0,sp,64
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    8000002e:	00025797          	auipc	a5,0x25
    80000032:	89278793          	addi	a5,a5,-1902 # 800248c0 <end>
    80000036:	00f53733          	sltu	a4,a0,a5
    8000003a:	47c5                	li	a5,17
    8000003c:	07ee                	slli	a5,a5,0x1b
    8000003e:	17fd                	addi	a5,a5,-1
    80000040:	00a7b7b3          	sltu	a5,a5,a0
    80000044:	8fd9                	or	a5,a5,a4
    80000046:	efa9                	bnez	a5,800000a0 <kfree+0x84>
    80000048:	84aa                	mv	s1,a0
    8000004a:	03451793          	slli	a5,a0,0x34
    8000004e:	eba9                	bnez	a5,800000a0 <kfree+0x84>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000050:	6605                	lui	a2,0x1
    80000052:	4585                	li	a1,1
    80000054:	1ca000ef          	jal	8000021e <memset>

  r = (struct run*)pa;

  push_off();
    80000058:	57b050ef          	jal	80005dd2 <push_off>

  int cid = cpuid();
    8000005c:	5c1000ef          	jal	80000e1c <cpuid>

  acquire(&kmems[cid].lock);
    80000060:	00009a97          	auipc	s5,0x9
    80000064:	c60a8a93          	addi	s5,s5,-928 # 80008cc0 <kmems>
    80000068:	00251993          	slli	s3,a0,0x2
    8000006c:	00a98933          	add	s2,s3,a0
    80000070:	090e                	slli	s2,s2,0x3
    80000072:	9956                	add	s2,s2,s5
    80000074:	854a                	mv	a0,s2
    80000076:	5a1050ef          	jal	80005e16 <acquire>
  r->next = kmems[cid].freelist;
    8000007a:	02093783          	ld	a5,32(s2)
    8000007e:	e09c                	sd	a5,0(s1)
  kmems[cid].freelist = r;
    80000080:	02993023          	sd	s1,32(s2)
  release(&kmems[cid].lock);
    80000084:	854a                	mv	a0,s2
    80000086:	679050ef          	jal	80005efe <release>

  pop_off();
    8000008a:	625050ef          	jal	80005eae <pop_off>
}
    8000008e:	70e2                	ld	ra,56(sp)
    80000090:	7442                	ld	s0,48(sp)
    80000092:	74a2                	ld	s1,40(sp)
    80000094:	7902                	ld	s2,32(sp)
    80000096:	69e2                	ld	s3,24(sp)
    80000098:	6a42                	ld	s4,16(sp)
    8000009a:	6aa2                	ld	s5,8(sp)
    8000009c:	6121                	addi	sp,sp,64
    8000009e:	8082                	ret
    panic("kfree");
    800000a0:	00008517          	auipc	a0,0x8
    800000a4:	f6050513          	addi	a0,a0,-160 # 80008000 <etext>
    800000a8:	243050ef          	jal	80005aea <panic>

00000000800000ac <freerange>:
{
    800000ac:	7179                	addi	sp,sp,-48
    800000ae:	f406                	sd	ra,40(sp)
    800000b0:	f022                	sd	s0,32(sp)
    800000b2:	ec26                	sd	s1,24(sp)
    800000b4:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000b6:	6785                	lui	a5,0x1
    800000b8:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000bc:	00e504b3          	add	s1,a0,a4
    800000c0:	777d                	lui	a4,0xfffff
    800000c2:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c4:	94be                	add	s1,s1,a5
    800000c6:	0295e263          	bltu	a1,s1,800000ea <freerange+0x3e>
    800000ca:	e84a                	sd	s2,16(sp)
    800000cc:	e44e                	sd	s3,8(sp)
    800000ce:	e052                	sd	s4,0(sp)
    800000d0:	892e                	mv	s2,a1
    kfree(p);
    800000d2:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000d4:	89be                	mv	s3,a5
    kfree(p);
    800000d6:	01448533          	add	a0,s1,s4
    800000da:	f43ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000de:	94ce                	add	s1,s1,s3
    800000e0:	fe997be3          	bgeu	s2,s1,800000d6 <freerange+0x2a>
    800000e4:	6942                	ld	s2,16(sp)
    800000e6:	69a2                	ld	s3,8(sp)
    800000e8:	6a02                	ld	s4,0(sp)
}
    800000ea:	70a2                	ld	ra,40(sp)
    800000ec:	7402                	ld	s0,32(sp)
    800000ee:	64e2                	ld	s1,24(sp)
    800000f0:	6145                	addi	sp,sp,48
    800000f2:	8082                	ret

00000000800000f4 <kinit>:
{
    800000f4:	7179                	addi	sp,sp,-48
    800000f6:	f406                	sd	ra,40(sp)
    800000f8:	f022                	sd	s0,32(sp)
    800000fa:	ec26                	sd	s1,24(sp)
    800000fc:	e84a                	sd	s2,16(sp)
    800000fe:	e44e                	sd	s3,8(sp)
    80000100:	1800                	addi	s0,sp,48
  for (int i=0; i < NCPU; i++) {
    80000102:	00009497          	auipc	s1,0x9
    80000106:	bbe48493          	addi	s1,s1,-1090 # 80008cc0 <kmems>
    8000010a:	00009997          	auipc	s3,0x9
    8000010e:	cf698993          	addi	s3,s3,-778 # 80008e00 <pid_lock>
    initlock(&kmems[i].lock, "kmem");
    80000112:	00008917          	auipc	s2,0x8
    80000116:	efe90913          	addi	s2,s2,-258 # 80008010 <etext+0x10>
    8000011a:	85ca                	mv	a1,s2
    8000011c:	8526                	mv	a0,s1
    8000011e:	679050ef          	jal	80005f96 <initlock>
  for (int i=0; i < NCPU; i++) {
    80000122:	02848493          	addi	s1,s1,40
    80000126:	ff349ae3          	bne	s1,s3,8000011a <kinit+0x26>
  freerange(end, (void*)PHYSTOP);
    8000012a:	45c5                	li	a1,17
    8000012c:	05ee                	slli	a1,a1,0x1b
    8000012e:	00024517          	auipc	a0,0x24
    80000132:	79250513          	addi	a0,a0,1938 # 800248c0 <end>
    80000136:	f77ff0ef          	jal	800000ac <freerange>
}
    8000013a:	70a2                	ld	ra,40(sp)
    8000013c:	7402                	ld	s0,32(sp)
    8000013e:	64e2                	ld	s1,24(sp)
    80000140:	6942                	ld	s2,16(sp)
    80000142:	69a2                	ld	s3,8(sp)
    80000144:	6145                	addi	sp,sp,48
    80000146:	8082                	ret

0000000080000148 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000148:	7139                	addi	sp,sp,-64
    8000014a:	fc06                	sd	ra,56(sp)
    8000014c:	f822                	sd	s0,48(sp)
    8000014e:	f426                	sd	s1,40(sp)
    80000150:	ec4e                	sd	s3,24(sp)
    80000152:	e852                	sd	s4,16(sp)
    80000154:	e456                	sd	s5,8(sp)
    80000156:	0080                	addi	s0,sp,64
  struct run *r;

  push_off();
    80000158:	47b050ef          	jal	80005dd2 <push_off>

  int cid = cpuid();
    8000015c:	4c1000ef          	jal	80000e1c <cpuid>
    80000160:	89aa                	mv	s3,a0

  acquire(&kmems[cid].lock);
    80000162:	00251793          	slli	a5,a0,0x2
    80000166:	97aa                	add	a5,a5,a0
    80000168:	078e                	slli	a5,a5,0x3
    8000016a:	00009497          	auipc	s1,0x9
    8000016e:	b5648493          	addi	s1,s1,-1194 # 80008cc0 <kmems>
    80000172:	94be                	add	s1,s1,a5
    80000174:	8526                	mv	a0,s1
    80000176:	4a1050ef          	jal	80005e16 <acquire>
  r = kmems[cid].freelist;
    8000017a:	0204ba83          	ld	s5,32(s1)
  if(r)
    8000017e:	000a8c63          	beqz	s5,80000196 <kalloc+0x4e>
    kmems[cid].freelist = r->next;
    80000182:	000ab683          	ld	a3,0(s5)
    80000186:	f094                	sd	a3,32(s1)
  release(&kmems[cid].lock);
    80000188:	8526                	mv	a0,s1
    8000018a:	575050ef          	jal	80005efe <release>
      if(r)
        break;
    }
  }

  pop_off();
    8000018e:	521050ef          	jal	80005eae <pop_off>
  r = kmems[cid].freelist;
    80000192:	8a56                	mv	s4,s5
    80000194:	a08d                	j	800001f6 <kalloc+0xae>
    80000196:	f04a                	sd	s2,32(sp)
    80000198:	e05a                	sd	s6,0(sp)
  release(&kmems[cid].lock);
    8000019a:	8526                	mv	a0,s1
    8000019c:	563050ef          	jal	80005efe <release>
  if(!r) { // steal free page from other CPU's free-list
    800001a0:	00009917          	auipc	s2,0x9
    800001a4:	b2090913          	addi	s2,s2,-1248 # 80008cc0 <kmems>
    for (int i=0; i < NCPU; i++) {
    800001a8:	4481                	li	s1,0
    800001aa:	4b21                	li	s6,8
    800001ac:	a809                	j	800001be <kalloc+0x76>
      release(&kmems[i].lock);
    800001ae:	854a                	mv	a0,s2
    800001b0:	54f050ef          	jal	80005efe <release>
    for (int i=0; i < NCPU; i++) {
    800001b4:	2485                	addiw	s1,s1,1
    800001b6:	02890913          	addi	s2,s2,40
    800001ba:	05648c63          	beq	s1,s6,80000212 <kalloc+0xca>
      if (i == cid)
    800001be:	fe998be3          	beq	s3,s1,800001b4 <kalloc+0x6c>
      acquire(&kmems[i].lock);
    800001c2:	854a                	mv	a0,s2
    800001c4:	453050ef          	jal	80005e16 <acquire>
      r = kmems[i].freelist;
    800001c8:	02093a03          	ld	s4,32(s2)
      if(r)
    800001cc:	fe0a01e3          	beqz	s4,800001ae <kalloc+0x66>
        kmems[i].freelist = r->next;
    800001d0:	000a3683          	ld	a3,0(s4)
    800001d4:	00249793          	slli	a5,s1,0x2
    800001d8:	97a6                	add	a5,a5,s1
    800001da:	078e                	slli	a5,a5,0x3
    800001dc:	00009717          	auipc	a4,0x9
    800001e0:	ae470713          	addi	a4,a4,-1308 # 80008cc0 <kmems>
    800001e4:	97ba                	add	a5,a5,a4
    800001e6:	f394                	sd	a3,32(a5)
      release(&kmems[i].lock);
    800001e8:	854a                	mv	a0,s2
    800001ea:	515050ef          	jal	80005efe <release>
  pop_off();
    800001ee:	4c1050ef          	jal	80005eae <pop_off>

  if(r)
    800001f2:	7902                	ld	s2,32(sp)
    800001f4:	6b02                	ld	s6,0(sp)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001f6:	6605                	lui	a2,0x1
    800001f8:	4595                	li	a1,5
    800001fa:	8552                	mv	a0,s4
    800001fc:	022000ef          	jal	8000021e <memset>
  return (void*)r;
}
    80000200:	8552                	mv	a0,s4
    80000202:	70e2                	ld	ra,56(sp)
    80000204:	7442                	ld	s0,48(sp)
    80000206:	74a2                	ld	s1,40(sp)
    80000208:	69e2                	ld	s3,24(sp)
    8000020a:	6a42                	ld	s4,16(sp)
    8000020c:	6aa2                	ld	s5,8(sp)
    8000020e:	6121                	addi	sp,sp,64
    80000210:	8082                	ret
  pop_off();
    80000212:	49d050ef          	jal	80005eae <pop_off>
    80000216:	8a56                	mv	s4,s5
    80000218:	7902                	ld	s2,32(sp)
    8000021a:	6b02                	ld	s6,0(sp)
    8000021c:	b7d5                	j	80000200 <kalloc+0xb8>

000000008000021e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000021e:	1141                	addi	sp,sp,-16
    80000220:	e406                	sd	ra,8(sp)
    80000222:	e022                	sd	s0,0(sp)
    80000224:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000226:	ca19                	beqz	a2,8000023c <memset+0x1e>
    80000228:	87aa                	mv	a5,a0
    8000022a:	1602                	slli	a2,a2,0x20
    8000022c:	9201                	srli	a2,a2,0x20
    8000022e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000232:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000236:	0785                	addi	a5,a5,1
    80000238:	fee79de3          	bne	a5,a4,80000232 <memset+0x14>
  }
  return dst;
}
    8000023c:	60a2                	ld	ra,8(sp)
    8000023e:	6402                	ld	s0,0(sp)
    80000240:	0141                	addi	sp,sp,16
    80000242:	8082                	ret

0000000080000244 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000244:	1141                	addi	sp,sp,-16
    80000246:	e406                	sd	ra,8(sp)
    80000248:	e022                	sd	s0,0(sp)
    8000024a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000024c:	c61d                	beqz	a2,8000027a <memcmp+0x36>
    8000024e:	1602                	slli	a2,a2,0x20
    80000250:	9201                	srli	a2,a2,0x20
    80000252:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000256:	00054783          	lbu	a5,0(a0)
    8000025a:	0005c703          	lbu	a4,0(a1)
    8000025e:	00e79863          	bne	a5,a4,8000026e <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000262:	0505                	addi	a0,a0,1
    80000264:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000266:	fed518e3          	bne	a0,a3,80000256 <memcmp+0x12>
  }

  return 0;
    8000026a:	4501                	li	a0,0
    8000026c:	a019                	j	80000272 <memcmp+0x2e>
      return *s1 - *s2;
    8000026e:	40e7853b          	subw	a0,a5,a4
}
    80000272:	60a2                	ld	ra,8(sp)
    80000274:	6402                	ld	s0,0(sp)
    80000276:	0141                	addi	sp,sp,16
    80000278:	8082                	ret
  return 0;
    8000027a:	4501                	li	a0,0
    8000027c:	bfdd                	j	80000272 <memcmp+0x2e>

000000008000027e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000027e:	1141                	addi	sp,sp,-16
    80000280:	e406                	sd	ra,8(sp)
    80000282:	e022                	sd	s0,0(sp)
    80000284:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000286:	c205                	beqz	a2,800002a6 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000288:	02a5e363          	bltu	a1,a0,800002ae <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000028c:	1602                	slli	a2,a2,0x20
    8000028e:	9201                	srli	a2,a2,0x20
    80000290:	00c587b3          	add	a5,a1,a2
{
    80000294:	872a                	mv	a4,a0
      *d++ = *s++;
    80000296:	0585                	addi	a1,a1,1
    80000298:	0705                	addi	a4,a4,1
    8000029a:	fff5c683          	lbu	a3,-1(a1)
    8000029e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800002a2:	feb79ae3          	bne	a5,a1,80000296 <memmove+0x18>

  return dst;
}
    800002a6:	60a2                	ld	ra,8(sp)
    800002a8:	6402                	ld	s0,0(sp)
    800002aa:	0141                	addi	sp,sp,16
    800002ac:	8082                	ret
  if(s < d && s + n > d){
    800002ae:	02061693          	slli	a3,a2,0x20
    800002b2:	9281                	srli	a3,a3,0x20
    800002b4:	00d58733          	add	a4,a1,a3
    800002b8:	fce57ae3          	bgeu	a0,a4,8000028c <memmove+0xe>
    d += n;
    800002bc:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800002be:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    800002c2:	1782                	slli	a5,a5,0x20
    800002c4:	9381                	srli	a5,a5,0x20
    800002c6:	fff7c793          	not	a5,a5
    800002ca:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800002cc:	177d                	addi	a4,a4,-1
    800002ce:	16fd                	addi	a3,a3,-1
    800002d0:	00074603          	lbu	a2,0(a4)
    800002d4:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800002d8:	fee79ae3          	bne	a5,a4,800002cc <memmove+0x4e>
    800002dc:	b7e9                	j	800002a6 <memmove+0x28>

00000000800002de <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800002de:	1141                	addi	sp,sp,-16
    800002e0:	e406                	sd	ra,8(sp)
    800002e2:	e022                	sd	s0,0(sp)
    800002e4:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    800002e6:	f99ff0ef          	jal	8000027e <memmove>
}
    800002ea:	60a2                	ld	ra,8(sp)
    800002ec:	6402                	ld	s0,0(sp)
    800002ee:	0141                	addi	sp,sp,16
    800002f0:	8082                	ret

00000000800002f2 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    800002f2:	1141                	addi	sp,sp,-16
    800002f4:	e406                	sd	ra,8(sp)
    800002f6:	e022                	sd	s0,0(sp)
    800002f8:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    800002fa:	ce11                	beqz	a2,80000316 <strncmp+0x24>
    800002fc:	00054783          	lbu	a5,0(a0)
    80000300:	cf89                	beqz	a5,8000031a <strncmp+0x28>
    80000302:	0005c703          	lbu	a4,0(a1)
    80000306:	00f71a63          	bne	a4,a5,8000031a <strncmp+0x28>
    n--, p++, q++;
    8000030a:	367d                	addiw	a2,a2,-1
    8000030c:	0505                	addi	a0,a0,1
    8000030e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000310:	f675                	bnez	a2,800002fc <strncmp+0xa>
  if(n == 0)
    return 0;
    80000312:	4501                	li	a0,0
    80000314:	a801                	j	80000324 <strncmp+0x32>
    80000316:	4501                	li	a0,0
    80000318:	a031                	j	80000324 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000031a:	00054503          	lbu	a0,0(a0)
    8000031e:	0005c783          	lbu	a5,0(a1)
    80000322:	9d1d                	subw	a0,a0,a5
}
    80000324:	60a2                	ld	ra,8(sp)
    80000326:	6402                	ld	s0,0(sp)
    80000328:	0141                	addi	sp,sp,16
    8000032a:	8082                	ret

000000008000032c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000032c:	1141                	addi	sp,sp,-16
    8000032e:	e406                	sd	ra,8(sp)
    80000330:	e022                	sd	s0,0(sp)
    80000332:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000334:	87aa                	mv	a5,a0
    80000336:	a011                	j	8000033a <strncpy+0xe>
    80000338:	8636                	mv	a2,a3
    8000033a:	02c05863          	blez	a2,8000036a <strncpy+0x3e>
    8000033e:	fff6069b          	addiw	a3,a2,-1
    80000342:	8836                	mv	a6,a3
    80000344:	0785                	addi	a5,a5,1
    80000346:	0005c703          	lbu	a4,0(a1)
    8000034a:	fee78fa3          	sb	a4,-1(a5)
    8000034e:	0585                	addi	a1,a1,1
    80000350:	f765                	bnez	a4,80000338 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000352:	873e                	mv	a4,a5
    80000354:	01005b63          	blez	a6,8000036a <strncpy+0x3e>
    80000358:	9fb1                	addw	a5,a5,a2
    8000035a:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000035c:	0705                	addi	a4,a4,1
    8000035e:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000362:	40e786bb          	subw	a3,a5,a4
    80000366:	fed04be3          	bgtz	a3,8000035c <strncpy+0x30>
  return os;
}
    8000036a:	60a2                	ld	ra,8(sp)
    8000036c:	6402                	ld	s0,0(sp)
    8000036e:	0141                	addi	sp,sp,16
    80000370:	8082                	ret

0000000080000372 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000372:	1141                	addi	sp,sp,-16
    80000374:	e406                	sd	ra,8(sp)
    80000376:	e022                	sd	s0,0(sp)
    80000378:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000037a:	02c05363          	blez	a2,800003a0 <safestrcpy+0x2e>
    8000037e:	fff6069b          	addiw	a3,a2,-1
    80000382:	1682                	slli	a3,a3,0x20
    80000384:	9281                	srli	a3,a3,0x20
    80000386:	96ae                	add	a3,a3,a1
    80000388:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    8000038a:	00d58963          	beq	a1,a3,8000039c <safestrcpy+0x2a>
    8000038e:	0585                	addi	a1,a1,1
    80000390:	0785                	addi	a5,a5,1
    80000392:	fff5c703          	lbu	a4,-1(a1)
    80000396:	fee78fa3          	sb	a4,-1(a5)
    8000039a:	fb65                	bnez	a4,8000038a <safestrcpy+0x18>
    ;
  *s = 0;
    8000039c:	00078023          	sb	zero,0(a5)
  return os;
}
    800003a0:	60a2                	ld	ra,8(sp)
    800003a2:	6402                	ld	s0,0(sp)
    800003a4:	0141                	addi	sp,sp,16
    800003a6:	8082                	ret

00000000800003a8 <strlen>:

int
strlen(const char *s)
{
    800003a8:	1141                	addi	sp,sp,-16
    800003aa:	e406                	sd	ra,8(sp)
    800003ac:	e022                	sd	s0,0(sp)
    800003ae:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800003b0:	00054783          	lbu	a5,0(a0)
    800003b4:	cf91                	beqz	a5,800003d0 <strlen+0x28>
    800003b6:	00150793          	addi	a5,a0,1
    800003ba:	86be                	mv	a3,a5
    800003bc:	0785                	addi	a5,a5,1
    800003be:	fff7c703          	lbu	a4,-1(a5)
    800003c2:	ff65                	bnez	a4,800003ba <strlen+0x12>
    800003c4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    800003c8:	60a2                	ld	ra,8(sp)
    800003ca:	6402                	ld	s0,0(sp)
    800003cc:	0141                	addi	sp,sp,16
    800003ce:	8082                	ret
  for(n = 0; s[n]; n++)
    800003d0:	4501                	li	a0,0
    800003d2:	bfdd                	j	800003c8 <strlen+0x20>

00000000800003d4 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800003d4:	1101                	addi	sp,sp,-32
    800003d6:	ec06                	sd	ra,24(sp)
    800003d8:	e822                	sd	s0,16(sp)
    800003da:	e426                	sd	s1,8(sp)
    800003dc:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    800003de:	23f000ef          	jal	80000e1c <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(atomic_read4((int *) &started) == 0)
    800003e2:	00009497          	auipc	s1,0x9
    800003e6:	89e48493          	addi	s1,s1,-1890 # 80008c80 <started>
  if(cpuid() == 0){
    800003ea:	c905                	beqz	a0,8000041a <main+0x46>
    while(atomic_read4((int *) &started) == 0)
    800003ec:	8526                	mv	a0,s1
    800003ee:	110060ef          	jal	800064fe <atomic_read4>
    800003f2:	dd6d                	beqz	a0,800003ec <main+0x18>
      ;
    __sync_synchronize();
    800003f4:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    800003f8:	225000ef          	jal	80000e1c <cpuid>
    800003fc:	85aa                	mv	a1,a0
    800003fe:	00008517          	auipc	a0,0x8
    80000402:	c3a50513          	addi	a0,a0,-966 # 80008038 <etext+0x38>
    80000406:	3ba050ef          	jal	800057c0 <printf>
    kvminithart();    // turn on paging
    8000040a:	084000ef          	jal	8000048e <kvminithart>
    trapinithart();   // install kernel trap vector
    8000040e:	58c010ef          	jal	8000199a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000412:	5f6040ef          	jal	80004a08 <plicinithart>
  }

  scheduler();        
    80000416:	6a3000ef          	jal	800012b8 <scheduler>
    consoleinit();
    8000041a:	2cc050ef          	jal	800056e6 <consoleinit>
    statsinit();
    8000041e:	46f040ef          	jal	8000508c <statsinit>
    printfinit();
    80000422:	704050ef          	jal	80005b26 <printfinit>
    printf("\n");
    80000426:	00008517          	auipc	a0,0x8
    8000042a:	bf250513          	addi	a0,a0,-1038 # 80008018 <etext+0x18>
    8000042e:	392050ef          	jal	800057c0 <printf>
    printf("xv6 kernel is booting\n");
    80000432:	00008517          	auipc	a0,0x8
    80000436:	bee50513          	addi	a0,a0,-1042 # 80008020 <etext+0x20>
    8000043a:	386050ef          	jal	800057c0 <printf>
    printf("\n");
    8000043e:	00008517          	auipc	a0,0x8
    80000442:	bda50513          	addi	a0,a0,-1062 # 80008018 <etext+0x18>
    80000446:	37a050ef          	jal	800057c0 <printf>
    kinit();         // physical page allocator
    8000044a:	cabff0ef          	jal	800000f4 <kinit>
    kvminit();       // create kernel page table
    8000044e:	2cc000ef          	jal	8000071a <kvminit>
    kvminithart();   // turn on paging
    80000452:	03c000ef          	jal	8000048e <kvminithart>
    procinit();      // process table
    80000456:	117000ef          	jal	80000d6c <procinit>
    trapinit();      // trap vectors
    8000045a:	51c010ef          	jal	80001976 <trapinit>
    trapinithart();  // install kernel trap vector
    8000045e:	53c010ef          	jal	8000199a <trapinithart>
    plicinit();      // set up interrupt controller
    80000462:	58c040ef          	jal	800049ee <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    80000466:	5a2040ef          	jal	80004a08 <plicinithart>
    binit();         // buffer cache
    8000046a:	411010ef          	jal	8000207a <binit>
    iinit();         // inode table
    8000046e:	162020ef          	jal	800025d0 <iinit>
    fileinit();      // file table
    80000472:	09a030ef          	jal	8000350c <fileinit>
    virtio_disk_init(); // emulated hard disk
    80000476:	682040ef          	jal	80004af8 <virtio_disk_init>
    userinit();      // first user process
    8000047a:	4a5000ef          	jal	8000111e <userinit>
    __sync_synchronize();
    8000047e:	0330000f          	fence	rw,rw
    started = 1;
    80000482:	4785                	li	a5,1
    80000484:	00008717          	auipc	a4,0x8
    80000488:	7ef72e23          	sw	a5,2044(a4) # 80008c80 <started>
    8000048c:	b769                	j	80000416 <main+0x42>

000000008000048e <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    8000048e:	1141                	addi	sp,sp,-16
    80000490:	e406                	sd	ra,8(sp)
    80000492:	e022                	sd	s0,0(sp)
    80000494:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000496:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    8000049a:	00008797          	auipc	a5,0x8
    8000049e:	7ee7b783          	ld	a5,2030(a5) # 80008c88 <kernel_pagetable>
    800004a2:	83b1                	srli	a5,a5,0xc
    800004a4:	577d                	li	a4,-1
    800004a6:	177e                	slli	a4,a4,0x3f
    800004a8:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800004aa:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800004ae:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800004b2:	60a2                	ld	ra,8(sp)
    800004b4:	6402                	ld	s0,0(sp)
    800004b6:	0141                	addi	sp,sp,16
    800004b8:	8082                	ret

00000000800004ba <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800004ba:	7139                	addi	sp,sp,-64
    800004bc:	fc06                	sd	ra,56(sp)
    800004be:	f822                	sd	s0,48(sp)
    800004c0:	f426                	sd	s1,40(sp)
    800004c2:	f04a                	sd	s2,32(sp)
    800004c4:	ec4e                	sd	s3,24(sp)
    800004c6:	e852                	sd	s4,16(sp)
    800004c8:	e456                	sd	s5,8(sp)
    800004ca:	e05a                	sd	s6,0(sp)
    800004cc:	0080                	addi	s0,sp,64
    800004ce:	84aa                	mv	s1,a0
    800004d0:	89ae                	mv	s3,a1
    800004d2:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    800004d4:	57fd                	li	a5,-1
    800004d6:	83e9                	srli	a5,a5,0x1a
    800004d8:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800004da:	4ab1                	li	s5,12
  if(va >= MAXVA)
    800004dc:	04b7e263          	bltu	a5,a1,80000520 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    800004e0:	0149d933          	srl	s2,s3,s4
    800004e4:	1ff97913          	andi	s2,s2,511
    800004e8:	090e                	slli	s2,s2,0x3
    800004ea:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    800004ec:	00093483          	ld	s1,0(s2)
    800004f0:	0014f793          	andi	a5,s1,1
    800004f4:	cf85                	beqz	a5,8000052c <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    800004f6:	80a9                	srli	s1,s1,0xa
    800004f8:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    800004fa:	3a5d                	addiw	s4,s4,-9
    800004fc:	ff5a12e3          	bne	s4,s5,800004e0 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000500:	00c9d513          	srli	a0,s3,0xc
    80000504:	1ff57513          	andi	a0,a0,511
    80000508:	050e                	slli	a0,a0,0x3
    8000050a:	9526                	add	a0,a0,s1
}
    8000050c:	70e2                	ld	ra,56(sp)
    8000050e:	7442                	ld	s0,48(sp)
    80000510:	74a2                	ld	s1,40(sp)
    80000512:	7902                	ld	s2,32(sp)
    80000514:	69e2                	ld	s3,24(sp)
    80000516:	6a42                	ld	s4,16(sp)
    80000518:	6aa2                	ld	s5,8(sp)
    8000051a:	6b02                	ld	s6,0(sp)
    8000051c:	6121                	addi	sp,sp,64
    8000051e:	8082                	ret
    panic("walk");
    80000520:	00008517          	auipc	a0,0x8
    80000524:	b3050513          	addi	a0,a0,-1232 # 80008050 <etext+0x50>
    80000528:	5c2050ef          	jal	80005aea <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000052c:	020b0263          	beqz	s6,80000550 <walk+0x96>
    80000530:	c19ff0ef          	jal	80000148 <kalloc>
    80000534:	84aa                	mv	s1,a0
    80000536:	d979                	beqz	a0,8000050c <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000538:	6605                	lui	a2,0x1
    8000053a:	4581                	li	a1,0
    8000053c:	ce3ff0ef          	jal	8000021e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000540:	00c4d793          	srli	a5,s1,0xc
    80000544:	07aa                	slli	a5,a5,0xa
    80000546:	0017e793          	ori	a5,a5,1
    8000054a:	00f93023          	sd	a5,0(s2)
    8000054e:	b775                	j	800004fa <walk+0x40>
        return 0;
    80000550:	4501                	li	a0,0
    80000552:	bf6d                	j	8000050c <walk+0x52>

0000000080000554 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000554:	57fd                	li	a5,-1
    80000556:	83e9                	srli	a5,a5,0x1a
    80000558:	00b7f463          	bgeu	a5,a1,80000560 <walkaddr+0xc>
    return 0;
    8000055c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000055e:	8082                	ret
{
    80000560:	1141                	addi	sp,sp,-16
    80000562:	e406                	sd	ra,8(sp)
    80000564:	e022                	sd	s0,0(sp)
    80000566:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000568:	4601                	li	a2,0
    8000056a:	f51ff0ef          	jal	800004ba <walk>
  if(pte == 0)
    8000056e:	c901                	beqz	a0,8000057e <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    80000570:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000572:	0117f693          	andi	a3,a5,17
    80000576:	4745                	li	a4,17
    return 0;
    80000578:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000057a:	00e68663          	beq	a3,a4,80000586 <walkaddr+0x32>
}
    8000057e:	60a2                	ld	ra,8(sp)
    80000580:	6402                	ld	s0,0(sp)
    80000582:	0141                	addi	sp,sp,16
    80000584:	8082                	ret
  pa = PTE2PA(*pte);
    80000586:	83a9                	srli	a5,a5,0xa
    80000588:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000058c:	bfcd                	j	8000057e <walkaddr+0x2a>

000000008000058e <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000058e:	715d                	addi	sp,sp,-80
    80000590:	e486                	sd	ra,72(sp)
    80000592:	e0a2                	sd	s0,64(sp)
    80000594:	fc26                	sd	s1,56(sp)
    80000596:	f84a                	sd	s2,48(sp)
    80000598:	f44e                	sd	s3,40(sp)
    8000059a:	f052                	sd	s4,32(sp)
    8000059c:	ec56                	sd	s5,24(sp)
    8000059e:	e85a                	sd	s6,16(sp)
    800005a0:	e45e                	sd	s7,8(sp)
    800005a2:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800005a4:	03459793          	slli	a5,a1,0x34
    800005a8:	eba1                	bnez	a5,800005f8 <mappages+0x6a>
    800005aa:	8a2a                	mv	s4,a0
    800005ac:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800005ae:	03461793          	slli	a5,a2,0x34
    800005b2:	eba9                	bnez	a5,80000604 <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    800005b4:	ce31                	beqz	a2,80000610 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800005b6:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    800005ba:	80060613          	addi	a2,a2,-2048
    800005be:	00b60933          	add	s2,a2,a1
  a = va;
    800005c2:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800005c4:	4b05                	li	s6,1
    800005c6:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800005ca:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    800005cc:	865a                	mv	a2,s6
    800005ce:	85a6                	mv	a1,s1
    800005d0:	8552                	mv	a0,s4
    800005d2:	ee9ff0ef          	jal	800004ba <walk>
    800005d6:	c929                	beqz	a0,80000628 <mappages+0x9a>
    if(*pte & PTE_V)
    800005d8:	611c                	ld	a5,0(a0)
    800005da:	8b85                	andi	a5,a5,1
    800005dc:	e3a1                	bnez	a5,8000061c <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800005de:	013487b3          	add	a5,s1,s3
    800005e2:	83b1                	srli	a5,a5,0xc
    800005e4:	07aa                	slli	a5,a5,0xa
    800005e6:	0157e7b3          	or	a5,a5,s5
    800005ea:	0017e793          	ori	a5,a5,1
    800005ee:	e11c                	sd	a5,0(a0)
    if(a == last)
    800005f0:	05248863          	beq	s1,s2,80000640 <mappages+0xb2>
    a += PGSIZE;
    800005f4:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    800005f6:	bfd9                	j	800005cc <mappages+0x3e>
    panic("mappages: va not aligned");
    800005f8:	00008517          	auipc	a0,0x8
    800005fc:	a6050513          	addi	a0,a0,-1440 # 80008058 <etext+0x58>
    80000600:	4ea050ef          	jal	80005aea <panic>
    panic("mappages: size not aligned");
    80000604:	00008517          	auipc	a0,0x8
    80000608:	a7450513          	addi	a0,a0,-1420 # 80008078 <etext+0x78>
    8000060c:	4de050ef          	jal	80005aea <panic>
    panic("mappages: size");
    80000610:	00008517          	auipc	a0,0x8
    80000614:	a8850513          	addi	a0,a0,-1400 # 80008098 <etext+0x98>
    80000618:	4d2050ef          	jal	80005aea <panic>
      panic("mappages: remap");
    8000061c:	00008517          	auipc	a0,0x8
    80000620:	a8c50513          	addi	a0,a0,-1396 # 800080a8 <etext+0xa8>
    80000624:	4c6050ef          	jal	80005aea <panic>
      return -1;
    80000628:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000062a:	60a6                	ld	ra,72(sp)
    8000062c:	6406                	ld	s0,64(sp)
    8000062e:	74e2                	ld	s1,56(sp)
    80000630:	7942                	ld	s2,48(sp)
    80000632:	79a2                	ld	s3,40(sp)
    80000634:	7a02                	ld	s4,32(sp)
    80000636:	6ae2                	ld	s5,24(sp)
    80000638:	6b42                	ld	s6,16(sp)
    8000063a:	6ba2                	ld	s7,8(sp)
    8000063c:	6161                	addi	sp,sp,80
    8000063e:	8082                	ret
  return 0;
    80000640:	4501                	li	a0,0
    80000642:	b7e5                	j	8000062a <mappages+0x9c>

0000000080000644 <kvmmap>:
{
    80000644:	1141                	addi	sp,sp,-16
    80000646:	e406                	sd	ra,8(sp)
    80000648:	e022                	sd	s0,0(sp)
    8000064a:	0800                	addi	s0,sp,16
    8000064c:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000064e:	86b2                	mv	a3,a2
    80000650:	863e                	mv	a2,a5
    80000652:	f3dff0ef          	jal	8000058e <mappages>
    80000656:	e509                	bnez	a0,80000660 <kvmmap+0x1c>
}
    80000658:	60a2                	ld	ra,8(sp)
    8000065a:	6402                	ld	s0,0(sp)
    8000065c:	0141                	addi	sp,sp,16
    8000065e:	8082                	ret
    panic("kvmmap");
    80000660:	00008517          	auipc	a0,0x8
    80000664:	a5850513          	addi	a0,a0,-1448 # 800080b8 <etext+0xb8>
    80000668:	482050ef          	jal	80005aea <panic>

000000008000066c <kvmmake>:
{
    8000066c:	1101                	addi	sp,sp,-32
    8000066e:	ec06                	sd	ra,24(sp)
    80000670:	e822                	sd	s0,16(sp)
    80000672:	e426                	sd	s1,8(sp)
    80000674:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    80000676:	ad3ff0ef          	jal	80000148 <kalloc>
    8000067a:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    8000067c:	6605                	lui	a2,0x1
    8000067e:	4581                	li	a1,0
    80000680:	b9fff0ef          	jal	8000021e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000684:	4719                	li	a4,6
    80000686:	6685                	lui	a3,0x1
    80000688:	10000637          	lui	a2,0x10000
    8000068c:	85b2                	mv	a1,a2
    8000068e:	8526                	mv	a0,s1
    80000690:	fb5ff0ef          	jal	80000644 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000694:	4719                	li	a4,6
    80000696:	6685                	lui	a3,0x1
    80000698:	10001637          	lui	a2,0x10001
    8000069c:	85b2                	mv	a1,a2
    8000069e:	8526                	mv	a0,s1
    800006a0:	fa5ff0ef          	jal	80000644 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800006a4:	4719                	li	a4,6
    800006a6:	040006b7          	lui	a3,0x4000
    800006aa:	0c000637          	lui	a2,0xc000
    800006ae:	85b2                	mv	a1,a2
    800006b0:	8526                	mv	a0,s1
    800006b2:	f93ff0ef          	jal	80000644 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800006b6:	4729                	li	a4,10
    800006b8:	80008697          	auipc	a3,0x80008
    800006bc:	94868693          	addi	a3,a3,-1720 # 8000 <_entry-0x7fff8000>
    800006c0:	4605                	li	a2,1
    800006c2:	067e                	slli	a2,a2,0x1f
    800006c4:	85b2                	mv	a1,a2
    800006c6:	8526                	mv	a0,s1
    800006c8:	f7dff0ef          	jal	80000644 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800006cc:	4719                	li	a4,6
    800006ce:	00008697          	auipc	a3,0x8
    800006d2:	93268693          	addi	a3,a3,-1742 # 80008000 <etext>
    800006d6:	47c5                	li	a5,17
    800006d8:	07ee                	slli	a5,a5,0x1b
    800006da:	40d786b3          	sub	a3,a5,a3
    800006de:	00008617          	auipc	a2,0x8
    800006e2:	92260613          	addi	a2,a2,-1758 # 80008000 <etext>
    800006e6:	85b2                	mv	a1,a2
    800006e8:	8526                	mv	a0,s1
    800006ea:	f5bff0ef          	jal	80000644 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006ee:	4729                	li	a4,10
    800006f0:	6685                	lui	a3,0x1
    800006f2:	00007617          	auipc	a2,0x7
    800006f6:	90e60613          	addi	a2,a2,-1778 # 80007000 <_trampoline>
    800006fa:	040005b7          	lui	a1,0x4000
    800006fe:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000700:	05b2                	slli	a1,a1,0xc
    80000702:	8526                	mv	a0,s1
    80000704:	f41ff0ef          	jal	80000644 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000708:	8526                	mv	a0,s1
    8000070a:	5c4000ef          	jal	80000cce <proc_mapstacks>
}
    8000070e:	8526                	mv	a0,s1
    80000710:	60e2                	ld	ra,24(sp)
    80000712:	6442                	ld	s0,16(sp)
    80000714:	64a2                	ld	s1,8(sp)
    80000716:	6105                	addi	sp,sp,32
    80000718:	8082                	ret

000000008000071a <kvminit>:
{
    8000071a:	1141                	addi	sp,sp,-16
    8000071c:	e406                	sd	ra,8(sp)
    8000071e:	e022                	sd	s0,0(sp)
    80000720:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000722:	f4bff0ef          	jal	8000066c <kvmmake>
    80000726:	00008797          	auipc	a5,0x8
    8000072a:	56a7b123          	sd	a0,1378(a5) # 80008c88 <kernel_pagetable>
}
    8000072e:	60a2                	ld	ra,8(sp)
    80000730:	6402                	ld	s0,0(sp)
    80000732:	0141                	addi	sp,sp,16
    80000734:	8082                	ret

0000000080000736 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    80000736:	1101                	addi	sp,sp,-32
    80000738:	ec06                	sd	ra,24(sp)
    8000073a:	e822                	sd	s0,16(sp)
    8000073c:	e426                	sd	s1,8(sp)
    8000073e:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000740:	a09ff0ef          	jal	80000148 <kalloc>
    80000744:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000746:	c509                	beqz	a0,80000750 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000748:	6605                	lui	a2,0x1
    8000074a:	4581                	li	a1,0
    8000074c:	ad3ff0ef          	jal	8000021e <memset>
  return pagetable;
}
    80000750:	8526                	mv	a0,s1
    80000752:	60e2                	ld	ra,24(sp)
    80000754:	6442                	ld	s0,16(sp)
    80000756:	64a2                	ld	s1,8(sp)
    80000758:	6105                	addi	sp,sp,32
    8000075a:	8082                	ret

000000008000075c <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    8000075c:	7139                	addi	sp,sp,-64
    8000075e:	fc06                	sd	ra,56(sp)
    80000760:	f822                	sd	s0,48(sp)
    80000762:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000764:	03459793          	slli	a5,a1,0x34
    80000768:	e38d                	bnez	a5,8000078a <uvmunmap+0x2e>
    8000076a:	f04a                	sd	s2,32(sp)
    8000076c:	ec4e                	sd	s3,24(sp)
    8000076e:	e852                	sd	s4,16(sp)
    80000770:	e456                	sd	s5,8(sp)
    80000772:	e05a                	sd	s6,0(sp)
    80000774:	8a2a                	mv	s4,a0
    80000776:	892e                	mv	s2,a1
    80000778:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    8000077a:	0632                	slli	a2,a2,0xc
    8000077c:	00b609b3          	add	s3,a2,a1
    80000780:	6b05                	lui	s6,0x1
    80000782:	0535f963          	bgeu	a1,s3,800007d4 <uvmunmap+0x78>
    80000786:	f426                	sd	s1,40(sp)
    80000788:	a015                	j	800007ac <uvmunmap+0x50>
    8000078a:	f426                	sd	s1,40(sp)
    8000078c:	f04a                	sd	s2,32(sp)
    8000078e:	ec4e                	sd	s3,24(sp)
    80000790:	e852                	sd	s4,16(sp)
    80000792:	e456                	sd	s5,8(sp)
    80000794:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80000796:	00008517          	auipc	a0,0x8
    8000079a:	92a50513          	addi	a0,a0,-1750 # 800080c0 <etext+0xc0>
    8000079e:	34c050ef          	jal	80005aea <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800007a2:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007a6:	995a                	add	s2,s2,s6
    800007a8:	03397563          	bgeu	s2,s3,800007d2 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800007ac:	4601                	li	a2,0
    800007ae:	85ca                	mv	a1,s2
    800007b0:	8552                	mv	a0,s4
    800007b2:	d09ff0ef          	jal	800004ba <walk>
    800007b6:	84aa                	mv	s1,a0
    800007b8:	d57d                	beqz	a0,800007a6 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800007ba:	611c                	ld	a5,0(a0)
    800007bc:	0017f713          	andi	a4,a5,1
    800007c0:	d37d                	beqz	a4,800007a6 <uvmunmap+0x4a>
    if(do_free){
    800007c2:	fe0a80e3          	beqz	s5,800007a2 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    800007c6:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800007c8:	00c79513          	slli	a0,a5,0xc
    800007cc:	851ff0ef          	jal	8000001c <kfree>
    800007d0:	bfc9                	j	800007a2 <uvmunmap+0x46>
    800007d2:	74a2                	ld	s1,40(sp)
    800007d4:	7902                	ld	s2,32(sp)
    800007d6:	69e2                	ld	s3,24(sp)
    800007d8:	6a42                	ld	s4,16(sp)
    800007da:	6aa2                	ld	s5,8(sp)
    800007dc:	6b02                	ld	s6,0(sp)
  }
}
    800007de:	70e2                	ld	ra,56(sp)
    800007e0:	7442                	ld	s0,48(sp)
    800007e2:	6121                	addi	sp,sp,64
    800007e4:	8082                	ret

00000000800007e6 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    800007e6:	1101                	addi	sp,sp,-32
    800007e8:	ec06                	sd	ra,24(sp)
    800007ea:	e822                	sd	s0,16(sp)
    800007ec:	e426                	sd	s1,8(sp)
    800007ee:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    800007f0:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    800007f2:	00b67d63          	bgeu	a2,a1,8000080c <uvmdealloc+0x26>
    800007f6:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    800007f8:	6785                	lui	a5,0x1
    800007fa:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007fc:	00f60733          	add	a4,a2,a5
    80000800:	76fd                	lui	a3,0xfffff
    80000802:	8f75                	and	a4,a4,a3
    80000804:	97ae                	add	a5,a5,a1
    80000806:	8ff5                	and	a5,a5,a3
    80000808:	00f76863          	bltu	a4,a5,80000818 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000080c:	8526                	mv	a0,s1
    8000080e:	60e2                	ld	ra,24(sp)
    80000810:	6442                	ld	s0,16(sp)
    80000812:	64a2                	ld	s1,8(sp)
    80000814:	6105                	addi	sp,sp,32
    80000816:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000818:	8f99                	sub	a5,a5,a4
    8000081a:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000081c:	4685                	li	a3,1
    8000081e:	0007861b          	sext.w	a2,a5
    80000822:	85ba                	mv	a1,a4
    80000824:	f39ff0ef          	jal	8000075c <uvmunmap>
    80000828:	b7d5                	j	8000080c <uvmdealloc+0x26>

000000008000082a <uvmalloc>:
  if(newsz < oldsz)
    8000082a:	0ab66163          	bltu	a2,a1,800008cc <uvmalloc+0xa2>
{
    8000082e:	715d                	addi	sp,sp,-80
    80000830:	e486                	sd	ra,72(sp)
    80000832:	e0a2                	sd	s0,64(sp)
    80000834:	f84a                	sd	s2,48(sp)
    80000836:	f052                	sd	s4,32(sp)
    80000838:	ec56                	sd	s5,24(sp)
    8000083a:	e45e                	sd	s7,8(sp)
    8000083c:	0880                	addi	s0,sp,80
    8000083e:	8aaa                	mv	s5,a0
    80000840:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000842:	6785                	lui	a5,0x1
    80000844:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000846:	95be                	add	a1,a1,a5
    80000848:	77fd                	lui	a5,0xfffff
    8000084a:	00f5f933          	and	s2,a1,a5
    8000084e:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000850:	08c97063          	bgeu	s2,a2,800008d0 <uvmalloc+0xa6>
    80000854:	fc26                	sd	s1,56(sp)
    80000856:	f44e                	sd	s3,40(sp)
    80000858:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    8000085a:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000085c:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000860:	8e9ff0ef          	jal	80000148 <kalloc>
    80000864:	84aa                	mv	s1,a0
    if(mem == 0){
    80000866:	c50d                	beqz	a0,80000890 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    80000868:	864e                	mv	a2,s3
    8000086a:	4581                	li	a1,0
    8000086c:	9b3ff0ef          	jal	8000021e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000870:	875a                	mv	a4,s6
    80000872:	86a6                	mv	a3,s1
    80000874:	864e                	mv	a2,s3
    80000876:	85ca                	mv	a1,s2
    80000878:	8556                	mv	a0,s5
    8000087a:	d15ff0ef          	jal	8000058e <mappages>
    8000087e:	e915                	bnez	a0,800008b2 <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000880:	994e                	add	s2,s2,s3
    80000882:	fd496fe3          	bltu	s2,s4,80000860 <uvmalloc+0x36>
  return newsz;
    80000886:	8552                	mv	a0,s4
    80000888:	74e2                	ld	s1,56(sp)
    8000088a:	79a2                	ld	s3,40(sp)
    8000088c:	6b42                	ld	s6,16(sp)
    8000088e:	a811                	j	800008a2 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80000890:	865e                	mv	a2,s7
    80000892:	85ca                	mv	a1,s2
    80000894:	8556                	mv	a0,s5
    80000896:	f51ff0ef          	jal	800007e6 <uvmdealloc>
      return 0;
    8000089a:	4501                	li	a0,0
    8000089c:	74e2                	ld	s1,56(sp)
    8000089e:	79a2                	ld	s3,40(sp)
    800008a0:	6b42                	ld	s6,16(sp)
}
    800008a2:	60a6                	ld	ra,72(sp)
    800008a4:	6406                	ld	s0,64(sp)
    800008a6:	7942                	ld	s2,48(sp)
    800008a8:	7a02                	ld	s4,32(sp)
    800008aa:	6ae2                	ld	s5,24(sp)
    800008ac:	6ba2                	ld	s7,8(sp)
    800008ae:	6161                	addi	sp,sp,80
    800008b0:	8082                	ret
      kfree(mem);
    800008b2:	8526                	mv	a0,s1
    800008b4:	f68ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800008b8:	865e                	mv	a2,s7
    800008ba:	85ca                	mv	a1,s2
    800008bc:	8556                	mv	a0,s5
    800008be:	f29ff0ef          	jal	800007e6 <uvmdealloc>
      return 0;
    800008c2:	4501                	li	a0,0
    800008c4:	74e2                	ld	s1,56(sp)
    800008c6:	79a2                	ld	s3,40(sp)
    800008c8:	6b42                	ld	s6,16(sp)
    800008ca:	bfe1                	j	800008a2 <uvmalloc+0x78>
    return oldsz;
    800008cc:	852e                	mv	a0,a1
}
    800008ce:	8082                	ret
  return newsz;
    800008d0:	8532                	mv	a0,a2
    800008d2:	bfc1                	j	800008a2 <uvmalloc+0x78>

00000000800008d4 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    800008d4:	7179                	addi	sp,sp,-48
    800008d6:	f406                	sd	ra,40(sp)
    800008d8:	f022                	sd	s0,32(sp)
    800008da:	ec26                	sd	s1,24(sp)
    800008dc:	e84a                	sd	s2,16(sp)
    800008de:	e44e                	sd	s3,8(sp)
    800008e0:	1800                	addi	s0,sp,48
    800008e2:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    800008e4:	84aa                	mv	s1,a0
    800008e6:	6905                	lui	s2,0x1
    800008e8:	992a                	add	s2,s2,a0
    800008ea:	a811                	j	800008fe <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    800008ec:	00007517          	auipc	a0,0x7
    800008f0:	7ec50513          	addi	a0,a0,2028 # 800080d8 <etext+0xd8>
    800008f4:	1f6050ef          	jal	80005aea <panic>
  for(int i = 0; i < 512; i++){
    800008f8:	04a1                	addi	s1,s1,8
    800008fa:	03248163          	beq	s1,s2,8000091c <freewalk+0x48>
    pte_t pte = pagetable[i];
    800008fe:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000900:	0017f713          	andi	a4,a5,1
    80000904:	db75                	beqz	a4,800008f8 <freewalk+0x24>
    80000906:	00e7f713          	andi	a4,a5,14
    8000090a:	f36d                	bnez	a4,800008ec <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    8000090c:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000090e:	00c79513          	slli	a0,a5,0xc
    80000912:	fc3ff0ef          	jal	800008d4 <freewalk>
      pagetable[i] = 0;
    80000916:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000091a:	bff9                	j	800008f8 <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    8000091c:	854e                	mv	a0,s3
    8000091e:	efeff0ef          	jal	8000001c <kfree>
}
    80000922:	70a2                	ld	ra,40(sp)
    80000924:	7402                	ld	s0,32(sp)
    80000926:	64e2                	ld	s1,24(sp)
    80000928:	6942                	ld	s2,16(sp)
    8000092a:	69a2                	ld	s3,8(sp)
    8000092c:	6145                	addi	sp,sp,48
    8000092e:	8082                	ret

0000000080000930 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000930:	1101                	addi	sp,sp,-32
    80000932:	ec06                	sd	ra,24(sp)
    80000934:	e822                	sd	s0,16(sp)
    80000936:	e426                	sd	s1,8(sp)
    80000938:	1000                	addi	s0,sp,32
    8000093a:	84aa                	mv	s1,a0
  if(sz > 0)
    8000093c:	e989                	bnez	a1,8000094e <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000093e:	8526                	mv	a0,s1
    80000940:	f95ff0ef          	jal	800008d4 <freewalk>
}
    80000944:	60e2                	ld	ra,24(sp)
    80000946:	6442                	ld	s0,16(sp)
    80000948:	64a2                	ld	s1,8(sp)
    8000094a:	6105                	addi	sp,sp,32
    8000094c:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000094e:	6785                	lui	a5,0x1
    80000950:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000952:	95be                	add	a1,a1,a5
    80000954:	4685                	li	a3,1
    80000956:	00c5d613          	srli	a2,a1,0xc
    8000095a:	4581                	li	a1,0
    8000095c:	e01ff0ef          	jal	8000075c <uvmunmap>
    80000960:	bff9                	j	8000093e <uvmfree+0xe>

0000000080000962 <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    80000962:	ca59                	beqz	a2,800009f8 <uvmcopy+0x96>
{
    80000964:	715d                	addi	sp,sp,-80
    80000966:	e486                	sd	ra,72(sp)
    80000968:	e0a2                	sd	s0,64(sp)
    8000096a:	fc26                	sd	s1,56(sp)
    8000096c:	f84a                	sd	s2,48(sp)
    8000096e:	f44e                	sd	s3,40(sp)
    80000970:	f052                	sd	s4,32(sp)
    80000972:	ec56                	sd	s5,24(sp)
    80000974:	e85a                	sd	s6,16(sp)
    80000976:	e45e                	sd	s7,8(sp)
    80000978:	0880                	addi	s0,sp,80
    8000097a:	8b2a                	mv	s6,a0
    8000097c:	8bae                	mv	s7,a1
    8000097e:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000980:	4481                	li	s1,0
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000982:	6a05                	lui	s4,0x1
    80000984:	a021                	j	8000098c <uvmcopy+0x2a>
  for(i = 0; i < sz; i += PGSIZE){
    80000986:	94d2                	add	s1,s1,s4
    80000988:	0554fc63          	bgeu	s1,s5,800009e0 <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    8000098c:	4601                	li	a2,0
    8000098e:	85a6                	mv	a1,s1
    80000990:	855a                	mv	a0,s6
    80000992:	b29ff0ef          	jal	800004ba <walk>
    80000996:	d965                	beqz	a0,80000986 <uvmcopy+0x24>
    if((*pte & PTE_V) == 0)
    80000998:	00053983          	ld	s3,0(a0)
    8000099c:	0019f793          	andi	a5,s3,1
    800009a0:	d3fd                	beqz	a5,80000986 <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    800009a2:	fa6ff0ef          	jal	80000148 <kalloc>
    800009a6:	892a                	mv	s2,a0
    800009a8:	c11d                	beqz	a0,800009ce <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    800009aa:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    800009ae:	8652                	mv	a2,s4
    800009b0:	05b2                	slli	a1,a1,0xc
    800009b2:	8cdff0ef          	jal	8000027e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800009b6:	3ff9f713          	andi	a4,s3,1023
    800009ba:	86ca                	mv	a3,s2
    800009bc:	8652                	mv	a2,s4
    800009be:	85a6                	mv	a1,s1
    800009c0:	855e                	mv	a0,s7
    800009c2:	bcdff0ef          	jal	8000058e <mappages>
    800009c6:	d161                	beqz	a0,80000986 <uvmcopy+0x24>
      kfree(mem);
    800009c8:	854a                	mv	a0,s2
    800009ca:	e52ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800009ce:	4685                	li	a3,1
    800009d0:	00c4d613          	srli	a2,s1,0xc
    800009d4:	4581                	li	a1,0
    800009d6:	855e                	mv	a0,s7
    800009d8:	d85ff0ef          	jal	8000075c <uvmunmap>
  return -1;
    800009dc:	557d                	li	a0,-1
    800009de:	a011                	j	800009e2 <uvmcopy+0x80>
  return 0;
    800009e0:	4501                	li	a0,0
}
    800009e2:	60a6                	ld	ra,72(sp)
    800009e4:	6406                	ld	s0,64(sp)
    800009e6:	74e2                	ld	s1,56(sp)
    800009e8:	7942                	ld	s2,48(sp)
    800009ea:	79a2                	ld	s3,40(sp)
    800009ec:	7a02                	ld	s4,32(sp)
    800009ee:	6ae2                	ld	s5,24(sp)
    800009f0:	6b42                	ld	s6,16(sp)
    800009f2:	6ba2                	ld	s7,8(sp)
    800009f4:	6161                	addi	sp,sp,80
    800009f6:	8082                	ret
  return 0;
    800009f8:	4501                	li	a0,0
}
    800009fa:	8082                	ret

00000000800009fc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    800009fc:	1141                	addi	sp,sp,-16
    800009fe:	e406                	sd	ra,8(sp)
    80000a00:	e022                	sd	s0,0(sp)
    80000a02:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000a04:	4601                	li	a2,0
    80000a06:	ab5ff0ef          	jal	800004ba <walk>
  if(pte == 0)
    80000a0a:	c901                	beqz	a0,80000a1a <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000a0c:	611c                	ld	a5,0(a0)
    80000a0e:	9bbd                	andi	a5,a5,-17
    80000a10:	e11c                	sd	a5,0(a0)
}
    80000a12:	60a2                	ld	ra,8(sp)
    80000a14:	6402                	ld	s0,0(sp)
    80000a16:	0141                	addi	sp,sp,16
    80000a18:	8082                	ret
    panic("uvmclear");
    80000a1a:	00007517          	auipc	a0,0x7
    80000a1e:	6ce50513          	addi	a0,a0,1742 # 800080e8 <etext+0xe8>
    80000a22:	0c8050ef          	jal	80005aea <panic>

0000000080000a26 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000a26:	cac5                	beqz	a3,80000ad6 <copyinstr+0xb0>
{
    80000a28:	715d                	addi	sp,sp,-80
    80000a2a:	e486                	sd	ra,72(sp)
    80000a2c:	e0a2                	sd	s0,64(sp)
    80000a2e:	fc26                	sd	s1,56(sp)
    80000a30:	f84a                	sd	s2,48(sp)
    80000a32:	f44e                	sd	s3,40(sp)
    80000a34:	f052                	sd	s4,32(sp)
    80000a36:	ec56                	sd	s5,24(sp)
    80000a38:	e85a                	sd	s6,16(sp)
    80000a3a:	e45e                	sd	s7,8(sp)
    80000a3c:	0880                	addi	s0,sp,80
    80000a3e:	8aaa                	mv	s5,a0
    80000a40:	84ae                	mv	s1,a1
    80000a42:	8bb2                	mv	s7,a2
    80000a44:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000a46:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000a48:	6a05                	lui	s4,0x1
    80000a4a:	a82d                	j	80000a84 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000a4c:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80000a50:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000a52:	0017c793          	xori	a5,a5,1
    80000a56:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000a5a:	60a6                	ld	ra,72(sp)
    80000a5c:	6406                	ld	s0,64(sp)
    80000a5e:	74e2                	ld	s1,56(sp)
    80000a60:	7942                	ld	s2,48(sp)
    80000a62:	79a2                	ld	s3,40(sp)
    80000a64:	7a02                	ld	s4,32(sp)
    80000a66:	6ae2                	ld	s5,24(sp)
    80000a68:	6b42                	ld	s6,16(sp)
    80000a6a:	6ba2                	ld	s7,8(sp)
    80000a6c:	6161                	addi	sp,sp,80
    80000a6e:	8082                	ret
    80000a70:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80000a74:	9726                	add	a4,a4,s1
      --max;
    80000a76:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80000a7a:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000a7e:	04e58463          	beq	a1,a4,80000ac6 <copyinstr+0xa0>
{
    80000a82:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80000a84:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000a88:	85ca                	mv	a1,s2
    80000a8a:	8556                	mv	a0,s5
    80000a8c:	ac9ff0ef          	jal	80000554 <walkaddr>
    if(pa0 == 0)
    80000a90:	cd0d                	beqz	a0,80000aca <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000a92:	417906b3          	sub	a3,s2,s7
    80000a96:	96d2                	add	a3,a3,s4
    if(n > max)
    80000a98:	00d9f363          	bgeu	s3,a3,80000a9e <copyinstr+0x78>
    80000a9c:	86ce                	mv	a3,s3
    while(n > 0){
    80000a9e:	ca85                	beqz	a3,80000ace <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80000aa0:	01750633          	add	a2,a0,s7
    80000aa4:	41260633          	sub	a2,a2,s2
    80000aa8:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80000aaa:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80000aac:	96a6                	add	a3,a3,s1
    80000aae:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000ab0:	00f60733          	add	a4,a2,a5
    80000ab4:	00074703          	lbu	a4,0(a4)
    80000ab8:	db51                	beqz	a4,80000a4c <copyinstr+0x26>
        *dst = *p;
    80000aba:	00e78023          	sb	a4,0(a5)
      dst++;
    80000abe:	0785                	addi	a5,a5,1
    while(n > 0){
    80000ac0:	fed797e3          	bne	a5,a3,80000aae <copyinstr+0x88>
    80000ac4:	b775                	j	80000a70 <copyinstr+0x4a>
    80000ac6:	4781                	li	a5,0
    80000ac8:	b769                	j	80000a52 <copyinstr+0x2c>
      return -1;
    80000aca:	557d                	li	a0,-1
    80000acc:	b779                	j	80000a5a <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80000ace:	6b85                	lui	s7,0x1
    80000ad0:	9bca                	add	s7,s7,s2
    80000ad2:	87a6                	mv	a5,s1
    80000ad4:	b77d                	j	80000a82 <copyinstr+0x5c>
  int got_null = 0;
    80000ad6:	4781                	li	a5,0
  if(got_null){
    80000ad8:	0017c793          	xori	a5,a5,1
    80000adc:	40f0053b          	negw	a0,a5
}
    80000ae0:	8082                	ret

0000000080000ae2 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80000ae2:	1141                	addi	sp,sp,-16
    80000ae4:	e406                	sd	ra,8(sp)
    80000ae6:	e022                	sd	s0,0(sp)
    80000ae8:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000aea:	4601                	li	a2,0
    80000aec:	9cfff0ef          	jal	800004ba <walk>
  if (pte == 0) {
    80000af0:	c119                	beqz	a0,80000af6 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    80000af2:	6108                	ld	a0,0(a0)
    80000af4:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000af6:	60a2                	ld	ra,8(sp)
    80000af8:	6402                	ld	s0,0(sp)
    80000afa:	0141                	addi	sp,sp,16
    80000afc:	8082                	ret

0000000080000afe <vmfault>:
{
    80000afe:	7179                	addi	sp,sp,-48
    80000b00:	f406                	sd	ra,40(sp)
    80000b02:	f022                	sd	s0,32(sp)
    80000b04:	e84a                	sd	s2,16(sp)
    80000b06:	e44e                	sd	s3,8(sp)
    80000b08:	1800                	addi	s0,sp,48
    80000b0a:	89aa                	mv	s3,a0
    80000b0c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80000b0e:	342000ef          	jal	80000e50 <myproc>
  if (va >= p->sz)
    80000b12:	693c                	ld	a5,80(a0)
    80000b14:	00f96a63          	bltu	s2,a5,80000b28 <vmfault+0x2a>
    return 0;
    80000b18:	4981                	li	s3,0
}
    80000b1a:	854e                	mv	a0,s3
    80000b1c:	70a2                	ld	ra,40(sp)
    80000b1e:	7402                	ld	s0,32(sp)
    80000b20:	6942                	ld	s2,16(sp)
    80000b22:	69a2                	ld	s3,8(sp)
    80000b24:	6145                	addi	sp,sp,48
    80000b26:	8082                	ret
    80000b28:	ec26                	sd	s1,24(sp)
    80000b2a:	e052                	sd	s4,0(sp)
    80000b2c:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80000b2e:	77fd                	lui	a5,0xfffff
    80000b30:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80000b34:	85d2                	mv	a1,s4
    80000b36:	854e                	mv	a0,s3
    80000b38:	fabff0ef          	jal	80000ae2 <ismapped>
    return 0;
    80000b3c:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000b3e:	c501                	beqz	a0,80000b46 <vmfault+0x48>
    80000b40:	64e2                	ld	s1,24(sp)
    80000b42:	6a02                	ld	s4,0(sp)
    80000b44:	bfd9                	j	80000b1a <vmfault+0x1c>
  mem = (uint64) kalloc();
    80000b46:	e02ff0ef          	jal	80000148 <kalloc>
    80000b4a:	892a                	mv	s2,a0
  if(mem == 0)
    80000b4c:	c905                	beqz	a0,80000b7c <vmfault+0x7e>
  mem = (uint64) kalloc();
    80000b4e:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000b50:	6605                	lui	a2,0x1
    80000b52:	4581                	li	a1,0
    80000b54:	ecaff0ef          	jal	8000021e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000b58:	4759                	li	a4,22
    80000b5a:	86ca                	mv	a3,s2
    80000b5c:	6605                	lui	a2,0x1
    80000b5e:	85d2                	mv	a1,s4
    80000b60:	6ca8                	ld	a0,88(s1)
    80000b62:	a2dff0ef          	jal	8000058e <mappages>
    80000b66:	e501                	bnez	a0,80000b6e <vmfault+0x70>
    80000b68:	64e2                	ld	s1,24(sp)
    80000b6a:	6a02                	ld	s4,0(sp)
    80000b6c:	b77d                	j	80000b1a <vmfault+0x1c>
    kfree((void *)mem);
    80000b6e:	854a                	mv	a0,s2
    80000b70:	cacff0ef          	jal	8000001c <kfree>
    return 0;
    80000b74:	4981                	li	s3,0
    80000b76:	64e2                	ld	s1,24(sp)
    80000b78:	6a02                	ld	s4,0(sp)
    80000b7a:	b745                	j	80000b1a <vmfault+0x1c>
    80000b7c:	64e2                	ld	s1,24(sp)
    80000b7e:	6a02                	ld	s4,0(sp)
    80000b80:	bf69                	j	80000b1a <vmfault+0x1c>

0000000080000b82 <copyout>:
  while(len > 0){
    80000b82:	cad1                	beqz	a3,80000c16 <copyout+0x94>
{
    80000b84:	711d                	addi	sp,sp,-96
    80000b86:	ec86                	sd	ra,88(sp)
    80000b88:	e8a2                	sd	s0,80(sp)
    80000b8a:	e4a6                	sd	s1,72(sp)
    80000b8c:	e0ca                	sd	s2,64(sp)
    80000b8e:	fc4e                	sd	s3,56(sp)
    80000b90:	f852                	sd	s4,48(sp)
    80000b92:	f456                	sd	s5,40(sp)
    80000b94:	f05a                	sd	s6,32(sp)
    80000b96:	ec5e                	sd	s7,24(sp)
    80000b98:	e862                	sd	s8,16(sp)
    80000b9a:	e466                	sd	s9,8(sp)
    80000b9c:	e06a                	sd	s10,0(sp)
    80000b9e:	1080                	addi	s0,sp,96
    80000ba0:	8baa                	mv	s7,a0
    80000ba2:	8a2e                	mv	s4,a1
    80000ba4:	8b32                	mv	s6,a2
    80000ba6:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000ba8:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80000baa:	5cfd                	li	s9,-1
    80000bac:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000bb0:	6c05                	lui	s8,0x1
    80000bb2:	a005                	j	80000bd2 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000bb4:	409a0533          	sub	a0,s4,s1
    80000bb8:	0009061b          	sext.w	a2,s2
    80000bbc:	85da                	mv	a1,s6
    80000bbe:	954e                	add	a0,a0,s3
    80000bc0:	ebeff0ef          	jal	8000027e <memmove>
    len -= n;
    80000bc4:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000bc8:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000bca:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80000bce:	040a8263          	beqz	s5,80000c12 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    80000bd2:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    80000bd6:	049ce263          	bltu	s9,s1,80000c1a <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    80000bda:	85a6                	mv	a1,s1
    80000bdc:	855e                	mv	a0,s7
    80000bde:	977ff0ef          	jal	80000554 <walkaddr>
    80000be2:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80000be4:	e901                	bnez	a0,80000bf4 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000be6:	4601                	li	a2,0
    80000be8:	85a6                	mv	a1,s1
    80000bea:	855e                	mv	a0,s7
    80000bec:	f13ff0ef          	jal	80000afe <vmfault>
    80000bf0:	89aa                	mv	s3,a0
    80000bf2:	c139                	beqz	a0,80000c38 <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    80000bf4:	4601                	li	a2,0
    80000bf6:	85a6                	mv	a1,s1
    80000bf8:	855e                	mv	a0,s7
    80000bfa:	8c1ff0ef          	jal	800004ba <walk>
    if((*pte & PTE_W) == 0)
    80000bfe:	611c                	ld	a5,0(a0)
    80000c00:	8b91                	andi	a5,a5,4
    80000c02:	cf8d                	beqz	a5,80000c3c <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    80000c04:	41448933          	sub	s2,s1,s4
    80000c08:	9962                	add	s2,s2,s8
    if(n > len)
    80000c0a:	fb2af5e3          	bgeu	s5,s2,80000bb4 <copyout+0x32>
    80000c0e:	8956                	mv	s2,s5
    80000c10:	b755                	j	80000bb4 <copyout+0x32>
  return 0;
    80000c12:	4501                	li	a0,0
    80000c14:	a021                	j	80000c1c <copyout+0x9a>
    80000c16:	4501                	li	a0,0
}
    80000c18:	8082                	ret
      return -1;
    80000c1a:	557d                	li	a0,-1
}
    80000c1c:	60e6                	ld	ra,88(sp)
    80000c1e:	6446                	ld	s0,80(sp)
    80000c20:	64a6                	ld	s1,72(sp)
    80000c22:	6906                	ld	s2,64(sp)
    80000c24:	79e2                	ld	s3,56(sp)
    80000c26:	7a42                	ld	s4,48(sp)
    80000c28:	7aa2                	ld	s5,40(sp)
    80000c2a:	7b02                	ld	s6,32(sp)
    80000c2c:	6be2                	ld	s7,24(sp)
    80000c2e:	6c42                	ld	s8,16(sp)
    80000c30:	6ca2                	ld	s9,8(sp)
    80000c32:	6d02                	ld	s10,0(sp)
    80000c34:	6125                	addi	sp,sp,96
    80000c36:	8082                	ret
        return -1;
    80000c38:	557d                	li	a0,-1
    80000c3a:	b7cd                	j	80000c1c <copyout+0x9a>
      return -1;
    80000c3c:	557d                	li	a0,-1
    80000c3e:	bff9                	j	80000c1c <copyout+0x9a>

0000000080000c40 <copyin>:
  while(len > 0){
    80000c40:	c6c9                	beqz	a3,80000cca <copyin+0x8a>
{
    80000c42:	715d                	addi	sp,sp,-80
    80000c44:	e486                	sd	ra,72(sp)
    80000c46:	e0a2                	sd	s0,64(sp)
    80000c48:	fc26                	sd	s1,56(sp)
    80000c4a:	f84a                	sd	s2,48(sp)
    80000c4c:	f44e                	sd	s3,40(sp)
    80000c4e:	f052                	sd	s4,32(sp)
    80000c50:	ec56                	sd	s5,24(sp)
    80000c52:	e85a                	sd	s6,16(sp)
    80000c54:	e45e                	sd	s7,8(sp)
    80000c56:	e062                	sd	s8,0(sp)
    80000c58:	0880                	addi	s0,sp,80
    80000c5a:	8baa                	mv	s7,a0
    80000c5c:	8aae                	mv	s5,a1
    80000c5e:	8932                	mv	s2,a2
    80000c60:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000c62:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000c64:	6b05                	lui	s6,0x1
    80000c66:	a035                	j	80000c92 <copyin+0x52>
    80000c68:	412984b3          	sub	s1,s3,s2
    80000c6c:	94da                	add	s1,s1,s6
    if(n > len)
    80000c6e:	009a7363          	bgeu	s4,s1,80000c74 <copyin+0x34>
    80000c72:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000c74:	413905b3          	sub	a1,s2,s3
    80000c78:	0004861b          	sext.w	a2,s1
    80000c7c:	95aa                	add	a1,a1,a0
    80000c7e:	8556                	mv	a0,s5
    80000c80:	dfeff0ef          	jal	8000027e <memmove>
    len -= n;
    80000c84:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000c88:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000c8a:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000c8e:	020a0163          	beqz	s4,80000cb0 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000c92:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000c96:	85ce                	mv	a1,s3
    80000c98:	855e                	mv	a0,s7
    80000c9a:	8bbff0ef          	jal	80000554 <walkaddr>
    if(pa0 == 0) {
    80000c9e:	f569                	bnez	a0,80000c68 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000ca0:	4601                	li	a2,0
    80000ca2:	85ce                	mv	a1,s3
    80000ca4:	855e                	mv	a0,s7
    80000ca6:	e59ff0ef          	jal	80000afe <vmfault>
    80000caa:	fd5d                	bnez	a0,80000c68 <copyin+0x28>
        return -1;
    80000cac:	557d                	li	a0,-1
    80000cae:	a011                	j	80000cb2 <copyin+0x72>
  return 0;
    80000cb0:	4501                	li	a0,0
}
    80000cb2:	60a6                	ld	ra,72(sp)
    80000cb4:	6406                	ld	s0,64(sp)
    80000cb6:	74e2                	ld	s1,56(sp)
    80000cb8:	7942                	ld	s2,48(sp)
    80000cba:	79a2                	ld	s3,40(sp)
    80000cbc:	7a02                	ld	s4,32(sp)
    80000cbe:	6ae2                	ld	s5,24(sp)
    80000cc0:	6b42                	ld	s6,16(sp)
    80000cc2:	6ba2                	ld	s7,8(sp)
    80000cc4:	6c02                	ld	s8,0(sp)
    80000cc6:	6161                	addi	sp,sp,80
    80000cc8:	8082                	ret
  return 0;
    80000cca:	4501                	li	a0,0
}
    80000ccc:	8082                	ret

0000000080000cce <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000cce:	715d                	addi	sp,sp,-80
    80000cd0:	e486                	sd	ra,72(sp)
    80000cd2:	e0a2                	sd	s0,64(sp)
    80000cd4:	fc26                	sd	s1,56(sp)
    80000cd6:	f84a                	sd	s2,48(sp)
    80000cd8:	f44e                	sd	s3,40(sp)
    80000cda:	f052                	sd	s4,32(sp)
    80000cdc:	ec56                	sd	s5,24(sp)
    80000cde:	e85a                	sd	s6,16(sp)
    80000ce0:	e45e                	sd	s7,8(sp)
    80000ce2:	e062                	sd	s8,0(sp)
    80000ce4:	0880                	addi	s0,sp,80
    80000ce6:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce8:	00008497          	auipc	s1,0x8
    80000cec:	55848493          	addi	s1,s1,1368 # 80009240 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000cf0:	8c26                	mv	s8,s1
    80000cf2:	677d47b7          	lui	a5,0x677d4
    80000cf6:	6cf78793          	addi	a5,a5,1743 # 677d46cf <_entry-0x1882b931>
    80000cfa:	51b3c937          	lui	s2,0x51b3c
    80000cfe:	ea390913          	addi	s2,s2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80000d02:	1902                	slli	s2,s2,0x20
    80000d04:	993e                	add	s2,s2,a5
    80000d06:	040009b7          	lui	s3,0x4000
    80000d0a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d0c:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d0e:	4b99                	li	s7,6
    80000d10:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d12:	0000ea97          	auipc	s5,0xe
    80000d16:	32ea8a93          	addi	s5,s5,814 # 8000f040 <tickslock>
    char *pa = kalloc();
    80000d1a:	c2eff0ef          	jal	80000148 <kalloc>
    80000d1e:	862a                	mv	a2,a0
    if(pa == 0)
    80000d20:	c121                	beqz	a0,80000d60 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000d22:	418485b3          	sub	a1,s1,s8
    80000d26:	858d                	srai	a1,a1,0x3
    80000d28:	032585b3          	mul	a1,a1,s2
    80000d2c:	05b6                	slli	a1,a1,0xd
    80000d2e:	6789                	lui	a5,0x2
    80000d30:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d32:	875e                	mv	a4,s7
    80000d34:	86da                	mv	a3,s6
    80000d36:	40b985b3          	sub	a1,s3,a1
    80000d3a:	8552                	mv	a0,s4
    80000d3c:	909ff0ef          	jal	80000644 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d40:	17848493          	addi	s1,s1,376
    80000d44:	fd549be3          	bne	s1,s5,80000d1a <proc_mapstacks+0x4c>
  }
}
    80000d48:	60a6                	ld	ra,72(sp)
    80000d4a:	6406                	ld	s0,64(sp)
    80000d4c:	74e2                	ld	s1,56(sp)
    80000d4e:	7942                	ld	s2,48(sp)
    80000d50:	79a2                	ld	s3,40(sp)
    80000d52:	7a02                	ld	s4,32(sp)
    80000d54:	6ae2                	ld	s5,24(sp)
    80000d56:	6b42                	ld	s6,16(sp)
    80000d58:	6ba2                	ld	s7,8(sp)
    80000d5a:	6c02                	ld	s8,0(sp)
    80000d5c:	6161                	addi	sp,sp,80
    80000d5e:	8082                	ret
      panic("kalloc");
    80000d60:	00007517          	auipc	a0,0x7
    80000d64:	39850513          	addi	a0,a0,920 # 800080f8 <etext+0xf8>
    80000d68:	583040ef          	jal	80005aea <panic>

0000000080000d6c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000d6c:	7139                	addi	sp,sp,-64
    80000d6e:	fc06                	sd	ra,56(sp)
    80000d70:	f822                	sd	s0,48(sp)
    80000d72:	f426                	sd	s1,40(sp)
    80000d74:	f04a                	sd	s2,32(sp)
    80000d76:	ec4e                	sd	s3,24(sp)
    80000d78:	e852                	sd	s4,16(sp)
    80000d7a:	e456                	sd	s5,8(sp)
    80000d7c:	e05a                	sd	s6,0(sp)
    80000d7e:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d80:	00007597          	auipc	a1,0x7
    80000d84:	38058593          	addi	a1,a1,896 # 80008100 <etext+0x100>
    80000d88:	00008517          	auipc	a0,0x8
    80000d8c:	07850513          	addi	a0,a0,120 # 80008e00 <pid_lock>
    80000d90:	206050ef          	jal	80005f96 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d94:	00007597          	auipc	a1,0x7
    80000d98:	37458593          	addi	a1,a1,884 # 80008108 <etext+0x108>
    80000d9c:	00008517          	auipc	a0,0x8
    80000da0:	08450513          	addi	a0,a0,132 # 80008e20 <wait_lock>
    80000da4:	1f2050ef          	jal	80005f96 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000da8:	00008497          	auipc	s1,0x8
    80000dac:	49848493          	addi	s1,s1,1176 # 80009240 <proc>
      initlock(&p->lock, "proc");
    80000db0:	00007b17          	auipc	s6,0x7
    80000db4:	368b0b13          	addi	s6,s6,872 # 80008118 <etext+0x118>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000db8:	8aa6                	mv	s5,s1
    80000dba:	677d47b7          	lui	a5,0x677d4
    80000dbe:	6cf78793          	addi	a5,a5,1743 # 677d46cf <_entry-0x1882b931>
    80000dc2:	51b3c937          	lui	s2,0x51b3c
    80000dc6:	ea390913          	addi	s2,s2,-349 # 51b3bea3 <_entry-0x2e4c415d>
    80000dca:	1902                	slli	s2,s2,0x20
    80000dcc:	993e                	add	s2,s2,a5
    80000dce:	040009b7          	lui	s3,0x4000
    80000dd2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000dd4:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000dd6:	0000ea17          	auipc	s4,0xe
    80000dda:	26aa0a13          	addi	s4,s4,618 # 8000f040 <tickslock>
      initlock(&p->lock, "proc");
    80000dde:	85da                	mv	a1,s6
    80000de0:	8526                	mv	a0,s1
    80000de2:	1b4050ef          	jal	80005f96 <initlock>
      p->state = UNUSED;
    80000de6:	0204a023          	sw	zero,32(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000dea:	415487b3          	sub	a5,s1,s5
    80000dee:	878d                	srai	a5,a5,0x3
    80000df0:	032787b3          	mul	a5,a5,s2
    80000df4:	07b6                	slli	a5,a5,0xd
    80000df6:	6709                	lui	a4,0x2
    80000df8:	9fb9                	addw	a5,a5,a4
    80000dfa:	40f987b3          	sub	a5,s3,a5
    80000dfe:	e4bc                	sd	a5,72(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000e00:	17848493          	addi	s1,s1,376
    80000e04:	fd449de3          	bne	s1,s4,80000dde <procinit+0x72>
  }
}
    80000e08:	70e2                	ld	ra,56(sp)
    80000e0a:	7442                	ld	s0,48(sp)
    80000e0c:	74a2                	ld	s1,40(sp)
    80000e0e:	7902                	ld	s2,32(sp)
    80000e10:	69e2                	ld	s3,24(sp)
    80000e12:	6a42                	ld	s4,16(sp)
    80000e14:	6aa2                	ld	s5,8(sp)
    80000e16:	6b02                	ld	s6,0(sp)
    80000e18:	6121                	addi	sp,sp,64
    80000e1a:	8082                	ret

0000000080000e1c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000e1c:	1141                	addi	sp,sp,-16
    80000e1e:	e406                	sd	ra,8(sp)
    80000e20:	e022                	sd	s0,0(sp)
    80000e22:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e24:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000e26:	2501                	sext.w	a0,a0
    80000e28:	60a2                	ld	ra,8(sp)
    80000e2a:	6402                	ld	s0,0(sp)
    80000e2c:	0141                	addi	sp,sp,16
    80000e2e:	8082                	ret

0000000080000e30 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000e30:	1141                	addi	sp,sp,-16
    80000e32:	e406                	sd	ra,8(sp)
    80000e34:	e022                	sd	s0,0(sp)
    80000e36:	0800                	addi	s0,sp,16
    80000e38:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000e3a:	2781                	sext.w	a5,a5
    80000e3c:	079e                	slli	a5,a5,0x7
  return c;
}
    80000e3e:	00008517          	auipc	a0,0x8
    80000e42:	00250513          	addi	a0,a0,2 # 80008e40 <cpus>
    80000e46:	953e                	add	a0,a0,a5
    80000e48:	60a2                	ld	ra,8(sp)
    80000e4a:	6402                	ld	s0,0(sp)
    80000e4c:	0141                	addi	sp,sp,16
    80000e4e:	8082                	ret

0000000080000e50 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e50:	1101                	addi	sp,sp,-32
    80000e52:	ec06                	sd	ra,24(sp)
    80000e54:	e822                	sd	s0,16(sp)
    80000e56:	e426                	sd	s1,8(sp)
    80000e58:	1000                	addi	s0,sp,32
  push_off();
    80000e5a:	779040ef          	jal	80005dd2 <push_off>
    80000e5e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e60:	2781                	sext.w	a5,a5
    80000e62:	079e                	slli	a5,a5,0x7
    80000e64:	00008717          	auipc	a4,0x8
    80000e68:	f9c70713          	addi	a4,a4,-100 # 80008e00 <pid_lock>
    80000e6c:	97ba                	add	a5,a5,a4
    80000e6e:	63bc                	ld	a5,64(a5)
    80000e70:	84be                	mv	s1,a5
  pop_off();
    80000e72:	03c050ef          	jal	80005eae <pop_off>
  return p;
}
    80000e76:	8526                	mv	a0,s1
    80000e78:	60e2                	ld	ra,24(sp)
    80000e7a:	6442                	ld	s0,16(sp)
    80000e7c:	64a2                	ld	s1,8(sp)
    80000e7e:	6105                	addi	sp,sp,32
    80000e80:	8082                	ret

0000000080000e82 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e82:	7179                	addi	sp,sp,-48
    80000e84:	f406                	sd	ra,40(sp)
    80000e86:	f022                	sd	s0,32(sp)
    80000e88:	ec26                	sd	s1,24(sp)
    80000e8a:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000e8c:	fc5ff0ef          	jal	80000e50 <myproc>
    80000e90:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000e92:	06c050ef          	jal	80005efe <release>

  if (first) {
    80000e96:	00008797          	auipc	a5,0x8
    80000e9a:	dda7a783          	lw	a5,-550(a5) # 80008c70 <first.1>
    80000e9e:	cf95                	beqz	a5,80000eda <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000ea0:	4505                	li	a0,1
    80000ea2:	3f7010ef          	jal	80002a98 <fsinit>

    first = 0;
    80000ea6:	00008797          	auipc	a5,0x8
    80000eaa:	dc07a523          	sw	zero,-566(a5) # 80008c70 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000eae:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000eb2:	00007797          	auipc	a5,0x7
    80000eb6:	26e78793          	addi	a5,a5,622 # 80008120 <etext+0x120>
    80000eba:	fcf43823          	sd	a5,-48(s0)
    80000ebe:	fc043c23          	sd	zero,-40(s0)
    80000ec2:	fd040593          	addi	a1,s0,-48
    80000ec6:	853e                	mv	a0,a5
    80000ec8:	555020ef          	jal	80003c1c <kexec>
    80000ecc:	70bc                	ld	a5,96(s1)
    80000ece:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000ed0:	70bc                	ld	a5,96(s1)
    80000ed2:	7bb8                	ld	a4,112(a5)
    80000ed4:	57fd                	li	a5,-1
    80000ed6:	02f70d63          	beq	a4,a5,80000f10 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000eda:	2dd000ef          	jal	800019b6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000ede:	6ca8                	ld	a0,88(s1)
    80000ee0:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000ee2:	04000737          	lui	a4,0x4000
    80000ee6:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000ee8:	0732                	slli	a4,a4,0xc
    80000eea:	00006797          	auipc	a5,0x6
    80000eee:	1b278793          	addi	a5,a5,434 # 8000709c <userret>
    80000ef2:	00006697          	auipc	a3,0x6
    80000ef6:	10e68693          	addi	a3,a3,270 # 80007000 <_trampoline>
    80000efa:	8f95                	sub	a5,a5,a3
    80000efc:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000efe:	577d                	li	a4,-1
    80000f00:	177e                	slli	a4,a4,0x3f
    80000f02:	8d59                	or	a0,a0,a4
    80000f04:	9782                	jalr	a5
}
    80000f06:	70a2                	ld	ra,40(sp)
    80000f08:	7402                	ld	s0,32(sp)
    80000f0a:	64e2                	ld	s1,24(sp)
    80000f0c:	6145                	addi	sp,sp,48
    80000f0e:	8082                	ret
      panic("exec");
    80000f10:	00007517          	auipc	a0,0x7
    80000f14:	21850513          	addi	a0,a0,536 # 80008128 <etext+0x128>
    80000f18:	3d3040ef          	jal	80005aea <panic>

0000000080000f1c <allocpid>:
{
    80000f1c:	1101                	addi	sp,sp,-32
    80000f1e:	ec06                	sd	ra,24(sp)
    80000f20:	e822                	sd	s0,16(sp)
    80000f22:	e426                	sd	s1,8(sp)
    80000f24:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000f26:	00008517          	auipc	a0,0x8
    80000f2a:	eda50513          	addi	a0,a0,-294 # 80008e00 <pid_lock>
    80000f2e:	6e9040ef          	jal	80005e16 <acquire>
  pid = nextpid;
    80000f32:	00008797          	auipc	a5,0x8
    80000f36:	d4278793          	addi	a5,a5,-702 # 80008c74 <nextpid>
    80000f3a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000f3c:	0014871b          	addiw	a4,s1,1
    80000f40:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000f42:	00008517          	auipc	a0,0x8
    80000f46:	ebe50513          	addi	a0,a0,-322 # 80008e00 <pid_lock>
    80000f4a:	7b5040ef          	jal	80005efe <release>
}
    80000f4e:	8526                	mv	a0,s1
    80000f50:	60e2                	ld	ra,24(sp)
    80000f52:	6442                	ld	s0,16(sp)
    80000f54:	64a2                	ld	s1,8(sp)
    80000f56:	6105                	addi	sp,sp,32
    80000f58:	8082                	ret

0000000080000f5a <proc_pagetable>:
{
    80000f5a:	1101                	addi	sp,sp,-32
    80000f5c:	ec06                	sd	ra,24(sp)
    80000f5e:	e822                	sd	s0,16(sp)
    80000f60:	e426                	sd	s1,8(sp)
    80000f62:	e04a                	sd	s2,0(sp)
    80000f64:	1000                	addi	s0,sp,32
    80000f66:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f68:	fceff0ef          	jal	80000736 <uvmcreate>
    80000f6c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f6e:	cd05                	beqz	a0,80000fa6 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f70:	4729                	li	a4,10
    80000f72:	00006697          	auipc	a3,0x6
    80000f76:	08e68693          	addi	a3,a3,142 # 80007000 <_trampoline>
    80000f7a:	6605                	lui	a2,0x1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	e0aff0ef          	jal	8000058e <mappages>
    80000f88:	02054663          	bltz	a0,80000fb4 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f8c:	4719                	li	a4,6
    80000f8e:	06093683          	ld	a3,96(s2)
    80000f92:	6605                	lui	a2,0x1
    80000f94:	020005b7          	lui	a1,0x2000
    80000f98:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f9a:	05b6                	slli	a1,a1,0xd
    80000f9c:	8526                	mv	a0,s1
    80000f9e:	df0ff0ef          	jal	8000058e <mappages>
    80000fa2:	00054f63          	bltz	a0,80000fc0 <proc_pagetable+0x66>
}
    80000fa6:	8526                	mv	a0,s1
    80000fa8:	60e2                	ld	ra,24(sp)
    80000faa:	6442                	ld	s0,16(sp)
    80000fac:	64a2                	ld	s1,8(sp)
    80000fae:	6902                	ld	s2,0(sp)
    80000fb0:	6105                	addi	sp,sp,32
    80000fb2:	8082                	ret
    uvmfree(pagetable, 0);
    80000fb4:	4581                	li	a1,0
    80000fb6:	8526                	mv	a0,s1
    80000fb8:	979ff0ef          	jal	80000930 <uvmfree>
    return 0;
    80000fbc:	4481                	li	s1,0
    80000fbe:	b7e5                	j	80000fa6 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fc0:	4681                	li	a3,0
    80000fc2:	4605                	li	a2,1
    80000fc4:	040005b7          	lui	a1,0x4000
    80000fc8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fca:	05b2                	slli	a1,a1,0xc
    80000fcc:	8526                	mv	a0,s1
    80000fce:	f8eff0ef          	jal	8000075c <uvmunmap>
    uvmfree(pagetable, 0);
    80000fd2:	4581                	li	a1,0
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	95bff0ef          	jal	80000930 <uvmfree>
    return 0;
    80000fda:	4481                	li	s1,0
    80000fdc:	b7e9                	j	80000fa6 <proc_pagetable+0x4c>

0000000080000fde <proc_freepagetable>:
{
    80000fde:	1101                	addi	sp,sp,-32
    80000fe0:	ec06                	sd	ra,24(sp)
    80000fe2:	e822                	sd	s0,16(sp)
    80000fe4:	e426                	sd	s1,8(sp)
    80000fe6:	e04a                	sd	s2,0(sp)
    80000fe8:	1000                	addi	s0,sp,32
    80000fea:	84aa                	mv	s1,a0
    80000fec:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fee:	4681                	li	a3,0
    80000ff0:	4605                	li	a2,1
    80000ff2:	040005b7          	lui	a1,0x4000
    80000ff6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ff8:	05b2                	slli	a1,a1,0xc
    80000ffa:	f62ff0ef          	jal	8000075c <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000ffe:	4681                	li	a3,0
    80001000:	4605                	li	a2,1
    80001002:	020005b7          	lui	a1,0x2000
    80001006:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001008:	05b6                	slli	a1,a1,0xd
    8000100a:	8526                	mv	a0,s1
    8000100c:	f50ff0ef          	jal	8000075c <uvmunmap>
  uvmfree(pagetable, sz);
    80001010:	85ca                	mv	a1,s2
    80001012:	8526                	mv	a0,s1
    80001014:	91dff0ef          	jal	80000930 <uvmfree>
}
    80001018:	60e2                	ld	ra,24(sp)
    8000101a:	6442                	ld	s0,16(sp)
    8000101c:	64a2                	ld	s1,8(sp)
    8000101e:	6902                	ld	s2,0(sp)
    80001020:	6105                	addi	sp,sp,32
    80001022:	8082                	ret

0000000080001024 <freeproc>:
{
    80001024:	1101                	addi	sp,sp,-32
    80001026:	ec06                	sd	ra,24(sp)
    80001028:	e822                	sd	s0,16(sp)
    8000102a:	e426                	sd	s1,8(sp)
    8000102c:	1000                	addi	s0,sp,32
    8000102e:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001030:	7128                	ld	a0,96(a0)
    80001032:	c119                	beqz	a0,80001038 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001034:	fe9fe0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80001038:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    8000103c:	6ca8                	ld	a0,88(s1)
    8000103e:	c501                	beqz	a0,80001046 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80001040:	68ac                	ld	a1,80(s1)
    80001042:	f9dff0ef          	jal	80000fde <proc_freepagetable>
  p->pagetable = 0;
    80001046:	0404bc23          	sd	zero,88(s1)
  p->sz = 0;
    8000104a:	0404b823          	sd	zero,80(s1)
  p->pid = 0;
    8000104e:	0204ac23          	sw	zero,56(s1)
  p->parent = 0;
    80001052:	0404b023          	sd	zero,64(s1)
  p->name[0] = 0;
    80001056:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    8000105a:	0204b423          	sd	zero,40(s1)
  p->killed = 0;
    8000105e:	0204a823          	sw	zero,48(s1)
  p->xstate = 0;
    80001062:	0204aa23          	sw	zero,52(s1)
  p->state = UNUSED;
    80001066:	0204a023          	sw	zero,32(s1)
}
    8000106a:	60e2                	ld	ra,24(sp)
    8000106c:	6442                	ld	s0,16(sp)
    8000106e:	64a2                	ld	s1,8(sp)
    80001070:	6105                	addi	sp,sp,32
    80001072:	8082                	ret

0000000080001074 <allocproc>:
{
    80001074:	1101                	addi	sp,sp,-32
    80001076:	ec06                	sd	ra,24(sp)
    80001078:	e822                	sd	s0,16(sp)
    8000107a:	e426                	sd	s1,8(sp)
    8000107c:	e04a                	sd	s2,0(sp)
    8000107e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001080:	00008497          	auipc	s1,0x8
    80001084:	1c048493          	addi	s1,s1,448 # 80009240 <proc>
    80001088:	0000e917          	auipc	s2,0xe
    8000108c:	fb890913          	addi	s2,s2,-72 # 8000f040 <tickslock>
    acquire(&p->lock);
    80001090:	8526                	mv	a0,s1
    80001092:	585040ef          	jal	80005e16 <acquire>
    if(p->state == UNUSED) {
    80001096:	509c                	lw	a5,32(s1)
    80001098:	cb91                	beqz	a5,800010ac <allocproc+0x38>
      release(&p->lock);
    8000109a:	8526                	mv	a0,s1
    8000109c:	663040ef          	jal	80005efe <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a0:	17848493          	addi	s1,s1,376
    800010a4:	ff2496e3          	bne	s1,s2,80001090 <allocproc+0x1c>
  return 0;
    800010a8:	4481                	li	s1,0
    800010aa:	a099                	j	800010f0 <allocproc+0x7c>
  p->pid = allocpid();
    800010ac:	e71ff0ef          	jal	80000f1c <allocpid>
    800010b0:	dc88                	sw	a0,56(s1)
  p->state = USED;
    800010b2:	4785                	li	a5,1
    800010b4:	d09c                	sw	a5,32(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800010b6:	892ff0ef          	jal	80000148 <kalloc>
    800010ba:	892a                	mv	s2,a0
    800010bc:	f0a8                	sd	a0,96(s1)
    800010be:	c121                	beqz	a0,800010fe <allocproc+0x8a>
  p->pincpu = 0;
    800010c0:	1604b823          	sd	zero,368(s1)
  p->pagetable = proc_pagetable(p);
    800010c4:	8526                	mv	a0,s1
    800010c6:	e95ff0ef          	jal	80000f5a <proc_pagetable>
    800010ca:	892a                	mv	s2,a0
    800010cc:	eca8                	sd	a0,88(s1)
  if(p->pagetable == 0){
    800010ce:	c121                	beqz	a0,8000110e <allocproc+0x9a>
  memset(&p->context, 0, sizeof(p->context));
    800010d0:	07000613          	li	a2,112
    800010d4:	4581                	li	a1,0
    800010d6:	06848513          	addi	a0,s1,104
    800010da:	944ff0ef          	jal	8000021e <memset>
  p->context.ra = (uint64)forkret;
    800010de:	00000797          	auipc	a5,0x0
    800010e2:	da478793          	addi	a5,a5,-604 # 80000e82 <forkret>
    800010e6:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010e8:	64bc                	ld	a5,72(s1)
    800010ea:	6705                	lui	a4,0x1
    800010ec:	97ba                	add	a5,a5,a4
    800010ee:	f8bc                	sd	a5,112(s1)
}
    800010f0:	8526                	mv	a0,s1
    800010f2:	60e2                	ld	ra,24(sp)
    800010f4:	6442                	ld	s0,16(sp)
    800010f6:	64a2                	ld	s1,8(sp)
    800010f8:	6902                	ld	s2,0(sp)
    800010fa:	6105                	addi	sp,sp,32
    800010fc:	8082                	ret
    freeproc(p);
    800010fe:	8526                	mv	a0,s1
    80001100:	f25ff0ef          	jal	80001024 <freeproc>
    release(&p->lock);
    80001104:	8526                	mv	a0,s1
    80001106:	5f9040ef          	jal	80005efe <release>
    return 0;
    8000110a:	84ca                	mv	s1,s2
    8000110c:	b7d5                	j	800010f0 <allocproc+0x7c>
    freeproc(p);
    8000110e:	8526                	mv	a0,s1
    80001110:	f15ff0ef          	jal	80001024 <freeproc>
    release(&p->lock);
    80001114:	8526                	mv	a0,s1
    80001116:	5e9040ef          	jal	80005efe <release>
    return 0;
    8000111a:	84ca                	mv	s1,s2
    8000111c:	bfd1                	j	800010f0 <allocproc+0x7c>

000000008000111e <userinit>:
{
    8000111e:	1101                	addi	sp,sp,-32
    80001120:	ec06                	sd	ra,24(sp)
    80001122:	e822                	sd	s0,16(sp)
    80001124:	e426                	sd	s1,8(sp)
    80001126:	1000                	addi	s0,sp,32
  p = allocproc();
    80001128:	f4dff0ef          	jal	80001074 <allocproc>
    8000112c:	84aa                	mv	s1,a0
  initproc = p;
    8000112e:	00008797          	auipc	a5,0x8
    80001132:	b6a7b123          	sd	a0,-1182(a5) # 80008c90 <initproc>
  p->cwd = namei("/");
    80001136:	00007517          	auipc	a0,0x7
    8000113a:	ffa50513          	addi	a0,a0,-6 # 80008130 <etext+0x130>
    8000113e:	695010ef          	jal	80002fd2 <namei>
    80001142:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    80001146:	478d                	li	a5,3
    80001148:	d09c                	sw	a5,32(s1)
  release(&p->lock);
    8000114a:	8526                	mv	a0,s1
    8000114c:	5b3040ef          	jal	80005efe <release>
}
    80001150:	60e2                	ld	ra,24(sp)
    80001152:	6442                	ld	s0,16(sp)
    80001154:	64a2                	ld	s1,8(sp)
    80001156:	6105                	addi	sp,sp,32
    80001158:	8082                	ret

000000008000115a <growproc>:
{
    8000115a:	1101                	addi	sp,sp,-32
    8000115c:	ec06                	sd	ra,24(sp)
    8000115e:	e822                	sd	s0,16(sp)
    80001160:	e426                	sd	s1,8(sp)
    80001162:	e04a                	sd	s2,0(sp)
    80001164:	1000                	addi	s0,sp,32
    80001166:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001168:	ce9ff0ef          	jal	80000e50 <myproc>
    8000116c:	84aa                	mv	s1,a0
  sz = p->sz;
    8000116e:	692c                	ld	a1,80(a0)
  if(n > 0){
    80001170:	01204c63          	bgtz	s2,80001188 <growproc+0x2e>
  } else if(n < 0){
    80001174:	02094463          	bltz	s2,8000119c <growproc+0x42>
  p->sz = sz;
    80001178:	e8ac                	sd	a1,80(s1)
  return 0;
    8000117a:	4501                	li	a0,0
}
    8000117c:	60e2                	ld	ra,24(sp)
    8000117e:	6442                	ld	s0,16(sp)
    80001180:	64a2                	ld	s1,8(sp)
    80001182:	6902                	ld	s2,0(sp)
    80001184:	6105                	addi	sp,sp,32
    80001186:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001188:	4691                	li	a3,4
    8000118a:	00b90633          	add	a2,s2,a1
    8000118e:	6d28                	ld	a0,88(a0)
    80001190:	e9aff0ef          	jal	8000082a <uvmalloc>
    80001194:	85aa                	mv	a1,a0
    80001196:	f16d                	bnez	a0,80001178 <growproc+0x1e>
      return -1;
    80001198:	557d                	li	a0,-1
    8000119a:	b7cd                	j	8000117c <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000119c:	00b90633          	add	a2,s2,a1
    800011a0:	6d28                	ld	a0,88(a0)
    800011a2:	e44ff0ef          	jal	800007e6 <uvmdealloc>
    800011a6:	85aa                	mv	a1,a0
    800011a8:	bfc1                	j	80001178 <growproc+0x1e>

00000000800011aa <kfork>:
{
    800011aa:	7139                	addi	sp,sp,-64
    800011ac:	fc06                	sd	ra,56(sp)
    800011ae:	f822                	sd	s0,48(sp)
    800011b0:	f426                	sd	s1,40(sp)
    800011b2:	e456                	sd	s5,8(sp)
    800011b4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800011b6:	c9bff0ef          	jal	80000e50 <myproc>
    800011ba:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800011bc:	eb9ff0ef          	jal	80001074 <allocproc>
    800011c0:	0e050a63          	beqz	a0,800012b4 <kfork+0x10a>
    800011c4:	e852                	sd	s4,16(sp)
    800011c6:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800011c8:	050ab603          	ld	a2,80(s5)
    800011cc:	6d2c                	ld	a1,88(a0)
    800011ce:	058ab503          	ld	a0,88(s5)
    800011d2:	f90ff0ef          	jal	80000962 <uvmcopy>
    800011d6:	04054863          	bltz	a0,80001226 <kfork+0x7c>
    800011da:	f04a                	sd	s2,32(sp)
    800011dc:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800011de:	050ab783          	ld	a5,80(s5)
    800011e2:	04fa3823          	sd	a5,80(s4)
  *(np->trapframe) = *(p->trapframe);
    800011e6:	060ab683          	ld	a3,96(s5)
    800011ea:	87b6                	mv	a5,a3
    800011ec:	060a3703          	ld	a4,96(s4)
    800011f0:	12068693          	addi	a3,a3,288
    800011f4:	6388                	ld	a0,0(a5)
    800011f6:	678c                	ld	a1,8(a5)
    800011f8:	6b90                	ld	a2,16(a5)
    800011fa:	e308                	sd	a0,0(a4)
    800011fc:	e70c                	sd	a1,8(a4)
    800011fe:	eb10                	sd	a2,16(a4)
    80001200:	6f90                	ld	a2,24(a5)
    80001202:	ef10                	sd	a2,24(a4)
    80001204:	02078793          	addi	a5,a5,32
    80001208:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    8000120c:	fed794e3          	bne	a5,a3,800011f4 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001210:	060a3783          	ld	a5,96(s4)
    80001214:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001218:	0d8a8493          	addi	s1,s5,216
    8000121c:	0d8a0913          	addi	s2,s4,216
    80001220:	158a8993          	addi	s3,s5,344
    80001224:	a831                	j	80001240 <kfork+0x96>
    freeproc(np);
    80001226:	8552                	mv	a0,s4
    80001228:	dfdff0ef          	jal	80001024 <freeproc>
    release(&np->lock);
    8000122c:	8552                	mv	a0,s4
    8000122e:	4d1040ef          	jal	80005efe <release>
    return -1;
    80001232:	54fd                	li	s1,-1
    80001234:	6a42                	ld	s4,16(sp)
    80001236:	a885                	j	800012a6 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001238:	04a1                	addi	s1,s1,8
    8000123a:	0921                	addi	s2,s2,8
    8000123c:	01348963          	beq	s1,s3,8000124e <kfork+0xa4>
    if(p->ofile[i])
    80001240:	6088                	ld	a0,0(s1)
    80001242:	d97d                	beqz	a0,80001238 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001244:	34a020ef          	jal	8000358e <filedup>
    80001248:	00a93023          	sd	a0,0(s2)
    8000124c:	b7f5                	j	80001238 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    8000124e:	158ab503          	ld	a0,344(s5)
    80001252:	510010ef          	jal	80002762 <idup>
    80001256:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000125a:	4641                	li	a2,16
    8000125c:	160a8593          	addi	a1,s5,352
    80001260:	160a0513          	addi	a0,s4,352
    80001264:	90eff0ef          	jal	80000372 <safestrcpy>
  pid = np->pid;
    80001268:	038a2483          	lw	s1,56(s4)
  release(&np->lock);
    8000126c:	8552                	mv	a0,s4
    8000126e:	491040ef          	jal	80005efe <release>
  acquire(&wait_lock);
    80001272:	00008517          	auipc	a0,0x8
    80001276:	bae50513          	addi	a0,a0,-1106 # 80008e20 <wait_lock>
    8000127a:	39d040ef          	jal	80005e16 <acquire>
  np->parent = p;
    8000127e:	055a3023          	sd	s5,64(s4)
  release(&wait_lock);
    80001282:	00008517          	auipc	a0,0x8
    80001286:	b9e50513          	addi	a0,a0,-1122 # 80008e20 <wait_lock>
    8000128a:	475040ef          	jal	80005efe <release>
  acquire(&np->lock);
    8000128e:	8552                	mv	a0,s4
    80001290:	387040ef          	jal	80005e16 <acquire>
  np->state = RUNNABLE;
    80001294:	478d                	li	a5,3
    80001296:	02fa2023          	sw	a5,32(s4)
  release(&np->lock);
    8000129a:	8552                	mv	a0,s4
    8000129c:	463040ef          	jal	80005efe <release>
  return pid;
    800012a0:	7902                	ld	s2,32(sp)
    800012a2:	69e2                	ld	s3,24(sp)
    800012a4:	6a42                	ld	s4,16(sp)
}
    800012a6:	8526                	mv	a0,s1
    800012a8:	70e2                	ld	ra,56(sp)
    800012aa:	7442                	ld	s0,48(sp)
    800012ac:	74a2                	ld	s1,40(sp)
    800012ae:	6aa2                	ld	s5,8(sp)
    800012b0:	6121                	addi	sp,sp,64
    800012b2:	8082                	ret
    return -1;
    800012b4:	54fd                	li	s1,-1
    800012b6:	bfc5                	j	800012a6 <kfork+0xfc>

00000000800012b8 <scheduler>:
{
    800012b8:	715d                	addi	sp,sp,-80
    800012ba:	e486                	sd	ra,72(sp)
    800012bc:	e0a2                	sd	s0,64(sp)
    800012be:	fc26                	sd	s1,56(sp)
    800012c0:	f84a                	sd	s2,48(sp)
    800012c2:	f44e                	sd	s3,40(sp)
    800012c4:	f052                	sd	s4,32(sp)
    800012c6:	ec56                	sd	s5,24(sp)
    800012c8:	e85a                	sd	s6,16(sp)
    800012ca:	e45e                	sd	s7,8(sp)
    800012cc:	e062                	sd	s8,0(sp)
    800012ce:	0880                	addi	s0,sp,80
    800012d0:	8792                	mv	a5,tp
  int id = r_tp();
    800012d2:	2781                	sext.w	a5,a5
  struct cpu *c = &cpus[id];
    800012d4:	00779713          	slli	a4,a5,0x7
    800012d8:	00008b97          	auipc	s7,0x8
    800012dc:	b68b8b93          	addi	s7,s7,-1176 # 80008e40 <cpus>
    800012e0:	00eb8a33          	add	s4,s7,a4
  c->proc = 0;
    800012e4:	00008697          	auipc	a3,0x8
    800012e8:	b1c68693          	addi	a3,a3,-1252 # 80008e00 <pid_lock>
    800012ec:	96ba                	add	a3,a3,a4
    800012ee:	0406b023          	sd	zero,64(a3)
        swtch(&c->context, &p->context);
    800012f2:	0721                	addi	a4,a4,8
    800012f4:	9bba                	add	s7,s7,a4
      if(p->state == RUNNABLE) {
    800012f6:	4a8d                	li	s5,3
        p->state = RUNNING;
    800012f8:	4c11                	li	s8,4
        c->proc = p;
    800012fa:	8b36                	mv	s6,a3
    800012fc:	a085                	j	8000135c <scheduler+0xa4>
      if(p->state == RUNNABLE) {
    800012fe:	03578863          	beq	a5,s5,8000132e <scheduler+0x76>
      release(&p->lock);
    80001302:	8526                	mv	a0,s1
    80001304:	3fb040ef          	jal	80005efe <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001308:	17848493          	addi	s1,s1,376
    8000130c:	03348d63          	beq	s1,s3,80001346 <scheduler+0x8e>
      acquire(&p->lock);
    80001310:	8526                	mv	a0,s1
    80001312:	305040ef          	jal	80005e16 <acquire>
      if(p->state != UNUSED) {
    80001316:	509c                	lw	a5,32(s1)
    80001318:	c7bd                	beqz	a5,80001386 <scheduler+0xce>
        nproc++;
    8000131a:	2905                	addiw	s2,s2,1
      if(p->pincpu && p->pincpu != c) {
    8000131c:	1704b703          	ld	a4,368(s1)
    80001320:	df79                	beqz	a4,800012fe <scheduler+0x46>
    80001322:	fd470ee3          	beq	a4,s4,800012fe <scheduler+0x46>
        release(&p->lock);
    80001326:	8526                	mv	a0,s1
    80001328:	3d7040ef          	jal	80005efe <release>
        continue;
    8000132c:	bff1                	j	80001308 <scheduler+0x50>
        p->state = RUNNING;
    8000132e:	0384a023          	sw	s8,32(s1)
        c->proc = p;
    80001332:	049b3023          	sd	s1,64(s6)
        swtch(&c->context, &p->context);
    80001336:	06848593          	addi	a1,s1,104
    8000133a:	855e                	mv	a0,s7
    8000133c:	5d0000ef          	jal	8000190c <swtch>
        c->proc = 0;
    80001340:	040b3023          	sd	zero,64(s6)
    80001344:	bf7d                	j	80001302 <scheduler+0x4a>
    if(nproc <= 2) {   // only init and sh exist
    80001346:	4789                	li	a5,2
    80001348:	0127ca63          	blt	a5,s2,8000135c <scheduler+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000134c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001350:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001354:	10079073          	csrw	sstatus,a5
      asm volatile("wfi");
    80001358:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000135c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001360:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001364:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001368:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000136c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000136e:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    80001372:	4901                	li	s2,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001374:	00008497          	auipc	s1,0x8
    80001378:	ecc48493          	addi	s1,s1,-308 # 80009240 <proc>
    8000137c:	0000e997          	auipc	s3,0xe
    80001380:	cc498993          	addi	s3,s3,-828 # 8000f040 <tickslock>
    80001384:	b771                	j	80001310 <scheduler+0x58>
      if(p->pincpu && p->pincpu != c) {
    80001386:	1704b783          	ld	a5,368(s1)
    8000138a:	f7478ce3          	beq	a5,s4,80001302 <scheduler+0x4a>
    8000138e:	dbb5                	beqz	a5,80001302 <scheduler+0x4a>
    80001390:	bf59                	j	80001326 <scheduler+0x6e>

0000000080001392 <sched>:
{
    80001392:	7179                	addi	sp,sp,-48
    80001394:	f406                	sd	ra,40(sp)
    80001396:	f022                	sd	s0,32(sp)
    80001398:	ec26                	sd	s1,24(sp)
    8000139a:	e84a                	sd	s2,16(sp)
    8000139c:	e44e                	sd	s3,8(sp)
    8000139e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800013a0:	ab1ff0ef          	jal	80000e50 <myproc>
    800013a4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800013a6:	201040ef          	jal	80005da6 <holding>
    800013aa:	c935                	beqz	a0,8000141e <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013ac:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800013ae:	2781                	sext.w	a5,a5
    800013b0:	079e                	slli	a5,a5,0x7
    800013b2:	00008717          	auipc	a4,0x8
    800013b6:	a4e70713          	addi	a4,a4,-1458 # 80008e00 <pid_lock>
    800013ba:	97ba                	add	a5,a5,a4
    800013bc:	0b87a703          	lw	a4,184(a5)
    800013c0:	4785                	li	a5,1
    800013c2:	06f71463          	bne	a4,a5,8000142a <sched+0x98>
  if(p->state == RUNNING)
    800013c6:	5098                	lw	a4,32(s1)
    800013c8:	4791                	li	a5,4
    800013ca:	06f70663          	beq	a4,a5,80001436 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013ce:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800013d2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800013d4:	e7bd                	bnez	a5,80001442 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013d6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800013d8:	00008917          	auipc	s2,0x8
    800013dc:	a2890913          	addi	s2,s2,-1496 # 80008e00 <pid_lock>
    800013e0:	2781                	sext.w	a5,a5
    800013e2:	079e                	slli	a5,a5,0x7
    800013e4:	97ca                	add	a5,a5,s2
    800013e6:	0bc7a983          	lw	s3,188(a5)
    800013ea:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800013ec:	2781                	sext.w	a5,a5
    800013ee:	079e                	slli	a5,a5,0x7
    800013f0:	07a1                	addi	a5,a5,8
    800013f2:	00008597          	auipc	a1,0x8
    800013f6:	a4e58593          	addi	a1,a1,-1458 # 80008e40 <cpus>
    800013fa:	95be                	add	a1,a1,a5
    800013fc:	06848513          	addi	a0,s1,104
    80001400:	50c000ef          	jal	8000190c <swtch>
    80001404:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001406:	2781                	sext.w	a5,a5
    80001408:	079e                	slli	a5,a5,0x7
    8000140a:	993e                	add	s2,s2,a5
    8000140c:	0b392e23          	sw	s3,188(s2)
}
    80001410:	70a2                	ld	ra,40(sp)
    80001412:	7402                	ld	s0,32(sp)
    80001414:	64e2                	ld	s1,24(sp)
    80001416:	6942                	ld	s2,16(sp)
    80001418:	69a2                	ld	s3,8(sp)
    8000141a:	6145                	addi	sp,sp,48
    8000141c:	8082                	ret
    panic("sched p->lock");
    8000141e:	00007517          	auipc	a0,0x7
    80001422:	d1a50513          	addi	a0,a0,-742 # 80008138 <etext+0x138>
    80001426:	6c4040ef          	jal	80005aea <panic>
    panic("sched locks");
    8000142a:	00007517          	auipc	a0,0x7
    8000142e:	d1e50513          	addi	a0,a0,-738 # 80008148 <etext+0x148>
    80001432:	6b8040ef          	jal	80005aea <panic>
    panic("sched RUNNING");
    80001436:	00007517          	auipc	a0,0x7
    8000143a:	d2250513          	addi	a0,a0,-734 # 80008158 <etext+0x158>
    8000143e:	6ac040ef          	jal	80005aea <panic>
    panic("sched interruptible");
    80001442:	00007517          	auipc	a0,0x7
    80001446:	d2650513          	addi	a0,a0,-730 # 80008168 <etext+0x168>
    8000144a:	6a0040ef          	jal	80005aea <panic>

000000008000144e <yield>:
{
    8000144e:	1101                	addi	sp,sp,-32
    80001450:	ec06                	sd	ra,24(sp)
    80001452:	e822                	sd	s0,16(sp)
    80001454:	e426                	sd	s1,8(sp)
    80001456:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001458:	9f9ff0ef          	jal	80000e50 <myproc>
    8000145c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000145e:	1b9040ef          	jal	80005e16 <acquire>
  p->state = RUNNABLE;
    80001462:	478d                	li	a5,3
    80001464:	d09c                	sw	a5,32(s1)
  sched();
    80001466:	f2dff0ef          	jal	80001392 <sched>
  release(&p->lock);
    8000146a:	8526                	mv	a0,s1
    8000146c:	293040ef          	jal	80005efe <release>
}
    80001470:	60e2                	ld	ra,24(sp)
    80001472:	6442                	ld	s0,16(sp)
    80001474:	64a2                	ld	s1,8(sp)
    80001476:	6105                	addi	sp,sp,32
    80001478:	8082                	ret

000000008000147a <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000147a:	7179                	addi	sp,sp,-48
    8000147c:	f406                	sd	ra,40(sp)
    8000147e:	f022                	sd	s0,32(sp)
    80001480:	ec26                	sd	s1,24(sp)
    80001482:	e84a                	sd	s2,16(sp)
    80001484:	e44e                	sd	s3,8(sp)
    80001486:	1800                	addi	s0,sp,48
    80001488:	89aa                	mv	s3,a0
    8000148a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000148c:	9c5ff0ef          	jal	80000e50 <myproc>
    80001490:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001492:	185040ef          	jal	80005e16 <acquire>
  release(lk);
    80001496:	854a                	mv	a0,s2
    80001498:	267040ef          	jal	80005efe <release>

  // Go to sleep.
  p->chan = chan;
    8000149c:	0334b423          	sd	s3,40(s1)
  p->state = SLEEPING;
    800014a0:	4789                	li	a5,2
    800014a2:	d09c                	sw	a5,32(s1)

  sched();
    800014a4:	eefff0ef          	jal	80001392 <sched>

  // Tidy up.
  p->chan = 0;
    800014a8:	0204b423          	sd	zero,40(s1)

  // Reacquire original lock.
  release(&p->lock);
    800014ac:	8526                	mv	a0,s1
    800014ae:	251040ef          	jal	80005efe <release>
  acquire(lk);
    800014b2:	854a                	mv	a0,s2
    800014b4:	163040ef          	jal	80005e16 <acquire>
}
    800014b8:	70a2                	ld	ra,40(sp)
    800014ba:	7402                	ld	s0,32(sp)
    800014bc:	64e2                	ld	s1,24(sp)
    800014be:	6942                	ld	s2,16(sp)
    800014c0:	69a2                	ld	s3,8(sp)
    800014c2:	6145                	addi	sp,sp,48
    800014c4:	8082                	ret

00000000800014c6 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800014c6:	7139                	addi	sp,sp,-64
    800014c8:	fc06                	sd	ra,56(sp)
    800014ca:	f822                	sd	s0,48(sp)
    800014cc:	f426                	sd	s1,40(sp)
    800014ce:	f04a                	sd	s2,32(sp)
    800014d0:	ec4e                	sd	s3,24(sp)
    800014d2:	e852                	sd	s4,16(sp)
    800014d4:	e456                	sd	s5,8(sp)
    800014d6:	0080                	addi	s0,sp,64
    800014d8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800014da:	00008497          	auipc	s1,0x8
    800014de:	d6648493          	addi	s1,s1,-666 # 80009240 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800014e2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800014e4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800014e6:	0000e917          	auipc	s2,0xe
    800014ea:	b5a90913          	addi	s2,s2,-1190 # 8000f040 <tickslock>
    800014ee:	a801                	j	800014fe <wakeup+0x38>
      }
      release(&p->lock);
    800014f0:	8526                	mv	a0,s1
    800014f2:	20d040ef          	jal	80005efe <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800014f6:	17848493          	addi	s1,s1,376
    800014fa:	03248263          	beq	s1,s2,8000151e <wakeup+0x58>
    if(p != myproc()){
    800014fe:	953ff0ef          	jal	80000e50 <myproc>
    80001502:	fe950ae3          	beq	a0,s1,800014f6 <wakeup+0x30>
      acquire(&p->lock);
    80001506:	8526                	mv	a0,s1
    80001508:	10f040ef          	jal	80005e16 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000150c:	509c                	lw	a5,32(s1)
    8000150e:	ff3791e3          	bne	a5,s3,800014f0 <wakeup+0x2a>
    80001512:	749c                	ld	a5,40(s1)
    80001514:	fd479ee3          	bne	a5,s4,800014f0 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001518:	0354a023          	sw	s5,32(s1)
    8000151c:	bfd1                	j	800014f0 <wakeup+0x2a>
    }
  }
}
    8000151e:	70e2                	ld	ra,56(sp)
    80001520:	7442                	ld	s0,48(sp)
    80001522:	74a2                	ld	s1,40(sp)
    80001524:	7902                	ld	s2,32(sp)
    80001526:	69e2                	ld	s3,24(sp)
    80001528:	6a42                	ld	s4,16(sp)
    8000152a:	6aa2                	ld	s5,8(sp)
    8000152c:	6121                	addi	sp,sp,64
    8000152e:	8082                	ret

0000000080001530 <reparent>:
{
    80001530:	7179                	addi	sp,sp,-48
    80001532:	f406                	sd	ra,40(sp)
    80001534:	f022                	sd	s0,32(sp)
    80001536:	ec26                	sd	s1,24(sp)
    80001538:	e84a                	sd	s2,16(sp)
    8000153a:	e44e                	sd	s3,8(sp)
    8000153c:	e052                	sd	s4,0(sp)
    8000153e:	1800                	addi	s0,sp,48
    80001540:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001542:	00008497          	auipc	s1,0x8
    80001546:	cfe48493          	addi	s1,s1,-770 # 80009240 <proc>
      pp->parent = initproc;
    8000154a:	00007a17          	auipc	s4,0x7
    8000154e:	746a0a13          	addi	s4,s4,1862 # 80008c90 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001552:	0000e997          	auipc	s3,0xe
    80001556:	aee98993          	addi	s3,s3,-1298 # 8000f040 <tickslock>
    8000155a:	a029                	j	80001564 <reparent+0x34>
    8000155c:	17848493          	addi	s1,s1,376
    80001560:	01348b63          	beq	s1,s3,80001576 <reparent+0x46>
    if(pp->parent == p){
    80001564:	60bc                	ld	a5,64(s1)
    80001566:	ff279be3          	bne	a5,s2,8000155c <reparent+0x2c>
      pp->parent = initproc;
    8000156a:	000a3503          	ld	a0,0(s4)
    8000156e:	e0a8                	sd	a0,64(s1)
      wakeup(initproc);
    80001570:	f57ff0ef          	jal	800014c6 <wakeup>
    80001574:	b7e5                	j	8000155c <reparent+0x2c>
}
    80001576:	70a2                	ld	ra,40(sp)
    80001578:	7402                	ld	s0,32(sp)
    8000157a:	64e2                	ld	s1,24(sp)
    8000157c:	6942                	ld	s2,16(sp)
    8000157e:	69a2                	ld	s3,8(sp)
    80001580:	6a02                	ld	s4,0(sp)
    80001582:	6145                	addi	sp,sp,48
    80001584:	8082                	ret

0000000080001586 <kexit>:
{
    80001586:	7179                	addi	sp,sp,-48
    80001588:	f406                	sd	ra,40(sp)
    8000158a:	f022                	sd	s0,32(sp)
    8000158c:	ec26                	sd	s1,24(sp)
    8000158e:	e84a                	sd	s2,16(sp)
    80001590:	e44e                	sd	s3,8(sp)
    80001592:	e052                	sd	s4,0(sp)
    80001594:	1800                	addi	s0,sp,48
    80001596:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001598:	8b9ff0ef          	jal	80000e50 <myproc>
    8000159c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000159e:	00007797          	auipc	a5,0x7
    800015a2:	6f27b783          	ld	a5,1778(a5) # 80008c90 <initproc>
    800015a6:	0d850493          	addi	s1,a0,216
    800015aa:	15850913          	addi	s2,a0,344
    800015ae:	00a79b63          	bne	a5,a0,800015c4 <kexit+0x3e>
    panic("init exiting");
    800015b2:	00007517          	auipc	a0,0x7
    800015b6:	bce50513          	addi	a0,a0,-1074 # 80008180 <etext+0x180>
    800015ba:	530040ef          	jal	80005aea <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800015be:	04a1                	addi	s1,s1,8
    800015c0:	01248963          	beq	s1,s2,800015d2 <kexit+0x4c>
    if(p->ofile[fd]){
    800015c4:	6088                	ld	a0,0(s1)
    800015c6:	dd65                	beqz	a0,800015be <kexit+0x38>
      fileclose(f);
    800015c8:	00c020ef          	jal	800035d4 <fileclose>
      p->ofile[fd] = 0;
    800015cc:	0004b023          	sd	zero,0(s1)
    800015d0:	b7fd                	j	800015be <kexit+0x38>
  begin_op();
    800015d2:	3df010ef          	jal	800031b0 <begin_op>
  iput(p->cwd);
    800015d6:	1589b503          	ld	a0,344(s3)
    800015da:	34c010ef          	jal	80002926 <iput>
  end_op();
    800015de:	443010ef          	jal	80003220 <end_op>
  p->cwd = 0;
    800015e2:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800015e6:	00008517          	auipc	a0,0x8
    800015ea:	83a50513          	addi	a0,a0,-1990 # 80008e20 <wait_lock>
    800015ee:	029040ef          	jal	80005e16 <acquire>
  reparent(p);
    800015f2:	854e                	mv	a0,s3
    800015f4:	f3dff0ef          	jal	80001530 <reparent>
  wakeup(p->parent);
    800015f8:	0409b503          	ld	a0,64(s3)
    800015fc:	ecbff0ef          	jal	800014c6 <wakeup>
  acquire(&p->lock);
    80001600:	854e                	mv	a0,s3
    80001602:	015040ef          	jal	80005e16 <acquire>
  p->xstate = status;
    80001606:	0349aa23          	sw	s4,52(s3)
  p->state = ZOMBIE;
    8000160a:	4795                	li	a5,5
    8000160c:	02f9a023          	sw	a5,32(s3)
  release(&wait_lock);
    80001610:	00008517          	auipc	a0,0x8
    80001614:	81050513          	addi	a0,a0,-2032 # 80008e20 <wait_lock>
    80001618:	0e7040ef          	jal	80005efe <release>
  sched();
    8000161c:	d77ff0ef          	jal	80001392 <sched>
  panic("zombie exit");
    80001620:	00007517          	auipc	a0,0x7
    80001624:	b7050513          	addi	a0,a0,-1168 # 80008190 <etext+0x190>
    80001628:	4c2040ef          	jal	80005aea <panic>

000000008000162c <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000162c:	7179                	addi	sp,sp,-48
    8000162e:	f406                	sd	ra,40(sp)
    80001630:	f022                	sd	s0,32(sp)
    80001632:	ec26                	sd	s1,24(sp)
    80001634:	e84a                	sd	s2,16(sp)
    80001636:	e44e                	sd	s3,8(sp)
    80001638:	1800                	addi	s0,sp,48
    8000163a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000163c:	00008497          	auipc	s1,0x8
    80001640:	c0448493          	addi	s1,s1,-1020 # 80009240 <proc>
    80001644:	0000e997          	auipc	s3,0xe
    80001648:	9fc98993          	addi	s3,s3,-1540 # 8000f040 <tickslock>
    acquire(&p->lock);
    8000164c:	8526                	mv	a0,s1
    8000164e:	7c8040ef          	jal	80005e16 <acquire>
    if(p->pid == pid){
    80001652:	5c9c                	lw	a5,56(s1)
    80001654:	01278b63          	beq	a5,s2,8000166a <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001658:	8526                	mv	a0,s1
    8000165a:	0a5040ef          	jal	80005efe <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000165e:	17848493          	addi	s1,s1,376
    80001662:	ff3495e3          	bne	s1,s3,8000164c <kkill+0x20>
  }
  return -1;
    80001666:	557d                	li	a0,-1
    80001668:	a819                	j	8000167e <kkill+0x52>
      p->killed = 1;
    8000166a:	4785                	li	a5,1
    8000166c:	d89c                	sw	a5,48(s1)
      if(p->state == SLEEPING){
    8000166e:	5098                	lw	a4,32(s1)
    80001670:	4789                	li	a5,2
    80001672:	00f70d63          	beq	a4,a5,8000168c <kkill+0x60>
      release(&p->lock);
    80001676:	8526                	mv	a0,s1
    80001678:	087040ef          	jal	80005efe <release>
      return 0;
    8000167c:	4501                	li	a0,0
}
    8000167e:	70a2                	ld	ra,40(sp)
    80001680:	7402                	ld	s0,32(sp)
    80001682:	64e2                	ld	s1,24(sp)
    80001684:	6942                	ld	s2,16(sp)
    80001686:	69a2                	ld	s3,8(sp)
    80001688:	6145                	addi	sp,sp,48
    8000168a:	8082                	ret
        p->state = RUNNABLE;
    8000168c:	478d                	li	a5,3
    8000168e:	d09c                	sw	a5,32(s1)
    80001690:	b7dd                	j	80001676 <kkill+0x4a>

0000000080001692 <setkilled>:

void
setkilled(struct proc *p)
{
    80001692:	1101                	addi	sp,sp,-32
    80001694:	ec06                	sd	ra,24(sp)
    80001696:	e822                	sd	s0,16(sp)
    80001698:	e426                	sd	s1,8(sp)
    8000169a:	1000                	addi	s0,sp,32
    8000169c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000169e:	778040ef          	jal	80005e16 <acquire>
  p->killed = 1;
    800016a2:	4785                	li	a5,1
    800016a4:	d89c                	sw	a5,48(s1)
  release(&p->lock);
    800016a6:	8526                	mv	a0,s1
    800016a8:	057040ef          	jal	80005efe <release>
}
    800016ac:	60e2                	ld	ra,24(sp)
    800016ae:	6442                	ld	s0,16(sp)
    800016b0:	64a2                	ld	s1,8(sp)
    800016b2:	6105                	addi	sp,sp,32
    800016b4:	8082                	ret

00000000800016b6 <killed>:

int
killed(struct proc *p)
{
    800016b6:	1101                	addi	sp,sp,-32
    800016b8:	ec06                	sd	ra,24(sp)
    800016ba:	e822                	sd	s0,16(sp)
    800016bc:	e426                	sd	s1,8(sp)
    800016be:	e04a                	sd	s2,0(sp)
    800016c0:	1000                	addi	s0,sp,32
    800016c2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800016c4:	752040ef          	jal	80005e16 <acquire>
  k = p->killed;
    800016c8:	589c                	lw	a5,48(s1)
    800016ca:	893e                	mv	s2,a5
  release(&p->lock);
    800016cc:	8526                	mv	a0,s1
    800016ce:	031040ef          	jal	80005efe <release>
  return k;
}
    800016d2:	854a                	mv	a0,s2
    800016d4:	60e2                	ld	ra,24(sp)
    800016d6:	6442                	ld	s0,16(sp)
    800016d8:	64a2                	ld	s1,8(sp)
    800016da:	6902                	ld	s2,0(sp)
    800016dc:	6105                	addi	sp,sp,32
    800016de:	8082                	ret

00000000800016e0 <kwait>:
{
    800016e0:	715d                	addi	sp,sp,-80
    800016e2:	e486                	sd	ra,72(sp)
    800016e4:	e0a2                	sd	s0,64(sp)
    800016e6:	fc26                	sd	s1,56(sp)
    800016e8:	f84a                	sd	s2,48(sp)
    800016ea:	f44e                	sd	s3,40(sp)
    800016ec:	f052                	sd	s4,32(sp)
    800016ee:	ec56                	sd	s5,24(sp)
    800016f0:	e85a                	sd	s6,16(sp)
    800016f2:	e45e                	sd	s7,8(sp)
    800016f4:	0880                	addi	s0,sp,80
    800016f6:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800016f8:	f58ff0ef          	jal	80000e50 <myproc>
    800016fc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016fe:	00007517          	auipc	a0,0x7
    80001702:	72250513          	addi	a0,a0,1826 # 80008e20 <wait_lock>
    80001706:	710040ef          	jal	80005e16 <acquire>
        if(pp->state == ZOMBIE){
    8000170a:	4a15                	li	s4,5
        havekids = 1;
    8000170c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000170e:	0000e997          	auipc	s3,0xe
    80001712:	93298993          	addi	s3,s3,-1742 # 8000f040 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001716:	00007b17          	auipc	s6,0x7
    8000171a:	70ab0b13          	addi	s6,s6,1802 # 80008e20 <wait_lock>
    8000171e:	a869                	j	800017b8 <kwait+0xd8>
          pid = pp->pid;
    80001720:	0384a983          	lw	s3,56(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001724:	000b8c63          	beqz	s7,8000173c <kwait+0x5c>
    80001728:	4691                	li	a3,4
    8000172a:	03448613          	addi	a2,s1,52
    8000172e:	85de                	mv	a1,s7
    80001730:	05893503          	ld	a0,88(s2)
    80001734:	c4eff0ef          	jal	80000b82 <copyout>
    80001738:	02054a63          	bltz	a0,8000176c <kwait+0x8c>
          freeproc(pp);
    8000173c:	8526                	mv	a0,s1
    8000173e:	8e7ff0ef          	jal	80001024 <freeproc>
          release(&pp->lock);
    80001742:	8526                	mv	a0,s1
    80001744:	7ba040ef          	jal	80005efe <release>
          release(&wait_lock);
    80001748:	00007517          	auipc	a0,0x7
    8000174c:	6d850513          	addi	a0,a0,1752 # 80008e20 <wait_lock>
    80001750:	7ae040ef          	jal	80005efe <release>
}
    80001754:	854e                	mv	a0,s3
    80001756:	60a6                	ld	ra,72(sp)
    80001758:	6406                	ld	s0,64(sp)
    8000175a:	74e2                	ld	s1,56(sp)
    8000175c:	7942                	ld	s2,48(sp)
    8000175e:	79a2                	ld	s3,40(sp)
    80001760:	7a02                	ld	s4,32(sp)
    80001762:	6ae2                	ld	s5,24(sp)
    80001764:	6b42                	ld	s6,16(sp)
    80001766:	6ba2                	ld	s7,8(sp)
    80001768:	6161                	addi	sp,sp,80
    8000176a:	8082                	ret
            release(&pp->lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	790040ef          	jal	80005efe <release>
            release(&wait_lock);
    80001772:	00007517          	auipc	a0,0x7
    80001776:	6ae50513          	addi	a0,a0,1710 # 80008e20 <wait_lock>
    8000177a:	784040ef          	jal	80005efe <release>
            return -1;
    8000177e:	59fd                	li	s3,-1
    80001780:	bfd1                	j	80001754 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001782:	17848493          	addi	s1,s1,376
    80001786:	03348063          	beq	s1,s3,800017a6 <kwait+0xc6>
      if(pp->parent == p){
    8000178a:	60bc                	ld	a5,64(s1)
    8000178c:	ff279be3          	bne	a5,s2,80001782 <kwait+0xa2>
        acquire(&pp->lock);
    80001790:	8526                	mv	a0,s1
    80001792:	684040ef          	jal	80005e16 <acquire>
        if(pp->state == ZOMBIE){
    80001796:	509c                	lw	a5,32(s1)
    80001798:	f94784e3          	beq	a5,s4,80001720 <kwait+0x40>
        release(&pp->lock);
    8000179c:	8526                	mv	a0,s1
    8000179e:	760040ef          	jal	80005efe <release>
        havekids = 1;
    800017a2:	8756                	mv	a4,s5
    800017a4:	bff9                	j	80001782 <kwait+0xa2>
    if(!havekids || killed(p)){
    800017a6:	cf19                	beqz	a4,800017c4 <kwait+0xe4>
    800017a8:	854a                	mv	a0,s2
    800017aa:	f0dff0ef          	jal	800016b6 <killed>
    800017ae:	e919                	bnez	a0,800017c4 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800017b0:	85da                	mv	a1,s6
    800017b2:	854a                	mv	a0,s2
    800017b4:	cc7ff0ef          	jal	8000147a <sleep>
    havekids = 0;
    800017b8:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800017ba:	00008497          	auipc	s1,0x8
    800017be:	a8648493          	addi	s1,s1,-1402 # 80009240 <proc>
    800017c2:	b7e1                	j	8000178a <kwait+0xaa>
      release(&wait_lock);
    800017c4:	00007517          	auipc	a0,0x7
    800017c8:	65c50513          	addi	a0,a0,1628 # 80008e20 <wait_lock>
    800017cc:	732040ef          	jal	80005efe <release>
      return -1;
    800017d0:	59fd                	li	s3,-1
    800017d2:	b749                	j	80001754 <kwait+0x74>

00000000800017d4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800017d4:	7179                	addi	sp,sp,-48
    800017d6:	f406                	sd	ra,40(sp)
    800017d8:	f022                	sd	s0,32(sp)
    800017da:	ec26                	sd	s1,24(sp)
    800017dc:	e84a                	sd	s2,16(sp)
    800017de:	e44e                	sd	s3,8(sp)
    800017e0:	e052                	sd	s4,0(sp)
    800017e2:	1800                	addi	s0,sp,48
    800017e4:	84aa                	mv	s1,a0
    800017e6:	8a2e                	mv	s4,a1
    800017e8:	89b2                	mv	s3,a2
    800017ea:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800017ec:	e64ff0ef          	jal	80000e50 <myproc>
  if(user_dst){
    800017f0:	cc99                	beqz	s1,8000180e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800017f2:	86ca                	mv	a3,s2
    800017f4:	864e                	mv	a2,s3
    800017f6:	85d2                	mv	a1,s4
    800017f8:	6d28                	ld	a0,88(a0)
    800017fa:	b88ff0ef          	jal	80000b82 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800017fe:	70a2                	ld	ra,40(sp)
    80001800:	7402                	ld	s0,32(sp)
    80001802:	64e2                	ld	s1,24(sp)
    80001804:	6942                	ld	s2,16(sp)
    80001806:	69a2                	ld	s3,8(sp)
    80001808:	6a02                	ld	s4,0(sp)
    8000180a:	6145                	addi	sp,sp,48
    8000180c:	8082                	ret
    memmove((char *)dst, src, len);
    8000180e:	0009061b          	sext.w	a2,s2
    80001812:	85ce                	mv	a1,s3
    80001814:	8552                	mv	a0,s4
    80001816:	a69fe0ef          	jal	8000027e <memmove>
    return 0;
    8000181a:	8526                	mv	a0,s1
    8000181c:	b7cd                	j	800017fe <either_copyout+0x2a>

000000008000181e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000181e:	7179                	addi	sp,sp,-48
    80001820:	f406                	sd	ra,40(sp)
    80001822:	f022                	sd	s0,32(sp)
    80001824:	ec26                	sd	s1,24(sp)
    80001826:	e84a                	sd	s2,16(sp)
    80001828:	e44e                	sd	s3,8(sp)
    8000182a:	e052                	sd	s4,0(sp)
    8000182c:	1800                	addi	s0,sp,48
    8000182e:	8a2a                	mv	s4,a0
    80001830:	84ae                	mv	s1,a1
    80001832:	89b2                	mv	s3,a2
    80001834:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001836:	e1aff0ef          	jal	80000e50 <myproc>
  if(user_src){
    8000183a:	cc99                	beqz	s1,80001858 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000183c:	86ca                	mv	a3,s2
    8000183e:	864e                	mv	a2,s3
    80001840:	85d2                	mv	a1,s4
    80001842:	6d28                	ld	a0,88(a0)
    80001844:	bfcff0ef          	jal	80000c40 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001848:	70a2                	ld	ra,40(sp)
    8000184a:	7402                	ld	s0,32(sp)
    8000184c:	64e2                	ld	s1,24(sp)
    8000184e:	6942                	ld	s2,16(sp)
    80001850:	69a2                	ld	s3,8(sp)
    80001852:	6a02                	ld	s4,0(sp)
    80001854:	6145                	addi	sp,sp,48
    80001856:	8082                	ret
    memmove(dst, (char*)src, len);
    80001858:	0009061b          	sext.w	a2,s2
    8000185c:	85ce                	mv	a1,s3
    8000185e:	8552                	mv	a0,s4
    80001860:	a1ffe0ef          	jal	8000027e <memmove>
    return 0;
    80001864:	8526                	mv	a0,s1
    80001866:	b7cd                	j	80001848 <either_copyin+0x2a>

0000000080001868 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001868:	715d                	addi	sp,sp,-80
    8000186a:	e486                	sd	ra,72(sp)
    8000186c:	e0a2                	sd	s0,64(sp)
    8000186e:	fc26                	sd	s1,56(sp)
    80001870:	f84a                	sd	s2,48(sp)
    80001872:	f44e                	sd	s3,40(sp)
    80001874:	f052                	sd	s4,32(sp)
    80001876:	ec56                	sd	s5,24(sp)
    80001878:	e85a                	sd	s6,16(sp)
    8000187a:	e45e                	sd	s7,8(sp)
    8000187c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000187e:	00006517          	auipc	a0,0x6
    80001882:	79a50513          	addi	a0,a0,1946 # 80008018 <etext+0x18>
    80001886:	73b030ef          	jal	800057c0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000188a:	00008497          	auipc	s1,0x8
    8000188e:	b1648493          	addi	s1,s1,-1258 # 800093a0 <proc+0x160>
    80001892:	0000e917          	auipc	s2,0xe
    80001896:	90e90913          	addi	s2,s2,-1778 # 8000f1a0 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000189a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000189c:	00007997          	auipc	s3,0x7
    800018a0:	90498993          	addi	s3,s3,-1788 # 800081a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    800018a4:	00007a97          	auipc	s5,0x7
    800018a8:	904a8a93          	addi	s5,s5,-1788 # 800081a8 <etext+0x1a8>
    printf("\n");
    800018ac:	00006a17          	auipc	s4,0x6
    800018b0:	76ca0a13          	addi	s4,s4,1900 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018b4:	00007b97          	auipc	s7,0x7
    800018b8:	21cb8b93          	addi	s7,s7,540 # 80008ad0 <states.0>
    800018bc:	a829                	j	800018d6 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800018be:	ed86a583          	lw	a1,-296(a3)
    800018c2:	8556                	mv	a0,s5
    800018c4:	6fd030ef          	jal	800057c0 <printf>
    printf("\n");
    800018c8:	8552                	mv	a0,s4
    800018ca:	6f7030ef          	jal	800057c0 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800018ce:	17848493          	addi	s1,s1,376
    800018d2:	03248263          	beq	s1,s2,800018f6 <procdump+0x8e>
    if(p->state == UNUSED)
    800018d6:	86a6                	mv	a3,s1
    800018d8:	ec04a783          	lw	a5,-320(s1)
    800018dc:	dbed                	beqz	a5,800018ce <procdump+0x66>
      state = "???";
    800018de:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018e0:	fcfb6fe3          	bltu	s6,a5,800018be <procdump+0x56>
    800018e4:	02079713          	slli	a4,a5,0x20
    800018e8:	01d75793          	srli	a5,a4,0x1d
    800018ec:	97de                	add	a5,a5,s7
    800018ee:	6390                	ld	a2,0(a5)
    800018f0:	f679                	bnez	a2,800018be <procdump+0x56>
      state = "???";
    800018f2:	864e                	mv	a2,s3
    800018f4:	b7e9                	j	800018be <procdump+0x56>
  }
}
    800018f6:	60a6                	ld	ra,72(sp)
    800018f8:	6406                	ld	s0,64(sp)
    800018fa:	74e2                	ld	s1,56(sp)
    800018fc:	7942                	ld	s2,48(sp)
    800018fe:	79a2                	ld	s3,40(sp)
    80001900:	7a02                	ld	s4,32(sp)
    80001902:	6ae2                	ld	s5,24(sp)
    80001904:	6b42                	ld	s6,16(sp)
    80001906:	6ba2                	ld	s7,8(sp)
    80001908:	6161                	addi	sp,sp,80
    8000190a:	8082                	ret

000000008000190c <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000190c:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001910:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001914:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001916:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001918:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000191c:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001920:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001924:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001928:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000192c:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001930:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001934:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001938:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000193c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001940:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001944:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001948:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000194a:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000194c:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001950:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001954:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001958:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000195c:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001960:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001964:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001968:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000196c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001970:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001974:	8082                	ret

0000000080001976 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001976:	1141                	addi	sp,sp,-16
    80001978:	e406                	sd	ra,8(sp)
    8000197a:	e022                	sd	s0,0(sp)
    8000197c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000197e:	00007597          	auipc	a1,0x7
    80001982:	86a58593          	addi	a1,a1,-1942 # 800081e8 <etext+0x1e8>
    80001986:	0000d517          	auipc	a0,0xd
    8000198a:	6ba50513          	addi	a0,a0,1722 # 8000f040 <tickslock>
    8000198e:	608040ef          	jal	80005f96 <initlock>
}
    80001992:	60a2                	ld	ra,8(sp)
    80001994:	6402                	ld	s0,0(sp)
    80001996:	0141                	addi	sp,sp,16
    80001998:	8082                	ret

000000008000199a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000199a:	1141                	addi	sp,sp,-16
    8000199c:	e406                	sd	ra,8(sp)
    8000199e:	e022                	sd	s0,0(sp)
    800019a0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019a2:	00003797          	auipc	a5,0x3
    800019a6:	fee78793          	addi	a5,a5,-18 # 80004990 <kernelvec>
    800019aa:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800019ae:	60a2                	ld	ra,8(sp)
    800019b0:	6402                	ld	s0,0(sp)
    800019b2:	0141                	addi	sp,sp,16
    800019b4:	8082                	ret

00000000800019b6 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800019b6:	1141                	addi	sp,sp,-16
    800019b8:	e406                	sd	ra,8(sp)
    800019ba:	e022                	sd	s0,0(sp)
    800019bc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800019be:	c92ff0ef          	jal	80000e50 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019c2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800019c6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019c8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800019cc:	04000737          	lui	a4,0x4000
    800019d0:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019d2:	0732                	slli	a4,a4,0xc
    800019d4:	00005797          	auipc	a5,0x5
    800019d8:	62c78793          	addi	a5,a5,1580 # 80007000 <_trampoline>
    800019dc:	00005697          	auipc	a3,0x5
    800019e0:	62468693          	addi	a3,a3,1572 # 80007000 <_trampoline>
    800019e4:	8f95                	sub	a5,a5,a3
    800019e6:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019e8:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800019ec:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800019ee:	18002773          	csrr	a4,satp
    800019f2:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800019f4:	7138                	ld	a4,96(a0)
    800019f6:	653c                	ld	a5,72(a0)
    800019f8:	6685                	lui	a3,0x1
    800019fa:	97b6                	add	a5,a5,a3
    800019fc:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800019fe:	713c                	ld	a5,96(a0)
    80001a00:	00000717          	auipc	a4,0x0
    80001a04:	0fc70713          	addi	a4,a4,252 # 80001afc <usertrap>
    80001a08:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001a0a:	713c                	ld	a5,96(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001a0c:	8712                	mv	a4,tp
    80001a0e:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a10:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001a14:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001a18:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001a1c:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001a20:	713c                	ld	a5,96(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001a22:	6f9c                	ld	a5,24(a5)
    80001a24:	14179073          	csrw	sepc,a5
}
    80001a28:	60a2                	ld	ra,8(sp)
    80001a2a:	6402                	ld	s0,0(sp)
    80001a2c:	0141                	addi	sp,sp,16
    80001a2e:	8082                	ret

0000000080001a30 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001a30:	1141                	addi	sp,sp,-16
    80001a32:	e406                	sd	ra,8(sp)
    80001a34:	e022                	sd	s0,0(sp)
    80001a36:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001a38:	be4ff0ef          	jal	80000e1c <cpuid>
    80001a3c:	cd11                	beqz	a0,80001a58 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001a3e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001a42:	000f4737          	lui	a4,0xf4
    80001a46:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001a4a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001a4c:	14d79073          	csrw	stimecmp,a5
}
    80001a50:	60a2                	ld	ra,8(sp)
    80001a52:	6402                	ld	s0,0(sp)
    80001a54:	0141                	addi	sp,sp,16
    80001a56:	8082                	ret
    acquire(&tickslock);
    80001a58:	0000d517          	auipc	a0,0xd
    80001a5c:	5e850513          	addi	a0,a0,1512 # 8000f040 <tickslock>
    80001a60:	3b6040ef          	jal	80005e16 <acquire>
    ticks++;
    80001a64:	00007717          	auipc	a4,0x7
    80001a68:	23470713          	addi	a4,a4,564 # 80008c98 <ticks>
    80001a6c:	431c                	lw	a5,0(a4)
    80001a6e:	2785                	addiw	a5,a5,1
    80001a70:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001a72:	853a                	mv	a0,a4
    80001a74:	a53ff0ef          	jal	800014c6 <wakeup>
    release(&tickslock);
    80001a78:	0000d517          	auipc	a0,0xd
    80001a7c:	5c850513          	addi	a0,a0,1480 # 8000f040 <tickslock>
    80001a80:	47e040ef          	jal	80005efe <release>
    80001a84:	bf6d                	j	80001a3e <clockintr+0xe>

0000000080001a86 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a86:	1101                	addi	sp,sp,-32
    80001a88:	ec06                	sd	ra,24(sp)
    80001a8a:	e822                	sd	s0,16(sp)
    80001a8c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a8e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001a92:	57fd                	li	a5,-1
    80001a94:	17fe                	slli	a5,a5,0x3f
    80001a96:	07a5                	addi	a5,a5,9
    80001a98:	00f70c63          	beq	a4,a5,80001ab0 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a9c:	57fd                	li	a5,-1
    80001a9e:	17fe                	slli	a5,a5,0x3f
    80001aa0:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001aa2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001aa4:	04f70863          	beq	a4,a5,80001af4 <devintr+0x6e>
  }
}
    80001aa8:	60e2                	ld	ra,24(sp)
    80001aaa:	6442                	ld	s0,16(sp)
    80001aac:	6105                	addi	sp,sp,32
    80001aae:	8082                	ret
    80001ab0:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001ab2:	78b020ef          	jal	80004a3c <plic_claim>
    80001ab6:	872a                	mv	a4,a0
    80001ab8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001aba:	47a9                	li	a5,10
    80001abc:	00f50963          	beq	a0,a5,80001ace <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80001ac0:	4785                	li	a5,1
    80001ac2:	00f50963          	beq	a0,a5,80001ad4 <devintr+0x4e>
    return 1;
    80001ac6:	4505                	li	a0,1
    } else if(irq){
    80001ac8:	eb09                	bnez	a4,80001ada <devintr+0x54>
    80001aca:	64a2                	ld	s1,8(sp)
    80001acc:	bff1                	j	80001aa8 <devintr+0x22>
      uartintr();
    80001ace:	1ec040ef          	jal	80005cba <uartintr>
    if(irq)
    80001ad2:	a819                	j	80001ae8 <devintr+0x62>
      virtio_disk_intr();
    80001ad4:	436030ef          	jal	80004f0a <virtio_disk_intr>
    if(irq)
    80001ad8:	a801                	j	80001ae8 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80001ada:	85ba                	mv	a1,a4
    80001adc:	00006517          	auipc	a0,0x6
    80001ae0:	71450513          	addi	a0,a0,1812 # 800081f0 <etext+0x1f0>
    80001ae4:	4dd030ef          	jal	800057c0 <printf>
      plic_complete(irq);
    80001ae8:	8526                	mv	a0,s1
    80001aea:	773020ef          	jal	80004a5c <plic_complete>
    return 1;
    80001aee:	4505                	li	a0,1
    80001af0:	64a2                	ld	s1,8(sp)
    80001af2:	bf5d                	j	80001aa8 <devintr+0x22>
    clockintr();
    80001af4:	f3dff0ef          	jal	80001a30 <clockintr>
    return 2;
    80001af8:	4509                	li	a0,2
    80001afa:	b77d                	j	80001aa8 <devintr+0x22>

0000000080001afc <usertrap>:
{
    80001afc:	1101                	addi	sp,sp,-32
    80001afe:	ec06                	sd	ra,24(sp)
    80001b00:	e822                	sd	s0,16(sp)
    80001b02:	e426                	sd	s1,8(sp)
    80001b04:	e04a                	sd	s2,0(sp)
    80001b06:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b08:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001b0c:	1007f793          	andi	a5,a5,256
    80001b10:	eba5                	bnez	a5,80001b80 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b12:	00003797          	auipc	a5,0x3
    80001b16:	e7e78793          	addi	a5,a5,-386 # 80004990 <kernelvec>
    80001b1a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001b1e:	b32ff0ef          	jal	80000e50 <myproc>
    80001b22:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001b24:	713c                	ld	a5,96(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b26:	14102773          	csrr	a4,sepc
    80001b2a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b2c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001b30:	47a1                	li	a5,8
    80001b32:	04f70d63          	beq	a4,a5,80001b8c <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001b36:	f51ff0ef          	jal	80001a86 <devintr>
    80001b3a:	892a                	mv	s2,a0
    80001b3c:	e945                	bnez	a0,80001bec <usertrap+0xf0>
    80001b3e:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b42:	47bd                	li	a5,15
    80001b44:	08f70863          	beq	a4,a5,80001bd4 <usertrap+0xd8>
    80001b48:	14202773          	csrr	a4,scause
    80001b4c:	47b5                	li	a5,13
    80001b4e:	08f70363          	beq	a4,a5,80001bd4 <usertrap+0xd8>
    80001b52:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b56:	5c90                	lw	a2,56(s1)
    80001b58:	00006517          	auipc	a0,0x6
    80001b5c:	6d850513          	addi	a0,a0,1752 # 80008230 <etext+0x230>
    80001b60:	461030ef          	jal	800057c0 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b64:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b68:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b6c:	00006517          	auipc	a0,0x6
    80001b70:	6f450513          	addi	a0,a0,1780 # 80008260 <etext+0x260>
    80001b74:	44d030ef          	jal	800057c0 <printf>
    setkilled(p);
    80001b78:	8526                	mv	a0,s1
    80001b7a:	b19ff0ef          	jal	80001692 <setkilled>
    80001b7e:	a035                	j	80001baa <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001b80:	00006517          	auipc	a0,0x6
    80001b84:	69050513          	addi	a0,a0,1680 # 80008210 <etext+0x210>
    80001b88:	763030ef          	jal	80005aea <panic>
    if(killed(p))
    80001b8c:	b2bff0ef          	jal	800016b6 <killed>
    80001b90:	ed15                	bnez	a0,80001bcc <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001b92:	70b8                	ld	a4,96(s1)
    80001b94:	6f1c                	ld	a5,24(a4)
    80001b96:	0791                	addi	a5,a5,4
    80001b98:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b9a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b9e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ba2:	10079073          	csrw	sstatus,a5
    syscall();
    80001ba6:	240000ef          	jal	80001de6 <syscall>
  if(killed(p))
    80001baa:	8526                	mv	a0,s1
    80001bac:	b0bff0ef          	jal	800016b6 <killed>
    80001bb0:	e139                	bnez	a0,80001bf6 <usertrap+0xfa>
  prepare_return();
    80001bb2:	e05ff0ef          	jal	800019b6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001bb6:	6ca8                	ld	a0,88(s1)
    80001bb8:	8131                	srli	a0,a0,0xc
    80001bba:	57fd                	li	a5,-1
    80001bbc:	17fe                	slli	a5,a5,0x3f
    80001bbe:	8d5d                	or	a0,a0,a5
}
    80001bc0:	60e2                	ld	ra,24(sp)
    80001bc2:	6442                	ld	s0,16(sp)
    80001bc4:	64a2                	ld	s1,8(sp)
    80001bc6:	6902                	ld	s2,0(sp)
    80001bc8:	6105                	addi	sp,sp,32
    80001bca:	8082                	ret
      kexit(-1);
    80001bcc:	557d                	li	a0,-1
    80001bce:	9b9ff0ef          	jal	80001586 <kexit>
    80001bd2:	b7c1                	j	80001b92 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001bd4:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bd8:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001bdc:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001bde:	00163613          	seqz	a2,a2
    80001be2:	6ca8                	ld	a0,88(s1)
    80001be4:	f1bfe0ef          	jal	80000afe <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001be8:	f169                	bnez	a0,80001baa <usertrap+0xae>
    80001bea:	b7a5                	j	80001b52 <usertrap+0x56>
  if(killed(p))
    80001bec:	8526                	mv	a0,s1
    80001bee:	ac9ff0ef          	jal	800016b6 <killed>
    80001bf2:	c511                	beqz	a0,80001bfe <usertrap+0x102>
    80001bf4:	a011                	j	80001bf8 <usertrap+0xfc>
    80001bf6:	4901                	li	s2,0
    kexit(-1);
    80001bf8:	557d                	li	a0,-1
    80001bfa:	98dff0ef          	jal	80001586 <kexit>
  if(which_dev == 2)
    80001bfe:	4789                	li	a5,2
    80001c00:	faf919e3          	bne	s2,a5,80001bb2 <usertrap+0xb6>
    yield();
    80001c04:	84bff0ef          	jal	8000144e <yield>
    80001c08:	b76d                	j	80001bb2 <usertrap+0xb6>

0000000080001c0a <kerneltrap>:
{
    80001c0a:	7179                	addi	sp,sp,-48
    80001c0c:	f406                	sd	ra,40(sp)
    80001c0e:	f022                	sd	s0,32(sp)
    80001c10:	ec26                	sd	s1,24(sp)
    80001c12:	e84a                	sd	s2,16(sp)
    80001c14:	e44e                	sd	s3,8(sp)
    80001c16:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c18:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c1c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c20:	142027f3          	csrr	a5,scause
    80001c24:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001c26:	1004f793          	andi	a5,s1,256
    80001c2a:	c795                	beqz	a5,80001c56 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001c2c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001c30:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001c32:	eb85                	bnez	a5,80001c62 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001c34:	e53ff0ef          	jal	80001a86 <devintr>
    80001c38:	c91d                	beqz	a0,80001c6e <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001c3a:	4789                	li	a5,2
    80001c3c:	04f50a63          	beq	a0,a5,80001c90 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c40:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c44:	10049073          	csrw	sstatus,s1
}
    80001c48:	70a2                	ld	ra,40(sp)
    80001c4a:	7402                	ld	s0,32(sp)
    80001c4c:	64e2                	ld	s1,24(sp)
    80001c4e:	6942                	ld	s2,16(sp)
    80001c50:	69a2                	ld	s3,8(sp)
    80001c52:	6145                	addi	sp,sp,48
    80001c54:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001c56:	00006517          	auipc	a0,0x6
    80001c5a:	63250513          	addi	a0,a0,1586 # 80008288 <etext+0x288>
    80001c5e:	68d030ef          	jal	80005aea <panic>
    panic("kerneltrap: interrupts enabled");
    80001c62:	00006517          	auipc	a0,0x6
    80001c66:	64e50513          	addi	a0,a0,1614 # 800082b0 <etext+0x2b0>
    80001c6a:	681030ef          	jal	80005aea <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c6e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c72:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001c76:	85ce                	mv	a1,s3
    80001c78:	00006517          	auipc	a0,0x6
    80001c7c:	65850513          	addi	a0,a0,1624 # 800082d0 <etext+0x2d0>
    80001c80:	341030ef          	jal	800057c0 <printf>
    panic("kerneltrap");
    80001c84:	00006517          	auipc	a0,0x6
    80001c88:	67450513          	addi	a0,a0,1652 # 800082f8 <etext+0x2f8>
    80001c8c:	65f030ef          	jal	80005aea <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c90:	9c0ff0ef          	jal	80000e50 <myproc>
    80001c94:	d555                	beqz	a0,80001c40 <kerneltrap+0x36>
    yield();
    80001c96:	fb8ff0ef          	jal	8000144e <yield>
    80001c9a:	b75d                	j	80001c40 <kerneltrap+0x36>

0000000080001c9c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001c9c:	1101                	addi	sp,sp,-32
    80001c9e:	ec06                	sd	ra,24(sp)
    80001ca0:	e822                	sd	s0,16(sp)
    80001ca2:	e426                	sd	s1,8(sp)
    80001ca4:	1000                	addi	s0,sp,32
    80001ca6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001ca8:	9a8ff0ef          	jal	80000e50 <myproc>
  switch (n) {
    80001cac:	4795                	li	a5,5
    80001cae:	0497e163          	bltu	a5,s1,80001cf0 <argraw+0x54>
    80001cb2:	048a                	slli	s1,s1,0x2
    80001cb4:	00007717          	auipc	a4,0x7
    80001cb8:	e4c70713          	addi	a4,a4,-436 # 80008b00 <states.0+0x30>
    80001cbc:	94ba                	add	s1,s1,a4
    80001cbe:	409c                	lw	a5,0(s1)
    80001cc0:	97ba                	add	a5,a5,a4
    80001cc2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001cc4:	713c                	ld	a5,96(a0)
    80001cc6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001cc8:	60e2                	ld	ra,24(sp)
    80001cca:	6442                	ld	s0,16(sp)
    80001ccc:	64a2                	ld	s1,8(sp)
    80001cce:	6105                	addi	sp,sp,32
    80001cd0:	8082                	ret
    return p->trapframe->a1;
    80001cd2:	713c                	ld	a5,96(a0)
    80001cd4:	7fa8                	ld	a0,120(a5)
    80001cd6:	bfcd                	j	80001cc8 <argraw+0x2c>
    return p->trapframe->a2;
    80001cd8:	713c                	ld	a5,96(a0)
    80001cda:	63c8                	ld	a0,128(a5)
    80001cdc:	b7f5                	j	80001cc8 <argraw+0x2c>
    return p->trapframe->a3;
    80001cde:	713c                	ld	a5,96(a0)
    80001ce0:	67c8                	ld	a0,136(a5)
    80001ce2:	b7dd                	j	80001cc8 <argraw+0x2c>
    return p->trapframe->a4;
    80001ce4:	713c                	ld	a5,96(a0)
    80001ce6:	6bc8                	ld	a0,144(a5)
    80001ce8:	b7c5                	j	80001cc8 <argraw+0x2c>
    return p->trapframe->a5;
    80001cea:	713c                	ld	a5,96(a0)
    80001cec:	6fc8                	ld	a0,152(a5)
    80001cee:	bfe9                	j	80001cc8 <argraw+0x2c>
  panic("argraw");
    80001cf0:	00006517          	auipc	a0,0x6
    80001cf4:	61850513          	addi	a0,a0,1560 # 80008308 <etext+0x308>
    80001cf8:	5f3030ef          	jal	80005aea <panic>

0000000080001cfc <fetchaddr>:
{
    80001cfc:	1101                	addi	sp,sp,-32
    80001cfe:	ec06                	sd	ra,24(sp)
    80001d00:	e822                	sd	s0,16(sp)
    80001d02:	e426                	sd	s1,8(sp)
    80001d04:	e04a                	sd	s2,0(sp)
    80001d06:	1000                	addi	s0,sp,32
    80001d08:	84aa                	mv	s1,a0
    80001d0a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001d0c:	944ff0ef          	jal	80000e50 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001d10:	693c                	ld	a5,80(a0)
    80001d12:	02f4f663          	bgeu	s1,a5,80001d3e <fetchaddr+0x42>
    80001d16:	00848713          	addi	a4,s1,8
    80001d1a:	02e7e463          	bltu	a5,a4,80001d42 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001d1e:	46a1                	li	a3,8
    80001d20:	8626                	mv	a2,s1
    80001d22:	85ca                	mv	a1,s2
    80001d24:	6d28                	ld	a0,88(a0)
    80001d26:	f1bfe0ef          	jal	80000c40 <copyin>
    80001d2a:	00a03533          	snez	a0,a0
    80001d2e:	40a0053b          	negw	a0,a0
}
    80001d32:	60e2                	ld	ra,24(sp)
    80001d34:	6442                	ld	s0,16(sp)
    80001d36:	64a2                	ld	s1,8(sp)
    80001d38:	6902                	ld	s2,0(sp)
    80001d3a:	6105                	addi	sp,sp,32
    80001d3c:	8082                	ret
    return -1;
    80001d3e:	557d                	li	a0,-1
    80001d40:	bfcd                	j	80001d32 <fetchaddr+0x36>
    80001d42:	557d                	li	a0,-1
    80001d44:	b7fd                	j	80001d32 <fetchaddr+0x36>

0000000080001d46 <fetchstr>:
{
    80001d46:	7179                	addi	sp,sp,-48
    80001d48:	f406                	sd	ra,40(sp)
    80001d4a:	f022                	sd	s0,32(sp)
    80001d4c:	ec26                	sd	s1,24(sp)
    80001d4e:	e84a                	sd	s2,16(sp)
    80001d50:	e44e                	sd	s3,8(sp)
    80001d52:	1800                	addi	s0,sp,48
    80001d54:	89aa                	mv	s3,a0
    80001d56:	84ae                	mv	s1,a1
    80001d58:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001d5a:	8f6ff0ef          	jal	80000e50 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001d5e:	86ca                	mv	a3,s2
    80001d60:	864e                	mv	a2,s3
    80001d62:	85a6                	mv	a1,s1
    80001d64:	6d28                	ld	a0,88(a0)
    80001d66:	cc1fe0ef          	jal	80000a26 <copyinstr>
    80001d6a:	00054c63          	bltz	a0,80001d82 <fetchstr+0x3c>
  return strlen(buf);
    80001d6e:	8526                	mv	a0,s1
    80001d70:	e38fe0ef          	jal	800003a8 <strlen>
}
    80001d74:	70a2                	ld	ra,40(sp)
    80001d76:	7402                	ld	s0,32(sp)
    80001d78:	64e2                	ld	s1,24(sp)
    80001d7a:	6942                	ld	s2,16(sp)
    80001d7c:	69a2                	ld	s3,8(sp)
    80001d7e:	6145                	addi	sp,sp,48
    80001d80:	8082                	ret
    return -1;
    80001d82:	557d                	li	a0,-1
    80001d84:	bfc5                	j	80001d74 <fetchstr+0x2e>

0000000080001d86 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001d86:	1101                	addi	sp,sp,-32
    80001d88:	ec06                	sd	ra,24(sp)
    80001d8a:	e822                	sd	s0,16(sp)
    80001d8c:	e426                	sd	s1,8(sp)
    80001d8e:	1000                	addi	s0,sp,32
    80001d90:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d92:	f0bff0ef          	jal	80001c9c <argraw>
    80001d96:	c088                	sw	a0,0(s1)
}
    80001d98:	60e2                	ld	ra,24(sp)
    80001d9a:	6442                	ld	s0,16(sp)
    80001d9c:	64a2                	ld	s1,8(sp)
    80001d9e:	6105                	addi	sp,sp,32
    80001da0:	8082                	ret

0000000080001da2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001da2:	1101                	addi	sp,sp,-32
    80001da4:	ec06                	sd	ra,24(sp)
    80001da6:	e822                	sd	s0,16(sp)
    80001da8:	e426                	sd	s1,8(sp)
    80001daa:	1000                	addi	s0,sp,32
    80001dac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001dae:	eefff0ef          	jal	80001c9c <argraw>
    80001db2:	e088                	sd	a0,0(s1)
}
    80001db4:	60e2                	ld	ra,24(sp)
    80001db6:	6442                	ld	s0,16(sp)
    80001db8:	64a2                	ld	s1,8(sp)
    80001dba:	6105                	addi	sp,sp,32
    80001dbc:	8082                	ret

0000000080001dbe <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	e426                	sd	s1,8(sp)
    80001dc6:	e04a                	sd	s2,0(sp)
    80001dc8:	1000                	addi	s0,sp,32
    80001dca:	892e                	mv	s2,a1
    80001dcc:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001dce:	ecfff0ef          	jal	80001c9c <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001dd2:	8626                	mv	a2,s1
    80001dd4:	85ca                	mv	a1,s2
    80001dd6:	f71ff0ef          	jal	80001d46 <fetchstr>
}
    80001dda:	60e2                	ld	ra,24(sp)
    80001ddc:	6442                	ld	s0,16(sp)
    80001dde:	64a2                	ld	s1,8(sp)
    80001de0:	6902                	ld	s2,0(sp)
    80001de2:	6105                	addi	sp,sp,32
    80001de4:	8082                	ret

0000000080001de6 <syscall>:
};


void
syscall(void)
{
    80001de6:	1101                	addi	sp,sp,-32
    80001de8:	ec06                	sd	ra,24(sp)
    80001dea:	e822                	sd	s0,16(sp)
    80001dec:	e426                	sd	s1,8(sp)
    80001dee:	e04a                	sd	s2,0(sp)
    80001df0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001df2:	85eff0ef          	jal	80000e50 <myproc>
    80001df6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001df8:	06053903          	ld	s2,96(a0)
    80001dfc:	0a893783          	ld	a5,168(s2)
    80001e00:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001e04:	37fd                	addiw	a5,a5,-1
    80001e06:	02300713          	li	a4,35
    80001e0a:	00f76f63          	bltu	a4,a5,80001e28 <syscall+0x42>
    80001e0e:	00369713          	slli	a4,a3,0x3
    80001e12:	00007797          	auipc	a5,0x7
    80001e16:	d0678793          	addi	a5,a5,-762 # 80008b18 <syscalls>
    80001e1a:	97ba                	add	a5,a5,a4
    80001e1c:	639c                	ld	a5,0(a5)
    80001e1e:	c789                	beqz	a5,80001e28 <syscall+0x42>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001e20:	9782                	jalr	a5
    80001e22:	06a93823          	sd	a0,112(s2)
    80001e26:	a829                	j	80001e40 <syscall+0x5a>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001e28:	16048613          	addi	a2,s1,352
    80001e2c:	5c8c                	lw	a1,56(s1)
    80001e2e:	00006517          	auipc	a0,0x6
    80001e32:	4e250513          	addi	a0,a0,1250 # 80008310 <etext+0x310>
    80001e36:	18b030ef          	jal	800057c0 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001e3a:	70bc                	ld	a5,96(s1)
    80001e3c:	577d                	li	a4,-1
    80001e3e:	fbb8                	sd	a4,112(a5)
  }
}
    80001e40:	60e2                	ld	ra,24(sp)
    80001e42:	6442                	ld	s0,16(sp)
    80001e44:	64a2                	ld	s1,8(sp)
    80001e46:	6902                	ld	s2,0(sp)
    80001e48:	6105                	addi	sp,sp,32
    80001e4a:	8082                	ret

0000000080001e4c <sys_exit>:
#endif
#include "vm.h"

uint64
sys_exit(void)
{
    80001e4c:	1101                	addi	sp,sp,-32
    80001e4e:	ec06                	sd	ra,24(sp)
    80001e50:	e822                	sd	s0,16(sp)
    80001e52:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001e54:	fec40593          	addi	a1,s0,-20
    80001e58:	4501                	li	a0,0
    80001e5a:	f2dff0ef          	jal	80001d86 <argint>
  kexit(n);
    80001e5e:	fec42503          	lw	a0,-20(s0)
    80001e62:	f24ff0ef          	jal	80001586 <kexit>
  return 0;  // not reached
}
    80001e66:	4501                	li	a0,0
    80001e68:	60e2                	ld	ra,24(sp)
    80001e6a:	6442                	ld	s0,16(sp)
    80001e6c:	6105                	addi	sp,sp,32
    80001e6e:	8082                	ret

0000000080001e70 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001e70:	1141                	addi	sp,sp,-16
    80001e72:	e406                	sd	ra,8(sp)
    80001e74:	e022                	sd	s0,0(sp)
    80001e76:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001e78:	fd9fe0ef          	jal	80000e50 <myproc>
}
    80001e7c:	5d08                	lw	a0,56(a0)
    80001e7e:	60a2                	ld	ra,8(sp)
    80001e80:	6402                	ld	s0,0(sp)
    80001e82:	0141                	addi	sp,sp,16
    80001e84:	8082                	ret

0000000080001e86 <sys_fork>:

uint64
sys_fork(void)
{
    80001e86:	1141                	addi	sp,sp,-16
    80001e88:	e406                	sd	ra,8(sp)
    80001e8a:	e022                	sd	s0,0(sp)
    80001e8c:	0800                	addi	s0,sp,16
  return kfork();
    80001e8e:	b1cff0ef          	jal	800011aa <kfork>
}
    80001e92:	60a2                	ld	ra,8(sp)
    80001e94:	6402                	ld	s0,0(sp)
    80001e96:	0141                	addi	sp,sp,16
    80001e98:	8082                	ret

0000000080001e9a <sys_wait>:

uint64
sys_wait(void)
{
    80001e9a:	1101                	addi	sp,sp,-32
    80001e9c:	ec06                	sd	ra,24(sp)
    80001e9e:	e822                	sd	s0,16(sp)
    80001ea0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001ea2:	fe840593          	addi	a1,s0,-24
    80001ea6:	4501                	li	a0,0
    80001ea8:	efbff0ef          	jal	80001da2 <argaddr>
  return kwait(p);
    80001eac:	fe843503          	ld	a0,-24(s0)
    80001eb0:	831ff0ef          	jal	800016e0 <kwait>
}
    80001eb4:	60e2                	ld	ra,24(sp)
    80001eb6:	6442                	ld	s0,16(sp)
    80001eb8:	6105                	addi	sp,sp,32
    80001eba:	8082                	ret

0000000080001ebc <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001ebc:	7179                	addi	sp,sp,-48
    80001ebe:	f406                	sd	ra,40(sp)
    80001ec0:	f022                	sd	s0,32(sp)
    80001ec2:	ec26                	sd	s1,24(sp)
    80001ec4:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001ec6:	fd840593          	addi	a1,s0,-40
    80001eca:	4501                	li	a0,0
    80001ecc:	ebbff0ef          	jal	80001d86 <argint>
  argint(1, &t);
    80001ed0:	fdc40593          	addi	a1,s0,-36
    80001ed4:	4505                	li	a0,1
    80001ed6:	eb1ff0ef          	jal	80001d86 <argint>
  addr = myproc()->sz;
    80001eda:	f77fe0ef          	jal	80000e50 <myproc>
    80001ede:	6924                	ld	s1,80(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001ee0:	fdc42703          	lw	a4,-36(s0)
    80001ee4:	4785                	li	a5,1
    80001ee6:	02f70163          	beq	a4,a5,80001f08 <sys_sbrk+0x4c>
    80001eea:	fd842783          	lw	a5,-40(s0)
    80001eee:	0007cd63          	bltz	a5,80001f08 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001ef2:	97a6                	add	a5,a5,s1
    80001ef4:	0297e863          	bltu	a5,s1,80001f24 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001ef8:	f59fe0ef          	jal	80000e50 <myproc>
    80001efc:	fd842703          	lw	a4,-40(s0)
    80001f00:	693c                	ld	a5,80(a0)
    80001f02:	97ba                	add	a5,a5,a4
    80001f04:	e93c                	sd	a5,80(a0)
    80001f06:	a039                	j	80001f14 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001f08:	fd842503          	lw	a0,-40(s0)
    80001f0c:	a4eff0ef          	jal	8000115a <growproc>
    80001f10:	00054863          	bltz	a0,80001f20 <sys_sbrk+0x64>
  }
  return addr;
}
    80001f14:	8526                	mv	a0,s1
    80001f16:	70a2                	ld	ra,40(sp)
    80001f18:	7402                	ld	s0,32(sp)
    80001f1a:	64e2                	ld	s1,24(sp)
    80001f1c:	6145                	addi	sp,sp,48
    80001f1e:	8082                	ret
      return -1;
    80001f20:	54fd                	li	s1,-1
    80001f22:	bfcd                	j	80001f14 <sys_sbrk+0x58>
      return -1;
    80001f24:	54fd                	li	s1,-1
    80001f26:	b7fd                	j	80001f14 <sys_sbrk+0x58>

0000000080001f28 <sys_pause>:

uint64
sys_pause(void)
{
    80001f28:	7139                	addi	sp,sp,-64
    80001f2a:	fc06                	sd	ra,56(sp)
    80001f2c:	f822                	sd	s0,48(sp)
    80001f2e:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80001f30:	fcc40593          	addi	a1,s0,-52
    80001f34:	4501                	li	a0,0
    80001f36:	e51ff0ef          	jal	80001d86 <argint>
  if(n < 0)
    80001f3a:	fcc42783          	lw	a5,-52(s0)
    80001f3e:	0607c863          	bltz	a5,80001fae <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001f42:	0000d517          	auipc	a0,0xd
    80001f46:	0fe50513          	addi	a0,a0,254 # 8000f040 <tickslock>
    80001f4a:	6cd030ef          	jal	80005e16 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001f4e:	fcc42783          	lw	a5,-52(s0)
    80001f52:	c3b9                	beqz	a5,80001f98 <sys_pause+0x70>
    80001f54:	f426                	sd	s1,40(sp)
    80001f56:	f04a                	sd	s2,32(sp)
    80001f58:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001f5a:	00007997          	auipc	s3,0x7
    80001f5e:	d3e9a983          	lw	s3,-706(s3) # 80008c98 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001f62:	0000d917          	auipc	s2,0xd
    80001f66:	0de90913          	addi	s2,s2,222 # 8000f040 <tickslock>
    80001f6a:	00007497          	auipc	s1,0x7
    80001f6e:	d2e48493          	addi	s1,s1,-722 # 80008c98 <ticks>
    if(killed(myproc())){
    80001f72:	edffe0ef          	jal	80000e50 <myproc>
    80001f76:	f40ff0ef          	jal	800016b6 <killed>
    80001f7a:	ed0d                	bnez	a0,80001fb4 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001f7c:	85ca                	mv	a1,s2
    80001f7e:	8526                	mv	a0,s1
    80001f80:	cfaff0ef          	jal	8000147a <sleep>
  while(ticks - ticks0 < n){
    80001f84:	409c                	lw	a5,0(s1)
    80001f86:	413787bb          	subw	a5,a5,s3
    80001f8a:	fcc42703          	lw	a4,-52(s0)
    80001f8e:	fee7e2e3          	bltu	a5,a4,80001f72 <sys_pause+0x4a>
    80001f92:	74a2                	ld	s1,40(sp)
    80001f94:	7902                	ld	s2,32(sp)
    80001f96:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001f98:	0000d517          	auipc	a0,0xd
    80001f9c:	0a850513          	addi	a0,a0,168 # 8000f040 <tickslock>
    80001fa0:	75f030ef          	jal	80005efe <release>
  return 0;
    80001fa4:	4501                	li	a0,0
}
    80001fa6:	70e2                	ld	ra,56(sp)
    80001fa8:	7442                	ld	s0,48(sp)
    80001faa:	6121                	addi	sp,sp,64
    80001fac:	8082                	ret
    n = 0;
    80001fae:	fc042623          	sw	zero,-52(s0)
    80001fb2:	bf41                	j	80001f42 <sys_pause+0x1a>
      release(&tickslock);
    80001fb4:	0000d517          	auipc	a0,0xd
    80001fb8:	08c50513          	addi	a0,a0,140 # 8000f040 <tickslock>
    80001fbc:	743030ef          	jal	80005efe <release>
      return -1;
    80001fc0:	557d                	li	a0,-1
    80001fc2:	74a2                	ld	s1,40(sp)
    80001fc4:	7902                	ld	s2,32(sp)
    80001fc6:	69e2                	ld	s3,24(sp)
    80001fc8:	bff9                	j	80001fa6 <sys_pause+0x7e>

0000000080001fca <sys_kill>:
#endif


uint64
sys_kill(void)
{
    80001fca:	1101                	addi	sp,sp,-32
    80001fcc:	ec06                	sd	ra,24(sp)
    80001fce:	e822                	sd	s0,16(sp)
    80001fd0:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001fd2:	fec40593          	addi	a1,s0,-20
    80001fd6:	4501                	li	a0,0
    80001fd8:	dafff0ef          	jal	80001d86 <argint>
  return kkill(pid);
    80001fdc:	fec42503          	lw	a0,-20(s0)
    80001fe0:	e4cff0ef          	jal	8000162c <kkill>
}
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	6105                	addi	sp,sp,32
    80001fea:	8082                	ret

0000000080001fec <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001fec:	1101                	addi	sp,sp,-32
    80001fee:	ec06                	sd	ra,24(sp)
    80001ff0:	e822                	sd	s0,16(sp)
    80001ff2:	e426                	sd	s1,8(sp)
    80001ff4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001ff6:	0000d517          	auipc	a0,0xd
    80001ffa:	04a50513          	addi	a0,a0,74 # 8000f040 <tickslock>
    80001ffe:	619030ef          	jal	80005e16 <acquire>
  xticks = ticks;
    80002002:	00007797          	auipc	a5,0x7
    80002006:	c967a783          	lw	a5,-874(a5) # 80008c98 <ticks>
    8000200a:	84be                	mv	s1,a5
  release(&tickslock);
    8000200c:	0000d517          	auipc	a0,0xd
    80002010:	03450513          	addi	a0,a0,52 # 8000f040 <tickslock>
    80002014:	6eb030ef          	jal	80005efe <release>
  return xticks;
}
    80002018:	02049513          	slli	a0,s1,0x20
    8000201c:	9101                	srli	a0,a0,0x20
    8000201e:	60e2                	ld	ra,24(sp)
    80002020:	6442                	ld	s0,16(sp)
    80002022:	64a2                	ld	s1,8(sp)
    80002024:	6105                	addi	sp,sp,32
    80002026:	8082                	ret

0000000080002028 <sys_cpupin>:

#ifdef LAB_LOCK
uint64
sys_cpupin(void)
{
    80002028:	7179                	addi	sp,sp,-48
    8000202a:	f406                	sd	ra,40(sp)
    8000202c:	f022                	sd	s0,32(sp)
    8000202e:	ec26                	sd	s1,24(sp)
    80002030:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80002032:	e1ffe0ef          	jal	80000e50 <myproc>
    80002036:	84aa                	mv	s1,a0
  int cpu;

  argint(0, &cpu);
    80002038:	fdc40593          	addi	a1,s0,-36
    8000203c:	4501                	li	a0,0
    8000203e:	d49ff0ef          	jal	80001d86 <argint>
  if (cpu < 0 || cpu >= NCPU)
    80002042:	fdc42703          	lw	a4,-36(s0)
    80002046:	479d                	li	a5,7
    return -1;
    80002048:	557d                	li	a0,-1
  if (cpu < 0 || cpu >= NCPU)
    8000204a:	02e7e363          	bltu	a5,a4,80002070 <sys_cpupin+0x48>
  acquire(&p->lock);
    8000204e:	8526                	mv	a0,s1
    80002050:	5c7030ef          	jal	80005e16 <acquire>
  p->pincpu = &cpus[cpu];
    80002054:	fdc42783          	lw	a5,-36(s0)
    80002058:	079e                	slli	a5,a5,0x7
    8000205a:	00007717          	auipc	a4,0x7
    8000205e:	de670713          	addi	a4,a4,-538 # 80008e40 <cpus>
    80002062:	97ba                	add	a5,a5,a4
    80002064:	16f4b823          	sd	a5,368(s1)
  release(&p->lock);
    80002068:	8526                	mv	a0,s1
    8000206a:	695030ef          	jal	80005efe <release>
  return 0;
    8000206e:	4501                	li	a0,0
}
    80002070:	70a2                	ld	ra,40(sp)
    80002072:	7402                	ld	s0,32(sp)
    80002074:	64e2                	ld	s1,24(sp)
    80002076:	6145                	addi	sp,sp,48
    80002078:	8082                	ret

000000008000207a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000207a:	7179                	addi	sp,sp,-48
    8000207c:	f406                	sd	ra,40(sp)
    8000207e:	f022                	sd	s0,32(sp)
    80002080:	ec26                	sd	s1,24(sp)
    80002082:	e84a                	sd	s2,16(sp)
    80002084:	e44e                	sd	s3,8(sp)
    80002086:	e052                	sd	s4,0(sp)
    80002088:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000208a:	00006597          	auipc	a1,0x6
    8000208e:	2a658593          	addi	a1,a1,678 # 80008330 <etext+0x330>
    80002092:	0000d517          	auipc	a0,0xd
    80002096:	fce50513          	addi	a0,a0,-50 # 8000f060 <bcache>
    8000209a:	6fd030ef          	jal	80005f96 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000209e:	00015797          	auipc	a5,0x15
    800020a2:	fc278793          	addi	a5,a5,-62 # 80017060 <bcache+0x8000>
    800020a6:	00015717          	auipc	a4,0x15
    800020aa:	31a70713          	addi	a4,a4,794 # 800173c0 <bcache+0x8360>
    800020ae:	3ae7b823          	sd	a4,944(a5)
  bcache.head.next = &bcache.head;
    800020b2:	3ae7bc23          	sd	a4,952(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020b6:	0000d497          	auipc	s1,0xd
    800020ba:	fca48493          	addi	s1,s1,-54 # 8000f080 <bcache+0x20>
    b->next = bcache.head.next;
    800020be:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800020c0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800020c2:	00006a17          	auipc	s4,0x6
    800020c6:	276a0a13          	addi	s4,s4,630 # 80008338 <etext+0x338>
    b->next = bcache.head.next;
    800020ca:	3b893783          	ld	a5,952(s2)
    800020ce:	ecbc                	sd	a5,88(s1)
    b->prev = &bcache.head;
    800020d0:	0534b823          	sd	s3,80(s1)
    initsleeplock(&b->lock, "buffer");
    800020d4:	85d2                	mv	a1,s4
    800020d6:	01048513          	addi	a0,s1,16
    800020da:	334010ef          	jal	8000340e <initsleeplock>
    bcache.head.next->prev = b;
    800020de:	3b893783          	ld	a5,952(s2)
    800020e2:	eba4                	sd	s1,80(a5)
    bcache.head.next = b;
    800020e4:	3a993c23          	sd	s1,952(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020e8:	46048493          	addi	s1,s1,1120
    800020ec:	fd349fe3          	bne	s1,s3,800020ca <binit+0x50>
  }
}
    800020f0:	70a2                	ld	ra,40(sp)
    800020f2:	7402                	ld	s0,32(sp)
    800020f4:	64e2                	ld	s1,24(sp)
    800020f6:	6942                	ld	s2,16(sp)
    800020f8:	69a2                	ld	s3,8(sp)
    800020fa:	6a02                	ld	s4,0(sp)
    800020fc:	6145                	addi	sp,sp,48
    800020fe:	8082                	ret

0000000080002100 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002100:	7179                	addi	sp,sp,-48
    80002102:	f406                	sd	ra,40(sp)
    80002104:	f022                	sd	s0,32(sp)
    80002106:	ec26                	sd	s1,24(sp)
    80002108:	e84a                	sd	s2,16(sp)
    8000210a:	e44e                	sd	s3,8(sp)
    8000210c:	1800                	addi	s0,sp,48
    8000210e:	892a                	mv	s2,a0
    80002110:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002112:	0000d517          	auipc	a0,0xd
    80002116:	f4e50513          	addi	a0,a0,-178 # 8000f060 <bcache>
    8000211a:	4fd030ef          	jal	80005e16 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000211e:	00015497          	auipc	s1,0x15
    80002122:	2fa4b483          	ld	s1,762(s1) # 80017418 <bcache+0x83b8>
    80002126:	00015797          	auipc	a5,0x15
    8000212a:	29a78793          	addi	a5,a5,666 # 800173c0 <bcache+0x8360>
    8000212e:	02f48b63          	beq	s1,a5,80002164 <bread+0x64>
    80002132:	873e                	mv	a4,a5
    80002134:	a021                	j	8000213c <bread+0x3c>
    80002136:	6ca4                	ld	s1,88(s1)
    80002138:	02e48663          	beq	s1,a4,80002164 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000213c:	449c                	lw	a5,8(s1)
    8000213e:	ff279ce3          	bne	a5,s2,80002136 <bread+0x36>
    80002142:	44dc                	lw	a5,12(s1)
    80002144:	ff3799e3          	bne	a5,s3,80002136 <bread+0x36>
      b->refcnt++;
    80002148:	44bc                	lw	a5,72(s1)
    8000214a:	2785                	addiw	a5,a5,1
    8000214c:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    8000214e:	0000d517          	auipc	a0,0xd
    80002152:	f1250513          	addi	a0,a0,-238 # 8000f060 <bcache>
    80002156:	5a9030ef          	jal	80005efe <release>
      acquiresleep(&b->lock);
    8000215a:	01048513          	addi	a0,s1,16
    8000215e:	2e6010ef          	jal	80003444 <acquiresleep>
      return b;
    80002162:	a889                	j	800021b4 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002164:	00015497          	auipc	s1,0x15
    80002168:	2ac4b483          	ld	s1,684(s1) # 80017410 <bcache+0x83b0>
    8000216c:	00015797          	auipc	a5,0x15
    80002170:	25478793          	addi	a5,a5,596 # 800173c0 <bcache+0x8360>
    80002174:	00f48863          	beq	s1,a5,80002184 <bread+0x84>
    80002178:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000217a:	44bc                	lw	a5,72(s1)
    8000217c:	cb91                	beqz	a5,80002190 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000217e:	68a4                	ld	s1,80(s1)
    80002180:	fee49de3          	bne	s1,a4,8000217a <bread+0x7a>
  panic("bget: no buffers");
    80002184:	00006517          	auipc	a0,0x6
    80002188:	1bc50513          	addi	a0,a0,444 # 80008340 <etext+0x340>
    8000218c:	15f030ef          	jal	80005aea <panic>
      b->dev = dev;
    80002190:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002194:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002198:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000219c:	4785                	li	a5,1
    8000219e:	c4bc                	sw	a5,72(s1)
      release(&bcache.lock);
    800021a0:	0000d517          	auipc	a0,0xd
    800021a4:	ec050513          	addi	a0,a0,-320 # 8000f060 <bcache>
    800021a8:	557030ef          	jal	80005efe <release>
      acquiresleep(&b->lock);
    800021ac:	01048513          	addi	a0,s1,16
    800021b0:	294010ef          	jal	80003444 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800021b4:	409c                	lw	a5,0(s1)
    800021b6:	cb89                	beqz	a5,800021c8 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800021b8:	8526                	mv	a0,s1
    800021ba:	70a2                	ld	ra,40(sp)
    800021bc:	7402                	ld	s0,32(sp)
    800021be:	64e2                	ld	s1,24(sp)
    800021c0:	6942                	ld	s2,16(sp)
    800021c2:	69a2                	ld	s3,8(sp)
    800021c4:	6145                	addi	sp,sp,48
    800021c6:	8082                	ret
    virtio_disk_rw(b, 0);
    800021c8:	4581                	li	a1,0
    800021ca:	8526                	mv	a0,s1
    800021cc:	2f5020ef          	jal	80004cc0 <virtio_disk_rw>
    b->valid = 1;
    800021d0:	4785                	li	a5,1
    800021d2:	c09c                	sw	a5,0(s1)
  return b;
    800021d4:	b7d5                	j	800021b8 <bread+0xb8>

00000000800021d6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800021d6:	1101                	addi	sp,sp,-32
    800021d8:	ec06                	sd	ra,24(sp)
    800021da:	e822                	sd	s0,16(sp)
    800021dc:	e426                	sd	s1,8(sp)
    800021de:	1000                	addi	s0,sp,32
    800021e0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021e2:	0541                	addi	a0,a0,16
    800021e4:	2de010ef          	jal	800034c2 <holdingsleep>
    800021e8:	c911                	beqz	a0,800021fc <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021ea:	4585                	li	a1,1
    800021ec:	8526                	mv	a0,s1
    800021ee:	2d3020ef          	jal	80004cc0 <virtio_disk_rw>
}
    800021f2:	60e2                	ld	ra,24(sp)
    800021f4:	6442                	ld	s0,16(sp)
    800021f6:	64a2                	ld	s1,8(sp)
    800021f8:	6105                	addi	sp,sp,32
    800021fa:	8082                	ret
    panic("bwrite");
    800021fc:	00006517          	auipc	a0,0x6
    80002200:	15c50513          	addi	a0,a0,348 # 80008358 <etext+0x358>
    80002204:	0e7030ef          	jal	80005aea <panic>

0000000080002208 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002208:	1101                	addi	sp,sp,-32
    8000220a:	ec06                	sd	ra,24(sp)
    8000220c:	e822                	sd	s0,16(sp)
    8000220e:	e426                	sd	s1,8(sp)
    80002210:	e04a                	sd	s2,0(sp)
    80002212:	1000                	addi	s0,sp,32
    80002214:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002216:	01050913          	addi	s2,a0,16
    8000221a:	854a                	mv	a0,s2
    8000221c:	2a6010ef          	jal	800034c2 <holdingsleep>
    80002220:	c125                	beqz	a0,80002280 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002222:	854a                	mv	a0,s2
    80002224:	266010ef          	jal	8000348a <releasesleep>

  acquire(&bcache.lock);
    80002228:	0000d517          	auipc	a0,0xd
    8000222c:	e3850513          	addi	a0,a0,-456 # 8000f060 <bcache>
    80002230:	3e7030ef          	jal	80005e16 <acquire>
  b->refcnt--;
    80002234:	44bc                	lw	a5,72(s1)
    80002236:	37fd                	addiw	a5,a5,-1
    80002238:	c4bc                	sw	a5,72(s1)
  if (b->refcnt == 0) {
    8000223a:	e79d                	bnez	a5,80002268 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000223c:	6cb8                	ld	a4,88(s1)
    8000223e:	68bc                	ld	a5,80(s1)
    80002240:	eb3c                	sd	a5,80(a4)
    b->prev->next = b->next;
    80002242:	6cb8                	ld	a4,88(s1)
    80002244:	efb8                	sd	a4,88(a5)
    b->next = bcache.head.next;
    80002246:	00015797          	auipc	a5,0x15
    8000224a:	e1a78793          	addi	a5,a5,-486 # 80017060 <bcache+0x8000>
    8000224e:	3b87b703          	ld	a4,952(a5)
    80002252:	ecb8                	sd	a4,88(s1)
    b->prev = &bcache.head;
    80002254:	00015717          	auipc	a4,0x15
    80002258:	16c70713          	addi	a4,a4,364 # 800173c0 <bcache+0x8360>
    8000225c:	e8b8                	sd	a4,80(s1)
    bcache.head.next->prev = b;
    8000225e:	3b87b703          	ld	a4,952(a5)
    80002262:	eb24                	sd	s1,80(a4)
    bcache.head.next = b;
    80002264:	3a97bc23          	sd	s1,952(a5)
  }
  
  release(&bcache.lock);
    80002268:	0000d517          	auipc	a0,0xd
    8000226c:	df850513          	addi	a0,a0,-520 # 8000f060 <bcache>
    80002270:	48f030ef          	jal	80005efe <release>
}
    80002274:	60e2                	ld	ra,24(sp)
    80002276:	6442                	ld	s0,16(sp)
    80002278:	64a2                	ld	s1,8(sp)
    8000227a:	6902                	ld	s2,0(sp)
    8000227c:	6105                	addi	sp,sp,32
    8000227e:	8082                	ret
    panic("brelse");
    80002280:	00006517          	auipc	a0,0x6
    80002284:	0e050513          	addi	a0,a0,224 # 80008360 <etext+0x360>
    80002288:	063030ef          	jal	80005aea <panic>

000000008000228c <bpin>:

void
bpin(struct buf *b) {
    8000228c:	1101                	addi	sp,sp,-32
    8000228e:	ec06                	sd	ra,24(sp)
    80002290:	e822                	sd	s0,16(sp)
    80002292:	e426                	sd	s1,8(sp)
    80002294:	1000                	addi	s0,sp,32
    80002296:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002298:	0000d517          	auipc	a0,0xd
    8000229c:	dc850513          	addi	a0,a0,-568 # 8000f060 <bcache>
    800022a0:	377030ef          	jal	80005e16 <acquire>
  b->refcnt++;
    800022a4:	44bc                	lw	a5,72(s1)
    800022a6:	2785                	addiw	a5,a5,1
    800022a8:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    800022aa:	0000d517          	auipc	a0,0xd
    800022ae:	db650513          	addi	a0,a0,-586 # 8000f060 <bcache>
    800022b2:	44d030ef          	jal	80005efe <release>
}
    800022b6:	60e2                	ld	ra,24(sp)
    800022b8:	6442                	ld	s0,16(sp)
    800022ba:	64a2                	ld	s1,8(sp)
    800022bc:	6105                	addi	sp,sp,32
    800022be:	8082                	ret

00000000800022c0 <bunpin>:

void
bunpin(struct buf *b) {
    800022c0:	1101                	addi	sp,sp,-32
    800022c2:	ec06                	sd	ra,24(sp)
    800022c4:	e822                	sd	s0,16(sp)
    800022c6:	e426                	sd	s1,8(sp)
    800022c8:	1000                	addi	s0,sp,32
    800022ca:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022cc:	0000d517          	auipc	a0,0xd
    800022d0:	d9450513          	addi	a0,a0,-620 # 8000f060 <bcache>
    800022d4:	343030ef          	jal	80005e16 <acquire>
  b->refcnt--;
    800022d8:	44bc                	lw	a5,72(s1)
    800022da:	37fd                	addiw	a5,a5,-1
    800022dc:	c4bc                	sw	a5,72(s1)
  release(&bcache.lock);
    800022de:	0000d517          	auipc	a0,0xd
    800022e2:	d8250513          	addi	a0,a0,-638 # 8000f060 <bcache>
    800022e6:	419030ef          	jal	80005efe <release>
}
    800022ea:	60e2                	ld	ra,24(sp)
    800022ec:	6442                	ld	s0,16(sp)
    800022ee:	64a2                	ld	s1,8(sp)
    800022f0:	6105                	addi	sp,sp,32
    800022f2:	8082                	ret

00000000800022f4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800022f4:	1101                	addi	sp,sp,-32
    800022f6:	ec06                	sd	ra,24(sp)
    800022f8:	e822                	sd	s0,16(sp)
    800022fa:	e426                	sd	s1,8(sp)
    800022fc:	e04a                	sd	s2,0(sp)
    800022fe:	1000                	addi	s0,sp,32
    80002300:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002302:	00d5d79b          	srliw	a5,a1,0xd
    80002306:	00015597          	auipc	a1,0x15
    8000230a:	5365a583          	lw	a1,1334(a1) # 8001783c <sb+0x1c>
    8000230e:	9dbd                	addw	a1,a1,a5
    80002310:	df1ff0ef          	jal	80002100 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002314:	0074f713          	andi	a4,s1,7
    80002318:	4785                	li	a5,1
    8000231a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000231e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002320:	90d9                	srli	s1,s1,0x36
    80002322:	00950733          	add	a4,a0,s1
    80002326:	06074703          	lbu	a4,96(a4)
    8000232a:	00e7f6b3          	and	a3,a5,a4
    8000232e:	c29d                	beqz	a3,80002354 <bfree+0x60>
    80002330:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002332:	94aa                	add	s1,s1,a0
    80002334:	fff7c793          	not	a5,a5
    80002338:	8f7d                	and	a4,a4,a5
    8000233a:	06e48023          	sb	a4,96(s1)
  log_write(bp);
    8000233e:	00c010ef          	jal	8000334a <log_write>
  brelse(bp);
    80002342:	854a                	mv	a0,s2
    80002344:	ec5ff0ef          	jal	80002208 <brelse>
}
    80002348:	60e2                	ld	ra,24(sp)
    8000234a:	6442                	ld	s0,16(sp)
    8000234c:	64a2                	ld	s1,8(sp)
    8000234e:	6902                	ld	s2,0(sp)
    80002350:	6105                	addi	sp,sp,32
    80002352:	8082                	ret
    panic("freeing free block");
    80002354:	00006517          	auipc	a0,0x6
    80002358:	01450513          	addi	a0,a0,20 # 80008368 <etext+0x368>
    8000235c:	78e030ef          	jal	80005aea <panic>

0000000080002360 <balloc>:
{
    80002360:	715d                	addi	sp,sp,-80
    80002362:	e486                	sd	ra,72(sp)
    80002364:	e0a2                	sd	s0,64(sp)
    80002366:	fc26                	sd	s1,56(sp)
    80002368:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000236a:	00015797          	auipc	a5,0x15
    8000236e:	4ba7a783          	lw	a5,1210(a5) # 80017824 <sb+0x4>
    80002372:	0e078263          	beqz	a5,80002456 <balloc+0xf6>
    80002376:	f84a                	sd	s2,48(sp)
    80002378:	f44e                	sd	s3,40(sp)
    8000237a:	f052                	sd	s4,32(sp)
    8000237c:	ec56                	sd	s5,24(sp)
    8000237e:	e85a                	sd	s6,16(sp)
    80002380:	e45e                	sd	s7,8(sp)
    80002382:	e062                	sd	s8,0(sp)
    80002384:	8baa                	mv	s7,a0
    80002386:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002388:	00015b17          	auipc	s6,0x15
    8000238c:	498b0b13          	addi	s6,s6,1176 # 80017820 <sb>
      m = 1 << (bi % 8);
    80002390:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002392:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002394:	6c09                	lui	s8,0x2
    80002396:	a09d                	j	800023fc <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002398:	97ca                	add	a5,a5,s2
    8000239a:	8e55                	or	a2,a2,a3
    8000239c:	06c78023          	sb	a2,96(a5)
        log_write(bp);
    800023a0:	854a                	mv	a0,s2
    800023a2:	7a9000ef          	jal	8000334a <log_write>
        brelse(bp);
    800023a6:	854a                	mv	a0,s2
    800023a8:	e61ff0ef          	jal	80002208 <brelse>
  bp = bread(dev, bno);
    800023ac:	85a6                	mv	a1,s1
    800023ae:	855e                	mv	a0,s7
    800023b0:	d51ff0ef          	jal	80002100 <bread>
    800023b4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800023b6:	40000613          	li	a2,1024
    800023ba:	4581                	li	a1,0
    800023bc:	06050513          	addi	a0,a0,96
    800023c0:	e5ffd0ef          	jal	8000021e <memset>
  log_write(bp);
    800023c4:	854a                	mv	a0,s2
    800023c6:	785000ef          	jal	8000334a <log_write>
  brelse(bp);
    800023ca:	854a                	mv	a0,s2
    800023cc:	e3dff0ef          	jal	80002208 <brelse>
}
    800023d0:	7942                	ld	s2,48(sp)
    800023d2:	79a2                	ld	s3,40(sp)
    800023d4:	7a02                	ld	s4,32(sp)
    800023d6:	6ae2                	ld	s5,24(sp)
    800023d8:	6b42                	ld	s6,16(sp)
    800023da:	6ba2                	ld	s7,8(sp)
    800023dc:	6c02                	ld	s8,0(sp)
}
    800023de:	8526                	mv	a0,s1
    800023e0:	60a6                	ld	ra,72(sp)
    800023e2:	6406                	ld	s0,64(sp)
    800023e4:	74e2                	ld	s1,56(sp)
    800023e6:	6161                	addi	sp,sp,80
    800023e8:	8082                	ret
    brelse(bp);
    800023ea:	854a                	mv	a0,s2
    800023ec:	e1dff0ef          	jal	80002208 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800023f0:	015c0abb          	addw	s5,s8,s5
    800023f4:	004b2783          	lw	a5,4(s6)
    800023f8:	04faf863          	bgeu	s5,a5,80002448 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800023fc:	40dad59b          	sraiw	a1,s5,0xd
    80002400:	01cb2783          	lw	a5,28(s6)
    80002404:	9dbd                	addw	a1,a1,a5
    80002406:	855e                	mv	a0,s7
    80002408:	cf9ff0ef          	jal	80002100 <bread>
    8000240c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000240e:	004b2503          	lw	a0,4(s6)
    80002412:	84d6                	mv	s1,s5
    80002414:	4701                	li	a4,0
    80002416:	fca4fae3          	bgeu	s1,a0,800023ea <balloc+0x8a>
      m = 1 << (bi % 8);
    8000241a:	00777693          	andi	a3,a4,7
    8000241e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002422:	41f7579b          	sraiw	a5,a4,0x1f
    80002426:	01d7d79b          	srliw	a5,a5,0x1d
    8000242a:	9fb9                	addw	a5,a5,a4
    8000242c:	4037d79b          	sraiw	a5,a5,0x3
    80002430:	00f90633          	add	a2,s2,a5
    80002434:	06064603          	lbu	a2,96(a2)
    80002438:	00c6f5b3          	and	a1,a3,a2
    8000243c:	ddb1                	beqz	a1,80002398 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000243e:	2705                	addiw	a4,a4,1
    80002440:	2485                	addiw	s1,s1,1
    80002442:	fd471ae3          	bne	a4,s4,80002416 <balloc+0xb6>
    80002446:	b755                	j	800023ea <balloc+0x8a>
    80002448:	7942                	ld	s2,48(sp)
    8000244a:	79a2                	ld	s3,40(sp)
    8000244c:	7a02                	ld	s4,32(sp)
    8000244e:	6ae2                	ld	s5,24(sp)
    80002450:	6b42                	ld	s6,16(sp)
    80002452:	6ba2                	ld	s7,8(sp)
    80002454:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002456:	00006517          	auipc	a0,0x6
    8000245a:	f2a50513          	addi	a0,a0,-214 # 80008380 <etext+0x380>
    8000245e:	362030ef          	jal	800057c0 <printf>
  return 0;
    80002462:	4481                	li	s1,0
    80002464:	bfad                	j	800023de <balloc+0x7e>

0000000080002466 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002466:	7179                	addi	sp,sp,-48
    80002468:	f406                	sd	ra,40(sp)
    8000246a:	f022                	sd	s0,32(sp)
    8000246c:	ec26                	sd	s1,24(sp)
    8000246e:	e84a                	sd	s2,16(sp)
    80002470:	e44e                	sd	s3,8(sp)
    80002472:	1800                	addi	s0,sp,48
    80002474:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002476:	47ad                	li	a5,11
    80002478:	02b7e363          	bltu	a5,a1,8000249e <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000247c:	02059793          	slli	a5,a1,0x20
    80002480:	01e7d593          	srli	a1,a5,0x1e
    80002484:	00b509b3          	add	s3,a0,a1
    80002488:	0589a483          	lw	s1,88(s3)
    8000248c:	e0b5                	bnez	s1,800024f0 <bmap+0x8a>
      addr = balloc(ip->dev);
    8000248e:	4108                	lw	a0,0(a0)
    80002490:	ed1ff0ef          	jal	80002360 <balloc>
    80002494:	84aa                	mv	s1,a0
      if(addr == 0)
    80002496:	cd29                	beqz	a0,800024f0 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002498:	04a9ac23          	sw	a0,88(s3)
    8000249c:	a891                	j	800024f0 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000249e:	ff45879b          	addiw	a5,a1,-12
    800024a2:	873e                	mv	a4,a5
    800024a4:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    800024a6:	0ff00793          	li	a5,255
    800024aa:	06e7e763          	bltu	a5,a4,80002518 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800024ae:	08852483          	lw	s1,136(a0)
    800024b2:	e891                	bnez	s1,800024c6 <bmap+0x60>
      addr = balloc(ip->dev);
    800024b4:	4108                	lw	a0,0(a0)
    800024b6:	eabff0ef          	jal	80002360 <balloc>
    800024ba:	84aa                	mv	s1,a0
      if(addr == 0)
    800024bc:	c915                	beqz	a0,800024f0 <bmap+0x8a>
    800024be:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800024c0:	08a92423          	sw	a0,136(s2)
    800024c4:	a011                	j	800024c8 <bmap+0x62>
    800024c6:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800024c8:	85a6                	mv	a1,s1
    800024ca:	00092503          	lw	a0,0(s2)
    800024ce:	c33ff0ef          	jal	80002100 <bread>
    800024d2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800024d4:	06050793          	addi	a5,a0,96
    if((addr = a[bn]) == 0){
    800024d8:	02099713          	slli	a4,s3,0x20
    800024dc:	01e75593          	srli	a1,a4,0x1e
    800024e0:	97ae                	add	a5,a5,a1
    800024e2:	89be                	mv	s3,a5
    800024e4:	4384                	lw	s1,0(a5)
    800024e6:	cc89                	beqz	s1,80002500 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800024e8:	8552                	mv	a0,s4
    800024ea:	d1fff0ef          	jal	80002208 <brelse>
    return addr;
    800024ee:	6a02                	ld	s4,0(sp)
  }
  panic("bmap: out of range");
}
    800024f0:	8526                	mv	a0,s1
    800024f2:	70a2                	ld	ra,40(sp)
    800024f4:	7402                	ld	s0,32(sp)
    800024f6:	64e2                	ld	s1,24(sp)
    800024f8:	6942                	ld	s2,16(sp)
    800024fa:	69a2                	ld	s3,8(sp)
    800024fc:	6145                	addi	sp,sp,48
    800024fe:	8082                	ret
      addr = balloc(ip->dev);
    80002500:	00092503          	lw	a0,0(s2)
    80002504:	e5dff0ef          	jal	80002360 <balloc>
    80002508:	84aa                	mv	s1,a0
      if(addr){
    8000250a:	dd79                	beqz	a0,800024e8 <bmap+0x82>
        a[bn] = addr;
    8000250c:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002510:	8552                	mv	a0,s4
    80002512:	639000ef          	jal	8000334a <log_write>
    80002516:	bfc9                	j	800024e8 <bmap+0x82>
    80002518:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000251a:	00006517          	auipc	a0,0x6
    8000251e:	e7e50513          	addi	a0,a0,-386 # 80008398 <etext+0x398>
    80002522:	5c8030ef          	jal	80005aea <panic>

0000000080002526 <iget>:
{
    80002526:	7179                	addi	sp,sp,-48
    80002528:	f406                	sd	ra,40(sp)
    8000252a:	f022                	sd	s0,32(sp)
    8000252c:	ec26                	sd	s1,24(sp)
    8000252e:	e84a                	sd	s2,16(sp)
    80002530:	e44e                	sd	s3,8(sp)
    80002532:	e052                	sd	s4,0(sp)
    80002534:	1800                	addi	s0,sp,48
    80002536:	892a                	mv	s2,a0
    80002538:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000253a:	00015517          	auipc	a0,0x15
    8000253e:	30650513          	addi	a0,a0,774 # 80017840 <itable>
    80002542:	0d5030ef          	jal	80005e16 <acquire>
  empty = 0;
    80002546:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002548:	00015497          	auipc	s1,0x15
    8000254c:	31848493          	addi	s1,s1,792 # 80017860 <itable+0x20>
    80002550:	00017697          	auipc	a3,0x17
    80002554:	f3068693          	addi	a3,a3,-208 # 80019480 <log>
    80002558:	a809                	j	8000256a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000255a:	e781                	bnez	a5,80002562 <iget+0x3c>
    8000255c:	00099363          	bnez	s3,80002562 <iget+0x3c>
      empty = ip;
    80002560:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002562:	09048493          	addi	s1,s1,144
    80002566:	02d48563          	beq	s1,a3,80002590 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000256a:	449c                	lw	a5,8(s1)
    8000256c:	fef057e3          	blez	a5,8000255a <iget+0x34>
    80002570:	4098                	lw	a4,0(s1)
    80002572:	ff2718e3          	bne	a4,s2,80002562 <iget+0x3c>
    80002576:	40d8                	lw	a4,4(s1)
    80002578:	ff4715e3          	bne	a4,s4,80002562 <iget+0x3c>
      ip->ref++;
    8000257c:	2785                	addiw	a5,a5,1
    8000257e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002580:	00015517          	auipc	a0,0x15
    80002584:	2c050513          	addi	a0,a0,704 # 80017840 <itable>
    80002588:	177030ef          	jal	80005efe <release>
      return ip;
    8000258c:	89a6                	mv	s3,s1
    8000258e:	a015                	j	800025b2 <iget+0x8c>
  if(empty == 0)
    80002590:	02098a63          	beqz	s3,800025c4 <iget+0x9e>
  ip->dev = dev;
    80002594:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002598:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    8000259c:	4785                	li	a5,1
    8000259e:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    800025a2:	0409a423          	sw	zero,72(s3)
  release(&itable.lock);
    800025a6:	00015517          	auipc	a0,0x15
    800025aa:	29a50513          	addi	a0,a0,666 # 80017840 <itable>
    800025ae:	151030ef          	jal	80005efe <release>
}
    800025b2:	854e                	mv	a0,s3
    800025b4:	70a2                	ld	ra,40(sp)
    800025b6:	7402                	ld	s0,32(sp)
    800025b8:	64e2                	ld	s1,24(sp)
    800025ba:	6942                	ld	s2,16(sp)
    800025bc:	69a2                	ld	s3,8(sp)
    800025be:	6a02                	ld	s4,0(sp)
    800025c0:	6145                	addi	sp,sp,48
    800025c2:	8082                	ret
    panic("iget: no inodes");
    800025c4:	00006517          	auipc	a0,0x6
    800025c8:	dec50513          	addi	a0,a0,-532 # 800083b0 <etext+0x3b0>
    800025cc:	51e030ef          	jal	80005aea <panic>

00000000800025d0 <iinit>:
{
    800025d0:	7179                	addi	sp,sp,-48
    800025d2:	f406                	sd	ra,40(sp)
    800025d4:	f022                	sd	s0,32(sp)
    800025d6:	ec26                	sd	s1,24(sp)
    800025d8:	e84a                	sd	s2,16(sp)
    800025da:	e44e                	sd	s3,8(sp)
    800025dc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025de:	00006597          	auipc	a1,0x6
    800025e2:	de258593          	addi	a1,a1,-542 # 800083c0 <etext+0x3c0>
    800025e6:	00015517          	auipc	a0,0x15
    800025ea:	25a50513          	addi	a0,a0,602 # 80017840 <itable>
    800025ee:	1a9030ef          	jal	80005f96 <initlock>
  for(i = 0; i < NINODE; i++) {
    800025f2:	00015497          	auipc	s1,0x15
    800025f6:	27e48493          	addi	s1,s1,638 # 80017870 <itable+0x30>
    800025fa:	00017997          	auipc	s3,0x17
    800025fe:	e9698993          	addi	s3,s3,-362 # 80019490 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002602:	00006917          	auipc	s2,0x6
    80002606:	dc690913          	addi	s2,s2,-570 # 800083c8 <etext+0x3c8>
    8000260a:	85ca                	mv	a1,s2
    8000260c:	8526                	mv	a0,s1
    8000260e:	601000ef          	jal	8000340e <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002612:	09048493          	addi	s1,s1,144
    80002616:	ff349ae3          	bne	s1,s3,8000260a <iinit+0x3a>
}
    8000261a:	70a2                	ld	ra,40(sp)
    8000261c:	7402                	ld	s0,32(sp)
    8000261e:	64e2                	ld	s1,24(sp)
    80002620:	6942                	ld	s2,16(sp)
    80002622:	69a2                	ld	s3,8(sp)
    80002624:	6145                	addi	sp,sp,48
    80002626:	8082                	ret

0000000080002628 <ialloc>:
{
    80002628:	7139                	addi	sp,sp,-64
    8000262a:	fc06                	sd	ra,56(sp)
    8000262c:	f822                	sd	s0,48(sp)
    8000262e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002630:	00015717          	auipc	a4,0x15
    80002634:	1fc72703          	lw	a4,508(a4) # 8001782c <sb+0xc>
    80002638:	4785                	li	a5,1
    8000263a:	06e7f063          	bgeu	a5,a4,8000269a <ialloc+0x72>
    8000263e:	f426                	sd	s1,40(sp)
    80002640:	f04a                	sd	s2,32(sp)
    80002642:	ec4e                	sd	s3,24(sp)
    80002644:	e852                	sd	s4,16(sp)
    80002646:	e456                	sd	s5,8(sp)
    80002648:	e05a                	sd	s6,0(sp)
    8000264a:	8aaa                	mv	s5,a0
    8000264c:	8b2e                	mv	s6,a1
    8000264e:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002650:	00015a17          	auipc	s4,0x15
    80002654:	1d0a0a13          	addi	s4,s4,464 # 80017820 <sb>
    80002658:	00495593          	srli	a1,s2,0x4
    8000265c:	018a2783          	lw	a5,24(s4)
    80002660:	9dbd                	addw	a1,a1,a5
    80002662:	8556                	mv	a0,s5
    80002664:	a9dff0ef          	jal	80002100 <bread>
    80002668:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000266a:	06050993          	addi	s3,a0,96
    8000266e:	00f97793          	andi	a5,s2,15
    80002672:	079a                	slli	a5,a5,0x6
    80002674:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002676:	00099783          	lh	a5,0(s3)
    8000267a:	cb9d                	beqz	a5,800026b0 <ialloc+0x88>
    brelse(bp);
    8000267c:	b8dff0ef          	jal	80002208 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002680:	0905                	addi	s2,s2,1
    80002682:	00ca2703          	lw	a4,12(s4)
    80002686:	0009079b          	sext.w	a5,s2
    8000268a:	fce7e7e3          	bltu	a5,a4,80002658 <ialloc+0x30>
    8000268e:	74a2                	ld	s1,40(sp)
    80002690:	7902                	ld	s2,32(sp)
    80002692:	69e2                	ld	s3,24(sp)
    80002694:	6a42                	ld	s4,16(sp)
    80002696:	6aa2                	ld	s5,8(sp)
    80002698:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000269a:	00006517          	auipc	a0,0x6
    8000269e:	d3650513          	addi	a0,a0,-714 # 800083d0 <etext+0x3d0>
    800026a2:	11e030ef          	jal	800057c0 <printf>
  return 0;
    800026a6:	4501                	li	a0,0
}
    800026a8:	70e2                	ld	ra,56(sp)
    800026aa:	7442                	ld	s0,48(sp)
    800026ac:	6121                	addi	sp,sp,64
    800026ae:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800026b0:	04000613          	li	a2,64
    800026b4:	4581                	li	a1,0
    800026b6:	854e                	mv	a0,s3
    800026b8:	b67fd0ef          	jal	8000021e <memset>
      dip->type = type;
    800026bc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800026c0:	8526                	mv	a0,s1
    800026c2:	489000ef          	jal	8000334a <log_write>
      brelse(bp);
    800026c6:	8526                	mv	a0,s1
    800026c8:	b41ff0ef          	jal	80002208 <brelse>
      return iget(dev, inum);
    800026cc:	0009059b          	sext.w	a1,s2
    800026d0:	8556                	mv	a0,s5
    800026d2:	e55ff0ef          	jal	80002526 <iget>
    800026d6:	74a2                	ld	s1,40(sp)
    800026d8:	7902                	ld	s2,32(sp)
    800026da:	69e2                	ld	s3,24(sp)
    800026dc:	6a42                	ld	s4,16(sp)
    800026de:	6aa2                	ld	s5,8(sp)
    800026e0:	6b02                	ld	s6,0(sp)
    800026e2:	b7d9                	j	800026a8 <ialloc+0x80>

00000000800026e4 <iupdate>:
{
    800026e4:	1101                	addi	sp,sp,-32
    800026e6:	ec06                	sd	ra,24(sp)
    800026e8:	e822                	sd	s0,16(sp)
    800026ea:	e426                	sd	s1,8(sp)
    800026ec:	e04a                	sd	s2,0(sp)
    800026ee:	1000                	addi	s0,sp,32
    800026f0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026f2:	415c                	lw	a5,4(a0)
    800026f4:	0047d79b          	srliw	a5,a5,0x4
    800026f8:	00015597          	auipc	a1,0x15
    800026fc:	1405a583          	lw	a1,320(a1) # 80017838 <sb+0x18>
    80002700:	9dbd                	addw	a1,a1,a5
    80002702:	4108                	lw	a0,0(a0)
    80002704:	9fdff0ef          	jal	80002100 <bread>
    80002708:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000270a:	06050793          	addi	a5,a0,96
    8000270e:	40d8                	lw	a4,4(s1)
    80002710:	8b3d                	andi	a4,a4,15
    80002712:	071a                	slli	a4,a4,0x6
    80002714:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002716:	04c49703          	lh	a4,76(s1)
    8000271a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000271e:	04e49703          	lh	a4,78(s1)
    80002722:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002726:	05049703          	lh	a4,80(s1)
    8000272a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000272e:	05249703          	lh	a4,82(s1)
    80002732:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002736:	48f8                	lw	a4,84(s1)
    80002738:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000273a:	03400613          	li	a2,52
    8000273e:	05848593          	addi	a1,s1,88
    80002742:	00c78513          	addi	a0,a5,12
    80002746:	b39fd0ef          	jal	8000027e <memmove>
  log_write(bp);
    8000274a:	854a                	mv	a0,s2
    8000274c:	3ff000ef          	jal	8000334a <log_write>
  brelse(bp);
    80002750:	854a                	mv	a0,s2
    80002752:	ab7ff0ef          	jal	80002208 <brelse>
}
    80002756:	60e2                	ld	ra,24(sp)
    80002758:	6442                	ld	s0,16(sp)
    8000275a:	64a2                	ld	s1,8(sp)
    8000275c:	6902                	ld	s2,0(sp)
    8000275e:	6105                	addi	sp,sp,32
    80002760:	8082                	ret

0000000080002762 <idup>:
{
    80002762:	1101                	addi	sp,sp,-32
    80002764:	ec06                	sd	ra,24(sp)
    80002766:	e822                	sd	s0,16(sp)
    80002768:	e426                	sd	s1,8(sp)
    8000276a:	1000                	addi	s0,sp,32
    8000276c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000276e:	00015517          	auipc	a0,0x15
    80002772:	0d250513          	addi	a0,a0,210 # 80017840 <itable>
    80002776:	6a0030ef          	jal	80005e16 <acquire>
  ip->ref++;
    8000277a:	449c                	lw	a5,8(s1)
    8000277c:	2785                	addiw	a5,a5,1
    8000277e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002780:	00015517          	auipc	a0,0x15
    80002784:	0c050513          	addi	a0,a0,192 # 80017840 <itable>
    80002788:	776030ef          	jal	80005efe <release>
}
    8000278c:	8526                	mv	a0,s1
    8000278e:	60e2                	ld	ra,24(sp)
    80002790:	6442                	ld	s0,16(sp)
    80002792:	64a2                	ld	s1,8(sp)
    80002794:	6105                	addi	sp,sp,32
    80002796:	8082                	ret

0000000080002798 <ilock>:
{
    80002798:	1101                	addi	sp,sp,-32
    8000279a:	ec06                	sd	ra,24(sp)
    8000279c:	e822                	sd	s0,16(sp)
    8000279e:	e426                	sd	s1,8(sp)
    800027a0:	1000                	addi	s0,sp,32
  if(ip == 0 || atomic_read4(&ip->ref) < 1)
    800027a2:	c115                	beqz	a0,800027c6 <ilock+0x2e>
    800027a4:	84aa                	mv	s1,a0
    800027a6:	0521                	addi	a0,a0,8
    800027a8:	557030ef          	jal	800064fe <atomic_read4>
    800027ac:	00a05d63          	blez	a0,800027c6 <ilock+0x2e>
  acquiresleep(&ip->lock);
    800027b0:	01048513          	addi	a0,s1,16
    800027b4:	491000ef          	jal	80003444 <acquiresleep>
  if(ip->valid == 0){
    800027b8:	44bc                	lw	a5,72(s1)
    800027ba:	cf89                	beqz	a5,800027d4 <ilock+0x3c>
}
    800027bc:	60e2                	ld	ra,24(sp)
    800027be:	6442                	ld	s0,16(sp)
    800027c0:	64a2                	ld	s1,8(sp)
    800027c2:	6105                	addi	sp,sp,32
    800027c4:	8082                	ret
    800027c6:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800027c8:	00006517          	auipc	a0,0x6
    800027cc:	c2050513          	addi	a0,a0,-992 # 800083e8 <etext+0x3e8>
    800027d0:	31a030ef          	jal	80005aea <panic>
    800027d4:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800027d6:	40dc                	lw	a5,4(s1)
    800027d8:	0047d79b          	srliw	a5,a5,0x4
    800027dc:	00015597          	auipc	a1,0x15
    800027e0:	05c5a583          	lw	a1,92(a1) # 80017838 <sb+0x18>
    800027e4:	9dbd                	addw	a1,a1,a5
    800027e6:	4088                	lw	a0,0(s1)
    800027e8:	919ff0ef          	jal	80002100 <bread>
    800027ec:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027ee:	06050593          	addi	a1,a0,96
    800027f2:	40dc                	lw	a5,4(s1)
    800027f4:	8bbd                	andi	a5,a5,15
    800027f6:	079a                	slli	a5,a5,0x6
    800027f8:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027fa:	00059783          	lh	a5,0(a1)
    800027fe:	04f49623          	sh	a5,76(s1)
    ip->major = dip->major;
    80002802:	00259783          	lh	a5,2(a1)
    80002806:	04f49723          	sh	a5,78(s1)
    ip->minor = dip->minor;
    8000280a:	00459783          	lh	a5,4(a1)
    8000280e:	04f49823          	sh	a5,80(s1)
    ip->nlink = dip->nlink;
    80002812:	00659783          	lh	a5,6(a1)
    80002816:	04f49923          	sh	a5,82(s1)
    ip->size = dip->size;
    8000281a:	459c                	lw	a5,8(a1)
    8000281c:	c8fc                	sw	a5,84(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000281e:	03400613          	li	a2,52
    80002822:	05b1                	addi	a1,a1,12
    80002824:	05848513          	addi	a0,s1,88
    80002828:	a57fd0ef          	jal	8000027e <memmove>
    brelse(bp);
    8000282c:	854a                	mv	a0,s2
    8000282e:	9dbff0ef          	jal	80002208 <brelse>
    ip->valid = 1;
    80002832:	4785                	li	a5,1
    80002834:	c4bc                	sw	a5,72(s1)
    if(ip->type == 0)
    80002836:	04c49783          	lh	a5,76(s1)
    8000283a:	c399                	beqz	a5,80002840 <ilock+0xa8>
    8000283c:	6902                	ld	s2,0(sp)
    8000283e:	bfbd                	j	800027bc <ilock+0x24>
      panic("ilock: no type");
    80002840:	00006517          	auipc	a0,0x6
    80002844:	bb050513          	addi	a0,a0,-1104 # 800083f0 <etext+0x3f0>
    80002848:	2a2030ef          	jal	80005aea <panic>

000000008000284c <iunlock>:
{
    8000284c:	1101                	addi	sp,sp,-32
    8000284e:	ec06                	sd	ra,24(sp)
    80002850:	e822                	sd	s0,16(sp)
    80002852:	e426                	sd	s1,8(sp)
    80002854:	e04a                	sd	s2,0(sp)
    80002856:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || atomic_read4(&ip->ref) < 1)
    80002858:	c51d                	beqz	a0,80002886 <iunlock+0x3a>
    8000285a:	84aa                	mv	s1,a0
    8000285c:	01050913          	addi	s2,a0,16
    80002860:	854a                	mv	a0,s2
    80002862:	461000ef          	jal	800034c2 <holdingsleep>
    80002866:	c105                	beqz	a0,80002886 <iunlock+0x3a>
    80002868:	00848513          	addi	a0,s1,8
    8000286c:	493030ef          	jal	800064fe <atomic_read4>
    80002870:	00a05b63          	blez	a0,80002886 <iunlock+0x3a>
  releasesleep(&ip->lock);
    80002874:	854a                	mv	a0,s2
    80002876:	415000ef          	jal	8000348a <releasesleep>
}
    8000287a:	60e2                	ld	ra,24(sp)
    8000287c:	6442                	ld	s0,16(sp)
    8000287e:	64a2                	ld	s1,8(sp)
    80002880:	6902                	ld	s2,0(sp)
    80002882:	6105                	addi	sp,sp,32
    80002884:	8082                	ret
    panic("iunlock");
    80002886:	00006517          	auipc	a0,0x6
    8000288a:	b7a50513          	addi	a0,a0,-1158 # 80008400 <etext+0x400>
    8000288e:	25c030ef          	jal	80005aea <panic>

0000000080002892 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002892:	7179                	addi	sp,sp,-48
    80002894:	f406                	sd	ra,40(sp)
    80002896:	f022                	sd	s0,32(sp)
    80002898:	ec26                	sd	s1,24(sp)
    8000289a:	e84a                	sd	s2,16(sp)
    8000289c:	e44e                	sd	s3,8(sp)
    8000289e:	1800                	addi	s0,sp,48
    800028a0:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800028a2:	05850493          	addi	s1,a0,88
    800028a6:	08850913          	addi	s2,a0,136
    800028aa:	a021                	j	800028b2 <itrunc+0x20>
    800028ac:	0491                	addi	s1,s1,4
    800028ae:	01248b63          	beq	s1,s2,800028c4 <itrunc+0x32>
    if(ip->addrs[i]){
    800028b2:	408c                	lw	a1,0(s1)
    800028b4:	dde5                	beqz	a1,800028ac <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800028b6:	0009a503          	lw	a0,0(s3)
    800028ba:	a3bff0ef          	jal	800022f4 <bfree>
      ip->addrs[i] = 0;
    800028be:	0004a023          	sw	zero,0(s1)
    800028c2:	b7ed                	j	800028ac <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800028c4:	0889a583          	lw	a1,136(s3)
    800028c8:	ed89                	bnez	a1,800028e2 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }
  
  ip->size = 0;
    800028ca:	0409aa23          	sw	zero,84(s3)
  iupdate(ip);
    800028ce:	854e                	mv	a0,s3
    800028d0:	e15ff0ef          	jal	800026e4 <iupdate>
}
    800028d4:	70a2                	ld	ra,40(sp)
    800028d6:	7402                	ld	s0,32(sp)
    800028d8:	64e2                	ld	s1,24(sp)
    800028da:	6942                	ld	s2,16(sp)
    800028dc:	69a2                	ld	s3,8(sp)
    800028de:	6145                	addi	sp,sp,48
    800028e0:	8082                	ret
    800028e2:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800028e4:	0009a503          	lw	a0,0(s3)
    800028e8:	819ff0ef          	jal	80002100 <bread>
    800028ec:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028ee:	06050493          	addi	s1,a0,96
    800028f2:	46050913          	addi	s2,a0,1120
    800028f6:	a021                	j	800028fe <itrunc+0x6c>
    800028f8:	0491                	addi	s1,s1,4
    800028fa:	01248963          	beq	s1,s2,8000290c <itrunc+0x7a>
      if(a[j])
    800028fe:	408c                	lw	a1,0(s1)
    80002900:	dde5                	beqz	a1,800028f8 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002902:	0009a503          	lw	a0,0(s3)
    80002906:	9efff0ef          	jal	800022f4 <bfree>
    8000290a:	b7fd                	j	800028f8 <itrunc+0x66>
    brelse(bp);
    8000290c:	8552                	mv	a0,s4
    8000290e:	8fbff0ef          	jal	80002208 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002912:	0889a583          	lw	a1,136(s3)
    80002916:	0009a503          	lw	a0,0(s3)
    8000291a:	9dbff0ef          	jal	800022f4 <bfree>
    ip->addrs[NDIRECT] = 0;
    8000291e:	0809a423          	sw	zero,136(s3)
    80002922:	6a02                	ld	s4,0(sp)
    80002924:	b75d                	j	800028ca <itrunc+0x38>

0000000080002926 <iput>:
{
    80002926:	1101                	addi	sp,sp,-32
    80002928:	ec06                	sd	ra,24(sp)
    8000292a:	e822                	sd	s0,16(sp)
    8000292c:	e426                	sd	s1,8(sp)
    8000292e:	1000                	addi	s0,sp,32
    80002930:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002932:	00015517          	auipc	a0,0x15
    80002936:	f0e50513          	addi	a0,a0,-242 # 80017840 <itable>
    8000293a:	4dc030ef          	jal	80005e16 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000293e:	4498                	lw	a4,8(s1)
    80002940:	4785                	li	a5,1
    80002942:	02f70063          	beq	a4,a5,80002962 <iput+0x3c>
  ip->ref--;
    80002946:	449c                	lw	a5,8(s1)
    80002948:	37fd                	addiw	a5,a5,-1
    8000294a:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    8000294c:	00015517          	auipc	a0,0x15
    80002950:	ef450513          	addi	a0,a0,-268 # 80017840 <itable>
    80002954:	5aa030ef          	jal	80005efe <release>
}
    80002958:	60e2                	ld	ra,24(sp)
    8000295a:	6442                	ld	s0,16(sp)
    8000295c:	64a2                	ld	s1,8(sp)
    8000295e:	6105                	addi	sp,sp,32
    80002960:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002962:	44bc                	lw	a5,72(s1)
    80002964:	d3ed                	beqz	a5,80002946 <iput+0x20>
    80002966:	05249783          	lh	a5,82(s1)
    8000296a:	fff1                	bnez	a5,80002946 <iput+0x20>
    8000296c:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000296e:	01048793          	addi	a5,s1,16
    80002972:	893e                	mv	s2,a5
    80002974:	853e                	mv	a0,a5
    80002976:	2cf000ef          	jal	80003444 <acquiresleep>
    release(&itable.lock);
    8000297a:	00015517          	auipc	a0,0x15
    8000297e:	ec650513          	addi	a0,a0,-314 # 80017840 <itable>
    80002982:	57c030ef          	jal	80005efe <release>
    itrunc(ip);
    80002986:	8526                	mv	a0,s1
    80002988:	f0bff0ef          	jal	80002892 <itrunc>
    ip->type = 0;
    8000298c:	04049623          	sh	zero,76(s1)
    iupdate(ip);
    80002990:	8526                	mv	a0,s1
    80002992:	d53ff0ef          	jal	800026e4 <iupdate>
    ip->valid = 0;
    80002996:	0404a423          	sw	zero,72(s1)
    releasesleep(&ip->lock);
    8000299a:	854a                	mv	a0,s2
    8000299c:	2ef000ef          	jal	8000348a <releasesleep>
    acquire(&itable.lock);
    800029a0:	00015517          	auipc	a0,0x15
    800029a4:	ea050513          	addi	a0,a0,-352 # 80017840 <itable>
    800029a8:	46e030ef          	jal	80005e16 <acquire>
    800029ac:	6902                	ld	s2,0(sp)
    800029ae:	bf61                	j	80002946 <iput+0x20>

00000000800029b0 <iunlockput>:
{
    800029b0:	1101                	addi	sp,sp,-32
    800029b2:	ec06                	sd	ra,24(sp)
    800029b4:	e822                	sd	s0,16(sp)
    800029b6:	e426                	sd	s1,8(sp)
    800029b8:	1000                	addi	s0,sp,32
    800029ba:	84aa                	mv	s1,a0
  iunlock(ip);
    800029bc:	e91ff0ef          	jal	8000284c <iunlock>
  iput(ip);
    800029c0:	8526                	mv	a0,s1
    800029c2:	f65ff0ef          	jal	80002926 <iput>
}
    800029c6:	60e2                	ld	ra,24(sp)
    800029c8:	6442                	ld	s0,16(sp)
    800029ca:	64a2                	ld	s1,8(sp)
    800029cc:	6105                	addi	sp,sp,32
    800029ce:	8082                	ret

00000000800029d0 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029d0:	00015717          	auipc	a4,0x15
    800029d4:	e5c72703          	lw	a4,-420(a4) # 8001782c <sb+0xc>
    800029d8:	4785                	li	a5,1
    800029da:	0ae7fe63          	bgeu	a5,a4,80002a96 <ireclaim+0xc6>
{
    800029de:	7139                	addi	sp,sp,-64
    800029e0:	fc06                	sd	ra,56(sp)
    800029e2:	f822                	sd	s0,48(sp)
    800029e4:	f426                	sd	s1,40(sp)
    800029e6:	f04a                	sd	s2,32(sp)
    800029e8:	ec4e                	sd	s3,24(sp)
    800029ea:	e852                	sd	s4,16(sp)
    800029ec:	e456                	sd	s5,8(sp)
    800029ee:	e05a                	sd	s6,0(sp)
    800029f0:	0080                	addi	s0,sp,64
    800029f2:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029f4:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800029f6:	00015a17          	auipc	s4,0x15
    800029fa:	e2aa0a13          	addi	s4,s4,-470 # 80017820 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800029fe:	00006b17          	auipc	s6,0x6
    80002a02:	a0ab0b13          	addi	s6,s6,-1526 # 80008408 <etext+0x408>
    80002a06:	a099                	j	80002a4c <ireclaim+0x7c>
    80002a08:	85ce                	mv	a1,s3
    80002a0a:	855a                	mv	a0,s6
    80002a0c:	5b5020ef          	jal	800057c0 <printf>
      ip = iget(dev, inum);
    80002a10:	85ce                	mv	a1,s3
    80002a12:	8556                	mv	a0,s5
    80002a14:	b13ff0ef          	jal	80002526 <iget>
    80002a18:	89aa                	mv	s3,a0
    brelse(bp);
    80002a1a:	854a                	mv	a0,s2
    80002a1c:	fecff0ef          	jal	80002208 <brelse>
    if (ip) {
    80002a20:	00098f63          	beqz	s3,80002a3e <ireclaim+0x6e>
      begin_op();
    80002a24:	78c000ef          	jal	800031b0 <begin_op>
      ilock(ip);
    80002a28:	854e                	mv	a0,s3
    80002a2a:	d6fff0ef          	jal	80002798 <ilock>
      iunlock(ip);
    80002a2e:	854e                	mv	a0,s3
    80002a30:	e1dff0ef          	jal	8000284c <iunlock>
      iput(ip);
    80002a34:	854e                	mv	a0,s3
    80002a36:	ef1ff0ef          	jal	80002926 <iput>
      end_op();
    80002a3a:	7e6000ef          	jal	80003220 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002a3e:	0485                	addi	s1,s1,1
    80002a40:	00ca2703          	lw	a4,12(s4)
    80002a44:	0004879b          	sext.w	a5,s1
    80002a48:	02e7fd63          	bgeu	a5,a4,80002a82 <ireclaim+0xb2>
    80002a4c:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002a50:	0044d593          	srli	a1,s1,0x4
    80002a54:	018a2783          	lw	a5,24(s4)
    80002a58:	9dbd                	addw	a1,a1,a5
    80002a5a:	8556                	mv	a0,s5
    80002a5c:	ea4ff0ef          	jal	80002100 <bread>
    80002a60:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002a62:	06050793          	addi	a5,a0,96
    80002a66:	00f9f713          	andi	a4,s3,15
    80002a6a:	071a                	slli	a4,a4,0x6
    80002a6c:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002a6e:	00079703          	lh	a4,0(a5)
    80002a72:	c701                	beqz	a4,80002a7a <ireclaim+0xaa>
    80002a74:	00679783          	lh	a5,6(a5)
    80002a78:	dbc1                	beqz	a5,80002a08 <ireclaim+0x38>
    brelse(bp);
    80002a7a:	854a                	mv	a0,s2
    80002a7c:	f8cff0ef          	jal	80002208 <brelse>
    if (ip) {
    80002a80:	bf7d                	j	80002a3e <ireclaim+0x6e>
}
    80002a82:	70e2                	ld	ra,56(sp)
    80002a84:	7442                	ld	s0,48(sp)
    80002a86:	74a2                	ld	s1,40(sp)
    80002a88:	7902                	ld	s2,32(sp)
    80002a8a:	69e2                	ld	s3,24(sp)
    80002a8c:	6a42                	ld	s4,16(sp)
    80002a8e:	6aa2                	ld	s5,8(sp)
    80002a90:	6b02                	ld	s6,0(sp)
    80002a92:	6121                	addi	sp,sp,64
    80002a94:	8082                	ret
    80002a96:	8082                	ret

0000000080002a98 <fsinit>:
fsinit(int dev) {
    80002a98:	1101                	addi	sp,sp,-32
    80002a9a:	ec06                	sd	ra,24(sp)
    80002a9c:	e822                	sd	s0,16(sp)
    80002a9e:	e426                	sd	s1,8(sp)
    80002aa0:	e04a                	sd	s2,0(sp)
    80002aa2:	1000                	addi	s0,sp,32
    80002aa4:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002aa6:	4585                	li	a1,1
    80002aa8:	e58ff0ef          	jal	80002100 <bread>
    80002aac:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aae:	02000613          	li	a2,32
    80002ab2:	06050593          	addi	a1,a0,96
    80002ab6:	00015517          	auipc	a0,0x15
    80002aba:	d6a50513          	addi	a0,a0,-662 # 80017820 <sb>
    80002abe:	fc0fd0ef          	jal	8000027e <memmove>
  brelse(bp);
    80002ac2:	8526                	mv	a0,s1
    80002ac4:	f44ff0ef          	jal	80002208 <brelse>
  if(sb.magic != FSMAGIC)
    80002ac8:	00015717          	auipc	a4,0x15
    80002acc:	d5872703          	lw	a4,-680(a4) # 80017820 <sb>
    80002ad0:	102037b7          	lui	a5,0x10203
    80002ad4:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ad8:	02f71263          	bne	a4,a5,80002afc <fsinit+0x64>
  initlog(dev, &sb);
    80002adc:	00015597          	auipc	a1,0x15
    80002ae0:	d4458593          	addi	a1,a1,-700 # 80017820 <sb>
    80002ae4:	854a                	mv	a0,s2
    80002ae6:	648000ef          	jal	8000312e <initlog>
  ireclaim(dev);
    80002aea:	854a                	mv	a0,s2
    80002aec:	ee5ff0ef          	jal	800029d0 <ireclaim>
}
    80002af0:	60e2                	ld	ra,24(sp)
    80002af2:	6442                	ld	s0,16(sp)
    80002af4:	64a2                	ld	s1,8(sp)
    80002af6:	6902                	ld	s2,0(sp)
    80002af8:	6105                	addi	sp,sp,32
    80002afa:	8082                	ret
    panic("invalid file system");
    80002afc:	00006517          	auipc	a0,0x6
    80002b00:	92c50513          	addi	a0,a0,-1748 # 80008428 <etext+0x428>
    80002b04:	7e7020ef          	jal	80005aea <panic>

0000000080002b08 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002b08:	1141                	addi	sp,sp,-16
    80002b0a:	e406                	sd	ra,8(sp)
    80002b0c:	e022                	sd	s0,0(sp)
    80002b0e:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002b10:	411c                	lw	a5,0(a0)
    80002b12:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002b14:	415c                	lw	a5,4(a0)
    80002b16:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002b18:	04c51783          	lh	a5,76(a0)
    80002b1c:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002b20:	05251783          	lh	a5,82(a0)
    80002b24:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002b28:	05456783          	lwu	a5,84(a0)
    80002b2c:	e99c                	sd	a5,16(a1)
}
    80002b2e:	60a2                	ld	ra,8(sp)
    80002b30:	6402                	ld	s0,0(sp)
    80002b32:	0141                	addi	sp,sp,16
    80002b34:	8082                	ret

0000000080002b36 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b36:	497c                	lw	a5,84(a0)
    80002b38:	0ed7e663          	bltu	a5,a3,80002c24 <readi+0xee>
{
    80002b3c:	7159                	addi	sp,sp,-112
    80002b3e:	f486                	sd	ra,104(sp)
    80002b40:	f0a2                	sd	s0,96(sp)
    80002b42:	eca6                	sd	s1,88(sp)
    80002b44:	e0d2                	sd	s4,64(sp)
    80002b46:	fc56                	sd	s5,56(sp)
    80002b48:	f85a                	sd	s6,48(sp)
    80002b4a:	f45e                	sd	s7,40(sp)
    80002b4c:	1880                	addi	s0,sp,112
    80002b4e:	8b2a                	mv	s6,a0
    80002b50:	8bae                	mv	s7,a1
    80002b52:	8a32                	mv	s4,a2
    80002b54:	84b6                	mv	s1,a3
    80002b56:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002b58:	9f35                	addw	a4,a4,a3
    return 0;
    80002b5a:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002b5c:	0ad76b63          	bltu	a4,a3,80002c12 <readi+0xdc>
    80002b60:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002b62:	00e7f463          	bgeu	a5,a4,80002b6a <readi+0x34>
    n = ip->size - off;
    80002b66:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b6a:	080a8b63          	beqz	s5,80002c00 <readi+0xca>
    80002b6e:	e8ca                	sd	s2,80(sp)
    80002b70:	f062                	sd	s8,32(sp)
    80002b72:	ec66                	sd	s9,24(sp)
    80002b74:	e86a                	sd	s10,16(sp)
    80002b76:	e46e                	sd	s11,8(sp)
    80002b78:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b7a:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002b7e:	5c7d                	li	s8,-1
    80002b80:	a80d                	j	80002bb2 <readi+0x7c>
    80002b82:	020d1d93          	slli	s11,s10,0x20
    80002b86:	020ddd93          	srli	s11,s11,0x20
    80002b8a:	06090613          	addi	a2,s2,96
    80002b8e:	86ee                	mv	a3,s11
    80002b90:	963e                	add	a2,a2,a5
    80002b92:	85d2                	mv	a1,s4
    80002b94:	855e                	mv	a0,s7
    80002b96:	c3ffe0ef          	jal	800017d4 <either_copyout>
    80002b9a:	05850363          	beq	a0,s8,80002be0 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002b9e:	854a                	mv	a0,s2
    80002ba0:	e68ff0ef          	jal	80002208 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ba4:	013d09bb          	addw	s3,s10,s3
    80002ba8:	009d04bb          	addw	s1,s10,s1
    80002bac:	9a6e                	add	s4,s4,s11
    80002bae:	0559f363          	bgeu	s3,s5,80002bf4 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002bb2:	00a4d59b          	srliw	a1,s1,0xa
    80002bb6:	855a                	mv	a0,s6
    80002bb8:	8afff0ef          	jal	80002466 <bmap>
    80002bbc:	85aa                	mv	a1,a0
    if(addr == 0)
    80002bbe:	c139                	beqz	a0,80002c04 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002bc0:	000b2503          	lw	a0,0(s6)
    80002bc4:	d3cff0ef          	jal	80002100 <bread>
    80002bc8:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bca:	3ff4f793          	andi	a5,s1,1023
    80002bce:	40fc873b          	subw	a4,s9,a5
    80002bd2:	413a86bb          	subw	a3,s5,s3
    80002bd6:	8d3a                	mv	s10,a4
    80002bd8:	fae6f5e3          	bgeu	a3,a4,80002b82 <readi+0x4c>
    80002bdc:	8d36                	mv	s10,a3
    80002bde:	b755                	j	80002b82 <readi+0x4c>
      brelse(bp);
    80002be0:	854a                	mv	a0,s2
    80002be2:	e26ff0ef          	jal	80002208 <brelse>
      tot = -1;
    80002be6:	59fd                	li	s3,-1
      break;
    80002be8:	6946                	ld	s2,80(sp)
    80002bea:	7c02                	ld	s8,32(sp)
    80002bec:	6ce2                	ld	s9,24(sp)
    80002bee:	6d42                	ld	s10,16(sp)
    80002bf0:	6da2                	ld	s11,8(sp)
    80002bf2:	a831                	j	80002c0e <readi+0xd8>
    80002bf4:	6946                	ld	s2,80(sp)
    80002bf6:	7c02                	ld	s8,32(sp)
    80002bf8:	6ce2                	ld	s9,24(sp)
    80002bfa:	6d42                	ld	s10,16(sp)
    80002bfc:	6da2                	ld	s11,8(sp)
    80002bfe:	a801                	j	80002c0e <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002c00:	89d6                	mv	s3,s5
    80002c02:	a031                	j	80002c0e <readi+0xd8>
    80002c04:	6946                	ld	s2,80(sp)
    80002c06:	7c02                	ld	s8,32(sp)
    80002c08:	6ce2                	ld	s9,24(sp)
    80002c0a:	6d42                	ld	s10,16(sp)
    80002c0c:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002c0e:	854e                	mv	a0,s3
    80002c10:	69a6                	ld	s3,72(sp)
}
    80002c12:	70a6                	ld	ra,104(sp)
    80002c14:	7406                	ld	s0,96(sp)
    80002c16:	64e6                	ld	s1,88(sp)
    80002c18:	6a06                	ld	s4,64(sp)
    80002c1a:	7ae2                	ld	s5,56(sp)
    80002c1c:	7b42                	ld	s6,48(sp)
    80002c1e:	7ba2                	ld	s7,40(sp)
    80002c20:	6165                	addi	sp,sp,112
    80002c22:	8082                	ret
    return 0;
    80002c24:	4501                	li	a0,0
}
    80002c26:	8082                	ret

0000000080002c28 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c28:	497c                	lw	a5,84(a0)
    80002c2a:	0ed7eb63          	bltu	a5,a3,80002d20 <writei+0xf8>
{
    80002c2e:	7159                	addi	sp,sp,-112
    80002c30:	f486                	sd	ra,104(sp)
    80002c32:	f0a2                	sd	s0,96(sp)
    80002c34:	e8ca                	sd	s2,80(sp)
    80002c36:	e0d2                	sd	s4,64(sp)
    80002c38:	fc56                	sd	s5,56(sp)
    80002c3a:	f85a                	sd	s6,48(sp)
    80002c3c:	f45e                	sd	s7,40(sp)
    80002c3e:	1880                	addi	s0,sp,112
    80002c40:	8aaa                	mv	s5,a0
    80002c42:	8bae                	mv	s7,a1
    80002c44:	8a32                	mv	s4,a2
    80002c46:	8936                	mv	s2,a3
    80002c48:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002c4a:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002c4e:	00043737          	lui	a4,0x43
    80002c52:	0cf76963          	bltu	a4,a5,80002d24 <writei+0xfc>
    80002c56:	0cd7e763          	bltu	a5,a3,80002d24 <writei+0xfc>
    80002c5a:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c5c:	0a0b0a63          	beqz	s6,80002d10 <writei+0xe8>
    80002c60:	eca6                	sd	s1,88(sp)
    80002c62:	f062                	sd	s8,32(sp)
    80002c64:	ec66                	sd	s9,24(sp)
    80002c66:	e86a                	sd	s10,16(sp)
    80002c68:	e46e                	sd	s11,8(sp)
    80002c6a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c6c:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002c70:	5c7d                	li	s8,-1
    80002c72:	a825                	j	80002caa <writei+0x82>
    80002c74:	020d1d93          	slli	s11,s10,0x20
    80002c78:	020ddd93          	srli	s11,s11,0x20
    80002c7c:	06048513          	addi	a0,s1,96
    80002c80:	86ee                	mv	a3,s11
    80002c82:	8652                	mv	a2,s4
    80002c84:	85de                	mv	a1,s7
    80002c86:	953e                	add	a0,a0,a5
    80002c88:	b97fe0ef          	jal	8000181e <either_copyin>
    80002c8c:	05850663          	beq	a0,s8,80002cd8 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002c90:	8526                	mv	a0,s1
    80002c92:	6b8000ef          	jal	8000334a <log_write>
    brelse(bp);
    80002c96:	8526                	mv	a0,s1
    80002c98:	d70ff0ef          	jal	80002208 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c9c:	013d09bb          	addw	s3,s10,s3
    80002ca0:	012d093b          	addw	s2,s10,s2
    80002ca4:	9a6e                	add	s4,s4,s11
    80002ca6:	0369fc63          	bgeu	s3,s6,80002cde <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002caa:	00a9559b          	srliw	a1,s2,0xa
    80002cae:	8556                	mv	a0,s5
    80002cb0:	fb6ff0ef          	jal	80002466 <bmap>
    80002cb4:	85aa                	mv	a1,a0
    if(addr == 0)
    80002cb6:	c505                	beqz	a0,80002cde <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002cb8:	000aa503          	lw	a0,0(s5)
    80002cbc:	c44ff0ef          	jal	80002100 <bread>
    80002cc0:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cc2:	3ff97793          	andi	a5,s2,1023
    80002cc6:	40fc873b          	subw	a4,s9,a5
    80002cca:	413b06bb          	subw	a3,s6,s3
    80002cce:	8d3a                	mv	s10,a4
    80002cd0:	fae6f2e3          	bgeu	a3,a4,80002c74 <writei+0x4c>
    80002cd4:	8d36                	mv	s10,a3
    80002cd6:	bf79                	j	80002c74 <writei+0x4c>
      brelse(bp);
    80002cd8:	8526                	mv	a0,s1
    80002cda:	d2eff0ef          	jal	80002208 <brelse>
  }

  if(off > ip->size)
    80002cde:	054aa783          	lw	a5,84(s5)
    80002ce2:	0327f963          	bgeu	a5,s2,80002d14 <writei+0xec>
    ip->size = off;
    80002ce6:	052aaa23          	sw	s2,84(s5)
    80002cea:	64e6                	ld	s1,88(sp)
    80002cec:	7c02                	ld	s8,32(sp)
    80002cee:	6ce2                	ld	s9,24(sp)
    80002cf0:	6d42                	ld	s10,16(sp)
    80002cf2:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002cf4:	8556                	mv	a0,s5
    80002cf6:	9efff0ef          	jal	800026e4 <iupdate>

  return tot;
    80002cfa:	854e                	mv	a0,s3
    80002cfc:	69a6                	ld	s3,72(sp)
}
    80002cfe:	70a6                	ld	ra,104(sp)
    80002d00:	7406                	ld	s0,96(sp)
    80002d02:	6946                	ld	s2,80(sp)
    80002d04:	6a06                	ld	s4,64(sp)
    80002d06:	7ae2                	ld	s5,56(sp)
    80002d08:	7b42                	ld	s6,48(sp)
    80002d0a:	7ba2                	ld	s7,40(sp)
    80002d0c:	6165                	addi	sp,sp,112
    80002d0e:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d10:	89da                	mv	s3,s6
    80002d12:	b7cd                	j	80002cf4 <writei+0xcc>
    80002d14:	64e6                	ld	s1,88(sp)
    80002d16:	7c02                	ld	s8,32(sp)
    80002d18:	6ce2                	ld	s9,24(sp)
    80002d1a:	6d42                	ld	s10,16(sp)
    80002d1c:	6da2                	ld	s11,8(sp)
    80002d1e:	bfd9                	j	80002cf4 <writei+0xcc>
    return -1;
    80002d20:	557d                	li	a0,-1
}
    80002d22:	8082                	ret
    return -1;
    80002d24:	557d                	li	a0,-1
    80002d26:	bfe1                	j	80002cfe <writei+0xd6>

0000000080002d28 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002d28:	1141                	addi	sp,sp,-16
    80002d2a:	e406                	sd	ra,8(sp)
    80002d2c:	e022                	sd	s0,0(sp)
    80002d2e:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002d30:	4639                	li	a2,14
    80002d32:	dc0fd0ef          	jal	800002f2 <strncmp>
}
    80002d36:	60a2                	ld	ra,8(sp)
    80002d38:	6402                	ld	s0,0(sp)
    80002d3a:	0141                	addi	sp,sp,16
    80002d3c:	8082                	ret

0000000080002d3e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002d3e:	711d                	addi	sp,sp,-96
    80002d40:	ec86                	sd	ra,88(sp)
    80002d42:	e8a2                	sd	s0,80(sp)
    80002d44:	e4a6                	sd	s1,72(sp)
    80002d46:	e0ca                	sd	s2,64(sp)
    80002d48:	fc4e                	sd	s3,56(sp)
    80002d4a:	f852                	sd	s4,48(sp)
    80002d4c:	f456                	sd	s5,40(sp)
    80002d4e:	f05a                	sd	s6,32(sp)
    80002d50:	ec5e                	sd	s7,24(sp)
    80002d52:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002d54:	04c51703          	lh	a4,76(a0)
    80002d58:	4785                	li	a5,1
    80002d5a:	00f71f63          	bne	a4,a5,80002d78 <dirlookup+0x3a>
    80002d5e:	892a                	mv	s2,a0
    80002d60:	8aae                	mv	s5,a1
    80002d62:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d64:	497c                	lw	a5,84(a0)
    80002d66:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d68:	fa040a13          	addi	s4,s0,-96
    80002d6c:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002d6e:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002d72:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d74:	e39d                	bnez	a5,80002d9a <dirlookup+0x5c>
    80002d76:	a8b9                	j	80002dd4 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002d78:	00005517          	auipc	a0,0x5
    80002d7c:	6c850513          	addi	a0,a0,1736 # 80008440 <etext+0x440>
    80002d80:	56b020ef          	jal	80005aea <panic>
      panic("dirlookup read");
    80002d84:	00005517          	auipc	a0,0x5
    80002d88:	6d450513          	addi	a0,a0,1748 # 80008458 <etext+0x458>
    80002d8c:	55f020ef          	jal	80005aea <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d90:	24c1                	addiw	s1,s1,16
    80002d92:	05492783          	lw	a5,84(s2)
    80002d96:	02f4fe63          	bgeu	s1,a5,80002dd2 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d9a:	874e                	mv	a4,s3
    80002d9c:	86a6                	mv	a3,s1
    80002d9e:	8652                	mv	a2,s4
    80002da0:	4581                	li	a1,0
    80002da2:	854a                	mv	a0,s2
    80002da4:	d93ff0ef          	jal	80002b36 <readi>
    80002da8:	fd351ee3          	bne	a0,s3,80002d84 <dirlookup+0x46>
    if(de.inum == 0)
    80002dac:	fa045783          	lhu	a5,-96(s0)
    80002db0:	d3e5                	beqz	a5,80002d90 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002db2:	85da                	mv	a1,s6
    80002db4:	8556                	mv	a0,s5
    80002db6:	f73ff0ef          	jal	80002d28 <namecmp>
    80002dba:	f979                	bnez	a0,80002d90 <dirlookup+0x52>
      if(poff)
    80002dbc:	000b8463          	beqz	s7,80002dc4 <dirlookup+0x86>
        *poff = off;
    80002dc0:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002dc4:	fa045583          	lhu	a1,-96(s0)
    80002dc8:	00092503          	lw	a0,0(s2)
    80002dcc:	f5aff0ef          	jal	80002526 <iget>
    80002dd0:	a011                	j	80002dd4 <dirlookup+0x96>
  return 0;
    80002dd2:	4501                	li	a0,0
}
    80002dd4:	60e6                	ld	ra,88(sp)
    80002dd6:	6446                	ld	s0,80(sp)
    80002dd8:	64a6                	ld	s1,72(sp)
    80002dda:	6906                	ld	s2,64(sp)
    80002ddc:	79e2                	ld	s3,56(sp)
    80002dde:	7a42                	ld	s4,48(sp)
    80002de0:	7aa2                	ld	s5,40(sp)
    80002de2:	7b02                	ld	s6,32(sp)
    80002de4:	6be2                	ld	s7,24(sp)
    80002de6:	6125                	addi	sp,sp,96
    80002de8:	8082                	ret

0000000080002dea <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002dea:	711d                	addi	sp,sp,-96
    80002dec:	ec86                	sd	ra,88(sp)
    80002dee:	e8a2                	sd	s0,80(sp)
    80002df0:	e4a6                	sd	s1,72(sp)
    80002df2:	e0ca                	sd	s2,64(sp)
    80002df4:	fc4e                	sd	s3,56(sp)
    80002df6:	f852                	sd	s4,48(sp)
    80002df8:	f456                	sd	s5,40(sp)
    80002dfa:	f05a                	sd	s6,32(sp)
    80002dfc:	ec5e                	sd	s7,24(sp)
    80002dfe:	e862                	sd	s8,16(sp)
    80002e00:	e466                	sd	s9,8(sp)
    80002e02:	e06a                	sd	s10,0(sp)
    80002e04:	1080                	addi	s0,sp,96
    80002e06:	84aa                	mv	s1,a0
    80002e08:	8b2e                	mv	s6,a1
    80002e0a:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002e0c:	00054703          	lbu	a4,0(a0)
    80002e10:	02f00793          	li	a5,47
    80002e14:	00f70f63          	beq	a4,a5,80002e32 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002e18:	838fe0ef          	jal	80000e50 <myproc>
    80002e1c:	15853503          	ld	a0,344(a0)
    80002e20:	943ff0ef          	jal	80002762 <idup>
    80002e24:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002e26:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002e2a:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002e2c:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002e2e:	4b85                	li	s7,1
    80002e30:	a879                	j	80002ece <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002e32:	4585                	li	a1,1
    80002e34:	852e                	mv	a0,a1
    80002e36:	ef0ff0ef          	jal	80002526 <iget>
    80002e3a:	8a2a                	mv	s4,a0
    80002e3c:	b7ed                	j	80002e26 <namex+0x3c>
      iunlockput(ip);
    80002e3e:	8552                	mv	a0,s4
    80002e40:	b71ff0ef          	jal	800029b0 <iunlockput>
      return 0;
    80002e44:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002e46:	8552                	mv	a0,s4
    80002e48:	60e6                	ld	ra,88(sp)
    80002e4a:	6446                	ld	s0,80(sp)
    80002e4c:	64a6                	ld	s1,72(sp)
    80002e4e:	6906                	ld	s2,64(sp)
    80002e50:	79e2                	ld	s3,56(sp)
    80002e52:	7a42                	ld	s4,48(sp)
    80002e54:	7aa2                	ld	s5,40(sp)
    80002e56:	7b02                	ld	s6,32(sp)
    80002e58:	6be2                	ld	s7,24(sp)
    80002e5a:	6c42                	ld	s8,16(sp)
    80002e5c:	6ca2                	ld	s9,8(sp)
    80002e5e:	6d02                	ld	s10,0(sp)
    80002e60:	6125                	addi	sp,sp,96
    80002e62:	8082                	ret
      iunlock(ip);
    80002e64:	8552                	mv	a0,s4
    80002e66:	9e7ff0ef          	jal	8000284c <iunlock>
      return ip;
    80002e6a:	bff1                	j	80002e46 <namex+0x5c>
      iunlockput(ip);
    80002e6c:	8552                	mv	a0,s4
    80002e6e:	b43ff0ef          	jal	800029b0 <iunlockput>
      return 0;
    80002e72:	8a4a                	mv	s4,s2
    80002e74:	bfc9                	j	80002e46 <namex+0x5c>
  len = path - s;
    80002e76:	40990633          	sub	a2,s2,s1
    80002e7a:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002e7e:	09ac5463          	bge	s8,s10,80002f06 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002e82:	8666                	mv	a2,s9
    80002e84:	85a6                	mv	a1,s1
    80002e86:	8556                	mv	a0,s5
    80002e88:	bf6fd0ef          	jal	8000027e <memmove>
    80002e8c:	84ca                	mv	s1,s2
  while(*path == '/')
    80002e8e:	0004c783          	lbu	a5,0(s1)
    80002e92:	01379763          	bne	a5,s3,80002ea0 <namex+0xb6>
    path++;
    80002e96:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e98:	0004c783          	lbu	a5,0(s1)
    80002e9c:	ff378de3          	beq	a5,s3,80002e96 <namex+0xac>
    ilock(ip);
    80002ea0:	8552                	mv	a0,s4
    80002ea2:	8f7ff0ef          	jal	80002798 <ilock>
    if(ip->type != T_DIR){
    80002ea6:	04ca1783          	lh	a5,76(s4)
    80002eaa:	f9779ae3          	bne	a5,s7,80002e3e <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002eae:	000b0563          	beqz	s6,80002eb8 <namex+0xce>
    80002eb2:	0004c783          	lbu	a5,0(s1)
    80002eb6:	d7dd                	beqz	a5,80002e64 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002eb8:	4601                	li	a2,0
    80002eba:	85d6                	mv	a1,s5
    80002ebc:	8552                	mv	a0,s4
    80002ebe:	e81ff0ef          	jal	80002d3e <dirlookup>
    80002ec2:	892a                	mv	s2,a0
    80002ec4:	d545                	beqz	a0,80002e6c <namex+0x82>
    iunlockput(ip);
    80002ec6:	8552                	mv	a0,s4
    80002ec8:	ae9ff0ef          	jal	800029b0 <iunlockput>
    ip = next;
    80002ecc:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002ece:	0004c783          	lbu	a5,0(s1)
    80002ed2:	01379763          	bne	a5,s3,80002ee0 <namex+0xf6>
    path++;
    80002ed6:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ed8:	0004c783          	lbu	a5,0(s1)
    80002edc:	ff378de3          	beq	a5,s3,80002ed6 <namex+0xec>
  if(*path == 0)
    80002ee0:	cf8d                	beqz	a5,80002f1a <namex+0x130>
  while(*path != '/' && *path != 0)
    80002ee2:	0004c783          	lbu	a5,0(s1)
    80002ee6:	fd178713          	addi	a4,a5,-47
    80002eea:	cb19                	beqz	a4,80002f00 <namex+0x116>
    80002eec:	cb91                	beqz	a5,80002f00 <namex+0x116>
    80002eee:	8926                	mv	s2,s1
    path++;
    80002ef0:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002ef2:	00094783          	lbu	a5,0(s2)
    80002ef6:	fd178713          	addi	a4,a5,-47
    80002efa:	df35                	beqz	a4,80002e76 <namex+0x8c>
    80002efc:	fbf5                	bnez	a5,80002ef0 <namex+0x106>
    80002efe:	bfa5                	j	80002e76 <namex+0x8c>
    80002f00:	8926                	mv	s2,s1
  len = path - s;
    80002f02:	4d01                	li	s10,0
    80002f04:	4601                	li	a2,0
    memmove(name, s, len);
    80002f06:	2601                	sext.w	a2,a2
    80002f08:	85a6                	mv	a1,s1
    80002f0a:	8556                	mv	a0,s5
    80002f0c:	b72fd0ef          	jal	8000027e <memmove>
    name[len] = 0;
    80002f10:	9d56                	add	s10,s10,s5
    80002f12:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffda740>
    80002f16:	84ca                	mv	s1,s2
    80002f18:	bf9d                	j	80002e8e <namex+0xa4>
  if(nameiparent){
    80002f1a:	f20b06e3          	beqz	s6,80002e46 <namex+0x5c>
    iput(ip);
    80002f1e:	8552                	mv	a0,s4
    80002f20:	a07ff0ef          	jal	80002926 <iput>
    return 0;
    80002f24:	4a01                	li	s4,0
    80002f26:	b705                	j	80002e46 <namex+0x5c>

0000000080002f28 <dirlink>:
{
    80002f28:	715d                	addi	sp,sp,-80
    80002f2a:	e486                	sd	ra,72(sp)
    80002f2c:	e0a2                	sd	s0,64(sp)
    80002f2e:	f84a                	sd	s2,48(sp)
    80002f30:	ec56                	sd	s5,24(sp)
    80002f32:	e85a                	sd	s6,16(sp)
    80002f34:	0880                	addi	s0,sp,80
    80002f36:	892a                	mv	s2,a0
    80002f38:	8aae                	mv	s5,a1
    80002f3a:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002f3c:	4601                	li	a2,0
    80002f3e:	e01ff0ef          	jal	80002d3e <dirlookup>
    80002f42:	ed1d                	bnez	a0,80002f80 <dirlink+0x58>
    80002f44:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f46:	05492483          	lw	s1,84(s2)
    80002f4a:	c4b9                	beqz	s1,80002f98 <dirlink+0x70>
    80002f4c:	f44e                	sd	s3,40(sp)
    80002f4e:	f052                	sd	s4,32(sp)
    80002f50:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f52:	fb040a13          	addi	s4,s0,-80
    80002f56:	49c1                	li	s3,16
    80002f58:	874e                	mv	a4,s3
    80002f5a:	86a6                	mv	a3,s1
    80002f5c:	8652                	mv	a2,s4
    80002f5e:	4581                	li	a1,0
    80002f60:	854a                	mv	a0,s2
    80002f62:	bd5ff0ef          	jal	80002b36 <readi>
    80002f66:	03351163          	bne	a0,s3,80002f88 <dirlink+0x60>
    if(de.inum == 0)
    80002f6a:	fb045783          	lhu	a5,-80(s0)
    80002f6e:	c39d                	beqz	a5,80002f94 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f70:	24c1                	addiw	s1,s1,16
    80002f72:	05492783          	lw	a5,84(s2)
    80002f76:	fef4e1e3          	bltu	s1,a5,80002f58 <dirlink+0x30>
    80002f7a:	79a2                	ld	s3,40(sp)
    80002f7c:	7a02                	ld	s4,32(sp)
    80002f7e:	a829                	j	80002f98 <dirlink+0x70>
    iput(ip);
    80002f80:	9a7ff0ef          	jal	80002926 <iput>
    return -1;
    80002f84:	557d                	li	a0,-1
    80002f86:	a83d                	j	80002fc4 <dirlink+0x9c>
      panic("dirlink read");
    80002f88:	00005517          	auipc	a0,0x5
    80002f8c:	4e050513          	addi	a0,a0,1248 # 80008468 <etext+0x468>
    80002f90:	35b020ef          	jal	80005aea <panic>
    80002f94:	79a2                	ld	s3,40(sp)
    80002f96:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002f98:	4639                	li	a2,14
    80002f9a:	85d6                	mv	a1,s5
    80002f9c:	fb240513          	addi	a0,s0,-78
    80002fa0:	b8cfd0ef          	jal	8000032c <strncpy>
  de.inum = inum;
    80002fa4:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fa8:	4741                	li	a4,16
    80002faa:	86a6                	mv	a3,s1
    80002fac:	fb040613          	addi	a2,s0,-80
    80002fb0:	4581                	li	a1,0
    80002fb2:	854a                	mv	a0,s2
    80002fb4:	c75ff0ef          	jal	80002c28 <writei>
    80002fb8:	1541                	addi	a0,a0,-16
    80002fba:	00a03533          	snez	a0,a0
    80002fbe:	40a0053b          	negw	a0,a0
    80002fc2:	74e2                	ld	s1,56(sp)
}
    80002fc4:	60a6                	ld	ra,72(sp)
    80002fc6:	6406                	ld	s0,64(sp)
    80002fc8:	7942                	ld	s2,48(sp)
    80002fca:	6ae2                	ld	s5,24(sp)
    80002fcc:	6b42                	ld	s6,16(sp)
    80002fce:	6161                	addi	sp,sp,80
    80002fd0:	8082                	ret

0000000080002fd2 <namei>:

struct inode*
namei(char *path)
{
    80002fd2:	1101                	addi	sp,sp,-32
    80002fd4:	ec06                	sd	ra,24(sp)
    80002fd6:	e822                	sd	s0,16(sp)
    80002fd8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002fda:	fe040613          	addi	a2,s0,-32
    80002fde:	4581                	li	a1,0
    80002fe0:	e0bff0ef          	jal	80002dea <namex>
}
    80002fe4:	60e2                	ld	ra,24(sp)
    80002fe6:	6442                	ld	s0,16(sp)
    80002fe8:	6105                	addi	sp,sp,32
    80002fea:	8082                	ret

0000000080002fec <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002fec:	1141                	addi	sp,sp,-16
    80002fee:	e406                	sd	ra,8(sp)
    80002ff0:	e022                	sd	s0,0(sp)
    80002ff2:	0800                	addi	s0,sp,16
    80002ff4:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002ff6:	4585                	li	a1,1
    80002ff8:	df3ff0ef          	jal	80002dea <namex>
}
    80002ffc:	60a2                	ld	ra,8(sp)
    80002ffe:	6402                	ld	s0,0(sp)
    80003000:	0141                	addi	sp,sp,16
    80003002:	8082                	ret

0000000080003004 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003004:	1101                	addi	sp,sp,-32
    80003006:	ec06                	sd	ra,24(sp)
    80003008:	e822                	sd	s0,16(sp)
    8000300a:	e426                	sd	s1,8(sp)
    8000300c:	e04a                	sd	s2,0(sp)
    8000300e:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003010:	00016917          	auipc	s2,0x16
    80003014:	47090913          	addi	s2,s2,1136 # 80019480 <log>
    80003018:	02092583          	lw	a1,32(s2)
    8000301c:	02c92503          	lw	a0,44(s2)
    80003020:	8e0ff0ef          	jal	80002100 <bread>
    80003024:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003026:	03092603          	lw	a2,48(s2)
    8000302a:	d130                	sw	a2,96(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000302c:	00c05f63          	blez	a2,8000304a <write_head+0x46>
    80003030:	00016717          	auipc	a4,0x16
    80003034:	48470713          	addi	a4,a4,1156 # 800194b4 <log+0x34>
    80003038:	87aa                	mv	a5,a0
    8000303a:	060a                	slli	a2,a2,0x2
    8000303c:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000303e:	4314                	lw	a3,0(a4)
    80003040:	d3f4                	sw	a3,100(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003042:	0711                	addi	a4,a4,4
    80003044:	0791                	addi	a5,a5,4
    80003046:	fec79ce3          	bne	a5,a2,8000303e <write_head+0x3a>
  }
  bwrite(buf);
    8000304a:	8526                	mv	a0,s1
    8000304c:	98aff0ef          	jal	800021d6 <bwrite>
  brelse(buf);
    80003050:	8526                	mv	a0,s1
    80003052:	9b6ff0ef          	jal	80002208 <brelse>
}
    80003056:	60e2                	ld	ra,24(sp)
    80003058:	6442                	ld	s0,16(sp)
    8000305a:	64a2                	ld	s1,8(sp)
    8000305c:	6902                	ld	s2,0(sp)
    8000305e:	6105                	addi	sp,sp,32
    80003060:	8082                	ret

0000000080003062 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003062:	00016797          	auipc	a5,0x16
    80003066:	44e7a783          	lw	a5,1102(a5) # 800194b0 <log+0x30>
    8000306a:	0cf05163          	blez	a5,8000312c <install_trans+0xca>
{
    8000306e:	715d                	addi	sp,sp,-80
    80003070:	e486                	sd	ra,72(sp)
    80003072:	e0a2                	sd	s0,64(sp)
    80003074:	fc26                	sd	s1,56(sp)
    80003076:	f84a                	sd	s2,48(sp)
    80003078:	f44e                	sd	s3,40(sp)
    8000307a:	f052                	sd	s4,32(sp)
    8000307c:	ec56                	sd	s5,24(sp)
    8000307e:	e85a                	sd	s6,16(sp)
    80003080:	e45e                	sd	s7,8(sp)
    80003082:	e062                	sd	s8,0(sp)
    80003084:	0880                	addi	s0,sp,80
    80003086:	8b2a                	mv	s6,a0
    80003088:	00016a97          	auipc	s5,0x16
    8000308c:	42ca8a93          	addi	s5,s5,1068 # 800194b4 <log+0x34>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003090:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003092:	00005c17          	auipc	s8,0x5
    80003096:	3e6c0c13          	addi	s8,s8,998 # 80008478 <etext+0x478>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000309a:	00016a17          	auipc	s4,0x16
    8000309e:	3e6a0a13          	addi	s4,s4,998 # 80019480 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800030a2:	40000b93          	li	s7,1024
    800030a6:	a025                	j	800030ce <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800030a8:	000aa603          	lw	a2,0(s5)
    800030ac:	85ce                	mv	a1,s3
    800030ae:	8562                	mv	a0,s8
    800030b0:	710020ef          	jal	800057c0 <printf>
    800030b4:	a839                	j	800030d2 <install_trans+0x70>
    brelse(lbuf);
    800030b6:	854a                	mv	a0,s2
    800030b8:	950ff0ef          	jal	80002208 <brelse>
    brelse(dbuf);
    800030bc:	8526                	mv	a0,s1
    800030be:	94aff0ef          	jal	80002208 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800030c2:	2985                	addiw	s3,s3,1
    800030c4:	0a91                	addi	s5,s5,4
    800030c6:	030a2783          	lw	a5,48(s4)
    800030ca:	04f9d563          	bge	s3,a5,80003114 <install_trans+0xb2>
    if(recovering) {
    800030ce:	fc0b1de3          	bnez	s6,800030a8 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800030d2:	020a2583          	lw	a1,32(s4)
    800030d6:	013585bb          	addw	a1,a1,s3
    800030da:	2585                	addiw	a1,a1,1
    800030dc:	02ca2503          	lw	a0,44(s4)
    800030e0:	820ff0ef          	jal	80002100 <bread>
    800030e4:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800030e6:	000aa583          	lw	a1,0(s5)
    800030ea:	02ca2503          	lw	a0,44(s4)
    800030ee:	812ff0ef          	jal	80002100 <bread>
    800030f2:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800030f4:	865e                	mv	a2,s7
    800030f6:	06090593          	addi	a1,s2,96
    800030fa:	06050513          	addi	a0,a0,96
    800030fe:	980fd0ef          	jal	8000027e <memmove>
    bwrite(dbuf);  // write dst to disk
    80003102:	8526                	mv	a0,s1
    80003104:	8d2ff0ef          	jal	800021d6 <bwrite>
    if(recovering == 0)
    80003108:	fa0b17e3          	bnez	s6,800030b6 <install_trans+0x54>
      bunpin(dbuf);
    8000310c:	8526                	mv	a0,s1
    8000310e:	9b2ff0ef          	jal	800022c0 <bunpin>
    80003112:	b755                	j	800030b6 <install_trans+0x54>
}
    80003114:	60a6                	ld	ra,72(sp)
    80003116:	6406                	ld	s0,64(sp)
    80003118:	74e2                	ld	s1,56(sp)
    8000311a:	7942                	ld	s2,48(sp)
    8000311c:	79a2                	ld	s3,40(sp)
    8000311e:	7a02                	ld	s4,32(sp)
    80003120:	6ae2                	ld	s5,24(sp)
    80003122:	6b42                	ld	s6,16(sp)
    80003124:	6ba2                	ld	s7,8(sp)
    80003126:	6c02                	ld	s8,0(sp)
    80003128:	6161                	addi	sp,sp,80
    8000312a:	8082                	ret
    8000312c:	8082                	ret

000000008000312e <initlog>:
{
    8000312e:	7179                	addi	sp,sp,-48
    80003130:	f406                	sd	ra,40(sp)
    80003132:	f022                	sd	s0,32(sp)
    80003134:	ec26                	sd	s1,24(sp)
    80003136:	e84a                	sd	s2,16(sp)
    80003138:	e44e                	sd	s3,8(sp)
    8000313a:	1800                	addi	s0,sp,48
    8000313c:	84aa                	mv	s1,a0
    8000313e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003140:	00016917          	auipc	s2,0x16
    80003144:	34090913          	addi	s2,s2,832 # 80019480 <log>
    80003148:	00005597          	auipc	a1,0x5
    8000314c:	35058593          	addi	a1,a1,848 # 80008498 <etext+0x498>
    80003150:	854a                	mv	a0,s2
    80003152:	645020ef          	jal	80005f96 <initlock>
  log.start = sb->logstart;
    80003156:	0149a583          	lw	a1,20(s3)
    8000315a:	02b92023          	sw	a1,32(s2)
  log.dev = dev;
    8000315e:	02992623          	sw	s1,44(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003162:	8526                	mv	a0,s1
    80003164:	f9dfe0ef          	jal	80002100 <bread>
  log.lh.n = lh->n;
    80003168:	5130                	lw	a2,96(a0)
    8000316a:	02c92823          	sw	a2,48(s2)
  for (i = 0; i < log.lh.n; i++) {
    8000316e:	00c05f63          	blez	a2,8000318c <initlog+0x5e>
    80003172:	87aa                	mv	a5,a0
    80003174:	00016717          	auipc	a4,0x16
    80003178:	34070713          	addi	a4,a4,832 # 800194b4 <log+0x34>
    8000317c:	060a                	slli	a2,a2,0x2
    8000317e:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003180:	53f4                	lw	a3,100(a5)
    80003182:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003184:	0791                	addi	a5,a5,4
    80003186:	0711                	addi	a4,a4,4
    80003188:	fec79ce3          	bne	a5,a2,80003180 <initlog+0x52>
  brelse(buf);
    8000318c:	87cff0ef          	jal	80002208 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003190:	4505                	li	a0,1
    80003192:	ed1ff0ef          	jal	80003062 <install_trans>
  log.lh.n = 0;
    80003196:	00016797          	auipc	a5,0x16
    8000319a:	3007ad23          	sw	zero,794(a5) # 800194b0 <log+0x30>
  write_head(); // clear the log
    8000319e:	e67ff0ef          	jal	80003004 <write_head>
}
    800031a2:	70a2                	ld	ra,40(sp)
    800031a4:	7402                	ld	s0,32(sp)
    800031a6:	64e2                	ld	s1,24(sp)
    800031a8:	6942                	ld	s2,16(sp)
    800031aa:	69a2                	ld	s3,8(sp)
    800031ac:	6145                	addi	sp,sp,48
    800031ae:	8082                	ret

00000000800031b0 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800031b0:	1101                	addi	sp,sp,-32
    800031b2:	ec06                	sd	ra,24(sp)
    800031b4:	e822                	sd	s0,16(sp)
    800031b6:	e426                	sd	s1,8(sp)
    800031b8:	e04a                	sd	s2,0(sp)
    800031ba:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800031bc:	00016517          	auipc	a0,0x16
    800031c0:	2c450513          	addi	a0,a0,708 # 80019480 <log>
    800031c4:	453020ef          	jal	80005e16 <acquire>
  while(1){
    if(log.committing){
    800031c8:	00016497          	auipc	s1,0x16
    800031cc:	2b848493          	addi	s1,s1,696 # 80019480 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800031d0:	4979                	li	s2,30
    800031d2:	a029                	j	800031dc <begin_op+0x2c>
      sleep(&log, &log.lock);
    800031d4:	85a6                	mv	a1,s1
    800031d6:	8526                	mv	a0,s1
    800031d8:	aa2fe0ef          	jal	8000147a <sleep>
    if(log.committing){
    800031dc:	549c                	lw	a5,40(s1)
    800031de:	fbfd                	bnez	a5,800031d4 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800031e0:	50d8                	lw	a4,36(s1)
    800031e2:	2705                	addiw	a4,a4,1
    800031e4:	0027179b          	slliw	a5,a4,0x2
    800031e8:	9fb9                	addw	a5,a5,a4
    800031ea:	0017979b          	slliw	a5,a5,0x1
    800031ee:	5894                	lw	a3,48(s1)
    800031f0:	9fb5                	addw	a5,a5,a3
    800031f2:	00f95763          	bge	s2,a5,80003200 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800031f6:	85a6                	mv	a1,s1
    800031f8:	8526                	mv	a0,s1
    800031fa:	a80fe0ef          	jal	8000147a <sleep>
    800031fe:	bff9                	j	800031dc <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003200:	00016797          	auipc	a5,0x16
    80003204:	2ae7a223          	sw	a4,676(a5) # 800194a4 <log+0x24>
      release(&log.lock);
    80003208:	00016517          	auipc	a0,0x16
    8000320c:	27850513          	addi	a0,a0,632 # 80019480 <log>
    80003210:	4ef020ef          	jal	80005efe <release>
      break;
    }
  }
}
    80003214:	60e2                	ld	ra,24(sp)
    80003216:	6442                	ld	s0,16(sp)
    80003218:	64a2                	ld	s1,8(sp)
    8000321a:	6902                	ld	s2,0(sp)
    8000321c:	6105                	addi	sp,sp,32
    8000321e:	8082                	ret

0000000080003220 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003220:	7139                	addi	sp,sp,-64
    80003222:	fc06                	sd	ra,56(sp)
    80003224:	f822                	sd	s0,48(sp)
    80003226:	f426                	sd	s1,40(sp)
    80003228:	f04a                	sd	s2,32(sp)
    8000322a:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000322c:	00016497          	auipc	s1,0x16
    80003230:	25448493          	addi	s1,s1,596 # 80019480 <log>
    80003234:	8526                	mv	a0,s1
    80003236:	3e1020ef          	jal	80005e16 <acquire>
  log.outstanding -= 1;
    8000323a:	50dc                	lw	a5,36(s1)
    8000323c:	37fd                	addiw	a5,a5,-1
    8000323e:	893e                	mv	s2,a5
    80003240:	d0dc                	sw	a5,36(s1)
  if(log.committing)
    80003242:	549c                	lw	a5,40(s1)
    80003244:	e7b1                	bnez	a5,80003290 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003246:	04091e63          	bnez	s2,800032a2 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    8000324a:	00016497          	auipc	s1,0x16
    8000324e:	23648493          	addi	s1,s1,566 # 80019480 <log>
    80003252:	4785                	li	a5,1
    80003254:	d49c                	sw	a5,40(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003256:	8526                	mv	a0,s1
    80003258:	4a7020ef          	jal	80005efe <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000325c:	589c                	lw	a5,48(s1)
    8000325e:	06f04463          	bgtz	a5,800032c6 <end_op+0xa6>
    acquire(&log.lock);
    80003262:	00016517          	auipc	a0,0x16
    80003266:	21e50513          	addi	a0,a0,542 # 80019480 <log>
    8000326a:	3ad020ef          	jal	80005e16 <acquire>
    log.committing = 0;
    8000326e:	00016797          	auipc	a5,0x16
    80003272:	2207ad23          	sw	zero,570(a5) # 800194a8 <log+0x28>
    wakeup(&log);
    80003276:	00016517          	auipc	a0,0x16
    8000327a:	20a50513          	addi	a0,a0,522 # 80019480 <log>
    8000327e:	a48fe0ef          	jal	800014c6 <wakeup>
    release(&log.lock);
    80003282:	00016517          	auipc	a0,0x16
    80003286:	1fe50513          	addi	a0,a0,510 # 80019480 <log>
    8000328a:	475020ef          	jal	80005efe <release>
}
    8000328e:	a035                	j	800032ba <end_op+0x9a>
    80003290:	ec4e                	sd	s3,24(sp)
    80003292:	e852                	sd	s4,16(sp)
    80003294:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003296:	00005517          	auipc	a0,0x5
    8000329a:	20a50513          	addi	a0,a0,522 # 800084a0 <etext+0x4a0>
    8000329e:	04d020ef          	jal	80005aea <panic>
    wakeup(&log);
    800032a2:	00016517          	auipc	a0,0x16
    800032a6:	1de50513          	addi	a0,a0,478 # 80019480 <log>
    800032aa:	a1cfe0ef          	jal	800014c6 <wakeup>
  release(&log.lock);
    800032ae:	00016517          	auipc	a0,0x16
    800032b2:	1d250513          	addi	a0,a0,466 # 80019480 <log>
    800032b6:	449020ef          	jal	80005efe <release>
}
    800032ba:	70e2                	ld	ra,56(sp)
    800032bc:	7442                	ld	s0,48(sp)
    800032be:	74a2                	ld	s1,40(sp)
    800032c0:	7902                	ld	s2,32(sp)
    800032c2:	6121                	addi	sp,sp,64
    800032c4:	8082                	ret
    800032c6:	ec4e                	sd	s3,24(sp)
    800032c8:	e852                	sd	s4,16(sp)
    800032ca:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800032cc:	00016a97          	auipc	s5,0x16
    800032d0:	1e8a8a93          	addi	s5,s5,488 # 800194b4 <log+0x34>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800032d4:	00016a17          	auipc	s4,0x16
    800032d8:	1aca0a13          	addi	s4,s4,428 # 80019480 <log>
    800032dc:	020a2583          	lw	a1,32(s4)
    800032e0:	012585bb          	addw	a1,a1,s2
    800032e4:	2585                	addiw	a1,a1,1
    800032e6:	02ca2503          	lw	a0,44(s4)
    800032ea:	e17fe0ef          	jal	80002100 <bread>
    800032ee:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800032f0:	000aa583          	lw	a1,0(s5)
    800032f4:	02ca2503          	lw	a0,44(s4)
    800032f8:	e09fe0ef          	jal	80002100 <bread>
    800032fc:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800032fe:	40000613          	li	a2,1024
    80003302:	06050593          	addi	a1,a0,96
    80003306:	06048513          	addi	a0,s1,96
    8000330a:	f75fc0ef          	jal	8000027e <memmove>
    bwrite(to);  // write the log
    8000330e:	8526                	mv	a0,s1
    80003310:	ec7fe0ef          	jal	800021d6 <bwrite>
    brelse(from);
    80003314:	854e                	mv	a0,s3
    80003316:	ef3fe0ef          	jal	80002208 <brelse>
    brelse(to);
    8000331a:	8526                	mv	a0,s1
    8000331c:	eedfe0ef          	jal	80002208 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003320:	2905                	addiw	s2,s2,1
    80003322:	0a91                	addi	s5,s5,4
    80003324:	030a2783          	lw	a5,48(s4)
    80003328:	faf94ae3          	blt	s2,a5,800032dc <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000332c:	cd9ff0ef          	jal	80003004 <write_head>
    install_trans(0); // Now install writes to home locations
    80003330:	4501                	li	a0,0
    80003332:	d31ff0ef          	jal	80003062 <install_trans>
    log.lh.n = 0;
    80003336:	00016797          	auipc	a5,0x16
    8000333a:	1607ad23          	sw	zero,378(a5) # 800194b0 <log+0x30>
    write_head();    // Erase the transaction from the log
    8000333e:	cc7ff0ef          	jal	80003004 <write_head>
    80003342:	69e2                	ld	s3,24(sp)
    80003344:	6a42                	ld	s4,16(sp)
    80003346:	6aa2                	ld	s5,8(sp)
    80003348:	bf29                	j	80003262 <end_op+0x42>

000000008000334a <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000334a:	1101                	addi	sp,sp,-32
    8000334c:	ec06                	sd	ra,24(sp)
    8000334e:	e822                	sd	s0,16(sp)
    80003350:	e426                	sd	s1,8(sp)
    80003352:	1000                	addi	s0,sp,32
    80003354:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003356:	00016517          	auipc	a0,0x16
    8000335a:	12a50513          	addi	a0,a0,298 # 80019480 <log>
    8000335e:	2b9020ef          	jal	80005e16 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003362:	00016617          	auipc	a2,0x16
    80003366:	14e62603          	lw	a2,334(a2) # 800194b0 <log+0x30>
    8000336a:	47f5                	li	a5,29
    8000336c:	04c7cd63          	blt	a5,a2,800033c6 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003370:	00016797          	auipc	a5,0x16
    80003374:	1347a783          	lw	a5,308(a5) # 800194a4 <log+0x24>
    80003378:	04f05d63          	blez	a5,800033d2 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000337c:	4781                	li	a5,0
    8000337e:	06c05063          	blez	a2,800033de <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003382:	44cc                	lw	a1,12(s1)
    80003384:	00016717          	auipc	a4,0x16
    80003388:	13070713          	addi	a4,a4,304 # 800194b4 <log+0x34>
  for (i = 0; i < log.lh.n; i++) {
    8000338c:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000338e:	4314                	lw	a3,0(a4)
    80003390:	04b68763          	beq	a3,a1,800033de <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003394:	2785                	addiw	a5,a5,1
    80003396:	0711                	addi	a4,a4,4
    80003398:	fef61be3          	bne	a2,a5,8000338e <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000339c:	060a                	slli	a2,a2,0x2
    8000339e:	03060613          	addi	a2,a2,48
    800033a2:	00016797          	auipc	a5,0x16
    800033a6:	0de78793          	addi	a5,a5,222 # 80019480 <log>
    800033aa:	97b2                	add	a5,a5,a2
    800033ac:	44d8                	lw	a4,12(s1)
    800033ae:	c3d8                	sw	a4,4(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800033b0:	8526                	mv	a0,s1
    800033b2:	edbfe0ef          	jal	8000228c <bpin>
    log.lh.n++;
    800033b6:	00016717          	auipc	a4,0x16
    800033ba:	0ca70713          	addi	a4,a4,202 # 80019480 <log>
    800033be:	5b1c                	lw	a5,48(a4)
    800033c0:	2785                	addiw	a5,a5,1
    800033c2:	db1c                	sw	a5,48(a4)
    800033c4:	a815                	j	800033f8 <log_write+0xae>
    panic("too big a transaction");
    800033c6:	00005517          	auipc	a0,0x5
    800033ca:	0ea50513          	addi	a0,a0,234 # 800084b0 <etext+0x4b0>
    800033ce:	71c020ef          	jal	80005aea <panic>
    panic("log_write outside of trans");
    800033d2:	00005517          	auipc	a0,0x5
    800033d6:	0f650513          	addi	a0,a0,246 # 800084c8 <etext+0x4c8>
    800033da:	710020ef          	jal	80005aea <panic>
  log.lh.block[i] = b->blockno;
    800033de:	00279693          	slli	a3,a5,0x2
    800033e2:	03068693          	addi	a3,a3,48
    800033e6:	00016717          	auipc	a4,0x16
    800033ea:	09a70713          	addi	a4,a4,154 # 80019480 <log>
    800033ee:	9736                	add	a4,a4,a3
    800033f0:	44d4                	lw	a3,12(s1)
    800033f2:	c354                	sw	a3,4(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800033f4:	faf60ee3          	beq	a2,a5,800033b0 <log_write+0x66>
  }
  release(&log.lock);
    800033f8:	00016517          	auipc	a0,0x16
    800033fc:	08850513          	addi	a0,a0,136 # 80019480 <log>
    80003400:	2ff020ef          	jal	80005efe <release>
}
    80003404:	60e2                	ld	ra,24(sp)
    80003406:	6442                	ld	s0,16(sp)
    80003408:	64a2                	ld	s1,8(sp)
    8000340a:	6105                	addi	sp,sp,32
    8000340c:	8082                	ret

000000008000340e <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000340e:	1101                	addi	sp,sp,-32
    80003410:	ec06                	sd	ra,24(sp)
    80003412:	e822                	sd	s0,16(sp)
    80003414:	e426                	sd	s1,8(sp)
    80003416:	e04a                	sd	s2,0(sp)
    80003418:	1000                	addi	s0,sp,32
    8000341a:	84aa                	mv	s1,a0
    8000341c:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000341e:	00005597          	auipc	a1,0x5
    80003422:	0ca58593          	addi	a1,a1,202 # 800084e8 <etext+0x4e8>
    80003426:	0521                	addi	a0,a0,8
    80003428:	36f020ef          	jal	80005f96 <initlock>
  lk->name = name;
    8000342c:	0324b423          	sd	s2,40(s1)
  lk->locked = 0;
    80003430:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003434:	0204a823          	sw	zero,48(s1)
}
    80003438:	60e2                	ld	ra,24(sp)
    8000343a:	6442                	ld	s0,16(sp)
    8000343c:	64a2                	ld	s1,8(sp)
    8000343e:	6902                	ld	s2,0(sp)
    80003440:	6105                	addi	sp,sp,32
    80003442:	8082                	ret

0000000080003444 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003444:	1101                	addi	sp,sp,-32
    80003446:	ec06                	sd	ra,24(sp)
    80003448:	e822                	sd	s0,16(sp)
    8000344a:	e426                	sd	s1,8(sp)
    8000344c:	e04a                	sd	s2,0(sp)
    8000344e:	1000                	addi	s0,sp,32
    80003450:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003452:	00850913          	addi	s2,a0,8
    80003456:	854a                	mv	a0,s2
    80003458:	1bf020ef          	jal	80005e16 <acquire>
  while (lk->locked) {
    8000345c:	409c                	lw	a5,0(s1)
    8000345e:	c799                	beqz	a5,8000346c <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003460:	85ca                	mv	a1,s2
    80003462:	8526                	mv	a0,s1
    80003464:	816fe0ef          	jal	8000147a <sleep>
  while (lk->locked) {
    80003468:	409c                	lw	a5,0(s1)
    8000346a:	fbfd                	bnez	a5,80003460 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000346c:	4785                	li	a5,1
    8000346e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003470:	9e1fd0ef          	jal	80000e50 <myproc>
    80003474:	5d1c                	lw	a5,56(a0)
    80003476:	d89c                	sw	a5,48(s1)
  release(&lk->lk);
    80003478:	854a                	mv	a0,s2
    8000347a:	285020ef          	jal	80005efe <release>
}
    8000347e:	60e2                	ld	ra,24(sp)
    80003480:	6442                	ld	s0,16(sp)
    80003482:	64a2                	ld	s1,8(sp)
    80003484:	6902                	ld	s2,0(sp)
    80003486:	6105                	addi	sp,sp,32
    80003488:	8082                	ret

000000008000348a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000348a:	1101                	addi	sp,sp,-32
    8000348c:	ec06                	sd	ra,24(sp)
    8000348e:	e822                	sd	s0,16(sp)
    80003490:	e426                	sd	s1,8(sp)
    80003492:	e04a                	sd	s2,0(sp)
    80003494:	1000                	addi	s0,sp,32
    80003496:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003498:	00850913          	addi	s2,a0,8
    8000349c:	854a                	mv	a0,s2
    8000349e:	179020ef          	jal	80005e16 <acquire>
  lk->locked = 0;
    800034a2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800034a6:	0204a823          	sw	zero,48(s1)
  wakeup(lk);
    800034aa:	8526                	mv	a0,s1
    800034ac:	81afe0ef          	jal	800014c6 <wakeup>
  release(&lk->lk);
    800034b0:	854a                	mv	a0,s2
    800034b2:	24d020ef          	jal	80005efe <release>
}
    800034b6:	60e2                	ld	ra,24(sp)
    800034b8:	6442                	ld	s0,16(sp)
    800034ba:	64a2                	ld	s1,8(sp)
    800034bc:	6902                	ld	s2,0(sp)
    800034be:	6105                	addi	sp,sp,32
    800034c0:	8082                	ret

00000000800034c2 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800034c2:	7179                	addi	sp,sp,-48
    800034c4:	f406                	sd	ra,40(sp)
    800034c6:	f022                	sd	s0,32(sp)
    800034c8:	ec26                	sd	s1,24(sp)
    800034ca:	e84a                	sd	s2,16(sp)
    800034cc:	1800                	addi	s0,sp,48
    800034ce:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800034d0:	00850913          	addi	s2,a0,8
    800034d4:	854a                	mv	a0,s2
    800034d6:	141020ef          	jal	80005e16 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800034da:	409c                	lw	a5,0(s1)
    800034dc:	ef81                	bnez	a5,800034f4 <holdingsleep+0x32>
    800034de:	4481                	li	s1,0
  release(&lk->lk);
    800034e0:	854a                	mv	a0,s2
    800034e2:	21d020ef          	jal	80005efe <release>
  return r;
}
    800034e6:	8526                	mv	a0,s1
    800034e8:	70a2                	ld	ra,40(sp)
    800034ea:	7402                	ld	s0,32(sp)
    800034ec:	64e2                	ld	s1,24(sp)
    800034ee:	6942                	ld	s2,16(sp)
    800034f0:	6145                	addi	sp,sp,48
    800034f2:	8082                	ret
    800034f4:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800034f6:	0304a983          	lw	s3,48(s1)
    800034fa:	957fd0ef          	jal	80000e50 <myproc>
    800034fe:	5d04                	lw	s1,56(a0)
    80003500:	413484b3          	sub	s1,s1,s3
    80003504:	0014b493          	seqz	s1,s1
    80003508:	69a2                	ld	s3,8(sp)
    8000350a:	bfd9                	j	800034e0 <holdingsleep+0x1e>

000000008000350c <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000350c:	1141                	addi	sp,sp,-16
    8000350e:	e406                	sd	ra,8(sp)
    80003510:	e022                	sd	s0,0(sp)
    80003512:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003514:	00005597          	auipc	a1,0x5
    80003518:	fe458593          	addi	a1,a1,-28 # 800084f8 <etext+0x4f8>
    8000351c:	00016517          	auipc	a0,0x16
    80003520:	0b450513          	addi	a0,a0,180 # 800195d0 <ftable>
    80003524:	273020ef          	jal	80005f96 <initlock>
}
    80003528:	60a2                	ld	ra,8(sp)
    8000352a:	6402                	ld	s0,0(sp)
    8000352c:	0141                	addi	sp,sp,16
    8000352e:	8082                	ret

0000000080003530 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003530:	1101                	addi	sp,sp,-32
    80003532:	ec06                	sd	ra,24(sp)
    80003534:	e822                	sd	s0,16(sp)
    80003536:	e426                	sd	s1,8(sp)
    80003538:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000353a:	00016517          	auipc	a0,0x16
    8000353e:	09650513          	addi	a0,a0,150 # 800195d0 <ftable>
    80003542:	0d5020ef          	jal	80005e16 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003546:	00016497          	auipc	s1,0x16
    8000354a:	0aa48493          	addi	s1,s1,170 # 800195f0 <ftable+0x20>
    8000354e:	00017717          	auipc	a4,0x17
    80003552:	04270713          	addi	a4,a4,66 # 8001a590 <disk>
    if(f->ref == 0){
    80003556:	40dc                	lw	a5,4(s1)
    80003558:	cf89                	beqz	a5,80003572 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000355a:	02848493          	addi	s1,s1,40
    8000355e:	fee49ce3          	bne	s1,a4,80003556 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003562:	00016517          	auipc	a0,0x16
    80003566:	06e50513          	addi	a0,a0,110 # 800195d0 <ftable>
    8000356a:	195020ef          	jal	80005efe <release>
  return 0;
    8000356e:	4481                	li	s1,0
    80003570:	a809                	j	80003582 <filealloc+0x52>
      f->ref = 1;
    80003572:	4785                	li	a5,1
    80003574:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003576:	00016517          	auipc	a0,0x16
    8000357a:	05a50513          	addi	a0,a0,90 # 800195d0 <ftable>
    8000357e:	181020ef          	jal	80005efe <release>
}
    80003582:	8526                	mv	a0,s1
    80003584:	60e2                	ld	ra,24(sp)
    80003586:	6442                	ld	s0,16(sp)
    80003588:	64a2                	ld	s1,8(sp)
    8000358a:	6105                	addi	sp,sp,32
    8000358c:	8082                	ret

000000008000358e <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000358e:	1101                	addi	sp,sp,-32
    80003590:	ec06                	sd	ra,24(sp)
    80003592:	e822                	sd	s0,16(sp)
    80003594:	e426                	sd	s1,8(sp)
    80003596:	1000                	addi	s0,sp,32
    80003598:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000359a:	00016517          	auipc	a0,0x16
    8000359e:	03650513          	addi	a0,a0,54 # 800195d0 <ftable>
    800035a2:	075020ef          	jal	80005e16 <acquire>
  if(f->ref < 1)
    800035a6:	40dc                	lw	a5,4(s1)
    800035a8:	02f05063          	blez	a5,800035c8 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800035ac:	2785                	addiw	a5,a5,1
    800035ae:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800035b0:	00016517          	auipc	a0,0x16
    800035b4:	02050513          	addi	a0,a0,32 # 800195d0 <ftable>
    800035b8:	147020ef          	jal	80005efe <release>
  return f;
}
    800035bc:	8526                	mv	a0,s1
    800035be:	60e2                	ld	ra,24(sp)
    800035c0:	6442                	ld	s0,16(sp)
    800035c2:	64a2                	ld	s1,8(sp)
    800035c4:	6105                	addi	sp,sp,32
    800035c6:	8082                	ret
    panic("filedup");
    800035c8:	00005517          	auipc	a0,0x5
    800035cc:	f3850513          	addi	a0,a0,-200 # 80008500 <etext+0x500>
    800035d0:	51a020ef          	jal	80005aea <panic>

00000000800035d4 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800035d4:	7139                	addi	sp,sp,-64
    800035d6:	fc06                	sd	ra,56(sp)
    800035d8:	f822                	sd	s0,48(sp)
    800035da:	f426                	sd	s1,40(sp)
    800035dc:	0080                	addi	s0,sp,64
    800035de:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800035e0:	00016517          	auipc	a0,0x16
    800035e4:	ff050513          	addi	a0,a0,-16 # 800195d0 <ftable>
    800035e8:	02f020ef          	jal	80005e16 <acquire>
  if(f->ref < 1)
    800035ec:	40dc                	lw	a5,4(s1)
    800035ee:	04f05a63          	blez	a5,80003642 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800035f2:	37fd                	addiw	a5,a5,-1
    800035f4:	c0dc                	sw	a5,4(s1)
    800035f6:	06f04063          	bgtz	a5,80003656 <fileclose+0x82>
    800035fa:	f04a                	sd	s2,32(sp)
    800035fc:	ec4e                	sd	s3,24(sp)
    800035fe:	e852                	sd	s4,16(sp)
    80003600:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003602:	0004a903          	lw	s2,0(s1)
    80003606:	0094c783          	lbu	a5,9(s1)
    8000360a:	89be                	mv	s3,a5
    8000360c:	689c                	ld	a5,16(s1)
    8000360e:	8a3e                	mv	s4,a5
    80003610:	6c9c                	ld	a5,24(s1)
    80003612:	8abe                	mv	s5,a5
  f->ref = 0;
    80003614:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003618:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000361c:	00016517          	auipc	a0,0x16
    80003620:	fb450513          	addi	a0,a0,-76 # 800195d0 <ftable>
    80003624:	0db020ef          	jal	80005efe <release>

  if(ff.type == FD_PIPE){
    80003628:	4785                	li	a5,1
    8000362a:	04f90163          	beq	s2,a5,8000366c <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000362e:	ffe9079b          	addiw	a5,s2,-2
    80003632:	4705                	li	a4,1
    80003634:	04f77563          	bgeu	a4,a5,8000367e <fileclose+0xaa>
    80003638:	7902                	ld	s2,32(sp)
    8000363a:	69e2                	ld	s3,24(sp)
    8000363c:	6a42                	ld	s4,16(sp)
    8000363e:	6aa2                	ld	s5,8(sp)
    80003640:	a00d                	j	80003662 <fileclose+0x8e>
    80003642:	f04a                	sd	s2,32(sp)
    80003644:	ec4e                	sd	s3,24(sp)
    80003646:	e852                	sd	s4,16(sp)
    80003648:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000364a:	00005517          	auipc	a0,0x5
    8000364e:	ebe50513          	addi	a0,a0,-322 # 80008508 <etext+0x508>
    80003652:	498020ef          	jal	80005aea <panic>
    release(&ftable.lock);
    80003656:	00016517          	auipc	a0,0x16
    8000365a:	f7a50513          	addi	a0,a0,-134 # 800195d0 <ftable>
    8000365e:	0a1020ef          	jal	80005efe <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003662:	70e2                	ld	ra,56(sp)
    80003664:	7442                	ld	s0,48(sp)
    80003666:	74a2                	ld	s1,40(sp)
    80003668:	6121                	addi	sp,sp,64
    8000366a:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    8000366c:	85ce                	mv	a1,s3
    8000366e:	8552                	mv	a0,s4
    80003670:	348000ef          	jal	800039b8 <pipeclose>
    80003674:	7902                	ld	s2,32(sp)
    80003676:	69e2                	ld	s3,24(sp)
    80003678:	6a42                	ld	s4,16(sp)
    8000367a:	6aa2                	ld	s5,8(sp)
    8000367c:	b7dd                	j	80003662 <fileclose+0x8e>
    begin_op();
    8000367e:	b33ff0ef          	jal	800031b0 <begin_op>
    iput(ff.ip);
    80003682:	8556                	mv	a0,s5
    80003684:	aa2ff0ef          	jal	80002926 <iput>
    end_op();
    80003688:	b99ff0ef          	jal	80003220 <end_op>
    8000368c:	7902                	ld	s2,32(sp)
    8000368e:	69e2                	ld	s3,24(sp)
    80003690:	6a42                	ld	s4,16(sp)
    80003692:	6aa2                	ld	s5,8(sp)
    80003694:	b7f9                	j	80003662 <fileclose+0x8e>

0000000080003696 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003696:	715d                	addi	sp,sp,-80
    80003698:	e486                	sd	ra,72(sp)
    8000369a:	e0a2                	sd	s0,64(sp)
    8000369c:	fc26                	sd	s1,56(sp)
    8000369e:	f052                	sd	s4,32(sp)
    800036a0:	0880                	addi	s0,sp,80
    800036a2:	84aa                	mv	s1,a0
    800036a4:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800036a6:	faafd0ef          	jal	80000e50 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800036aa:	409c                	lw	a5,0(s1)
    800036ac:	37f9                	addiw	a5,a5,-2
    800036ae:	4705                	li	a4,1
    800036b0:	04f76263          	bltu	a4,a5,800036f4 <filestat+0x5e>
    800036b4:	f84a                	sd	s2,48(sp)
    800036b6:	f44e                	sd	s3,40(sp)
    800036b8:	89aa                	mv	s3,a0
    ilock(f->ip);
    800036ba:	6c88                	ld	a0,24(s1)
    800036bc:	8dcff0ef          	jal	80002798 <ilock>
    stati(f->ip, &st);
    800036c0:	fb840913          	addi	s2,s0,-72
    800036c4:	85ca                	mv	a1,s2
    800036c6:	6c88                	ld	a0,24(s1)
    800036c8:	c40ff0ef          	jal	80002b08 <stati>
    iunlock(f->ip);
    800036cc:	6c88                	ld	a0,24(s1)
    800036ce:	97eff0ef          	jal	8000284c <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800036d2:	46e1                	li	a3,24
    800036d4:	864a                	mv	a2,s2
    800036d6:	85d2                	mv	a1,s4
    800036d8:	0589b503          	ld	a0,88(s3)
    800036dc:	ca6fd0ef          	jal	80000b82 <copyout>
    800036e0:	41f5551b          	sraiw	a0,a0,0x1f
    800036e4:	7942                	ld	s2,48(sp)
    800036e6:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800036e8:	60a6                	ld	ra,72(sp)
    800036ea:	6406                	ld	s0,64(sp)
    800036ec:	74e2                	ld	s1,56(sp)
    800036ee:	7a02                	ld	s4,32(sp)
    800036f0:	6161                	addi	sp,sp,80
    800036f2:	8082                	ret
  return -1;
    800036f4:	557d                	li	a0,-1
    800036f6:	bfcd                	j	800036e8 <filestat+0x52>

00000000800036f8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800036f8:	7179                	addi	sp,sp,-48
    800036fa:	f406                	sd	ra,40(sp)
    800036fc:	f022                	sd	s0,32(sp)
    800036fe:	e84a                	sd	s2,16(sp)
    80003700:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003702:	00854783          	lbu	a5,8(a0)
    80003706:	cfd1                	beqz	a5,800037a2 <fileread+0xaa>
    80003708:	ec26                	sd	s1,24(sp)
    8000370a:	e44e                	sd	s3,8(sp)
    8000370c:	84aa                	mv	s1,a0
    8000370e:	892e                	mv	s2,a1
    80003710:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80003712:	411c                	lw	a5,0(a0)
    80003714:	4705                	li	a4,1
    80003716:	04e78363          	beq	a5,a4,8000375c <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000371a:	470d                	li	a4,3
    8000371c:	04e78763          	beq	a5,a4,8000376a <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003720:	4709                	li	a4,2
    80003722:	06e79a63          	bne	a5,a4,80003796 <fileread+0x9e>
    ilock(f->ip);
    80003726:	6d08                	ld	a0,24(a0)
    80003728:	870ff0ef          	jal	80002798 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000372c:	874e                	mv	a4,s3
    8000372e:	5094                	lw	a3,32(s1)
    80003730:	864a                	mv	a2,s2
    80003732:	4585                	li	a1,1
    80003734:	6c88                	ld	a0,24(s1)
    80003736:	c00ff0ef          	jal	80002b36 <readi>
    8000373a:	892a                	mv	s2,a0
    8000373c:	00a05563          	blez	a0,80003746 <fileread+0x4e>
      f->off += r;
    80003740:	509c                	lw	a5,32(s1)
    80003742:	9fa9                	addw	a5,a5,a0
    80003744:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003746:	6c88                	ld	a0,24(s1)
    80003748:	904ff0ef          	jal	8000284c <iunlock>
    8000374c:	64e2                	ld	s1,24(sp)
    8000374e:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003750:	854a                	mv	a0,s2
    80003752:	70a2                	ld	ra,40(sp)
    80003754:	7402                	ld	s0,32(sp)
    80003756:	6942                	ld	s2,16(sp)
    80003758:	6145                	addi	sp,sp,48
    8000375a:	8082                	ret
    r = piperead(f->pipe, addr, n);
    8000375c:	6908                	ld	a0,16(a0)
    8000375e:	3b6000ef          	jal	80003b14 <piperead>
    80003762:	892a                	mv	s2,a0
    80003764:	64e2                	ld	s1,24(sp)
    80003766:	69a2                	ld	s3,8(sp)
    80003768:	b7e5                	j	80003750 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000376a:	02451783          	lh	a5,36(a0)
    8000376e:	03079693          	slli	a3,a5,0x30
    80003772:	92c1                	srli	a3,a3,0x30
    80003774:	4725                	li	a4,9
    80003776:	02d76963          	bltu	a4,a3,800037a8 <fileread+0xb0>
    8000377a:	0792                	slli	a5,a5,0x4
    8000377c:	00016717          	auipc	a4,0x16
    80003780:	db470713          	addi	a4,a4,-588 # 80019530 <devsw>
    80003784:	97ba                	add	a5,a5,a4
    80003786:	639c                	ld	a5,0(a5)
    80003788:	c78d                	beqz	a5,800037b2 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    8000378a:	4505                	li	a0,1
    8000378c:	9782                	jalr	a5
    8000378e:	892a                	mv	s2,a0
    80003790:	64e2                	ld	s1,24(sp)
    80003792:	69a2                	ld	s3,8(sp)
    80003794:	bf75                	j	80003750 <fileread+0x58>
    panic("fileread");
    80003796:	00005517          	auipc	a0,0x5
    8000379a:	d8250513          	addi	a0,a0,-638 # 80008518 <etext+0x518>
    8000379e:	34c020ef          	jal	80005aea <panic>
    return -1;
    800037a2:	57fd                	li	a5,-1
    800037a4:	893e                	mv	s2,a5
    800037a6:	b76d                	j	80003750 <fileread+0x58>
      return -1;
    800037a8:	57fd                	li	a5,-1
    800037aa:	893e                	mv	s2,a5
    800037ac:	64e2                	ld	s1,24(sp)
    800037ae:	69a2                	ld	s3,8(sp)
    800037b0:	b745                	j	80003750 <fileread+0x58>
    800037b2:	57fd                	li	a5,-1
    800037b4:	893e                	mv	s2,a5
    800037b6:	64e2                	ld	s1,24(sp)
    800037b8:	69a2                	ld	s3,8(sp)
    800037ba:	bf59                	j	80003750 <fileread+0x58>

00000000800037bc <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800037bc:	00954783          	lbu	a5,9(a0)
    800037c0:	10078f63          	beqz	a5,800038de <filewrite+0x122>
{
    800037c4:	711d                	addi	sp,sp,-96
    800037c6:	ec86                	sd	ra,88(sp)
    800037c8:	e8a2                	sd	s0,80(sp)
    800037ca:	e0ca                	sd	s2,64(sp)
    800037cc:	f456                	sd	s5,40(sp)
    800037ce:	f05a                	sd	s6,32(sp)
    800037d0:	1080                	addi	s0,sp,96
    800037d2:	892a                	mv	s2,a0
    800037d4:	8b2e                	mv	s6,a1
    800037d6:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800037d8:	411c                	lw	a5,0(a0)
    800037da:	4705                	li	a4,1
    800037dc:	02e78a63          	beq	a5,a4,80003810 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037e0:	470d                	li	a4,3
    800037e2:	02e78b63          	beq	a5,a4,80003818 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800037e6:	4709                	li	a4,2
    800037e8:	0ce79f63          	bne	a5,a4,800038c6 <filewrite+0x10a>
    800037ec:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800037ee:	0ac05a63          	blez	a2,800038a2 <filewrite+0xe6>
    800037f2:	e4a6                	sd	s1,72(sp)
    800037f4:	fc4e                	sd	s3,56(sp)
    800037f6:	ec5e                	sd	s7,24(sp)
    800037f8:	e862                	sd	s8,16(sp)
    800037fa:	e466                	sd	s9,8(sp)
    int i = 0;
    800037fc:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800037fe:	6b85                	lui	s7,0x1
    80003800:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003804:	6785                	lui	a5,0x1
    80003806:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000380a:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000380c:	4c05                	li	s8,1
    8000380e:	a8ad                	j	80003888 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003810:	6908                	ld	a0,16(a0)
    80003812:	20a000ef          	jal	80003a1c <pipewrite>
    80003816:	a04d                	j	800038b8 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003818:	02451783          	lh	a5,36(a0)
    8000381c:	03079693          	slli	a3,a5,0x30
    80003820:	92c1                	srli	a3,a3,0x30
    80003822:	4725                	li	a4,9
    80003824:	0ad76f63          	bltu	a4,a3,800038e2 <filewrite+0x126>
    80003828:	0792                	slli	a5,a5,0x4
    8000382a:	00016717          	auipc	a4,0x16
    8000382e:	d0670713          	addi	a4,a4,-762 # 80019530 <devsw>
    80003832:	97ba                	add	a5,a5,a4
    80003834:	679c                	ld	a5,8(a5)
    80003836:	cbc5                	beqz	a5,800038e6 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80003838:	4505                	li	a0,1
    8000383a:	9782                	jalr	a5
    8000383c:	a8b5                	j	800038b8 <filewrite+0xfc>
      if(n1 > max)
    8000383e:	2981                	sext.w	s3,s3
      begin_op();
    80003840:	971ff0ef          	jal	800031b0 <begin_op>
      ilock(f->ip);
    80003844:	01893503          	ld	a0,24(s2)
    80003848:	f51fe0ef          	jal	80002798 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000384c:	874e                	mv	a4,s3
    8000384e:	02092683          	lw	a3,32(s2)
    80003852:	016a0633          	add	a2,s4,s6
    80003856:	85e2                	mv	a1,s8
    80003858:	01893503          	ld	a0,24(s2)
    8000385c:	bccff0ef          	jal	80002c28 <writei>
    80003860:	84aa                	mv	s1,a0
    80003862:	00a05763          	blez	a0,80003870 <filewrite+0xb4>
        f->off += r;
    80003866:	02092783          	lw	a5,32(s2)
    8000386a:	9fa9                	addw	a5,a5,a0
    8000386c:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003870:	01893503          	ld	a0,24(s2)
    80003874:	fd9fe0ef          	jal	8000284c <iunlock>
      end_op();
    80003878:	9a9ff0ef          	jal	80003220 <end_op>

      if(r != n1){
    8000387c:	02999563          	bne	s3,s1,800038a6 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80003880:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003884:	015a5963          	bge	s4,s5,80003896 <filewrite+0xda>
      int n1 = n - i;
    80003888:	414a87bb          	subw	a5,s5,s4
    8000388c:	89be                	mv	s3,a5
      if(n1 > max)
    8000388e:	fafbd8e3          	bge	s7,a5,8000383e <filewrite+0x82>
    80003892:	89e6                	mv	s3,s9
    80003894:	b76d                	j	8000383e <filewrite+0x82>
    80003896:	64a6                	ld	s1,72(sp)
    80003898:	79e2                	ld	s3,56(sp)
    8000389a:	6be2                	ld	s7,24(sp)
    8000389c:	6c42                	ld	s8,16(sp)
    8000389e:	6ca2                	ld	s9,8(sp)
    800038a0:	a801                	j	800038b0 <filewrite+0xf4>
    int i = 0;
    800038a2:	4a01                	li	s4,0
    800038a4:	a031                	j	800038b0 <filewrite+0xf4>
    800038a6:	64a6                	ld	s1,72(sp)
    800038a8:	79e2                	ld	s3,56(sp)
    800038aa:	6be2                	ld	s7,24(sp)
    800038ac:	6c42                	ld	s8,16(sp)
    800038ae:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800038b0:	034a9d63          	bne	s5,s4,800038ea <filewrite+0x12e>
    800038b4:	8556                	mv	a0,s5
    800038b6:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800038b8:	60e6                	ld	ra,88(sp)
    800038ba:	6446                	ld	s0,80(sp)
    800038bc:	6906                	ld	s2,64(sp)
    800038be:	7aa2                	ld	s5,40(sp)
    800038c0:	7b02                	ld	s6,32(sp)
    800038c2:	6125                	addi	sp,sp,96
    800038c4:	8082                	ret
    800038c6:	e4a6                	sd	s1,72(sp)
    800038c8:	fc4e                	sd	s3,56(sp)
    800038ca:	f852                	sd	s4,48(sp)
    800038cc:	ec5e                	sd	s7,24(sp)
    800038ce:	e862                	sd	s8,16(sp)
    800038d0:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800038d2:	00005517          	auipc	a0,0x5
    800038d6:	c5650513          	addi	a0,a0,-938 # 80008528 <etext+0x528>
    800038da:	210020ef          	jal	80005aea <panic>
    return -1;
    800038de:	557d                	li	a0,-1
}
    800038e0:	8082                	ret
      return -1;
    800038e2:	557d                	li	a0,-1
    800038e4:	bfd1                	j	800038b8 <filewrite+0xfc>
    800038e6:	557d                	li	a0,-1
    800038e8:	bfc1                	j	800038b8 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800038ea:	557d                	li	a0,-1
    800038ec:	7a42                	ld	s4,48(sp)
    800038ee:	b7e9                	j	800038b8 <filewrite+0xfc>

00000000800038f0 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800038f0:	7179                	addi	sp,sp,-48
    800038f2:	f406                	sd	ra,40(sp)
    800038f4:	f022                	sd	s0,32(sp)
    800038f6:	ec26                	sd	s1,24(sp)
    800038f8:	e052                	sd	s4,0(sp)
    800038fa:	1800                	addi	s0,sp,48
    800038fc:	84aa                	mv	s1,a0
    800038fe:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003900:	0005b023          	sd	zero,0(a1)
    80003904:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003908:	c29ff0ef          	jal	80003530 <filealloc>
    8000390c:	e088                	sd	a0,0(s1)
    8000390e:	c549                	beqz	a0,80003998 <pipealloc+0xa8>
    80003910:	c21ff0ef          	jal	80003530 <filealloc>
    80003914:	00aa3023          	sd	a0,0(s4)
    80003918:	cd25                	beqz	a0,80003990 <pipealloc+0xa0>
    8000391a:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    8000391c:	82dfc0ef          	jal	80000148 <kalloc>
    80003920:	892a                	mv	s2,a0
    80003922:	c12d                	beqz	a0,80003984 <pipealloc+0x94>
    80003924:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003926:	4985                	li	s3,1
    80003928:	23352423          	sw	s3,552(a0)
  pi->writeopen = 1;
    8000392c:	23352623          	sw	s3,556(a0)
  pi->nwrite = 0;
    80003930:	22052223          	sw	zero,548(a0)
  pi->nread = 0;
    80003934:	22052023          	sw	zero,544(a0)
  initlock(&pi->lock, "pipe");
    80003938:	00005597          	auipc	a1,0x5
    8000393c:	c0058593          	addi	a1,a1,-1024 # 80008538 <etext+0x538>
    80003940:	656020ef          	jal	80005f96 <initlock>
  (*f0)->type = FD_PIPE;
    80003944:	609c                	ld	a5,0(s1)
    80003946:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000394a:	609c                	ld	a5,0(s1)
    8000394c:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003950:	609c                	ld	a5,0(s1)
    80003952:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003956:	609c                	ld	a5,0(s1)
    80003958:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    8000395c:	000a3783          	ld	a5,0(s4)
    80003960:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003964:	000a3783          	ld	a5,0(s4)
    80003968:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    8000396c:	000a3783          	ld	a5,0(s4)
    80003970:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003974:	000a3783          	ld	a5,0(s4)
    80003978:	0127b823          	sd	s2,16(a5)
  return 0;
    8000397c:	4501                	li	a0,0
    8000397e:	6942                	ld	s2,16(sp)
    80003980:	69a2                	ld	s3,8(sp)
    80003982:	a01d                	j	800039a8 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003984:	6088                	ld	a0,0(s1)
    80003986:	c119                	beqz	a0,8000398c <pipealloc+0x9c>
    80003988:	6942                	ld	s2,16(sp)
    8000398a:	a029                	j	80003994 <pipealloc+0xa4>
    8000398c:	6942                	ld	s2,16(sp)
    8000398e:	a029                	j	80003998 <pipealloc+0xa8>
    80003990:	6088                	ld	a0,0(s1)
    80003992:	c10d                	beqz	a0,800039b4 <pipealloc+0xc4>
    fileclose(*f0);
    80003994:	c41ff0ef          	jal	800035d4 <fileclose>
  if(*f1)
    80003998:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    8000399c:	557d                	li	a0,-1
  if(*f1)
    8000399e:	c789                	beqz	a5,800039a8 <pipealloc+0xb8>
    fileclose(*f1);
    800039a0:	853e                	mv	a0,a5
    800039a2:	c33ff0ef          	jal	800035d4 <fileclose>
  return -1;
    800039a6:	557d                	li	a0,-1
}
    800039a8:	70a2                	ld	ra,40(sp)
    800039aa:	7402                	ld	s0,32(sp)
    800039ac:	64e2                	ld	s1,24(sp)
    800039ae:	6a02                	ld	s4,0(sp)
    800039b0:	6145                	addi	sp,sp,48
    800039b2:	8082                	ret
  return -1;
    800039b4:	557d                	li	a0,-1
    800039b6:	bfcd                	j	800039a8 <pipealloc+0xb8>

00000000800039b8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800039b8:	1101                	addi	sp,sp,-32
    800039ba:	ec06                	sd	ra,24(sp)
    800039bc:	e822                	sd	s0,16(sp)
    800039be:	e426                	sd	s1,8(sp)
    800039c0:	e04a                	sd	s2,0(sp)
    800039c2:	1000                	addi	s0,sp,32
    800039c4:	84aa                	mv	s1,a0
    800039c6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800039c8:	44e020ef          	jal	80005e16 <acquire>
  if(writable){
    800039cc:	02090763          	beqz	s2,800039fa <pipeclose+0x42>
    pi->writeopen = 0;
    800039d0:	2204a623          	sw	zero,556(s1)
    wakeup(&pi->nread);
    800039d4:	22048513          	addi	a0,s1,544
    800039d8:	aeffd0ef          	jal	800014c6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800039dc:	2284a783          	lw	a5,552(s1)
    800039e0:	e781                	bnez	a5,800039e8 <pipeclose+0x30>
    800039e2:	22c4a783          	lw	a5,556(s1)
    800039e6:	c38d                	beqz	a5,80003a08 <pipeclose+0x50>
#ifdef LAB_LOCK
    freelock(&pi->lock);
#endif    
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800039e8:	8526                	mv	a0,s1
    800039ea:	514020ef          	jal	80005efe <release>
}
    800039ee:	60e2                	ld	ra,24(sp)
    800039f0:	6442                	ld	s0,16(sp)
    800039f2:	64a2                	ld	s1,8(sp)
    800039f4:	6902                	ld	s2,0(sp)
    800039f6:	6105                	addi	sp,sp,32
    800039f8:	8082                	ret
    pi->readopen = 0;
    800039fa:	2204a423          	sw	zero,552(s1)
    wakeup(&pi->nwrite);
    800039fe:	22448513          	addi	a0,s1,548
    80003a02:	ac5fd0ef          	jal	800014c6 <wakeup>
    80003a06:	bfd9                	j	800039dc <pipeclose+0x24>
    release(&pi->lock);
    80003a08:	8526                	mv	a0,s1
    80003a0a:	4f4020ef          	jal	80005efe <release>
    freelock(&pi->lock);
    80003a0e:	8526                	mv	a0,s1
    80003a10:	52a020ef          	jal	80005f3a <freelock>
    kfree((char*)pi);
    80003a14:	8526                	mv	a0,s1
    80003a16:	e06fc0ef          	jal	8000001c <kfree>
    80003a1a:	bfd1                	j	800039ee <pipeclose+0x36>

0000000080003a1c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003a1c:	7159                	addi	sp,sp,-112
    80003a1e:	f486                	sd	ra,104(sp)
    80003a20:	f0a2                	sd	s0,96(sp)
    80003a22:	eca6                	sd	s1,88(sp)
    80003a24:	e8ca                	sd	s2,80(sp)
    80003a26:	e4ce                	sd	s3,72(sp)
    80003a28:	e0d2                	sd	s4,64(sp)
    80003a2a:	fc56                	sd	s5,56(sp)
    80003a2c:	1880                	addi	s0,sp,112
    80003a2e:	84aa                	mv	s1,a0
    80003a30:	8aae                	mv	s5,a1
    80003a32:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003a34:	c1cfd0ef          	jal	80000e50 <myproc>
    80003a38:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003a3a:	8526                	mv	a0,s1
    80003a3c:	3da020ef          	jal	80005e16 <acquire>
  while(i < n){
    80003a40:	0d405263          	blez	s4,80003b04 <pipewrite+0xe8>
    80003a44:	f85a                	sd	s6,48(sp)
    80003a46:	f45e                	sd	s7,40(sp)
    80003a48:	f062                	sd	s8,32(sp)
    80003a4a:	ec66                	sd	s9,24(sp)
    80003a4c:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003a4e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a50:	f9f40c13          	addi	s8,s0,-97
    80003a54:	4b85                	li	s7,1
    80003a56:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003a58:	22048d13          	addi	s10,s1,544
      sleep(&pi->nwrite, &pi->lock);
    80003a5c:	22448c93          	addi	s9,s1,548
    80003a60:	a82d                	j	80003a9a <pipewrite+0x7e>
      release(&pi->lock);
    80003a62:	8526                	mv	a0,s1
    80003a64:	49a020ef          	jal	80005efe <release>
      return -1;
    80003a68:	597d                	li	s2,-1
    80003a6a:	7b42                	ld	s6,48(sp)
    80003a6c:	7ba2                	ld	s7,40(sp)
    80003a6e:	7c02                	ld	s8,32(sp)
    80003a70:	6ce2                	ld	s9,24(sp)
    80003a72:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003a74:	854a                	mv	a0,s2
    80003a76:	70a6                	ld	ra,104(sp)
    80003a78:	7406                	ld	s0,96(sp)
    80003a7a:	64e6                	ld	s1,88(sp)
    80003a7c:	6946                	ld	s2,80(sp)
    80003a7e:	69a6                	ld	s3,72(sp)
    80003a80:	6a06                	ld	s4,64(sp)
    80003a82:	7ae2                	ld	s5,56(sp)
    80003a84:	6165                	addi	sp,sp,112
    80003a86:	8082                	ret
      wakeup(&pi->nread);
    80003a88:	856a                	mv	a0,s10
    80003a8a:	a3dfd0ef          	jal	800014c6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003a8e:	85a6                	mv	a1,s1
    80003a90:	8566                	mv	a0,s9
    80003a92:	9e9fd0ef          	jal	8000147a <sleep>
  while(i < n){
    80003a96:	05495a63          	bge	s2,s4,80003aea <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003a9a:	2284a783          	lw	a5,552(s1)
    80003a9e:	d3f1                	beqz	a5,80003a62 <pipewrite+0x46>
    80003aa0:	854e                	mv	a0,s3
    80003aa2:	c15fd0ef          	jal	800016b6 <killed>
    80003aa6:	fd55                	bnez	a0,80003a62 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003aa8:	2204a783          	lw	a5,544(s1)
    80003aac:	2244a703          	lw	a4,548(s1)
    80003ab0:	2007879b          	addiw	a5,a5,512
    80003ab4:	fcf70ae3          	beq	a4,a5,80003a88 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003ab8:	86de                	mv	a3,s7
    80003aba:	01590633          	add	a2,s2,s5
    80003abe:	85e2                	mv	a1,s8
    80003ac0:	0589b503          	ld	a0,88(s3)
    80003ac4:	97cfd0ef          	jal	80000c40 <copyin>
    80003ac8:	05650063          	beq	a0,s6,80003b08 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003acc:	2244a783          	lw	a5,548(s1)
    80003ad0:	0017871b          	addiw	a4,a5,1
    80003ad4:	22e4a223          	sw	a4,548(s1)
    80003ad8:	1ff7f793          	andi	a5,a5,511
    80003adc:	97a6                	add	a5,a5,s1
    80003ade:	f9f44703          	lbu	a4,-97(s0)
    80003ae2:	02e78023          	sb	a4,32(a5)
      i++;
    80003ae6:	2905                	addiw	s2,s2,1
    80003ae8:	b77d                	j	80003a96 <pipewrite+0x7a>
    80003aea:	7b42                	ld	s6,48(sp)
    80003aec:	7ba2                	ld	s7,40(sp)
    80003aee:	7c02                	ld	s8,32(sp)
    80003af0:	6ce2                	ld	s9,24(sp)
    80003af2:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003af4:	22048513          	addi	a0,s1,544
    80003af8:	9cffd0ef          	jal	800014c6 <wakeup>
  release(&pi->lock);
    80003afc:	8526                	mv	a0,s1
    80003afe:	400020ef          	jal	80005efe <release>
  return i;
    80003b02:	bf8d                	j	80003a74 <pipewrite+0x58>
  int i = 0;
    80003b04:	4901                	li	s2,0
    80003b06:	b7fd                	j	80003af4 <pipewrite+0xd8>
    80003b08:	7b42                	ld	s6,48(sp)
    80003b0a:	7ba2                	ld	s7,40(sp)
    80003b0c:	7c02                	ld	s8,32(sp)
    80003b0e:	6ce2                	ld	s9,24(sp)
    80003b10:	6d42                	ld	s10,16(sp)
    80003b12:	b7cd                	j	80003af4 <pipewrite+0xd8>

0000000080003b14 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003b14:	711d                	addi	sp,sp,-96
    80003b16:	ec86                	sd	ra,88(sp)
    80003b18:	e8a2                	sd	s0,80(sp)
    80003b1a:	e4a6                	sd	s1,72(sp)
    80003b1c:	e0ca                	sd	s2,64(sp)
    80003b1e:	fc4e                	sd	s3,56(sp)
    80003b20:	f852                	sd	s4,48(sp)
    80003b22:	f456                	sd	s5,40(sp)
    80003b24:	1080                	addi	s0,sp,96
    80003b26:	84aa                	mv	s1,a0
    80003b28:	892e                	mv	s2,a1
    80003b2a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003b2c:	b24fd0ef          	jal	80000e50 <myproc>
    80003b30:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003b32:	8526                	mv	a0,s1
    80003b34:	2e2020ef          	jal	80005e16 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b38:	2204a703          	lw	a4,544(s1)
    80003b3c:	2244a783          	lw	a5,548(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b40:	22048993          	addi	s3,s1,544
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b44:	02f71763          	bne	a4,a5,80003b72 <piperead+0x5e>
    80003b48:	22c4a783          	lw	a5,556(s1)
    80003b4c:	cf85                	beqz	a5,80003b84 <piperead+0x70>
    if(killed(pr)){
    80003b4e:	8552                	mv	a0,s4
    80003b50:	b67fd0ef          	jal	800016b6 <killed>
    80003b54:	e11d                	bnez	a0,80003b7a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b56:	85a6                	mv	a1,s1
    80003b58:	854e                	mv	a0,s3
    80003b5a:	921fd0ef          	jal	8000147a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b5e:	2204a703          	lw	a4,544(s1)
    80003b62:	2244a783          	lw	a5,548(s1)
    80003b66:	fef701e3          	beq	a4,a5,80003b48 <piperead+0x34>
    80003b6a:	f05a                	sd	s6,32(sp)
    80003b6c:	ec5e                	sd	s7,24(sp)
    80003b6e:	e862                	sd	s8,16(sp)
    80003b70:	a829                	j	80003b8a <piperead+0x76>
    80003b72:	f05a                	sd	s6,32(sp)
    80003b74:	ec5e                	sd	s7,24(sp)
    80003b76:	e862                	sd	s8,16(sp)
    80003b78:	a809                	j	80003b8a <piperead+0x76>
      release(&pi->lock);
    80003b7a:	8526                	mv	a0,s1
    80003b7c:	382020ef          	jal	80005efe <release>
      return -1;
    80003b80:	59fd                	li	s3,-1
    80003b82:	a09d                	j	80003be8 <piperead+0xd4>
    80003b84:	f05a                	sd	s6,32(sp)
    80003b86:	ec5e                	sd	s7,24(sp)
    80003b88:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b8a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b8c:	faf40c13          	addi	s8,s0,-81
    80003b90:	4b85                	li	s7,1
    80003b92:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b94:	05505063          	blez	s5,80003bd4 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003b98:	2204a783          	lw	a5,544(s1)
    80003b9c:	2244a703          	lw	a4,548(s1)
    80003ba0:	02f70a63          	beq	a4,a5,80003bd4 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ba4:	0017871b          	addiw	a4,a5,1
    80003ba8:	22e4a023          	sw	a4,544(s1)
    80003bac:	1ff7f793          	andi	a5,a5,511
    80003bb0:	97a6                	add	a5,a5,s1
    80003bb2:	0207c783          	lbu	a5,32(a5)
    80003bb6:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003bba:	86de                	mv	a3,s7
    80003bbc:	8662                	mv	a2,s8
    80003bbe:	85ca                	mv	a1,s2
    80003bc0:	058a3503          	ld	a0,88(s4)
    80003bc4:	fbffc0ef          	jal	80000b82 <copyout>
    80003bc8:	01650663          	beq	a0,s6,80003bd4 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003bcc:	2985                	addiw	s3,s3,1
    80003bce:	0905                	addi	s2,s2,1
    80003bd0:	fd3a94e3          	bne	s5,s3,80003b98 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003bd4:	22448513          	addi	a0,s1,548
    80003bd8:	8effd0ef          	jal	800014c6 <wakeup>
  release(&pi->lock);
    80003bdc:	8526                	mv	a0,s1
    80003bde:	320020ef          	jal	80005efe <release>
    80003be2:	7b02                	ld	s6,32(sp)
    80003be4:	6be2                	ld	s7,24(sp)
    80003be6:	6c42                	ld	s8,16(sp)
  return i;
}
    80003be8:	854e                	mv	a0,s3
    80003bea:	60e6                	ld	ra,88(sp)
    80003bec:	6446                	ld	s0,80(sp)
    80003bee:	64a6                	ld	s1,72(sp)
    80003bf0:	6906                	ld	s2,64(sp)
    80003bf2:	79e2                	ld	s3,56(sp)
    80003bf4:	7a42                	ld	s4,48(sp)
    80003bf6:	7aa2                	ld	s5,40(sp)
    80003bf8:	6125                	addi	sp,sp,96
    80003bfa:	8082                	ret

0000000080003bfc <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003bfc:	1141                	addi	sp,sp,-16
    80003bfe:	e406                	sd	ra,8(sp)
    80003c00:	e022                	sd	s0,0(sp)
    80003c02:	0800                	addi	s0,sp,16
    80003c04:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003c06:	0035151b          	slliw	a0,a0,0x3
    80003c0a:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003c0c:	8b89                	andi	a5,a5,2
    80003c0e:	c399                	beqz	a5,80003c14 <flags2perm+0x18>
      perm |= PTE_W;
    80003c10:	00456513          	ori	a0,a0,4
    return perm;
}
    80003c14:	60a2                	ld	ra,8(sp)
    80003c16:	6402                	ld	s0,0(sp)
    80003c18:	0141                	addi	sp,sp,16
    80003c1a:	8082                	ret

0000000080003c1c <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003c1c:	de010113          	addi	sp,sp,-544
    80003c20:	20113c23          	sd	ra,536(sp)
    80003c24:	20813823          	sd	s0,528(sp)
    80003c28:	20913423          	sd	s1,520(sp)
    80003c2c:	21213023          	sd	s2,512(sp)
    80003c30:	1400                	addi	s0,sp,544
    80003c32:	892a                	mv	s2,a0
    80003c34:	dea43823          	sd	a0,-528(s0)
    80003c38:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003c3c:	a14fd0ef          	jal	80000e50 <myproc>
    80003c40:	84aa                	mv	s1,a0

  begin_op();
    80003c42:	d6eff0ef          	jal	800031b0 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003c46:	854a                	mv	a0,s2
    80003c48:	b8aff0ef          	jal	80002fd2 <namei>
    80003c4c:	cd21                	beqz	a0,80003ca4 <kexec+0x88>
    80003c4e:	fbd2                	sd	s4,496(sp)
    80003c50:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003c52:	b47fe0ef          	jal	80002798 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003c56:	04000713          	li	a4,64
    80003c5a:	4681                	li	a3,0
    80003c5c:	e5040613          	addi	a2,s0,-432
    80003c60:	4581                	li	a1,0
    80003c62:	8552                	mv	a0,s4
    80003c64:	ed3fe0ef          	jal	80002b36 <readi>
    80003c68:	04000793          	li	a5,64
    80003c6c:	00f51a63          	bne	a0,a5,80003c80 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003c70:	e5042703          	lw	a4,-432(s0)
    80003c74:	464c47b7          	lui	a5,0x464c4
    80003c78:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003c7c:	02f70863          	beq	a4,a5,80003cac <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003c80:	8552                	mv	a0,s4
    80003c82:	d2ffe0ef          	jal	800029b0 <iunlockput>
    end_op();
    80003c86:	d9aff0ef          	jal	80003220 <end_op>
  }
  return -1;
    80003c8a:	557d                	li	a0,-1
    80003c8c:	7a5e                	ld	s4,496(sp)
}
    80003c8e:	21813083          	ld	ra,536(sp)
    80003c92:	21013403          	ld	s0,528(sp)
    80003c96:	20813483          	ld	s1,520(sp)
    80003c9a:	20013903          	ld	s2,512(sp)
    80003c9e:	22010113          	addi	sp,sp,544
    80003ca2:	8082                	ret
    end_op();
    80003ca4:	d7cff0ef          	jal	80003220 <end_op>
    return -1;
    80003ca8:	557d                	li	a0,-1
    80003caa:	b7d5                	j	80003c8e <kexec+0x72>
    80003cac:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003cae:	8526                	mv	a0,s1
    80003cb0:	aaafd0ef          	jal	80000f5a <proc_pagetable>
    80003cb4:	8b2a                	mv	s6,a0
    80003cb6:	26050f63          	beqz	a0,80003f34 <kexec+0x318>
    80003cba:	ffce                	sd	s3,504(sp)
    80003cbc:	f7d6                	sd	s5,488(sp)
    80003cbe:	efde                	sd	s7,472(sp)
    80003cc0:	ebe2                	sd	s8,464(sp)
    80003cc2:	e7e6                	sd	s9,456(sp)
    80003cc4:	e3ea                	sd	s10,448(sp)
    80003cc6:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cc8:	e8845783          	lhu	a5,-376(s0)
    80003ccc:	0e078963          	beqz	a5,80003dbe <kexec+0x1a2>
    80003cd0:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003cd4:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cd6:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003cd8:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003cdc:	6c85                	lui	s9,0x1
    80003cde:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003ce2:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003ce6:	6a85                	lui	s5,0x1
    80003ce8:	a085                	j	80003d48 <kexec+0x12c>
      panic("loadseg: address should exist");
    80003cea:	00005517          	auipc	a0,0x5
    80003cee:	85650513          	addi	a0,a0,-1962 # 80008540 <etext+0x540>
    80003cf2:	5f9010ef          	jal	80005aea <panic>
    if(sz - i < PGSIZE)
    80003cf6:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003cf8:	874a                	mv	a4,s2
    80003cfa:	009b86bb          	addw	a3,s7,s1
    80003cfe:	4581                	li	a1,0
    80003d00:	8552                	mv	a0,s4
    80003d02:	e35fe0ef          	jal	80002b36 <readi>
    80003d06:	22a91b63          	bne	s2,a0,80003f3c <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80003d0a:	009a84bb          	addw	s1,s5,s1
    80003d0e:	0334f263          	bgeu	s1,s3,80003d32 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003d12:	02049593          	slli	a1,s1,0x20
    80003d16:	9181                	srli	a1,a1,0x20
    80003d18:	95e2                	add	a1,a1,s8
    80003d1a:	855a                	mv	a0,s6
    80003d1c:	839fc0ef          	jal	80000554 <walkaddr>
    80003d20:	862a                	mv	a2,a0
    if(pa == 0)
    80003d22:	d561                	beqz	a0,80003cea <kexec+0xce>
    if(sz - i < PGSIZE)
    80003d24:	409987bb          	subw	a5,s3,s1
    80003d28:	893e                	mv	s2,a5
    80003d2a:	fcfcf6e3          	bgeu	s9,a5,80003cf6 <kexec+0xda>
    80003d2e:	8956                	mv	s2,s5
    80003d30:	b7d9                	j	80003cf6 <kexec+0xda>
    sz = sz1;
    80003d32:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d36:	2d05                	addiw	s10,s10,1
    80003d38:	e0843783          	ld	a5,-504(s0)
    80003d3c:	0387869b          	addiw	a3,a5,56
    80003d40:	e8845783          	lhu	a5,-376(s0)
    80003d44:	06fd5e63          	bge	s10,a5,80003dc0 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d48:	e0d43423          	sd	a3,-504(s0)
    80003d4c:	876e                	mv	a4,s11
    80003d4e:	e1840613          	addi	a2,s0,-488
    80003d52:	4581                	li	a1,0
    80003d54:	8552                	mv	a0,s4
    80003d56:	de1fe0ef          	jal	80002b36 <readi>
    80003d5a:	1db51f63          	bne	a0,s11,80003f38 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80003d5e:	e1842783          	lw	a5,-488(s0)
    80003d62:	4705                	li	a4,1
    80003d64:	fce799e3          	bne	a5,a4,80003d36 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003d68:	e4043483          	ld	s1,-448(s0)
    80003d6c:	e3843783          	ld	a5,-456(s0)
    80003d70:	1ef4e463          	bltu	s1,a5,80003f58 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d74:	e2843783          	ld	a5,-472(s0)
    80003d78:	94be                	add	s1,s1,a5
    80003d7a:	1ef4e263          	bltu	s1,a5,80003f5e <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80003d7e:	de843703          	ld	a4,-536(s0)
    80003d82:	8ff9                	and	a5,a5,a4
    80003d84:	1e079063          	bnez	a5,80003f64 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d88:	e1c42503          	lw	a0,-484(s0)
    80003d8c:	e71ff0ef          	jal	80003bfc <flags2perm>
    80003d90:	86aa                	mv	a3,a0
    80003d92:	8626                	mv	a2,s1
    80003d94:	85ca                	mv	a1,s2
    80003d96:	855a                	mv	a0,s6
    80003d98:	a93fc0ef          	jal	8000082a <uvmalloc>
    80003d9c:	dea43c23          	sd	a0,-520(s0)
    80003da0:	1c050563          	beqz	a0,80003f6a <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003da4:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003da8:	00098863          	beqz	s3,80003db8 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003dac:	e2843c03          	ld	s8,-472(s0)
    80003db0:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003db4:	4481                	li	s1,0
    80003db6:	bfb1                	j	80003d12 <kexec+0xf6>
    sz = sz1;
    80003db8:	df843903          	ld	s2,-520(s0)
    80003dbc:	bfad                	j	80003d36 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003dbe:	4901                	li	s2,0
  iunlockput(ip);
    80003dc0:	8552                	mv	a0,s4
    80003dc2:	beffe0ef          	jal	800029b0 <iunlockput>
  end_op();
    80003dc6:	c5aff0ef          	jal	80003220 <end_op>
  p = myproc();
    80003dca:	886fd0ef          	jal	80000e50 <myproc>
    80003dce:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003dd0:	05053d03          	ld	s10,80(a0)
  sz = PGROUNDUP(sz);
    80003dd4:	6985                	lui	s3,0x1
    80003dd6:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003dd8:	99ca                	add	s3,s3,s2
    80003dda:	77fd                	lui	a5,0xfffff
    80003ddc:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003de0:	4691                	li	a3,4
    80003de2:	6609                	lui	a2,0x2
    80003de4:	964e                	add	a2,a2,s3
    80003de6:	85ce                	mv	a1,s3
    80003de8:	855a                	mv	a0,s6
    80003dea:	a41fc0ef          	jal	8000082a <uvmalloc>
    80003dee:	8a2a                	mv	s4,a0
    80003df0:	e105                	bnez	a0,80003e10 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003df2:	85ce                	mv	a1,s3
    80003df4:	855a                	mv	a0,s6
    80003df6:	9e8fd0ef          	jal	80000fde <proc_freepagetable>
  return -1;
    80003dfa:	557d                	li	a0,-1
    80003dfc:	79fe                	ld	s3,504(sp)
    80003dfe:	7a5e                	ld	s4,496(sp)
    80003e00:	7abe                	ld	s5,488(sp)
    80003e02:	7b1e                	ld	s6,480(sp)
    80003e04:	6bfe                	ld	s7,472(sp)
    80003e06:	6c5e                	ld	s8,464(sp)
    80003e08:	6cbe                	ld	s9,456(sp)
    80003e0a:	6d1e                	ld	s10,448(sp)
    80003e0c:	7dfa                	ld	s11,440(sp)
    80003e0e:	b541                	j	80003c8e <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003e10:	75f9                	lui	a1,0xffffe
    80003e12:	95aa                	add	a1,a1,a0
    80003e14:	855a                	mv	a0,s6
    80003e16:	be7fc0ef          	jal	800009fc <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003e1a:	800a0b93          	addi	s7,s4,-2048
    80003e1e:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80003e22:	e0043783          	ld	a5,-512(s0)
    80003e26:	6388                	ld	a0,0(a5)
  sp = sz;
    80003e28:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003e2a:	4481                	li	s1,0
    ustack[argc] = sp;
    80003e2c:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003e30:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003e34:	cd21                	beqz	a0,80003e8c <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80003e36:	d72fc0ef          	jal	800003a8 <strlen>
    80003e3a:	0015079b          	addiw	a5,a0,1
    80003e3e:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e42:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003e46:	13796563          	bltu	s2,s7,80003f70 <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003e4a:	e0043d83          	ld	s11,-512(s0)
    80003e4e:	000db983          	ld	s3,0(s11)
    80003e52:	854e                	mv	a0,s3
    80003e54:	d54fc0ef          	jal	800003a8 <strlen>
    80003e58:	0015069b          	addiw	a3,a0,1
    80003e5c:	864e                	mv	a2,s3
    80003e5e:	85ca                	mv	a1,s2
    80003e60:	855a                	mv	a0,s6
    80003e62:	d21fc0ef          	jal	80000b82 <copyout>
    80003e66:	10054763          	bltz	a0,80003f74 <kexec+0x358>
    ustack[argc] = sp;
    80003e6a:	00349793          	slli	a5,s1,0x3
    80003e6e:	97e6                	add	a5,a5,s9
    80003e70:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffda740>
  for(argc = 0; argv[argc]; argc++) {
    80003e74:	0485                	addi	s1,s1,1
    80003e76:	008d8793          	addi	a5,s11,8
    80003e7a:	e0f43023          	sd	a5,-512(s0)
    80003e7e:	008db503          	ld	a0,8(s11)
    80003e82:	c509                	beqz	a0,80003e8c <kexec+0x270>
    if(argc >= MAXARG)
    80003e84:	fb8499e3          	bne	s1,s8,80003e36 <kexec+0x21a>
  sz = sz1;
    80003e88:	89d2                	mv	s3,s4
    80003e8a:	b7a5                	j	80003df2 <kexec+0x1d6>
  ustack[argc] = 0;
    80003e8c:	00349793          	slli	a5,s1,0x3
    80003e90:	f9078793          	addi	a5,a5,-112
    80003e94:	97a2                	add	a5,a5,s0
    80003e96:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e9a:	00349693          	slli	a3,s1,0x3
    80003e9e:	06a1                	addi	a3,a3,8
    80003ea0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003ea4:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003ea8:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003eaa:	f57964e3          	bltu	s2,s7,80003df2 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003eae:	e9040613          	addi	a2,s0,-368
    80003eb2:	85ca                	mv	a1,s2
    80003eb4:	855a                	mv	a0,s6
    80003eb6:	ccdfc0ef          	jal	80000b82 <copyout>
    80003eba:	f2054ce3          	bltz	a0,80003df2 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80003ebe:	060ab783          	ld	a5,96(s5) # 1060 <_entry-0x7fffefa0>
    80003ec2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003ec6:	df043783          	ld	a5,-528(s0)
    80003eca:	0007c703          	lbu	a4,0(a5)
    80003ece:	cf11                	beqz	a4,80003eea <kexec+0x2ce>
    80003ed0:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003ed2:	02f00693          	li	a3,47
    80003ed6:	a029                	j	80003ee0 <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80003ed8:	0785                	addi	a5,a5,1
    80003eda:	fff7c703          	lbu	a4,-1(a5)
    80003ede:	c711                	beqz	a4,80003eea <kexec+0x2ce>
    if(*s == '/')
    80003ee0:	fed71ce3          	bne	a4,a3,80003ed8 <kexec+0x2bc>
      last = s+1;
    80003ee4:	def43823          	sd	a5,-528(s0)
    80003ee8:	bfc5                	j	80003ed8 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80003eea:	4641                	li	a2,16
    80003eec:	df043583          	ld	a1,-528(s0)
    80003ef0:	160a8513          	addi	a0,s5,352
    80003ef4:	c7efc0ef          	jal	80000372 <safestrcpy>
  oldpagetable = p->pagetable;
    80003ef8:	058ab503          	ld	a0,88(s5)
  p->pagetable = pagetable;
    80003efc:	056abc23          	sd	s6,88(s5)
  p->sz = sz;
    80003f00:	054ab823          	sd	s4,80(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80003f04:	060ab783          	ld	a5,96(s5)
    80003f08:	e6843703          	ld	a4,-408(s0)
    80003f0c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003f0e:	060ab783          	ld	a5,96(s5)
    80003f12:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003f16:	85ea                	mv	a1,s10
    80003f18:	8c6fd0ef          	jal	80000fde <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003f1c:	0004851b          	sext.w	a0,s1
    80003f20:	79fe                	ld	s3,504(sp)
    80003f22:	7a5e                	ld	s4,496(sp)
    80003f24:	7abe                	ld	s5,488(sp)
    80003f26:	7b1e                	ld	s6,480(sp)
    80003f28:	6bfe                	ld	s7,472(sp)
    80003f2a:	6c5e                	ld	s8,464(sp)
    80003f2c:	6cbe                	ld	s9,456(sp)
    80003f2e:	6d1e                	ld	s10,448(sp)
    80003f30:	7dfa                	ld	s11,440(sp)
    80003f32:	bbb1                	j	80003c8e <kexec+0x72>
    80003f34:	7b1e                	ld	s6,480(sp)
    80003f36:	b3a9                	j	80003c80 <kexec+0x64>
    80003f38:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003f3c:	df843583          	ld	a1,-520(s0)
    80003f40:	855a                	mv	a0,s6
    80003f42:	89cfd0ef          	jal	80000fde <proc_freepagetable>
  if(ip){
    80003f46:	79fe                	ld	s3,504(sp)
    80003f48:	7abe                	ld	s5,488(sp)
    80003f4a:	7b1e                	ld	s6,480(sp)
    80003f4c:	6bfe                	ld	s7,472(sp)
    80003f4e:	6c5e                	ld	s8,464(sp)
    80003f50:	6cbe                	ld	s9,456(sp)
    80003f52:	6d1e                	ld	s10,448(sp)
    80003f54:	7dfa                	ld	s11,440(sp)
    80003f56:	b32d                	j	80003c80 <kexec+0x64>
    80003f58:	df243c23          	sd	s2,-520(s0)
    80003f5c:	b7c5                	j	80003f3c <kexec+0x320>
    80003f5e:	df243c23          	sd	s2,-520(s0)
    80003f62:	bfe9                	j	80003f3c <kexec+0x320>
    80003f64:	df243c23          	sd	s2,-520(s0)
    80003f68:	bfd1                	j	80003f3c <kexec+0x320>
    80003f6a:	df243c23          	sd	s2,-520(s0)
    80003f6e:	b7f9                	j	80003f3c <kexec+0x320>
  sz = sz1;
    80003f70:	89d2                	mv	s3,s4
    80003f72:	b541                	j	80003df2 <kexec+0x1d6>
    80003f74:	89d2                	mv	s3,s4
    80003f76:	bdb5                	j	80003df2 <kexec+0x1d6>

0000000080003f78 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f78:	7179                	addi	sp,sp,-48
    80003f7a:	f406                	sd	ra,40(sp)
    80003f7c:	f022                	sd	s0,32(sp)
    80003f7e:	ec26                	sd	s1,24(sp)
    80003f80:	e84a                	sd	s2,16(sp)
    80003f82:	1800                	addi	s0,sp,48
    80003f84:	892e                	mv	s2,a1
    80003f86:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f88:	fdc40593          	addi	a1,s0,-36
    80003f8c:	dfbfd0ef          	jal	80001d86 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f90:	fdc42703          	lw	a4,-36(s0)
    80003f94:	47bd                	li	a5,15
    80003f96:	02e7ea63          	bltu	a5,a4,80003fca <argfd+0x52>
    80003f9a:	eb7fc0ef          	jal	80000e50 <myproc>
    80003f9e:	fdc42703          	lw	a4,-36(s0)
    80003fa2:	00371793          	slli	a5,a4,0x3
    80003fa6:	0d078793          	addi	a5,a5,208
    80003faa:	953e                	add	a0,a0,a5
    80003fac:	651c                	ld	a5,8(a0)
    80003fae:	c385                	beqz	a5,80003fce <argfd+0x56>
    return -1;
  if(pfd)
    80003fb0:	00090463          	beqz	s2,80003fb8 <argfd+0x40>
    *pfd = fd;
    80003fb4:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003fb8:	4501                	li	a0,0
  if(pf)
    80003fba:	c091                	beqz	s1,80003fbe <argfd+0x46>
    *pf = f;
    80003fbc:	e09c                	sd	a5,0(s1)
}
    80003fbe:	70a2                	ld	ra,40(sp)
    80003fc0:	7402                	ld	s0,32(sp)
    80003fc2:	64e2                	ld	s1,24(sp)
    80003fc4:	6942                	ld	s2,16(sp)
    80003fc6:	6145                	addi	sp,sp,48
    80003fc8:	8082                	ret
    return -1;
    80003fca:	557d                	li	a0,-1
    80003fcc:	bfcd                	j	80003fbe <argfd+0x46>
    80003fce:	557d                	li	a0,-1
    80003fd0:	b7fd                	j	80003fbe <argfd+0x46>

0000000080003fd2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003fd2:	1101                	addi	sp,sp,-32
    80003fd4:	ec06                	sd	ra,24(sp)
    80003fd6:	e822                	sd	s0,16(sp)
    80003fd8:	e426                	sd	s1,8(sp)
    80003fda:	1000                	addi	s0,sp,32
    80003fdc:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003fde:	e73fc0ef          	jal	80000e50 <myproc>
    80003fe2:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003fe4:	0d850793          	addi	a5,a0,216
    80003fe8:	4501                	li	a0,0
    80003fea:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003fec:	6398                	ld	a4,0(a5)
    80003fee:	cb19                	beqz	a4,80004004 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003ff0:	2505                	addiw	a0,a0,1
    80003ff2:	07a1                	addi	a5,a5,8
    80003ff4:	fed51ce3          	bne	a0,a3,80003fec <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003ff8:	557d                	li	a0,-1
}
    80003ffa:	60e2                	ld	ra,24(sp)
    80003ffc:	6442                	ld	s0,16(sp)
    80003ffe:	64a2                	ld	s1,8(sp)
    80004000:	6105                	addi	sp,sp,32
    80004002:	8082                	ret
      p->ofile[fd] = f;
    80004004:	00351793          	slli	a5,a0,0x3
    80004008:	0d078793          	addi	a5,a5,208
    8000400c:	963e                	add	a2,a2,a5
    8000400e:	e604                	sd	s1,8(a2)
      return fd;
    80004010:	b7ed                	j	80003ffa <fdalloc+0x28>

0000000080004012 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004012:	715d                	addi	sp,sp,-80
    80004014:	e486                	sd	ra,72(sp)
    80004016:	e0a2                	sd	s0,64(sp)
    80004018:	fc26                	sd	s1,56(sp)
    8000401a:	f84a                	sd	s2,48(sp)
    8000401c:	f44e                	sd	s3,40(sp)
    8000401e:	f052                	sd	s4,32(sp)
    80004020:	ec56                	sd	s5,24(sp)
    80004022:	e85a                	sd	s6,16(sp)
    80004024:	0880                	addi	s0,sp,80
    80004026:	892e                	mv	s2,a1
    80004028:	8a2e                	mv	s4,a1
    8000402a:	8ab2                	mv	s5,a2
    8000402c:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000402e:	fb040593          	addi	a1,s0,-80
    80004032:	fbbfe0ef          	jal	80002fec <nameiparent>
    80004036:	84aa                	mv	s1,a0
    80004038:	10050763          	beqz	a0,80004146 <create+0x134>
    return 0;

  ilock(dp);
    8000403c:	f5cfe0ef          	jal	80002798 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004040:	4601                	li	a2,0
    80004042:	fb040593          	addi	a1,s0,-80
    80004046:	8526                	mv	a0,s1
    80004048:	cf7fe0ef          	jal	80002d3e <dirlookup>
    8000404c:	89aa                	mv	s3,a0
    8000404e:	c131                	beqz	a0,80004092 <create+0x80>
    iunlockput(dp);
    80004050:	8526                	mv	a0,s1
    80004052:	95ffe0ef          	jal	800029b0 <iunlockput>
    ilock(ip);
    80004056:	854e                	mv	a0,s3
    80004058:	f40fe0ef          	jal	80002798 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000405c:	4789                	li	a5,2
    8000405e:	02f91563          	bne	s2,a5,80004088 <create+0x76>
    80004062:	04c9d783          	lhu	a5,76(s3)
    80004066:	37f9                	addiw	a5,a5,-2
    80004068:	17c2                	slli	a5,a5,0x30
    8000406a:	93c1                	srli	a5,a5,0x30
    8000406c:	4705                	li	a4,1
    8000406e:	00f76d63          	bltu	a4,a5,80004088 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004072:	854e                	mv	a0,s3
    80004074:	60a6                	ld	ra,72(sp)
    80004076:	6406                	ld	s0,64(sp)
    80004078:	74e2                	ld	s1,56(sp)
    8000407a:	7942                	ld	s2,48(sp)
    8000407c:	79a2                	ld	s3,40(sp)
    8000407e:	7a02                	ld	s4,32(sp)
    80004080:	6ae2                	ld	s5,24(sp)
    80004082:	6b42                	ld	s6,16(sp)
    80004084:	6161                	addi	sp,sp,80
    80004086:	8082                	ret
    iunlockput(ip);
    80004088:	854e                	mv	a0,s3
    8000408a:	927fe0ef          	jal	800029b0 <iunlockput>
    return 0;
    8000408e:	4981                	li	s3,0
    80004090:	b7cd                	j	80004072 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004092:	85ca                	mv	a1,s2
    80004094:	4088                	lw	a0,0(s1)
    80004096:	d92fe0ef          	jal	80002628 <ialloc>
    8000409a:	892a                	mv	s2,a0
    8000409c:	cd15                	beqz	a0,800040d8 <create+0xc6>
  ilock(ip);
    8000409e:	efafe0ef          	jal	80002798 <ilock>
  ip->major = major;
    800040a2:	05591723          	sh	s5,78(s2)
  ip->minor = minor;
    800040a6:	05691823          	sh	s6,80(s2)
  ip->nlink = 1;
    800040aa:	4785                	li	a5,1
    800040ac:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    800040b0:	854a                	mv	a0,s2
    800040b2:	e32fe0ef          	jal	800026e4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800040b6:	4705                	li	a4,1
    800040b8:	02ea0463          	beq	s4,a4,800040e0 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800040bc:	00492603          	lw	a2,4(s2)
    800040c0:	fb040593          	addi	a1,s0,-80
    800040c4:	8526                	mv	a0,s1
    800040c6:	e63fe0ef          	jal	80002f28 <dirlink>
    800040ca:	06054263          	bltz	a0,8000412e <create+0x11c>
  iunlockput(dp);
    800040ce:	8526                	mv	a0,s1
    800040d0:	8e1fe0ef          	jal	800029b0 <iunlockput>
  return ip;
    800040d4:	89ca                	mv	s3,s2
    800040d6:	bf71                	j	80004072 <create+0x60>
    iunlockput(dp);
    800040d8:	8526                	mv	a0,s1
    800040da:	8d7fe0ef          	jal	800029b0 <iunlockput>
    return 0;
    800040de:	bf51                	j	80004072 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800040e0:	00492603          	lw	a2,4(s2)
    800040e4:	00004597          	auipc	a1,0x4
    800040e8:	47c58593          	addi	a1,a1,1148 # 80008560 <etext+0x560>
    800040ec:	854a                	mv	a0,s2
    800040ee:	e3bfe0ef          	jal	80002f28 <dirlink>
    800040f2:	02054e63          	bltz	a0,8000412e <create+0x11c>
    800040f6:	40d0                	lw	a2,4(s1)
    800040f8:	00004597          	auipc	a1,0x4
    800040fc:	47058593          	addi	a1,a1,1136 # 80008568 <etext+0x568>
    80004100:	854a                	mv	a0,s2
    80004102:	e27fe0ef          	jal	80002f28 <dirlink>
    80004106:	02054463          	bltz	a0,8000412e <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    8000410a:	00492603          	lw	a2,4(s2)
    8000410e:	fb040593          	addi	a1,s0,-80
    80004112:	8526                	mv	a0,s1
    80004114:	e15fe0ef          	jal	80002f28 <dirlink>
    80004118:	00054b63          	bltz	a0,8000412e <create+0x11c>
    dp->nlink++;  // for ".."
    8000411c:	0524d783          	lhu	a5,82(s1)
    80004120:	2785                	addiw	a5,a5,1
    80004122:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    80004126:	8526                	mv	a0,s1
    80004128:	dbcfe0ef          	jal	800026e4 <iupdate>
    8000412c:	b74d                	j	800040ce <create+0xbc>
  ip->nlink = 0;
    8000412e:	04091923          	sh	zero,82(s2)
  iupdate(ip);
    80004132:	854a                	mv	a0,s2
    80004134:	db0fe0ef          	jal	800026e4 <iupdate>
  iunlockput(ip);
    80004138:	854a                	mv	a0,s2
    8000413a:	877fe0ef          	jal	800029b0 <iunlockput>
  iunlockput(dp);
    8000413e:	8526                	mv	a0,s1
    80004140:	871fe0ef          	jal	800029b0 <iunlockput>
  return 0;
    80004144:	b73d                	j	80004072 <create+0x60>
    return 0;
    80004146:	89aa                	mv	s3,a0
    80004148:	b72d                	j	80004072 <create+0x60>

000000008000414a <sys_dup>:
{
    8000414a:	7179                	addi	sp,sp,-48
    8000414c:	f406                	sd	ra,40(sp)
    8000414e:	f022                	sd	s0,32(sp)
    80004150:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004152:	fd840613          	addi	a2,s0,-40
    80004156:	4581                	li	a1,0
    80004158:	4501                	li	a0,0
    8000415a:	e1fff0ef          	jal	80003f78 <argfd>
    return -1;
    8000415e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004160:	02054363          	bltz	a0,80004186 <sys_dup+0x3c>
    80004164:	ec26                	sd	s1,24(sp)
    80004166:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004168:	fd843483          	ld	s1,-40(s0)
    8000416c:	8526                	mv	a0,s1
    8000416e:	e65ff0ef          	jal	80003fd2 <fdalloc>
    80004172:	892a                	mv	s2,a0
    return -1;
    80004174:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004176:	00054d63          	bltz	a0,80004190 <sys_dup+0x46>
  filedup(f);
    8000417a:	8526                	mv	a0,s1
    8000417c:	c12ff0ef          	jal	8000358e <filedup>
  return fd;
    80004180:	87ca                	mv	a5,s2
    80004182:	64e2                	ld	s1,24(sp)
    80004184:	6942                	ld	s2,16(sp)
}
    80004186:	853e                	mv	a0,a5
    80004188:	70a2                	ld	ra,40(sp)
    8000418a:	7402                	ld	s0,32(sp)
    8000418c:	6145                	addi	sp,sp,48
    8000418e:	8082                	ret
    80004190:	64e2                	ld	s1,24(sp)
    80004192:	6942                	ld	s2,16(sp)
    80004194:	bfcd                	j	80004186 <sys_dup+0x3c>

0000000080004196 <sys_read>:
{
    80004196:	7179                	addi	sp,sp,-48
    80004198:	f406                	sd	ra,40(sp)
    8000419a:	f022                	sd	s0,32(sp)
    8000419c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000419e:	fd840593          	addi	a1,s0,-40
    800041a2:	4505                	li	a0,1
    800041a4:	bfffd0ef          	jal	80001da2 <argaddr>
  argint(2, &n);
    800041a8:	fe440593          	addi	a1,s0,-28
    800041ac:	4509                	li	a0,2
    800041ae:	bd9fd0ef          	jal	80001d86 <argint>
  if(argfd(0, 0, &f) < 0)
    800041b2:	fe840613          	addi	a2,s0,-24
    800041b6:	4581                	li	a1,0
    800041b8:	4501                	li	a0,0
    800041ba:	dbfff0ef          	jal	80003f78 <argfd>
    800041be:	87aa                	mv	a5,a0
    return -1;
    800041c0:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041c2:	0007ca63          	bltz	a5,800041d6 <sys_read+0x40>
  return fileread(f, p, n);
    800041c6:	fe442603          	lw	a2,-28(s0)
    800041ca:	fd843583          	ld	a1,-40(s0)
    800041ce:	fe843503          	ld	a0,-24(s0)
    800041d2:	d26ff0ef          	jal	800036f8 <fileread>
}
    800041d6:	70a2                	ld	ra,40(sp)
    800041d8:	7402                	ld	s0,32(sp)
    800041da:	6145                	addi	sp,sp,48
    800041dc:	8082                	ret

00000000800041de <sys_write>:
{
    800041de:	7179                	addi	sp,sp,-48
    800041e0:	f406                	sd	ra,40(sp)
    800041e2:	f022                	sd	s0,32(sp)
    800041e4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041e6:	fd840593          	addi	a1,s0,-40
    800041ea:	4505                	li	a0,1
    800041ec:	bb7fd0ef          	jal	80001da2 <argaddr>
  argint(2, &n);
    800041f0:	fe440593          	addi	a1,s0,-28
    800041f4:	4509                	li	a0,2
    800041f6:	b91fd0ef          	jal	80001d86 <argint>
  if(argfd(0, 0, &f) < 0)
    800041fa:	fe840613          	addi	a2,s0,-24
    800041fe:	4581                	li	a1,0
    80004200:	4501                	li	a0,0
    80004202:	d77ff0ef          	jal	80003f78 <argfd>
    80004206:	87aa                	mv	a5,a0
    return -1;
    80004208:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000420a:	0007ca63          	bltz	a5,8000421e <sys_write+0x40>
  return filewrite(f, p, n);
    8000420e:	fe442603          	lw	a2,-28(s0)
    80004212:	fd843583          	ld	a1,-40(s0)
    80004216:	fe843503          	ld	a0,-24(s0)
    8000421a:	da2ff0ef          	jal	800037bc <filewrite>
}
    8000421e:	70a2                	ld	ra,40(sp)
    80004220:	7402                	ld	s0,32(sp)
    80004222:	6145                	addi	sp,sp,48
    80004224:	8082                	ret

0000000080004226 <sys_close>:
{
    80004226:	1101                	addi	sp,sp,-32
    80004228:	ec06                	sd	ra,24(sp)
    8000422a:	e822                	sd	s0,16(sp)
    8000422c:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000422e:	fe040613          	addi	a2,s0,-32
    80004232:	fec40593          	addi	a1,s0,-20
    80004236:	4501                	li	a0,0
    80004238:	d41ff0ef          	jal	80003f78 <argfd>
    return -1;
    8000423c:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000423e:	02054163          	bltz	a0,80004260 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004242:	c0ffc0ef          	jal	80000e50 <myproc>
    80004246:	fec42783          	lw	a5,-20(s0)
    8000424a:	078e                	slli	a5,a5,0x3
    8000424c:	0d078793          	addi	a5,a5,208
    80004250:	953e                	add	a0,a0,a5
    80004252:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004256:	fe043503          	ld	a0,-32(s0)
    8000425a:	b7aff0ef          	jal	800035d4 <fileclose>
  return 0;
    8000425e:	4781                	li	a5,0
}
    80004260:	853e                	mv	a0,a5
    80004262:	60e2                	ld	ra,24(sp)
    80004264:	6442                	ld	s0,16(sp)
    80004266:	6105                	addi	sp,sp,32
    80004268:	8082                	ret

000000008000426a <sys_fstat>:
{
    8000426a:	1101                	addi	sp,sp,-32
    8000426c:	ec06                	sd	ra,24(sp)
    8000426e:	e822                	sd	s0,16(sp)
    80004270:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004272:	fe040593          	addi	a1,s0,-32
    80004276:	4505                	li	a0,1
    80004278:	b2bfd0ef          	jal	80001da2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000427c:	fe840613          	addi	a2,s0,-24
    80004280:	4581                	li	a1,0
    80004282:	4501                	li	a0,0
    80004284:	cf5ff0ef          	jal	80003f78 <argfd>
    80004288:	87aa                	mv	a5,a0
    return -1;
    8000428a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000428c:	0007c863          	bltz	a5,8000429c <sys_fstat+0x32>
  return filestat(f, st);
    80004290:	fe043583          	ld	a1,-32(s0)
    80004294:	fe843503          	ld	a0,-24(s0)
    80004298:	bfeff0ef          	jal	80003696 <filestat>
}
    8000429c:	60e2                	ld	ra,24(sp)
    8000429e:	6442                	ld	s0,16(sp)
    800042a0:	6105                	addi	sp,sp,32
    800042a2:	8082                	ret

00000000800042a4 <sys_link>:
{
    800042a4:	7169                	addi	sp,sp,-304
    800042a6:	f606                	sd	ra,296(sp)
    800042a8:	f222                	sd	s0,288(sp)
    800042aa:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042ac:	08000613          	li	a2,128
    800042b0:	ed040593          	addi	a1,s0,-304
    800042b4:	4501                	li	a0,0
    800042b6:	b09fd0ef          	jal	80001dbe <argstr>
    return -1;
    800042ba:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042bc:	0c054e63          	bltz	a0,80004398 <sys_link+0xf4>
    800042c0:	08000613          	li	a2,128
    800042c4:	f5040593          	addi	a1,s0,-176
    800042c8:	4505                	li	a0,1
    800042ca:	af5fd0ef          	jal	80001dbe <argstr>
    return -1;
    800042ce:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042d0:	0c054463          	bltz	a0,80004398 <sys_link+0xf4>
    800042d4:	ee26                	sd	s1,280(sp)
  begin_op();
    800042d6:	edbfe0ef          	jal	800031b0 <begin_op>
  if((ip = namei(old)) == 0){
    800042da:	ed040513          	addi	a0,s0,-304
    800042de:	cf5fe0ef          	jal	80002fd2 <namei>
    800042e2:	84aa                	mv	s1,a0
    800042e4:	c53d                	beqz	a0,80004352 <sys_link+0xae>
  ilock(ip);
    800042e6:	cb2fe0ef          	jal	80002798 <ilock>
  if(ip->type == T_DIR){
    800042ea:	04c49703          	lh	a4,76(s1)
    800042ee:	4785                	li	a5,1
    800042f0:	06f70663          	beq	a4,a5,8000435c <sys_link+0xb8>
    800042f4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042f6:	0524d783          	lhu	a5,82(s1)
    800042fa:	2785                	addiw	a5,a5,1
    800042fc:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004300:	8526                	mv	a0,s1
    80004302:	be2fe0ef          	jal	800026e4 <iupdate>
  iunlock(ip);
    80004306:	8526                	mv	a0,s1
    80004308:	d44fe0ef          	jal	8000284c <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000430c:	fd040593          	addi	a1,s0,-48
    80004310:	f5040513          	addi	a0,s0,-176
    80004314:	cd9fe0ef          	jal	80002fec <nameiparent>
    80004318:	892a                	mv	s2,a0
    8000431a:	cd21                	beqz	a0,80004372 <sys_link+0xce>
  ilock(dp);
    8000431c:	c7cfe0ef          	jal	80002798 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004320:	854a                	mv	a0,s2
    80004322:	00092703          	lw	a4,0(s2)
    80004326:	409c                	lw	a5,0(s1)
    80004328:	04f71263          	bne	a4,a5,8000436c <sys_link+0xc8>
    8000432c:	40d0                	lw	a2,4(s1)
    8000432e:	fd040593          	addi	a1,s0,-48
    80004332:	bf7fe0ef          	jal	80002f28 <dirlink>
    80004336:	02054b63          	bltz	a0,8000436c <sys_link+0xc8>
  iunlockput(dp);
    8000433a:	854a                	mv	a0,s2
    8000433c:	e74fe0ef          	jal	800029b0 <iunlockput>
  iput(ip);
    80004340:	8526                	mv	a0,s1
    80004342:	de4fe0ef          	jal	80002926 <iput>
  end_op();
    80004346:	edbfe0ef          	jal	80003220 <end_op>
  return 0;
    8000434a:	4781                	li	a5,0
    8000434c:	64f2                	ld	s1,280(sp)
    8000434e:	6952                	ld	s2,272(sp)
    80004350:	a0a1                	j	80004398 <sys_link+0xf4>
    end_op();
    80004352:	ecffe0ef          	jal	80003220 <end_op>
    return -1;
    80004356:	57fd                	li	a5,-1
    80004358:	64f2                	ld	s1,280(sp)
    8000435a:	a83d                	j	80004398 <sys_link+0xf4>
    iunlockput(ip);
    8000435c:	8526                	mv	a0,s1
    8000435e:	e52fe0ef          	jal	800029b0 <iunlockput>
    end_op();
    80004362:	ebffe0ef          	jal	80003220 <end_op>
    return -1;
    80004366:	57fd                	li	a5,-1
    80004368:	64f2                	ld	s1,280(sp)
    8000436a:	a03d                	j	80004398 <sys_link+0xf4>
    iunlockput(dp);
    8000436c:	854a                	mv	a0,s2
    8000436e:	e42fe0ef          	jal	800029b0 <iunlockput>
  ilock(ip);
    80004372:	8526                	mv	a0,s1
    80004374:	c24fe0ef          	jal	80002798 <ilock>
  ip->nlink--;
    80004378:	0524d783          	lhu	a5,82(s1)
    8000437c:	37fd                	addiw	a5,a5,-1
    8000437e:	04f49923          	sh	a5,82(s1)
  iupdate(ip);
    80004382:	8526                	mv	a0,s1
    80004384:	b60fe0ef          	jal	800026e4 <iupdate>
  iunlockput(ip);
    80004388:	8526                	mv	a0,s1
    8000438a:	e26fe0ef          	jal	800029b0 <iunlockput>
  end_op();
    8000438e:	e93fe0ef          	jal	80003220 <end_op>
  return -1;
    80004392:	57fd                	li	a5,-1
    80004394:	64f2                	ld	s1,280(sp)
    80004396:	6952                	ld	s2,272(sp)
}
    80004398:	853e                	mv	a0,a5
    8000439a:	70b2                	ld	ra,296(sp)
    8000439c:	7412                	ld	s0,288(sp)
    8000439e:	6155                	addi	sp,sp,304
    800043a0:	8082                	ret

00000000800043a2 <sys_unlink>:
{
    800043a2:	7151                	addi	sp,sp,-240
    800043a4:	f586                	sd	ra,232(sp)
    800043a6:	f1a2                	sd	s0,224(sp)
    800043a8:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800043aa:	08000613          	li	a2,128
    800043ae:	f3040593          	addi	a1,s0,-208
    800043b2:	4501                	li	a0,0
    800043b4:	a0bfd0ef          	jal	80001dbe <argstr>
    800043b8:	14054d63          	bltz	a0,80004512 <sys_unlink+0x170>
    800043bc:	eda6                	sd	s1,216(sp)
  begin_op();
    800043be:	df3fe0ef          	jal	800031b0 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800043c2:	fb040593          	addi	a1,s0,-80
    800043c6:	f3040513          	addi	a0,s0,-208
    800043ca:	c23fe0ef          	jal	80002fec <nameiparent>
    800043ce:	84aa                	mv	s1,a0
    800043d0:	c955                	beqz	a0,80004484 <sys_unlink+0xe2>
  ilock(dp);
    800043d2:	bc6fe0ef          	jal	80002798 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800043d6:	00004597          	auipc	a1,0x4
    800043da:	18a58593          	addi	a1,a1,394 # 80008560 <etext+0x560>
    800043de:	fb040513          	addi	a0,s0,-80
    800043e2:	947fe0ef          	jal	80002d28 <namecmp>
    800043e6:	10050b63          	beqz	a0,800044fc <sys_unlink+0x15a>
    800043ea:	00004597          	auipc	a1,0x4
    800043ee:	17e58593          	addi	a1,a1,382 # 80008568 <etext+0x568>
    800043f2:	fb040513          	addi	a0,s0,-80
    800043f6:	933fe0ef          	jal	80002d28 <namecmp>
    800043fa:	10050163          	beqz	a0,800044fc <sys_unlink+0x15a>
    800043fe:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004400:	f2c40613          	addi	a2,s0,-212
    80004404:	fb040593          	addi	a1,s0,-80
    80004408:	8526                	mv	a0,s1
    8000440a:	935fe0ef          	jal	80002d3e <dirlookup>
    8000440e:	892a                	mv	s2,a0
    80004410:	0e050563          	beqz	a0,800044fa <sys_unlink+0x158>
    80004414:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004416:	b82fe0ef          	jal	80002798 <ilock>
  if(ip->nlink < 1)
    8000441a:	05291783          	lh	a5,82(s2)
    8000441e:	06f05863          	blez	a5,8000448e <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004422:	04c91703          	lh	a4,76(s2)
    80004426:	4785                	li	a5,1
    80004428:	06f70963          	beq	a4,a5,8000449a <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    8000442c:	fc040993          	addi	s3,s0,-64
    80004430:	4641                	li	a2,16
    80004432:	4581                	li	a1,0
    80004434:	854e                	mv	a0,s3
    80004436:	de9fb0ef          	jal	8000021e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000443a:	4741                	li	a4,16
    8000443c:	f2c42683          	lw	a3,-212(s0)
    80004440:	864e                	mv	a2,s3
    80004442:	4581                	li	a1,0
    80004444:	8526                	mv	a0,s1
    80004446:	fe2fe0ef          	jal	80002c28 <writei>
    8000444a:	47c1                	li	a5,16
    8000444c:	08f51863          	bne	a0,a5,800044dc <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80004450:	04c91703          	lh	a4,76(s2)
    80004454:	4785                	li	a5,1
    80004456:	08f70963          	beq	a4,a5,800044e8 <sys_unlink+0x146>
  iunlockput(dp);
    8000445a:	8526                	mv	a0,s1
    8000445c:	d54fe0ef          	jal	800029b0 <iunlockput>
  ip->nlink--;
    80004460:	05295783          	lhu	a5,82(s2)
    80004464:	37fd                	addiw	a5,a5,-1
    80004466:	04f91923          	sh	a5,82(s2)
  iupdate(ip);
    8000446a:	854a                	mv	a0,s2
    8000446c:	a78fe0ef          	jal	800026e4 <iupdate>
  iunlockput(ip);
    80004470:	854a                	mv	a0,s2
    80004472:	d3efe0ef          	jal	800029b0 <iunlockput>
  end_op();
    80004476:	dabfe0ef          	jal	80003220 <end_op>
  return 0;
    8000447a:	4501                	li	a0,0
    8000447c:	64ee                	ld	s1,216(sp)
    8000447e:	694e                	ld	s2,208(sp)
    80004480:	69ae                	ld	s3,200(sp)
    80004482:	a061                	j	8000450a <sys_unlink+0x168>
    end_op();
    80004484:	d9dfe0ef          	jal	80003220 <end_op>
    return -1;
    80004488:	557d                	li	a0,-1
    8000448a:	64ee                	ld	s1,216(sp)
    8000448c:	a8bd                	j	8000450a <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000448e:	00004517          	auipc	a0,0x4
    80004492:	0e250513          	addi	a0,a0,226 # 80008570 <etext+0x570>
    80004496:	654010ef          	jal	80005aea <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000449a:	05492703          	lw	a4,84(s2)
    8000449e:	02000793          	li	a5,32
    800044a2:	f8e7f5e3          	bgeu	a5,a4,8000442c <sys_unlink+0x8a>
    800044a6:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800044a8:	4741                	li	a4,16
    800044aa:	86ce                	mv	a3,s3
    800044ac:	f1840613          	addi	a2,s0,-232
    800044b0:	4581                	li	a1,0
    800044b2:	854a                	mv	a0,s2
    800044b4:	e82fe0ef          	jal	80002b36 <readi>
    800044b8:	47c1                	li	a5,16
    800044ba:	00f51b63          	bne	a0,a5,800044d0 <sys_unlink+0x12e>
    if(de.inum != 0)
    800044be:	f1845783          	lhu	a5,-232(s0)
    800044c2:	ebb1                	bnez	a5,80004516 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800044c4:	29c1                	addiw	s3,s3,16
    800044c6:	05492783          	lw	a5,84(s2)
    800044ca:	fcf9efe3          	bltu	s3,a5,800044a8 <sys_unlink+0x106>
    800044ce:	bfb9                	j	8000442c <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800044d0:	00004517          	auipc	a0,0x4
    800044d4:	0b850513          	addi	a0,a0,184 # 80008588 <etext+0x588>
    800044d8:	612010ef          	jal	80005aea <panic>
    panic("unlink: writei");
    800044dc:	00004517          	auipc	a0,0x4
    800044e0:	0c450513          	addi	a0,a0,196 # 800085a0 <etext+0x5a0>
    800044e4:	606010ef          	jal	80005aea <panic>
    dp->nlink--;
    800044e8:	0524d783          	lhu	a5,82(s1)
    800044ec:	37fd                	addiw	a5,a5,-1
    800044ee:	04f49923          	sh	a5,82(s1)
    iupdate(dp);
    800044f2:	8526                	mv	a0,s1
    800044f4:	9f0fe0ef          	jal	800026e4 <iupdate>
    800044f8:	b78d                	j	8000445a <sys_unlink+0xb8>
    800044fa:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800044fc:	8526                	mv	a0,s1
    800044fe:	cb2fe0ef          	jal	800029b0 <iunlockput>
  end_op();
    80004502:	d1ffe0ef          	jal	80003220 <end_op>
  return -1;
    80004506:	557d                	li	a0,-1
    80004508:	64ee                	ld	s1,216(sp)
}
    8000450a:	70ae                	ld	ra,232(sp)
    8000450c:	740e                	ld	s0,224(sp)
    8000450e:	616d                	addi	sp,sp,240
    80004510:	8082                	ret
    return -1;
    80004512:	557d                	li	a0,-1
    80004514:	bfdd                	j	8000450a <sys_unlink+0x168>
    iunlockput(ip);
    80004516:	854a                	mv	a0,s2
    80004518:	c98fe0ef          	jal	800029b0 <iunlockput>
    goto bad;
    8000451c:	694e                	ld	s2,208(sp)
    8000451e:	69ae                	ld	s3,200(sp)
    80004520:	bff1                	j	800044fc <sys_unlink+0x15a>

0000000080004522 <sys_open>:

uint64
sys_open(void)
{
    80004522:	7131                	addi	sp,sp,-192
    80004524:	fd06                	sd	ra,184(sp)
    80004526:	f922                	sd	s0,176(sp)
    80004528:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000452a:	f4c40593          	addi	a1,s0,-180
    8000452e:	4505                	li	a0,1
    80004530:	857fd0ef          	jal	80001d86 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004534:	08000613          	li	a2,128
    80004538:	f5040593          	addi	a1,s0,-176
    8000453c:	4501                	li	a0,0
    8000453e:	881fd0ef          	jal	80001dbe <argstr>
    80004542:	87aa                	mv	a5,a0
    return -1;
    80004544:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004546:	0a07c363          	bltz	a5,800045ec <sys_open+0xca>
    8000454a:	f526                	sd	s1,168(sp)

  begin_op();
    8000454c:	c65fe0ef          	jal	800031b0 <begin_op>

  if(omode & O_CREATE){
    80004550:	f4c42783          	lw	a5,-180(s0)
    80004554:	2007f793          	andi	a5,a5,512
    80004558:	c3dd                	beqz	a5,800045fe <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    8000455a:	4681                	li	a3,0
    8000455c:	4601                	li	a2,0
    8000455e:	4589                	li	a1,2
    80004560:	f5040513          	addi	a0,s0,-176
    80004564:	aafff0ef          	jal	80004012 <create>
    80004568:	84aa                	mv	s1,a0
    if(ip == 0){
    8000456a:	c549                	beqz	a0,800045f4 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000456c:	04c49703          	lh	a4,76(s1)
    80004570:	478d                	li	a5,3
    80004572:	00f71763          	bne	a4,a5,80004580 <sys_open+0x5e>
    80004576:	04e4d703          	lhu	a4,78(s1)
    8000457a:	47a5                	li	a5,9
    8000457c:	0ae7ee63          	bltu	a5,a4,80004638 <sys_open+0x116>
    80004580:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004582:	faffe0ef          	jal	80003530 <filealloc>
    80004586:	892a                	mv	s2,a0
    80004588:	c561                	beqz	a0,80004650 <sys_open+0x12e>
    8000458a:	ed4e                	sd	s3,152(sp)
    8000458c:	a47ff0ef          	jal	80003fd2 <fdalloc>
    80004590:	89aa                	mv	s3,a0
    80004592:	0a054b63          	bltz	a0,80004648 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004596:	04c49703          	lh	a4,76(s1)
    8000459a:	478d                	li	a5,3
    8000459c:	0cf70363          	beq	a4,a5,80004662 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800045a0:	4789                	li	a5,2
    800045a2:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800045a6:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800045aa:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800045ae:	f4c42783          	lw	a5,-180(s0)
    800045b2:	0017f713          	andi	a4,a5,1
    800045b6:	00174713          	xori	a4,a4,1
    800045ba:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800045be:	0037f713          	andi	a4,a5,3
    800045c2:	00e03733          	snez	a4,a4
    800045c6:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800045ca:	4007f793          	andi	a5,a5,1024
    800045ce:	c791                	beqz	a5,800045da <sys_open+0xb8>
    800045d0:	04c49703          	lh	a4,76(s1)
    800045d4:	4789                	li	a5,2
    800045d6:	08f70d63          	beq	a4,a5,80004670 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800045da:	8526                	mv	a0,s1
    800045dc:	a70fe0ef          	jal	8000284c <iunlock>
  end_op();
    800045e0:	c41fe0ef          	jal	80003220 <end_op>

  return fd;
    800045e4:	854e                	mv	a0,s3
    800045e6:	74aa                	ld	s1,168(sp)
    800045e8:	790a                	ld	s2,160(sp)
    800045ea:	69ea                	ld	s3,152(sp)
}
    800045ec:	70ea                	ld	ra,184(sp)
    800045ee:	744a                	ld	s0,176(sp)
    800045f0:	6129                	addi	sp,sp,192
    800045f2:	8082                	ret
      end_op();
    800045f4:	c2dfe0ef          	jal	80003220 <end_op>
      return -1;
    800045f8:	557d                	li	a0,-1
    800045fa:	74aa                	ld	s1,168(sp)
    800045fc:	bfc5                	j	800045ec <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800045fe:	f5040513          	addi	a0,s0,-176
    80004602:	9d1fe0ef          	jal	80002fd2 <namei>
    80004606:	84aa                	mv	s1,a0
    80004608:	c11d                	beqz	a0,8000462e <sys_open+0x10c>
    ilock(ip);
    8000460a:	98efe0ef          	jal	80002798 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000460e:	04c49703          	lh	a4,76(s1)
    80004612:	4785                	li	a5,1
    80004614:	f4f71ce3          	bne	a4,a5,8000456c <sys_open+0x4a>
    80004618:	f4c42783          	lw	a5,-180(s0)
    8000461c:	d3b5                	beqz	a5,80004580 <sys_open+0x5e>
      iunlockput(ip);
    8000461e:	8526                	mv	a0,s1
    80004620:	b90fe0ef          	jal	800029b0 <iunlockput>
      end_op();
    80004624:	bfdfe0ef          	jal	80003220 <end_op>
      return -1;
    80004628:	557d                	li	a0,-1
    8000462a:	74aa                	ld	s1,168(sp)
    8000462c:	b7c1                	j	800045ec <sys_open+0xca>
      end_op();
    8000462e:	bf3fe0ef          	jal	80003220 <end_op>
      return -1;
    80004632:	557d                	li	a0,-1
    80004634:	74aa                	ld	s1,168(sp)
    80004636:	bf5d                	j	800045ec <sys_open+0xca>
    iunlockput(ip);
    80004638:	8526                	mv	a0,s1
    8000463a:	b76fe0ef          	jal	800029b0 <iunlockput>
    end_op();
    8000463e:	be3fe0ef          	jal	80003220 <end_op>
    return -1;
    80004642:	557d                	li	a0,-1
    80004644:	74aa                	ld	s1,168(sp)
    80004646:	b75d                	j	800045ec <sys_open+0xca>
      fileclose(f);
    80004648:	854a                	mv	a0,s2
    8000464a:	f8bfe0ef          	jal	800035d4 <fileclose>
    8000464e:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004650:	8526                	mv	a0,s1
    80004652:	b5efe0ef          	jal	800029b0 <iunlockput>
    end_op();
    80004656:	bcbfe0ef          	jal	80003220 <end_op>
    return -1;
    8000465a:	557d                	li	a0,-1
    8000465c:	74aa                	ld	s1,168(sp)
    8000465e:	790a                	ld	s2,160(sp)
    80004660:	b771                	j	800045ec <sys_open+0xca>
    f->type = FD_DEVICE;
    80004662:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004666:	04e49783          	lh	a5,78(s1)
    8000466a:	02f91223          	sh	a5,36(s2)
    8000466e:	bf35                	j	800045aa <sys_open+0x88>
    itrunc(ip);
    80004670:	8526                	mv	a0,s1
    80004672:	a20fe0ef          	jal	80002892 <itrunc>
    80004676:	b795                	j	800045da <sys_open+0xb8>

0000000080004678 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004678:	7175                	addi	sp,sp,-144
    8000467a:	e506                	sd	ra,136(sp)
    8000467c:	e122                	sd	s0,128(sp)
    8000467e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004680:	b31fe0ef          	jal	800031b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004684:	08000613          	li	a2,128
    80004688:	f7040593          	addi	a1,s0,-144
    8000468c:	4501                	li	a0,0
    8000468e:	f30fd0ef          	jal	80001dbe <argstr>
    80004692:	02054363          	bltz	a0,800046b8 <sys_mkdir+0x40>
    80004696:	4681                	li	a3,0
    80004698:	4601                	li	a2,0
    8000469a:	4585                	li	a1,1
    8000469c:	f7040513          	addi	a0,s0,-144
    800046a0:	973ff0ef          	jal	80004012 <create>
    800046a4:	c911                	beqz	a0,800046b8 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800046a6:	b0afe0ef          	jal	800029b0 <iunlockput>
  end_op();
    800046aa:	b77fe0ef          	jal	80003220 <end_op>
  return 0;
    800046ae:	4501                	li	a0,0
}
    800046b0:	60aa                	ld	ra,136(sp)
    800046b2:	640a                	ld	s0,128(sp)
    800046b4:	6149                	addi	sp,sp,144
    800046b6:	8082                	ret
    end_op();
    800046b8:	b69fe0ef          	jal	80003220 <end_op>
    return -1;
    800046bc:	557d                	li	a0,-1
    800046be:	bfcd                	j	800046b0 <sys_mkdir+0x38>

00000000800046c0 <sys_mknod>:

uint64
sys_mknod(void)
{
    800046c0:	7135                	addi	sp,sp,-160
    800046c2:	ed06                	sd	ra,152(sp)
    800046c4:	e922                	sd	s0,144(sp)
    800046c6:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800046c8:	ae9fe0ef          	jal	800031b0 <begin_op>
  argint(1, &major);
    800046cc:	f6c40593          	addi	a1,s0,-148
    800046d0:	4505                	li	a0,1
    800046d2:	eb4fd0ef          	jal	80001d86 <argint>
  argint(2, &minor);
    800046d6:	f6840593          	addi	a1,s0,-152
    800046da:	4509                	li	a0,2
    800046dc:	eaafd0ef          	jal	80001d86 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046e0:	08000613          	li	a2,128
    800046e4:	f7040593          	addi	a1,s0,-144
    800046e8:	4501                	li	a0,0
    800046ea:	ed4fd0ef          	jal	80001dbe <argstr>
    800046ee:	02054563          	bltz	a0,80004718 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800046f2:	f6841683          	lh	a3,-152(s0)
    800046f6:	f6c41603          	lh	a2,-148(s0)
    800046fa:	458d                	li	a1,3
    800046fc:	f7040513          	addi	a0,s0,-144
    80004700:	913ff0ef          	jal	80004012 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004704:	c911                	beqz	a0,80004718 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004706:	aaafe0ef          	jal	800029b0 <iunlockput>
  end_op();
    8000470a:	b17fe0ef          	jal	80003220 <end_op>
  return 0;
    8000470e:	4501                	li	a0,0
}
    80004710:	60ea                	ld	ra,152(sp)
    80004712:	644a                	ld	s0,144(sp)
    80004714:	610d                	addi	sp,sp,160
    80004716:	8082                	ret
    end_op();
    80004718:	b09fe0ef          	jal	80003220 <end_op>
    return -1;
    8000471c:	557d                	li	a0,-1
    8000471e:	bfcd                	j	80004710 <sys_mknod+0x50>

0000000080004720 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004720:	7135                	addi	sp,sp,-160
    80004722:	ed06                	sd	ra,152(sp)
    80004724:	e922                	sd	s0,144(sp)
    80004726:	e14a                	sd	s2,128(sp)
    80004728:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    8000472a:	f26fc0ef          	jal	80000e50 <myproc>
    8000472e:	892a                	mv	s2,a0
  
  begin_op();
    80004730:	a81fe0ef          	jal	800031b0 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004734:	08000613          	li	a2,128
    80004738:	f6040593          	addi	a1,s0,-160
    8000473c:	4501                	li	a0,0
    8000473e:	e80fd0ef          	jal	80001dbe <argstr>
    80004742:	04054363          	bltz	a0,80004788 <sys_chdir+0x68>
    80004746:	e526                	sd	s1,136(sp)
    80004748:	f6040513          	addi	a0,s0,-160
    8000474c:	887fe0ef          	jal	80002fd2 <namei>
    80004750:	84aa                	mv	s1,a0
    80004752:	c915                	beqz	a0,80004786 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004754:	844fe0ef          	jal	80002798 <ilock>
  if(ip->type != T_DIR){
    80004758:	04c49703          	lh	a4,76(s1)
    8000475c:	4785                	li	a5,1
    8000475e:	02f71963          	bne	a4,a5,80004790 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004762:	8526                	mv	a0,s1
    80004764:	8e8fe0ef          	jal	8000284c <iunlock>
  iput(p->cwd);
    80004768:	15893503          	ld	a0,344(s2)
    8000476c:	9bafe0ef          	jal	80002926 <iput>
  end_op();
    80004770:	ab1fe0ef          	jal	80003220 <end_op>
  p->cwd = ip;
    80004774:	14993c23          	sd	s1,344(s2)
  return 0;
    80004778:	4501                	li	a0,0
    8000477a:	64aa                	ld	s1,136(sp)
}
    8000477c:	60ea                	ld	ra,152(sp)
    8000477e:	644a                	ld	s0,144(sp)
    80004780:	690a                	ld	s2,128(sp)
    80004782:	610d                	addi	sp,sp,160
    80004784:	8082                	ret
    80004786:	64aa                	ld	s1,136(sp)
    end_op();
    80004788:	a99fe0ef          	jal	80003220 <end_op>
    return -1;
    8000478c:	557d                	li	a0,-1
    8000478e:	b7fd                	j	8000477c <sys_chdir+0x5c>
    iunlockput(ip);
    80004790:	8526                	mv	a0,s1
    80004792:	a1efe0ef          	jal	800029b0 <iunlockput>
    end_op();
    80004796:	a8bfe0ef          	jal	80003220 <end_op>
    return -1;
    8000479a:	557d                	li	a0,-1
    8000479c:	64aa                	ld	s1,136(sp)
    8000479e:	bff9                	j	8000477c <sys_chdir+0x5c>

00000000800047a0 <sys_exec>:

uint64
sys_exec(void)
{
    800047a0:	7105                	addi	sp,sp,-480
    800047a2:	ef86                	sd	ra,472(sp)
    800047a4:	eba2                	sd	s0,464(sp)
    800047a6:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800047a8:	e2840593          	addi	a1,s0,-472
    800047ac:	4505                	li	a0,1
    800047ae:	df4fd0ef          	jal	80001da2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800047b2:	08000613          	li	a2,128
    800047b6:	f3040593          	addi	a1,s0,-208
    800047ba:	4501                	li	a0,0
    800047bc:	e02fd0ef          	jal	80001dbe <argstr>
    800047c0:	87aa                	mv	a5,a0
    return -1;
    800047c2:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800047c4:	0e07c063          	bltz	a5,800048a4 <sys_exec+0x104>
    800047c8:	e7a6                	sd	s1,456(sp)
    800047ca:	e3ca                	sd	s2,448(sp)
    800047cc:	ff4e                	sd	s3,440(sp)
    800047ce:	fb52                	sd	s4,432(sp)
    800047d0:	f756                	sd	s5,424(sp)
    800047d2:	f35a                	sd	s6,416(sp)
    800047d4:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800047d6:	e3040a13          	addi	s4,s0,-464
    800047da:	10000613          	li	a2,256
    800047de:	4581                	li	a1,0
    800047e0:	8552                	mv	a0,s4
    800047e2:	a3dfb0ef          	jal	8000021e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800047e6:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800047e8:	89d2                	mv	s3,s4
    800047ea:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047ec:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047f0:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800047f2:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047f6:	00391513          	slli	a0,s2,0x3
    800047fa:	85d6                	mv	a1,s5
    800047fc:	e2843783          	ld	a5,-472(s0)
    80004800:	953e                	add	a0,a0,a5
    80004802:	cfafd0ef          	jal	80001cfc <fetchaddr>
    80004806:	02054663          	bltz	a0,80004832 <sys_exec+0x92>
    if(uarg == 0){
    8000480a:	e2043783          	ld	a5,-480(s0)
    8000480e:	c7a1                	beqz	a5,80004856 <sys_exec+0xb6>
    argv[i] = kalloc();
    80004810:	939fb0ef          	jal	80000148 <kalloc>
    80004814:	85aa                	mv	a1,a0
    80004816:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    8000481a:	cd01                	beqz	a0,80004832 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000481c:	865a                	mv	a2,s6
    8000481e:	e2043503          	ld	a0,-480(s0)
    80004822:	d24fd0ef          	jal	80001d46 <fetchstr>
    80004826:	00054663          	bltz	a0,80004832 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    8000482a:	0905                	addi	s2,s2,1
    8000482c:	09a1                	addi	s3,s3,8
    8000482e:	fd7914e3          	bne	s2,s7,800047f6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004832:	100a0a13          	addi	s4,s4,256
    80004836:	6088                	ld	a0,0(s1)
    80004838:	cd31                	beqz	a0,80004894 <sys_exec+0xf4>
    kfree(argv[i]);
    8000483a:	fe2fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000483e:	04a1                	addi	s1,s1,8
    80004840:	ff449be3          	bne	s1,s4,80004836 <sys_exec+0x96>
  return -1;
    80004844:	557d                	li	a0,-1
    80004846:	64be                	ld	s1,456(sp)
    80004848:	691e                	ld	s2,448(sp)
    8000484a:	79fa                	ld	s3,440(sp)
    8000484c:	7a5a                	ld	s4,432(sp)
    8000484e:	7aba                	ld	s5,424(sp)
    80004850:	7b1a                	ld	s6,416(sp)
    80004852:	6bfa                	ld	s7,408(sp)
    80004854:	a881                	j	800048a4 <sys_exec+0x104>
      argv[i] = 0;
    80004856:	0009079b          	sext.w	a5,s2
    8000485a:	e3040593          	addi	a1,s0,-464
    8000485e:	078e                	slli	a5,a5,0x3
    80004860:	97ae                	add	a5,a5,a1
    80004862:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004866:	f3040513          	addi	a0,s0,-208
    8000486a:	bb2ff0ef          	jal	80003c1c <kexec>
    8000486e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004870:	100a0a13          	addi	s4,s4,256
    80004874:	6088                	ld	a0,0(s1)
    80004876:	c511                	beqz	a0,80004882 <sys_exec+0xe2>
    kfree(argv[i]);
    80004878:	fa4fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000487c:	04a1                	addi	s1,s1,8
    8000487e:	ff449be3          	bne	s1,s4,80004874 <sys_exec+0xd4>
  return ret;
    80004882:	854a                	mv	a0,s2
    80004884:	64be                	ld	s1,456(sp)
    80004886:	691e                	ld	s2,448(sp)
    80004888:	79fa                	ld	s3,440(sp)
    8000488a:	7a5a                	ld	s4,432(sp)
    8000488c:	7aba                	ld	s5,424(sp)
    8000488e:	7b1a                	ld	s6,416(sp)
    80004890:	6bfa                	ld	s7,408(sp)
    80004892:	a809                	j	800048a4 <sys_exec+0x104>
  return -1;
    80004894:	557d                	li	a0,-1
    80004896:	64be                	ld	s1,456(sp)
    80004898:	691e                	ld	s2,448(sp)
    8000489a:	79fa                	ld	s3,440(sp)
    8000489c:	7a5a                	ld	s4,432(sp)
    8000489e:	7aba                	ld	s5,424(sp)
    800048a0:	7b1a                	ld	s6,416(sp)
    800048a2:	6bfa                	ld	s7,408(sp)
}
    800048a4:	60fe                	ld	ra,472(sp)
    800048a6:	645e                	ld	s0,464(sp)
    800048a8:	613d                	addi	sp,sp,480
    800048aa:	8082                	ret

00000000800048ac <sys_pipe>:

uint64
sys_pipe(void)
{
    800048ac:	7139                	addi	sp,sp,-64
    800048ae:	fc06                	sd	ra,56(sp)
    800048b0:	f822                	sd	s0,48(sp)
    800048b2:	f426                	sd	s1,40(sp)
    800048b4:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800048b6:	d9afc0ef          	jal	80000e50 <myproc>
    800048ba:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800048bc:	fd840593          	addi	a1,s0,-40
    800048c0:	4501                	li	a0,0
    800048c2:	ce0fd0ef          	jal	80001da2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800048c6:	fc840593          	addi	a1,s0,-56
    800048ca:	fd040513          	addi	a0,s0,-48
    800048ce:	822ff0ef          	jal	800038f0 <pipealloc>
    return -1;
    800048d2:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800048d4:	0a054763          	bltz	a0,80004982 <sys_pipe+0xd6>
  fd0 = -1;
    800048d8:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800048dc:	fd043503          	ld	a0,-48(s0)
    800048e0:	ef2ff0ef          	jal	80003fd2 <fdalloc>
    800048e4:	fca42223          	sw	a0,-60(s0)
    800048e8:	08054463          	bltz	a0,80004970 <sys_pipe+0xc4>
    800048ec:	fc843503          	ld	a0,-56(s0)
    800048f0:	ee2ff0ef          	jal	80003fd2 <fdalloc>
    800048f4:	fca42023          	sw	a0,-64(s0)
    800048f8:	06054263          	bltz	a0,8000495c <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048fc:	4691                	li	a3,4
    800048fe:	fc440613          	addi	a2,s0,-60
    80004902:	fd843583          	ld	a1,-40(s0)
    80004906:	6ca8                	ld	a0,88(s1)
    80004908:	a7afc0ef          	jal	80000b82 <copyout>
    8000490c:	00054e63          	bltz	a0,80004928 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004910:	4691                	li	a3,4
    80004912:	fc040613          	addi	a2,s0,-64
    80004916:	fd843583          	ld	a1,-40(s0)
    8000491a:	95b6                	add	a1,a1,a3
    8000491c:	6ca8                	ld	a0,88(s1)
    8000491e:	a64fc0ef          	jal	80000b82 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004922:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004924:	04055f63          	bgez	a0,80004982 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80004928:	fc442783          	lw	a5,-60(s0)
    8000492c:	078e                	slli	a5,a5,0x3
    8000492e:	0d078793          	addi	a5,a5,208
    80004932:	97a6                	add	a5,a5,s1
    80004934:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004938:	fc042783          	lw	a5,-64(s0)
    8000493c:	078e                	slli	a5,a5,0x3
    8000493e:	0d078793          	addi	a5,a5,208
    80004942:	97a6                	add	a5,a5,s1
    80004944:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004948:	fd043503          	ld	a0,-48(s0)
    8000494c:	c89fe0ef          	jal	800035d4 <fileclose>
    fileclose(wf);
    80004950:	fc843503          	ld	a0,-56(s0)
    80004954:	c81fe0ef          	jal	800035d4 <fileclose>
    return -1;
    80004958:	57fd                	li	a5,-1
    8000495a:	a025                	j	80004982 <sys_pipe+0xd6>
    if(fd0 >= 0)
    8000495c:	fc442783          	lw	a5,-60(s0)
    80004960:	0007c863          	bltz	a5,80004970 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004964:	078e                	slli	a5,a5,0x3
    80004966:	0d078793          	addi	a5,a5,208
    8000496a:	97a6                	add	a5,a5,s1
    8000496c:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004970:	fd043503          	ld	a0,-48(s0)
    80004974:	c61fe0ef          	jal	800035d4 <fileclose>
    fileclose(wf);
    80004978:	fc843503          	ld	a0,-56(s0)
    8000497c:	c59fe0ef          	jal	800035d4 <fileclose>
    return -1;
    80004980:	57fd                	li	a5,-1
}
    80004982:	853e                	mv	a0,a5
    80004984:	70e2                	ld	ra,56(sp)
    80004986:	7442                	ld	s0,48(sp)
    80004988:	74a2                	ld	s1,40(sp)
    8000498a:	6121                	addi	sp,sp,64
    8000498c:	8082                	ret
	...

0000000080004990 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004990:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004992:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004994:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004996:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004998:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000499a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000499c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000499e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800049a0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800049a2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800049a4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800049a6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800049a8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800049aa:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800049ac:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800049ae:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800049b0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800049b2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800049b4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800049b6:	a54fd0ef          	jal	80001c0a <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800049ba:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800049bc:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800049be:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800049c0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800049c2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800049c4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800049c6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800049c8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800049ca:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800049cc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800049ce:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800049d0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800049d2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800049d4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800049d6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800049d8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800049da:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800049dc:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800049de:	10200073          	sret
    800049e2:	00000013          	nop
    800049e6:	00000013          	nop
    800049ea:	00000013          	nop

00000000800049ee <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800049ee:	1141                	addi	sp,sp,-16
    800049f0:	e406                	sd	ra,8(sp)
    800049f2:	e022                	sd	s0,0(sp)
    800049f4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800049f6:	0c000737          	lui	a4,0xc000
    800049fa:	4785                	li	a5,1
    800049fc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800049fe:	c35c                	sw	a5,4(a4)
}
    80004a00:	60a2                	ld	ra,8(sp)
    80004a02:	6402                	ld	s0,0(sp)
    80004a04:	0141                	addi	sp,sp,16
    80004a06:	8082                	ret

0000000080004a08 <plicinithart>:

void
plicinithart(void)
{
    80004a08:	1141                	addi	sp,sp,-16
    80004a0a:	e406                	sd	ra,8(sp)
    80004a0c:	e022                	sd	s0,0(sp)
    80004a0e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a10:	c0cfc0ef          	jal	80000e1c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004a14:	0085171b          	slliw	a4,a0,0x8
    80004a18:	0c0027b7          	lui	a5,0xc002
    80004a1c:	97ba                	add	a5,a5,a4
    80004a1e:	40200713          	li	a4,1026
    80004a22:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004a26:	00d5151b          	slliw	a0,a0,0xd
    80004a2a:	0c2017b7          	lui	a5,0xc201
    80004a2e:	97aa                	add	a5,a5,a0
    80004a30:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004a34:	60a2                	ld	ra,8(sp)
    80004a36:	6402                	ld	s0,0(sp)
    80004a38:	0141                	addi	sp,sp,16
    80004a3a:	8082                	ret

0000000080004a3c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004a3c:	1141                	addi	sp,sp,-16
    80004a3e:	e406                	sd	ra,8(sp)
    80004a40:	e022                	sd	s0,0(sp)
    80004a42:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a44:	bd8fc0ef          	jal	80000e1c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004a48:	00d5151b          	slliw	a0,a0,0xd
    80004a4c:	0c2017b7          	lui	a5,0xc201
    80004a50:	97aa                	add	a5,a5,a0
  return irq;
}
    80004a52:	43c8                	lw	a0,4(a5)
    80004a54:	60a2                	ld	ra,8(sp)
    80004a56:	6402                	ld	s0,0(sp)
    80004a58:	0141                	addi	sp,sp,16
    80004a5a:	8082                	ret

0000000080004a5c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004a5c:	1101                	addi	sp,sp,-32
    80004a5e:	ec06                	sd	ra,24(sp)
    80004a60:	e822                	sd	s0,16(sp)
    80004a62:	e426                	sd	s1,8(sp)
    80004a64:	1000                	addi	s0,sp,32
    80004a66:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004a68:	bb4fc0ef          	jal	80000e1c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004a6c:	00d5179b          	slliw	a5,a0,0xd
    80004a70:	0c201737          	lui	a4,0xc201
    80004a74:	97ba                	add	a5,a5,a4
    80004a76:	c3c4                	sw	s1,4(a5)
}
    80004a78:	60e2                	ld	ra,24(sp)
    80004a7a:	6442                	ld	s0,16(sp)
    80004a7c:	64a2                	ld	s1,8(sp)
    80004a7e:	6105                	addi	sp,sp,32
    80004a80:	8082                	ret

0000000080004a82 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a82:	1141                	addi	sp,sp,-16
    80004a84:	e406                	sd	ra,8(sp)
    80004a86:	e022                	sd	s0,0(sp)
    80004a88:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a8a:	479d                	li	a5,7
    80004a8c:	04a7ca63          	blt	a5,a0,80004ae0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a90:	00016797          	auipc	a5,0x16
    80004a94:	b0078793          	addi	a5,a5,-1280 # 8001a590 <disk>
    80004a98:	97aa                	add	a5,a5,a0
    80004a9a:	0187c783          	lbu	a5,24(a5)
    80004a9e:	e7b9                	bnez	a5,80004aec <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004aa0:	00451693          	slli	a3,a0,0x4
    80004aa4:	00016797          	auipc	a5,0x16
    80004aa8:	aec78793          	addi	a5,a5,-1300 # 8001a590 <disk>
    80004aac:	6398                	ld	a4,0(a5)
    80004aae:	9736                	add	a4,a4,a3
    80004ab0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004ab4:	6398                	ld	a4,0(a5)
    80004ab6:	9736                	add	a4,a4,a3
    80004ab8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004abc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004ac0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004ac4:	97aa                	add	a5,a5,a0
    80004ac6:	4705                	li	a4,1
    80004ac8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004acc:	00016517          	auipc	a0,0x16
    80004ad0:	adc50513          	addi	a0,a0,-1316 # 8001a5a8 <disk+0x18>
    80004ad4:	9f3fc0ef          	jal	800014c6 <wakeup>
}
    80004ad8:	60a2                	ld	ra,8(sp)
    80004ada:	6402                	ld	s0,0(sp)
    80004adc:	0141                	addi	sp,sp,16
    80004ade:	8082                	ret
    panic("free_desc 1");
    80004ae0:	00004517          	auipc	a0,0x4
    80004ae4:	ad050513          	addi	a0,a0,-1328 # 800085b0 <etext+0x5b0>
    80004ae8:	002010ef          	jal	80005aea <panic>
    panic("free_desc 2");
    80004aec:	00004517          	auipc	a0,0x4
    80004af0:	ad450513          	addi	a0,a0,-1324 # 800085c0 <etext+0x5c0>
    80004af4:	7f7000ef          	jal	80005aea <panic>

0000000080004af8 <virtio_disk_init>:
{
    80004af8:	1101                	addi	sp,sp,-32
    80004afa:	ec06                	sd	ra,24(sp)
    80004afc:	e822                	sd	s0,16(sp)
    80004afe:	e426                	sd	s1,8(sp)
    80004b00:	e04a                	sd	s2,0(sp)
    80004b02:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004b04:	00004597          	auipc	a1,0x4
    80004b08:	acc58593          	addi	a1,a1,-1332 # 800085d0 <etext+0x5d0>
    80004b0c:	00016517          	auipc	a0,0x16
    80004b10:	bac50513          	addi	a0,a0,-1108 # 8001a6b8 <disk+0x128>
    80004b14:	482010ef          	jal	80005f96 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004b18:	100017b7          	lui	a5,0x10001
    80004b1c:	4398                	lw	a4,0(a5)
    80004b1e:	2701                	sext.w	a4,a4
    80004b20:	747277b7          	lui	a5,0x74727
    80004b24:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004b28:	14f71863          	bne	a4,a5,80004c78 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b2c:	100017b7          	lui	a5,0x10001
    80004b30:	43dc                	lw	a5,4(a5)
    80004b32:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004b34:	4709                	li	a4,2
    80004b36:	14e79163          	bne	a5,a4,80004c78 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b3a:	100017b7          	lui	a5,0x10001
    80004b3e:	479c                	lw	a5,8(a5)
    80004b40:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b42:	12e79b63          	bne	a5,a4,80004c78 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004b46:	100017b7          	lui	a5,0x10001
    80004b4a:	47d8                	lw	a4,12(a5)
    80004b4c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b4e:	554d47b7          	lui	a5,0x554d4
    80004b52:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004b56:	12f71163          	bne	a4,a5,80004c78 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b5a:	100017b7          	lui	a5,0x10001
    80004b5e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b62:	4705                	li	a4,1
    80004b64:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b66:	470d                	li	a4,3
    80004b68:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004b6a:	10001737          	lui	a4,0x10001
    80004b6e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004b70:	c7ffe6b7          	lui	a3,0xc7ffe
    80004b74:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd9e9f>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004b78:	8f75                	and	a4,a4,a3
    80004b7a:	100016b7          	lui	a3,0x10001
    80004b7e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b80:	472d                	li	a4,11
    80004b82:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b84:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b88:	439c                	lw	a5,0(a5)
    80004b8a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b8e:	8ba1                	andi	a5,a5,8
    80004b90:	0e078a63          	beqz	a5,80004c84 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b94:	100017b7          	lui	a5,0x10001
    80004b98:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b9c:	43fc                	lw	a5,68(a5)
    80004b9e:	2781                	sext.w	a5,a5
    80004ba0:	0e079863          	bnez	a5,80004c90 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004ba4:	100017b7          	lui	a5,0x10001
    80004ba8:	5bdc                	lw	a5,52(a5)
    80004baa:	2781                	sext.w	a5,a5
  if(max == 0)
    80004bac:	0e078863          	beqz	a5,80004c9c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004bb0:	471d                	li	a4,7
    80004bb2:	0ef77b63          	bgeu	a4,a5,80004ca8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004bb6:	d92fb0ef          	jal	80000148 <kalloc>
    80004bba:	00016497          	auipc	s1,0x16
    80004bbe:	9d648493          	addi	s1,s1,-1578 # 8001a590 <disk>
    80004bc2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004bc4:	d84fb0ef          	jal	80000148 <kalloc>
    80004bc8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004bca:	d7efb0ef          	jal	80000148 <kalloc>
    80004bce:	87aa                	mv	a5,a0
    80004bd0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004bd2:	6088                	ld	a0,0(s1)
    80004bd4:	0e050063          	beqz	a0,80004cb4 <virtio_disk_init+0x1bc>
    80004bd8:	00016717          	auipc	a4,0x16
    80004bdc:	9c073703          	ld	a4,-1600(a4) # 8001a598 <disk+0x8>
    80004be0:	cb71                	beqz	a4,80004cb4 <virtio_disk_init+0x1bc>
    80004be2:	cbe9                	beqz	a5,80004cb4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004be4:	6605                	lui	a2,0x1
    80004be6:	4581                	li	a1,0
    80004be8:	e36fb0ef          	jal	8000021e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004bec:	00016497          	auipc	s1,0x16
    80004bf0:	9a448493          	addi	s1,s1,-1628 # 8001a590 <disk>
    80004bf4:	6605                	lui	a2,0x1
    80004bf6:	4581                	li	a1,0
    80004bf8:	6488                	ld	a0,8(s1)
    80004bfa:	e24fb0ef          	jal	8000021e <memset>
  memset(disk.used, 0, PGSIZE);
    80004bfe:	6605                	lui	a2,0x1
    80004c00:	4581                	li	a1,0
    80004c02:	6888                	ld	a0,16(s1)
    80004c04:	e1afb0ef          	jal	8000021e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004c08:	100017b7          	lui	a5,0x10001
    80004c0c:	4721                	li	a4,8
    80004c0e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004c10:	4098                	lw	a4,0(s1)
    80004c12:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004c16:	40d8                	lw	a4,4(s1)
    80004c18:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004c1c:	649c                	ld	a5,8(s1)
    80004c1e:	0007869b          	sext.w	a3,a5
    80004c22:	10001737          	lui	a4,0x10001
    80004c26:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004c2a:	9781                	srai	a5,a5,0x20
    80004c2c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004c30:	689c                	ld	a5,16(s1)
    80004c32:	0007869b          	sext.w	a3,a5
    80004c36:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004c3a:	9781                	srai	a5,a5,0x20
    80004c3c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004c40:	4785                	li	a5,1
    80004c42:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004c44:	00f48c23          	sb	a5,24(s1)
    80004c48:	00f48ca3          	sb	a5,25(s1)
    80004c4c:	00f48d23          	sb	a5,26(s1)
    80004c50:	00f48da3          	sb	a5,27(s1)
    80004c54:	00f48e23          	sb	a5,28(s1)
    80004c58:	00f48ea3          	sb	a5,29(s1)
    80004c5c:	00f48f23          	sb	a5,30(s1)
    80004c60:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c64:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c68:	07272823          	sw	s2,112(a4)
}
    80004c6c:	60e2                	ld	ra,24(sp)
    80004c6e:	6442                	ld	s0,16(sp)
    80004c70:	64a2                	ld	s1,8(sp)
    80004c72:	6902                	ld	s2,0(sp)
    80004c74:	6105                	addi	sp,sp,32
    80004c76:	8082                	ret
    panic("could not find virtio disk");
    80004c78:	00004517          	auipc	a0,0x4
    80004c7c:	96850513          	addi	a0,a0,-1688 # 800085e0 <etext+0x5e0>
    80004c80:	66b000ef          	jal	80005aea <panic>
    panic("virtio disk FEATURES_OK unset");
    80004c84:	00004517          	auipc	a0,0x4
    80004c88:	97c50513          	addi	a0,a0,-1668 # 80008600 <etext+0x600>
    80004c8c:	65f000ef          	jal	80005aea <panic>
    panic("virtio disk should not be ready");
    80004c90:	00004517          	auipc	a0,0x4
    80004c94:	99050513          	addi	a0,a0,-1648 # 80008620 <etext+0x620>
    80004c98:	653000ef          	jal	80005aea <panic>
    panic("virtio disk has no queue 0");
    80004c9c:	00004517          	auipc	a0,0x4
    80004ca0:	9a450513          	addi	a0,a0,-1628 # 80008640 <etext+0x640>
    80004ca4:	647000ef          	jal	80005aea <panic>
    panic("virtio disk max queue too short");
    80004ca8:	00004517          	auipc	a0,0x4
    80004cac:	9b850513          	addi	a0,a0,-1608 # 80008660 <etext+0x660>
    80004cb0:	63b000ef          	jal	80005aea <panic>
    panic("virtio disk kalloc");
    80004cb4:	00004517          	auipc	a0,0x4
    80004cb8:	9cc50513          	addi	a0,a0,-1588 # 80008680 <etext+0x680>
    80004cbc:	62f000ef          	jal	80005aea <panic>

0000000080004cc0 <virtio_disk_rw>:
}
#endif

void
virtio_disk_rw(struct buf *b, int write)
{
    80004cc0:	711d                	addi	sp,sp,-96
    80004cc2:	ec86                	sd	ra,88(sp)
    80004cc4:	e8a2                	sd	s0,80(sp)
    80004cc6:	e4a6                	sd	s1,72(sp)
    80004cc8:	e0ca                	sd	s2,64(sp)
    80004cca:	fc4e                	sd	s3,56(sp)
    80004ccc:	f852                	sd	s4,48(sp)
    80004cce:	f456                	sd	s5,40(sp)
    80004cd0:	f05a                	sd	s6,32(sp)
    80004cd2:	ec5e                	sd	s7,24(sp)
    80004cd4:	e862                	sd	s8,16(sp)
    80004cd6:	1080                	addi	s0,sp,96
    80004cd8:	89aa                	mv	s3,a0
    80004cda:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004cdc:	4544                	lw	s1,12(a0)

  acquire(&disk.vdisk_lock);
    80004cde:	00016517          	auipc	a0,0x16
    80004ce2:	9da50513          	addi	a0,a0,-1574 # 8001a6b8 <disk+0x128>
    80004ce6:	130010ef          	jal	80005e16 <acquire>
  for(int i = 0; i < NBUF; i++){
    80004cea:	00016697          	auipc	a3,0x16
    80004cee:	9ee68693          	addi	a3,a3,-1554 # 8001a6d8 <xbufs>
    80004cf2:	4781                	li	a5,0
    80004cf4:	4679                	li	a2,30
    if(xbufs[i] == b){
    80004cf6:	6298                	ld	a4,0(a3)
    80004cf8:	02e98563          	beq	s3,a4,80004d22 <virtio_disk_rw+0x62>
    if(xbufs[i] == 0){
    80004cfc:	cb19                	beqz	a4,80004d12 <virtio_disk_rw+0x52>
  for(int i = 0; i < NBUF; i++){
    80004cfe:	2785                	addiw	a5,a5,1
    80004d00:	06a1                	addi	a3,a3,8
    80004d02:	fec79ae3          	bne	a5,a2,80004cf6 <virtio_disk_rw+0x36>
  panic("more than NBUF bufs");
    80004d06:	00004517          	auipc	a0,0x4
    80004d0a:	99250513          	addi	a0,a0,-1646 # 80008698 <etext+0x698>
    80004d0e:	5dd000ef          	jal	80005aea <panic>
      xbufs[i] = b;
    80004d12:	078e                	slli	a5,a5,0x3
    80004d14:	00016717          	auipc	a4,0x16
    80004d18:	87c70713          	addi	a4,a4,-1924 # 8001a590 <disk>
    80004d1c:	97ba                	add	a5,a5,a4
    80004d1e:	1537b423          	sd	s3,328(a5)
  uint64 sector = b->blockno * (BSIZE / 512);
    80004d22:	0014949b          	slliw	s1,s1,0x1
    80004d26:	02049793          	slli	a5,s1,0x20
    80004d2a:	9381                	srli	a5,a5,0x20
    80004d2c:	8c3e                	mv	s8,a5
  for(int i = 0; i < NUM; i++){
    80004d2e:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004d30:	00016a97          	auipc	s5,0x16
    80004d34:	860a8a93          	addi	s5,s5,-1952 # 8001a590 <disk>
  for(int i = 0; i < 3; i++){
    80004d38:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004d3a:	5bfd                	li	s7,-1
    80004d3c:	a095                	j	80004da0 <virtio_disk_rw+0xe0>
      disk.free[i] = 0;
    80004d3e:	00fa8733          	add	a4,s5,a5
    80004d42:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004d46:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004d48:	0207c563          	bltz	a5,80004d72 <virtio_disk_rw+0xb2>
  for(int i = 0; i < 3; i++){
    80004d4c:	2905                	addiw	s2,s2,1
    80004d4e:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004d50:	05490c63          	beq	s2,s4,80004da8 <virtio_disk_rw+0xe8>
    idx[i] = alloc_desc();
    80004d54:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004d56:	00016717          	auipc	a4,0x16
    80004d5a:	83a70713          	addi	a4,a4,-1990 # 8001a590 <disk>
    80004d5e:	4781                	li	a5,0
    if(disk.free[i]){
    80004d60:	01874683          	lbu	a3,24(a4)
    80004d64:	fee9                	bnez	a3,80004d3e <virtio_disk_rw+0x7e>
  for(int i = 0; i < NUM; i++){
    80004d66:	2785                	addiw	a5,a5,1
    80004d68:	0705                	addi	a4,a4,1
    80004d6a:	fe979be3          	bne	a5,s1,80004d60 <virtio_disk_rw+0xa0>
    idx[i] = alloc_desc();
    80004d6e:	0175a023          	sw	s7,0(a1)
      for(int j = 0; j < i; j++)
    80004d72:	01205d63          	blez	s2,80004d8c <virtio_disk_rw+0xcc>
        free_desc(idx[j]);
    80004d76:	fa042503          	lw	a0,-96(s0)
    80004d7a:	d09ff0ef          	jal	80004a82 <free_desc>
      for(int j = 0; j < i; j++)
    80004d7e:	4785                	li	a5,1
    80004d80:	0127d663          	bge	a5,s2,80004d8c <virtio_disk_rw+0xcc>
        free_desc(idx[j]);
    80004d84:	fa442503          	lw	a0,-92(s0)
    80004d88:	cfbff0ef          	jal	80004a82 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d8c:	00016597          	auipc	a1,0x16
    80004d90:	92c58593          	addi	a1,a1,-1748 # 8001a6b8 <disk+0x128>
    80004d94:	00016517          	auipc	a0,0x16
    80004d98:	81450513          	addi	a0,a0,-2028 # 8001a5a8 <disk+0x18>
    80004d9c:	edefc0ef          	jal	8000147a <sleep>
  for(int i = 0; i < 3; i++){
    80004da0:	fa040613          	addi	a2,s0,-96
    80004da4:	4901                	li	s2,0
    80004da6:	b77d                	j	80004d54 <virtio_disk_rw+0x94>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004da8:	fa042503          	lw	a0,-96(s0)
    80004dac:	00451613          	slli	a2,a0,0x4

  if(write)
    80004db0:	00015797          	auipc	a5,0x15
    80004db4:	7e078793          	addi	a5,a5,2016 # 8001a590 <disk>
    80004db8:	00451713          	slli	a4,a0,0x4
    80004dbc:	0a070713          	addi	a4,a4,160
    80004dc0:	973e                	add	a4,a4,a5
    80004dc2:	016036b3          	snez	a3,s6
    80004dc6:	c714                	sw	a3,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004dc8:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004dcc:	01873823          	sd	s8,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004dd0:	6398                	ld	a4,0(a5)
    80004dd2:	9732                	add	a4,a4,a2
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004dd4:	0a860693          	addi	a3,a2,168
    80004dd8:	96be                	add	a3,a3,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004dda:	e314                	sd	a3,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004ddc:	6394                	ld	a3,0(a5)
    80004dde:	00c68833          	add	a6,a3,a2
    80004de2:	4741                	li	a4,16
    80004de4:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004de8:	4585                	li	a1,1
    80004dea:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004dee:	fa442703          	lw	a4,-92(s0)
    80004df2:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004df6:	0712                	slli	a4,a4,0x4
    80004df8:	96ba                	add	a3,a3,a4
    80004dfa:	06098813          	addi	a6,s3,96
    80004dfe:	0106b023          	sd	a6,0(a3)
  disk.desc[idx[1]].len = BSIZE;
    80004e02:	0007b883          	ld	a7,0(a5)
    80004e06:	9746                	add	a4,a4,a7
    80004e08:	40000693          	li	a3,1024
    80004e0c:	c714                	sw	a3,8(a4)
  if(write)
    80004e0e:	001b3693          	seqz	a3,s6
    80004e12:	0016969b          	slliw	a3,a3,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004e16:	8ecd                	or	a3,a3,a1
    80004e18:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004e1c:	fa842683          	lw	a3,-88(s0)
    80004e20:	00d71723          	sh	a3,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004e24:	00451813          	slli	a6,a0,0x4
    80004e28:	02080813          	addi	a6,a6,32
    80004e2c:	983e                	add	a6,a6,a5
    80004e2e:	577d                	li	a4,-1
    80004e30:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004e34:	0692                	slli	a3,a3,0x4
    80004e36:	98b6                	add	a7,a7,a3
    80004e38:	03060713          	addi	a4,a2,48
    80004e3c:	973e                	add	a4,a4,a5
    80004e3e:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004e42:	6398                	ld	a4,0(a5)
    80004e44:	9736                	add	a4,a4,a3
    80004e46:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004e48:	4689                	li	a3,2
    80004e4a:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004e4e:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004e52:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004e56:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004e5a:	6794                	ld	a3,8(a5)
    80004e5c:	0026d703          	lhu	a4,2(a3)
    80004e60:	8b1d                	andi	a4,a4,7
    80004e62:	0706                	slli	a4,a4,0x1
    80004e64:	96ba                	add	a3,a3,a4
    80004e66:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004e6a:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004e6e:	6798                	ld	a4,8(a5)
    80004e70:	00275783          	lhu	a5,2(a4)
    80004e74:	2785                	addiw	a5,a5,1
    80004e76:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004e7a:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004e7e:	100017b7          	lui	a5,0x10001
    80004e82:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004e86:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004e8a:	00016917          	auipc	s2,0x16
    80004e8e:	82e90913          	addi	s2,s2,-2002 # 8001a6b8 <disk+0x128>
  while(b->disk == 1) {
    80004e92:	84ae                	mv	s1,a1
    80004e94:	00b79a63          	bne	a5,a1,80004ea8 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80004e98:	85ca                	mv	a1,s2
    80004e9a:	854e                	mv	a0,s3
    80004e9c:	ddefc0ef          	jal	8000147a <sleep>
  while(b->disk == 1) {
    80004ea0:	0049a783          	lw	a5,4(s3)
    80004ea4:	fe978ae3          	beq	a5,s1,80004e98 <virtio_disk_rw+0x1d8>
  }

  disk.info[idx[0]].b = 0;
    80004ea8:	fa042903          	lw	s2,-96(s0)
    80004eac:	00491713          	slli	a4,s2,0x4
    80004eb0:	02070713          	addi	a4,a4,32
    80004eb4:	00015797          	auipc	a5,0x15
    80004eb8:	6dc78793          	addi	a5,a5,1756 # 8001a590 <disk>
    80004ebc:	97ba                	add	a5,a5,a4
    80004ebe:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004ec2:	00015997          	auipc	s3,0x15
    80004ec6:	6ce98993          	addi	s3,s3,1742 # 8001a590 <disk>
    80004eca:	00491713          	slli	a4,s2,0x4
    80004ece:	0009b783          	ld	a5,0(s3)
    80004ed2:	97ba                	add	a5,a5,a4
    80004ed4:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004ed8:	854a                	mv	a0,s2
    80004eda:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004ede:	ba5ff0ef          	jal	80004a82 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004ee2:	8885                	andi	s1,s1,1
    80004ee4:	f0fd                	bnez	s1,80004eca <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004ee6:	00015517          	auipc	a0,0x15
    80004eea:	7d250513          	addi	a0,a0,2002 # 8001a6b8 <disk+0x128>
    80004eee:	010010ef          	jal	80005efe <release>
}
    80004ef2:	60e6                	ld	ra,88(sp)
    80004ef4:	6446                	ld	s0,80(sp)
    80004ef6:	64a6                	ld	s1,72(sp)
    80004ef8:	6906                	ld	s2,64(sp)
    80004efa:	79e2                	ld	s3,56(sp)
    80004efc:	7a42                	ld	s4,48(sp)
    80004efe:	7aa2                	ld	s5,40(sp)
    80004f00:	7b02                	ld	s6,32(sp)
    80004f02:	6be2                	ld	s7,24(sp)
    80004f04:	6c42                	ld	s8,16(sp)
    80004f06:	6125                	addi	sp,sp,96
    80004f08:	8082                	ret

0000000080004f0a <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004f0a:	1101                	addi	sp,sp,-32
    80004f0c:	ec06                	sd	ra,24(sp)
    80004f0e:	e822                	sd	s0,16(sp)
    80004f10:	e426                	sd	s1,8(sp)
    80004f12:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004f14:	00015497          	auipc	s1,0x15
    80004f18:	67c48493          	addi	s1,s1,1660 # 8001a590 <disk>
    80004f1c:	00015517          	auipc	a0,0x15
    80004f20:	79c50513          	addi	a0,a0,1948 # 8001a6b8 <disk+0x128>
    80004f24:	6f3000ef          	jal	80005e16 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004f28:	100017b7          	lui	a5,0x10001
    80004f2c:	53bc                	lw	a5,96(a5)
    80004f2e:	8b8d                	andi	a5,a5,3
    80004f30:	10001737          	lui	a4,0x10001
    80004f34:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004f36:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004f3a:	689c                	ld	a5,16(s1)
    80004f3c:	0204d703          	lhu	a4,32(s1)
    80004f40:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004f44:	04f70863          	beq	a4,a5,80004f94 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004f48:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004f4c:	6898                	ld	a4,16(s1)
    80004f4e:	0204d783          	lhu	a5,32(s1)
    80004f52:	8b9d                	andi	a5,a5,7
    80004f54:	078e                	slli	a5,a5,0x3
    80004f56:	97ba                	add	a5,a5,a4
    80004f58:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004f5a:	00479713          	slli	a4,a5,0x4
    80004f5e:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004f62:	9726                	add	a4,a4,s1
    80004f64:	01074703          	lbu	a4,16(a4)
    80004f68:	e329                	bnez	a4,80004faa <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004f6a:	0792                	slli	a5,a5,0x4
    80004f6c:	02078793          	addi	a5,a5,32
    80004f70:	97a6                	add	a5,a5,s1
    80004f72:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004f74:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004f78:	d4efc0ef          	jal	800014c6 <wakeup>

    disk.used_idx += 1;
    80004f7c:	0204d783          	lhu	a5,32(s1)
    80004f80:	2785                	addiw	a5,a5,1
    80004f82:	17c2                	slli	a5,a5,0x30
    80004f84:	93c1                	srli	a5,a5,0x30
    80004f86:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004f8a:	6898                	ld	a4,16(s1)
    80004f8c:	00275703          	lhu	a4,2(a4)
    80004f90:	faf71ce3          	bne	a4,a5,80004f48 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004f94:	00015517          	auipc	a0,0x15
    80004f98:	72450513          	addi	a0,a0,1828 # 8001a6b8 <disk+0x128>
    80004f9c:	763000ef          	jal	80005efe <release>
}
    80004fa0:	60e2                	ld	ra,24(sp)
    80004fa2:	6442                	ld	s0,16(sp)
    80004fa4:	64a2                	ld	s1,8(sp)
    80004fa6:	6105                	addi	sp,sp,32
    80004fa8:	8082                	ret
      panic("virtio_disk_intr status");
    80004faa:	00003517          	auipc	a0,0x3
    80004fae:	70650513          	addi	a0,a0,1798 # 800086b0 <etext+0x6b0>
    80004fb2:	339000ef          	jal	80005aea <panic>

0000000080004fb6 <statswrite>:
int statscopyin(char*, int);
int statslock(char*, int);
  
int
statswrite(int user_src, uint64 src, int n)
{
    80004fb6:	1141                	addi	sp,sp,-16
    80004fb8:	e406                	sd	ra,8(sp)
    80004fba:	e022                	sd	s0,0(sp)
    80004fbc:	0800                	addi	s0,sp,16
  return -1;
}
    80004fbe:	557d                	li	a0,-1
    80004fc0:	60a2                	ld	ra,8(sp)
    80004fc2:	6402                	ld	s0,0(sp)
    80004fc4:	0141                	addi	sp,sp,16
    80004fc6:	8082                	ret

0000000080004fc8 <statsread>:

int
statsread(int user_dst, uint64 dst, int n)
{
    80004fc8:	7179                	addi	sp,sp,-48
    80004fca:	f406                	sd	ra,40(sp)
    80004fcc:	f022                	sd	s0,32(sp)
    80004fce:	ec26                	sd	s1,24(sp)
    80004fd0:	e44e                	sd	s3,8(sp)
    80004fd2:	e052                	sd	s4,0(sp)
    80004fd4:	1800                	addi	s0,sp,48
    80004fd6:	89aa                	mv	s3,a0
    80004fd8:	8a2e                	mv	s4,a1
    80004fda:	84b2                	mv	s1,a2
  int m;

  acquire(&stats.lock);
    80004fdc:	00015517          	auipc	a0,0x15
    80004fe0:	7ec50513          	addi	a0,a0,2028 # 8001a7c8 <stats>
    80004fe4:	633000ef          	jal	80005e16 <acquire>

  if(stats.sz == 0) {
    80004fe8:	00017797          	auipc	a5,0x17
    80004fec:	8007a783          	lw	a5,-2048(a5) # 8001b7e8 <stats+0x1020>
    80004ff0:	c7b5                	beqz	a5,8000505c <statsread+0x94>
#endif
#ifdef LAB_LOCK
    stats.sz = statslock(stats.buf, BUFSZ);
#endif
  }
  m = stats.sz - stats.off;
    80004ff2:	00016797          	auipc	a5,0x16
    80004ff6:	7d678793          	addi	a5,a5,2006 # 8001b7c8 <stats+0x1000>
    80004ffa:	53d8                	lw	a4,36(a5)
    80004ffc:	539c                	lw	a5,32(a5)
    80004ffe:	9f99                	subw	a5,a5,a4

  if (m > 0) {
    80005000:	06f05a63          	blez	a5,80005074 <statsread+0xac>
    80005004:	e84a                	sd	s2,16(sp)
    if(m > n)
    80005006:	86be                	mv	a3,a5
    80005008:	00f4d363          	bge	s1,a5,8000500e <statsread+0x46>
    8000500c:	86a6                	mv	a3,s1
    8000500e:	8936                	mv	s2,a3
    80005010:	0006849b          	sext.w	s1,a3
      m  = n;
    if(either_copyout(user_dst, dst, stats.buf+stats.off, m) != -1) {
    80005014:	86a6                	mv	a3,s1
    80005016:	00015617          	auipc	a2,0x15
    8000501a:	7d260613          	addi	a2,a2,2002 # 8001a7e8 <stats+0x20>
    8000501e:	963a                	add	a2,a2,a4
    80005020:	85d2                	mv	a1,s4
    80005022:	854e                	mv	a0,s3
    80005024:	fb0fc0ef          	jal	800017d4 <either_copyout>
    80005028:	57fd                	li	a5,-1
    8000502a:	04f50f63          	beq	a0,a5,80005088 <statsread+0xc0>
      stats.off += m;
    8000502e:	00016717          	auipc	a4,0x16
    80005032:	79a70713          	addi	a4,a4,1946 # 8001b7c8 <stats+0x1000>
    80005036:	535c                	lw	a5,36(a4)
    80005038:	00f907bb          	addw	a5,s2,a5
    8000503c:	d35c                	sw	a5,36(a4)
    8000503e:	6942                	ld	s2,16(sp)
  } else {
    m = -1;
    stats.sz = 0;
    stats.off = 0;
  }
  release(&stats.lock);
    80005040:	00015517          	auipc	a0,0x15
    80005044:	78850513          	addi	a0,a0,1928 # 8001a7c8 <stats>
    80005048:	6b7000ef          	jal	80005efe <release>
  return m;
}
    8000504c:	8526                	mv	a0,s1
    8000504e:	70a2                	ld	ra,40(sp)
    80005050:	7402                	ld	s0,32(sp)
    80005052:	64e2                	ld	s1,24(sp)
    80005054:	69a2                	ld	s3,8(sp)
    80005056:	6a02                	ld	s4,0(sp)
    80005058:	6145                	addi	sp,sp,48
    8000505a:	8082                	ret
    stats.sz = statslock(stats.buf, BUFSZ);
    8000505c:	6585                	lui	a1,0x1
    8000505e:	00015517          	auipc	a0,0x15
    80005062:	78a50513          	addi	a0,a0,1930 # 8001a7e8 <stats+0x20>
    80005066:	4de010ef          	jal	80006544 <statslock>
    8000506a:	00016797          	auipc	a5,0x16
    8000506e:	76a7af23          	sw	a0,1918(a5) # 8001b7e8 <stats+0x1020>
    80005072:	b741                	j	80004ff2 <statsread+0x2a>
    stats.sz = 0;
    80005074:	00016797          	auipc	a5,0x16
    80005078:	75478793          	addi	a5,a5,1876 # 8001b7c8 <stats+0x1000>
    8000507c:	0207a023          	sw	zero,32(a5)
    stats.off = 0;
    80005080:	0207a223          	sw	zero,36(a5)
    m = -1;
    80005084:	54fd                	li	s1,-1
    80005086:	bf6d                	j	80005040 <statsread+0x78>
    80005088:	6942                	ld	s2,16(sp)
    8000508a:	bf5d                	j	80005040 <statsread+0x78>

000000008000508c <statsinit>:

void
statsinit(void)
{
    8000508c:	1141                	addi	sp,sp,-16
    8000508e:	e406                	sd	ra,8(sp)
    80005090:	e022                	sd	s0,0(sp)
    80005092:	0800                	addi	s0,sp,16
  initlock(&stats.lock, "stats");
    80005094:	00003597          	auipc	a1,0x3
    80005098:	63458593          	addi	a1,a1,1588 # 800086c8 <etext+0x6c8>
    8000509c:	00015517          	auipc	a0,0x15
    800050a0:	72c50513          	addi	a0,a0,1836 # 8001a7c8 <stats>
    800050a4:	6f3000ef          	jal	80005f96 <initlock>

  devsw[STATS].read = statsread;
    800050a8:	00014797          	auipc	a5,0x14
    800050ac:	48878793          	addi	a5,a5,1160 # 80019530 <devsw>
    800050b0:	00000717          	auipc	a4,0x0
    800050b4:	f1870713          	addi	a4,a4,-232 # 80004fc8 <statsread>
    800050b8:	f398                	sd	a4,32(a5)
  devsw[STATS].write = statswrite;
    800050ba:	00000717          	auipc	a4,0x0
    800050be:	efc70713          	addi	a4,a4,-260 # 80004fb6 <statswrite>
    800050c2:	f798                	sd	a4,40(a5)
}
    800050c4:	60a2                	ld	ra,8(sp)
    800050c6:	6402                	ld	s0,0(sp)
    800050c8:	0141                	addi	sp,sp,16
    800050ca:	8082                	ret

00000000800050cc <sprintint>:
  return 1;
}

static int
sprintint(char *s, int xx, int base, int sign)
{
    800050cc:	1101                	addi	sp,sp,-32
    800050ce:	ec06                	sd	ra,24(sp)
    800050d0:	e822                	sd	s0,16(sp)
    800050d2:	1000                	addi	s0,sp,32
    800050d4:	88aa                	mv	a7,a0
  char buf[16];
  int i, n;
  uint x;

  if(sign && (sign = xx < 0))
    800050d6:	c299                	beqz	a3,800050dc <sprintint+0x10>
    800050d8:	0805c263          	bltz	a1,8000515c <sprintint+0x90>
    x = -xx;
  else
    x = xx;
    800050dc:	4e81                	li	t4,0

  i = 0;
    800050de:	fe040693          	addi	a3,s0,-32
    x = xx;
    800050e2:	8736                	mv	a4,a3
  i = 0;
    800050e4:	4501                	li	a0,0
  do {
    buf[i++] = digits[x % base];
    800050e6:	00004317          	auipc	t1,0x4
    800050ea:	b5a30313          	addi	t1,t1,-1190 # 80008c40 <digits>
    800050ee:	8e2a                	mv	t3,a0
    800050f0:	0015081b          	addiw	a6,a0,1
    800050f4:	8542                	mv	a0,a6
    800050f6:	02c5f7bb          	remuw	a5,a1,a2
    800050fa:	1782                	slli	a5,a5,0x20
    800050fc:	9381                	srli	a5,a5,0x20
    800050fe:	979a                	add	a5,a5,t1
    80005100:	0007c783          	lbu	a5,0(a5)
    80005104:	00f70023          	sb	a5,0(a4)
  } while((x /= base) != 0);
    80005108:	87ae                	mv	a5,a1
    8000510a:	02c5d5bb          	divuw	a1,a1,a2
    8000510e:	0705                	addi	a4,a4,1
    80005110:	fcc7ffe3          	bgeu	a5,a2,800050ee <sprintint+0x22>

  if(sign)
    80005114:	000e8c63          	beqz	t4,8000512c <sprintint+0x60>
    buf[i++] = '-';
    80005118:	ff080793          	addi	a5,a6,-16
    8000511c:	00878833          	add	a6,a5,s0
    80005120:	02d00793          	li	a5,45
    80005124:	fef80823          	sb	a5,-16(a6)
    80005128:	002e051b          	addiw	a0,t3,2

  n = 0;
  while(--i >= 0)
    8000512c:	02a05c63          	blez	a0,80005164 <sprintint+0x98>
    80005130:	fff5059b          	addiw	a1,a0,-1
    80005134:	00b68733          	add	a4,a3,a1
    80005138:	87c6                	mv	a5,a7
    8000513a:	00188613          	addi	a2,a7,1
    8000513e:	1582                	slli	a1,a1,0x20
    80005140:	9181                	srli	a1,a1,0x20
    80005142:	962e                	add	a2,a2,a1
  *s = c;
    80005144:	00074683          	lbu	a3,0(a4)
    80005148:	00d78023          	sb	a3,0(a5)
  while(--i >= 0)
    8000514c:	177d                	addi	a4,a4,-1
    8000514e:	0785                	addi	a5,a5,1
    80005150:	fec79ae3          	bne	a5,a2,80005144 <sprintint+0x78>
    n += sputc(s+n, buf[i]);
  return n;
}
    80005154:	60e2                	ld	ra,24(sp)
    80005156:	6442                	ld	s0,16(sp)
    80005158:	6105                	addi	sp,sp,32
    8000515a:	8082                	ret
    x = -xx;
    8000515c:	40b005bb          	negw	a1,a1
  if(sign && (sign = xx < 0))
    80005160:	4e85                	li	t4,1
    x = -xx;
    80005162:	bfb5                	j	800050de <sprintint+0x12>
  while(--i >= 0)
    80005164:	4501                	li	a0,0
    80005166:	b7fd                	j	80005154 <sprintint+0x88>

0000000080005168 <snprintf>:

int
snprintf(char *buf, unsigned long sz, const char *fmt, ...)
{
    80005168:	7135                	addi	sp,sp,-160
    8000516a:	f486                	sd	ra,104(sp)
    8000516c:	f0a2                	sd	s0,96(sp)
    8000516e:	eca6                	sd	s1,88(sp)
    80005170:	1880                	addi	s0,sp,112
    80005172:	e414                	sd	a3,8(s0)
    80005174:	e818                	sd	a4,16(s0)
    80005176:	ec1c                	sd	a5,24(s0)
    80005178:	03043023          	sd	a6,32(s0)
    8000517c:	03143423          	sd	a7,40(s0)
  va_list ap;
  int i, c;
  int off = 0;
  char *s;

  va_start(ap, fmt);
    80005180:	00840793          	addi	a5,s0,8
    80005184:	f8f43c23          	sd	a5,-104(s0)
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    80005188:	c995                	beqz	a1,800051bc <snprintf+0x54>
    8000518a:	e8ca                	sd	s2,80(sp)
    8000518c:	e4ce                	sd	s3,72(sp)
    8000518e:	e0d2                	sd	s4,64(sp)
    80005190:	fc56                	sd	s5,56(sp)
    80005192:	f85a                	sd	s6,48(sp)
    80005194:	f45e                	sd	s7,40(sp)
    80005196:	f062                	sd	s8,32(sp)
    80005198:	ec66                	sd	s9,24(sp)
    8000519a:	e86a                	sd	s10,16(sp)
    8000519c:	8a2a                	mv	s4,a0
    8000519e:	89ae                	mv	s3,a1
    800051a0:	8ab2                	mv	s5,a2
    800051a2:	4481                	li	s1,0
    800051a4:	4901                	li	s2,0
    800051a6:	4501                	li	a0,0
    if(c != '%'){
    800051a8:	02500b13          	li	s6,37
      continue;
    }
    c = fmt[++i] & 0xff;
    if(c == 0)
      break;
    switch(c){
    800051ac:	07300b93          	li	s7,115
    800051b0:	07800d13          	li	s10,120
    case 'd':
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
      break;
    case 'x':
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    800051b4:	4c05                	li	s8,1
    switch(c){
    800051b6:	06400c93          	li	s9,100
    800051ba:	a819                	j	800051d0 <snprintf+0x68>
  int off = 0;
    800051bc:	4481                	li	s1,0
    800051be:	a8c5                	j	800052ae <snprintf+0x146>
  *s = c;
    800051c0:	9552                	add	a0,a0,s4
    800051c2:	00f50023          	sb	a5,0(a0)
      off += sputc(buf+off, c);
    800051c6:	2485                	addiw	s1,s1,1
  for(i = 0; off < sz && (c = fmt[i] & 0xff) != 0; i++){
    800051c8:	2905                	addiw	s2,s2,1
    800051ca:	8526                	mv	a0,s1
    800051cc:	1134f163          	bgeu	s1,s3,800052ce <snprintf+0x166>
    800051d0:	012a87b3          	add	a5,s5,s2
    800051d4:	0007c783          	lbu	a5,0(a5)
    800051d8:	0007871b          	sext.w	a4,a5
    800051dc:	c3e1                	beqz	a5,8000529c <snprintf+0x134>
    if(c != '%'){
    800051de:	ff6711e3          	bne	a4,s6,800051c0 <snprintf+0x58>
    c = fmt[++i] & 0xff;
    800051e2:	0019079b          	addiw	a5,s2,1
    800051e6:	893e                	mv	s2,a5
    800051e8:	97d6                	add	a5,a5,s5
    800051ea:	0007c783          	lbu	a5,0(a5)
    if(c == 0)
    800051ee:	c7f1                	beqz	a5,800052ba <snprintf+0x152>
    switch(c){
    800051f0:	05778663          	beq	a5,s7,8000523c <snprintf+0xd4>
    800051f4:	02fbe463          	bltu	s7,a5,8000521c <snprintf+0xb4>
    800051f8:	09678363          	beq	a5,s6,8000527e <snprintf+0x116>
    800051fc:	09979663          	bne	a5,s9,80005288 <snprintf+0x120>
      off += sprintint(buf+off, va_arg(ap, int), 10, 1);
    80005200:	f9843783          	ld	a5,-104(s0)
    80005204:	00878713          	addi	a4,a5,8
    80005208:	f8e43c23          	sd	a4,-104(s0)
    8000520c:	86e2                	mv	a3,s8
    8000520e:	4629                	li	a2,10
    80005210:	438c                	lw	a1,0(a5)
    80005212:	9552                	add	a0,a0,s4
    80005214:	eb9ff0ef          	jal	800050cc <sprintint>
    80005218:	9ca9                	addw	s1,s1,a0
      break;
    8000521a:	b77d                	j	800051c8 <snprintf+0x60>
    switch(c){
    8000521c:	07a79663          	bne	a5,s10,80005288 <snprintf+0x120>
      off += sprintint(buf+off, va_arg(ap, int), 16, 1);
    80005220:	f9843783          	ld	a5,-104(s0)
    80005224:	00878713          	addi	a4,a5,8
    80005228:	f8e43c23          	sd	a4,-104(s0)
    8000522c:	86e2                	mv	a3,s8
    8000522e:	4641                	li	a2,16
    80005230:	438c                	lw	a1,0(a5)
    80005232:	9552                	add	a0,a0,s4
    80005234:	e99ff0ef          	jal	800050cc <sprintint>
    80005238:	9ca9                	addw	s1,s1,a0
      break;
    8000523a:	b779                	j	800051c8 <snprintf+0x60>
    case 's':
      if((s = va_arg(ap, char*)) == 0)
    8000523c:	f9843783          	ld	a5,-104(s0)
    80005240:	00878713          	addi	a4,a5,8
    80005244:	f8e43c23          	sd	a4,-104(s0)
    80005248:	6398                	ld	a4,0(a5)
    8000524a:	c70d                	beqz	a4,80005274 <snprintf+0x10c>
        s = "(null)";
      for(; *s && off < sz; s++)
    8000524c:	00074683          	lbu	a3,0(a4)
    80005250:	87a6                	mv	a5,s1
    80005252:	f734fbe3          	bgeu	s1,s3,800051c8 <snprintf+0x60>
    80005256:	daad                	beqz	a3,800051c8 <snprintf+0x60>
  *s = c;
    80005258:	00fa0633          	add	a2,s4,a5
    8000525c:	00d60023          	sb	a3,0(a2)
      for(; *s && off < sz; s++)
    80005260:	0705                	addi	a4,a4,1
    80005262:	00074683          	lbu	a3,0(a4)
    80005266:	84be                	mv	s1,a5
    80005268:	0785                	addi	a5,a5,1
    8000526a:	0137f363          	bgeu	a5,s3,80005270 <snprintf+0x108>
    8000526e:	f6ed                	bnez	a3,80005258 <snprintf+0xf0>
        off += sputc(buf+off, *s);
    80005270:	2485                	addiw	s1,s1,1
    80005272:	bf99                	j	800051c8 <snprintf+0x60>
        s = "(null)";
    80005274:	00003717          	auipc	a4,0x3
    80005278:	45c70713          	addi	a4,a4,1116 # 800086d0 <etext+0x6d0>
    8000527c:	bfc1                	j	8000524c <snprintf+0xe4>
  *s = c;
    8000527e:	9552                	add	a0,a0,s4
    80005280:	01650023          	sb	s6,0(a0)
      break;
    case '%':
      off += sputc(buf+off, '%');
    80005284:	2485                	addiw	s1,s1,1
      break;
    80005286:	b789                	j	800051c8 <snprintf+0x60>
  *s = c;
    80005288:	9552                	add	a0,a0,s4
    8000528a:	01650023          	sb	s6,0(a0)
    default:
      // Print unknown % sequence to draw attention.
      off += sputc(buf+off, '%');
    8000528e:	0014871b          	addiw	a4,s1,1
  *s = c;
    80005292:	9752                	add	a4,a4,s4
    80005294:	00f70023          	sb	a5,0(a4)
      off += sputc(buf+off, c);
    80005298:	2489                	addiw	s1,s1,2
      break;
    8000529a:	b73d                	j	800051c8 <snprintf+0x60>
    8000529c:	6946                	ld	s2,80(sp)
    8000529e:	69a6                	ld	s3,72(sp)
    800052a0:	6a06                	ld	s4,64(sp)
    800052a2:	7ae2                	ld	s5,56(sp)
    800052a4:	7b42                	ld	s6,48(sp)
    800052a6:	7ba2                	ld	s7,40(sp)
    800052a8:	7c02                	ld	s8,32(sp)
    800052aa:	6ce2                	ld	s9,24(sp)
    800052ac:	6d42                	ld	s10,16(sp)
    }
  }
  return off;
}
    800052ae:	8526                	mv	a0,s1
    800052b0:	70a6                	ld	ra,104(sp)
    800052b2:	7406                	ld	s0,96(sp)
    800052b4:	64e6                	ld	s1,88(sp)
    800052b6:	610d                	addi	sp,sp,160
    800052b8:	8082                	ret
    800052ba:	6946                	ld	s2,80(sp)
    800052bc:	69a6                	ld	s3,72(sp)
    800052be:	6a06                	ld	s4,64(sp)
    800052c0:	7ae2                	ld	s5,56(sp)
    800052c2:	7b42                	ld	s6,48(sp)
    800052c4:	7ba2                	ld	s7,40(sp)
    800052c6:	7c02                	ld	s8,32(sp)
    800052c8:	6ce2                	ld	s9,24(sp)
    800052ca:	6d42                	ld	s10,16(sp)
    800052cc:	b7cd                	j	800052ae <snprintf+0x146>
    800052ce:	6946                	ld	s2,80(sp)
    800052d0:	69a6                	ld	s3,72(sp)
    800052d2:	6a06                	ld	s4,64(sp)
    800052d4:	7ae2                	ld	s5,56(sp)
    800052d6:	7b42                	ld	s6,48(sp)
    800052d8:	7ba2                	ld	s7,40(sp)
    800052da:	7c02                	ld	s8,32(sp)
    800052dc:	6ce2                	ld	s9,24(sp)
    800052de:	6d42                	ld	s10,16(sp)
    800052e0:	b7f9                	j	800052ae <snprintf+0x146>

00000000800052e2 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800052e2:	1141                	addi	sp,sp,-16
    800052e4:	e406                	sd	ra,8(sp)
    800052e6:	e022                	sd	s0,0(sp)
    800052e8:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800052ea:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800052ee:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800052f2:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800052f6:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800052fa:	577d                	li	a4,-1
    800052fc:	177e                	slli	a4,a4,0x3f
    800052fe:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80005300:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80005304:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80005308:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    8000530c:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005310:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80005314:	000f4737          	lui	a4,0xf4
    80005318:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000531c:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000531e:	14d79073          	csrw	stimecmp,a5
}
    80005322:	60a2                	ld	ra,8(sp)
    80005324:	6402                	ld	s0,0(sp)
    80005326:	0141                	addi	sp,sp,16
    80005328:	8082                	ret

000000008000532a <start>:
{
    8000532a:	1141                	addi	sp,sp,-16
    8000532c:	e406                	sd	ra,8(sp)
    8000532e:	e022                	sd	s0,0(sp)
    80005330:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005332:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005336:	7779                	lui	a4,0xffffe
    80005338:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd9f3f>
    8000533c:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000533e:	6705                	lui	a4,0x1
    80005340:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005344:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005346:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    8000534a:	ffffb797          	auipc	a5,0xffffb
    8000534e:	08a78793          	addi	a5,a5,138 # 800003d4 <main>
    80005352:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005356:	4781                	li	a5,0
    80005358:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    8000535c:	67c1                	lui	a5,0x10
    8000535e:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005360:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005364:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005368:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    8000536c:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80005370:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005374:	57fd                	li	a5,-1
    80005376:	83a9                	srli	a5,a5,0xa
    80005378:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    8000537c:	47bd                	li	a5,15
    8000537e:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005382:	f61ff0ef          	jal	800052e2 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005386:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    8000538a:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    8000538c:	823e                	mv	tp,a5
  asm volatile("mret");
    8000538e:	30200073          	mret
}
    80005392:	60a2                	ld	ra,8(sp)
    80005394:	6402                	ld	s0,0(sp)
    80005396:	0141                	addi	sp,sp,16
    80005398:	8082                	ret

000000008000539a <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    8000539a:	7119                	addi	sp,sp,-128
    8000539c:	fc86                	sd	ra,120(sp)
    8000539e:	f8a2                	sd	s0,112(sp)
    800053a0:	f4a6                	sd	s1,104(sp)
    800053a2:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    800053a4:	06c05b63          	blez	a2,8000541a <consolewrite+0x80>
    800053a8:	f0ca                	sd	s2,96(sp)
    800053aa:	ecce                	sd	s3,88(sp)
    800053ac:	e8d2                	sd	s4,80(sp)
    800053ae:	e4d6                	sd	s5,72(sp)
    800053b0:	e0da                	sd	s6,64(sp)
    800053b2:	fc5e                	sd	s7,56(sp)
    800053b4:	f862                	sd	s8,48(sp)
    800053b6:	f466                	sd	s9,40(sp)
    800053b8:	f06a                	sd	s10,32(sp)
    800053ba:	8b2a                	mv	s6,a0
    800053bc:	8bae                	mv	s7,a1
    800053be:	8a32                	mv	s4,a2
  int i = 0;
    800053c0:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800053c2:	02000c93          	li	s9,32
    800053c6:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800053ca:	f8040a93          	addi	s5,s0,-128
    800053ce:	5c7d                	li	s8,-1
    800053d0:	a025                	j	800053f8 <consolewrite+0x5e>
    if(nn > n - i)
    800053d2:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800053d6:	86ce                	mv	a3,s3
    800053d8:	01748633          	add	a2,s1,s7
    800053dc:	85da                	mv	a1,s6
    800053de:	8556                	mv	a0,s5
    800053e0:	c3efc0ef          	jal	8000181e <either_copyin>
    800053e4:	03850d63          	beq	a0,s8,8000541e <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    800053e8:	85ce                	mv	a1,s3
    800053ea:	8556                	mv	a0,s5
    800053ec:	7b4000ef          	jal	80005ba0 <uartwrite>
    i += nn;
    800053f0:	009904bb          	addw	s1,s2,s1
  while(i < n){
    800053f4:	0144d963          	bge	s1,s4,80005406 <consolewrite+0x6c>
    if(nn > n - i)
    800053f8:	409a07bb          	subw	a5,s4,s1
    800053fc:	893e                	mv	s2,a5
    800053fe:	fcfcdae3          	bge	s9,a5,800053d2 <consolewrite+0x38>
    80005402:	896a                	mv	s2,s10
    80005404:	b7f9                	j	800053d2 <consolewrite+0x38>
    80005406:	7906                	ld	s2,96(sp)
    80005408:	69e6                	ld	s3,88(sp)
    8000540a:	6a46                	ld	s4,80(sp)
    8000540c:	6aa6                	ld	s5,72(sp)
    8000540e:	6b06                	ld	s6,64(sp)
    80005410:	7be2                	ld	s7,56(sp)
    80005412:	7c42                	ld	s8,48(sp)
    80005414:	7ca2                	ld	s9,40(sp)
    80005416:	7d02                	ld	s10,32(sp)
    80005418:	a821                	j	80005430 <consolewrite+0x96>
  int i = 0;
    8000541a:	4481                	li	s1,0
    8000541c:	a811                	j	80005430 <consolewrite+0x96>
    8000541e:	7906                	ld	s2,96(sp)
    80005420:	69e6                	ld	s3,88(sp)
    80005422:	6a46                	ld	s4,80(sp)
    80005424:	6aa6                	ld	s5,72(sp)
    80005426:	6b06                	ld	s6,64(sp)
    80005428:	7be2                	ld	s7,56(sp)
    8000542a:	7c42                	ld	s8,48(sp)
    8000542c:	7ca2                	ld	s9,40(sp)
    8000542e:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    80005430:	8526                	mv	a0,s1
    80005432:	70e6                	ld	ra,120(sp)
    80005434:	7446                	ld	s0,112(sp)
    80005436:	74a6                	ld	s1,104(sp)
    80005438:	6109                	addi	sp,sp,128
    8000543a:	8082                	ret

000000008000543c <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    8000543c:	711d                	addi	sp,sp,-96
    8000543e:	ec86                	sd	ra,88(sp)
    80005440:	e8a2                	sd	s0,80(sp)
    80005442:	e4a6                	sd	s1,72(sp)
    80005444:	e0ca                	sd	s2,64(sp)
    80005446:	fc4e                	sd	s3,56(sp)
    80005448:	f852                	sd	s4,48(sp)
    8000544a:	f05a                	sd	s6,32(sp)
    8000544c:	ec5e                	sd	s7,24(sp)
    8000544e:	1080                	addi	s0,sp,96
    80005450:	8b2a                	mv	s6,a0
    80005452:	8a2e                	mv	s4,a1
    80005454:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005456:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80005458:	0001e517          	auipc	a0,0x1e
    8000545c:	39850513          	addi	a0,a0,920 # 800237f0 <cons>
    80005460:	1b7000ef          	jal	80005e16 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005464:	0001e497          	auipc	s1,0x1e
    80005468:	38c48493          	addi	s1,s1,908 # 800237f0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    8000546c:	0001e917          	auipc	s2,0x1e
    80005470:	42490913          	addi	s2,s2,1060 # 80023890 <cons+0xa0>
  while(n > 0){
    80005474:	0b305b63          	blez	s3,8000552a <consoleread+0xee>
    while(cons.r == cons.w){
    80005478:	0a04a783          	lw	a5,160(s1)
    8000547c:	0a44a703          	lw	a4,164(s1)
    80005480:	0af71063          	bne	a4,a5,80005520 <consoleread+0xe4>
      if(killed(myproc())){
    80005484:	9cdfb0ef          	jal	80000e50 <myproc>
    80005488:	a2efc0ef          	jal	800016b6 <killed>
    8000548c:	e12d                	bnez	a0,800054ee <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000548e:	85a6                	mv	a1,s1
    80005490:	854a                	mv	a0,s2
    80005492:	fe9fb0ef          	jal	8000147a <sleep>
    while(cons.r == cons.w){
    80005496:	0a04a783          	lw	a5,160(s1)
    8000549a:	0a44a703          	lw	a4,164(s1)
    8000549e:	fef703e3          	beq	a4,a5,80005484 <consoleread+0x48>
    800054a2:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800054a4:	0001e717          	auipc	a4,0x1e
    800054a8:	34c70713          	addi	a4,a4,844 # 800237f0 <cons>
    800054ac:	0017869b          	addiw	a3,a5,1
    800054b0:	0ad72023          	sw	a3,160(a4)
    800054b4:	07f7f693          	andi	a3,a5,127
    800054b8:	9736                	add	a4,a4,a3
    800054ba:	02074703          	lbu	a4,32(a4)
    800054be:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800054c2:	4691                	li	a3,4
    800054c4:	04da8663          	beq	s5,a3,80005510 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800054c8:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800054cc:	4685                	li	a3,1
    800054ce:	faf40613          	addi	a2,s0,-81
    800054d2:	85d2                	mv	a1,s4
    800054d4:	855a                	mv	a0,s6
    800054d6:	afefc0ef          	jal	800017d4 <either_copyout>
    800054da:	57fd                	li	a5,-1
    800054dc:	04f50663          	beq	a0,a5,80005528 <consoleread+0xec>
      break;

    dst++;
    800054e0:	0a05                	addi	s4,s4,1
    --n;
    800054e2:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800054e4:	47a9                	li	a5,10
    800054e6:	04fa8b63          	beq	s5,a5,8000553c <consoleread+0x100>
    800054ea:	7aa2                	ld	s5,40(sp)
    800054ec:	b761                	j	80005474 <consoleread+0x38>
        release(&cons.lock);
    800054ee:	0001e517          	auipc	a0,0x1e
    800054f2:	30250513          	addi	a0,a0,770 # 800237f0 <cons>
    800054f6:	209000ef          	jal	80005efe <release>
        return -1;
    800054fa:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800054fc:	60e6                	ld	ra,88(sp)
    800054fe:	6446                	ld	s0,80(sp)
    80005500:	64a6                	ld	s1,72(sp)
    80005502:	6906                	ld	s2,64(sp)
    80005504:	79e2                	ld	s3,56(sp)
    80005506:	7a42                	ld	s4,48(sp)
    80005508:	7b02                	ld	s6,32(sp)
    8000550a:	6be2                	ld	s7,24(sp)
    8000550c:	6125                	addi	sp,sp,96
    8000550e:	8082                	ret
      if(n < target){
    80005510:	0179fa63          	bgeu	s3,s7,80005524 <consoleread+0xe8>
        cons.r--;
    80005514:	0001e717          	auipc	a4,0x1e
    80005518:	36f72e23          	sw	a5,892(a4) # 80023890 <cons+0xa0>
    8000551c:	7aa2                	ld	s5,40(sp)
    8000551e:	a031                	j	8000552a <consoleread+0xee>
    80005520:	f456                	sd	s5,40(sp)
    80005522:	b749                	j	800054a4 <consoleread+0x68>
    80005524:	7aa2                	ld	s5,40(sp)
    80005526:	a011                	j	8000552a <consoleread+0xee>
    80005528:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    8000552a:	0001e517          	auipc	a0,0x1e
    8000552e:	2c650513          	addi	a0,a0,710 # 800237f0 <cons>
    80005532:	1cd000ef          	jal	80005efe <release>
  return target - n;
    80005536:	413b853b          	subw	a0,s7,s3
    8000553a:	b7c9                	j	800054fc <consoleread+0xc0>
    8000553c:	7aa2                	ld	s5,40(sp)
    8000553e:	b7f5                	j	8000552a <consoleread+0xee>

0000000080005540 <consputc>:
{
    80005540:	1141                	addi	sp,sp,-16
    80005542:	e406                	sd	ra,8(sp)
    80005544:	e022                	sd	s0,0(sp)
    80005546:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005548:	10000793          	li	a5,256
    8000554c:	00f50863          	beq	a0,a5,8000555c <consputc+0x1c>
    uartputc_sync(c);
    80005550:	6e4000ef          	jal	80005c34 <uartputc_sync>
}
    80005554:	60a2                	ld	ra,8(sp)
    80005556:	6402                	ld	s0,0(sp)
    80005558:	0141                	addi	sp,sp,16
    8000555a:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    8000555c:	4521                	li	a0,8
    8000555e:	6d6000ef          	jal	80005c34 <uartputc_sync>
    80005562:	02000513          	li	a0,32
    80005566:	6ce000ef          	jal	80005c34 <uartputc_sync>
    8000556a:	4521                	li	a0,8
    8000556c:	6c8000ef          	jal	80005c34 <uartputc_sync>
    80005570:	b7d5                	j	80005554 <consputc+0x14>

0000000080005572 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005572:	1101                	addi	sp,sp,-32
    80005574:	ec06                	sd	ra,24(sp)
    80005576:	e822                	sd	s0,16(sp)
    80005578:	e426                	sd	s1,8(sp)
    8000557a:	1000                	addi	s0,sp,32
    8000557c:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000557e:	0001e517          	auipc	a0,0x1e
    80005582:	27250513          	addi	a0,a0,626 # 800237f0 <cons>
    80005586:	091000ef          	jal	80005e16 <acquire>

  switch(c){
    8000558a:	47d5                	li	a5,21
    8000558c:	08f48d63          	beq	s1,a5,80005626 <consoleintr+0xb4>
    80005590:	0297c563          	blt	a5,s1,800055ba <consoleintr+0x48>
    80005594:	47a1                	li	a5,8
    80005596:	0ef48263          	beq	s1,a5,8000567a <consoleintr+0x108>
    8000559a:	47c1                	li	a5,16
    8000559c:	10f49363          	bne	s1,a5,800056a2 <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800055a0:	ac8fc0ef          	jal	80001868 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800055a4:	0001e517          	auipc	a0,0x1e
    800055a8:	24c50513          	addi	a0,a0,588 # 800237f0 <cons>
    800055ac:	153000ef          	jal	80005efe <release>
}
    800055b0:	60e2                	ld	ra,24(sp)
    800055b2:	6442                	ld	s0,16(sp)
    800055b4:	64a2                	ld	s1,8(sp)
    800055b6:	6105                	addi	sp,sp,32
    800055b8:	8082                	ret
  switch(c){
    800055ba:	07f00793          	li	a5,127
    800055be:	0af48e63          	beq	s1,a5,8000567a <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800055c2:	0001e717          	auipc	a4,0x1e
    800055c6:	22e70713          	addi	a4,a4,558 # 800237f0 <cons>
    800055ca:	0a872783          	lw	a5,168(a4)
    800055ce:	0a072703          	lw	a4,160(a4)
    800055d2:	9f99                	subw	a5,a5,a4
    800055d4:	07f00713          	li	a4,127
    800055d8:	fcf766e3          	bltu	a4,a5,800055a4 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800055dc:	47b5                	li	a5,13
    800055de:	0cf48563          	beq	s1,a5,800056a8 <consoleintr+0x136>
      consputc(c);
    800055e2:	8526                	mv	a0,s1
    800055e4:	f5dff0ef          	jal	80005540 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800055e8:	0001e717          	auipc	a4,0x1e
    800055ec:	20870713          	addi	a4,a4,520 # 800237f0 <cons>
    800055f0:	0a872683          	lw	a3,168(a4)
    800055f4:	0016879b          	addiw	a5,a3,1
    800055f8:	863e                	mv	a2,a5
    800055fa:	0af72423          	sw	a5,168(a4)
    800055fe:	07f6f693          	andi	a3,a3,127
    80005602:	9736                	add	a4,a4,a3
    80005604:	02970023          	sb	s1,32(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005608:	ff648713          	addi	a4,s1,-10
    8000560c:	c371                	beqz	a4,800056d0 <consoleintr+0x15e>
    8000560e:	14f1                	addi	s1,s1,-4
    80005610:	c0e1                	beqz	s1,800056d0 <consoleintr+0x15e>
    80005612:	0001e717          	auipc	a4,0x1e
    80005616:	27e72703          	lw	a4,638(a4) # 80023890 <cons+0xa0>
    8000561a:	9f99                	subw	a5,a5,a4
    8000561c:	08000713          	li	a4,128
    80005620:	f8e792e3          	bne	a5,a4,800055a4 <consoleintr+0x32>
    80005624:	a075                	j	800056d0 <consoleintr+0x15e>
    80005626:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005628:	0001e717          	auipc	a4,0x1e
    8000562c:	1c870713          	addi	a4,a4,456 # 800237f0 <cons>
    80005630:	0a872783          	lw	a5,168(a4)
    80005634:	0a472703          	lw	a4,164(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005638:	0001e497          	auipc	s1,0x1e
    8000563c:	1b848493          	addi	s1,s1,440 # 800237f0 <cons>
    while(cons.e != cons.w &&
    80005640:	4929                	li	s2,10
    80005642:	02f70863          	beq	a4,a5,80005672 <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005646:	37fd                	addiw	a5,a5,-1
    80005648:	07f7f713          	andi	a4,a5,127
    8000564c:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000564e:	02074703          	lbu	a4,32(a4)
    80005652:	03270263          	beq	a4,s2,80005676 <consoleintr+0x104>
      cons.e--;
    80005656:	0af4a423          	sw	a5,168(s1)
      consputc(BACKSPACE);
    8000565a:	10000513          	li	a0,256
    8000565e:	ee3ff0ef          	jal	80005540 <consputc>
    while(cons.e != cons.w &&
    80005662:	0a84a783          	lw	a5,168(s1)
    80005666:	0a44a703          	lw	a4,164(s1)
    8000566a:	fcf71ee3          	bne	a4,a5,80005646 <consoleintr+0xd4>
    8000566e:	6902                	ld	s2,0(sp)
    80005670:	bf15                	j	800055a4 <consoleintr+0x32>
    80005672:	6902                	ld	s2,0(sp)
    80005674:	bf05                	j	800055a4 <consoleintr+0x32>
    80005676:	6902                	ld	s2,0(sp)
    80005678:	b735                	j	800055a4 <consoleintr+0x32>
    if(cons.e != cons.w){
    8000567a:	0001e717          	auipc	a4,0x1e
    8000567e:	17670713          	addi	a4,a4,374 # 800237f0 <cons>
    80005682:	0a872783          	lw	a5,168(a4)
    80005686:	0a472703          	lw	a4,164(a4)
    8000568a:	f0f70de3          	beq	a4,a5,800055a4 <consoleintr+0x32>
      cons.e--;
    8000568e:	37fd                	addiw	a5,a5,-1
    80005690:	0001e717          	auipc	a4,0x1e
    80005694:	20f72423          	sw	a5,520(a4) # 80023898 <cons+0xa8>
      consputc(BACKSPACE);
    80005698:	10000513          	li	a0,256
    8000569c:	ea5ff0ef          	jal	80005540 <consputc>
    800056a0:	b711                	j	800055a4 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800056a2:	f00481e3          	beqz	s1,800055a4 <consoleintr+0x32>
    800056a6:	bf31                	j	800055c2 <consoleintr+0x50>
      consputc(c);
    800056a8:	4529                	li	a0,10
    800056aa:	e97ff0ef          	jal	80005540 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800056ae:	0001e797          	auipc	a5,0x1e
    800056b2:	14278793          	addi	a5,a5,322 # 800237f0 <cons>
    800056b6:	0a87a703          	lw	a4,168(a5)
    800056ba:	0017069b          	addiw	a3,a4,1
    800056be:	8636                	mv	a2,a3
    800056c0:	0ad7a423          	sw	a3,168(a5)
    800056c4:	07f77713          	andi	a4,a4,127
    800056c8:	97ba                	add	a5,a5,a4
    800056ca:	4729                	li	a4,10
    800056cc:	02e78023          	sb	a4,32(a5)
        cons.w = cons.e;
    800056d0:	0001e797          	auipc	a5,0x1e
    800056d4:	1cc7a223          	sw	a2,452(a5) # 80023894 <cons+0xa4>
        wakeup(&cons.r);
    800056d8:	0001e517          	auipc	a0,0x1e
    800056dc:	1b850513          	addi	a0,a0,440 # 80023890 <cons+0xa0>
    800056e0:	de7fb0ef          	jal	800014c6 <wakeup>
    800056e4:	b5c1                	j	800055a4 <consoleintr+0x32>

00000000800056e6 <consoleinit>:

void
consoleinit(void)
{
    800056e6:	1141                	addi	sp,sp,-16
    800056e8:	e406                	sd	ra,8(sp)
    800056ea:	e022                	sd	s0,0(sp)
    800056ec:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800056ee:	00003597          	auipc	a1,0x3
    800056f2:	fea58593          	addi	a1,a1,-22 # 800086d8 <etext+0x6d8>
    800056f6:	0001e517          	auipc	a0,0x1e
    800056fa:	0fa50513          	addi	a0,a0,250 # 800237f0 <cons>
    800056fe:	099000ef          	jal	80005f96 <initlock>

  uartinit();
    80005702:	448000ef          	jal	80005b4a <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005706:	00014797          	auipc	a5,0x14
    8000570a:	e2a78793          	addi	a5,a5,-470 # 80019530 <devsw>
    8000570e:	00000717          	auipc	a4,0x0
    80005712:	d2e70713          	addi	a4,a4,-722 # 8000543c <consoleread>
    80005716:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005718:	00000717          	auipc	a4,0x0
    8000571c:	c8270713          	addi	a4,a4,-894 # 8000539a <consolewrite>
    80005720:	ef98                	sd	a4,24(a5)
}
    80005722:	60a2                	ld	ra,8(sp)
    80005724:	6402                	ld	s0,0(sp)
    80005726:	0141                	addi	sp,sp,16
    80005728:	8082                	ret

000000008000572a <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    8000572a:	7139                	addi	sp,sp,-64
    8000572c:	fc06                	sd	ra,56(sp)
    8000572e:	f822                	sd	s0,48(sp)
    80005730:	f04a                	sd	s2,32(sp)
    80005732:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005734:	c219                	beqz	a2,8000573a <printint+0x10>
    80005736:	08054163          	bltz	a0,800057b8 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    8000573a:	4301                	li	t1,0

  i = 0;
    8000573c:	fc840913          	addi	s2,s0,-56
    x = xx;
    80005740:	86ca                	mv	a3,s2
  i = 0;
    80005742:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005744:	00003817          	auipc	a6,0x3
    80005748:	51480813          	addi	a6,a6,1300 # 80008c58 <digits>
    8000574c:	88ba                	mv	a7,a4
    8000574e:	0017061b          	addiw	a2,a4,1
    80005752:	8732                	mv	a4,a2
    80005754:	02b577b3          	remu	a5,a0,a1
    80005758:	97c2                	add	a5,a5,a6
    8000575a:	0007c783          	lbu	a5,0(a5)
    8000575e:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005762:	87aa                	mv	a5,a0
    80005764:	02b55533          	divu	a0,a0,a1
    80005768:	0685                	addi	a3,a3,1
    8000576a:	feb7f1e3          	bgeu	a5,a1,8000574c <printint+0x22>

  if(sign)
    8000576e:	00030c63          	beqz	t1,80005786 <printint+0x5c>
    buf[i++] = '-';
    80005772:	fe060793          	addi	a5,a2,-32
    80005776:	00878633          	add	a2,a5,s0
    8000577a:	02d00793          	li	a5,45
    8000577e:	fef60423          	sb	a5,-24(a2)
    80005782:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80005786:	02e05463          	blez	a4,800057ae <printint+0x84>
    8000578a:	f426                	sd	s1,40(sp)
    8000578c:	377d                	addiw	a4,a4,-1
    8000578e:	00e904b3          	add	s1,s2,a4
    80005792:	197d                	addi	s2,s2,-1
    80005794:	993a                	add	s2,s2,a4
    80005796:	1702                	slli	a4,a4,0x20
    80005798:	9301                	srli	a4,a4,0x20
    8000579a:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000579e:	0004c503          	lbu	a0,0(s1)
    800057a2:	d9fff0ef          	jal	80005540 <consputc>
  while(--i >= 0)
    800057a6:	14fd                	addi	s1,s1,-1
    800057a8:	ff249be3          	bne	s1,s2,8000579e <printint+0x74>
    800057ac:	74a2                	ld	s1,40(sp)
}
    800057ae:	70e2                	ld	ra,56(sp)
    800057b0:	7442                	ld	s0,48(sp)
    800057b2:	7902                	ld	s2,32(sp)
    800057b4:	6121                	addi	sp,sp,64
    800057b6:	8082                	ret
    x = -xx;
    800057b8:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800057bc:	4305                	li	t1,1
    x = -xx;
    800057be:	bfbd                	j	8000573c <printint+0x12>

00000000800057c0 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800057c0:	7131                	addi	sp,sp,-192
    800057c2:	fc86                	sd	ra,120(sp)
    800057c4:	f8a2                	sd	s0,112(sp)
    800057c6:	f0ca                	sd	s2,96(sp)
    800057c8:	0100                	addi	s0,sp,128
    800057ca:	892a                	mv	s2,a0
    800057cc:	e40c                	sd	a1,8(s0)
    800057ce:	e810                	sd	a2,16(s0)
    800057d0:	ec14                	sd	a3,24(s0)
    800057d2:	f018                	sd	a4,32(s0)
    800057d4:	f41c                	sd	a5,40(s0)
    800057d6:	03043823          	sd	a6,48(s0)
    800057da:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    800057de:	00003797          	auipc	a5,0x3
    800057e2:	4c27a783          	lw	a5,1218(a5) # 80008ca0 <panicking>
    800057e6:	cf9d                	beqz	a5,80005824 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800057e8:	00840793          	addi	a5,s0,8
    800057ec:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800057f0:	00094503          	lbu	a0,0(s2)
    800057f4:	22050663          	beqz	a0,80005a20 <printf+0x260>
    800057f8:	f4a6                	sd	s1,104(sp)
    800057fa:	ecce                	sd	s3,88(sp)
    800057fc:	e8d2                	sd	s4,80(sp)
    800057fe:	e4d6                	sd	s5,72(sp)
    80005800:	e0da                	sd	s6,64(sp)
    80005802:	fc5e                	sd	s7,56(sp)
    80005804:	f862                	sd	s8,48(sp)
    80005806:	f06a                	sd	s10,32(sp)
    80005808:	ec6e                	sd	s11,24(sp)
    8000580a:	4a01                	li	s4,0
    if(cx != '%'){
    8000580c:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    80005810:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005814:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005818:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    8000581c:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000581e:	06400b93          	li	s7,100
    80005822:	a015                	j	80005846 <printf+0x86>
    acquire(&pr.lock);
    80005824:	0001e517          	auipc	a0,0x1e
    80005828:	07c50513          	addi	a0,a0,124 # 800238a0 <pr>
    8000582c:	5ea000ef          	jal	80005e16 <acquire>
    80005830:	bf65                	j	800057e8 <printf+0x28>
      consputc(cx);
    80005832:	d0fff0ef          	jal	80005540 <consputc>
      continue;
    80005836:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005838:	2485                	addiw	s1,s1,1
    8000583a:	8a26                	mv	s4,s1
    8000583c:	94ca                	add	s1,s1,s2
    8000583e:	0004c503          	lbu	a0,0(s1)
    80005842:	1c050663          	beqz	a0,80005a0e <printf+0x24e>
    if(cx != '%'){
    80005846:	ff3516e3          	bne	a0,s3,80005832 <printf+0x72>
    i++;
    8000584a:	001a079b          	addiw	a5,s4,1
    8000584e:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    80005850:	00f90733          	add	a4,s2,a5
    80005854:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005858:	200a8963          	beqz	s5,80005a6a <printf+0x2aa>
    8000585c:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    80005860:	1e068c63          	beqz	a3,80005a58 <printf+0x298>
    if(c0 == 'd'){
    80005864:	037a8863          	beq	s5,s7,80005894 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005868:	f94a8713          	addi	a4,s5,-108
    8000586c:	00173713          	seqz	a4,a4
    80005870:	f9c68613          	addi	a2,a3,-100
    80005874:	ee05                	bnez	a2,800058ac <printf+0xec>
    80005876:	cb1d                	beqz	a4,800058ac <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    80005878:	f8843783          	ld	a5,-120(s0)
    8000587c:	00878713          	addi	a4,a5,8
    80005880:	f8e43423          	sd	a4,-120(s0)
    80005884:	4605                	li	a2,1
    80005886:	85da                	mv	a1,s6
    80005888:	6388                	ld	a0,0(a5)
    8000588a:	ea1ff0ef          	jal	8000572a <printint>
      i += 1;
    8000588e:	002a049b          	addiw	s1,s4,2
    80005892:	b75d                	j	80005838 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    80005894:	f8843783          	ld	a5,-120(s0)
    80005898:	00878713          	addi	a4,a5,8
    8000589c:	f8e43423          	sd	a4,-120(s0)
    800058a0:	4605                	li	a2,1
    800058a2:	85da                	mv	a1,s6
    800058a4:	4388                	lw	a0,0(a5)
    800058a6:	e85ff0ef          	jal	8000572a <printint>
    800058aa:	b779                	j	80005838 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800058ac:	97ca                	add	a5,a5,s2
    800058ae:	8636                	mv	a2,a3
    800058b0:	0027c683          	lbu	a3,2(a5)
    800058b4:	a2c9                	j	80005a76 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    800058b6:	f8843783          	ld	a5,-120(s0)
    800058ba:	00878713          	addi	a4,a5,8
    800058be:	f8e43423          	sd	a4,-120(s0)
    800058c2:	4605                	li	a2,1
    800058c4:	45a9                	li	a1,10
    800058c6:	6388                	ld	a0,0(a5)
    800058c8:	e63ff0ef          	jal	8000572a <printint>
      i += 2;
    800058cc:	003a049b          	addiw	s1,s4,3
    800058d0:	b7a5                	j	80005838 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    800058d2:	f8843783          	ld	a5,-120(s0)
    800058d6:	00878713          	addi	a4,a5,8
    800058da:	f8e43423          	sd	a4,-120(s0)
    800058de:	4601                	li	a2,0
    800058e0:	85da                	mv	a1,s6
    800058e2:	0007e503          	lwu	a0,0(a5)
    800058e6:	e45ff0ef          	jal	8000572a <printint>
    800058ea:	b7b9                	j	80005838 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    800058ec:	f8843783          	ld	a5,-120(s0)
    800058f0:	00878713          	addi	a4,a5,8
    800058f4:	f8e43423          	sd	a4,-120(s0)
    800058f8:	4601                	li	a2,0
    800058fa:	85da                	mv	a1,s6
    800058fc:	6388                	ld	a0,0(a5)
    800058fe:	e2dff0ef          	jal	8000572a <printint>
      i += 1;
    80005902:	002a049b          	addiw	s1,s4,2
    80005906:	bf0d                	j	80005838 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005908:	f8843783          	ld	a5,-120(s0)
    8000590c:	00878713          	addi	a4,a5,8
    80005910:	f8e43423          	sd	a4,-120(s0)
    80005914:	4601                	li	a2,0
    80005916:	45a9                	li	a1,10
    80005918:	6388                	ld	a0,0(a5)
    8000591a:	e11ff0ef          	jal	8000572a <printint>
      i += 2;
    8000591e:	003a049b          	addiw	s1,s4,3
    80005922:	bf19                	j	80005838 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005924:	f8843783          	ld	a5,-120(s0)
    80005928:	00878713          	addi	a4,a5,8
    8000592c:	f8e43423          	sd	a4,-120(s0)
    80005930:	4601                	li	a2,0
    80005932:	45c1                	li	a1,16
    80005934:	0007e503          	lwu	a0,0(a5)
    80005938:	df3ff0ef          	jal	8000572a <printint>
    8000593c:	bdf5                	j	80005838 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    8000593e:	f8843783          	ld	a5,-120(s0)
    80005942:	00878713          	addi	a4,a5,8
    80005946:	f8e43423          	sd	a4,-120(s0)
    8000594a:	45c1                	li	a1,16
    8000594c:	6388                	ld	a0,0(a5)
    8000594e:	dddff0ef          	jal	8000572a <printint>
      i += 1;
    80005952:	002a049b          	addiw	s1,s4,2
    80005956:	b5cd                	j	80005838 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005958:	f8843783          	ld	a5,-120(s0)
    8000595c:	00878713          	addi	a4,a5,8
    80005960:	f8e43423          	sd	a4,-120(s0)
    80005964:	4601                	li	a2,0
    80005966:	45c1                	li	a1,16
    80005968:	6388                	ld	a0,0(a5)
    8000596a:	dc1ff0ef          	jal	8000572a <printint>
      i += 2;
    8000596e:	003a049b          	addiw	s1,s4,3
    80005972:	b5d9                	j	80005838 <printf+0x78>
    80005974:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    80005976:	f8843783          	ld	a5,-120(s0)
    8000597a:	00878713          	addi	a4,a5,8
    8000597e:	f8e43423          	sd	a4,-120(s0)
    80005982:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80005986:	03000513          	li	a0,48
    8000598a:	bb7ff0ef          	jal	80005540 <consputc>
  consputc('x');
    8000598e:	07800513          	li	a0,120
    80005992:	bafff0ef          	jal	80005540 <consputc>
    80005996:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005998:	00003c97          	auipc	s9,0x3
    8000599c:	2c0c8c93          	addi	s9,s9,704 # 80008c58 <digits>
    800059a0:	03cad793          	srli	a5,s5,0x3c
    800059a4:	97e6                	add	a5,a5,s9
    800059a6:	0007c503          	lbu	a0,0(a5)
    800059aa:	b97ff0ef          	jal	80005540 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800059ae:	0a92                	slli	s5,s5,0x4
    800059b0:	3a7d                	addiw	s4,s4,-1
    800059b2:	fe0a17e3          	bnez	s4,800059a0 <printf+0x1e0>
    800059b6:	7ca2                	ld	s9,40(sp)
    800059b8:	b541                	j	80005838 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    800059ba:	f8843783          	ld	a5,-120(s0)
    800059be:	00878713          	addi	a4,a5,8
    800059c2:	f8e43423          	sd	a4,-120(s0)
    800059c6:	4388                	lw	a0,0(a5)
    800059c8:	b79ff0ef          	jal	80005540 <consputc>
    800059cc:	b5b5                	j	80005838 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    800059ce:	f8843783          	ld	a5,-120(s0)
    800059d2:	00878713          	addi	a4,a5,8
    800059d6:	f8e43423          	sd	a4,-120(s0)
    800059da:	0007ba03          	ld	s4,0(a5)
    800059de:	000a0d63          	beqz	s4,800059f8 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    800059e2:	000a4503          	lbu	a0,0(s4)
    800059e6:	e40509e3          	beqz	a0,80005838 <printf+0x78>
        consputc(*s);
    800059ea:	b57ff0ef          	jal	80005540 <consputc>
      for(; *s; s++)
    800059ee:	0a05                	addi	s4,s4,1
    800059f0:	000a4503          	lbu	a0,0(s4)
    800059f4:	f97d                	bnez	a0,800059ea <printf+0x22a>
    800059f6:	b589                	j	80005838 <printf+0x78>
        s = "(null)";
    800059f8:	00003a17          	auipc	s4,0x3
    800059fc:	cd8a0a13          	addi	s4,s4,-808 # 800086d0 <etext+0x6d0>
      for(; *s; s++)
    80005a00:	02800513          	li	a0,40
    80005a04:	b7dd                	j	800059ea <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005a06:	8556                	mv	a0,s5
    80005a08:	b39ff0ef          	jal	80005540 <consputc>
    80005a0c:	b535                	j	80005838 <printf+0x78>
    80005a0e:	74a6                	ld	s1,104(sp)
    80005a10:	69e6                	ld	s3,88(sp)
    80005a12:	6a46                	ld	s4,80(sp)
    80005a14:	6aa6                	ld	s5,72(sp)
    80005a16:	6b06                	ld	s6,64(sp)
    80005a18:	7be2                	ld	s7,56(sp)
    80005a1a:	7c42                	ld	s8,48(sp)
    80005a1c:	7d02                	ld	s10,32(sp)
    80005a1e:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    80005a20:	00003797          	auipc	a5,0x3
    80005a24:	2807a783          	lw	a5,640(a5) # 80008ca0 <panicking>
    80005a28:	c38d                	beqz	a5,80005a4a <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80005a2a:	4501                	li	a0,0
    80005a2c:	70e6                	ld	ra,120(sp)
    80005a2e:	7446                	ld	s0,112(sp)
    80005a30:	7906                	ld	s2,96(sp)
    80005a32:	6129                	addi	sp,sp,192
    80005a34:	8082                	ret
    80005a36:	74a6                	ld	s1,104(sp)
    80005a38:	69e6                	ld	s3,88(sp)
    80005a3a:	6a46                	ld	s4,80(sp)
    80005a3c:	6aa6                	ld	s5,72(sp)
    80005a3e:	6b06                	ld	s6,64(sp)
    80005a40:	7be2                	ld	s7,56(sp)
    80005a42:	7c42                	ld	s8,48(sp)
    80005a44:	7d02                	ld	s10,32(sp)
    80005a46:	6de2                	ld	s11,24(sp)
    80005a48:	bfe1                	j	80005a20 <printf+0x260>
    release(&pr.lock);
    80005a4a:	0001e517          	auipc	a0,0x1e
    80005a4e:	e5650513          	addi	a0,a0,-426 # 800238a0 <pr>
    80005a52:	4ac000ef          	jal	80005efe <release>
  return 0;
    80005a56:	bfd1                	j	80005a2a <printf+0x26a>
    if(c0 == 'd'){
    80005a58:	e37a8ee3          	beq	s5,s7,80005894 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005a5c:	f94a8713          	addi	a4,s5,-108
    80005a60:	00173713          	seqz	a4,a4
    80005a64:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005a66:	4781                	li	a5,0
    80005a68:	a00d                	j	80005a8a <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    80005a6a:	f94a8713          	addi	a4,s5,-108
    80005a6e:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    80005a72:	8656                	mv	a2,s5
    80005a74:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005a76:	f9460793          	addi	a5,a2,-108
    80005a7a:	0017b793          	seqz	a5,a5
    80005a7e:	8ff9                	and	a5,a5,a4
    80005a80:	f9c68593          	addi	a1,a3,-100
    80005a84:	e199                	bnez	a1,80005a8a <printf+0x2ca>
    80005a86:	e20798e3          	bnez	a5,800058b6 <printf+0xf6>
    } else if(c0 == 'u'){
    80005a8a:	e58a84e3          	beq	s5,s8,800058d2 <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    80005a8e:	f8b60593          	addi	a1,a2,-117
    80005a92:	e199                	bnez	a1,80005a98 <printf+0x2d8>
    80005a94:	e4071ce3          	bnez	a4,800058ec <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005a98:	f8b68593          	addi	a1,a3,-117
    80005a9c:	e199                	bnez	a1,80005aa2 <printf+0x2e2>
    80005a9e:	e60795e3          	bnez	a5,80005908 <printf+0x148>
    } else if(c0 == 'x'){
    80005aa2:	e9aa81e3          	beq	s5,s10,80005924 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    80005aa6:	f8860613          	addi	a2,a2,-120
    80005aaa:	e219                	bnez	a2,80005ab0 <printf+0x2f0>
    80005aac:	e80719e3          	bnez	a4,8000593e <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005ab0:	f8868693          	addi	a3,a3,-120
    80005ab4:	e299                	bnez	a3,80005aba <printf+0x2fa>
    80005ab6:	ea0791e3          	bnez	a5,80005958 <printf+0x198>
    } else if(c0 == 'p'){
    80005aba:	ebba8de3          	beq	s5,s11,80005974 <printf+0x1b4>
    } else if(c0 == 'c'){
    80005abe:	06300793          	li	a5,99
    80005ac2:	eefa8ce3          	beq	s5,a5,800059ba <printf+0x1fa>
    } else if(c0 == 's'){
    80005ac6:	07300793          	li	a5,115
    80005aca:	f0fa82e3          	beq	s5,a5,800059ce <printf+0x20e>
    } else if(c0 == '%'){
    80005ace:	02500793          	li	a5,37
    80005ad2:	f2fa8ae3          	beq	s5,a5,80005a06 <printf+0x246>
    } else if(c0 == 0){
    80005ad6:	f60a80e3          	beqz	s5,80005a36 <printf+0x276>
      consputc('%');
    80005ada:	02500513          	li	a0,37
    80005ade:	a63ff0ef          	jal	80005540 <consputc>
      consputc(c0);
    80005ae2:	8556                	mv	a0,s5
    80005ae4:	a5dff0ef          	jal	80005540 <consputc>
    80005ae8:	bb81                	j	80005838 <printf+0x78>

0000000080005aea <panic>:

void
panic(char *s)
{
    80005aea:	1101                	addi	sp,sp,-32
    80005aec:	ec06                	sd	ra,24(sp)
    80005aee:	e822                	sd	s0,16(sp)
    80005af0:	e426                	sd	s1,8(sp)
    80005af2:	e04a                	sd	s2,0(sp)
    80005af4:	1000                	addi	s0,sp,32
    80005af6:	892a                	mv	s2,a0
  panicking = 1;
    80005af8:	4485                	li	s1,1
    80005afa:	00003797          	auipc	a5,0x3
    80005afe:	1a97a323          	sw	s1,422(a5) # 80008ca0 <panicking>
  printf("panic: ");
    80005b02:	00003517          	auipc	a0,0x3
    80005b06:	bde50513          	addi	a0,a0,-1058 # 800086e0 <etext+0x6e0>
    80005b0a:	cb7ff0ef          	jal	800057c0 <printf>
  printf("%s\n", s);
    80005b0e:	85ca                	mv	a1,s2
    80005b10:	00003517          	auipc	a0,0x3
    80005b14:	bd850513          	addi	a0,a0,-1064 # 800086e8 <etext+0x6e8>
    80005b18:	ca9ff0ef          	jal	800057c0 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005b1c:	00003797          	auipc	a5,0x3
    80005b20:	1897a023          	sw	s1,384(a5) # 80008c9c <panicked>
  for(;;)
    80005b24:	a001                	j	80005b24 <panic+0x3a>

0000000080005b26 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005b26:	1141                	addi	sp,sp,-16
    80005b28:	e406                	sd	ra,8(sp)
    80005b2a:	e022                	sd	s0,0(sp)
    80005b2c:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005b2e:	00003597          	auipc	a1,0x3
    80005b32:	bc258593          	addi	a1,a1,-1086 # 800086f0 <etext+0x6f0>
    80005b36:	0001e517          	auipc	a0,0x1e
    80005b3a:	d6a50513          	addi	a0,a0,-662 # 800238a0 <pr>
    80005b3e:	458000ef          	jal	80005f96 <initlock>
}
    80005b42:	60a2                	ld	ra,8(sp)
    80005b44:	6402                	ld	s0,0(sp)
    80005b46:	0141                	addi	sp,sp,16
    80005b48:	8082                	ret

0000000080005b4a <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005b4a:	1141                	addi	sp,sp,-16
    80005b4c:	e406                	sd	ra,8(sp)
    80005b4e:	e022                	sd	s0,0(sp)
    80005b50:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005b52:	100007b7          	lui	a5,0x10000
    80005b56:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005b5a:	10000737          	lui	a4,0x10000
    80005b5e:	f8000693          	li	a3,-128
    80005b62:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005b66:	468d                	li	a3,3
    80005b68:	10000637          	lui	a2,0x10000
    80005b6c:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005b70:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005b74:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005b78:	8732                	mv	a4,a2
    80005b7a:	461d                	li	a2,7
    80005b7c:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005b80:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005b84:	00003597          	auipc	a1,0x3
    80005b88:	b7458593          	addi	a1,a1,-1164 # 800086f8 <etext+0x6f8>
    80005b8c:	0001e517          	auipc	a0,0x1e
    80005b90:	d3450513          	addi	a0,a0,-716 # 800238c0 <tx_lock>
    80005b94:	402000ef          	jal	80005f96 <initlock>
}
    80005b98:	60a2                	ld	ra,8(sp)
    80005b9a:	6402                	ld	s0,0(sp)
    80005b9c:	0141                	addi	sp,sp,16
    80005b9e:	8082                	ret

0000000080005ba0 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005ba0:	715d                	addi	sp,sp,-80
    80005ba2:	e486                	sd	ra,72(sp)
    80005ba4:	e0a2                	sd	s0,64(sp)
    80005ba6:	fc26                	sd	s1,56(sp)
    80005ba8:	ec56                	sd	s5,24(sp)
    80005baa:	0880                	addi	s0,sp,80
    80005bac:	8aaa                	mv	s5,a0
    80005bae:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005bb0:	0001e517          	auipc	a0,0x1e
    80005bb4:	d1050513          	addi	a0,a0,-752 # 800238c0 <tx_lock>
    80005bb8:	25e000ef          	jal	80005e16 <acquire>

  int i = 0;
  while(i < n){ 
    80005bbc:	06905063          	blez	s1,80005c1c <uartwrite+0x7c>
    80005bc0:	f84a                	sd	s2,48(sp)
    80005bc2:	f44e                	sd	s3,40(sp)
    80005bc4:	f052                	sd	s4,32(sp)
    80005bc6:	e85a                	sd	s6,16(sp)
    80005bc8:	e45e                	sd	s7,8(sp)
    80005bca:	8a56                	mv	s4,s5
    80005bcc:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005bce:	00003497          	auipc	s1,0x3
    80005bd2:	0da48493          	addi	s1,s1,218 # 80008ca8 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005bd6:	0001e997          	auipc	s3,0x1e
    80005bda:	cea98993          	addi	s3,s3,-790 # 800238c0 <tx_lock>
    80005bde:	00003917          	auipc	s2,0x3
    80005be2:	0c690913          	addi	s2,s2,198 # 80008ca4 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005be6:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005bea:	4b05                	li	s6,1
    80005bec:	a005                	j	80005c0c <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005bee:	85ce                	mv	a1,s3
    80005bf0:	854a                	mv	a0,s2
    80005bf2:	889fb0ef          	jal	8000147a <sleep>
    while(tx_busy != 0){
    80005bf6:	409c                	lw	a5,0(s1)
    80005bf8:	fbfd                	bnez	a5,80005bee <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005bfa:	000a4783          	lbu	a5,0(s4)
    80005bfe:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005c02:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005c06:	0a05                	addi	s4,s4,1
    80005c08:	015a0563          	beq	s4,s5,80005c12 <uartwrite+0x72>
    while(tx_busy != 0){
    80005c0c:	409c                	lw	a5,0(s1)
    80005c0e:	f3e5                	bnez	a5,80005bee <uartwrite+0x4e>
    80005c10:	b7ed                	j	80005bfa <uartwrite+0x5a>
    80005c12:	7942                	ld	s2,48(sp)
    80005c14:	79a2                	ld	s3,40(sp)
    80005c16:	7a02                	ld	s4,32(sp)
    80005c18:	6b42                	ld	s6,16(sp)
    80005c1a:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005c1c:	0001e517          	auipc	a0,0x1e
    80005c20:	ca450513          	addi	a0,a0,-860 # 800238c0 <tx_lock>
    80005c24:	2da000ef          	jal	80005efe <release>
}
    80005c28:	60a6                	ld	ra,72(sp)
    80005c2a:	6406                	ld	s0,64(sp)
    80005c2c:	74e2                	ld	s1,56(sp)
    80005c2e:	6ae2                	ld	s5,24(sp)
    80005c30:	6161                	addi	sp,sp,80
    80005c32:	8082                	ret

0000000080005c34 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005c34:	1101                	addi	sp,sp,-32
    80005c36:	ec06                	sd	ra,24(sp)
    80005c38:	e822                	sd	s0,16(sp)
    80005c3a:	e426                	sd	s1,8(sp)
    80005c3c:	1000                	addi	s0,sp,32
    80005c3e:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005c40:	00003797          	auipc	a5,0x3
    80005c44:	0607a783          	lw	a5,96(a5) # 80008ca0 <panicking>
    80005c48:	cf95                	beqz	a5,80005c84 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005c4a:	00003797          	auipc	a5,0x3
    80005c4e:	0527a783          	lw	a5,82(a5) # 80008c9c <panicked>
    80005c52:	ef85                	bnez	a5,80005c8a <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005c54:	10000737          	lui	a4,0x10000
    80005c58:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005c5a:	00074783          	lbu	a5,0(a4)
    80005c5e:	0207f793          	andi	a5,a5,32
    80005c62:	dfe5                	beqz	a5,80005c5a <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005c64:	0ff4f513          	zext.b	a0,s1
    80005c68:	100007b7          	lui	a5,0x10000
    80005c6c:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005c70:	00003797          	auipc	a5,0x3
    80005c74:	0307a783          	lw	a5,48(a5) # 80008ca0 <panicking>
    80005c78:	cb91                	beqz	a5,80005c8c <uartputc_sync+0x58>
    pop_off();
}
    80005c7a:	60e2                	ld	ra,24(sp)
    80005c7c:	6442                	ld	s0,16(sp)
    80005c7e:	64a2                	ld	s1,8(sp)
    80005c80:	6105                	addi	sp,sp,32
    80005c82:	8082                	ret
    push_off();
    80005c84:	14e000ef          	jal	80005dd2 <push_off>
    80005c88:	b7c9                	j	80005c4a <uartputc_sync+0x16>
    for(;;)
    80005c8a:	a001                	j	80005c8a <uartputc_sync+0x56>
    pop_off();
    80005c8c:	222000ef          	jal	80005eae <pop_off>
}
    80005c90:	b7ed                	j	80005c7a <uartputc_sync+0x46>

0000000080005c92 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005c92:	1141                	addi	sp,sp,-16
    80005c94:	e406                	sd	ra,8(sp)
    80005c96:	e022                	sd	s0,0(sp)
    80005c98:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005c9a:	100007b7          	lui	a5,0x10000
    80005c9e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005ca2:	8b85                	andi	a5,a5,1
    80005ca4:	cb89                	beqz	a5,80005cb6 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005ca6:	100007b7          	lui	a5,0x10000
    80005caa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005cae:	60a2                	ld	ra,8(sp)
    80005cb0:	6402                	ld	s0,0(sp)
    80005cb2:	0141                	addi	sp,sp,16
    80005cb4:	8082                	ret
    return -1;
    80005cb6:	557d                	li	a0,-1
    80005cb8:	bfdd                	j	80005cae <uartgetc+0x1c>

0000000080005cba <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005cba:	1101                	addi	sp,sp,-32
    80005cbc:	ec06                	sd	ra,24(sp)
    80005cbe:	e822                	sd	s0,16(sp)
    80005cc0:	e426                	sd	s1,8(sp)
    80005cc2:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005cc4:	100007b7          	lui	a5,0x10000
    80005cc8:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005ccc:	0001e517          	auipc	a0,0x1e
    80005cd0:	bf450513          	addi	a0,a0,-1036 # 800238c0 <tx_lock>
    80005cd4:	142000ef          	jal	80005e16 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005cd8:	100007b7          	lui	a5,0x10000
    80005cdc:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005ce0:	0207f793          	andi	a5,a5,32
    80005ce4:	ef99                	bnez	a5,80005d02 <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005ce6:	0001e517          	auipc	a0,0x1e
    80005cea:	bda50513          	addi	a0,a0,-1062 # 800238c0 <tx_lock>
    80005cee:	210000ef          	jal	80005efe <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005cf2:	54fd                	li	s1,-1
    int c = uartgetc();
    80005cf4:	f9fff0ef          	jal	80005c92 <uartgetc>
    if(c == -1)
    80005cf8:	02950063          	beq	a0,s1,80005d18 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005cfc:	877ff0ef          	jal	80005572 <consoleintr>
  while(1){
    80005d00:	bfd5                	j	80005cf4 <uartintr+0x3a>
    tx_busy = 0;
    80005d02:	00003797          	auipc	a5,0x3
    80005d06:	fa07a323          	sw	zero,-90(a5) # 80008ca8 <tx_busy>
    wakeup(&tx_chan);
    80005d0a:	00003517          	auipc	a0,0x3
    80005d0e:	f9a50513          	addi	a0,a0,-102 # 80008ca4 <tx_chan>
    80005d12:	fb4fb0ef          	jal	800014c6 <wakeup>
    80005d16:	bfc1                	j	80005ce6 <uartintr+0x2c>
  }
}
    80005d18:	60e2                	ld	ra,24(sp)
    80005d1a:	6442                	ld	s0,16(sp)
    80005d1c:	64a2                	ld	s1,8(sp)
    80005d1e:	6105                	addi	sp,sp,32
    80005d20:	8082                	ret

0000000080005d22 <delay>:
  }
}

static uint
delay()
{
    80005d22:	1141                	addi	sp,sp,-16
    80005d24:	e406                	sd	ra,8(sp)
    80005d26:	e022                	sd	s0,0(sp)
    80005d28:	0800                	addi	s0,sp,16
    80005d2a:	6789                	lui	a5,0x2
    80005d2c:	71078793          	addi	a5,a5,1808 # 2710 <_entry-0x7fffd8f0>
  static uint v;
  for (int i = 0; i < 10000; i++) {
    __atomic_fetch_add(&v, 1, __ATOMIC_RELAXED);
    80005d30:	00003717          	auipc	a4,0x3
    80005d34:	f8070713          	addi	a4,a4,-128 # 80008cb0 <v.1>
    80005d38:	4685                	li	a3,1
    80005d3a:	00d7202f          	amoadd.w	zero,a3,(a4)
  for (int i = 0; i < 10000; i++) {
    80005d3e:	37fd                	addiw	a5,a5,-1
    80005d40:	ffed                	bnez	a5,80005d3a <delay+0x18>
  }
  return __atomic_load_n(&v, __ATOMIC_RELAXED);
    80005d42:	00003797          	auipc	a5,0x3
    80005d46:	f6e78793          	addi	a5,a5,-146 # 80008cb0 <v.1>
    80005d4a:	4388                	lw	a0,0(a5)
}
    80005d4c:	2501                	sext.w	a0,a0
    80005d4e:	60a2                	ld	ra,8(sp)
    80005d50:	6402                	ld	s0,0(sp)
    80005d52:	0141                	addi	sp,sp,16
    80005d54:	8082                	ret

0000000080005d56 <rwspinlock_test_step>:
{
    80005d56:	1101                	addi	sp,sp,-32
    80005d58:	ec06                	sd	ra,24(sp)
    80005d5a:	e822                	sd	s0,16(sp)
    80005d5c:	e426                	sd	s1,8(sp)
    80005d5e:	e04a                	sd	s2,0(sp)
    80005d60:	1000                	addi	s0,sp,32
    80005d62:	84aa                	mv	s1,a0
    80005d64:	892e                	mv	s2,a1
  __atomic_fetch_add(&barrier, 1, __ATOMIC_ACQ_REL);
    80005d66:	00003797          	auipc	a5,0x3
    80005d6a:	f4678793          	addi	a5,a5,-186 # 80008cac <barrier.0>
    80005d6e:	4705                	li	a4,1
    80005d70:	06e7a02f          	amoadd.w.aqrl	zero,a4,(a5)
  while (__atomic_load_n(&barrier, __ATOMIC_RELAXED) < ncpu * step) {
    80005d74:	0025169b          	slliw	a3,a0,0x2
    80005d78:	873e                	mv	a4,a5
    80005d7a:	431c                	lw	a5,0(a4)
    80005d7c:	2781                	sext.w	a5,a5
    80005d7e:	fed7eee3          	bltu	a5,a3,80005d7a <rwspinlock_test_step+0x24>
  if (cpuid() == 0) {
    80005d82:	89afb0ef          	jal	80000e1c <cpuid>
    80005d86:	c519                	beqz	a0,80005d94 <rwspinlock_test_step+0x3e>
}
    80005d88:	60e2                	ld	ra,24(sp)
    80005d8a:	6442                	ld	s0,16(sp)
    80005d8c:	64a2                	ld	s1,8(sp)
    80005d8e:	6902                	ld	s2,0(sp)
    80005d90:	6105                	addi	sp,sp,32
    80005d92:	8082                	ret
    printf("rwspinlock_test: step %d: %s\n", step, msg);
    80005d94:	864a                	mv	a2,s2
    80005d96:	85a6                	mv	a1,s1
    80005d98:	00003517          	auipc	a0,0x3
    80005d9c:	96850513          	addi	a0,a0,-1688 # 80008700 <etext+0x700>
    80005da0:	a21ff0ef          	jal	800057c0 <printf>
}
    80005da4:	b7d5                	j	80005d88 <rwspinlock_test_step+0x32>

0000000080005da6 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005da6:	411c                	lw	a5,0(a0)
    80005da8:	e399                	bnez	a5,80005dae <holding+0x8>
    80005daa:	4501                	li	a0,0
  return r;
}
    80005dac:	8082                	ret
{
    80005dae:	1101                	addi	sp,sp,-32
    80005db0:	ec06                	sd	ra,24(sp)
    80005db2:	e822                	sd	s0,16(sp)
    80005db4:	e426                	sd	s1,8(sp)
    80005db6:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005db8:	691c                	ld	a5,16(a0)
    80005dba:	84be                	mv	s1,a5
    80005dbc:	874fb0ef          	jal	80000e30 <mycpu>
    80005dc0:	40a48533          	sub	a0,s1,a0
    80005dc4:	00153513          	seqz	a0,a0
}
    80005dc8:	60e2                	ld	ra,24(sp)
    80005dca:	6442                	ld	s0,16(sp)
    80005dcc:	64a2                	ld	s1,8(sp)
    80005dce:	6105                	addi	sp,sp,32
    80005dd0:	8082                	ret

0000000080005dd2 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005dd2:	1101                	addi	sp,sp,-32
    80005dd4:	ec06                	sd	ra,24(sp)
    80005dd6:	e822                	sd	s0,16(sp)
    80005dd8:	e426                	sd	s1,8(sp)
    80005dda:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005ddc:	100027f3          	csrr	a5,sstatus
    80005de0:	84be                	mv	s1,a5
    80005de2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005de6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005de8:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005dec:	844fb0ef          	jal	80000e30 <mycpu>
    80005df0:	5d3c                	lw	a5,120(a0)
    80005df2:	cb99                	beqz	a5,80005e08 <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005df4:	83cfb0ef          	jal	80000e30 <mycpu>
    80005df8:	5d3c                	lw	a5,120(a0)
    80005dfa:	2785                	addiw	a5,a5,1
    80005dfc:	dd3c                	sw	a5,120(a0)
}
    80005dfe:	60e2                	ld	ra,24(sp)
    80005e00:	6442                	ld	s0,16(sp)
    80005e02:	64a2                	ld	s1,8(sp)
    80005e04:	6105                	addi	sp,sp,32
    80005e06:	8082                	ret
    mycpu()->intena = old;
    80005e08:	828fb0ef          	jal	80000e30 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005e0c:	0014d793          	srli	a5,s1,0x1
    80005e10:	8b85                	andi	a5,a5,1
    80005e12:	dd7c                	sw	a5,124(a0)
    80005e14:	b7c5                	j	80005df4 <push_off+0x22>

0000000080005e16 <acquire>:
{
    80005e16:	1101                	addi	sp,sp,-32
    80005e18:	ec06                	sd	ra,24(sp)
    80005e1a:	e822                	sd	s0,16(sp)
    80005e1c:	e426                	sd	s1,8(sp)
    80005e1e:	1000                	addi	s0,sp,32
    80005e20:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005e22:	fb1ff0ef          	jal	80005dd2 <push_off>
  if(holding(lk))
    80005e26:	8526                	mv	a0,s1
    80005e28:	f7fff0ef          	jal	80005da6 <holding>
    80005e2c:	e901                	bnez	a0,80005e3c <acquire+0x26>
    __sync_fetch_and_add(&(lk->n), 1);
    80005e2e:	4785                	li	a5,1
    80005e30:	01c48713          	addi	a4,s1,28
    80005e34:	06f7202f          	amoadd.w.aqrl	zero,a5,(a4)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80005e38:	873e                	mv	a4,a5
    80005e3a:	a819                	j	80005e50 <acquire+0x3a>
    panic("acquire");
    80005e3c:	00003517          	auipc	a0,0x3
    80005e40:	93c50513          	addi	a0,a0,-1732 # 80008778 <etext+0x778>
    80005e44:	ca7ff0ef          	jal	80005aea <panic>
    __sync_fetch_and_add(&(lk->nts), 1);
    80005e48:	01848793          	addi	a5,s1,24
    80005e4c:	06e7a02f          	amoadd.w.aqrl	zero,a4,(a5)
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80005e50:	87ba                	mv	a5,a4
    80005e52:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005e56:	2781                	sext.w	a5,a5
    80005e58:	fbe5                	bnez	a5,80005e48 <acquire+0x32>
  __sync_synchronize();
    80005e5a:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005e5e:	fd3fa0ef          	jal	80000e30 <mycpu>
    80005e62:	e888                	sd	a0,16(s1)
}
    80005e64:	60e2                	ld	ra,24(sp)
    80005e66:	6442                	ld	s0,16(sp)
    80005e68:	64a2                	ld	s1,8(sp)
    80005e6a:	6105                	addi	sp,sp,32
    80005e6c:	8082                	ret

0000000080005e6e <read_acquire>:
{
    80005e6e:	1101                	addi	sp,sp,-32
    80005e70:	ec06                	sd	ra,24(sp)
    80005e72:	e822                	sd	s0,16(sp)
    80005e74:	e426                	sd	s1,8(sp)
    80005e76:	1000                	addi	s0,sp,32
    80005e78:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005e7a:	f59ff0ef          	jal	80005dd2 <push_off>
  acquire(&rwlk->l);
    80005e7e:	8526                	mv	a0,s1
    80005e80:	f97ff0ef          	jal	80005e16 <acquire>
}
    80005e84:	60e2                	ld	ra,24(sp)
    80005e86:	6442                	ld	s0,16(sp)
    80005e88:	64a2                	ld	s1,8(sp)
    80005e8a:	6105                	addi	sp,sp,32
    80005e8c:	8082                	ret

0000000080005e8e <write_acquire>:
{
    80005e8e:	1101                	addi	sp,sp,-32
    80005e90:	ec06                	sd	ra,24(sp)
    80005e92:	e822                	sd	s0,16(sp)
    80005e94:	e426                	sd	s1,8(sp)
    80005e96:	1000                	addi	s0,sp,32
    80005e98:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005e9a:	f39ff0ef          	jal	80005dd2 <push_off>
  acquire(&rwlk->l);
    80005e9e:	8526                	mv	a0,s1
    80005ea0:	f77ff0ef          	jal	80005e16 <acquire>
}
    80005ea4:	60e2                	ld	ra,24(sp)
    80005ea6:	6442                	ld	s0,16(sp)
    80005ea8:	64a2                	ld	s1,8(sp)
    80005eaa:	6105                	addi	sp,sp,32
    80005eac:	8082                	ret

0000000080005eae <pop_off>:

void
pop_off(void)
{
    80005eae:	1141                	addi	sp,sp,-16
    80005eb0:	e406                	sd	ra,8(sp)
    80005eb2:	e022                	sd	s0,0(sp)
    80005eb4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005eb6:	f7bfa0ef          	jal	80000e30 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005eba:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005ebe:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005ec0:	e39d                	bnez	a5,80005ee6 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005ec2:	5d3c                	lw	a5,120(a0)
    80005ec4:	02f05763          	blez	a5,80005ef2 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005ec8:	37fd                	addiw	a5,a5,-1
    80005eca:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005ecc:	eb89                	bnez	a5,80005ede <pop_off+0x30>
    80005ece:	5d7c                	lw	a5,124(a0)
    80005ed0:	c799                	beqz	a5,80005ede <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005ed2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005ed6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005eda:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005ede:	60a2                	ld	ra,8(sp)
    80005ee0:	6402                	ld	s0,0(sp)
    80005ee2:	0141                	addi	sp,sp,16
    80005ee4:	8082                	ret
    panic("pop_off - interruptible");
    80005ee6:	00003517          	auipc	a0,0x3
    80005eea:	83a50513          	addi	a0,a0,-1990 # 80008720 <etext+0x720>
    80005eee:	bfdff0ef          	jal	80005aea <panic>
    panic("pop_off");
    80005ef2:	00003517          	auipc	a0,0x3
    80005ef6:	84650513          	addi	a0,a0,-1978 # 80008738 <etext+0x738>
    80005efa:	bf1ff0ef          	jal	80005aea <panic>

0000000080005efe <release>:
{
    80005efe:	1101                	addi	sp,sp,-32
    80005f00:	ec06                	sd	ra,24(sp)
    80005f02:	e822                	sd	s0,16(sp)
    80005f04:	e426                	sd	s1,8(sp)
    80005f06:	1000                	addi	s0,sp,32
    80005f08:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005f0a:	e9dff0ef          	jal	80005da6 <holding>
    80005f0e:	c105                	beqz	a0,80005f2e <release+0x30>
  lk->cpu = 0;
    80005f10:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005f14:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005f18:	0310000f          	fence	rw,w
    80005f1c:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005f20:	f8fff0ef          	jal	80005eae <pop_off>
}
    80005f24:	60e2                	ld	ra,24(sp)
    80005f26:	6442                	ld	s0,16(sp)
    80005f28:	64a2                	ld	s1,8(sp)
    80005f2a:	6105                	addi	sp,sp,32
    80005f2c:	8082                	ret
    panic("release");
    80005f2e:	00003517          	auipc	a0,0x3
    80005f32:	86250513          	addi	a0,a0,-1950 # 80008790 <etext+0x790>
    80005f36:	bb5ff0ef          	jal	80005aea <panic>

0000000080005f3a <freelock>:
{
    80005f3a:	1101                	addi	sp,sp,-32
    80005f3c:	ec06                	sd	ra,24(sp)
    80005f3e:	e822                	sd	s0,16(sp)
    80005f40:	e426                	sd	s1,8(sp)
    80005f42:	1000                	addi	s0,sp,32
    80005f44:	84aa                	mv	s1,a0
  acquire(&lock_locks);
    80005f46:	0001e517          	auipc	a0,0x1e
    80005f4a:	99a50513          	addi	a0,a0,-1638 # 800238e0 <lock_locks>
    80005f4e:	ec9ff0ef          	jal	80005e16 <acquire>
  for (i = 0; i < NLOCK; i++) {
    80005f52:	0001e717          	auipc	a4,0x1e
    80005f56:	9ce70713          	addi	a4,a4,-1586 # 80023920 <locks>
    80005f5a:	4781                	li	a5,0
    80005f5c:	1f400613          	li	a2,500
    if(locks[i] == lk) {
    80005f60:	6314                	ld	a3,0(a4)
    80005f62:	00968763          	beq	a3,s1,80005f70 <freelock+0x36>
  for (i = 0; i < NLOCK; i++) {
    80005f66:	2785                	addiw	a5,a5,1
    80005f68:	0721                	addi	a4,a4,8
    80005f6a:	fec79be3          	bne	a5,a2,80005f60 <freelock+0x26>
    80005f6e:	a809                	j	80005f80 <freelock+0x46>
      locks[i] = 0;
    80005f70:	078e                	slli	a5,a5,0x3
    80005f72:	0001e717          	auipc	a4,0x1e
    80005f76:	9ae70713          	addi	a4,a4,-1618 # 80023920 <locks>
    80005f7a:	97ba                	add	a5,a5,a4
    80005f7c:	0007b023          	sd	zero,0(a5)
  release(&lock_locks);
    80005f80:	0001e517          	auipc	a0,0x1e
    80005f84:	96050513          	addi	a0,a0,-1696 # 800238e0 <lock_locks>
    80005f88:	f77ff0ef          	jal	80005efe <release>
}
    80005f8c:	60e2                	ld	ra,24(sp)
    80005f8e:	6442                	ld	s0,16(sp)
    80005f90:	64a2                	ld	s1,8(sp)
    80005f92:	6105                	addi	sp,sp,32
    80005f94:	8082                	ret

0000000080005f96 <initlock>:
{
    80005f96:	1101                	addi	sp,sp,-32
    80005f98:	ec06                	sd	ra,24(sp)
    80005f9a:	e822                	sd	s0,16(sp)
    80005f9c:	e426                	sd	s1,8(sp)
    80005f9e:	1000                	addi	s0,sp,32
    80005fa0:	84aa                	mv	s1,a0
  lk->name = name;
    80005fa2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005fa4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005fa8:	00053823          	sd	zero,16(a0)
  lk->nts = 0;
    80005fac:	00052c23          	sw	zero,24(a0)
  lk->n = 0;
    80005fb0:	00052e23          	sw	zero,28(a0)
  acquire(&lock_locks);
    80005fb4:	0001e517          	auipc	a0,0x1e
    80005fb8:	92c50513          	addi	a0,a0,-1748 # 800238e0 <lock_locks>
    80005fbc:	e5bff0ef          	jal	80005e16 <acquire>
  for (i = 0; i < NLOCK; i++) {
    80005fc0:	0001e717          	auipc	a4,0x1e
    80005fc4:	96070713          	addi	a4,a4,-1696 # 80023920 <locks>
    80005fc8:	4781                	li	a5,0
    80005fca:	1f400613          	li	a2,500
    if(locks[i] == 0) {
    80005fce:	6314                	ld	a3,0(a4)
    80005fd0:	ca99                	beqz	a3,80005fe6 <initlock+0x50>
  for (i = 0; i < NLOCK; i++) {
    80005fd2:	2785                	addiw	a5,a5,1
    80005fd4:	0721                	addi	a4,a4,8
    80005fd6:	fec79ce3          	bne	a5,a2,80005fce <initlock+0x38>
  panic("findslot");
    80005fda:	00002517          	auipc	a0,0x2
    80005fde:	76650513          	addi	a0,a0,1894 # 80008740 <etext+0x740>
    80005fe2:	b09ff0ef          	jal	80005aea <panic>
      locks[i] = lk;
    80005fe6:	078e                	slli	a5,a5,0x3
    80005fe8:	0001e717          	auipc	a4,0x1e
    80005fec:	93870713          	addi	a4,a4,-1736 # 80023920 <locks>
    80005ff0:	97ba                	add	a5,a5,a4
    80005ff2:	e384                	sd	s1,0(a5)
      release(&lock_locks);
    80005ff4:	0001e517          	auipc	a0,0x1e
    80005ff8:	8ec50513          	addi	a0,a0,-1812 # 800238e0 <lock_locks>
    80005ffc:	f03ff0ef          	jal	80005efe <release>
}
    80006000:	60e2                	ld	ra,24(sp)
    80006002:	6442                	ld	s0,16(sp)
    80006004:	64a2                	ld	s1,8(sp)
    80006006:	6105                	addi	sp,sp,32
    80006008:	8082                	ret

000000008000600a <initrwlock>:
{
    8000600a:	1141                	addi	sp,sp,-16
    8000600c:	e406                	sd	ra,8(sp)
    8000600e:	e022                	sd	s0,0(sp)
    80006010:	0800                	addi	s0,sp,16
  initlock(&rwlk->l, "rwlk");
    80006012:	00002597          	auipc	a1,0x2
    80006016:	73e58593          	addi	a1,a1,1854 # 80008750 <etext+0x750>
    8000601a:	f7dff0ef          	jal	80005f96 <initlock>
}
    8000601e:	60a2                	ld	ra,8(sp)
    80006020:	6402                	ld	s0,0(sp)
    80006022:	0141                	addi	sp,sp,16
    80006024:	8082                	ret

0000000080006026 <read_release>:
{
    80006026:	1141                	addi	sp,sp,-16
    80006028:	e406                	sd	ra,8(sp)
    8000602a:	e022                	sd	s0,0(sp)
    8000602c:	0800                	addi	s0,sp,16
  release(&rwlk->l);
    8000602e:	ed1ff0ef          	jal	80005efe <release>
  pop_off();
    80006032:	e7dff0ef          	jal	80005eae <pop_off>
}
    80006036:	60a2                	ld	ra,8(sp)
    80006038:	6402                	ld	s0,0(sp)
    8000603a:	0141                	addi	sp,sp,16
    8000603c:	8082                	ret

000000008000603e <write_release>:
{
    8000603e:	1141                	addi	sp,sp,-16
    80006040:	e406                	sd	ra,8(sp)
    80006042:	e022                	sd	s0,0(sp)
    80006044:	0800                	addi	s0,sp,16
  release(&rwlk->l);
    80006046:	eb9ff0ef          	jal	80005efe <release>
  pop_off();
    8000604a:	e65ff0ef          	jal	80005eae <pop_off>
}
    8000604e:	60a2                	ld	ra,8(sp)
    80006050:	6402                	ld	s0,0(sp)
    80006052:	0141                	addi	sp,sp,16
    80006054:	8082                	ret

0000000080006056 <sys_rwlktest>:
{
    80006056:	7119                	addi	sp,sp,-128
    80006058:	fc86                	sd	ra,120(sp)
    8000605a:	f8a2                	sd	s0,112(sp)
    8000605c:	f4a6                	sd	s1,104(sp)
    8000605e:	f0ca                	sd	s2,96(sp)
    80006060:	ecce                	sd	s3,88(sp)
    80006062:	e8d2                	sd	s4,80(sp)
    80006064:	e4d6                	sd	s5,72(sp)
    80006066:	e0da                	sd	s6,64(sp)
    80006068:	fc5e                	sd	s7,56(sp)
    8000606a:	f862                	sd	s8,48(sp)
    8000606c:	f466                	sd	s9,40(sp)
    8000606e:	f06a                	sd	s10,32(sp)
    80006070:	0100                	addi	s0,sp,128
  push_off();
    80006072:	d61ff0ef          	jal	80005dd2 <push_off>
  int id = cpuid();
    80006076:	da7fa0ef          	jal	80000e1c <cpuid>
    8000607a:	8baa                	mv	s7,a0
  rwspinlock_test_step(++step, "initrwlock");
    8000607c:	00002597          	auipc	a1,0x2
    80006080:	6dc58593          	addi	a1,a1,1756 # 80008758 <etext+0x758>
    80006084:	4505                	li	a0,1
    80006086:	cd1ff0ef          	jal	80005d56 <rwspinlock_test_step>
  if (id == 0) {
    8000608a:	0c0b8163          	beqz	s7,8000614c <sys_rwlktest+0xf6>
  rwspinlock_test_step(++step, "concurrent read_acquire");
    8000608e:	00002597          	auipc	a1,0x2
    80006092:	6da58593          	addi	a1,a1,1754 # 80008768 <etext+0x768>
    80006096:	4509                	li	a0,2
    80006098:	cbfff0ef          	jal	80005d56 <rwspinlock_test_step>
    8000609c:	000f44b7          	lui	s1,0xf4
    800060a0:	24048493          	addi	s1,s1,576 # f4240 <_entry-0x7ff0bdc0>
    read_acquire(&l);
    800060a4:	0001e917          	auipc	s2,0x1e
    800060a8:	85c90913          	addi	s2,s2,-1956 # 80023900 <l.5>
    800060ac:	854a                	mv	a0,s2
    800060ae:	dc1ff0ef          	jal	80005e6e <read_acquire>
  for (int i = 0; i < 1000000; i++)
    800060b2:	34fd                	addiw	s1,s1,-1
    800060b4:	fce5                	bnez	s1,800060ac <sys_rwlktest+0x56>
  rwspinlock_test_step(++step, "concurrent read_release");
    800060b6:	00002597          	auipc	a1,0x2
    800060ba:	6ca58593          	addi	a1,a1,1738 # 80008780 <etext+0x780>
    800060be:	450d                	li	a0,3
    800060c0:	c97ff0ef          	jal	80005d56 <rwspinlock_test_step>
    800060c4:	000f4937          	lui	s2,0xf4
    800060c8:	24090913          	addi	s2,s2,576 # f4240 <_entry-0x7ff0bdc0>
    read_release(&l);
    800060cc:	0001e997          	auipc	s3,0x1e
    800060d0:	83498993          	addi	s3,s3,-1996 # 80023900 <l.5>
    800060d4:	854e                	mv	a0,s3
    800060d6:	f51ff0ef          	jal	80006026 <read_release>
  for (int i = 0; i < 1000000; i++)
    800060da:	fff9049b          	addiw	s1,s2,-1
    800060de:	8926                	mv	s2,s1
    800060e0:	f8f5                	bnez	s1,800060d4 <sys_rwlktest+0x7e>
  rwspinlock_test_step(++step, "prepare read_acquire for writer priority test");
    800060e2:	00002597          	auipc	a1,0x2
    800060e6:	6b658593          	addi	a1,a1,1718 # 80008798 <etext+0x798>
    800060ea:	4511                	li	a0,4
    800060ec:	c6bff0ef          	jal	80005d56 <rwspinlock_test_step>
  if (id == 1) {
    800060f0:	4785                	li	a5,1
    800060f2:	06fb8463          	beq	s7,a5,8000615a <sys_rwlktest+0x104>
  rwspinlock_test_step(++step, "writer priority test");
    800060f6:	00002597          	auipc	a1,0x2
    800060fa:	6d258593          	addi	a1,a1,1746 # 800087c8 <etext+0x7c8>
    800060fe:	4515                	li	a0,5
    80006100:	c57ff0ef          	jal	80005d56 <rwspinlock_test_step>
  if (id == 0) {
    80006104:	0c0b8563          	beqz	s7,800061ce <sys_rwlktest+0x178>
  if (id == 2) {
    80006108:	4789                	li	a5,2
    8000610a:	0efb9463          	bne	s7,a5,800061f2 <sys_rwlktest+0x19c>
    delay();
    8000610e:	c15ff0ef          	jal	80005d22 <delay>
    read_acquire(&l);
    80006112:	0001d517          	auipc	a0,0x1d
    80006116:	7ee50513          	addi	a0,a0,2030 # 80023900 <l.5>
    8000611a:	d55ff0ef          	jal	80005e6e <read_acquire>
    uint f = __atomic_load_n(&flag, __ATOMIC_RELAXED);
    8000611e:	00003797          	auipc	a5,0x3
    80006122:	b9e78793          	addi	a5,a5,-1122 # 80008cbc <flag.4>
    80006126:	439c                	lw	a5,0(a5)
    80006128:	2781                	sext.w	a5,a5
  int r = 0;
    8000612a:	4c01                	li	s8,0
    if (f == 0) {
    8000612c:	0e078c63          	beqz	a5,80006224 <sys_rwlktest+0x1ce>
    read_release(&l);
    80006130:	0001d517          	auipc	a0,0x1d
    80006134:	7d050513          	addi	a0,a0,2000 # 80023900 <l.5>
    80006138:	eefff0ef          	jal	80006026 <read_release>
  rwspinlock_test_step(++step, "checking for concurrent readers/writers");
    8000613c:	00002597          	auipc	a1,0x2
    80006140:	6e458593          	addi	a1,a1,1764 # 80008820 <etext+0x820>
    80006144:	4519                	li	a0,6
    80006146:	c11ff0ef          	jal	80005d56 <rwspinlock_test_step>
  if (id == 0) {
    8000614a:	a0f5                	j	80006236 <sys_rwlktest+0x1e0>
    initrwlock(&l);
    8000614c:	0001d517          	auipc	a0,0x1d
    80006150:	7b450513          	addi	a0,a0,1972 # 80023900 <l.5>
    80006154:	eb7ff0ef          	jal	8000600a <initrwlock>
    80006158:	bf1d                	j	8000608e <sys_rwlktest+0x38>
    8000615a:	49f9                	li	s3,30
      read_acquire(&l);
    8000615c:	0001da17          	auipc	s4,0x1d
    80006160:	7a4a0a13          	addi	s4,s4,1956 # 80023900 <l.5>
    80006164:	8552                	mv	a0,s4
    80006166:	d09ff0ef          	jal	80005e6e <read_acquire>
    for (int i = 0; i < 30; i++) {
    8000616a:	39fd                	addiw	s3,s3,-1
    8000616c:	fe099ce3          	bnez	s3,80006164 <sys_rwlktest+0x10e>
  rwspinlock_test_step(++step, "writer priority test");
    80006170:	00002597          	auipc	a1,0x2
    80006174:	65858593          	addi	a1,a1,1624 # 800087c8 <etext+0x7c8>
    80006178:	4515                	li	a0,5
    8000617a:	bddff0ef          	jal	80005d56 <rwspinlock_test_step>
    delay();
    8000617e:	ba5ff0ef          	jal	80005d22 <delay>
    80006182:	49a9                	li	s3,10
      read_release(&l);
    80006184:	0001da17          	auipc	s4,0x1d
    80006188:	77ca0a13          	addi	s4,s4,1916 # 80023900 <l.5>
    8000618c:	8552                	mv	a0,s4
    8000618e:	e99ff0ef          	jal	80006026 <read_release>
    for (int i = 0; i < 10; i++) {
    80006192:	39fd                	addiw	s3,s3,-1
    80006194:	fe099ce3          	bnez	s3,8000618c <sys_rwlktest+0x136>
    delay();
    80006198:	b8bff0ef          	jal	80005d22 <delay>
    8000619c:	49a9                	li	s3,10
      read_release(&l);
    8000619e:	0001da17          	auipc	s4,0x1d
    800061a2:	762a0a13          	addi	s4,s4,1890 # 80023900 <l.5>
    800061a6:	8552                	mv	a0,s4
    800061a8:	e7fff0ef          	jal	80006026 <read_release>
    for (int i = 0; i < 10; i++) {
    800061ac:	39fd                	addiw	s3,s3,-1
    800061ae:	fe099ce3          	bnez	s3,800061a6 <sys_rwlktest+0x150>
    delay();
    800061b2:	b71ff0ef          	jal	80005d22 <delay>
    800061b6:	49a9                	li	s3,10
      read_release(&l);
    800061b8:	0001da17          	auipc	s4,0x1d
    800061bc:	748a0a13          	addi	s4,s4,1864 # 80023900 <l.5>
    800061c0:	8552                	mv	a0,s4
    800061c2:	e65ff0ef          	jal	80006026 <read_release>
    for (int i = 0; i < 10; i++) {
    800061c6:	39fd                	addiw	s3,s3,-1
    800061c8:	fe099ce3          	bnez	s3,800061c0 <sys_rwlktest+0x16a>
    800061cc:	a01d                	j	800061f2 <sys_rwlktest+0x19c>
    write_acquire(&l);
    800061ce:	0001d517          	auipc	a0,0x1d
    800061d2:	73250513          	addi	a0,a0,1842 # 80023900 <l.5>
    800061d6:	cb9ff0ef          	jal	80005e8e <write_acquire>
    __atomic_store_n(&flag, 1, __ATOMIC_RELAXED);
    800061da:	00003797          	auipc	a5,0x3
    800061de:	ae278793          	addi	a5,a5,-1310 # 80008cbc <flag.4>
    800061e2:	4705                	li	a4,1
    800061e4:	c398                	sw	a4,0(a5)
    write_release(&l);
    800061e6:	0001d517          	auipc	a0,0x1d
    800061ea:	71a50513          	addi	a0,a0,1818 # 80023900 <l.5>
    800061ee:	e51ff0ef          	jal	8000603e <write_release>
  rwspinlock_test_step(++step, "checking for concurrent readers/writers");
    800061f2:	00002597          	auipc	a1,0x2
    800061f6:	62e58593          	addi	a1,a1,1582 # 80008820 <etext+0x820>
    800061fa:	4519                	li	a0,6
    800061fc:	b5bff0ef          	jal	80005d56 <rwspinlock_test_step>
    uint maxwv = 0;
    80006200:	8a26                	mv	s4,s1
    80006202:	000f49b7          	lui	s3,0xf4
    80006206:	24098993          	addi	s3,s3,576 # f4240 <_entry-0x7ff0bdc0>
  if (id == 0) {
    8000620a:	020b9563          	bnez	s7,80006234 <sys_rwlktest+0x1de>
      write_acquire(&l);
    8000620e:	0001da97          	auipc	s5,0x1d
    80006212:	6f2a8a93          	addi	s5,s5,1778 # 80023900 <l.5>
      uint x = __atomic_add_fetch(&v, 1, __ATOMIC_ACQ_REL);
    80006216:	00003497          	auipc	s1,0x3
    8000621a:	aa248493          	addi	s1,s1,-1374 # 80008cb8 <v.3>
    8000621e:	4c05                	li	s8,1
      uint y = __atomic_fetch_sub(&v, 1, __ATOMIC_ACQ_REL);
    80006220:	5b7d                	li	s6,-1
    80006222:	a089                	j	80006264 <sys_rwlktest+0x20e>
      printf("rwspinlock_test: reader sneaked ahead of waiting writer\n");
    80006224:	00002517          	auipc	a0,0x2
    80006228:	5bc50513          	addi	a0,a0,1468 # 800087e0 <etext+0x7e0>
    8000622c:	d94ff0ef          	jal	800057c0 <printf>
      r = -1;
    80006230:	5c7d                	li	s8,-1
    80006232:	bdfd                	j	80006130 <sys_rwlktest+0xda>
    80006234:	4c01                	li	s8,0
    uint maxrv = 0;
    80006236:	000f4a37          	lui	s4,0xf4
    8000623a:	240a0a13          	addi	s4,s4,576 # f4240 <_entry-0x7ff0bdc0>
      read_acquire(&l);
    8000623e:	0001da97          	auipc	s5,0x1d
    80006242:	6c2a8a93          	addi	s5,s5,1730 # 80023900 <l.5>
      uint x = __atomic_add_fetch(&v, 1, __ATOMIC_ACQ_REL);
    80006246:	00003997          	auipc	s3,0x3
    8000624a:	a7298993          	addi	s3,s3,-1422 # 80008cb8 <v.3>
    8000624e:	4c85                	li	s9,1
      uint y = __atomic_fetch_sub(&v, 1, __ATOMIC_ACQ_REL);
    80006250:	5b7d                	li	s6,-1
    80006252:	a09d                	j	800062b8 <sys_rwlktest+0x262>
      if (y > maxwv) {
    80006254:	00070a1b          	sext.w	s4,a4
      write_release(&l);
    80006258:	8556                	mv	a0,s5
    8000625a:	de5ff0ef          	jal	8000603e <write_release>
    for (int i = 0; i < 1000000; i++) {
    8000625e:	39fd                	addiw	s3,s3,-1
    80006260:	02098663          	beqz	s3,8000628c <sys_rwlktest+0x236>
      write_acquire(&l);
    80006264:	8556                	mv	a0,s5
    80006266:	c29ff0ef          	jal	80005e8e <write_acquire>
      uint x = __atomic_add_fetch(&v, 1, __ATOMIC_ACQ_REL);
    8000626a:	0784a72f          	amoadd.w.aqrl	a4,s8,(s1)
    8000626e:	2705                	addiw	a4,a4,1
      uint y = __atomic_fetch_sub(&v, 1, __ATOMIC_ACQ_REL);
    80006270:	0764a6af          	amoadd.w.aqrl	a3,s6,(s1)
      if (y > maxwv) {
    80006274:	87ba                	mv	a5,a4
    80006276:	0006861b          	sext.w	a2,a3
    8000627a:	00c77363          	bgeu	a4,a2,80006280 <sys_rwlktest+0x22a>
    8000627e:	87b6                	mv	a5,a3
    80006280:	873e                	mv	a4,a5
    80006282:	2781                	sext.w	a5,a5
    80006284:	fd47f8e3          	bgeu	a5,s4,80006254 <sys_rwlktest+0x1fe>
    80006288:	8752                	mv	a4,s4
    8000628a:	b7e9                	j	80006254 <sys_rwlktest+0x1fe>
    if (maxwv > 1) {
    8000628c:	4785                	li	a5,1
    8000628e:	8c5e                	mv	s8,s7
    80006290:	0547fb63          	bgeu	a5,s4,800062e6 <sys_rwlktest+0x290>
      printf("rwspinlock_test: cpu %d saw concurrent reads/writes: %d\n", id, maxwv);
    80006294:	8652                	mv	a2,s4
    80006296:	4581                	li	a1,0
    80006298:	00002517          	auipc	a0,0x2
    8000629c:	5b050513          	addi	a0,a0,1456 # 80008848 <etext+0x848>
    800062a0:	d20ff0ef          	jal	800057c0 <printf>
      r = -1;
    800062a4:	5c7d                	li	s8,-1
    800062a6:	a081                	j	800062e6 <sys_rwlktest+0x290>
      if (y > maxrv) {
    800062a8:	0007049b          	sext.w	s1,a4
      read_release(&l);
    800062ac:	8556                	mv	a0,s5
    800062ae:	d79ff0ef          	jal	80006026 <read_release>
    for (int i = 0; i < 1000000; i++) {
    800062b2:	3a7d                	addiw	s4,s4,-1
    800062b4:	020a0663          	beqz	s4,800062e0 <sys_rwlktest+0x28a>
      read_acquire(&l);
    800062b8:	8556                	mv	a0,s5
    800062ba:	bb5ff0ef          	jal	80005e6e <read_acquire>
      uint x = __atomic_add_fetch(&v, 1, __ATOMIC_ACQ_REL);
    800062be:	0799a72f          	amoadd.w.aqrl	a4,s9,(s3)
    800062c2:	2705                	addiw	a4,a4,1
      uint y = __atomic_fetch_sub(&v, 1, __ATOMIC_ACQ_REL);
    800062c4:	0769a6af          	amoadd.w.aqrl	a3,s6,(s3)
      if (y > maxrv) {
    800062c8:	87ba                	mv	a5,a4
    800062ca:	0006861b          	sext.w	a2,a3
    800062ce:	00c77363          	bgeu	a4,a2,800062d4 <sys_rwlktest+0x27e>
    800062d2:	87b6                	mv	a5,a3
    800062d4:	873e                	mv	a4,a5
    800062d6:	2781                	sext.w	a5,a5
    800062d8:	fc97f8e3          	bgeu	a5,s1,800062a8 <sys_rwlktest+0x252>
    800062dc:	8726                	mv	a4,s1
    800062de:	b7e9                	j	800062a8 <sys_rwlktest+0x252>
    if (maxrv < 2) {
    800062e0:	4785                	li	a5,1
    800062e2:	0297f863          	bgeu	a5,s1,80006312 <sys_rwlktest+0x2bc>
  rwspinlock_test_step(++step, "checking for concurrent writers");
    800062e6:	00002597          	auipc	a1,0x2
    800062ea:	5da58593          	addi	a1,a1,1498 # 800088c0 <etext+0x8c0>
    800062ee:	451d                	li	a0,7
    800062f0:	a67ff0ef          	jal	80005d56 <rwspinlock_test_step>
    800062f4:	000f49b7          	lui	s3,0xf4
    800062f8:	24098993          	addi	s3,s3,576 # f4240 <_entry-0x7ff0bdc0>
    write_acquire(&l);
    800062fc:	0001da17          	auipc	s4,0x1d
    80006300:	604a0a13          	addi	s4,s4,1540 # 80023900 <l.5>
    uint x = __atomic_add_fetch(&v, 1, __ATOMIC_ACQ_REL);
    80006304:	00003497          	auipc	s1,0x3
    80006308:	9b448493          	addi	s1,s1,-1612 # 80008cb8 <v.3>
    8000630c:	4b05                	li	s6,1
    uint y = __atomic_fetch_sub(&v, 1, __ATOMIC_ACQ_REL);
    8000630e:	5afd                	li	s5,-1
    80006310:	a01d                	j	80006336 <sys_rwlktest+0x2e0>
      printf("rwspinlock_test: cpu %d never saw concurrent reads: %d\n", id, maxrv);
    80006312:	8626                	mv	a2,s1
    80006314:	85de                	mv	a1,s7
    80006316:	00002517          	auipc	a0,0x2
    8000631a:	57250513          	addi	a0,a0,1394 # 80008888 <etext+0x888>
    8000631e:	ca2ff0ef          	jal	800057c0 <printf>
      r = -1;
    80006322:	5c7d                	li	s8,-1
    80006324:	b7c9                	j	800062e6 <sys_rwlktest+0x290>
    if (y > maxwv) {
    80006326:	0007091b          	sext.w	s2,a4
    write_release(&l);
    8000632a:	8552                	mv	a0,s4
    8000632c:	d13ff0ef          	jal	8000603e <write_release>
  for (int i = 0; i < 1000000; i++) {
    80006330:	39fd                	addiw	s3,s3,-1
    80006332:	02098663          	beqz	s3,8000635e <sys_rwlktest+0x308>
    write_acquire(&l);
    80006336:	8552                	mv	a0,s4
    80006338:	b57ff0ef          	jal	80005e8e <write_acquire>
    uint x = __atomic_add_fetch(&v, 1, __ATOMIC_ACQ_REL);
    8000633c:	0764a72f          	amoadd.w.aqrl	a4,s6,(s1)
    80006340:	2705                	addiw	a4,a4,1
    uint y = __atomic_fetch_sub(&v, 1, __ATOMIC_ACQ_REL);
    80006342:	0754a6af          	amoadd.w.aqrl	a3,s5,(s1)
    if (y > maxwv) {
    80006346:	87ba                	mv	a5,a4
    80006348:	0006861b          	sext.w	a2,a3
    8000634c:	00c77363          	bgeu	a4,a2,80006352 <sys_rwlktest+0x2fc>
    80006350:	87b6                	mv	a5,a3
    80006352:	873e                	mv	a4,a5
    80006354:	2781                	sext.w	a5,a5
    80006356:	fd27f8e3          	bgeu	a5,s2,80006326 <sys_rwlktest+0x2d0>
    8000635a:	874a                	mv	a4,s2
    8000635c:	b7e9                	j	80006326 <sys_rwlktest+0x2d0>
  if (maxwv > 1) {
    8000635e:	4785                	li	a5,1
    80006360:	0727ec63          	bltu	a5,s2,800063d8 <sys_rwlktest+0x382>
  rwspinlock_test_step(++step, "acquiring multiple locks");
    80006364:	00002597          	auipc	a1,0x2
    80006368:	5b458593          	addi	a1,a1,1460 # 80008918 <etext+0x918>
    8000636c:	4521                	li	a0,8
    8000636e:	9e9ff0ef          	jal	80005d56 <rwspinlock_test_step>
  initrwlock(&l2);
    80006372:	f8040493          	addi	s1,s0,-128
    80006376:	8526                	mv	a0,s1
    80006378:	c93ff0ef          	jal	8000600a <initrwlock>
  write_acquire(&l2);
    8000637c:	8526                	mv	a0,s1
    8000637e:	b11ff0ef          	jal	80005e8e <write_acquire>
  read_acquire(&l);
    80006382:	0001d517          	auipc	a0,0x1d
    80006386:	57e50513          	addi	a0,a0,1406 # 80023900 <l.5>
    8000638a:	ae5ff0ef          	jal	80005e6e <read_acquire>
  rwspinlock_test_step(++step, "releasing multiple locks");
    8000638e:	00002597          	auipc	a1,0x2
    80006392:	5aa58593          	addi	a1,a1,1450 # 80008938 <etext+0x938>
    80006396:	4525                	li	a0,9
    80006398:	9bfff0ef          	jal	80005d56 <rwspinlock_test_step>
  write_release(&l2);
    8000639c:	8526                	mv	a0,s1
    8000639e:	ca1ff0ef          	jal	8000603e <write_release>
  read_release(&l);
    800063a2:	0001d517          	auipc	a0,0x1d
    800063a6:	55e50513          	addi	a0,a0,1374 # 80023900 <l.5>
    800063aa:	c7dff0ef          	jal	80006026 <read_release>
    800063ae:	44ad                	li	s1,11
    rwspinlock_test_step(++step, "prepare read_acquire for multiple writer priority test");
    800063b0:	00002a97          	auipc	s5,0x2
    800063b4:	5a8a8a93          	addi	s5,s5,1448 # 80008958 <etext+0x958>
    if (id == 3) {
    800063b8:	498d                	li	s3,3
    rwspinlock_test_step(++step, "multiple writer priority test");
    800063ba:	00002b17          	auipc	s6,0x2
    800063be:	5d6b0b13          	addi	s6,s6,1494 # 80008990 <etext+0x990>
    if (id == 0 || id == 1) {
    800063c2:	4c85                	li	s9,1
    if (id == 2) {
    800063c4:	4d09                	li	s10,2
      read_acquire(&l);
    800063c6:	0001d917          	auipc	s2,0x1d
    800063ca:	53a90913          	addi	s2,s2,1338 # 80023900 <l.5>
      if (writer_count == 0) {
    800063ce:	00003a17          	auipc	s4,0x3
    800063d2:	8e6a0a13          	addi	s4,s4,-1818 # 80008cb4 <writer_count.2>
    800063d6:	a059                	j	8000645c <sys_rwlktest+0x406>
    printf("rwspinlock_test: cpu %d saw concurrent writes: %d\n", id, maxwv);
    800063d8:	864a                	mv	a2,s2
    800063da:	85de                	mv	a1,s7
    800063dc:	00002517          	auipc	a0,0x2
    800063e0:	50450513          	addi	a0,a0,1284 # 800088e0 <etext+0x8e0>
    800063e4:	bdcff0ef          	jal	800057c0 <printf>
    r = -1;
    800063e8:	5c7d                	li	s8,-1
    800063ea:	bfad                	j	80006364 <sys_rwlktest+0x30e>
      writer_count = 0;
    800063ec:	000a2023          	sw	zero,0(s4)
      read_acquire(&l);
    800063f0:	854a                	mv	a0,s2
    800063f2:	a7dff0ef          	jal	80005e6e <read_acquire>
      read_acquire(&l);
    800063f6:	854a                	mv	a0,s2
    800063f8:	a77ff0ef          	jal	80005e6e <read_acquire>
    rwspinlock_test_step(++step, "multiple writer priority test");
    800063fc:	85da                	mv	a1,s6
    800063fe:	8526                	mv	a0,s1
    80006400:	957ff0ef          	jal	80005d56 <rwspinlock_test_step>
    if (id == 3) {
    80006404:	053b9863          	bne	s7,s3,80006454 <sys_rwlktest+0x3fe>
      delay();
    80006408:	91bff0ef          	jal	80005d22 <delay>
      read_release(&l);
    8000640c:	854a                	mv	a0,s2
    8000640e:	c19ff0ef          	jal	80006026 <read_release>
      delay();
    80006412:	911ff0ef          	jal	80005d22 <delay>
      read_release(&l);
    80006416:	854a                	mv	a0,s2
    80006418:	c0fff0ef          	jal	80006026 <read_release>
      delay();
    8000641c:	907ff0ef          	jal	80005d22 <delay>
      delay();
    80006420:	903ff0ef          	jal	80005d22 <delay>
      read_acquire(&l);
    80006424:	854a                	mv	a0,s2
    80006426:	a49ff0ef          	jal	80005e6e <read_acquire>
      if (writer_count != 2) {
    8000642a:	000a2783          	lw	a5,0(s4)
    8000642e:	09a79063          	bne	a5,s10,800064ae <sys_rwlktest+0x458>
      read_release(&l);
    80006432:	854a                	mv	a0,s2
    80006434:	bf3ff0ef          	jal	80006026 <read_release>
    80006438:	a831                	j	80006454 <sys_rwlktest+0x3fe>
      write_acquire(&l);
    8000643a:	854a                	mv	a0,s2
    8000643c:	a53ff0ef          	jal	80005e8e <write_acquire>
      writer_count++;
    80006440:	000a2783          	lw	a5,0(s4)
    80006444:	2785                	addiw	a5,a5,1
    80006446:	00fa2023          	sw	a5,0(s4)
      delay();
    8000644a:	8d9ff0ef          	jal	80005d22 <delay>
      write_release(&l);
    8000644e:	854a                	mv	a0,s2
    80006450:	befff0ef          	jal	8000603e <write_release>
  for (int i = 0; i < 10; i++) {
    80006454:	2489                	addiw	s1,s1,2
    80006456:	47fd                	li	a5,31
    80006458:	06f48363          	beq	s1,a5,800064be <sys_rwlktest+0x468>
    rwspinlock_test_step(++step, "prepare read_acquire for multiple writer priority test");
    8000645c:	85d6                	mv	a1,s5
    8000645e:	fff4851b          	addiw	a0,s1,-1
    80006462:	8f5ff0ef          	jal	80005d56 <rwspinlock_test_step>
    if (id == 3) {
    80006466:	f93b83e3          	beq	s7,s3,800063ec <sys_rwlktest+0x396>
    rwspinlock_test_step(++step, "multiple writer priority test");
    8000646a:	85da                	mv	a1,s6
    8000646c:	8526                	mv	a0,s1
    8000646e:	8e9ff0ef          	jal	80005d56 <rwspinlock_test_step>
    if (id == 0 || id == 1) {
    80006472:	fd7cf4e3          	bgeu	s9,s7,8000643a <sys_rwlktest+0x3e4>
    if (id == 2) {
    80006476:	fdab9fe3          	bne	s7,s10,80006454 <sys_rwlktest+0x3fe>
      delay();
    8000647a:	8a9ff0ef          	jal	80005d22 <delay>
      read_acquire(&l);
    8000647e:	854a                	mv	a0,s2
    80006480:	9efff0ef          	jal	80005e6e <read_acquire>
      if (writer_count == 0) {
    80006484:	000a2783          	lw	a5,0(s4)
    80006488:	cb99                	beqz	a5,8000649e <sys_rwlktest+0x448>
      delay();
    8000648a:	899ff0ef          	jal	80005d22 <delay>
      delay();
    8000648e:	895ff0ef          	jal	80005d22 <delay>
      delay();
    80006492:	891ff0ef          	jal	80005d22 <delay>
      read_release(&l);
    80006496:	854a                	mv	a0,s2
    80006498:	b8fff0ef          	jal	80006026 <read_release>
    if (id == 3) {
    8000649c:	bf65                	j	80006454 <sys_rwlktest+0x3fe>
        printf("rwspinlock_test: reader sneaked ahead of both waiting writers\n");
    8000649e:	00002517          	auipc	a0,0x2
    800064a2:	51250513          	addi	a0,a0,1298 # 800089b0 <etext+0x9b0>
    800064a6:	b1aff0ef          	jal	800057c0 <printf>
        r = -1;
    800064aa:	5c7d                	li	s8,-1
    800064ac:	bff9                	j	8000648a <sys_rwlktest+0x434>
        printf("rwspinlock_test: reader sneaked ahead of second waiting writer\n");
    800064ae:	00002517          	auipc	a0,0x2
    800064b2:	54250513          	addi	a0,a0,1346 # 800089f0 <etext+0x9f0>
    800064b6:	b0aff0ef          	jal	800057c0 <printf>
        r = -1;
    800064ba:	5c7d                	li	s8,-1
    800064bc:	bf9d                	j	80006432 <sys_rwlktest+0x3dc>
  rwspinlock_test_step(++step, "done");
    800064be:	00002597          	auipc	a1,0x2
    800064c2:	57258593          	addi	a1,a1,1394 # 80008a30 <etext+0xa30>
    800064c6:	4579                	li	a0,30
    800064c8:	88fff0ef          	jal	80005d56 <rwspinlock_test_step>
  printf("rwspinlock_test(%d): %d\n", id, r);
    800064cc:	8662                	mv	a2,s8
    800064ce:	85de                	mv	a1,s7
    800064d0:	00002517          	auipc	a0,0x2
    800064d4:	56850513          	addi	a0,a0,1384 # 80008a38 <etext+0xa38>
    800064d8:	ae8ff0ef          	jal	800057c0 <printf>
  pop_off();
    800064dc:	9d3ff0ef          	jal	80005eae <pop_off>
}
    800064e0:	8562                	mv	a0,s8
    800064e2:	70e6                	ld	ra,120(sp)
    800064e4:	7446                	ld	s0,112(sp)
    800064e6:	74a6                	ld	s1,104(sp)
    800064e8:	7906                	ld	s2,96(sp)
    800064ea:	69e6                	ld	s3,88(sp)
    800064ec:	6a46                	ld	s4,80(sp)
    800064ee:	6aa6                	ld	s5,72(sp)
    800064f0:	6b06                	ld	s6,64(sp)
    800064f2:	7be2                	ld	s7,56(sp)
    800064f4:	7c42                	ld	s8,48(sp)
    800064f6:	7ca2                	ld	s9,40(sp)
    800064f8:	7d02                	ld	s10,32(sp)
    800064fa:	6109                	addi	sp,sp,128
    800064fc:	8082                	ret

00000000800064fe <atomic_read4>:

// Read a shared 32-bit value without holding a lock
int
atomic_read4(int *addr) {
    800064fe:	1141                	addi	sp,sp,-16
    80006500:	e406                	sd	ra,8(sp)
    80006502:	e022                	sd	s0,0(sp)
    80006504:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006506:	0330000f          	fence	rw,rw
    8000650a:	4108                	lw	a0,0(a0)
    8000650c:	0230000f          	fence	r,rw
  return val;
}
    80006510:	2501                	sext.w	a0,a0
    80006512:	60a2                	ld	ra,8(sp)
    80006514:	6402                	ld	s0,0(sp)
    80006516:	0141                	addi	sp,sp,16
    80006518:	8082                	ret

000000008000651a <snprint_lock>:
#ifdef LAB_LOCK
int
snprint_lock(char *buf, int sz, struct spinlock *lk)
{
  int n = 0;
  if(lk->n > 0) {
    8000651a:	4e5c                	lw	a5,28(a2)
    8000651c:	00f04463          	bgtz	a5,80006524 <snprint_lock+0xa>
  int n = 0;
    80006520:	4501                	li	a0,0
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
                 lk->name, lk->nts, lk->n);
  }
  return n;
}
    80006522:	8082                	ret
{
    80006524:	1141                	addi	sp,sp,-16
    80006526:	e406                	sd	ra,8(sp)
    80006528:	e022                	sd	s0,0(sp)
    8000652a:	0800                	addi	s0,sp,16
    n = snprintf(buf, sz, "lock: %s: #test-and-set %d #acquire() %d\n",
    8000652c:	4e18                	lw	a4,24(a2)
    8000652e:	6614                	ld	a3,8(a2)
    80006530:	00002617          	auipc	a2,0x2
    80006534:	52860613          	addi	a2,a2,1320 # 80008a58 <etext+0xa58>
    80006538:	c31fe0ef          	jal	80005168 <snprintf>
}
    8000653c:	60a2                	ld	ra,8(sp)
    8000653e:	6402                	ld	s0,0(sp)
    80006540:	0141                	addi	sp,sp,16
    80006542:	8082                	ret

0000000080006544 <statslock>:

int
statslock(char *buf, int sz) {
    80006544:	711d                	addi	sp,sp,-96
    80006546:	ec86                	sd	ra,88(sp)
    80006548:	e8a2                	sd	s0,80(sp)
    8000654a:	e4a6                	sd	s1,72(sp)
    8000654c:	e0ca                	sd	s2,64(sp)
    8000654e:	fc4e                	sd	s3,56(sp)
    80006550:	f852                	sd	s4,48(sp)
    80006552:	f456                	sd	s5,40(sp)
    80006554:	f05a                	sd	s6,32(sp)
    80006556:	ec5e                	sd	s7,24(sp)
    80006558:	e862                	sd	s8,16(sp)
    8000655a:	e466                	sd	s9,8(sp)
    8000655c:	e06a                	sd	s10,0(sp)
    8000655e:	1080                	addi	s0,sp,96
    80006560:	8aaa                	mv	s5,a0
    80006562:	8b2e                	mv	s6,a1
  int n;
  int tot = 0;

  acquire(&lock_locks);
    80006564:	0001d517          	auipc	a0,0x1d
    80006568:	37c50513          	addi	a0,a0,892 # 800238e0 <lock_locks>
    8000656c:	8abff0ef          	jal	80005e16 <acquire>
  n = snprintf(buf, sz, "--- lock kmem stats\n");
    80006570:	00002617          	auipc	a2,0x2
    80006574:	51860613          	addi	a2,a2,1304 # 80008a88 <etext+0xa88>
    80006578:	85da                	mv	a1,s6
    8000657a:	8556                	mv	a0,s5
    8000657c:	bedfe0ef          	jal	80005168 <snprintf>
    80006580:	8a2a                	mv	s4,a0
  for(int i = 0; i < NLOCK; i++) {
    80006582:	0001dc17          	auipc	s8,0x1d
    80006586:	39ec0c13          	addi	s8,s8,926 # 80023920 <locks>
    8000658a:	0001ec97          	auipc	s9,0x1e
    8000658e:	336c8c93          	addi	s9,s9,822 # 800248c0 <end>
  n = snprintf(buf, sz, "--- lock kmem stats\n");
    80006592:	84e2                	mv	s1,s8
  int tot = 0;
    80006594:	4b81                	li	s7,0
    if(locks[i] == 0)
      break;
    if(strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    80006596:	00002917          	auipc	s2,0x2
    8000659a:	a7a90913          	addi	s2,s2,-1414 # 80008010 <etext+0x10>
    8000659e:	a021                	j	800065a6 <statslock+0x62>
  for(int i = 0; i < NLOCK; i++) {
    800065a0:	04a1                	addi	s1,s1,8
    800065a2:	03948c63          	beq	s1,s9,800065da <statslock+0x96>
    if(locks[i] == 0)
    800065a6:	609c                	ld	a5,0(s1)
    800065a8:	cb8d                	beqz	a5,800065da <statslock+0x96>
    if(strncmp(locks[i]->name, "kmem", strlen("kmem")) == 0) {
    800065aa:	0087b983          	ld	s3,8(a5)
    800065ae:	854a                	mv	a0,s2
    800065b0:	df9f90ef          	jal	800003a8 <strlen>
    800065b4:	862a                	mv	a2,a0
    800065b6:	85ca                	mv	a1,s2
    800065b8:	854e                	mv	a0,s3
    800065ba:	d39f90ef          	jal	800002f2 <strncmp>
    800065be:	f16d                	bnez	a0,800065a0 <statslock+0x5c>
      tot += locks[i]->nts;
    800065c0:	6090                	ld	a2,0(s1)
    800065c2:	4e1c                	lw	a5,24(a2)
    800065c4:	01778bbb          	addw	s7,a5,s7
      n += snprint_lock(buf +n, sz-n, locks[i]);
    800065c8:	414b05bb          	subw	a1,s6,s4
    800065cc:	014a8533          	add	a0,s5,s4
    800065d0:	f4bff0ef          	jal	8000651a <snprint_lock>
    800065d4:	01450a3b          	addw	s4,a0,s4
    800065d8:	b7e1                	j	800065a0 <statslock+0x5c>
    }
  }
  
  n += snprintf(buf+n, sz-n, "--- top 5 contended locks:\n");
    800065da:	00002617          	auipc	a2,0x2
    800065de:	4c660613          	addi	a2,a2,1222 # 80008aa0 <etext+0xaa0>
    800065e2:	414b05bb          	subw	a1,s6,s4
    800065e6:	014a8533          	add	a0,s5,s4
    800065ea:	b7ffe0ef          	jal	80005168 <snprintf>
    800065ee:	014509bb          	addw	s3,a0,s4
    800065f2:	4a15                	li	s4,5
  int last = 100000000;
    800065f4:	05f5e837          	lui	a6,0x5f5e
    800065f8:	10080813          	addi	a6,a6,256 # 5f5e100 <_entry-0x7a0a1f00>
  for(int t = 0; t < 5; t++) {
    int top = 0;
    for(int i = 0; i < NLOCK; i++) {
      if(locks[i] == 0)
        break;
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    800065fc:	0001d497          	auipc	s1,0x1d
    80006600:	32448493          	addi	s1,s1,804 # 80023920 <locks>
    for(int i = 0; i < NLOCK; i++) {
    80006604:	1f400913          	li	s2,500
    80006608:	a881                	j	80006658 <statslock+0x114>
        top = i;
    8000660a:	85ba                	mv	a1,a4
    for(int i = 0; i < NLOCK; i++) {
    8000660c:	2705                	addiw	a4,a4,1
    8000660e:	06a1                	addi	a3,a3,8
    80006610:	01270f63          	beq	a4,s2,8000662e <statslock+0xea>
      if(locks[i] == 0)
    80006614:	629c                	ld	a5,0(a3)
    80006616:	cf81                	beqz	a5,8000662e <statslock+0xea>
      if(locks[i]->nts > locks[top]->nts && locks[i]->nts < last) {
    80006618:	4f90                	lw	a2,24(a5)
    8000661a:	00359793          	slli	a5,a1,0x3
    8000661e:	97a6                	add	a5,a5,s1
    80006620:	639c                	ld	a5,0(a5)
    80006622:	4f9c                	lw	a5,24(a5)
    80006624:	fec7d4e3          	bge	a5,a2,8000660c <statslock+0xc8>
    80006628:	ff0652e3          	bge	a2,a6,8000660c <statslock+0xc8>
    8000662c:	bff9                	j	8000660a <statslock+0xc6>
      }
    }
    n += snprint_lock(buf+n, sz-n, locks[top]);
    8000662e:	058e                	slli	a1,a1,0x3
    80006630:	00b48cb3          	add	s9,s1,a1
    80006634:	000cb603          	ld	a2,0(s9)
    80006638:	413b05bb          	subw	a1,s6,s3
    8000663c:	013a8533          	add	a0,s5,s3
    80006640:	edbff0ef          	jal	8000651a <snprint_lock>
    80006644:	01350d3b          	addw	s10,a0,s3
    80006648:	89ea                	mv	s3,s10
    last = locks[top]->nts;
    8000664a:	000cb783          	ld	a5,0(s9)
    8000664e:	0187a803          	lw	a6,24(a5)
  for(int t = 0; t < 5; t++) {
    80006652:	3a7d                	addiw	s4,s4,-1
    80006654:	000a0663          	beqz	s4,80006660 <statslock+0x11c>
  int tot = 0;
    80006658:	86e2                	mv	a3,s8
    for(int i = 0; i < NLOCK; i++) {
    8000665a:	4701                	li	a4,0
    int top = 0;
    8000665c:	4581                	li	a1,0
    8000665e:	bf5d                	j	80006614 <statslock+0xd0>
  }
  n += snprintf(buf+n, sz-n, "tot= %d\n", tot);
    80006660:	86de                	mv	a3,s7
    80006662:	00002617          	auipc	a2,0x2
    80006666:	45e60613          	addi	a2,a2,1118 # 80008ac0 <etext+0xac0>
    8000666a:	41ab05bb          	subw	a1,s6,s10
    8000666e:	01aa8533          	add	a0,s5,s10
    80006672:	af7fe0ef          	jal	80005168 <snprintf>
    80006676:	01a50d3b          	addw	s10,a0,s10
  release(&lock_locks);  
    8000667a:	0001d517          	auipc	a0,0x1d
    8000667e:	26650513          	addi	a0,a0,614 # 800238e0 <lock_locks>
    80006682:	87dff0ef          	jal	80005efe <release>
  return n;
}
    80006686:	856a                	mv	a0,s10
    80006688:	60e6                	ld	ra,88(sp)
    8000668a:	6446                	ld	s0,80(sp)
    8000668c:	64a6                	ld	s1,72(sp)
    8000668e:	6906                	ld	s2,64(sp)
    80006690:	79e2                	ld	s3,56(sp)
    80006692:	7a42                	ld	s4,48(sp)
    80006694:	7aa2                	ld	s5,40(sp)
    80006696:	7b02                	ld	s6,32(sp)
    80006698:	6be2                	ld	s7,24(sp)
    8000669a:	6c42                	ld	s8,16(sp)
    8000669c:	6ca2                	ld	s9,8(sp)
    8000669e:	6d02                	ld	s10,0(sp)
    800066a0:	6125                	addi	sp,sp,96
    800066a2:	8082                	ret
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0)
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	9282                	jalr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0)
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
