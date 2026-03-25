
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00025117          	auipc	sp,0x25
    80000004:	d6010113          	addi	sp,sp,-672 # 80024d60 <stack0>
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
    80000016:	460050ef          	jal	80005476 <start>

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
    80000028:	0002d797          	auipc	a5,0x2d
    8000002c:	e1078793          	addi	a5,a5,-496 # 8002ce38 <end>
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
    80000052:	00008917          	auipc	s2,0x8
    80000056:	8de90913          	addi	s2,s2,-1826 # 80007930 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	69d050ef          	jal	80005ef8 <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	721050ef          	jal	80005f8c <release>
}
    80000070:	60e2                	ld	ra,24(sp)
    80000072:	6442                	ld	s0,16(sp)
    80000074:	64a2                	ld	s1,8(sp)
    80000076:	6902                	ld	s2,0(sp)
    80000078:	6105                	addi	sp,sp,32
    8000007a:	8082                	ret
    panic("kfree");
    8000007c:	00007517          	auipc	a0,0x7
    80000080:	f8450513          	addi	a0,a0,-124 # 80007000 <etext>
    80000084:	3b3050ef          	jal	80005c36 <panic>

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
    800000d8:	00007597          	auipc	a1,0x7
    800000dc:	f3858593          	addi	a1,a1,-200 # 80007010 <etext+0x10>
    800000e0:	00008517          	auipc	a0,0x8
    800000e4:	85050513          	addi	a0,a0,-1968 # 80007930 <kmem>
    800000e8:	587050ef          	jal	80005e6e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	0002d517          	auipc	a0,0x2d
    800000f4:	d4850513          	addi	a0,a0,-696 # 8002ce38 <end>
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
    8000010e:	00008517          	auipc	a0,0x8
    80000112:	82250513          	addi	a0,a0,-2014 # 80007930 <kmem>
    80000116:	5e3050ef          	jal	80005ef8 <acquire>
  r = kmem.freelist;
    8000011a:	00008497          	auipc	s1,0x8
    8000011e:	82e4b483          	ld	s1,-2002(s1) # 80007948 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	00008717          	auipc	a4,0x8
    8000012a:	82f73123          	sd	a5,-2014(a4) # 80007948 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	00008517          	auipc	a0,0x8
    80000132:	80250513          	addi	a0,a0,-2046 # 80007930 <kmem>
    80000136:	657050ef          	jal	80005f8c <release>

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
    80000150:	00007517          	auipc	a0,0x7
    80000154:	7e050513          	addi	a0,a0,2016 # 80007930 <kmem>
    80000158:	635050ef          	jal	80005f8c <release>
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
    80000314:	1141                	addi	sp,sp,-16
    80000316:	e406                	sd	ra,8(sp)
    80000318:	e022                	sd	s0,0(sp)
    8000031a:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000031c:	5ad000ef          	jal	800010c8 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000320:	00007717          	auipc	a4,0x7
    80000324:	5e070713          	addi	a4,a4,1504 # 80007900 <started>
  if(cpuid() == 0){
    80000328:	c51d                	beqz	a0,80000356 <main+0x42>
    while(started == 0)
    8000032a:	431c                	lw	a5,0(a4)
    8000032c:	2781                	sext.w	a5,a5
    8000032e:	dff5                	beqz	a5,8000032a <main+0x16>
      ;
    __sync_synchronize();
    80000330:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000334:	595000ef          	jal	800010c8 <cpuid>
    80000338:	85aa                	mv	a1,a0
    8000033a:	00007517          	auipc	a0,0x7
    8000033e:	cfe50513          	addi	a0,a0,-770 # 80007038 <etext+0x38>
    80000342:	5ca050ef          	jal	8000590c <printf>
    kvminithart();    // turn on paging
    80000346:	080000ef          	jal	800003c6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034a:	15d010ef          	jal	80001ca6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034e:	36b040ef          	jal	80004eb8 <plicinithart>
  }

  scheduler();        
    80000352:	256010ef          	jal	800015a8 <scheduler>
    consoleinit();
    80000356:	4dc050ef          	jal	80005832 <consoleinit>
    printfinit();
    8000035a:	119050ef          	jal	80005c72 <printfinit>
    printf("\n");
    8000035e:	00007517          	auipc	a0,0x7
    80000362:	cba50513          	addi	a0,a0,-838 # 80007018 <etext+0x18>
    80000366:	5a6050ef          	jal	8000590c <printf>
    printf("xv6 kernel is booting\n");
    8000036a:	00007517          	auipc	a0,0x7
    8000036e:	cb650513          	addi	a0,a0,-842 # 80007020 <etext+0x20>
    80000372:	59a050ef          	jal	8000590c <printf>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	58e050ef          	jal	8000590c <printf>
    kinit();         // physical page allocator
    80000382:	d4fff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    80000386:	2cc000ef          	jal	80000652 <kvminit>
    kvminithart();   // turn on paging
    8000038a:	03c000ef          	jal	800003c6 <kvminithart>
    procinit();      // process table
    8000038e:	485000ef          	jal	80001012 <procinit>
    trapinit();      // trap vectors
    80000392:	0f1010ef          	jal	80001c82 <trapinit>
    trapinithart();  // install kernel trap vector
    80000396:	111010ef          	jal	80001ca6 <trapinithart>
    plicinit();      // set up interrupt controller
    8000039a:	305040ef          	jal	80004e9e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039e:	31b040ef          	jal	80004eb8 <plicinithart>
    binit();         // buffer cache
    800003a2:	19a020ef          	jal	8000253c <binit>
    iinit();         // inode table
    800003a6:	6ec020ef          	jal	80002a92 <iinit>
    fileinit();      // file table
    800003aa:	618030ef          	jal	800039c2 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	3fb040ef          	jal	80004fa8 <virtio_disk_init>
    userinit();      // first user process
    800003b2:	020010ef          	jal	800013d2 <userinit>
    __sync_synchronize();
    800003b6:	0330000f          	fence	rw,rw
    started = 1;
    800003ba:	4785                	li	a5,1
    800003bc:	00007717          	auipc	a4,0x7
    800003c0:	54f72223          	sw	a5,1348(a4) # 80007900 <started>
    800003c4:	b779                	j	80000352 <main+0x3e>

00000000800003c6 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    800003c6:	1141                	addi	sp,sp,-16
    800003c8:	e406                	sd	ra,8(sp)
    800003ca:	e022                	sd	s0,0(sp)
    800003cc:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003ce:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003d2:	00007797          	auipc	a5,0x7
    800003d6:	5367b783          	ld	a5,1334(a5) # 80007908 <kernel_pagetable>
    800003da:	83b1                	srli	a5,a5,0xc
    800003dc:	577d                	li	a4,-1
    800003de:	177e                	slli	a4,a4,0x3f
    800003e0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003e2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003e6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003ea:	60a2                	ld	ra,8(sp)
    800003ec:	6402                	ld	s0,0(sp)
    800003ee:	0141                	addi	sp,sp,16
    800003f0:	8082                	ret

00000000800003f2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003f2:	7139                	addi	sp,sp,-64
    800003f4:	fc06                	sd	ra,56(sp)
    800003f6:	f822                	sd	s0,48(sp)
    800003f8:	f426                	sd	s1,40(sp)
    800003fa:	f04a                	sd	s2,32(sp)
    800003fc:	ec4e                	sd	s3,24(sp)
    800003fe:	e852                	sd	s4,16(sp)
    80000400:	e456                	sd	s5,8(sp)
    80000402:	e05a                	sd	s6,0(sp)
    80000404:	0080                	addi	s0,sp,64
    80000406:	84aa                	mv	s1,a0
    80000408:	89ae                	mv	s3,a1
    8000040a:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    8000040c:	57fd                	li	a5,-1
    8000040e:	83e9                	srli	a5,a5,0x1a
    80000410:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000412:	4ab1                	li	s5,12
  if(va >= MAXVA)
    80000414:	04b7e263          	bltu	a5,a1,80000458 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    80000418:	0149d933          	srl	s2,s3,s4
    8000041c:	1ff97913          	andi	s2,s2,511
    80000420:	090e                	slli	s2,s2,0x3
    80000422:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000424:	00093483          	ld	s1,0(s2)
    80000428:	0014f793          	andi	a5,s1,1
    8000042c:	cf85                	beqz	a5,80000464 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000042e:	80a9                	srli	s1,s1,0xa
    80000430:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000432:	3a5d                	addiw	s4,s4,-9
    80000434:	ff5a12e3          	bne	s4,s5,80000418 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000438:	00c9d513          	srli	a0,s3,0xc
    8000043c:	1ff57513          	andi	a0,a0,511
    80000440:	050e                	slli	a0,a0,0x3
    80000442:	9526                	add	a0,a0,s1
}
    80000444:	70e2                	ld	ra,56(sp)
    80000446:	7442                	ld	s0,48(sp)
    80000448:	74a2                	ld	s1,40(sp)
    8000044a:	7902                	ld	s2,32(sp)
    8000044c:	69e2                	ld	s3,24(sp)
    8000044e:	6a42                	ld	s4,16(sp)
    80000450:	6aa2                	ld	s5,8(sp)
    80000452:	6b02                	ld	s6,0(sp)
    80000454:	6121                	addi	sp,sp,64
    80000456:	8082                	ret
    panic("walk");
    80000458:	00007517          	auipc	a0,0x7
    8000045c:	bf850513          	addi	a0,a0,-1032 # 80007050 <etext+0x50>
    80000460:	7d6050ef          	jal	80005c36 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000464:	020b0263          	beqz	s6,80000488 <walk+0x96>
    80000468:	c9dff0ef          	jal	80000104 <kalloc>
    8000046c:	84aa                	mv	s1,a0
    8000046e:	d979                	beqz	a0,80000444 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000470:	6605                	lui	a2,0x1
    80000472:	4581                	li	a1,0
    80000474:	cebff0ef          	jal	8000015e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000478:	00c4d793          	srli	a5,s1,0xc
    8000047c:	07aa                	slli	a5,a5,0xa
    8000047e:	0017e793          	ori	a5,a5,1
    80000482:	00f93023          	sd	a5,0(s2)
    80000486:	b775                	j	80000432 <walk+0x40>
        return 0;
    80000488:	4501                	li	a0,0
    8000048a:	bf6d                	j	80000444 <walk+0x52>

000000008000048c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000048c:	57fd                	li	a5,-1
    8000048e:	83e9                	srli	a5,a5,0x1a
    80000490:	00b7f463          	bgeu	a5,a1,80000498 <walkaddr+0xc>
    return 0;
    80000494:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000496:	8082                	ret
{
    80000498:	1141                	addi	sp,sp,-16
    8000049a:	e406                	sd	ra,8(sp)
    8000049c:	e022                	sd	s0,0(sp)
    8000049e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004a0:	4601                	li	a2,0
    800004a2:	f51ff0ef          	jal	800003f2 <walk>
  if(pte == 0)
    800004a6:	c901                	beqz	a0,800004b6 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    800004a8:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004aa:	0117f693          	andi	a3,a5,17
    800004ae:	4745                	li	a4,17
    return 0;
    800004b0:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004b2:	00e68663          	beq	a3,a4,800004be <walkaddr+0x32>
}
    800004b6:	60a2                	ld	ra,8(sp)
    800004b8:	6402                	ld	s0,0(sp)
    800004ba:	0141                	addi	sp,sp,16
    800004bc:	8082                	ret
  pa = PTE2PA(*pte);
    800004be:	83a9                	srli	a5,a5,0xa
    800004c0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004c4:	bfcd                	j	800004b6 <walkaddr+0x2a>

00000000800004c6 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004c6:	715d                	addi	sp,sp,-80
    800004c8:	e486                	sd	ra,72(sp)
    800004ca:	e0a2                	sd	s0,64(sp)
    800004cc:	fc26                	sd	s1,56(sp)
    800004ce:	f84a                	sd	s2,48(sp)
    800004d0:	f44e                	sd	s3,40(sp)
    800004d2:	f052                	sd	s4,32(sp)
    800004d4:	ec56                	sd	s5,24(sp)
    800004d6:	e85a                	sd	s6,16(sp)
    800004d8:	e45e                	sd	s7,8(sp)
    800004da:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004dc:	03459793          	slli	a5,a1,0x34
    800004e0:	eba1                	bnez	a5,80000530 <mappages+0x6a>
    800004e2:	8a2a                	mv	s4,a0
    800004e4:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004e6:	03461793          	slli	a5,a2,0x34
    800004ea:	eba9                	bnez	a5,8000053c <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    800004ec:	ce31                	beqz	a2,80000548 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ee:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    800004f2:	80060613          	addi	a2,a2,-2048
    800004f6:	00b60933          	add	s2,a2,a1
  a = va;
    800004fa:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004fc:	4b05                	li	s6,1
    800004fe:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000502:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    80000504:	865a                	mv	a2,s6
    80000506:	85a6                	mv	a1,s1
    80000508:	8552                	mv	a0,s4
    8000050a:	ee9ff0ef          	jal	800003f2 <walk>
    8000050e:	c929                	beqz	a0,80000560 <mappages+0x9a>
    if(*pte & PTE_V)
    80000510:	611c                	ld	a5,0(a0)
    80000512:	8b85                	andi	a5,a5,1
    80000514:	e3a1                	bnez	a5,80000554 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000516:	013487b3          	add	a5,s1,s3
    8000051a:	83b1                	srli	a5,a5,0xc
    8000051c:	07aa                	slli	a5,a5,0xa
    8000051e:	0157e7b3          	or	a5,a5,s5
    80000522:	0017e793          	ori	a5,a5,1
    80000526:	e11c                	sd	a5,0(a0)
    if(a == last)
    80000528:	05248863          	beq	s1,s2,80000578 <mappages+0xb2>
    a += PGSIZE;
    8000052c:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000052e:	bfd9                	j	80000504 <mappages+0x3e>
    panic("mappages: va not aligned");
    80000530:	00007517          	auipc	a0,0x7
    80000534:	b2850513          	addi	a0,a0,-1240 # 80007058 <etext+0x58>
    80000538:	6fe050ef          	jal	80005c36 <panic>
    panic("mappages: size not aligned");
    8000053c:	00007517          	auipc	a0,0x7
    80000540:	b3c50513          	addi	a0,a0,-1220 # 80007078 <etext+0x78>
    80000544:	6f2050ef          	jal	80005c36 <panic>
    panic("mappages: size");
    80000548:	00007517          	auipc	a0,0x7
    8000054c:	b5050513          	addi	a0,a0,-1200 # 80007098 <etext+0x98>
    80000550:	6e6050ef          	jal	80005c36 <panic>
      panic("mappages: remap");
    80000554:	00007517          	auipc	a0,0x7
    80000558:	b5450513          	addi	a0,a0,-1196 # 800070a8 <etext+0xa8>
    8000055c:	6da050ef          	jal	80005c36 <panic>
      return -1;
    80000560:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000562:	60a6                	ld	ra,72(sp)
    80000564:	6406                	ld	s0,64(sp)
    80000566:	74e2                	ld	s1,56(sp)
    80000568:	7942                	ld	s2,48(sp)
    8000056a:	79a2                	ld	s3,40(sp)
    8000056c:	7a02                	ld	s4,32(sp)
    8000056e:	6ae2                	ld	s5,24(sp)
    80000570:	6b42                	ld	s6,16(sp)
    80000572:	6ba2                	ld	s7,8(sp)
    80000574:	6161                	addi	sp,sp,80
    80000576:	8082                	ret
  return 0;
    80000578:	4501                	li	a0,0
    8000057a:	b7e5                	j	80000562 <mappages+0x9c>

000000008000057c <kvmmap>:
{
    8000057c:	1141                	addi	sp,sp,-16
    8000057e:	e406                	sd	ra,8(sp)
    80000580:	e022                	sd	s0,0(sp)
    80000582:	0800                	addi	s0,sp,16
    80000584:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000586:	86b2                	mv	a3,a2
    80000588:	863e                	mv	a2,a5
    8000058a:	f3dff0ef          	jal	800004c6 <mappages>
    8000058e:	e509                	bnez	a0,80000598 <kvmmap+0x1c>
}
    80000590:	60a2                	ld	ra,8(sp)
    80000592:	6402                	ld	s0,0(sp)
    80000594:	0141                	addi	sp,sp,16
    80000596:	8082                	ret
    panic("kvmmap");
    80000598:	00007517          	auipc	a0,0x7
    8000059c:	b2050513          	addi	a0,a0,-1248 # 800070b8 <etext+0xb8>
    800005a0:	696050ef          	jal	80005c36 <panic>

00000000800005a4 <kvmmake>:
{
    800005a4:	1101                	addi	sp,sp,-32
    800005a6:	ec06                	sd	ra,24(sp)
    800005a8:	e822                	sd	s0,16(sp)
    800005aa:	e426                	sd	s1,8(sp)
    800005ac:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005ae:	b57ff0ef          	jal	80000104 <kalloc>
    800005b2:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005b4:	6605                	lui	a2,0x1
    800005b6:	4581                	li	a1,0
    800005b8:	ba7ff0ef          	jal	8000015e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005bc:	4719                	li	a4,6
    800005be:	6685                	lui	a3,0x1
    800005c0:	10000637          	lui	a2,0x10000
    800005c4:	85b2                	mv	a1,a2
    800005c6:	8526                	mv	a0,s1
    800005c8:	fb5ff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005cc:	4719                	li	a4,6
    800005ce:	6685                	lui	a3,0x1
    800005d0:	10001637          	lui	a2,0x10001
    800005d4:	85b2                	mv	a1,a2
    800005d6:	8526                	mv	a0,s1
    800005d8:	fa5ff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005dc:	4719                	li	a4,6
    800005de:	040006b7          	lui	a3,0x4000
    800005e2:	0c000637          	lui	a2,0xc000
    800005e6:	85b2                	mv	a1,a2
    800005e8:	8526                	mv	a0,s1
    800005ea:	f93ff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ee:	4729                	li	a4,10
    800005f0:	80007697          	auipc	a3,0x80007
    800005f4:	a1068693          	addi	a3,a3,-1520 # 7000 <_entry-0x7fff9000>
    800005f8:	4605                	li	a2,1
    800005fa:	067e                	slli	a2,a2,0x1f
    800005fc:	85b2                	mv	a1,a2
    800005fe:	8526                	mv	a0,s1
    80000600:	f7dff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000604:	4719                	li	a4,6
    80000606:	00007697          	auipc	a3,0x7
    8000060a:	9fa68693          	addi	a3,a3,-1542 # 80007000 <etext>
    8000060e:	47c5                	li	a5,17
    80000610:	07ee                	slli	a5,a5,0x1b
    80000612:	40d786b3          	sub	a3,a5,a3
    80000616:	00007617          	auipc	a2,0x7
    8000061a:	9ea60613          	addi	a2,a2,-1558 # 80007000 <etext>
    8000061e:	85b2                	mv	a1,a2
    80000620:	8526                	mv	a0,s1
    80000622:	f5bff0ef          	jal	8000057c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000626:	4729                	li	a4,10
    80000628:	6685                	lui	a3,0x1
    8000062a:	00006617          	auipc	a2,0x6
    8000062e:	9d660613          	addi	a2,a2,-1578 # 80006000 <_trampoline>
    80000632:	040005b7          	lui	a1,0x4000
    80000636:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000638:	05b2                	slli	a1,a1,0xc
    8000063a:	8526                	mv	a0,s1
    8000063c:	f41ff0ef          	jal	8000057c <kvmmap>
  proc_mapstacks(kpgtbl);
    80000640:	8526                	mv	a0,s1
    80000642:	12d000ef          	jal	80000f6e <proc_mapstacks>
}
    80000646:	8526                	mv	a0,s1
    80000648:	60e2                	ld	ra,24(sp)
    8000064a:	6442                	ld	s0,16(sp)
    8000064c:	64a2                	ld	s1,8(sp)
    8000064e:	6105                	addi	sp,sp,32
    80000650:	8082                	ret

0000000080000652 <kvminit>:
{
    80000652:	1141                	addi	sp,sp,-16
    80000654:	e406                	sd	ra,8(sp)
    80000656:	e022                	sd	s0,0(sp)
    80000658:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000065a:	f4bff0ef          	jal	800005a4 <kvmmake>
    8000065e:	00007797          	auipc	a5,0x7
    80000662:	2aa7b523          	sd	a0,682(a5) # 80007908 <kernel_pagetable>
}
    80000666:	60a2                	ld	ra,8(sp)
    80000668:	6402                	ld	s0,0(sp)
    8000066a:	0141                	addi	sp,sp,16
    8000066c:	8082                	ret

000000008000066e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000066e:	1101                	addi	sp,sp,-32
    80000670:	ec06                	sd	ra,24(sp)
    80000672:	e822                	sd	s0,16(sp)
    80000674:	e426                	sd	s1,8(sp)
    80000676:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000678:	a8dff0ef          	jal	80000104 <kalloc>
    8000067c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000067e:	c509                	beqz	a0,80000688 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000680:	6605                	lui	a2,0x1
    80000682:	4581                	li	a1,0
    80000684:	adbff0ef          	jal	8000015e <memset>
  return pagetable;
}
    80000688:	8526                	mv	a0,s1
    8000068a:	60e2                	ld	ra,24(sp)
    8000068c:	6442                	ld	s0,16(sp)
    8000068e:	64a2                	ld	s1,8(sp)
    80000690:	6105                	addi	sp,sp,32
    80000692:	8082                	ret

0000000080000694 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000694:	7139                	addi	sp,sp,-64
    80000696:	fc06                	sd	ra,56(sp)
    80000698:	f822                	sd	s0,48(sp)
    8000069a:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    8000069c:	03459793          	slli	a5,a1,0x34
    800006a0:	e38d                	bnez	a5,800006c2 <uvmunmap+0x2e>
    800006a2:	f04a                	sd	s2,32(sp)
    800006a4:	ec4e                	sd	s3,24(sp)
    800006a6:	e852                	sd	s4,16(sp)
    800006a8:	e456                	sd	s5,8(sp)
    800006aa:	e05a                	sd	s6,0(sp)
    800006ac:	8a2a                	mv	s4,a0
    800006ae:	892e                	mv	s2,a1
    800006b0:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006b2:	0632                	slli	a2,a2,0xc
    800006b4:	00b609b3          	add	s3,a2,a1
    800006b8:	6b05                	lui	s6,0x1
    800006ba:	0535f963          	bgeu	a1,s3,8000070c <uvmunmap+0x78>
    800006be:	f426                	sd	s1,40(sp)
    800006c0:	a015                	j	800006e4 <uvmunmap+0x50>
    800006c2:	f426                	sd	s1,40(sp)
    800006c4:	f04a                	sd	s2,32(sp)
    800006c6:	ec4e                	sd	s3,24(sp)
    800006c8:	e852                	sd	s4,16(sp)
    800006ca:	e456                	sd	s5,8(sp)
    800006cc:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    800006ce:	00007517          	auipc	a0,0x7
    800006d2:	9f250513          	addi	a0,a0,-1550 # 800070c0 <etext+0xc0>
    800006d6:	560050ef          	jal	80005c36 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006da:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800006de:	995a                	add	s2,s2,s6
    800006e0:	03397563          	bgeu	s2,s3,8000070a <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006e4:	4601                	li	a2,0
    800006e6:	85ca                	mv	a1,s2
    800006e8:	8552                	mv	a0,s4
    800006ea:	d09ff0ef          	jal	800003f2 <walk>
    800006ee:	84aa                	mv	s1,a0
    800006f0:	d57d                	beqz	a0,800006de <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006f2:	611c                	ld	a5,0(a0)
    800006f4:	0017f713          	andi	a4,a5,1
    800006f8:	d37d                	beqz	a4,800006de <uvmunmap+0x4a>
    if(do_free){
    800006fa:	fe0a80e3          	beqz	s5,800006da <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    800006fe:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000700:	00c79513          	slli	a0,a5,0xc
    80000704:	919ff0ef          	jal	8000001c <kfree>
    80000708:	bfc9                	j	800006da <uvmunmap+0x46>
    8000070a:	74a2                	ld	s1,40(sp)
    8000070c:	7902                	ld	s2,32(sp)
    8000070e:	69e2                	ld	s3,24(sp)
    80000710:	6a42                	ld	s4,16(sp)
    80000712:	6aa2                	ld	s5,8(sp)
    80000714:	6b02                	ld	s6,0(sp)
  }
}
    80000716:	70e2                	ld	ra,56(sp)
    80000718:	7442                	ld	s0,48(sp)
    8000071a:	6121                	addi	sp,sp,64
    8000071c:	8082                	ret

000000008000071e <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000071e:	1101                	addi	sp,sp,-32
    80000720:	ec06                	sd	ra,24(sp)
    80000722:	e822                	sd	s0,16(sp)
    80000724:	e426                	sd	s1,8(sp)
    80000726:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000728:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    8000072a:	00b67d63          	bgeu	a2,a1,80000744 <uvmdealloc+0x26>
    8000072e:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000730:	6785                	lui	a5,0x1
    80000732:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000734:	00f60733          	add	a4,a2,a5
    80000738:	76fd                	lui	a3,0xfffff
    8000073a:	8f75                	and	a4,a4,a3
    8000073c:	97ae                	add	a5,a5,a1
    8000073e:	8ff5                	and	a5,a5,a3
    80000740:	00f76863          	bltu	a4,a5,80000750 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000744:	8526                	mv	a0,s1
    80000746:	60e2                	ld	ra,24(sp)
    80000748:	6442                	ld	s0,16(sp)
    8000074a:	64a2                	ld	s1,8(sp)
    8000074c:	6105                	addi	sp,sp,32
    8000074e:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000750:	8f99                	sub	a5,a5,a4
    80000752:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000754:	4685                	li	a3,1
    80000756:	0007861b          	sext.w	a2,a5
    8000075a:	85ba                	mv	a1,a4
    8000075c:	f39ff0ef          	jal	80000694 <uvmunmap>
    80000760:	b7d5                	j	80000744 <uvmdealloc+0x26>

0000000080000762 <uvmalloc>:
  if(newsz < oldsz)
    80000762:	0ab66163          	bltu	a2,a1,80000804 <uvmalloc+0xa2>
{
    80000766:	715d                	addi	sp,sp,-80
    80000768:	e486                	sd	ra,72(sp)
    8000076a:	e0a2                	sd	s0,64(sp)
    8000076c:	f84a                	sd	s2,48(sp)
    8000076e:	f052                	sd	s4,32(sp)
    80000770:	ec56                	sd	s5,24(sp)
    80000772:	e45e                	sd	s7,8(sp)
    80000774:	0880                	addi	s0,sp,80
    80000776:	8aaa                	mv	s5,a0
    80000778:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    8000077a:	6785                	lui	a5,0x1
    8000077c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000077e:	95be                	add	a1,a1,a5
    80000780:	77fd                	lui	a5,0xfffff
    80000782:	00f5f933          	and	s2,a1,a5
    80000786:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    80000788:	08c97063          	bgeu	s2,a2,80000808 <uvmalloc+0xa6>
    8000078c:	fc26                	sd	s1,56(sp)
    8000078e:	f44e                	sd	s3,40(sp)
    80000790:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    80000792:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000794:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    80000798:	96dff0ef          	jal	80000104 <kalloc>
    8000079c:	84aa                	mv	s1,a0
    if(mem == 0){
    8000079e:	c50d                	beqz	a0,800007c8 <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    800007a0:	864e                	mv	a2,s3
    800007a2:	4581                	li	a1,0
    800007a4:	9bbff0ef          	jal	8000015e <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007a8:	875a                	mv	a4,s6
    800007aa:	86a6                	mv	a3,s1
    800007ac:	864e                	mv	a2,s3
    800007ae:	85ca                	mv	a1,s2
    800007b0:	8556                	mv	a0,s5
    800007b2:	d15ff0ef          	jal	800004c6 <mappages>
    800007b6:	e915                	bnez	a0,800007ea <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800007b8:	994e                	add	s2,s2,s3
    800007ba:	fd496fe3          	bltu	s2,s4,80000798 <uvmalloc+0x36>
  return newsz;
    800007be:	8552                	mv	a0,s4
    800007c0:	74e2                	ld	s1,56(sp)
    800007c2:	79a2                	ld	s3,40(sp)
    800007c4:	6b42                	ld	s6,16(sp)
    800007c6:	a811                	j	800007da <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    800007c8:	865e                	mv	a2,s7
    800007ca:	85ca                	mv	a1,s2
    800007cc:	8556                	mv	a0,s5
    800007ce:	f51ff0ef          	jal	8000071e <uvmdealloc>
      return 0;
    800007d2:	4501                	li	a0,0
    800007d4:	74e2                	ld	s1,56(sp)
    800007d6:	79a2                	ld	s3,40(sp)
    800007d8:	6b42                	ld	s6,16(sp)
}
    800007da:	60a6                	ld	ra,72(sp)
    800007dc:	6406                	ld	s0,64(sp)
    800007de:	7942                	ld	s2,48(sp)
    800007e0:	7a02                	ld	s4,32(sp)
    800007e2:	6ae2                	ld	s5,24(sp)
    800007e4:	6ba2                	ld	s7,8(sp)
    800007e6:	6161                	addi	sp,sp,80
    800007e8:	8082                	ret
      kfree(mem);
    800007ea:	8526                	mv	a0,s1
    800007ec:	831ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007f0:	865e                	mv	a2,s7
    800007f2:	85ca                	mv	a1,s2
    800007f4:	8556                	mv	a0,s5
    800007f6:	f29ff0ef          	jal	8000071e <uvmdealloc>
      return 0;
    800007fa:	4501                	li	a0,0
    800007fc:	74e2                	ld	s1,56(sp)
    800007fe:	79a2                	ld	s3,40(sp)
    80000800:	6b42                	ld	s6,16(sp)
    80000802:	bfe1                	j	800007da <uvmalloc+0x78>
    return oldsz;
    80000804:	852e                	mv	a0,a1
}
    80000806:	8082                	ret
  return newsz;
    80000808:	8532                	mv	a0,a2
    8000080a:	bfc1                	j	800007da <uvmalloc+0x78>

000000008000080c <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    8000080c:	7179                	addi	sp,sp,-48
    8000080e:	f406                	sd	ra,40(sp)
    80000810:	f022                	sd	s0,32(sp)
    80000812:	ec26                	sd	s1,24(sp)
    80000814:	e84a                	sd	s2,16(sp)
    80000816:	e44e                	sd	s3,8(sp)
    80000818:	1800                	addi	s0,sp,48
    8000081a:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    8000081c:	84aa                	mv	s1,a0
    8000081e:	6905                	lui	s2,0x1
    80000820:	992a                	add	s2,s2,a0
    80000822:	a811                	j	80000836 <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    80000824:	00007517          	auipc	a0,0x7
    80000828:	8b450513          	addi	a0,a0,-1868 # 800070d8 <etext+0xd8>
    8000082c:	40a050ef          	jal	80005c36 <panic>
  for(int i = 0; i < 512; i++){
    80000830:	04a1                	addi	s1,s1,8
    80000832:	03248163          	beq	s1,s2,80000854 <freewalk+0x48>
    pte_t pte = pagetable[i];
    80000836:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000838:	0017f713          	andi	a4,a5,1
    8000083c:	db75                	beqz	a4,80000830 <freewalk+0x24>
    8000083e:	00e7f713          	andi	a4,a5,14
    80000842:	f36d                	bnez	a4,80000824 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80000844:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000846:	00c79513          	slli	a0,a5,0xc
    8000084a:	fc3ff0ef          	jal	8000080c <freewalk>
      pagetable[i] = 0;
    8000084e:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000852:	bff9                	j	80000830 <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    80000854:	854e                	mv	a0,s3
    80000856:	fc6ff0ef          	jal	8000001c <kfree>
}
    8000085a:	70a2                	ld	ra,40(sp)
    8000085c:	7402                	ld	s0,32(sp)
    8000085e:	64e2                	ld	s1,24(sp)
    80000860:	6942                	ld	s2,16(sp)
    80000862:	69a2                	ld	s3,8(sp)
    80000864:	6145                	addi	sp,sp,48
    80000866:	8082                	ret

0000000080000868 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000868:	1101                	addi	sp,sp,-32
    8000086a:	ec06                	sd	ra,24(sp)
    8000086c:	e822                	sd	s0,16(sp)
    8000086e:	e426                	sd	s1,8(sp)
    80000870:	1000                	addi	s0,sp,32
    80000872:	84aa                	mv	s1,a0
  if(sz > 0)
    80000874:	e989                	bnez	a1,80000886 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000876:	8526                	mv	a0,s1
    80000878:	f95ff0ef          	jal	8000080c <freewalk>
}
    8000087c:	60e2                	ld	ra,24(sp)
    8000087e:	6442                	ld	s0,16(sp)
    80000880:	64a2                	ld	s1,8(sp)
    80000882:	6105                	addi	sp,sp,32
    80000884:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000886:	6785                	lui	a5,0x1
    80000888:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000088a:	95be                	add	a1,a1,a5
    8000088c:	4685                	li	a3,1
    8000088e:	00c5d613          	srli	a2,a1,0xc
    80000892:	4581                	li	a1,0
    80000894:	e01ff0ef          	jal	80000694 <uvmunmap>
    80000898:	bff9                	j	80000876 <uvmfree+0xe>

000000008000089a <uvmcopy>:
  pte_t *pte;
  uint64 pa, i;
  uint flags;
  char *mem;

  for(i = 0; i < sz; i += PGSIZE){
    8000089a:	ca59                	beqz	a2,80000930 <uvmcopy+0x96>
{
    8000089c:	715d                	addi	sp,sp,-80
    8000089e:	e486                	sd	ra,72(sp)
    800008a0:	e0a2                	sd	s0,64(sp)
    800008a2:	fc26                	sd	s1,56(sp)
    800008a4:	f84a                	sd	s2,48(sp)
    800008a6:	f44e                	sd	s3,40(sp)
    800008a8:	f052                	sd	s4,32(sp)
    800008aa:	ec56                	sd	s5,24(sp)
    800008ac:	e85a                	sd	s6,16(sp)
    800008ae:	e45e                	sd	s7,8(sp)
    800008b0:	0880                	addi	s0,sp,80
    800008b2:	8b2a                	mv	s6,a0
    800008b4:	8bae                	mv	s7,a1
    800008b6:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += PGSIZE){
    800008b8:	4481                	li	s1,0
      continue;   // physical page hasn't been allocated
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008ba:	6a05                	lui	s4,0x1
    800008bc:	a021                	j	800008c4 <uvmcopy+0x2a>
  for(i = 0; i < sz; i += PGSIZE){
    800008be:	94d2                	add	s1,s1,s4
    800008c0:	0554fc63          	bgeu	s1,s5,80000918 <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    800008c4:	4601                	li	a2,0
    800008c6:	85a6                	mv	a1,s1
    800008c8:	855a                	mv	a0,s6
    800008ca:	b29ff0ef          	jal	800003f2 <walk>
    800008ce:	d965                	beqz	a0,800008be <uvmcopy+0x24>
    if((*pte & PTE_V) == 0)
    800008d0:	00053983          	ld	s3,0(a0)
    800008d4:	0019f793          	andi	a5,s3,1
    800008d8:	d3fd                	beqz	a5,800008be <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    800008da:	82bff0ef          	jal	80000104 <kalloc>
    800008de:	892a                	mv	s2,a0
    800008e0:	c11d                	beqz	a0,80000906 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    800008e2:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    800008e6:	8652                	mv	a2,s4
    800008e8:	05b2                	slli	a1,a1,0xc
    800008ea:	8d5ff0ef          	jal	800001be <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008ee:	3ff9f713          	andi	a4,s3,1023
    800008f2:	86ca                	mv	a3,s2
    800008f4:	8652                	mv	a2,s4
    800008f6:	85a6                	mv	a1,s1
    800008f8:	855e                	mv	a0,s7
    800008fa:	bcdff0ef          	jal	800004c6 <mappages>
    800008fe:	d161                	beqz	a0,800008be <uvmcopy+0x24>
      kfree(mem);
    80000900:	854a                	mv	a0,s2
    80000902:	f1aff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000906:	4685                	li	a3,1
    80000908:	00c4d613          	srli	a2,s1,0xc
    8000090c:	4581                	li	a1,0
    8000090e:	855e                	mv	a0,s7
    80000910:	d85ff0ef          	jal	80000694 <uvmunmap>
  return -1;
    80000914:	557d                	li	a0,-1
    80000916:	a011                	j	8000091a <uvmcopy+0x80>
  return 0;
    80000918:	4501                	li	a0,0
}
    8000091a:	60a6                	ld	ra,72(sp)
    8000091c:	6406                	ld	s0,64(sp)
    8000091e:	74e2                	ld	s1,56(sp)
    80000920:	7942                	ld	s2,48(sp)
    80000922:	79a2                	ld	s3,40(sp)
    80000924:	7a02                	ld	s4,32(sp)
    80000926:	6ae2                	ld	s5,24(sp)
    80000928:	6b42                	ld	s6,16(sp)
    8000092a:	6ba2                	ld	s7,8(sp)
    8000092c:	6161                	addi	sp,sp,80
    8000092e:	8082                	ret
  return 0;
    80000930:	4501                	li	a0,0
}
    80000932:	8082                	ret

0000000080000934 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000934:	1141                	addi	sp,sp,-16
    80000936:	e406                	sd	ra,8(sp)
    80000938:	e022                	sd	s0,0(sp)
    8000093a:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    8000093c:	4601                	li	a2,0
    8000093e:	ab5ff0ef          	jal	800003f2 <walk>
  if(pte == 0)
    80000942:	c901                	beqz	a0,80000952 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000944:	611c                	ld	a5,0(a0)
    80000946:	9bbd                	andi	a5,a5,-17
    80000948:	e11c                	sd	a5,0(a0)
}
    8000094a:	60a2                	ld	ra,8(sp)
    8000094c:	6402                	ld	s0,0(sp)
    8000094e:	0141                	addi	sp,sp,16
    80000950:	8082                	ret
    panic("uvmclear");
    80000952:	00006517          	auipc	a0,0x6
    80000956:	79650513          	addi	a0,a0,1942 # 800070e8 <etext+0xe8>
    8000095a:	2dc050ef          	jal	80005c36 <panic>

000000008000095e <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    8000095e:	cac5                	beqz	a3,80000a0e <copyinstr+0xb0>
{
    80000960:	715d                	addi	sp,sp,-80
    80000962:	e486                	sd	ra,72(sp)
    80000964:	e0a2                	sd	s0,64(sp)
    80000966:	fc26                	sd	s1,56(sp)
    80000968:	f84a                	sd	s2,48(sp)
    8000096a:	f44e                	sd	s3,40(sp)
    8000096c:	f052                	sd	s4,32(sp)
    8000096e:	ec56                	sd	s5,24(sp)
    80000970:	e85a                	sd	s6,16(sp)
    80000972:	e45e                	sd	s7,8(sp)
    80000974:	0880                	addi	s0,sp,80
    80000976:	8aaa                	mv	s5,a0
    80000978:	84ae                	mv	s1,a1
    8000097a:	8bb2                	mv	s7,a2
    8000097c:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    8000097e:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000980:	6a05                	lui	s4,0x1
    80000982:	a82d                	j	800009bc <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000984:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80000988:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000098a:	0017c793          	xori	a5,a5,1
    8000098e:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000992:	60a6                	ld	ra,72(sp)
    80000994:	6406                	ld	s0,64(sp)
    80000996:	74e2                	ld	s1,56(sp)
    80000998:	7942                	ld	s2,48(sp)
    8000099a:	79a2                	ld	s3,40(sp)
    8000099c:	7a02                	ld	s4,32(sp)
    8000099e:	6ae2                	ld	s5,24(sp)
    800009a0:	6b42                	ld	s6,16(sp)
    800009a2:	6ba2                	ld	s7,8(sp)
    800009a4:	6161                	addi	sp,sp,80
    800009a6:	8082                	ret
    800009a8:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    800009ac:	9726                	add	a4,a4,s1
      --max;
    800009ae:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    800009b2:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    800009b6:	04e58463          	beq	a1,a4,800009fe <copyinstr+0xa0>
{
    800009ba:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    800009bc:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    800009c0:	85ca                	mv	a1,s2
    800009c2:	8556                	mv	a0,s5
    800009c4:	ac9ff0ef          	jal	8000048c <walkaddr>
    if(pa0 == 0)
    800009c8:	cd0d                	beqz	a0,80000a02 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800009ca:	417906b3          	sub	a3,s2,s7
    800009ce:	96d2                	add	a3,a3,s4
    if(n > max)
    800009d0:	00d9f363          	bgeu	s3,a3,800009d6 <copyinstr+0x78>
    800009d4:	86ce                	mv	a3,s3
    while(n > 0){
    800009d6:	ca85                	beqz	a3,80000a06 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    800009d8:	01750633          	add	a2,a0,s7
    800009dc:	41260633          	sub	a2,a2,s2
    800009e0:	87a6                	mv	a5,s1
      if(*p == '\0'){
    800009e2:	8e05                	sub	a2,a2,s1
    while(n > 0){
    800009e4:	96a6                	add	a3,a3,s1
    800009e6:	85be                	mv	a1,a5
      if(*p == '\0'){
    800009e8:	00f60733          	add	a4,a2,a5
    800009ec:	00074703          	lbu	a4,0(a4)
    800009f0:	db51                	beqz	a4,80000984 <copyinstr+0x26>
        *dst = *p;
    800009f2:	00e78023          	sb	a4,0(a5)
      dst++;
    800009f6:	0785                	addi	a5,a5,1
    while(n > 0){
    800009f8:	fed797e3          	bne	a5,a3,800009e6 <copyinstr+0x88>
    800009fc:	b775                	j	800009a8 <copyinstr+0x4a>
    800009fe:	4781                	li	a5,0
    80000a00:	b769                	j	8000098a <copyinstr+0x2c>
      return -1;
    80000a02:	557d                	li	a0,-1
    80000a04:	b779                	j	80000992 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80000a06:	6b85                	lui	s7,0x1
    80000a08:	9bca                	add	s7,s7,s2
    80000a0a:	87a6                	mv	a5,s1
    80000a0c:	b77d                	j	800009ba <copyinstr+0x5c>
  int got_null = 0;
    80000a0e:	4781                	li	a5,0
  if(got_null){
    80000a10:	0017c793          	xori	a5,a5,1
    80000a14:	40f0053b          	negw	a0,a5
}
    80000a18:	8082                	ret

0000000080000a1a <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80000a1a:	1141                	addi	sp,sp,-16
    80000a1c:	e406                	sd	ra,8(sp)
    80000a1e:	e022                	sd	s0,0(sp)
    80000a20:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000a22:	4601                	li	a2,0
    80000a24:	9cfff0ef          	jal	800003f2 <walk>
  if (pte == 0) {
    80000a28:	c119                	beqz	a0,80000a2e <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    80000a2a:	6108                	ld	a0,0(a0)
    80000a2c:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a2e:	60a2                	ld	ra,8(sp)
    80000a30:	6402                	ld	s0,0(sp)
    80000a32:	0141                	addi	sp,sp,16
    80000a34:	8082                	ret

0000000080000a36 <vmfault>:
{
    80000a36:	711d                	addi	sp,sp,-96
    80000a38:	ec86                	sd	ra,88(sp)
    80000a3a:	e8a2                	sd	s0,80(sp)
    80000a3c:	e4a6                	sd	s1,72(sp)
    80000a3e:	e0ca                	sd	s2,64(sp)
    80000a40:	fc4e                	sd	s3,56(sp)
    80000a42:	f852                	sd	s4,48(sp)
    80000a44:	ec5e                	sd	s7,24(sp)
    80000a46:	1080                	addi	s0,sp,96
    80000a48:	84aa                	mv	s1,a0
    80000a4a:	892e                	mv	s2,a1
    80000a4c:	8a32                	mv	s4,a2
  struct proc *p = myproc();
    80000a4e:	6ae000ef          	jal	800010fc <myproc>
    80000a52:	89aa                	mv	s3,a0
  if (va >= p->sz) {
    80000a54:	653c                	ld	a5,72(a0)
    80000a56:	16f96e63          	bltu	s2,a5,80000bd2 <vmfault+0x19c>
    80000a5a:	17050793          	addi	a5,a0,368
    uint i = 0;
    80000a5e:	4481                	li	s1,0
    for (; i< NVMA; i++) {
    80000a60:	46c1                	li	a3,16
    80000a62:	a031                	j	80000a6e <vmfault+0x38>
    80000a64:	2485                	addiw	s1,s1,1
    80000a66:	03078793          	addi	a5,a5,48
    80000a6a:	10d48963          	beq	s1,a3,80000b7c <vmfault+0x146>
      if (!p->vma[i].valid)
    80000a6e:	4398                	lw	a4,0(a5)
    80000a70:	db75                	beqz	a4,80000a64 <vmfault+0x2e>
      if (p->vma[i].start <= va && va < p->vma[i].end)
    80000a72:	6798                	ld	a4,8(a5)
    80000a74:	fee968e3          	bltu	s2,a4,80000a64 <vmfault+0x2e>
    80000a78:	6b98                	ld	a4,16(a5)
    80000a7a:	fee975e3          	bgeu	s2,a4,80000a64 <vmfault+0x2e>
    if (!read && !(p->vma[i].prot & PROT_WRITE)) {
    80000a7e:	180a1a63          	bnez	s4,80000c12 <vmfault+0x1dc>
    80000a82:	02049713          	slli	a4,s1,0x20
    80000a86:	9301                	srli	a4,a4,0x20
    80000a88:	00171793          	slli	a5,a4,0x1
    80000a8c:	97ba                	add	a5,a5,a4
    80000a8e:	0792                	slli	a5,a5,0x4
    80000a90:	97ce                	add	a5,a5,s3
    80000a92:	1887a783          	lw	a5,392(a5)
    80000a96:	8b89                	andi	a5,a5,2
    80000a98:	0e078d63          	beqz	a5,80000b92 <vmfault+0x15c>
    80000a9c:	f456                	sd	s5,40(sp)
    80000a9e:	e862                	sd	s8,16(sp)
    mem = (uint64) kalloc();
    80000aa0:	e64ff0ef          	jal	80000104 <kalloc>
    80000aa4:	8aaa                	mv	s5,a0
    80000aa6:	8c2a                	mv	s8,a0
      return 0;
    80000aa8:	4b81                	li	s7,0
    if(mem == 0)
    80000aaa:	16050763          	beqz	a0,80000c18 <vmfault+0x1e2>
    80000aae:	f05a                	sd	s6,32(sp)
    80000ab0:	e466                	sd	s9,8(sp)
    va = PGROUNDDOWN(va);
    80000ab2:	77fd                	lui	a5,0xfffff
    80000ab4:	00f97733          	and	a4,s2,a5
    80000ab8:	8cba                	mv	s9,a4
    mem = (uint64) kalloc();
    80000aba:	8baa                	mv	s7,a0
    uint64 off = va - p->vma[i].start;
    80000abc:	02049a13          	slli	s4,s1,0x20
    80000ac0:	020a5a13          	srli	s4,s4,0x20
    80000ac4:	001a1913          	slli	s2,s4,0x1
    80000ac8:	014907b3          	add	a5,s2,s4
    80000acc:	0792                	slli	a5,a5,0x4
    80000ace:	97ce                	add	a5,a5,s3
    80000ad0:	1787b783          	ld	a5,376(a5) # fffffffffffff178 <end+0xffffffff7ffd2340>
    80000ad4:	40f70b33          	sub	s6,a4,a5
    begin_op();
    80000ad8:	38f020ef          	jal	80003666 <begin_op>
    ilock(p->vma[i].f->ip);
    80000adc:	014907b3          	add	a5,s2,s4
    80000ae0:	0792                	slli	a5,a5,0x4
    80000ae2:	97ce                	add	a5,a5,s3
    80000ae4:	1907b783          	ld	a5,400(a5)
    80000ae8:	6f88                	ld	a0,24(a5)
    80000aea:	170020ef          	jal	80002c5a <ilock>
    uint n = readi(p->vma[i].f->ip, 0, mem, p->vma[i].offset + off, PGSIZE);
    80000aee:	014907b3          	add	a5,s2,s4
    80000af2:	0792                	slli	a5,a5,0x4
    80000af4:	97ce                	add	a5,a5,s3
    80000af6:	1987a683          	lw	a3,408(a5)
    80000afa:	014907b3          	add	a5,s2,s4
    80000afe:	0792                	slli	a5,a5,0x4
    80000b00:	97ce                	add	a5,a5,s3
    80000b02:	1907b783          	ld	a5,400(a5)
    80000b06:	6705                	lui	a4,0x1
    80000b08:	016686bb          	addw	a3,a3,s6
    80000b0c:	8656                	mv	a2,s5
    80000b0e:	4581                	li	a1,0
    80000b10:	6f88                	ld	a0,24(a5)
    80000b12:	4da020ef          	jal	80002fec <readi>
    80000b16:	8aaa                	mv	s5,a0
    iunlock(p->vma[i].f->ip);
    80000b18:	014907b3          	add	a5,s2,s4
    80000b1c:	0792                	slli	a5,a5,0x4
    80000b1e:	97ce                	add	a5,a5,s3
    80000b20:	1907b783          	ld	a5,400(a5)
    80000b24:	6f88                	ld	a0,24(a5)
    80000b26:	1e2020ef          	jal	80002d08 <iunlock>
    end_op();
    80000b2a:	3ad020ef          	jal	800036d6 <end_op>
    if (n < PGSIZE) {
    80000b2e:	6785                	lui	a5,0x1
    80000b30:	06faed63          	bltu	s5,a5,80000baa <vmfault+0x174>
    if (p->vma[i].prot & PROT_READ)
    80000b34:	1482                	slli	s1,s1,0x20
    80000b36:	9081                	srli	s1,s1,0x20
    80000b38:	00149793          	slli	a5,s1,0x1
    80000b3c:	97a6                	add	a5,a5,s1
    80000b3e:	0792                	slli	a5,a5,0x4
    80000b40:	97ce                	add	a5,a5,s3
    80000b42:	1887a783          	lw	a5,392(a5) # 1188 <_entry-0x7fffee78>
    80000b46:	0017f693          	andi	a3,a5,1
        perm |= PTE_R;
    80000b4a:	4749                	li	a4,18
    if (p->vma[i].prot & PROT_READ)
    80000b4c:	e291                	bnez	a3,80000b50 <vmfault+0x11a>
    int perm = PTE_U;
    80000b4e:	4741                	li	a4,16
    if (p->vma[i].prot & PROT_WRITE)
    80000b50:	0027f693          	andi	a3,a5,2
    80000b54:	c299                	beqz	a3,80000b5a <vmfault+0x124>
        perm |= PTE_W;
    80000b56:	00476713          	ori	a4,a4,4
    if (p->vma[i].prot & PROT_EXEC)
    80000b5a:	8b91                	andi	a5,a5,4
    80000b5c:	c399                	beqz	a5,80000b62 <vmfault+0x12c>
        perm |= PTE_X;
    80000b5e:	00876713          	ori	a4,a4,8
    if (mappages(p->pagetable, va, PGSIZE, mem, perm) != 0) {
    80000b62:	86e2                	mv	a3,s8
    80000b64:	6605                	lui	a2,0x1
    80000b66:	85e6                	mv	a1,s9
    80000b68:	0509b503          	ld	a0,80(s3)
    80000b6c:	95bff0ef          	jal	800004c6 <mappages>
    80000b70:	e921                	bnez	a0,80000bc0 <vmfault+0x18a>
    80000b72:	7aa2                	ld	s5,40(sp)
    80000b74:	7b02                	ld	s6,32(sp)
    80000b76:	6c42                	ld	s8,16(sp)
    80000b78:	6ca2                	ld	s9,8(sp)
    80000b7a:	a011                	j	80000b7e <vmfault+0x148>
      return 0;
    80000b7c:	4b81                	li	s7,0
}
    80000b7e:	855e                	mv	a0,s7
    80000b80:	60e6                	ld	ra,88(sp)
    80000b82:	6446                	ld	s0,80(sp)
    80000b84:	64a6                	ld	s1,72(sp)
    80000b86:	6906                	ld	s2,64(sp)
    80000b88:	79e2                	ld	s3,56(sp)
    80000b8a:	7a42                	ld	s4,48(sp)
    80000b8c:	6be2                	ld	s7,24(sp)
    80000b8e:	6125                	addi	sp,sp,96
    80000b90:	8082                	ret
      printf("vmfault: unable to write to a read-only memory mapped file\n");
    80000b92:	00006517          	auipc	a0,0x6
    80000b96:	56650513          	addi	a0,a0,1382 # 800070f8 <etext+0xf8>
    80000b9a:	573040ef          	jal	8000590c <printf>
      p->killed = 1; // fatal fault
    80000b9e:	4785                	li	a5,1
    80000ba0:	02f9a423          	sw	a5,40(s3)
      return -1;
    80000ba4:	57fd                	li	a5,-1
    80000ba6:	8bbe                	mv	s7,a5
    80000ba8:	bfd9                	j	80000b7e <vmfault+0x148>
      memset((void*)(mem + n), 0, PGSIZE - n);
    80000baa:	020a9513          	slli	a0,s5,0x20
    80000bae:	9101                	srli	a0,a0,0x20
    80000bb0:	6605                	lui	a2,0x1
    80000bb2:	4156063b          	subw	a2,a2,s5
    80000bb6:	4581                	li	a1,0
    80000bb8:	9562                	add	a0,a0,s8
    80000bba:	da4ff0ef          	jal	8000015e <memset>
    80000bbe:	bf9d                	j	80000b34 <vmfault+0xfe>
      kfree((void *)mem);
    80000bc0:	8562                	mv	a0,s8
    80000bc2:	c5aff0ef          	jal	8000001c <kfree>
      return 0;
    80000bc6:	4b81                	li	s7,0
    80000bc8:	7aa2                	ld	s5,40(sp)
    80000bca:	7b02                	ld	s6,32(sp)
    80000bcc:	6c42                	ld	s8,16(sp)
    80000bce:	6ca2                	ld	s9,8(sp)
    80000bd0:	b77d                	j	80000b7e <vmfault+0x148>
  va = PGROUNDDOWN(va);
    80000bd2:	77fd                	lui	a5,0xfffff
    80000bd4:	00f97933          	and	s2,s2,a5
  if(ismapped(pagetable, va)) {
    80000bd8:	85ca                	mv	a1,s2
    80000bda:	8526                	mv	a0,s1
    80000bdc:	e3fff0ef          	jal	80000a1a <ismapped>
    return 0;
    80000be0:	4b81                	li	s7,0
  if(ismapped(pagetable, va)) {
    80000be2:	fd51                	bnez	a0,80000b7e <vmfault+0x148>
  mem = (uint64) kalloc();
    80000be4:	d20ff0ef          	jal	80000104 <kalloc>
    80000be8:	84aa                	mv	s1,a0
  if(mem == 0)
    80000bea:	d951                	beqz	a0,80000b7e <vmfault+0x148>
  mem = (uint64) kalloc();
    80000bec:	8baa                	mv	s7,a0
  memset((void *) mem, 0, PGSIZE);
    80000bee:	6605                	lui	a2,0x1
    80000bf0:	4581                	li	a1,0
    80000bf2:	d6cff0ef          	jal	8000015e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000bf6:	4759                	li	a4,22
    80000bf8:	86a6                	mv	a3,s1
    80000bfa:	6605                	lui	a2,0x1
    80000bfc:	85ca                	mv	a1,s2
    80000bfe:	0509b503          	ld	a0,80(s3)
    80000c02:	8c5ff0ef          	jal	800004c6 <mappages>
    80000c06:	dd25                	beqz	a0,80000b7e <vmfault+0x148>
    kfree((void *)mem);
    80000c08:	8526                	mv	a0,s1
    80000c0a:	c12ff0ef          	jal	8000001c <kfree>
    return 0;
    80000c0e:	4b81                	li	s7,0
    80000c10:	b7bd                	j	80000b7e <vmfault+0x148>
    80000c12:	f456                	sd	s5,40(sp)
    80000c14:	e862                	sd	s8,16(sp)
    80000c16:	b569                	j	80000aa0 <vmfault+0x6a>
    80000c18:	7aa2                	ld	s5,40(sp)
    80000c1a:	6c42                	ld	s8,16(sp)
    80000c1c:	b78d                	j	80000b7e <vmfault+0x148>

0000000080000c1e <copyout>:
  while(len > 0){
    80000c1e:	cad1                	beqz	a3,80000cb2 <copyout+0x94>
{
    80000c20:	711d                	addi	sp,sp,-96
    80000c22:	ec86                	sd	ra,88(sp)
    80000c24:	e8a2                	sd	s0,80(sp)
    80000c26:	e4a6                	sd	s1,72(sp)
    80000c28:	e0ca                	sd	s2,64(sp)
    80000c2a:	fc4e                	sd	s3,56(sp)
    80000c2c:	f852                	sd	s4,48(sp)
    80000c2e:	f456                	sd	s5,40(sp)
    80000c30:	f05a                	sd	s6,32(sp)
    80000c32:	ec5e                	sd	s7,24(sp)
    80000c34:	e862                	sd	s8,16(sp)
    80000c36:	e466                	sd	s9,8(sp)
    80000c38:	e06a                	sd	s10,0(sp)
    80000c3a:	1080                	addi	s0,sp,96
    80000c3c:	8baa                	mv	s7,a0
    80000c3e:	8a2e                	mv	s4,a1
    80000c40:	8b32                	mv	s6,a2
    80000c42:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000c44:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80000c46:	5cfd                	li	s9,-1
    80000c48:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000c4c:	6c05                	lui	s8,0x1
    80000c4e:	a005                	j	80000c6e <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c50:	409a0533          	sub	a0,s4,s1
    80000c54:	0009061b          	sext.w	a2,s2
    80000c58:	85da                	mv	a1,s6
    80000c5a:	954e                	add	a0,a0,s3
    80000c5c:	d62ff0ef          	jal	800001be <memmove>
    len -= n;
    80000c60:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000c64:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000c66:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80000c6a:	040a8263          	beqz	s5,80000cae <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    80000c6e:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    80000c72:	049ce263          	bltu	s9,s1,80000cb6 <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    80000c76:	85a6                	mv	a1,s1
    80000c78:	855e                	mv	a0,s7
    80000c7a:	813ff0ef          	jal	8000048c <walkaddr>
    80000c7e:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80000c80:	e901                	bnez	a0,80000c90 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000c82:	4601                	li	a2,0
    80000c84:	85a6                	mv	a1,s1
    80000c86:	855e                	mv	a0,s7
    80000c88:	dafff0ef          	jal	80000a36 <vmfault>
    80000c8c:	89aa                	mv	s3,a0
    80000c8e:	c139                	beqz	a0,80000cd4 <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    80000c90:	4601                	li	a2,0
    80000c92:	85a6                	mv	a1,s1
    80000c94:	855e                	mv	a0,s7
    80000c96:	f5cff0ef          	jal	800003f2 <walk>
    if((*pte & PTE_W) == 0)
    80000c9a:	611c                	ld	a5,0(a0)
    80000c9c:	8b91                	andi	a5,a5,4
    80000c9e:	cf8d                	beqz	a5,80000cd8 <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    80000ca0:	41448933          	sub	s2,s1,s4
    80000ca4:	9962                	add	s2,s2,s8
    if(n > len)
    80000ca6:	fb2af5e3          	bgeu	s5,s2,80000c50 <copyout+0x32>
    80000caa:	8956                	mv	s2,s5
    80000cac:	b755                	j	80000c50 <copyout+0x32>
  return 0;
    80000cae:	4501                	li	a0,0
    80000cb0:	a021                	j	80000cb8 <copyout+0x9a>
    80000cb2:	4501                	li	a0,0
}
    80000cb4:	8082                	ret
      return -1;
    80000cb6:	557d                	li	a0,-1
}
    80000cb8:	60e6                	ld	ra,88(sp)
    80000cba:	6446                	ld	s0,80(sp)
    80000cbc:	64a6                	ld	s1,72(sp)
    80000cbe:	6906                	ld	s2,64(sp)
    80000cc0:	79e2                	ld	s3,56(sp)
    80000cc2:	7a42                	ld	s4,48(sp)
    80000cc4:	7aa2                	ld	s5,40(sp)
    80000cc6:	7b02                	ld	s6,32(sp)
    80000cc8:	6be2                	ld	s7,24(sp)
    80000cca:	6c42                	ld	s8,16(sp)
    80000ccc:	6ca2                	ld	s9,8(sp)
    80000cce:	6d02                	ld	s10,0(sp)
    80000cd0:	6125                	addi	sp,sp,96
    80000cd2:	8082                	ret
        return -1;
    80000cd4:	557d                	li	a0,-1
    80000cd6:	b7cd                	j	80000cb8 <copyout+0x9a>
      return -1;
    80000cd8:	557d                	li	a0,-1
    80000cda:	bff9                	j	80000cb8 <copyout+0x9a>

0000000080000cdc <copyin>:
  while(len > 0){
    80000cdc:	c6c9                	beqz	a3,80000d66 <copyin+0x8a>
{
    80000cde:	715d                	addi	sp,sp,-80
    80000ce0:	e486                	sd	ra,72(sp)
    80000ce2:	e0a2                	sd	s0,64(sp)
    80000ce4:	fc26                	sd	s1,56(sp)
    80000ce6:	f84a                	sd	s2,48(sp)
    80000ce8:	f44e                	sd	s3,40(sp)
    80000cea:	f052                	sd	s4,32(sp)
    80000cec:	ec56                	sd	s5,24(sp)
    80000cee:	e85a                	sd	s6,16(sp)
    80000cf0:	e45e                	sd	s7,8(sp)
    80000cf2:	e062                	sd	s8,0(sp)
    80000cf4:	0880                	addi	s0,sp,80
    80000cf6:	8baa                	mv	s7,a0
    80000cf8:	8aae                	mv	s5,a1
    80000cfa:	8932                	mv	s2,a2
    80000cfc:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000cfe:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000d00:	6b05                	lui	s6,0x1
    80000d02:	a035                	j	80000d2e <copyin+0x52>
    80000d04:	412984b3          	sub	s1,s3,s2
    80000d08:	94da                	add	s1,s1,s6
    if(n > len)
    80000d0a:	009a7363          	bgeu	s4,s1,80000d10 <copyin+0x34>
    80000d0e:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d10:	413905b3          	sub	a1,s2,s3
    80000d14:	0004861b          	sext.w	a2,s1
    80000d18:	95aa                	add	a1,a1,a0
    80000d1a:	8556                	mv	a0,s5
    80000d1c:	ca2ff0ef          	jal	800001be <memmove>
    len -= n;
    80000d20:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000d24:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000d26:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000d2a:	020a0163          	beqz	s4,80000d4c <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000d2e:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000d32:	85ce                	mv	a1,s3
    80000d34:	855e                	mv	a0,s7
    80000d36:	f56ff0ef          	jal	8000048c <walkaddr>
    if(pa0 == 0) {
    80000d3a:	f569                	bnez	a0,80000d04 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000d3c:	4601                	li	a2,0
    80000d3e:	85ce                	mv	a1,s3
    80000d40:	855e                	mv	a0,s7
    80000d42:	cf5ff0ef          	jal	80000a36 <vmfault>
    80000d46:	fd5d                	bnez	a0,80000d04 <copyin+0x28>
        return -1;
    80000d48:	557d                	li	a0,-1
    80000d4a:	a011                	j	80000d4e <copyin+0x72>
  return 0;
    80000d4c:	4501                	li	a0,0
}
    80000d4e:	60a6                	ld	ra,72(sp)
    80000d50:	6406                	ld	s0,64(sp)
    80000d52:	74e2                	ld	s1,56(sp)
    80000d54:	7942                	ld	s2,48(sp)
    80000d56:	79a2                	ld	s3,40(sp)
    80000d58:	7a02                	ld	s4,32(sp)
    80000d5a:	6ae2                	ld	s5,24(sp)
    80000d5c:	6b42                	ld	s6,16(sp)
    80000d5e:	6ba2                	ld	s7,8(sp)
    80000d60:	6c02                	ld	s8,0(sp)
    80000d62:	6161                	addi	sp,sp,80
    80000d64:	8082                	ret
  return 0;
    80000d66:	4501                	li	a0,0
}
    80000d68:	8082                	ret

0000000080000d6a <uvmunmap_vma>:

int
uvmunmap_vma(pagetable_t pagetable, struct VMA *vma, uint64 addr, uint64 end)
{
    80000d6a:	7175                	addi	sp,sp,-144
    80000d6c:	e506                	sd	ra,136(sp)
    80000d6e:	e122                	sd	s0,128(sp)
    80000d70:	0900                	addi	s0,sp,144
    80000d72:	f8a43423          	sd	a0,-120(s0)
    80000d76:	f6b43c23          	sd	a1,-136(s0)
  if (vma->valid == 0)
    80000d7a:	419c                	lw	a5,0(a1)
    80000d7c:	1c078463          	beqz	a5,80000f44 <uvmunmap_vma+0x1da>
    80000d80:	f86a                	sd	s10,48(sp)
    return -1;

  // No overlap
  if (vma->end <= addr || vma->start >= end)
    80000d82:	0105bd03          	ld	s10,16(a1)
    80000d86:	1da67163          	bgeu	a2,s10,80000f48 <uvmunmap_vma+0x1de>
    80000d8a:	659c                	ld	a5,8(a1)
    80000d8c:	1cd7f163          	bgeu	a5,a3,80000f4e <uvmunmap_vma+0x1e4>

  // Calculate correct unmap range for this VMA
  uint64 unmap_start = (addr > vma->start) ? addr : vma->start;
  uint64 unmap_end   = (end < vma->end)    ? end  : vma->end;

  if (unmap_start != vma->start && unmap_end != vma->end) {
    80000d90:	01a6f463          	bgeu	a3,s10,80000d98 <uvmunmap_vma+0x2e>
    80000d94:	04c7ef63          	bltu	a5,a2,80000df2 <uvmunmap_vma+0x88>
    80000d98:	fca6                	sd	s1,120(sp)
  uint64 unmap_start = (addr > vma->start) ? addr : vma->start;
    80000d9a:	f6f43823          	sd	a5,-144(s0)
    80000d9e:	00c7f463          	bgeu	a5,a2,80000da6 <uvmunmap_vma+0x3c>
    80000da2:	f6c43823          	sd	a2,-144(s0)
  uint64 unmap_end   = (end < vma->end)    ? end  : vma->end;
    80000da6:	01a6f363          	bgeu	a3,s10,80000dac <uvmunmap_vma+0x42>
    80000daa:	8d36                	mv	s10,a3
    return -1;
  }
  
  // If the file is mapped MAP_SHARED,
  // write the dirty page back to the file.
  if (vma->flags & MAP_SHARED) {
    80000dac:	f7843683          	ld	a3,-136(s0)
    80000db0:	4ed8                	lw	a4,28(a3)
    80000db2:	8b05                	andi	a4,a4,1
    80000db4:	10070363          	beqz	a4,80000eba <uvmunmap_vma+0x150>
    80000db8:	ecd6                	sd	s5,88(sp)
    uint64 addr = unmap_start;
    uint offset = vma->offset + (addr - vma->start);
    pte_t *pte;

    for(; addr < unmap_end; addr += PGSIZE){
    80000dba:	f7043a83          	ld	s5,-144(s0)
    80000dbe:	13aafa63          	bgeu	s5,s10,80000ef2 <uvmunmap_vma+0x188>
    80000dc2:	f8ca                	sd	s2,112(sp)
    80000dc4:	f4ce                	sd	s3,104(sp)
    80000dc6:	f0d2                	sd	s4,96(sp)
    80000dc8:	e8da                	sd	s6,80(sp)
    80000dca:	e4de                	sd	s7,72(sp)
    80000dcc:	e0e2                	sd	s8,64(sp)
    80000dce:	fc66                	sd	s9,56(sp)
    80000dd0:	f46e                	sd	s11,40(sp)
    uint offset = vma->offset + (addr - vma->start);
    80000dd2:	40fa87bb          	subw	a5,s5,a5
    80000dd6:	0286ab83          	lw	s7,40(a3) # fffffffffffff028 <end+0xffffffff7ffd21f0>
    80000dda:	00fb8bbb          	addw	s7,s7,a5

      // write back to file without expanding the file size
      int size = f->ip->size - offset; // file length starts from offset
      if (size < 0) {
        break;
      } else if (size < n) {
    80000dde:	6d85                	lui	s11,0x1
        n = size;
      }

      while(i < n){
        int n1 = n - i;
        if(n1 > max)
    80000de0:	c00d8c13          	addi	s8,s11,-1024 # c00 <_entry-0x7ffff400>
    80000de4:	6785                	lui	a5,0x1
    80000de6:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80000dea:	f8f42223          	sw	a5,-124(s0)
          n1 = max;
        begin_op();
        ilock(f->ip);
        // printf("write back, vma %p, unmmap_end %p, addr %p, offset %d, file size %d, n %d , n1 %d\n", (void *)vma, (void *)unmap_end, (void *)addr, offset, f->ip->size, n, n1);
        if ((r = writei(f->ip, 1, addr + i, offset, n1)) > 0)
    80000dee:	4c85                	li	s9,1
    80000df0:	a88d                	j	80000e62 <uvmunmap_vma+0xf8>
    printf("munmap: cant punch a hole in the middle of a region\n");
    80000df2:	00006517          	auipc	a0,0x6
    80000df6:	34650513          	addi	a0,a0,838 # 80007138 <etext+0x138>
    80000dfa:	313040ef          	jal	8000590c <printf>
    return -1;
    80000dfe:	557d                	li	a0,-1
    80000e00:	7d42                	ld	s10,48(sp)
    80000e02:	a0e5                	j	80000eea <uvmunmap_vma+0x180>
        if(n1 > max)
    80000e04:	2481                	sext.w	s1,s1
        begin_op();
    80000e06:	061020ef          	jal	80003666 <begin_op>
        ilock(f->ip);
    80000e0a:	018a3503          	ld	a0,24(s4) # 1018 <_entry-0x7fffefe8>
    80000e0e:	64d010ef          	jal	80002c5a <ilock>
        if ((r = writei(f->ip, 1, addr + i, offset, n1)) > 0)
    80000e12:	8726                	mv	a4,s1
    80000e14:	86de                	mv	a3,s7
    80000e16:	01598633          	add	a2,s3,s5
    80000e1a:	85e6                	mv	a1,s9
    80000e1c:	018a3503          	ld	a0,24(s4)
    80000e20:	2be020ef          	jal	800030de <writei>
    80000e24:	892a                	mv	s2,a0
    80000e26:	00a05463          	blez	a0,80000e2e <uvmunmap_vma+0xc4>
          offset += r;
    80000e2a:	01750bbb          	addw	s7,a0,s7
        iunlock(f->ip);
    80000e2e:	018a3503          	ld	a0,24(s4)
    80000e32:	6d7010ef          	jal	80002d08 <iunlock>
        end_op();
    80000e36:	0a1020ef          	jal	800036d6 <end_op>
        if(r != n1){
    80000e3a:	00991f63          	bne	s2,s1,80000e58 <uvmunmap_vma+0xee>
          // error from writei
          break;
        }
        i += r;
    80000e3e:	013489bb          	addw	s3,s1,s3
      while(i < n){
    80000e42:	0169db63          	bge	s3,s6,80000e58 <uvmunmap_vma+0xee>
        int n1 = n - i;
    80000e46:	413b07bb          	subw	a5,s6,s3
    80000e4a:	84be                	mv	s1,a5
        if(n1 > max)
    80000e4c:	fafc5ce3          	bge	s8,a5,80000e04 <uvmunmap_vma+0x9a>
    80000e50:	f8442483          	lw	s1,-124(s0)
    80000e54:	bf45                	j	80000e04 <uvmunmap_vma+0x9a>
      while(i < n){
    80000e56:	4981                	li	s3,0
      }
      if (i != n)
    80000e58:	0f3b1e63          	bne	s6,s3,80000f54 <uvmunmap_vma+0x1ea>
    for(; addr < unmap_end; addr += PGSIZE){
    80000e5c:	9aee                	add	s5,s5,s11
    80000e5e:	05aaf563          	bgeu	s5,s10,80000ea8 <uvmunmap_vma+0x13e>
      if((pte = walk(pagetable, addr, 0)) == 0) // leaf page table entry allocated?
    80000e62:	4601                	li	a2,0
    80000e64:	85d6                	mv	a1,s5
    80000e66:	f8843503          	ld	a0,-120(s0)
    80000e6a:	d88ff0ef          	jal	800003f2 <walk>
    80000e6e:	d57d                	beqz	a0,80000e5c <uvmunmap_vma+0xf2>
      if((*pte & PTE_V) == 0 || (*pte & PTE_D) == 0)
    80000e70:	611c                	ld	a5,0(a0)
    80000e72:	0817f793          	andi	a5,a5,129
    80000e76:	08100713          	li	a4,129
    80000e7a:	fee791e3          	bne	a5,a4,80000e5c <uvmunmap_vma+0xf2>
      struct file *f = vma->f;
    80000e7e:	f7843783          	ld	a5,-136(s0)
    80000e82:	0207ba03          	ld	s4,32(a5)
      int size = f->ip->size - offset; // file length starts from offset
    80000e86:	018a3783          	ld	a5,24(s4)
    80000e8a:	47fc                	lw	a5,76(a5)
    80000e8c:	417787bb          	subw	a5,a5,s7
    80000e90:	873e                	mv	a4,a5
      if (size < 0) {
    80000e92:	0607c263          	bltz	a5,80000ef6 <uvmunmap_vma+0x18c>
      } else if (size < n) {
    80000e96:	8b3e                	mv	s6,a5
    80000e98:	00fdd363          	bge	s11,a5,80000e9e <uvmunmap_vma+0x134>
    80000e9c:	6b05                	lui	s6,0x1
    80000e9e:	2b01                	sext.w	s6,s6
      while(i < n){
    80000ea0:	fae05be3          	blez	a4,80000e56 <uvmunmap_vma+0xec>
    80000ea4:	4981                	li	s3,0
    80000ea6:	b745                	j	80000e46 <uvmunmap_vma+0xdc>
    80000ea8:	7946                	ld	s2,112(sp)
    80000eaa:	79a6                	ld	s3,104(sp)
    80000eac:	7a06                	ld	s4,96(sp)
    80000eae:	6ae6                	ld	s5,88(sp)
    80000eb0:	6b46                	ld	s6,80(sp)
    80000eb2:	6ba6                	ld	s7,72(sp)
    80000eb4:	6c06                	ld	s8,64(sp)
    80000eb6:	7ce2                	ld	s9,56(sp)
    80000eb8:	7da2                	ld	s11,40(sp)
        return -1;
    }
  }

  // Unmap the pages
  uvmunmap(pagetable, unmap_start, (unmap_end-unmap_start)/PGSIZE, 1);
    80000eba:	f7043483          	ld	s1,-144(s0)
    80000ebe:	409d0633          	sub	a2,s10,s1
    80000ec2:	4685                	li	a3,1
    80000ec4:	8231                	srli	a2,a2,0xc
    80000ec6:	85a6                	mv	a1,s1
    80000ec8:	f8843503          	ld	a0,-120(s0)
    80000ecc:	fc8ff0ef          	jal	80000694 <uvmunmap>

  if (unmap_start == vma->start && unmap_end == vma->end) {
    80000ed0:	f7843783          	ld	a5,-136(s0)
    80000ed4:	679c                	ld	a5,8(a5)
    80000ed6:	02978a63          	beq	a5,s1,80000f0a <uvmunmap_vma+0x1a0>
    // Shrink from front
    vma->offset += (unmap_end - vma->start);
    vma->start = unmap_end;
  } else {
    // Shrink from back
    vma->end = unmap_start;
    80000eda:	f7843783          	ld	a5,-136(s0)
    80000ede:	f7043703          	ld	a4,-144(s0)
    80000ee2:	eb98                	sd	a4,16(a5)
  }

  return 0;
    80000ee4:	4501                	li	a0,0
    80000ee6:	74e6                	ld	s1,120(sp)
    80000ee8:	7d42                	ld	s10,48(sp)
}
    80000eea:	60aa                	ld	ra,136(sp)
    80000eec:	640a                	ld	s0,128(sp)
    80000eee:	6149                	addi	sp,sp,144
    80000ef0:	8082                	ret
    80000ef2:	6ae6                	ld	s5,88(sp)
    80000ef4:	b7d9                	j	80000eba <uvmunmap_vma+0x150>
    80000ef6:	7946                	ld	s2,112(sp)
    80000ef8:	79a6                	ld	s3,104(sp)
    80000efa:	7a06                	ld	s4,96(sp)
    80000efc:	6ae6                	ld	s5,88(sp)
    80000efe:	6b46                	ld	s6,80(sp)
    80000f00:	6ba6                	ld	s7,72(sp)
    80000f02:	6c06                	ld	s8,64(sp)
    80000f04:	7ce2                	ld	s9,56(sp)
    80000f06:	7da2                	ld	s11,40(sp)
    80000f08:	bf4d                	j	80000eba <uvmunmap_vma+0x150>
  if (unmap_start == vma->start && unmap_end == vma->end) {
    80000f0a:	f7843703          	ld	a4,-136(s0)
    80000f0e:	6b18                	ld	a4,16(a4)
    80000f10:	01a70f63          	beq	a4,s10,80000f2e <uvmunmap_vma+0x1c4>
    vma->offset += (unmap_end - vma->start);
    80000f14:	40fd07bb          	subw	a5,s10,a5
    80000f18:	f7843683          	ld	a3,-136(s0)
    80000f1c:	5698                	lw	a4,40(a3)
    80000f1e:	9fb9                	addw	a5,a5,a4
    80000f20:	d69c                	sw	a5,40(a3)
    vma->start = unmap_end;
    80000f22:	01a6b423          	sd	s10,8(a3)
  return 0;
    80000f26:	4501                	li	a0,0
    80000f28:	74e6                	ld	s1,120(sp)
    80000f2a:	7d42                	ld	s10,48(sp)
    80000f2c:	bf7d                	j	80000eea <uvmunmap_vma+0x180>
    fileclose(vma->f);
    80000f2e:	f7843483          	ld	s1,-136(s0)
    80000f32:	7088                	ld	a0,32(s1)
    80000f34:	357020ef          	jal	80003a8a <fileclose>
    vma->valid = 0;
    80000f38:	0004a023          	sw	zero,0(s1)
  return 0;
    80000f3c:	4501                	li	a0,0
    vma->valid = 0;
    80000f3e:	74e6                	ld	s1,120(sp)
    80000f40:	7d42                	ld	s10,48(sp)
    80000f42:	b765                	j	80000eea <uvmunmap_vma+0x180>
    return -1;
    80000f44:	557d                	li	a0,-1
    80000f46:	b755                	j	80000eea <uvmunmap_vma+0x180>
      return -1;
    80000f48:	557d                	li	a0,-1
    80000f4a:	7d42                	ld	s10,48(sp)
    80000f4c:	bf79                	j	80000eea <uvmunmap_vma+0x180>
    80000f4e:	557d                	li	a0,-1
    80000f50:	7d42                	ld	s10,48(sp)
    80000f52:	bf61                	j	80000eea <uvmunmap_vma+0x180>
        return -1;
    80000f54:	557d                	li	a0,-1
    80000f56:	74e6                	ld	s1,120(sp)
    80000f58:	7946                	ld	s2,112(sp)
    80000f5a:	79a6                	ld	s3,104(sp)
    80000f5c:	7a06                	ld	s4,96(sp)
    80000f5e:	6ae6                	ld	s5,88(sp)
    80000f60:	6b46                	ld	s6,80(sp)
    80000f62:	6ba6                	ld	s7,72(sp)
    80000f64:	6c06                	ld	s8,64(sp)
    80000f66:	7ce2                	ld	s9,56(sp)
    80000f68:	7d42                	ld	s10,48(sp)
    80000f6a:	7da2                	ld	s11,40(sp)
    80000f6c:	bfbd                	j	80000eea <uvmunmap_vma+0x180>

0000000080000f6e <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000f6e:	715d                	addi	sp,sp,-80
    80000f70:	e486                	sd	ra,72(sp)
    80000f72:	e0a2                	sd	s0,64(sp)
    80000f74:	fc26                	sd	s1,56(sp)
    80000f76:	f84a                	sd	s2,48(sp)
    80000f78:	f44e                	sd	s3,40(sp)
    80000f7a:	f052                	sd	s4,32(sp)
    80000f7c:	ec56                	sd	s5,24(sp)
    80000f7e:	e85a                	sd	s6,16(sp)
    80000f80:	e45e                	sd	s7,8(sp)
    80000f82:	e062                	sd	s8,0(sp)
    80000f84:	0880                	addi	s0,sp,80
    80000f86:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f88:	00007497          	auipc	s1,0x7
    80000f8c:	df848493          	addi	s1,s1,-520 # 80007d80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f90:	8c26                	mv	s8,s1
    80000f92:	000e37b7          	lui	a5,0xe3
    80000f96:	27b78793          	addi	a5,a5,635 # e327b <_entry-0x7ff1cd85>
    80000f9a:	07b2                	slli	a5,a5,0xc
    80000f9c:	97778793          	addi	a5,a5,-1673
    80000fa0:	193d5937          	lui	s2,0x193d5
    80000fa4:	bb790913          	addi	s2,s2,-1097 # 193d4bb7 <_entry-0x66c2b449>
    80000fa8:	1902                	slli	s2,s2,0x20
    80000faa:	993e                	add	s2,s2,a5
    80000fac:	040009b7          	lui	s3,0x4000
    80000fb0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000fb2:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000fb4:	4b99                	li	s7,6
    80000fb6:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb8:	00019a97          	auipc	s5,0x19
    80000fbc:	9c8a8a93          	addi	s5,s5,-1592 # 80019980 <tickslock>
    char *pa = kalloc();
    80000fc0:	944ff0ef          	jal	80000104 <kalloc>
    80000fc4:	862a                	mv	a2,a0
    if(pa == 0)
    80000fc6:	c121                	beqz	a0,80001006 <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    80000fc8:	418485b3          	sub	a1,s1,s8
    80000fcc:	8591                	srai	a1,a1,0x4
    80000fce:	032585b3          	mul	a1,a1,s2
    80000fd2:	05b6                	slli	a1,a1,0xd
    80000fd4:	6789                	lui	a5,0x2
    80000fd6:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000fd8:	875e                	mv	a4,s7
    80000fda:	86da                	mv	a3,s6
    80000fdc:	40b985b3          	sub	a1,s3,a1
    80000fe0:	8552                	mv	a0,s4
    80000fe2:	d9aff0ef          	jal	8000057c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fe6:	47048493          	addi	s1,s1,1136
    80000fea:	fd549be3          	bne	s1,s5,80000fc0 <proc_mapstacks+0x52>
  }
}
    80000fee:	60a6                	ld	ra,72(sp)
    80000ff0:	6406                	ld	s0,64(sp)
    80000ff2:	74e2                	ld	s1,56(sp)
    80000ff4:	7942                	ld	s2,48(sp)
    80000ff6:	79a2                	ld	s3,40(sp)
    80000ff8:	7a02                	ld	s4,32(sp)
    80000ffa:	6ae2                	ld	s5,24(sp)
    80000ffc:	6b42                	ld	s6,16(sp)
    80000ffe:	6ba2                	ld	s7,8(sp)
    80001000:	6c02                	ld	s8,0(sp)
    80001002:	6161                	addi	sp,sp,80
    80001004:	8082                	ret
      panic("kalloc");
    80001006:	00006517          	auipc	a0,0x6
    8000100a:	16a50513          	addi	a0,a0,362 # 80007170 <etext+0x170>
    8000100e:	429040ef          	jal	80005c36 <panic>

0000000080001012 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001012:	7139                	addi	sp,sp,-64
    80001014:	fc06                	sd	ra,56(sp)
    80001016:	f822                	sd	s0,48(sp)
    80001018:	f426                	sd	s1,40(sp)
    8000101a:	f04a                	sd	s2,32(sp)
    8000101c:	ec4e                	sd	s3,24(sp)
    8000101e:	e852                	sd	s4,16(sp)
    80001020:	e456                	sd	s5,8(sp)
    80001022:	e05a                	sd	s6,0(sp)
    80001024:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001026:	00006597          	auipc	a1,0x6
    8000102a:	15258593          	addi	a1,a1,338 # 80007178 <etext+0x178>
    8000102e:	00007517          	auipc	a0,0x7
    80001032:	92250513          	addi	a0,a0,-1758 # 80007950 <pid_lock>
    80001036:	639040ef          	jal	80005e6e <initlock>
  initlock(&wait_lock, "wait_lock");
    8000103a:	00006597          	auipc	a1,0x6
    8000103e:	14658593          	addi	a1,a1,326 # 80007180 <etext+0x180>
    80001042:	00007517          	auipc	a0,0x7
    80001046:	92650513          	addi	a0,a0,-1754 # 80007968 <wait_lock>
    8000104a:	625040ef          	jal	80005e6e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000104e:	00007497          	auipc	s1,0x7
    80001052:	d3248493          	addi	s1,s1,-718 # 80007d80 <proc>
      initlock(&p->lock, "proc");
    80001056:	00006b17          	auipc	s6,0x6
    8000105a:	13ab0b13          	addi	s6,s6,314 # 80007190 <etext+0x190>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    8000105e:	8aa6                	mv	s5,s1
    80001060:	000e37b7          	lui	a5,0xe3
    80001064:	27b78793          	addi	a5,a5,635 # e327b <_entry-0x7ff1cd85>
    80001068:	07b2                	slli	a5,a5,0xc
    8000106a:	97778793          	addi	a5,a5,-1673
    8000106e:	193d5937          	lui	s2,0x193d5
    80001072:	bb790913          	addi	s2,s2,-1097 # 193d4bb7 <_entry-0x66c2b449>
    80001076:	1902                	slli	s2,s2,0x20
    80001078:	993e                	add	s2,s2,a5
    8000107a:	040009b7          	lui	s3,0x4000
    8000107e:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001080:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001082:	00019a17          	auipc	s4,0x19
    80001086:	8fea0a13          	addi	s4,s4,-1794 # 80019980 <tickslock>
      initlock(&p->lock, "proc");
    8000108a:	85da                	mv	a1,s6
    8000108c:	8526                	mv	a0,s1
    8000108e:	5e1040ef          	jal	80005e6e <initlock>
      p->state = UNUSED;
    80001092:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80001096:	415487b3          	sub	a5,s1,s5
    8000109a:	8791                	srai	a5,a5,0x4
    8000109c:	032787b3          	mul	a5,a5,s2
    800010a0:	07b6                	slli	a5,a5,0xd
    800010a2:	6709                	lui	a4,0x2
    800010a4:	9fb9                	addw	a5,a5,a4
    800010a6:	40f987b3          	sub	a5,s3,a5
    800010aa:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800010ac:	47048493          	addi	s1,s1,1136
    800010b0:	fd449de3          	bne	s1,s4,8000108a <procinit+0x78>
  }
}
    800010b4:	70e2                	ld	ra,56(sp)
    800010b6:	7442                	ld	s0,48(sp)
    800010b8:	74a2                	ld	s1,40(sp)
    800010ba:	7902                	ld	s2,32(sp)
    800010bc:	69e2                	ld	s3,24(sp)
    800010be:	6a42                	ld	s4,16(sp)
    800010c0:	6aa2                	ld	s5,8(sp)
    800010c2:	6b02                	ld	s6,0(sp)
    800010c4:	6121                	addi	sp,sp,64
    800010c6:	8082                	ret

00000000800010c8 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800010c8:	1141                	addi	sp,sp,-16
    800010ca:	e406                	sd	ra,8(sp)
    800010cc:	e022                	sd	s0,0(sp)
    800010ce:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800010d0:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800010d2:	2501                	sext.w	a0,a0
    800010d4:	60a2                	ld	ra,8(sp)
    800010d6:	6402                	ld	s0,0(sp)
    800010d8:	0141                	addi	sp,sp,16
    800010da:	8082                	ret

00000000800010dc <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800010dc:	1141                	addi	sp,sp,-16
    800010de:	e406                	sd	ra,8(sp)
    800010e0:	e022                	sd	s0,0(sp)
    800010e2:	0800                	addi	s0,sp,16
    800010e4:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800010e6:	2781                	sext.w	a5,a5
    800010e8:	079e                	slli	a5,a5,0x7
  return c;
}
    800010ea:	00007517          	auipc	a0,0x7
    800010ee:	89650513          	addi	a0,a0,-1898 # 80007980 <cpus>
    800010f2:	953e                	add	a0,a0,a5
    800010f4:	60a2                	ld	ra,8(sp)
    800010f6:	6402                	ld	s0,0(sp)
    800010f8:	0141                	addi	sp,sp,16
    800010fa:	8082                	ret

00000000800010fc <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800010fc:	1101                	addi	sp,sp,-32
    800010fe:	ec06                	sd	ra,24(sp)
    80001100:	e822                	sd	s0,16(sp)
    80001102:	e426                	sd	s1,8(sp)
    80001104:	1000                	addi	s0,sp,32
  push_off();
    80001106:	5af040ef          	jal	80005eb4 <push_off>
    8000110a:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000110c:	2781                	sext.w	a5,a5
    8000110e:	079e                	slli	a5,a5,0x7
    80001110:	00007717          	auipc	a4,0x7
    80001114:	84070713          	addi	a4,a4,-1984 # 80007950 <pid_lock>
    80001118:	97ba                	add	a5,a5,a4
    8000111a:	7b9c                	ld	a5,48(a5)
    8000111c:	84be                	mv	s1,a5
  pop_off();
    8000111e:	61f040ef          	jal	80005f3c <pop_off>
  return p;
}
    80001122:	8526                	mv	a0,s1
    80001124:	60e2                	ld	ra,24(sp)
    80001126:	6442                	ld	s0,16(sp)
    80001128:	64a2                	ld	s1,8(sp)
    8000112a:	6105                	addi	sp,sp,32
    8000112c:	8082                	ret

000000008000112e <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    8000112e:	7179                	addi	sp,sp,-48
    80001130:	f406                	sd	ra,40(sp)
    80001132:	f022                	sd	s0,32(sp)
    80001134:	ec26                	sd	s1,24(sp)
    80001136:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80001138:	fc5ff0ef          	jal	800010fc <myproc>
    8000113c:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    8000113e:	64f040ef          	jal	80005f8c <release>

  if (first) {
    80001142:	00006797          	auipc	a5,0x6
    80001146:	7ae7a783          	lw	a5,1966(a5) # 800078f0 <first.1>
    8000114a:	cf95                	beqz	a5,80001186 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000114c:	4505                	li	a0,1
    8000114e:	601010ef          	jal	80002f4e <fsinit>

    first = 0;
    80001152:	00006797          	auipc	a5,0x6
    80001156:	7807af23          	sw	zero,1950(a5) # 800078f0 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000115a:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    8000115e:	00006797          	auipc	a5,0x6
    80001162:	03a78793          	addi	a5,a5,58 # 80007198 <etext+0x198>
    80001166:	fcf43823          	sd	a5,-48(s0)
    8000116a:	fc043c23          	sd	zero,-40(s0)
    8000116e:	fd040593          	addi	a1,s0,-48
    80001172:	853e                	mv	a0,a5
    80001174:	759020ef          	jal	800040cc <kexec>
    80001178:	6cbc                	ld	a5,88(s1)
    8000117a:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    8000117c:	6cbc                	ld	a5,88(s1)
    8000117e:	7bb8                	ld	a4,112(a5)
    80001180:	57fd                	li	a5,-1
    80001182:	02f70d63          	beq	a4,a5,800011bc <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80001186:	33d000ef          	jal	80001cc2 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000118a:	68a8                	ld	a0,80(s1)
    8000118c:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    8000118e:	04000737          	lui	a4,0x4000
    80001192:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001194:	0732                	slli	a4,a4,0xc
    80001196:	00005797          	auipc	a5,0x5
    8000119a:	f0678793          	addi	a5,a5,-250 # 8000609c <userret>
    8000119e:	00005697          	auipc	a3,0x5
    800011a2:	e6268693          	addi	a3,a3,-414 # 80006000 <_trampoline>
    800011a6:	8f95                	sub	a5,a5,a3
    800011a8:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800011aa:	577d                	li	a4,-1
    800011ac:	177e                	slli	a4,a4,0x3f
    800011ae:	8d59                	or	a0,a0,a4
    800011b0:	9782                	jalr	a5
}
    800011b2:	70a2                	ld	ra,40(sp)
    800011b4:	7402                	ld	s0,32(sp)
    800011b6:	64e2                	ld	s1,24(sp)
    800011b8:	6145                	addi	sp,sp,48
    800011ba:	8082                	ret
      panic("exec");
    800011bc:	00006517          	auipc	a0,0x6
    800011c0:	fe450513          	addi	a0,a0,-28 # 800071a0 <etext+0x1a0>
    800011c4:	273040ef          	jal	80005c36 <panic>

00000000800011c8 <allocpid>:
{
    800011c8:	1101                	addi	sp,sp,-32
    800011ca:	ec06                	sd	ra,24(sp)
    800011cc:	e822                	sd	s0,16(sp)
    800011ce:	e426                	sd	s1,8(sp)
    800011d0:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800011d2:	00006517          	auipc	a0,0x6
    800011d6:	77e50513          	addi	a0,a0,1918 # 80007950 <pid_lock>
    800011da:	51f040ef          	jal	80005ef8 <acquire>
  pid = nextpid;
    800011de:	00006797          	auipc	a5,0x6
    800011e2:	71678793          	addi	a5,a5,1814 # 800078f4 <nextpid>
    800011e6:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800011e8:	0014871b          	addiw	a4,s1,1
    800011ec:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800011ee:	00006517          	auipc	a0,0x6
    800011f2:	76250513          	addi	a0,a0,1890 # 80007950 <pid_lock>
    800011f6:	597040ef          	jal	80005f8c <release>
}
    800011fa:	8526                	mv	a0,s1
    800011fc:	60e2                	ld	ra,24(sp)
    800011fe:	6442                	ld	s0,16(sp)
    80001200:	64a2                	ld	s1,8(sp)
    80001202:	6105                	addi	sp,sp,32
    80001204:	8082                	ret

0000000080001206 <proc_pagetable>:
{
    80001206:	1101                	addi	sp,sp,-32
    80001208:	ec06                	sd	ra,24(sp)
    8000120a:	e822                	sd	s0,16(sp)
    8000120c:	e426                	sd	s1,8(sp)
    8000120e:	e04a                	sd	s2,0(sp)
    80001210:	1000                	addi	s0,sp,32
    80001212:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001214:	c5aff0ef          	jal	8000066e <uvmcreate>
    80001218:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000121a:	cd05                	beqz	a0,80001252 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000121c:	4729                	li	a4,10
    8000121e:	00005697          	auipc	a3,0x5
    80001222:	de268693          	addi	a3,a3,-542 # 80006000 <_trampoline>
    80001226:	6605                	lui	a2,0x1
    80001228:	040005b7          	lui	a1,0x4000
    8000122c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000122e:	05b2                	slli	a1,a1,0xc
    80001230:	a96ff0ef          	jal	800004c6 <mappages>
    80001234:	02054663          	bltz	a0,80001260 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80001238:	4719                	li	a4,6
    8000123a:	05893683          	ld	a3,88(s2)
    8000123e:	6605                	lui	a2,0x1
    80001240:	020005b7          	lui	a1,0x2000
    80001244:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001246:	05b6                	slli	a1,a1,0xd
    80001248:	8526                	mv	a0,s1
    8000124a:	a7cff0ef          	jal	800004c6 <mappages>
    8000124e:	00054f63          	bltz	a0,8000126c <proc_pagetable+0x66>
}
    80001252:	8526                	mv	a0,s1
    80001254:	60e2                	ld	ra,24(sp)
    80001256:	6442                	ld	s0,16(sp)
    80001258:	64a2                	ld	s1,8(sp)
    8000125a:	6902                	ld	s2,0(sp)
    8000125c:	6105                	addi	sp,sp,32
    8000125e:	8082                	ret
    uvmfree(pagetable, 0);
    80001260:	4581                	li	a1,0
    80001262:	8526                	mv	a0,s1
    80001264:	e04ff0ef          	jal	80000868 <uvmfree>
    return 0;
    80001268:	4481                	li	s1,0
    8000126a:	b7e5                	j	80001252 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000126c:	4681                	li	a3,0
    8000126e:	4605                	li	a2,1
    80001270:	040005b7          	lui	a1,0x4000
    80001274:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001276:	05b2                	slli	a1,a1,0xc
    80001278:	8526                	mv	a0,s1
    8000127a:	c1aff0ef          	jal	80000694 <uvmunmap>
    uvmfree(pagetable, 0);
    8000127e:	4581                	li	a1,0
    80001280:	8526                	mv	a0,s1
    80001282:	de6ff0ef          	jal	80000868 <uvmfree>
    return 0;
    80001286:	4481                	li	s1,0
    80001288:	b7e9                	j	80001252 <proc_pagetable+0x4c>

000000008000128a <proc_freepagetable>:
{
    8000128a:	1101                	addi	sp,sp,-32
    8000128c:	ec06                	sd	ra,24(sp)
    8000128e:	e822                	sd	s0,16(sp)
    80001290:	e426                	sd	s1,8(sp)
    80001292:	e04a                	sd	s2,0(sp)
    80001294:	1000                	addi	s0,sp,32
    80001296:	84aa                	mv	s1,a0
    80001298:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000129a:	4681                	li	a3,0
    8000129c:	4605                	li	a2,1
    8000129e:	040005b7          	lui	a1,0x4000
    800012a2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800012a4:	05b2                	slli	a1,a1,0xc
    800012a6:	beeff0ef          	jal	80000694 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800012aa:	4681                	li	a3,0
    800012ac:	4605                	li	a2,1
    800012ae:	020005b7          	lui	a1,0x2000
    800012b2:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800012b4:	05b6                	slli	a1,a1,0xd
    800012b6:	8526                	mv	a0,s1
    800012b8:	bdcff0ef          	jal	80000694 <uvmunmap>
  uvmfree(pagetable, sz);
    800012bc:	85ca                	mv	a1,s2
    800012be:	8526                	mv	a0,s1
    800012c0:	da8ff0ef          	jal	80000868 <uvmfree>
}
    800012c4:	60e2                	ld	ra,24(sp)
    800012c6:	6442                	ld	s0,16(sp)
    800012c8:	64a2                	ld	s1,8(sp)
    800012ca:	6902                	ld	s2,0(sp)
    800012cc:	6105                	addi	sp,sp,32
    800012ce:	8082                	ret

00000000800012d0 <freeproc>:
{
    800012d0:	1101                	addi	sp,sp,-32
    800012d2:	ec06                	sd	ra,24(sp)
    800012d4:	e822                	sd	s0,16(sp)
    800012d6:	e426                	sd	s1,8(sp)
    800012d8:	1000                	addi	s0,sp,32
    800012da:	84aa                	mv	s1,a0
  if(p->trapframe)
    800012dc:	6d28                	ld	a0,88(a0)
    800012de:	c119                	beqz	a0,800012e4 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800012e0:	d3dfe0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    800012e4:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800012e8:	68a8                	ld	a0,80(s1)
    800012ea:	c501                	beqz	a0,800012f2 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800012ec:	64ac                	ld	a1,72(s1)
    800012ee:	f9dff0ef          	jal	8000128a <proc_freepagetable>
  p->pagetable = 0;
    800012f2:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800012f6:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800012fa:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800012fe:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001302:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001306:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000130a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000130e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001312:	0004ac23          	sw	zero,24(s1)
}
    80001316:	60e2                	ld	ra,24(sp)
    80001318:	6442                	ld	s0,16(sp)
    8000131a:	64a2                	ld	s1,8(sp)
    8000131c:	6105                	addi	sp,sp,32
    8000131e:	8082                	ret

0000000080001320 <allocproc>:
{
    80001320:	1101                	addi	sp,sp,-32
    80001322:	ec06                	sd	ra,24(sp)
    80001324:	e822                	sd	s0,16(sp)
    80001326:	e426                	sd	s1,8(sp)
    80001328:	e04a                	sd	s2,0(sp)
    8000132a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000132c:	00007497          	auipc	s1,0x7
    80001330:	a5448493          	addi	s1,s1,-1452 # 80007d80 <proc>
    80001334:	00018917          	auipc	s2,0x18
    80001338:	64c90913          	addi	s2,s2,1612 # 80019980 <tickslock>
    acquire(&p->lock);
    8000133c:	8526                	mv	a0,s1
    8000133e:	3bb040ef          	jal	80005ef8 <acquire>
    if(p->state == UNUSED) {
    80001342:	4c9c                	lw	a5,24(s1)
    80001344:	cb91                	beqz	a5,80001358 <allocproc+0x38>
      release(&p->lock);
    80001346:	8526                	mv	a0,s1
    80001348:	445040ef          	jal	80005f8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000134c:	47048493          	addi	s1,s1,1136
    80001350:	ff2496e3          	bne	s1,s2,8000133c <allocproc+0x1c>
  return 0;
    80001354:	4481                	li	s1,0
    80001356:	a0b9                	j	800013a4 <allocproc+0x84>
  p->pid = allocpid();
    80001358:	e71ff0ef          	jal	800011c8 <allocpid>
    8000135c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000135e:	4785                	li	a5,1
    80001360:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001362:	da3fe0ef          	jal	80000104 <kalloc>
    80001366:	892a                	mv	s2,a0
    80001368:	eca8                	sd	a0,88(s1)
    8000136a:	c521                	beqz	a0,800013b2 <allocproc+0x92>
  p->pagetable = proc_pagetable(p);
    8000136c:	8526                	mv	a0,s1
    8000136e:	e99ff0ef          	jal	80001206 <proc_pagetable>
    80001372:	892a                	mv	s2,a0
    80001374:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80001376:	c531                	beqz	a0,800013c2 <allocproc+0xa2>
  p->mmap_base = TRAPFRAME;
    80001378:	020007b7          	lui	a5,0x2000
    8000137c:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    8000137e:	07b6                	slli	a5,a5,0xd
    80001380:	16f4b423          	sd	a5,360(s1)
  memset(&p->context, 0, sizeof(p->context));
    80001384:	07000613          	li	a2,112
    80001388:	4581                	li	a1,0
    8000138a:	06048513          	addi	a0,s1,96
    8000138e:	dd1fe0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    80001392:	00000797          	auipc	a5,0x0
    80001396:	d9c78793          	addi	a5,a5,-612 # 8000112e <forkret>
    8000139a:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000139c:	60bc                	ld	a5,64(s1)
    8000139e:	6705                	lui	a4,0x1
    800013a0:	97ba                	add	a5,a5,a4
    800013a2:	f4bc                	sd	a5,104(s1)
}
    800013a4:	8526                	mv	a0,s1
    800013a6:	60e2                	ld	ra,24(sp)
    800013a8:	6442                	ld	s0,16(sp)
    800013aa:	64a2                	ld	s1,8(sp)
    800013ac:	6902                	ld	s2,0(sp)
    800013ae:	6105                	addi	sp,sp,32
    800013b0:	8082                	ret
    freeproc(p);
    800013b2:	8526                	mv	a0,s1
    800013b4:	f1dff0ef          	jal	800012d0 <freeproc>
    release(&p->lock);
    800013b8:	8526                	mv	a0,s1
    800013ba:	3d3040ef          	jal	80005f8c <release>
    return 0;
    800013be:	84ca                	mv	s1,s2
    800013c0:	b7d5                	j	800013a4 <allocproc+0x84>
    freeproc(p);
    800013c2:	8526                	mv	a0,s1
    800013c4:	f0dff0ef          	jal	800012d0 <freeproc>
    release(&p->lock);
    800013c8:	8526                	mv	a0,s1
    800013ca:	3c3040ef          	jal	80005f8c <release>
    return 0;
    800013ce:	84ca                	mv	s1,s2
    800013d0:	bfd1                	j	800013a4 <allocproc+0x84>

00000000800013d2 <userinit>:
{
    800013d2:	1101                	addi	sp,sp,-32
    800013d4:	ec06                	sd	ra,24(sp)
    800013d6:	e822                	sd	s0,16(sp)
    800013d8:	e426                	sd	s1,8(sp)
    800013da:	1000                	addi	s0,sp,32
  p = allocproc();
    800013dc:	f45ff0ef          	jal	80001320 <allocproc>
    800013e0:	84aa                	mv	s1,a0
  initproc = p;
    800013e2:	00006797          	auipc	a5,0x6
    800013e6:	52a7b723          	sd	a0,1326(a5) # 80007910 <initproc>
  p->cwd = namei("/");
    800013ea:	00006517          	auipc	a0,0x6
    800013ee:	dbe50513          	addi	a0,a0,-578 # 800071a8 <etext+0x1a8>
    800013f2:	096020ef          	jal	80003488 <namei>
    800013f6:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013fa:	478d                	li	a5,3
    800013fc:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013fe:	8526                	mv	a0,s1
    80001400:	38d040ef          	jal	80005f8c <release>
}
    80001404:	60e2                	ld	ra,24(sp)
    80001406:	6442                	ld	s0,16(sp)
    80001408:	64a2                	ld	s1,8(sp)
    8000140a:	6105                	addi	sp,sp,32
    8000140c:	8082                	ret

000000008000140e <growproc>:
{
    8000140e:	1101                	addi	sp,sp,-32
    80001410:	ec06                	sd	ra,24(sp)
    80001412:	e822                	sd	s0,16(sp)
    80001414:	e426                	sd	s1,8(sp)
    80001416:	e04a                	sd	s2,0(sp)
    80001418:	1000                	addi	s0,sp,32
    8000141a:	892a                	mv	s2,a0
  struct proc *p = myproc();
    8000141c:	ce1ff0ef          	jal	800010fc <myproc>
    80001420:	84aa                	mv	s1,a0
  sz = p->sz;
    80001422:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001424:	01204c63          	bgtz	s2,8000143c <growproc+0x2e>
  } else if(n < 0){
    80001428:	02094463          	bltz	s2,80001450 <growproc+0x42>
  p->sz = sz;
    8000142c:	e4ac                	sd	a1,72(s1)
  return 0;
    8000142e:	4501                	li	a0,0
}
    80001430:	60e2                	ld	ra,24(sp)
    80001432:	6442                	ld	s0,16(sp)
    80001434:	64a2                	ld	s1,8(sp)
    80001436:	6902                	ld	s2,0(sp)
    80001438:	6105                	addi	sp,sp,32
    8000143a:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    8000143c:	4691                	li	a3,4
    8000143e:	00b90633          	add	a2,s2,a1
    80001442:	6928                	ld	a0,80(a0)
    80001444:	b1eff0ef          	jal	80000762 <uvmalloc>
    80001448:	85aa                	mv	a1,a0
    8000144a:	f16d                	bnez	a0,8000142c <growproc+0x1e>
      return -1;
    8000144c:	557d                	li	a0,-1
    8000144e:	b7cd                	j	80001430 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001450:	00b90633          	add	a2,s2,a1
    80001454:	6928                	ld	a0,80(a0)
    80001456:	ac8ff0ef          	jal	8000071e <uvmdealloc>
    8000145a:	85aa                	mv	a1,a0
    8000145c:	bfc1                	j	8000142c <growproc+0x1e>

000000008000145e <kfork>:
{
    8000145e:	7139                	addi	sp,sp,-64
    80001460:	fc06                	sd	ra,56(sp)
    80001462:	f822                	sd	s0,48(sp)
    80001464:	f426                	sd	s1,40(sp)
    80001466:	e456                	sd	s5,8(sp)
    80001468:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000146a:	c93ff0ef          	jal	800010fc <myproc>
    8000146e:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001470:	eb1ff0ef          	jal	80001320 <allocproc>
    80001474:	12050863          	beqz	a0,800015a4 <kfork+0x146>
    80001478:	e852                	sd	s4,16(sp)
    8000147a:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000147c:	048ab603          	ld	a2,72(s5)
    80001480:	692c                	ld	a1,80(a0)
    80001482:	050ab503          	ld	a0,80(s5)
    80001486:	c14ff0ef          	jal	8000089a <uvmcopy>
    8000148a:	02054263          	bltz	a0,800014ae <kfork+0x50>
    8000148e:	f04a                	sd	s2,32(sp)
    80001490:	ec4e                	sd	s3,24(sp)
    80001492:	e05a                	sd	s6,0(sp)
  np->sz = p->sz;
    80001494:	048ab783          	ld	a5,72(s5)
    80001498:	04fa3423          	sd	a5,72(s4)
  for (uint i=0; i < NVMA; i++) {
    8000149c:	170a8493          	addi	s1,s5,368
    800014a0:	170a0913          	addi	s2,s4,368
    800014a4:	470a8993          	addi	s3,s5,1136
      memmove(&np->vma[i], &p->vma[i], sizeof(struct VMA));
    800014a8:	03000b13          	li	s6,48
    800014ac:	a005                	j	800014cc <kfork+0x6e>
    freeproc(np);
    800014ae:	8552                	mv	a0,s4
    800014b0:	e21ff0ef          	jal	800012d0 <freeproc>
    release(&np->lock);
    800014b4:	8552                	mv	a0,s4
    800014b6:	2d7040ef          	jal	80005f8c <release>
    return -1;
    800014ba:	54fd                	li	s1,-1
    800014bc:	6a42                	ld	s4,16(sp)
    800014be:	a8e1                	j	80001596 <kfork+0x138>
  for (uint i=0; i < NVMA; i++) {
    800014c0:	03048493          	addi	s1,s1,48
    800014c4:	03090913          	addi	s2,s2,48
    800014c8:	01348f63          	beq	s1,s3,800014e6 <kfork+0x88>
    if (p->vma[i].valid) {
    800014cc:	409c                	lw	a5,0(s1)
    800014ce:	dbed                	beqz	a5,800014c0 <kfork+0x62>
      memmove(&np->vma[i], &p->vma[i], sizeof(struct VMA));
    800014d0:	865a                	mv	a2,s6
    800014d2:	85a6                	mv	a1,s1
    800014d4:	854a                	mv	a0,s2
    800014d6:	ce9fe0ef          	jal	800001be <memmove>
      p->vma[i].f = filedup(np->vma[i].f);
    800014da:	02093503          	ld	a0,32(s2)
    800014de:	566020ef          	jal	80003a44 <filedup>
    800014e2:	f088                	sd	a0,32(s1)
    800014e4:	bff1                	j	800014c0 <kfork+0x62>
  *(np->trapframe) = *(p->trapframe);
    800014e6:	058ab683          	ld	a3,88(s5)
    800014ea:	87b6                	mv	a5,a3
    800014ec:	058a3703          	ld	a4,88(s4)
    800014f0:	12068693          	addi	a3,a3,288
    800014f4:	6388                	ld	a0,0(a5)
    800014f6:	678c                	ld	a1,8(a5)
    800014f8:	6b90                	ld	a2,16(a5)
    800014fa:	e308                	sd	a0,0(a4)
    800014fc:	e70c                	sd	a1,8(a4)
    800014fe:	eb10                	sd	a2,16(a4)
    80001500:	6f90                	ld	a2,24(a5)
    80001502:	ef10                	sd	a2,24(a4)
    80001504:	02078793          	addi	a5,a5,32
    80001508:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    8000150c:	fed794e3          	bne	a5,a3,800014f4 <kfork+0x96>
  np->trapframe->a0 = 0;
    80001510:	058a3783          	ld	a5,88(s4)
    80001514:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001518:	0d0a8493          	addi	s1,s5,208
    8000151c:	0d0a0913          	addi	s2,s4,208
    80001520:	150a8993          	addi	s3,s5,336
    80001524:	a029                	j	8000152e <kfork+0xd0>
    80001526:	04a1                	addi	s1,s1,8
    80001528:	0921                	addi	s2,s2,8
    8000152a:	01348963          	beq	s1,s3,8000153c <kfork+0xde>
    if(p->ofile[i])
    8000152e:	6088                	ld	a0,0(s1)
    80001530:	d97d                	beqz	a0,80001526 <kfork+0xc8>
      np->ofile[i] = filedup(p->ofile[i]);
    80001532:	512020ef          	jal	80003a44 <filedup>
    80001536:	00a93023          	sd	a0,0(s2)
    8000153a:	b7f5                	j	80001526 <kfork+0xc8>
  np->cwd = idup(p->cwd);
    8000153c:	150ab503          	ld	a0,336(s5)
    80001540:	6e4010ef          	jal	80002c24 <idup>
    80001544:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001548:	4641                	li	a2,16
    8000154a:	158a8593          	addi	a1,s5,344
    8000154e:	158a0513          	addi	a0,s4,344
    80001552:	d61fe0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    80001556:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    8000155a:	8552                	mv	a0,s4
    8000155c:	231040ef          	jal	80005f8c <release>
  acquire(&wait_lock);
    80001560:	00006517          	auipc	a0,0x6
    80001564:	40850513          	addi	a0,a0,1032 # 80007968 <wait_lock>
    80001568:	191040ef          	jal	80005ef8 <acquire>
  np->parent = p;
    8000156c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001570:	00006517          	auipc	a0,0x6
    80001574:	3f850513          	addi	a0,a0,1016 # 80007968 <wait_lock>
    80001578:	215040ef          	jal	80005f8c <release>
  acquire(&np->lock);
    8000157c:	8552                	mv	a0,s4
    8000157e:	17b040ef          	jal	80005ef8 <acquire>
  np->state = RUNNABLE;
    80001582:	478d                	li	a5,3
    80001584:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001588:	8552                	mv	a0,s4
    8000158a:	203040ef          	jal	80005f8c <release>
  return pid;
    8000158e:	7902                	ld	s2,32(sp)
    80001590:	69e2                	ld	s3,24(sp)
    80001592:	6a42                	ld	s4,16(sp)
    80001594:	6b02                	ld	s6,0(sp)
}
    80001596:	8526                	mv	a0,s1
    80001598:	70e2                	ld	ra,56(sp)
    8000159a:	7442                	ld	s0,48(sp)
    8000159c:	74a2                	ld	s1,40(sp)
    8000159e:	6aa2                	ld	s5,8(sp)
    800015a0:	6121                	addi	sp,sp,64
    800015a2:	8082                	ret
    return -1;
    800015a4:	54fd                	li	s1,-1
    800015a6:	bfc5                	j	80001596 <kfork+0x138>

00000000800015a8 <scheduler>:
{
    800015a8:	715d                	addi	sp,sp,-80
    800015aa:	e486                	sd	ra,72(sp)
    800015ac:	e0a2                	sd	s0,64(sp)
    800015ae:	fc26                	sd	s1,56(sp)
    800015b0:	f84a                	sd	s2,48(sp)
    800015b2:	f44e                	sd	s3,40(sp)
    800015b4:	f052                	sd	s4,32(sp)
    800015b6:	ec56                	sd	s5,24(sp)
    800015b8:	e85a                	sd	s6,16(sp)
    800015ba:	e45e                	sd	s7,8(sp)
    800015bc:	e062                	sd	s8,0(sp)
    800015be:	0880                	addi	s0,sp,80
    800015c0:	8792                	mv	a5,tp
  int id = r_tp();
    800015c2:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015c4:	00779b13          	slli	s6,a5,0x7
    800015c8:	00006717          	auipc	a4,0x6
    800015cc:	38870713          	addi	a4,a4,904 # 80007950 <pid_lock>
    800015d0:	975a                	add	a4,a4,s6
    800015d2:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015d6:	00006717          	auipc	a4,0x6
    800015da:	3b270713          	addi	a4,a4,946 # 80007988 <cpus+0x8>
    800015de:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800015e0:	4c11                	li	s8,4
        c->proc = p;
    800015e2:	079e                	slli	a5,a5,0x7
    800015e4:	00006a17          	auipc	s4,0x6
    800015e8:	36ca0a13          	addi	s4,s4,876 # 80007950 <pid_lock>
    800015ec:	9a3e                	add	s4,s4,a5
        found = 1;
    800015ee:	4b85                	li	s7,1
    800015f0:	a83d                	j	8000162e <scheduler+0x86>
      release(&p->lock);
    800015f2:	8526                	mv	a0,s1
    800015f4:	199040ef          	jal	80005f8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015f8:	47048493          	addi	s1,s1,1136
    800015fc:	03248563          	beq	s1,s2,80001626 <scheduler+0x7e>
      acquire(&p->lock);
    80001600:	8526                	mv	a0,s1
    80001602:	0f7040ef          	jal	80005ef8 <acquire>
      if(p->state == RUNNABLE) {
    80001606:	4c9c                	lw	a5,24(s1)
    80001608:	ff3795e3          	bne	a5,s3,800015f2 <scheduler+0x4a>
        p->state = RUNNING;
    8000160c:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001610:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001614:	06048593          	addi	a1,s1,96
    80001618:	855a                	mv	a0,s6
    8000161a:	5fe000ef          	jal	80001c18 <swtch>
        c->proc = 0;
    8000161e:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001622:	8ade                	mv	s5,s7
    80001624:	b7f9                	j	800015f2 <scheduler+0x4a>
    if(found == 0) {
    80001626:	000a9463          	bnez	s5,8000162e <scheduler+0x86>
      asm volatile("wfi");
    8000162a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000162e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001632:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001636:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000163a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000163e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001640:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001644:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001646:	00006497          	auipc	s1,0x6
    8000164a:	73a48493          	addi	s1,s1,1850 # 80007d80 <proc>
      if(p->state == RUNNABLE) {
    8000164e:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001650:	00018917          	auipc	s2,0x18
    80001654:	33090913          	addi	s2,s2,816 # 80019980 <tickslock>
    80001658:	b765                	j	80001600 <scheduler+0x58>

000000008000165a <sched>:
{
    8000165a:	7179                	addi	sp,sp,-48
    8000165c:	f406                	sd	ra,40(sp)
    8000165e:	f022                	sd	s0,32(sp)
    80001660:	ec26                	sd	s1,24(sp)
    80001662:	e84a                	sd	s2,16(sp)
    80001664:	e44e                	sd	s3,8(sp)
    80001666:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001668:	a95ff0ef          	jal	800010fc <myproc>
    8000166c:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000166e:	01b040ef          	jal	80005e88 <holding>
    80001672:	c935                	beqz	a0,800016e6 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001674:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001676:	2781                	sext.w	a5,a5
    80001678:	079e                	slli	a5,a5,0x7
    8000167a:	00006717          	auipc	a4,0x6
    8000167e:	2d670713          	addi	a4,a4,726 # 80007950 <pid_lock>
    80001682:	97ba                	add	a5,a5,a4
    80001684:	0a87a703          	lw	a4,168(a5)
    80001688:	4785                	li	a5,1
    8000168a:	06f71463          	bne	a4,a5,800016f2 <sched+0x98>
  if(p->state == RUNNING)
    8000168e:	4c98                	lw	a4,24(s1)
    80001690:	4791                	li	a5,4
    80001692:	06f70663          	beq	a4,a5,800016fe <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001696:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000169a:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000169c:	e7bd                	bnez	a5,8000170a <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000169e:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800016a0:	00006917          	auipc	s2,0x6
    800016a4:	2b090913          	addi	s2,s2,688 # 80007950 <pid_lock>
    800016a8:	2781                	sext.w	a5,a5
    800016aa:	079e                	slli	a5,a5,0x7
    800016ac:	97ca                	add	a5,a5,s2
    800016ae:	0ac7a983          	lw	s3,172(a5)
    800016b2:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016b4:	2781                	sext.w	a5,a5
    800016b6:	079e                	slli	a5,a5,0x7
    800016b8:	07a1                	addi	a5,a5,8
    800016ba:	00006597          	auipc	a1,0x6
    800016be:	2c658593          	addi	a1,a1,710 # 80007980 <cpus>
    800016c2:	95be                	add	a1,a1,a5
    800016c4:	06048513          	addi	a0,s1,96
    800016c8:	550000ef          	jal	80001c18 <swtch>
    800016cc:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016ce:	2781                	sext.w	a5,a5
    800016d0:	079e                	slli	a5,a5,0x7
    800016d2:	993e                	add	s2,s2,a5
    800016d4:	0b392623          	sw	s3,172(s2)
}
    800016d8:	70a2                	ld	ra,40(sp)
    800016da:	7402                	ld	s0,32(sp)
    800016dc:	64e2                	ld	s1,24(sp)
    800016de:	6942                	ld	s2,16(sp)
    800016e0:	69a2                	ld	s3,8(sp)
    800016e2:	6145                	addi	sp,sp,48
    800016e4:	8082                	ret
    panic("sched p->lock");
    800016e6:	00006517          	auipc	a0,0x6
    800016ea:	aca50513          	addi	a0,a0,-1334 # 800071b0 <etext+0x1b0>
    800016ee:	548040ef          	jal	80005c36 <panic>
    panic("sched locks");
    800016f2:	00006517          	auipc	a0,0x6
    800016f6:	ace50513          	addi	a0,a0,-1330 # 800071c0 <etext+0x1c0>
    800016fa:	53c040ef          	jal	80005c36 <panic>
    panic("sched RUNNING");
    800016fe:	00006517          	auipc	a0,0x6
    80001702:	ad250513          	addi	a0,a0,-1326 # 800071d0 <etext+0x1d0>
    80001706:	530040ef          	jal	80005c36 <panic>
    panic("sched interruptible");
    8000170a:	00006517          	auipc	a0,0x6
    8000170e:	ad650513          	addi	a0,a0,-1322 # 800071e0 <etext+0x1e0>
    80001712:	524040ef          	jal	80005c36 <panic>

0000000080001716 <yield>:
{
    80001716:	1101                	addi	sp,sp,-32
    80001718:	ec06                	sd	ra,24(sp)
    8000171a:	e822                	sd	s0,16(sp)
    8000171c:	e426                	sd	s1,8(sp)
    8000171e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001720:	9ddff0ef          	jal	800010fc <myproc>
    80001724:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001726:	7d2040ef          	jal	80005ef8 <acquire>
  p->state = RUNNABLE;
    8000172a:	478d                	li	a5,3
    8000172c:	cc9c                	sw	a5,24(s1)
  sched();
    8000172e:	f2dff0ef          	jal	8000165a <sched>
  release(&p->lock);
    80001732:	8526                	mv	a0,s1
    80001734:	059040ef          	jal	80005f8c <release>
}
    80001738:	60e2                	ld	ra,24(sp)
    8000173a:	6442                	ld	s0,16(sp)
    8000173c:	64a2                	ld	s1,8(sp)
    8000173e:	6105                	addi	sp,sp,32
    80001740:	8082                	ret

0000000080001742 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001742:	7179                	addi	sp,sp,-48
    80001744:	f406                	sd	ra,40(sp)
    80001746:	f022                	sd	s0,32(sp)
    80001748:	ec26                	sd	s1,24(sp)
    8000174a:	e84a                	sd	s2,16(sp)
    8000174c:	e44e                	sd	s3,8(sp)
    8000174e:	1800                	addi	s0,sp,48
    80001750:	89aa                	mv	s3,a0
    80001752:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001754:	9a9ff0ef          	jal	800010fc <myproc>
    80001758:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000175a:	79e040ef          	jal	80005ef8 <acquire>
  release(lk);
    8000175e:	854a                	mv	a0,s2
    80001760:	02d040ef          	jal	80005f8c <release>

  // Go to sleep.
  p->chan = chan;
    80001764:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001768:	4789                	li	a5,2
    8000176a:	cc9c                	sw	a5,24(s1)

  sched();
    8000176c:	eefff0ef          	jal	8000165a <sched>

  // Tidy up.
  p->chan = 0;
    80001770:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001774:	8526                	mv	a0,s1
    80001776:	017040ef          	jal	80005f8c <release>
  acquire(lk);
    8000177a:	854a                	mv	a0,s2
    8000177c:	77c040ef          	jal	80005ef8 <acquire>
}
    80001780:	70a2                	ld	ra,40(sp)
    80001782:	7402                	ld	s0,32(sp)
    80001784:	64e2                	ld	s1,24(sp)
    80001786:	6942                	ld	s2,16(sp)
    80001788:	69a2                	ld	s3,8(sp)
    8000178a:	6145                	addi	sp,sp,48
    8000178c:	8082                	ret

000000008000178e <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    8000178e:	7139                	addi	sp,sp,-64
    80001790:	fc06                	sd	ra,56(sp)
    80001792:	f822                	sd	s0,48(sp)
    80001794:	f426                	sd	s1,40(sp)
    80001796:	f04a                	sd	s2,32(sp)
    80001798:	ec4e                	sd	s3,24(sp)
    8000179a:	e852                	sd	s4,16(sp)
    8000179c:	e456                	sd	s5,8(sp)
    8000179e:	0080                	addi	s0,sp,64
    800017a0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800017a2:	00006497          	auipc	s1,0x6
    800017a6:	5de48493          	addi	s1,s1,1502 # 80007d80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800017aa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017ac:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017ae:	00018917          	auipc	s2,0x18
    800017b2:	1d290913          	addi	s2,s2,466 # 80019980 <tickslock>
    800017b6:	a801                	j	800017c6 <wakeup+0x38>
      }
      release(&p->lock);
    800017b8:	8526                	mv	a0,s1
    800017ba:	7d2040ef          	jal	80005f8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017be:	47048493          	addi	s1,s1,1136
    800017c2:	03248263          	beq	s1,s2,800017e6 <wakeup+0x58>
    if(p != myproc()){
    800017c6:	937ff0ef          	jal	800010fc <myproc>
    800017ca:	fe950ae3          	beq	a0,s1,800017be <wakeup+0x30>
      acquire(&p->lock);
    800017ce:	8526                	mv	a0,s1
    800017d0:	728040ef          	jal	80005ef8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017d4:	4c9c                	lw	a5,24(s1)
    800017d6:	ff3791e3          	bne	a5,s3,800017b8 <wakeup+0x2a>
    800017da:	709c                	ld	a5,32(s1)
    800017dc:	fd479ee3          	bne	a5,s4,800017b8 <wakeup+0x2a>
        p->state = RUNNABLE;
    800017e0:	0154ac23          	sw	s5,24(s1)
    800017e4:	bfd1                	j	800017b8 <wakeup+0x2a>
    }
  }
}
    800017e6:	70e2                	ld	ra,56(sp)
    800017e8:	7442                	ld	s0,48(sp)
    800017ea:	74a2                	ld	s1,40(sp)
    800017ec:	7902                	ld	s2,32(sp)
    800017ee:	69e2                	ld	s3,24(sp)
    800017f0:	6a42                	ld	s4,16(sp)
    800017f2:	6aa2                	ld	s5,8(sp)
    800017f4:	6121                	addi	sp,sp,64
    800017f6:	8082                	ret

00000000800017f8 <reparent>:
{
    800017f8:	7179                	addi	sp,sp,-48
    800017fa:	f406                	sd	ra,40(sp)
    800017fc:	f022                	sd	s0,32(sp)
    800017fe:	ec26                	sd	s1,24(sp)
    80001800:	e84a                	sd	s2,16(sp)
    80001802:	e44e                	sd	s3,8(sp)
    80001804:	e052                	sd	s4,0(sp)
    80001806:	1800                	addi	s0,sp,48
    80001808:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000180a:	00006497          	auipc	s1,0x6
    8000180e:	57648493          	addi	s1,s1,1398 # 80007d80 <proc>
      pp->parent = initproc;
    80001812:	00006a17          	auipc	s4,0x6
    80001816:	0fea0a13          	addi	s4,s4,254 # 80007910 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000181a:	00018997          	auipc	s3,0x18
    8000181e:	16698993          	addi	s3,s3,358 # 80019980 <tickslock>
    80001822:	a029                	j	8000182c <reparent+0x34>
    80001824:	47048493          	addi	s1,s1,1136
    80001828:	01348b63          	beq	s1,s3,8000183e <reparent+0x46>
    if(pp->parent == p){
    8000182c:	7c9c                	ld	a5,56(s1)
    8000182e:	ff279be3          	bne	a5,s2,80001824 <reparent+0x2c>
      pp->parent = initproc;
    80001832:	000a3503          	ld	a0,0(s4)
    80001836:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001838:	f57ff0ef          	jal	8000178e <wakeup>
    8000183c:	b7e5                	j	80001824 <reparent+0x2c>
}
    8000183e:	70a2                	ld	ra,40(sp)
    80001840:	7402                	ld	s0,32(sp)
    80001842:	64e2                	ld	s1,24(sp)
    80001844:	6942                	ld	s2,16(sp)
    80001846:	69a2                	ld	s3,8(sp)
    80001848:	6a02                	ld	s4,0(sp)
    8000184a:	6145                	addi	sp,sp,48
    8000184c:	8082                	ret

000000008000184e <kexit>:
{
    8000184e:	7139                	addi	sp,sp,-64
    80001850:	fc06                	sd	ra,56(sp)
    80001852:	f822                	sd	s0,48(sp)
    80001854:	f426                	sd	s1,40(sp)
    80001856:	f04a                	sd	s2,32(sp)
    80001858:	ec4e                	sd	s3,24(sp)
    8000185a:	e456                	sd	s5,8(sp)
    8000185c:	0080                	addi	s0,sp,64
    8000185e:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80001860:	89dff0ef          	jal	800010fc <myproc>
    80001864:	892a                	mv	s2,a0
  if(p == initproc)
    80001866:	00006797          	auipc	a5,0x6
    8000186a:	0aa7b783          	ld	a5,170(a5) # 80007910 <initproc>
    8000186e:	0d050493          	addi	s1,a0,208
    80001872:	15050993          	addi	s3,a0,336
    80001876:	00a78563          	beq	a5,a0,80001880 <kexit+0x32>
    8000187a:	e852                	sd	s4,16(sp)
    8000187c:	e05a                	sd	s6,0(sp)
    8000187e:	a821                	j	80001896 <kexit+0x48>
    80001880:	e852                	sd	s4,16(sp)
    80001882:	e05a                	sd	s6,0(sp)
    panic("init exiting");
    80001884:	00006517          	auipc	a0,0x6
    80001888:	97450513          	addi	a0,a0,-1676 # 800071f8 <etext+0x1f8>
    8000188c:	3aa040ef          	jal	80005c36 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001890:	04a1                	addi	s1,s1,8
    80001892:	01348963          	beq	s1,s3,800018a4 <kexit+0x56>
    if(p->ofile[fd]){
    80001896:	6088                	ld	a0,0(s1)
    80001898:	dd65                	beqz	a0,80001890 <kexit+0x42>
      fileclose(f);
    8000189a:	1f0020ef          	jal	80003a8a <fileclose>
      p->ofile[fd] = 0;
    8000189e:	0004b023          	sd	zero,0(s1)
    800018a2:	b7fd                	j	80001890 <kexit+0x42>
    800018a4:	17090493          	addi	s1,s2,368
    800018a8:	47090993          	addi	s3,s2,1136
    if (uvmunmap_vma(p->pagetable, vma, vma->start, vma->end) == -1)
    800018ac:	5a7d                	li	s4,-1
      printf("kexit: failed to unmap vma");
    800018ae:	00006b17          	auipc	s6,0x6
    800018b2:	95ab0b13          	addi	s6,s6,-1702 # 80007208 <etext+0x208>
    800018b6:	a029                	j	800018c0 <kexit+0x72>
  for (uint i=0; i < NVMA; i++) {
    800018b8:	03048493          	addi	s1,s1,48
    800018bc:	03348163          	beq	s1,s3,800018de <kexit+0x90>
    if (vma->valid == 0)
    800018c0:	409c                	lw	a5,0(s1)
    800018c2:	dbfd                	beqz	a5,800018b8 <kexit+0x6a>
    if (uvmunmap_vma(p->pagetable, vma, vma->start, vma->end) == -1)
    800018c4:	6894                	ld	a3,16(s1)
    800018c6:	6490                	ld	a2,8(s1)
    800018c8:	85a6                	mv	a1,s1
    800018ca:	05093503          	ld	a0,80(s2)
    800018ce:	c9cff0ef          	jal	80000d6a <uvmunmap_vma>
    800018d2:	ff4513e3          	bne	a0,s4,800018b8 <kexit+0x6a>
      printf("kexit: failed to unmap vma");
    800018d6:	855a                	mv	a0,s6
    800018d8:	034040ef          	jal	8000590c <printf>
    800018dc:	bff1                	j	800018b8 <kexit+0x6a>
  begin_op();
    800018de:	589010ef          	jal	80003666 <begin_op>
  iput(p->cwd);
    800018e2:	15093503          	ld	a0,336(s2)
    800018e6:	4f6010ef          	jal	80002ddc <iput>
  end_op();
    800018ea:	5ed010ef          	jal	800036d6 <end_op>
  p->cwd = 0;
    800018ee:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    800018f2:	00006517          	auipc	a0,0x6
    800018f6:	07650513          	addi	a0,a0,118 # 80007968 <wait_lock>
    800018fa:	5fe040ef          	jal	80005ef8 <acquire>
  reparent(p);
    800018fe:	854a                	mv	a0,s2
    80001900:	ef9ff0ef          	jal	800017f8 <reparent>
  wakeup(p->parent);
    80001904:	03893503          	ld	a0,56(s2)
    80001908:	e87ff0ef          	jal	8000178e <wakeup>
  acquire(&p->lock);
    8000190c:	854a                	mv	a0,s2
    8000190e:	5ea040ef          	jal	80005ef8 <acquire>
  p->xstate = status;
    80001912:	03592623          	sw	s5,44(s2)
  p->state = ZOMBIE;
    80001916:	4795                	li	a5,5
    80001918:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    8000191c:	00006517          	auipc	a0,0x6
    80001920:	04c50513          	addi	a0,a0,76 # 80007968 <wait_lock>
    80001924:	668040ef          	jal	80005f8c <release>
  sched();
    80001928:	d33ff0ef          	jal	8000165a <sched>
  panic("zombie exit");
    8000192c:	00006517          	auipc	a0,0x6
    80001930:	8fc50513          	addi	a0,a0,-1796 # 80007228 <etext+0x228>
    80001934:	302040ef          	jal	80005c36 <panic>

0000000080001938 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001938:	7179                	addi	sp,sp,-48
    8000193a:	f406                	sd	ra,40(sp)
    8000193c:	f022                	sd	s0,32(sp)
    8000193e:	ec26                	sd	s1,24(sp)
    80001940:	e84a                	sd	s2,16(sp)
    80001942:	e44e                	sd	s3,8(sp)
    80001944:	1800                	addi	s0,sp,48
    80001946:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001948:	00006497          	auipc	s1,0x6
    8000194c:	43848493          	addi	s1,s1,1080 # 80007d80 <proc>
    80001950:	00018997          	auipc	s3,0x18
    80001954:	03098993          	addi	s3,s3,48 # 80019980 <tickslock>
    acquire(&p->lock);
    80001958:	8526                	mv	a0,s1
    8000195a:	59e040ef          	jal	80005ef8 <acquire>
    if(p->pid == pid){
    8000195e:	589c                	lw	a5,48(s1)
    80001960:	01278b63          	beq	a5,s2,80001976 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001964:	8526                	mv	a0,s1
    80001966:	626040ef          	jal	80005f8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000196a:	47048493          	addi	s1,s1,1136
    8000196e:	ff3495e3          	bne	s1,s3,80001958 <kkill+0x20>
  }
  return -1;
    80001972:	557d                	li	a0,-1
    80001974:	a819                	j	8000198a <kkill+0x52>
      p->killed = 1;
    80001976:	4785                	li	a5,1
    80001978:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000197a:	4c98                	lw	a4,24(s1)
    8000197c:	4789                	li	a5,2
    8000197e:	00f70d63          	beq	a4,a5,80001998 <kkill+0x60>
      release(&p->lock);
    80001982:	8526                	mv	a0,s1
    80001984:	608040ef          	jal	80005f8c <release>
      return 0;
    80001988:	4501                	li	a0,0
}
    8000198a:	70a2                	ld	ra,40(sp)
    8000198c:	7402                	ld	s0,32(sp)
    8000198e:	64e2                	ld	s1,24(sp)
    80001990:	6942                	ld	s2,16(sp)
    80001992:	69a2                	ld	s3,8(sp)
    80001994:	6145                	addi	sp,sp,48
    80001996:	8082                	ret
        p->state = RUNNABLE;
    80001998:	478d                	li	a5,3
    8000199a:	cc9c                	sw	a5,24(s1)
    8000199c:	b7dd                	j	80001982 <kkill+0x4a>

000000008000199e <setkilled>:

void
setkilled(struct proc *p)
{
    8000199e:	1101                	addi	sp,sp,-32
    800019a0:	ec06                	sd	ra,24(sp)
    800019a2:	e822                	sd	s0,16(sp)
    800019a4:	e426                	sd	s1,8(sp)
    800019a6:	1000                	addi	s0,sp,32
    800019a8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019aa:	54e040ef          	jal	80005ef8 <acquire>
  p->killed = 1;
    800019ae:	4785                	li	a5,1
    800019b0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019b2:	8526                	mv	a0,s1
    800019b4:	5d8040ef          	jal	80005f8c <release>
}
    800019b8:	60e2                	ld	ra,24(sp)
    800019ba:	6442                	ld	s0,16(sp)
    800019bc:	64a2                	ld	s1,8(sp)
    800019be:	6105                	addi	sp,sp,32
    800019c0:	8082                	ret

00000000800019c2 <killed>:

int
killed(struct proc *p)
{
    800019c2:	1101                	addi	sp,sp,-32
    800019c4:	ec06                	sd	ra,24(sp)
    800019c6:	e822                	sd	s0,16(sp)
    800019c8:	e426                	sd	s1,8(sp)
    800019ca:	e04a                	sd	s2,0(sp)
    800019cc:	1000                	addi	s0,sp,32
    800019ce:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800019d0:	528040ef          	jal	80005ef8 <acquire>
  k = p->killed;
    800019d4:	549c                	lw	a5,40(s1)
    800019d6:	893e                	mv	s2,a5
  release(&p->lock);
    800019d8:	8526                	mv	a0,s1
    800019da:	5b2040ef          	jal	80005f8c <release>
  return k;
}
    800019de:	854a                	mv	a0,s2
    800019e0:	60e2                	ld	ra,24(sp)
    800019e2:	6442                	ld	s0,16(sp)
    800019e4:	64a2                	ld	s1,8(sp)
    800019e6:	6902                	ld	s2,0(sp)
    800019e8:	6105                	addi	sp,sp,32
    800019ea:	8082                	ret

00000000800019ec <kwait>:
{
    800019ec:	715d                	addi	sp,sp,-80
    800019ee:	e486                	sd	ra,72(sp)
    800019f0:	e0a2                	sd	s0,64(sp)
    800019f2:	fc26                	sd	s1,56(sp)
    800019f4:	f84a                	sd	s2,48(sp)
    800019f6:	f44e                	sd	s3,40(sp)
    800019f8:	f052                	sd	s4,32(sp)
    800019fa:	ec56                	sd	s5,24(sp)
    800019fc:	e85a                	sd	s6,16(sp)
    800019fe:	e45e                	sd	s7,8(sp)
    80001a00:	0880                	addi	s0,sp,80
    80001a02:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001a04:	ef8ff0ef          	jal	800010fc <myproc>
    80001a08:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a0a:	00006517          	auipc	a0,0x6
    80001a0e:	f5e50513          	addi	a0,a0,-162 # 80007968 <wait_lock>
    80001a12:	4e6040ef          	jal	80005ef8 <acquire>
        if(pp->state == ZOMBIE){
    80001a16:	4a15                	li	s4,5
        havekids = 1;
    80001a18:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a1a:	00018997          	auipc	s3,0x18
    80001a1e:	f6698993          	addi	s3,s3,-154 # 80019980 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a22:	00006b17          	auipc	s6,0x6
    80001a26:	f46b0b13          	addi	s6,s6,-186 # 80007968 <wait_lock>
    80001a2a:	a869                	j	80001ac4 <kwait+0xd8>
          pid = pp->pid;
    80001a2c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a30:	000b8c63          	beqz	s7,80001a48 <kwait+0x5c>
    80001a34:	4691                	li	a3,4
    80001a36:	02c48613          	addi	a2,s1,44
    80001a3a:	85de                	mv	a1,s7
    80001a3c:	05093503          	ld	a0,80(s2)
    80001a40:	9deff0ef          	jal	80000c1e <copyout>
    80001a44:	02054a63          	bltz	a0,80001a78 <kwait+0x8c>
          freeproc(pp);
    80001a48:	8526                	mv	a0,s1
    80001a4a:	887ff0ef          	jal	800012d0 <freeproc>
          release(&pp->lock);
    80001a4e:	8526                	mv	a0,s1
    80001a50:	53c040ef          	jal	80005f8c <release>
          release(&wait_lock);
    80001a54:	00006517          	auipc	a0,0x6
    80001a58:	f1450513          	addi	a0,a0,-236 # 80007968 <wait_lock>
    80001a5c:	530040ef          	jal	80005f8c <release>
}
    80001a60:	854e                	mv	a0,s3
    80001a62:	60a6                	ld	ra,72(sp)
    80001a64:	6406                	ld	s0,64(sp)
    80001a66:	74e2                	ld	s1,56(sp)
    80001a68:	7942                	ld	s2,48(sp)
    80001a6a:	79a2                	ld	s3,40(sp)
    80001a6c:	7a02                	ld	s4,32(sp)
    80001a6e:	6ae2                	ld	s5,24(sp)
    80001a70:	6b42                	ld	s6,16(sp)
    80001a72:	6ba2                	ld	s7,8(sp)
    80001a74:	6161                	addi	sp,sp,80
    80001a76:	8082                	ret
            release(&pp->lock);
    80001a78:	8526                	mv	a0,s1
    80001a7a:	512040ef          	jal	80005f8c <release>
            release(&wait_lock);
    80001a7e:	00006517          	auipc	a0,0x6
    80001a82:	eea50513          	addi	a0,a0,-278 # 80007968 <wait_lock>
    80001a86:	506040ef          	jal	80005f8c <release>
            return -1;
    80001a8a:	59fd                	li	s3,-1
    80001a8c:	bfd1                	j	80001a60 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a8e:	47048493          	addi	s1,s1,1136
    80001a92:	03348063          	beq	s1,s3,80001ab2 <kwait+0xc6>
      if(pp->parent == p){
    80001a96:	7c9c                	ld	a5,56(s1)
    80001a98:	ff279be3          	bne	a5,s2,80001a8e <kwait+0xa2>
        acquire(&pp->lock);
    80001a9c:	8526                	mv	a0,s1
    80001a9e:	45a040ef          	jal	80005ef8 <acquire>
        if(pp->state == ZOMBIE){
    80001aa2:	4c9c                	lw	a5,24(s1)
    80001aa4:	f94784e3          	beq	a5,s4,80001a2c <kwait+0x40>
        release(&pp->lock);
    80001aa8:	8526                	mv	a0,s1
    80001aaa:	4e2040ef          	jal	80005f8c <release>
        havekids = 1;
    80001aae:	8756                	mv	a4,s5
    80001ab0:	bff9                	j	80001a8e <kwait+0xa2>
    if(!havekids || killed(p)){
    80001ab2:	cf19                	beqz	a4,80001ad0 <kwait+0xe4>
    80001ab4:	854a                	mv	a0,s2
    80001ab6:	f0dff0ef          	jal	800019c2 <killed>
    80001aba:	e919                	bnez	a0,80001ad0 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001abc:	85da                	mv	a1,s6
    80001abe:	854a                	mv	a0,s2
    80001ac0:	c83ff0ef          	jal	80001742 <sleep>
    havekids = 0;
    80001ac4:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ac6:	00006497          	auipc	s1,0x6
    80001aca:	2ba48493          	addi	s1,s1,698 # 80007d80 <proc>
    80001ace:	b7e1                	j	80001a96 <kwait+0xaa>
      release(&wait_lock);
    80001ad0:	00006517          	auipc	a0,0x6
    80001ad4:	e9850513          	addi	a0,a0,-360 # 80007968 <wait_lock>
    80001ad8:	4b4040ef          	jal	80005f8c <release>
      return -1;
    80001adc:	59fd                	li	s3,-1
    80001ade:	b749                	j	80001a60 <kwait+0x74>

0000000080001ae0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001ae0:	7179                	addi	sp,sp,-48
    80001ae2:	f406                	sd	ra,40(sp)
    80001ae4:	f022                	sd	s0,32(sp)
    80001ae6:	ec26                	sd	s1,24(sp)
    80001ae8:	e84a                	sd	s2,16(sp)
    80001aea:	e44e                	sd	s3,8(sp)
    80001aec:	e052                	sd	s4,0(sp)
    80001aee:	1800                	addi	s0,sp,48
    80001af0:	84aa                	mv	s1,a0
    80001af2:	8a2e                	mv	s4,a1
    80001af4:	89b2                	mv	s3,a2
    80001af6:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001af8:	e04ff0ef          	jal	800010fc <myproc>
  if(user_dst){
    80001afc:	cc99                	beqz	s1,80001b1a <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001afe:	86ca                	mv	a3,s2
    80001b00:	864e                	mv	a2,s3
    80001b02:	85d2                	mv	a1,s4
    80001b04:	6928                	ld	a0,80(a0)
    80001b06:	918ff0ef          	jal	80000c1e <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b0a:	70a2                	ld	ra,40(sp)
    80001b0c:	7402                	ld	s0,32(sp)
    80001b0e:	64e2                	ld	s1,24(sp)
    80001b10:	6942                	ld	s2,16(sp)
    80001b12:	69a2                	ld	s3,8(sp)
    80001b14:	6a02                	ld	s4,0(sp)
    80001b16:	6145                	addi	sp,sp,48
    80001b18:	8082                	ret
    memmove((char *)dst, src, len);
    80001b1a:	0009061b          	sext.w	a2,s2
    80001b1e:	85ce                	mv	a1,s3
    80001b20:	8552                	mv	a0,s4
    80001b22:	e9cfe0ef          	jal	800001be <memmove>
    return 0;
    80001b26:	8526                	mv	a0,s1
    80001b28:	b7cd                	j	80001b0a <either_copyout+0x2a>

0000000080001b2a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b2a:	7179                	addi	sp,sp,-48
    80001b2c:	f406                	sd	ra,40(sp)
    80001b2e:	f022                	sd	s0,32(sp)
    80001b30:	ec26                	sd	s1,24(sp)
    80001b32:	e84a                	sd	s2,16(sp)
    80001b34:	e44e                	sd	s3,8(sp)
    80001b36:	e052                	sd	s4,0(sp)
    80001b38:	1800                	addi	s0,sp,48
    80001b3a:	8a2a                	mv	s4,a0
    80001b3c:	84ae                	mv	s1,a1
    80001b3e:	89b2                	mv	s3,a2
    80001b40:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001b42:	dbaff0ef          	jal	800010fc <myproc>
  if(user_src){
    80001b46:	cc99                	beqz	s1,80001b64 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001b48:	86ca                	mv	a3,s2
    80001b4a:	864e                	mv	a2,s3
    80001b4c:	85d2                	mv	a1,s4
    80001b4e:	6928                	ld	a0,80(a0)
    80001b50:	98cff0ef          	jal	80000cdc <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b54:	70a2                	ld	ra,40(sp)
    80001b56:	7402                	ld	s0,32(sp)
    80001b58:	64e2                	ld	s1,24(sp)
    80001b5a:	6942                	ld	s2,16(sp)
    80001b5c:	69a2                	ld	s3,8(sp)
    80001b5e:	6a02                	ld	s4,0(sp)
    80001b60:	6145                	addi	sp,sp,48
    80001b62:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b64:	0009061b          	sext.w	a2,s2
    80001b68:	85ce                	mv	a1,s3
    80001b6a:	8552                	mv	a0,s4
    80001b6c:	e52fe0ef          	jal	800001be <memmove>
    return 0;
    80001b70:	8526                	mv	a0,s1
    80001b72:	b7cd                	j	80001b54 <either_copyin+0x2a>

0000000080001b74 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b74:	715d                	addi	sp,sp,-80
    80001b76:	e486                	sd	ra,72(sp)
    80001b78:	e0a2                	sd	s0,64(sp)
    80001b7a:	fc26                	sd	s1,56(sp)
    80001b7c:	f84a                	sd	s2,48(sp)
    80001b7e:	f44e                	sd	s3,40(sp)
    80001b80:	f052                	sd	s4,32(sp)
    80001b82:	ec56                	sd	s5,24(sp)
    80001b84:	e85a                	sd	s6,16(sp)
    80001b86:	e45e                	sd	s7,8(sp)
    80001b88:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b8a:	00005517          	auipc	a0,0x5
    80001b8e:	48e50513          	addi	a0,a0,1166 # 80007018 <etext+0x18>
    80001b92:	57b030ef          	jal	8000590c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b96:	00006497          	auipc	s1,0x6
    80001b9a:	34248493          	addi	s1,s1,834 # 80007ed8 <proc+0x158>
    80001b9e:	00018917          	auipc	s2,0x18
    80001ba2:	f3a90913          	addi	s2,s2,-198 # 80019ad8 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001ba6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001ba8:	00005997          	auipc	s3,0x5
    80001bac:	69098993          	addi	s3,s3,1680 # 80007238 <etext+0x238>
    printf("%d %s %s", p->pid, state, p->name);
    80001bb0:	00005a97          	auipc	s5,0x5
    80001bb4:	690a8a93          	addi	s5,s5,1680 # 80007240 <etext+0x240>
    printf("\n");
    80001bb8:	00005a17          	auipc	s4,0x5
    80001bbc:	460a0a13          	addi	s4,s4,1120 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bc0:	00006b97          	auipc	s7,0x6
    80001bc4:	c08b8b93          	addi	s7,s7,-1016 # 800077c8 <states.0>
    80001bc8:	a829                	j	80001be2 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001bca:	ed86a583          	lw	a1,-296(a3)
    80001bce:	8556                	mv	a0,s5
    80001bd0:	53d030ef          	jal	8000590c <printf>
    printf("\n");
    80001bd4:	8552                	mv	a0,s4
    80001bd6:	537030ef          	jal	8000590c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bda:	47048493          	addi	s1,s1,1136
    80001bde:	03248263          	beq	s1,s2,80001c02 <procdump+0x8e>
    if(p->state == UNUSED)
    80001be2:	86a6                	mv	a3,s1
    80001be4:	ec04a783          	lw	a5,-320(s1)
    80001be8:	dbed                	beqz	a5,80001bda <procdump+0x66>
      state = "???";
    80001bea:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bec:	fcfb6fe3          	bltu	s6,a5,80001bca <procdump+0x56>
    80001bf0:	02079713          	slli	a4,a5,0x20
    80001bf4:	01d75793          	srli	a5,a4,0x1d
    80001bf8:	97de                	add	a5,a5,s7
    80001bfa:	6390                	ld	a2,0(a5)
    80001bfc:	f679                	bnez	a2,80001bca <procdump+0x56>
      state = "???";
    80001bfe:	864e                	mv	a2,s3
    80001c00:	b7e9                	j	80001bca <procdump+0x56>
  }
}
    80001c02:	60a6                	ld	ra,72(sp)
    80001c04:	6406                	ld	s0,64(sp)
    80001c06:	74e2                	ld	s1,56(sp)
    80001c08:	7942                	ld	s2,48(sp)
    80001c0a:	79a2                	ld	s3,40(sp)
    80001c0c:	7a02                	ld	s4,32(sp)
    80001c0e:	6ae2                	ld	s5,24(sp)
    80001c10:	6b42                	ld	s6,16(sp)
    80001c12:	6ba2                	ld	s7,8(sp)
    80001c14:	6161                	addi	sp,sp,80
    80001c16:	8082                	ret

0000000080001c18 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001c18:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001c1c:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001c20:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001c22:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001c24:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001c28:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001c2c:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001c30:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001c34:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001c38:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001c3c:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001c40:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001c44:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001c48:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001c4c:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001c50:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001c54:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001c56:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001c58:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001c5c:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001c60:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001c64:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001c68:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001c6c:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001c70:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001c74:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001c78:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001c7c:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001c80:	8082                	ret

0000000080001c82 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c82:	1141                	addi	sp,sp,-16
    80001c84:	e406                	sd	ra,8(sp)
    80001c86:	e022                	sd	s0,0(sp)
    80001c88:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c8a:	00005597          	auipc	a1,0x5
    80001c8e:	5f658593          	addi	a1,a1,1526 # 80007280 <etext+0x280>
    80001c92:	00018517          	auipc	a0,0x18
    80001c96:	cee50513          	addi	a0,a0,-786 # 80019980 <tickslock>
    80001c9a:	1d4040ef          	jal	80005e6e <initlock>
}
    80001c9e:	60a2                	ld	ra,8(sp)
    80001ca0:	6402                	ld	s0,0(sp)
    80001ca2:	0141                	addi	sp,sp,16
    80001ca4:	8082                	ret

0000000080001ca6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ca6:	1141                	addi	sp,sp,-16
    80001ca8:	e406                	sd	ra,8(sp)
    80001caa:	e022                	sd	s0,0(sp)
    80001cac:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cae:	00003797          	auipc	a5,0x3
    80001cb2:	19278793          	addi	a5,a5,402 # 80004e40 <kernelvec>
    80001cb6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cba:	60a2                	ld	ra,8(sp)
    80001cbc:	6402                	ld	s0,0(sp)
    80001cbe:	0141                	addi	sp,sp,16
    80001cc0:	8082                	ret

0000000080001cc2 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80001cc2:	1141                	addi	sp,sp,-16
    80001cc4:	e406                	sd	ra,8(sp)
    80001cc6:	e022                	sd	s0,0(sp)
    80001cc8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cca:	c32ff0ef          	jal	800010fc <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cce:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001cd2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001cd4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001cd8:	04000737          	lui	a4,0x4000
    80001cdc:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001cde:	0732                	slli	a4,a4,0xc
    80001ce0:	00004797          	auipc	a5,0x4
    80001ce4:	32078793          	addi	a5,a5,800 # 80006000 <_trampoline>
    80001ce8:	00004697          	auipc	a3,0x4
    80001cec:	31868693          	addi	a3,a3,792 # 80006000 <_trampoline>
    80001cf0:	8f95                	sub	a5,a5,a3
    80001cf2:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf4:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001cf8:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001cfa:	18002773          	csrr	a4,satp
    80001cfe:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d00:	6d38                	ld	a4,88(a0)
    80001d02:	613c                	ld	a5,64(a0)
    80001d04:	6685                	lui	a3,0x1
    80001d06:	97b6                	add	a5,a5,a3
    80001d08:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d0a:	6d3c                	ld	a5,88(a0)
    80001d0c:	00000717          	auipc	a4,0x0
    80001d10:	0fc70713          	addi	a4,a4,252 # 80001e08 <usertrap>
    80001d14:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d16:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d18:	8712                	mv	a4,tp
    80001d1a:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d1c:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d20:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d24:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d28:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d2c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d2e:	6f9c                	ld	a5,24(a5)
    80001d30:	14179073          	csrw	sepc,a5
}
    80001d34:	60a2                	ld	ra,8(sp)
    80001d36:	6402                	ld	s0,0(sp)
    80001d38:	0141                	addi	sp,sp,16
    80001d3a:	8082                	ret

0000000080001d3c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d3c:	1141                	addi	sp,sp,-16
    80001d3e:	e406                	sd	ra,8(sp)
    80001d40:	e022                	sd	s0,0(sp)
    80001d42:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001d44:	b84ff0ef          	jal	800010c8 <cpuid>
    80001d48:	cd11                	beqz	a0,80001d64 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001d4a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001d4e:	000f4737          	lui	a4,0xf4
    80001d52:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001d56:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001d58:	14d79073          	csrw	stimecmp,a5
}
    80001d5c:	60a2                	ld	ra,8(sp)
    80001d5e:	6402                	ld	s0,0(sp)
    80001d60:	0141                	addi	sp,sp,16
    80001d62:	8082                	ret
    acquire(&tickslock);
    80001d64:	00018517          	auipc	a0,0x18
    80001d68:	c1c50513          	addi	a0,a0,-996 # 80019980 <tickslock>
    80001d6c:	18c040ef          	jal	80005ef8 <acquire>
    ticks++;
    80001d70:	00006717          	auipc	a4,0x6
    80001d74:	ba870713          	addi	a4,a4,-1112 # 80007918 <ticks>
    80001d78:	431c                	lw	a5,0(a4)
    80001d7a:	2785                	addiw	a5,a5,1
    80001d7c:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001d7e:	853a                	mv	a0,a4
    80001d80:	a0fff0ef          	jal	8000178e <wakeup>
    release(&tickslock);
    80001d84:	00018517          	auipc	a0,0x18
    80001d88:	bfc50513          	addi	a0,a0,-1028 # 80019980 <tickslock>
    80001d8c:	200040ef          	jal	80005f8c <release>
    80001d90:	bf6d                	j	80001d4a <clockintr+0xe>

0000000080001d92 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001d92:	1101                	addi	sp,sp,-32
    80001d94:	ec06                	sd	ra,24(sp)
    80001d96:	e822                	sd	s0,16(sp)
    80001d98:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d9a:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001d9e:	57fd                	li	a5,-1
    80001da0:	17fe                	slli	a5,a5,0x3f
    80001da2:	07a5                	addi	a5,a5,9
    80001da4:	00f70c63          	beq	a4,a5,80001dbc <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001da8:	57fd                	li	a5,-1
    80001daa:	17fe                	slli	a5,a5,0x3f
    80001dac:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001dae:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001db0:	04f70863          	beq	a4,a5,80001e00 <devintr+0x6e>
  }
}
    80001db4:	60e2                	ld	ra,24(sp)
    80001db6:	6442                	ld	s0,16(sp)
    80001db8:	6105                	addi	sp,sp,32
    80001dba:	8082                	ret
    80001dbc:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001dbe:	12e030ef          	jal	80004eec <plic_claim>
    80001dc2:	872a                	mv	a4,a0
    80001dc4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dc6:	47a9                	li	a5,10
    80001dc8:	00f50963          	beq	a0,a5,80001dda <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80001dcc:	4785                	li	a5,1
    80001dce:	00f50963          	beq	a0,a5,80001de0 <devintr+0x4e>
    return 1;
    80001dd2:	4505                	li	a0,1
    } else if(irq){
    80001dd4:	eb09                	bnez	a4,80001de6 <devintr+0x54>
    80001dd6:	64a2                	ld	s1,8(sp)
    80001dd8:	bff1                	j	80001db4 <devintr+0x22>
      uartintr();
    80001dda:	02c040ef          	jal	80005e06 <uartintr>
    if(irq)
    80001dde:	a819                	j	80001df4 <devintr+0x62>
      virtio_disk_intr();
    80001de0:	5a2030ef          	jal	80005382 <virtio_disk_intr>
    if(irq)
    80001de4:	a801                	j	80001df4 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80001de6:	85ba                	mv	a1,a4
    80001de8:	00005517          	auipc	a0,0x5
    80001dec:	4a050513          	addi	a0,a0,1184 # 80007288 <etext+0x288>
    80001df0:	31d030ef          	jal	8000590c <printf>
      plic_complete(irq);
    80001df4:	8526                	mv	a0,s1
    80001df6:	116030ef          	jal	80004f0c <plic_complete>
    return 1;
    80001dfa:	4505                	li	a0,1
    80001dfc:	64a2                	ld	s1,8(sp)
    80001dfe:	bf5d                	j	80001db4 <devintr+0x22>
    clockintr();
    80001e00:	f3dff0ef          	jal	80001d3c <clockintr>
    return 2;
    80001e04:	4509                	li	a0,2
    80001e06:	b77d                	j	80001db4 <devintr+0x22>

0000000080001e08 <usertrap>:
{
    80001e08:	1101                	addi	sp,sp,-32
    80001e0a:	ec06                	sd	ra,24(sp)
    80001e0c:	e822                	sd	s0,16(sp)
    80001e0e:	e426                	sd	s1,8(sp)
    80001e10:	e04a                	sd	s2,0(sp)
    80001e12:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e14:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e18:	1007f793          	andi	a5,a5,256
    80001e1c:	eba5                	bnez	a5,80001e8c <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e1e:	00003797          	auipc	a5,0x3
    80001e22:	02278793          	addi	a5,a5,34 # 80004e40 <kernelvec>
    80001e26:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e2a:	ad2ff0ef          	jal	800010fc <myproc>
    80001e2e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e30:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e32:	14102773          	csrr	a4,sepc
    80001e36:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e38:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e3c:	47a1                	li	a5,8
    80001e3e:	04f70d63          	beq	a4,a5,80001e98 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001e42:	f51ff0ef          	jal	80001d92 <devintr>
    80001e46:	892a                	mv	s2,a0
    80001e48:	e945                	bnez	a0,80001ef8 <usertrap+0xf0>
    80001e4a:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001e4e:	47bd                	li	a5,15
    80001e50:	08f70863          	beq	a4,a5,80001ee0 <usertrap+0xd8>
    80001e54:	14202773          	csrr	a4,scause
    80001e58:	47b5                	li	a5,13
    80001e5a:	08f70363          	beq	a4,a5,80001ee0 <usertrap+0xd8>
    80001e5e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001e62:	5890                	lw	a2,48(s1)
    80001e64:	00005517          	auipc	a0,0x5
    80001e68:	46450513          	addi	a0,a0,1124 # 800072c8 <etext+0x2c8>
    80001e6c:	2a1030ef          	jal	8000590c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e70:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e74:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001e78:	00005517          	auipc	a0,0x5
    80001e7c:	48050513          	addi	a0,a0,1152 # 800072f8 <etext+0x2f8>
    80001e80:	28d030ef          	jal	8000590c <printf>
    setkilled(p);
    80001e84:	8526                	mv	a0,s1
    80001e86:	b19ff0ef          	jal	8000199e <setkilled>
    80001e8a:	a035                	j	80001eb6 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001e8c:	00005517          	auipc	a0,0x5
    80001e90:	41c50513          	addi	a0,a0,1052 # 800072a8 <etext+0x2a8>
    80001e94:	5a3030ef          	jal	80005c36 <panic>
    if(killed(p))
    80001e98:	b2bff0ef          	jal	800019c2 <killed>
    80001e9c:	ed15                	bnez	a0,80001ed8 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001e9e:	6cb8                	ld	a4,88(s1)
    80001ea0:	6f1c                	ld	a5,24(a4)
    80001ea2:	0791                	addi	a5,a5,4
    80001ea4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ea6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eaa:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001eae:	10079073          	csrw	sstatus,a5
    syscall();
    80001eb2:	240000ef          	jal	800020f2 <syscall>
  if(killed(p))
    80001eb6:	8526                	mv	a0,s1
    80001eb8:	b0bff0ef          	jal	800019c2 <killed>
    80001ebc:	e139                	bnez	a0,80001f02 <usertrap+0xfa>
  prepare_return();
    80001ebe:	e05ff0ef          	jal	80001cc2 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ec2:	68a8                	ld	a0,80(s1)
    80001ec4:	8131                	srli	a0,a0,0xc
    80001ec6:	57fd                	li	a5,-1
    80001ec8:	17fe                	slli	a5,a5,0x3f
    80001eca:	8d5d                	or	a0,a0,a5
}
    80001ecc:	60e2                	ld	ra,24(sp)
    80001ece:	6442                	ld	s0,16(sp)
    80001ed0:	64a2                	ld	s1,8(sp)
    80001ed2:	6902                	ld	s2,0(sp)
    80001ed4:	6105                	addi	sp,sp,32
    80001ed6:	8082                	ret
      kexit(-1);
    80001ed8:	557d                	li	a0,-1
    80001eda:	975ff0ef          	jal	8000184e <kexit>
    80001ede:	b7c1                	j	80001e9e <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ee0:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee4:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001ee8:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001eea:	00163613          	seqz	a2,a2
    80001eee:	68a8                	ld	a0,80(s1)
    80001ef0:	b47fe0ef          	jal	80000a36 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001ef4:	f169                	bnez	a0,80001eb6 <usertrap+0xae>
    80001ef6:	b7a5                	j	80001e5e <usertrap+0x56>
  if(killed(p))
    80001ef8:	8526                	mv	a0,s1
    80001efa:	ac9ff0ef          	jal	800019c2 <killed>
    80001efe:	c511                	beqz	a0,80001f0a <usertrap+0x102>
    80001f00:	a011                	j	80001f04 <usertrap+0xfc>
    80001f02:	4901                	li	s2,0
    kexit(-1);
    80001f04:	557d                	li	a0,-1
    80001f06:	949ff0ef          	jal	8000184e <kexit>
  if(which_dev == 2)
    80001f0a:	4789                	li	a5,2
    80001f0c:	faf919e3          	bne	s2,a5,80001ebe <usertrap+0xb6>
    yield();
    80001f10:	807ff0ef          	jal	80001716 <yield>
    80001f14:	b76d                	j	80001ebe <usertrap+0xb6>

0000000080001f16 <kerneltrap>:
{
    80001f16:	7179                	addi	sp,sp,-48
    80001f18:	f406                	sd	ra,40(sp)
    80001f1a:	f022                	sd	s0,32(sp)
    80001f1c:	ec26                	sd	s1,24(sp)
    80001f1e:	e84a                	sd	s2,16(sp)
    80001f20:	e44e                	sd	s3,8(sp)
    80001f22:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f24:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f28:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f2c:	142027f3          	csrr	a5,scause
    80001f30:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001f32:	1004f793          	andi	a5,s1,256
    80001f36:	c795                	beqz	a5,80001f62 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f38:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f3c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f3e:	eb85                	bnez	a5,80001f6e <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001f40:	e53ff0ef          	jal	80001d92 <devintr>
    80001f44:	c91d                	beqz	a0,80001f7a <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001f46:	4789                	li	a5,2
    80001f48:	04f50a63          	beq	a0,a5,80001f9c <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f4c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f50:	10049073          	csrw	sstatus,s1
}
    80001f54:	70a2                	ld	ra,40(sp)
    80001f56:	7402                	ld	s0,32(sp)
    80001f58:	64e2                	ld	s1,24(sp)
    80001f5a:	6942                	ld	s2,16(sp)
    80001f5c:	69a2                	ld	s3,8(sp)
    80001f5e:	6145                	addi	sp,sp,48
    80001f60:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f62:	00005517          	auipc	a0,0x5
    80001f66:	3be50513          	addi	a0,a0,958 # 80007320 <etext+0x320>
    80001f6a:	4cd030ef          	jal	80005c36 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f6e:	00005517          	auipc	a0,0x5
    80001f72:	3da50513          	addi	a0,a0,986 # 80007348 <etext+0x348>
    80001f76:	4c1030ef          	jal	80005c36 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f7a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f7e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001f82:	85ce                	mv	a1,s3
    80001f84:	00005517          	auipc	a0,0x5
    80001f88:	3e450513          	addi	a0,a0,996 # 80007368 <etext+0x368>
    80001f8c:	181030ef          	jal	8000590c <printf>
    panic("kerneltrap");
    80001f90:	00005517          	auipc	a0,0x5
    80001f94:	40050513          	addi	a0,a0,1024 # 80007390 <etext+0x390>
    80001f98:	49f030ef          	jal	80005c36 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001f9c:	960ff0ef          	jal	800010fc <myproc>
    80001fa0:	d555                	beqz	a0,80001f4c <kerneltrap+0x36>
    yield();
    80001fa2:	f74ff0ef          	jal	80001716 <yield>
    80001fa6:	b75d                	j	80001f4c <kerneltrap+0x36>

0000000080001fa8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fa8:	1101                	addi	sp,sp,-32
    80001faa:	ec06                	sd	ra,24(sp)
    80001fac:	e822                	sd	s0,16(sp)
    80001fae:	e426                	sd	s1,8(sp)
    80001fb0:	1000                	addi	s0,sp,32
    80001fb2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fb4:	948ff0ef          	jal	800010fc <myproc>
  switch (n) {
    80001fb8:	4795                	li	a5,5
    80001fba:	0497e163          	bltu	a5,s1,80001ffc <argraw+0x54>
    80001fbe:	048a                	slli	s1,s1,0x2
    80001fc0:	00006717          	auipc	a4,0x6
    80001fc4:	83870713          	addi	a4,a4,-1992 # 800077f8 <states.0+0x30>
    80001fc8:	94ba                	add	s1,s1,a4
    80001fca:	409c                	lw	a5,0(s1)
    80001fcc:	97ba                	add	a5,a5,a4
    80001fce:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fd0:	6d3c                	ld	a5,88(a0)
    80001fd2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fd4:	60e2                	ld	ra,24(sp)
    80001fd6:	6442                	ld	s0,16(sp)
    80001fd8:	64a2                	ld	s1,8(sp)
    80001fda:	6105                	addi	sp,sp,32
    80001fdc:	8082                	ret
    return p->trapframe->a1;
    80001fde:	6d3c                	ld	a5,88(a0)
    80001fe0:	7fa8                	ld	a0,120(a5)
    80001fe2:	bfcd                	j	80001fd4 <argraw+0x2c>
    return p->trapframe->a2;
    80001fe4:	6d3c                	ld	a5,88(a0)
    80001fe6:	63c8                	ld	a0,128(a5)
    80001fe8:	b7f5                	j	80001fd4 <argraw+0x2c>
    return p->trapframe->a3;
    80001fea:	6d3c                	ld	a5,88(a0)
    80001fec:	67c8                	ld	a0,136(a5)
    80001fee:	b7dd                	j	80001fd4 <argraw+0x2c>
    return p->trapframe->a4;
    80001ff0:	6d3c                	ld	a5,88(a0)
    80001ff2:	6bc8                	ld	a0,144(a5)
    80001ff4:	b7c5                	j	80001fd4 <argraw+0x2c>
    return p->trapframe->a5;
    80001ff6:	6d3c                	ld	a5,88(a0)
    80001ff8:	6fc8                	ld	a0,152(a5)
    80001ffa:	bfe9                	j	80001fd4 <argraw+0x2c>
  panic("argraw");
    80001ffc:	00005517          	auipc	a0,0x5
    80002000:	3a450513          	addi	a0,a0,932 # 800073a0 <etext+0x3a0>
    80002004:	433030ef          	jal	80005c36 <panic>

0000000080002008 <fetchaddr>:
{
    80002008:	1101                	addi	sp,sp,-32
    8000200a:	ec06                	sd	ra,24(sp)
    8000200c:	e822                	sd	s0,16(sp)
    8000200e:	e426                	sd	s1,8(sp)
    80002010:	e04a                	sd	s2,0(sp)
    80002012:	1000                	addi	s0,sp,32
    80002014:	84aa                	mv	s1,a0
    80002016:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002018:	8e4ff0ef          	jal	800010fc <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000201c:	653c                	ld	a5,72(a0)
    8000201e:	02f4f663          	bgeu	s1,a5,8000204a <fetchaddr+0x42>
    80002022:	00848713          	addi	a4,s1,8
    80002026:	02e7e463          	bltu	a5,a4,8000204e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000202a:	46a1                	li	a3,8
    8000202c:	8626                	mv	a2,s1
    8000202e:	85ca                	mv	a1,s2
    80002030:	6928                	ld	a0,80(a0)
    80002032:	cabfe0ef          	jal	80000cdc <copyin>
    80002036:	00a03533          	snez	a0,a0
    8000203a:	40a0053b          	negw	a0,a0
}
    8000203e:	60e2                	ld	ra,24(sp)
    80002040:	6442                	ld	s0,16(sp)
    80002042:	64a2                	ld	s1,8(sp)
    80002044:	6902                	ld	s2,0(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret
    return -1;
    8000204a:	557d                	li	a0,-1
    8000204c:	bfcd                	j	8000203e <fetchaddr+0x36>
    8000204e:	557d                	li	a0,-1
    80002050:	b7fd                	j	8000203e <fetchaddr+0x36>

0000000080002052 <fetchstr>:
{
    80002052:	7179                	addi	sp,sp,-48
    80002054:	f406                	sd	ra,40(sp)
    80002056:	f022                	sd	s0,32(sp)
    80002058:	ec26                	sd	s1,24(sp)
    8000205a:	e84a                	sd	s2,16(sp)
    8000205c:	e44e                	sd	s3,8(sp)
    8000205e:	1800                	addi	s0,sp,48
    80002060:	89aa                	mv	s3,a0
    80002062:	84ae                	mv	s1,a1
    80002064:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002066:	896ff0ef          	jal	800010fc <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000206a:	86ca                	mv	a3,s2
    8000206c:	864e                	mv	a2,s3
    8000206e:	85a6                	mv	a1,s1
    80002070:	6928                	ld	a0,80(a0)
    80002072:	8edfe0ef          	jal	8000095e <copyinstr>
    80002076:	00054c63          	bltz	a0,8000208e <fetchstr+0x3c>
  return strlen(buf);
    8000207a:	8526                	mv	a0,s1
    8000207c:	a6cfe0ef          	jal	800002e8 <strlen>
}
    80002080:	70a2                	ld	ra,40(sp)
    80002082:	7402                	ld	s0,32(sp)
    80002084:	64e2                	ld	s1,24(sp)
    80002086:	6942                	ld	s2,16(sp)
    80002088:	69a2                	ld	s3,8(sp)
    8000208a:	6145                	addi	sp,sp,48
    8000208c:	8082                	ret
    return -1;
    8000208e:	557d                	li	a0,-1
    80002090:	bfc5                	j	80002080 <fetchstr+0x2e>

0000000080002092 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80002092:	1101                	addi	sp,sp,-32
    80002094:	ec06                	sd	ra,24(sp)
    80002096:	e822                	sd	s0,16(sp)
    80002098:	e426                	sd	s1,8(sp)
    8000209a:	1000                	addi	s0,sp,32
    8000209c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    8000209e:	f0bff0ef          	jal	80001fa8 <argraw>
    800020a2:	c088                	sw	a0,0(s1)
}
    800020a4:	60e2                	ld	ra,24(sp)
    800020a6:	6442                	ld	s0,16(sp)
    800020a8:	64a2                	ld	s1,8(sp)
    800020aa:	6105                	addi	sp,sp,32
    800020ac:	8082                	ret

00000000800020ae <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020ae:	1101                	addi	sp,sp,-32
    800020b0:	ec06                	sd	ra,24(sp)
    800020b2:	e822                	sd	s0,16(sp)
    800020b4:	e426                	sd	s1,8(sp)
    800020b6:	1000                	addi	s0,sp,32
    800020b8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020ba:	eefff0ef          	jal	80001fa8 <argraw>
    800020be:	e088                	sd	a0,0(s1)
}
    800020c0:	60e2                	ld	ra,24(sp)
    800020c2:	6442                	ld	s0,16(sp)
    800020c4:	64a2                	ld	s1,8(sp)
    800020c6:	6105                	addi	sp,sp,32
    800020c8:	8082                	ret

00000000800020ca <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020ca:	1101                	addi	sp,sp,-32
    800020cc:	ec06                	sd	ra,24(sp)
    800020ce:	e822                	sd	s0,16(sp)
    800020d0:	e426                	sd	s1,8(sp)
    800020d2:	e04a                	sd	s2,0(sp)
    800020d4:	1000                	addi	s0,sp,32
    800020d6:	892e                	mv	s2,a1
    800020d8:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800020da:	ecfff0ef          	jal	80001fa8 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800020de:	8626                	mv	a2,s1
    800020e0:	85ca                	mv	a1,s2
    800020e2:	f71ff0ef          	jal	80002052 <fetchstr>
}
    800020e6:	60e2                	ld	ra,24(sp)
    800020e8:	6442                	ld	s0,16(sp)
    800020ea:	64a2                	ld	s1,8(sp)
    800020ec:	6902                	ld	s2,0(sp)
    800020ee:	6105                	addi	sp,sp,32
    800020f0:	8082                	ret

00000000800020f2 <syscall>:
[SYS_munmap]    sys_munmap,
};

void
syscall(void)
{
    800020f2:	1101                	addi	sp,sp,-32
    800020f4:	ec06                	sd	ra,24(sp)
    800020f6:	e822                	sd	s0,16(sp)
    800020f8:	e426                	sd	s1,8(sp)
    800020fa:	e04a                	sd	s2,0(sp)
    800020fc:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    800020fe:	ffffe0ef          	jal	800010fc <myproc>
    80002102:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002104:	05853903          	ld	s2,88(a0)
    80002108:	0a893783          	ld	a5,168(s2)
    8000210c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002110:	37fd                	addiw	a5,a5,-1
    80002112:	4759                	li	a4,22
    80002114:	00f76f63          	bltu	a4,a5,80002132 <syscall+0x40>
    80002118:	00369713          	slli	a4,a3,0x3
    8000211c:	00005797          	auipc	a5,0x5
    80002120:	6f478793          	addi	a5,a5,1780 # 80007810 <syscalls>
    80002124:	97ba                	add	a5,a5,a4
    80002126:	639c                	ld	a5,0(a5)
    80002128:	c789                	beqz	a5,80002132 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000212a:	9782                	jalr	a5
    8000212c:	06a93823          	sd	a0,112(s2)
    80002130:	a829                	j	8000214a <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002132:	15848613          	addi	a2,s1,344
    80002136:	588c                	lw	a1,48(s1)
    80002138:	00005517          	auipc	a0,0x5
    8000213c:	27050513          	addi	a0,a0,624 # 800073a8 <etext+0x3a8>
    80002140:	7cc030ef          	jal	8000590c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002144:	6cbc                	ld	a5,88(s1)
    80002146:	577d                	li	a4,-1
    80002148:	fbb8                	sd	a4,112(a5)
  }
}
    8000214a:	60e2                	ld	ra,24(sp)
    8000214c:	6442                	ld	s0,16(sp)
    8000214e:	64a2                	ld	s1,8(sp)
    80002150:	6902                	ld	s2,0(sp)
    80002152:	6105                	addi	sp,sp,32
    80002154:	8082                	ret

0000000080002156 <sys_exit>:
#include "fcntl.h"


uint64
sys_exit(void)
{
    80002156:	1101                	addi	sp,sp,-32
    80002158:	ec06                	sd	ra,24(sp)
    8000215a:	e822                	sd	s0,16(sp)
    8000215c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000215e:	fec40593          	addi	a1,s0,-20
    80002162:	4501                	li	a0,0
    80002164:	f2fff0ef          	jal	80002092 <argint>
  kexit(n);
    80002168:	fec42503          	lw	a0,-20(s0)
    8000216c:	ee2ff0ef          	jal	8000184e <kexit>
  return 0;  // not reached
}
    80002170:	4501                	li	a0,0
    80002172:	60e2                	ld	ra,24(sp)
    80002174:	6442                	ld	s0,16(sp)
    80002176:	6105                	addi	sp,sp,32
    80002178:	8082                	ret

000000008000217a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000217a:	1141                	addi	sp,sp,-16
    8000217c:	e406                	sd	ra,8(sp)
    8000217e:	e022                	sd	s0,0(sp)
    80002180:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002182:	f7bfe0ef          	jal	800010fc <myproc>
}
    80002186:	5908                	lw	a0,48(a0)
    80002188:	60a2                	ld	ra,8(sp)
    8000218a:	6402                	ld	s0,0(sp)
    8000218c:	0141                	addi	sp,sp,16
    8000218e:	8082                	ret

0000000080002190 <sys_fork>:

uint64
sys_fork(void)
{
    80002190:	1141                	addi	sp,sp,-16
    80002192:	e406                	sd	ra,8(sp)
    80002194:	e022                	sd	s0,0(sp)
    80002196:	0800                	addi	s0,sp,16
  return kfork();
    80002198:	ac6ff0ef          	jal	8000145e <kfork>
}
    8000219c:	60a2                	ld	ra,8(sp)
    8000219e:	6402                	ld	s0,0(sp)
    800021a0:	0141                	addi	sp,sp,16
    800021a2:	8082                	ret

00000000800021a4 <sys_wait>:

uint64
sys_wait(void)
{
    800021a4:	1101                	addi	sp,sp,-32
    800021a6:	ec06                	sd	ra,24(sp)
    800021a8:	e822                	sd	s0,16(sp)
    800021aa:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021ac:	fe840593          	addi	a1,s0,-24
    800021b0:	4501                	li	a0,0
    800021b2:	efdff0ef          	jal	800020ae <argaddr>
  return kwait(p);
    800021b6:	fe843503          	ld	a0,-24(s0)
    800021ba:	833ff0ef          	jal	800019ec <kwait>
}
    800021be:	60e2                	ld	ra,24(sp)
    800021c0:	6442                	ld	s0,16(sp)
    800021c2:	6105                	addi	sp,sp,32
    800021c4:	8082                	ret

00000000800021c6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021c6:	7179                	addi	sp,sp,-48
    800021c8:	f406                	sd	ra,40(sp)
    800021ca:	f022                	sd	s0,32(sp)
    800021cc:	ec26                	sd	s1,24(sp)
    800021ce:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800021d0:	fd840593          	addi	a1,s0,-40
    800021d4:	4501                	li	a0,0
    800021d6:	ebdff0ef          	jal	80002092 <argint>
  argint(1, &t);
    800021da:	fdc40593          	addi	a1,s0,-36
    800021de:	4505                	li	a0,1
    800021e0:	eb3ff0ef          	jal	80002092 <argint>
  addr = myproc()->sz;
    800021e4:	f19fe0ef          	jal	800010fc <myproc>
    800021e8:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    800021ea:	fdc42703          	lw	a4,-36(s0)
    800021ee:	4785                	li	a5,1
    800021f0:	02f70163          	beq	a4,a5,80002212 <sys_sbrk+0x4c>
    800021f4:	fd842783          	lw	a5,-40(s0)
    800021f8:	0007cd63          	bltz	a5,80002212 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    800021fc:	97a6                	add	a5,a5,s1
    800021fe:	0297e863          	bltu	a5,s1,8000222e <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80002202:	efbfe0ef          	jal	800010fc <myproc>
    80002206:	fd842703          	lw	a4,-40(s0)
    8000220a:	653c                	ld	a5,72(a0)
    8000220c:	97ba                	add	a5,a5,a4
    8000220e:	e53c                	sd	a5,72(a0)
    80002210:	a039                	j	8000221e <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80002212:	fd842503          	lw	a0,-40(s0)
    80002216:	9f8ff0ef          	jal	8000140e <growproc>
    8000221a:	00054863          	bltz	a0,8000222a <sys_sbrk+0x64>
  }
  return addr;
}
    8000221e:	8526                	mv	a0,s1
    80002220:	70a2                	ld	ra,40(sp)
    80002222:	7402                	ld	s0,32(sp)
    80002224:	64e2                	ld	s1,24(sp)
    80002226:	6145                	addi	sp,sp,48
    80002228:	8082                	ret
      return -1;
    8000222a:	54fd                	li	s1,-1
    8000222c:	bfcd                	j	8000221e <sys_sbrk+0x58>
      return -1;
    8000222e:	54fd                	li	s1,-1
    80002230:	b7fd                	j	8000221e <sys_sbrk+0x58>

0000000080002232 <sys_pause>:

uint64
sys_pause(void)
{
    80002232:	7139                	addi	sp,sp,-64
    80002234:	fc06                	sd	ra,56(sp)
    80002236:	f822                	sd	s0,48(sp)
    80002238:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000223a:	fcc40593          	addi	a1,s0,-52
    8000223e:	4501                	li	a0,0
    80002240:	e53ff0ef          	jal	80002092 <argint>
  if(n < 0)
    80002244:	fcc42783          	lw	a5,-52(s0)
    80002248:	0607c863          	bltz	a5,800022b8 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    8000224c:	00017517          	auipc	a0,0x17
    80002250:	73450513          	addi	a0,a0,1844 # 80019980 <tickslock>
    80002254:	4a5030ef          	jal	80005ef8 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002258:	fcc42783          	lw	a5,-52(s0)
    8000225c:	c3b9                	beqz	a5,800022a2 <sys_pause+0x70>
    8000225e:	f426                	sd	s1,40(sp)
    80002260:	f04a                	sd	s2,32(sp)
    80002262:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002264:	00005997          	auipc	s3,0x5
    80002268:	6b49a983          	lw	s3,1716(s3) # 80007918 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000226c:	00017917          	auipc	s2,0x17
    80002270:	71490913          	addi	s2,s2,1812 # 80019980 <tickslock>
    80002274:	00005497          	auipc	s1,0x5
    80002278:	6a448493          	addi	s1,s1,1700 # 80007918 <ticks>
    if(killed(myproc())){
    8000227c:	e81fe0ef          	jal	800010fc <myproc>
    80002280:	f42ff0ef          	jal	800019c2 <killed>
    80002284:	ed0d                	bnez	a0,800022be <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002286:	85ca                	mv	a1,s2
    80002288:	8526                	mv	a0,s1
    8000228a:	cb8ff0ef          	jal	80001742 <sleep>
  while(ticks - ticks0 < n){
    8000228e:	409c                	lw	a5,0(s1)
    80002290:	413787bb          	subw	a5,a5,s3
    80002294:	fcc42703          	lw	a4,-52(s0)
    80002298:	fee7e2e3          	bltu	a5,a4,8000227c <sys_pause+0x4a>
    8000229c:	74a2                	ld	s1,40(sp)
    8000229e:	7902                	ld	s2,32(sp)
    800022a0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800022a2:	00017517          	auipc	a0,0x17
    800022a6:	6de50513          	addi	a0,a0,1758 # 80019980 <tickslock>
    800022aa:	4e3030ef          	jal	80005f8c <release>
  return 0;
    800022ae:	4501                	li	a0,0
}
    800022b0:	70e2                	ld	ra,56(sp)
    800022b2:	7442                	ld	s0,48(sp)
    800022b4:	6121                	addi	sp,sp,64
    800022b6:	8082                	ret
    n = 0;
    800022b8:	fc042623          	sw	zero,-52(s0)
    800022bc:	bf41                	j	8000224c <sys_pause+0x1a>
      release(&tickslock);
    800022be:	00017517          	auipc	a0,0x17
    800022c2:	6c250513          	addi	a0,a0,1730 # 80019980 <tickslock>
    800022c6:	4c7030ef          	jal	80005f8c <release>
      return -1;
    800022ca:	557d                	li	a0,-1
    800022cc:	74a2                	ld	s1,40(sp)
    800022ce:	7902                	ld	s2,32(sp)
    800022d0:	69e2                	ld	s3,24(sp)
    800022d2:	bff9                	j	800022b0 <sys_pause+0x7e>

00000000800022d4 <sys_kill>:

uint64
sys_kill(void)
{
    800022d4:	1101                	addi	sp,sp,-32
    800022d6:	ec06                	sd	ra,24(sp)
    800022d8:	e822                	sd	s0,16(sp)
    800022da:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022dc:	fec40593          	addi	a1,s0,-20
    800022e0:	4501                	li	a0,0
    800022e2:	db1ff0ef          	jal	80002092 <argint>
  return kkill(pid);
    800022e6:	fec42503          	lw	a0,-20(s0)
    800022ea:	e4eff0ef          	jal	80001938 <kkill>
}
    800022ee:	60e2                	ld	ra,24(sp)
    800022f0:	6442                	ld	s0,16(sp)
    800022f2:	6105                	addi	sp,sp,32
    800022f4:	8082                	ret

00000000800022f6 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022f6:	1101                	addi	sp,sp,-32
    800022f8:	ec06                	sd	ra,24(sp)
    800022fa:	e822                	sd	s0,16(sp)
    800022fc:	e426                	sd	s1,8(sp)
    800022fe:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002300:	00017517          	auipc	a0,0x17
    80002304:	68050513          	addi	a0,a0,1664 # 80019980 <tickslock>
    80002308:	3f1030ef          	jal	80005ef8 <acquire>
  xticks = ticks;
    8000230c:	00005797          	auipc	a5,0x5
    80002310:	60c7a783          	lw	a5,1548(a5) # 80007918 <ticks>
    80002314:	84be                	mv	s1,a5
  release(&tickslock);
    80002316:	00017517          	auipc	a0,0x17
    8000231a:	66a50513          	addi	a0,a0,1642 # 80019980 <tickslock>
    8000231e:	46f030ef          	jal	80005f8c <release>
  return xticks;
}
    80002322:	02049513          	slli	a0,s1,0x20
    80002326:	9101                	srli	a0,a0,0x20
    80002328:	60e2                	ld	ra,24(sp)
    8000232a:	6442                	ld	s0,16(sp)
    8000232c:	64a2                	ld	s1,8(sp)
    8000232e:	6105                	addi	sp,sp,32
    80002330:	8082                	ret

0000000080002332 <sys_mmap>:

uint64
sys_mmap(void)
{
    80002332:	711d                	addi	sp,sp,-96
    80002334:	ec86                	sd	ra,88(sp)
    80002336:	e8a2                	sd	s0,80(sp)
    80002338:	e0ca                	sd	s2,64(sp)
    8000233a:	1080                	addi	s0,sp,96
  uint64 addr;
  int len, prot, flags, fd, offset;

  argaddr(0, &addr);
    8000233c:	fb840593          	addi	a1,s0,-72
    80002340:	4501                	li	a0,0
    80002342:	d6dff0ef          	jal	800020ae <argaddr>
  argint(1, &len);
    80002346:	fb440593          	addi	a1,s0,-76
    8000234a:	4505                	li	a0,1
    8000234c:	d47ff0ef          	jal	80002092 <argint>
  argint(2, &prot);
    80002350:	fb040593          	addi	a1,s0,-80
    80002354:	4509                	li	a0,2
    80002356:	d3dff0ef          	jal	80002092 <argint>
  argint(3, &flags);
    8000235a:	fac40593          	addi	a1,s0,-84
    8000235e:	450d                	li	a0,3
    80002360:	d33ff0ef          	jal	80002092 <argint>
  argint(4, &fd);
    80002364:	fa840593          	addi	a1,s0,-88
    80002368:	4511                	li	a0,4
    8000236a:	d29ff0ef          	jal	80002092 <argint>
  argint(5, &offset);
    8000236e:	fa440593          	addi	a1,s0,-92
    80002372:	4515                	li	a0,5
    80002374:	d1fff0ef          	jal	80002092 <argint>

  if (len == 0)
    80002378:	fb442783          	lw	a5,-76(s0)
    return -1;
    8000237c:	597d                	li	s2,-1
  if (len == 0)
    8000237e:	0e078c63          	beqz	a5,80002476 <sys_mmap+0x144>

  if (addr != 0) {
    80002382:	fb843783          	ld	a5,-72(s0)
    80002386:	e7d1                	bnez	a5,80002412 <sys_mmap+0xe0>
    80002388:	e4a6                	sd	s1,72(sp)
    8000238a:	fc4e                	sd	s3,56(sp)
    printf("mmap: only support addr = 0");
    return -1;
  }

  struct proc *p = myproc();
    8000238c:	d71fe0ef          	jal	800010fc <myproc>
    80002390:	89aa                	mv	s3,a0

  if (((prot & PROT_READ) > 0) & !p->ofile[fd]->readable) {
    80002392:	fb042483          	lw	s1,-80(s0)
    80002396:	fa842783          	lw	a5,-88(s0)
    8000239a:	078e                	slli	a5,a5,0x3
    8000239c:	0d078793          	addi	a5,a5,208
    800023a0:	97aa                	add	a5,a5,a0
    800023a2:	6388                	ld	a0,0(a5)
    800023a4:	0014f793          	andi	a5,s1,1
    800023a8:	c789                	beqz	a5,800023b2 <sys_mmap+0x80>
    800023aa:	00854783          	lbu	a5,8(a0)
    // printf("mmap: target file is not readable\n");
    return -1;
    800023ae:	597d                	li	s2,-1
  if (((prot & PROT_READ) > 0) & !p->ofile[fd]->readable) {
    800023b0:	cbe9                	beqz	a5,80002482 <sys_mmap+0x150>
  }
  if (((prot & PROT_WRITE) > 0) & !p->ofile[fd]->writable & (flags & MAP_SHARED)) {
    800023b2:	8085                	srli	s1,s1,0x1
    800023b4:	00954783          	lbu	a5,9(a0)
    800023b8:	0017b793          	seqz	a5,a5
    800023bc:	fac42703          	lw	a4,-84(s0)
    800023c0:	8cfd                	and	s1,s1,a5
    800023c2:	8cf9                	and	s1,s1,a4
    // printf("mmap: target file is not writable\n");
    return -1;
    800023c4:	597d                	li	s2,-1
  if (((prot & PROT_WRITE) > 0) & !p->ofile[fd]->writable & (flags & MAP_SHARED)) {
    800023c6:	e0e9                	bnez	s1,80002488 <sys_mmap+0x156>
  }

  // Allocate new virtual pages 
  uint64 size = PGROUNDUP(len);
    800023c8:	fb442783          	lw	a5,-76(s0)
    800023cc:	6685                	lui	a3,0x1
    800023ce:	36fd                	addiw	a3,a3,-1 # fff <_entry-0x7ffff001>
    800023d0:	9ebd                	addw	a3,a3,a5
    800023d2:	77fd                	lui	a5,0xfffff
    800023d4:	8efd                	and	a3,a3,a5
  uint64 start = PGROUNDDOWN(p->mmap_base - size);
    800023d6:	1689b903          	ld	s2,360(s3)
    800023da:	40d90933          	sub	s2,s2,a3
    800023de:	00f97933          	and	s2,s2,a5

  // Check if address overlap with other memory regions
  if (start < p->sz || start >= TRAPFRAME) {
    800023e2:	0489b783          	ld	a5,72(s3)
    800023e6:	02f96d63          	bltu	s2,a5,80002420 <sys_mmap+0xee>
    800023ea:	fdfff7b7          	lui	a5,0xfdfff
    800023ee:	07ba                	slli	a5,a5,0xe
    800023f0:	83e9                	srli	a5,a5,0x1a
    800023f2:	0327e763          	bltu	a5,s2,80002420 <sys_mmap+0xee>
    800023f6:	17098793          	addi	a5,s3,368
    return -1;
  }

  // Find free vma
  int i = 0;
  for (; i < NVMA; i++) {
    800023fa:	4641                	li	a2,16
    if (p->vma[i].valid == 0)
    800023fc:	4398                	lw	a4,0(a5)
    800023fe:	c70d                	beqz	a4,80002428 <sys_mmap+0xf6>
  for (; i < NVMA; i++) {
    80002400:	2485                	addiw	s1,s1,1
    80002402:	03078793          	addi	a5,a5,48 # fffffffffdfff030 <end+0xffffffff7dfd21f8>
    80002406:	fec49be3          	bne	s1,a2,800023fc <sys_mmap+0xca>
      break;
  }
  if (i == NVMA) {
    return -1;
    8000240a:	597d                	li	s2,-1
    8000240c:	64a6                	ld	s1,72(sp)
    8000240e:	79e2                	ld	s3,56(sp)
    80002410:	a09d                	j	80002476 <sys_mmap+0x144>
    printf("mmap: only support addr = 0");
    80002412:	00005517          	auipc	a0,0x5
    80002416:	fb650513          	addi	a0,a0,-74 # 800073c8 <etext+0x3c8>
    8000241a:	4f2030ef          	jal	8000590c <printf>
    return -1;
    8000241e:	a8a1                	j	80002476 <sys_mmap+0x144>
    return -1;
    80002420:	597d                	li	s2,-1
    80002422:	64a6                	ld	s1,72(sp)
    80002424:	79e2                	ld	s3,56(sp)
    80002426:	a881                	j	80002476 <sys_mmap+0x144>
    80002428:	f852                	sd	s4,48(sp)
    8000242a:	f456                	sd	s5,40(sp)
  }

  // Set and use the free VMA slot
  p->vma[i].start  = start;
    8000242c:	00149a93          	slli	s5,s1,0x1
    80002430:	009a87b3          	add	a5,s5,s1
    80002434:	0792                	slli	a5,a5,0x4
    80002436:	00f98a33          	add	s4,s3,a5
    8000243a:	172a3c23          	sd	s2,376(s4)
  p->vma[i].end    = start + size;
    8000243e:	96ca                	add	a3,a3,s2
    80002440:	18da3023          	sd	a3,384(s4)
  p->vma[i].f   = filedup(p->ofile[fd]);
    80002444:	600010ef          	jal	80003a44 <filedup>
    80002448:	18aa3823          	sd	a0,400(s4)
  p->vma[i].offset = offset;
    8000244c:	fa442783          	lw	a5,-92(s0)
    80002450:	18fa2c23          	sw	a5,408(s4)
  p->vma[i].prot   = prot;
    80002454:	fb042783          	lw	a5,-80(s0)
    80002458:	18fa2423          	sw	a5,392(s4)
  p->vma[i].flags  = flags;
    8000245c:	fac42783          	lw	a5,-84(s0)
    80002460:	18fa2623          	sw	a5,396(s4)
  p->vma[i].valid  = 1;
    80002464:	4705                	li	a4,1
    80002466:	16ea2823          	sw	a4,368(s4)

  // Move the mmap top downward for the next mapping
  p->mmap_base = start;
    8000246a:	1729b423          	sd	s2,360(s3)
    8000246e:	64a6                	ld	s1,72(sp)
    80002470:	79e2                	ld	s3,56(sp)
    80002472:	7a42                	ld	s4,48(sp)
    80002474:	7aa2                	ld	s5,40(sp)

  return start;
}
    80002476:	854a                	mv	a0,s2
    80002478:	60e6                	ld	ra,88(sp)
    8000247a:	6446                	ld	s0,80(sp)
    8000247c:	6906                	ld	s2,64(sp)
    8000247e:	6125                	addi	sp,sp,96
    80002480:	8082                	ret
    80002482:	64a6                	ld	s1,72(sp)
    80002484:	79e2                	ld	s3,56(sp)
    80002486:	bfc5                	j	80002476 <sys_mmap+0x144>
    80002488:	64a6                	ld	s1,72(sp)
    8000248a:	79e2                	ld	s3,56(sp)
    8000248c:	b7ed                	j	80002476 <sys_mmap+0x144>

000000008000248e <sys_munmap>:

// Assumption: either unmap at the start, or at the end, or the whole region 
// (but not punch a hole in the middle of a region)
uint64
sys_munmap(void)
{
    8000248e:	715d                	addi	sp,sp,-80
    80002490:	e486                	sd	ra,72(sp)
    80002492:	e0a2                	sd	s0,64(sp)
    80002494:	f84a                	sd	s2,48(sp)
    80002496:	f052                	sd	s4,32(sp)
    80002498:	0880                	addi	s0,sp,80
  uint64 addr, end;
  int len;

  argaddr(0, &addr);
    8000249a:	fb840593          	addi	a1,s0,-72
    8000249e:	4501                	li	a0,0
    800024a0:	c0fff0ef          	jal	800020ae <argaddr>
  argint(1, &len);
    800024a4:	fb440593          	addi	a1,s0,-76
    800024a8:	4505                	li	a0,1
    800024aa:	be9ff0ef          	jal	80002092 <argint>

  if (addr == 0 || len == 0 || (addr % PGSIZE) != 0)
    800024ae:	fb843903          	ld	s2,-72(s0)
    return -1;
    800024b2:	5a7d                	li	s4,-1
  if (addr == 0 || len == 0 || (addr % PGSIZE) != 0)
    800024b4:	06090b63          	beqz	s2,8000252a <sys_munmap+0x9c>
    800024b8:	fb442783          	lw	a5,-76(s0)
    800024bc:	c7bd                	beqz	a5,8000252a <sys_munmap+0x9c>
    800024be:	03491713          	slli	a4,s2,0x34
    800024c2:	03475a13          	srli	s4,a4,0x34
    800024c6:	eb2d                	bnez	a4,80002538 <sys_munmap+0xaa>
    800024c8:	fc26                	sd	s1,56(sp)
    800024ca:	f44e                	sd	s3,40(sp)
    800024cc:	ec56                	sd	s5,24(sp)

  end = PGROUNDUP(addr + len);
    800024ce:	6705                	lui	a4,0x1
    800024d0:	177d                	addi	a4,a4,-1 # fff <_entry-0x7ffff001>
    800024d2:	993a                	add	s2,s2,a4
    800024d4:	993e                	add	s2,s2,a5
    800024d6:	77fd                	lui	a5,0xfffff
    800024d8:	00f97933          	and	s2,s2,a5

  struct proc *p = myproc();
    800024dc:	c21fe0ef          	jal	800010fc <myproc>
    800024e0:	8aaa                	mv	s5,a0

  for (uint i=0; i < NVMA; i++) {
    800024e2:	17050493          	addi	s1,a0,368
    800024e6:	47050993          	addi	s3,a0,1136
    800024ea:	a029                	j	800024f4 <sys_munmap+0x66>
    800024ec:	03048493          	addi	s1,s1,48
    800024f0:	03348a63          	beq	s1,s3,80002524 <sys_munmap+0x96>
    struct VMA *vma = &p->vma[i];

    if (vma->valid == 0 || vma->end <= addr || vma->start >= end)
    800024f4:	409c                	lw	a5,0(s1)
    800024f6:	dbfd                	beqz	a5,800024ec <sys_munmap+0x5e>
    800024f8:	fb843603          	ld	a2,-72(s0)
    800024fc:	689c                	ld	a5,16(s1)
    800024fe:	fef677e3          	bgeu	a2,a5,800024ec <sys_munmap+0x5e>
    80002502:	649c                	ld	a5,8(s1)
    80002504:	ff27f4e3          	bgeu	a5,s2,800024ec <sys_munmap+0x5e>
      continue;

    if (uvmunmap_vma(p->pagetable, vma, addr, end) == -1)
    80002508:	86ca                	mv	a3,s2
    8000250a:	85a6                	mv	a1,s1
    8000250c:	050ab503          	ld	a0,80(s5)
    80002510:	85bfe0ef          	jal	80000d6a <uvmunmap_vma>
    80002514:	57fd                	li	a5,-1
    80002516:	fcf51be3          	bne	a0,a5,800024ec <sys_munmap+0x5e>
      return -1;
    8000251a:	5a7d                	li	s4,-1
    8000251c:	74e2                	ld	s1,56(sp)
    8000251e:	79a2                	ld	s3,40(sp)
    80002520:	6ae2                	ld	s5,24(sp)
    80002522:	a021                	j	8000252a <sys_munmap+0x9c>
    80002524:	74e2                	ld	s1,56(sp)
    80002526:	79a2                	ld	s3,40(sp)
    80002528:	6ae2                	ld	s5,24(sp)
  }

  return 0;
}
    8000252a:	8552                	mv	a0,s4
    8000252c:	60a6                	ld	ra,72(sp)
    8000252e:	6406                	ld	s0,64(sp)
    80002530:	7942                	ld	s2,48(sp)
    80002532:	7a02                	ld	s4,32(sp)
    80002534:	6161                	addi	sp,sp,80
    80002536:	8082                	ret
    return -1;
    80002538:	5a7d                	li	s4,-1
    8000253a:	bfc5                	j	8000252a <sys_munmap+0x9c>

000000008000253c <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000253c:	7179                	addi	sp,sp,-48
    8000253e:	f406                	sd	ra,40(sp)
    80002540:	f022                	sd	s0,32(sp)
    80002542:	ec26                	sd	s1,24(sp)
    80002544:	e84a                	sd	s2,16(sp)
    80002546:	e44e                	sd	s3,8(sp)
    80002548:	e052                	sd	s4,0(sp)
    8000254a:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000254c:	00005597          	auipc	a1,0x5
    80002550:	e9c58593          	addi	a1,a1,-356 # 800073e8 <etext+0x3e8>
    80002554:	00017517          	auipc	a0,0x17
    80002558:	44450513          	addi	a0,a0,1092 # 80019998 <bcache>
    8000255c:	113030ef          	jal	80005e6e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002560:	0001f797          	auipc	a5,0x1f
    80002564:	43878793          	addi	a5,a5,1080 # 80021998 <bcache+0x8000>
    80002568:	0001f717          	auipc	a4,0x1f
    8000256c:	69870713          	addi	a4,a4,1688 # 80021c00 <bcache+0x8268>
    80002570:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002574:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002578:	00017497          	auipc	s1,0x17
    8000257c:	43848493          	addi	s1,s1,1080 # 800199b0 <bcache+0x18>
    b->next = bcache.head.next;
    80002580:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002582:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002584:	00005a17          	auipc	s4,0x5
    80002588:	e6ca0a13          	addi	s4,s4,-404 # 800073f0 <etext+0x3f0>
    b->next = bcache.head.next;
    8000258c:	2b893783          	ld	a5,696(s2)
    80002590:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002592:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002596:	85d2                	mv	a1,s4
    80002598:	01048513          	addi	a0,s1,16
    8000259c:	328010ef          	jal	800038c4 <initsleeplock>
    bcache.head.next->prev = b;
    800025a0:	2b893783          	ld	a5,696(s2)
    800025a4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025a6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025aa:	45848493          	addi	s1,s1,1112
    800025ae:	fd349fe3          	bne	s1,s3,8000258c <binit+0x50>
  }
}
    800025b2:	70a2                	ld	ra,40(sp)
    800025b4:	7402                	ld	s0,32(sp)
    800025b6:	64e2                	ld	s1,24(sp)
    800025b8:	6942                	ld	s2,16(sp)
    800025ba:	69a2                	ld	s3,8(sp)
    800025bc:	6a02                	ld	s4,0(sp)
    800025be:	6145                	addi	sp,sp,48
    800025c0:	8082                	ret

00000000800025c2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025c2:	7179                	addi	sp,sp,-48
    800025c4:	f406                	sd	ra,40(sp)
    800025c6:	f022                	sd	s0,32(sp)
    800025c8:	ec26                	sd	s1,24(sp)
    800025ca:	e84a                	sd	s2,16(sp)
    800025cc:	e44e                	sd	s3,8(sp)
    800025ce:	1800                	addi	s0,sp,48
    800025d0:	892a                	mv	s2,a0
    800025d2:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800025d4:	00017517          	auipc	a0,0x17
    800025d8:	3c450513          	addi	a0,a0,964 # 80019998 <bcache>
    800025dc:	11d030ef          	jal	80005ef8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800025e0:	0001f497          	auipc	s1,0x1f
    800025e4:	6704b483          	ld	s1,1648(s1) # 80021c50 <bcache+0x82b8>
    800025e8:	0001f797          	auipc	a5,0x1f
    800025ec:	61878793          	addi	a5,a5,1560 # 80021c00 <bcache+0x8268>
    800025f0:	02f48b63          	beq	s1,a5,80002626 <bread+0x64>
    800025f4:	873e                	mv	a4,a5
    800025f6:	a021                	j	800025fe <bread+0x3c>
    800025f8:	68a4                	ld	s1,80(s1)
    800025fa:	02e48663          	beq	s1,a4,80002626 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800025fe:	449c                	lw	a5,8(s1)
    80002600:	ff279ce3          	bne	a5,s2,800025f8 <bread+0x36>
    80002604:	44dc                	lw	a5,12(s1)
    80002606:	ff3799e3          	bne	a5,s3,800025f8 <bread+0x36>
      b->refcnt++;
    8000260a:	40bc                	lw	a5,64(s1)
    8000260c:	2785                	addiw	a5,a5,1
    8000260e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002610:	00017517          	auipc	a0,0x17
    80002614:	38850513          	addi	a0,a0,904 # 80019998 <bcache>
    80002618:	175030ef          	jal	80005f8c <release>
      acquiresleep(&b->lock);
    8000261c:	01048513          	addi	a0,s1,16
    80002620:	2da010ef          	jal	800038fa <acquiresleep>
      return b;
    80002624:	a889                	j	80002676 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002626:	0001f497          	auipc	s1,0x1f
    8000262a:	6224b483          	ld	s1,1570(s1) # 80021c48 <bcache+0x82b0>
    8000262e:	0001f797          	auipc	a5,0x1f
    80002632:	5d278793          	addi	a5,a5,1490 # 80021c00 <bcache+0x8268>
    80002636:	00f48863          	beq	s1,a5,80002646 <bread+0x84>
    8000263a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000263c:	40bc                	lw	a5,64(s1)
    8000263e:	cb91                	beqz	a5,80002652 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002640:	64a4                	ld	s1,72(s1)
    80002642:	fee49de3          	bne	s1,a4,8000263c <bread+0x7a>
  panic("bget: no buffers");
    80002646:	00005517          	auipc	a0,0x5
    8000264a:	db250513          	addi	a0,a0,-590 # 800073f8 <etext+0x3f8>
    8000264e:	5e8030ef          	jal	80005c36 <panic>
      b->dev = dev;
    80002652:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002656:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000265a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000265e:	4785                	li	a5,1
    80002660:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002662:	00017517          	auipc	a0,0x17
    80002666:	33650513          	addi	a0,a0,822 # 80019998 <bcache>
    8000266a:	123030ef          	jal	80005f8c <release>
      acquiresleep(&b->lock);
    8000266e:	01048513          	addi	a0,s1,16
    80002672:	288010ef          	jal	800038fa <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002676:	409c                	lw	a5,0(s1)
    80002678:	cb89                	beqz	a5,8000268a <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000267a:	8526                	mv	a0,s1
    8000267c:	70a2                	ld	ra,40(sp)
    8000267e:	7402                	ld	s0,32(sp)
    80002680:	64e2                	ld	s1,24(sp)
    80002682:	6942                	ld	s2,16(sp)
    80002684:	69a2                	ld	s3,8(sp)
    80002686:	6145                	addi	sp,sp,48
    80002688:	8082                	ret
    virtio_disk_rw(b, 0);
    8000268a:	4581                	li	a1,0
    8000268c:	8526                	mv	a0,s1
    8000268e:	2e3020ef          	jal	80005170 <virtio_disk_rw>
    b->valid = 1;
    80002692:	4785                	li	a5,1
    80002694:	c09c                	sw	a5,0(s1)
  return b;
    80002696:	b7d5                	j	8000267a <bread+0xb8>

0000000080002698 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002698:	1101                	addi	sp,sp,-32
    8000269a:	ec06                	sd	ra,24(sp)
    8000269c:	e822                	sd	s0,16(sp)
    8000269e:	e426                	sd	s1,8(sp)
    800026a0:	1000                	addi	s0,sp,32
    800026a2:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026a4:	0541                	addi	a0,a0,16
    800026a6:	2d2010ef          	jal	80003978 <holdingsleep>
    800026aa:	c911                	beqz	a0,800026be <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026ac:	4585                	li	a1,1
    800026ae:	8526                	mv	a0,s1
    800026b0:	2c1020ef          	jal	80005170 <virtio_disk_rw>
}
    800026b4:	60e2                	ld	ra,24(sp)
    800026b6:	6442                	ld	s0,16(sp)
    800026b8:	64a2                	ld	s1,8(sp)
    800026ba:	6105                	addi	sp,sp,32
    800026bc:	8082                	ret
    panic("bwrite");
    800026be:	00005517          	auipc	a0,0x5
    800026c2:	d5250513          	addi	a0,a0,-686 # 80007410 <etext+0x410>
    800026c6:	570030ef          	jal	80005c36 <panic>

00000000800026ca <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026ca:	1101                	addi	sp,sp,-32
    800026cc:	ec06                	sd	ra,24(sp)
    800026ce:	e822                	sd	s0,16(sp)
    800026d0:	e426                	sd	s1,8(sp)
    800026d2:	e04a                	sd	s2,0(sp)
    800026d4:	1000                	addi	s0,sp,32
    800026d6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026d8:	01050913          	addi	s2,a0,16
    800026dc:	854a                	mv	a0,s2
    800026de:	29a010ef          	jal	80003978 <holdingsleep>
    800026e2:	c125                	beqz	a0,80002742 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800026e4:	854a                	mv	a0,s2
    800026e6:	25a010ef          	jal	80003940 <releasesleep>

  acquire(&bcache.lock);
    800026ea:	00017517          	auipc	a0,0x17
    800026ee:	2ae50513          	addi	a0,a0,686 # 80019998 <bcache>
    800026f2:	007030ef          	jal	80005ef8 <acquire>
  b->refcnt--;
    800026f6:	40bc                	lw	a5,64(s1)
    800026f8:	37fd                	addiw	a5,a5,-1
    800026fa:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800026fc:	e79d                	bnez	a5,8000272a <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800026fe:	68b8                	ld	a4,80(s1)
    80002700:	64bc                	ld	a5,72(s1)
    80002702:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002704:	68b8                	ld	a4,80(s1)
    80002706:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002708:	0001f797          	auipc	a5,0x1f
    8000270c:	29078793          	addi	a5,a5,656 # 80021998 <bcache+0x8000>
    80002710:	2b87b703          	ld	a4,696(a5)
    80002714:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002716:	0001f717          	auipc	a4,0x1f
    8000271a:	4ea70713          	addi	a4,a4,1258 # 80021c00 <bcache+0x8268>
    8000271e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002720:	2b87b703          	ld	a4,696(a5)
    80002724:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002726:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000272a:	00017517          	auipc	a0,0x17
    8000272e:	26e50513          	addi	a0,a0,622 # 80019998 <bcache>
    80002732:	05b030ef          	jal	80005f8c <release>
}
    80002736:	60e2                	ld	ra,24(sp)
    80002738:	6442                	ld	s0,16(sp)
    8000273a:	64a2                	ld	s1,8(sp)
    8000273c:	6902                	ld	s2,0(sp)
    8000273e:	6105                	addi	sp,sp,32
    80002740:	8082                	ret
    panic("brelse");
    80002742:	00005517          	auipc	a0,0x5
    80002746:	cd650513          	addi	a0,a0,-810 # 80007418 <etext+0x418>
    8000274a:	4ec030ef          	jal	80005c36 <panic>

000000008000274e <bpin>:

void
bpin(struct buf *b) {
    8000274e:	1101                	addi	sp,sp,-32
    80002750:	ec06                	sd	ra,24(sp)
    80002752:	e822                	sd	s0,16(sp)
    80002754:	e426                	sd	s1,8(sp)
    80002756:	1000                	addi	s0,sp,32
    80002758:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000275a:	00017517          	auipc	a0,0x17
    8000275e:	23e50513          	addi	a0,a0,574 # 80019998 <bcache>
    80002762:	796030ef          	jal	80005ef8 <acquire>
  b->refcnt++;
    80002766:	40bc                	lw	a5,64(s1)
    80002768:	2785                	addiw	a5,a5,1
    8000276a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000276c:	00017517          	auipc	a0,0x17
    80002770:	22c50513          	addi	a0,a0,556 # 80019998 <bcache>
    80002774:	019030ef          	jal	80005f8c <release>
}
    80002778:	60e2                	ld	ra,24(sp)
    8000277a:	6442                	ld	s0,16(sp)
    8000277c:	64a2                	ld	s1,8(sp)
    8000277e:	6105                	addi	sp,sp,32
    80002780:	8082                	ret

0000000080002782 <bunpin>:

void
bunpin(struct buf *b) {
    80002782:	1101                	addi	sp,sp,-32
    80002784:	ec06                	sd	ra,24(sp)
    80002786:	e822                	sd	s0,16(sp)
    80002788:	e426                	sd	s1,8(sp)
    8000278a:	1000                	addi	s0,sp,32
    8000278c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000278e:	00017517          	auipc	a0,0x17
    80002792:	20a50513          	addi	a0,a0,522 # 80019998 <bcache>
    80002796:	762030ef          	jal	80005ef8 <acquire>
  b->refcnt--;
    8000279a:	40bc                	lw	a5,64(s1)
    8000279c:	37fd                	addiw	a5,a5,-1
    8000279e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027a0:	00017517          	auipc	a0,0x17
    800027a4:	1f850513          	addi	a0,a0,504 # 80019998 <bcache>
    800027a8:	7e4030ef          	jal	80005f8c <release>
}
    800027ac:	60e2                	ld	ra,24(sp)
    800027ae:	6442                	ld	s0,16(sp)
    800027b0:	64a2                	ld	s1,8(sp)
    800027b2:	6105                	addi	sp,sp,32
    800027b4:	8082                	ret

00000000800027b6 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027b6:	1101                	addi	sp,sp,-32
    800027b8:	ec06                	sd	ra,24(sp)
    800027ba:	e822                	sd	s0,16(sp)
    800027bc:	e426                	sd	s1,8(sp)
    800027be:	e04a                	sd	s2,0(sp)
    800027c0:	1000                	addi	s0,sp,32
    800027c2:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027c4:	00d5d79b          	srliw	a5,a1,0xd
    800027c8:	00020597          	auipc	a1,0x20
    800027cc:	8ac5a583          	lw	a1,-1876(a1) # 80022074 <sb+0x1c>
    800027d0:	9dbd                	addw	a1,a1,a5
    800027d2:	df1ff0ef          	jal	800025c2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800027d6:	0074f713          	andi	a4,s1,7
    800027da:	4785                	li	a5,1
    800027dc:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800027e0:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800027e2:	90d9                	srli	s1,s1,0x36
    800027e4:	00950733          	add	a4,a0,s1
    800027e8:	05874703          	lbu	a4,88(a4)
    800027ec:	00e7f6b3          	and	a3,a5,a4
    800027f0:	c29d                	beqz	a3,80002816 <bfree+0x60>
    800027f2:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800027f4:	94aa                	add	s1,s1,a0
    800027f6:	fff7c793          	not	a5,a5
    800027fa:	8f7d                	and	a4,a4,a5
    800027fc:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002800:	000010ef          	jal	80003800 <log_write>
  brelse(bp);
    80002804:	854a                	mv	a0,s2
    80002806:	ec5ff0ef          	jal	800026ca <brelse>
}
    8000280a:	60e2                	ld	ra,24(sp)
    8000280c:	6442                	ld	s0,16(sp)
    8000280e:	64a2                	ld	s1,8(sp)
    80002810:	6902                	ld	s2,0(sp)
    80002812:	6105                	addi	sp,sp,32
    80002814:	8082                	ret
    panic("freeing free block");
    80002816:	00005517          	auipc	a0,0x5
    8000281a:	c0a50513          	addi	a0,a0,-1014 # 80007420 <etext+0x420>
    8000281e:	418030ef          	jal	80005c36 <panic>

0000000080002822 <balloc>:
{
    80002822:	715d                	addi	sp,sp,-80
    80002824:	e486                	sd	ra,72(sp)
    80002826:	e0a2                	sd	s0,64(sp)
    80002828:	fc26                	sd	s1,56(sp)
    8000282a:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000282c:	00020797          	auipc	a5,0x20
    80002830:	8307a783          	lw	a5,-2000(a5) # 8002205c <sb+0x4>
    80002834:	0e078263          	beqz	a5,80002918 <balloc+0xf6>
    80002838:	f84a                	sd	s2,48(sp)
    8000283a:	f44e                	sd	s3,40(sp)
    8000283c:	f052                	sd	s4,32(sp)
    8000283e:	ec56                	sd	s5,24(sp)
    80002840:	e85a                	sd	s6,16(sp)
    80002842:	e45e                	sd	s7,8(sp)
    80002844:	e062                	sd	s8,0(sp)
    80002846:	8baa                	mv	s7,a0
    80002848:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000284a:	00020b17          	auipc	s6,0x20
    8000284e:	80eb0b13          	addi	s6,s6,-2034 # 80022058 <sb>
      m = 1 << (bi % 8);
    80002852:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002854:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002856:	6c09                	lui	s8,0x2
    80002858:	a09d                	j	800028be <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000285a:	97ca                	add	a5,a5,s2
    8000285c:	8e55                	or	a2,a2,a3
    8000285e:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002862:	854a                	mv	a0,s2
    80002864:	79d000ef          	jal	80003800 <log_write>
        brelse(bp);
    80002868:	854a                	mv	a0,s2
    8000286a:	e61ff0ef          	jal	800026ca <brelse>
  bp = bread(dev, bno);
    8000286e:	85a6                	mv	a1,s1
    80002870:	855e                	mv	a0,s7
    80002872:	d51ff0ef          	jal	800025c2 <bread>
    80002876:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002878:	40000613          	li	a2,1024
    8000287c:	4581                	li	a1,0
    8000287e:	05850513          	addi	a0,a0,88
    80002882:	8ddfd0ef          	jal	8000015e <memset>
  log_write(bp);
    80002886:	854a                	mv	a0,s2
    80002888:	779000ef          	jal	80003800 <log_write>
  brelse(bp);
    8000288c:	854a                	mv	a0,s2
    8000288e:	e3dff0ef          	jal	800026ca <brelse>
}
    80002892:	7942                	ld	s2,48(sp)
    80002894:	79a2                	ld	s3,40(sp)
    80002896:	7a02                	ld	s4,32(sp)
    80002898:	6ae2                	ld	s5,24(sp)
    8000289a:	6b42                	ld	s6,16(sp)
    8000289c:	6ba2                	ld	s7,8(sp)
    8000289e:	6c02                	ld	s8,0(sp)
}
    800028a0:	8526                	mv	a0,s1
    800028a2:	60a6                	ld	ra,72(sp)
    800028a4:	6406                	ld	s0,64(sp)
    800028a6:	74e2                	ld	s1,56(sp)
    800028a8:	6161                	addi	sp,sp,80
    800028aa:	8082                	ret
    brelse(bp);
    800028ac:	854a                	mv	a0,s2
    800028ae:	e1dff0ef          	jal	800026ca <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028b2:	015c0abb          	addw	s5,s8,s5
    800028b6:	004b2783          	lw	a5,4(s6)
    800028ba:	04faf863          	bgeu	s5,a5,8000290a <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800028be:	40dad59b          	sraiw	a1,s5,0xd
    800028c2:	01cb2783          	lw	a5,28(s6)
    800028c6:	9dbd                	addw	a1,a1,a5
    800028c8:	855e                	mv	a0,s7
    800028ca:	cf9ff0ef          	jal	800025c2 <bread>
    800028ce:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028d0:	004b2503          	lw	a0,4(s6)
    800028d4:	84d6                	mv	s1,s5
    800028d6:	4701                	li	a4,0
    800028d8:	fca4fae3          	bgeu	s1,a0,800028ac <balloc+0x8a>
      m = 1 << (bi % 8);
    800028dc:	00777693          	andi	a3,a4,7
    800028e0:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800028e4:	41f7579b          	sraiw	a5,a4,0x1f
    800028e8:	01d7d79b          	srliw	a5,a5,0x1d
    800028ec:	9fb9                	addw	a5,a5,a4
    800028ee:	4037d79b          	sraiw	a5,a5,0x3
    800028f2:	00f90633          	add	a2,s2,a5
    800028f6:	05864603          	lbu	a2,88(a2)
    800028fa:	00c6f5b3          	and	a1,a3,a2
    800028fe:	ddb1                	beqz	a1,8000285a <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002900:	2705                	addiw	a4,a4,1
    80002902:	2485                	addiw	s1,s1,1
    80002904:	fd471ae3          	bne	a4,s4,800028d8 <balloc+0xb6>
    80002908:	b755                	j	800028ac <balloc+0x8a>
    8000290a:	7942                	ld	s2,48(sp)
    8000290c:	79a2                	ld	s3,40(sp)
    8000290e:	7a02                	ld	s4,32(sp)
    80002910:	6ae2                	ld	s5,24(sp)
    80002912:	6b42                	ld	s6,16(sp)
    80002914:	6ba2                	ld	s7,8(sp)
    80002916:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002918:	00005517          	auipc	a0,0x5
    8000291c:	b2050513          	addi	a0,a0,-1248 # 80007438 <etext+0x438>
    80002920:	7ed020ef          	jal	8000590c <printf>
  return 0;
    80002924:	4481                	li	s1,0
    80002926:	bfad                	j	800028a0 <balloc+0x7e>

0000000080002928 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002928:	7179                	addi	sp,sp,-48
    8000292a:	f406                	sd	ra,40(sp)
    8000292c:	f022                	sd	s0,32(sp)
    8000292e:	ec26                	sd	s1,24(sp)
    80002930:	e84a                	sd	s2,16(sp)
    80002932:	e44e                	sd	s3,8(sp)
    80002934:	1800                	addi	s0,sp,48
    80002936:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002938:	47ad                	li	a5,11
    8000293a:	02b7e363          	bltu	a5,a1,80002960 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000293e:	02059793          	slli	a5,a1,0x20
    80002942:	01e7d593          	srli	a1,a5,0x1e
    80002946:	00b509b3          	add	s3,a0,a1
    8000294a:	0509a483          	lw	s1,80(s3)
    8000294e:	e0b5                	bnez	s1,800029b2 <bmap+0x8a>
      addr = balloc(ip->dev);
    80002950:	4108                	lw	a0,0(a0)
    80002952:	ed1ff0ef          	jal	80002822 <balloc>
    80002956:	84aa                	mv	s1,a0
      if(addr == 0)
    80002958:	cd29                	beqz	a0,800029b2 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    8000295a:	04a9a823          	sw	a0,80(s3)
    8000295e:	a891                	j	800029b2 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002960:	ff45879b          	addiw	a5,a1,-12
    80002964:	873e                	mv	a4,a5
    80002966:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80002968:	0ff00793          	li	a5,255
    8000296c:	06e7e763          	bltu	a5,a4,800029da <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002970:	08052483          	lw	s1,128(a0)
    80002974:	e891                	bnez	s1,80002988 <bmap+0x60>
      addr = balloc(ip->dev);
    80002976:	4108                	lw	a0,0(a0)
    80002978:	eabff0ef          	jal	80002822 <balloc>
    8000297c:	84aa                	mv	s1,a0
      if(addr == 0)
    8000297e:	c915                	beqz	a0,800029b2 <bmap+0x8a>
    80002980:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002982:	08a92023          	sw	a0,128(s2)
    80002986:	a011                	j	8000298a <bmap+0x62>
    80002988:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000298a:	85a6                	mv	a1,s1
    8000298c:	00092503          	lw	a0,0(s2)
    80002990:	c33ff0ef          	jal	800025c2 <bread>
    80002994:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002996:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000299a:	02099713          	slli	a4,s3,0x20
    8000299e:	01e75593          	srli	a1,a4,0x1e
    800029a2:	97ae                	add	a5,a5,a1
    800029a4:	89be                	mv	s3,a5
    800029a6:	4384                	lw	s1,0(a5)
    800029a8:	cc89                	beqz	s1,800029c2 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029aa:	8552                	mv	a0,s4
    800029ac:	d1fff0ef          	jal	800026ca <brelse>
    return addr;
    800029b0:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800029b2:	8526                	mv	a0,s1
    800029b4:	70a2                	ld	ra,40(sp)
    800029b6:	7402                	ld	s0,32(sp)
    800029b8:	64e2                	ld	s1,24(sp)
    800029ba:	6942                	ld	s2,16(sp)
    800029bc:	69a2                	ld	s3,8(sp)
    800029be:	6145                	addi	sp,sp,48
    800029c0:	8082                	ret
      addr = balloc(ip->dev);
    800029c2:	00092503          	lw	a0,0(s2)
    800029c6:	e5dff0ef          	jal	80002822 <balloc>
    800029ca:	84aa                	mv	s1,a0
      if(addr){
    800029cc:	dd79                	beqz	a0,800029aa <bmap+0x82>
        a[bn] = addr;
    800029ce:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800029d2:	8552                	mv	a0,s4
    800029d4:	62d000ef          	jal	80003800 <log_write>
    800029d8:	bfc9                	j	800029aa <bmap+0x82>
    800029da:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800029dc:	00005517          	auipc	a0,0x5
    800029e0:	a7450513          	addi	a0,a0,-1420 # 80007450 <etext+0x450>
    800029e4:	252030ef          	jal	80005c36 <panic>

00000000800029e8 <iget>:
{
    800029e8:	7179                	addi	sp,sp,-48
    800029ea:	f406                	sd	ra,40(sp)
    800029ec:	f022                	sd	s0,32(sp)
    800029ee:	ec26                	sd	s1,24(sp)
    800029f0:	e84a                	sd	s2,16(sp)
    800029f2:	e44e                	sd	s3,8(sp)
    800029f4:	e052                	sd	s4,0(sp)
    800029f6:	1800                	addi	s0,sp,48
    800029f8:	892a                	mv	s2,a0
    800029fa:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800029fc:	0001f517          	auipc	a0,0x1f
    80002a00:	67c50513          	addi	a0,a0,1660 # 80022078 <itable>
    80002a04:	4f4030ef          	jal	80005ef8 <acquire>
  empty = 0;
    80002a08:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a0a:	0001f497          	auipc	s1,0x1f
    80002a0e:	68648493          	addi	s1,s1,1670 # 80022090 <itable+0x18>
    80002a12:	00021697          	auipc	a3,0x21
    80002a16:	10e68693          	addi	a3,a3,270 # 80023b20 <log>
    80002a1a:	a809                	j	80002a2c <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a1c:	e781                	bnez	a5,80002a24 <iget+0x3c>
    80002a1e:	00099363          	bnez	s3,80002a24 <iget+0x3c>
      empty = ip;
    80002a22:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a24:	08848493          	addi	s1,s1,136
    80002a28:	02d48563          	beq	s1,a3,80002a52 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a2c:	449c                	lw	a5,8(s1)
    80002a2e:	fef057e3          	blez	a5,80002a1c <iget+0x34>
    80002a32:	4098                	lw	a4,0(s1)
    80002a34:	ff2718e3          	bne	a4,s2,80002a24 <iget+0x3c>
    80002a38:	40d8                	lw	a4,4(s1)
    80002a3a:	ff4715e3          	bne	a4,s4,80002a24 <iget+0x3c>
      ip->ref++;
    80002a3e:	2785                	addiw	a5,a5,1
    80002a40:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a42:	0001f517          	auipc	a0,0x1f
    80002a46:	63650513          	addi	a0,a0,1590 # 80022078 <itable>
    80002a4a:	542030ef          	jal	80005f8c <release>
      return ip;
    80002a4e:	89a6                	mv	s3,s1
    80002a50:	a015                	j	80002a74 <iget+0x8c>
  if(empty == 0)
    80002a52:	02098a63          	beqz	s3,80002a86 <iget+0x9e>
  ip->dev = dev;
    80002a56:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002a5a:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80002a5e:	4785                	li	a5,1
    80002a60:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002a64:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80002a68:	0001f517          	auipc	a0,0x1f
    80002a6c:	61050513          	addi	a0,a0,1552 # 80022078 <itable>
    80002a70:	51c030ef          	jal	80005f8c <release>
}
    80002a74:	854e                	mv	a0,s3
    80002a76:	70a2                	ld	ra,40(sp)
    80002a78:	7402                	ld	s0,32(sp)
    80002a7a:	64e2                	ld	s1,24(sp)
    80002a7c:	6942                	ld	s2,16(sp)
    80002a7e:	69a2                	ld	s3,8(sp)
    80002a80:	6a02                	ld	s4,0(sp)
    80002a82:	6145                	addi	sp,sp,48
    80002a84:	8082                	ret
    panic("iget: no inodes");
    80002a86:	00005517          	auipc	a0,0x5
    80002a8a:	9e250513          	addi	a0,a0,-1566 # 80007468 <etext+0x468>
    80002a8e:	1a8030ef          	jal	80005c36 <panic>

0000000080002a92 <iinit>:
{
    80002a92:	7179                	addi	sp,sp,-48
    80002a94:	f406                	sd	ra,40(sp)
    80002a96:	f022                	sd	s0,32(sp)
    80002a98:	ec26                	sd	s1,24(sp)
    80002a9a:	e84a                	sd	s2,16(sp)
    80002a9c:	e44e                	sd	s3,8(sp)
    80002a9e:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002aa0:	00005597          	auipc	a1,0x5
    80002aa4:	9d858593          	addi	a1,a1,-1576 # 80007478 <etext+0x478>
    80002aa8:	0001f517          	auipc	a0,0x1f
    80002aac:	5d050513          	addi	a0,a0,1488 # 80022078 <itable>
    80002ab0:	3be030ef          	jal	80005e6e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ab4:	0001f497          	auipc	s1,0x1f
    80002ab8:	5ec48493          	addi	s1,s1,1516 # 800220a0 <itable+0x28>
    80002abc:	00021997          	auipc	s3,0x21
    80002ac0:	07498993          	addi	s3,s3,116 # 80023b30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002ac4:	00005917          	auipc	s2,0x5
    80002ac8:	9bc90913          	addi	s2,s2,-1604 # 80007480 <etext+0x480>
    80002acc:	85ca                	mv	a1,s2
    80002ace:	8526                	mv	a0,s1
    80002ad0:	5f5000ef          	jal	800038c4 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002ad4:	08848493          	addi	s1,s1,136
    80002ad8:	ff349ae3          	bne	s1,s3,80002acc <iinit+0x3a>
}
    80002adc:	70a2                	ld	ra,40(sp)
    80002ade:	7402                	ld	s0,32(sp)
    80002ae0:	64e2                	ld	s1,24(sp)
    80002ae2:	6942                	ld	s2,16(sp)
    80002ae4:	69a2                	ld	s3,8(sp)
    80002ae6:	6145                	addi	sp,sp,48
    80002ae8:	8082                	ret

0000000080002aea <ialloc>:
{
    80002aea:	7139                	addi	sp,sp,-64
    80002aec:	fc06                	sd	ra,56(sp)
    80002aee:	f822                	sd	s0,48(sp)
    80002af0:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002af2:	0001f717          	auipc	a4,0x1f
    80002af6:	57272703          	lw	a4,1394(a4) # 80022064 <sb+0xc>
    80002afa:	4785                	li	a5,1
    80002afc:	06e7f063          	bgeu	a5,a4,80002b5c <ialloc+0x72>
    80002b00:	f426                	sd	s1,40(sp)
    80002b02:	f04a                	sd	s2,32(sp)
    80002b04:	ec4e                	sd	s3,24(sp)
    80002b06:	e852                	sd	s4,16(sp)
    80002b08:	e456                	sd	s5,8(sp)
    80002b0a:	e05a                	sd	s6,0(sp)
    80002b0c:	8aaa                	mv	s5,a0
    80002b0e:	8b2e                	mv	s6,a1
    80002b10:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002b12:	0001fa17          	auipc	s4,0x1f
    80002b16:	546a0a13          	addi	s4,s4,1350 # 80022058 <sb>
    80002b1a:	00495593          	srli	a1,s2,0x4
    80002b1e:	018a2783          	lw	a5,24(s4)
    80002b22:	9dbd                	addw	a1,a1,a5
    80002b24:	8556                	mv	a0,s5
    80002b26:	a9dff0ef          	jal	800025c2 <bread>
    80002b2a:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b2c:	05850993          	addi	s3,a0,88
    80002b30:	00f97793          	andi	a5,s2,15
    80002b34:	079a                	slli	a5,a5,0x6
    80002b36:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b38:	00099783          	lh	a5,0(s3)
    80002b3c:	cb9d                	beqz	a5,80002b72 <ialloc+0x88>
    brelse(bp);
    80002b3e:	b8dff0ef          	jal	800026ca <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b42:	0905                	addi	s2,s2,1
    80002b44:	00ca2703          	lw	a4,12(s4)
    80002b48:	0009079b          	sext.w	a5,s2
    80002b4c:	fce7e7e3          	bltu	a5,a4,80002b1a <ialloc+0x30>
    80002b50:	74a2                	ld	s1,40(sp)
    80002b52:	7902                	ld	s2,32(sp)
    80002b54:	69e2                	ld	s3,24(sp)
    80002b56:	6a42                	ld	s4,16(sp)
    80002b58:	6aa2                	ld	s5,8(sp)
    80002b5a:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002b5c:	00005517          	auipc	a0,0x5
    80002b60:	92c50513          	addi	a0,a0,-1748 # 80007488 <etext+0x488>
    80002b64:	5a9020ef          	jal	8000590c <printf>
  return 0;
    80002b68:	4501                	li	a0,0
}
    80002b6a:	70e2                	ld	ra,56(sp)
    80002b6c:	7442                	ld	s0,48(sp)
    80002b6e:	6121                	addi	sp,sp,64
    80002b70:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b72:	04000613          	li	a2,64
    80002b76:	4581                	li	a1,0
    80002b78:	854e                	mv	a0,s3
    80002b7a:	de4fd0ef          	jal	8000015e <memset>
      dip->type = type;
    80002b7e:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b82:	8526                	mv	a0,s1
    80002b84:	47d000ef          	jal	80003800 <log_write>
      brelse(bp);
    80002b88:	8526                	mv	a0,s1
    80002b8a:	b41ff0ef          	jal	800026ca <brelse>
      return iget(dev, inum);
    80002b8e:	0009059b          	sext.w	a1,s2
    80002b92:	8556                	mv	a0,s5
    80002b94:	e55ff0ef          	jal	800029e8 <iget>
    80002b98:	74a2                	ld	s1,40(sp)
    80002b9a:	7902                	ld	s2,32(sp)
    80002b9c:	69e2                	ld	s3,24(sp)
    80002b9e:	6a42                	ld	s4,16(sp)
    80002ba0:	6aa2                	ld	s5,8(sp)
    80002ba2:	6b02                	ld	s6,0(sp)
    80002ba4:	b7d9                	j	80002b6a <ialloc+0x80>

0000000080002ba6 <iupdate>:
{
    80002ba6:	1101                	addi	sp,sp,-32
    80002ba8:	ec06                	sd	ra,24(sp)
    80002baa:	e822                	sd	s0,16(sp)
    80002bac:	e426                	sd	s1,8(sp)
    80002bae:	e04a                	sd	s2,0(sp)
    80002bb0:	1000                	addi	s0,sp,32
    80002bb2:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bb4:	415c                	lw	a5,4(a0)
    80002bb6:	0047d79b          	srliw	a5,a5,0x4
    80002bba:	0001f597          	auipc	a1,0x1f
    80002bbe:	4b65a583          	lw	a1,1206(a1) # 80022070 <sb+0x18>
    80002bc2:	9dbd                	addw	a1,a1,a5
    80002bc4:	4108                	lw	a0,0(a0)
    80002bc6:	9fdff0ef          	jal	800025c2 <bread>
    80002bca:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bcc:	05850793          	addi	a5,a0,88
    80002bd0:	40d8                	lw	a4,4(s1)
    80002bd2:	8b3d                	andi	a4,a4,15
    80002bd4:	071a                	slli	a4,a4,0x6
    80002bd6:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002bd8:	04449703          	lh	a4,68(s1)
    80002bdc:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002be0:	04649703          	lh	a4,70(s1)
    80002be4:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002be8:	04849703          	lh	a4,72(s1)
    80002bec:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002bf0:	04a49703          	lh	a4,74(s1)
    80002bf4:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002bf8:	44f8                	lw	a4,76(s1)
    80002bfa:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bfc:	03400613          	li	a2,52
    80002c00:	05048593          	addi	a1,s1,80
    80002c04:	00c78513          	addi	a0,a5,12
    80002c08:	db6fd0ef          	jal	800001be <memmove>
  log_write(bp);
    80002c0c:	854a                	mv	a0,s2
    80002c0e:	3f3000ef          	jal	80003800 <log_write>
  brelse(bp);
    80002c12:	854a                	mv	a0,s2
    80002c14:	ab7ff0ef          	jal	800026ca <brelse>
}
    80002c18:	60e2                	ld	ra,24(sp)
    80002c1a:	6442                	ld	s0,16(sp)
    80002c1c:	64a2                	ld	s1,8(sp)
    80002c1e:	6902                	ld	s2,0(sp)
    80002c20:	6105                	addi	sp,sp,32
    80002c22:	8082                	ret

0000000080002c24 <idup>:
{
    80002c24:	1101                	addi	sp,sp,-32
    80002c26:	ec06                	sd	ra,24(sp)
    80002c28:	e822                	sd	s0,16(sp)
    80002c2a:	e426                	sd	s1,8(sp)
    80002c2c:	1000                	addi	s0,sp,32
    80002c2e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c30:	0001f517          	auipc	a0,0x1f
    80002c34:	44850513          	addi	a0,a0,1096 # 80022078 <itable>
    80002c38:	2c0030ef          	jal	80005ef8 <acquire>
  ip->ref++;
    80002c3c:	449c                	lw	a5,8(s1)
    80002c3e:	2785                	addiw	a5,a5,1
    80002c40:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c42:	0001f517          	auipc	a0,0x1f
    80002c46:	43650513          	addi	a0,a0,1078 # 80022078 <itable>
    80002c4a:	342030ef          	jal	80005f8c <release>
}
    80002c4e:	8526                	mv	a0,s1
    80002c50:	60e2                	ld	ra,24(sp)
    80002c52:	6442                	ld	s0,16(sp)
    80002c54:	64a2                	ld	s1,8(sp)
    80002c56:	6105                	addi	sp,sp,32
    80002c58:	8082                	ret

0000000080002c5a <ilock>:
{
    80002c5a:	1101                	addi	sp,sp,-32
    80002c5c:	ec06                	sd	ra,24(sp)
    80002c5e:	e822                	sd	s0,16(sp)
    80002c60:	e426                	sd	s1,8(sp)
    80002c62:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c64:	cd19                	beqz	a0,80002c82 <ilock+0x28>
    80002c66:	84aa                	mv	s1,a0
    80002c68:	451c                	lw	a5,8(a0)
    80002c6a:	00f05c63          	blez	a5,80002c82 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002c6e:	0541                	addi	a0,a0,16
    80002c70:	48b000ef          	jal	800038fa <acquiresleep>
  if(ip->valid == 0){
    80002c74:	40bc                	lw	a5,64(s1)
    80002c76:	cf89                	beqz	a5,80002c90 <ilock+0x36>
}
    80002c78:	60e2                	ld	ra,24(sp)
    80002c7a:	6442                	ld	s0,16(sp)
    80002c7c:	64a2                	ld	s1,8(sp)
    80002c7e:	6105                	addi	sp,sp,32
    80002c80:	8082                	ret
    80002c82:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002c84:	00005517          	auipc	a0,0x5
    80002c88:	81c50513          	addi	a0,a0,-2020 # 800074a0 <etext+0x4a0>
    80002c8c:	7ab020ef          	jal	80005c36 <panic>
    80002c90:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c92:	40dc                	lw	a5,4(s1)
    80002c94:	0047d79b          	srliw	a5,a5,0x4
    80002c98:	0001f597          	auipc	a1,0x1f
    80002c9c:	3d85a583          	lw	a1,984(a1) # 80022070 <sb+0x18>
    80002ca0:	9dbd                	addw	a1,a1,a5
    80002ca2:	4088                	lw	a0,0(s1)
    80002ca4:	91fff0ef          	jal	800025c2 <bread>
    80002ca8:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002caa:	05850593          	addi	a1,a0,88
    80002cae:	40dc                	lw	a5,4(s1)
    80002cb0:	8bbd                	andi	a5,a5,15
    80002cb2:	079a                	slli	a5,a5,0x6
    80002cb4:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002cb6:	00059783          	lh	a5,0(a1)
    80002cba:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cbe:	00259783          	lh	a5,2(a1)
    80002cc2:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cc6:	00459783          	lh	a5,4(a1)
    80002cca:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cce:	00659783          	lh	a5,6(a1)
    80002cd2:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002cd6:	459c                	lw	a5,8(a1)
    80002cd8:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cda:	03400613          	li	a2,52
    80002cde:	05b1                	addi	a1,a1,12
    80002ce0:	05048513          	addi	a0,s1,80
    80002ce4:	cdafd0ef          	jal	800001be <memmove>
    brelse(bp);
    80002ce8:	854a                	mv	a0,s2
    80002cea:	9e1ff0ef          	jal	800026ca <brelse>
    ip->valid = 1;
    80002cee:	4785                	li	a5,1
    80002cf0:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cf2:	04449783          	lh	a5,68(s1)
    80002cf6:	c399                	beqz	a5,80002cfc <ilock+0xa2>
    80002cf8:	6902                	ld	s2,0(sp)
    80002cfa:	bfbd                	j	80002c78 <ilock+0x1e>
      panic("ilock: no type");
    80002cfc:	00004517          	auipc	a0,0x4
    80002d00:	7ac50513          	addi	a0,a0,1964 # 800074a8 <etext+0x4a8>
    80002d04:	733020ef          	jal	80005c36 <panic>

0000000080002d08 <iunlock>:
{
    80002d08:	1101                	addi	sp,sp,-32
    80002d0a:	ec06                	sd	ra,24(sp)
    80002d0c:	e822                	sd	s0,16(sp)
    80002d0e:	e426                	sd	s1,8(sp)
    80002d10:	e04a                	sd	s2,0(sp)
    80002d12:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d14:	c505                	beqz	a0,80002d3c <iunlock+0x34>
    80002d16:	84aa                	mv	s1,a0
    80002d18:	01050913          	addi	s2,a0,16
    80002d1c:	854a                	mv	a0,s2
    80002d1e:	45b000ef          	jal	80003978 <holdingsleep>
    80002d22:	cd09                	beqz	a0,80002d3c <iunlock+0x34>
    80002d24:	449c                	lw	a5,8(s1)
    80002d26:	00f05b63          	blez	a5,80002d3c <iunlock+0x34>
  releasesleep(&ip->lock);
    80002d2a:	854a                	mv	a0,s2
    80002d2c:	415000ef          	jal	80003940 <releasesleep>
}
    80002d30:	60e2                	ld	ra,24(sp)
    80002d32:	6442                	ld	s0,16(sp)
    80002d34:	64a2                	ld	s1,8(sp)
    80002d36:	6902                	ld	s2,0(sp)
    80002d38:	6105                	addi	sp,sp,32
    80002d3a:	8082                	ret
    panic("iunlock");
    80002d3c:	00004517          	auipc	a0,0x4
    80002d40:	77c50513          	addi	a0,a0,1916 # 800074b8 <etext+0x4b8>
    80002d44:	6f3020ef          	jal	80005c36 <panic>

0000000080002d48 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d48:	7179                	addi	sp,sp,-48
    80002d4a:	f406                	sd	ra,40(sp)
    80002d4c:	f022                	sd	s0,32(sp)
    80002d4e:	ec26                	sd	s1,24(sp)
    80002d50:	e84a                	sd	s2,16(sp)
    80002d52:	e44e                	sd	s3,8(sp)
    80002d54:	1800                	addi	s0,sp,48
    80002d56:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d58:	05050493          	addi	s1,a0,80
    80002d5c:	08050913          	addi	s2,a0,128
    80002d60:	a021                	j	80002d68 <itrunc+0x20>
    80002d62:	0491                	addi	s1,s1,4
    80002d64:	01248b63          	beq	s1,s2,80002d7a <itrunc+0x32>
    if(ip->addrs[i]){
    80002d68:	408c                	lw	a1,0(s1)
    80002d6a:	dde5                	beqz	a1,80002d62 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d6c:	0009a503          	lw	a0,0(s3)
    80002d70:	a47ff0ef          	jal	800027b6 <bfree>
      ip->addrs[i] = 0;
    80002d74:	0004a023          	sw	zero,0(s1)
    80002d78:	b7ed                	j	80002d62 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d7a:	0809a583          	lw	a1,128(s3)
    80002d7e:	ed89                	bnez	a1,80002d98 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d80:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d84:	854e                	mv	a0,s3
    80002d86:	e21ff0ef          	jal	80002ba6 <iupdate>
}
    80002d8a:	70a2                	ld	ra,40(sp)
    80002d8c:	7402                	ld	s0,32(sp)
    80002d8e:	64e2                	ld	s1,24(sp)
    80002d90:	6942                	ld	s2,16(sp)
    80002d92:	69a2                	ld	s3,8(sp)
    80002d94:	6145                	addi	sp,sp,48
    80002d96:	8082                	ret
    80002d98:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d9a:	0009a503          	lw	a0,0(s3)
    80002d9e:	825ff0ef          	jal	800025c2 <bread>
    80002da2:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002da4:	05850493          	addi	s1,a0,88
    80002da8:	45850913          	addi	s2,a0,1112
    80002dac:	a021                	j	80002db4 <itrunc+0x6c>
    80002dae:	0491                	addi	s1,s1,4
    80002db0:	01248963          	beq	s1,s2,80002dc2 <itrunc+0x7a>
      if(a[j])
    80002db4:	408c                	lw	a1,0(s1)
    80002db6:	dde5                	beqz	a1,80002dae <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002db8:	0009a503          	lw	a0,0(s3)
    80002dbc:	9fbff0ef          	jal	800027b6 <bfree>
    80002dc0:	b7fd                	j	80002dae <itrunc+0x66>
    brelse(bp);
    80002dc2:	8552                	mv	a0,s4
    80002dc4:	907ff0ef          	jal	800026ca <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dc8:	0809a583          	lw	a1,128(s3)
    80002dcc:	0009a503          	lw	a0,0(s3)
    80002dd0:	9e7ff0ef          	jal	800027b6 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dd4:	0809a023          	sw	zero,128(s3)
    80002dd8:	6a02                	ld	s4,0(sp)
    80002dda:	b75d                	j	80002d80 <itrunc+0x38>

0000000080002ddc <iput>:
{
    80002ddc:	1101                	addi	sp,sp,-32
    80002dde:	ec06                	sd	ra,24(sp)
    80002de0:	e822                	sd	s0,16(sp)
    80002de2:	e426                	sd	s1,8(sp)
    80002de4:	1000                	addi	s0,sp,32
    80002de6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002de8:	0001f517          	auipc	a0,0x1f
    80002dec:	29050513          	addi	a0,a0,656 # 80022078 <itable>
    80002df0:	108030ef          	jal	80005ef8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002df4:	4498                	lw	a4,8(s1)
    80002df6:	4785                	li	a5,1
    80002df8:	02f70063          	beq	a4,a5,80002e18 <iput+0x3c>
  ip->ref--;
    80002dfc:	449c                	lw	a5,8(s1)
    80002dfe:	37fd                	addiw	a5,a5,-1
    80002e00:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e02:	0001f517          	auipc	a0,0x1f
    80002e06:	27650513          	addi	a0,a0,630 # 80022078 <itable>
    80002e0a:	182030ef          	jal	80005f8c <release>
}
    80002e0e:	60e2                	ld	ra,24(sp)
    80002e10:	6442                	ld	s0,16(sp)
    80002e12:	64a2                	ld	s1,8(sp)
    80002e14:	6105                	addi	sp,sp,32
    80002e16:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e18:	40bc                	lw	a5,64(s1)
    80002e1a:	d3ed                	beqz	a5,80002dfc <iput+0x20>
    80002e1c:	04a49783          	lh	a5,74(s1)
    80002e20:	fff1                	bnez	a5,80002dfc <iput+0x20>
    80002e22:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e24:	01048793          	addi	a5,s1,16
    80002e28:	893e                	mv	s2,a5
    80002e2a:	853e                	mv	a0,a5
    80002e2c:	2cf000ef          	jal	800038fa <acquiresleep>
    release(&itable.lock);
    80002e30:	0001f517          	auipc	a0,0x1f
    80002e34:	24850513          	addi	a0,a0,584 # 80022078 <itable>
    80002e38:	154030ef          	jal	80005f8c <release>
    itrunc(ip);
    80002e3c:	8526                	mv	a0,s1
    80002e3e:	f0bff0ef          	jal	80002d48 <itrunc>
    ip->type = 0;
    80002e42:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e46:	8526                	mv	a0,s1
    80002e48:	d5fff0ef          	jal	80002ba6 <iupdate>
    ip->valid = 0;
    80002e4c:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e50:	854a                	mv	a0,s2
    80002e52:	2ef000ef          	jal	80003940 <releasesleep>
    acquire(&itable.lock);
    80002e56:	0001f517          	auipc	a0,0x1f
    80002e5a:	22250513          	addi	a0,a0,546 # 80022078 <itable>
    80002e5e:	09a030ef          	jal	80005ef8 <acquire>
    80002e62:	6902                	ld	s2,0(sp)
    80002e64:	bf61                	j	80002dfc <iput+0x20>

0000000080002e66 <iunlockput>:
{
    80002e66:	1101                	addi	sp,sp,-32
    80002e68:	ec06                	sd	ra,24(sp)
    80002e6a:	e822                	sd	s0,16(sp)
    80002e6c:	e426                	sd	s1,8(sp)
    80002e6e:	1000                	addi	s0,sp,32
    80002e70:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e72:	e97ff0ef          	jal	80002d08 <iunlock>
  iput(ip);
    80002e76:	8526                	mv	a0,s1
    80002e78:	f65ff0ef          	jal	80002ddc <iput>
}
    80002e7c:	60e2                	ld	ra,24(sp)
    80002e7e:	6442                	ld	s0,16(sp)
    80002e80:	64a2                	ld	s1,8(sp)
    80002e82:	6105                	addi	sp,sp,32
    80002e84:	8082                	ret

0000000080002e86 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002e86:	0001f717          	auipc	a4,0x1f
    80002e8a:	1de72703          	lw	a4,478(a4) # 80022064 <sb+0xc>
    80002e8e:	4785                	li	a5,1
    80002e90:	0ae7fe63          	bgeu	a5,a4,80002f4c <ireclaim+0xc6>
{
    80002e94:	7139                	addi	sp,sp,-64
    80002e96:	fc06                	sd	ra,56(sp)
    80002e98:	f822                	sd	s0,48(sp)
    80002e9a:	f426                	sd	s1,40(sp)
    80002e9c:	f04a                	sd	s2,32(sp)
    80002e9e:	ec4e                	sd	s3,24(sp)
    80002ea0:	e852                	sd	s4,16(sp)
    80002ea2:	e456                	sd	s5,8(sp)
    80002ea4:	e05a                	sd	s6,0(sp)
    80002ea6:	0080                	addi	s0,sp,64
    80002ea8:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002eaa:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002eac:	0001fa17          	auipc	s4,0x1f
    80002eb0:	1aca0a13          	addi	s4,s4,428 # 80022058 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002eb4:	00004b17          	auipc	s6,0x4
    80002eb8:	60cb0b13          	addi	s6,s6,1548 # 800074c0 <etext+0x4c0>
    80002ebc:	a099                	j	80002f02 <ireclaim+0x7c>
    80002ebe:	85ce                	mv	a1,s3
    80002ec0:	855a                	mv	a0,s6
    80002ec2:	24b020ef          	jal	8000590c <printf>
      ip = iget(dev, inum);
    80002ec6:	85ce                	mv	a1,s3
    80002ec8:	8556                	mv	a0,s5
    80002eca:	b1fff0ef          	jal	800029e8 <iget>
    80002ece:	89aa                	mv	s3,a0
    brelse(bp);
    80002ed0:	854a                	mv	a0,s2
    80002ed2:	ff8ff0ef          	jal	800026ca <brelse>
    if (ip) {
    80002ed6:	00098f63          	beqz	s3,80002ef4 <ireclaim+0x6e>
      begin_op();
    80002eda:	78c000ef          	jal	80003666 <begin_op>
      ilock(ip);
    80002ede:	854e                	mv	a0,s3
    80002ee0:	d7bff0ef          	jal	80002c5a <ilock>
      iunlock(ip);
    80002ee4:	854e                	mv	a0,s3
    80002ee6:	e23ff0ef          	jal	80002d08 <iunlock>
      iput(ip);
    80002eea:	854e                	mv	a0,s3
    80002eec:	ef1ff0ef          	jal	80002ddc <iput>
      end_op();
    80002ef0:	7e6000ef          	jal	800036d6 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002ef4:	0485                	addi	s1,s1,1
    80002ef6:	00ca2703          	lw	a4,12(s4)
    80002efa:	0004879b          	sext.w	a5,s1
    80002efe:	02e7fd63          	bgeu	a5,a4,80002f38 <ireclaim+0xb2>
    80002f02:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002f06:	0044d593          	srli	a1,s1,0x4
    80002f0a:	018a2783          	lw	a5,24(s4)
    80002f0e:	9dbd                	addw	a1,a1,a5
    80002f10:	8556                	mv	a0,s5
    80002f12:	eb0ff0ef          	jal	800025c2 <bread>
    80002f16:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002f18:	05850793          	addi	a5,a0,88
    80002f1c:	00f9f713          	andi	a4,s3,15
    80002f20:	071a                	slli	a4,a4,0x6
    80002f22:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002f24:	00079703          	lh	a4,0(a5)
    80002f28:	c701                	beqz	a4,80002f30 <ireclaim+0xaa>
    80002f2a:	00679783          	lh	a5,6(a5)
    80002f2e:	dbc1                	beqz	a5,80002ebe <ireclaim+0x38>
    brelse(bp);
    80002f30:	854a                	mv	a0,s2
    80002f32:	f98ff0ef          	jal	800026ca <brelse>
    if (ip) {
    80002f36:	bf7d                	j	80002ef4 <ireclaim+0x6e>
}
    80002f38:	70e2                	ld	ra,56(sp)
    80002f3a:	7442                	ld	s0,48(sp)
    80002f3c:	74a2                	ld	s1,40(sp)
    80002f3e:	7902                	ld	s2,32(sp)
    80002f40:	69e2                	ld	s3,24(sp)
    80002f42:	6a42                	ld	s4,16(sp)
    80002f44:	6aa2                	ld	s5,8(sp)
    80002f46:	6b02                	ld	s6,0(sp)
    80002f48:	6121                	addi	sp,sp,64
    80002f4a:	8082                	ret
    80002f4c:	8082                	ret

0000000080002f4e <fsinit>:
fsinit(int dev) {
    80002f4e:	1101                	addi	sp,sp,-32
    80002f50:	ec06                	sd	ra,24(sp)
    80002f52:	e822                	sd	s0,16(sp)
    80002f54:	e426                	sd	s1,8(sp)
    80002f56:	e04a                	sd	s2,0(sp)
    80002f58:	1000                	addi	s0,sp,32
    80002f5a:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002f5c:	4585                	li	a1,1
    80002f5e:	e64ff0ef          	jal	800025c2 <bread>
    80002f62:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002f64:	02000613          	li	a2,32
    80002f68:	05850593          	addi	a1,a0,88
    80002f6c:	0001f517          	auipc	a0,0x1f
    80002f70:	0ec50513          	addi	a0,a0,236 # 80022058 <sb>
    80002f74:	a4afd0ef          	jal	800001be <memmove>
  brelse(bp);
    80002f78:	8526                	mv	a0,s1
    80002f7a:	f50ff0ef          	jal	800026ca <brelse>
  if(sb.magic != FSMAGIC)
    80002f7e:	0001f717          	auipc	a4,0x1f
    80002f82:	0da72703          	lw	a4,218(a4) # 80022058 <sb>
    80002f86:	102037b7          	lui	a5,0x10203
    80002f8a:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002f8e:	02f71263          	bne	a4,a5,80002fb2 <fsinit+0x64>
  initlog(dev, &sb);
    80002f92:	0001f597          	auipc	a1,0x1f
    80002f96:	0c658593          	addi	a1,a1,198 # 80022058 <sb>
    80002f9a:	854a                	mv	a0,s2
    80002f9c:	648000ef          	jal	800035e4 <initlog>
  ireclaim(dev);
    80002fa0:	854a                	mv	a0,s2
    80002fa2:	ee5ff0ef          	jal	80002e86 <ireclaim>
}
    80002fa6:	60e2                	ld	ra,24(sp)
    80002fa8:	6442                	ld	s0,16(sp)
    80002faa:	64a2                	ld	s1,8(sp)
    80002fac:	6902                	ld	s2,0(sp)
    80002fae:	6105                	addi	sp,sp,32
    80002fb0:	8082                	ret
    panic("invalid file system");
    80002fb2:	00004517          	auipc	a0,0x4
    80002fb6:	52e50513          	addi	a0,a0,1326 # 800074e0 <etext+0x4e0>
    80002fba:	47d020ef          	jal	80005c36 <panic>

0000000080002fbe <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fbe:	1141                	addi	sp,sp,-16
    80002fc0:	e406                	sd	ra,8(sp)
    80002fc2:	e022                	sd	s0,0(sp)
    80002fc4:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002fc6:	411c                	lw	a5,0(a0)
    80002fc8:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002fca:	415c                	lw	a5,4(a0)
    80002fcc:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002fce:	04451783          	lh	a5,68(a0)
    80002fd2:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002fd6:	04a51783          	lh	a5,74(a0)
    80002fda:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002fde:	04c56783          	lwu	a5,76(a0)
    80002fe2:	e99c                	sd	a5,16(a1)
}
    80002fe4:	60a2                	ld	ra,8(sp)
    80002fe6:	6402                	ld	s0,0(sp)
    80002fe8:	0141                	addi	sp,sp,16
    80002fea:	8082                	ret

0000000080002fec <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fec:	457c                	lw	a5,76(a0)
    80002fee:	0ed7e663          	bltu	a5,a3,800030da <readi+0xee>
{
    80002ff2:	7159                	addi	sp,sp,-112
    80002ff4:	f486                	sd	ra,104(sp)
    80002ff6:	f0a2                	sd	s0,96(sp)
    80002ff8:	eca6                	sd	s1,88(sp)
    80002ffa:	e0d2                	sd	s4,64(sp)
    80002ffc:	fc56                	sd	s5,56(sp)
    80002ffe:	f85a                	sd	s6,48(sp)
    80003000:	f45e                	sd	s7,40(sp)
    80003002:	1880                	addi	s0,sp,112
    80003004:	8b2a                	mv	s6,a0
    80003006:	8bae                	mv	s7,a1
    80003008:	8a32                	mv	s4,a2
    8000300a:	84b6                	mv	s1,a3
    8000300c:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000300e:	9f35                	addw	a4,a4,a3
    return 0;
    80003010:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80003012:	0ad76b63          	bltu	a4,a3,800030c8 <readi+0xdc>
    80003016:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003018:	00e7f463          	bgeu	a5,a4,80003020 <readi+0x34>
    n = ip->size - off;
    8000301c:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003020:	080a8b63          	beqz	s5,800030b6 <readi+0xca>
    80003024:	e8ca                	sd	s2,80(sp)
    80003026:	f062                	sd	s8,32(sp)
    80003028:	ec66                	sd	s9,24(sp)
    8000302a:	e86a                	sd	s10,16(sp)
    8000302c:	e46e                	sd	s11,8(sp)
    8000302e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003030:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003034:	5c7d                	li	s8,-1
    80003036:	a80d                	j	80003068 <readi+0x7c>
    80003038:	020d1d93          	slli	s11,s10,0x20
    8000303c:	020ddd93          	srli	s11,s11,0x20
    80003040:	05890613          	addi	a2,s2,88
    80003044:	86ee                	mv	a3,s11
    80003046:	963e                	add	a2,a2,a5
    80003048:	85d2                	mv	a1,s4
    8000304a:	855e                	mv	a0,s7
    8000304c:	a95fe0ef          	jal	80001ae0 <either_copyout>
    80003050:	05850363          	beq	a0,s8,80003096 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003054:	854a                	mv	a0,s2
    80003056:	e74ff0ef          	jal	800026ca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000305a:	013d09bb          	addw	s3,s10,s3
    8000305e:	009d04bb          	addw	s1,s10,s1
    80003062:	9a6e                	add	s4,s4,s11
    80003064:	0559f363          	bgeu	s3,s5,800030aa <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003068:	00a4d59b          	srliw	a1,s1,0xa
    8000306c:	855a                	mv	a0,s6
    8000306e:	8bbff0ef          	jal	80002928 <bmap>
    80003072:	85aa                	mv	a1,a0
    if(addr == 0)
    80003074:	c139                	beqz	a0,800030ba <readi+0xce>
    bp = bread(ip->dev, addr);
    80003076:	000b2503          	lw	a0,0(s6)
    8000307a:	d48ff0ef          	jal	800025c2 <bread>
    8000307e:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003080:	3ff4f793          	andi	a5,s1,1023
    80003084:	40fc873b          	subw	a4,s9,a5
    80003088:	413a86bb          	subw	a3,s5,s3
    8000308c:	8d3a                	mv	s10,a4
    8000308e:	fae6f5e3          	bgeu	a3,a4,80003038 <readi+0x4c>
    80003092:	8d36                	mv	s10,a3
    80003094:	b755                	j	80003038 <readi+0x4c>
      brelse(bp);
    80003096:	854a                	mv	a0,s2
    80003098:	e32ff0ef          	jal	800026ca <brelse>
      tot = -1;
    8000309c:	59fd                	li	s3,-1
      break;
    8000309e:	6946                	ld	s2,80(sp)
    800030a0:	7c02                	ld	s8,32(sp)
    800030a2:	6ce2                	ld	s9,24(sp)
    800030a4:	6d42                	ld	s10,16(sp)
    800030a6:	6da2                	ld	s11,8(sp)
    800030a8:	a831                	j	800030c4 <readi+0xd8>
    800030aa:	6946                	ld	s2,80(sp)
    800030ac:	7c02                	ld	s8,32(sp)
    800030ae:	6ce2                	ld	s9,24(sp)
    800030b0:	6d42                	ld	s10,16(sp)
    800030b2:	6da2                	ld	s11,8(sp)
    800030b4:	a801                	j	800030c4 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030b6:	89d6                	mv	s3,s5
    800030b8:	a031                	j	800030c4 <readi+0xd8>
    800030ba:	6946                	ld	s2,80(sp)
    800030bc:	7c02                	ld	s8,32(sp)
    800030be:	6ce2                	ld	s9,24(sp)
    800030c0:	6d42                	ld	s10,16(sp)
    800030c2:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800030c4:	854e                	mv	a0,s3
    800030c6:	69a6                	ld	s3,72(sp)
}
    800030c8:	70a6                	ld	ra,104(sp)
    800030ca:	7406                	ld	s0,96(sp)
    800030cc:	64e6                	ld	s1,88(sp)
    800030ce:	6a06                	ld	s4,64(sp)
    800030d0:	7ae2                	ld	s5,56(sp)
    800030d2:	7b42                	ld	s6,48(sp)
    800030d4:	7ba2                	ld	s7,40(sp)
    800030d6:	6165                	addi	sp,sp,112
    800030d8:	8082                	ret
    return 0;
    800030da:	4501                	li	a0,0
}
    800030dc:	8082                	ret

00000000800030de <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800030de:	457c                	lw	a5,76(a0)
    800030e0:	0ed7eb63          	bltu	a5,a3,800031d6 <writei+0xf8>
{
    800030e4:	7159                	addi	sp,sp,-112
    800030e6:	f486                	sd	ra,104(sp)
    800030e8:	f0a2                	sd	s0,96(sp)
    800030ea:	e8ca                	sd	s2,80(sp)
    800030ec:	e0d2                	sd	s4,64(sp)
    800030ee:	fc56                	sd	s5,56(sp)
    800030f0:	f85a                	sd	s6,48(sp)
    800030f2:	f45e                	sd	s7,40(sp)
    800030f4:	1880                	addi	s0,sp,112
    800030f6:	8aaa                	mv	s5,a0
    800030f8:	8bae                	mv	s7,a1
    800030fa:	8a32                	mv	s4,a2
    800030fc:	8936                	mv	s2,a3
    800030fe:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003100:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003104:	00043737          	lui	a4,0x43
    80003108:	0cf76963          	bltu	a4,a5,800031da <writei+0xfc>
    8000310c:	0cd7e763          	bltu	a5,a3,800031da <writei+0xfc>
    80003110:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003112:	0a0b0a63          	beqz	s6,800031c6 <writei+0xe8>
    80003116:	eca6                	sd	s1,88(sp)
    80003118:	f062                	sd	s8,32(sp)
    8000311a:	ec66                	sd	s9,24(sp)
    8000311c:	e86a                	sd	s10,16(sp)
    8000311e:	e46e                	sd	s11,8(sp)
    80003120:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80003122:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003126:	5c7d                	li	s8,-1
    80003128:	a825                	j	80003160 <writei+0x82>
    8000312a:	020d1d93          	slli	s11,s10,0x20
    8000312e:	020ddd93          	srli	s11,s11,0x20
    80003132:	05848513          	addi	a0,s1,88
    80003136:	86ee                	mv	a3,s11
    80003138:	8652                	mv	a2,s4
    8000313a:	85de                	mv	a1,s7
    8000313c:	953e                	add	a0,a0,a5
    8000313e:	9edfe0ef          	jal	80001b2a <either_copyin>
    80003142:	05850663          	beq	a0,s8,8000318e <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003146:	8526                	mv	a0,s1
    80003148:	6b8000ef          	jal	80003800 <log_write>
    brelse(bp);
    8000314c:	8526                	mv	a0,s1
    8000314e:	d7cff0ef          	jal	800026ca <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003152:	013d09bb          	addw	s3,s10,s3
    80003156:	012d093b          	addw	s2,s10,s2
    8000315a:	9a6e                	add	s4,s4,s11
    8000315c:	0369fc63          	bgeu	s3,s6,80003194 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80003160:	00a9559b          	srliw	a1,s2,0xa
    80003164:	8556                	mv	a0,s5
    80003166:	fc2ff0ef          	jal	80002928 <bmap>
    8000316a:	85aa                	mv	a1,a0
    if(addr == 0)
    8000316c:	c505                	beqz	a0,80003194 <writei+0xb6>
    bp = bread(ip->dev, addr);
    8000316e:	000aa503          	lw	a0,0(s5)
    80003172:	c50ff0ef          	jal	800025c2 <bread>
    80003176:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003178:	3ff97793          	andi	a5,s2,1023
    8000317c:	40fc873b          	subw	a4,s9,a5
    80003180:	413b06bb          	subw	a3,s6,s3
    80003184:	8d3a                	mv	s10,a4
    80003186:	fae6f2e3          	bgeu	a3,a4,8000312a <writei+0x4c>
    8000318a:	8d36                	mv	s10,a3
    8000318c:	bf79                	j	8000312a <writei+0x4c>
      brelse(bp);
    8000318e:	8526                	mv	a0,s1
    80003190:	d3aff0ef          	jal	800026ca <brelse>
  }

  if(off > ip->size)
    80003194:	04caa783          	lw	a5,76(s5)
    80003198:	0327f963          	bgeu	a5,s2,800031ca <writei+0xec>
    ip->size = off;
    8000319c:	052aa623          	sw	s2,76(s5)
    800031a0:	64e6                	ld	s1,88(sp)
    800031a2:	7c02                	ld	s8,32(sp)
    800031a4:	6ce2                	ld	s9,24(sp)
    800031a6:	6d42                	ld	s10,16(sp)
    800031a8:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031aa:	8556                	mv	a0,s5
    800031ac:	9fbff0ef          	jal	80002ba6 <iupdate>

  return tot;
    800031b0:	854e                	mv	a0,s3
    800031b2:	69a6                	ld	s3,72(sp)
}
    800031b4:	70a6                	ld	ra,104(sp)
    800031b6:	7406                	ld	s0,96(sp)
    800031b8:	6946                	ld	s2,80(sp)
    800031ba:	6a06                	ld	s4,64(sp)
    800031bc:	7ae2                	ld	s5,56(sp)
    800031be:	7b42                	ld	s6,48(sp)
    800031c0:	7ba2                	ld	s7,40(sp)
    800031c2:	6165                	addi	sp,sp,112
    800031c4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031c6:	89da                	mv	s3,s6
    800031c8:	b7cd                	j	800031aa <writei+0xcc>
    800031ca:	64e6                	ld	s1,88(sp)
    800031cc:	7c02                	ld	s8,32(sp)
    800031ce:	6ce2                	ld	s9,24(sp)
    800031d0:	6d42                	ld	s10,16(sp)
    800031d2:	6da2                	ld	s11,8(sp)
    800031d4:	bfd9                	j	800031aa <writei+0xcc>
    return -1;
    800031d6:	557d                	li	a0,-1
}
    800031d8:	8082                	ret
    return -1;
    800031da:	557d                	li	a0,-1
    800031dc:	bfe1                	j	800031b4 <writei+0xd6>

00000000800031de <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800031de:	1141                	addi	sp,sp,-16
    800031e0:	e406                	sd	ra,8(sp)
    800031e2:	e022                	sd	s0,0(sp)
    800031e4:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800031e6:	4639                	li	a2,14
    800031e8:	84afd0ef          	jal	80000232 <strncmp>
}
    800031ec:	60a2                	ld	ra,8(sp)
    800031ee:	6402                	ld	s0,0(sp)
    800031f0:	0141                	addi	sp,sp,16
    800031f2:	8082                	ret

00000000800031f4 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800031f4:	711d                	addi	sp,sp,-96
    800031f6:	ec86                	sd	ra,88(sp)
    800031f8:	e8a2                	sd	s0,80(sp)
    800031fa:	e4a6                	sd	s1,72(sp)
    800031fc:	e0ca                	sd	s2,64(sp)
    800031fe:	fc4e                	sd	s3,56(sp)
    80003200:	f852                	sd	s4,48(sp)
    80003202:	f456                	sd	s5,40(sp)
    80003204:	f05a                	sd	s6,32(sp)
    80003206:	ec5e                	sd	s7,24(sp)
    80003208:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    8000320a:	04451703          	lh	a4,68(a0)
    8000320e:	4785                	li	a5,1
    80003210:	00f71f63          	bne	a4,a5,8000322e <dirlookup+0x3a>
    80003214:	892a                	mv	s2,a0
    80003216:	8aae                	mv	s5,a1
    80003218:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    8000321a:	457c                	lw	a5,76(a0)
    8000321c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000321e:	fa040a13          	addi	s4,s0,-96
    80003222:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003224:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003228:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000322a:	e39d                	bnez	a5,80003250 <dirlookup+0x5c>
    8000322c:	a8b9                	j	8000328a <dirlookup+0x96>
    panic("dirlookup not DIR");
    8000322e:	00004517          	auipc	a0,0x4
    80003232:	2ca50513          	addi	a0,a0,714 # 800074f8 <etext+0x4f8>
    80003236:	201020ef          	jal	80005c36 <panic>
      panic("dirlookup read");
    8000323a:	00004517          	auipc	a0,0x4
    8000323e:	2d650513          	addi	a0,a0,726 # 80007510 <etext+0x510>
    80003242:	1f5020ef          	jal	80005c36 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003246:	24c1                	addiw	s1,s1,16
    80003248:	04c92783          	lw	a5,76(s2)
    8000324c:	02f4fe63          	bgeu	s1,a5,80003288 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003250:	874e                	mv	a4,s3
    80003252:	86a6                	mv	a3,s1
    80003254:	8652                	mv	a2,s4
    80003256:	4581                	li	a1,0
    80003258:	854a                	mv	a0,s2
    8000325a:	d93ff0ef          	jal	80002fec <readi>
    8000325e:	fd351ee3          	bne	a0,s3,8000323a <dirlookup+0x46>
    if(de.inum == 0)
    80003262:	fa045783          	lhu	a5,-96(s0)
    80003266:	d3e5                	beqz	a5,80003246 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003268:	85da                	mv	a1,s6
    8000326a:	8556                	mv	a0,s5
    8000326c:	f73ff0ef          	jal	800031de <namecmp>
    80003270:	f979                	bnez	a0,80003246 <dirlookup+0x52>
      if(poff)
    80003272:	000b8463          	beqz	s7,8000327a <dirlookup+0x86>
        *poff = off;
    80003276:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    8000327a:	fa045583          	lhu	a1,-96(s0)
    8000327e:	00092503          	lw	a0,0(s2)
    80003282:	f66ff0ef          	jal	800029e8 <iget>
    80003286:	a011                	j	8000328a <dirlookup+0x96>
  return 0;
    80003288:	4501                	li	a0,0
}
    8000328a:	60e6                	ld	ra,88(sp)
    8000328c:	6446                	ld	s0,80(sp)
    8000328e:	64a6                	ld	s1,72(sp)
    80003290:	6906                	ld	s2,64(sp)
    80003292:	79e2                	ld	s3,56(sp)
    80003294:	7a42                	ld	s4,48(sp)
    80003296:	7aa2                	ld	s5,40(sp)
    80003298:	7b02                	ld	s6,32(sp)
    8000329a:	6be2                	ld	s7,24(sp)
    8000329c:	6125                	addi	sp,sp,96
    8000329e:	8082                	ret

00000000800032a0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032a0:	711d                	addi	sp,sp,-96
    800032a2:	ec86                	sd	ra,88(sp)
    800032a4:	e8a2                	sd	s0,80(sp)
    800032a6:	e4a6                	sd	s1,72(sp)
    800032a8:	e0ca                	sd	s2,64(sp)
    800032aa:	fc4e                	sd	s3,56(sp)
    800032ac:	f852                	sd	s4,48(sp)
    800032ae:	f456                	sd	s5,40(sp)
    800032b0:	f05a                	sd	s6,32(sp)
    800032b2:	ec5e                	sd	s7,24(sp)
    800032b4:	e862                	sd	s8,16(sp)
    800032b6:	e466                	sd	s9,8(sp)
    800032b8:	e06a                	sd	s10,0(sp)
    800032ba:	1080                	addi	s0,sp,96
    800032bc:	84aa                	mv	s1,a0
    800032be:	8b2e                	mv	s6,a1
    800032c0:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032c2:	00054703          	lbu	a4,0(a0)
    800032c6:	02f00793          	li	a5,47
    800032ca:	00f70f63          	beq	a4,a5,800032e8 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032ce:	e2ffd0ef          	jal	800010fc <myproc>
    800032d2:	15053503          	ld	a0,336(a0)
    800032d6:	94fff0ef          	jal	80002c24 <idup>
    800032da:	8a2a                	mv	s4,a0
  while(*path == '/')
    800032dc:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    800032e0:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    800032e2:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800032e4:	4b85                	li	s7,1
    800032e6:	a879                	j	80003384 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    800032e8:	4585                	li	a1,1
    800032ea:	852e                	mv	a0,a1
    800032ec:	efcff0ef          	jal	800029e8 <iget>
    800032f0:	8a2a                	mv	s4,a0
    800032f2:	b7ed                	j	800032dc <namex+0x3c>
      iunlockput(ip);
    800032f4:	8552                	mv	a0,s4
    800032f6:	b71ff0ef          	jal	80002e66 <iunlockput>
      return 0;
    800032fa:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    800032fc:	8552                	mv	a0,s4
    800032fe:	60e6                	ld	ra,88(sp)
    80003300:	6446                	ld	s0,80(sp)
    80003302:	64a6                	ld	s1,72(sp)
    80003304:	6906                	ld	s2,64(sp)
    80003306:	79e2                	ld	s3,56(sp)
    80003308:	7a42                	ld	s4,48(sp)
    8000330a:	7aa2                	ld	s5,40(sp)
    8000330c:	7b02                	ld	s6,32(sp)
    8000330e:	6be2                	ld	s7,24(sp)
    80003310:	6c42                	ld	s8,16(sp)
    80003312:	6ca2                	ld	s9,8(sp)
    80003314:	6d02                	ld	s10,0(sp)
    80003316:	6125                	addi	sp,sp,96
    80003318:	8082                	ret
      iunlock(ip);
    8000331a:	8552                	mv	a0,s4
    8000331c:	9edff0ef          	jal	80002d08 <iunlock>
      return ip;
    80003320:	bff1                	j	800032fc <namex+0x5c>
      iunlockput(ip);
    80003322:	8552                	mv	a0,s4
    80003324:	b43ff0ef          	jal	80002e66 <iunlockput>
      return 0;
    80003328:	8a4a                	mv	s4,s2
    8000332a:	bfc9                	j	800032fc <namex+0x5c>
  len = path - s;
    8000332c:	40990633          	sub	a2,s2,s1
    80003330:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003334:	09ac5463          	bge	s8,s10,800033bc <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80003338:	8666                	mv	a2,s9
    8000333a:	85a6                	mv	a1,s1
    8000333c:	8556                	mv	a0,s5
    8000333e:	e81fc0ef          	jal	800001be <memmove>
    80003342:	84ca                	mv	s1,s2
  while(*path == '/')
    80003344:	0004c783          	lbu	a5,0(s1)
    80003348:	01379763          	bne	a5,s3,80003356 <namex+0xb6>
    path++;
    8000334c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000334e:	0004c783          	lbu	a5,0(s1)
    80003352:	ff378de3          	beq	a5,s3,8000334c <namex+0xac>
    ilock(ip);
    80003356:	8552                	mv	a0,s4
    80003358:	903ff0ef          	jal	80002c5a <ilock>
    if(ip->type != T_DIR){
    8000335c:	044a1783          	lh	a5,68(s4)
    80003360:	f9779ae3          	bne	a5,s7,800032f4 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003364:	000b0563          	beqz	s6,8000336e <namex+0xce>
    80003368:	0004c783          	lbu	a5,0(s1)
    8000336c:	d7dd                	beqz	a5,8000331a <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000336e:	4601                	li	a2,0
    80003370:	85d6                	mv	a1,s5
    80003372:	8552                	mv	a0,s4
    80003374:	e81ff0ef          	jal	800031f4 <dirlookup>
    80003378:	892a                	mv	s2,a0
    8000337a:	d545                	beqz	a0,80003322 <namex+0x82>
    iunlockput(ip);
    8000337c:	8552                	mv	a0,s4
    8000337e:	ae9ff0ef          	jal	80002e66 <iunlockput>
    ip = next;
    80003382:	8a4a                	mv	s4,s2
  while(*path == '/')
    80003384:	0004c783          	lbu	a5,0(s1)
    80003388:	01379763          	bne	a5,s3,80003396 <namex+0xf6>
    path++;
    8000338c:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000338e:	0004c783          	lbu	a5,0(s1)
    80003392:	ff378de3          	beq	a5,s3,8000338c <namex+0xec>
  if(*path == 0)
    80003396:	cf8d                	beqz	a5,800033d0 <namex+0x130>
  while(*path != '/' && *path != 0)
    80003398:	0004c783          	lbu	a5,0(s1)
    8000339c:	fd178713          	addi	a4,a5,-47
    800033a0:	cb19                	beqz	a4,800033b6 <namex+0x116>
    800033a2:	cb91                	beqz	a5,800033b6 <namex+0x116>
    800033a4:	8926                	mv	s2,s1
    path++;
    800033a6:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    800033a8:	00094783          	lbu	a5,0(s2)
    800033ac:	fd178713          	addi	a4,a5,-47
    800033b0:	df35                	beqz	a4,8000332c <namex+0x8c>
    800033b2:	fbf5                	bnez	a5,800033a6 <namex+0x106>
    800033b4:	bfa5                	j	8000332c <namex+0x8c>
    800033b6:	8926                	mv	s2,s1
  len = path - s;
    800033b8:	4d01                	li	s10,0
    800033ba:	4601                	li	a2,0
    memmove(name, s, len);
    800033bc:	2601                	sext.w	a2,a2
    800033be:	85a6                	mv	a1,s1
    800033c0:	8556                	mv	a0,s5
    800033c2:	dfdfc0ef          	jal	800001be <memmove>
    name[len] = 0;
    800033c6:	9d56                	add	s10,s10,s5
    800033c8:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffd21c8>
    800033cc:	84ca                	mv	s1,s2
    800033ce:	bf9d                	j	80003344 <namex+0xa4>
  if(nameiparent){
    800033d0:	f20b06e3          	beqz	s6,800032fc <namex+0x5c>
    iput(ip);
    800033d4:	8552                	mv	a0,s4
    800033d6:	a07ff0ef          	jal	80002ddc <iput>
    return 0;
    800033da:	4a01                	li	s4,0
    800033dc:	b705                	j	800032fc <namex+0x5c>

00000000800033de <dirlink>:
{
    800033de:	715d                	addi	sp,sp,-80
    800033e0:	e486                	sd	ra,72(sp)
    800033e2:	e0a2                	sd	s0,64(sp)
    800033e4:	f84a                	sd	s2,48(sp)
    800033e6:	ec56                	sd	s5,24(sp)
    800033e8:	e85a                	sd	s6,16(sp)
    800033ea:	0880                	addi	s0,sp,80
    800033ec:	892a                	mv	s2,a0
    800033ee:	8aae                	mv	s5,a1
    800033f0:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    800033f2:	4601                	li	a2,0
    800033f4:	e01ff0ef          	jal	800031f4 <dirlookup>
    800033f8:	ed1d                	bnez	a0,80003436 <dirlink+0x58>
    800033fa:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800033fc:	04c92483          	lw	s1,76(s2)
    80003400:	c4b9                	beqz	s1,8000344e <dirlink+0x70>
    80003402:	f44e                	sd	s3,40(sp)
    80003404:	f052                	sd	s4,32(sp)
    80003406:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003408:	fb040a13          	addi	s4,s0,-80
    8000340c:	49c1                	li	s3,16
    8000340e:	874e                	mv	a4,s3
    80003410:	86a6                	mv	a3,s1
    80003412:	8652                	mv	a2,s4
    80003414:	4581                	li	a1,0
    80003416:	854a                	mv	a0,s2
    80003418:	bd5ff0ef          	jal	80002fec <readi>
    8000341c:	03351163          	bne	a0,s3,8000343e <dirlink+0x60>
    if(de.inum == 0)
    80003420:	fb045783          	lhu	a5,-80(s0)
    80003424:	c39d                	beqz	a5,8000344a <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003426:	24c1                	addiw	s1,s1,16
    80003428:	04c92783          	lw	a5,76(s2)
    8000342c:	fef4e1e3          	bltu	s1,a5,8000340e <dirlink+0x30>
    80003430:	79a2                	ld	s3,40(sp)
    80003432:	7a02                	ld	s4,32(sp)
    80003434:	a829                	j	8000344e <dirlink+0x70>
    iput(ip);
    80003436:	9a7ff0ef          	jal	80002ddc <iput>
    return -1;
    8000343a:	557d                	li	a0,-1
    8000343c:	a83d                	j	8000347a <dirlink+0x9c>
      panic("dirlink read");
    8000343e:	00004517          	auipc	a0,0x4
    80003442:	0e250513          	addi	a0,a0,226 # 80007520 <etext+0x520>
    80003446:	7f0020ef          	jal	80005c36 <panic>
    8000344a:	79a2                	ld	s3,40(sp)
    8000344c:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8000344e:	4639                	li	a2,14
    80003450:	85d6                	mv	a1,s5
    80003452:	fb240513          	addi	a0,s0,-78
    80003456:	e17fc0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    8000345a:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000345e:	4741                	li	a4,16
    80003460:	86a6                	mv	a3,s1
    80003462:	fb040613          	addi	a2,s0,-80
    80003466:	4581                	li	a1,0
    80003468:	854a                	mv	a0,s2
    8000346a:	c75ff0ef          	jal	800030de <writei>
    8000346e:	1541                	addi	a0,a0,-16
    80003470:	00a03533          	snez	a0,a0
    80003474:	40a0053b          	negw	a0,a0
    80003478:	74e2                	ld	s1,56(sp)
}
    8000347a:	60a6                	ld	ra,72(sp)
    8000347c:	6406                	ld	s0,64(sp)
    8000347e:	7942                	ld	s2,48(sp)
    80003480:	6ae2                	ld	s5,24(sp)
    80003482:	6b42                	ld	s6,16(sp)
    80003484:	6161                	addi	sp,sp,80
    80003486:	8082                	ret

0000000080003488 <namei>:

struct inode*
namei(char *path)
{
    80003488:	1101                	addi	sp,sp,-32
    8000348a:	ec06                	sd	ra,24(sp)
    8000348c:	e822                	sd	s0,16(sp)
    8000348e:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003490:	fe040613          	addi	a2,s0,-32
    80003494:	4581                	li	a1,0
    80003496:	e0bff0ef          	jal	800032a0 <namex>
}
    8000349a:	60e2                	ld	ra,24(sp)
    8000349c:	6442                	ld	s0,16(sp)
    8000349e:	6105                	addi	sp,sp,32
    800034a0:	8082                	ret

00000000800034a2 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034a2:	1141                	addi	sp,sp,-16
    800034a4:	e406                	sd	ra,8(sp)
    800034a6:	e022                	sd	s0,0(sp)
    800034a8:	0800                	addi	s0,sp,16
    800034aa:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034ac:	4585                	li	a1,1
    800034ae:	df3ff0ef          	jal	800032a0 <namex>
}
    800034b2:	60a2                	ld	ra,8(sp)
    800034b4:	6402                	ld	s0,0(sp)
    800034b6:	0141                	addi	sp,sp,16
    800034b8:	8082                	ret

00000000800034ba <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034ba:	1101                	addi	sp,sp,-32
    800034bc:	ec06                	sd	ra,24(sp)
    800034be:	e822                	sd	s0,16(sp)
    800034c0:	e426                	sd	s1,8(sp)
    800034c2:	e04a                	sd	s2,0(sp)
    800034c4:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034c6:	00020917          	auipc	s2,0x20
    800034ca:	65a90913          	addi	s2,s2,1626 # 80023b20 <log>
    800034ce:	01892583          	lw	a1,24(s2)
    800034d2:	02492503          	lw	a0,36(s2)
    800034d6:	8ecff0ef          	jal	800025c2 <bread>
    800034da:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800034dc:	02892603          	lw	a2,40(s2)
    800034e0:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800034e2:	00c05f63          	blez	a2,80003500 <write_head+0x46>
    800034e6:	00020717          	auipc	a4,0x20
    800034ea:	66670713          	addi	a4,a4,1638 # 80023b4c <log+0x2c>
    800034ee:	87aa                	mv	a5,a0
    800034f0:	060a                	slli	a2,a2,0x2
    800034f2:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800034f4:	4314                	lw	a3,0(a4)
    800034f6:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800034f8:	0711                	addi	a4,a4,4
    800034fa:	0791                	addi	a5,a5,4
    800034fc:	fec79ce3          	bne	a5,a2,800034f4 <write_head+0x3a>
  }
  bwrite(buf);
    80003500:	8526                	mv	a0,s1
    80003502:	996ff0ef          	jal	80002698 <bwrite>
  brelse(buf);
    80003506:	8526                	mv	a0,s1
    80003508:	9c2ff0ef          	jal	800026ca <brelse>
}
    8000350c:	60e2                	ld	ra,24(sp)
    8000350e:	6442                	ld	s0,16(sp)
    80003510:	64a2                	ld	s1,8(sp)
    80003512:	6902                	ld	s2,0(sp)
    80003514:	6105                	addi	sp,sp,32
    80003516:	8082                	ret

0000000080003518 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003518:	00020797          	auipc	a5,0x20
    8000351c:	6307a783          	lw	a5,1584(a5) # 80023b48 <log+0x28>
    80003520:	0cf05163          	blez	a5,800035e2 <install_trans+0xca>
{
    80003524:	715d                	addi	sp,sp,-80
    80003526:	e486                	sd	ra,72(sp)
    80003528:	e0a2                	sd	s0,64(sp)
    8000352a:	fc26                	sd	s1,56(sp)
    8000352c:	f84a                	sd	s2,48(sp)
    8000352e:	f44e                	sd	s3,40(sp)
    80003530:	f052                	sd	s4,32(sp)
    80003532:	ec56                	sd	s5,24(sp)
    80003534:	e85a                	sd	s6,16(sp)
    80003536:	e45e                	sd	s7,8(sp)
    80003538:	e062                	sd	s8,0(sp)
    8000353a:	0880                	addi	s0,sp,80
    8000353c:	8b2a                	mv	s6,a0
    8000353e:	00020a97          	auipc	s5,0x20
    80003542:	60ea8a93          	addi	s5,s5,1550 # 80023b4c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003546:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003548:	00004c17          	auipc	s8,0x4
    8000354c:	fe8c0c13          	addi	s8,s8,-24 # 80007530 <etext+0x530>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003550:	00020a17          	auipc	s4,0x20
    80003554:	5d0a0a13          	addi	s4,s4,1488 # 80023b20 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003558:	40000b93          	li	s7,1024
    8000355c:	a025                	j	80003584 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000355e:	000aa603          	lw	a2,0(s5)
    80003562:	85ce                	mv	a1,s3
    80003564:	8562                	mv	a0,s8
    80003566:	3a6020ef          	jal	8000590c <printf>
    8000356a:	a839                	j	80003588 <install_trans+0x70>
    brelse(lbuf);
    8000356c:	854a                	mv	a0,s2
    8000356e:	95cff0ef          	jal	800026ca <brelse>
    brelse(dbuf);
    80003572:	8526                	mv	a0,s1
    80003574:	956ff0ef          	jal	800026ca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003578:	2985                	addiw	s3,s3,1
    8000357a:	0a91                	addi	s5,s5,4
    8000357c:	028a2783          	lw	a5,40(s4)
    80003580:	04f9d563          	bge	s3,a5,800035ca <install_trans+0xb2>
    if(recovering) {
    80003584:	fc0b1de3          	bnez	s6,8000355e <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003588:	018a2583          	lw	a1,24(s4)
    8000358c:	013585bb          	addw	a1,a1,s3
    80003590:	2585                	addiw	a1,a1,1
    80003592:	024a2503          	lw	a0,36(s4)
    80003596:	82cff0ef          	jal	800025c2 <bread>
    8000359a:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000359c:	000aa583          	lw	a1,0(s5)
    800035a0:	024a2503          	lw	a0,36(s4)
    800035a4:	81eff0ef          	jal	800025c2 <bread>
    800035a8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035aa:	865e                	mv	a2,s7
    800035ac:	05890593          	addi	a1,s2,88
    800035b0:	05850513          	addi	a0,a0,88
    800035b4:	c0bfc0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    800035b8:	8526                	mv	a0,s1
    800035ba:	8deff0ef          	jal	80002698 <bwrite>
    if(recovering == 0)
    800035be:	fa0b17e3          	bnez	s6,8000356c <install_trans+0x54>
      bunpin(dbuf);
    800035c2:	8526                	mv	a0,s1
    800035c4:	9beff0ef          	jal	80002782 <bunpin>
    800035c8:	b755                	j	8000356c <install_trans+0x54>
}
    800035ca:	60a6                	ld	ra,72(sp)
    800035cc:	6406                	ld	s0,64(sp)
    800035ce:	74e2                	ld	s1,56(sp)
    800035d0:	7942                	ld	s2,48(sp)
    800035d2:	79a2                	ld	s3,40(sp)
    800035d4:	7a02                	ld	s4,32(sp)
    800035d6:	6ae2                	ld	s5,24(sp)
    800035d8:	6b42                	ld	s6,16(sp)
    800035da:	6ba2                	ld	s7,8(sp)
    800035dc:	6c02                	ld	s8,0(sp)
    800035de:	6161                	addi	sp,sp,80
    800035e0:	8082                	ret
    800035e2:	8082                	ret

00000000800035e4 <initlog>:
{
    800035e4:	7179                	addi	sp,sp,-48
    800035e6:	f406                	sd	ra,40(sp)
    800035e8:	f022                	sd	s0,32(sp)
    800035ea:	ec26                	sd	s1,24(sp)
    800035ec:	e84a                	sd	s2,16(sp)
    800035ee:	e44e                	sd	s3,8(sp)
    800035f0:	1800                	addi	s0,sp,48
    800035f2:	84aa                	mv	s1,a0
    800035f4:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035f6:	00020917          	auipc	s2,0x20
    800035fa:	52a90913          	addi	s2,s2,1322 # 80023b20 <log>
    800035fe:	00004597          	auipc	a1,0x4
    80003602:	f5258593          	addi	a1,a1,-174 # 80007550 <etext+0x550>
    80003606:	854a                	mv	a0,s2
    80003608:	067020ef          	jal	80005e6e <initlock>
  log.start = sb->logstart;
    8000360c:	0149a583          	lw	a1,20(s3)
    80003610:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003614:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003618:	8526                	mv	a0,s1
    8000361a:	fa9fe0ef          	jal	800025c2 <bread>
  log.lh.n = lh->n;
    8000361e:	4d30                	lw	a2,88(a0)
    80003620:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003624:	00c05f63          	blez	a2,80003642 <initlog+0x5e>
    80003628:	87aa                	mv	a5,a0
    8000362a:	00020717          	auipc	a4,0x20
    8000362e:	52270713          	addi	a4,a4,1314 # 80023b4c <log+0x2c>
    80003632:	060a                	slli	a2,a2,0x2
    80003634:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003636:	4ff4                	lw	a3,92(a5)
    80003638:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000363a:	0791                	addi	a5,a5,4
    8000363c:	0711                	addi	a4,a4,4
    8000363e:	fec79ce3          	bne	a5,a2,80003636 <initlog+0x52>
  brelse(buf);
    80003642:	888ff0ef          	jal	800026ca <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003646:	4505                	li	a0,1
    80003648:	ed1ff0ef          	jal	80003518 <install_trans>
  log.lh.n = 0;
    8000364c:	00020797          	auipc	a5,0x20
    80003650:	4e07ae23          	sw	zero,1276(a5) # 80023b48 <log+0x28>
  write_head(); // clear the log
    80003654:	e67ff0ef          	jal	800034ba <write_head>
}
    80003658:	70a2                	ld	ra,40(sp)
    8000365a:	7402                	ld	s0,32(sp)
    8000365c:	64e2                	ld	s1,24(sp)
    8000365e:	6942                	ld	s2,16(sp)
    80003660:	69a2                	ld	s3,8(sp)
    80003662:	6145                	addi	sp,sp,48
    80003664:	8082                	ret

0000000080003666 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003666:	1101                	addi	sp,sp,-32
    80003668:	ec06                	sd	ra,24(sp)
    8000366a:	e822                	sd	s0,16(sp)
    8000366c:	e426                	sd	s1,8(sp)
    8000366e:	e04a                	sd	s2,0(sp)
    80003670:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003672:	00020517          	auipc	a0,0x20
    80003676:	4ae50513          	addi	a0,a0,1198 # 80023b20 <log>
    8000367a:	07f020ef          	jal	80005ef8 <acquire>
  while(1){
    if(log.committing){
    8000367e:	00020497          	auipc	s1,0x20
    80003682:	4a248493          	addi	s1,s1,1186 # 80023b20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003686:	4979                	li	s2,30
    80003688:	a029                	j	80003692 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000368a:	85a6                	mv	a1,s1
    8000368c:	8526                	mv	a0,s1
    8000368e:	8b4fe0ef          	jal	80001742 <sleep>
    if(log.committing){
    80003692:	509c                	lw	a5,32(s1)
    80003694:	fbfd                	bnez	a5,8000368a <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003696:	4cd8                	lw	a4,28(s1)
    80003698:	2705                	addiw	a4,a4,1
    8000369a:	0027179b          	slliw	a5,a4,0x2
    8000369e:	9fb9                	addw	a5,a5,a4
    800036a0:	0017979b          	slliw	a5,a5,0x1
    800036a4:	5494                	lw	a3,40(s1)
    800036a6:	9fb5                	addw	a5,a5,a3
    800036a8:	00f95763          	bge	s2,a5,800036b6 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036ac:	85a6                	mv	a1,s1
    800036ae:	8526                	mv	a0,s1
    800036b0:	892fe0ef          	jal	80001742 <sleep>
    800036b4:	bff9                	j	80003692 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800036b6:	00020797          	auipc	a5,0x20
    800036ba:	48e7a323          	sw	a4,1158(a5) # 80023b3c <log+0x1c>
      release(&log.lock);
    800036be:	00020517          	auipc	a0,0x20
    800036c2:	46250513          	addi	a0,a0,1122 # 80023b20 <log>
    800036c6:	0c7020ef          	jal	80005f8c <release>
      break;
    }
  }
}
    800036ca:	60e2                	ld	ra,24(sp)
    800036cc:	6442                	ld	s0,16(sp)
    800036ce:	64a2                	ld	s1,8(sp)
    800036d0:	6902                	ld	s2,0(sp)
    800036d2:	6105                	addi	sp,sp,32
    800036d4:	8082                	ret

00000000800036d6 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036d6:	7139                	addi	sp,sp,-64
    800036d8:	fc06                	sd	ra,56(sp)
    800036da:	f822                	sd	s0,48(sp)
    800036dc:	f426                	sd	s1,40(sp)
    800036de:	f04a                	sd	s2,32(sp)
    800036e0:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036e2:	00020497          	auipc	s1,0x20
    800036e6:	43e48493          	addi	s1,s1,1086 # 80023b20 <log>
    800036ea:	8526                	mv	a0,s1
    800036ec:	00d020ef          	jal	80005ef8 <acquire>
  log.outstanding -= 1;
    800036f0:	4cdc                	lw	a5,28(s1)
    800036f2:	37fd                	addiw	a5,a5,-1
    800036f4:	893e                	mv	s2,a5
    800036f6:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800036f8:	509c                	lw	a5,32(s1)
    800036fa:	e7b1                	bnez	a5,80003746 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    800036fc:	04091e63          	bnez	s2,80003758 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003700:	00020497          	auipc	s1,0x20
    80003704:	42048493          	addi	s1,s1,1056 # 80023b20 <log>
    80003708:	4785                	li	a5,1
    8000370a:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000370c:	8526                	mv	a0,s1
    8000370e:	07f020ef          	jal	80005f8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003712:	549c                	lw	a5,40(s1)
    80003714:	06f04463          	bgtz	a5,8000377c <end_op+0xa6>
    acquire(&log.lock);
    80003718:	00020517          	auipc	a0,0x20
    8000371c:	40850513          	addi	a0,a0,1032 # 80023b20 <log>
    80003720:	7d8020ef          	jal	80005ef8 <acquire>
    log.committing = 0;
    80003724:	00020797          	auipc	a5,0x20
    80003728:	4007ae23          	sw	zero,1052(a5) # 80023b40 <log+0x20>
    wakeup(&log);
    8000372c:	00020517          	auipc	a0,0x20
    80003730:	3f450513          	addi	a0,a0,1012 # 80023b20 <log>
    80003734:	85afe0ef          	jal	8000178e <wakeup>
    release(&log.lock);
    80003738:	00020517          	auipc	a0,0x20
    8000373c:	3e850513          	addi	a0,a0,1000 # 80023b20 <log>
    80003740:	04d020ef          	jal	80005f8c <release>
}
    80003744:	a035                	j	80003770 <end_op+0x9a>
    80003746:	ec4e                	sd	s3,24(sp)
    80003748:	e852                	sd	s4,16(sp)
    8000374a:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000374c:	00004517          	auipc	a0,0x4
    80003750:	e0c50513          	addi	a0,a0,-500 # 80007558 <etext+0x558>
    80003754:	4e2020ef          	jal	80005c36 <panic>
    wakeup(&log);
    80003758:	00020517          	auipc	a0,0x20
    8000375c:	3c850513          	addi	a0,a0,968 # 80023b20 <log>
    80003760:	82efe0ef          	jal	8000178e <wakeup>
  release(&log.lock);
    80003764:	00020517          	auipc	a0,0x20
    80003768:	3bc50513          	addi	a0,a0,956 # 80023b20 <log>
    8000376c:	021020ef          	jal	80005f8c <release>
}
    80003770:	70e2                	ld	ra,56(sp)
    80003772:	7442                	ld	s0,48(sp)
    80003774:	74a2                	ld	s1,40(sp)
    80003776:	7902                	ld	s2,32(sp)
    80003778:	6121                	addi	sp,sp,64
    8000377a:	8082                	ret
    8000377c:	ec4e                	sd	s3,24(sp)
    8000377e:	e852                	sd	s4,16(sp)
    80003780:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003782:	00020a97          	auipc	s5,0x20
    80003786:	3caa8a93          	addi	s5,s5,970 # 80023b4c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000378a:	00020a17          	auipc	s4,0x20
    8000378e:	396a0a13          	addi	s4,s4,918 # 80023b20 <log>
    80003792:	018a2583          	lw	a1,24(s4)
    80003796:	012585bb          	addw	a1,a1,s2
    8000379a:	2585                	addiw	a1,a1,1
    8000379c:	024a2503          	lw	a0,36(s4)
    800037a0:	e23fe0ef          	jal	800025c2 <bread>
    800037a4:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037a6:	000aa583          	lw	a1,0(s5)
    800037aa:	024a2503          	lw	a0,36(s4)
    800037ae:	e15fe0ef          	jal	800025c2 <bread>
    800037b2:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037b4:	40000613          	li	a2,1024
    800037b8:	05850593          	addi	a1,a0,88
    800037bc:	05848513          	addi	a0,s1,88
    800037c0:	9fffc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    800037c4:	8526                	mv	a0,s1
    800037c6:	ed3fe0ef          	jal	80002698 <bwrite>
    brelse(from);
    800037ca:	854e                	mv	a0,s3
    800037cc:	efffe0ef          	jal	800026ca <brelse>
    brelse(to);
    800037d0:	8526                	mv	a0,s1
    800037d2:	ef9fe0ef          	jal	800026ca <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037d6:	2905                	addiw	s2,s2,1
    800037d8:	0a91                	addi	s5,s5,4
    800037da:	028a2783          	lw	a5,40(s4)
    800037de:	faf94ae3          	blt	s2,a5,80003792 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037e2:	cd9ff0ef          	jal	800034ba <write_head>
    install_trans(0); // Now install writes to home locations
    800037e6:	4501                	li	a0,0
    800037e8:	d31ff0ef          	jal	80003518 <install_trans>
    log.lh.n = 0;
    800037ec:	00020797          	auipc	a5,0x20
    800037f0:	3407ae23          	sw	zero,860(a5) # 80023b48 <log+0x28>
    write_head();    // Erase the transaction from the log
    800037f4:	cc7ff0ef          	jal	800034ba <write_head>
    800037f8:	69e2                	ld	s3,24(sp)
    800037fa:	6a42                	ld	s4,16(sp)
    800037fc:	6aa2                	ld	s5,8(sp)
    800037fe:	bf29                	j	80003718 <end_op+0x42>

0000000080003800 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003800:	1101                	addi	sp,sp,-32
    80003802:	ec06                	sd	ra,24(sp)
    80003804:	e822                	sd	s0,16(sp)
    80003806:	e426                	sd	s1,8(sp)
    80003808:	1000                	addi	s0,sp,32
    8000380a:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000380c:	00020517          	auipc	a0,0x20
    80003810:	31450513          	addi	a0,a0,788 # 80023b20 <log>
    80003814:	6e4020ef          	jal	80005ef8 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003818:	00020617          	auipc	a2,0x20
    8000381c:	33062603          	lw	a2,816(a2) # 80023b48 <log+0x28>
    80003820:	47f5                	li	a5,29
    80003822:	04c7cd63          	blt	a5,a2,8000387c <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003826:	00020797          	auipc	a5,0x20
    8000382a:	3167a783          	lw	a5,790(a5) # 80023b3c <log+0x1c>
    8000382e:	04f05d63          	blez	a5,80003888 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003832:	4781                	li	a5,0
    80003834:	06c05063          	blez	a2,80003894 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003838:	44cc                	lw	a1,12(s1)
    8000383a:	00020717          	auipc	a4,0x20
    8000383e:	31270713          	addi	a4,a4,786 # 80023b4c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003842:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003844:	4314                	lw	a3,0(a4)
    80003846:	04b68763          	beq	a3,a1,80003894 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    8000384a:	2785                	addiw	a5,a5,1
    8000384c:	0711                	addi	a4,a4,4
    8000384e:	fef61be3          	bne	a2,a5,80003844 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003852:	060a                	slli	a2,a2,0x2
    80003854:	02060613          	addi	a2,a2,32
    80003858:	00020797          	auipc	a5,0x20
    8000385c:	2c878793          	addi	a5,a5,712 # 80023b20 <log>
    80003860:	97b2                	add	a5,a5,a2
    80003862:	44d8                	lw	a4,12(s1)
    80003864:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003866:	8526                	mv	a0,s1
    80003868:	ee7fe0ef          	jal	8000274e <bpin>
    log.lh.n++;
    8000386c:	00020717          	auipc	a4,0x20
    80003870:	2b470713          	addi	a4,a4,692 # 80023b20 <log>
    80003874:	571c                	lw	a5,40(a4)
    80003876:	2785                	addiw	a5,a5,1
    80003878:	d71c                	sw	a5,40(a4)
    8000387a:	a815                	j	800038ae <log_write+0xae>
    panic("too big a transaction");
    8000387c:	00004517          	auipc	a0,0x4
    80003880:	cec50513          	addi	a0,a0,-788 # 80007568 <etext+0x568>
    80003884:	3b2020ef          	jal	80005c36 <panic>
    panic("log_write outside of trans");
    80003888:	00004517          	auipc	a0,0x4
    8000388c:	cf850513          	addi	a0,a0,-776 # 80007580 <etext+0x580>
    80003890:	3a6020ef          	jal	80005c36 <panic>
  log.lh.block[i] = b->blockno;
    80003894:	00279693          	slli	a3,a5,0x2
    80003898:	02068693          	addi	a3,a3,32
    8000389c:	00020717          	auipc	a4,0x20
    800038a0:	28470713          	addi	a4,a4,644 # 80023b20 <log>
    800038a4:	9736                	add	a4,a4,a3
    800038a6:	44d4                	lw	a3,12(s1)
    800038a8:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038aa:	faf60ee3          	beq	a2,a5,80003866 <log_write+0x66>
  }
  release(&log.lock);
    800038ae:	00020517          	auipc	a0,0x20
    800038b2:	27250513          	addi	a0,a0,626 # 80023b20 <log>
    800038b6:	6d6020ef          	jal	80005f8c <release>
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	64a2                	ld	s1,8(sp)
    800038c0:	6105                	addi	sp,sp,32
    800038c2:	8082                	ret

00000000800038c4 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038c4:	1101                	addi	sp,sp,-32
    800038c6:	ec06                	sd	ra,24(sp)
    800038c8:	e822                	sd	s0,16(sp)
    800038ca:	e426                	sd	s1,8(sp)
    800038cc:	e04a                	sd	s2,0(sp)
    800038ce:	1000                	addi	s0,sp,32
    800038d0:	84aa                	mv	s1,a0
    800038d2:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038d4:	00004597          	auipc	a1,0x4
    800038d8:	ccc58593          	addi	a1,a1,-820 # 800075a0 <etext+0x5a0>
    800038dc:	0521                	addi	a0,a0,8
    800038de:	590020ef          	jal	80005e6e <initlock>
  lk->name = name;
    800038e2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038e6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038ea:	0204a423          	sw	zero,40(s1)
}
    800038ee:	60e2                	ld	ra,24(sp)
    800038f0:	6442                	ld	s0,16(sp)
    800038f2:	64a2                	ld	s1,8(sp)
    800038f4:	6902                	ld	s2,0(sp)
    800038f6:	6105                	addi	sp,sp,32
    800038f8:	8082                	ret

00000000800038fa <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038fa:	1101                	addi	sp,sp,-32
    800038fc:	ec06                	sd	ra,24(sp)
    800038fe:	e822                	sd	s0,16(sp)
    80003900:	e426                	sd	s1,8(sp)
    80003902:	e04a                	sd	s2,0(sp)
    80003904:	1000                	addi	s0,sp,32
    80003906:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003908:	00850913          	addi	s2,a0,8
    8000390c:	854a                	mv	a0,s2
    8000390e:	5ea020ef          	jal	80005ef8 <acquire>
  while (lk->locked) {
    80003912:	409c                	lw	a5,0(s1)
    80003914:	c799                	beqz	a5,80003922 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003916:	85ca                	mv	a1,s2
    80003918:	8526                	mv	a0,s1
    8000391a:	e29fd0ef          	jal	80001742 <sleep>
  while (lk->locked) {
    8000391e:	409c                	lw	a5,0(s1)
    80003920:	fbfd                	bnez	a5,80003916 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003922:	4785                	li	a5,1
    80003924:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003926:	fd6fd0ef          	jal	800010fc <myproc>
    8000392a:	591c                	lw	a5,48(a0)
    8000392c:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000392e:	854a                	mv	a0,s2
    80003930:	65c020ef          	jal	80005f8c <release>
}
    80003934:	60e2                	ld	ra,24(sp)
    80003936:	6442                	ld	s0,16(sp)
    80003938:	64a2                	ld	s1,8(sp)
    8000393a:	6902                	ld	s2,0(sp)
    8000393c:	6105                	addi	sp,sp,32
    8000393e:	8082                	ret

0000000080003940 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003940:	1101                	addi	sp,sp,-32
    80003942:	ec06                	sd	ra,24(sp)
    80003944:	e822                	sd	s0,16(sp)
    80003946:	e426                	sd	s1,8(sp)
    80003948:	e04a                	sd	s2,0(sp)
    8000394a:	1000                	addi	s0,sp,32
    8000394c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000394e:	00850913          	addi	s2,a0,8
    80003952:	854a                	mv	a0,s2
    80003954:	5a4020ef          	jal	80005ef8 <acquire>
  lk->locked = 0;
    80003958:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000395c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003960:	8526                	mv	a0,s1
    80003962:	e2dfd0ef          	jal	8000178e <wakeup>
  release(&lk->lk);
    80003966:	854a                	mv	a0,s2
    80003968:	624020ef          	jal	80005f8c <release>
}
    8000396c:	60e2                	ld	ra,24(sp)
    8000396e:	6442                	ld	s0,16(sp)
    80003970:	64a2                	ld	s1,8(sp)
    80003972:	6902                	ld	s2,0(sp)
    80003974:	6105                	addi	sp,sp,32
    80003976:	8082                	ret

0000000080003978 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003978:	7179                	addi	sp,sp,-48
    8000397a:	f406                	sd	ra,40(sp)
    8000397c:	f022                	sd	s0,32(sp)
    8000397e:	ec26                	sd	s1,24(sp)
    80003980:	e84a                	sd	s2,16(sp)
    80003982:	1800                	addi	s0,sp,48
    80003984:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003986:	00850913          	addi	s2,a0,8
    8000398a:	854a                	mv	a0,s2
    8000398c:	56c020ef          	jal	80005ef8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003990:	409c                	lw	a5,0(s1)
    80003992:	ef81                	bnez	a5,800039aa <holdingsleep+0x32>
    80003994:	4481                	li	s1,0
  release(&lk->lk);
    80003996:	854a                	mv	a0,s2
    80003998:	5f4020ef          	jal	80005f8c <release>
  return r;
}
    8000399c:	8526                	mv	a0,s1
    8000399e:	70a2                	ld	ra,40(sp)
    800039a0:	7402                	ld	s0,32(sp)
    800039a2:	64e2                	ld	s1,24(sp)
    800039a4:	6942                	ld	s2,16(sp)
    800039a6:	6145                	addi	sp,sp,48
    800039a8:	8082                	ret
    800039aa:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ac:	0284a983          	lw	s3,40(s1)
    800039b0:	f4cfd0ef          	jal	800010fc <myproc>
    800039b4:	5904                	lw	s1,48(a0)
    800039b6:	413484b3          	sub	s1,s1,s3
    800039ba:	0014b493          	seqz	s1,s1
    800039be:	69a2                	ld	s3,8(sp)
    800039c0:	bfd9                	j	80003996 <holdingsleep+0x1e>

00000000800039c2 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039c2:	1141                	addi	sp,sp,-16
    800039c4:	e406                	sd	ra,8(sp)
    800039c6:	e022                	sd	s0,0(sp)
    800039c8:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039ca:	00004597          	auipc	a1,0x4
    800039ce:	be658593          	addi	a1,a1,-1050 # 800075b0 <etext+0x5b0>
    800039d2:	00020517          	auipc	a0,0x20
    800039d6:	29650513          	addi	a0,a0,662 # 80023c68 <ftable>
    800039da:	494020ef          	jal	80005e6e <initlock>
}
    800039de:	60a2                	ld	ra,8(sp)
    800039e0:	6402                	ld	s0,0(sp)
    800039e2:	0141                	addi	sp,sp,16
    800039e4:	8082                	ret

00000000800039e6 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039e6:	1101                	addi	sp,sp,-32
    800039e8:	ec06                	sd	ra,24(sp)
    800039ea:	e822                	sd	s0,16(sp)
    800039ec:	e426                	sd	s1,8(sp)
    800039ee:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039f0:	00020517          	auipc	a0,0x20
    800039f4:	27850513          	addi	a0,a0,632 # 80023c68 <ftable>
    800039f8:	500020ef          	jal	80005ef8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039fc:	00020497          	auipc	s1,0x20
    80003a00:	28448493          	addi	s1,s1,644 # 80023c80 <ftable+0x18>
    80003a04:	00021717          	auipc	a4,0x21
    80003a08:	21c70713          	addi	a4,a4,540 # 80024c20 <disk>
    if(f->ref == 0){
    80003a0c:	40dc                	lw	a5,4(s1)
    80003a0e:	cf89                	beqz	a5,80003a28 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a10:	02848493          	addi	s1,s1,40
    80003a14:	fee49ce3          	bne	s1,a4,80003a0c <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a18:	00020517          	auipc	a0,0x20
    80003a1c:	25050513          	addi	a0,a0,592 # 80023c68 <ftable>
    80003a20:	56c020ef          	jal	80005f8c <release>
  return 0;
    80003a24:	4481                	li	s1,0
    80003a26:	a809                	j	80003a38 <filealloc+0x52>
      f->ref = 1;
    80003a28:	4785                	li	a5,1
    80003a2a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a2c:	00020517          	auipc	a0,0x20
    80003a30:	23c50513          	addi	a0,a0,572 # 80023c68 <ftable>
    80003a34:	558020ef          	jal	80005f8c <release>
}
    80003a38:	8526                	mv	a0,s1
    80003a3a:	60e2                	ld	ra,24(sp)
    80003a3c:	6442                	ld	s0,16(sp)
    80003a3e:	64a2                	ld	s1,8(sp)
    80003a40:	6105                	addi	sp,sp,32
    80003a42:	8082                	ret

0000000080003a44 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a44:	1101                	addi	sp,sp,-32
    80003a46:	ec06                	sd	ra,24(sp)
    80003a48:	e822                	sd	s0,16(sp)
    80003a4a:	e426                	sd	s1,8(sp)
    80003a4c:	1000                	addi	s0,sp,32
    80003a4e:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a50:	00020517          	auipc	a0,0x20
    80003a54:	21850513          	addi	a0,a0,536 # 80023c68 <ftable>
    80003a58:	4a0020ef          	jal	80005ef8 <acquire>
  if(f->ref < 1)
    80003a5c:	40dc                	lw	a5,4(s1)
    80003a5e:	02f05063          	blez	a5,80003a7e <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003a62:	2785                	addiw	a5,a5,1
    80003a64:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a66:	00020517          	auipc	a0,0x20
    80003a6a:	20250513          	addi	a0,a0,514 # 80023c68 <ftable>
    80003a6e:	51e020ef          	jal	80005f8c <release>
  return f;
}
    80003a72:	8526                	mv	a0,s1
    80003a74:	60e2                	ld	ra,24(sp)
    80003a76:	6442                	ld	s0,16(sp)
    80003a78:	64a2                	ld	s1,8(sp)
    80003a7a:	6105                	addi	sp,sp,32
    80003a7c:	8082                	ret
    panic("filedup");
    80003a7e:	00004517          	auipc	a0,0x4
    80003a82:	b3a50513          	addi	a0,a0,-1222 # 800075b8 <etext+0x5b8>
    80003a86:	1b0020ef          	jal	80005c36 <panic>

0000000080003a8a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a8a:	7139                	addi	sp,sp,-64
    80003a8c:	fc06                	sd	ra,56(sp)
    80003a8e:	f822                	sd	s0,48(sp)
    80003a90:	f426                	sd	s1,40(sp)
    80003a92:	0080                	addi	s0,sp,64
    80003a94:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003a96:	00020517          	auipc	a0,0x20
    80003a9a:	1d250513          	addi	a0,a0,466 # 80023c68 <ftable>
    80003a9e:	45a020ef          	jal	80005ef8 <acquire>
  if(f->ref < 1)
    80003aa2:	40dc                	lw	a5,4(s1)
    80003aa4:	04f05a63          	blez	a5,80003af8 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003aa8:	37fd                	addiw	a5,a5,-1
    80003aaa:	c0dc                	sw	a5,4(s1)
    80003aac:	06f04063          	bgtz	a5,80003b0c <fileclose+0x82>
    80003ab0:	f04a                	sd	s2,32(sp)
    80003ab2:	ec4e                	sd	s3,24(sp)
    80003ab4:	e852                	sd	s4,16(sp)
    80003ab6:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ab8:	0004a903          	lw	s2,0(s1)
    80003abc:	0094c783          	lbu	a5,9(s1)
    80003ac0:	89be                	mv	s3,a5
    80003ac2:	689c                	ld	a5,16(s1)
    80003ac4:	8a3e                	mv	s4,a5
    80003ac6:	6c9c                	ld	a5,24(s1)
    80003ac8:	8abe                	mv	s5,a5
  f->ref = 0;
    80003aca:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ace:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ad2:	00020517          	auipc	a0,0x20
    80003ad6:	19650513          	addi	a0,a0,406 # 80023c68 <ftable>
    80003ada:	4b2020ef          	jal	80005f8c <release>

  if(ff.type == FD_PIPE){
    80003ade:	4785                	li	a5,1
    80003ae0:	04f90163          	beq	s2,a5,80003b22 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003ae4:	ffe9079b          	addiw	a5,s2,-2
    80003ae8:	4705                	li	a4,1
    80003aea:	04f77563          	bgeu	a4,a5,80003b34 <fileclose+0xaa>
    80003aee:	7902                	ld	s2,32(sp)
    80003af0:	69e2                	ld	s3,24(sp)
    80003af2:	6a42                	ld	s4,16(sp)
    80003af4:	6aa2                	ld	s5,8(sp)
    80003af6:	a00d                	j	80003b18 <fileclose+0x8e>
    80003af8:	f04a                	sd	s2,32(sp)
    80003afa:	ec4e                	sd	s3,24(sp)
    80003afc:	e852                	sd	s4,16(sp)
    80003afe:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b00:	00004517          	auipc	a0,0x4
    80003b04:	ac050513          	addi	a0,a0,-1344 # 800075c0 <etext+0x5c0>
    80003b08:	12e020ef          	jal	80005c36 <panic>
    release(&ftable.lock);
    80003b0c:	00020517          	auipc	a0,0x20
    80003b10:	15c50513          	addi	a0,a0,348 # 80023c68 <ftable>
    80003b14:	478020ef          	jal	80005f8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b18:	70e2                	ld	ra,56(sp)
    80003b1a:	7442                	ld	s0,48(sp)
    80003b1c:	74a2                	ld	s1,40(sp)
    80003b1e:	6121                	addi	sp,sp,64
    80003b20:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b22:	85ce                	mv	a1,s3
    80003b24:	8552                	mv	a0,s4
    80003b26:	348000ef          	jal	80003e6e <pipeclose>
    80003b2a:	7902                	ld	s2,32(sp)
    80003b2c:	69e2                	ld	s3,24(sp)
    80003b2e:	6a42                	ld	s4,16(sp)
    80003b30:	6aa2                	ld	s5,8(sp)
    80003b32:	b7dd                	j	80003b18 <fileclose+0x8e>
    begin_op();
    80003b34:	b33ff0ef          	jal	80003666 <begin_op>
    iput(ff.ip);
    80003b38:	8556                	mv	a0,s5
    80003b3a:	aa2ff0ef          	jal	80002ddc <iput>
    end_op();
    80003b3e:	b99ff0ef          	jal	800036d6 <end_op>
    80003b42:	7902                	ld	s2,32(sp)
    80003b44:	69e2                	ld	s3,24(sp)
    80003b46:	6a42                	ld	s4,16(sp)
    80003b48:	6aa2                	ld	s5,8(sp)
    80003b4a:	b7f9                	j	80003b18 <fileclose+0x8e>

0000000080003b4c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b4c:	715d                	addi	sp,sp,-80
    80003b4e:	e486                	sd	ra,72(sp)
    80003b50:	e0a2                	sd	s0,64(sp)
    80003b52:	fc26                	sd	s1,56(sp)
    80003b54:	f052                	sd	s4,32(sp)
    80003b56:	0880                	addi	s0,sp,80
    80003b58:	84aa                	mv	s1,a0
    80003b5a:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80003b5c:	da0fd0ef          	jal	800010fc <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b60:	409c                	lw	a5,0(s1)
    80003b62:	37f9                	addiw	a5,a5,-2
    80003b64:	4705                	li	a4,1
    80003b66:	04f76263          	bltu	a4,a5,80003baa <filestat+0x5e>
    80003b6a:	f84a                	sd	s2,48(sp)
    80003b6c:	f44e                	sd	s3,40(sp)
    80003b6e:	89aa                	mv	s3,a0
    ilock(f->ip);
    80003b70:	6c88                	ld	a0,24(s1)
    80003b72:	8e8ff0ef          	jal	80002c5a <ilock>
    stati(f->ip, &st);
    80003b76:	fb840913          	addi	s2,s0,-72
    80003b7a:	85ca                	mv	a1,s2
    80003b7c:	6c88                	ld	a0,24(s1)
    80003b7e:	c40ff0ef          	jal	80002fbe <stati>
    iunlock(f->ip);
    80003b82:	6c88                	ld	a0,24(s1)
    80003b84:	984ff0ef          	jal	80002d08 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b88:	46e1                	li	a3,24
    80003b8a:	864a                	mv	a2,s2
    80003b8c:	85d2                	mv	a1,s4
    80003b8e:	0509b503          	ld	a0,80(s3)
    80003b92:	88cfd0ef          	jal	80000c1e <copyout>
    80003b96:	41f5551b          	sraiw	a0,a0,0x1f
    80003b9a:	7942                	ld	s2,48(sp)
    80003b9c:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003b9e:	60a6                	ld	ra,72(sp)
    80003ba0:	6406                	ld	s0,64(sp)
    80003ba2:	74e2                	ld	s1,56(sp)
    80003ba4:	7a02                	ld	s4,32(sp)
    80003ba6:	6161                	addi	sp,sp,80
    80003ba8:	8082                	ret
  return -1;
    80003baa:	557d                	li	a0,-1
    80003bac:	bfcd                	j	80003b9e <filestat+0x52>

0000000080003bae <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bae:	7179                	addi	sp,sp,-48
    80003bb0:	f406                	sd	ra,40(sp)
    80003bb2:	f022                	sd	s0,32(sp)
    80003bb4:	e84a                	sd	s2,16(sp)
    80003bb6:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003bb8:	00854783          	lbu	a5,8(a0)
    80003bbc:	cfd1                	beqz	a5,80003c58 <fileread+0xaa>
    80003bbe:	ec26                	sd	s1,24(sp)
    80003bc0:	e44e                	sd	s3,8(sp)
    80003bc2:	84aa                	mv	s1,a0
    80003bc4:	892e                	mv	s2,a1
    80003bc6:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bc8:	411c                	lw	a5,0(a0)
    80003bca:	4705                	li	a4,1
    80003bcc:	04e78363          	beq	a5,a4,80003c12 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bd0:	470d                	li	a4,3
    80003bd2:	04e78763          	beq	a5,a4,80003c20 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003bd6:	4709                	li	a4,2
    80003bd8:	06e79a63          	bne	a5,a4,80003c4c <fileread+0x9e>
    ilock(f->ip);
    80003bdc:	6d08                	ld	a0,24(a0)
    80003bde:	87cff0ef          	jal	80002c5a <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003be2:	874e                	mv	a4,s3
    80003be4:	5094                	lw	a3,32(s1)
    80003be6:	864a                	mv	a2,s2
    80003be8:	4585                	li	a1,1
    80003bea:	6c88                	ld	a0,24(s1)
    80003bec:	c00ff0ef          	jal	80002fec <readi>
    80003bf0:	892a                	mv	s2,a0
    80003bf2:	00a05563          	blez	a0,80003bfc <fileread+0x4e>
      f->off += r;
    80003bf6:	509c                	lw	a5,32(s1)
    80003bf8:	9fa9                	addw	a5,a5,a0
    80003bfa:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003bfc:	6c88                	ld	a0,24(s1)
    80003bfe:	90aff0ef          	jal	80002d08 <iunlock>
    80003c02:	64e2                	ld	s1,24(sp)
    80003c04:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c06:	854a                	mv	a0,s2
    80003c08:	70a2                	ld	ra,40(sp)
    80003c0a:	7402                	ld	s0,32(sp)
    80003c0c:	6942                	ld	s2,16(sp)
    80003c0e:	6145                	addi	sp,sp,48
    80003c10:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c12:	6908                	ld	a0,16(a0)
    80003c14:	3b0000ef          	jal	80003fc4 <piperead>
    80003c18:	892a                	mv	s2,a0
    80003c1a:	64e2                	ld	s1,24(sp)
    80003c1c:	69a2                	ld	s3,8(sp)
    80003c1e:	b7e5                	j	80003c06 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c20:	02451783          	lh	a5,36(a0)
    80003c24:	03079693          	slli	a3,a5,0x30
    80003c28:	92c1                	srli	a3,a3,0x30
    80003c2a:	4725                	li	a4,9
    80003c2c:	02d76963          	bltu	a4,a3,80003c5e <fileread+0xb0>
    80003c30:	0792                	slli	a5,a5,0x4
    80003c32:	00020717          	auipc	a4,0x20
    80003c36:	f9670713          	addi	a4,a4,-106 # 80023bc8 <devsw>
    80003c3a:	97ba                	add	a5,a5,a4
    80003c3c:	639c                	ld	a5,0(a5)
    80003c3e:	c78d                	beqz	a5,80003c68 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80003c40:	4505                	li	a0,1
    80003c42:	9782                	jalr	a5
    80003c44:	892a                	mv	s2,a0
    80003c46:	64e2                	ld	s1,24(sp)
    80003c48:	69a2                	ld	s3,8(sp)
    80003c4a:	bf75                	j	80003c06 <fileread+0x58>
    panic("fileread");
    80003c4c:	00004517          	auipc	a0,0x4
    80003c50:	98450513          	addi	a0,a0,-1660 # 800075d0 <etext+0x5d0>
    80003c54:	7e3010ef          	jal	80005c36 <panic>
    return -1;
    80003c58:	57fd                	li	a5,-1
    80003c5a:	893e                	mv	s2,a5
    80003c5c:	b76d                	j	80003c06 <fileread+0x58>
      return -1;
    80003c5e:	57fd                	li	a5,-1
    80003c60:	893e                	mv	s2,a5
    80003c62:	64e2                	ld	s1,24(sp)
    80003c64:	69a2                	ld	s3,8(sp)
    80003c66:	b745                	j	80003c06 <fileread+0x58>
    80003c68:	57fd                	li	a5,-1
    80003c6a:	893e                	mv	s2,a5
    80003c6c:	64e2                	ld	s1,24(sp)
    80003c6e:	69a2                	ld	s3,8(sp)
    80003c70:	bf59                	j	80003c06 <fileread+0x58>

0000000080003c72 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c72:	00954783          	lbu	a5,9(a0)
    80003c76:	10078f63          	beqz	a5,80003d94 <filewrite+0x122>
{
    80003c7a:	711d                	addi	sp,sp,-96
    80003c7c:	ec86                	sd	ra,88(sp)
    80003c7e:	e8a2                	sd	s0,80(sp)
    80003c80:	e0ca                	sd	s2,64(sp)
    80003c82:	f456                	sd	s5,40(sp)
    80003c84:	f05a                	sd	s6,32(sp)
    80003c86:	1080                	addi	s0,sp,96
    80003c88:	892a                	mv	s2,a0
    80003c8a:	8b2e                	mv	s6,a1
    80003c8c:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c8e:	411c                	lw	a5,0(a0)
    80003c90:	4705                	li	a4,1
    80003c92:	02e78a63          	beq	a5,a4,80003cc6 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c96:	470d                	li	a4,3
    80003c98:	02e78b63          	beq	a5,a4,80003cce <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c9c:	4709                	li	a4,2
    80003c9e:	0ce79f63          	bne	a5,a4,80003d7c <filewrite+0x10a>
    80003ca2:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003ca4:	0ac05a63          	blez	a2,80003d58 <filewrite+0xe6>
    80003ca8:	e4a6                	sd	s1,72(sp)
    80003caa:	fc4e                	sd	s3,56(sp)
    80003cac:	ec5e                	sd	s7,24(sp)
    80003cae:	e862                	sd	s8,16(sp)
    80003cb0:	e466                	sd	s9,8(sp)
    int i = 0;
    80003cb2:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003cb4:	6b85                	lui	s7,0x1
    80003cb6:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003cba:	6785                	lui	a5,0x1
    80003cbc:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80003cc0:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cc2:	4c05                	li	s8,1
    80003cc4:	a8ad                	j	80003d3e <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003cc6:	6908                	ld	a0,16(a0)
    80003cc8:	204000ef          	jal	80003ecc <pipewrite>
    80003ccc:	a04d                	j	80003d6e <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cce:	02451783          	lh	a5,36(a0)
    80003cd2:	03079693          	slli	a3,a5,0x30
    80003cd6:	92c1                	srli	a3,a3,0x30
    80003cd8:	4725                	li	a4,9
    80003cda:	0ad76f63          	bltu	a4,a3,80003d98 <filewrite+0x126>
    80003cde:	0792                	slli	a5,a5,0x4
    80003ce0:	00020717          	auipc	a4,0x20
    80003ce4:	ee870713          	addi	a4,a4,-280 # 80023bc8 <devsw>
    80003ce8:	97ba                	add	a5,a5,a4
    80003cea:	679c                	ld	a5,8(a5)
    80003cec:	cbc5                	beqz	a5,80003d9c <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80003cee:	4505                	li	a0,1
    80003cf0:	9782                	jalr	a5
    80003cf2:	a8b5                	j	80003d6e <filewrite+0xfc>
      if(n1 > max)
    80003cf4:	2981                	sext.w	s3,s3
      begin_op();
    80003cf6:	971ff0ef          	jal	80003666 <begin_op>
      ilock(f->ip);
    80003cfa:	01893503          	ld	a0,24(s2)
    80003cfe:	f5dfe0ef          	jal	80002c5a <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d02:	874e                	mv	a4,s3
    80003d04:	02092683          	lw	a3,32(s2)
    80003d08:	016a0633          	add	a2,s4,s6
    80003d0c:	85e2                	mv	a1,s8
    80003d0e:	01893503          	ld	a0,24(s2)
    80003d12:	bccff0ef          	jal	800030de <writei>
    80003d16:	84aa                	mv	s1,a0
    80003d18:	00a05763          	blez	a0,80003d26 <filewrite+0xb4>
        f->off += r;
    80003d1c:	02092783          	lw	a5,32(s2)
    80003d20:	9fa9                	addw	a5,a5,a0
    80003d22:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d26:	01893503          	ld	a0,24(s2)
    80003d2a:	fdffe0ef          	jal	80002d08 <iunlock>
      end_op();
    80003d2e:	9a9ff0ef          	jal	800036d6 <end_op>

      if(r != n1){
    80003d32:	02999563          	bne	s3,s1,80003d5c <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80003d36:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003d3a:	015a5963          	bge	s4,s5,80003d4c <filewrite+0xda>
      int n1 = n - i;
    80003d3e:	414a87bb          	subw	a5,s5,s4
    80003d42:	89be                	mv	s3,a5
      if(n1 > max)
    80003d44:	fafbd8e3          	bge	s7,a5,80003cf4 <filewrite+0x82>
    80003d48:	89e6                	mv	s3,s9
    80003d4a:	b76d                	j	80003cf4 <filewrite+0x82>
    80003d4c:	64a6                	ld	s1,72(sp)
    80003d4e:	79e2                	ld	s3,56(sp)
    80003d50:	6be2                	ld	s7,24(sp)
    80003d52:	6c42                	ld	s8,16(sp)
    80003d54:	6ca2                	ld	s9,8(sp)
    80003d56:	a801                	j	80003d66 <filewrite+0xf4>
    int i = 0;
    80003d58:	4a01                	li	s4,0
    80003d5a:	a031                	j	80003d66 <filewrite+0xf4>
    80003d5c:	64a6                	ld	s1,72(sp)
    80003d5e:	79e2                	ld	s3,56(sp)
    80003d60:	6be2                	ld	s7,24(sp)
    80003d62:	6c42                	ld	s8,16(sp)
    80003d64:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003d66:	034a9d63          	bne	s5,s4,80003da0 <filewrite+0x12e>
    80003d6a:	8556                	mv	a0,s5
    80003d6c:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d6e:	60e6                	ld	ra,88(sp)
    80003d70:	6446                	ld	s0,80(sp)
    80003d72:	6906                	ld	s2,64(sp)
    80003d74:	7aa2                	ld	s5,40(sp)
    80003d76:	7b02                	ld	s6,32(sp)
    80003d78:	6125                	addi	sp,sp,96
    80003d7a:	8082                	ret
    80003d7c:	e4a6                	sd	s1,72(sp)
    80003d7e:	fc4e                	sd	s3,56(sp)
    80003d80:	f852                	sd	s4,48(sp)
    80003d82:	ec5e                	sd	s7,24(sp)
    80003d84:	e862                	sd	s8,16(sp)
    80003d86:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003d88:	00004517          	auipc	a0,0x4
    80003d8c:	85850513          	addi	a0,a0,-1960 # 800075e0 <etext+0x5e0>
    80003d90:	6a7010ef          	jal	80005c36 <panic>
    return -1;
    80003d94:	557d                	li	a0,-1
}
    80003d96:	8082                	ret
      return -1;
    80003d98:	557d                	li	a0,-1
    80003d9a:	bfd1                	j	80003d6e <filewrite+0xfc>
    80003d9c:	557d                	li	a0,-1
    80003d9e:	bfc1                	j	80003d6e <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80003da0:	557d                	li	a0,-1
    80003da2:	7a42                	ld	s4,48(sp)
    80003da4:	b7e9                	j	80003d6e <filewrite+0xfc>

0000000080003da6 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003da6:	7179                	addi	sp,sp,-48
    80003da8:	f406                	sd	ra,40(sp)
    80003daa:	f022                	sd	s0,32(sp)
    80003dac:	ec26                	sd	s1,24(sp)
    80003dae:	e052                	sd	s4,0(sp)
    80003db0:	1800                	addi	s0,sp,48
    80003db2:	84aa                	mv	s1,a0
    80003db4:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003db6:	0005b023          	sd	zero,0(a1)
    80003dba:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dbe:	c29ff0ef          	jal	800039e6 <filealloc>
    80003dc2:	e088                	sd	a0,0(s1)
    80003dc4:	c549                	beqz	a0,80003e4e <pipealloc+0xa8>
    80003dc6:	c21ff0ef          	jal	800039e6 <filealloc>
    80003dca:	00aa3023          	sd	a0,0(s4)
    80003dce:	cd25                	beqz	a0,80003e46 <pipealloc+0xa0>
    80003dd0:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dd2:	b32fc0ef          	jal	80000104 <kalloc>
    80003dd6:	892a                	mv	s2,a0
    80003dd8:	c12d                	beqz	a0,80003e3a <pipealloc+0x94>
    80003dda:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003ddc:	4985                	li	s3,1
    80003dde:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003de2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003de6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003dea:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003dee:	00004597          	auipc	a1,0x4
    80003df2:	80258593          	addi	a1,a1,-2046 # 800075f0 <etext+0x5f0>
    80003df6:	078020ef          	jal	80005e6e <initlock>
  (*f0)->type = FD_PIPE;
    80003dfa:	609c                	ld	a5,0(s1)
    80003dfc:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e00:	609c                	ld	a5,0(s1)
    80003e02:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e06:	609c                	ld	a5,0(s1)
    80003e08:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e0c:	609c                	ld	a5,0(s1)
    80003e0e:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e12:	000a3783          	ld	a5,0(s4)
    80003e16:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e1a:	000a3783          	ld	a5,0(s4)
    80003e1e:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e22:	000a3783          	ld	a5,0(s4)
    80003e26:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e2a:	000a3783          	ld	a5,0(s4)
    80003e2e:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e32:	4501                	li	a0,0
    80003e34:	6942                	ld	s2,16(sp)
    80003e36:	69a2                	ld	s3,8(sp)
    80003e38:	a01d                	j	80003e5e <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e3a:	6088                	ld	a0,0(s1)
    80003e3c:	c119                	beqz	a0,80003e42 <pipealloc+0x9c>
    80003e3e:	6942                	ld	s2,16(sp)
    80003e40:	a029                	j	80003e4a <pipealloc+0xa4>
    80003e42:	6942                	ld	s2,16(sp)
    80003e44:	a029                	j	80003e4e <pipealloc+0xa8>
    80003e46:	6088                	ld	a0,0(s1)
    80003e48:	c10d                	beqz	a0,80003e6a <pipealloc+0xc4>
    fileclose(*f0);
    80003e4a:	c41ff0ef          	jal	80003a8a <fileclose>
  if(*f1)
    80003e4e:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e52:	557d                	li	a0,-1
  if(*f1)
    80003e54:	c789                	beqz	a5,80003e5e <pipealloc+0xb8>
    fileclose(*f1);
    80003e56:	853e                	mv	a0,a5
    80003e58:	c33ff0ef          	jal	80003a8a <fileclose>
  return -1;
    80003e5c:	557d                	li	a0,-1
}
    80003e5e:	70a2                	ld	ra,40(sp)
    80003e60:	7402                	ld	s0,32(sp)
    80003e62:	64e2                	ld	s1,24(sp)
    80003e64:	6a02                	ld	s4,0(sp)
    80003e66:	6145                	addi	sp,sp,48
    80003e68:	8082                	ret
  return -1;
    80003e6a:	557d                	li	a0,-1
    80003e6c:	bfcd                	j	80003e5e <pipealloc+0xb8>

0000000080003e6e <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e6e:	1101                	addi	sp,sp,-32
    80003e70:	ec06                	sd	ra,24(sp)
    80003e72:	e822                	sd	s0,16(sp)
    80003e74:	e426                	sd	s1,8(sp)
    80003e76:	e04a                	sd	s2,0(sp)
    80003e78:	1000                	addi	s0,sp,32
    80003e7a:	84aa                	mv	s1,a0
    80003e7c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003e7e:	07a020ef          	jal	80005ef8 <acquire>
  if(writable){
    80003e82:	02090763          	beqz	s2,80003eb0 <pipeclose+0x42>
    pi->writeopen = 0;
    80003e86:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003e8a:	21848513          	addi	a0,s1,536
    80003e8e:	901fd0ef          	jal	8000178e <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003e92:	2204a783          	lw	a5,544(s1)
    80003e96:	e781                	bnez	a5,80003e9e <pipeclose+0x30>
    80003e98:	2244a783          	lw	a5,548(s1)
    80003e9c:	c38d                	beqz	a5,80003ebe <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80003e9e:	8526                	mv	a0,s1
    80003ea0:	0ec020ef          	jal	80005f8c <release>
}
    80003ea4:	60e2                	ld	ra,24(sp)
    80003ea6:	6442                	ld	s0,16(sp)
    80003ea8:	64a2                	ld	s1,8(sp)
    80003eaa:	6902                	ld	s2,0(sp)
    80003eac:	6105                	addi	sp,sp,32
    80003eae:	8082                	ret
    pi->readopen = 0;
    80003eb0:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003eb4:	21c48513          	addi	a0,s1,540
    80003eb8:	8d7fd0ef          	jal	8000178e <wakeup>
    80003ebc:	bfd9                	j	80003e92 <pipeclose+0x24>
    release(&pi->lock);
    80003ebe:	8526                	mv	a0,s1
    80003ec0:	0cc020ef          	jal	80005f8c <release>
    kfree((char*)pi);
    80003ec4:	8526                	mv	a0,s1
    80003ec6:	956fc0ef          	jal	8000001c <kfree>
    80003eca:	bfe9                	j	80003ea4 <pipeclose+0x36>

0000000080003ecc <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ecc:	7159                	addi	sp,sp,-112
    80003ece:	f486                	sd	ra,104(sp)
    80003ed0:	f0a2                	sd	s0,96(sp)
    80003ed2:	eca6                	sd	s1,88(sp)
    80003ed4:	e8ca                	sd	s2,80(sp)
    80003ed6:	e4ce                	sd	s3,72(sp)
    80003ed8:	e0d2                	sd	s4,64(sp)
    80003eda:	fc56                	sd	s5,56(sp)
    80003edc:	1880                	addi	s0,sp,112
    80003ede:	84aa                	mv	s1,a0
    80003ee0:	8aae                	mv	s5,a1
    80003ee2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ee4:	a18fd0ef          	jal	800010fc <myproc>
    80003ee8:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003eea:	8526                	mv	a0,s1
    80003eec:	00c020ef          	jal	80005ef8 <acquire>
  while(i < n){
    80003ef0:	0d405263          	blez	s4,80003fb4 <pipewrite+0xe8>
    80003ef4:	f85a                	sd	s6,48(sp)
    80003ef6:	f45e                	sd	s7,40(sp)
    80003ef8:	f062                	sd	s8,32(sp)
    80003efa:	ec66                	sd	s9,24(sp)
    80003efc:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003efe:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f00:	f9f40c13          	addi	s8,s0,-97
    80003f04:	4b85                	li	s7,1
    80003f06:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f08:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f0c:	21c48c93          	addi	s9,s1,540
    80003f10:	a82d                	j	80003f4a <pipewrite+0x7e>
      release(&pi->lock);
    80003f12:	8526                	mv	a0,s1
    80003f14:	078020ef          	jal	80005f8c <release>
      return -1;
    80003f18:	597d                	li	s2,-1
    80003f1a:	7b42                	ld	s6,48(sp)
    80003f1c:	7ba2                	ld	s7,40(sp)
    80003f1e:	7c02                	ld	s8,32(sp)
    80003f20:	6ce2                	ld	s9,24(sp)
    80003f22:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f24:	854a                	mv	a0,s2
    80003f26:	70a6                	ld	ra,104(sp)
    80003f28:	7406                	ld	s0,96(sp)
    80003f2a:	64e6                	ld	s1,88(sp)
    80003f2c:	6946                	ld	s2,80(sp)
    80003f2e:	69a6                	ld	s3,72(sp)
    80003f30:	6a06                	ld	s4,64(sp)
    80003f32:	7ae2                	ld	s5,56(sp)
    80003f34:	6165                	addi	sp,sp,112
    80003f36:	8082                	ret
      wakeup(&pi->nread);
    80003f38:	856a                	mv	a0,s10
    80003f3a:	855fd0ef          	jal	8000178e <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f3e:	85a6                	mv	a1,s1
    80003f40:	8566                	mv	a0,s9
    80003f42:	801fd0ef          	jal	80001742 <sleep>
  while(i < n){
    80003f46:	05495a63          	bge	s2,s4,80003f9a <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003f4a:	2204a783          	lw	a5,544(s1)
    80003f4e:	d3f1                	beqz	a5,80003f12 <pipewrite+0x46>
    80003f50:	854e                	mv	a0,s3
    80003f52:	a71fd0ef          	jal	800019c2 <killed>
    80003f56:	fd55                	bnez	a0,80003f12 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f58:	2184a783          	lw	a5,536(s1)
    80003f5c:	21c4a703          	lw	a4,540(s1)
    80003f60:	2007879b          	addiw	a5,a5,512
    80003f64:	fcf70ae3          	beq	a4,a5,80003f38 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f68:	86de                	mv	a3,s7
    80003f6a:	01590633          	add	a2,s2,s5
    80003f6e:	85e2                	mv	a1,s8
    80003f70:	0509b503          	ld	a0,80(s3)
    80003f74:	d69fc0ef          	jal	80000cdc <copyin>
    80003f78:	05650063          	beq	a0,s6,80003fb8 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003f7c:	21c4a783          	lw	a5,540(s1)
    80003f80:	0017871b          	addiw	a4,a5,1
    80003f84:	20e4ae23          	sw	a4,540(s1)
    80003f88:	1ff7f793          	andi	a5,a5,511
    80003f8c:	97a6                	add	a5,a5,s1
    80003f8e:	f9f44703          	lbu	a4,-97(s0)
    80003f92:	00e78c23          	sb	a4,24(a5)
      i++;
    80003f96:	2905                	addiw	s2,s2,1
    80003f98:	b77d                	j	80003f46 <pipewrite+0x7a>
    80003f9a:	7b42                	ld	s6,48(sp)
    80003f9c:	7ba2                	ld	s7,40(sp)
    80003f9e:	7c02                	ld	s8,32(sp)
    80003fa0:	6ce2                	ld	s9,24(sp)
    80003fa2:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003fa4:	21848513          	addi	a0,s1,536
    80003fa8:	fe6fd0ef          	jal	8000178e <wakeup>
  release(&pi->lock);
    80003fac:	8526                	mv	a0,s1
    80003fae:	7df010ef          	jal	80005f8c <release>
  return i;
    80003fb2:	bf8d                	j	80003f24 <pipewrite+0x58>
  int i = 0;
    80003fb4:	4901                	li	s2,0
    80003fb6:	b7fd                	j	80003fa4 <pipewrite+0xd8>
    80003fb8:	7b42                	ld	s6,48(sp)
    80003fba:	7ba2                	ld	s7,40(sp)
    80003fbc:	7c02                	ld	s8,32(sp)
    80003fbe:	6ce2                	ld	s9,24(sp)
    80003fc0:	6d42                	ld	s10,16(sp)
    80003fc2:	b7cd                	j	80003fa4 <pipewrite+0xd8>

0000000080003fc4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003fc4:	711d                	addi	sp,sp,-96
    80003fc6:	ec86                	sd	ra,88(sp)
    80003fc8:	e8a2                	sd	s0,80(sp)
    80003fca:	e4a6                	sd	s1,72(sp)
    80003fcc:	e0ca                	sd	s2,64(sp)
    80003fce:	fc4e                	sd	s3,56(sp)
    80003fd0:	f852                	sd	s4,48(sp)
    80003fd2:	f456                	sd	s5,40(sp)
    80003fd4:	1080                	addi	s0,sp,96
    80003fd6:	84aa                	mv	s1,a0
    80003fd8:	892e                	mv	s2,a1
    80003fda:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003fdc:	920fd0ef          	jal	800010fc <myproc>
    80003fe0:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003fe2:	8526                	mv	a0,s1
    80003fe4:	715010ef          	jal	80005ef8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003fe8:	2184a703          	lw	a4,536(s1)
    80003fec:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003ff0:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ff4:	02f71763          	bne	a4,a5,80004022 <piperead+0x5e>
    80003ff8:	2244a783          	lw	a5,548(s1)
    80003ffc:	cf85                	beqz	a5,80004034 <piperead+0x70>
    if(killed(pr)){
    80003ffe:	8552                	mv	a0,s4
    80004000:	9c3fd0ef          	jal	800019c2 <killed>
    80004004:	e11d                	bnez	a0,8000402a <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004006:	85a6                	mv	a1,s1
    80004008:	854e                	mv	a0,s3
    8000400a:	f38fd0ef          	jal	80001742 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000400e:	2184a703          	lw	a4,536(s1)
    80004012:	21c4a783          	lw	a5,540(s1)
    80004016:	fef701e3          	beq	a4,a5,80003ff8 <piperead+0x34>
    8000401a:	f05a                	sd	s6,32(sp)
    8000401c:	ec5e                	sd	s7,24(sp)
    8000401e:	e862                	sd	s8,16(sp)
    80004020:	a829                	j	8000403a <piperead+0x76>
    80004022:	f05a                	sd	s6,32(sp)
    80004024:	ec5e                	sd	s7,24(sp)
    80004026:	e862                	sd	s8,16(sp)
    80004028:	a809                	j	8000403a <piperead+0x76>
      release(&pi->lock);
    8000402a:	8526                	mv	a0,s1
    8000402c:	761010ef          	jal	80005f8c <release>
      return -1;
    80004030:	59fd                	li	s3,-1
    80004032:	a09d                	j	80004098 <piperead+0xd4>
    80004034:	f05a                	sd	s6,32(sp)
    80004036:	ec5e                	sd	s7,24(sp)
    80004038:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000403a:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000403c:	faf40c13          	addi	s8,s0,-81
    80004040:	4b85                	li	s7,1
    80004042:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004044:	05505063          	blez	s5,80004084 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80004048:	2184a783          	lw	a5,536(s1)
    8000404c:	21c4a703          	lw	a4,540(s1)
    80004050:	02f70a63          	beq	a4,a5,80004084 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004054:	0017871b          	addiw	a4,a5,1
    80004058:	20e4ac23          	sw	a4,536(s1)
    8000405c:	1ff7f793          	andi	a5,a5,511
    80004060:	97a6                	add	a5,a5,s1
    80004062:	0187c783          	lbu	a5,24(a5)
    80004066:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    8000406a:	86de                	mv	a3,s7
    8000406c:	8662                	mv	a2,s8
    8000406e:	85ca                	mv	a1,s2
    80004070:	050a3503          	ld	a0,80(s4)
    80004074:	babfc0ef          	jal	80000c1e <copyout>
    80004078:	01650663          	beq	a0,s6,80004084 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000407c:	2985                	addiw	s3,s3,1
    8000407e:	0905                	addi	s2,s2,1
    80004080:	fd3a94e3          	bne	s5,s3,80004048 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004084:	21c48513          	addi	a0,s1,540
    80004088:	f06fd0ef          	jal	8000178e <wakeup>
  release(&pi->lock);
    8000408c:	8526                	mv	a0,s1
    8000408e:	6ff010ef          	jal	80005f8c <release>
    80004092:	7b02                	ld	s6,32(sp)
    80004094:	6be2                	ld	s7,24(sp)
    80004096:	6c42                	ld	s8,16(sp)
  return i;
}
    80004098:	854e                	mv	a0,s3
    8000409a:	60e6                	ld	ra,88(sp)
    8000409c:	6446                	ld	s0,80(sp)
    8000409e:	64a6                	ld	s1,72(sp)
    800040a0:	6906                	ld	s2,64(sp)
    800040a2:	79e2                	ld	s3,56(sp)
    800040a4:	7a42                	ld	s4,48(sp)
    800040a6:	7aa2                	ld	s5,40(sp)
    800040a8:	6125                	addi	sp,sp,96
    800040aa:	8082                	ret

00000000800040ac <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    800040ac:	1141                	addi	sp,sp,-16
    800040ae:	e406                	sd	ra,8(sp)
    800040b0:	e022                	sd	s0,0(sp)
    800040b2:	0800                	addi	s0,sp,16
    800040b4:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040b6:	0035151b          	slliw	a0,a0,0x3
    800040ba:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800040bc:	8b89                	andi	a5,a5,2
    800040be:	c399                	beqz	a5,800040c4 <flags2perm+0x18>
      perm |= PTE_W;
    800040c0:	00456513          	ori	a0,a0,4
    return perm;
}
    800040c4:	60a2                	ld	ra,8(sp)
    800040c6:	6402                	ld	s0,0(sp)
    800040c8:	0141                	addi	sp,sp,16
    800040ca:	8082                	ret

00000000800040cc <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800040cc:	de010113          	addi	sp,sp,-544
    800040d0:	20113c23          	sd	ra,536(sp)
    800040d4:	20813823          	sd	s0,528(sp)
    800040d8:	20913423          	sd	s1,520(sp)
    800040dc:	21213023          	sd	s2,512(sp)
    800040e0:	1400                	addi	s0,sp,544
    800040e2:	892a                	mv	s2,a0
    800040e4:	dea43823          	sd	a0,-528(s0)
    800040e8:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800040ec:	810fd0ef          	jal	800010fc <myproc>
    800040f0:	84aa                	mv	s1,a0

  begin_op();
    800040f2:	d74ff0ef          	jal	80003666 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    800040f6:	854a                	mv	a0,s2
    800040f8:	b90ff0ef          	jal	80003488 <namei>
    800040fc:	cd21                	beqz	a0,80004154 <kexec+0x88>
    800040fe:	fbd2                	sd	s4,496(sp)
    80004100:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004102:	b59fe0ef          	jal	80002c5a <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004106:	04000713          	li	a4,64
    8000410a:	4681                	li	a3,0
    8000410c:	e5040613          	addi	a2,s0,-432
    80004110:	4581                	li	a1,0
    80004112:	8552                	mv	a0,s4
    80004114:	ed9fe0ef          	jal	80002fec <readi>
    80004118:	04000793          	li	a5,64
    8000411c:	00f51a63          	bne	a0,a5,80004130 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004120:	e5042703          	lw	a4,-432(s0)
    80004124:	464c47b7          	lui	a5,0x464c4
    80004128:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000412c:	02f70863          	beq	a4,a5,8000415c <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004130:	8552                	mv	a0,s4
    80004132:	d35fe0ef          	jal	80002e66 <iunlockput>
    end_op();
    80004136:	da0ff0ef          	jal	800036d6 <end_op>
  }
  return -1;
    8000413a:	557d                	li	a0,-1
    8000413c:	7a5e                	ld	s4,496(sp)
}
    8000413e:	21813083          	ld	ra,536(sp)
    80004142:	21013403          	ld	s0,528(sp)
    80004146:	20813483          	ld	s1,520(sp)
    8000414a:	20013903          	ld	s2,512(sp)
    8000414e:	22010113          	addi	sp,sp,544
    80004152:	8082                	ret
    end_op();
    80004154:	d82ff0ef          	jal	800036d6 <end_op>
    return -1;
    80004158:	557d                	li	a0,-1
    8000415a:	b7d5                	j	8000413e <kexec+0x72>
    8000415c:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000415e:	8526                	mv	a0,s1
    80004160:	8a6fd0ef          	jal	80001206 <proc_pagetable>
    80004164:	8b2a                	mv	s6,a0
    80004166:	26050f63          	beqz	a0,800043e4 <kexec+0x318>
    8000416a:	ffce                	sd	s3,504(sp)
    8000416c:	f7d6                	sd	s5,488(sp)
    8000416e:	efde                	sd	s7,472(sp)
    80004170:	ebe2                	sd	s8,464(sp)
    80004172:	e7e6                	sd	s9,456(sp)
    80004174:	e3ea                	sd	s10,448(sp)
    80004176:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004178:	e8845783          	lhu	a5,-376(s0)
    8000417c:	0e078963          	beqz	a5,8000426e <kexec+0x1a2>
    80004180:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004184:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004186:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004188:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    8000418c:	6c85                	lui	s9,0x1
    8000418e:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004192:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80004196:	6a85                	lui	s5,0x1
    80004198:	a085                	j	800041f8 <kexec+0x12c>
      panic("loadseg: address should exist");
    8000419a:	00003517          	auipc	a0,0x3
    8000419e:	45e50513          	addi	a0,a0,1118 # 800075f8 <etext+0x5f8>
    800041a2:	295010ef          	jal	80005c36 <panic>
    if(sz - i < PGSIZE)
    800041a6:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041a8:	874a                	mv	a4,s2
    800041aa:	009b86bb          	addw	a3,s7,s1
    800041ae:	4581                	li	a1,0
    800041b0:	8552                	mv	a0,s4
    800041b2:	e3bfe0ef          	jal	80002fec <readi>
    800041b6:	22a91b63          	bne	s2,a0,800043ec <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    800041ba:	009a84bb          	addw	s1,s5,s1
    800041be:	0334f263          	bgeu	s1,s3,800041e2 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    800041c2:	02049593          	slli	a1,s1,0x20
    800041c6:	9181                	srli	a1,a1,0x20
    800041c8:	95e2                	add	a1,a1,s8
    800041ca:	855a                	mv	a0,s6
    800041cc:	ac0fc0ef          	jal	8000048c <walkaddr>
    800041d0:	862a                	mv	a2,a0
    if(pa == 0)
    800041d2:	d561                	beqz	a0,8000419a <kexec+0xce>
    if(sz - i < PGSIZE)
    800041d4:	409987bb          	subw	a5,s3,s1
    800041d8:	893e                	mv	s2,a5
    800041da:	fcfcf6e3          	bgeu	s9,a5,800041a6 <kexec+0xda>
    800041de:	8956                	mv	s2,s5
    800041e0:	b7d9                	j	800041a6 <kexec+0xda>
    sz = sz1;
    800041e2:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041e6:	2d05                	addiw	s10,s10,1
    800041e8:	e0843783          	ld	a5,-504(s0)
    800041ec:	0387869b          	addiw	a3,a5,56
    800041f0:	e8845783          	lhu	a5,-376(s0)
    800041f4:	06fd5e63          	bge	s10,a5,80004270 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041f8:	e0d43423          	sd	a3,-504(s0)
    800041fc:	876e                	mv	a4,s11
    800041fe:	e1840613          	addi	a2,s0,-488
    80004202:	4581                	li	a1,0
    80004204:	8552                	mv	a0,s4
    80004206:	de7fe0ef          	jal	80002fec <readi>
    8000420a:	1db51f63          	bne	a0,s11,800043e8 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    8000420e:	e1842783          	lw	a5,-488(s0)
    80004212:	4705                	li	a4,1
    80004214:	fce799e3          	bne	a5,a4,800041e6 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80004218:	e4043483          	ld	s1,-448(s0)
    8000421c:	e3843783          	ld	a5,-456(s0)
    80004220:	1ef4e463          	bltu	s1,a5,80004408 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004224:	e2843783          	ld	a5,-472(s0)
    80004228:	94be                	add	s1,s1,a5
    8000422a:	1ef4e263          	bltu	s1,a5,8000440e <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    8000422e:	de843703          	ld	a4,-536(s0)
    80004232:	8ff9                	and	a5,a5,a4
    80004234:	1e079063          	bnez	a5,80004414 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004238:	e1c42503          	lw	a0,-484(s0)
    8000423c:	e71ff0ef          	jal	800040ac <flags2perm>
    80004240:	86aa                	mv	a3,a0
    80004242:	8626                	mv	a2,s1
    80004244:	85ca                	mv	a1,s2
    80004246:	855a                	mv	a0,s6
    80004248:	d1afc0ef          	jal	80000762 <uvmalloc>
    8000424c:	dea43c23          	sd	a0,-520(s0)
    80004250:	1c050563          	beqz	a0,8000441a <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004254:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004258:	00098863          	beqz	s3,80004268 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000425c:	e2843c03          	ld	s8,-472(s0)
    80004260:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004264:	4481                	li	s1,0
    80004266:	bfb1                	j	800041c2 <kexec+0xf6>
    sz = sz1;
    80004268:	df843903          	ld	s2,-520(s0)
    8000426c:	bfad                	j	800041e6 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000426e:	4901                	li	s2,0
  iunlockput(ip);
    80004270:	8552                	mv	a0,s4
    80004272:	bf5fe0ef          	jal	80002e66 <iunlockput>
  end_op();
    80004276:	c60ff0ef          	jal	800036d6 <end_op>
  p = myproc();
    8000427a:	e83fc0ef          	jal	800010fc <myproc>
    8000427e:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004280:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004284:	6985                	lui	s3,0x1
    80004286:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004288:	99ca                	add	s3,s3,s2
    8000428a:	77fd                	lui	a5,0xfffff
    8000428c:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004290:	4691                	li	a3,4
    80004292:	6609                	lui	a2,0x2
    80004294:	964e                	add	a2,a2,s3
    80004296:	85ce                	mv	a1,s3
    80004298:	855a                	mv	a0,s6
    8000429a:	cc8fc0ef          	jal	80000762 <uvmalloc>
    8000429e:	8a2a                	mv	s4,a0
    800042a0:	e105                	bnez	a0,800042c0 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    800042a2:	85ce                	mv	a1,s3
    800042a4:	855a                	mv	a0,s6
    800042a6:	fe5fc0ef          	jal	8000128a <proc_freepagetable>
  return -1;
    800042aa:	557d                	li	a0,-1
    800042ac:	79fe                	ld	s3,504(sp)
    800042ae:	7a5e                	ld	s4,496(sp)
    800042b0:	7abe                	ld	s5,488(sp)
    800042b2:	7b1e                	ld	s6,480(sp)
    800042b4:	6bfe                	ld	s7,472(sp)
    800042b6:	6c5e                	ld	s8,464(sp)
    800042b8:	6cbe                	ld	s9,456(sp)
    800042ba:	6d1e                	ld	s10,448(sp)
    800042bc:	7dfa                	ld	s11,440(sp)
    800042be:	b541                	j	8000413e <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800042c0:	75f9                	lui	a1,0xffffe
    800042c2:	95aa                	add	a1,a1,a0
    800042c4:	855a                	mv	a0,s6
    800042c6:	e6efc0ef          	jal	80000934 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800042ca:	800a0b93          	addi	s7,s4,-2048
    800042ce:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    800042d2:	e0043783          	ld	a5,-512(s0)
    800042d6:	6388                	ld	a0,0(a5)
  sp = sz;
    800042d8:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    800042da:	4481                	li	s1,0
    ustack[argc] = sp;
    800042dc:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    800042e0:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    800042e4:	cd21                	beqz	a0,8000433c <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    800042e6:	802fc0ef          	jal	800002e8 <strlen>
    800042ea:	0015079b          	addiw	a5,a0,1
    800042ee:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800042f2:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    800042f6:	13796563          	bltu	s2,s7,80004420 <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800042fa:	e0043d83          	ld	s11,-512(s0)
    800042fe:	000db983          	ld	s3,0(s11)
    80004302:	854e                	mv	a0,s3
    80004304:	fe5fb0ef          	jal	800002e8 <strlen>
    80004308:	0015069b          	addiw	a3,a0,1
    8000430c:	864e                	mv	a2,s3
    8000430e:	85ca                	mv	a1,s2
    80004310:	855a                	mv	a0,s6
    80004312:	90dfc0ef          	jal	80000c1e <copyout>
    80004316:	10054763          	bltz	a0,80004424 <kexec+0x358>
    ustack[argc] = sp;
    8000431a:	00349793          	slli	a5,s1,0x3
    8000431e:	97e6                	add	a5,a5,s9
    80004320:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd21c8>
  for(argc = 0; argv[argc]; argc++) {
    80004324:	0485                	addi	s1,s1,1
    80004326:	008d8793          	addi	a5,s11,8
    8000432a:	e0f43023          	sd	a5,-512(s0)
    8000432e:	008db503          	ld	a0,8(s11)
    80004332:	c509                	beqz	a0,8000433c <kexec+0x270>
    if(argc >= MAXARG)
    80004334:	fb8499e3          	bne	s1,s8,800042e6 <kexec+0x21a>
  sz = sz1;
    80004338:	89d2                	mv	s3,s4
    8000433a:	b7a5                	j	800042a2 <kexec+0x1d6>
  ustack[argc] = 0;
    8000433c:	00349793          	slli	a5,s1,0x3
    80004340:	f9078793          	addi	a5,a5,-112
    80004344:	97a2                	add	a5,a5,s0
    80004346:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    8000434a:	00349693          	slli	a3,s1,0x3
    8000434e:	06a1                	addi	a3,a3,8
    80004350:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004354:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004358:	89d2                	mv	s3,s4
  if(sp < stackbase)
    8000435a:	f57964e3          	bltu	s2,s7,800042a2 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000435e:	e9040613          	addi	a2,s0,-368
    80004362:	85ca                	mv	a1,s2
    80004364:	855a                	mv	a0,s6
    80004366:	8b9fc0ef          	jal	80000c1e <copyout>
    8000436a:	f2054ce3          	bltz	a0,800042a2 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    8000436e:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80004372:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004376:	df043783          	ld	a5,-528(s0)
    8000437a:	0007c703          	lbu	a4,0(a5)
    8000437e:	cf11                	beqz	a4,8000439a <kexec+0x2ce>
    80004380:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004382:	02f00693          	li	a3,47
    80004386:	a029                	j	80004390 <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80004388:	0785                	addi	a5,a5,1
    8000438a:	fff7c703          	lbu	a4,-1(a5)
    8000438e:	c711                	beqz	a4,8000439a <kexec+0x2ce>
    if(*s == '/')
    80004390:	fed71ce3          	bne	a4,a3,80004388 <kexec+0x2bc>
      last = s+1;
    80004394:	def43823          	sd	a5,-528(s0)
    80004398:	bfc5                	j	80004388 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    8000439a:	4641                	li	a2,16
    8000439c:	df043583          	ld	a1,-528(s0)
    800043a0:	158a8513          	addi	a0,s5,344
    800043a4:	f0ffb0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    800043a8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043ac:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800043b0:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    800043b4:	058ab783          	ld	a5,88(s5)
    800043b8:	e6843703          	ld	a4,-408(s0)
    800043bc:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043be:	058ab783          	ld	a5,88(s5)
    800043c2:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043c6:	85ea                	mv	a1,s10
    800043c8:	ec3fc0ef          	jal	8000128a <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043cc:	0004851b          	sext.w	a0,s1
    800043d0:	79fe                	ld	s3,504(sp)
    800043d2:	7a5e                	ld	s4,496(sp)
    800043d4:	7abe                	ld	s5,488(sp)
    800043d6:	7b1e                	ld	s6,480(sp)
    800043d8:	6bfe                	ld	s7,472(sp)
    800043da:	6c5e                	ld	s8,464(sp)
    800043dc:	6cbe                	ld	s9,456(sp)
    800043de:	6d1e                	ld	s10,448(sp)
    800043e0:	7dfa                	ld	s11,440(sp)
    800043e2:	bbb1                	j	8000413e <kexec+0x72>
    800043e4:	7b1e                	ld	s6,480(sp)
    800043e6:	b3a9                	j	80004130 <kexec+0x64>
    800043e8:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    800043ec:	df843583          	ld	a1,-520(s0)
    800043f0:	855a                	mv	a0,s6
    800043f2:	e99fc0ef          	jal	8000128a <proc_freepagetable>
  if(ip){
    800043f6:	79fe                	ld	s3,504(sp)
    800043f8:	7abe                	ld	s5,488(sp)
    800043fa:	7b1e                	ld	s6,480(sp)
    800043fc:	6bfe                	ld	s7,472(sp)
    800043fe:	6c5e                	ld	s8,464(sp)
    80004400:	6cbe                	ld	s9,456(sp)
    80004402:	6d1e                	ld	s10,448(sp)
    80004404:	7dfa                	ld	s11,440(sp)
    80004406:	b32d                	j	80004130 <kexec+0x64>
    80004408:	df243c23          	sd	s2,-520(s0)
    8000440c:	b7c5                	j	800043ec <kexec+0x320>
    8000440e:	df243c23          	sd	s2,-520(s0)
    80004412:	bfe9                	j	800043ec <kexec+0x320>
    80004414:	df243c23          	sd	s2,-520(s0)
    80004418:	bfd1                	j	800043ec <kexec+0x320>
    8000441a:	df243c23          	sd	s2,-520(s0)
    8000441e:	b7f9                	j	800043ec <kexec+0x320>
  sz = sz1;
    80004420:	89d2                	mv	s3,s4
    80004422:	b541                	j	800042a2 <kexec+0x1d6>
    80004424:	89d2                	mv	s3,s4
    80004426:	bdb5                	j	800042a2 <kexec+0x1d6>

0000000080004428 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004428:	7179                	addi	sp,sp,-48
    8000442a:	f406                	sd	ra,40(sp)
    8000442c:	f022                	sd	s0,32(sp)
    8000442e:	ec26                	sd	s1,24(sp)
    80004430:	e84a                	sd	s2,16(sp)
    80004432:	1800                	addi	s0,sp,48
    80004434:	892e                	mv	s2,a1
    80004436:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004438:	fdc40593          	addi	a1,s0,-36
    8000443c:	c57fd0ef          	jal	80002092 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80004440:	fdc42703          	lw	a4,-36(s0)
    80004444:	47bd                	li	a5,15
    80004446:	02e7ea63          	bltu	a5,a4,8000447a <argfd+0x52>
    8000444a:	cb3fc0ef          	jal	800010fc <myproc>
    8000444e:	fdc42703          	lw	a4,-36(s0)
    80004452:	00371793          	slli	a5,a4,0x3
    80004456:	0d078793          	addi	a5,a5,208
    8000445a:	953e                	add	a0,a0,a5
    8000445c:	611c                	ld	a5,0(a0)
    8000445e:	c385                	beqz	a5,8000447e <argfd+0x56>
    return -1;
  if(pfd)
    80004460:	00090463          	beqz	s2,80004468 <argfd+0x40>
    *pfd = fd;
    80004464:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004468:	4501                	li	a0,0
  if(pf)
    8000446a:	c091                	beqz	s1,8000446e <argfd+0x46>
    *pf = f;
    8000446c:	e09c                	sd	a5,0(s1)
}
    8000446e:	70a2                	ld	ra,40(sp)
    80004470:	7402                	ld	s0,32(sp)
    80004472:	64e2                	ld	s1,24(sp)
    80004474:	6942                	ld	s2,16(sp)
    80004476:	6145                	addi	sp,sp,48
    80004478:	8082                	ret
    return -1;
    8000447a:	557d                	li	a0,-1
    8000447c:	bfcd                	j	8000446e <argfd+0x46>
    8000447e:	557d                	li	a0,-1
    80004480:	b7fd                	j	8000446e <argfd+0x46>

0000000080004482 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004482:	1101                	addi	sp,sp,-32
    80004484:	ec06                	sd	ra,24(sp)
    80004486:	e822                	sd	s0,16(sp)
    80004488:	e426                	sd	s1,8(sp)
    8000448a:	1000                	addi	s0,sp,32
    8000448c:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000448e:	c6ffc0ef          	jal	800010fc <myproc>
    80004492:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004494:	0d050793          	addi	a5,a0,208
    80004498:	4501                	li	a0,0
    8000449a:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    8000449c:	6398                	ld	a4,0(a5)
    8000449e:	cb19                	beqz	a4,800044b4 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800044a0:	2505                	addiw	a0,a0,1
    800044a2:	07a1                	addi	a5,a5,8
    800044a4:	fed51ce3          	bne	a0,a3,8000449c <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044a8:	557d                	li	a0,-1
}
    800044aa:	60e2                	ld	ra,24(sp)
    800044ac:	6442                	ld	s0,16(sp)
    800044ae:	64a2                	ld	s1,8(sp)
    800044b0:	6105                	addi	sp,sp,32
    800044b2:	8082                	ret
      p->ofile[fd] = f;
    800044b4:	00351793          	slli	a5,a0,0x3
    800044b8:	0d078793          	addi	a5,a5,208
    800044bc:	963e                	add	a2,a2,a5
    800044be:	e204                	sd	s1,0(a2)
      return fd;
    800044c0:	b7ed                	j	800044aa <fdalloc+0x28>

00000000800044c2 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044c2:	715d                	addi	sp,sp,-80
    800044c4:	e486                	sd	ra,72(sp)
    800044c6:	e0a2                	sd	s0,64(sp)
    800044c8:	fc26                	sd	s1,56(sp)
    800044ca:	f84a                	sd	s2,48(sp)
    800044cc:	f44e                	sd	s3,40(sp)
    800044ce:	f052                	sd	s4,32(sp)
    800044d0:	ec56                	sd	s5,24(sp)
    800044d2:	e85a                	sd	s6,16(sp)
    800044d4:	0880                	addi	s0,sp,80
    800044d6:	892e                	mv	s2,a1
    800044d8:	8a2e                	mv	s4,a1
    800044da:	8ab2                	mv	s5,a2
    800044dc:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    800044de:	fb040593          	addi	a1,s0,-80
    800044e2:	fc1fe0ef          	jal	800034a2 <nameiparent>
    800044e6:	84aa                	mv	s1,a0
    800044e8:	10050763          	beqz	a0,800045f6 <create+0x134>
    return 0;

  ilock(dp);
    800044ec:	f6efe0ef          	jal	80002c5a <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    800044f0:	4601                	li	a2,0
    800044f2:	fb040593          	addi	a1,s0,-80
    800044f6:	8526                	mv	a0,s1
    800044f8:	cfdfe0ef          	jal	800031f4 <dirlookup>
    800044fc:	89aa                	mv	s3,a0
    800044fe:	c131                	beqz	a0,80004542 <create+0x80>
    iunlockput(dp);
    80004500:	8526                	mv	a0,s1
    80004502:	965fe0ef          	jal	80002e66 <iunlockput>
    ilock(ip);
    80004506:	854e                	mv	a0,s3
    80004508:	f52fe0ef          	jal	80002c5a <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000450c:	4789                	li	a5,2
    8000450e:	02f91563          	bne	s2,a5,80004538 <create+0x76>
    80004512:	0449d783          	lhu	a5,68(s3)
    80004516:	37f9                	addiw	a5,a5,-2
    80004518:	17c2                	slli	a5,a5,0x30
    8000451a:	93c1                	srli	a5,a5,0x30
    8000451c:	4705                	li	a4,1
    8000451e:	00f76d63          	bltu	a4,a5,80004538 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004522:	854e                	mv	a0,s3
    80004524:	60a6                	ld	ra,72(sp)
    80004526:	6406                	ld	s0,64(sp)
    80004528:	74e2                	ld	s1,56(sp)
    8000452a:	7942                	ld	s2,48(sp)
    8000452c:	79a2                	ld	s3,40(sp)
    8000452e:	7a02                	ld	s4,32(sp)
    80004530:	6ae2                	ld	s5,24(sp)
    80004532:	6b42                	ld	s6,16(sp)
    80004534:	6161                	addi	sp,sp,80
    80004536:	8082                	ret
    iunlockput(ip);
    80004538:	854e                	mv	a0,s3
    8000453a:	92dfe0ef          	jal	80002e66 <iunlockput>
    return 0;
    8000453e:	4981                	li	s3,0
    80004540:	b7cd                	j	80004522 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004542:	85ca                	mv	a1,s2
    80004544:	4088                	lw	a0,0(s1)
    80004546:	da4fe0ef          	jal	80002aea <ialloc>
    8000454a:	892a                	mv	s2,a0
    8000454c:	cd15                	beqz	a0,80004588 <create+0xc6>
  ilock(ip);
    8000454e:	f0cfe0ef          	jal	80002c5a <ilock>
  ip->major = major;
    80004552:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004556:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    8000455a:	4785                	li	a5,1
    8000455c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004560:	854a                	mv	a0,s2
    80004562:	e44fe0ef          	jal	80002ba6 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004566:	4705                	li	a4,1
    80004568:	02ea0463          	beq	s4,a4,80004590 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8000456c:	00492603          	lw	a2,4(s2)
    80004570:	fb040593          	addi	a1,s0,-80
    80004574:	8526                	mv	a0,s1
    80004576:	e69fe0ef          	jal	800033de <dirlink>
    8000457a:	06054263          	bltz	a0,800045de <create+0x11c>
  iunlockput(dp);
    8000457e:	8526                	mv	a0,s1
    80004580:	8e7fe0ef          	jal	80002e66 <iunlockput>
  return ip;
    80004584:	89ca                	mv	s3,s2
    80004586:	bf71                	j	80004522 <create+0x60>
    iunlockput(dp);
    80004588:	8526                	mv	a0,s1
    8000458a:	8ddfe0ef          	jal	80002e66 <iunlockput>
    return 0;
    8000458e:	bf51                	j	80004522 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004590:	00492603          	lw	a2,4(s2)
    80004594:	00003597          	auipc	a1,0x3
    80004598:	08458593          	addi	a1,a1,132 # 80007618 <etext+0x618>
    8000459c:	854a                	mv	a0,s2
    8000459e:	e41fe0ef          	jal	800033de <dirlink>
    800045a2:	02054e63          	bltz	a0,800045de <create+0x11c>
    800045a6:	40d0                	lw	a2,4(s1)
    800045a8:	00003597          	auipc	a1,0x3
    800045ac:	07858593          	addi	a1,a1,120 # 80007620 <etext+0x620>
    800045b0:	854a                	mv	a0,s2
    800045b2:	e2dfe0ef          	jal	800033de <dirlink>
    800045b6:	02054463          	bltz	a0,800045de <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800045ba:	00492603          	lw	a2,4(s2)
    800045be:	fb040593          	addi	a1,s0,-80
    800045c2:	8526                	mv	a0,s1
    800045c4:	e1bfe0ef          	jal	800033de <dirlink>
    800045c8:	00054b63          	bltz	a0,800045de <create+0x11c>
    dp->nlink++;  // for ".."
    800045cc:	04a4d783          	lhu	a5,74(s1)
    800045d0:	2785                	addiw	a5,a5,1
    800045d2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800045d6:	8526                	mv	a0,s1
    800045d8:	dcefe0ef          	jal	80002ba6 <iupdate>
    800045dc:	b74d                	j	8000457e <create+0xbc>
  ip->nlink = 0;
    800045de:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    800045e2:	854a                	mv	a0,s2
    800045e4:	dc2fe0ef          	jal	80002ba6 <iupdate>
  iunlockput(ip);
    800045e8:	854a                	mv	a0,s2
    800045ea:	87dfe0ef          	jal	80002e66 <iunlockput>
  iunlockput(dp);
    800045ee:	8526                	mv	a0,s1
    800045f0:	877fe0ef          	jal	80002e66 <iunlockput>
  return 0;
    800045f4:	b73d                	j	80004522 <create+0x60>
    return 0;
    800045f6:	89aa                	mv	s3,a0
    800045f8:	b72d                	j	80004522 <create+0x60>

00000000800045fa <sys_dup>:
{
    800045fa:	7179                	addi	sp,sp,-48
    800045fc:	f406                	sd	ra,40(sp)
    800045fe:	f022                	sd	s0,32(sp)
    80004600:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004602:	fd840613          	addi	a2,s0,-40
    80004606:	4581                	li	a1,0
    80004608:	4501                	li	a0,0
    8000460a:	e1fff0ef          	jal	80004428 <argfd>
    return -1;
    8000460e:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004610:	02054363          	bltz	a0,80004636 <sys_dup+0x3c>
    80004614:	ec26                	sd	s1,24(sp)
    80004616:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004618:	fd843483          	ld	s1,-40(s0)
    8000461c:	8526                	mv	a0,s1
    8000461e:	e65ff0ef          	jal	80004482 <fdalloc>
    80004622:	892a                	mv	s2,a0
    return -1;
    80004624:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004626:	00054d63          	bltz	a0,80004640 <sys_dup+0x46>
  filedup(f);
    8000462a:	8526                	mv	a0,s1
    8000462c:	c18ff0ef          	jal	80003a44 <filedup>
  return fd;
    80004630:	87ca                	mv	a5,s2
    80004632:	64e2                	ld	s1,24(sp)
    80004634:	6942                	ld	s2,16(sp)
}
    80004636:	853e                	mv	a0,a5
    80004638:	70a2                	ld	ra,40(sp)
    8000463a:	7402                	ld	s0,32(sp)
    8000463c:	6145                	addi	sp,sp,48
    8000463e:	8082                	ret
    80004640:	64e2                	ld	s1,24(sp)
    80004642:	6942                	ld	s2,16(sp)
    80004644:	bfcd                	j	80004636 <sys_dup+0x3c>

0000000080004646 <sys_read>:
{
    80004646:	7179                	addi	sp,sp,-48
    80004648:	f406                	sd	ra,40(sp)
    8000464a:	f022                	sd	s0,32(sp)
    8000464c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000464e:	fd840593          	addi	a1,s0,-40
    80004652:	4505                	li	a0,1
    80004654:	a5bfd0ef          	jal	800020ae <argaddr>
  argint(2, &n);
    80004658:	fe440593          	addi	a1,s0,-28
    8000465c:	4509                	li	a0,2
    8000465e:	a35fd0ef          	jal	80002092 <argint>
  if(argfd(0, 0, &f) < 0)
    80004662:	fe840613          	addi	a2,s0,-24
    80004666:	4581                	li	a1,0
    80004668:	4501                	li	a0,0
    8000466a:	dbfff0ef          	jal	80004428 <argfd>
    8000466e:	87aa                	mv	a5,a0
    return -1;
    80004670:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004672:	0007ca63          	bltz	a5,80004686 <sys_read+0x40>
  return fileread(f, p, n);
    80004676:	fe442603          	lw	a2,-28(s0)
    8000467a:	fd843583          	ld	a1,-40(s0)
    8000467e:	fe843503          	ld	a0,-24(s0)
    80004682:	d2cff0ef          	jal	80003bae <fileread>
}
    80004686:	70a2                	ld	ra,40(sp)
    80004688:	7402                	ld	s0,32(sp)
    8000468a:	6145                	addi	sp,sp,48
    8000468c:	8082                	ret

000000008000468e <sys_write>:
{
    8000468e:	7179                	addi	sp,sp,-48
    80004690:	f406                	sd	ra,40(sp)
    80004692:	f022                	sd	s0,32(sp)
    80004694:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004696:	fd840593          	addi	a1,s0,-40
    8000469a:	4505                	li	a0,1
    8000469c:	a13fd0ef          	jal	800020ae <argaddr>
  argint(2, &n);
    800046a0:	fe440593          	addi	a1,s0,-28
    800046a4:	4509                	li	a0,2
    800046a6:	9edfd0ef          	jal	80002092 <argint>
  if(argfd(0, 0, &f) < 0)
    800046aa:	fe840613          	addi	a2,s0,-24
    800046ae:	4581                	li	a1,0
    800046b0:	4501                	li	a0,0
    800046b2:	d77ff0ef          	jal	80004428 <argfd>
    800046b6:	87aa                	mv	a5,a0
    return -1;
    800046b8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046ba:	0007ca63          	bltz	a5,800046ce <sys_write+0x40>
  return filewrite(f, p, n);
    800046be:	fe442603          	lw	a2,-28(s0)
    800046c2:	fd843583          	ld	a1,-40(s0)
    800046c6:	fe843503          	ld	a0,-24(s0)
    800046ca:	da8ff0ef          	jal	80003c72 <filewrite>
}
    800046ce:	70a2                	ld	ra,40(sp)
    800046d0:	7402                	ld	s0,32(sp)
    800046d2:	6145                	addi	sp,sp,48
    800046d4:	8082                	ret

00000000800046d6 <sys_close>:
{
    800046d6:	1101                	addi	sp,sp,-32
    800046d8:	ec06                	sd	ra,24(sp)
    800046da:	e822                	sd	s0,16(sp)
    800046dc:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800046de:	fe040613          	addi	a2,s0,-32
    800046e2:	fec40593          	addi	a1,s0,-20
    800046e6:	4501                	li	a0,0
    800046e8:	d41ff0ef          	jal	80004428 <argfd>
    return -1;
    800046ec:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800046ee:	02054163          	bltz	a0,80004710 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    800046f2:	a0bfc0ef          	jal	800010fc <myproc>
    800046f6:	fec42783          	lw	a5,-20(s0)
    800046fa:	078e                	slli	a5,a5,0x3
    800046fc:	0d078793          	addi	a5,a5,208
    80004700:	953e                	add	a0,a0,a5
    80004702:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004706:	fe043503          	ld	a0,-32(s0)
    8000470a:	b80ff0ef          	jal	80003a8a <fileclose>
  return 0;
    8000470e:	4781                	li	a5,0
}
    80004710:	853e                	mv	a0,a5
    80004712:	60e2                	ld	ra,24(sp)
    80004714:	6442                	ld	s0,16(sp)
    80004716:	6105                	addi	sp,sp,32
    80004718:	8082                	ret

000000008000471a <sys_fstat>:
{
    8000471a:	1101                	addi	sp,sp,-32
    8000471c:	ec06                	sd	ra,24(sp)
    8000471e:	e822                	sd	s0,16(sp)
    80004720:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004722:	fe040593          	addi	a1,s0,-32
    80004726:	4505                	li	a0,1
    80004728:	987fd0ef          	jal	800020ae <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000472c:	fe840613          	addi	a2,s0,-24
    80004730:	4581                	li	a1,0
    80004732:	4501                	li	a0,0
    80004734:	cf5ff0ef          	jal	80004428 <argfd>
    80004738:	87aa                	mv	a5,a0
    return -1;
    8000473a:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000473c:	0007c863          	bltz	a5,8000474c <sys_fstat+0x32>
  return filestat(f, st);
    80004740:	fe043583          	ld	a1,-32(s0)
    80004744:	fe843503          	ld	a0,-24(s0)
    80004748:	c04ff0ef          	jal	80003b4c <filestat>
}
    8000474c:	60e2                	ld	ra,24(sp)
    8000474e:	6442                	ld	s0,16(sp)
    80004750:	6105                	addi	sp,sp,32
    80004752:	8082                	ret

0000000080004754 <sys_link>:
{
    80004754:	7169                	addi	sp,sp,-304
    80004756:	f606                	sd	ra,296(sp)
    80004758:	f222                	sd	s0,288(sp)
    8000475a:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000475c:	08000613          	li	a2,128
    80004760:	ed040593          	addi	a1,s0,-304
    80004764:	4501                	li	a0,0
    80004766:	965fd0ef          	jal	800020ca <argstr>
    return -1;
    8000476a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000476c:	0c054e63          	bltz	a0,80004848 <sys_link+0xf4>
    80004770:	08000613          	li	a2,128
    80004774:	f5040593          	addi	a1,s0,-176
    80004778:	4505                	li	a0,1
    8000477a:	951fd0ef          	jal	800020ca <argstr>
    return -1;
    8000477e:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004780:	0c054463          	bltz	a0,80004848 <sys_link+0xf4>
    80004784:	ee26                	sd	s1,280(sp)
  begin_op();
    80004786:	ee1fe0ef          	jal	80003666 <begin_op>
  if((ip = namei(old)) == 0){
    8000478a:	ed040513          	addi	a0,s0,-304
    8000478e:	cfbfe0ef          	jal	80003488 <namei>
    80004792:	84aa                	mv	s1,a0
    80004794:	c53d                	beqz	a0,80004802 <sys_link+0xae>
  ilock(ip);
    80004796:	cc4fe0ef          	jal	80002c5a <ilock>
  if(ip->type == T_DIR){
    8000479a:	04449703          	lh	a4,68(s1)
    8000479e:	4785                	li	a5,1
    800047a0:	06f70663          	beq	a4,a5,8000480c <sys_link+0xb8>
    800047a4:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800047a6:	04a4d783          	lhu	a5,74(s1)
    800047aa:	2785                	addiw	a5,a5,1
    800047ac:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047b0:	8526                	mv	a0,s1
    800047b2:	bf4fe0ef          	jal	80002ba6 <iupdate>
  iunlock(ip);
    800047b6:	8526                	mv	a0,s1
    800047b8:	d50fe0ef          	jal	80002d08 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047bc:	fd040593          	addi	a1,s0,-48
    800047c0:	f5040513          	addi	a0,s0,-176
    800047c4:	cdffe0ef          	jal	800034a2 <nameiparent>
    800047c8:	892a                	mv	s2,a0
    800047ca:	cd21                	beqz	a0,80004822 <sys_link+0xce>
  ilock(dp);
    800047cc:	c8efe0ef          	jal	80002c5a <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047d0:	854a                	mv	a0,s2
    800047d2:	00092703          	lw	a4,0(s2)
    800047d6:	409c                	lw	a5,0(s1)
    800047d8:	04f71263          	bne	a4,a5,8000481c <sys_link+0xc8>
    800047dc:	40d0                	lw	a2,4(s1)
    800047de:	fd040593          	addi	a1,s0,-48
    800047e2:	bfdfe0ef          	jal	800033de <dirlink>
    800047e6:	02054b63          	bltz	a0,8000481c <sys_link+0xc8>
  iunlockput(dp);
    800047ea:	854a                	mv	a0,s2
    800047ec:	e7afe0ef          	jal	80002e66 <iunlockput>
  iput(ip);
    800047f0:	8526                	mv	a0,s1
    800047f2:	deafe0ef          	jal	80002ddc <iput>
  end_op();
    800047f6:	ee1fe0ef          	jal	800036d6 <end_op>
  return 0;
    800047fa:	4781                	li	a5,0
    800047fc:	64f2                	ld	s1,280(sp)
    800047fe:	6952                	ld	s2,272(sp)
    80004800:	a0a1                	j	80004848 <sys_link+0xf4>
    end_op();
    80004802:	ed5fe0ef          	jal	800036d6 <end_op>
    return -1;
    80004806:	57fd                	li	a5,-1
    80004808:	64f2                	ld	s1,280(sp)
    8000480a:	a83d                	j	80004848 <sys_link+0xf4>
    iunlockput(ip);
    8000480c:	8526                	mv	a0,s1
    8000480e:	e58fe0ef          	jal	80002e66 <iunlockput>
    end_op();
    80004812:	ec5fe0ef          	jal	800036d6 <end_op>
    return -1;
    80004816:	57fd                	li	a5,-1
    80004818:	64f2                	ld	s1,280(sp)
    8000481a:	a03d                	j	80004848 <sys_link+0xf4>
    iunlockput(dp);
    8000481c:	854a                	mv	a0,s2
    8000481e:	e48fe0ef          	jal	80002e66 <iunlockput>
  ilock(ip);
    80004822:	8526                	mv	a0,s1
    80004824:	c36fe0ef          	jal	80002c5a <ilock>
  ip->nlink--;
    80004828:	04a4d783          	lhu	a5,74(s1)
    8000482c:	37fd                	addiw	a5,a5,-1
    8000482e:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004832:	8526                	mv	a0,s1
    80004834:	b72fe0ef          	jal	80002ba6 <iupdate>
  iunlockput(ip);
    80004838:	8526                	mv	a0,s1
    8000483a:	e2cfe0ef          	jal	80002e66 <iunlockput>
  end_op();
    8000483e:	e99fe0ef          	jal	800036d6 <end_op>
  return -1;
    80004842:	57fd                	li	a5,-1
    80004844:	64f2                	ld	s1,280(sp)
    80004846:	6952                	ld	s2,272(sp)
}
    80004848:	853e                	mv	a0,a5
    8000484a:	70b2                	ld	ra,296(sp)
    8000484c:	7412                	ld	s0,288(sp)
    8000484e:	6155                	addi	sp,sp,304
    80004850:	8082                	ret

0000000080004852 <sys_unlink>:
{
    80004852:	7151                	addi	sp,sp,-240
    80004854:	f586                	sd	ra,232(sp)
    80004856:	f1a2                	sd	s0,224(sp)
    80004858:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000485a:	08000613          	li	a2,128
    8000485e:	f3040593          	addi	a1,s0,-208
    80004862:	4501                	li	a0,0
    80004864:	867fd0ef          	jal	800020ca <argstr>
    80004868:	14054d63          	bltz	a0,800049c2 <sys_unlink+0x170>
    8000486c:	eda6                	sd	s1,216(sp)
  begin_op();
    8000486e:	df9fe0ef          	jal	80003666 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004872:	fb040593          	addi	a1,s0,-80
    80004876:	f3040513          	addi	a0,s0,-208
    8000487a:	c29fe0ef          	jal	800034a2 <nameiparent>
    8000487e:	84aa                	mv	s1,a0
    80004880:	c955                	beqz	a0,80004934 <sys_unlink+0xe2>
  ilock(dp);
    80004882:	bd8fe0ef          	jal	80002c5a <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004886:	00003597          	auipc	a1,0x3
    8000488a:	d9258593          	addi	a1,a1,-622 # 80007618 <etext+0x618>
    8000488e:	fb040513          	addi	a0,s0,-80
    80004892:	94dfe0ef          	jal	800031de <namecmp>
    80004896:	10050b63          	beqz	a0,800049ac <sys_unlink+0x15a>
    8000489a:	00003597          	auipc	a1,0x3
    8000489e:	d8658593          	addi	a1,a1,-634 # 80007620 <etext+0x620>
    800048a2:	fb040513          	addi	a0,s0,-80
    800048a6:	939fe0ef          	jal	800031de <namecmp>
    800048aa:	10050163          	beqz	a0,800049ac <sys_unlink+0x15a>
    800048ae:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800048b0:	f2c40613          	addi	a2,s0,-212
    800048b4:	fb040593          	addi	a1,s0,-80
    800048b8:	8526                	mv	a0,s1
    800048ba:	93bfe0ef          	jal	800031f4 <dirlookup>
    800048be:	892a                	mv	s2,a0
    800048c0:	0e050563          	beqz	a0,800049aa <sys_unlink+0x158>
    800048c4:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800048c6:	b94fe0ef          	jal	80002c5a <ilock>
  if(ip->nlink < 1)
    800048ca:	04a91783          	lh	a5,74(s2)
    800048ce:	06f05863          	blez	a5,8000493e <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800048d2:	04491703          	lh	a4,68(s2)
    800048d6:	4785                	li	a5,1
    800048d8:	06f70963          	beq	a4,a5,8000494a <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800048dc:	fc040993          	addi	s3,s0,-64
    800048e0:	4641                	li	a2,16
    800048e2:	4581                	li	a1,0
    800048e4:	854e                	mv	a0,s3
    800048e6:	879fb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800048ea:	4741                	li	a4,16
    800048ec:	f2c42683          	lw	a3,-212(s0)
    800048f0:	864e                	mv	a2,s3
    800048f2:	4581                	li	a1,0
    800048f4:	8526                	mv	a0,s1
    800048f6:	fe8fe0ef          	jal	800030de <writei>
    800048fa:	47c1                	li	a5,16
    800048fc:	08f51863          	bne	a0,a5,8000498c <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80004900:	04491703          	lh	a4,68(s2)
    80004904:	4785                	li	a5,1
    80004906:	08f70963          	beq	a4,a5,80004998 <sys_unlink+0x146>
  iunlockput(dp);
    8000490a:	8526                	mv	a0,s1
    8000490c:	d5afe0ef          	jal	80002e66 <iunlockput>
  ip->nlink--;
    80004910:	04a95783          	lhu	a5,74(s2)
    80004914:	37fd                	addiw	a5,a5,-1
    80004916:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000491a:	854a                	mv	a0,s2
    8000491c:	a8afe0ef          	jal	80002ba6 <iupdate>
  iunlockput(ip);
    80004920:	854a                	mv	a0,s2
    80004922:	d44fe0ef          	jal	80002e66 <iunlockput>
  end_op();
    80004926:	db1fe0ef          	jal	800036d6 <end_op>
  return 0;
    8000492a:	4501                	li	a0,0
    8000492c:	64ee                	ld	s1,216(sp)
    8000492e:	694e                	ld	s2,208(sp)
    80004930:	69ae                	ld	s3,200(sp)
    80004932:	a061                	j	800049ba <sys_unlink+0x168>
    end_op();
    80004934:	da3fe0ef          	jal	800036d6 <end_op>
    return -1;
    80004938:	557d                	li	a0,-1
    8000493a:	64ee                	ld	s1,216(sp)
    8000493c:	a8bd                	j	800049ba <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000493e:	00003517          	auipc	a0,0x3
    80004942:	cea50513          	addi	a0,a0,-790 # 80007628 <etext+0x628>
    80004946:	2f0010ef          	jal	80005c36 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000494a:	04c92703          	lw	a4,76(s2)
    8000494e:	02000793          	li	a5,32
    80004952:	f8e7f5e3          	bgeu	a5,a4,800048dc <sys_unlink+0x8a>
    80004956:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004958:	4741                	li	a4,16
    8000495a:	86ce                	mv	a3,s3
    8000495c:	f1840613          	addi	a2,s0,-232
    80004960:	4581                	li	a1,0
    80004962:	854a                	mv	a0,s2
    80004964:	e88fe0ef          	jal	80002fec <readi>
    80004968:	47c1                	li	a5,16
    8000496a:	00f51b63          	bne	a0,a5,80004980 <sys_unlink+0x12e>
    if(de.inum != 0)
    8000496e:	f1845783          	lhu	a5,-232(s0)
    80004972:	ebb1                	bnez	a5,800049c6 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004974:	29c1                	addiw	s3,s3,16
    80004976:	04c92783          	lw	a5,76(s2)
    8000497a:	fcf9efe3          	bltu	s3,a5,80004958 <sys_unlink+0x106>
    8000497e:	bfb9                	j	800048dc <sys_unlink+0x8a>
      panic("isdirempty: readi");
    80004980:	00003517          	auipc	a0,0x3
    80004984:	cc050513          	addi	a0,a0,-832 # 80007640 <etext+0x640>
    80004988:	2ae010ef          	jal	80005c36 <panic>
    panic("unlink: writei");
    8000498c:	00003517          	auipc	a0,0x3
    80004990:	ccc50513          	addi	a0,a0,-820 # 80007658 <etext+0x658>
    80004994:	2a2010ef          	jal	80005c36 <panic>
    dp->nlink--;
    80004998:	04a4d783          	lhu	a5,74(s1)
    8000499c:	37fd                	addiw	a5,a5,-1
    8000499e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049a2:	8526                	mv	a0,s1
    800049a4:	a02fe0ef          	jal	80002ba6 <iupdate>
    800049a8:	b78d                	j	8000490a <sys_unlink+0xb8>
    800049aa:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800049ac:	8526                	mv	a0,s1
    800049ae:	cb8fe0ef          	jal	80002e66 <iunlockput>
  end_op();
    800049b2:	d25fe0ef          	jal	800036d6 <end_op>
  return -1;
    800049b6:	557d                	li	a0,-1
    800049b8:	64ee                	ld	s1,216(sp)
}
    800049ba:	70ae                	ld	ra,232(sp)
    800049bc:	740e                	ld	s0,224(sp)
    800049be:	616d                	addi	sp,sp,240
    800049c0:	8082                	ret
    return -1;
    800049c2:	557d                	li	a0,-1
    800049c4:	bfdd                	j	800049ba <sys_unlink+0x168>
    iunlockput(ip);
    800049c6:	854a                	mv	a0,s2
    800049c8:	c9efe0ef          	jal	80002e66 <iunlockput>
    goto bad;
    800049cc:	694e                	ld	s2,208(sp)
    800049ce:	69ae                	ld	s3,200(sp)
    800049d0:	bff1                	j	800049ac <sys_unlink+0x15a>

00000000800049d2 <sys_open>:

uint64
sys_open(void)
{
    800049d2:	7131                	addi	sp,sp,-192
    800049d4:	fd06                	sd	ra,184(sp)
    800049d6:	f922                	sd	s0,176(sp)
    800049d8:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800049da:	f4c40593          	addi	a1,s0,-180
    800049de:	4505                	li	a0,1
    800049e0:	eb2fd0ef          	jal	80002092 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800049e4:	08000613          	li	a2,128
    800049e8:	f5040593          	addi	a1,s0,-176
    800049ec:	4501                	li	a0,0
    800049ee:	edcfd0ef          	jal	800020ca <argstr>
    800049f2:	87aa                	mv	a5,a0
    return -1;
    800049f4:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800049f6:	0a07c363          	bltz	a5,80004a9c <sys_open+0xca>
    800049fa:	f526                	sd	s1,168(sp)

  begin_op();
    800049fc:	c6bfe0ef          	jal	80003666 <begin_op>

  if(omode & O_CREATE){
    80004a00:	f4c42783          	lw	a5,-180(s0)
    80004a04:	2007f793          	andi	a5,a5,512
    80004a08:	c3dd                	beqz	a5,80004aae <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004a0a:	4681                	li	a3,0
    80004a0c:	4601                	li	a2,0
    80004a0e:	4589                	li	a1,2
    80004a10:	f5040513          	addi	a0,s0,-176
    80004a14:	aafff0ef          	jal	800044c2 <create>
    80004a18:	84aa                	mv	s1,a0
    if(ip == 0){
    80004a1a:	c549                	beqz	a0,80004aa4 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004a1c:	04449703          	lh	a4,68(s1)
    80004a20:	478d                	li	a5,3
    80004a22:	00f71763          	bne	a4,a5,80004a30 <sys_open+0x5e>
    80004a26:	0464d703          	lhu	a4,70(s1)
    80004a2a:	47a5                	li	a5,9
    80004a2c:	0ae7ee63          	bltu	a5,a4,80004ae8 <sys_open+0x116>
    80004a30:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004a32:	fb5fe0ef          	jal	800039e6 <filealloc>
    80004a36:	892a                	mv	s2,a0
    80004a38:	c561                	beqz	a0,80004b00 <sys_open+0x12e>
    80004a3a:	ed4e                	sd	s3,152(sp)
    80004a3c:	a47ff0ef          	jal	80004482 <fdalloc>
    80004a40:	89aa                	mv	s3,a0
    80004a42:	0a054b63          	bltz	a0,80004af8 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004a46:	04449703          	lh	a4,68(s1)
    80004a4a:	478d                	li	a5,3
    80004a4c:	0cf70363          	beq	a4,a5,80004b12 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004a50:	4789                	li	a5,2
    80004a52:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004a56:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004a5a:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004a5e:	f4c42783          	lw	a5,-180(s0)
    80004a62:	0017f713          	andi	a4,a5,1
    80004a66:	00174713          	xori	a4,a4,1
    80004a6a:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004a6e:	0037f713          	andi	a4,a5,3
    80004a72:	00e03733          	snez	a4,a4
    80004a76:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004a7a:	4007f793          	andi	a5,a5,1024
    80004a7e:	c791                	beqz	a5,80004a8a <sys_open+0xb8>
    80004a80:	04449703          	lh	a4,68(s1)
    80004a84:	4789                	li	a5,2
    80004a86:	08f70d63          	beq	a4,a5,80004b20 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004a8a:	8526                	mv	a0,s1
    80004a8c:	a7cfe0ef          	jal	80002d08 <iunlock>
  end_op();
    80004a90:	c47fe0ef          	jal	800036d6 <end_op>

  return fd;
    80004a94:	854e                	mv	a0,s3
    80004a96:	74aa                	ld	s1,168(sp)
    80004a98:	790a                	ld	s2,160(sp)
    80004a9a:	69ea                	ld	s3,152(sp)
}
    80004a9c:	70ea                	ld	ra,184(sp)
    80004a9e:	744a                	ld	s0,176(sp)
    80004aa0:	6129                	addi	sp,sp,192
    80004aa2:	8082                	ret
      end_op();
    80004aa4:	c33fe0ef          	jal	800036d6 <end_op>
      return -1;
    80004aa8:	557d                	li	a0,-1
    80004aaa:	74aa                	ld	s1,168(sp)
    80004aac:	bfc5                	j	80004a9c <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004aae:	f5040513          	addi	a0,s0,-176
    80004ab2:	9d7fe0ef          	jal	80003488 <namei>
    80004ab6:	84aa                	mv	s1,a0
    80004ab8:	c11d                	beqz	a0,80004ade <sys_open+0x10c>
    ilock(ip);
    80004aba:	9a0fe0ef          	jal	80002c5a <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004abe:	04449703          	lh	a4,68(s1)
    80004ac2:	4785                	li	a5,1
    80004ac4:	f4f71ce3          	bne	a4,a5,80004a1c <sys_open+0x4a>
    80004ac8:	f4c42783          	lw	a5,-180(s0)
    80004acc:	d3b5                	beqz	a5,80004a30 <sys_open+0x5e>
      iunlockput(ip);
    80004ace:	8526                	mv	a0,s1
    80004ad0:	b96fe0ef          	jal	80002e66 <iunlockput>
      end_op();
    80004ad4:	c03fe0ef          	jal	800036d6 <end_op>
      return -1;
    80004ad8:	557d                	li	a0,-1
    80004ada:	74aa                	ld	s1,168(sp)
    80004adc:	b7c1                	j	80004a9c <sys_open+0xca>
      end_op();
    80004ade:	bf9fe0ef          	jal	800036d6 <end_op>
      return -1;
    80004ae2:	557d                	li	a0,-1
    80004ae4:	74aa                	ld	s1,168(sp)
    80004ae6:	bf5d                	j	80004a9c <sys_open+0xca>
    iunlockput(ip);
    80004ae8:	8526                	mv	a0,s1
    80004aea:	b7cfe0ef          	jal	80002e66 <iunlockput>
    end_op();
    80004aee:	be9fe0ef          	jal	800036d6 <end_op>
    return -1;
    80004af2:	557d                	li	a0,-1
    80004af4:	74aa                	ld	s1,168(sp)
    80004af6:	b75d                	j	80004a9c <sys_open+0xca>
      fileclose(f);
    80004af8:	854a                	mv	a0,s2
    80004afa:	f91fe0ef          	jal	80003a8a <fileclose>
    80004afe:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004b00:	8526                	mv	a0,s1
    80004b02:	b64fe0ef          	jal	80002e66 <iunlockput>
    end_op();
    80004b06:	bd1fe0ef          	jal	800036d6 <end_op>
    return -1;
    80004b0a:	557d                	li	a0,-1
    80004b0c:	74aa                	ld	s1,168(sp)
    80004b0e:	790a                	ld	s2,160(sp)
    80004b10:	b771                	j	80004a9c <sys_open+0xca>
    f->type = FD_DEVICE;
    80004b12:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004b16:	04649783          	lh	a5,70(s1)
    80004b1a:	02f91223          	sh	a5,36(s2)
    80004b1e:	bf35                	j	80004a5a <sys_open+0x88>
    itrunc(ip);
    80004b20:	8526                	mv	a0,s1
    80004b22:	a26fe0ef          	jal	80002d48 <itrunc>
    80004b26:	b795                	j	80004a8a <sys_open+0xb8>

0000000080004b28 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004b28:	7175                	addi	sp,sp,-144
    80004b2a:	e506                	sd	ra,136(sp)
    80004b2c:	e122                	sd	s0,128(sp)
    80004b2e:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004b30:	b37fe0ef          	jal	80003666 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004b34:	08000613          	li	a2,128
    80004b38:	f7040593          	addi	a1,s0,-144
    80004b3c:	4501                	li	a0,0
    80004b3e:	d8cfd0ef          	jal	800020ca <argstr>
    80004b42:	02054363          	bltz	a0,80004b68 <sys_mkdir+0x40>
    80004b46:	4681                	li	a3,0
    80004b48:	4601                	li	a2,0
    80004b4a:	4585                	li	a1,1
    80004b4c:	f7040513          	addi	a0,s0,-144
    80004b50:	973ff0ef          	jal	800044c2 <create>
    80004b54:	c911                	beqz	a0,80004b68 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004b56:	b10fe0ef          	jal	80002e66 <iunlockput>
  end_op();
    80004b5a:	b7dfe0ef          	jal	800036d6 <end_op>
  return 0;
    80004b5e:	4501                	li	a0,0
}
    80004b60:	60aa                	ld	ra,136(sp)
    80004b62:	640a                	ld	s0,128(sp)
    80004b64:	6149                	addi	sp,sp,144
    80004b66:	8082                	ret
    end_op();
    80004b68:	b6ffe0ef          	jal	800036d6 <end_op>
    return -1;
    80004b6c:	557d                	li	a0,-1
    80004b6e:	bfcd                	j	80004b60 <sys_mkdir+0x38>

0000000080004b70 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004b70:	7135                	addi	sp,sp,-160
    80004b72:	ed06                	sd	ra,152(sp)
    80004b74:	e922                	sd	s0,144(sp)
    80004b76:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004b78:	aeffe0ef          	jal	80003666 <begin_op>
  argint(1, &major);
    80004b7c:	f6c40593          	addi	a1,s0,-148
    80004b80:	4505                	li	a0,1
    80004b82:	d10fd0ef          	jal	80002092 <argint>
  argint(2, &minor);
    80004b86:	f6840593          	addi	a1,s0,-152
    80004b8a:	4509                	li	a0,2
    80004b8c:	d06fd0ef          	jal	80002092 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004b90:	08000613          	li	a2,128
    80004b94:	f7040593          	addi	a1,s0,-144
    80004b98:	4501                	li	a0,0
    80004b9a:	d30fd0ef          	jal	800020ca <argstr>
    80004b9e:	02054563          	bltz	a0,80004bc8 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004ba2:	f6841683          	lh	a3,-152(s0)
    80004ba6:	f6c41603          	lh	a2,-148(s0)
    80004baa:	458d                	li	a1,3
    80004bac:	f7040513          	addi	a0,s0,-144
    80004bb0:	913ff0ef          	jal	800044c2 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004bb4:	c911                	beqz	a0,80004bc8 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004bb6:	ab0fe0ef          	jal	80002e66 <iunlockput>
  end_op();
    80004bba:	b1dfe0ef          	jal	800036d6 <end_op>
  return 0;
    80004bbe:	4501                	li	a0,0
}
    80004bc0:	60ea                	ld	ra,152(sp)
    80004bc2:	644a                	ld	s0,144(sp)
    80004bc4:	610d                	addi	sp,sp,160
    80004bc6:	8082                	ret
    end_op();
    80004bc8:	b0ffe0ef          	jal	800036d6 <end_op>
    return -1;
    80004bcc:	557d                	li	a0,-1
    80004bce:	bfcd                	j	80004bc0 <sys_mknod+0x50>

0000000080004bd0 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004bd0:	7135                	addi	sp,sp,-160
    80004bd2:	ed06                	sd	ra,152(sp)
    80004bd4:	e922                	sd	s0,144(sp)
    80004bd6:	e14a                	sd	s2,128(sp)
    80004bd8:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004bda:	d22fc0ef          	jal	800010fc <myproc>
    80004bde:	892a                	mv	s2,a0
  
  begin_op();
    80004be0:	a87fe0ef          	jal	80003666 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004be4:	08000613          	li	a2,128
    80004be8:	f6040593          	addi	a1,s0,-160
    80004bec:	4501                	li	a0,0
    80004bee:	cdcfd0ef          	jal	800020ca <argstr>
    80004bf2:	04054363          	bltz	a0,80004c38 <sys_chdir+0x68>
    80004bf6:	e526                	sd	s1,136(sp)
    80004bf8:	f6040513          	addi	a0,s0,-160
    80004bfc:	88dfe0ef          	jal	80003488 <namei>
    80004c00:	84aa                	mv	s1,a0
    80004c02:	c915                	beqz	a0,80004c36 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004c04:	856fe0ef          	jal	80002c5a <ilock>
  if(ip->type != T_DIR){
    80004c08:	04449703          	lh	a4,68(s1)
    80004c0c:	4785                	li	a5,1
    80004c0e:	02f71963          	bne	a4,a5,80004c40 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004c12:	8526                	mv	a0,s1
    80004c14:	8f4fe0ef          	jal	80002d08 <iunlock>
  iput(p->cwd);
    80004c18:	15093503          	ld	a0,336(s2)
    80004c1c:	9c0fe0ef          	jal	80002ddc <iput>
  end_op();
    80004c20:	ab7fe0ef          	jal	800036d6 <end_op>
  p->cwd = ip;
    80004c24:	14993823          	sd	s1,336(s2)
  return 0;
    80004c28:	4501                	li	a0,0
    80004c2a:	64aa                	ld	s1,136(sp)
}
    80004c2c:	60ea                	ld	ra,152(sp)
    80004c2e:	644a                	ld	s0,144(sp)
    80004c30:	690a                	ld	s2,128(sp)
    80004c32:	610d                	addi	sp,sp,160
    80004c34:	8082                	ret
    80004c36:	64aa                	ld	s1,136(sp)
    end_op();
    80004c38:	a9ffe0ef          	jal	800036d6 <end_op>
    return -1;
    80004c3c:	557d                	li	a0,-1
    80004c3e:	b7fd                	j	80004c2c <sys_chdir+0x5c>
    iunlockput(ip);
    80004c40:	8526                	mv	a0,s1
    80004c42:	a24fe0ef          	jal	80002e66 <iunlockput>
    end_op();
    80004c46:	a91fe0ef          	jal	800036d6 <end_op>
    return -1;
    80004c4a:	557d                	li	a0,-1
    80004c4c:	64aa                	ld	s1,136(sp)
    80004c4e:	bff9                	j	80004c2c <sys_chdir+0x5c>

0000000080004c50 <sys_exec>:

uint64
sys_exec(void)
{
    80004c50:	7105                	addi	sp,sp,-480
    80004c52:	ef86                	sd	ra,472(sp)
    80004c54:	eba2                	sd	s0,464(sp)
    80004c56:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004c58:	e2840593          	addi	a1,s0,-472
    80004c5c:	4505                	li	a0,1
    80004c5e:	c50fd0ef          	jal	800020ae <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004c62:	08000613          	li	a2,128
    80004c66:	f3040593          	addi	a1,s0,-208
    80004c6a:	4501                	li	a0,0
    80004c6c:	c5efd0ef          	jal	800020ca <argstr>
    80004c70:	87aa                	mv	a5,a0
    return -1;
    80004c72:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004c74:	0e07c063          	bltz	a5,80004d54 <sys_exec+0x104>
    80004c78:	e7a6                	sd	s1,456(sp)
    80004c7a:	e3ca                	sd	s2,448(sp)
    80004c7c:	ff4e                	sd	s3,440(sp)
    80004c7e:	fb52                	sd	s4,432(sp)
    80004c80:	f756                	sd	s5,424(sp)
    80004c82:	f35a                	sd	s6,416(sp)
    80004c84:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004c86:	e3040a13          	addi	s4,s0,-464
    80004c8a:	10000613          	li	a2,256
    80004c8e:	4581                	li	a1,0
    80004c90:	8552                	mv	a0,s4
    80004c92:	cccfb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004c96:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004c98:	89d2                	mv	s3,s4
    80004c9a:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004c9c:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ca0:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004ca2:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004ca6:	00391513          	slli	a0,s2,0x3
    80004caa:	85d6                	mv	a1,s5
    80004cac:	e2843783          	ld	a5,-472(s0)
    80004cb0:	953e                	add	a0,a0,a5
    80004cb2:	b56fd0ef          	jal	80002008 <fetchaddr>
    80004cb6:	02054663          	bltz	a0,80004ce2 <sys_exec+0x92>
    if(uarg == 0){
    80004cba:	e2043783          	ld	a5,-480(s0)
    80004cbe:	c7a1                	beqz	a5,80004d06 <sys_exec+0xb6>
    argv[i] = kalloc();
    80004cc0:	c44fb0ef          	jal	80000104 <kalloc>
    80004cc4:	85aa                	mv	a1,a0
    80004cc6:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004cca:	cd01                	beqz	a0,80004ce2 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ccc:	865a                	mv	a2,s6
    80004cce:	e2043503          	ld	a0,-480(s0)
    80004cd2:	b80fd0ef          	jal	80002052 <fetchstr>
    80004cd6:	00054663          	bltz	a0,80004ce2 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004cda:	0905                	addi	s2,s2,1
    80004cdc:	09a1                	addi	s3,s3,8
    80004cde:	fd7914e3          	bne	s2,s7,80004ca6 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004ce2:	100a0a13          	addi	s4,s4,256
    80004ce6:	6088                	ld	a0,0(s1)
    80004ce8:	cd31                	beqz	a0,80004d44 <sys_exec+0xf4>
    kfree(argv[i]);
    80004cea:	b32fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004cee:	04a1                	addi	s1,s1,8
    80004cf0:	ff449be3          	bne	s1,s4,80004ce6 <sys_exec+0x96>
  return -1;
    80004cf4:	557d                	li	a0,-1
    80004cf6:	64be                	ld	s1,456(sp)
    80004cf8:	691e                	ld	s2,448(sp)
    80004cfa:	79fa                	ld	s3,440(sp)
    80004cfc:	7a5a                	ld	s4,432(sp)
    80004cfe:	7aba                	ld	s5,424(sp)
    80004d00:	7b1a                	ld	s6,416(sp)
    80004d02:	6bfa                	ld	s7,408(sp)
    80004d04:	a881                	j	80004d54 <sys_exec+0x104>
      argv[i] = 0;
    80004d06:	0009079b          	sext.w	a5,s2
    80004d0a:	e3040593          	addi	a1,s0,-464
    80004d0e:	078e                	slli	a5,a5,0x3
    80004d10:	97ae                	add	a5,a5,a1
    80004d12:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004d16:	f3040513          	addi	a0,s0,-208
    80004d1a:	bb2ff0ef          	jal	800040cc <kexec>
    80004d1e:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004d20:	100a0a13          	addi	s4,s4,256
    80004d24:	6088                	ld	a0,0(s1)
    80004d26:	c511                	beqz	a0,80004d32 <sys_exec+0xe2>
    kfree(argv[i]);
    80004d28:	af4fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004d2c:	04a1                	addi	s1,s1,8
    80004d2e:	ff449be3          	bne	s1,s4,80004d24 <sys_exec+0xd4>
  return ret;
    80004d32:	854a                	mv	a0,s2
    80004d34:	64be                	ld	s1,456(sp)
    80004d36:	691e                	ld	s2,448(sp)
    80004d38:	79fa                	ld	s3,440(sp)
    80004d3a:	7a5a                	ld	s4,432(sp)
    80004d3c:	7aba                	ld	s5,424(sp)
    80004d3e:	7b1a                	ld	s6,416(sp)
    80004d40:	6bfa                	ld	s7,408(sp)
    80004d42:	a809                	j	80004d54 <sys_exec+0x104>
  return -1;
    80004d44:	557d                	li	a0,-1
    80004d46:	64be                	ld	s1,456(sp)
    80004d48:	691e                	ld	s2,448(sp)
    80004d4a:	79fa                	ld	s3,440(sp)
    80004d4c:	7a5a                	ld	s4,432(sp)
    80004d4e:	7aba                	ld	s5,424(sp)
    80004d50:	7b1a                	ld	s6,416(sp)
    80004d52:	6bfa                	ld	s7,408(sp)
}
    80004d54:	60fe                	ld	ra,472(sp)
    80004d56:	645e                	ld	s0,464(sp)
    80004d58:	613d                	addi	sp,sp,480
    80004d5a:	8082                	ret

0000000080004d5c <sys_pipe>:

uint64
sys_pipe(void)
{
    80004d5c:	7139                	addi	sp,sp,-64
    80004d5e:	fc06                	sd	ra,56(sp)
    80004d60:	f822                	sd	s0,48(sp)
    80004d62:	f426                	sd	s1,40(sp)
    80004d64:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004d66:	b96fc0ef          	jal	800010fc <myproc>
    80004d6a:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004d6c:	fd840593          	addi	a1,s0,-40
    80004d70:	4501                	li	a0,0
    80004d72:	b3cfd0ef          	jal	800020ae <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004d76:	fc840593          	addi	a1,s0,-56
    80004d7a:	fd040513          	addi	a0,s0,-48
    80004d7e:	828ff0ef          	jal	80003da6 <pipealloc>
    return -1;
    80004d82:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004d84:	0a054763          	bltz	a0,80004e32 <sys_pipe+0xd6>
  fd0 = -1;
    80004d88:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004d8c:	fd043503          	ld	a0,-48(s0)
    80004d90:	ef2ff0ef          	jal	80004482 <fdalloc>
    80004d94:	fca42223          	sw	a0,-60(s0)
    80004d98:	08054463          	bltz	a0,80004e20 <sys_pipe+0xc4>
    80004d9c:	fc843503          	ld	a0,-56(s0)
    80004da0:	ee2ff0ef          	jal	80004482 <fdalloc>
    80004da4:	fca42023          	sw	a0,-64(s0)
    80004da8:	06054263          	bltz	a0,80004e0c <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004dac:	4691                	li	a3,4
    80004dae:	fc440613          	addi	a2,s0,-60
    80004db2:	fd843583          	ld	a1,-40(s0)
    80004db6:	68a8                	ld	a0,80(s1)
    80004db8:	e67fb0ef          	jal	80000c1e <copyout>
    80004dbc:	00054e63          	bltz	a0,80004dd8 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004dc0:	4691                	li	a3,4
    80004dc2:	fc040613          	addi	a2,s0,-64
    80004dc6:	fd843583          	ld	a1,-40(s0)
    80004dca:	95b6                	add	a1,a1,a3
    80004dcc:	68a8                	ld	a0,80(s1)
    80004dce:	e51fb0ef          	jal	80000c1e <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004dd2:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004dd4:	04055f63          	bgez	a0,80004e32 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80004dd8:	fc442783          	lw	a5,-60(s0)
    80004ddc:	078e                	slli	a5,a5,0x3
    80004dde:	0d078793          	addi	a5,a5,208
    80004de2:	97a6                	add	a5,a5,s1
    80004de4:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004de8:	fc042783          	lw	a5,-64(s0)
    80004dec:	078e                	slli	a5,a5,0x3
    80004dee:	0d078793          	addi	a5,a5,208
    80004df2:	97a6                	add	a5,a5,s1
    80004df4:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004df8:	fd043503          	ld	a0,-48(s0)
    80004dfc:	c8ffe0ef          	jal	80003a8a <fileclose>
    fileclose(wf);
    80004e00:	fc843503          	ld	a0,-56(s0)
    80004e04:	c87fe0ef          	jal	80003a8a <fileclose>
    return -1;
    80004e08:	57fd                	li	a5,-1
    80004e0a:	a025                	j	80004e32 <sys_pipe+0xd6>
    if(fd0 >= 0)
    80004e0c:	fc442783          	lw	a5,-60(s0)
    80004e10:	0007c863          	bltz	a5,80004e20 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004e14:	078e                	slli	a5,a5,0x3
    80004e16:	0d078793          	addi	a5,a5,208
    80004e1a:	97a6                	add	a5,a5,s1
    80004e1c:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004e20:	fd043503          	ld	a0,-48(s0)
    80004e24:	c67fe0ef          	jal	80003a8a <fileclose>
    fileclose(wf);
    80004e28:	fc843503          	ld	a0,-56(s0)
    80004e2c:	c5ffe0ef          	jal	80003a8a <fileclose>
    return -1;
    80004e30:	57fd                	li	a5,-1
}
    80004e32:	853e                	mv	a0,a5
    80004e34:	70e2                	ld	ra,56(sp)
    80004e36:	7442                	ld	s0,48(sp)
    80004e38:	74a2                	ld	s1,40(sp)
    80004e3a:	6121                	addi	sp,sp,64
    80004e3c:	8082                	ret
	...

0000000080004e40 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004e40:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004e42:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004e44:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004e46:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004e48:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80004e4a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80004e4c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80004e4e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004e50:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004e52:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004e54:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004e56:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004e58:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80004e5a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80004e5c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80004e5e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004e60:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004e62:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004e64:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004e66:	8b0fd0ef          	jal	80001f16 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80004e6a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80004e6c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80004e6e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004e70:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004e72:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004e74:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004e76:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004e78:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80004e7a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80004e7c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80004e7e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004e80:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004e82:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004e84:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004e86:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004e88:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80004e8a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80004e8c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80004e8e:	10200073          	sret
    80004e92:	00000013          	nop
    80004e96:	00000013          	nop
    80004e9a:	00000013          	nop

0000000080004e9e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004e9e:	1141                	addi	sp,sp,-16
    80004ea0:	e406                	sd	ra,8(sp)
    80004ea2:	e022                	sd	s0,0(sp)
    80004ea4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004ea6:	0c000737          	lui	a4,0xc000
    80004eaa:	4785                	li	a5,1
    80004eac:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004eae:	c35c                	sw	a5,4(a4)
}
    80004eb0:	60a2                	ld	ra,8(sp)
    80004eb2:	6402                	ld	s0,0(sp)
    80004eb4:	0141                	addi	sp,sp,16
    80004eb6:	8082                	ret

0000000080004eb8 <plicinithart>:

void
plicinithart(void)
{
    80004eb8:	1141                	addi	sp,sp,-16
    80004eba:	e406                	sd	ra,8(sp)
    80004ebc:	e022                	sd	s0,0(sp)
    80004ebe:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ec0:	a08fc0ef          	jal	800010c8 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004ec4:	0085171b          	slliw	a4,a0,0x8
    80004ec8:	0c0027b7          	lui	a5,0xc002
    80004ecc:	97ba                	add	a5,a5,a4
    80004ece:	40200713          	li	a4,1026
    80004ed2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004ed6:	00d5151b          	slliw	a0,a0,0xd
    80004eda:	0c2017b7          	lui	a5,0xc201
    80004ede:	97aa                	add	a5,a5,a0
    80004ee0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004ee4:	60a2                	ld	ra,8(sp)
    80004ee6:	6402                	ld	s0,0(sp)
    80004ee8:	0141                	addi	sp,sp,16
    80004eea:	8082                	ret

0000000080004eec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004eec:	1141                	addi	sp,sp,-16
    80004eee:	e406                	sd	ra,8(sp)
    80004ef0:	e022                	sd	s0,0(sp)
    80004ef2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ef4:	9d4fc0ef          	jal	800010c8 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004ef8:	00d5151b          	slliw	a0,a0,0xd
    80004efc:	0c2017b7          	lui	a5,0xc201
    80004f00:	97aa                	add	a5,a5,a0
  return irq;
}
    80004f02:	43c8                	lw	a0,4(a5)
    80004f04:	60a2                	ld	ra,8(sp)
    80004f06:	6402                	ld	s0,0(sp)
    80004f08:	0141                	addi	sp,sp,16
    80004f0a:	8082                	ret

0000000080004f0c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004f0c:	1101                	addi	sp,sp,-32
    80004f0e:	ec06                	sd	ra,24(sp)
    80004f10:	e822                	sd	s0,16(sp)
    80004f12:	e426                	sd	s1,8(sp)
    80004f14:	1000                	addi	s0,sp,32
    80004f16:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004f18:	9b0fc0ef          	jal	800010c8 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004f1c:	00d5179b          	slliw	a5,a0,0xd
    80004f20:	0c201737          	lui	a4,0xc201
    80004f24:	97ba                	add	a5,a5,a4
    80004f26:	c3c4                	sw	s1,4(a5)
}
    80004f28:	60e2                	ld	ra,24(sp)
    80004f2a:	6442                	ld	s0,16(sp)
    80004f2c:	64a2                	ld	s1,8(sp)
    80004f2e:	6105                	addi	sp,sp,32
    80004f30:	8082                	ret

0000000080004f32 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004f32:	1141                	addi	sp,sp,-16
    80004f34:	e406                	sd	ra,8(sp)
    80004f36:	e022                	sd	s0,0(sp)
    80004f38:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004f3a:	479d                	li	a5,7
    80004f3c:	04a7ca63          	blt	a5,a0,80004f90 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004f40:	00020797          	auipc	a5,0x20
    80004f44:	ce078793          	addi	a5,a5,-800 # 80024c20 <disk>
    80004f48:	97aa                	add	a5,a5,a0
    80004f4a:	0187c783          	lbu	a5,24(a5)
    80004f4e:	e7b9                	bnez	a5,80004f9c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004f50:	00451693          	slli	a3,a0,0x4
    80004f54:	00020797          	auipc	a5,0x20
    80004f58:	ccc78793          	addi	a5,a5,-820 # 80024c20 <disk>
    80004f5c:	6398                	ld	a4,0(a5)
    80004f5e:	9736                	add	a4,a4,a3
    80004f60:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004f64:	6398                	ld	a4,0(a5)
    80004f66:	9736                	add	a4,a4,a3
    80004f68:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004f6c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004f70:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004f74:	97aa                	add	a5,a5,a0
    80004f76:	4705                	li	a4,1
    80004f78:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004f7c:	00020517          	auipc	a0,0x20
    80004f80:	cbc50513          	addi	a0,a0,-836 # 80024c38 <disk+0x18>
    80004f84:	80bfc0ef          	jal	8000178e <wakeup>
}
    80004f88:	60a2                	ld	ra,8(sp)
    80004f8a:	6402                	ld	s0,0(sp)
    80004f8c:	0141                	addi	sp,sp,16
    80004f8e:	8082                	ret
    panic("free_desc 1");
    80004f90:	00002517          	auipc	a0,0x2
    80004f94:	6d850513          	addi	a0,a0,1752 # 80007668 <etext+0x668>
    80004f98:	49f000ef          	jal	80005c36 <panic>
    panic("free_desc 2");
    80004f9c:	00002517          	auipc	a0,0x2
    80004fa0:	6dc50513          	addi	a0,a0,1756 # 80007678 <etext+0x678>
    80004fa4:	493000ef          	jal	80005c36 <panic>

0000000080004fa8 <virtio_disk_init>:
{
    80004fa8:	1101                	addi	sp,sp,-32
    80004faa:	ec06                	sd	ra,24(sp)
    80004fac:	e822                	sd	s0,16(sp)
    80004fae:	e426                	sd	s1,8(sp)
    80004fb0:	e04a                	sd	s2,0(sp)
    80004fb2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004fb4:	00002597          	auipc	a1,0x2
    80004fb8:	6d458593          	addi	a1,a1,1748 # 80007688 <etext+0x688>
    80004fbc:	00020517          	auipc	a0,0x20
    80004fc0:	d8c50513          	addi	a0,a0,-628 # 80024d48 <disk+0x128>
    80004fc4:	6ab000ef          	jal	80005e6e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004fc8:	100017b7          	lui	a5,0x10001
    80004fcc:	4398                	lw	a4,0(a5)
    80004fce:	2701                	sext.w	a4,a4
    80004fd0:	747277b7          	lui	a5,0x74727
    80004fd4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004fd8:	14f71863          	bne	a4,a5,80005128 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004fdc:	100017b7          	lui	a5,0x10001
    80004fe0:	43dc                	lw	a5,4(a5)
    80004fe2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004fe4:	4709                	li	a4,2
    80004fe6:	14e79163          	bne	a5,a4,80005128 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004fea:	100017b7          	lui	a5,0x10001
    80004fee:	479c                	lw	a5,8(a5)
    80004ff0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004ff2:	12e79b63          	bne	a5,a4,80005128 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004ff6:	100017b7          	lui	a5,0x10001
    80004ffa:	47d8                	lw	a4,12(a5)
    80004ffc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004ffe:	554d47b7          	lui	a5,0x554d4
    80005002:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005006:	12f71163          	bne	a4,a5,80005128 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000500a:	100017b7          	lui	a5,0x10001
    8000500e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005012:	4705                	li	a4,1
    80005014:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005016:	470d                	li	a4,3
    80005018:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000501a:	10001737          	lui	a4,0x10001
    8000501e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005020:	c7ffe6b7          	lui	a3,0xc7ffe
    80005024:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd1927>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005028:	8f75                	and	a4,a4,a3
    8000502a:	100016b7          	lui	a3,0x10001
    8000502e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005030:	472d                	li	a4,11
    80005032:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005034:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005038:	439c                	lw	a5,0(a5)
    8000503a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000503e:	8ba1                	andi	a5,a5,8
    80005040:	0e078a63          	beqz	a5,80005134 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005044:	100017b7          	lui	a5,0x10001
    80005048:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000504c:	43fc                	lw	a5,68(a5)
    8000504e:	2781                	sext.w	a5,a5
    80005050:	0e079863          	bnez	a5,80005140 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005054:	100017b7          	lui	a5,0x10001
    80005058:	5bdc                	lw	a5,52(a5)
    8000505a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000505c:	0e078863          	beqz	a5,8000514c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005060:	471d                	li	a4,7
    80005062:	0ef77b63          	bgeu	a4,a5,80005158 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005066:	89efb0ef          	jal	80000104 <kalloc>
    8000506a:	00020497          	auipc	s1,0x20
    8000506e:	bb648493          	addi	s1,s1,-1098 # 80024c20 <disk>
    80005072:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005074:	890fb0ef          	jal	80000104 <kalloc>
    80005078:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000507a:	88afb0ef          	jal	80000104 <kalloc>
    8000507e:	87aa                	mv	a5,a0
    80005080:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005082:	6088                	ld	a0,0(s1)
    80005084:	0e050063          	beqz	a0,80005164 <virtio_disk_init+0x1bc>
    80005088:	00020717          	auipc	a4,0x20
    8000508c:	ba073703          	ld	a4,-1120(a4) # 80024c28 <disk+0x8>
    80005090:	cb71                	beqz	a4,80005164 <virtio_disk_init+0x1bc>
    80005092:	cbe9                	beqz	a5,80005164 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005094:	6605                	lui	a2,0x1
    80005096:	4581                	li	a1,0
    80005098:	8c6fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    8000509c:	00020497          	auipc	s1,0x20
    800050a0:	b8448493          	addi	s1,s1,-1148 # 80024c20 <disk>
    800050a4:	6605                	lui	a2,0x1
    800050a6:	4581                	li	a1,0
    800050a8:	6488                	ld	a0,8(s1)
    800050aa:	8b4fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    800050ae:	6605                	lui	a2,0x1
    800050b0:	4581                	li	a1,0
    800050b2:	6888                	ld	a0,16(s1)
    800050b4:	8aafb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800050b8:	100017b7          	lui	a5,0x10001
    800050bc:	4721                	li	a4,8
    800050be:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800050c0:	4098                	lw	a4,0(s1)
    800050c2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800050c6:	40d8                	lw	a4,4(s1)
    800050c8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800050cc:	649c                	ld	a5,8(s1)
    800050ce:	0007869b          	sext.w	a3,a5
    800050d2:	10001737          	lui	a4,0x10001
    800050d6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800050da:	9781                	srai	a5,a5,0x20
    800050dc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800050e0:	689c                	ld	a5,16(s1)
    800050e2:	0007869b          	sext.w	a3,a5
    800050e6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800050ea:	9781                	srai	a5,a5,0x20
    800050ec:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800050f0:	4785                	li	a5,1
    800050f2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    800050f4:	00f48c23          	sb	a5,24(s1)
    800050f8:	00f48ca3          	sb	a5,25(s1)
    800050fc:	00f48d23          	sb	a5,26(s1)
    80005100:	00f48da3          	sb	a5,27(s1)
    80005104:	00f48e23          	sb	a5,28(s1)
    80005108:	00f48ea3          	sb	a5,29(s1)
    8000510c:	00f48f23          	sb	a5,30(s1)
    80005110:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005114:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005118:	07272823          	sw	s2,112(a4)
}
    8000511c:	60e2                	ld	ra,24(sp)
    8000511e:	6442                	ld	s0,16(sp)
    80005120:	64a2                	ld	s1,8(sp)
    80005122:	6902                	ld	s2,0(sp)
    80005124:	6105                	addi	sp,sp,32
    80005126:	8082                	ret
    panic("could not find virtio disk");
    80005128:	00002517          	auipc	a0,0x2
    8000512c:	57050513          	addi	a0,a0,1392 # 80007698 <etext+0x698>
    80005130:	307000ef          	jal	80005c36 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005134:	00002517          	auipc	a0,0x2
    80005138:	58450513          	addi	a0,a0,1412 # 800076b8 <etext+0x6b8>
    8000513c:	2fb000ef          	jal	80005c36 <panic>
    panic("virtio disk should not be ready");
    80005140:	00002517          	auipc	a0,0x2
    80005144:	59850513          	addi	a0,a0,1432 # 800076d8 <etext+0x6d8>
    80005148:	2ef000ef          	jal	80005c36 <panic>
    panic("virtio disk has no queue 0");
    8000514c:	00002517          	auipc	a0,0x2
    80005150:	5ac50513          	addi	a0,a0,1452 # 800076f8 <etext+0x6f8>
    80005154:	2e3000ef          	jal	80005c36 <panic>
    panic("virtio disk max queue too short");
    80005158:	00002517          	auipc	a0,0x2
    8000515c:	5c050513          	addi	a0,a0,1472 # 80007718 <etext+0x718>
    80005160:	2d7000ef          	jal	80005c36 <panic>
    panic("virtio disk kalloc");
    80005164:	00002517          	auipc	a0,0x2
    80005168:	5d450513          	addi	a0,a0,1492 # 80007738 <etext+0x738>
    8000516c:	2cb000ef          	jal	80005c36 <panic>

0000000080005170 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005170:	711d                	addi	sp,sp,-96
    80005172:	ec86                	sd	ra,88(sp)
    80005174:	e8a2                	sd	s0,80(sp)
    80005176:	e4a6                	sd	s1,72(sp)
    80005178:	e0ca                	sd	s2,64(sp)
    8000517a:	fc4e                	sd	s3,56(sp)
    8000517c:	f852                	sd	s4,48(sp)
    8000517e:	f456                	sd	s5,40(sp)
    80005180:	f05a                	sd	s6,32(sp)
    80005182:	ec5e                	sd	s7,24(sp)
    80005184:	e862                	sd	s8,16(sp)
    80005186:	1080                	addi	s0,sp,96
    80005188:	89aa                	mv	s3,a0
    8000518a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000518c:	00c52b83          	lw	s7,12(a0)
    80005190:	001b9b9b          	slliw	s7,s7,0x1
    80005194:	1b82                	slli	s7,s7,0x20
    80005196:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000519a:	00020517          	auipc	a0,0x20
    8000519e:	bae50513          	addi	a0,a0,-1106 # 80024d48 <disk+0x128>
    800051a2:	557000ef          	jal	80005ef8 <acquire>
  for(int i = 0; i < NUM; i++){
    800051a6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800051a8:	00020a97          	auipc	s5,0x20
    800051ac:	a78a8a93          	addi	s5,s5,-1416 # 80024c20 <disk>
  for(int i = 0; i < 3; i++){
    800051b0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800051b2:	5c7d                	li	s8,-1
    800051b4:	a095                	j	80005218 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800051b6:	00fa8733          	add	a4,s5,a5
    800051ba:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800051be:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800051c0:	0207c563          	bltz	a5,800051ea <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    800051c4:	2905                	addiw	s2,s2,1
    800051c6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800051c8:	05490c63          	beq	s2,s4,80005220 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800051cc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800051ce:	00020717          	auipc	a4,0x20
    800051d2:	a5270713          	addi	a4,a4,-1454 # 80024c20 <disk>
    800051d6:	4781                	li	a5,0
    if(disk.free[i]){
    800051d8:	01874683          	lbu	a3,24(a4)
    800051dc:	fee9                	bnez	a3,800051b6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    800051de:	2785                	addiw	a5,a5,1
    800051e0:	0705                	addi	a4,a4,1
    800051e2:	fe979be3          	bne	a5,s1,800051d8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    800051e6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    800051ea:	01205d63          	blez	s2,80005204 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800051ee:	fa042503          	lw	a0,-96(s0)
    800051f2:	d41ff0ef          	jal	80004f32 <free_desc>
      for(int j = 0; j < i; j++)
    800051f6:	4785                	li	a5,1
    800051f8:	0127d663          	bge	a5,s2,80005204 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    800051fc:	fa442503          	lw	a0,-92(s0)
    80005200:	d33ff0ef          	jal	80004f32 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005204:	00020597          	auipc	a1,0x20
    80005208:	b4458593          	addi	a1,a1,-1212 # 80024d48 <disk+0x128>
    8000520c:	00020517          	auipc	a0,0x20
    80005210:	a2c50513          	addi	a0,a0,-1492 # 80024c38 <disk+0x18>
    80005214:	d2efc0ef          	jal	80001742 <sleep>
  for(int i = 0; i < 3; i++){
    80005218:	fa040613          	addi	a2,s0,-96
    8000521c:	4901                	li	s2,0
    8000521e:	b77d                	j	800051cc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005220:	fa042503          	lw	a0,-96(s0)
    80005224:	00451693          	slli	a3,a0,0x4

  if(write)
    80005228:	00020797          	auipc	a5,0x20
    8000522c:	9f878793          	addi	a5,a5,-1544 # 80024c20 <disk>
    80005230:	00451713          	slli	a4,a0,0x4
    80005234:	0a070713          	addi	a4,a4,160
    80005238:	973e                	add	a4,a4,a5
    8000523a:	01603633          	snez	a2,s6
    8000523e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005240:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005244:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005248:	6398                	ld	a4,0(a5)
    8000524a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000524c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005250:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005252:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005254:	6390                	ld	a2,0(a5)
    80005256:	00d60833          	add	a6,a2,a3
    8000525a:	4741                	li	a4,16
    8000525c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005260:	4585                	li	a1,1
    80005262:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005266:	fa442703          	lw	a4,-92(s0)
    8000526a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000526e:	0712                	slli	a4,a4,0x4
    80005270:	963a                	add	a2,a2,a4
    80005272:	05898813          	addi	a6,s3,88
    80005276:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    8000527a:	0007b883          	ld	a7,0(a5)
    8000527e:	9746                	add	a4,a4,a7
    80005280:	40000613          	li	a2,1024
    80005284:	c710                	sw	a2,8(a4)
  if(write)
    80005286:	001b3613          	seqz	a2,s6
    8000528a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000528e:	8e4d                	or	a2,a2,a1
    80005290:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005294:	fa842603          	lw	a2,-88(s0)
    80005298:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000529c:	00451813          	slli	a6,a0,0x4
    800052a0:	02080813          	addi	a6,a6,32
    800052a4:	983e                	add	a6,a6,a5
    800052a6:	577d                	li	a4,-1
    800052a8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800052ac:	0612                	slli	a2,a2,0x4
    800052ae:	98b2                	add	a7,a7,a2
    800052b0:	03068713          	addi	a4,a3,48
    800052b4:	973e                	add	a4,a4,a5
    800052b6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800052ba:	6398                	ld	a4,0(a5)
    800052bc:	9732                	add	a4,a4,a2
    800052be:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800052c0:	4689                	li	a3,2
    800052c2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800052c6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800052ca:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    800052ce:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800052d2:	6794                	ld	a3,8(a5)
    800052d4:	0026d703          	lhu	a4,2(a3)
    800052d8:	8b1d                	andi	a4,a4,7
    800052da:	0706                	slli	a4,a4,0x1
    800052dc:	96ba                	add	a3,a3,a4
    800052de:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    800052e2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800052e6:	6798                	ld	a4,8(a5)
    800052e8:	00275783          	lhu	a5,2(a4)
    800052ec:	2785                	addiw	a5,a5,1
    800052ee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800052f2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800052f6:	100017b7          	lui	a5,0x10001
    800052fa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800052fe:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005302:	00020917          	auipc	s2,0x20
    80005306:	a4690913          	addi	s2,s2,-1466 # 80024d48 <disk+0x128>
  while(b->disk == 1) {
    8000530a:	84ae                	mv	s1,a1
    8000530c:	00b79a63          	bne	a5,a1,80005320 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005310:	85ca                	mv	a1,s2
    80005312:	854e                	mv	a0,s3
    80005314:	c2efc0ef          	jal	80001742 <sleep>
  while(b->disk == 1) {
    80005318:	0049a783          	lw	a5,4(s3)
    8000531c:	fe978ae3          	beq	a5,s1,80005310 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005320:	fa042903          	lw	s2,-96(s0)
    80005324:	00491713          	slli	a4,s2,0x4
    80005328:	02070713          	addi	a4,a4,32
    8000532c:	00020797          	auipc	a5,0x20
    80005330:	8f478793          	addi	a5,a5,-1804 # 80024c20 <disk>
    80005334:	97ba                	add	a5,a5,a4
    80005336:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000533a:	00020997          	auipc	s3,0x20
    8000533e:	8e698993          	addi	s3,s3,-1818 # 80024c20 <disk>
    80005342:	00491713          	slli	a4,s2,0x4
    80005346:	0009b783          	ld	a5,0(s3)
    8000534a:	97ba                	add	a5,a5,a4
    8000534c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005350:	854a                	mv	a0,s2
    80005352:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005356:	bddff0ef          	jal	80004f32 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000535a:	8885                	andi	s1,s1,1
    8000535c:	f0fd                	bnez	s1,80005342 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000535e:	00020517          	auipc	a0,0x20
    80005362:	9ea50513          	addi	a0,a0,-1558 # 80024d48 <disk+0x128>
    80005366:	427000ef          	jal	80005f8c <release>
}
    8000536a:	60e6                	ld	ra,88(sp)
    8000536c:	6446                	ld	s0,80(sp)
    8000536e:	64a6                	ld	s1,72(sp)
    80005370:	6906                	ld	s2,64(sp)
    80005372:	79e2                	ld	s3,56(sp)
    80005374:	7a42                	ld	s4,48(sp)
    80005376:	7aa2                	ld	s5,40(sp)
    80005378:	7b02                	ld	s6,32(sp)
    8000537a:	6be2                	ld	s7,24(sp)
    8000537c:	6c42                	ld	s8,16(sp)
    8000537e:	6125                	addi	sp,sp,96
    80005380:	8082                	ret

0000000080005382 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005382:	1101                	addi	sp,sp,-32
    80005384:	ec06                	sd	ra,24(sp)
    80005386:	e822                	sd	s0,16(sp)
    80005388:	e426                	sd	s1,8(sp)
    8000538a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000538c:	00020497          	auipc	s1,0x20
    80005390:	89448493          	addi	s1,s1,-1900 # 80024c20 <disk>
    80005394:	00020517          	auipc	a0,0x20
    80005398:	9b450513          	addi	a0,a0,-1612 # 80024d48 <disk+0x128>
    8000539c:	35d000ef          	jal	80005ef8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800053a0:	100017b7          	lui	a5,0x10001
    800053a4:	53bc                	lw	a5,96(a5)
    800053a6:	8b8d                	andi	a5,a5,3
    800053a8:	10001737          	lui	a4,0x10001
    800053ac:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800053ae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800053b2:	689c                	ld	a5,16(s1)
    800053b4:	0204d703          	lhu	a4,32(s1)
    800053b8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800053bc:	04f70863          	beq	a4,a5,8000540c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800053c0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800053c4:	6898                	ld	a4,16(s1)
    800053c6:	0204d783          	lhu	a5,32(s1)
    800053ca:	8b9d                	andi	a5,a5,7
    800053cc:	078e                	slli	a5,a5,0x3
    800053ce:	97ba                	add	a5,a5,a4
    800053d0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800053d2:	00479713          	slli	a4,a5,0x4
    800053d6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    800053da:	9726                	add	a4,a4,s1
    800053dc:	01074703          	lbu	a4,16(a4)
    800053e0:	e329                	bnez	a4,80005422 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    800053e2:	0792                	slli	a5,a5,0x4
    800053e4:	02078793          	addi	a5,a5,32
    800053e8:	97a6                	add	a5,a5,s1
    800053ea:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    800053ec:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800053f0:	b9efc0ef          	jal	8000178e <wakeup>

    disk.used_idx += 1;
    800053f4:	0204d783          	lhu	a5,32(s1)
    800053f8:	2785                	addiw	a5,a5,1
    800053fa:	17c2                	slli	a5,a5,0x30
    800053fc:	93c1                	srli	a5,a5,0x30
    800053fe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005402:	6898                	ld	a4,16(s1)
    80005404:	00275703          	lhu	a4,2(a4)
    80005408:	faf71ce3          	bne	a4,a5,800053c0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000540c:	00020517          	auipc	a0,0x20
    80005410:	93c50513          	addi	a0,a0,-1732 # 80024d48 <disk+0x128>
    80005414:	379000ef          	jal	80005f8c <release>
}
    80005418:	60e2                	ld	ra,24(sp)
    8000541a:	6442                	ld	s0,16(sp)
    8000541c:	64a2                	ld	s1,8(sp)
    8000541e:	6105                	addi	sp,sp,32
    80005420:	8082                	ret
      panic("virtio_disk_intr status");
    80005422:	00002517          	auipc	a0,0x2
    80005426:	32e50513          	addi	a0,a0,814 # 80007750 <etext+0x750>
    8000542a:	00d000ef          	jal	80005c36 <panic>

000000008000542e <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000542e:	1141                	addi	sp,sp,-16
    80005430:	e406                	sd	ra,8(sp)
    80005432:	e022                	sd	s0,0(sp)
    80005434:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005436:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    8000543a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    8000543e:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80005442:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005446:	577d                	li	a4,-1
    80005448:	177e                	slli	a4,a4,0x3f
    8000544a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000544c:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80005450:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80005454:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005458:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    8000545c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80005460:	000f4737          	lui	a4,0xf4
    80005464:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005468:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000546a:	14d79073          	csrw	stimecmp,a5
}
    8000546e:	60a2                	ld	ra,8(sp)
    80005470:	6402                	ld	s0,0(sp)
    80005472:	0141                	addi	sp,sp,16
    80005474:	8082                	ret

0000000080005476 <start>:
{
    80005476:	1141                	addi	sp,sp,-16
    80005478:	e406                	sd	ra,8(sp)
    8000547a:	e022                	sd	s0,0(sp)
    8000547c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000547e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005482:	7779                	lui	a4,0xffffe
    80005484:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd19c7>
    80005488:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000548a:	6705                	lui	a4,0x1
    8000548c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005490:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005492:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005496:	ffffb797          	auipc	a5,0xffffb
    8000549a:	e7e78793          	addi	a5,a5,-386 # 80000314 <main>
    8000549e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800054a2:	4781                	li	a5,0
    800054a4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800054a8:	67c1                	lui	a5,0x10
    800054aa:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800054ac:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800054b0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800054b4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800054b8:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800054bc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800054c0:	57fd                	li	a5,-1
    800054c2:	83a9                	srli	a5,a5,0xa
    800054c4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800054c8:	47bd                	li	a5,15
    800054ca:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800054ce:	f61ff0ef          	jal	8000542e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800054d2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    800054d6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    800054d8:	823e                	mv	tp,a5
  asm volatile("mret");
    800054da:	30200073          	mret
}
    800054de:	60a2                	ld	ra,8(sp)
    800054e0:	6402                	ld	s0,0(sp)
    800054e2:	0141                	addi	sp,sp,16
    800054e4:	8082                	ret

00000000800054e6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    800054e6:	7119                	addi	sp,sp,-128
    800054e8:	fc86                	sd	ra,120(sp)
    800054ea:	f8a2                	sd	s0,112(sp)
    800054ec:	f4a6                	sd	s1,104(sp)
    800054ee:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    800054f0:	06c05b63          	blez	a2,80005566 <consolewrite+0x80>
    800054f4:	f0ca                	sd	s2,96(sp)
    800054f6:	ecce                	sd	s3,88(sp)
    800054f8:	e8d2                	sd	s4,80(sp)
    800054fa:	e4d6                	sd	s5,72(sp)
    800054fc:	e0da                	sd	s6,64(sp)
    800054fe:	fc5e                	sd	s7,56(sp)
    80005500:	f862                	sd	s8,48(sp)
    80005502:	f466                	sd	s9,40(sp)
    80005504:	f06a                	sd	s10,32(sp)
    80005506:	8b2a                	mv	s6,a0
    80005508:	8bae                	mv	s7,a1
    8000550a:	8a32                	mv	s4,a2
  int i = 0;
    8000550c:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    8000550e:	02000c93          	li	s9,32
    80005512:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005516:	f8040a93          	addi	s5,s0,-128
    8000551a:	5c7d                	li	s8,-1
    8000551c:	a025                	j	80005544 <consolewrite+0x5e>
    if(nn > n - i)
    8000551e:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005522:	86ce                	mv	a3,s3
    80005524:	01748633          	add	a2,s1,s7
    80005528:	85da                	mv	a1,s6
    8000552a:	8556                	mv	a0,s5
    8000552c:	dfefc0ef          	jal	80001b2a <either_copyin>
    80005530:	03850d63          	beq	a0,s8,8000556a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80005534:	85ce                	mv	a1,s3
    80005536:	8556                	mv	a0,s5
    80005538:	7b4000ef          	jal	80005cec <uartwrite>
    i += nn;
    8000553c:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005540:	0144d963          	bge	s1,s4,80005552 <consolewrite+0x6c>
    if(nn > n - i)
    80005544:	409a07bb          	subw	a5,s4,s1
    80005548:	893e                	mv	s2,a5
    8000554a:	fcfcdae3          	bge	s9,a5,8000551e <consolewrite+0x38>
    8000554e:	896a                	mv	s2,s10
    80005550:	b7f9                	j	8000551e <consolewrite+0x38>
    80005552:	7906                	ld	s2,96(sp)
    80005554:	69e6                	ld	s3,88(sp)
    80005556:	6a46                	ld	s4,80(sp)
    80005558:	6aa6                	ld	s5,72(sp)
    8000555a:	6b06                	ld	s6,64(sp)
    8000555c:	7be2                	ld	s7,56(sp)
    8000555e:	7c42                	ld	s8,48(sp)
    80005560:	7ca2                	ld	s9,40(sp)
    80005562:	7d02                	ld	s10,32(sp)
    80005564:	a821                	j	8000557c <consolewrite+0x96>
  int i = 0;
    80005566:	4481                	li	s1,0
    80005568:	a811                	j	8000557c <consolewrite+0x96>
    8000556a:	7906                	ld	s2,96(sp)
    8000556c:	69e6                	ld	s3,88(sp)
    8000556e:	6a46                	ld	s4,80(sp)
    80005570:	6aa6                	ld	s5,72(sp)
    80005572:	6b06                	ld	s6,64(sp)
    80005574:	7be2                	ld	s7,56(sp)
    80005576:	7c42                	ld	s8,48(sp)
    80005578:	7ca2                	ld	s9,40(sp)
    8000557a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000557c:	8526                	mv	a0,s1
    8000557e:	70e6                	ld	ra,120(sp)
    80005580:	7446                	ld	s0,112(sp)
    80005582:	74a6                	ld	s1,104(sp)
    80005584:	6109                	addi	sp,sp,128
    80005586:	8082                	ret

0000000080005588 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005588:	711d                	addi	sp,sp,-96
    8000558a:	ec86                	sd	ra,88(sp)
    8000558c:	e8a2                	sd	s0,80(sp)
    8000558e:	e4a6                	sd	s1,72(sp)
    80005590:	e0ca                	sd	s2,64(sp)
    80005592:	fc4e                	sd	s3,56(sp)
    80005594:	f852                	sd	s4,48(sp)
    80005596:	f05a                	sd	s6,32(sp)
    80005598:	ec5e                	sd	s7,24(sp)
    8000559a:	1080                	addi	s0,sp,96
    8000559c:	8b2a                	mv	s6,a0
    8000559e:	8a2e                	mv	s4,a1
    800055a0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800055a2:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    800055a4:	00027517          	auipc	a0,0x27
    800055a8:	7bc50513          	addi	a0,a0,1980 # 8002cd60 <cons>
    800055ac:	14d000ef          	jal	80005ef8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800055b0:	00027497          	auipc	s1,0x27
    800055b4:	7b048493          	addi	s1,s1,1968 # 8002cd60 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800055b8:	00028917          	auipc	s2,0x28
    800055bc:	84090913          	addi	s2,s2,-1984 # 8002cdf8 <cons+0x98>
  while(n > 0){
    800055c0:	0b305b63          	blez	s3,80005676 <consoleread+0xee>
    while(cons.r == cons.w){
    800055c4:	0984a783          	lw	a5,152(s1)
    800055c8:	09c4a703          	lw	a4,156(s1)
    800055cc:	0af71063          	bne	a4,a5,8000566c <consoleread+0xe4>
      if(killed(myproc())){
    800055d0:	b2dfb0ef          	jal	800010fc <myproc>
    800055d4:	beefc0ef          	jal	800019c2 <killed>
    800055d8:	e12d                	bnez	a0,8000563a <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800055da:	85a6                	mv	a1,s1
    800055dc:	854a                	mv	a0,s2
    800055de:	964fc0ef          	jal	80001742 <sleep>
    while(cons.r == cons.w){
    800055e2:	0984a783          	lw	a5,152(s1)
    800055e6:	09c4a703          	lw	a4,156(s1)
    800055ea:	fef703e3          	beq	a4,a5,800055d0 <consoleread+0x48>
    800055ee:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800055f0:	00027717          	auipc	a4,0x27
    800055f4:	77070713          	addi	a4,a4,1904 # 8002cd60 <cons>
    800055f8:	0017869b          	addiw	a3,a5,1
    800055fc:	08d72c23          	sw	a3,152(a4)
    80005600:	07f7f693          	andi	a3,a5,127
    80005604:	9736                	add	a4,a4,a3
    80005606:	01874703          	lbu	a4,24(a4)
    8000560a:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    8000560e:	4691                	li	a3,4
    80005610:	04da8663          	beq	s5,a3,8000565c <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005614:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005618:	4685                	li	a3,1
    8000561a:	faf40613          	addi	a2,s0,-81
    8000561e:	85d2                	mv	a1,s4
    80005620:	855a                	mv	a0,s6
    80005622:	cbefc0ef          	jal	80001ae0 <either_copyout>
    80005626:	57fd                	li	a5,-1
    80005628:	04f50663          	beq	a0,a5,80005674 <consoleread+0xec>
      break;

    dst++;
    8000562c:	0a05                	addi	s4,s4,1
    --n;
    8000562e:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005630:	47a9                	li	a5,10
    80005632:	04fa8b63          	beq	s5,a5,80005688 <consoleread+0x100>
    80005636:	7aa2                	ld	s5,40(sp)
    80005638:	b761                	j	800055c0 <consoleread+0x38>
        release(&cons.lock);
    8000563a:	00027517          	auipc	a0,0x27
    8000563e:	72650513          	addi	a0,a0,1830 # 8002cd60 <cons>
    80005642:	14b000ef          	jal	80005f8c <release>
        return -1;
    80005646:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005648:	60e6                	ld	ra,88(sp)
    8000564a:	6446                	ld	s0,80(sp)
    8000564c:	64a6                	ld	s1,72(sp)
    8000564e:	6906                	ld	s2,64(sp)
    80005650:	79e2                	ld	s3,56(sp)
    80005652:	7a42                	ld	s4,48(sp)
    80005654:	7b02                	ld	s6,32(sp)
    80005656:	6be2                	ld	s7,24(sp)
    80005658:	6125                	addi	sp,sp,96
    8000565a:	8082                	ret
      if(n < target){
    8000565c:	0179fa63          	bgeu	s3,s7,80005670 <consoleread+0xe8>
        cons.r--;
    80005660:	00027717          	auipc	a4,0x27
    80005664:	78f72c23          	sw	a5,1944(a4) # 8002cdf8 <cons+0x98>
    80005668:	7aa2                	ld	s5,40(sp)
    8000566a:	a031                	j	80005676 <consoleread+0xee>
    8000566c:	f456                	sd	s5,40(sp)
    8000566e:	b749                	j	800055f0 <consoleread+0x68>
    80005670:	7aa2                	ld	s5,40(sp)
    80005672:	a011                	j	80005676 <consoleread+0xee>
    80005674:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005676:	00027517          	auipc	a0,0x27
    8000567a:	6ea50513          	addi	a0,a0,1770 # 8002cd60 <cons>
    8000567e:	10f000ef          	jal	80005f8c <release>
  return target - n;
    80005682:	413b853b          	subw	a0,s7,s3
    80005686:	b7c9                	j	80005648 <consoleread+0xc0>
    80005688:	7aa2                	ld	s5,40(sp)
    8000568a:	b7f5                	j	80005676 <consoleread+0xee>

000000008000568c <consputc>:
{
    8000568c:	1141                	addi	sp,sp,-16
    8000568e:	e406                	sd	ra,8(sp)
    80005690:	e022                	sd	s0,0(sp)
    80005692:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005694:	10000793          	li	a5,256
    80005698:	00f50863          	beq	a0,a5,800056a8 <consputc+0x1c>
    uartputc_sync(c);
    8000569c:	6e4000ef          	jal	80005d80 <uartputc_sync>
}
    800056a0:	60a2                	ld	ra,8(sp)
    800056a2:	6402                	ld	s0,0(sp)
    800056a4:	0141                	addi	sp,sp,16
    800056a6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800056a8:	4521                	li	a0,8
    800056aa:	6d6000ef          	jal	80005d80 <uartputc_sync>
    800056ae:	02000513          	li	a0,32
    800056b2:	6ce000ef          	jal	80005d80 <uartputc_sync>
    800056b6:	4521                	li	a0,8
    800056b8:	6c8000ef          	jal	80005d80 <uartputc_sync>
    800056bc:	b7d5                	j	800056a0 <consputc+0x14>

00000000800056be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800056be:	1101                	addi	sp,sp,-32
    800056c0:	ec06                	sd	ra,24(sp)
    800056c2:	e822                	sd	s0,16(sp)
    800056c4:	e426                	sd	s1,8(sp)
    800056c6:	1000                	addi	s0,sp,32
    800056c8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800056ca:	00027517          	auipc	a0,0x27
    800056ce:	69650513          	addi	a0,a0,1686 # 8002cd60 <cons>
    800056d2:	027000ef          	jal	80005ef8 <acquire>

  switch(c){
    800056d6:	47d5                	li	a5,21
    800056d8:	08f48d63          	beq	s1,a5,80005772 <consoleintr+0xb4>
    800056dc:	0297c563          	blt	a5,s1,80005706 <consoleintr+0x48>
    800056e0:	47a1                	li	a5,8
    800056e2:	0ef48263          	beq	s1,a5,800057c6 <consoleintr+0x108>
    800056e6:	47c1                	li	a5,16
    800056e8:	10f49363          	bne	s1,a5,800057ee <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800056ec:	c88fc0ef          	jal	80001b74 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800056f0:	00027517          	auipc	a0,0x27
    800056f4:	67050513          	addi	a0,a0,1648 # 8002cd60 <cons>
    800056f8:	095000ef          	jal	80005f8c <release>
}
    800056fc:	60e2                	ld	ra,24(sp)
    800056fe:	6442                	ld	s0,16(sp)
    80005700:	64a2                	ld	s1,8(sp)
    80005702:	6105                	addi	sp,sp,32
    80005704:	8082                	ret
  switch(c){
    80005706:	07f00793          	li	a5,127
    8000570a:	0af48e63          	beq	s1,a5,800057c6 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000570e:	00027717          	auipc	a4,0x27
    80005712:	65270713          	addi	a4,a4,1618 # 8002cd60 <cons>
    80005716:	0a072783          	lw	a5,160(a4)
    8000571a:	09872703          	lw	a4,152(a4)
    8000571e:	9f99                	subw	a5,a5,a4
    80005720:	07f00713          	li	a4,127
    80005724:	fcf766e3          	bltu	a4,a5,800056f0 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005728:	47b5                	li	a5,13
    8000572a:	0cf48563          	beq	s1,a5,800057f4 <consoleintr+0x136>
      consputc(c);
    8000572e:	8526                	mv	a0,s1
    80005730:	f5dff0ef          	jal	8000568c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005734:	00027717          	auipc	a4,0x27
    80005738:	62c70713          	addi	a4,a4,1580 # 8002cd60 <cons>
    8000573c:	0a072683          	lw	a3,160(a4)
    80005740:	0016879b          	addiw	a5,a3,1
    80005744:	863e                	mv	a2,a5
    80005746:	0af72023          	sw	a5,160(a4)
    8000574a:	07f6f693          	andi	a3,a3,127
    8000574e:	9736                	add	a4,a4,a3
    80005750:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005754:	ff648713          	addi	a4,s1,-10
    80005758:	c371                	beqz	a4,8000581c <consoleintr+0x15e>
    8000575a:	14f1                	addi	s1,s1,-4
    8000575c:	c0e1                	beqz	s1,8000581c <consoleintr+0x15e>
    8000575e:	00027717          	auipc	a4,0x27
    80005762:	69a72703          	lw	a4,1690(a4) # 8002cdf8 <cons+0x98>
    80005766:	9f99                	subw	a5,a5,a4
    80005768:	08000713          	li	a4,128
    8000576c:	f8e792e3          	bne	a5,a4,800056f0 <consoleintr+0x32>
    80005770:	a075                	j	8000581c <consoleintr+0x15e>
    80005772:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005774:	00027717          	auipc	a4,0x27
    80005778:	5ec70713          	addi	a4,a4,1516 # 8002cd60 <cons>
    8000577c:	0a072783          	lw	a5,160(a4)
    80005780:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005784:	00027497          	auipc	s1,0x27
    80005788:	5dc48493          	addi	s1,s1,1500 # 8002cd60 <cons>
    while(cons.e != cons.w &&
    8000578c:	4929                	li	s2,10
    8000578e:	02f70863          	beq	a4,a5,800057be <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005792:	37fd                	addiw	a5,a5,-1
    80005794:	07f7f713          	andi	a4,a5,127
    80005798:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000579a:	01874703          	lbu	a4,24(a4)
    8000579e:	03270263          	beq	a4,s2,800057c2 <consoleintr+0x104>
      cons.e--;
    800057a2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800057a6:	10000513          	li	a0,256
    800057aa:	ee3ff0ef          	jal	8000568c <consputc>
    while(cons.e != cons.w &&
    800057ae:	0a04a783          	lw	a5,160(s1)
    800057b2:	09c4a703          	lw	a4,156(s1)
    800057b6:	fcf71ee3          	bne	a4,a5,80005792 <consoleintr+0xd4>
    800057ba:	6902                	ld	s2,0(sp)
    800057bc:	bf15                	j	800056f0 <consoleintr+0x32>
    800057be:	6902                	ld	s2,0(sp)
    800057c0:	bf05                	j	800056f0 <consoleintr+0x32>
    800057c2:	6902                	ld	s2,0(sp)
    800057c4:	b735                	j	800056f0 <consoleintr+0x32>
    if(cons.e != cons.w){
    800057c6:	00027717          	auipc	a4,0x27
    800057ca:	59a70713          	addi	a4,a4,1434 # 8002cd60 <cons>
    800057ce:	0a072783          	lw	a5,160(a4)
    800057d2:	09c72703          	lw	a4,156(a4)
    800057d6:	f0f70de3          	beq	a4,a5,800056f0 <consoleintr+0x32>
      cons.e--;
    800057da:	37fd                	addiw	a5,a5,-1
    800057dc:	00027717          	auipc	a4,0x27
    800057e0:	62f72223          	sw	a5,1572(a4) # 8002ce00 <cons+0xa0>
      consputc(BACKSPACE);
    800057e4:	10000513          	li	a0,256
    800057e8:	ea5ff0ef          	jal	8000568c <consputc>
    800057ec:	b711                	j	800056f0 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800057ee:	f00481e3          	beqz	s1,800056f0 <consoleintr+0x32>
    800057f2:	bf31                	j	8000570e <consoleintr+0x50>
      consputc(c);
    800057f4:	4529                	li	a0,10
    800057f6:	e97ff0ef          	jal	8000568c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800057fa:	00027797          	auipc	a5,0x27
    800057fe:	56678793          	addi	a5,a5,1382 # 8002cd60 <cons>
    80005802:	0a07a703          	lw	a4,160(a5)
    80005806:	0017069b          	addiw	a3,a4,1
    8000580a:	8636                	mv	a2,a3
    8000580c:	0ad7a023          	sw	a3,160(a5)
    80005810:	07f77713          	andi	a4,a4,127
    80005814:	97ba                	add	a5,a5,a4
    80005816:	4729                	li	a4,10
    80005818:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000581c:	00027797          	auipc	a5,0x27
    80005820:	5ec7a023          	sw	a2,1504(a5) # 8002cdfc <cons+0x9c>
        wakeup(&cons.r);
    80005824:	00027517          	auipc	a0,0x27
    80005828:	5d450513          	addi	a0,a0,1492 # 8002cdf8 <cons+0x98>
    8000582c:	f63fb0ef          	jal	8000178e <wakeup>
    80005830:	b5c1                	j	800056f0 <consoleintr+0x32>

0000000080005832 <consoleinit>:

void
consoleinit(void)
{
    80005832:	1141                	addi	sp,sp,-16
    80005834:	e406                	sd	ra,8(sp)
    80005836:	e022                	sd	s0,0(sp)
    80005838:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000583a:	00002597          	auipc	a1,0x2
    8000583e:	f2e58593          	addi	a1,a1,-210 # 80007768 <etext+0x768>
    80005842:	00027517          	auipc	a0,0x27
    80005846:	51e50513          	addi	a0,a0,1310 # 8002cd60 <cons>
    8000584a:	624000ef          	jal	80005e6e <initlock>

  uartinit();
    8000584e:	448000ef          	jal	80005c96 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005852:	0001e797          	auipc	a5,0x1e
    80005856:	37678793          	addi	a5,a5,886 # 80023bc8 <devsw>
    8000585a:	00000717          	auipc	a4,0x0
    8000585e:	d2e70713          	addi	a4,a4,-722 # 80005588 <consoleread>
    80005862:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005864:	00000717          	auipc	a4,0x0
    80005868:	c8270713          	addi	a4,a4,-894 # 800054e6 <consolewrite>
    8000586c:	ef98                	sd	a4,24(a5)
}
    8000586e:	60a2                	ld	ra,8(sp)
    80005870:	6402                	ld	s0,0(sp)
    80005872:	0141                	addi	sp,sp,16
    80005874:	8082                	ret

0000000080005876 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005876:	7139                	addi	sp,sp,-64
    80005878:	fc06                	sd	ra,56(sp)
    8000587a:	f822                	sd	s0,48(sp)
    8000587c:	f04a                	sd	s2,32(sp)
    8000587e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005880:	c219                	beqz	a2,80005886 <printint+0x10>
    80005882:	08054163          	bltz	a0,80005904 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005886:	4301                	li	t1,0

  i = 0;
    80005888:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000588c:	86ca                	mv	a3,s2
  i = 0;
    8000588e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005890:	00002817          	auipc	a6,0x2
    80005894:	04080813          	addi	a6,a6,64 # 800078d0 <digits>
    80005898:	88ba                	mv	a7,a4
    8000589a:	0017061b          	addiw	a2,a4,1
    8000589e:	8732                	mv	a4,a2
    800058a0:	02b577b3          	remu	a5,a0,a1
    800058a4:	97c2                	add	a5,a5,a6
    800058a6:	0007c783          	lbu	a5,0(a5)
    800058aa:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800058ae:	87aa                	mv	a5,a0
    800058b0:	02b55533          	divu	a0,a0,a1
    800058b4:	0685                	addi	a3,a3,1
    800058b6:	feb7f1e3          	bgeu	a5,a1,80005898 <printint+0x22>

  if(sign)
    800058ba:	00030c63          	beqz	t1,800058d2 <printint+0x5c>
    buf[i++] = '-';
    800058be:	fe060793          	addi	a5,a2,-32
    800058c2:	00878633          	add	a2,a5,s0
    800058c6:	02d00793          	li	a5,45
    800058ca:	fef60423          	sb	a5,-24(a2)
    800058ce:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800058d2:	02e05463          	blez	a4,800058fa <printint+0x84>
    800058d6:	f426                	sd	s1,40(sp)
    800058d8:	377d                	addiw	a4,a4,-1
    800058da:	00e904b3          	add	s1,s2,a4
    800058de:	197d                	addi	s2,s2,-1
    800058e0:	993a                	add	s2,s2,a4
    800058e2:	1702                	slli	a4,a4,0x20
    800058e4:	9301                	srli	a4,a4,0x20
    800058e6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800058ea:	0004c503          	lbu	a0,0(s1)
    800058ee:	d9fff0ef          	jal	8000568c <consputc>
  while(--i >= 0)
    800058f2:	14fd                	addi	s1,s1,-1
    800058f4:	ff249be3          	bne	s1,s2,800058ea <printint+0x74>
    800058f8:	74a2                	ld	s1,40(sp)
}
    800058fa:	70e2                	ld	ra,56(sp)
    800058fc:	7442                	ld	s0,48(sp)
    800058fe:	7902                	ld	s2,32(sp)
    80005900:	6121                	addi	sp,sp,64
    80005902:	8082                	ret
    x = -xx;
    80005904:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005908:	4305                	li	t1,1
    x = -xx;
    8000590a:	bfbd                	j	80005888 <printint+0x12>

000000008000590c <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000590c:	7131                	addi	sp,sp,-192
    8000590e:	fc86                	sd	ra,120(sp)
    80005910:	f8a2                	sd	s0,112(sp)
    80005912:	f0ca                	sd	s2,96(sp)
    80005914:	0100                	addi	s0,sp,128
    80005916:	892a                	mv	s2,a0
    80005918:	e40c                	sd	a1,8(s0)
    8000591a:	e810                	sd	a2,16(s0)
    8000591c:	ec14                	sd	a3,24(s0)
    8000591e:	f018                	sd	a4,32(s0)
    80005920:	f41c                	sd	a5,40(s0)
    80005922:	03043823          	sd	a6,48(s0)
    80005926:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    8000592a:	00002797          	auipc	a5,0x2
    8000592e:	ff67a783          	lw	a5,-10(a5) # 80007920 <panicking>
    80005932:	cf9d                	beqz	a5,80005970 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005934:	00840793          	addi	a5,s0,8
    80005938:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000593c:	00094503          	lbu	a0,0(s2)
    80005940:	22050663          	beqz	a0,80005b6c <printf+0x260>
    80005944:	f4a6                	sd	s1,104(sp)
    80005946:	ecce                	sd	s3,88(sp)
    80005948:	e8d2                	sd	s4,80(sp)
    8000594a:	e4d6                	sd	s5,72(sp)
    8000594c:	e0da                	sd	s6,64(sp)
    8000594e:	fc5e                	sd	s7,56(sp)
    80005950:	f862                	sd	s8,48(sp)
    80005952:	f06a                	sd	s10,32(sp)
    80005954:	ec6e                	sd	s11,24(sp)
    80005956:	4a01                	li	s4,0
    if(cx != '%'){
    80005958:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000595c:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005960:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005964:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80005968:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000596a:	06400b93          	li	s7,100
    8000596e:	a015                	j	80005992 <printf+0x86>
    acquire(&pr.lock);
    80005970:	00027517          	auipc	a0,0x27
    80005974:	49850513          	addi	a0,a0,1176 # 8002ce08 <pr>
    80005978:	580000ef          	jal	80005ef8 <acquire>
    8000597c:	bf65                	j	80005934 <printf+0x28>
      consputc(cx);
    8000597e:	d0fff0ef          	jal	8000568c <consputc>
      continue;
    80005982:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005984:	2485                	addiw	s1,s1,1
    80005986:	8a26                	mv	s4,s1
    80005988:	94ca                	add	s1,s1,s2
    8000598a:	0004c503          	lbu	a0,0(s1)
    8000598e:	1c050663          	beqz	a0,80005b5a <printf+0x24e>
    if(cx != '%'){
    80005992:	ff3516e3          	bne	a0,s3,8000597e <printf+0x72>
    i++;
    80005996:	001a079b          	addiw	a5,s4,1
    8000599a:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000599c:	00f90733          	add	a4,s2,a5
    800059a0:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800059a4:	200a8963          	beqz	s5,80005bb6 <printf+0x2aa>
    800059a8:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    800059ac:	1e068c63          	beqz	a3,80005ba4 <printf+0x298>
    if(c0 == 'd'){
    800059b0:	037a8863          	beq	s5,s7,800059e0 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800059b4:	f94a8713          	addi	a4,s5,-108
    800059b8:	00173713          	seqz	a4,a4
    800059bc:	f9c68613          	addi	a2,a3,-100
    800059c0:	ee05                	bnez	a2,800059f8 <printf+0xec>
    800059c2:	cb1d                	beqz	a4,800059f8 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800059c4:	f8843783          	ld	a5,-120(s0)
    800059c8:	00878713          	addi	a4,a5,8
    800059cc:	f8e43423          	sd	a4,-120(s0)
    800059d0:	4605                	li	a2,1
    800059d2:	85da                	mv	a1,s6
    800059d4:	6388                	ld	a0,0(a5)
    800059d6:	ea1ff0ef          	jal	80005876 <printint>
      i += 1;
    800059da:	002a049b          	addiw	s1,s4,2
    800059de:	b75d                	j	80005984 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800059e0:	f8843783          	ld	a5,-120(s0)
    800059e4:	00878713          	addi	a4,a5,8
    800059e8:	f8e43423          	sd	a4,-120(s0)
    800059ec:	4605                	li	a2,1
    800059ee:	85da                	mv	a1,s6
    800059f0:	4388                	lw	a0,0(a5)
    800059f2:	e85ff0ef          	jal	80005876 <printint>
    800059f6:	b779                	j	80005984 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800059f8:	97ca                	add	a5,a5,s2
    800059fa:	8636                	mv	a2,a3
    800059fc:	0027c683          	lbu	a3,2(a5)
    80005a00:	a2c9                	j	80005bc2 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005a02:	f8843783          	ld	a5,-120(s0)
    80005a06:	00878713          	addi	a4,a5,8
    80005a0a:	f8e43423          	sd	a4,-120(s0)
    80005a0e:	4605                	li	a2,1
    80005a10:	45a9                	li	a1,10
    80005a12:	6388                	ld	a0,0(a5)
    80005a14:	e63ff0ef          	jal	80005876 <printint>
      i += 2;
    80005a18:	003a049b          	addiw	s1,s4,3
    80005a1c:	b7a5                	j	80005984 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    80005a1e:	f8843783          	ld	a5,-120(s0)
    80005a22:	00878713          	addi	a4,a5,8
    80005a26:	f8e43423          	sd	a4,-120(s0)
    80005a2a:	4601                	li	a2,0
    80005a2c:	85da                	mv	a1,s6
    80005a2e:	0007e503          	lwu	a0,0(a5)
    80005a32:	e45ff0ef          	jal	80005876 <printint>
    80005a36:	b7b9                	j	80005984 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005a38:	f8843783          	ld	a5,-120(s0)
    80005a3c:	00878713          	addi	a4,a5,8
    80005a40:	f8e43423          	sd	a4,-120(s0)
    80005a44:	4601                	li	a2,0
    80005a46:	85da                	mv	a1,s6
    80005a48:	6388                	ld	a0,0(a5)
    80005a4a:	e2dff0ef          	jal	80005876 <printint>
      i += 1;
    80005a4e:	002a049b          	addiw	s1,s4,2
    80005a52:	bf0d                	j	80005984 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005a54:	f8843783          	ld	a5,-120(s0)
    80005a58:	00878713          	addi	a4,a5,8
    80005a5c:	f8e43423          	sd	a4,-120(s0)
    80005a60:	4601                	li	a2,0
    80005a62:	45a9                	li	a1,10
    80005a64:	6388                	ld	a0,0(a5)
    80005a66:	e11ff0ef          	jal	80005876 <printint>
      i += 2;
    80005a6a:	003a049b          	addiw	s1,s4,3
    80005a6e:	bf19                	j	80005984 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005a70:	f8843783          	ld	a5,-120(s0)
    80005a74:	00878713          	addi	a4,a5,8
    80005a78:	f8e43423          	sd	a4,-120(s0)
    80005a7c:	4601                	li	a2,0
    80005a7e:	45c1                	li	a1,16
    80005a80:	0007e503          	lwu	a0,0(a5)
    80005a84:	df3ff0ef          	jal	80005876 <printint>
    80005a88:	bdf5                	j	80005984 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005a8a:	f8843783          	ld	a5,-120(s0)
    80005a8e:	00878713          	addi	a4,a5,8
    80005a92:	f8e43423          	sd	a4,-120(s0)
    80005a96:	45c1                	li	a1,16
    80005a98:	6388                	ld	a0,0(a5)
    80005a9a:	dddff0ef          	jal	80005876 <printint>
      i += 1;
    80005a9e:	002a049b          	addiw	s1,s4,2
    80005aa2:	b5cd                	j	80005984 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005aa4:	f8843783          	ld	a5,-120(s0)
    80005aa8:	00878713          	addi	a4,a5,8
    80005aac:	f8e43423          	sd	a4,-120(s0)
    80005ab0:	4601                	li	a2,0
    80005ab2:	45c1                	li	a1,16
    80005ab4:	6388                	ld	a0,0(a5)
    80005ab6:	dc1ff0ef          	jal	80005876 <printint>
      i += 2;
    80005aba:	003a049b          	addiw	s1,s4,3
    80005abe:	b5d9                	j	80005984 <printf+0x78>
    80005ac0:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    80005ac2:	f8843783          	ld	a5,-120(s0)
    80005ac6:	00878713          	addi	a4,a5,8
    80005aca:	f8e43423          	sd	a4,-120(s0)
    80005ace:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80005ad2:	03000513          	li	a0,48
    80005ad6:	bb7ff0ef          	jal	8000568c <consputc>
  consputc('x');
    80005ada:	07800513          	li	a0,120
    80005ade:	bafff0ef          	jal	8000568c <consputc>
    80005ae2:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005ae4:	00002c97          	auipc	s9,0x2
    80005ae8:	decc8c93          	addi	s9,s9,-532 # 800078d0 <digits>
    80005aec:	03cad793          	srli	a5,s5,0x3c
    80005af0:	97e6                	add	a5,a5,s9
    80005af2:	0007c503          	lbu	a0,0(a5)
    80005af6:	b97ff0ef          	jal	8000568c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005afa:	0a92                	slli	s5,s5,0x4
    80005afc:	3a7d                	addiw	s4,s4,-1
    80005afe:	fe0a17e3          	bnez	s4,80005aec <printf+0x1e0>
    80005b02:	7ca2                	ld	s9,40(sp)
    80005b04:	b541                	j	80005984 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80005b06:	f8843783          	ld	a5,-120(s0)
    80005b0a:	00878713          	addi	a4,a5,8
    80005b0e:	f8e43423          	sd	a4,-120(s0)
    80005b12:	4388                	lw	a0,0(a5)
    80005b14:	b79ff0ef          	jal	8000568c <consputc>
    80005b18:	b5b5                	j	80005984 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80005b1a:	f8843783          	ld	a5,-120(s0)
    80005b1e:	00878713          	addi	a4,a5,8
    80005b22:	f8e43423          	sd	a4,-120(s0)
    80005b26:	0007ba03          	ld	s4,0(a5)
    80005b2a:	000a0d63          	beqz	s4,80005b44 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    80005b2e:	000a4503          	lbu	a0,0(s4)
    80005b32:	e40509e3          	beqz	a0,80005984 <printf+0x78>
        consputc(*s);
    80005b36:	b57ff0ef          	jal	8000568c <consputc>
      for(; *s; s++)
    80005b3a:	0a05                	addi	s4,s4,1
    80005b3c:	000a4503          	lbu	a0,0(s4)
    80005b40:	f97d                	bnez	a0,80005b36 <printf+0x22a>
    80005b42:	b589                	j	80005984 <printf+0x78>
        s = "(null)";
    80005b44:	00002a17          	auipc	s4,0x2
    80005b48:	c2ca0a13          	addi	s4,s4,-980 # 80007770 <etext+0x770>
      for(; *s; s++)
    80005b4c:	02800513          	li	a0,40
    80005b50:	b7dd                	j	80005b36 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005b52:	8556                	mv	a0,s5
    80005b54:	b39ff0ef          	jal	8000568c <consputc>
    80005b58:	b535                	j	80005984 <printf+0x78>
    80005b5a:	74a6                	ld	s1,104(sp)
    80005b5c:	69e6                	ld	s3,88(sp)
    80005b5e:	6a46                	ld	s4,80(sp)
    80005b60:	6aa6                	ld	s5,72(sp)
    80005b62:	6b06                	ld	s6,64(sp)
    80005b64:	7be2                	ld	s7,56(sp)
    80005b66:	7c42                	ld	s8,48(sp)
    80005b68:	7d02                	ld	s10,32(sp)
    80005b6a:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    80005b6c:	00002797          	auipc	a5,0x2
    80005b70:	db47a783          	lw	a5,-588(a5) # 80007920 <panicking>
    80005b74:	c38d                	beqz	a5,80005b96 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80005b76:	4501                	li	a0,0
    80005b78:	70e6                	ld	ra,120(sp)
    80005b7a:	7446                	ld	s0,112(sp)
    80005b7c:	7906                	ld	s2,96(sp)
    80005b7e:	6129                	addi	sp,sp,192
    80005b80:	8082                	ret
    80005b82:	74a6                	ld	s1,104(sp)
    80005b84:	69e6                	ld	s3,88(sp)
    80005b86:	6a46                	ld	s4,80(sp)
    80005b88:	6aa6                	ld	s5,72(sp)
    80005b8a:	6b06                	ld	s6,64(sp)
    80005b8c:	7be2                	ld	s7,56(sp)
    80005b8e:	7c42                	ld	s8,48(sp)
    80005b90:	7d02                	ld	s10,32(sp)
    80005b92:	6de2                	ld	s11,24(sp)
    80005b94:	bfe1                	j	80005b6c <printf+0x260>
    release(&pr.lock);
    80005b96:	00027517          	auipc	a0,0x27
    80005b9a:	27250513          	addi	a0,a0,626 # 8002ce08 <pr>
    80005b9e:	3ee000ef          	jal	80005f8c <release>
  return 0;
    80005ba2:	bfd1                	j	80005b76 <printf+0x26a>
    if(c0 == 'd'){
    80005ba4:	e37a8ee3          	beq	s5,s7,800059e0 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005ba8:	f94a8713          	addi	a4,s5,-108
    80005bac:	00173713          	seqz	a4,a4
    80005bb0:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005bb2:	4781                	li	a5,0
    80005bb4:	a00d                	j	80005bd6 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    80005bb6:	f94a8713          	addi	a4,s5,-108
    80005bba:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    80005bbe:	8656                	mv	a2,s5
    80005bc0:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005bc2:	f9460793          	addi	a5,a2,-108
    80005bc6:	0017b793          	seqz	a5,a5
    80005bca:	8ff9                	and	a5,a5,a4
    80005bcc:	f9c68593          	addi	a1,a3,-100
    80005bd0:	e199                	bnez	a1,80005bd6 <printf+0x2ca>
    80005bd2:	e20798e3          	bnez	a5,80005a02 <printf+0xf6>
    } else if(c0 == 'u'){
    80005bd6:	e58a84e3          	beq	s5,s8,80005a1e <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    80005bda:	f8b60593          	addi	a1,a2,-117
    80005bde:	e199                	bnez	a1,80005be4 <printf+0x2d8>
    80005be0:	e4071ce3          	bnez	a4,80005a38 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005be4:	f8b68593          	addi	a1,a3,-117
    80005be8:	e199                	bnez	a1,80005bee <printf+0x2e2>
    80005bea:	e60795e3          	bnez	a5,80005a54 <printf+0x148>
    } else if(c0 == 'x'){
    80005bee:	e9aa81e3          	beq	s5,s10,80005a70 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    80005bf2:	f8860613          	addi	a2,a2,-120
    80005bf6:	e219                	bnez	a2,80005bfc <printf+0x2f0>
    80005bf8:	e80719e3          	bnez	a4,80005a8a <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005bfc:	f8868693          	addi	a3,a3,-120
    80005c00:	e299                	bnez	a3,80005c06 <printf+0x2fa>
    80005c02:	ea0791e3          	bnez	a5,80005aa4 <printf+0x198>
    } else if(c0 == 'p'){
    80005c06:	ebba8de3          	beq	s5,s11,80005ac0 <printf+0x1b4>
    } else if(c0 == 'c'){
    80005c0a:	06300793          	li	a5,99
    80005c0e:	eefa8ce3          	beq	s5,a5,80005b06 <printf+0x1fa>
    } else if(c0 == 's'){
    80005c12:	07300793          	li	a5,115
    80005c16:	f0fa82e3          	beq	s5,a5,80005b1a <printf+0x20e>
    } else if(c0 == '%'){
    80005c1a:	02500793          	li	a5,37
    80005c1e:	f2fa8ae3          	beq	s5,a5,80005b52 <printf+0x246>
    } else if(c0 == 0){
    80005c22:	f60a80e3          	beqz	s5,80005b82 <printf+0x276>
      consputc('%');
    80005c26:	02500513          	li	a0,37
    80005c2a:	a63ff0ef          	jal	8000568c <consputc>
      consputc(c0);
    80005c2e:	8556                	mv	a0,s5
    80005c30:	a5dff0ef          	jal	8000568c <consputc>
    80005c34:	bb81                	j	80005984 <printf+0x78>

0000000080005c36 <panic>:

void
panic(char *s)
{
    80005c36:	1101                	addi	sp,sp,-32
    80005c38:	ec06                	sd	ra,24(sp)
    80005c3a:	e822                	sd	s0,16(sp)
    80005c3c:	e426                	sd	s1,8(sp)
    80005c3e:	e04a                	sd	s2,0(sp)
    80005c40:	1000                	addi	s0,sp,32
    80005c42:	892a                	mv	s2,a0
  panicking = 1;
    80005c44:	4485                	li	s1,1
    80005c46:	00002797          	auipc	a5,0x2
    80005c4a:	cc97ad23          	sw	s1,-806(a5) # 80007920 <panicking>
  printf("panic: ");
    80005c4e:	00002517          	auipc	a0,0x2
    80005c52:	b2a50513          	addi	a0,a0,-1238 # 80007778 <etext+0x778>
    80005c56:	cb7ff0ef          	jal	8000590c <printf>
  printf("%s\n", s);
    80005c5a:	85ca                	mv	a1,s2
    80005c5c:	00002517          	auipc	a0,0x2
    80005c60:	b2450513          	addi	a0,a0,-1244 # 80007780 <etext+0x780>
    80005c64:	ca9ff0ef          	jal	8000590c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c68:	00002797          	auipc	a5,0x2
    80005c6c:	ca97aa23          	sw	s1,-844(a5) # 8000791c <panicked>
  for(;;)
    80005c70:	a001                	j	80005c70 <panic+0x3a>

0000000080005c72 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005c72:	1141                	addi	sp,sp,-16
    80005c74:	e406                	sd	ra,8(sp)
    80005c76:	e022                	sd	s0,0(sp)
    80005c78:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005c7a:	00002597          	auipc	a1,0x2
    80005c7e:	b0e58593          	addi	a1,a1,-1266 # 80007788 <etext+0x788>
    80005c82:	00027517          	auipc	a0,0x27
    80005c86:	18650513          	addi	a0,a0,390 # 8002ce08 <pr>
    80005c8a:	1e4000ef          	jal	80005e6e <initlock>
}
    80005c8e:	60a2                	ld	ra,8(sp)
    80005c90:	6402                	ld	s0,0(sp)
    80005c92:	0141                	addi	sp,sp,16
    80005c94:	8082                	ret

0000000080005c96 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005c96:	1141                	addi	sp,sp,-16
    80005c98:	e406                	sd	ra,8(sp)
    80005c9a:	e022                	sd	s0,0(sp)
    80005c9c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005c9e:	100007b7          	lui	a5,0x10000
    80005ca2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005ca6:	10000737          	lui	a4,0x10000
    80005caa:	f8000693          	li	a3,-128
    80005cae:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005cb2:	468d                	li	a3,3
    80005cb4:	10000637          	lui	a2,0x10000
    80005cb8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005cbc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005cc0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005cc4:	8732                	mv	a4,a2
    80005cc6:	461d                	li	a2,7
    80005cc8:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005ccc:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005cd0:	00002597          	auipc	a1,0x2
    80005cd4:	ac058593          	addi	a1,a1,-1344 # 80007790 <etext+0x790>
    80005cd8:	00027517          	auipc	a0,0x27
    80005cdc:	14850513          	addi	a0,a0,328 # 8002ce20 <tx_lock>
    80005ce0:	18e000ef          	jal	80005e6e <initlock>
}
    80005ce4:	60a2                	ld	ra,8(sp)
    80005ce6:	6402                	ld	s0,0(sp)
    80005ce8:	0141                	addi	sp,sp,16
    80005cea:	8082                	ret

0000000080005cec <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005cec:	715d                	addi	sp,sp,-80
    80005cee:	e486                	sd	ra,72(sp)
    80005cf0:	e0a2                	sd	s0,64(sp)
    80005cf2:	fc26                	sd	s1,56(sp)
    80005cf4:	ec56                	sd	s5,24(sp)
    80005cf6:	0880                	addi	s0,sp,80
    80005cf8:	8aaa                	mv	s5,a0
    80005cfa:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005cfc:	00027517          	auipc	a0,0x27
    80005d00:	12450513          	addi	a0,a0,292 # 8002ce20 <tx_lock>
    80005d04:	1f4000ef          	jal	80005ef8 <acquire>

  int i = 0;
  while(i < n){ 
    80005d08:	06905063          	blez	s1,80005d68 <uartwrite+0x7c>
    80005d0c:	f84a                	sd	s2,48(sp)
    80005d0e:	f44e                	sd	s3,40(sp)
    80005d10:	f052                	sd	s4,32(sp)
    80005d12:	e85a                	sd	s6,16(sp)
    80005d14:	e45e                	sd	s7,8(sp)
    80005d16:	8a56                	mv	s4,s5
    80005d18:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005d1a:	00002497          	auipc	s1,0x2
    80005d1e:	c0e48493          	addi	s1,s1,-1010 # 80007928 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005d22:	00027997          	auipc	s3,0x27
    80005d26:	0fe98993          	addi	s3,s3,254 # 8002ce20 <tx_lock>
    80005d2a:	00002917          	auipc	s2,0x2
    80005d2e:	bfa90913          	addi	s2,s2,-1030 # 80007924 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005d32:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005d36:	4b05                	li	s6,1
    80005d38:	a005                	j	80005d58 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005d3a:	85ce                	mv	a1,s3
    80005d3c:	854a                	mv	a0,s2
    80005d3e:	a05fb0ef          	jal	80001742 <sleep>
    while(tx_busy != 0){
    80005d42:	409c                	lw	a5,0(s1)
    80005d44:	fbfd                	bnez	a5,80005d3a <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005d46:	000a4783          	lbu	a5,0(s4)
    80005d4a:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005d4e:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005d52:	0a05                	addi	s4,s4,1
    80005d54:	015a0563          	beq	s4,s5,80005d5e <uartwrite+0x72>
    while(tx_busy != 0){
    80005d58:	409c                	lw	a5,0(s1)
    80005d5a:	f3e5                	bnez	a5,80005d3a <uartwrite+0x4e>
    80005d5c:	b7ed                	j	80005d46 <uartwrite+0x5a>
    80005d5e:	7942                	ld	s2,48(sp)
    80005d60:	79a2                	ld	s3,40(sp)
    80005d62:	7a02                	ld	s4,32(sp)
    80005d64:	6b42                	ld	s6,16(sp)
    80005d66:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005d68:	00027517          	auipc	a0,0x27
    80005d6c:	0b850513          	addi	a0,a0,184 # 8002ce20 <tx_lock>
    80005d70:	21c000ef          	jal	80005f8c <release>
}
    80005d74:	60a6                	ld	ra,72(sp)
    80005d76:	6406                	ld	s0,64(sp)
    80005d78:	74e2                	ld	s1,56(sp)
    80005d7a:	6ae2                	ld	s5,24(sp)
    80005d7c:	6161                	addi	sp,sp,80
    80005d7e:	8082                	ret

0000000080005d80 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005d80:	1101                	addi	sp,sp,-32
    80005d82:	ec06                	sd	ra,24(sp)
    80005d84:	e822                	sd	s0,16(sp)
    80005d86:	e426                	sd	s1,8(sp)
    80005d88:	1000                	addi	s0,sp,32
    80005d8a:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005d8c:	00002797          	auipc	a5,0x2
    80005d90:	b947a783          	lw	a5,-1132(a5) # 80007920 <panicking>
    80005d94:	cf95                	beqz	a5,80005dd0 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005d96:	00002797          	auipc	a5,0x2
    80005d9a:	b867a783          	lw	a5,-1146(a5) # 8000791c <panicked>
    80005d9e:	ef85                	bnez	a5,80005dd6 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005da0:	10000737          	lui	a4,0x10000
    80005da4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005da6:	00074783          	lbu	a5,0(a4)
    80005daa:	0207f793          	andi	a5,a5,32
    80005dae:	dfe5                	beqz	a5,80005da6 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005db0:	0ff4f513          	zext.b	a0,s1
    80005db4:	100007b7          	lui	a5,0x10000
    80005db8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005dbc:	00002797          	auipc	a5,0x2
    80005dc0:	b647a783          	lw	a5,-1180(a5) # 80007920 <panicking>
    80005dc4:	cb91                	beqz	a5,80005dd8 <uartputc_sync+0x58>
    pop_off();
}
    80005dc6:	60e2                	ld	ra,24(sp)
    80005dc8:	6442                	ld	s0,16(sp)
    80005dca:	64a2                	ld	s1,8(sp)
    80005dcc:	6105                	addi	sp,sp,32
    80005dce:	8082                	ret
    push_off();
    80005dd0:	0e4000ef          	jal	80005eb4 <push_off>
    80005dd4:	b7c9                	j	80005d96 <uartputc_sync+0x16>
    for(;;)
    80005dd6:	a001                	j	80005dd6 <uartputc_sync+0x56>
    pop_off();
    80005dd8:	164000ef          	jal	80005f3c <pop_off>
}
    80005ddc:	b7ed                	j	80005dc6 <uartputc_sync+0x46>

0000000080005dde <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005dde:	1141                	addi	sp,sp,-16
    80005de0:	e406                	sd	ra,8(sp)
    80005de2:	e022                	sd	s0,0(sp)
    80005de4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005de6:	100007b7          	lui	a5,0x10000
    80005dea:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005dee:	8b85                	andi	a5,a5,1
    80005df0:	cb89                	beqz	a5,80005e02 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005df2:	100007b7          	lui	a5,0x10000
    80005df6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005dfa:	60a2                	ld	ra,8(sp)
    80005dfc:	6402                	ld	s0,0(sp)
    80005dfe:	0141                	addi	sp,sp,16
    80005e00:	8082                	ret
    return -1;
    80005e02:	557d                	li	a0,-1
    80005e04:	bfdd                	j	80005dfa <uartgetc+0x1c>

0000000080005e06 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005e06:	1101                	addi	sp,sp,-32
    80005e08:	ec06                	sd	ra,24(sp)
    80005e0a:	e822                	sd	s0,16(sp)
    80005e0c:	e426                	sd	s1,8(sp)
    80005e0e:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005e10:	100007b7          	lui	a5,0x10000
    80005e14:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005e18:	00027517          	auipc	a0,0x27
    80005e1c:	00850513          	addi	a0,a0,8 # 8002ce20 <tx_lock>
    80005e20:	0d8000ef          	jal	80005ef8 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005e24:	100007b7          	lui	a5,0x10000
    80005e28:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005e2c:	0207f793          	andi	a5,a5,32
    80005e30:	ef99                	bnez	a5,80005e4e <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005e32:	00027517          	auipc	a0,0x27
    80005e36:	fee50513          	addi	a0,a0,-18 # 8002ce20 <tx_lock>
    80005e3a:	152000ef          	jal	80005f8c <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005e3e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005e40:	f9fff0ef          	jal	80005dde <uartgetc>
    if(c == -1)
    80005e44:	02950063          	beq	a0,s1,80005e64 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005e48:	877ff0ef          	jal	800056be <consoleintr>
  while(1){
    80005e4c:	bfd5                	j	80005e40 <uartintr+0x3a>
    tx_busy = 0;
    80005e4e:	00002797          	auipc	a5,0x2
    80005e52:	ac07ad23          	sw	zero,-1318(a5) # 80007928 <tx_busy>
    wakeup(&tx_chan);
    80005e56:	00002517          	auipc	a0,0x2
    80005e5a:	ace50513          	addi	a0,a0,-1330 # 80007924 <tx_chan>
    80005e5e:	931fb0ef          	jal	8000178e <wakeup>
    80005e62:	bfc1                	j	80005e32 <uartintr+0x2c>
  }
}
    80005e64:	60e2                	ld	ra,24(sp)
    80005e66:	6442                	ld	s0,16(sp)
    80005e68:	64a2                	ld	s1,8(sp)
    80005e6a:	6105                	addi	sp,sp,32
    80005e6c:	8082                	ret

0000000080005e6e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005e6e:	1141                	addi	sp,sp,-16
    80005e70:	e406                	sd	ra,8(sp)
    80005e72:	e022                	sd	s0,0(sp)
    80005e74:	0800                	addi	s0,sp,16
  lk->name = name;
    80005e76:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005e78:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005e7c:	00053823          	sd	zero,16(a0)
}
    80005e80:	60a2                	ld	ra,8(sp)
    80005e82:	6402                	ld	s0,0(sp)
    80005e84:	0141                	addi	sp,sp,16
    80005e86:	8082                	ret

0000000080005e88 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005e88:	411c                	lw	a5,0(a0)
    80005e8a:	e399                	bnez	a5,80005e90 <holding+0x8>
    80005e8c:	4501                	li	a0,0
  return r;
}
    80005e8e:	8082                	ret
{
    80005e90:	1101                	addi	sp,sp,-32
    80005e92:	ec06                	sd	ra,24(sp)
    80005e94:	e822                	sd	s0,16(sp)
    80005e96:	e426                	sd	s1,8(sp)
    80005e98:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005e9a:	691c                	ld	a5,16(a0)
    80005e9c:	84be                	mv	s1,a5
    80005e9e:	a3efb0ef          	jal	800010dc <mycpu>
    80005ea2:	40a48533          	sub	a0,s1,a0
    80005ea6:	00153513          	seqz	a0,a0
}
    80005eaa:	60e2                	ld	ra,24(sp)
    80005eac:	6442                	ld	s0,16(sp)
    80005eae:	64a2                	ld	s1,8(sp)
    80005eb0:	6105                	addi	sp,sp,32
    80005eb2:	8082                	ret

0000000080005eb4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005eb4:	1101                	addi	sp,sp,-32
    80005eb6:	ec06                	sd	ra,24(sp)
    80005eb8:	e822                	sd	s0,16(sp)
    80005eba:	e426                	sd	s1,8(sp)
    80005ebc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005ebe:	100027f3          	csrr	a5,sstatus
    80005ec2:	84be                	mv	s1,a5
    80005ec4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005ec8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005eca:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005ece:	a0efb0ef          	jal	800010dc <mycpu>
    80005ed2:	5d3c                	lw	a5,120(a0)
    80005ed4:	cb99                	beqz	a5,80005eea <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005ed6:	a06fb0ef          	jal	800010dc <mycpu>
    80005eda:	5d3c                	lw	a5,120(a0)
    80005edc:	2785                	addiw	a5,a5,1
    80005ede:	dd3c                	sw	a5,120(a0)
}
    80005ee0:	60e2                	ld	ra,24(sp)
    80005ee2:	6442                	ld	s0,16(sp)
    80005ee4:	64a2                	ld	s1,8(sp)
    80005ee6:	6105                	addi	sp,sp,32
    80005ee8:	8082                	ret
    mycpu()->intena = old;
    80005eea:	9f2fb0ef          	jal	800010dc <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005eee:	0014d793          	srli	a5,s1,0x1
    80005ef2:	8b85                	andi	a5,a5,1
    80005ef4:	dd7c                	sw	a5,124(a0)
    80005ef6:	b7c5                	j	80005ed6 <push_off+0x22>

0000000080005ef8 <acquire>:
{
    80005ef8:	1101                	addi	sp,sp,-32
    80005efa:	ec06                	sd	ra,24(sp)
    80005efc:	e822                	sd	s0,16(sp)
    80005efe:	e426                	sd	s1,8(sp)
    80005f00:	1000                	addi	s0,sp,32
    80005f02:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005f04:	fb1ff0ef          	jal	80005eb4 <push_off>
  if(holding(lk))
    80005f08:	8526                	mv	a0,s1
    80005f0a:	f7fff0ef          	jal	80005e88 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005f0e:	4705                	li	a4,1
  if(holding(lk))
    80005f10:	e105                	bnez	a0,80005f30 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005f12:	87ba                	mv	a5,a4
    80005f14:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005f18:	2781                	sext.w	a5,a5
    80005f1a:	ffe5                	bnez	a5,80005f12 <acquire+0x1a>
  __sync_synchronize();
    80005f1c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005f20:	9bcfb0ef          	jal	800010dc <mycpu>
    80005f24:	e888                	sd	a0,16(s1)
}
    80005f26:	60e2                	ld	ra,24(sp)
    80005f28:	6442                	ld	s0,16(sp)
    80005f2a:	64a2                	ld	s1,8(sp)
    80005f2c:	6105                	addi	sp,sp,32
    80005f2e:	8082                	ret
    panic("acquire");
    80005f30:	00002517          	auipc	a0,0x2
    80005f34:	86850513          	addi	a0,a0,-1944 # 80007798 <etext+0x798>
    80005f38:	cffff0ef          	jal	80005c36 <panic>

0000000080005f3c <pop_off>:

void
pop_off(void)
{
    80005f3c:	1141                	addi	sp,sp,-16
    80005f3e:	e406                	sd	ra,8(sp)
    80005f40:	e022                	sd	s0,0(sp)
    80005f42:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005f44:	998fb0ef          	jal	800010dc <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005f48:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005f4c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005f4e:	e39d                	bnez	a5,80005f74 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005f50:	5d3c                	lw	a5,120(a0)
    80005f52:	02f05763          	blez	a5,80005f80 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005f56:	37fd                	addiw	a5,a5,-1
    80005f58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005f5a:	eb89                	bnez	a5,80005f6c <pop_off+0x30>
    80005f5c:	5d7c                	lw	a5,124(a0)
    80005f5e:	c799                	beqz	a5,80005f6c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005f60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005f64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005f68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005f6c:	60a2                	ld	ra,8(sp)
    80005f6e:	6402                	ld	s0,0(sp)
    80005f70:	0141                	addi	sp,sp,16
    80005f72:	8082                	ret
    panic("pop_off - interruptible");
    80005f74:	00002517          	auipc	a0,0x2
    80005f78:	82c50513          	addi	a0,a0,-2004 # 800077a0 <etext+0x7a0>
    80005f7c:	cbbff0ef          	jal	80005c36 <panic>
    panic("pop_off");
    80005f80:	00002517          	auipc	a0,0x2
    80005f84:	83850513          	addi	a0,a0,-1992 # 800077b8 <etext+0x7b8>
    80005f88:	cafff0ef          	jal	80005c36 <panic>

0000000080005f8c <release>:
{
    80005f8c:	1101                	addi	sp,sp,-32
    80005f8e:	ec06                	sd	ra,24(sp)
    80005f90:	e822                	sd	s0,16(sp)
    80005f92:	e426                	sd	s1,8(sp)
    80005f94:	1000                	addi	s0,sp,32
    80005f96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005f98:	ef1ff0ef          	jal	80005e88 <holding>
    80005f9c:	c105                	beqz	a0,80005fbc <release+0x30>
  lk->cpu = 0;
    80005f9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005fa2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005fa6:	0310000f          	fence	rw,w
    80005faa:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005fae:	f8fff0ef          	jal	80005f3c <pop_off>
}
    80005fb2:	60e2                	ld	ra,24(sp)
    80005fb4:	6442                	ld	s0,16(sp)
    80005fb6:	64a2                	ld	s1,8(sp)
    80005fb8:	6105                	addi	sp,sp,32
    80005fba:	8082                	ret
    panic("release");
    80005fbc:	00002517          	auipc	a0,0x2
    80005fc0:	80450513          	addi	a0,a0,-2044 # 800077c0 <etext+0x7c0>
    80005fc4:	c73ff0ef          	jal	80005c36 <panic>
	...

0000000080006000 <_trampoline>:
    80006000:	14051073          	csrw	sscratch,a0
    80006004:	02000537          	lui	a0,0x2000
    80006008:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    8000600a:	0536                	slli	a0,a0,0xd
    8000600c:	02153423          	sd	ra,40(a0)
    80006010:	02253823          	sd	sp,48(a0)
    80006014:	02353c23          	sd	gp,56(a0)
    80006018:	04453023          	sd	tp,64(a0)
    8000601c:	04553423          	sd	t0,72(a0)
    80006020:	04653823          	sd	t1,80(a0)
    80006024:	04753c23          	sd	t2,88(a0)
    80006028:	f120                	sd	s0,96(a0)
    8000602a:	f524                	sd	s1,104(a0)
    8000602c:	fd2c                	sd	a1,120(a0)
    8000602e:	e150                	sd	a2,128(a0)
    80006030:	e554                	sd	a3,136(a0)
    80006032:	e958                	sd	a4,144(a0)
    80006034:	ed5c                	sd	a5,152(a0)
    80006036:	0b053023          	sd	a6,160(a0)
    8000603a:	0b153423          	sd	a7,168(a0)
    8000603e:	0b253823          	sd	s2,176(a0)
    80006042:	0b353c23          	sd	s3,184(a0)
    80006046:	0d453023          	sd	s4,192(a0)
    8000604a:	0d553423          	sd	s5,200(a0)
    8000604e:	0d653823          	sd	s6,208(a0)
    80006052:	0d753c23          	sd	s7,216(a0)
    80006056:	0f853023          	sd	s8,224(a0)
    8000605a:	0f953423          	sd	s9,232(a0)
    8000605e:	0fa53823          	sd	s10,240(a0)
    80006062:	0fb53c23          	sd	s11,248(a0)
    80006066:	11c53023          	sd	t3,256(a0)
    8000606a:	11d53423          	sd	t4,264(a0)
    8000606e:	11e53823          	sd	t5,272(a0)
    80006072:	11f53c23          	sd	t6,280(a0)
    80006076:	140022f3          	csrr	t0,sscratch
    8000607a:	06553823          	sd	t0,112(a0)
    8000607e:	00853103          	ld	sp,8(a0)
    80006082:	02053203          	ld	tp,32(a0)
    80006086:	01053283          	ld	t0,16(a0)
    8000608a:	00053303          	ld	t1,0(a0)
    8000608e:	12000073          	sfence.vma
    80006092:	18031073          	csrw	satp,t1
    80006096:	12000073          	sfence.vma
    8000609a:	9282                	jalr	t0

000000008000609c <userret>:
    8000609c:	12000073          	sfence.vma
    800060a0:	18051073          	csrw	satp,a0
    800060a4:	12000073          	sfence.vma
    800060a8:	02000537          	lui	a0,0x2000
    800060ac:	357d                	addiw	a0,a0,-1 # 1ffffff <_entry-0x7e000001>
    800060ae:	0536                	slli	a0,a0,0xd
    800060b0:	02853083          	ld	ra,40(a0)
    800060b4:	03053103          	ld	sp,48(a0)
    800060b8:	03853183          	ld	gp,56(a0)
    800060bc:	04053203          	ld	tp,64(a0)
    800060c0:	04853283          	ld	t0,72(a0)
    800060c4:	05053303          	ld	t1,80(a0)
    800060c8:	05853383          	ld	t2,88(a0)
    800060cc:	7120                	ld	s0,96(a0)
    800060ce:	7524                	ld	s1,104(a0)
    800060d0:	7d2c                	ld	a1,120(a0)
    800060d2:	6150                	ld	a2,128(a0)
    800060d4:	6554                	ld	a3,136(a0)
    800060d6:	6958                	ld	a4,144(a0)
    800060d8:	6d5c                	ld	a5,152(a0)
    800060da:	0a053803          	ld	a6,160(a0)
    800060de:	0a853883          	ld	a7,168(a0)
    800060e2:	0b053903          	ld	s2,176(a0)
    800060e6:	0b853983          	ld	s3,184(a0)
    800060ea:	0c053a03          	ld	s4,192(a0)
    800060ee:	0c853a83          	ld	s5,200(a0)
    800060f2:	0d053b03          	ld	s6,208(a0)
    800060f6:	0d853b83          	ld	s7,216(a0)
    800060fa:	0e053c03          	ld	s8,224(a0)
    800060fe:	0e853c83          	ld	s9,232(a0)
    80006102:	0f053d03          	ld	s10,240(a0)
    80006106:	0f853d83          	ld	s11,248(a0)
    8000610a:	10053e03          	ld	t3,256(a0)
    8000610e:	10853e83          	ld	t4,264(a0)
    80006112:	11053f03          	ld	t5,272(a0)
    80006116:	11853f83          	ld	t6,280(a0)
    8000611a:	7928                	ld	a0,112(a0)
    8000611c:	10200073          	sret
	...
