
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0001a117          	auipc	sp,0x1a
    80000004:	e0010113          	addi	sp,sp,-512 # 80019e00 <stack0>
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
    80000016:	4fc050ef          	jal	80005512 <start>

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
    80000028:	00022797          	auipc	a5,0x22
    8000002c:	eb078793          	addi	a5,a5,-336 # 80021ed8 <end>
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
    80000056:	93e90913          	addi	s2,s2,-1730 # 80008990 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	739050ef          	jal	80005f94 <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	7bd050ef          	jal	80006028 <release>
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
    80000084:	44f050ef          	jal	80005cd2 <panic>

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
    800000e4:	8b050513          	addi	a0,a0,-1872 # 80008990 <kmem>
    800000e8:	623050ef          	jal	80005f0a <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	00022517          	auipc	a0,0x22
    800000f4:	de850513          	addi	a0,a0,-536 # 80021ed8 <end>
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
    80000112:	88250513          	addi	a0,a0,-1918 # 80008990 <kmem>
    80000116:	67f050ef          	jal	80005f94 <acquire>
  r = kmem.freelist;
    8000011a:	00009497          	auipc	s1,0x9
    8000011e:	88e4b483          	ld	s1,-1906(s1) # 800089a8 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	00009717          	auipc	a4,0x9
    8000012a:	88f73123          	sd	a5,-1918(a4) # 800089a8 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	00009517          	auipc	a0,0x9
    80000132:	86250513          	addi	a0,a0,-1950 # 80008990 <kmem>
    80000136:	6f3050ef          	jal	80006028 <release>

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
    80000154:	84050513          	addi	a0,a0,-1984 # 80008990 <kmem>
    80000158:	6d1050ef          	jal	80006028 <release>
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
    8000031e:	291000ef          	jal	80000dae <cpuid>
    kcsaninit();
#endif
    __sync_synchronize();
    started = 1;
  } else {
    while(atomic_read4((int *) &started) == 0)
    80000322:	00008497          	auipc	s1,0x8
    80000326:	62e48493          	addi	s1,s1,1582 # 80008950 <started>
  if(cpuid() == 0){
    8000032a:	c905                	beqz	a0,8000035a <main+0x46>
    while(atomic_read4((int *) &started) == 0)
    8000032c:	8526                	mv	a0,s1
    8000032e:	537050ef          	jal	80006064 <atomic_read4>
    80000332:	dd6d                	beqz	a0,8000032c <main+0x18>
      ;
    __sync_synchronize();
    80000334:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000338:	277000ef          	jal	80000dae <cpuid>
    8000033c:	85aa                	mv	a1,a0
    8000033e:	00008517          	auipc	a0,0x8
    80000342:	cfa50513          	addi	a0,a0,-774 # 80008038 <etext+0x38>
    80000346:	662050ef          	jal	800059a8 <printf>
    kvminithart();    // turn on paging
    8000034a:	088000ef          	jal	800003d2 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034e:	5b2010ef          	jal	80001900 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000352:	5d8040ef          	jal	8000492a <plicinithart>
  }

#ifdef LAB_LOCK
  rwspinlock_test();
#endif
  scheduler();        
    80000356:	6f1000ef          	jal	80001246 <scheduler>
    consoleinit();
    8000035a:	574050ef          	jal	800058ce <consoleinit>
    printfinit();
    8000035e:	1b1050ef          	jal	80005d0e <printfinit>
    printf("\n");
    80000362:	00008517          	auipc	a0,0x8
    80000366:	cb650513          	addi	a0,a0,-842 # 80008018 <etext+0x18>
    8000036a:	63e050ef          	jal	800059a8 <printf>
    printf("xv6 kernel is booting\n");
    8000036e:	00008517          	auipc	a0,0x8
    80000372:	cb250513          	addi	a0,a0,-846 # 80008020 <etext+0x20>
    80000376:	632050ef          	jal	800059a8 <printf>
    printf("\n");
    8000037a:	00008517          	auipc	a0,0x8
    8000037e:	c9e50513          	addi	a0,a0,-866 # 80008018 <etext+0x18>
    80000382:	626050ef          	jal	800059a8 <printf>
    kinit();         // physical page allocator
    80000386:	d4bff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    8000038a:	2f8000ef          	jal	80000682 <kvminit>
    kvminithart();   // turn on paging
    8000038e:	044000ef          	jal	800003d2 <kvminithart>
    procinit();      // process table
    80000392:	169000ef          	jal	80000cfa <procinit>
    trapinit();      // trap vectors
    80000396:	546010ef          	jal	800018dc <trapinit>
    trapinithart();  // install kernel trap vector
    8000039a:	566010ef          	jal	80001900 <trapinithart>
    plicinit();      // set up interrupt controller
    8000039e:	560040ef          	jal	800048fe <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003a2:	588040ef          	jal	8000492a <plicinithart>
    binit();         // buffer cache
    800003a6:	3f5010ef          	jal	80001f9a <binit>
    iinit();         // inode table
    800003aa:	146020ef          	jal	800024f0 <iinit>
    fileinit();      // file table
    800003ae:	072030ef          	jal	80003420 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003b2:	676040ef          	jal	80004a28 <virtio_disk_init>
    pci_init();
    800003b6:	08c050ef          	jal	80005442 <pci_init>
    netinit();
    800003ba:	499040ef          	jal	80005052 <netinit>
    userinit();      // first user process
    800003be:	4ef000ef          	jal	800010ac <userinit>
    __sync_synchronize();
    800003c2:	0330000f          	fence	rw,rw
    started = 1;
    800003c6:	4785                	li	a5,1
    800003c8:	00008717          	auipc	a4,0x8
    800003cc:	58f72423          	sw	a5,1416(a4) # 80008950 <started>
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
    800003e2:	57a7b783          	ld	a5,1402(a5) # 80008958 <kernel_pagetable>
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
    8000046c:	067050ef          	jal	80005cd2 <panic>
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
    80000544:	78e050ef          	jal	80005cd2 <panic>
    panic("mappages: size not aligned");
    80000548:	00008517          	auipc	a0,0x8
    8000054c:	b3050513          	addi	a0,a0,-1232 # 80008078 <etext+0x78>
    80000550:	782050ef          	jal	80005cd2 <panic>
    panic("mappages: size");
    80000554:	00008517          	auipc	a0,0x8
    80000558:	b4450513          	addi	a0,a0,-1212 # 80008098 <etext+0x98>
    8000055c:	776050ef          	jal	80005cd2 <panic>
      panic("mappages: remap");
    80000560:	00008517          	auipc	a0,0x8
    80000564:	b4850513          	addi	a0,a0,-1208 # 800080a8 <etext+0xa8>
    80000568:	76a050ef          	jal	80005cd2 <panic>
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
    800005ac:	726050ef          	jal	80005cd2 <panic>

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
    80000692:	2ca7b523          	sd	a0,714(a5) # 80008958 <kernel_pagetable>
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
    8000070c:	5c6050ef          	jal	80005cd2 <panic>
      panic("uvmunmap: not a leaf");
    80000710:	00008517          	auipc	a0,0x8
    80000714:	9c850513          	addi	a0,a0,-1592 # 800080d8 <etext+0xd8>
    80000718:	5ba050ef          	jal	80005cd2 <panic>
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
    80000878:	45a050ef          	jal	80005cd2 <panic>
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
    800009a6:	32c050ef          	jal	80005cd2 <panic>

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
    80000a92:	350000ef          	jal	80000de2 <myproc>
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
    80000c76:	16e48493          	addi	s1,s1,366 # 80008de0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c7a:	8c26                	mv	s8,s1
    80000c7c:	000a57b7          	lui	a5,0xa5
    80000c80:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80000c84:	07b2                	slli	a5,a5,0xc
    80000c86:	fa578793          	addi	a5,a5,-91
    80000c8a:	4fa50937          	lui	s2,0x4fa50
    80000c8e:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80000c92:	1902                	slli	s2,s2,0x20
    80000c94:	993e                	add	s2,s2,a5
    80000c96:	010009b7          	lui	s3,0x1000
    80000c9a:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000c9c:	09ba                	slli	s3,s3,0xe
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c9e:	4b99                	li	s7,6
    80000ca0:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ca2:	0000ea97          	auipc	s5,0xe
    80000ca6:	b3ea8a93          	addi	s5,s5,-1218 # 8000e7e0 <tickslock>
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
    80000cce:	16848493          	addi	s1,s1,360
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
    80000cf6:	7dd040ef          	jal	80005cd2 <panic>

0000000080000cfa <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cfa:	7139                	addi	sp,sp,-64
    80000cfc:	fc06                	sd	ra,56(sp)
    80000cfe:	f822                	sd	s0,48(sp)
    80000d00:	f426                	sd	s1,40(sp)
    80000d02:	f04a                	sd	s2,32(sp)
    80000d04:	ec4e                	sd	s3,24(sp)
    80000d06:	e852                	sd	s4,16(sp)
    80000d08:	e456                	sd	s5,8(sp)
    80000d0a:	e05a                	sd	s6,0(sp)
    80000d0c:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d0e:	00007597          	auipc	a1,0x7
    80000d12:	40a58593          	addi	a1,a1,1034 # 80008118 <etext+0x118>
    80000d16:	00008517          	auipc	a0,0x8
    80000d1a:	c9a50513          	addi	a0,a0,-870 # 800089b0 <pid_lock>
    80000d1e:	1ec050ef          	jal	80005f0a <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d22:	00007597          	auipc	a1,0x7
    80000d26:	3fe58593          	addi	a1,a1,1022 # 80008120 <etext+0x120>
    80000d2a:	00008517          	auipc	a0,0x8
    80000d2e:	c9e50513          	addi	a0,a0,-866 # 800089c8 <wait_lock>
    80000d32:	1d8050ef          	jal	80005f0a <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d36:	00008497          	auipc	s1,0x8
    80000d3a:	0aa48493          	addi	s1,s1,170 # 80008de0 <proc>
      initlock(&p->lock, "proc");
    80000d3e:	00007a97          	auipc	s5,0x7
    80000d42:	3f2a8a93          	addi	s5,s5,1010 # 80008130 <etext+0x130>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d46:	8a26                	mv	s4,s1
    80000d48:	000a57b7          	lui	a5,0xa5
    80000d4c:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80000d50:	07b2                	slli	a5,a5,0xc
    80000d52:	fa578793          	addi	a5,a5,-91
    80000d56:	4fa50937          	lui	s2,0x4fa50
    80000d5a:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80000d5e:	1902                	slli	s2,s2,0x20
    80000d60:	993e                	add	s2,s2,a5
    80000d62:	010009b7          	lui	s3,0x1000
    80000d66:	19fd                	addi	s3,s3,-1 # ffffff <_entry-0x7f000001>
    80000d68:	09ba                	slli	s3,s3,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d6a:	0000eb17          	auipc	s6,0xe
    80000d6e:	a76b0b13          	addi	s6,s6,-1418 # 8000e7e0 <tickslock>
      initlock(&p->lock, "proc");
    80000d72:	85d6                	mv	a1,s5
    80000d74:	8526                	mv	a0,s1
    80000d76:	194050ef          	jal	80005f0a <initlock>
      p->state = UNUSED;
    80000d7a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d7e:	414487b3          	sub	a5,s1,s4
    80000d82:	878d                	srai	a5,a5,0x3
    80000d84:	032787b3          	mul	a5,a5,s2
    80000d88:	00d7979b          	slliw	a5,a5,0xd
    80000d8c:	40f987b3          	sub	a5,s3,a5
    80000d90:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d92:	16848493          	addi	s1,s1,360
    80000d96:	fd649ee3          	bne	s1,s6,80000d72 <procinit+0x78>
  }
}
    80000d9a:	70e2                	ld	ra,56(sp)
    80000d9c:	7442                	ld	s0,48(sp)
    80000d9e:	74a2                	ld	s1,40(sp)
    80000da0:	7902                	ld	s2,32(sp)
    80000da2:	69e2                	ld	s3,24(sp)
    80000da4:	6a42                	ld	s4,16(sp)
    80000da6:	6aa2                	ld	s5,8(sp)
    80000da8:	6b02                	ld	s6,0(sp)
    80000daa:	6121                	addi	sp,sp,64
    80000dac:	8082                	ret

0000000080000dae <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000dae:	1141                	addi	sp,sp,-16
    80000db0:	e406                	sd	ra,8(sp)
    80000db2:	e022                	sd	s0,0(sp)
    80000db4:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000db6:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000db8:	2501                	sext.w	a0,a0
    80000dba:	60a2                	ld	ra,8(sp)
    80000dbc:	6402                	ld	s0,0(sp)
    80000dbe:	0141                	addi	sp,sp,16
    80000dc0:	8082                	ret

0000000080000dc2 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000dc2:	1141                	addi	sp,sp,-16
    80000dc4:	e406                	sd	ra,8(sp)
    80000dc6:	e022                	sd	s0,0(sp)
    80000dc8:	0800                	addi	s0,sp,16
    80000dca:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000dcc:	2781                	sext.w	a5,a5
    80000dce:	079e                	slli	a5,a5,0x7
  return c;
}
    80000dd0:	00008517          	auipc	a0,0x8
    80000dd4:	c1050513          	addi	a0,a0,-1008 # 800089e0 <cpus>
    80000dd8:	953e                	add	a0,a0,a5
    80000dda:	60a2                	ld	ra,8(sp)
    80000ddc:	6402                	ld	s0,0(sp)
    80000dde:	0141                	addi	sp,sp,16
    80000de0:	8082                	ret

0000000080000de2 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000de2:	1101                	addi	sp,sp,-32
    80000de4:	ec06                	sd	ra,24(sp)
    80000de6:	e822                	sd	s0,16(sp)
    80000de8:	e426                	sd	s1,8(sp)
    80000dea:	1000                	addi	s0,sp,32
  push_off();
    80000dec:	164050ef          	jal	80005f50 <push_off>
    80000df0:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000df2:	2781                	sext.w	a5,a5
    80000df4:	079e                	slli	a5,a5,0x7
    80000df6:	00008717          	auipc	a4,0x8
    80000dfa:	bba70713          	addi	a4,a4,-1094 # 800089b0 <pid_lock>
    80000dfe:	97ba                	add	a5,a5,a4
    80000e00:	7b9c                	ld	a5,48(a5)
    80000e02:	84be                	mv	s1,a5
  pop_off();
    80000e04:	1d4050ef          	jal	80005fd8 <pop_off>
  return p;
}
    80000e08:	8526                	mv	a0,s1
    80000e0a:	60e2                	ld	ra,24(sp)
    80000e0c:	6442                	ld	s0,16(sp)
    80000e0e:	64a2                	ld	s1,8(sp)
    80000e10:	6105                	addi	sp,sp,32
    80000e12:	8082                	ret

0000000080000e14 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e14:	7179                	addi	sp,sp,-48
    80000e16:	f406                	sd	ra,40(sp)
    80000e18:	f022                	sd	s0,32(sp)
    80000e1a:	ec26                	sd	s1,24(sp)
    80000e1c:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000e1e:	fc5ff0ef          	jal	80000de2 <myproc>
    80000e22:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000e24:	204050ef          	jal	80006028 <release>

  if (first) {
    80000e28:	00008797          	auipc	a5,0x8
    80000e2c:	b087a783          	lw	a5,-1272(a5) # 80008930 <first.1>
    80000e30:	cf95                	beqz	a5,80000e6c <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000e32:	4505                	li	a0,1
    80000e34:	379010ef          	jal	800029ac <fsinit>

    first = 0;
    80000e38:	00008797          	auipc	a5,0x8
    80000e3c:	ae07ac23          	sw	zero,-1288(a5) # 80008930 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000e40:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000e44:	00007797          	auipc	a5,0x7
    80000e48:	2f478793          	addi	a5,a5,756 # 80008138 <etext+0x138>
    80000e4c:	fcf43823          	sd	a5,-48(s0)
    80000e50:	fc043c23          	sd	zero,-40(s0)
    80000e54:	fd040593          	addi	a1,s0,-48
    80000e58:	853e                	mv	a0,a5
    80000e5a:	4d1020ef          	jal	80003b2a <kexec>
    80000e5e:	6cbc                	ld	a5,88(s1)
    80000e60:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000e62:	6cbc                	ld	a5,88(s1)
    80000e64:	7bb8                	ld	a4,112(a5)
    80000e66:	57fd                	li	a5,-1
    80000e68:	02f70d63          	beq	a4,a5,80000ea2 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e6c:	2b1000ef          	jal	8000191c <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e70:	68a8                	ld	a0,80(s1)
    80000e72:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e74:	04000737          	lui	a4,0x4000
    80000e78:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e7a:	0732                	slli	a4,a4,0xc
    80000e7c:	00006797          	auipc	a5,0x6
    80000e80:	22078793          	addi	a5,a5,544 # 8000709c <userret>
    80000e84:	00006697          	auipc	a3,0x6
    80000e88:	17c68693          	addi	a3,a3,380 # 80007000 <_trampoline>
    80000e8c:	8f95                	sub	a5,a5,a3
    80000e8e:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e90:	577d                	li	a4,-1
    80000e92:	177e                	slli	a4,a4,0x3f
    80000e94:	8d59                	or	a0,a0,a4
    80000e96:	9782                	jalr	a5
}
    80000e98:	70a2                	ld	ra,40(sp)
    80000e9a:	7402                	ld	s0,32(sp)
    80000e9c:	64e2                	ld	s1,24(sp)
    80000e9e:	6145                	addi	sp,sp,48
    80000ea0:	8082                	ret
      panic("exec");
    80000ea2:	00007517          	auipc	a0,0x7
    80000ea6:	29e50513          	addi	a0,a0,670 # 80008140 <etext+0x140>
    80000eaa:	629040ef          	jal	80005cd2 <panic>

0000000080000eae <allocpid>:
{
    80000eae:	1101                	addi	sp,sp,-32
    80000eb0:	ec06                	sd	ra,24(sp)
    80000eb2:	e822                	sd	s0,16(sp)
    80000eb4:	e426                	sd	s1,8(sp)
    80000eb6:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000eb8:	00008517          	auipc	a0,0x8
    80000ebc:	af850513          	addi	a0,a0,-1288 # 800089b0 <pid_lock>
    80000ec0:	0d4050ef          	jal	80005f94 <acquire>
  pid = nextpid;
    80000ec4:	00008797          	auipc	a5,0x8
    80000ec8:	a7078793          	addi	a5,a5,-1424 # 80008934 <nextpid>
    80000ecc:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ece:	0014871b          	addiw	a4,s1,1
    80000ed2:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ed4:	00008517          	auipc	a0,0x8
    80000ed8:	adc50513          	addi	a0,a0,-1316 # 800089b0 <pid_lock>
    80000edc:	14c050ef          	jal	80006028 <release>
}
    80000ee0:	8526                	mv	a0,s1
    80000ee2:	60e2                	ld	ra,24(sp)
    80000ee4:	6442                	ld	s0,16(sp)
    80000ee6:	64a2                	ld	s1,8(sp)
    80000ee8:	6105                	addi	sp,sp,32
    80000eea:	8082                	ret

0000000080000eec <proc_pagetable>:
{
    80000eec:	1101                	addi	sp,sp,-32
    80000eee:	ec06                	sd	ra,24(sp)
    80000ef0:	e822                	sd	s0,16(sp)
    80000ef2:	e426                	sd	s1,8(sp)
    80000ef4:	e04a                	sd	s2,0(sp)
    80000ef6:	1000                	addi	s0,sp,32
    80000ef8:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000efa:	fa4ff0ef          	jal	8000069e <uvmcreate>
    80000efe:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000f00:	cd05                	beqz	a0,80000f38 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f02:	4729                	li	a4,10
    80000f04:	00006697          	auipc	a3,0x6
    80000f08:	0fc68693          	addi	a3,a3,252 # 80007000 <_trampoline>
    80000f0c:	6605                	lui	a2,0x1
    80000f0e:	040005b7          	lui	a1,0x4000
    80000f12:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f14:	05b2                	slli	a1,a1,0xc
    80000f16:	dbcff0ef          	jal	800004d2 <mappages>
    80000f1a:	02054663          	bltz	a0,80000f46 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f1e:	4719                	li	a4,6
    80000f20:	05893683          	ld	a3,88(s2)
    80000f24:	6605                	lui	a2,0x1
    80000f26:	020005b7          	lui	a1,0x2000
    80000f2a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f2c:	05b6                	slli	a1,a1,0xd
    80000f2e:	8526                	mv	a0,s1
    80000f30:	da2ff0ef          	jal	800004d2 <mappages>
    80000f34:	00054f63          	bltz	a0,80000f52 <proc_pagetable+0x66>
}
    80000f38:	8526                	mv	a0,s1
    80000f3a:	60e2                	ld	ra,24(sp)
    80000f3c:	6442                	ld	s0,16(sp)
    80000f3e:	64a2                	ld	s1,8(sp)
    80000f40:	6902                	ld	s2,0(sp)
    80000f42:	6105                	addi	sp,sp,32
    80000f44:	8082                	ret
    uvmfree(pagetable, 0);
    80000f46:	4581                	li	a1,0
    80000f48:	8526                	mv	a0,s1
    80000f4a:	96bff0ef          	jal	800008b4 <uvmfree>
    return 0;
    80000f4e:	4481                	li	s1,0
    80000f50:	b7e5                	j	80000f38 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f52:	4681                	li	a3,0
    80000f54:	4605                	li	a2,1
    80000f56:	040005b7          	lui	a1,0x4000
    80000f5a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f5c:	05b2                	slli	a1,a1,0xc
    80000f5e:	8526                	mv	a0,s1
    80000f60:	f64ff0ef          	jal	800006c4 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f64:	4581                	li	a1,0
    80000f66:	8526                	mv	a0,s1
    80000f68:	94dff0ef          	jal	800008b4 <uvmfree>
    return 0;
    80000f6c:	4481                	li	s1,0
    80000f6e:	b7e9                	j	80000f38 <proc_pagetable+0x4c>

0000000080000f70 <proc_freepagetable>:
{
    80000f70:	1101                	addi	sp,sp,-32
    80000f72:	ec06                	sd	ra,24(sp)
    80000f74:	e822                	sd	s0,16(sp)
    80000f76:	e426                	sd	s1,8(sp)
    80000f78:	e04a                	sd	s2,0(sp)
    80000f7a:	1000                	addi	s0,sp,32
    80000f7c:	84aa                	mv	s1,a0
    80000f7e:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f80:	4681                	li	a3,0
    80000f82:	4605                	li	a2,1
    80000f84:	040005b7          	lui	a1,0x4000
    80000f88:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f8a:	05b2                	slli	a1,a1,0xc
    80000f8c:	f38ff0ef          	jal	800006c4 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f90:	4681                	li	a3,0
    80000f92:	4605                	li	a2,1
    80000f94:	020005b7          	lui	a1,0x2000
    80000f98:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f9a:	05b6                	slli	a1,a1,0xd
    80000f9c:	8526                	mv	a0,s1
    80000f9e:	f26ff0ef          	jal	800006c4 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fa2:	85ca                	mv	a1,s2
    80000fa4:	8526                	mv	a0,s1
    80000fa6:	90fff0ef          	jal	800008b4 <uvmfree>
}
    80000faa:	60e2                	ld	ra,24(sp)
    80000fac:	6442                	ld	s0,16(sp)
    80000fae:	64a2                	ld	s1,8(sp)
    80000fb0:	6902                	ld	s2,0(sp)
    80000fb2:	6105                	addi	sp,sp,32
    80000fb4:	8082                	ret

0000000080000fb6 <freeproc>:
{
    80000fb6:	1101                	addi	sp,sp,-32
    80000fb8:	ec06                	sd	ra,24(sp)
    80000fba:	e822                	sd	s0,16(sp)
    80000fbc:	e426                	sd	s1,8(sp)
    80000fbe:	1000                	addi	s0,sp,32
    80000fc0:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000fc2:	6d28                	ld	a0,88(a0)
    80000fc4:	c119                	beqz	a0,80000fca <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000fc6:	856ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000fca:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000fce:	68a8                	ld	a0,80(s1)
    80000fd0:	c501                	beqz	a0,80000fd8 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000fd2:	64ac                	ld	a1,72(s1)
    80000fd4:	f9dff0ef          	jal	80000f70 <proc_freepagetable>
  p->pagetable = 0;
    80000fd8:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000fdc:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000fe0:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000fe4:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000fe8:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000fec:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000ff0:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000ff4:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000ff8:	0004ac23          	sw	zero,24(s1)
}
    80000ffc:	60e2                	ld	ra,24(sp)
    80000ffe:	6442                	ld	s0,16(sp)
    80001000:	64a2                	ld	s1,8(sp)
    80001002:	6105                	addi	sp,sp,32
    80001004:	8082                	ret

0000000080001006 <allocproc>:
{
    80001006:	1101                	addi	sp,sp,-32
    80001008:	ec06                	sd	ra,24(sp)
    8000100a:	e822                	sd	s0,16(sp)
    8000100c:	e426                	sd	s1,8(sp)
    8000100e:	e04a                	sd	s2,0(sp)
    80001010:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001012:	00008497          	auipc	s1,0x8
    80001016:	dce48493          	addi	s1,s1,-562 # 80008de0 <proc>
    8000101a:	0000d917          	auipc	s2,0xd
    8000101e:	7c690913          	addi	s2,s2,1990 # 8000e7e0 <tickslock>
    acquire(&p->lock);
    80001022:	8526                	mv	a0,s1
    80001024:	771040ef          	jal	80005f94 <acquire>
    if(p->state == UNUSED) {
    80001028:	4c9c                	lw	a5,24(s1)
    8000102a:	cb91                	beqz	a5,8000103e <allocproc+0x38>
      release(&p->lock);
    8000102c:	8526                	mv	a0,s1
    8000102e:	7fb040ef          	jal	80006028 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001032:	16848493          	addi	s1,s1,360
    80001036:	ff2496e3          	bne	s1,s2,80001022 <allocproc+0x1c>
  return 0;
    8000103a:	4481                	li	s1,0
    8000103c:	a089                	j	8000107e <allocproc+0x78>
  p->pid = allocpid();
    8000103e:	e71ff0ef          	jal	80000eae <allocpid>
    80001042:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001044:	4785                	li	a5,1
    80001046:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001048:	8bcff0ef          	jal	80000104 <kalloc>
    8000104c:	892a                	mv	s2,a0
    8000104e:	eca8                	sd	a0,88(s1)
    80001050:	cd15                	beqz	a0,8000108c <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001052:	8526                	mv	a0,s1
    80001054:	e99ff0ef          	jal	80000eec <proc_pagetable>
    80001058:	892a                	mv	s2,a0
    8000105a:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000105c:	c121                	beqz	a0,8000109c <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    8000105e:	07000613          	li	a2,112
    80001062:	4581                	li	a1,0
    80001064:	06048513          	addi	a0,s1,96
    80001068:	8f6ff0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    8000106c:	00000797          	auipc	a5,0x0
    80001070:	da878793          	addi	a5,a5,-600 # 80000e14 <forkret>
    80001074:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001076:	60bc                	ld	a5,64(s1)
    80001078:	6705                	lui	a4,0x1
    8000107a:	97ba                	add	a5,a5,a4
    8000107c:	f4bc                	sd	a5,104(s1)
}
    8000107e:	8526                	mv	a0,s1
    80001080:	60e2                	ld	ra,24(sp)
    80001082:	6442                	ld	s0,16(sp)
    80001084:	64a2                	ld	s1,8(sp)
    80001086:	6902                	ld	s2,0(sp)
    80001088:	6105                	addi	sp,sp,32
    8000108a:	8082                	ret
    freeproc(p);
    8000108c:	8526                	mv	a0,s1
    8000108e:	f29ff0ef          	jal	80000fb6 <freeproc>
    release(&p->lock);
    80001092:	8526                	mv	a0,s1
    80001094:	795040ef          	jal	80006028 <release>
    return 0;
    80001098:	84ca                	mv	s1,s2
    8000109a:	b7d5                	j	8000107e <allocproc+0x78>
    freeproc(p);
    8000109c:	8526                	mv	a0,s1
    8000109e:	f19ff0ef          	jal	80000fb6 <freeproc>
    release(&p->lock);
    800010a2:	8526                	mv	a0,s1
    800010a4:	785040ef          	jal	80006028 <release>
    return 0;
    800010a8:	84ca                	mv	s1,s2
    800010aa:	bfd1                	j	8000107e <allocproc+0x78>

00000000800010ac <userinit>:
{
    800010ac:	1101                	addi	sp,sp,-32
    800010ae:	ec06                	sd	ra,24(sp)
    800010b0:	e822                	sd	s0,16(sp)
    800010b2:	e426                	sd	s1,8(sp)
    800010b4:	1000                	addi	s0,sp,32
  p = allocproc();
    800010b6:	f51ff0ef          	jal	80001006 <allocproc>
    800010ba:	84aa                	mv	s1,a0
  initproc = p;
    800010bc:	00008797          	auipc	a5,0x8
    800010c0:	8aa7b223          	sd	a0,-1884(a5) # 80008960 <initproc>
  p->cwd = namei("/");
    800010c4:	00007517          	auipc	a0,0x7
    800010c8:	08450513          	addi	a0,a0,132 # 80008148 <etext+0x148>
    800010cc:	61b010ef          	jal	80002ee6 <namei>
    800010d0:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800010d4:	478d                	li	a5,3
    800010d6:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800010d8:	8526                	mv	a0,s1
    800010da:	74f040ef          	jal	80006028 <release>
}
    800010de:	60e2                	ld	ra,24(sp)
    800010e0:	6442                	ld	s0,16(sp)
    800010e2:	64a2                	ld	s1,8(sp)
    800010e4:	6105                	addi	sp,sp,32
    800010e6:	8082                	ret

00000000800010e8 <growproc>:
{
    800010e8:	1101                	addi	sp,sp,-32
    800010ea:	ec06                	sd	ra,24(sp)
    800010ec:	e822                	sd	s0,16(sp)
    800010ee:	e426                	sd	s1,8(sp)
    800010f0:	e04a                	sd	s2,0(sp)
    800010f2:	1000                	addi	s0,sp,32
    800010f4:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800010f6:	cedff0ef          	jal	80000de2 <myproc>
    800010fa:	84aa                	mv	s1,a0
  sz = p->sz;
    800010fc:	652c                	ld	a1,72(a0)
  if(n > 0){
    800010fe:	01204c63          	bgtz	s2,80001116 <growproc+0x2e>
  } else if(n < 0){
    80001102:	02094463          	bltz	s2,8000112a <growproc+0x42>
  p->sz = sz;
    80001106:	e4ac                	sd	a1,72(s1)
  return 0;
    80001108:	4501                	li	a0,0
}
    8000110a:	60e2                	ld	ra,24(sp)
    8000110c:	6442                	ld	s0,16(sp)
    8000110e:	64a2                	ld	s1,8(sp)
    80001110:	6902                	ld	s2,0(sp)
    80001112:	6105                	addi	sp,sp,32
    80001114:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001116:	4691                	li	a3,4
    80001118:	00b90633          	add	a2,s2,a1
    8000111c:	6928                	ld	a0,80(a0)
    8000111e:	e90ff0ef          	jal	800007ae <uvmalloc>
    80001122:	85aa                	mv	a1,a0
    80001124:	f16d                	bnez	a0,80001106 <growproc+0x1e>
      return -1;
    80001126:	557d                	li	a0,-1
    80001128:	b7cd                	j	8000110a <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    8000112a:	00b90633          	add	a2,s2,a1
    8000112e:	6928                	ld	a0,80(a0)
    80001130:	e3aff0ef          	jal	8000076a <uvmdealloc>
    80001134:	85aa                	mv	a1,a0
    80001136:	bfc1                	j	80001106 <growproc+0x1e>

0000000080001138 <kfork>:
{
    80001138:	7139                	addi	sp,sp,-64
    8000113a:	fc06                	sd	ra,56(sp)
    8000113c:	f822                	sd	s0,48(sp)
    8000113e:	f426                	sd	s1,40(sp)
    80001140:	e456                	sd	s5,8(sp)
    80001142:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001144:	c9fff0ef          	jal	80000de2 <myproc>
    80001148:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000114a:	ebdff0ef          	jal	80001006 <allocproc>
    8000114e:	0e050a63          	beqz	a0,80001242 <kfork+0x10a>
    80001152:	e852                	sd	s4,16(sp)
    80001154:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001156:	048ab603          	ld	a2,72(s5)
    8000115a:	692c                	ld	a1,80(a0)
    8000115c:	050ab503          	ld	a0,80(s5)
    80001160:	f86ff0ef          	jal	800008e6 <uvmcopy>
    80001164:	04054863          	bltz	a0,800011b4 <kfork+0x7c>
    80001168:	f04a                	sd	s2,32(sp)
    8000116a:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000116c:	048ab783          	ld	a5,72(s5)
    80001170:	04fa3423          	sd	a5,72(s4) # 1048 <_entry-0x7fffefb8>
  *(np->trapframe) = *(p->trapframe);
    80001174:	058ab683          	ld	a3,88(s5)
    80001178:	87b6                	mv	a5,a3
    8000117a:	058a3703          	ld	a4,88(s4)
    8000117e:	12068693          	addi	a3,a3,288
    80001182:	6388                	ld	a0,0(a5)
    80001184:	678c                	ld	a1,8(a5)
    80001186:	6b90                	ld	a2,16(a5)
    80001188:	e308                	sd	a0,0(a4)
    8000118a:	e70c                	sd	a1,8(a4)
    8000118c:	eb10                	sd	a2,16(a4)
    8000118e:	6f90                	ld	a2,24(a5)
    80001190:	ef10                	sd	a2,24(a4)
    80001192:	02078793          	addi	a5,a5,32
    80001196:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    8000119a:	fed794e3          	bne	a5,a3,80001182 <kfork+0x4a>
  np->trapframe->a0 = 0;
    8000119e:	058a3783          	ld	a5,88(s4)
    800011a2:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800011a6:	0d0a8493          	addi	s1,s5,208
    800011aa:	0d0a0913          	addi	s2,s4,208
    800011ae:	150a8993          	addi	s3,s5,336
    800011b2:	a831                	j	800011ce <kfork+0x96>
    freeproc(np);
    800011b4:	8552                	mv	a0,s4
    800011b6:	e01ff0ef          	jal	80000fb6 <freeproc>
    release(&np->lock);
    800011ba:	8552                	mv	a0,s4
    800011bc:	66d040ef          	jal	80006028 <release>
    return -1;
    800011c0:	54fd                	li	s1,-1
    800011c2:	6a42                	ld	s4,16(sp)
    800011c4:	a885                	j	80001234 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    800011c6:	04a1                	addi	s1,s1,8
    800011c8:	0921                	addi	s2,s2,8
    800011ca:	01348963          	beq	s1,s3,800011dc <kfork+0xa4>
    if(p->ofile[i])
    800011ce:	6088                	ld	a0,0(s1)
    800011d0:	d97d                	beqz	a0,800011c6 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    800011d2:	2d0020ef          	jal	800034a2 <filedup>
    800011d6:	00a93023          	sd	a0,0(s2)
    800011da:	b7f5                	j	800011c6 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    800011dc:	150ab503          	ld	a0,336(s5)
    800011e0:	4a2010ef          	jal	80002682 <idup>
    800011e4:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800011e8:	4641                	li	a2,16
    800011ea:	158a8593          	addi	a1,s5,344
    800011ee:	158a0513          	addi	a0,s4,344
    800011f2:	8c0ff0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    800011f6:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    800011fa:	8552                	mv	a0,s4
    800011fc:	62d040ef          	jal	80006028 <release>
  acquire(&wait_lock);
    80001200:	00007517          	auipc	a0,0x7
    80001204:	7c850513          	addi	a0,a0,1992 # 800089c8 <wait_lock>
    80001208:	58d040ef          	jal	80005f94 <acquire>
  np->parent = p;
    8000120c:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001210:	00007517          	auipc	a0,0x7
    80001214:	7b850513          	addi	a0,a0,1976 # 800089c8 <wait_lock>
    80001218:	611040ef          	jal	80006028 <release>
  acquire(&np->lock);
    8000121c:	8552                	mv	a0,s4
    8000121e:	577040ef          	jal	80005f94 <acquire>
  np->state = RUNNABLE;
    80001222:	478d                	li	a5,3
    80001224:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001228:	8552                	mv	a0,s4
    8000122a:	5ff040ef          	jal	80006028 <release>
  return pid;
    8000122e:	7902                	ld	s2,32(sp)
    80001230:	69e2                	ld	s3,24(sp)
    80001232:	6a42                	ld	s4,16(sp)
}
    80001234:	8526                	mv	a0,s1
    80001236:	70e2                	ld	ra,56(sp)
    80001238:	7442                	ld	s0,48(sp)
    8000123a:	74a2                	ld	s1,40(sp)
    8000123c:	6aa2                	ld	s5,8(sp)
    8000123e:	6121                	addi	sp,sp,64
    80001240:	8082                	ret
    return -1;
    80001242:	54fd                	li	s1,-1
    80001244:	bfc5                	j	80001234 <kfork+0xfc>

0000000080001246 <scheduler>:
{
    80001246:	715d                	addi	sp,sp,-80
    80001248:	e486                	sd	ra,72(sp)
    8000124a:	e0a2                	sd	s0,64(sp)
    8000124c:	fc26                	sd	s1,56(sp)
    8000124e:	f84a                	sd	s2,48(sp)
    80001250:	f44e                	sd	s3,40(sp)
    80001252:	f052                	sd	s4,32(sp)
    80001254:	ec56                	sd	s5,24(sp)
    80001256:	e85a                	sd	s6,16(sp)
    80001258:	e45e                	sd	s7,8(sp)
    8000125a:	e062                	sd	s8,0(sp)
    8000125c:	0880                	addi	s0,sp,80
    8000125e:	8792                	mv	a5,tp
  int id = r_tp();
    80001260:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001262:	00779b13          	slli	s6,a5,0x7
    80001266:	00007717          	auipc	a4,0x7
    8000126a:	74a70713          	addi	a4,a4,1866 # 800089b0 <pid_lock>
    8000126e:	975a                	add	a4,a4,s6
    80001270:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001274:	00007717          	auipc	a4,0x7
    80001278:	77470713          	addi	a4,a4,1908 # 800089e8 <cpus+0x8>
    8000127c:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000127e:	4c11                	li	s8,4
        c->proc = p;
    80001280:	079e                	slli	a5,a5,0x7
    80001282:	00007a17          	auipc	s4,0x7
    80001286:	72ea0a13          	addi	s4,s4,1838 # 800089b0 <pid_lock>
    8000128a:	9a3e                	add	s4,s4,a5
        found = 1;
    8000128c:	4b85                	li	s7,1
    8000128e:	a83d                	j	800012cc <scheduler+0x86>
      release(&p->lock);
    80001290:	8526                	mv	a0,s1
    80001292:	597040ef          	jal	80006028 <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001296:	16848493          	addi	s1,s1,360
    8000129a:	03248563          	beq	s1,s2,800012c4 <scheduler+0x7e>
      acquire(&p->lock);
    8000129e:	8526                	mv	a0,s1
    800012a0:	4f5040ef          	jal	80005f94 <acquire>
      if(p->state == RUNNABLE) {
    800012a4:	4c9c                	lw	a5,24(s1)
    800012a6:	ff3795e3          	bne	a5,s3,80001290 <scheduler+0x4a>
        p->state = RUNNING;
    800012aa:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800012ae:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800012b2:	06048593          	addi	a1,s1,96
    800012b6:	855a                	mv	a0,s6
    800012b8:	5ba000ef          	jal	80001872 <swtch>
        c->proc = 0;
    800012bc:	020a3823          	sd	zero,48(s4)
        found = 1;
    800012c0:	8ade                	mv	s5,s7
    800012c2:	b7f9                	j	80001290 <scheduler+0x4a>
    if(found == 0) {
    800012c4:	000a9463          	bnez	s5,800012cc <scheduler+0x86>
      asm volatile("wfi");
    800012c8:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012cc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800012d0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012d4:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012d8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800012dc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012de:	10079073          	csrw	sstatus,a5
    int found = 0;
    800012e2:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800012e4:	00008497          	auipc	s1,0x8
    800012e8:	afc48493          	addi	s1,s1,-1284 # 80008de0 <proc>
      if(p->state == RUNNABLE) {
    800012ec:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800012ee:	0000d917          	auipc	s2,0xd
    800012f2:	4f290913          	addi	s2,s2,1266 # 8000e7e0 <tickslock>
    800012f6:	b765                	j	8000129e <scheduler+0x58>

00000000800012f8 <sched>:
{
    800012f8:	7179                	addi	sp,sp,-48
    800012fa:	f406                	sd	ra,40(sp)
    800012fc:	f022                	sd	s0,32(sp)
    800012fe:	ec26                	sd	s1,24(sp)
    80001300:	e84a                	sd	s2,16(sp)
    80001302:	e44e                	sd	s3,8(sp)
    80001304:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001306:	addff0ef          	jal	80000de2 <myproc>
    8000130a:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    8000130c:	419040ef          	jal	80005f24 <holding>
    80001310:	c935                	beqz	a0,80001384 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001312:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001314:	2781                	sext.w	a5,a5
    80001316:	079e                	slli	a5,a5,0x7
    80001318:	00007717          	auipc	a4,0x7
    8000131c:	69870713          	addi	a4,a4,1688 # 800089b0 <pid_lock>
    80001320:	97ba                	add	a5,a5,a4
    80001322:	0a87a703          	lw	a4,168(a5)
    80001326:	4785                	li	a5,1
    80001328:	06f71463          	bne	a4,a5,80001390 <sched+0x98>
  if(p->state == RUNNING)
    8000132c:	4c98                	lw	a4,24(s1)
    8000132e:	4791                	li	a5,4
    80001330:	06f70663          	beq	a4,a5,8000139c <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001334:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001338:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000133a:	e7bd                	bnez	a5,800013a8 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000133c:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000133e:	00007917          	auipc	s2,0x7
    80001342:	67290913          	addi	s2,s2,1650 # 800089b0 <pid_lock>
    80001346:	2781                	sext.w	a5,a5
    80001348:	079e                	slli	a5,a5,0x7
    8000134a:	97ca                	add	a5,a5,s2
    8000134c:	0ac7a983          	lw	s3,172(a5)
    80001350:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001352:	2781                	sext.w	a5,a5
    80001354:	079e                	slli	a5,a5,0x7
    80001356:	07a1                	addi	a5,a5,8
    80001358:	00007597          	auipc	a1,0x7
    8000135c:	68858593          	addi	a1,a1,1672 # 800089e0 <cpus>
    80001360:	95be                	add	a1,a1,a5
    80001362:	06048513          	addi	a0,s1,96
    80001366:	50c000ef          	jal	80001872 <swtch>
    8000136a:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000136c:	2781                	sext.w	a5,a5
    8000136e:	079e                	slli	a5,a5,0x7
    80001370:	993e                	add	s2,s2,a5
    80001372:	0b392623          	sw	s3,172(s2)
}
    80001376:	70a2                	ld	ra,40(sp)
    80001378:	7402                	ld	s0,32(sp)
    8000137a:	64e2                	ld	s1,24(sp)
    8000137c:	6942                	ld	s2,16(sp)
    8000137e:	69a2                	ld	s3,8(sp)
    80001380:	6145                	addi	sp,sp,48
    80001382:	8082                	ret
    panic("sched p->lock");
    80001384:	00007517          	auipc	a0,0x7
    80001388:	dcc50513          	addi	a0,a0,-564 # 80008150 <etext+0x150>
    8000138c:	147040ef          	jal	80005cd2 <panic>
    panic("sched locks");
    80001390:	00007517          	auipc	a0,0x7
    80001394:	dd050513          	addi	a0,a0,-560 # 80008160 <etext+0x160>
    80001398:	13b040ef          	jal	80005cd2 <panic>
    panic("sched RUNNING");
    8000139c:	00007517          	auipc	a0,0x7
    800013a0:	dd450513          	addi	a0,a0,-556 # 80008170 <etext+0x170>
    800013a4:	12f040ef          	jal	80005cd2 <panic>
    panic("sched interruptible");
    800013a8:	00007517          	auipc	a0,0x7
    800013ac:	dd850513          	addi	a0,a0,-552 # 80008180 <etext+0x180>
    800013b0:	123040ef          	jal	80005cd2 <panic>

00000000800013b4 <yield>:
{
    800013b4:	1101                	addi	sp,sp,-32
    800013b6:	ec06                	sd	ra,24(sp)
    800013b8:	e822                	sd	s0,16(sp)
    800013ba:	e426                	sd	s1,8(sp)
    800013bc:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800013be:	a25ff0ef          	jal	80000de2 <myproc>
    800013c2:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800013c4:	3d1040ef          	jal	80005f94 <acquire>
  p->state = RUNNABLE;
    800013c8:	478d                	li	a5,3
    800013ca:	cc9c                	sw	a5,24(s1)
  sched();
    800013cc:	f2dff0ef          	jal	800012f8 <sched>
  release(&p->lock);
    800013d0:	8526                	mv	a0,s1
    800013d2:	457040ef          	jal	80006028 <release>
}
    800013d6:	60e2                	ld	ra,24(sp)
    800013d8:	6442                	ld	s0,16(sp)
    800013da:	64a2                	ld	s1,8(sp)
    800013dc:	6105                	addi	sp,sp,32
    800013de:	8082                	ret

00000000800013e0 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800013e0:	7179                	addi	sp,sp,-48
    800013e2:	f406                	sd	ra,40(sp)
    800013e4:	f022                	sd	s0,32(sp)
    800013e6:	ec26                	sd	s1,24(sp)
    800013e8:	e84a                	sd	s2,16(sp)
    800013ea:	e44e                	sd	s3,8(sp)
    800013ec:	1800                	addi	s0,sp,48
    800013ee:	89aa                	mv	s3,a0
    800013f0:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013f2:	9f1ff0ef          	jal	80000de2 <myproc>
    800013f6:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013f8:	39d040ef          	jal	80005f94 <acquire>
  release(lk);
    800013fc:	854a                	mv	a0,s2
    800013fe:	42b040ef          	jal	80006028 <release>

  // Go to sleep.
  p->chan = chan;
    80001402:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001406:	4789                	li	a5,2
    80001408:	cc9c                	sw	a5,24(s1)

  sched();
    8000140a:	eefff0ef          	jal	800012f8 <sched>

  // Tidy up.
  p->chan = 0;
    8000140e:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001412:	8526                	mv	a0,s1
    80001414:	415040ef          	jal	80006028 <release>
  acquire(lk);
    80001418:	854a                	mv	a0,s2
    8000141a:	37b040ef          	jal	80005f94 <acquire>
}
    8000141e:	70a2                	ld	ra,40(sp)
    80001420:	7402                	ld	s0,32(sp)
    80001422:	64e2                	ld	s1,24(sp)
    80001424:	6942                	ld	s2,16(sp)
    80001426:	69a2                	ld	s3,8(sp)
    80001428:	6145                	addi	sp,sp,48
    8000142a:	8082                	ret

000000008000142c <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    8000142c:	7139                	addi	sp,sp,-64
    8000142e:	fc06                	sd	ra,56(sp)
    80001430:	f822                	sd	s0,48(sp)
    80001432:	f426                	sd	s1,40(sp)
    80001434:	f04a                	sd	s2,32(sp)
    80001436:	ec4e                	sd	s3,24(sp)
    80001438:	e852                	sd	s4,16(sp)
    8000143a:	e456                	sd	s5,8(sp)
    8000143c:	0080                	addi	s0,sp,64
    8000143e:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001440:	00008497          	auipc	s1,0x8
    80001444:	9a048493          	addi	s1,s1,-1632 # 80008de0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001448:	4989                	li	s3,2
        p->state = RUNNABLE;
    8000144a:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    8000144c:	0000d917          	auipc	s2,0xd
    80001450:	39490913          	addi	s2,s2,916 # 8000e7e0 <tickslock>
    80001454:	a801                	j	80001464 <wakeup+0x38>
      }
      release(&p->lock);
    80001456:	8526                	mv	a0,s1
    80001458:	3d1040ef          	jal	80006028 <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000145c:	16848493          	addi	s1,s1,360
    80001460:	03248263          	beq	s1,s2,80001484 <wakeup+0x58>
    if(p != myproc()){
    80001464:	97fff0ef          	jal	80000de2 <myproc>
    80001468:	fe950ae3          	beq	a0,s1,8000145c <wakeup+0x30>
      acquire(&p->lock);
    8000146c:	8526                	mv	a0,s1
    8000146e:	327040ef          	jal	80005f94 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001472:	4c9c                	lw	a5,24(s1)
    80001474:	ff3791e3          	bne	a5,s3,80001456 <wakeup+0x2a>
    80001478:	709c                	ld	a5,32(s1)
    8000147a:	fd479ee3          	bne	a5,s4,80001456 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000147e:	0154ac23          	sw	s5,24(s1)
    80001482:	bfd1                	j	80001456 <wakeup+0x2a>
    }
  }
}
    80001484:	70e2                	ld	ra,56(sp)
    80001486:	7442                	ld	s0,48(sp)
    80001488:	74a2                	ld	s1,40(sp)
    8000148a:	7902                	ld	s2,32(sp)
    8000148c:	69e2                	ld	s3,24(sp)
    8000148e:	6a42                	ld	s4,16(sp)
    80001490:	6aa2                	ld	s5,8(sp)
    80001492:	6121                	addi	sp,sp,64
    80001494:	8082                	ret

0000000080001496 <reparent>:
{
    80001496:	7179                	addi	sp,sp,-48
    80001498:	f406                	sd	ra,40(sp)
    8000149a:	f022                	sd	s0,32(sp)
    8000149c:	ec26                	sd	s1,24(sp)
    8000149e:	e84a                	sd	s2,16(sp)
    800014a0:	e44e                	sd	s3,8(sp)
    800014a2:	e052                	sd	s4,0(sp)
    800014a4:	1800                	addi	s0,sp,48
    800014a6:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014a8:	00008497          	auipc	s1,0x8
    800014ac:	93848493          	addi	s1,s1,-1736 # 80008de0 <proc>
      pp->parent = initproc;
    800014b0:	00007a17          	auipc	s4,0x7
    800014b4:	4b0a0a13          	addi	s4,s4,1200 # 80008960 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014b8:	0000d997          	auipc	s3,0xd
    800014bc:	32898993          	addi	s3,s3,808 # 8000e7e0 <tickslock>
    800014c0:	a029                	j	800014ca <reparent+0x34>
    800014c2:	16848493          	addi	s1,s1,360
    800014c6:	01348b63          	beq	s1,s3,800014dc <reparent+0x46>
    if(pp->parent == p){
    800014ca:	7c9c                	ld	a5,56(s1)
    800014cc:	ff279be3          	bne	a5,s2,800014c2 <reparent+0x2c>
      pp->parent = initproc;
    800014d0:	000a3503          	ld	a0,0(s4)
    800014d4:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800014d6:	f57ff0ef          	jal	8000142c <wakeup>
    800014da:	b7e5                	j	800014c2 <reparent+0x2c>
}
    800014dc:	70a2                	ld	ra,40(sp)
    800014de:	7402                	ld	s0,32(sp)
    800014e0:	64e2                	ld	s1,24(sp)
    800014e2:	6942                	ld	s2,16(sp)
    800014e4:	69a2                	ld	s3,8(sp)
    800014e6:	6a02                	ld	s4,0(sp)
    800014e8:	6145                	addi	sp,sp,48
    800014ea:	8082                	ret

00000000800014ec <kexit>:
{
    800014ec:	7179                	addi	sp,sp,-48
    800014ee:	f406                	sd	ra,40(sp)
    800014f0:	f022                	sd	s0,32(sp)
    800014f2:	ec26                	sd	s1,24(sp)
    800014f4:	e84a                	sd	s2,16(sp)
    800014f6:	e44e                	sd	s3,8(sp)
    800014f8:	e052                	sd	s4,0(sp)
    800014fa:	1800                	addi	s0,sp,48
    800014fc:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014fe:	8e5ff0ef          	jal	80000de2 <myproc>
    80001502:	89aa                	mv	s3,a0
  if(p == initproc)
    80001504:	00007797          	auipc	a5,0x7
    80001508:	45c7b783          	ld	a5,1116(a5) # 80008960 <initproc>
    8000150c:	0d050493          	addi	s1,a0,208
    80001510:	15050913          	addi	s2,a0,336
    80001514:	00a79b63          	bne	a5,a0,8000152a <kexit+0x3e>
    panic("init exiting");
    80001518:	00007517          	auipc	a0,0x7
    8000151c:	c8050513          	addi	a0,a0,-896 # 80008198 <etext+0x198>
    80001520:	7b2040ef          	jal	80005cd2 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001524:	04a1                	addi	s1,s1,8
    80001526:	01248963          	beq	s1,s2,80001538 <kexit+0x4c>
    if(p->ofile[fd]){
    8000152a:	6088                	ld	a0,0(s1)
    8000152c:	dd65                	beqz	a0,80001524 <kexit+0x38>
      fileclose(f);
    8000152e:	7bb010ef          	jal	800034e8 <fileclose>
      p->ofile[fd] = 0;
    80001532:	0004b023          	sd	zero,0(s1)
    80001536:	b7fd                	j	80001524 <kexit+0x38>
  begin_op();
    80001538:	38d010ef          	jal	800030c4 <begin_op>
  iput(p->cwd);
    8000153c:	1509b503          	ld	a0,336(s3)
    80001540:	2fa010ef          	jal	8000283a <iput>
  end_op();
    80001544:	3f1010ef          	jal	80003134 <end_op>
  p->cwd = 0;
    80001548:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    8000154c:	00007517          	auipc	a0,0x7
    80001550:	47c50513          	addi	a0,a0,1148 # 800089c8 <wait_lock>
    80001554:	241040ef          	jal	80005f94 <acquire>
  reparent(p);
    80001558:	854e                	mv	a0,s3
    8000155a:	f3dff0ef          	jal	80001496 <reparent>
  wakeup(p->parent);
    8000155e:	0389b503          	ld	a0,56(s3)
    80001562:	ecbff0ef          	jal	8000142c <wakeup>
  acquire(&p->lock);
    80001566:	854e                	mv	a0,s3
    80001568:	22d040ef          	jal	80005f94 <acquire>
  p->xstate = status;
    8000156c:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001570:	4795                	li	a5,5
    80001572:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001576:	00007517          	auipc	a0,0x7
    8000157a:	45250513          	addi	a0,a0,1106 # 800089c8 <wait_lock>
    8000157e:	2ab040ef          	jal	80006028 <release>
  sched();
    80001582:	d77ff0ef          	jal	800012f8 <sched>
  panic("zombie exit");
    80001586:	00007517          	auipc	a0,0x7
    8000158a:	c2250513          	addi	a0,a0,-990 # 800081a8 <etext+0x1a8>
    8000158e:	744040ef          	jal	80005cd2 <panic>

0000000080001592 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001592:	7179                	addi	sp,sp,-48
    80001594:	f406                	sd	ra,40(sp)
    80001596:	f022                	sd	s0,32(sp)
    80001598:	ec26                	sd	s1,24(sp)
    8000159a:	e84a                	sd	s2,16(sp)
    8000159c:	e44e                	sd	s3,8(sp)
    8000159e:	1800                	addi	s0,sp,48
    800015a0:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800015a2:	00008497          	auipc	s1,0x8
    800015a6:	83e48493          	addi	s1,s1,-1986 # 80008de0 <proc>
    800015aa:	0000d997          	auipc	s3,0xd
    800015ae:	23698993          	addi	s3,s3,566 # 8000e7e0 <tickslock>
    acquire(&p->lock);
    800015b2:	8526                	mv	a0,s1
    800015b4:	1e1040ef          	jal	80005f94 <acquire>
    if(p->pid == pid){
    800015b8:	589c                	lw	a5,48(s1)
    800015ba:	01278b63          	beq	a5,s2,800015d0 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800015be:	8526                	mv	a0,s1
    800015c0:	269040ef          	jal	80006028 <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800015c4:	16848493          	addi	s1,s1,360
    800015c8:	ff3495e3          	bne	s1,s3,800015b2 <kkill+0x20>
  }
  return -1;
    800015cc:	557d                	li	a0,-1
    800015ce:	a819                	j	800015e4 <kkill+0x52>
      p->killed = 1;
    800015d0:	4785                	li	a5,1
    800015d2:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800015d4:	4c98                	lw	a4,24(s1)
    800015d6:	4789                	li	a5,2
    800015d8:	00f70d63          	beq	a4,a5,800015f2 <kkill+0x60>
      release(&p->lock);
    800015dc:	8526                	mv	a0,s1
    800015de:	24b040ef          	jal	80006028 <release>
      return 0;
    800015e2:	4501                	li	a0,0
}
    800015e4:	70a2                	ld	ra,40(sp)
    800015e6:	7402                	ld	s0,32(sp)
    800015e8:	64e2                	ld	s1,24(sp)
    800015ea:	6942                	ld	s2,16(sp)
    800015ec:	69a2                	ld	s3,8(sp)
    800015ee:	6145                	addi	sp,sp,48
    800015f0:	8082                	ret
        p->state = RUNNABLE;
    800015f2:	478d                	li	a5,3
    800015f4:	cc9c                	sw	a5,24(s1)
    800015f6:	b7dd                	j	800015dc <kkill+0x4a>

00000000800015f8 <setkilled>:

void
setkilled(struct proc *p)
{
    800015f8:	1101                	addi	sp,sp,-32
    800015fa:	ec06                	sd	ra,24(sp)
    800015fc:	e822                	sd	s0,16(sp)
    800015fe:	e426                	sd	s1,8(sp)
    80001600:	1000                	addi	s0,sp,32
    80001602:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001604:	191040ef          	jal	80005f94 <acquire>
  p->killed = 1;
    80001608:	4785                	li	a5,1
    8000160a:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    8000160c:	8526                	mv	a0,s1
    8000160e:	21b040ef          	jal	80006028 <release>
}
    80001612:	60e2                	ld	ra,24(sp)
    80001614:	6442                	ld	s0,16(sp)
    80001616:	64a2                	ld	s1,8(sp)
    80001618:	6105                	addi	sp,sp,32
    8000161a:	8082                	ret

000000008000161c <killed>:

int
killed(struct proc *p)
{
    8000161c:	1101                	addi	sp,sp,-32
    8000161e:	ec06                	sd	ra,24(sp)
    80001620:	e822                	sd	s0,16(sp)
    80001622:	e426                	sd	s1,8(sp)
    80001624:	e04a                	sd	s2,0(sp)
    80001626:	1000                	addi	s0,sp,32
    80001628:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    8000162a:	16b040ef          	jal	80005f94 <acquire>
  k = p->killed;
    8000162e:	549c                	lw	a5,40(s1)
    80001630:	893e                	mv	s2,a5
  release(&p->lock);
    80001632:	8526                	mv	a0,s1
    80001634:	1f5040ef          	jal	80006028 <release>
  return k;
}
    80001638:	854a                	mv	a0,s2
    8000163a:	60e2                	ld	ra,24(sp)
    8000163c:	6442                	ld	s0,16(sp)
    8000163e:	64a2                	ld	s1,8(sp)
    80001640:	6902                	ld	s2,0(sp)
    80001642:	6105                	addi	sp,sp,32
    80001644:	8082                	ret

0000000080001646 <kwait>:
{
    80001646:	715d                	addi	sp,sp,-80
    80001648:	e486                	sd	ra,72(sp)
    8000164a:	e0a2                	sd	s0,64(sp)
    8000164c:	fc26                	sd	s1,56(sp)
    8000164e:	f84a                	sd	s2,48(sp)
    80001650:	f44e                	sd	s3,40(sp)
    80001652:	f052                	sd	s4,32(sp)
    80001654:	ec56                	sd	s5,24(sp)
    80001656:	e85a                	sd	s6,16(sp)
    80001658:	e45e                	sd	s7,8(sp)
    8000165a:	0880                	addi	s0,sp,80
    8000165c:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000165e:	f84ff0ef          	jal	80000de2 <myproc>
    80001662:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001664:	00007517          	auipc	a0,0x7
    80001668:	36450513          	addi	a0,a0,868 # 800089c8 <wait_lock>
    8000166c:	129040ef          	jal	80005f94 <acquire>
        if(pp->state == ZOMBIE){
    80001670:	4a15                	li	s4,5
        havekids = 1;
    80001672:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001674:	0000d997          	auipc	s3,0xd
    80001678:	16c98993          	addi	s3,s3,364 # 8000e7e0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000167c:	00007b17          	auipc	s6,0x7
    80001680:	34cb0b13          	addi	s6,s6,844 # 800089c8 <wait_lock>
    80001684:	a869                	j	8000171e <kwait+0xd8>
          pid = pp->pid;
    80001686:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000168a:	000b8c63          	beqz	s7,800016a2 <kwait+0x5c>
    8000168e:	4691                	li	a3,4
    80001690:	02c48613          	addi	a2,s1,44
    80001694:	85de                	mv	a1,s7
    80001696:	05093503          	ld	a0,80(s2)
    8000169a:	c6cff0ef          	jal	80000b06 <copyout>
    8000169e:	02054a63          	bltz	a0,800016d2 <kwait+0x8c>
          freeproc(pp);
    800016a2:	8526                	mv	a0,s1
    800016a4:	913ff0ef          	jal	80000fb6 <freeproc>
          release(&pp->lock);
    800016a8:	8526                	mv	a0,s1
    800016aa:	17f040ef          	jal	80006028 <release>
          release(&wait_lock);
    800016ae:	00007517          	auipc	a0,0x7
    800016b2:	31a50513          	addi	a0,a0,794 # 800089c8 <wait_lock>
    800016b6:	173040ef          	jal	80006028 <release>
}
    800016ba:	854e                	mv	a0,s3
    800016bc:	60a6                	ld	ra,72(sp)
    800016be:	6406                	ld	s0,64(sp)
    800016c0:	74e2                	ld	s1,56(sp)
    800016c2:	7942                	ld	s2,48(sp)
    800016c4:	79a2                	ld	s3,40(sp)
    800016c6:	7a02                	ld	s4,32(sp)
    800016c8:	6ae2                	ld	s5,24(sp)
    800016ca:	6b42                	ld	s6,16(sp)
    800016cc:	6ba2                	ld	s7,8(sp)
    800016ce:	6161                	addi	sp,sp,80
    800016d0:	8082                	ret
            release(&pp->lock);
    800016d2:	8526                	mv	a0,s1
    800016d4:	155040ef          	jal	80006028 <release>
            release(&wait_lock);
    800016d8:	00007517          	auipc	a0,0x7
    800016dc:	2f050513          	addi	a0,a0,752 # 800089c8 <wait_lock>
    800016e0:	149040ef          	jal	80006028 <release>
            return -1;
    800016e4:	59fd                	li	s3,-1
    800016e6:	bfd1                	j	800016ba <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016e8:	16848493          	addi	s1,s1,360
    800016ec:	03348063          	beq	s1,s3,8000170c <kwait+0xc6>
      if(pp->parent == p){
    800016f0:	7c9c                	ld	a5,56(s1)
    800016f2:	ff279be3          	bne	a5,s2,800016e8 <kwait+0xa2>
        acquire(&pp->lock);
    800016f6:	8526                	mv	a0,s1
    800016f8:	09d040ef          	jal	80005f94 <acquire>
        if(pp->state == ZOMBIE){
    800016fc:	4c9c                	lw	a5,24(s1)
    800016fe:	f94784e3          	beq	a5,s4,80001686 <kwait+0x40>
        release(&pp->lock);
    80001702:	8526                	mv	a0,s1
    80001704:	125040ef          	jal	80006028 <release>
        havekids = 1;
    80001708:	8756                	mv	a4,s5
    8000170a:	bff9                	j	800016e8 <kwait+0xa2>
    if(!havekids || killed(p)){
    8000170c:	cf19                	beqz	a4,8000172a <kwait+0xe4>
    8000170e:	854a                	mv	a0,s2
    80001710:	f0dff0ef          	jal	8000161c <killed>
    80001714:	e919                	bnez	a0,8000172a <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001716:	85da                	mv	a1,s6
    80001718:	854a                	mv	a0,s2
    8000171a:	cc7ff0ef          	jal	800013e0 <sleep>
    havekids = 0;
    8000171e:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001720:	00007497          	auipc	s1,0x7
    80001724:	6c048493          	addi	s1,s1,1728 # 80008de0 <proc>
    80001728:	b7e1                	j	800016f0 <kwait+0xaa>
      release(&wait_lock);
    8000172a:	00007517          	auipc	a0,0x7
    8000172e:	29e50513          	addi	a0,a0,670 # 800089c8 <wait_lock>
    80001732:	0f7040ef          	jal	80006028 <release>
      return -1;
    80001736:	59fd                	li	s3,-1
    80001738:	b749                	j	800016ba <kwait+0x74>

000000008000173a <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000173a:	7179                	addi	sp,sp,-48
    8000173c:	f406                	sd	ra,40(sp)
    8000173e:	f022                	sd	s0,32(sp)
    80001740:	ec26                	sd	s1,24(sp)
    80001742:	e84a                	sd	s2,16(sp)
    80001744:	e44e                	sd	s3,8(sp)
    80001746:	e052                	sd	s4,0(sp)
    80001748:	1800                	addi	s0,sp,48
    8000174a:	84aa                	mv	s1,a0
    8000174c:	8a2e                	mv	s4,a1
    8000174e:	89b2                	mv	s3,a2
    80001750:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001752:	e90ff0ef          	jal	80000de2 <myproc>
  if(user_dst){
    80001756:	cc99                	beqz	s1,80001774 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001758:	86ca                	mv	a3,s2
    8000175a:	864e                	mv	a2,s3
    8000175c:	85d2                	mv	a1,s4
    8000175e:	6928                	ld	a0,80(a0)
    80001760:	ba6ff0ef          	jal	80000b06 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001764:	70a2                	ld	ra,40(sp)
    80001766:	7402                	ld	s0,32(sp)
    80001768:	64e2                	ld	s1,24(sp)
    8000176a:	6942                	ld	s2,16(sp)
    8000176c:	69a2                	ld	s3,8(sp)
    8000176e:	6a02                	ld	s4,0(sp)
    80001770:	6145                	addi	sp,sp,48
    80001772:	8082                	ret
    memmove((char *)dst, src, len);
    80001774:	0009061b          	sext.w	a2,s2
    80001778:	85ce                	mv	a1,s3
    8000177a:	8552                	mv	a0,s4
    8000177c:	a43fe0ef          	jal	800001be <memmove>
    return 0;
    80001780:	8526                	mv	a0,s1
    80001782:	b7cd                	j	80001764 <either_copyout+0x2a>

0000000080001784 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001784:	7179                	addi	sp,sp,-48
    80001786:	f406                	sd	ra,40(sp)
    80001788:	f022                	sd	s0,32(sp)
    8000178a:	ec26                	sd	s1,24(sp)
    8000178c:	e84a                	sd	s2,16(sp)
    8000178e:	e44e                	sd	s3,8(sp)
    80001790:	e052                	sd	s4,0(sp)
    80001792:	1800                	addi	s0,sp,48
    80001794:	8a2a                	mv	s4,a0
    80001796:	84ae                	mv	s1,a1
    80001798:	89b2                	mv	s3,a2
    8000179a:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000179c:	e46ff0ef          	jal	80000de2 <myproc>
  if(user_src){
    800017a0:	cc99                	beqz	s1,800017be <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800017a2:	86ca                	mv	a3,s2
    800017a4:	864e                	mv	a2,s3
    800017a6:	85d2                	mv	a1,s4
    800017a8:	6928                	ld	a0,80(a0)
    800017aa:	c20ff0ef          	jal	80000bca <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800017ae:	70a2                	ld	ra,40(sp)
    800017b0:	7402                	ld	s0,32(sp)
    800017b2:	64e2                	ld	s1,24(sp)
    800017b4:	6942                	ld	s2,16(sp)
    800017b6:	69a2                	ld	s3,8(sp)
    800017b8:	6a02                	ld	s4,0(sp)
    800017ba:	6145                	addi	sp,sp,48
    800017bc:	8082                	ret
    memmove(dst, (char*)src, len);
    800017be:	0009061b          	sext.w	a2,s2
    800017c2:	85ce                	mv	a1,s3
    800017c4:	8552                	mv	a0,s4
    800017c6:	9f9fe0ef          	jal	800001be <memmove>
    return 0;
    800017ca:	8526                	mv	a0,s1
    800017cc:	b7cd                	j	800017ae <either_copyin+0x2a>

00000000800017ce <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800017ce:	715d                	addi	sp,sp,-80
    800017d0:	e486                	sd	ra,72(sp)
    800017d2:	e0a2                	sd	s0,64(sp)
    800017d4:	fc26                	sd	s1,56(sp)
    800017d6:	f84a                	sd	s2,48(sp)
    800017d8:	f44e                	sd	s3,40(sp)
    800017da:	f052                	sd	s4,32(sp)
    800017dc:	ec56                	sd	s5,24(sp)
    800017de:	e85a                	sd	s6,16(sp)
    800017e0:	e45e                	sd	s7,8(sp)
    800017e2:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    800017e4:	00007517          	auipc	a0,0x7
    800017e8:	83450513          	addi	a0,a0,-1996 # 80008018 <etext+0x18>
    800017ec:	1bc040ef          	jal	800059a8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017f0:	00007497          	auipc	s1,0x7
    800017f4:	74848493          	addi	s1,s1,1864 # 80008f38 <proc+0x158>
    800017f8:	0000d917          	auipc	s2,0xd
    800017fc:	14090913          	addi	s2,s2,320 # 8000e938 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001800:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001802:	00007997          	auipc	s3,0x7
    80001806:	9b698993          	addi	s3,s3,-1610 # 800081b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    8000180a:	00007a97          	auipc	s5,0x7
    8000180e:	9b6a8a93          	addi	s5,s5,-1610 # 800081c0 <etext+0x1c0>
    printf("\n");
    80001812:	00007a17          	auipc	s4,0x7
    80001816:	806a0a13          	addi	s4,s4,-2042 # 80008018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000181a:	00007b97          	auipc	s7,0x7
    8000181e:	fa6b8b93          	addi	s7,s7,-90 # 800087c0 <states.0>
    80001822:	a829                	j	8000183c <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001824:	ed86a583          	lw	a1,-296(a3)
    80001828:	8556                	mv	a0,s5
    8000182a:	17e040ef          	jal	800059a8 <printf>
    printf("\n");
    8000182e:	8552                	mv	a0,s4
    80001830:	178040ef          	jal	800059a8 <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001834:	16848493          	addi	s1,s1,360
    80001838:	03248263          	beq	s1,s2,8000185c <procdump+0x8e>
    if(p->state == UNUSED)
    8000183c:	86a6                	mv	a3,s1
    8000183e:	ec04a783          	lw	a5,-320(s1)
    80001842:	dbed                	beqz	a5,80001834 <procdump+0x66>
      state = "???";
    80001844:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001846:	fcfb6fe3          	bltu	s6,a5,80001824 <procdump+0x56>
    8000184a:	02079713          	slli	a4,a5,0x20
    8000184e:	01d75793          	srli	a5,a4,0x1d
    80001852:	97de                	add	a5,a5,s7
    80001854:	6390                	ld	a2,0(a5)
    80001856:	f679                	bnez	a2,80001824 <procdump+0x56>
      state = "???";
    80001858:	864e                	mv	a2,s3
    8000185a:	b7e9                	j	80001824 <procdump+0x56>
  }
}
    8000185c:	60a6                	ld	ra,72(sp)
    8000185e:	6406                	ld	s0,64(sp)
    80001860:	74e2                	ld	s1,56(sp)
    80001862:	7942                	ld	s2,48(sp)
    80001864:	79a2                	ld	s3,40(sp)
    80001866:	7a02                	ld	s4,32(sp)
    80001868:	6ae2                	ld	s5,24(sp)
    8000186a:	6b42                	ld	s6,16(sp)
    8000186c:	6ba2                	ld	s7,8(sp)
    8000186e:	6161                	addi	sp,sp,80
    80001870:	8082                	ret

0000000080001872 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001872:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001876:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000187a:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000187c:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000187e:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001882:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001886:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000188a:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    8000188e:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001892:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001896:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000189a:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    8000189e:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800018a2:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800018a6:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800018aa:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800018ae:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800018b0:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800018b2:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800018b6:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800018ba:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800018be:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800018c2:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800018c6:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800018ca:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800018ce:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800018d2:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800018d6:	0685bd83          	ld	s11,104(a1)
        
        ret
    800018da:	8082                	ret

00000000800018dc <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018dc:	1141                	addi	sp,sp,-16
    800018de:	e406                	sd	ra,8(sp)
    800018e0:	e022                	sd	s0,0(sp)
    800018e2:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    800018e4:	00007597          	auipc	a1,0x7
    800018e8:	91c58593          	addi	a1,a1,-1764 # 80008200 <etext+0x200>
    800018ec:	0000d517          	auipc	a0,0xd
    800018f0:	ef450513          	addi	a0,a0,-268 # 8000e7e0 <tickslock>
    800018f4:	616040ef          	jal	80005f0a <initlock>
}
    800018f8:	60a2                	ld	ra,8(sp)
    800018fa:	6402                	ld	s0,0(sp)
    800018fc:	0141                	addi	sp,sp,16
    800018fe:	8082                	ret

0000000080001900 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001900:	1141                	addi	sp,sp,-16
    80001902:	e406                	sd	ra,8(sp)
    80001904:	e022                	sd	s0,0(sp)
    80001906:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001908:	00003797          	auipc	a5,0x3
    8000190c:	f9878793          	addi	a5,a5,-104 # 800048a0 <kernelvec>
    80001910:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001914:	60a2                	ld	ra,8(sp)
    80001916:	6402                	ld	s0,0(sp)
    80001918:	0141                	addi	sp,sp,16
    8000191a:	8082                	ret

000000008000191c <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    8000191c:	1141                	addi	sp,sp,-16
    8000191e:	e406                	sd	ra,8(sp)
    80001920:	e022                	sd	s0,0(sp)
    80001922:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001924:	cbeff0ef          	jal	80000de2 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001928:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000192c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000192e:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001932:	04000737          	lui	a4,0x4000
    80001936:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001938:	0732                	slli	a4,a4,0xc
    8000193a:	00005797          	auipc	a5,0x5
    8000193e:	6c678793          	addi	a5,a5,1734 # 80007000 <_trampoline>
    80001942:	00005697          	auipc	a3,0x5
    80001946:	6be68693          	addi	a3,a3,1726 # 80007000 <_trampoline>
    8000194a:	8f95                	sub	a5,a5,a3
    8000194c:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000194e:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001952:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001954:	18002773          	csrr	a4,satp
    80001958:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000195a:	6d38                	ld	a4,88(a0)
    8000195c:	613c                	ld	a5,64(a0)
    8000195e:	6685                	lui	a3,0x1
    80001960:	97b6                	add	a5,a5,a3
    80001962:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001964:	6d3c                	ld	a5,88(a0)
    80001966:	00000717          	auipc	a4,0x0
    8000196a:	10a70713          	addi	a4,a4,266 # 80001a70 <usertrap>
    8000196e:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001970:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001972:	8712                	mv	a4,tp
    80001974:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001976:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000197a:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000197e:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001982:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001986:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001988:	6f9c                	ld	a5,24(a5)
    8000198a:	14179073          	csrw	sepc,a5
}
    8000198e:	60a2                	ld	ra,8(sp)
    80001990:	6402                	ld	s0,0(sp)
    80001992:	0141                	addi	sp,sp,16
    80001994:	8082                	ret

0000000080001996 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001996:	1141                	addi	sp,sp,-16
    80001998:	e406                	sd	ra,8(sp)
    8000199a:	e022                	sd	s0,0(sp)
    8000199c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000199e:	c10ff0ef          	jal	80000dae <cpuid>
    800019a2:	cd11                	beqz	a0,800019be <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800019a4:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800019a8:	000f4737          	lui	a4,0xf4
    800019ac:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800019b0:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800019b2:	14d79073          	csrw	stimecmp,a5
}
    800019b6:	60a2                	ld	ra,8(sp)
    800019b8:	6402                	ld	s0,0(sp)
    800019ba:	0141                	addi	sp,sp,16
    800019bc:	8082                	ret
    acquire(&tickslock);
    800019be:	0000d517          	auipc	a0,0xd
    800019c2:	e2250513          	addi	a0,a0,-478 # 8000e7e0 <tickslock>
    800019c6:	5ce040ef          	jal	80005f94 <acquire>
    ticks++;
    800019ca:	00007717          	auipc	a4,0x7
    800019ce:	f9e70713          	addi	a4,a4,-98 # 80008968 <ticks>
    800019d2:	431c                	lw	a5,0(a4)
    800019d4:	2785                	addiw	a5,a5,1
    800019d6:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    800019d8:	853a                	mv	a0,a4
    800019da:	a53ff0ef          	jal	8000142c <wakeup>
    release(&tickslock);
    800019de:	0000d517          	auipc	a0,0xd
    800019e2:	e0250513          	addi	a0,a0,-510 # 8000e7e0 <tickslock>
    800019e6:	642040ef          	jal	80006028 <release>
    800019ea:	bf6d                	j	800019a4 <clockintr+0xe>

00000000800019ec <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019ec:	1101                	addi	sp,sp,-32
    800019ee:	ec06                	sd	ra,24(sp)
    800019f0:	e822                	sd	s0,16(sp)
    800019f2:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019f4:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019f8:	57fd                	li	a5,-1
    800019fa:	17fe                	slli	a5,a5,0x3f
    800019fc:	07a5                	addi	a5,a5,9
    800019fe:	00f70c63          	beq	a4,a5,80001a16 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a02:	57fd                	li	a5,-1
    80001a04:	17fe                	slli	a5,a5,0x3f
    80001a06:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a08:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a0a:	04f70f63          	beq	a4,a5,80001a68 <devintr+0x7c>
  }
}
    80001a0e:	60e2                	ld	ra,24(sp)
    80001a10:	6442                	ld	s0,16(sp)
    80001a12:	6105                	addi	sp,sp,32
    80001a14:	8082                	ret
    80001a16:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a18:	755020ef          	jal	8000496c <plic_claim>
    80001a1c:	872a                	mv	a4,a0
    80001a1e:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a20:	47a9                	li	a5,10
    80001a22:	00f50d63          	beq	a0,a5,80001a3c <devintr+0x50>
    } else if(irq == VIRTIO0_IRQ){
    80001a26:	4785                	li	a5,1
    80001a28:	02f50263          	beq	a0,a5,80001a4c <devintr+0x60>
    else if(irq == E1000_IRQ){
    80001a2c:	02100793          	li	a5,33
    80001a30:	02f50163          	beq	a0,a5,80001a52 <devintr+0x66>
    return 1;
    80001a34:	4505                	li	a0,1
    else if(irq){
    80001a36:	e30d                	bnez	a4,80001a58 <devintr+0x6c>
    80001a38:	64a2                	ld	s1,8(sp)
    80001a3a:	bfd1                	j	80001a0e <devintr+0x22>
      uartintr();
    80001a3c:	466040ef          	jal	80005ea2 <uartintr>
      plic_complete(irq);
    80001a40:	8526                	mv	a0,s1
    80001a42:	74b020ef          	jal	8000498c <plic_complete>
    return 1;
    80001a46:	4505                	li	a0,1
    80001a48:	64a2                	ld	s1,8(sp)
    80001a4a:	b7d1                	j	80001a0e <devintr+0x22>
      virtio_disk_intr();
    80001a4c:	3b6030ef          	jal	80004e02 <virtio_disk_intr>
    if(irq)
    80001a50:	bfc5                	j	80001a40 <devintr+0x54>
      e1000_intr();
    80001a52:	5e2030ef          	jal	80005034 <e1000_intr>
    if(irq)
    80001a56:	b7ed                	j	80001a40 <devintr+0x54>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a58:	85ba                	mv	a1,a4
    80001a5a:	00006517          	auipc	a0,0x6
    80001a5e:	7ae50513          	addi	a0,a0,1966 # 80008208 <etext+0x208>
    80001a62:	747030ef          	jal	800059a8 <printf>
    if(irq)
    80001a66:	bfe9                	j	80001a40 <devintr+0x54>
    clockintr();
    80001a68:	f2fff0ef          	jal	80001996 <clockintr>
    return 2;
    80001a6c:	4509                	li	a0,2
    80001a6e:	b745                	j	80001a0e <devintr+0x22>

0000000080001a70 <usertrap>:
{
    80001a70:	1101                	addi	sp,sp,-32
    80001a72:	ec06                	sd	ra,24(sp)
    80001a74:	e822                	sd	s0,16(sp)
    80001a76:	e426                	sd	s1,8(sp)
    80001a78:	e04a                	sd	s2,0(sp)
    80001a7a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a7c:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a80:	1007f793          	andi	a5,a5,256
    80001a84:	eba5                	bnez	a5,80001af4 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a86:	00003797          	auipc	a5,0x3
    80001a8a:	e1a78793          	addi	a5,a5,-486 # 800048a0 <kernelvec>
    80001a8e:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a92:	b50ff0ef          	jal	80000de2 <myproc>
    80001a96:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a98:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a9a:	14102773          	csrr	a4,sepc
    80001a9e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aa0:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001aa4:	47a1                	li	a5,8
    80001aa6:	04f70d63          	beq	a4,a5,80001b00 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001aaa:	f43ff0ef          	jal	800019ec <devintr>
    80001aae:	892a                	mv	s2,a0
    80001ab0:	e945                	bnez	a0,80001b60 <usertrap+0xf0>
    80001ab2:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001ab6:	47bd                	li	a5,15
    80001ab8:	08f70863          	beq	a4,a5,80001b48 <usertrap+0xd8>
    80001abc:	14202773          	csrr	a4,scause
    80001ac0:	47b5                	li	a5,13
    80001ac2:	08f70363          	beq	a4,a5,80001b48 <usertrap+0xd8>
    80001ac6:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001aca:	5890                	lw	a2,48(s1)
    80001acc:	00006517          	auipc	a0,0x6
    80001ad0:	77c50513          	addi	a0,a0,1916 # 80008248 <etext+0x248>
    80001ad4:	6d5030ef          	jal	800059a8 <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ad8:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001adc:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001ae0:	00006517          	auipc	a0,0x6
    80001ae4:	79850513          	addi	a0,a0,1944 # 80008278 <etext+0x278>
    80001ae8:	6c1030ef          	jal	800059a8 <printf>
    setkilled(p);
    80001aec:	8526                	mv	a0,s1
    80001aee:	b0bff0ef          	jal	800015f8 <setkilled>
    80001af2:	a035                	j	80001b1e <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001af4:	00006517          	auipc	a0,0x6
    80001af8:	73450513          	addi	a0,a0,1844 # 80008228 <etext+0x228>
    80001afc:	1d6040ef          	jal	80005cd2 <panic>
    if(killed(p))
    80001b00:	b1dff0ef          	jal	8000161c <killed>
    80001b04:	ed15                	bnez	a0,80001b40 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001b06:	6cb8                	ld	a4,88(s1)
    80001b08:	6f1c                	ld	a5,24(a4)
    80001b0a:	0791                	addi	a5,a5,4
    80001b0c:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b0e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b12:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b16:	10079073          	csrw	sstatus,a5
    syscall();
    80001b1a:	240000ef          	jal	80001d5a <syscall>
  if(killed(p))
    80001b1e:	8526                	mv	a0,s1
    80001b20:	afdff0ef          	jal	8000161c <killed>
    80001b24:	e139                	bnez	a0,80001b6a <usertrap+0xfa>
  prepare_return();
    80001b26:	df7ff0ef          	jal	8000191c <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b2a:	68a8                	ld	a0,80(s1)
    80001b2c:	8131                	srli	a0,a0,0xc
    80001b2e:	57fd                	li	a5,-1
    80001b30:	17fe                	slli	a5,a5,0x3f
    80001b32:	8d5d                	or	a0,a0,a5
}
    80001b34:	60e2                	ld	ra,24(sp)
    80001b36:	6442                	ld	s0,16(sp)
    80001b38:	64a2                	ld	s1,8(sp)
    80001b3a:	6902                	ld	s2,0(sp)
    80001b3c:	6105                	addi	sp,sp,32
    80001b3e:	8082                	ret
      kexit(-1);
    80001b40:	557d                	li	a0,-1
    80001b42:	9abff0ef          	jal	800014ec <kexit>
    80001b46:	b7c1                	j	80001b06 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b48:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b4c:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001b50:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001b52:	00163613          	seqz	a2,a2
    80001b56:	68a8                	ld	a0,80(s1)
    80001b58:	f2bfe0ef          	jal	80000a82 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b5c:	f169                	bnez	a0,80001b1e <usertrap+0xae>
    80001b5e:	b7a5                	j	80001ac6 <usertrap+0x56>
  if(killed(p))
    80001b60:	8526                	mv	a0,s1
    80001b62:	abbff0ef          	jal	8000161c <killed>
    80001b66:	c511                	beqz	a0,80001b72 <usertrap+0x102>
    80001b68:	a011                	j	80001b6c <usertrap+0xfc>
    80001b6a:	4901                	li	s2,0
    kexit(-1);
    80001b6c:	557d                	li	a0,-1
    80001b6e:	97fff0ef          	jal	800014ec <kexit>
  if(which_dev == 2)
    80001b72:	4789                	li	a5,2
    80001b74:	faf919e3          	bne	s2,a5,80001b26 <usertrap+0xb6>
    yield();
    80001b78:	83dff0ef          	jal	800013b4 <yield>
    80001b7c:	b76d                	j	80001b26 <usertrap+0xb6>

0000000080001b7e <kerneltrap>:
{
    80001b7e:	7179                	addi	sp,sp,-48
    80001b80:	f406                	sd	ra,40(sp)
    80001b82:	f022                	sd	s0,32(sp)
    80001b84:	ec26                	sd	s1,24(sp)
    80001b86:	e84a                	sd	s2,16(sp)
    80001b88:	e44e                	sd	s3,8(sp)
    80001b8a:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b8c:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b90:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b94:	142027f3          	csrr	a5,scause
    80001b98:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001b9a:	1004f793          	andi	a5,s1,256
    80001b9e:	c795                	beqz	a5,80001bca <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ba0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ba4:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001ba6:	eb85                	bnez	a5,80001bd6 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001ba8:	e45ff0ef          	jal	800019ec <devintr>
    80001bac:	c91d                	beqz	a0,80001be2 <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001bae:	4789                	li	a5,2
    80001bb0:	04f50a63          	beq	a0,a5,80001c04 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bb4:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bb8:	10049073          	csrw	sstatus,s1
}
    80001bbc:	70a2                	ld	ra,40(sp)
    80001bbe:	7402                	ld	s0,32(sp)
    80001bc0:	64e2                	ld	s1,24(sp)
    80001bc2:	6942                	ld	s2,16(sp)
    80001bc4:	69a2                	ld	s3,8(sp)
    80001bc6:	6145                	addi	sp,sp,48
    80001bc8:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001bca:	00006517          	auipc	a0,0x6
    80001bce:	6d650513          	addi	a0,a0,1750 # 800082a0 <etext+0x2a0>
    80001bd2:	100040ef          	jal	80005cd2 <panic>
    panic("kerneltrap: interrupts enabled");
    80001bd6:	00006517          	auipc	a0,0x6
    80001bda:	6f250513          	addi	a0,a0,1778 # 800082c8 <etext+0x2c8>
    80001bde:	0f4040ef          	jal	80005cd2 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001be2:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001be6:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001bea:	85ce                	mv	a1,s3
    80001bec:	00006517          	auipc	a0,0x6
    80001bf0:	6fc50513          	addi	a0,a0,1788 # 800082e8 <etext+0x2e8>
    80001bf4:	5b5030ef          	jal	800059a8 <printf>
    panic("kerneltrap");
    80001bf8:	00006517          	auipc	a0,0x6
    80001bfc:	71850513          	addi	a0,a0,1816 # 80008310 <etext+0x310>
    80001c00:	0d2040ef          	jal	80005cd2 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c04:	9deff0ef          	jal	80000de2 <myproc>
    80001c08:	d555                	beqz	a0,80001bb4 <kerneltrap+0x36>
    yield();
    80001c0a:	faaff0ef          	jal	800013b4 <yield>
    80001c0e:	b75d                	j	80001bb4 <kerneltrap+0x36>

0000000080001c10 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001c10:	1101                	addi	sp,sp,-32
    80001c12:	ec06                	sd	ra,24(sp)
    80001c14:	e822                	sd	s0,16(sp)
    80001c16:	e426                	sd	s1,8(sp)
    80001c18:	1000                	addi	s0,sp,32
    80001c1a:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c1c:	9c6ff0ef          	jal	80000de2 <myproc>
  switch (n) {
    80001c20:	4795                	li	a5,5
    80001c22:	0497e163          	bltu	a5,s1,80001c64 <argraw+0x54>
    80001c26:	048a                	slli	s1,s1,0x2
    80001c28:	00007717          	auipc	a4,0x7
    80001c2c:	bc870713          	addi	a4,a4,-1080 # 800087f0 <states.0+0x30>
    80001c30:	94ba                	add	s1,s1,a4
    80001c32:	409c                	lw	a5,0(s1)
    80001c34:	97ba                	add	a5,a5,a4
    80001c36:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c38:	6d3c                	ld	a5,88(a0)
    80001c3a:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c3c:	60e2                	ld	ra,24(sp)
    80001c3e:	6442                	ld	s0,16(sp)
    80001c40:	64a2                	ld	s1,8(sp)
    80001c42:	6105                	addi	sp,sp,32
    80001c44:	8082                	ret
    return p->trapframe->a1;
    80001c46:	6d3c                	ld	a5,88(a0)
    80001c48:	7fa8                	ld	a0,120(a5)
    80001c4a:	bfcd                	j	80001c3c <argraw+0x2c>
    return p->trapframe->a2;
    80001c4c:	6d3c                	ld	a5,88(a0)
    80001c4e:	63c8                	ld	a0,128(a5)
    80001c50:	b7f5                	j	80001c3c <argraw+0x2c>
    return p->trapframe->a3;
    80001c52:	6d3c                	ld	a5,88(a0)
    80001c54:	67c8                	ld	a0,136(a5)
    80001c56:	b7dd                	j	80001c3c <argraw+0x2c>
    return p->trapframe->a4;
    80001c58:	6d3c                	ld	a5,88(a0)
    80001c5a:	6bc8                	ld	a0,144(a5)
    80001c5c:	b7c5                	j	80001c3c <argraw+0x2c>
    return p->trapframe->a5;
    80001c5e:	6d3c                	ld	a5,88(a0)
    80001c60:	6fc8                	ld	a0,152(a5)
    80001c62:	bfe9                	j	80001c3c <argraw+0x2c>
  panic("argraw");
    80001c64:	00006517          	auipc	a0,0x6
    80001c68:	6bc50513          	addi	a0,a0,1724 # 80008320 <etext+0x320>
    80001c6c:	066040ef          	jal	80005cd2 <panic>

0000000080001c70 <fetchaddr>:
{
    80001c70:	1101                	addi	sp,sp,-32
    80001c72:	ec06                	sd	ra,24(sp)
    80001c74:	e822                	sd	s0,16(sp)
    80001c76:	e426                	sd	s1,8(sp)
    80001c78:	e04a                	sd	s2,0(sp)
    80001c7a:	1000                	addi	s0,sp,32
    80001c7c:	84aa                	mv	s1,a0
    80001c7e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c80:	962ff0ef          	jal	80000de2 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c84:	653c                	ld	a5,72(a0)
    80001c86:	02f4f663          	bgeu	s1,a5,80001cb2 <fetchaddr+0x42>
    80001c8a:	00848713          	addi	a4,s1,8
    80001c8e:	02e7e463          	bltu	a5,a4,80001cb6 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c92:	46a1                	li	a3,8
    80001c94:	8626                	mv	a2,s1
    80001c96:	85ca                	mv	a1,s2
    80001c98:	6928                	ld	a0,80(a0)
    80001c9a:	f31fe0ef          	jal	80000bca <copyin>
    80001c9e:	00a03533          	snez	a0,a0
    80001ca2:	40a0053b          	negw	a0,a0
}
    80001ca6:	60e2                	ld	ra,24(sp)
    80001ca8:	6442                	ld	s0,16(sp)
    80001caa:	64a2                	ld	s1,8(sp)
    80001cac:	6902                	ld	s2,0(sp)
    80001cae:	6105                	addi	sp,sp,32
    80001cb0:	8082                	ret
    return -1;
    80001cb2:	557d                	li	a0,-1
    80001cb4:	bfcd                	j	80001ca6 <fetchaddr+0x36>
    80001cb6:	557d                	li	a0,-1
    80001cb8:	b7fd                	j	80001ca6 <fetchaddr+0x36>

0000000080001cba <fetchstr>:
{
    80001cba:	7179                	addi	sp,sp,-48
    80001cbc:	f406                	sd	ra,40(sp)
    80001cbe:	f022                	sd	s0,32(sp)
    80001cc0:	ec26                	sd	s1,24(sp)
    80001cc2:	e84a                	sd	s2,16(sp)
    80001cc4:	e44e                	sd	s3,8(sp)
    80001cc6:	1800                	addi	s0,sp,48
    80001cc8:	89aa                	mv	s3,a0
    80001cca:	84ae                	mv	s1,a1
    80001ccc:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001cce:	914ff0ef          	jal	80000de2 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001cd2:	86ca                	mv	a3,s2
    80001cd4:	864e                	mv	a2,s3
    80001cd6:	85a6                	mv	a1,s1
    80001cd8:	6928                	ld	a0,80(a0)
    80001cda:	cd1fe0ef          	jal	800009aa <copyinstr>
    80001cde:	00054c63          	bltz	a0,80001cf6 <fetchstr+0x3c>
  return strlen(buf);
    80001ce2:	8526                	mv	a0,s1
    80001ce4:	e04fe0ef          	jal	800002e8 <strlen>
}
    80001ce8:	70a2                	ld	ra,40(sp)
    80001cea:	7402                	ld	s0,32(sp)
    80001cec:	64e2                	ld	s1,24(sp)
    80001cee:	6942                	ld	s2,16(sp)
    80001cf0:	69a2                	ld	s3,8(sp)
    80001cf2:	6145                	addi	sp,sp,48
    80001cf4:	8082                	ret
    return -1;
    80001cf6:	557d                	li	a0,-1
    80001cf8:	bfc5                	j	80001ce8 <fetchstr+0x2e>

0000000080001cfa <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001cfa:	1101                	addi	sp,sp,-32
    80001cfc:	ec06                	sd	ra,24(sp)
    80001cfe:	e822                	sd	s0,16(sp)
    80001d00:	e426                	sd	s1,8(sp)
    80001d02:	1000                	addi	s0,sp,32
    80001d04:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d06:	f0bff0ef          	jal	80001c10 <argraw>
    80001d0a:	c088                	sw	a0,0(s1)
}
    80001d0c:	60e2                	ld	ra,24(sp)
    80001d0e:	6442                	ld	s0,16(sp)
    80001d10:	64a2                	ld	s1,8(sp)
    80001d12:	6105                	addi	sp,sp,32
    80001d14:	8082                	ret

0000000080001d16 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001d16:	1101                	addi	sp,sp,-32
    80001d18:	ec06                	sd	ra,24(sp)
    80001d1a:	e822                	sd	s0,16(sp)
    80001d1c:	e426                	sd	s1,8(sp)
    80001d1e:	1000                	addi	s0,sp,32
    80001d20:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d22:	eefff0ef          	jal	80001c10 <argraw>
    80001d26:	e088                	sd	a0,0(s1)
}
    80001d28:	60e2                	ld	ra,24(sp)
    80001d2a:	6442                	ld	s0,16(sp)
    80001d2c:	64a2                	ld	s1,8(sp)
    80001d2e:	6105                	addi	sp,sp,32
    80001d30:	8082                	ret

0000000080001d32 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d32:	1101                	addi	sp,sp,-32
    80001d34:	ec06                	sd	ra,24(sp)
    80001d36:	e822                	sd	s0,16(sp)
    80001d38:	e426                	sd	s1,8(sp)
    80001d3a:	e04a                	sd	s2,0(sp)
    80001d3c:	1000                	addi	s0,sp,32
    80001d3e:	892e                	mv	s2,a1
    80001d40:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001d42:	ecfff0ef          	jal	80001c10 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001d46:	8626                	mv	a2,s1
    80001d48:	85ca                	mv	a1,s2
    80001d4a:	f71ff0ef          	jal	80001cba <fetchstr>
}
    80001d4e:	60e2                	ld	ra,24(sp)
    80001d50:	6442                	ld	s0,16(sp)
    80001d52:	64a2                	ld	s1,8(sp)
    80001d54:	6902                	ld	s2,0(sp)
    80001d56:	6105                	addi	sp,sp,32
    80001d58:	8082                	ret

0000000080001d5a <syscall>:
};


void
syscall(void)
{
    80001d5a:	1101                	addi	sp,sp,-32
    80001d5c:	ec06                	sd	ra,24(sp)
    80001d5e:	e822                	sd	s0,16(sp)
    80001d60:	e426                	sd	s1,8(sp)
    80001d62:	e04a                	sd	s2,0(sp)
    80001d64:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d66:	87cff0ef          	jal	80000de2 <myproc>
    80001d6a:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d6c:	05853903          	ld	s2,88(a0)
    80001d70:	0a893783          	ld	a5,168(s2)
    80001d74:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d78:	37fd                	addiw	a5,a5,-1
    80001d7a:	477d                	li	a4,31
    80001d7c:	00f76f63          	bltu	a4,a5,80001d9a <syscall+0x40>
    80001d80:	00369713          	slli	a4,a3,0x3
    80001d84:	00007797          	auipc	a5,0x7
    80001d88:	a8478793          	addi	a5,a5,-1404 # 80008808 <syscalls>
    80001d8c:	97ba                	add	a5,a5,a4
    80001d8e:	639c                	ld	a5,0(a5)
    80001d90:	c789                	beqz	a5,80001d9a <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d92:	9782                	jalr	a5
    80001d94:	06a93823          	sd	a0,112(s2)
    80001d98:	a829                	j	80001db2 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d9a:	15848613          	addi	a2,s1,344
    80001d9e:	588c                	lw	a1,48(s1)
    80001da0:	00006517          	auipc	a0,0x6
    80001da4:	58850513          	addi	a0,a0,1416 # 80008328 <etext+0x328>
    80001da8:	401030ef          	jal	800059a8 <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001dac:	6cbc                	ld	a5,88(s1)
    80001dae:	577d                	li	a4,-1
    80001db0:	fbb8                	sd	a4,112(a5)
  }
}
    80001db2:	60e2                	ld	ra,24(sp)
    80001db4:	6442                	ld	s0,16(sp)
    80001db6:	64a2                	ld	s1,8(sp)
    80001db8:	6902                	ld	s2,0(sp)
    80001dba:	6105                	addi	sp,sp,32
    80001dbc:	8082                	ret

0000000080001dbe <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001dbe:	1101                	addi	sp,sp,-32
    80001dc0:	ec06                	sd	ra,24(sp)
    80001dc2:	e822                	sd	s0,16(sp)
    80001dc4:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001dc6:	fec40593          	addi	a1,s0,-20
    80001dca:	4501                	li	a0,0
    80001dcc:	f2fff0ef          	jal	80001cfa <argint>
  kexit(n);
    80001dd0:	fec42503          	lw	a0,-20(s0)
    80001dd4:	f18ff0ef          	jal	800014ec <kexit>
  return 0;  // not reached
}
    80001dd8:	4501                	li	a0,0
    80001dda:	60e2                	ld	ra,24(sp)
    80001ddc:	6442                	ld	s0,16(sp)
    80001dde:	6105                	addi	sp,sp,32
    80001de0:	8082                	ret

0000000080001de2 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001de2:	1141                	addi	sp,sp,-16
    80001de4:	e406                	sd	ra,8(sp)
    80001de6:	e022                	sd	s0,0(sp)
    80001de8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001dea:	ff9fe0ef          	jal	80000de2 <myproc>
}
    80001dee:	5908                	lw	a0,48(a0)
    80001df0:	60a2                	ld	ra,8(sp)
    80001df2:	6402                	ld	s0,0(sp)
    80001df4:	0141                	addi	sp,sp,16
    80001df6:	8082                	ret

0000000080001df8 <sys_fork>:

uint64
sys_fork(void)
{
    80001df8:	1141                	addi	sp,sp,-16
    80001dfa:	e406                	sd	ra,8(sp)
    80001dfc:	e022                	sd	s0,0(sp)
    80001dfe:	0800                	addi	s0,sp,16
  return kfork();
    80001e00:	b38ff0ef          	jal	80001138 <kfork>
}
    80001e04:	60a2                	ld	ra,8(sp)
    80001e06:	6402                	ld	s0,0(sp)
    80001e08:	0141                	addi	sp,sp,16
    80001e0a:	8082                	ret

0000000080001e0c <sys_wait>:

uint64
sys_wait(void)
{
    80001e0c:	1101                	addi	sp,sp,-32
    80001e0e:	ec06                	sd	ra,24(sp)
    80001e10:	e822                	sd	s0,16(sp)
    80001e12:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e14:	fe840593          	addi	a1,s0,-24
    80001e18:	4501                	li	a0,0
    80001e1a:	efdff0ef          	jal	80001d16 <argaddr>
  return kwait(p);
    80001e1e:	fe843503          	ld	a0,-24(s0)
    80001e22:	825ff0ef          	jal	80001646 <kwait>
}
    80001e26:	60e2                	ld	ra,24(sp)
    80001e28:	6442                	ld	s0,16(sp)
    80001e2a:	6105                	addi	sp,sp,32
    80001e2c:	8082                	ret

0000000080001e2e <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e2e:	7179                	addi	sp,sp,-48
    80001e30:	f406                	sd	ra,40(sp)
    80001e32:	f022                	sd	s0,32(sp)
    80001e34:	ec26                	sd	s1,24(sp)
    80001e36:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001e38:	fd840593          	addi	a1,s0,-40
    80001e3c:	4501                	li	a0,0
    80001e3e:	ebdff0ef          	jal	80001cfa <argint>
  argint(1, &t);
    80001e42:	fdc40593          	addi	a1,s0,-36
    80001e46:	4505                	li	a0,1
    80001e48:	eb3ff0ef          	jal	80001cfa <argint>
  addr = myproc()->sz;
    80001e4c:	f97fe0ef          	jal	80000de2 <myproc>
    80001e50:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001e52:	fdc42703          	lw	a4,-36(s0)
    80001e56:	4785                	li	a5,1
    80001e58:	02f70163          	beq	a4,a5,80001e7a <sys_sbrk+0x4c>
    80001e5c:	fd842783          	lw	a5,-40(s0)
    80001e60:	0007cd63          	bltz	a5,80001e7a <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001e64:	97a6                	add	a5,a5,s1
    80001e66:	0297e863          	bltu	a5,s1,80001e96 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001e6a:	f79fe0ef          	jal	80000de2 <myproc>
    80001e6e:	fd842703          	lw	a4,-40(s0)
    80001e72:	653c                	ld	a5,72(a0)
    80001e74:	97ba                	add	a5,a5,a4
    80001e76:	e53c                	sd	a5,72(a0)
    80001e78:	a039                	j	80001e86 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001e7a:	fd842503          	lw	a0,-40(s0)
    80001e7e:	a6aff0ef          	jal	800010e8 <growproc>
    80001e82:	00054863          	bltz	a0,80001e92 <sys_sbrk+0x64>
  }
  return addr;
}
    80001e86:	8526                	mv	a0,s1
    80001e88:	70a2                	ld	ra,40(sp)
    80001e8a:	7402                	ld	s0,32(sp)
    80001e8c:	64e2                	ld	s1,24(sp)
    80001e8e:	6145                	addi	sp,sp,48
    80001e90:	8082                	ret
      return -1;
    80001e92:	54fd                	li	s1,-1
    80001e94:	bfcd                	j	80001e86 <sys_sbrk+0x58>
      return -1;
    80001e96:	54fd                	li	s1,-1
    80001e98:	b7fd                	j	80001e86 <sys_sbrk+0x58>

0000000080001e9a <sys_pause>:

uint64
sys_pause(void)
{
    80001e9a:	7139                	addi	sp,sp,-64
    80001e9c:	fc06                	sd	ra,56(sp)
    80001e9e:	f822                	sd	s0,48(sp)
    80001ea0:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001ea2:	fcc40593          	addi	a1,s0,-52
    80001ea6:	4501                	li	a0,0
    80001ea8:	e53ff0ef          	jal	80001cfa <argint>
  if(n < 0)
    80001eac:	fcc42783          	lw	a5,-52(s0)
    80001eb0:	0607c863          	bltz	a5,80001f20 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001eb4:	0000d517          	auipc	a0,0xd
    80001eb8:	92c50513          	addi	a0,a0,-1748 # 8000e7e0 <tickslock>
    80001ebc:	0d8040ef          	jal	80005f94 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001ec0:	fcc42783          	lw	a5,-52(s0)
    80001ec4:	c3b9                	beqz	a5,80001f0a <sys_pause+0x70>
    80001ec6:	f426                	sd	s1,40(sp)
    80001ec8:	f04a                	sd	s2,32(sp)
    80001eca:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001ecc:	00007997          	auipc	s3,0x7
    80001ed0:	a9c9a983          	lw	s3,-1380(s3) # 80008968 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001ed4:	0000d917          	auipc	s2,0xd
    80001ed8:	90c90913          	addi	s2,s2,-1780 # 8000e7e0 <tickslock>
    80001edc:	00007497          	auipc	s1,0x7
    80001ee0:	a8c48493          	addi	s1,s1,-1396 # 80008968 <ticks>
    if(killed(myproc())){
    80001ee4:	efffe0ef          	jal	80000de2 <myproc>
    80001ee8:	f34ff0ef          	jal	8000161c <killed>
    80001eec:	ed0d                	bnez	a0,80001f26 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001eee:	85ca                	mv	a1,s2
    80001ef0:	8526                	mv	a0,s1
    80001ef2:	ceeff0ef          	jal	800013e0 <sleep>
  while(ticks - ticks0 < n){
    80001ef6:	409c                	lw	a5,0(s1)
    80001ef8:	413787bb          	subw	a5,a5,s3
    80001efc:	fcc42703          	lw	a4,-52(s0)
    80001f00:	fee7e2e3          	bltu	a5,a4,80001ee4 <sys_pause+0x4a>
    80001f04:	74a2                	ld	s1,40(sp)
    80001f06:	7902                	ld	s2,32(sp)
    80001f08:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001f0a:	0000d517          	auipc	a0,0xd
    80001f0e:	8d650513          	addi	a0,a0,-1834 # 8000e7e0 <tickslock>
    80001f12:	116040ef          	jal	80006028 <release>
  return 0;
    80001f16:	4501                	li	a0,0
}
    80001f18:	70e2                	ld	ra,56(sp)
    80001f1a:	7442                	ld	s0,48(sp)
    80001f1c:	6121                	addi	sp,sp,64
    80001f1e:	8082                	ret
    n = 0;
    80001f20:	fc042623          	sw	zero,-52(s0)
    80001f24:	bf41                	j	80001eb4 <sys_pause+0x1a>
      release(&tickslock);
    80001f26:	0000d517          	auipc	a0,0xd
    80001f2a:	8ba50513          	addi	a0,a0,-1862 # 8000e7e0 <tickslock>
    80001f2e:	0fa040ef          	jal	80006028 <release>
      return -1;
    80001f32:	557d                	li	a0,-1
    80001f34:	74a2                	ld	s1,40(sp)
    80001f36:	7902                	ld	s2,32(sp)
    80001f38:	69e2                	ld	s3,24(sp)
    80001f3a:	bff9                	j	80001f18 <sys_pause+0x7e>

0000000080001f3c <sys_kill>:

uint64
sys_kill(void)
{
    80001f3c:	1101                	addi	sp,sp,-32
    80001f3e:	ec06                	sd	ra,24(sp)
    80001f40:	e822                	sd	s0,16(sp)
    80001f42:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f44:	fec40593          	addi	a1,s0,-20
    80001f48:	4501                	li	a0,0
    80001f4a:	db1ff0ef          	jal	80001cfa <argint>
  return kkill(pid);
    80001f4e:	fec42503          	lw	a0,-20(s0)
    80001f52:	e40ff0ef          	jal	80001592 <kkill>
}
    80001f56:	60e2                	ld	ra,24(sp)
    80001f58:	6442                	ld	s0,16(sp)
    80001f5a:	6105                	addi	sp,sp,32
    80001f5c:	8082                	ret

0000000080001f5e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f5e:	1101                	addi	sp,sp,-32
    80001f60:	ec06                	sd	ra,24(sp)
    80001f62:	e822                	sd	s0,16(sp)
    80001f64:	e426                	sd	s1,8(sp)
    80001f66:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f68:	0000d517          	auipc	a0,0xd
    80001f6c:	87850513          	addi	a0,a0,-1928 # 8000e7e0 <tickslock>
    80001f70:	024040ef          	jal	80005f94 <acquire>
  xticks = ticks;
    80001f74:	00007797          	auipc	a5,0x7
    80001f78:	9f47a783          	lw	a5,-1548(a5) # 80008968 <ticks>
    80001f7c:	84be                	mv	s1,a5
  release(&tickslock);
    80001f7e:	0000d517          	auipc	a0,0xd
    80001f82:	86250513          	addi	a0,a0,-1950 # 8000e7e0 <tickslock>
    80001f86:	0a2040ef          	jal	80006028 <release>
  return xticks;
}
    80001f8a:	02049513          	slli	a0,s1,0x20
    80001f8e:	9101                	srli	a0,a0,0x20
    80001f90:	60e2                	ld	ra,24(sp)
    80001f92:	6442                	ld	s0,16(sp)
    80001f94:	64a2                	ld	s1,8(sp)
    80001f96:	6105                	addi	sp,sp,32
    80001f98:	8082                	ret

0000000080001f9a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f9a:	7179                	addi	sp,sp,-48
    80001f9c:	f406                	sd	ra,40(sp)
    80001f9e:	f022                	sd	s0,32(sp)
    80001fa0:	ec26                	sd	s1,24(sp)
    80001fa2:	e84a                	sd	s2,16(sp)
    80001fa4:	e44e                	sd	s3,8(sp)
    80001fa6:	e052                	sd	s4,0(sp)
    80001fa8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001faa:	00006597          	auipc	a1,0x6
    80001fae:	39e58593          	addi	a1,a1,926 # 80008348 <etext+0x348>
    80001fb2:	0000d517          	auipc	a0,0xd
    80001fb6:	84650513          	addi	a0,a0,-1978 # 8000e7f8 <bcache>
    80001fba:	751030ef          	jal	80005f0a <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001fbe:	00015797          	auipc	a5,0x15
    80001fc2:	83a78793          	addi	a5,a5,-1990 # 800167f8 <bcache+0x8000>
    80001fc6:	00015717          	auipc	a4,0x15
    80001fca:	a9a70713          	addi	a4,a4,-1382 # 80016a60 <bcache+0x8268>
    80001fce:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001fd2:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fd6:	0000d497          	auipc	s1,0xd
    80001fda:	83a48493          	addi	s1,s1,-1990 # 8000e810 <bcache+0x18>
    b->next = bcache.head.next;
    80001fde:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001fe0:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001fe2:	00006a17          	auipc	s4,0x6
    80001fe6:	36ea0a13          	addi	s4,s4,878 # 80008350 <etext+0x350>
    b->next = bcache.head.next;
    80001fea:	2b893783          	ld	a5,696(s2)
    80001fee:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001ff0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001ff4:	85d2                	mv	a1,s4
    80001ff6:	01048513          	addi	a0,s1,16
    80001ffa:	328010ef          	jal	80003322 <initsleeplock>
    bcache.head.next->prev = b;
    80001ffe:	2b893783          	ld	a5,696(s2)
    80002002:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002004:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002008:	45848493          	addi	s1,s1,1112
    8000200c:	fd349fe3          	bne	s1,s3,80001fea <binit+0x50>
  }
}
    80002010:	70a2                	ld	ra,40(sp)
    80002012:	7402                	ld	s0,32(sp)
    80002014:	64e2                	ld	s1,24(sp)
    80002016:	6942                	ld	s2,16(sp)
    80002018:	69a2                	ld	s3,8(sp)
    8000201a:	6a02                	ld	s4,0(sp)
    8000201c:	6145                	addi	sp,sp,48
    8000201e:	8082                	ret

0000000080002020 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002020:	7179                	addi	sp,sp,-48
    80002022:	f406                	sd	ra,40(sp)
    80002024:	f022                	sd	s0,32(sp)
    80002026:	ec26                	sd	s1,24(sp)
    80002028:	e84a                	sd	s2,16(sp)
    8000202a:	e44e                	sd	s3,8(sp)
    8000202c:	1800                	addi	s0,sp,48
    8000202e:	892a                	mv	s2,a0
    80002030:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002032:	0000c517          	auipc	a0,0xc
    80002036:	7c650513          	addi	a0,a0,1990 # 8000e7f8 <bcache>
    8000203a:	75b030ef          	jal	80005f94 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000203e:	00015497          	auipc	s1,0x15
    80002042:	a724b483          	ld	s1,-1422(s1) # 80016ab0 <bcache+0x82b8>
    80002046:	00015797          	auipc	a5,0x15
    8000204a:	a1a78793          	addi	a5,a5,-1510 # 80016a60 <bcache+0x8268>
    8000204e:	02f48b63          	beq	s1,a5,80002084 <bread+0x64>
    80002052:	873e                	mv	a4,a5
    80002054:	a021                	j	8000205c <bread+0x3c>
    80002056:	68a4                	ld	s1,80(s1)
    80002058:	02e48663          	beq	s1,a4,80002084 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000205c:	449c                	lw	a5,8(s1)
    8000205e:	ff279ce3          	bne	a5,s2,80002056 <bread+0x36>
    80002062:	44dc                	lw	a5,12(s1)
    80002064:	ff3799e3          	bne	a5,s3,80002056 <bread+0x36>
      b->refcnt++;
    80002068:	40bc                	lw	a5,64(s1)
    8000206a:	2785                	addiw	a5,a5,1
    8000206c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000206e:	0000c517          	auipc	a0,0xc
    80002072:	78a50513          	addi	a0,a0,1930 # 8000e7f8 <bcache>
    80002076:	7b3030ef          	jal	80006028 <release>
      acquiresleep(&b->lock);
    8000207a:	01048513          	addi	a0,s1,16
    8000207e:	2da010ef          	jal	80003358 <acquiresleep>
      return b;
    80002082:	a889                	j	800020d4 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002084:	00015497          	auipc	s1,0x15
    80002088:	a244b483          	ld	s1,-1500(s1) # 80016aa8 <bcache+0x82b0>
    8000208c:	00015797          	auipc	a5,0x15
    80002090:	9d478793          	addi	a5,a5,-1580 # 80016a60 <bcache+0x8268>
    80002094:	00f48863          	beq	s1,a5,800020a4 <bread+0x84>
    80002098:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000209a:	40bc                	lw	a5,64(s1)
    8000209c:	cb91                	beqz	a5,800020b0 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000209e:	64a4                	ld	s1,72(s1)
    800020a0:	fee49de3          	bne	s1,a4,8000209a <bread+0x7a>
  panic("bget: no buffers");
    800020a4:	00006517          	auipc	a0,0x6
    800020a8:	2b450513          	addi	a0,a0,692 # 80008358 <etext+0x358>
    800020ac:	427030ef          	jal	80005cd2 <panic>
      b->dev = dev;
    800020b0:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800020b4:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800020b8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800020bc:	4785                	li	a5,1
    800020be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800020c0:	0000c517          	auipc	a0,0xc
    800020c4:	73850513          	addi	a0,a0,1848 # 8000e7f8 <bcache>
    800020c8:	761030ef          	jal	80006028 <release>
      acquiresleep(&b->lock);
    800020cc:	01048513          	addi	a0,s1,16
    800020d0:	288010ef          	jal	80003358 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800020d4:	409c                	lw	a5,0(s1)
    800020d6:	cb89                	beqz	a5,800020e8 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800020d8:	8526                	mv	a0,s1
    800020da:	70a2                	ld	ra,40(sp)
    800020dc:	7402                	ld	s0,32(sp)
    800020de:	64e2                	ld	s1,24(sp)
    800020e0:	6942                	ld	s2,16(sp)
    800020e2:	69a2                	ld	s3,8(sp)
    800020e4:	6145                	addi	sp,sp,48
    800020e6:	8082                	ret
    virtio_disk_rw(b, 0);
    800020e8:	4581                	li	a1,0
    800020ea:	8526                	mv	a0,s1
    800020ec:	305020ef          	jal	80004bf0 <virtio_disk_rw>
    b->valid = 1;
    800020f0:	4785                	li	a5,1
    800020f2:	c09c                	sw	a5,0(s1)
  return b;
    800020f4:	b7d5                	j	800020d8 <bread+0xb8>

00000000800020f6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800020f6:	1101                	addi	sp,sp,-32
    800020f8:	ec06                	sd	ra,24(sp)
    800020fa:	e822                	sd	s0,16(sp)
    800020fc:	e426                	sd	s1,8(sp)
    800020fe:	1000                	addi	s0,sp,32
    80002100:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002102:	0541                	addi	a0,a0,16
    80002104:	2d2010ef          	jal	800033d6 <holdingsleep>
    80002108:	c911                	beqz	a0,8000211c <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000210a:	4585                	li	a1,1
    8000210c:	8526                	mv	a0,s1
    8000210e:	2e3020ef          	jal	80004bf0 <virtio_disk_rw>
}
    80002112:	60e2                	ld	ra,24(sp)
    80002114:	6442                	ld	s0,16(sp)
    80002116:	64a2                	ld	s1,8(sp)
    80002118:	6105                	addi	sp,sp,32
    8000211a:	8082                	ret
    panic("bwrite");
    8000211c:	00006517          	auipc	a0,0x6
    80002120:	25450513          	addi	a0,a0,596 # 80008370 <etext+0x370>
    80002124:	3af030ef          	jal	80005cd2 <panic>

0000000080002128 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002128:	1101                	addi	sp,sp,-32
    8000212a:	ec06                	sd	ra,24(sp)
    8000212c:	e822                	sd	s0,16(sp)
    8000212e:	e426                	sd	s1,8(sp)
    80002130:	e04a                	sd	s2,0(sp)
    80002132:	1000                	addi	s0,sp,32
    80002134:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002136:	01050913          	addi	s2,a0,16
    8000213a:	854a                	mv	a0,s2
    8000213c:	29a010ef          	jal	800033d6 <holdingsleep>
    80002140:	c125                	beqz	a0,800021a0 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002142:	854a                	mv	a0,s2
    80002144:	25a010ef          	jal	8000339e <releasesleep>

  acquire(&bcache.lock);
    80002148:	0000c517          	auipc	a0,0xc
    8000214c:	6b050513          	addi	a0,a0,1712 # 8000e7f8 <bcache>
    80002150:	645030ef          	jal	80005f94 <acquire>
  b->refcnt--;
    80002154:	40bc                	lw	a5,64(s1)
    80002156:	37fd                	addiw	a5,a5,-1
    80002158:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000215a:	e79d                	bnez	a5,80002188 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000215c:	68b8                	ld	a4,80(s1)
    8000215e:	64bc                	ld	a5,72(s1)
    80002160:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002162:	68b8                	ld	a4,80(s1)
    80002164:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002166:	00014797          	auipc	a5,0x14
    8000216a:	69278793          	addi	a5,a5,1682 # 800167f8 <bcache+0x8000>
    8000216e:	2b87b703          	ld	a4,696(a5)
    80002172:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002174:	00015717          	auipc	a4,0x15
    80002178:	8ec70713          	addi	a4,a4,-1812 # 80016a60 <bcache+0x8268>
    8000217c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000217e:	2b87b703          	ld	a4,696(a5)
    80002182:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002184:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002188:	0000c517          	auipc	a0,0xc
    8000218c:	67050513          	addi	a0,a0,1648 # 8000e7f8 <bcache>
    80002190:	699030ef          	jal	80006028 <release>
}
    80002194:	60e2                	ld	ra,24(sp)
    80002196:	6442                	ld	s0,16(sp)
    80002198:	64a2                	ld	s1,8(sp)
    8000219a:	6902                	ld	s2,0(sp)
    8000219c:	6105                	addi	sp,sp,32
    8000219e:	8082                	ret
    panic("brelse");
    800021a0:	00006517          	auipc	a0,0x6
    800021a4:	1d850513          	addi	a0,a0,472 # 80008378 <etext+0x378>
    800021a8:	32b030ef          	jal	80005cd2 <panic>

00000000800021ac <bpin>:

void
bpin(struct buf *b) {
    800021ac:	1101                	addi	sp,sp,-32
    800021ae:	ec06                	sd	ra,24(sp)
    800021b0:	e822                	sd	s0,16(sp)
    800021b2:	e426                	sd	s1,8(sp)
    800021b4:	1000                	addi	s0,sp,32
    800021b6:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021b8:	0000c517          	auipc	a0,0xc
    800021bc:	64050513          	addi	a0,a0,1600 # 8000e7f8 <bcache>
    800021c0:	5d5030ef          	jal	80005f94 <acquire>
  b->refcnt++;
    800021c4:	40bc                	lw	a5,64(s1)
    800021c6:	2785                	addiw	a5,a5,1
    800021c8:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021ca:	0000c517          	auipc	a0,0xc
    800021ce:	62e50513          	addi	a0,a0,1582 # 8000e7f8 <bcache>
    800021d2:	657030ef          	jal	80006028 <release>
}
    800021d6:	60e2                	ld	ra,24(sp)
    800021d8:	6442                	ld	s0,16(sp)
    800021da:	64a2                	ld	s1,8(sp)
    800021dc:	6105                	addi	sp,sp,32
    800021de:	8082                	ret

00000000800021e0 <bunpin>:

void
bunpin(struct buf *b) {
    800021e0:	1101                	addi	sp,sp,-32
    800021e2:	ec06                	sd	ra,24(sp)
    800021e4:	e822                	sd	s0,16(sp)
    800021e6:	e426                	sd	s1,8(sp)
    800021e8:	1000                	addi	s0,sp,32
    800021ea:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800021ec:	0000c517          	auipc	a0,0xc
    800021f0:	60c50513          	addi	a0,a0,1548 # 8000e7f8 <bcache>
    800021f4:	5a1030ef          	jal	80005f94 <acquire>
  b->refcnt--;
    800021f8:	40bc                	lw	a5,64(s1)
    800021fa:	37fd                	addiw	a5,a5,-1
    800021fc:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021fe:	0000c517          	auipc	a0,0xc
    80002202:	5fa50513          	addi	a0,a0,1530 # 8000e7f8 <bcache>
    80002206:	623030ef          	jal	80006028 <release>
}
    8000220a:	60e2                	ld	ra,24(sp)
    8000220c:	6442                	ld	s0,16(sp)
    8000220e:	64a2                	ld	s1,8(sp)
    80002210:	6105                	addi	sp,sp,32
    80002212:	8082                	ret

0000000080002214 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002214:	1101                	addi	sp,sp,-32
    80002216:	ec06                	sd	ra,24(sp)
    80002218:	e822                	sd	s0,16(sp)
    8000221a:	e426                	sd	s1,8(sp)
    8000221c:	e04a                	sd	s2,0(sp)
    8000221e:	1000                	addi	s0,sp,32
    80002220:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002222:	00d5d79b          	srliw	a5,a1,0xd
    80002226:	00015597          	auipc	a1,0x15
    8000222a:	cae5a583          	lw	a1,-850(a1) # 80016ed4 <sb+0x1c>
    8000222e:	9dbd                	addw	a1,a1,a5
    80002230:	df1ff0ef          	jal	80002020 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002234:	0074f713          	andi	a4,s1,7
    80002238:	4785                	li	a5,1
    8000223a:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000223e:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002240:	90d9                	srli	s1,s1,0x36
    80002242:	00950733          	add	a4,a0,s1
    80002246:	05874703          	lbu	a4,88(a4)
    8000224a:	00e7f6b3          	and	a3,a5,a4
    8000224e:	c29d                	beqz	a3,80002274 <bfree+0x60>
    80002250:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002252:	94aa                	add	s1,s1,a0
    80002254:	fff7c793          	not	a5,a5
    80002258:	8f7d                	and	a4,a4,a5
    8000225a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000225e:	000010ef          	jal	8000325e <log_write>
  brelse(bp);
    80002262:	854a                	mv	a0,s2
    80002264:	ec5ff0ef          	jal	80002128 <brelse>
}
    80002268:	60e2                	ld	ra,24(sp)
    8000226a:	6442                	ld	s0,16(sp)
    8000226c:	64a2                	ld	s1,8(sp)
    8000226e:	6902                	ld	s2,0(sp)
    80002270:	6105                	addi	sp,sp,32
    80002272:	8082                	ret
    panic("freeing free block");
    80002274:	00006517          	auipc	a0,0x6
    80002278:	10c50513          	addi	a0,a0,268 # 80008380 <etext+0x380>
    8000227c:	257030ef          	jal	80005cd2 <panic>

0000000080002280 <balloc>:
{
    80002280:	715d                	addi	sp,sp,-80
    80002282:	e486                	sd	ra,72(sp)
    80002284:	e0a2                	sd	s0,64(sp)
    80002286:	fc26                	sd	s1,56(sp)
    80002288:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000228a:	00015797          	auipc	a5,0x15
    8000228e:	c327a783          	lw	a5,-974(a5) # 80016ebc <sb+0x4>
    80002292:	0e078263          	beqz	a5,80002376 <balloc+0xf6>
    80002296:	f84a                	sd	s2,48(sp)
    80002298:	f44e                	sd	s3,40(sp)
    8000229a:	f052                	sd	s4,32(sp)
    8000229c:	ec56                	sd	s5,24(sp)
    8000229e:	e85a                	sd	s6,16(sp)
    800022a0:	e45e                	sd	s7,8(sp)
    800022a2:	e062                	sd	s8,0(sp)
    800022a4:	8baa                	mv	s7,a0
    800022a6:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800022a8:	00015b17          	auipc	s6,0x15
    800022ac:	c10b0b13          	addi	s6,s6,-1008 # 80016eb8 <sb>
      m = 1 << (bi % 8);
    800022b0:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022b2:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800022b4:	6c09                	lui	s8,0x2
    800022b6:	a09d                	j	8000231c <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800022b8:	97ca                	add	a5,a5,s2
    800022ba:	8e55                	or	a2,a2,a3
    800022bc:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800022c0:	854a                	mv	a0,s2
    800022c2:	79d000ef          	jal	8000325e <log_write>
        brelse(bp);
    800022c6:	854a                	mv	a0,s2
    800022c8:	e61ff0ef          	jal	80002128 <brelse>
  bp = bread(dev, bno);
    800022cc:	85a6                	mv	a1,s1
    800022ce:	855e                	mv	a0,s7
    800022d0:	d51ff0ef          	jal	80002020 <bread>
    800022d4:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800022d6:	40000613          	li	a2,1024
    800022da:	4581                	li	a1,0
    800022dc:	05850513          	addi	a0,a0,88
    800022e0:	e7ffd0ef          	jal	8000015e <memset>
  log_write(bp);
    800022e4:	854a                	mv	a0,s2
    800022e6:	779000ef          	jal	8000325e <log_write>
  brelse(bp);
    800022ea:	854a                	mv	a0,s2
    800022ec:	e3dff0ef          	jal	80002128 <brelse>
}
    800022f0:	7942                	ld	s2,48(sp)
    800022f2:	79a2                	ld	s3,40(sp)
    800022f4:	7a02                	ld	s4,32(sp)
    800022f6:	6ae2                	ld	s5,24(sp)
    800022f8:	6b42                	ld	s6,16(sp)
    800022fa:	6ba2                	ld	s7,8(sp)
    800022fc:	6c02                	ld	s8,0(sp)
}
    800022fe:	8526                	mv	a0,s1
    80002300:	60a6                	ld	ra,72(sp)
    80002302:	6406                	ld	s0,64(sp)
    80002304:	74e2                	ld	s1,56(sp)
    80002306:	6161                	addi	sp,sp,80
    80002308:	8082                	ret
    brelse(bp);
    8000230a:	854a                	mv	a0,s2
    8000230c:	e1dff0ef          	jal	80002128 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002310:	015c0abb          	addw	s5,s8,s5
    80002314:	004b2783          	lw	a5,4(s6)
    80002318:	04faf863          	bgeu	s5,a5,80002368 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    8000231c:	40dad59b          	sraiw	a1,s5,0xd
    80002320:	01cb2783          	lw	a5,28(s6)
    80002324:	9dbd                	addw	a1,a1,a5
    80002326:	855e                	mv	a0,s7
    80002328:	cf9ff0ef          	jal	80002020 <bread>
    8000232c:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000232e:	004b2503          	lw	a0,4(s6)
    80002332:	84d6                	mv	s1,s5
    80002334:	4701                	li	a4,0
    80002336:	fca4fae3          	bgeu	s1,a0,8000230a <balloc+0x8a>
      m = 1 << (bi % 8);
    8000233a:	00777693          	andi	a3,a4,7
    8000233e:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002342:	41f7579b          	sraiw	a5,a4,0x1f
    80002346:	01d7d79b          	srliw	a5,a5,0x1d
    8000234a:	9fb9                	addw	a5,a5,a4
    8000234c:	4037d79b          	sraiw	a5,a5,0x3
    80002350:	00f90633          	add	a2,s2,a5
    80002354:	05864603          	lbu	a2,88(a2)
    80002358:	00c6f5b3          	and	a1,a3,a2
    8000235c:	ddb1                	beqz	a1,800022b8 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000235e:	2705                	addiw	a4,a4,1
    80002360:	2485                	addiw	s1,s1,1
    80002362:	fd471ae3          	bne	a4,s4,80002336 <balloc+0xb6>
    80002366:	b755                	j	8000230a <balloc+0x8a>
    80002368:	7942                	ld	s2,48(sp)
    8000236a:	79a2                	ld	s3,40(sp)
    8000236c:	7a02                	ld	s4,32(sp)
    8000236e:	6ae2                	ld	s5,24(sp)
    80002370:	6b42                	ld	s6,16(sp)
    80002372:	6ba2                	ld	s7,8(sp)
    80002374:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002376:	00006517          	auipc	a0,0x6
    8000237a:	02250513          	addi	a0,a0,34 # 80008398 <etext+0x398>
    8000237e:	62a030ef          	jal	800059a8 <printf>
  return 0;
    80002382:	4481                	li	s1,0
    80002384:	bfad                	j	800022fe <balloc+0x7e>

0000000080002386 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002386:	7179                	addi	sp,sp,-48
    80002388:	f406                	sd	ra,40(sp)
    8000238a:	f022                	sd	s0,32(sp)
    8000238c:	ec26                	sd	s1,24(sp)
    8000238e:	e84a                	sd	s2,16(sp)
    80002390:	e44e                	sd	s3,8(sp)
    80002392:	1800                	addi	s0,sp,48
    80002394:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002396:	47ad                	li	a5,11
    80002398:	02b7e363          	bltu	a5,a1,800023be <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000239c:	02059793          	slli	a5,a1,0x20
    800023a0:	01e7d593          	srli	a1,a5,0x1e
    800023a4:	00b509b3          	add	s3,a0,a1
    800023a8:	0509a483          	lw	s1,80(s3)
    800023ac:	e0b5                	bnez	s1,80002410 <bmap+0x8a>
      addr = balloc(ip->dev);
    800023ae:	4108                	lw	a0,0(a0)
    800023b0:	ed1ff0ef          	jal	80002280 <balloc>
    800023b4:	84aa                	mv	s1,a0
      if(addr == 0)
    800023b6:	cd29                	beqz	a0,80002410 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    800023b8:	04a9a823          	sw	a0,80(s3)
    800023bc:	a891                	j	80002410 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800023be:	ff45879b          	addiw	a5,a1,-12
    800023c2:	873e                	mv	a4,a5
    800023c4:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    800023c6:	0ff00793          	li	a5,255
    800023ca:	06e7e763          	bltu	a5,a4,80002438 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800023ce:	08052483          	lw	s1,128(a0)
    800023d2:	e891                	bnez	s1,800023e6 <bmap+0x60>
      addr = balloc(ip->dev);
    800023d4:	4108                	lw	a0,0(a0)
    800023d6:	eabff0ef          	jal	80002280 <balloc>
    800023da:	84aa                	mv	s1,a0
      if(addr == 0)
    800023dc:	c915                	beqz	a0,80002410 <bmap+0x8a>
    800023de:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800023e0:	08a92023          	sw	a0,128(s2)
    800023e4:	a011                	j	800023e8 <bmap+0x62>
    800023e6:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800023e8:	85a6                	mv	a1,s1
    800023ea:	00092503          	lw	a0,0(s2)
    800023ee:	c33ff0ef          	jal	80002020 <bread>
    800023f2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023f4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800023f8:	02099713          	slli	a4,s3,0x20
    800023fc:	01e75593          	srli	a1,a4,0x1e
    80002400:	97ae                	add	a5,a5,a1
    80002402:	89be                	mv	s3,a5
    80002404:	4384                	lw	s1,0(a5)
    80002406:	cc89                	beqz	s1,80002420 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002408:	8552                	mv	a0,s4
    8000240a:	d1fff0ef          	jal	80002128 <brelse>
    return addr;
    8000240e:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002410:	8526                	mv	a0,s1
    80002412:	70a2                	ld	ra,40(sp)
    80002414:	7402                	ld	s0,32(sp)
    80002416:	64e2                	ld	s1,24(sp)
    80002418:	6942                	ld	s2,16(sp)
    8000241a:	69a2                	ld	s3,8(sp)
    8000241c:	6145                	addi	sp,sp,48
    8000241e:	8082                	ret
      addr = balloc(ip->dev);
    80002420:	00092503          	lw	a0,0(s2)
    80002424:	e5dff0ef          	jal	80002280 <balloc>
    80002428:	84aa                	mv	s1,a0
      if(addr){
    8000242a:	dd79                	beqz	a0,80002408 <bmap+0x82>
        a[bn] = addr;
    8000242c:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002430:	8552                	mv	a0,s4
    80002432:	62d000ef          	jal	8000325e <log_write>
    80002436:	bfc9                	j	80002408 <bmap+0x82>
    80002438:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    8000243a:	00006517          	auipc	a0,0x6
    8000243e:	f7650513          	addi	a0,a0,-138 # 800083b0 <etext+0x3b0>
    80002442:	091030ef          	jal	80005cd2 <panic>

0000000080002446 <iget>:
{
    80002446:	7179                	addi	sp,sp,-48
    80002448:	f406                	sd	ra,40(sp)
    8000244a:	f022                	sd	s0,32(sp)
    8000244c:	ec26                	sd	s1,24(sp)
    8000244e:	e84a                	sd	s2,16(sp)
    80002450:	e44e                	sd	s3,8(sp)
    80002452:	e052                	sd	s4,0(sp)
    80002454:	1800                	addi	s0,sp,48
    80002456:	892a                	mv	s2,a0
    80002458:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000245a:	00015517          	auipc	a0,0x15
    8000245e:	a7e50513          	addi	a0,a0,-1410 # 80016ed8 <itable>
    80002462:	333030ef          	jal	80005f94 <acquire>
  empty = 0;
    80002466:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002468:	00015497          	auipc	s1,0x15
    8000246c:	a8848493          	addi	s1,s1,-1400 # 80016ef0 <itable+0x18>
    80002470:	00016697          	auipc	a3,0x16
    80002474:	51068693          	addi	a3,a3,1296 # 80018980 <log>
    80002478:	a809                	j	8000248a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000247a:	e781                	bnez	a5,80002482 <iget+0x3c>
    8000247c:	00099363          	bnez	s3,80002482 <iget+0x3c>
      empty = ip;
    80002480:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002482:	08848493          	addi	s1,s1,136
    80002486:	02d48563          	beq	s1,a3,800024b0 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000248a:	449c                	lw	a5,8(s1)
    8000248c:	fef057e3          	blez	a5,8000247a <iget+0x34>
    80002490:	4098                	lw	a4,0(s1)
    80002492:	ff2718e3          	bne	a4,s2,80002482 <iget+0x3c>
    80002496:	40d8                	lw	a4,4(s1)
    80002498:	ff4715e3          	bne	a4,s4,80002482 <iget+0x3c>
      ip->ref++;
    8000249c:	2785                	addiw	a5,a5,1
    8000249e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024a0:	00015517          	auipc	a0,0x15
    800024a4:	a3850513          	addi	a0,a0,-1480 # 80016ed8 <itable>
    800024a8:	381030ef          	jal	80006028 <release>
      return ip;
    800024ac:	89a6                	mv	s3,s1
    800024ae:	a015                	j	800024d2 <iget+0x8c>
  if(empty == 0)
    800024b0:	02098a63          	beqz	s3,800024e4 <iget+0x9e>
  ip->dev = dev;
    800024b4:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    800024b8:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    800024bc:	4785                	li	a5,1
    800024be:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    800024c2:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    800024c6:	00015517          	auipc	a0,0x15
    800024ca:	a1250513          	addi	a0,a0,-1518 # 80016ed8 <itable>
    800024ce:	35b030ef          	jal	80006028 <release>
}
    800024d2:	854e                	mv	a0,s3
    800024d4:	70a2                	ld	ra,40(sp)
    800024d6:	7402                	ld	s0,32(sp)
    800024d8:	64e2                	ld	s1,24(sp)
    800024da:	6942                	ld	s2,16(sp)
    800024dc:	69a2                	ld	s3,8(sp)
    800024de:	6a02                	ld	s4,0(sp)
    800024e0:	6145                	addi	sp,sp,48
    800024e2:	8082                	ret
    panic("iget: no inodes");
    800024e4:	00006517          	auipc	a0,0x6
    800024e8:	ee450513          	addi	a0,a0,-284 # 800083c8 <etext+0x3c8>
    800024ec:	7e6030ef          	jal	80005cd2 <panic>

00000000800024f0 <iinit>:
{
    800024f0:	7179                	addi	sp,sp,-48
    800024f2:	f406                	sd	ra,40(sp)
    800024f4:	f022                	sd	s0,32(sp)
    800024f6:	ec26                	sd	s1,24(sp)
    800024f8:	e84a                	sd	s2,16(sp)
    800024fa:	e44e                	sd	s3,8(sp)
    800024fc:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800024fe:	00006597          	auipc	a1,0x6
    80002502:	eda58593          	addi	a1,a1,-294 # 800083d8 <etext+0x3d8>
    80002506:	00015517          	auipc	a0,0x15
    8000250a:	9d250513          	addi	a0,a0,-1582 # 80016ed8 <itable>
    8000250e:	1fd030ef          	jal	80005f0a <initlock>
  for(i = 0; i < NINODE; i++) {
    80002512:	00015497          	auipc	s1,0x15
    80002516:	9ee48493          	addi	s1,s1,-1554 # 80016f00 <itable+0x28>
    8000251a:	00016997          	auipc	s3,0x16
    8000251e:	47698993          	addi	s3,s3,1142 # 80018990 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002522:	00006917          	auipc	s2,0x6
    80002526:	ebe90913          	addi	s2,s2,-322 # 800083e0 <etext+0x3e0>
    8000252a:	85ca                	mv	a1,s2
    8000252c:	8526                	mv	a0,s1
    8000252e:	5f5000ef          	jal	80003322 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002532:	08848493          	addi	s1,s1,136
    80002536:	ff349ae3          	bne	s1,s3,8000252a <iinit+0x3a>
}
    8000253a:	70a2                	ld	ra,40(sp)
    8000253c:	7402                	ld	s0,32(sp)
    8000253e:	64e2                	ld	s1,24(sp)
    80002540:	6942                	ld	s2,16(sp)
    80002542:	69a2                	ld	s3,8(sp)
    80002544:	6145                	addi	sp,sp,48
    80002546:	8082                	ret

0000000080002548 <ialloc>:
{
    80002548:	7139                	addi	sp,sp,-64
    8000254a:	fc06                	sd	ra,56(sp)
    8000254c:	f822                	sd	s0,48(sp)
    8000254e:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002550:	00015717          	auipc	a4,0x15
    80002554:	97472703          	lw	a4,-1676(a4) # 80016ec4 <sb+0xc>
    80002558:	4785                	li	a5,1
    8000255a:	06e7f063          	bgeu	a5,a4,800025ba <ialloc+0x72>
    8000255e:	f426                	sd	s1,40(sp)
    80002560:	f04a                	sd	s2,32(sp)
    80002562:	ec4e                	sd	s3,24(sp)
    80002564:	e852                	sd	s4,16(sp)
    80002566:	e456                	sd	s5,8(sp)
    80002568:	e05a                	sd	s6,0(sp)
    8000256a:	8aaa                	mv	s5,a0
    8000256c:	8b2e                	mv	s6,a1
    8000256e:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002570:	00015a17          	auipc	s4,0x15
    80002574:	948a0a13          	addi	s4,s4,-1720 # 80016eb8 <sb>
    80002578:	00495593          	srli	a1,s2,0x4
    8000257c:	018a2783          	lw	a5,24(s4)
    80002580:	9dbd                	addw	a1,a1,a5
    80002582:	8556                	mv	a0,s5
    80002584:	a9dff0ef          	jal	80002020 <bread>
    80002588:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000258a:	05850993          	addi	s3,a0,88
    8000258e:	00f97793          	andi	a5,s2,15
    80002592:	079a                	slli	a5,a5,0x6
    80002594:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002596:	00099783          	lh	a5,0(s3)
    8000259a:	cb9d                	beqz	a5,800025d0 <ialloc+0x88>
    brelse(bp);
    8000259c:	b8dff0ef          	jal	80002128 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025a0:	0905                	addi	s2,s2,1
    800025a2:	00ca2703          	lw	a4,12(s4)
    800025a6:	0009079b          	sext.w	a5,s2
    800025aa:	fce7e7e3          	bltu	a5,a4,80002578 <ialloc+0x30>
    800025ae:	74a2                	ld	s1,40(sp)
    800025b0:	7902                	ld	s2,32(sp)
    800025b2:	69e2                	ld	s3,24(sp)
    800025b4:	6a42                	ld	s4,16(sp)
    800025b6:	6aa2                	ld	s5,8(sp)
    800025b8:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    800025ba:	00006517          	auipc	a0,0x6
    800025be:	e2e50513          	addi	a0,a0,-466 # 800083e8 <etext+0x3e8>
    800025c2:	3e6030ef          	jal	800059a8 <printf>
  return 0;
    800025c6:	4501                	li	a0,0
}
    800025c8:	70e2                	ld	ra,56(sp)
    800025ca:	7442                	ld	s0,48(sp)
    800025cc:	6121                	addi	sp,sp,64
    800025ce:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    800025d0:	04000613          	li	a2,64
    800025d4:	4581                	li	a1,0
    800025d6:	854e                	mv	a0,s3
    800025d8:	b87fd0ef          	jal	8000015e <memset>
      dip->type = type;
    800025dc:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800025e0:	8526                	mv	a0,s1
    800025e2:	47d000ef          	jal	8000325e <log_write>
      brelse(bp);
    800025e6:	8526                	mv	a0,s1
    800025e8:	b41ff0ef          	jal	80002128 <brelse>
      return iget(dev, inum);
    800025ec:	0009059b          	sext.w	a1,s2
    800025f0:	8556                	mv	a0,s5
    800025f2:	e55ff0ef          	jal	80002446 <iget>
    800025f6:	74a2                	ld	s1,40(sp)
    800025f8:	7902                	ld	s2,32(sp)
    800025fa:	69e2                	ld	s3,24(sp)
    800025fc:	6a42                	ld	s4,16(sp)
    800025fe:	6aa2                	ld	s5,8(sp)
    80002600:	6b02                	ld	s6,0(sp)
    80002602:	b7d9                	j	800025c8 <ialloc+0x80>

0000000080002604 <iupdate>:
{
    80002604:	1101                	addi	sp,sp,-32
    80002606:	ec06                	sd	ra,24(sp)
    80002608:	e822                	sd	s0,16(sp)
    8000260a:	e426                	sd	s1,8(sp)
    8000260c:	e04a                	sd	s2,0(sp)
    8000260e:	1000                	addi	s0,sp,32
    80002610:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002612:	415c                	lw	a5,4(a0)
    80002614:	0047d79b          	srliw	a5,a5,0x4
    80002618:	00015597          	auipc	a1,0x15
    8000261c:	8b85a583          	lw	a1,-1864(a1) # 80016ed0 <sb+0x18>
    80002620:	9dbd                	addw	a1,a1,a5
    80002622:	4108                	lw	a0,0(a0)
    80002624:	9fdff0ef          	jal	80002020 <bread>
    80002628:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000262a:	05850793          	addi	a5,a0,88
    8000262e:	40d8                	lw	a4,4(s1)
    80002630:	8b3d                	andi	a4,a4,15
    80002632:	071a                	slli	a4,a4,0x6
    80002634:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002636:	04449703          	lh	a4,68(s1)
    8000263a:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000263e:	04649703          	lh	a4,70(s1)
    80002642:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002646:	04849703          	lh	a4,72(s1)
    8000264a:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000264e:	04a49703          	lh	a4,74(s1)
    80002652:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002656:	44f8                	lw	a4,76(s1)
    80002658:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000265a:	03400613          	li	a2,52
    8000265e:	05048593          	addi	a1,s1,80
    80002662:	00c78513          	addi	a0,a5,12
    80002666:	b59fd0ef          	jal	800001be <memmove>
  log_write(bp);
    8000266a:	854a                	mv	a0,s2
    8000266c:	3f3000ef          	jal	8000325e <log_write>
  brelse(bp);
    80002670:	854a                	mv	a0,s2
    80002672:	ab7ff0ef          	jal	80002128 <brelse>
}
    80002676:	60e2                	ld	ra,24(sp)
    80002678:	6442                	ld	s0,16(sp)
    8000267a:	64a2                	ld	s1,8(sp)
    8000267c:	6902                	ld	s2,0(sp)
    8000267e:	6105                	addi	sp,sp,32
    80002680:	8082                	ret

0000000080002682 <idup>:
{
    80002682:	1101                	addi	sp,sp,-32
    80002684:	ec06                	sd	ra,24(sp)
    80002686:	e822                	sd	s0,16(sp)
    80002688:	e426                	sd	s1,8(sp)
    8000268a:	1000                	addi	s0,sp,32
    8000268c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000268e:	00015517          	auipc	a0,0x15
    80002692:	84a50513          	addi	a0,a0,-1974 # 80016ed8 <itable>
    80002696:	0ff030ef          	jal	80005f94 <acquire>
  ip->ref++;
    8000269a:	449c                	lw	a5,8(s1)
    8000269c:	2785                	addiw	a5,a5,1
    8000269e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026a0:	00015517          	auipc	a0,0x15
    800026a4:	83850513          	addi	a0,a0,-1992 # 80016ed8 <itable>
    800026a8:	181030ef          	jal	80006028 <release>
}
    800026ac:	8526                	mv	a0,s1
    800026ae:	60e2                	ld	ra,24(sp)
    800026b0:	6442                	ld	s0,16(sp)
    800026b2:	64a2                	ld	s1,8(sp)
    800026b4:	6105                	addi	sp,sp,32
    800026b6:	8082                	ret

00000000800026b8 <ilock>:
{
    800026b8:	1101                	addi	sp,sp,-32
    800026ba:	ec06                	sd	ra,24(sp)
    800026bc:	e822                	sd	s0,16(sp)
    800026be:	e426                	sd	s1,8(sp)
    800026c0:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    800026c2:	cd19                	beqz	a0,800026e0 <ilock+0x28>
    800026c4:	84aa                	mv	s1,a0
    800026c6:	451c                	lw	a5,8(a0)
    800026c8:	00f05c63          	blez	a5,800026e0 <ilock+0x28>
  acquiresleep(&ip->lock);
    800026cc:	0541                	addi	a0,a0,16
    800026ce:	48b000ef          	jal	80003358 <acquiresleep>
  if(ip->valid == 0){
    800026d2:	40bc                	lw	a5,64(s1)
    800026d4:	cf89                	beqz	a5,800026ee <ilock+0x36>
}
    800026d6:	60e2                	ld	ra,24(sp)
    800026d8:	6442                	ld	s0,16(sp)
    800026da:	64a2                	ld	s1,8(sp)
    800026dc:	6105                	addi	sp,sp,32
    800026de:	8082                	ret
    800026e0:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800026e2:	00006517          	auipc	a0,0x6
    800026e6:	d1e50513          	addi	a0,a0,-738 # 80008400 <etext+0x400>
    800026ea:	5e8030ef          	jal	80005cd2 <panic>
    800026ee:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026f0:	40dc                	lw	a5,4(s1)
    800026f2:	0047d79b          	srliw	a5,a5,0x4
    800026f6:	00014597          	auipc	a1,0x14
    800026fa:	7da5a583          	lw	a1,2010(a1) # 80016ed0 <sb+0x18>
    800026fe:	9dbd                	addw	a1,a1,a5
    80002700:	4088                	lw	a0,0(s1)
    80002702:	91fff0ef          	jal	80002020 <bread>
    80002706:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002708:	05850593          	addi	a1,a0,88
    8000270c:	40dc                	lw	a5,4(s1)
    8000270e:	8bbd                	andi	a5,a5,15
    80002710:	079a                	slli	a5,a5,0x6
    80002712:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002714:	00059783          	lh	a5,0(a1)
    80002718:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000271c:	00259783          	lh	a5,2(a1)
    80002720:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002724:	00459783          	lh	a5,4(a1)
    80002728:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000272c:	00659783          	lh	a5,6(a1)
    80002730:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002734:	459c                	lw	a5,8(a1)
    80002736:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002738:	03400613          	li	a2,52
    8000273c:	05b1                	addi	a1,a1,12
    8000273e:	05048513          	addi	a0,s1,80
    80002742:	a7dfd0ef          	jal	800001be <memmove>
    brelse(bp);
    80002746:	854a                	mv	a0,s2
    80002748:	9e1ff0ef          	jal	80002128 <brelse>
    ip->valid = 1;
    8000274c:	4785                	li	a5,1
    8000274e:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002750:	04449783          	lh	a5,68(s1)
    80002754:	c399                	beqz	a5,8000275a <ilock+0xa2>
    80002756:	6902                	ld	s2,0(sp)
    80002758:	bfbd                	j	800026d6 <ilock+0x1e>
      panic("ilock: no type");
    8000275a:	00006517          	auipc	a0,0x6
    8000275e:	cae50513          	addi	a0,a0,-850 # 80008408 <etext+0x408>
    80002762:	570030ef          	jal	80005cd2 <panic>

0000000080002766 <iunlock>:
{
    80002766:	1101                	addi	sp,sp,-32
    80002768:	ec06                	sd	ra,24(sp)
    8000276a:	e822                	sd	s0,16(sp)
    8000276c:	e426                	sd	s1,8(sp)
    8000276e:	e04a                	sd	s2,0(sp)
    80002770:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002772:	c505                	beqz	a0,8000279a <iunlock+0x34>
    80002774:	84aa                	mv	s1,a0
    80002776:	01050913          	addi	s2,a0,16
    8000277a:	854a                	mv	a0,s2
    8000277c:	45b000ef          	jal	800033d6 <holdingsleep>
    80002780:	cd09                	beqz	a0,8000279a <iunlock+0x34>
    80002782:	449c                	lw	a5,8(s1)
    80002784:	00f05b63          	blez	a5,8000279a <iunlock+0x34>
  releasesleep(&ip->lock);
    80002788:	854a                	mv	a0,s2
    8000278a:	415000ef          	jal	8000339e <releasesleep>
}
    8000278e:	60e2                	ld	ra,24(sp)
    80002790:	6442                	ld	s0,16(sp)
    80002792:	64a2                	ld	s1,8(sp)
    80002794:	6902                	ld	s2,0(sp)
    80002796:	6105                	addi	sp,sp,32
    80002798:	8082                	ret
    panic("iunlock");
    8000279a:	00006517          	auipc	a0,0x6
    8000279e:	c7e50513          	addi	a0,a0,-898 # 80008418 <etext+0x418>
    800027a2:	530030ef          	jal	80005cd2 <panic>

00000000800027a6 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027a6:	7179                	addi	sp,sp,-48
    800027a8:	f406                	sd	ra,40(sp)
    800027aa:	f022                	sd	s0,32(sp)
    800027ac:	ec26                	sd	s1,24(sp)
    800027ae:	e84a                	sd	s2,16(sp)
    800027b0:	e44e                	sd	s3,8(sp)
    800027b2:	1800                	addi	s0,sp,48
    800027b4:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    800027b6:	05050493          	addi	s1,a0,80
    800027ba:	08050913          	addi	s2,a0,128
    800027be:	a021                	j	800027c6 <itrunc+0x20>
    800027c0:	0491                	addi	s1,s1,4
    800027c2:	01248b63          	beq	s1,s2,800027d8 <itrunc+0x32>
    if(ip->addrs[i]){
    800027c6:	408c                	lw	a1,0(s1)
    800027c8:	dde5                	beqz	a1,800027c0 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    800027ca:	0009a503          	lw	a0,0(s3)
    800027ce:	a47ff0ef          	jal	80002214 <bfree>
      ip->addrs[i] = 0;
    800027d2:	0004a023          	sw	zero,0(s1)
    800027d6:	b7ed                	j	800027c0 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800027d8:	0809a583          	lw	a1,128(s3)
    800027dc:	ed89                	bnez	a1,800027f6 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800027de:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800027e2:	854e                	mv	a0,s3
    800027e4:	e21ff0ef          	jal	80002604 <iupdate>
}
    800027e8:	70a2                	ld	ra,40(sp)
    800027ea:	7402                	ld	s0,32(sp)
    800027ec:	64e2                	ld	s1,24(sp)
    800027ee:	6942                	ld	s2,16(sp)
    800027f0:	69a2                	ld	s3,8(sp)
    800027f2:	6145                	addi	sp,sp,48
    800027f4:	8082                	ret
    800027f6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800027f8:	0009a503          	lw	a0,0(s3)
    800027fc:	825ff0ef          	jal	80002020 <bread>
    80002800:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002802:	05850493          	addi	s1,a0,88
    80002806:	45850913          	addi	s2,a0,1112
    8000280a:	a021                	j	80002812 <itrunc+0x6c>
    8000280c:	0491                	addi	s1,s1,4
    8000280e:	01248963          	beq	s1,s2,80002820 <itrunc+0x7a>
      if(a[j])
    80002812:	408c                	lw	a1,0(s1)
    80002814:	dde5                	beqz	a1,8000280c <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002816:	0009a503          	lw	a0,0(s3)
    8000281a:	9fbff0ef          	jal	80002214 <bfree>
    8000281e:	b7fd                	j	8000280c <itrunc+0x66>
    brelse(bp);
    80002820:	8552                	mv	a0,s4
    80002822:	907ff0ef          	jal	80002128 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002826:	0809a583          	lw	a1,128(s3)
    8000282a:	0009a503          	lw	a0,0(s3)
    8000282e:	9e7ff0ef          	jal	80002214 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002832:	0809a023          	sw	zero,128(s3)
    80002836:	6a02                	ld	s4,0(sp)
    80002838:	b75d                	j	800027de <itrunc+0x38>

000000008000283a <iput>:
{
    8000283a:	1101                	addi	sp,sp,-32
    8000283c:	ec06                	sd	ra,24(sp)
    8000283e:	e822                	sd	s0,16(sp)
    80002840:	e426                	sd	s1,8(sp)
    80002842:	1000                	addi	s0,sp,32
    80002844:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002846:	00014517          	auipc	a0,0x14
    8000284a:	69250513          	addi	a0,a0,1682 # 80016ed8 <itable>
    8000284e:	746030ef          	jal	80005f94 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002852:	4498                	lw	a4,8(s1)
    80002854:	4785                	li	a5,1
    80002856:	02f70063          	beq	a4,a5,80002876 <iput+0x3c>
  ip->ref--;
    8000285a:	449c                	lw	a5,8(s1)
    8000285c:	37fd                	addiw	a5,a5,-1
    8000285e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002860:	00014517          	auipc	a0,0x14
    80002864:	67850513          	addi	a0,a0,1656 # 80016ed8 <itable>
    80002868:	7c0030ef          	jal	80006028 <release>
}
    8000286c:	60e2                	ld	ra,24(sp)
    8000286e:	6442                	ld	s0,16(sp)
    80002870:	64a2                	ld	s1,8(sp)
    80002872:	6105                	addi	sp,sp,32
    80002874:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002876:	40bc                	lw	a5,64(s1)
    80002878:	d3ed                	beqz	a5,8000285a <iput+0x20>
    8000287a:	04a49783          	lh	a5,74(s1)
    8000287e:	fff1                	bnez	a5,8000285a <iput+0x20>
    80002880:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002882:	01048793          	addi	a5,s1,16
    80002886:	893e                	mv	s2,a5
    80002888:	853e                	mv	a0,a5
    8000288a:	2cf000ef          	jal	80003358 <acquiresleep>
    release(&itable.lock);
    8000288e:	00014517          	auipc	a0,0x14
    80002892:	64a50513          	addi	a0,a0,1610 # 80016ed8 <itable>
    80002896:	792030ef          	jal	80006028 <release>
    itrunc(ip);
    8000289a:	8526                	mv	a0,s1
    8000289c:	f0bff0ef          	jal	800027a6 <itrunc>
    ip->type = 0;
    800028a0:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    800028a4:	8526                	mv	a0,s1
    800028a6:	d5fff0ef          	jal	80002604 <iupdate>
    ip->valid = 0;
    800028aa:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    800028ae:	854a                	mv	a0,s2
    800028b0:	2ef000ef          	jal	8000339e <releasesleep>
    acquire(&itable.lock);
    800028b4:	00014517          	auipc	a0,0x14
    800028b8:	62450513          	addi	a0,a0,1572 # 80016ed8 <itable>
    800028bc:	6d8030ef          	jal	80005f94 <acquire>
    800028c0:	6902                	ld	s2,0(sp)
    800028c2:	bf61                	j	8000285a <iput+0x20>

00000000800028c4 <iunlockput>:
{
    800028c4:	1101                	addi	sp,sp,-32
    800028c6:	ec06                	sd	ra,24(sp)
    800028c8:	e822                	sd	s0,16(sp)
    800028ca:	e426                	sd	s1,8(sp)
    800028cc:	1000                	addi	s0,sp,32
    800028ce:	84aa                	mv	s1,a0
  iunlock(ip);
    800028d0:	e97ff0ef          	jal	80002766 <iunlock>
  iput(ip);
    800028d4:	8526                	mv	a0,s1
    800028d6:	f65ff0ef          	jal	8000283a <iput>
}
    800028da:	60e2                	ld	ra,24(sp)
    800028dc:	6442                	ld	s0,16(sp)
    800028de:	64a2                	ld	s1,8(sp)
    800028e0:	6105                	addi	sp,sp,32
    800028e2:	8082                	ret

00000000800028e4 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800028e4:	00014717          	auipc	a4,0x14
    800028e8:	5e072703          	lw	a4,1504(a4) # 80016ec4 <sb+0xc>
    800028ec:	4785                	li	a5,1
    800028ee:	0ae7fe63          	bgeu	a5,a4,800029aa <ireclaim+0xc6>
{
    800028f2:	7139                	addi	sp,sp,-64
    800028f4:	fc06                	sd	ra,56(sp)
    800028f6:	f822                	sd	s0,48(sp)
    800028f8:	f426                	sd	s1,40(sp)
    800028fa:	f04a                	sd	s2,32(sp)
    800028fc:	ec4e                	sd	s3,24(sp)
    800028fe:	e852                	sd	s4,16(sp)
    80002900:	e456                	sd	s5,8(sp)
    80002902:	e05a                	sd	s6,0(sp)
    80002904:	0080                	addi	s0,sp,64
    80002906:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002908:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    8000290a:	00014a17          	auipc	s4,0x14
    8000290e:	5aea0a13          	addi	s4,s4,1454 # 80016eb8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002912:	00006b17          	auipc	s6,0x6
    80002916:	b0eb0b13          	addi	s6,s6,-1266 # 80008420 <etext+0x420>
    8000291a:	a099                	j	80002960 <ireclaim+0x7c>
    8000291c:	85ce                	mv	a1,s3
    8000291e:	855a                	mv	a0,s6
    80002920:	088030ef          	jal	800059a8 <printf>
      ip = iget(dev, inum);
    80002924:	85ce                	mv	a1,s3
    80002926:	8556                	mv	a0,s5
    80002928:	b1fff0ef          	jal	80002446 <iget>
    8000292c:	89aa                	mv	s3,a0
    brelse(bp);
    8000292e:	854a                	mv	a0,s2
    80002930:	ff8ff0ef          	jal	80002128 <brelse>
    if (ip) {
    80002934:	00098f63          	beqz	s3,80002952 <ireclaim+0x6e>
      begin_op();
    80002938:	78c000ef          	jal	800030c4 <begin_op>
      ilock(ip);
    8000293c:	854e                	mv	a0,s3
    8000293e:	d7bff0ef          	jal	800026b8 <ilock>
      iunlock(ip);
    80002942:	854e                	mv	a0,s3
    80002944:	e23ff0ef          	jal	80002766 <iunlock>
      iput(ip);
    80002948:	854e                	mv	a0,s3
    8000294a:	ef1ff0ef          	jal	8000283a <iput>
      end_op();
    8000294e:	7e6000ef          	jal	80003134 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002952:	0485                	addi	s1,s1,1
    80002954:	00ca2703          	lw	a4,12(s4)
    80002958:	0004879b          	sext.w	a5,s1
    8000295c:	02e7fd63          	bgeu	a5,a4,80002996 <ireclaim+0xb2>
    80002960:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002964:	0044d593          	srli	a1,s1,0x4
    80002968:	018a2783          	lw	a5,24(s4)
    8000296c:	9dbd                	addw	a1,a1,a5
    8000296e:	8556                	mv	a0,s5
    80002970:	eb0ff0ef          	jal	80002020 <bread>
    80002974:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002976:	05850793          	addi	a5,a0,88
    8000297a:	00f9f713          	andi	a4,s3,15
    8000297e:	071a                	slli	a4,a4,0x6
    80002980:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002982:	00079703          	lh	a4,0(a5)
    80002986:	c701                	beqz	a4,8000298e <ireclaim+0xaa>
    80002988:	00679783          	lh	a5,6(a5)
    8000298c:	dbc1                	beqz	a5,8000291c <ireclaim+0x38>
    brelse(bp);
    8000298e:	854a                	mv	a0,s2
    80002990:	f98ff0ef          	jal	80002128 <brelse>
    if (ip) {
    80002994:	bf7d                	j	80002952 <ireclaim+0x6e>
}
    80002996:	70e2                	ld	ra,56(sp)
    80002998:	7442                	ld	s0,48(sp)
    8000299a:	74a2                	ld	s1,40(sp)
    8000299c:	7902                	ld	s2,32(sp)
    8000299e:	69e2                	ld	s3,24(sp)
    800029a0:	6a42                	ld	s4,16(sp)
    800029a2:	6aa2                	ld	s5,8(sp)
    800029a4:	6b02                	ld	s6,0(sp)
    800029a6:	6121                	addi	sp,sp,64
    800029a8:	8082                	ret
    800029aa:	8082                	ret

00000000800029ac <fsinit>:
fsinit(int dev) {
    800029ac:	1101                	addi	sp,sp,-32
    800029ae:	ec06                	sd	ra,24(sp)
    800029b0:	e822                	sd	s0,16(sp)
    800029b2:	e426                	sd	s1,8(sp)
    800029b4:	e04a                	sd	s2,0(sp)
    800029b6:	1000                	addi	s0,sp,32
    800029b8:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029ba:	4585                	li	a1,1
    800029bc:	e64ff0ef          	jal	80002020 <bread>
    800029c0:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029c2:	02000613          	li	a2,32
    800029c6:	05850593          	addi	a1,a0,88
    800029ca:	00014517          	auipc	a0,0x14
    800029ce:	4ee50513          	addi	a0,a0,1262 # 80016eb8 <sb>
    800029d2:	fecfd0ef          	jal	800001be <memmove>
  brelse(bp);
    800029d6:	8526                	mv	a0,s1
    800029d8:	f50ff0ef          	jal	80002128 <brelse>
  if(sb.magic != FSMAGIC)
    800029dc:	00014717          	auipc	a4,0x14
    800029e0:	4dc72703          	lw	a4,1244(a4) # 80016eb8 <sb>
    800029e4:	102037b7          	lui	a5,0x10203
    800029e8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029ec:	02f71263          	bne	a4,a5,80002a10 <fsinit+0x64>
  initlog(dev, &sb);
    800029f0:	00014597          	auipc	a1,0x14
    800029f4:	4c858593          	addi	a1,a1,1224 # 80016eb8 <sb>
    800029f8:	854a                	mv	a0,s2
    800029fa:	648000ef          	jal	80003042 <initlog>
  ireclaim(dev);
    800029fe:	854a                	mv	a0,s2
    80002a00:	ee5ff0ef          	jal	800028e4 <ireclaim>
}
    80002a04:	60e2                	ld	ra,24(sp)
    80002a06:	6442                	ld	s0,16(sp)
    80002a08:	64a2                	ld	s1,8(sp)
    80002a0a:	6902                	ld	s2,0(sp)
    80002a0c:	6105                	addi	sp,sp,32
    80002a0e:	8082                	ret
    panic("invalid file system");
    80002a10:	00006517          	auipc	a0,0x6
    80002a14:	a3050513          	addi	a0,a0,-1488 # 80008440 <etext+0x440>
    80002a18:	2ba030ef          	jal	80005cd2 <panic>

0000000080002a1c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002a1c:	1141                	addi	sp,sp,-16
    80002a1e:	e406                	sd	ra,8(sp)
    80002a20:	e022                	sd	s0,0(sp)
    80002a22:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002a24:	411c                	lw	a5,0(a0)
    80002a26:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002a28:	415c                	lw	a5,4(a0)
    80002a2a:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002a2c:	04451783          	lh	a5,68(a0)
    80002a30:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002a34:	04a51783          	lh	a5,74(a0)
    80002a38:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002a3c:	04c56783          	lwu	a5,76(a0)
    80002a40:	e99c                	sd	a5,16(a1)
}
    80002a42:	60a2                	ld	ra,8(sp)
    80002a44:	6402                	ld	s0,0(sp)
    80002a46:	0141                	addi	sp,sp,16
    80002a48:	8082                	ret

0000000080002a4a <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002a4a:	457c                	lw	a5,76(a0)
    80002a4c:	0ed7e663          	bltu	a5,a3,80002b38 <readi+0xee>
{
    80002a50:	7159                	addi	sp,sp,-112
    80002a52:	f486                	sd	ra,104(sp)
    80002a54:	f0a2                	sd	s0,96(sp)
    80002a56:	eca6                	sd	s1,88(sp)
    80002a58:	e0d2                	sd	s4,64(sp)
    80002a5a:	fc56                	sd	s5,56(sp)
    80002a5c:	f85a                	sd	s6,48(sp)
    80002a5e:	f45e                	sd	s7,40(sp)
    80002a60:	1880                	addi	s0,sp,112
    80002a62:	8b2a                	mv	s6,a0
    80002a64:	8bae                	mv	s7,a1
    80002a66:	8a32                	mv	s4,a2
    80002a68:	84b6                	mv	s1,a3
    80002a6a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a6c:	9f35                	addw	a4,a4,a3
    return 0;
    80002a6e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a70:	0ad76b63          	bltu	a4,a3,80002b26 <readi+0xdc>
    80002a74:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a76:	00e7f463          	bgeu	a5,a4,80002a7e <readi+0x34>
    n = ip->size - off;
    80002a7a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a7e:	080a8b63          	beqz	s5,80002b14 <readi+0xca>
    80002a82:	e8ca                	sd	s2,80(sp)
    80002a84:	f062                	sd	s8,32(sp)
    80002a86:	ec66                	sd	s9,24(sp)
    80002a88:	e86a                	sd	s10,16(sp)
    80002a8a:	e46e                	sd	s11,8(sp)
    80002a8c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a8e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a92:	5c7d                	li	s8,-1
    80002a94:	a80d                	j	80002ac6 <readi+0x7c>
    80002a96:	020d1d93          	slli	s11,s10,0x20
    80002a9a:	020ddd93          	srli	s11,s11,0x20
    80002a9e:	05890613          	addi	a2,s2,88
    80002aa2:	86ee                	mv	a3,s11
    80002aa4:	963e                	add	a2,a2,a5
    80002aa6:	85d2                	mv	a1,s4
    80002aa8:	855e                	mv	a0,s7
    80002aaa:	c91fe0ef          	jal	8000173a <either_copyout>
    80002aae:	05850363          	beq	a0,s8,80002af4 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002ab2:	854a                	mv	a0,s2
    80002ab4:	e74ff0ef          	jal	80002128 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ab8:	013d09bb          	addw	s3,s10,s3
    80002abc:	009d04bb          	addw	s1,s10,s1
    80002ac0:	9a6e                	add	s4,s4,s11
    80002ac2:	0559f363          	bgeu	s3,s5,80002b08 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002ac6:	00a4d59b          	srliw	a1,s1,0xa
    80002aca:	855a                	mv	a0,s6
    80002acc:	8bbff0ef          	jal	80002386 <bmap>
    80002ad0:	85aa                	mv	a1,a0
    if(addr == 0)
    80002ad2:	c139                	beqz	a0,80002b18 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002ad4:	000b2503          	lw	a0,0(s6)
    80002ad8:	d48ff0ef          	jal	80002020 <bread>
    80002adc:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ade:	3ff4f793          	andi	a5,s1,1023
    80002ae2:	40fc873b          	subw	a4,s9,a5
    80002ae6:	413a86bb          	subw	a3,s5,s3
    80002aea:	8d3a                	mv	s10,a4
    80002aec:	fae6f5e3          	bgeu	a3,a4,80002a96 <readi+0x4c>
    80002af0:	8d36                	mv	s10,a3
    80002af2:	b755                	j	80002a96 <readi+0x4c>
      brelse(bp);
    80002af4:	854a                	mv	a0,s2
    80002af6:	e32ff0ef          	jal	80002128 <brelse>
      tot = -1;
    80002afa:	59fd                	li	s3,-1
      break;
    80002afc:	6946                	ld	s2,80(sp)
    80002afe:	7c02                	ld	s8,32(sp)
    80002b00:	6ce2                	ld	s9,24(sp)
    80002b02:	6d42                	ld	s10,16(sp)
    80002b04:	6da2                	ld	s11,8(sp)
    80002b06:	a831                	j	80002b22 <readi+0xd8>
    80002b08:	6946                	ld	s2,80(sp)
    80002b0a:	7c02                	ld	s8,32(sp)
    80002b0c:	6ce2                	ld	s9,24(sp)
    80002b0e:	6d42                	ld	s10,16(sp)
    80002b10:	6da2                	ld	s11,8(sp)
    80002b12:	a801                	j	80002b22 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b14:	89d6                	mv	s3,s5
    80002b16:	a031                	j	80002b22 <readi+0xd8>
    80002b18:	6946                	ld	s2,80(sp)
    80002b1a:	7c02                	ld	s8,32(sp)
    80002b1c:	6ce2                	ld	s9,24(sp)
    80002b1e:	6d42                	ld	s10,16(sp)
    80002b20:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002b22:	854e                	mv	a0,s3
    80002b24:	69a6                	ld	s3,72(sp)
}
    80002b26:	70a6                	ld	ra,104(sp)
    80002b28:	7406                	ld	s0,96(sp)
    80002b2a:	64e6                	ld	s1,88(sp)
    80002b2c:	6a06                	ld	s4,64(sp)
    80002b2e:	7ae2                	ld	s5,56(sp)
    80002b30:	7b42                	ld	s6,48(sp)
    80002b32:	7ba2                	ld	s7,40(sp)
    80002b34:	6165                	addi	sp,sp,112
    80002b36:	8082                	ret
    return 0;
    80002b38:	4501                	li	a0,0
}
    80002b3a:	8082                	ret

0000000080002b3c <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b3c:	457c                	lw	a5,76(a0)
    80002b3e:	0ed7eb63          	bltu	a5,a3,80002c34 <writei+0xf8>
{
    80002b42:	7159                	addi	sp,sp,-112
    80002b44:	f486                	sd	ra,104(sp)
    80002b46:	f0a2                	sd	s0,96(sp)
    80002b48:	e8ca                	sd	s2,80(sp)
    80002b4a:	e0d2                	sd	s4,64(sp)
    80002b4c:	fc56                	sd	s5,56(sp)
    80002b4e:	f85a                	sd	s6,48(sp)
    80002b50:	f45e                	sd	s7,40(sp)
    80002b52:	1880                	addi	s0,sp,112
    80002b54:	8aaa                	mv	s5,a0
    80002b56:	8bae                	mv	s7,a1
    80002b58:	8a32                	mv	s4,a2
    80002b5a:	8936                	mv	s2,a3
    80002b5c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b5e:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b62:	00043737          	lui	a4,0x43
    80002b66:	0cf76963          	bltu	a4,a5,80002c38 <writei+0xfc>
    80002b6a:	0cd7e763          	bltu	a5,a3,80002c38 <writei+0xfc>
    80002b6e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b70:	0a0b0a63          	beqz	s6,80002c24 <writei+0xe8>
    80002b74:	eca6                	sd	s1,88(sp)
    80002b76:	f062                	sd	s8,32(sp)
    80002b78:	ec66                	sd	s9,24(sp)
    80002b7a:	e86a                	sd	s10,16(sp)
    80002b7c:	e46e                	sd	s11,8(sp)
    80002b7e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b80:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b84:	5c7d                	li	s8,-1
    80002b86:	a825                	j	80002bbe <writei+0x82>
    80002b88:	020d1d93          	slli	s11,s10,0x20
    80002b8c:	020ddd93          	srli	s11,s11,0x20
    80002b90:	05848513          	addi	a0,s1,88
    80002b94:	86ee                	mv	a3,s11
    80002b96:	8652                	mv	a2,s4
    80002b98:	85de                	mv	a1,s7
    80002b9a:	953e                	add	a0,a0,a5
    80002b9c:	be9fe0ef          	jal	80001784 <either_copyin>
    80002ba0:	05850663          	beq	a0,s8,80002bec <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002ba4:	8526                	mv	a0,s1
    80002ba6:	6b8000ef          	jal	8000325e <log_write>
    brelse(bp);
    80002baa:	8526                	mv	a0,s1
    80002bac:	d7cff0ef          	jal	80002128 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bb0:	013d09bb          	addw	s3,s10,s3
    80002bb4:	012d093b          	addw	s2,s10,s2
    80002bb8:	9a6e                	add	s4,s4,s11
    80002bba:	0369fc63          	bgeu	s3,s6,80002bf2 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002bbe:	00a9559b          	srliw	a1,s2,0xa
    80002bc2:	8556                	mv	a0,s5
    80002bc4:	fc2ff0ef          	jal	80002386 <bmap>
    80002bc8:	85aa                	mv	a1,a0
    if(addr == 0)
    80002bca:	c505                	beqz	a0,80002bf2 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002bcc:	000aa503          	lw	a0,0(s5)
    80002bd0:	c50ff0ef          	jal	80002020 <bread>
    80002bd4:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bd6:	3ff97793          	andi	a5,s2,1023
    80002bda:	40fc873b          	subw	a4,s9,a5
    80002bde:	413b06bb          	subw	a3,s6,s3
    80002be2:	8d3a                	mv	s10,a4
    80002be4:	fae6f2e3          	bgeu	a3,a4,80002b88 <writei+0x4c>
    80002be8:	8d36                	mv	s10,a3
    80002bea:	bf79                	j	80002b88 <writei+0x4c>
      brelse(bp);
    80002bec:	8526                	mv	a0,s1
    80002bee:	d3aff0ef          	jal	80002128 <brelse>
  }

  if(off > ip->size)
    80002bf2:	04caa783          	lw	a5,76(s5)
    80002bf6:	0327f963          	bgeu	a5,s2,80002c28 <writei+0xec>
    ip->size = off;
    80002bfa:	052aa623          	sw	s2,76(s5)
    80002bfe:	64e6                	ld	s1,88(sp)
    80002c00:	7c02                	ld	s8,32(sp)
    80002c02:	6ce2                	ld	s9,24(sp)
    80002c04:	6d42                	ld	s10,16(sp)
    80002c06:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002c08:	8556                	mv	a0,s5
    80002c0a:	9fbff0ef          	jal	80002604 <iupdate>

  return tot;
    80002c0e:	854e                	mv	a0,s3
    80002c10:	69a6                	ld	s3,72(sp)
}
    80002c12:	70a6                	ld	ra,104(sp)
    80002c14:	7406                	ld	s0,96(sp)
    80002c16:	6946                	ld	s2,80(sp)
    80002c18:	6a06                	ld	s4,64(sp)
    80002c1a:	7ae2                	ld	s5,56(sp)
    80002c1c:	7b42                	ld	s6,48(sp)
    80002c1e:	7ba2                	ld	s7,40(sp)
    80002c20:	6165                	addi	sp,sp,112
    80002c22:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c24:	89da                	mv	s3,s6
    80002c26:	b7cd                	j	80002c08 <writei+0xcc>
    80002c28:	64e6                	ld	s1,88(sp)
    80002c2a:	7c02                	ld	s8,32(sp)
    80002c2c:	6ce2                	ld	s9,24(sp)
    80002c2e:	6d42                	ld	s10,16(sp)
    80002c30:	6da2                	ld	s11,8(sp)
    80002c32:	bfd9                	j	80002c08 <writei+0xcc>
    return -1;
    80002c34:	557d                	li	a0,-1
}
    80002c36:	8082                	ret
    return -1;
    80002c38:	557d                	li	a0,-1
    80002c3a:	bfe1                	j	80002c12 <writei+0xd6>

0000000080002c3c <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002c3c:	1141                	addi	sp,sp,-16
    80002c3e:	e406                	sd	ra,8(sp)
    80002c40:	e022                	sd	s0,0(sp)
    80002c42:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002c44:	4639                	li	a2,14
    80002c46:	decfd0ef          	jal	80000232 <strncmp>
}
    80002c4a:	60a2                	ld	ra,8(sp)
    80002c4c:	6402                	ld	s0,0(sp)
    80002c4e:	0141                	addi	sp,sp,16
    80002c50:	8082                	ret

0000000080002c52 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002c52:	711d                	addi	sp,sp,-96
    80002c54:	ec86                	sd	ra,88(sp)
    80002c56:	e8a2                	sd	s0,80(sp)
    80002c58:	e4a6                	sd	s1,72(sp)
    80002c5a:	e0ca                	sd	s2,64(sp)
    80002c5c:	fc4e                	sd	s3,56(sp)
    80002c5e:	f852                	sd	s4,48(sp)
    80002c60:	f456                	sd	s5,40(sp)
    80002c62:	f05a                	sd	s6,32(sp)
    80002c64:	ec5e                	sd	s7,24(sp)
    80002c66:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c68:	04451703          	lh	a4,68(a0)
    80002c6c:	4785                	li	a5,1
    80002c6e:	00f71f63          	bne	a4,a5,80002c8c <dirlookup+0x3a>
    80002c72:	892a                	mv	s2,a0
    80002c74:	8aae                	mv	s5,a1
    80002c76:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c78:	457c                	lw	a5,76(a0)
    80002c7a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c7c:	fa040a13          	addi	s4,s0,-96
    80002c80:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002c82:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c86:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c88:	e39d                	bnez	a5,80002cae <dirlookup+0x5c>
    80002c8a:	a8b9                	j	80002ce8 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002c8c:	00005517          	auipc	a0,0x5
    80002c90:	7cc50513          	addi	a0,a0,1996 # 80008458 <etext+0x458>
    80002c94:	03e030ef          	jal	80005cd2 <panic>
      panic("dirlookup read");
    80002c98:	00005517          	auipc	a0,0x5
    80002c9c:	7d850513          	addi	a0,a0,2008 # 80008470 <etext+0x470>
    80002ca0:	032030ef          	jal	80005cd2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ca4:	24c1                	addiw	s1,s1,16
    80002ca6:	04c92783          	lw	a5,76(s2)
    80002caa:	02f4fe63          	bgeu	s1,a5,80002ce6 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002cae:	874e                	mv	a4,s3
    80002cb0:	86a6                	mv	a3,s1
    80002cb2:	8652                	mv	a2,s4
    80002cb4:	4581                	li	a1,0
    80002cb6:	854a                	mv	a0,s2
    80002cb8:	d93ff0ef          	jal	80002a4a <readi>
    80002cbc:	fd351ee3          	bne	a0,s3,80002c98 <dirlookup+0x46>
    if(de.inum == 0)
    80002cc0:	fa045783          	lhu	a5,-96(s0)
    80002cc4:	d3e5                	beqz	a5,80002ca4 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002cc6:	85da                	mv	a1,s6
    80002cc8:	8556                	mv	a0,s5
    80002cca:	f73ff0ef          	jal	80002c3c <namecmp>
    80002cce:	f979                	bnez	a0,80002ca4 <dirlookup+0x52>
      if(poff)
    80002cd0:	000b8463          	beqz	s7,80002cd8 <dirlookup+0x86>
        *poff = off;
    80002cd4:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002cd8:	fa045583          	lhu	a1,-96(s0)
    80002cdc:	00092503          	lw	a0,0(s2)
    80002ce0:	f66ff0ef          	jal	80002446 <iget>
    80002ce4:	a011                	j	80002ce8 <dirlookup+0x96>
  return 0;
    80002ce6:	4501                	li	a0,0
}
    80002ce8:	60e6                	ld	ra,88(sp)
    80002cea:	6446                	ld	s0,80(sp)
    80002cec:	64a6                	ld	s1,72(sp)
    80002cee:	6906                	ld	s2,64(sp)
    80002cf0:	79e2                	ld	s3,56(sp)
    80002cf2:	7a42                	ld	s4,48(sp)
    80002cf4:	7aa2                	ld	s5,40(sp)
    80002cf6:	7b02                	ld	s6,32(sp)
    80002cf8:	6be2                	ld	s7,24(sp)
    80002cfa:	6125                	addi	sp,sp,96
    80002cfc:	8082                	ret

0000000080002cfe <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002cfe:	711d                	addi	sp,sp,-96
    80002d00:	ec86                	sd	ra,88(sp)
    80002d02:	e8a2                	sd	s0,80(sp)
    80002d04:	e4a6                	sd	s1,72(sp)
    80002d06:	e0ca                	sd	s2,64(sp)
    80002d08:	fc4e                	sd	s3,56(sp)
    80002d0a:	f852                	sd	s4,48(sp)
    80002d0c:	f456                	sd	s5,40(sp)
    80002d0e:	f05a                	sd	s6,32(sp)
    80002d10:	ec5e                	sd	s7,24(sp)
    80002d12:	e862                	sd	s8,16(sp)
    80002d14:	e466                	sd	s9,8(sp)
    80002d16:	e06a                	sd	s10,0(sp)
    80002d18:	1080                	addi	s0,sp,96
    80002d1a:	84aa                	mv	s1,a0
    80002d1c:	8b2e                	mv	s6,a1
    80002d1e:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002d20:	00054703          	lbu	a4,0(a0)
    80002d24:	02f00793          	li	a5,47
    80002d28:	00f70f63          	beq	a4,a5,80002d46 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002d2c:	8b6fe0ef          	jal	80000de2 <myproc>
    80002d30:	15053503          	ld	a0,336(a0)
    80002d34:	94fff0ef          	jal	80002682 <idup>
    80002d38:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002d3a:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002d3e:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002d40:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002d42:	4b85                	li	s7,1
    80002d44:	a879                	j	80002de2 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002d46:	4585                	li	a1,1
    80002d48:	852e                	mv	a0,a1
    80002d4a:	efcff0ef          	jal	80002446 <iget>
    80002d4e:	8a2a                	mv	s4,a0
    80002d50:	b7ed                	j	80002d3a <namex+0x3c>
      iunlockput(ip);
    80002d52:	8552                	mv	a0,s4
    80002d54:	b71ff0ef          	jal	800028c4 <iunlockput>
      return 0;
    80002d58:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002d5a:	8552                	mv	a0,s4
    80002d5c:	60e6                	ld	ra,88(sp)
    80002d5e:	6446                	ld	s0,80(sp)
    80002d60:	64a6                	ld	s1,72(sp)
    80002d62:	6906                	ld	s2,64(sp)
    80002d64:	79e2                	ld	s3,56(sp)
    80002d66:	7a42                	ld	s4,48(sp)
    80002d68:	7aa2                	ld	s5,40(sp)
    80002d6a:	7b02                	ld	s6,32(sp)
    80002d6c:	6be2                	ld	s7,24(sp)
    80002d6e:	6c42                	ld	s8,16(sp)
    80002d70:	6ca2                	ld	s9,8(sp)
    80002d72:	6d02                	ld	s10,0(sp)
    80002d74:	6125                	addi	sp,sp,96
    80002d76:	8082                	ret
      iunlock(ip);
    80002d78:	8552                	mv	a0,s4
    80002d7a:	9edff0ef          	jal	80002766 <iunlock>
      return ip;
    80002d7e:	bff1                	j	80002d5a <namex+0x5c>
      iunlockput(ip);
    80002d80:	8552                	mv	a0,s4
    80002d82:	b43ff0ef          	jal	800028c4 <iunlockput>
      return 0;
    80002d86:	8a4a                	mv	s4,s2
    80002d88:	bfc9                	j	80002d5a <namex+0x5c>
  len = path - s;
    80002d8a:	40990633          	sub	a2,s2,s1
    80002d8e:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002d92:	09ac5463          	bge	s8,s10,80002e1a <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002d96:	8666                	mv	a2,s9
    80002d98:	85a6                	mv	a1,s1
    80002d9a:	8556                	mv	a0,s5
    80002d9c:	c22fd0ef          	jal	800001be <memmove>
    80002da0:	84ca                	mv	s1,s2
  while(*path == '/')
    80002da2:	0004c783          	lbu	a5,0(s1)
    80002da6:	01379763          	bne	a5,s3,80002db4 <namex+0xb6>
    path++;
    80002daa:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dac:	0004c783          	lbu	a5,0(s1)
    80002db0:	ff378de3          	beq	a5,s3,80002daa <namex+0xac>
    ilock(ip);
    80002db4:	8552                	mv	a0,s4
    80002db6:	903ff0ef          	jal	800026b8 <ilock>
    if(ip->type != T_DIR){
    80002dba:	044a1783          	lh	a5,68(s4)
    80002dbe:	f9779ae3          	bne	a5,s7,80002d52 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002dc2:	000b0563          	beqz	s6,80002dcc <namex+0xce>
    80002dc6:	0004c783          	lbu	a5,0(s1)
    80002dca:	d7dd                	beqz	a5,80002d78 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002dcc:	4601                	li	a2,0
    80002dce:	85d6                	mv	a1,s5
    80002dd0:	8552                	mv	a0,s4
    80002dd2:	e81ff0ef          	jal	80002c52 <dirlookup>
    80002dd6:	892a                	mv	s2,a0
    80002dd8:	d545                	beqz	a0,80002d80 <namex+0x82>
    iunlockput(ip);
    80002dda:	8552                	mv	a0,s4
    80002ddc:	ae9ff0ef          	jal	800028c4 <iunlockput>
    ip = next;
    80002de0:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002de2:	0004c783          	lbu	a5,0(s1)
    80002de6:	01379763          	bne	a5,s3,80002df4 <namex+0xf6>
    path++;
    80002dea:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002dec:	0004c783          	lbu	a5,0(s1)
    80002df0:	ff378de3          	beq	a5,s3,80002dea <namex+0xec>
  if(*path == 0)
    80002df4:	cf8d                	beqz	a5,80002e2e <namex+0x130>
  while(*path != '/' && *path != 0)
    80002df6:	0004c783          	lbu	a5,0(s1)
    80002dfa:	fd178713          	addi	a4,a5,-47
    80002dfe:	cb19                	beqz	a4,80002e14 <namex+0x116>
    80002e00:	cb91                	beqz	a5,80002e14 <namex+0x116>
    80002e02:	8926                	mv	s2,s1
    path++;
    80002e04:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002e06:	00094783          	lbu	a5,0(s2)
    80002e0a:	fd178713          	addi	a4,a5,-47
    80002e0e:	df35                	beqz	a4,80002d8a <namex+0x8c>
    80002e10:	fbf5                	bnez	a5,80002e04 <namex+0x106>
    80002e12:	bfa5                	j	80002d8a <namex+0x8c>
    80002e14:	8926                	mv	s2,s1
  len = path - s;
    80002e16:	4d01                	li	s10,0
    80002e18:	4601                	li	a2,0
    memmove(name, s, len);
    80002e1a:	2601                	sext.w	a2,a2
    80002e1c:	85a6                	mv	a1,s1
    80002e1e:	8556                	mv	a0,s5
    80002e20:	b9efd0ef          	jal	800001be <memmove>
    name[len] = 0;
    80002e24:	9d56                	add	s10,s10,s5
    80002e26:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdd128>
    80002e2a:	84ca                	mv	s1,s2
    80002e2c:	bf9d                	j	80002da2 <namex+0xa4>
  if(nameiparent){
    80002e2e:	f20b06e3          	beqz	s6,80002d5a <namex+0x5c>
    iput(ip);
    80002e32:	8552                	mv	a0,s4
    80002e34:	a07ff0ef          	jal	8000283a <iput>
    return 0;
    80002e38:	4a01                	li	s4,0
    80002e3a:	b705                	j	80002d5a <namex+0x5c>

0000000080002e3c <dirlink>:
{
    80002e3c:	715d                	addi	sp,sp,-80
    80002e3e:	e486                	sd	ra,72(sp)
    80002e40:	e0a2                	sd	s0,64(sp)
    80002e42:	f84a                	sd	s2,48(sp)
    80002e44:	ec56                	sd	s5,24(sp)
    80002e46:	e85a                	sd	s6,16(sp)
    80002e48:	0880                	addi	s0,sp,80
    80002e4a:	892a                	mv	s2,a0
    80002e4c:	8aae                	mv	s5,a1
    80002e4e:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002e50:	4601                	li	a2,0
    80002e52:	e01ff0ef          	jal	80002c52 <dirlookup>
    80002e56:	ed1d                	bnez	a0,80002e94 <dirlink+0x58>
    80002e58:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e5a:	04c92483          	lw	s1,76(s2)
    80002e5e:	c4b9                	beqz	s1,80002eac <dirlink+0x70>
    80002e60:	f44e                	sd	s3,40(sp)
    80002e62:	f052                	sd	s4,32(sp)
    80002e64:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e66:	fb040a13          	addi	s4,s0,-80
    80002e6a:	49c1                	li	s3,16
    80002e6c:	874e                	mv	a4,s3
    80002e6e:	86a6                	mv	a3,s1
    80002e70:	8652                	mv	a2,s4
    80002e72:	4581                	li	a1,0
    80002e74:	854a                	mv	a0,s2
    80002e76:	bd5ff0ef          	jal	80002a4a <readi>
    80002e7a:	03351163          	bne	a0,s3,80002e9c <dirlink+0x60>
    if(de.inum == 0)
    80002e7e:	fb045783          	lhu	a5,-80(s0)
    80002e82:	c39d                	beqz	a5,80002ea8 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e84:	24c1                	addiw	s1,s1,16
    80002e86:	04c92783          	lw	a5,76(s2)
    80002e8a:	fef4e1e3          	bltu	s1,a5,80002e6c <dirlink+0x30>
    80002e8e:	79a2                	ld	s3,40(sp)
    80002e90:	7a02                	ld	s4,32(sp)
    80002e92:	a829                	j	80002eac <dirlink+0x70>
    iput(ip);
    80002e94:	9a7ff0ef          	jal	8000283a <iput>
    return -1;
    80002e98:	557d                	li	a0,-1
    80002e9a:	a83d                	j	80002ed8 <dirlink+0x9c>
      panic("dirlink read");
    80002e9c:	00005517          	auipc	a0,0x5
    80002ea0:	5e450513          	addi	a0,a0,1508 # 80008480 <etext+0x480>
    80002ea4:	62f020ef          	jal	80005cd2 <panic>
    80002ea8:	79a2                	ld	s3,40(sp)
    80002eaa:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002eac:	4639                	li	a2,14
    80002eae:	85d6                	mv	a1,s5
    80002eb0:	fb240513          	addi	a0,s0,-78
    80002eb4:	bb8fd0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80002eb8:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002ebc:	4741                	li	a4,16
    80002ebe:	86a6                	mv	a3,s1
    80002ec0:	fb040613          	addi	a2,s0,-80
    80002ec4:	4581                	li	a1,0
    80002ec6:	854a                	mv	a0,s2
    80002ec8:	c75ff0ef          	jal	80002b3c <writei>
    80002ecc:	1541                	addi	a0,a0,-16
    80002ece:	00a03533          	snez	a0,a0
    80002ed2:	40a0053b          	negw	a0,a0
    80002ed6:	74e2                	ld	s1,56(sp)
}
    80002ed8:	60a6                	ld	ra,72(sp)
    80002eda:	6406                	ld	s0,64(sp)
    80002edc:	7942                	ld	s2,48(sp)
    80002ede:	6ae2                	ld	s5,24(sp)
    80002ee0:	6b42                	ld	s6,16(sp)
    80002ee2:	6161                	addi	sp,sp,80
    80002ee4:	8082                	ret

0000000080002ee6 <namei>:

struct inode*
namei(char *path)
{
    80002ee6:	1101                	addi	sp,sp,-32
    80002ee8:	ec06                	sd	ra,24(sp)
    80002eea:	e822                	sd	s0,16(sp)
    80002eec:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002eee:	fe040613          	addi	a2,s0,-32
    80002ef2:	4581                	li	a1,0
    80002ef4:	e0bff0ef          	jal	80002cfe <namex>
}
    80002ef8:	60e2                	ld	ra,24(sp)
    80002efa:	6442                	ld	s0,16(sp)
    80002efc:	6105                	addi	sp,sp,32
    80002efe:	8082                	ret

0000000080002f00 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002f00:	1141                	addi	sp,sp,-16
    80002f02:	e406                	sd	ra,8(sp)
    80002f04:	e022                	sd	s0,0(sp)
    80002f06:	0800                	addi	s0,sp,16
    80002f08:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002f0a:	4585                	li	a1,1
    80002f0c:	df3ff0ef          	jal	80002cfe <namex>
}
    80002f10:	60a2                	ld	ra,8(sp)
    80002f12:	6402                	ld	s0,0(sp)
    80002f14:	0141                	addi	sp,sp,16
    80002f16:	8082                	ret

0000000080002f18 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002f18:	1101                	addi	sp,sp,-32
    80002f1a:	ec06                	sd	ra,24(sp)
    80002f1c:	e822                	sd	s0,16(sp)
    80002f1e:	e426                	sd	s1,8(sp)
    80002f20:	e04a                	sd	s2,0(sp)
    80002f22:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002f24:	00016917          	auipc	s2,0x16
    80002f28:	a5c90913          	addi	s2,s2,-1444 # 80018980 <log>
    80002f2c:	01892583          	lw	a1,24(s2)
    80002f30:	02492503          	lw	a0,36(s2)
    80002f34:	8ecff0ef          	jal	80002020 <bread>
    80002f38:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002f3a:	02892603          	lw	a2,40(s2)
    80002f3e:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002f40:	00c05f63          	blez	a2,80002f5e <write_head+0x46>
    80002f44:	00016717          	auipc	a4,0x16
    80002f48:	a6870713          	addi	a4,a4,-1432 # 800189ac <log+0x2c>
    80002f4c:	87aa                	mv	a5,a0
    80002f4e:	060a                	slli	a2,a2,0x2
    80002f50:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002f52:	4314                	lw	a3,0(a4)
    80002f54:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002f56:	0711                	addi	a4,a4,4
    80002f58:	0791                	addi	a5,a5,4
    80002f5a:	fec79ce3          	bne	a5,a2,80002f52 <write_head+0x3a>
  }
  bwrite(buf);
    80002f5e:	8526                	mv	a0,s1
    80002f60:	996ff0ef          	jal	800020f6 <bwrite>
  brelse(buf);
    80002f64:	8526                	mv	a0,s1
    80002f66:	9c2ff0ef          	jal	80002128 <brelse>
}
    80002f6a:	60e2                	ld	ra,24(sp)
    80002f6c:	6442                	ld	s0,16(sp)
    80002f6e:	64a2                	ld	s1,8(sp)
    80002f70:	6902                	ld	s2,0(sp)
    80002f72:	6105                	addi	sp,sp,32
    80002f74:	8082                	ret

0000000080002f76 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f76:	00016797          	auipc	a5,0x16
    80002f7a:	a327a783          	lw	a5,-1486(a5) # 800189a8 <log+0x28>
    80002f7e:	0cf05163          	blez	a5,80003040 <install_trans+0xca>
{
    80002f82:	715d                	addi	sp,sp,-80
    80002f84:	e486                	sd	ra,72(sp)
    80002f86:	e0a2                	sd	s0,64(sp)
    80002f88:	fc26                	sd	s1,56(sp)
    80002f8a:	f84a                	sd	s2,48(sp)
    80002f8c:	f44e                	sd	s3,40(sp)
    80002f8e:	f052                	sd	s4,32(sp)
    80002f90:	ec56                	sd	s5,24(sp)
    80002f92:	e85a                	sd	s6,16(sp)
    80002f94:	e45e                	sd	s7,8(sp)
    80002f96:	e062                	sd	s8,0(sp)
    80002f98:	0880                	addi	s0,sp,80
    80002f9a:	8b2a                	mv	s6,a0
    80002f9c:	00016a97          	auipc	s5,0x16
    80002fa0:	a10a8a93          	addi	s5,s5,-1520 # 800189ac <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fa4:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002fa6:	00005c17          	auipc	s8,0x5
    80002faa:	4eac0c13          	addi	s8,s8,1258 # 80008490 <etext+0x490>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fae:	00016a17          	auipc	s4,0x16
    80002fb2:	9d2a0a13          	addi	s4,s4,-1582 # 80018980 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fb6:	40000b93          	li	s7,1024
    80002fba:	a025                	j	80002fe2 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002fbc:	000aa603          	lw	a2,0(s5)
    80002fc0:	85ce                	mv	a1,s3
    80002fc2:	8562                	mv	a0,s8
    80002fc4:	1e5020ef          	jal	800059a8 <printf>
    80002fc8:	a839                	j	80002fe6 <install_trans+0x70>
    brelse(lbuf);
    80002fca:	854a                	mv	a0,s2
    80002fcc:	95cff0ef          	jal	80002128 <brelse>
    brelse(dbuf);
    80002fd0:	8526                	mv	a0,s1
    80002fd2:	956ff0ef          	jal	80002128 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002fd6:	2985                	addiw	s3,s3,1
    80002fd8:	0a91                	addi	s5,s5,4
    80002fda:	028a2783          	lw	a5,40(s4)
    80002fde:	04f9d563          	bge	s3,a5,80003028 <install_trans+0xb2>
    if(recovering) {
    80002fe2:	fc0b1de3          	bnez	s6,80002fbc <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002fe6:	018a2583          	lw	a1,24(s4)
    80002fea:	013585bb          	addw	a1,a1,s3
    80002fee:	2585                	addiw	a1,a1,1
    80002ff0:	024a2503          	lw	a0,36(s4)
    80002ff4:	82cff0ef          	jal	80002020 <bread>
    80002ff8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002ffa:	000aa583          	lw	a1,0(s5)
    80002ffe:	024a2503          	lw	a0,36(s4)
    80003002:	81eff0ef          	jal	80002020 <bread>
    80003006:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003008:	865e                	mv	a2,s7
    8000300a:	05890593          	addi	a1,s2,88
    8000300e:	05850513          	addi	a0,a0,88
    80003012:	9acfd0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    80003016:	8526                	mv	a0,s1
    80003018:	8deff0ef          	jal	800020f6 <bwrite>
    if(recovering == 0)
    8000301c:	fa0b17e3          	bnez	s6,80002fca <install_trans+0x54>
      bunpin(dbuf);
    80003020:	8526                	mv	a0,s1
    80003022:	9beff0ef          	jal	800021e0 <bunpin>
    80003026:	b755                	j	80002fca <install_trans+0x54>
}
    80003028:	60a6                	ld	ra,72(sp)
    8000302a:	6406                	ld	s0,64(sp)
    8000302c:	74e2                	ld	s1,56(sp)
    8000302e:	7942                	ld	s2,48(sp)
    80003030:	79a2                	ld	s3,40(sp)
    80003032:	7a02                	ld	s4,32(sp)
    80003034:	6ae2                	ld	s5,24(sp)
    80003036:	6b42                	ld	s6,16(sp)
    80003038:	6ba2                	ld	s7,8(sp)
    8000303a:	6c02                	ld	s8,0(sp)
    8000303c:	6161                	addi	sp,sp,80
    8000303e:	8082                	ret
    80003040:	8082                	ret

0000000080003042 <initlog>:
{
    80003042:	7179                	addi	sp,sp,-48
    80003044:	f406                	sd	ra,40(sp)
    80003046:	f022                	sd	s0,32(sp)
    80003048:	ec26                	sd	s1,24(sp)
    8000304a:	e84a                	sd	s2,16(sp)
    8000304c:	e44e                	sd	s3,8(sp)
    8000304e:	1800                	addi	s0,sp,48
    80003050:	84aa                	mv	s1,a0
    80003052:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003054:	00016917          	auipc	s2,0x16
    80003058:	92c90913          	addi	s2,s2,-1748 # 80018980 <log>
    8000305c:	00005597          	auipc	a1,0x5
    80003060:	45458593          	addi	a1,a1,1108 # 800084b0 <etext+0x4b0>
    80003064:	854a                	mv	a0,s2
    80003066:	6a5020ef          	jal	80005f0a <initlock>
  log.start = sb->logstart;
    8000306a:	0149a583          	lw	a1,20(s3)
    8000306e:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003072:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003076:	8526                	mv	a0,s1
    80003078:	fa9fe0ef          	jal	80002020 <bread>
  log.lh.n = lh->n;
    8000307c:	4d30                	lw	a2,88(a0)
    8000307e:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003082:	00c05f63          	blez	a2,800030a0 <initlog+0x5e>
    80003086:	87aa                	mv	a5,a0
    80003088:	00016717          	auipc	a4,0x16
    8000308c:	92470713          	addi	a4,a4,-1756 # 800189ac <log+0x2c>
    80003090:	060a                	slli	a2,a2,0x2
    80003092:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003094:	4ff4                	lw	a3,92(a5)
    80003096:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003098:	0791                	addi	a5,a5,4
    8000309a:	0711                	addi	a4,a4,4
    8000309c:	fec79ce3          	bne	a5,a2,80003094 <initlog+0x52>
  brelse(buf);
    800030a0:	888ff0ef          	jal	80002128 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800030a4:	4505                	li	a0,1
    800030a6:	ed1ff0ef          	jal	80002f76 <install_trans>
  log.lh.n = 0;
    800030aa:	00016797          	auipc	a5,0x16
    800030ae:	8e07af23          	sw	zero,-1794(a5) # 800189a8 <log+0x28>
  write_head(); // clear the log
    800030b2:	e67ff0ef          	jal	80002f18 <write_head>
}
    800030b6:	70a2                	ld	ra,40(sp)
    800030b8:	7402                	ld	s0,32(sp)
    800030ba:	64e2                	ld	s1,24(sp)
    800030bc:	6942                	ld	s2,16(sp)
    800030be:	69a2                	ld	s3,8(sp)
    800030c0:	6145                	addi	sp,sp,48
    800030c2:	8082                	ret

00000000800030c4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800030c4:	1101                	addi	sp,sp,-32
    800030c6:	ec06                	sd	ra,24(sp)
    800030c8:	e822                	sd	s0,16(sp)
    800030ca:	e426                	sd	s1,8(sp)
    800030cc:	e04a                	sd	s2,0(sp)
    800030ce:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800030d0:	00016517          	auipc	a0,0x16
    800030d4:	8b050513          	addi	a0,a0,-1872 # 80018980 <log>
    800030d8:	6bd020ef          	jal	80005f94 <acquire>
  while(1){
    if(log.committing){
    800030dc:	00016497          	auipc	s1,0x16
    800030e0:	8a448493          	addi	s1,s1,-1884 # 80018980 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030e4:	4979                	li	s2,30
    800030e6:	a029                	j	800030f0 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800030e8:	85a6                	mv	a1,s1
    800030ea:	8526                	mv	a0,s1
    800030ec:	af4fe0ef          	jal	800013e0 <sleep>
    if(log.committing){
    800030f0:	509c                	lw	a5,32(s1)
    800030f2:	fbfd                	bnez	a5,800030e8 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800030f4:	4cd8                	lw	a4,28(s1)
    800030f6:	2705                	addiw	a4,a4,1
    800030f8:	0027179b          	slliw	a5,a4,0x2
    800030fc:	9fb9                	addw	a5,a5,a4
    800030fe:	0017979b          	slliw	a5,a5,0x1
    80003102:	5494                	lw	a3,40(s1)
    80003104:	9fb5                	addw	a5,a5,a3
    80003106:	00f95763          	bge	s2,a5,80003114 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    8000310a:	85a6                	mv	a1,s1
    8000310c:	8526                	mv	a0,s1
    8000310e:	ad2fe0ef          	jal	800013e0 <sleep>
    80003112:	bff9                	j	800030f0 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003114:	00016797          	auipc	a5,0x16
    80003118:	88e7a423          	sw	a4,-1912(a5) # 8001899c <log+0x1c>
      release(&log.lock);
    8000311c:	00016517          	auipc	a0,0x16
    80003120:	86450513          	addi	a0,a0,-1948 # 80018980 <log>
    80003124:	705020ef          	jal	80006028 <release>
      break;
    }
  }
}
    80003128:	60e2                	ld	ra,24(sp)
    8000312a:	6442                	ld	s0,16(sp)
    8000312c:	64a2                	ld	s1,8(sp)
    8000312e:	6902                	ld	s2,0(sp)
    80003130:	6105                	addi	sp,sp,32
    80003132:	8082                	ret

0000000080003134 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003134:	7139                	addi	sp,sp,-64
    80003136:	fc06                	sd	ra,56(sp)
    80003138:	f822                	sd	s0,48(sp)
    8000313a:	f426                	sd	s1,40(sp)
    8000313c:	f04a                	sd	s2,32(sp)
    8000313e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003140:	00016497          	auipc	s1,0x16
    80003144:	84048493          	addi	s1,s1,-1984 # 80018980 <log>
    80003148:	8526                	mv	a0,s1
    8000314a:	64b020ef          	jal	80005f94 <acquire>
  log.outstanding -= 1;
    8000314e:	4cdc                	lw	a5,28(s1)
    80003150:	37fd                	addiw	a5,a5,-1
    80003152:	893e                	mv	s2,a5
    80003154:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003156:	509c                	lw	a5,32(s1)
    80003158:	e7b1                	bnez	a5,800031a4 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    8000315a:	04091e63          	bnez	s2,800031b6 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    8000315e:	00016497          	auipc	s1,0x16
    80003162:	82248493          	addi	s1,s1,-2014 # 80018980 <log>
    80003166:	4785                	li	a5,1
    80003168:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000316a:	8526                	mv	a0,s1
    8000316c:	6bd020ef          	jal	80006028 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003170:	549c                	lw	a5,40(s1)
    80003172:	06f04463          	bgtz	a5,800031da <end_op+0xa6>
    acquire(&log.lock);
    80003176:	00016517          	auipc	a0,0x16
    8000317a:	80a50513          	addi	a0,a0,-2038 # 80018980 <log>
    8000317e:	617020ef          	jal	80005f94 <acquire>
    log.committing = 0;
    80003182:	00016797          	auipc	a5,0x16
    80003186:	8007af23          	sw	zero,-2018(a5) # 800189a0 <log+0x20>
    wakeup(&log);
    8000318a:	00015517          	auipc	a0,0x15
    8000318e:	7f650513          	addi	a0,a0,2038 # 80018980 <log>
    80003192:	a9afe0ef          	jal	8000142c <wakeup>
    release(&log.lock);
    80003196:	00015517          	auipc	a0,0x15
    8000319a:	7ea50513          	addi	a0,a0,2026 # 80018980 <log>
    8000319e:	68b020ef          	jal	80006028 <release>
}
    800031a2:	a035                	j	800031ce <end_op+0x9a>
    800031a4:	ec4e                	sd	s3,24(sp)
    800031a6:	e852                	sd	s4,16(sp)
    800031a8:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800031aa:	00005517          	auipc	a0,0x5
    800031ae:	30e50513          	addi	a0,a0,782 # 800084b8 <etext+0x4b8>
    800031b2:	321020ef          	jal	80005cd2 <panic>
    wakeup(&log);
    800031b6:	00015517          	auipc	a0,0x15
    800031ba:	7ca50513          	addi	a0,a0,1994 # 80018980 <log>
    800031be:	a6efe0ef          	jal	8000142c <wakeup>
  release(&log.lock);
    800031c2:	00015517          	auipc	a0,0x15
    800031c6:	7be50513          	addi	a0,a0,1982 # 80018980 <log>
    800031ca:	65f020ef          	jal	80006028 <release>
}
    800031ce:	70e2                	ld	ra,56(sp)
    800031d0:	7442                	ld	s0,48(sp)
    800031d2:	74a2                	ld	s1,40(sp)
    800031d4:	7902                	ld	s2,32(sp)
    800031d6:	6121                	addi	sp,sp,64
    800031d8:	8082                	ret
    800031da:	ec4e                	sd	s3,24(sp)
    800031dc:	e852                	sd	s4,16(sp)
    800031de:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800031e0:	00015a97          	auipc	s5,0x15
    800031e4:	7cca8a93          	addi	s5,s5,1996 # 800189ac <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800031e8:	00015a17          	auipc	s4,0x15
    800031ec:	798a0a13          	addi	s4,s4,1944 # 80018980 <log>
    800031f0:	018a2583          	lw	a1,24(s4)
    800031f4:	012585bb          	addw	a1,a1,s2
    800031f8:	2585                	addiw	a1,a1,1
    800031fa:	024a2503          	lw	a0,36(s4)
    800031fe:	e23fe0ef          	jal	80002020 <bread>
    80003202:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003204:	000aa583          	lw	a1,0(s5)
    80003208:	024a2503          	lw	a0,36(s4)
    8000320c:	e15fe0ef          	jal	80002020 <bread>
    80003210:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003212:	40000613          	li	a2,1024
    80003216:	05850593          	addi	a1,a0,88
    8000321a:	05848513          	addi	a0,s1,88
    8000321e:	fa1fc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    80003222:	8526                	mv	a0,s1
    80003224:	ed3fe0ef          	jal	800020f6 <bwrite>
    brelse(from);
    80003228:	854e                	mv	a0,s3
    8000322a:	efffe0ef          	jal	80002128 <brelse>
    brelse(to);
    8000322e:	8526                	mv	a0,s1
    80003230:	ef9fe0ef          	jal	80002128 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003234:	2905                	addiw	s2,s2,1
    80003236:	0a91                	addi	s5,s5,4
    80003238:	028a2783          	lw	a5,40(s4)
    8000323c:	faf94ae3          	blt	s2,a5,800031f0 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003240:	cd9ff0ef          	jal	80002f18 <write_head>
    install_trans(0); // Now install writes to home locations
    80003244:	4501                	li	a0,0
    80003246:	d31ff0ef          	jal	80002f76 <install_trans>
    log.lh.n = 0;
    8000324a:	00015797          	auipc	a5,0x15
    8000324e:	7407af23          	sw	zero,1886(a5) # 800189a8 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003252:	cc7ff0ef          	jal	80002f18 <write_head>
    80003256:	69e2                	ld	s3,24(sp)
    80003258:	6a42                	ld	s4,16(sp)
    8000325a:	6aa2                	ld	s5,8(sp)
    8000325c:	bf29                	j	80003176 <end_op+0x42>

000000008000325e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000325e:	1101                	addi	sp,sp,-32
    80003260:	ec06                	sd	ra,24(sp)
    80003262:	e822                	sd	s0,16(sp)
    80003264:	e426                	sd	s1,8(sp)
    80003266:	1000                	addi	s0,sp,32
    80003268:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000326a:	00015517          	auipc	a0,0x15
    8000326e:	71650513          	addi	a0,a0,1814 # 80018980 <log>
    80003272:	523020ef          	jal	80005f94 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003276:	00015617          	auipc	a2,0x15
    8000327a:	73262603          	lw	a2,1842(a2) # 800189a8 <log+0x28>
    8000327e:	47f5                	li	a5,29
    80003280:	04c7cd63          	blt	a5,a2,800032da <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003284:	00015797          	auipc	a5,0x15
    80003288:	7187a783          	lw	a5,1816(a5) # 8001899c <log+0x1c>
    8000328c:	04f05d63          	blez	a5,800032e6 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003290:	4781                	li	a5,0
    80003292:	06c05063          	blez	a2,800032f2 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003296:	44cc                	lw	a1,12(s1)
    80003298:	00015717          	auipc	a4,0x15
    8000329c:	71470713          	addi	a4,a4,1812 # 800189ac <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800032a0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800032a2:	4314                	lw	a3,0(a4)
    800032a4:	04b68763          	beq	a3,a1,800032f2 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    800032a8:	2785                	addiw	a5,a5,1
    800032aa:	0711                	addi	a4,a4,4
    800032ac:	fef61be3          	bne	a2,a5,800032a2 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800032b0:	060a                	slli	a2,a2,0x2
    800032b2:	02060613          	addi	a2,a2,32
    800032b6:	00015797          	auipc	a5,0x15
    800032ba:	6ca78793          	addi	a5,a5,1738 # 80018980 <log>
    800032be:	97b2                	add	a5,a5,a2
    800032c0:	44d8                	lw	a4,12(s1)
    800032c2:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800032c4:	8526                	mv	a0,s1
    800032c6:	ee7fe0ef          	jal	800021ac <bpin>
    log.lh.n++;
    800032ca:	00015717          	auipc	a4,0x15
    800032ce:	6b670713          	addi	a4,a4,1718 # 80018980 <log>
    800032d2:	571c                	lw	a5,40(a4)
    800032d4:	2785                	addiw	a5,a5,1
    800032d6:	d71c                	sw	a5,40(a4)
    800032d8:	a815                	j	8000330c <log_write+0xae>
    panic("too big a transaction");
    800032da:	00005517          	auipc	a0,0x5
    800032de:	1ee50513          	addi	a0,a0,494 # 800084c8 <etext+0x4c8>
    800032e2:	1f1020ef          	jal	80005cd2 <panic>
    panic("log_write outside of trans");
    800032e6:	00005517          	auipc	a0,0x5
    800032ea:	1fa50513          	addi	a0,a0,506 # 800084e0 <etext+0x4e0>
    800032ee:	1e5020ef          	jal	80005cd2 <panic>
  log.lh.block[i] = b->blockno;
    800032f2:	00279693          	slli	a3,a5,0x2
    800032f6:	02068693          	addi	a3,a3,32
    800032fa:	00015717          	auipc	a4,0x15
    800032fe:	68670713          	addi	a4,a4,1670 # 80018980 <log>
    80003302:	9736                	add	a4,a4,a3
    80003304:	44d4                	lw	a3,12(s1)
    80003306:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003308:	faf60ee3          	beq	a2,a5,800032c4 <log_write+0x66>
  }
  release(&log.lock);
    8000330c:	00015517          	auipc	a0,0x15
    80003310:	67450513          	addi	a0,a0,1652 # 80018980 <log>
    80003314:	515020ef          	jal	80006028 <release>
}
    80003318:	60e2                	ld	ra,24(sp)
    8000331a:	6442                	ld	s0,16(sp)
    8000331c:	64a2                	ld	s1,8(sp)
    8000331e:	6105                	addi	sp,sp,32
    80003320:	8082                	ret

0000000080003322 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003322:	1101                	addi	sp,sp,-32
    80003324:	ec06                	sd	ra,24(sp)
    80003326:	e822                	sd	s0,16(sp)
    80003328:	e426                	sd	s1,8(sp)
    8000332a:	e04a                	sd	s2,0(sp)
    8000332c:	1000                	addi	s0,sp,32
    8000332e:	84aa                	mv	s1,a0
    80003330:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003332:	00005597          	auipc	a1,0x5
    80003336:	1ce58593          	addi	a1,a1,462 # 80008500 <etext+0x500>
    8000333a:	0521                	addi	a0,a0,8
    8000333c:	3cf020ef          	jal	80005f0a <initlock>
  lk->name = name;
    80003340:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003344:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003348:	0204a423          	sw	zero,40(s1)
}
    8000334c:	60e2                	ld	ra,24(sp)
    8000334e:	6442                	ld	s0,16(sp)
    80003350:	64a2                	ld	s1,8(sp)
    80003352:	6902                	ld	s2,0(sp)
    80003354:	6105                	addi	sp,sp,32
    80003356:	8082                	ret

0000000080003358 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003358:	1101                	addi	sp,sp,-32
    8000335a:	ec06                	sd	ra,24(sp)
    8000335c:	e822                	sd	s0,16(sp)
    8000335e:	e426                	sd	s1,8(sp)
    80003360:	e04a                	sd	s2,0(sp)
    80003362:	1000                	addi	s0,sp,32
    80003364:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003366:	00850913          	addi	s2,a0,8
    8000336a:	854a                	mv	a0,s2
    8000336c:	429020ef          	jal	80005f94 <acquire>
  while (lk->locked) {
    80003370:	409c                	lw	a5,0(s1)
    80003372:	c799                	beqz	a5,80003380 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003374:	85ca                	mv	a1,s2
    80003376:	8526                	mv	a0,s1
    80003378:	868fe0ef          	jal	800013e0 <sleep>
  while (lk->locked) {
    8000337c:	409c                	lw	a5,0(s1)
    8000337e:	fbfd                	bnez	a5,80003374 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003380:	4785                	li	a5,1
    80003382:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003384:	a5ffd0ef          	jal	80000de2 <myproc>
    80003388:	591c                	lw	a5,48(a0)
    8000338a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000338c:	854a                	mv	a0,s2
    8000338e:	49b020ef          	jal	80006028 <release>
}
    80003392:	60e2                	ld	ra,24(sp)
    80003394:	6442                	ld	s0,16(sp)
    80003396:	64a2                	ld	s1,8(sp)
    80003398:	6902                	ld	s2,0(sp)
    8000339a:	6105                	addi	sp,sp,32
    8000339c:	8082                	ret

000000008000339e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000339e:	1101                	addi	sp,sp,-32
    800033a0:	ec06                	sd	ra,24(sp)
    800033a2:	e822                	sd	s0,16(sp)
    800033a4:	e426                	sd	s1,8(sp)
    800033a6:	e04a                	sd	s2,0(sp)
    800033a8:	1000                	addi	s0,sp,32
    800033aa:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800033ac:	00850913          	addi	s2,a0,8
    800033b0:	854a                	mv	a0,s2
    800033b2:	3e3020ef          	jal	80005f94 <acquire>
  lk->locked = 0;
    800033b6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033ba:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800033be:	8526                	mv	a0,s1
    800033c0:	86cfe0ef          	jal	8000142c <wakeup>
  release(&lk->lk);
    800033c4:	854a                	mv	a0,s2
    800033c6:	463020ef          	jal	80006028 <release>
}
    800033ca:	60e2                	ld	ra,24(sp)
    800033cc:	6442                	ld	s0,16(sp)
    800033ce:	64a2                	ld	s1,8(sp)
    800033d0:	6902                	ld	s2,0(sp)
    800033d2:	6105                	addi	sp,sp,32
    800033d4:	8082                	ret

00000000800033d6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800033d6:	7179                	addi	sp,sp,-48
    800033d8:	f406                	sd	ra,40(sp)
    800033da:	f022                	sd	s0,32(sp)
    800033dc:	ec26                	sd	s1,24(sp)
    800033de:	e84a                	sd	s2,16(sp)
    800033e0:	1800                	addi	s0,sp,48
    800033e2:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800033e4:	00850913          	addi	s2,a0,8
    800033e8:	854a                	mv	a0,s2
    800033ea:	3ab020ef          	jal	80005f94 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800033ee:	409c                	lw	a5,0(s1)
    800033f0:	ef81                	bnez	a5,80003408 <holdingsleep+0x32>
    800033f2:	4481                	li	s1,0
  release(&lk->lk);
    800033f4:	854a                	mv	a0,s2
    800033f6:	433020ef          	jal	80006028 <release>
  return r;
}
    800033fa:	8526                	mv	a0,s1
    800033fc:	70a2                	ld	ra,40(sp)
    800033fe:	7402                	ld	s0,32(sp)
    80003400:	64e2                	ld	s1,24(sp)
    80003402:	6942                	ld	s2,16(sp)
    80003404:	6145                	addi	sp,sp,48
    80003406:	8082                	ret
    80003408:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    8000340a:	0284a983          	lw	s3,40(s1)
    8000340e:	9d5fd0ef          	jal	80000de2 <myproc>
    80003412:	5904                	lw	s1,48(a0)
    80003414:	413484b3          	sub	s1,s1,s3
    80003418:	0014b493          	seqz	s1,s1
    8000341c:	69a2                	ld	s3,8(sp)
    8000341e:	bfd9                	j	800033f4 <holdingsleep+0x1e>

0000000080003420 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003420:	1141                	addi	sp,sp,-16
    80003422:	e406                	sd	ra,8(sp)
    80003424:	e022                	sd	s0,0(sp)
    80003426:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003428:	00005597          	auipc	a1,0x5
    8000342c:	0e858593          	addi	a1,a1,232 # 80008510 <etext+0x510>
    80003430:	00015517          	auipc	a0,0x15
    80003434:	69850513          	addi	a0,a0,1688 # 80018ac8 <ftable>
    80003438:	2d3020ef          	jal	80005f0a <initlock>
}
    8000343c:	60a2                	ld	ra,8(sp)
    8000343e:	6402                	ld	s0,0(sp)
    80003440:	0141                	addi	sp,sp,16
    80003442:	8082                	ret

0000000080003444 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003444:	1101                	addi	sp,sp,-32
    80003446:	ec06                	sd	ra,24(sp)
    80003448:	e822                	sd	s0,16(sp)
    8000344a:	e426                	sd	s1,8(sp)
    8000344c:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000344e:	00015517          	auipc	a0,0x15
    80003452:	67a50513          	addi	a0,a0,1658 # 80018ac8 <ftable>
    80003456:	33f020ef          	jal	80005f94 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000345a:	00015497          	auipc	s1,0x15
    8000345e:	68648493          	addi	s1,s1,1670 # 80018ae0 <ftable+0x18>
    80003462:	00016717          	auipc	a4,0x16
    80003466:	61e70713          	addi	a4,a4,1566 # 80019a80 <disk>
    if(f->ref == 0){
    8000346a:	40dc                	lw	a5,4(s1)
    8000346c:	cf89                	beqz	a5,80003486 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000346e:	02848493          	addi	s1,s1,40
    80003472:	fee49ce3          	bne	s1,a4,8000346a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003476:	00015517          	auipc	a0,0x15
    8000347a:	65250513          	addi	a0,a0,1618 # 80018ac8 <ftable>
    8000347e:	3ab020ef          	jal	80006028 <release>
  return 0;
    80003482:	4481                	li	s1,0
    80003484:	a809                	j	80003496 <filealloc+0x52>
      f->ref = 1;
    80003486:	4785                	li	a5,1
    80003488:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000348a:	00015517          	auipc	a0,0x15
    8000348e:	63e50513          	addi	a0,a0,1598 # 80018ac8 <ftable>
    80003492:	397020ef          	jal	80006028 <release>
}
    80003496:	8526                	mv	a0,s1
    80003498:	60e2                	ld	ra,24(sp)
    8000349a:	6442                	ld	s0,16(sp)
    8000349c:	64a2                	ld	s1,8(sp)
    8000349e:	6105                	addi	sp,sp,32
    800034a0:	8082                	ret

00000000800034a2 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800034a2:	1101                	addi	sp,sp,-32
    800034a4:	ec06                	sd	ra,24(sp)
    800034a6:	e822                	sd	s0,16(sp)
    800034a8:	e426                	sd	s1,8(sp)
    800034aa:	1000                	addi	s0,sp,32
    800034ac:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800034ae:	00015517          	auipc	a0,0x15
    800034b2:	61a50513          	addi	a0,a0,1562 # 80018ac8 <ftable>
    800034b6:	2df020ef          	jal	80005f94 <acquire>
  if(f->ref < 1)
    800034ba:	40dc                	lw	a5,4(s1)
    800034bc:	02f05063          	blez	a5,800034dc <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800034c0:	2785                	addiw	a5,a5,1
    800034c2:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800034c4:	00015517          	auipc	a0,0x15
    800034c8:	60450513          	addi	a0,a0,1540 # 80018ac8 <ftable>
    800034cc:	35d020ef          	jal	80006028 <release>
  return f;
}
    800034d0:	8526                	mv	a0,s1
    800034d2:	60e2                	ld	ra,24(sp)
    800034d4:	6442                	ld	s0,16(sp)
    800034d6:	64a2                	ld	s1,8(sp)
    800034d8:	6105                	addi	sp,sp,32
    800034da:	8082                	ret
    panic("filedup");
    800034dc:	00005517          	auipc	a0,0x5
    800034e0:	03c50513          	addi	a0,a0,60 # 80008518 <etext+0x518>
    800034e4:	7ee020ef          	jal	80005cd2 <panic>

00000000800034e8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800034e8:	7139                	addi	sp,sp,-64
    800034ea:	fc06                	sd	ra,56(sp)
    800034ec:	f822                	sd	s0,48(sp)
    800034ee:	f426                	sd	s1,40(sp)
    800034f0:	0080                	addi	s0,sp,64
    800034f2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800034f4:	00015517          	auipc	a0,0x15
    800034f8:	5d450513          	addi	a0,a0,1492 # 80018ac8 <ftable>
    800034fc:	299020ef          	jal	80005f94 <acquire>
  if(f->ref < 1)
    80003500:	40dc                	lw	a5,4(s1)
    80003502:	04f05a63          	blez	a5,80003556 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003506:	37fd                	addiw	a5,a5,-1
    80003508:	c0dc                	sw	a5,4(s1)
    8000350a:	06f04063          	bgtz	a5,8000356a <fileclose+0x82>
    8000350e:	f04a                	sd	s2,32(sp)
    80003510:	ec4e                	sd	s3,24(sp)
    80003512:	e852                	sd	s4,16(sp)
    80003514:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003516:	0004a903          	lw	s2,0(s1)
    8000351a:	0094c783          	lbu	a5,9(s1)
    8000351e:	89be                	mv	s3,a5
    80003520:	689c                	ld	a5,16(s1)
    80003522:	8a3e                	mv	s4,a5
    80003524:	6c9c                	ld	a5,24(s1)
    80003526:	8abe                	mv	s5,a5
  f->ref = 0;
    80003528:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000352c:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003530:	00015517          	auipc	a0,0x15
    80003534:	59850513          	addi	a0,a0,1432 # 80018ac8 <ftable>
    80003538:	2f1020ef          	jal	80006028 <release>

  if(ff.type == FD_PIPE){
    8000353c:	4785                	li	a5,1
    8000353e:	04f90163          	beq	s2,a5,80003580 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003542:	ffe9079b          	addiw	a5,s2,-2
    80003546:	4705                	li	a4,1
    80003548:	04f77563          	bgeu	a4,a5,80003592 <fileclose+0xaa>
    8000354c:	7902                	ld	s2,32(sp)
    8000354e:	69e2                	ld	s3,24(sp)
    80003550:	6a42                	ld	s4,16(sp)
    80003552:	6aa2                	ld	s5,8(sp)
    80003554:	a00d                	j	80003576 <fileclose+0x8e>
    80003556:	f04a                	sd	s2,32(sp)
    80003558:	ec4e                	sd	s3,24(sp)
    8000355a:	e852                	sd	s4,16(sp)
    8000355c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000355e:	00005517          	auipc	a0,0x5
    80003562:	fc250513          	addi	a0,a0,-62 # 80008520 <etext+0x520>
    80003566:	76c020ef          	jal	80005cd2 <panic>
    release(&ftable.lock);
    8000356a:	00015517          	auipc	a0,0x15
    8000356e:	55e50513          	addi	a0,a0,1374 # 80018ac8 <ftable>
    80003572:	2b7020ef          	jal	80006028 <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003576:	70e2                	ld	ra,56(sp)
    80003578:	7442                	ld	s0,48(sp)
    8000357a:	74a2                	ld	s1,40(sp)
    8000357c:	6121                	addi	sp,sp,64
    8000357e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003580:	85ce                	mv	a1,s3
    80003582:	8552                	mv	a0,s4
    80003584:	348000ef          	jal	800038cc <pipeclose>
    80003588:	7902                	ld	s2,32(sp)
    8000358a:	69e2                	ld	s3,24(sp)
    8000358c:	6a42                	ld	s4,16(sp)
    8000358e:	6aa2                	ld	s5,8(sp)
    80003590:	b7dd                	j	80003576 <fileclose+0x8e>
    begin_op();
    80003592:	b33ff0ef          	jal	800030c4 <begin_op>
    iput(ff.ip);
    80003596:	8556                	mv	a0,s5
    80003598:	aa2ff0ef          	jal	8000283a <iput>
    end_op();
    8000359c:	b99ff0ef          	jal	80003134 <end_op>
    800035a0:	7902                	ld	s2,32(sp)
    800035a2:	69e2                	ld	s3,24(sp)
    800035a4:	6a42                	ld	s4,16(sp)
    800035a6:	6aa2                	ld	s5,8(sp)
    800035a8:	b7f9                	j	80003576 <fileclose+0x8e>

00000000800035aa <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800035aa:	715d                	addi	sp,sp,-80
    800035ac:	e486                	sd	ra,72(sp)
    800035ae:	e0a2                	sd	s0,64(sp)
    800035b0:	fc26                	sd	s1,56(sp)
    800035b2:	f052                	sd	s4,32(sp)
    800035b4:	0880                	addi	s0,sp,80
    800035b6:	84aa                	mv	s1,a0
    800035b8:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800035ba:	829fd0ef          	jal	80000de2 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800035be:	409c                	lw	a5,0(s1)
    800035c0:	37f9                	addiw	a5,a5,-2
    800035c2:	4705                	li	a4,1
    800035c4:	04f76263          	bltu	a4,a5,80003608 <filestat+0x5e>
    800035c8:	f84a                	sd	s2,48(sp)
    800035ca:	f44e                	sd	s3,40(sp)
    800035cc:	89aa                	mv	s3,a0
    ilock(f->ip);
    800035ce:	6c88                	ld	a0,24(s1)
    800035d0:	8e8ff0ef          	jal	800026b8 <ilock>
    stati(f->ip, &st);
    800035d4:	fb840913          	addi	s2,s0,-72
    800035d8:	85ca                	mv	a1,s2
    800035da:	6c88                	ld	a0,24(s1)
    800035dc:	c40ff0ef          	jal	80002a1c <stati>
    iunlock(f->ip);
    800035e0:	6c88                	ld	a0,24(s1)
    800035e2:	984ff0ef          	jal	80002766 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800035e6:	46e1                	li	a3,24
    800035e8:	864a                	mv	a2,s2
    800035ea:	85d2                	mv	a1,s4
    800035ec:	0509b503          	ld	a0,80(s3)
    800035f0:	d16fd0ef          	jal	80000b06 <copyout>
    800035f4:	41f5551b          	sraiw	a0,a0,0x1f
    800035f8:	7942                	ld	s2,48(sp)
    800035fa:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800035fc:	60a6                	ld	ra,72(sp)
    800035fe:	6406                	ld	s0,64(sp)
    80003600:	74e2                	ld	s1,56(sp)
    80003602:	7a02                	ld	s4,32(sp)
    80003604:	6161                	addi	sp,sp,80
    80003606:	8082                	ret
  return -1;
    80003608:	557d                	li	a0,-1
    8000360a:	bfcd                	j	800035fc <filestat+0x52>

000000008000360c <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000360c:	7179                	addi	sp,sp,-48
    8000360e:	f406                	sd	ra,40(sp)
    80003610:	f022                	sd	s0,32(sp)
    80003612:	e84a                	sd	s2,16(sp)
    80003614:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003616:	00854783          	lbu	a5,8(a0)
    8000361a:	cfd1                	beqz	a5,800036b6 <fileread+0xaa>
    8000361c:	ec26                	sd	s1,24(sp)
    8000361e:	e44e                	sd	s3,8(sp)
    80003620:	84aa                	mv	s1,a0
    80003622:	892e                	mv	s2,a1
    80003624:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80003626:	411c                	lw	a5,0(a0)
    80003628:	4705                	li	a4,1
    8000362a:	04e78363          	beq	a5,a4,80003670 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000362e:	470d                	li	a4,3
    80003630:	04e78763          	beq	a5,a4,8000367e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003634:	4709                	li	a4,2
    80003636:	06e79a63          	bne	a5,a4,800036aa <fileread+0x9e>
    ilock(f->ip);
    8000363a:	6d08                	ld	a0,24(a0)
    8000363c:	87cff0ef          	jal	800026b8 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003640:	874e                	mv	a4,s3
    80003642:	5094                	lw	a3,32(s1)
    80003644:	864a                	mv	a2,s2
    80003646:	4585                	li	a1,1
    80003648:	6c88                	ld	a0,24(s1)
    8000364a:	c00ff0ef          	jal	80002a4a <readi>
    8000364e:	892a                	mv	s2,a0
    80003650:	00a05563          	blez	a0,8000365a <fileread+0x4e>
      f->off += r;
    80003654:	509c                	lw	a5,32(s1)
    80003656:	9fa9                	addw	a5,a5,a0
    80003658:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000365a:	6c88                	ld	a0,24(s1)
    8000365c:	90aff0ef          	jal	80002766 <iunlock>
    80003660:	64e2                	ld	s1,24(sp)
    80003662:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003664:	854a                	mv	a0,s2
    80003666:	70a2                	ld	ra,40(sp)
    80003668:	7402                	ld	s0,32(sp)
    8000366a:	6942                	ld	s2,16(sp)
    8000366c:	6145                	addi	sp,sp,48
    8000366e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003670:	6908                	ld	a0,16(a0)
    80003672:	3b0000ef          	jal	80003a22 <piperead>
    80003676:	892a                	mv	s2,a0
    80003678:	64e2                	ld	s1,24(sp)
    8000367a:	69a2                	ld	s3,8(sp)
    8000367c:	b7e5                	j	80003664 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000367e:	02451783          	lh	a5,36(a0)
    80003682:	03079693          	slli	a3,a5,0x30
    80003686:	92c1                	srli	a3,a3,0x30
    80003688:	4725                	li	a4,9
    8000368a:	02d76963          	bltu	a4,a3,800036bc <fileread+0xb0>
    8000368e:	0792                	slli	a5,a5,0x4
    80003690:	00015717          	auipc	a4,0x15
    80003694:	39870713          	addi	a4,a4,920 # 80018a28 <devsw>
    80003698:	97ba                	add	a5,a5,a4
    8000369a:	639c                	ld	a5,0(a5)
    8000369c:	c78d                	beqz	a5,800036c6 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    8000369e:	4505                	li	a0,1
    800036a0:	9782                	jalr	a5
    800036a2:	892a                	mv	s2,a0
    800036a4:	64e2                	ld	s1,24(sp)
    800036a6:	69a2                	ld	s3,8(sp)
    800036a8:	bf75                	j	80003664 <fileread+0x58>
    panic("fileread");
    800036aa:	00005517          	auipc	a0,0x5
    800036ae:	e8650513          	addi	a0,a0,-378 # 80008530 <etext+0x530>
    800036b2:	620020ef          	jal	80005cd2 <panic>
    return -1;
    800036b6:	57fd                	li	a5,-1
    800036b8:	893e                	mv	s2,a5
    800036ba:	b76d                	j	80003664 <fileread+0x58>
      return -1;
    800036bc:	57fd                	li	a5,-1
    800036be:	893e                	mv	s2,a5
    800036c0:	64e2                	ld	s1,24(sp)
    800036c2:	69a2                	ld	s3,8(sp)
    800036c4:	b745                	j	80003664 <fileread+0x58>
    800036c6:	57fd                	li	a5,-1
    800036c8:	893e                	mv	s2,a5
    800036ca:	64e2                	ld	s1,24(sp)
    800036cc:	69a2                	ld	s3,8(sp)
    800036ce:	bf59                	j	80003664 <fileread+0x58>

00000000800036d0 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800036d0:	00954783          	lbu	a5,9(a0)
    800036d4:	10078f63          	beqz	a5,800037f2 <filewrite+0x122>
{
    800036d8:	711d                	addi	sp,sp,-96
    800036da:	ec86                	sd	ra,88(sp)
    800036dc:	e8a2                	sd	s0,80(sp)
    800036de:	e0ca                	sd	s2,64(sp)
    800036e0:	f456                	sd	s5,40(sp)
    800036e2:	f05a                	sd	s6,32(sp)
    800036e4:	1080                	addi	s0,sp,96
    800036e6:	892a                	mv	s2,a0
    800036e8:	8b2e                	mv	s6,a1
    800036ea:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800036ec:	411c                	lw	a5,0(a0)
    800036ee:	4705                	li	a4,1
    800036f0:	02e78a63          	beq	a5,a4,80003724 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036f4:	470d                	li	a4,3
    800036f6:	02e78b63          	beq	a5,a4,8000372c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800036fa:	4709                	li	a4,2
    800036fc:	0ce79f63          	bne	a5,a4,800037da <filewrite+0x10a>
    80003700:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003702:	0ac05a63          	blez	a2,800037b6 <filewrite+0xe6>
    80003706:	e4a6                	sd	s1,72(sp)
    80003708:	fc4e                	sd	s3,56(sp)
    8000370a:	ec5e                	sd	s7,24(sp)
    8000370c:	e862                	sd	s8,16(sp)
    8000370e:	e466                	sd	s9,8(sp)
    int i = 0;
    80003710:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003712:	6b85                	lui	s7,0x1
    80003714:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003718:	6785                	lui	a5,0x1
    8000371a:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000371e:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003720:	4c05                	li	s8,1
    80003722:	a8ad                	j	8000379c <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003724:	6908                	ld	a0,16(a0)
    80003726:	204000ef          	jal	8000392a <pipewrite>
    8000372a:	a04d                	j	800037cc <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000372c:	02451783          	lh	a5,36(a0)
    80003730:	03079693          	slli	a3,a5,0x30
    80003734:	92c1                	srli	a3,a3,0x30
    80003736:	4725                	li	a4,9
    80003738:	0ad76f63          	bltu	a4,a3,800037f6 <filewrite+0x126>
    8000373c:	0792                	slli	a5,a5,0x4
    8000373e:	00015717          	auipc	a4,0x15
    80003742:	2ea70713          	addi	a4,a4,746 # 80018a28 <devsw>
    80003746:	97ba                	add	a5,a5,a4
    80003748:	679c                	ld	a5,8(a5)
    8000374a:	cbc5                	beqz	a5,800037fa <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    8000374c:	4505                	li	a0,1
    8000374e:	9782                	jalr	a5
    80003750:	a8b5                	j	800037cc <filewrite+0xfc>
      if(n1 > max)
    80003752:	2981                	sext.w	s3,s3
      begin_op();
    80003754:	971ff0ef          	jal	800030c4 <begin_op>
      ilock(f->ip);
    80003758:	01893503          	ld	a0,24(s2)
    8000375c:	f5dfe0ef          	jal	800026b8 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003760:	874e                	mv	a4,s3
    80003762:	02092683          	lw	a3,32(s2)
    80003766:	016a0633          	add	a2,s4,s6
    8000376a:	85e2                	mv	a1,s8
    8000376c:	01893503          	ld	a0,24(s2)
    80003770:	bccff0ef          	jal	80002b3c <writei>
    80003774:	84aa                	mv	s1,a0
    80003776:	00a05763          	blez	a0,80003784 <filewrite+0xb4>
        f->off += r;
    8000377a:	02092783          	lw	a5,32(s2)
    8000377e:	9fa9                	addw	a5,a5,a0
    80003780:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003784:	01893503          	ld	a0,24(s2)
    80003788:	fdffe0ef          	jal	80002766 <iunlock>
      end_op();
    8000378c:	9a9ff0ef          	jal	80003134 <end_op>

      if(r != n1){
    80003790:	02999563          	bne	s3,s1,800037ba <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80003794:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003798:	015a5963          	bge	s4,s5,800037aa <filewrite+0xda>
      int n1 = n - i;
    8000379c:	414a87bb          	subw	a5,s5,s4
    800037a0:	89be                	mv	s3,a5
      if(n1 > max)
    800037a2:	fafbd8e3          	bge	s7,a5,80003752 <filewrite+0x82>
    800037a6:	89e6                	mv	s3,s9
    800037a8:	b76d                	j	80003752 <filewrite+0x82>
    800037aa:	64a6                	ld	s1,72(sp)
    800037ac:	79e2                	ld	s3,56(sp)
    800037ae:	6be2                	ld	s7,24(sp)
    800037b0:	6c42                	ld	s8,16(sp)
    800037b2:	6ca2                	ld	s9,8(sp)
    800037b4:	a801                	j	800037c4 <filewrite+0xf4>
    int i = 0;
    800037b6:	4a01                	li	s4,0
    800037b8:	a031                	j	800037c4 <filewrite+0xf4>
    800037ba:	64a6                	ld	s1,72(sp)
    800037bc:	79e2                	ld	s3,56(sp)
    800037be:	6be2                	ld	s7,24(sp)
    800037c0:	6c42                	ld	s8,16(sp)
    800037c2:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800037c4:	034a9d63          	bne	s5,s4,800037fe <filewrite+0x12e>
    800037c8:	8556                	mv	a0,s5
    800037ca:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800037cc:	60e6                	ld	ra,88(sp)
    800037ce:	6446                	ld	s0,80(sp)
    800037d0:	6906                	ld	s2,64(sp)
    800037d2:	7aa2                	ld	s5,40(sp)
    800037d4:	7b02                	ld	s6,32(sp)
    800037d6:	6125                	addi	sp,sp,96
    800037d8:	8082                	ret
    800037da:	e4a6                	sd	s1,72(sp)
    800037dc:	fc4e                	sd	s3,56(sp)
    800037de:	f852                	sd	s4,48(sp)
    800037e0:	ec5e                	sd	s7,24(sp)
    800037e2:	e862                	sd	s8,16(sp)
    800037e4:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800037e6:	00005517          	auipc	a0,0x5
    800037ea:	d5a50513          	addi	a0,a0,-678 # 80008540 <etext+0x540>
    800037ee:	4e4020ef          	jal	80005cd2 <panic>
    return -1;
    800037f2:	557d                	li	a0,-1
}
    800037f4:	8082                	ret
      return -1;
    800037f6:	557d                	li	a0,-1
    800037f8:	bfd1                	j	800037cc <filewrite+0xfc>
    800037fa:	557d                	li	a0,-1
    800037fc:	bfc1                	j	800037cc <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800037fe:	557d                	li	a0,-1
    80003800:	7a42                	ld	s4,48(sp)
    80003802:	b7e9                	j	800037cc <filewrite+0xfc>

0000000080003804 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003804:	7179                	addi	sp,sp,-48
    80003806:	f406                	sd	ra,40(sp)
    80003808:	f022                	sd	s0,32(sp)
    8000380a:	ec26                	sd	s1,24(sp)
    8000380c:	e052                	sd	s4,0(sp)
    8000380e:	1800                	addi	s0,sp,48
    80003810:	84aa                	mv	s1,a0
    80003812:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003814:	0005b023          	sd	zero,0(a1)
    80003818:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    8000381c:	c29ff0ef          	jal	80003444 <filealloc>
    80003820:	e088                	sd	a0,0(s1)
    80003822:	c549                	beqz	a0,800038ac <pipealloc+0xa8>
    80003824:	c21ff0ef          	jal	80003444 <filealloc>
    80003828:	00aa3023          	sd	a0,0(s4)
    8000382c:	cd25                	beqz	a0,800038a4 <pipealloc+0xa0>
    8000382e:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003830:	8d5fc0ef          	jal	80000104 <kalloc>
    80003834:	892a                	mv	s2,a0
    80003836:	c12d                	beqz	a0,80003898 <pipealloc+0x94>
    80003838:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    8000383a:	4985                	li	s3,1
    8000383c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003840:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003844:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003848:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    8000384c:	00005597          	auipc	a1,0x5
    80003850:	d0458593          	addi	a1,a1,-764 # 80008550 <etext+0x550>
    80003854:	6b6020ef          	jal	80005f0a <initlock>
  (*f0)->type = FD_PIPE;
    80003858:	609c                	ld	a5,0(s1)
    8000385a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000385e:	609c                	ld	a5,0(s1)
    80003860:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003864:	609c                	ld	a5,0(s1)
    80003866:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000386a:	609c                	ld	a5,0(s1)
    8000386c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003870:	000a3783          	ld	a5,0(s4)
    80003874:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003878:	000a3783          	ld	a5,0(s4)
    8000387c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003880:	000a3783          	ld	a5,0(s4)
    80003884:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003888:	000a3783          	ld	a5,0(s4)
    8000388c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003890:	4501                	li	a0,0
    80003892:	6942                	ld	s2,16(sp)
    80003894:	69a2                	ld	s3,8(sp)
    80003896:	a01d                	j	800038bc <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003898:	6088                	ld	a0,0(s1)
    8000389a:	c119                	beqz	a0,800038a0 <pipealloc+0x9c>
    8000389c:	6942                	ld	s2,16(sp)
    8000389e:	a029                	j	800038a8 <pipealloc+0xa4>
    800038a0:	6942                	ld	s2,16(sp)
    800038a2:	a029                	j	800038ac <pipealloc+0xa8>
    800038a4:	6088                	ld	a0,0(s1)
    800038a6:	c10d                	beqz	a0,800038c8 <pipealloc+0xc4>
    fileclose(*f0);
    800038a8:	c41ff0ef          	jal	800034e8 <fileclose>
  if(*f1)
    800038ac:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    800038b0:	557d                	li	a0,-1
  if(*f1)
    800038b2:	c789                	beqz	a5,800038bc <pipealloc+0xb8>
    fileclose(*f1);
    800038b4:	853e                	mv	a0,a5
    800038b6:	c33ff0ef          	jal	800034e8 <fileclose>
  return -1;
    800038ba:	557d                	li	a0,-1
}
    800038bc:	70a2                	ld	ra,40(sp)
    800038be:	7402                	ld	s0,32(sp)
    800038c0:	64e2                	ld	s1,24(sp)
    800038c2:	6a02                	ld	s4,0(sp)
    800038c4:	6145                	addi	sp,sp,48
    800038c6:	8082                	ret
  return -1;
    800038c8:	557d                	li	a0,-1
    800038ca:	bfcd                	j	800038bc <pipealloc+0xb8>

00000000800038cc <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800038cc:	1101                	addi	sp,sp,-32
    800038ce:	ec06                	sd	ra,24(sp)
    800038d0:	e822                	sd	s0,16(sp)
    800038d2:	e426                	sd	s1,8(sp)
    800038d4:	e04a                	sd	s2,0(sp)
    800038d6:	1000                	addi	s0,sp,32
    800038d8:	84aa                	mv	s1,a0
    800038da:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800038dc:	6b8020ef          	jal	80005f94 <acquire>
  if(writable){
    800038e0:	02090763          	beqz	s2,8000390e <pipeclose+0x42>
    pi->writeopen = 0;
    800038e4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800038e8:	21848513          	addi	a0,s1,536
    800038ec:	b41fd0ef          	jal	8000142c <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800038f0:	2204a783          	lw	a5,544(s1)
    800038f4:	e781                	bnez	a5,800038fc <pipeclose+0x30>
    800038f6:	2244a783          	lw	a5,548(s1)
    800038fa:	c38d                	beqz	a5,8000391c <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800038fc:	8526                	mv	a0,s1
    800038fe:	72a020ef          	jal	80006028 <release>
}
    80003902:	60e2                	ld	ra,24(sp)
    80003904:	6442                	ld	s0,16(sp)
    80003906:	64a2                	ld	s1,8(sp)
    80003908:	6902                	ld	s2,0(sp)
    8000390a:	6105                	addi	sp,sp,32
    8000390c:	8082                	ret
    pi->readopen = 0;
    8000390e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003912:	21c48513          	addi	a0,s1,540
    80003916:	b17fd0ef          	jal	8000142c <wakeup>
    8000391a:	bfd9                	j	800038f0 <pipeclose+0x24>
    release(&pi->lock);
    8000391c:	8526                	mv	a0,s1
    8000391e:	70a020ef          	jal	80006028 <release>
    kfree((char*)pi);
    80003922:	8526                	mv	a0,s1
    80003924:	ef8fc0ef          	jal	8000001c <kfree>
    80003928:	bfe9                	j	80003902 <pipeclose+0x36>

000000008000392a <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    8000392a:	7159                	addi	sp,sp,-112
    8000392c:	f486                	sd	ra,104(sp)
    8000392e:	f0a2                	sd	s0,96(sp)
    80003930:	eca6                	sd	s1,88(sp)
    80003932:	e8ca                	sd	s2,80(sp)
    80003934:	e4ce                	sd	s3,72(sp)
    80003936:	e0d2                	sd	s4,64(sp)
    80003938:	fc56                	sd	s5,56(sp)
    8000393a:	1880                	addi	s0,sp,112
    8000393c:	84aa                	mv	s1,a0
    8000393e:	8aae                	mv	s5,a1
    80003940:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003942:	ca0fd0ef          	jal	80000de2 <myproc>
    80003946:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003948:	8526                	mv	a0,s1
    8000394a:	64a020ef          	jal	80005f94 <acquire>
  while(i < n){
    8000394e:	0d405263          	blez	s4,80003a12 <pipewrite+0xe8>
    80003952:	f85a                	sd	s6,48(sp)
    80003954:	f45e                	sd	s7,40(sp)
    80003956:	f062                	sd	s8,32(sp)
    80003958:	ec66                	sd	s9,24(sp)
    8000395a:	e86a                	sd	s10,16(sp)
  int i = 0;
    8000395c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000395e:	f9f40c13          	addi	s8,s0,-97
    80003962:	4b85                	li	s7,1
    80003964:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003966:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000396a:	21c48c93          	addi	s9,s1,540
    8000396e:	a82d                	j	800039a8 <pipewrite+0x7e>
      release(&pi->lock);
    80003970:	8526                	mv	a0,s1
    80003972:	6b6020ef          	jal	80006028 <release>
      return -1;
    80003976:	597d                	li	s2,-1
    80003978:	7b42                	ld	s6,48(sp)
    8000397a:	7ba2                	ld	s7,40(sp)
    8000397c:	7c02                	ld	s8,32(sp)
    8000397e:	6ce2                	ld	s9,24(sp)
    80003980:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003982:	854a                	mv	a0,s2
    80003984:	70a6                	ld	ra,104(sp)
    80003986:	7406                	ld	s0,96(sp)
    80003988:	64e6                	ld	s1,88(sp)
    8000398a:	6946                	ld	s2,80(sp)
    8000398c:	69a6                	ld	s3,72(sp)
    8000398e:	6a06                	ld	s4,64(sp)
    80003990:	7ae2                	ld	s5,56(sp)
    80003992:	6165                	addi	sp,sp,112
    80003994:	8082                	ret
      wakeup(&pi->nread);
    80003996:	856a                	mv	a0,s10
    80003998:	a95fd0ef          	jal	8000142c <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000399c:	85a6                	mv	a1,s1
    8000399e:	8566                	mv	a0,s9
    800039a0:	a41fd0ef          	jal	800013e0 <sleep>
  while(i < n){
    800039a4:	05495a63          	bge	s2,s4,800039f8 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    800039a8:	2204a783          	lw	a5,544(s1)
    800039ac:	d3f1                	beqz	a5,80003970 <pipewrite+0x46>
    800039ae:	854e                	mv	a0,s3
    800039b0:	c6dfd0ef          	jal	8000161c <killed>
    800039b4:	fd55                	bnez	a0,80003970 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    800039b6:	2184a783          	lw	a5,536(s1)
    800039ba:	21c4a703          	lw	a4,540(s1)
    800039be:	2007879b          	addiw	a5,a5,512
    800039c2:	fcf70ae3          	beq	a4,a5,80003996 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800039c6:	86de                	mv	a3,s7
    800039c8:	01590633          	add	a2,s2,s5
    800039cc:	85e2                	mv	a1,s8
    800039ce:	0509b503          	ld	a0,80(s3)
    800039d2:	9f8fd0ef          	jal	80000bca <copyin>
    800039d6:	05650063          	beq	a0,s6,80003a16 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    800039da:	21c4a783          	lw	a5,540(s1)
    800039de:	0017871b          	addiw	a4,a5,1
    800039e2:	20e4ae23          	sw	a4,540(s1)
    800039e6:	1ff7f793          	andi	a5,a5,511
    800039ea:	97a6                	add	a5,a5,s1
    800039ec:	f9f44703          	lbu	a4,-97(s0)
    800039f0:	00e78c23          	sb	a4,24(a5)
      i++;
    800039f4:	2905                	addiw	s2,s2,1
    800039f6:	b77d                	j	800039a4 <pipewrite+0x7a>
    800039f8:	7b42                	ld	s6,48(sp)
    800039fa:	7ba2                	ld	s7,40(sp)
    800039fc:	7c02                	ld	s8,32(sp)
    800039fe:	6ce2                	ld	s9,24(sp)
    80003a00:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003a02:	21848513          	addi	a0,s1,536
    80003a06:	a27fd0ef          	jal	8000142c <wakeup>
  release(&pi->lock);
    80003a0a:	8526                	mv	a0,s1
    80003a0c:	61c020ef          	jal	80006028 <release>
  return i;
    80003a10:	bf8d                	j	80003982 <pipewrite+0x58>
  int i = 0;
    80003a12:	4901                	li	s2,0
    80003a14:	b7fd                	j	80003a02 <pipewrite+0xd8>
    80003a16:	7b42                	ld	s6,48(sp)
    80003a18:	7ba2                	ld	s7,40(sp)
    80003a1a:	7c02                	ld	s8,32(sp)
    80003a1c:	6ce2                	ld	s9,24(sp)
    80003a1e:	6d42                	ld	s10,16(sp)
    80003a20:	b7cd                	j	80003a02 <pipewrite+0xd8>

0000000080003a22 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003a22:	711d                	addi	sp,sp,-96
    80003a24:	ec86                	sd	ra,88(sp)
    80003a26:	e8a2                	sd	s0,80(sp)
    80003a28:	e4a6                	sd	s1,72(sp)
    80003a2a:	e0ca                	sd	s2,64(sp)
    80003a2c:	fc4e                	sd	s3,56(sp)
    80003a2e:	f852                	sd	s4,48(sp)
    80003a30:	f456                	sd	s5,40(sp)
    80003a32:	1080                	addi	s0,sp,96
    80003a34:	84aa                	mv	s1,a0
    80003a36:	892e                	mv	s2,a1
    80003a38:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003a3a:	ba8fd0ef          	jal	80000de2 <myproc>
    80003a3e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003a40:	8526                	mv	a0,s1
    80003a42:	552020ef          	jal	80005f94 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a46:	2184a703          	lw	a4,536(s1)
    80003a4a:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a4e:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a52:	02f71763          	bne	a4,a5,80003a80 <piperead+0x5e>
    80003a56:	2244a783          	lw	a5,548(s1)
    80003a5a:	cf85                	beqz	a5,80003a92 <piperead+0x70>
    if(killed(pr)){
    80003a5c:	8552                	mv	a0,s4
    80003a5e:	bbffd0ef          	jal	8000161c <killed>
    80003a62:	e11d                	bnez	a0,80003a88 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a64:	85a6                	mv	a1,s1
    80003a66:	854e                	mv	a0,s3
    80003a68:	979fd0ef          	jal	800013e0 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a6c:	2184a703          	lw	a4,536(s1)
    80003a70:	21c4a783          	lw	a5,540(s1)
    80003a74:	fef701e3          	beq	a4,a5,80003a56 <piperead+0x34>
    80003a78:	f05a                	sd	s6,32(sp)
    80003a7a:	ec5e                	sd	s7,24(sp)
    80003a7c:	e862                	sd	s8,16(sp)
    80003a7e:	a829                	j	80003a98 <piperead+0x76>
    80003a80:	f05a                	sd	s6,32(sp)
    80003a82:	ec5e                	sd	s7,24(sp)
    80003a84:	e862                	sd	s8,16(sp)
    80003a86:	a809                	j	80003a98 <piperead+0x76>
      release(&pi->lock);
    80003a88:	8526                	mv	a0,s1
    80003a8a:	59e020ef          	jal	80006028 <release>
      return -1;
    80003a8e:	59fd                	li	s3,-1
    80003a90:	a09d                	j	80003af6 <piperead+0xd4>
    80003a92:	f05a                	sd	s6,32(sp)
    80003a94:	ec5e                	sd	s7,24(sp)
    80003a96:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a98:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a9a:	faf40c13          	addi	s8,s0,-81
    80003a9e:	4b85                	li	s7,1
    80003aa0:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003aa2:	05505063          	blez	s5,80003ae2 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003aa6:	2184a783          	lw	a5,536(s1)
    80003aaa:	21c4a703          	lw	a4,540(s1)
    80003aae:	02f70a63          	beq	a4,a5,80003ae2 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003ab2:	0017871b          	addiw	a4,a5,1
    80003ab6:	20e4ac23          	sw	a4,536(s1)
    80003aba:	1ff7f793          	andi	a5,a5,511
    80003abe:	97a6                	add	a5,a5,s1
    80003ac0:	0187c783          	lbu	a5,24(a5)
    80003ac4:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ac8:	86de                	mv	a3,s7
    80003aca:	8662                	mv	a2,s8
    80003acc:	85ca                	mv	a1,s2
    80003ace:	050a3503          	ld	a0,80(s4)
    80003ad2:	834fd0ef          	jal	80000b06 <copyout>
    80003ad6:	01650663          	beq	a0,s6,80003ae2 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ada:	2985                	addiw	s3,s3,1
    80003adc:	0905                	addi	s2,s2,1
    80003ade:	fd3a94e3          	bne	s5,s3,80003aa6 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003ae2:	21c48513          	addi	a0,s1,540
    80003ae6:	947fd0ef          	jal	8000142c <wakeup>
  release(&pi->lock);
    80003aea:	8526                	mv	a0,s1
    80003aec:	53c020ef          	jal	80006028 <release>
    80003af0:	7b02                	ld	s6,32(sp)
    80003af2:	6be2                	ld	s7,24(sp)
    80003af4:	6c42                	ld	s8,16(sp)
  return i;
}
    80003af6:	854e                	mv	a0,s3
    80003af8:	60e6                	ld	ra,88(sp)
    80003afa:	6446                	ld	s0,80(sp)
    80003afc:	64a6                	ld	s1,72(sp)
    80003afe:	6906                	ld	s2,64(sp)
    80003b00:	79e2                	ld	s3,56(sp)
    80003b02:	7a42                	ld	s4,48(sp)
    80003b04:	7aa2                	ld	s5,40(sp)
    80003b06:	6125                	addi	sp,sp,96
    80003b08:	8082                	ret

0000000080003b0a <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003b0a:	1141                	addi	sp,sp,-16
    80003b0c:	e406                	sd	ra,8(sp)
    80003b0e:	e022                	sd	s0,0(sp)
    80003b10:	0800                	addi	s0,sp,16
    80003b12:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003b14:	0035151b          	slliw	a0,a0,0x3
    80003b18:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003b1a:	8b89                	andi	a5,a5,2
    80003b1c:	c399                	beqz	a5,80003b22 <flags2perm+0x18>
      perm |= PTE_W;
    80003b1e:	00456513          	ori	a0,a0,4
    return perm;
}
    80003b22:	60a2                	ld	ra,8(sp)
    80003b24:	6402                	ld	s0,0(sp)
    80003b26:	0141                	addi	sp,sp,16
    80003b28:	8082                	ret

0000000080003b2a <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003b2a:	de010113          	addi	sp,sp,-544
    80003b2e:	20113c23          	sd	ra,536(sp)
    80003b32:	20813823          	sd	s0,528(sp)
    80003b36:	20913423          	sd	s1,520(sp)
    80003b3a:	21213023          	sd	s2,512(sp)
    80003b3e:	1400                	addi	s0,sp,544
    80003b40:	892a                	mv	s2,a0
    80003b42:	dea43823          	sd	a0,-528(s0)
    80003b46:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003b4a:	a98fd0ef          	jal	80000de2 <myproc>
    80003b4e:	84aa                	mv	s1,a0

  begin_op();
    80003b50:	d74ff0ef          	jal	800030c4 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003b54:	854a                	mv	a0,s2
    80003b56:	b90ff0ef          	jal	80002ee6 <namei>
    80003b5a:	cd21                	beqz	a0,80003bb2 <kexec+0x88>
    80003b5c:	fbd2                	sd	s4,496(sp)
    80003b5e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003b60:	b59fe0ef          	jal	800026b8 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b64:	04000713          	li	a4,64
    80003b68:	4681                	li	a3,0
    80003b6a:	e5040613          	addi	a2,s0,-432
    80003b6e:	4581                	li	a1,0
    80003b70:	8552                	mv	a0,s4
    80003b72:	ed9fe0ef          	jal	80002a4a <readi>
    80003b76:	04000793          	li	a5,64
    80003b7a:	00f51a63          	bne	a0,a5,80003b8e <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003b7e:	e5042703          	lw	a4,-432(s0)
    80003b82:	464c47b7          	lui	a5,0x464c4
    80003b86:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b8a:	02f70863          	beq	a4,a5,80003bba <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b8e:	8552                	mv	a0,s4
    80003b90:	d35fe0ef          	jal	800028c4 <iunlockput>
    end_op();
    80003b94:	da0ff0ef          	jal	80003134 <end_op>
  }
  return -1;
    80003b98:	557d                	li	a0,-1
    80003b9a:	7a5e                	ld	s4,496(sp)
}
    80003b9c:	21813083          	ld	ra,536(sp)
    80003ba0:	21013403          	ld	s0,528(sp)
    80003ba4:	20813483          	ld	s1,520(sp)
    80003ba8:	20013903          	ld	s2,512(sp)
    80003bac:	22010113          	addi	sp,sp,544
    80003bb0:	8082                	ret
    end_op();
    80003bb2:	d82ff0ef          	jal	80003134 <end_op>
    return -1;
    80003bb6:	557d                	li	a0,-1
    80003bb8:	b7d5                	j	80003b9c <kexec+0x72>
    80003bba:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003bbc:	8526                	mv	a0,s1
    80003bbe:	b2efd0ef          	jal	80000eec <proc_pagetable>
    80003bc2:	8b2a                	mv	s6,a0
    80003bc4:	26050f63          	beqz	a0,80003e42 <kexec+0x318>
    80003bc8:	ffce                	sd	s3,504(sp)
    80003bca:	f7d6                	sd	s5,488(sp)
    80003bcc:	efde                	sd	s7,472(sp)
    80003bce:	ebe2                	sd	s8,464(sp)
    80003bd0:	e7e6                	sd	s9,456(sp)
    80003bd2:	e3ea                	sd	s10,448(sp)
    80003bd4:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003bd6:	e8845783          	lhu	a5,-376(s0)
    80003bda:	0e078963          	beqz	a5,80003ccc <kexec+0x1a2>
    80003bde:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003be2:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003be4:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003be6:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003bea:	6c85                	lui	s9,0x1
    80003bec:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003bf0:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003bf4:	6a85                	lui	s5,0x1
    80003bf6:	a085                	j	80003c56 <kexec+0x12c>
      panic("loadseg: address should exist");
    80003bf8:	00005517          	auipc	a0,0x5
    80003bfc:	96050513          	addi	a0,a0,-1696 # 80008558 <etext+0x558>
    80003c00:	0d2020ef          	jal	80005cd2 <panic>
    if(sz - i < PGSIZE)
    80003c04:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003c06:	874a                	mv	a4,s2
    80003c08:	009b86bb          	addw	a3,s7,s1
    80003c0c:	4581                	li	a1,0
    80003c0e:	8552                	mv	a0,s4
    80003c10:	e3bfe0ef          	jal	80002a4a <readi>
    80003c14:	22a91b63          	bne	s2,a0,80003e4a <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80003c18:	009a84bb          	addw	s1,s5,s1
    80003c1c:	0334f263          	bgeu	s1,s3,80003c40 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003c20:	02049593          	slli	a1,s1,0x20
    80003c24:	9181                	srli	a1,a1,0x20
    80003c26:	95e2                	add	a1,a1,s8
    80003c28:	855a                	mv	a0,s6
    80003c2a:	86ffc0ef          	jal	80000498 <walkaddr>
    80003c2e:	862a                	mv	a2,a0
    if(pa == 0)
    80003c30:	d561                	beqz	a0,80003bf8 <kexec+0xce>
    if(sz - i < PGSIZE)
    80003c32:	409987bb          	subw	a5,s3,s1
    80003c36:	893e                	mv	s2,a5
    80003c38:	fcfcf6e3          	bgeu	s9,a5,80003c04 <kexec+0xda>
    80003c3c:	8956                	mv	s2,s5
    80003c3e:	b7d9                	j	80003c04 <kexec+0xda>
    sz = sz1;
    80003c40:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c44:	2d05                	addiw	s10,s10,1
    80003c46:	e0843783          	ld	a5,-504(s0)
    80003c4a:	0387869b          	addiw	a3,a5,56
    80003c4e:	e8845783          	lhu	a5,-376(s0)
    80003c52:	06fd5e63          	bge	s10,a5,80003cce <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c56:	e0d43423          	sd	a3,-504(s0)
    80003c5a:	876e                	mv	a4,s11
    80003c5c:	e1840613          	addi	a2,s0,-488
    80003c60:	4581                	li	a1,0
    80003c62:	8552                	mv	a0,s4
    80003c64:	de7fe0ef          	jal	80002a4a <readi>
    80003c68:	1db51f63          	bne	a0,s11,80003e46 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80003c6c:	e1842783          	lw	a5,-488(s0)
    80003c70:	4705                	li	a4,1
    80003c72:	fce799e3          	bne	a5,a4,80003c44 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003c76:	e4043483          	ld	s1,-448(s0)
    80003c7a:	e3843783          	ld	a5,-456(s0)
    80003c7e:	1ef4e463          	bltu	s1,a5,80003e66 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c82:	e2843783          	ld	a5,-472(s0)
    80003c86:	94be                	add	s1,s1,a5
    80003c88:	1ef4e263          	bltu	s1,a5,80003e6c <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80003c8c:	de843703          	ld	a4,-536(s0)
    80003c90:	8ff9                	and	a5,a5,a4
    80003c92:	1e079063          	bnez	a5,80003e72 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c96:	e1c42503          	lw	a0,-484(s0)
    80003c9a:	e71ff0ef          	jal	80003b0a <flags2perm>
    80003c9e:	86aa                	mv	a3,a0
    80003ca0:	8626                	mv	a2,s1
    80003ca2:	85ca                	mv	a1,s2
    80003ca4:	855a                	mv	a0,s6
    80003ca6:	b09fc0ef          	jal	800007ae <uvmalloc>
    80003caa:	dea43c23          	sd	a0,-520(s0)
    80003cae:	1c050563          	beqz	a0,80003e78 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003cb2:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003cb6:	00098863          	beqz	s3,80003cc6 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003cba:	e2843c03          	ld	s8,-472(s0)
    80003cbe:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003cc2:	4481                	li	s1,0
    80003cc4:	bfb1                	j	80003c20 <kexec+0xf6>
    sz = sz1;
    80003cc6:	df843903          	ld	s2,-520(s0)
    80003cca:	bfad                	j	80003c44 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003ccc:	4901                	li	s2,0
  iunlockput(ip);
    80003cce:	8552                	mv	a0,s4
    80003cd0:	bf5fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    80003cd4:	c60ff0ef          	jal	80003134 <end_op>
  p = myproc();
    80003cd8:	90afd0ef          	jal	80000de2 <myproc>
    80003cdc:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003cde:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003ce2:	6985                	lui	s3,0x1
    80003ce4:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003ce6:	99ca                	add	s3,s3,s2
    80003ce8:	77fd                	lui	a5,0xfffff
    80003cea:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003cee:	4691                	li	a3,4
    80003cf0:	6609                	lui	a2,0x2
    80003cf2:	964e                	add	a2,a2,s3
    80003cf4:	85ce                	mv	a1,s3
    80003cf6:	855a                	mv	a0,s6
    80003cf8:	ab7fc0ef          	jal	800007ae <uvmalloc>
    80003cfc:	8a2a                	mv	s4,a0
    80003cfe:	e105                	bnez	a0,80003d1e <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003d00:	85ce                	mv	a1,s3
    80003d02:	855a                	mv	a0,s6
    80003d04:	a6cfd0ef          	jal	80000f70 <proc_freepagetable>
  return -1;
    80003d08:	557d                	li	a0,-1
    80003d0a:	79fe                	ld	s3,504(sp)
    80003d0c:	7a5e                	ld	s4,496(sp)
    80003d0e:	7abe                	ld	s5,488(sp)
    80003d10:	7b1e                	ld	s6,480(sp)
    80003d12:	6bfe                	ld	s7,472(sp)
    80003d14:	6c5e                	ld	s8,464(sp)
    80003d16:	6cbe                	ld	s9,456(sp)
    80003d18:	6d1e                	ld	s10,448(sp)
    80003d1a:	7dfa                	ld	s11,440(sp)
    80003d1c:	b541                	j	80003b9c <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003d1e:	75f9                	lui	a1,0xffffe
    80003d20:	95aa                	add	a1,a1,a0
    80003d22:	855a                	mv	a0,s6
    80003d24:	c5dfc0ef          	jal	80000980 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003d28:	800a0b93          	addi	s7,s4,-2048
    80003d2c:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80003d30:	e0043783          	ld	a5,-512(s0)
    80003d34:	6388                	ld	a0,0(a5)
  sp = sz;
    80003d36:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003d38:	4481                	li	s1,0
    ustack[argc] = sp;
    80003d3a:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003d3e:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003d42:	cd21                	beqz	a0,80003d9a <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80003d44:	da4fc0ef          	jal	800002e8 <strlen>
    80003d48:	0015079b          	addiw	a5,a0,1
    80003d4c:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003d50:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003d54:	13796563          	bltu	s2,s7,80003e7e <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003d58:	e0043d83          	ld	s11,-512(s0)
    80003d5c:	000db983          	ld	s3,0(s11)
    80003d60:	854e                	mv	a0,s3
    80003d62:	d86fc0ef          	jal	800002e8 <strlen>
    80003d66:	0015069b          	addiw	a3,a0,1
    80003d6a:	864e                	mv	a2,s3
    80003d6c:	85ca                	mv	a1,s2
    80003d6e:	855a                	mv	a0,s6
    80003d70:	d97fc0ef          	jal	80000b06 <copyout>
    80003d74:	10054763          	bltz	a0,80003e82 <kexec+0x358>
    ustack[argc] = sp;
    80003d78:	00349793          	slli	a5,s1,0x3
    80003d7c:	97e6                	add	a5,a5,s9
    80003d7e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdd128>
  for(argc = 0; argv[argc]; argc++) {
    80003d82:	0485                	addi	s1,s1,1
    80003d84:	008d8793          	addi	a5,s11,8
    80003d88:	e0f43023          	sd	a5,-512(s0)
    80003d8c:	008db503          	ld	a0,8(s11)
    80003d90:	c509                	beqz	a0,80003d9a <kexec+0x270>
    if(argc >= MAXARG)
    80003d92:	fb8499e3          	bne	s1,s8,80003d44 <kexec+0x21a>
  sz = sz1;
    80003d96:	89d2                	mv	s3,s4
    80003d98:	b7a5                	j	80003d00 <kexec+0x1d6>
  ustack[argc] = 0;
    80003d9a:	00349793          	slli	a5,s1,0x3
    80003d9e:	f9078793          	addi	a5,a5,-112
    80003da2:	97a2                	add	a5,a5,s0
    80003da4:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003da8:	00349693          	slli	a3,s1,0x3
    80003dac:	06a1                	addi	a3,a3,8
    80003dae:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003db2:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003db6:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003db8:	f57964e3          	bltu	s2,s7,80003d00 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003dbc:	e9040613          	addi	a2,s0,-368
    80003dc0:	85ca                	mv	a1,s2
    80003dc2:	855a                	mv	a0,s6
    80003dc4:	d43fc0ef          	jal	80000b06 <copyout>
    80003dc8:	f2054ce3          	bltz	a0,80003d00 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80003dcc:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003dd0:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003dd4:	df043783          	ld	a5,-528(s0)
    80003dd8:	0007c703          	lbu	a4,0(a5)
    80003ddc:	cf11                	beqz	a4,80003df8 <kexec+0x2ce>
    80003dde:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003de0:	02f00693          	li	a3,47
    80003de4:	a029                	j	80003dee <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80003de6:	0785                	addi	a5,a5,1
    80003de8:	fff7c703          	lbu	a4,-1(a5)
    80003dec:	c711                	beqz	a4,80003df8 <kexec+0x2ce>
    if(*s == '/')
    80003dee:	fed71ce3          	bne	a4,a3,80003de6 <kexec+0x2bc>
      last = s+1;
    80003df2:	def43823          	sd	a5,-528(s0)
    80003df6:	bfc5                	j	80003de6 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80003df8:	4641                	li	a2,16
    80003dfa:	df043583          	ld	a1,-528(s0)
    80003dfe:	158a8513          	addi	a0,s5,344
    80003e02:	cb0fc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003e06:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003e0a:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003e0e:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80003e12:	058ab783          	ld	a5,88(s5)
    80003e16:	e6843703          	ld	a4,-408(s0)
    80003e1a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003e1c:	058ab783          	ld	a5,88(s5)
    80003e20:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003e24:	85ea                	mv	a1,s10
    80003e26:	94afd0ef          	jal	80000f70 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003e2a:	0004851b          	sext.w	a0,s1
    80003e2e:	79fe                	ld	s3,504(sp)
    80003e30:	7a5e                	ld	s4,496(sp)
    80003e32:	7abe                	ld	s5,488(sp)
    80003e34:	7b1e                	ld	s6,480(sp)
    80003e36:	6bfe                	ld	s7,472(sp)
    80003e38:	6c5e                	ld	s8,464(sp)
    80003e3a:	6cbe                	ld	s9,456(sp)
    80003e3c:	6d1e                	ld	s10,448(sp)
    80003e3e:	7dfa                	ld	s11,440(sp)
    80003e40:	bbb1                	j	80003b9c <kexec+0x72>
    80003e42:	7b1e                	ld	s6,480(sp)
    80003e44:	b3a9                	j	80003b8e <kexec+0x64>
    80003e46:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003e4a:	df843583          	ld	a1,-520(s0)
    80003e4e:	855a                	mv	a0,s6
    80003e50:	920fd0ef          	jal	80000f70 <proc_freepagetable>
  if(ip){
    80003e54:	79fe                	ld	s3,504(sp)
    80003e56:	7abe                	ld	s5,488(sp)
    80003e58:	7b1e                	ld	s6,480(sp)
    80003e5a:	6bfe                	ld	s7,472(sp)
    80003e5c:	6c5e                	ld	s8,464(sp)
    80003e5e:	6cbe                	ld	s9,456(sp)
    80003e60:	6d1e                	ld	s10,448(sp)
    80003e62:	7dfa                	ld	s11,440(sp)
    80003e64:	b32d                	j	80003b8e <kexec+0x64>
    80003e66:	df243c23          	sd	s2,-520(s0)
    80003e6a:	b7c5                	j	80003e4a <kexec+0x320>
    80003e6c:	df243c23          	sd	s2,-520(s0)
    80003e70:	bfe9                	j	80003e4a <kexec+0x320>
    80003e72:	df243c23          	sd	s2,-520(s0)
    80003e76:	bfd1                	j	80003e4a <kexec+0x320>
    80003e78:	df243c23          	sd	s2,-520(s0)
    80003e7c:	b7f9                	j	80003e4a <kexec+0x320>
  sz = sz1;
    80003e7e:	89d2                	mv	s3,s4
    80003e80:	b541                	j	80003d00 <kexec+0x1d6>
    80003e82:	89d2                	mv	s3,s4
    80003e84:	bdb5                	j	80003d00 <kexec+0x1d6>

0000000080003e86 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e86:	7179                	addi	sp,sp,-48
    80003e88:	f406                	sd	ra,40(sp)
    80003e8a:	f022                	sd	s0,32(sp)
    80003e8c:	ec26                	sd	s1,24(sp)
    80003e8e:	e84a                	sd	s2,16(sp)
    80003e90:	1800                	addi	s0,sp,48
    80003e92:	892e                	mv	s2,a1
    80003e94:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e96:	fdc40593          	addi	a1,s0,-36
    80003e9a:	e61fd0ef          	jal	80001cfa <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e9e:	fdc42703          	lw	a4,-36(s0)
    80003ea2:	47bd                	li	a5,15
    80003ea4:	02e7ea63          	bltu	a5,a4,80003ed8 <argfd+0x52>
    80003ea8:	f3bfc0ef          	jal	80000de2 <myproc>
    80003eac:	fdc42703          	lw	a4,-36(s0)
    80003eb0:	00371793          	slli	a5,a4,0x3
    80003eb4:	0d078793          	addi	a5,a5,208
    80003eb8:	953e                	add	a0,a0,a5
    80003eba:	611c                	ld	a5,0(a0)
    80003ebc:	c385                	beqz	a5,80003edc <argfd+0x56>
    return -1;
  if(pfd)
    80003ebe:	00090463          	beqz	s2,80003ec6 <argfd+0x40>
    *pfd = fd;
    80003ec2:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003ec6:	4501                	li	a0,0
  if(pf)
    80003ec8:	c091                	beqz	s1,80003ecc <argfd+0x46>
    *pf = f;
    80003eca:	e09c                	sd	a5,0(s1)
}
    80003ecc:	70a2                	ld	ra,40(sp)
    80003ece:	7402                	ld	s0,32(sp)
    80003ed0:	64e2                	ld	s1,24(sp)
    80003ed2:	6942                	ld	s2,16(sp)
    80003ed4:	6145                	addi	sp,sp,48
    80003ed6:	8082                	ret
    return -1;
    80003ed8:	557d                	li	a0,-1
    80003eda:	bfcd                	j	80003ecc <argfd+0x46>
    80003edc:	557d                	li	a0,-1
    80003ede:	b7fd                	j	80003ecc <argfd+0x46>

0000000080003ee0 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003ee0:	1101                	addi	sp,sp,-32
    80003ee2:	ec06                	sd	ra,24(sp)
    80003ee4:	e822                	sd	s0,16(sp)
    80003ee6:	e426                	sd	s1,8(sp)
    80003ee8:	1000                	addi	s0,sp,32
    80003eea:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003eec:	ef7fc0ef          	jal	80000de2 <myproc>
    80003ef0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003ef2:	0d050793          	addi	a5,a0,208
    80003ef6:	4501                	li	a0,0
    80003ef8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003efa:	6398                	ld	a4,0(a5)
    80003efc:	cb19                	beqz	a4,80003f12 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003efe:	2505                	addiw	a0,a0,1
    80003f00:	07a1                	addi	a5,a5,8
    80003f02:	fed51ce3          	bne	a0,a3,80003efa <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003f06:	557d                	li	a0,-1
}
    80003f08:	60e2                	ld	ra,24(sp)
    80003f0a:	6442                	ld	s0,16(sp)
    80003f0c:	64a2                	ld	s1,8(sp)
    80003f0e:	6105                	addi	sp,sp,32
    80003f10:	8082                	ret
      p->ofile[fd] = f;
    80003f12:	00351793          	slli	a5,a0,0x3
    80003f16:	0d078793          	addi	a5,a5,208
    80003f1a:	963e                	add	a2,a2,a5
    80003f1c:	e204                	sd	s1,0(a2)
      return fd;
    80003f1e:	b7ed                	j	80003f08 <fdalloc+0x28>

0000000080003f20 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003f20:	715d                	addi	sp,sp,-80
    80003f22:	e486                	sd	ra,72(sp)
    80003f24:	e0a2                	sd	s0,64(sp)
    80003f26:	fc26                	sd	s1,56(sp)
    80003f28:	f84a                	sd	s2,48(sp)
    80003f2a:	f44e                	sd	s3,40(sp)
    80003f2c:	f052                	sd	s4,32(sp)
    80003f2e:	ec56                	sd	s5,24(sp)
    80003f30:	e85a                	sd	s6,16(sp)
    80003f32:	0880                	addi	s0,sp,80
    80003f34:	892e                	mv	s2,a1
    80003f36:	8a2e                	mv	s4,a1
    80003f38:	8ab2                	mv	s5,a2
    80003f3a:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003f3c:	fb040593          	addi	a1,s0,-80
    80003f40:	fc1fe0ef          	jal	80002f00 <nameiparent>
    80003f44:	84aa                	mv	s1,a0
    80003f46:	10050763          	beqz	a0,80004054 <create+0x134>
    return 0;

  ilock(dp);
    80003f4a:	f6efe0ef          	jal	800026b8 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003f4e:	4601                	li	a2,0
    80003f50:	fb040593          	addi	a1,s0,-80
    80003f54:	8526                	mv	a0,s1
    80003f56:	cfdfe0ef          	jal	80002c52 <dirlookup>
    80003f5a:	89aa                	mv	s3,a0
    80003f5c:	c131                	beqz	a0,80003fa0 <create+0x80>
    iunlockput(dp);
    80003f5e:	8526                	mv	a0,s1
    80003f60:	965fe0ef          	jal	800028c4 <iunlockput>
    ilock(ip);
    80003f64:	854e                	mv	a0,s3
    80003f66:	f52fe0ef          	jal	800026b8 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003f6a:	4789                	li	a5,2
    80003f6c:	02f91563          	bne	s2,a5,80003f96 <create+0x76>
    80003f70:	0449d783          	lhu	a5,68(s3)
    80003f74:	37f9                	addiw	a5,a5,-2
    80003f76:	17c2                	slli	a5,a5,0x30
    80003f78:	93c1                	srli	a5,a5,0x30
    80003f7a:	4705                	li	a4,1
    80003f7c:	00f76d63          	bltu	a4,a5,80003f96 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f80:	854e                	mv	a0,s3
    80003f82:	60a6                	ld	ra,72(sp)
    80003f84:	6406                	ld	s0,64(sp)
    80003f86:	74e2                	ld	s1,56(sp)
    80003f88:	7942                	ld	s2,48(sp)
    80003f8a:	79a2                	ld	s3,40(sp)
    80003f8c:	7a02                	ld	s4,32(sp)
    80003f8e:	6ae2                	ld	s5,24(sp)
    80003f90:	6b42                	ld	s6,16(sp)
    80003f92:	6161                	addi	sp,sp,80
    80003f94:	8082                	ret
    iunlockput(ip);
    80003f96:	854e                	mv	a0,s3
    80003f98:	92dfe0ef          	jal	800028c4 <iunlockput>
    return 0;
    80003f9c:	4981                	li	s3,0
    80003f9e:	b7cd                	j	80003f80 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003fa0:	85ca                	mv	a1,s2
    80003fa2:	4088                	lw	a0,0(s1)
    80003fa4:	da4fe0ef          	jal	80002548 <ialloc>
    80003fa8:	892a                	mv	s2,a0
    80003faa:	cd15                	beqz	a0,80003fe6 <create+0xc6>
  ilock(ip);
    80003fac:	f0cfe0ef          	jal	800026b8 <ilock>
  ip->major = major;
    80003fb0:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80003fb4:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80003fb8:	4785                	li	a5,1
    80003fba:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80003fbe:	854a                	mv	a0,s2
    80003fc0:	e44fe0ef          	jal	80002604 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003fc4:	4705                	li	a4,1
    80003fc6:	02ea0463          	beq	s4,a4,80003fee <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fca:	00492603          	lw	a2,4(s2)
    80003fce:	fb040593          	addi	a1,s0,-80
    80003fd2:	8526                	mv	a0,s1
    80003fd4:	e69fe0ef          	jal	80002e3c <dirlink>
    80003fd8:	06054263          	bltz	a0,8000403c <create+0x11c>
  iunlockput(dp);
    80003fdc:	8526                	mv	a0,s1
    80003fde:	8e7fe0ef          	jal	800028c4 <iunlockput>
  return ip;
    80003fe2:	89ca                	mv	s3,s2
    80003fe4:	bf71                	j	80003f80 <create+0x60>
    iunlockput(dp);
    80003fe6:	8526                	mv	a0,s1
    80003fe8:	8ddfe0ef          	jal	800028c4 <iunlockput>
    return 0;
    80003fec:	bf51                	j	80003f80 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003fee:	00492603          	lw	a2,4(s2)
    80003ff2:	00004597          	auipc	a1,0x4
    80003ff6:	58658593          	addi	a1,a1,1414 # 80008578 <etext+0x578>
    80003ffa:	854a                	mv	a0,s2
    80003ffc:	e41fe0ef          	jal	80002e3c <dirlink>
    80004000:	02054e63          	bltz	a0,8000403c <create+0x11c>
    80004004:	40d0                	lw	a2,4(s1)
    80004006:	00004597          	auipc	a1,0x4
    8000400a:	57a58593          	addi	a1,a1,1402 # 80008580 <etext+0x580>
    8000400e:	854a                	mv	a0,s2
    80004010:	e2dfe0ef          	jal	80002e3c <dirlink>
    80004014:	02054463          	bltz	a0,8000403c <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004018:	00492603          	lw	a2,4(s2)
    8000401c:	fb040593          	addi	a1,s0,-80
    80004020:	8526                	mv	a0,s1
    80004022:	e1bfe0ef          	jal	80002e3c <dirlink>
    80004026:	00054b63          	bltz	a0,8000403c <create+0x11c>
    dp->nlink++;  // for ".."
    8000402a:	04a4d783          	lhu	a5,74(s1)
    8000402e:	2785                	addiw	a5,a5,1
    80004030:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004034:	8526                	mv	a0,s1
    80004036:	dcefe0ef          	jal	80002604 <iupdate>
    8000403a:	b74d                	j	80003fdc <create+0xbc>
  ip->nlink = 0;
    8000403c:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004040:	854a                	mv	a0,s2
    80004042:	dc2fe0ef          	jal	80002604 <iupdate>
  iunlockput(ip);
    80004046:	854a                	mv	a0,s2
    80004048:	87dfe0ef          	jal	800028c4 <iunlockput>
  iunlockput(dp);
    8000404c:	8526                	mv	a0,s1
    8000404e:	877fe0ef          	jal	800028c4 <iunlockput>
  return 0;
    80004052:	b73d                	j	80003f80 <create+0x60>
    return 0;
    80004054:	89aa                	mv	s3,a0
    80004056:	b72d                	j	80003f80 <create+0x60>

0000000080004058 <sys_dup>:
{
    80004058:	7179                	addi	sp,sp,-48
    8000405a:	f406                	sd	ra,40(sp)
    8000405c:	f022                	sd	s0,32(sp)
    8000405e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004060:	fd840613          	addi	a2,s0,-40
    80004064:	4581                	li	a1,0
    80004066:	4501                	li	a0,0
    80004068:	e1fff0ef          	jal	80003e86 <argfd>
    return -1;
    8000406c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000406e:	02054363          	bltz	a0,80004094 <sys_dup+0x3c>
    80004072:	ec26                	sd	s1,24(sp)
    80004074:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004076:	fd843483          	ld	s1,-40(s0)
    8000407a:	8526                	mv	a0,s1
    8000407c:	e65ff0ef          	jal	80003ee0 <fdalloc>
    80004080:	892a                	mv	s2,a0
    return -1;
    80004082:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004084:	00054d63          	bltz	a0,8000409e <sys_dup+0x46>
  filedup(f);
    80004088:	8526                	mv	a0,s1
    8000408a:	c18ff0ef          	jal	800034a2 <filedup>
  return fd;
    8000408e:	87ca                	mv	a5,s2
    80004090:	64e2                	ld	s1,24(sp)
    80004092:	6942                	ld	s2,16(sp)
}
    80004094:	853e                	mv	a0,a5
    80004096:	70a2                	ld	ra,40(sp)
    80004098:	7402                	ld	s0,32(sp)
    8000409a:	6145                	addi	sp,sp,48
    8000409c:	8082                	ret
    8000409e:	64e2                	ld	s1,24(sp)
    800040a0:	6942                	ld	s2,16(sp)
    800040a2:	bfcd                	j	80004094 <sys_dup+0x3c>

00000000800040a4 <sys_read>:
{
    800040a4:	7179                	addi	sp,sp,-48
    800040a6:	f406                	sd	ra,40(sp)
    800040a8:	f022                	sd	s0,32(sp)
    800040aa:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040ac:	fd840593          	addi	a1,s0,-40
    800040b0:	4505                	li	a0,1
    800040b2:	c65fd0ef          	jal	80001d16 <argaddr>
  argint(2, &n);
    800040b6:	fe440593          	addi	a1,s0,-28
    800040ba:	4509                	li	a0,2
    800040bc:	c3ffd0ef          	jal	80001cfa <argint>
  if(argfd(0, 0, &f) < 0)
    800040c0:	fe840613          	addi	a2,s0,-24
    800040c4:	4581                	li	a1,0
    800040c6:	4501                	li	a0,0
    800040c8:	dbfff0ef          	jal	80003e86 <argfd>
    800040cc:	87aa                	mv	a5,a0
    return -1;
    800040ce:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040d0:	0007ca63          	bltz	a5,800040e4 <sys_read+0x40>
  return fileread(f, p, n);
    800040d4:	fe442603          	lw	a2,-28(s0)
    800040d8:	fd843583          	ld	a1,-40(s0)
    800040dc:	fe843503          	ld	a0,-24(s0)
    800040e0:	d2cff0ef          	jal	8000360c <fileread>
}
    800040e4:	70a2                	ld	ra,40(sp)
    800040e6:	7402                	ld	s0,32(sp)
    800040e8:	6145                	addi	sp,sp,48
    800040ea:	8082                	ret

00000000800040ec <sys_write>:
{
    800040ec:	7179                	addi	sp,sp,-48
    800040ee:	f406                	sd	ra,40(sp)
    800040f0:	f022                	sd	s0,32(sp)
    800040f2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800040f4:	fd840593          	addi	a1,s0,-40
    800040f8:	4505                	li	a0,1
    800040fa:	c1dfd0ef          	jal	80001d16 <argaddr>
  argint(2, &n);
    800040fe:	fe440593          	addi	a1,s0,-28
    80004102:	4509                	li	a0,2
    80004104:	bf7fd0ef          	jal	80001cfa <argint>
  if(argfd(0, 0, &f) < 0)
    80004108:	fe840613          	addi	a2,s0,-24
    8000410c:	4581                	li	a1,0
    8000410e:	4501                	li	a0,0
    80004110:	d77ff0ef          	jal	80003e86 <argfd>
    80004114:	87aa                	mv	a5,a0
    return -1;
    80004116:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004118:	0007ca63          	bltz	a5,8000412c <sys_write+0x40>
  return filewrite(f, p, n);
    8000411c:	fe442603          	lw	a2,-28(s0)
    80004120:	fd843583          	ld	a1,-40(s0)
    80004124:	fe843503          	ld	a0,-24(s0)
    80004128:	da8ff0ef          	jal	800036d0 <filewrite>
}
    8000412c:	70a2                	ld	ra,40(sp)
    8000412e:	7402                	ld	s0,32(sp)
    80004130:	6145                	addi	sp,sp,48
    80004132:	8082                	ret

0000000080004134 <sys_close>:
{
    80004134:	1101                	addi	sp,sp,-32
    80004136:	ec06                	sd	ra,24(sp)
    80004138:	e822                	sd	s0,16(sp)
    8000413a:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000413c:	fe040613          	addi	a2,s0,-32
    80004140:	fec40593          	addi	a1,s0,-20
    80004144:	4501                	li	a0,0
    80004146:	d41ff0ef          	jal	80003e86 <argfd>
    return -1;
    8000414a:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000414c:	02054163          	bltz	a0,8000416e <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004150:	c93fc0ef          	jal	80000de2 <myproc>
    80004154:	fec42783          	lw	a5,-20(s0)
    80004158:	078e                	slli	a5,a5,0x3
    8000415a:	0d078793          	addi	a5,a5,208
    8000415e:	953e                	add	a0,a0,a5
    80004160:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004164:	fe043503          	ld	a0,-32(s0)
    80004168:	b80ff0ef          	jal	800034e8 <fileclose>
  return 0;
    8000416c:	4781                	li	a5,0
}
    8000416e:	853e                	mv	a0,a5
    80004170:	60e2                	ld	ra,24(sp)
    80004172:	6442                	ld	s0,16(sp)
    80004174:	6105                	addi	sp,sp,32
    80004176:	8082                	ret

0000000080004178 <sys_fstat>:
{
    80004178:	1101                	addi	sp,sp,-32
    8000417a:	ec06                	sd	ra,24(sp)
    8000417c:	e822                	sd	s0,16(sp)
    8000417e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004180:	fe040593          	addi	a1,s0,-32
    80004184:	4505                	li	a0,1
    80004186:	b91fd0ef          	jal	80001d16 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000418a:	fe840613          	addi	a2,s0,-24
    8000418e:	4581                	li	a1,0
    80004190:	4501                	li	a0,0
    80004192:	cf5ff0ef          	jal	80003e86 <argfd>
    80004196:	87aa                	mv	a5,a0
    return -1;
    80004198:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000419a:	0007c863          	bltz	a5,800041aa <sys_fstat+0x32>
  return filestat(f, st);
    8000419e:	fe043583          	ld	a1,-32(s0)
    800041a2:	fe843503          	ld	a0,-24(s0)
    800041a6:	c04ff0ef          	jal	800035aa <filestat>
}
    800041aa:	60e2                	ld	ra,24(sp)
    800041ac:	6442                	ld	s0,16(sp)
    800041ae:	6105                	addi	sp,sp,32
    800041b0:	8082                	ret

00000000800041b2 <sys_link>:
{
    800041b2:	7169                	addi	sp,sp,-304
    800041b4:	f606                	sd	ra,296(sp)
    800041b6:	f222                	sd	s0,288(sp)
    800041b8:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041ba:	08000613          	li	a2,128
    800041be:	ed040593          	addi	a1,s0,-304
    800041c2:	4501                	li	a0,0
    800041c4:	b6ffd0ef          	jal	80001d32 <argstr>
    return -1;
    800041c8:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041ca:	0c054e63          	bltz	a0,800042a6 <sys_link+0xf4>
    800041ce:	08000613          	li	a2,128
    800041d2:	f5040593          	addi	a1,s0,-176
    800041d6:	4505                	li	a0,1
    800041d8:	b5bfd0ef          	jal	80001d32 <argstr>
    return -1;
    800041dc:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800041de:	0c054463          	bltz	a0,800042a6 <sys_link+0xf4>
    800041e2:	ee26                	sd	s1,280(sp)
  begin_op();
    800041e4:	ee1fe0ef          	jal	800030c4 <begin_op>
  if((ip = namei(old)) == 0){
    800041e8:	ed040513          	addi	a0,s0,-304
    800041ec:	cfbfe0ef          	jal	80002ee6 <namei>
    800041f0:	84aa                	mv	s1,a0
    800041f2:	c53d                	beqz	a0,80004260 <sys_link+0xae>
  ilock(ip);
    800041f4:	cc4fe0ef          	jal	800026b8 <ilock>
  if(ip->type == T_DIR){
    800041f8:	04449703          	lh	a4,68(s1)
    800041fc:	4785                	li	a5,1
    800041fe:	06f70663          	beq	a4,a5,8000426a <sys_link+0xb8>
    80004202:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004204:	04a4d783          	lhu	a5,74(s1)
    80004208:	2785                	addiw	a5,a5,1
    8000420a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000420e:	8526                	mv	a0,s1
    80004210:	bf4fe0ef          	jal	80002604 <iupdate>
  iunlock(ip);
    80004214:	8526                	mv	a0,s1
    80004216:	d50fe0ef          	jal	80002766 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    8000421a:	fd040593          	addi	a1,s0,-48
    8000421e:	f5040513          	addi	a0,s0,-176
    80004222:	cdffe0ef          	jal	80002f00 <nameiparent>
    80004226:	892a                	mv	s2,a0
    80004228:	cd21                	beqz	a0,80004280 <sys_link+0xce>
  ilock(dp);
    8000422a:	c8efe0ef          	jal	800026b8 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000422e:	854a                	mv	a0,s2
    80004230:	00092703          	lw	a4,0(s2)
    80004234:	409c                	lw	a5,0(s1)
    80004236:	04f71263          	bne	a4,a5,8000427a <sys_link+0xc8>
    8000423a:	40d0                	lw	a2,4(s1)
    8000423c:	fd040593          	addi	a1,s0,-48
    80004240:	bfdfe0ef          	jal	80002e3c <dirlink>
    80004244:	02054b63          	bltz	a0,8000427a <sys_link+0xc8>
  iunlockput(dp);
    80004248:	854a                	mv	a0,s2
    8000424a:	e7afe0ef          	jal	800028c4 <iunlockput>
  iput(ip);
    8000424e:	8526                	mv	a0,s1
    80004250:	deafe0ef          	jal	8000283a <iput>
  end_op();
    80004254:	ee1fe0ef          	jal	80003134 <end_op>
  return 0;
    80004258:	4781                	li	a5,0
    8000425a:	64f2                	ld	s1,280(sp)
    8000425c:	6952                	ld	s2,272(sp)
    8000425e:	a0a1                	j	800042a6 <sys_link+0xf4>
    end_op();
    80004260:	ed5fe0ef          	jal	80003134 <end_op>
    return -1;
    80004264:	57fd                	li	a5,-1
    80004266:	64f2                	ld	s1,280(sp)
    80004268:	a83d                	j	800042a6 <sys_link+0xf4>
    iunlockput(ip);
    8000426a:	8526                	mv	a0,s1
    8000426c:	e58fe0ef          	jal	800028c4 <iunlockput>
    end_op();
    80004270:	ec5fe0ef          	jal	80003134 <end_op>
    return -1;
    80004274:	57fd                	li	a5,-1
    80004276:	64f2                	ld	s1,280(sp)
    80004278:	a03d                	j	800042a6 <sys_link+0xf4>
    iunlockput(dp);
    8000427a:	854a                	mv	a0,s2
    8000427c:	e48fe0ef          	jal	800028c4 <iunlockput>
  ilock(ip);
    80004280:	8526                	mv	a0,s1
    80004282:	c36fe0ef          	jal	800026b8 <ilock>
  ip->nlink--;
    80004286:	04a4d783          	lhu	a5,74(s1)
    8000428a:	37fd                	addiw	a5,a5,-1
    8000428c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004290:	8526                	mv	a0,s1
    80004292:	b72fe0ef          	jal	80002604 <iupdate>
  iunlockput(ip);
    80004296:	8526                	mv	a0,s1
    80004298:	e2cfe0ef          	jal	800028c4 <iunlockput>
  end_op();
    8000429c:	e99fe0ef          	jal	80003134 <end_op>
  return -1;
    800042a0:	57fd                	li	a5,-1
    800042a2:	64f2                	ld	s1,280(sp)
    800042a4:	6952                	ld	s2,272(sp)
}
    800042a6:	853e                	mv	a0,a5
    800042a8:	70b2                	ld	ra,296(sp)
    800042aa:	7412                	ld	s0,288(sp)
    800042ac:	6155                	addi	sp,sp,304
    800042ae:	8082                	ret

00000000800042b0 <sys_unlink>:
{
    800042b0:	7151                	addi	sp,sp,-240
    800042b2:	f586                	sd	ra,232(sp)
    800042b4:	f1a2                	sd	s0,224(sp)
    800042b6:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800042b8:	08000613          	li	a2,128
    800042bc:	f3040593          	addi	a1,s0,-208
    800042c0:	4501                	li	a0,0
    800042c2:	a71fd0ef          	jal	80001d32 <argstr>
    800042c6:	14054d63          	bltz	a0,80004420 <sys_unlink+0x170>
    800042ca:	eda6                	sd	s1,216(sp)
  begin_op();
    800042cc:	df9fe0ef          	jal	800030c4 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800042d0:	fb040593          	addi	a1,s0,-80
    800042d4:	f3040513          	addi	a0,s0,-208
    800042d8:	c29fe0ef          	jal	80002f00 <nameiparent>
    800042dc:	84aa                	mv	s1,a0
    800042de:	c955                	beqz	a0,80004392 <sys_unlink+0xe2>
  ilock(dp);
    800042e0:	bd8fe0ef          	jal	800026b8 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800042e4:	00004597          	auipc	a1,0x4
    800042e8:	29458593          	addi	a1,a1,660 # 80008578 <etext+0x578>
    800042ec:	fb040513          	addi	a0,s0,-80
    800042f0:	94dfe0ef          	jal	80002c3c <namecmp>
    800042f4:	10050b63          	beqz	a0,8000440a <sys_unlink+0x15a>
    800042f8:	00004597          	auipc	a1,0x4
    800042fc:	28858593          	addi	a1,a1,648 # 80008580 <etext+0x580>
    80004300:	fb040513          	addi	a0,s0,-80
    80004304:	939fe0ef          	jal	80002c3c <namecmp>
    80004308:	10050163          	beqz	a0,8000440a <sys_unlink+0x15a>
    8000430c:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000430e:	f2c40613          	addi	a2,s0,-212
    80004312:	fb040593          	addi	a1,s0,-80
    80004316:	8526                	mv	a0,s1
    80004318:	93bfe0ef          	jal	80002c52 <dirlookup>
    8000431c:	892a                	mv	s2,a0
    8000431e:	0e050563          	beqz	a0,80004408 <sys_unlink+0x158>
    80004322:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004324:	b94fe0ef          	jal	800026b8 <ilock>
  if(ip->nlink < 1)
    80004328:	04a91783          	lh	a5,74(s2)
    8000432c:	06f05863          	blez	a5,8000439c <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004330:	04491703          	lh	a4,68(s2)
    80004334:	4785                	li	a5,1
    80004336:	06f70963          	beq	a4,a5,800043a8 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    8000433a:	fc040993          	addi	s3,s0,-64
    8000433e:	4641                	li	a2,16
    80004340:	4581                	li	a1,0
    80004342:	854e                	mv	a0,s3
    80004344:	e1bfb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004348:	4741                	li	a4,16
    8000434a:	f2c42683          	lw	a3,-212(s0)
    8000434e:	864e                	mv	a2,s3
    80004350:	4581                	li	a1,0
    80004352:	8526                	mv	a0,s1
    80004354:	fe8fe0ef          	jal	80002b3c <writei>
    80004358:	47c1                	li	a5,16
    8000435a:	08f51863          	bne	a0,a5,800043ea <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    8000435e:	04491703          	lh	a4,68(s2)
    80004362:	4785                	li	a5,1
    80004364:	08f70963          	beq	a4,a5,800043f6 <sys_unlink+0x146>
  iunlockput(dp);
    80004368:	8526                	mv	a0,s1
    8000436a:	d5afe0ef          	jal	800028c4 <iunlockput>
  ip->nlink--;
    8000436e:	04a95783          	lhu	a5,74(s2)
    80004372:	37fd                	addiw	a5,a5,-1
    80004374:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004378:	854a                	mv	a0,s2
    8000437a:	a8afe0ef          	jal	80002604 <iupdate>
  iunlockput(ip);
    8000437e:	854a                	mv	a0,s2
    80004380:	d44fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    80004384:	db1fe0ef          	jal	80003134 <end_op>
  return 0;
    80004388:	4501                	li	a0,0
    8000438a:	64ee                	ld	s1,216(sp)
    8000438c:	694e                	ld	s2,208(sp)
    8000438e:	69ae                	ld	s3,200(sp)
    80004390:	a061                	j	80004418 <sys_unlink+0x168>
    end_op();
    80004392:	da3fe0ef          	jal	80003134 <end_op>
    return -1;
    80004396:	557d                	li	a0,-1
    80004398:	64ee                	ld	s1,216(sp)
    8000439a:	a8bd                	j	80004418 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000439c:	00004517          	auipc	a0,0x4
    800043a0:	1ec50513          	addi	a0,a0,492 # 80008588 <etext+0x588>
    800043a4:	12f010ef          	jal	80005cd2 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043a8:	04c92703          	lw	a4,76(s2)
    800043ac:	02000793          	li	a5,32
    800043b0:	f8e7f5e3          	bgeu	a5,a4,8000433a <sys_unlink+0x8a>
    800043b4:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043b6:	4741                	li	a4,16
    800043b8:	86ce                	mv	a3,s3
    800043ba:	f1840613          	addi	a2,s0,-232
    800043be:	4581                	li	a1,0
    800043c0:	854a                	mv	a0,s2
    800043c2:	e88fe0ef          	jal	80002a4a <readi>
    800043c6:	47c1                	li	a5,16
    800043c8:	00f51b63          	bne	a0,a5,800043de <sys_unlink+0x12e>
    if(de.inum != 0)
    800043cc:	f1845783          	lhu	a5,-232(s0)
    800043d0:	ebb1                	bnez	a5,80004424 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800043d2:	29c1                	addiw	s3,s3,16
    800043d4:	04c92783          	lw	a5,76(s2)
    800043d8:	fcf9efe3          	bltu	s3,a5,800043b6 <sys_unlink+0x106>
    800043dc:	bfb9                	j	8000433a <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800043de:	00004517          	auipc	a0,0x4
    800043e2:	1c250513          	addi	a0,a0,450 # 800085a0 <etext+0x5a0>
    800043e6:	0ed010ef          	jal	80005cd2 <panic>
    panic("unlink: writei");
    800043ea:	00004517          	auipc	a0,0x4
    800043ee:	1ce50513          	addi	a0,a0,462 # 800085b8 <etext+0x5b8>
    800043f2:	0e1010ef          	jal	80005cd2 <panic>
    dp->nlink--;
    800043f6:	04a4d783          	lhu	a5,74(s1)
    800043fa:	37fd                	addiw	a5,a5,-1
    800043fc:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004400:	8526                	mv	a0,s1
    80004402:	a02fe0ef          	jal	80002604 <iupdate>
    80004406:	b78d                	j	80004368 <sys_unlink+0xb8>
    80004408:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    8000440a:	8526                	mv	a0,s1
    8000440c:	cb8fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    80004410:	d25fe0ef          	jal	80003134 <end_op>
  return -1;
    80004414:	557d                	li	a0,-1
    80004416:	64ee                	ld	s1,216(sp)
}
    80004418:	70ae                	ld	ra,232(sp)
    8000441a:	740e                	ld	s0,224(sp)
    8000441c:	616d                	addi	sp,sp,240
    8000441e:	8082                	ret
    return -1;
    80004420:	557d                	li	a0,-1
    80004422:	bfdd                	j	80004418 <sys_unlink+0x168>
    iunlockput(ip);
    80004424:	854a                	mv	a0,s2
    80004426:	c9efe0ef          	jal	800028c4 <iunlockput>
    goto bad;
    8000442a:	694e                	ld	s2,208(sp)
    8000442c:	69ae                	ld	s3,200(sp)
    8000442e:	bff1                	j	8000440a <sys_unlink+0x15a>

0000000080004430 <sys_open>:

uint64
sys_open(void)
{
    80004430:	7131                	addi	sp,sp,-192
    80004432:	fd06                	sd	ra,184(sp)
    80004434:	f922                	sd	s0,176(sp)
    80004436:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004438:	f4c40593          	addi	a1,s0,-180
    8000443c:	4505                	li	a0,1
    8000443e:	8bdfd0ef          	jal	80001cfa <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004442:	08000613          	li	a2,128
    80004446:	f5040593          	addi	a1,s0,-176
    8000444a:	4501                	li	a0,0
    8000444c:	8e7fd0ef          	jal	80001d32 <argstr>
    80004450:	87aa                	mv	a5,a0
    return -1;
    80004452:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004454:	0a07c363          	bltz	a5,800044fa <sys_open+0xca>
    80004458:	f526                	sd	s1,168(sp)

  begin_op();
    8000445a:	c6bfe0ef          	jal	800030c4 <begin_op>

  if(omode & O_CREATE){
    8000445e:	f4c42783          	lw	a5,-180(s0)
    80004462:	2007f793          	andi	a5,a5,512
    80004466:	c3dd                	beqz	a5,8000450c <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004468:	4681                	li	a3,0
    8000446a:	4601                	li	a2,0
    8000446c:	4589                	li	a1,2
    8000446e:	f5040513          	addi	a0,s0,-176
    80004472:	aafff0ef          	jal	80003f20 <create>
    80004476:	84aa                	mv	s1,a0
    if(ip == 0){
    80004478:	c549                	beqz	a0,80004502 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000447a:	04449703          	lh	a4,68(s1)
    8000447e:	478d                	li	a5,3
    80004480:	00f71763          	bne	a4,a5,8000448e <sys_open+0x5e>
    80004484:	0464d703          	lhu	a4,70(s1)
    80004488:	47a5                	li	a5,9
    8000448a:	0ae7ee63          	bltu	a5,a4,80004546 <sys_open+0x116>
    8000448e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004490:	fb5fe0ef          	jal	80003444 <filealloc>
    80004494:	892a                	mv	s2,a0
    80004496:	c561                	beqz	a0,8000455e <sys_open+0x12e>
    80004498:	ed4e                	sd	s3,152(sp)
    8000449a:	a47ff0ef          	jal	80003ee0 <fdalloc>
    8000449e:	89aa                	mv	s3,a0
    800044a0:	0a054b63          	bltz	a0,80004556 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800044a4:	04449703          	lh	a4,68(s1)
    800044a8:	478d                	li	a5,3
    800044aa:	0cf70363          	beq	a4,a5,80004570 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800044ae:	4789                	li	a5,2
    800044b0:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    800044b4:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    800044b8:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    800044bc:	f4c42783          	lw	a5,-180(s0)
    800044c0:	0017f713          	andi	a4,a5,1
    800044c4:	00174713          	xori	a4,a4,1
    800044c8:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    800044cc:	0037f713          	andi	a4,a5,3
    800044d0:	00e03733          	snez	a4,a4
    800044d4:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800044d8:	4007f793          	andi	a5,a5,1024
    800044dc:	c791                	beqz	a5,800044e8 <sys_open+0xb8>
    800044de:	04449703          	lh	a4,68(s1)
    800044e2:	4789                	li	a5,2
    800044e4:	08f70d63          	beq	a4,a5,8000457e <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800044e8:	8526                	mv	a0,s1
    800044ea:	a7cfe0ef          	jal	80002766 <iunlock>
  end_op();
    800044ee:	c47fe0ef          	jal	80003134 <end_op>

  return fd;
    800044f2:	854e                	mv	a0,s3
    800044f4:	74aa                	ld	s1,168(sp)
    800044f6:	790a                	ld	s2,160(sp)
    800044f8:	69ea                	ld	s3,152(sp)
}
    800044fa:	70ea                	ld	ra,184(sp)
    800044fc:	744a                	ld	s0,176(sp)
    800044fe:	6129                	addi	sp,sp,192
    80004500:	8082                	ret
      end_op();
    80004502:	c33fe0ef          	jal	80003134 <end_op>
      return -1;
    80004506:	557d                	li	a0,-1
    80004508:	74aa                	ld	s1,168(sp)
    8000450a:	bfc5                	j	800044fa <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000450c:	f5040513          	addi	a0,s0,-176
    80004510:	9d7fe0ef          	jal	80002ee6 <namei>
    80004514:	84aa                	mv	s1,a0
    80004516:	c11d                	beqz	a0,8000453c <sys_open+0x10c>
    ilock(ip);
    80004518:	9a0fe0ef          	jal	800026b8 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000451c:	04449703          	lh	a4,68(s1)
    80004520:	4785                	li	a5,1
    80004522:	f4f71ce3          	bne	a4,a5,8000447a <sys_open+0x4a>
    80004526:	f4c42783          	lw	a5,-180(s0)
    8000452a:	d3b5                	beqz	a5,8000448e <sys_open+0x5e>
      iunlockput(ip);
    8000452c:	8526                	mv	a0,s1
    8000452e:	b96fe0ef          	jal	800028c4 <iunlockput>
      end_op();
    80004532:	c03fe0ef          	jal	80003134 <end_op>
      return -1;
    80004536:	557d                	li	a0,-1
    80004538:	74aa                	ld	s1,168(sp)
    8000453a:	b7c1                	j	800044fa <sys_open+0xca>
      end_op();
    8000453c:	bf9fe0ef          	jal	80003134 <end_op>
      return -1;
    80004540:	557d                	li	a0,-1
    80004542:	74aa                	ld	s1,168(sp)
    80004544:	bf5d                	j	800044fa <sys_open+0xca>
    iunlockput(ip);
    80004546:	8526                	mv	a0,s1
    80004548:	b7cfe0ef          	jal	800028c4 <iunlockput>
    end_op();
    8000454c:	be9fe0ef          	jal	80003134 <end_op>
    return -1;
    80004550:	557d                	li	a0,-1
    80004552:	74aa                	ld	s1,168(sp)
    80004554:	b75d                	j	800044fa <sys_open+0xca>
      fileclose(f);
    80004556:	854a                	mv	a0,s2
    80004558:	f91fe0ef          	jal	800034e8 <fileclose>
    8000455c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000455e:	8526                	mv	a0,s1
    80004560:	b64fe0ef          	jal	800028c4 <iunlockput>
    end_op();
    80004564:	bd1fe0ef          	jal	80003134 <end_op>
    return -1;
    80004568:	557d                	li	a0,-1
    8000456a:	74aa                	ld	s1,168(sp)
    8000456c:	790a                	ld	s2,160(sp)
    8000456e:	b771                	j	800044fa <sys_open+0xca>
    f->type = FD_DEVICE;
    80004570:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004574:	04649783          	lh	a5,70(s1)
    80004578:	02f91223          	sh	a5,36(s2)
    8000457c:	bf35                	j	800044b8 <sys_open+0x88>
    itrunc(ip);
    8000457e:	8526                	mv	a0,s1
    80004580:	a26fe0ef          	jal	800027a6 <itrunc>
    80004584:	b795                	j	800044e8 <sys_open+0xb8>

0000000080004586 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004586:	7175                	addi	sp,sp,-144
    80004588:	e506                	sd	ra,136(sp)
    8000458a:	e122                	sd	s0,128(sp)
    8000458c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000458e:	b37fe0ef          	jal	800030c4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004592:	08000613          	li	a2,128
    80004596:	f7040593          	addi	a1,s0,-144
    8000459a:	4501                	li	a0,0
    8000459c:	f96fd0ef          	jal	80001d32 <argstr>
    800045a0:	02054363          	bltz	a0,800045c6 <sys_mkdir+0x40>
    800045a4:	4681                	li	a3,0
    800045a6:	4601                	li	a2,0
    800045a8:	4585                	li	a1,1
    800045aa:	f7040513          	addi	a0,s0,-144
    800045ae:	973ff0ef          	jal	80003f20 <create>
    800045b2:	c911                	beqz	a0,800045c6 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045b4:	b10fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    800045b8:	b7dfe0ef          	jal	80003134 <end_op>
  return 0;
    800045bc:	4501                	li	a0,0
}
    800045be:	60aa                	ld	ra,136(sp)
    800045c0:	640a                	ld	s0,128(sp)
    800045c2:	6149                	addi	sp,sp,144
    800045c4:	8082                	ret
    end_op();
    800045c6:	b6ffe0ef          	jal	80003134 <end_op>
    return -1;
    800045ca:	557d                	li	a0,-1
    800045cc:	bfcd                	j	800045be <sys_mkdir+0x38>

00000000800045ce <sys_mknod>:

uint64
sys_mknod(void)
{
    800045ce:	7135                	addi	sp,sp,-160
    800045d0:	ed06                	sd	ra,152(sp)
    800045d2:	e922                	sd	s0,144(sp)
    800045d4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800045d6:	aeffe0ef          	jal	800030c4 <begin_op>
  argint(1, &major);
    800045da:	f6c40593          	addi	a1,s0,-148
    800045de:	4505                	li	a0,1
    800045e0:	f1afd0ef          	jal	80001cfa <argint>
  argint(2, &minor);
    800045e4:	f6840593          	addi	a1,s0,-152
    800045e8:	4509                	li	a0,2
    800045ea:	f10fd0ef          	jal	80001cfa <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045ee:	08000613          	li	a2,128
    800045f2:	f7040593          	addi	a1,s0,-144
    800045f6:	4501                	li	a0,0
    800045f8:	f3afd0ef          	jal	80001d32 <argstr>
    800045fc:	02054563          	bltz	a0,80004626 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004600:	f6841683          	lh	a3,-152(s0)
    80004604:	f6c41603          	lh	a2,-148(s0)
    80004608:	458d                	li	a1,3
    8000460a:	f7040513          	addi	a0,s0,-144
    8000460e:	913ff0ef          	jal	80003f20 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004612:	c911                	beqz	a0,80004626 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004614:	ab0fe0ef          	jal	800028c4 <iunlockput>
  end_op();
    80004618:	b1dfe0ef          	jal	80003134 <end_op>
  return 0;
    8000461c:	4501                	li	a0,0
}
    8000461e:	60ea                	ld	ra,152(sp)
    80004620:	644a                	ld	s0,144(sp)
    80004622:	610d                	addi	sp,sp,160
    80004624:	8082                	ret
    end_op();
    80004626:	b0ffe0ef          	jal	80003134 <end_op>
    return -1;
    8000462a:	557d                	li	a0,-1
    8000462c:	bfcd                	j	8000461e <sys_mknod+0x50>

000000008000462e <sys_chdir>:

uint64
sys_chdir(void)
{
    8000462e:	7135                	addi	sp,sp,-160
    80004630:	ed06                	sd	ra,152(sp)
    80004632:	e922                	sd	s0,144(sp)
    80004634:	e14a                	sd	s2,128(sp)
    80004636:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004638:	faafc0ef          	jal	80000de2 <myproc>
    8000463c:	892a                	mv	s2,a0
  
  begin_op();
    8000463e:	a87fe0ef          	jal	800030c4 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004642:	08000613          	li	a2,128
    80004646:	f6040593          	addi	a1,s0,-160
    8000464a:	4501                	li	a0,0
    8000464c:	ee6fd0ef          	jal	80001d32 <argstr>
    80004650:	04054363          	bltz	a0,80004696 <sys_chdir+0x68>
    80004654:	e526                	sd	s1,136(sp)
    80004656:	f6040513          	addi	a0,s0,-160
    8000465a:	88dfe0ef          	jal	80002ee6 <namei>
    8000465e:	84aa                	mv	s1,a0
    80004660:	c915                	beqz	a0,80004694 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004662:	856fe0ef          	jal	800026b8 <ilock>
  if(ip->type != T_DIR){
    80004666:	04449703          	lh	a4,68(s1)
    8000466a:	4785                	li	a5,1
    8000466c:	02f71963          	bne	a4,a5,8000469e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004670:	8526                	mv	a0,s1
    80004672:	8f4fe0ef          	jal	80002766 <iunlock>
  iput(p->cwd);
    80004676:	15093503          	ld	a0,336(s2)
    8000467a:	9c0fe0ef          	jal	8000283a <iput>
  end_op();
    8000467e:	ab7fe0ef          	jal	80003134 <end_op>
  p->cwd = ip;
    80004682:	14993823          	sd	s1,336(s2)
  return 0;
    80004686:	4501                	li	a0,0
    80004688:	64aa                	ld	s1,136(sp)
}
    8000468a:	60ea                	ld	ra,152(sp)
    8000468c:	644a                	ld	s0,144(sp)
    8000468e:	690a                	ld	s2,128(sp)
    80004690:	610d                	addi	sp,sp,160
    80004692:	8082                	ret
    80004694:	64aa                	ld	s1,136(sp)
    end_op();
    80004696:	a9ffe0ef          	jal	80003134 <end_op>
    return -1;
    8000469a:	557d                	li	a0,-1
    8000469c:	b7fd                	j	8000468a <sys_chdir+0x5c>
    iunlockput(ip);
    8000469e:	8526                	mv	a0,s1
    800046a0:	a24fe0ef          	jal	800028c4 <iunlockput>
    end_op();
    800046a4:	a91fe0ef          	jal	80003134 <end_op>
    return -1;
    800046a8:	557d                	li	a0,-1
    800046aa:	64aa                	ld	s1,136(sp)
    800046ac:	bff9                	j	8000468a <sys_chdir+0x5c>

00000000800046ae <sys_exec>:

uint64
sys_exec(void)
{
    800046ae:	7105                	addi	sp,sp,-480
    800046b0:	ef86                	sd	ra,472(sp)
    800046b2:	eba2                	sd	s0,464(sp)
    800046b4:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    800046b6:	e2840593          	addi	a1,s0,-472
    800046ba:	4505                	li	a0,1
    800046bc:	e5afd0ef          	jal	80001d16 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    800046c0:	08000613          	li	a2,128
    800046c4:	f3040593          	addi	a1,s0,-208
    800046c8:	4501                	li	a0,0
    800046ca:	e68fd0ef          	jal	80001d32 <argstr>
    800046ce:	87aa                	mv	a5,a0
    return -1;
    800046d0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800046d2:	0e07c063          	bltz	a5,800047b2 <sys_exec+0x104>
    800046d6:	e7a6                	sd	s1,456(sp)
    800046d8:	e3ca                	sd	s2,448(sp)
    800046da:	ff4e                	sd	s3,440(sp)
    800046dc:	fb52                	sd	s4,432(sp)
    800046de:	f756                	sd	s5,424(sp)
    800046e0:	f35a                	sd	s6,416(sp)
    800046e2:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800046e4:	e3040a13          	addi	s4,s0,-464
    800046e8:	10000613          	li	a2,256
    800046ec:	4581                	li	a1,0
    800046ee:	8552                	mv	a0,s4
    800046f0:	a6ffb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800046f4:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800046f6:	89d2                	mv	s3,s4
    800046f8:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800046fa:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046fe:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004700:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004704:	00391513          	slli	a0,s2,0x3
    80004708:	85d6                	mv	a1,s5
    8000470a:	e2843783          	ld	a5,-472(s0)
    8000470e:	953e                	add	a0,a0,a5
    80004710:	d60fd0ef          	jal	80001c70 <fetchaddr>
    80004714:	02054663          	bltz	a0,80004740 <sys_exec+0x92>
    if(uarg == 0){
    80004718:	e2043783          	ld	a5,-480(s0)
    8000471c:	c7a1                	beqz	a5,80004764 <sys_exec+0xb6>
    argv[i] = kalloc();
    8000471e:	9e7fb0ef          	jal	80000104 <kalloc>
    80004722:	85aa                	mv	a1,a0
    80004724:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004728:	cd01                	beqz	a0,80004740 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000472a:	865a                	mv	a2,s6
    8000472c:	e2043503          	ld	a0,-480(s0)
    80004730:	d8afd0ef          	jal	80001cba <fetchstr>
    80004734:	00054663          	bltz	a0,80004740 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004738:	0905                	addi	s2,s2,1
    8000473a:	09a1                	addi	s3,s3,8
    8000473c:	fd7914e3          	bne	s2,s7,80004704 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004740:	100a0a13          	addi	s4,s4,256
    80004744:	6088                	ld	a0,0(s1)
    80004746:	cd31                	beqz	a0,800047a2 <sys_exec+0xf4>
    kfree(argv[i]);
    80004748:	8d5fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000474c:	04a1                	addi	s1,s1,8
    8000474e:	ff449be3          	bne	s1,s4,80004744 <sys_exec+0x96>
  return -1;
    80004752:	557d                	li	a0,-1
    80004754:	64be                	ld	s1,456(sp)
    80004756:	691e                	ld	s2,448(sp)
    80004758:	79fa                	ld	s3,440(sp)
    8000475a:	7a5a                	ld	s4,432(sp)
    8000475c:	7aba                	ld	s5,424(sp)
    8000475e:	7b1a                	ld	s6,416(sp)
    80004760:	6bfa                	ld	s7,408(sp)
    80004762:	a881                	j	800047b2 <sys_exec+0x104>
      argv[i] = 0;
    80004764:	0009079b          	sext.w	a5,s2
    80004768:	e3040593          	addi	a1,s0,-464
    8000476c:	078e                	slli	a5,a5,0x3
    8000476e:	97ae                	add	a5,a5,a1
    80004770:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004774:	f3040513          	addi	a0,s0,-208
    80004778:	bb2ff0ef          	jal	80003b2a <kexec>
    8000477c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000477e:	100a0a13          	addi	s4,s4,256
    80004782:	6088                	ld	a0,0(s1)
    80004784:	c511                	beqz	a0,80004790 <sys_exec+0xe2>
    kfree(argv[i]);
    80004786:	897fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000478a:	04a1                	addi	s1,s1,8
    8000478c:	ff449be3          	bne	s1,s4,80004782 <sys_exec+0xd4>
  return ret;
    80004790:	854a                	mv	a0,s2
    80004792:	64be                	ld	s1,456(sp)
    80004794:	691e                	ld	s2,448(sp)
    80004796:	79fa                	ld	s3,440(sp)
    80004798:	7a5a                	ld	s4,432(sp)
    8000479a:	7aba                	ld	s5,424(sp)
    8000479c:	7b1a                	ld	s6,416(sp)
    8000479e:	6bfa                	ld	s7,408(sp)
    800047a0:	a809                	j	800047b2 <sys_exec+0x104>
  return -1;
    800047a2:	557d                	li	a0,-1
    800047a4:	64be                	ld	s1,456(sp)
    800047a6:	691e                	ld	s2,448(sp)
    800047a8:	79fa                	ld	s3,440(sp)
    800047aa:	7a5a                	ld	s4,432(sp)
    800047ac:	7aba                	ld	s5,424(sp)
    800047ae:	7b1a                	ld	s6,416(sp)
    800047b0:	6bfa                	ld	s7,408(sp)
}
    800047b2:	60fe                	ld	ra,472(sp)
    800047b4:	645e                	ld	s0,464(sp)
    800047b6:	613d                	addi	sp,sp,480
    800047b8:	8082                	ret

00000000800047ba <sys_pipe>:

uint64
sys_pipe(void)
{
    800047ba:	7139                	addi	sp,sp,-64
    800047bc:	fc06                	sd	ra,56(sp)
    800047be:	f822                	sd	s0,48(sp)
    800047c0:	f426                	sd	s1,40(sp)
    800047c2:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    800047c4:	e1efc0ef          	jal	80000de2 <myproc>
    800047c8:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    800047ca:	fd840593          	addi	a1,s0,-40
    800047ce:	4501                	li	a0,0
    800047d0:	d46fd0ef          	jal	80001d16 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800047d4:	fc840593          	addi	a1,s0,-56
    800047d8:	fd040513          	addi	a0,s0,-48
    800047dc:	828ff0ef          	jal	80003804 <pipealloc>
    return -1;
    800047e0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800047e2:	0a054763          	bltz	a0,80004890 <sys_pipe+0xd6>
  fd0 = -1;
    800047e6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800047ea:	fd043503          	ld	a0,-48(s0)
    800047ee:	ef2ff0ef          	jal	80003ee0 <fdalloc>
    800047f2:	fca42223          	sw	a0,-60(s0)
    800047f6:	08054463          	bltz	a0,8000487e <sys_pipe+0xc4>
    800047fa:	fc843503          	ld	a0,-56(s0)
    800047fe:	ee2ff0ef          	jal	80003ee0 <fdalloc>
    80004802:	fca42023          	sw	a0,-64(s0)
    80004806:	06054263          	bltz	a0,8000486a <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    8000480a:	4691                	li	a3,4
    8000480c:	fc440613          	addi	a2,s0,-60
    80004810:	fd843583          	ld	a1,-40(s0)
    80004814:	68a8                	ld	a0,80(s1)
    80004816:	af0fc0ef          	jal	80000b06 <copyout>
    8000481a:	00054e63          	bltz	a0,80004836 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    8000481e:	4691                	li	a3,4
    80004820:	fc040613          	addi	a2,s0,-64
    80004824:	fd843583          	ld	a1,-40(s0)
    80004828:	95b6                	add	a1,a1,a3
    8000482a:	68a8                	ld	a0,80(s1)
    8000482c:	adafc0ef          	jal	80000b06 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004830:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004832:	04055f63          	bgez	a0,80004890 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80004836:	fc442783          	lw	a5,-60(s0)
    8000483a:	078e                	slli	a5,a5,0x3
    8000483c:	0d078793          	addi	a5,a5,208
    80004840:	97a6                	add	a5,a5,s1
    80004842:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004846:	fc042783          	lw	a5,-64(s0)
    8000484a:	078e                	slli	a5,a5,0x3
    8000484c:	0d078793          	addi	a5,a5,208
    80004850:	97a6                	add	a5,a5,s1
    80004852:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004856:	fd043503          	ld	a0,-48(s0)
    8000485a:	c8ffe0ef          	jal	800034e8 <fileclose>
    fileclose(wf);
    8000485e:	fc843503          	ld	a0,-56(s0)
    80004862:	c87fe0ef          	jal	800034e8 <fileclose>
    return -1;
    80004866:	57fd                	li	a5,-1
    80004868:	a025                	j	80004890 <sys_pipe+0xd6>
    if(fd0 >= 0)
    8000486a:	fc442783          	lw	a5,-60(s0)
    8000486e:	0007c863          	bltz	a5,8000487e <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004872:	078e                	slli	a5,a5,0x3
    80004874:	0d078793          	addi	a5,a5,208
    80004878:	97a6                	add	a5,a5,s1
    8000487a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000487e:	fd043503          	ld	a0,-48(s0)
    80004882:	c67fe0ef          	jal	800034e8 <fileclose>
    fileclose(wf);
    80004886:	fc843503          	ld	a0,-56(s0)
    8000488a:	c5ffe0ef          	jal	800034e8 <fileclose>
    return -1;
    8000488e:	57fd                	li	a5,-1
}
    80004890:	853e                	mv	a0,a5
    80004892:	70e2                	ld	ra,56(sp)
    80004894:	7442                	ld	s0,48(sp)
    80004896:	74a2                	ld	s1,40(sp)
    80004898:	6121                	addi	sp,sp,64
    8000489a:	8082                	ret
    8000489c:	0000                	unimp
	...

00000000800048a0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    800048a0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    800048a2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    800048a4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    800048a6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    800048a8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    800048aa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    800048ac:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    800048ae:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    800048b0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    800048b2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    800048b4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    800048b6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    800048b8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    800048ba:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    800048bc:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    800048be:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    800048c0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    800048c2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    800048c4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    800048c6:	ab8fd0ef          	jal	80001b7e <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    800048ca:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    800048cc:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    800048ce:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800048d0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800048d2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800048d4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800048d6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800048d8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800048da:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800048dc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800048de:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800048e0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800048e2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800048e4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800048e6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800048e8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800048ea:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800048ec:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800048ee:	10200073          	sret
    800048f2:	00000013          	nop
    800048f6:	00000013          	nop
    800048fa:	00000013          	nop

00000000800048fe <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800048fe:	1141                	addi	sp,sp,-16
    80004900:	e406                	sd	ra,8(sp)
    80004902:	e022                	sd	s0,0(sp)
    80004904:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004906:	0c000737          	lui	a4,0xc000
    8000490a:	4785                	li	a5,1
    8000490c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    8000490e:	c35c                	sw	a5,4(a4)
    80004910:	00470793          	addi	a5,a4,4 # c000004 <_entry-0x73fffffc>
  
#ifdef LAB_NET
  // PCIE IRQs are 32 to 35
  for(int irq = 1; irq < 0x35; irq++){
    *(uint32*)(PLIC + irq*4) = 1;
    80004914:	4685                	li	a3,1
  for(int irq = 1; irq < 0x35; irq++){
    80004916:	0d470713          	addi	a4,a4,212
    *(uint32*)(PLIC + irq*4) = 1;
    8000491a:	c394                	sw	a3,0(a5)
  for(int irq = 1; irq < 0x35; irq++){
    8000491c:	0791                	addi	a5,a5,4
    8000491e:	fee79ee3          	bne	a5,a4,8000491a <plicinit+0x1c>
  }
#endif  
}
    80004922:	60a2                	ld	ra,8(sp)
    80004924:	6402                	ld	s0,0(sp)
    80004926:	0141                	addi	sp,sp,16
    80004928:	8082                	ret

000000008000492a <plicinithart>:

void
plicinithart(void)
{
    8000492a:	1141                	addi	sp,sp,-16
    8000492c:	e406                	sd	ra,8(sp)
    8000492e:	e022                	sd	s0,0(sp)
    80004930:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004932:	c7cfc0ef          	jal	80000dae <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004936:	0085179b          	slliw	a5,a0,0x8
    8000493a:	0c002737          	lui	a4,0xc002
    8000493e:	973e                	add	a4,a4,a5
    80004940:	40200693          	li	a3,1026
    80004944:	08d72023          	sw	a3,128(a4) # c002080 <_entry-0x73ffdf80>

#ifdef LAB_NET
  // hack to get at next 32 IRQs for e1000.
  // volatile prevents the compiler from merging this with
  // the assignment above to generate a single 64-bit store.
  *(volatile uint32*)(PLIC_SENABLE(hart)+4) = 0xffffffff;
    80004948:	0c002737          	lui	a4,0xc002
    8000494c:	08470713          	addi	a4,a4,132 # c002084 <_entry-0x73ffdf7c>
    80004950:	97ba                	add	a5,a5,a4
    80004952:	577d                	li	a4,-1
    80004954:	c398                	sw	a4,0(a5)
#endif
  
  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004956:	00d5151b          	slliw	a0,a0,0xd
    8000495a:	0c2017b7          	lui	a5,0xc201
    8000495e:	97aa                	add	a5,a5,a0
    80004960:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004964:	60a2                	ld	ra,8(sp)
    80004966:	6402                	ld	s0,0(sp)
    80004968:	0141                	addi	sp,sp,16
    8000496a:	8082                	ret

000000008000496c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    8000496c:	1141                	addi	sp,sp,-16
    8000496e:	e406                	sd	ra,8(sp)
    80004970:	e022                	sd	s0,0(sp)
    80004972:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004974:	c3afc0ef          	jal	80000dae <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004978:	00d5151b          	slliw	a0,a0,0xd
    8000497c:	0c2017b7          	lui	a5,0xc201
    80004980:	97aa                	add	a5,a5,a0
  return irq;
}
    80004982:	43c8                	lw	a0,4(a5)
    80004984:	60a2                	ld	ra,8(sp)
    80004986:	6402                	ld	s0,0(sp)
    80004988:	0141                	addi	sp,sp,16
    8000498a:	8082                	ret

000000008000498c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000498c:	1101                	addi	sp,sp,-32
    8000498e:	ec06                	sd	ra,24(sp)
    80004990:	e822                	sd	s0,16(sp)
    80004992:	e426                	sd	s1,8(sp)
    80004994:	1000                	addi	s0,sp,32
    80004996:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004998:	c16fc0ef          	jal	80000dae <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000499c:	00d5179b          	slliw	a5,a0,0xd
    800049a0:	0c201737          	lui	a4,0xc201
    800049a4:	97ba                	add	a5,a5,a4
    800049a6:	c3c4                	sw	s1,4(a5)
}
    800049a8:	60e2                	ld	ra,24(sp)
    800049aa:	6442                	ld	s0,16(sp)
    800049ac:	64a2                	ld	s1,8(sp)
    800049ae:	6105                	addi	sp,sp,32
    800049b0:	8082                	ret

00000000800049b2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800049b2:	1141                	addi	sp,sp,-16
    800049b4:	e406                	sd	ra,8(sp)
    800049b6:	e022                	sd	s0,0(sp)
    800049b8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800049ba:	479d                	li	a5,7
    800049bc:	04a7ca63          	blt	a5,a0,80004a10 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    800049c0:	00015797          	auipc	a5,0x15
    800049c4:	0c078793          	addi	a5,a5,192 # 80019a80 <disk>
    800049c8:	97aa                	add	a5,a5,a0
    800049ca:	0187c783          	lbu	a5,24(a5)
    800049ce:	e7b9                	bnez	a5,80004a1c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800049d0:	00451693          	slli	a3,a0,0x4
    800049d4:	00015797          	auipc	a5,0x15
    800049d8:	0ac78793          	addi	a5,a5,172 # 80019a80 <disk>
    800049dc:	6398                	ld	a4,0(a5)
    800049de:	9736                	add	a4,a4,a3
    800049e0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    800049e4:	6398                	ld	a4,0(a5)
    800049e6:	9736                	add	a4,a4,a3
    800049e8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800049ec:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800049f0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800049f4:	97aa                	add	a5,a5,a0
    800049f6:	4705                	li	a4,1
    800049f8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    800049fc:	00015517          	auipc	a0,0x15
    80004a00:	09c50513          	addi	a0,a0,156 # 80019a98 <disk+0x18>
    80004a04:	a29fc0ef          	jal	8000142c <wakeup>
}
    80004a08:	60a2                	ld	ra,8(sp)
    80004a0a:	6402                	ld	s0,0(sp)
    80004a0c:	0141                	addi	sp,sp,16
    80004a0e:	8082                	ret
    panic("free_desc 1");
    80004a10:	00004517          	auipc	a0,0x4
    80004a14:	bb850513          	addi	a0,a0,-1096 # 800085c8 <etext+0x5c8>
    80004a18:	2ba010ef          	jal	80005cd2 <panic>
    panic("free_desc 2");
    80004a1c:	00004517          	auipc	a0,0x4
    80004a20:	bbc50513          	addi	a0,a0,-1092 # 800085d8 <etext+0x5d8>
    80004a24:	2ae010ef          	jal	80005cd2 <panic>

0000000080004a28 <virtio_disk_init>:
{
    80004a28:	1101                	addi	sp,sp,-32
    80004a2a:	ec06                	sd	ra,24(sp)
    80004a2c:	e822                	sd	s0,16(sp)
    80004a2e:	e426                	sd	s1,8(sp)
    80004a30:	e04a                	sd	s2,0(sp)
    80004a32:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004a34:	00004597          	auipc	a1,0x4
    80004a38:	bb458593          	addi	a1,a1,-1100 # 800085e8 <etext+0x5e8>
    80004a3c:	00015517          	auipc	a0,0x15
    80004a40:	16c50513          	addi	a0,a0,364 # 80019ba8 <disk+0x128>
    80004a44:	4c6010ef          	jal	80005f0a <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a48:	100017b7          	lui	a5,0x10001
    80004a4c:	4398                	lw	a4,0(a5)
    80004a4e:	2701                	sext.w	a4,a4
    80004a50:	747277b7          	lui	a5,0x74727
    80004a54:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004a58:	14f71863          	bne	a4,a5,80004ba8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a5c:	100017b7          	lui	a5,0x10001
    80004a60:	43dc                	lw	a5,4(a5)
    80004a62:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004a64:	4709                	li	a4,2
    80004a66:	14e79163          	bne	a5,a4,80004ba8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a6a:	100017b7          	lui	a5,0x10001
    80004a6e:	479c                	lw	a5,8(a5)
    80004a70:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004a72:	12e79b63          	bne	a5,a4,80004ba8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004a76:	100017b7          	lui	a5,0x10001
    80004a7a:	47d8                	lw	a4,12(a5)
    80004a7c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004a7e:	554d47b7          	lui	a5,0x554d4
    80004a82:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a86:	12f71163          	bne	a4,a5,80004ba8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a8a:	100017b7          	lui	a5,0x10001
    80004a8e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a92:	4705                	li	a4,1
    80004a94:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a96:	470d                	li	a4,3
    80004a98:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a9a:	10001737          	lui	a4,0x10001
    80004a9e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004aa0:	c7ffe6b7          	lui	a3,0xc7ffe
    80004aa4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdc887>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004aa8:	8f75                	and	a4,a4,a3
    80004aaa:	100016b7          	lui	a3,0x10001
    80004aae:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ab0:	472d                	li	a4,11
    80004ab2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ab4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004ab8:	439c                	lw	a5,0(a5)
    80004aba:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004abe:	8ba1                	andi	a5,a5,8
    80004ac0:	0e078a63          	beqz	a5,80004bb4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004ac4:	100017b7          	lui	a5,0x10001
    80004ac8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004acc:	43fc                	lw	a5,68(a5)
    80004ace:	2781                	sext.w	a5,a5
    80004ad0:	0e079863          	bnez	a5,80004bc0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004ad4:	100017b7          	lui	a5,0x10001
    80004ad8:	5bdc                	lw	a5,52(a5)
    80004ada:	2781                	sext.w	a5,a5
  if(max == 0)
    80004adc:	0e078863          	beqz	a5,80004bcc <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004ae0:	471d                	li	a4,7
    80004ae2:	0ef77b63          	bgeu	a4,a5,80004bd8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004ae6:	e1efb0ef          	jal	80000104 <kalloc>
    80004aea:	00015497          	auipc	s1,0x15
    80004aee:	f9648493          	addi	s1,s1,-106 # 80019a80 <disk>
    80004af2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004af4:	e10fb0ef          	jal	80000104 <kalloc>
    80004af8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004afa:	e0afb0ef          	jal	80000104 <kalloc>
    80004afe:	87aa                	mv	a5,a0
    80004b00:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004b02:	6088                	ld	a0,0(s1)
    80004b04:	0e050063          	beqz	a0,80004be4 <virtio_disk_init+0x1bc>
    80004b08:	00015717          	auipc	a4,0x15
    80004b0c:	f8073703          	ld	a4,-128(a4) # 80019a88 <disk+0x8>
    80004b10:	cb71                	beqz	a4,80004be4 <virtio_disk_init+0x1bc>
    80004b12:	cbe9                	beqz	a5,80004be4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004b14:	6605                	lui	a2,0x1
    80004b16:	4581                	li	a1,0
    80004b18:	e46fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004b1c:	00015497          	auipc	s1,0x15
    80004b20:	f6448493          	addi	s1,s1,-156 # 80019a80 <disk>
    80004b24:	6605                	lui	a2,0x1
    80004b26:	4581                	li	a1,0
    80004b28:	6488                	ld	a0,8(s1)
    80004b2a:	e34fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    80004b2e:	6605                	lui	a2,0x1
    80004b30:	4581                	li	a1,0
    80004b32:	6888                	ld	a0,16(s1)
    80004b34:	e2afb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004b38:	100017b7          	lui	a5,0x10001
    80004b3c:	4721                	li	a4,8
    80004b3e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004b40:	4098                	lw	a4,0(s1)
    80004b42:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004b46:	40d8                	lw	a4,4(s1)
    80004b48:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004b4c:	649c                	ld	a5,8(s1)
    80004b4e:	0007869b          	sext.w	a3,a5
    80004b52:	10001737          	lui	a4,0x10001
    80004b56:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004b5a:	9781                	srai	a5,a5,0x20
    80004b5c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004b60:	689c                	ld	a5,16(s1)
    80004b62:	0007869b          	sext.w	a3,a5
    80004b66:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004b6a:	9781                	srai	a5,a5,0x20
    80004b6c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004b70:	4785                	li	a5,1
    80004b72:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004b74:	00f48c23          	sb	a5,24(s1)
    80004b78:	00f48ca3          	sb	a5,25(s1)
    80004b7c:	00f48d23          	sb	a5,26(s1)
    80004b80:	00f48da3          	sb	a5,27(s1)
    80004b84:	00f48e23          	sb	a5,28(s1)
    80004b88:	00f48ea3          	sb	a5,29(s1)
    80004b8c:	00f48f23          	sb	a5,30(s1)
    80004b90:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b94:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b98:	07272823          	sw	s2,112(a4)
}
    80004b9c:	60e2                	ld	ra,24(sp)
    80004b9e:	6442                	ld	s0,16(sp)
    80004ba0:	64a2                	ld	s1,8(sp)
    80004ba2:	6902                	ld	s2,0(sp)
    80004ba4:	6105                	addi	sp,sp,32
    80004ba6:	8082                	ret
    panic("could not find virtio disk");
    80004ba8:	00004517          	auipc	a0,0x4
    80004bac:	a5050513          	addi	a0,a0,-1456 # 800085f8 <etext+0x5f8>
    80004bb0:	122010ef          	jal	80005cd2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004bb4:	00004517          	auipc	a0,0x4
    80004bb8:	a6450513          	addi	a0,a0,-1436 # 80008618 <etext+0x618>
    80004bbc:	116010ef          	jal	80005cd2 <panic>
    panic("virtio disk should not be ready");
    80004bc0:	00004517          	auipc	a0,0x4
    80004bc4:	a7850513          	addi	a0,a0,-1416 # 80008638 <etext+0x638>
    80004bc8:	10a010ef          	jal	80005cd2 <panic>
    panic("virtio disk has no queue 0");
    80004bcc:	00004517          	auipc	a0,0x4
    80004bd0:	a8c50513          	addi	a0,a0,-1396 # 80008658 <etext+0x658>
    80004bd4:	0fe010ef          	jal	80005cd2 <panic>
    panic("virtio disk max queue too short");
    80004bd8:	00004517          	auipc	a0,0x4
    80004bdc:	aa050513          	addi	a0,a0,-1376 # 80008678 <etext+0x678>
    80004be0:	0f2010ef          	jal	80005cd2 <panic>
    panic("virtio disk kalloc");
    80004be4:	00004517          	auipc	a0,0x4
    80004be8:	ab450513          	addi	a0,a0,-1356 # 80008698 <etext+0x698>
    80004bec:	0e6010ef          	jal	80005cd2 <panic>

0000000080004bf0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004bf0:	711d                	addi	sp,sp,-96
    80004bf2:	ec86                	sd	ra,88(sp)
    80004bf4:	e8a2                	sd	s0,80(sp)
    80004bf6:	e4a6                	sd	s1,72(sp)
    80004bf8:	e0ca                	sd	s2,64(sp)
    80004bfa:	fc4e                	sd	s3,56(sp)
    80004bfc:	f852                	sd	s4,48(sp)
    80004bfe:	f456                	sd	s5,40(sp)
    80004c00:	f05a                	sd	s6,32(sp)
    80004c02:	ec5e                	sd	s7,24(sp)
    80004c04:	e862                	sd	s8,16(sp)
    80004c06:	1080                	addi	s0,sp,96
    80004c08:	89aa                	mv	s3,a0
    80004c0a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004c0c:	00c52b83          	lw	s7,12(a0)
    80004c10:	001b9b9b          	slliw	s7,s7,0x1
    80004c14:	1b82                	slli	s7,s7,0x20
    80004c16:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004c1a:	00015517          	auipc	a0,0x15
    80004c1e:	f8e50513          	addi	a0,a0,-114 # 80019ba8 <disk+0x128>
    80004c22:	372010ef          	jal	80005f94 <acquire>
  for(int i = 0; i < NUM; i++){
    80004c26:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004c28:	00015a97          	auipc	s5,0x15
    80004c2c:	e58a8a93          	addi	s5,s5,-424 # 80019a80 <disk>
  for(int i = 0; i < 3; i++){
    80004c30:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004c32:	5c7d                	li	s8,-1
    80004c34:	a095                	j	80004c98 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004c36:	00fa8733          	add	a4,s5,a5
    80004c3a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004c3e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004c40:	0207c563          	bltz	a5,80004c6a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004c44:	2905                	addiw	s2,s2,1
    80004c46:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004c48:	05490c63          	beq	s2,s4,80004ca0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004c4c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004c4e:	00015717          	auipc	a4,0x15
    80004c52:	e3270713          	addi	a4,a4,-462 # 80019a80 <disk>
    80004c56:	4781                	li	a5,0
    if(disk.free[i]){
    80004c58:	01874683          	lbu	a3,24(a4)
    80004c5c:	fee9                	bnez	a3,80004c36 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004c5e:	2785                	addiw	a5,a5,1
    80004c60:	0705                	addi	a4,a4,1
    80004c62:	fe979be3          	bne	a5,s1,80004c58 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004c66:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004c6a:	01205d63          	blez	s2,80004c84 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c6e:	fa042503          	lw	a0,-96(s0)
    80004c72:	d41ff0ef          	jal	800049b2 <free_desc>
      for(int j = 0; j < i; j++)
    80004c76:	4785                	li	a5,1
    80004c78:	0127d663          	bge	a5,s2,80004c84 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004c7c:	fa442503          	lw	a0,-92(s0)
    80004c80:	d33ff0ef          	jal	800049b2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c84:	00015597          	auipc	a1,0x15
    80004c88:	f2458593          	addi	a1,a1,-220 # 80019ba8 <disk+0x128>
    80004c8c:	00015517          	auipc	a0,0x15
    80004c90:	e0c50513          	addi	a0,a0,-500 # 80019a98 <disk+0x18>
    80004c94:	f4cfc0ef          	jal	800013e0 <sleep>
  for(int i = 0; i < 3; i++){
    80004c98:	fa040613          	addi	a2,s0,-96
    80004c9c:	4901                	li	s2,0
    80004c9e:	b77d                	j	80004c4c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ca0:	fa042503          	lw	a0,-96(s0)
    80004ca4:	00451693          	slli	a3,a0,0x4

  if(write)
    80004ca8:	00015797          	auipc	a5,0x15
    80004cac:	dd878793          	addi	a5,a5,-552 # 80019a80 <disk>
    80004cb0:	00451713          	slli	a4,a0,0x4
    80004cb4:	0a070713          	addi	a4,a4,160
    80004cb8:	973e                	add	a4,a4,a5
    80004cba:	01603633          	snez	a2,s6
    80004cbe:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004cc0:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004cc4:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004cc8:	6398                	ld	a4,0(a5)
    80004cca:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ccc:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004cd0:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004cd2:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004cd4:	6390                	ld	a2,0(a5)
    80004cd6:	00d60833          	add	a6,a2,a3
    80004cda:	4741                	li	a4,16
    80004cdc:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004ce0:	4585                	li	a1,1
    80004ce2:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004ce6:	fa442703          	lw	a4,-92(s0)
    80004cea:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004cee:	0712                	slli	a4,a4,0x4
    80004cf0:	963a                	add	a2,a2,a4
    80004cf2:	05898813          	addi	a6,s3,88
    80004cf6:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004cfa:	0007b883          	ld	a7,0(a5)
    80004cfe:	9746                	add	a4,a4,a7
    80004d00:	40000613          	li	a2,1024
    80004d04:	c710                	sw	a2,8(a4)
  if(write)
    80004d06:	001b3613          	seqz	a2,s6
    80004d0a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004d0e:	8e4d                	or	a2,a2,a1
    80004d10:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004d14:	fa842603          	lw	a2,-88(s0)
    80004d18:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004d1c:	00451813          	slli	a6,a0,0x4
    80004d20:	02080813          	addi	a6,a6,32
    80004d24:	983e                	add	a6,a6,a5
    80004d26:	577d                	li	a4,-1
    80004d28:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004d2c:	0612                	slli	a2,a2,0x4
    80004d2e:	98b2                	add	a7,a7,a2
    80004d30:	03068713          	addi	a4,a3,48
    80004d34:	973e                	add	a4,a4,a5
    80004d36:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004d3a:	6398                	ld	a4,0(a5)
    80004d3c:	9732                	add	a4,a4,a2
    80004d3e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004d40:	4689                	li	a3,2
    80004d42:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004d46:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004d4a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004d4e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004d52:	6794                	ld	a3,8(a5)
    80004d54:	0026d703          	lhu	a4,2(a3)
    80004d58:	8b1d                	andi	a4,a4,7
    80004d5a:	0706                	slli	a4,a4,0x1
    80004d5c:	96ba                	add	a3,a3,a4
    80004d5e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004d62:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004d66:	6798                	ld	a4,8(a5)
    80004d68:	00275783          	lhu	a5,2(a4)
    80004d6c:	2785                	addiw	a5,a5,1
    80004d6e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004d72:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004d76:	100017b7          	lui	a5,0x10001
    80004d7a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004d7e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004d82:	00015917          	auipc	s2,0x15
    80004d86:	e2690913          	addi	s2,s2,-474 # 80019ba8 <disk+0x128>
  while(b->disk == 1) {
    80004d8a:	84ae                	mv	s1,a1
    80004d8c:	00b79a63          	bne	a5,a1,80004da0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d90:	85ca                	mv	a1,s2
    80004d92:	854e                	mv	a0,s3
    80004d94:	e4cfc0ef          	jal	800013e0 <sleep>
  while(b->disk == 1) {
    80004d98:	0049a783          	lw	a5,4(s3)
    80004d9c:	fe978ae3          	beq	a5,s1,80004d90 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004da0:	fa042903          	lw	s2,-96(s0)
    80004da4:	00491713          	slli	a4,s2,0x4
    80004da8:	02070713          	addi	a4,a4,32
    80004dac:	00015797          	auipc	a5,0x15
    80004db0:	cd478793          	addi	a5,a5,-812 # 80019a80 <disk>
    80004db4:	97ba                	add	a5,a5,a4
    80004db6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004dba:	00015997          	auipc	s3,0x15
    80004dbe:	cc698993          	addi	s3,s3,-826 # 80019a80 <disk>
    80004dc2:	00491713          	slli	a4,s2,0x4
    80004dc6:	0009b783          	ld	a5,0(s3)
    80004dca:	97ba                	add	a5,a5,a4
    80004dcc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004dd0:	854a                	mv	a0,s2
    80004dd2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004dd6:	bddff0ef          	jal	800049b2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004dda:	8885                	andi	s1,s1,1
    80004ddc:	f0fd                	bnez	s1,80004dc2 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004dde:	00015517          	auipc	a0,0x15
    80004de2:	dca50513          	addi	a0,a0,-566 # 80019ba8 <disk+0x128>
    80004de6:	242010ef          	jal	80006028 <release>
}
    80004dea:	60e6                	ld	ra,88(sp)
    80004dec:	6446                	ld	s0,80(sp)
    80004dee:	64a6                	ld	s1,72(sp)
    80004df0:	6906                	ld	s2,64(sp)
    80004df2:	79e2                	ld	s3,56(sp)
    80004df4:	7a42                	ld	s4,48(sp)
    80004df6:	7aa2                	ld	s5,40(sp)
    80004df8:	7b02                	ld	s6,32(sp)
    80004dfa:	6be2                	ld	s7,24(sp)
    80004dfc:	6c42                	ld	s8,16(sp)
    80004dfe:	6125                	addi	sp,sp,96
    80004e00:	8082                	ret

0000000080004e02 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004e02:	1101                	addi	sp,sp,-32
    80004e04:	ec06                	sd	ra,24(sp)
    80004e06:	e822                	sd	s0,16(sp)
    80004e08:	e426                	sd	s1,8(sp)
    80004e0a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004e0c:	00015497          	auipc	s1,0x15
    80004e10:	c7448493          	addi	s1,s1,-908 # 80019a80 <disk>
    80004e14:	00015517          	auipc	a0,0x15
    80004e18:	d9450513          	addi	a0,a0,-620 # 80019ba8 <disk+0x128>
    80004e1c:	178010ef          	jal	80005f94 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004e20:	100017b7          	lui	a5,0x10001
    80004e24:	53bc                	lw	a5,96(a5)
    80004e26:	8b8d                	andi	a5,a5,3
    80004e28:	10001737          	lui	a4,0x10001
    80004e2c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004e2e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004e32:	689c                	ld	a5,16(s1)
    80004e34:	0204d703          	lhu	a4,32(s1)
    80004e38:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004e3c:	04f70863          	beq	a4,a5,80004e8c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004e40:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004e44:	6898                	ld	a4,16(s1)
    80004e46:	0204d783          	lhu	a5,32(s1)
    80004e4a:	8b9d                	andi	a5,a5,7
    80004e4c:	078e                	slli	a5,a5,0x3
    80004e4e:	97ba                	add	a5,a5,a4
    80004e50:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004e52:	00479713          	slli	a4,a5,0x4
    80004e56:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004e5a:	9726                	add	a4,a4,s1
    80004e5c:	01074703          	lbu	a4,16(a4)
    80004e60:	e329                	bnez	a4,80004ea2 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004e62:	0792                	slli	a5,a5,0x4
    80004e64:	02078793          	addi	a5,a5,32
    80004e68:	97a6                	add	a5,a5,s1
    80004e6a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004e6c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004e70:	dbcfc0ef          	jal	8000142c <wakeup>

    disk.used_idx += 1;
    80004e74:	0204d783          	lhu	a5,32(s1)
    80004e78:	2785                	addiw	a5,a5,1
    80004e7a:	17c2                	slli	a5,a5,0x30
    80004e7c:	93c1                	srli	a5,a5,0x30
    80004e7e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e82:	6898                	ld	a4,16(s1)
    80004e84:	00275703          	lhu	a4,2(a4)
    80004e88:	faf71ce3          	bne	a4,a5,80004e40 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e8c:	00015517          	auipc	a0,0x15
    80004e90:	d1c50513          	addi	a0,a0,-740 # 80019ba8 <disk+0x128>
    80004e94:	194010ef          	jal	80006028 <release>
}
    80004e98:	60e2                	ld	ra,24(sp)
    80004e9a:	6442                	ld	s0,16(sp)
    80004e9c:	64a2                	ld	s1,8(sp)
    80004e9e:	6105                	addi	sp,sp,32
    80004ea0:	8082                	ret
      panic("virtio_disk_intr status");
    80004ea2:	00004517          	auipc	a0,0x4
    80004ea6:	80e50513          	addi	a0,a0,-2034 # 800086b0 <etext+0x6b0>
    80004eaa:	629000ef          	jal	80005cd2 <panic>

0000000080004eae <e1000_init>:
// e1000's registers are mapped.
// this code loosely follows the initialization directions
// in Chapter 14 of Intel's Software Developer's Manual.
void
e1000_init(uint32 *xregs)
{
    80004eae:	1101                	addi	sp,sp,-32
    80004eb0:	ec06                	sd	ra,24(sp)
    80004eb2:	e822                	sd	s0,16(sp)
    80004eb4:	e426                	sd	s1,8(sp)
    80004eb6:	e04a                	sd	s2,0(sp)
    80004eb8:	1000                	addi	s0,sp,32
    80004eba:	84aa                	mv	s1,a0
  int i;

  initlock(&e1000_lock, "e1000");
    80004ebc:	00004597          	auipc	a1,0x4
    80004ec0:	80c58593          	addi	a1,a1,-2036 # 800086c8 <etext+0x6c8>
    80004ec4:	00015517          	auipc	a0,0x15
    80004ec8:	cfc50513          	addi	a0,a0,-772 # 80019bc0 <e1000_lock>
    80004ecc:	03e010ef          	jal	80005f0a <initlock>

  regs = xregs;
    80004ed0:	00004797          	auipc	a5,0x4
    80004ed4:	aa97b023          	sd	s1,-1376(a5) # 80008970 <regs>

  // Reset the device
  regs[E1000_IMS] = 0; // disable interrupts
    80004ed8:	0c04a823          	sw	zero,208(s1)
  regs[E1000_CTL] |= E1000_CTL_RST;
    80004edc:	409c                	lw	a5,0(s1)
    80004ede:	04000737          	lui	a4,0x4000
    80004ee2:	8fd9                	or	a5,a5,a4
    80004ee4:	c09c                	sw	a5,0(s1)
  regs[E1000_IMS] = 0; // redisable interrupts
    80004ee6:	0c04a823          	sw	zero,208(s1)
  __sync_synchronize();
    80004eea:	0330000f          	fence	rw,rw

  // [E1000 14.5] Transmit initialization
  memset(tx_ring, 0, sizeof(tx_ring));
    80004eee:	10000613          	li	a2,256
    80004ef2:	4581                	li	a1,0
    80004ef4:	00015517          	auipc	a0,0x15
    80004ef8:	cec50513          	addi	a0,a0,-788 # 80019be0 <tx_ring>
    80004efc:	a62fb0ef          	jal	8000015e <memset>
  for (i = 0; i < TX_RING_SIZE; i++) {
    80004f00:	00015797          	auipc	a5,0x15
    80004f04:	ce078793          	addi	a5,a5,-800 # 80019be0 <tx_ring>
    80004f08:	00015697          	auipc	a3,0x15
    80004f0c:	dd868693          	addi	a3,a3,-552 # 80019ce0 <rx_ring>
    tx_ring[i].status = E1000_TXD_STAT_DD;
    80004f10:	4705                	li	a4,1
    80004f12:	00e78623          	sb	a4,12(a5)
    tx_ring[i].addr = 0;
    80004f16:	0007b023          	sd	zero,0(a5)
  for (i = 0; i < TX_RING_SIZE; i++) {
    80004f1a:	07c1                	addi	a5,a5,16
    80004f1c:	fed79be3          	bne	a5,a3,80004f12 <e1000_init+0x64>
  }
  regs[E1000_TDBAL] = (uint64) tx_ring;
    80004f20:	00015717          	auipc	a4,0x15
    80004f24:	cc070713          	addi	a4,a4,-832 # 80019be0 <tx_ring>
    80004f28:	00004797          	auipc	a5,0x4
    80004f2c:	a487b783          	ld	a5,-1464(a5) # 80008970 <regs>
    80004f30:	6691                	lui	a3,0x4
    80004f32:	97b6                	add	a5,a5,a3
    80004f34:	80e7a023          	sw	a4,-2048(a5)
  if(sizeof(tx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_TDLEN] = sizeof(tx_ring);
    80004f38:	10000713          	li	a4,256
    80004f3c:	80e7a423          	sw	a4,-2040(a5)
  regs[E1000_TDH] = regs[E1000_TDT] = 0;
    80004f40:	8007ac23          	sw	zero,-2024(a5)
    80004f44:	8007a823          	sw	zero,-2032(a5)
  
  // [E1000 14.4] Receive initialization
  memset(rx_ring, 0, sizeof(rx_ring));
    80004f48:	863a                	mv	a2,a4
    80004f4a:	4581                	li	a1,0
    80004f4c:	00015517          	auipc	a0,0x15
    80004f50:	d9450513          	addi	a0,a0,-620 # 80019ce0 <rx_ring>
    80004f54:	a0afb0ef          	jal	8000015e <memset>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80004f58:	00015497          	auipc	s1,0x15
    80004f5c:	d8848493          	addi	s1,s1,-632 # 80019ce0 <rx_ring>
    80004f60:	00015917          	auipc	s2,0x15
    80004f64:	e8090913          	addi	s2,s2,-384 # 80019de0 <netlock>
    rx_ring[i].addr = (uint64) kalloc();
    80004f68:	99cfb0ef          	jal	80000104 <kalloc>
    80004f6c:	e088                	sd	a0,0(s1)
    if (!rx_ring[i].addr)
    80004f6e:	c545                	beqz	a0,80005016 <e1000_init+0x168>
  for (i = 0; i < RX_RING_SIZE; i++) {
    80004f70:	04c1                	addi	s1,s1,16
    80004f72:	ff249be3          	bne	s1,s2,80004f68 <e1000_init+0xba>
      panic("e1000");
  }
  regs[E1000_RDBAL] = (uint64) rx_ring;
    80004f76:	00004697          	auipc	a3,0x4
    80004f7a:	9fa6b683          	ld	a3,-1542(a3) # 80008970 <regs>
    80004f7e:	00015717          	auipc	a4,0x15
    80004f82:	d6270713          	addi	a4,a4,-670 # 80019ce0 <rx_ring>
    80004f86:	678d                	lui	a5,0x3
    80004f88:	97b6                	add	a5,a5,a3
    80004f8a:	80e7a023          	sw	a4,-2048(a5) # 2800 <_entry-0x7fffd800>
  if(sizeof(rx_ring) % 128 != 0)
    panic("e1000");
  regs[E1000_RDH] = 0;
    80004f8e:	8007a823          	sw	zero,-2032(a5)
  regs[E1000_RDT] = RX_RING_SIZE - 1;
    80004f92:	473d                	li	a4,15
    80004f94:	80e7ac23          	sw	a4,-2024(a5)
  regs[E1000_RDLEN] = sizeof(rx_ring);
    80004f98:	10000713          	li	a4,256
    80004f9c:	80e7a423          	sw	a4,-2040(a5)

  // filter by qemu's MAC address, 52:54:00:12:34:56
  regs[E1000_RA] = 0x12005452;
    80004fa0:	6795                	lui	a5,0x5
    80004fa2:	97b6                	add	a5,a5,a3
    80004fa4:	12005737          	lui	a4,0x12005
    80004fa8:	45270713          	addi	a4,a4,1106 # 12005452 <_entry-0x6dffabae>
    80004fac:	40e7a023          	sw	a4,1024(a5) # 5400 <_entry-0x7fffac00>
  regs[E1000_RA+1] = 0x5634 | (1<<31);
    80004fb0:	80005737          	lui	a4,0x80005
    80004fb4:	63470713          	addi	a4,a4,1588 # ffffffff80005634 <end+0xfffffffefffe375c>
    80004fb8:	40e7a223          	sw	a4,1028(a5)
  // multicast table
  for (int i = 0; i < 4096/32; i++)
    80004fbc:	6795                	lui	a5,0x5
    80004fbe:	20078793          	addi	a5,a5,512 # 5200 <_entry-0x7fffae00>
    80004fc2:	97b6                	add	a5,a5,a3
    80004fc4:	6715                	lui	a4,0x5
    80004fc6:	40070713          	addi	a4,a4,1024 # 5400 <_entry-0x7fffac00>
    80004fca:	9736                	add	a4,a4,a3
    regs[E1000_MTA + i] = 0;
    80004fcc:	0007a023          	sw	zero,0(a5)
  for (int i = 0; i < 4096/32; i++)
    80004fd0:	0791                	addi	a5,a5,4
    80004fd2:	fee79de3          	bne	a5,a4,80004fcc <e1000_init+0x11e>

  // transmitter control bits.
  regs[E1000_TCTL] = E1000_TCTL_EN |  // enable
    80004fd6:	000407b7          	lui	a5,0x40
    80004fda:	10a78793          	addi	a5,a5,266 # 4010a <_entry-0x7ffbfef6>
    80004fde:	40f6a023          	sw	a5,1024(a3)
    E1000_TCTL_PSP |                  // pad short packets
    (0x10 << E1000_TCTL_CT_SHIFT) |   // collision stuff
    (0x40 << E1000_TCTL_COLD_SHIFT);
  regs[E1000_TIPG] = 10 | (8<<10) | (6<<20); // inter-pkt gap
    80004fe2:	006027b7          	lui	a5,0x602
    80004fe6:	07a9                	addi	a5,a5,10 # 60200a <_entry-0x7f9fdff6>
    80004fe8:	40f6a823          	sw	a5,1040(a3)

  // receiver control bits.
  regs[E1000_RCTL] = E1000_RCTL_EN | // enable receiver
    80004fec:	040087b7          	lui	a5,0x4008
    80004ff0:	0789                	addi	a5,a5,2 # 4008002 <_entry-0x7bff7ffe>
    80004ff2:	10f6a023          	sw	a5,256(a3)
    E1000_RCTL_BAM |                 // enable broadcast
    E1000_RCTL_SZ_2048 |             // 2048-byte rx buffers
    E1000_RCTL_SECRC;                // strip CRC
  
  // ask e1000 for receive interrupts.
  regs[E1000_RDTR] = 0; // interrupt after every received packet (no timer)
    80004ff6:	678d                	lui	a5,0x3
    80004ff8:	97b6                	add	a5,a5,a3
    80004ffa:	8207a023          	sw	zero,-2016(a5) # 2820 <_entry-0x7fffd7e0>
  regs[E1000_RADV] = 0; // interrupt after every packet (no timer)
    80004ffe:	8207a623          	sw	zero,-2004(a5)
  regs[E1000_IMS] = (1 << 7); // RXDW -- Receiver Descriptor Write Back
    80005002:	08000793          	li	a5,128
    80005006:	0cf6a823          	sw	a5,208(a3)
}
    8000500a:	60e2                	ld	ra,24(sp)
    8000500c:	6442                	ld	s0,16(sp)
    8000500e:	64a2                	ld	s1,8(sp)
    80005010:	6902                	ld	s2,0(sp)
    80005012:	6105                	addi	sp,sp,32
    80005014:	8082                	ret
      panic("e1000");
    80005016:	00003517          	auipc	a0,0x3
    8000501a:	6b250513          	addi	a0,a0,1714 # 800086c8 <etext+0x6c8>
    8000501e:	4b5000ef          	jal	80005cd2 <panic>

0000000080005022 <e1000_transmit>:

int
e1000_transmit(char *buf, int len)
{
    80005022:	1141                	addi	sp,sp,-16
    80005024:	e406                	sd	ra,8(sp)
    80005026:	e022                	sd	s0,0(sp)
    80005028:	0800                	addi	s0,sp,16
  // so that the caller knows to free buf.
  //

  
  return 0;
}
    8000502a:	4501                	li	a0,0
    8000502c:	60a2                	ld	ra,8(sp)
    8000502e:	6402                	ld	s0,0(sp)
    80005030:	0141                	addi	sp,sp,16
    80005032:	8082                	ret

0000000080005034 <e1000_intr>:

}

void
e1000_intr(void)
{
    80005034:	1141                	addi	sp,sp,-16
    80005036:	e406                	sd	ra,8(sp)
    80005038:	e022                	sd	s0,0(sp)
    8000503a:	0800                	addi	s0,sp,16
  // tell the e1000 we've seen this interrupt;
  // without this the e1000 won't raise any
  // further interrupts.
  regs[E1000_ICR] = 0xffffffff;
    8000503c:	00004797          	auipc	a5,0x4
    80005040:	9347b783          	ld	a5,-1740(a5) # 80008970 <regs>
    80005044:	577d                	li	a4,-1
    80005046:	0ce7a023          	sw	a4,192(a5)

  e1000_recv();
}
    8000504a:	60a2                	ld	ra,8(sp)
    8000504c:	6402                	ld	s0,0(sp)
    8000504e:	0141                	addi	sp,sp,16
    80005050:	8082                	ret

0000000080005052 <netinit>:

static struct spinlock netlock;

void
netinit(void)
{
    80005052:	1141                	addi	sp,sp,-16
    80005054:	e406                	sd	ra,8(sp)
    80005056:	e022                	sd	s0,0(sp)
    80005058:	0800                	addi	s0,sp,16
  initlock(&netlock, "netlock");
    8000505a:	00003597          	auipc	a1,0x3
    8000505e:	67658593          	addi	a1,a1,1654 # 800086d0 <etext+0x6d0>
    80005062:	00015517          	auipc	a0,0x15
    80005066:	d7e50513          	addi	a0,a0,-642 # 80019de0 <netlock>
    8000506a:	6a1000ef          	jal	80005f0a <initlock>
}
    8000506e:	60a2                	ld	ra,8(sp)
    80005070:	6402                	ld	s0,0(sp)
    80005072:	0141                	addi	sp,sp,16
    80005074:	8082                	ret

0000000080005076 <sys_bind>:
// prepare to receive UDP packets address to the port,
// i.e. allocate any queues &c needed.
//
uint64
sys_bind(void)
{
    80005076:	1141                	addi	sp,sp,-16
    80005078:	e406                	sd	ra,8(sp)
    8000507a:	e022                	sd	s0,0(sp)
    8000507c:	0800                	addi	s0,sp,16
  //
  // Your code here.
  //

  return -1;
}
    8000507e:	557d                	li	a0,-1
    80005080:	60a2                	ld	ra,8(sp)
    80005082:	6402                	ld	s0,0(sp)
    80005084:	0141                	addi	sp,sp,16
    80005086:	8082                	ret

0000000080005088 <sys_unbind>:
// release any resources previously created by bind(port);
// from now on UDP packets addressed to port should be dropped.
//
uint64
sys_unbind(void)
{
    80005088:	1141                	addi	sp,sp,-16
    8000508a:	e406                	sd	ra,8(sp)
    8000508c:	e022                	sd	s0,0(sp)
    8000508e:	0800                	addi	s0,sp,16
  //
  // Optional: Your code here.
  //

  return 0;
}
    80005090:	4501                	li	a0,0
    80005092:	60a2                	ld	ra,8(sp)
    80005094:	6402                	ld	s0,0(sp)
    80005096:	0141                	addi	sp,sp,16
    80005098:	8082                	ret

000000008000509a <sys_recv>:
// dport, *src, and *sport are host byte order.
// bind(dport) must previously have been called.
//
uint64
sys_recv(void)
{
    8000509a:	1141                	addi	sp,sp,-16
    8000509c:	e406                	sd	ra,8(sp)
    8000509e:	e022                	sd	s0,0(sp)
    800050a0:	0800                	addi	s0,sp,16
  //
  // Your code here.
  //
  return -1;
}
    800050a2:	557d                	li	a0,-1
    800050a4:	60a2                	ld	ra,8(sp)
    800050a6:	6402                	ld	s0,0(sp)
    800050a8:	0141                	addi	sp,sp,16
    800050aa:	8082                	ret

00000000800050ac <sys_send>:
//
// send(int sport, int dst, int dport, char *buf, int len)
//
uint64
sys_send(void)
{
    800050ac:	715d                	addi	sp,sp,-80
    800050ae:	e486                	sd	ra,72(sp)
    800050b0:	e0a2                	sd	s0,64(sp)
    800050b2:	f84a                	sd	s2,48(sp)
    800050b4:	f44e                	sd	s3,40(sp)
    800050b6:	0880                	addi	s0,sp,80
  struct proc *p = myproc();
    800050b8:	d2bfb0ef          	jal	80000de2 <myproc>
    800050bc:	89aa                	mv	s3,a0
  int dst;
  int dport;
  uint64 bufaddr;
  int len;

  argint(0, &sport);
    800050be:	fcc40593          	addi	a1,s0,-52
    800050c2:	4501                	li	a0,0
    800050c4:	c37fc0ef          	jal	80001cfa <argint>
  argint(1, &dst);
    800050c8:	fc840593          	addi	a1,s0,-56
    800050cc:	4505                	li	a0,1
    800050ce:	c2dfc0ef          	jal	80001cfa <argint>
  argint(2, &dport);
    800050d2:	fc440593          	addi	a1,s0,-60
    800050d6:	4509                	li	a0,2
    800050d8:	c23fc0ef          	jal	80001cfa <argint>
  argaddr(3, &bufaddr);
    800050dc:	fb840593          	addi	a1,s0,-72
    800050e0:	450d                	li	a0,3
    800050e2:	c35fc0ef          	jal	80001d16 <argaddr>
  argint(4, &len);
    800050e6:	fb440593          	addi	a1,s0,-76
    800050ea:	4511                	li	a0,4
    800050ec:	c0ffc0ef          	jal	80001cfa <argint>

  int total = len + sizeof(struct eth) + sizeof(struct ip) + sizeof(struct udp);
    800050f0:	fb442903          	lw	s2,-76(s0)
    800050f4:	02a9091b          	addiw	s2,s2,42
  if(total > PGSIZE)
    800050f8:	6785                	lui	a5,0x1
    return -1;
    800050fa:	557d                	li	a0,-1
  if(total > PGSIZE)
    800050fc:	1527c963          	blt	a5,s2,8000524e <sys_send+0x1a2>
    80005100:	fc26                	sd	s1,56(sp)

  char *buf = kalloc();
    80005102:	802fb0ef          	jal	80000104 <kalloc>
    80005106:	84aa                	mv	s1,a0
  if(buf == 0){
    80005108:	14050963          	beqz	a0,8000525a <sys_send+0x1ae>
    printf("sys_send: kalloc failed\n");
    return -1;
  }
  memset(buf, 0, PGSIZE);
    8000510c:	6605                	lui	a2,0x1
    8000510e:	4581                	li	a1,0
    80005110:	84efb0ef          	jal	8000015e <memset>

  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, host_mac, ETHADDR_LEN);
    80005114:	4619                	li	a2,6
    80005116:	00004597          	auipc	a1,0x4
    8000511a:	82258593          	addi	a1,a1,-2014 # 80008938 <host_mac>
    8000511e:	8526                	mv	a0,s1
    80005120:	89efb0ef          	jal	800001be <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN);
    80005124:	4619                	li	a2,6
    80005126:	00004597          	auipc	a1,0x4
    8000512a:	81a58593          	addi	a1,a1,-2022 # 80008940 <local_mac>
    8000512e:	00c48533          	add	a0,s1,a2
    80005132:	88cfb0ef          	jal	800001be <memmove>
  eth->type = htons(ETHTYPE_IP);
    80005136:	47a1                	li	a5,8
    80005138:	00f48623          	sb	a5,12(s1)
    8000513c:	000486a3          	sb	zero,13(s1)

  struct ip *ip = (struct ip *)(eth + 1);
    80005140:	00e48713          	addi	a4,s1,14
  ip->ip_vhl = 0x45; // version 4, header length 4*5
    80005144:	04500793          	li	a5,69
    80005148:	00f48723          	sb	a5,14(s1)
  ip->ip_tos = 0;
    8000514c:	000487a3          	sb	zero,15(s1)
  ip->ip_len = htons(sizeof(struct ip) + sizeof(struct udp) + len);
    80005150:	fb442683          	lw	a3,-76(s0)
    80005154:	03069593          	slli	a1,a3,0x30
    80005158:	91c1                	srli	a1,a1,0x30
    8000515a:	01c5879b          	addiw	a5,a1,28
// endianness support
//

static inline uint16 bswaps(uint16 val)
{
  return (((val & 0x00ffU) << 8) |
    8000515e:	03079513          	slli	a0,a5,0x30
    80005162:	03855613          	srli	a2,a0,0x38
    80005166:	0087979b          	slliw	a5,a5,0x8
    8000516a:	9fb1                	addw	a5,a5,a2
    8000516c:	00f49823          	sh	a5,16(s1)
  ip->ip_id = 0;
    80005170:	00049923          	sh	zero,18(s1)
  ip->ip_off = 0;
    80005174:	00049a23          	sh	zero,20(s1)
  ip->ip_ttl = 100;
    80005178:	06400793          	li	a5,100
    8000517c:	00f48b23          	sb	a5,22(s1)
  ip->ip_p = IPPROTO_UDP;
    80005180:	47c5                	li	a5,17
    80005182:	00f48ba3          	sb	a5,23(s1)
  ip->ip_src = htonl(local_ip);
    80005186:	0f0207b7          	lui	a5,0xf020
    8000518a:	07a9                	addi	a5,a5,10 # f02000a <_entry-0x70fdfff6>
    8000518c:	00f4ad23          	sw	a5,26(s1)
  ip->ip_dst = htonl(dst);
    80005190:	fc842783          	lw	a5,-56(s0)
          ((val & 0xff00U) >> 8));
}

static inline uint32 bswapl(uint32 val)
{
  return (((val & 0x000000ffUL) << 24) |
    80005194:	0187961b          	slliw	a2,a5,0x18
          ((val & 0x0000ff00UL) << 8) |
          ((val & 0x00ff0000UL) >> 8) |
          ((val & 0xff000000UL) >> 24));
    80005198:	0187d51b          	srliw	a0,a5,0x18
          ((val & 0x00ff0000UL) >> 8) |
    8000519c:	8e49                	or	a2,a2,a0
          ((val & 0x0000ff00UL) << 8) |
    8000519e:	0087951b          	slliw	a0,a5,0x8
    800051a2:	00ff0837          	lui	a6,0xff0
    800051a6:	01057533          	and	a0,a0,a6
          ((val & 0x00ff0000UL) >> 8) |
    800051aa:	8e49                	or	a2,a2,a0
    800051ac:	0087d79b          	srliw	a5,a5,0x8
    800051b0:	6541                	lui	a0,0x10
    800051b2:	f0050513          	addi	a0,a0,-256 # ff00 <_entry-0x7fff0100>
    800051b6:	8fe9                	and	a5,a5,a0
    800051b8:	8fd1                	or	a5,a5,a2
    800051ba:	00f4af23          	sw	a5,30(s1)
  while (nleft > 1)  {
    800051be:	02248813          	addi	a6,s1,34
  unsigned int sum = 0;
    800051c2:	4601                	li	a2,0
    sum += *w++;
    800051c4:	0709                	addi	a4,a4,2
    800051c6:	ffe75783          	lhu	a5,-2(a4)
    800051ca:	9fb1                	addw	a5,a5,a2
    800051cc:	863e                	mv	a2,a5
  while (nleft > 1)  {
    800051ce:	ff071be3          	bne	a4,a6,800051c4 <sys_send+0x118>
  sum = (sum & 0xffff) + (sum >> 16);
    800051d2:	03079713          	slli	a4,a5,0x30
    800051d6:	9341                	srli	a4,a4,0x30
    800051d8:	0107d79b          	srliw	a5,a5,0x10
    800051dc:	9fb9                	addw	a5,a5,a4
  sum += (sum >> 16);
    800051de:	0107d71b          	srliw	a4,a5,0x10
    800051e2:	9fb9                	addw	a5,a5,a4
  answer = ~sum; /* truncate to 16 bits */
    800051e4:	fff7c793          	not	a5,a5
  ip->ip_sum = in_cksum((unsigned char *)ip, sizeof(*ip));
    800051e8:	00f49c23          	sh	a5,24(s1)

  struct udp *udp = (struct udp *)(ip + 1);
  udp->sport = htons(sport);
    800051ec:	fcc42783          	lw	a5,-52(s0)
  return (((val & 0x00ffU) << 8) |
    800051f0:	03079613          	slli	a2,a5,0x30
    800051f4:	03865713          	srli	a4,a2,0x38
    800051f8:	0087979b          	slliw	a5,a5,0x8
    800051fc:	9fb9                	addw	a5,a5,a4
    800051fe:	02f49123          	sh	a5,34(s1)
  udp->dport = htons(dport);
    80005202:	fc442783          	lw	a5,-60(s0)
    80005206:	03079613          	slli	a2,a5,0x30
    8000520a:	03865713          	srli	a4,a2,0x38
    8000520e:	0087979b          	slliw	a5,a5,0x8
    80005212:	9fb9                	addw	a5,a5,a4
    80005214:	02f49223          	sh	a5,36(s1)
  udp->ulen = htons(len + sizeof(struct udp));
    80005218:	0085879b          	addiw	a5,a1,8
    8000521c:	03079613          	slli	a2,a5,0x30
    80005220:	03865713          	srli	a4,a2,0x38
    80005224:	0087979b          	slliw	a5,a5,0x8
    80005228:	9fb9                	addw	a5,a5,a4
    8000522a:	02f49323          	sh	a5,38(s1)

  char *payload = (char *)(udp + 1);
  if(copyin(p->pagetable, payload, bufaddr, len) < 0){
    8000522e:	fb843603          	ld	a2,-72(s0)
    80005232:	02a48593          	addi	a1,s1,42
    80005236:	0509b503          	ld	a0,80(s3)
    8000523a:	991fb0ef          	jal	80000bca <copyin>
    8000523e:	02054763          	bltz	a0,8000526c <sys_send+0x1c0>
    kfree(buf);
    printf("send: copyin failed\n");
    return -1;
  }

  e1000_transmit(buf, total);
    80005242:	85ca                	mv	a1,s2
    80005244:	8526                	mv	a0,s1
    80005246:	dddff0ef          	jal	80005022 <e1000_transmit>

  return 0;
    8000524a:	4501                	li	a0,0
    8000524c:	74e2                	ld	s1,56(sp)
}
    8000524e:	60a6                	ld	ra,72(sp)
    80005250:	6406                	ld	s0,64(sp)
    80005252:	7942                	ld	s2,48(sp)
    80005254:	79a2                	ld	s3,40(sp)
    80005256:	6161                	addi	sp,sp,80
    80005258:	8082                	ret
    printf("sys_send: kalloc failed\n");
    8000525a:	00003517          	auipc	a0,0x3
    8000525e:	47e50513          	addi	a0,a0,1150 # 800086d8 <etext+0x6d8>
    80005262:	746000ef          	jal	800059a8 <printf>
    return -1;
    80005266:	557d                	li	a0,-1
    80005268:	74e2                	ld	s1,56(sp)
    8000526a:	b7d5                	j	8000524e <sys_send+0x1a2>
    kfree(buf);
    8000526c:	8526                	mv	a0,s1
    8000526e:	daffa0ef          	jal	8000001c <kfree>
    printf("send: copyin failed\n");
    80005272:	00003517          	auipc	a0,0x3
    80005276:	48650513          	addi	a0,a0,1158 # 800086f8 <etext+0x6f8>
    8000527a:	72e000ef          	jal	800059a8 <printf>
    return -1;
    8000527e:	557d                	li	a0,-1
    80005280:	74e2                	ld	s1,56(sp)
    80005282:	b7f1                	j	8000524e <sys_send+0x1a2>

0000000080005284 <ip_rx>:
void
ip_rx(char *buf, int len)
{
  // don't delete this printf; make grade depends on it.
  static int seen_ip = 0;
  if(seen_ip == 0)
    80005284:	00003797          	auipc	a5,0x3
    80005288:	6f87a783          	lw	a5,1784(a5) # 8000897c <seen_ip.1>
    8000528c:	c799                	beqz	a5,8000529a <ip_rx+0x16>
    printf("ip_rx: received an IP packet\n");
  seen_ip = 1;
    8000528e:	4785                	li	a5,1
    80005290:	00003717          	auipc	a4,0x3
    80005294:	6ef72623          	sw	a5,1772(a4) # 8000897c <seen_ip.1>
    80005298:	8082                	ret
{
    8000529a:	1141                	addi	sp,sp,-16
    8000529c:	e406                	sd	ra,8(sp)
    8000529e:	e022                	sd	s0,0(sp)
    800052a0:	0800                	addi	s0,sp,16
    printf("ip_rx: received an IP packet\n");
    800052a2:	00003517          	auipc	a0,0x3
    800052a6:	46e50513          	addi	a0,a0,1134 # 80008710 <etext+0x710>
    800052aa:	6fe000ef          	jal	800059a8 <printf>
  seen_ip = 1;
    800052ae:	4785                	li	a5,1
    800052b0:	00003717          	auipc	a4,0x3
    800052b4:	6cf72623          	sw	a5,1740(a4) # 8000897c <seen_ip.1>

  //
  // Your code here.
  //
  
}
    800052b8:	60a2                	ld	ra,8(sp)
    800052ba:	6402                	ld	s0,0(sp)
    800052bc:	0141                	addi	sp,sp,16
    800052be:	8082                	ret

00000000800052c0 <arp_rx>:
// qemu to send IP packets to xv6; the real ARP
// protocol is more complex.
//
void
arp_rx(char *inbuf)
{
    800052c0:	7179                	addi	sp,sp,-48
    800052c2:	f406                	sd	ra,40(sp)
    800052c4:	f022                	sd	s0,32(sp)
    800052c6:	e84a                	sd	s2,16(sp)
    800052c8:	1800                	addi	s0,sp,48
    800052ca:	892a                	mv	s2,a0
  static int seen_arp = 0;

  if(seen_arp){
    800052cc:	00003797          	auipc	a5,0x3
    800052d0:	6ac7a783          	lw	a5,1708(a5) # 80008978 <seen_arp.0>
    800052d4:	10079263          	bnez	a5,800053d8 <arp_rx+0x118>
    800052d8:	ec26                	sd	s1,24(sp)
    800052da:	e44e                	sd	s3,8(sp)
    800052dc:	e052                	sd	s4,0(sp)
    kfree(inbuf);
    return;
  }
  printf("arp_rx: received an ARP packet\n");
    800052de:	00003517          	auipc	a0,0x3
    800052e2:	45250513          	addi	a0,a0,1106 # 80008730 <etext+0x730>
    800052e6:	6c2000ef          	jal	800059a8 <printf>
  seen_arp = 1;
    800052ea:	4785                	li	a5,1
    800052ec:	00003717          	auipc	a4,0x3
    800052f0:	68f72623          	sw	a5,1676(a4) # 80008978 <seen_arp.0>

  struct eth *ineth = (struct eth *) inbuf;
  struct arp *inarp = (struct arp *) (ineth + 1);

  char *buf = kalloc();
    800052f4:	e11fa0ef          	jal	80000104 <kalloc>
    800052f8:	84aa                	mv	s1,a0
  if(buf == 0)
    800052fa:	0e050263          	beqz	a0,800053de <arp_rx+0x11e>
    panic("send_arp_reply");
  
  struct eth *eth = (struct eth *) buf;
  memmove(eth->dhost, ineth->shost, ETHADDR_LEN); // ethernet destination = query source
    800052fe:	00690a13          	addi	s4,s2,6
    80005302:	4619                	li	a2,6
    80005304:	85d2                	mv	a1,s4
    80005306:	eb9fa0ef          	jal	800001be <memmove>
  memmove(eth->shost, local_mac, ETHADDR_LEN); // ethernet source = xv6's ethernet address
    8000530a:	4619                	li	a2,6
    8000530c:	00003597          	auipc	a1,0x3
    80005310:	63458593          	addi	a1,a1,1588 # 80008940 <local_mac>
    80005314:	00c48533          	add	a0,s1,a2
    80005318:	ea7fa0ef          	jal	800001be <memmove>
  eth->type = htons(ETHTYPE_ARP);
    8000531c:	47a1                	li	a5,8
    8000531e:	00f48623          	sb	a5,12(s1)
    80005322:	4719                	li	a4,6
    80005324:	00e486a3          	sb	a4,13(s1)

  struct arp *arp = (struct arp *)(eth + 1);
  arp->hrd = htons(ARP_HRD_ETHER);
    80005328:	00048723          	sb	zero,14(s1)
    8000532c:	4705                	li	a4,1
    8000532e:	00e487a3          	sb	a4,15(s1)
  arp->pro = htons(ETHTYPE_IP);
    80005332:	00f48823          	sb	a5,16(s1)
    80005336:	000488a3          	sb	zero,17(s1)
  arp->hln = ETHADDR_LEN;
    8000533a:	4799                	li	a5,6
    8000533c:	00f48923          	sb	a5,18(s1)
  arp->pln = sizeof(uint32);
    80005340:	4791                	li	a5,4
    80005342:	00f489a3          	sb	a5,19(s1)
  arp->op = htons(ARP_OP_REPLY);
    80005346:	00048a23          	sb	zero,20(s1)
    8000534a:	4989                	li	s3,2
    8000534c:	01348aa3          	sb	s3,21(s1)

  memmove(arp->sha, local_mac, ETHADDR_LEN);
    80005350:	4619                	li	a2,6
    80005352:	00003597          	auipc	a1,0x3
    80005356:	5ee58593          	addi	a1,a1,1518 # 80008940 <local_mac>
    8000535a:	01648513          	addi	a0,s1,22
    8000535e:	e61fa0ef          	jal	800001be <memmove>
  arp->sip = htonl(local_ip);
    80005362:	47a9                	li	a5,10
    80005364:	00f48e23          	sb	a5,28(s1)
    80005368:	00048ea3          	sb	zero,29(s1)
    8000536c:	01348f23          	sb	s3,30(s1)
    80005370:	47bd                	li	a5,15
    80005372:	00f48fa3          	sb	a5,31(s1)
  memmove(arp->tha, ineth->shost, ETHADDR_LEN);
    80005376:	4619                	li	a2,6
    80005378:	85d2                	mv	a1,s4
    8000537a:	02048513          	addi	a0,s1,32
    8000537e:	e41fa0ef          	jal	800001be <memmove>
  arp->tip = inarp->sip;
    80005382:	01c94703          	lbu	a4,28(s2)
    80005386:	01d94783          	lbu	a5,29(s2)
    8000538a:	07a2                	slli	a5,a5,0x8
    8000538c:	8fd9                	or	a5,a5,a4
    8000538e:	01e94703          	lbu	a4,30(s2)
    80005392:	0742                	slli	a4,a4,0x10
    80005394:	8f5d                	or	a4,a4,a5
    80005396:	01f94783          	lbu	a5,31(s2)
    8000539a:	07e2                	slli	a5,a5,0x18
    8000539c:	8fd9                	or	a5,a5,a4
    8000539e:	02f48323          	sb	a5,38(s1)
    800053a2:	0087d713          	srli	a4,a5,0x8
    800053a6:	02e483a3          	sb	a4,39(s1)
    800053aa:	0107d713          	srli	a4,a5,0x10
    800053ae:	02e48423          	sb	a4,40(s1)
    800053b2:	83e1                	srli	a5,a5,0x18
    800053b4:	02f484a3          	sb	a5,41(s1)

  e1000_transmit(buf, sizeof(*eth) + sizeof(*arp));
    800053b8:	02a00593          	li	a1,42
    800053bc:	8526                	mv	a0,s1
    800053be:	c65ff0ef          	jal	80005022 <e1000_transmit>

  kfree(inbuf);
    800053c2:	854a                	mv	a0,s2
    800053c4:	c59fa0ef          	jal	8000001c <kfree>
    800053c8:	64e2                	ld	s1,24(sp)
    800053ca:	69a2                	ld	s3,8(sp)
    800053cc:	6a02                	ld	s4,0(sp)
}
    800053ce:	70a2                	ld	ra,40(sp)
    800053d0:	7402                	ld	s0,32(sp)
    800053d2:	6942                	ld	s2,16(sp)
    800053d4:	6145                	addi	sp,sp,48
    800053d6:	8082                	ret
    kfree(inbuf);
    800053d8:	c45fa0ef          	jal	8000001c <kfree>
    return;
    800053dc:	bfcd                	j	800053ce <arp_rx+0x10e>
    panic("send_arp_reply");
    800053de:	00003517          	auipc	a0,0x3
    800053e2:	37250513          	addi	a0,a0,882 # 80008750 <etext+0x750>
    800053e6:	0ed000ef          	jal	80005cd2 <panic>

00000000800053ea <net_rx>:

void
net_rx(char *buf, int len)
{
    800053ea:	1141                	addi	sp,sp,-16
    800053ec:	e406                	sd	ra,8(sp)
    800053ee:	e022                	sd	s0,0(sp)
    800053f0:	0800                	addi	s0,sp,16
  struct eth *eth = (struct eth *) buf;

  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
    800053f2:	02900793          	li	a5,41
    800053f6:	02b7fe63          	bgeu	a5,a1,80005432 <net_rx+0x48>
     ntohs(eth->type) == ETHTYPE_ARP){
    800053fa:	00c54703          	lbu	a4,12(a0)
    800053fe:	00d54783          	lbu	a5,13(a0)
    80005402:	07a2                	slli	a5,a5,0x8
  if(len >= sizeof(struct eth) + sizeof(struct arp) &&
    80005404:	8fd9                	or	a5,a5,a4
    80005406:	60800713          	li	a4,1544
    8000540a:	02e78163          	beq	a5,a4,8000542c <net_rx+0x42>
    arp_rx(buf);
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
     ntohs(eth->type) == ETHTYPE_IP){
    8000540e:	00c54703          	lbu	a4,12(a0)
    80005412:	00d54783          	lbu	a5,13(a0)
    80005416:	07a2                	slli	a5,a5,0x8
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
    80005418:	8fd9                	or	a5,a5,a4
    8000541a:	4721                	li	a4,8
    8000541c:	02e78063          	beq	a5,a4,8000543c <net_rx+0x52>
    ip_rx(buf, len);
  } else {
    kfree(buf);
    80005420:	bfdfa0ef          	jal	8000001c <kfree>
  }
}
    80005424:	60a2                	ld	ra,8(sp)
    80005426:	6402                	ld	s0,0(sp)
    80005428:	0141                	addi	sp,sp,16
    8000542a:	8082                	ret
    arp_rx(buf);
    8000542c:	e95ff0ef          	jal	800052c0 <arp_rx>
    80005430:	bfd5                	j	80005424 <net_rx+0x3a>
  } else if(len >= sizeof(struct eth) + sizeof(struct ip) &&
    80005432:	02100793          	li	a5,33
    80005436:	feb7f5e3          	bgeu	a5,a1,80005420 <net_rx+0x36>
    8000543a:	bfd1                	j	8000540e <net_rx+0x24>
    ip_rx(buf, len);
    8000543c:	e49ff0ef          	jal	80005284 <ip_rx>
    80005440:	b7d5                	j	80005424 <net_rx+0x3a>

0000000080005442 <pci_init>:
#include "proc.h"
#include "defs.h"

void
pci_init()
{
    80005442:	715d                	addi	sp,sp,-80
    80005444:	e486                	sd	ra,72(sp)
    80005446:	e0a2                	sd	s0,64(sp)
    80005448:	fc26                	sd	s1,56(sp)
    8000544a:	f84a                	sd	s2,48(sp)
    8000544c:	f44e                	sd	s3,40(sp)
    8000544e:	f052                	sd	s4,32(sp)
    80005450:	ec56                	sd	s5,24(sp)
    80005452:	e85a                	sd	s6,16(sp)
    80005454:	e45e                	sd	s7,8(sp)
    80005456:	0880                	addi	s0,sp,80
    80005458:	300004b7          	lui	s1,0x30000
    uint32 off = (bus << 16) | (dev << 11) | (func << 8) | (offset);
    volatile uint32 *base = ecam + off;
    uint32 id = base[0];
    
    // 100e:8086 is an e1000
    if(id == 0x100e8086){
    8000545c:	100e8937          	lui	s2,0x100e8
    80005460:	08690913          	addi	s2,s2,134 # 100e8086 <_entry-0x6ff17f7a>
      // command and status register.
      // bit 0 : I/O access enable
      // bit 1 : memory access enable
      // bit 2 : enable mastering
      base[1] = 7;
    80005464:	4b9d                	li	s7,7
      for(int i = 0; i < 6; i++){
        uint32 old = base[4+i];

        // writing all 1's to the BAR causes it to be
        // replaced with its size.
        base[4+i] = 0xffffffff;
    80005466:	5afd                	li	s5,-1
        base[4+i] = old;
      }

      // tell the e1000 to reveal its registers at
      // physical address 0x40000000.
      base[4+0] = e1000_regs;
    80005468:	40000b37          	lui	s6,0x40000
  for(int dev = 0; dev < 32; dev++){
    8000546c:	6a09                	lui	s4,0x2
    8000546e:	300409b7          	lui	s3,0x30040
    80005472:	a021                	j	8000547a <pci_init+0x38>
    80005474:	94d2                	add	s1,s1,s4
    80005476:	03348f63          	beq	s1,s3,800054b4 <pci_init+0x72>
    volatile uint32 *base = ecam + off;
    8000547a:	86a6                	mv	a3,s1
    uint32 id = base[0];
    8000547c:	409c                	lw	a5,0(s1)
    8000547e:	2781                	sext.w	a5,a5
    if(id == 0x100e8086){
    80005480:	ff279ae3          	bne	a5,s2,80005474 <pci_init+0x32>
      base[1] = 7;
    80005484:	0174a223          	sw	s7,4(s1) # 30000004 <_entry-0x4ffffffc>
      __sync_synchronize();
    80005488:	0330000f          	fence	rw,rw
      for(int i = 0; i < 6; i++){
    8000548c:	01048793          	addi	a5,s1,16
    80005490:	02848613          	addi	a2,s1,40
        uint32 old = base[4+i];
    80005494:	4398                	lw	a4,0(a5)
    80005496:	2701                	sext.w	a4,a4
        base[4+i] = 0xffffffff;
    80005498:	0157a023          	sw	s5,0(a5)
        __sync_synchronize();
    8000549c:	0330000f          	fence	rw,rw
        base[4+i] = old;
    800054a0:	c398                	sw	a4,0(a5)
      for(int i = 0; i < 6; i++){
    800054a2:	0791                	addi	a5,a5,4
    800054a4:	fec798e3          	bne	a5,a2,80005494 <pci_init+0x52>
      base[4+0] = e1000_regs;
    800054a8:	0166a823          	sw	s6,16(a3)

      e1000_init((uint32*)e1000_regs);
    800054ac:	855a                	mv	a0,s6
    800054ae:	a01ff0ef          	jal	80004eae <e1000_init>
    800054b2:	b7c9                	j	80005474 <pci_init+0x32>
    }
  }
}
    800054b4:	60a6                	ld	ra,72(sp)
    800054b6:	6406                	ld	s0,64(sp)
    800054b8:	74e2                	ld	s1,56(sp)
    800054ba:	7942                	ld	s2,48(sp)
    800054bc:	79a2                	ld	s3,40(sp)
    800054be:	7a02                	ld	s4,32(sp)
    800054c0:	6ae2                	ld	s5,24(sp)
    800054c2:	6b42                	ld	s6,16(sp)
    800054c4:	6ba2                	ld	s7,8(sp)
    800054c6:	6161                	addi	sp,sp,80
    800054c8:	8082                	ret

00000000800054ca <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800054ca:	1141                	addi	sp,sp,-16
    800054cc:	e406                	sd	ra,8(sp)
    800054ce:	e022                	sd	s0,0(sp)
    800054d0:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800054d2:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800054d6:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800054da:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800054de:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800054e2:	577d                	li	a4,-1
    800054e4:	177e                	slli	a4,a4,0x3f
    800054e6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800054e8:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800054ec:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800054f0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800054f4:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    800054f8:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    800054fc:	000f4737          	lui	a4,0xf4
    80005500:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005504:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80005506:	14d79073          	csrw	stimecmp,a5
}
    8000550a:	60a2                	ld	ra,8(sp)
    8000550c:	6402                	ld	s0,0(sp)
    8000550e:	0141                	addi	sp,sp,16
    80005510:	8082                	ret

0000000080005512 <start>:
{
    80005512:	1141                	addi	sp,sp,-16
    80005514:	e406                	sd	ra,8(sp)
    80005516:	e022                	sd	s0,0(sp)
    80005518:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000551a:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    8000551e:	7779                	lui	a4,0xffffe
    80005520:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdc927>
    80005524:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005526:	6705                	lui	a4,0x1
    80005528:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    8000552c:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    8000552e:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005532:	ffffb797          	auipc	a5,0xffffb
    80005536:	de278793          	addi	a5,a5,-542 # 80000314 <main>
    8000553a:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    8000553e:	4781                	li	a5,0
    80005540:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005544:	67c1                	lui	a5,0x10
    80005546:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80005548:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    8000554c:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005550:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80005554:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80005558:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    8000555c:	57fd                	li	a5,-1
    8000555e:	83a9                	srli	a5,a5,0xa
    80005560:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005564:	47bd                	li	a5,15
    80005566:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000556a:	f61ff0ef          	jal	800054ca <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    8000556e:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005572:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005574:	823e                	mv	tp,a5
  asm volatile("mret");
    80005576:	30200073          	mret
}
    8000557a:	60a2                	ld	ra,8(sp)
    8000557c:	6402                	ld	s0,0(sp)
    8000557e:	0141                	addi	sp,sp,16
    80005580:	8082                	ret

0000000080005582 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005582:	7119                	addi	sp,sp,-128
    80005584:	fc86                	sd	ra,120(sp)
    80005586:	f8a2                	sd	s0,112(sp)
    80005588:	f4a6                	sd	s1,104(sp)
    8000558a:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    8000558c:	06c05b63          	blez	a2,80005602 <consolewrite+0x80>
    80005590:	f0ca                	sd	s2,96(sp)
    80005592:	ecce                	sd	s3,88(sp)
    80005594:	e8d2                	sd	s4,80(sp)
    80005596:	e4d6                	sd	s5,72(sp)
    80005598:	e0da                	sd	s6,64(sp)
    8000559a:	fc5e                	sd	s7,56(sp)
    8000559c:	f862                	sd	s8,48(sp)
    8000559e:	f466                	sd	s9,40(sp)
    800055a0:	f06a                	sd	s10,32(sp)
    800055a2:	8b2a                	mv	s6,a0
    800055a4:	8bae                	mv	s7,a1
    800055a6:	8a32                	mv	s4,a2
  int i = 0;
    800055a8:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800055aa:	02000c93          	li	s9,32
    800055ae:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800055b2:	f8040a93          	addi	s5,s0,-128
    800055b6:	5c7d                	li	s8,-1
    800055b8:	a025                	j	800055e0 <consolewrite+0x5e>
    if(nn > n - i)
    800055ba:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800055be:	86ce                	mv	a3,s3
    800055c0:	01748633          	add	a2,s1,s7
    800055c4:	85da                	mv	a1,s6
    800055c6:	8556                	mv	a0,s5
    800055c8:	9bcfc0ef          	jal	80001784 <either_copyin>
    800055cc:	03850d63          	beq	a0,s8,80005606 <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    800055d0:	85ce                	mv	a1,s3
    800055d2:	8556                	mv	a0,s5
    800055d4:	7b4000ef          	jal	80005d88 <uartwrite>
    i += nn;
    800055d8:	009904bb          	addw	s1,s2,s1
  while(i < n){
    800055dc:	0144d963          	bge	s1,s4,800055ee <consolewrite+0x6c>
    if(nn > n - i)
    800055e0:	409a07bb          	subw	a5,s4,s1
    800055e4:	893e                	mv	s2,a5
    800055e6:	fcfcdae3          	bge	s9,a5,800055ba <consolewrite+0x38>
    800055ea:	896a                	mv	s2,s10
    800055ec:	b7f9                	j	800055ba <consolewrite+0x38>
    800055ee:	7906                	ld	s2,96(sp)
    800055f0:	69e6                	ld	s3,88(sp)
    800055f2:	6a46                	ld	s4,80(sp)
    800055f4:	6aa6                	ld	s5,72(sp)
    800055f6:	6b06                	ld	s6,64(sp)
    800055f8:	7be2                	ld	s7,56(sp)
    800055fa:	7c42                	ld	s8,48(sp)
    800055fc:	7ca2                	ld	s9,40(sp)
    800055fe:	7d02                	ld	s10,32(sp)
    80005600:	a821                	j	80005618 <consolewrite+0x96>
  int i = 0;
    80005602:	4481                	li	s1,0
    80005604:	a811                	j	80005618 <consolewrite+0x96>
    80005606:	7906                	ld	s2,96(sp)
    80005608:	69e6                	ld	s3,88(sp)
    8000560a:	6a46                	ld	s4,80(sp)
    8000560c:	6aa6                	ld	s5,72(sp)
    8000560e:	6b06                	ld	s6,64(sp)
    80005610:	7be2                	ld	s7,56(sp)
    80005612:	7c42                	ld	s8,48(sp)
    80005614:	7ca2                	ld	s9,40(sp)
    80005616:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    80005618:	8526                	mv	a0,s1
    8000561a:	70e6                	ld	ra,120(sp)
    8000561c:	7446                	ld	s0,112(sp)
    8000561e:	74a6                	ld	s1,104(sp)
    80005620:	6109                	addi	sp,sp,128
    80005622:	8082                	ret

0000000080005624 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005624:	711d                	addi	sp,sp,-96
    80005626:	ec86                	sd	ra,88(sp)
    80005628:	e8a2                	sd	s0,80(sp)
    8000562a:	e4a6                	sd	s1,72(sp)
    8000562c:	e0ca                	sd	s2,64(sp)
    8000562e:	fc4e                	sd	s3,56(sp)
    80005630:	f852                	sd	s4,48(sp)
    80005632:	f05a                	sd	s6,32(sp)
    80005634:	ec5e                	sd	s7,24(sp)
    80005636:	1080                	addi	s0,sp,96
    80005638:	8b2a                	mv	s6,a0
    8000563a:	8a2e                	mv	s4,a1
    8000563c:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    8000563e:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80005640:	0001c517          	auipc	a0,0x1c
    80005644:	7c050513          	addi	a0,a0,1984 # 80021e00 <cons>
    80005648:	14d000ef          	jal	80005f94 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    8000564c:	0001c497          	auipc	s1,0x1c
    80005650:	7b448493          	addi	s1,s1,1972 # 80021e00 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005654:	0001d917          	auipc	s2,0x1d
    80005658:	84490913          	addi	s2,s2,-1980 # 80021e98 <cons+0x98>
  while(n > 0){
    8000565c:	0b305b63          	blez	s3,80005712 <consoleread+0xee>
    while(cons.r == cons.w){
    80005660:	0984a783          	lw	a5,152(s1)
    80005664:	09c4a703          	lw	a4,156(s1)
    80005668:	0af71063          	bne	a4,a5,80005708 <consoleread+0xe4>
      if(killed(myproc())){
    8000566c:	f76fb0ef          	jal	80000de2 <myproc>
    80005670:	fadfb0ef          	jal	8000161c <killed>
    80005674:	e12d                	bnez	a0,800056d6 <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80005676:	85a6                	mv	a1,s1
    80005678:	854a                	mv	a0,s2
    8000567a:	d67fb0ef          	jal	800013e0 <sleep>
    while(cons.r == cons.w){
    8000567e:	0984a783          	lw	a5,152(s1)
    80005682:	09c4a703          	lw	a4,156(s1)
    80005686:	fef703e3          	beq	a4,a5,8000566c <consoleread+0x48>
    8000568a:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    8000568c:	0001c717          	auipc	a4,0x1c
    80005690:	77470713          	addi	a4,a4,1908 # 80021e00 <cons>
    80005694:	0017869b          	addiw	a3,a5,1
    80005698:	08d72c23          	sw	a3,152(a4)
    8000569c:	07f7f693          	andi	a3,a5,127
    800056a0:	9736                	add	a4,a4,a3
    800056a2:	01874703          	lbu	a4,24(a4)
    800056a6:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800056aa:	4691                	li	a3,4
    800056ac:	04da8663          	beq	s5,a3,800056f8 <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800056b0:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800056b4:	4685                	li	a3,1
    800056b6:	faf40613          	addi	a2,s0,-81
    800056ba:	85d2                	mv	a1,s4
    800056bc:	855a                	mv	a0,s6
    800056be:	87cfc0ef          	jal	8000173a <either_copyout>
    800056c2:	57fd                	li	a5,-1
    800056c4:	04f50663          	beq	a0,a5,80005710 <consoleread+0xec>
      break;

    dst++;
    800056c8:	0a05                	addi	s4,s4,1 # 2001 <_entry-0x7fffdfff>
    --n;
    800056ca:	39fd                	addiw	s3,s3,-1 # 3003ffff <_entry-0x4ffc0001>

    if(c == '\n'){
    800056cc:	47a9                	li	a5,10
    800056ce:	04fa8b63          	beq	s5,a5,80005724 <consoleread+0x100>
    800056d2:	7aa2                	ld	s5,40(sp)
    800056d4:	b761                	j	8000565c <consoleread+0x38>
        release(&cons.lock);
    800056d6:	0001c517          	auipc	a0,0x1c
    800056da:	72a50513          	addi	a0,a0,1834 # 80021e00 <cons>
    800056de:	14b000ef          	jal	80006028 <release>
        return -1;
    800056e2:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800056e4:	60e6                	ld	ra,88(sp)
    800056e6:	6446                	ld	s0,80(sp)
    800056e8:	64a6                	ld	s1,72(sp)
    800056ea:	6906                	ld	s2,64(sp)
    800056ec:	79e2                	ld	s3,56(sp)
    800056ee:	7a42                	ld	s4,48(sp)
    800056f0:	7b02                	ld	s6,32(sp)
    800056f2:	6be2                	ld	s7,24(sp)
    800056f4:	6125                	addi	sp,sp,96
    800056f6:	8082                	ret
      if(n < target){
    800056f8:	0179fa63          	bgeu	s3,s7,8000570c <consoleread+0xe8>
        cons.r--;
    800056fc:	0001c717          	auipc	a4,0x1c
    80005700:	78f72e23          	sw	a5,1948(a4) # 80021e98 <cons+0x98>
    80005704:	7aa2                	ld	s5,40(sp)
    80005706:	a031                	j	80005712 <consoleread+0xee>
    80005708:	f456                	sd	s5,40(sp)
    8000570a:	b749                	j	8000568c <consoleread+0x68>
    8000570c:	7aa2                	ld	s5,40(sp)
    8000570e:	a011                	j	80005712 <consoleread+0xee>
    80005710:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005712:	0001c517          	auipc	a0,0x1c
    80005716:	6ee50513          	addi	a0,a0,1774 # 80021e00 <cons>
    8000571a:	10f000ef          	jal	80006028 <release>
  return target - n;
    8000571e:	413b853b          	subw	a0,s7,s3
    80005722:	b7c9                	j	800056e4 <consoleread+0xc0>
    80005724:	7aa2                	ld	s5,40(sp)
    80005726:	b7f5                	j	80005712 <consoleread+0xee>

0000000080005728 <consputc>:
{
    80005728:	1141                	addi	sp,sp,-16
    8000572a:	e406                	sd	ra,8(sp)
    8000572c:	e022                	sd	s0,0(sp)
    8000572e:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005730:	10000793          	li	a5,256
    80005734:	00f50863          	beq	a0,a5,80005744 <consputc+0x1c>
    uartputc_sync(c);
    80005738:	6e4000ef          	jal	80005e1c <uartputc_sync>
}
    8000573c:	60a2                	ld	ra,8(sp)
    8000573e:	6402                	ld	s0,0(sp)
    80005740:	0141                	addi	sp,sp,16
    80005742:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005744:	4521                	li	a0,8
    80005746:	6d6000ef          	jal	80005e1c <uartputc_sync>
    8000574a:	02000513          	li	a0,32
    8000574e:	6ce000ef          	jal	80005e1c <uartputc_sync>
    80005752:	4521                	li	a0,8
    80005754:	6c8000ef          	jal	80005e1c <uartputc_sync>
    80005758:	b7d5                	j	8000573c <consputc+0x14>

000000008000575a <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000575a:	1101                	addi	sp,sp,-32
    8000575c:	ec06                	sd	ra,24(sp)
    8000575e:	e822                	sd	s0,16(sp)
    80005760:	e426                	sd	s1,8(sp)
    80005762:	1000                	addi	s0,sp,32
    80005764:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005766:	0001c517          	auipc	a0,0x1c
    8000576a:	69a50513          	addi	a0,a0,1690 # 80021e00 <cons>
    8000576e:	027000ef          	jal	80005f94 <acquire>

  switch(c){
    80005772:	47d5                	li	a5,21
    80005774:	08f48d63          	beq	s1,a5,8000580e <consoleintr+0xb4>
    80005778:	0297c563          	blt	a5,s1,800057a2 <consoleintr+0x48>
    8000577c:	47a1                	li	a5,8
    8000577e:	0ef48263          	beq	s1,a5,80005862 <consoleintr+0x108>
    80005782:	47c1                	li	a5,16
    80005784:	10f49363          	bne	s1,a5,8000588a <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    80005788:	846fc0ef          	jal	800017ce <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    8000578c:	0001c517          	auipc	a0,0x1c
    80005790:	67450513          	addi	a0,a0,1652 # 80021e00 <cons>
    80005794:	095000ef          	jal	80006028 <release>
}
    80005798:	60e2                	ld	ra,24(sp)
    8000579a:	6442                	ld	s0,16(sp)
    8000579c:	64a2                	ld	s1,8(sp)
    8000579e:	6105                	addi	sp,sp,32
    800057a0:	8082                	ret
  switch(c){
    800057a2:	07f00793          	li	a5,127
    800057a6:	0af48e63          	beq	s1,a5,80005862 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800057aa:	0001c717          	auipc	a4,0x1c
    800057ae:	65670713          	addi	a4,a4,1622 # 80021e00 <cons>
    800057b2:	0a072783          	lw	a5,160(a4)
    800057b6:	09872703          	lw	a4,152(a4)
    800057ba:	9f99                	subw	a5,a5,a4
    800057bc:	07f00713          	li	a4,127
    800057c0:	fcf766e3          	bltu	a4,a5,8000578c <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800057c4:	47b5                	li	a5,13
    800057c6:	0cf48563          	beq	s1,a5,80005890 <consoleintr+0x136>
      consputc(c);
    800057ca:	8526                	mv	a0,s1
    800057cc:	f5dff0ef          	jal	80005728 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800057d0:	0001c717          	auipc	a4,0x1c
    800057d4:	63070713          	addi	a4,a4,1584 # 80021e00 <cons>
    800057d8:	0a072683          	lw	a3,160(a4)
    800057dc:	0016879b          	addiw	a5,a3,1
    800057e0:	863e                	mv	a2,a5
    800057e2:	0af72023          	sw	a5,160(a4)
    800057e6:	07f6f693          	andi	a3,a3,127
    800057ea:	9736                	add	a4,a4,a3
    800057ec:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800057f0:	ff648713          	addi	a4,s1,-10
    800057f4:	c371                	beqz	a4,800058b8 <consoleintr+0x15e>
    800057f6:	14f1                	addi	s1,s1,-4
    800057f8:	c0e1                	beqz	s1,800058b8 <consoleintr+0x15e>
    800057fa:	0001c717          	auipc	a4,0x1c
    800057fe:	69e72703          	lw	a4,1694(a4) # 80021e98 <cons+0x98>
    80005802:	9f99                	subw	a5,a5,a4
    80005804:	08000713          	li	a4,128
    80005808:	f8e792e3          	bne	a5,a4,8000578c <consoleintr+0x32>
    8000580c:	a075                	j	800058b8 <consoleintr+0x15e>
    8000580e:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005810:	0001c717          	auipc	a4,0x1c
    80005814:	5f070713          	addi	a4,a4,1520 # 80021e00 <cons>
    80005818:	0a072783          	lw	a5,160(a4)
    8000581c:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005820:	0001c497          	auipc	s1,0x1c
    80005824:	5e048493          	addi	s1,s1,1504 # 80021e00 <cons>
    while(cons.e != cons.w &&
    80005828:	4929                	li	s2,10
    8000582a:	02f70863          	beq	a4,a5,8000585a <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    8000582e:	37fd                	addiw	a5,a5,-1
    80005830:	07f7f713          	andi	a4,a5,127
    80005834:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005836:	01874703          	lbu	a4,24(a4)
    8000583a:	03270263          	beq	a4,s2,8000585e <consoleintr+0x104>
      cons.e--;
    8000583e:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005842:	10000513          	li	a0,256
    80005846:	ee3ff0ef          	jal	80005728 <consputc>
    while(cons.e != cons.w &&
    8000584a:	0a04a783          	lw	a5,160(s1)
    8000584e:	09c4a703          	lw	a4,156(s1)
    80005852:	fcf71ee3          	bne	a4,a5,8000582e <consoleintr+0xd4>
    80005856:	6902                	ld	s2,0(sp)
    80005858:	bf15                	j	8000578c <consoleintr+0x32>
    8000585a:	6902                	ld	s2,0(sp)
    8000585c:	bf05                	j	8000578c <consoleintr+0x32>
    8000585e:	6902                	ld	s2,0(sp)
    80005860:	b735                	j	8000578c <consoleintr+0x32>
    if(cons.e != cons.w){
    80005862:	0001c717          	auipc	a4,0x1c
    80005866:	59e70713          	addi	a4,a4,1438 # 80021e00 <cons>
    8000586a:	0a072783          	lw	a5,160(a4)
    8000586e:	09c72703          	lw	a4,156(a4)
    80005872:	f0f70de3          	beq	a4,a5,8000578c <consoleintr+0x32>
      cons.e--;
    80005876:	37fd                	addiw	a5,a5,-1
    80005878:	0001c717          	auipc	a4,0x1c
    8000587c:	62f72423          	sw	a5,1576(a4) # 80021ea0 <cons+0xa0>
      consputc(BACKSPACE);
    80005880:	10000513          	li	a0,256
    80005884:	ea5ff0ef          	jal	80005728 <consputc>
    80005888:	b711                	j	8000578c <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000588a:	f00481e3          	beqz	s1,8000578c <consoleintr+0x32>
    8000588e:	bf31                	j	800057aa <consoleintr+0x50>
      consputc(c);
    80005890:	4529                	li	a0,10
    80005892:	e97ff0ef          	jal	80005728 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005896:	0001c797          	auipc	a5,0x1c
    8000589a:	56a78793          	addi	a5,a5,1386 # 80021e00 <cons>
    8000589e:	0a07a703          	lw	a4,160(a5)
    800058a2:	0017069b          	addiw	a3,a4,1
    800058a6:	8636                	mv	a2,a3
    800058a8:	0ad7a023          	sw	a3,160(a5)
    800058ac:	07f77713          	andi	a4,a4,127
    800058b0:	97ba                	add	a5,a5,a4
    800058b2:	4729                	li	a4,10
    800058b4:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800058b8:	0001c797          	auipc	a5,0x1c
    800058bc:	5ec7a223          	sw	a2,1508(a5) # 80021e9c <cons+0x9c>
        wakeup(&cons.r);
    800058c0:	0001c517          	auipc	a0,0x1c
    800058c4:	5d850513          	addi	a0,a0,1496 # 80021e98 <cons+0x98>
    800058c8:	b65fb0ef          	jal	8000142c <wakeup>
    800058cc:	b5c1                	j	8000578c <consoleintr+0x32>

00000000800058ce <consoleinit>:

void
consoleinit(void)
{
    800058ce:	1141                	addi	sp,sp,-16
    800058d0:	e406                	sd	ra,8(sp)
    800058d2:	e022                	sd	s0,0(sp)
    800058d4:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800058d6:	00003597          	auipc	a1,0x3
    800058da:	e8a58593          	addi	a1,a1,-374 # 80008760 <etext+0x760>
    800058de:	0001c517          	auipc	a0,0x1c
    800058e2:	52250513          	addi	a0,a0,1314 # 80021e00 <cons>
    800058e6:	624000ef          	jal	80005f0a <initlock>

  uartinit();
    800058ea:	448000ef          	jal	80005d32 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800058ee:	00013797          	auipc	a5,0x13
    800058f2:	13a78793          	addi	a5,a5,314 # 80018a28 <devsw>
    800058f6:	00000717          	auipc	a4,0x0
    800058fa:	d2e70713          	addi	a4,a4,-722 # 80005624 <consoleread>
    800058fe:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005900:	00000717          	auipc	a4,0x0
    80005904:	c8270713          	addi	a4,a4,-894 # 80005582 <consolewrite>
    80005908:	ef98                	sd	a4,24(a5)
}
    8000590a:	60a2                	ld	ra,8(sp)
    8000590c:	6402                	ld	s0,0(sp)
    8000590e:	0141                	addi	sp,sp,16
    80005910:	8082                	ret

0000000080005912 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005912:	7139                	addi	sp,sp,-64
    80005914:	fc06                	sd	ra,56(sp)
    80005916:	f822                	sd	s0,48(sp)
    80005918:	f04a                	sd	s2,32(sp)
    8000591a:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    8000591c:	c219                	beqz	a2,80005922 <printint+0x10>
    8000591e:	08054163          	bltz	a0,800059a0 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005922:	4301                	li	t1,0

  i = 0;
    80005924:	fc840913          	addi	s2,s0,-56
    x = xx;
    80005928:	86ca                	mv	a3,s2
  i = 0;
    8000592a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000592c:	00003817          	auipc	a6,0x3
    80005930:	fe480813          	addi	a6,a6,-28 # 80008910 <digits>
    80005934:	88ba                	mv	a7,a4
    80005936:	0017061b          	addiw	a2,a4,1
    8000593a:	8732                	mv	a4,a2
    8000593c:	02b577b3          	remu	a5,a0,a1
    80005940:	97c2                	add	a5,a5,a6
    80005942:	0007c783          	lbu	a5,0(a5)
    80005946:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000594a:	87aa                	mv	a5,a0
    8000594c:	02b55533          	divu	a0,a0,a1
    80005950:	0685                	addi	a3,a3,1
    80005952:	feb7f1e3          	bgeu	a5,a1,80005934 <printint+0x22>

  if(sign)
    80005956:	00030c63          	beqz	t1,8000596e <printint+0x5c>
    buf[i++] = '-';
    8000595a:	fe060793          	addi	a5,a2,-32 # fe0 <_entry-0x7ffff020>
    8000595e:	00878633          	add	a2,a5,s0
    80005962:	02d00793          	li	a5,45
    80005966:	fef60423          	sb	a5,-24(a2)
    8000596a:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    8000596e:	02e05463          	blez	a4,80005996 <printint+0x84>
    80005972:	f426                	sd	s1,40(sp)
    80005974:	377d                	addiw	a4,a4,-1
    80005976:	00e904b3          	add	s1,s2,a4
    8000597a:	197d                	addi	s2,s2,-1
    8000597c:	993a                	add	s2,s2,a4
    8000597e:	1702                	slli	a4,a4,0x20
    80005980:	9301                	srli	a4,a4,0x20
    80005982:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005986:	0004c503          	lbu	a0,0(s1)
    8000598a:	d9fff0ef          	jal	80005728 <consputc>
  while(--i >= 0)
    8000598e:	14fd                	addi	s1,s1,-1
    80005990:	ff249be3          	bne	s1,s2,80005986 <printint+0x74>
    80005994:	74a2                	ld	s1,40(sp)
}
    80005996:	70e2                	ld	ra,56(sp)
    80005998:	7442                	ld	s0,48(sp)
    8000599a:	7902                	ld	s2,32(sp)
    8000599c:	6121                	addi	sp,sp,64
    8000599e:	8082                	ret
    x = -xx;
    800059a0:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800059a4:	4305                	li	t1,1
    x = -xx;
    800059a6:	bfbd                	j	80005924 <printint+0x12>

00000000800059a8 <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800059a8:	7131                	addi	sp,sp,-192
    800059aa:	fc86                	sd	ra,120(sp)
    800059ac:	f8a2                	sd	s0,112(sp)
    800059ae:	f0ca                	sd	s2,96(sp)
    800059b0:	0100                	addi	s0,sp,128
    800059b2:	892a                	mv	s2,a0
    800059b4:	e40c                	sd	a1,8(s0)
    800059b6:	e810                	sd	a2,16(s0)
    800059b8:	ec14                	sd	a3,24(s0)
    800059ba:	f018                	sd	a4,32(s0)
    800059bc:	f41c                	sd	a5,40(s0)
    800059be:	03043823          	sd	a6,48(s0)
    800059c2:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    800059c6:	00003797          	auipc	a5,0x3
    800059ca:	fbe7a783          	lw	a5,-66(a5) # 80008984 <panicking>
    800059ce:	cf9d                	beqz	a5,80005a0c <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800059d0:	00840793          	addi	a5,s0,8
    800059d4:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800059d8:	00094503          	lbu	a0,0(s2)
    800059dc:	22050663          	beqz	a0,80005c08 <printf+0x260>
    800059e0:	f4a6                	sd	s1,104(sp)
    800059e2:	ecce                	sd	s3,88(sp)
    800059e4:	e8d2                	sd	s4,80(sp)
    800059e6:	e4d6                	sd	s5,72(sp)
    800059e8:	e0da                	sd	s6,64(sp)
    800059ea:	fc5e                	sd	s7,56(sp)
    800059ec:	f862                	sd	s8,48(sp)
    800059ee:	f06a                	sd	s10,32(sp)
    800059f0:	ec6e                	sd	s11,24(sp)
    800059f2:	4a01                	li	s4,0
    if(cx != '%'){
    800059f4:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800059f8:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800059fc:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005a00:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80005a04:	4b29                	li	s6,10
    if(c0 == 'd'){
    80005a06:	06400b93          	li	s7,100
    80005a0a:	a015                	j	80005a2e <printf+0x86>
    acquire(&pr.lock);
    80005a0c:	0001c517          	auipc	a0,0x1c
    80005a10:	49c50513          	addi	a0,a0,1180 # 80021ea8 <pr>
    80005a14:	580000ef          	jal	80005f94 <acquire>
    80005a18:	bf65                	j	800059d0 <printf+0x28>
      consputc(cx);
    80005a1a:	d0fff0ef          	jal	80005728 <consputc>
      continue;
    80005a1e:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005a20:	2485                	addiw	s1,s1,1
    80005a22:	8a26                	mv	s4,s1
    80005a24:	94ca                	add	s1,s1,s2
    80005a26:	0004c503          	lbu	a0,0(s1)
    80005a2a:	1c050663          	beqz	a0,80005bf6 <printf+0x24e>
    if(cx != '%'){
    80005a2e:	ff3516e3          	bne	a0,s3,80005a1a <printf+0x72>
    i++;
    80005a32:	001a079b          	addiw	a5,s4,1
    80005a36:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    80005a38:	00f90733          	add	a4,s2,a5
    80005a3c:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005a40:	200a8963          	beqz	s5,80005c52 <printf+0x2aa>
    80005a44:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    80005a48:	1e068c63          	beqz	a3,80005c40 <printf+0x298>
    if(c0 == 'd'){
    80005a4c:	037a8863          	beq	s5,s7,80005a7c <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005a50:	f94a8713          	addi	a4,s5,-108
    80005a54:	00173713          	seqz	a4,a4
    80005a58:	f9c68613          	addi	a2,a3,-100
    80005a5c:	ee05                	bnez	a2,80005a94 <printf+0xec>
    80005a5e:	cb1d                	beqz	a4,80005a94 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    80005a60:	f8843783          	ld	a5,-120(s0)
    80005a64:	00878713          	addi	a4,a5,8
    80005a68:	f8e43423          	sd	a4,-120(s0)
    80005a6c:	4605                	li	a2,1
    80005a6e:	85da                	mv	a1,s6
    80005a70:	6388                	ld	a0,0(a5)
    80005a72:	ea1ff0ef          	jal	80005912 <printint>
      i += 1;
    80005a76:	002a049b          	addiw	s1,s4,2
    80005a7a:	b75d                	j	80005a20 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    80005a7c:	f8843783          	ld	a5,-120(s0)
    80005a80:	00878713          	addi	a4,a5,8
    80005a84:	f8e43423          	sd	a4,-120(s0)
    80005a88:	4605                	li	a2,1
    80005a8a:	85da                	mv	a1,s6
    80005a8c:	4388                	lw	a0,0(a5)
    80005a8e:	e85ff0ef          	jal	80005912 <printint>
    80005a92:	b779                	j	80005a20 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    80005a94:	97ca                	add	a5,a5,s2
    80005a96:	8636                	mv	a2,a3
    80005a98:	0027c683          	lbu	a3,2(a5)
    80005a9c:	a2c9                	j	80005c5e <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005a9e:	f8843783          	ld	a5,-120(s0)
    80005aa2:	00878713          	addi	a4,a5,8
    80005aa6:	f8e43423          	sd	a4,-120(s0)
    80005aaa:	4605                	li	a2,1
    80005aac:	45a9                	li	a1,10
    80005aae:	6388                	ld	a0,0(a5)
    80005ab0:	e63ff0ef          	jal	80005912 <printint>
      i += 2;
    80005ab4:	003a049b          	addiw	s1,s4,3
    80005ab8:	b7a5                	j	80005a20 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    80005aba:	f8843783          	ld	a5,-120(s0)
    80005abe:	00878713          	addi	a4,a5,8
    80005ac2:	f8e43423          	sd	a4,-120(s0)
    80005ac6:	4601                	li	a2,0
    80005ac8:	85da                	mv	a1,s6
    80005aca:	0007e503          	lwu	a0,0(a5)
    80005ace:	e45ff0ef          	jal	80005912 <printint>
    80005ad2:	b7b9                	j	80005a20 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005ad4:	f8843783          	ld	a5,-120(s0)
    80005ad8:	00878713          	addi	a4,a5,8
    80005adc:	f8e43423          	sd	a4,-120(s0)
    80005ae0:	4601                	li	a2,0
    80005ae2:	85da                	mv	a1,s6
    80005ae4:	6388                	ld	a0,0(a5)
    80005ae6:	e2dff0ef          	jal	80005912 <printint>
      i += 1;
    80005aea:	002a049b          	addiw	s1,s4,2
    80005aee:	bf0d                	j	80005a20 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005af0:	f8843783          	ld	a5,-120(s0)
    80005af4:	00878713          	addi	a4,a5,8
    80005af8:	f8e43423          	sd	a4,-120(s0)
    80005afc:	4601                	li	a2,0
    80005afe:	45a9                	li	a1,10
    80005b00:	6388                	ld	a0,0(a5)
    80005b02:	e11ff0ef          	jal	80005912 <printint>
      i += 2;
    80005b06:	003a049b          	addiw	s1,s4,3
    80005b0a:	bf19                	j	80005a20 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005b0c:	f8843783          	ld	a5,-120(s0)
    80005b10:	00878713          	addi	a4,a5,8
    80005b14:	f8e43423          	sd	a4,-120(s0)
    80005b18:	4601                	li	a2,0
    80005b1a:	45c1                	li	a1,16
    80005b1c:	0007e503          	lwu	a0,0(a5)
    80005b20:	df3ff0ef          	jal	80005912 <printint>
    80005b24:	bdf5                	j	80005a20 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005b26:	f8843783          	ld	a5,-120(s0)
    80005b2a:	00878713          	addi	a4,a5,8
    80005b2e:	f8e43423          	sd	a4,-120(s0)
    80005b32:	45c1                	li	a1,16
    80005b34:	6388                	ld	a0,0(a5)
    80005b36:	dddff0ef          	jal	80005912 <printint>
      i += 1;
    80005b3a:	002a049b          	addiw	s1,s4,2
    80005b3e:	b5cd                	j	80005a20 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005b40:	f8843783          	ld	a5,-120(s0)
    80005b44:	00878713          	addi	a4,a5,8
    80005b48:	f8e43423          	sd	a4,-120(s0)
    80005b4c:	4601                	li	a2,0
    80005b4e:	45c1                	li	a1,16
    80005b50:	6388                	ld	a0,0(a5)
    80005b52:	dc1ff0ef          	jal	80005912 <printint>
      i += 2;
    80005b56:	003a049b          	addiw	s1,s4,3
    80005b5a:	b5d9                	j	80005a20 <printf+0x78>
    80005b5c:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    80005b5e:	f8843783          	ld	a5,-120(s0)
    80005b62:	00878713          	addi	a4,a5,8
    80005b66:	f8e43423          	sd	a4,-120(s0)
    80005b6a:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80005b6e:	03000513          	li	a0,48
    80005b72:	bb7ff0ef          	jal	80005728 <consputc>
  consputc('x');
    80005b76:	07800513          	li	a0,120
    80005b7a:	bafff0ef          	jal	80005728 <consputc>
    80005b7e:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005b80:	00003c97          	auipc	s9,0x3
    80005b84:	d90c8c93          	addi	s9,s9,-624 # 80008910 <digits>
    80005b88:	03cad793          	srli	a5,s5,0x3c
    80005b8c:	97e6                	add	a5,a5,s9
    80005b8e:	0007c503          	lbu	a0,0(a5)
    80005b92:	b97ff0ef          	jal	80005728 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005b96:	0a92                	slli	s5,s5,0x4
    80005b98:	3a7d                	addiw	s4,s4,-1
    80005b9a:	fe0a17e3          	bnez	s4,80005b88 <printf+0x1e0>
    80005b9e:	7ca2                	ld	s9,40(sp)
    80005ba0:	b541                	j	80005a20 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80005ba2:	f8843783          	ld	a5,-120(s0)
    80005ba6:	00878713          	addi	a4,a5,8
    80005baa:	f8e43423          	sd	a4,-120(s0)
    80005bae:	4388                	lw	a0,0(a5)
    80005bb0:	b79ff0ef          	jal	80005728 <consputc>
    80005bb4:	b5b5                	j	80005a20 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80005bb6:	f8843783          	ld	a5,-120(s0)
    80005bba:	00878713          	addi	a4,a5,8
    80005bbe:	f8e43423          	sd	a4,-120(s0)
    80005bc2:	0007ba03          	ld	s4,0(a5)
    80005bc6:	000a0d63          	beqz	s4,80005be0 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    80005bca:	000a4503          	lbu	a0,0(s4)
    80005bce:	e40509e3          	beqz	a0,80005a20 <printf+0x78>
        consputc(*s);
    80005bd2:	b57ff0ef          	jal	80005728 <consputc>
      for(; *s; s++)
    80005bd6:	0a05                	addi	s4,s4,1
    80005bd8:	000a4503          	lbu	a0,0(s4)
    80005bdc:	f97d                	bnez	a0,80005bd2 <printf+0x22a>
    80005bde:	b589                	j	80005a20 <printf+0x78>
        s = "(null)";
    80005be0:	00003a17          	auipc	s4,0x3
    80005be4:	b88a0a13          	addi	s4,s4,-1144 # 80008768 <etext+0x768>
      for(; *s; s++)
    80005be8:	02800513          	li	a0,40
    80005bec:	b7dd                	j	80005bd2 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005bee:	8556                	mv	a0,s5
    80005bf0:	b39ff0ef          	jal	80005728 <consputc>
    80005bf4:	b535                	j	80005a20 <printf+0x78>
    80005bf6:	74a6                	ld	s1,104(sp)
    80005bf8:	69e6                	ld	s3,88(sp)
    80005bfa:	6a46                	ld	s4,80(sp)
    80005bfc:	6aa6                	ld	s5,72(sp)
    80005bfe:	6b06                	ld	s6,64(sp)
    80005c00:	7be2                	ld	s7,56(sp)
    80005c02:	7c42                	ld	s8,48(sp)
    80005c04:	7d02                	ld	s10,32(sp)
    80005c06:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    80005c08:	00003797          	auipc	a5,0x3
    80005c0c:	d7c7a783          	lw	a5,-644(a5) # 80008984 <panicking>
    80005c10:	c38d                	beqz	a5,80005c32 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80005c12:	4501                	li	a0,0
    80005c14:	70e6                	ld	ra,120(sp)
    80005c16:	7446                	ld	s0,112(sp)
    80005c18:	7906                	ld	s2,96(sp)
    80005c1a:	6129                	addi	sp,sp,192
    80005c1c:	8082                	ret
    80005c1e:	74a6                	ld	s1,104(sp)
    80005c20:	69e6                	ld	s3,88(sp)
    80005c22:	6a46                	ld	s4,80(sp)
    80005c24:	6aa6                	ld	s5,72(sp)
    80005c26:	6b06                	ld	s6,64(sp)
    80005c28:	7be2                	ld	s7,56(sp)
    80005c2a:	7c42                	ld	s8,48(sp)
    80005c2c:	7d02                	ld	s10,32(sp)
    80005c2e:	6de2                	ld	s11,24(sp)
    80005c30:	bfe1                	j	80005c08 <printf+0x260>
    release(&pr.lock);
    80005c32:	0001c517          	auipc	a0,0x1c
    80005c36:	27650513          	addi	a0,a0,630 # 80021ea8 <pr>
    80005c3a:	3ee000ef          	jal	80006028 <release>
  return 0;
    80005c3e:	bfd1                	j	80005c12 <printf+0x26a>
    if(c0 == 'd'){
    80005c40:	e37a8ee3          	beq	s5,s7,80005a7c <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005c44:	f94a8713          	addi	a4,s5,-108
    80005c48:	00173713          	seqz	a4,a4
    80005c4c:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005c4e:	4781                	li	a5,0
    80005c50:	a00d                	j	80005c72 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    80005c52:	f94a8713          	addi	a4,s5,-108
    80005c56:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    80005c5a:	8656                	mv	a2,s5
    80005c5c:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005c5e:	f9460793          	addi	a5,a2,-108
    80005c62:	0017b793          	seqz	a5,a5
    80005c66:	8ff9                	and	a5,a5,a4
    80005c68:	f9c68593          	addi	a1,a3,-100
    80005c6c:	e199                	bnez	a1,80005c72 <printf+0x2ca>
    80005c6e:	e20798e3          	bnez	a5,80005a9e <printf+0xf6>
    } else if(c0 == 'u'){
    80005c72:	e58a84e3          	beq	s5,s8,80005aba <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    80005c76:	f8b60593          	addi	a1,a2,-117
    80005c7a:	e199                	bnez	a1,80005c80 <printf+0x2d8>
    80005c7c:	e4071ce3          	bnez	a4,80005ad4 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005c80:	f8b68593          	addi	a1,a3,-117
    80005c84:	e199                	bnez	a1,80005c8a <printf+0x2e2>
    80005c86:	e60795e3          	bnez	a5,80005af0 <printf+0x148>
    } else if(c0 == 'x'){
    80005c8a:	e9aa81e3          	beq	s5,s10,80005b0c <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    80005c8e:	f8860613          	addi	a2,a2,-120
    80005c92:	e219                	bnez	a2,80005c98 <printf+0x2f0>
    80005c94:	e80719e3          	bnez	a4,80005b26 <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005c98:	f8868693          	addi	a3,a3,-120
    80005c9c:	e299                	bnez	a3,80005ca2 <printf+0x2fa>
    80005c9e:	ea0791e3          	bnez	a5,80005b40 <printf+0x198>
    } else if(c0 == 'p'){
    80005ca2:	ebba8de3          	beq	s5,s11,80005b5c <printf+0x1b4>
    } else if(c0 == 'c'){
    80005ca6:	06300793          	li	a5,99
    80005caa:	eefa8ce3          	beq	s5,a5,80005ba2 <printf+0x1fa>
    } else if(c0 == 's'){
    80005cae:	07300793          	li	a5,115
    80005cb2:	f0fa82e3          	beq	s5,a5,80005bb6 <printf+0x20e>
    } else if(c0 == '%'){
    80005cb6:	02500793          	li	a5,37
    80005cba:	f2fa8ae3          	beq	s5,a5,80005bee <printf+0x246>
    } else if(c0 == 0){
    80005cbe:	f60a80e3          	beqz	s5,80005c1e <printf+0x276>
      consputc('%');
    80005cc2:	02500513          	li	a0,37
    80005cc6:	a63ff0ef          	jal	80005728 <consputc>
      consputc(c0);
    80005cca:	8556                	mv	a0,s5
    80005ccc:	a5dff0ef          	jal	80005728 <consputc>
    80005cd0:	bb81                	j	80005a20 <printf+0x78>

0000000080005cd2 <panic>:

void
panic(char *s)
{
    80005cd2:	1101                	addi	sp,sp,-32
    80005cd4:	ec06                	sd	ra,24(sp)
    80005cd6:	e822                	sd	s0,16(sp)
    80005cd8:	e426                	sd	s1,8(sp)
    80005cda:	e04a                	sd	s2,0(sp)
    80005cdc:	1000                	addi	s0,sp,32
    80005cde:	892a                	mv	s2,a0
  panicking = 1;
    80005ce0:	4485                	li	s1,1
    80005ce2:	00003797          	auipc	a5,0x3
    80005ce6:	ca97a123          	sw	s1,-862(a5) # 80008984 <panicking>
  printf("panic: ");
    80005cea:	00003517          	auipc	a0,0x3
    80005cee:	a8650513          	addi	a0,a0,-1402 # 80008770 <etext+0x770>
    80005cf2:	cb7ff0ef          	jal	800059a8 <printf>
  printf("%s\n", s);
    80005cf6:	85ca                	mv	a1,s2
    80005cf8:	00003517          	auipc	a0,0x3
    80005cfc:	a8050513          	addi	a0,a0,-1408 # 80008778 <etext+0x778>
    80005d00:	ca9ff0ef          	jal	800059a8 <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005d04:	00003797          	auipc	a5,0x3
    80005d08:	c697ae23          	sw	s1,-900(a5) # 80008980 <panicked>
  for(;;)
    80005d0c:	a001                	j	80005d0c <panic+0x3a>

0000000080005d0e <printfinit>:
    ;
}

void
printfinit(void)
{
    80005d0e:	1141                	addi	sp,sp,-16
    80005d10:	e406                	sd	ra,8(sp)
    80005d12:	e022                	sd	s0,0(sp)
    80005d14:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005d16:	00003597          	auipc	a1,0x3
    80005d1a:	a6a58593          	addi	a1,a1,-1430 # 80008780 <etext+0x780>
    80005d1e:	0001c517          	auipc	a0,0x1c
    80005d22:	18a50513          	addi	a0,a0,394 # 80021ea8 <pr>
    80005d26:	1e4000ef          	jal	80005f0a <initlock>
}
    80005d2a:	60a2                	ld	ra,8(sp)
    80005d2c:	6402                	ld	s0,0(sp)
    80005d2e:	0141                	addi	sp,sp,16
    80005d30:	8082                	ret

0000000080005d32 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005d32:	1141                	addi	sp,sp,-16
    80005d34:	e406                	sd	ra,8(sp)
    80005d36:	e022                	sd	s0,0(sp)
    80005d38:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005d3a:	100007b7          	lui	a5,0x10000
    80005d3e:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005d42:	10000737          	lui	a4,0x10000
    80005d46:	f8000693          	li	a3,-128
    80005d4a:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005d4e:	468d                	li	a3,3
    80005d50:	10000637          	lui	a2,0x10000
    80005d54:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005d58:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005d5c:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005d60:	8732                	mv	a4,a2
    80005d62:	461d                	li	a2,7
    80005d64:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005d68:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005d6c:	00003597          	auipc	a1,0x3
    80005d70:	a1c58593          	addi	a1,a1,-1508 # 80008788 <etext+0x788>
    80005d74:	0001c517          	auipc	a0,0x1c
    80005d78:	14c50513          	addi	a0,a0,332 # 80021ec0 <tx_lock>
    80005d7c:	18e000ef          	jal	80005f0a <initlock>
}
    80005d80:	60a2                	ld	ra,8(sp)
    80005d82:	6402                	ld	s0,0(sp)
    80005d84:	0141                	addi	sp,sp,16
    80005d86:	8082                	ret

0000000080005d88 <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005d88:	715d                	addi	sp,sp,-80
    80005d8a:	e486                	sd	ra,72(sp)
    80005d8c:	e0a2                	sd	s0,64(sp)
    80005d8e:	fc26                	sd	s1,56(sp)
    80005d90:	ec56                	sd	s5,24(sp)
    80005d92:	0880                	addi	s0,sp,80
    80005d94:	8aaa                	mv	s5,a0
    80005d96:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005d98:	0001c517          	auipc	a0,0x1c
    80005d9c:	12850513          	addi	a0,a0,296 # 80021ec0 <tx_lock>
    80005da0:	1f4000ef          	jal	80005f94 <acquire>

  int i = 0;
  while(i < n){ 
    80005da4:	06905063          	blez	s1,80005e04 <uartwrite+0x7c>
    80005da8:	f84a                	sd	s2,48(sp)
    80005daa:	f44e                	sd	s3,40(sp)
    80005dac:	f052                	sd	s4,32(sp)
    80005dae:	e85a                	sd	s6,16(sp)
    80005db0:	e45e                	sd	s7,8(sp)
    80005db2:	8a56                	mv	s4,s5
    80005db4:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005db6:	00003497          	auipc	s1,0x3
    80005dba:	bd648493          	addi	s1,s1,-1066 # 8000898c <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005dbe:	0001c997          	auipc	s3,0x1c
    80005dc2:	10298993          	addi	s3,s3,258 # 80021ec0 <tx_lock>
    80005dc6:	00003917          	auipc	s2,0x3
    80005dca:	bc290913          	addi	s2,s2,-1086 # 80008988 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005dce:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005dd2:	4b05                	li	s6,1
    80005dd4:	a005                	j	80005df4 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005dd6:	85ce                	mv	a1,s3
    80005dd8:	854a                	mv	a0,s2
    80005dda:	e06fb0ef          	jal	800013e0 <sleep>
    while(tx_busy != 0){
    80005dde:	409c                	lw	a5,0(s1)
    80005de0:	fbfd                	bnez	a5,80005dd6 <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005de2:	000a4783          	lbu	a5,0(s4)
    80005de6:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005dea:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005dee:	0a05                	addi	s4,s4,1
    80005df0:	015a0563          	beq	s4,s5,80005dfa <uartwrite+0x72>
    while(tx_busy != 0){
    80005df4:	409c                	lw	a5,0(s1)
    80005df6:	f3e5                	bnez	a5,80005dd6 <uartwrite+0x4e>
    80005df8:	b7ed                	j	80005de2 <uartwrite+0x5a>
    80005dfa:	7942                	ld	s2,48(sp)
    80005dfc:	79a2                	ld	s3,40(sp)
    80005dfe:	7a02                	ld	s4,32(sp)
    80005e00:	6b42                	ld	s6,16(sp)
    80005e02:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005e04:	0001c517          	auipc	a0,0x1c
    80005e08:	0bc50513          	addi	a0,a0,188 # 80021ec0 <tx_lock>
    80005e0c:	21c000ef          	jal	80006028 <release>
}
    80005e10:	60a6                	ld	ra,72(sp)
    80005e12:	6406                	ld	s0,64(sp)
    80005e14:	74e2                	ld	s1,56(sp)
    80005e16:	6ae2                	ld	s5,24(sp)
    80005e18:	6161                	addi	sp,sp,80
    80005e1a:	8082                	ret

0000000080005e1c <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e1c:	1101                	addi	sp,sp,-32
    80005e1e:	ec06                	sd	ra,24(sp)
    80005e20:	e822                	sd	s0,16(sp)
    80005e22:	e426                	sd	s1,8(sp)
    80005e24:	1000                	addi	s0,sp,32
    80005e26:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005e28:	00003797          	auipc	a5,0x3
    80005e2c:	b5c7a783          	lw	a5,-1188(a5) # 80008984 <panicking>
    80005e30:	cf95                	beqz	a5,80005e6c <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005e32:	00003797          	auipc	a5,0x3
    80005e36:	b4e7a783          	lw	a5,-1202(a5) # 80008980 <panicked>
    80005e3a:	ef85                	bnez	a5,80005e72 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e3c:	10000737          	lui	a4,0x10000
    80005e40:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005e42:	00074783          	lbu	a5,0(a4)
    80005e46:	0207f793          	andi	a5,a5,32
    80005e4a:	dfe5                	beqz	a5,80005e42 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005e4c:	0ff4f513          	zext.b	a0,s1
    80005e50:	100007b7          	lui	a5,0x10000
    80005e54:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005e58:	00003797          	auipc	a5,0x3
    80005e5c:	b2c7a783          	lw	a5,-1236(a5) # 80008984 <panicking>
    80005e60:	cb91                	beqz	a5,80005e74 <uartputc_sync+0x58>
    pop_off();
}
    80005e62:	60e2                	ld	ra,24(sp)
    80005e64:	6442                	ld	s0,16(sp)
    80005e66:	64a2                	ld	s1,8(sp)
    80005e68:	6105                	addi	sp,sp,32
    80005e6a:	8082                	ret
    push_off();
    80005e6c:	0e4000ef          	jal	80005f50 <push_off>
    80005e70:	b7c9                	j	80005e32 <uartputc_sync+0x16>
    for(;;)
    80005e72:	a001                	j	80005e72 <uartputc_sync+0x56>
    pop_off();
    80005e74:	164000ef          	jal	80005fd8 <pop_off>
}
    80005e78:	b7ed                	j	80005e62 <uartputc_sync+0x46>

0000000080005e7a <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005e7a:	1141                	addi	sp,sp,-16
    80005e7c:	e406                	sd	ra,8(sp)
    80005e7e:	e022                	sd	s0,0(sp)
    80005e80:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005e82:	100007b7          	lui	a5,0x10000
    80005e86:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005e8a:	8b85                	andi	a5,a5,1
    80005e8c:	cb89                	beqz	a5,80005e9e <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005e8e:	100007b7          	lui	a5,0x10000
    80005e92:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005e96:	60a2                	ld	ra,8(sp)
    80005e98:	6402                	ld	s0,0(sp)
    80005e9a:	0141                	addi	sp,sp,16
    80005e9c:	8082                	ret
    return -1;
    80005e9e:	557d                	li	a0,-1
    80005ea0:	bfdd                	j	80005e96 <uartgetc+0x1c>

0000000080005ea2 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005ea2:	1101                	addi	sp,sp,-32
    80005ea4:	ec06                	sd	ra,24(sp)
    80005ea6:	e822                	sd	s0,16(sp)
    80005ea8:	e426                	sd	s1,8(sp)
    80005eaa:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005eac:	100007b7          	lui	a5,0x10000
    80005eb0:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005eb4:	0001c517          	auipc	a0,0x1c
    80005eb8:	00c50513          	addi	a0,a0,12 # 80021ec0 <tx_lock>
    80005ebc:	0d8000ef          	jal	80005f94 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005ec0:	100007b7          	lui	a5,0x10000
    80005ec4:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005ec8:	0207f793          	andi	a5,a5,32
    80005ecc:	ef99                	bnez	a5,80005eea <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005ece:	0001c517          	auipc	a0,0x1c
    80005ed2:	ff250513          	addi	a0,a0,-14 # 80021ec0 <tx_lock>
    80005ed6:	152000ef          	jal	80006028 <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005eda:	54fd                	li	s1,-1
    int c = uartgetc();
    80005edc:	f9fff0ef          	jal	80005e7a <uartgetc>
    if(c == -1)
    80005ee0:	02950063          	beq	a0,s1,80005f00 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005ee4:	877ff0ef          	jal	8000575a <consoleintr>
  while(1){
    80005ee8:	bfd5                	j	80005edc <uartintr+0x3a>
    tx_busy = 0;
    80005eea:	00003797          	auipc	a5,0x3
    80005eee:	aa07a123          	sw	zero,-1374(a5) # 8000898c <tx_busy>
    wakeup(&tx_chan);
    80005ef2:	00003517          	auipc	a0,0x3
    80005ef6:	a9650513          	addi	a0,a0,-1386 # 80008988 <tx_chan>
    80005efa:	d32fb0ef          	jal	8000142c <wakeup>
    80005efe:	bfc1                	j	80005ece <uartintr+0x2c>
  }
}
    80005f00:	60e2                	ld	ra,24(sp)
    80005f02:	6442                	ld	s0,16(sp)
    80005f04:	64a2                	ld	s1,8(sp)
    80005f06:	6105                	addi	sp,sp,32
    80005f08:	8082                	ret

0000000080005f0a <initlock>:
}
#endif

void
initlock(struct spinlock *lk, char *name)
{
    80005f0a:	1141                	addi	sp,sp,-16
    80005f0c:	e406                	sd	ra,8(sp)
    80005f0e:	e022                	sd	s0,0(sp)
    80005f10:	0800                	addi	s0,sp,16
  lk->name = name;
    80005f12:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005f14:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005f18:	00053823          	sd	zero,16(a0)
#ifdef LAB_LOCK
  lk->nts = 0;
  lk->n = 0;
  findslot(lk);
#endif  
}
    80005f1c:	60a2                	ld	ra,8(sp)
    80005f1e:	6402                	ld	s0,0(sp)
    80005f20:	0141                	addi	sp,sp,16
    80005f22:	8082                	ret

0000000080005f24 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005f24:	411c                	lw	a5,0(a0)
    80005f26:	e399                	bnez	a5,80005f2c <holding+0x8>
    80005f28:	4501                	li	a0,0
  return r;
}
    80005f2a:	8082                	ret
{
    80005f2c:	1101                	addi	sp,sp,-32
    80005f2e:	ec06                	sd	ra,24(sp)
    80005f30:	e822                	sd	s0,16(sp)
    80005f32:	e426                	sd	s1,8(sp)
    80005f34:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005f36:	691c                	ld	a5,16(a0)
    80005f38:	84be                	mv	s1,a5
    80005f3a:	e89fa0ef          	jal	80000dc2 <mycpu>
    80005f3e:	40a48533          	sub	a0,s1,a0
    80005f42:	00153513          	seqz	a0,a0
}
    80005f46:	60e2                	ld	ra,24(sp)
    80005f48:	6442                	ld	s0,16(sp)
    80005f4a:	64a2                	ld	s1,8(sp)
    80005f4c:	6105                	addi	sp,sp,32
    80005f4e:	8082                	ret

0000000080005f50 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005f50:	1101                	addi	sp,sp,-32
    80005f52:	ec06                	sd	ra,24(sp)
    80005f54:	e822                	sd	s0,16(sp)
    80005f56:	e426                	sd	s1,8(sp)
    80005f58:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005f5a:	100027f3          	csrr	a5,sstatus
    80005f5e:	84be                	mv	s1,a5
    80005f60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005f64:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005f66:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005f6a:	e59fa0ef          	jal	80000dc2 <mycpu>
    80005f6e:	5d3c                	lw	a5,120(a0)
    80005f70:	cb99                	beqz	a5,80005f86 <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005f72:	e51fa0ef          	jal	80000dc2 <mycpu>
    80005f76:	5d3c                	lw	a5,120(a0)
    80005f78:	2785                	addiw	a5,a5,1
    80005f7a:	dd3c                	sw	a5,120(a0)
}
    80005f7c:	60e2                	ld	ra,24(sp)
    80005f7e:	6442                	ld	s0,16(sp)
    80005f80:	64a2                	ld	s1,8(sp)
    80005f82:	6105                	addi	sp,sp,32
    80005f84:	8082                	ret
    mycpu()->intena = old;
    80005f86:	e3dfa0ef          	jal	80000dc2 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005f8a:	0014d793          	srli	a5,s1,0x1
    80005f8e:	8b85                	andi	a5,a5,1
    80005f90:	dd7c                	sw	a5,124(a0)
    80005f92:	b7c5                	j	80005f72 <push_off+0x22>

0000000080005f94 <acquire>:
{
    80005f94:	1101                	addi	sp,sp,-32
    80005f96:	ec06                	sd	ra,24(sp)
    80005f98:	e822                	sd	s0,16(sp)
    80005f9a:	e426                	sd	s1,8(sp)
    80005f9c:	1000                	addi	s0,sp,32
    80005f9e:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005fa0:	fb1ff0ef          	jal	80005f50 <push_off>
  if(holding(lk))
    80005fa4:	8526                	mv	a0,s1
    80005fa6:	f7fff0ef          	jal	80005f24 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80005faa:	4705                	li	a4,1
  if(holding(lk))
    80005fac:	e105                	bnez	a0,80005fcc <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0) {
    80005fae:	87ba                	mv	a5,a4
    80005fb0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005fb4:	2781                	sext.w	a5,a5
    80005fb6:	ffe5                	bnez	a5,80005fae <acquire+0x1a>
  __sync_synchronize();
    80005fb8:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005fbc:	e07fa0ef          	jal	80000dc2 <mycpu>
    80005fc0:	e888                	sd	a0,16(s1)
}
    80005fc2:	60e2                	ld	ra,24(sp)
    80005fc4:	6442                	ld	s0,16(sp)
    80005fc6:	64a2                	ld	s1,8(sp)
    80005fc8:	6105                	addi	sp,sp,32
    80005fca:	8082                	ret
    panic("acquire");
    80005fcc:	00002517          	auipc	a0,0x2
    80005fd0:	7c450513          	addi	a0,a0,1988 # 80008790 <etext+0x790>
    80005fd4:	cffff0ef          	jal	80005cd2 <panic>

0000000080005fd8 <pop_off>:

void
pop_off(void)
{
    80005fd8:	1141                	addi	sp,sp,-16
    80005fda:	e406                	sd	ra,8(sp)
    80005fdc:	e022                	sd	s0,0(sp)
    80005fde:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005fe0:	de3fa0ef          	jal	80000dc2 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005fe4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005fe8:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005fea:	e39d                	bnez	a5,80006010 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005fec:	5d3c                	lw	a5,120(a0)
    80005fee:	02f05763          	blez	a5,8000601c <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005ff2:	37fd                	addiw	a5,a5,-1
    80005ff4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005ff6:	eb89                	bnez	a5,80006008 <pop_off+0x30>
    80005ff8:	5d7c                	lw	a5,124(a0)
    80005ffa:	c799                	beqz	a5,80006008 <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005ffc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006000:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006004:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006008:	60a2                	ld	ra,8(sp)
    8000600a:	6402                	ld	s0,0(sp)
    8000600c:	0141                	addi	sp,sp,16
    8000600e:	8082                	ret
    panic("pop_off - interruptible");
    80006010:	00002517          	auipc	a0,0x2
    80006014:	78850513          	addi	a0,a0,1928 # 80008798 <etext+0x798>
    80006018:	cbbff0ef          	jal	80005cd2 <panic>
    panic("pop_off");
    8000601c:	00002517          	auipc	a0,0x2
    80006020:	79450513          	addi	a0,a0,1940 # 800087b0 <etext+0x7b0>
    80006024:	cafff0ef          	jal	80005cd2 <panic>

0000000080006028 <release>:
{
    80006028:	1101                	addi	sp,sp,-32
    8000602a:	ec06                	sd	ra,24(sp)
    8000602c:	e822                	sd	s0,16(sp)
    8000602e:	e426                	sd	s1,8(sp)
    80006030:	1000                	addi	s0,sp,32
    80006032:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006034:	ef1ff0ef          	jal	80005f24 <holding>
    80006038:	c105                	beqz	a0,80006058 <release+0x30>
  lk->cpu = 0;
    8000603a:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000603e:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006042:	0310000f          	fence	rw,w
    80006046:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000604a:	f8fff0ef          	jal	80005fd8 <pop_off>
}
    8000604e:	60e2                	ld	ra,24(sp)
    80006050:	6442                	ld	s0,16(sp)
    80006052:	64a2                	ld	s1,8(sp)
    80006054:	6105                	addi	sp,sp,32
    80006056:	8082                	ret
    panic("release");
    80006058:	00002517          	auipc	a0,0x2
    8000605c:	76050513          	addi	a0,a0,1888 # 800087b8 <etext+0x7b8>
    80006060:	c73ff0ef          	jal	80005cd2 <panic>

0000000080006064 <atomic_read4>:

// Read a shared 32-bit value without holding a lock
int
atomic_read4(int *addr) {
    80006064:	1141                	addi	sp,sp,-16
    80006066:	e406                	sd	ra,8(sp)
    80006068:	e022                	sd	s0,0(sp)
    8000606a:	0800                	addi	s0,sp,16
  uint32 val;
  __atomic_load(addr, &val, __ATOMIC_SEQ_CST);
    8000606c:	0330000f          	fence	rw,rw
    80006070:	4108                	lw	a0,0(a0)
    80006072:	0230000f          	fence	r,rw
  return val;
}
    80006076:	2501                	sext.w	a0,a0
    80006078:	60a2                	ld	ra,8(sp)
    8000607a:	6402                	ld	s0,0(sp)
    8000607c:	0141                	addi	sp,sp,16
    8000607e:	8082                	ret
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
