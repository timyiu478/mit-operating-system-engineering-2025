
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
    80000004:	f1010113          	addi	sp,sp,-240 # 8001af10 <stack0>
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
    80000016:	771040ef          	jal	80004f86 <start>

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
    80000028:	00023797          	auipc	a5,0x23
    8000002c:	fc078793          	addi	a5,a5,-64 # 80022fe8 <end>
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
    80000056:	88e90913          	addi	s2,s2,-1906 # 800078e0 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	1ad050ef          	jal	80005a08 <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	231050ef          	jal	80005a9c <release>
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
    80000084:	6c2050ef          	jal	80005746 <panic>

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
    800000e4:	80050513          	addi	a0,a0,-2048 # 800078e0 <kmem>
    800000e8:	097050ef          	jal	8000597e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	00023517          	auipc	a0,0x23
    800000f4:	ef850513          	addi	a0,a0,-264 # 80022fe8 <end>
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
    8000010e:	00007517          	auipc	a0,0x7
    80000112:	7d250513          	addi	a0,a0,2002 # 800078e0 <kmem>
    80000116:	0f3050ef          	jal	80005a08 <acquire>
  r = kmem.freelist;
    8000011a:	00007497          	auipc	s1,0x7
    8000011e:	7de4b483          	ld	s1,2014(s1) # 800078f8 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	00007717          	auipc	a4,0x7
    8000012a:	7cf73923          	sd	a5,2002(a4) # 800078f8 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	00007517          	auipc	a0,0x7
    80000132:	7b250513          	addi	a0,a0,1970 # 800078e0 <kmem>
    80000136:	167050ef          	jal	80005a9c <release>

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
    80000154:	79050513          	addi	a0,a0,1936 # 800078e0 <kmem>
    80000158:	145050ef          	jal	80005a9c <release>
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
    8000031c:	287000ef          	jal	80000da2 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000320:	00007717          	auipc	a4,0x7
    80000324:	59070713          	addi	a4,a4,1424 # 800078b0 <started>
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
    80000334:	26f000ef          	jal	80000da2 <cpuid>
    80000338:	85aa                	mv	a1,a0
    8000033a:	00007517          	auipc	a0,0x7
    8000033e:	cfe50513          	addi	a0,a0,-770 # 80007038 <etext+0x38>
    80000342:	0da050ef          	jal	8000541c <printf>
    kvminithart();    // turn on paging
    80000346:	080000ef          	jal	800003c6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034a:	620010ef          	jal	8000196a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034e:	67a040ef          	jal	800049c8 <plicinithart>
  }

  scheduler();        
    80000352:	75f000ef          	jal	800012b0 <scheduler>
    consoleinit();
    80000356:	7ed040ef          	jal	80005342 <consoleinit>
    printfinit();
    8000035a:	428050ef          	jal	80005782 <printfinit>
    printf("\n");
    8000035e:	00007517          	auipc	a0,0x7
    80000362:	cba50513          	addi	a0,a0,-838 # 80007018 <etext+0x18>
    80000366:	0b6050ef          	jal	8000541c <printf>
    printf("xv6 kernel is booting\n");
    8000036a:	00007517          	auipc	a0,0x7
    8000036e:	cb650513          	addi	a0,a0,-842 # 80007020 <etext+0x20>
    80000372:	0aa050ef          	jal	8000541c <printf>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	09e050ef          	jal	8000541c <printf>
    kinit();         // physical page allocator
    80000382:	d4fff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    80000386:	2ea000ef          	jal	80000670 <kvminit>
    kvminithart();   // turn on paging
    8000038a:	03c000ef          	jal	800003c6 <kvminithart>
    procinit();      // process table
    8000038e:	169000ef          	jal	80000cf6 <procinit>
    trapinit();      // trap vectors
    80000392:	5b4010ef          	jal	80001946 <trapinit>
    trapinithart();  // install kernel trap vector
    80000396:	5d4010ef          	jal	8000196a <trapinithart>
    plicinit();      // set up interrupt controller
    8000039a:	614040ef          	jal	800049ae <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039e:	62a040ef          	jal	800049c8 <plicinithart>
    binit();         // buffer cache
    800003a2:	4a9010ef          	jal	8000204a <binit>
    iinit();         // inode table
    800003a6:	1fa020ef          	jal	800025a0 <iinit>
    fileinit();      // file table
    800003aa:	126030ef          	jal	800034d0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	70a040ef          	jal	80004ab8 <virtio_disk_init>
    userinit();      // first user process
    800003b2:	565000ef          	jal	80001116 <userinit>
    __sync_synchronize();
    800003b6:	0330000f          	fence	rw,rw
    started = 1;
    800003ba:	4785                	li	a5,1
    800003bc:	00007717          	auipc	a4,0x7
    800003c0:	4ef72a23          	sw	a5,1268(a4) # 800078b0 <started>
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
    800003d6:	4e67b783          	ld	a5,1254(a5) # 800078b8 <kernel_pagetable>
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
    80000414:	04b7e763          	bltu	a5,a1,80000462 <walk+0x70>
    pte_t *pte = &pagetable[PX(level, va)];
    80000418:	0149d933          	srl	s2,s3,s4
    8000041c:	1ff97913          	andi	s2,s2,511
    80000420:	090e                	slli	s2,s2,0x3
    80000422:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000424:	00093483          	ld	s1,0(s2)
    80000428:	0014f793          	andi	a5,s1,1
    8000042c:	c3a9                	beqz	a5,8000046e <walk+0x7c>
      pagetable = (pagetable_t)PTE2PA(*pte);
#ifdef LAB_PGTBL
      if(PTE_LEAF(*pte)) {
    8000042e:	00e4f793          	andi	a5,s1,14
    80000432:	ef89                	bnez	a5,8000044c <walk+0x5a>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000434:	80a9                	srli	s1,s1,0xa
    80000436:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000438:	3a5d                	addiw	s4,s4,-9
    8000043a:	fd5a1fe3          	bne	s4,s5,80000418 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    8000043e:	00c9d993          	srli	s3,s3,0xc
    80000442:	1ff9f993          	andi	s3,s3,511
    80000446:	098e                	slli	s3,s3,0x3
    80000448:	01348933          	add	s2,s1,s3
}
    8000044c:	854a                	mv	a0,s2
    8000044e:	70e2                	ld	ra,56(sp)
    80000450:	7442                	ld	s0,48(sp)
    80000452:	74a2                	ld	s1,40(sp)
    80000454:	7902                	ld	s2,32(sp)
    80000456:	69e2                	ld	s3,24(sp)
    80000458:	6a42                	ld	s4,16(sp)
    8000045a:	6aa2                	ld	s5,8(sp)
    8000045c:	6b02                	ld	s6,0(sp)
    8000045e:	6121                	addi	sp,sp,64
    80000460:	8082                	ret
    panic("walk");
    80000462:	00007517          	auipc	a0,0x7
    80000466:	bee50513          	addi	a0,a0,-1042 # 80007050 <etext+0x50>
    8000046a:	2dc050ef          	jal	80005746 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000046e:	020b0263          	beqz	s6,80000492 <walk+0xa0>
    80000472:	c93ff0ef          	jal	80000104 <kalloc>
    80000476:	84aa                	mv	s1,a0
    80000478:	cd19                	beqz	a0,80000496 <walk+0xa4>
      memset(pagetable, 0, PGSIZE);
    8000047a:	6605                	lui	a2,0x1
    8000047c:	4581                	li	a1,0
    8000047e:	ce1ff0ef          	jal	8000015e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000482:	00c4d793          	srli	a5,s1,0xc
    80000486:	07aa                	slli	a5,a5,0xa
    80000488:	0017e793          	ori	a5,a5,1
    8000048c:	00f93023          	sd	a5,0(s2)
    80000490:	b765                	j	80000438 <walk+0x46>
        return 0;
    80000492:	4901                	li	s2,0
    80000494:	bf65                	j	8000044c <walk+0x5a>
    80000496:	892a                	mv	s2,a0
    80000498:	bf55                	j	8000044c <walk+0x5a>

000000008000049a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000049a:	57fd                	li	a5,-1
    8000049c:	83e9                	srli	a5,a5,0x1a
    8000049e:	00b7f463          	bgeu	a5,a1,800004a6 <walkaddr+0xc>
    return 0;
    800004a2:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800004a4:	8082                	ret
{
    800004a6:	1141                	addi	sp,sp,-16
    800004a8:	e406                	sd	ra,8(sp)
    800004aa:	e022                	sd	s0,0(sp)
    800004ac:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800004ae:	4601                	li	a2,0
    800004b0:	f43ff0ef          	jal	800003f2 <walk>
  if(pte == 0)
    800004b4:	c901                	beqz	a0,800004c4 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    800004b6:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800004b8:	0117f693          	andi	a3,a5,17
    800004bc:	4745                	li	a4,17
    return 0;
    800004be:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800004c0:	00e68663          	beq	a3,a4,800004cc <walkaddr+0x32>
}
    800004c4:	60a2                	ld	ra,8(sp)
    800004c6:	6402                	ld	s0,0(sp)
    800004c8:	0141                	addi	sp,sp,16
    800004ca:	8082                	ret
  pa = PTE2PA(*pte);
    800004cc:	83a9                	srli	a5,a5,0xa
    800004ce:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004d2:	bfcd                	j	800004c4 <walkaddr+0x2a>

00000000800004d4 <vmprint>:


#if defined(LAB_PGTBL) || defined(SOL_MMAP) || defined(SOL_COW)
void
vmprint(pagetable_t pagetable) {
    800004d4:	1141                	addi	sp,sp,-16
    800004d6:	e406                	sd	ra,8(sp)
    800004d8:	e022                	sd	s0,0(sp)
    800004da:	0800                	addi	s0,sp,16
  // your code here
}
    800004dc:	60a2                	ld	ra,8(sp)
    800004de:	6402                	ld	s0,0(sp)
    800004e0:	0141                	addi	sp,sp,16
    800004e2:	8082                	ret

00000000800004e4 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004e4:	715d                	addi	sp,sp,-80
    800004e6:	e486                	sd	ra,72(sp)
    800004e8:	e0a2                	sd	s0,64(sp)
    800004ea:	fc26                	sd	s1,56(sp)
    800004ec:	f84a                	sd	s2,48(sp)
    800004ee:	f44e                	sd	s3,40(sp)
    800004f0:	f052                	sd	s4,32(sp)
    800004f2:	ec56                	sd	s5,24(sp)
    800004f4:	e85a                	sd	s6,16(sp)
    800004f6:	e45e                	sd	s7,8(sp)
    800004f8:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004fa:	03459793          	slli	a5,a1,0x34
    800004fe:	eba1                	bnez	a5,8000054e <mappages+0x6a>
    80000500:	8a2a                	mv	s4,a0
    80000502:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    80000504:	03461793          	slli	a5,a2,0x34
    80000508:	eba9                	bnez	a5,8000055a <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    8000050a:	ce31                	beqz	a2,80000566 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    8000050c:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80000510:	80060613          	addi	a2,a2,-2048
    80000514:	00b60933          	add	s2,a2,a1
  a = va;
    80000518:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    8000051a:	4b05                	li	s6,1
    8000051c:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000520:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    80000522:	865a                	mv	a2,s6
    80000524:	85a6                	mv	a1,s1
    80000526:	8552                	mv	a0,s4
    80000528:	ecbff0ef          	jal	800003f2 <walk>
    8000052c:	c929                	beqz	a0,8000057e <mappages+0x9a>
    if(*pte & PTE_V)
    8000052e:	611c                	ld	a5,0(a0)
    80000530:	8b85                	andi	a5,a5,1
    80000532:	e3a1                	bnez	a5,80000572 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000534:	013487b3          	add	a5,s1,s3
    80000538:	83b1                	srli	a5,a5,0xc
    8000053a:	07aa                	slli	a5,a5,0xa
    8000053c:	0157e7b3          	or	a5,a5,s5
    80000540:	0017e793          	ori	a5,a5,1
    80000544:	e11c                	sd	a5,0(a0)
    if(a == last)
    80000546:	05248863          	beq	s1,s2,80000596 <mappages+0xb2>
    a += PGSIZE;
    8000054a:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000054c:	bfd9                	j	80000522 <mappages+0x3e>
    panic("mappages: va not aligned");
    8000054e:	00007517          	auipc	a0,0x7
    80000552:	b0a50513          	addi	a0,a0,-1270 # 80007058 <etext+0x58>
    80000556:	1f0050ef          	jal	80005746 <panic>
    panic("mappages: size not aligned");
    8000055a:	00007517          	auipc	a0,0x7
    8000055e:	b1e50513          	addi	a0,a0,-1250 # 80007078 <etext+0x78>
    80000562:	1e4050ef          	jal	80005746 <panic>
    panic("mappages: size");
    80000566:	00007517          	auipc	a0,0x7
    8000056a:	b3250513          	addi	a0,a0,-1230 # 80007098 <etext+0x98>
    8000056e:	1d8050ef          	jal	80005746 <panic>
      panic("mappages: remap");
    80000572:	00007517          	auipc	a0,0x7
    80000576:	b3650513          	addi	a0,a0,-1226 # 800070a8 <etext+0xa8>
    8000057a:	1cc050ef          	jal	80005746 <panic>
      return -1;
    8000057e:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000580:	60a6                	ld	ra,72(sp)
    80000582:	6406                	ld	s0,64(sp)
    80000584:	74e2                	ld	s1,56(sp)
    80000586:	7942                	ld	s2,48(sp)
    80000588:	79a2                	ld	s3,40(sp)
    8000058a:	7a02                	ld	s4,32(sp)
    8000058c:	6ae2                	ld	s5,24(sp)
    8000058e:	6b42                	ld	s6,16(sp)
    80000590:	6ba2                	ld	s7,8(sp)
    80000592:	6161                	addi	sp,sp,80
    80000594:	8082                	ret
  return 0;
    80000596:	4501                	li	a0,0
    80000598:	b7e5                	j	80000580 <mappages+0x9c>

000000008000059a <kvmmap>:
{
    8000059a:	1141                	addi	sp,sp,-16
    8000059c:	e406                	sd	ra,8(sp)
    8000059e:	e022                	sd	s0,0(sp)
    800005a0:	0800                	addi	s0,sp,16
    800005a2:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005a4:	86b2                	mv	a3,a2
    800005a6:	863e                	mv	a2,a5
    800005a8:	f3dff0ef          	jal	800004e4 <mappages>
    800005ac:	e509                	bnez	a0,800005b6 <kvmmap+0x1c>
}
    800005ae:	60a2                	ld	ra,8(sp)
    800005b0:	6402                	ld	s0,0(sp)
    800005b2:	0141                	addi	sp,sp,16
    800005b4:	8082                	ret
    panic("kvmmap");
    800005b6:	00007517          	auipc	a0,0x7
    800005ba:	b0250513          	addi	a0,a0,-1278 # 800070b8 <etext+0xb8>
    800005be:	188050ef          	jal	80005746 <panic>

00000000800005c2 <kvmmake>:
{
    800005c2:	1101                	addi	sp,sp,-32
    800005c4:	ec06                	sd	ra,24(sp)
    800005c6:	e822                	sd	s0,16(sp)
    800005c8:	e426                	sd	s1,8(sp)
    800005ca:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800005cc:	b39ff0ef          	jal	80000104 <kalloc>
    800005d0:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800005d2:	6605                	lui	a2,0x1
    800005d4:	4581                	li	a1,0
    800005d6:	b89ff0ef          	jal	8000015e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    800005da:	4719                	li	a4,6
    800005dc:	6685                	lui	a3,0x1
    800005de:	10000637          	lui	a2,0x10000
    800005e2:	85b2                	mv	a1,a2
    800005e4:	8526                	mv	a0,s1
    800005e6:	fb5ff0ef          	jal	8000059a <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005ea:	4719                	li	a4,6
    800005ec:	6685                	lui	a3,0x1
    800005ee:	10001637          	lui	a2,0x10001
    800005f2:	85b2                	mv	a1,a2
    800005f4:	8526                	mv	a0,s1
    800005f6:	fa5ff0ef          	jal	8000059a <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005fa:	4719                	li	a4,6
    800005fc:	040006b7          	lui	a3,0x4000
    80000600:	0c000637          	lui	a2,0xc000
    80000604:	85b2                	mv	a1,a2
    80000606:	8526                	mv	a0,s1
    80000608:	f93ff0ef          	jal	8000059a <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000060c:	4729                	li	a4,10
    8000060e:	80007697          	auipc	a3,0x80007
    80000612:	9f268693          	addi	a3,a3,-1550 # 7000 <_entry-0x7fff9000>
    80000616:	4605                	li	a2,1
    80000618:	067e                	slli	a2,a2,0x1f
    8000061a:	85b2                	mv	a1,a2
    8000061c:	8526                	mv	a0,s1
    8000061e:	f7dff0ef          	jal	8000059a <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000622:	4719                	li	a4,6
    80000624:	00007697          	auipc	a3,0x7
    80000628:	9dc68693          	addi	a3,a3,-1572 # 80007000 <etext>
    8000062c:	47c5                	li	a5,17
    8000062e:	07ee                	slli	a5,a5,0x1b
    80000630:	40d786b3          	sub	a3,a5,a3
    80000634:	00007617          	auipc	a2,0x7
    80000638:	9cc60613          	addi	a2,a2,-1588 # 80007000 <etext>
    8000063c:	85b2                	mv	a1,a2
    8000063e:	8526                	mv	a0,s1
    80000640:	f5bff0ef          	jal	8000059a <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000644:	4729                	li	a4,10
    80000646:	6685                	lui	a3,0x1
    80000648:	00006617          	auipc	a2,0x6
    8000064c:	9b860613          	addi	a2,a2,-1608 # 80006000 <_trampoline>
    80000650:	040005b7          	lui	a1,0x4000
    80000654:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000656:	05b2                	slli	a1,a1,0xc
    80000658:	8526                	mv	a0,s1
    8000065a:	f41ff0ef          	jal	8000059a <kvmmap>
  proc_mapstacks(kpgtbl);
    8000065e:	8526                	mv	a0,s1
    80000660:	5fc000ef          	jal	80000c5c <proc_mapstacks>
}
    80000664:	8526                	mv	a0,s1
    80000666:	60e2                	ld	ra,24(sp)
    80000668:	6442                	ld	s0,16(sp)
    8000066a:	64a2                	ld	s1,8(sp)
    8000066c:	6105                	addi	sp,sp,32
    8000066e:	8082                	ret

0000000080000670 <kvminit>:
{
    80000670:	1141                	addi	sp,sp,-16
    80000672:	e406                	sd	ra,8(sp)
    80000674:	e022                	sd	s0,0(sp)
    80000676:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    80000678:	f4bff0ef          	jal	800005c2 <kvmmake>
    8000067c:	00007797          	auipc	a5,0x7
    80000680:	22a7be23          	sd	a0,572(a5) # 800078b8 <kernel_pagetable>
}
    80000684:	60a2                	ld	ra,8(sp)
    80000686:	6402                	ld	s0,0(sp)
    80000688:	0141                	addi	sp,sp,16
    8000068a:	8082                	ret

000000008000068c <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000068c:	1101                	addi	sp,sp,-32
    8000068e:	ec06                	sd	ra,24(sp)
    80000690:	e822                	sd	s0,16(sp)
    80000692:	e426                	sd	s1,8(sp)
    80000694:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000696:	a6fff0ef          	jal	80000104 <kalloc>
    8000069a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000069c:	c509                	beqz	a0,800006a6 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    8000069e:	6605                	lui	a2,0x1
    800006a0:	4581                	li	a1,0
    800006a2:	abdff0ef          	jal	8000015e <memset>
  return pagetable;
}
    800006a6:	8526                	mv	a0,s1
    800006a8:	60e2                	ld	ra,24(sp)
    800006aa:	6442                	ld	s0,16(sp)
    800006ac:	64a2                	ld	s1,8(sp)
    800006ae:	6105                	addi	sp,sp,32
    800006b0:	8082                	ret

00000000800006b2 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800006b2:	715d                	addi	sp,sp,-80
    800006b4:	e486                	sd	ra,72(sp)
    800006b6:	e0a2                	sd	s0,64(sp)
    800006b8:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;

  if((va % PGSIZE) != 0)
    800006ba:	03459793          	slli	a5,a1,0x34
    800006be:	e39d                	bnez	a5,800006e4 <uvmunmap+0x32>
    800006c0:	f84a                	sd	s2,48(sp)
    800006c2:	f44e                	sd	s3,40(sp)
    800006c4:	f052                	sd	s4,32(sp)
    800006c6:	ec56                	sd	s5,24(sp)
    800006c8:	e85a                	sd	s6,16(sp)
    800006ca:	e45e                	sd	s7,8(sp)
    800006cc:	8a2a                	mv	s4,a0
    800006ce:	892e                	mv	s2,a1
    800006d0:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006d2:	0632                	slli	a2,a2,0xc
    800006d4:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
      continue;
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
      continue;
    sz = PGSIZE;
    if(PTE_FLAGS(*pte) == PTE_V)
    800006d8:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006da:	6a85                	lui	s5,0x1
    800006dc:	0735f463          	bgeu	a1,s3,80000744 <uvmunmap+0x92>
    800006e0:	fc26                	sd	s1,56(sp)
    800006e2:	a80d                	j	80000714 <uvmunmap+0x62>
    800006e4:	fc26                	sd	s1,56(sp)
    800006e6:	f84a                	sd	s2,48(sp)
    800006e8:	f44e                	sd	s3,40(sp)
    800006ea:	f052                	sd	s4,32(sp)
    800006ec:	ec56                	sd	s5,24(sp)
    800006ee:	e85a                	sd	s6,16(sp)
    800006f0:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006f2:	00007517          	auipc	a0,0x7
    800006f6:	9ce50513          	addi	a0,a0,-1586 # 800070c0 <etext+0xc0>
    800006fa:	04c050ef          	jal	80005746 <panic>
      panic("uvmunmap: not a leaf");
    800006fe:	00007517          	auipc	a0,0x7
    80000702:	9da50513          	addi	a0,a0,-1574 # 800070d8 <etext+0xd8>
    80000706:	040050ef          	jal	80005746 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    8000070a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000070e:	9956                	add	s2,s2,s5
    80000710:	03397963          	bgeu	s2,s3,80000742 <uvmunmap+0x90>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    80000714:	4601                	li	a2,0
    80000716:	85ca                	mv	a1,s2
    80000718:	8552                	mv	a0,s4
    8000071a:	cd9ff0ef          	jal	800003f2 <walk>
    8000071e:	84aa                	mv	s1,a0
    80000720:	d57d                	beqz	a0,8000070e <uvmunmap+0x5c>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80000722:	611c                	ld	a5,0(a0)
    80000724:	0017f713          	andi	a4,a5,1
    80000728:	d37d                	beqz	a4,8000070e <uvmunmap+0x5c>
    if(PTE_FLAGS(*pte) == PTE_V)
    8000072a:	3ff7f713          	andi	a4,a5,1023
    8000072e:	fd7708e3          	beq	a4,s7,800006fe <uvmunmap+0x4c>
    if(do_free){
    80000732:	fc0b0ce3          	beqz	s6,8000070a <uvmunmap+0x58>
      uint64 pa = PTE2PA(*pte);
    80000736:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000738:	00c79513          	slli	a0,a5,0xc
    8000073c:	8e1ff0ef          	jal	8000001c <kfree>
    80000740:	b7e9                	j	8000070a <uvmunmap+0x58>
    80000742:	74e2                	ld	s1,56(sp)
    80000744:	7942                	ld	s2,48(sp)
    80000746:	79a2                	ld	s3,40(sp)
    80000748:	7a02                	ld	s4,32(sp)
    8000074a:	6ae2                	ld	s5,24(sp)
    8000074c:	6b42                	ld	s6,16(sp)
    8000074e:	6ba2                	ld	s7,8(sp)
  }
}
    80000750:	60a6                	ld	ra,72(sp)
    80000752:	6406                	ld	s0,64(sp)
    80000754:	6161                	addi	sp,sp,80
    80000756:	8082                	ret

0000000080000758 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000758:	1101                	addi	sp,sp,-32
    8000075a:	ec06                	sd	ra,24(sp)
    8000075c:	e822                	sd	s0,16(sp)
    8000075e:	e426                	sd	s1,8(sp)
    80000760:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000762:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000764:	00b67d63          	bgeu	a2,a1,8000077e <uvmdealloc+0x26>
    80000768:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000076a:	6785                	lui	a5,0x1
    8000076c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000076e:	00f60733          	add	a4,a2,a5
    80000772:	76fd                	lui	a3,0xfffff
    80000774:	8f75                	and	a4,a4,a3
    80000776:	97ae                	add	a5,a5,a1
    80000778:	8ff5                	and	a5,a5,a3
    8000077a:	00f76863          	bltu	a4,a5,8000078a <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000077e:	8526                	mv	a0,s1
    80000780:	60e2                	ld	ra,24(sp)
    80000782:	6442                	ld	s0,16(sp)
    80000784:	64a2                	ld	s1,8(sp)
    80000786:	6105                	addi	sp,sp,32
    80000788:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000078a:	8f99                	sub	a5,a5,a4
    8000078c:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000078e:	4685                	li	a3,1
    80000790:	0007861b          	sext.w	a2,a5
    80000794:	85ba                	mv	a1,a4
    80000796:	f1dff0ef          	jal	800006b2 <uvmunmap>
    8000079a:	b7d5                	j	8000077e <uvmdealloc+0x26>

000000008000079c <uvmalloc>:
  if(newsz < oldsz)
    8000079c:	0ab66163          	bltu	a2,a1,8000083e <uvmalloc+0xa2>
{
    800007a0:	715d                	addi	sp,sp,-80
    800007a2:	e486                	sd	ra,72(sp)
    800007a4:	e0a2                	sd	s0,64(sp)
    800007a6:	f84a                	sd	s2,48(sp)
    800007a8:	f052                	sd	s4,32(sp)
    800007aa:	ec56                	sd	s5,24(sp)
    800007ac:	e45e                	sd	s7,8(sp)
    800007ae:	0880                	addi	s0,sp,80
    800007b0:	8aaa                	mv	s5,a0
    800007b2:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800007b4:	6785                	lui	a5,0x1
    800007b6:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800007b8:	95be                	add	a1,a1,a5
    800007ba:	77fd                	lui	a5,0xfffff
    800007bc:	00f5f933          	and	s2,a1,a5
    800007c0:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += sz){
    800007c2:	08c97063          	bgeu	s2,a2,80000842 <uvmalloc+0xa6>
    800007c6:	fc26                	sd	s1,56(sp)
    800007c8:	f44e                	sd	s3,40(sp)
    800007ca:	e85a                	sd	s6,16(sp)
    memset(mem, 0, sz);
    800007cc:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007ce:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800007d2:	933ff0ef          	jal	80000104 <kalloc>
    800007d6:	84aa                	mv	s1,a0
    if(mem == 0){
    800007d8:	c50d                	beqz	a0,80000802 <uvmalloc+0x66>
    memset(mem, 0, sz);
    800007da:	864e                	mv	a2,s3
    800007dc:	4581                	li	a1,0
    800007de:	981ff0ef          	jal	8000015e <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800007e2:	875a                	mv	a4,s6
    800007e4:	86a6                	mv	a3,s1
    800007e6:	864e                	mv	a2,s3
    800007e8:	85ca                	mv	a1,s2
    800007ea:	8556                	mv	a0,s5
    800007ec:	cf9ff0ef          	jal	800004e4 <mappages>
    800007f0:	e915                	bnez	a0,80000824 <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += sz){
    800007f2:	994e                	add	s2,s2,s3
    800007f4:	fd496fe3          	bltu	s2,s4,800007d2 <uvmalloc+0x36>
  return newsz;
    800007f8:	8552                	mv	a0,s4
    800007fa:	74e2                	ld	s1,56(sp)
    800007fc:	79a2                	ld	s3,40(sp)
    800007fe:	6b42                	ld	s6,16(sp)
    80000800:	a811                	j	80000814 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    80000802:	865e                	mv	a2,s7
    80000804:	85ca                	mv	a1,s2
    80000806:	8556                	mv	a0,s5
    80000808:	f51ff0ef          	jal	80000758 <uvmdealloc>
      return 0;
    8000080c:	4501                	li	a0,0
    8000080e:	74e2                	ld	s1,56(sp)
    80000810:	79a2                	ld	s3,40(sp)
    80000812:	6b42                	ld	s6,16(sp)
}
    80000814:	60a6                	ld	ra,72(sp)
    80000816:	6406                	ld	s0,64(sp)
    80000818:	7942                	ld	s2,48(sp)
    8000081a:	7a02                	ld	s4,32(sp)
    8000081c:	6ae2                	ld	s5,24(sp)
    8000081e:	6ba2                	ld	s7,8(sp)
    80000820:	6161                	addi	sp,sp,80
    80000822:	8082                	ret
      kfree(mem);
    80000824:	8526                	mv	a0,s1
    80000826:	ff6ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    8000082a:	865e                	mv	a2,s7
    8000082c:	85ca                	mv	a1,s2
    8000082e:	8556                	mv	a0,s5
    80000830:	f29ff0ef          	jal	80000758 <uvmdealloc>
      return 0;
    80000834:	4501                	li	a0,0
    80000836:	74e2                	ld	s1,56(sp)
    80000838:	79a2                	ld	s3,40(sp)
    8000083a:	6b42                	ld	s6,16(sp)
    8000083c:	bfe1                	j	80000814 <uvmalloc+0x78>
    return oldsz;
    8000083e:	852e                	mv	a0,a1
}
    80000840:	8082                	ret
  return newsz;
    80000842:	8532                	mv	a0,a2
    80000844:	bfc1                	j	80000814 <uvmalloc+0x78>

0000000080000846 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000846:	7179                	addi	sp,sp,-48
    80000848:	f406                	sd	ra,40(sp)
    8000084a:	f022                	sd	s0,32(sp)
    8000084c:	ec26                	sd	s1,24(sp)
    8000084e:	e84a                	sd	s2,16(sp)
    80000850:	e44e                	sd	s3,8(sp)
    80000852:	1800                	addi	s0,sp,48
    80000854:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000856:	84aa                	mv	s1,a0
    80000858:	6905                	lui	s2,0x1
    8000085a:	992a                	add	s2,s2,a0
    8000085c:	a811                	j	80000870 <freewalk+0x2a>
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      // backtrace();
      panic("freewalk: leaf");
    8000085e:	00007517          	auipc	a0,0x7
    80000862:	89250513          	addi	a0,a0,-1902 # 800070f0 <etext+0xf0>
    80000866:	6e1040ef          	jal	80005746 <panic>
  for(int i = 0; i < 512; i++){
    8000086a:	04a1                	addi	s1,s1,8
    8000086c:	03248163          	beq	s1,s2,8000088e <freewalk+0x48>
    pte_t pte = pagetable[i];
    80000870:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000872:	0017f713          	andi	a4,a5,1
    80000876:	db75                	beqz	a4,8000086a <freewalk+0x24>
    80000878:	00e7f713          	andi	a4,a5,14
    8000087c:	f36d                	bnez	a4,8000085e <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    8000087e:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000880:	00c79513          	slli	a0,a5,0xc
    80000884:	fc3ff0ef          	jal	80000846 <freewalk>
      pagetable[i] = 0;
    80000888:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000088c:	bff9                	j	8000086a <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    8000088e:	854e                	mv	a0,s3
    80000890:	f8cff0ef          	jal	8000001c <kfree>
}
    80000894:	70a2                	ld	ra,40(sp)
    80000896:	7402                	ld	s0,32(sp)
    80000898:	64e2                	ld	s1,24(sp)
    8000089a:	6942                	ld	s2,16(sp)
    8000089c:	69a2                	ld	s3,8(sp)
    8000089e:	6145                	addi	sp,sp,48
    800008a0:	8082                	ret

00000000800008a2 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800008a2:	1101                	addi	sp,sp,-32
    800008a4:	ec06                	sd	ra,24(sp)
    800008a6:	e822                	sd	s0,16(sp)
    800008a8:	e426                	sd	s1,8(sp)
    800008aa:	1000                	addi	s0,sp,32
    800008ac:	84aa                	mv	s1,a0
  if(sz > 0)
    800008ae:	e989                	bnez	a1,800008c0 <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800008b0:	8526                	mv	a0,s1
    800008b2:	f95ff0ef          	jal	80000846 <freewalk>
}
    800008b6:	60e2                	ld	ra,24(sp)
    800008b8:	6442                	ld	s0,16(sp)
    800008ba:	64a2                	ld	s1,8(sp)
    800008bc:	6105                	addi	sp,sp,32
    800008be:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800008c0:	6785                	lui	a5,0x1
    800008c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008c4:	95be                	add	a1,a1,a5
    800008c6:	4685                	li	a3,1
    800008c8:	00c5d613          	srli	a2,a1,0xc
    800008cc:	4581                	li	a1,0
    800008ce:	de5ff0ef          	jal	800006b2 <uvmunmap>
    800008d2:	bff9                	j	800008b0 <uvmfree+0xe>

00000000800008d4 <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc = PGSIZE;

  for(i = 0; i < sz; i += szinc){
    800008d4:	ca59                	beqz	a2,8000096a <uvmcopy+0x96>
{
    800008d6:	715d                	addi	sp,sp,-80
    800008d8:	e486                	sd	ra,72(sp)
    800008da:	e0a2                	sd	s0,64(sp)
    800008dc:	fc26                	sd	s1,56(sp)
    800008de:	f84a                	sd	s2,48(sp)
    800008e0:	f44e                	sd	s3,40(sp)
    800008e2:	f052                	sd	s4,32(sp)
    800008e4:	ec56                	sd	s5,24(sp)
    800008e6:	e85a                	sd	s6,16(sp)
    800008e8:	e45e                	sd	s7,8(sp)
    800008ea:	0880                	addi	s0,sp,80
    800008ec:	8b2a                	mv	s6,a0
    800008ee:	8bae                	mv	s7,a1
    800008f0:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += szinc){
    800008f2:	4481                	li	s1,0
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008f4:	6a05                	lui	s4,0x1
    800008f6:	a021                	j	800008fe <uvmcopy+0x2a>
  for(i = 0; i < sz; i += szinc){
    800008f8:	94d2                	add	s1,s1,s4
    800008fa:	0554fc63          	bgeu	s1,s5,80000952 <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    800008fe:	4601                	li	a2,0
    80000900:	85a6                	mv	a1,s1
    80000902:	855a                	mv	a0,s6
    80000904:	aefff0ef          	jal	800003f2 <walk>
    80000908:	d965                	beqz	a0,800008f8 <uvmcopy+0x24>
    if((*pte & PTE_V) == 0) {
    8000090a:	00053983          	ld	s3,0(a0)
    8000090e:	0019f793          	andi	a5,s3,1
    80000912:	d3fd                	beqz	a5,800008f8 <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    80000914:	ff0ff0ef          	jal	80000104 <kalloc>
    80000918:	892a                	mv	s2,a0
    8000091a:	c11d                	beqz	a0,80000940 <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    8000091c:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    80000920:	8652                	mv	a2,s4
    80000922:	05b2                	slli	a1,a1,0xc
    80000924:	89bff0ef          	jal	800001be <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000928:	3ff9f713          	andi	a4,s3,1023
    8000092c:	86ca                	mv	a3,s2
    8000092e:	8652                	mv	a2,s4
    80000930:	85a6                	mv	a1,s1
    80000932:	855e                	mv	a0,s7
    80000934:	bb1ff0ef          	jal	800004e4 <mappages>
    80000938:	d161                	beqz	a0,800008f8 <uvmcopy+0x24>
      kfree(mem);
    8000093a:	854a                	mv	a0,s2
    8000093c:	ee0ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000940:	4685                	li	a3,1
    80000942:	00c4d613          	srli	a2,s1,0xc
    80000946:	4581                	li	a1,0
    80000948:	855e                	mv	a0,s7
    8000094a:	d69ff0ef          	jal	800006b2 <uvmunmap>
  return -1;
    8000094e:	557d                	li	a0,-1
    80000950:	a011                	j	80000954 <uvmcopy+0x80>
  return 0;
    80000952:	4501                	li	a0,0
}
    80000954:	60a6                	ld	ra,72(sp)
    80000956:	6406                	ld	s0,64(sp)
    80000958:	74e2                	ld	s1,56(sp)
    8000095a:	7942                	ld	s2,48(sp)
    8000095c:	79a2                	ld	s3,40(sp)
    8000095e:	7a02                	ld	s4,32(sp)
    80000960:	6ae2                	ld	s5,24(sp)
    80000962:	6b42                	ld	s6,16(sp)
    80000964:	6ba2                	ld	s7,8(sp)
    80000966:	6161                	addi	sp,sp,80
    80000968:	8082                	ret
  return 0;
    8000096a:	4501                	li	a0,0
}
    8000096c:	8082                	ret

000000008000096e <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    8000096e:	1141                	addi	sp,sp,-16
    80000970:	e406                	sd	ra,8(sp)
    80000972:	e022                	sd	s0,0(sp)
    80000974:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000976:	4601                	li	a2,0
    80000978:	a7bff0ef          	jal	800003f2 <walk>
  if(pte == 0)
    8000097c:	c901                	beqz	a0,8000098c <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    8000097e:	611c                	ld	a5,0(a0)
    80000980:	9bbd                	andi	a5,a5,-17
    80000982:	e11c                	sd	a5,0(a0)
}
    80000984:	60a2                	ld	ra,8(sp)
    80000986:	6402                	ld	s0,0(sp)
    80000988:	0141                	addi	sp,sp,16
    8000098a:	8082                	ret
    panic("uvmclear");
    8000098c:	00006517          	auipc	a0,0x6
    80000990:	77450513          	addi	a0,a0,1908 # 80007100 <etext+0x100>
    80000994:	5b3040ef          	jal	80005746 <panic>

0000000080000998 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000998:	cac5                	beqz	a3,80000a48 <copyinstr+0xb0>
{
    8000099a:	715d                	addi	sp,sp,-80
    8000099c:	e486                	sd	ra,72(sp)
    8000099e:	e0a2                	sd	s0,64(sp)
    800009a0:	fc26                	sd	s1,56(sp)
    800009a2:	f84a                	sd	s2,48(sp)
    800009a4:	f44e                	sd	s3,40(sp)
    800009a6:	f052                	sd	s4,32(sp)
    800009a8:	ec56                	sd	s5,24(sp)
    800009aa:	e85a                	sd	s6,16(sp)
    800009ac:	e45e                	sd	s7,8(sp)
    800009ae:	0880                	addi	s0,sp,80
    800009b0:	8aaa                	mv	s5,a0
    800009b2:	84ae                	mv	s1,a1
    800009b4:	8bb2                	mv	s7,a2
    800009b6:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    800009b8:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    800009ba:	6a05                	lui	s4,0x1
    800009bc:	a82d                	j	800009f6 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    800009be:	00078023          	sb	zero,0(a5)
        got_null = 1;
    800009c2:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    800009c4:	0017c793          	xori	a5,a5,1
    800009c8:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    800009cc:	60a6                	ld	ra,72(sp)
    800009ce:	6406                	ld	s0,64(sp)
    800009d0:	74e2                	ld	s1,56(sp)
    800009d2:	7942                	ld	s2,48(sp)
    800009d4:	79a2                	ld	s3,40(sp)
    800009d6:	7a02                	ld	s4,32(sp)
    800009d8:	6ae2                	ld	s5,24(sp)
    800009da:	6b42                	ld	s6,16(sp)
    800009dc:	6ba2                	ld	s7,8(sp)
    800009de:	6161                	addi	sp,sp,80
    800009e0:	8082                	ret
    800009e2:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    800009e6:	9726                	add	a4,a4,s1
      --max;
    800009e8:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    800009ec:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    800009f0:	04e58463          	beq	a1,a4,80000a38 <copyinstr+0xa0>
{
    800009f4:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    800009f6:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    800009fa:	85ca                	mv	a1,s2
    800009fc:	8556                	mv	a0,s5
    800009fe:	a9dff0ef          	jal	8000049a <walkaddr>
    if(pa0 == 0)
    80000a02:	cd0d                	beqz	a0,80000a3c <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000a04:	417906b3          	sub	a3,s2,s7
    80000a08:	96d2                	add	a3,a3,s4
    if(n > max)
    80000a0a:	00d9f363          	bgeu	s3,a3,80000a10 <copyinstr+0x78>
    80000a0e:	86ce                	mv	a3,s3
    while(n > 0){
    80000a10:	ca85                	beqz	a3,80000a40 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80000a12:	01750633          	add	a2,a0,s7
    80000a16:	41260633          	sub	a2,a2,s2
    80000a1a:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80000a1c:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80000a1e:	96a6                	add	a3,a3,s1
    80000a20:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000a22:	00f60733          	add	a4,a2,a5
    80000a26:	00074703          	lbu	a4,0(a4)
    80000a2a:	db51                	beqz	a4,800009be <copyinstr+0x26>
        *dst = *p;
    80000a2c:	00e78023          	sb	a4,0(a5)
      dst++;
    80000a30:	0785                	addi	a5,a5,1
    while(n > 0){
    80000a32:	fed797e3          	bne	a5,a3,80000a20 <copyinstr+0x88>
    80000a36:	b775                	j	800009e2 <copyinstr+0x4a>
    80000a38:	4781                	li	a5,0
    80000a3a:	b769                	j	800009c4 <copyinstr+0x2c>
      return -1;
    80000a3c:	557d                	li	a0,-1
    80000a3e:	b779                	j	800009cc <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80000a40:	6b85                	lui	s7,0x1
    80000a42:	9bca                	add	s7,s7,s2
    80000a44:	87a6                	mv	a5,s1
    80000a46:	b77d                	j	800009f4 <copyinstr+0x5c>
  int got_null = 0;
    80000a48:	4781                	li	a5,0
  if(got_null){
    80000a4a:	0017c793          	xori	a5,a5,1
    80000a4e:	40f0053b          	negw	a0,a5
}
    80000a52:	8082                	ret

0000000080000a54 <ismapped>:
  }
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va) {
    80000a54:	1141                	addi	sp,sp,-16
    80000a56:	e406                	sd	ra,8(sp)
    80000a58:	e022                	sd	s0,0(sp)
    80000a5a:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000a5c:	4601                	li	a2,0
    80000a5e:	995ff0ef          	jal	800003f2 <walk>
  if (pte == 0) {
    80000a62:	c119                	beqz	a0,80000a68 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    80000a64:	6108                	ld	a0,0(a0)
    80000a66:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a68:	60a2                	ld	ra,8(sp)
    80000a6a:	6402                	ld	s0,0(sp)
    80000a6c:	0141                	addi	sp,sp,16
    80000a6e:	8082                	ret

0000000080000a70 <vmfault>:
{
    80000a70:	7179                	addi	sp,sp,-48
    80000a72:	f406                	sd	ra,40(sp)
    80000a74:	f022                	sd	s0,32(sp)
    80000a76:	e84a                	sd	s2,16(sp)
    80000a78:	e44e                	sd	s3,8(sp)
    80000a7a:	1800                	addi	s0,sp,48
    80000a7c:	89aa                	mv	s3,a0
    80000a7e:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80000a80:	356000ef          	jal	80000dd6 <myproc>
  if (va >= p->sz)
    80000a84:	653c                	ld	a5,72(a0)
    80000a86:	00f96a63          	bltu	s2,a5,80000a9a <vmfault+0x2a>
    return 0;
    80000a8a:	4981                	li	s3,0
}
    80000a8c:	854e                	mv	a0,s3
    80000a8e:	70a2                	ld	ra,40(sp)
    80000a90:	7402                	ld	s0,32(sp)
    80000a92:	6942                	ld	s2,16(sp)
    80000a94:	69a2                	ld	s3,8(sp)
    80000a96:	6145                	addi	sp,sp,48
    80000a98:	8082                	ret
    80000a9a:	ec26                	sd	s1,24(sp)
    80000a9c:	e052                	sd	s4,0(sp)
    80000a9e:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80000aa0:	77fd                	lui	a5,0xfffff
    80000aa2:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80000aa6:	85d2                	mv	a1,s4
    80000aa8:	854e                	mv	a0,s3
    80000aaa:	fabff0ef          	jal	80000a54 <ismapped>
    return 0;
    80000aae:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000ab0:	c501                	beqz	a0,80000ab8 <vmfault+0x48>
    80000ab2:	64e2                	ld	s1,24(sp)
    80000ab4:	6a02                	ld	s4,0(sp)
    80000ab6:	bfd9                	j	80000a8c <vmfault+0x1c>
  mem = (uint64) kalloc();
    80000ab8:	e4cff0ef          	jal	80000104 <kalloc>
    80000abc:	892a                	mv	s2,a0
  if(mem == 0)
    80000abe:	c905                	beqz	a0,80000aee <vmfault+0x7e>
  mem = (uint64) kalloc();
    80000ac0:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000ac2:	6605                	lui	a2,0x1
    80000ac4:	4581                	li	a1,0
    80000ac6:	e98ff0ef          	jal	8000015e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000aca:	4759                	li	a4,22
    80000acc:	86ca                	mv	a3,s2
    80000ace:	6605                	lui	a2,0x1
    80000ad0:	85d2                	mv	a1,s4
    80000ad2:	68a8                	ld	a0,80(s1)
    80000ad4:	a11ff0ef          	jal	800004e4 <mappages>
    80000ad8:	e501                	bnez	a0,80000ae0 <vmfault+0x70>
    80000ada:	64e2                	ld	s1,24(sp)
    80000adc:	6a02                	ld	s4,0(sp)
    80000ade:	b77d                	j	80000a8c <vmfault+0x1c>
    kfree((void *)mem);
    80000ae0:	854a                	mv	a0,s2
    80000ae2:	d3aff0ef          	jal	8000001c <kfree>
    return 0;
    80000ae6:	4981                	li	s3,0
    80000ae8:	64e2                	ld	s1,24(sp)
    80000aea:	6a02                	ld	s4,0(sp)
    80000aec:	b745                	j	80000a8c <vmfault+0x1c>
    80000aee:	64e2                	ld	s1,24(sp)
    80000af0:	6a02                	ld	s4,0(sp)
    80000af2:	bf69                	j	80000a8c <vmfault+0x1c>

0000000080000af4 <copyout>:
  while(len > 0){
    80000af4:	cad9                	beqz	a3,80000b8a <copyout+0x96>
{
    80000af6:	711d                	addi	sp,sp,-96
    80000af8:	ec86                	sd	ra,88(sp)
    80000afa:	e8a2                	sd	s0,80(sp)
    80000afc:	e4a6                	sd	s1,72(sp)
    80000afe:	e0ca                	sd	s2,64(sp)
    80000b00:	fc4e                	sd	s3,56(sp)
    80000b02:	f852                	sd	s4,48(sp)
    80000b04:	f456                	sd	s5,40(sp)
    80000b06:	f05a                	sd	s6,32(sp)
    80000b08:	ec5e                	sd	s7,24(sp)
    80000b0a:	e862                	sd	s8,16(sp)
    80000b0c:	e466                	sd	s9,8(sp)
    80000b0e:	e06a                	sd	s10,0(sp)
    80000b10:	1080                	addi	s0,sp,96
    80000b12:	8baa                	mv	s7,a0
    80000b14:	8a2e                	mv	s4,a1
    80000b16:	8b32                	mv	s6,a2
    80000b18:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000b1a:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80000b1c:	5cfd                	li	s9,-1
    80000b1e:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000b22:	6c05                	lui	s8,0x1
    80000b24:	a005                	j	80000b44 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b26:	409a0533          	sub	a0,s4,s1
    80000b2a:	0009061b          	sext.w	a2,s2
    80000b2e:	85da                	mv	a1,s6
    80000b30:	954e                	add	a0,a0,s3
    80000b32:	e8cff0ef          	jal	800001be <memmove>
    len -= n;
    80000b36:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000b3a:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000b3c:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80000b40:	040a8363          	beqz	s5,80000b86 <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80000b44:	01aa74b3          	and	s1,s4,s10
    if (va0 >= MAXVA)
    80000b48:	049ce363          	bltu	s9,s1,80000b8e <copyout+0x9a>
    pa0 = walkaddr(pagetable, va0);
    80000b4c:	85a6                	mv	a1,s1
    80000b4e:	855e                	mv	a0,s7
    80000b50:	94bff0ef          	jal	8000049a <walkaddr>
    80000b54:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80000b56:	e901                	bnez	a0,80000b66 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000b58:	4601                	li	a2,0
    80000b5a:	85a6                	mv	a1,s1
    80000b5c:	855e                	mv	a0,s7
    80000b5e:	f13ff0ef          	jal	80000a70 <vmfault>
    80000b62:	89aa                	mv	s3,a0
    80000b64:	c521                	beqz	a0,80000bac <copyout+0xb8>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000b66:	4601                	li	a2,0
    80000b68:	85a6                	mv	a1,s1
    80000b6a:	855e                	mv	a0,s7
    80000b6c:	887ff0ef          	jal	800003f2 <walk>
    80000b70:	c121                	beqz	a0,80000bb0 <copyout+0xbc>
    if((*pte & PTE_W) == 0)
    80000b72:	611c                	ld	a5,0(a0)
    80000b74:	8b91                	andi	a5,a5,4
    80000b76:	cf9d                	beqz	a5,80000bb4 <copyout+0xc0>
    n = PGSIZE - (dstva - va0);
    80000b78:	41448933          	sub	s2,s1,s4
    80000b7c:	9962                	add	s2,s2,s8
    if(n > len)
    80000b7e:	fb2af4e3          	bgeu	s5,s2,80000b26 <copyout+0x32>
    80000b82:	8956                	mv	s2,s5
    80000b84:	b74d                	j	80000b26 <copyout+0x32>
  return 0;
    80000b86:	4501                	li	a0,0
    80000b88:	a021                	j	80000b90 <copyout+0x9c>
    80000b8a:	4501                	li	a0,0
}
    80000b8c:	8082                	ret
      return -1;
    80000b8e:	557d                	li	a0,-1
}
    80000b90:	60e6                	ld	ra,88(sp)
    80000b92:	6446                	ld	s0,80(sp)
    80000b94:	64a6                	ld	s1,72(sp)
    80000b96:	6906                	ld	s2,64(sp)
    80000b98:	79e2                	ld	s3,56(sp)
    80000b9a:	7a42                	ld	s4,48(sp)
    80000b9c:	7aa2                	ld	s5,40(sp)
    80000b9e:	7b02                	ld	s6,32(sp)
    80000ba0:	6be2                	ld	s7,24(sp)
    80000ba2:	6c42                	ld	s8,16(sp)
    80000ba4:	6ca2                	ld	s9,8(sp)
    80000ba6:	6d02                	ld	s10,0(sp)
    80000ba8:	6125                	addi	sp,sp,96
    80000baa:	8082                	ret
        return -1;
    80000bac:	557d                	li	a0,-1
    80000bae:	b7cd                	j	80000b90 <copyout+0x9c>
      return -1;
    80000bb0:	557d                	li	a0,-1
    80000bb2:	bff9                	j	80000b90 <copyout+0x9c>
      return -1;
    80000bb4:	557d                	li	a0,-1
    80000bb6:	bfe9                	j	80000b90 <copyout+0x9c>

0000000080000bb8 <copyin>:
  while(len > 0){
    80000bb8:	c6c9                	beqz	a3,80000c42 <copyin+0x8a>
{
    80000bba:	715d                	addi	sp,sp,-80
    80000bbc:	e486                	sd	ra,72(sp)
    80000bbe:	e0a2                	sd	s0,64(sp)
    80000bc0:	fc26                	sd	s1,56(sp)
    80000bc2:	f84a                	sd	s2,48(sp)
    80000bc4:	f44e                	sd	s3,40(sp)
    80000bc6:	f052                	sd	s4,32(sp)
    80000bc8:	ec56                	sd	s5,24(sp)
    80000bca:	e85a                	sd	s6,16(sp)
    80000bcc:	e45e                	sd	s7,8(sp)
    80000bce:	e062                	sd	s8,0(sp)
    80000bd0:	0880                	addi	s0,sp,80
    80000bd2:	8baa                	mv	s7,a0
    80000bd4:	8aae                	mv	s5,a1
    80000bd6:	8932                	mv	s2,a2
    80000bd8:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000bda:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000bdc:	6b05                	lui	s6,0x1
    80000bde:	a035                	j	80000c0a <copyin+0x52>
    80000be0:	412984b3          	sub	s1,s3,s2
    80000be4:	94da                	add	s1,s1,s6
    if(n > len)
    80000be6:	009a7363          	bgeu	s4,s1,80000bec <copyin+0x34>
    80000bea:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bec:	413905b3          	sub	a1,s2,s3
    80000bf0:	0004861b          	sext.w	a2,s1
    80000bf4:	95aa                	add	a1,a1,a0
    80000bf6:	8556                	mv	a0,s5
    80000bf8:	dc6ff0ef          	jal	800001be <memmove>
    len -= n;
    80000bfc:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000c00:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000c02:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000c06:	020a0163          	beqz	s4,80000c28 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000c0a:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000c0e:	85ce                	mv	a1,s3
    80000c10:	855e                	mv	a0,s7
    80000c12:	889ff0ef          	jal	8000049a <walkaddr>
    if(pa0 == 0) {
    80000c16:	f569                	bnez	a0,80000be0 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000c18:	4601                	li	a2,0
    80000c1a:	85ce                	mv	a1,s3
    80000c1c:	855e                	mv	a0,s7
    80000c1e:	e53ff0ef          	jal	80000a70 <vmfault>
    80000c22:	fd5d                	bnez	a0,80000be0 <copyin+0x28>
        return -1;
    80000c24:	557d                	li	a0,-1
    80000c26:	a011                	j	80000c2a <copyin+0x72>
  return 0;
    80000c28:	4501                	li	a0,0
}
    80000c2a:	60a6                	ld	ra,72(sp)
    80000c2c:	6406                	ld	s0,64(sp)
    80000c2e:	74e2                	ld	s1,56(sp)
    80000c30:	7942                	ld	s2,48(sp)
    80000c32:	79a2                	ld	s3,40(sp)
    80000c34:	7a02                	ld	s4,32(sp)
    80000c36:	6ae2                	ld	s5,24(sp)
    80000c38:	6b42                	ld	s6,16(sp)
    80000c3a:	6ba2                	ld	s7,8(sp)
    80000c3c:	6c02                	ld	s8,0(sp)
    80000c3e:	6161                	addi	sp,sp,80
    80000c40:	8082                	ret
  return 0;
    80000c42:	4501                	li	a0,0
}
    80000c44:	8082                	ret

0000000080000c46 <pgpte>:



#ifdef LAB_PGTBL
pte_t*
pgpte(pagetable_t pagetable, uint64 va) {
    80000c46:	1141                	addi	sp,sp,-16
    80000c48:	e406                	sd	ra,8(sp)
    80000c4a:	e022                	sd	s0,0(sp)
    80000c4c:	0800                	addi	s0,sp,16
  return walk(pagetable, va, 0);
    80000c4e:	4601                	li	a2,0
    80000c50:	fa2ff0ef          	jal	800003f2 <walk>
}
    80000c54:	60a2                	ld	ra,8(sp)
    80000c56:	6402                	ld	s0,0(sp)
    80000c58:	0141                	addi	sp,sp,16
    80000c5a:	8082                	ret

0000000080000c5c <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c5c:	715d                	addi	sp,sp,-80
    80000c5e:	e486                	sd	ra,72(sp)
    80000c60:	e0a2                	sd	s0,64(sp)
    80000c62:	fc26                	sd	s1,56(sp)
    80000c64:	f84a                	sd	s2,48(sp)
    80000c66:	f44e                	sd	s3,40(sp)
    80000c68:	f052                	sd	s4,32(sp)
    80000c6a:	ec56                	sd	s5,24(sp)
    80000c6c:	e85a                	sd	s6,16(sp)
    80000c6e:	e45e                	sd	s7,8(sp)
    80000c70:	e062                	sd	s8,0(sp)
    80000c72:	0880                	addi	s0,sp,80
    80000c74:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c76:	00007497          	auipc	s1,0x7
    80000c7a:	0ba48493          	addi	s1,s1,186 # 80007d30 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c7e:	8c26                	mv	s8,s1
    80000c80:	410417b7          	lui	a5,0x41041
    80000c84:	04078793          	addi	a5,a5,64 # 41041040 <_entry-0x3efbefc0>
    80000c88:	01e79993          	slli	s3,a5,0x1e
    80000c8c:	99be                	add	s3,s3,a5
    80000c8e:	fff9c993          	not	s3,s3
    80000c92:	01000937          	lui	s2,0x1000
    80000c96:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000c98:	093a                	slli	s2,s2,0xe
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c9a:	4b99                	li	s7,6
    80000c9c:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c9e:	0000fa97          	auipc	s5,0xf
    80000ca2:	e92a8a93          	addi	s5,s5,-366 # 8000fb30 <tickslock>
    char *pa = kalloc();
    80000ca6:	c5eff0ef          	jal	80000104 <kalloc>
    80000caa:	862a                	mv	a2,a0
    if(pa == 0)
    80000cac:	cd1d                	beqz	a0,80000cea <proc_mapstacks+0x8e>
    uint64 va = KSTACK((int) (p - proc));
    80000cae:	418485b3          	sub	a1,s1,s8
    80000cb2:	858d                	srai	a1,a1,0x3
    80000cb4:	033585b3          	mul	a1,a1,s3
    80000cb8:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000cbc:	875e                	mv	a4,s7
    80000cbe:	86da                	mv	a3,s6
    80000cc0:	40b905b3          	sub	a1,s2,a1
    80000cc4:	8552                	mv	a0,s4
    80000cc6:	8d5ff0ef          	jal	8000059a <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cca:	1f848493          	addi	s1,s1,504
    80000cce:	fd549ce3          	bne	s1,s5,80000ca6 <proc_mapstacks+0x4a>
  }
}
    80000cd2:	60a6                	ld	ra,72(sp)
    80000cd4:	6406                	ld	s0,64(sp)
    80000cd6:	74e2                	ld	s1,56(sp)
    80000cd8:	7942                	ld	s2,48(sp)
    80000cda:	79a2                	ld	s3,40(sp)
    80000cdc:	7a02                	ld	s4,32(sp)
    80000cde:	6ae2                	ld	s5,24(sp)
    80000ce0:	6b42                	ld	s6,16(sp)
    80000ce2:	6ba2                	ld	s7,8(sp)
    80000ce4:	6c02                	ld	s8,0(sp)
    80000ce6:	6161                	addi	sp,sp,80
    80000ce8:	8082                	ret
      panic("kalloc");
    80000cea:	00006517          	auipc	a0,0x6
    80000cee:	42650513          	addi	a0,a0,1062 # 80007110 <etext+0x110>
    80000cf2:	255040ef          	jal	80005746 <panic>

0000000080000cf6 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000cf6:	7139                	addi	sp,sp,-64
    80000cf8:	fc06                	sd	ra,56(sp)
    80000cfa:	f822                	sd	s0,48(sp)
    80000cfc:	f426                	sd	s1,40(sp)
    80000cfe:	f04a                	sd	s2,32(sp)
    80000d00:	ec4e                	sd	s3,24(sp)
    80000d02:	e852                	sd	s4,16(sp)
    80000d04:	e456                	sd	s5,8(sp)
    80000d06:	e05a                	sd	s6,0(sp)
    80000d08:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000d0a:	00006597          	auipc	a1,0x6
    80000d0e:	40e58593          	addi	a1,a1,1038 # 80007118 <etext+0x118>
    80000d12:	00007517          	auipc	a0,0x7
    80000d16:	bee50513          	addi	a0,a0,-1042 # 80007900 <pid_lock>
    80000d1a:	465040ef          	jal	8000597e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000d1e:	00006597          	auipc	a1,0x6
    80000d22:	40258593          	addi	a1,a1,1026 # 80007120 <etext+0x120>
    80000d26:	00007517          	auipc	a0,0x7
    80000d2a:	bf250513          	addi	a0,a0,-1038 # 80007918 <wait_lock>
    80000d2e:	451040ef          	jal	8000597e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d32:	00007497          	auipc	s1,0x7
    80000d36:	ffe48493          	addi	s1,s1,-2 # 80007d30 <proc>
      initlock(&p->lock, "proc");
    80000d3a:	00006a97          	auipc	s5,0x6
    80000d3e:	3f6a8a93          	addi	s5,s5,1014 # 80007130 <etext+0x130>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000d42:	8a26                	mv	s4,s1
    80000d44:	410417b7          	lui	a5,0x41041
    80000d48:	04078793          	addi	a5,a5,64 # 41041040 <_entry-0x3efbefc0>
    80000d4c:	01e79993          	slli	s3,a5,0x1e
    80000d50:	99be                	add	s3,s3,a5
    80000d52:	fff9c993          	not	s3,s3
    80000d56:	01000937          	lui	s2,0x1000
    80000d5a:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80000d5c:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d5e:	0000fb17          	auipc	s6,0xf
    80000d62:	dd2b0b13          	addi	s6,s6,-558 # 8000fb30 <tickslock>
      initlock(&p->lock, "proc");
    80000d66:	85d6                	mv	a1,s5
    80000d68:	8526                	mv	a0,s1
    80000d6a:	415040ef          	jal	8000597e <initlock>
      p->state = UNUSED;
    80000d6e:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d72:	414487b3          	sub	a5,s1,s4
    80000d76:	878d                	srai	a5,a5,0x3
    80000d78:	033787b3          	mul	a5,a5,s3
    80000d7c:	00d7979b          	slliw	a5,a5,0xd
    80000d80:	40f907b3          	sub	a5,s2,a5
    80000d84:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d86:	1f848493          	addi	s1,s1,504
    80000d8a:	fd649ee3          	bne	s1,s6,80000d66 <procinit+0x70>
  }
}
    80000d8e:	70e2                	ld	ra,56(sp)
    80000d90:	7442                	ld	s0,48(sp)
    80000d92:	74a2                	ld	s1,40(sp)
    80000d94:	7902                	ld	s2,32(sp)
    80000d96:	69e2                	ld	s3,24(sp)
    80000d98:	6a42                	ld	s4,16(sp)
    80000d9a:	6aa2                	ld	s5,8(sp)
    80000d9c:	6b02                	ld	s6,0(sp)
    80000d9e:	6121                	addi	sp,sp,64
    80000da0:	8082                	ret

0000000080000da2 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000da2:	1141                	addi	sp,sp,-16
    80000da4:	e406                	sd	ra,8(sp)
    80000da6:	e022                	sd	s0,0(sp)
    80000da8:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000daa:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000dac:	2501                	sext.w	a0,a0
    80000dae:	60a2                	ld	ra,8(sp)
    80000db0:	6402                	ld	s0,0(sp)
    80000db2:	0141                	addi	sp,sp,16
    80000db4:	8082                	ret

0000000080000db6 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000db6:	1141                	addi	sp,sp,-16
    80000db8:	e406                	sd	ra,8(sp)
    80000dba:	e022                	sd	s0,0(sp)
    80000dbc:	0800                	addi	s0,sp,16
    80000dbe:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000dc0:	2781                	sext.w	a5,a5
    80000dc2:	079e                	slli	a5,a5,0x7
  return c;
}
    80000dc4:	00007517          	auipc	a0,0x7
    80000dc8:	b6c50513          	addi	a0,a0,-1172 # 80007930 <cpus>
    80000dcc:	953e                	add	a0,a0,a5
    80000dce:	60a2                	ld	ra,8(sp)
    80000dd0:	6402                	ld	s0,0(sp)
    80000dd2:	0141                	addi	sp,sp,16
    80000dd4:	8082                	ret

0000000080000dd6 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000dd6:	1101                	addi	sp,sp,-32
    80000dd8:	ec06                	sd	ra,24(sp)
    80000dda:	e822                	sd	s0,16(sp)
    80000ddc:	e426                	sd	s1,8(sp)
    80000dde:	1000                	addi	s0,sp,32
  push_off();
    80000de0:	3e5040ef          	jal	800059c4 <push_off>
    80000de4:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000de6:	2781                	sext.w	a5,a5
    80000de8:	079e                	slli	a5,a5,0x7
    80000dea:	00007717          	auipc	a4,0x7
    80000dee:	b1670713          	addi	a4,a4,-1258 # 80007900 <pid_lock>
    80000df2:	97ba                	add	a5,a5,a4
    80000df4:	7b9c                	ld	a5,48(a5)
    80000df6:	84be                	mv	s1,a5
  pop_off();
    80000df8:	455040ef          	jal	80005a4c <pop_off>
  return p;
}
    80000dfc:	8526                	mv	a0,s1
    80000dfe:	60e2                	ld	ra,24(sp)
    80000e00:	6442                	ld	s0,16(sp)
    80000e02:	64a2                	ld	s1,8(sp)
    80000e04:	6105                	addi	sp,sp,32
    80000e06:	8082                	ret

0000000080000e08 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000e08:	7179                	addi	sp,sp,-48
    80000e0a:	f406                	sd	ra,40(sp)
    80000e0c:	f022                	sd	s0,32(sp)
    80000e0e:	ec26                	sd	s1,24(sp)
    80000e10:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000e12:	fc5ff0ef          	jal	80000dd6 <myproc>
    80000e16:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000e18:	485040ef          	jal	80005a9c <release>

  if (first) {
    80000e1c:	00007797          	auipc	a5,0x7
    80000e20:	a847a783          	lw	a5,-1404(a5) # 800078a0 <first.1>
    80000e24:	cf95                	beqz	a5,80000e60 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000e26:	4505                	li	a0,1
    80000e28:	435010ef          	jal	80002a5c <fsinit>

    first = 0;
    80000e2c:	00007797          	auipc	a5,0x7
    80000e30:	a607aa23          	sw	zero,-1420(a5) # 800078a0 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000e34:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000e38:	00006797          	auipc	a5,0x6
    80000e3c:	30078793          	addi	a5,a5,768 # 80007138 <etext+0x138>
    80000e40:	fcf43823          	sd	a5,-48(s0)
    80000e44:	fc043c23          	sd	zero,-40(s0)
    80000e48:	fd040593          	addi	a1,s0,-48
    80000e4c:	853e                	mv	a0,a5
    80000e4e:	58d020ef          	jal	80003bda <kexec>
    80000e52:	6cbc                	ld	a5,88(s1)
    80000e54:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000e56:	6cbc                	ld	a5,88(s1)
    80000e58:	7bb8                	ld	a4,112(a5)
    80000e5a:	57fd                	li	a5,-1
    80000e5c:	02f70d63          	beq	a4,a5,80000e96 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e60:	327000ef          	jal	80001986 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e64:	68a8                	ld	a0,80(s1)
    80000e66:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e68:	04000737          	lui	a4,0x4000
    80000e6c:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e6e:	0732                	slli	a4,a4,0xc
    80000e70:	00005797          	auipc	a5,0x5
    80000e74:	22c78793          	addi	a5,a5,556 # 8000609c <userret>
    80000e78:	00005697          	auipc	a3,0x5
    80000e7c:	18868693          	addi	a3,a3,392 # 80006000 <_trampoline>
    80000e80:	8f95                	sub	a5,a5,a3
    80000e82:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e84:	577d                	li	a4,-1
    80000e86:	177e                	slli	a4,a4,0x3f
    80000e88:	8d59                	or	a0,a0,a4
    80000e8a:	9782                	jalr	a5
}
    80000e8c:	70a2                	ld	ra,40(sp)
    80000e8e:	7402                	ld	s0,32(sp)
    80000e90:	64e2                	ld	s1,24(sp)
    80000e92:	6145                	addi	sp,sp,48
    80000e94:	8082                	ret
      panic("exec");
    80000e96:	00006517          	auipc	a0,0x6
    80000e9a:	2aa50513          	addi	a0,a0,682 # 80007140 <etext+0x140>
    80000e9e:	0a9040ef          	jal	80005746 <panic>

0000000080000ea2 <allocpid>:
{
    80000ea2:	1101                	addi	sp,sp,-32
    80000ea4:	ec06                	sd	ra,24(sp)
    80000ea6:	e822                	sd	s0,16(sp)
    80000ea8:	e426                	sd	s1,8(sp)
    80000eaa:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000eac:	00007517          	auipc	a0,0x7
    80000eb0:	a5450513          	addi	a0,a0,-1452 # 80007900 <pid_lock>
    80000eb4:	355040ef          	jal	80005a08 <acquire>
  pid = nextpid;
    80000eb8:	00007797          	auipc	a5,0x7
    80000ebc:	9ec78793          	addi	a5,a5,-1556 # 800078a4 <nextpid>
    80000ec0:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000ec2:	0014871b          	addiw	a4,s1,1
    80000ec6:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000ec8:	00007517          	auipc	a0,0x7
    80000ecc:	a3850513          	addi	a0,a0,-1480 # 80007900 <pid_lock>
    80000ed0:	3cd040ef          	jal	80005a9c <release>
}
    80000ed4:	8526                	mv	a0,s1
    80000ed6:	60e2                	ld	ra,24(sp)
    80000ed8:	6442                	ld	s0,16(sp)
    80000eda:	64a2                	ld	s1,8(sp)
    80000edc:	6105                	addi	sp,sp,32
    80000ede:	8082                	ret

0000000080000ee0 <proc_pagetable>:
{
    80000ee0:	1101                	addi	sp,sp,-32
    80000ee2:	ec06                	sd	ra,24(sp)
    80000ee4:	e822                	sd	s0,16(sp)
    80000ee6:	e426                	sd	s1,8(sp)
    80000ee8:	e04a                	sd	s2,0(sp)
    80000eea:	1000                	addi	s0,sp,32
    80000eec:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000eee:	f9eff0ef          	jal	8000068c <uvmcreate>
    80000ef2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000ef4:	c929                	beqz	a0,80000f46 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000ef6:	4729                	li	a4,10
    80000ef8:	00005697          	auipc	a3,0x5
    80000efc:	10868693          	addi	a3,a3,264 # 80006000 <_trampoline>
    80000f00:	6605                	lui	a2,0x1
    80000f02:	040005b7          	lui	a1,0x4000
    80000f06:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f08:	05b2                	slli	a1,a1,0xc
    80000f0a:	ddaff0ef          	jal	800004e4 <mappages>
    80000f0e:	04054363          	bltz	a0,80000f54 <proc_pagetable+0x74>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f12:	4719                	li	a4,6
    80000f14:	05893683          	ld	a3,88(s2)
    80000f18:	6605                	lui	a2,0x1
    80000f1a:	020005b7          	lui	a1,0x2000
    80000f1e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f20:	05b6                	slli	a1,a1,0xd
    80000f22:	8526                	mv	a0,s1
    80000f24:	dc0ff0ef          	jal	800004e4 <mappages>
    80000f28:	02054c63          	bltz	a0,80000f60 <proc_pagetable+0x80>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80000f2c:	4749                	li	a4,18
    80000f2e:	06093683          	ld	a3,96(s2)
    80000f32:	6605                	lui	a2,0x1
    80000f34:	040005b7          	lui	a1,0x4000
    80000f38:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80000f3a:	05b2                	slli	a1,a1,0xc
    80000f3c:	8526                	mv	a0,s1
    80000f3e:	da6ff0ef          	jal	800004e4 <mappages>
    80000f42:	02054e63          	bltz	a0,80000f7e <proc_pagetable+0x9e>
}
    80000f46:	8526                	mv	a0,s1
    80000f48:	60e2                	ld	ra,24(sp)
    80000f4a:	6442                	ld	s0,16(sp)
    80000f4c:	64a2                	ld	s1,8(sp)
    80000f4e:	6902                	ld	s2,0(sp)
    80000f50:	6105                	addi	sp,sp,32
    80000f52:	8082                	ret
    uvmfree(pagetable, 0);
    80000f54:	4581                	li	a1,0
    80000f56:	8526                	mv	a0,s1
    80000f58:	94bff0ef          	jal	800008a2 <uvmfree>
    return 0;
    80000f5c:	4481                	li	s1,0
    80000f5e:	b7e5                	j	80000f46 <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f60:	4681                	li	a3,0
    80000f62:	4605                	li	a2,1
    80000f64:	040005b7          	lui	a1,0x4000
    80000f68:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f6a:	05b2                	slli	a1,a1,0xc
    80000f6c:	8526                	mv	a0,s1
    80000f6e:	f44ff0ef          	jal	800006b2 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f72:	4581                	li	a1,0
    80000f74:	8526                	mv	a0,s1
    80000f76:	92dff0ef          	jal	800008a2 <uvmfree>
    return 0;
    80000f7a:	4481                	li	s1,0
    80000f7c:	b7e9                	j	80000f46 <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f7e:	4681                	li	a3,0
    80000f80:	4605                	li	a2,1
    80000f82:	040005b7          	lui	a1,0x4000
    80000f86:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f88:	05b2                	slli	a1,a1,0xc
    80000f8a:	8526                	mv	a0,s1
    80000f8c:	f26ff0ef          	jal	800006b2 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f90:	4581                	li	a1,0
    80000f92:	8526                	mv	a0,s1
    80000f94:	90fff0ef          	jal	800008a2 <uvmfree>
    return 0;
    80000f98:	4481                	li	s1,0
    80000f9a:	b775                	j	80000f46 <proc_pagetable+0x66>

0000000080000f9c <proc_freepagetable>:
{
    80000f9c:	1101                	addi	sp,sp,-32
    80000f9e:	ec06                	sd	ra,24(sp)
    80000fa0:	e822                	sd	s0,16(sp)
    80000fa2:	e426                	sd	s1,8(sp)
    80000fa4:	e04a                	sd	s2,0(sp)
    80000fa6:	1000                	addi	s0,sp,32
    80000fa8:	84aa                	mv	s1,a0
    80000faa:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fac:	4681                	li	a3,0
    80000fae:	4605                	li	a2,1
    80000fb0:	040005b7          	lui	a1,0x4000
    80000fb4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000fb6:	05b2                	slli	a1,a1,0xc
    80000fb8:	efaff0ef          	jal	800006b2 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fbc:	4681                	li	a3,0
    80000fbe:	4605                	li	a2,1
    80000fc0:	020005b7          	lui	a1,0x2000
    80000fc4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000fc6:	05b6                	slli	a1,a1,0xd
    80000fc8:	8526                	mv	a0,s1
    80000fca:	ee8ff0ef          	jal	800006b2 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80000fce:	4681                	li	a3,0
    80000fd0:	4605                	li	a2,1
    80000fd2:	040005b7          	lui	a1,0x4000
    80000fd6:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80000fd8:	05b2                	slli	a1,a1,0xc
    80000fda:	8526                	mv	a0,s1
    80000fdc:	ed6ff0ef          	jal	800006b2 <uvmunmap>
  uvmfree(pagetable, sz);
    80000fe0:	85ca                	mv	a1,s2
    80000fe2:	8526                	mv	a0,s1
    80000fe4:	8bfff0ef          	jal	800008a2 <uvmfree>
}
    80000fe8:	60e2                	ld	ra,24(sp)
    80000fea:	6442                	ld	s0,16(sp)
    80000fec:	64a2                	ld	s1,8(sp)
    80000fee:	6902                	ld	s2,0(sp)
    80000ff0:	6105                	addi	sp,sp,32
    80000ff2:	8082                	ret

0000000080000ff4 <freeproc>:
{
    80000ff4:	1101                	addi	sp,sp,-32
    80000ff6:	ec06                	sd	ra,24(sp)
    80000ff8:	e822                	sd	s0,16(sp)
    80000ffa:	e426                	sd	s1,8(sp)
    80000ffc:	1000                	addi	s0,sp,32
    80000ffe:	84aa                	mv	s1,a0
  if(p->trapframe)
    80001000:	6d28                	ld	a0,88(a0)
    80001002:	c119                	beqz	a0,80001008 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001004:	818ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80001008:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    8000100c:	70a8                	ld	a0,96(s1)
    8000100e:	c119                	beqz	a0,80001014 <freeproc+0x20>
    kfree((void*)p->usyscall);
    80001010:	80cff0ef          	jal	8000001c <kfree>
  p->usyscall = 0;
    80001014:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001018:	68a8                	ld	a0,80(s1)
    8000101a:	c501                	beqz	a0,80001022 <freeproc+0x2e>
    proc_freepagetable(p->pagetable, p->sz);
    8000101c:	64ac                	ld	a1,72(s1)
    8000101e:	f7fff0ef          	jal	80000f9c <proc_freepagetable>
  p->pagetable = 0;
    80001022:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001026:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000102a:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    8000102e:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001032:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    80001036:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000103a:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    8000103e:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001042:	0004ac23          	sw	zero,24(s1)
}
    80001046:	60e2                	ld	ra,24(sp)
    80001048:	6442                	ld	s0,16(sp)
    8000104a:	64a2                	ld	s1,8(sp)
    8000104c:	6105                	addi	sp,sp,32
    8000104e:	8082                	ret

0000000080001050 <allocproc>:
{
    80001050:	1101                	addi	sp,sp,-32
    80001052:	ec06                	sd	ra,24(sp)
    80001054:	e822                	sd	s0,16(sp)
    80001056:	e426                	sd	s1,8(sp)
    80001058:	e04a                	sd	s2,0(sp)
    8000105a:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000105c:	00007497          	auipc	s1,0x7
    80001060:	cd448493          	addi	s1,s1,-812 # 80007d30 <proc>
    80001064:	0000f917          	auipc	s2,0xf
    80001068:	acc90913          	addi	s2,s2,-1332 # 8000fb30 <tickslock>
    acquire(&p->lock);
    8000106c:	8526                	mv	a0,s1
    8000106e:	19b040ef          	jal	80005a08 <acquire>
    if(p->state == UNUSED) {
    80001072:	4c9c                	lw	a5,24(s1)
    80001074:	cb91                	beqz	a5,80001088 <allocproc+0x38>
      release(&p->lock);
    80001076:	8526                	mv	a0,s1
    80001078:	225040ef          	jal	80005a9c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000107c:	1f848493          	addi	s1,s1,504
    80001080:	ff2496e3          	bne	s1,s2,8000106c <allocproc+0x1c>
  return 0;
    80001084:	4481                	li	s1,0
    80001086:	a889                	j	800010d8 <allocproc+0x88>
  p->pid = allocpid();
    80001088:	e1bff0ef          	jal	80000ea2 <allocpid>
    8000108c:	d888                	sw	a0,48(s1)
  p->state = USED;
    8000108e:	4785                	li	a5,1
    80001090:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001092:	872ff0ef          	jal	80000104 <kalloc>
    80001096:	892a                	mv	s2,a0
    80001098:	eca8                	sd	a0,88(s1)
    8000109a:	c531                	beqz	a0,800010e6 <allocproc+0x96>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    8000109c:	868ff0ef          	jal	80000104 <kalloc>
    800010a0:	892a                	mv	s2,a0
    800010a2:	f0a8                	sd	a0,96(s1)
    800010a4:	c929                	beqz	a0,800010f6 <allocproc+0xa6>
  p->pagetable = proc_pagetable(p);
    800010a6:	8526                	mv	a0,s1
    800010a8:	e39ff0ef          	jal	80000ee0 <proc_pagetable>
    800010ac:	892a                	mv	s2,a0
    800010ae:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800010b0:	c939                	beqz	a0,80001106 <allocproc+0xb6>
  p->usyscall->pid = p->pid;
    800010b2:	70bc                	ld	a5,96(s1)
    800010b4:	5898                	lw	a4,48(s1)
    800010b6:	c398                	sw	a4,0(a5)
  memset(&p->context, 0, sizeof(p->context));
    800010b8:	07000613          	li	a2,112
    800010bc:	4581                	li	a1,0
    800010be:	06848513          	addi	a0,s1,104
    800010c2:	89cff0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    800010c6:	00000797          	auipc	a5,0x0
    800010ca:	d4278793          	addi	a5,a5,-702 # 80000e08 <forkret>
    800010ce:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    800010d0:	60bc                	ld	a5,64(s1)
    800010d2:	6705                	lui	a4,0x1
    800010d4:	97ba                	add	a5,a5,a4
    800010d6:	f8bc                	sd	a5,112(s1)
}
    800010d8:	8526                	mv	a0,s1
    800010da:	60e2                	ld	ra,24(sp)
    800010dc:	6442                	ld	s0,16(sp)
    800010de:	64a2                	ld	s1,8(sp)
    800010e0:	6902                	ld	s2,0(sp)
    800010e2:	6105                	addi	sp,sp,32
    800010e4:	8082                	ret
    freeproc(p);
    800010e6:	8526                	mv	a0,s1
    800010e8:	f0dff0ef          	jal	80000ff4 <freeproc>
    release(&p->lock);
    800010ec:	8526                	mv	a0,s1
    800010ee:	1af040ef          	jal	80005a9c <release>
    return 0;
    800010f2:	84ca                	mv	s1,s2
    800010f4:	b7d5                	j	800010d8 <allocproc+0x88>
    freeproc(p);
    800010f6:	8526                	mv	a0,s1
    800010f8:	efdff0ef          	jal	80000ff4 <freeproc>
    release(&p->lock);
    800010fc:	8526                	mv	a0,s1
    800010fe:	19f040ef          	jal	80005a9c <release>
    return 0;
    80001102:	84ca                	mv	s1,s2
    80001104:	bfd1                	j	800010d8 <allocproc+0x88>
    freeproc(p);
    80001106:	8526                	mv	a0,s1
    80001108:	eedff0ef          	jal	80000ff4 <freeproc>
    release(&p->lock);
    8000110c:	8526                	mv	a0,s1
    8000110e:	18f040ef          	jal	80005a9c <release>
    return 0;
    80001112:	84ca                	mv	s1,s2
    80001114:	b7d1                	j	800010d8 <allocproc+0x88>

0000000080001116 <userinit>:
{
    80001116:	1101                	addi	sp,sp,-32
    80001118:	ec06                	sd	ra,24(sp)
    8000111a:	e822                	sd	s0,16(sp)
    8000111c:	e426                	sd	s1,8(sp)
    8000111e:	1000                	addi	s0,sp,32
  p = allocproc();
    80001120:	f31ff0ef          	jal	80001050 <allocproc>
    80001124:	84aa                	mv	s1,a0
  initproc = p;
    80001126:	00006797          	auipc	a5,0x6
    8000112a:	78a7bd23          	sd	a0,1946(a5) # 800078c0 <initproc>
  p->cwd = namei("/");
    8000112e:	00006517          	auipc	a0,0x6
    80001132:	01a50513          	addi	a0,a0,26 # 80007148 <etext+0x148>
    80001136:	661010ef          	jal	80002f96 <namei>
    8000113a:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    8000113e:	478d                	li	a5,3
    80001140:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001142:	8526                	mv	a0,s1
    80001144:	159040ef          	jal	80005a9c <release>
}
    80001148:	60e2                	ld	ra,24(sp)
    8000114a:	6442                	ld	s0,16(sp)
    8000114c:	64a2                	ld	s1,8(sp)
    8000114e:	6105                	addi	sp,sp,32
    80001150:	8082                	ret

0000000080001152 <growproc>:
{
    80001152:	1101                	addi	sp,sp,-32
    80001154:	ec06                	sd	ra,24(sp)
    80001156:	e822                	sd	s0,16(sp)
    80001158:	e426                	sd	s1,8(sp)
    8000115a:	e04a                	sd	s2,0(sp)
    8000115c:	1000                	addi	s0,sp,32
    8000115e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001160:	c77ff0ef          	jal	80000dd6 <myproc>
    80001164:	84aa                	mv	s1,a0
  sz = p->sz;
    80001166:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001168:	01204c63          	bgtz	s2,80001180 <growproc+0x2e>
  } else if(n < 0){
    8000116c:	02094463          	bltz	s2,80001194 <growproc+0x42>
  p->sz = sz;
    80001170:	e4ac                	sd	a1,72(s1)
  return 0;
    80001172:	4501                	li	a0,0
}
    80001174:	60e2                	ld	ra,24(sp)
    80001176:	6442                	ld	s0,16(sp)
    80001178:	64a2                	ld	s1,8(sp)
    8000117a:	6902                	ld	s2,0(sp)
    8000117c:	6105                	addi	sp,sp,32
    8000117e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001180:	4691                	li	a3,4
    80001182:	00b90633          	add	a2,s2,a1
    80001186:	6928                	ld	a0,80(a0)
    80001188:	e14ff0ef          	jal	8000079c <uvmalloc>
    8000118c:	85aa                	mv	a1,a0
    8000118e:	f16d                	bnez	a0,80001170 <growproc+0x1e>
      return -1;
    80001190:	557d                	li	a0,-1
    80001192:	b7cd                	j	80001174 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001194:	00b90633          	add	a2,s2,a1
    80001198:	6928                	ld	a0,80(a0)
    8000119a:	dbeff0ef          	jal	80000758 <uvmdealloc>
    8000119e:	85aa                	mv	a1,a0
    800011a0:	bfc1                	j	80001170 <growproc+0x1e>

00000000800011a2 <kfork>:
{
    800011a2:	7139                	addi	sp,sp,-64
    800011a4:	fc06                	sd	ra,56(sp)
    800011a6:	f822                	sd	s0,48(sp)
    800011a8:	f426                	sd	s1,40(sp)
    800011aa:	e456                	sd	s5,8(sp)
    800011ac:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800011ae:	c29ff0ef          	jal	80000dd6 <myproc>
    800011b2:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800011b4:	e9dff0ef          	jal	80001050 <allocproc>
    800011b8:	0e050a63          	beqz	a0,800012ac <kfork+0x10a>
    800011bc:	e852                	sd	s4,16(sp)
    800011be:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800011c0:	048ab603          	ld	a2,72(s5)
    800011c4:	692c                	ld	a1,80(a0)
    800011c6:	050ab503          	ld	a0,80(s5)
    800011ca:	f0aff0ef          	jal	800008d4 <uvmcopy>
    800011ce:	04054863          	bltz	a0,8000121e <kfork+0x7c>
    800011d2:	f04a                	sd	s2,32(sp)
    800011d4:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800011d6:	048ab783          	ld	a5,72(s5)
    800011da:	04fa3423          	sd	a5,72(s4) # 1048 <_entry-0x7fffefb8>
  *(np->trapframe) = *(p->trapframe);
    800011de:	058ab683          	ld	a3,88(s5)
    800011e2:	87b6                	mv	a5,a3
    800011e4:	058a3703          	ld	a4,88(s4)
    800011e8:	12068693          	addi	a3,a3,288
    800011ec:	6388                	ld	a0,0(a5)
    800011ee:	678c                	ld	a1,8(a5)
    800011f0:	6b90                	ld	a2,16(a5)
    800011f2:	e308                	sd	a0,0(a4)
    800011f4:	e70c                	sd	a1,8(a4)
    800011f6:	eb10                	sd	a2,16(a4)
    800011f8:	6f90                	ld	a2,24(a5)
    800011fa:	ef10                	sd	a2,24(a4)
    800011fc:	02078793          	addi	a5,a5,32
    80001200:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001204:	fed794e3          	bne	a5,a3,800011ec <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001208:	058a3783          	ld	a5,88(s4)
    8000120c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001210:	0d8a8493          	addi	s1,s5,216
    80001214:	0d8a0913          	addi	s2,s4,216
    80001218:	158a8993          	addi	s3,s5,344
    8000121c:	a831                	j	80001238 <kfork+0x96>
    freeproc(np);
    8000121e:	8552                	mv	a0,s4
    80001220:	dd5ff0ef          	jal	80000ff4 <freeproc>
    release(&np->lock);
    80001224:	8552                	mv	a0,s4
    80001226:	077040ef          	jal	80005a9c <release>
    return -1;
    8000122a:	54fd                	li	s1,-1
    8000122c:	6a42                	ld	s4,16(sp)
    8000122e:	a885                	j	8000129e <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001230:	04a1                	addi	s1,s1,8
    80001232:	0921                	addi	s2,s2,8
    80001234:	01348963          	beq	s1,s3,80001246 <kfork+0xa4>
    if(p->ofile[i])
    80001238:	6088                	ld	a0,0(s1)
    8000123a:	d97d                	beqz	a0,80001230 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    8000123c:	316020ef          	jal	80003552 <filedup>
    80001240:	00a93023          	sd	a0,0(s2)
    80001244:	b7f5                	j	80001230 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001246:	158ab503          	ld	a0,344(s5)
    8000124a:	4e8010ef          	jal	80002732 <idup>
    8000124e:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001252:	4641                	li	a2,16
    80001254:	160a8593          	addi	a1,s5,352
    80001258:	160a0513          	addi	a0,s4,352
    8000125c:	856ff0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    80001260:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001264:	8552                	mv	a0,s4
    80001266:	037040ef          	jal	80005a9c <release>
  acquire(&wait_lock);
    8000126a:	00006517          	auipc	a0,0x6
    8000126e:	6ae50513          	addi	a0,a0,1710 # 80007918 <wait_lock>
    80001272:	796040ef          	jal	80005a08 <acquire>
  np->parent = p;
    80001276:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000127a:	00006517          	auipc	a0,0x6
    8000127e:	69e50513          	addi	a0,a0,1694 # 80007918 <wait_lock>
    80001282:	01b040ef          	jal	80005a9c <release>
  acquire(&np->lock);
    80001286:	8552                	mv	a0,s4
    80001288:	780040ef          	jal	80005a08 <acquire>
  np->state = RUNNABLE;
    8000128c:	478d                	li	a5,3
    8000128e:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001292:	8552                	mv	a0,s4
    80001294:	009040ef          	jal	80005a9c <release>
  return pid;
    80001298:	7902                	ld	s2,32(sp)
    8000129a:	69e2                	ld	s3,24(sp)
    8000129c:	6a42                	ld	s4,16(sp)
}
    8000129e:	8526                	mv	a0,s1
    800012a0:	70e2                	ld	ra,56(sp)
    800012a2:	7442                	ld	s0,48(sp)
    800012a4:	74a2                	ld	s1,40(sp)
    800012a6:	6aa2                	ld	s5,8(sp)
    800012a8:	6121                	addi	sp,sp,64
    800012aa:	8082                	ret
    return -1;
    800012ac:	54fd                	li	s1,-1
    800012ae:	bfc5                	j	8000129e <kfork+0xfc>

00000000800012b0 <scheduler>:
{
    800012b0:	715d                	addi	sp,sp,-80
    800012b2:	e486                	sd	ra,72(sp)
    800012b4:	e0a2                	sd	s0,64(sp)
    800012b6:	fc26                	sd	s1,56(sp)
    800012b8:	f84a                	sd	s2,48(sp)
    800012ba:	f44e                	sd	s3,40(sp)
    800012bc:	f052                	sd	s4,32(sp)
    800012be:	ec56                	sd	s5,24(sp)
    800012c0:	e85a                	sd	s6,16(sp)
    800012c2:	e45e                	sd	s7,8(sp)
    800012c4:	e062                	sd	s8,0(sp)
    800012c6:	0880                	addi	s0,sp,80
    800012c8:	8792                	mv	a5,tp
  int id = r_tp();
    800012ca:	2781                	sext.w	a5,a5
  c->proc = 0;
    800012cc:	00779b13          	slli	s6,a5,0x7
    800012d0:	00006717          	auipc	a4,0x6
    800012d4:	63070713          	addi	a4,a4,1584 # 80007900 <pid_lock>
    800012d8:	975a                	add	a4,a4,s6
    800012da:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800012de:	00006717          	auipc	a4,0x6
    800012e2:	65a70713          	addi	a4,a4,1626 # 80007938 <cpus+0x8>
    800012e6:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800012e8:	4c11                	li	s8,4
        c->proc = p;
    800012ea:	079e                	slli	a5,a5,0x7
    800012ec:	00006a17          	auipc	s4,0x6
    800012f0:	614a0a13          	addi	s4,s4,1556 # 80007900 <pid_lock>
    800012f4:	9a3e                	add	s4,s4,a5
        found = 1;
    800012f6:	4b85                	li	s7,1
    800012f8:	a83d                	j	80001336 <scheduler+0x86>
      release(&p->lock);
    800012fa:	8526                	mv	a0,s1
    800012fc:	7a0040ef          	jal	80005a9c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001300:	1f848493          	addi	s1,s1,504
    80001304:	03248563          	beq	s1,s2,8000132e <scheduler+0x7e>
      acquire(&p->lock);
    80001308:	8526                	mv	a0,s1
    8000130a:	6fe040ef          	jal	80005a08 <acquire>
      if(p->state == RUNNABLE) {
    8000130e:	4c9c                	lw	a5,24(s1)
    80001310:	ff3795e3          	bne	a5,s3,800012fa <scheduler+0x4a>
        p->state = RUNNING;
    80001314:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001318:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000131c:	06848593          	addi	a1,s1,104
    80001320:	855a                	mv	a0,s6
    80001322:	5ba000ef          	jal	800018dc <swtch>
        c->proc = 0;
    80001326:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000132a:	8ade                	mv	s5,s7
    8000132c:	b7f9                	j	800012fa <scheduler+0x4a>
    if(found == 0) {
    8000132e:	000a9463          	bnez	s5,80001336 <scheduler+0x86>
      asm volatile("wfi");
    80001332:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001336:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000133a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000133e:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001342:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001346:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001348:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000134c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000134e:	00007497          	auipc	s1,0x7
    80001352:	9e248493          	addi	s1,s1,-1566 # 80007d30 <proc>
      if(p->state == RUNNABLE) {
    80001356:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001358:	0000e917          	auipc	s2,0xe
    8000135c:	7d890913          	addi	s2,s2,2008 # 8000fb30 <tickslock>
    80001360:	b765                	j	80001308 <scheduler+0x58>

0000000080001362 <sched>:
{
    80001362:	7179                	addi	sp,sp,-48
    80001364:	f406                	sd	ra,40(sp)
    80001366:	f022                	sd	s0,32(sp)
    80001368:	ec26                	sd	s1,24(sp)
    8000136a:	e84a                	sd	s2,16(sp)
    8000136c:	e44e                	sd	s3,8(sp)
    8000136e:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001370:	a67ff0ef          	jal	80000dd6 <myproc>
    80001374:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001376:	622040ef          	jal	80005998 <holding>
    8000137a:	c935                	beqz	a0,800013ee <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000137c:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000137e:	2781                	sext.w	a5,a5
    80001380:	079e                	slli	a5,a5,0x7
    80001382:	00006717          	auipc	a4,0x6
    80001386:	57e70713          	addi	a4,a4,1406 # 80007900 <pid_lock>
    8000138a:	97ba                	add	a5,a5,a4
    8000138c:	0a87a703          	lw	a4,168(a5)
    80001390:	4785                	li	a5,1
    80001392:	06f71463          	bne	a4,a5,800013fa <sched+0x98>
  if(p->state == RUNNING)
    80001396:	4c98                	lw	a4,24(s1)
    80001398:	4791                	li	a5,4
    8000139a:	06f70663          	beq	a4,a5,80001406 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000139e:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800013a2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800013a4:	e7bd                	bnez	a5,80001412 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    800013a6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800013a8:	00006917          	auipc	s2,0x6
    800013ac:	55890913          	addi	s2,s2,1368 # 80007900 <pid_lock>
    800013b0:	2781                	sext.w	a5,a5
    800013b2:	079e                	slli	a5,a5,0x7
    800013b4:	97ca                	add	a5,a5,s2
    800013b6:	0ac7a983          	lw	s3,172(a5)
    800013ba:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800013bc:	2781                	sext.w	a5,a5
    800013be:	079e                	slli	a5,a5,0x7
    800013c0:	07a1                	addi	a5,a5,8
    800013c2:	00006597          	auipc	a1,0x6
    800013c6:	56e58593          	addi	a1,a1,1390 # 80007930 <cpus>
    800013ca:	95be                	add	a1,a1,a5
    800013cc:	06848513          	addi	a0,s1,104
    800013d0:	50c000ef          	jal	800018dc <swtch>
    800013d4:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800013d6:	2781                	sext.w	a5,a5
    800013d8:	079e                	slli	a5,a5,0x7
    800013da:	993e                	add	s2,s2,a5
    800013dc:	0b392623          	sw	s3,172(s2)
}
    800013e0:	70a2                	ld	ra,40(sp)
    800013e2:	7402                	ld	s0,32(sp)
    800013e4:	64e2                	ld	s1,24(sp)
    800013e6:	6942                	ld	s2,16(sp)
    800013e8:	69a2                	ld	s3,8(sp)
    800013ea:	6145                	addi	sp,sp,48
    800013ec:	8082                	ret
    panic("sched p->lock");
    800013ee:	00006517          	auipc	a0,0x6
    800013f2:	d6250513          	addi	a0,a0,-670 # 80007150 <etext+0x150>
    800013f6:	350040ef          	jal	80005746 <panic>
    panic("sched locks");
    800013fa:	00006517          	auipc	a0,0x6
    800013fe:	d6650513          	addi	a0,a0,-666 # 80007160 <etext+0x160>
    80001402:	344040ef          	jal	80005746 <panic>
    panic("sched RUNNING");
    80001406:	00006517          	auipc	a0,0x6
    8000140a:	d6a50513          	addi	a0,a0,-662 # 80007170 <etext+0x170>
    8000140e:	338040ef          	jal	80005746 <panic>
    panic("sched interruptible");
    80001412:	00006517          	auipc	a0,0x6
    80001416:	d6e50513          	addi	a0,a0,-658 # 80007180 <etext+0x180>
    8000141a:	32c040ef          	jal	80005746 <panic>

000000008000141e <yield>:
{
    8000141e:	1101                	addi	sp,sp,-32
    80001420:	ec06                	sd	ra,24(sp)
    80001422:	e822                	sd	s0,16(sp)
    80001424:	e426                	sd	s1,8(sp)
    80001426:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001428:	9afff0ef          	jal	80000dd6 <myproc>
    8000142c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000142e:	5da040ef          	jal	80005a08 <acquire>
  p->state = RUNNABLE;
    80001432:	478d                	li	a5,3
    80001434:	cc9c                	sw	a5,24(s1)
  sched();
    80001436:	f2dff0ef          	jal	80001362 <sched>
  release(&p->lock);
    8000143a:	8526                	mv	a0,s1
    8000143c:	660040ef          	jal	80005a9c <release>
}
    80001440:	60e2                	ld	ra,24(sp)
    80001442:	6442                	ld	s0,16(sp)
    80001444:	64a2                	ld	s1,8(sp)
    80001446:	6105                	addi	sp,sp,32
    80001448:	8082                	ret

000000008000144a <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000144a:	7179                	addi	sp,sp,-48
    8000144c:	f406                	sd	ra,40(sp)
    8000144e:	f022                	sd	s0,32(sp)
    80001450:	ec26                	sd	s1,24(sp)
    80001452:	e84a                	sd	s2,16(sp)
    80001454:	e44e                	sd	s3,8(sp)
    80001456:	1800                	addi	s0,sp,48
    80001458:	89aa                	mv	s3,a0
    8000145a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000145c:	97bff0ef          	jal	80000dd6 <myproc>
    80001460:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001462:	5a6040ef          	jal	80005a08 <acquire>
  release(lk);
    80001466:	854a                	mv	a0,s2
    80001468:	634040ef          	jal	80005a9c <release>

  // Go to sleep.
  p->chan = chan;
    8000146c:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001470:	4789                	li	a5,2
    80001472:	cc9c                	sw	a5,24(s1)

  sched();
    80001474:	eefff0ef          	jal	80001362 <sched>

  // Tidy up.
  p->chan = 0;
    80001478:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000147c:	8526                	mv	a0,s1
    8000147e:	61e040ef          	jal	80005a9c <release>
  acquire(lk);
    80001482:	854a                	mv	a0,s2
    80001484:	584040ef          	jal	80005a08 <acquire>
}
    80001488:	70a2                	ld	ra,40(sp)
    8000148a:	7402                	ld	s0,32(sp)
    8000148c:	64e2                	ld	s1,24(sp)
    8000148e:	6942                	ld	s2,16(sp)
    80001490:	69a2                	ld	s3,8(sp)
    80001492:	6145                	addi	sp,sp,48
    80001494:	8082                	ret

0000000080001496 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001496:	7139                	addi	sp,sp,-64
    80001498:	fc06                	sd	ra,56(sp)
    8000149a:	f822                	sd	s0,48(sp)
    8000149c:	f426                	sd	s1,40(sp)
    8000149e:	f04a                	sd	s2,32(sp)
    800014a0:	ec4e                	sd	s3,24(sp)
    800014a2:	e852                	sd	s4,16(sp)
    800014a4:	e456                	sd	s5,8(sp)
    800014a6:	0080                	addi	s0,sp,64
    800014a8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800014aa:	00007497          	auipc	s1,0x7
    800014ae:	88648493          	addi	s1,s1,-1914 # 80007d30 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800014b2:	4989                	li	s3,2
        p->state = RUNNABLE;
    800014b4:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800014b6:	0000e917          	auipc	s2,0xe
    800014ba:	67a90913          	addi	s2,s2,1658 # 8000fb30 <tickslock>
    800014be:	a801                	j	800014ce <wakeup+0x38>
      }
      release(&p->lock);
    800014c0:	8526                	mv	a0,s1
    800014c2:	5da040ef          	jal	80005a9c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800014c6:	1f848493          	addi	s1,s1,504
    800014ca:	03248263          	beq	s1,s2,800014ee <wakeup+0x58>
    if(p != myproc()){
    800014ce:	909ff0ef          	jal	80000dd6 <myproc>
    800014d2:	fe950ae3          	beq	a0,s1,800014c6 <wakeup+0x30>
      acquire(&p->lock);
    800014d6:	8526                	mv	a0,s1
    800014d8:	530040ef          	jal	80005a08 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800014dc:	4c9c                	lw	a5,24(s1)
    800014de:	ff3791e3          	bne	a5,s3,800014c0 <wakeup+0x2a>
    800014e2:	709c                	ld	a5,32(s1)
    800014e4:	fd479ee3          	bne	a5,s4,800014c0 <wakeup+0x2a>
        p->state = RUNNABLE;
    800014e8:	0154ac23          	sw	s5,24(s1)
    800014ec:	bfd1                	j	800014c0 <wakeup+0x2a>
    }
  }
}
    800014ee:	70e2                	ld	ra,56(sp)
    800014f0:	7442                	ld	s0,48(sp)
    800014f2:	74a2                	ld	s1,40(sp)
    800014f4:	7902                	ld	s2,32(sp)
    800014f6:	69e2                	ld	s3,24(sp)
    800014f8:	6a42                	ld	s4,16(sp)
    800014fa:	6aa2                	ld	s5,8(sp)
    800014fc:	6121                	addi	sp,sp,64
    800014fe:	8082                	ret

0000000080001500 <reparent>:
{
    80001500:	7179                	addi	sp,sp,-48
    80001502:	f406                	sd	ra,40(sp)
    80001504:	f022                	sd	s0,32(sp)
    80001506:	ec26                	sd	s1,24(sp)
    80001508:	e84a                	sd	s2,16(sp)
    8000150a:	e44e                	sd	s3,8(sp)
    8000150c:	e052                	sd	s4,0(sp)
    8000150e:	1800                	addi	s0,sp,48
    80001510:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001512:	00007497          	auipc	s1,0x7
    80001516:	81e48493          	addi	s1,s1,-2018 # 80007d30 <proc>
      pp->parent = initproc;
    8000151a:	00006a17          	auipc	s4,0x6
    8000151e:	3a6a0a13          	addi	s4,s4,934 # 800078c0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001522:	0000e997          	auipc	s3,0xe
    80001526:	60e98993          	addi	s3,s3,1550 # 8000fb30 <tickslock>
    8000152a:	a029                	j	80001534 <reparent+0x34>
    8000152c:	1f848493          	addi	s1,s1,504
    80001530:	01348b63          	beq	s1,s3,80001546 <reparent+0x46>
    if(pp->parent == p){
    80001534:	7c9c                	ld	a5,56(s1)
    80001536:	ff279be3          	bne	a5,s2,8000152c <reparent+0x2c>
      pp->parent = initproc;
    8000153a:	000a3503          	ld	a0,0(s4)
    8000153e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001540:	f57ff0ef          	jal	80001496 <wakeup>
    80001544:	b7e5                	j	8000152c <reparent+0x2c>
}
    80001546:	70a2                	ld	ra,40(sp)
    80001548:	7402                	ld	s0,32(sp)
    8000154a:	64e2                	ld	s1,24(sp)
    8000154c:	6942                	ld	s2,16(sp)
    8000154e:	69a2                	ld	s3,8(sp)
    80001550:	6a02                	ld	s4,0(sp)
    80001552:	6145                	addi	sp,sp,48
    80001554:	8082                	ret

0000000080001556 <kexit>:
{
    80001556:	7179                	addi	sp,sp,-48
    80001558:	f406                	sd	ra,40(sp)
    8000155a:	f022                	sd	s0,32(sp)
    8000155c:	ec26                	sd	s1,24(sp)
    8000155e:	e84a                	sd	s2,16(sp)
    80001560:	e44e                	sd	s3,8(sp)
    80001562:	e052                	sd	s4,0(sp)
    80001564:	1800                	addi	s0,sp,48
    80001566:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001568:	86fff0ef          	jal	80000dd6 <myproc>
    8000156c:	89aa                	mv	s3,a0
  if(p == initproc)
    8000156e:	00006797          	auipc	a5,0x6
    80001572:	3527b783          	ld	a5,850(a5) # 800078c0 <initproc>
    80001576:	0d850493          	addi	s1,a0,216
    8000157a:	15850913          	addi	s2,a0,344
    8000157e:	00a79b63          	bne	a5,a0,80001594 <kexit+0x3e>
    panic("init exiting");
    80001582:	00006517          	auipc	a0,0x6
    80001586:	c1650513          	addi	a0,a0,-1002 # 80007198 <etext+0x198>
    8000158a:	1bc040ef          	jal	80005746 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    8000158e:	04a1                	addi	s1,s1,8
    80001590:	01248963          	beq	s1,s2,800015a2 <kexit+0x4c>
    if(p->ofile[fd]){
    80001594:	6088                	ld	a0,0(s1)
    80001596:	dd65                	beqz	a0,8000158e <kexit+0x38>
      fileclose(f);
    80001598:	000020ef          	jal	80003598 <fileclose>
      p->ofile[fd] = 0;
    8000159c:	0004b023          	sd	zero,0(s1)
    800015a0:	b7fd                	j	8000158e <kexit+0x38>
  begin_op();
    800015a2:	3d3010ef          	jal	80003174 <begin_op>
  iput(p->cwd);
    800015a6:	1589b503          	ld	a0,344(s3)
    800015aa:	340010ef          	jal	800028ea <iput>
  end_op();
    800015ae:	437010ef          	jal	800031e4 <end_op>
  p->cwd = 0;
    800015b2:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    800015b6:	00006517          	auipc	a0,0x6
    800015ba:	36250513          	addi	a0,a0,866 # 80007918 <wait_lock>
    800015be:	44a040ef          	jal	80005a08 <acquire>
  reparent(p);
    800015c2:	854e                	mv	a0,s3
    800015c4:	f3dff0ef          	jal	80001500 <reparent>
  wakeup(p->parent);
    800015c8:	0389b503          	ld	a0,56(s3)
    800015cc:	ecbff0ef          	jal	80001496 <wakeup>
  acquire(&p->lock);
    800015d0:	854e                	mv	a0,s3
    800015d2:	436040ef          	jal	80005a08 <acquire>
  p->xstate = status;
    800015d6:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800015da:	4795                	li	a5,5
    800015dc:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800015e0:	00006517          	auipc	a0,0x6
    800015e4:	33850513          	addi	a0,a0,824 # 80007918 <wait_lock>
    800015e8:	4b4040ef          	jal	80005a9c <release>
  sched();
    800015ec:	d77ff0ef          	jal	80001362 <sched>
  panic("zombie exit");
    800015f0:	00006517          	auipc	a0,0x6
    800015f4:	bb850513          	addi	a0,a0,-1096 # 800071a8 <etext+0x1a8>
    800015f8:	14e040ef          	jal	80005746 <panic>

00000000800015fc <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800015fc:	7179                	addi	sp,sp,-48
    800015fe:	f406                	sd	ra,40(sp)
    80001600:	f022                	sd	s0,32(sp)
    80001602:	ec26                	sd	s1,24(sp)
    80001604:	e84a                	sd	s2,16(sp)
    80001606:	e44e                	sd	s3,8(sp)
    80001608:	1800                	addi	s0,sp,48
    8000160a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000160c:	00006497          	auipc	s1,0x6
    80001610:	72448493          	addi	s1,s1,1828 # 80007d30 <proc>
    80001614:	0000e997          	auipc	s3,0xe
    80001618:	51c98993          	addi	s3,s3,1308 # 8000fb30 <tickslock>
    acquire(&p->lock);
    8000161c:	8526                	mv	a0,s1
    8000161e:	3ea040ef          	jal	80005a08 <acquire>
    if(p->pid == pid){
    80001622:	589c                	lw	a5,48(s1)
    80001624:	01278b63          	beq	a5,s2,8000163a <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001628:	8526                	mv	a0,s1
    8000162a:	472040ef          	jal	80005a9c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000162e:	1f848493          	addi	s1,s1,504
    80001632:	ff3495e3          	bne	s1,s3,8000161c <kkill+0x20>
  }
  return -1;
    80001636:	557d                	li	a0,-1
    80001638:	a819                	j	8000164e <kkill+0x52>
      p->killed = 1;
    8000163a:	4785                	li	a5,1
    8000163c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000163e:	4c98                	lw	a4,24(s1)
    80001640:	4789                	li	a5,2
    80001642:	00f70d63          	beq	a4,a5,8000165c <kkill+0x60>
      release(&p->lock);
    80001646:	8526                	mv	a0,s1
    80001648:	454040ef          	jal	80005a9c <release>
      return 0;
    8000164c:	4501                	li	a0,0
}
    8000164e:	70a2                	ld	ra,40(sp)
    80001650:	7402                	ld	s0,32(sp)
    80001652:	64e2                	ld	s1,24(sp)
    80001654:	6942                	ld	s2,16(sp)
    80001656:	69a2                	ld	s3,8(sp)
    80001658:	6145                	addi	sp,sp,48
    8000165a:	8082                	ret
        p->state = RUNNABLE;
    8000165c:	478d                	li	a5,3
    8000165e:	cc9c                	sw	a5,24(s1)
    80001660:	b7dd                	j	80001646 <kkill+0x4a>

0000000080001662 <setkilled>:

void
setkilled(struct proc *p)
{
    80001662:	1101                	addi	sp,sp,-32
    80001664:	ec06                	sd	ra,24(sp)
    80001666:	e822                	sd	s0,16(sp)
    80001668:	e426                	sd	s1,8(sp)
    8000166a:	1000                	addi	s0,sp,32
    8000166c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000166e:	39a040ef          	jal	80005a08 <acquire>
  p->killed = 1;
    80001672:	4785                	li	a5,1
    80001674:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001676:	8526                	mv	a0,s1
    80001678:	424040ef          	jal	80005a9c <release>
}
    8000167c:	60e2                	ld	ra,24(sp)
    8000167e:	6442                	ld	s0,16(sp)
    80001680:	64a2                	ld	s1,8(sp)
    80001682:	6105                	addi	sp,sp,32
    80001684:	8082                	ret

0000000080001686 <killed>:

int
killed(struct proc *p)
{
    80001686:	1101                	addi	sp,sp,-32
    80001688:	ec06                	sd	ra,24(sp)
    8000168a:	e822                	sd	s0,16(sp)
    8000168c:	e426                	sd	s1,8(sp)
    8000168e:	e04a                	sd	s2,0(sp)
    80001690:	1000                	addi	s0,sp,32
    80001692:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001694:	374040ef          	jal	80005a08 <acquire>
  k = p->killed;
    80001698:	549c                	lw	a5,40(s1)
    8000169a:	893e                	mv	s2,a5
  release(&p->lock);
    8000169c:	8526                	mv	a0,s1
    8000169e:	3fe040ef          	jal	80005a9c <release>
  return k;
}
    800016a2:	854a                	mv	a0,s2
    800016a4:	60e2                	ld	ra,24(sp)
    800016a6:	6442                	ld	s0,16(sp)
    800016a8:	64a2                	ld	s1,8(sp)
    800016aa:	6902                	ld	s2,0(sp)
    800016ac:	6105                	addi	sp,sp,32
    800016ae:	8082                	ret

00000000800016b0 <kwait>:
{
    800016b0:	715d                	addi	sp,sp,-80
    800016b2:	e486                	sd	ra,72(sp)
    800016b4:	e0a2                	sd	s0,64(sp)
    800016b6:	fc26                	sd	s1,56(sp)
    800016b8:	f84a                	sd	s2,48(sp)
    800016ba:	f44e                	sd	s3,40(sp)
    800016bc:	f052                	sd	s4,32(sp)
    800016be:	ec56                	sd	s5,24(sp)
    800016c0:	e85a                	sd	s6,16(sp)
    800016c2:	e45e                	sd	s7,8(sp)
    800016c4:	0880                	addi	s0,sp,80
    800016c6:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800016c8:	f0eff0ef          	jal	80000dd6 <myproc>
    800016cc:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800016ce:	00006517          	auipc	a0,0x6
    800016d2:	24a50513          	addi	a0,a0,586 # 80007918 <wait_lock>
    800016d6:	332040ef          	jal	80005a08 <acquire>
        if(pp->state == ZOMBIE){
    800016da:	4a15                	li	s4,5
        havekids = 1;
    800016dc:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016de:	0000e997          	auipc	s3,0xe
    800016e2:	45298993          	addi	s3,s3,1106 # 8000fb30 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016e6:	00006b17          	auipc	s6,0x6
    800016ea:	232b0b13          	addi	s6,s6,562 # 80007918 <wait_lock>
    800016ee:	a869                	j	80001788 <kwait+0xd8>
          pid = pp->pid;
    800016f0:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800016f4:	000b8c63          	beqz	s7,8000170c <kwait+0x5c>
    800016f8:	4691                	li	a3,4
    800016fa:	02c48613          	addi	a2,s1,44
    800016fe:	85de                	mv	a1,s7
    80001700:	05093503          	ld	a0,80(s2)
    80001704:	bf0ff0ef          	jal	80000af4 <copyout>
    80001708:	02054a63          	bltz	a0,8000173c <kwait+0x8c>
          freeproc(pp);
    8000170c:	8526                	mv	a0,s1
    8000170e:	8e7ff0ef          	jal	80000ff4 <freeproc>
          release(&pp->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	388040ef          	jal	80005a9c <release>
          release(&wait_lock);
    80001718:	00006517          	auipc	a0,0x6
    8000171c:	20050513          	addi	a0,a0,512 # 80007918 <wait_lock>
    80001720:	37c040ef          	jal	80005a9c <release>
}
    80001724:	854e                	mv	a0,s3
    80001726:	60a6                	ld	ra,72(sp)
    80001728:	6406                	ld	s0,64(sp)
    8000172a:	74e2                	ld	s1,56(sp)
    8000172c:	7942                	ld	s2,48(sp)
    8000172e:	79a2                	ld	s3,40(sp)
    80001730:	7a02                	ld	s4,32(sp)
    80001732:	6ae2                	ld	s5,24(sp)
    80001734:	6b42                	ld	s6,16(sp)
    80001736:	6ba2                	ld	s7,8(sp)
    80001738:	6161                	addi	sp,sp,80
    8000173a:	8082                	ret
            release(&pp->lock);
    8000173c:	8526                	mv	a0,s1
    8000173e:	35e040ef          	jal	80005a9c <release>
            release(&wait_lock);
    80001742:	00006517          	auipc	a0,0x6
    80001746:	1d650513          	addi	a0,a0,470 # 80007918 <wait_lock>
    8000174a:	352040ef          	jal	80005a9c <release>
            return -1;
    8000174e:	59fd                	li	s3,-1
    80001750:	bfd1                	j	80001724 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001752:	1f848493          	addi	s1,s1,504
    80001756:	03348063          	beq	s1,s3,80001776 <kwait+0xc6>
      if(pp->parent == p){
    8000175a:	7c9c                	ld	a5,56(s1)
    8000175c:	ff279be3          	bne	a5,s2,80001752 <kwait+0xa2>
        acquire(&pp->lock);
    80001760:	8526                	mv	a0,s1
    80001762:	2a6040ef          	jal	80005a08 <acquire>
        if(pp->state == ZOMBIE){
    80001766:	4c9c                	lw	a5,24(s1)
    80001768:	f94784e3          	beq	a5,s4,800016f0 <kwait+0x40>
        release(&pp->lock);
    8000176c:	8526                	mv	a0,s1
    8000176e:	32e040ef          	jal	80005a9c <release>
        havekids = 1;
    80001772:	8756                	mv	a4,s5
    80001774:	bff9                	j	80001752 <kwait+0xa2>
    if(!havekids || killed(p)){
    80001776:	cf19                	beqz	a4,80001794 <kwait+0xe4>
    80001778:	854a                	mv	a0,s2
    8000177a:	f0dff0ef          	jal	80001686 <killed>
    8000177e:	e919                	bnez	a0,80001794 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001780:	85da                	mv	a1,s6
    80001782:	854a                	mv	a0,s2
    80001784:	cc7ff0ef          	jal	8000144a <sleep>
    havekids = 0;
    80001788:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000178a:	00006497          	auipc	s1,0x6
    8000178e:	5a648493          	addi	s1,s1,1446 # 80007d30 <proc>
    80001792:	b7e1                	j	8000175a <kwait+0xaa>
      release(&wait_lock);
    80001794:	00006517          	auipc	a0,0x6
    80001798:	18450513          	addi	a0,a0,388 # 80007918 <wait_lock>
    8000179c:	300040ef          	jal	80005a9c <release>
      return -1;
    800017a0:	59fd                	li	s3,-1
    800017a2:	b749                	j	80001724 <kwait+0x74>

00000000800017a4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800017a4:	7179                	addi	sp,sp,-48
    800017a6:	f406                	sd	ra,40(sp)
    800017a8:	f022                	sd	s0,32(sp)
    800017aa:	ec26                	sd	s1,24(sp)
    800017ac:	e84a                	sd	s2,16(sp)
    800017ae:	e44e                	sd	s3,8(sp)
    800017b0:	e052                	sd	s4,0(sp)
    800017b2:	1800                	addi	s0,sp,48
    800017b4:	84aa                	mv	s1,a0
    800017b6:	8a2e                	mv	s4,a1
    800017b8:	89b2                	mv	s3,a2
    800017ba:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800017bc:	e1aff0ef          	jal	80000dd6 <myproc>
  if(user_dst){
    800017c0:	cc99                	beqz	s1,800017de <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800017c2:	86ca                	mv	a3,s2
    800017c4:	864e                	mv	a2,s3
    800017c6:	85d2                	mv	a1,s4
    800017c8:	6928                	ld	a0,80(a0)
    800017ca:	b2aff0ef          	jal	80000af4 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800017ce:	70a2                	ld	ra,40(sp)
    800017d0:	7402                	ld	s0,32(sp)
    800017d2:	64e2                	ld	s1,24(sp)
    800017d4:	6942                	ld	s2,16(sp)
    800017d6:	69a2                	ld	s3,8(sp)
    800017d8:	6a02                	ld	s4,0(sp)
    800017da:	6145                	addi	sp,sp,48
    800017dc:	8082                	ret
    memmove((char *)dst, src, len);
    800017de:	0009061b          	sext.w	a2,s2
    800017e2:	85ce                	mv	a1,s3
    800017e4:	8552                	mv	a0,s4
    800017e6:	9d9fe0ef          	jal	800001be <memmove>
    return 0;
    800017ea:	8526                	mv	a0,s1
    800017ec:	b7cd                	j	800017ce <either_copyout+0x2a>

00000000800017ee <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800017ee:	7179                	addi	sp,sp,-48
    800017f0:	f406                	sd	ra,40(sp)
    800017f2:	f022                	sd	s0,32(sp)
    800017f4:	ec26                	sd	s1,24(sp)
    800017f6:	e84a                	sd	s2,16(sp)
    800017f8:	e44e                	sd	s3,8(sp)
    800017fa:	e052                	sd	s4,0(sp)
    800017fc:	1800                	addi	s0,sp,48
    800017fe:	8a2a                	mv	s4,a0
    80001800:	84ae                	mv	s1,a1
    80001802:	89b2                	mv	s3,a2
    80001804:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001806:	dd0ff0ef          	jal	80000dd6 <myproc>
  if(user_src){
    8000180a:	cc99                	beqz	s1,80001828 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000180c:	86ca                	mv	a3,s2
    8000180e:	864e                	mv	a2,s3
    80001810:	85d2                	mv	a1,s4
    80001812:	6928                	ld	a0,80(a0)
    80001814:	ba4ff0ef          	jal	80000bb8 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001818:	70a2                	ld	ra,40(sp)
    8000181a:	7402                	ld	s0,32(sp)
    8000181c:	64e2                	ld	s1,24(sp)
    8000181e:	6942                	ld	s2,16(sp)
    80001820:	69a2                	ld	s3,8(sp)
    80001822:	6a02                	ld	s4,0(sp)
    80001824:	6145                	addi	sp,sp,48
    80001826:	8082                	ret
    memmove(dst, (char*)src, len);
    80001828:	0009061b          	sext.w	a2,s2
    8000182c:	85ce                	mv	a1,s3
    8000182e:	8552                	mv	a0,s4
    80001830:	98ffe0ef          	jal	800001be <memmove>
    return 0;
    80001834:	8526                	mv	a0,s1
    80001836:	b7cd                	j	80001818 <either_copyin+0x2a>

0000000080001838 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001838:	715d                	addi	sp,sp,-80
    8000183a:	e486                	sd	ra,72(sp)
    8000183c:	e0a2                	sd	s0,64(sp)
    8000183e:	fc26                	sd	s1,56(sp)
    80001840:	f84a                	sd	s2,48(sp)
    80001842:	f44e                	sd	s3,40(sp)
    80001844:	f052                	sd	s4,32(sp)
    80001846:	ec56                	sd	s5,24(sp)
    80001848:	e85a                	sd	s6,16(sp)
    8000184a:	e45e                	sd	s7,8(sp)
    8000184c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000184e:	00005517          	auipc	a0,0x5
    80001852:	7ca50513          	addi	a0,a0,1994 # 80007018 <etext+0x18>
    80001856:	3c7030ef          	jal	8000541c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000185a:	00006497          	auipc	s1,0x6
    8000185e:	63648493          	addi	s1,s1,1590 # 80007e90 <proc+0x160>
    80001862:	0000e917          	auipc	s2,0xe
    80001866:	42e90913          	addi	s2,s2,1070 # 8000fc90 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000186a:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000186c:	00006997          	auipc	s3,0x6
    80001870:	94c98993          	addi	s3,s3,-1716 # 800071b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    80001874:	00006a97          	auipc	s5,0x6
    80001878:	94ca8a93          	addi	s5,s5,-1716 # 800071c0 <etext+0x1c0>
    printf("\n");
    8000187c:	00005a17          	auipc	s4,0x5
    80001880:	79ca0a13          	addi	s4,s4,1948 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001884:	00006b97          	auipc	s7,0x6
    80001888:	ea4b8b93          	addi	s7,s7,-348 # 80007728 <states.0>
    8000188c:	a829                	j	800018a6 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    8000188e:	ed06a583          	lw	a1,-304(a3)
    80001892:	8556                	mv	a0,s5
    80001894:	389030ef          	jal	8000541c <printf>
    printf("\n");
    80001898:	8552                	mv	a0,s4
    8000189a:	383030ef          	jal	8000541c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000189e:	1f848493          	addi	s1,s1,504
    800018a2:	03248263          	beq	s1,s2,800018c6 <procdump+0x8e>
    if(p->state == UNUSED)
    800018a6:	86a6                	mv	a3,s1
    800018a8:	eb84a783          	lw	a5,-328(s1)
    800018ac:	dbed                	beqz	a5,8000189e <procdump+0x66>
      state = "???";
    800018ae:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800018b0:	fcfb6fe3          	bltu	s6,a5,8000188e <procdump+0x56>
    800018b4:	02079713          	slli	a4,a5,0x20
    800018b8:	01d75793          	srli	a5,a4,0x1d
    800018bc:	97de                	add	a5,a5,s7
    800018be:	6390                	ld	a2,0(a5)
    800018c0:	f679                	bnez	a2,8000188e <procdump+0x56>
      state = "???";
    800018c2:	864e                	mv	a2,s3
    800018c4:	b7e9                	j	8000188e <procdump+0x56>
  }
}
    800018c6:	60a6                	ld	ra,72(sp)
    800018c8:	6406                	ld	s0,64(sp)
    800018ca:	74e2                	ld	s1,56(sp)
    800018cc:	7942                	ld	s2,48(sp)
    800018ce:	79a2                	ld	s3,40(sp)
    800018d0:	7a02                	ld	s4,32(sp)
    800018d2:	6ae2                	ld	s5,24(sp)
    800018d4:	6b42                	ld	s6,16(sp)
    800018d6:	6ba2                	ld	s7,8(sp)
    800018d8:	6161                	addi	sp,sp,80
    800018da:	8082                	ret

00000000800018dc <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    800018dc:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    800018e0:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    800018e4:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    800018e6:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    800018e8:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    800018ec:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800018f0:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800018f4:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800018f8:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800018fc:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001900:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001904:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001908:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000190c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001910:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001914:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001918:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000191a:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000191c:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001920:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001924:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001928:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000192c:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001930:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001934:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001938:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000193c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001940:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001944:	8082                	ret

0000000080001946 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001946:	1141                	addi	sp,sp,-16
    80001948:	e406                	sd	ra,8(sp)
    8000194a:	e022                	sd	s0,0(sp)
    8000194c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000194e:	00006597          	auipc	a1,0x6
    80001952:	8b258593          	addi	a1,a1,-1870 # 80007200 <etext+0x200>
    80001956:	0000e517          	auipc	a0,0xe
    8000195a:	1da50513          	addi	a0,a0,474 # 8000fb30 <tickslock>
    8000195e:	020040ef          	jal	8000597e <initlock>
}
    80001962:	60a2                	ld	ra,8(sp)
    80001964:	6402                	ld	s0,0(sp)
    80001966:	0141                	addi	sp,sp,16
    80001968:	8082                	ret

000000008000196a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000196a:	1141                	addi	sp,sp,-16
    8000196c:	e406                	sd	ra,8(sp)
    8000196e:	e022                	sd	s0,0(sp)
    80001970:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001972:	00003797          	auipc	a5,0x3
    80001976:	fde78793          	addi	a5,a5,-34 # 80004950 <kernelvec>
    8000197a:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    8000197e:	60a2                	ld	ra,8(sp)
    80001980:	6402                	ld	s0,0(sp)
    80001982:	0141                	addi	sp,sp,16
    80001984:	8082                	ret

0000000080001986 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80001986:	1141                	addi	sp,sp,-16
    80001988:	e406                	sd	ra,8(sp)
    8000198a:	e022                	sd	s0,0(sp)
    8000198c:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    8000198e:	c48ff0ef          	jal	80000dd6 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001992:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001996:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001998:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000199c:	04000737          	lui	a4,0x4000
    800019a0:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800019a2:	0732                	slli	a4,a4,0xc
    800019a4:	00004797          	auipc	a5,0x4
    800019a8:	65c78793          	addi	a5,a5,1628 # 80006000 <_trampoline>
    800019ac:	00004697          	auipc	a3,0x4
    800019b0:	65468693          	addi	a3,a3,1620 # 80006000 <_trampoline>
    800019b4:	8f95                	sub	a5,a5,a3
    800019b6:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    800019b8:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    800019bc:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    800019be:	18002773          	csrr	a4,satp
    800019c2:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    800019c4:	6d38                	ld	a4,88(a0)
    800019c6:	613c                	ld	a5,64(a0)
    800019c8:	6685                	lui	a3,0x1
    800019ca:	97b6                	add	a5,a5,a3
    800019cc:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    800019ce:	6d3c                	ld	a5,88(a0)
    800019d0:	00000717          	auipc	a4,0x0
    800019d4:	0fc70713          	addi	a4,a4,252 # 80001acc <usertrap>
    800019d8:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    800019da:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    800019dc:	8712                	mv	a4,tp
    800019de:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800019e0:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    800019e4:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    800019e8:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800019ec:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800019f0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800019f2:	6f9c                	ld	a5,24(a5)
    800019f4:	14179073          	csrw	sepc,a5
}
    800019f8:	60a2                	ld	ra,8(sp)
    800019fa:	6402                	ld	s0,0(sp)
    800019fc:	0141                	addi	sp,sp,16
    800019fe:	8082                	ret

0000000080001a00 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001a00:	1141                	addi	sp,sp,-16
    80001a02:	e406                	sd	ra,8(sp)
    80001a04:	e022                	sd	s0,0(sp)
    80001a06:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001a08:	b9aff0ef          	jal	80000da2 <cpuid>
    80001a0c:	cd11                	beqz	a0,80001a28 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001a0e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001a12:	000f4737          	lui	a4,0xf4
    80001a16:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001a1a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001a1c:	14d79073          	csrw	stimecmp,a5
}
    80001a20:	60a2                	ld	ra,8(sp)
    80001a22:	6402                	ld	s0,0(sp)
    80001a24:	0141                	addi	sp,sp,16
    80001a26:	8082                	ret
    acquire(&tickslock);
    80001a28:	0000e517          	auipc	a0,0xe
    80001a2c:	10850513          	addi	a0,a0,264 # 8000fb30 <tickslock>
    80001a30:	7d9030ef          	jal	80005a08 <acquire>
    ticks++;
    80001a34:	00006717          	auipc	a4,0x6
    80001a38:	e9470713          	addi	a4,a4,-364 # 800078c8 <ticks>
    80001a3c:	431c                	lw	a5,0(a4)
    80001a3e:	2785                	addiw	a5,a5,1
    80001a40:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001a42:	853a                	mv	a0,a4
    80001a44:	a53ff0ef          	jal	80001496 <wakeup>
    release(&tickslock);
    80001a48:	0000e517          	auipc	a0,0xe
    80001a4c:	0e850513          	addi	a0,a0,232 # 8000fb30 <tickslock>
    80001a50:	04c040ef          	jal	80005a9c <release>
    80001a54:	bf6d                	j	80001a0e <clockintr+0xe>

0000000080001a56 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a56:	1101                	addi	sp,sp,-32
    80001a58:	ec06                	sd	ra,24(sp)
    80001a5a:	e822                	sd	s0,16(sp)
    80001a5c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a5e:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001a62:	57fd                	li	a5,-1
    80001a64:	17fe                	slli	a5,a5,0x3f
    80001a66:	07a5                	addi	a5,a5,9
    80001a68:	00f70c63          	beq	a4,a5,80001a80 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a6c:	57fd                	li	a5,-1
    80001a6e:	17fe                	slli	a5,a5,0x3f
    80001a70:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a72:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a74:	04f70863          	beq	a4,a5,80001ac4 <devintr+0x6e>
  }
}
    80001a78:	60e2                	ld	ra,24(sp)
    80001a7a:	6442                	ld	s0,16(sp)
    80001a7c:	6105                	addi	sp,sp,32
    80001a7e:	8082                	ret
    80001a80:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a82:	77b020ef          	jal	800049fc <plic_claim>
    80001a86:	872a                	mv	a4,a0
    80001a88:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a8a:	47a9                	li	a5,10
    80001a8c:	00f50963          	beq	a0,a5,80001a9e <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80001a90:	4785                	li	a5,1
    80001a92:	00f50963          	beq	a0,a5,80001aa4 <devintr+0x4e>
    return 1;
    80001a96:	4505                	li	a0,1
    } else if(irq){
    80001a98:	eb09                	bnez	a4,80001aaa <devintr+0x54>
    80001a9a:	64a2                	ld	s1,8(sp)
    80001a9c:	bff1                	j	80001a78 <devintr+0x22>
      uartintr();
    80001a9e:	679030ef          	jal	80005916 <uartintr>
    if(irq)
    80001aa2:	a819                	j	80001ab8 <devintr+0x62>
      virtio_disk_intr();
    80001aa4:	3ee030ef          	jal	80004e92 <virtio_disk_intr>
    if(irq)
    80001aa8:	a801                	j	80001ab8 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80001aaa:	85ba                	mv	a1,a4
    80001aac:	00005517          	auipc	a0,0x5
    80001ab0:	75c50513          	addi	a0,a0,1884 # 80007208 <etext+0x208>
    80001ab4:	169030ef          	jal	8000541c <printf>
      plic_complete(irq);
    80001ab8:	8526                	mv	a0,s1
    80001aba:	763020ef          	jal	80004a1c <plic_complete>
    return 1;
    80001abe:	4505                	li	a0,1
    80001ac0:	64a2                	ld	s1,8(sp)
    80001ac2:	bf5d                	j	80001a78 <devintr+0x22>
    clockintr();
    80001ac4:	f3dff0ef          	jal	80001a00 <clockintr>
    return 2;
    80001ac8:	4509                	li	a0,2
    80001aca:	b77d                	j	80001a78 <devintr+0x22>

0000000080001acc <usertrap>:
{
    80001acc:	1101                	addi	sp,sp,-32
    80001ace:	ec06                	sd	ra,24(sp)
    80001ad0:	e822                	sd	s0,16(sp)
    80001ad2:	e426                	sd	s1,8(sp)
    80001ad4:	e04a                	sd	s2,0(sp)
    80001ad6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ad8:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001adc:	1007f793          	andi	a5,a5,256
    80001ae0:	eba5                	bnez	a5,80001b50 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001ae2:	00003797          	auipc	a5,0x3
    80001ae6:	e6e78793          	addi	a5,a5,-402 # 80004950 <kernelvec>
    80001aea:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001aee:	ae8ff0ef          	jal	80000dd6 <myproc>
    80001af2:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001af4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001af6:	14102773          	csrr	a4,sepc
    80001afa:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001afc:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001b00:	47a1                	li	a5,8
    80001b02:	04f70d63          	beq	a4,a5,80001b5c <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001b06:	f51ff0ef          	jal	80001a56 <devintr>
    80001b0a:	892a                	mv	s2,a0
    80001b0c:	e945                	bnez	a0,80001bbc <usertrap+0xf0>
    80001b0e:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b12:	47bd                	li	a5,15
    80001b14:	08f70863          	beq	a4,a5,80001ba4 <usertrap+0xd8>
    80001b18:	14202773          	csrr	a4,scause
    80001b1c:	47b5                	li	a5,13
    80001b1e:	08f70363          	beq	a4,a5,80001ba4 <usertrap+0xd8>
    80001b22:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001b26:	5890                	lw	a2,48(s1)
    80001b28:	00005517          	auipc	a0,0x5
    80001b2c:	72050513          	addi	a0,a0,1824 # 80007248 <etext+0x248>
    80001b30:	0ed030ef          	jal	8000541c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b34:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b38:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001b3c:	00005517          	auipc	a0,0x5
    80001b40:	73c50513          	addi	a0,a0,1852 # 80007278 <etext+0x278>
    80001b44:	0d9030ef          	jal	8000541c <printf>
    setkilled(p);
    80001b48:	8526                	mv	a0,s1
    80001b4a:	b19ff0ef          	jal	80001662 <setkilled>
    80001b4e:	a035                	j	80001b7a <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001b50:	00005517          	auipc	a0,0x5
    80001b54:	6d850513          	addi	a0,a0,1752 # 80007228 <etext+0x228>
    80001b58:	3ef030ef          	jal	80005746 <panic>
    if(killed(p))
    80001b5c:	b2bff0ef          	jal	80001686 <killed>
    80001b60:	ed15                	bnez	a0,80001b9c <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001b62:	6cb8                	ld	a4,88(s1)
    80001b64:	6f1c                	ld	a5,24(a4)
    80001b66:	0791                	addi	a5,a5,4
    80001b68:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b6a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b6e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b72:	10079073          	csrw	sstatus,a5
    syscall();
    80001b76:	240000ef          	jal	80001db6 <syscall>
  if(killed(p))
    80001b7a:	8526                	mv	a0,s1
    80001b7c:	b0bff0ef          	jal	80001686 <killed>
    80001b80:	e139                	bnez	a0,80001bc6 <usertrap+0xfa>
  prepare_return();
    80001b82:	e05ff0ef          	jal	80001986 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b86:	68a8                	ld	a0,80(s1)
    80001b88:	8131                	srli	a0,a0,0xc
    80001b8a:	57fd                	li	a5,-1
    80001b8c:	17fe                	slli	a5,a5,0x3f
    80001b8e:	8d5d                	or	a0,a0,a5
}
    80001b90:	60e2                	ld	ra,24(sp)
    80001b92:	6442                	ld	s0,16(sp)
    80001b94:	64a2                	ld	s1,8(sp)
    80001b96:	6902                	ld	s2,0(sp)
    80001b98:	6105                	addi	sp,sp,32
    80001b9a:	8082                	ret
      kexit(-1);
    80001b9c:	557d                	li	a0,-1
    80001b9e:	9b9ff0ef          	jal	80001556 <kexit>
    80001ba2:	b7c1                	j	80001b62 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ba4:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ba8:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001bac:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001bae:	00163613          	seqz	a2,a2
    80001bb2:	68a8                	ld	a0,80(s1)
    80001bb4:	ebdfe0ef          	jal	80000a70 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001bb8:	f169                	bnez	a0,80001b7a <usertrap+0xae>
    80001bba:	b7a5                	j	80001b22 <usertrap+0x56>
  if(killed(p))
    80001bbc:	8526                	mv	a0,s1
    80001bbe:	ac9ff0ef          	jal	80001686 <killed>
    80001bc2:	c511                	beqz	a0,80001bce <usertrap+0x102>
    80001bc4:	a011                	j	80001bc8 <usertrap+0xfc>
    80001bc6:	4901                	li	s2,0
    kexit(-1);
    80001bc8:	557d                	li	a0,-1
    80001bca:	98dff0ef          	jal	80001556 <kexit>
  if(which_dev == 2)
    80001bce:	4789                	li	a5,2
    80001bd0:	faf919e3          	bne	s2,a5,80001b82 <usertrap+0xb6>
    yield();
    80001bd4:	84bff0ef          	jal	8000141e <yield>
    80001bd8:	b76d                	j	80001b82 <usertrap+0xb6>

0000000080001bda <kerneltrap>:
{
    80001bda:	7179                	addi	sp,sp,-48
    80001bdc:	f406                	sd	ra,40(sp)
    80001bde:	f022                	sd	s0,32(sp)
    80001be0:	ec26                	sd	s1,24(sp)
    80001be2:	e84a                	sd	s2,16(sp)
    80001be4:	e44e                	sd	s3,8(sp)
    80001be6:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001be8:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bec:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf0:	142027f3          	csrr	a5,scause
    80001bf4:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001bf6:	1004f793          	andi	a5,s1,256
    80001bfa:	c795                	beqz	a5,80001c26 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bfc:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001c00:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001c02:	eb85                	bnez	a5,80001c32 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001c04:	e53ff0ef          	jal	80001a56 <devintr>
    80001c08:	c91d                	beqz	a0,80001c3e <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001c0a:	4789                	li	a5,2
    80001c0c:	04f50a63          	beq	a0,a5,80001c60 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001c10:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c14:	10049073          	csrw	sstatus,s1
}
    80001c18:	70a2                	ld	ra,40(sp)
    80001c1a:	7402                	ld	s0,32(sp)
    80001c1c:	64e2                	ld	s1,24(sp)
    80001c1e:	6942                	ld	s2,16(sp)
    80001c20:	69a2                	ld	s3,8(sp)
    80001c22:	6145                	addi	sp,sp,48
    80001c24:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001c26:	00005517          	auipc	a0,0x5
    80001c2a:	67a50513          	addi	a0,a0,1658 # 800072a0 <etext+0x2a0>
    80001c2e:	319030ef          	jal	80005746 <panic>
    panic("kerneltrap: interrupts enabled");
    80001c32:	00005517          	auipc	a0,0x5
    80001c36:	69650513          	addi	a0,a0,1686 # 800072c8 <etext+0x2c8>
    80001c3a:	30d030ef          	jal	80005746 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c3e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c42:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001c46:	85ce                	mv	a1,s3
    80001c48:	00005517          	auipc	a0,0x5
    80001c4c:	6a050513          	addi	a0,a0,1696 # 800072e8 <etext+0x2e8>
    80001c50:	7cc030ef          	jal	8000541c <printf>
    panic("kerneltrap");
    80001c54:	00005517          	auipc	a0,0x5
    80001c58:	6bc50513          	addi	a0,a0,1724 # 80007310 <etext+0x310>
    80001c5c:	2eb030ef          	jal	80005746 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c60:	976ff0ef          	jal	80000dd6 <myproc>
    80001c64:	d555                	beqz	a0,80001c10 <kerneltrap+0x36>
    yield();
    80001c66:	fb8ff0ef          	jal	8000141e <yield>
    80001c6a:	b75d                	j	80001c10 <kerneltrap+0x36>

0000000080001c6c <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001c6c:	1101                	addi	sp,sp,-32
    80001c6e:	ec06                	sd	ra,24(sp)
    80001c70:	e822                	sd	s0,16(sp)
    80001c72:	e426                	sd	s1,8(sp)
    80001c74:	1000                	addi	s0,sp,32
    80001c76:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c78:	95eff0ef          	jal	80000dd6 <myproc>
  switch (n) {
    80001c7c:	4795                	li	a5,5
    80001c7e:	0497e163          	bltu	a5,s1,80001cc0 <argraw+0x54>
    80001c82:	048a                	slli	s1,s1,0x2
    80001c84:	00006717          	auipc	a4,0x6
    80001c88:	ad470713          	addi	a4,a4,-1324 # 80007758 <states.0+0x30>
    80001c8c:	94ba                	add	s1,s1,a4
    80001c8e:	409c                	lw	a5,0(s1)
    80001c90:	97ba                	add	a5,a5,a4
    80001c92:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c94:	6d3c                	ld	a5,88(a0)
    80001c96:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c98:	60e2                	ld	ra,24(sp)
    80001c9a:	6442                	ld	s0,16(sp)
    80001c9c:	64a2                	ld	s1,8(sp)
    80001c9e:	6105                	addi	sp,sp,32
    80001ca0:	8082                	ret
    return p->trapframe->a1;
    80001ca2:	6d3c                	ld	a5,88(a0)
    80001ca4:	7fa8                	ld	a0,120(a5)
    80001ca6:	bfcd                	j	80001c98 <argraw+0x2c>
    return p->trapframe->a2;
    80001ca8:	6d3c                	ld	a5,88(a0)
    80001caa:	63c8                	ld	a0,128(a5)
    80001cac:	b7f5                	j	80001c98 <argraw+0x2c>
    return p->trapframe->a3;
    80001cae:	6d3c                	ld	a5,88(a0)
    80001cb0:	67c8                	ld	a0,136(a5)
    80001cb2:	b7dd                	j	80001c98 <argraw+0x2c>
    return p->trapframe->a4;
    80001cb4:	6d3c                	ld	a5,88(a0)
    80001cb6:	6bc8                	ld	a0,144(a5)
    80001cb8:	b7c5                	j	80001c98 <argraw+0x2c>
    return p->trapframe->a5;
    80001cba:	6d3c                	ld	a5,88(a0)
    80001cbc:	6fc8                	ld	a0,152(a5)
    80001cbe:	bfe9                	j	80001c98 <argraw+0x2c>
  panic("argraw");
    80001cc0:	00005517          	auipc	a0,0x5
    80001cc4:	66050513          	addi	a0,a0,1632 # 80007320 <etext+0x320>
    80001cc8:	27f030ef          	jal	80005746 <panic>

0000000080001ccc <fetchaddr>:
{
    80001ccc:	1101                	addi	sp,sp,-32
    80001cce:	ec06                	sd	ra,24(sp)
    80001cd0:	e822                	sd	s0,16(sp)
    80001cd2:	e426                	sd	s1,8(sp)
    80001cd4:	e04a                	sd	s2,0(sp)
    80001cd6:	1000                	addi	s0,sp,32
    80001cd8:	84aa                	mv	s1,a0
    80001cda:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001cdc:	8faff0ef          	jal	80000dd6 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ce0:	653c                	ld	a5,72(a0)
    80001ce2:	02f4f663          	bgeu	s1,a5,80001d0e <fetchaddr+0x42>
    80001ce6:	00848713          	addi	a4,s1,8
    80001cea:	02e7e463          	bltu	a5,a4,80001d12 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001cee:	46a1                	li	a3,8
    80001cf0:	8626                	mv	a2,s1
    80001cf2:	85ca                	mv	a1,s2
    80001cf4:	6928                	ld	a0,80(a0)
    80001cf6:	ec3fe0ef          	jal	80000bb8 <copyin>
    80001cfa:	00a03533          	snez	a0,a0
    80001cfe:	40a0053b          	negw	a0,a0
}
    80001d02:	60e2                	ld	ra,24(sp)
    80001d04:	6442                	ld	s0,16(sp)
    80001d06:	64a2                	ld	s1,8(sp)
    80001d08:	6902                	ld	s2,0(sp)
    80001d0a:	6105                	addi	sp,sp,32
    80001d0c:	8082                	ret
    return -1;
    80001d0e:	557d                	li	a0,-1
    80001d10:	bfcd                	j	80001d02 <fetchaddr+0x36>
    80001d12:	557d                	li	a0,-1
    80001d14:	b7fd                	j	80001d02 <fetchaddr+0x36>

0000000080001d16 <fetchstr>:
{
    80001d16:	7179                	addi	sp,sp,-48
    80001d18:	f406                	sd	ra,40(sp)
    80001d1a:	f022                	sd	s0,32(sp)
    80001d1c:	ec26                	sd	s1,24(sp)
    80001d1e:	e84a                	sd	s2,16(sp)
    80001d20:	e44e                	sd	s3,8(sp)
    80001d22:	1800                	addi	s0,sp,48
    80001d24:	89aa                	mv	s3,a0
    80001d26:	84ae                	mv	s1,a1
    80001d28:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001d2a:	8acff0ef          	jal	80000dd6 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001d2e:	86ca                	mv	a3,s2
    80001d30:	864e                	mv	a2,s3
    80001d32:	85a6                	mv	a1,s1
    80001d34:	6928                	ld	a0,80(a0)
    80001d36:	c63fe0ef          	jal	80000998 <copyinstr>
    80001d3a:	00054c63          	bltz	a0,80001d52 <fetchstr+0x3c>
  return strlen(buf);
    80001d3e:	8526                	mv	a0,s1
    80001d40:	da8fe0ef          	jal	800002e8 <strlen>
}
    80001d44:	70a2                	ld	ra,40(sp)
    80001d46:	7402                	ld	s0,32(sp)
    80001d48:	64e2                	ld	s1,24(sp)
    80001d4a:	6942                	ld	s2,16(sp)
    80001d4c:	69a2                	ld	s3,8(sp)
    80001d4e:	6145                	addi	sp,sp,48
    80001d50:	8082                	ret
    return -1;
    80001d52:	557d                	li	a0,-1
    80001d54:	bfc5                	j	80001d44 <fetchstr+0x2e>

0000000080001d56 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001d56:	1101                	addi	sp,sp,-32
    80001d58:	ec06                	sd	ra,24(sp)
    80001d5a:	e822                	sd	s0,16(sp)
    80001d5c:	e426                	sd	s1,8(sp)
    80001d5e:	1000                	addi	s0,sp,32
    80001d60:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d62:	f0bff0ef          	jal	80001c6c <argraw>
    80001d66:	c088                	sw	a0,0(s1)
}
    80001d68:	60e2                	ld	ra,24(sp)
    80001d6a:	6442                	ld	s0,16(sp)
    80001d6c:	64a2                	ld	s1,8(sp)
    80001d6e:	6105                	addi	sp,sp,32
    80001d70:	8082                	ret

0000000080001d72 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001d72:	1101                	addi	sp,sp,-32
    80001d74:	ec06                	sd	ra,24(sp)
    80001d76:	e822                	sd	s0,16(sp)
    80001d78:	e426                	sd	s1,8(sp)
    80001d7a:	1000                	addi	s0,sp,32
    80001d7c:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d7e:	eefff0ef          	jal	80001c6c <argraw>
    80001d82:	e088                	sd	a0,0(s1)
}
    80001d84:	60e2                	ld	ra,24(sp)
    80001d86:	6442                	ld	s0,16(sp)
    80001d88:	64a2                	ld	s1,8(sp)
    80001d8a:	6105                	addi	sp,sp,32
    80001d8c:	8082                	ret

0000000080001d8e <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d8e:	1101                	addi	sp,sp,-32
    80001d90:	ec06                	sd	ra,24(sp)
    80001d92:	e822                	sd	s0,16(sp)
    80001d94:	e426                	sd	s1,8(sp)
    80001d96:	e04a                	sd	s2,0(sp)
    80001d98:	1000                	addi	s0,sp,32
    80001d9a:	892e                	mv	s2,a1
    80001d9c:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001d9e:	ecfff0ef          	jal	80001c6c <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001da2:	8626                	mv	a2,s1
    80001da4:	85ca                	mv	a1,s2
    80001da6:	f71ff0ef          	jal	80001d16 <fetchstr>
}
    80001daa:	60e2                	ld	ra,24(sp)
    80001dac:	6442                	ld	s0,16(sp)
    80001dae:	64a2                	ld	s1,8(sp)
    80001db0:	6902                	ld	s2,0(sp)
    80001db2:	6105                	addi	sp,sp,32
    80001db4:	8082                	ret

0000000080001db6 <syscall>:
};


void
syscall(void)
{
    80001db6:	1101                	addi	sp,sp,-32
    80001db8:	ec06                	sd	ra,24(sp)
    80001dba:	e822                	sd	s0,16(sp)
    80001dbc:	e426                	sd	s1,8(sp)
    80001dbe:	e04a                	sd	s2,0(sp)
    80001dc0:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001dc2:	814ff0ef          	jal	80000dd6 <myproc>
    80001dc6:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001dc8:	05853903          	ld	s2,88(a0)
    80001dcc:	0a893783          	ld	a5,168(s2)
    80001dd0:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001dd4:	37fd                	addiw	a5,a5,-1
    80001dd6:	02100713          	li	a4,33
    80001dda:	00f76f63          	bltu	a4,a5,80001df8 <syscall+0x42>
    80001dde:	00369713          	slli	a4,a3,0x3
    80001de2:	00006797          	auipc	a5,0x6
    80001de6:	98e78793          	addi	a5,a5,-1650 # 80007770 <syscalls>
    80001dea:	97ba                	add	a5,a5,a4
    80001dec:	639c                	ld	a5,0(a5)
    80001dee:	c789                	beqz	a5,80001df8 <syscall+0x42>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001df0:	9782                	jalr	a5
    80001df2:	06a93823          	sd	a0,112(s2)
    80001df6:	a829                	j	80001e10 <syscall+0x5a>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001df8:	16048613          	addi	a2,s1,352
    80001dfc:	588c                	lw	a1,48(s1)
    80001dfe:	00005517          	auipc	a0,0x5
    80001e02:	52a50513          	addi	a0,a0,1322 # 80007328 <etext+0x328>
    80001e06:	616030ef          	jal	8000541c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001e0a:	6cbc                	ld	a5,88(s1)
    80001e0c:	577d                	li	a4,-1
    80001e0e:	fbb8                	sd	a4,112(a5)
  }
}
    80001e10:	60e2                	ld	ra,24(sp)
    80001e12:	6442                	ld	s0,16(sp)
    80001e14:	64a2                	ld	s1,8(sp)
    80001e16:	6902                	ld	s2,0(sp)
    80001e18:	6105                	addi	sp,sp,32
    80001e1a:	8082                	ret

0000000080001e1c <sys_exit>:
#endif
#include "vm.h"

uint64
sys_exit(void)
{
    80001e1c:	1101                	addi	sp,sp,-32
    80001e1e:	ec06                	sd	ra,24(sp)
    80001e20:	e822                	sd	s0,16(sp)
    80001e22:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001e24:	fec40593          	addi	a1,s0,-20
    80001e28:	4501                	li	a0,0
    80001e2a:	f2dff0ef          	jal	80001d56 <argint>
  kexit(n);
    80001e2e:	fec42503          	lw	a0,-20(s0)
    80001e32:	f24ff0ef          	jal	80001556 <kexit>
  return 0;  // not reached
}
    80001e36:	4501                	li	a0,0
    80001e38:	60e2                	ld	ra,24(sp)
    80001e3a:	6442                	ld	s0,16(sp)
    80001e3c:	6105                	addi	sp,sp,32
    80001e3e:	8082                	ret

0000000080001e40 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001e40:	1141                	addi	sp,sp,-16
    80001e42:	e406                	sd	ra,8(sp)
    80001e44:	e022                	sd	s0,0(sp)
    80001e46:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001e48:	f8ffe0ef          	jal	80000dd6 <myproc>
}
    80001e4c:	5908                	lw	a0,48(a0)
    80001e4e:	60a2                	ld	ra,8(sp)
    80001e50:	6402                	ld	s0,0(sp)
    80001e52:	0141                	addi	sp,sp,16
    80001e54:	8082                	ret

0000000080001e56 <sys_fork>:

uint64
sys_fork(void)
{
    80001e56:	1141                	addi	sp,sp,-16
    80001e58:	e406                	sd	ra,8(sp)
    80001e5a:	e022                	sd	s0,0(sp)
    80001e5c:	0800                	addi	s0,sp,16
  return kfork();
    80001e5e:	b44ff0ef          	jal	800011a2 <kfork>
}
    80001e62:	60a2                	ld	ra,8(sp)
    80001e64:	6402                	ld	s0,0(sp)
    80001e66:	0141                	addi	sp,sp,16
    80001e68:	8082                	ret

0000000080001e6a <sys_wait>:

uint64
sys_wait(void)
{
    80001e6a:	1101                	addi	sp,sp,-32
    80001e6c:	ec06                	sd	ra,24(sp)
    80001e6e:	e822                	sd	s0,16(sp)
    80001e70:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e72:	fe840593          	addi	a1,s0,-24
    80001e76:	4501                	li	a0,0
    80001e78:	efbff0ef          	jal	80001d72 <argaddr>
  return kwait(p);
    80001e7c:	fe843503          	ld	a0,-24(s0)
    80001e80:	831ff0ef          	jal	800016b0 <kwait>
}
    80001e84:	60e2                	ld	ra,24(sp)
    80001e86:	6442                	ld	s0,16(sp)
    80001e88:	6105                	addi	sp,sp,32
    80001e8a:	8082                	ret

0000000080001e8c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e8c:	7179                	addi	sp,sp,-48
    80001e8e:	f406                	sd	ra,40(sp)
    80001e90:	f022                	sd	s0,32(sp)
    80001e92:	ec26                	sd	s1,24(sp)
    80001e94:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001e96:	fd840593          	addi	a1,s0,-40
    80001e9a:	4501                	li	a0,0
    80001e9c:	ebbff0ef          	jal	80001d56 <argint>
  argint(1, &t);
    80001ea0:	fdc40593          	addi	a1,s0,-36
    80001ea4:	4505                	li	a0,1
    80001ea6:	eb1ff0ef          	jal	80001d56 <argint>
  addr = myproc()->sz;
    80001eaa:	f2dfe0ef          	jal	80000dd6 <myproc>
    80001eae:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001eb0:	fdc42703          	lw	a4,-36(s0)
    80001eb4:	4785                	li	a5,1
    80001eb6:	02f70163          	beq	a4,a5,80001ed8 <sys_sbrk+0x4c>
    80001eba:	fd842783          	lw	a5,-40(s0)
    80001ebe:	0007cd63          	bltz	a5,80001ed8 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001ec2:	97a6                	add	a5,a5,s1
    80001ec4:	0297e863          	bltu	a5,s1,80001ef4 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001ec8:	f0ffe0ef          	jal	80000dd6 <myproc>
    80001ecc:	fd842703          	lw	a4,-40(s0)
    80001ed0:	653c                	ld	a5,72(a0)
    80001ed2:	97ba                	add	a5,a5,a4
    80001ed4:	e53c                	sd	a5,72(a0)
    80001ed6:	a039                	j	80001ee4 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001ed8:	fd842503          	lw	a0,-40(s0)
    80001edc:	a76ff0ef          	jal	80001152 <growproc>
    80001ee0:	00054863          	bltz	a0,80001ef0 <sys_sbrk+0x64>
  }
  return addr;
}
    80001ee4:	8526                	mv	a0,s1
    80001ee6:	70a2                	ld	ra,40(sp)
    80001ee8:	7402                	ld	s0,32(sp)
    80001eea:	64e2                	ld	s1,24(sp)
    80001eec:	6145                	addi	sp,sp,48
    80001eee:	8082                	ret
      return -1;
    80001ef0:	54fd                	li	s1,-1
    80001ef2:	bfcd                	j	80001ee4 <sys_sbrk+0x58>
      return -1;
    80001ef4:	54fd                	li	s1,-1
    80001ef6:	b7fd                	j	80001ee4 <sys_sbrk+0x58>

0000000080001ef8 <sys_pause>:

uint64
sys_pause(void)
{
    80001ef8:	7139                	addi	sp,sp,-64
    80001efa:	fc06                	sd	ra,56(sp)
    80001efc:	f822                	sd	s0,48(sp)
    80001efe:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    80001f00:	fcc40593          	addi	a1,s0,-52
    80001f04:	4501                	li	a0,0
    80001f06:	e51ff0ef          	jal	80001d56 <argint>
  if(n < 0)
    80001f0a:	fcc42783          	lw	a5,-52(s0)
    80001f0e:	0607c863          	bltz	a5,80001f7e <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001f12:	0000e517          	auipc	a0,0xe
    80001f16:	c1e50513          	addi	a0,a0,-994 # 8000fb30 <tickslock>
    80001f1a:	2ef030ef          	jal	80005a08 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001f1e:	fcc42783          	lw	a5,-52(s0)
    80001f22:	c3b9                	beqz	a5,80001f68 <sys_pause+0x70>
    80001f24:	f426                	sd	s1,40(sp)
    80001f26:	f04a                	sd	s2,32(sp)
    80001f28:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001f2a:	00006997          	auipc	s3,0x6
    80001f2e:	99e9a983          	lw	s3,-1634(s3) # 800078c8 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001f32:	0000e917          	auipc	s2,0xe
    80001f36:	bfe90913          	addi	s2,s2,-1026 # 8000fb30 <tickslock>
    80001f3a:	00006497          	auipc	s1,0x6
    80001f3e:	98e48493          	addi	s1,s1,-1650 # 800078c8 <ticks>
    if(killed(myproc())){
    80001f42:	e95fe0ef          	jal	80000dd6 <myproc>
    80001f46:	f40ff0ef          	jal	80001686 <killed>
    80001f4a:	ed0d                	bnez	a0,80001f84 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001f4c:	85ca                	mv	a1,s2
    80001f4e:	8526                	mv	a0,s1
    80001f50:	cfaff0ef          	jal	8000144a <sleep>
  while(ticks - ticks0 < n){
    80001f54:	409c                	lw	a5,0(s1)
    80001f56:	413787bb          	subw	a5,a5,s3
    80001f5a:	fcc42703          	lw	a4,-52(s0)
    80001f5e:	fee7e2e3          	bltu	a5,a4,80001f42 <sys_pause+0x4a>
    80001f62:	74a2                	ld	s1,40(sp)
    80001f64:	7902                	ld	s2,32(sp)
    80001f66:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001f68:	0000e517          	auipc	a0,0xe
    80001f6c:	bc850513          	addi	a0,a0,-1080 # 8000fb30 <tickslock>
    80001f70:	32d030ef          	jal	80005a9c <release>
  return 0;
    80001f74:	4501                	li	a0,0
}
    80001f76:	70e2                	ld	ra,56(sp)
    80001f78:	7442                	ld	s0,48(sp)
    80001f7a:	6121                	addi	sp,sp,64
    80001f7c:	8082                	ret
    n = 0;
    80001f7e:	fc042623          	sw	zero,-52(s0)
    80001f82:	bf41                	j	80001f12 <sys_pause+0x1a>
      release(&tickslock);
    80001f84:	0000e517          	auipc	a0,0xe
    80001f88:	bac50513          	addi	a0,a0,-1108 # 8000fb30 <tickslock>
    80001f8c:	311030ef          	jal	80005a9c <release>
      return -1;
    80001f90:	557d                	li	a0,-1
    80001f92:	74a2                	ld	s1,40(sp)
    80001f94:	7902                	ld	s2,32(sp)
    80001f96:	69e2                	ld	s3,24(sp)
    80001f98:	bff9                	j	80001f76 <sys_pause+0x7e>

0000000080001f9a <sys_pgpte>:


#ifdef LAB_PGTBL
int
sys_pgpte(void)
{
    80001f9a:	7179                	addi	sp,sp,-48
    80001f9c:	f406                	sd	ra,40(sp)
    80001f9e:	f022                	sd	s0,32(sp)
    80001fa0:	ec26                	sd	s1,24(sp)
    80001fa2:	1800                	addi	s0,sp,48
  uint64 va;
  struct proc *p;  

  p = myproc();
    80001fa4:	e33fe0ef          	jal	80000dd6 <myproc>
    80001fa8:	84aa                	mv	s1,a0
  argaddr(0, &va);
    80001faa:	fd840593          	addi	a1,s0,-40
    80001fae:	4501                	li	a0,0
    80001fb0:	dc3ff0ef          	jal	80001d72 <argaddr>
  pte_t *pte = pgpte(p->pagetable, va);
    80001fb4:	fd843583          	ld	a1,-40(s0)
    80001fb8:	68a8                	ld	a0,80(s1)
    80001fba:	c8dfe0ef          	jal	80000c46 <pgpte>
    80001fbe:	87aa                	mv	a5,a0
  if(pte != 0) {
      return (uint64) *pte;
  }
  return 0;
    80001fc0:	4501                	li	a0,0
  if(pte != 0) {
    80001fc2:	c391                	beqz	a5,80001fc6 <sys_pgpte+0x2c>
      return (uint64) *pte;
    80001fc4:	4388                	lw	a0,0(a5)
}
    80001fc6:	70a2                	ld	ra,40(sp)
    80001fc8:	7402                	ld	s0,32(sp)
    80001fca:	64e2                	ld	s1,24(sp)
    80001fcc:	6145                	addi	sp,sp,48
    80001fce:	8082                	ret

0000000080001fd0 <sys_kpgtbl>:
#endif

#ifdef LAB_PGTBL
int
sys_kpgtbl(void)
{
    80001fd0:	1141                	addi	sp,sp,-16
    80001fd2:	e406                	sd	ra,8(sp)
    80001fd4:	e022                	sd	s0,0(sp)
    80001fd6:	0800                	addi	s0,sp,16
  struct proc *p;  

  p = myproc();
    80001fd8:	dfffe0ef          	jal	80000dd6 <myproc>
  vmprint(p->pagetable);
    80001fdc:	6928                	ld	a0,80(a0)
    80001fde:	cf6fe0ef          	jal	800004d4 <vmprint>
  return 0;
}
    80001fe2:	4501                	li	a0,0
    80001fe4:	60a2                	ld	ra,8(sp)
    80001fe6:	6402                	ld	s0,0(sp)
    80001fe8:	0141                	addi	sp,sp,16
    80001fea:	8082                	ret

0000000080001fec <sys_kill>:
#endif


uint64
sys_kill(void)
{
    80001fec:	1101                	addi	sp,sp,-32
    80001fee:	ec06                	sd	ra,24(sp)
    80001ff0:	e822                	sd	s0,16(sp)
    80001ff2:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ff4:	fec40593          	addi	a1,s0,-20
    80001ff8:	4501                	li	a0,0
    80001ffa:	d5dff0ef          	jal	80001d56 <argint>
  return kkill(pid);
    80001ffe:	fec42503          	lw	a0,-20(s0)
    80002002:	dfaff0ef          	jal	800015fc <kkill>
}
    80002006:	60e2                	ld	ra,24(sp)
    80002008:	6442                	ld	s0,16(sp)
    8000200a:	6105                	addi	sp,sp,32
    8000200c:	8082                	ret

000000008000200e <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    8000200e:	1101                	addi	sp,sp,-32
    80002010:	ec06                	sd	ra,24(sp)
    80002012:	e822                	sd	s0,16(sp)
    80002014:	e426                	sd	s1,8(sp)
    80002016:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002018:	0000e517          	auipc	a0,0xe
    8000201c:	b1850513          	addi	a0,a0,-1256 # 8000fb30 <tickslock>
    80002020:	1e9030ef          	jal	80005a08 <acquire>
  xticks = ticks;
    80002024:	00006797          	auipc	a5,0x6
    80002028:	8a47a783          	lw	a5,-1884(a5) # 800078c8 <ticks>
    8000202c:	84be                	mv	s1,a5
  release(&tickslock);
    8000202e:	0000e517          	auipc	a0,0xe
    80002032:	b0250513          	addi	a0,a0,-1278 # 8000fb30 <tickslock>
    80002036:	267030ef          	jal	80005a9c <release>
  return xticks;
}
    8000203a:	02049513          	slli	a0,s1,0x20
    8000203e:	9101                	srli	a0,a0,0x20
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6105                	addi	sp,sp,32
    80002048:	8082                	ret

000000008000204a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000204a:	7179                	addi	sp,sp,-48
    8000204c:	f406                	sd	ra,40(sp)
    8000204e:	f022                	sd	s0,32(sp)
    80002050:	ec26                	sd	s1,24(sp)
    80002052:	e84a                	sd	s2,16(sp)
    80002054:	e44e                	sd	s3,8(sp)
    80002056:	e052                	sd	s4,0(sp)
    80002058:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000205a:	00005597          	auipc	a1,0x5
    8000205e:	2ee58593          	addi	a1,a1,750 # 80007348 <etext+0x348>
    80002062:	0000e517          	auipc	a0,0xe
    80002066:	ae650513          	addi	a0,a0,-1306 # 8000fb48 <bcache>
    8000206a:	115030ef          	jal	8000597e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000206e:	00016797          	auipc	a5,0x16
    80002072:	ada78793          	addi	a5,a5,-1318 # 80017b48 <bcache+0x8000>
    80002076:	00016717          	auipc	a4,0x16
    8000207a:	d3a70713          	addi	a4,a4,-710 # 80017db0 <bcache+0x8268>
    8000207e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002082:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002086:	0000e497          	auipc	s1,0xe
    8000208a:	ada48493          	addi	s1,s1,-1318 # 8000fb60 <bcache+0x18>
    b->next = bcache.head.next;
    8000208e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002090:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002092:	00005a17          	auipc	s4,0x5
    80002096:	2bea0a13          	addi	s4,s4,702 # 80007350 <etext+0x350>
    b->next = bcache.head.next;
    8000209a:	2b893783          	ld	a5,696(s2)
    8000209e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800020a0:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800020a4:	85d2                	mv	a1,s4
    800020a6:	01048513          	addi	a0,s1,16
    800020aa:	328010ef          	jal	800033d2 <initsleeplock>
    bcache.head.next->prev = b;
    800020ae:	2b893783          	ld	a5,696(s2)
    800020b2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800020b4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020b8:	45848493          	addi	s1,s1,1112
    800020bc:	fd349fe3          	bne	s1,s3,8000209a <binit+0x50>
  }
}
    800020c0:	70a2                	ld	ra,40(sp)
    800020c2:	7402                	ld	s0,32(sp)
    800020c4:	64e2                	ld	s1,24(sp)
    800020c6:	6942                	ld	s2,16(sp)
    800020c8:	69a2                	ld	s3,8(sp)
    800020ca:	6a02                	ld	s4,0(sp)
    800020cc:	6145                	addi	sp,sp,48
    800020ce:	8082                	ret

00000000800020d0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800020d0:	7179                	addi	sp,sp,-48
    800020d2:	f406                	sd	ra,40(sp)
    800020d4:	f022                	sd	s0,32(sp)
    800020d6:	ec26                	sd	s1,24(sp)
    800020d8:	e84a                	sd	s2,16(sp)
    800020da:	e44e                	sd	s3,8(sp)
    800020dc:	1800                	addi	s0,sp,48
    800020de:	892a                	mv	s2,a0
    800020e0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800020e2:	0000e517          	auipc	a0,0xe
    800020e6:	a6650513          	addi	a0,a0,-1434 # 8000fb48 <bcache>
    800020ea:	11f030ef          	jal	80005a08 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800020ee:	00016497          	auipc	s1,0x16
    800020f2:	d124b483          	ld	s1,-750(s1) # 80017e00 <bcache+0x82b8>
    800020f6:	00016797          	auipc	a5,0x16
    800020fa:	cba78793          	addi	a5,a5,-838 # 80017db0 <bcache+0x8268>
    800020fe:	02f48b63          	beq	s1,a5,80002134 <bread+0x64>
    80002102:	873e                	mv	a4,a5
    80002104:	a021                	j	8000210c <bread+0x3c>
    80002106:	68a4                	ld	s1,80(s1)
    80002108:	02e48663          	beq	s1,a4,80002134 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000210c:	449c                	lw	a5,8(s1)
    8000210e:	ff279ce3          	bne	a5,s2,80002106 <bread+0x36>
    80002112:	44dc                	lw	a5,12(s1)
    80002114:	ff3799e3          	bne	a5,s3,80002106 <bread+0x36>
      b->refcnt++;
    80002118:	40bc                	lw	a5,64(s1)
    8000211a:	2785                	addiw	a5,a5,1
    8000211c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000211e:	0000e517          	auipc	a0,0xe
    80002122:	a2a50513          	addi	a0,a0,-1494 # 8000fb48 <bcache>
    80002126:	177030ef          	jal	80005a9c <release>
      acquiresleep(&b->lock);
    8000212a:	01048513          	addi	a0,s1,16
    8000212e:	2da010ef          	jal	80003408 <acquiresleep>
      return b;
    80002132:	a889                	j	80002184 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002134:	00016497          	auipc	s1,0x16
    80002138:	cc44b483          	ld	s1,-828(s1) # 80017df8 <bcache+0x82b0>
    8000213c:	00016797          	auipc	a5,0x16
    80002140:	c7478793          	addi	a5,a5,-908 # 80017db0 <bcache+0x8268>
    80002144:	00f48863          	beq	s1,a5,80002154 <bread+0x84>
    80002148:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000214a:	40bc                	lw	a5,64(s1)
    8000214c:	cb91                	beqz	a5,80002160 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000214e:	64a4                	ld	s1,72(s1)
    80002150:	fee49de3          	bne	s1,a4,8000214a <bread+0x7a>
  panic("bget: no buffers");
    80002154:	00005517          	auipc	a0,0x5
    80002158:	20450513          	addi	a0,a0,516 # 80007358 <etext+0x358>
    8000215c:	5ea030ef          	jal	80005746 <panic>
      b->dev = dev;
    80002160:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002164:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002168:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000216c:	4785                	li	a5,1
    8000216e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002170:	0000e517          	auipc	a0,0xe
    80002174:	9d850513          	addi	a0,a0,-1576 # 8000fb48 <bcache>
    80002178:	125030ef          	jal	80005a9c <release>
      acquiresleep(&b->lock);
    8000217c:	01048513          	addi	a0,s1,16
    80002180:	288010ef          	jal	80003408 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002184:	409c                	lw	a5,0(s1)
    80002186:	cb89                	beqz	a5,80002198 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002188:	8526                	mv	a0,s1
    8000218a:	70a2                	ld	ra,40(sp)
    8000218c:	7402                	ld	s0,32(sp)
    8000218e:	64e2                	ld	s1,24(sp)
    80002190:	6942                	ld	s2,16(sp)
    80002192:	69a2                	ld	s3,8(sp)
    80002194:	6145                	addi	sp,sp,48
    80002196:	8082                	ret
    virtio_disk_rw(b, 0);
    80002198:	4581                	li	a1,0
    8000219a:	8526                	mv	a0,s1
    8000219c:	2e5020ef          	jal	80004c80 <virtio_disk_rw>
    b->valid = 1;
    800021a0:	4785                	li	a5,1
    800021a2:	c09c                	sw	a5,0(s1)
  return b;
    800021a4:	b7d5                	j	80002188 <bread+0xb8>

00000000800021a6 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800021a6:	1101                	addi	sp,sp,-32
    800021a8:	ec06                	sd	ra,24(sp)
    800021aa:	e822                	sd	s0,16(sp)
    800021ac:	e426                	sd	s1,8(sp)
    800021ae:	1000                	addi	s0,sp,32
    800021b0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021b2:	0541                	addi	a0,a0,16
    800021b4:	2d2010ef          	jal	80003486 <holdingsleep>
    800021b8:	c911                	beqz	a0,800021cc <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021ba:	4585                	li	a1,1
    800021bc:	8526                	mv	a0,s1
    800021be:	2c3020ef          	jal	80004c80 <virtio_disk_rw>
}
    800021c2:	60e2                	ld	ra,24(sp)
    800021c4:	6442                	ld	s0,16(sp)
    800021c6:	64a2                	ld	s1,8(sp)
    800021c8:	6105                	addi	sp,sp,32
    800021ca:	8082                	ret
    panic("bwrite");
    800021cc:	00005517          	auipc	a0,0x5
    800021d0:	1a450513          	addi	a0,a0,420 # 80007370 <etext+0x370>
    800021d4:	572030ef          	jal	80005746 <panic>

00000000800021d8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800021d8:	1101                	addi	sp,sp,-32
    800021da:	ec06                	sd	ra,24(sp)
    800021dc:	e822                	sd	s0,16(sp)
    800021de:	e426                	sd	s1,8(sp)
    800021e0:	e04a                	sd	s2,0(sp)
    800021e2:	1000                	addi	s0,sp,32
    800021e4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021e6:	01050913          	addi	s2,a0,16
    800021ea:	854a                	mv	a0,s2
    800021ec:	29a010ef          	jal	80003486 <holdingsleep>
    800021f0:	c125                	beqz	a0,80002250 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800021f2:	854a                	mv	a0,s2
    800021f4:	25a010ef          	jal	8000344e <releasesleep>

  acquire(&bcache.lock);
    800021f8:	0000e517          	auipc	a0,0xe
    800021fc:	95050513          	addi	a0,a0,-1712 # 8000fb48 <bcache>
    80002200:	009030ef          	jal	80005a08 <acquire>
  b->refcnt--;
    80002204:	40bc                	lw	a5,64(s1)
    80002206:	37fd                	addiw	a5,a5,-1
    80002208:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000220a:	e79d                	bnez	a5,80002238 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000220c:	68b8                	ld	a4,80(s1)
    8000220e:	64bc                	ld	a5,72(s1)
    80002210:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002212:	68b8                	ld	a4,80(s1)
    80002214:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002216:	00016797          	auipc	a5,0x16
    8000221a:	93278793          	addi	a5,a5,-1742 # 80017b48 <bcache+0x8000>
    8000221e:	2b87b703          	ld	a4,696(a5)
    80002222:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002224:	00016717          	auipc	a4,0x16
    80002228:	b8c70713          	addi	a4,a4,-1140 # 80017db0 <bcache+0x8268>
    8000222c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000222e:	2b87b703          	ld	a4,696(a5)
    80002232:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002234:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002238:	0000e517          	auipc	a0,0xe
    8000223c:	91050513          	addi	a0,a0,-1776 # 8000fb48 <bcache>
    80002240:	05d030ef          	jal	80005a9c <release>
}
    80002244:	60e2                	ld	ra,24(sp)
    80002246:	6442                	ld	s0,16(sp)
    80002248:	64a2                	ld	s1,8(sp)
    8000224a:	6902                	ld	s2,0(sp)
    8000224c:	6105                	addi	sp,sp,32
    8000224e:	8082                	ret
    panic("brelse");
    80002250:	00005517          	auipc	a0,0x5
    80002254:	12850513          	addi	a0,a0,296 # 80007378 <etext+0x378>
    80002258:	4ee030ef          	jal	80005746 <panic>

000000008000225c <bpin>:

void
bpin(struct buf *b) {
    8000225c:	1101                	addi	sp,sp,-32
    8000225e:	ec06                	sd	ra,24(sp)
    80002260:	e822                	sd	s0,16(sp)
    80002262:	e426                	sd	s1,8(sp)
    80002264:	1000                	addi	s0,sp,32
    80002266:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002268:	0000e517          	auipc	a0,0xe
    8000226c:	8e050513          	addi	a0,a0,-1824 # 8000fb48 <bcache>
    80002270:	798030ef          	jal	80005a08 <acquire>
  b->refcnt++;
    80002274:	40bc                	lw	a5,64(s1)
    80002276:	2785                	addiw	a5,a5,1
    80002278:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000227a:	0000e517          	auipc	a0,0xe
    8000227e:	8ce50513          	addi	a0,a0,-1842 # 8000fb48 <bcache>
    80002282:	01b030ef          	jal	80005a9c <release>
}
    80002286:	60e2                	ld	ra,24(sp)
    80002288:	6442                	ld	s0,16(sp)
    8000228a:	64a2                	ld	s1,8(sp)
    8000228c:	6105                	addi	sp,sp,32
    8000228e:	8082                	ret

0000000080002290 <bunpin>:

void
bunpin(struct buf *b) {
    80002290:	1101                	addi	sp,sp,-32
    80002292:	ec06                	sd	ra,24(sp)
    80002294:	e822                	sd	s0,16(sp)
    80002296:	e426                	sd	s1,8(sp)
    80002298:	1000                	addi	s0,sp,32
    8000229a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000229c:	0000e517          	auipc	a0,0xe
    800022a0:	8ac50513          	addi	a0,a0,-1876 # 8000fb48 <bcache>
    800022a4:	764030ef          	jal	80005a08 <acquire>
  b->refcnt--;
    800022a8:	40bc                	lw	a5,64(s1)
    800022aa:	37fd                	addiw	a5,a5,-1
    800022ac:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022ae:	0000e517          	auipc	a0,0xe
    800022b2:	89a50513          	addi	a0,a0,-1894 # 8000fb48 <bcache>
    800022b6:	7e6030ef          	jal	80005a9c <release>
}
    800022ba:	60e2                	ld	ra,24(sp)
    800022bc:	6442                	ld	s0,16(sp)
    800022be:	64a2                	ld	s1,8(sp)
    800022c0:	6105                	addi	sp,sp,32
    800022c2:	8082                	ret

00000000800022c4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800022c4:	1101                	addi	sp,sp,-32
    800022c6:	ec06                	sd	ra,24(sp)
    800022c8:	e822                	sd	s0,16(sp)
    800022ca:	e426                	sd	s1,8(sp)
    800022cc:	e04a                	sd	s2,0(sp)
    800022ce:	1000                	addi	s0,sp,32
    800022d0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800022d2:	00d5d79b          	srliw	a5,a1,0xd
    800022d6:	00016597          	auipc	a1,0x16
    800022da:	f4e5a583          	lw	a1,-178(a1) # 80018224 <sb+0x1c>
    800022de:	9dbd                	addw	a1,a1,a5
    800022e0:	df1ff0ef          	jal	800020d0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800022e4:	0074f713          	andi	a4,s1,7
    800022e8:	4785                	li	a5,1
    800022ea:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800022ee:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800022f0:	90d9                	srli	s1,s1,0x36
    800022f2:	00950733          	add	a4,a0,s1
    800022f6:	05874703          	lbu	a4,88(a4)
    800022fa:	00e7f6b3          	and	a3,a5,a4
    800022fe:	c29d                	beqz	a3,80002324 <bfree+0x60>
    80002300:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002302:	94aa                	add	s1,s1,a0
    80002304:	fff7c793          	not	a5,a5
    80002308:	8f7d                	and	a4,a4,a5
    8000230a:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000230e:	000010ef          	jal	8000330e <log_write>
  brelse(bp);
    80002312:	854a                	mv	a0,s2
    80002314:	ec5ff0ef          	jal	800021d8 <brelse>
}
    80002318:	60e2                	ld	ra,24(sp)
    8000231a:	6442                	ld	s0,16(sp)
    8000231c:	64a2                	ld	s1,8(sp)
    8000231e:	6902                	ld	s2,0(sp)
    80002320:	6105                	addi	sp,sp,32
    80002322:	8082                	ret
    panic("freeing free block");
    80002324:	00005517          	auipc	a0,0x5
    80002328:	05c50513          	addi	a0,a0,92 # 80007380 <etext+0x380>
    8000232c:	41a030ef          	jal	80005746 <panic>

0000000080002330 <balloc>:
{
    80002330:	715d                	addi	sp,sp,-80
    80002332:	e486                	sd	ra,72(sp)
    80002334:	e0a2                	sd	s0,64(sp)
    80002336:	fc26                	sd	s1,56(sp)
    80002338:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000233a:	00016797          	auipc	a5,0x16
    8000233e:	ed27a783          	lw	a5,-302(a5) # 8001820c <sb+0x4>
    80002342:	0e078263          	beqz	a5,80002426 <balloc+0xf6>
    80002346:	f84a                	sd	s2,48(sp)
    80002348:	f44e                	sd	s3,40(sp)
    8000234a:	f052                	sd	s4,32(sp)
    8000234c:	ec56                	sd	s5,24(sp)
    8000234e:	e85a                	sd	s6,16(sp)
    80002350:	e45e                	sd	s7,8(sp)
    80002352:	e062                	sd	s8,0(sp)
    80002354:	8baa                	mv	s7,a0
    80002356:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002358:	00016b17          	auipc	s6,0x16
    8000235c:	eb0b0b13          	addi	s6,s6,-336 # 80018208 <sb>
      m = 1 << (bi % 8);
    80002360:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002362:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002364:	6c09                	lui	s8,0x2
    80002366:	a09d                	j	800023cc <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002368:	97ca                	add	a5,a5,s2
    8000236a:	8e55                	or	a2,a2,a3
    8000236c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002370:	854a                	mv	a0,s2
    80002372:	79d000ef          	jal	8000330e <log_write>
        brelse(bp);
    80002376:	854a                	mv	a0,s2
    80002378:	e61ff0ef          	jal	800021d8 <brelse>
  bp = bread(dev, bno);
    8000237c:	85a6                	mv	a1,s1
    8000237e:	855e                	mv	a0,s7
    80002380:	d51ff0ef          	jal	800020d0 <bread>
    80002384:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002386:	40000613          	li	a2,1024
    8000238a:	4581                	li	a1,0
    8000238c:	05850513          	addi	a0,a0,88
    80002390:	dcffd0ef          	jal	8000015e <memset>
  log_write(bp);
    80002394:	854a                	mv	a0,s2
    80002396:	779000ef          	jal	8000330e <log_write>
  brelse(bp);
    8000239a:	854a                	mv	a0,s2
    8000239c:	e3dff0ef          	jal	800021d8 <brelse>
}
    800023a0:	7942                	ld	s2,48(sp)
    800023a2:	79a2                	ld	s3,40(sp)
    800023a4:	7a02                	ld	s4,32(sp)
    800023a6:	6ae2                	ld	s5,24(sp)
    800023a8:	6b42                	ld	s6,16(sp)
    800023aa:	6ba2                	ld	s7,8(sp)
    800023ac:	6c02                	ld	s8,0(sp)
}
    800023ae:	8526                	mv	a0,s1
    800023b0:	60a6                	ld	ra,72(sp)
    800023b2:	6406                	ld	s0,64(sp)
    800023b4:	74e2                	ld	s1,56(sp)
    800023b6:	6161                	addi	sp,sp,80
    800023b8:	8082                	ret
    brelse(bp);
    800023ba:	854a                	mv	a0,s2
    800023bc:	e1dff0ef          	jal	800021d8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800023c0:	015c0abb          	addw	s5,s8,s5
    800023c4:	004b2783          	lw	a5,4(s6)
    800023c8:	04faf863          	bgeu	s5,a5,80002418 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800023cc:	40dad59b          	sraiw	a1,s5,0xd
    800023d0:	01cb2783          	lw	a5,28(s6)
    800023d4:	9dbd                	addw	a1,a1,a5
    800023d6:	855e                	mv	a0,s7
    800023d8:	cf9ff0ef          	jal	800020d0 <bread>
    800023dc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023de:	004b2503          	lw	a0,4(s6)
    800023e2:	84d6                	mv	s1,s5
    800023e4:	4701                	li	a4,0
    800023e6:	fca4fae3          	bgeu	s1,a0,800023ba <balloc+0x8a>
      m = 1 << (bi % 8);
    800023ea:	00777693          	andi	a3,a4,7
    800023ee:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800023f2:	41f7579b          	sraiw	a5,a4,0x1f
    800023f6:	01d7d79b          	srliw	a5,a5,0x1d
    800023fa:	9fb9                	addw	a5,a5,a4
    800023fc:	4037d79b          	sraiw	a5,a5,0x3
    80002400:	00f90633          	add	a2,s2,a5
    80002404:	05864603          	lbu	a2,88(a2)
    80002408:	00c6f5b3          	and	a1,a3,a2
    8000240c:	ddb1                	beqz	a1,80002368 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000240e:	2705                	addiw	a4,a4,1
    80002410:	2485                	addiw	s1,s1,1
    80002412:	fd471ae3          	bne	a4,s4,800023e6 <balloc+0xb6>
    80002416:	b755                	j	800023ba <balloc+0x8a>
    80002418:	7942                	ld	s2,48(sp)
    8000241a:	79a2                	ld	s3,40(sp)
    8000241c:	7a02                	ld	s4,32(sp)
    8000241e:	6ae2                	ld	s5,24(sp)
    80002420:	6b42                	ld	s6,16(sp)
    80002422:	6ba2                	ld	s7,8(sp)
    80002424:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002426:	00005517          	auipc	a0,0x5
    8000242a:	f7250513          	addi	a0,a0,-142 # 80007398 <etext+0x398>
    8000242e:	7ef020ef          	jal	8000541c <printf>
  return 0;
    80002432:	4481                	li	s1,0
    80002434:	bfad                	j	800023ae <balloc+0x7e>

0000000080002436 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002436:	7179                	addi	sp,sp,-48
    80002438:	f406                	sd	ra,40(sp)
    8000243a:	f022                	sd	s0,32(sp)
    8000243c:	ec26                	sd	s1,24(sp)
    8000243e:	e84a                	sd	s2,16(sp)
    80002440:	e44e                	sd	s3,8(sp)
    80002442:	1800                	addi	s0,sp,48
    80002444:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002446:	47ad                	li	a5,11
    80002448:	02b7e363          	bltu	a5,a1,8000246e <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000244c:	02059793          	slli	a5,a1,0x20
    80002450:	01e7d593          	srli	a1,a5,0x1e
    80002454:	00b509b3          	add	s3,a0,a1
    80002458:	0509a483          	lw	s1,80(s3)
    8000245c:	e0b5                	bnez	s1,800024c0 <bmap+0x8a>
      addr = balloc(ip->dev);
    8000245e:	4108                	lw	a0,0(a0)
    80002460:	ed1ff0ef          	jal	80002330 <balloc>
    80002464:	84aa                	mv	s1,a0
      if(addr == 0)
    80002466:	cd29                	beqz	a0,800024c0 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002468:	04a9a823          	sw	a0,80(s3)
    8000246c:	a891                	j	800024c0 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000246e:	ff45879b          	addiw	a5,a1,-12
    80002472:	873e                	mv	a4,a5
    80002474:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80002476:	0ff00793          	li	a5,255
    8000247a:	06e7e763          	bltu	a5,a4,800024e8 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000247e:	08052483          	lw	s1,128(a0)
    80002482:	e891                	bnez	s1,80002496 <bmap+0x60>
      addr = balloc(ip->dev);
    80002484:	4108                	lw	a0,0(a0)
    80002486:	eabff0ef          	jal	80002330 <balloc>
    8000248a:	84aa                	mv	s1,a0
      if(addr == 0)
    8000248c:	c915                	beqz	a0,800024c0 <bmap+0x8a>
    8000248e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002490:	08a92023          	sw	a0,128(s2)
    80002494:	a011                	j	80002498 <bmap+0x62>
    80002496:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002498:	85a6                	mv	a1,s1
    8000249a:	00092503          	lw	a0,0(s2)
    8000249e:	c33ff0ef          	jal	800020d0 <bread>
    800024a2:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800024a4:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800024a8:	02099713          	slli	a4,s3,0x20
    800024ac:	01e75593          	srli	a1,a4,0x1e
    800024b0:	97ae                	add	a5,a5,a1
    800024b2:	89be                	mv	s3,a5
    800024b4:	4384                	lw	s1,0(a5)
    800024b6:	cc89                	beqz	s1,800024d0 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800024b8:	8552                	mv	a0,s4
    800024ba:	d1fff0ef          	jal	800021d8 <brelse>
    return addr;
    800024be:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800024c0:	8526                	mv	a0,s1
    800024c2:	70a2                	ld	ra,40(sp)
    800024c4:	7402                	ld	s0,32(sp)
    800024c6:	64e2                	ld	s1,24(sp)
    800024c8:	6942                	ld	s2,16(sp)
    800024ca:	69a2                	ld	s3,8(sp)
    800024cc:	6145                	addi	sp,sp,48
    800024ce:	8082                	ret
      addr = balloc(ip->dev);
    800024d0:	00092503          	lw	a0,0(s2)
    800024d4:	e5dff0ef          	jal	80002330 <balloc>
    800024d8:	84aa                	mv	s1,a0
      if(addr){
    800024da:	dd79                	beqz	a0,800024b8 <bmap+0x82>
        a[bn] = addr;
    800024dc:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800024e0:	8552                	mv	a0,s4
    800024e2:	62d000ef          	jal	8000330e <log_write>
    800024e6:	bfc9                	j	800024b8 <bmap+0x82>
    800024e8:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800024ea:	00005517          	auipc	a0,0x5
    800024ee:	ec650513          	addi	a0,a0,-314 # 800073b0 <etext+0x3b0>
    800024f2:	254030ef          	jal	80005746 <panic>

00000000800024f6 <iget>:
{
    800024f6:	7179                	addi	sp,sp,-48
    800024f8:	f406                	sd	ra,40(sp)
    800024fa:	f022                	sd	s0,32(sp)
    800024fc:	ec26                	sd	s1,24(sp)
    800024fe:	e84a                	sd	s2,16(sp)
    80002500:	e44e                	sd	s3,8(sp)
    80002502:	e052                	sd	s4,0(sp)
    80002504:	1800                	addi	s0,sp,48
    80002506:	892a                	mv	s2,a0
    80002508:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    8000250a:	00016517          	auipc	a0,0x16
    8000250e:	d1e50513          	addi	a0,a0,-738 # 80018228 <itable>
    80002512:	4f6030ef          	jal	80005a08 <acquire>
  empty = 0;
    80002516:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002518:	00016497          	auipc	s1,0x16
    8000251c:	d2848493          	addi	s1,s1,-728 # 80018240 <itable+0x18>
    80002520:	00017697          	auipc	a3,0x17
    80002524:	7b068693          	addi	a3,a3,1968 # 80019cd0 <log>
    80002528:	a809                	j	8000253a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000252a:	e781                	bnez	a5,80002532 <iget+0x3c>
    8000252c:	00099363          	bnez	s3,80002532 <iget+0x3c>
      empty = ip;
    80002530:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002532:	08848493          	addi	s1,s1,136
    80002536:	02d48563          	beq	s1,a3,80002560 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000253a:	449c                	lw	a5,8(s1)
    8000253c:	fef057e3          	blez	a5,8000252a <iget+0x34>
    80002540:	4098                	lw	a4,0(s1)
    80002542:	ff2718e3          	bne	a4,s2,80002532 <iget+0x3c>
    80002546:	40d8                	lw	a4,4(s1)
    80002548:	ff4715e3          	bne	a4,s4,80002532 <iget+0x3c>
      ip->ref++;
    8000254c:	2785                	addiw	a5,a5,1
    8000254e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002550:	00016517          	auipc	a0,0x16
    80002554:	cd850513          	addi	a0,a0,-808 # 80018228 <itable>
    80002558:	544030ef          	jal	80005a9c <release>
      return ip;
    8000255c:	89a6                	mv	s3,s1
    8000255e:	a015                	j	80002582 <iget+0x8c>
  if(empty == 0)
    80002560:	02098a63          	beqz	s3,80002594 <iget+0x9e>
  ip->dev = dev;
    80002564:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002568:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    8000256c:	4785                	li	a5,1
    8000256e:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002572:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80002576:	00016517          	auipc	a0,0x16
    8000257a:	cb250513          	addi	a0,a0,-846 # 80018228 <itable>
    8000257e:	51e030ef          	jal	80005a9c <release>
}
    80002582:	854e                	mv	a0,s3
    80002584:	70a2                	ld	ra,40(sp)
    80002586:	7402                	ld	s0,32(sp)
    80002588:	64e2                	ld	s1,24(sp)
    8000258a:	6942                	ld	s2,16(sp)
    8000258c:	69a2                	ld	s3,8(sp)
    8000258e:	6a02                	ld	s4,0(sp)
    80002590:	6145                	addi	sp,sp,48
    80002592:	8082                	ret
    panic("iget: no inodes");
    80002594:	00005517          	auipc	a0,0x5
    80002598:	e3450513          	addi	a0,a0,-460 # 800073c8 <etext+0x3c8>
    8000259c:	1aa030ef          	jal	80005746 <panic>

00000000800025a0 <iinit>:
{
    800025a0:	7179                	addi	sp,sp,-48
    800025a2:	f406                	sd	ra,40(sp)
    800025a4:	f022                	sd	s0,32(sp)
    800025a6:	ec26                	sd	s1,24(sp)
    800025a8:	e84a                	sd	s2,16(sp)
    800025aa:	e44e                	sd	s3,8(sp)
    800025ac:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025ae:	00005597          	auipc	a1,0x5
    800025b2:	e2a58593          	addi	a1,a1,-470 # 800073d8 <etext+0x3d8>
    800025b6:	00016517          	auipc	a0,0x16
    800025ba:	c7250513          	addi	a0,a0,-910 # 80018228 <itable>
    800025be:	3c0030ef          	jal	8000597e <initlock>
  for(i = 0; i < NINODE; i++) {
    800025c2:	00016497          	auipc	s1,0x16
    800025c6:	c8e48493          	addi	s1,s1,-882 # 80018250 <itable+0x28>
    800025ca:	00017997          	auipc	s3,0x17
    800025ce:	71698993          	addi	s3,s3,1814 # 80019ce0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025d2:	00005917          	auipc	s2,0x5
    800025d6:	e0e90913          	addi	s2,s2,-498 # 800073e0 <etext+0x3e0>
    800025da:	85ca                	mv	a1,s2
    800025dc:	8526                	mv	a0,s1
    800025de:	5f5000ef          	jal	800033d2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025e2:	08848493          	addi	s1,s1,136
    800025e6:	ff349ae3          	bne	s1,s3,800025da <iinit+0x3a>
}
    800025ea:	70a2                	ld	ra,40(sp)
    800025ec:	7402                	ld	s0,32(sp)
    800025ee:	64e2                	ld	s1,24(sp)
    800025f0:	6942                	ld	s2,16(sp)
    800025f2:	69a2                	ld	s3,8(sp)
    800025f4:	6145                	addi	sp,sp,48
    800025f6:	8082                	ret

00000000800025f8 <ialloc>:
{
    800025f8:	7139                	addi	sp,sp,-64
    800025fa:	fc06                	sd	ra,56(sp)
    800025fc:	f822                	sd	s0,48(sp)
    800025fe:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002600:	00016717          	auipc	a4,0x16
    80002604:	c1472703          	lw	a4,-1004(a4) # 80018214 <sb+0xc>
    80002608:	4785                	li	a5,1
    8000260a:	06e7f063          	bgeu	a5,a4,8000266a <ialloc+0x72>
    8000260e:	f426                	sd	s1,40(sp)
    80002610:	f04a                	sd	s2,32(sp)
    80002612:	ec4e                	sd	s3,24(sp)
    80002614:	e852                	sd	s4,16(sp)
    80002616:	e456                	sd	s5,8(sp)
    80002618:	e05a                	sd	s6,0(sp)
    8000261a:	8aaa                	mv	s5,a0
    8000261c:	8b2e                	mv	s6,a1
    8000261e:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002620:	00016a17          	auipc	s4,0x16
    80002624:	be8a0a13          	addi	s4,s4,-1048 # 80018208 <sb>
    80002628:	00495593          	srli	a1,s2,0x4
    8000262c:	018a2783          	lw	a5,24(s4)
    80002630:	9dbd                	addw	a1,a1,a5
    80002632:	8556                	mv	a0,s5
    80002634:	a9dff0ef          	jal	800020d0 <bread>
    80002638:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000263a:	05850993          	addi	s3,a0,88
    8000263e:	00f97793          	andi	a5,s2,15
    80002642:	079a                	slli	a5,a5,0x6
    80002644:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002646:	00099783          	lh	a5,0(s3)
    8000264a:	cb9d                	beqz	a5,80002680 <ialloc+0x88>
    brelse(bp);
    8000264c:	b8dff0ef          	jal	800021d8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002650:	0905                	addi	s2,s2,1
    80002652:	00ca2703          	lw	a4,12(s4)
    80002656:	0009079b          	sext.w	a5,s2
    8000265a:	fce7e7e3          	bltu	a5,a4,80002628 <ialloc+0x30>
    8000265e:	74a2                	ld	s1,40(sp)
    80002660:	7902                	ld	s2,32(sp)
    80002662:	69e2                	ld	s3,24(sp)
    80002664:	6a42                	ld	s4,16(sp)
    80002666:	6aa2                	ld	s5,8(sp)
    80002668:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000266a:	00005517          	auipc	a0,0x5
    8000266e:	d7e50513          	addi	a0,a0,-642 # 800073e8 <etext+0x3e8>
    80002672:	5ab020ef          	jal	8000541c <printf>
  return 0;
    80002676:	4501                	li	a0,0
}
    80002678:	70e2                	ld	ra,56(sp)
    8000267a:	7442                	ld	s0,48(sp)
    8000267c:	6121                	addi	sp,sp,64
    8000267e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002680:	04000613          	li	a2,64
    80002684:	4581                	li	a1,0
    80002686:	854e                	mv	a0,s3
    80002688:	ad7fd0ef          	jal	8000015e <memset>
      dip->type = type;
    8000268c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002690:	8526                	mv	a0,s1
    80002692:	47d000ef          	jal	8000330e <log_write>
      brelse(bp);
    80002696:	8526                	mv	a0,s1
    80002698:	b41ff0ef          	jal	800021d8 <brelse>
      return iget(dev, inum);
    8000269c:	0009059b          	sext.w	a1,s2
    800026a0:	8556                	mv	a0,s5
    800026a2:	e55ff0ef          	jal	800024f6 <iget>
    800026a6:	74a2                	ld	s1,40(sp)
    800026a8:	7902                	ld	s2,32(sp)
    800026aa:	69e2                	ld	s3,24(sp)
    800026ac:	6a42                	ld	s4,16(sp)
    800026ae:	6aa2                	ld	s5,8(sp)
    800026b0:	6b02                	ld	s6,0(sp)
    800026b2:	b7d9                	j	80002678 <ialloc+0x80>

00000000800026b4 <iupdate>:
{
    800026b4:	1101                	addi	sp,sp,-32
    800026b6:	ec06                	sd	ra,24(sp)
    800026b8:	e822                	sd	s0,16(sp)
    800026ba:	e426                	sd	s1,8(sp)
    800026bc:	e04a                	sd	s2,0(sp)
    800026be:	1000                	addi	s0,sp,32
    800026c0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026c2:	415c                	lw	a5,4(a0)
    800026c4:	0047d79b          	srliw	a5,a5,0x4
    800026c8:	00016597          	auipc	a1,0x16
    800026cc:	b585a583          	lw	a1,-1192(a1) # 80018220 <sb+0x18>
    800026d0:	9dbd                	addw	a1,a1,a5
    800026d2:	4108                	lw	a0,0(a0)
    800026d4:	9fdff0ef          	jal	800020d0 <bread>
    800026d8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026da:	05850793          	addi	a5,a0,88
    800026de:	40d8                	lw	a4,4(s1)
    800026e0:	8b3d                	andi	a4,a4,15
    800026e2:	071a                	slli	a4,a4,0x6
    800026e4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026e6:	04449703          	lh	a4,68(s1)
    800026ea:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026ee:	04649703          	lh	a4,70(s1)
    800026f2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800026f6:	04849703          	lh	a4,72(s1)
    800026fa:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800026fe:	04a49703          	lh	a4,74(s1)
    80002702:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002706:	44f8                	lw	a4,76(s1)
    80002708:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    8000270a:	03400613          	li	a2,52
    8000270e:	05048593          	addi	a1,s1,80
    80002712:	00c78513          	addi	a0,a5,12
    80002716:	aa9fd0ef          	jal	800001be <memmove>
  log_write(bp);
    8000271a:	854a                	mv	a0,s2
    8000271c:	3f3000ef          	jal	8000330e <log_write>
  brelse(bp);
    80002720:	854a                	mv	a0,s2
    80002722:	ab7ff0ef          	jal	800021d8 <brelse>
}
    80002726:	60e2                	ld	ra,24(sp)
    80002728:	6442                	ld	s0,16(sp)
    8000272a:	64a2                	ld	s1,8(sp)
    8000272c:	6902                	ld	s2,0(sp)
    8000272e:	6105                	addi	sp,sp,32
    80002730:	8082                	ret

0000000080002732 <idup>:
{
    80002732:	1101                	addi	sp,sp,-32
    80002734:	ec06                	sd	ra,24(sp)
    80002736:	e822                	sd	s0,16(sp)
    80002738:	e426                	sd	s1,8(sp)
    8000273a:	1000                	addi	s0,sp,32
    8000273c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000273e:	00016517          	auipc	a0,0x16
    80002742:	aea50513          	addi	a0,a0,-1302 # 80018228 <itable>
    80002746:	2c2030ef          	jal	80005a08 <acquire>
  ip->ref++;
    8000274a:	449c                	lw	a5,8(s1)
    8000274c:	2785                	addiw	a5,a5,1
    8000274e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002750:	00016517          	auipc	a0,0x16
    80002754:	ad850513          	addi	a0,a0,-1320 # 80018228 <itable>
    80002758:	344030ef          	jal	80005a9c <release>
}
    8000275c:	8526                	mv	a0,s1
    8000275e:	60e2                	ld	ra,24(sp)
    80002760:	6442                	ld	s0,16(sp)
    80002762:	64a2                	ld	s1,8(sp)
    80002764:	6105                	addi	sp,sp,32
    80002766:	8082                	ret

0000000080002768 <ilock>:
{
    80002768:	1101                	addi	sp,sp,-32
    8000276a:	ec06                	sd	ra,24(sp)
    8000276c:	e822                	sd	s0,16(sp)
    8000276e:	e426                	sd	s1,8(sp)
    80002770:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002772:	cd19                	beqz	a0,80002790 <ilock+0x28>
    80002774:	84aa                	mv	s1,a0
    80002776:	451c                	lw	a5,8(a0)
    80002778:	00f05c63          	blez	a5,80002790 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000277c:	0541                	addi	a0,a0,16
    8000277e:	48b000ef          	jal	80003408 <acquiresleep>
  if(ip->valid == 0){
    80002782:	40bc                	lw	a5,64(s1)
    80002784:	cf89                	beqz	a5,8000279e <ilock+0x36>
}
    80002786:	60e2                	ld	ra,24(sp)
    80002788:	6442                	ld	s0,16(sp)
    8000278a:	64a2                	ld	s1,8(sp)
    8000278c:	6105                	addi	sp,sp,32
    8000278e:	8082                	ret
    80002790:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002792:	00005517          	auipc	a0,0x5
    80002796:	c6e50513          	addi	a0,a0,-914 # 80007400 <etext+0x400>
    8000279a:	7ad020ef          	jal	80005746 <panic>
    8000279e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800027a0:	40dc                	lw	a5,4(s1)
    800027a2:	0047d79b          	srliw	a5,a5,0x4
    800027a6:	00016597          	auipc	a1,0x16
    800027aa:	a7a5a583          	lw	a1,-1414(a1) # 80018220 <sb+0x18>
    800027ae:	9dbd                	addw	a1,a1,a5
    800027b0:	4088                	lw	a0,0(s1)
    800027b2:	91fff0ef          	jal	800020d0 <bread>
    800027b6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027b8:	05850593          	addi	a1,a0,88
    800027bc:	40dc                	lw	a5,4(s1)
    800027be:	8bbd                	andi	a5,a5,15
    800027c0:	079a                	slli	a5,a5,0x6
    800027c2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027c4:	00059783          	lh	a5,0(a1)
    800027c8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027cc:	00259783          	lh	a5,2(a1)
    800027d0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027d4:	00459783          	lh	a5,4(a1)
    800027d8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027dc:	00659783          	lh	a5,6(a1)
    800027e0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027e4:	459c                	lw	a5,8(a1)
    800027e6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027e8:	03400613          	li	a2,52
    800027ec:	05b1                	addi	a1,a1,12
    800027ee:	05048513          	addi	a0,s1,80
    800027f2:	9cdfd0ef          	jal	800001be <memmove>
    brelse(bp);
    800027f6:	854a                	mv	a0,s2
    800027f8:	9e1ff0ef          	jal	800021d8 <brelse>
    ip->valid = 1;
    800027fc:	4785                	li	a5,1
    800027fe:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002800:	04449783          	lh	a5,68(s1)
    80002804:	c399                	beqz	a5,8000280a <ilock+0xa2>
    80002806:	6902                	ld	s2,0(sp)
    80002808:	bfbd                	j	80002786 <ilock+0x1e>
      panic("ilock: no type");
    8000280a:	00005517          	auipc	a0,0x5
    8000280e:	bfe50513          	addi	a0,a0,-1026 # 80007408 <etext+0x408>
    80002812:	735020ef          	jal	80005746 <panic>

0000000080002816 <iunlock>:
{
    80002816:	1101                	addi	sp,sp,-32
    80002818:	ec06                	sd	ra,24(sp)
    8000281a:	e822                	sd	s0,16(sp)
    8000281c:	e426                	sd	s1,8(sp)
    8000281e:	e04a                	sd	s2,0(sp)
    80002820:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002822:	c505                	beqz	a0,8000284a <iunlock+0x34>
    80002824:	84aa                	mv	s1,a0
    80002826:	01050913          	addi	s2,a0,16
    8000282a:	854a                	mv	a0,s2
    8000282c:	45b000ef          	jal	80003486 <holdingsleep>
    80002830:	cd09                	beqz	a0,8000284a <iunlock+0x34>
    80002832:	449c                	lw	a5,8(s1)
    80002834:	00f05b63          	blez	a5,8000284a <iunlock+0x34>
  releasesleep(&ip->lock);
    80002838:	854a                	mv	a0,s2
    8000283a:	415000ef          	jal	8000344e <releasesleep>
}
    8000283e:	60e2                	ld	ra,24(sp)
    80002840:	6442                	ld	s0,16(sp)
    80002842:	64a2                	ld	s1,8(sp)
    80002844:	6902                	ld	s2,0(sp)
    80002846:	6105                	addi	sp,sp,32
    80002848:	8082                	ret
    panic("iunlock");
    8000284a:	00005517          	auipc	a0,0x5
    8000284e:	bce50513          	addi	a0,a0,-1074 # 80007418 <etext+0x418>
    80002852:	6f5020ef          	jal	80005746 <panic>

0000000080002856 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002856:	7179                	addi	sp,sp,-48
    80002858:	f406                	sd	ra,40(sp)
    8000285a:	f022                	sd	s0,32(sp)
    8000285c:	ec26                	sd	s1,24(sp)
    8000285e:	e84a                	sd	s2,16(sp)
    80002860:	e44e                	sd	s3,8(sp)
    80002862:	1800                	addi	s0,sp,48
    80002864:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002866:	05050493          	addi	s1,a0,80
    8000286a:	08050913          	addi	s2,a0,128
    8000286e:	a021                	j	80002876 <itrunc+0x20>
    80002870:	0491                	addi	s1,s1,4
    80002872:	01248b63          	beq	s1,s2,80002888 <itrunc+0x32>
    if(ip->addrs[i]){
    80002876:	408c                	lw	a1,0(s1)
    80002878:	dde5                	beqz	a1,80002870 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000287a:	0009a503          	lw	a0,0(s3)
    8000287e:	a47ff0ef          	jal	800022c4 <bfree>
      ip->addrs[i] = 0;
    80002882:	0004a023          	sw	zero,0(s1)
    80002886:	b7ed                	j	80002870 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002888:	0809a583          	lw	a1,128(s3)
    8000288c:	ed89                	bnez	a1,800028a6 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000288e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002892:	854e                	mv	a0,s3
    80002894:	e21ff0ef          	jal	800026b4 <iupdate>
}
    80002898:	70a2                	ld	ra,40(sp)
    8000289a:	7402                	ld	s0,32(sp)
    8000289c:	64e2                	ld	s1,24(sp)
    8000289e:	6942                	ld	s2,16(sp)
    800028a0:	69a2                	ld	s3,8(sp)
    800028a2:	6145                	addi	sp,sp,48
    800028a4:	8082                	ret
    800028a6:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800028a8:	0009a503          	lw	a0,0(s3)
    800028ac:	825ff0ef          	jal	800020d0 <bread>
    800028b0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028b2:	05850493          	addi	s1,a0,88
    800028b6:	45850913          	addi	s2,a0,1112
    800028ba:	a021                	j	800028c2 <itrunc+0x6c>
    800028bc:	0491                	addi	s1,s1,4
    800028be:	01248963          	beq	s1,s2,800028d0 <itrunc+0x7a>
      if(a[j])
    800028c2:	408c                	lw	a1,0(s1)
    800028c4:	dde5                	beqz	a1,800028bc <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028c6:	0009a503          	lw	a0,0(s3)
    800028ca:	9fbff0ef          	jal	800022c4 <bfree>
    800028ce:	b7fd                	j	800028bc <itrunc+0x66>
    brelse(bp);
    800028d0:	8552                	mv	a0,s4
    800028d2:	907ff0ef          	jal	800021d8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028d6:	0809a583          	lw	a1,128(s3)
    800028da:	0009a503          	lw	a0,0(s3)
    800028de:	9e7ff0ef          	jal	800022c4 <bfree>
    ip->addrs[NDIRECT] = 0;
    800028e2:	0809a023          	sw	zero,128(s3)
    800028e6:	6a02                	ld	s4,0(sp)
    800028e8:	b75d                	j	8000288e <itrunc+0x38>

00000000800028ea <iput>:
{
    800028ea:	1101                	addi	sp,sp,-32
    800028ec:	ec06                	sd	ra,24(sp)
    800028ee:	e822                	sd	s0,16(sp)
    800028f0:	e426                	sd	s1,8(sp)
    800028f2:	1000                	addi	s0,sp,32
    800028f4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028f6:	00016517          	auipc	a0,0x16
    800028fa:	93250513          	addi	a0,a0,-1742 # 80018228 <itable>
    800028fe:	10a030ef          	jal	80005a08 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002902:	4498                	lw	a4,8(s1)
    80002904:	4785                	li	a5,1
    80002906:	02f70063          	beq	a4,a5,80002926 <iput+0x3c>
  ip->ref--;
    8000290a:	449c                	lw	a5,8(s1)
    8000290c:	37fd                	addiw	a5,a5,-1
    8000290e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002910:	00016517          	auipc	a0,0x16
    80002914:	91850513          	addi	a0,a0,-1768 # 80018228 <itable>
    80002918:	184030ef          	jal	80005a9c <release>
}
    8000291c:	60e2                	ld	ra,24(sp)
    8000291e:	6442                	ld	s0,16(sp)
    80002920:	64a2                	ld	s1,8(sp)
    80002922:	6105                	addi	sp,sp,32
    80002924:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002926:	40bc                	lw	a5,64(s1)
    80002928:	d3ed                	beqz	a5,8000290a <iput+0x20>
    8000292a:	04a49783          	lh	a5,74(s1)
    8000292e:	fff1                	bnez	a5,8000290a <iput+0x20>
    80002930:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002932:	01048793          	addi	a5,s1,16
    80002936:	893e                	mv	s2,a5
    80002938:	853e                	mv	a0,a5
    8000293a:	2cf000ef          	jal	80003408 <acquiresleep>
    release(&itable.lock);
    8000293e:	00016517          	auipc	a0,0x16
    80002942:	8ea50513          	addi	a0,a0,-1814 # 80018228 <itable>
    80002946:	156030ef          	jal	80005a9c <release>
    itrunc(ip);
    8000294a:	8526                	mv	a0,s1
    8000294c:	f0bff0ef          	jal	80002856 <itrunc>
    ip->type = 0;
    80002950:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002954:	8526                	mv	a0,s1
    80002956:	d5fff0ef          	jal	800026b4 <iupdate>
    ip->valid = 0;
    8000295a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000295e:	854a                	mv	a0,s2
    80002960:	2ef000ef          	jal	8000344e <releasesleep>
    acquire(&itable.lock);
    80002964:	00016517          	auipc	a0,0x16
    80002968:	8c450513          	addi	a0,a0,-1852 # 80018228 <itable>
    8000296c:	09c030ef          	jal	80005a08 <acquire>
    80002970:	6902                	ld	s2,0(sp)
    80002972:	bf61                	j	8000290a <iput+0x20>

0000000080002974 <iunlockput>:
{
    80002974:	1101                	addi	sp,sp,-32
    80002976:	ec06                	sd	ra,24(sp)
    80002978:	e822                	sd	s0,16(sp)
    8000297a:	e426                	sd	s1,8(sp)
    8000297c:	1000                	addi	s0,sp,32
    8000297e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002980:	e97ff0ef          	jal	80002816 <iunlock>
  iput(ip);
    80002984:	8526                	mv	a0,s1
    80002986:	f65ff0ef          	jal	800028ea <iput>
}
    8000298a:	60e2                	ld	ra,24(sp)
    8000298c:	6442                	ld	s0,16(sp)
    8000298e:	64a2                	ld	s1,8(sp)
    80002990:	6105                	addi	sp,sp,32
    80002992:	8082                	ret

0000000080002994 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002994:	00016717          	auipc	a4,0x16
    80002998:	88072703          	lw	a4,-1920(a4) # 80018214 <sb+0xc>
    8000299c:	4785                	li	a5,1
    8000299e:	0ae7fe63          	bgeu	a5,a4,80002a5a <ireclaim+0xc6>
{
    800029a2:	7139                	addi	sp,sp,-64
    800029a4:	fc06                	sd	ra,56(sp)
    800029a6:	f822                	sd	s0,48(sp)
    800029a8:	f426                	sd	s1,40(sp)
    800029aa:	f04a                	sd	s2,32(sp)
    800029ac:	ec4e                	sd	s3,24(sp)
    800029ae:	e852                	sd	s4,16(sp)
    800029b0:	e456                	sd	s5,8(sp)
    800029b2:	e05a                	sd	s6,0(sp)
    800029b4:	0080                	addi	s0,sp,64
    800029b6:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029b8:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800029ba:	00016a17          	auipc	s4,0x16
    800029be:	84ea0a13          	addi	s4,s4,-1970 # 80018208 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800029c2:	00005b17          	auipc	s6,0x5
    800029c6:	a5eb0b13          	addi	s6,s6,-1442 # 80007420 <etext+0x420>
    800029ca:	a099                	j	80002a10 <ireclaim+0x7c>
    800029cc:	85ce                	mv	a1,s3
    800029ce:	855a                	mv	a0,s6
    800029d0:	24d020ef          	jal	8000541c <printf>
      ip = iget(dev, inum);
    800029d4:	85ce                	mv	a1,s3
    800029d6:	8556                	mv	a0,s5
    800029d8:	b1fff0ef          	jal	800024f6 <iget>
    800029dc:	89aa                	mv	s3,a0
    brelse(bp);
    800029de:	854a                	mv	a0,s2
    800029e0:	ff8ff0ef          	jal	800021d8 <brelse>
    if (ip) {
    800029e4:	00098f63          	beqz	s3,80002a02 <ireclaim+0x6e>
      begin_op();
    800029e8:	78c000ef          	jal	80003174 <begin_op>
      ilock(ip);
    800029ec:	854e                	mv	a0,s3
    800029ee:	d7bff0ef          	jal	80002768 <ilock>
      iunlock(ip);
    800029f2:	854e                	mv	a0,s3
    800029f4:	e23ff0ef          	jal	80002816 <iunlock>
      iput(ip);
    800029f8:	854e                	mv	a0,s3
    800029fa:	ef1ff0ef          	jal	800028ea <iput>
      end_op();
    800029fe:	7e6000ef          	jal	800031e4 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002a02:	0485                	addi	s1,s1,1
    80002a04:	00ca2703          	lw	a4,12(s4)
    80002a08:	0004879b          	sext.w	a5,s1
    80002a0c:	02e7fd63          	bgeu	a5,a4,80002a46 <ireclaim+0xb2>
    80002a10:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002a14:	0044d593          	srli	a1,s1,0x4
    80002a18:	018a2783          	lw	a5,24(s4)
    80002a1c:	9dbd                	addw	a1,a1,a5
    80002a1e:	8556                	mv	a0,s5
    80002a20:	eb0ff0ef          	jal	800020d0 <bread>
    80002a24:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002a26:	05850793          	addi	a5,a0,88
    80002a2a:	00f9f713          	andi	a4,s3,15
    80002a2e:	071a                	slli	a4,a4,0x6
    80002a30:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002a32:	00079703          	lh	a4,0(a5)
    80002a36:	c701                	beqz	a4,80002a3e <ireclaim+0xaa>
    80002a38:	00679783          	lh	a5,6(a5)
    80002a3c:	dbc1                	beqz	a5,800029cc <ireclaim+0x38>
    brelse(bp);
    80002a3e:	854a                	mv	a0,s2
    80002a40:	f98ff0ef          	jal	800021d8 <brelse>
    if (ip) {
    80002a44:	bf7d                	j	80002a02 <ireclaim+0x6e>
}
    80002a46:	70e2                	ld	ra,56(sp)
    80002a48:	7442                	ld	s0,48(sp)
    80002a4a:	74a2                	ld	s1,40(sp)
    80002a4c:	7902                	ld	s2,32(sp)
    80002a4e:	69e2                	ld	s3,24(sp)
    80002a50:	6a42                	ld	s4,16(sp)
    80002a52:	6aa2                	ld	s5,8(sp)
    80002a54:	6b02                	ld	s6,0(sp)
    80002a56:	6121                	addi	sp,sp,64
    80002a58:	8082                	ret
    80002a5a:	8082                	ret

0000000080002a5c <fsinit>:
fsinit(int dev) {
    80002a5c:	1101                	addi	sp,sp,-32
    80002a5e:	ec06                	sd	ra,24(sp)
    80002a60:	e822                	sd	s0,16(sp)
    80002a62:	e426                	sd	s1,8(sp)
    80002a64:	e04a                	sd	s2,0(sp)
    80002a66:	1000                	addi	s0,sp,32
    80002a68:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a6a:	4585                	li	a1,1
    80002a6c:	e64ff0ef          	jal	800020d0 <bread>
    80002a70:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a72:	02000613          	li	a2,32
    80002a76:	05850593          	addi	a1,a0,88
    80002a7a:	00015517          	auipc	a0,0x15
    80002a7e:	78e50513          	addi	a0,a0,1934 # 80018208 <sb>
    80002a82:	f3cfd0ef          	jal	800001be <memmove>
  brelse(bp);
    80002a86:	8526                	mv	a0,s1
    80002a88:	f50ff0ef          	jal	800021d8 <brelse>
  if(sb.magic != FSMAGIC)
    80002a8c:	00015717          	auipc	a4,0x15
    80002a90:	77c72703          	lw	a4,1916(a4) # 80018208 <sb>
    80002a94:	102037b7          	lui	a5,0x10203
    80002a98:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a9c:	02f71263          	bne	a4,a5,80002ac0 <fsinit+0x64>
  initlog(dev, &sb);
    80002aa0:	00015597          	auipc	a1,0x15
    80002aa4:	76858593          	addi	a1,a1,1896 # 80018208 <sb>
    80002aa8:	854a                	mv	a0,s2
    80002aaa:	648000ef          	jal	800030f2 <initlog>
  ireclaim(dev);
    80002aae:	854a                	mv	a0,s2
    80002ab0:	ee5ff0ef          	jal	80002994 <ireclaim>
}
    80002ab4:	60e2                	ld	ra,24(sp)
    80002ab6:	6442                	ld	s0,16(sp)
    80002ab8:	64a2                	ld	s1,8(sp)
    80002aba:	6902                	ld	s2,0(sp)
    80002abc:	6105                	addi	sp,sp,32
    80002abe:	8082                	ret
    panic("invalid file system");
    80002ac0:	00005517          	auipc	a0,0x5
    80002ac4:	98050513          	addi	a0,a0,-1664 # 80007440 <etext+0x440>
    80002ac8:	47f020ef          	jal	80005746 <panic>

0000000080002acc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002acc:	1141                	addi	sp,sp,-16
    80002ace:	e406                	sd	ra,8(sp)
    80002ad0:	e022                	sd	s0,0(sp)
    80002ad2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ad4:	411c                	lw	a5,0(a0)
    80002ad6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ad8:	415c                	lw	a5,4(a0)
    80002ada:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002adc:	04451783          	lh	a5,68(a0)
    80002ae0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ae4:	04a51783          	lh	a5,74(a0)
    80002ae8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002aec:	04c56783          	lwu	a5,76(a0)
    80002af0:	e99c                	sd	a5,16(a1)
}
    80002af2:	60a2                	ld	ra,8(sp)
    80002af4:	6402                	ld	s0,0(sp)
    80002af6:	0141                	addi	sp,sp,16
    80002af8:	8082                	ret

0000000080002afa <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002afa:	457c                	lw	a5,76(a0)
    80002afc:	0ed7e663          	bltu	a5,a3,80002be8 <readi+0xee>
{
    80002b00:	7159                	addi	sp,sp,-112
    80002b02:	f486                	sd	ra,104(sp)
    80002b04:	f0a2                	sd	s0,96(sp)
    80002b06:	eca6                	sd	s1,88(sp)
    80002b08:	e0d2                	sd	s4,64(sp)
    80002b0a:	fc56                	sd	s5,56(sp)
    80002b0c:	f85a                	sd	s6,48(sp)
    80002b0e:	f45e                	sd	s7,40(sp)
    80002b10:	1880                	addi	s0,sp,112
    80002b12:	8b2a                	mv	s6,a0
    80002b14:	8bae                	mv	s7,a1
    80002b16:	8a32                	mv	s4,a2
    80002b18:	84b6                	mv	s1,a3
    80002b1a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002b1c:	9f35                	addw	a4,a4,a3
    return 0;
    80002b1e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002b20:	0ad76b63          	bltu	a4,a3,80002bd6 <readi+0xdc>
    80002b24:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002b26:	00e7f463          	bgeu	a5,a4,80002b2e <readi+0x34>
    n = ip->size - off;
    80002b2a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b2e:	080a8b63          	beqz	s5,80002bc4 <readi+0xca>
    80002b32:	e8ca                	sd	s2,80(sp)
    80002b34:	f062                	sd	s8,32(sp)
    80002b36:	ec66                	sd	s9,24(sp)
    80002b38:	e86a                	sd	s10,16(sp)
    80002b3a:	e46e                	sd	s11,8(sp)
    80002b3c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b3e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002b42:	5c7d                	li	s8,-1
    80002b44:	a80d                	j	80002b76 <readi+0x7c>
    80002b46:	020d1d93          	slli	s11,s10,0x20
    80002b4a:	020ddd93          	srli	s11,s11,0x20
    80002b4e:	05890613          	addi	a2,s2,88
    80002b52:	86ee                	mv	a3,s11
    80002b54:	963e                	add	a2,a2,a5
    80002b56:	85d2                	mv	a1,s4
    80002b58:	855e                	mv	a0,s7
    80002b5a:	c4bfe0ef          	jal	800017a4 <either_copyout>
    80002b5e:	05850363          	beq	a0,s8,80002ba4 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002b62:	854a                	mv	a0,s2
    80002b64:	e74ff0ef          	jal	800021d8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b68:	013d09bb          	addw	s3,s10,s3
    80002b6c:	009d04bb          	addw	s1,s10,s1
    80002b70:	9a6e                	add	s4,s4,s11
    80002b72:	0559f363          	bgeu	s3,s5,80002bb8 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b76:	00a4d59b          	srliw	a1,s1,0xa
    80002b7a:	855a                	mv	a0,s6
    80002b7c:	8bbff0ef          	jal	80002436 <bmap>
    80002b80:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b82:	c139                	beqz	a0,80002bc8 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002b84:	000b2503          	lw	a0,0(s6)
    80002b88:	d48ff0ef          	jal	800020d0 <bread>
    80002b8c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b8e:	3ff4f793          	andi	a5,s1,1023
    80002b92:	40fc873b          	subw	a4,s9,a5
    80002b96:	413a86bb          	subw	a3,s5,s3
    80002b9a:	8d3a                	mv	s10,a4
    80002b9c:	fae6f5e3          	bgeu	a3,a4,80002b46 <readi+0x4c>
    80002ba0:	8d36                	mv	s10,a3
    80002ba2:	b755                	j	80002b46 <readi+0x4c>
      brelse(bp);
    80002ba4:	854a                	mv	a0,s2
    80002ba6:	e32ff0ef          	jal	800021d8 <brelse>
      tot = -1;
    80002baa:	59fd                	li	s3,-1
      break;
    80002bac:	6946                	ld	s2,80(sp)
    80002bae:	7c02                	ld	s8,32(sp)
    80002bb0:	6ce2                	ld	s9,24(sp)
    80002bb2:	6d42                	ld	s10,16(sp)
    80002bb4:	6da2                	ld	s11,8(sp)
    80002bb6:	a831                	j	80002bd2 <readi+0xd8>
    80002bb8:	6946                	ld	s2,80(sp)
    80002bba:	7c02                	ld	s8,32(sp)
    80002bbc:	6ce2                	ld	s9,24(sp)
    80002bbe:	6d42                	ld	s10,16(sp)
    80002bc0:	6da2                	ld	s11,8(sp)
    80002bc2:	a801                	j	80002bd2 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002bc4:	89d6                	mv	s3,s5
    80002bc6:	a031                	j	80002bd2 <readi+0xd8>
    80002bc8:	6946                	ld	s2,80(sp)
    80002bca:	7c02                	ld	s8,32(sp)
    80002bcc:	6ce2                	ld	s9,24(sp)
    80002bce:	6d42                	ld	s10,16(sp)
    80002bd0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002bd2:	854e                	mv	a0,s3
    80002bd4:	69a6                	ld	s3,72(sp)
}
    80002bd6:	70a6                	ld	ra,104(sp)
    80002bd8:	7406                	ld	s0,96(sp)
    80002bda:	64e6                	ld	s1,88(sp)
    80002bdc:	6a06                	ld	s4,64(sp)
    80002bde:	7ae2                	ld	s5,56(sp)
    80002be0:	7b42                	ld	s6,48(sp)
    80002be2:	7ba2                	ld	s7,40(sp)
    80002be4:	6165                	addi	sp,sp,112
    80002be6:	8082                	ret
    return 0;
    80002be8:	4501                	li	a0,0
}
    80002bea:	8082                	ret

0000000080002bec <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002bec:	457c                	lw	a5,76(a0)
    80002bee:	0ed7eb63          	bltu	a5,a3,80002ce4 <writei+0xf8>
{
    80002bf2:	7159                	addi	sp,sp,-112
    80002bf4:	f486                	sd	ra,104(sp)
    80002bf6:	f0a2                	sd	s0,96(sp)
    80002bf8:	e8ca                	sd	s2,80(sp)
    80002bfa:	e0d2                	sd	s4,64(sp)
    80002bfc:	fc56                	sd	s5,56(sp)
    80002bfe:	f85a                	sd	s6,48(sp)
    80002c00:	f45e                	sd	s7,40(sp)
    80002c02:	1880                	addi	s0,sp,112
    80002c04:	8aaa                	mv	s5,a0
    80002c06:	8bae                	mv	s7,a1
    80002c08:	8a32                	mv	s4,a2
    80002c0a:	8936                	mv	s2,a3
    80002c0c:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002c0e:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002c12:	00043737          	lui	a4,0x43
    80002c16:	0cf76963          	bltu	a4,a5,80002ce8 <writei+0xfc>
    80002c1a:	0cd7e763          	bltu	a5,a3,80002ce8 <writei+0xfc>
    80002c1e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c20:	0a0b0a63          	beqz	s6,80002cd4 <writei+0xe8>
    80002c24:	eca6                	sd	s1,88(sp)
    80002c26:	f062                	sd	s8,32(sp)
    80002c28:	ec66                	sd	s9,24(sp)
    80002c2a:	e86a                	sd	s10,16(sp)
    80002c2c:	e46e                	sd	s11,8(sp)
    80002c2e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c30:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002c34:	5c7d                	li	s8,-1
    80002c36:	a825                	j	80002c6e <writei+0x82>
    80002c38:	020d1d93          	slli	s11,s10,0x20
    80002c3c:	020ddd93          	srli	s11,s11,0x20
    80002c40:	05848513          	addi	a0,s1,88
    80002c44:	86ee                	mv	a3,s11
    80002c46:	8652                	mv	a2,s4
    80002c48:	85de                	mv	a1,s7
    80002c4a:	953e                	add	a0,a0,a5
    80002c4c:	ba3fe0ef          	jal	800017ee <either_copyin>
    80002c50:	05850663          	beq	a0,s8,80002c9c <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002c54:	8526                	mv	a0,s1
    80002c56:	6b8000ef          	jal	8000330e <log_write>
    brelse(bp);
    80002c5a:	8526                	mv	a0,s1
    80002c5c:	d7cff0ef          	jal	800021d8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c60:	013d09bb          	addw	s3,s10,s3
    80002c64:	012d093b          	addw	s2,s10,s2
    80002c68:	9a6e                	add	s4,s4,s11
    80002c6a:	0369fc63          	bgeu	s3,s6,80002ca2 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002c6e:	00a9559b          	srliw	a1,s2,0xa
    80002c72:	8556                	mv	a0,s5
    80002c74:	fc2ff0ef          	jal	80002436 <bmap>
    80002c78:	85aa                	mv	a1,a0
    if(addr == 0)
    80002c7a:	c505                	beqz	a0,80002ca2 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002c7c:	000aa503          	lw	a0,0(s5)
    80002c80:	c50ff0ef          	jal	800020d0 <bread>
    80002c84:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c86:	3ff97793          	andi	a5,s2,1023
    80002c8a:	40fc873b          	subw	a4,s9,a5
    80002c8e:	413b06bb          	subw	a3,s6,s3
    80002c92:	8d3a                	mv	s10,a4
    80002c94:	fae6f2e3          	bgeu	a3,a4,80002c38 <writei+0x4c>
    80002c98:	8d36                	mv	s10,a3
    80002c9a:	bf79                	j	80002c38 <writei+0x4c>
      brelse(bp);
    80002c9c:	8526                	mv	a0,s1
    80002c9e:	d3aff0ef          	jal	800021d8 <brelse>
  }

  if(off > ip->size)
    80002ca2:	04caa783          	lw	a5,76(s5)
    80002ca6:	0327f963          	bgeu	a5,s2,80002cd8 <writei+0xec>
    ip->size = off;
    80002caa:	052aa623          	sw	s2,76(s5)
    80002cae:	64e6                	ld	s1,88(sp)
    80002cb0:	7c02                	ld	s8,32(sp)
    80002cb2:	6ce2                	ld	s9,24(sp)
    80002cb4:	6d42                	ld	s10,16(sp)
    80002cb6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002cb8:	8556                	mv	a0,s5
    80002cba:	9fbff0ef          	jal	800026b4 <iupdate>

  return tot;
    80002cbe:	854e                	mv	a0,s3
    80002cc0:	69a6                	ld	s3,72(sp)
}
    80002cc2:	70a6                	ld	ra,104(sp)
    80002cc4:	7406                	ld	s0,96(sp)
    80002cc6:	6946                	ld	s2,80(sp)
    80002cc8:	6a06                	ld	s4,64(sp)
    80002cca:	7ae2                	ld	s5,56(sp)
    80002ccc:	7b42                	ld	s6,48(sp)
    80002cce:	7ba2                	ld	s7,40(sp)
    80002cd0:	6165                	addi	sp,sp,112
    80002cd2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002cd4:	89da                	mv	s3,s6
    80002cd6:	b7cd                	j	80002cb8 <writei+0xcc>
    80002cd8:	64e6                	ld	s1,88(sp)
    80002cda:	7c02                	ld	s8,32(sp)
    80002cdc:	6ce2                	ld	s9,24(sp)
    80002cde:	6d42                	ld	s10,16(sp)
    80002ce0:	6da2                	ld	s11,8(sp)
    80002ce2:	bfd9                	j	80002cb8 <writei+0xcc>
    return -1;
    80002ce4:	557d                	li	a0,-1
}
    80002ce6:	8082                	ret
    return -1;
    80002ce8:	557d                	li	a0,-1
    80002cea:	bfe1                	j	80002cc2 <writei+0xd6>

0000000080002cec <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002cec:	1141                	addi	sp,sp,-16
    80002cee:	e406                	sd	ra,8(sp)
    80002cf0:	e022                	sd	s0,0(sp)
    80002cf2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002cf4:	4639                	li	a2,14
    80002cf6:	d3cfd0ef          	jal	80000232 <strncmp>
}
    80002cfa:	60a2                	ld	ra,8(sp)
    80002cfc:	6402                	ld	s0,0(sp)
    80002cfe:	0141                	addi	sp,sp,16
    80002d00:	8082                	ret

0000000080002d02 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002d02:	711d                	addi	sp,sp,-96
    80002d04:	ec86                	sd	ra,88(sp)
    80002d06:	e8a2                	sd	s0,80(sp)
    80002d08:	e4a6                	sd	s1,72(sp)
    80002d0a:	e0ca                	sd	s2,64(sp)
    80002d0c:	fc4e                	sd	s3,56(sp)
    80002d0e:	f852                	sd	s4,48(sp)
    80002d10:	f456                	sd	s5,40(sp)
    80002d12:	f05a                	sd	s6,32(sp)
    80002d14:	ec5e                	sd	s7,24(sp)
    80002d16:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002d18:	04451703          	lh	a4,68(a0)
    80002d1c:	4785                	li	a5,1
    80002d1e:	00f71f63          	bne	a4,a5,80002d3c <dirlookup+0x3a>
    80002d22:	892a                	mv	s2,a0
    80002d24:	8aae                	mv	s5,a1
    80002d26:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d28:	457c                	lw	a5,76(a0)
    80002d2a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d2c:	fa040a13          	addi	s4,s0,-96
    80002d30:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002d32:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002d36:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d38:	e39d                	bnez	a5,80002d5e <dirlookup+0x5c>
    80002d3a:	a8b9                	j	80002d98 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002d3c:	00004517          	auipc	a0,0x4
    80002d40:	71c50513          	addi	a0,a0,1820 # 80007458 <etext+0x458>
    80002d44:	203020ef          	jal	80005746 <panic>
      panic("dirlookup read");
    80002d48:	00004517          	auipc	a0,0x4
    80002d4c:	72850513          	addi	a0,a0,1832 # 80007470 <etext+0x470>
    80002d50:	1f7020ef          	jal	80005746 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d54:	24c1                	addiw	s1,s1,16
    80002d56:	04c92783          	lw	a5,76(s2)
    80002d5a:	02f4fe63          	bgeu	s1,a5,80002d96 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d5e:	874e                	mv	a4,s3
    80002d60:	86a6                	mv	a3,s1
    80002d62:	8652                	mv	a2,s4
    80002d64:	4581                	li	a1,0
    80002d66:	854a                	mv	a0,s2
    80002d68:	d93ff0ef          	jal	80002afa <readi>
    80002d6c:	fd351ee3          	bne	a0,s3,80002d48 <dirlookup+0x46>
    if(de.inum == 0)
    80002d70:	fa045783          	lhu	a5,-96(s0)
    80002d74:	d3e5                	beqz	a5,80002d54 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002d76:	85da                	mv	a1,s6
    80002d78:	8556                	mv	a0,s5
    80002d7a:	f73ff0ef          	jal	80002cec <namecmp>
    80002d7e:	f979                	bnez	a0,80002d54 <dirlookup+0x52>
      if(poff)
    80002d80:	000b8463          	beqz	s7,80002d88 <dirlookup+0x86>
        *poff = off;
    80002d84:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002d88:	fa045583          	lhu	a1,-96(s0)
    80002d8c:	00092503          	lw	a0,0(s2)
    80002d90:	f66ff0ef          	jal	800024f6 <iget>
    80002d94:	a011                	j	80002d98 <dirlookup+0x96>
  return 0;
    80002d96:	4501                	li	a0,0
}
    80002d98:	60e6                	ld	ra,88(sp)
    80002d9a:	6446                	ld	s0,80(sp)
    80002d9c:	64a6                	ld	s1,72(sp)
    80002d9e:	6906                	ld	s2,64(sp)
    80002da0:	79e2                	ld	s3,56(sp)
    80002da2:	7a42                	ld	s4,48(sp)
    80002da4:	7aa2                	ld	s5,40(sp)
    80002da6:	7b02                	ld	s6,32(sp)
    80002da8:	6be2                	ld	s7,24(sp)
    80002daa:	6125                	addi	sp,sp,96
    80002dac:	8082                	ret

0000000080002dae <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002dae:	711d                	addi	sp,sp,-96
    80002db0:	ec86                	sd	ra,88(sp)
    80002db2:	e8a2                	sd	s0,80(sp)
    80002db4:	e4a6                	sd	s1,72(sp)
    80002db6:	e0ca                	sd	s2,64(sp)
    80002db8:	fc4e                	sd	s3,56(sp)
    80002dba:	f852                	sd	s4,48(sp)
    80002dbc:	f456                	sd	s5,40(sp)
    80002dbe:	f05a                	sd	s6,32(sp)
    80002dc0:	ec5e                	sd	s7,24(sp)
    80002dc2:	e862                	sd	s8,16(sp)
    80002dc4:	e466                	sd	s9,8(sp)
    80002dc6:	e06a                	sd	s10,0(sp)
    80002dc8:	1080                	addi	s0,sp,96
    80002dca:	84aa                	mv	s1,a0
    80002dcc:	8b2e                	mv	s6,a1
    80002dce:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002dd0:	00054703          	lbu	a4,0(a0)
    80002dd4:	02f00793          	li	a5,47
    80002dd8:	00f70f63          	beq	a4,a5,80002df6 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002ddc:	ffbfd0ef          	jal	80000dd6 <myproc>
    80002de0:	15853503          	ld	a0,344(a0)
    80002de4:	94fff0ef          	jal	80002732 <idup>
    80002de8:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002dea:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002dee:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002df0:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002df2:	4b85                	li	s7,1
    80002df4:	a879                	j	80002e92 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002df6:	4585                	li	a1,1
    80002df8:	852e                	mv	a0,a1
    80002dfa:	efcff0ef          	jal	800024f6 <iget>
    80002dfe:	8a2a                	mv	s4,a0
    80002e00:	b7ed                	j	80002dea <namex+0x3c>
      iunlockput(ip);
    80002e02:	8552                	mv	a0,s4
    80002e04:	b71ff0ef          	jal	80002974 <iunlockput>
      return 0;
    80002e08:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002e0a:	8552                	mv	a0,s4
    80002e0c:	60e6                	ld	ra,88(sp)
    80002e0e:	6446                	ld	s0,80(sp)
    80002e10:	64a6                	ld	s1,72(sp)
    80002e12:	6906                	ld	s2,64(sp)
    80002e14:	79e2                	ld	s3,56(sp)
    80002e16:	7a42                	ld	s4,48(sp)
    80002e18:	7aa2                	ld	s5,40(sp)
    80002e1a:	7b02                	ld	s6,32(sp)
    80002e1c:	6be2                	ld	s7,24(sp)
    80002e1e:	6c42                	ld	s8,16(sp)
    80002e20:	6ca2                	ld	s9,8(sp)
    80002e22:	6d02                	ld	s10,0(sp)
    80002e24:	6125                	addi	sp,sp,96
    80002e26:	8082                	ret
      iunlock(ip);
    80002e28:	8552                	mv	a0,s4
    80002e2a:	9edff0ef          	jal	80002816 <iunlock>
      return ip;
    80002e2e:	bff1                	j	80002e0a <namex+0x5c>
      iunlockput(ip);
    80002e30:	8552                	mv	a0,s4
    80002e32:	b43ff0ef          	jal	80002974 <iunlockput>
      return 0;
    80002e36:	8a4a                	mv	s4,s2
    80002e38:	bfc9                	j	80002e0a <namex+0x5c>
  len = path - s;
    80002e3a:	40990633          	sub	a2,s2,s1
    80002e3e:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002e42:	09ac5463          	bge	s8,s10,80002eca <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002e46:	8666                	mv	a2,s9
    80002e48:	85a6                	mv	a1,s1
    80002e4a:	8556                	mv	a0,s5
    80002e4c:	b72fd0ef          	jal	800001be <memmove>
    80002e50:	84ca                	mv	s1,s2
  while(*path == '/')
    80002e52:	0004c783          	lbu	a5,0(s1)
    80002e56:	01379763          	bne	a5,s3,80002e64 <namex+0xb6>
    path++;
    80002e5a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e5c:	0004c783          	lbu	a5,0(s1)
    80002e60:	ff378de3          	beq	a5,s3,80002e5a <namex+0xac>
    ilock(ip);
    80002e64:	8552                	mv	a0,s4
    80002e66:	903ff0ef          	jal	80002768 <ilock>
    if(ip->type != T_DIR){
    80002e6a:	044a1783          	lh	a5,68(s4)
    80002e6e:	f9779ae3          	bne	a5,s7,80002e02 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002e72:	000b0563          	beqz	s6,80002e7c <namex+0xce>
    80002e76:	0004c783          	lbu	a5,0(s1)
    80002e7a:	d7dd                	beqz	a5,80002e28 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002e7c:	4601                	li	a2,0
    80002e7e:	85d6                	mv	a1,s5
    80002e80:	8552                	mv	a0,s4
    80002e82:	e81ff0ef          	jal	80002d02 <dirlookup>
    80002e86:	892a                	mv	s2,a0
    80002e88:	d545                	beqz	a0,80002e30 <namex+0x82>
    iunlockput(ip);
    80002e8a:	8552                	mv	a0,s4
    80002e8c:	ae9ff0ef          	jal	80002974 <iunlockput>
    ip = next;
    80002e90:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002e92:	0004c783          	lbu	a5,0(s1)
    80002e96:	01379763          	bne	a5,s3,80002ea4 <namex+0xf6>
    path++;
    80002e9a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e9c:	0004c783          	lbu	a5,0(s1)
    80002ea0:	ff378de3          	beq	a5,s3,80002e9a <namex+0xec>
  if(*path == 0)
    80002ea4:	cf8d                	beqz	a5,80002ede <namex+0x130>
  while(*path != '/' && *path != 0)
    80002ea6:	0004c783          	lbu	a5,0(s1)
    80002eaa:	fd178713          	addi	a4,a5,-47
    80002eae:	cb19                	beqz	a4,80002ec4 <namex+0x116>
    80002eb0:	cb91                	beqz	a5,80002ec4 <namex+0x116>
    80002eb2:	8926                	mv	s2,s1
    path++;
    80002eb4:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002eb6:	00094783          	lbu	a5,0(s2)
    80002eba:	fd178713          	addi	a4,a5,-47
    80002ebe:	df35                	beqz	a4,80002e3a <namex+0x8c>
    80002ec0:	fbf5                	bnez	a5,80002eb4 <namex+0x106>
    80002ec2:	bfa5                	j	80002e3a <namex+0x8c>
    80002ec4:	8926                	mv	s2,s1
  len = path - s;
    80002ec6:	4d01                	li	s10,0
    80002ec8:	4601                	li	a2,0
    memmove(name, s, len);
    80002eca:	2601                	sext.w	a2,a2
    80002ecc:	85a6                	mv	a1,s1
    80002ece:	8556                	mv	a0,s5
    80002ed0:	aeefd0ef          	jal	800001be <memmove>
    name[len] = 0;
    80002ed4:	9d56                	add	s10,s10,s5
    80002ed6:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdc018>
    80002eda:	84ca                	mv	s1,s2
    80002edc:	bf9d                	j	80002e52 <namex+0xa4>
  if(nameiparent){
    80002ede:	f20b06e3          	beqz	s6,80002e0a <namex+0x5c>
    iput(ip);
    80002ee2:	8552                	mv	a0,s4
    80002ee4:	a07ff0ef          	jal	800028ea <iput>
    return 0;
    80002ee8:	4a01                	li	s4,0
    80002eea:	b705                	j	80002e0a <namex+0x5c>

0000000080002eec <dirlink>:
{
    80002eec:	715d                	addi	sp,sp,-80
    80002eee:	e486                	sd	ra,72(sp)
    80002ef0:	e0a2                	sd	s0,64(sp)
    80002ef2:	f84a                	sd	s2,48(sp)
    80002ef4:	ec56                	sd	s5,24(sp)
    80002ef6:	e85a                	sd	s6,16(sp)
    80002ef8:	0880                	addi	s0,sp,80
    80002efa:	892a                	mv	s2,a0
    80002efc:	8aae                	mv	s5,a1
    80002efe:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002f00:	4601                	li	a2,0
    80002f02:	e01ff0ef          	jal	80002d02 <dirlookup>
    80002f06:	ed1d                	bnez	a0,80002f44 <dirlink+0x58>
    80002f08:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f0a:	04c92483          	lw	s1,76(s2)
    80002f0e:	c4b9                	beqz	s1,80002f5c <dirlink+0x70>
    80002f10:	f44e                	sd	s3,40(sp)
    80002f12:	f052                	sd	s4,32(sp)
    80002f14:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f16:	fb040a13          	addi	s4,s0,-80
    80002f1a:	49c1                	li	s3,16
    80002f1c:	874e                	mv	a4,s3
    80002f1e:	86a6                	mv	a3,s1
    80002f20:	8652                	mv	a2,s4
    80002f22:	4581                	li	a1,0
    80002f24:	854a                	mv	a0,s2
    80002f26:	bd5ff0ef          	jal	80002afa <readi>
    80002f2a:	03351163          	bne	a0,s3,80002f4c <dirlink+0x60>
    if(de.inum == 0)
    80002f2e:	fb045783          	lhu	a5,-80(s0)
    80002f32:	c39d                	beqz	a5,80002f58 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f34:	24c1                	addiw	s1,s1,16
    80002f36:	04c92783          	lw	a5,76(s2)
    80002f3a:	fef4e1e3          	bltu	s1,a5,80002f1c <dirlink+0x30>
    80002f3e:	79a2                	ld	s3,40(sp)
    80002f40:	7a02                	ld	s4,32(sp)
    80002f42:	a829                	j	80002f5c <dirlink+0x70>
    iput(ip);
    80002f44:	9a7ff0ef          	jal	800028ea <iput>
    return -1;
    80002f48:	557d                	li	a0,-1
    80002f4a:	a83d                	j	80002f88 <dirlink+0x9c>
      panic("dirlink read");
    80002f4c:	00004517          	auipc	a0,0x4
    80002f50:	53450513          	addi	a0,a0,1332 # 80007480 <etext+0x480>
    80002f54:	7f2020ef          	jal	80005746 <panic>
    80002f58:	79a2                	ld	s3,40(sp)
    80002f5a:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002f5c:	4639                	li	a2,14
    80002f5e:	85d6                	mv	a1,s5
    80002f60:	fb240513          	addi	a0,s0,-78
    80002f64:	b08fd0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80002f68:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f6c:	4741                	li	a4,16
    80002f6e:	86a6                	mv	a3,s1
    80002f70:	fb040613          	addi	a2,s0,-80
    80002f74:	4581                	li	a1,0
    80002f76:	854a                	mv	a0,s2
    80002f78:	c75ff0ef          	jal	80002bec <writei>
    80002f7c:	1541                	addi	a0,a0,-16
    80002f7e:	00a03533          	snez	a0,a0
    80002f82:	40a0053b          	negw	a0,a0
    80002f86:	74e2                	ld	s1,56(sp)
}
    80002f88:	60a6                	ld	ra,72(sp)
    80002f8a:	6406                	ld	s0,64(sp)
    80002f8c:	7942                	ld	s2,48(sp)
    80002f8e:	6ae2                	ld	s5,24(sp)
    80002f90:	6b42                	ld	s6,16(sp)
    80002f92:	6161                	addi	sp,sp,80
    80002f94:	8082                	ret

0000000080002f96 <namei>:

struct inode*
namei(char *path)
{
    80002f96:	1101                	addi	sp,sp,-32
    80002f98:	ec06                	sd	ra,24(sp)
    80002f9a:	e822                	sd	s0,16(sp)
    80002f9c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002f9e:	fe040613          	addi	a2,s0,-32
    80002fa2:	4581                	li	a1,0
    80002fa4:	e0bff0ef          	jal	80002dae <namex>
}
    80002fa8:	60e2                	ld	ra,24(sp)
    80002faa:	6442                	ld	s0,16(sp)
    80002fac:	6105                	addi	sp,sp,32
    80002fae:	8082                	ret

0000000080002fb0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002fb0:	1141                	addi	sp,sp,-16
    80002fb2:	e406                	sd	ra,8(sp)
    80002fb4:	e022                	sd	s0,0(sp)
    80002fb6:	0800                	addi	s0,sp,16
    80002fb8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002fba:	4585                	li	a1,1
    80002fbc:	df3ff0ef          	jal	80002dae <namex>
}
    80002fc0:	60a2                	ld	ra,8(sp)
    80002fc2:	6402                	ld	s0,0(sp)
    80002fc4:	0141                	addi	sp,sp,16
    80002fc6:	8082                	ret

0000000080002fc8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002fc8:	1101                	addi	sp,sp,-32
    80002fca:	ec06                	sd	ra,24(sp)
    80002fcc:	e822                	sd	s0,16(sp)
    80002fce:	e426                	sd	s1,8(sp)
    80002fd0:	e04a                	sd	s2,0(sp)
    80002fd2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002fd4:	00017917          	auipc	s2,0x17
    80002fd8:	cfc90913          	addi	s2,s2,-772 # 80019cd0 <log>
    80002fdc:	01892583          	lw	a1,24(s2)
    80002fe0:	02492503          	lw	a0,36(s2)
    80002fe4:	8ecff0ef          	jal	800020d0 <bread>
    80002fe8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002fea:	02892603          	lw	a2,40(s2)
    80002fee:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002ff0:	00c05f63          	blez	a2,8000300e <write_head+0x46>
    80002ff4:	00017717          	auipc	a4,0x17
    80002ff8:	d0870713          	addi	a4,a4,-760 # 80019cfc <log+0x2c>
    80002ffc:	87aa                	mv	a5,a0
    80002ffe:	060a                	slli	a2,a2,0x2
    80003000:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003002:	4314                	lw	a3,0(a4)
    80003004:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003006:	0711                	addi	a4,a4,4
    80003008:	0791                	addi	a5,a5,4
    8000300a:	fec79ce3          	bne	a5,a2,80003002 <write_head+0x3a>
  }
  bwrite(buf);
    8000300e:	8526                	mv	a0,s1
    80003010:	996ff0ef          	jal	800021a6 <bwrite>
  brelse(buf);
    80003014:	8526                	mv	a0,s1
    80003016:	9c2ff0ef          	jal	800021d8 <brelse>
}
    8000301a:	60e2                	ld	ra,24(sp)
    8000301c:	6442                	ld	s0,16(sp)
    8000301e:	64a2                	ld	s1,8(sp)
    80003020:	6902                	ld	s2,0(sp)
    80003022:	6105                	addi	sp,sp,32
    80003024:	8082                	ret

0000000080003026 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003026:	00017797          	auipc	a5,0x17
    8000302a:	cd27a783          	lw	a5,-814(a5) # 80019cf8 <log+0x28>
    8000302e:	0cf05163          	blez	a5,800030f0 <install_trans+0xca>
{
    80003032:	715d                	addi	sp,sp,-80
    80003034:	e486                	sd	ra,72(sp)
    80003036:	e0a2                	sd	s0,64(sp)
    80003038:	fc26                	sd	s1,56(sp)
    8000303a:	f84a                	sd	s2,48(sp)
    8000303c:	f44e                	sd	s3,40(sp)
    8000303e:	f052                	sd	s4,32(sp)
    80003040:	ec56                	sd	s5,24(sp)
    80003042:	e85a                	sd	s6,16(sp)
    80003044:	e45e                	sd	s7,8(sp)
    80003046:	e062                	sd	s8,0(sp)
    80003048:	0880                	addi	s0,sp,80
    8000304a:	8b2a                	mv	s6,a0
    8000304c:	00017a97          	auipc	s5,0x17
    80003050:	cb0a8a93          	addi	s5,s5,-848 # 80019cfc <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003054:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003056:	00004c17          	auipc	s8,0x4
    8000305a:	43ac0c13          	addi	s8,s8,1082 # 80007490 <etext+0x490>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000305e:	00017a17          	auipc	s4,0x17
    80003062:	c72a0a13          	addi	s4,s4,-910 # 80019cd0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003066:	40000b93          	li	s7,1024
    8000306a:	a025                	j	80003092 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000306c:	000aa603          	lw	a2,0(s5)
    80003070:	85ce                	mv	a1,s3
    80003072:	8562                	mv	a0,s8
    80003074:	3a8020ef          	jal	8000541c <printf>
    80003078:	a839                	j	80003096 <install_trans+0x70>
    brelse(lbuf);
    8000307a:	854a                	mv	a0,s2
    8000307c:	95cff0ef          	jal	800021d8 <brelse>
    brelse(dbuf);
    80003080:	8526                	mv	a0,s1
    80003082:	956ff0ef          	jal	800021d8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003086:	2985                	addiw	s3,s3,1
    80003088:	0a91                	addi	s5,s5,4
    8000308a:	028a2783          	lw	a5,40(s4)
    8000308e:	04f9d563          	bge	s3,a5,800030d8 <install_trans+0xb2>
    if(recovering) {
    80003092:	fc0b1de3          	bnez	s6,8000306c <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003096:	018a2583          	lw	a1,24(s4)
    8000309a:	013585bb          	addw	a1,a1,s3
    8000309e:	2585                	addiw	a1,a1,1
    800030a0:	024a2503          	lw	a0,36(s4)
    800030a4:	82cff0ef          	jal	800020d0 <bread>
    800030a8:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800030aa:	000aa583          	lw	a1,0(s5)
    800030ae:	024a2503          	lw	a0,36(s4)
    800030b2:	81eff0ef          	jal	800020d0 <bread>
    800030b6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800030b8:	865e                	mv	a2,s7
    800030ba:	05890593          	addi	a1,s2,88
    800030be:	05850513          	addi	a0,a0,88
    800030c2:	8fcfd0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    800030c6:	8526                	mv	a0,s1
    800030c8:	8deff0ef          	jal	800021a6 <bwrite>
    if(recovering == 0)
    800030cc:	fa0b17e3          	bnez	s6,8000307a <install_trans+0x54>
      bunpin(dbuf);
    800030d0:	8526                	mv	a0,s1
    800030d2:	9beff0ef          	jal	80002290 <bunpin>
    800030d6:	b755                	j	8000307a <install_trans+0x54>
}
    800030d8:	60a6                	ld	ra,72(sp)
    800030da:	6406                	ld	s0,64(sp)
    800030dc:	74e2                	ld	s1,56(sp)
    800030de:	7942                	ld	s2,48(sp)
    800030e0:	79a2                	ld	s3,40(sp)
    800030e2:	7a02                	ld	s4,32(sp)
    800030e4:	6ae2                	ld	s5,24(sp)
    800030e6:	6b42                	ld	s6,16(sp)
    800030e8:	6ba2                	ld	s7,8(sp)
    800030ea:	6c02                	ld	s8,0(sp)
    800030ec:	6161                	addi	sp,sp,80
    800030ee:	8082                	ret
    800030f0:	8082                	ret

00000000800030f2 <initlog>:
{
    800030f2:	7179                	addi	sp,sp,-48
    800030f4:	f406                	sd	ra,40(sp)
    800030f6:	f022                	sd	s0,32(sp)
    800030f8:	ec26                	sd	s1,24(sp)
    800030fa:	e84a                	sd	s2,16(sp)
    800030fc:	e44e                	sd	s3,8(sp)
    800030fe:	1800                	addi	s0,sp,48
    80003100:	84aa                	mv	s1,a0
    80003102:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003104:	00017917          	auipc	s2,0x17
    80003108:	bcc90913          	addi	s2,s2,-1076 # 80019cd0 <log>
    8000310c:	00004597          	auipc	a1,0x4
    80003110:	3a458593          	addi	a1,a1,932 # 800074b0 <etext+0x4b0>
    80003114:	854a                	mv	a0,s2
    80003116:	069020ef          	jal	8000597e <initlock>
  log.start = sb->logstart;
    8000311a:	0149a583          	lw	a1,20(s3)
    8000311e:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003122:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003126:	8526                	mv	a0,s1
    80003128:	fa9fe0ef          	jal	800020d0 <bread>
  log.lh.n = lh->n;
    8000312c:	4d30                	lw	a2,88(a0)
    8000312e:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003132:	00c05f63          	blez	a2,80003150 <initlog+0x5e>
    80003136:	87aa                	mv	a5,a0
    80003138:	00017717          	auipc	a4,0x17
    8000313c:	bc470713          	addi	a4,a4,-1084 # 80019cfc <log+0x2c>
    80003140:	060a                	slli	a2,a2,0x2
    80003142:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003144:	4ff4                	lw	a3,92(a5)
    80003146:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003148:	0791                	addi	a5,a5,4
    8000314a:	0711                	addi	a4,a4,4
    8000314c:	fec79ce3          	bne	a5,a2,80003144 <initlog+0x52>
  brelse(buf);
    80003150:	888ff0ef          	jal	800021d8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003154:	4505                	li	a0,1
    80003156:	ed1ff0ef          	jal	80003026 <install_trans>
  log.lh.n = 0;
    8000315a:	00017797          	auipc	a5,0x17
    8000315e:	b807af23          	sw	zero,-1122(a5) # 80019cf8 <log+0x28>
  write_head(); // clear the log
    80003162:	e67ff0ef          	jal	80002fc8 <write_head>
}
    80003166:	70a2                	ld	ra,40(sp)
    80003168:	7402                	ld	s0,32(sp)
    8000316a:	64e2                	ld	s1,24(sp)
    8000316c:	6942                	ld	s2,16(sp)
    8000316e:	69a2                	ld	s3,8(sp)
    80003170:	6145                	addi	sp,sp,48
    80003172:	8082                	ret

0000000080003174 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003174:	1101                	addi	sp,sp,-32
    80003176:	ec06                	sd	ra,24(sp)
    80003178:	e822                	sd	s0,16(sp)
    8000317a:	e426                	sd	s1,8(sp)
    8000317c:	e04a                	sd	s2,0(sp)
    8000317e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003180:	00017517          	auipc	a0,0x17
    80003184:	b5050513          	addi	a0,a0,-1200 # 80019cd0 <log>
    80003188:	081020ef          	jal	80005a08 <acquire>
  while(1){
    if(log.committing){
    8000318c:	00017497          	auipc	s1,0x17
    80003190:	b4448493          	addi	s1,s1,-1212 # 80019cd0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003194:	4979                	li	s2,30
    80003196:	a029                	j	800031a0 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003198:	85a6                	mv	a1,s1
    8000319a:	8526                	mv	a0,s1
    8000319c:	aaefe0ef          	jal	8000144a <sleep>
    if(log.committing){
    800031a0:	509c                	lw	a5,32(s1)
    800031a2:	fbfd                	bnez	a5,80003198 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800031a4:	4cd8                	lw	a4,28(s1)
    800031a6:	2705                	addiw	a4,a4,1
    800031a8:	0027179b          	slliw	a5,a4,0x2
    800031ac:	9fb9                	addw	a5,a5,a4
    800031ae:	0017979b          	slliw	a5,a5,0x1
    800031b2:	5494                	lw	a3,40(s1)
    800031b4:	9fb5                	addw	a5,a5,a3
    800031b6:	00f95763          	bge	s2,a5,800031c4 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800031ba:	85a6                	mv	a1,s1
    800031bc:	8526                	mv	a0,s1
    800031be:	a8cfe0ef          	jal	8000144a <sleep>
    800031c2:	bff9                	j	800031a0 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800031c4:	00017797          	auipc	a5,0x17
    800031c8:	b2e7a423          	sw	a4,-1240(a5) # 80019cec <log+0x1c>
      release(&log.lock);
    800031cc:	00017517          	auipc	a0,0x17
    800031d0:	b0450513          	addi	a0,a0,-1276 # 80019cd0 <log>
    800031d4:	0c9020ef          	jal	80005a9c <release>
      break;
    }
  }
}
    800031d8:	60e2                	ld	ra,24(sp)
    800031da:	6442                	ld	s0,16(sp)
    800031dc:	64a2                	ld	s1,8(sp)
    800031de:	6902                	ld	s2,0(sp)
    800031e0:	6105                	addi	sp,sp,32
    800031e2:	8082                	ret

00000000800031e4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800031e4:	7139                	addi	sp,sp,-64
    800031e6:	fc06                	sd	ra,56(sp)
    800031e8:	f822                	sd	s0,48(sp)
    800031ea:	f426                	sd	s1,40(sp)
    800031ec:	f04a                	sd	s2,32(sp)
    800031ee:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800031f0:	00017497          	auipc	s1,0x17
    800031f4:	ae048493          	addi	s1,s1,-1312 # 80019cd0 <log>
    800031f8:	8526                	mv	a0,s1
    800031fa:	00f020ef          	jal	80005a08 <acquire>
  log.outstanding -= 1;
    800031fe:	4cdc                	lw	a5,28(s1)
    80003200:	37fd                	addiw	a5,a5,-1
    80003202:	893e                	mv	s2,a5
    80003204:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003206:	509c                	lw	a5,32(s1)
    80003208:	e7b1                	bnez	a5,80003254 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    8000320a:	04091e63          	bnez	s2,80003266 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    8000320e:	00017497          	auipc	s1,0x17
    80003212:	ac248493          	addi	s1,s1,-1342 # 80019cd0 <log>
    80003216:	4785                	li	a5,1
    80003218:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000321a:	8526                	mv	a0,s1
    8000321c:	081020ef          	jal	80005a9c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003220:	549c                	lw	a5,40(s1)
    80003222:	06f04463          	bgtz	a5,8000328a <end_op+0xa6>
    acquire(&log.lock);
    80003226:	00017517          	auipc	a0,0x17
    8000322a:	aaa50513          	addi	a0,a0,-1366 # 80019cd0 <log>
    8000322e:	7da020ef          	jal	80005a08 <acquire>
    log.committing = 0;
    80003232:	00017797          	auipc	a5,0x17
    80003236:	aa07af23          	sw	zero,-1346(a5) # 80019cf0 <log+0x20>
    wakeup(&log);
    8000323a:	00017517          	auipc	a0,0x17
    8000323e:	a9650513          	addi	a0,a0,-1386 # 80019cd0 <log>
    80003242:	a54fe0ef          	jal	80001496 <wakeup>
    release(&log.lock);
    80003246:	00017517          	auipc	a0,0x17
    8000324a:	a8a50513          	addi	a0,a0,-1398 # 80019cd0 <log>
    8000324e:	04f020ef          	jal	80005a9c <release>
}
    80003252:	a035                	j	8000327e <end_op+0x9a>
    80003254:	ec4e                	sd	s3,24(sp)
    80003256:	e852                	sd	s4,16(sp)
    80003258:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000325a:	00004517          	auipc	a0,0x4
    8000325e:	25e50513          	addi	a0,a0,606 # 800074b8 <etext+0x4b8>
    80003262:	4e4020ef          	jal	80005746 <panic>
    wakeup(&log);
    80003266:	00017517          	auipc	a0,0x17
    8000326a:	a6a50513          	addi	a0,a0,-1430 # 80019cd0 <log>
    8000326e:	a28fe0ef          	jal	80001496 <wakeup>
  release(&log.lock);
    80003272:	00017517          	auipc	a0,0x17
    80003276:	a5e50513          	addi	a0,a0,-1442 # 80019cd0 <log>
    8000327a:	023020ef          	jal	80005a9c <release>
}
    8000327e:	70e2                	ld	ra,56(sp)
    80003280:	7442                	ld	s0,48(sp)
    80003282:	74a2                	ld	s1,40(sp)
    80003284:	7902                	ld	s2,32(sp)
    80003286:	6121                	addi	sp,sp,64
    80003288:	8082                	ret
    8000328a:	ec4e                	sd	s3,24(sp)
    8000328c:	e852                	sd	s4,16(sp)
    8000328e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003290:	00017a97          	auipc	s5,0x17
    80003294:	a6ca8a93          	addi	s5,s5,-1428 # 80019cfc <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003298:	00017a17          	auipc	s4,0x17
    8000329c:	a38a0a13          	addi	s4,s4,-1480 # 80019cd0 <log>
    800032a0:	018a2583          	lw	a1,24(s4)
    800032a4:	012585bb          	addw	a1,a1,s2
    800032a8:	2585                	addiw	a1,a1,1
    800032aa:	024a2503          	lw	a0,36(s4)
    800032ae:	e23fe0ef          	jal	800020d0 <bread>
    800032b2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800032b4:	000aa583          	lw	a1,0(s5)
    800032b8:	024a2503          	lw	a0,36(s4)
    800032bc:	e15fe0ef          	jal	800020d0 <bread>
    800032c0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800032c2:	40000613          	li	a2,1024
    800032c6:	05850593          	addi	a1,a0,88
    800032ca:	05848513          	addi	a0,s1,88
    800032ce:	ef1fc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    800032d2:	8526                	mv	a0,s1
    800032d4:	ed3fe0ef          	jal	800021a6 <bwrite>
    brelse(from);
    800032d8:	854e                	mv	a0,s3
    800032da:	efffe0ef          	jal	800021d8 <brelse>
    brelse(to);
    800032de:	8526                	mv	a0,s1
    800032e0:	ef9fe0ef          	jal	800021d8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800032e4:	2905                	addiw	s2,s2,1
    800032e6:	0a91                	addi	s5,s5,4
    800032e8:	028a2783          	lw	a5,40(s4)
    800032ec:	faf94ae3          	blt	s2,a5,800032a0 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800032f0:	cd9ff0ef          	jal	80002fc8 <write_head>
    install_trans(0); // Now install writes to home locations
    800032f4:	4501                	li	a0,0
    800032f6:	d31ff0ef          	jal	80003026 <install_trans>
    log.lh.n = 0;
    800032fa:	00017797          	auipc	a5,0x17
    800032fe:	9e07af23          	sw	zero,-1538(a5) # 80019cf8 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003302:	cc7ff0ef          	jal	80002fc8 <write_head>
    80003306:	69e2                	ld	s3,24(sp)
    80003308:	6a42                	ld	s4,16(sp)
    8000330a:	6aa2                	ld	s5,8(sp)
    8000330c:	bf29                	j	80003226 <end_op+0x42>

000000008000330e <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000330e:	1101                	addi	sp,sp,-32
    80003310:	ec06                	sd	ra,24(sp)
    80003312:	e822                	sd	s0,16(sp)
    80003314:	e426                	sd	s1,8(sp)
    80003316:	1000                	addi	s0,sp,32
    80003318:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000331a:	00017517          	auipc	a0,0x17
    8000331e:	9b650513          	addi	a0,a0,-1610 # 80019cd0 <log>
    80003322:	6e6020ef          	jal	80005a08 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003326:	00017617          	auipc	a2,0x17
    8000332a:	9d262603          	lw	a2,-1582(a2) # 80019cf8 <log+0x28>
    8000332e:	47f5                	li	a5,29
    80003330:	04c7cd63          	blt	a5,a2,8000338a <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003334:	00017797          	auipc	a5,0x17
    80003338:	9b87a783          	lw	a5,-1608(a5) # 80019cec <log+0x1c>
    8000333c:	04f05d63          	blez	a5,80003396 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003340:	4781                	li	a5,0
    80003342:	06c05063          	blez	a2,800033a2 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003346:	44cc                	lw	a1,12(s1)
    80003348:	00017717          	auipc	a4,0x17
    8000334c:	9b470713          	addi	a4,a4,-1612 # 80019cfc <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003350:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003352:	4314                	lw	a3,0(a4)
    80003354:	04b68763          	beq	a3,a1,800033a2 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003358:	2785                	addiw	a5,a5,1
    8000335a:	0711                	addi	a4,a4,4
    8000335c:	fef61be3          	bne	a2,a5,80003352 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003360:	060a                	slli	a2,a2,0x2
    80003362:	02060613          	addi	a2,a2,32
    80003366:	00017797          	auipc	a5,0x17
    8000336a:	96a78793          	addi	a5,a5,-1686 # 80019cd0 <log>
    8000336e:	97b2                	add	a5,a5,a2
    80003370:	44d8                	lw	a4,12(s1)
    80003372:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003374:	8526                	mv	a0,s1
    80003376:	ee7fe0ef          	jal	8000225c <bpin>
    log.lh.n++;
    8000337a:	00017717          	auipc	a4,0x17
    8000337e:	95670713          	addi	a4,a4,-1706 # 80019cd0 <log>
    80003382:	571c                	lw	a5,40(a4)
    80003384:	2785                	addiw	a5,a5,1
    80003386:	d71c                	sw	a5,40(a4)
    80003388:	a815                	j	800033bc <log_write+0xae>
    panic("too big a transaction");
    8000338a:	00004517          	auipc	a0,0x4
    8000338e:	13e50513          	addi	a0,a0,318 # 800074c8 <etext+0x4c8>
    80003392:	3b4020ef          	jal	80005746 <panic>
    panic("log_write outside of trans");
    80003396:	00004517          	auipc	a0,0x4
    8000339a:	14a50513          	addi	a0,a0,330 # 800074e0 <etext+0x4e0>
    8000339e:	3a8020ef          	jal	80005746 <panic>
  log.lh.block[i] = b->blockno;
    800033a2:	00279693          	slli	a3,a5,0x2
    800033a6:	02068693          	addi	a3,a3,32
    800033aa:	00017717          	auipc	a4,0x17
    800033ae:	92670713          	addi	a4,a4,-1754 # 80019cd0 <log>
    800033b2:	9736                	add	a4,a4,a3
    800033b4:	44d4                	lw	a3,12(s1)
    800033b6:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800033b8:	faf60ee3          	beq	a2,a5,80003374 <log_write+0x66>
  }
  release(&log.lock);
    800033bc:	00017517          	auipc	a0,0x17
    800033c0:	91450513          	addi	a0,a0,-1772 # 80019cd0 <log>
    800033c4:	6d8020ef          	jal	80005a9c <release>
}
    800033c8:	60e2                	ld	ra,24(sp)
    800033ca:	6442                	ld	s0,16(sp)
    800033cc:	64a2                	ld	s1,8(sp)
    800033ce:	6105                	addi	sp,sp,32
    800033d0:	8082                	ret

00000000800033d2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	e426                	sd	s1,8(sp)
    800033da:	e04a                	sd	s2,0(sp)
    800033dc:	1000                	addi	s0,sp,32
    800033de:	84aa                	mv	s1,a0
    800033e0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800033e2:	00004597          	auipc	a1,0x4
    800033e6:	11e58593          	addi	a1,a1,286 # 80007500 <etext+0x500>
    800033ea:	0521                	addi	a0,a0,8
    800033ec:	592020ef          	jal	8000597e <initlock>
  lk->name = name;
    800033f0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800033f4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033f8:	0204a423          	sw	zero,40(s1)
}
    800033fc:	60e2                	ld	ra,24(sp)
    800033fe:	6442                	ld	s0,16(sp)
    80003400:	64a2                	ld	s1,8(sp)
    80003402:	6902                	ld	s2,0(sp)
    80003404:	6105                	addi	sp,sp,32
    80003406:	8082                	ret

0000000080003408 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003408:	1101                	addi	sp,sp,-32
    8000340a:	ec06                	sd	ra,24(sp)
    8000340c:	e822                	sd	s0,16(sp)
    8000340e:	e426                	sd	s1,8(sp)
    80003410:	e04a                	sd	s2,0(sp)
    80003412:	1000                	addi	s0,sp,32
    80003414:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003416:	00850913          	addi	s2,a0,8
    8000341a:	854a                	mv	a0,s2
    8000341c:	5ec020ef          	jal	80005a08 <acquire>
  while (lk->locked) {
    80003420:	409c                	lw	a5,0(s1)
    80003422:	c799                	beqz	a5,80003430 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003424:	85ca                	mv	a1,s2
    80003426:	8526                	mv	a0,s1
    80003428:	822fe0ef          	jal	8000144a <sleep>
  while (lk->locked) {
    8000342c:	409c                	lw	a5,0(s1)
    8000342e:	fbfd                	bnez	a5,80003424 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003430:	4785                	li	a5,1
    80003432:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003434:	9a3fd0ef          	jal	80000dd6 <myproc>
    80003438:	591c                	lw	a5,48(a0)
    8000343a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000343c:	854a                	mv	a0,s2
    8000343e:	65e020ef          	jal	80005a9c <release>
}
    80003442:	60e2                	ld	ra,24(sp)
    80003444:	6442                	ld	s0,16(sp)
    80003446:	64a2                	ld	s1,8(sp)
    80003448:	6902                	ld	s2,0(sp)
    8000344a:	6105                	addi	sp,sp,32
    8000344c:	8082                	ret

000000008000344e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000344e:	1101                	addi	sp,sp,-32
    80003450:	ec06                	sd	ra,24(sp)
    80003452:	e822                	sd	s0,16(sp)
    80003454:	e426                	sd	s1,8(sp)
    80003456:	e04a                	sd	s2,0(sp)
    80003458:	1000                	addi	s0,sp,32
    8000345a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000345c:	00850913          	addi	s2,a0,8
    80003460:	854a                	mv	a0,s2
    80003462:	5a6020ef          	jal	80005a08 <acquire>
  lk->locked = 0;
    80003466:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000346a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000346e:	8526                	mv	a0,s1
    80003470:	826fe0ef          	jal	80001496 <wakeup>
  release(&lk->lk);
    80003474:	854a                	mv	a0,s2
    80003476:	626020ef          	jal	80005a9c <release>
}
    8000347a:	60e2                	ld	ra,24(sp)
    8000347c:	6442                	ld	s0,16(sp)
    8000347e:	64a2                	ld	s1,8(sp)
    80003480:	6902                	ld	s2,0(sp)
    80003482:	6105                	addi	sp,sp,32
    80003484:	8082                	ret

0000000080003486 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003486:	7179                	addi	sp,sp,-48
    80003488:	f406                	sd	ra,40(sp)
    8000348a:	f022                	sd	s0,32(sp)
    8000348c:	ec26                	sd	s1,24(sp)
    8000348e:	e84a                	sd	s2,16(sp)
    80003490:	1800                	addi	s0,sp,48
    80003492:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003494:	00850913          	addi	s2,a0,8
    80003498:	854a                	mv	a0,s2
    8000349a:	56e020ef          	jal	80005a08 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000349e:	409c                	lw	a5,0(s1)
    800034a0:	ef81                	bnez	a5,800034b8 <holdingsleep+0x32>
    800034a2:	4481                	li	s1,0
  release(&lk->lk);
    800034a4:	854a                	mv	a0,s2
    800034a6:	5f6020ef          	jal	80005a9c <release>
  return r;
}
    800034aa:	8526                	mv	a0,s1
    800034ac:	70a2                	ld	ra,40(sp)
    800034ae:	7402                	ld	s0,32(sp)
    800034b0:	64e2                	ld	s1,24(sp)
    800034b2:	6942                	ld	s2,16(sp)
    800034b4:	6145                	addi	sp,sp,48
    800034b6:	8082                	ret
    800034b8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800034ba:	0284a983          	lw	s3,40(s1)
    800034be:	919fd0ef          	jal	80000dd6 <myproc>
    800034c2:	5904                	lw	s1,48(a0)
    800034c4:	413484b3          	sub	s1,s1,s3
    800034c8:	0014b493          	seqz	s1,s1
    800034cc:	69a2                	ld	s3,8(sp)
    800034ce:	bfd9                	j	800034a4 <holdingsleep+0x1e>

00000000800034d0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800034d0:	1141                	addi	sp,sp,-16
    800034d2:	e406                	sd	ra,8(sp)
    800034d4:	e022                	sd	s0,0(sp)
    800034d6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800034d8:	00004597          	auipc	a1,0x4
    800034dc:	03858593          	addi	a1,a1,56 # 80007510 <etext+0x510>
    800034e0:	00017517          	auipc	a0,0x17
    800034e4:	93850513          	addi	a0,a0,-1736 # 80019e18 <ftable>
    800034e8:	496020ef          	jal	8000597e <initlock>
}
    800034ec:	60a2                	ld	ra,8(sp)
    800034ee:	6402                	ld	s0,0(sp)
    800034f0:	0141                	addi	sp,sp,16
    800034f2:	8082                	ret

00000000800034f4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800034f4:	1101                	addi	sp,sp,-32
    800034f6:	ec06                	sd	ra,24(sp)
    800034f8:	e822                	sd	s0,16(sp)
    800034fa:	e426                	sd	s1,8(sp)
    800034fc:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800034fe:	00017517          	auipc	a0,0x17
    80003502:	91a50513          	addi	a0,a0,-1766 # 80019e18 <ftable>
    80003506:	502020ef          	jal	80005a08 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000350a:	00017497          	auipc	s1,0x17
    8000350e:	92648493          	addi	s1,s1,-1754 # 80019e30 <ftable+0x18>
    80003512:	00018717          	auipc	a4,0x18
    80003516:	8be70713          	addi	a4,a4,-1858 # 8001add0 <disk>
    if(f->ref == 0){
    8000351a:	40dc                	lw	a5,4(s1)
    8000351c:	cf89                	beqz	a5,80003536 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000351e:	02848493          	addi	s1,s1,40
    80003522:	fee49ce3          	bne	s1,a4,8000351a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003526:	00017517          	auipc	a0,0x17
    8000352a:	8f250513          	addi	a0,a0,-1806 # 80019e18 <ftable>
    8000352e:	56e020ef          	jal	80005a9c <release>
  return 0;
    80003532:	4481                	li	s1,0
    80003534:	a809                	j	80003546 <filealloc+0x52>
      f->ref = 1;
    80003536:	4785                	li	a5,1
    80003538:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000353a:	00017517          	auipc	a0,0x17
    8000353e:	8de50513          	addi	a0,a0,-1826 # 80019e18 <ftable>
    80003542:	55a020ef          	jal	80005a9c <release>
}
    80003546:	8526                	mv	a0,s1
    80003548:	60e2                	ld	ra,24(sp)
    8000354a:	6442                	ld	s0,16(sp)
    8000354c:	64a2                	ld	s1,8(sp)
    8000354e:	6105                	addi	sp,sp,32
    80003550:	8082                	ret

0000000080003552 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003552:	1101                	addi	sp,sp,-32
    80003554:	ec06                	sd	ra,24(sp)
    80003556:	e822                	sd	s0,16(sp)
    80003558:	e426                	sd	s1,8(sp)
    8000355a:	1000                	addi	s0,sp,32
    8000355c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000355e:	00017517          	auipc	a0,0x17
    80003562:	8ba50513          	addi	a0,a0,-1862 # 80019e18 <ftable>
    80003566:	4a2020ef          	jal	80005a08 <acquire>
  if(f->ref < 1)
    8000356a:	40dc                	lw	a5,4(s1)
    8000356c:	02f05063          	blez	a5,8000358c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003570:	2785                	addiw	a5,a5,1
    80003572:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003574:	00017517          	auipc	a0,0x17
    80003578:	8a450513          	addi	a0,a0,-1884 # 80019e18 <ftable>
    8000357c:	520020ef          	jal	80005a9c <release>
  return f;
}
    80003580:	8526                	mv	a0,s1
    80003582:	60e2                	ld	ra,24(sp)
    80003584:	6442                	ld	s0,16(sp)
    80003586:	64a2                	ld	s1,8(sp)
    80003588:	6105                	addi	sp,sp,32
    8000358a:	8082                	ret
    panic("filedup");
    8000358c:	00004517          	auipc	a0,0x4
    80003590:	f8c50513          	addi	a0,a0,-116 # 80007518 <etext+0x518>
    80003594:	1b2020ef          	jal	80005746 <panic>

0000000080003598 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003598:	7139                	addi	sp,sp,-64
    8000359a:	fc06                	sd	ra,56(sp)
    8000359c:	f822                	sd	s0,48(sp)
    8000359e:	f426                	sd	s1,40(sp)
    800035a0:	0080                	addi	s0,sp,64
    800035a2:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800035a4:	00017517          	auipc	a0,0x17
    800035a8:	87450513          	addi	a0,a0,-1932 # 80019e18 <ftable>
    800035ac:	45c020ef          	jal	80005a08 <acquire>
  if(f->ref < 1)
    800035b0:	40dc                	lw	a5,4(s1)
    800035b2:	04f05a63          	blez	a5,80003606 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800035b6:	37fd                	addiw	a5,a5,-1
    800035b8:	c0dc                	sw	a5,4(s1)
    800035ba:	06f04063          	bgtz	a5,8000361a <fileclose+0x82>
    800035be:	f04a                	sd	s2,32(sp)
    800035c0:	ec4e                	sd	s3,24(sp)
    800035c2:	e852                	sd	s4,16(sp)
    800035c4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800035c6:	0004a903          	lw	s2,0(s1)
    800035ca:	0094c783          	lbu	a5,9(s1)
    800035ce:	89be                	mv	s3,a5
    800035d0:	689c                	ld	a5,16(s1)
    800035d2:	8a3e                	mv	s4,a5
    800035d4:	6c9c                	ld	a5,24(s1)
    800035d6:	8abe                	mv	s5,a5
  f->ref = 0;
    800035d8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800035dc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800035e0:	00017517          	auipc	a0,0x17
    800035e4:	83850513          	addi	a0,a0,-1992 # 80019e18 <ftable>
    800035e8:	4b4020ef          	jal	80005a9c <release>

  if(ff.type == FD_PIPE){
    800035ec:	4785                	li	a5,1
    800035ee:	04f90163          	beq	s2,a5,80003630 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800035f2:	ffe9079b          	addiw	a5,s2,-2
    800035f6:	4705                	li	a4,1
    800035f8:	04f77563          	bgeu	a4,a5,80003642 <fileclose+0xaa>
    800035fc:	7902                	ld	s2,32(sp)
    800035fe:	69e2                	ld	s3,24(sp)
    80003600:	6a42                	ld	s4,16(sp)
    80003602:	6aa2                	ld	s5,8(sp)
    80003604:	a00d                	j	80003626 <fileclose+0x8e>
    80003606:	f04a                	sd	s2,32(sp)
    80003608:	ec4e                	sd	s3,24(sp)
    8000360a:	e852                	sd	s4,16(sp)
    8000360c:	e456                	sd	s5,8(sp)
    panic("fileclose");
    8000360e:	00004517          	auipc	a0,0x4
    80003612:	f1250513          	addi	a0,a0,-238 # 80007520 <etext+0x520>
    80003616:	130020ef          	jal	80005746 <panic>
    release(&ftable.lock);
    8000361a:	00016517          	auipc	a0,0x16
    8000361e:	7fe50513          	addi	a0,a0,2046 # 80019e18 <ftable>
    80003622:	47a020ef          	jal	80005a9c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003626:	70e2                	ld	ra,56(sp)
    80003628:	7442                	ld	s0,48(sp)
    8000362a:	74a2                	ld	s1,40(sp)
    8000362c:	6121                	addi	sp,sp,64
    8000362e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003630:	85ce                	mv	a1,s3
    80003632:	8552                	mv	a0,s4
    80003634:	348000ef          	jal	8000397c <pipeclose>
    80003638:	7902                	ld	s2,32(sp)
    8000363a:	69e2                	ld	s3,24(sp)
    8000363c:	6a42                	ld	s4,16(sp)
    8000363e:	6aa2                	ld	s5,8(sp)
    80003640:	b7dd                	j	80003626 <fileclose+0x8e>
    begin_op();
    80003642:	b33ff0ef          	jal	80003174 <begin_op>
    iput(ff.ip);
    80003646:	8556                	mv	a0,s5
    80003648:	aa2ff0ef          	jal	800028ea <iput>
    end_op();
    8000364c:	b99ff0ef          	jal	800031e4 <end_op>
    80003650:	7902                	ld	s2,32(sp)
    80003652:	69e2                	ld	s3,24(sp)
    80003654:	6a42                	ld	s4,16(sp)
    80003656:	6aa2                	ld	s5,8(sp)
    80003658:	b7f9                	j	80003626 <fileclose+0x8e>

000000008000365a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000365a:	715d                	addi	sp,sp,-80
    8000365c:	e486                	sd	ra,72(sp)
    8000365e:	e0a2                	sd	s0,64(sp)
    80003660:	fc26                	sd	s1,56(sp)
    80003662:	f052                	sd	s4,32(sp)
    80003664:	0880                	addi	s0,sp,80
    80003666:	84aa                	mv	s1,a0
    80003668:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000366a:	f6cfd0ef          	jal	80000dd6 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000366e:	409c                	lw	a5,0(s1)
    80003670:	37f9                	addiw	a5,a5,-2
    80003672:	4705                	li	a4,1
    80003674:	04f76263          	bltu	a4,a5,800036b8 <filestat+0x5e>
    80003678:	f84a                	sd	s2,48(sp)
    8000367a:	f44e                	sd	s3,40(sp)
    8000367c:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000367e:	6c88                	ld	a0,24(s1)
    80003680:	8e8ff0ef          	jal	80002768 <ilock>
    stati(f->ip, &st);
    80003684:	fb840913          	addi	s2,s0,-72
    80003688:	85ca                	mv	a1,s2
    8000368a:	6c88                	ld	a0,24(s1)
    8000368c:	c40ff0ef          	jal	80002acc <stati>
    iunlock(f->ip);
    80003690:	6c88                	ld	a0,24(s1)
    80003692:	984ff0ef          	jal	80002816 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003696:	46e1                	li	a3,24
    80003698:	864a                	mv	a2,s2
    8000369a:	85d2                	mv	a1,s4
    8000369c:	0509b503          	ld	a0,80(s3)
    800036a0:	c54fd0ef          	jal	80000af4 <copyout>
    800036a4:	41f5551b          	sraiw	a0,a0,0x1f
    800036a8:	7942                	ld	s2,48(sp)
    800036aa:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800036ac:	60a6                	ld	ra,72(sp)
    800036ae:	6406                	ld	s0,64(sp)
    800036b0:	74e2                	ld	s1,56(sp)
    800036b2:	7a02                	ld	s4,32(sp)
    800036b4:	6161                	addi	sp,sp,80
    800036b6:	8082                	ret
  return -1;
    800036b8:	557d                	li	a0,-1
    800036ba:	bfcd                	j	800036ac <filestat+0x52>

00000000800036bc <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800036bc:	7179                	addi	sp,sp,-48
    800036be:	f406                	sd	ra,40(sp)
    800036c0:	f022                	sd	s0,32(sp)
    800036c2:	e84a                	sd	s2,16(sp)
    800036c4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800036c6:	00854783          	lbu	a5,8(a0)
    800036ca:	cfd1                	beqz	a5,80003766 <fileread+0xaa>
    800036cc:	ec26                	sd	s1,24(sp)
    800036ce:	e44e                	sd	s3,8(sp)
    800036d0:	84aa                	mv	s1,a0
    800036d2:	892e                	mv	s2,a1
    800036d4:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800036d6:	411c                	lw	a5,0(a0)
    800036d8:	4705                	li	a4,1
    800036da:	04e78363          	beq	a5,a4,80003720 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036de:	470d                	li	a4,3
    800036e0:	04e78763          	beq	a5,a4,8000372e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800036e4:	4709                	li	a4,2
    800036e6:	06e79a63          	bne	a5,a4,8000375a <fileread+0x9e>
    ilock(f->ip);
    800036ea:	6d08                	ld	a0,24(a0)
    800036ec:	87cff0ef          	jal	80002768 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800036f0:	874e                	mv	a4,s3
    800036f2:	5094                	lw	a3,32(s1)
    800036f4:	864a                	mv	a2,s2
    800036f6:	4585                	li	a1,1
    800036f8:	6c88                	ld	a0,24(s1)
    800036fa:	c00ff0ef          	jal	80002afa <readi>
    800036fe:	892a                	mv	s2,a0
    80003700:	00a05563          	blez	a0,8000370a <fileread+0x4e>
      f->off += r;
    80003704:	509c                	lw	a5,32(s1)
    80003706:	9fa9                	addw	a5,a5,a0
    80003708:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    8000370a:	6c88                	ld	a0,24(s1)
    8000370c:	90aff0ef          	jal	80002816 <iunlock>
    80003710:	64e2                	ld	s1,24(sp)
    80003712:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003714:	854a                	mv	a0,s2
    80003716:	70a2                	ld	ra,40(sp)
    80003718:	7402                	ld	s0,32(sp)
    8000371a:	6942                	ld	s2,16(sp)
    8000371c:	6145                	addi	sp,sp,48
    8000371e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003720:	6908                	ld	a0,16(a0)
    80003722:	3b0000ef          	jal	80003ad2 <piperead>
    80003726:	892a                	mv	s2,a0
    80003728:	64e2                	ld	s1,24(sp)
    8000372a:	69a2                	ld	s3,8(sp)
    8000372c:	b7e5                	j	80003714 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000372e:	02451783          	lh	a5,36(a0)
    80003732:	03079693          	slli	a3,a5,0x30
    80003736:	92c1                	srli	a3,a3,0x30
    80003738:	4725                	li	a4,9
    8000373a:	02d76963          	bltu	a4,a3,8000376c <fileread+0xb0>
    8000373e:	0792                	slli	a5,a5,0x4
    80003740:	00016717          	auipc	a4,0x16
    80003744:	63870713          	addi	a4,a4,1592 # 80019d78 <devsw>
    80003748:	97ba                	add	a5,a5,a4
    8000374a:	639c                	ld	a5,0(a5)
    8000374c:	c78d                	beqz	a5,80003776 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    8000374e:	4505                	li	a0,1
    80003750:	9782                	jalr	a5
    80003752:	892a                	mv	s2,a0
    80003754:	64e2                	ld	s1,24(sp)
    80003756:	69a2                	ld	s3,8(sp)
    80003758:	bf75                	j	80003714 <fileread+0x58>
    panic("fileread");
    8000375a:	00004517          	auipc	a0,0x4
    8000375e:	dd650513          	addi	a0,a0,-554 # 80007530 <etext+0x530>
    80003762:	7e5010ef          	jal	80005746 <panic>
    return -1;
    80003766:	57fd                	li	a5,-1
    80003768:	893e                	mv	s2,a5
    8000376a:	b76d                	j	80003714 <fileread+0x58>
      return -1;
    8000376c:	57fd                	li	a5,-1
    8000376e:	893e                	mv	s2,a5
    80003770:	64e2                	ld	s1,24(sp)
    80003772:	69a2                	ld	s3,8(sp)
    80003774:	b745                	j	80003714 <fileread+0x58>
    80003776:	57fd                	li	a5,-1
    80003778:	893e                	mv	s2,a5
    8000377a:	64e2                	ld	s1,24(sp)
    8000377c:	69a2                	ld	s3,8(sp)
    8000377e:	bf59                	j	80003714 <fileread+0x58>

0000000080003780 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003780:	00954783          	lbu	a5,9(a0)
    80003784:	10078f63          	beqz	a5,800038a2 <filewrite+0x122>
{
    80003788:	711d                	addi	sp,sp,-96
    8000378a:	ec86                	sd	ra,88(sp)
    8000378c:	e8a2                	sd	s0,80(sp)
    8000378e:	e0ca                	sd	s2,64(sp)
    80003790:	f456                	sd	s5,40(sp)
    80003792:	f05a                	sd	s6,32(sp)
    80003794:	1080                	addi	s0,sp,96
    80003796:	892a                	mv	s2,a0
    80003798:	8b2e                	mv	s6,a1
    8000379a:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000379c:	411c                	lw	a5,0(a0)
    8000379e:	4705                	li	a4,1
    800037a0:	02e78a63          	beq	a5,a4,800037d4 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037a4:	470d                	li	a4,3
    800037a6:	02e78b63          	beq	a5,a4,800037dc <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800037aa:	4709                	li	a4,2
    800037ac:	0ce79f63          	bne	a5,a4,8000388a <filewrite+0x10a>
    800037b0:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800037b2:	0ac05a63          	blez	a2,80003866 <filewrite+0xe6>
    800037b6:	e4a6                	sd	s1,72(sp)
    800037b8:	fc4e                	sd	s3,56(sp)
    800037ba:	ec5e                	sd	s7,24(sp)
    800037bc:	e862                	sd	s8,16(sp)
    800037be:	e466                	sd	s9,8(sp)
    int i = 0;
    800037c0:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800037c2:	6b85                	lui	s7,0x1
    800037c4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800037c8:	6785                	lui	a5,0x1
    800037ca:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800037ce:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800037d0:	4c05                	li	s8,1
    800037d2:	a8ad                	j	8000384c <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800037d4:	6908                	ld	a0,16(a0)
    800037d6:	204000ef          	jal	800039da <pipewrite>
    800037da:	a04d                	j	8000387c <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800037dc:	02451783          	lh	a5,36(a0)
    800037e0:	03079693          	slli	a3,a5,0x30
    800037e4:	92c1                	srli	a3,a3,0x30
    800037e6:	4725                	li	a4,9
    800037e8:	0ad76f63          	bltu	a4,a3,800038a6 <filewrite+0x126>
    800037ec:	0792                	slli	a5,a5,0x4
    800037ee:	00016717          	auipc	a4,0x16
    800037f2:	58a70713          	addi	a4,a4,1418 # 80019d78 <devsw>
    800037f6:	97ba                	add	a5,a5,a4
    800037f8:	679c                	ld	a5,8(a5)
    800037fa:	cbc5                	beqz	a5,800038aa <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800037fc:	4505                	li	a0,1
    800037fe:	9782                	jalr	a5
    80003800:	a8b5                	j	8000387c <filewrite+0xfc>
      if(n1 > max)
    80003802:	2981                	sext.w	s3,s3
      begin_op();
    80003804:	971ff0ef          	jal	80003174 <begin_op>
      ilock(f->ip);
    80003808:	01893503          	ld	a0,24(s2)
    8000380c:	f5dfe0ef          	jal	80002768 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003810:	874e                	mv	a4,s3
    80003812:	02092683          	lw	a3,32(s2)
    80003816:	016a0633          	add	a2,s4,s6
    8000381a:	85e2                	mv	a1,s8
    8000381c:	01893503          	ld	a0,24(s2)
    80003820:	bccff0ef          	jal	80002bec <writei>
    80003824:	84aa                	mv	s1,a0
    80003826:	00a05763          	blez	a0,80003834 <filewrite+0xb4>
        f->off += r;
    8000382a:	02092783          	lw	a5,32(s2)
    8000382e:	9fa9                	addw	a5,a5,a0
    80003830:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003834:	01893503          	ld	a0,24(s2)
    80003838:	fdffe0ef          	jal	80002816 <iunlock>
      end_op();
    8000383c:	9a9ff0ef          	jal	800031e4 <end_op>

      if(r != n1){
    80003840:	02999563          	bne	s3,s1,8000386a <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80003844:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003848:	015a5963          	bge	s4,s5,8000385a <filewrite+0xda>
      int n1 = n - i;
    8000384c:	414a87bb          	subw	a5,s5,s4
    80003850:	89be                	mv	s3,a5
      if(n1 > max)
    80003852:	fafbd8e3          	bge	s7,a5,80003802 <filewrite+0x82>
    80003856:	89e6                	mv	s3,s9
    80003858:	b76d                	j	80003802 <filewrite+0x82>
    8000385a:	64a6                	ld	s1,72(sp)
    8000385c:	79e2                	ld	s3,56(sp)
    8000385e:	6be2                	ld	s7,24(sp)
    80003860:	6c42                	ld	s8,16(sp)
    80003862:	6ca2                	ld	s9,8(sp)
    80003864:	a801                	j	80003874 <filewrite+0xf4>
    int i = 0;
    80003866:	4a01                	li	s4,0
    80003868:	a031                	j	80003874 <filewrite+0xf4>
    8000386a:	64a6                	ld	s1,72(sp)
    8000386c:	79e2                	ld	s3,56(sp)
    8000386e:	6be2                	ld	s7,24(sp)
    80003870:	6c42                	ld	s8,16(sp)
    80003872:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003874:	034a9d63          	bne	s5,s4,800038ae <filewrite+0x12e>
    80003878:	8556                	mv	a0,s5
    8000387a:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000387c:	60e6                	ld	ra,88(sp)
    8000387e:	6446                	ld	s0,80(sp)
    80003880:	6906                	ld	s2,64(sp)
    80003882:	7aa2                	ld	s5,40(sp)
    80003884:	7b02                	ld	s6,32(sp)
    80003886:	6125                	addi	sp,sp,96
    80003888:	8082                	ret
    8000388a:	e4a6                	sd	s1,72(sp)
    8000388c:	fc4e                	sd	s3,56(sp)
    8000388e:	f852                	sd	s4,48(sp)
    80003890:	ec5e                	sd	s7,24(sp)
    80003892:	e862                	sd	s8,16(sp)
    80003894:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003896:	00004517          	auipc	a0,0x4
    8000389a:	caa50513          	addi	a0,a0,-854 # 80007540 <etext+0x540>
    8000389e:	6a9010ef          	jal	80005746 <panic>
    return -1;
    800038a2:	557d                	li	a0,-1
}
    800038a4:	8082                	ret
      return -1;
    800038a6:	557d                	li	a0,-1
    800038a8:	bfd1                	j	8000387c <filewrite+0xfc>
    800038aa:	557d                	li	a0,-1
    800038ac:	bfc1                	j	8000387c <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800038ae:	557d                	li	a0,-1
    800038b0:	7a42                	ld	s4,48(sp)
    800038b2:	b7e9                	j	8000387c <filewrite+0xfc>

00000000800038b4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800038b4:	7179                	addi	sp,sp,-48
    800038b6:	f406                	sd	ra,40(sp)
    800038b8:	f022                	sd	s0,32(sp)
    800038ba:	ec26                	sd	s1,24(sp)
    800038bc:	e052                	sd	s4,0(sp)
    800038be:	1800                	addi	s0,sp,48
    800038c0:	84aa                	mv	s1,a0
    800038c2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800038c4:	0005b023          	sd	zero,0(a1)
    800038c8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800038cc:	c29ff0ef          	jal	800034f4 <filealloc>
    800038d0:	e088                	sd	a0,0(s1)
    800038d2:	c549                	beqz	a0,8000395c <pipealloc+0xa8>
    800038d4:	c21ff0ef          	jal	800034f4 <filealloc>
    800038d8:	00aa3023          	sd	a0,0(s4)
    800038dc:	cd25                	beqz	a0,80003954 <pipealloc+0xa0>
    800038de:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800038e0:	825fc0ef          	jal	80000104 <kalloc>
    800038e4:	892a                	mv	s2,a0
    800038e6:	c12d                	beqz	a0,80003948 <pipealloc+0x94>
    800038e8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800038ea:	4985                	li	s3,1
    800038ec:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800038f0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800038f4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800038f8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800038fc:	00004597          	auipc	a1,0x4
    80003900:	c5458593          	addi	a1,a1,-940 # 80007550 <etext+0x550>
    80003904:	07a020ef          	jal	8000597e <initlock>
  (*f0)->type = FD_PIPE;
    80003908:	609c                	ld	a5,0(s1)
    8000390a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    8000390e:	609c                	ld	a5,0(s1)
    80003910:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003914:	609c                	ld	a5,0(s1)
    80003916:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000391a:	609c                	ld	a5,0(s1)
    8000391c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003920:	000a3783          	ld	a5,0(s4)
    80003924:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003928:	000a3783          	ld	a5,0(s4)
    8000392c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003930:	000a3783          	ld	a5,0(s4)
    80003934:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003938:	000a3783          	ld	a5,0(s4)
    8000393c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003940:	4501                	li	a0,0
    80003942:	6942                	ld	s2,16(sp)
    80003944:	69a2                	ld	s3,8(sp)
    80003946:	a01d                	j	8000396c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003948:	6088                	ld	a0,0(s1)
    8000394a:	c119                	beqz	a0,80003950 <pipealloc+0x9c>
    8000394c:	6942                	ld	s2,16(sp)
    8000394e:	a029                	j	80003958 <pipealloc+0xa4>
    80003950:	6942                	ld	s2,16(sp)
    80003952:	a029                	j	8000395c <pipealloc+0xa8>
    80003954:	6088                	ld	a0,0(s1)
    80003956:	c10d                	beqz	a0,80003978 <pipealloc+0xc4>
    fileclose(*f0);
    80003958:	c41ff0ef          	jal	80003598 <fileclose>
  if(*f1)
    8000395c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003960:	557d                	li	a0,-1
  if(*f1)
    80003962:	c789                	beqz	a5,8000396c <pipealloc+0xb8>
    fileclose(*f1);
    80003964:	853e                	mv	a0,a5
    80003966:	c33ff0ef          	jal	80003598 <fileclose>
  return -1;
    8000396a:	557d                	li	a0,-1
}
    8000396c:	70a2                	ld	ra,40(sp)
    8000396e:	7402                	ld	s0,32(sp)
    80003970:	64e2                	ld	s1,24(sp)
    80003972:	6a02                	ld	s4,0(sp)
    80003974:	6145                	addi	sp,sp,48
    80003976:	8082                	ret
  return -1;
    80003978:	557d                	li	a0,-1
    8000397a:	bfcd                	j	8000396c <pipealloc+0xb8>

000000008000397c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000397c:	1101                	addi	sp,sp,-32
    8000397e:	ec06                	sd	ra,24(sp)
    80003980:	e822                	sd	s0,16(sp)
    80003982:	e426                	sd	s1,8(sp)
    80003984:	e04a                	sd	s2,0(sp)
    80003986:	1000                	addi	s0,sp,32
    80003988:	84aa                	mv	s1,a0
    8000398a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000398c:	07c020ef          	jal	80005a08 <acquire>
  if(writable){
    80003990:	02090763          	beqz	s2,800039be <pipeclose+0x42>
    pi->writeopen = 0;
    80003994:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003998:	21848513          	addi	a0,s1,536
    8000399c:	afbfd0ef          	jal	80001496 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800039a0:	2204a783          	lw	a5,544(s1)
    800039a4:	e781                	bnez	a5,800039ac <pipeclose+0x30>
    800039a6:	2244a783          	lw	a5,548(s1)
    800039aa:	c38d                	beqz	a5,800039cc <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800039ac:	8526                	mv	a0,s1
    800039ae:	0ee020ef          	jal	80005a9c <release>
}
    800039b2:	60e2                	ld	ra,24(sp)
    800039b4:	6442                	ld	s0,16(sp)
    800039b6:	64a2                	ld	s1,8(sp)
    800039b8:	6902                	ld	s2,0(sp)
    800039ba:	6105                	addi	sp,sp,32
    800039bc:	8082                	ret
    pi->readopen = 0;
    800039be:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800039c2:	21c48513          	addi	a0,s1,540
    800039c6:	ad1fd0ef          	jal	80001496 <wakeup>
    800039ca:	bfd9                	j	800039a0 <pipeclose+0x24>
    release(&pi->lock);
    800039cc:	8526                	mv	a0,s1
    800039ce:	0ce020ef          	jal	80005a9c <release>
    kfree((char*)pi);
    800039d2:	8526                	mv	a0,s1
    800039d4:	e48fc0ef          	jal	8000001c <kfree>
    800039d8:	bfe9                	j	800039b2 <pipeclose+0x36>

00000000800039da <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800039da:	7159                	addi	sp,sp,-112
    800039dc:	f486                	sd	ra,104(sp)
    800039de:	f0a2                	sd	s0,96(sp)
    800039e0:	eca6                	sd	s1,88(sp)
    800039e2:	e8ca                	sd	s2,80(sp)
    800039e4:	e4ce                	sd	s3,72(sp)
    800039e6:	e0d2                	sd	s4,64(sp)
    800039e8:	fc56                	sd	s5,56(sp)
    800039ea:	1880                	addi	s0,sp,112
    800039ec:	84aa                	mv	s1,a0
    800039ee:	8aae                	mv	s5,a1
    800039f0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800039f2:	be4fd0ef          	jal	80000dd6 <myproc>
    800039f6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800039f8:	8526                	mv	a0,s1
    800039fa:	00e020ef          	jal	80005a08 <acquire>
  while(i < n){
    800039fe:	0d405263          	blez	s4,80003ac2 <pipewrite+0xe8>
    80003a02:	f85a                	sd	s6,48(sp)
    80003a04:	f45e                	sd	s7,40(sp)
    80003a06:	f062                	sd	s8,32(sp)
    80003a08:	ec66                	sd	s9,24(sp)
    80003a0a:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003a0c:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a0e:	f9f40c13          	addi	s8,s0,-97
    80003a12:	4b85                	li	s7,1
    80003a14:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003a16:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003a1a:	21c48c93          	addi	s9,s1,540
    80003a1e:	a82d                	j	80003a58 <pipewrite+0x7e>
      release(&pi->lock);
    80003a20:	8526                	mv	a0,s1
    80003a22:	07a020ef          	jal	80005a9c <release>
      return -1;
    80003a26:	597d                	li	s2,-1
    80003a28:	7b42                	ld	s6,48(sp)
    80003a2a:	7ba2                	ld	s7,40(sp)
    80003a2c:	7c02                	ld	s8,32(sp)
    80003a2e:	6ce2                	ld	s9,24(sp)
    80003a30:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003a32:	854a                	mv	a0,s2
    80003a34:	70a6                	ld	ra,104(sp)
    80003a36:	7406                	ld	s0,96(sp)
    80003a38:	64e6                	ld	s1,88(sp)
    80003a3a:	6946                	ld	s2,80(sp)
    80003a3c:	69a6                	ld	s3,72(sp)
    80003a3e:	6a06                	ld	s4,64(sp)
    80003a40:	7ae2                	ld	s5,56(sp)
    80003a42:	6165                	addi	sp,sp,112
    80003a44:	8082                	ret
      wakeup(&pi->nread);
    80003a46:	856a                	mv	a0,s10
    80003a48:	a4ffd0ef          	jal	80001496 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003a4c:	85a6                	mv	a1,s1
    80003a4e:	8566                	mv	a0,s9
    80003a50:	9fbfd0ef          	jal	8000144a <sleep>
  while(i < n){
    80003a54:	05495a63          	bge	s2,s4,80003aa8 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003a58:	2204a783          	lw	a5,544(s1)
    80003a5c:	d3f1                	beqz	a5,80003a20 <pipewrite+0x46>
    80003a5e:	854e                	mv	a0,s3
    80003a60:	c27fd0ef          	jal	80001686 <killed>
    80003a64:	fd55                	bnez	a0,80003a20 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003a66:	2184a783          	lw	a5,536(s1)
    80003a6a:	21c4a703          	lw	a4,540(s1)
    80003a6e:	2007879b          	addiw	a5,a5,512
    80003a72:	fcf70ae3          	beq	a4,a5,80003a46 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a76:	86de                	mv	a3,s7
    80003a78:	01590633          	add	a2,s2,s5
    80003a7c:	85e2                	mv	a1,s8
    80003a7e:	0509b503          	ld	a0,80(s3)
    80003a82:	936fd0ef          	jal	80000bb8 <copyin>
    80003a86:	05650063          	beq	a0,s6,80003ac6 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003a8a:	21c4a783          	lw	a5,540(s1)
    80003a8e:	0017871b          	addiw	a4,a5,1
    80003a92:	20e4ae23          	sw	a4,540(s1)
    80003a96:	1ff7f793          	andi	a5,a5,511
    80003a9a:	97a6                	add	a5,a5,s1
    80003a9c:	f9f44703          	lbu	a4,-97(s0)
    80003aa0:	00e78c23          	sb	a4,24(a5)
      i++;
    80003aa4:	2905                	addiw	s2,s2,1
    80003aa6:	b77d                	j	80003a54 <pipewrite+0x7a>
    80003aa8:	7b42                	ld	s6,48(sp)
    80003aaa:	7ba2                	ld	s7,40(sp)
    80003aac:	7c02                	ld	s8,32(sp)
    80003aae:	6ce2                	ld	s9,24(sp)
    80003ab0:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003ab2:	21848513          	addi	a0,s1,536
    80003ab6:	9e1fd0ef          	jal	80001496 <wakeup>
  release(&pi->lock);
    80003aba:	8526                	mv	a0,s1
    80003abc:	7e1010ef          	jal	80005a9c <release>
  return i;
    80003ac0:	bf8d                	j	80003a32 <pipewrite+0x58>
  int i = 0;
    80003ac2:	4901                	li	s2,0
    80003ac4:	b7fd                	j	80003ab2 <pipewrite+0xd8>
    80003ac6:	7b42                	ld	s6,48(sp)
    80003ac8:	7ba2                	ld	s7,40(sp)
    80003aca:	7c02                	ld	s8,32(sp)
    80003acc:	6ce2                	ld	s9,24(sp)
    80003ace:	6d42                	ld	s10,16(sp)
    80003ad0:	b7cd                	j	80003ab2 <pipewrite+0xd8>

0000000080003ad2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ad2:	711d                	addi	sp,sp,-96
    80003ad4:	ec86                	sd	ra,88(sp)
    80003ad6:	e8a2                	sd	s0,80(sp)
    80003ad8:	e4a6                	sd	s1,72(sp)
    80003ada:	e0ca                	sd	s2,64(sp)
    80003adc:	fc4e                	sd	s3,56(sp)
    80003ade:	f852                	sd	s4,48(sp)
    80003ae0:	f456                	sd	s5,40(sp)
    80003ae2:	1080                	addi	s0,sp,96
    80003ae4:	84aa                	mv	s1,a0
    80003ae6:	892e                	mv	s2,a1
    80003ae8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003aea:	aecfd0ef          	jal	80000dd6 <myproc>
    80003aee:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003af0:	8526                	mv	a0,s1
    80003af2:	717010ef          	jal	80005a08 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003af6:	2184a703          	lw	a4,536(s1)
    80003afa:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003afe:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b02:	02f71763          	bne	a4,a5,80003b30 <piperead+0x5e>
    80003b06:	2244a783          	lw	a5,548(s1)
    80003b0a:	cf85                	beqz	a5,80003b42 <piperead+0x70>
    if(killed(pr)){
    80003b0c:	8552                	mv	a0,s4
    80003b0e:	b79fd0ef          	jal	80001686 <killed>
    80003b12:	e11d                	bnez	a0,80003b38 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b14:	85a6                	mv	a1,s1
    80003b16:	854e                	mv	a0,s3
    80003b18:	933fd0ef          	jal	8000144a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b1c:	2184a703          	lw	a4,536(s1)
    80003b20:	21c4a783          	lw	a5,540(s1)
    80003b24:	fef701e3          	beq	a4,a5,80003b06 <piperead+0x34>
    80003b28:	f05a                	sd	s6,32(sp)
    80003b2a:	ec5e                	sd	s7,24(sp)
    80003b2c:	e862                	sd	s8,16(sp)
    80003b2e:	a829                	j	80003b48 <piperead+0x76>
    80003b30:	f05a                	sd	s6,32(sp)
    80003b32:	ec5e                	sd	s7,24(sp)
    80003b34:	e862                	sd	s8,16(sp)
    80003b36:	a809                	j	80003b48 <piperead+0x76>
      release(&pi->lock);
    80003b38:	8526                	mv	a0,s1
    80003b3a:	763010ef          	jal	80005a9c <release>
      return -1;
    80003b3e:	59fd                	li	s3,-1
    80003b40:	a09d                	j	80003ba6 <piperead+0xd4>
    80003b42:	f05a                	sd	s6,32(sp)
    80003b44:	ec5e                	sd	s7,24(sp)
    80003b46:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b48:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b4a:	faf40c13          	addi	s8,s0,-81
    80003b4e:	4b85                	li	s7,1
    80003b50:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b52:	05505063          	blez	s5,80003b92 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003b56:	2184a783          	lw	a5,536(s1)
    80003b5a:	21c4a703          	lw	a4,540(s1)
    80003b5e:	02f70a63          	beq	a4,a5,80003b92 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003b62:	0017871b          	addiw	a4,a5,1
    80003b66:	20e4ac23          	sw	a4,536(s1)
    80003b6a:	1ff7f793          	andi	a5,a5,511
    80003b6e:	97a6                	add	a5,a5,s1
    80003b70:	0187c783          	lbu	a5,24(a5)
    80003b74:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b78:	86de                	mv	a3,s7
    80003b7a:	8662                	mv	a2,s8
    80003b7c:	85ca                	mv	a1,s2
    80003b7e:	050a3503          	ld	a0,80(s4)
    80003b82:	f73fc0ef          	jal	80000af4 <copyout>
    80003b86:	01650663          	beq	a0,s6,80003b92 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b8a:	2985                	addiw	s3,s3,1
    80003b8c:	0905                	addi	s2,s2,1
    80003b8e:	fd3a94e3          	bne	s5,s3,80003b56 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003b92:	21c48513          	addi	a0,s1,540
    80003b96:	901fd0ef          	jal	80001496 <wakeup>
  release(&pi->lock);
    80003b9a:	8526                	mv	a0,s1
    80003b9c:	701010ef          	jal	80005a9c <release>
    80003ba0:	7b02                	ld	s6,32(sp)
    80003ba2:	6be2                	ld	s7,24(sp)
    80003ba4:	6c42                	ld	s8,16(sp)
  return i;
}
    80003ba6:	854e                	mv	a0,s3
    80003ba8:	60e6                	ld	ra,88(sp)
    80003baa:	6446                	ld	s0,80(sp)
    80003bac:	64a6                	ld	s1,72(sp)
    80003bae:	6906                	ld	s2,64(sp)
    80003bb0:	79e2                	ld	s3,56(sp)
    80003bb2:	7a42                	ld	s4,48(sp)
    80003bb4:	7aa2                	ld	s5,40(sp)
    80003bb6:	6125                	addi	sp,sp,96
    80003bb8:	8082                	ret

0000000080003bba <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003bba:	1141                	addi	sp,sp,-16
    80003bbc:	e406                	sd	ra,8(sp)
    80003bbe:	e022                	sd	s0,0(sp)
    80003bc0:	0800                	addi	s0,sp,16
    80003bc2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003bc4:	0035151b          	slliw	a0,a0,0x3
    80003bc8:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003bca:	8b89                	andi	a5,a5,2
    80003bcc:	c399                	beqz	a5,80003bd2 <flags2perm+0x18>
      perm |= PTE_W;
    80003bce:	00456513          	ori	a0,a0,4
    return perm;
}
    80003bd2:	60a2                	ld	ra,8(sp)
    80003bd4:	6402                	ld	s0,0(sp)
    80003bd6:	0141                	addi	sp,sp,16
    80003bd8:	8082                	ret

0000000080003bda <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003bda:	de010113          	addi	sp,sp,-544
    80003bde:	20113c23          	sd	ra,536(sp)
    80003be2:	20813823          	sd	s0,528(sp)
    80003be6:	20913423          	sd	s1,520(sp)
    80003bea:	21213023          	sd	s2,512(sp)
    80003bee:	1400                	addi	s0,sp,544
    80003bf0:	892a                	mv	s2,a0
    80003bf2:	dea43823          	sd	a0,-528(s0)
    80003bf6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003bfa:	9dcfd0ef          	jal	80000dd6 <myproc>
    80003bfe:	84aa                	mv	s1,a0

  begin_op();
    80003c00:	d74ff0ef          	jal	80003174 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003c04:	854a                	mv	a0,s2
    80003c06:	b90ff0ef          	jal	80002f96 <namei>
    80003c0a:	cd21                	beqz	a0,80003c62 <kexec+0x88>
    80003c0c:	fbd2                	sd	s4,496(sp)
    80003c0e:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003c10:	b59fe0ef          	jal	80002768 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003c14:	04000713          	li	a4,64
    80003c18:	4681                	li	a3,0
    80003c1a:	e5040613          	addi	a2,s0,-432
    80003c1e:	4581                	li	a1,0
    80003c20:	8552                	mv	a0,s4
    80003c22:	ed9fe0ef          	jal	80002afa <readi>
    80003c26:	04000793          	li	a5,64
    80003c2a:	00f51a63          	bne	a0,a5,80003c3e <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003c2e:	e5042703          	lw	a4,-432(s0)
    80003c32:	464c47b7          	lui	a5,0x464c4
    80003c36:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003c3a:	02f70863          	beq	a4,a5,80003c6a <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003c3e:	8552                	mv	a0,s4
    80003c40:	d35fe0ef          	jal	80002974 <iunlockput>
    end_op();
    80003c44:	da0ff0ef          	jal	800031e4 <end_op>
  }
  return -1;
    80003c48:	557d                	li	a0,-1
    80003c4a:	7a5e                	ld	s4,496(sp)
}
    80003c4c:	21813083          	ld	ra,536(sp)
    80003c50:	21013403          	ld	s0,528(sp)
    80003c54:	20813483          	ld	s1,520(sp)
    80003c58:	20013903          	ld	s2,512(sp)
    80003c5c:	22010113          	addi	sp,sp,544
    80003c60:	8082                	ret
    end_op();
    80003c62:	d82ff0ef          	jal	800031e4 <end_op>
    return -1;
    80003c66:	557d                	li	a0,-1
    80003c68:	b7d5                	j	80003c4c <kexec+0x72>
    80003c6a:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003c6c:	8526                	mv	a0,s1
    80003c6e:	a72fd0ef          	jal	80000ee0 <proc_pagetable>
    80003c72:	8b2a                	mv	s6,a0
    80003c74:	26050f63          	beqz	a0,80003ef2 <kexec+0x318>
    80003c78:	ffce                	sd	s3,504(sp)
    80003c7a:	f7d6                	sd	s5,488(sp)
    80003c7c:	efde                	sd	s7,472(sp)
    80003c7e:	ebe2                	sd	s8,464(sp)
    80003c80:	e7e6                	sd	s9,456(sp)
    80003c82:	e3ea                	sd	s10,448(sp)
    80003c84:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c86:	e8845783          	lhu	a5,-376(s0)
    80003c8a:	0e078963          	beqz	a5,80003d7c <kexec+0x1a2>
    80003c8e:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c92:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c94:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c96:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003c9a:	6c85                	lui	s9,0x1
    80003c9c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003ca0:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003ca4:	6a85                	lui	s5,0x1
    80003ca6:	a085                	j	80003d06 <kexec+0x12c>
      panic("loadseg: address should exist");
    80003ca8:	00004517          	auipc	a0,0x4
    80003cac:	8b050513          	addi	a0,a0,-1872 # 80007558 <etext+0x558>
    80003cb0:	297010ef          	jal	80005746 <panic>
    if(sz - i < PGSIZE)
    80003cb4:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003cb6:	874a                	mv	a4,s2
    80003cb8:	009b86bb          	addw	a3,s7,s1
    80003cbc:	4581                	li	a1,0
    80003cbe:	8552                	mv	a0,s4
    80003cc0:	e3bfe0ef          	jal	80002afa <readi>
    80003cc4:	22a91b63          	bne	s2,a0,80003efa <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80003cc8:	009a84bb          	addw	s1,s5,s1
    80003ccc:	0334f263          	bgeu	s1,s3,80003cf0 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003cd0:	02049593          	slli	a1,s1,0x20
    80003cd4:	9181                	srli	a1,a1,0x20
    80003cd6:	95e2                	add	a1,a1,s8
    80003cd8:	855a                	mv	a0,s6
    80003cda:	fc0fc0ef          	jal	8000049a <walkaddr>
    80003cde:	862a                	mv	a2,a0
    if(pa == 0)
    80003ce0:	d561                	beqz	a0,80003ca8 <kexec+0xce>
    if(sz - i < PGSIZE)
    80003ce2:	409987bb          	subw	a5,s3,s1
    80003ce6:	893e                	mv	s2,a5
    80003ce8:	fcfcf6e3          	bgeu	s9,a5,80003cb4 <kexec+0xda>
    80003cec:	8956                	mv	s2,s5
    80003cee:	b7d9                	j	80003cb4 <kexec+0xda>
    sz = sz1;
    80003cf0:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cf4:	2d05                	addiw	s10,s10,1
    80003cf6:	e0843783          	ld	a5,-504(s0)
    80003cfa:	0387869b          	addiw	a3,a5,56
    80003cfe:	e8845783          	lhu	a5,-376(s0)
    80003d02:	06fd5e63          	bge	s10,a5,80003d7e <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d06:	e0d43423          	sd	a3,-504(s0)
    80003d0a:	876e                	mv	a4,s11
    80003d0c:	e1840613          	addi	a2,s0,-488
    80003d10:	4581                	li	a1,0
    80003d12:	8552                	mv	a0,s4
    80003d14:	de7fe0ef          	jal	80002afa <readi>
    80003d18:	1db51f63          	bne	a0,s11,80003ef6 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80003d1c:	e1842783          	lw	a5,-488(s0)
    80003d20:	4705                	li	a4,1
    80003d22:	fce799e3          	bne	a5,a4,80003cf4 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003d26:	e4043483          	ld	s1,-448(s0)
    80003d2a:	e3843783          	ld	a5,-456(s0)
    80003d2e:	1ef4e463          	bltu	s1,a5,80003f16 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d32:	e2843783          	ld	a5,-472(s0)
    80003d36:	94be                	add	s1,s1,a5
    80003d38:	1ef4e263          	bltu	s1,a5,80003f1c <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80003d3c:	de843703          	ld	a4,-536(s0)
    80003d40:	8ff9                	and	a5,a5,a4
    80003d42:	1e079063          	bnez	a5,80003f22 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d46:	e1c42503          	lw	a0,-484(s0)
    80003d4a:	e71ff0ef          	jal	80003bba <flags2perm>
    80003d4e:	86aa                	mv	a3,a0
    80003d50:	8626                	mv	a2,s1
    80003d52:	85ca                	mv	a1,s2
    80003d54:	855a                	mv	a0,s6
    80003d56:	a47fc0ef          	jal	8000079c <uvmalloc>
    80003d5a:	dea43c23          	sd	a0,-520(s0)
    80003d5e:	1c050563          	beqz	a0,80003f28 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d62:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d66:	00098863          	beqz	s3,80003d76 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d6a:	e2843c03          	ld	s8,-472(s0)
    80003d6e:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d72:	4481                	li	s1,0
    80003d74:	bfb1                	j	80003cd0 <kexec+0xf6>
    sz = sz1;
    80003d76:	df843903          	ld	s2,-520(s0)
    80003d7a:	bfad                	j	80003cf4 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d7c:	4901                	li	s2,0
  iunlockput(ip);
    80003d7e:	8552                	mv	a0,s4
    80003d80:	bf5fe0ef          	jal	80002974 <iunlockput>
  end_op();
    80003d84:	c60ff0ef          	jal	800031e4 <end_op>
  p = myproc();
    80003d88:	84efd0ef          	jal	80000dd6 <myproc>
    80003d8c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003d8e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003d92:	6985                	lui	s3,0x1
    80003d94:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003d96:	99ca                	add	s3,s3,s2
    80003d98:	77fd                	lui	a5,0xfffff
    80003d9a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003d9e:	4691                	li	a3,4
    80003da0:	6609                	lui	a2,0x2
    80003da2:	964e                	add	a2,a2,s3
    80003da4:	85ce                	mv	a1,s3
    80003da6:	855a                	mv	a0,s6
    80003da8:	9f5fc0ef          	jal	8000079c <uvmalloc>
    80003dac:	8a2a                	mv	s4,a0
    80003dae:	e105                	bnez	a0,80003dce <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003db0:	85ce                	mv	a1,s3
    80003db2:	855a                	mv	a0,s6
    80003db4:	9e8fd0ef          	jal	80000f9c <proc_freepagetable>
  return -1;
    80003db8:	557d                	li	a0,-1
    80003dba:	79fe                	ld	s3,504(sp)
    80003dbc:	7a5e                	ld	s4,496(sp)
    80003dbe:	7abe                	ld	s5,488(sp)
    80003dc0:	7b1e                	ld	s6,480(sp)
    80003dc2:	6bfe                	ld	s7,472(sp)
    80003dc4:	6c5e                	ld	s8,464(sp)
    80003dc6:	6cbe                	ld	s9,456(sp)
    80003dc8:	6d1e                	ld	s10,448(sp)
    80003dca:	7dfa                	ld	s11,440(sp)
    80003dcc:	b541                	j	80003c4c <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003dce:	75f9                	lui	a1,0xffffe
    80003dd0:	95aa                	add	a1,a1,a0
    80003dd2:	855a                	mv	a0,s6
    80003dd4:	b9bfc0ef          	jal	8000096e <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003dd8:	800a0b93          	addi	s7,s4,-2048
    80003ddc:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80003de0:	e0043783          	ld	a5,-512(s0)
    80003de4:	6388                	ld	a0,0(a5)
  sp = sz;
    80003de6:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003de8:	4481                	li	s1,0
    ustack[argc] = sp;
    80003dea:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003dee:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003df2:	cd21                	beqz	a0,80003e4a <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80003df4:	cf4fc0ef          	jal	800002e8 <strlen>
    80003df8:	0015079b          	addiw	a5,a0,1
    80003dfc:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e00:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003e04:	13796563          	bltu	s2,s7,80003f2e <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003e08:	e0043d83          	ld	s11,-512(s0)
    80003e0c:	000db983          	ld	s3,0(s11)
    80003e10:	854e                	mv	a0,s3
    80003e12:	cd6fc0ef          	jal	800002e8 <strlen>
    80003e16:	0015069b          	addiw	a3,a0,1
    80003e1a:	864e                	mv	a2,s3
    80003e1c:	85ca                	mv	a1,s2
    80003e1e:	855a                	mv	a0,s6
    80003e20:	cd5fc0ef          	jal	80000af4 <copyout>
    80003e24:	10054763          	bltz	a0,80003f32 <kexec+0x358>
    ustack[argc] = sp;
    80003e28:	00349793          	slli	a5,s1,0x3
    80003e2c:	97e6                	add	a5,a5,s9
    80003e2e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdc018>
  for(argc = 0; argv[argc]; argc++) {
    80003e32:	0485                	addi	s1,s1,1
    80003e34:	008d8793          	addi	a5,s11,8
    80003e38:	e0f43023          	sd	a5,-512(s0)
    80003e3c:	008db503          	ld	a0,8(s11)
    80003e40:	c509                	beqz	a0,80003e4a <kexec+0x270>
    if(argc >= MAXARG)
    80003e42:	fb8499e3          	bne	s1,s8,80003df4 <kexec+0x21a>
  sz = sz1;
    80003e46:	89d2                	mv	s3,s4
    80003e48:	b7a5                	j	80003db0 <kexec+0x1d6>
  ustack[argc] = 0;
    80003e4a:	00349793          	slli	a5,s1,0x3
    80003e4e:	f9078793          	addi	a5,a5,-112
    80003e52:	97a2                	add	a5,a5,s0
    80003e54:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e58:	00349693          	slli	a3,s1,0x3
    80003e5c:	06a1                	addi	a3,a3,8
    80003e5e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e62:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e66:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003e68:	f57964e3          	bltu	s2,s7,80003db0 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e6c:	e9040613          	addi	a2,s0,-368
    80003e70:	85ca                	mv	a1,s2
    80003e72:	855a                	mv	a0,s6
    80003e74:	c81fc0ef          	jal	80000af4 <copyout>
    80003e78:	f2054ce3          	bltz	a0,80003db0 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80003e7c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003e80:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003e84:	df043783          	ld	a5,-528(s0)
    80003e88:	0007c703          	lbu	a4,0(a5)
    80003e8c:	cf11                	beqz	a4,80003ea8 <kexec+0x2ce>
    80003e8e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003e90:	02f00693          	li	a3,47
    80003e94:	a029                	j	80003e9e <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80003e96:	0785                	addi	a5,a5,1
    80003e98:	fff7c703          	lbu	a4,-1(a5)
    80003e9c:	c711                	beqz	a4,80003ea8 <kexec+0x2ce>
    if(*s == '/')
    80003e9e:	fed71ce3          	bne	a4,a3,80003e96 <kexec+0x2bc>
      last = s+1;
    80003ea2:	def43823          	sd	a5,-528(s0)
    80003ea6:	bfc5                	j	80003e96 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80003ea8:	4641                	li	a2,16
    80003eaa:	df043583          	ld	a1,-528(s0)
    80003eae:	160a8513          	addi	a0,s5,352
    80003eb2:	c00fc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003eb6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003eba:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003ebe:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80003ec2:	058ab783          	ld	a5,88(s5)
    80003ec6:	e6843703          	ld	a4,-408(s0)
    80003eca:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003ecc:	058ab783          	ld	a5,88(s5)
    80003ed0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003ed4:	85ea                	mv	a1,s10
    80003ed6:	8c6fd0ef          	jal	80000f9c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003eda:	0004851b          	sext.w	a0,s1
    80003ede:	79fe                	ld	s3,504(sp)
    80003ee0:	7a5e                	ld	s4,496(sp)
    80003ee2:	7abe                	ld	s5,488(sp)
    80003ee4:	7b1e                	ld	s6,480(sp)
    80003ee6:	6bfe                	ld	s7,472(sp)
    80003ee8:	6c5e                	ld	s8,464(sp)
    80003eea:	6cbe                	ld	s9,456(sp)
    80003eec:	6d1e                	ld	s10,448(sp)
    80003eee:	7dfa                	ld	s11,440(sp)
    80003ef0:	bbb1                	j	80003c4c <kexec+0x72>
    80003ef2:	7b1e                	ld	s6,480(sp)
    80003ef4:	b3a9                	j	80003c3e <kexec+0x64>
    80003ef6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003efa:	df843583          	ld	a1,-520(s0)
    80003efe:	855a                	mv	a0,s6
    80003f00:	89cfd0ef          	jal	80000f9c <proc_freepagetable>
  if(ip){
    80003f04:	79fe                	ld	s3,504(sp)
    80003f06:	7abe                	ld	s5,488(sp)
    80003f08:	7b1e                	ld	s6,480(sp)
    80003f0a:	6bfe                	ld	s7,472(sp)
    80003f0c:	6c5e                	ld	s8,464(sp)
    80003f0e:	6cbe                	ld	s9,456(sp)
    80003f10:	6d1e                	ld	s10,448(sp)
    80003f12:	7dfa                	ld	s11,440(sp)
    80003f14:	b32d                	j	80003c3e <kexec+0x64>
    80003f16:	df243c23          	sd	s2,-520(s0)
    80003f1a:	b7c5                	j	80003efa <kexec+0x320>
    80003f1c:	df243c23          	sd	s2,-520(s0)
    80003f20:	bfe9                	j	80003efa <kexec+0x320>
    80003f22:	df243c23          	sd	s2,-520(s0)
    80003f26:	bfd1                	j	80003efa <kexec+0x320>
    80003f28:	df243c23          	sd	s2,-520(s0)
    80003f2c:	b7f9                	j	80003efa <kexec+0x320>
  sz = sz1;
    80003f2e:	89d2                	mv	s3,s4
    80003f30:	b541                	j	80003db0 <kexec+0x1d6>
    80003f32:	89d2                	mv	s3,s4
    80003f34:	bdb5                	j	80003db0 <kexec+0x1d6>

0000000080003f36 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f36:	7179                	addi	sp,sp,-48
    80003f38:	f406                	sd	ra,40(sp)
    80003f3a:	f022                	sd	s0,32(sp)
    80003f3c:	ec26                	sd	s1,24(sp)
    80003f3e:	e84a                	sd	s2,16(sp)
    80003f40:	1800                	addi	s0,sp,48
    80003f42:	892e                	mv	s2,a1
    80003f44:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f46:	fdc40593          	addi	a1,s0,-36
    80003f4a:	e0dfd0ef          	jal	80001d56 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f4e:	fdc42703          	lw	a4,-36(s0)
    80003f52:	47bd                	li	a5,15
    80003f54:	02e7ea63          	bltu	a5,a4,80003f88 <argfd+0x52>
    80003f58:	e7ffc0ef          	jal	80000dd6 <myproc>
    80003f5c:	fdc42703          	lw	a4,-36(s0)
    80003f60:	00371793          	slli	a5,a4,0x3
    80003f64:	0d078793          	addi	a5,a5,208
    80003f68:	953e                	add	a0,a0,a5
    80003f6a:	651c                	ld	a5,8(a0)
    80003f6c:	c385                	beqz	a5,80003f8c <argfd+0x56>
    return -1;
  if(pfd)
    80003f6e:	00090463          	beqz	s2,80003f76 <argfd+0x40>
    *pfd = fd;
    80003f72:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003f76:	4501                	li	a0,0
  if(pf)
    80003f78:	c091                	beqz	s1,80003f7c <argfd+0x46>
    *pf = f;
    80003f7a:	e09c                	sd	a5,0(s1)
}
    80003f7c:	70a2                	ld	ra,40(sp)
    80003f7e:	7402                	ld	s0,32(sp)
    80003f80:	64e2                	ld	s1,24(sp)
    80003f82:	6942                	ld	s2,16(sp)
    80003f84:	6145                	addi	sp,sp,48
    80003f86:	8082                	ret
    return -1;
    80003f88:	557d                	li	a0,-1
    80003f8a:	bfcd                	j	80003f7c <argfd+0x46>
    80003f8c:	557d                	li	a0,-1
    80003f8e:	b7fd                	j	80003f7c <argfd+0x46>

0000000080003f90 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003f90:	1101                	addi	sp,sp,-32
    80003f92:	ec06                	sd	ra,24(sp)
    80003f94:	e822                	sd	s0,16(sp)
    80003f96:	e426                	sd	s1,8(sp)
    80003f98:	1000                	addi	s0,sp,32
    80003f9a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003f9c:	e3bfc0ef          	jal	80000dd6 <myproc>
    80003fa0:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003fa2:	0d850793          	addi	a5,a0,216
    80003fa6:	4501                	li	a0,0
    80003fa8:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003faa:	6398                	ld	a4,0(a5)
    80003fac:	cb19                	beqz	a4,80003fc2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003fae:	2505                	addiw	a0,a0,1
    80003fb0:	07a1                	addi	a5,a5,8
    80003fb2:	fed51ce3          	bne	a0,a3,80003faa <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003fb6:	557d                	li	a0,-1
}
    80003fb8:	60e2                	ld	ra,24(sp)
    80003fba:	6442                	ld	s0,16(sp)
    80003fbc:	64a2                	ld	s1,8(sp)
    80003fbe:	6105                	addi	sp,sp,32
    80003fc0:	8082                	ret
      p->ofile[fd] = f;
    80003fc2:	00351793          	slli	a5,a0,0x3
    80003fc6:	0d078793          	addi	a5,a5,208
    80003fca:	963e                	add	a2,a2,a5
    80003fcc:	e604                	sd	s1,8(a2)
      return fd;
    80003fce:	b7ed                	j	80003fb8 <fdalloc+0x28>

0000000080003fd0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003fd0:	715d                	addi	sp,sp,-80
    80003fd2:	e486                	sd	ra,72(sp)
    80003fd4:	e0a2                	sd	s0,64(sp)
    80003fd6:	fc26                	sd	s1,56(sp)
    80003fd8:	f84a                	sd	s2,48(sp)
    80003fda:	f44e                	sd	s3,40(sp)
    80003fdc:	f052                	sd	s4,32(sp)
    80003fde:	ec56                	sd	s5,24(sp)
    80003fe0:	e85a                	sd	s6,16(sp)
    80003fe2:	0880                	addi	s0,sp,80
    80003fe4:	892e                	mv	s2,a1
    80003fe6:	8a2e                	mv	s4,a1
    80003fe8:	8ab2                	mv	s5,a2
    80003fea:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003fec:	fb040593          	addi	a1,s0,-80
    80003ff0:	fc1fe0ef          	jal	80002fb0 <nameiparent>
    80003ff4:	84aa                	mv	s1,a0
    80003ff6:	10050763          	beqz	a0,80004104 <create+0x134>
    return 0;

  ilock(dp);
    80003ffa:	f6efe0ef          	jal	80002768 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003ffe:	4601                	li	a2,0
    80004000:	fb040593          	addi	a1,s0,-80
    80004004:	8526                	mv	a0,s1
    80004006:	cfdfe0ef          	jal	80002d02 <dirlookup>
    8000400a:	89aa                	mv	s3,a0
    8000400c:	c131                	beqz	a0,80004050 <create+0x80>
    iunlockput(dp);
    8000400e:	8526                	mv	a0,s1
    80004010:	965fe0ef          	jal	80002974 <iunlockput>
    ilock(ip);
    80004014:	854e                	mv	a0,s3
    80004016:	f52fe0ef          	jal	80002768 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000401a:	4789                	li	a5,2
    8000401c:	02f91563          	bne	s2,a5,80004046 <create+0x76>
    80004020:	0449d783          	lhu	a5,68(s3)
    80004024:	37f9                	addiw	a5,a5,-2
    80004026:	17c2                	slli	a5,a5,0x30
    80004028:	93c1                	srli	a5,a5,0x30
    8000402a:	4705                	li	a4,1
    8000402c:	00f76d63          	bltu	a4,a5,80004046 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004030:	854e                	mv	a0,s3
    80004032:	60a6                	ld	ra,72(sp)
    80004034:	6406                	ld	s0,64(sp)
    80004036:	74e2                	ld	s1,56(sp)
    80004038:	7942                	ld	s2,48(sp)
    8000403a:	79a2                	ld	s3,40(sp)
    8000403c:	7a02                	ld	s4,32(sp)
    8000403e:	6ae2                	ld	s5,24(sp)
    80004040:	6b42                	ld	s6,16(sp)
    80004042:	6161                	addi	sp,sp,80
    80004044:	8082                	ret
    iunlockput(ip);
    80004046:	854e                	mv	a0,s3
    80004048:	92dfe0ef          	jal	80002974 <iunlockput>
    return 0;
    8000404c:	4981                	li	s3,0
    8000404e:	b7cd                	j	80004030 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004050:	85ca                	mv	a1,s2
    80004052:	4088                	lw	a0,0(s1)
    80004054:	da4fe0ef          	jal	800025f8 <ialloc>
    80004058:	892a                	mv	s2,a0
    8000405a:	cd15                	beqz	a0,80004096 <create+0xc6>
  ilock(ip);
    8000405c:	f0cfe0ef          	jal	80002768 <ilock>
  ip->major = major;
    80004060:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004064:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004068:	4785                	li	a5,1
    8000406a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000406e:	854a                	mv	a0,s2
    80004070:	e44fe0ef          	jal	800026b4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004074:	4705                	li	a4,1
    80004076:	02ea0463          	beq	s4,a4,8000409e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8000407a:	00492603          	lw	a2,4(s2)
    8000407e:	fb040593          	addi	a1,s0,-80
    80004082:	8526                	mv	a0,s1
    80004084:	e69fe0ef          	jal	80002eec <dirlink>
    80004088:	06054263          	bltz	a0,800040ec <create+0x11c>
  iunlockput(dp);
    8000408c:	8526                	mv	a0,s1
    8000408e:	8e7fe0ef          	jal	80002974 <iunlockput>
  return ip;
    80004092:	89ca                	mv	s3,s2
    80004094:	bf71                	j	80004030 <create+0x60>
    iunlockput(dp);
    80004096:	8526                	mv	a0,s1
    80004098:	8ddfe0ef          	jal	80002974 <iunlockput>
    return 0;
    8000409c:	bf51                	j	80004030 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000409e:	00492603          	lw	a2,4(s2)
    800040a2:	00003597          	auipc	a1,0x3
    800040a6:	4d658593          	addi	a1,a1,1238 # 80007578 <etext+0x578>
    800040aa:	854a                	mv	a0,s2
    800040ac:	e41fe0ef          	jal	80002eec <dirlink>
    800040b0:	02054e63          	bltz	a0,800040ec <create+0x11c>
    800040b4:	40d0                	lw	a2,4(s1)
    800040b6:	00003597          	auipc	a1,0x3
    800040ba:	4ca58593          	addi	a1,a1,1226 # 80007580 <etext+0x580>
    800040be:	854a                	mv	a0,s2
    800040c0:	e2dfe0ef          	jal	80002eec <dirlink>
    800040c4:	02054463          	bltz	a0,800040ec <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800040c8:	00492603          	lw	a2,4(s2)
    800040cc:	fb040593          	addi	a1,s0,-80
    800040d0:	8526                	mv	a0,s1
    800040d2:	e1bfe0ef          	jal	80002eec <dirlink>
    800040d6:	00054b63          	bltz	a0,800040ec <create+0x11c>
    dp->nlink++;  // for ".."
    800040da:	04a4d783          	lhu	a5,74(s1)
    800040de:	2785                	addiw	a5,a5,1
    800040e0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800040e4:	8526                	mv	a0,s1
    800040e6:	dcefe0ef          	jal	800026b4 <iupdate>
    800040ea:	b74d                	j	8000408c <create+0xbc>
  ip->nlink = 0;
    800040ec:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    800040f0:	854a                	mv	a0,s2
    800040f2:	dc2fe0ef          	jal	800026b4 <iupdate>
  iunlockput(ip);
    800040f6:	854a                	mv	a0,s2
    800040f8:	87dfe0ef          	jal	80002974 <iunlockput>
  iunlockput(dp);
    800040fc:	8526                	mv	a0,s1
    800040fe:	877fe0ef          	jal	80002974 <iunlockput>
  return 0;
    80004102:	b73d                	j	80004030 <create+0x60>
    return 0;
    80004104:	89aa                	mv	s3,a0
    80004106:	b72d                	j	80004030 <create+0x60>

0000000080004108 <sys_dup>:
{
    80004108:	7179                	addi	sp,sp,-48
    8000410a:	f406                	sd	ra,40(sp)
    8000410c:	f022                	sd	s0,32(sp)
    8000410e:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004110:	fd840613          	addi	a2,s0,-40
    80004114:	4581                	li	a1,0
    80004116:	4501                	li	a0,0
    80004118:	e1fff0ef          	jal	80003f36 <argfd>
    return -1;
    8000411c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000411e:	02054363          	bltz	a0,80004144 <sys_dup+0x3c>
    80004122:	ec26                	sd	s1,24(sp)
    80004124:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004126:	fd843483          	ld	s1,-40(s0)
    8000412a:	8526                	mv	a0,s1
    8000412c:	e65ff0ef          	jal	80003f90 <fdalloc>
    80004130:	892a                	mv	s2,a0
    return -1;
    80004132:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004134:	00054d63          	bltz	a0,8000414e <sys_dup+0x46>
  filedup(f);
    80004138:	8526                	mv	a0,s1
    8000413a:	c18ff0ef          	jal	80003552 <filedup>
  return fd;
    8000413e:	87ca                	mv	a5,s2
    80004140:	64e2                	ld	s1,24(sp)
    80004142:	6942                	ld	s2,16(sp)
}
    80004144:	853e                	mv	a0,a5
    80004146:	70a2                	ld	ra,40(sp)
    80004148:	7402                	ld	s0,32(sp)
    8000414a:	6145                	addi	sp,sp,48
    8000414c:	8082                	ret
    8000414e:	64e2                	ld	s1,24(sp)
    80004150:	6942                	ld	s2,16(sp)
    80004152:	bfcd                	j	80004144 <sys_dup+0x3c>

0000000080004154 <sys_read>:
{
    80004154:	7179                	addi	sp,sp,-48
    80004156:	f406                	sd	ra,40(sp)
    80004158:	f022                	sd	s0,32(sp)
    8000415a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000415c:	fd840593          	addi	a1,s0,-40
    80004160:	4505                	li	a0,1
    80004162:	c11fd0ef          	jal	80001d72 <argaddr>
  argint(2, &n);
    80004166:	fe440593          	addi	a1,s0,-28
    8000416a:	4509                	li	a0,2
    8000416c:	bebfd0ef          	jal	80001d56 <argint>
  if(argfd(0, 0, &f) < 0)
    80004170:	fe840613          	addi	a2,s0,-24
    80004174:	4581                	li	a1,0
    80004176:	4501                	li	a0,0
    80004178:	dbfff0ef          	jal	80003f36 <argfd>
    8000417c:	87aa                	mv	a5,a0
    return -1;
    8000417e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004180:	0007ca63          	bltz	a5,80004194 <sys_read+0x40>
  return fileread(f, p, n);
    80004184:	fe442603          	lw	a2,-28(s0)
    80004188:	fd843583          	ld	a1,-40(s0)
    8000418c:	fe843503          	ld	a0,-24(s0)
    80004190:	d2cff0ef          	jal	800036bc <fileread>
}
    80004194:	70a2                	ld	ra,40(sp)
    80004196:	7402                	ld	s0,32(sp)
    80004198:	6145                	addi	sp,sp,48
    8000419a:	8082                	ret

000000008000419c <sys_write>:
{
    8000419c:	7179                	addi	sp,sp,-48
    8000419e:	f406                	sd	ra,40(sp)
    800041a0:	f022                	sd	s0,32(sp)
    800041a2:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041a4:	fd840593          	addi	a1,s0,-40
    800041a8:	4505                	li	a0,1
    800041aa:	bc9fd0ef          	jal	80001d72 <argaddr>
  argint(2, &n);
    800041ae:	fe440593          	addi	a1,s0,-28
    800041b2:	4509                	li	a0,2
    800041b4:	ba3fd0ef          	jal	80001d56 <argint>
  if(argfd(0, 0, &f) < 0)
    800041b8:	fe840613          	addi	a2,s0,-24
    800041bc:	4581                	li	a1,0
    800041be:	4501                	li	a0,0
    800041c0:	d77ff0ef          	jal	80003f36 <argfd>
    800041c4:	87aa                	mv	a5,a0
    return -1;
    800041c6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041c8:	0007ca63          	bltz	a5,800041dc <sys_write+0x40>
  return filewrite(f, p, n);
    800041cc:	fe442603          	lw	a2,-28(s0)
    800041d0:	fd843583          	ld	a1,-40(s0)
    800041d4:	fe843503          	ld	a0,-24(s0)
    800041d8:	da8ff0ef          	jal	80003780 <filewrite>
}
    800041dc:	70a2                	ld	ra,40(sp)
    800041de:	7402                	ld	s0,32(sp)
    800041e0:	6145                	addi	sp,sp,48
    800041e2:	8082                	ret

00000000800041e4 <sys_close>:
{
    800041e4:	1101                	addi	sp,sp,-32
    800041e6:	ec06                	sd	ra,24(sp)
    800041e8:	e822                	sd	s0,16(sp)
    800041ea:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800041ec:	fe040613          	addi	a2,s0,-32
    800041f0:	fec40593          	addi	a1,s0,-20
    800041f4:	4501                	li	a0,0
    800041f6:	d41ff0ef          	jal	80003f36 <argfd>
    return -1;
    800041fa:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800041fc:	02054163          	bltz	a0,8000421e <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004200:	bd7fc0ef          	jal	80000dd6 <myproc>
    80004204:	fec42783          	lw	a5,-20(s0)
    80004208:	078e                	slli	a5,a5,0x3
    8000420a:	0d078793          	addi	a5,a5,208
    8000420e:	953e                	add	a0,a0,a5
    80004210:	00053423          	sd	zero,8(a0)
  fileclose(f);
    80004214:	fe043503          	ld	a0,-32(s0)
    80004218:	b80ff0ef          	jal	80003598 <fileclose>
  return 0;
    8000421c:	4781                	li	a5,0
}
    8000421e:	853e                	mv	a0,a5
    80004220:	60e2                	ld	ra,24(sp)
    80004222:	6442                	ld	s0,16(sp)
    80004224:	6105                	addi	sp,sp,32
    80004226:	8082                	ret

0000000080004228 <sys_fstat>:
{
    80004228:	1101                	addi	sp,sp,-32
    8000422a:	ec06                	sd	ra,24(sp)
    8000422c:	e822                	sd	s0,16(sp)
    8000422e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004230:	fe040593          	addi	a1,s0,-32
    80004234:	4505                	li	a0,1
    80004236:	b3dfd0ef          	jal	80001d72 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000423a:	fe840613          	addi	a2,s0,-24
    8000423e:	4581                	li	a1,0
    80004240:	4501                	li	a0,0
    80004242:	cf5ff0ef          	jal	80003f36 <argfd>
    80004246:	87aa                	mv	a5,a0
    return -1;
    80004248:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000424a:	0007c863          	bltz	a5,8000425a <sys_fstat+0x32>
  return filestat(f, st);
    8000424e:	fe043583          	ld	a1,-32(s0)
    80004252:	fe843503          	ld	a0,-24(s0)
    80004256:	c04ff0ef          	jal	8000365a <filestat>
}
    8000425a:	60e2                	ld	ra,24(sp)
    8000425c:	6442                	ld	s0,16(sp)
    8000425e:	6105                	addi	sp,sp,32
    80004260:	8082                	ret

0000000080004262 <sys_link>:
{
    80004262:	7169                	addi	sp,sp,-304
    80004264:	f606                	sd	ra,296(sp)
    80004266:	f222                	sd	s0,288(sp)
    80004268:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000426a:	08000613          	li	a2,128
    8000426e:	ed040593          	addi	a1,s0,-304
    80004272:	4501                	li	a0,0
    80004274:	b1bfd0ef          	jal	80001d8e <argstr>
    return -1;
    80004278:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000427a:	0c054e63          	bltz	a0,80004356 <sys_link+0xf4>
    8000427e:	08000613          	li	a2,128
    80004282:	f5040593          	addi	a1,s0,-176
    80004286:	4505                	li	a0,1
    80004288:	b07fd0ef          	jal	80001d8e <argstr>
    return -1;
    8000428c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000428e:	0c054463          	bltz	a0,80004356 <sys_link+0xf4>
    80004292:	ee26                	sd	s1,280(sp)
  begin_op();
    80004294:	ee1fe0ef          	jal	80003174 <begin_op>
  if((ip = namei(old)) == 0){
    80004298:	ed040513          	addi	a0,s0,-304
    8000429c:	cfbfe0ef          	jal	80002f96 <namei>
    800042a0:	84aa                	mv	s1,a0
    800042a2:	c53d                	beqz	a0,80004310 <sys_link+0xae>
  ilock(ip);
    800042a4:	cc4fe0ef          	jal	80002768 <ilock>
  if(ip->type == T_DIR){
    800042a8:	04449703          	lh	a4,68(s1)
    800042ac:	4785                	li	a5,1
    800042ae:	06f70663          	beq	a4,a5,8000431a <sys_link+0xb8>
    800042b2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042b4:	04a4d783          	lhu	a5,74(s1)
    800042b8:	2785                	addiw	a5,a5,1
    800042ba:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800042be:	8526                	mv	a0,s1
    800042c0:	bf4fe0ef          	jal	800026b4 <iupdate>
  iunlock(ip);
    800042c4:	8526                	mv	a0,s1
    800042c6:	d50fe0ef          	jal	80002816 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800042ca:	fd040593          	addi	a1,s0,-48
    800042ce:	f5040513          	addi	a0,s0,-176
    800042d2:	cdffe0ef          	jal	80002fb0 <nameiparent>
    800042d6:	892a                	mv	s2,a0
    800042d8:	cd21                	beqz	a0,80004330 <sys_link+0xce>
  ilock(dp);
    800042da:	c8efe0ef          	jal	80002768 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800042de:	854a                	mv	a0,s2
    800042e0:	00092703          	lw	a4,0(s2)
    800042e4:	409c                	lw	a5,0(s1)
    800042e6:	04f71263          	bne	a4,a5,8000432a <sys_link+0xc8>
    800042ea:	40d0                	lw	a2,4(s1)
    800042ec:	fd040593          	addi	a1,s0,-48
    800042f0:	bfdfe0ef          	jal	80002eec <dirlink>
    800042f4:	02054b63          	bltz	a0,8000432a <sys_link+0xc8>
  iunlockput(dp);
    800042f8:	854a                	mv	a0,s2
    800042fa:	e7afe0ef          	jal	80002974 <iunlockput>
  iput(ip);
    800042fe:	8526                	mv	a0,s1
    80004300:	deafe0ef          	jal	800028ea <iput>
  end_op();
    80004304:	ee1fe0ef          	jal	800031e4 <end_op>
  return 0;
    80004308:	4781                	li	a5,0
    8000430a:	64f2                	ld	s1,280(sp)
    8000430c:	6952                	ld	s2,272(sp)
    8000430e:	a0a1                	j	80004356 <sys_link+0xf4>
    end_op();
    80004310:	ed5fe0ef          	jal	800031e4 <end_op>
    return -1;
    80004314:	57fd                	li	a5,-1
    80004316:	64f2                	ld	s1,280(sp)
    80004318:	a83d                	j	80004356 <sys_link+0xf4>
    iunlockput(ip);
    8000431a:	8526                	mv	a0,s1
    8000431c:	e58fe0ef          	jal	80002974 <iunlockput>
    end_op();
    80004320:	ec5fe0ef          	jal	800031e4 <end_op>
    return -1;
    80004324:	57fd                	li	a5,-1
    80004326:	64f2                	ld	s1,280(sp)
    80004328:	a03d                	j	80004356 <sys_link+0xf4>
    iunlockput(dp);
    8000432a:	854a                	mv	a0,s2
    8000432c:	e48fe0ef          	jal	80002974 <iunlockput>
  ilock(ip);
    80004330:	8526                	mv	a0,s1
    80004332:	c36fe0ef          	jal	80002768 <ilock>
  ip->nlink--;
    80004336:	04a4d783          	lhu	a5,74(s1)
    8000433a:	37fd                	addiw	a5,a5,-1
    8000433c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004340:	8526                	mv	a0,s1
    80004342:	b72fe0ef          	jal	800026b4 <iupdate>
  iunlockput(ip);
    80004346:	8526                	mv	a0,s1
    80004348:	e2cfe0ef          	jal	80002974 <iunlockput>
  end_op();
    8000434c:	e99fe0ef          	jal	800031e4 <end_op>
  return -1;
    80004350:	57fd                	li	a5,-1
    80004352:	64f2                	ld	s1,280(sp)
    80004354:	6952                	ld	s2,272(sp)
}
    80004356:	853e                	mv	a0,a5
    80004358:	70b2                	ld	ra,296(sp)
    8000435a:	7412                	ld	s0,288(sp)
    8000435c:	6155                	addi	sp,sp,304
    8000435e:	8082                	ret

0000000080004360 <sys_unlink>:
{
    80004360:	7151                	addi	sp,sp,-240
    80004362:	f586                	sd	ra,232(sp)
    80004364:	f1a2                	sd	s0,224(sp)
    80004366:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004368:	08000613          	li	a2,128
    8000436c:	f3040593          	addi	a1,s0,-208
    80004370:	4501                	li	a0,0
    80004372:	a1dfd0ef          	jal	80001d8e <argstr>
    80004376:	14054d63          	bltz	a0,800044d0 <sys_unlink+0x170>
    8000437a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000437c:	df9fe0ef          	jal	80003174 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004380:	fb040593          	addi	a1,s0,-80
    80004384:	f3040513          	addi	a0,s0,-208
    80004388:	c29fe0ef          	jal	80002fb0 <nameiparent>
    8000438c:	84aa                	mv	s1,a0
    8000438e:	c955                	beqz	a0,80004442 <sys_unlink+0xe2>
  ilock(dp);
    80004390:	bd8fe0ef          	jal	80002768 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004394:	00003597          	auipc	a1,0x3
    80004398:	1e458593          	addi	a1,a1,484 # 80007578 <etext+0x578>
    8000439c:	fb040513          	addi	a0,s0,-80
    800043a0:	94dfe0ef          	jal	80002cec <namecmp>
    800043a4:	10050b63          	beqz	a0,800044ba <sys_unlink+0x15a>
    800043a8:	00003597          	auipc	a1,0x3
    800043ac:	1d858593          	addi	a1,a1,472 # 80007580 <etext+0x580>
    800043b0:	fb040513          	addi	a0,s0,-80
    800043b4:	939fe0ef          	jal	80002cec <namecmp>
    800043b8:	10050163          	beqz	a0,800044ba <sys_unlink+0x15a>
    800043bc:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800043be:	f2c40613          	addi	a2,s0,-212
    800043c2:	fb040593          	addi	a1,s0,-80
    800043c6:	8526                	mv	a0,s1
    800043c8:	93bfe0ef          	jal	80002d02 <dirlookup>
    800043cc:	892a                	mv	s2,a0
    800043ce:	0e050563          	beqz	a0,800044b8 <sys_unlink+0x158>
    800043d2:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800043d4:	b94fe0ef          	jal	80002768 <ilock>
  if(ip->nlink < 1)
    800043d8:	04a91783          	lh	a5,74(s2)
    800043dc:	06f05863          	blez	a5,8000444c <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800043e0:	04491703          	lh	a4,68(s2)
    800043e4:	4785                	li	a5,1
    800043e6:	06f70963          	beq	a4,a5,80004458 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800043ea:	fc040993          	addi	s3,s0,-64
    800043ee:	4641                	li	a2,16
    800043f0:	4581                	li	a1,0
    800043f2:	854e                	mv	a0,s3
    800043f4:	d6bfb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043f8:	4741                	li	a4,16
    800043fa:	f2c42683          	lw	a3,-212(s0)
    800043fe:	864e                	mv	a2,s3
    80004400:	4581                	li	a1,0
    80004402:	8526                	mv	a0,s1
    80004404:	fe8fe0ef          	jal	80002bec <writei>
    80004408:	47c1                	li	a5,16
    8000440a:	08f51863          	bne	a0,a5,8000449a <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    8000440e:	04491703          	lh	a4,68(s2)
    80004412:	4785                	li	a5,1
    80004414:	08f70963          	beq	a4,a5,800044a6 <sys_unlink+0x146>
  iunlockput(dp);
    80004418:	8526                	mv	a0,s1
    8000441a:	d5afe0ef          	jal	80002974 <iunlockput>
  ip->nlink--;
    8000441e:	04a95783          	lhu	a5,74(s2)
    80004422:	37fd                	addiw	a5,a5,-1
    80004424:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004428:	854a                	mv	a0,s2
    8000442a:	a8afe0ef          	jal	800026b4 <iupdate>
  iunlockput(ip);
    8000442e:	854a                	mv	a0,s2
    80004430:	d44fe0ef          	jal	80002974 <iunlockput>
  end_op();
    80004434:	db1fe0ef          	jal	800031e4 <end_op>
  return 0;
    80004438:	4501                	li	a0,0
    8000443a:	64ee                	ld	s1,216(sp)
    8000443c:	694e                	ld	s2,208(sp)
    8000443e:	69ae                	ld	s3,200(sp)
    80004440:	a061                	j	800044c8 <sys_unlink+0x168>
    end_op();
    80004442:	da3fe0ef          	jal	800031e4 <end_op>
    return -1;
    80004446:	557d                	li	a0,-1
    80004448:	64ee                	ld	s1,216(sp)
    8000444a:	a8bd                	j	800044c8 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000444c:	00003517          	auipc	a0,0x3
    80004450:	13c50513          	addi	a0,a0,316 # 80007588 <etext+0x588>
    80004454:	2f2010ef          	jal	80005746 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004458:	04c92703          	lw	a4,76(s2)
    8000445c:	02000793          	li	a5,32
    80004460:	f8e7f5e3          	bgeu	a5,a4,800043ea <sys_unlink+0x8a>
    80004464:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004466:	4741                	li	a4,16
    80004468:	86ce                	mv	a3,s3
    8000446a:	f1840613          	addi	a2,s0,-232
    8000446e:	4581                	li	a1,0
    80004470:	854a                	mv	a0,s2
    80004472:	e88fe0ef          	jal	80002afa <readi>
    80004476:	47c1                	li	a5,16
    80004478:	00f51b63          	bne	a0,a5,8000448e <sys_unlink+0x12e>
    if(de.inum != 0)
    8000447c:	f1845783          	lhu	a5,-232(s0)
    80004480:	ebb1                	bnez	a5,800044d4 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004482:	29c1                	addiw	s3,s3,16
    80004484:	04c92783          	lw	a5,76(s2)
    80004488:	fcf9efe3          	bltu	s3,a5,80004466 <sys_unlink+0x106>
    8000448c:	bfb9                	j	800043ea <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000448e:	00003517          	auipc	a0,0x3
    80004492:	11250513          	addi	a0,a0,274 # 800075a0 <etext+0x5a0>
    80004496:	2b0010ef          	jal	80005746 <panic>
    panic("unlink: writei");
    8000449a:	00003517          	auipc	a0,0x3
    8000449e:	11e50513          	addi	a0,a0,286 # 800075b8 <etext+0x5b8>
    800044a2:	2a4010ef          	jal	80005746 <panic>
    dp->nlink--;
    800044a6:	04a4d783          	lhu	a5,74(s1)
    800044aa:	37fd                	addiw	a5,a5,-1
    800044ac:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800044b0:	8526                	mv	a0,s1
    800044b2:	a02fe0ef          	jal	800026b4 <iupdate>
    800044b6:	b78d                	j	80004418 <sys_unlink+0xb8>
    800044b8:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800044ba:	8526                	mv	a0,s1
    800044bc:	cb8fe0ef          	jal	80002974 <iunlockput>
  end_op();
    800044c0:	d25fe0ef          	jal	800031e4 <end_op>
  return -1;
    800044c4:	557d                	li	a0,-1
    800044c6:	64ee                	ld	s1,216(sp)
}
    800044c8:	70ae                	ld	ra,232(sp)
    800044ca:	740e                	ld	s0,224(sp)
    800044cc:	616d                	addi	sp,sp,240
    800044ce:	8082                	ret
    return -1;
    800044d0:	557d                	li	a0,-1
    800044d2:	bfdd                	j	800044c8 <sys_unlink+0x168>
    iunlockput(ip);
    800044d4:	854a                	mv	a0,s2
    800044d6:	c9efe0ef          	jal	80002974 <iunlockput>
    goto bad;
    800044da:	694e                	ld	s2,208(sp)
    800044dc:	69ae                	ld	s3,200(sp)
    800044de:	bff1                	j	800044ba <sys_unlink+0x15a>

00000000800044e0 <sys_open>:

uint64
sys_open(void)
{
    800044e0:	7131                	addi	sp,sp,-192
    800044e2:	fd06                	sd	ra,184(sp)
    800044e4:	f922                	sd	s0,176(sp)
    800044e6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800044e8:	f4c40593          	addi	a1,s0,-180
    800044ec:	4505                	li	a0,1
    800044ee:	869fd0ef          	jal	80001d56 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800044f2:	08000613          	li	a2,128
    800044f6:	f5040593          	addi	a1,s0,-176
    800044fa:	4501                	li	a0,0
    800044fc:	893fd0ef          	jal	80001d8e <argstr>
    80004500:	87aa                	mv	a5,a0
    return -1;
    80004502:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004504:	0a07c363          	bltz	a5,800045aa <sys_open+0xca>
    80004508:	f526                	sd	s1,168(sp)

  begin_op();
    8000450a:	c6bfe0ef          	jal	80003174 <begin_op>

  if(omode & O_CREATE){
    8000450e:	f4c42783          	lw	a5,-180(s0)
    80004512:	2007f793          	andi	a5,a5,512
    80004516:	c3dd                	beqz	a5,800045bc <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004518:	4681                	li	a3,0
    8000451a:	4601                	li	a2,0
    8000451c:	4589                	li	a1,2
    8000451e:	f5040513          	addi	a0,s0,-176
    80004522:	aafff0ef          	jal	80003fd0 <create>
    80004526:	84aa                	mv	s1,a0
    if(ip == 0){
    80004528:	c549                	beqz	a0,800045b2 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000452a:	04449703          	lh	a4,68(s1)
    8000452e:	478d                	li	a5,3
    80004530:	00f71763          	bne	a4,a5,8000453e <sys_open+0x5e>
    80004534:	0464d703          	lhu	a4,70(s1)
    80004538:	47a5                	li	a5,9
    8000453a:	0ae7ee63          	bltu	a5,a4,800045f6 <sys_open+0x116>
    8000453e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004540:	fb5fe0ef          	jal	800034f4 <filealloc>
    80004544:	892a                	mv	s2,a0
    80004546:	c561                	beqz	a0,8000460e <sys_open+0x12e>
    80004548:	ed4e                	sd	s3,152(sp)
    8000454a:	a47ff0ef          	jal	80003f90 <fdalloc>
    8000454e:	89aa                	mv	s3,a0
    80004550:	0a054b63          	bltz	a0,80004606 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004554:	04449703          	lh	a4,68(s1)
    80004558:	478d                	li	a5,3
    8000455a:	0cf70363          	beq	a4,a5,80004620 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000455e:	4789                	li	a5,2
    80004560:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004564:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004568:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000456c:	f4c42783          	lw	a5,-180(s0)
    80004570:	0017f713          	andi	a4,a5,1
    80004574:	00174713          	xori	a4,a4,1
    80004578:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000457c:	0037f713          	andi	a4,a5,3
    80004580:	00e03733          	snez	a4,a4
    80004584:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004588:	4007f793          	andi	a5,a5,1024
    8000458c:	c791                	beqz	a5,80004598 <sys_open+0xb8>
    8000458e:	04449703          	lh	a4,68(s1)
    80004592:	4789                	li	a5,2
    80004594:	08f70d63          	beq	a4,a5,8000462e <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004598:	8526                	mv	a0,s1
    8000459a:	a7cfe0ef          	jal	80002816 <iunlock>
  end_op();
    8000459e:	c47fe0ef          	jal	800031e4 <end_op>

  return fd;
    800045a2:	854e                	mv	a0,s3
    800045a4:	74aa                	ld	s1,168(sp)
    800045a6:	790a                	ld	s2,160(sp)
    800045a8:	69ea                	ld	s3,152(sp)
}
    800045aa:	70ea                	ld	ra,184(sp)
    800045ac:	744a                	ld	s0,176(sp)
    800045ae:	6129                	addi	sp,sp,192
    800045b0:	8082                	ret
      end_op();
    800045b2:	c33fe0ef          	jal	800031e4 <end_op>
      return -1;
    800045b6:	557d                	li	a0,-1
    800045b8:	74aa                	ld	s1,168(sp)
    800045ba:	bfc5                	j	800045aa <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800045bc:	f5040513          	addi	a0,s0,-176
    800045c0:	9d7fe0ef          	jal	80002f96 <namei>
    800045c4:	84aa                	mv	s1,a0
    800045c6:	c11d                	beqz	a0,800045ec <sys_open+0x10c>
    ilock(ip);
    800045c8:	9a0fe0ef          	jal	80002768 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800045cc:	04449703          	lh	a4,68(s1)
    800045d0:	4785                	li	a5,1
    800045d2:	f4f71ce3          	bne	a4,a5,8000452a <sys_open+0x4a>
    800045d6:	f4c42783          	lw	a5,-180(s0)
    800045da:	d3b5                	beqz	a5,8000453e <sys_open+0x5e>
      iunlockput(ip);
    800045dc:	8526                	mv	a0,s1
    800045de:	b96fe0ef          	jal	80002974 <iunlockput>
      end_op();
    800045e2:	c03fe0ef          	jal	800031e4 <end_op>
      return -1;
    800045e6:	557d                	li	a0,-1
    800045e8:	74aa                	ld	s1,168(sp)
    800045ea:	b7c1                	j	800045aa <sys_open+0xca>
      end_op();
    800045ec:	bf9fe0ef          	jal	800031e4 <end_op>
      return -1;
    800045f0:	557d                	li	a0,-1
    800045f2:	74aa                	ld	s1,168(sp)
    800045f4:	bf5d                	j	800045aa <sys_open+0xca>
    iunlockput(ip);
    800045f6:	8526                	mv	a0,s1
    800045f8:	b7cfe0ef          	jal	80002974 <iunlockput>
    end_op();
    800045fc:	be9fe0ef          	jal	800031e4 <end_op>
    return -1;
    80004600:	557d                	li	a0,-1
    80004602:	74aa                	ld	s1,168(sp)
    80004604:	b75d                	j	800045aa <sys_open+0xca>
      fileclose(f);
    80004606:	854a                	mv	a0,s2
    80004608:	f91fe0ef          	jal	80003598 <fileclose>
    8000460c:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    8000460e:	8526                	mv	a0,s1
    80004610:	b64fe0ef          	jal	80002974 <iunlockput>
    end_op();
    80004614:	bd1fe0ef          	jal	800031e4 <end_op>
    return -1;
    80004618:	557d                	li	a0,-1
    8000461a:	74aa                	ld	s1,168(sp)
    8000461c:	790a                	ld	s2,160(sp)
    8000461e:	b771                	j	800045aa <sys_open+0xca>
    f->type = FD_DEVICE;
    80004620:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004624:	04649783          	lh	a5,70(s1)
    80004628:	02f91223          	sh	a5,36(s2)
    8000462c:	bf35                	j	80004568 <sys_open+0x88>
    itrunc(ip);
    8000462e:	8526                	mv	a0,s1
    80004630:	a26fe0ef          	jal	80002856 <itrunc>
    80004634:	b795                	j	80004598 <sys_open+0xb8>

0000000080004636 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004636:	7175                	addi	sp,sp,-144
    80004638:	e506                	sd	ra,136(sp)
    8000463a:	e122                	sd	s0,128(sp)
    8000463c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000463e:	b37fe0ef          	jal	80003174 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004642:	08000613          	li	a2,128
    80004646:	f7040593          	addi	a1,s0,-144
    8000464a:	4501                	li	a0,0
    8000464c:	f42fd0ef          	jal	80001d8e <argstr>
    80004650:	02054363          	bltz	a0,80004676 <sys_mkdir+0x40>
    80004654:	4681                	li	a3,0
    80004656:	4601                	li	a2,0
    80004658:	4585                	li	a1,1
    8000465a:	f7040513          	addi	a0,s0,-144
    8000465e:	973ff0ef          	jal	80003fd0 <create>
    80004662:	c911                	beqz	a0,80004676 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004664:	b10fe0ef          	jal	80002974 <iunlockput>
  end_op();
    80004668:	b7dfe0ef          	jal	800031e4 <end_op>
  return 0;
    8000466c:	4501                	li	a0,0
}
    8000466e:	60aa                	ld	ra,136(sp)
    80004670:	640a                	ld	s0,128(sp)
    80004672:	6149                	addi	sp,sp,144
    80004674:	8082                	ret
    end_op();
    80004676:	b6ffe0ef          	jal	800031e4 <end_op>
    return -1;
    8000467a:	557d                	li	a0,-1
    8000467c:	bfcd                	j	8000466e <sys_mkdir+0x38>

000000008000467e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000467e:	7135                	addi	sp,sp,-160
    80004680:	ed06                	sd	ra,152(sp)
    80004682:	e922                	sd	s0,144(sp)
    80004684:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004686:	aeffe0ef          	jal	80003174 <begin_op>
  argint(1, &major);
    8000468a:	f6c40593          	addi	a1,s0,-148
    8000468e:	4505                	li	a0,1
    80004690:	ec6fd0ef          	jal	80001d56 <argint>
  argint(2, &minor);
    80004694:	f6840593          	addi	a1,s0,-152
    80004698:	4509                	li	a0,2
    8000469a:	ebcfd0ef          	jal	80001d56 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000469e:	08000613          	li	a2,128
    800046a2:	f7040593          	addi	a1,s0,-144
    800046a6:	4501                	li	a0,0
    800046a8:	ee6fd0ef          	jal	80001d8e <argstr>
    800046ac:	02054563          	bltz	a0,800046d6 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800046b0:	f6841683          	lh	a3,-152(s0)
    800046b4:	f6c41603          	lh	a2,-148(s0)
    800046b8:	458d                	li	a1,3
    800046ba:	f7040513          	addi	a0,s0,-144
    800046be:	913ff0ef          	jal	80003fd0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046c2:	c911                	beqz	a0,800046d6 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800046c4:	ab0fe0ef          	jal	80002974 <iunlockput>
  end_op();
    800046c8:	b1dfe0ef          	jal	800031e4 <end_op>
  return 0;
    800046cc:	4501                	li	a0,0
}
    800046ce:	60ea                	ld	ra,152(sp)
    800046d0:	644a                	ld	s0,144(sp)
    800046d2:	610d                	addi	sp,sp,160
    800046d4:	8082                	ret
    end_op();
    800046d6:	b0ffe0ef          	jal	800031e4 <end_op>
    return -1;
    800046da:	557d                	li	a0,-1
    800046dc:	bfcd                	j	800046ce <sys_mknod+0x50>

00000000800046de <sys_chdir>:

uint64
sys_chdir(void)
{
    800046de:	7135                	addi	sp,sp,-160
    800046e0:	ed06                	sd	ra,152(sp)
    800046e2:	e922                	sd	s0,144(sp)
    800046e4:	e14a                	sd	s2,128(sp)
    800046e6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800046e8:	eeefc0ef          	jal	80000dd6 <myproc>
    800046ec:	892a                	mv	s2,a0
  
  begin_op();
    800046ee:	a87fe0ef          	jal	80003174 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800046f2:	08000613          	li	a2,128
    800046f6:	f6040593          	addi	a1,s0,-160
    800046fa:	4501                	li	a0,0
    800046fc:	e92fd0ef          	jal	80001d8e <argstr>
    80004700:	04054363          	bltz	a0,80004746 <sys_chdir+0x68>
    80004704:	e526                	sd	s1,136(sp)
    80004706:	f6040513          	addi	a0,s0,-160
    8000470a:	88dfe0ef          	jal	80002f96 <namei>
    8000470e:	84aa                	mv	s1,a0
    80004710:	c915                	beqz	a0,80004744 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004712:	856fe0ef          	jal	80002768 <ilock>
  if(ip->type != T_DIR){
    80004716:	04449703          	lh	a4,68(s1)
    8000471a:	4785                	li	a5,1
    8000471c:	02f71963          	bne	a4,a5,8000474e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004720:	8526                	mv	a0,s1
    80004722:	8f4fe0ef          	jal	80002816 <iunlock>
  iput(p->cwd);
    80004726:	15893503          	ld	a0,344(s2)
    8000472a:	9c0fe0ef          	jal	800028ea <iput>
  end_op();
    8000472e:	ab7fe0ef          	jal	800031e4 <end_op>
  p->cwd = ip;
    80004732:	14993c23          	sd	s1,344(s2)
  return 0;
    80004736:	4501                	li	a0,0
    80004738:	64aa                	ld	s1,136(sp)
}
    8000473a:	60ea                	ld	ra,152(sp)
    8000473c:	644a                	ld	s0,144(sp)
    8000473e:	690a                	ld	s2,128(sp)
    80004740:	610d                	addi	sp,sp,160
    80004742:	8082                	ret
    80004744:	64aa                	ld	s1,136(sp)
    end_op();
    80004746:	a9ffe0ef          	jal	800031e4 <end_op>
    return -1;
    8000474a:	557d                	li	a0,-1
    8000474c:	b7fd                	j	8000473a <sys_chdir+0x5c>
    iunlockput(ip);
    8000474e:	8526                	mv	a0,s1
    80004750:	a24fe0ef          	jal	80002974 <iunlockput>
    end_op();
    80004754:	a91fe0ef          	jal	800031e4 <end_op>
    return -1;
    80004758:	557d                	li	a0,-1
    8000475a:	64aa                	ld	s1,136(sp)
    8000475c:	bff9                	j	8000473a <sys_chdir+0x5c>

000000008000475e <sys_exec>:

uint64
sys_exec(void)
{
    8000475e:	7105                	addi	sp,sp,-480
    80004760:	ef86                	sd	ra,472(sp)
    80004762:	eba2                	sd	s0,464(sp)
    80004764:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004766:	e2840593          	addi	a1,s0,-472
    8000476a:	4505                	li	a0,1
    8000476c:	e06fd0ef          	jal	80001d72 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004770:	08000613          	li	a2,128
    80004774:	f3040593          	addi	a1,s0,-208
    80004778:	4501                	li	a0,0
    8000477a:	e14fd0ef          	jal	80001d8e <argstr>
    8000477e:	87aa                	mv	a5,a0
    return -1;
    80004780:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004782:	0e07c063          	bltz	a5,80004862 <sys_exec+0x104>
    80004786:	e7a6                	sd	s1,456(sp)
    80004788:	e3ca                	sd	s2,448(sp)
    8000478a:	ff4e                	sd	s3,440(sp)
    8000478c:	fb52                	sd	s4,432(sp)
    8000478e:	f756                	sd	s5,424(sp)
    80004790:	f35a                	sd	s6,416(sp)
    80004792:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004794:	e3040a13          	addi	s4,s0,-464
    80004798:	10000613          	li	a2,256
    8000479c:	4581                	li	a1,0
    8000479e:	8552                	mv	a0,s4
    800047a0:	9bffb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800047a4:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800047a6:	89d2                	mv	s3,s4
    800047a8:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047aa:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047ae:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800047b0:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047b4:	00391513          	slli	a0,s2,0x3
    800047b8:	85d6                	mv	a1,s5
    800047ba:	e2843783          	ld	a5,-472(s0)
    800047be:	953e                	add	a0,a0,a5
    800047c0:	d0cfd0ef          	jal	80001ccc <fetchaddr>
    800047c4:	02054663          	bltz	a0,800047f0 <sys_exec+0x92>
    if(uarg == 0){
    800047c8:	e2043783          	ld	a5,-480(s0)
    800047cc:	c7a1                	beqz	a5,80004814 <sys_exec+0xb6>
    argv[i] = kalloc();
    800047ce:	937fb0ef          	jal	80000104 <kalloc>
    800047d2:	85aa                	mv	a1,a0
    800047d4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800047d8:	cd01                	beqz	a0,800047f0 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047da:	865a                	mv	a2,s6
    800047dc:	e2043503          	ld	a0,-480(s0)
    800047e0:	d36fd0ef          	jal	80001d16 <fetchstr>
    800047e4:	00054663          	bltz	a0,800047f0 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800047e8:	0905                	addi	s2,s2,1
    800047ea:	09a1                	addi	s3,s3,8
    800047ec:	fd7914e3          	bne	s2,s7,800047b4 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800047f0:	100a0a13          	addi	s4,s4,256
    800047f4:	6088                	ld	a0,0(s1)
    800047f6:	cd31                	beqz	a0,80004852 <sys_exec+0xf4>
    kfree(argv[i]);
    800047f8:	825fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800047fc:	04a1                	addi	s1,s1,8
    800047fe:	ff449be3          	bne	s1,s4,800047f4 <sys_exec+0x96>
  return -1;
    80004802:	557d                	li	a0,-1
    80004804:	64be                	ld	s1,456(sp)
    80004806:	691e                	ld	s2,448(sp)
    80004808:	79fa                	ld	s3,440(sp)
    8000480a:	7a5a                	ld	s4,432(sp)
    8000480c:	7aba                	ld	s5,424(sp)
    8000480e:	7b1a                	ld	s6,416(sp)
    80004810:	6bfa                	ld	s7,408(sp)
    80004812:	a881                	j	80004862 <sys_exec+0x104>
      argv[i] = 0;
    80004814:	0009079b          	sext.w	a5,s2
    80004818:	e3040593          	addi	a1,s0,-464
    8000481c:	078e                	slli	a5,a5,0x3
    8000481e:	97ae                	add	a5,a5,a1
    80004820:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004824:	f3040513          	addi	a0,s0,-208
    80004828:	bb2ff0ef          	jal	80003bda <kexec>
    8000482c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000482e:	100a0a13          	addi	s4,s4,256
    80004832:	6088                	ld	a0,0(s1)
    80004834:	c511                	beqz	a0,80004840 <sys_exec+0xe2>
    kfree(argv[i]);
    80004836:	fe6fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000483a:	04a1                	addi	s1,s1,8
    8000483c:	ff449be3          	bne	s1,s4,80004832 <sys_exec+0xd4>
  return ret;
    80004840:	854a                	mv	a0,s2
    80004842:	64be                	ld	s1,456(sp)
    80004844:	691e                	ld	s2,448(sp)
    80004846:	79fa                	ld	s3,440(sp)
    80004848:	7a5a                	ld	s4,432(sp)
    8000484a:	7aba                	ld	s5,424(sp)
    8000484c:	7b1a                	ld	s6,416(sp)
    8000484e:	6bfa                	ld	s7,408(sp)
    80004850:	a809                	j	80004862 <sys_exec+0x104>
  return -1;
    80004852:	557d                	li	a0,-1
    80004854:	64be                	ld	s1,456(sp)
    80004856:	691e                	ld	s2,448(sp)
    80004858:	79fa                	ld	s3,440(sp)
    8000485a:	7a5a                	ld	s4,432(sp)
    8000485c:	7aba                	ld	s5,424(sp)
    8000485e:	7b1a                	ld	s6,416(sp)
    80004860:	6bfa                	ld	s7,408(sp)
}
    80004862:	60fe                	ld	ra,472(sp)
    80004864:	645e                	ld	s0,464(sp)
    80004866:	613d                	addi	sp,sp,480
    80004868:	8082                	ret

000000008000486a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000486a:	7139                	addi	sp,sp,-64
    8000486c:	fc06                	sd	ra,56(sp)
    8000486e:	f822                	sd	s0,48(sp)
    80004870:	f426                	sd	s1,40(sp)
    80004872:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004874:	d62fc0ef          	jal	80000dd6 <myproc>
    80004878:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000487a:	fd840593          	addi	a1,s0,-40
    8000487e:	4501                	li	a0,0
    80004880:	cf2fd0ef          	jal	80001d72 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004884:	fc840593          	addi	a1,s0,-56
    80004888:	fd040513          	addi	a0,s0,-48
    8000488c:	828ff0ef          	jal	800038b4 <pipealloc>
    return -1;
    80004890:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004892:	0a054763          	bltz	a0,80004940 <sys_pipe+0xd6>
  fd0 = -1;
    80004896:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000489a:	fd043503          	ld	a0,-48(s0)
    8000489e:	ef2ff0ef          	jal	80003f90 <fdalloc>
    800048a2:	fca42223          	sw	a0,-60(s0)
    800048a6:	08054463          	bltz	a0,8000492e <sys_pipe+0xc4>
    800048aa:	fc843503          	ld	a0,-56(s0)
    800048ae:	ee2ff0ef          	jal	80003f90 <fdalloc>
    800048b2:	fca42023          	sw	a0,-64(s0)
    800048b6:	06054263          	bltz	a0,8000491a <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048ba:	4691                	li	a3,4
    800048bc:	fc440613          	addi	a2,s0,-60
    800048c0:	fd843583          	ld	a1,-40(s0)
    800048c4:	68a8                	ld	a0,80(s1)
    800048c6:	a2efc0ef          	jal	80000af4 <copyout>
    800048ca:	00054e63          	bltz	a0,800048e6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800048ce:	4691                	li	a3,4
    800048d0:	fc040613          	addi	a2,s0,-64
    800048d4:	fd843583          	ld	a1,-40(s0)
    800048d8:	95b6                	add	a1,a1,a3
    800048da:	68a8                	ld	a0,80(s1)
    800048dc:	a18fc0ef          	jal	80000af4 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800048e0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048e2:	04055f63          	bgez	a0,80004940 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800048e6:	fc442783          	lw	a5,-60(s0)
    800048ea:	078e                	slli	a5,a5,0x3
    800048ec:	0d078793          	addi	a5,a5,208
    800048f0:	97a6                	add	a5,a5,s1
    800048f2:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    800048f6:	fc042783          	lw	a5,-64(s0)
    800048fa:	078e                	slli	a5,a5,0x3
    800048fc:	0d078793          	addi	a5,a5,208
    80004900:	97a6                	add	a5,a5,s1
    80004902:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004906:	fd043503          	ld	a0,-48(s0)
    8000490a:	c8ffe0ef          	jal	80003598 <fileclose>
    fileclose(wf);
    8000490e:	fc843503          	ld	a0,-56(s0)
    80004912:	c87fe0ef          	jal	80003598 <fileclose>
    return -1;
    80004916:	57fd                	li	a5,-1
    80004918:	a025                	j	80004940 <sys_pipe+0xd6>
    if(fd0 >= 0)
    8000491a:	fc442783          	lw	a5,-60(s0)
    8000491e:	0007c863          	bltz	a5,8000492e <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004922:	078e                	slli	a5,a5,0x3
    80004924:	0d078793          	addi	a5,a5,208
    80004928:	97a6                	add	a5,a5,s1
    8000492a:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    8000492e:	fd043503          	ld	a0,-48(s0)
    80004932:	c67fe0ef          	jal	80003598 <fileclose>
    fileclose(wf);
    80004936:	fc843503          	ld	a0,-56(s0)
    8000493a:	c5ffe0ef          	jal	80003598 <fileclose>
    return -1;
    8000493e:	57fd                	li	a5,-1
}
    80004940:	853e                	mv	a0,a5
    80004942:	70e2                	ld	ra,56(sp)
    80004944:	7442                	ld	s0,48(sp)
    80004946:	74a2                	ld	s1,40(sp)
    80004948:	6121                	addi	sp,sp,64
    8000494a:	8082                	ret
    8000494c:	0000                	unimp
	...

0000000080004950 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004950:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004952:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004954:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004956:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004958:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000495a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000495c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000495e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004960:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004962:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004964:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004966:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004968:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000496a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000496c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000496e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004970:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004972:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004974:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004976:	a64fd0ef          	jal	80001bda <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000497a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000497c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000497e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004980:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004982:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004984:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004986:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004988:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000498a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000498c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000498e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004990:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004992:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004994:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004996:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004998:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000499a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000499c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000499e:	10200073          	sret
    800049a2:	00000013          	nop
    800049a6:	00000013          	nop
    800049aa:	00000013          	nop

00000000800049ae <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800049ae:	1141                	addi	sp,sp,-16
    800049b0:	e406                	sd	ra,8(sp)
    800049b2:	e022                	sd	s0,0(sp)
    800049b4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800049b6:	0c000737          	lui	a4,0xc000
    800049ba:	4785                	li	a5,1
    800049bc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800049be:	c35c                	sw	a5,4(a4)
}
    800049c0:	60a2                	ld	ra,8(sp)
    800049c2:	6402                	ld	s0,0(sp)
    800049c4:	0141                	addi	sp,sp,16
    800049c6:	8082                	ret

00000000800049c8 <plicinithart>:

void
plicinithart(void)
{
    800049c8:	1141                	addi	sp,sp,-16
    800049ca:	e406                	sd	ra,8(sp)
    800049cc:	e022                	sd	s0,0(sp)
    800049ce:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049d0:	bd2fc0ef          	jal	80000da2 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800049d4:	0085171b          	slliw	a4,a0,0x8
    800049d8:	0c0027b7          	lui	a5,0xc002
    800049dc:	97ba                	add	a5,a5,a4
    800049de:	40200713          	li	a4,1026
    800049e2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800049e6:	00d5151b          	slliw	a0,a0,0xd
    800049ea:	0c2017b7          	lui	a5,0xc201
    800049ee:	97aa                	add	a5,a5,a0
    800049f0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800049f4:	60a2                	ld	ra,8(sp)
    800049f6:	6402                	ld	s0,0(sp)
    800049f8:	0141                	addi	sp,sp,16
    800049fa:	8082                	ret

00000000800049fc <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800049fc:	1141                	addi	sp,sp,-16
    800049fe:	e406                	sd	ra,8(sp)
    80004a00:	e022                	sd	s0,0(sp)
    80004a02:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a04:	b9efc0ef          	jal	80000da2 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004a08:	00d5151b          	slliw	a0,a0,0xd
    80004a0c:	0c2017b7          	lui	a5,0xc201
    80004a10:	97aa                	add	a5,a5,a0
  return irq;
}
    80004a12:	43c8                	lw	a0,4(a5)
    80004a14:	60a2                	ld	ra,8(sp)
    80004a16:	6402                	ld	s0,0(sp)
    80004a18:	0141                	addi	sp,sp,16
    80004a1a:	8082                	ret

0000000080004a1c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004a1c:	1101                	addi	sp,sp,-32
    80004a1e:	ec06                	sd	ra,24(sp)
    80004a20:	e822                	sd	s0,16(sp)
    80004a22:	e426                	sd	s1,8(sp)
    80004a24:	1000                	addi	s0,sp,32
    80004a26:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004a28:	b7afc0ef          	jal	80000da2 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004a2c:	00d5179b          	slliw	a5,a0,0xd
    80004a30:	0c201737          	lui	a4,0xc201
    80004a34:	97ba                	add	a5,a5,a4
    80004a36:	c3c4                	sw	s1,4(a5)
}
    80004a38:	60e2                	ld	ra,24(sp)
    80004a3a:	6442                	ld	s0,16(sp)
    80004a3c:	64a2                	ld	s1,8(sp)
    80004a3e:	6105                	addi	sp,sp,32
    80004a40:	8082                	ret

0000000080004a42 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a42:	1141                	addi	sp,sp,-16
    80004a44:	e406                	sd	ra,8(sp)
    80004a46:	e022                	sd	s0,0(sp)
    80004a48:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a4a:	479d                	li	a5,7
    80004a4c:	04a7ca63          	blt	a5,a0,80004aa0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a50:	00016797          	auipc	a5,0x16
    80004a54:	38078793          	addi	a5,a5,896 # 8001add0 <disk>
    80004a58:	97aa                	add	a5,a5,a0
    80004a5a:	0187c783          	lbu	a5,24(a5)
    80004a5e:	e7b9                	bnez	a5,80004aac <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a60:	00451693          	slli	a3,a0,0x4
    80004a64:	00016797          	auipc	a5,0x16
    80004a68:	36c78793          	addi	a5,a5,876 # 8001add0 <disk>
    80004a6c:	6398                	ld	a4,0(a5)
    80004a6e:	9736                	add	a4,a4,a3
    80004a70:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004a74:	6398                	ld	a4,0(a5)
    80004a76:	9736                	add	a4,a4,a3
    80004a78:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004a7c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004a80:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004a84:	97aa                	add	a5,a5,a0
    80004a86:	4705                	li	a4,1
    80004a88:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004a8c:	00016517          	auipc	a0,0x16
    80004a90:	35c50513          	addi	a0,a0,860 # 8001ade8 <disk+0x18>
    80004a94:	a03fc0ef          	jal	80001496 <wakeup>
}
    80004a98:	60a2                	ld	ra,8(sp)
    80004a9a:	6402                	ld	s0,0(sp)
    80004a9c:	0141                	addi	sp,sp,16
    80004a9e:	8082                	ret
    panic("free_desc 1");
    80004aa0:	00003517          	auipc	a0,0x3
    80004aa4:	b2850513          	addi	a0,a0,-1240 # 800075c8 <etext+0x5c8>
    80004aa8:	49f000ef          	jal	80005746 <panic>
    panic("free_desc 2");
    80004aac:	00003517          	auipc	a0,0x3
    80004ab0:	b2c50513          	addi	a0,a0,-1236 # 800075d8 <etext+0x5d8>
    80004ab4:	493000ef          	jal	80005746 <panic>

0000000080004ab8 <virtio_disk_init>:
{
    80004ab8:	1101                	addi	sp,sp,-32
    80004aba:	ec06                	sd	ra,24(sp)
    80004abc:	e822                	sd	s0,16(sp)
    80004abe:	e426                	sd	s1,8(sp)
    80004ac0:	e04a                	sd	s2,0(sp)
    80004ac2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004ac4:	00003597          	auipc	a1,0x3
    80004ac8:	b2458593          	addi	a1,a1,-1244 # 800075e8 <etext+0x5e8>
    80004acc:	00016517          	auipc	a0,0x16
    80004ad0:	42c50513          	addi	a0,a0,1068 # 8001aef8 <disk+0x128>
    80004ad4:	6ab000ef          	jal	8000597e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004ad8:	100017b7          	lui	a5,0x10001
    80004adc:	4398                	lw	a4,0(a5)
    80004ade:	2701                	sext.w	a4,a4
    80004ae0:	747277b7          	lui	a5,0x74727
    80004ae4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004ae8:	14f71863          	bne	a4,a5,80004c38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004aec:	100017b7          	lui	a5,0x10001
    80004af0:	43dc                	lw	a5,4(a5)
    80004af2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004af4:	4709                	li	a4,2
    80004af6:	14e79163          	bne	a5,a4,80004c38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004afa:	100017b7          	lui	a5,0x10001
    80004afe:	479c                	lw	a5,8(a5)
    80004b00:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b02:	12e79b63          	bne	a5,a4,80004c38 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004b06:	100017b7          	lui	a5,0x10001
    80004b0a:	47d8                	lw	a4,12(a5)
    80004b0c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b0e:	554d47b7          	lui	a5,0x554d4
    80004b12:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004b16:	12f71163          	bne	a4,a5,80004c38 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b1a:	100017b7          	lui	a5,0x10001
    80004b1e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b22:	4705                	li	a4,1
    80004b24:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b26:	470d                	li	a4,3
    80004b28:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004b2a:	10001737          	lui	a4,0x10001
    80004b2e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004b30:	c7ffe6b7          	lui	a3,0xc7ffe
    80004b34:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb777>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004b38:	8f75                	and	a4,a4,a3
    80004b3a:	100016b7          	lui	a3,0x10001
    80004b3e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b40:	472d                	li	a4,11
    80004b42:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b44:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b48:	439c                	lw	a5,0(a5)
    80004b4a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b4e:	8ba1                	andi	a5,a5,8
    80004b50:	0e078a63          	beqz	a5,80004c44 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b54:	100017b7          	lui	a5,0x10001
    80004b58:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b5c:	43fc                	lw	a5,68(a5)
    80004b5e:	2781                	sext.w	a5,a5
    80004b60:	0e079863          	bnez	a5,80004c50 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004b64:	100017b7          	lui	a5,0x10001
    80004b68:	5bdc                	lw	a5,52(a5)
    80004b6a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004b6c:	0e078863          	beqz	a5,80004c5c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004b70:	471d                	li	a4,7
    80004b72:	0ef77b63          	bgeu	a4,a5,80004c68 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004b76:	d8efb0ef          	jal	80000104 <kalloc>
    80004b7a:	00016497          	auipc	s1,0x16
    80004b7e:	25648493          	addi	s1,s1,598 # 8001add0 <disk>
    80004b82:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004b84:	d80fb0ef          	jal	80000104 <kalloc>
    80004b88:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004b8a:	d7afb0ef          	jal	80000104 <kalloc>
    80004b8e:	87aa                	mv	a5,a0
    80004b90:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004b92:	6088                	ld	a0,0(s1)
    80004b94:	0e050063          	beqz	a0,80004c74 <virtio_disk_init+0x1bc>
    80004b98:	00016717          	auipc	a4,0x16
    80004b9c:	24073703          	ld	a4,576(a4) # 8001add8 <disk+0x8>
    80004ba0:	cb71                	beqz	a4,80004c74 <virtio_disk_init+0x1bc>
    80004ba2:	cbe9                	beqz	a5,80004c74 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004ba4:	6605                	lui	a2,0x1
    80004ba6:	4581                	li	a1,0
    80004ba8:	db6fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004bac:	00016497          	auipc	s1,0x16
    80004bb0:	22448493          	addi	s1,s1,548 # 8001add0 <disk>
    80004bb4:	6605                	lui	a2,0x1
    80004bb6:	4581                	li	a1,0
    80004bb8:	6488                	ld	a0,8(s1)
    80004bba:	da4fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    80004bbe:	6605                	lui	a2,0x1
    80004bc0:	4581                	li	a1,0
    80004bc2:	6888                	ld	a0,16(s1)
    80004bc4:	d9afb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004bc8:	100017b7          	lui	a5,0x10001
    80004bcc:	4721                	li	a4,8
    80004bce:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004bd0:	4098                	lw	a4,0(s1)
    80004bd2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004bd6:	40d8                	lw	a4,4(s1)
    80004bd8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004bdc:	649c                	ld	a5,8(s1)
    80004bde:	0007869b          	sext.w	a3,a5
    80004be2:	10001737          	lui	a4,0x10001
    80004be6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004bea:	9781                	srai	a5,a5,0x20
    80004bec:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004bf0:	689c                	ld	a5,16(s1)
    80004bf2:	0007869b          	sext.w	a3,a5
    80004bf6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004bfa:	9781                	srai	a5,a5,0x20
    80004bfc:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004c00:	4785                	li	a5,1
    80004c02:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004c04:	00f48c23          	sb	a5,24(s1)
    80004c08:	00f48ca3          	sb	a5,25(s1)
    80004c0c:	00f48d23          	sb	a5,26(s1)
    80004c10:	00f48da3          	sb	a5,27(s1)
    80004c14:	00f48e23          	sb	a5,28(s1)
    80004c18:	00f48ea3          	sb	a5,29(s1)
    80004c1c:	00f48f23          	sb	a5,30(s1)
    80004c20:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c24:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c28:	07272823          	sw	s2,112(a4)
}
    80004c2c:	60e2                	ld	ra,24(sp)
    80004c2e:	6442                	ld	s0,16(sp)
    80004c30:	64a2                	ld	s1,8(sp)
    80004c32:	6902                	ld	s2,0(sp)
    80004c34:	6105                	addi	sp,sp,32
    80004c36:	8082                	ret
    panic("could not find virtio disk");
    80004c38:	00003517          	auipc	a0,0x3
    80004c3c:	9c050513          	addi	a0,a0,-1600 # 800075f8 <etext+0x5f8>
    80004c40:	307000ef          	jal	80005746 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004c44:	00003517          	auipc	a0,0x3
    80004c48:	9d450513          	addi	a0,a0,-1580 # 80007618 <etext+0x618>
    80004c4c:	2fb000ef          	jal	80005746 <panic>
    panic("virtio disk should not be ready");
    80004c50:	00003517          	auipc	a0,0x3
    80004c54:	9e850513          	addi	a0,a0,-1560 # 80007638 <etext+0x638>
    80004c58:	2ef000ef          	jal	80005746 <panic>
    panic("virtio disk has no queue 0");
    80004c5c:	00003517          	auipc	a0,0x3
    80004c60:	9fc50513          	addi	a0,a0,-1540 # 80007658 <etext+0x658>
    80004c64:	2e3000ef          	jal	80005746 <panic>
    panic("virtio disk max queue too short");
    80004c68:	00003517          	auipc	a0,0x3
    80004c6c:	a1050513          	addi	a0,a0,-1520 # 80007678 <etext+0x678>
    80004c70:	2d7000ef          	jal	80005746 <panic>
    panic("virtio disk kalloc");
    80004c74:	00003517          	auipc	a0,0x3
    80004c78:	a2450513          	addi	a0,a0,-1500 # 80007698 <etext+0x698>
    80004c7c:	2cb000ef          	jal	80005746 <panic>

0000000080004c80 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004c80:	711d                	addi	sp,sp,-96
    80004c82:	ec86                	sd	ra,88(sp)
    80004c84:	e8a2                	sd	s0,80(sp)
    80004c86:	e4a6                	sd	s1,72(sp)
    80004c88:	e0ca                	sd	s2,64(sp)
    80004c8a:	fc4e                	sd	s3,56(sp)
    80004c8c:	f852                	sd	s4,48(sp)
    80004c8e:	f456                	sd	s5,40(sp)
    80004c90:	f05a                	sd	s6,32(sp)
    80004c92:	ec5e                	sd	s7,24(sp)
    80004c94:	e862                	sd	s8,16(sp)
    80004c96:	1080                	addi	s0,sp,96
    80004c98:	89aa                	mv	s3,a0
    80004c9a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004c9c:	00c52b83          	lw	s7,12(a0)
    80004ca0:	001b9b9b          	slliw	s7,s7,0x1
    80004ca4:	1b82                	slli	s7,s7,0x20
    80004ca6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004caa:	00016517          	auipc	a0,0x16
    80004cae:	24e50513          	addi	a0,a0,590 # 8001aef8 <disk+0x128>
    80004cb2:	557000ef          	jal	80005a08 <acquire>
  for(int i = 0; i < NUM; i++){
    80004cb6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004cb8:	00016a97          	auipc	s5,0x16
    80004cbc:	118a8a93          	addi	s5,s5,280 # 8001add0 <disk>
  for(int i = 0; i < 3; i++){
    80004cc0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004cc2:	5c7d                	li	s8,-1
    80004cc4:	a095                	j	80004d28 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004cc6:	00fa8733          	add	a4,s5,a5
    80004cca:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004cce:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004cd0:	0207c563          	bltz	a5,80004cfa <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004cd4:	2905                	addiw	s2,s2,1
    80004cd6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004cd8:	05490c63          	beq	s2,s4,80004d30 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004cdc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004cde:	00016717          	auipc	a4,0x16
    80004ce2:	0f270713          	addi	a4,a4,242 # 8001add0 <disk>
    80004ce6:	4781                	li	a5,0
    if(disk.free[i]){
    80004ce8:	01874683          	lbu	a3,24(a4)
    80004cec:	fee9                	bnez	a3,80004cc6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004cee:	2785                	addiw	a5,a5,1
    80004cf0:	0705                	addi	a4,a4,1
    80004cf2:	fe979be3          	bne	a5,s1,80004ce8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004cf6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004cfa:	01205d63          	blez	s2,80004d14 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004cfe:	fa042503          	lw	a0,-96(s0)
    80004d02:	d41ff0ef          	jal	80004a42 <free_desc>
      for(int j = 0; j < i; j++)
    80004d06:	4785                	li	a5,1
    80004d08:	0127d663          	bge	a5,s2,80004d14 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004d0c:	fa442503          	lw	a0,-92(s0)
    80004d10:	d33ff0ef          	jal	80004a42 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d14:	00016597          	auipc	a1,0x16
    80004d18:	1e458593          	addi	a1,a1,484 # 8001aef8 <disk+0x128>
    80004d1c:	00016517          	auipc	a0,0x16
    80004d20:	0cc50513          	addi	a0,a0,204 # 8001ade8 <disk+0x18>
    80004d24:	f26fc0ef          	jal	8000144a <sleep>
  for(int i = 0; i < 3; i++){
    80004d28:	fa040613          	addi	a2,s0,-96
    80004d2c:	4901                	li	s2,0
    80004d2e:	b77d                	j	80004cdc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d30:	fa042503          	lw	a0,-96(s0)
    80004d34:	00451693          	slli	a3,a0,0x4

  if(write)
    80004d38:	00016797          	auipc	a5,0x16
    80004d3c:	09878793          	addi	a5,a5,152 # 8001add0 <disk>
    80004d40:	00451713          	slli	a4,a0,0x4
    80004d44:	0a070713          	addi	a4,a4,160
    80004d48:	973e                	add	a4,a4,a5
    80004d4a:	01603633          	snez	a2,s6
    80004d4e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004d50:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004d54:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d58:	6398                	ld	a4,0(a5)
    80004d5a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d5c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004d60:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d62:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004d64:	6390                	ld	a2,0(a5)
    80004d66:	00d60833          	add	a6,a2,a3
    80004d6a:	4741                	li	a4,16
    80004d6c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004d70:	4585                	li	a1,1
    80004d72:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004d76:	fa442703          	lw	a4,-92(s0)
    80004d7a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004d7e:	0712                	slli	a4,a4,0x4
    80004d80:	963a                	add	a2,a2,a4
    80004d82:	05898813          	addi	a6,s3,88
    80004d86:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004d8a:	0007b883          	ld	a7,0(a5)
    80004d8e:	9746                	add	a4,a4,a7
    80004d90:	40000613          	li	a2,1024
    80004d94:	c710                	sw	a2,8(a4)
  if(write)
    80004d96:	001b3613          	seqz	a2,s6
    80004d9a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004d9e:	8e4d                	or	a2,a2,a1
    80004da0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004da4:	fa842603          	lw	a2,-88(s0)
    80004da8:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004dac:	00451813          	slli	a6,a0,0x4
    80004db0:	02080813          	addi	a6,a6,32
    80004db4:	983e                	add	a6,a6,a5
    80004db6:	577d                	li	a4,-1
    80004db8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004dbc:	0612                	slli	a2,a2,0x4
    80004dbe:	98b2                	add	a7,a7,a2
    80004dc0:	03068713          	addi	a4,a3,48
    80004dc4:	973e                	add	a4,a4,a5
    80004dc6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004dca:	6398                	ld	a4,0(a5)
    80004dcc:	9732                	add	a4,a4,a2
    80004dce:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004dd0:	4689                	li	a3,2
    80004dd2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004dd6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004dda:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004dde:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004de2:	6794                	ld	a3,8(a5)
    80004de4:	0026d703          	lhu	a4,2(a3)
    80004de8:	8b1d                	andi	a4,a4,7
    80004dea:	0706                	slli	a4,a4,0x1
    80004dec:	96ba                	add	a3,a3,a4
    80004dee:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004df2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004df6:	6798                	ld	a4,8(a5)
    80004df8:	00275783          	lhu	a5,2(a4)
    80004dfc:	2785                	addiw	a5,a5,1
    80004dfe:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004e02:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004e06:	100017b7          	lui	a5,0x10001
    80004e0a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004e0e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004e12:	00016917          	auipc	s2,0x16
    80004e16:	0e690913          	addi	s2,s2,230 # 8001aef8 <disk+0x128>
  while(b->disk == 1) {
    80004e1a:	84ae                	mv	s1,a1
    80004e1c:	00b79a63          	bne	a5,a1,80004e30 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004e20:	85ca                	mv	a1,s2
    80004e22:	854e                	mv	a0,s3
    80004e24:	e26fc0ef          	jal	8000144a <sleep>
  while(b->disk == 1) {
    80004e28:	0049a783          	lw	a5,4(s3)
    80004e2c:	fe978ae3          	beq	a5,s1,80004e20 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004e30:	fa042903          	lw	s2,-96(s0)
    80004e34:	00491713          	slli	a4,s2,0x4
    80004e38:	02070713          	addi	a4,a4,32
    80004e3c:	00016797          	auipc	a5,0x16
    80004e40:	f9478793          	addi	a5,a5,-108 # 8001add0 <disk>
    80004e44:	97ba                	add	a5,a5,a4
    80004e46:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004e4a:	00016997          	auipc	s3,0x16
    80004e4e:	f8698993          	addi	s3,s3,-122 # 8001add0 <disk>
    80004e52:	00491713          	slli	a4,s2,0x4
    80004e56:	0009b783          	ld	a5,0(s3)
    80004e5a:	97ba                	add	a5,a5,a4
    80004e5c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004e60:	854a                	mv	a0,s2
    80004e62:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004e66:	bddff0ef          	jal	80004a42 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004e6a:	8885                	andi	s1,s1,1
    80004e6c:	f0fd                	bnez	s1,80004e52 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004e6e:	00016517          	auipc	a0,0x16
    80004e72:	08a50513          	addi	a0,a0,138 # 8001aef8 <disk+0x128>
    80004e76:	427000ef          	jal	80005a9c <release>
}
    80004e7a:	60e6                	ld	ra,88(sp)
    80004e7c:	6446                	ld	s0,80(sp)
    80004e7e:	64a6                	ld	s1,72(sp)
    80004e80:	6906                	ld	s2,64(sp)
    80004e82:	79e2                	ld	s3,56(sp)
    80004e84:	7a42                	ld	s4,48(sp)
    80004e86:	7aa2                	ld	s5,40(sp)
    80004e88:	7b02                	ld	s6,32(sp)
    80004e8a:	6be2                	ld	s7,24(sp)
    80004e8c:	6c42                	ld	s8,16(sp)
    80004e8e:	6125                	addi	sp,sp,96
    80004e90:	8082                	ret

0000000080004e92 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004e92:	1101                	addi	sp,sp,-32
    80004e94:	ec06                	sd	ra,24(sp)
    80004e96:	e822                	sd	s0,16(sp)
    80004e98:	e426                	sd	s1,8(sp)
    80004e9a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004e9c:	00016497          	auipc	s1,0x16
    80004ea0:	f3448493          	addi	s1,s1,-204 # 8001add0 <disk>
    80004ea4:	00016517          	auipc	a0,0x16
    80004ea8:	05450513          	addi	a0,a0,84 # 8001aef8 <disk+0x128>
    80004eac:	35d000ef          	jal	80005a08 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004eb0:	100017b7          	lui	a5,0x10001
    80004eb4:	53bc                	lw	a5,96(a5)
    80004eb6:	8b8d                	andi	a5,a5,3
    80004eb8:	10001737          	lui	a4,0x10001
    80004ebc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004ebe:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004ec2:	689c                	ld	a5,16(s1)
    80004ec4:	0204d703          	lhu	a4,32(s1)
    80004ec8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004ecc:	04f70863          	beq	a4,a5,80004f1c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004ed0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004ed4:	6898                	ld	a4,16(s1)
    80004ed6:	0204d783          	lhu	a5,32(s1)
    80004eda:	8b9d                	andi	a5,a5,7
    80004edc:	078e                	slli	a5,a5,0x3
    80004ede:	97ba                	add	a5,a5,a4
    80004ee0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004ee2:	00479713          	slli	a4,a5,0x4
    80004ee6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004eea:	9726                	add	a4,a4,s1
    80004eec:	01074703          	lbu	a4,16(a4)
    80004ef0:	e329                	bnez	a4,80004f32 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004ef2:	0792                	slli	a5,a5,0x4
    80004ef4:	02078793          	addi	a5,a5,32
    80004ef8:	97a6                	add	a5,a5,s1
    80004efa:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004efc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004f00:	d96fc0ef          	jal	80001496 <wakeup>

    disk.used_idx += 1;
    80004f04:	0204d783          	lhu	a5,32(s1)
    80004f08:	2785                	addiw	a5,a5,1
    80004f0a:	17c2                	slli	a5,a5,0x30
    80004f0c:	93c1                	srli	a5,a5,0x30
    80004f0e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004f12:	6898                	ld	a4,16(s1)
    80004f14:	00275703          	lhu	a4,2(a4)
    80004f18:	faf71ce3          	bne	a4,a5,80004ed0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004f1c:	00016517          	auipc	a0,0x16
    80004f20:	fdc50513          	addi	a0,a0,-36 # 8001aef8 <disk+0x128>
    80004f24:	379000ef          	jal	80005a9c <release>
}
    80004f28:	60e2                	ld	ra,24(sp)
    80004f2a:	6442                	ld	s0,16(sp)
    80004f2c:	64a2                	ld	s1,8(sp)
    80004f2e:	6105                	addi	sp,sp,32
    80004f30:	8082                	ret
      panic("virtio_disk_intr status");
    80004f32:	00002517          	auipc	a0,0x2
    80004f36:	77e50513          	addi	a0,a0,1918 # 800076b0 <etext+0x6b0>
    80004f3a:	00d000ef          	jal	80005746 <panic>

0000000080004f3e <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004f3e:	1141                	addi	sp,sp,-16
    80004f40:	e406                	sd	ra,8(sp)
    80004f42:	e022                	sd	s0,0(sp)
    80004f44:	0800                	addi	s0,sp,16
#define MIE_STIE (1L << 5)  // supervisor timer
static inline uint64
r_mie()
{
  uint64 x;
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004f46:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004f4a:	0207e793          	ori	a5,a5,32
}

static inline void 
w_mie(uint64 x)
{
  asm volatile("csrw mie, %0" : : "r" (x));
    80004f4e:	30479073          	csrw	mie,a5
static inline uint64
r_menvcfg()
{
  uint64 x;
  // asm volatile("csrr %0, menvcfg" : "=r" (x) );
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004f52:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004f56:	577d                	li	a4,-1
    80004f58:	177e                	slli	a4,a4,0x3f
    80004f5a:	8fd9                	or	a5,a5,a4

static inline void 
w_menvcfg(uint64 x)
{
  //asm volatile("csrw menvcfg, %0" : : "r" (x));
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004f5c:	30a79073          	csrw	0x30a,a5

static inline uint64
r_mcounteren()
{
  uint64 x;
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004f60:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004f64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004f68:	30679073          	csrw	mcounteren,a5
// machine-mode cycle counter
static inline uint64
r_time()
{
  uint64 x;
  asm volatile("csrr %0, time" : "=r" (x) );
    80004f6c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004f70:	000f4737          	lui	a4,0xf4
    80004f74:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004f78:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004f7a:	14d79073          	csrw	stimecmp,a5
}
    80004f7e:	60a2                	ld	ra,8(sp)
    80004f80:	6402                	ld	s0,0(sp)
    80004f82:	0141                	addi	sp,sp,16
    80004f84:	8082                	ret

0000000080004f86 <start>:
{
    80004f86:	1141                	addi	sp,sp,-16
    80004f88:	e406                	sd	ra,8(sp)
    80004f8a:	e022                	sd	s0,0(sp)
    80004f8c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004f8e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004f92:	7779                	lui	a4,0xffffe
    80004f94:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdb817>
    80004f98:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004f9a:	6705                	lui	a4,0x1
    80004f9c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004fa0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004fa2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004fa6:	ffffb797          	auipc	a5,0xffffb
    80004faa:	36e78793          	addi	a5,a5,878 # 80000314 <main>
    80004fae:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004fb2:	4781                	li	a5,0
    80004fb4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004fb8:	67c1                	lui	a5,0x10
    80004fba:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004fbc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004fc0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004fc4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004fc8:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004fcc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004fd0:	57fd                	li	a5,-1
    80004fd2:	83a9                	srli	a5,a5,0xa
    80004fd4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004fd8:	47bd                	li	a5,15
    80004fda:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004fde:	f61ff0ef          	jal	80004f3e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004fe2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004fe6:	2781                	sext.w	a5,a5
}

static inline void 
w_tp(uint64 x)
{
  asm volatile("mv tp, %0" : : "r" (x));
    80004fe8:	823e                	mv	tp,a5
  asm volatile("mret");
    80004fea:	30200073          	mret
}
    80004fee:	60a2                	ld	ra,8(sp)
    80004ff0:	6402                	ld	s0,0(sp)
    80004ff2:	0141                	addi	sp,sp,16
    80004ff4:	8082                	ret

0000000080004ff6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004ff6:	7119                	addi	sp,sp,-128
    80004ff8:	fc86                	sd	ra,120(sp)
    80004ffa:	f8a2                	sd	s0,112(sp)
    80004ffc:	f4a6                	sd	s1,104(sp)
    80004ffe:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005000:	06c05b63          	blez	a2,80005076 <consolewrite+0x80>
    80005004:	f0ca                	sd	s2,96(sp)
    80005006:	ecce                	sd	s3,88(sp)
    80005008:	e8d2                	sd	s4,80(sp)
    8000500a:	e4d6                	sd	s5,72(sp)
    8000500c:	e0da                	sd	s6,64(sp)
    8000500e:	fc5e                	sd	s7,56(sp)
    80005010:	f862                	sd	s8,48(sp)
    80005012:	f466                	sd	s9,40(sp)
    80005014:	f06a                	sd	s10,32(sp)
    80005016:	8b2a                	mv	s6,a0
    80005018:	8bae                	mv	s7,a1
    8000501a:	8a32                	mv	s4,a2
  int i = 0;
    8000501c:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    8000501e:	02000c93          	li	s9,32
    80005022:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005026:	f8040a93          	addi	s5,s0,-128
    8000502a:	5c7d                	li	s8,-1
    8000502c:	a025                	j	80005054 <consolewrite+0x5e>
    if(nn > n - i)
    8000502e:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005032:	86ce                	mv	a3,s3
    80005034:	01748633          	add	a2,s1,s7
    80005038:	85da                	mv	a1,s6
    8000503a:	8556                	mv	a0,s5
    8000503c:	fb2fc0ef          	jal	800017ee <either_copyin>
    80005040:	03850d63          	beq	a0,s8,8000507a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80005044:	85ce                	mv	a1,s3
    80005046:	8556                	mv	a0,s5
    80005048:	7b4000ef          	jal	800057fc <uartwrite>
    i += nn;
    8000504c:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005050:	0144d963          	bge	s1,s4,80005062 <consolewrite+0x6c>
    if(nn > n - i)
    80005054:	409a07bb          	subw	a5,s4,s1
    80005058:	893e                	mv	s2,a5
    8000505a:	fcfcdae3          	bge	s9,a5,8000502e <consolewrite+0x38>
    8000505e:	896a                	mv	s2,s10
    80005060:	b7f9                	j	8000502e <consolewrite+0x38>
    80005062:	7906                	ld	s2,96(sp)
    80005064:	69e6                	ld	s3,88(sp)
    80005066:	6a46                	ld	s4,80(sp)
    80005068:	6aa6                	ld	s5,72(sp)
    8000506a:	6b06                	ld	s6,64(sp)
    8000506c:	7be2                	ld	s7,56(sp)
    8000506e:	7c42                	ld	s8,48(sp)
    80005070:	7ca2                	ld	s9,40(sp)
    80005072:	7d02                	ld	s10,32(sp)
    80005074:	a821                	j	8000508c <consolewrite+0x96>
  int i = 0;
    80005076:	4481                	li	s1,0
    80005078:	a811                	j	8000508c <consolewrite+0x96>
    8000507a:	7906                	ld	s2,96(sp)
    8000507c:	69e6                	ld	s3,88(sp)
    8000507e:	6a46                	ld	s4,80(sp)
    80005080:	6aa6                	ld	s5,72(sp)
    80005082:	6b06                	ld	s6,64(sp)
    80005084:	7be2                	ld	s7,56(sp)
    80005086:	7c42                	ld	s8,48(sp)
    80005088:	7ca2                	ld	s9,40(sp)
    8000508a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000508c:	8526                	mv	a0,s1
    8000508e:	70e6                	ld	ra,120(sp)
    80005090:	7446                	ld	s0,112(sp)
    80005092:	74a6                	ld	s1,104(sp)
    80005094:	6109                	addi	sp,sp,128
    80005096:	8082                	ret

0000000080005098 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005098:	711d                	addi	sp,sp,-96
    8000509a:	ec86                	sd	ra,88(sp)
    8000509c:	e8a2                	sd	s0,80(sp)
    8000509e:	e4a6                	sd	s1,72(sp)
    800050a0:	e0ca                	sd	s2,64(sp)
    800050a2:	fc4e                	sd	s3,56(sp)
    800050a4:	f852                	sd	s4,48(sp)
    800050a6:	f05a                	sd	s6,32(sp)
    800050a8:	ec5e                	sd	s7,24(sp)
    800050aa:	1080                	addi	s0,sp,96
    800050ac:	8b2a                	mv	s6,a0
    800050ae:	8a2e                	mv	s4,a1
    800050b0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800050b2:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    800050b4:	0001e517          	auipc	a0,0x1e
    800050b8:	e5c50513          	addi	a0,a0,-420 # 80022f10 <cons>
    800050bc:	14d000ef          	jal	80005a08 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800050c0:	0001e497          	auipc	s1,0x1e
    800050c4:	e5048493          	addi	s1,s1,-432 # 80022f10 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800050c8:	0001e917          	auipc	s2,0x1e
    800050cc:	ee090913          	addi	s2,s2,-288 # 80022fa8 <cons+0x98>
  while(n > 0){
    800050d0:	0b305b63          	blez	s3,80005186 <consoleread+0xee>
    while(cons.r == cons.w){
    800050d4:	0984a783          	lw	a5,152(s1)
    800050d8:	09c4a703          	lw	a4,156(s1)
    800050dc:	0af71063          	bne	a4,a5,8000517c <consoleread+0xe4>
      if(killed(myproc())){
    800050e0:	cf7fb0ef          	jal	80000dd6 <myproc>
    800050e4:	da2fc0ef          	jal	80001686 <killed>
    800050e8:	e12d                	bnez	a0,8000514a <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800050ea:	85a6                	mv	a1,s1
    800050ec:	854a                	mv	a0,s2
    800050ee:	b5cfc0ef          	jal	8000144a <sleep>
    while(cons.r == cons.w){
    800050f2:	0984a783          	lw	a5,152(s1)
    800050f6:	09c4a703          	lw	a4,156(s1)
    800050fa:	fef703e3          	beq	a4,a5,800050e0 <consoleread+0x48>
    800050fe:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005100:	0001e717          	auipc	a4,0x1e
    80005104:	e1070713          	addi	a4,a4,-496 # 80022f10 <cons>
    80005108:	0017869b          	addiw	a3,a5,1
    8000510c:	08d72c23          	sw	a3,152(a4)
    80005110:	07f7f693          	andi	a3,a5,127
    80005114:	9736                	add	a4,a4,a3
    80005116:	01874703          	lbu	a4,24(a4)
    8000511a:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    8000511e:	4691                	li	a3,4
    80005120:	04da8663          	beq	s5,a3,8000516c <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005124:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005128:	4685                	li	a3,1
    8000512a:	faf40613          	addi	a2,s0,-81
    8000512e:	85d2                	mv	a1,s4
    80005130:	855a                	mv	a0,s6
    80005132:	e72fc0ef          	jal	800017a4 <either_copyout>
    80005136:	57fd                	li	a5,-1
    80005138:	04f50663          	beq	a0,a5,80005184 <consoleread+0xec>
      break;

    dst++;
    8000513c:	0a05                	addi	s4,s4,1
    --n;
    8000513e:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005140:	47a9                	li	a5,10
    80005142:	04fa8b63          	beq	s5,a5,80005198 <consoleread+0x100>
    80005146:	7aa2                	ld	s5,40(sp)
    80005148:	b761                	j	800050d0 <consoleread+0x38>
        release(&cons.lock);
    8000514a:	0001e517          	auipc	a0,0x1e
    8000514e:	dc650513          	addi	a0,a0,-570 # 80022f10 <cons>
    80005152:	14b000ef          	jal	80005a9c <release>
        return -1;
    80005156:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005158:	60e6                	ld	ra,88(sp)
    8000515a:	6446                	ld	s0,80(sp)
    8000515c:	64a6                	ld	s1,72(sp)
    8000515e:	6906                	ld	s2,64(sp)
    80005160:	79e2                	ld	s3,56(sp)
    80005162:	7a42                	ld	s4,48(sp)
    80005164:	7b02                	ld	s6,32(sp)
    80005166:	6be2                	ld	s7,24(sp)
    80005168:	6125                	addi	sp,sp,96
    8000516a:	8082                	ret
      if(n < target){
    8000516c:	0179fa63          	bgeu	s3,s7,80005180 <consoleread+0xe8>
        cons.r--;
    80005170:	0001e717          	auipc	a4,0x1e
    80005174:	e2f72c23          	sw	a5,-456(a4) # 80022fa8 <cons+0x98>
    80005178:	7aa2                	ld	s5,40(sp)
    8000517a:	a031                	j	80005186 <consoleread+0xee>
    8000517c:	f456                	sd	s5,40(sp)
    8000517e:	b749                	j	80005100 <consoleread+0x68>
    80005180:	7aa2                	ld	s5,40(sp)
    80005182:	a011                	j	80005186 <consoleread+0xee>
    80005184:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005186:	0001e517          	auipc	a0,0x1e
    8000518a:	d8a50513          	addi	a0,a0,-630 # 80022f10 <cons>
    8000518e:	10f000ef          	jal	80005a9c <release>
  return target - n;
    80005192:	413b853b          	subw	a0,s7,s3
    80005196:	b7c9                	j	80005158 <consoleread+0xc0>
    80005198:	7aa2                	ld	s5,40(sp)
    8000519a:	b7f5                	j	80005186 <consoleread+0xee>

000000008000519c <consputc>:
{
    8000519c:	1141                	addi	sp,sp,-16
    8000519e:	e406                	sd	ra,8(sp)
    800051a0:	e022                	sd	s0,0(sp)
    800051a2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800051a4:	10000793          	li	a5,256
    800051a8:	00f50863          	beq	a0,a5,800051b8 <consputc+0x1c>
    uartputc_sync(c);
    800051ac:	6e4000ef          	jal	80005890 <uartputc_sync>
}
    800051b0:	60a2                	ld	ra,8(sp)
    800051b2:	6402                	ld	s0,0(sp)
    800051b4:	0141                	addi	sp,sp,16
    800051b6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800051b8:	4521                	li	a0,8
    800051ba:	6d6000ef          	jal	80005890 <uartputc_sync>
    800051be:	02000513          	li	a0,32
    800051c2:	6ce000ef          	jal	80005890 <uartputc_sync>
    800051c6:	4521                	li	a0,8
    800051c8:	6c8000ef          	jal	80005890 <uartputc_sync>
    800051cc:	b7d5                	j	800051b0 <consputc+0x14>

00000000800051ce <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800051ce:	1101                	addi	sp,sp,-32
    800051d0:	ec06                	sd	ra,24(sp)
    800051d2:	e822                	sd	s0,16(sp)
    800051d4:	e426                	sd	s1,8(sp)
    800051d6:	1000                	addi	s0,sp,32
    800051d8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800051da:	0001e517          	auipc	a0,0x1e
    800051de:	d3650513          	addi	a0,a0,-714 # 80022f10 <cons>
    800051e2:	027000ef          	jal	80005a08 <acquire>

  switch(c){
    800051e6:	47d5                	li	a5,21
    800051e8:	08f48d63          	beq	s1,a5,80005282 <consoleintr+0xb4>
    800051ec:	0297c563          	blt	a5,s1,80005216 <consoleintr+0x48>
    800051f0:	47a1                	li	a5,8
    800051f2:	0ef48263          	beq	s1,a5,800052d6 <consoleintr+0x108>
    800051f6:	47c1                	li	a5,16
    800051f8:	10f49363          	bne	s1,a5,800052fe <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800051fc:	e3cfc0ef          	jal	80001838 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005200:	0001e517          	auipc	a0,0x1e
    80005204:	d1050513          	addi	a0,a0,-752 # 80022f10 <cons>
    80005208:	095000ef          	jal	80005a9c <release>
}
    8000520c:	60e2                	ld	ra,24(sp)
    8000520e:	6442                	ld	s0,16(sp)
    80005210:	64a2                	ld	s1,8(sp)
    80005212:	6105                	addi	sp,sp,32
    80005214:	8082                	ret
  switch(c){
    80005216:	07f00793          	li	a5,127
    8000521a:	0af48e63          	beq	s1,a5,800052d6 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000521e:	0001e717          	auipc	a4,0x1e
    80005222:	cf270713          	addi	a4,a4,-782 # 80022f10 <cons>
    80005226:	0a072783          	lw	a5,160(a4)
    8000522a:	09872703          	lw	a4,152(a4)
    8000522e:	9f99                	subw	a5,a5,a4
    80005230:	07f00713          	li	a4,127
    80005234:	fcf766e3          	bltu	a4,a5,80005200 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005238:	47b5                	li	a5,13
    8000523a:	0cf48563          	beq	s1,a5,80005304 <consoleintr+0x136>
      consputc(c);
    8000523e:	8526                	mv	a0,s1
    80005240:	f5dff0ef          	jal	8000519c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005244:	0001e717          	auipc	a4,0x1e
    80005248:	ccc70713          	addi	a4,a4,-820 # 80022f10 <cons>
    8000524c:	0a072683          	lw	a3,160(a4)
    80005250:	0016879b          	addiw	a5,a3,1
    80005254:	863e                	mv	a2,a5
    80005256:	0af72023          	sw	a5,160(a4)
    8000525a:	07f6f693          	andi	a3,a3,127
    8000525e:	9736                	add	a4,a4,a3
    80005260:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005264:	ff648713          	addi	a4,s1,-10
    80005268:	c371                	beqz	a4,8000532c <consoleintr+0x15e>
    8000526a:	14f1                	addi	s1,s1,-4
    8000526c:	c0e1                	beqz	s1,8000532c <consoleintr+0x15e>
    8000526e:	0001e717          	auipc	a4,0x1e
    80005272:	d3a72703          	lw	a4,-710(a4) # 80022fa8 <cons+0x98>
    80005276:	9f99                	subw	a5,a5,a4
    80005278:	08000713          	li	a4,128
    8000527c:	f8e792e3          	bne	a5,a4,80005200 <consoleintr+0x32>
    80005280:	a075                	j	8000532c <consoleintr+0x15e>
    80005282:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005284:	0001e717          	auipc	a4,0x1e
    80005288:	c8c70713          	addi	a4,a4,-884 # 80022f10 <cons>
    8000528c:	0a072783          	lw	a5,160(a4)
    80005290:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005294:	0001e497          	auipc	s1,0x1e
    80005298:	c7c48493          	addi	s1,s1,-900 # 80022f10 <cons>
    while(cons.e != cons.w &&
    8000529c:	4929                	li	s2,10
    8000529e:	02f70863          	beq	a4,a5,800052ce <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800052a2:	37fd                	addiw	a5,a5,-1
    800052a4:	07f7f713          	andi	a4,a5,127
    800052a8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800052aa:	01874703          	lbu	a4,24(a4)
    800052ae:	03270263          	beq	a4,s2,800052d2 <consoleintr+0x104>
      cons.e--;
    800052b2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800052b6:	10000513          	li	a0,256
    800052ba:	ee3ff0ef          	jal	8000519c <consputc>
    while(cons.e != cons.w &&
    800052be:	0a04a783          	lw	a5,160(s1)
    800052c2:	09c4a703          	lw	a4,156(s1)
    800052c6:	fcf71ee3          	bne	a4,a5,800052a2 <consoleintr+0xd4>
    800052ca:	6902                	ld	s2,0(sp)
    800052cc:	bf15                	j	80005200 <consoleintr+0x32>
    800052ce:	6902                	ld	s2,0(sp)
    800052d0:	bf05                	j	80005200 <consoleintr+0x32>
    800052d2:	6902                	ld	s2,0(sp)
    800052d4:	b735                	j	80005200 <consoleintr+0x32>
    if(cons.e != cons.w){
    800052d6:	0001e717          	auipc	a4,0x1e
    800052da:	c3a70713          	addi	a4,a4,-966 # 80022f10 <cons>
    800052de:	0a072783          	lw	a5,160(a4)
    800052e2:	09c72703          	lw	a4,156(a4)
    800052e6:	f0f70de3          	beq	a4,a5,80005200 <consoleintr+0x32>
      cons.e--;
    800052ea:	37fd                	addiw	a5,a5,-1
    800052ec:	0001e717          	auipc	a4,0x1e
    800052f0:	ccf72223          	sw	a5,-828(a4) # 80022fb0 <cons+0xa0>
      consputc(BACKSPACE);
    800052f4:	10000513          	li	a0,256
    800052f8:	ea5ff0ef          	jal	8000519c <consputc>
    800052fc:	b711                	j	80005200 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800052fe:	f00481e3          	beqz	s1,80005200 <consoleintr+0x32>
    80005302:	bf31                	j	8000521e <consoleintr+0x50>
      consputc(c);
    80005304:	4529                	li	a0,10
    80005306:	e97ff0ef          	jal	8000519c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000530a:	0001e797          	auipc	a5,0x1e
    8000530e:	c0678793          	addi	a5,a5,-1018 # 80022f10 <cons>
    80005312:	0a07a703          	lw	a4,160(a5)
    80005316:	0017069b          	addiw	a3,a4,1
    8000531a:	8636                	mv	a2,a3
    8000531c:	0ad7a023          	sw	a3,160(a5)
    80005320:	07f77713          	andi	a4,a4,127
    80005324:	97ba                	add	a5,a5,a4
    80005326:	4729                	li	a4,10
    80005328:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000532c:	0001e797          	auipc	a5,0x1e
    80005330:	c8c7a023          	sw	a2,-896(a5) # 80022fac <cons+0x9c>
        wakeup(&cons.r);
    80005334:	0001e517          	auipc	a0,0x1e
    80005338:	c7450513          	addi	a0,a0,-908 # 80022fa8 <cons+0x98>
    8000533c:	95afc0ef          	jal	80001496 <wakeup>
    80005340:	b5c1                	j	80005200 <consoleintr+0x32>

0000000080005342 <consoleinit>:

void
consoleinit(void)
{
    80005342:	1141                	addi	sp,sp,-16
    80005344:	e406                	sd	ra,8(sp)
    80005346:	e022                	sd	s0,0(sp)
    80005348:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000534a:	00002597          	auipc	a1,0x2
    8000534e:	37e58593          	addi	a1,a1,894 # 800076c8 <etext+0x6c8>
    80005352:	0001e517          	auipc	a0,0x1e
    80005356:	bbe50513          	addi	a0,a0,-1090 # 80022f10 <cons>
    8000535a:	624000ef          	jal	8000597e <initlock>

  uartinit();
    8000535e:	448000ef          	jal	800057a6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005362:	00015797          	auipc	a5,0x15
    80005366:	a1678793          	addi	a5,a5,-1514 # 80019d78 <devsw>
    8000536a:	00000717          	auipc	a4,0x0
    8000536e:	d2e70713          	addi	a4,a4,-722 # 80005098 <consoleread>
    80005372:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005374:	00000717          	auipc	a4,0x0
    80005378:	c8270713          	addi	a4,a4,-894 # 80004ff6 <consolewrite>
    8000537c:	ef98                	sd	a4,24(a5)
}
    8000537e:	60a2                	ld	ra,8(sp)
    80005380:	6402                	ld	s0,0(sp)
    80005382:	0141                	addi	sp,sp,16
    80005384:	8082                	ret

0000000080005386 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005386:	7139                	addi	sp,sp,-64
    80005388:	fc06                	sd	ra,56(sp)
    8000538a:	f822                	sd	s0,48(sp)
    8000538c:	f04a                	sd	s2,32(sp)
    8000538e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005390:	c219                	beqz	a2,80005396 <printint+0x10>
    80005392:	08054163          	bltz	a0,80005414 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005396:	4301                	li	t1,0

  i = 0;
    80005398:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000539c:	86ca                	mv	a3,s2
  i = 0;
    8000539e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800053a0:	00002817          	auipc	a6,0x2
    800053a4:	4e880813          	addi	a6,a6,1256 # 80007888 <digits>
    800053a8:	88ba                	mv	a7,a4
    800053aa:	0017061b          	addiw	a2,a4,1
    800053ae:	8732                	mv	a4,a2
    800053b0:	02b577b3          	remu	a5,a0,a1
    800053b4:	97c2                	add	a5,a5,a6
    800053b6:	0007c783          	lbu	a5,0(a5)
    800053ba:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800053be:	87aa                	mv	a5,a0
    800053c0:	02b55533          	divu	a0,a0,a1
    800053c4:	0685                	addi	a3,a3,1
    800053c6:	feb7f1e3          	bgeu	a5,a1,800053a8 <printint+0x22>

  if(sign)
    800053ca:	00030c63          	beqz	t1,800053e2 <printint+0x5c>
    buf[i++] = '-';
    800053ce:	fe060793          	addi	a5,a2,-32
    800053d2:	00878633          	add	a2,a5,s0
    800053d6:	02d00793          	li	a5,45
    800053da:	fef60423          	sb	a5,-24(a2)
    800053de:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800053e2:	02e05463          	blez	a4,8000540a <printint+0x84>
    800053e6:	f426                	sd	s1,40(sp)
    800053e8:	377d                	addiw	a4,a4,-1
    800053ea:	00e904b3          	add	s1,s2,a4
    800053ee:	197d                	addi	s2,s2,-1
    800053f0:	993a                	add	s2,s2,a4
    800053f2:	1702                	slli	a4,a4,0x20
    800053f4:	9301                	srli	a4,a4,0x20
    800053f6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800053fa:	0004c503          	lbu	a0,0(s1)
    800053fe:	d9fff0ef          	jal	8000519c <consputc>
  while(--i >= 0)
    80005402:	14fd                	addi	s1,s1,-1
    80005404:	ff249be3          	bne	s1,s2,800053fa <printint+0x74>
    80005408:	74a2                	ld	s1,40(sp)
}
    8000540a:	70e2                	ld	ra,56(sp)
    8000540c:	7442                	ld	s0,48(sp)
    8000540e:	7902                	ld	s2,32(sp)
    80005410:	6121                	addi	sp,sp,64
    80005412:	8082                	ret
    x = -xx;
    80005414:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005418:	4305                	li	t1,1
    x = -xx;
    8000541a:	bfbd                	j	80005398 <printint+0x12>

000000008000541c <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000541c:	7131                	addi	sp,sp,-192
    8000541e:	fc86                	sd	ra,120(sp)
    80005420:	f8a2                	sd	s0,112(sp)
    80005422:	f0ca                	sd	s2,96(sp)
    80005424:	0100                	addi	s0,sp,128
    80005426:	892a                	mv	s2,a0
    80005428:	e40c                	sd	a1,8(s0)
    8000542a:	e810                	sd	a2,16(s0)
    8000542c:	ec14                	sd	a3,24(s0)
    8000542e:	f018                	sd	a4,32(s0)
    80005430:	f41c                	sd	a5,40(s0)
    80005432:	03043823          	sd	a6,48(s0)
    80005436:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    8000543a:	00002797          	auipc	a5,0x2
    8000543e:	4967a783          	lw	a5,1174(a5) # 800078d0 <panicking>
    80005442:	cf9d                	beqz	a5,80005480 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005444:	00840793          	addi	a5,s0,8
    80005448:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000544c:	00094503          	lbu	a0,0(s2)
    80005450:	22050663          	beqz	a0,8000567c <printf+0x260>
    80005454:	f4a6                	sd	s1,104(sp)
    80005456:	ecce                	sd	s3,88(sp)
    80005458:	e8d2                	sd	s4,80(sp)
    8000545a:	e4d6                	sd	s5,72(sp)
    8000545c:	e0da                	sd	s6,64(sp)
    8000545e:	fc5e                	sd	s7,56(sp)
    80005460:	f862                	sd	s8,48(sp)
    80005462:	f06a                	sd	s10,32(sp)
    80005464:	ec6e                	sd	s11,24(sp)
    80005466:	4a01                	li	s4,0
    if(cx != '%'){
    80005468:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000546c:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005470:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005474:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80005478:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000547a:	06400b93          	li	s7,100
    8000547e:	a015                	j	800054a2 <printf+0x86>
    acquire(&pr.lock);
    80005480:	0001e517          	auipc	a0,0x1e
    80005484:	b3850513          	addi	a0,a0,-1224 # 80022fb8 <pr>
    80005488:	580000ef          	jal	80005a08 <acquire>
    8000548c:	bf65                	j	80005444 <printf+0x28>
      consputc(cx);
    8000548e:	d0fff0ef          	jal	8000519c <consputc>
      continue;
    80005492:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005494:	2485                	addiw	s1,s1,1
    80005496:	8a26                	mv	s4,s1
    80005498:	94ca                	add	s1,s1,s2
    8000549a:	0004c503          	lbu	a0,0(s1)
    8000549e:	1c050663          	beqz	a0,8000566a <printf+0x24e>
    if(cx != '%'){
    800054a2:	ff3516e3          	bne	a0,s3,8000548e <printf+0x72>
    i++;
    800054a6:	001a079b          	addiw	a5,s4,1
    800054aa:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800054ac:	00f90733          	add	a4,s2,a5
    800054b0:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800054b4:	200a8963          	beqz	s5,800056c6 <printf+0x2aa>
    800054b8:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    800054bc:	1e068c63          	beqz	a3,800056b4 <printf+0x298>
    if(c0 == 'd'){
    800054c0:	037a8863          	beq	s5,s7,800054f0 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800054c4:	f94a8713          	addi	a4,s5,-108
    800054c8:	00173713          	seqz	a4,a4
    800054cc:	f9c68613          	addi	a2,a3,-100
    800054d0:	ee05                	bnez	a2,80005508 <printf+0xec>
    800054d2:	cb1d                	beqz	a4,80005508 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800054d4:	f8843783          	ld	a5,-120(s0)
    800054d8:	00878713          	addi	a4,a5,8
    800054dc:	f8e43423          	sd	a4,-120(s0)
    800054e0:	4605                	li	a2,1
    800054e2:	85da                	mv	a1,s6
    800054e4:	6388                	ld	a0,0(a5)
    800054e6:	ea1ff0ef          	jal	80005386 <printint>
      i += 1;
    800054ea:	002a049b          	addiw	s1,s4,2
    800054ee:	b75d                	j	80005494 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800054f0:	f8843783          	ld	a5,-120(s0)
    800054f4:	00878713          	addi	a4,a5,8
    800054f8:	f8e43423          	sd	a4,-120(s0)
    800054fc:	4605                	li	a2,1
    800054fe:	85da                	mv	a1,s6
    80005500:	4388                	lw	a0,0(a5)
    80005502:	e85ff0ef          	jal	80005386 <printint>
    80005506:	b779                	j	80005494 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    80005508:	97ca                	add	a5,a5,s2
    8000550a:	8636                	mv	a2,a3
    8000550c:	0027c683          	lbu	a3,2(a5)
    80005510:	a2c9                	j	800056d2 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005512:	f8843783          	ld	a5,-120(s0)
    80005516:	00878713          	addi	a4,a5,8
    8000551a:	f8e43423          	sd	a4,-120(s0)
    8000551e:	4605                	li	a2,1
    80005520:	45a9                	li	a1,10
    80005522:	6388                	ld	a0,0(a5)
    80005524:	e63ff0ef          	jal	80005386 <printint>
      i += 2;
    80005528:	003a049b          	addiw	s1,s4,3
    8000552c:	b7a5                	j	80005494 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000552e:	f8843783          	ld	a5,-120(s0)
    80005532:	00878713          	addi	a4,a5,8
    80005536:	f8e43423          	sd	a4,-120(s0)
    8000553a:	4601                	li	a2,0
    8000553c:	85da                	mv	a1,s6
    8000553e:	0007e503          	lwu	a0,0(a5)
    80005542:	e45ff0ef          	jal	80005386 <printint>
    80005546:	b7b9                	j	80005494 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005548:	f8843783          	ld	a5,-120(s0)
    8000554c:	00878713          	addi	a4,a5,8
    80005550:	f8e43423          	sd	a4,-120(s0)
    80005554:	4601                	li	a2,0
    80005556:	85da                	mv	a1,s6
    80005558:	6388                	ld	a0,0(a5)
    8000555a:	e2dff0ef          	jal	80005386 <printint>
      i += 1;
    8000555e:	002a049b          	addiw	s1,s4,2
    80005562:	bf0d                	j	80005494 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005564:	f8843783          	ld	a5,-120(s0)
    80005568:	00878713          	addi	a4,a5,8
    8000556c:	f8e43423          	sd	a4,-120(s0)
    80005570:	4601                	li	a2,0
    80005572:	45a9                	li	a1,10
    80005574:	6388                	ld	a0,0(a5)
    80005576:	e11ff0ef          	jal	80005386 <printint>
      i += 2;
    8000557a:	003a049b          	addiw	s1,s4,3
    8000557e:	bf19                	j	80005494 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005580:	f8843783          	ld	a5,-120(s0)
    80005584:	00878713          	addi	a4,a5,8
    80005588:	f8e43423          	sd	a4,-120(s0)
    8000558c:	4601                	li	a2,0
    8000558e:	45c1                	li	a1,16
    80005590:	0007e503          	lwu	a0,0(a5)
    80005594:	df3ff0ef          	jal	80005386 <printint>
    80005598:	bdf5                	j	80005494 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    8000559a:	f8843783          	ld	a5,-120(s0)
    8000559e:	00878713          	addi	a4,a5,8
    800055a2:	f8e43423          	sd	a4,-120(s0)
    800055a6:	45c1                	li	a1,16
    800055a8:	6388                	ld	a0,0(a5)
    800055aa:	dddff0ef          	jal	80005386 <printint>
      i += 1;
    800055ae:	002a049b          	addiw	s1,s4,2
    800055b2:	b5cd                	j	80005494 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800055b4:	f8843783          	ld	a5,-120(s0)
    800055b8:	00878713          	addi	a4,a5,8
    800055bc:	f8e43423          	sd	a4,-120(s0)
    800055c0:	4601                	li	a2,0
    800055c2:	45c1                	li	a1,16
    800055c4:	6388                	ld	a0,0(a5)
    800055c6:	dc1ff0ef          	jal	80005386 <printint>
      i += 2;
    800055ca:	003a049b          	addiw	s1,s4,3
    800055ce:	b5d9                	j	80005494 <printf+0x78>
    800055d0:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800055d2:	f8843783          	ld	a5,-120(s0)
    800055d6:	00878713          	addi	a4,a5,8
    800055da:	f8e43423          	sd	a4,-120(s0)
    800055de:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800055e2:	03000513          	li	a0,48
    800055e6:	bb7ff0ef          	jal	8000519c <consputc>
  consputc('x');
    800055ea:	07800513          	li	a0,120
    800055ee:	bafff0ef          	jal	8000519c <consputc>
    800055f2:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800055f4:	00002c97          	auipc	s9,0x2
    800055f8:	294c8c93          	addi	s9,s9,660 # 80007888 <digits>
    800055fc:	03cad793          	srli	a5,s5,0x3c
    80005600:	97e6                	add	a5,a5,s9
    80005602:	0007c503          	lbu	a0,0(a5)
    80005606:	b97ff0ef          	jal	8000519c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000560a:	0a92                	slli	s5,s5,0x4
    8000560c:	3a7d                	addiw	s4,s4,-1
    8000560e:	fe0a17e3          	bnez	s4,800055fc <printf+0x1e0>
    80005612:	7ca2                	ld	s9,40(sp)
    80005614:	b541                	j	80005494 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80005616:	f8843783          	ld	a5,-120(s0)
    8000561a:	00878713          	addi	a4,a5,8
    8000561e:	f8e43423          	sd	a4,-120(s0)
    80005622:	4388                	lw	a0,0(a5)
    80005624:	b79ff0ef          	jal	8000519c <consputc>
    80005628:	b5b5                	j	80005494 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    8000562a:	f8843783          	ld	a5,-120(s0)
    8000562e:	00878713          	addi	a4,a5,8
    80005632:	f8e43423          	sd	a4,-120(s0)
    80005636:	0007ba03          	ld	s4,0(a5)
    8000563a:	000a0d63          	beqz	s4,80005654 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000563e:	000a4503          	lbu	a0,0(s4)
    80005642:	e40509e3          	beqz	a0,80005494 <printf+0x78>
        consputc(*s);
    80005646:	b57ff0ef          	jal	8000519c <consputc>
      for(; *s; s++)
    8000564a:	0a05                	addi	s4,s4,1
    8000564c:	000a4503          	lbu	a0,0(s4)
    80005650:	f97d                	bnez	a0,80005646 <printf+0x22a>
    80005652:	b589                	j	80005494 <printf+0x78>
        s = "(null)";
    80005654:	00002a17          	auipc	s4,0x2
    80005658:	07ca0a13          	addi	s4,s4,124 # 800076d0 <etext+0x6d0>
      for(; *s; s++)
    8000565c:	02800513          	li	a0,40
    80005660:	b7dd                	j	80005646 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005662:	8556                	mv	a0,s5
    80005664:	b39ff0ef          	jal	8000519c <consputc>
    80005668:	b535                	j	80005494 <printf+0x78>
    8000566a:	74a6                	ld	s1,104(sp)
    8000566c:	69e6                	ld	s3,88(sp)
    8000566e:	6a46                	ld	s4,80(sp)
    80005670:	6aa6                	ld	s5,72(sp)
    80005672:	6b06                	ld	s6,64(sp)
    80005674:	7be2                	ld	s7,56(sp)
    80005676:	7c42                	ld	s8,48(sp)
    80005678:	7d02                	ld	s10,32(sp)
    8000567a:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000567c:	00002797          	auipc	a5,0x2
    80005680:	2547a783          	lw	a5,596(a5) # 800078d0 <panicking>
    80005684:	c38d                	beqz	a5,800056a6 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80005686:	4501                	li	a0,0
    80005688:	70e6                	ld	ra,120(sp)
    8000568a:	7446                	ld	s0,112(sp)
    8000568c:	7906                	ld	s2,96(sp)
    8000568e:	6129                	addi	sp,sp,192
    80005690:	8082                	ret
    80005692:	74a6                	ld	s1,104(sp)
    80005694:	69e6                	ld	s3,88(sp)
    80005696:	6a46                	ld	s4,80(sp)
    80005698:	6aa6                	ld	s5,72(sp)
    8000569a:	6b06                	ld	s6,64(sp)
    8000569c:	7be2                	ld	s7,56(sp)
    8000569e:	7c42                	ld	s8,48(sp)
    800056a0:	7d02                	ld	s10,32(sp)
    800056a2:	6de2                	ld	s11,24(sp)
    800056a4:	bfe1                	j	8000567c <printf+0x260>
    release(&pr.lock);
    800056a6:	0001e517          	auipc	a0,0x1e
    800056aa:	91250513          	addi	a0,a0,-1774 # 80022fb8 <pr>
    800056ae:	3ee000ef          	jal	80005a9c <release>
  return 0;
    800056b2:	bfd1                	j	80005686 <printf+0x26a>
    if(c0 == 'd'){
    800056b4:	e37a8ee3          	beq	s5,s7,800054f0 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800056b8:	f94a8713          	addi	a4,s5,-108
    800056bc:	00173713          	seqz	a4,a4
    800056c0:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800056c2:	4781                	li	a5,0
    800056c4:	a00d                	j	800056e6 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800056c6:	f94a8713          	addi	a4,s5,-108
    800056ca:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800056ce:	8656                	mv	a2,s5
    800056d0:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800056d2:	f9460793          	addi	a5,a2,-108
    800056d6:	0017b793          	seqz	a5,a5
    800056da:	8ff9                	and	a5,a5,a4
    800056dc:	f9c68593          	addi	a1,a3,-100
    800056e0:	e199                	bnez	a1,800056e6 <printf+0x2ca>
    800056e2:	e20798e3          	bnez	a5,80005512 <printf+0xf6>
    } else if(c0 == 'u'){
    800056e6:	e58a84e3          	beq	s5,s8,8000552e <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    800056ea:	f8b60593          	addi	a1,a2,-117
    800056ee:	e199                	bnez	a1,800056f4 <printf+0x2d8>
    800056f0:	e4071ce3          	bnez	a4,80005548 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800056f4:	f8b68593          	addi	a1,a3,-117
    800056f8:	e199                	bnez	a1,800056fe <printf+0x2e2>
    800056fa:	e60795e3          	bnez	a5,80005564 <printf+0x148>
    } else if(c0 == 'x'){
    800056fe:	e9aa81e3          	beq	s5,s10,80005580 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    80005702:	f8860613          	addi	a2,a2,-120
    80005706:	e219                	bnez	a2,8000570c <printf+0x2f0>
    80005708:	e80719e3          	bnez	a4,8000559a <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000570c:	f8868693          	addi	a3,a3,-120
    80005710:	e299                	bnez	a3,80005716 <printf+0x2fa>
    80005712:	ea0791e3          	bnez	a5,800055b4 <printf+0x198>
    } else if(c0 == 'p'){
    80005716:	ebba8de3          	beq	s5,s11,800055d0 <printf+0x1b4>
    } else if(c0 == 'c'){
    8000571a:	06300793          	li	a5,99
    8000571e:	eefa8ce3          	beq	s5,a5,80005616 <printf+0x1fa>
    } else if(c0 == 's'){
    80005722:	07300793          	li	a5,115
    80005726:	f0fa82e3          	beq	s5,a5,8000562a <printf+0x20e>
    } else if(c0 == '%'){
    8000572a:	02500793          	li	a5,37
    8000572e:	f2fa8ae3          	beq	s5,a5,80005662 <printf+0x246>
    } else if(c0 == 0){
    80005732:	f60a80e3          	beqz	s5,80005692 <printf+0x276>
      consputc('%');
    80005736:	02500513          	li	a0,37
    8000573a:	a63ff0ef          	jal	8000519c <consputc>
      consputc(c0);
    8000573e:	8556                	mv	a0,s5
    80005740:	a5dff0ef          	jal	8000519c <consputc>
    80005744:	bb81                	j	80005494 <printf+0x78>

0000000080005746 <panic>:

void
panic(char *s)
{
    80005746:	1101                	addi	sp,sp,-32
    80005748:	ec06                	sd	ra,24(sp)
    8000574a:	e822                	sd	s0,16(sp)
    8000574c:	e426                	sd	s1,8(sp)
    8000574e:	e04a                	sd	s2,0(sp)
    80005750:	1000                	addi	s0,sp,32
    80005752:	892a                	mv	s2,a0
  panicking = 1;
    80005754:	4485                	li	s1,1
    80005756:	00002797          	auipc	a5,0x2
    8000575a:	1697ad23          	sw	s1,378(a5) # 800078d0 <panicking>
  printf("panic: ");
    8000575e:	00002517          	auipc	a0,0x2
    80005762:	f7a50513          	addi	a0,a0,-134 # 800076d8 <etext+0x6d8>
    80005766:	cb7ff0ef          	jal	8000541c <printf>
  printf("%s\n", s);
    8000576a:	85ca                	mv	a1,s2
    8000576c:	00002517          	auipc	a0,0x2
    80005770:	f7450513          	addi	a0,a0,-140 # 800076e0 <etext+0x6e0>
    80005774:	ca9ff0ef          	jal	8000541c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005778:	00002797          	auipc	a5,0x2
    8000577c:	1497aa23          	sw	s1,340(a5) # 800078cc <panicked>
  for(;;)
    80005780:	a001                	j	80005780 <panic+0x3a>

0000000080005782 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005782:	1141                	addi	sp,sp,-16
    80005784:	e406                	sd	ra,8(sp)
    80005786:	e022                	sd	s0,0(sp)
    80005788:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000578a:	00002597          	auipc	a1,0x2
    8000578e:	f5e58593          	addi	a1,a1,-162 # 800076e8 <etext+0x6e8>
    80005792:	0001e517          	auipc	a0,0x1e
    80005796:	82650513          	addi	a0,a0,-2010 # 80022fb8 <pr>
    8000579a:	1e4000ef          	jal	8000597e <initlock>
}
    8000579e:	60a2                	ld	ra,8(sp)
    800057a0:	6402                	ld	s0,0(sp)
    800057a2:	0141                	addi	sp,sp,16
    800057a4:	8082                	ret

00000000800057a6 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    800057a6:	1141                	addi	sp,sp,-16
    800057a8:	e406                	sd	ra,8(sp)
    800057aa:	e022                	sd	s0,0(sp)
    800057ac:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800057ae:	100007b7          	lui	a5,0x10000
    800057b2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800057b6:	10000737          	lui	a4,0x10000
    800057ba:	f8000693          	li	a3,-128
    800057be:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800057c2:	468d                	li	a3,3
    800057c4:	10000637          	lui	a2,0x10000
    800057c8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800057cc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800057d0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800057d4:	8732                	mv	a4,a2
    800057d6:	461d                	li	a2,7
    800057d8:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800057dc:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800057e0:	00002597          	auipc	a1,0x2
    800057e4:	f1058593          	addi	a1,a1,-240 # 800076f0 <etext+0x6f0>
    800057e8:	0001d517          	auipc	a0,0x1d
    800057ec:	7e850513          	addi	a0,a0,2024 # 80022fd0 <tx_lock>
    800057f0:	18e000ef          	jal	8000597e <initlock>
}
    800057f4:	60a2                	ld	ra,8(sp)
    800057f6:	6402                	ld	s0,0(sp)
    800057f8:	0141                	addi	sp,sp,16
    800057fa:	8082                	ret

00000000800057fc <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800057fc:	715d                	addi	sp,sp,-80
    800057fe:	e486                	sd	ra,72(sp)
    80005800:	e0a2                	sd	s0,64(sp)
    80005802:	fc26                	sd	s1,56(sp)
    80005804:	ec56                	sd	s5,24(sp)
    80005806:	0880                	addi	s0,sp,80
    80005808:	8aaa                	mv	s5,a0
    8000580a:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    8000580c:	0001d517          	auipc	a0,0x1d
    80005810:	7c450513          	addi	a0,a0,1988 # 80022fd0 <tx_lock>
    80005814:	1f4000ef          	jal	80005a08 <acquire>

  int i = 0;
  while(i < n){ 
    80005818:	06905063          	blez	s1,80005878 <uartwrite+0x7c>
    8000581c:	f84a                	sd	s2,48(sp)
    8000581e:	f44e                	sd	s3,40(sp)
    80005820:	f052                	sd	s4,32(sp)
    80005822:	e85a                	sd	s6,16(sp)
    80005824:	e45e                	sd	s7,8(sp)
    80005826:	8a56                	mv	s4,s5
    80005828:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    8000582a:	00002497          	auipc	s1,0x2
    8000582e:	0ae48493          	addi	s1,s1,174 # 800078d8 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005832:	0001d997          	auipc	s3,0x1d
    80005836:	79e98993          	addi	s3,s3,1950 # 80022fd0 <tx_lock>
    8000583a:	00002917          	auipc	s2,0x2
    8000583e:	09a90913          	addi	s2,s2,154 # 800078d4 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005842:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005846:	4b05                	li	s6,1
    80005848:	a005                	j	80005868 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    8000584a:	85ce                	mv	a1,s3
    8000584c:	854a                	mv	a0,s2
    8000584e:	bfdfb0ef          	jal	8000144a <sleep>
    while(tx_busy != 0){
    80005852:	409c                	lw	a5,0(s1)
    80005854:	fbfd                	bnez	a5,8000584a <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005856:	000a4783          	lbu	a5,0(s4)
    8000585a:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000585e:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005862:	0a05                	addi	s4,s4,1
    80005864:	015a0563          	beq	s4,s5,8000586e <uartwrite+0x72>
    while(tx_busy != 0){
    80005868:	409c                	lw	a5,0(s1)
    8000586a:	f3e5                	bnez	a5,8000584a <uartwrite+0x4e>
    8000586c:	b7ed                	j	80005856 <uartwrite+0x5a>
    8000586e:	7942                	ld	s2,48(sp)
    80005870:	79a2                	ld	s3,40(sp)
    80005872:	7a02                	ld	s4,32(sp)
    80005874:	6b42                	ld	s6,16(sp)
    80005876:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005878:	0001d517          	auipc	a0,0x1d
    8000587c:	75850513          	addi	a0,a0,1880 # 80022fd0 <tx_lock>
    80005880:	21c000ef          	jal	80005a9c <release>
}
    80005884:	60a6                	ld	ra,72(sp)
    80005886:	6406                	ld	s0,64(sp)
    80005888:	74e2                	ld	s1,56(sp)
    8000588a:	6ae2                	ld	s5,24(sp)
    8000588c:	6161                	addi	sp,sp,80
    8000588e:	8082                	ret

0000000080005890 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005890:	1101                	addi	sp,sp,-32
    80005892:	ec06                	sd	ra,24(sp)
    80005894:	e822                	sd	s0,16(sp)
    80005896:	e426                	sd	s1,8(sp)
    80005898:	1000                	addi	s0,sp,32
    8000589a:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000589c:	00002797          	auipc	a5,0x2
    800058a0:	0347a783          	lw	a5,52(a5) # 800078d0 <panicking>
    800058a4:	cf95                	beqz	a5,800058e0 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    800058a6:	00002797          	auipc	a5,0x2
    800058aa:	0267a783          	lw	a5,38(a5) # 800078cc <panicked>
    800058ae:	ef85                	bnez	a5,800058e6 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800058b0:	10000737          	lui	a4,0x10000
    800058b4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800058b6:	00074783          	lbu	a5,0(a4)
    800058ba:	0207f793          	andi	a5,a5,32
    800058be:	dfe5                	beqz	a5,800058b6 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    800058c0:	0ff4f513          	zext.b	a0,s1
    800058c4:	100007b7          	lui	a5,0x10000
    800058c8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800058cc:	00002797          	auipc	a5,0x2
    800058d0:	0047a783          	lw	a5,4(a5) # 800078d0 <panicking>
    800058d4:	cb91                	beqz	a5,800058e8 <uartputc_sync+0x58>
    pop_off();
}
    800058d6:	60e2                	ld	ra,24(sp)
    800058d8:	6442                	ld	s0,16(sp)
    800058da:	64a2                	ld	s1,8(sp)
    800058dc:	6105                	addi	sp,sp,32
    800058de:	8082                	ret
    push_off();
    800058e0:	0e4000ef          	jal	800059c4 <push_off>
    800058e4:	b7c9                	j	800058a6 <uartputc_sync+0x16>
    for(;;)
    800058e6:	a001                	j	800058e6 <uartputc_sync+0x56>
    pop_off();
    800058e8:	164000ef          	jal	80005a4c <pop_off>
}
    800058ec:	b7ed                	j	800058d6 <uartputc_sync+0x46>

00000000800058ee <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800058ee:	1141                	addi	sp,sp,-16
    800058f0:	e406                	sd	ra,8(sp)
    800058f2:	e022                	sd	s0,0(sp)
    800058f4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800058f6:	100007b7          	lui	a5,0x10000
    800058fa:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800058fe:	8b85                	andi	a5,a5,1
    80005900:	cb89                	beqz	a5,80005912 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005902:	100007b7          	lui	a5,0x10000
    80005906:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000590a:	60a2                	ld	ra,8(sp)
    8000590c:	6402                	ld	s0,0(sp)
    8000590e:	0141                	addi	sp,sp,16
    80005910:	8082                	ret
    return -1;
    80005912:	557d                	li	a0,-1
    80005914:	bfdd                	j	8000590a <uartgetc+0x1c>

0000000080005916 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005916:	1101                	addi	sp,sp,-32
    80005918:	ec06                	sd	ra,24(sp)
    8000591a:	e822                	sd	s0,16(sp)
    8000591c:	e426                	sd	s1,8(sp)
    8000591e:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005920:	100007b7          	lui	a5,0x10000
    80005924:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005928:	0001d517          	auipc	a0,0x1d
    8000592c:	6a850513          	addi	a0,a0,1704 # 80022fd0 <tx_lock>
    80005930:	0d8000ef          	jal	80005a08 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005934:	100007b7          	lui	a5,0x10000
    80005938:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000593c:	0207f793          	andi	a5,a5,32
    80005940:	ef99                	bnez	a5,8000595e <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005942:	0001d517          	auipc	a0,0x1d
    80005946:	68e50513          	addi	a0,a0,1678 # 80022fd0 <tx_lock>
    8000594a:	152000ef          	jal	80005a9c <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000594e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005950:	f9fff0ef          	jal	800058ee <uartgetc>
    if(c == -1)
    80005954:	02950063          	beq	a0,s1,80005974 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005958:	877ff0ef          	jal	800051ce <consoleintr>
  while(1){
    8000595c:	bfd5                	j	80005950 <uartintr+0x3a>
    tx_busy = 0;
    8000595e:	00002797          	auipc	a5,0x2
    80005962:	f607ad23          	sw	zero,-134(a5) # 800078d8 <tx_busy>
    wakeup(&tx_chan);
    80005966:	00002517          	auipc	a0,0x2
    8000596a:	f6e50513          	addi	a0,a0,-146 # 800078d4 <tx_chan>
    8000596e:	b29fb0ef          	jal	80001496 <wakeup>
    80005972:	bfc1                	j	80005942 <uartintr+0x2c>
  }
}
    80005974:	60e2                	ld	ra,24(sp)
    80005976:	6442                	ld	s0,16(sp)
    80005978:	64a2                	ld	s1,8(sp)
    8000597a:	6105                	addi	sp,sp,32
    8000597c:	8082                	ret

000000008000597e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000597e:	1141                	addi	sp,sp,-16
    80005980:	e406                	sd	ra,8(sp)
    80005982:	e022                	sd	s0,0(sp)
    80005984:	0800                	addi	s0,sp,16
  lk->name = name;
    80005986:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005988:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000598c:	00053823          	sd	zero,16(a0)
}
    80005990:	60a2                	ld	ra,8(sp)
    80005992:	6402                	ld	s0,0(sp)
    80005994:	0141                	addi	sp,sp,16
    80005996:	8082                	ret

0000000080005998 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005998:	411c                	lw	a5,0(a0)
    8000599a:	e399                	bnez	a5,800059a0 <holding+0x8>
    8000599c:	4501                	li	a0,0
  return r;
}
    8000599e:	8082                	ret
{
    800059a0:	1101                	addi	sp,sp,-32
    800059a2:	ec06                	sd	ra,24(sp)
    800059a4:	e822                	sd	s0,16(sp)
    800059a6:	e426                	sd	s1,8(sp)
    800059a8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800059aa:	691c                	ld	a5,16(a0)
    800059ac:	84be                	mv	s1,a5
    800059ae:	c08fb0ef          	jal	80000db6 <mycpu>
    800059b2:	40a48533          	sub	a0,s1,a0
    800059b6:	00153513          	seqz	a0,a0
}
    800059ba:	60e2                	ld	ra,24(sp)
    800059bc:	6442                	ld	s0,16(sp)
    800059be:	64a2                	ld	s1,8(sp)
    800059c0:	6105                	addi	sp,sp,32
    800059c2:	8082                	ret

00000000800059c4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800059c4:	1101                	addi	sp,sp,-32
    800059c6:	ec06                	sd	ra,24(sp)
    800059c8:	e822                	sd	s0,16(sp)
    800059ca:	e426                	sd	s1,8(sp)
    800059cc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800059ce:	100027f3          	csrr	a5,sstatus
    800059d2:	84be                	mv	s1,a5
    800059d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800059d8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800059da:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    800059de:	bd8fb0ef          	jal	80000db6 <mycpu>
    800059e2:	5d3c                	lw	a5,120(a0)
    800059e4:	cb99                	beqz	a5,800059fa <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800059e6:	bd0fb0ef          	jal	80000db6 <mycpu>
    800059ea:	5d3c                	lw	a5,120(a0)
    800059ec:	2785                	addiw	a5,a5,1
    800059ee:	dd3c                	sw	a5,120(a0)
}
    800059f0:	60e2                	ld	ra,24(sp)
    800059f2:	6442                	ld	s0,16(sp)
    800059f4:	64a2                	ld	s1,8(sp)
    800059f6:	6105                	addi	sp,sp,32
    800059f8:	8082                	ret
    mycpu()->intena = old;
    800059fa:	bbcfb0ef          	jal	80000db6 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800059fe:	0014d793          	srli	a5,s1,0x1
    80005a02:	8b85                	andi	a5,a5,1
    80005a04:	dd7c                	sw	a5,124(a0)
    80005a06:	b7c5                	j	800059e6 <push_off+0x22>

0000000080005a08 <acquire>:
{
    80005a08:	1101                	addi	sp,sp,-32
    80005a0a:	ec06                	sd	ra,24(sp)
    80005a0c:	e822                	sd	s0,16(sp)
    80005a0e:	e426                	sd	s1,8(sp)
    80005a10:	1000                	addi	s0,sp,32
    80005a12:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005a14:	fb1ff0ef          	jal	800059c4 <push_off>
  if(holding(lk))
    80005a18:	8526                	mv	a0,s1
    80005a1a:	f7fff0ef          	jal	80005998 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a1e:	4705                	li	a4,1
  if(holding(lk))
    80005a20:	e105                	bnez	a0,80005a40 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a22:	87ba                	mv	a5,a4
    80005a24:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005a28:	2781                	sext.w	a5,a5
    80005a2a:	ffe5                	bnez	a5,80005a22 <acquire+0x1a>
  __sync_synchronize();
    80005a2c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005a30:	b86fb0ef          	jal	80000db6 <mycpu>
    80005a34:	e888                	sd	a0,16(s1)
}
    80005a36:	60e2                	ld	ra,24(sp)
    80005a38:	6442                	ld	s0,16(sp)
    80005a3a:	64a2                	ld	s1,8(sp)
    80005a3c:	6105                	addi	sp,sp,32
    80005a3e:	8082                	ret
    panic("acquire");
    80005a40:	00002517          	auipc	a0,0x2
    80005a44:	cb850513          	addi	a0,a0,-840 # 800076f8 <etext+0x6f8>
    80005a48:	cffff0ef          	jal	80005746 <panic>

0000000080005a4c <pop_off>:

void
pop_off(void)
{
    80005a4c:	1141                	addi	sp,sp,-16
    80005a4e:	e406                	sd	ra,8(sp)
    80005a50:	e022                	sd	s0,0(sp)
    80005a52:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005a54:	b62fb0ef          	jal	80000db6 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a58:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005a5c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005a5e:	e39d                	bnez	a5,80005a84 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005a60:	5d3c                	lw	a5,120(a0)
    80005a62:	02f05763          	blez	a5,80005a90 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005a66:	37fd                	addiw	a5,a5,-1
    80005a68:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005a6a:	eb89                	bnez	a5,80005a7c <pop_off+0x30>
    80005a6c:	5d7c                	lw	a5,124(a0)
    80005a6e:	c799                	beqz	a5,80005a7c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a70:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005a74:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005a78:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005a7c:	60a2                	ld	ra,8(sp)
    80005a7e:	6402                	ld	s0,0(sp)
    80005a80:	0141                	addi	sp,sp,16
    80005a82:	8082                	ret
    panic("pop_off - interruptible");
    80005a84:	00002517          	auipc	a0,0x2
    80005a88:	c7c50513          	addi	a0,a0,-900 # 80007700 <etext+0x700>
    80005a8c:	cbbff0ef          	jal	80005746 <panic>
    panic("pop_off");
    80005a90:	00002517          	auipc	a0,0x2
    80005a94:	c8850513          	addi	a0,a0,-888 # 80007718 <etext+0x718>
    80005a98:	cafff0ef          	jal	80005746 <panic>

0000000080005a9c <release>:
{
    80005a9c:	1101                	addi	sp,sp,-32
    80005a9e:	ec06                	sd	ra,24(sp)
    80005aa0:	e822                	sd	s0,16(sp)
    80005aa2:	e426                	sd	s1,8(sp)
    80005aa4:	1000                	addi	s0,sp,32
    80005aa6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005aa8:	ef1ff0ef          	jal	80005998 <holding>
    80005aac:	c105                	beqz	a0,80005acc <release+0x30>
  lk->cpu = 0;
    80005aae:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005ab2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005ab6:	0310000f          	fence	rw,w
    80005aba:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005abe:	f8fff0ef          	jal	80005a4c <pop_off>
}
    80005ac2:	60e2                	ld	ra,24(sp)
    80005ac4:	6442                	ld	s0,16(sp)
    80005ac6:	64a2                	ld	s1,8(sp)
    80005ac8:	6105                	addi	sp,sp,32
    80005aca:	8082                	ret
    panic("release");
    80005acc:	00002517          	auipc	a0,0x2
    80005ad0:	c5450513          	addi	a0,a0,-940 # 80007720 <etext+0x720>
    80005ad4:	c73ff0ef          	jal	80005746 <panic>
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
