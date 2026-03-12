
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	019cb117          	auipc	sp,0x19cb
    80000004:	71010113          	addi	sp,sp,1808 # 819cb710 <stack0>
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
    80000016:	3b3050ef          	jal	80005bc8 <start>

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
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	019d3797          	auipc	a5,0x19d3
    8000002c:	7c078793          	addi	a5,a5,1984 # 819d37e8 <end>
    80000030:	00f53733          	sltu	a4,a0,a5
    80000034:	47c5                	li	a5,17
    80000036:	07ee                	slli	a5,a5,0x1b
    80000038:	17fd                	addi	a5,a5,-1
    8000003a:	00a7b7b3          	sltu	a5,a5,a0
    8000003e:	8fd9                	or	a5,a5,a4
    80000040:	ef95                	bnez	a5,8000007c <kfree+0x60>
    80000042:	84aa                	mv	s1,a0
    80000044:	03451793          	slli	a5,a0,0x34
    80000048:	eb95                	bnez	a5,8000007c <kfree+0x60>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004a:	6605                	lui	a2,0x1
    8000004c:	4585                	li	a1,1
    8000004e:	110000ef          	jal	8000015e <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000052:	00009917          	auipc	s2,0x9
    80000056:	a3e90913          	addi	s2,s2,-1474 # 80008a90 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	5ee060ef          	jal	8000664a <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	672060ef          	jal	800066de <release>
}
    80000070:	60e2                	ld	ra,24(sp)
    80000072:	6442                	ld	s0,16(sp)
    80000074:	64a2                	ld	s1,8(sp)
    80000076:	6902                	ld	s2,0(sp)
    80000078:	6105                	addi	sp,sp,32
    8000007a:	8082                	ret
    panic("kfree");
    8000007c:	00008517          	auipc	a0,0x8
    80000080:	f8450513          	addi	a0,a0,-124 # 80008000 <etext>
    80000084:	304060ef          	jal	80006388 <panic>

0000000080000088 <freerange>:
{
    80000088:	7179                	addi	sp,sp,-48
    8000008a:	f406                	sd	ra,40(sp)
    8000008c:	f022                	sd	s0,32(sp)
    8000008e:	ec26                	sd	s1,24(sp)
    80000090:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000092:	6785                	lui	a5,0x1
    80000094:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000098:	00e504b3          	add	s1,a0,a4
    8000009c:	777d                	lui	a4,0xfffff
    8000009e:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000a0:	94be                	add	s1,s1,a5
    800000a2:	0295e263          	bltu	a1,s1,800000c6 <freerange+0x3e>
    800000a6:	e84a                	sd	s2,16(sp)
    800000a8:	e44e                	sd	s3,8(sp)
    800000aa:	e052                	sd	s4,0(sp)
    800000ac:	892e                	mv	s2,a1
    kfree(p);
    800000ae:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b0:	89be                	mv	s3,a5
    kfree(p);
    800000b2:	01448533          	add	a0,s1,s4
    800000b6:	f67ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ba:	94ce                	add	s1,s1,s3
    800000bc:	fe997be3          	bgeu	s2,s1,800000b2 <freerange+0x2a>
    800000c0:	6942                	ld	s2,16(sp)
    800000c2:	69a2                	ld	s3,8(sp)
    800000c4:	6a02                	ld	s4,0(sp)
}
    800000c6:	70a2                	ld	ra,40(sp)
    800000c8:	7402                	ld	s0,32(sp)
    800000ca:	64e2                	ld	s1,24(sp)
    800000cc:	6145                	addi	sp,sp,48
    800000ce:	8082                	ret

00000000800000d0 <kinit>:
{
    800000d0:	1141                	addi	sp,sp,-16
    800000d2:	e406                	sd	ra,8(sp)
    800000d4:	e022                	sd	s0,0(sp)
    800000d6:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d8:	00008597          	auipc	a1,0x8
    800000dc:	f3858593          	addi	a1,a1,-200 # 80008010 <etext+0x10>
    800000e0:	00009517          	auipc	a0,0x9
    800000e4:	9b050513          	addi	a0,a0,-1616 # 80008a90 <kmem>
    800000e8:	4d8060ef          	jal	800065c0 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	019d3517          	auipc	a0,0x19d3
    800000f4:	6f850513          	addi	a0,a0,1784 # 819d37e8 <end>
    800000f8:	f91ff0ef          	jal	80000088 <freerange>
}
    800000fc:	60a2                	ld	ra,8(sp)
    800000fe:	6402                	ld	s0,0(sp)
    80000100:	0141                	addi	sp,sp,16
    80000102:	8082                	ret

0000000080000104 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000104:	1101                	addi	sp,sp,-32
    80000106:	ec06                	sd	ra,24(sp)
    80000108:	e822                	sd	s0,16(sp)
    8000010a:	e426                	sd	s1,8(sp)
    8000010c:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    8000010e:	00009517          	auipc	a0,0x9
    80000112:	98250513          	addi	a0,a0,-1662 # 80008a90 <kmem>
    80000116:	534060ef          	jal	8000664a <acquire>
  r = kmem.freelist;
    8000011a:	00009497          	auipc	s1,0x9
    8000011e:	98e4b483          	ld	s1,-1650(s1) # 80008aa8 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	00009717          	auipc	a4,0x9
    8000012a:	98f73123          	sd	a5,-1662(a4) # 80008aa8 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	00009517          	auipc	a0,0x9
    80000132:	96250513          	addi	a0,a0,-1694 # 80008a90 <kmem>
    80000136:	5a8060ef          	jal	800066de <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000013a:	6605                	lui	a2,0x1
    8000013c:	4595                	li	a1,5
    8000013e:	8526                	mv	a0,s1
    80000140:	01e000ef          	jal	8000015e <memset>
  return (void*)r;
}
    80000144:	8526                	mv	a0,s1
    80000146:	60e2                	ld	ra,24(sp)
    80000148:	6442                	ld	s0,16(sp)
    8000014a:	64a2                	ld	s1,8(sp)
    8000014c:	6105                	addi	sp,sp,32
    8000014e:	8082                	ret
  release(&kmem.lock);
    80000150:	00009517          	auipc	a0,0x9
    80000154:	94050513          	addi	a0,a0,-1728 # 80008a90 <kmem>
    80000158:	586060ef          	jal	800066de <release>
  if(r)
    8000015c:	b7e5                	j	80000144 <kalloc+0x40>

000000008000015e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000015e:	1141                	addi	sp,sp,-16
    80000160:	e406                	sd	ra,8(sp)
    80000162:	e022                	sd	s0,0(sp)
    80000164:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000166:	ca19                	beqz	a2,8000017c <memset+0x1e>
    80000168:	87aa                	mv	a5,a0
    8000016a:	1602                	slli	a2,a2,0x20
    8000016c:	9201                	srli	a2,a2,0x20
    8000016e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000172:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000176:	0785                	addi	a5,a5,1
    80000178:	fee79de3          	bne	a5,a4,80000172 <memset+0x14>
  }
  return dst;
}
    8000017c:	60a2                	ld	ra,8(sp)
    8000017e:	6402                	ld	s0,0(sp)
    80000180:	0141                	addi	sp,sp,16
    80000182:	8082                	ret

0000000080000184 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000184:	1141                	addi	sp,sp,-16
    80000186:	e406                	sd	ra,8(sp)
    80000188:	e022                	sd	s0,0(sp)
    8000018a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000018c:	c61d                	beqz	a2,800001ba <memcmp+0x36>
    8000018e:	1602                	slli	a2,a2,0x20
    80000190:	9201                	srli	a2,a2,0x20
    80000192:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000196:	00054783          	lbu	a5,0(a0)
    8000019a:	0005c703          	lbu	a4,0(a1)
    8000019e:	00e79863          	bne	a5,a4,800001ae <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    800001a2:	0505                	addi	a0,a0,1
    800001a4:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001a6:	fed518e3          	bne	a0,a3,80000196 <memcmp+0x12>
  }

  return 0;
    800001aa:	4501                	li	a0,0
    800001ac:	a019                	j	800001b2 <memcmp+0x2e>
      return *s1 - *s2;
    800001ae:	40e7853b          	subw	a0,a5,a4
}
    800001b2:	60a2                	ld	ra,8(sp)
    800001b4:	6402                	ld	s0,0(sp)
    800001b6:	0141                	addi	sp,sp,16
    800001b8:	8082                	ret
  return 0;
    800001ba:	4501                	li	a0,0
    800001bc:	bfdd                	j	800001b2 <memcmp+0x2e>

00000000800001be <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001be:	1141                	addi	sp,sp,-16
    800001c0:	e406                	sd	ra,8(sp)
    800001c2:	e022                	sd	s0,0(sp)
    800001c4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001c6:	c205                	beqz	a2,800001e6 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001c8:	02a5e363          	bltu	a1,a0,800001ee <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001cc:	1602                	slli	a2,a2,0x20
    800001ce:	9201                	srli	a2,a2,0x20
    800001d0:	00c587b3          	add	a5,a1,a2
{
    800001d4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001d6:	0585                	addi	a1,a1,1
    800001d8:	0705                	addi	a4,a4,1
    800001da:	fff5c683          	lbu	a3,-1(a1)
    800001de:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001e2:	feb79ae3          	bne	a5,a1,800001d6 <memmove+0x18>

  return dst;
}
    800001e6:	60a2                	ld	ra,8(sp)
    800001e8:	6402                	ld	s0,0(sp)
    800001ea:	0141                	addi	sp,sp,16
    800001ec:	8082                	ret
  if(s < d && s + n > d){
    800001ee:	02061693          	slli	a3,a2,0x20
    800001f2:	9281                	srli	a3,a3,0x20
    800001f4:	00d58733          	add	a4,a1,a3
    800001f8:	fce57ae3          	bgeu	a0,a4,800001cc <memmove+0xe>
    d += n;
    800001fc:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001fe:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000202:	1782                	slli	a5,a5,0x20
    80000204:	9381                	srli	a5,a5,0x20
    80000206:	fff7c793          	not	a5,a5
    8000020a:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000020c:	177d                	addi	a4,a4,-1
    8000020e:	16fd                	addi	a3,a3,-1
    80000210:	00074603          	lbu	a2,0(a4)
    80000214:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000218:	fee79ae3          	bne	a5,a4,8000020c <memmove+0x4e>
    8000021c:	b7e9                	j	800001e6 <memmove+0x28>

000000008000021e <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000021e:	1141                	addi	sp,sp,-16
    80000220:	e406                	sd	ra,8(sp)
    80000222:	e022                	sd	s0,0(sp)
    80000224:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000226:	f99ff0ef          	jal	800001be <memmove>
}
    8000022a:	60a2                	ld	ra,8(sp)
    8000022c:	6402                	ld	s0,0(sp)
    8000022e:	0141                	addi	sp,sp,16
    80000230:	8082                	ret

0000000080000232 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000232:	1141                	addi	sp,sp,-16
    80000234:	e406                	sd	ra,8(sp)
    80000236:	e022                	sd	s0,0(sp)
    80000238:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000023a:	ce11                	beqz	a2,80000256 <strncmp+0x24>
    8000023c:	00054783          	lbu	a5,0(a0)
    80000240:	cf89                	beqz	a5,8000025a <strncmp+0x28>
    80000242:	0005c703          	lbu	a4,0(a1)
    80000246:	00f71a63          	bne	a4,a5,8000025a <strncmp+0x28>
    n--, p++, q++;
    8000024a:	367d                	addiw	a2,a2,-1
    8000024c:	0505                	addi	a0,a0,1
    8000024e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000250:	f675                	bnez	a2,8000023c <strncmp+0xa>
  if(n == 0)
    return 0;
    80000252:	4501                	li	a0,0
    80000254:	a801                	j	80000264 <strncmp+0x32>
    80000256:	4501                	li	a0,0
    80000258:	a031                	j	80000264 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000025a:	00054503          	lbu	a0,0(a0)
    8000025e:	0005c783          	lbu	a5,0(a1)
    80000262:	9d1d                	subw	a0,a0,a5
}
    80000264:	60a2                	ld	ra,8(sp)
    80000266:	6402                	ld	s0,0(sp)
    80000268:	0141                	addi	sp,sp,16
    8000026a:	8082                	ret

000000008000026c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000026c:	1141                	addi	sp,sp,-16
    8000026e:	e406                	sd	ra,8(sp)
    80000270:	e022                	sd	s0,0(sp)
    80000272:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000274:	87aa                	mv	a5,a0
    80000276:	a011                	j	8000027a <strncpy+0xe>
    80000278:	8636                	mv	a2,a3
    8000027a:	02c05863          	blez	a2,800002aa <strncpy+0x3e>
    8000027e:	fff6069b          	addiw	a3,a2,-1
    80000282:	8836                	mv	a6,a3
    80000284:	0785                	addi	a5,a5,1
    80000286:	0005c703          	lbu	a4,0(a1)
    8000028a:	fee78fa3          	sb	a4,-1(a5)
    8000028e:	0585                	addi	a1,a1,1
    80000290:	f765                	bnez	a4,80000278 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000292:	873e                	mv	a4,a5
    80000294:	01005b63          	blez	a6,800002aa <strncpy+0x3e>
    80000298:	9fb1                	addw	a5,a5,a2
    8000029a:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800002a2:	40e786bb          	subw	a3,a5,a4
    800002a6:	fed04be3          	bgtz	a3,8000029c <strncpy+0x30>
  return os;
}
    800002aa:	60a2                	ld	ra,8(sp)
    800002ac:	6402                	ld	s0,0(sp)
    800002ae:	0141                	addi	sp,sp,16
    800002b0:	8082                	ret

00000000800002b2 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002b2:	1141                	addi	sp,sp,-16
    800002b4:	e406                	sd	ra,8(sp)
    800002b6:	e022                	sd	s0,0(sp)
    800002b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002ba:	02c05363          	blez	a2,800002e0 <safestrcpy+0x2e>
    800002be:	fff6069b          	addiw	a3,a2,-1
    800002c2:	1682                	slli	a3,a3,0x20
    800002c4:	9281                	srli	a3,a3,0x20
    800002c6:	96ae                	add	a3,a3,a1
    800002c8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002ca:	00d58963          	beq	a1,a3,800002dc <safestrcpy+0x2a>
    800002ce:	0585                	addi	a1,a1,1
    800002d0:	0785                	addi	a5,a5,1
    800002d2:	fff5c703          	lbu	a4,-1(a1)
    800002d6:	fee78fa3          	sb	a4,-1(a5)
    800002da:	fb65                	bnez	a4,800002ca <safestrcpy+0x18>
    ;
  *s = 0;
    800002dc:	00078023          	sb	zero,0(a5)
  return os;
}
    800002e0:	60a2                	ld	ra,8(sp)
    800002e2:	6402                	ld	s0,0(sp)
    800002e4:	0141                	addi	sp,sp,16
    800002e6:	8082                	ret

00000000800002e8 <strlen>:

int
strlen(const char *s)
{
    800002e8:	1141                	addi	sp,sp,-16
    800002ea:	e406                	sd	ra,8(sp)
    800002ec:	e022                	sd	s0,0(sp)
    800002ee:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002f0:	00054783          	lbu	a5,0(a0)
    800002f4:	cf91                	beqz	a5,80000310 <strlen+0x28>
    800002f6:	00150793          	addi	a5,a0,1
    800002fa:	86be                	mv	a3,a5
    800002fc:	0785                	addi	a5,a5,1
    800002fe:	fff7c703          	lbu	a4,-1(a5)
    80000302:	ff65                	bnez	a4,800002fa <strlen+0x12>
    80000304:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000308:	60a2                	ld	ra,8(sp)
    8000030a:	6402                	ld	s0,0(sp)
    8000030c:	0141                	addi	sp,sp,16
    8000030e:	8082                	ret
  for(n = 0; s[n]; n++)
    80000310:	4501                	li	a0,0
    80000312:	bfdd                	j	80000308 <strlen+0x20>

0000000080000314 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000314:	1101                	addi	sp,sp,-32
    80000316:	ec06                	sd	ra,24(sp)
    80000318:	e822                	sd	s0,16(sp)
    8000031a:	e426                	sd	s1,8(sp)
    8000031c:	1000                	addi	s0,sp,32
  if(cpuid() == 0){
    8000031e:	2b7000ef          	jal	80000dd4 <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(atomic_read4((int *) &started) == 0)
    80000322:	00008497          	auipc	s1,0x8
    80000326:	72e48493          	addi	s1,s1,1838 # 80008a50 <started>
  if(cpuid() == 0){
    8000032a:	c905                	beqz	a0,8000035a <main+0x46>
    while(atomic_read4((int *) &started) == 0)
    8000032c:	8526                	mv	a0,s1
    8000032e:	3ec060ef          	jal	8000671a <atomic_read4>
    80000332:	dd6d                	beqz	a0,8000032c <main+0x18>
      ;
    __sync_synchronize();
    80000334:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000338:	29d000ef          	jal	80000dd4 <cpuid>
    8000033c:	85aa                	mv	a1,a0
    8000033e:	00008517          	auipc	a0,0x8
    80000342:	cfa50513          	addi	a0,a0,-774 # 80008038 <etext+0x38>
    80000346:	519050ef          	jal	8000605e <printf>
    kvminithart();    // turn on paging
    8000034a:	088000ef          	jal	800003d2 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034e:	602010ef          	jal	80001950 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000352:	628040ef          	jal	8000497a <plicinithart>
  }

#ifdef LAB_LOCK
  rwspinlock_test();
#endif
  scheduler();        
    80000356:	741000ef          	jal	80001296 <scheduler>
    consoleinit();
    8000035a:	42b050ef          	jal	80005f84 <consoleinit>
    printfinit();
    8000035e:	066060ef          	jal	800063c4 <printfinit>
    printf("\n");
    80000362:	00008517          	auipc	a0,0x8
    80000366:	cb650513          	addi	a0,a0,-842 # 80008018 <etext+0x18>
    8000036a:	4f5050ef          	jal	8000605e <printf>
    printf("xv6 kernel is booting\n");
    8000036e:	00008517          	auipc	a0,0x8
    80000372:	cb250513          	addi	a0,a0,-846 # 80008020 <etext+0x20>
    80000376:	4e9050ef          	jal	8000605e <printf>
    printf("\n");
    8000037a:	00008517          	auipc	a0,0x8
    8000037e:	c9e50513          	addi	a0,a0,-866 # 80008018 <etext+0x18>
    80000382:	4dd050ef          	jal	8000605e <printf>
    kinit();         // physical page allocator
    80000386:	d4bff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    8000038a:	2f8000ef          	jal	80000682 <kvminit>
    kvminithart();   // turn on paging
    8000038e:	044000ef          	jal	800003d2 <kvminithart>
    procinit();      // process table
    80000392:	169000ef          	jal	80000cfa <procinit>
    trapinit();      // trap vectors
    80000396:	596010ef          	jal	8000192c <trapinit>
    trapinithart();  // install kernel trap vector
    8000039a:	5b6010ef          	jal	80001950 <trapinithart>
    plicinit();      // set up interrupt controller
    8000039e:	5b0040ef          	jal	8000494e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003a2:	5d8040ef          	jal	8000497a <plicinithart>
    binit();         // buffer cache
    800003a6:	445010ef          	jal	80001fea <binit>
    iinit();         // inode table
    800003aa:	196020ef          	jal	80002540 <iinit>
    fileinit();      // file table
    800003ae:	0c2030ef          	jal	80003470 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003b2:	6c6040ef          	jal	80004a78 <virtio_disk_init>
    pci_init();
    800003b6:	742050ef          	jal	80005af8 <pci_init>
    netinit();
    800003ba:	66f040ef          	jal	80005228 <netinit>
    userinit();      // first user process
    800003be:	527000ef          	jal	800010e4 <userinit>
    __sync_synchronize();
    800003c2:	0330000f          	fence	rw,rw
    started = 1;
    800003c6:	4785                	li	a5,1
    800003c8:	00008717          	auipc	a4,0x8
    800003cc:	68f72423          	sw	a5,1672(a4) # 80008a50 <started>
    800003d0:	b759                	j	80000356 <main+0x42>

00000000800003d2 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    800003d2:	1141                	addi	sp,sp,-16
    800003d4:	e406                	sd	ra,8(sp)
    800003d6:	e022                	sd	s0,0(sp)
    800003d8:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003da:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003de:	00008797          	auipc	a5,0x8
    800003e2:	67a7b783          	ld	a5,1658(a5) # 80008a58 <kernel_pagetable>
    800003e6:	83b1                	srli	a5,a5,0xc
    800003e8:	577d                	li	a4,-1
    800003ea:	177e                	slli	a4,a4,0x3f
    800003ec:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003ee:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003f2:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003f6:	60a2                	ld	ra,8(sp)
    800003f8:	6402                	ld	s0,0(sp)
    800003fa:	0141                	addi	sp,sp,16
    800003fc:	8082                	ret

00000000800003fe <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003fe:	7139                	addi	sp,sp,-64
    80000400:	fc06                	sd	ra,56(sp)
    80000402:	f822                	sd	s0,48(sp)
    80000404:	f426                	sd	s1,40(sp)
    80000406:	f04a                	sd	s2,32(sp)
    80000408:	ec4e                	sd	s3,24(sp)
    8000040a:	e852                	sd	s4,16(sp)
    8000040c:	e456                	sd	s5,8(sp)
    8000040e:	e05a                	sd	s6,0(sp)
    80000410:	0080                	addi	s0,sp,64
    80000412:	84aa                	mv	s1,a0
    80000414:	89ae                	mv	s3,a1
    80000416:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80000418:	57fd                	li	a5,-1
    8000041a:	83e9                	srli	a5,a5,0x1a
    8000041c:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    8000041e:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80000420:	04b7e263          	bltu	a5,a1,80000464 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000424:	0149d933          	srl	s2,s3,s4
    80000428:	1ff97913          	andi	s2,s2,511
    8000042c:	090e                	slli	s2,s2,0x3
    8000042e:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000430:	00093483          	ld	s1,0(s2)
    80000434:	0014f793          	andi	a5,s1,1
    80000438:	cf85                	beqz	a5,80000470 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000043a:	80a9                	srli	s1,s1,0xa
    8000043c:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    8000043e:	3a5d                	addiw	s4,s4,-9
    80000440:	ff5a12e3          	bne	s4,s5,80000424 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000444:	00c9d513          	srli	a0,s3,0xc
    80000448:	1ff57513          	andi	a0,a0,511
    8000044c:	050e                	slli	a0,a0,0x3
    8000044e:	9526                	add	a0,a0,s1
}
    80000450:	70e2                	ld	ra,56(sp)
    80000452:	7442                	ld	s0,48(sp)
    80000454:	74a2                	ld	s1,40(sp)
    80000456:	7902                	ld	s2,32(sp)
    80000458:	69e2                	ld	s3,24(sp)
    8000045a:	6a42                	ld	s4,16(sp)
    8000045c:	6aa2                	ld	s5,8(sp)
    8000045e:	6b02                	ld	s6,0(sp)
    80000460:	6121                	addi	sp,sp,64
    80000462:	8082                	ret
    panic("walk");
    80000464:	00008517          	auipc	a0,0x8
    80000468:	bec50513          	addi	a0,a0,-1044 # 80008050 <etext+0x50>
    8000046c:	71d050ef          	jal	80006388 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000470:	020b0263          	beqz	s6,80000494 <walk+0x96>
    80000474:	c91ff0ef          	jal	80000104 <kalloc>
    80000478:	84aa                	mv	s1,a0
    8000047a:	d979                	beqz	a0,80000450 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    8000047c:	6605                	lui	a2,0x1
    8000047e:	4581                	li	a1,0
    80000480:	cdfff0ef          	jal	8000015e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000484:	00c4d793          	srli	a5,s1,0xc
    80000488:	07aa                	slli	a5,a5,0xa
    8000048a:	0017e793          	ori	a5,a5,1
    8000048e:	00f93023          	sd	a5,0(s2)
    80000492:	b775                	j	8000043e <walk+0x40>
        return 0;
    80000494:	4501                	li	a0,0
    80000496:	bf6d                	j	80000450 <walk+0x52>

0000000080000498 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    80000498:	57fd                	li	a5,-1
    8000049a:	83e9                	srli	a5,a5,0x1a
    8000049c:	00b7f463          	bgeu	a5,a1,800004a4 <walkaddr+0xc>
    return 0;
    800004a0:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800004a2:	8082                	ret
{
    800004a4:	1141                	addi	sp,sp,-16
    800004a6:	e406                	sd	ra,8(sp)
    800004a8:	e022                	sd	s0,0(sp)
    800004aa:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004ac:	4601                	li	a2,0
    800004ae:	f51ff0ef          	jal	800003fe <walk>
  if(pte == 0)
    800004b2:	c901                	beqz	a0,800004c2 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    800004b4:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004b6:	0117f693          	andi	a3,a5,17
    800004ba:	4745                	li	a4,17
    return 0;
    800004bc:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004be:	00e68663          	beq	a3,a4,800004ca <walkaddr+0x32>
}
    800004c2:	60a2                	ld	ra,8(sp)
    800004c4:	6402                	ld	s0,0(sp)
    800004c6:	0141                	addi	sp,sp,16
    800004c8:	8082                	ret
  pa = PTE2PA(*pte);
    800004ca:	83a9                	srli	a5,a5,0xa
    800004cc:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004d0:	bfcd                	j	800004c2 <walkaddr+0x2a>

00000000800004d2 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004d2:	715d                	addi	sp,sp,-80
    800004d4:	e486                	sd	ra,72(sp)
    800004d6:	e0a2                	sd	s0,64(sp)
    800004d8:	fc26                	sd	s1,56(sp)
    800004da:	f84a                	sd	s2,48(sp)
    800004dc:	f44e                	sd	s3,40(sp)
    800004de:	f052                	sd	s4,32(sp)
    800004e0:	ec56                	sd	s5,24(sp)
    800004e2:	e85a                	sd	s6,16(sp)
    800004e4:	e45e                	sd	s7,8(sp)
    800004e6:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004e8:	03459793          	slli	a5,a1,0x34
    800004ec:	eba1                	bnez	a5,8000053c <mappages+0x6a>
    800004ee:	8a2a                	mv	s4,a0
    800004f0:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004f2:	03461793          	slli	a5,a2,0x34
    800004f6:	eba9                	bnez	a5,80000548 <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    800004f8:	ce31                	beqz	a2,80000554 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004fa:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    800004fe:	80060613          	addi	a2,a2,-2048
    80000502:	00b60933          	add	s2,a2,a1
  a = va;
    80000506:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80000508:	4b05                	li	s6,1
    8000050a:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    8000050e:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    80000510:	865a                	mv	a2,s6
    80000512:	85a6                	mv	a1,s1
    80000514:	8552                	mv	a0,s4
    80000516:	ee9ff0ef          	jal	800003fe <walk>
    8000051a:	c929                	beqz	a0,8000056c <mappages+0x9a>
    if(*pte & PTE_V)
    8000051c:	611c                	ld	a5,0(a0)
    8000051e:	8b85                	andi	a5,a5,1
    80000520:	e3a1                	bnez	a5,80000560 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000522:	013487b3          	add	a5,s1,s3
    80000526:	83b1                	srli	a5,a5,0xc
    80000528:	07aa                	slli	a5,a5,0xa
    8000052a:	0157e7b3          	or	a5,a5,s5
    8000052e:	0017e793          	ori	a5,a5,1
    80000532:	e11c                	sd	a5,0(a0)
    if(a == last)
    80000534:	05248863          	beq	s1,s2,80000584 <mappages+0xb2>
    a += PGSIZE;
    80000538:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000053a:	bfd9                	j	80000510 <mappages+0x3e>
    panic("mappages: va not aligned");
    8000053c:	00008517          	auipc	a0,0x8
    80000540:	b1c50513          	addi	a0,a0,-1252 # 80008058 <etext+0x58>
    80000544:	645050ef          	jal	80006388 <panic>
    panic("mappages: size not aligned");
    80000548:	00008517          	auipc	a0,0x8
    8000054c:	b3050513          	addi	a0,a0,-1232 # 80008078 <etext+0x78>
    80000550:	639050ef          	jal	80006388 <panic>
    panic("mappages: size");
    80000554:	00008517          	auipc	a0,0x8
    80000558:	b4450513          	addi	a0,a0,-1212 # 80008098 <etext+0x98>
    8000055c:	62d050ef          	jal	80006388 <panic>
      panic("mappages: remap");
    80000560:	00008517          	auipc	a0,0x8
    80000564:	b4850513          	addi	a0,a0,-1208 # 800080a8 <etext+0xa8>
    80000568:	621050ef          	jal	80006388 <panic>
      return -1;
    8000056c:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    8000056e:	60a6                	ld	ra,72(sp)
    80000570:	6406                	ld	s0,64(sp)
    80000572:	74e2                	ld	s1,56(sp)
    80000574:	7942                	ld	s2,48(sp)
    80000576:	79a2                	ld	s3,40(sp)
    80000578:	7a02                	ld	s4,32(sp)
    8000057a:	6ae2                	ld	s5,24(sp)
    8000057c:	6b42                	ld	s6,16(sp)
    8000057e:	6ba2                	ld	s7,8(sp)
    80000580:	6161                	addi	sp,sp,80
    80000582:	8082                	ret
  return 0;
    80000584:	4501                	li	a0,0
    80000586:	b7e5                	j	8000056e <mappages+0x9c>

0000000080000588 <kvmmap>:
{
    80000588:	1141                	addi	sp,sp,-16
    8000058a:	e406                	sd	ra,8(sp)
    8000058c:	e022                	sd	s0,0(sp)
    8000058e:	0800                	addi	s0,sp,16
    80000590:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000592:	86b2                	mv	a3,a2
    80000594:	863e                	mv	a2,a5
    80000596:	f3dff0ef          	jal	800004d2 <mappages>
    8000059a:	e509                	bnez	a0,800005a4 <kvmmap+0x1c>
}
    8000059c:	60a2                	ld	ra,8(sp)
    8000059e:	6402                	ld	s0,0(sp)
    800005a0:	0141                	addi	sp,sp,16
    800005a2:	8082                	ret
    panic("kvmmap");
    800005a4:	00008517          	auipc	a0,0x8
    800005a8:	b1450513          	addi	a0,a0,-1260 # 800080b8 <etext+0xb8>
    800005ac:	5dd050ef          	jal	80006388 <panic>

00000000800005b0 <kvmmake>:
{
    800005b0:	1101                	addi	sp,sp,-32
    800005b2:	ec06                	sd	ra,24(sp)
    800005b4:	e822                	sd	s0,16(sp)
    800005b6:	e426                	sd	s1,8(sp)
    800005b8:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005ba:	b4bff0ef          	jal	80000104 <kalloc>
    800005be:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005c0:	6605                	lui	a2,0x1
    800005c2:	4581                	li	a1,0
    800005c4:	b9bff0ef          	jal	8000015e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005c8:	4719                	li	a4,6
    800005ca:	6685                	lui	a3,0x1
    800005cc:	10000637          	lui	a2,0x10000
    800005d0:	85b2                	mv	a1,a2
    800005d2:	8526                	mv	a0,s1
    800005d4:	fb5ff0ef          	jal	80000588 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005d8:	4719                	li	a4,6
    800005da:	6685                	lui	a3,0x1
    800005dc:	10001637          	lui	a2,0x10001
    800005e0:	85b2                	mv	a1,a2
    800005e2:	8526                	mv	a0,s1
    800005e4:	fa5ff0ef          	jal	80000588 <kvmmap>
  kvmmap(kpgtbl, 0x30000000L, 0x30000000L, 0x10000000, PTE_R | PTE_W);
    800005e8:	4719                	li	a4,6
    800005ea:	100006b7          	lui	a3,0x10000
    800005ee:	30000637          	lui	a2,0x30000
    800005f2:	85b2                	mv	a1,a2
    800005f4:	8526                	mv	a0,s1
    800005f6:	f93ff0ef          	jal	80000588 <kvmmap>
  kvmmap(kpgtbl, 0x40000000L, 0x40000000L, 0x20000, PTE_R | PTE_W);
    800005fa:	4719                	li	a4,6
    800005fc:	000206b7          	lui	a3,0x20
    80000600:	40000637          	lui	a2,0x40000
    80000604:	85b2                	mv	a1,a2
    80000606:	8526                	mv	a0,s1
    80000608:	f81ff0ef          	jal	80000588 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000060c:	4719                	li	a4,6
    8000060e:	040006b7          	lui	a3,0x4000
    80000612:	0c000637          	lui	a2,0xc000
    80000616:	85b2                	mv	a1,a2
    80000618:	8526                	mv	a0,s1
    8000061a:	f6fff0ef          	jal	80000588 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000061e:	4729                	li	a4,10
    80000620:	80008697          	auipc	a3,0x80008
    80000624:	9e068693          	addi	a3,a3,-1568 # 8000 <_entry-0x7fff8000>
    80000628:	4605                	li	a2,1
    8000062a:	067e                	slli	a2,a2,0x1f
    8000062c:	85b2                	mv	a1,a2
    8000062e:	8526                	mv	a0,s1
    80000630:	f59ff0ef          	jal	80000588 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000634:	4719                	li	a4,6
    80000636:	00008697          	auipc	a3,0x8
    8000063a:	9ca68693          	addi	a3,a3,-1590 # 80008000 <etext>
    8000063e:	47c5                	li	a5,17
    80000640:	07ee                	slli	a5,a5,0x1b
    80000642:	40d786b3          	sub	a3,a5,a3
    80000646:	00008617          	auipc	a2,0x8
    8000064a:	9ba60613          	addi	a2,a2,-1606 # 80008000 <etext>
    8000064e:	85b2                	mv	a1,a2
    80000650:	8526                	mv	a0,s1
    80000652:	f37ff0ef          	jal	80000588 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000656:	4729                	li	a4,10
    80000658:	6685                	lui	a3,0x1
    8000065a:	00007617          	auipc	a2,0x7
    8000065e:	9a660613          	addi	a2,a2,-1626 # 80007000 <_trampoline>
    80000662:	040005b7          	lui	a1,0x4000
    80000666:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000668:	05b2                	slli	a1,a1,0xc
    8000066a:	8526                	mv	a0,s1
    8000066c:	f1dff0ef          	jal	80000588 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000670:	8526                	mv	a0,s1
    80000672:	5e6000ef          	jal	80000c58 <proc_mapstacks>
}
    80000676:	8526                	mv	a0,s1
    80000678:	60e2                	ld	ra,24(sp)
    8000067a:	6442                	ld	s0,16(sp)
    8000067c:	64a2                	ld	s1,8(sp)
    8000067e:	6105                	addi	sp,sp,32
    80000680:	8082                	ret

0000000080000682 <kvminit>:
{
    80000682:	1141                	addi	sp,sp,-16
    80000684:	e406                	sd	ra,8(sp)
    80000686:	e022                	sd	s0,0(sp)
    80000688:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000068a:	f27ff0ef          	jal	800005b0 <kvmmake>
    8000068e:	00008797          	auipc	a5,0x8
    80000692:	3ca7b523          	sd	a0,970(a5) # 80008a58 <kernel_pagetable>
}
    80000696:	60a2                	ld	ra,8(sp)
    80000698:	6402                	ld	s0,0(sp)
    8000069a:	0141                	addi	sp,sp,16
    8000069c:	8082                	ret

000000008000069e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000069e:	1101                	addi	sp,sp,-32
    800006a0:	ec06                	sd	ra,24(sp)
    800006a2:	e822                	sd	s0,16(sp)
    800006a4:	e426                	sd	s1,8(sp)
    800006a6:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800006a8:	a5dff0ef          	jal	80000104 <kalloc>
    800006ac:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800006ae:	c509                	beqz	a0,800006b8 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800006b0:	6605                	lui	a2,0x1
    800006b2:	4581                	li	a1,0
    800006b4:	aabff0ef          	jal	8000015e <memset>
  return pagetable;
}
    800006b8:	8526                	mv	a0,s1
    800006ba:	60e2                	ld	ra,24(sp)
    800006bc:	6442                	ld	s0,16(sp)
    800006be:	64a2                	ld	s1,8(sp)
    800006c0:	6105                	addi	sp,sp,32
    800006c2:	8082                	ret

00000000800006c4 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800006c4:	715d                	addi	sp,sp,-80
    800006c6:	e486                	sd	ra,72(sp)
    800006c8:	e0a2                	sd	s0,64(sp)
    800006ca:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;

  if((va % PGSIZE) != 0)
    800006cc:	03459793          	slli	a5,a1,0x34
    800006d0:	e39d                	bnez	a5,800006f6 <uvmunmap+0x32>
    800006d2:	f84a                	sd	s2,48(sp)
    800006d4:	f44e                	sd	s3,40(sp)
    800006d6:	f052                	sd	s4,32(sp)
    800006d8:	ec56                	sd	s5,24(sp)
    800006da:	e85a                	sd	s6,16(sp)
    800006dc:	e45e                	sd	s7,8(sp)
    800006de:	8a2a                	mv	s4,a0
    800006e0:	892e                	mv	s2,a1
    800006e2:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006e4:	0632                	slli	a2,a2,0xc
    800006e6:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
      continue;
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
      continue;
    sz = PGSIZE;
    if(PTE_FLAGS(*pte) == PTE_V)
    800006ea:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006ec:	6a85                	lui	s5,0x1
    800006ee:	0735f463          	bgeu	a1,s3,80000756 <uvmunmap+0x92>
    800006f2:	fc26                	sd	s1,56(sp)
    800006f4:	a80d                	j	80000726 <uvmunmap+0x62>
    800006f6:	fc26                	sd	s1,56(sp)
    800006f8:	f84a                	sd	s2,48(sp)
    800006fa:	f44e                	sd	s3,40(sp)
    800006fc:	f052                	sd	s4,32(sp)
    800006fe:	ec56                	sd	s5,24(sp)
    80000700:	e85a                	sd	s6,16(sp)
    80000702:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    80000704:	00008517          	auipc	a0,0x8
    80000708:	9bc50513          	addi	a0,a0,-1604 # 800080c0 <etext+0xc0>
    8000070c:	47d050ef          	jal	80006388 <panic>
      panic("uvmunmap: not a leaf");
    80000710:	00008517          	auipc	a0,0x8
    80000714:	9c850513          	addi	a0,a0,-1592 # 800080d8 <etext+0xd8>
    80000718:	471050ef          	jal	80006388 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000071c:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000720:	9956                	add	s2,s2,s5
    80000722:	03397963          	bgeu	s2,s3,80000754 <uvmunmap+0x90>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80000726:	4601                	li	a2,0
    80000728:	85ca                	mv	a1,s2
    8000072a:	8552                	mv	a0,s4
    8000072c:	cd3ff0ef          	jal	800003fe <walk>
    80000730:	84aa                	mv	s1,a0
    80000732:	d57d                	beqz	a0,80000720 <uvmunmap+0x5c>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80000734:	611c                	ld	a5,0(a0)
    80000736:	0017f713          	andi	a4,a5,1
    8000073a:	d37d                	beqz	a4,80000720 <uvmunmap+0x5c>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000073c:	3ff7f713          	andi	a4,a5,1023
    80000740:	fd7708e3          	beq	a4,s7,80000710 <uvmunmap+0x4c>
    if(do_free){
    80000744:	fc0b0ce3          	beqz	s6,8000071c <uvmunmap+0x58>
      uint64 pa = PTE2PA(*pte);
    80000748:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    8000074a:	00c79513          	slli	a0,a5,0xc
    8000074e:	8cfff0ef          	jal	8000001c <kfree>
    80000752:	b7e9                	j	8000071c <uvmunmap+0x58>
    80000754:	74e2                	ld	s1,56(sp)
    80000756:	7942                	ld	s2,48(sp)
    80000758:	79a2                	ld	s3,40(sp)
    8000075a:	7a02                	ld	s4,32(sp)
    8000075c:	6ae2                	ld	s5,24(sp)
    8000075e:	6b42                	ld	s6,16(sp)
    80000760:	6ba2                	ld	s7,8(sp)
  }
}
    80000762:	60a6                	ld	ra,72(sp)
    80000764:	6406                	ld	s0,64(sp)
    80000766:	6161                	addi	sp,sp,80
    80000768:	8082                	ret

000000008000076a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000076a:	1101                	addi	sp,sp,-32
    8000076c:	ec06                	sd	ra,24(sp)
    8000076e:	e822                	sd	s0,16(sp)
    80000770:	e426                	sd	s1,8(sp)
    80000772:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000774:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000776:	00b67d63          	bgeu	a2,a1,80000790 <uvmdealloc+0x26>
    8000077a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000077c:	6785                	lui	a5,0x1
    8000077e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000780:	00f60733          	add	a4,a2,a5
    80000784:	76fd                	lui	a3,0xfffff
    80000786:	8f75                	and	a4,a4,a3
    80000788:	97ae                	add	a5,a5,a1
    8000078a:	8ff5                	and	a5,a5,a3
    8000078c:	00f76863          	bltu	a4,a5,8000079c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000790:	8526                	mv	a0,s1
    80000792:	60e2                	ld	ra,24(sp)
    80000794:	6442                	ld	s0,16(sp)
    80000796:	64a2                	ld	s1,8(sp)
    80000798:	6105                	addi	sp,sp,32
    8000079a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000079c:	8f99                	sub	a5,a5,a4
    8000079e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800007a0:	4685                	li	a3,1
    800007a2:	0007861b          	sext.w	a2,a5
    800007a6:	85ba                	mv	a1,a4
    800007a8:	f1dff0ef          	jal	800006c4 <uvmunmap>
    800007ac:	b7d5                	j	80000790 <uvmdealloc+0x26>

00000000800007ae <uvmalloc>:
  if(newsz < oldsz)
    800007ae:	0ab66163          	bltu	a2,a1,80000850 <uvmalloc+0xa2>
{
    800007b2:	715d                	addi	sp,sp,-80
    800007b4:	e486                	sd	ra,72(sp)
    800007b6:	e0a2                	sd	s0,64(sp)
    800007b8:	f84a                	sd	s2,48(sp)
    800007ba:	f052                	sd	s4,32(sp)
    800007bc:	ec56                	sd	s5,24(sp)
    800007be:	e45e                	sd	s7,8(sp)
    800007c0:	0880                	addi	s0,sp,80
    800007c2:	8aaa                	mv	s5,a0
    800007c4:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007c6:	6785                	lui	a5,0x1
    800007c8:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007ca:	95be                	add	a1,a1,a5
    800007cc:	77fd                	lui	a5,0xfffff
    800007ce:	00f5f933          	and	s2,a1,a5
    800007d2:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += sz){
    800007d4:	08c97063          	bgeu	s2,a2,80000854 <uvmalloc+0xa6>
    800007d8:	fc26                	sd	s1,56(sp)
    800007da:	f44e                	sd	s3,40(sp)
    800007dc:	e85a                	sd	s6,16(sp)
    memset(mem, 0, sz);
    800007de:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007e0:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007e4:	921ff0ef          	jal	80000104 <kalloc>
    800007e8:	84aa                	mv	s1,a0
    if(mem == 0){
    800007ea:	c50d                	beqz	a0,80000814 <uvmalloc+0x66>
    memset(mem, 0, sz);
    800007ec:	864e                	mv	a2,s3
    800007ee:	4581                	li	a1,0
    800007f0:	96fff0ef          	jal	8000015e <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007f4:	875a                	mv	a4,s6
    800007f6:	86a6                	mv	a3,s1
    800007f8:	864e                	mv	a2,s3
    800007fa:	85ca                	mv	a1,s2
    800007fc:	8556                	mv	a0,s5
    800007fe:	cd5ff0ef          	jal	800004d2 <mappages>
    80000802:	e915                	bnez	a0,80000836 <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += sz){
    80000804:	994e                	add	s2,s2,s3
    80000806:	fd496fe3          	bltu	s2,s4,800007e4 <uvmalloc+0x36>
  return newsz;
    8000080a:	8552                	mv	a0,s4
    8000080c:	74e2                	ld	s1,56(sp)
    8000080e:	79a2                	ld	s3,40(sp)
    80000810:	6b42                	ld	s6,16(sp)
    80000812:	a811                	j	80000826 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80000814:	865e                	mv	a2,s7
    80000816:	85ca                	mv	a1,s2
    80000818:	8556                	mv	a0,s5
    8000081a:	f51ff0ef          	jal	8000076a <uvmdealloc>
      return 0;
    8000081e:	4501                	li	a0,0
    80000820:	74e2                	ld	s1,56(sp)
    80000822:	79a2                	ld	s3,40(sp)
    80000824:	6b42                	ld	s6,16(sp)
}
    80000826:	60a6                	ld	ra,72(sp)
    80000828:	6406                	ld	s0,64(sp)
    8000082a:	7942                	ld	s2,48(sp)
    8000082c:	7a02                	ld	s4,32(sp)
    8000082e:	6ae2                	ld	s5,24(sp)
    80000830:	6ba2                	ld	s7,8(sp)
    80000832:	6161                	addi	sp,sp,80
    80000834:	8082                	ret
      kfree(mem);
    80000836:	8526                	mv	a0,s1
    80000838:	fe4ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000083c:	865e                	mv	a2,s7
    8000083e:	85ca                	mv	a1,s2
    80000840:	8556                	mv	a0,s5
    80000842:	f29ff0ef          	jal	8000076a <uvmdealloc>
      return 0;
    80000846:	4501                	li	a0,0
    80000848:	74e2                	ld	s1,56(sp)
    8000084a:	79a2                	ld	s3,40(sp)
    8000084c:	6b42                	ld	s6,16(sp)
    8000084e:	bfe1                	j	80000826 <uvmalloc+0x78>
    return oldsz;
    80000850:	852e                	mv	a0,a1
}
    80000852:	8082                	ret
  return newsz;
    80000854:	8532                	mv	a0,a2
    80000856:	bfc1                	j	80000826 <uvmalloc+0x78>

0000000080000858 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000858:	7179                	addi	sp,sp,-48
    8000085a:	f406                	sd	ra,40(sp)
    8000085c:	f022                	sd	s0,32(sp)
    8000085e:	ec26                	sd	s1,24(sp)
    80000860:	e84a                	sd	s2,16(sp)
    80000862:	e44e                	sd	s3,8(sp)
    80000864:	1800                	addi	s0,sp,48
    80000866:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000868:	84aa                	mv	s1,a0
    8000086a:	6905                	lui	s2,0x1
    8000086c:	992a                	add	s2,s2,a0
    8000086e:	a811                	j	80000882 <freewalk+0x2a>
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      // backtrace();
      panic("freewalk: leaf");
    80000870:	00008517          	auipc	a0,0x8
    80000874:	88050513          	addi	a0,a0,-1920 # 800080f0 <etext+0xf0>
    80000878:	311050ef          	jal	80006388 <panic>
  for(int i = 0; i < 512; i++){
    8000087c:	04a1                	addi	s1,s1,8
    8000087e:	03248163          	beq	s1,s2,800008a0 <freewalk+0x48>
    pte_t pte = pagetable[i];
    80000882:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000884:	0017f713          	andi	a4,a5,1
    80000888:	db75                	beqz	a4,8000087c <freewalk+0x24>
    8000088a:	00e7f713          	andi	a4,a5,14
    8000088e:	f36d                	bnez	a4,80000870 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80000890:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000892:	00c79513          	slli	a0,a5,0xc
    80000896:	fc3ff0ef          	jal	80000858 <freewalk>
      pagetable[i] = 0;
    8000089a:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000089e:	bff9                	j	8000087c <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    800008a0:	854e                	mv	a0,s3
    800008a2:	f7aff0ef          	jal	8000001c <kfree>
}
    800008a6:	70a2                	ld	ra,40(sp)
    800008a8:	7402                	ld	s0,32(sp)
    800008aa:	64e2                	ld	s1,24(sp)
    800008ac:	6942                	ld	s2,16(sp)
    800008ae:	69a2                	ld	s3,8(sp)
    800008b0:	6145                	addi	sp,sp,48
    800008b2:	8082                	ret

00000000800008b4 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008b4:	1101                	addi	sp,sp,-32
    800008b6:	ec06                	sd	ra,24(sp)
    800008b8:	e822                	sd	s0,16(sp)
    800008ba:	e426                	sd	s1,8(sp)
    800008bc:	1000                	addi	s0,sp,32
    800008be:	84aa                	mv	s1,a0
  if(sz > 0)
    800008c0:	e989                	bnez	a1,800008d2 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008c2:	8526                	mv	a0,s1
    800008c4:	f95ff0ef          	jal	80000858 <freewalk>
}
    800008c8:	60e2                	ld	ra,24(sp)
    800008ca:	6442                	ld	s0,16(sp)
    800008cc:	64a2                	ld	s1,8(sp)
    800008ce:	6105                	addi	sp,sp,32
    800008d0:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008d2:	6785                	lui	a5,0x1
    800008d4:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008d6:	95be                	add	a1,a1,a5
    800008d8:	4685                	li	a3,1
    800008da:	00c5d613          	srli	a2,a1,0xc
    800008de:	4581                	li	a1,0
    800008e0:	de5ff0ef          	jal	800006c4 <uvmunmap>
    800008e4:	bff9                	j	800008c2 <uvmfree+0xe>

00000000800008e6 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc = PGSIZE;

  for(i = 0; i < sz; i += szinc){
    800008e6:	ca59                	beqz	a2,8000097c <uvmcopy+0x96>
{
    800008e8:	715d                	addi	sp,sp,-80
    800008ea:	e486                	sd	ra,72(sp)
    800008ec:	e0a2                	sd	s0,64(sp)
    800008ee:	fc26                	sd	s1,56(sp)
    800008f0:	f84a                	sd	s2,48(sp)
    800008f2:	f44e                	sd	s3,40(sp)
    800008f4:	f052                	sd	s4,32(sp)
    800008f6:	ec56                	sd	s5,24(sp)
    800008f8:	e85a                	sd	s6,16(sp)
    800008fa:	e45e                	sd	s7,8(sp)
    800008fc:	0880                	addi	s0,sp,80
    800008fe:	8b2a                	mv	s6,a0
    80000900:	8bae                	mv	s7,a1
    80000902:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += szinc){
    80000904:	4481                	li	s1,0
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    80000906:	6a05                	lui	s4,0x1
    80000908:	a021                	j	80000910 <uvmcopy+0x2a>
  for(i = 0; i < sz; i += szinc){
    8000090a:	94d2                	add	s1,s1,s4
    8000090c:	0554fc63          	bgeu	s1,s5,80000964 <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    80000910:	4601                	li	a2,0
    80000912:	85a6                	mv	a1,s1
    80000914:	855a                	mv	a0,s6
    80000916:	ae9ff0ef          	jal	800003fe <walk>
    8000091a:	d965                	beqz	a0,8000090a <uvmcopy+0x24>
    if((*pte & PTE_V) == 0) {
    8000091c:	00053983          	ld	s3,0(a0)
    80000920:	0019f793          	andi	a5,s3,1
    80000924:	d3fd                	beqz	a5,8000090a <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    80000926:	fdeff0ef          	jal	80000104 <kalloc>
    8000092a:	892a                	mv	s2,a0
    8000092c:	c11d                	beqz	a0,80000952 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000092e:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80000932:	8652                	mv	a2,s4
    80000934:	05b2                	slli	a1,a1,0xc
    80000936:	889ff0ef          	jal	800001be <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    8000093a:	3ff9f713          	andi	a4,s3,1023
    8000093e:	86ca                	mv	a3,s2
    80000940:	8652                	mv	a2,s4
    80000942:	85a6                	mv	a1,s1
    80000944:	855e                	mv	a0,s7
    80000946:	b8dff0ef          	jal	800004d2 <mappages>
    8000094a:	d161                	beqz	a0,8000090a <uvmcopy+0x24>
      kfree(mem);
    8000094c:	854a                	mv	a0,s2
    8000094e:	eceff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000952:	4685                	li	a3,1
    80000954:	00c4d613          	srli	a2,s1,0xc
    80000958:	4581                	li	a1,0
    8000095a:	855e                	mv	a0,s7
    8000095c:	d69ff0ef          	jal	800006c4 <uvmunmap>
  return -1;
    80000960:	557d                	li	a0,-1
    80000962:	a011                	j	80000966 <uvmcopy+0x80>
  return 0;
    80000964:	4501                	li	a0,0
}
    80000966:	60a6                	ld	ra,72(sp)
    80000968:	6406                	ld	s0,64(sp)
    8000096a:	74e2                	ld	s1,56(sp)
    8000096c:	7942                	ld	s2,48(sp)
    8000096e:	79a2                	ld	s3,40(sp)
    80000970:	7a02                	ld	s4,32(sp)
    80000972:	6ae2                	ld	s5,24(sp)
    80000974:	6b42                	ld	s6,16(sp)
    80000976:	6ba2                	ld	s7,8(sp)
    80000978:	6161                	addi	sp,sp,80
    8000097a:	8082                	ret
  return 0;
    8000097c:	4501                	li	a0,0
}
    8000097e:	8082                	ret

0000000080000980 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000980:	1141                	addi	sp,sp,-16
    80000982:	e406                	sd	ra,8(sp)
    80000984:	e022                	sd	s0,0(sp)
    80000986:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000988:	4601                	li	a2,0
    8000098a:	a75ff0ef          	jal	800003fe <walk>
  if(pte == 0)
    8000098e:	c901                	beqz	a0,8000099e <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000990:	611c                	ld	a5,0(a0)
    80000992:	9bbd                	andi	a5,a5,-17
    80000994:	e11c                	sd	a5,0(a0)
}
    80000996:	60a2                	ld	ra,8(sp)
    80000998:	6402                	ld	s0,0(sp)
    8000099a:	0141                	addi	sp,sp,16
    8000099c:	8082                	ret
    panic("uvmclear");
    8000099e:	00007517          	auipc	a0,0x7
    800009a2:	76250513          	addi	a0,a0,1890 # 80008100 <etext+0x100>
    800009a6:	1e3050ef          	jal	80006388 <panic>

00000000800009aa <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    800009aa:	cac5                	beqz	a3,80000a5a <copyinstr+0xb0>
{
    800009ac:	715d                	addi	sp,sp,-80
    800009ae:	e486                	sd	ra,72(sp)
    800009b0:	e0a2                	sd	s0,64(sp)
    800009b2:	fc26                	sd	s1,56(sp)
    800009b4:	f84a                	sd	s2,48(sp)
    800009b6:	f44e                	sd	s3,40(sp)
    800009b8:	f052                	sd	s4,32(sp)
    800009ba:	ec56                	sd	s5,24(sp)
    800009bc:	e85a                	sd	s6,16(sp)
    800009be:	e45e                	sd	s7,8(sp)
    800009c0:	0880                	addi	s0,sp,80
    800009c2:	8aaa                	mv	s5,a0
    800009c4:	84ae                	mv	s1,a1
    800009c6:	8bb2                	mv	s7,a2
    800009c8:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800009ca:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800009cc:	6a05                	lui	s4,0x1
    800009ce:	a82d                	j	80000a08 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800009d0:	00078023          	sb	zero,0(a5)
        got_null = 1;
    800009d4:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800009d6:	0017c793          	xori	a5,a5,1
    800009da:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800009de:	60a6                	ld	ra,72(sp)
    800009e0:	6406                	ld	s0,64(sp)
    800009e2:	74e2                	ld	s1,56(sp)
    800009e4:	7942                	ld	s2,48(sp)
    800009e6:	79a2                	ld	s3,40(sp)
    800009e8:	7a02                	ld	s4,32(sp)
    800009ea:	6ae2                	ld	s5,24(sp)
    800009ec:	6b42                	ld	s6,16(sp)
    800009ee:	6ba2                	ld	s7,8(sp)
    800009f0:	6161                	addi	sp,sp,80
    800009f2:	8082                	ret
    800009f4:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    800009f8:	9726                	add	a4,a4,s1
      --max;
    800009fa:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    800009fe:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000a02:	04e58463          	beq	a1,a4,80000a4a <copyinstr+0xa0>
{
    80000a06:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80000a08:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000a0c:	85ca                	mv	a1,s2
    80000a0e:	8556                	mv	a0,s5
    80000a10:	a89ff0ef          	jal	80000498 <walkaddr>
    if(pa0 == 0)
    80000a14:	cd0d                	beqz	a0,80000a4e <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000a16:	417906b3          	sub	a3,s2,s7
    80000a1a:	96d2                	add	a3,a3,s4
    if(n > max)
    80000a1c:	00d9f363          	bgeu	s3,a3,80000a22 <copyinstr+0x78>
    80000a20:	86ce                	mv	a3,s3
    while(n > 0){
    80000a22:	ca85                	beqz	a3,80000a52 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80000a24:	01750633          	add	a2,a0,s7
    80000a28:	41260633          	sub	a2,a2,s2
    80000a2c:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80000a2e:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80000a30:	96a6                	add	a3,a3,s1
    80000a32:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000a34:	00f60733          	add	a4,a2,a5
    80000a38:	00074703          	lbu	a4,0(a4)
    80000a3c:	db51                	beqz	a4,800009d0 <copyinstr+0x26>
        *dst = *p;
    80000a3e:	00e78023          	sb	a4,0(a5)
      dst++;
    80000a42:	0785                	addi	a5,a5,1
    while(n > 0){
    80000a44:	fed797e3          	bne	a5,a3,80000a32 <copyinstr+0x88>
    80000a48:	b775                	j	800009f4 <copyinstr+0x4a>
    80000a4a:	4781                	li	a5,0
    80000a4c:	b769                	j	800009d6 <copyinstr+0x2c>
      return -1;
    80000a4e:	557d                	li	a0,-1
    80000a50:	b779                	j	800009de <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80000a52:	6b85                	lui	s7,0x1
    80000a54:	9bca                	add	s7,s7,s2
    80000a56:	87a6                	mv	a5,s1
    80000a58:	b77d                	j	80000a06 <copyinstr+0x5c>
  int got_null = 0;
    80000a5a:	4781                	li	a5,0
  if(got_null){
    80000a5c:	0017c793          	xori	a5,a5,1
    80000a60:	40f0053b          	negw	a0,a5
}
    80000a64:	8082                	ret

0000000080000a66 <ismapped>:
  }
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va) {
    80000a66:	1141                	addi	sp,sp,-16
    80000a68:	e406                	sd	ra,8(sp)
    80000a6a:	e022                	sd	s0,0(sp)
    80000a6c:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000a6e:	4601                	li	a2,0
    80000a70:	98fff0ef          	jal	800003fe <walk>
  if (pte == 0) {
    80000a74:	c119                	beqz	a0,80000a7a <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    80000a76:	6108                	ld	a0,0(a0)
    80000a78:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a7a:	60a2                	ld	ra,8(sp)
    80000a7c:	6402                	ld	s0,0(sp)
    80000a7e:	0141                	addi	sp,sp,16
    80000a80:	8082                	ret

0000000080000a82 <vmfault>:
{
    80000a82:	7179                	addi	sp,sp,-48
    80000a84:	f406                	sd	ra,40(sp)
    80000a86:	f022                	sd	s0,32(sp)
    80000a88:	e84a                	sd	s2,16(sp)
    80000a8a:	e44e                	sd	s3,8(sp)
    80000a8c:	1800                	addi	s0,sp,48
    80000a8e:	89aa                	mv	s3,a0
    80000a90:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80000a92:	376000ef          	jal	80000e08 <myproc>
  if (va >= p->sz)
    80000a96:	653c                	ld	a5,72(a0)
    80000a98:	00f96a63          	bltu	s2,a5,80000aac <vmfault+0x2a>
    return 0;
    80000a9c:	4981                	li	s3,0
}
    80000a9e:	854e                	mv	a0,s3
    80000aa0:	70a2                	ld	ra,40(sp)
    80000aa2:	7402                	ld	s0,32(sp)
    80000aa4:	6942                	ld	s2,16(sp)
    80000aa6:	69a2                	ld	s3,8(sp)
    80000aa8:	6145                	addi	sp,sp,48
    80000aaa:	8082                	ret
    80000aac:	ec26                	sd	s1,24(sp)
    80000aae:	e052                	sd	s4,0(sp)
    80000ab0:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80000ab2:	77fd                	lui	a5,0xfffff
    80000ab4:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80000ab8:	85d2                	mv	a1,s4
    80000aba:	854e                	mv	a0,s3
    80000abc:	fabff0ef          	jal	80000a66 <ismapped>
    return 0;
    80000ac0:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000ac2:	c501                	beqz	a0,80000aca <vmfault+0x48>
    80000ac4:	64e2                	ld	s1,24(sp)
    80000ac6:	6a02                	ld	s4,0(sp)
    80000ac8:	bfd9                	j	80000a9e <vmfault+0x1c>
  mem = (uint64) kalloc();
    80000aca:	e3aff0ef          	jal	80000104 <kalloc>
    80000ace:	892a                	mv	s2,a0
  if(mem == 0)
    80000ad0:	c905                	beqz	a0,80000b00 <vmfault+0x7e>
  mem = (uint64) kalloc();
    80000ad2:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000ad4:	6605                	lui	a2,0x1
    80000ad6:	4581                	li	a1,0
    80000ad8:	e86ff0ef          	jal	8000015e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000adc:	4759                	li	a4,22
    80000ade:	86ca                	mv	a3,s2
    80000ae0:	6605                	lui	a2,0x1
    80000ae2:	85d2                	mv	a1,s4
    80000ae4:	68a8                	ld	a0,80(s1)
    80000ae6:	9edff0ef          	jal	800004d2 <mappages>
    80000aea:	e501                	bnez	a0,80000af2 <vmfault+0x70>
    80000aec:	64e2                	ld	s1,24(sp)
    80000aee:	6a02                	ld	s4,0(sp)
    80000af0:	b77d                	j	80000a9e <vmfault+0x1c>
    kfree((void *)mem);
    80000af2:	854a                	mv	a0,s2
    80000af4:	d28ff0ef          	jal	8000001c <kfree>
    return 0;
    80000af8:	4981                	li	s3,0
    80000afa:	64e2                	ld	s1,24(sp)
    80000afc:	6a02                	ld	s4,0(sp)
    80000afe:	b745                	j	80000a9e <vmfault+0x1c>
    80000b00:	64e2                	ld	s1,24(sp)
    80000b02:	6a02                	ld	s4,0(sp)
    80000b04:	bf69                	j	80000a9e <vmfault+0x1c>

0000000080000b06 <copyout>:
  while(len > 0){
    80000b06:	cad9                	beqz	a3,80000b9c <copyout+0x96>
{
    80000b08:	711d                	addi	sp,sp,-96
    80000b0a:	ec86                	sd	ra,88(sp)
    80000b0c:	e8a2                	sd	s0,80(sp)
    80000b0e:	e4a6                	sd	s1,72(sp)
    80000b10:	e0ca                	sd	s2,64(sp)
    80000b12:	fc4e                	sd	s3,56(sp)
    80000b14:	f852                	sd	s4,48(sp)
    80000b16:	f456                	sd	s5,40(sp)
    80000b18:	f05a                	sd	s6,32(sp)
    80000b1a:	ec5e                	sd	s7,24(sp)
    80000b1c:	e862                	sd	s8,16(sp)
    80000b1e:	e466                	sd	s9,8(sp)
    80000b20:	e06a                	sd	s10,0(sp)
    80000b22:	1080                	addi	s0,sp,96
    80000b24:	8baa                	mv	s7,a0
    80000b26:	8a2e                	mv	s4,a1
    80000b28:	8b32                	mv	s6,a2
    80000b2a:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000b2c:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80000b2e:	5cfd                	li	s9,-1
    80000b30:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000b34:	6c05                	lui	s8,0x1
    80000b36:	a005                	j	80000b56 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b38:	409a0533          	sub	a0,s4,s1
    80000b3c:	0009061b          	sext.w	a2,s2
    80000b40:	85da                	mv	a1,s6
    80000b42:	954e                	add	a0,a0,s3
    80000b44:	e7aff0ef          	jal	800001be <memmove>
    len -= n;
    80000b48:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000b4c:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000b4e:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80000b52:	040a8363          	beqz	s5,80000b98 <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80000b56:	01aa74b3          	and	s1,s4,s10
    if (va0 >= MAXVA)
    80000b5a:	049ce363          	bltu	s9,s1,80000ba0 <copyout+0x9a>
    pa0 = walkaddr(pagetable, va0);
    80000b5e:	85a6                	mv	a1,s1
    80000b60:	855e                	mv	a0,s7
    80000b62:	937ff0ef          	jal	80000498 <walkaddr>
    80000b66:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80000b68:	e901                	bnez	a0,80000b78 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000b6a:	4601                	li	a2,0
    80000b6c:	85a6                	mv	a1,s1
    80000b6e:	855e                	mv	a0,s7
    80000b70:	f13ff0ef          	jal	80000a82 <vmfault>
    80000b74:	89aa                	mv	s3,a0
    80000b76:	c521                	beqz	a0,80000bbe <copyout+0xb8>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000b78:	4601                	li	a2,0
    80000b7a:	85a6                	mv	a1,s1
    80000b7c:	855e                	mv	a0,s7
    80000b7e:	881ff0ef          	jal	800003fe <walk>
    80000b82:	c121                	beqz	a0,80000bc2 <copyout+0xbc>
    if((*pte & PTE_W) == 0)
    80000b84:	611c                	ld	a5,0(a0)
    80000b86:	8b91                	andi	a5,a5,4
    80000b88:	cf9d                	beqz	a5,80000bc6 <copyout+0xc0>
    n = PGSIZE - (dstva - va0);
    80000b8a:	41448933          	sub	s2,s1,s4
    80000b8e:	9962                	add	s2,s2,s8
    if(n > len)
    80000b90:	fb2af4e3          	bgeu	s5,s2,80000b38 <copyout+0x32>
    80000b94:	8956                	mv	s2,s5
    80000b96:	b74d                	j	80000b38 <copyout+0x32>
  return 0;
    80000b98:	4501                	li	a0,0
    80000b9a:	a021                	j	80000ba2 <copyout+0x9c>
    80000b9c:	4501                	li	a0,0
}
    80000b9e:	8082                	ret
      return -1;
    80000ba0:	557d                	li	a0,-1
}
    80000ba2:	60e6                	ld	ra,88(sp)
    80000ba4:	6446                	ld	s0,80(sp)
    80000ba6:	64a6                	ld	s1,72(sp)
    80000ba8:	6906                	ld	s2,64(sp)
    80000baa:	79e2                	ld	s3,56(sp)
    80000bac:	7a42                	ld	s4,48(sp)
    80000bae:	7aa2                	ld	s5,40(sp)
    80000bb0:	7b02                	ld	s6,32(sp)
    80000bb2:	6be2                	ld	s7,24(sp)
    80000bb4:	6c42                	ld	s8,16(sp)
    80000bb6:	6ca2                	ld	s9,8(sp)
    80000bb8:	6d02                	ld	s10,0(sp)
    80000bba:	6125                	addi	sp,sp,96
    80000bbc:	8082                	ret
        return -1;
    80000bbe:	557d                	li	a0,-1
    80000bc0:	b7cd                	j	80000ba2 <copyout+0x9c>
      return -1;
    80000bc2:	557d                	li	a0,-1
    80000bc4:	bff9                	j	80000ba2 <copyout+0x9c>
      return -1;
    80000bc6:	557d                	li	a0,-1
    80000bc8:	bfe9                	j	80000ba2 <copyout+0x9c>

0000000080000bca <copyin>:
  while(len > 0){
    80000bca:	c6c9                	beqz	a3,80000c54 <copyin+0x8a>
{
    80000bcc:	715d                	addi	sp,sp,-80
    80000bce:	e486                	sd	ra,72(sp)
    80000bd0:	e0a2                	sd	s0,64(sp)
    80000bd2:	fc26                	sd	s1,56(sp)
    80000bd4:	f84a                	sd	s2,48(sp)
    80000bd6:	f44e                	sd	s3,40(sp)
    80000bd8:	f052                	sd	s4,32(sp)
    80000bda:	ec56                	sd	s5,24(sp)
    80000bdc:	e85a                	sd	s6,16(sp)
    80000bde:	e45e                	sd	s7,8(sp)
    80000be0:	e062                	sd	s8,0(sp)
    80000be2:	0880                	addi	s0,sp,80
    80000be4:	8baa                	mv	s7,a0
    80000be6:	8aae                	mv	s5,a1
    80000be8:	8932                	mv	s2,a2
    80000bea:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000bec:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000bee:	6b05                	lui	s6,0x1
    80000bf0:	a035                	j	80000c1c <copyin+0x52>
    80000bf2:	412984b3          	sub	s1,s3,s2
    80000bf6:	94da                	add	s1,s1,s6
    if(n > len)
    80000bf8:	009a7363          	bgeu	s4,s1,80000bfe <copyin+0x34>
    80000bfc:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bfe:	413905b3          	sub	a1,s2,s3
    80000c02:	0004861b          	sext.w	a2,s1
    80000c06:	95aa                	add	a1,a1,a0
    80000c08:	8556                	mv	a0,s5
    80000c0a:	db4ff0ef          	jal	800001be <memmove>
    len -= n;
    80000c0e:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000c12:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000c14:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000c18:	020a0163          	beqz	s4,80000c3a <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000c1c:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000c20:	85ce                	mv	a1,s3
    80000c22:	855e                	mv	a0,s7
    80000c24:	875ff0ef          	jal	80000498 <walkaddr>
    if(pa0 == 0) {
    80000c28:	f569                	bnez	a0,80000bf2 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000c2a:	4601                	li	a2,0
    80000c2c:	85ce                	mv	a1,s3
    80000c2e:	855e                	mv	a0,s7
    80000c30:	e53ff0ef          	jal	80000a82 <vmfault>
    80000c34:	fd5d                	bnez	a0,80000bf2 <copyin+0x28>
        return -1;
    80000c36:	557d                	li	a0,-1
    80000c38:	a011                	j	80000c3c <copyin+0x72>
  return 0;
    80000c3a:	4501                	li	a0,0
}
    80000c3c:	60a6                	ld	ra,72(sp)
    80000c3e:	6406                	ld	s0,64(sp)
    80000c40:	74e2                	ld	s1,56(sp)
    80000c42:	7942                	ld	s2,48(sp)
    80000c44:	79a2                	ld	s3,40(sp)
    80000c46:	7a02                	ld	s4,32(sp)
    80000c48:	6ae2                	ld	s5,24(sp)
    80000c4a:	6b42                	ld	s6,16(sp)
    80000c4c:	6ba2                	ld	s7,8(sp)
    80000c4e:	6c02                	ld	s8,0(sp)
    80000c50:	6161                	addi	sp,sp,80
    80000c52:	8082                	ret
  return 0;
    80000c54:	4501                	li	a0,0
}
    80000c56:	8082                	ret

0000000080000c58 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c58:	715d                	addi	sp,sp,-80
    80000c5a:	e486                	sd	ra,72(sp)
    80000c5c:	e0a2                	sd	s0,64(sp)
    80000c5e:	fc26                	sd	s1,56(sp)
    80000c60:	f84a                	sd	s2,48(sp)
    80000c62:	f44e                	sd	s3,40(sp)
    80000c64:	f052                	sd	s4,32(sp)
    80000c66:	ec56                	sd	s5,24(sp)
    80000c68:	e85a                	sd	s6,16(sp)
    80000c6a:	e45e                	sd	s7,8(sp)
    80000c6c:	e062                	sd	s8,0(sp)
    80000c6e:	0880                	addi	s0,sp,80
    80000c70:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c72:	00008497          	auipc	s1,0x8
    80000c76:	26e48493          	addi	s1,s1,622 # 80008ee0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c7a:	8c26                	mv	s8,s1
    80000c7c:	ff048937          	lui	s2,0xff048
    80000c80:	dc190913          	addi	s2,s2,-575 # ffffffffff047dc1 <end+0xffffffff7d6745d9>
    80000c84:	0932                	slli	s2,s2,0xc
    80000c86:	1f790913          	addi	s2,s2,503
    80000c8a:	093e                	slli	s2,s2,0xf
    80000c8c:	23f90913          	addi	s2,s2,575
    80000c90:	0932                	slli	s2,s2,0xc
    80000c92:	e0990913          	addi	s2,s2,-503
    80000c96:	010009b7          	lui	s3,0x1000
    80000c9a:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000c9c:	09ba                	slli	s3,s3,0xe
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c9e:	4b99                	li	s7,6
    80000ca0:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ca2:	0000fa97          	auipc	s5,0xf
    80000ca6:	43ea8a93          	addi	s5,s5,1086 # 800100e0 <tickslock>
    char *pa = kalloc();
    80000caa:	c5aff0ef          	jal	80000104 <kalloc>
    80000cae:	862a                	mv	a2,a0
    if(pa == 0)
    80000cb0:	cd1d                	beqz	a0,80000cee <proc_mapstacks+0x96>
    uint64 va = KSTACK((int) (p - proc));
    80000cb2:	418485b3          	sub	a1,s1,s8
    80000cb6:	858d                	srai	a1,a1,0x3
    80000cb8:	032585b3          	mul	a1,a1,s2
    80000cbc:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000cc0:	875e                	mv	a4,s7
    80000cc2:	86da                	mv	a3,s6
    80000cc4:	40b985b3          	sub	a1,s3,a1
    80000cc8:	8552                	mv	a0,s4
    80000cca:	8bfff0ef          	jal	80000588 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cce:	1c848493          	addi	s1,s1,456
    80000cd2:	fd549ce3          	bne	s1,s5,80000caa <proc_mapstacks+0x52>
  }
}
    80000cd6:	60a6                	ld	ra,72(sp)
    80000cd8:	6406                	ld	s0,64(sp)
    80000cda:	74e2                	ld	s1,56(sp)
    80000cdc:	7942                	ld	s2,48(sp)
    80000cde:	79a2                	ld	s3,40(sp)
    80000ce0:	7a02                	ld	s4,32(sp)
    80000ce2:	6ae2                	ld	s5,24(sp)
    80000ce4:	6b42                	ld	s6,16(sp)
    80000ce6:	6ba2                	ld	s7,8(sp)
    80000ce8:	6c02                	ld	s8,0(sp)
    80000cea:	6161                	addi	sp,sp,80
    80000cec:	8082                	ret
      panic("kalloc");
    80000cee:	00007517          	auipc	a0,0x7
    80000cf2:	42250513          	addi	a0,a0,1058 # 80008110 <etext+0x110>
    80000cf6:	692050ef          	jal	80006388 <panic>

0000000080000cfa <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cfa:	715d                	addi	sp,sp,-80
    80000cfc:	e486                	sd	ra,72(sp)
    80000cfe:	e0a2                	sd	s0,64(sp)
    80000d00:	fc26                	sd	s1,56(sp)
    80000d02:	f84a                	sd	s2,48(sp)
    80000d04:	f44e                	sd	s3,40(sp)
    80000d06:	f052                	sd	s4,32(sp)
    80000d08:	ec56                	sd	s5,24(sp)
    80000d0a:	e85a                	sd	s6,16(sp)
    80000d0c:	e45e                	sd	s7,8(sp)
    80000d0e:	e062                	sd	s8,0(sp)
    80000d10:	0880                	addi	s0,sp,80
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d12:	00007597          	auipc	a1,0x7
    80000d16:	40658593          	addi	a1,a1,1030 # 80008118 <etext+0x118>
    80000d1a:	00008517          	auipc	a0,0x8
    80000d1e:	d9650513          	addi	a0,a0,-618 # 80008ab0 <pid_lock>
    80000d22:	09f050ef          	jal	800065c0 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d26:	00007597          	auipc	a1,0x7
    80000d2a:	3fa58593          	addi	a1,a1,1018 # 80008120 <etext+0x120>
    80000d2e:	00008517          	auipc	a0,0x8
    80000d32:	d9a50513          	addi	a0,a0,-614 # 80008ac8 <wait_lock>
    80000d36:	08b050ef          	jal	800065c0 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d3a:	00008497          	auipc	s1,0x8
    80000d3e:	36e48493          	addi	s1,s1,878 # 800090a8 <proc+0x1c8>
    80000d42:	00008997          	auipc	s3,0x8
    80000d46:	19e98993          	addi	s3,s3,414 # 80008ee0 <proc>
      initlock(&p->lock, "proc");
    80000d4a:	00007c17          	auipc	s8,0x7
    80000d4e:	3e6c0c13          	addi	s8,s8,998 # 80008130 <etext+0x130>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d52:	8bce                	mv	s7,s3
    80000d54:	ff048a37          	lui	s4,0xff048
    80000d58:	dc1a0a13          	addi	s4,s4,-575 # ffffffffff047dc1 <end+0xffffffff7d6745d9>
    80000d5c:	0a32                	slli	s4,s4,0xc
    80000d5e:	1f7a0a13          	addi	s4,s4,503
    80000d62:	0a3e                	slli	s4,s4,0xf
    80000d64:	23fa0a13          	addi	s4,s4,575
    80000d68:	0a32                	slli	s4,s4,0xc
    80000d6a:	e09a0a13          	addi	s4,s4,-503
    80000d6e:	01000ab7          	lui	s5,0x1000
    80000d72:	1afd                	addi	s5,s5,-1 # ffffff <_entry-0x7f000001>
    80000d74:	0aba                	slli	s5,s5,0xe
      for (int i =0; i < MAXBPORTS; i++) {
        p->bindedports[i] = -1;
    80000d76:	597d                	li	s2,-1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d78:	0000fb17          	auipc	s6,0xf
    80000d7c:	368b0b13          	addi	s6,s6,872 # 800100e0 <tickslock>
      initlock(&p->lock, "proc");
    80000d80:	85e2                	mv	a1,s8
    80000d82:	854e                	mv	a0,s3
    80000d84:	03d050ef          	jal	800065c0 <initlock>
      p->state = UNUSED;
    80000d88:	0009ac23          	sw	zero,24(s3)
      p->kstack = KSTACK((int) (p - proc));
    80000d8c:	417987b3          	sub	a5,s3,s7
    80000d90:	878d                	srai	a5,a5,0x3
    80000d92:	034787b3          	mul	a5,a5,s4
    80000d96:	00d7979b          	slliw	a5,a5,0xd
    80000d9a:	40fa87b3          	sub	a5,s5,a5
    80000d9e:	04f9b023          	sd	a5,64(s3)
      for (int i =0; i < MAXBPORTS; i++) {
    80000da2:	16898793          	addi	a5,s3,360
        p->bindedports[i] = -1;
    80000da6:	0127a023          	sw	s2,0(a5) # fffffffffffff000 <end+0xffffffff7e62b818>
      for (int i =0; i < MAXBPORTS; i++) {
    80000daa:	0791                	addi	a5,a5,4
    80000dac:	fe979de3          	bne	a5,s1,80000da6 <procinit+0xac>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000db0:	1c898993          	addi	s3,s3,456
    80000db4:	1c848493          	addi	s1,s1,456
    80000db8:	fd6994e3          	bne	s3,s6,80000d80 <procinit+0x86>
      }
  }
}
    80000dbc:	60a6                	ld	ra,72(sp)
    80000dbe:	6406                	ld	s0,64(sp)
    80000dc0:	74e2                	ld	s1,56(sp)
    80000dc2:	7942                	ld	s2,48(sp)
    80000dc4:	79a2                	ld	s3,40(sp)
    80000dc6:	7a02                	ld	s4,32(sp)
    80000dc8:	6ae2                	ld	s5,24(sp)
    80000dca:	6b42                	ld	s6,16(sp)
    80000dcc:	6ba2                	ld	s7,8(sp)
    80000dce:	6c02                	ld	s8,0(sp)
    80000dd0:	6161                	addi	sp,sp,80
    80000dd2:	8082                	ret

0000000080000dd4 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000dd4:	1141                	addi	sp,sp,-16
    80000dd6:	e406                	sd	ra,8(sp)
    80000dd8:	e022                	sd	s0,0(sp)
    80000dda:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000ddc:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000dde:	2501                	sext.w	a0,a0
    80000de0:	60a2                	ld	ra,8(sp)
    80000de2:	6402                	ld	s0,0(sp)
    80000de4:	0141                	addi	sp,sp,16
    80000de6:	8082                	ret

0000000080000de8 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000de8:	1141                	addi	sp,sp,-16
    80000dea:	e406                	sd	ra,8(sp)
    80000dec:	e022                	sd	s0,0(sp)
    80000dee:	0800                	addi	s0,sp,16
    80000df0:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000df2:	2781                	sext.w	a5,a5
    80000df4:	079e                	slli	a5,a5,0x7
  return c;
}
    80000df6:	00008517          	auipc	a0,0x8
    80000dfa:	cea50513          	addi	a0,a0,-790 # 80008ae0 <cpus>
    80000dfe:	953e                	add	a0,a0,a5
    80000e00:	60a2                	ld	ra,8(sp)
    80000e02:	6402                	ld	s0,0(sp)
    80000e04:	0141                	addi	sp,sp,16
    80000e06:	8082                	ret

0000000080000e08 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000e08:	1101                	addi	sp,sp,-32
    80000e0a:	ec06                	sd	ra,24(sp)
    80000e0c:	e822                	sd	s0,16(sp)
    80000e0e:	e426                	sd	s1,8(sp)
    80000e10:	1000                	addi	s0,sp,32
  push_off();
    80000e12:	7f4050ef          	jal	80006606 <push_off>
    80000e16:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000e18:	2781                	sext.w	a5,a5
    80000e1a:	079e                	slli	a5,a5,0x7
    80000e1c:	00008717          	auipc	a4,0x8
    80000e20:	c9470713          	addi	a4,a4,-876 # 80008ab0 <pid_lock>
    80000e24:	97ba                	add	a5,a5,a4
    80000e26:	7b9c                	ld	a5,48(a5)
    80000e28:	84be                	mv	s1,a5
  pop_off();
    80000e2a:	065050ef          	jal	8000668e <pop_off>
  return p;
}
    80000e2e:	8526                	mv	a0,s1
    80000e30:	60e2                	ld	ra,24(sp)
    80000e32:	6442                	ld	s0,16(sp)
    80000e34:	64a2                	ld	s1,8(sp)
    80000e36:	6105                	addi	sp,sp,32
    80000e38:	8082                	ret

0000000080000e3a <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e3a:	7179                	addi	sp,sp,-48
    80000e3c:	f406                	sd	ra,40(sp)
    80000e3e:	f022                	sd	s0,32(sp)
    80000e40:	ec26                	sd	s1,24(sp)
    80000e42:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000e44:	fc5ff0ef          	jal	80000e08 <myproc>
    80000e48:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000e4a:	095050ef          	jal	800066de <release>

  if (first) {
    80000e4e:	00008797          	auipc	a5,0x8
    80000e52:	be27a783          	lw	a5,-1054(a5) # 80008a30 <first.1>
    80000e56:	cf95                	beqz	a5,80000e92 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000e58:	4505                	li	a0,1
    80000e5a:	3a3010ef          	jal	800029fc <fsinit>

    first = 0;
    80000e5e:	00008797          	auipc	a5,0x8
    80000e62:	bc07a923          	sw	zero,-1070(a5) # 80008a30 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000e66:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000e6a:	00007797          	auipc	a5,0x7
    80000e6e:	2ce78793          	addi	a5,a5,718 # 80008138 <etext+0x138>
    80000e72:	fcf43823          	sd	a5,-48(s0)
    80000e76:	fc043c23          	sd	zero,-40(s0)
    80000e7a:	fd040593          	addi	a1,s0,-48
    80000e7e:	853e                	mv	a0,a5
    80000e80:	4fb020ef          	jal	80003b7a <kexec>
    80000e84:	6cbc                	ld	a5,88(s1)
    80000e86:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000e88:	6cbc                	ld	a5,88(s1)
    80000e8a:	7bb8                	ld	a4,112(a5)
    80000e8c:	57fd                	li	a5,-1
    80000e8e:	02f70d63          	beq	a4,a5,80000ec8 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e92:	2db000ef          	jal	8000196c <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e96:	68a8                	ld	a0,80(s1)
    80000e98:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e9a:	04000737          	lui	a4,0x4000
    80000e9e:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000ea0:	0732                	slli	a4,a4,0xc
    80000ea2:	00006797          	auipc	a5,0x6
    80000ea6:	1fa78793          	addi	a5,a5,506 # 8000709c <userret>
    80000eaa:	00006697          	auipc	a3,0x6
    80000eae:	15668693          	addi	a3,a3,342 # 80007000 <_trampoline>
    80000eb2:	8f95                	sub	a5,a5,a3
    80000eb4:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000eb6:	577d                	li	a4,-1
    80000eb8:	177e                	slli	a4,a4,0x3f
    80000eba:	8d59                	or	a0,a0,a4
    80000ebc:	9782                	jalr	a5
}
    80000ebe:	70a2                	ld	ra,40(sp)
    80000ec0:	7402                	ld	s0,32(sp)
    80000ec2:	64e2                	ld	s1,24(sp)
    80000ec4:	6145                	addi	sp,sp,48
    80000ec6:	8082                	ret
      panic("exec");
    80000ec8:	00007517          	auipc	a0,0x7
    80000ecc:	27850513          	addi	a0,a0,632 # 80008140 <etext+0x140>
    80000ed0:	4b8050ef          	jal	80006388 <panic>

0000000080000ed4 <allocpid>:
{
    80000ed4:	1101                	addi	sp,sp,-32
    80000ed6:	ec06                	sd	ra,24(sp)
    80000ed8:	e822                	sd	s0,16(sp)
    80000eda:	e426                	sd	s1,8(sp)
    80000edc:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000ede:	00008517          	auipc	a0,0x8
    80000ee2:	bd250513          	addi	a0,a0,-1070 # 80008ab0 <pid_lock>
    80000ee6:	764050ef          	jal	8000664a <acquire>
  pid = nextpid;
    80000eea:	00008797          	auipc	a5,0x8
    80000eee:	b4a78793          	addi	a5,a5,-1206 # 80008a34 <nextpid>
    80000ef2:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ef4:	0014871b          	addiw	a4,s1,1
    80000ef8:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000efa:	00008517          	auipc	a0,0x8
    80000efe:	bb650513          	addi	a0,a0,-1098 # 80008ab0 <pid_lock>
    80000f02:	7dc050ef          	jal	800066de <release>
}
    80000f06:	8526                	mv	a0,s1
    80000f08:	60e2                	ld	ra,24(sp)
    80000f0a:	6442                	ld	s0,16(sp)
    80000f0c:	64a2                	ld	s1,8(sp)
    80000f0e:	6105                	addi	sp,sp,32
    80000f10:	8082                	ret

0000000080000f12 <proc_pagetable>:
{
    80000f12:	1101                	addi	sp,sp,-32
    80000f14:	ec06                	sd	ra,24(sp)
    80000f16:	e822                	sd	s0,16(sp)
    80000f18:	e426                	sd	s1,8(sp)
    80000f1a:	e04a                	sd	s2,0(sp)
    80000f1c:	1000                	addi	s0,sp,32
    80000f1e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000f20:	f7eff0ef          	jal	8000069e <uvmcreate>
    80000f24:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f26:	cd05                	beqz	a0,80000f5e <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f28:	4729                	li	a4,10
    80000f2a:	00006697          	auipc	a3,0x6
    80000f2e:	0d668693          	addi	a3,a3,214 # 80007000 <_trampoline>
    80000f32:	6605                	lui	a2,0x1
    80000f34:	040005b7          	lui	a1,0x4000
    80000f38:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f3a:	05b2                	slli	a1,a1,0xc
    80000f3c:	d96ff0ef          	jal	800004d2 <mappages>
    80000f40:	02054663          	bltz	a0,80000f6c <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f44:	4719                	li	a4,6
    80000f46:	05893683          	ld	a3,88(s2)
    80000f4a:	6605                	lui	a2,0x1
    80000f4c:	020005b7          	lui	a1,0x2000
    80000f50:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f52:	05b6                	slli	a1,a1,0xd
    80000f54:	8526                	mv	a0,s1
    80000f56:	d7cff0ef          	jal	800004d2 <mappages>
    80000f5a:	00054f63          	bltz	a0,80000f78 <proc_pagetable+0x66>
}
    80000f5e:	8526                	mv	a0,s1
    80000f60:	60e2                	ld	ra,24(sp)
    80000f62:	6442                	ld	s0,16(sp)
    80000f64:	64a2                	ld	s1,8(sp)
    80000f66:	6902                	ld	s2,0(sp)
    80000f68:	6105                	addi	sp,sp,32
    80000f6a:	8082                	ret
    uvmfree(pagetable, 0);
    80000f6c:	4581                	li	a1,0
    80000f6e:	8526                	mv	a0,s1
    80000f70:	945ff0ef          	jal	800008b4 <uvmfree>
    return 0;
    80000f74:	4481                	li	s1,0
    80000f76:	b7e5                	j	80000f5e <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f78:	4681                	li	a3,0
    80000f7a:	4605                	li	a2,1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	8526                	mv	a0,s1
    80000f86:	f3eff0ef          	jal	800006c4 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f8a:	4581                	li	a1,0
    80000f8c:	8526                	mv	a0,s1
    80000f8e:	927ff0ef          	jal	800008b4 <uvmfree>
    return 0;
    80000f92:	4481                	li	s1,0
    80000f94:	b7e9                	j	80000f5e <proc_pagetable+0x4c>

0000000080000f96 <proc_freepagetable>:
{
    80000f96:	1101                	addi	sp,sp,-32
    80000f98:	ec06                	sd	ra,24(sp)
    80000f9a:	e822                	sd	s0,16(sp)
    80000f9c:	e426                	sd	s1,8(sp)
    80000f9e:	e04a                	sd	s2,0(sp)
    80000fa0:	1000                	addi	s0,sp,32
    80000fa2:	84aa                	mv	s1,a0
    80000fa4:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fa6:	4681                	li	a3,0
    80000fa8:	4605                	li	a2,1
    80000faa:	040005b7          	lui	a1,0x4000
    80000fae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb0:	05b2                	slli	a1,a1,0xc
    80000fb2:	f12ff0ef          	jal	800006c4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fb6:	4681                	li	a3,0
    80000fb8:	4605                	li	a2,1
    80000fba:	020005b7          	lui	a1,0x2000
    80000fbe:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fc0:	05b6                	slli	a1,a1,0xd
    80000fc2:	8526                	mv	a0,s1
    80000fc4:	f00ff0ef          	jal	800006c4 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fc8:	85ca                	mv	a1,s2
    80000fca:	8526                	mv	a0,s1
    80000fcc:	8e9ff0ef          	jal	800008b4 <uvmfree>
}
    80000fd0:	60e2                	ld	ra,24(sp)
    80000fd2:	6442                	ld	s0,16(sp)
    80000fd4:	64a2                	ld	s1,8(sp)
    80000fd6:	6902                	ld	s2,0(sp)
    80000fd8:	6105                	addi	sp,sp,32
    80000fda:	8082                	ret

0000000080000fdc <freeproc>:
{
    80000fdc:	1101                	addi	sp,sp,-32
    80000fde:	ec06                	sd	ra,24(sp)
    80000fe0:	e822                	sd	s0,16(sp)
    80000fe2:	e426                	sd	s1,8(sp)
    80000fe4:	1000                	addi	s0,sp,32
    80000fe6:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fe8:	6d28                	ld	a0,88(a0)
    80000fea:	c119                	beqz	a0,80000ff0 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000fec:	830ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000ff0:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000ff4:	68a8                	ld	a0,80(s1)
    80000ff6:	c501                	beqz	a0,80000ffe <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000ff8:	64ac                	ld	a1,72(s1)
    80000ffa:	f9dff0ef          	jal	80000f96 <proc_freepagetable>
  p->pagetable = 0;
    80000ffe:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001002:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001006:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000100a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000100e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001012:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80001016:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000101a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    8000101e:	0004ac23          	sw	zero,24(s1)
  for (int i =0; i < MAXBPORTS; i++) {
    80001022:	16848793          	addi	a5,s1,360
    80001026:	1c848713          	addi	a4,s1,456
    p->bindedports[i] = -1;
    8000102a:	56fd                	li	a3,-1
    8000102c:	c394                	sw	a3,0(a5)
  for (int i =0; i < MAXBPORTS; i++) {
    8000102e:	0791                	addi	a5,a5,4
    80001030:	fee79ee3          	bne	a5,a4,8000102c <freeproc+0x50>
}
    80001034:	60e2                	ld	ra,24(sp)
    80001036:	6442                	ld	s0,16(sp)
    80001038:	64a2                	ld	s1,8(sp)
    8000103a:	6105                	addi	sp,sp,32
    8000103c:	8082                	ret

000000008000103e <allocproc>:
{
    8000103e:	1101                	addi	sp,sp,-32
    80001040:	ec06                	sd	ra,24(sp)
    80001042:	e822                	sd	s0,16(sp)
    80001044:	e426                	sd	s1,8(sp)
    80001046:	e04a                	sd	s2,0(sp)
    80001048:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000104a:	00008497          	auipc	s1,0x8
    8000104e:	e9648493          	addi	s1,s1,-362 # 80008ee0 <proc>
    80001052:	0000f917          	auipc	s2,0xf
    80001056:	08e90913          	addi	s2,s2,142 # 800100e0 <tickslock>
    acquire(&p->lock);
    8000105a:	8526                	mv	a0,s1
    8000105c:	5ee050ef          	jal	8000664a <acquire>
    if(p->state == UNUSED) {
    80001060:	4c9c                	lw	a5,24(s1)
    80001062:	cb91                	beqz	a5,80001076 <allocproc+0x38>
      release(&p->lock);
    80001064:	8526                	mv	a0,s1
    80001066:	678050ef          	jal	800066de <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000106a:	1c848493          	addi	s1,s1,456
    8000106e:	ff2496e3          	bne	s1,s2,8000105a <allocproc+0x1c>
  return 0;
    80001072:	4481                	li	s1,0
    80001074:	a089                	j	800010b6 <allocproc+0x78>
  p->pid = allocpid();
    80001076:	e5fff0ef          	jal	80000ed4 <allocpid>
    8000107a:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000107c:	4785                	li	a5,1
    8000107e:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001080:	884ff0ef          	jal	80000104 <kalloc>
    80001084:	892a                	mv	s2,a0
    80001086:	eca8                	sd	a0,88(s1)
    80001088:	cd15                	beqz	a0,800010c4 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    8000108a:	8526                	mv	a0,s1
    8000108c:	e87ff0ef          	jal	80000f12 <proc_pagetable>
    80001090:	892a                	mv	s2,a0
    80001092:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001094:	c121                	beqz	a0,800010d4 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001096:	07000613          	li	a2,112
    8000109a:	4581                	li	a1,0
    8000109c:	06048513          	addi	a0,s1,96
    800010a0:	8beff0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    800010a4:	00000797          	auipc	a5,0x0
    800010a8:	d9678793          	addi	a5,a5,-618 # 80000e3a <forkret>
    800010ac:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010ae:	60bc                	ld	a5,64(s1)
    800010b0:	6705                	lui	a4,0x1
    800010b2:	97ba                	add	a5,a5,a4
    800010b4:	f4bc                	sd	a5,104(s1)
}
    800010b6:	8526                	mv	a0,s1
    800010b8:	60e2                	ld	ra,24(sp)
    800010ba:	6442                	ld	s0,16(sp)
    800010bc:	64a2                	ld	s1,8(sp)
    800010be:	6902                	ld	s2,0(sp)
    800010c0:	6105                	addi	sp,sp,32
    800010c2:	8082                	ret
    freeproc(p);
    800010c4:	8526                	mv	a0,s1
    800010c6:	f17ff0ef          	jal	80000fdc <freeproc>
    release(&p->lock);
    800010ca:	8526                	mv	a0,s1
    800010cc:	612050ef          	jal	800066de <release>
    return 0;
    800010d0:	84ca                	mv	s1,s2
    800010d2:	b7d5                	j	800010b6 <allocproc+0x78>
    freeproc(p);
    800010d4:	8526                	mv	a0,s1
    800010d6:	f07ff0ef          	jal	80000fdc <freeproc>
    release(&p->lock);
    800010da:	8526                	mv	a0,s1
    800010dc:	602050ef          	jal	800066de <release>
    return 0;
    800010e0:	84ca                	mv	s1,s2
    800010e2:	bfd1                	j	800010b6 <allocproc+0x78>

00000000800010e4 <userinit>:
{
    800010e4:	1101                	addi	sp,sp,-32
    800010e6:	ec06                	sd	ra,24(sp)
    800010e8:	e822                	sd	s0,16(sp)
    800010ea:	e426                	sd	s1,8(sp)
    800010ec:	1000                	addi	s0,sp,32
  p = allocproc();
    800010ee:	f51ff0ef          	jal	8000103e <allocproc>
    800010f2:	84aa                	mv	s1,a0
  initproc = p;
    800010f4:	00008797          	auipc	a5,0x8
    800010f8:	96a7b623          	sd	a0,-1684(a5) # 80008a60 <initproc>
  p->cwd = namei("/");
    800010fc:	00007517          	auipc	a0,0x7
    80001100:	04c50513          	addi	a0,a0,76 # 80008148 <etext+0x148>
    80001104:	633010ef          	jal	80002f36 <namei>
    80001108:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    8000110c:	478d                	li	a5,3
    8000110e:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001110:	8526                	mv	a0,s1
    80001112:	5cc050ef          	jal	800066de <release>
}
    80001116:	60e2                	ld	ra,24(sp)
    80001118:	6442                	ld	s0,16(sp)
    8000111a:	64a2                	ld	s1,8(sp)
    8000111c:	6105                	addi	sp,sp,32
    8000111e:	8082                	ret

0000000080001120 <growproc>:
{
    80001120:	1101                	addi	sp,sp,-32
    80001122:	ec06                	sd	ra,24(sp)
    80001124:	e822                	sd	s0,16(sp)
    80001126:	e426                	sd	s1,8(sp)
    80001128:	e04a                	sd	s2,0(sp)
    8000112a:	1000                	addi	s0,sp,32
    8000112c:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000112e:	cdbff0ef          	jal	80000e08 <myproc>
    80001132:	84aa                	mv	s1,a0
  sz = p->sz;
    80001134:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001136:	01204c63          	bgtz	s2,8000114e <growproc+0x2e>
  } else if(n < 0){
    8000113a:	02094463          	bltz	s2,80001162 <growproc+0x42>
  p->sz = sz;
    8000113e:	e4ac                	sd	a1,72(s1)
  return 0;
    80001140:	4501                	li	a0,0
}
    80001142:	60e2                	ld	ra,24(sp)
    80001144:	6442                	ld	s0,16(sp)
    80001146:	64a2                	ld	s1,8(sp)
    80001148:	6902                	ld	s2,0(sp)
    8000114a:	6105                	addi	sp,sp,32
    8000114c:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000114e:	4691                	li	a3,4
    80001150:	00b90633          	add	a2,s2,a1
    80001154:	6928                	ld	a0,80(a0)
    80001156:	e58ff0ef          	jal	800007ae <uvmalloc>
    8000115a:	85aa                	mv	a1,a0
    8000115c:	f16d                	bnez	a0,8000113e <growproc+0x1e>
      return -1;
    8000115e:	557d                	li	a0,-1
    80001160:	b7cd                	j	80001142 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001162:	00b90633          	add	a2,s2,a1
    80001166:	6928                	ld	a0,80(a0)
    80001168:	e02ff0ef          	jal	8000076a <uvmdealloc>
    8000116c:	85aa                	mv	a1,a0
    8000116e:	bfc1                	j	8000113e <growproc+0x1e>

0000000080001170 <kfork>:
{
    80001170:	7139                	addi	sp,sp,-64
    80001172:	fc06                	sd	ra,56(sp)
    80001174:	f822                	sd	s0,48(sp)
    80001176:	f426                	sd	s1,40(sp)
    80001178:	e456                	sd	s5,8(sp)
    8000117a:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000117c:	c8dff0ef          	jal	80000e08 <myproc>
    80001180:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001182:	ebdff0ef          	jal	8000103e <allocproc>
    80001186:	10050663          	beqz	a0,80001292 <kfork+0x122>
    8000118a:	ec4e                	sd	s3,24(sp)
    8000118c:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000118e:	048ab603          	ld	a2,72(s5)
    80001192:	692c                	ld	a1,80(a0)
    80001194:	050ab503          	ld	a0,80(s5)
    80001198:	f4eff0ef          	jal	800008e6 <uvmcopy>
    8000119c:	06054463          	bltz	a0,80001204 <kfork+0x94>
    800011a0:	f04a                	sd	s2,32(sp)
    800011a2:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    800011a4:	048ab783          	ld	a5,72(s5)
    800011a8:	04f9b423          	sd	a5,72(s3)
  for (int i =0; i < MAXBPORTS; i++) {
    800011ac:	168a8793          	addi	a5,s5,360
    800011b0:	16898713          	addi	a4,s3,360
    800011b4:	1c8a8613          	addi	a2,s5,456
    np->bindedports[i] = p->bindedports[i];
    800011b8:	4394                	lw	a3,0(a5)
    800011ba:	c314                	sw	a3,0(a4)
  for (int i =0; i < MAXBPORTS; i++) {
    800011bc:	0791                	addi	a5,a5,4
    800011be:	0711                	addi	a4,a4,4 # 1004 <_entry-0x7fffeffc>
    800011c0:	fec79ce3          	bne	a5,a2,800011b8 <kfork+0x48>
  *(np->trapframe) = *(p->trapframe);
    800011c4:	058ab683          	ld	a3,88(s5)
    800011c8:	87b6                	mv	a5,a3
    800011ca:	0589b703          	ld	a4,88(s3)
    800011ce:	12068693          	addi	a3,a3,288
    800011d2:	6388                	ld	a0,0(a5)
    800011d4:	678c                	ld	a1,8(a5)
    800011d6:	6b90                	ld	a2,16(a5)
    800011d8:	e308                	sd	a0,0(a4)
    800011da:	e70c                	sd	a1,8(a4)
    800011dc:	eb10                	sd	a2,16(a4)
    800011de:	6f90                	ld	a2,24(a5)
    800011e0:	ef10                	sd	a2,24(a4)
    800011e2:	02078793          	addi	a5,a5,32
    800011e6:	02070713          	addi	a4,a4,32
    800011ea:	fed794e3          	bne	a5,a3,800011d2 <kfork+0x62>
  np->trapframe->a0 = 0;
    800011ee:	0589b783          	ld	a5,88(s3)
    800011f2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800011f6:	0d0a8493          	addi	s1,s5,208
    800011fa:	0d098913          	addi	s2,s3,208
    800011fe:	150a8a13          	addi	s4,s5,336
    80001202:	a015                	j	80001226 <kfork+0xb6>
    freeproc(np);
    80001204:	854e                	mv	a0,s3
    80001206:	dd7ff0ef          	jal	80000fdc <freeproc>
    release(&np->lock);
    8000120a:	854e                	mv	a0,s3
    8000120c:	4d2050ef          	jal	800066de <release>
    return -1;
    80001210:	54fd                	li	s1,-1
    80001212:	69e2                	ld	s3,24(sp)
    80001214:	a885                	j	80001284 <kfork+0x114>
      np->ofile[i] = filedup(p->ofile[i]);
    80001216:	2dc020ef          	jal	800034f2 <filedup>
    8000121a:	00a93023          	sd	a0,0(s2)
  for(i = 0; i < NOFILE; i++)
    8000121e:	04a1                	addi	s1,s1,8
    80001220:	0921                	addi	s2,s2,8
    80001222:	01448563          	beq	s1,s4,8000122c <kfork+0xbc>
    if(p->ofile[i])
    80001226:	6088                	ld	a0,0(s1)
    80001228:	f57d                	bnez	a0,80001216 <kfork+0xa6>
    8000122a:	bfd5                	j	8000121e <kfork+0xae>
  np->cwd = idup(p->cwd);
    8000122c:	150ab503          	ld	a0,336(s5)
    80001230:	4a2010ef          	jal	800026d2 <idup>
    80001234:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001238:	4641                	li	a2,16
    8000123a:	158a8593          	addi	a1,s5,344
    8000123e:	15898513          	addi	a0,s3,344
    80001242:	870ff0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    80001246:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    8000124a:	854e                	mv	a0,s3
    8000124c:	492050ef          	jal	800066de <release>
  acquire(&wait_lock);
    80001250:	00008517          	auipc	a0,0x8
    80001254:	87850513          	addi	a0,a0,-1928 # 80008ac8 <wait_lock>
    80001258:	3f2050ef          	jal	8000664a <acquire>
  np->parent = p;
    8000125c:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    80001260:	00008517          	auipc	a0,0x8
    80001264:	86850513          	addi	a0,a0,-1944 # 80008ac8 <wait_lock>
    80001268:	476050ef          	jal	800066de <release>
  acquire(&np->lock);
    8000126c:	854e                	mv	a0,s3
    8000126e:	3dc050ef          	jal	8000664a <acquire>
  np->state = RUNNABLE;
    80001272:	478d                	li	a5,3
    80001274:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001278:	854e                	mv	a0,s3
    8000127a:	464050ef          	jal	800066de <release>
  return pid;
    8000127e:	7902                	ld	s2,32(sp)
    80001280:	69e2                	ld	s3,24(sp)
    80001282:	6a42                	ld	s4,16(sp)
}
    80001284:	8526                	mv	a0,s1
    80001286:	70e2                	ld	ra,56(sp)
    80001288:	7442                	ld	s0,48(sp)
    8000128a:	74a2                	ld	s1,40(sp)
    8000128c:	6aa2                	ld	s5,8(sp)
    8000128e:	6121                	addi	sp,sp,64
    80001290:	8082                	ret
    return -1;
    80001292:	54fd                	li	s1,-1
    80001294:	bfc5                	j	80001284 <kfork+0x114>

0000000080001296 <scheduler>:
{
    80001296:	715d                	addi	sp,sp,-80
    80001298:	e486                	sd	ra,72(sp)
    8000129a:	e0a2                	sd	s0,64(sp)
    8000129c:	fc26                	sd	s1,56(sp)
    8000129e:	f84a                	sd	s2,48(sp)
    800012a0:	f44e                	sd	s3,40(sp)
    800012a2:	f052                	sd	s4,32(sp)
    800012a4:	ec56                	sd	s5,24(sp)
    800012a6:	e85a                	sd	s6,16(sp)
    800012a8:	e45e                	sd	s7,8(sp)
    800012aa:	e062                	sd	s8,0(sp)
    800012ac:	0880                	addi	s0,sp,80
    800012ae:	8792                	mv	a5,tp
  int id = r_tp();
    800012b0:	2781                	sext.w	a5,a5
  c->proc = 0;
    800012b2:	00779b13          	slli	s6,a5,0x7
    800012b6:	00007717          	auipc	a4,0x7
    800012ba:	7fa70713          	addi	a4,a4,2042 # 80008ab0 <pid_lock>
    800012be:	975a                	add	a4,a4,s6
    800012c0:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800012c4:	00008717          	auipc	a4,0x8
    800012c8:	82470713          	addi	a4,a4,-2012 # 80008ae8 <cpus+0x8>
    800012cc:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800012ce:	4c11                	li	s8,4
        c->proc = p;
    800012d0:	079e                	slli	a5,a5,0x7
    800012d2:	00007a17          	auipc	s4,0x7
    800012d6:	7dea0a13          	addi	s4,s4,2014 # 80008ab0 <pid_lock>
    800012da:	9a3e                	add	s4,s4,a5
        found = 1;
    800012dc:	4b85                	li	s7,1
    800012de:	a83d                	j	8000131c <scheduler+0x86>
      release(&p->lock);
    800012e0:	8526                	mv	a0,s1
    800012e2:	3fc050ef          	jal	800066de <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800012e6:	1c848493          	addi	s1,s1,456
    800012ea:	03248563          	beq	s1,s2,80001314 <scheduler+0x7e>
      acquire(&p->lock);
    800012ee:	8526                	mv	a0,s1
    800012f0:	35a050ef          	jal	8000664a <acquire>
      if(p->state == RUNNABLE) {
    800012f4:	4c9c                	lw	a5,24(s1)
    800012f6:	ff3795e3          	bne	a5,s3,800012e0 <scheduler+0x4a>
        p->state = RUNNING;
    800012fa:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800012fe:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001302:	06048593          	addi	a1,s1,96
    80001306:	855a                	mv	a0,s6
    80001308:	5ba000ef          	jal	800018c2 <swtch>
        c->proc = 0;
    8000130c:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001310:	8ade                	mv	s5,s7
    80001312:	b7f9                	j	800012e0 <scheduler+0x4a>
    if(found == 0) {
    80001314:	000a9463          	bnez	s5,8000131c <scheduler+0x86>
      asm volatile("wfi");
    80001318:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000131c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001320:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001324:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001328:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000132c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000132e:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001332:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001334:	00008497          	auipc	s1,0x8
    80001338:	bac48493          	addi	s1,s1,-1108 # 80008ee0 <proc>
      if(p->state == RUNNABLE) {
    8000133c:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000133e:	0000f917          	auipc	s2,0xf
    80001342:	da290913          	addi	s2,s2,-606 # 800100e0 <tickslock>
    80001346:	b765                	j	800012ee <scheduler+0x58>

0000000080001348 <sched>:
{
    80001348:	7179                	addi	sp,sp,-48
    8000134a:	f406                	sd	ra,40(sp)
    8000134c:	f022                	sd	s0,32(sp)
    8000134e:	ec26                	sd	s1,24(sp)
    80001350:	e84a                	sd	s2,16(sp)
    80001352:	e44e                	sd	s3,8(sp)
    80001354:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001356:	ab3ff0ef          	jal	80000e08 <myproc>
    8000135a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000135c:	27e050ef          	jal	800065da <holding>
    80001360:	c935                	beqz	a0,800013d4 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001362:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001364:	2781                	sext.w	a5,a5
    80001366:	079e                	slli	a5,a5,0x7
    80001368:	00007717          	auipc	a4,0x7
    8000136c:	74870713          	addi	a4,a4,1864 # 80008ab0 <pid_lock>
    80001370:	97ba                	add	a5,a5,a4
    80001372:	0a87a703          	lw	a4,168(a5)
    80001376:	4785                	li	a5,1
    80001378:	06f71463          	bne	a4,a5,800013e0 <sched+0x98>
  if(p->state == RUNNING)
    8000137c:	4c98                	lw	a4,24(s1)
    8000137e:	4791                	li	a5,4
    80001380:	06f70663          	beq	a4,a5,800013ec <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001384:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001388:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000138a:	e7bd                	bnez	a5,800013f8 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000138c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000138e:	00007917          	auipc	s2,0x7
    80001392:	72290913          	addi	s2,s2,1826 # 80008ab0 <pid_lock>
    80001396:	2781                	sext.w	a5,a5
    80001398:	079e                	slli	a5,a5,0x7
    8000139a:	97ca                	add	a5,a5,s2
    8000139c:	0ac7a983          	lw	s3,172(a5)
    800013a0:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800013a2:	2781                	sext.w	a5,a5
    800013a4:	079e                	slli	a5,a5,0x7
    800013a6:	07a1                	addi	a5,a5,8
    800013a8:	00007597          	auipc	a1,0x7
    800013ac:	73858593          	addi	a1,a1,1848 # 80008ae0 <cpus>
    800013b0:	95be                	add	a1,a1,a5
    800013b2:	06048513          	addi	a0,s1,96
    800013b6:	50c000ef          	jal	800018c2 <swtch>
    800013ba:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800013bc:	2781                	sext.w	a5,a5
    800013be:	079e                	slli	a5,a5,0x7
    800013c0:	993e                	add	s2,s2,a5
    800013c2:	0b392623          	sw	s3,172(s2)
}
    800013c6:	70a2                	ld	ra,40(sp)
    800013c8:	7402                	ld	s0,32(sp)
    800013ca:	64e2                	ld	s1,24(sp)
    800013cc:	6942                	ld	s2,16(sp)
    800013ce:	69a2                	ld	s3,8(sp)
    800013d0:	6145                	addi	sp,sp,48
    800013d2:	8082                	ret
    panic("sched p->lock");
    800013d4:	00007517          	auipc	a0,0x7
    800013d8:	d7c50513          	addi	a0,a0,-644 # 80008150 <etext+0x150>
    800013dc:	7ad040ef          	jal	80006388 <panic>
    panic("sched locks");
    800013e0:	00007517          	auipc	a0,0x7
    800013e4:	d8050513          	addi	a0,a0,-640 # 80008160 <etext+0x160>
    800013e8:	7a1040ef          	jal	80006388 <panic>
    panic("sched RUNNING");
    800013ec:	00007517          	auipc	a0,0x7
    800013f0:	d8450513          	addi	a0,a0,-636 # 80008170 <etext+0x170>
    800013f4:	795040ef          	jal	80006388 <panic>
    panic("sched interruptible");
    800013f8:	00007517          	auipc	a0,0x7
    800013fc:	d8850513          	addi	a0,a0,-632 # 80008180 <etext+0x180>
    80001400:	789040ef          	jal	80006388 <panic>

0000000080001404 <yield>:
{
    80001404:	1101                	addi	sp,sp,-32
    80001406:	ec06                	sd	ra,24(sp)
    80001408:	e822                	sd	s0,16(sp)
    8000140a:	e426                	sd	s1,8(sp)
    8000140c:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000140e:	9fbff0ef          	jal	80000e08 <myproc>
    80001412:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001414:	236050ef          	jal	8000664a <acquire>
  p->state = RUNNABLE;
    80001418:	478d                	li	a5,3
    8000141a:	cc9c                	sw	a5,24(s1)
  sched();
    8000141c:	f2dff0ef          	jal	80001348 <sched>
  release(&p->lock);
    80001420:	8526                	mv	a0,s1
    80001422:	2bc050ef          	jal	800066de <release>
}
    80001426:	60e2                	ld	ra,24(sp)
    80001428:	6442                	ld	s0,16(sp)
    8000142a:	64a2                	ld	s1,8(sp)
    8000142c:	6105                	addi	sp,sp,32
    8000142e:	8082                	ret

0000000080001430 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001430:	7179                	addi	sp,sp,-48
    80001432:	f406                	sd	ra,40(sp)
    80001434:	f022                	sd	s0,32(sp)
    80001436:	ec26                	sd	s1,24(sp)
    80001438:	e84a                	sd	s2,16(sp)
    8000143a:	e44e                	sd	s3,8(sp)
    8000143c:	1800                	addi	s0,sp,48
    8000143e:	89aa                	mv	s3,a0
    80001440:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001442:	9c7ff0ef          	jal	80000e08 <myproc>
    80001446:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001448:	202050ef          	jal	8000664a <acquire>
  release(lk);
    8000144c:	854a                	mv	a0,s2
    8000144e:	290050ef          	jal	800066de <release>

  // Go to sleep.
  p->chan = chan;
    80001452:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001456:	4789                	li	a5,2
    80001458:	cc9c                	sw	a5,24(s1)

  sched();
    8000145a:	eefff0ef          	jal	80001348 <sched>

  // Tidy up.
  p->chan = 0;
    8000145e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001462:	8526                	mv	a0,s1
    80001464:	27a050ef          	jal	800066de <release>
  acquire(lk);
    80001468:	854a                	mv	a0,s2
    8000146a:	1e0050ef          	jal	8000664a <acquire>
}
    8000146e:	70a2                	ld	ra,40(sp)
    80001470:	7402                	ld	s0,32(sp)
    80001472:	64e2                	ld	s1,24(sp)
    80001474:	6942                	ld	s2,16(sp)
    80001476:	69a2                	ld	s3,8(sp)
    80001478:	6145                	addi	sp,sp,48
    8000147a:	8082                	ret

000000008000147c <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    8000147c:	7139                	addi	sp,sp,-64
    8000147e:	fc06                	sd	ra,56(sp)
    80001480:	f822                	sd	s0,48(sp)
    80001482:	f426                	sd	s1,40(sp)
    80001484:	f04a                	sd	s2,32(sp)
    80001486:	ec4e                	sd	s3,24(sp)
    80001488:	e852                	sd	s4,16(sp)
    8000148a:	e456                	sd	s5,8(sp)
    8000148c:	0080                	addi	s0,sp,64
    8000148e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001490:	00008497          	auipc	s1,0x8
    80001494:	a5048493          	addi	s1,s1,-1456 # 80008ee0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001498:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000149a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000149c:	0000f917          	auipc	s2,0xf
    800014a0:	c4490913          	addi	s2,s2,-956 # 800100e0 <tickslock>
    800014a4:	a801                	j	800014b4 <wakeup+0x38>
      }
      release(&p->lock);
    800014a6:	8526                	mv	a0,s1
    800014a8:	236050ef          	jal	800066de <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800014ac:	1c848493          	addi	s1,s1,456
    800014b0:	03248263          	beq	s1,s2,800014d4 <wakeup+0x58>
    if(p != myproc()){
    800014b4:	955ff0ef          	jal	80000e08 <myproc>
    800014b8:	fe950ae3          	beq	a0,s1,800014ac <wakeup+0x30>
      acquire(&p->lock);
    800014bc:	8526                	mv	a0,s1
    800014be:	18c050ef          	jal	8000664a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800014c2:	4c9c                	lw	a5,24(s1)
    800014c4:	ff3791e3          	bne	a5,s3,800014a6 <wakeup+0x2a>
    800014c8:	709c                	ld	a5,32(s1)
    800014ca:	fd479ee3          	bne	a5,s4,800014a6 <wakeup+0x2a>
        p->state = RUNNABLE;
    800014ce:	0154ac23          	sw	s5,24(s1)
    800014d2:	bfd1                	j	800014a6 <wakeup+0x2a>
    }
  }
}
    800014d4:	70e2                	ld	ra,56(sp)
    800014d6:	7442                	ld	s0,48(sp)
    800014d8:	74a2                	ld	s1,40(sp)
    800014da:	7902                	ld	s2,32(sp)
    800014dc:	69e2                	ld	s3,24(sp)
    800014de:	6a42                	ld	s4,16(sp)
    800014e0:	6aa2                	ld	s5,8(sp)
    800014e2:	6121                	addi	sp,sp,64
    800014e4:	8082                	ret

00000000800014e6 <reparent>:
{
    800014e6:	7179                	addi	sp,sp,-48
    800014e8:	f406                	sd	ra,40(sp)
    800014ea:	f022                	sd	s0,32(sp)
    800014ec:	ec26                	sd	s1,24(sp)
    800014ee:	e84a                	sd	s2,16(sp)
    800014f0:	e44e                	sd	s3,8(sp)
    800014f2:	e052                	sd	s4,0(sp)
    800014f4:	1800                	addi	s0,sp,48
    800014f6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014f8:	00008497          	auipc	s1,0x8
    800014fc:	9e848493          	addi	s1,s1,-1560 # 80008ee0 <proc>
      pp->parent = initproc;
    80001500:	00007a17          	auipc	s4,0x7
    80001504:	560a0a13          	addi	s4,s4,1376 # 80008a60 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001508:	0000f997          	auipc	s3,0xf
    8000150c:	bd898993          	addi	s3,s3,-1064 # 800100e0 <tickslock>
    80001510:	a029                	j	8000151a <reparent+0x34>
    80001512:	1c848493          	addi	s1,s1,456
    80001516:	01348b63          	beq	s1,s3,8000152c <reparent+0x46>
    if(pp->parent == p){
    8000151a:	7c9c                	ld	a5,56(s1)
    8000151c:	ff279be3          	bne	a5,s2,80001512 <reparent+0x2c>
      pp->parent = initproc;
    80001520:	000a3503          	ld	a0,0(s4)
    80001524:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001526:	f57ff0ef          	jal	8000147c <wakeup>
    8000152a:	b7e5                	j	80001512 <reparent+0x2c>
}
    8000152c:	70a2                	ld	ra,40(sp)
    8000152e:	7402                	ld	s0,32(sp)
    80001530:	64e2                	ld	s1,24(sp)
    80001532:	6942                	ld	s2,16(sp)
    80001534:	69a2                	ld	s3,8(sp)
    80001536:	6a02                	ld	s4,0(sp)
    80001538:	6145                	addi	sp,sp,48
    8000153a:	8082                	ret

000000008000153c <kexit>:
{
    8000153c:	7179                	addi	sp,sp,-48
    8000153e:	f406                	sd	ra,40(sp)
    80001540:	f022                	sd	s0,32(sp)
    80001542:	ec26                	sd	s1,24(sp)
    80001544:	e84a                	sd	s2,16(sp)
    80001546:	e44e                	sd	s3,8(sp)
    80001548:	e052                	sd	s4,0(sp)
    8000154a:	1800                	addi	s0,sp,48
    8000154c:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000154e:	8bbff0ef          	jal	80000e08 <myproc>
    80001552:	89aa                	mv	s3,a0
  if(p == initproc)
    80001554:	00007797          	auipc	a5,0x7
    80001558:	50c7b783          	ld	a5,1292(a5) # 80008a60 <initproc>
    8000155c:	0d050493          	addi	s1,a0,208
    80001560:	15050913          	addi	s2,a0,336
    80001564:	00a79b63          	bne	a5,a0,8000157a <kexit+0x3e>
    panic("init exiting");
    80001568:	00007517          	auipc	a0,0x7
    8000156c:	c3050513          	addi	a0,a0,-976 # 80008198 <etext+0x198>
    80001570:	619040ef          	jal	80006388 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001574:	04a1                	addi	s1,s1,8
    80001576:	01248963          	beq	s1,s2,80001588 <kexit+0x4c>
    if(p->ofile[fd]){
    8000157a:	6088                	ld	a0,0(s1)
    8000157c:	dd65                	beqz	a0,80001574 <kexit+0x38>
      fileclose(f);
    8000157e:	7bb010ef          	jal	80003538 <fileclose>
      p->ofile[fd] = 0;
    80001582:	0004b023          	sd	zero,0(s1)
    80001586:	b7fd                	j	80001574 <kexit+0x38>
  begin_op();
    80001588:	38d010ef          	jal	80003114 <begin_op>
  iput(p->cwd);
    8000158c:	1509b503          	ld	a0,336(s3)
    80001590:	2fa010ef          	jal	8000288a <iput>
  end_op();
    80001594:	3f1010ef          	jal	80003184 <end_op>
  p->cwd = 0;
    80001598:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000159c:	00007517          	auipc	a0,0x7
    800015a0:	52c50513          	addi	a0,a0,1324 # 80008ac8 <wait_lock>
    800015a4:	0a6050ef          	jal	8000664a <acquire>
  reparent(p);
    800015a8:	854e                	mv	a0,s3
    800015aa:	f3dff0ef          	jal	800014e6 <reparent>
  wakeup(p->parent);
    800015ae:	0389b503          	ld	a0,56(s3)
    800015b2:	ecbff0ef          	jal	8000147c <wakeup>
  acquire(&p->lock);
    800015b6:	854e                	mv	a0,s3
    800015b8:	092050ef          	jal	8000664a <acquire>
  p->xstate = status;
    800015bc:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800015c0:	4795                	li	a5,5
    800015c2:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800015c6:	00007517          	auipc	a0,0x7
    800015ca:	50250513          	addi	a0,a0,1282 # 80008ac8 <wait_lock>
    800015ce:	110050ef          	jal	800066de <release>
  sched();
    800015d2:	d77ff0ef          	jal	80001348 <sched>
  panic("zombie exit");
    800015d6:	00007517          	auipc	a0,0x7
    800015da:	bd250513          	addi	a0,a0,-1070 # 800081a8 <etext+0x1a8>
    800015de:	5ab040ef          	jal	80006388 <panic>

00000000800015e2 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800015e2:	7179                	addi	sp,sp,-48
    800015e4:	f406                	sd	ra,40(sp)
    800015e6:	f022                	sd	s0,32(sp)
    800015e8:	ec26                	sd	s1,24(sp)
    800015ea:	e84a                	sd	s2,16(sp)
    800015ec:	e44e                	sd	s3,8(sp)
    800015ee:	1800                	addi	s0,sp,48
    800015f0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800015f2:	00008497          	auipc	s1,0x8
    800015f6:	8ee48493          	addi	s1,s1,-1810 # 80008ee0 <proc>
    800015fa:	0000f997          	auipc	s3,0xf
    800015fe:	ae698993          	addi	s3,s3,-1306 # 800100e0 <tickslock>
    acquire(&p->lock);
    80001602:	8526                	mv	a0,s1
    80001604:	046050ef          	jal	8000664a <acquire>
    if(p->pid == pid){
    80001608:	589c                	lw	a5,48(s1)
    8000160a:	01278b63          	beq	a5,s2,80001620 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000160e:	8526                	mv	a0,s1
    80001610:	0ce050ef          	jal	800066de <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001614:	1c848493          	addi	s1,s1,456
    80001618:	ff3495e3          	bne	s1,s3,80001602 <kkill+0x20>
  }
  return -1;
    8000161c:	557d                	li	a0,-1
    8000161e:	a819                	j	80001634 <kkill+0x52>
      p->killed = 1;
    80001620:	4785                	li	a5,1
    80001622:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001624:	4c98                	lw	a4,24(s1)
    80001626:	4789                	li	a5,2
    80001628:	00f70d63          	beq	a4,a5,80001642 <kkill+0x60>
      release(&p->lock);
    8000162c:	8526                	mv	a0,s1
    8000162e:	0b0050ef          	jal	800066de <release>
      return 0;
    80001632:	4501                	li	a0,0
}
    80001634:	70a2                	ld	ra,40(sp)
    80001636:	7402                	ld	s0,32(sp)
    80001638:	64e2                	ld	s1,24(sp)
    8000163a:	6942                	ld	s2,16(sp)
    8000163c:	69a2                	ld	s3,8(sp)
    8000163e:	6145                	addi	sp,sp,48
    80001640:	8082                	ret
        p->state = RUNNABLE;
    80001642:	478d                	li	a5,3
    80001644:	cc9c                	sw	a5,24(s1)
    80001646:	b7dd                	j	8000162c <kkill+0x4a>

0000000080001648 <setkilled>:

void
setkilled(struct proc *p)
{
    80001648:	1101                	addi	sp,sp,-32
    8000164a:	ec06                	sd	ra,24(sp)
    8000164c:	e822                	sd	s0,16(sp)
    8000164e:	e426                	sd	s1,8(sp)
    80001650:	1000                	addi	s0,sp,32
    80001652:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001654:	7f7040ef          	jal	8000664a <acquire>
  p->killed = 1;
    80001658:	4785                	li	a5,1
    8000165a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000165c:	8526                	mv	a0,s1
    8000165e:	080050ef          	jal	800066de <release>
}
    80001662:	60e2                	ld	ra,24(sp)
    80001664:	6442                	ld	s0,16(sp)
    80001666:	64a2                	ld	s1,8(sp)
    80001668:	6105                	addi	sp,sp,32
    8000166a:	8082                	ret

000000008000166c <killed>:

int
killed(struct proc *p)
{
    8000166c:	1101                	addi	sp,sp,-32
    8000166e:	ec06                	sd	ra,24(sp)
    80001670:	e822                	sd	s0,16(sp)
    80001672:	e426                	sd	s1,8(sp)
    80001674:	e04a                	sd	s2,0(sp)
    80001676:	1000                	addi	s0,sp,32
    80001678:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000167a:	7d1040ef          	jal	8000664a <acquire>
  k = p->killed;
    8000167e:	549c                	lw	a5,40(s1)
    80001680:	893e                	mv	s2,a5
  release(&p->lock);
    80001682:	8526                	mv	a0,s1
    80001684:	05a050ef          	jal	800066de <release>
  return k;
}
    80001688:	854a                	mv	a0,s2
    8000168a:	60e2                	ld	ra,24(sp)
    8000168c:	6442                	ld	s0,16(sp)
    8000168e:	64a2                	ld	s1,8(sp)
    80001690:	6902                	ld	s2,0(sp)
    80001692:	6105                	addi	sp,sp,32
    80001694:	8082                	ret

0000000080001696 <kwait>:
{
    80001696:	715d                	addi	sp,sp,-80
    80001698:	e486                	sd	ra,72(sp)
    8000169a:	e0a2                	sd	s0,64(sp)
    8000169c:	fc26                	sd	s1,56(sp)
    8000169e:	f84a                	sd	s2,48(sp)
    800016a0:	f44e                	sd	s3,40(sp)
    800016a2:	f052                	sd	s4,32(sp)
    800016a4:	ec56                	sd	s5,24(sp)
    800016a6:	e85a                	sd	s6,16(sp)
    800016a8:	e45e                	sd	s7,8(sp)
    800016aa:	0880                	addi	s0,sp,80
    800016ac:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800016ae:	f5aff0ef          	jal	80000e08 <myproc>
    800016b2:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016b4:	00007517          	auipc	a0,0x7
    800016b8:	41450513          	addi	a0,a0,1044 # 80008ac8 <wait_lock>
    800016bc:	78f040ef          	jal	8000664a <acquire>
        if(pp->state == ZOMBIE){
    800016c0:	4a15                	li	s4,5
        havekids = 1;
    800016c2:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016c4:	0000f997          	auipc	s3,0xf
    800016c8:	a1c98993          	addi	s3,s3,-1508 # 800100e0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016cc:	00007b17          	auipc	s6,0x7
    800016d0:	3fcb0b13          	addi	s6,s6,1020 # 80008ac8 <wait_lock>
    800016d4:	a869                	j	8000176e <kwait+0xd8>
          pid = pp->pid;
    800016d6:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800016da:	000b8c63          	beqz	s7,800016f2 <kwait+0x5c>
    800016de:	4691                	li	a3,4
    800016e0:	02c48613          	addi	a2,s1,44
    800016e4:	85de                	mv	a1,s7
    800016e6:	05093503          	ld	a0,80(s2)
    800016ea:	c1cff0ef          	jal	80000b06 <copyout>
    800016ee:	02054a63          	bltz	a0,80001722 <kwait+0x8c>
          freeproc(pp);
    800016f2:	8526                	mv	a0,s1
    800016f4:	8e9ff0ef          	jal	80000fdc <freeproc>
          release(&pp->lock);
    800016f8:	8526                	mv	a0,s1
    800016fa:	7e5040ef          	jal	800066de <release>
          release(&wait_lock);
    800016fe:	00007517          	auipc	a0,0x7
    80001702:	3ca50513          	addi	a0,a0,970 # 80008ac8 <wait_lock>
    80001706:	7d9040ef          	jal	800066de <release>
}
    8000170a:	854e                	mv	a0,s3
    8000170c:	60a6                	ld	ra,72(sp)
    8000170e:	6406                	ld	s0,64(sp)
    80001710:	74e2                	ld	s1,56(sp)
    80001712:	7942                	ld	s2,48(sp)
    80001714:	79a2                	ld	s3,40(sp)
    80001716:	7a02                	ld	s4,32(sp)
    80001718:	6ae2                	ld	s5,24(sp)
    8000171a:	6b42                	ld	s6,16(sp)
    8000171c:	6ba2                	ld	s7,8(sp)
    8000171e:	6161                	addi	sp,sp,80
    80001720:	8082                	ret
            release(&pp->lock);
    80001722:	8526                	mv	a0,s1
    80001724:	7bb040ef          	jal	800066de <release>
            release(&wait_lock);
    80001728:	00007517          	auipc	a0,0x7
    8000172c:	3a050513          	addi	a0,a0,928 # 80008ac8 <wait_lock>
    80001730:	7af040ef          	jal	800066de <release>
            return -1;
    80001734:	59fd                	li	s3,-1
    80001736:	bfd1                	j	8000170a <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001738:	1c848493          	addi	s1,s1,456
    8000173c:	03348063          	beq	s1,s3,8000175c <kwait+0xc6>
      if(pp->parent == p){
    80001740:	7c9c                	ld	a5,56(s1)
    80001742:	ff279be3          	bne	a5,s2,80001738 <kwait+0xa2>
        acquire(&pp->lock);
    80001746:	8526                	mv	a0,s1
    80001748:	703040ef          	jal	8000664a <acquire>
        if(pp->state == ZOMBIE){
    8000174c:	4c9c                	lw	a5,24(s1)
    8000174e:	f94784e3          	beq	a5,s4,800016d6 <kwait+0x40>
        release(&pp->lock);
    80001752:	8526                	mv	a0,s1
    80001754:	78b040ef          	jal	800066de <release>
        havekids = 1;
    80001758:	8756                	mv	a4,s5
    8000175a:	bff9                	j	80001738 <kwait+0xa2>
    if(!havekids || killed(p)){
    8000175c:	cf19                	beqz	a4,8000177a <kwait+0xe4>
    8000175e:	854a                	mv	a0,s2
    80001760:	f0dff0ef          	jal	8000166c <killed>
    80001764:	e919                	bnez	a0,8000177a <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001766:	85da                	mv	a1,s6
    80001768:	854a                	mv	a0,s2
    8000176a:	cc7ff0ef          	jal	80001430 <sleep>
    havekids = 0;
    8000176e:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001770:	00007497          	auipc	s1,0x7
    80001774:	77048493          	addi	s1,s1,1904 # 80008ee0 <proc>
    80001778:	b7e1                	j	80001740 <kwait+0xaa>
      release(&wait_lock);
    8000177a:	00007517          	auipc	a0,0x7
    8000177e:	34e50513          	addi	a0,a0,846 # 80008ac8 <wait_lock>
    80001782:	75d040ef          	jal	800066de <release>
      return -1;
    80001786:	59fd                	li	s3,-1
    80001788:	b749                	j	8000170a <kwait+0x74>

000000008000178a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000178a:	7179                	addi	sp,sp,-48
    8000178c:	f406                	sd	ra,40(sp)
    8000178e:	f022                	sd	s0,32(sp)
    80001790:	ec26                	sd	s1,24(sp)
    80001792:	e84a                	sd	s2,16(sp)
    80001794:	e44e                	sd	s3,8(sp)
    80001796:	e052                	sd	s4,0(sp)
    80001798:	1800                	addi	s0,sp,48
    8000179a:	84aa                	mv	s1,a0
    8000179c:	8a2e                	mv	s4,a1
    8000179e:	89b2                	mv	s3,a2
    800017a0:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800017a2:	e66ff0ef          	jal	80000e08 <myproc>
  if(user_dst){
    800017a6:	cc99                	beqz	s1,800017c4 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800017a8:	86ca                	mv	a3,s2
    800017aa:	864e                	mv	a2,s3
    800017ac:	85d2                	mv	a1,s4
    800017ae:	6928                	ld	a0,80(a0)
    800017b0:	b56ff0ef          	jal	80000b06 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800017b4:	70a2                	ld	ra,40(sp)
    800017b6:	7402                	ld	s0,32(sp)
    800017b8:	64e2                	ld	s1,24(sp)
    800017ba:	6942                	ld	s2,16(sp)
    800017bc:	69a2                	ld	s3,8(sp)
    800017be:	6a02                	ld	s4,0(sp)
    800017c0:	6145                	addi	sp,sp,48
    800017c2:	8082                	ret
    memmove((char *)dst, src, len);
    800017c4:	0009061b          	sext.w	a2,s2
    800017c8:	85ce                	mv	a1,s3
    800017ca:	8552                	mv	a0,s4
    800017cc:	9f3fe0ef          	jal	800001be <memmove>
    return 0;
    800017d0:	8526                	mv	a0,s1
    800017d2:	b7cd                	j	800017b4 <either_copyout+0x2a>

00000000800017d4 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800017d4:	7179                	addi	sp,sp,-48
    800017d6:	f406                	sd	ra,40(sp)
    800017d8:	f022                	sd	s0,32(sp)
    800017da:	ec26                	sd	s1,24(sp)
    800017dc:	e84a                	sd	s2,16(sp)
    800017de:	e44e                	sd	s3,8(sp)
    800017e0:	e052                	sd	s4,0(sp)
    800017e2:	1800                	addi	s0,sp,48
    800017e4:	8a2a                	mv	s4,a0
    800017e6:	84ae                	mv	s1,a1
    800017e8:	89b2                	mv	s3,a2
    800017ea:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800017ec:	e1cff0ef          	jal	80000e08 <myproc>
  if(user_src){
    800017f0:	cc99                	beqz	s1,8000180e <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800017f2:	86ca                	mv	a3,s2
    800017f4:	864e                	mv	a2,s3
    800017f6:	85d2                	mv	a1,s4
    800017f8:	6928                	ld	a0,80(a0)
    800017fa:	bd0ff0ef          	jal	80000bca <copyin>
  } else {
    memmove(dst, (char*)src, len);
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
    memmove(dst, (char*)src, len);
    8000180e:	0009061b          	sext.w	a2,s2
    80001812:	85ce                	mv	a1,s3
    80001814:	8552                	mv	a0,s4
    80001816:	9a9fe0ef          	jal	800001be <memmove>
    return 0;
    8000181a:	8526                	mv	a0,s1
    8000181c:	b7cd                	j	800017fe <either_copyin+0x2a>

000000008000181e <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    8000181e:	715d                	addi	sp,sp,-80
    80001820:	e486                	sd	ra,72(sp)
    80001822:	e0a2                	sd	s0,64(sp)
    80001824:	fc26                	sd	s1,56(sp)
    80001826:	f84a                	sd	s2,48(sp)
    80001828:	f44e                	sd	s3,40(sp)
    8000182a:	f052                	sd	s4,32(sp)
    8000182c:	ec56                	sd	s5,24(sp)
    8000182e:	e85a                	sd	s6,16(sp)
    80001830:	e45e                	sd	s7,8(sp)
    80001832:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001834:	00006517          	auipc	a0,0x6
    80001838:	7e450513          	addi	a0,a0,2020 # 80008018 <etext+0x18>
    8000183c:	023040ef          	jal	8000605e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001840:	00007497          	auipc	s1,0x7
    80001844:	7f848493          	addi	s1,s1,2040 # 80009038 <proc+0x158>
    80001848:	0000f917          	auipc	s2,0xf
    8000184c:	9f090913          	addi	s2,s2,-1552 # 80010238 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001850:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001852:	00007997          	auipc	s3,0x7
    80001856:	96698993          	addi	s3,s3,-1690 # 800081b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    8000185a:	00007a97          	auipc	s5,0x7
    8000185e:	966a8a93          	addi	s5,s5,-1690 # 800081c0 <etext+0x1c0>
    printf("\n");
    80001862:	00006a17          	auipc	s4,0x6
    80001866:	7b6a0a13          	addi	s4,s4,1974 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000186a:	00007b97          	auipc	s7,0x7
    8000186e:	05eb8b93          	addi	s7,s7,94 # 800088c8 <states.0>
    80001872:	a829                	j	8000188c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001874:	ed86a583          	lw	a1,-296(a3)
    80001878:	8556                	mv	a0,s5
    8000187a:	7e4040ef          	jal	8000605e <printf>
    printf("\n");
    8000187e:	8552                	mv	a0,s4
    80001880:	7de040ef          	jal	8000605e <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001884:	1c848493          	addi	s1,s1,456
    80001888:	03248263          	beq	s1,s2,800018ac <procdump+0x8e>
    if(p->state == UNUSED)
    8000188c:	86a6                	mv	a3,s1
    8000188e:	ec04a783          	lw	a5,-320(s1)
    80001892:	dbed                	beqz	a5,80001884 <procdump+0x66>
      state = "???";
    80001894:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001896:	fcfb6fe3          	bltu	s6,a5,80001874 <procdump+0x56>
    8000189a:	02079713          	slli	a4,a5,0x20
    8000189e:	01d75793          	srli	a5,a4,0x1d
    800018a2:	97de                	add	a5,a5,s7
    800018a4:	6390                	ld	a2,0(a5)
    800018a6:	f679                	bnez	a2,80001874 <procdump+0x56>
      state = "???";
    800018a8:	864e                	mv	a2,s3
    800018aa:	b7e9                	j	80001874 <procdump+0x56>
  }
}
    800018ac:	60a6                	ld	ra,72(sp)
    800018ae:	6406                	ld	s0,64(sp)
    800018b0:	74e2                	ld	s1,56(sp)
    800018b2:	7942                	ld	s2,48(sp)
    800018b4:	79a2                	ld	s3,40(sp)
    800018b6:	7a02                	ld	s4,32(sp)
    800018b8:	6ae2                	ld	s5,24(sp)
    800018ba:	6b42                	ld	s6,16(sp)
    800018bc:	6ba2                	ld	s7,8(sp)
    800018be:	6161                	addi	sp,sp,80
    800018c0:	8082                	ret

00000000800018c2 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800018c2:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800018c6:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800018ca:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800018cc:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800018ce:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800018d2:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800018d6:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800018da:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800018de:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800018e2:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800018e6:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800018ea:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800018ee:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800018f2:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800018f6:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800018fa:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800018fe:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001900:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001902:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001906:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000190a:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    8000190e:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001912:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001916:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000191a:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    8000191e:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001922:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001926:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000192a:	8082                	ret

000000008000192c <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000192c:	1141                	addi	sp,sp,-16
    8000192e:	e406                	sd	ra,8(sp)
    80001930:	e022                	sd	s0,0(sp)
    80001932:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001934:	00007597          	auipc	a1,0x7
    80001938:	8cc58593          	addi	a1,a1,-1844 # 80008200 <etext+0x200>
    8000193c:	0000e517          	auipc	a0,0xe
    80001940:	7a450513          	addi	a0,a0,1956 # 800100e0 <tickslock>
    80001944:	47d040ef          	jal	800065c0 <initlock>
}
    80001948:	60a2                	ld	ra,8(sp)
    8000194a:	6402                	ld	s0,0(sp)
    8000194c:	0141                	addi	sp,sp,16
    8000194e:	8082                	ret

0000000080001950 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001950:	1141                	addi	sp,sp,-16
    80001952:	e406                	sd	ra,8(sp)
    80001954:	e022                	sd	s0,0(sp)
    80001956:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001958:	00003797          	auipc	a5,0x3
    8000195c:	f9878793          	addi	a5,a5,-104 # 800048f0 <kernelvec>
    80001960:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001964:	60a2                	ld	ra,8(sp)
    80001966:	6402                	ld	s0,0(sp)
    80001968:	0141                	addi	sp,sp,16
    8000196a:	8082                	ret

000000008000196c <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    8000196c:	1141                	addi	sp,sp,-16
    8000196e:	e406                	sd	ra,8(sp)
    80001970:	e022                	sd	s0,0(sp)
    80001972:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001974:	c94ff0ef          	jal	80000e08 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001978:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000197c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000197e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001982:	04000737          	lui	a4,0x4000
    80001986:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001988:	0732                	slli	a4,a4,0xc
    8000198a:	00005797          	auipc	a5,0x5
    8000198e:	67678793          	addi	a5,a5,1654 # 80007000 <_trampoline>
    80001992:	00005697          	auipc	a3,0x5
    80001996:	66e68693          	addi	a3,a3,1646 # 80007000 <_trampoline>
    8000199a:	8f95                	sub	a5,a5,a3
    8000199c:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000199e:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800019a2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800019a4:	18002773          	csrr	a4,satp
    800019a8:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800019aa:	6d38                	ld	a4,88(a0)
    800019ac:	613c                	ld	a5,64(a0)
    800019ae:	6685                	lui	a3,0x1
    800019b0:	97b6                	add	a5,a5,a3
    800019b2:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800019b4:	6d3c                	ld	a5,88(a0)
    800019b6:	00000717          	auipc	a4,0x0
    800019ba:	10a70713          	addi	a4,a4,266 # 80001ac0 <usertrap>
    800019be:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800019c0:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800019c2:	8712                	mv	a4,tp
    800019c4:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019c6:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800019ca:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800019ce:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019d2:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800019d6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800019d8:	6f9c                	ld	a5,24(a5)
    800019da:	14179073          	csrw	sepc,a5
}
    800019de:	60a2                	ld	ra,8(sp)
    800019e0:	6402                	ld	s0,0(sp)
    800019e2:	0141                	addi	sp,sp,16
    800019e4:	8082                	ret

00000000800019e6 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800019e6:	1141                	addi	sp,sp,-16
    800019e8:	e406                	sd	ra,8(sp)
    800019ea:	e022                	sd	s0,0(sp)
    800019ec:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800019ee:	be6ff0ef          	jal	80000dd4 <cpuid>
    800019f2:	cd11                	beqz	a0,80001a0e <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800019f4:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800019f8:	000f4737          	lui	a4,0xf4
    800019fc:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001a00:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001a02:	14d79073          	csrw	stimecmp,a5
}
    80001a06:	60a2                	ld	ra,8(sp)
    80001a08:	6402                	ld	s0,0(sp)
    80001a0a:	0141                	addi	sp,sp,16
    80001a0c:	8082                	ret
    acquire(&tickslock);
    80001a0e:	0000e517          	auipc	a0,0xe
    80001a12:	6d250513          	addi	a0,a0,1746 # 800100e0 <tickslock>
    80001a16:	435040ef          	jal	8000664a <acquire>
    ticks++;
    80001a1a:	00007717          	auipc	a4,0x7
    80001a1e:	04e70713          	addi	a4,a4,78 # 80008a68 <ticks>
    80001a22:	431c                	lw	a5,0(a4)
    80001a24:	2785                	addiw	a5,a5,1
    80001a26:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001a28:	853a                	mv	a0,a4
    80001a2a:	a53ff0ef          	jal	8000147c <wakeup>
    release(&tickslock);
    80001a2e:	0000e517          	auipc	a0,0xe
    80001a32:	6b250513          	addi	a0,a0,1714 # 800100e0 <tickslock>
    80001a36:	4a9040ef          	jal	800066de <release>
    80001a3a:	bf6d                	j	800019f4 <clockintr+0xe>

0000000080001a3c <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a3c:	1101                	addi	sp,sp,-32
    80001a3e:	ec06                	sd	ra,24(sp)
    80001a40:	e822                	sd	s0,16(sp)
    80001a42:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a44:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001a48:	57fd                	li	a5,-1
    80001a4a:	17fe                	slli	a5,a5,0x3f
    80001a4c:	07a5                	addi	a5,a5,9
    80001a4e:	00f70c63          	beq	a4,a5,80001a66 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a52:	57fd                	li	a5,-1
    80001a54:	17fe                	slli	a5,a5,0x3f
    80001a56:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a58:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a5a:	04f70f63          	beq	a4,a5,80001ab8 <devintr+0x7c>
  }
}
    80001a5e:	60e2                	ld	ra,24(sp)
    80001a60:	6442                	ld	s0,16(sp)
    80001a62:	6105                	addi	sp,sp,32
    80001a64:	8082                	ret
    80001a66:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a68:	755020ef          	jal	800049bc <plic_claim>
    80001a6c:	872a                	mv	a4,a0
    80001a6e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a70:	47a9                	li	a5,10
    80001a72:	00f50d63          	beq	a0,a5,80001a8c <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001a76:	4785                	li	a5,1
    80001a78:	02f50263          	beq	a0,a5,80001a9c <devintr+0x60>
    else if(irq == E1000_IRQ){
    80001a7c:	02100793          	li	a5,33
    80001a80:	02f50163          	beq	a0,a5,80001aa2 <devintr+0x66>
    return 1;
    80001a84:	4505                	li	a0,1
    else if(irq){
    80001a86:	e30d                	bnez	a4,80001aa8 <devintr+0x6c>
    80001a88:	64a2                	ld	s1,8(sp)
    80001a8a:	bfd1                	j	80001a5e <devintr+0x22>
      uartintr();
    80001a8c:	2cd040ef          	jal	80006558 <uartintr>
      plic_complete(irq);
    80001a90:	8526                	mv	a0,s1
    80001a92:	74b020ef          	jal	800049dc <plic_complete>
    return 1;
    80001a96:	4505                	li	a0,1
    80001a98:	64a2                	ld	s1,8(sp)
    80001a9a:	b7d1                	j	80001a5e <devintr+0x22>
      virtio_disk_intr();
    80001a9c:	3b6030ef          	jal	80004e52 <virtio_disk_intr>
    if(irq)
    80001aa0:	bfc5                	j	80001a90 <devintr+0x54>
      e1000_intr();
    80001aa2:	6a8030ef          	jal	8000514a <e1000_intr>
    if(irq)
    80001aa6:	b7ed                	j	80001a90 <devintr+0x54>
      printf("unexpected interrupt irq=%d\n", irq);
    80001aa8:	85ba                	mv	a1,a4
    80001aaa:	00006517          	auipc	a0,0x6
    80001aae:	75e50513          	addi	a0,a0,1886 # 80008208 <etext+0x208>
    80001ab2:	5ac040ef          	jal	8000605e <printf>
    if(irq)
    80001ab6:	bfe9                	j	80001a90 <devintr+0x54>
    clockintr();
    80001ab8:	f2fff0ef          	jal	800019e6 <clockintr>
    return 2;
    80001abc:	4509                	li	a0,2
    80001abe:	b745                	j	80001a5e <devintr+0x22>

0000000080001ac0 <usertrap>:
{
    80001ac0:	1101                	addi	sp,sp,-32
    80001ac2:	ec06                	sd	ra,24(sp)
    80001ac4:	e822                	sd	s0,16(sp)
    80001ac6:	e426                	sd	s1,8(sp)
    80001ac8:	e04a                	sd	s2,0(sp)
    80001aca:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001acc:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001ad0:	1007f793          	andi	a5,a5,256
    80001ad4:	eba5                	bnez	a5,80001b44 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ad6:	00003797          	auipc	a5,0x3
    80001ada:	e1a78793          	addi	a5,a5,-486 # 800048f0 <kernelvec>
    80001ade:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001ae2:	b26ff0ef          	jal	80000e08 <myproc>
    80001ae6:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001ae8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aea:	14102773          	csrr	a4,sepc
    80001aee:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001af0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001af4:	47a1                	li	a5,8
    80001af6:	04f70d63          	beq	a4,a5,80001b50 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001afa:	f43ff0ef          	jal	80001a3c <devintr>
    80001afe:	892a                	mv	s2,a0
    80001b00:	e945                	bnez	a0,80001bb0 <usertrap+0xf0>
    80001b02:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b06:	47bd                	li	a5,15
    80001b08:	08f70863          	beq	a4,a5,80001b98 <usertrap+0xd8>
    80001b0c:	14202773          	csrr	a4,scause
    80001b10:	47b5                	li	a5,13
    80001b12:	08f70363          	beq	a4,a5,80001b98 <usertrap+0xd8>
    80001b16:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b1a:	5890                	lw	a2,48(s1)
    80001b1c:	00006517          	auipc	a0,0x6
    80001b20:	72c50513          	addi	a0,a0,1836 # 80008248 <etext+0x248>
    80001b24:	53a040ef          	jal	8000605e <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b28:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b2c:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b30:	00006517          	auipc	a0,0x6
    80001b34:	74850513          	addi	a0,a0,1864 # 80008278 <etext+0x278>
    80001b38:	526040ef          	jal	8000605e <printf>
    setkilled(p);
    80001b3c:	8526                	mv	a0,s1
    80001b3e:	b0bff0ef          	jal	80001648 <setkilled>
    80001b42:	a035                	j	80001b6e <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001b44:	00006517          	auipc	a0,0x6
    80001b48:	6e450513          	addi	a0,a0,1764 # 80008228 <etext+0x228>
    80001b4c:	03d040ef          	jal	80006388 <panic>
    if(killed(p))
    80001b50:	b1dff0ef          	jal	8000166c <killed>
    80001b54:	ed15                	bnez	a0,80001b90 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001b56:	6cb8                	ld	a4,88(s1)
    80001b58:	6f1c                	ld	a5,24(a4)
    80001b5a:	0791                	addi	a5,a5,4
    80001b5c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b5e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b62:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b66:	10079073          	csrw	sstatus,a5
    syscall();
    80001b6a:	240000ef          	jal	80001daa <syscall>
  if(killed(p))
    80001b6e:	8526                	mv	a0,s1
    80001b70:	afdff0ef          	jal	8000166c <killed>
    80001b74:	e139                	bnez	a0,80001bba <usertrap+0xfa>
  prepare_return();
    80001b76:	df7ff0ef          	jal	8000196c <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b7a:	68a8                	ld	a0,80(s1)
    80001b7c:	8131                	srli	a0,a0,0xc
    80001b7e:	57fd                	li	a5,-1
    80001b80:	17fe                	slli	a5,a5,0x3f
    80001b82:	8d5d                	or	a0,a0,a5
}
    80001b84:	60e2                	ld	ra,24(sp)
    80001b86:	6442                	ld	s0,16(sp)
    80001b88:	64a2                	ld	s1,8(sp)
    80001b8a:	6902                	ld	s2,0(sp)
    80001b8c:	6105                	addi	sp,sp,32
    80001b8e:	8082                	ret
      kexit(-1);
    80001b90:	557d                	li	a0,-1
    80001b92:	9abff0ef          	jal	8000153c <kexit>
    80001b96:	b7c1                	j	80001b56 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b98:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b9c:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001ba0:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001ba2:	00163613          	seqz	a2,a2
    80001ba6:	68a8                	ld	a0,80(s1)
    80001ba8:	edbfe0ef          	jal	80000a82 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001bac:	f169                	bnez	a0,80001b6e <usertrap+0xae>
    80001bae:	b7a5                	j	80001b16 <usertrap+0x56>
  if(killed(p))
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	abbff0ef          	jal	8000166c <killed>
    80001bb6:	c511                	beqz	a0,80001bc2 <usertrap+0x102>
    80001bb8:	a011                	j	80001bbc <usertrap+0xfc>
    80001bba:	4901                	li	s2,0
    kexit(-1);
    80001bbc:	557d                	li	a0,-1
    80001bbe:	97fff0ef          	jal	8000153c <kexit>
  if(which_dev == 2)
    80001bc2:	4789                	li	a5,2
    80001bc4:	faf919e3          	bne	s2,a5,80001b76 <usertrap+0xb6>
    yield();
    80001bc8:	83dff0ef          	jal	80001404 <yield>
    80001bcc:	b76d                	j	80001b76 <usertrap+0xb6>

0000000080001bce <kerneltrap>:
{
    80001bce:	7179                	addi	sp,sp,-48
    80001bd0:	f406                	sd	ra,40(sp)
    80001bd2:	f022                	sd	s0,32(sp)
    80001bd4:	ec26                	sd	s1,24(sp)
    80001bd6:	e84a                	sd	s2,16(sp)
    80001bd8:	e44e                	sd	s3,8(sp)
    80001bda:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bdc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001be0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001be4:	142027f3          	csrr	a5,scause
    80001be8:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001bea:	1004f793          	andi	a5,s1,256
    80001bee:	c795                	beqz	a5,80001c1a <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bf0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001bf4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001bf6:	eb85                	bnez	a5,80001c26 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001bf8:	e45ff0ef          	jal	80001a3c <devintr>
    80001bfc:	c91d                	beqz	a0,80001c32 <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001bfe:	4789                	li	a5,2
    80001c00:	04f50a63          	beq	a0,a5,80001c54 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c04:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c08:	10049073          	csrw	sstatus,s1
}
    80001c0c:	70a2                	ld	ra,40(sp)
    80001c0e:	7402                	ld	s0,32(sp)
    80001c10:	64e2                	ld	s1,24(sp)
    80001c12:	6942                	ld	s2,16(sp)
    80001c14:	69a2                	ld	s3,8(sp)
    80001c16:	6145                	addi	sp,sp,48
    80001c18:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001c1a:	00006517          	auipc	a0,0x6
    80001c1e:	68650513          	addi	a0,a0,1670 # 800082a0 <etext+0x2a0>
    80001c22:	766040ef          	jal	80006388 <panic>
    panic("kerneltrap: interrupts enabled");
    80001c26:	00006517          	auipc	a0,0x6
    80001c2a:	6a250513          	addi	a0,a0,1698 # 800082c8 <etext+0x2c8>
    80001c2e:	75a040ef          	jal	80006388 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c32:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c36:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001c3a:	85ce                	mv	a1,s3
    80001c3c:	00006517          	auipc	a0,0x6
    80001c40:	6ac50513          	addi	a0,a0,1708 # 800082e8 <etext+0x2e8>
    80001c44:	41a040ef          	jal	8000605e <printf>
    panic("kerneltrap");
    80001c48:	00006517          	auipc	a0,0x6
    80001c4c:	6c850513          	addi	a0,a0,1736 # 80008310 <etext+0x310>
    80001c50:	738040ef          	jal	80006388 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c54:	9b4ff0ef          	jal	80000e08 <myproc>
    80001c58:	d555                	beqz	a0,80001c04 <kerneltrap+0x36>
    yield();
    80001c5a:	faaff0ef          	jal	80001404 <yield>
    80001c5e:	b75d                	j	80001c04 <kerneltrap+0x36>

0000000080001c60 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001c60:	1101                	addi	sp,sp,-32
    80001c62:	ec06                	sd	ra,24(sp)
    80001c64:	e822                	sd	s0,16(sp)
    80001c66:	e426                	sd	s1,8(sp)
    80001c68:	1000                	addi	s0,sp,32
    80001c6a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c6c:	99cff0ef          	jal	80000e08 <myproc>
  switch (n) {
    80001c70:	4795                	li	a5,5
    80001c72:	0497e163          	bltu	a5,s1,80001cb4 <argraw+0x54>
    80001c76:	048a                	slli	s1,s1,0x2
    80001c78:	00007717          	auipc	a4,0x7
    80001c7c:	c8070713          	addi	a4,a4,-896 # 800088f8 <states.0+0x30>
    80001c80:	94ba                	add	s1,s1,a4
    80001c82:	409c                	lw	a5,0(s1)
    80001c84:	97ba                	add	a5,a5,a4
    80001c86:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c88:	6d3c                	ld	a5,88(a0)
    80001c8a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c8c:	60e2                	ld	ra,24(sp)
    80001c8e:	6442                	ld	s0,16(sp)
    80001c90:	64a2                	ld	s1,8(sp)
    80001c92:	6105                	addi	sp,sp,32
    80001c94:	8082                	ret
    return p->trapframe->a1;
    80001c96:	6d3c                	ld	a5,88(a0)
    80001c98:	7fa8                	ld	a0,120(a5)
    80001c9a:	bfcd                	j	80001c8c <argraw+0x2c>
    return p->trapframe->a2;
    80001c9c:	6d3c                	ld	a5,88(a0)
    80001c9e:	63c8                	ld	a0,128(a5)
    80001ca0:	b7f5                	j	80001c8c <argraw+0x2c>
    return p->trapframe->a3;
    80001ca2:	6d3c                	ld	a5,88(a0)
    80001ca4:	67c8                	ld	a0,136(a5)
    80001ca6:	b7dd                	j	80001c8c <argraw+0x2c>
    return p->trapframe->a4;
    80001ca8:	6d3c                	ld	a5,88(a0)
    80001caa:	6bc8                	ld	a0,144(a5)
    80001cac:	b7c5                	j	80001c8c <argraw+0x2c>
    return p->trapframe->a5;
    80001cae:	6d3c                	ld	a5,88(a0)
    80001cb0:	6fc8                	ld	a0,152(a5)
    80001cb2:	bfe9                	j	80001c8c <argraw+0x2c>
  panic("argraw");
    80001cb4:	00006517          	auipc	a0,0x6
    80001cb8:	66c50513          	addi	a0,a0,1644 # 80008320 <etext+0x320>
    80001cbc:	6cc040ef          	jal	80006388 <panic>

0000000080001cc0 <fetchaddr>:
{
    80001cc0:	1101                	addi	sp,sp,-32
    80001cc2:	ec06                	sd	ra,24(sp)
    80001cc4:	e822                	sd	s0,16(sp)
    80001cc6:	e426                	sd	s1,8(sp)
    80001cc8:	e04a                	sd	s2,0(sp)
    80001cca:	1000                	addi	s0,sp,32
    80001ccc:	84aa                	mv	s1,a0
    80001cce:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001cd0:	938ff0ef          	jal	80000e08 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001cd4:	653c                	ld	a5,72(a0)
    80001cd6:	02f4f663          	bgeu	s1,a5,80001d02 <fetchaddr+0x42>
    80001cda:	00848713          	addi	a4,s1,8
    80001cde:	02e7e463          	bltu	a5,a4,80001d06 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ce2:	46a1                	li	a3,8
    80001ce4:	8626                	mv	a2,s1
    80001ce6:	85ca                	mv	a1,s2
    80001ce8:	6928                	ld	a0,80(a0)
    80001cea:	ee1fe0ef          	jal	80000bca <copyin>
    80001cee:	00a03533          	snez	a0,a0
    80001cf2:	40a0053b          	negw	a0,a0
}
    80001cf6:	60e2                	ld	ra,24(sp)
    80001cf8:	6442                	ld	s0,16(sp)
    80001cfa:	64a2                	ld	s1,8(sp)
    80001cfc:	6902                	ld	s2,0(sp)
    80001cfe:	6105                	addi	sp,sp,32
    80001d00:	8082                	ret
    return -1;
    80001d02:	557d                	li	a0,-1
    80001d04:	bfcd                	j	80001cf6 <fetchaddr+0x36>
    80001d06:	557d                	li	a0,-1
    80001d08:	b7fd                	j	80001cf6 <fetchaddr+0x36>

0000000080001d0a <fetchstr>:
{
    80001d0a:	7179                	addi	sp,sp,-48
    80001d0c:	f406                	sd	ra,40(sp)
    80001d0e:	f022                	sd	s0,32(sp)
    80001d10:	ec26                	sd	s1,24(sp)
    80001d12:	e84a                	sd	s2,16(sp)
    80001d14:	e44e                	sd	s3,8(sp)
    80001d16:	1800                	addi	s0,sp,48
    80001d18:	89aa                	mv	s3,a0
    80001d1a:	84ae                	mv	s1,a1
    80001d1c:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001d1e:	8eaff0ef          	jal	80000e08 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001d22:	86ca                	mv	a3,s2
    80001d24:	864e                	mv	a2,s3
    80001d26:	85a6                	mv	a1,s1
    80001d28:	6928                	ld	a0,80(a0)
    80001d2a:	c81fe0ef          	jal	800009aa <copyinstr>
    80001d2e:	00054c63          	bltz	a0,80001d46 <fetchstr+0x3c>
  return strlen(buf);
    80001d32:	8526                	mv	a0,s1
    80001d34:	db4fe0ef          	jal	800002e8 <strlen>
}
    80001d38:	70a2                	ld	ra,40(sp)
    80001d3a:	7402                	ld	s0,32(sp)
    80001d3c:	64e2                	ld	s1,24(sp)
    80001d3e:	6942                	ld	s2,16(sp)
    80001d40:	69a2                	ld	s3,8(sp)
    80001d42:	6145                	addi	sp,sp,48
    80001d44:	8082                	ret
    return -1;
    80001d46:	557d                	li	a0,-1
    80001d48:	bfc5                	j	80001d38 <fetchstr+0x2e>

0000000080001d4a <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001d4a:	1101                	addi	sp,sp,-32
    80001d4c:	ec06                	sd	ra,24(sp)
    80001d4e:	e822                	sd	s0,16(sp)
    80001d50:	e426                	sd	s1,8(sp)
    80001d52:	1000                	addi	s0,sp,32
    80001d54:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d56:	f0bff0ef          	jal	80001c60 <argraw>
    80001d5a:	c088                	sw	a0,0(s1)
}
    80001d5c:	60e2                	ld	ra,24(sp)
    80001d5e:	6442                	ld	s0,16(sp)
    80001d60:	64a2                	ld	s1,8(sp)
    80001d62:	6105                	addi	sp,sp,32
    80001d64:	8082                	ret

0000000080001d66 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001d66:	1101                	addi	sp,sp,-32
    80001d68:	ec06                	sd	ra,24(sp)
    80001d6a:	e822                	sd	s0,16(sp)
    80001d6c:	e426                	sd	s1,8(sp)
    80001d6e:	1000                	addi	s0,sp,32
    80001d70:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d72:	eefff0ef          	jal	80001c60 <argraw>
    80001d76:	e088                	sd	a0,0(s1)
}
    80001d78:	60e2                	ld	ra,24(sp)
    80001d7a:	6442                	ld	s0,16(sp)
    80001d7c:	64a2                	ld	s1,8(sp)
    80001d7e:	6105                	addi	sp,sp,32
    80001d80:	8082                	ret

0000000080001d82 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d82:	1101                	addi	sp,sp,-32
    80001d84:	ec06                	sd	ra,24(sp)
    80001d86:	e822                	sd	s0,16(sp)
    80001d88:	e426                	sd	s1,8(sp)
    80001d8a:	e04a                	sd	s2,0(sp)
    80001d8c:	1000                	addi	s0,sp,32
    80001d8e:	892e                	mv	s2,a1
    80001d90:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001d92:	ecfff0ef          	jal	80001c60 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001d96:	8626                	mv	a2,s1
    80001d98:	85ca                	mv	a1,s2
    80001d9a:	f71ff0ef          	jal	80001d0a <fetchstr>
}
    80001d9e:	60e2                	ld	ra,24(sp)
    80001da0:	6442                	ld	s0,16(sp)
    80001da2:	64a2                	ld	s1,8(sp)
    80001da4:	6902                	ld	s2,0(sp)
    80001da6:	6105                	addi	sp,sp,32
    80001da8:	8082                	ret

0000000080001daa <syscall>:
};


void
syscall(void)
{
    80001daa:	1101                	addi	sp,sp,-32
    80001dac:	ec06                	sd	ra,24(sp)
    80001dae:	e822                	sd	s0,16(sp)
    80001db0:	e426                	sd	s1,8(sp)
    80001db2:	e04a                	sd	s2,0(sp)
    80001db4:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001db6:	852ff0ef          	jal	80000e08 <myproc>
    80001dba:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001dbc:	05853903          	ld	s2,88(a0)
    80001dc0:	0a893783          	ld	a5,168(s2)
    80001dc4:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001dc8:	37fd                	addiw	a5,a5,-1
    80001dca:	477d                	li	a4,31
    80001dcc:	00f76f63          	bltu	a4,a5,80001dea <syscall+0x40>
    80001dd0:	00369713          	slli	a4,a3,0x3
    80001dd4:	00007797          	auipc	a5,0x7
    80001dd8:	b3c78793          	addi	a5,a5,-1220 # 80008910 <syscalls>
    80001ddc:	97ba                	add	a5,a5,a4
    80001dde:	639c                	ld	a5,0(a5)
    80001de0:	c789                	beqz	a5,80001dea <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001de2:	9782                	jalr	a5
    80001de4:	06a93823          	sd	a0,112(s2)
    80001de8:	a829                	j	80001e02 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001dea:	15848613          	addi	a2,s1,344
    80001dee:	588c                	lw	a1,48(s1)
    80001df0:	00006517          	auipc	a0,0x6
    80001df4:	53850513          	addi	a0,a0,1336 # 80008328 <etext+0x328>
    80001df8:	266040ef          	jal	8000605e <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001dfc:	6cbc                	ld	a5,88(s1)
    80001dfe:	577d                	li	a4,-1
    80001e00:	fbb8                	sd	a4,112(a5)
  }
}
    80001e02:	60e2                	ld	ra,24(sp)
    80001e04:	6442                	ld	s0,16(sp)
    80001e06:	64a2                	ld	s1,8(sp)
    80001e08:	6902                	ld	s2,0(sp)
    80001e0a:	6105                	addi	sp,sp,32
    80001e0c:	8082                	ret

0000000080001e0e <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001e0e:	1101                	addi	sp,sp,-32
    80001e10:	ec06                	sd	ra,24(sp)
    80001e12:	e822                	sd	s0,16(sp)
    80001e14:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001e16:	fec40593          	addi	a1,s0,-20
    80001e1a:	4501                	li	a0,0
    80001e1c:	f2fff0ef          	jal	80001d4a <argint>
  kexit(n);
    80001e20:	fec42503          	lw	a0,-20(s0)
    80001e24:	f18ff0ef          	jal	8000153c <kexit>
  return 0;  // not reached
}
    80001e28:	4501                	li	a0,0
    80001e2a:	60e2                	ld	ra,24(sp)
    80001e2c:	6442                	ld	s0,16(sp)
    80001e2e:	6105                	addi	sp,sp,32
    80001e30:	8082                	ret

0000000080001e32 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001e32:	1141                	addi	sp,sp,-16
    80001e34:	e406                	sd	ra,8(sp)
    80001e36:	e022                	sd	s0,0(sp)
    80001e38:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001e3a:	fcffe0ef          	jal	80000e08 <myproc>
}
    80001e3e:	5908                	lw	a0,48(a0)
    80001e40:	60a2                	ld	ra,8(sp)
    80001e42:	6402                	ld	s0,0(sp)
    80001e44:	0141                	addi	sp,sp,16
    80001e46:	8082                	ret

0000000080001e48 <sys_fork>:

uint64
sys_fork(void)
{
    80001e48:	1141                	addi	sp,sp,-16
    80001e4a:	e406                	sd	ra,8(sp)
    80001e4c:	e022                	sd	s0,0(sp)
    80001e4e:	0800                	addi	s0,sp,16
  return kfork();
    80001e50:	b20ff0ef          	jal	80001170 <kfork>
}
    80001e54:	60a2                	ld	ra,8(sp)
    80001e56:	6402                	ld	s0,0(sp)
    80001e58:	0141                	addi	sp,sp,16
    80001e5a:	8082                	ret

0000000080001e5c <sys_wait>:

uint64
sys_wait(void)
{
    80001e5c:	1101                	addi	sp,sp,-32
    80001e5e:	ec06                	sd	ra,24(sp)
    80001e60:	e822                	sd	s0,16(sp)
    80001e62:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e64:	fe840593          	addi	a1,s0,-24
    80001e68:	4501                	li	a0,0
    80001e6a:	efdff0ef          	jal	80001d66 <argaddr>
  return kwait(p);
    80001e6e:	fe843503          	ld	a0,-24(s0)
    80001e72:	825ff0ef          	jal	80001696 <kwait>
}
    80001e76:	60e2                	ld	ra,24(sp)
    80001e78:	6442                	ld	s0,16(sp)
    80001e7a:	6105                	addi	sp,sp,32
    80001e7c:	8082                	ret

0000000080001e7e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e7e:	7179                	addi	sp,sp,-48
    80001e80:	f406                	sd	ra,40(sp)
    80001e82:	f022                	sd	s0,32(sp)
    80001e84:	ec26                	sd	s1,24(sp)
    80001e86:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001e88:	fd840593          	addi	a1,s0,-40
    80001e8c:	4501                	li	a0,0
    80001e8e:	ebdff0ef          	jal	80001d4a <argint>
  argint(1, &t);
    80001e92:	fdc40593          	addi	a1,s0,-36
    80001e96:	4505                	li	a0,1
    80001e98:	eb3ff0ef          	jal	80001d4a <argint>
  addr = myproc()->sz;
    80001e9c:	f6dfe0ef          	jal	80000e08 <myproc>
    80001ea0:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001ea2:	fdc42703          	lw	a4,-36(s0)
    80001ea6:	4785                	li	a5,1
    80001ea8:	02f70163          	beq	a4,a5,80001eca <sys_sbrk+0x4c>
    80001eac:	fd842783          	lw	a5,-40(s0)
    80001eb0:	0007cd63          	bltz	a5,80001eca <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001eb4:	97a6                	add	a5,a5,s1
    80001eb6:	0297e863          	bltu	a5,s1,80001ee6 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001eba:	f4ffe0ef          	jal	80000e08 <myproc>
    80001ebe:	fd842703          	lw	a4,-40(s0)
    80001ec2:	653c                	ld	a5,72(a0)
    80001ec4:	97ba                	add	a5,a5,a4
    80001ec6:	e53c                	sd	a5,72(a0)
    80001ec8:	a039                	j	80001ed6 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001eca:	fd842503          	lw	a0,-40(s0)
    80001ece:	a52ff0ef          	jal	80001120 <growproc>
    80001ed2:	00054863          	bltz	a0,80001ee2 <sys_sbrk+0x64>
  }
  return addr;
}
    80001ed6:	8526                	mv	a0,s1
    80001ed8:	70a2                	ld	ra,40(sp)
    80001eda:	7402                	ld	s0,32(sp)
    80001edc:	64e2                	ld	s1,24(sp)
    80001ede:	6145                	addi	sp,sp,48
    80001ee0:	8082                	ret
      return -1;
    80001ee2:	54fd                	li	s1,-1
    80001ee4:	bfcd                	j	80001ed6 <sys_sbrk+0x58>
      return -1;
    80001ee6:	54fd                	li	s1,-1
    80001ee8:	b7fd                	j	80001ed6 <sys_sbrk+0x58>

0000000080001eea <sys_pause>:

uint64
sys_pause(void)
{
    80001eea:	7139                	addi	sp,sp,-64
    80001eec:	fc06                	sd	ra,56(sp)
    80001eee:	f822                	sd	s0,48(sp)
    80001ef0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001ef2:	fcc40593          	addi	a1,s0,-52
    80001ef6:	4501                	li	a0,0
    80001ef8:	e53ff0ef          	jal	80001d4a <argint>
  if(n < 0)
    80001efc:	fcc42783          	lw	a5,-52(s0)
    80001f00:	0607c863          	bltz	a5,80001f70 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001f04:	0000e517          	auipc	a0,0xe
    80001f08:	1dc50513          	addi	a0,a0,476 # 800100e0 <tickslock>
    80001f0c:	73e040ef          	jal	8000664a <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001f10:	fcc42783          	lw	a5,-52(s0)
    80001f14:	c3b9                	beqz	a5,80001f5a <sys_pause+0x70>
    80001f16:	f426                	sd	s1,40(sp)
    80001f18:	f04a                	sd	s2,32(sp)
    80001f1a:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001f1c:	00007997          	auipc	s3,0x7
    80001f20:	b4c9a983          	lw	s3,-1204(s3) # 80008a68 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001f24:	0000e917          	auipc	s2,0xe
    80001f28:	1bc90913          	addi	s2,s2,444 # 800100e0 <tickslock>
    80001f2c:	00007497          	auipc	s1,0x7
    80001f30:	b3c48493          	addi	s1,s1,-1220 # 80008a68 <ticks>
    if(killed(myproc())){
    80001f34:	ed5fe0ef          	jal	80000e08 <myproc>
    80001f38:	f34ff0ef          	jal	8000166c <killed>
    80001f3c:	ed0d                	bnez	a0,80001f76 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001f3e:	85ca                	mv	a1,s2
    80001f40:	8526                	mv	a0,s1
    80001f42:	ceeff0ef          	jal	80001430 <sleep>
  while(ticks - ticks0 < n){
    80001f46:	409c                	lw	a5,0(s1)
    80001f48:	413787bb          	subw	a5,a5,s3
    80001f4c:	fcc42703          	lw	a4,-52(s0)
    80001f50:	fee7e2e3          	bltu	a5,a4,80001f34 <sys_pause+0x4a>
    80001f54:	74a2                	ld	s1,40(sp)
    80001f56:	7902                	ld	s2,32(sp)
    80001f58:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001f5a:	0000e517          	auipc	a0,0xe
    80001f5e:	18650513          	addi	a0,a0,390 # 800100e0 <tickslock>
    80001f62:	77c040ef          	jal	800066de <release>
  return 0;
    80001f66:	4501                	li	a0,0
}
    80001f68:	70e2                	ld	ra,56(sp)
    80001f6a:	7442                	ld	s0,48(sp)
    80001f6c:	6121                	addi	sp,sp,64
    80001f6e:	8082                	ret
    n = 0;
    80001f70:	fc042623          	sw	zero,-52(s0)
    80001f74:	bf41                	j	80001f04 <sys_pause+0x1a>
      release(&tickslock);
    80001f76:	0000e517          	auipc	a0,0xe
    80001f7a:	16a50513          	addi	a0,a0,362 # 800100e0 <tickslock>
    80001f7e:	760040ef          	jal	800066de <release>
      return -1;
    80001f82:	557d                	li	a0,-1
    80001f84:	74a2                	ld	s1,40(sp)
    80001f86:	7902                	ld	s2,32(sp)
    80001f88:	69e2                	ld	s3,24(sp)
    80001f8a:	bff9                	j	80001f68 <sys_pause+0x7e>

0000000080001f8c <sys_kill>:

uint64
sys_kill(void)
{
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f94:	fec40593          	addi	a1,s0,-20
    80001f98:	4501                	li	a0,0
    80001f9a:	db1ff0ef          	jal	80001d4a <argint>
  return kkill(pid);
    80001f9e:	fec42503          	lw	a0,-20(s0)
    80001fa2:	e40ff0ef          	jal	800015e2 <kkill>
}
    80001fa6:	60e2                	ld	ra,24(sp)
    80001fa8:	6442                	ld	s0,16(sp)
    80001faa:	6105                	addi	sp,sp,32
    80001fac:	8082                	ret

0000000080001fae <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001fae:	1101                	addi	sp,sp,-32
    80001fb0:	ec06                	sd	ra,24(sp)
    80001fb2:	e822                	sd	s0,16(sp)
    80001fb4:	e426                	sd	s1,8(sp)
    80001fb6:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001fb8:	0000e517          	auipc	a0,0xe
    80001fbc:	12850513          	addi	a0,a0,296 # 800100e0 <tickslock>
    80001fc0:	68a040ef          	jal	8000664a <acquire>
  xticks = ticks;
    80001fc4:	00007797          	auipc	a5,0x7
    80001fc8:	aa47a783          	lw	a5,-1372(a5) # 80008a68 <ticks>
    80001fcc:	84be                	mv	s1,a5
  release(&tickslock);
    80001fce:	0000e517          	auipc	a0,0xe
    80001fd2:	11250513          	addi	a0,a0,274 # 800100e0 <tickslock>
    80001fd6:	708040ef          	jal	800066de <release>
  return xticks;
}
    80001fda:	02049513          	slli	a0,s1,0x20
    80001fde:	9101                	srli	a0,a0,0x20
    80001fe0:	60e2                	ld	ra,24(sp)
    80001fe2:	6442                	ld	s0,16(sp)
    80001fe4:	64a2                	ld	s1,8(sp)
    80001fe6:	6105                	addi	sp,sp,32
    80001fe8:	8082                	ret

0000000080001fea <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001fea:	7179                	addi	sp,sp,-48
    80001fec:	f406                	sd	ra,40(sp)
    80001fee:	f022                	sd	s0,32(sp)
    80001ff0:	ec26                	sd	s1,24(sp)
    80001ff2:	e84a                	sd	s2,16(sp)
    80001ff4:	e44e                	sd	s3,8(sp)
    80001ff6:	e052                	sd	s4,0(sp)
    80001ff8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001ffa:	00006597          	auipc	a1,0x6
    80001ffe:	34e58593          	addi	a1,a1,846 # 80008348 <etext+0x348>
    80002002:	0000e517          	auipc	a0,0xe
    80002006:	0f650513          	addi	a0,a0,246 # 800100f8 <bcache>
    8000200a:	5b6040ef          	jal	800065c0 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000200e:	00016797          	auipc	a5,0x16
    80002012:	0ea78793          	addi	a5,a5,234 # 800180f8 <bcache+0x8000>
    80002016:	00016717          	auipc	a4,0x16
    8000201a:	34a70713          	addi	a4,a4,842 # 80018360 <bcache+0x8268>
    8000201e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002022:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002026:	0000e497          	auipc	s1,0xe
    8000202a:	0ea48493          	addi	s1,s1,234 # 80010110 <bcache+0x18>
    b->next = bcache.head.next;
    8000202e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002030:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002032:	00006a17          	auipc	s4,0x6
    80002036:	31ea0a13          	addi	s4,s4,798 # 80008350 <etext+0x350>
    b->next = bcache.head.next;
    8000203a:	2b893783          	ld	a5,696(s2)
    8000203e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002040:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002044:	85d2                	mv	a1,s4
    80002046:	01048513          	addi	a0,s1,16
    8000204a:	328010ef          	jal	80003372 <initsleeplock>
    bcache.head.next->prev = b;
    8000204e:	2b893783          	ld	a5,696(s2)
    80002052:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002054:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002058:	45848493          	addi	s1,s1,1112
    8000205c:	fd349fe3          	bne	s1,s3,8000203a <binit+0x50>
  }
}
    80002060:	70a2                	ld	ra,40(sp)
    80002062:	7402                	ld	s0,32(sp)
    80002064:	64e2                	ld	s1,24(sp)
    80002066:	6942                	ld	s2,16(sp)
    80002068:	69a2                	ld	s3,8(sp)
    8000206a:	6a02                	ld	s4,0(sp)
    8000206c:	6145                	addi	sp,sp,48
    8000206e:	8082                	ret

0000000080002070 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002070:	7179                	addi	sp,sp,-48
    80002072:	f406                	sd	ra,40(sp)
    80002074:	f022                	sd	s0,32(sp)
    80002076:	ec26                	sd	s1,24(sp)
    80002078:	e84a                	sd	s2,16(sp)
    8000207a:	e44e                	sd	s3,8(sp)
    8000207c:	1800                	addi	s0,sp,48
    8000207e:	892a                	mv	s2,a0
    80002080:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002082:	0000e517          	auipc	a0,0xe
    80002086:	07650513          	addi	a0,a0,118 # 800100f8 <bcache>
    8000208a:	5c0040ef          	jal	8000664a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000208e:	00016497          	auipc	s1,0x16
    80002092:	3224b483          	ld	s1,802(s1) # 800183b0 <bcache+0x82b8>
    80002096:	00016797          	auipc	a5,0x16
    8000209a:	2ca78793          	addi	a5,a5,714 # 80018360 <bcache+0x8268>
    8000209e:	02f48b63          	beq	s1,a5,800020d4 <bread+0x64>
    800020a2:	873e                	mv	a4,a5
    800020a4:	a021                	j	800020ac <bread+0x3c>
    800020a6:	68a4                	ld	s1,80(s1)
    800020a8:	02e48663          	beq	s1,a4,800020d4 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800020ac:	449c                	lw	a5,8(s1)
    800020ae:	ff279ce3          	bne	a5,s2,800020a6 <bread+0x36>
    800020b2:	44dc                	lw	a5,12(s1)
    800020b4:	ff3799e3          	bne	a5,s3,800020a6 <bread+0x36>
      b->refcnt++;
    800020b8:	40bc                	lw	a5,64(s1)
    800020ba:	2785                	addiw	a5,a5,1
    800020bc:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020be:	0000e517          	auipc	a0,0xe
    800020c2:	03a50513          	addi	a0,a0,58 # 800100f8 <bcache>
    800020c6:	618040ef          	jal	800066de <release>
      acquiresleep(&b->lock);
    800020ca:	01048513          	addi	a0,s1,16
    800020ce:	2da010ef          	jal	800033a8 <acquiresleep>
      return b;
    800020d2:	a889                	j	80002124 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020d4:	00016497          	auipc	s1,0x16
    800020d8:	2d44b483          	ld	s1,724(s1) # 800183a8 <bcache+0x82b0>
    800020dc:	00016797          	auipc	a5,0x16
    800020e0:	28478793          	addi	a5,a5,644 # 80018360 <bcache+0x8268>
    800020e4:	00f48863          	beq	s1,a5,800020f4 <bread+0x84>
    800020e8:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800020ea:	40bc                	lw	a5,64(s1)
    800020ec:	cb91                	beqz	a5,80002100 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800020ee:	64a4                	ld	s1,72(s1)
    800020f0:	fee49de3          	bne	s1,a4,800020ea <bread+0x7a>
  panic("bget: no buffers");
    800020f4:	00006517          	auipc	a0,0x6
    800020f8:	26450513          	addi	a0,a0,612 # 80008358 <etext+0x358>
    800020fc:	28c040ef          	jal	80006388 <panic>
      b->dev = dev;
    80002100:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002104:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002108:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000210c:	4785                	li	a5,1
    8000210e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002110:	0000e517          	auipc	a0,0xe
    80002114:	fe850513          	addi	a0,a0,-24 # 800100f8 <bcache>
    80002118:	5c6040ef          	jal	800066de <release>
      acquiresleep(&b->lock);
    8000211c:	01048513          	addi	a0,s1,16
    80002120:	288010ef          	jal	800033a8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002124:	409c                	lw	a5,0(s1)
    80002126:	cb89                	beqz	a5,80002138 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002128:	8526                	mv	a0,s1
    8000212a:	70a2                	ld	ra,40(sp)
    8000212c:	7402                	ld	s0,32(sp)
    8000212e:	64e2                	ld	s1,24(sp)
    80002130:	6942                	ld	s2,16(sp)
    80002132:	69a2                	ld	s3,8(sp)
    80002134:	6145                	addi	sp,sp,48
    80002136:	8082                	ret
    virtio_disk_rw(b, 0);
    80002138:	4581                	li	a1,0
    8000213a:	8526                	mv	a0,s1
    8000213c:	305020ef          	jal	80004c40 <virtio_disk_rw>
    b->valid = 1;
    80002140:	4785                	li	a5,1
    80002142:	c09c                	sw	a5,0(s1)
  return b;
    80002144:	b7d5                	j	80002128 <bread+0xb8>

0000000080002146 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002146:	1101                	addi	sp,sp,-32
    80002148:	ec06                	sd	ra,24(sp)
    8000214a:	e822                	sd	s0,16(sp)
    8000214c:	e426                	sd	s1,8(sp)
    8000214e:	1000                	addi	s0,sp,32
    80002150:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002152:	0541                	addi	a0,a0,16
    80002154:	2d2010ef          	jal	80003426 <holdingsleep>
    80002158:	c911                	beqz	a0,8000216c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000215a:	4585                	li	a1,1
    8000215c:	8526                	mv	a0,s1
    8000215e:	2e3020ef          	jal	80004c40 <virtio_disk_rw>
}
    80002162:	60e2                	ld	ra,24(sp)
    80002164:	6442                	ld	s0,16(sp)
    80002166:	64a2                	ld	s1,8(sp)
    80002168:	6105                	addi	sp,sp,32
    8000216a:	8082                	ret
    panic("bwrite");
    8000216c:	00006517          	auipc	a0,0x6
    80002170:	20450513          	addi	a0,a0,516 # 80008370 <etext+0x370>
    80002174:	214040ef          	jal	80006388 <panic>

0000000080002178 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002178:	1101                	addi	sp,sp,-32
    8000217a:	ec06                	sd	ra,24(sp)
    8000217c:	e822                	sd	s0,16(sp)
    8000217e:	e426                	sd	s1,8(sp)
    80002180:	e04a                	sd	s2,0(sp)
    80002182:	1000                	addi	s0,sp,32
    80002184:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002186:	01050913          	addi	s2,a0,16
    8000218a:	854a                	mv	a0,s2
    8000218c:	29a010ef          	jal	80003426 <holdingsleep>
    80002190:	c125                	beqz	a0,800021f0 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002192:	854a                	mv	a0,s2
    80002194:	25a010ef          	jal	800033ee <releasesleep>

  acquire(&bcache.lock);
    80002198:	0000e517          	auipc	a0,0xe
    8000219c:	f6050513          	addi	a0,a0,-160 # 800100f8 <bcache>
    800021a0:	4aa040ef          	jal	8000664a <acquire>
  b->refcnt--;
    800021a4:	40bc                	lw	a5,64(s1)
    800021a6:	37fd                	addiw	a5,a5,-1
    800021a8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800021aa:	e79d                	bnez	a5,800021d8 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800021ac:	68b8                	ld	a4,80(s1)
    800021ae:	64bc                	ld	a5,72(s1)
    800021b0:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800021b2:	68b8                	ld	a4,80(s1)
    800021b4:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800021b6:	00016797          	auipc	a5,0x16
    800021ba:	f4278793          	addi	a5,a5,-190 # 800180f8 <bcache+0x8000>
    800021be:	2b87b703          	ld	a4,696(a5)
    800021c2:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800021c4:	00016717          	auipc	a4,0x16
    800021c8:	19c70713          	addi	a4,a4,412 # 80018360 <bcache+0x8268>
    800021cc:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800021ce:	2b87b703          	ld	a4,696(a5)
    800021d2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800021d4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800021d8:	0000e517          	auipc	a0,0xe
    800021dc:	f2050513          	addi	a0,a0,-224 # 800100f8 <bcache>
    800021e0:	4fe040ef          	jal	800066de <release>
}
    800021e4:	60e2                	ld	ra,24(sp)
    800021e6:	6442                	ld	s0,16(sp)
    800021e8:	64a2                	ld	s1,8(sp)
    800021ea:	6902                	ld	s2,0(sp)
    800021ec:	6105                	addi	sp,sp,32
    800021ee:	8082                	ret
    panic("brelse");
    800021f0:	00006517          	auipc	a0,0x6
    800021f4:	18850513          	addi	a0,a0,392 # 80008378 <etext+0x378>
    800021f8:	190040ef          	jal	80006388 <panic>

00000000800021fc <bpin>:

void
bpin(struct buf *b) {
    800021fc:	1101                	addi	sp,sp,-32
    800021fe:	ec06                	sd	ra,24(sp)
    80002200:	e822                	sd	s0,16(sp)
    80002202:	e426                	sd	s1,8(sp)
    80002204:	1000                	addi	s0,sp,32
    80002206:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002208:	0000e517          	auipc	a0,0xe
    8000220c:	ef050513          	addi	a0,a0,-272 # 800100f8 <bcache>
    80002210:	43a040ef          	jal	8000664a <acquire>
  b->refcnt++;
    80002214:	40bc                	lw	a5,64(s1)
    80002216:	2785                	addiw	a5,a5,1
    80002218:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000221a:	0000e517          	auipc	a0,0xe
    8000221e:	ede50513          	addi	a0,a0,-290 # 800100f8 <bcache>
    80002222:	4bc040ef          	jal	800066de <release>
}
    80002226:	60e2                	ld	ra,24(sp)
    80002228:	6442                	ld	s0,16(sp)
    8000222a:	64a2                	ld	s1,8(sp)
    8000222c:	6105                	addi	sp,sp,32
    8000222e:	8082                	ret

0000000080002230 <bunpin>:

void
bunpin(struct buf *b) {
    80002230:	1101                	addi	sp,sp,-32
    80002232:	ec06                	sd	ra,24(sp)
    80002234:	e822                	sd	s0,16(sp)
    80002236:	e426                	sd	s1,8(sp)
    80002238:	1000                	addi	s0,sp,32
    8000223a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000223c:	0000e517          	auipc	a0,0xe
    80002240:	ebc50513          	addi	a0,a0,-324 # 800100f8 <bcache>
    80002244:	406040ef          	jal	8000664a <acquire>
  b->refcnt--;
    80002248:	40bc                	lw	a5,64(s1)
    8000224a:	37fd                	addiw	a5,a5,-1
    8000224c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000224e:	0000e517          	auipc	a0,0xe
    80002252:	eaa50513          	addi	a0,a0,-342 # 800100f8 <bcache>
    80002256:	488040ef          	jal	800066de <release>
}
    8000225a:	60e2                	ld	ra,24(sp)
    8000225c:	6442                	ld	s0,16(sp)
    8000225e:	64a2                	ld	s1,8(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret

0000000080002264 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002264:	1101                	addi	sp,sp,-32
    80002266:	ec06                	sd	ra,24(sp)
    80002268:	e822                	sd	s0,16(sp)
    8000226a:	e426                	sd	s1,8(sp)
    8000226c:	e04a                	sd	s2,0(sp)
    8000226e:	1000                	addi	s0,sp,32
    80002270:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002272:	00d5d79b          	srliw	a5,a1,0xd
    80002276:	00016597          	auipc	a1,0x16
    8000227a:	55e5a583          	lw	a1,1374(a1) # 800187d4 <sb+0x1c>
    8000227e:	9dbd                	addw	a1,a1,a5
    80002280:	df1ff0ef          	jal	80002070 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002284:	0074f713          	andi	a4,s1,7
    80002288:	4785                	li	a5,1
    8000228a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000228e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002290:	90d9                	srli	s1,s1,0x36
    80002292:	00950733          	add	a4,a0,s1
    80002296:	05874703          	lbu	a4,88(a4)
    8000229a:	00e7f6b3          	and	a3,a5,a4
    8000229e:	c29d                	beqz	a3,800022c4 <bfree+0x60>
    800022a0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800022a2:	94aa                	add	s1,s1,a0
    800022a4:	fff7c793          	not	a5,a5
    800022a8:	8f7d                	and	a4,a4,a5
    800022aa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800022ae:	000010ef          	jal	800032ae <log_write>
  brelse(bp);
    800022b2:	854a                	mv	a0,s2
    800022b4:	ec5ff0ef          	jal	80002178 <brelse>
}
    800022b8:	60e2                	ld	ra,24(sp)
    800022ba:	6442                	ld	s0,16(sp)
    800022bc:	64a2                	ld	s1,8(sp)
    800022be:	6902                	ld	s2,0(sp)
    800022c0:	6105                	addi	sp,sp,32
    800022c2:	8082                	ret
    panic("freeing free block");
    800022c4:	00006517          	auipc	a0,0x6
    800022c8:	0bc50513          	addi	a0,a0,188 # 80008380 <etext+0x380>
    800022cc:	0bc040ef          	jal	80006388 <panic>

00000000800022d0 <balloc>:
{
    800022d0:	715d                	addi	sp,sp,-80
    800022d2:	e486                	sd	ra,72(sp)
    800022d4:	e0a2                	sd	s0,64(sp)
    800022d6:	fc26                	sd	s1,56(sp)
    800022d8:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800022da:	00016797          	auipc	a5,0x16
    800022de:	4e27a783          	lw	a5,1250(a5) # 800187bc <sb+0x4>
    800022e2:	0e078263          	beqz	a5,800023c6 <balloc+0xf6>
    800022e6:	f84a                	sd	s2,48(sp)
    800022e8:	f44e                	sd	s3,40(sp)
    800022ea:	f052                	sd	s4,32(sp)
    800022ec:	ec56                	sd	s5,24(sp)
    800022ee:	e85a                	sd	s6,16(sp)
    800022f0:	e45e                	sd	s7,8(sp)
    800022f2:	e062                	sd	s8,0(sp)
    800022f4:	8baa                	mv	s7,a0
    800022f6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022f8:	00016b17          	auipc	s6,0x16
    800022fc:	4c0b0b13          	addi	s6,s6,1216 # 800187b8 <sb>
      m = 1 << (bi % 8);
    80002300:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002302:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002304:	6c09                	lui	s8,0x2
    80002306:	a09d                	j	8000236c <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002308:	97ca                	add	a5,a5,s2
    8000230a:	8e55                	or	a2,a2,a3
    8000230c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002310:	854a                	mv	a0,s2
    80002312:	79d000ef          	jal	800032ae <log_write>
        brelse(bp);
    80002316:	854a                	mv	a0,s2
    80002318:	e61ff0ef          	jal	80002178 <brelse>
  bp = bread(dev, bno);
    8000231c:	85a6                	mv	a1,s1
    8000231e:	855e                	mv	a0,s7
    80002320:	d51ff0ef          	jal	80002070 <bread>
    80002324:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002326:	40000613          	li	a2,1024
    8000232a:	4581                	li	a1,0
    8000232c:	05850513          	addi	a0,a0,88
    80002330:	e2ffd0ef          	jal	8000015e <memset>
  log_write(bp);
    80002334:	854a                	mv	a0,s2
    80002336:	779000ef          	jal	800032ae <log_write>
  brelse(bp);
    8000233a:	854a                	mv	a0,s2
    8000233c:	e3dff0ef          	jal	80002178 <brelse>
}
    80002340:	7942                	ld	s2,48(sp)
    80002342:	79a2                	ld	s3,40(sp)
    80002344:	7a02                	ld	s4,32(sp)
    80002346:	6ae2                	ld	s5,24(sp)
    80002348:	6b42                	ld	s6,16(sp)
    8000234a:	6ba2                	ld	s7,8(sp)
    8000234c:	6c02                	ld	s8,0(sp)
}
    8000234e:	8526                	mv	a0,s1
    80002350:	60a6                	ld	ra,72(sp)
    80002352:	6406                	ld	s0,64(sp)
    80002354:	74e2                	ld	s1,56(sp)
    80002356:	6161                	addi	sp,sp,80
    80002358:	8082                	ret
    brelse(bp);
    8000235a:	854a                	mv	a0,s2
    8000235c:	e1dff0ef          	jal	80002178 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002360:	015c0abb          	addw	s5,s8,s5
    80002364:	004b2783          	lw	a5,4(s6)
    80002368:	04faf863          	bgeu	s5,a5,800023b8 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    8000236c:	40dad59b          	sraiw	a1,s5,0xd
    80002370:	01cb2783          	lw	a5,28(s6)
    80002374:	9dbd                	addw	a1,a1,a5
    80002376:	855e                	mv	a0,s7
    80002378:	cf9ff0ef          	jal	80002070 <bread>
    8000237c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000237e:	004b2503          	lw	a0,4(s6)
    80002382:	84d6                	mv	s1,s5
    80002384:	4701                	li	a4,0
    80002386:	fca4fae3          	bgeu	s1,a0,8000235a <balloc+0x8a>
      m = 1 << (bi % 8);
    8000238a:	00777693          	andi	a3,a4,7
    8000238e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002392:	41f7579b          	sraiw	a5,a4,0x1f
    80002396:	01d7d79b          	srliw	a5,a5,0x1d
    8000239a:	9fb9                	addw	a5,a5,a4
    8000239c:	4037d79b          	sraiw	a5,a5,0x3
    800023a0:	00f90633          	add	a2,s2,a5
    800023a4:	05864603          	lbu	a2,88(a2)
    800023a8:	00c6f5b3          	and	a1,a3,a2
    800023ac:	ddb1                	beqz	a1,80002308 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023ae:	2705                	addiw	a4,a4,1
    800023b0:	2485                	addiw	s1,s1,1
    800023b2:	fd471ae3          	bne	a4,s4,80002386 <balloc+0xb6>
    800023b6:	b755                	j	8000235a <balloc+0x8a>
    800023b8:	7942                	ld	s2,48(sp)
    800023ba:	79a2                	ld	s3,40(sp)
    800023bc:	7a02                	ld	s4,32(sp)
    800023be:	6ae2                	ld	s5,24(sp)
    800023c0:	6b42                	ld	s6,16(sp)
    800023c2:	6ba2                	ld	s7,8(sp)
    800023c4:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800023c6:	00006517          	auipc	a0,0x6
    800023ca:	fd250513          	addi	a0,a0,-46 # 80008398 <etext+0x398>
    800023ce:	491030ef          	jal	8000605e <printf>
  return 0;
    800023d2:	4481                	li	s1,0
    800023d4:	bfad                	j	8000234e <balloc+0x7e>

00000000800023d6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800023d6:	7179                	addi	sp,sp,-48
    800023d8:	f406                	sd	ra,40(sp)
    800023da:	f022                	sd	s0,32(sp)
    800023dc:	ec26                	sd	s1,24(sp)
    800023de:	e84a                	sd	s2,16(sp)
    800023e0:	e44e                	sd	s3,8(sp)
    800023e2:	1800                	addi	s0,sp,48
    800023e4:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800023e6:	47ad                	li	a5,11
    800023e8:	02b7e363          	bltu	a5,a1,8000240e <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800023ec:	02059793          	slli	a5,a1,0x20
    800023f0:	01e7d593          	srli	a1,a5,0x1e
    800023f4:	00b509b3          	add	s3,a0,a1
    800023f8:	0509a483          	lw	s1,80(s3)
    800023fc:	e0b5                	bnez	s1,80002460 <bmap+0x8a>
      addr = balloc(ip->dev);
    800023fe:	4108                	lw	a0,0(a0)
    80002400:	ed1ff0ef          	jal	800022d0 <balloc>
    80002404:	84aa                	mv	s1,a0
      if(addr == 0)
    80002406:	cd29                	beqz	a0,80002460 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002408:	04a9a823          	sw	a0,80(s3)
    8000240c:	a891                	j	80002460 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000240e:	ff45879b          	addiw	a5,a1,-12
    80002412:	873e                	mv	a4,a5
    80002414:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80002416:	0ff00793          	li	a5,255
    8000241a:	06e7e763          	bltu	a5,a4,80002488 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000241e:	08052483          	lw	s1,128(a0)
    80002422:	e891                	bnez	s1,80002436 <bmap+0x60>
      addr = balloc(ip->dev);
    80002424:	4108                	lw	a0,0(a0)
    80002426:	eabff0ef          	jal	800022d0 <balloc>
    8000242a:	84aa                	mv	s1,a0
      if(addr == 0)
    8000242c:	c915                	beqz	a0,80002460 <bmap+0x8a>
    8000242e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002430:	08a92023          	sw	a0,128(s2)
    80002434:	a011                	j	80002438 <bmap+0x62>
    80002436:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002438:	85a6                	mv	a1,s1
    8000243a:	00092503          	lw	a0,0(s2)
    8000243e:	c33ff0ef          	jal	80002070 <bread>
    80002442:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002444:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002448:	02099713          	slli	a4,s3,0x20
    8000244c:	01e75593          	srli	a1,a4,0x1e
    80002450:	97ae                	add	a5,a5,a1
    80002452:	89be                	mv	s3,a5
    80002454:	4384                	lw	s1,0(a5)
    80002456:	cc89                	beqz	s1,80002470 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002458:	8552                	mv	a0,s4
    8000245a:	d1fff0ef          	jal	80002178 <brelse>
    return addr;
    8000245e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002460:	8526                	mv	a0,s1
    80002462:	70a2                	ld	ra,40(sp)
    80002464:	7402                	ld	s0,32(sp)
    80002466:	64e2                	ld	s1,24(sp)
    80002468:	6942                	ld	s2,16(sp)
    8000246a:	69a2                	ld	s3,8(sp)
    8000246c:	6145                	addi	sp,sp,48
    8000246e:	8082                	ret
      addr = balloc(ip->dev);
    80002470:	00092503          	lw	a0,0(s2)
    80002474:	e5dff0ef          	jal	800022d0 <balloc>
    80002478:	84aa                	mv	s1,a0
      if(addr){
    8000247a:	dd79                	beqz	a0,80002458 <bmap+0x82>
        a[bn] = addr;
    8000247c:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002480:	8552                	mv	a0,s4
    80002482:	62d000ef          	jal	800032ae <log_write>
    80002486:	bfc9                	j	80002458 <bmap+0x82>
    80002488:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000248a:	00006517          	auipc	a0,0x6
    8000248e:	f2650513          	addi	a0,a0,-218 # 800083b0 <etext+0x3b0>
    80002492:	6f7030ef          	jal	80006388 <panic>

0000000080002496 <iget>:
{
    80002496:	7179                	addi	sp,sp,-48
    80002498:	f406                	sd	ra,40(sp)
    8000249a:	f022                	sd	s0,32(sp)
    8000249c:	ec26                	sd	s1,24(sp)
    8000249e:	e84a                	sd	s2,16(sp)
    800024a0:	e44e                	sd	s3,8(sp)
    800024a2:	e052                	sd	s4,0(sp)
    800024a4:	1800                	addi	s0,sp,48
    800024a6:	892a                	mv	s2,a0
    800024a8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800024aa:	00016517          	auipc	a0,0x16
    800024ae:	32e50513          	addi	a0,a0,814 # 800187d8 <itable>
    800024b2:	198040ef          	jal	8000664a <acquire>
  empty = 0;
    800024b6:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024b8:	00016497          	auipc	s1,0x16
    800024bc:	33848493          	addi	s1,s1,824 # 800187f0 <itable+0x18>
    800024c0:	00018697          	auipc	a3,0x18
    800024c4:	dc068693          	addi	a3,a3,-576 # 8001a280 <log>
    800024c8:	a809                	j	800024da <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024ca:	e781                	bnez	a5,800024d2 <iget+0x3c>
    800024cc:	00099363          	bnez	s3,800024d2 <iget+0x3c>
      empty = ip;
    800024d0:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024d2:	08848493          	addi	s1,s1,136
    800024d6:	02d48563          	beq	s1,a3,80002500 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024da:	449c                	lw	a5,8(s1)
    800024dc:	fef057e3          	blez	a5,800024ca <iget+0x34>
    800024e0:	4098                	lw	a4,0(s1)
    800024e2:	ff2718e3          	bne	a4,s2,800024d2 <iget+0x3c>
    800024e6:	40d8                	lw	a4,4(s1)
    800024e8:	ff4715e3          	bne	a4,s4,800024d2 <iget+0x3c>
      ip->ref++;
    800024ec:	2785                	addiw	a5,a5,1
    800024ee:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024f0:	00016517          	auipc	a0,0x16
    800024f4:	2e850513          	addi	a0,a0,744 # 800187d8 <itable>
    800024f8:	1e6040ef          	jal	800066de <release>
      return ip;
    800024fc:	89a6                	mv	s3,s1
    800024fe:	a015                	j	80002522 <iget+0x8c>
  if(empty == 0)
    80002500:	02098a63          	beqz	s3,80002534 <iget+0x9e>
  ip->dev = dev;
    80002504:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002508:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    8000250c:	4785                	li	a5,1
    8000250e:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002512:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80002516:	00016517          	auipc	a0,0x16
    8000251a:	2c250513          	addi	a0,a0,706 # 800187d8 <itable>
    8000251e:	1c0040ef          	jal	800066de <release>
}
    80002522:	854e                	mv	a0,s3
    80002524:	70a2                	ld	ra,40(sp)
    80002526:	7402                	ld	s0,32(sp)
    80002528:	64e2                	ld	s1,24(sp)
    8000252a:	6942                	ld	s2,16(sp)
    8000252c:	69a2                	ld	s3,8(sp)
    8000252e:	6a02                	ld	s4,0(sp)
    80002530:	6145                	addi	sp,sp,48
    80002532:	8082                	ret
    panic("iget: no inodes");
    80002534:	00006517          	auipc	a0,0x6
    80002538:	e9450513          	addi	a0,a0,-364 # 800083c8 <etext+0x3c8>
    8000253c:	64d030ef          	jal	80006388 <panic>

0000000080002540 <iinit>:
{
    80002540:	7179                	addi	sp,sp,-48
    80002542:	f406                	sd	ra,40(sp)
    80002544:	f022                	sd	s0,32(sp)
    80002546:	ec26                	sd	s1,24(sp)
    80002548:	e84a                	sd	s2,16(sp)
    8000254a:	e44e                	sd	s3,8(sp)
    8000254c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000254e:	00006597          	auipc	a1,0x6
    80002552:	e8a58593          	addi	a1,a1,-374 # 800083d8 <etext+0x3d8>
    80002556:	00016517          	auipc	a0,0x16
    8000255a:	28250513          	addi	a0,a0,642 # 800187d8 <itable>
    8000255e:	062040ef          	jal	800065c0 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002562:	00016497          	auipc	s1,0x16
    80002566:	29e48493          	addi	s1,s1,670 # 80018800 <itable+0x28>
    8000256a:	00018997          	auipc	s3,0x18
    8000256e:	d2698993          	addi	s3,s3,-730 # 8001a290 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002572:	00006917          	auipc	s2,0x6
    80002576:	e6e90913          	addi	s2,s2,-402 # 800083e0 <etext+0x3e0>
    8000257a:	85ca                	mv	a1,s2
    8000257c:	8526                	mv	a0,s1
    8000257e:	5f5000ef          	jal	80003372 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002582:	08848493          	addi	s1,s1,136
    80002586:	ff349ae3          	bne	s1,s3,8000257a <iinit+0x3a>
}
    8000258a:	70a2                	ld	ra,40(sp)
    8000258c:	7402                	ld	s0,32(sp)
    8000258e:	64e2                	ld	s1,24(sp)
    80002590:	6942                	ld	s2,16(sp)
    80002592:	69a2                	ld	s3,8(sp)
    80002594:	6145                	addi	sp,sp,48
    80002596:	8082                	ret

0000000080002598 <ialloc>:
{
    80002598:	7139                	addi	sp,sp,-64
    8000259a:	fc06                	sd	ra,56(sp)
    8000259c:	f822                	sd	s0,48(sp)
    8000259e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800025a0:	00016717          	auipc	a4,0x16
    800025a4:	22472703          	lw	a4,548(a4) # 800187c4 <sb+0xc>
    800025a8:	4785                	li	a5,1
    800025aa:	06e7f063          	bgeu	a5,a4,8000260a <ialloc+0x72>
    800025ae:	f426                	sd	s1,40(sp)
    800025b0:	f04a                	sd	s2,32(sp)
    800025b2:	ec4e                	sd	s3,24(sp)
    800025b4:	e852                	sd	s4,16(sp)
    800025b6:	e456                	sd	s5,8(sp)
    800025b8:	e05a                	sd	s6,0(sp)
    800025ba:	8aaa                	mv	s5,a0
    800025bc:	8b2e                	mv	s6,a1
    800025be:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800025c0:	00016a17          	auipc	s4,0x16
    800025c4:	1f8a0a13          	addi	s4,s4,504 # 800187b8 <sb>
    800025c8:	00495593          	srli	a1,s2,0x4
    800025cc:	018a2783          	lw	a5,24(s4)
    800025d0:	9dbd                	addw	a1,a1,a5
    800025d2:	8556                	mv	a0,s5
    800025d4:	a9dff0ef          	jal	80002070 <bread>
    800025d8:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025da:	05850993          	addi	s3,a0,88
    800025de:	00f97793          	andi	a5,s2,15
    800025e2:	079a                	slli	a5,a5,0x6
    800025e4:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025e6:	00099783          	lh	a5,0(s3)
    800025ea:	cb9d                	beqz	a5,80002620 <ialloc+0x88>
    brelse(bp);
    800025ec:	b8dff0ef          	jal	80002178 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025f0:	0905                	addi	s2,s2,1
    800025f2:	00ca2703          	lw	a4,12(s4)
    800025f6:	0009079b          	sext.w	a5,s2
    800025fa:	fce7e7e3          	bltu	a5,a4,800025c8 <ialloc+0x30>
    800025fe:	74a2                	ld	s1,40(sp)
    80002600:	7902                	ld	s2,32(sp)
    80002602:	69e2                	ld	s3,24(sp)
    80002604:	6a42                	ld	s4,16(sp)
    80002606:	6aa2                	ld	s5,8(sp)
    80002608:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000260a:	00006517          	auipc	a0,0x6
    8000260e:	dde50513          	addi	a0,a0,-546 # 800083e8 <etext+0x3e8>
    80002612:	24d030ef          	jal	8000605e <printf>
  return 0;
    80002616:	4501                	li	a0,0
}
    80002618:	70e2                	ld	ra,56(sp)
    8000261a:	7442                	ld	s0,48(sp)
    8000261c:	6121                	addi	sp,sp,64
    8000261e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002620:	04000613          	li	a2,64
    80002624:	4581                	li	a1,0
    80002626:	854e                	mv	a0,s3
    80002628:	b37fd0ef          	jal	8000015e <memset>
      dip->type = type;
    8000262c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002630:	8526                	mv	a0,s1
    80002632:	47d000ef          	jal	800032ae <log_write>
      brelse(bp);
    80002636:	8526                	mv	a0,s1
    80002638:	b41ff0ef          	jal	80002178 <brelse>
      return iget(dev, inum);
    8000263c:	0009059b          	sext.w	a1,s2
    80002640:	8556                	mv	a0,s5
    80002642:	e55ff0ef          	jal	80002496 <iget>
    80002646:	74a2                	ld	s1,40(sp)
    80002648:	7902                	ld	s2,32(sp)
    8000264a:	69e2                	ld	s3,24(sp)
    8000264c:	6a42                	ld	s4,16(sp)
    8000264e:	6aa2                	ld	s5,8(sp)
    80002650:	6b02                	ld	s6,0(sp)
    80002652:	b7d9                	j	80002618 <ialloc+0x80>

0000000080002654 <iupdate>:
{
    80002654:	1101                	addi	sp,sp,-32
    80002656:	ec06                	sd	ra,24(sp)
    80002658:	e822                	sd	s0,16(sp)
    8000265a:	e426                	sd	s1,8(sp)
    8000265c:	e04a                	sd	s2,0(sp)
    8000265e:	1000                	addi	s0,sp,32
    80002660:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002662:	415c                	lw	a5,4(a0)
    80002664:	0047d79b          	srliw	a5,a5,0x4
    80002668:	00016597          	auipc	a1,0x16
    8000266c:	1685a583          	lw	a1,360(a1) # 800187d0 <sb+0x18>
    80002670:	9dbd                	addw	a1,a1,a5
    80002672:	4108                	lw	a0,0(a0)
    80002674:	9fdff0ef          	jal	80002070 <bread>
    80002678:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000267a:	05850793          	addi	a5,a0,88
    8000267e:	40d8                	lw	a4,4(s1)
    80002680:	8b3d                	andi	a4,a4,15
    80002682:	071a                	slli	a4,a4,0x6
    80002684:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002686:	04449703          	lh	a4,68(s1)
    8000268a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000268e:	04649703          	lh	a4,70(s1)
    80002692:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002696:	04849703          	lh	a4,72(s1)
    8000269a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000269e:	04a49703          	lh	a4,74(s1)
    800026a2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800026a6:	44f8                	lw	a4,76(s1)
    800026a8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026aa:	03400613          	li	a2,52
    800026ae:	05048593          	addi	a1,s1,80
    800026b2:	00c78513          	addi	a0,a5,12
    800026b6:	b09fd0ef          	jal	800001be <memmove>
  log_write(bp);
    800026ba:	854a                	mv	a0,s2
    800026bc:	3f3000ef          	jal	800032ae <log_write>
  brelse(bp);
    800026c0:	854a                	mv	a0,s2
    800026c2:	ab7ff0ef          	jal	80002178 <brelse>
}
    800026c6:	60e2                	ld	ra,24(sp)
    800026c8:	6442                	ld	s0,16(sp)
    800026ca:	64a2                	ld	s1,8(sp)
    800026cc:	6902                	ld	s2,0(sp)
    800026ce:	6105                	addi	sp,sp,32
    800026d0:	8082                	ret

00000000800026d2 <idup>:
{
    800026d2:	1101                	addi	sp,sp,-32
    800026d4:	ec06                	sd	ra,24(sp)
    800026d6:	e822                	sd	s0,16(sp)
    800026d8:	e426                	sd	s1,8(sp)
    800026da:	1000                	addi	s0,sp,32
    800026dc:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026de:	00016517          	auipc	a0,0x16
    800026e2:	0fa50513          	addi	a0,a0,250 # 800187d8 <itable>
    800026e6:	765030ef          	jal	8000664a <acquire>
  ip->ref++;
    800026ea:	449c                	lw	a5,8(s1)
    800026ec:	2785                	addiw	a5,a5,1
    800026ee:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026f0:	00016517          	auipc	a0,0x16
    800026f4:	0e850513          	addi	a0,a0,232 # 800187d8 <itable>
    800026f8:	7e7030ef          	jal	800066de <release>
}
    800026fc:	8526                	mv	a0,s1
    800026fe:	60e2                	ld	ra,24(sp)
    80002700:	6442                	ld	s0,16(sp)
    80002702:	64a2                	ld	s1,8(sp)
    80002704:	6105                	addi	sp,sp,32
    80002706:	8082                	ret

0000000080002708 <ilock>:
{
    80002708:	1101                	addi	sp,sp,-32
    8000270a:	ec06                	sd	ra,24(sp)
    8000270c:	e822                	sd	s0,16(sp)
    8000270e:	e426                	sd	s1,8(sp)
    80002710:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002712:	cd19                	beqz	a0,80002730 <ilock+0x28>
    80002714:	84aa                	mv	s1,a0
    80002716:	451c                	lw	a5,8(a0)
    80002718:	00f05c63          	blez	a5,80002730 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000271c:	0541                	addi	a0,a0,16
    8000271e:	48b000ef          	jal	800033a8 <acquiresleep>
  if(ip->valid == 0){
    80002722:	40bc                	lw	a5,64(s1)
    80002724:	cf89                	beqz	a5,8000273e <ilock+0x36>
}
    80002726:	60e2                	ld	ra,24(sp)
    80002728:	6442                	ld	s0,16(sp)
    8000272a:	64a2                	ld	s1,8(sp)
    8000272c:	6105                	addi	sp,sp,32
    8000272e:	8082                	ret
    80002730:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002732:	00006517          	auipc	a0,0x6
    80002736:	cce50513          	addi	a0,a0,-818 # 80008400 <etext+0x400>
    8000273a:	44f030ef          	jal	80006388 <panic>
    8000273e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002740:	40dc                	lw	a5,4(s1)
    80002742:	0047d79b          	srliw	a5,a5,0x4
    80002746:	00016597          	auipc	a1,0x16
    8000274a:	08a5a583          	lw	a1,138(a1) # 800187d0 <sb+0x18>
    8000274e:	9dbd                	addw	a1,a1,a5
    80002750:	4088                	lw	a0,0(s1)
    80002752:	91fff0ef          	jal	80002070 <bread>
    80002756:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002758:	05850593          	addi	a1,a0,88
    8000275c:	40dc                	lw	a5,4(s1)
    8000275e:	8bbd                	andi	a5,a5,15
    80002760:	079a                	slli	a5,a5,0x6
    80002762:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002764:	00059783          	lh	a5,0(a1)
    80002768:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000276c:	00259783          	lh	a5,2(a1)
    80002770:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002774:	00459783          	lh	a5,4(a1)
    80002778:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000277c:	00659783          	lh	a5,6(a1)
    80002780:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002784:	459c                	lw	a5,8(a1)
    80002786:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002788:	03400613          	li	a2,52
    8000278c:	05b1                	addi	a1,a1,12
    8000278e:	05048513          	addi	a0,s1,80
    80002792:	a2dfd0ef          	jal	800001be <memmove>
    brelse(bp);
    80002796:	854a                	mv	a0,s2
    80002798:	9e1ff0ef          	jal	80002178 <brelse>
    ip->valid = 1;
    8000279c:	4785                	li	a5,1
    8000279e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027a0:	04449783          	lh	a5,68(s1)
    800027a4:	c399                	beqz	a5,800027aa <ilock+0xa2>
    800027a6:	6902                	ld	s2,0(sp)
    800027a8:	bfbd                	j	80002726 <ilock+0x1e>
      panic("ilock: no type");
    800027aa:	00006517          	auipc	a0,0x6
    800027ae:	c5e50513          	addi	a0,a0,-930 # 80008408 <etext+0x408>
    800027b2:	3d7030ef          	jal	80006388 <panic>

00000000800027b6 <iunlock>:
{
    800027b6:	1101                	addi	sp,sp,-32
    800027b8:	ec06                	sd	ra,24(sp)
    800027ba:	e822                	sd	s0,16(sp)
    800027bc:	e426                	sd	s1,8(sp)
    800027be:	e04a                	sd	s2,0(sp)
    800027c0:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027c2:	c505                	beqz	a0,800027ea <iunlock+0x34>
    800027c4:	84aa                	mv	s1,a0
    800027c6:	01050913          	addi	s2,a0,16
    800027ca:	854a                	mv	a0,s2
    800027cc:	45b000ef          	jal	80003426 <holdingsleep>
    800027d0:	cd09                	beqz	a0,800027ea <iunlock+0x34>
    800027d2:	449c                	lw	a5,8(s1)
    800027d4:	00f05b63          	blez	a5,800027ea <iunlock+0x34>
  releasesleep(&ip->lock);
    800027d8:	854a                	mv	a0,s2
    800027da:	415000ef          	jal	800033ee <releasesleep>
}
    800027de:	60e2                	ld	ra,24(sp)
    800027e0:	6442                	ld	s0,16(sp)
    800027e2:	64a2                	ld	s1,8(sp)
    800027e4:	6902                	ld	s2,0(sp)
    800027e6:	6105                	addi	sp,sp,32
    800027e8:	8082                	ret
    panic("iunlock");
    800027ea:	00006517          	auipc	a0,0x6
    800027ee:	c2e50513          	addi	a0,a0,-978 # 80008418 <etext+0x418>
    800027f2:	397030ef          	jal	80006388 <panic>

00000000800027f6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027f6:	7179                	addi	sp,sp,-48
    800027f8:	f406                	sd	ra,40(sp)
    800027fa:	f022                	sd	s0,32(sp)
    800027fc:	ec26                	sd	s1,24(sp)
    800027fe:	e84a                	sd	s2,16(sp)
    80002800:	e44e                	sd	s3,8(sp)
    80002802:	1800                	addi	s0,sp,48
    80002804:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002806:	05050493          	addi	s1,a0,80
    8000280a:	08050913          	addi	s2,a0,128
    8000280e:	a021                	j	80002816 <itrunc+0x20>
    80002810:	0491                	addi	s1,s1,4
    80002812:	01248b63          	beq	s1,s2,80002828 <itrunc+0x32>
    if(ip->addrs[i]){
    80002816:	408c                	lw	a1,0(s1)
    80002818:	dde5                	beqz	a1,80002810 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000281a:	0009a503          	lw	a0,0(s3)
    8000281e:	a47ff0ef          	jal	80002264 <bfree>
      ip->addrs[i] = 0;
    80002822:	0004a023          	sw	zero,0(s1)
    80002826:	b7ed                	j	80002810 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002828:	0809a583          	lw	a1,128(s3)
    8000282c:	ed89                	bnez	a1,80002846 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000282e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002832:	854e                	mv	a0,s3
    80002834:	e21ff0ef          	jal	80002654 <iupdate>
}
    80002838:	70a2                	ld	ra,40(sp)
    8000283a:	7402                	ld	s0,32(sp)
    8000283c:	64e2                	ld	s1,24(sp)
    8000283e:	6942                	ld	s2,16(sp)
    80002840:	69a2                	ld	s3,8(sp)
    80002842:	6145                	addi	sp,sp,48
    80002844:	8082                	ret
    80002846:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002848:	0009a503          	lw	a0,0(s3)
    8000284c:	825ff0ef          	jal	80002070 <bread>
    80002850:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002852:	05850493          	addi	s1,a0,88
    80002856:	45850913          	addi	s2,a0,1112
    8000285a:	a021                	j	80002862 <itrunc+0x6c>
    8000285c:	0491                	addi	s1,s1,4
    8000285e:	01248963          	beq	s1,s2,80002870 <itrunc+0x7a>
      if(a[j])
    80002862:	408c                	lw	a1,0(s1)
    80002864:	dde5                	beqz	a1,8000285c <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002866:	0009a503          	lw	a0,0(s3)
    8000286a:	9fbff0ef          	jal	80002264 <bfree>
    8000286e:	b7fd                	j	8000285c <itrunc+0x66>
    brelse(bp);
    80002870:	8552                	mv	a0,s4
    80002872:	907ff0ef          	jal	80002178 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002876:	0809a583          	lw	a1,128(s3)
    8000287a:	0009a503          	lw	a0,0(s3)
    8000287e:	9e7ff0ef          	jal	80002264 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002882:	0809a023          	sw	zero,128(s3)
    80002886:	6a02                	ld	s4,0(sp)
    80002888:	b75d                	j	8000282e <itrunc+0x38>

000000008000288a <iput>:
{
    8000288a:	1101                	addi	sp,sp,-32
    8000288c:	ec06                	sd	ra,24(sp)
    8000288e:	e822                	sd	s0,16(sp)
    80002890:	e426                	sd	s1,8(sp)
    80002892:	1000                	addi	s0,sp,32
    80002894:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002896:	00016517          	auipc	a0,0x16
    8000289a:	f4250513          	addi	a0,a0,-190 # 800187d8 <itable>
    8000289e:	5ad030ef          	jal	8000664a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028a2:	4498                	lw	a4,8(s1)
    800028a4:	4785                	li	a5,1
    800028a6:	02f70063          	beq	a4,a5,800028c6 <iput+0x3c>
  ip->ref--;
    800028aa:	449c                	lw	a5,8(s1)
    800028ac:	37fd                	addiw	a5,a5,-1
    800028ae:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028b0:	00016517          	auipc	a0,0x16
    800028b4:	f2850513          	addi	a0,a0,-216 # 800187d8 <itable>
    800028b8:	627030ef          	jal	800066de <release>
}
    800028bc:	60e2                	ld	ra,24(sp)
    800028be:	6442                	ld	s0,16(sp)
    800028c0:	64a2                	ld	s1,8(sp)
    800028c2:	6105                	addi	sp,sp,32
    800028c4:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028c6:	40bc                	lw	a5,64(s1)
    800028c8:	d3ed                	beqz	a5,800028aa <iput+0x20>
    800028ca:	04a49783          	lh	a5,74(s1)
    800028ce:	fff1                	bnez	a5,800028aa <iput+0x20>
    800028d0:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    800028d2:	01048793          	addi	a5,s1,16
    800028d6:	893e                	mv	s2,a5
    800028d8:	853e                	mv	a0,a5
    800028da:	2cf000ef          	jal	800033a8 <acquiresleep>
    release(&itable.lock);
    800028de:	00016517          	auipc	a0,0x16
    800028e2:	efa50513          	addi	a0,a0,-262 # 800187d8 <itable>
    800028e6:	5f9030ef          	jal	800066de <release>
    itrunc(ip);
    800028ea:	8526                	mv	a0,s1
    800028ec:	f0bff0ef          	jal	800027f6 <itrunc>
    ip->type = 0;
    800028f0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028f4:	8526                	mv	a0,s1
    800028f6:	d5fff0ef          	jal	80002654 <iupdate>
    ip->valid = 0;
    800028fa:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028fe:	854a                	mv	a0,s2
    80002900:	2ef000ef          	jal	800033ee <releasesleep>
    acquire(&itable.lock);
    80002904:	00016517          	auipc	a0,0x16
    80002908:	ed450513          	addi	a0,a0,-300 # 800187d8 <itable>
    8000290c:	53f030ef          	jal	8000664a <acquire>
    80002910:	6902                	ld	s2,0(sp)
    80002912:	bf61                	j	800028aa <iput+0x20>

0000000080002914 <iunlockput>:
{
    80002914:	1101                	addi	sp,sp,-32
    80002916:	ec06                	sd	ra,24(sp)
    80002918:	e822                	sd	s0,16(sp)
    8000291a:	e426                	sd	s1,8(sp)
    8000291c:	1000                	addi	s0,sp,32
    8000291e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002920:	e97ff0ef          	jal	800027b6 <iunlock>
  iput(ip);
    80002924:	8526                	mv	a0,s1
    80002926:	f65ff0ef          	jal	8000288a <iput>
}
    8000292a:	60e2                	ld	ra,24(sp)
    8000292c:	6442                	ld	s0,16(sp)
    8000292e:	64a2                	ld	s1,8(sp)
    80002930:	6105                	addi	sp,sp,32
    80002932:	8082                	ret

0000000080002934 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002934:	00016717          	auipc	a4,0x16
    80002938:	e9072703          	lw	a4,-368(a4) # 800187c4 <sb+0xc>
    8000293c:	4785                	li	a5,1
    8000293e:	0ae7fe63          	bgeu	a5,a4,800029fa <ireclaim+0xc6>
{
    80002942:	7139                	addi	sp,sp,-64
    80002944:	fc06                	sd	ra,56(sp)
    80002946:	f822                	sd	s0,48(sp)
    80002948:	f426                	sd	s1,40(sp)
    8000294a:	f04a                	sd	s2,32(sp)
    8000294c:	ec4e                	sd	s3,24(sp)
    8000294e:	e852                	sd	s4,16(sp)
    80002950:	e456                	sd	s5,8(sp)
    80002952:	e05a                	sd	s6,0(sp)
    80002954:	0080                	addi	s0,sp,64
    80002956:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002958:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000295a:	00016a17          	auipc	s4,0x16
    8000295e:	e5ea0a13          	addi	s4,s4,-418 # 800187b8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002962:	00006b17          	auipc	s6,0x6
    80002966:	abeb0b13          	addi	s6,s6,-1346 # 80008420 <etext+0x420>
    8000296a:	a099                	j	800029b0 <ireclaim+0x7c>
    8000296c:	85ce                	mv	a1,s3
    8000296e:	855a                	mv	a0,s6
    80002970:	6ee030ef          	jal	8000605e <printf>
      ip = iget(dev, inum);
    80002974:	85ce                	mv	a1,s3
    80002976:	8556                	mv	a0,s5
    80002978:	b1fff0ef          	jal	80002496 <iget>
    8000297c:	89aa                	mv	s3,a0
    brelse(bp);
    8000297e:	854a                	mv	a0,s2
    80002980:	ff8ff0ef          	jal	80002178 <brelse>
    if (ip) {
    80002984:	00098f63          	beqz	s3,800029a2 <ireclaim+0x6e>
      begin_op();
    80002988:	78c000ef          	jal	80003114 <begin_op>
      ilock(ip);
    8000298c:	854e                	mv	a0,s3
    8000298e:	d7bff0ef          	jal	80002708 <ilock>
      iunlock(ip);
    80002992:	854e                	mv	a0,s3
    80002994:	e23ff0ef          	jal	800027b6 <iunlock>
      iput(ip);
    80002998:	854e                	mv	a0,s3
    8000299a:	ef1ff0ef          	jal	8000288a <iput>
      end_op();
    8000299e:	7e6000ef          	jal	80003184 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029a2:	0485                	addi	s1,s1,1
    800029a4:	00ca2703          	lw	a4,12(s4)
    800029a8:	0004879b          	sext.w	a5,s1
    800029ac:	02e7fd63          	bgeu	a5,a4,800029e6 <ireclaim+0xb2>
    800029b0:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800029b4:	0044d593          	srli	a1,s1,0x4
    800029b8:	018a2783          	lw	a5,24(s4)
    800029bc:	9dbd                	addw	a1,a1,a5
    800029be:	8556                	mv	a0,s5
    800029c0:	eb0ff0ef          	jal	80002070 <bread>
    800029c4:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    800029c6:	05850793          	addi	a5,a0,88
    800029ca:	00f9f713          	andi	a4,s3,15
    800029ce:	071a                	slli	a4,a4,0x6
    800029d0:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    800029d2:	00079703          	lh	a4,0(a5)
    800029d6:	c701                	beqz	a4,800029de <ireclaim+0xaa>
    800029d8:	00679783          	lh	a5,6(a5)
    800029dc:	dbc1                	beqz	a5,8000296c <ireclaim+0x38>
    brelse(bp);
    800029de:	854a                	mv	a0,s2
    800029e0:	f98ff0ef          	jal	80002178 <brelse>
    if (ip) {
    800029e4:	bf7d                	j	800029a2 <ireclaim+0x6e>
}
    800029e6:	70e2                	ld	ra,56(sp)
    800029e8:	7442                	ld	s0,48(sp)
    800029ea:	74a2                	ld	s1,40(sp)
    800029ec:	7902                	ld	s2,32(sp)
    800029ee:	69e2                	ld	s3,24(sp)
    800029f0:	6a42                	ld	s4,16(sp)
    800029f2:	6aa2                	ld	s5,8(sp)
    800029f4:	6b02                	ld	s6,0(sp)
    800029f6:	6121                	addi	sp,sp,64
    800029f8:	8082                	ret
    800029fa:	8082                	ret

00000000800029fc <fsinit>:
fsinit(int dev) {
    800029fc:	1101                	addi	sp,sp,-32
    800029fe:	ec06                	sd	ra,24(sp)
    80002a00:	e822                	sd	s0,16(sp)
    80002a02:	e426                	sd	s1,8(sp)
    80002a04:	e04a                	sd	s2,0(sp)
    80002a06:	1000                	addi	s0,sp,32
    80002a08:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a0a:	4585                	li	a1,1
    80002a0c:	e64ff0ef          	jal	80002070 <bread>
    80002a10:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a12:	02000613          	li	a2,32
    80002a16:	05850593          	addi	a1,a0,88
    80002a1a:	00016517          	auipc	a0,0x16
    80002a1e:	d9e50513          	addi	a0,a0,-610 # 800187b8 <sb>
    80002a22:	f9cfd0ef          	jal	800001be <memmove>
  brelse(bp);
    80002a26:	8526                	mv	a0,s1
    80002a28:	f50ff0ef          	jal	80002178 <brelse>
  if(sb.magic != FSMAGIC)
    80002a2c:	00016717          	auipc	a4,0x16
    80002a30:	d8c72703          	lw	a4,-628(a4) # 800187b8 <sb>
    80002a34:	102037b7          	lui	a5,0x10203
    80002a38:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a3c:	02f71263          	bne	a4,a5,80002a60 <fsinit+0x64>
  initlog(dev, &sb);
    80002a40:	00016597          	auipc	a1,0x16
    80002a44:	d7858593          	addi	a1,a1,-648 # 800187b8 <sb>
    80002a48:	854a                	mv	a0,s2
    80002a4a:	648000ef          	jal	80003092 <initlog>
  ireclaim(dev);
    80002a4e:	854a                	mv	a0,s2
    80002a50:	ee5ff0ef          	jal	80002934 <ireclaim>
}
    80002a54:	60e2                	ld	ra,24(sp)
    80002a56:	6442                	ld	s0,16(sp)
    80002a58:	64a2                	ld	s1,8(sp)
    80002a5a:	6902                	ld	s2,0(sp)
    80002a5c:	6105                	addi	sp,sp,32
    80002a5e:	8082                	ret
    panic("invalid file system");
    80002a60:	00006517          	auipc	a0,0x6
    80002a64:	9e050513          	addi	a0,a0,-1568 # 80008440 <etext+0x440>
    80002a68:	121030ef          	jal	80006388 <panic>

0000000080002a6c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a6c:	1141                	addi	sp,sp,-16
    80002a6e:	e406                	sd	ra,8(sp)
    80002a70:	e022                	sd	s0,0(sp)
    80002a72:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a74:	411c                	lw	a5,0(a0)
    80002a76:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a78:	415c                	lw	a5,4(a0)
    80002a7a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a7c:	04451783          	lh	a5,68(a0)
    80002a80:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a84:	04a51783          	lh	a5,74(a0)
    80002a88:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a8c:	04c56783          	lwu	a5,76(a0)
    80002a90:	e99c                	sd	a5,16(a1)
}
    80002a92:	60a2                	ld	ra,8(sp)
    80002a94:	6402                	ld	s0,0(sp)
    80002a96:	0141                	addi	sp,sp,16
    80002a98:	8082                	ret

0000000080002a9a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a9a:	457c                	lw	a5,76(a0)
    80002a9c:	0ed7e663          	bltu	a5,a3,80002b88 <readi+0xee>
{
    80002aa0:	7159                	addi	sp,sp,-112
    80002aa2:	f486                	sd	ra,104(sp)
    80002aa4:	f0a2                	sd	s0,96(sp)
    80002aa6:	eca6                	sd	s1,88(sp)
    80002aa8:	e0d2                	sd	s4,64(sp)
    80002aaa:	fc56                	sd	s5,56(sp)
    80002aac:	f85a                	sd	s6,48(sp)
    80002aae:	f45e                	sd	s7,40(sp)
    80002ab0:	1880                	addi	s0,sp,112
    80002ab2:	8b2a                	mv	s6,a0
    80002ab4:	8bae                	mv	s7,a1
    80002ab6:	8a32                	mv	s4,a2
    80002ab8:	84b6                	mv	s1,a3
    80002aba:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002abc:	9f35                	addw	a4,a4,a3
    return 0;
    80002abe:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ac0:	0ad76b63          	bltu	a4,a3,80002b76 <readi+0xdc>
    80002ac4:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002ac6:	00e7f463          	bgeu	a5,a4,80002ace <readi+0x34>
    n = ip->size - off;
    80002aca:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ace:	080a8b63          	beqz	s5,80002b64 <readi+0xca>
    80002ad2:	e8ca                	sd	s2,80(sp)
    80002ad4:	f062                	sd	s8,32(sp)
    80002ad6:	ec66                	sd	s9,24(sp)
    80002ad8:	e86a                	sd	s10,16(sp)
    80002ada:	e46e                	sd	s11,8(sp)
    80002adc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ade:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ae2:	5c7d                	li	s8,-1
    80002ae4:	a80d                	j	80002b16 <readi+0x7c>
    80002ae6:	020d1d93          	slli	s11,s10,0x20
    80002aea:	020ddd93          	srli	s11,s11,0x20
    80002aee:	05890613          	addi	a2,s2,88
    80002af2:	86ee                	mv	a3,s11
    80002af4:	963e                	add	a2,a2,a5
    80002af6:	85d2                	mv	a1,s4
    80002af8:	855e                	mv	a0,s7
    80002afa:	c91fe0ef          	jal	8000178a <either_copyout>
    80002afe:	05850363          	beq	a0,s8,80002b44 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002b02:	854a                	mv	a0,s2
    80002b04:	e74ff0ef          	jal	80002178 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b08:	013d09bb          	addw	s3,s10,s3
    80002b0c:	009d04bb          	addw	s1,s10,s1
    80002b10:	9a6e                	add	s4,s4,s11
    80002b12:	0559f363          	bgeu	s3,s5,80002b58 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b16:	00a4d59b          	srliw	a1,s1,0xa
    80002b1a:	855a                	mv	a0,s6
    80002b1c:	8bbff0ef          	jal	800023d6 <bmap>
    80002b20:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b22:	c139                	beqz	a0,80002b68 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002b24:	000b2503          	lw	a0,0(s6)
    80002b28:	d48ff0ef          	jal	80002070 <bread>
    80002b2c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b2e:	3ff4f793          	andi	a5,s1,1023
    80002b32:	40fc873b          	subw	a4,s9,a5
    80002b36:	413a86bb          	subw	a3,s5,s3
    80002b3a:	8d3a                	mv	s10,a4
    80002b3c:	fae6f5e3          	bgeu	a3,a4,80002ae6 <readi+0x4c>
    80002b40:	8d36                	mv	s10,a3
    80002b42:	b755                	j	80002ae6 <readi+0x4c>
      brelse(bp);
    80002b44:	854a                	mv	a0,s2
    80002b46:	e32ff0ef          	jal	80002178 <brelse>
      tot = -1;
    80002b4a:	59fd                	li	s3,-1
      break;
    80002b4c:	6946                	ld	s2,80(sp)
    80002b4e:	7c02                	ld	s8,32(sp)
    80002b50:	6ce2                	ld	s9,24(sp)
    80002b52:	6d42                	ld	s10,16(sp)
    80002b54:	6da2                	ld	s11,8(sp)
    80002b56:	a831                	j	80002b72 <readi+0xd8>
    80002b58:	6946                	ld	s2,80(sp)
    80002b5a:	7c02                	ld	s8,32(sp)
    80002b5c:	6ce2                	ld	s9,24(sp)
    80002b5e:	6d42                	ld	s10,16(sp)
    80002b60:	6da2                	ld	s11,8(sp)
    80002b62:	a801                	j	80002b72 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b64:	89d6                	mv	s3,s5
    80002b66:	a031                	j	80002b72 <readi+0xd8>
    80002b68:	6946                	ld	s2,80(sp)
    80002b6a:	7c02                	ld	s8,32(sp)
    80002b6c:	6ce2                	ld	s9,24(sp)
    80002b6e:	6d42                	ld	s10,16(sp)
    80002b70:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b72:	854e                	mv	a0,s3
    80002b74:	69a6                	ld	s3,72(sp)
}
    80002b76:	70a6                	ld	ra,104(sp)
    80002b78:	7406                	ld	s0,96(sp)
    80002b7a:	64e6                	ld	s1,88(sp)
    80002b7c:	6a06                	ld	s4,64(sp)
    80002b7e:	7ae2                	ld	s5,56(sp)
    80002b80:	7b42                	ld	s6,48(sp)
    80002b82:	7ba2                	ld	s7,40(sp)
    80002b84:	6165                	addi	sp,sp,112
    80002b86:	8082                	ret
    return 0;
    80002b88:	4501                	li	a0,0
}
    80002b8a:	8082                	ret

0000000080002b8c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b8c:	457c                	lw	a5,76(a0)
    80002b8e:	0ed7eb63          	bltu	a5,a3,80002c84 <writei+0xf8>
{
    80002b92:	7159                	addi	sp,sp,-112
    80002b94:	f486                	sd	ra,104(sp)
    80002b96:	f0a2                	sd	s0,96(sp)
    80002b98:	e8ca                	sd	s2,80(sp)
    80002b9a:	e0d2                	sd	s4,64(sp)
    80002b9c:	fc56                	sd	s5,56(sp)
    80002b9e:	f85a                	sd	s6,48(sp)
    80002ba0:	f45e                	sd	s7,40(sp)
    80002ba2:	1880                	addi	s0,sp,112
    80002ba4:	8aaa                	mv	s5,a0
    80002ba6:	8bae                	mv	s7,a1
    80002ba8:	8a32                	mv	s4,a2
    80002baa:	8936                	mv	s2,a3
    80002bac:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002bae:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002bb2:	00043737          	lui	a4,0x43
    80002bb6:	0cf76963          	bltu	a4,a5,80002c88 <writei+0xfc>
    80002bba:	0cd7e763          	bltu	a5,a3,80002c88 <writei+0xfc>
    80002bbe:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bc0:	0a0b0a63          	beqz	s6,80002c74 <writei+0xe8>
    80002bc4:	eca6                	sd	s1,88(sp)
    80002bc6:	f062                	sd	s8,32(sp)
    80002bc8:	ec66                	sd	s9,24(sp)
    80002bca:	e86a                	sd	s10,16(sp)
    80002bcc:	e46e                	sd	s11,8(sp)
    80002bce:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bd0:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002bd4:	5c7d                	li	s8,-1
    80002bd6:	a825                	j	80002c0e <writei+0x82>
    80002bd8:	020d1d93          	slli	s11,s10,0x20
    80002bdc:	020ddd93          	srli	s11,s11,0x20
    80002be0:	05848513          	addi	a0,s1,88
    80002be4:	86ee                	mv	a3,s11
    80002be6:	8652                	mv	a2,s4
    80002be8:	85de                	mv	a1,s7
    80002bea:	953e                	add	a0,a0,a5
    80002bec:	be9fe0ef          	jal	800017d4 <either_copyin>
    80002bf0:	05850663          	beq	a0,s8,80002c3c <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002bf4:	8526                	mv	a0,s1
    80002bf6:	6b8000ef          	jal	800032ae <log_write>
    brelse(bp);
    80002bfa:	8526                	mv	a0,s1
    80002bfc:	d7cff0ef          	jal	80002178 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c00:	013d09bb          	addw	s3,s10,s3
    80002c04:	012d093b          	addw	s2,s10,s2
    80002c08:	9a6e                	add	s4,s4,s11
    80002c0a:	0369fc63          	bgeu	s3,s6,80002c42 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002c0e:	00a9559b          	srliw	a1,s2,0xa
    80002c12:	8556                	mv	a0,s5
    80002c14:	fc2ff0ef          	jal	800023d6 <bmap>
    80002c18:	85aa                	mv	a1,a0
    if(addr == 0)
    80002c1a:	c505                	beqz	a0,80002c42 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002c1c:	000aa503          	lw	a0,0(s5)
    80002c20:	c50ff0ef          	jal	80002070 <bread>
    80002c24:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c26:	3ff97793          	andi	a5,s2,1023
    80002c2a:	40fc873b          	subw	a4,s9,a5
    80002c2e:	413b06bb          	subw	a3,s6,s3
    80002c32:	8d3a                	mv	s10,a4
    80002c34:	fae6f2e3          	bgeu	a3,a4,80002bd8 <writei+0x4c>
    80002c38:	8d36                	mv	s10,a3
    80002c3a:	bf79                	j	80002bd8 <writei+0x4c>
      brelse(bp);
    80002c3c:	8526                	mv	a0,s1
    80002c3e:	d3aff0ef          	jal	80002178 <brelse>
  }

  if(off > ip->size)
    80002c42:	04caa783          	lw	a5,76(s5)
    80002c46:	0327f963          	bgeu	a5,s2,80002c78 <writei+0xec>
    ip->size = off;
    80002c4a:	052aa623          	sw	s2,76(s5)
    80002c4e:	64e6                	ld	s1,88(sp)
    80002c50:	7c02                	ld	s8,32(sp)
    80002c52:	6ce2                	ld	s9,24(sp)
    80002c54:	6d42                	ld	s10,16(sp)
    80002c56:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c58:	8556                	mv	a0,s5
    80002c5a:	9fbff0ef          	jal	80002654 <iupdate>

  return tot;
    80002c5e:	854e                	mv	a0,s3
    80002c60:	69a6                	ld	s3,72(sp)
}
    80002c62:	70a6                	ld	ra,104(sp)
    80002c64:	7406                	ld	s0,96(sp)
    80002c66:	6946                	ld	s2,80(sp)
    80002c68:	6a06                	ld	s4,64(sp)
    80002c6a:	7ae2                	ld	s5,56(sp)
    80002c6c:	7b42                	ld	s6,48(sp)
    80002c6e:	7ba2                	ld	s7,40(sp)
    80002c70:	6165                	addi	sp,sp,112
    80002c72:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c74:	89da                	mv	s3,s6
    80002c76:	b7cd                	j	80002c58 <writei+0xcc>
    80002c78:	64e6                	ld	s1,88(sp)
    80002c7a:	7c02                	ld	s8,32(sp)
    80002c7c:	6ce2                	ld	s9,24(sp)
    80002c7e:	6d42                	ld	s10,16(sp)
    80002c80:	6da2                	ld	s11,8(sp)
    80002c82:	bfd9                	j	80002c58 <writei+0xcc>
    return -1;
    80002c84:	557d                	li	a0,-1
}
    80002c86:	8082                	ret
    return -1;
    80002c88:	557d                	li	a0,-1
    80002c8a:	bfe1                	j	80002c62 <writei+0xd6>

0000000080002c8c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c8c:	1141                	addi	sp,sp,-16
    80002c8e:	e406                	sd	ra,8(sp)
    80002c90:	e022                	sd	s0,0(sp)
    80002c92:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c94:	4639                	li	a2,14
    80002c96:	d9cfd0ef          	jal	80000232 <strncmp>
}
    80002c9a:	60a2                	ld	ra,8(sp)
    80002c9c:	6402                	ld	s0,0(sp)
    80002c9e:	0141                	addi	sp,sp,16
    80002ca0:	8082                	ret

0000000080002ca2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002ca2:	711d                	addi	sp,sp,-96
    80002ca4:	ec86                	sd	ra,88(sp)
    80002ca6:	e8a2                	sd	s0,80(sp)
    80002ca8:	e4a6                	sd	s1,72(sp)
    80002caa:	e0ca                	sd	s2,64(sp)
    80002cac:	fc4e                	sd	s3,56(sp)
    80002cae:	f852                	sd	s4,48(sp)
    80002cb0:	f456                	sd	s5,40(sp)
    80002cb2:	f05a                	sd	s6,32(sp)
    80002cb4:	ec5e                	sd	s7,24(sp)
    80002cb6:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002cb8:	04451703          	lh	a4,68(a0)
    80002cbc:	4785                	li	a5,1
    80002cbe:	00f71f63          	bne	a4,a5,80002cdc <dirlookup+0x3a>
    80002cc2:	892a                	mv	s2,a0
    80002cc4:	8aae                	mv	s5,a1
    80002cc6:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cc8:	457c                	lw	a5,76(a0)
    80002cca:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ccc:	fa040a13          	addi	s4,s0,-96
    80002cd0:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002cd2:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002cd6:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cd8:	e39d                	bnez	a5,80002cfe <dirlookup+0x5c>
    80002cda:	a8b9                	j	80002d38 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002cdc:	00005517          	auipc	a0,0x5
    80002ce0:	77c50513          	addi	a0,a0,1916 # 80008458 <etext+0x458>
    80002ce4:	6a4030ef          	jal	80006388 <panic>
      panic("dirlookup read");
    80002ce8:	00005517          	auipc	a0,0x5
    80002cec:	78850513          	addi	a0,a0,1928 # 80008470 <etext+0x470>
    80002cf0:	698030ef          	jal	80006388 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002cf4:	24c1                	addiw	s1,s1,16
    80002cf6:	04c92783          	lw	a5,76(s2)
    80002cfa:	02f4fe63          	bgeu	s1,a5,80002d36 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cfe:	874e                	mv	a4,s3
    80002d00:	86a6                	mv	a3,s1
    80002d02:	8652                	mv	a2,s4
    80002d04:	4581                	li	a1,0
    80002d06:	854a                	mv	a0,s2
    80002d08:	d93ff0ef          	jal	80002a9a <readi>
    80002d0c:	fd351ee3          	bne	a0,s3,80002ce8 <dirlookup+0x46>
    if(de.inum == 0)
    80002d10:	fa045783          	lhu	a5,-96(s0)
    80002d14:	d3e5                	beqz	a5,80002cf4 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002d16:	85da                	mv	a1,s6
    80002d18:	8556                	mv	a0,s5
    80002d1a:	f73ff0ef          	jal	80002c8c <namecmp>
    80002d1e:	f979                	bnez	a0,80002cf4 <dirlookup+0x52>
      if(poff)
    80002d20:	000b8463          	beqz	s7,80002d28 <dirlookup+0x86>
        *poff = off;
    80002d24:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002d28:	fa045583          	lhu	a1,-96(s0)
    80002d2c:	00092503          	lw	a0,0(s2)
    80002d30:	f66ff0ef          	jal	80002496 <iget>
    80002d34:	a011                	j	80002d38 <dirlookup+0x96>
  return 0;
    80002d36:	4501                	li	a0,0
}
    80002d38:	60e6                	ld	ra,88(sp)
    80002d3a:	6446                	ld	s0,80(sp)
    80002d3c:	64a6                	ld	s1,72(sp)
    80002d3e:	6906                	ld	s2,64(sp)
    80002d40:	79e2                	ld	s3,56(sp)
    80002d42:	7a42                	ld	s4,48(sp)
    80002d44:	7aa2                	ld	s5,40(sp)
    80002d46:	7b02                	ld	s6,32(sp)
    80002d48:	6be2                	ld	s7,24(sp)
    80002d4a:	6125                	addi	sp,sp,96
    80002d4c:	8082                	ret

0000000080002d4e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d4e:	711d                	addi	sp,sp,-96
    80002d50:	ec86                	sd	ra,88(sp)
    80002d52:	e8a2                	sd	s0,80(sp)
    80002d54:	e4a6                	sd	s1,72(sp)
    80002d56:	e0ca                	sd	s2,64(sp)
    80002d58:	fc4e                	sd	s3,56(sp)
    80002d5a:	f852                	sd	s4,48(sp)
    80002d5c:	f456                	sd	s5,40(sp)
    80002d5e:	f05a                	sd	s6,32(sp)
    80002d60:	ec5e                	sd	s7,24(sp)
    80002d62:	e862                	sd	s8,16(sp)
    80002d64:	e466                	sd	s9,8(sp)
    80002d66:	e06a                	sd	s10,0(sp)
    80002d68:	1080                	addi	s0,sp,96
    80002d6a:	84aa                	mv	s1,a0
    80002d6c:	8b2e                	mv	s6,a1
    80002d6e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d70:	00054703          	lbu	a4,0(a0)
    80002d74:	02f00793          	li	a5,47
    80002d78:	00f70f63          	beq	a4,a5,80002d96 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d7c:	88cfe0ef          	jal	80000e08 <myproc>
    80002d80:	15053503          	ld	a0,336(a0)
    80002d84:	94fff0ef          	jal	800026d2 <idup>
    80002d88:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d8a:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002d8e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002d90:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d92:	4b85                	li	s7,1
    80002d94:	a879                	j	80002e32 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002d96:	4585                	li	a1,1
    80002d98:	852e                	mv	a0,a1
    80002d9a:	efcff0ef          	jal	80002496 <iget>
    80002d9e:	8a2a                	mv	s4,a0
    80002da0:	b7ed                	j	80002d8a <namex+0x3c>
      iunlockput(ip);
    80002da2:	8552                	mv	a0,s4
    80002da4:	b71ff0ef          	jal	80002914 <iunlockput>
      return 0;
    80002da8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002daa:	8552                	mv	a0,s4
    80002dac:	60e6                	ld	ra,88(sp)
    80002dae:	6446                	ld	s0,80(sp)
    80002db0:	64a6                	ld	s1,72(sp)
    80002db2:	6906                	ld	s2,64(sp)
    80002db4:	79e2                	ld	s3,56(sp)
    80002db6:	7a42                	ld	s4,48(sp)
    80002db8:	7aa2                	ld	s5,40(sp)
    80002dba:	7b02                	ld	s6,32(sp)
    80002dbc:	6be2                	ld	s7,24(sp)
    80002dbe:	6c42                	ld	s8,16(sp)
    80002dc0:	6ca2                	ld	s9,8(sp)
    80002dc2:	6d02                	ld	s10,0(sp)
    80002dc4:	6125                	addi	sp,sp,96
    80002dc6:	8082                	ret
      iunlock(ip);
    80002dc8:	8552                	mv	a0,s4
    80002dca:	9edff0ef          	jal	800027b6 <iunlock>
      return ip;
    80002dce:	bff1                	j	80002daa <namex+0x5c>
      iunlockput(ip);
    80002dd0:	8552                	mv	a0,s4
    80002dd2:	b43ff0ef          	jal	80002914 <iunlockput>
      return 0;
    80002dd6:	8a4a                	mv	s4,s2
    80002dd8:	bfc9                	j	80002daa <namex+0x5c>
  len = path - s;
    80002dda:	40990633          	sub	a2,s2,s1
    80002dde:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002de2:	09ac5463          	bge	s8,s10,80002e6a <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002de6:	8666                	mv	a2,s9
    80002de8:	85a6                	mv	a1,s1
    80002dea:	8556                	mv	a0,s5
    80002dec:	bd2fd0ef          	jal	800001be <memmove>
    80002df0:	84ca                	mv	s1,s2
  while(*path == '/')
    80002df2:	0004c783          	lbu	a5,0(s1)
    80002df6:	01379763          	bne	a5,s3,80002e04 <namex+0xb6>
    path++;
    80002dfa:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dfc:	0004c783          	lbu	a5,0(s1)
    80002e00:	ff378de3          	beq	a5,s3,80002dfa <namex+0xac>
    ilock(ip);
    80002e04:	8552                	mv	a0,s4
    80002e06:	903ff0ef          	jal	80002708 <ilock>
    if(ip->type != T_DIR){
    80002e0a:	044a1783          	lh	a5,68(s4)
    80002e0e:	f9779ae3          	bne	a5,s7,80002da2 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002e12:	000b0563          	beqz	s6,80002e1c <namex+0xce>
    80002e16:	0004c783          	lbu	a5,0(s1)
    80002e1a:	d7dd                	beqz	a5,80002dc8 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002e1c:	4601                	li	a2,0
    80002e1e:	85d6                	mv	a1,s5
    80002e20:	8552                	mv	a0,s4
    80002e22:	e81ff0ef          	jal	80002ca2 <dirlookup>
    80002e26:	892a                	mv	s2,a0
    80002e28:	d545                	beqz	a0,80002dd0 <namex+0x82>
    iunlockput(ip);
    80002e2a:	8552                	mv	a0,s4
    80002e2c:	ae9ff0ef          	jal	80002914 <iunlockput>
    ip = next;
    80002e30:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002e32:	0004c783          	lbu	a5,0(s1)
    80002e36:	01379763          	bne	a5,s3,80002e44 <namex+0xf6>
    path++;
    80002e3a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e3c:	0004c783          	lbu	a5,0(s1)
    80002e40:	ff378de3          	beq	a5,s3,80002e3a <namex+0xec>
  if(*path == 0)
    80002e44:	cf8d                	beqz	a5,80002e7e <namex+0x130>
  while(*path != '/' && *path != 0)
    80002e46:	0004c783          	lbu	a5,0(s1)
    80002e4a:	fd178713          	addi	a4,a5,-47
    80002e4e:	cb19                	beqz	a4,80002e64 <namex+0x116>
    80002e50:	cb91                	beqz	a5,80002e64 <namex+0x116>
    80002e52:	8926                	mv	s2,s1
    path++;
    80002e54:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002e56:	00094783          	lbu	a5,0(s2)
    80002e5a:	fd178713          	addi	a4,a5,-47
    80002e5e:	df35                	beqz	a4,80002dda <namex+0x8c>
    80002e60:	fbf5                	bnez	a5,80002e54 <namex+0x106>
    80002e62:	bfa5                	j	80002dda <namex+0x8c>
    80002e64:	8926                	mv	s2,s1
  len = path - s;
    80002e66:	4d01                	li	s10,0
    80002e68:	4601                	li	a2,0
    memmove(name, s, len);
    80002e6a:	2601                	sext.w	a2,a2
    80002e6c:	85a6                	mv	a1,s1
    80002e6e:	8556                	mv	a0,s5
    80002e70:	b4efd0ef          	jal	800001be <memmove>
    name[len] = 0;
    80002e74:	9d56                	add	s10,s10,s5
    80002e76:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7e62b818>
    80002e7a:	84ca                	mv	s1,s2
    80002e7c:	bf9d                	j	80002df2 <namex+0xa4>
  if(nameiparent){
    80002e7e:	f20b06e3          	beqz	s6,80002daa <namex+0x5c>
    iput(ip);
    80002e82:	8552                	mv	a0,s4
    80002e84:	a07ff0ef          	jal	8000288a <iput>
    return 0;
    80002e88:	4a01                	li	s4,0
    80002e8a:	b705                	j	80002daa <namex+0x5c>

0000000080002e8c <dirlink>:
{
    80002e8c:	715d                	addi	sp,sp,-80
    80002e8e:	e486                	sd	ra,72(sp)
    80002e90:	e0a2                	sd	s0,64(sp)
    80002e92:	f84a                	sd	s2,48(sp)
    80002e94:	ec56                	sd	s5,24(sp)
    80002e96:	e85a                	sd	s6,16(sp)
    80002e98:	0880                	addi	s0,sp,80
    80002e9a:	892a                	mv	s2,a0
    80002e9c:	8aae                	mv	s5,a1
    80002e9e:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002ea0:	4601                	li	a2,0
    80002ea2:	e01ff0ef          	jal	80002ca2 <dirlookup>
    80002ea6:	ed1d                	bnez	a0,80002ee4 <dirlink+0x58>
    80002ea8:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002eaa:	04c92483          	lw	s1,76(s2)
    80002eae:	c4b9                	beqz	s1,80002efc <dirlink+0x70>
    80002eb0:	f44e                	sd	s3,40(sp)
    80002eb2:	f052                	sd	s4,32(sp)
    80002eb4:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eb6:	fb040a13          	addi	s4,s0,-80
    80002eba:	49c1                	li	s3,16
    80002ebc:	874e                	mv	a4,s3
    80002ebe:	86a6                	mv	a3,s1
    80002ec0:	8652                	mv	a2,s4
    80002ec2:	4581                	li	a1,0
    80002ec4:	854a                	mv	a0,s2
    80002ec6:	bd5ff0ef          	jal	80002a9a <readi>
    80002eca:	03351163          	bne	a0,s3,80002eec <dirlink+0x60>
    if(de.inum == 0)
    80002ece:	fb045783          	lhu	a5,-80(s0)
    80002ed2:	c39d                	beqz	a5,80002ef8 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ed4:	24c1                	addiw	s1,s1,16
    80002ed6:	04c92783          	lw	a5,76(s2)
    80002eda:	fef4e1e3          	bltu	s1,a5,80002ebc <dirlink+0x30>
    80002ede:	79a2                	ld	s3,40(sp)
    80002ee0:	7a02                	ld	s4,32(sp)
    80002ee2:	a829                	j	80002efc <dirlink+0x70>
    iput(ip);
    80002ee4:	9a7ff0ef          	jal	8000288a <iput>
    return -1;
    80002ee8:	557d                	li	a0,-1
    80002eea:	a83d                	j	80002f28 <dirlink+0x9c>
      panic("dirlink read");
    80002eec:	00005517          	auipc	a0,0x5
    80002ef0:	59450513          	addi	a0,a0,1428 # 80008480 <etext+0x480>
    80002ef4:	494030ef          	jal	80006388 <panic>
    80002ef8:	79a2                	ld	s3,40(sp)
    80002efa:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002efc:	4639                	li	a2,14
    80002efe:	85d6                	mv	a1,s5
    80002f00:	fb240513          	addi	a0,s0,-78
    80002f04:	b68fd0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80002f08:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f0c:	4741                	li	a4,16
    80002f0e:	86a6                	mv	a3,s1
    80002f10:	fb040613          	addi	a2,s0,-80
    80002f14:	4581                	li	a1,0
    80002f16:	854a                	mv	a0,s2
    80002f18:	c75ff0ef          	jal	80002b8c <writei>
    80002f1c:	1541                	addi	a0,a0,-16
    80002f1e:	00a03533          	snez	a0,a0
    80002f22:	40a0053b          	negw	a0,a0
    80002f26:	74e2                	ld	s1,56(sp)
}
    80002f28:	60a6                	ld	ra,72(sp)
    80002f2a:	6406                	ld	s0,64(sp)
    80002f2c:	7942                	ld	s2,48(sp)
    80002f2e:	6ae2                	ld	s5,24(sp)
    80002f30:	6b42                	ld	s6,16(sp)
    80002f32:	6161                	addi	sp,sp,80
    80002f34:	8082                	ret

0000000080002f36 <namei>:

struct inode*
namei(char *path)
{
    80002f36:	1101                	addi	sp,sp,-32
    80002f38:	ec06                	sd	ra,24(sp)
    80002f3a:	e822                	sd	s0,16(sp)
    80002f3c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002f3e:	fe040613          	addi	a2,s0,-32
    80002f42:	4581                	li	a1,0
    80002f44:	e0bff0ef          	jal	80002d4e <namex>
}
    80002f48:	60e2                	ld	ra,24(sp)
    80002f4a:	6442                	ld	s0,16(sp)
    80002f4c:	6105                	addi	sp,sp,32
    80002f4e:	8082                	ret

0000000080002f50 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002f50:	1141                	addi	sp,sp,-16
    80002f52:	e406                	sd	ra,8(sp)
    80002f54:	e022                	sd	s0,0(sp)
    80002f56:	0800                	addi	s0,sp,16
    80002f58:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f5a:	4585                	li	a1,1
    80002f5c:	df3ff0ef          	jal	80002d4e <namex>
}
    80002f60:	60a2                	ld	ra,8(sp)
    80002f62:	6402                	ld	s0,0(sp)
    80002f64:	0141                	addi	sp,sp,16
    80002f66:	8082                	ret

0000000080002f68 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f68:	1101                	addi	sp,sp,-32
    80002f6a:	ec06                	sd	ra,24(sp)
    80002f6c:	e822                	sd	s0,16(sp)
    80002f6e:	e426                	sd	s1,8(sp)
    80002f70:	e04a                	sd	s2,0(sp)
    80002f72:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f74:	00017917          	auipc	s2,0x17
    80002f78:	30c90913          	addi	s2,s2,780 # 8001a280 <log>
    80002f7c:	01892583          	lw	a1,24(s2)
    80002f80:	02492503          	lw	a0,36(s2)
    80002f84:	8ecff0ef          	jal	80002070 <bread>
    80002f88:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f8a:	02892603          	lw	a2,40(s2)
    80002f8e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f90:	00c05f63          	blez	a2,80002fae <write_head+0x46>
    80002f94:	00017717          	auipc	a4,0x17
    80002f98:	31870713          	addi	a4,a4,792 # 8001a2ac <log+0x2c>
    80002f9c:	87aa                	mv	a5,a0
    80002f9e:	060a                	slli	a2,a2,0x2
    80002fa0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002fa2:	4314                	lw	a3,0(a4)
    80002fa4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002fa6:	0711                	addi	a4,a4,4
    80002fa8:	0791                	addi	a5,a5,4
    80002faa:	fec79ce3          	bne	a5,a2,80002fa2 <write_head+0x3a>
  }
  bwrite(buf);
    80002fae:	8526                	mv	a0,s1
    80002fb0:	996ff0ef          	jal	80002146 <bwrite>
  brelse(buf);
    80002fb4:	8526                	mv	a0,s1
    80002fb6:	9c2ff0ef          	jal	80002178 <brelse>
}
    80002fba:	60e2                	ld	ra,24(sp)
    80002fbc:	6442                	ld	s0,16(sp)
    80002fbe:	64a2                	ld	s1,8(sp)
    80002fc0:	6902                	ld	s2,0(sp)
    80002fc2:	6105                	addi	sp,sp,32
    80002fc4:	8082                	ret

0000000080002fc6 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fc6:	00017797          	auipc	a5,0x17
    80002fca:	2e27a783          	lw	a5,738(a5) # 8001a2a8 <log+0x28>
    80002fce:	0cf05163          	blez	a5,80003090 <install_trans+0xca>
{
    80002fd2:	715d                	addi	sp,sp,-80
    80002fd4:	e486                	sd	ra,72(sp)
    80002fd6:	e0a2                	sd	s0,64(sp)
    80002fd8:	fc26                	sd	s1,56(sp)
    80002fda:	f84a                	sd	s2,48(sp)
    80002fdc:	f44e                	sd	s3,40(sp)
    80002fde:	f052                	sd	s4,32(sp)
    80002fe0:	ec56                	sd	s5,24(sp)
    80002fe2:	e85a                	sd	s6,16(sp)
    80002fe4:	e45e                	sd	s7,8(sp)
    80002fe6:	e062                	sd	s8,0(sp)
    80002fe8:	0880                	addi	s0,sp,80
    80002fea:	8b2a                	mv	s6,a0
    80002fec:	00017a97          	auipc	s5,0x17
    80002ff0:	2c0a8a93          	addi	s5,s5,704 # 8001a2ac <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002ff4:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002ff6:	00005c17          	auipc	s8,0x5
    80002ffa:	49ac0c13          	addi	s8,s8,1178 # 80008490 <etext+0x490>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002ffe:	00017a17          	auipc	s4,0x17
    80003002:	282a0a13          	addi	s4,s4,642 # 8001a280 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003006:	40000b93          	li	s7,1024
    8000300a:	a025                	j	80003032 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000300c:	000aa603          	lw	a2,0(s5)
    80003010:	85ce                	mv	a1,s3
    80003012:	8562                	mv	a0,s8
    80003014:	04a030ef          	jal	8000605e <printf>
    80003018:	a839                	j	80003036 <install_trans+0x70>
    brelse(lbuf);
    8000301a:	854a                	mv	a0,s2
    8000301c:	95cff0ef          	jal	80002178 <brelse>
    brelse(dbuf);
    80003020:	8526                	mv	a0,s1
    80003022:	956ff0ef          	jal	80002178 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003026:	2985                	addiw	s3,s3,1
    80003028:	0a91                	addi	s5,s5,4
    8000302a:	028a2783          	lw	a5,40(s4)
    8000302e:	04f9d563          	bge	s3,a5,80003078 <install_trans+0xb2>
    if(recovering) {
    80003032:	fc0b1de3          	bnez	s6,8000300c <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003036:	018a2583          	lw	a1,24(s4)
    8000303a:	013585bb          	addw	a1,a1,s3
    8000303e:	2585                	addiw	a1,a1,1
    80003040:	024a2503          	lw	a0,36(s4)
    80003044:	82cff0ef          	jal	80002070 <bread>
    80003048:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000304a:	000aa583          	lw	a1,0(s5)
    8000304e:	024a2503          	lw	a0,36(s4)
    80003052:	81eff0ef          	jal	80002070 <bread>
    80003056:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003058:	865e                	mv	a2,s7
    8000305a:	05890593          	addi	a1,s2,88
    8000305e:	05850513          	addi	a0,a0,88
    80003062:	95cfd0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    80003066:	8526                	mv	a0,s1
    80003068:	8deff0ef          	jal	80002146 <bwrite>
    if(recovering == 0)
    8000306c:	fa0b17e3          	bnez	s6,8000301a <install_trans+0x54>
      bunpin(dbuf);
    80003070:	8526                	mv	a0,s1
    80003072:	9beff0ef          	jal	80002230 <bunpin>
    80003076:	b755                	j	8000301a <install_trans+0x54>
}
    80003078:	60a6                	ld	ra,72(sp)
    8000307a:	6406                	ld	s0,64(sp)
    8000307c:	74e2                	ld	s1,56(sp)
    8000307e:	7942                	ld	s2,48(sp)
    80003080:	79a2                	ld	s3,40(sp)
    80003082:	7a02                	ld	s4,32(sp)
    80003084:	6ae2                	ld	s5,24(sp)
    80003086:	6b42                	ld	s6,16(sp)
    80003088:	6ba2                	ld	s7,8(sp)
    8000308a:	6c02                	ld	s8,0(sp)
    8000308c:	6161                	addi	sp,sp,80
    8000308e:	8082                	ret
    80003090:	8082                	ret

0000000080003092 <initlog>:
{
    80003092:	7179                	addi	sp,sp,-48
    80003094:	f406                	sd	ra,40(sp)
    80003096:	f022                	sd	s0,32(sp)
    80003098:	ec26                	sd	s1,24(sp)
    8000309a:	e84a                	sd	s2,16(sp)
    8000309c:	e44e                	sd	s3,8(sp)
    8000309e:	1800                	addi	s0,sp,48
    800030a0:	84aa                	mv	s1,a0
    800030a2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800030a4:	00017917          	auipc	s2,0x17
    800030a8:	1dc90913          	addi	s2,s2,476 # 8001a280 <log>
    800030ac:	00005597          	auipc	a1,0x5
    800030b0:	40458593          	addi	a1,a1,1028 # 800084b0 <etext+0x4b0>
    800030b4:	854a                	mv	a0,s2
    800030b6:	50a030ef          	jal	800065c0 <initlock>
  log.start = sb->logstart;
    800030ba:	0149a583          	lw	a1,20(s3)
    800030be:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    800030c2:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    800030c6:	8526                	mv	a0,s1
    800030c8:	fa9fe0ef          	jal	80002070 <bread>
  log.lh.n = lh->n;
    800030cc:	4d30                	lw	a2,88(a0)
    800030ce:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    800030d2:	00c05f63          	blez	a2,800030f0 <initlog+0x5e>
    800030d6:	87aa                	mv	a5,a0
    800030d8:	00017717          	auipc	a4,0x17
    800030dc:	1d470713          	addi	a4,a4,468 # 8001a2ac <log+0x2c>
    800030e0:	060a                	slli	a2,a2,0x2
    800030e2:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800030e4:	4ff4                	lw	a3,92(a5)
    800030e6:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800030e8:	0791                	addi	a5,a5,4
    800030ea:	0711                	addi	a4,a4,4
    800030ec:	fec79ce3          	bne	a5,a2,800030e4 <initlog+0x52>
  brelse(buf);
    800030f0:	888ff0ef          	jal	80002178 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800030f4:	4505                	li	a0,1
    800030f6:	ed1ff0ef          	jal	80002fc6 <install_trans>
  log.lh.n = 0;
    800030fa:	00017797          	auipc	a5,0x17
    800030fe:	1a07a723          	sw	zero,430(a5) # 8001a2a8 <log+0x28>
  write_head(); // clear the log
    80003102:	e67ff0ef          	jal	80002f68 <write_head>
}
    80003106:	70a2                	ld	ra,40(sp)
    80003108:	7402                	ld	s0,32(sp)
    8000310a:	64e2                	ld	s1,24(sp)
    8000310c:	6942                	ld	s2,16(sp)
    8000310e:	69a2                	ld	s3,8(sp)
    80003110:	6145                	addi	sp,sp,48
    80003112:	8082                	ret

0000000080003114 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003114:	1101                	addi	sp,sp,-32
    80003116:	ec06                	sd	ra,24(sp)
    80003118:	e822                	sd	s0,16(sp)
    8000311a:	e426                	sd	s1,8(sp)
    8000311c:	e04a                	sd	s2,0(sp)
    8000311e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003120:	00017517          	auipc	a0,0x17
    80003124:	16050513          	addi	a0,a0,352 # 8001a280 <log>
    80003128:	522030ef          	jal	8000664a <acquire>
  while(1){
    if(log.committing){
    8000312c:	00017497          	auipc	s1,0x17
    80003130:	15448493          	addi	s1,s1,340 # 8001a280 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003134:	4979                	li	s2,30
    80003136:	a029                	j	80003140 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003138:	85a6                	mv	a1,s1
    8000313a:	8526                	mv	a0,s1
    8000313c:	af4fe0ef          	jal	80001430 <sleep>
    if(log.committing){
    80003140:	509c                	lw	a5,32(s1)
    80003142:	fbfd                	bnez	a5,80003138 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003144:	4cd8                	lw	a4,28(s1)
    80003146:	2705                	addiw	a4,a4,1
    80003148:	0027179b          	slliw	a5,a4,0x2
    8000314c:	9fb9                	addw	a5,a5,a4
    8000314e:	0017979b          	slliw	a5,a5,0x1
    80003152:	5494                	lw	a3,40(s1)
    80003154:	9fb5                	addw	a5,a5,a3
    80003156:	00f95763          	bge	s2,a5,80003164 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000315a:	85a6                	mv	a1,s1
    8000315c:	8526                	mv	a0,s1
    8000315e:	ad2fe0ef          	jal	80001430 <sleep>
    80003162:	bff9                	j	80003140 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003164:	00017797          	auipc	a5,0x17
    80003168:	12e7ac23          	sw	a4,312(a5) # 8001a29c <log+0x1c>
      release(&log.lock);
    8000316c:	00017517          	auipc	a0,0x17
    80003170:	11450513          	addi	a0,a0,276 # 8001a280 <log>
    80003174:	56a030ef          	jal	800066de <release>
      break;
    }
  }
}
    80003178:	60e2                	ld	ra,24(sp)
    8000317a:	6442                	ld	s0,16(sp)
    8000317c:	64a2                	ld	s1,8(sp)
    8000317e:	6902                	ld	s2,0(sp)
    80003180:	6105                	addi	sp,sp,32
    80003182:	8082                	ret

0000000080003184 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003184:	7139                	addi	sp,sp,-64
    80003186:	fc06                	sd	ra,56(sp)
    80003188:	f822                	sd	s0,48(sp)
    8000318a:	f426                	sd	s1,40(sp)
    8000318c:	f04a                	sd	s2,32(sp)
    8000318e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003190:	00017497          	auipc	s1,0x17
    80003194:	0f048493          	addi	s1,s1,240 # 8001a280 <log>
    80003198:	8526                	mv	a0,s1
    8000319a:	4b0030ef          	jal	8000664a <acquire>
  log.outstanding -= 1;
    8000319e:	4cdc                	lw	a5,28(s1)
    800031a0:	37fd                	addiw	a5,a5,-1
    800031a2:	893e                	mv	s2,a5
    800031a4:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800031a6:	509c                	lw	a5,32(s1)
    800031a8:	e7b1                	bnez	a5,800031f4 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    800031aa:	04091e63          	bnez	s2,80003206 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    800031ae:	00017497          	auipc	s1,0x17
    800031b2:	0d248493          	addi	s1,s1,210 # 8001a280 <log>
    800031b6:	4785                	li	a5,1
    800031b8:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800031ba:	8526                	mv	a0,s1
    800031bc:	522030ef          	jal	800066de <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800031c0:	549c                	lw	a5,40(s1)
    800031c2:	06f04463          	bgtz	a5,8000322a <end_op+0xa6>
    acquire(&log.lock);
    800031c6:	00017517          	auipc	a0,0x17
    800031ca:	0ba50513          	addi	a0,a0,186 # 8001a280 <log>
    800031ce:	47c030ef          	jal	8000664a <acquire>
    log.committing = 0;
    800031d2:	00017797          	auipc	a5,0x17
    800031d6:	0c07a723          	sw	zero,206(a5) # 8001a2a0 <log+0x20>
    wakeup(&log);
    800031da:	00017517          	auipc	a0,0x17
    800031de:	0a650513          	addi	a0,a0,166 # 8001a280 <log>
    800031e2:	a9afe0ef          	jal	8000147c <wakeup>
    release(&log.lock);
    800031e6:	00017517          	auipc	a0,0x17
    800031ea:	09a50513          	addi	a0,a0,154 # 8001a280 <log>
    800031ee:	4f0030ef          	jal	800066de <release>
}
    800031f2:	a035                	j	8000321e <end_op+0x9a>
    800031f4:	ec4e                	sd	s3,24(sp)
    800031f6:	e852                	sd	s4,16(sp)
    800031f8:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800031fa:	00005517          	auipc	a0,0x5
    800031fe:	2be50513          	addi	a0,a0,702 # 800084b8 <etext+0x4b8>
    80003202:	186030ef          	jal	80006388 <panic>
    wakeup(&log);
    80003206:	00017517          	auipc	a0,0x17
    8000320a:	07a50513          	addi	a0,a0,122 # 8001a280 <log>
    8000320e:	a6efe0ef          	jal	8000147c <wakeup>
  release(&log.lock);
    80003212:	00017517          	auipc	a0,0x17
    80003216:	06e50513          	addi	a0,a0,110 # 8001a280 <log>
    8000321a:	4c4030ef          	jal	800066de <release>
}
    8000321e:	70e2                	ld	ra,56(sp)
    80003220:	7442                	ld	s0,48(sp)
    80003222:	74a2                	ld	s1,40(sp)
    80003224:	7902                	ld	s2,32(sp)
    80003226:	6121                	addi	sp,sp,64
    80003228:	8082                	ret
    8000322a:	ec4e                	sd	s3,24(sp)
    8000322c:	e852                	sd	s4,16(sp)
    8000322e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003230:	00017a97          	auipc	s5,0x17
    80003234:	07ca8a93          	addi	s5,s5,124 # 8001a2ac <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003238:	00017a17          	auipc	s4,0x17
    8000323c:	048a0a13          	addi	s4,s4,72 # 8001a280 <log>
    80003240:	018a2583          	lw	a1,24(s4)
    80003244:	012585bb          	addw	a1,a1,s2
    80003248:	2585                	addiw	a1,a1,1
    8000324a:	024a2503          	lw	a0,36(s4)
    8000324e:	e23fe0ef          	jal	80002070 <bread>
    80003252:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003254:	000aa583          	lw	a1,0(s5)
    80003258:	024a2503          	lw	a0,36(s4)
    8000325c:	e15fe0ef          	jal	80002070 <bread>
    80003260:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003262:	40000613          	li	a2,1024
    80003266:	05850593          	addi	a1,a0,88
    8000326a:	05848513          	addi	a0,s1,88
    8000326e:	f51fc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    80003272:	8526                	mv	a0,s1
    80003274:	ed3fe0ef          	jal	80002146 <bwrite>
    brelse(from);
    80003278:	854e                	mv	a0,s3
    8000327a:	efffe0ef          	jal	80002178 <brelse>
    brelse(to);
    8000327e:	8526                	mv	a0,s1
    80003280:	ef9fe0ef          	jal	80002178 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003284:	2905                	addiw	s2,s2,1
    80003286:	0a91                	addi	s5,s5,4
    80003288:	028a2783          	lw	a5,40(s4)
    8000328c:	faf94ae3          	blt	s2,a5,80003240 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003290:	cd9ff0ef          	jal	80002f68 <write_head>
    install_trans(0); // Now install writes to home locations
    80003294:	4501                	li	a0,0
    80003296:	d31ff0ef          	jal	80002fc6 <install_trans>
    log.lh.n = 0;
    8000329a:	00017797          	auipc	a5,0x17
    8000329e:	0007a723          	sw	zero,14(a5) # 8001a2a8 <log+0x28>
    write_head();    // Erase the transaction from the log
    800032a2:	cc7ff0ef          	jal	80002f68 <write_head>
    800032a6:	69e2                	ld	s3,24(sp)
    800032a8:	6a42                	ld	s4,16(sp)
    800032aa:	6aa2                	ld	s5,8(sp)
    800032ac:	bf29                	j	800031c6 <end_op+0x42>

00000000800032ae <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800032ae:	1101                	addi	sp,sp,-32
    800032b0:	ec06                	sd	ra,24(sp)
    800032b2:	e822                	sd	s0,16(sp)
    800032b4:	e426                	sd	s1,8(sp)
    800032b6:	1000                	addi	s0,sp,32
    800032b8:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800032ba:	00017517          	auipc	a0,0x17
    800032be:	fc650513          	addi	a0,a0,-58 # 8001a280 <log>
    800032c2:	388030ef          	jal	8000664a <acquire>
  if (log.lh.n >= LOGBLOCKS)
    800032c6:	00017617          	auipc	a2,0x17
    800032ca:	fe262603          	lw	a2,-30(a2) # 8001a2a8 <log+0x28>
    800032ce:	47f5                	li	a5,29
    800032d0:	04c7cd63          	blt	a5,a2,8000332a <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800032d4:	00017797          	auipc	a5,0x17
    800032d8:	fc87a783          	lw	a5,-56(a5) # 8001a29c <log+0x1c>
    800032dc:	04f05d63          	blez	a5,80003336 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800032e0:	4781                	li	a5,0
    800032e2:	06c05063          	blez	a2,80003342 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032e6:	44cc                	lw	a1,12(s1)
    800032e8:	00017717          	auipc	a4,0x17
    800032ec:	fc470713          	addi	a4,a4,-60 # 8001a2ac <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800032f0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032f2:	4314                	lw	a3,0(a4)
    800032f4:	04b68763          	beq	a3,a1,80003342 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    800032f8:	2785                	addiw	a5,a5,1
    800032fa:	0711                	addi	a4,a4,4
    800032fc:	fef61be3          	bne	a2,a5,800032f2 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003300:	060a                	slli	a2,a2,0x2
    80003302:	02060613          	addi	a2,a2,32
    80003306:	00017797          	auipc	a5,0x17
    8000330a:	f7a78793          	addi	a5,a5,-134 # 8001a280 <log>
    8000330e:	97b2                	add	a5,a5,a2
    80003310:	44d8                	lw	a4,12(s1)
    80003312:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003314:	8526                	mv	a0,s1
    80003316:	ee7fe0ef          	jal	800021fc <bpin>
    log.lh.n++;
    8000331a:	00017717          	auipc	a4,0x17
    8000331e:	f6670713          	addi	a4,a4,-154 # 8001a280 <log>
    80003322:	571c                	lw	a5,40(a4)
    80003324:	2785                	addiw	a5,a5,1
    80003326:	d71c                	sw	a5,40(a4)
    80003328:	a815                	j	8000335c <log_write+0xae>
    panic("too big a transaction");
    8000332a:	00005517          	auipc	a0,0x5
    8000332e:	19e50513          	addi	a0,a0,414 # 800084c8 <etext+0x4c8>
    80003332:	056030ef          	jal	80006388 <panic>
    panic("log_write outside of trans");
    80003336:	00005517          	auipc	a0,0x5
    8000333a:	1aa50513          	addi	a0,a0,426 # 800084e0 <etext+0x4e0>
    8000333e:	04a030ef          	jal	80006388 <panic>
  log.lh.block[i] = b->blockno;
    80003342:	00279693          	slli	a3,a5,0x2
    80003346:	02068693          	addi	a3,a3,32
    8000334a:	00017717          	auipc	a4,0x17
    8000334e:	f3670713          	addi	a4,a4,-202 # 8001a280 <log>
    80003352:	9736                	add	a4,a4,a3
    80003354:	44d4                	lw	a3,12(s1)
    80003356:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003358:	faf60ee3          	beq	a2,a5,80003314 <log_write+0x66>
  }
  release(&log.lock);
    8000335c:	00017517          	auipc	a0,0x17
    80003360:	f2450513          	addi	a0,a0,-220 # 8001a280 <log>
    80003364:	37a030ef          	jal	800066de <release>
}
    80003368:	60e2                	ld	ra,24(sp)
    8000336a:	6442                	ld	s0,16(sp)
    8000336c:	64a2                	ld	s1,8(sp)
    8000336e:	6105                	addi	sp,sp,32
    80003370:	8082                	ret

0000000080003372 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003372:	1101                	addi	sp,sp,-32
    80003374:	ec06                	sd	ra,24(sp)
    80003376:	e822                	sd	s0,16(sp)
    80003378:	e426                	sd	s1,8(sp)
    8000337a:	e04a                	sd	s2,0(sp)
    8000337c:	1000                	addi	s0,sp,32
    8000337e:	84aa                	mv	s1,a0
    80003380:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003382:	00005597          	auipc	a1,0x5
    80003386:	17e58593          	addi	a1,a1,382 # 80008500 <etext+0x500>
    8000338a:	0521                	addi	a0,a0,8
    8000338c:	234030ef          	jal	800065c0 <initlock>
  lk->name = name;
    80003390:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003394:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003398:	0204a423          	sw	zero,40(s1)
}
    8000339c:	60e2                	ld	ra,24(sp)
    8000339e:	6442                	ld	s0,16(sp)
    800033a0:	64a2                	ld	s1,8(sp)
    800033a2:	6902                	ld	s2,0(sp)
    800033a4:	6105                	addi	sp,sp,32
    800033a6:	8082                	ret

00000000800033a8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800033a8:	1101                	addi	sp,sp,-32
    800033aa:	ec06                	sd	ra,24(sp)
    800033ac:	e822                	sd	s0,16(sp)
    800033ae:	e426                	sd	s1,8(sp)
    800033b0:	e04a                	sd	s2,0(sp)
    800033b2:	1000                	addi	s0,sp,32
    800033b4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800033b6:	00850913          	addi	s2,a0,8
    800033ba:	854a                	mv	a0,s2
    800033bc:	28e030ef          	jal	8000664a <acquire>
  while (lk->locked) {
    800033c0:	409c                	lw	a5,0(s1)
    800033c2:	c799                	beqz	a5,800033d0 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800033c4:	85ca                	mv	a1,s2
    800033c6:	8526                	mv	a0,s1
    800033c8:	868fe0ef          	jal	80001430 <sleep>
  while (lk->locked) {
    800033cc:	409c                	lw	a5,0(s1)
    800033ce:	fbfd                	bnez	a5,800033c4 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800033d0:	4785                	li	a5,1
    800033d2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800033d4:	a35fd0ef          	jal	80000e08 <myproc>
    800033d8:	591c                	lw	a5,48(a0)
    800033da:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800033dc:	854a                	mv	a0,s2
    800033de:	300030ef          	jal	800066de <release>
}
    800033e2:	60e2                	ld	ra,24(sp)
    800033e4:	6442                	ld	s0,16(sp)
    800033e6:	64a2                	ld	s1,8(sp)
    800033e8:	6902                	ld	s2,0(sp)
    800033ea:	6105                	addi	sp,sp,32
    800033ec:	8082                	ret

00000000800033ee <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800033ee:	1101                	addi	sp,sp,-32
    800033f0:	ec06                	sd	ra,24(sp)
    800033f2:	e822                	sd	s0,16(sp)
    800033f4:	e426                	sd	s1,8(sp)
    800033f6:	e04a                	sd	s2,0(sp)
    800033f8:	1000                	addi	s0,sp,32
    800033fa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800033fc:	00850913          	addi	s2,a0,8
    80003400:	854a                	mv	a0,s2
    80003402:	248030ef          	jal	8000664a <acquire>
  lk->locked = 0;
    80003406:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000340a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000340e:	8526                	mv	a0,s1
    80003410:	86cfe0ef          	jal	8000147c <wakeup>
  release(&lk->lk);
    80003414:	854a                	mv	a0,s2
    80003416:	2c8030ef          	jal	800066de <release>
}
    8000341a:	60e2                	ld	ra,24(sp)
    8000341c:	6442                	ld	s0,16(sp)
    8000341e:	64a2                	ld	s1,8(sp)
    80003420:	6902                	ld	s2,0(sp)
    80003422:	6105                	addi	sp,sp,32
    80003424:	8082                	ret

0000000080003426 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003426:	7179                	addi	sp,sp,-48
    80003428:	f406                	sd	ra,40(sp)
    8000342a:	f022                	sd	s0,32(sp)
    8000342c:	ec26                	sd	s1,24(sp)
    8000342e:	e84a                	sd	s2,16(sp)
    80003430:	1800                	addi	s0,sp,48
    80003432:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003434:	00850913          	addi	s2,a0,8
    80003438:	854a                	mv	a0,s2
    8000343a:	210030ef          	jal	8000664a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000343e:	409c                	lw	a5,0(s1)
    80003440:	ef81                	bnez	a5,80003458 <holdingsleep+0x32>
    80003442:	4481                	li	s1,0
  release(&lk->lk);
    80003444:	854a                	mv	a0,s2
    80003446:	298030ef          	jal	800066de <release>
  return r;
}
    8000344a:	8526                	mv	a0,s1
    8000344c:	70a2                	ld	ra,40(sp)
    8000344e:	7402                	ld	s0,32(sp)
    80003450:	64e2                	ld	s1,24(sp)
    80003452:	6942                	ld	s2,16(sp)
    80003454:	6145                	addi	sp,sp,48
    80003456:	8082                	ret
    80003458:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000345a:	0284a983          	lw	s3,40(s1)
    8000345e:	9abfd0ef          	jal	80000e08 <myproc>
    80003462:	5904                	lw	s1,48(a0)
    80003464:	413484b3          	sub	s1,s1,s3
    80003468:	0014b493          	seqz	s1,s1
    8000346c:	69a2                	ld	s3,8(sp)
    8000346e:	bfd9                	j	80003444 <holdingsleep+0x1e>

0000000080003470 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003470:	1141                	addi	sp,sp,-16
    80003472:	e406                	sd	ra,8(sp)
    80003474:	e022                	sd	s0,0(sp)
    80003476:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003478:	00005597          	auipc	a1,0x5
    8000347c:	09858593          	addi	a1,a1,152 # 80008510 <etext+0x510>
    80003480:	00017517          	auipc	a0,0x17
    80003484:	f4850513          	addi	a0,a0,-184 # 8001a3c8 <ftable>
    80003488:	138030ef          	jal	800065c0 <initlock>
}
    8000348c:	60a2                	ld	ra,8(sp)
    8000348e:	6402                	ld	s0,0(sp)
    80003490:	0141                	addi	sp,sp,16
    80003492:	8082                	ret

0000000080003494 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003494:	1101                	addi	sp,sp,-32
    80003496:	ec06                	sd	ra,24(sp)
    80003498:	e822                	sd	s0,16(sp)
    8000349a:	e426                	sd	s1,8(sp)
    8000349c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000349e:	00017517          	auipc	a0,0x17
    800034a2:	f2a50513          	addi	a0,a0,-214 # 8001a3c8 <ftable>
    800034a6:	1a4030ef          	jal	8000664a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800034aa:	00017497          	auipc	s1,0x17
    800034ae:	f3648493          	addi	s1,s1,-202 # 8001a3e0 <ftable+0x18>
    800034b2:	00018717          	auipc	a4,0x18
    800034b6:	ece70713          	addi	a4,a4,-306 # 8001b380 <disk>
    if(f->ref == 0){
    800034ba:	40dc                	lw	a5,4(s1)
    800034bc:	cf89                	beqz	a5,800034d6 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800034be:	02848493          	addi	s1,s1,40
    800034c2:	fee49ce3          	bne	s1,a4,800034ba <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800034c6:	00017517          	auipc	a0,0x17
    800034ca:	f0250513          	addi	a0,a0,-254 # 8001a3c8 <ftable>
    800034ce:	210030ef          	jal	800066de <release>
  return 0;
    800034d2:	4481                	li	s1,0
    800034d4:	a809                	j	800034e6 <filealloc+0x52>
      f->ref = 1;
    800034d6:	4785                	li	a5,1
    800034d8:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800034da:	00017517          	auipc	a0,0x17
    800034de:	eee50513          	addi	a0,a0,-274 # 8001a3c8 <ftable>
    800034e2:	1fc030ef          	jal	800066de <release>
}
    800034e6:	8526                	mv	a0,s1
    800034e8:	60e2                	ld	ra,24(sp)
    800034ea:	6442                	ld	s0,16(sp)
    800034ec:	64a2                	ld	s1,8(sp)
    800034ee:	6105                	addi	sp,sp,32
    800034f0:	8082                	ret

00000000800034f2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800034f2:	1101                	addi	sp,sp,-32
    800034f4:	ec06                	sd	ra,24(sp)
    800034f6:	e822                	sd	s0,16(sp)
    800034f8:	e426                	sd	s1,8(sp)
    800034fa:	1000                	addi	s0,sp,32
    800034fc:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800034fe:	00017517          	auipc	a0,0x17
    80003502:	eca50513          	addi	a0,a0,-310 # 8001a3c8 <ftable>
    80003506:	144030ef          	jal	8000664a <acquire>
  if(f->ref < 1)
    8000350a:	40dc                	lw	a5,4(s1)
    8000350c:	02f05063          	blez	a5,8000352c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003510:	2785                	addiw	a5,a5,1
    80003512:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003514:	00017517          	auipc	a0,0x17
    80003518:	eb450513          	addi	a0,a0,-332 # 8001a3c8 <ftable>
    8000351c:	1c2030ef          	jal	800066de <release>
  return f;
}
    80003520:	8526                	mv	a0,s1
    80003522:	60e2                	ld	ra,24(sp)
    80003524:	6442                	ld	s0,16(sp)
    80003526:	64a2                	ld	s1,8(sp)
    80003528:	6105                	addi	sp,sp,32
    8000352a:	8082                	ret
    panic("filedup");
    8000352c:	00005517          	auipc	a0,0x5
    80003530:	fec50513          	addi	a0,a0,-20 # 80008518 <etext+0x518>
    80003534:	655020ef          	jal	80006388 <panic>

0000000080003538 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003538:	7139                	addi	sp,sp,-64
    8000353a:	fc06                	sd	ra,56(sp)
    8000353c:	f822                	sd	s0,48(sp)
    8000353e:	f426                	sd	s1,40(sp)
    80003540:	0080                	addi	s0,sp,64
    80003542:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003544:	00017517          	auipc	a0,0x17
    80003548:	e8450513          	addi	a0,a0,-380 # 8001a3c8 <ftable>
    8000354c:	0fe030ef          	jal	8000664a <acquire>
  if(f->ref < 1)
    80003550:	40dc                	lw	a5,4(s1)
    80003552:	04f05a63          	blez	a5,800035a6 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003556:	37fd                	addiw	a5,a5,-1
    80003558:	c0dc                	sw	a5,4(s1)
    8000355a:	06f04063          	bgtz	a5,800035ba <fileclose+0x82>
    8000355e:	f04a                	sd	s2,32(sp)
    80003560:	ec4e                	sd	s3,24(sp)
    80003562:	e852                	sd	s4,16(sp)
    80003564:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003566:	0004a903          	lw	s2,0(s1)
    8000356a:	0094c783          	lbu	a5,9(s1)
    8000356e:	89be                	mv	s3,a5
    80003570:	689c                	ld	a5,16(s1)
    80003572:	8a3e                	mv	s4,a5
    80003574:	6c9c                	ld	a5,24(s1)
    80003576:	8abe                	mv	s5,a5
  f->ref = 0;
    80003578:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000357c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003580:	00017517          	auipc	a0,0x17
    80003584:	e4850513          	addi	a0,a0,-440 # 8001a3c8 <ftable>
    80003588:	156030ef          	jal	800066de <release>

  if(ff.type == FD_PIPE){
    8000358c:	4785                	li	a5,1
    8000358e:	04f90163          	beq	s2,a5,800035d0 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003592:	ffe9079b          	addiw	a5,s2,-2
    80003596:	4705                	li	a4,1
    80003598:	04f77563          	bgeu	a4,a5,800035e2 <fileclose+0xaa>
    8000359c:	7902                	ld	s2,32(sp)
    8000359e:	69e2                	ld	s3,24(sp)
    800035a0:	6a42                	ld	s4,16(sp)
    800035a2:	6aa2                	ld	s5,8(sp)
    800035a4:	a00d                	j	800035c6 <fileclose+0x8e>
    800035a6:	f04a                	sd	s2,32(sp)
    800035a8:	ec4e                	sd	s3,24(sp)
    800035aa:	e852                	sd	s4,16(sp)
    800035ac:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800035ae:	00005517          	auipc	a0,0x5
    800035b2:	f7250513          	addi	a0,a0,-142 # 80008520 <etext+0x520>
    800035b6:	5d3020ef          	jal	80006388 <panic>
    release(&ftable.lock);
    800035ba:	00017517          	auipc	a0,0x17
    800035be:	e0e50513          	addi	a0,a0,-498 # 8001a3c8 <ftable>
    800035c2:	11c030ef          	jal	800066de <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800035c6:	70e2                	ld	ra,56(sp)
    800035c8:	7442                	ld	s0,48(sp)
    800035ca:	74a2                	ld	s1,40(sp)
    800035cc:	6121                	addi	sp,sp,64
    800035ce:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800035d0:	85ce                	mv	a1,s3
    800035d2:	8552                	mv	a0,s4
    800035d4:	348000ef          	jal	8000391c <pipeclose>
    800035d8:	7902                	ld	s2,32(sp)
    800035da:	69e2                	ld	s3,24(sp)
    800035dc:	6a42                	ld	s4,16(sp)
    800035de:	6aa2                	ld	s5,8(sp)
    800035e0:	b7dd                	j	800035c6 <fileclose+0x8e>
    begin_op();
    800035e2:	b33ff0ef          	jal	80003114 <begin_op>
    iput(ff.ip);
    800035e6:	8556                	mv	a0,s5
    800035e8:	aa2ff0ef          	jal	8000288a <iput>
    end_op();
    800035ec:	b99ff0ef          	jal	80003184 <end_op>
    800035f0:	7902                	ld	s2,32(sp)
    800035f2:	69e2                	ld	s3,24(sp)
    800035f4:	6a42                	ld	s4,16(sp)
    800035f6:	6aa2                	ld	s5,8(sp)
    800035f8:	b7f9                	j	800035c6 <fileclose+0x8e>

00000000800035fa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800035fa:	715d                	addi	sp,sp,-80
    800035fc:	e486                	sd	ra,72(sp)
    800035fe:	e0a2                	sd	s0,64(sp)
    80003600:	fc26                	sd	s1,56(sp)
    80003602:	f052                	sd	s4,32(sp)
    80003604:	0880                	addi	s0,sp,80
    80003606:	84aa                	mv	s1,a0
    80003608:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000360a:	ffefd0ef          	jal	80000e08 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000360e:	409c                	lw	a5,0(s1)
    80003610:	37f9                	addiw	a5,a5,-2
    80003612:	4705                	li	a4,1
    80003614:	04f76263          	bltu	a4,a5,80003658 <filestat+0x5e>
    80003618:	f84a                	sd	s2,48(sp)
    8000361a:	f44e                	sd	s3,40(sp)
    8000361c:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000361e:	6c88                	ld	a0,24(s1)
    80003620:	8e8ff0ef          	jal	80002708 <ilock>
    stati(f->ip, &st);
    80003624:	fb840913          	addi	s2,s0,-72
    80003628:	85ca                	mv	a1,s2
    8000362a:	6c88                	ld	a0,24(s1)
    8000362c:	c40ff0ef          	jal	80002a6c <stati>
    iunlock(f->ip);
    80003630:	6c88                	ld	a0,24(s1)
    80003632:	984ff0ef          	jal	800027b6 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003636:	46e1                	li	a3,24
    80003638:	864a                	mv	a2,s2
    8000363a:	85d2                	mv	a1,s4
    8000363c:	0509b503          	ld	a0,80(s3)
    80003640:	cc6fd0ef          	jal	80000b06 <copyout>
    80003644:	41f5551b          	sraiw	a0,a0,0x1f
    80003648:	7942                	ld	s2,48(sp)
    8000364a:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000364c:	60a6                	ld	ra,72(sp)
    8000364e:	6406                	ld	s0,64(sp)
    80003650:	74e2                	ld	s1,56(sp)
    80003652:	7a02                	ld	s4,32(sp)
    80003654:	6161                	addi	sp,sp,80
    80003656:	8082                	ret
  return -1;
    80003658:	557d                	li	a0,-1
    8000365a:	bfcd                	j	8000364c <filestat+0x52>

000000008000365c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000365c:	7179                	addi	sp,sp,-48
    8000365e:	f406                	sd	ra,40(sp)
    80003660:	f022                	sd	s0,32(sp)
    80003662:	e84a                	sd	s2,16(sp)
    80003664:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003666:	00854783          	lbu	a5,8(a0)
    8000366a:	cfd1                	beqz	a5,80003706 <fileread+0xaa>
    8000366c:	ec26                	sd	s1,24(sp)
    8000366e:	e44e                	sd	s3,8(sp)
    80003670:	84aa                	mv	s1,a0
    80003672:	892e                	mv	s2,a1
    80003674:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80003676:	411c                	lw	a5,0(a0)
    80003678:	4705                	li	a4,1
    8000367a:	04e78363          	beq	a5,a4,800036c0 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000367e:	470d                	li	a4,3
    80003680:	04e78763          	beq	a5,a4,800036ce <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003684:	4709                	li	a4,2
    80003686:	06e79a63          	bne	a5,a4,800036fa <fileread+0x9e>
    ilock(f->ip);
    8000368a:	6d08                	ld	a0,24(a0)
    8000368c:	87cff0ef          	jal	80002708 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003690:	874e                	mv	a4,s3
    80003692:	5094                	lw	a3,32(s1)
    80003694:	864a                	mv	a2,s2
    80003696:	4585                	li	a1,1
    80003698:	6c88                	ld	a0,24(s1)
    8000369a:	c00ff0ef          	jal	80002a9a <readi>
    8000369e:	892a                	mv	s2,a0
    800036a0:	00a05563          	blez	a0,800036aa <fileread+0x4e>
      f->off += r;
    800036a4:	509c                	lw	a5,32(s1)
    800036a6:	9fa9                	addw	a5,a5,a0
    800036a8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800036aa:	6c88                	ld	a0,24(s1)
    800036ac:	90aff0ef          	jal	800027b6 <iunlock>
    800036b0:	64e2                	ld	s1,24(sp)
    800036b2:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800036b4:	854a                	mv	a0,s2
    800036b6:	70a2                	ld	ra,40(sp)
    800036b8:	7402                	ld	s0,32(sp)
    800036ba:	6942                	ld	s2,16(sp)
    800036bc:	6145                	addi	sp,sp,48
    800036be:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800036c0:	6908                	ld	a0,16(a0)
    800036c2:	3b0000ef          	jal	80003a72 <piperead>
    800036c6:	892a                	mv	s2,a0
    800036c8:	64e2                	ld	s1,24(sp)
    800036ca:	69a2                	ld	s3,8(sp)
    800036cc:	b7e5                	j	800036b4 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800036ce:	02451783          	lh	a5,36(a0)
    800036d2:	03079693          	slli	a3,a5,0x30
    800036d6:	92c1                	srli	a3,a3,0x30
    800036d8:	4725                	li	a4,9
    800036da:	02d76963          	bltu	a4,a3,8000370c <fileread+0xb0>
    800036de:	0792                	slli	a5,a5,0x4
    800036e0:	00017717          	auipc	a4,0x17
    800036e4:	c4870713          	addi	a4,a4,-952 # 8001a328 <devsw>
    800036e8:	97ba                	add	a5,a5,a4
    800036ea:	639c                	ld	a5,0(a5)
    800036ec:	c78d                	beqz	a5,80003716 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    800036ee:	4505                	li	a0,1
    800036f0:	9782                	jalr	a5
    800036f2:	892a                	mv	s2,a0
    800036f4:	64e2                	ld	s1,24(sp)
    800036f6:	69a2                	ld	s3,8(sp)
    800036f8:	bf75                	j	800036b4 <fileread+0x58>
    panic("fileread");
    800036fa:	00005517          	auipc	a0,0x5
    800036fe:	e3650513          	addi	a0,a0,-458 # 80008530 <etext+0x530>
    80003702:	487020ef          	jal	80006388 <panic>
    return -1;
    80003706:	57fd                	li	a5,-1
    80003708:	893e                	mv	s2,a5
    8000370a:	b76d                	j	800036b4 <fileread+0x58>
      return -1;
    8000370c:	57fd                	li	a5,-1
    8000370e:	893e                	mv	s2,a5
    80003710:	64e2                	ld	s1,24(sp)
    80003712:	69a2                	ld	s3,8(sp)
    80003714:	b745                	j	800036b4 <fileread+0x58>
    80003716:	57fd                	li	a5,-1
    80003718:	893e                	mv	s2,a5
    8000371a:	64e2                	ld	s1,24(sp)
    8000371c:	69a2                	ld	s3,8(sp)
    8000371e:	bf59                	j	800036b4 <fileread+0x58>

0000000080003720 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003720:	00954783          	lbu	a5,9(a0)
    80003724:	10078f63          	beqz	a5,80003842 <filewrite+0x122>
{
    80003728:	711d                	addi	sp,sp,-96
    8000372a:	ec86                	sd	ra,88(sp)
    8000372c:	e8a2                	sd	s0,80(sp)
    8000372e:	e0ca                	sd	s2,64(sp)
    80003730:	f456                	sd	s5,40(sp)
    80003732:	f05a                	sd	s6,32(sp)
    80003734:	1080                	addi	s0,sp,96
    80003736:	892a                	mv	s2,a0
    80003738:	8b2e                	mv	s6,a1
    8000373a:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000373c:	411c                	lw	a5,0(a0)
    8000373e:	4705                	li	a4,1
    80003740:	02e78a63          	beq	a5,a4,80003774 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003744:	470d                	li	a4,3
    80003746:	02e78b63          	beq	a5,a4,8000377c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000374a:	4709                	li	a4,2
    8000374c:	0ce79f63          	bne	a5,a4,8000382a <filewrite+0x10a>
    80003750:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003752:	0ac05a63          	blez	a2,80003806 <filewrite+0xe6>
    80003756:	e4a6                	sd	s1,72(sp)
    80003758:	fc4e                	sd	s3,56(sp)
    8000375a:	ec5e                	sd	s7,24(sp)
    8000375c:	e862                	sd	s8,16(sp)
    8000375e:	e466                	sd	s9,8(sp)
    int i = 0;
    80003760:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003762:	6b85                	lui	s7,0x1
    80003764:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003768:	6785                	lui	a5,0x1
    8000376a:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000376e:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003770:	4c05                	li	s8,1
    80003772:	a8ad                	j	800037ec <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003774:	6908                	ld	a0,16(a0)
    80003776:	204000ef          	jal	8000397a <pipewrite>
    8000377a:	a04d                	j	8000381c <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000377c:	02451783          	lh	a5,36(a0)
    80003780:	03079693          	slli	a3,a5,0x30
    80003784:	92c1                	srli	a3,a3,0x30
    80003786:	4725                	li	a4,9
    80003788:	0ad76f63          	bltu	a4,a3,80003846 <filewrite+0x126>
    8000378c:	0792                	slli	a5,a5,0x4
    8000378e:	00017717          	auipc	a4,0x17
    80003792:	b9a70713          	addi	a4,a4,-1126 # 8001a328 <devsw>
    80003796:	97ba                	add	a5,a5,a4
    80003798:	679c                	ld	a5,8(a5)
    8000379a:	cbc5                	beqz	a5,8000384a <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    8000379c:	4505                	li	a0,1
    8000379e:	9782                	jalr	a5
    800037a0:	a8b5                	j	8000381c <filewrite+0xfc>
      if(n1 > max)
    800037a2:	2981                	sext.w	s3,s3
      begin_op();
    800037a4:	971ff0ef          	jal	80003114 <begin_op>
      ilock(f->ip);
    800037a8:	01893503          	ld	a0,24(s2)
    800037ac:	f5dfe0ef          	jal	80002708 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800037b0:	874e                	mv	a4,s3
    800037b2:	02092683          	lw	a3,32(s2)
    800037b6:	016a0633          	add	a2,s4,s6
    800037ba:	85e2                	mv	a1,s8
    800037bc:	01893503          	ld	a0,24(s2)
    800037c0:	bccff0ef          	jal	80002b8c <writei>
    800037c4:	84aa                	mv	s1,a0
    800037c6:	00a05763          	blez	a0,800037d4 <filewrite+0xb4>
        f->off += r;
    800037ca:	02092783          	lw	a5,32(s2)
    800037ce:	9fa9                	addw	a5,a5,a0
    800037d0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800037d4:	01893503          	ld	a0,24(s2)
    800037d8:	fdffe0ef          	jal	800027b6 <iunlock>
      end_op();
    800037dc:	9a9ff0ef          	jal	80003184 <end_op>

      if(r != n1){
    800037e0:	02999563          	bne	s3,s1,8000380a <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    800037e4:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800037e8:	015a5963          	bge	s4,s5,800037fa <filewrite+0xda>
      int n1 = n - i;
    800037ec:	414a87bb          	subw	a5,s5,s4
    800037f0:	89be                	mv	s3,a5
      if(n1 > max)
    800037f2:	fafbd8e3          	bge	s7,a5,800037a2 <filewrite+0x82>
    800037f6:	89e6                	mv	s3,s9
    800037f8:	b76d                	j	800037a2 <filewrite+0x82>
    800037fa:	64a6                	ld	s1,72(sp)
    800037fc:	79e2                	ld	s3,56(sp)
    800037fe:	6be2                	ld	s7,24(sp)
    80003800:	6c42                	ld	s8,16(sp)
    80003802:	6ca2                	ld	s9,8(sp)
    80003804:	a801                	j	80003814 <filewrite+0xf4>
    int i = 0;
    80003806:	4a01                	li	s4,0
    80003808:	a031                	j	80003814 <filewrite+0xf4>
    8000380a:	64a6                	ld	s1,72(sp)
    8000380c:	79e2                	ld	s3,56(sp)
    8000380e:	6be2                	ld	s7,24(sp)
    80003810:	6c42                	ld	s8,16(sp)
    80003812:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003814:	034a9d63          	bne	s5,s4,8000384e <filewrite+0x12e>
    80003818:	8556                	mv	a0,s5
    8000381a:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000381c:	60e6                	ld	ra,88(sp)
    8000381e:	6446                	ld	s0,80(sp)
    80003820:	6906                	ld	s2,64(sp)
    80003822:	7aa2                	ld	s5,40(sp)
    80003824:	7b02                	ld	s6,32(sp)
    80003826:	6125                	addi	sp,sp,96
    80003828:	8082                	ret
    8000382a:	e4a6                	sd	s1,72(sp)
    8000382c:	fc4e                	sd	s3,56(sp)
    8000382e:	f852                	sd	s4,48(sp)
    80003830:	ec5e                	sd	s7,24(sp)
    80003832:	e862                	sd	s8,16(sp)
    80003834:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003836:	00005517          	auipc	a0,0x5
    8000383a:	d0a50513          	addi	a0,a0,-758 # 80008540 <etext+0x540>
    8000383e:	34b020ef          	jal	80006388 <panic>
    return -1;
    80003842:	557d                	li	a0,-1
}
    80003844:	8082                	ret
      return -1;
    80003846:	557d                	li	a0,-1
    80003848:	bfd1                	j	8000381c <filewrite+0xfc>
    8000384a:	557d                	li	a0,-1
    8000384c:	bfc1                	j	8000381c <filewrite+0xfc>
    ret = (i == n ? n : -1);
    8000384e:	557d                	li	a0,-1
    80003850:	7a42                	ld	s4,48(sp)
    80003852:	b7e9                	j	8000381c <filewrite+0xfc>

0000000080003854 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003854:	7179                	addi	sp,sp,-48
    80003856:	f406                	sd	ra,40(sp)
    80003858:	f022                	sd	s0,32(sp)
    8000385a:	ec26                	sd	s1,24(sp)
    8000385c:	e052                	sd	s4,0(sp)
    8000385e:	1800                	addi	s0,sp,48
    80003860:	84aa                	mv	s1,a0
    80003862:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003864:	0005b023          	sd	zero,0(a1)
    80003868:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000386c:	c29ff0ef          	jal	80003494 <filealloc>
    80003870:	e088                	sd	a0,0(s1)
    80003872:	c549                	beqz	a0,800038fc <pipealloc+0xa8>
    80003874:	c21ff0ef          	jal	80003494 <filealloc>
    80003878:	00aa3023          	sd	a0,0(s4)
    8000387c:	cd25                	beqz	a0,800038f4 <pipealloc+0xa0>
    8000387e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003880:	885fc0ef          	jal	80000104 <kalloc>
    80003884:	892a                	mv	s2,a0
    80003886:	c12d                	beqz	a0,800038e8 <pipealloc+0x94>
    80003888:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000388a:	4985                	li	s3,1
    8000388c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003890:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003894:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003898:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000389c:	00005597          	auipc	a1,0x5
    800038a0:	cb458593          	addi	a1,a1,-844 # 80008550 <etext+0x550>
    800038a4:	51d020ef          	jal	800065c0 <initlock>
  (*f0)->type = FD_PIPE;
    800038a8:	609c                	ld	a5,0(s1)
    800038aa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800038ae:	609c                	ld	a5,0(s1)
    800038b0:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    800038b4:	609c                	ld	a5,0(s1)
    800038b6:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    800038ba:	609c                	ld	a5,0(s1)
    800038bc:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    800038c0:	000a3783          	ld	a5,0(s4)
    800038c4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    800038c8:	000a3783          	ld	a5,0(s4)
    800038cc:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    800038d0:	000a3783          	ld	a5,0(s4)
    800038d4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    800038d8:	000a3783          	ld	a5,0(s4)
    800038dc:	0127b823          	sd	s2,16(a5)
  return 0;
    800038e0:	4501                	li	a0,0
    800038e2:	6942                	ld	s2,16(sp)
    800038e4:	69a2                	ld	s3,8(sp)
    800038e6:	a01d                	j	8000390c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    800038e8:	6088                	ld	a0,0(s1)
    800038ea:	c119                	beqz	a0,800038f0 <pipealloc+0x9c>
    800038ec:	6942                	ld	s2,16(sp)
    800038ee:	a029                	j	800038f8 <pipealloc+0xa4>
    800038f0:	6942                	ld	s2,16(sp)
    800038f2:	a029                	j	800038fc <pipealloc+0xa8>
    800038f4:	6088                	ld	a0,0(s1)
    800038f6:	c10d                	beqz	a0,80003918 <pipealloc+0xc4>
    fileclose(*f0);
    800038f8:	c41ff0ef          	jal	80003538 <fileclose>
  if(*f1)
    800038fc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003900:	557d                	li	a0,-1
  if(*f1)
    80003902:	c789                	beqz	a5,8000390c <pipealloc+0xb8>
    fileclose(*f1);
    80003904:	853e                	mv	a0,a5
    80003906:	c33ff0ef          	jal	80003538 <fileclose>
  return -1;
    8000390a:	557d                	li	a0,-1
}
    8000390c:	70a2                	ld	ra,40(sp)
    8000390e:	7402                	ld	s0,32(sp)
    80003910:	64e2                	ld	s1,24(sp)
    80003912:	6a02                	ld	s4,0(sp)
    80003914:	6145                	addi	sp,sp,48
    80003916:	8082                	ret
  return -1;
    80003918:	557d                	li	a0,-1
    8000391a:	bfcd                	j	8000390c <pipealloc+0xb8>

000000008000391c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec06                	sd	ra,24(sp)
    80003920:	e822                	sd	s0,16(sp)
    80003922:	e426                	sd	s1,8(sp)
    80003924:	e04a                	sd	s2,0(sp)
    80003926:	1000                	addi	s0,sp,32
    80003928:	84aa                	mv	s1,a0
    8000392a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000392c:	51f020ef          	jal	8000664a <acquire>
  if(writable){
    80003930:	02090763          	beqz	s2,8000395e <pipeclose+0x42>
    pi->writeopen = 0;
    80003934:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003938:	21848513          	addi	a0,s1,536
    8000393c:	b41fd0ef          	jal	8000147c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003940:	2204a783          	lw	a5,544(s1)
    80003944:	e781                	bnez	a5,8000394c <pipeclose+0x30>
    80003946:	2244a783          	lw	a5,548(s1)
    8000394a:	c38d                	beqz	a5,8000396c <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    8000394c:	8526                	mv	a0,s1
    8000394e:	591020ef          	jal	800066de <release>
}
    80003952:	60e2                	ld	ra,24(sp)
    80003954:	6442                	ld	s0,16(sp)
    80003956:	64a2                	ld	s1,8(sp)
    80003958:	6902                	ld	s2,0(sp)
    8000395a:	6105                	addi	sp,sp,32
    8000395c:	8082                	ret
    pi->readopen = 0;
    8000395e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003962:	21c48513          	addi	a0,s1,540
    80003966:	b17fd0ef          	jal	8000147c <wakeup>
    8000396a:	bfd9                	j	80003940 <pipeclose+0x24>
    release(&pi->lock);
    8000396c:	8526                	mv	a0,s1
    8000396e:	571020ef          	jal	800066de <release>
    kfree((char*)pi);
    80003972:	8526                	mv	a0,s1
    80003974:	ea8fc0ef          	jal	8000001c <kfree>
    80003978:	bfe9                	j	80003952 <pipeclose+0x36>

000000008000397a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000397a:	7159                	addi	sp,sp,-112
    8000397c:	f486                	sd	ra,104(sp)
    8000397e:	f0a2                	sd	s0,96(sp)
    80003980:	eca6                	sd	s1,88(sp)
    80003982:	e8ca                	sd	s2,80(sp)
    80003984:	e4ce                	sd	s3,72(sp)
    80003986:	e0d2                	sd	s4,64(sp)
    80003988:	fc56                	sd	s5,56(sp)
    8000398a:	1880                	addi	s0,sp,112
    8000398c:	84aa                	mv	s1,a0
    8000398e:	8aae                	mv	s5,a1
    80003990:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003992:	c76fd0ef          	jal	80000e08 <myproc>
    80003996:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003998:	8526                	mv	a0,s1
    8000399a:	4b1020ef          	jal	8000664a <acquire>
  while(i < n){
    8000399e:	0d405263          	blez	s4,80003a62 <pipewrite+0xe8>
    800039a2:	f85a                	sd	s6,48(sp)
    800039a4:	f45e                	sd	s7,40(sp)
    800039a6:	f062                	sd	s8,32(sp)
    800039a8:	ec66                	sd	s9,24(sp)
    800039aa:	e86a                	sd	s10,16(sp)
  int i = 0;
    800039ac:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800039ae:	f9f40c13          	addi	s8,s0,-97
    800039b2:	4b85                	li	s7,1
    800039b4:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    800039b6:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    800039ba:	21c48c93          	addi	s9,s1,540
    800039be:	a82d                	j	800039f8 <pipewrite+0x7e>
      release(&pi->lock);
    800039c0:	8526                	mv	a0,s1
    800039c2:	51d020ef          	jal	800066de <release>
      return -1;
    800039c6:	597d                	li	s2,-1
    800039c8:	7b42                	ld	s6,48(sp)
    800039ca:	7ba2                	ld	s7,40(sp)
    800039cc:	7c02                	ld	s8,32(sp)
    800039ce:	6ce2                	ld	s9,24(sp)
    800039d0:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    800039d2:	854a                	mv	a0,s2
    800039d4:	70a6                	ld	ra,104(sp)
    800039d6:	7406                	ld	s0,96(sp)
    800039d8:	64e6                	ld	s1,88(sp)
    800039da:	6946                	ld	s2,80(sp)
    800039dc:	69a6                	ld	s3,72(sp)
    800039de:	6a06                	ld	s4,64(sp)
    800039e0:	7ae2                	ld	s5,56(sp)
    800039e2:	6165                	addi	sp,sp,112
    800039e4:	8082                	ret
      wakeup(&pi->nread);
    800039e6:	856a                	mv	a0,s10
    800039e8:	a95fd0ef          	jal	8000147c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    800039ec:	85a6                	mv	a1,s1
    800039ee:	8566                	mv	a0,s9
    800039f0:	a41fd0ef          	jal	80001430 <sleep>
  while(i < n){
    800039f4:	05495a63          	bge	s2,s4,80003a48 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800039f8:	2204a783          	lw	a5,544(s1)
    800039fc:	d3f1                	beqz	a5,800039c0 <pipewrite+0x46>
    800039fe:	854e                	mv	a0,s3
    80003a00:	c6dfd0ef          	jal	8000166c <killed>
    80003a04:	fd55                	bnez	a0,800039c0 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003a06:	2184a783          	lw	a5,536(s1)
    80003a0a:	21c4a703          	lw	a4,540(s1)
    80003a0e:	2007879b          	addiw	a5,a5,512
    80003a12:	fcf70ae3          	beq	a4,a5,800039e6 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a16:	86de                	mv	a3,s7
    80003a18:	01590633          	add	a2,s2,s5
    80003a1c:	85e2                	mv	a1,s8
    80003a1e:	0509b503          	ld	a0,80(s3)
    80003a22:	9a8fd0ef          	jal	80000bca <copyin>
    80003a26:	05650063          	beq	a0,s6,80003a66 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003a2a:	21c4a783          	lw	a5,540(s1)
    80003a2e:	0017871b          	addiw	a4,a5,1
    80003a32:	20e4ae23          	sw	a4,540(s1)
    80003a36:	1ff7f793          	andi	a5,a5,511
    80003a3a:	97a6                	add	a5,a5,s1
    80003a3c:	f9f44703          	lbu	a4,-97(s0)
    80003a40:	00e78c23          	sb	a4,24(a5)
      i++;
    80003a44:	2905                	addiw	s2,s2,1
    80003a46:	b77d                	j	800039f4 <pipewrite+0x7a>
    80003a48:	7b42                	ld	s6,48(sp)
    80003a4a:	7ba2                	ld	s7,40(sp)
    80003a4c:	7c02                	ld	s8,32(sp)
    80003a4e:	6ce2                	ld	s9,24(sp)
    80003a50:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003a52:	21848513          	addi	a0,s1,536
    80003a56:	a27fd0ef          	jal	8000147c <wakeup>
  release(&pi->lock);
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	483020ef          	jal	800066de <release>
  return i;
    80003a60:	bf8d                	j	800039d2 <pipewrite+0x58>
  int i = 0;
    80003a62:	4901                	li	s2,0
    80003a64:	b7fd                	j	80003a52 <pipewrite+0xd8>
    80003a66:	7b42                	ld	s6,48(sp)
    80003a68:	7ba2                	ld	s7,40(sp)
    80003a6a:	7c02                	ld	s8,32(sp)
    80003a6c:	6ce2                	ld	s9,24(sp)
    80003a6e:	6d42                	ld	s10,16(sp)
    80003a70:	b7cd                	j	80003a52 <pipewrite+0xd8>

0000000080003a72 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003a72:	711d                	addi	sp,sp,-96
    80003a74:	ec86                	sd	ra,88(sp)
    80003a76:	e8a2                	sd	s0,80(sp)
    80003a78:	e4a6                	sd	s1,72(sp)
    80003a7a:	e0ca                	sd	s2,64(sp)
    80003a7c:	fc4e                	sd	s3,56(sp)
    80003a7e:	f852                	sd	s4,48(sp)
    80003a80:	f456                	sd	s5,40(sp)
    80003a82:	1080                	addi	s0,sp,96
    80003a84:	84aa                	mv	s1,a0
    80003a86:	892e                	mv	s2,a1
    80003a88:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003a8a:	b7efd0ef          	jal	80000e08 <myproc>
    80003a8e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003a90:	8526                	mv	a0,s1
    80003a92:	3b9020ef          	jal	8000664a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a96:	2184a703          	lw	a4,536(s1)
    80003a9a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a9e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003aa2:	02f71763          	bne	a4,a5,80003ad0 <piperead+0x5e>
    80003aa6:	2244a783          	lw	a5,548(s1)
    80003aaa:	cf85                	beqz	a5,80003ae2 <piperead+0x70>
    if(killed(pr)){
    80003aac:	8552                	mv	a0,s4
    80003aae:	bbffd0ef          	jal	8000166c <killed>
    80003ab2:	e11d                	bnez	a0,80003ad8 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ab4:	85a6                	mv	a1,s1
    80003ab6:	854e                	mv	a0,s3
    80003ab8:	979fd0ef          	jal	80001430 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003abc:	2184a703          	lw	a4,536(s1)
    80003ac0:	21c4a783          	lw	a5,540(s1)
    80003ac4:	fef701e3          	beq	a4,a5,80003aa6 <piperead+0x34>
    80003ac8:	f05a                	sd	s6,32(sp)
    80003aca:	ec5e                	sd	s7,24(sp)
    80003acc:	e862                	sd	s8,16(sp)
    80003ace:	a829                	j	80003ae8 <piperead+0x76>
    80003ad0:	f05a                	sd	s6,32(sp)
    80003ad2:	ec5e                	sd	s7,24(sp)
    80003ad4:	e862                	sd	s8,16(sp)
    80003ad6:	a809                	j	80003ae8 <piperead+0x76>
      release(&pi->lock);
    80003ad8:	8526                	mv	a0,s1
    80003ada:	405020ef          	jal	800066de <release>
      return -1;
    80003ade:	59fd                	li	s3,-1
    80003ae0:	a09d                	j	80003b46 <piperead+0xd4>
    80003ae2:	f05a                	sd	s6,32(sp)
    80003ae4:	ec5e                	sd	s7,24(sp)
    80003ae6:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ae8:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003aea:	faf40c13          	addi	s8,s0,-81
    80003aee:	4b85                	li	s7,1
    80003af0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003af2:	05505063          	blez	s5,80003b32 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003af6:	2184a783          	lw	a5,536(s1)
    80003afa:	21c4a703          	lw	a4,540(s1)
    80003afe:	02f70a63          	beq	a4,a5,80003b32 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003b02:	0017871b          	addiw	a4,a5,1
    80003b06:	20e4ac23          	sw	a4,536(s1)
    80003b0a:	1ff7f793          	andi	a5,a5,511
    80003b0e:	97a6                	add	a5,a5,s1
    80003b10:	0187c783          	lbu	a5,24(a5)
    80003b14:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b18:	86de                	mv	a3,s7
    80003b1a:	8662                	mv	a2,s8
    80003b1c:	85ca                	mv	a1,s2
    80003b1e:	050a3503          	ld	a0,80(s4)
    80003b22:	fe5fc0ef          	jal	80000b06 <copyout>
    80003b26:	01650663          	beq	a0,s6,80003b32 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b2a:	2985                	addiw	s3,s3,1
    80003b2c:	0905                	addi	s2,s2,1
    80003b2e:	fd3a94e3          	bne	s5,s3,80003af6 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003b32:	21c48513          	addi	a0,s1,540
    80003b36:	947fd0ef          	jal	8000147c <wakeup>
  release(&pi->lock);
    80003b3a:	8526                	mv	a0,s1
    80003b3c:	3a3020ef          	jal	800066de <release>
    80003b40:	7b02                	ld	s6,32(sp)
    80003b42:	6be2                	ld	s7,24(sp)
    80003b44:	6c42                	ld	s8,16(sp)
  return i;
}
    80003b46:	854e                	mv	a0,s3
    80003b48:	60e6                	ld	ra,88(sp)
    80003b4a:	6446                	ld	s0,80(sp)
    80003b4c:	64a6                	ld	s1,72(sp)
    80003b4e:	6906                	ld	s2,64(sp)
    80003b50:	79e2                	ld	s3,56(sp)
    80003b52:	7a42                	ld	s4,48(sp)
    80003b54:	7aa2                	ld	s5,40(sp)
    80003b56:	6125                	addi	sp,sp,96
    80003b58:	8082                	ret

0000000080003b5a <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003b5a:	1141                	addi	sp,sp,-16
    80003b5c:	e406                	sd	ra,8(sp)
    80003b5e:	e022                	sd	s0,0(sp)
    80003b60:	0800                	addi	s0,sp,16
    80003b62:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003b64:	0035151b          	slliw	a0,a0,0x3
    80003b68:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003b6a:	8b89                	andi	a5,a5,2
    80003b6c:	c399                	beqz	a5,80003b72 <flags2perm+0x18>
      perm |= PTE_W;
    80003b6e:	00456513          	ori	a0,a0,4
    return perm;
}
    80003b72:	60a2                	ld	ra,8(sp)
    80003b74:	6402                	ld	s0,0(sp)
    80003b76:	0141                	addi	sp,sp,16
    80003b78:	8082                	ret

0000000080003b7a <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003b7a:	de010113          	addi	sp,sp,-544
    80003b7e:	20113c23          	sd	ra,536(sp)
    80003b82:	20813823          	sd	s0,528(sp)
    80003b86:	20913423          	sd	s1,520(sp)
    80003b8a:	21213023          	sd	s2,512(sp)
    80003b8e:	1400                	addi	s0,sp,544
    80003b90:	892a                	mv	s2,a0
    80003b92:	dea43823          	sd	a0,-528(s0)
    80003b96:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003b9a:	a6efd0ef          	jal	80000e08 <myproc>
    80003b9e:	84aa                	mv	s1,a0

  begin_op();
    80003ba0:	d74ff0ef          	jal	80003114 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003ba4:	854a                	mv	a0,s2
    80003ba6:	b90ff0ef          	jal	80002f36 <namei>
    80003baa:	cd21                	beqz	a0,80003c02 <kexec+0x88>
    80003bac:	fbd2                	sd	s4,496(sp)
    80003bae:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003bb0:	b59fe0ef          	jal	80002708 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003bb4:	04000713          	li	a4,64
    80003bb8:	4681                	li	a3,0
    80003bba:	e5040613          	addi	a2,s0,-432
    80003bbe:	4581                	li	a1,0
    80003bc0:	8552                	mv	a0,s4
    80003bc2:	ed9fe0ef          	jal	80002a9a <readi>
    80003bc6:	04000793          	li	a5,64
    80003bca:	00f51a63          	bne	a0,a5,80003bde <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003bce:	e5042703          	lw	a4,-432(s0)
    80003bd2:	464c47b7          	lui	a5,0x464c4
    80003bd6:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003bda:	02f70863          	beq	a4,a5,80003c0a <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003bde:	8552                	mv	a0,s4
    80003be0:	d35fe0ef          	jal	80002914 <iunlockput>
    end_op();
    80003be4:	da0ff0ef          	jal	80003184 <end_op>
  }
  return -1;
    80003be8:	557d                	li	a0,-1
    80003bea:	7a5e                	ld	s4,496(sp)
}
    80003bec:	21813083          	ld	ra,536(sp)
    80003bf0:	21013403          	ld	s0,528(sp)
    80003bf4:	20813483          	ld	s1,520(sp)
    80003bf8:	20013903          	ld	s2,512(sp)
    80003bfc:	22010113          	addi	sp,sp,544
    80003c00:	8082                	ret
    end_op();
    80003c02:	d82ff0ef          	jal	80003184 <end_op>
    return -1;
    80003c06:	557d                	li	a0,-1
    80003c08:	b7d5                	j	80003bec <kexec+0x72>
    80003c0a:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003c0c:	8526                	mv	a0,s1
    80003c0e:	b04fd0ef          	jal	80000f12 <proc_pagetable>
    80003c12:	8b2a                	mv	s6,a0
    80003c14:	26050f63          	beqz	a0,80003e92 <kexec+0x318>
    80003c18:	ffce                	sd	s3,504(sp)
    80003c1a:	f7d6                	sd	s5,488(sp)
    80003c1c:	efde                	sd	s7,472(sp)
    80003c1e:	ebe2                	sd	s8,464(sp)
    80003c20:	e7e6                	sd	s9,456(sp)
    80003c22:	e3ea                	sd	s10,448(sp)
    80003c24:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c26:	e8845783          	lhu	a5,-376(s0)
    80003c2a:	0e078963          	beqz	a5,80003d1c <kexec+0x1a2>
    80003c2e:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c32:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c34:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c36:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003c3a:	6c85                	lui	s9,0x1
    80003c3c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003c40:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003c44:	6a85                	lui	s5,0x1
    80003c46:	a085                	j	80003ca6 <kexec+0x12c>
      panic("loadseg: address should exist");
    80003c48:	00005517          	auipc	a0,0x5
    80003c4c:	91050513          	addi	a0,a0,-1776 # 80008558 <etext+0x558>
    80003c50:	738020ef          	jal	80006388 <panic>
    if(sz - i < PGSIZE)
    80003c54:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003c56:	874a                	mv	a4,s2
    80003c58:	009b86bb          	addw	a3,s7,s1
    80003c5c:	4581                	li	a1,0
    80003c5e:	8552                	mv	a0,s4
    80003c60:	e3bfe0ef          	jal	80002a9a <readi>
    80003c64:	22a91b63          	bne	s2,a0,80003e9a <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80003c68:	009a84bb          	addw	s1,s5,s1
    80003c6c:	0334f263          	bgeu	s1,s3,80003c90 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003c70:	02049593          	slli	a1,s1,0x20
    80003c74:	9181                	srli	a1,a1,0x20
    80003c76:	95e2                	add	a1,a1,s8
    80003c78:	855a                	mv	a0,s6
    80003c7a:	81ffc0ef          	jal	80000498 <walkaddr>
    80003c7e:	862a                	mv	a2,a0
    if(pa == 0)
    80003c80:	d561                	beqz	a0,80003c48 <kexec+0xce>
    if(sz - i < PGSIZE)
    80003c82:	409987bb          	subw	a5,s3,s1
    80003c86:	893e                	mv	s2,a5
    80003c88:	fcfcf6e3          	bgeu	s9,a5,80003c54 <kexec+0xda>
    80003c8c:	8956                	mv	s2,s5
    80003c8e:	b7d9                	j	80003c54 <kexec+0xda>
    sz = sz1;
    80003c90:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c94:	2d05                	addiw	s10,s10,1
    80003c96:	e0843783          	ld	a5,-504(s0)
    80003c9a:	0387869b          	addiw	a3,a5,56
    80003c9e:	e8845783          	lhu	a5,-376(s0)
    80003ca2:	06fd5e63          	bge	s10,a5,80003d1e <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003ca6:	e0d43423          	sd	a3,-504(s0)
    80003caa:	876e                	mv	a4,s11
    80003cac:	e1840613          	addi	a2,s0,-488
    80003cb0:	4581                	li	a1,0
    80003cb2:	8552                	mv	a0,s4
    80003cb4:	de7fe0ef          	jal	80002a9a <readi>
    80003cb8:	1db51f63          	bne	a0,s11,80003e96 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80003cbc:	e1842783          	lw	a5,-488(s0)
    80003cc0:	4705                	li	a4,1
    80003cc2:	fce799e3          	bne	a5,a4,80003c94 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003cc6:	e4043483          	ld	s1,-448(s0)
    80003cca:	e3843783          	ld	a5,-456(s0)
    80003cce:	1ef4e463          	bltu	s1,a5,80003eb6 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003cd2:	e2843783          	ld	a5,-472(s0)
    80003cd6:	94be                	add	s1,s1,a5
    80003cd8:	1ef4e263          	bltu	s1,a5,80003ebc <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80003cdc:	de843703          	ld	a4,-536(s0)
    80003ce0:	8ff9                	and	a5,a5,a4
    80003ce2:	1e079063          	bnez	a5,80003ec2 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003ce6:	e1c42503          	lw	a0,-484(s0)
    80003cea:	e71ff0ef          	jal	80003b5a <flags2perm>
    80003cee:	86aa                	mv	a3,a0
    80003cf0:	8626                	mv	a2,s1
    80003cf2:	85ca                	mv	a1,s2
    80003cf4:	855a                	mv	a0,s6
    80003cf6:	ab9fc0ef          	jal	800007ae <uvmalloc>
    80003cfa:	dea43c23          	sd	a0,-520(s0)
    80003cfe:	1c050563          	beqz	a0,80003ec8 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d02:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d06:	00098863          	beqz	s3,80003d16 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d0a:	e2843c03          	ld	s8,-472(s0)
    80003d0e:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d12:	4481                	li	s1,0
    80003d14:	bfb1                	j	80003c70 <kexec+0xf6>
    sz = sz1;
    80003d16:	df843903          	ld	s2,-520(s0)
    80003d1a:	bfad                	j	80003c94 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d1c:	4901                	li	s2,0
  iunlockput(ip);
    80003d1e:	8552                	mv	a0,s4
    80003d20:	bf5fe0ef          	jal	80002914 <iunlockput>
  end_op();
    80003d24:	c60ff0ef          	jal	80003184 <end_op>
  p = myproc();
    80003d28:	8e0fd0ef          	jal	80000e08 <myproc>
    80003d2c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003d2e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003d32:	6985                	lui	s3,0x1
    80003d34:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003d36:	99ca                	add	s3,s3,s2
    80003d38:	77fd                	lui	a5,0xfffff
    80003d3a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003d3e:	4691                	li	a3,4
    80003d40:	6609                	lui	a2,0x2
    80003d42:	964e                	add	a2,a2,s3
    80003d44:	85ce                	mv	a1,s3
    80003d46:	855a                	mv	a0,s6
    80003d48:	a67fc0ef          	jal	800007ae <uvmalloc>
    80003d4c:	8a2a                	mv	s4,a0
    80003d4e:	e105                	bnez	a0,80003d6e <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003d50:	85ce                	mv	a1,s3
    80003d52:	855a                	mv	a0,s6
    80003d54:	a42fd0ef          	jal	80000f96 <proc_freepagetable>
  return -1;
    80003d58:	557d                	li	a0,-1
    80003d5a:	79fe                	ld	s3,504(sp)
    80003d5c:	7a5e                	ld	s4,496(sp)
    80003d5e:	7abe                	ld	s5,488(sp)
    80003d60:	7b1e                	ld	s6,480(sp)
    80003d62:	6bfe                	ld	s7,472(sp)
    80003d64:	6c5e                	ld	s8,464(sp)
    80003d66:	6cbe                	ld	s9,456(sp)
    80003d68:	6d1e                	ld	s10,448(sp)
    80003d6a:	7dfa                	ld	s11,440(sp)
    80003d6c:	b541                	j	80003bec <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003d6e:	75f9                	lui	a1,0xffffe
    80003d70:	95aa                	add	a1,a1,a0
    80003d72:	855a                	mv	a0,s6
    80003d74:	c0dfc0ef          	jal	80000980 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003d78:	800a0b93          	addi	s7,s4,-2048
    80003d7c:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80003d80:	e0043783          	ld	a5,-512(s0)
    80003d84:	6388                	ld	a0,0(a5)
  sp = sz;
    80003d86:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003d88:	4481                	li	s1,0
    ustack[argc] = sp;
    80003d8a:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003d8e:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003d92:	cd21                	beqz	a0,80003dea <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80003d94:	d54fc0ef          	jal	800002e8 <strlen>
    80003d98:	0015079b          	addiw	a5,a0,1
    80003d9c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003da0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003da4:	13796563          	bltu	s2,s7,80003ece <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003da8:	e0043d83          	ld	s11,-512(s0)
    80003dac:	000db983          	ld	s3,0(s11)
    80003db0:	854e                	mv	a0,s3
    80003db2:	d36fc0ef          	jal	800002e8 <strlen>
    80003db6:	0015069b          	addiw	a3,a0,1
    80003dba:	864e                	mv	a2,s3
    80003dbc:	85ca                	mv	a1,s2
    80003dbe:	855a                	mv	a0,s6
    80003dc0:	d47fc0ef          	jal	80000b06 <copyout>
    80003dc4:	10054763          	bltz	a0,80003ed2 <kexec+0x358>
    ustack[argc] = sp;
    80003dc8:	00349793          	slli	a5,s1,0x3
    80003dcc:	97e6                	add	a5,a5,s9
    80003dce:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7e62b818>
  for(argc = 0; argv[argc]; argc++) {
    80003dd2:	0485                	addi	s1,s1,1
    80003dd4:	008d8793          	addi	a5,s11,8
    80003dd8:	e0f43023          	sd	a5,-512(s0)
    80003ddc:	008db503          	ld	a0,8(s11)
    80003de0:	c509                	beqz	a0,80003dea <kexec+0x270>
    if(argc >= MAXARG)
    80003de2:	fb8499e3          	bne	s1,s8,80003d94 <kexec+0x21a>
  sz = sz1;
    80003de6:	89d2                	mv	s3,s4
    80003de8:	b7a5                	j	80003d50 <kexec+0x1d6>
  ustack[argc] = 0;
    80003dea:	00349793          	slli	a5,s1,0x3
    80003dee:	f9078793          	addi	a5,a5,-112
    80003df2:	97a2                	add	a5,a5,s0
    80003df4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003df8:	00349693          	slli	a3,s1,0x3
    80003dfc:	06a1                	addi	a3,a3,8
    80003dfe:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e02:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e06:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003e08:	f57964e3          	bltu	s2,s7,80003d50 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e0c:	e9040613          	addi	a2,s0,-368
    80003e10:	85ca                	mv	a1,s2
    80003e12:	855a                	mv	a0,s6
    80003e14:	cf3fc0ef          	jal	80000b06 <copyout>
    80003e18:	f2054ce3          	bltz	a0,80003d50 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80003e1c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003e20:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003e24:	df043783          	ld	a5,-528(s0)
    80003e28:	0007c703          	lbu	a4,0(a5)
    80003e2c:	cf11                	beqz	a4,80003e48 <kexec+0x2ce>
    80003e2e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003e30:	02f00693          	li	a3,47
    80003e34:	a029                	j	80003e3e <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80003e36:	0785                	addi	a5,a5,1
    80003e38:	fff7c703          	lbu	a4,-1(a5)
    80003e3c:	c711                	beqz	a4,80003e48 <kexec+0x2ce>
    if(*s == '/')
    80003e3e:	fed71ce3          	bne	a4,a3,80003e36 <kexec+0x2bc>
      last = s+1;
    80003e42:	def43823          	sd	a5,-528(s0)
    80003e46:	bfc5                	j	80003e36 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80003e48:	4641                	li	a2,16
    80003e4a:	df043583          	ld	a1,-528(s0)
    80003e4e:	158a8513          	addi	a0,s5,344
    80003e52:	c60fc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003e56:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003e5a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003e5e:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80003e62:	058ab783          	ld	a5,88(s5)
    80003e66:	e6843703          	ld	a4,-408(s0)
    80003e6a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003e6c:	058ab783          	ld	a5,88(s5)
    80003e70:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003e74:	85ea                	mv	a1,s10
    80003e76:	920fd0ef          	jal	80000f96 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003e7a:	0004851b          	sext.w	a0,s1
    80003e7e:	79fe                	ld	s3,504(sp)
    80003e80:	7a5e                	ld	s4,496(sp)
    80003e82:	7abe                	ld	s5,488(sp)
    80003e84:	7b1e                	ld	s6,480(sp)
    80003e86:	6bfe                	ld	s7,472(sp)
    80003e88:	6c5e                	ld	s8,464(sp)
    80003e8a:	6cbe                	ld	s9,456(sp)
    80003e8c:	6d1e                	ld	s10,448(sp)
    80003e8e:	7dfa                	ld	s11,440(sp)
    80003e90:	bbb1                	j	80003bec <kexec+0x72>
    80003e92:	7b1e                	ld	s6,480(sp)
    80003e94:	b3a9                	j	80003bde <kexec+0x64>
    80003e96:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003e9a:	df843583          	ld	a1,-520(s0)
    80003e9e:	855a                	mv	a0,s6
    80003ea0:	8f6fd0ef          	jal	80000f96 <proc_freepagetable>
  if(ip){
    80003ea4:	79fe                	ld	s3,504(sp)
    80003ea6:	7abe                	ld	s5,488(sp)
    80003ea8:	7b1e                	ld	s6,480(sp)
    80003eaa:	6bfe                	ld	s7,472(sp)
    80003eac:	6c5e                	ld	s8,464(sp)
    80003eae:	6cbe                	ld	s9,456(sp)
    80003eb0:	6d1e                	ld	s10,448(sp)
    80003eb2:	7dfa                	ld	s11,440(sp)
    80003eb4:	b32d                	j	80003bde <kexec+0x64>
    80003eb6:	df243c23          	sd	s2,-520(s0)
    80003eba:	b7c5                	j	80003e9a <kexec+0x320>
    80003ebc:	df243c23          	sd	s2,-520(s0)
    80003ec0:	bfe9                	j	80003e9a <kexec+0x320>
    80003ec2:	df243c23          	sd	s2,-520(s0)
    80003ec6:	bfd1                	j	80003e9a <kexec+0x320>
    80003ec8:	df243c23          	sd	s2,-520(s0)
    80003ecc:	b7f9                	j	80003e9a <kexec+0x320>
  sz = sz1;
    80003ece:	89d2                	mv	s3,s4
    80003ed0:	b541                	j	80003d50 <kexec+0x1d6>
    80003ed2:	89d2                	mv	s3,s4
    80003ed4:	bdb5                	j	80003d50 <kexec+0x1d6>

0000000080003ed6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003ed6:	7179                	addi	sp,sp,-48
    80003ed8:	f406                	sd	ra,40(sp)
    80003eda:	f022                	sd	s0,32(sp)
    80003edc:	ec26                	sd	s1,24(sp)
    80003ede:	e84a                	sd	s2,16(sp)
    80003ee0:	1800                	addi	s0,sp,48
    80003ee2:	892e                	mv	s2,a1
    80003ee4:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003ee6:	fdc40593          	addi	a1,s0,-36
    80003eea:	e61fd0ef          	jal	80001d4a <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003eee:	fdc42703          	lw	a4,-36(s0)
    80003ef2:	47bd                	li	a5,15
    80003ef4:	02e7ea63          	bltu	a5,a4,80003f28 <argfd+0x52>
    80003ef8:	f11fc0ef          	jal	80000e08 <myproc>
    80003efc:	fdc42703          	lw	a4,-36(s0)
    80003f00:	00371793          	slli	a5,a4,0x3
    80003f04:	0d078793          	addi	a5,a5,208
    80003f08:	953e                	add	a0,a0,a5
    80003f0a:	611c                	ld	a5,0(a0)
    80003f0c:	c385                	beqz	a5,80003f2c <argfd+0x56>
    return -1;
  if(pfd)
    80003f0e:	00090463          	beqz	s2,80003f16 <argfd+0x40>
    *pfd = fd;
    80003f12:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003f16:	4501                	li	a0,0
  if(pf)
    80003f18:	c091                	beqz	s1,80003f1c <argfd+0x46>
    *pf = f;
    80003f1a:	e09c                	sd	a5,0(s1)
}
    80003f1c:	70a2                	ld	ra,40(sp)
    80003f1e:	7402                	ld	s0,32(sp)
    80003f20:	64e2                	ld	s1,24(sp)
    80003f22:	6942                	ld	s2,16(sp)
    80003f24:	6145                	addi	sp,sp,48
    80003f26:	8082                	ret
    return -1;
    80003f28:	557d                	li	a0,-1
    80003f2a:	bfcd                	j	80003f1c <argfd+0x46>
    80003f2c:	557d                	li	a0,-1
    80003f2e:	b7fd                	j	80003f1c <argfd+0x46>

0000000080003f30 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003f30:	1101                	addi	sp,sp,-32
    80003f32:	ec06                	sd	ra,24(sp)
    80003f34:	e822                	sd	s0,16(sp)
    80003f36:	e426                	sd	s1,8(sp)
    80003f38:	1000                	addi	s0,sp,32
    80003f3a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003f3c:	ecdfc0ef          	jal	80000e08 <myproc>
    80003f40:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003f42:	0d050793          	addi	a5,a0,208
    80003f46:	4501                	li	a0,0
    80003f48:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003f4a:	6398                	ld	a4,0(a5)
    80003f4c:	cb19                	beqz	a4,80003f62 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003f4e:	2505                	addiw	a0,a0,1
    80003f50:	07a1                	addi	a5,a5,8
    80003f52:	fed51ce3          	bne	a0,a3,80003f4a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003f56:	557d                	li	a0,-1
}
    80003f58:	60e2                	ld	ra,24(sp)
    80003f5a:	6442                	ld	s0,16(sp)
    80003f5c:	64a2                	ld	s1,8(sp)
    80003f5e:	6105                	addi	sp,sp,32
    80003f60:	8082                	ret
      p->ofile[fd] = f;
    80003f62:	00351793          	slli	a5,a0,0x3
    80003f66:	0d078793          	addi	a5,a5,208
    80003f6a:	963e                	add	a2,a2,a5
    80003f6c:	e204                	sd	s1,0(a2)
      return fd;
    80003f6e:	b7ed                	j	80003f58 <fdalloc+0x28>

0000000080003f70 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003f70:	715d                	addi	sp,sp,-80
    80003f72:	e486                	sd	ra,72(sp)
    80003f74:	e0a2                	sd	s0,64(sp)
    80003f76:	fc26                	sd	s1,56(sp)
    80003f78:	f84a                	sd	s2,48(sp)
    80003f7a:	f44e                	sd	s3,40(sp)
    80003f7c:	f052                	sd	s4,32(sp)
    80003f7e:	ec56                	sd	s5,24(sp)
    80003f80:	e85a                	sd	s6,16(sp)
    80003f82:	0880                	addi	s0,sp,80
    80003f84:	892e                	mv	s2,a1
    80003f86:	8a2e                	mv	s4,a1
    80003f88:	8ab2                	mv	s5,a2
    80003f8a:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003f8c:	fb040593          	addi	a1,s0,-80
    80003f90:	fc1fe0ef          	jal	80002f50 <nameiparent>
    80003f94:	84aa                	mv	s1,a0
    80003f96:	10050763          	beqz	a0,800040a4 <create+0x134>
    return 0;

  ilock(dp);
    80003f9a:	f6efe0ef          	jal	80002708 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f9e:	4601                	li	a2,0
    80003fa0:	fb040593          	addi	a1,s0,-80
    80003fa4:	8526                	mv	a0,s1
    80003fa6:	cfdfe0ef          	jal	80002ca2 <dirlookup>
    80003faa:	89aa                	mv	s3,a0
    80003fac:	c131                	beqz	a0,80003ff0 <create+0x80>
    iunlockput(dp);
    80003fae:	8526                	mv	a0,s1
    80003fb0:	965fe0ef          	jal	80002914 <iunlockput>
    ilock(ip);
    80003fb4:	854e                	mv	a0,s3
    80003fb6:	f52fe0ef          	jal	80002708 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003fba:	4789                	li	a5,2
    80003fbc:	02f91563          	bne	s2,a5,80003fe6 <create+0x76>
    80003fc0:	0449d783          	lhu	a5,68(s3)
    80003fc4:	37f9                	addiw	a5,a5,-2
    80003fc6:	17c2                	slli	a5,a5,0x30
    80003fc8:	93c1                	srli	a5,a5,0x30
    80003fca:	4705                	li	a4,1
    80003fcc:	00f76d63          	bltu	a4,a5,80003fe6 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003fd0:	854e                	mv	a0,s3
    80003fd2:	60a6                	ld	ra,72(sp)
    80003fd4:	6406                	ld	s0,64(sp)
    80003fd6:	74e2                	ld	s1,56(sp)
    80003fd8:	7942                	ld	s2,48(sp)
    80003fda:	79a2                	ld	s3,40(sp)
    80003fdc:	7a02                	ld	s4,32(sp)
    80003fde:	6ae2                	ld	s5,24(sp)
    80003fe0:	6b42                	ld	s6,16(sp)
    80003fe2:	6161                	addi	sp,sp,80
    80003fe4:	8082                	ret
    iunlockput(ip);
    80003fe6:	854e                	mv	a0,s3
    80003fe8:	92dfe0ef          	jal	80002914 <iunlockput>
    return 0;
    80003fec:	4981                	li	s3,0
    80003fee:	b7cd                	j	80003fd0 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003ff0:	85ca                	mv	a1,s2
    80003ff2:	4088                	lw	a0,0(s1)
    80003ff4:	da4fe0ef          	jal	80002598 <ialloc>
    80003ff8:	892a                	mv	s2,a0
    80003ffa:	cd15                	beqz	a0,80004036 <create+0xc6>
  ilock(ip);
    80003ffc:	f0cfe0ef          	jal	80002708 <ilock>
  ip->major = major;
    80004000:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004004:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004008:	4785                	li	a5,1
    8000400a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000400e:	854a                	mv	a0,s2
    80004010:	e44fe0ef          	jal	80002654 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004014:	4705                	li	a4,1
    80004016:	02ea0463          	beq	s4,a4,8000403e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8000401a:	00492603          	lw	a2,4(s2)
    8000401e:	fb040593          	addi	a1,s0,-80
    80004022:	8526                	mv	a0,s1
    80004024:	e69fe0ef          	jal	80002e8c <dirlink>
    80004028:	06054263          	bltz	a0,8000408c <create+0x11c>
  iunlockput(dp);
    8000402c:	8526                	mv	a0,s1
    8000402e:	8e7fe0ef          	jal	80002914 <iunlockput>
  return ip;
    80004032:	89ca                	mv	s3,s2
    80004034:	bf71                	j	80003fd0 <create+0x60>
    iunlockput(dp);
    80004036:	8526                	mv	a0,s1
    80004038:	8ddfe0ef          	jal	80002914 <iunlockput>
    return 0;
    8000403c:	bf51                	j	80003fd0 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000403e:	00492603          	lw	a2,4(s2)
    80004042:	00004597          	auipc	a1,0x4
    80004046:	53658593          	addi	a1,a1,1334 # 80008578 <etext+0x578>
    8000404a:	854a                	mv	a0,s2
    8000404c:	e41fe0ef          	jal	80002e8c <dirlink>
    80004050:	02054e63          	bltz	a0,8000408c <create+0x11c>
    80004054:	40d0                	lw	a2,4(s1)
    80004056:	00004597          	auipc	a1,0x4
    8000405a:	52a58593          	addi	a1,a1,1322 # 80008580 <etext+0x580>
    8000405e:	854a                	mv	a0,s2
    80004060:	e2dfe0ef          	jal	80002e8c <dirlink>
    80004064:	02054463          	bltz	a0,8000408c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004068:	00492603          	lw	a2,4(s2)
    8000406c:	fb040593          	addi	a1,s0,-80
    80004070:	8526                	mv	a0,s1
    80004072:	e1bfe0ef          	jal	80002e8c <dirlink>
    80004076:	00054b63          	bltz	a0,8000408c <create+0x11c>
    dp->nlink++;  // for ".."
    8000407a:	04a4d783          	lhu	a5,74(s1)
    8000407e:	2785                	addiw	a5,a5,1
    80004080:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004084:	8526                	mv	a0,s1
    80004086:	dcefe0ef          	jal	80002654 <iupdate>
    8000408a:	b74d                	j	8000402c <create+0xbc>
  ip->nlink = 0;
    8000408c:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004090:	854a                	mv	a0,s2
    80004092:	dc2fe0ef          	jal	80002654 <iupdate>
  iunlockput(ip);
    80004096:	854a                	mv	a0,s2
    80004098:	87dfe0ef          	jal	80002914 <iunlockput>
  iunlockput(dp);
    8000409c:	8526                	mv	a0,s1
    8000409e:	877fe0ef          	jal	80002914 <iunlockput>
  return 0;
    800040a2:	b73d                	j	80003fd0 <create+0x60>
    return 0;
    800040a4:	89aa                	mv	s3,a0
    800040a6:	b72d                	j	80003fd0 <create+0x60>

00000000800040a8 <sys_dup>:
{
    800040a8:	7179                	addi	sp,sp,-48
    800040aa:	f406                	sd	ra,40(sp)
    800040ac:	f022                	sd	s0,32(sp)
    800040ae:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800040b0:	fd840613          	addi	a2,s0,-40
    800040b4:	4581                	li	a1,0
    800040b6:	4501                	li	a0,0
    800040b8:	e1fff0ef          	jal	80003ed6 <argfd>
    return -1;
    800040bc:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800040be:	02054363          	bltz	a0,800040e4 <sys_dup+0x3c>
    800040c2:	ec26                	sd	s1,24(sp)
    800040c4:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800040c6:	fd843483          	ld	s1,-40(s0)
    800040ca:	8526                	mv	a0,s1
    800040cc:	e65ff0ef          	jal	80003f30 <fdalloc>
    800040d0:	892a                	mv	s2,a0
    return -1;
    800040d2:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800040d4:	00054d63          	bltz	a0,800040ee <sys_dup+0x46>
  filedup(f);
    800040d8:	8526                	mv	a0,s1
    800040da:	c18ff0ef          	jal	800034f2 <filedup>
  return fd;
    800040de:	87ca                	mv	a5,s2
    800040e0:	64e2                	ld	s1,24(sp)
    800040e2:	6942                	ld	s2,16(sp)
}
    800040e4:	853e                	mv	a0,a5
    800040e6:	70a2                	ld	ra,40(sp)
    800040e8:	7402                	ld	s0,32(sp)
    800040ea:	6145                	addi	sp,sp,48
    800040ec:	8082                	ret
    800040ee:	64e2                	ld	s1,24(sp)
    800040f0:	6942                	ld	s2,16(sp)
    800040f2:	bfcd                	j	800040e4 <sys_dup+0x3c>

00000000800040f4 <sys_read>:
{
    800040f4:	7179                	addi	sp,sp,-48
    800040f6:	f406                	sd	ra,40(sp)
    800040f8:	f022                	sd	s0,32(sp)
    800040fa:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040fc:	fd840593          	addi	a1,s0,-40
    80004100:	4505                	li	a0,1
    80004102:	c65fd0ef          	jal	80001d66 <argaddr>
  argint(2, &n);
    80004106:	fe440593          	addi	a1,s0,-28
    8000410a:	4509                	li	a0,2
    8000410c:	c3ffd0ef          	jal	80001d4a <argint>
  if(argfd(0, 0, &f) < 0)
    80004110:	fe840613          	addi	a2,s0,-24
    80004114:	4581                	li	a1,0
    80004116:	4501                	li	a0,0
    80004118:	dbfff0ef          	jal	80003ed6 <argfd>
    8000411c:	87aa                	mv	a5,a0
    return -1;
    8000411e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004120:	0007ca63          	bltz	a5,80004134 <sys_read+0x40>
  return fileread(f, p, n);
    80004124:	fe442603          	lw	a2,-28(s0)
    80004128:	fd843583          	ld	a1,-40(s0)
    8000412c:	fe843503          	ld	a0,-24(s0)
    80004130:	d2cff0ef          	jal	8000365c <fileread>
}
    80004134:	70a2                	ld	ra,40(sp)
    80004136:	7402                	ld	s0,32(sp)
    80004138:	6145                	addi	sp,sp,48
    8000413a:	8082                	ret

000000008000413c <sys_write>:
{
    8000413c:	7179                	addi	sp,sp,-48
    8000413e:	f406                	sd	ra,40(sp)
    80004140:	f022                	sd	s0,32(sp)
    80004142:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004144:	fd840593          	addi	a1,s0,-40
    80004148:	4505                	li	a0,1
    8000414a:	c1dfd0ef          	jal	80001d66 <argaddr>
  argint(2, &n);
    8000414e:	fe440593          	addi	a1,s0,-28
    80004152:	4509                	li	a0,2
    80004154:	bf7fd0ef          	jal	80001d4a <argint>
  if(argfd(0, 0, &f) < 0)
    80004158:	fe840613          	addi	a2,s0,-24
    8000415c:	4581                	li	a1,0
    8000415e:	4501                	li	a0,0
    80004160:	d77ff0ef          	jal	80003ed6 <argfd>
    80004164:	87aa                	mv	a5,a0
    return -1;
    80004166:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004168:	0007ca63          	bltz	a5,8000417c <sys_write+0x40>
  return filewrite(f, p, n);
    8000416c:	fe442603          	lw	a2,-28(s0)
    80004170:	fd843583          	ld	a1,-40(s0)
    80004174:	fe843503          	ld	a0,-24(s0)
    80004178:	da8ff0ef          	jal	80003720 <filewrite>
}
    8000417c:	70a2                	ld	ra,40(sp)
    8000417e:	7402                	ld	s0,32(sp)
    80004180:	6145                	addi	sp,sp,48
    80004182:	8082                	ret

0000000080004184 <sys_close>:
{
    80004184:	1101                	addi	sp,sp,-32
    80004186:	ec06                	sd	ra,24(sp)
    80004188:	e822                	sd	s0,16(sp)
    8000418a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000418c:	fe040613          	addi	a2,s0,-32
    80004190:	fec40593          	addi	a1,s0,-20
    80004194:	4501                	li	a0,0
    80004196:	d41ff0ef          	jal	80003ed6 <argfd>
    return -1;
    8000419a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000419c:	02054163          	bltz	a0,800041be <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    800041a0:	c69fc0ef          	jal	80000e08 <myproc>
    800041a4:	fec42783          	lw	a5,-20(s0)
    800041a8:	078e                	slli	a5,a5,0x3
    800041aa:	0d078793          	addi	a5,a5,208
    800041ae:	953e                	add	a0,a0,a5
    800041b0:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800041b4:	fe043503          	ld	a0,-32(s0)
    800041b8:	b80ff0ef          	jal	80003538 <fileclose>
  return 0;
    800041bc:	4781                	li	a5,0
}
    800041be:	853e                	mv	a0,a5
    800041c0:	60e2                	ld	ra,24(sp)
    800041c2:	6442                	ld	s0,16(sp)
    800041c4:	6105                	addi	sp,sp,32
    800041c6:	8082                	ret

00000000800041c8 <sys_fstat>:
{
    800041c8:	1101                	addi	sp,sp,-32
    800041ca:	ec06                	sd	ra,24(sp)
    800041cc:	e822                	sd	s0,16(sp)
    800041ce:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800041d0:	fe040593          	addi	a1,s0,-32
    800041d4:	4505                	li	a0,1
    800041d6:	b91fd0ef          	jal	80001d66 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800041da:	fe840613          	addi	a2,s0,-24
    800041de:	4581                	li	a1,0
    800041e0:	4501                	li	a0,0
    800041e2:	cf5ff0ef          	jal	80003ed6 <argfd>
    800041e6:	87aa                	mv	a5,a0
    return -1;
    800041e8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041ea:	0007c863          	bltz	a5,800041fa <sys_fstat+0x32>
  return filestat(f, st);
    800041ee:	fe043583          	ld	a1,-32(s0)
    800041f2:	fe843503          	ld	a0,-24(s0)
    800041f6:	c04ff0ef          	jal	800035fa <filestat>
}
    800041fa:	60e2                	ld	ra,24(sp)
    800041fc:	6442                	ld	s0,16(sp)
    800041fe:	6105                	addi	sp,sp,32
    80004200:	8082                	ret

0000000080004202 <sys_link>:
{
    80004202:	7169                	addi	sp,sp,-304
    80004204:	f606                	sd	ra,296(sp)
    80004206:	f222                	sd	s0,288(sp)
    80004208:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000420a:	08000613          	li	a2,128
    8000420e:	ed040593          	addi	a1,s0,-304
    80004212:	4501                	li	a0,0
    80004214:	b6ffd0ef          	jal	80001d82 <argstr>
    return -1;
    80004218:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000421a:	0c054e63          	bltz	a0,800042f6 <sys_link+0xf4>
    8000421e:	08000613          	li	a2,128
    80004222:	f5040593          	addi	a1,s0,-176
    80004226:	4505                	li	a0,1
    80004228:	b5bfd0ef          	jal	80001d82 <argstr>
    return -1;
    8000422c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000422e:	0c054463          	bltz	a0,800042f6 <sys_link+0xf4>
    80004232:	ee26                	sd	s1,280(sp)
  begin_op();
    80004234:	ee1fe0ef          	jal	80003114 <begin_op>
  if((ip = namei(old)) == 0){
    80004238:	ed040513          	addi	a0,s0,-304
    8000423c:	cfbfe0ef          	jal	80002f36 <namei>
    80004240:	84aa                	mv	s1,a0
    80004242:	c53d                	beqz	a0,800042b0 <sys_link+0xae>
  ilock(ip);
    80004244:	cc4fe0ef          	jal	80002708 <ilock>
  if(ip->type == T_DIR){
    80004248:	04449703          	lh	a4,68(s1)
    8000424c:	4785                	li	a5,1
    8000424e:	06f70663          	beq	a4,a5,800042ba <sys_link+0xb8>
    80004252:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004254:	04a4d783          	lhu	a5,74(s1)
    80004258:	2785                	addiw	a5,a5,1
    8000425a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000425e:	8526                	mv	a0,s1
    80004260:	bf4fe0ef          	jal	80002654 <iupdate>
  iunlock(ip);
    80004264:	8526                	mv	a0,s1
    80004266:	d50fe0ef          	jal	800027b6 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000426a:	fd040593          	addi	a1,s0,-48
    8000426e:	f5040513          	addi	a0,s0,-176
    80004272:	cdffe0ef          	jal	80002f50 <nameiparent>
    80004276:	892a                	mv	s2,a0
    80004278:	cd21                	beqz	a0,800042d0 <sys_link+0xce>
  ilock(dp);
    8000427a:	c8efe0ef          	jal	80002708 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000427e:	854a                	mv	a0,s2
    80004280:	00092703          	lw	a4,0(s2)
    80004284:	409c                	lw	a5,0(s1)
    80004286:	04f71263          	bne	a4,a5,800042ca <sys_link+0xc8>
    8000428a:	40d0                	lw	a2,4(s1)
    8000428c:	fd040593          	addi	a1,s0,-48
    80004290:	bfdfe0ef          	jal	80002e8c <dirlink>
    80004294:	02054b63          	bltz	a0,800042ca <sys_link+0xc8>
  iunlockput(dp);
    80004298:	854a                	mv	a0,s2
    8000429a:	e7afe0ef          	jal	80002914 <iunlockput>
  iput(ip);
    8000429e:	8526                	mv	a0,s1
    800042a0:	deafe0ef          	jal	8000288a <iput>
  end_op();
    800042a4:	ee1fe0ef          	jal	80003184 <end_op>
  return 0;
    800042a8:	4781                	li	a5,0
    800042aa:	64f2                	ld	s1,280(sp)
    800042ac:	6952                	ld	s2,272(sp)
    800042ae:	a0a1                	j	800042f6 <sys_link+0xf4>
    end_op();
    800042b0:	ed5fe0ef          	jal	80003184 <end_op>
    return -1;
    800042b4:	57fd                	li	a5,-1
    800042b6:	64f2                	ld	s1,280(sp)
    800042b8:	a83d                	j	800042f6 <sys_link+0xf4>
    iunlockput(ip);
    800042ba:	8526                	mv	a0,s1
    800042bc:	e58fe0ef          	jal	80002914 <iunlockput>
    end_op();
    800042c0:	ec5fe0ef          	jal	80003184 <end_op>
    return -1;
    800042c4:	57fd                	li	a5,-1
    800042c6:	64f2                	ld	s1,280(sp)
    800042c8:	a03d                	j	800042f6 <sys_link+0xf4>
    iunlockput(dp);
    800042ca:	854a                	mv	a0,s2
    800042cc:	e48fe0ef          	jal	80002914 <iunlockput>
  ilock(ip);
    800042d0:	8526                	mv	a0,s1
    800042d2:	c36fe0ef          	jal	80002708 <ilock>
  ip->nlink--;
    800042d6:	04a4d783          	lhu	a5,74(s1)
    800042da:	37fd                	addiw	a5,a5,-1
    800042dc:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800042e0:	8526                	mv	a0,s1
    800042e2:	b72fe0ef          	jal	80002654 <iupdate>
  iunlockput(ip);
    800042e6:	8526                	mv	a0,s1
    800042e8:	e2cfe0ef          	jal	80002914 <iunlockput>
  end_op();
    800042ec:	e99fe0ef          	jal	80003184 <end_op>
  return -1;
    800042f0:	57fd                	li	a5,-1
    800042f2:	64f2                	ld	s1,280(sp)
    800042f4:	6952                	ld	s2,272(sp)
}
    800042f6:	853e                	mv	a0,a5
    800042f8:	70b2                	ld	ra,296(sp)
    800042fa:	7412                	ld	s0,288(sp)
    800042fc:	6155                	addi	sp,sp,304
    800042fe:	8082                	ret

0000000080004300 <sys_unlink>:
{
    80004300:	7151                	addi	sp,sp,-240
    80004302:	f586                	sd	ra,232(sp)
    80004304:	f1a2                	sd	s0,224(sp)
    80004306:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004308:	08000613          	li	a2,128
    8000430c:	f3040593          	addi	a1,s0,-208
    80004310:	4501                	li	a0,0
    80004312:	a71fd0ef          	jal	80001d82 <argstr>
    80004316:	14054d63          	bltz	a0,80004470 <sys_unlink+0x170>
    8000431a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000431c:	df9fe0ef          	jal	80003114 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004320:	fb040593          	addi	a1,s0,-80
    80004324:	f3040513          	addi	a0,s0,-208
    80004328:	c29fe0ef          	jal	80002f50 <nameiparent>
    8000432c:	84aa                	mv	s1,a0
    8000432e:	c955                	beqz	a0,800043e2 <sys_unlink+0xe2>
  ilock(dp);
    80004330:	bd8fe0ef          	jal	80002708 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004334:	00004597          	auipc	a1,0x4
    80004338:	24458593          	addi	a1,a1,580 # 80008578 <etext+0x578>
    8000433c:	fb040513          	addi	a0,s0,-80
    80004340:	94dfe0ef          	jal	80002c8c <namecmp>
    80004344:	10050b63          	beqz	a0,8000445a <sys_unlink+0x15a>
    80004348:	00004597          	auipc	a1,0x4
    8000434c:	23858593          	addi	a1,a1,568 # 80008580 <etext+0x580>
    80004350:	fb040513          	addi	a0,s0,-80
    80004354:	939fe0ef          	jal	80002c8c <namecmp>
    80004358:	10050163          	beqz	a0,8000445a <sys_unlink+0x15a>
    8000435c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000435e:	f2c40613          	addi	a2,s0,-212
    80004362:	fb040593          	addi	a1,s0,-80
    80004366:	8526                	mv	a0,s1
    80004368:	93bfe0ef          	jal	80002ca2 <dirlookup>
    8000436c:	892a                	mv	s2,a0
    8000436e:	0e050563          	beqz	a0,80004458 <sys_unlink+0x158>
    80004372:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004374:	b94fe0ef          	jal	80002708 <ilock>
  if(ip->nlink < 1)
    80004378:	04a91783          	lh	a5,74(s2)
    8000437c:	06f05863          	blez	a5,800043ec <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004380:	04491703          	lh	a4,68(s2)
    80004384:	4785                	li	a5,1
    80004386:	06f70963          	beq	a4,a5,800043f8 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    8000438a:	fc040993          	addi	s3,s0,-64
    8000438e:	4641                	li	a2,16
    80004390:	4581                	li	a1,0
    80004392:	854e                	mv	a0,s3
    80004394:	dcbfb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004398:	4741                	li	a4,16
    8000439a:	f2c42683          	lw	a3,-212(s0)
    8000439e:	864e                	mv	a2,s3
    800043a0:	4581                	li	a1,0
    800043a2:	8526                	mv	a0,s1
    800043a4:	fe8fe0ef          	jal	80002b8c <writei>
    800043a8:	47c1                	li	a5,16
    800043aa:	08f51863          	bne	a0,a5,8000443a <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    800043ae:	04491703          	lh	a4,68(s2)
    800043b2:	4785                	li	a5,1
    800043b4:	08f70963          	beq	a4,a5,80004446 <sys_unlink+0x146>
  iunlockput(dp);
    800043b8:	8526                	mv	a0,s1
    800043ba:	d5afe0ef          	jal	80002914 <iunlockput>
  ip->nlink--;
    800043be:	04a95783          	lhu	a5,74(s2)
    800043c2:	37fd                	addiw	a5,a5,-1
    800043c4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800043c8:	854a                	mv	a0,s2
    800043ca:	a8afe0ef          	jal	80002654 <iupdate>
  iunlockput(ip);
    800043ce:	854a                	mv	a0,s2
    800043d0:	d44fe0ef          	jal	80002914 <iunlockput>
  end_op();
    800043d4:	db1fe0ef          	jal	80003184 <end_op>
  return 0;
    800043d8:	4501                	li	a0,0
    800043da:	64ee                	ld	s1,216(sp)
    800043dc:	694e                	ld	s2,208(sp)
    800043de:	69ae                	ld	s3,200(sp)
    800043e0:	a061                	j	80004468 <sys_unlink+0x168>
    end_op();
    800043e2:	da3fe0ef          	jal	80003184 <end_op>
    return -1;
    800043e6:	557d                	li	a0,-1
    800043e8:	64ee                	ld	s1,216(sp)
    800043ea:	a8bd                	j	80004468 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800043ec:	00004517          	auipc	a0,0x4
    800043f0:	19c50513          	addi	a0,a0,412 # 80008588 <etext+0x588>
    800043f4:	795010ef          	jal	80006388 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043f8:	04c92703          	lw	a4,76(s2)
    800043fc:	02000793          	li	a5,32
    80004400:	f8e7f5e3          	bgeu	a5,a4,8000438a <sys_unlink+0x8a>
    80004404:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004406:	4741                	li	a4,16
    80004408:	86ce                	mv	a3,s3
    8000440a:	f1840613          	addi	a2,s0,-232
    8000440e:	4581                	li	a1,0
    80004410:	854a                	mv	a0,s2
    80004412:	e88fe0ef          	jal	80002a9a <readi>
    80004416:	47c1                	li	a5,16
    80004418:	00f51b63          	bne	a0,a5,8000442e <sys_unlink+0x12e>
    if(de.inum != 0)
    8000441c:	f1845783          	lhu	a5,-232(s0)
    80004420:	ebb1                	bnez	a5,80004474 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004422:	29c1                	addiw	s3,s3,16
    80004424:	04c92783          	lw	a5,76(s2)
    80004428:	fcf9efe3          	bltu	s3,a5,80004406 <sys_unlink+0x106>
    8000442c:	bfb9                	j	8000438a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000442e:	00004517          	auipc	a0,0x4
    80004432:	17250513          	addi	a0,a0,370 # 800085a0 <etext+0x5a0>
    80004436:	753010ef          	jal	80006388 <panic>
    panic("unlink: writei");
    8000443a:	00004517          	auipc	a0,0x4
    8000443e:	17e50513          	addi	a0,a0,382 # 800085b8 <etext+0x5b8>
    80004442:	747010ef          	jal	80006388 <panic>
    dp->nlink--;
    80004446:	04a4d783          	lhu	a5,74(s1)
    8000444a:	37fd                	addiw	a5,a5,-1
    8000444c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004450:	8526                	mv	a0,s1
    80004452:	a02fe0ef          	jal	80002654 <iupdate>
    80004456:	b78d                	j	800043b8 <sys_unlink+0xb8>
    80004458:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000445a:	8526                	mv	a0,s1
    8000445c:	cb8fe0ef          	jal	80002914 <iunlockput>
  end_op();
    80004460:	d25fe0ef          	jal	80003184 <end_op>
  return -1;
    80004464:	557d                	li	a0,-1
    80004466:	64ee                	ld	s1,216(sp)
}
    80004468:	70ae                	ld	ra,232(sp)
    8000446a:	740e                	ld	s0,224(sp)
    8000446c:	616d                	addi	sp,sp,240
    8000446e:	8082                	ret
    return -1;
    80004470:	557d                	li	a0,-1
    80004472:	bfdd                	j	80004468 <sys_unlink+0x168>
    iunlockput(ip);
    80004474:	854a                	mv	a0,s2
    80004476:	c9efe0ef          	jal	80002914 <iunlockput>
    goto bad;
    8000447a:	694e                	ld	s2,208(sp)
    8000447c:	69ae                	ld	s3,200(sp)
    8000447e:	bff1                	j	8000445a <sys_unlink+0x15a>

0000000080004480 <sys_open>:

uint64
sys_open(void)
{
    80004480:	7131                	addi	sp,sp,-192
    80004482:	fd06                	sd	ra,184(sp)
    80004484:	f922                	sd	s0,176(sp)
    80004486:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004488:	f4c40593          	addi	a1,s0,-180
    8000448c:	4505                	li	a0,1
    8000448e:	8bdfd0ef          	jal	80001d4a <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004492:	08000613          	li	a2,128
    80004496:	f5040593          	addi	a1,s0,-176
    8000449a:	4501                	li	a0,0
    8000449c:	8e7fd0ef          	jal	80001d82 <argstr>
    800044a0:	87aa                	mv	a5,a0
    return -1;
    800044a2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800044a4:	0a07c363          	bltz	a5,8000454a <sys_open+0xca>
    800044a8:	f526                	sd	s1,168(sp)

  begin_op();
    800044aa:	c6bfe0ef          	jal	80003114 <begin_op>

  if(omode & O_CREATE){
    800044ae:	f4c42783          	lw	a5,-180(s0)
    800044b2:	2007f793          	andi	a5,a5,512
    800044b6:	c3dd                	beqz	a5,8000455c <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800044b8:	4681                	li	a3,0
    800044ba:	4601                	li	a2,0
    800044bc:	4589                	li	a1,2
    800044be:	f5040513          	addi	a0,s0,-176
    800044c2:	aafff0ef          	jal	80003f70 <create>
    800044c6:	84aa                	mv	s1,a0
    if(ip == 0){
    800044c8:	c549                	beqz	a0,80004552 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800044ca:	04449703          	lh	a4,68(s1)
    800044ce:	478d                	li	a5,3
    800044d0:	00f71763          	bne	a4,a5,800044de <sys_open+0x5e>
    800044d4:	0464d703          	lhu	a4,70(s1)
    800044d8:	47a5                	li	a5,9
    800044da:	0ae7ee63          	bltu	a5,a4,80004596 <sys_open+0x116>
    800044de:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800044e0:	fb5fe0ef          	jal	80003494 <filealloc>
    800044e4:	892a                	mv	s2,a0
    800044e6:	c561                	beqz	a0,800045ae <sys_open+0x12e>
    800044e8:	ed4e                	sd	s3,152(sp)
    800044ea:	a47ff0ef          	jal	80003f30 <fdalloc>
    800044ee:	89aa                	mv	s3,a0
    800044f0:	0a054b63          	bltz	a0,800045a6 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800044f4:	04449703          	lh	a4,68(s1)
    800044f8:	478d                	li	a5,3
    800044fa:	0cf70363          	beq	a4,a5,800045c0 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800044fe:	4789                	li	a5,2
    80004500:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004504:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004508:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000450c:	f4c42783          	lw	a5,-180(s0)
    80004510:	0017f713          	andi	a4,a5,1
    80004514:	00174713          	xori	a4,a4,1
    80004518:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000451c:	0037f713          	andi	a4,a5,3
    80004520:	00e03733          	snez	a4,a4
    80004524:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004528:	4007f793          	andi	a5,a5,1024
    8000452c:	c791                	beqz	a5,80004538 <sys_open+0xb8>
    8000452e:	04449703          	lh	a4,68(s1)
    80004532:	4789                	li	a5,2
    80004534:	08f70d63          	beq	a4,a5,800045ce <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004538:	8526                	mv	a0,s1
    8000453a:	a7cfe0ef          	jal	800027b6 <iunlock>
  end_op();
    8000453e:	c47fe0ef          	jal	80003184 <end_op>

  return fd;
    80004542:	854e                	mv	a0,s3
    80004544:	74aa                	ld	s1,168(sp)
    80004546:	790a                	ld	s2,160(sp)
    80004548:	69ea                	ld	s3,152(sp)
}
    8000454a:	70ea                	ld	ra,184(sp)
    8000454c:	744a                	ld	s0,176(sp)
    8000454e:	6129                	addi	sp,sp,192
    80004550:	8082                	ret
      end_op();
    80004552:	c33fe0ef          	jal	80003184 <end_op>
      return -1;
    80004556:	557d                	li	a0,-1
    80004558:	74aa                	ld	s1,168(sp)
    8000455a:	bfc5                	j	8000454a <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000455c:	f5040513          	addi	a0,s0,-176
    80004560:	9d7fe0ef          	jal	80002f36 <namei>
    80004564:	84aa                	mv	s1,a0
    80004566:	c11d                	beqz	a0,8000458c <sys_open+0x10c>
    ilock(ip);
    80004568:	9a0fe0ef          	jal	80002708 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000456c:	04449703          	lh	a4,68(s1)
    80004570:	4785                	li	a5,1
    80004572:	f4f71ce3          	bne	a4,a5,800044ca <sys_open+0x4a>
    80004576:	f4c42783          	lw	a5,-180(s0)
    8000457a:	d3b5                	beqz	a5,800044de <sys_open+0x5e>
      iunlockput(ip);
    8000457c:	8526                	mv	a0,s1
    8000457e:	b96fe0ef          	jal	80002914 <iunlockput>
      end_op();
    80004582:	c03fe0ef          	jal	80003184 <end_op>
      return -1;
    80004586:	557d                	li	a0,-1
    80004588:	74aa                	ld	s1,168(sp)
    8000458a:	b7c1                	j	8000454a <sys_open+0xca>
      end_op();
    8000458c:	bf9fe0ef          	jal	80003184 <end_op>
      return -1;
    80004590:	557d                	li	a0,-1
    80004592:	74aa                	ld	s1,168(sp)
    80004594:	bf5d                	j	8000454a <sys_open+0xca>
    iunlockput(ip);
    80004596:	8526                	mv	a0,s1
    80004598:	b7cfe0ef          	jal	80002914 <iunlockput>
    end_op();
    8000459c:	be9fe0ef          	jal	80003184 <end_op>
    return -1;
    800045a0:	557d                	li	a0,-1
    800045a2:	74aa                	ld	s1,168(sp)
    800045a4:	b75d                	j	8000454a <sys_open+0xca>
      fileclose(f);
    800045a6:	854a                	mv	a0,s2
    800045a8:	f91fe0ef          	jal	80003538 <fileclose>
    800045ac:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800045ae:	8526                	mv	a0,s1
    800045b0:	b64fe0ef          	jal	80002914 <iunlockput>
    end_op();
    800045b4:	bd1fe0ef          	jal	80003184 <end_op>
    return -1;
    800045b8:	557d                	li	a0,-1
    800045ba:	74aa                	ld	s1,168(sp)
    800045bc:	790a                	ld	s2,160(sp)
    800045be:	b771                	j	8000454a <sys_open+0xca>
    f->type = FD_DEVICE;
    800045c0:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800045c4:	04649783          	lh	a5,70(s1)
    800045c8:	02f91223          	sh	a5,36(s2)
    800045cc:	bf35                	j	80004508 <sys_open+0x88>
    itrunc(ip);
    800045ce:	8526                	mv	a0,s1
    800045d0:	a26fe0ef          	jal	800027f6 <itrunc>
    800045d4:	b795                	j	80004538 <sys_open+0xb8>

00000000800045d6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800045d6:	7175                	addi	sp,sp,-144
    800045d8:	e506                	sd	ra,136(sp)
    800045da:	e122                	sd	s0,128(sp)
    800045dc:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800045de:	b37fe0ef          	jal	80003114 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800045e2:	08000613          	li	a2,128
    800045e6:	f7040593          	addi	a1,s0,-144
    800045ea:	4501                	li	a0,0
    800045ec:	f96fd0ef          	jal	80001d82 <argstr>
    800045f0:	02054363          	bltz	a0,80004616 <sys_mkdir+0x40>
    800045f4:	4681                	li	a3,0
    800045f6:	4601                	li	a2,0
    800045f8:	4585                	li	a1,1
    800045fa:	f7040513          	addi	a0,s0,-144
    800045fe:	973ff0ef          	jal	80003f70 <create>
    80004602:	c911                	beqz	a0,80004616 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004604:	b10fe0ef          	jal	80002914 <iunlockput>
  end_op();
    80004608:	b7dfe0ef          	jal	80003184 <end_op>
  return 0;
    8000460c:	4501                	li	a0,0
}
    8000460e:	60aa                	ld	ra,136(sp)
    80004610:	640a                	ld	s0,128(sp)
    80004612:	6149                	addi	sp,sp,144
    80004614:	8082                	ret
    end_op();
    80004616:	b6ffe0ef          	jal	80003184 <end_op>
    return -1;
    8000461a:	557d                	li	a0,-1
    8000461c:	bfcd                	j	8000460e <sys_mkdir+0x38>

000000008000461e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000461e:	7135                	addi	sp,sp,-160
    80004620:	ed06                	sd	ra,152(sp)
    80004622:	e922                	sd	s0,144(sp)
    80004624:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004626:	aeffe0ef          	jal	80003114 <begin_op>
  argint(1, &major);
    8000462a:	f6c40593          	addi	a1,s0,-148
    8000462e:	4505                	li	a0,1
    80004630:	f1afd0ef          	jal	80001d4a <argint>
  argint(2, &minor);
    80004634:	f6840593          	addi	a1,s0,-152
    80004638:	4509                	li	a0,2
    8000463a:	f10fd0ef          	jal	80001d4a <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000463e:	08000613          	li	a2,128
    80004642:	f7040593          	addi	a1,s0,-144
    80004646:	4501                	li	a0,0
    80004648:	f3afd0ef          	jal	80001d82 <argstr>
    8000464c:	02054563          	bltz	a0,80004676 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004650:	f6841683          	lh	a3,-152(s0)
    80004654:	f6c41603          	lh	a2,-148(s0)
    80004658:	458d                	li	a1,3
    8000465a:	f7040513          	addi	a0,s0,-144
    8000465e:	913ff0ef          	jal	80003f70 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004662:	c911                	beqz	a0,80004676 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004664:	ab0fe0ef          	jal	80002914 <iunlockput>
  end_op();
    80004668:	b1dfe0ef          	jal	80003184 <end_op>
  return 0;
    8000466c:	4501                	li	a0,0
}
    8000466e:	60ea                	ld	ra,152(sp)
    80004670:	644a                	ld	s0,144(sp)
    80004672:	610d                	addi	sp,sp,160
    80004674:	8082                	ret
    end_op();
    80004676:	b0ffe0ef          	jal	80003184 <end_op>
    return -1;
    8000467a:	557d                	li	a0,-1
    8000467c:	bfcd                	j	8000466e <sys_mknod+0x50>

000000008000467e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000467e:	7135                	addi	sp,sp,-160
    80004680:	ed06                	sd	ra,152(sp)
    80004682:	e922                	sd	s0,144(sp)
    80004684:	e14a                	sd	s2,128(sp)
    80004686:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004688:	f80fc0ef          	jal	80000e08 <myproc>
    8000468c:	892a                	mv	s2,a0
  
  begin_op();
    8000468e:	a87fe0ef          	jal	80003114 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004692:	08000613          	li	a2,128
    80004696:	f6040593          	addi	a1,s0,-160
    8000469a:	4501                	li	a0,0
    8000469c:	ee6fd0ef          	jal	80001d82 <argstr>
    800046a0:	04054363          	bltz	a0,800046e6 <sys_chdir+0x68>
    800046a4:	e526                	sd	s1,136(sp)
    800046a6:	f6040513          	addi	a0,s0,-160
    800046aa:	88dfe0ef          	jal	80002f36 <namei>
    800046ae:	84aa                	mv	s1,a0
    800046b0:	c915                	beqz	a0,800046e4 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800046b2:	856fe0ef          	jal	80002708 <ilock>
  if(ip->type != T_DIR){
    800046b6:	04449703          	lh	a4,68(s1)
    800046ba:	4785                	li	a5,1
    800046bc:	02f71963          	bne	a4,a5,800046ee <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800046c0:	8526                	mv	a0,s1
    800046c2:	8f4fe0ef          	jal	800027b6 <iunlock>
  iput(p->cwd);
    800046c6:	15093503          	ld	a0,336(s2)
    800046ca:	9c0fe0ef          	jal	8000288a <iput>
  end_op();
    800046ce:	ab7fe0ef          	jal	80003184 <end_op>
  p->cwd = ip;
    800046d2:	14993823          	sd	s1,336(s2)
  return 0;
    800046d6:	4501                	li	a0,0
    800046d8:	64aa                	ld	s1,136(sp)
}
    800046da:	60ea                	ld	ra,152(sp)
    800046dc:	644a                	ld	s0,144(sp)
    800046de:	690a                	ld	s2,128(sp)
    800046e0:	610d                	addi	sp,sp,160
    800046e2:	8082                	ret
    800046e4:	64aa                	ld	s1,136(sp)
    end_op();
    800046e6:	a9ffe0ef          	jal	80003184 <end_op>
    return -1;
    800046ea:	557d                	li	a0,-1
    800046ec:	b7fd                	j	800046da <sys_chdir+0x5c>
    iunlockput(ip);
    800046ee:	8526                	mv	a0,s1
    800046f0:	a24fe0ef          	jal	80002914 <iunlockput>
    end_op();
    800046f4:	a91fe0ef          	jal	80003184 <end_op>
    return -1;
    800046f8:	557d                	li	a0,-1
    800046fa:	64aa                	ld	s1,136(sp)
    800046fc:	bff9                	j	800046da <sys_chdir+0x5c>

00000000800046fe <sys_exec>:

uint64
sys_exec(void)
{
    800046fe:	7105                	addi	sp,sp,-480
    80004700:	ef86                	sd	ra,472(sp)
    80004702:	eba2                	sd	s0,464(sp)
    80004704:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004706:	e2840593          	addi	a1,s0,-472
    8000470a:	4505                	li	a0,1
    8000470c:	e5afd0ef          	jal	80001d66 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004710:	08000613          	li	a2,128
    80004714:	f3040593          	addi	a1,s0,-208
    80004718:	4501                	li	a0,0
    8000471a:	e68fd0ef          	jal	80001d82 <argstr>
    8000471e:	87aa                	mv	a5,a0
    return -1;
    80004720:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004722:	0e07c063          	bltz	a5,80004802 <sys_exec+0x104>
    80004726:	e7a6                	sd	s1,456(sp)
    80004728:	e3ca                	sd	s2,448(sp)
    8000472a:	ff4e                	sd	s3,440(sp)
    8000472c:	fb52                	sd	s4,432(sp)
    8000472e:	f756                	sd	s5,424(sp)
    80004730:	f35a                	sd	s6,416(sp)
    80004732:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004734:	e3040a13          	addi	s4,s0,-464
    80004738:	10000613          	li	a2,256
    8000473c:	4581                	li	a1,0
    8000473e:	8552                	mv	a0,s4
    80004740:	a1ffb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004744:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004746:	89d2                	mv	s3,s4
    80004748:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000474a:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000474e:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004750:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004754:	00391513          	slli	a0,s2,0x3
    80004758:	85d6                	mv	a1,s5
    8000475a:	e2843783          	ld	a5,-472(s0)
    8000475e:	953e                	add	a0,a0,a5
    80004760:	d60fd0ef          	jal	80001cc0 <fetchaddr>
    80004764:	02054663          	bltz	a0,80004790 <sys_exec+0x92>
    if(uarg == 0){
    80004768:	e2043783          	ld	a5,-480(s0)
    8000476c:	c7a1                	beqz	a5,800047b4 <sys_exec+0xb6>
    argv[i] = kalloc();
    8000476e:	997fb0ef          	jal	80000104 <kalloc>
    80004772:	85aa                	mv	a1,a0
    80004774:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004778:	cd01                	beqz	a0,80004790 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000477a:	865a                	mv	a2,s6
    8000477c:	e2043503          	ld	a0,-480(s0)
    80004780:	d8afd0ef          	jal	80001d0a <fetchstr>
    80004784:	00054663          	bltz	a0,80004790 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004788:	0905                	addi	s2,s2,1
    8000478a:	09a1                	addi	s3,s3,8
    8000478c:	fd7914e3          	bne	s2,s7,80004754 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004790:	100a0a13          	addi	s4,s4,256
    80004794:	6088                	ld	a0,0(s1)
    80004796:	cd31                	beqz	a0,800047f2 <sys_exec+0xf4>
    kfree(argv[i]);
    80004798:	885fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000479c:	04a1                	addi	s1,s1,8
    8000479e:	ff449be3          	bne	s1,s4,80004794 <sys_exec+0x96>
  return -1;
    800047a2:	557d                	li	a0,-1
    800047a4:	64be                	ld	s1,456(sp)
    800047a6:	691e                	ld	s2,448(sp)
    800047a8:	79fa                	ld	s3,440(sp)
    800047aa:	7a5a                	ld	s4,432(sp)
    800047ac:	7aba                	ld	s5,424(sp)
    800047ae:	7b1a                	ld	s6,416(sp)
    800047b0:	6bfa                	ld	s7,408(sp)
    800047b2:	a881                	j	80004802 <sys_exec+0x104>
      argv[i] = 0;
    800047b4:	0009079b          	sext.w	a5,s2
    800047b8:	e3040593          	addi	a1,s0,-464
    800047bc:	078e                	slli	a5,a5,0x3
    800047be:	97ae                	add	a5,a5,a1
    800047c0:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800047c4:	f3040513          	addi	a0,s0,-208
    800047c8:	bb2ff0ef          	jal	80003b7a <kexec>
    800047cc:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800047ce:	100a0a13          	addi	s4,s4,256
    800047d2:	6088                	ld	a0,0(s1)
    800047d4:	c511                	beqz	a0,800047e0 <sys_exec+0xe2>
    kfree(argv[i]);
    800047d6:	847fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800047da:	04a1                	addi	s1,s1,8
    800047dc:	ff449be3          	bne	s1,s4,800047d2 <sys_exec+0xd4>
  return ret;
    800047e0:	854a                	mv	a0,s2
    800047e2:	64be                	ld	s1,456(sp)
    800047e4:	691e                	ld	s2,448(sp)
    800047e6:	79fa                	ld	s3,440(sp)
    800047e8:	7a5a                	ld	s4,432(sp)
    800047ea:	7aba                	ld	s5,424(sp)
    800047ec:	7b1a                	ld	s6,416(sp)
    800047ee:	6bfa                	ld	s7,408(sp)
    800047f0:	a809                	j	80004802 <sys_exec+0x104>
  return -1;
    800047f2:	557d                	li	a0,-1
    800047f4:	64be                	ld	s1,456(sp)
    800047f6:	691e                	ld	s2,448(sp)
    800047f8:	79fa                	ld	s3,440(sp)
    800047fa:	7a5a                	ld	s4,432(sp)
    800047fc:	7aba                	ld	s5,424(sp)
    800047fe:	7b1a                	ld	s6,416(sp)
    80004800:	6bfa                	ld	s7,408(sp)
}
    80004802:	60fe                	ld	ra,472(sp)
    80004804:	645e                	ld	s0,464(sp)
    80004806:	613d                	addi	sp,sp,480
    80004808:	8082                	ret

000000008000480a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000480a:	7139                	addi	sp,sp,-64
    8000480c:	fc06                	sd	ra,56(sp)
    8000480e:	f822                	sd	s0,48(sp)
    80004810:	f426                	sd	s1,40(sp)
    80004812:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004814:	df4fc0ef          	jal	80000e08 <myproc>
    80004818:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000481a:	fd840593          	addi	a1,s0,-40
    8000481e:	4501                	li	a0,0
    80004820:	d46fd0ef          	jal	80001d66 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004824:	fc840593          	addi	a1,s0,-56
    80004828:	fd040513          	addi	a0,s0,-48
    8000482c:	828ff0ef          	jal	80003854 <pipealloc>
    return -1;
    80004830:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004832:	0a054763          	bltz	a0,800048e0 <sys_pipe+0xd6>
  fd0 = -1;
    80004836:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000483a:	fd043503          	ld	a0,-48(s0)
    8000483e:	ef2ff0ef          	jal	80003f30 <fdalloc>
    80004842:	fca42223          	sw	a0,-60(s0)
    80004846:	08054463          	bltz	a0,800048ce <sys_pipe+0xc4>
    8000484a:	fc843503          	ld	a0,-56(s0)
    8000484e:	ee2ff0ef          	jal	80003f30 <fdalloc>
    80004852:	fca42023          	sw	a0,-64(s0)
    80004856:	06054263          	bltz	a0,800048ba <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000485a:	4691                	li	a3,4
    8000485c:	fc440613          	addi	a2,s0,-60
    80004860:	fd843583          	ld	a1,-40(s0)
    80004864:	68a8                	ld	a0,80(s1)
    80004866:	aa0fc0ef          	jal	80000b06 <copyout>
    8000486a:	00054e63          	bltz	a0,80004886 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000486e:	4691                	li	a3,4
    80004870:	fc040613          	addi	a2,s0,-64
    80004874:	fd843583          	ld	a1,-40(s0)
    80004878:	95b6                	add	a1,a1,a3
    8000487a:	68a8                	ld	a0,80(s1)
    8000487c:	a8afc0ef          	jal	80000b06 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004880:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004882:	04055f63          	bgez	a0,800048e0 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80004886:	fc442783          	lw	a5,-60(s0)
    8000488a:	078e                	slli	a5,a5,0x3
    8000488c:	0d078793          	addi	a5,a5,208
    80004890:	97a6                	add	a5,a5,s1
    80004892:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004896:	fc042783          	lw	a5,-64(s0)
    8000489a:	078e                	slli	a5,a5,0x3
    8000489c:	0d078793          	addi	a5,a5,208
    800048a0:	97a6                	add	a5,a5,s1
    800048a2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800048a6:	fd043503          	ld	a0,-48(s0)
    800048aa:	c8ffe0ef          	jal	80003538 <fileclose>
    fileclose(wf);
    800048ae:	fc843503          	ld	a0,-56(s0)
    800048b2:	c87fe0ef          	jal	80003538 <fileclose>
    return -1;
    800048b6:	57fd                	li	a5,-1
    800048b8:	a025                	j	800048e0 <sys_pipe+0xd6>
    if(fd0 >= 0)
    800048ba:	fc442783          	lw	a5,-60(s0)
    800048be:	0007c863          	bltz	a5,800048ce <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    800048c2:	078e                	slli	a5,a5,0x3
    800048c4:	0d078793          	addi	a5,a5,208
    800048c8:	97a6                	add	a5,a5,s1
    800048ca:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800048ce:	fd043503          	ld	a0,-48(s0)
    800048d2:	c67fe0ef          	jal	80003538 <fileclose>
    fileclose(wf);
    800048d6:	fc843503          	ld	a0,-56(s0)
    800048da:	c5ffe0ef          	jal	80003538 <fileclose>
    return -1;
    800048de:	57fd                	li	a5,-1
}
    800048e0:	853e                	mv	a0,a5
    800048e2:	70e2                	ld	ra,56(sp)
    800048e4:	7442                	ld	s0,48(sp)
    800048e6:	74a2                	ld	s1,40(sp)
    800048e8:	6121                	addi	sp,sp,64
    800048ea:	8082                	ret
    800048ec:	0000                	unimp
	...

00000000800048f0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800048f0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800048f2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800048f4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    800048f6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    800048f8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800048fa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800048fc:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800048fe:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004900:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004902:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004904:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004906:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004908:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000490a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000490c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000490e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004910:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004912:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004914:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004916:	ab8fd0ef          	jal	80001bce <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000491a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000491c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000491e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004920:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004922:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004924:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004926:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004928:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000492a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000492c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000492e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004930:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004932:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004934:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004936:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004938:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000493a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000493c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000493e:	10200073          	sret
    80004942:	00000013          	nop
    80004946:	00000013          	nop
    8000494a:	00000013          	nop

000000008000494e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000494e:	1141                	addi	sp,sp,-16
    80004950:	e406                	sd	ra,8(sp)
    80004952:	e022                	sd	s0,0(sp)
    80004954:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004956:	0c000737          	lui	a4,0xc000
    8000495a:	4785                	li	a5,1
    8000495c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000495e:	c35c                	sw	a5,4(a4)
    80004960:	00470793          	addi	a5,a4,4 # c000004 <_entry-0x73fffffc>
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    80004964:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    80004966:	0d470713          	addi	a4,a4,212
    *(uint32*)(PLIC + irq*4) = 1;
    8000496a:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    8000496c:	0791                	addi	a5,a5,4
    8000496e:	fee79ee3          	bne	a5,a4,8000496a <plicinit+0x1c>
  }
#endif  
}
    80004972:	60a2                	ld	ra,8(sp)
    80004974:	6402                	ld	s0,0(sp)
    80004976:	0141                	addi	sp,sp,16
    80004978:	8082                	ret

000000008000497a <plicinithart>:

void
plicinithart(void)
{
    8000497a:	1141                	addi	sp,sp,-16
    8000497c:	e406                	sd	ra,8(sp)
    8000497e:	e022                	sd	s0,0(sp)
    80004980:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004982:	c52fc0ef          	jal	80000dd4 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004986:	0085179b          	slliw	a5,a0,0x8
    8000498a:	0c002737          	lui	a4,0xc002
    8000498e:	973e                	add	a4,a4,a5
    80004990:	40200693          	li	a3,1026
    80004994:	08d72023          	sw	a3,128(a4) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000.
  // volatile prevents the compiler from merging this with
  // the assignment above to generate a single 64-bit store.
  *(volatile uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    80004998:	0c002737          	lui	a4,0xc002
    8000499c:	08470713          	addi	a4,a4,132 # c002084 <_entry-0x73ffdf7c>
    800049a0:	97ba                	add	a5,a5,a4
    800049a2:	577d                	li	a4,-1
    800049a4:	c398                	sw	a4,0(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800049a6:	00d5151b          	slliw	a0,a0,0xd
    800049aa:	0c2017b7          	lui	a5,0xc201
    800049ae:	97aa                	add	a5,a5,a0
    800049b0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800049b4:	60a2                	ld	ra,8(sp)
    800049b6:	6402                	ld	s0,0(sp)
    800049b8:	0141                	addi	sp,sp,16
    800049ba:	8082                	ret

00000000800049bc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800049bc:	1141                	addi	sp,sp,-16
    800049be:	e406                	sd	ra,8(sp)
    800049c0:	e022                	sd	s0,0(sp)
    800049c2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049c4:	c10fc0ef          	jal	80000dd4 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800049c8:	00d5151b          	slliw	a0,a0,0xd
    800049cc:	0c2017b7          	lui	a5,0xc201
    800049d0:	97aa                	add	a5,a5,a0
  return irq;
}
    800049d2:	43c8                	lw	a0,4(a5)
    800049d4:	60a2                	ld	ra,8(sp)
    800049d6:	6402                	ld	s0,0(sp)
    800049d8:	0141                	addi	sp,sp,16
    800049da:	8082                	ret

00000000800049dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800049dc:	1101                	addi	sp,sp,-32
    800049de:	ec06                	sd	ra,24(sp)
    800049e0:	e822                	sd	s0,16(sp)
    800049e2:	e426                	sd	s1,8(sp)
    800049e4:	1000                	addi	s0,sp,32
    800049e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800049e8:	becfc0ef          	jal	80000dd4 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800049ec:	00d5179b          	slliw	a5,a0,0xd
    800049f0:	0c201737          	lui	a4,0xc201
    800049f4:	97ba                	add	a5,a5,a4
    800049f6:	c3c4                	sw	s1,4(a5)
}
    800049f8:	60e2                	ld	ra,24(sp)
    800049fa:	6442                	ld	s0,16(sp)
    800049fc:	64a2                	ld	s1,8(sp)
    800049fe:	6105                	addi	sp,sp,32
    80004a00:	8082                	ret

0000000080004a02 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a02:	1141                	addi	sp,sp,-16
    80004a04:	e406                	sd	ra,8(sp)
    80004a06:	e022                	sd	s0,0(sp)
    80004a08:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a0a:	479d                	li	a5,7
    80004a0c:	04a7ca63          	blt	a5,a0,80004a60 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a10:	00017797          	auipc	a5,0x17
    80004a14:	97078793          	addi	a5,a5,-1680 # 8001b380 <disk>
    80004a18:	97aa                	add	a5,a5,a0
    80004a1a:	0187c783          	lbu	a5,24(a5)
    80004a1e:	e7b9                	bnez	a5,80004a6c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a20:	00451693          	slli	a3,a0,0x4
    80004a24:	00017797          	auipc	a5,0x17
    80004a28:	95c78793          	addi	a5,a5,-1700 # 8001b380 <disk>
    80004a2c:	6398                	ld	a4,0(a5)
    80004a2e:	9736                	add	a4,a4,a3
    80004a30:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004a34:	6398                	ld	a4,0(a5)
    80004a36:	9736                	add	a4,a4,a3
    80004a38:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004a3c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004a40:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004a44:	97aa                	add	a5,a5,a0
    80004a46:	4705                	li	a4,1
    80004a48:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004a4c:	00017517          	auipc	a0,0x17
    80004a50:	94c50513          	addi	a0,a0,-1716 # 8001b398 <disk+0x18>
    80004a54:	a29fc0ef          	jal	8000147c <wakeup>
}
    80004a58:	60a2                	ld	ra,8(sp)
    80004a5a:	6402                	ld	s0,0(sp)
    80004a5c:	0141                	addi	sp,sp,16
    80004a5e:	8082                	ret
    panic("free_desc 1");
    80004a60:	00004517          	auipc	a0,0x4
    80004a64:	b6850513          	addi	a0,a0,-1176 # 800085c8 <etext+0x5c8>
    80004a68:	121010ef          	jal	80006388 <panic>
    panic("free_desc 2");
    80004a6c:	00004517          	auipc	a0,0x4
    80004a70:	b6c50513          	addi	a0,a0,-1172 # 800085d8 <etext+0x5d8>
    80004a74:	115010ef          	jal	80006388 <panic>

0000000080004a78 <virtio_disk_init>:
{
    80004a78:	1101                	addi	sp,sp,-32
    80004a7a:	ec06                	sd	ra,24(sp)
    80004a7c:	e822                	sd	s0,16(sp)
    80004a7e:	e426                	sd	s1,8(sp)
    80004a80:	e04a                	sd	s2,0(sp)
    80004a82:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004a84:	00004597          	auipc	a1,0x4
    80004a88:	b6458593          	addi	a1,a1,-1180 # 800085e8 <etext+0x5e8>
    80004a8c:	00017517          	auipc	a0,0x17
    80004a90:	a1c50513          	addi	a0,a0,-1508 # 8001b4a8 <disk+0x128>
    80004a94:	32d010ef          	jal	800065c0 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a98:	100017b7          	lui	a5,0x10001
    80004a9c:	4398                	lw	a4,0(a5)
    80004a9e:	2701                	sext.w	a4,a4
    80004aa0:	747277b7          	lui	a5,0x74727
    80004aa4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004aa8:	14f71863          	bne	a4,a5,80004bf8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004aac:	100017b7          	lui	a5,0x10001
    80004ab0:	43dc                	lw	a5,4(a5)
    80004ab2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004ab4:	4709                	li	a4,2
    80004ab6:	14e79163          	bne	a5,a4,80004bf8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004aba:	100017b7          	lui	a5,0x10001
    80004abe:	479c                	lw	a5,8(a5)
    80004ac0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004ac2:	12e79b63          	bne	a5,a4,80004bf8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004ac6:	100017b7          	lui	a5,0x10001
    80004aca:	47d8                	lw	a4,12(a5)
    80004acc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004ace:	554d47b7          	lui	a5,0x554d4
    80004ad2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004ad6:	12f71163          	bne	a4,a5,80004bf8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ada:	100017b7          	lui	a5,0x10001
    80004ade:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ae2:	4705                	li	a4,1
    80004ae4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ae6:	470d                	li	a4,3
    80004ae8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004aea:	10001737          	lui	a4,0x10001
    80004aee:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004af0:	c7ffe6b7          	lui	a3,0xc7ffe
    80004af4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff4662af77>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004af8:	8f75                	and	a4,a4,a3
    80004afa:	100016b7          	lui	a3,0x10001
    80004afe:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b00:	472d                	li	a4,11
    80004b02:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b04:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b08:	439c                	lw	a5,0(a5)
    80004b0a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b0e:	8ba1                	andi	a5,a5,8
    80004b10:	0e078a63          	beqz	a5,80004c04 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b14:	100017b7          	lui	a5,0x10001
    80004b18:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b1c:	43fc                	lw	a5,68(a5)
    80004b1e:	2781                	sext.w	a5,a5
    80004b20:	0e079863          	bnez	a5,80004c10 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004b24:	100017b7          	lui	a5,0x10001
    80004b28:	5bdc                	lw	a5,52(a5)
    80004b2a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004b2c:	0e078863          	beqz	a5,80004c1c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004b30:	471d                	li	a4,7
    80004b32:	0ef77b63          	bgeu	a4,a5,80004c28 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004b36:	dcefb0ef          	jal	80000104 <kalloc>
    80004b3a:	00017497          	auipc	s1,0x17
    80004b3e:	84648493          	addi	s1,s1,-1978 # 8001b380 <disk>
    80004b42:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004b44:	dc0fb0ef          	jal	80000104 <kalloc>
    80004b48:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004b4a:	dbafb0ef          	jal	80000104 <kalloc>
    80004b4e:	87aa                	mv	a5,a0
    80004b50:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004b52:	6088                	ld	a0,0(s1)
    80004b54:	0e050063          	beqz	a0,80004c34 <virtio_disk_init+0x1bc>
    80004b58:	00017717          	auipc	a4,0x17
    80004b5c:	83073703          	ld	a4,-2000(a4) # 8001b388 <disk+0x8>
    80004b60:	cb71                	beqz	a4,80004c34 <virtio_disk_init+0x1bc>
    80004b62:	cbe9                	beqz	a5,80004c34 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004b64:	6605                	lui	a2,0x1
    80004b66:	4581                	li	a1,0
    80004b68:	df6fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004b6c:	00017497          	auipc	s1,0x17
    80004b70:	81448493          	addi	s1,s1,-2028 # 8001b380 <disk>
    80004b74:	6605                	lui	a2,0x1
    80004b76:	4581                	li	a1,0
    80004b78:	6488                	ld	a0,8(s1)
    80004b7a:	de4fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    80004b7e:	6605                	lui	a2,0x1
    80004b80:	4581                	li	a1,0
    80004b82:	6888                	ld	a0,16(s1)
    80004b84:	ddafb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004b88:	100017b7          	lui	a5,0x10001
    80004b8c:	4721                	li	a4,8
    80004b8e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004b90:	4098                	lw	a4,0(s1)
    80004b92:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004b96:	40d8                	lw	a4,4(s1)
    80004b98:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004b9c:	649c                	ld	a5,8(s1)
    80004b9e:	0007869b          	sext.w	a3,a5
    80004ba2:	10001737          	lui	a4,0x10001
    80004ba6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004baa:	9781                	srai	a5,a5,0x20
    80004bac:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004bb0:	689c                	ld	a5,16(s1)
    80004bb2:	0007869b          	sext.w	a3,a5
    80004bb6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004bba:	9781                	srai	a5,a5,0x20
    80004bbc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004bc0:	4785                	li	a5,1
    80004bc2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004bc4:	00f48c23          	sb	a5,24(s1)
    80004bc8:	00f48ca3          	sb	a5,25(s1)
    80004bcc:	00f48d23          	sb	a5,26(s1)
    80004bd0:	00f48da3          	sb	a5,27(s1)
    80004bd4:	00f48e23          	sb	a5,28(s1)
    80004bd8:	00f48ea3          	sb	a5,29(s1)
    80004bdc:	00f48f23          	sb	a5,30(s1)
    80004be0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004be4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004be8:	07272823          	sw	s2,112(a4)
}
    80004bec:	60e2                	ld	ra,24(sp)
    80004bee:	6442                	ld	s0,16(sp)
    80004bf0:	64a2                	ld	s1,8(sp)
    80004bf2:	6902                	ld	s2,0(sp)
    80004bf4:	6105                	addi	sp,sp,32
    80004bf6:	8082                	ret
    panic("could not find virtio disk");
    80004bf8:	00004517          	auipc	a0,0x4
    80004bfc:	a0050513          	addi	a0,a0,-1536 # 800085f8 <etext+0x5f8>
    80004c00:	788010ef          	jal	80006388 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004c04:	00004517          	auipc	a0,0x4
    80004c08:	a1450513          	addi	a0,a0,-1516 # 80008618 <etext+0x618>
    80004c0c:	77c010ef          	jal	80006388 <panic>
    panic("virtio disk should not be ready");
    80004c10:	00004517          	auipc	a0,0x4
    80004c14:	a2850513          	addi	a0,a0,-1496 # 80008638 <etext+0x638>
    80004c18:	770010ef          	jal	80006388 <panic>
    panic("virtio disk has no queue 0");
    80004c1c:	00004517          	auipc	a0,0x4
    80004c20:	a3c50513          	addi	a0,a0,-1476 # 80008658 <etext+0x658>
    80004c24:	764010ef          	jal	80006388 <panic>
    panic("virtio disk max queue too short");
    80004c28:	00004517          	auipc	a0,0x4
    80004c2c:	a5050513          	addi	a0,a0,-1456 # 80008678 <etext+0x678>
    80004c30:	758010ef          	jal	80006388 <panic>
    panic("virtio disk kalloc");
    80004c34:	00004517          	auipc	a0,0x4
    80004c38:	a6450513          	addi	a0,a0,-1436 # 80008698 <etext+0x698>
    80004c3c:	74c010ef          	jal	80006388 <panic>

0000000080004c40 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004c40:	711d                	addi	sp,sp,-96
    80004c42:	ec86                	sd	ra,88(sp)
    80004c44:	e8a2                	sd	s0,80(sp)
    80004c46:	e4a6                	sd	s1,72(sp)
    80004c48:	e0ca                	sd	s2,64(sp)
    80004c4a:	fc4e                	sd	s3,56(sp)
    80004c4c:	f852                	sd	s4,48(sp)
    80004c4e:	f456                	sd	s5,40(sp)
    80004c50:	f05a                	sd	s6,32(sp)
    80004c52:	ec5e                	sd	s7,24(sp)
    80004c54:	e862                	sd	s8,16(sp)
    80004c56:	1080                	addi	s0,sp,96
    80004c58:	89aa                	mv	s3,a0
    80004c5a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004c5c:	00c52b83          	lw	s7,12(a0)
    80004c60:	001b9b9b          	slliw	s7,s7,0x1
    80004c64:	1b82                	slli	s7,s7,0x20
    80004c66:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004c6a:	00017517          	auipc	a0,0x17
    80004c6e:	83e50513          	addi	a0,a0,-1986 # 8001b4a8 <disk+0x128>
    80004c72:	1d9010ef          	jal	8000664a <acquire>
  for(int i = 0; i < NUM; i++){
    80004c76:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004c78:	00016a97          	auipc	s5,0x16
    80004c7c:	708a8a93          	addi	s5,s5,1800 # 8001b380 <disk>
  for(int i = 0; i < 3; i++){
    80004c80:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004c82:	5c7d                	li	s8,-1
    80004c84:	a095                	j	80004ce8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004c86:	00fa8733          	add	a4,s5,a5
    80004c8a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004c8e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004c90:	0207c563          	bltz	a5,80004cba <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004c94:	2905                	addiw	s2,s2,1
    80004c96:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c98:	05490c63          	beq	s2,s4,80004cf0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004c9c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c9e:	00016717          	auipc	a4,0x16
    80004ca2:	6e270713          	addi	a4,a4,1762 # 8001b380 <disk>
    80004ca6:	4781                	li	a5,0
    if(disk.free[i]){
    80004ca8:	01874683          	lbu	a3,24(a4)
    80004cac:	fee9                	bnez	a3,80004c86 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004cae:	2785                	addiw	a5,a5,1
    80004cb0:	0705                	addi	a4,a4,1
    80004cb2:	fe979be3          	bne	a5,s1,80004ca8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004cb6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004cba:	01205d63          	blez	s2,80004cd4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004cbe:	fa042503          	lw	a0,-96(s0)
    80004cc2:	d41ff0ef          	jal	80004a02 <free_desc>
      for(int j = 0; j < i; j++)
    80004cc6:	4785                	li	a5,1
    80004cc8:	0127d663          	bge	a5,s2,80004cd4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004ccc:	fa442503          	lw	a0,-92(s0)
    80004cd0:	d33ff0ef          	jal	80004a02 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004cd4:	00016597          	auipc	a1,0x16
    80004cd8:	7d458593          	addi	a1,a1,2004 # 8001b4a8 <disk+0x128>
    80004cdc:	00016517          	auipc	a0,0x16
    80004ce0:	6bc50513          	addi	a0,a0,1724 # 8001b398 <disk+0x18>
    80004ce4:	f4cfc0ef          	jal	80001430 <sleep>
  for(int i = 0; i < 3; i++){
    80004ce8:	fa040613          	addi	a2,s0,-96
    80004cec:	4901                	li	s2,0
    80004cee:	b77d                	j	80004c9c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004cf0:	fa042503          	lw	a0,-96(s0)
    80004cf4:	00451693          	slli	a3,a0,0x4

  if(write)
    80004cf8:	00016797          	auipc	a5,0x16
    80004cfc:	68878793          	addi	a5,a5,1672 # 8001b380 <disk>
    80004d00:	00451713          	slli	a4,a0,0x4
    80004d04:	0a070713          	addi	a4,a4,160
    80004d08:	973e                	add	a4,a4,a5
    80004d0a:	01603633          	snez	a2,s6
    80004d0e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004d10:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004d14:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d18:	6398                	ld	a4,0(a5)
    80004d1a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d1c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004d20:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d22:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004d24:	6390                	ld	a2,0(a5)
    80004d26:	00d60833          	add	a6,a2,a3
    80004d2a:	4741                	li	a4,16
    80004d2c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004d30:	4585                	li	a1,1
    80004d32:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004d36:	fa442703          	lw	a4,-92(s0)
    80004d3a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004d3e:	0712                	slli	a4,a4,0x4
    80004d40:	963a                	add	a2,a2,a4
    80004d42:	05898813          	addi	a6,s3,88
    80004d46:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004d4a:	0007b883          	ld	a7,0(a5)
    80004d4e:	9746                	add	a4,a4,a7
    80004d50:	40000613          	li	a2,1024
    80004d54:	c710                	sw	a2,8(a4)
  if(write)
    80004d56:	001b3613          	seqz	a2,s6
    80004d5a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004d5e:	8e4d                	or	a2,a2,a1
    80004d60:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004d64:	fa842603          	lw	a2,-88(s0)
    80004d68:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004d6c:	00451813          	slli	a6,a0,0x4
    80004d70:	02080813          	addi	a6,a6,32
    80004d74:	983e                	add	a6,a6,a5
    80004d76:	577d                	li	a4,-1
    80004d78:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004d7c:	0612                	slli	a2,a2,0x4
    80004d7e:	98b2                	add	a7,a7,a2
    80004d80:	03068713          	addi	a4,a3,48
    80004d84:	973e                	add	a4,a4,a5
    80004d86:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004d8a:	6398                	ld	a4,0(a5)
    80004d8c:	9732                	add	a4,a4,a2
    80004d8e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004d90:	4689                	li	a3,2
    80004d92:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004d96:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004d9a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004d9e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004da2:	6794                	ld	a3,8(a5)
    80004da4:	0026d703          	lhu	a4,2(a3)
    80004da8:	8b1d                	andi	a4,a4,7
    80004daa:	0706                	slli	a4,a4,0x1
    80004dac:	96ba                	add	a3,a3,a4
    80004dae:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004db2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004db6:	6798                	ld	a4,8(a5)
    80004db8:	00275783          	lhu	a5,2(a4)
    80004dbc:	2785                	addiw	a5,a5,1
    80004dbe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004dc2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004dc6:	100017b7          	lui	a5,0x10001
    80004dca:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004dce:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004dd2:	00016917          	auipc	s2,0x16
    80004dd6:	6d690913          	addi	s2,s2,1750 # 8001b4a8 <disk+0x128>
  while(b->disk == 1) {
    80004dda:	84ae                	mv	s1,a1
    80004ddc:	00b79a63          	bne	a5,a1,80004df0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004de0:	85ca                	mv	a1,s2
    80004de2:	854e                	mv	a0,s3
    80004de4:	e4cfc0ef          	jal	80001430 <sleep>
  while(b->disk == 1) {
    80004de8:	0049a783          	lw	a5,4(s3)
    80004dec:	fe978ae3          	beq	a5,s1,80004de0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004df0:	fa042903          	lw	s2,-96(s0)
    80004df4:	00491713          	slli	a4,s2,0x4
    80004df8:	02070713          	addi	a4,a4,32
    80004dfc:	00016797          	auipc	a5,0x16
    80004e00:	58478793          	addi	a5,a5,1412 # 8001b380 <disk>
    80004e04:	97ba                	add	a5,a5,a4
    80004e06:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004e0a:	00016997          	auipc	s3,0x16
    80004e0e:	57698993          	addi	s3,s3,1398 # 8001b380 <disk>
    80004e12:	00491713          	slli	a4,s2,0x4
    80004e16:	0009b783          	ld	a5,0(s3)
    80004e1a:	97ba                	add	a5,a5,a4
    80004e1c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004e20:	854a                	mv	a0,s2
    80004e22:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004e26:	bddff0ef          	jal	80004a02 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004e2a:	8885                	andi	s1,s1,1
    80004e2c:	f0fd                	bnez	s1,80004e12 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004e2e:	00016517          	auipc	a0,0x16
    80004e32:	67a50513          	addi	a0,a0,1658 # 8001b4a8 <disk+0x128>
    80004e36:	0a9010ef          	jal	800066de <release>
}
    80004e3a:	60e6                	ld	ra,88(sp)
    80004e3c:	6446                	ld	s0,80(sp)
    80004e3e:	64a6                	ld	s1,72(sp)
    80004e40:	6906                	ld	s2,64(sp)
    80004e42:	79e2                	ld	s3,56(sp)
    80004e44:	7a42                	ld	s4,48(sp)
    80004e46:	7aa2                	ld	s5,40(sp)
    80004e48:	7b02                	ld	s6,32(sp)
    80004e4a:	6be2                	ld	s7,24(sp)
    80004e4c:	6c42                	ld	s8,16(sp)
    80004e4e:	6125                	addi	sp,sp,96
    80004e50:	8082                	ret

0000000080004e52 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004e52:	1101                	addi	sp,sp,-32
    80004e54:	ec06                	sd	ra,24(sp)
    80004e56:	e822                	sd	s0,16(sp)
    80004e58:	e426                	sd	s1,8(sp)
    80004e5a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004e5c:	00016497          	auipc	s1,0x16
    80004e60:	52448493          	addi	s1,s1,1316 # 8001b380 <disk>
    80004e64:	00016517          	auipc	a0,0x16
    80004e68:	64450513          	addi	a0,a0,1604 # 8001b4a8 <disk+0x128>
    80004e6c:	7de010ef          	jal	8000664a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004e70:	100017b7          	lui	a5,0x10001
    80004e74:	53bc                	lw	a5,96(a5)
    80004e76:	8b8d                	andi	a5,a5,3
    80004e78:	10001737          	lui	a4,0x10001
    80004e7c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004e7e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004e82:	689c                	ld	a5,16(s1)
    80004e84:	0204d703          	lhu	a4,32(s1)
    80004e88:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004e8c:	04f70863          	beq	a4,a5,80004edc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004e90:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004e94:	6898                	ld	a4,16(s1)
    80004e96:	0204d783          	lhu	a5,32(s1)
    80004e9a:	8b9d                	andi	a5,a5,7
    80004e9c:	078e                	slli	a5,a5,0x3
    80004e9e:	97ba                	add	a5,a5,a4
    80004ea0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004ea2:	00479713          	slli	a4,a5,0x4
    80004ea6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004eaa:	9726                	add	a4,a4,s1
    80004eac:	01074703          	lbu	a4,16(a4)
    80004eb0:	e329                	bnez	a4,80004ef2 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004eb2:	0792                	slli	a5,a5,0x4
    80004eb4:	02078793          	addi	a5,a5,32
    80004eb8:	97a6                	add	a5,a5,s1
    80004eba:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004ebc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004ec0:	dbcfc0ef          	jal	8000147c <wakeup>

    disk.used_idx += 1;
    80004ec4:	0204d783          	lhu	a5,32(s1)
    80004ec8:	2785                	addiw	a5,a5,1
    80004eca:	17c2                	slli	a5,a5,0x30
    80004ecc:	93c1                	srli	a5,a5,0x30
    80004ece:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004ed2:	6898                	ld	a4,16(s1)
    80004ed4:	00275703          	lhu	a4,2(a4)
    80004ed8:	faf71ce3          	bne	a4,a5,80004e90 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004edc:	00016517          	auipc	a0,0x16
    80004ee0:	5cc50513          	addi	a0,a0,1484 # 8001b4a8 <disk+0x128>
    80004ee4:	7fa010ef          	jal	800066de <release>
}
    80004ee8:	60e2                	ld	ra,24(sp)
    80004eea:	6442                	ld	s0,16(sp)
    80004eec:	64a2                	ld	s1,8(sp)
    80004eee:	6105                	addi	sp,sp,32
    80004ef0:	8082                	ret
      panic("virtio_disk_intr status");
    80004ef2:	00003517          	auipc	a0,0x3
    80004ef6:	7be50513          	addi	a0,a0,1982 # 800086b0 <etext+0x6b0>
    80004efa:	48e010ef          	jal	80006388 <panic>

0000000080004efe <e1000_init>:
// e1003's registers are mapped.
// this code loosely follows the initialization directions
// in Chapter 14 of Intel's Software Developer's Manual.
void
e1000_init(uint32 *xregs)
{
    80004efe:	1101                	addi	sp,sp,-32
    80004f00:	ec06                	sd	ra,24(sp)
    80004f02:	e822                	sd	s0,16(sp)
    80004f04:	e426                	sd	s1,8(sp)
    80004f06:	e04a                	sd	s2,0(sp)
    80004f08:	1000                	addi	s0,sp,32
    80004f0a:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    80004f0c:	00003597          	auipc	a1,0x3
    80004f10:	7bc58593          	addi	a1,a1,1980 # 800086c8 <etext+0x6c8>
    80004f14:	00016517          	auipc	a0,0x16
    80004f18:	5ac50513          	addi	a0,a0,1452 # 8001b4c0 <e1000_lock>
    80004f1c:	6a4010ef          	jal	800065c0 <initlock>
  initlock(&e1000_lock_rx, "e1000_rx");
    80004f20:	00003597          	auipc	a1,0x3
    80004f24:	7b058593          	addi	a1,a1,1968 # 800086d0 <etext+0x6d0>
    80004f28:	00016517          	auipc	a0,0x16
    80004f2c:	5b050513          	addi	a0,a0,1456 # 8001b4d8 <e1000_lock_rx>
    80004f30:	690010ef          	jal	800065c0 <initlock>

  regs = xregs;
    80004f34:	00004797          	auipc	a5,0x4
    80004f38:	b297be23          	sd	s1,-1220(a5) # 80008a70 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    80004f3c:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    80004f40:	409c                	lw	a5,0(s1)
    80004f42:	04000737          	lui	a4,0x4000
    80004f46:	8fd9                	or	a5,a5,a4
    80004f48:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    80004f4a:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    80004f4e:	0330000f          	fence	rw,rw

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    80004f52:	10000613          	li	a2,256
    80004f56:	4581                	li	a1,0
    80004f58:	00016517          	auipc	a0,0x16
    80004f5c:	59850513          	addi	a0,a0,1432 # 8001b4f0 <tx_ring>
    80004f60:	9fefb0ef          	jal	8000015e <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    80004f64:	00016797          	auipc	a5,0x16
    80004f68:	58c78793          	addi	a5,a5,1420 # 8001b4f0 <tx_ring>
    80004f6c:	00016697          	auipc	a3,0x16
    80004f70:	68468693          	addi	a3,a3,1668 # 8001b5f0 <rx_ring>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    80004f74:	4705                	li	a4,1
    80004f76:	00e78623          	sb	a4,12(a5)
    tx_ring[i].addr = 0;
    80004f7a:	0007b023          	sd	zero,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    80004f7e:	07c1                	addi	a5,a5,16
    80004f80:	fed79be3          	bne	a5,a3,80004f76 <e1000_init+0x78>
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
    80004f84:	00016717          	auipc	a4,0x16
    80004f88:	56c70713          	addi	a4,a4,1388 # 8001b4f0 <tx_ring>
    80004f8c:	00004797          	auipc	a5,0x4
    80004f90:	ae47b783          	ld	a5,-1308(a5) # 80008a70 <regs>
    80004f94:	6691                	lui	a3,0x4
    80004f96:	97b6                	add	a5,a5,a3
    80004f98:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    80004f9c:	10000713          	li	a4,256
    80004fa0:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    80004fa4:	8007ac23          	sw	zero,-2024(a5)
    80004fa8:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    80004fac:	863a                	mv	a2,a4
    80004fae:	4581                	li	a1,0
    80004fb0:	00016517          	auipc	a0,0x16
    80004fb4:	64050513          	addi	a0,a0,1600 # 8001b5f0 <rx_ring>
    80004fb8:	9a6fb0ef          	jal	8000015e <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80004fbc:	00016497          	auipc	s1,0x16
    80004fc0:	63448493          	addi	s1,s1,1588 # 8001b5f0 <rx_ring>
    80004fc4:	00016917          	auipc	s2,0x16
    80004fc8:	72c90913          	addi	s2,s2,1836 # 8001b6f0 <netlock>
    rx_ring[i].addr = (uint64) kalloc();
    80004fcc:	938fb0ef          	jal	80000104 <kalloc>
    80004fd0:	e088                	sd	a0,0(s1)
    if (!rx_ring[i].addr)
    80004fd2:	c545                	beqz	a0,8000507a <e1000_init+0x17c>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80004fd4:	04c1                	addi	s1,s1,16
    80004fd6:	ff249be3          	bne	s1,s2,80004fcc <e1000_init+0xce>
      panic("e1000");
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    80004fda:	00004697          	auipc	a3,0x4
    80004fde:	a966b683          	ld	a3,-1386(a3) # 80008a70 <regs>
    80004fe2:	00016717          	auipc	a4,0x16
    80004fe6:	60e70713          	addi	a4,a4,1550 # 8001b5f0 <rx_ring>
    80004fea:	678d                	lui	a5,0x3
    80004fec:	97b6                	add	a5,a5,a3
    80004fee:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    80004ff2:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    80004ff6:	473d                	li	a4,15
    80004ff8:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    80004ffc:	10000713          	li	a4,256
    80005000:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80005004:	6795                	lui	a5,0x5
    80005006:	97b6                	add	a5,a5,a3
    80005008:	12005737          	lui	a4,0x12005
    8000500c:	45270713          	addi	a4,a4,1106 # 12005452 <_entry-0x6dffabae>
    80005010:	40e7a023          	sw	a4,1024(a5) # 5400 <_entry-0x7fffac00>
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    80005014:	80005737          	lui	a4,0x80005
    80005018:	63470713          	addi	a4,a4,1588 # ffffffff80005634 <end+0xfffffffefe631e4c>
    8000501c:	40e7a223          	sw	a4,1028(a5)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    80005020:	6795                	lui	a5,0x5
    80005022:	20078793          	addi	a5,a5,512 # 5200 <_entry-0x7fffae00>
    80005026:	97b6                	add	a5,a5,a3
    80005028:	6715                	lui	a4,0x5
    8000502a:	40070713          	addi	a4,a4,1024 # 5400 <_entry-0x7fffac00>
    8000502e:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    80005030:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < 4096/32; i++)
    80005034:	0791                	addi	a5,a5,4
    80005036:	fee79de3          	bne	a5,a4,80005030 <e1000_init+0x132>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    8000503a:	000407b7          	lui	a5,0x40
    8000503e:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    80005042:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    80005046:	006027b7          	lui	a5,0x602
    8000504a:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    8000504c:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    80005050:	040087b7          	lui	a5,0x4008
    80005054:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    80005056:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    8000505a:	678d                	lui	a5,0x3
    8000505c:	97b6                	add	a5,a5,a3
    8000505e:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    80005062:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    80005066:	08000793          	li	a5,128
    8000506a:	0cf6a823          	sw	a5,208(a3)
}
    8000506e:	60e2                	ld	ra,24(sp)
    80005070:	6442                	ld	s0,16(sp)
    80005072:	64a2                	ld	s1,8(sp)
    80005074:	6902                	ld	s2,0(sp)
    80005076:	6105                	addi	sp,sp,32
    80005078:	8082                	ret
      panic("e1000");
    8000507a:	00003517          	auipc	a0,0x3
    8000507e:	64e50513          	addi	a0,a0,1614 # 800086c8 <etext+0x6c8>
    80005082:	306010ef          	jal	80006388 <panic>

0000000080005086 <e1000_transmit>:

int
e1000_transmit(char *buf, int len)
{
    80005086:	7179                	addi	sp,sp,-48
    80005088:	f406                	sd	ra,40(sp)
    8000508a:	f022                	sd	s0,32(sp)
    8000508c:	ec26                	sd	s1,24(sp)
    8000508e:	e84a                	sd	s2,16(sp)
    80005090:	e44e                	sd	s3,8(sp)
    80005092:	e052                	sd	s4,0(sp)
    80005094:	1800                	addi	s0,sp,48
    80005096:	89aa                	mv	s3,a0
    80005098:	8a2e                	mv	s4,a1
  // return 0 on success.
  // return -1 on failure (e.g., there is no descriptor available)
  // so that the caller knows to free buf.
  //

  acquire(&e1000_lock);
    8000509a:	00016517          	auipc	a0,0x16
    8000509e:	42650513          	addi	a0,a0,1062 # 8001b4c0 <e1000_lock>
    800050a2:	5a8010ef          	jal	8000664a <acquire>

  // printf("e1000 transmit start\n");

  // Ask the E1000 for the TX ring index at which it's expecting the next packet, by reading the E1000_TDT control register.
  uint64 tail = regs[E1000_TDT];
    800050a6:	00004797          	auipc	a5,0x4
    800050aa:	9ca7b783          	ld	a5,-1590(a5) # 80008a70 <regs>
    800050ae:	6711                	lui	a4,0x4
    800050b0:	97ba                	add	a5,a5,a4
    800050b2:	8187a483          	lw	s1,-2024(a5)
    800050b6:	0004891b          	sext.w	s2,s1
    800050ba:	1482                	slli	s1,s1,0x20
    800050bc:	9081                	srli	s1,s1,0x20
  
  // Check if the ring is overflowing
  if (!(tx_ring[tail].status & E1000_TXD_STAT_DD)) {
    800050be:	00449713          	slli	a4,s1,0x4
    800050c2:	00016797          	auipc	a5,0x16
    800050c6:	3fe78793          	addi	a5,a5,1022 # 8001b4c0 <e1000_lock>
    800050ca:	97ba                	add	a5,a5,a4
    800050cc:	03c7c783          	lbu	a5,60(a5)
    800050d0:	8b85                	andi	a5,a5,1
    800050d2:	c3ad                	beqz	a5,80005134 <e1000_transmit+0xae>
    printf("the tx ring is overflowing");
    return -1;
  }

  // Use kfree() to free the last buffer that was transmitted from that descriptor (if there was one)
  void *last_buf = (void *)tx_ring[tail].addr;
    800050d4:	00449713          	slli	a4,s1,0x4
    800050d8:	00016797          	auipc	a5,0x16
    800050dc:	3e878793          	addi	a5,a5,1000 # 8001b4c0 <e1000_lock>
    800050e0:	97ba                	add	a5,a5,a4
    800050e2:	7b88                	ld	a0,48(a5)
  if (last_buf != 0) {
    800050e4:	e125                	bnez	a0,80005144 <e1000_transmit+0xbe>
    kfree(last_buf);
  }

  // Fill in the descriptor. Set the necessary cmd flags
  tx_ring[tail].addr = (uint64) buf;
    800050e6:	0492                	slli	s1,s1,0x4
    800050e8:	00016797          	auipc	a5,0x16
    800050ec:	3d878793          	addi	a5,a5,984 # 8001b4c0 <e1000_lock>
    800050f0:	97a6                	add	a5,a5,s1
    800050f2:	0337b823          	sd	s3,48(a5)
  tx_ring[tail].length = len;
    800050f6:	03479c23          	sh	s4,56(a5)
  tx_ring[tail].cmd = E1000_TXD_CMD_RS | E1000_TXD_CMD_EOP;
    800050fa:	4725                	li	a4,9
    800050fc:	02e78da3          	sb	a4,59(a5)
   
  // Update the ring position by adding one to E1000_TDT modulo TX_RING_SIZE
  regs[E1000_TDT] = (tail + 1) % TX_RING_SIZE;
    80005100:	2905                	addiw	s2,s2,1
    80005102:	00f97913          	andi	s2,s2,15
    80005106:	00004797          	auipc	a5,0x4
    8000510a:	96a7b783          	ld	a5,-1686(a5) # 80008a70 <regs>
    8000510e:	6711                	lui	a4,0x4
    80005110:	97ba                	add	a5,a5,a4
    80005112:	8127ac23          	sw	s2,-2024(a5)

  // printf("e1000 transmit end\n");

  release(&e1000_lock);
    80005116:	00016517          	auipc	a0,0x16
    8000511a:	3aa50513          	addi	a0,a0,938 # 8001b4c0 <e1000_lock>
    8000511e:	5c0010ef          	jal	800066de <release>
  
  return 0;
    80005122:	4501                	li	a0,0
}
    80005124:	70a2                	ld	ra,40(sp)
    80005126:	7402                	ld	s0,32(sp)
    80005128:	64e2                	ld	s1,24(sp)
    8000512a:	6942                	ld	s2,16(sp)
    8000512c:	69a2                	ld	s3,8(sp)
    8000512e:	6a02                	ld	s4,0(sp)
    80005130:	6145                	addi	sp,sp,48
    80005132:	8082                	ret
    printf("the tx ring is overflowing");
    80005134:	00003517          	auipc	a0,0x3
    80005138:	5ac50513          	addi	a0,a0,1452 # 800086e0 <etext+0x6e0>
    8000513c:	723000ef          	jal	8000605e <printf>
    return -1;
    80005140:	557d                	li	a0,-1
    80005142:	b7cd                	j	80005124 <e1000_transmit+0x9e>
    kfree(last_buf);
    80005144:	ed9fa0ef          	jal	8000001c <kfree>
    80005148:	bf79                	j	800050e6 <e1000_transmit+0x60>

000000008000514a <e1000_intr>:
  release(&e1000_lock_rx);
}

void
e1000_intr(void)
{
    8000514a:	7139                	addi	sp,sp,-64
    8000514c:	fc06                	sd	ra,56(sp)
    8000514e:	f822                	sd	s0,48(sp)
    80005150:	f426                	sd	s1,40(sp)
    80005152:	e05a                	sd	s6,0(sp)
    80005154:	0080                	addi	s0,sp,64
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    80005156:	00004497          	auipc	s1,0x4
    8000515a:	91a48493          	addi	s1,s1,-1766 # 80008a70 <regs>
    8000515e:	609c                	ld	a5,0(s1)
    80005160:	577d                	li	a4,-1
    80005162:	0ce7a023          	sw	a4,192(a5)
  acquire(&e1000_lock_rx);
    80005166:	00016517          	auipc	a0,0x16
    8000516a:	37250513          	addi	a0,a0,882 # 8001b4d8 <e1000_lock_rx>
    8000516e:	4dc010ef          	jal	8000664a <acquire>
    uint64 next = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    80005172:	609c                	ld	a5,0(s1)
    80005174:	670d                	lui	a4,0x3
    80005176:	97ba                	add	a5,a5,a4
    80005178:	8187a483          	lw	s1,-2024(a5)
    8000517c:	2485                	addiw	s1,s1,1
    8000517e:	00f4fb13          	andi	s6,s1,15
    if (!(rx_ring[next].status & E1000_RXD_STAT_DD)) {
    80005182:	004b1713          	slli	a4,s6,0x4
    80005186:	00016797          	auipc	a5,0x16
    8000518a:	33a78793          	addi	a5,a5,826 # 8001b4c0 <e1000_lock>
    8000518e:	97ba                	add	a5,a5,a4
    80005190:	13c7c783          	lbu	a5,316(a5)
    80005194:	8b85                	andi	a5,a5,1
    80005196:	c7bd                	beqz	a5,80005204 <e1000_intr+0xba>
    80005198:	f04a                	sd	s2,32(sp)
    8000519a:	ec4e                	sd	s3,24(sp)
    8000519c:	e852                	sd	s4,16(sp)
    8000519e:	e456                	sd	s5,8(sp)
    800051a0:	84da                	mv	s1,s6
    int len = rx_ring[next].length;
    800051a2:	00016997          	auipc	s3,0x16
    800051a6:	31e98993          	addi	s3,s3,798 # 8001b4c0 <e1000_lock>
    regs[E1000_RDT] = next;
    800051aa:	00004a97          	auipc	s5,0x4
    800051ae:	8c6a8a93          	addi	s5,s5,-1850 # 80008a70 <regs>
    800051b2:	6a0d                	lui	s4,0x3
    int len = rx_ring[next].length;
    800051b4:	00449913          	slli	s2,s1,0x4
    800051b8:	994e                	add	s2,s2,s3
    net_rx(buf, len);
    800051ba:	13895583          	lhu	a1,312(s2)
    800051be:	13093503          	ld	a0,304(s2)
    800051c2:	0df000ef          	jal	80005aa0 <net_rx>
    rx_ring[next].addr = (uint64) kalloc();
    800051c6:	f3ffa0ef          	jal	80000104 <kalloc>
    800051ca:	12a93823          	sd	a0,304(s2)
    if (!rx_ring[next].addr)
    800051ce:	c539                	beqz	a0,8000521c <e1000_intr+0xd2>
    rx_ring[next].status = 0;
    800051d0:	0492                	slli	s1,s1,0x4
    800051d2:	94ce                	add	s1,s1,s3
    800051d4:	12048e23          	sb	zero,316(s1)
    regs[E1000_RDT] = next;
    800051d8:	000ab783          	ld	a5,0(s5)
    800051dc:	97d2                	add	a5,a5,s4
    800051de:	8167ac23          	sw	s6,-2024(a5)
    uint64 next = (regs[E1000_RDT] + 1) % RX_RING_SIZE;
    800051e2:	8187a483          	lw	s1,-2024(a5)
    800051e6:	2485                	addiw	s1,s1,1
    800051e8:	00f4fb13          	andi	s6,s1,15
    800051ec:	84da                	mv	s1,s6
    if (!(rx_ring[next].status & E1000_RXD_STAT_DD)) {
    800051ee:	004b1793          	slli	a5,s6,0x4
    800051f2:	97ce                	add	a5,a5,s3
    800051f4:	13c7c783          	lbu	a5,316(a5)
    800051f8:	8b85                	andi	a5,a5,1
    800051fa:	ffcd                	bnez	a5,800051b4 <e1000_intr+0x6a>
    800051fc:	7902                	ld	s2,32(sp)
    800051fe:	69e2                	ld	s3,24(sp)
    80005200:	6a42                	ld	s4,16(sp)
    80005202:	6aa2                	ld	s5,8(sp)
  release(&e1000_lock_rx);
    80005204:	00016517          	auipc	a0,0x16
    80005208:	2d450513          	addi	a0,a0,724 # 8001b4d8 <e1000_lock_rx>
    8000520c:	4d2010ef          	jal	800066de <release>

  e1000_recv();
}
    80005210:	70e2                	ld	ra,56(sp)
    80005212:	7442                	ld	s0,48(sp)
    80005214:	74a2                	ld	s1,40(sp)
    80005216:	6b02                	ld	s6,0(sp)
    80005218:	6121                	addi	sp,sp,64
    8000521a:	8082                	ret
      panic("e1000_recv");
    8000521c:	00003517          	auipc	a0,0x3
    80005220:	4e450513          	addi	a0,a0,1252 # 80008700 <etext+0x700>
    80005224:	164010ef          	jal	80006388 <panic>

0000000080005228 <netinit>:

static struct spinlock netlock;

void
netinit(void)
{
    80005228:	1141                	addi	sp,sp,-16
    8000522a:	e406                	sd	ra,8(sp)
    8000522c:	e022                	sd	s0,0(sp)
    8000522e:	0800                	addi	s0,sp,16
  initlock(&netlock, "netlock");
    80005230:	00003597          	auipc	a1,0x3
    80005234:	4e058593          	addi	a1,a1,1248 # 80008710 <etext+0x710>
    80005238:	00016517          	auipc	a0,0x16
    8000523c:	4b850513          	addi	a0,a0,1208 # 8001b6f0 <netlock>
    80005240:	380010ef          	jal	800065c0 <initlock>

  // initialise unbinded ports and rx_rings
  for (int i=0; i< MAX_PORT_SIZE; i++){
    80005244:	01996717          	auipc	a4,0x1996
    80005248:	4c470713          	addi	a4,a4,1220 # 8199b708 <port2Status>
    8000524c:	00016797          	auipc	a5,0x16
    80005250:	53c78793          	addi	a5,a5,1340 # 8001b788 <port2Ring+0x80>
    80005254:	01996697          	auipc	a3,0x1996
    80005258:	53468693          	addi	a3,a3,1332 # 8199b788 <port2Status+0x80>
    port2Status[i] = false;
    8000525c:	00070023          	sb	zero,0(a4)
    port2Ring[i].r = 0;
    80005260:	0007a023          	sw	zero,0(a5)
    port2Ring[i].w = 0;
    80005264:	0007a223          	sw	zero,4(a5)
  for (int i=0; i< MAX_PORT_SIZE; i++){
    80005268:	0705                	addi	a4,a4,1
    8000526a:	08878793          	addi	a5,a5,136
    8000526e:	fed797e3          	bne	a5,a3,8000525c <netinit+0x34>
  }
}
    80005272:	60a2                	ld	ra,8(sp)
    80005274:	6402                	ld	s0,0(sp)
    80005276:	0141                	addi	sp,sp,16
    80005278:	8082                	ret

000000008000527a <sys_bind>:
// prepare to receive UDP packets address to the port,
// i.e. allocate any queues &c needed.
//
uint64
sys_bind(void)
{
    8000527a:	1101                	addi	sp,sp,-32
    8000527c:	ec06                	sd	ra,24(sp)
    8000527e:	e822                	sd	s0,16(sp)
    80005280:	1000                	addi	s0,sp,32
  //
  // Your code here.
  //

  int port;
  argint(0, &port);
    80005282:	fec40593          	addi	a1,s0,-20
    80005286:	4501                	li	a0,0
    80005288:	ac3fc0ef          	jal	80001d4a <argint>

  if (port < 0) { // invalid port?
    8000528c:	fec42783          	lw	a5,-20(s0)
    80005290:	0607c363          	bltz	a5,800052f6 <sys_bind+0x7c>
    printf("bind: port should >= 0\n");
    return -1;
  }

  acquire(&netlock);
    80005294:	00016517          	auipc	a0,0x16
    80005298:	45c50513          	addi	a0,a0,1116 # 8001b6f0 <netlock>
    8000529c:	3ae010ef          	jal	8000664a <acquire>

  if (port2Status[port]) { // binded?
    800052a0:	fec42583          	lw	a1,-20(s0)
    800052a4:	01996797          	auipc	a5,0x1996
    800052a8:	46478793          	addi	a5,a5,1124 # 8199b708 <port2Status>
    800052ac:	97ae                	add	a5,a5,a1
    800052ae:	0007c783          	lbu	a5,0(a5)
    800052b2:	ebb1                	bnez	a5,80005306 <sys_bind+0x8c>
    printf("bind: port %d is already binded\n", port);
    return 0;
  }

  struct proc *p = myproc();
    800052b4:	b55fb0ef          	jal	80000e08 <myproc>

  int emptyIdx = -1;
  for (int i =0; i < MAXBPORTS; i++) {
    if (p->bindedports[i] == port) { 
    800052b8:	fec42583          	lw	a1,-20(s0)
    800052bc:	16850713          	addi	a4,a0,360
  for (int i =0; i < MAXBPORTS; i++) {
    800052c0:	4781                	li	a5,0
      printf("bind: port %d is binded by pid %d\n", port, p->pid);
      release(&netlock);
      return -1;
    } else if (p->bindedports[i] == -1) {
    800052c2:	567d                	li	a2,-1
  for (int i =0; i < MAXBPORTS; i++) {
    800052c4:	4861                	li	a6,24
    if (p->bindedports[i] == port) { 
    800052c6:	4314                	lw	a3,0(a4)
    800052c8:	04b68763          	beq	a3,a1,80005316 <sys_bind+0x9c>
    } else if (p->bindedports[i] == -1) {
    800052cc:	06c68463          	beq	a3,a2,80005334 <sys_bind+0xba>
  for (int i =0; i < MAXBPORTS; i++) {
    800052d0:	2785                	addiw	a5,a5,1
    800052d2:	0711                	addi	a4,a4,4
    800052d4:	ff0799e3          	bne	a5,a6,800052c6 <sys_bind+0x4c>
      break;
    }
  }

  if (emptyIdx == -1) {
    printf("bind: unable to bind more than %d number of ports\n", MAXBPORTS);
    800052d8:	45e1                	li	a1,24
    800052da:	00003517          	auipc	a0,0x3
    800052de:	4a650513          	addi	a0,a0,1190 # 80008780 <etext+0x780>
    800052e2:	57d000ef          	jal	8000605e <printf>
    release(&netlock);
    800052e6:	00016517          	auipc	a0,0x16
    800052ea:	40a50513          	addi	a0,a0,1034 # 8001b6f0 <netlock>
    800052ee:	3f0010ef          	jal	800066de <release>
    return -1;
    800052f2:	557d                	li	a0,-1
    800052f4:	a0bd                	j	80005362 <sys_bind+0xe8>
    printf("bind: port should >= 0\n");
    800052f6:	00003517          	auipc	a0,0x3
    800052fa:	42250513          	addi	a0,a0,1058 # 80008718 <etext+0x718>
    800052fe:	561000ef          	jal	8000605e <printf>
    return -1;
    80005302:	557d                	li	a0,-1
    80005304:	a8b9                	j	80005362 <sys_bind+0xe8>
    printf("bind: port %d is already binded\n", port);
    80005306:	00003517          	auipc	a0,0x3
    8000530a:	42a50513          	addi	a0,a0,1066 # 80008730 <etext+0x730>
    8000530e:	551000ef          	jal	8000605e <printf>
    return 0;
    80005312:	4501                	li	a0,0
    80005314:	a0b9                	j	80005362 <sys_bind+0xe8>
      printf("bind: port %d is binded by pid %d\n", port, p->pid);
    80005316:	5910                	lw	a2,48(a0)
    80005318:	00003517          	auipc	a0,0x3
    8000531c:	44050513          	addi	a0,a0,1088 # 80008758 <etext+0x758>
    80005320:	53f000ef          	jal	8000605e <printf>
      release(&netlock);
    80005324:	00016517          	auipc	a0,0x16
    80005328:	3cc50513          	addi	a0,a0,972 # 8001b6f0 <netlock>
    8000532c:	3b2010ef          	jal	800066de <release>
      return -1;
    80005330:	557d                	li	a0,-1
    80005332:	a805                	j	80005362 <sys_bind+0xe8>
  if (emptyIdx == -1) {
    80005334:	577d                	li	a4,-1
    80005336:	fae781e3          	beq	a5,a4,800052d8 <sys_bind+0x5e>
  }

  // bind port
  p->bindedports[emptyIdx] = port;
    8000533a:	078a                	slli	a5,a5,0x2
    8000533c:	16078793          	addi	a5,a5,352
    80005340:	953e                	add	a0,a0,a5
    80005342:	c50c                	sw	a1,8(a0)
  port2Status[port] = true;
    80005344:	01996797          	auipc	a5,0x1996
    80005348:	3c478793          	addi	a5,a5,964 # 8199b708 <port2Status>
    8000534c:	97ae                	add	a5,a5,a1
    8000534e:	4705                	li	a4,1
    80005350:	00e78023          	sb	a4,0(a5)

  release(&netlock);
    80005354:	00016517          	auipc	a0,0x16
    80005358:	39c50513          	addi	a0,a0,924 # 8001b6f0 <netlock>
    8000535c:	382010ef          	jal	800066de <release>

  return 0;
    80005360:	4501                	li	a0,0
}
    80005362:	60e2                	ld	ra,24(sp)
    80005364:	6442                	ld	s0,16(sp)
    80005366:	6105                	addi	sp,sp,32
    80005368:	8082                	ret

000000008000536a <sys_unbind>:
// release any resources previously created by bind(port);
// from now on UDP packets addressed to port should be dropped.
//
uint64
sys_unbind(void)
{
    8000536a:	7179                	addi	sp,sp,-48
    8000536c:	f406                	sd	ra,40(sp)
    8000536e:	f022                	sd	s0,32(sp)
    80005370:	1800                	addi	s0,sp,48
  //
  // Optional: Your code here.
  //

  int port;
  argint(0, &port);
    80005372:	fdc40593          	addi	a1,s0,-36
    80005376:	4501                	li	a0,0
    80005378:	9d3fc0ef          	jal	80001d4a <argint>

  // invalid port
  if (port < 0) {
    8000537c:	fdc42783          	lw	a5,-36(s0)
    return -1;
    80005380:	557d                	li	a0,-1
  if (port < 0) {
    80005382:	0a07ce63          	bltz	a5,8000543e <sys_unbind+0xd4>
    80005386:	ec26                	sd	s1,24(sp)
  }

  struct proc *p = myproc();
    80005388:	a81fb0ef          	jal	80000e08 <myproc>
    8000538c:	84aa                	mv	s1,a0

  acquire(&netlock);
    8000538e:	00016517          	auipc	a0,0x16
    80005392:	36250513          	addi	a0,a0,866 # 8001b6f0 <netlock>
    80005396:	2b4010ef          	jal	8000664a <acquire>

  // unbind port
  for (int i =0; i < MAXBPORTS; i++) {
    if (p->bindedports[i] == port) { 
    8000539a:	fdc42683          	lw	a3,-36(s0)
    8000539e:	16848713          	addi	a4,s1,360
  for (int i =0; i < MAXBPORTS; i++) {
    800053a2:	4781                	li	a5,0
    800053a4:	45e1                	li	a1,24
    if (p->bindedports[i] == port) { 
    800053a6:	4310                	lw	a2,0(a4)
    800053a8:	00d60763          	beq	a2,a3,800053b6 <sys_unbind+0x4c>
  for (int i =0; i < MAXBPORTS; i++) {
    800053ac:	2785                	addiw	a5,a5,1
    800053ae:	0711                	addi	a4,a4,4
    800053b0:	feb79be3          	bne	a5,a1,800053a6 <sys_unbind+0x3c>
    800053b4:	a039                	j	800053c2 <sys_unbind+0x58>
      p->bindedports[i] = -1;
    800053b6:	078a                	slli	a5,a5,0x2
    800053b8:	16078793          	addi	a5,a5,352
    800053bc:	94be                	add	s1,s1,a5
    800053be:	57fd                	li	a5,-1
    800053c0:	c49c                	sw	a5,8(s1)
      break;
    }
  }
  port2Status[port] = false;
    800053c2:	01996797          	auipc	a5,0x1996
    800053c6:	34678793          	addi	a5,a5,838 # 8199b708 <port2Status>
    800053ca:	97b6                	add	a5,a5,a3
    800053cc:	00078023          	sb	zero,0(a5)

  // free the queue
  while (port2Ring[port].r != port2Ring[port].w) {
    800053d0:	00469793          	slli	a5,a3,0x4
    800053d4:	97b6                	add	a5,a5,a3
    800053d6:	078e                	slli	a5,a5,0x3
    800053d8:	00016717          	auipc	a4,0x16
    800053dc:	33070713          	addi	a4,a4,816 # 8001b708 <port2Ring>
    800053e0:	973e                	add	a4,a4,a5
    800053e2:	08072783          	lw	a5,128(a4)
    800053e6:	08472703          	lw	a4,132(a4)
    800053ea:	04f70263          	beq	a4,a5,8000542e <sys_unbind+0xc4>
    kfree((void *)port2Ring[port].buf_addr[port2Ring[port].r]);
    800053ee:	00016497          	auipc	s1,0x16
    800053f2:	31a48493          	addi	s1,s1,794 # 8001b708 <port2Ring>
    800053f6:	1782                	slli	a5,a5,0x20
    800053f8:	9381                	srli	a5,a5,0x20
    800053fa:	00469713          	slli	a4,a3,0x4
    800053fe:	9736                	add	a4,a4,a3
    80005400:	97ba                	add	a5,a5,a4
    80005402:	078e                	slli	a5,a5,0x3
    80005404:	97a6                	add	a5,a5,s1
    80005406:	6388                	ld	a0,0(a5)
    80005408:	c15fa0ef          	jal	8000001c <kfree>
    port2Ring[port].r = (port2Ring[port].r + 1) % PACKET_BUF_SIZE;
    8000540c:	fdc42683          	lw	a3,-36(s0)
    80005410:	00469713          	slli	a4,a3,0x4
    80005414:	9736                	add	a4,a4,a3
    80005416:	070e                	slli	a4,a4,0x3
    80005418:	9726                	add	a4,a4,s1
    8000541a:	08072783          	lw	a5,128(a4)
    8000541e:	2785                	addiw	a5,a5,1
    80005420:	8bbd                	andi	a5,a5,15
    80005422:	08f72023          	sw	a5,128(a4)
  while (port2Ring[port].r != port2Ring[port].w) {
    80005426:	08472703          	lw	a4,132(a4)
    8000542a:	fcf716e3          	bne	a4,a5,800053f6 <sys_unbind+0x8c>
  }

  release(&netlock);
    8000542e:	00016517          	auipc	a0,0x16
    80005432:	2c250513          	addi	a0,a0,706 # 8001b6f0 <netlock>
    80005436:	2a8010ef          	jal	800066de <release>

  return 0;
    8000543a:	4501                	li	a0,0
    8000543c:	64e2                	ld	s1,24(sp)
}
    8000543e:	70a2                	ld	ra,40(sp)
    80005440:	7402                	ld	s0,32(sp)
    80005442:	6145                	addi	sp,sp,48
    80005444:	8082                	ret

0000000080005446 <sys_recv>:
// dport, *src, and *sport are host byte order.
// bind(dport) must previously have been called.
//
uint64
sys_recv(void)
{
    80005446:	7159                	addi	sp,sp,-112
    80005448:	f486                	sd	ra,104(sp)
    8000544a:	f0a2                	sd	s0,96(sp)
    8000544c:	e8ca                	sd	s2,80(sp)
    8000544e:	e4ce                	sd	s3,72(sp)
    80005450:	1880                	addi	s0,sp,112
  // Your code here.
  //

  // printf("sys_recv start\n");

  struct proc *p = myproc();
    80005452:	9b7fb0ef          	jal	80000e08 <myproc>
    80005456:	89aa                	mv	s3,a0
  uint64 src;
  uint64 sport;
  uint64 buf;
  int maxlen;

  argint(0, &dport);
    80005458:	fbc40593          	addi	a1,s0,-68
    8000545c:	4501                	li	a0,0
    8000545e:	8edfc0ef          	jal	80001d4a <argint>
  argaddr(1, &src);
    80005462:	fb040593          	addi	a1,s0,-80
    80005466:	4505                	li	a0,1
    80005468:	8fffc0ef          	jal	80001d66 <argaddr>
  argaddr(2, &sport);
    8000546c:	fa840593          	addi	a1,s0,-88
    80005470:	4509                	li	a0,2
    80005472:	8f5fc0ef          	jal	80001d66 <argaddr>
  argaddr(3, &buf);
    80005476:	fa040593          	addi	a1,s0,-96
    8000547a:	450d                	li	a0,3
    8000547c:	8ebfc0ef          	jal	80001d66 <argaddr>
  argint(4, &maxlen);
    80005480:	f9c40593          	addi	a1,s0,-100
    80005484:	4511                	li	a0,4
    80005486:	8c5fc0ef          	jal	80001d4a <argint>

  // Check if the port is binded by the caller
  bool isbinded = false;
  for (int i =0; i < MAXBPORTS; i++) {
    if (p->bindedports[i] == dport) { 
    8000548a:	fbc42583          	lw	a1,-68(s0)
    8000548e:	16898793          	addi	a5,s3,360
    80005492:	1c898693          	addi	a3,s3,456
    80005496:	4398                	lw	a4,0(a5)
    80005498:	04b70763          	beq	a4,a1,800054e6 <sys_recv+0xa0>
  for (int i =0; i < MAXBPORTS; i++) {
    8000549c:	0791                	addi	a5,a5,4
    8000549e:	fed79ce3          	bne	a5,a3,80005496 <sys_recv+0x50>
      isbinded = true;
      break;
    }
  }
  if (!isbinded) {
    printf("dport %d is not binded by pid %d\n", dport, p->pid);
    800054a2:	0309a603          	lw	a2,48(s3)
    800054a6:	00003517          	auipc	a0,0x3
    800054aa:	31250513          	addi	a0,a0,786 # 800087b8 <etext+0x7b8>
    800054ae:	3b1000ef          	jal	8000605e <printf>
    return -1;
    800054b2:	597d                	li	s2,-1
    800054b4:	a819                	j	800054ca <sys_recv+0x84>

  // Wait until interrupt handler has put some
  // packets into ring->buf_addr.
  while(ring->r == ring->w){
    if(killed(myproc())){
      release(&netlock);
    800054b6:	00016517          	auipc	a0,0x16
    800054ba:	23a50513          	addi	a0,a0,570 # 8001b6f0 <netlock>
    800054be:	220010ef          	jal	800066de <release>
      return -1;
    800054c2:	597d                	li	s2,-1
    800054c4:	64e6                	ld	s1,88(sp)
    800054c6:	6a06                	ld	s4,64(sp)
    800054c8:	7ae2                	ld	s5,56(sp)

err:
  kfree(ineth);
  return -1;

}
    800054ca:	854a                	mv	a0,s2
    800054cc:	70a6                	ld	ra,104(sp)
    800054ce:	7406                	ld	s0,96(sp)
    800054d0:	6946                	ld	s2,80(sp)
    800054d2:	69a6                	ld	s3,72(sp)
    800054d4:	6165                	addi	sp,sp,112
    800054d6:	8082                	ret
  kfree(ineth);
    800054d8:	8526                	mv	a0,s1
    800054da:	b43fa0ef          	jal	8000001c <kfree>
  return -1;
    800054de:	597d                	li	s2,-1
    800054e0:	64e6                	ld	s1,88(sp)
    800054e2:	7ae2                	ld	s5,56(sp)
    800054e4:	b7dd                	j	800054ca <sys_recv+0x84>
    800054e6:	eca6                	sd	s1,88(sp)
    800054e8:	fc56                	sd	s5,56(sp)
  acquire(&netlock);
    800054ea:	00016517          	auipc	a0,0x16
    800054ee:	20650513          	addi	a0,a0,518 # 8001b6f0 <netlock>
    800054f2:	158010ef          	jal	8000664a <acquire>
  struct rx_ring *ring = &port2Ring[dport];
    800054f6:	fbc42a83          	lw	s5,-68(s0)
  while(ring->r == ring->w){
    800054fa:	004a9793          	slli	a5,s5,0x4
    800054fe:	97d6                	add	a5,a5,s5
    80005500:	078e                	slli	a5,a5,0x3
    80005502:	00016717          	auipc	a4,0x16
    80005506:	20670713          	addi	a4,a4,518 # 8001b708 <port2Ring>
    8000550a:	973e                	add	a4,a4,a5
    8000550c:	08072783          	lw	a5,128(a4)
    80005510:	08472703          	lw	a4,132(a4)
    80005514:	04f71b63          	bne	a4,a5,8000556a <sys_recv+0x124>
    80005518:	e0d2                	sd	s4,64(sp)
    sleep(&ring->r, &netlock);
    8000551a:	004a9913          	slli	s2,s5,0x4
    8000551e:	9956                	add	s2,s2,s5
    80005520:	090e                	slli	s2,s2,0x3
    80005522:	08090913          	addi	s2,s2,128
    80005526:	00016797          	auipc	a5,0x16
    8000552a:	1e278793          	addi	a5,a5,482 # 8001b708 <port2Ring>
    8000552e:	993e                	add	s2,s2,a5
    80005530:	00016a17          	auipc	s4,0x16
    80005534:	1c0a0a13          	addi	s4,s4,448 # 8001b6f0 <netlock>
  while(ring->r == ring->w){
    80005538:	004a9793          	slli	a5,s5,0x4
    8000553c:	97d6                	add	a5,a5,s5
    8000553e:	078e                	slli	a5,a5,0x3
    80005540:	00016497          	auipc	s1,0x16
    80005544:	1c848493          	addi	s1,s1,456 # 8001b708 <port2Ring>
    80005548:	94be                	add	s1,s1,a5
    if(killed(myproc())){
    8000554a:	8bffb0ef          	jal	80000e08 <myproc>
    8000554e:	91efc0ef          	jal	8000166c <killed>
    80005552:	f135                	bnez	a0,800054b6 <sys_recv+0x70>
    sleep(&ring->r, &netlock);
    80005554:	85d2                	mv	a1,s4
    80005556:	854a                	mv	a0,s2
    80005558:	ed9fb0ef          	jal	80001430 <sleep>
  while(ring->r == ring->w){
    8000555c:	0804a783          	lw	a5,128(s1)
    80005560:	0844a703          	lw	a4,132(s1)
    80005564:	fef703e3          	beq	a4,a5,8000554a <sys_recv+0x104>
    80005568:	6a06                	ld	s4,64(sp)
  struct eth *ineth = (struct eth *) ring->buf_addr[ring->r];
    8000556a:	00016597          	auipc	a1,0x16
    8000556e:	19e58593          	addi	a1,a1,414 # 8001b708 <port2Ring>
    80005572:	02079713          	slli	a4,a5,0x20
    80005576:	9301                	srli	a4,a4,0x20
    80005578:	004a9613          	slli	a2,s5,0x4
    8000557c:	9656                	add	a2,a2,s5
    8000557e:	9732                	add	a4,a4,a2
    80005580:	070e                	slli	a4,a4,0x3
    80005582:	972e                	add	a4,a4,a1
    80005584:	6304                	ld	s1,0(a4)
  int ip_src = ntohl(inip->ip_src);
    80005586:	01a4a703          	lw	a4,26(s1)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    8000558a:	0187169b          	slliw	a3,a4,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    8000558e:	0187551b          	srliw	a0,a4,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005592:	8ec9                	or	a3,a3,a0
          ((val & 0x0000ff00UL) << 8) |
    80005594:	0087151b          	slliw	a0,a4,0x8
    80005598:	00ff0837          	lui	a6,0xff0
    8000559c:	01057533          	and	a0,a0,a6
          ((val & 0x00ff0000UL) >> 8) |
    800055a0:	8ec9                	or	a3,a3,a0
    800055a2:	0087571b          	srliw	a4,a4,0x8
    800055a6:	6541                	lui	a0,0x10
    800055a8:	f0050513          	addi	a0,a0,-256 # ff00 <_entry-0x7fff0100>
    800055ac:	8f69                	and	a4,a4,a0
    800055ae:	8f55                	or	a4,a4,a3
    800055b0:	f8e42c23          	sw	a4,-104(s0)
  return (((val & 0x00ffU) << 8) |
    800055b4:	0224d703          	lhu	a4,34(s1)
    800055b8:	00875693          	srli	a3,a4,0x8
    800055bc:	0087171b          	slliw	a4,a4,0x8
    800055c0:	9f35                	addw	a4,a4,a3
  short udp_sport = ntohs(inudp->sport);
    800055c2:	f8e41b23          	sh	a4,-106(s0)
  ring->r = (ring->r + 1) % PACKET_BUF_SIZE;
    800055c6:	060e                	slli	a2,a2,0x3
    800055c8:	95b2                	add	a1,a1,a2
    800055ca:	2785                	addiw	a5,a5,1
    800055cc:	8bbd                	andi	a5,a5,15
    800055ce:	08f5a023          	sw	a5,128(a1)
  release(&netlock);
    800055d2:	00016517          	auipc	a0,0x16
    800055d6:	11e50513          	addi	a0,a0,286 # 8001b6f0 <netlock>
    800055da:	104010ef          	jal	800066de <release>
  if (copyout(p->pagetable, src, (char *)&ip_src, sizeof(int)) == -1) {
    800055de:	4691                	li	a3,4
    800055e0:	f9840613          	addi	a2,s0,-104
    800055e4:	fb043583          	ld	a1,-80(s0)
    800055e8:	0509b503          	ld	a0,80(s3)
    800055ec:	d1afb0ef          	jal	80000b06 <copyout>
    800055f0:	57fd                	li	a5,-1
    800055f2:	eef503e3          	beq	a0,a5,800054d8 <sys_recv+0x92>
  if (copyout(p->pagetable, sport, (char *)&udp_sport, sizeof(short)) == -1) {
    800055f6:	4689                	li	a3,2
    800055f8:	f9640613          	addi	a2,s0,-106
    800055fc:	fa843583          	ld	a1,-88(s0)
    80005600:	0509b503          	ld	a0,80(s3)
    80005604:	d02fb0ef          	jal	80000b06 <copyout>
    80005608:	57fd                	li	a5,-1
    8000560a:	ecf507e3          	beq	a0,a5,800054d8 <sys_recv+0x92>
  char *payload = (char *) ((char *)inudp + 8); // 8 byte UDP header
    8000560e:	02a48613          	addi	a2,s1,42
    80005612:	0264d783          	lhu	a5,38(s1)
    80005616:	0087d693          	srli	a3,a5,0x8
    8000561a:	0087979b          	slliw	a5,a5,0x8
    8000561e:	9ebd                	addw	a3,a3,a5
  uint16 copyLen = ntohs(inudp->ulen) - 8;
    80005620:	36e1                	addiw	a3,a3,-8
    80005622:	16c2                	slli	a3,a3,0x30
    80005624:	92c1                	srli	a3,a3,0x30
  if (copyLen > maxlen) {
    80005626:	f9c42783          	lw	a5,-100(s0)
    8000562a:	0006871b          	sext.w	a4,a3
    8000562e:	00e7d563          	bge	a5,a4,80005638 <sys_recv+0x1f2>
    copyLen = (uint16) maxlen;
    80005632:	03079693          	slli	a3,a5,0x30
    80005636:	92c1                	srli	a3,a3,0x30
  if (copyout(p->pagetable, buf, payload, copyLen) == -1) {
    80005638:	8936                	mv	s2,a3
    8000563a:	fa043583          	ld	a1,-96(s0)
    8000563e:	0509b503          	ld	a0,80(s3)
    80005642:	cc4fb0ef          	jal	80000b06 <copyout>
    80005646:	57fd                	li	a5,-1
    80005648:	e8f508e3          	beq	a0,a5,800054d8 <sys_recv+0x92>
  kfree(ineth);
    8000564c:	8526                	mv	a0,s1
    8000564e:	9cffa0ef          	jal	8000001c <kfree>
  return copyLen;
    80005652:	64e6                	ld	s1,88(sp)
    80005654:	7ae2                	ld	s5,56(sp)
    80005656:	bd95                	j	800054ca <sys_recv+0x84>

0000000080005658 <sys_send>:
//
// send(int sport, int dst, int dport, char *buf, int len)
//
uint64
sys_send(void)
{
    80005658:	715d                	addi	sp,sp,-80
    8000565a:	e486                	sd	ra,72(sp)
    8000565c:	e0a2                	sd	s0,64(sp)
    8000565e:	f84a                	sd	s2,48(sp)
    80005660:	f44e                	sd	s3,40(sp)
    80005662:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    80005664:	fa4fb0ef          	jal	80000e08 <myproc>
    80005668:	89aa                	mv	s3,a0
  int dst;
  int dport;
  uint64 bufaddr;
  int len;

  argint(0, &sport);
    8000566a:	fcc40593          	addi	a1,s0,-52
    8000566e:	4501                	li	a0,0
    80005670:	edafc0ef          	jal	80001d4a <argint>
  argint(1, &dst);
    80005674:	fc840593          	addi	a1,s0,-56
    80005678:	4505                	li	a0,1
    8000567a:	ed0fc0ef          	jal	80001d4a <argint>
  argint(2, &dport);
    8000567e:	fc440593          	addi	a1,s0,-60
    80005682:	4509                	li	a0,2
    80005684:	ec6fc0ef          	jal	80001d4a <argint>
  argaddr(3, &bufaddr);
    80005688:	fb840593          	addi	a1,s0,-72
    8000568c:	450d                	li	a0,3
    8000568e:	ed8fc0ef          	jal	80001d66 <argaddr>
  argint(4, &len);
    80005692:	fb440593          	addi	a1,s0,-76
    80005696:	4511                	li	a0,4
    80005698:	eb2fc0ef          	jal	80001d4a <argint>

  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
    8000569c:	fb442903          	lw	s2,-76(s0)
    800056a0:	02a9091b          	addiw	s2,s2,42
  if(total > PGSIZE)
    800056a4:	6785                	lui	a5,0x1
    return -1;
    800056a6:	557d                	li	a0,-1
  if(total > PGSIZE)
    800056a8:	1527c963          	blt	a5,s2,800057fa <sys_send+0x1a2>
    800056ac:	fc26                	sd	s1,56(sp)

  char *buf = kalloc();
    800056ae:	a57fa0ef          	jal	80000104 <kalloc>
    800056b2:	84aa                	mv	s1,a0
  if(buf == 0){
    800056b4:	14050963          	beqz	a0,80005806 <sys_send+0x1ae>
    printf("sys_send: kalloc failed\n");
    return -1;
  }
  memset(buf, 0, PGSIZE);
    800056b8:	6605                	lui	a2,0x1
    800056ba:	4581                	li	a1,0
    800056bc:	aa3fa0ef          	jal	8000015e <memset>

  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
    800056c0:	4619                	li	a2,6
    800056c2:	00003597          	auipc	a1,0x3
    800056c6:	37658593          	addi	a1,a1,886 # 80008a38 <host_mac>
    800056ca:	8526                	mv	a0,s1
    800056cc:	af3fa0ef          	jal	800001be <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN);
    800056d0:	4619                	li	a2,6
    800056d2:	00003597          	auipc	a1,0x3
    800056d6:	36e58593          	addi	a1,a1,878 # 80008a40 <local_mac>
    800056da:	00c48533          	add	a0,s1,a2
    800056de:	ae1fa0ef          	jal	800001be <memmove>
  eth->type = htons(ETHTYPE_IP);
    800056e2:	47a1                	li	a5,8
    800056e4:	00f48623          	sb	a5,12(s1)
    800056e8:	000486a3          	sb	zero,13(s1)

  struct ip *ip = (struct ip *)(eth + 1);
    800056ec:	00e48713          	addi	a4,s1,14
  ip->ip_vhl = 0x45; // version 4, header length 4*5
    800056f0:	04500793          	li	a5,69
    800056f4:	00f48723          	sb	a5,14(s1)
  ip->ip_tos = 0;
    800056f8:	000487a3          	sb	zero,15(s1)
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
    800056fc:	fb442683          	lw	a3,-76(s0)
    80005700:	03069593          	slli	a1,a3,0x30
    80005704:	91c1                	srli	a1,a1,0x30
    80005706:	01c5879b          	addiw	a5,a1,28
    8000570a:	03079513          	slli	a0,a5,0x30
    8000570e:	03855613          	srli	a2,a0,0x38
    80005712:	0087979b          	slliw	a5,a5,0x8
    80005716:	9fb1                	addw	a5,a5,a2
    80005718:	00f49823          	sh	a5,16(s1)
  ip->ip_id = 0;
    8000571c:	00049923          	sh	zero,18(s1)
  ip->ip_off = 0;
    80005720:	00049a23          	sh	zero,20(s1)
  ip->ip_ttl = 100;
    80005724:	06400793          	li	a5,100
    80005728:	00f48b23          	sb	a5,22(s1)
  ip->ip_p = IPPROTO_UDP;
    8000572c:	47c5                	li	a5,17
    8000572e:	00f48ba3          	sb	a5,23(s1)
  ip->ip_src = htonl(local_ip);
    80005732:	0f0207b7          	lui	a5,0xf020
    80005736:	07a9                	addi	a5,a5,10 # f02000a <_entry-0x70fdfff6>
    80005738:	00f4ad23          	sw	a5,26(s1)
  ip->ip_dst = htonl(dst);
    8000573c:	fc842783          	lw	a5,-56(s0)
  return (((val & 0x000000ffUL) << 24) |
    80005740:	0187961b          	slliw	a2,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005744:	0187d51b          	srliw	a0,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    80005748:	8e49                	or	a2,a2,a0
          ((val & 0x0000ff00UL) << 8) |
    8000574a:	0087951b          	slliw	a0,a5,0x8
    8000574e:	00ff0837          	lui	a6,0xff0
    80005752:	01057533          	and	a0,a0,a6
          ((val & 0x00ff0000UL) >> 8) |
    80005756:	8e49                	or	a2,a2,a0
    80005758:	0087d79b          	srliw	a5,a5,0x8
    8000575c:	6541                	lui	a0,0x10
    8000575e:	f0050513          	addi	a0,a0,-256 # ff00 <_entry-0x7fff0100>
    80005762:	8fe9                	and	a5,a5,a0
    80005764:	8fd1                	or	a5,a5,a2
    80005766:	00f4af23          	sw	a5,30(s1)
  while (nleft > 1)  {
    8000576a:	02248813          	addi	a6,s1,34
  unsigned int sum = 0;
    8000576e:	4601                	li	a2,0
    sum += *w++;
    80005770:	0709                	addi	a4,a4,2
    80005772:	ffe75783          	lhu	a5,-2(a4)
    80005776:	9fb1                	addw	a5,a5,a2
    80005778:	863e                	mv	a2,a5
  while (nleft > 1)  {
    8000577a:	ff071be3          	bne	a4,a6,80005770 <sys_send+0x118>
  sum = (sum & 0xffff) + (sum >> 16);
    8000577e:	03079713          	slli	a4,a5,0x30
    80005782:	9341                	srli	a4,a4,0x30
    80005784:	0107d79b          	srliw	a5,a5,0x10
    80005788:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    8000578a:	0107d71b          	srliw	a4,a5,0x10
    8000578e:	9fb9                	addw	a5,a5,a4
  answer = ~sum; /* truncate to 16 bits */
    80005790:	fff7c793          	not	a5,a5
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));
    80005794:	00f49c23          	sh	a5,24(s1)

  struct udp *udp = (struct udp *)(ip + 1);
  udp->sport = htons(sport);
    80005798:	fcc42783          	lw	a5,-52(s0)
  return (((val & 0x00ffU) << 8) |
    8000579c:	03079613          	slli	a2,a5,0x30
    800057a0:	03865713          	srli	a4,a2,0x38
    800057a4:	0087979b          	slliw	a5,a5,0x8
    800057a8:	9fb9                	addw	a5,a5,a4
    800057aa:	02f49123          	sh	a5,34(s1)
  udp->dport = htons(dport);
    800057ae:	fc442783          	lw	a5,-60(s0)
    800057b2:	03079613          	slli	a2,a5,0x30
    800057b6:	03865713          	srli	a4,a2,0x38
    800057ba:	0087979b          	slliw	a5,a5,0x8
    800057be:	9fb9                	addw	a5,a5,a4
    800057c0:	02f49223          	sh	a5,36(s1)
  udp->ulen = htons(len + sizeof(struct udp));
    800057c4:	0085879b          	addiw	a5,a1,8
    800057c8:	03079613          	slli	a2,a5,0x30
    800057cc:	03865713          	srli	a4,a2,0x38
    800057d0:	0087979b          	slliw	a5,a5,0x8
    800057d4:	9fb9                	addw	a5,a5,a4
    800057d6:	02f49323          	sh	a5,38(s1)

  char *payload = (char *)(udp + 1);
  if(copyin(p->pagetable, payload, bufaddr, len) < 0){
    800057da:	fb843603          	ld	a2,-72(s0)
    800057de:	02a48593          	addi	a1,s1,42
    800057e2:	0509b503          	ld	a0,80(s3)
    800057e6:	be4fb0ef          	jal	80000bca <copyin>
    800057ea:	02054763          	bltz	a0,80005818 <sys_send+0x1c0>
    kfree(buf);
    printf("send: copyin failed\n");
    return -1;
  }

  e1000_transmit(buf, total);
    800057ee:	85ca                	mv	a1,s2
    800057f0:	8526                	mv	a0,s1
    800057f2:	895ff0ef          	jal	80005086 <e1000_transmit>

  return 0;
    800057f6:	4501                	li	a0,0
    800057f8:	74e2                	ld	s1,56(sp)
}
    800057fa:	60a6                	ld	ra,72(sp)
    800057fc:	6406                	ld	s0,64(sp)
    800057fe:	7942                	ld	s2,48(sp)
    80005800:	79a2                	ld	s3,40(sp)
    80005802:	6161                	addi	sp,sp,80
    80005804:	8082                	ret
    printf("sys_send: kalloc failed\n");
    80005806:	00003517          	auipc	a0,0x3
    8000580a:	fda50513          	addi	a0,a0,-38 # 800087e0 <etext+0x7e0>
    8000580e:	051000ef          	jal	8000605e <printf>
    return -1;
    80005812:	557d                	li	a0,-1
    80005814:	74e2                	ld	s1,56(sp)
    80005816:	b7d5                	j	800057fa <sys_send+0x1a2>
    kfree(buf);
    80005818:	8526                	mv	a0,s1
    8000581a:	803fa0ef          	jal	8000001c <kfree>
    printf("send: copyin failed\n");
    8000581e:	00003517          	auipc	a0,0x3
    80005822:	fe250513          	addi	a0,a0,-30 # 80008800 <etext+0x800>
    80005826:	039000ef          	jal	8000605e <printf>
    return -1;
    8000582a:	557d                	li	a0,-1
    8000582c:	74e2                	ld	s1,56(sp)
    8000582e:	b7f1                	j	800057fa <sys_send+0x1a2>

0000000080005830 <ip_rx>:

void
ip_rx(char *buf, int len)
{
    80005830:	1101                	addi	sp,sp,-32
    80005832:	ec06                	sd	ra,24(sp)
    80005834:	e822                	sd	s0,16(sp)
    80005836:	e426                	sd	s1,8(sp)
    80005838:	1000                	addi	s0,sp,32
    8000583a:	84aa                	mv	s1,a0
  // don't delete this printf; make grade depends on it.
  static int seen_ip = 0;
  if(seen_ip == 0)
    8000583c:	00003797          	auipc	a5,0x3
    80005840:	2407a783          	lw	a5,576(a5) # 80008a7c <seen_ip.1>
    80005844:	cfb5                	beqz	a5,800058c0 <ip_rx+0x90>
    printf("ip_rx: received an IP packet\n");
  seen_ip = 1;
    80005846:	4785                	li	a5,1
    80005848:	00003717          	auipc	a4,0x3
    8000584c:	22f72a23          	sw	a5,564(a4) # 80008a7c <seen_ip.1>

  struct eth *ineth = (struct eth *) buf;
  struct ip *inip = (struct ip *) (ineth + 1); // advance the pointer by 1 × sizeof(struct eth) bytes
  struct udp *inudp = (struct udp *) (inip + 1);

  if ( (ntohl(inip->ip_dst) != local_ip)    // check if the dst IP is equal to host IP
    80005850:	01e4a783          	lw	a5,30(s1)
  return (((val & 0x000000ffUL) << 24) |
    80005854:	0187971b          	slliw	a4,a5,0x18
          ((val & 0xff000000UL) >> 24));
    80005858:	0187d69b          	srliw	a3,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    8000585c:	8f55                	or	a4,a4,a3
          ((val & 0x0000ff00UL) << 8) |
    8000585e:	0087969b          	slliw	a3,a5,0x8
    80005862:	00ff0637          	lui	a2,0xff0
    80005866:	8ef1                	and	a3,a3,a2
          ((val & 0x00ff0000UL) >> 8) |
    80005868:	8f55                	or	a4,a4,a3
    8000586a:	0087d79b          	srliw	a5,a5,0x8
    8000586e:	66c1                	lui	a3,0x10
    80005870:	f0068693          	addi	a3,a3,-256 # ff00 <_entry-0x7fff0100>
    80005874:	8ff5                	and	a5,a5,a3
    80005876:	8fd9                	or	a5,a5,a4
    80005878:	0a000737          	lui	a4,0xa000
    8000587c:	20f70713          	addi	a4,a4,527 # a00020f <_entry-0x75fffdf1>
    80005880:	02e79863          	bne	a5,a4,800058b0 <ip_rx+0x80>
    || (inip->ip_p != IPPROTO_UDP)          // check if the arriving packet is UDP
    80005884:	0174c703          	lbu	a4,23(s1)
    80005888:	47c5                	li	a5,17
    8000588a:	02f71363          	bne	a4,a5,800058b0 <ip_rx+0x80>
  return (((val & 0x00ffU) << 8) |
    8000588e:	0244d703          	lhu	a4,36(s1)
    80005892:	00875793          	srli	a5,a4,0x8
    80005896:	0087171b          	slliw	a4,a4,0x8
    8000589a:	9fb9                	addw	a5,a5,a4
    || (!port2Status[ntohs(inudp->dport)])  // its destination port has been passed to bind()
    8000589c:	17c2                	slli	a5,a5,0x30
    8000589e:	93c1                	srli	a5,a5,0x30
    800058a0:	01996717          	auipc	a4,0x1996
    800058a4:	e6870713          	addi	a4,a4,-408 # 8199b708 <port2Status>
    800058a8:	97ba                	add	a5,a5,a4
    800058aa:	0007c783          	lbu	a5,0(a5)
    800058ae:	e385                	bnez	a5,800058ce <ip_rx+0x9e>
      ) {
    // drop the packet
    kfree(buf);
    800058b0:	8526                	mv	a0,s1
    800058b2:	f6afa0ef          	jal	8000001c <kfree>
  // Wake up sys_recv()
  // printf("wake up port %d, chan %p\n", ntohs(inudp->dport), &ring->r);
  wakeup(&ring->r);

  // printf("ip_rx: end\n");
}
    800058b6:	60e2                	ld	ra,24(sp)
    800058b8:	6442                	ld	s0,16(sp)
    800058ba:	64a2                	ld	s1,8(sp)
    800058bc:	6105                	addi	sp,sp,32
    800058be:	8082                	ret
    printf("ip_rx: received an IP packet\n");
    800058c0:	00003517          	auipc	a0,0x3
    800058c4:	f5850513          	addi	a0,a0,-168 # 80008818 <etext+0x818>
    800058c8:	796000ef          	jal	8000605e <printf>
    800058cc:	bfad                	j	80005846 <ip_rx+0x16>
    800058ce:	e04a                	sd	s2,0(sp)
  acquire(&netlock);
    800058d0:	00016517          	auipc	a0,0x16
    800058d4:	e2050513          	addi	a0,a0,-480 # 8001b6f0 <netlock>
    800058d8:	573000ef          	jal	8000664a <acquire>
    800058dc:	0244d783          	lhu	a5,36(s1)
    800058e0:	0087d713          	srli	a4,a5,0x8
    800058e4:	0087979b          	slliw	a5,a5,0x8
    800058e8:	9fb9                	addw	a5,a5,a4
    800058ea:	03079713          	slli	a4,a5,0x30
    800058ee:	9341                	srli	a4,a4,0x30
    800058f0:	893a                	mv	s2,a4
  struct rx_ring *ring = &port2Ring[ntohs(inudp->dport)];
    800058f2:	0007061b          	sext.w	a2,a4
  if ((ring->w + 1) % PACKET_BUF_SIZE == ring->r) {
    800058f6:	00471793          	slli	a5,a4,0x4
    800058fa:	97ba                	add	a5,a5,a4
    800058fc:	078e                	slli	a5,a5,0x3
    800058fe:	00016717          	auipc	a4,0x16
    80005902:	e0a70713          	addi	a4,a4,-502 # 8001b708 <port2Ring>
    80005906:	973e                	add	a4,a4,a5
    80005908:	08472783          	lw	a5,132(a4)
    8000590c:	0017869b          	addiw	a3,a5,1
    80005910:	8abd                	andi	a3,a3,15
    80005912:	08072703          	lw	a4,128(a4)
    80005916:	04d70563          	beq	a4,a3,80005960 <ip_rx+0x130>
  ring->buf_addr[ring->w] = (uint64) buf;
    8000591a:	1782                	slli	a5,a5,0x20
    8000591c:	9381                	srli	a5,a5,0x20
    8000591e:	00461713          	slli	a4,a2,0x4
    80005922:	9732                	add	a4,a4,a2
    80005924:	97ba                	add	a5,a5,a4
    80005926:	078e                	slli	a5,a5,0x3
    80005928:	00016617          	auipc	a2,0x16
    8000592c:	de060613          	addi	a2,a2,-544 # 8001b708 <port2Ring>
    80005930:	97b2                	add	a5,a5,a2
    80005932:	e384                	sd	s1,0(a5)
  ring->w = (ring->w + 1) % PACKET_BUF_SIZE;
    80005934:	070e                	slli	a4,a4,0x3
    80005936:	84b2                	mv	s1,a2
    80005938:	9732                	add	a4,a4,a2
    8000593a:	08d72223          	sw	a3,132(a4)
  release(&netlock);
    8000593e:	00016517          	auipc	a0,0x16
    80005942:	db250513          	addi	a0,a0,-590 # 8001b6f0 <netlock>
    80005946:	599000ef          	jal	800066de <release>
  wakeup(&ring->r);
    8000594a:	00491513          	slli	a0,s2,0x4
    8000594e:	954a                	add	a0,a0,s2
    80005950:	050e                	slli	a0,a0,0x3
    80005952:	08050513          	addi	a0,a0,128
    80005956:	9526                	add	a0,a0,s1
    80005958:	b25fb0ef          	jal	8000147c <wakeup>
    8000595c:	6902                	ld	s2,0(sp)
    8000595e:	bfa1                	j	800058b6 <ip_rx+0x86>
    kfree(buf);
    80005960:	8526                	mv	a0,s1
    80005962:	ebafa0ef          	jal	8000001c <kfree>
    release(&netlock);
    80005966:	00016517          	auipc	a0,0x16
    8000596a:	d8a50513          	addi	a0,a0,-630 # 8001b6f0 <netlock>
    8000596e:	571000ef          	jal	800066de <release>
    return;
    80005972:	6902                	ld	s2,0(sp)
    80005974:	b789                	j	800058b6 <ip_rx+0x86>

0000000080005976 <arp_rx>:
// qemu to send IP packets to xv6; the real ARP
// protocol is more complex.
//
void
arp_rx(char *inbuf)
{
    80005976:	7179                	addi	sp,sp,-48
    80005978:	f406                	sd	ra,40(sp)
    8000597a:	f022                	sd	s0,32(sp)
    8000597c:	e84a                	sd	s2,16(sp)
    8000597e:	1800                	addi	s0,sp,48
    80005980:	892a                	mv	s2,a0
  static int seen_arp = 0;

  if(seen_arp){
    80005982:	00003797          	auipc	a5,0x3
    80005986:	0f67a783          	lw	a5,246(a5) # 80008a78 <seen_arp.0>
    8000598a:	10079263          	bnez	a5,80005a8e <arp_rx+0x118>
    8000598e:	ec26                	sd	s1,24(sp)
    80005990:	e44e                	sd	s3,8(sp)
    80005992:	e052                	sd	s4,0(sp)
    kfree(inbuf);
    return;
  }
  printf("arp_rx: received an ARP packet\n");
    80005994:	00003517          	auipc	a0,0x3
    80005998:	ea450513          	addi	a0,a0,-348 # 80008838 <etext+0x838>
    8000599c:	6c2000ef          	jal	8000605e <printf>
  seen_arp = 1;
    800059a0:	4785                	li	a5,1
    800059a2:	00003717          	auipc	a4,0x3
    800059a6:	0cf72b23          	sw	a5,214(a4) # 80008a78 <seen_arp.0>

  struct eth *ineth = (struct eth *) inbuf;
  struct arp *inarp = (struct arp *) (ineth + 1);

  char *buf = kalloc();
    800059aa:	f5afa0ef          	jal	80000104 <kalloc>
    800059ae:	84aa                	mv	s1,a0
  if(buf == 0)
    800059b0:	0e050263          	beqz	a0,80005a94 <arp_rx+0x11e>
    panic("send_arp_reply");
  
  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, ineth->shost, ETHADDR_LEN); // ethernet destination = query source
    800059b4:	00690a13          	addi	s4,s2,6
    800059b8:	4619                	li	a2,6
    800059ba:	85d2                	mv	a1,s4
    800059bc:	803fa0ef          	jal	800001be <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN); // ethernet source = xv6's ethernet address
    800059c0:	4619                	li	a2,6
    800059c2:	00003597          	auipc	a1,0x3
    800059c6:	07e58593          	addi	a1,a1,126 # 80008a40 <local_mac>
    800059ca:	00c48533          	add	a0,s1,a2
    800059ce:	ff0fa0ef          	jal	800001be <memmove>
  eth->type = htons(ETHTYPE_ARP);
    800059d2:	47a1                	li	a5,8
    800059d4:	00f48623          	sb	a5,12(s1)
    800059d8:	4719                	li	a4,6
    800059da:	00e486a3          	sb	a4,13(s1)

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
    800059de:	00048723          	sb	zero,14(s1)
    800059e2:	4705                	li	a4,1
    800059e4:	00e487a3          	sb	a4,15(s1)
  arp->pro = htons(ETHTYPE_IP);
    800059e8:	00f48823          	sb	a5,16(s1)
    800059ec:	000488a3          	sb	zero,17(s1)
  arp->hln = ETHADDR_LEN;
    800059f0:	4799                	li	a5,6
    800059f2:	00f48923          	sb	a5,18(s1)
  arp->pln = sizeof(uint32);
    800059f6:	4791                	li	a5,4
    800059f8:	00f489a3          	sb	a5,19(s1)
  arp->op = htons(ARP_OP_REPLY);
    800059fc:	00048a23          	sb	zero,20(s1)
    80005a00:	4989                	li	s3,2
    80005a02:	01348aa3          	sb	s3,21(s1)

  memmove(arp->sha, local_mac, ETHADDR_LEN);
    80005a06:	4619                	li	a2,6
    80005a08:	00003597          	auipc	a1,0x3
    80005a0c:	03858593          	addi	a1,a1,56 # 80008a40 <local_mac>
    80005a10:	01648513          	addi	a0,s1,22
    80005a14:	faafa0ef          	jal	800001be <memmove>
  arp->sip = htonl(local_ip);
    80005a18:	47a9                	li	a5,10
    80005a1a:	00f48e23          	sb	a5,28(s1)
    80005a1e:	00048ea3          	sb	zero,29(s1)
    80005a22:	01348f23          	sb	s3,30(s1)
    80005a26:	47bd                	li	a5,15
    80005a28:	00f48fa3          	sb	a5,31(s1)
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
    80005a2c:	4619                	li	a2,6
    80005a2e:	85d2                	mv	a1,s4
    80005a30:	02048513          	addi	a0,s1,32
    80005a34:	f8afa0ef          	jal	800001be <memmove>
  arp->tip = inarp->sip;
    80005a38:	01c94703          	lbu	a4,28(s2)
    80005a3c:	01d94783          	lbu	a5,29(s2)
    80005a40:	07a2                	slli	a5,a5,0x8
    80005a42:	8fd9                	or	a5,a5,a4
    80005a44:	01e94703          	lbu	a4,30(s2)
    80005a48:	0742                	slli	a4,a4,0x10
    80005a4a:	8f5d                	or	a4,a4,a5
    80005a4c:	01f94783          	lbu	a5,31(s2)
    80005a50:	07e2                	slli	a5,a5,0x18
    80005a52:	8fd9                	or	a5,a5,a4
    80005a54:	02f48323          	sb	a5,38(s1)
    80005a58:	0087d713          	srli	a4,a5,0x8
    80005a5c:	02e483a3          	sb	a4,39(s1)
    80005a60:	0107d713          	srli	a4,a5,0x10
    80005a64:	02e48423          	sb	a4,40(s1)
    80005a68:	83e1                	srli	a5,a5,0x18
    80005a6a:	02f484a3          	sb	a5,41(s1)

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));
    80005a6e:	02a00593          	li	a1,42
    80005a72:	8526                	mv	a0,s1
    80005a74:	e12ff0ef          	jal	80005086 <e1000_transmit>

  kfree(inbuf);
    80005a78:	854a                	mv	a0,s2
    80005a7a:	da2fa0ef          	jal	8000001c <kfree>
    80005a7e:	64e2                	ld	s1,24(sp)
    80005a80:	69a2                	ld	s3,8(sp)
    80005a82:	6a02                	ld	s4,0(sp)
}
    80005a84:	70a2                	ld	ra,40(sp)
    80005a86:	7402                	ld	s0,32(sp)
    80005a88:	6942                	ld	s2,16(sp)
    80005a8a:	6145                	addi	sp,sp,48
    80005a8c:	8082                	ret
    kfree(inbuf);
    80005a8e:	d8efa0ef          	jal	8000001c <kfree>
    return;
    80005a92:	bfcd                	j	80005a84 <arp_rx+0x10e>
    panic("send_arp_reply");
    80005a94:	00003517          	auipc	a0,0x3
    80005a98:	dc450513          	addi	a0,a0,-572 # 80008858 <etext+0x858>
    80005a9c:	0ed000ef          	jal	80006388 <panic>

0000000080005aa0 <net_rx>:

void
net_rx(char *buf, int len)
{
    80005aa0:	1141                	addi	sp,sp,-16
    80005aa2:	e406                	sd	ra,8(sp)
    80005aa4:	e022                	sd	s0,0(sp)
    80005aa6:	0800                	addi	s0,sp,16
  struct eth *eth = (struct eth *) buf;

  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
    80005aa8:	02900793          	li	a5,41
    80005aac:	02b7fe63          	bgeu	a5,a1,80005ae8 <net_rx+0x48>
     ntohs(eth->type) == ETHTYPE_ARP){
    80005ab0:	00c54703          	lbu	a4,12(a0)
    80005ab4:	00d54783          	lbu	a5,13(a0)
    80005ab8:	07a2                	slli	a5,a5,0x8
  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
    80005aba:	8fd9                	or	a5,a5,a4
    80005abc:	60800713          	li	a4,1544
    80005ac0:	02e78163          	beq	a5,a4,80005ae2 <net_rx+0x42>
    arp_rx(buf);
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
     ntohs(eth->type) == ETHTYPE_IP){
    80005ac4:	00c54703          	lbu	a4,12(a0)
    80005ac8:	00d54783          	lbu	a5,13(a0)
    80005acc:	07a2                	slli	a5,a5,0x8
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
    80005ace:	8fd9                	or	a5,a5,a4
    80005ad0:	4721                	li	a4,8
    80005ad2:	02e78063          	beq	a5,a4,80005af2 <net_rx+0x52>
    ip_rx(buf, len);
  } else {
    kfree(buf);
    80005ad6:	d46fa0ef          	jal	8000001c <kfree>
  }
}
    80005ada:	60a2                	ld	ra,8(sp)
    80005adc:	6402                	ld	s0,0(sp)
    80005ade:	0141                	addi	sp,sp,16
    80005ae0:	8082                	ret
    arp_rx(buf);
    80005ae2:	e95ff0ef          	jal	80005976 <arp_rx>
    80005ae6:	bfd5                	j	80005ada <net_rx+0x3a>
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
    80005ae8:	02100793          	li	a5,33
    80005aec:	feb7f5e3          	bgeu	a5,a1,80005ad6 <net_rx+0x36>
    80005af0:	bfd1                	j	80005ac4 <net_rx+0x24>
    ip_rx(buf, len);
    80005af2:	d3fff0ef          	jal	80005830 <ip_rx>
    80005af6:	b7d5                	j	80005ada <net_rx+0x3a>

0000000080005af8 <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    80005af8:	715d                	addi	sp,sp,-80
    80005afa:	e486                	sd	ra,72(sp)
    80005afc:	e0a2                	sd	s0,64(sp)
    80005afe:	fc26                	sd	s1,56(sp)
    80005b00:	f84a                	sd	s2,48(sp)
    80005b02:	f44e                	sd	s3,40(sp)
    80005b04:	f052                	sd	s4,32(sp)
    80005b06:	ec56                	sd	s5,24(sp)
    80005b08:	e85a                	sd	s6,16(sp)
    80005b0a:	e45e                	sd	s7,8(sp)
    80005b0c:	0880                	addi	s0,sp,80
    80005b0e:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    80005b12:	100e8937          	lui	s2,0x100e8
    80005b16:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    80005b1a:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    80005b1c:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    80005b1e:	40000b37          	lui	s6,0x40000
  for(int dev = 0; dev < 32; dev++){
    80005b22:	6a09                	lui	s4,0x2
    80005b24:	300409b7          	lui	s3,0x30040
    80005b28:	a021                	j	80005b30 <pci_init+0x38>
    80005b2a:	94d2                	add	s1,s1,s4
    80005b2c:	03348f63          	beq	s1,s3,80005b6a <pci_init+0x72>
    volatile uint32 *base = ecam + off;
    80005b30:	86a6                	mv	a3,s1
    uint32 id = base[0];
    80005b32:	409c                	lw	a5,0(s1)
    80005b34:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    80005b36:	ff279ae3          	bne	a5,s2,80005b2a <pci_init+0x32>
      base[1] = 7;
    80005b3a:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    80005b3e:	0330000f          	fence	rw,rw
      for(int i = 0; i < 6; i++){
    80005b42:	01048793          	addi	a5,s1,16
    80005b46:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    80005b4a:	4398                	lw	a4,0(a5)
    80005b4c:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    80005b4e:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    80005b52:	0330000f          	fence	rw,rw
        base[4+i] = old;
    80005b56:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    80005b58:	0791                	addi	a5,a5,4
    80005b5a:	fec798e3          	bne	a5,a2,80005b4a <pci_init+0x52>
      base[4+0] = e1000_regs;
    80005b5e:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    80005b62:	855a                	mv	a0,s6
    80005b64:	b9aff0ef          	jal	80004efe <e1000_init>
    80005b68:	b7c9                	j	80005b2a <pci_init+0x32>
    }
  }
}
    80005b6a:	60a6                	ld	ra,72(sp)
    80005b6c:	6406                	ld	s0,64(sp)
    80005b6e:	74e2                	ld	s1,56(sp)
    80005b70:	7942                	ld	s2,48(sp)
    80005b72:	79a2                	ld	s3,40(sp)
    80005b74:	7a02                	ld	s4,32(sp)
    80005b76:	6ae2                	ld	s5,24(sp)
    80005b78:	6b42                	ld	s6,16(sp)
    80005b7a:	6ba2                	ld	s7,8(sp)
    80005b7c:	6161                	addi	sp,sp,80
    80005b7e:	8082                	ret

0000000080005b80 <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80005b80:	1141                	addi	sp,sp,-16
    80005b82:	e406                	sd	ra,8(sp)
    80005b84:	e022                	sd	s0,0(sp)
    80005b86:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b88:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80005b8c:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b90:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80005b94:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005b98:	577d                	li	a4,-1
    80005b9a:	177e                	slli	a4,a4,0x3f
    80005b9c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80005b9e:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80005ba2:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80005ba6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005baa:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80005bae:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80005bb2:	000f4737          	lui	a4,0xf4
    80005bb6:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005bba:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005bbc:	14d79073          	csrw	stimecmp,a5
}
    80005bc0:	60a2                	ld	ra,8(sp)
    80005bc2:	6402                	ld	s0,0(sp)
    80005bc4:	0141                	addi	sp,sp,16
    80005bc6:	8082                	ret

0000000080005bc8 <start>:
{
    80005bc8:	1141                	addi	sp,sp,-16
    80005bca:	e406                	sd	ra,8(sp)
    80005bcc:	e022                	sd	s0,0(sp)
    80005bce:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005bd0:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005bd4:	7779                	lui	a4,0xffffe
    80005bd6:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7e62b017>
    80005bda:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005bdc:	6705                	lui	a4,0x1
    80005bde:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005be2:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005be4:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005be8:	ffffa797          	auipc	a5,0xffffa
    80005bec:	72c78793          	addi	a5,a5,1836 # 80000314 <main>
    80005bf0:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005bf4:	4781                	li	a5,0
    80005bf6:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005bfa:	67c1                	lui	a5,0x10
    80005bfc:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005bfe:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005c02:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005c06:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80005c0a:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80005c0e:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005c12:	57fd                	li	a5,-1
    80005c14:	83a9                	srli	a5,a5,0xa
    80005c16:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005c1a:	47bd                	li	a5,15
    80005c1c:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005c20:	f61ff0ef          	jal	80005b80 <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c24:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005c28:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005c2a:	823e                	mv	tp,a5
  asm volatile("mret");
    80005c2c:	30200073          	mret
}
    80005c30:	60a2                	ld	ra,8(sp)
    80005c32:	6402                	ld	s0,0(sp)
    80005c34:	0141                	addi	sp,sp,16
    80005c36:	8082                	ret

0000000080005c38 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005c38:	7119                	addi	sp,sp,-128
    80005c3a:	fc86                	sd	ra,120(sp)
    80005c3c:	f8a2                	sd	s0,112(sp)
    80005c3e:	f4a6                	sd	s1,104(sp)
    80005c40:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005c42:	06c05b63          	blez	a2,80005cb8 <consolewrite+0x80>
    80005c46:	f0ca                	sd	s2,96(sp)
    80005c48:	ecce                	sd	s3,88(sp)
    80005c4a:	e8d2                	sd	s4,80(sp)
    80005c4c:	e4d6                	sd	s5,72(sp)
    80005c4e:	e0da                	sd	s6,64(sp)
    80005c50:	fc5e                	sd	s7,56(sp)
    80005c52:	f862                	sd	s8,48(sp)
    80005c54:	f466                	sd	s9,40(sp)
    80005c56:	f06a                	sd	s10,32(sp)
    80005c58:	8b2a                	mv	s6,a0
    80005c5a:	8bae                	mv	s7,a1
    80005c5c:	8a32                	mv	s4,a2
  int i = 0;
    80005c5e:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80005c60:	02000c93          	li	s9,32
    80005c64:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005c68:	f8040a93          	addi	s5,s0,-128
    80005c6c:	5c7d                	li	s8,-1
    80005c6e:	a025                	j	80005c96 <consolewrite+0x5e>
    if(nn > n - i)
    80005c70:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005c74:	86ce                	mv	a3,s3
    80005c76:	01748633          	add	a2,s1,s7
    80005c7a:	85da                	mv	a1,s6
    80005c7c:	8556                	mv	a0,s5
    80005c7e:	b57fb0ef          	jal	800017d4 <either_copyin>
    80005c82:	03850d63          	beq	a0,s8,80005cbc <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80005c86:	85ce                	mv	a1,s3
    80005c88:	8556                	mv	a0,s5
    80005c8a:	7b4000ef          	jal	8000643e <uartwrite>
    i += nn;
    80005c8e:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005c92:	0144d963          	bge	s1,s4,80005ca4 <consolewrite+0x6c>
    if(nn > n - i)
    80005c96:	409a07bb          	subw	a5,s4,s1
    80005c9a:	893e                	mv	s2,a5
    80005c9c:	fcfcdae3          	bge	s9,a5,80005c70 <consolewrite+0x38>
    80005ca0:	896a                	mv	s2,s10
    80005ca2:	b7f9                	j	80005c70 <consolewrite+0x38>
    80005ca4:	7906                	ld	s2,96(sp)
    80005ca6:	69e6                	ld	s3,88(sp)
    80005ca8:	6a46                	ld	s4,80(sp)
    80005caa:	6aa6                	ld	s5,72(sp)
    80005cac:	6b06                	ld	s6,64(sp)
    80005cae:	7be2                	ld	s7,56(sp)
    80005cb0:	7c42                	ld	s8,48(sp)
    80005cb2:	7ca2                	ld	s9,40(sp)
    80005cb4:	7d02                	ld	s10,32(sp)
    80005cb6:	a821                	j	80005cce <consolewrite+0x96>
  int i = 0;
    80005cb8:	4481                	li	s1,0
    80005cba:	a811                	j	80005cce <consolewrite+0x96>
    80005cbc:	7906                	ld	s2,96(sp)
    80005cbe:	69e6                	ld	s3,88(sp)
    80005cc0:	6a46                	ld	s4,80(sp)
    80005cc2:	6aa6                	ld	s5,72(sp)
    80005cc4:	6b06                	ld	s6,64(sp)
    80005cc6:	7be2                	ld	s7,56(sp)
    80005cc8:	7c42                	ld	s8,48(sp)
    80005cca:	7ca2                	ld	s9,40(sp)
    80005ccc:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    80005cce:	8526                	mv	a0,s1
    80005cd0:	70e6                	ld	ra,120(sp)
    80005cd2:	7446                	ld	s0,112(sp)
    80005cd4:	74a6                	ld	s1,104(sp)
    80005cd6:	6109                	addi	sp,sp,128
    80005cd8:	8082                	ret

0000000080005cda <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005cda:	711d                	addi	sp,sp,-96
    80005cdc:	ec86                	sd	ra,88(sp)
    80005cde:	e8a2                	sd	s0,80(sp)
    80005ce0:	e4a6                	sd	s1,72(sp)
    80005ce2:	e0ca                	sd	s2,64(sp)
    80005ce4:	fc4e                	sd	s3,56(sp)
    80005ce6:	f852                	sd	s4,48(sp)
    80005ce8:	f05a                	sd	s6,32(sp)
    80005cea:	ec5e                	sd	s7,24(sp)
    80005cec:	1080                	addi	s0,sp,96
    80005cee:	8b2a                	mv	s6,a0
    80005cf0:	8a2e                	mv	s4,a1
    80005cf2:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005cf4:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80005cf6:	019ce517          	auipc	a0,0x19ce
    80005cfa:	a1a50513          	addi	a0,a0,-1510 # 819d3710 <cons>
    80005cfe:	14d000ef          	jal	8000664a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d02:	019ce497          	auipc	s1,0x19ce
    80005d06:	a0e48493          	addi	s1,s1,-1522 # 819d3710 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d0a:	019ce917          	auipc	s2,0x19ce
    80005d0e:	a9e90913          	addi	s2,s2,-1378 # 819d37a8 <cons+0x98>
  while(n > 0){
    80005d12:	0b305b63          	blez	s3,80005dc8 <consoleread+0xee>
    while(cons.r == cons.w){
    80005d16:	0984a783          	lw	a5,152(s1)
    80005d1a:	09c4a703          	lw	a4,156(s1)
    80005d1e:	0af71063          	bne	a4,a5,80005dbe <consoleread+0xe4>
      if(killed(myproc())){
    80005d22:	8e6fb0ef          	jal	80000e08 <myproc>
    80005d26:	947fb0ef          	jal	8000166c <killed>
    80005d2a:	e12d                	bnez	a0,80005d8c <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80005d2c:	85a6                	mv	a1,s1
    80005d2e:	854a                	mv	a0,s2
    80005d30:	f00fb0ef          	jal	80001430 <sleep>
    while(cons.r == cons.w){
    80005d34:	0984a783          	lw	a5,152(s1)
    80005d38:	09c4a703          	lw	a4,156(s1)
    80005d3c:	fef703e3          	beq	a4,a5,80005d22 <consoleread+0x48>
    80005d40:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005d42:	019ce717          	auipc	a4,0x19ce
    80005d46:	9ce70713          	addi	a4,a4,-1586 # 819d3710 <cons>
    80005d4a:	0017869b          	addiw	a3,a5,1
    80005d4e:	08d72c23          	sw	a3,152(a4)
    80005d52:	07f7f693          	andi	a3,a5,127
    80005d56:	9736                	add	a4,a4,a3
    80005d58:	01874703          	lbu	a4,24(a4)
    80005d5c:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    80005d60:	4691                	li	a3,4
    80005d62:	04da8663          	beq	s5,a3,80005dae <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005d66:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d6a:	4685                	li	a3,1
    80005d6c:	faf40613          	addi	a2,s0,-81
    80005d70:	85d2                	mv	a1,s4
    80005d72:	855a                	mv	a0,s6
    80005d74:	a17fb0ef          	jal	8000178a <either_copyout>
    80005d78:	57fd                	li	a5,-1
    80005d7a:	04f50663          	beq	a0,a5,80005dc6 <consoleread+0xec>
      break;

    dst++;
    80005d7e:	0a05                	addi	s4,s4,1 # 2001 <_entry-0x7fffdfff>
    --n;
    80005d80:	39fd                	addiw	s3,s3,-1 # 3003ffff <_entry-0x4ffc0001>

    if(c == '\n'){
    80005d82:	47a9                	li	a5,10
    80005d84:	04fa8b63          	beq	s5,a5,80005dda <consoleread+0x100>
    80005d88:	7aa2                	ld	s5,40(sp)
    80005d8a:	b761                	j	80005d12 <consoleread+0x38>
        release(&cons.lock);
    80005d8c:	019ce517          	auipc	a0,0x19ce
    80005d90:	98450513          	addi	a0,a0,-1660 # 819d3710 <cons>
    80005d94:	14b000ef          	jal	800066de <release>
        return -1;
    80005d98:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005d9a:	60e6                	ld	ra,88(sp)
    80005d9c:	6446                	ld	s0,80(sp)
    80005d9e:	64a6                	ld	s1,72(sp)
    80005da0:	6906                	ld	s2,64(sp)
    80005da2:	79e2                	ld	s3,56(sp)
    80005da4:	7a42                	ld	s4,48(sp)
    80005da6:	7b02                	ld	s6,32(sp)
    80005da8:	6be2                	ld	s7,24(sp)
    80005daa:	6125                	addi	sp,sp,96
    80005dac:	8082                	ret
      if(n < target){
    80005dae:	0179fa63          	bgeu	s3,s7,80005dc2 <consoleread+0xe8>
        cons.r--;
    80005db2:	019ce717          	auipc	a4,0x19ce
    80005db6:	9ef72b23          	sw	a5,-1546(a4) # 819d37a8 <cons+0x98>
    80005dba:	7aa2                	ld	s5,40(sp)
    80005dbc:	a031                	j	80005dc8 <consoleread+0xee>
    80005dbe:	f456                	sd	s5,40(sp)
    80005dc0:	b749                	j	80005d42 <consoleread+0x68>
    80005dc2:	7aa2                	ld	s5,40(sp)
    80005dc4:	a011                	j	80005dc8 <consoleread+0xee>
    80005dc6:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005dc8:	019ce517          	auipc	a0,0x19ce
    80005dcc:	94850513          	addi	a0,a0,-1720 # 819d3710 <cons>
    80005dd0:	10f000ef          	jal	800066de <release>
  return target - n;
    80005dd4:	413b853b          	subw	a0,s7,s3
    80005dd8:	b7c9                	j	80005d9a <consoleread+0xc0>
    80005dda:	7aa2                	ld	s5,40(sp)
    80005ddc:	b7f5                	j	80005dc8 <consoleread+0xee>

0000000080005dde <consputc>:
{
    80005dde:	1141                	addi	sp,sp,-16
    80005de0:	e406                	sd	ra,8(sp)
    80005de2:	e022                	sd	s0,0(sp)
    80005de4:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005de6:	10000793          	li	a5,256
    80005dea:	00f50863          	beq	a0,a5,80005dfa <consputc+0x1c>
    uartputc_sync(c);
    80005dee:	6e4000ef          	jal	800064d2 <uartputc_sync>
}
    80005df2:	60a2                	ld	ra,8(sp)
    80005df4:	6402                	ld	s0,0(sp)
    80005df6:	0141                	addi	sp,sp,16
    80005df8:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005dfa:	4521                	li	a0,8
    80005dfc:	6d6000ef          	jal	800064d2 <uartputc_sync>
    80005e00:	02000513          	li	a0,32
    80005e04:	6ce000ef          	jal	800064d2 <uartputc_sync>
    80005e08:	4521                	li	a0,8
    80005e0a:	6c8000ef          	jal	800064d2 <uartputc_sync>
    80005e0e:	b7d5                	j	80005df2 <consputc+0x14>

0000000080005e10 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e10:	1101                	addi	sp,sp,-32
    80005e12:	ec06                	sd	ra,24(sp)
    80005e14:	e822                	sd	s0,16(sp)
    80005e16:	e426                	sd	s1,8(sp)
    80005e18:	1000                	addi	s0,sp,32
    80005e1a:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005e1c:	019ce517          	auipc	a0,0x19ce
    80005e20:	8f450513          	addi	a0,a0,-1804 # 819d3710 <cons>
    80005e24:	027000ef          	jal	8000664a <acquire>

  switch(c){
    80005e28:	47d5                	li	a5,21
    80005e2a:	08f48d63          	beq	s1,a5,80005ec4 <consoleintr+0xb4>
    80005e2e:	0297c563          	blt	a5,s1,80005e58 <consoleintr+0x48>
    80005e32:	47a1                	li	a5,8
    80005e34:	0ef48263          	beq	s1,a5,80005f18 <consoleintr+0x108>
    80005e38:	47c1                	li	a5,16
    80005e3a:	10f49363          	bne	s1,a5,80005f40 <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    80005e3e:	9e1fb0ef          	jal	8000181e <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005e42:	019ce517          	auipc	a0,0x19ce
    80005e46:	8ce50513          	addi	a0,a0,-1842 # 819d3710 <cons>
    80005e4a:	095000ef          	jal	800066de <release>
}
    80005e4e:	60e2                	ld	ra,24(sp)
    80005e50:	6442                	ld	s0,16(sp)
    80005e52:	64a2                	ld	s1,8(sp)
    80005e54:	6105                	addi	sp,sp,32
    80005e56:	8082                	ret
  switch(c){
    80005e58:	07f00793          	li	a5,127
    80005e5c:	0af48e63          	beq	s1,a5,80005f18 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005e60:	019ce717          	auipc	a4,0x19ce
    80005e64:	8b070713          	addi	a4,a4,-1872 # 819d3710 <cons>
    80005e68:	0a072783          	lw	a5,160(a4)
    80005e6c:	09872703          	lw	a4,152(a4)
    80005e70:	9f99                	subw	a5,a5,a4
    80005e72:	07f00713          	li	a4,127
    80005e76:	fcf766e3          	bltu	a4,a5,80005e42 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005e7a:	47b5                	li	a5,13
    80005e7c:	0cf48563          	beq	s1,a5,80005f46 <consoleintr+0x136>
      consputc(c);
    80005e80:	8526                	mv	a0,s1
    80005e82:	f5dff0ef          	jal	80005dde <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e86:	019ce717          	auipc	a4,0x19ce
    80005e8a:	88a70713          	addi	a4,a4,-1910 # 819d3710 <cons>
    80005e8e:	0a072683          	lw	a3,160(a4)
    80005e92:	0016879b          	addiw	a5,a3,1
    80005e96:	863e                	mv	a2,a5
    80005e98:	0af72023          	sw	a5,160(a4)
    80005e9c:	07f6f693          	andi	a3,a3,127
    80005ea0:	9736                	add	a4,a4,a3
    80005ea2:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005ea6:	ff648713          	addi	a4,s1,-10
    80005eaa:	c371                	beqz	a4,80005f6e <consoleintr+0x15e>
    80005eac:	14f1                	addi	s1,s1,-4
    80005eae:	c0e1                	beqz	s1,80005f6e <consoleintr+0x15e>
    80005eb0:	019ce717          	auipc	a4,0x19ce
    80005eb4:	8f872703          	lw	a4,-1800(a4) # 819d37a8 <cons+0x98>
    80005eb8:	9f99                	subw	a5,a5,a4
    80005eba:	08000713          	li	a4,128
    80005ebe:	f8e792e3          	bne	a5,a4,80005e42 <consoleintr+0x32>
    80005ec2:	a075                	j	80005f6e <consoleintr+0x15e>
    80005ec4:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005ec6:	019ce717          	auipc	a4,0x19ce
    80005eca:	84a70713          	addi	a4,a4,-1974 # 819d3710 <cons>
    80005ece:	0a072783          	lw	a5,160(a4)
    80005ed2:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ed6:	019ce497          	auipc	s1,0x19ce
    80005eda:	83a48493          	addi	s1,s1,-1990 # 819d3710 <cons>
    while(cons.e != cons.w &&
    80005ede:	4929                	li	s2,10
    80005ee0:	02f70863          	beq	a4,a5,80005f10 <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ee4:	37fd                	addiw	a5,a5,-1
    80005ee6:	07f7f713          	andi	a4,a5,127
    80005eea:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005eec:	01874703          	lbu	a4,24(a4)
    80005ef0:	03270263          	beq	a4,s2,80005f14 <consoleintr+0x104>
      cons.e--;
    80005ef4:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005ef8:	10000513          	li	a0,256
    80005efc:	ee3ff0ef          	jal	80005dde <consputc>
    while(cons.e != cons.w &&
    80005f00:	0a04a783          	lw	a5,160(s1)
    80005f04:	09c4a703          	lw	a4,156(s1)
    80005f08:	fcf71ee3          	bne	a4,a5,80005ee4 <consoleintr+0xd4>
    80005f0c:	6902                	ld	s2,0(sp)
    80005f0e:	bf15                	j	80005e42 <consoleintr+0x32>
    80005f10:	6902                	ld	s2,0(sp)
    80005f12:	bf05                	j	80005e42 <consoleintr+0x32>
    80005f14:	6902                	ld	s2,0(sp)
    80005f16:	b735                	j	80005e42 <consoleintr+0x32>
    if(cons.e != cons.w){
    80005f18:	019cd717          	auipc	a4,0x19cd
    80005f1c:	7f870713          	addi	a4,a4,2040 # 819d3710 <cons>
    80005f20:	0a072783          	lw	a5,160(a4)
    80005f24:	09c72703          	lw	a4,156(a4)
    80005f28:	f0f70de3          	beq	a4,a5,80005e42 <consoleintr+0x32>
      cons.e--;
    80005f2c:	37fd                	addiw	a5,a5,-1
    80005f2e:	019ce717          	auipc	a4,0x19ce
    80005f32:	88f72123          	sw	a5,-1918(a4) # 819d37b0 <cons+0xa0>
      consputc(BACKSPACE);
    80005f36:	10000513          	li	a0,256
    80005f3a:	ea5ff0ef          	jal	80005dde <consputc>
    80005f3e:	b711                	j	80005e42 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005f40:	f00481e3          	beqz	s1,80005e42 <consoleintr+0x32>
    80005f44:	bf31                	j	80005e60 <consoleintr+0x50>
      consputc(c);
    80005f46:	4529                	li	a0,10
    80005f48:	e97ff0ef          	jal	80005dde <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005f4c:	019cd797          	auipc	a5,0x19cd
    80005f50:	7c478793          	addi	a5,a5,1988 # 819d3710 <cons>
    80005f54:	0a07a703          	lw	a4,160(a5)
    80005f58:	0017069b          	addiw	a3,a4,1
    80005f5c:	8636                	mv	a2,a3
    80005f5e:	0ad7a023          	sw	a3,160(a5)
    80005f62:	07f77713          	andi	a4,a4,127
    80005f66:	97ba                	add	a5,a5,a4
    80005f68:	4729                	li	a4,10
    80005f6a:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f6e:	019ce797          	auipc	a5,0x19ce
    80005f72:	82c7af23          	sw	a2,-1986(a5) # 819d37ac <cons+0x9c>
        wakeup(&cons.r);
    80005f76:	019ce517          	auipc	a0,0x19ce
    80005f7a:	83250513          	addi	a0,a0,-1998 # 819d37a8 <cons+0x98>
    80005f7e:	cfefb0ef          	jal	8000147c <wakeup>
    80005f82:	b5c1                	j	80005e42 <consoleintr+0x32>

0000000080005f84 <consoleinit>:

void
consoleinit(void)
{
    80005f84:	1141                	addi	sp,sp,-16
    80005f86:	e406                	sd	ra,8(sp)
    80005f88:	e022                	sd	s0,0(sp)
    80005f8a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f8c:	00003597          	auipc	a1,0x3
    80005f90:	8dc58593          	addi	a1,a1,-1828 # 80008868 <etext+0x868>
    80005f94:	019cd517          	auipc	a0,0x19cd
    80005f98:	77c50513          	addi	a0,a0,1916 # 819d3710 <cons>
    80005f9c:	624000ef          	jal	800065c0 <initlock>

  uartinit();
    80005fa0:	448000ef          	jal	800063e8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005fa4:	00014797          	auipc	a5,0x14
    80005fa8:	38478793          	addi	a5,a5,900 # 8001a328 <devsw>
    80005fac:	00000717          	auipc	a4,0x0
    80005fb0:	d2e70713          	addi	a4,a4,-722 # 80005cda <consoleread>
    80005fb4:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005fb6:	00000717          	auipc	a4,0x0
    80005fba:	c8270713          	addi	a4,a4,-894 # 80005c38 <consolewrite>
    80005fbe:	ef98                	sd	a4,24(a5)
}
    80005fc0:	60a2                	ld	ra,8(sp)
    80005fc2:	6402                	ld	s0,0(sp)
    80005fc4:	0141                	addi	sp,sp,16
    80005fc6:	8082                	ret

0000000080005fc8 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005fc8:	7139                	addi	sp,sp,-64
    80005fca:	fc06                	sd	ra,56(sp)
    80005fcc:	f822                	sd	s0,48(sp)
    80005fce:	f04a                	sd	s2,32(sp)
    80005fd0:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005fd2:	c219                	beqz	a2,80005fd8 <printint+0x10>
    80005fd4:	08054163          	bltz	a0,80006056 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005fd8:	4301                	li	t1,0

  i = 0;
    80005fda:	fc840913          	addi	s2,s0,-56
    x = xx;
    80005fde:	86ca                	mv	a3,s2
  i = 0;
    80005fe0:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005fe2:	00003817          	auipc	a6,0x3
    80005fe6:	a3680813          	addi	a6,a6,-1482 # 80008a18 <digits>
    80005fea:	88ba                	mv	a7,a4
    80005fec:	0017061b          	addiw	a2,a4,1
    80005ff0:	8732                	mv	a4,a2
    80005ff2:	02b577b3          	remu	a5,a0,a1
    80005ff6:	97c2                	add	a5,a5,a6
    80005ff8:	0007c783          	lbu	a5,0(a5)
    80005ffc:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80006000:	87aa                	mv	a5,a0
    80006002:	02b55533          	divu	a0,a0,a1
    80006006:	0685                	addi	a3,a3,1
    80006008:	feb7f1e3          	bgeu	a5,a1,80005fea <printint+0x22>

  if(sign)
    8000600c:	00030c63          	beqz	t1,80006024 <printint+0x5c>
    buf[i++] = '-';
    80006010:	fe060793          	addi	a5,a2,-32
    80006014:	00878633          	add	a2,a5,s0
    80006018:	02d00793          	li	a5,45
    8000601c:	fef60423          	sb	a5,-24(a2)
    80006020:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80006024:	02e05463          	blez	a4,8000604c <printint+0x84>
    80006028:	f426                	sd	s1,40(sp)
    8000602a:	377d                	addiw	a4,a4,-1
    8000602c:	00e904b3          	add	s1,s2,a4
    80006030:	197d                	addi	s2,s2,-1
    80006032:	993a                	add	s2,s2,a4
    80006034:	1702                	slli	a4,a4,0x20
    80006036:	9301                	srli	a4,a4,0x20
    80006038:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000603c:	0004c503          	lbu	a0,0(s1)
    80006040:	d9fff0ef          	jal	80005dde <consputc>
  while(--i >= 0)
    80006044:	14fd                	addi	s1,s1,-1
    80006046:	ff249be3          	bne	s1,s2,8000603c <printint+0x74>
    8000604a:	74a2                	ld	s1,40(sp)
}
    8000604c:	70e2                	ld	ra,56(sp)
    8000604e:	7442                	ld	s0,48(sp)
    80006050:	7902                	ld	s2,32(sp)
    80006052:	6121                	addi	sp,sp,64
    80006054:	8082                	ret
    x = -xx;
    80006056:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    8000605a:	4305                	li	t1,1
    x = -xx;
    8000605c:	bfbd                	j	80005fda <printint+0x12>

000000008000605e <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000605e:	7131                	addi	sp,sp,-192
    80006060:	fc86                	sd	ra,120(sp)
    80006062:	f8a2                	sd	s0,112(sp)
    80006064:	f0ca                	sd	s2,96(sp)
    80006066:	0100                	addi	s0,sp,128
    80006068:	892a                	mv	s2,a0
    8000606a:	e40c                	sd	a1,8(s0)
    8000606c:	e810                	sd	a2,16(s0)
    8000606e:	ec14                	sd	a3,24(s0)
    80006070:	f018                	sd	a4,32(s0)
    80006072:	f41c                	sd	a5,40(s0)
    80006074:	03043823          	sd	a6,48(s0)
    80006078:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    8000607c:	00003797          	auipc	a5,0x3
    80006080:	a087a783          	lw	a5,-1528(a5) # 80008a84 <panicking>
    80006084:	cf9d                	beqz	a5,800060c2 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80006086:	00840793          	addi	a5,s0,8
    8000608a:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000608e:	00094503          	lbu	a0,0(s2)
    80006092:	22050663          	beqz	a0,800062be <printf+0x260>
    80006096:	f4a6                	sd	s1,104(sp)
    80006098:	ecce                	sd	s3,88(sp)
    8000609a:	e8d2                	sd	s4,80(sp)
    8000609c:	e4d6                	sd	s5,72(sp)
    8000609e:	e0da                	sd	s6,64(sp)
    800060a0:	fc5e                	sd	s7,56(sp)
    800060a2:	f862                	sd	s8,48(sp)
    800060a4:	f06a                	sd	s10,32(sp)
    800060a6:	ec6e                	sd	s11,24(sp)
    800060a8:	4a01                	li	s4,0
    if(cx != '%'){
    800060aa:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800060ae:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800060b2:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800060b6:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    800060ba:	4b29                	li	s6,10
    if(c0 == 'd'){
    800060bc:	06400b93          	li	s7,100
    800060c0:	a015                	j	800060e4 <printf+0x86>
    acquire(&pr.lock);
    800060c2:	019cd517          	auipc	a0,0x19cd
    800060c6:	6f650513          	addi	a0,a0,1782 # 819d37b8 <pr>
    800060ca:	580000ef          	jal	8000664a <acquire>
    800060ce:	bf65                	j	80006086 <printf+0x28>
      consputc(cx);
    800060d0:	d0fff0ef          	jal	80005dde <consputc>
      continue;
    800060d4:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800060d6:	2485                	addiw	s1,s1,1
    800060d8:	8a26                	mv	s4,s1
    800060da:	94ca                	add	s1,s1,s2
    800060dc:	0004c503          	lbu	a0,0(s1)
    800060e0:	1c050663          	beqz	a0,800062ac <printf+0x24e>
    if(cx != '%'){
    800060e4:	ff3516e3          	bne	a0,s3,800060d0 <printf+0x72>
    i++;
    800060e8:	001a079b          	addiw	a5,s4,1
    800060ec:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800060ee:	00f90733          	add	a4,s2,a5
    800060f2:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800060f6:	200a8963          	beqz	s5,80006308 <printf+0x2aa>
    800060fa:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    800060fe:	1e068c63          	beqz	a3,800062f6 <printf+0x298>
    if(c0 == 'd'){
    80006102:	037a8863          	beq	s5,s7,80006132 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80006106:	f94a8713          	addi	a4,s5,-108
    8000610a:	00173713          	seqz	a4,a4
    8000610e:	f9c68613          	addi	a2,a3,-100
    80006112:	ee05                	bnez	a2,8000614a <printf+0xec>
    80006114:	cb1d                	beqz	a4,8000614a <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    80006116:	f8843783          	ld	a5,-120(s0)
    8000611a:	00878713          	addi	a4,a5,8
    8000611e:	f8e43423          	sd	a4,-120(s0)
    80006122:	4605                	li	a2,1
    80006124:	85da                	mv	a1,s6
    80006126:	6388                	ld	a0,0(a5)
    80006128:	ea1ff0ef          	jal	80005fc8 <printint>
      i += 1;
    8000612c:	002a049b          	addiw	s1,s4,2
    80006130:	b75d                	j	800060d6 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    80006132:	f8843783          	ld	a5,-120(s0)
    80006136:	00878713          	addi	a4,a5,8
    8000613a:	f8e43423          	sd	a4,-120(s0)
    8000613e:	4605                	li	a2,1
    80006140:	85da                	mv	a1,s6
    80006142:	4388                	lw	a0,0(a5)
    80006144:	e85ff0ef          	jal	80005fc8 <printint>
    80006148:	b779                	j	800060d6 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    8000614a:	97ca                	add	a5,a5,s2
    8000614c:	8636                	mv	a2,a3
    8000614e:	0027c683          	lbu	a3,2(a5)
    80006152:	a2c9                	j	80006314 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80006154:	f8843783          	ld	a5,-120(s0)
    80006158:	00878713          	addi	a4,a5,8
    8000615c:	f8e43423          	sd	a4,-120(s0)
    80006160:	4605                	li	a2,1
    80006162:	45a9                	li	a1,10
    80006164:	6388                	ld	a0,0(a5)
    80006166:	e63ff0ef          	jal	80005fc8 <printint>
      i += 2;
    8000616a:	003a049b          	addiw	s1,s4,3
    8000616e:	b7a5                	j	800060d6 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    80006170:	f8843783          	ld	a5,-120(s0)
    80006174:	00878713          	addi	a4,a5,8
    80006178:	f8e43423          	sd	a4,-120(s0)
    8000617c:	4601                	li	a2,0
    8000617e:	85da                	mv	a1,s6
    80006180:	0007e503          	lwu	a0,0(a5)
    80006184:	e45ff0ef          	jal	80005fc8 <printint>
    80006188:	b7b9                	j	800060d6 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    8000618a:	f8843783          	ld	a5,-120(s0)
    8000618e:	00878713          	addi	a4,a5,8
    80006192:	f8e43423          	sd	a4,-120(s0)
    80006196:	4601                	li	a2,0
    80006198:	85da                	mv	a1,s6
    8000619a:	6388                	ld	a0,0(a5)
    8000619c:	e2dff0ef          	jal	80005fc8 <printint>
      i += 1;
    800061a0:	002a049b          	addiw	s1,s4,2
    800061a4:	bf0d                	j	800060d6 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    800061a6:	f8843783          	ld	a5,-120(s0)
    800061aa:	00878713          	addi	a4,a5,8
    800061ae:	f8e43423          	sd	a4,-120(s0)
    800061b2:	4601                	li	a2,0
    800061b4:	45a9                	li	a1,10
    800061b6:	6388                	ld	a0,0(a5)
    800061b8:	e11ff0ef          	jal	80005fc8 <printint>
      i += 2;
    800061bc:	003a049b          	addiw	s1,s4,3
    800061c0:	bf19                	j	800060d6 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    800061c2:	f8843783          	ld	a5,-120(s0)
    800061c6:	00878713          	addi	a4,a5,8
    800061ca:	f8e43423          	sd	a4,-120(s0)
    800061ce:	4601                	li	a2,0
    800061d0:	45c1                	li	a1,16
    800061d2:	0007e503          	lwu	a0,0(a5)
    800061d6:	df3ff0ef          	jal	80005fc8 <printint>
    800061da:	bdf5                	j	800060d6 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800061dc:	f8843783          	ld	a5,-120(s0)
    800061e0:	00878713          	addi	a4,a5,8
    800061e4:	f8e43423          	sd	a4,-120(s0)
    800061e8:	45c1                	li	a1,16
    800061ea:	6388                	ld	a0,0(a5)
    800061ec:	dddff0ef          	jal	80005fc8 <printint>
      i += 1;
    800061f0:	002a049b          	addiw	s1,s4,2
    800061f4:	b5cd                	j	800060d6 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800061f6:	f8843783          	ld	a5,-120(s0)
    800061fa:	00878713          	addi	a4,a5,8
    800061fe:	f8e43423          	sd	a4,-120(s0)
    80006202:	4601                	li	a2,0
    80006204:	45c1                	li	a1,16
    80006206:	6388                	ld	a0,0(a5)
    80006208:	dc1ff0ef          	jal	80005fc8 <printint>
      i += 2;
    8000620c:	003a049b          	addiw	s1,s4,3
    80006210:	b5d9                	j	800060d6 <printf+0x78>
    80006212:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    80006214:	f8843783          	ld	a5,-120(s0)
    80006218:	00878713          	addi	a4,a5,8
    8000621c:	f8e43423          	sd	a4,-120(s0)
    80006220:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80006224:	03000513          	li	a0,48
    80006228:	bb7ff0ef          	jal	80005dde <consputc>
  consputc('x');
    8000622c:	07800513          	li	a0,120
    80006230:	bafff0ef          	jal	80005dde <consputc>
    80006234:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006236:	00002c97          	auipc	s9,0x2
    8000623a:	7e2c8c93          	addi	s9,s9,2018 # 80008a18 <digits>
    8000623e:	03cad793          	srli	a5,s5,0x3c
    80006242:	97e6                	add	a5,a5,s9
    80006244:	0007c503          	lbu	a0,0(a5)
    80006248:	b97ff0ef          	jal	80005dde <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000624c:	0a92                	slli	s5,s5,0x4
    8000624e:	3a7d                	addiw	s4,s4,-1
    80006250:	fe0a17e3          	bnez	s4,8000623e <printf+0x1e0>
    80006254:	7ca2                	ld	s9,40(sp)
    80006256:	b541                	j	800060d6 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80006258:	f8843783          	ld	a5,-120(s0)
    8000625c:	00878713          	addi	a4,a5,8
    80006260:	f8e43423          	sd	a4,-120(s0)
    80006264:	4388                	lw	a0,0(a5)
    80006266:	b79ff0ef          	jal	80005dde <consputc>
    8000626a:	b5b5                	j	800060d6 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    8000626c:	f8843783          	ld	a5,-120(s0)
    80006270:	00878713          	addi	a4,a5,8
    80006274:	f8e43423          	sd	a4,-120(s0)
    80006278:	0007ba03          	ld	s4,0(a5)
    8000627c:	000a0d63          	beqz	s4,80006296 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    80006280:	000a4503          	lbu	a0,0(s4)
    80006284:	e40509e3          	beqz	a0,800060d6 <printf+0x78>
        consputc(*s);
    80006288:	b57ff0ef          	jal	80005dde <consputc>
      for(; *s; s++)
    8000628c:	0a05                	addi	s4,s4,1
    8000628e:	000a4503          	lbu	a0,0(s4)
    80006292:	f97d                	bnez	a0,80006288 <printf+0x22a>
    80006294:	b589                	j	800060d6 <printf+0x78>
        s = "(null)";
    80006296:	00002a17          	auipc	s4,0x2
    8000629a:	5daa0a13          	addi	s4,s4,1498 # 80008870 <etext+0x870>
      for(; *s; s++)
    8000629e:	02800513          	li	a0,40
    800062a2:	b7dd                	j	80006288 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    800062a4:	8556                	mv	a0,s5
    800062a6:	b39ff0ef          	jal	80005dde <consputc>
    800062aa:	b535                	j	800060d6 <printf+0x78>
    800062ac:	74a6                	ld	s1,104(sp)
    800062ae:	69e6                	ld	s3,88(sp)
    800062b0:	6a46                	ld	s4,80(sp)
    800062b2:	6aa6                	ld	s5,72(sp)
    800062b4:	6b06                	ld	s6,64(sp)
    800062b6:	7be2                	ld	s7,56(sp)
    800062b8:	7c42                	ld	s8,48(sp)
    800062ba:	7d02                	ld	s10,32(sp)
    800062bc:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800062be:	00002797          	auipc	a5,0x2
    800062c2:	7c67a783          	lw	a5,1990(a5) # 80008a84 <panicking>
    800062c6:	c38d                	beqz	a5,800062e8 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    800062c8:	4501                	li	a0,0
    800062ca:	70e6                	ld	ra,120(sp)
    800062cc:	7446                	ld	s0,112(sp)
    800062ce:	7906                	ld	s2,96(sp)
    800062d0:	6129                	addi	sp,sp,192
    800062d2:	8082                	ret
    800062d4:	74a6                	ld	s1,104(sp)
    800062d6:	69e6                	ld	s3,88(sp)
    800062d8:	6a46                	ld	s4,80(sp)
    800062da:	6aa6                	ld	s5,72(sp)
    800062dc:	6b06                	ld	s6,64(sp)
    800062de:	7be2                	ld	s7,56(sp)
    800062e0:	7c42                	ld	s8,48(sp)
    800062e2:	7d02                	ld	s10,32(sp)
    800062e4:	6de2                	ld	s11,24(sp)
    800062e6:	bfe1                	j	800062be <printf+0x260>
    release(&pr.lock);
    800062e8:	019cd517          	auipc	a0,0x19cd
    800062ec:	4d050513          	addi	a0,a0,1232 # 819d37b8 <pr>
    800062f0:	3ee000ef          	jal	800066de <release>
  return 0;
    800062f4:	bfd1                	j	800062c8 <printf+0x26a>
    if(c0 == 'd'){
    800062f6:	e37a8ee3          	beq	s5,s7,80006132 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800062fa:	f94a8713          	addi	a4,s5,-108
    800062fe:	00173713          	seqz	a4,a4
    80006302:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80006304:	4781                	li	a5,0
    80006306:	a00d                	j	80006328 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    80006308:	f94a8713          	addi	a4,s5,-108
    8000630c:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    80006310:	8656                	mv	a2,s5
    80006312:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80006314:	f9460793          	addi	a5,a2,-108
    80006318:	0017b793          	seqz	a5,a5
    8000631c:	8ff9                	and	a5,a5,a4
    8000631e:	f9c68593          	addi	a1,a3,-100
    80006322:	e199                	bnez	a1,80006328 <printf+0x2ca>
    80006324:	e20798e3          	bnez	a5,80006154 <printf+0xf6>
    } else if(c0 == 'u'){
    80006328:	e58a84e3          	beq	s5,s8,80006170 <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    8000632c:	f8b60593          	addi	a1,a2,-117
    80006330:	e199                	bnez	a1,80006336 <printf+0x2d8>
    80006332:	e4071ce3          	bnez	a4,8000618a <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80006336:	f8b68593          	addi	a1,a3,-117
    8000633a:	e199                	bnez	a1,80006340 <printf+0x2e2>
    8000633c:	e60795e3          	bnez	a5,800061a6 <printf+0x148>
    } else if(c0 == 'x'){
    80006340:	e9aa81e3          	beq	s5,s10,800061c2 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    80006344:	f8860613          	addi	a2,a2,-120
    80006348:	e219                	bnez	a2,8000634e <printf+0x2f0>
    8000634a:	e80719e3          	bnez	a4,800061dc <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000634e:	f8868693          	addi	a3,a3,-120
    80006352:	e299                	bnez	a3,80006358 <printf+0x2fa>
    80006354:	ea0791e3          	bnez	a5,800061f6 <printf+0x198>
    } else if(c0 == 'p'){
    80006358:	ebba8de3          	beq	s5,s11,80006212 <printf+0x1b4>
    } else if(c0 == 'c'){
    8000635c:	06300793          	li	a5,99
    80006360:	eefa8ce3          	beq	s5,a5,80006258 <printf+0x1fa>
    } else if(c0 == 's'){
    80006364:	07300793          	li	a5,115
    80006368:	f0fa82e3          	beq	s5,a5,8000626c <printf+0x20e>
    } else if(c0 == '%'){
    8000636c:	02500793          	li	a5,37
    80006370:	f2fa8ae3          	beq	s5,a5,800062a4 <printf+0x246>
    } else if(c0 == 0){
    80006374:	f60a80e3          	beqz	s5,800062d4 <printf+0x276>
      consputc('%');
    80006378:	02500513          	li	a0,37
    8000637c:	a63ff0ef          	jal	80005dde <consputc>
      consputc(c0);
    80006380:	8556                	mv	a0,s5
    80006382:	a5dff0ef          	jal	80005dde <consputc>
    80006386:	bb81                	j	800060d6 <printf+0x78>

0000000080006388 <panic>:

void
panic(char *s)
{
    80006388:	1101                	addi	sp,sp,-32
    8000638a:	ec06                	sd	ra,24(sp)
    8000638c:	e822                	sd	s0,16(sp)
    8000638e:	e426                	sd	s1,8(sp)
    80006390:	e04a                	sd	s2,0(sp)
    80006392:	1000                	addi	s0,sp,32
    80006394:	892a                	mv	s2,a0
  panicking = 1;
    80006396:	4485                	li	s1,1
    80006398:	00002797          	auipc	a5,0x2
    8000639c:	6e97a623          	sw	s1,1772(a5) # 80008a84 <panicking>
  printf("panic: ");
    800063a0:	00002517          	auipc	a0,0x2
    800063a4:	4d850513          	addi	a0,a0,1240 # 80008878 <etext+0x878>
    800063a8:	cb7ff0ef          	jal	8000605e <printf>
  printf("%s\n", s);
    800063ac:	85ca                	mv	a1,s2
    800063ae:	00002517          	auipc	a0,0x2
    800063b2:	4d250513          	addi	a0,a0,1234 # 80008880 <etext+0x880>
    800063b6:	ca9ff0ef          	jal	8000605e <printf>
  panicked = 1; // freeze uart output from other CPUs
    800063ba:	00002797          	auipc	a5,0x2
    800063be:	6c97a323          	sw	s1,1734(a5) # 80008a80 <panicked>
  for(;;)
    800063c2:	a001                	j	800063c2 <panic+0x3a>

00000000800063c4 <printfinit>:
    ;
}

void
printfinit(void)
{
    800063c4:	1141                	addi	sp,sp,-16
    800063c6:	e406                	sd	ra,8(sp)
    800063c8:	e022                	sd	s0,0(sp)
    800063ca:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    800063cc:	00002597          	auipc	a1,0x2
    800063d0:	4bc58593          	addi	a1,a1,1212 # 80008888 <etext+0x888>
    800063d4:	019cd517          	auipc	a0,0x19cd
    800063d8:	3e450513          	addi	a0,a0,996 # 819d37b8 <pr>
    800063dc:	1e4000ef          	jal	800065c0 <initlock>
}
    800063e0:	60a2                	ld	ra,8(sp)
    800063e2:	6402                	ld	s0,0(sp)
    800063e4:	0141                	addi	sp,sp,16
    800063e6:	8082                	ret

00000000800063e8 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    800063e8:	1141                	addi	sp,sp,-16
    800063ea:	e406                	sd	ra,8(sp)
    800063ec:	e022                	sd	s0,0(sp)
    800063ee:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800063f0:	100007b7          	lui	a5,0x10000
    800063f4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800063f8:	10000737          	lui	a4,0x10000
    800063fc:	f8000693          	li	a3,-128
    80006400:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80006404:	468d                	li	a3,3
    80006406:	10000637          	lui	a2,0x10000
    8000640a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000640e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006412:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80006416:	8732                	mv	a4,a2
    80006418:	461d                	li	a2,7
    8000641a:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000641e:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80006422:	00002597          	auipc	a1,0x2
    80006426:	46e58593          	addi	a1,a1,1134 # 80008890 <etext+0x890>
    8000642a:	019cd517          	auipc	a0,0x19cd
    8000642e:	3a650513          	addi	a0,a0,934 # 819d37d0 <tx_lock>
    80006432:	18e000ef          	jal	800065c0 <initlock>
}
    80006436:	60a2                	ld	ra,8(sp)
    80006438:	6402                	ld	s0,0(sp)
    8000643a:	0141                	addi	sp,sp,16
    8000643c:	8082                	ret

000000008000643e <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    8000643e:	715d                	addi	sp,sp,-80
    80006440:	e486                	sd	ra,72(sp)
    80006442:	e0a2                	sd	s0,64(sp)
    80006444:	fc26                	sd	s1,56(sp)
    80006446:	ec56                	sd	s5,24(sp)
    80006448:	0880                	addi	s0,sp,80
    8000644a:	8aaa                	mv	s5,a0
    8000644c:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    8000644e:	019cd517          	auipc	a0,0x19cd
    80006452:	38250513          	addi	a0,a0,898 # 819d37d0 <tx_lock>
    80006456:	1f4000ef          	jal	8000664a <acquire>

  int i = 0;
  while(i < n){ 
    8000645a:	06905063          	blez	s1,800064ba <uartwrite+0x7c>
    8000645e:	f84a                	sd	s2,48(sp)
    80006460:	f44e                	sd	s3,40(sp)
    80006462:	f052                	sd	s4,32(sp)
    80006464:	e85a                	sd	s6,16(sp)
    80006466:	e45e                	sd	s7,8(sp)
    80006468:	8a56                	mv	s4,s5
    8000646a:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    8000646c:	00002497          	auipc	s1,0x2
    80006470:	62048493          	addi	s1,s1,1568 # 80008a8c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80006474:	019cd997          	auipc	s3,0x19cd
    80006478:	35c98993          	addi	s3,s3,860 # 819d37d0 <tx_lock>
    8000647c:	00002917          	auipc	s2,0x2
    80006480:	60c90913          	addi	s2,s2,1548 # 80008a88 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80006484:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80006488:	4b05                	li	s6,1
    8000648a:	a005                	j	800064aa <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    8000648c:	85ce                	mv	a1,s3
    8000648e:	854a                	mv	a0,s2
    80006490:	fa1fa0ef          	jal	80001430 <sleep>
    while(tx_busy != 0){
    80006494:	409c                	lw	a5,0(s1)
    80006496:	fbfd                	bnez	a5,8000648c <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80006498:	000a4783          	lbu	a5,0(s4)
    8000649c:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800064a0:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800064a4:	0a05                	addi	s4,s4,1
    800064a6:	015a0563          	beq	s4,s5,800064b0 <uartwrite+0x72>
    while(tx_busy != 0){
    800064aa:	409c                	lw	a5,0(s1)
    800064ac:	f3e5                	bnez	a5,8000648c <uartwrite+0x4e>
    800064ae:	b7ed                	j	80006498 <uartwrite+0x5a>
    800064b0:	7942                	ld	s2,48(sp)
    800064b2:	79a2                	ld	s3,40(sp)
    800064b4:	7a02                	ld	s4,32(sp)
    800064b6:	6b42                	ld	s6,16(sp)
    800064b8:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    800064ba:	019cd517          	auipc	a0,0x19cd
    800064be:	31650513          	addi	a0,a0,790 # 819d37d0 <tx_lock>
    800064c2:	21c000ef          	jal	800066de <release>
}
    800064c6:	60a6                	ld	ra,72(sp)
    800064c8:	6406                	ld	s0,64(sp)
    800064ca:	74e2                	ld	s1,56(sp)
    800064cc:	6ae2                	ld	s5,24(sp)
    800064ce:	6161                	addi	sp,sp,80
    800064d0:	8082                	ret

00000000800064d2 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800064d2:	1101                	addi	sp,sp,-32
    800064d4:	ec06                	sd	ra,24(sp)
    800064d6:	e822                	sd	s0,16(sp)
    800064d8:	e426                	sd	s1,8(sp)
    800064da:	1000                	addi	s0,sp,32
    800064dc:	84aa                	mv	s1,a0
  if(panicking == 0)
    800064de:	00002797          	auipc	a5,0x2
    800064e2:	5a67a783          	lw	a5,1446(a5) # 80008a84 <panicking>
    800064e6:	cf95                	beqz	a5,80006522 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    800064e8:	00002797          	auipc	a5,0x2
    800064ec:	5987a783          	lw	a5,1432(a5) # 80008a80 <panicked>
    800064f0:	ef85                	bnez	a5,80006528 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800064f2:	10000737          	lui	a4,0x10000
    800064f6:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800064f8:	00074783          	lbu	a5,0(a4)
    800064fc:	0207f793          	andi	a5,a5,32
    80006500:	dfe5                	beqz	a5,800064f8 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80006502:	0ff4f513          	zext.b	a0,s1
    80006506:	100007b7          	lui	a5,0x10000
    8000650a:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    8000650e:	00002797          	auipc	a5,0x2
    80006512:	5767a783          	lw	a5,1398(a5) # 80008a84 <panicking>
    80006516:	cb91                	beqz	a5,8000652a <uartputc_sync+0x58>
    pop_off();
}
    80006518:	60e2                	ld	ra,24(sp)
    8000651a:	6442                	ld	s0,16(sp)
    8000651c:	64a2                	ld	s1,8(sp)
    8000651e:	6105                	addi	sp,sp,32
    80006520:	8082                	ret
    push_off();
    80006522:	0e4000ef          	jal	80006606 <push_off>
    80006526:	b7c9                	j	800064e8 <uartputc_sync+0x16>
    for(;;)
    80006528:	a001                	j	80006528 <uartputc_sync+0x56>
    pop_off();
    8000652a:	164000ef          	jal	8000668e <pop_off>
}
    8000652e:	b7ed                	j	80006518 <uartputc_sync+0x46>

0000000080006530 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006530:	1141                	addi	sp,sp,-16
    80006532:	e406                	sd	ra,8(sp)
    80006534:	e022                	sd	s0,0(sp)
    80006536:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80006538:	100007b7          	lui	a5,0x10000
    8000653c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006540:	8b85                	andi	a5,a5,1
    80006542:	cb89                	beqz	a5,80006554 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006544:	100007b7          	lui	a5,0x10000
    80006548:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000654c:	60a2                	ld	ra,8(sp)
    8000654e:	6402                	ld	s0,0(sp)
    80006550:	0141                	addi	sp,sp,16
    80006552:	8082                	ret
    return -1;
    80006554:	557d                	li	a0,-1
    80006556:	bfdd                	j	8000654c <uartgetc+0x1c>

0000000080006558 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80006558:	1101                	addi	sp,sp,-32
    8000655a:	ec06                	sd	ra,24(sp)
    8000655c:	e822                	sd	s0,16(sp)
    8000655e:	e426                	sd	s1,8(sp)
    80006560:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80006562:	100007b7          	lui	a5,0x10000
    80006566:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    8000656a:	019cd517          	auipc	a0,0x19cd
    8000656e:	26650513          	addi	a0,a0,614 # 819d37d0 <tx_lock>
    80006572:	0d8000ef          	jal	8000664a <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80006576:	100007b7          	lui	a5,0x10000
    8000657a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000657e:	0207f793          	andi	a5,a5,32
    80006582:	ef99                	bnez	a5,800065a0 <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80006584:	019cd517          	auipc	a0,0x19cd
    80006588:	24c50513          	addi	a0,a0,588 # 819d37d0 <tx_lock>
    8000658c:	152000ef          	jal	800066de <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006590:	54fd                	li	s1,-1
    int c = uartgetc();
    80006592:	f9fff0ef          	jal	80006530 <uartgetc>
    if(c == -1)
    80006596:	02950063          	beq	a0,s1,800065b6 <uartintr+0x5e>
      break;
    consoleintr(c);
    8000659a:	877ff0ef          	jal	80005e10 <consoleintr>
  while(1){
    8000659e:	bfd5                	j	80006592 <uartintr+0x3a>
    tx_busy = 0;
    800065a0:	00002797          	auipc	a5,0x2
    800065a4:	4e07a623          	sw	zero,1260(a5) # 80008a8c <tx_busy>
    wakeup(&tx_chan);
    800065a8:	00002517          	auipc	a0,0x2
    800065ac:	4e050513          	addi	a0,a0,1248 # 80008a88 <tx_chan>
    800065b0:	ecdfa0ef          	jal	8000147c <wakeup>
    800065b4:	bfc1                	j	80006584 <uartintr+0x2c>
  }
}
    800065b6:	60e2                	ld	ra,24(sp)
    800065b8:	6442                	ld	s0,16(sp)
    800065ba:	64a2                	ld	s1,8(sp)
    800065bc:	6105                	addi	sp,sp,32
    800065be:	8082                	ret

00000000800065c0 <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    800065c0:	1141                	addi	sp,sp,-16
    800065c2:	e406                	sd	ra,8(sp)
    800065c4:	e022                	sd	s0,0(sp)
    800065c6:	0800                	addi	s0,sp,16
  lk->name = name;
    800065c8:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800065ca:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800065ce:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    800065d2:	60a2                	ld	ra,8(sp)
    800065d4:	6402                	ld	s0,0(sp)
    800065d6:	0141                	addi	sp,sp,16
    800065d8:	8082                	ret

00000000800065da <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800065da:	411c                	lw	a5,0(a0)
    800065dc:	e399                	bnez	a5,800065e2 <holding+0x8>
    800065de:	4501                	li	a0,0
  return r;
}
    800065e0:	8082                	ret
{
    800065e2:	1101                	addi	sp,sp,-32
    800065e4:	ec06                	sd	ra,24(sp)
    800065e6:	e822                	sd	s0,16(sp)
    800065e8:	e426                	sd	s1,8(sp)
    800065ea:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800065ec:	691c                	ld	a5,16(a0)
    800065ee:	84be                	mv	s1,a5
    800065f0:	ff8fa0ef          	jal	80000de8 <mycpu>
    800065f4:	40a48533          	sub	a0,s1,a0
    800065f8:	00153513          	seqz	a0,a0
}
    800065fc:	60e2                	ld	ra,24(sp)
    800065fe:	6442                	ld	s0,16(sp)
    80006600:	64a2                	ld	s1,8(sp)
    80006602:	6105                	addi	sp,sp,32
    80006604:	8082                	ret

0000000080006606 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006606:	1101                	addi	sp,sp,-32
    80006608:	ec06                	sd	ra,24(sp)
    8000660a:	e822                	sd	s0,16(sp)
    8000660c:	e426                	sd	s1,8(sp)
    8000660e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006610:	100027f3          	csrr	a5,sstatus
    80006614:	84be                	mv	s1,a5
    80006616:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000661a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000661c:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80006620:	fc8fa0ef          	jal	80000de8 <mycpu>
    80006624:	5d3c                	lw	a5,120(a0)
    80006626:	cb99                	beqz	a5,8000663c <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006628:	fc0fa0ef          	jal	80000de8 <mycpu>
    8000662c:	5d3c                	lw	a5,120(a0)
    8000662e:	2785                	addiw	a5,a5,1
    80006630:	dd3c                	sw	a5,120(a0)
}
    80006632:	60e2                	ld	ra,24(sp)
    80006634:	6442                	ld	s0,16(sp)
    80006636:	64a2                	ld	s1,8(sp)
    80006638:	6105                	addi	sp,sp,32
    8000663a:	8082                	ret
    mycpu()->intena = old;
    8000663c:	facfa0ef          	jal	80000de8 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006640:	0014d793          	srli	a5,s1,0x1
    80006644:	8b85                	andi	a5,a5,1
    80006646:	dd7c                	sw	a5,124(a0)
    80006648:	b7c5                	j	80006628 <push_off+0x22>

000000008000664a <acquire>:
{
    8000664a:	1101                	addi	sp,sp,-32
    8000664c:	ec06                	sd	ra,24(sp)
    8000664e:	e822                	sd	s0,16(sp)
    80006650:	e426                	sd	s1,8(sp)
    80006652:	1000                	addi	s0,sp,32
    80006654:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006656:	fb1ff0ef          	jal	80006606 <push_off>
  if(holding(lk))
    8000665a:	8526                	mv	a0,s1
    8000665c:	f7fff0ef          	jal	800065da <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006660:	4705                	li	a4,1
  if(holding(lk))
    80006662:	e105                	bnez	a0,80006682 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80006664:	87ba                	mv	a5,a4
    80006666:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    8000666a:	2781                	sext.w	a5,a5
    8000666c:	ffe5                	bnez	a5,80006664 <acquire+0x1a>
  __sync_synchronize();
    8000666e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80006672:	f76fa0ef          	jal	80000de8 <mycpu>
    80006676:	e888                	sd	a0,16(s1)
}
    80006678:	60e2                	ld	ra,24(sp)
    8000667a:	6442                	ld	s0,16(sp)
    8000667c:	64a2                	ld	s1,8(sp)
    8000667e:	6105                	addi	sp,sp,32
    80006680:	8082                	ret
    panic("acquire");
    80006682:	00002517          	auipc	a0,0x2
    80006686:	21650513          	addi	a0,a0,534 # 80008898 <etext+0x898>
    8000668a:	cffff0ef          	jal	80006388 <panic>

000000008000668e <pop_off>:

void
pop_off(void)
{
    8000668e:	1141                	addi	sp,sp,-16
    80006690:	e406                	sd	ra,8(sp)
    80006692:	e022                	sd	s0,0(sp)
    80006694:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006696:	f52fa0ef          	jal	80000de8 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000669a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000669e:	8b89                	andi	a5,a5,2
  if(intr_get())
    800066a0:	e39d                	bnez	a5,800066c6 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800066a2:	5d3c                	lw	a5,120(a0)
    800066a4:	02f05763          	blez	a5,800066d2 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    800066a8:	37fd                	addiw	a5,a5,-1
    800066aa:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800066ac:	eb89                	bnez	a5,800066be <pop_off+0x30>
    800066ae:	5d7c                	lw	a5,124(a0)
    800066b0:	c799                	beqz	a5,800066be <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800066b2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800066b6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066ba:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800066be:	60a2                	ld	ra,8(sp)
    800066c0:	6402                	ld	s0,0(sp)
    800066c2:	0141                	addi	sp,sp,16
    800066c4:	8082                	ret
    panic("pop_off - interruptible");
    800066c6:	00002517          	auipc	a0,0x2
    800066ca:	1da50513          	addi	a0,a0,474 # 800088a0 <etext+0x8a0>
    800066ce:	cbbff0ef          	jal	80006388 <panic>
    panic("pop_off");
    800066d2:	00002517          	auipc	a0,0x2
    800066d6:	1e650513          	addi	a0,a0,486 # 800088b8 <etext+0x8b8>
    800066da:	cafff0ef          	jal	80006388 <panic>

00000000800066de <release>:
{
    800066de:	1101                	addi	sp,sp,-32
    800066e0:	ec06                	sd	ra,24(sp)
    800066e2:	e822                	sd	s0,16(sp)
    800066e4:	e426                	sd	s1,8(sp)
    800066e6:	1000                	addi	s0,sp,32
    800066e8:	84aa                	mv	s1,a0
  if(!holding(lk))
    800066ea:	ef1ff0ef          	jal	800065da <holding>
    800066ee:	c105                	beqz	a0,8000670e <release+0x30>
  lk->cpu = 0;
    800066f0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800066f4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800066f8:	0310000f          	fence	rw,w
    800066fc:	0004a023          	sw	zero,0(s1)
  pop_off();
    80006700:	f8fff0ef          	jal	8000668e <pop_off>
}
    80006704:	60e2                	ld	ra,24(sp)
    80006706:	6442                	ld	s0,16(sp)
    80006708:	64a2                	ld	s1,8(sp)
    8000670a:	6105                	addi	sp,sp,32
    8000670c:	8082                	ret
    panic("release");
    8000670e:	00002517          	auipc	a0,0x2
    80006712:	1b250513          	addi	a0,a0,434 # 800088c0 <etext+0x8c0>
    80006716:	c73ff0ef          	jal	80006388 <panic>

000000008000671a <atomic_read4>:

// Read a shared 32-bit value without holding a lock
int
atomic_read4(int *addr) {
    8000671a:	1141                	addi	sp,sp,-16
    8000671c:	e406                	sd	ra,8(sp)
    8000671e:	e022                	sd	s0,0(sp)
    80006720:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    80006722:	0330000f          	fence	rw,rw
    80006726:	4108                	lw	a0,0(a0)
    80006728:	0230000f          	fence	r,rw
  return val;
}
    8000672c:	2501                	sext.w	a0,a0
    8000672e:	60a2                	ld	ra,8(sp)
    80006730:	6402                	ld	s0,0(sp)
    80006732:	0141                	addi	sp,sp,16
    80006734:	8082                	ret
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
