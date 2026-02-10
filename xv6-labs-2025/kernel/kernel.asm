
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00019117          	auipc	sp,0x19
    80000004:	a9010113          	addi	sp,sp,-1392 # 80018a90 <stack0>
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
    80000016:	661040ef          	jal	80004e76 <start>

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
    80000028:	00021797          	auipc	a5,0x21
    8000002c:	b4078793          	addi	a5,a5,-1216 # 80020b68 <end>
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
    80000056:	80e90913          	addi	s2,s2,-2034 # 80007860 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	09d050ef          	jal	800058f8 <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	121050ef          	jal	8000598c <release>
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
    80000084:	5b2050ef          	jal	80005636 <panic>

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
    800000e0:	00007517          	auipc	a0,0x7
    800000e4:	78050513          	addi	a0,a0,1920 # 80007860 <kmem>
    800000e8:	786050ef          	jal	8000586e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	00021517          	auipc	a0,0x21
    800000f4:	a7850513          	addi	a0,a0,-1416 # 80020b68 <end>
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
    80000112:	75250513          	addi	a0,a0,1874 # 80007860 <kmem>
    80000116:	7e2050ef          	jal	800058f8 <acquire>
  r = kmem.freelist;
    8000011a:	00007497          	auipc	s1,0x7
    8000011e:	75e4b483          	ld	s1,1886(s1) # 80007878 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	00007717          	auipc	a4,0x7
    8000012a:	74f73923          	sd	a5,1874(a4) # 80007878 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	00007517          	auipc	a0,0x7
    80000132:	73250513          	addi	a0,a0,1842 # 80007860 <kmem>
    80000136:	057050ef          	jal	8000598c <release>

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
    80000154:	71050513          	addi	a0,a0,1808 # 80007860 <kmem>
    80000158:	035050ef          	jal	8000598c <release>
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
    8000031c:	245000ef          	jal	80000d60 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000320:	00007717          	auipc	a4,0x7
    80000324:	51070713          	addi	a4,a4,1296 # 80007830 <started>
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
    80000334:	22d000ef          	jal	80000d60 <cpuid>
    80000338:	85aa                	mv	a1,a0
    8000033a:	00007517          	auipc	a0,0x7
    8000033e:	cfe50513          	addi	a0,a0,-770 # 80007038 <etext+0x38>
    80000342:	7cb040ef          	jal	8000530c <printf>
    kvminithart();    // turn on paging
    80000346:	080000ef          	jal	800003c6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034a:	568010ef          	jal	800018b2 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034e:	56a040ef          	jal	800048b8 <plicinithart>
  }

  scheduler();        
    80000352:	6a7000ef          	jal	800011f8 <scheduler>
    consoleinit();
    80000356:	6dd040ef          	jal	80005232 <consoleinit>
    printfinit();
    8000035a:	318050ef          	jal	80005672 <printfinit>
    printf("\n");
    8000035e:	00007517          	auipc	a0,0x7
    80000362:	cba50513          	addi	a0,a0,-838 # 80007018 <etext+0x18>
    80000366:	7a7040ef          	jal	8000530c <printf>
    printf("xv6 kernel is booting\n");
    8000036a:	00007517          	auipc	a0,0x7
    8000036e:	cb650513          	addi	a0,a0,-842 # 80007020 <etext+0x20>
    80000372:	79b040ef          	jal	8000530c <printf>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	78f040ef          	jal	8000530c <printf>
    kinit();         // physical page allocator
    80000382:	d4fff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    80000386:	2cc000ef          	jal	80000652 <kvminit>
    kvminithart();   // turn on paging
    8000038a:	03c000ef          	jal	800003c6 <kvminithart>
    procinit();      // process table
    8000038e:	11d000ef          	jal	80000caa <procinit>
    trapinit();      // trap vectors
    80000392:	4fc010ef          	jal	8000188e <trapinit>
    trapinithart();  // install kernel trap vector
    80000396:	51c010ef          	jal	800018b2 <trapinithart>
    plicinit();      // set up interrupt controller
    8000039a:	504040ef          	jal	8000489e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039e:	51a040ef          	jal	800048b8 <plicinithart>
    binit();         // buffer cache
    800003a2:	39d010ef          	jal	80001f3e <binit>
    iinit();         // inode table
    800003a6:	0ee020ef          	jal	80002494 <iinit>
    fileinit();      // file table
    800003aa:	01a030ef          	jal	800033c4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	5fa040ef          	jal	800049a8 <virtio_disk_init>
    userinit();      // first user process
    800003b2:	4ad000ef          	jal	8000105e <userinit>
    __sync_synchronize();
    800003b6:	0330000f          	fence	rw,rw
    started = 1;
    800003ba:	4785                	li	a5,1
    800003bc:	00007717          	auipc	a4,0x7
    800003c0:	46f72a23          	sw	a5,1140(a4) # 80007830 <started>
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
    800003d6:	4667b783          	ld	a5,1126(a5) # 80007838 <kernel_pagetable>
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
    80000460:	1d6050ef          	jal	80005636 <panic>
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
    80000538:	0fe050ef          	jal	80005636 <panic>
    panic("mappages: size not aligned");
    8000053c:	00007517          	auipc	a0,0x7
    80000540:	b3c50513          	addi	a0,a0,-1220 # 80007078 <etext+0x78>
    80000544:	0f2050ef          	jal	80005636 <panic>
    panic("mappages: size");
    80000548:	00007517          	auipc	a0,0x7
    8000054c:	b5050513          	addi	a0,a0,-1200 # 80007098 <etext+0x98>
    80000550:	0e6050ef          	jal	80005636 <panic>
      panic("mappages: remap");
    80000554:	00007517          	auipc	a0,0x7
    80000558:	b5450513          	addi	a0,a0,-1196 # 800070a8 <etext+0xa8>
    8000055c:	0da050ef          	jal	80005636 <panic>
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
    800005a0:	096050ef          	jal	80005636 <panic>

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
    80000642:	5c4000ef          	jal	80000c06 <proc_mapstacks>
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
    80000662:	1ca7bd23          	sd	a0,474(a5) # 80007838 <kernel_pagetable>
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
    800006d6:	761040ef          	jal	80005636 <panic>
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
    8000082c:	60b040ef          	jal	80005636 <panic>
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
    8000095a:	4dd040ef          	jal	80005636 <panic>

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
    80000a36:	7179                	addi	sp,sp,-48
    80000a38:	f406                	sd	ra,40(sp)
    80000a3a:	f022                	sd	s0,32(sp)
    80000a3c:	e84a                	sd	s2,16(sp)
    80000a3e:	e44e                	sd	s3,8(sp)
    80000a40:	1800                	addi	s0,sp,48
    80000a42:	89aa                	mv	s3,a0
    80000a44:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80000a46:	34e000ef          	jal	80000d94 <myproc>
  if (va >= p->sz)
    80000a4a:	653c                	ld	a5,72(a0)
    80000a4c:	00f96a63          	bltu	s2,a5,80000a60 <vmfault+0x2a>
    return 0;
    80000a50:	4981                	li	s3,0
}
    80000a52:	854e                	mv	a0,s3
    80000a54:	70a2                	ld	ra,40(sp)
    80000a56:	7402                	ld	s0,32(sp)
    80000a58:	6942                	ld	s2,16(sp)
    80000a5a:	69a2                	ld	s3,8(sp)
    80000a5c:	6145                	addi	sp,sp,48
    80000a5e:	8082                	ret
    80000a60:	ec26                	sd	s1,24(sp)
    80000a62:	e052                	sd	s4,0(sp)
    80000a64:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80000a66:	77fd                	lui	a5,0xfffff
    80000a68:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80000a6c:	85d2                	mv	a1,s4
    80000a6e:	854e                	mv	a0,s3
    80000a70:	fabff0ef          	jal	80000a1a <ismapped>
    return 0;
    80000a74:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a76:	c501                	beqz	a0,80000a7e <vmfault+0x48>
    80000a78:	64e2                	ld	s1,24(sp)
    80000a7a:	6a02                	ld	s4,0(sp)
    80000a7c:	bfd9                	j	80000a52 <vmfault+0x1c>
  mem = (uint64) kalloc();
    80000a7e:	e86ff0ef          	jal	80000104 <kalloc>
    80000a82:	892a                	mv	s2,a0
  if(mem == 0)
    80000a84:	c905                	beqz	a0,80000ab4 <vmfault+0x7e>
  mem = (uint64) kalloc();
    80000a86:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a88:	6605                	lui	a2,0x1
    80000a8a:	4581                	li	a1,0
    80000a8c:	ed2ff0ef          	jal	8000015e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a90:	4759                	li	a4,22
    80000a92:	86ca                	mv	a3,s2
    80000a94:	6605                	lui	a2,0x1
    80000a96:	85d2                	mv	a1,s4
    80000a98:	68a8                	ld	a0,80(s1)
    80000a9a:	a2dff0ef          	jal	800004c6 <mappages>
    80000a9e:	e501                	bnez	a0,80000aa6 <vmfault+0x70>
    80000aa0:	64e2                	ld	s1,24(sp)
    80000aa2:	6a02                	ld	s4,0(sp)
    80000aa4:	b77d                	j	80000a52 <vmfault+0x1c>
    kfree((void *)mem);
    80000aa6:	854a                	mv	a0,s2
    80000aa8:	d74ff0ef          	jal	8000001c <kfree>
    return 0;
    80000aac:	4981                	li	s3,0
    80000aae:	64e2                	ld	s1,24(sp)
    80000ab0:	6a02                	ld	s4,0(sp)
    80000ab2:	b745                	j	80000a52 <vmfault+0x1c>
    80000ab4:	64e2                	ld	s1,24(sp)
    80000ab6:	6a02                	ld	s4,0(sp)
    80000ab8:	bf69                	j	80000a52 <vmfault+0x1c>

0000000080000aba <copyout>:
  while(len > 0){
    80000aba:	cad1                	beqz	a3,80000b4e <copyout+0x94>
{
    80000abc:	711d                	addi	sp,sp,-96
    80000abe:	ec86                	sd	ra,88(sp)
    80000ac0:	e8a2                	sd	s0,80(sp)
    80000ac2:	e4a6                	sd	s1,72(sp)
    80000ac4:	e0ca                	sd	s2,64(sp)
    80000ac6:	fc4e                	sd	s3,56(sp)
    80000ac8:	f852                	sd	s4,48(sp)
    80000aca:	f456                	sd	s5,40(sp)
    80000acc:	f05a                	sd	s6,32(sp)
    80000ace:	ec5e                	sd	s7,24(sp)
    80000ad0:	e862                	sd	s8,16(sp)
    80000ad2:	e466                	sd	s9,8(sp)
    80000ad4:	e06a                	sd	s10,0(sp)
    80000ad6:	1080                	addi	s0,sp,96
    80000ad8:	8baa                	mv	s7,a0
    80000ada:	8a2e                	mv	s4,a1
    80000adc:	8b32                	mv	s6,a2
    80000ade:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000ae0:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80000ae2:	5cfd                	li	s9,-1
    80000ae4:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000ae8:	6c05                	lui	s8,0x1
    80000aea:	a005                	j	80000b0a <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000aec:	409a0533          	sub	a0,s4,s1
    80000af0:	0009061b          	sext.w	a2,s2
    80000af4:	85da                	mv	a1,s6
    80000af6:	954e                	add	a0,a0,s3
    80000af8:	ec6ff0ef          	jal	800001be <memmove>
    len -= n;
    80000afc:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000b00:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000b02:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80000b06:	040a8263          	beqz	s5,80000b4a <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    80000b0a:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    80000b0e:	049ce263          	bltu	s9,s1,80000b52 <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    80000b12:	85a6                	mv	a1,s1
    80000b14:	855e                	mv	a0,s7
    80000b16:	977ff0ef          	jal	8000048c <walkaddr>
    80000b1a:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80000b1c:	e901                	bnez	a0,80000b2c <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000b1e:	4601                	li	a2,0
    80000b20:	85a6                	mv	a1,s1
    80000b22:	855e                	mv	a0,s7
    80000b24:	f13ff0ef          	jal	80000a36 <vmfault>
    80000b28:	89aa                	mv	s3,a0
    80000b2a:	c139                	beqz	a0,80000b70 <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    80000b2c:	4601                	li	a2,0
    80000b2e:	85a6                	mv	a1,s1
    80000b30:	855e                	mv	a0,s7
    80000b32:	8c1ff0ef          	jal	800003f2 <walk>
    if((*pte & PTE_W) == 0)
    80000b36:	611c                	ld	a5,0(a0)
    80000b38:	8b91                	andi	a5,a5,4
    80000b3a:	cf8d                	beqz	a5,80000b74 <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    80000b3c:	41448933          	sub	s2,s1,s4
    80000b40:	9962                	add	s2,s2,s8
    if(n > len)
    80000b42:	fb2af5e3          	bgeu	s5,s2,80000aec <copyout+0x32>
    80000b46:	8956                	mv	s2,s5
    80000b48:	b755                	j	80000aec <copyout+0x32>
  return 0;
    80000b4a:	4501                	li	a0,0
    80000b4c:	a021                	j	80000b54 <copyout+0x9a>
    80000b4e:	4501                	li	a0,0
}
    80000b50:	8082                	ret
      return -1;
    80000b52:	557d                	li	a0,-1
}
    80000b54:	60e6                	ld	ra,88(sp)
    80000b56:	6446                	ld	s0,80(sp)
    80000b58:	64a6                	ld	s1,72(sp)
    80000b5a:	6906                	ld	s2,64(sp)
    80000b5c:	79e2                	ld	s3,56(sp)
    80000b5e:	7a42                	ld	s4,48(sp)
    80000b60:	7aa2                	ld	s5,40(sp)
    80000b62:	7b02                	ld	s6,32(sp)
    80000b64:	6be2                	ld	s7,24(sp)
    80000b66:	6c42                	ld	s8,16(sp)
    80000b68:	6ca2                	ld	s9,8(sp)
    80000b6a:	6d02                	ld	s10,0(sp)
    80000b6c:	6125                	addi	sp,sp,96
    80000b6e:	8082                	ret
        return -1;
    80000b70:	557d                	li	a0,-1
    80000b72:	b7cd                	j	80000b54 <copyout+0x9a>
      return -1;
    80000b74:	557d                	li	a0,-1
    80000b76:	bff9                	j	80000b54 <copyout+0x9a>

0000000080000b78 <copyin>:
  while(len > 0){
    80000b78:	c6c9                	beqz	a3,80000c02 <copyin+0x8a>
{
    80000b7a:	715d                	addi	sp,sp,-80
    80000b7c:	e486                	sd	ra,72(sp)
    80000b7e:	e0a2                	sd	s0,64(sp)
    80000b80:	fc26                	sd	s1,56(sp)
    80000b82:	f84a                	sd	s2,48(sp)
    80000b84:	f44e                	sd	s3,40(sp)
    80000b86:	f052                	sd	s4,32(sp)
    80000b88:	ec56                	sd	s5,24(sp)
    80000b8a:	e85a                	sd	s6,16(sp)
    80000b8c:	e45e                	sd	s7,8(sp)
    80000b8e:	e062                	sd	s8,0(sp)
    80000b90:	0880                	addi	s0,sp,80
    80000b92:	8baa                	mv	s7,a0
    80000b94:	8aae                	mv	s5,a1
    80000b96:	8932                	mv	s2,a2
    80000b98:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000b9a:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000b9c:	6b05                	lui	s6,0x1
    80000b9e:	a035                	j	80000bca <copyin+0x52>
    80000ba0:	412984b3          	sub	s1,s3,s2
    80000ba4:	94da                	add	s1,s1,s6
    if(n > len)
    80000ba6:	009a7363          	bgeu	s4,s1,80000bac <copyin+0x34>
    80000baa:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bac:	413905b3          	sub	a1,s2,s3
    80000bb0:	0004861b          	sext.w	a2,s1
    80000bb4:	95aa                	add	a1,a1,a0
    80000bb6:	8556                	mv	a0,s5
    80000bb8:	e06ff0ef          	jal	800001be <memmove>
    len -= n;
    80000bbc:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000bc0:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000bc2:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000bc6:	020a0163          	beqz	s4,80000be8 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000bca:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000bce:	85ce                	mv	a1,s3
    80000bd0:	855e                	mv	a0,s7
    80000bd2:	8bbff0ef          	jal	8000048c <walkaddr>
    if(pa0 == 0) {
    80000bd6:	f569                	bnez	a0,80000ba0 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000bd8:	4601                	li	a2,0
    80000bda:	85ce                	mv	a1,s3
    80000bdc:	855e                	mv	a0,s7
    80000bde:	e59ff0ef          	jal	80000a36 <vmfault>
    80000be2:	fd5d                	bnez	a0,80000ba0 <copyin+0x28>
        return -1;
    80000be4:	557d                	li	a0,-1
    80000be6:	a011                	j	80000bea <copyin+0x72>
  return 0;
    80000be8:	4501                	li	a0,0
}
    80000bea:	60a6                	ld	ra,72(sp)
    80000bec:	6406                	ld	s0,64(sp)
    80000bee:	74e2                	ld	s1,56(sp)
    80000bf0:	7942                	ld	s2,48(sp)
    80000bf2:	79a2                	ld	s3,40(sp)
    80000bf4:	7a02                	ld	s4,32(sp)
    80000bf6:	6ae2                	ld	s5,24(sp)
    80000bf8:	6b42                	ld	s6,16(sp)
    80000bfa:	6ba2                	ld	s7,8(sp)
    80000bfc:	6c02                	ld	s8,0(sp)
    80000bfe:	6161                	addi	sp,sp,80
    80000c00:	8082                	ret
  return 0;
    80000c02:	4501                	li	a0,0
}
    80000c04:	8082                	ret

0000000080000c06 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c06:	715d                	addi	sp,sp,-80
    80000c08:	e486                	sd	ra,72(sp)
    80000c0a:	e0a2                	sd	s0,64(sp)
    80000c0c:	fc26                	sd	s1,56(sp)
    80000c0e:	f84a                	sd	s2,48(sp)
    80000c10:	f44e                	sd	s3,40(sp)
    80000c12:	f052                	sd	s4,32(sp)
    80000c14:	ec56                	sd	s5,24(sp)
    80000c16:	e85a                	sd	s6,16(sp)
    80000c18:	e45e                	sd	s7,8(sp)
    80000c1a:	e062                	sd	s8,0(sp)
    80000c1c:	0880                	addi	s0,sp,80
    80000c1e:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c20:	00007497          	auipc	s1,0x7
    80000c24:	09048493          	addi	s1,s1,144 # 80007cb0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c28:	8c26                	mv	s8,s1
    80000c2a:	000a57b7          	lui	a5,0xa5
    80000c2e:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80000c32:	07b2                	slli	a5,a5,0xc
    80000c34:	fa578793          	addi	a5,a5,-91
    80000c38:	4fa50937          	lui	s2,0x4fa50
    80000c3c:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80000c40:	1902                	slli	s2,s2,0x20
    80000c42:	993e                	add	s2,s2,a5
    80000c44:	040009b7          	lui	s3,0x4000
    80000c48:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c4a:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c4c:	4b99                	li	s7,6
    80000c4e:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c50:	0000da97          	auipc	s5,0xd
    80000c54:	a60a8a93          	addi	s5,s5,-1440 # 8000d6b0 <tickslock>
    char *pa = kalloc();
    80000c58:	cacff0ef          	jal	80000104 <kalloc>
    80000c5c:	862a                	mv	a2,a0
    if(pa == 0)
    80000c5e:	c121                	beqz	a0,80000c9e <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    80000c60:	418485b3          	sub	a1,s1,s8
    80000c64:	858d                	srai	a1,a1,0x3
    80000c66:	032585b3          	mul	a1,a1,s2
    80000c6a:	05b6                	slli	a1,a1,0xd
    80000c6c:	6789                	lui	a5,0x2
    80000c6e:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c70:	875e                	mv	a4,s7
    80000c72:	86da                	mv	a3,s6
    80000c74:	40b985b3          	sub	a1,s3,a1
    80000c78:	8552                	mv	a0,s4
    80000c7a:	903ff0ef          	jal	8000057c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c7e:	16848493          	addi	s1,s1,360
    80000c82:	fd549be3          	bne	s1,s5,80000c58 <proc_mapstacks+0x52>
  }
}
    80000c86:	60a6                	ld	ra,72(sp)
    80000c88:	6406                	ld	s0,64(sp)
    80000c8a:	74e2                	ld	s1,56(sp)
    80000c8c:	7942                	ld	s2,48(sp)
    80000c8e:	79a2                	ld	s3,40(sp)
    80000c90:	7a02                	ld	s4,32(sp)
    80000c92:	6ae2                	ld	s5,24(sp)
    80000c94:	6b42                	ld	s6,16(sp)
    80000c96:	6ba2                	ld	s7,8(sp)
    80000c98:	6c02                	ld	s8,0(sp)
    80000c9a:	6161                	addi	sp,sp,80
    80000c9c:	8082                	ret
      panic("kalloc");
    80000c9e:	00006517          	auipc	a0,0x6
    80000ca2:	45a50513          	addi	a0,a0,1114 # 800070f8 <etext+0xf8>
    80000ca6:	191040ef          	jal	80005636 <panic>

0000000080000caa <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000caa:	7139                	addi	sp,sp,-64
    80000cac:	fc06                	sd	ra,56(sp)
    80000cae:	f822                	sd	s0,48(sp)
    80000cb0:	f426                	sd	s1,40(sp)
    80000cb2:	f04a                	sd	s2,32(sp)
    80000cb4:	ec4e                	sd	s3,24(sp)
    80000cb6:	e852                	sd	s4,16(sp)
    80000cb8:	e456                	sd	s5,8(sp)
    80000cba:	e05a                	sd	s6,0(sp)
    80000cbc:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cbe:	00006597          	auipc	a1,0x6
    80000cc2:	44258593          	addi	a1,a1,1090 # 80007100 <etext+0x100>
    80000cc6:	00007517          	auipc	a0,0x7
    80000cca:	bba50513          	addi	a0,a0,-1094 # 80007880 <pid_lock>
    80000cce:	3a1040ef          	jal	8000586e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cd2:	00006597          	auipc	a1,0x6
    80000cd6:	43658593          	addi	a1,a1,1078 # 80007108 <etext+0x108>
    80000cda:	00007517          	auipc	a0,0x7
    80000cde:	bbe50513          	addi	a0,a0,-1090 # 80007898 <wait_lock>
    80000ce2:	38d040ef          	jal	8000586e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce6:	00007497          	auipc	s1,0x7
    80000cea:	fca48493          	addi	s1,s1,-54 # 80007cb0 <proc>
      initlock(&p->lock, "proc");
    80000cee:	00006b17          	auipc	s6,0x6
    80000cf2:	42ab0b13          	addi	s6,s6,1066 # 80007118 <etext+0x118>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cf6:	8aa6                	mv	s5,s1
    80000cf8:	000a57b7          	lui	a5,0xa5
    80000cfc:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80000d00:	07b2                	slli	a5,a5,0xc
    80000d02:	fa578793          	addi	a5,a5,-91
    80000d06:	4fa50937          	lui	s2,0x4fa50
    80000d0a:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80000d0e:	1902                	slli	s2,s2,0x20
    80000d10:	993e                	add	s2,s2,a5
    80000d12:	040009b7          	lui	s3,0x4000
    80000d16:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d18:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d1a:	0000da17          	auipc	s4,0xd
    80000d1e:	996a0a13          	addi	s4,s4,-1642 # 8000d6b0 <tickslock>
      initlock(&p->lock, "proc");
    80000d22:	85da                	mv	a1,s6
    80000d24:	8526                	mv	a0,s1
    80000d26:	349040ef          	jal	8000586e <initlock>
      p->state = UNUSED;
    80000d2a:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d2e:	415487b3          	sub	a5,s1,s5
    80000d32:	878d                	srai	a5,a5,0x3
    80000d34:	032787b3          	mul	a5,a5,s2
    80000d38:	07b6                	slli	a5,a5,0xd
    80000d3a:	6709                	lui	a4,0x2
    80000d3c:	9fb9                	addw	a5,a5,a4
    80000d3e:	40f987b3          	sub	a5,s3,a5
    80000d42:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d44:	16848493          	addi	s1,s1,360
    80000d48:	fd449de3          	bne	s1,s4,80000d22 <procinit+0x78>
  }
}
    80000d4c:	70e2                	ld	ra,56(sp)
    80000d4e:	7442                	ld	s0,48(sp)
    80000d50:	74a2                	ld	s1,40(sp)
    80000d52:	7902                	ld	s2,32(sp)
    80000d54:	69e2                	ld	s3,24(sp)
    80000d56:	6a42                	ld	s4,16(sp)
    80000d58:	6aa2                	ld	s5,8(sp)
    80000d5a:	6b02                	ld	s6,0(sp)
    80000d5c:	6121                	addi	sp,sp,64
    80000d5e:	8082                	ret

0000000080000d60 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d60:	1141                	addi	sp,sp,-16
    80000d62:	e406                	sd	ra,8(sp)
    80000d64:	e022                	sd	s0,0(sp)
    80000d66:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d68:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d6a:	2501                	sext.w	a0,a0
    80000d6c:	60a2                	ld	ra,8(sp)
    80000d6e:	6402                	ld	s0,0(sp)
    80000d70:	0141                	addi	sp,sp,16
    80000d72:	8082                	ret

0000000080000d74 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d74:	1141                	addi	sp,sp,-16
    80000d76:	e406                	sd	ra,8(sp)
    80000d78:	e022                	sd	s0,0(sp)
    80000d7a:	0800                	addi	s0,sp,16
    80000d7c:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d7e:	2781                	sext.w	a5,a5
    80000d80:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d82:	00007517          	auipc	a0,0x7
    80000d86:	b2e50513          	addi	a0,a0,-1234 # 800078b0 <cpus>
    80000d8a:	953e                	add	a0,a0,a5
    80000d8c:	60a2                	ld	ra,8(sp)
    80000d8e:	6402                	ld	s0,0(sp)
    80000d90:	0141                	addi	sp,sp,16
    80000d92:	8082                	ret

0000000080000d94 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d94:	1101                	addi	sp,sp,-32
    80000d96:	ec06                	sd	ra,24(sp)
    80000d98:	e822                	sd	s0,16(sp)
    80000d9a:	e426                	sd	s1,8(sp)
    80000d9c:	1000                	addi	s0,sp,32
  push_off();
    80000d9e:	317040ef          	jal	800058b4 <push_off>
    80000da2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000da4:	2781                	sext.w	a5,a5
    80000da6:	079e                	slli	a5,a5,0x7
    80000da8:	00007717          	auipc	a4,0x7
    80000dac:	ad870713          	addi	a4,a4,-1320 # 80007880 <pid_lock>
    80000db0:	97ba                	add	a5,a5,a4
    80000db2:	7b9c                	ld	a5,48(a5)
    80000db4:	84be                	mv	s1,a5
  pop_off();
    80000db6:	387040ef          	jal	8000593c <pop_off>
  return p;
}
    80000dba:	8526                	mv	a0,s1
    80000dbc:	60e2                	ld	ra,24(sp)
    80000dbe:	6442                	ld	s0,16(sp)
    80000dc0:	64a2                	ld	s1,8(sp)
    80000dc2:	6105                	addi	sp,sp,32
    80000dc4:	8082                	ret

0000000080000dc6 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dc6:	7179                	addi	sp,sp,-48
    80000dc8:	f406                	sd	ra,40(sp)
    80000dca:	f022                	sd	s0,32(sp)
    80000dcc:	ec26                	sd	s1,24(sp)
    80000dce:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000dd0:	fc5ff0ef          	jal	80000d94 <myproc>
    80000dd4:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000dd6:	3b7040ef          	jal	8000598c <release>

  if (first) {
    80000dda:	00007797          	auipc	a5,0x7
    80000dde:	a467a783          	lw	a5,-1466(a5) # 80007820 <first.1>
    80000de2:	cf95                	beqz	a5,80000e1e <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000de4:	4505                	li	a0,1
    80000de6:	36b010ef          	jal	80002950 <fsinit>

    first = 0;
    80000dea:	00007797          	auipc	a5,0x7
    80000dee:	a207ab23          	sw	zero,-1482(a5) # 80007820 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000df2:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000df6:	00006797          	auipc	a5,0x6
    80000dfa:	32a78793          	addi	a5,a5,810 # 80007120 <etext+0x120>
    80000dfe:	fcf43823          	sd	a5,-48(s0)
    80000e02:	fc043c23          	sd	zero,-40(s0)
    80000e06:	fd040593          	addi	a1,s0,-48
    80000e0a:	853e                	mv	a0,a5
    80000e0c:	4c3020ef          	jal	80003ace <kexec>
    80000e10:	6cbc                	ld	a5,88(s1)
    80000e12:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000e14:	6cbc                	ld	a5,88(s1)
    80000e16:	7bb8                	ld	a4,112(a5)
    80000e18:	57fd                	li	a5,-1
    80000e1a:	02f70d63          	beq	a4,a5,80000e54 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e1e:	2b1000ef          	jal	800018ce <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e22:	68a8                	ld	a0,80(s1)
    80000e24:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e26:	04000737          	lui	a4,0x4000
    80000e2a:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e2c:	0732                	slli	a4,a4,0xc
    80000e2e:	00005797          	auipc	a5,0x5
    80000e32:	26e78793          	addi	a5,a5,622 # 8000609c <userret>
    80000e36:	00005697          	auipc	a3,0x5
    80000e3a:	1ca68693          	addi	a3,a3,458 # 80006000 <_trampoline>
    80000e3e:	8f95                	sub	a5,a5,a3
    80000e40:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e42:	577d                	li	a4,-1
    80000e44:	177e                	slli	a4,a4,0x3f
    80000e46:	8d59                	or	a0,a0,a4
    80000e48:	9782                	jalr	a5
}
    80000e4a:	70a2                	ld	ra,40(sp)
    80000e4c:	7402                	ld	s0,32(sp)
    80000e4e:	64e2                	ld	s1,24(sp)
    80000e50:	6145                	addi	sp,sp,48
    80000e52:	8082                	ret
      panic("exec");
    80000e54:	00006517          	auipc	a0,0x6
    80000e58:	2d450513          	addi	a0,a0,724 # 80007128 <etext+0x128>
    80000e5c:	7da040ef          	jal	80005636 <panic>

0000000080000e60 <allocpid>:
{
    80000e60:	1101                	addi	sp,sp,-32
    80000e62:	ec06                	sd	ra,24(sp)
    80000e64:	e822                	sd	s0,16(sp)
    80000e66:	e426                	sd	s1,8(sp)
    80000e68:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e6a:	00007517          	auipc	a0,0x7
    80000e6e:	a1650513          	addi	a0,a0,-1514 # 80007880 <pid_lock>
    80000e72:	287040ef          	jal	800058f8 <acquire>
  pid = nextpid;
    80000e76:	00007797          	auipc	a5,0x7
    80000e7a:	9ae78793          	addi	a5,a5,-1618 # 80007824 <nextpid>
    80000e7e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e80:	0014871b          	addiw	a4,s1,1
    80000e84:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e86:	00007517          	auipc	a0,0x7
    80000e8a:	9fa50513          	addi	a0,a0,-1542 # 80007880 <pid_lock>
    80000e8e:	2ff040ef          	jal	8000598c <release>
}
    80000e92:	8526                	mv	a0,s1
    80000e94:	60e2                	ld	ra,24(sp)
    80000e96:	6442                	ld	s0,16(sp)
    80000e98:	64a2                	ld	s1,8(sp)
    80000e9a:	6105                	addi	sp,sp,32
    80000e9c:	8082                	ret

0000000080000e9e <proc_pagetable>:
{
    80000e9e:	1101                	addi	sp,sp,-32
    80000ea0:	ec06                	sd	ra,24(sp)
    80000ea2:	e822                	sd	s0,16(sp)
    80000ea4:	e426                	sd	s1,8(sp)
    80000ea6:	e04a                	sd	s2,0(sp)
    80000ea8:	1000                	addi	s0,sp,32
    80000eaa:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000eac:	fc2ff0ef          	jal	8000066e <uvmcreate>
    80000eb0:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000eb2:	cd05                	beqz	a0,80000eea <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000eb4:	4729                	li	a4,10
    80000eb6:	00005697          	auipc	a3,0x5
    80000eba:	14a68693          	addi	a3,a3,330 # 80006000 <_trampoline>
    80000ebe:	6605                	lui	a2,0x1
    80000ec0:	040005b7          	lui	a1,0x4000
    80000ec4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ec6:	05b2                	slli	a1,a1,0xc
    80000ec8:	dfeff0ef          	jal	800004c6 <mappages>
    80000ecc:	02054663          	bltz	a0,80000ef8 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000ed0:	4719                	li	a4,6
    80000ed2:	05893683          	ld	a3,88(s2)
    80000ed6:	6605                	lui	a2,0x1
    80000ed8:	020005b7          	lui	a1,0x2000
    80000edc:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ede:	05b6                	slli	a1,a1,0xd
    80000ee0:	8526                	mv	a0,s1
    80000ee2:	de4ff0ef          	jal	800004c6 <mappages>
    80000ee6:	00054f63          	bltz	a0,80000f04 <proc_pagetable+0x66>
}
    80000eea:	8526                	mv	a0,s1
    80000eec:	60e2                	ld	ra,24(sp)
    80000eee:	6442                	ld	s0,16(sp)
    80000ef0:	64a2                	ld	s1,8(sp)
    80000ef2:	6902                	ld	s2,0(sp)
    80000ef4:	6105                	addi	sp,sp,32
    80000ef6:	8082                	ret
    uvmfree(pagetable, 0);
    80000ef8:	4581                	li	a1,0
    80000efa:	8526                	mv	a0,s1
    80000efc:	96dff0ef          	jal	80000868 <uvmfree>
    return 0;
    80000f00:	4481                	li	s1,0
    80000f02:	b7e5                	j	80000eea <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f04:	4681                	li	a3,0
    80000f06:	4605                	li	a2,1
    80000f08:	040005b7          	lui	a1,0x4000
    80000f0c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f0e:	05b2                	slli	a1,a1,0xc
    80000f10:	8526                	mv	a0,s1
    80000f12:	f82ff0ef          	jal	80000694 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f16:	4581                	li	a1,0
    80000f18:	8526                	mv	a0,s1
    80000f1a:	94fff0ef          	jal	80000868 <uvmfree>
    return 0;
    80000f1e:	4481                	li	s1,0
    80000f20:	b7e9                	j	80000eea <proc_pagetable+0x4c>

0000000080000f22 <proc_freepagetable>:
{
    80000f22:	1101                	addi	sp,sp,-32
    80000f24:	ec06                	sd	ra,24(sp)
    80000f26:	e822                	sd	s0,16(sp)
    80000f28:	e426                	sd	s1,8(sp)
    80000f2a:	e04a                	sd	s2,0(sp)
    80000f2c:	1000                	addi	s0,sp,32
    80000f2e:	84aa                	mv	s1,a0
    80000f30:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f32:	4681                	li	a3,0
    80000f34:	4605                	li	a2,1
    80000f36:	040005b7          	lui	a1,0x4000
    80000f3a:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f3c:	05b2                	slli	a1,a1,0xc
    80000f3e:	f56ff0ef          	jal	80000694 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f42:	4681                	li	a3,0
    80000f44:	4605                	li	a2,1
    80000f46:	020005b7          	lui	a1,0x2000
    80000f4a:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f4c:	05b6                	slli	a1,a1,0xd
    80000f4e:	8526                	mv	a0,s1
    80000f50:	f44ff0ef          	jal	80000694 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f54:	85ca                	mv	a1,s2
    80000f56:	8526                	mv	a0,s1
    80000f58:	911ff0ef          	jal	80000868 <uvmfree>
}
    80000f5c:	60e2                	ld	ra,24(sp)
    80000f5e:	6442                	ld	s0,16(sp)
    80000f60:	64a2                	ld	s1,8(sp)
    80000f62:	6902                	ld	s2,0(sp)
    80000f64:	6105                	addi	sp,sp,32
    80000f66:	8082                	ret

0000000080000f68 <freeproc>:
{
    80000f68:	1101                	addi	sp,sp,-32
    80000f6a:	ec06                	sd	ra,24(sp)
    80000f6c:	e822                	sd	s0,16(sp)
    80000f6e:	e426                	sd	s1,8(sp)
    80000f70:	1000                	addi	s0,sp,32
    80000f72:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f74:	6d28                	ld	a0,88(a0)
    80000f76:	c119                	beqz	a0,80000f7c <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f78:	8a4ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f7c:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f80:	68a8                	ld	a0,80(s1)
    80000f82:	c501                	beqz	a0,80000f8a <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f84:	64ac                	ld	a1,72(s1)
    80000f86:	f9dff0ef          	jal	80000f22 <proc_freepagetable>
  p->pagetable = 0;
    80000f8a:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f8e:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f92:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f96:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f9a:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f9e:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000fa2:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000fa6:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000faa:	0004ac23          	sw	zero,24(s1)
}
    80000fae:	60e2                	ld	ra,24(sp)
    80000fb0:	6442                	ld	s0,16(sp)
    80000fb2:	64a2                	ld	s1,8(sp)
    80000fb4:	6105                	addi	sp,sp,32
    80000fb6:	8082                	ret

0000000080000fb8 <allocproc>:
{
    80000fb8:	1101                	addi	sp,sp,-32
    80000fba:	ec06                	sd	ra,24(sp)
    80000fbc:	e822                	sd	s0,16(sp)
    80000fbe:	e426                	sd	s1,8(sp)
    80000fc0:	e04a                	sd	s2,0(sp)
    80000fc2:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fc4:	00007497          	auipc	s1,0x7
    80000fc8:	cec48493          	addi	s1,s1,-788 # 80007cb0 <proc>
    80000fcc:	0000c917          	auipc	s2,0xc
    80000fd0:	6e490913          	addi	s2,s2,1764 # 8000d6b0 <tickslock>
    acquire(&p->lock);
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	123040ef          	jal	800058f8 <acquire>
    if(p->state == UNUSED) {
    80000fda:	4c9c                	lw	a5,24(s1)
    80000fdc:	cb91                	beqz	a5,80000ff0 <allocproc+0x38>
      release(&p->lock);
    80000fde:	8526                	mv	a0,s1
    80000fe0:	1ad040ef          	jal	8000598c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fe4:	16848493          	addi	s1,s1,360
    80000fe8:	ff2496e3          	bne	s1,s2,80000fd4 <allocproc+0x1c>
  return 0;
    80000fec:	4481                	li	s1,0
    80000fee:	a089                	j	80001030 <allocproc+0x78>
  p->pid = allocpid();
    80000ff0:	e71ff0ef          	jal	80000e60 <allocpid>
    80000ff4:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000ff6:	4785                	li	a5,1
    80000ff8:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000ffa:	90aff0ef          	jal	80000104 <kalloc>
    80000ffe:	892a                	mv	s2,a0
    80001000:	eca8                	sd	a0,88(s1)
    80001002:	cd15                	beqz	a0,8000103e <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001004:	8526                	mv	a0,s1
    80001006:	e99ff0ef          	jal	80000e9e <proc_pagetable>
    8000100a:	892a                	mv	s2,a0
    8000100c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000100e:	c121                	beqz	a0,8000104e <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80001010:	07000613          	li	a2,112
    80001014:	4581                	li	a1,0
    80001016:	06048513          	addi	a0,s1,96
    8000101a:	944ff0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    8000101e:	00000797          	auipc	a5,0x0
    80001022:	da878793          	addi	a5,a5,-600 # 80000dc6 <forkret>
    80001026:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001028:	60bc                	ld	a5,64(s1)
    8000102a:	6705                	lui	a4,0x1
    8000102c:	97ba                	add	a5,a5,a4
    8000102e:	f4bc                	sd	a5,104(s1)
}
    80001030:	8526                	mv	a0,s1
    80001032:	60e2                	ld	ra,24(sp)
    80001034:	6442                	ld	s0,16(sp)
    80001036:	64a2                	ld	s1,8(sp)
    80001038:	6902                	ld	s2,0(sp)
    8000103a:	6105                	addi	sp,sp,32
    8000103c:	8082                	ret
    freeproc(p);
    8000103e:	8526                	mv	a0,s1
    80001040:	f29ff0ef          	jal	80000f68 <freeproc>
    release(&p->lock);
    80001044:	8526                	mv	a0,s1
    80001046:	147040ef          	jal	8000598c <release>
    return 0;
    8000104a:	84ca                	mv	s1,s2
    8000104c:	b7d5                	j	80001030 <allocproc+0x78>
    freeproc(p);
    8000104e:	8526                	mv	a0,s1
    80001050:	f19ff0ef          	jal	80000f68 <freeproc>
    release(&p->lock);
    80001054:	8526                	mv	a0,s1
    80001056:	137040ef          	jal	8000598c <release>
    return 0;
    8000105a:	84ca                	mv	s1,s2
    8000105c:	bfd1                	j	80001030 <allocproc+0x78>

000000008000105e <userinit>:
{
    8000105e:	1101                	addi	sp,sp,-32
    80001060:	ec06                	sd	ra,24(sp)
    80001062:	e822                	sd	s0,16(sp)
    80001064:	e426                	sd	s1,8(sp)
    80001066:	1000                	addi	s0,sp,32
  p = allocproc();
    80001068:	f51ff0ef          	jal	80000fb8 <allocproc>
    8000106c:	84aa                	mv	s1,a0
  initproc = p;
    8000106e:	00006797          	auipc	a5,0x6
    80001072:	7ca7b923          	sd	a0,2002(a5) # 80007840 <initproc>
  p->cwd = namei("/");
    80001076:	00006517          	auipc	a0,0x6
    8000107a:	0ba50513          	addi	a0,a0,186 # 80007130 <etext+0x130>
    8000107e:	60d010ef          	jal	80002e8a <namei>
    80001082:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001086:	478d                	li	a5,3
    80001088:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000108a:	8526                	mv	a0,s1
    8000108c:	101040ef          	jal	8000598c <release>
}
    80001090:	60e2                	ld	ra,24(sp)
    80001092:	6442                	ld	s0,16(sp)
    80001094:	64a2                	ld	s1,8(sp)
    80001096:	6105                	addi	sp,sp,32
    80001098:	8082                	ret

000000008000109a <growproc>:
{
    8000109a:	1101                	addi	sp,sp,-32
    8000109c:	ec06                	sd	ra,24(sp)
    8000109e:	e822                	sd	s0,16(sp)
    800010a0:	e426                	sd	s1,8(sp)
    800010a2:	e04a                	sd	s2,0(sp)
    800010a4:	1000                	addi	s0,sp,32
    800010a6:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800010a8:	cedff0ef          	jal	80000d94 <myproc>
    800010ac:	84aa                	mv	s1,a0
  sz = p->sz;
    800010ae:	652c                	ld	a1,72(a0)
  if(n > 0){
    800010b0:	01204c63          	bgtz	s2,800010c8 <growproc+0x2e>
  } else if(n < 0){
    800010b4:	02094463          	bltz	s2,800010dc <growproc+0x42>
  p->sz = sz;
    800010b8:	e4ac                	sd	a1,72(s1)
  return 0;
    800010ba:	4501                	li	a0,0
}
    800010bc:	60e2                	ld	ra,24(sp)
    800010be:	6442                	ld	s0,16(sp)
    800010c0:	64a2                	ld	s1,8(sp)
    800010c2:	6902                	ld	s2,0(sp)
    800010c4:	6105                	addi	sp,sp,32
    800010c6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010c8:	4691                	li	a3,4
    800010ca:	00b90633          	add	a2,s2,a1
    800010ce:	6928                	ld	a0,80(a0)
    800010d0:	e92ff0ef          	jal	80000762 <uvmalloc>
    800010d4:	85aa                	mv	a1,a0
    800010d6:	f16d                	bnez	a0,800010b8 <growproc+0x1e>
      return -1;
    800010d8:	557d                	li	a0,-1
    800010da:	b7cd                	j	800010bc <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010dc:	00b90633          	add	a2,s2,a1
    800010e0:	6928                	ld	a0,80(a0)
    800010e2:	e3cff0ef          	jal	8000071e <uvmdealloc>
    800010e6:	85aa                	mv	a1,a0
    800010e8:	bfc1                	j	800010b8 <growproc+0x1e>

00000000800010ea <kfork>:
{
    800010ea:	7139                	addi	sp,sp,-64
    800010ec:	fc06                	sd	ra,56(sp)
    800010ee:	f822                	sd	s0,48(sp)
    800010f0:	f426                	sd	s1,40(sp)
    800010f2:	e456                	sd	s5,8(sp)
    800010f4:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010f6:	c9fff0ef          	jal	80000d94 <myproc>
    800010fa:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010fc:	ebdff0ef          	jal	80000fb8 <allocproc>
    80001100:	0e050a63          	beqz	a0,800011f4 <kfork+0x10a>
    80001104:	e852                	sd	s4,16(sp)
    80001106:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001108:	048ab603          	ld	a2,72(s5)
    8000110c:	692c                	ld	a1,80(a0)
    8000110e:	050ab503          	ld	a0,80(s5)
    80001112:	f88ff0ef          	jal	8000089a <uvmcopy>
    80001116:	04054863          	bltz	a0,80001166 <kfork+0x7c>
    8000111a:	f04a                	sd	s2,32(sp)
    8000111c:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    8000111e:	048ab783          	ld	a5,72(s5)
    80001122:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    80001126:	058ab683          	ld	a3,88(s5)
    8000112a:	87b6                	mv	a5,a3
    8000112c:	058a3703          	ld	a4,88(s4)
    80001130:	12068693          	addi	a3,a3,288
    80001134:	6388                	ld	a0,0(a5)
    80001136:	678c                	ld	a1,8(a5)
    80001138:	6b90                	ld	a2,16(a5)
    8000113a:	e308                	sd	a0,0(a4)
    8000113c:	e70c                	sd	a1,8(a4)
    8000113e:	eb10                	sd	a2,16(a4)
    80001140:	6f90                	ld	a2,24(a5)
    80001142:	ef10                	sd	a2,24(a4)
    80001144:	02078793          	addi	a5,a5,32
    80001148:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    8000114c:	fed794e3          	bne	a5,a3,80001134 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001150:	058a3783          	ld	a5,88(s4)
    80001154:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001158:	0d0a8493          	addi	s1,s5,208
    8000115c:	0d0a0913          	addi	s2,s4,208
    80001160:	150a8993          	addi	s3,s5,336
    80001164:	a831                	j	80001180 <kfork+0x96>
    freeproc(np);
    80001166:	8552                	mv	a0,s4
    80001168:	e01ff0ef          	jal	80000f68 <freeproc>
    release(&np->lock);
    8000116c:	8552                	mv	a0,s4
    8000116e:	01f040ef          	jal	8000598c <release>
    return -1;
    80001172:	54fd                	li	s1,-1
    80001174:	6a42                	ld	s4,16(sp)
    80001176:	a885                	j	800011e6 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001178:	04a1                	addi	s1,s1,8
    8000117a:	0921                	addi	s2,s2,8
    8000117c:	01348963          	beq	s1,s3,8000118e <kfork+0xa4>
    if(p->ofile[i])
    80001180:	6088                	ld	a0,0(s1)
    80001182:	d97d                	beqz	a0,80001178 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    80001184:	2c2020ef          	jal	80003446 <filedup>
    80001188:	00a93023          	sd	a0,0(s2)
    8000118c:	b7f5                	j	80001178 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    8000118e:	150ab503          	ld	a0,336(s5)
    80001192:	494010ef          	jal	80002626 <idup>
    80001196:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000119a:	4641                	li	a2,16
    8000119c:	158a8593          	addi	a1,s5,344
    800011a0:	158a0513          	addi	a0,s4,344
    800011a4:	90eff0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    800011a8:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    800011ac:	8552                	mv	a0,s4
    800011ae:	7de040ef          	jal	8000598c <release>
  acquire(&wait_lock);
    800011b2:	00006517          	auipc	a0,0x6
    800011b6:	6e650513          	addi	a0,a0,1766 # 80007898 <wait_lock>
    800011ba:	73e040ef          	jal	800058f8 <acquire>
  np->parent = p;
    800011be:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800011c2:	00006517          	auipc	a0,0x6
    800011c6:	6d650513          	addi	a0,a0,1750 # 80007898 <wait_lock>
    800011ca:	7c2040ef          	jal	8000598c <release>
  acquire(&np->lock);
    800011ce:	8552                	mv	a0,s4
    800011d0:	728040ef          	jal	800058f8 <acquire>
  np->state = RUNNABLE;
    800011d4:	478d                	li	a5,3
    800011d6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800011da:	8552                	mv	a0,s4
    800011dc:	7b0040ef          	jal	8000598c <release>
  return pid;
    800011e0:	7902                	ld	s2,32(sp)
    800011e2:	69e2                	ld	s3,24(sp)
    800011e4:	6a42                	ld	s4,16(sp)
}
    800011e6:	8526                	mv	a0,s1
    800011e8:	70e2                	ld	ra,56(sp)
    800011ea:	7442                	ld	s0,48(sp)
    800011ec:	74a2                	ld	s1,40(sp)
    800011ee:	6aa2                	ld	s5,8(sp)
    800011f0:	6121                	addi	sp,sp,64
    800011f2:	8082                	ret
    return -1;
    800011f4:	54fd                	li	s1,-1
    800011f6:	bfc5                	j	800011e6 <kfork+0xfc>

00000000800011f8 <scheduler>:
{
    800011f8:	715d                	addi	sp,sp,-80
    800011fa:	e486                	sd	ra,72(sp)
    800011fc:	e0a2                	sd	s0,64(sp)
    800011fe:	fc26                	sd	s1,56(sp)
    80001200:	f84a                	sd	s2,48(sp)
    80001202:	f44e                	sd	s3,40(sp)
    80001204:	f052                	sd	s4,32(sp)
    80001206:	ec56                	sd	s5,24(sp)
    80001208:	e85a                	sd	s6,16(sp)
    8000120a:	e45e                	sd	s7,8(sp)
    8000120c:	e062                	sd	s8,0(sp)
    8000120e:	0880                	addi	s0,sp,80
    80001210:	8792                	mv	a5,tp
  int id = r_tp();
    80001212:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001214:	00779b13          	slli	s6,a5,0x7
    80001218:	00006717          	auipc	a4,0x6
    8000121c:	66870713          	addi	a4,a4,1640 # 80007880 <pid_lock>
    80001220:	975a                	add	a4,a4,s6
    80001222:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001226:	00006717          	auipc	a4,0x6
    8000122a:	69270713          	addi	a4,a4,1682 # 800078b8 <cpus+0x8>
    8000122e:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001230:	4c11                	li	s8,4
        c->proc = p;
    80001232:	079e                	slli	a5,a5,0x7
    80001234:	00006a17          	auipc	s4,0x6
    80001238:	64ca0a13          	addi	s4,s4,1612 # 80007880 <pid_lock>
    8000123c:	9a3e                	add	s4,s4,a5
        found = 1;
    8000123e:	4b85                	li	s7,1
    80001240:	a83d                	j	8000127e <scheduler+0x86>
      release(&p->lock);
    80001242:	8526                	mv	a0,s1
    80001244:	748040ef          	jal	8000598c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001248:	16848493          	addi	s1,s1,360
    8000124c:	03248563          	beq	s1,s2,80001276 <scheduler+0x7e>
      acquire(&p->lock);
    80001250:	8526                	mv	a0,s1
    80001252:	6a6040ef          	jal	800058f8 <acquire>
      if(p->state == RUNNABLE) {
    80001256:	4c9c                	lw	a5,24(s1)
    80001258:	ff3795e3          	bne	a5,s3,80001242 <scheduler+0x4a>
        p->state = RUNNING;
    8000125c:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001260:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001264:	06048593          	addi	a1,s1,96
    80001268:	855a                	mv	a0,s6
    8000126a:	5ba000ef          	jal	80001824 <swtch>
        c->proc = 0;
    8000126e:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001272:	8ade                	mv	s5,s7
    80001274:	b7f9                	j	80001242 <scheduler+0x4a>
    if(found == 0) {
    80001276:	000a9463          	bnez	s5,8000127e <scheduler+0x86>
      asm volatile("wfi");
    8000127a:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000127e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001282:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001286:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000128a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    8000128e:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001290:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001294:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001296:	00007497          	auipc	s1,0x7
    8000129a:	a1a48493          	addi	s1,s1,-1510 # 80007cb0 <proc>
      if(p->state == RUNNABLE) {
    8000129e:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800012a0:	0000c917          	auipc	s2,0xc
    800012a4:	41090913          	addi	s2,s2,1040 # 8000d6b0 <tickslock>
    800012a8:	b765                	j	80001250 <scheduler+0x58>

00000000800012aa <sched>:
{
    800012aa:	7179                	addi	sp,sp,-48
    800012ac:	f406                	sd	ra,40(sp)
    800012ae:	f022                	sd	s0,32(sp)
    800012b0:	ec26                	sd	s1,24(sp)
    800012b2:	e84a                	sd	s2,16(sp)
    800012b4:	e44e                	sd	s3,8(sp)
    800012b6:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012b8:	addff0ef          	jal	80000d94 <myproc>
    800012bc:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012be:	5ca040ef          	jal	80005888 <holding>
    800012c2:	c935                	beqz	a0,80001336 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012c4:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012c6:	2781                	sext.w	a5,a5
    800012c8:	079e                	slli	a5,a5,0x7
    800012ca:	00006717          	auipc	a4,0x6
    800012ce:	5b670713          	addi	a4,a4,1462 # 80007880 <pid_lock>
    800012d2:	97ba                	add	a5,a5,a4
    800012d4:	0a87a703          	lw	a4,168(a5)
    800012d8:	4785                	li	a5,1
    800012da:	06f71463          	bne	a4,a5,80001342 <sched+0x98>
  if(p->state == RUNNING)
    800012de:	4c98                	lw	a4,24(s1)
    800012e0:	4791                	li	a5,4
    800012e2:	06f70663          	beq	a4,a5,8000134e <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012e6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012ea:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012ec:	e7bd                	bnez	a5,8000135a <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012ee:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012f0:	00006917          	auipc	s2,0x6
    800012f4:	59090913          	addi	s2,s2,1424 # 80007880 <pid_lock>
    800012f8:	2781                	sext.w	a5,a5
    800012fa:	079e                	slli	a5,a5,0x7
    800012fc:	97ca                	add	a5,a5,s2
    800012fe:	0ac7a983          	lw	s3,172(a5)
    80001302:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001304:	2781                	sext.w	a5,a5
    80001306:	079e                	slli	a5,a5,0x7
    80001308:	07a1                	addi	a5,a5,8
    8000130a:	00006597          	auipc	a1,0x6
    8000130e:	5a658593          	addi	a1,a1,1446 # 800078b0 <cpus>
    80001312:	95be                	add	a1,a1,a5
    80001314:	06048513          	addi	a0,s1,96
    80001318:	50c000ef          	jal	80001824 <swtch>
    8000131c:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    8000131e:	2781                	sext.w	a5,a5
    80001320:	079e                	slli	a5,a5,0x7
    80001322:	993e                	add	s2,s2,a5
    80001324:	0b392623          	sw	s3,172(s2)
}
    80001328:	70a2                	ld	ra,40(sp)
    8000132a:	7402                	ld	s0,32(sp)
    8000132c:	64e2                	ld	s1,24(sp)
    8000132e:	6942                	ld	s2,16(sp)
    80001330:	69a2                	ld	s3,8(sp)
    80001332:	6145                	addi	sp,sp,48
    80001334:	8082                	ret
    panic("sched p->lock");
    80001336:	00006517          	auipc	a0,0x6
    8000133a:	e0250513          	addi	a0,a0,-510 # 80007138 <etext+0x138>
    8000133e:	2f8040ef          	jal	80005636 <panic>
    panic("sched locks");
    80001342:	00006517          	auipc	a0,0x6
    80001346:	e0650513          	addi	a0,a0,-506 # 80007148 <etext+0x148>
    8000134a:	2ec040ef          	jal	80005636 <panic>
    panic("sched RUNNING");
    8000134e:	00006517          	auipc	a0,0x6
    80001352:	e0a50513          	addi	a0,a0,-502 # 80007158 <etext+0x158>
    80001356:	2e0040ef          	jal	80005636 <panic>
    panic("sched interruptible");
    8000135a:	00006517          	auipc	a0,0x6
    8000135e:	e0e50513          	addi	a0,a0,-498 # 80007168 <etext+0x168>
    80001362:	2d4040ef          	jal	80005636 <panic>

0000000080001366 <yield>:
{
    80001366:	1101                	addi	sp,sp,-32
    80001368:	ec06                	sd	ra,24(sp)
    8000136a:	e822                	sd	s0,16(sp)
    8000136c:	e426                	sd	s1,8(sp)
    8000136e:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001370:	a25ff0ef          	jal	80000d94 <myproc>
    80001374:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001376:	582040ef          	jal	800058f8 <acquire>
  p->state = RUNNABLE;
    8000137a:	478d                	li	a5,3
    8000137c:	cc9c                	sw	a5,24(s1)
  sched();
    8000137e:	f2dff0ef          	jal	800012aa <sched>
  release(&p->lock);
    80001382:	8526                	mv	a0,s1
    80001384:	608040ef          	jal	8000598c <release>
}
    80001388:	60e2                	ld	ra,24(sp)
    8000138a:	6442                	ld	s0,16(sp)
    8000138c:	64a2                	ld	s1,8(sp)
    8000138e:	6105                	addi	sp,sp,32
    80001390:	8082                	ret

0000000080001392 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001392:	7179                	addi	sp,sp,-48
    80001394:	f406                	sd	ra,40(sp)
    80001396:	f022                	sd	s0,32(sp)
    80001398:	ec26                	sd	s1,24(sp)
    8000139a:	e84a                	sd	s2,16(sp)
    8000139c:	e44e                	sd	s3,8(sp)
    8000139e:	1800                	addi	s0,sp,48
    800013a0:	89aa                	mv	s3,a0
    800013a2:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013a4:	9f1ff0ef          	jal	80000d94 <myproc>
    800013a8:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013aa:	54e040ef          	jal	800058f8 <acquire>
  release(lk);
    800013ae:	854a                	mv	a0,s2
    800013b0:	5dc040ef          	jal	8000598c <release>

  // Go to sleep.
  p->chan = chan;
    800013b4:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013b8:	4789                	li	a5,2
    800013ba:	cc9c                	sw	a5,24(s1)

  sched();
    800013bc:	eefff0ef          	jal	800012aa <sched>

  // Tidy up.
  p->chan = 0;
    800013c0:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013c4:	8526                	mv	a0,s1
    800013c6:	5c6040ef          	jal	8000598c <release>
  acquire(lk);
    800013ca:	854a                	mv	a0,s2
    800013cc:	52c040ef          	jal	800058f8 <acquire>
}
    800013d0:	70a2                	ld	ra,40(sp)
    800013d2:	7402                	ld	s0,32(sp)
    800013d4:	64e2                	ld	s1,24(sp)
    800013d6:	6942                	ld	s2,16(sp)
    800013d8:	69a2                	ld	s3,8(sp)
    800013da:	6145                	addi	sp,sp,48
    800013dc:	8082                	ret

00000000800013de <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013de:	7139                	addi	sp,sp,-64
    800013e0:	fc06                	sd	ra,56(sp)
    800013e2:	f822                	sd	s0,48(sp)
    800013e4:	f426                	sd	s1,40(sp)
    800013e6:	f04a                	sd	s2,32(sp)
    800013e8:	ec4e                	sd	s3,24(sp)
    800013ea:	e852                	sd	s4,16(sp)
    800013ec:	e456                	sd	s5,8(sp)
    800013ee:	0080                	addi	s0,sp,64
    800013f0:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013f2:	00007497          	auipc	s1,0x7
    800013f6:	8be48493          	addi	s1,s1,-1858 # 80007cb0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    800013fa:	4989                	li	s3,2
        p->state = RUNNABLE;
    800013fc:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800013fe:	0000c917          	auipc	s2,0xc
    80001402:	2b290913          	addi	s2,s2,690 # 8000d6b0 <tickslock>
    80001406:	a801                	j	80001416 <wakeup+0x38>
      }
      release(&p->lock);
    80001408:	8526                	mv	a0,s1
    8000140a:	582040ef          	jal	8000598c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000140e:	16848493          	addi	s1,s1,360
    80001412:	03248263          	beq	s1,s2,80001436 <wakeup+0x58>
    if(p != myproc()){
    80001416:	97fff0ef          	jal	80000d94 <myproc>
    8000141a:	fe950ae3          	beq	a0,s1,8000140e <wakeup+0x30>
      acquire(&p->lock);
    8000141e:	8526                	mv	a0,s1
    80001420:	4d8040ef          	jal	800058f8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001424:	4c9c                	lw	a5,24(s1)
    80001426:	ff3791e3          	bne	a5,s3,80001408 <wakeup+0x2a>
    8000142a:	709c                	ld	a5,32(s1)
    8000142c:	fd479ee3          	bne	a5,s4,80001408 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001430:	0154ac23          	sw	s5,24(s1)
    80001434:	bfd1                	j	80001408 <wakeup+0x2a>
    }
  }
}
    80001436:	70e2                	ld	ra,56(sp)
    80001438:	7442                	ld	s0,48(sp)
    8000143a:	74a2                	ld	s1,40(sp)
    8000143c:	7902                	ld	s2,32(sp)
    8000143e:	69e2                	ld	s3,24(sp)
    80001440:	6a42                	ld	s4,16(sp)
    80001442:	6aa2                	ld	s5,8(sp)
    80001444:	6121                	addi	sp,sp,64
    80001446:	8082                	ret

0000000080001448 <reparent>:
{
    80001448:	7179                	addi	sp,sp,-48
    8000144a:	f406                	sd	ra,40(sp)
    8000144c:	f022                	sd	s0,32(sp)
    8000144e:	ec26                	sd	s1,24(sp)
    80001450:	e84a                	sd	s2,16(sp)
    80001452:	e44e                	sd	s3,8(sp)
    80001454:	e052                	sd	s4,0(sp)
    80001456:	1800                	addi	s0,sp,48
    80001458:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000145a:	00007497          	auipc	s1,0x7
    8000145e:	85648493          	addi	s1,s1,-1962 # 80007cb0 <proc>
      pp->parent = initproc;
    80001462:	00006a17          	auipc	s4,0x6
    80001466:	3dea0a13          	addi	s4,s4,990 # 80007840 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000146a:	0000c997          	auipc	s3,0xc
    8000146e:	24698993          	addi	s3,s3,582 # 8000d6b0 <tickslock>
    80001472:	a029                	j	8000147c <reparent+0x34>
    80001474:	16848493          	addi	s1,s1,360
    80001478:	01348b63          	beq	s1,s3,8000148e <reparent+0x46>
    if(pp->parent == p){
    8000147c:	7c9c                	ld	a5,56(s1)
    8000147e:	ff279be3          	bne	a5,s2,80001474 <reparent+0x2c>
      pp->parent = initproc;
    80001482:	000a3503          	ld	a0,0(s4)
    80001486:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001488:	f57ff0ef          	jal	800013de <wakeup>
    8000148c:	b7e5                	j	80001474 <reparent+0x2c>
}
    8000148e:	70a2                	ld	ra,40(sp)
    80001490:	7402                	ld	s0,32(sp)
    80001492:	64e2                	ld	s1,24(sp)
    80001494:	6942                	ld	s2,16(sp)
    80001496:	69a2                	ld	s3,8(sp)
    80001498:	6a02                	ld	s4,0(sp)
    8000149a:	6145                	addi	sp,sp,48
    8000149c:	8082                	ret

000000008000149e <kexit>:
{
    8000149e:	7179                	addi	sp,sp,-48
    800014a0:	f406                	sd	ra,40(sp)
    800014a2:	f022                	sd	s0,32(sp)
    800014a4:	ec26                	sd	s1,24(sp)
    800014a6:	e84a                	sd	s2,16(sp)
    800014a8:	e44e                	sd	s3,8(sp)
    800014aa:	e052                	sd	s4,0(sp)
    800014ac:	1800                	addi	s0,sp,48
    800014ae:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014b0:	8e5ff0ef          	jal	80000d94 <myproc>
    800014b4:	89aa                	mv	s3,a0
  if(p == initproc)
    800014b6:	00006797          	auipc	a5,0x6
    800014ba:	38a7b783          	ld	a5,906(a5) # 80007840 <initproc>
    800014be:	0d050493          	addi	s1,a0,208
    800014c2:	15050913          	addi	s2,a0,336
    800014c6:	00a79b63          	bne	a5,a0,800014dc <kexit+0x3e>
    panic("init exiting");
    800014ca:	00006517          	auipc	a0,0x6
    800014ce:	cb650513          	addi	a0,a0,-842 # 80007180 <etext+0x180>
    800014d2:	164040ef          	jal	80005636 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800014d6:	04a1                	addi	s1,s1,8
    800014d8:	01248963          	beq	s1,s2,800014ea <kexit+0x4c>
    if(p->ofile[fd]){
    800014dc:	6088                	ld	a0,0(s1)
    800014de:	dd65                	beqz	a0,800014d6 <kexit+0x38>
      fileclose(f);
    800014e0:	7ad010ef          	jal	8000348c <fileclose>
      p->ofile[fd] = 0;
    800014e4:	0004b023          	sd	zero,0(s1)
    800014e8:	b7fd                	j	800014d6 <kexit+0x38>
  begin_op();
    800014ea:	37f010ef          	jal	80003068 <begin_op>
  iput(p->cwd);
    800014ee:	1509b503          	ld	a0,336(s3)
    800014f2:	2ec010ef          	jal	800027de <iput>
  end_op();
    800014f6:	3e3010ef          	jal	800030d8 <end_op>
  p->cwd = 0;
    800014fa:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    800014fe:	00006517          	auipc	a0,0x6
    80001502:	39a50513          	addi	a0,a0,922 # 80007898 <wait_lock>
    80001506:	3f2040ef          	jal	800058f8 <acquire>
  reparent(p);
    8000150a:	854e                	mv	a0,s3
    8000150c:	f3dff0ef          	jal	80001448 <reparent>
  wakeup(p->parent);
    80001510:	0389b503          	ld	a0,56(s3)
    80001514:	ecbff0ef          	jal	800013de <wakeup>
  acquire(&p->lock);
    80001518:	854e                	mv	a0,s3
    8000151a:	3de040ef          	jal	800058f8 <acquire>
  p->xstate = status;
    8000151e:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001522:	4795                	li	a5,5
    80001524:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001528:	00006517          	auipc	a0,0x6
    8000152c:	37050513          	addi	a0,a0,880 # 80007898 <wait_lock>
    80001530:	45c040ef          	jal	8000598c <release>
  sched();
    80001534:	d77ff0ef          	jal	800012aa <sched>
  panic("zombie exit");
    80001538:	00006517          	auipc	a0,0x6
    8000153c:	c5850513          	addi	a0,a0,-936 # 80007190 <etext+0x190>
    80001540:	0f6040ef          	jal	80005636 <panic>

0000000080001544 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001544:	7179                	addi	sp,sp,-48
    80001546:	f406                	sd	ra,40(sp)
    80001548:	f022                	sd	s0,32(sp)
    8000154a:	ec26                	sd	s1,24(sp)
    8000154c:	e84a                	sd	s2,16(sp)
    8000154e:	e44e                	sd	s3,8(sp)
    80001550:	1800                	addi	s0,sp,48
    80001552:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001554:	00006497          	auipc	s1,0x6
    80001558:	75c48493          	addi	s1,s1,1884 # 80007cb0 <proc>
    8000155c:	0000c997          	auipc	s3,0xc
    80001560:	15498993          	addi	s3,s3,340 # 8000d6b0 <tickslock>
    acquire(&p->lock);
    80001564:	8526                	mv	a0,s1
    80001566:	392040ef          	jal	800058f8 <acquire>
    if(p->pid == pid){
    8000156a:	589c                	lw	a5,48(s1)
    8000156c:	01278b63          	beq	a5,s2,80001582 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001570:	8526                	mv	a0,s1
    80001572:	41a040ef          	jal	8000598c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001576:	16848493          	addi	s1,s1,360
    8000157a:	ff3495e3          	bne	s1,s3,80001564 <kkill+0x20>
  }
  return -1;
    8000157e:	557d                	li	a0,-1
    80001580:	a819                	j	80001596 <kkill+0x52>
      p->killed = 1;
    80001582:	4785                	li	a5,1
    80001584:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001586:	4c98                	lw	a4,24(s1)
    80001588:	4789                	li	a5,2
    8000158a:	00f70d63          	beq	a4,a5,800015a4 <kkill+0x60>
      release(&p->lock);
    8000158e:	8526                	mv	a0,s1
    80001590:	3fc040ef          	jal	8000598c <release>
      return 0;
    80001594:	4501                	li	a0,0
}
    80001596:	70a2                	ld	ra,40(sp)
    80001598:	7402                	ld	s0,32(sp)
    8000159a:	64e2                	ld	s1,24(sp)
    8000159c:	6942                	ld	s2,16(sp)
    8000159e:	69a2                	ld	s3,8(sp)
    800015a0:	6145                	addi	sp,sp,48
    800015a2:	8082                	ret
        p->state = RUNNABLE;
    800015a4:	478d                	li	a5,3
    800015a6:	cc9c                	sw	a5,24(s1)
    800015a8:	b7dd                	j	8000158e <kkill+0x4a>

00000000800015aa <setkilled>:

void
setkilled(struct proc *p)
{
    800015aa:	1101                	addi	sp,sp,-32
    800015ac:	ec06                	sd	ra,24(sp)
    800015ae:	e822                	sd	s0,16(sp)
    800015b0:	e426                	sd	s1,8(sp)
    800015b2:	1000                	addi	s0,sp,32
    800015b4:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015b6:	342040ef          	jal	800058f8 <acquire>
  p->killed = 1;
    800015ba:	4785                	li	a5,1
    800015bc:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015be:	8526                	mv	a0,s1
    800015c0:	3cc040ef          	jal	8000598c <release>
}
    800015c4:	60e2                	ld	ra,24(sp)
    800015c6:	6442                	ld	s0,16(sp)
    800015c8:	64a2                	ld	s1,8(sp)
    800015ca:	6105                	addi	sp,sp,32
    800015cc:	8082                	ret

00000000800015ce <killed>:

int
killed(struct proc *p)
{
    800015ce:	1101                	addi	sp,sp,-32
    800015d0:	ec06                	sd	ra,24(sp)
    800015d2:	e822                	sd	s0,16(sp)
    800015d4:	e426                	sd	s1,8(sp)
    800015d6:	e04a                	sd	s2,0(sp)
    800015d8:	1000                	addi	s0,sp,32
    800015da:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015dc:	31c040ef          	jal	800058f8 <acquire>
  k = p->killed;
    800015e0:	549c                	lw	a5,40(s1)
    800015e2:	893e                	mv	s2,a5
  release(&p->lock);
    800015e4:	8526                	mv	a0,s1
    800015e6:	3a6040ef          	jal	8000598c <release>
  return k;
}
    800015ea:	854a                	mv	a0,s2
    800015ec:	60e2                	ld	ra,24(sp)
    800015ee:	6442                	ld	s0,16(sp)
    800015f0:	64a2                	ld	s1,8(sp)
    800015f2:	6902                	ld	s2,0(sp)
    800015f4:	6105                	addi	sp,sp,32
    800015f6:	8082                	ret

00000000800015f8 <kwait>:
{
    800015f8:	715d                	addi	sp,sp,-80
    800015fa:	e486                	sd	ra,72(sp)
    800015fc:	e0a2                	sd	s0,64(sp)
    800015fe:	fc26                	sd	s1,56(sp)
    80001600:	f84a                	sd	s2,48(sp)
    80001602:	f44e                	sd	s3,40(sp)
    80001604:	f052                	sd	s4,32(sp)
    80001606:	ec56                	sd	s5,24(sp)
    80001608:	e85a                	sd	s6,16(sp)
    8000160a:	e45e                	sd	s7,8(sp)
    8000160c:	0880                	addi	s0,sp,80
    8000160e:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001610:	f84ff0ef          	jal	80000d94 <myproc>
    80001614:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001616:	00006517          	auipc	a0,0x6
    8000161a:	28250513          	addi	a0,a0,642 # 80007898 <wait_lock>
    8000161e:	2da040ef          	jal	800058f8 <acquire>
        if(pp->state == ZOMBIE){
    80001622:	4a15                	li	s4,5
        havekids = 1;
    80001624:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001626:	0000c997          	auipc	s3,0xc
    8000162a:	08a98993          	addi	s3,s3,138 # 8000d6b0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    8000162e:	00006b17          	auipc	s6,0x6
    80001632:	26ab0b13          	addi	s6,s6,618 # 80007898 <wait_lock>
    80001636:	a869                	j	800016d0 <kwait+0xd8>
          pid = pp->pid;
    80001638:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000163c:	000b8c63          	beqz	s7,80001654 <kwait+0x5c>
    80001640:	4691                	li	a3,4
    80001642:	02c48613          	addi	a2,s1,44
    80001646:	85de                	mv	a1,s7
    80001648:	05093503          	ld	a0,80(s2)
    8000164c:	c6eff0ef          	jal	80000aba <copyout>
    80001650:	02054a63          	bltz	a0,80001684 <kwait+0x8c>
          freeproc(pp);
    80001654:	8526                	mv	a0,s1
    80001656:	913ff0ef          	jal	80000f68 <freeproc>
          release(&pp->lock);
    8000165a:	8526                	mv	a0,s1
    8000165c:	330040ef          	jal	8000598c <release>
          release(&wait_lock);
    80001660:	00006517          	auipc	a0,0x6
    80001664:	23850513          	addi	a0,a0,568 # 80007898 <wait_lock>
    80001668:	324040ef          	jal	8000598c <release>
}
    8000166c:	854e                	mv	a0,s3
    8000166e:	60a6                	ld	ra,72(sp)
    80001670:	6406                	ld	s0,64(sp)
    80001672:	74e2                	ld	s1,56(sp)
    80001674:	7942                	ld	s2,48(sp)
    80001676:	79a2                	ld	s3,40(sp)
    80001678:	7a02                	ld	s4,32(sp)
    8000167a:	6ae2                	ld	s5,24(sp)
    8000167c:	6b42                	ld	s6,16(sp)
    8000167e:	6ba2                	ld	s7,8(sp)
    80001680:	6161                	addi	sp,sp,80
    80001682:	8082                	ret
            release(&pp->lock);
    80001684:	8526                	mv	a0,s1
    80001686:	306040ef          	jal	8000598c <release>
            release(&wait_lock);
    8000168a:	00006517          	auipc	a0,0x6
    8000168e:	20e50513          	addi	a0,a0,526 # 80007898 <wait_lock>
    80001692:	2fa040ef          	jal	8000598c <release>
            return -1;
    80001696:	59fd                	li	s3,-1
    80001698:	bfd1                	j	8000166c <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000169a:	16848493          	addi	s1,s1,360
    8000169e:	03348063          	beq	s1,s3,800016be <kwait+0xc6>
      if(pp->parent == p){
    800016a2:	7c9c                	ld	a5,56(s1)
    800016a4:	ff279be3          	bne	a5,s2,8000169a <kwait+0xa2>
        acquire(&pp->lock);
    800016a8:	8526                	mv	a0,s1
    800016aa:	24e040ef          	jal	800058f8 <acquire>
        if(pp->state == ZOMBIE){
    800016ae:	4c9c                	lw	a5,24(s1)
    800016b0:	f94784e3          	beq	a5,s4,80001638 <kwait+0x40>
        release(&pp->lock);
    800016b4:	8526                	mv	a0,s1
    800016b6:	2d6040ef          	jal	8000598c <release>
        havekids = 1;
    800016ba:	8756                	mv	a4,s5
    800016bc:	bff9                	j	8000169a <kwait+0xa2>
    if(!havekids || killed(p)){
    800016be:	cf19                	beqz	a4,800016dc <kwait+0xe4>
    800016c0:	854a                	mv	a0,s2
    800016c2:	f0dff0ef          	jal	800015ce <killed>
    800016c6:	e919                	bnez	a0,800016dc <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016c8:	85da                	mv	a1,s6
    800016ca:	854a                	mv	a0,s2
    800016cc:	cc7ff0ef          	jal	80001392 <sleep>
    havekids = 0;
    800016d0:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016d2:	00006497          	auipc	s1,0x6
    800016d6:	5de48493          	addi	s1,s1,1502 # 80007cb0 <proc>
    800016da:	b7e1                	j	800016a2 <kwait+0xaa>
      release(&wait_lock);
    800016dc:	00006517          	auipc	a0,0x6
    800016e0:	1bc50513          	addi	a0,a0,444 # 80007898 <wait_lock>
    800016e4:	2a8040ef          	jal	8000598c <release>
      return -1;
    800016e8:	59fd                	li	s3,-1
    800016ea:	b749                	j	8000166c <kwait+0x74>

00000000800016ec <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016ec:	7179                	addi	sp,sp,-48
    800016ee:	f406                	sd	ra,40(sp)
    800016f0:	f022                	sd	s0,32(sp)
    800016f2:	ec26                	sd	s1,24(sp)
    800016f4:	e84a                	sd	s2,16(sp)
    800016f6:	e44e                	sd	s3,8(sp)
    800016f8:	e052                	sd	s4,0(sp)
    800016fa:	1800                	addi	s0,sp,48
    800016fc:	84aa                	mv	s1,a0
    800016fe:	8a2e                	mv	s4,a1
    80001700:	89b2                	mv	s3,a2
    80001702:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001704:	e90ff0ef          	jal	80000d94 <myproc>
  if(user_dst){
    80001708:	cc99                	beqz	s1,80001726 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000170a:	86ca                	mv	a3,s2
    8000170c:	864e                	mv	a2,s3
    8000170e:	85d2                	mv	a1,s4
    80001710:	6928                	ld	a0,80(a0)
    80001712:	ba8ff0ef          	jal	80000aba <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001716:	70a2                	ld	ra,40(sp)
    80001718:	7402                	ld	s0,32(sp)
    8000171a:	64e2                	ld	s1,24(sp)
    8000171c:	6942                	ld	s2,16(sp)
    8000171e:	69a2                	ld	s3,8(sp)
    80001720:	6a02                	ld	s4,0(sp)
    80001722:	6145                	addi	sp,sp,48
    80001724:	8082                	ret
    memmove((char *)dst, src, len);
    80001726:	0009061b          	sext.w	a2,s2
    8000172a:	85ce                	mv	a1,s3
    8000172c:	8552                	mv	a0,s4
    8000172e:	a91fe0ef          	jal	800001be <memmove>
    return 0;
    80001732:	8526                	mv	a0,s1
    80001734:	b7cd                	j	80001716 <either_copyout+0x2a>

0000000080001736 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001736:	7179                	addi	sp,sp,-48
    80001738:	f406                	sd	ra,40(sp)
    8000173a:	f022                	sd	s0,32(sp)
    8000173c:	ec26                	sd	s1,24(sp)
    8000173e:	e84a                	sd	s2,16(sp)
    80001740:	e44e                	sd	s3,8(sp)
    80001742:	e052                	sd	s4,0(sp)
    80001744:	1800                	addi	s0,sp,48
    80001746:	8a2a                	mv	s4,a0
    80001748:	84ae                	mv	s1,a1
    8000174a:	89b2                	mv	s3,a2
    8000174c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000174e:	e46ff0ef          	jal	80000d94 <myproc>
  if(user_src){
    80001752:	cc99                	beqz	s1,80001770 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001754:	86ca                	mv	a3,s2
    80001756:	864e                	mv	a2,s3
    80001758:	85d2                	mv	a1,s4
    8000175a:	6928                	ld	a0,80(a0)
    8000175c:	c1cff0ef          	jal	80000b78 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001760:	70a2                	ld	ra,40(sp)
    80001762:	7402                	ld	s0,32(sp)
    80001764:	64e2                	ld	s1,24(sp)
    80001766:	6942                	ld	s2,16(sp)
    80001768:	69a2                	ld	s3,8(sp)
    8000176a:	6a02                	ld	s4,0(sp)
    8000176c:	6145                	addi	sp,sp,48
    8000176e:	8082                	ret
    memmove(dst, (char*)src, len);
    80001770:	0009061b          	sext.w	a2,s2
    80001774:	85ce                	mv	a1,s3
    80001776:	8552                	mv	a0,s4
    80001778:	a47fe0ef          	jal	800001be <memmove>
    return 0;
    8000177c:	8526                	mv	a0,s1
    8000177e:	b7cd                	j	80001760 <either_copyin+0x2a>

0000000080001780 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001780:	715d                	addi	sp,sp,-80
    80001782:	e486                	sd	ra,72(sp)
    80001784:	e0a2                	sd	s0,64(sp)
    80001786:	fc26                	sd	s1,56(sp)
    80001788:	f84a                	sd	s2,48(sp)
    8000178a:	f44e                	sd	s3,40(sp)
    8000178c:	f052                	sd	s4,32(sp)
    8000178e:	ec56                	sd	s5,24(sp)
    80001790:	e85a                	sd	s6,16(sp)
    80001792:	e45e                	sd	s7,8(sp)
    80001794:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001796:	00006517          	auipc	a0,0x6
    8000179a:	88250513          	addi	a0,a0,-1918 # 80007018 <etext+0x18>
    8000179e:	36f030ef          	jal	8000530c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017a2:	00006497          	auipc	s1,0x6
    800017a6:	66648493          	addi	s1,s1,1638 # 80007e08 <proc+0x158>
    800017aa:	0000c917          	auipc	s2,0xc
    800017ae:	05e90913          	addi	s2,s2,94 # 8000d808 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017b2:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017b4:	00006997          	auipc	s3,0x6
    800017b8:	9ec98993          	addi	s3,s3,-1556 # 800071a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    800017bc:	00006a97          	auipc	s5,0x6
    800017c0:	9eca8a93          	addi	s5,s5,-1556 # 800071a8 <etext+0x1a8>
    printf("\n");
    800017c4:	00006a17          	auipc	s4,0x6
    800017c8:	854a0a13          	addi	s4,s4,-1964 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017cc:	00006b97          	auipc	s7,0x6
    800017d0:	f44b8b93          	addi	s7,s7,-188 # 80007710 <states.0>
    800017d4:	a829                	j	800017ee <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017d6:	ed86a583          	lw	a1,-296(a3)
    800017da:	8556                	mv	a0,s5
    800017dc:	331030ef          	jal	8000530c <printf>
    printf("\n");
    800017e0:	8552                	mv	a0,s4
    800017e2:	32b030ef          	jal	8000530c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017e6:	16848493          	addi	s1,s1,360
    800017ea:	03248263          	beq	s1,s2,8000180e <procdump+0x8e>
    if(p->state == UNUSED)
    800017ee:	86a6                	mv	a3,s1
    800017f0:	ec04a783          	lw	a5,-320(s1)
    800017f4:	dbed                	beqz	a5,800017e6 <procdump+0x66>
      state = "???";
    800017f6:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017f8:	fcfb6fe3          	bltu	s6,a5,800017d6 <procdump+0x56>
    800017fc:	02079713          	slli	a4,a5,0x20
    80001800:	01d75793          	srli	a5,a4,0x1d
    80001804:	97de                	add	a5,a5,s7
    80001806:	6390                	ld	a2,0(a5)
    80001808:	f679                	bnez	a2,800017d6 <procdump+0x56>
      state = "???";
    8000180a:	864e                	mv	a2,s3
    8000180c:	b7e9                	j	800017d6 <procdump+0x56>
  }
}
    8000180e:	60a6                	ld	ra,72(sp)
    80001810:	6406                	ld	s0,64(sp)
    80001812:	74e2                	ld	s1,56(sp)
    80001814:	7942                	ld	s2,48(sp)
    80001816:	79a2                	ld	s3,40(sp)
    80001818:	7a02                	ld	s4,32(sp)
    8000181a:	6ae2                	ld	s5,24(sp)
    8000181c:	6b42                	ld	s6,16(sp)
    8000181e:	6ba2                	ld	s7,8(sp)
    80001820:	6161                	addi	sp,sp,80
    80001822:	8082                	ret

0000000080001824 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001824:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001828:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000182c:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    8000182e:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001830:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001834:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001838:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000183c:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001840:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001844:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001848:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000184c:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001850:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001854:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001858:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000185c:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001860:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001862:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001864:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001868:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000186c:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001870:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001874:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001878:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000187c:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001880:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001884:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001888:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000188c:	8082                	ret

000000008000188e <trapinit>:

extern int devintr();

void
trapinit(void)
{
    8000188e:	1141                	addi	sp,sp,-16
    80001890:	e406                	sd	ra,8(sp)
    80001892:	e022                	sd	s0,0(sp)
    80001894:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001896:	00006597          	auipc	a1,0x6
    8000189a:	95258593          	addi	a1,a1,-1710 # 800071e8 <etext+0x1e8>
    8000189e:	0000c517          	auipc	a0,0xc
    800018a2:	e1250513          	addi	a0,a0,-494 # 8000d6b0 <tickslock>
    800018a6:	7c9030ef          	jal	8000586e <initlock>
}
    800018aa:	60a2                	ld	ra,8(sp)
    800018ac:	6402                	ld	s0,0(sp)
    800018ae:	0141                	addi	sp,sp,16
    800018b0:	8082                	ret

00000000800018b2 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018b2:	1141                	addi	sp,sp,-16
    800018b4:	e406                	sd	ra,8(sp)
    800018b6:	e022                	sd	s0,0(sp)
    800018b8:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018ba:	00003797          	auipc	a5,0x3
    800018be:	f8678793          	addi	a5,a5,-122 # 80004840 <kernelvec>
    800018c2:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018c6:	60a2                	ld	ra,8(sp)
    800018c8:	6402                	ld	s0,0(sp)
    800018ca:	0141                	addi	sp,sp,16
    800018cc:	8082                	ret

00000000800018ce <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018ce:	1141                	addi	sp,sp,-16
    800018d0:	e406                	sd	ra,8(sp)
    800018d2:	e022                	sd	s0,0(sp)
    800018d4:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018d6:	cbeff0ef          	jal	80000d94 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018da:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018de:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018e0:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018e4:	04000737          	lui	a4,0x4000
    800018e8:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018ea:	0732                	slli	a4,a4,0xc
    800018ec:	00004797          	auipc	a5,0x4
    800018f0:	71478793          	addi	a5,a5,1812 # 80006000 <_trampoline>
    800018f4:	00004697          	auipc	a3,0x4
    800018f8:	70c68693          	addi	a3,a3,1804 # 80006000 <_trampoline>
    800018fc:	8f95                	sub	a5,a5,a3
    800018fe:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001900:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001904:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001906:	18002773          	csrr	a4,satp
    8000190a:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000190c:	6d38                	ld	a4,88(a0)
    8000190e:	613c                	ld	a5,64(a0)
    80001910:	6685                	lui	a3,0x1
    80001912:	97b6                	add	a5,a5,a3
    80001914:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001916:	6d3c                	ld	a5,88(a0)
    80001918:	00000717          	auipc	a4,0x0
    8000191c:	0fc70713          	addi	a4,a4,252 # 80001a14 <usertrap>
    80001920:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001922:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001924:	8712                	mv	a4,tp
    80001926:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001928:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000192c:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001930:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001934:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001938:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000193a:	6f9c                	ld	a5,24(a5)
    8000193c:	14179073          	csrw	sepc,a5
}
    80001940:	60a2                	ld	ra,8(sp)
    80001942:	6402                	ld	s0,0(sp)
    80001944:	0141                	addi	sp,sp,16
    80001946:	8082                	ret

0000000080001948 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001948:	1141                	addi	sp,sp,-16
    8000194a:	e406                	sd	ra,8(sp)
    8000194c:	e022                	sd	s0,0(sp)
    8000194e:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001950:	c10ff0ef          	jal	80000d60 <cpuid>
    80001954:	cd11                	beqz	a0,80001970 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001956:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000195a:	000f4737          	lui	a4,0xf4
    8000195e:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001962:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001964:	14d79073          	csrw	stimecmp,a5
}
    80001968:	60a2                	ld	ra,8(sp)
    8000196a:	6402                	ld	s0,0(sp)
    8000196c:	0141                	addi	sp,sp,16
    8000196e:	8082                	ret
    acquire(&tickslock);
    80001970:	0000c517          	auipc	a0,0xc
    80001974:	d4050513          	addi	a0,a0,-704 # 8000d6b0 <tickslock>
    80001978:	781030ef          	jal	800058f8 <acquire>
    ticks++;
    8000197c:	00006717          	auipc	a4,0x6
    80001980:	ecc70713          	addi	a4,a4,-308 # 80007848 <ticks>
    80001984:	431c                	lw	a5,0(a4)
    80001986:	2785                	addiw	a5,a5,1
    80001988:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    8000198a:	853a                	mv	a0,a4
    8000198c:	a53ff0ef          	jal	800013de <wakeup>
    release(&tickslock);
    80001990:	0000c517          	auipc	a0,0xc
    80001994:	d2050513          	addi	a0,a0,-736 # 8000d6b0 <tickslock>
    80001998:	7f5030ef          	jal	8000598c <release>
    8000199c:	bf6d                	j	80001956 <clockintr+0xe>

000000008000199e <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    8000199e:	1101                	addi	sp,sp,-32
    800019a0:	ec06                	sd	ra,24(sp)
    800019a2:	e822                	sd	s0,16(sp)
    800019a4:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019a6:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019aa:	57fd                	li	a5,-1
    800019ac:	17fe                	slli	a5,a5,0x3f
    800019ae:	07a5                	addi	a5,a5,9
    800019b0:	00f70c63          	beq	a4,a5,800019c8 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019b4:	57fd                	li	a5,-1
    800019b6:	17fe                	slli	a5,a5,0x3f
    800019b8:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019ba:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019bc:	04f70863          	beq	a4,a5,80001a0c <devintr+0x6e>
  }
}
    800019c0:	60e2                	ld	ra,24(sp)
    800019c2:	6442                	ld	s0,16(sp)
    800019c4:	6105                	addi	sp,sp,32
    800019c6:	8082                	ret
    800019c8:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019ca:	723020ef          	jal	800048ec <plic_claim>
    800019ce:	872a                	mv	a4,a0
    800019d0:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019d2:	47a9                	li	a5,10
    800019d4:	00f50963          	beq	a0,a5,800019e6 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    800019d8:	4785                	li	a5,1
    800019da:	00f50963          	beq	a0,a5,800019ec <devintr+0x4e>
    return 1;
    800019de:	4505                	li	a0,1
    } else if(irq){
    800019e0:	eb09                	bnez	a4,800019f2 <devintr+0x54>
    800019e2:	64a2                	ld	s1,8(sp)
    800019e4:	bff1                	j	800019c0 <devintr+0x22>
      uartintr();
    800019e6:	621030ef          	jal	80005806 <uartintr>
    if(irq)
    800019ea:	a819                	j	80001a00 <devintr+0x62>
      virtio_disk_intr();
    800019ec:	396030ef          	jal	80004d82 <virtio_disk_intr>
    if(irq)
    800019f0:	a801                	j	80001a00 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    800019f2:	85ba                	mv	a1,a4
    800019f4:	00005517          	auipc	a0,0x5
    800019f8:	7fc50513          	addi	a0,a0,2044 # 800071f0 <etext+0x1f0>
    800019fc:	111030ef          	jal	8000530c <printf>
      plic_complete(irq);
    80001a00:	8526                	mv	a0,s1
    80001a02:	70b020ef          	jal	8000490c <plic_complete>
    return 1;
    80001a06:	4505                	li	a0,1
    80001a08:	64a2                	ld	s1,8(sp)
    80001a0a:	bf5d                	j	800019c0 <devintr+0x22>
    clockintr();
    80001a0c:	f3dff0ef          	jal	80001948 <clockintr>
    return 2;
    80001a10:	4509                	li	a0,2
    80001a12:	b77d                	j	800019c0 <devintr+0x22>

0000000080001a14 <usertrap>:
{
    80001a14:	1101                	addi	sp,sp,-32
    80001a16:	ec06                	sd	ra,24(sp)
    80001a18:	e822                	sd	s0,16(sp)
    80001a1a:	e426                	sd	s1,8(sp)
    80001a1c:	e04a                	sd	s2,0(sp)
    80001a1e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a20:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a24:	1007f793          	andi	a5,a5,256
    80001a28:	eba5                	bnez	a5,80001a98 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a2a:	00003797          	auipc	a5,0x3
    80001a2e:	e1678793          	addi	a5,a5,-490 # 80004840 <kernelvec>
    80001a32:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a36:	b5eff0ef          	jal	80000d94 <myproc>
    80001a3a:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a3c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a3e:	14102773          	csrr	a4,sepc
    80001a42:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a44:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a48:	47a1                	li	a5,8
    80001a4a:	04f70d63          	beq	a4,a5,80001aa4 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a4e:	f51ff0ef          	jal	8000199e <devintr>
    80001a52:	892a                	mv	s2,a0
    80001a54:	e945                	bnez	a0,80001b04 <usertrap+0xf0>
    80001a56:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a5a:	47bd                	li	a5,15
    80001a5c:	08f70863          	beq	a4,a5,80001aec <usertrap+0xd8>
    80001a60:	14202773          	csrr	a4,scause
    80001a64:	47b5                	li	a5,13
    80001a66:	08f70363          	beq	a4,a5,80001aec <usertrap+0xd8>
    80001a6a:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a6e:	5890                	lw	a2,48(s1)
    80001a70:	00005517          	auipc	a0,0x5
    80001a74:	7c050513          	addi	a0,a0,1984 # 80007230 <etext+0x230>
    80001a78:	095030ef          	jal	8000530c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a80:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a84:	00005517          	auipc	a0,0x5
    80001a88:	7dc50513          	addi	a0,a0,2012 # 80007260 <etext+0x260>
    80001a8c:	081030ef          	jal	8000530c <printf>
    setkilled(p);
    80001a90:	8526                	mv	a0,s1
    80001a92:	b19ff0ef          	jal	800015aa <setkilled>
    80001a96:	a035                	j	80001ac2 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a98:	00005517          	auipc	a0,0x5
    80001a9c:	77850513          	addi	a0,a0,1912 # 80007210 <etext+0x210>
    80001aa0:	397030ef          	jal	80005636 <panic>
    if(killed(p))
    80001aa4:	b2bff0ef          	jal	800015ce <killed>
    80001aa8:	ed15                	bnez	a0,80001ae4 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001aaa:	6cb8                	ld	a4,88(s1)
    80001aac:	6f1c                	ld	a5,24(a4)
    80001aae:	0791                	addi	a5,a5,4
    80001ab0:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ab6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001aba:	10079073          	csrw	sstatus,a5
    syscall();
    80001abe:	240000ef          	jal	80001cfe <syscall>
  if(killed(p))
    80001ac2:	8526                	mv	a0,s1
    80001ac4:	b0bff0ef          	jal	800015ce <killed>
    80001ac8:	e139                	bnez	a0,80001b0e <usertrap+0xfa>
  prepare_return();
    80001aca:	e05ff0ef          	jal	800018ce <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ace:	68a8                	ld	a0,80(s1)
    80001ad0:	8131                	srli	a0,a0,0xc
    80001ad2:	57fd                	li	a5,-1
    80001ad4:	17fe                	slli	a5,a5,0x3f
    80001ad6:	8d5d                	or	a0,a0,a5
}
    80001ad8:	60e2                	ld	ra,24(sp)
    80001ada:	6442                	ld	s0,16(sp)
    80001adc:	64a2                	ld	s1,8(sp)
    80001ade:	6902                	ld	s2,0(sp)
    80001ae0:	6105                	addi	sp,sp,32
    80001ae2:	8082                	ret
      kexit(-1);
    80001ae4:	557d                	li	a0,-1
    80001ae6:	9b9ff0ef          	jal	8000149e <kexit>
    80001aea:	b7c1                	j	80001aaa <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001aec:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001af0:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001af4:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001af6:	00163613          	seqz	a2,a2
    80001afa:	68a8                	ld	a0,80(s1)
    80001afc:	f3bfe0ef          	jal	80000a36 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b00:	f169                	bnez	a0,80001ac2 <usertrap+0xae>
    80001b02:	b7a5                	j	80001a6a <usertrap+0x56>
  if(killed(p))
    80001b04:	8526                	mv	a0,s1
    80001b06:	ac9ff0ef          	jal	800015ce <killed>
    80001b0a:	c511                	beqz	a0,80001b16 <usertrap+0x102>
    80001b0c:	a011                	j	80001b10 <usertrap+0xfc>
    80001b0e:	4901                	li	s2,0
    kexit(-1);
    80001b10:	557d                	li	a0,-1
    80001b12:	98dff0ef          	jal	8000149e <kexit>
  if(which_dev == 2)
    80001b16:	4789                	li	a5,2
    80001b18:	faf919e3          	bne	s2,a5,80001aca <usertrap+0xb6>
    yield();
    80001b1c:	84bff0ef          	jal	80001366 <yield>
    80001b20:	b76d                	j	80001aca <usertrap+0xb6>

0000000080001b22 <kerneltrap>:
{
    80001b22:	7179                	addi	sp,sp,-48
    80001b24:	f406                	sd	ra,40(sp)
    80001b26:	f022                	sd	s0,32(sp)
    80001b28:	ec26                	sd	s1,24(sp)
    80001b2a:	e84a                	sd	s2,16(sp)
    80001b2c:	e44e                	sd	s3,8(sp)
    80001b2e:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b30:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b34:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b38:	142027f3          	csrr	a5,scause
    80001b3c:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001b3e:	1004f793          	andi	a5,s1,256
    80001b42:	c795                	beqz	a5,80001b6e <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b44:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b48:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b4a:	eb85                	bnez	a5,80001b7a <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001b4c:	e53ff0ef          	jal	8000199e <devintr>
    80001b50:	c91d                	beqz	a0,80001b86 <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001b52:	4789                	li	a5,2
    80001b54:	04f50a63          	beq	a0,a5,80001ba8 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b58:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5c:	10049073          	csrw	sstatus,s1
}
    80001b60:	70a2                	ld	ra,40(sp)
    80001b62:	7402                	ld	s0,32(sp)
    80001b64:	64e2                	ld	s1,24(sp)
    80001b66:	6942                	ld	s2,16(sp)
    80001b68:	69a2                	ld	s3,8(sp)
    80001b6a:	6145                	addi	sp,sp,48
    80001b6c:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b6e:	00005517          	auipc	a0,0x5
    80001b72:	71a50513          	addi	a0,a0,1818 # 80007288 <etext+0x288>
    80001b76:	2c1030ef          	jal	80005636 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b7a:	00005517          	auipc	a0,0x5
    80001b7e:	73650513          	addi	a0,a0,1846 # 800072b0 <etext+0x2b0>
    80001b82:	2b5030ef          	jal	80005636 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b86:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b8a:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b8e:	85ce                	mv	a1,s3
    80001b90:	00005517          	auipc	a0,0x5
    80001b94:	74050513          	addi	a0,a0,1856 # 800072d0 <etext+0x2d0>
    80001b98:	774030ef          	jal	8000530c <printf>
    panic("kerneltrap");
    80001b9c:	00005517          	auipc	a0,0x5
    80001ba0:	75c50513          	addi	a0,a0,1884 # 800072f8 <etext+0x2f8>
    80001ba4:	293030ef          	jal	80005636 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001ba8:	9ecff0ef          	jal	80000d94 <myproc>
    80001bac:	d555                	beqz	a0,80001b58 <kerneltrap+0x36>
    yield();
    80001bae:	fb8ff0ef          	jal	80001366 <yield>
    80001bb2:	b75d                	j	80001b58 <kerneltrap+0x36>

0000000080001bb4 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bb4:	1101                	addi	sp,sp,-32
    80001bb6:	ec06                	sd	ra,24(sp)
    80001bb8:	e822                	sd	s0,16(sp)
    80001bba:	e426                	sd	s1,8(sp)
    80001bbc:	1000                	addi	s0,sp,32
    80001bbe:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bc0:	9d4ff0ef          	jal	80000d94 <myproc>
  switch (n) {
    80001bc4:	4795                	li	a5,5
    80001bc6:	0497e163          	bltu	a5,s1,80001c08 <argraw+0x54>
    80001bca:	048a                	slli	s1,s1,0x2
    80001bcc:	00006717          	auipc	a4,0x6
    80001bd0:	b7470713          	addi	a4,a4,-1164 # 80007740 <states.0+0x30>
    80001bd4:	94ba                	add	s1,s1,a4
    80001bd6:	409c                	lw	a5,0(s1)
    80001bd8:	97ba                	add	a5,a5,a4
    80001bda:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bdc:	6d3c                	ld	a5,88(a0)
    80001bde:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001be0:	60e2                	ld	ra,24(sp)
    80001be2:	6442                	ld	s0,16(sp)
    80001be4:	64a2                	ld	s1,8(sp)
    80001be6:	6105                	addi	sp,sp,32
    80001be8:	8082                	ret
    return p->trapframe->a1;
    80001bea:	6d3c                	ld	a5,88(a0)
    80001bec:	7fa8                	ld	a0,120(a5)
    80001bee:	bfcd                	j	80001be0 <argraw+0x2c>
    return p->trapframe->a2;
    80001bf0:	6d3c                	ld	a5,88(a0)
    80001bf2:	63c8                	ld	a0,128(a5)
    80001bf4:	b7f5                	j	80001be0 <argraw+0x2c>
    return p->trapframe->a3;
    80001bf6:	6d3c                	ld	a5,88(a0)
    80001bf8:	67c8                	ld	a0,136(a5)
    80001bfa:	b7dd                	j	80001be0 <argraw+0x2c>
    return p->trapframe->a4;
    80001bfc:	6d3c                	ld	a5,88(a0)
    80001bfe:	6bc8                	ld	a0,144(a5)
    80001c00:	b7c5                	j	80001be0 <argraw+0x2c>
    return p->trapframe->a5;
    80001c02:	6d3c                	ld	a5,88(a0)
    80001c04:	6fc8                	ld	a0,152(a5)
    80001c06:	bfe9                	j	80001be0 <argraw+0x2c>
  panic("argraw");
    80001c08:	00005517          	auipc	a0,0x5
    80001c0c:	70050513          	addi	a0,a0,1792 # 80007308 <etext+0x308>
    80001c10:	227030ef          	jal	80005636 <panic>

0000000080001c14 <fetchaddr>:
{
    80001c14:	1101                	addi	sp,sp,-32
    80001c16:	ec06                	sd	ra,24(sp)
    80001c18:	e822                	sd	s0,16(sp)
    80001c1a:	e426                	sd	s1,8(sp)
    80001c1c:	e04a                	sd	s2,0(sp)
    80001c1e:	1000                	addi	s0,sp,32
    80001c20:	84aa                	mv	s1,a0
    80001c22:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c24:	970ff0ef          	jal	80000d94 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c28:	653c                	ld	a5,72(a0)
    80001c2a:	02f4f663          	bgeu	s1,a5,80001c56 <fetchaddr+0x42>
    80001c2e:	00848713          	addi	a4,s1,8
    80001c32:	02e7e463          	bltu	a5,a4,80001c5a <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c36:	46a1                	li	a3,8
    80001c38:	8626                	mv	a2,s1
    80001c3a:	85ca                	mv	a1,s2
    80001c3c:	6928                	ld	a0,80(a0)
    80001c3e:	f3bfe0ef          	jal	80000b78 <copyin>
    80001c42:	00a03533          	snez	a0,a0
    80001c46:	40a0053b          	negw	a0,a0
}
    80001c4a:	60e2                	ld	ra,24(sp)
    80001c4c:	6442                	ld	s0,16(sp)
    80001c4e:	64a2                	ld	s1,8(sp)
    80001c50:	6902                	ld	s2,0(sp)
    80001c52:	6105                	addi	sp,sp,32
    80001c54:	8082                	ret
    return -1;
    80001c56:	557d                	li	a0,-1
    80001c58:	bfcd                	j	80001c4a <fetchaddr+0x36>
    80001c5a:	557d                	li	a0,-1
    80001c5c:	b7fd                	j	80001c4a <fetchaddr+0x36>

0000000080001c5e <fetchstr>:
{
    80001c5e:	7179                	addi	sp,sp,-48
    80001c60:	f406                	sd	ra,40(sp)
    80001c62:	f022                	sd	s0,32(sp)
    80001c64:	ec26                	sd	s1,24(sp)
    80001c66:	e84a                	sd	s2,16(sp)
    80001c68:	e44e                	sd	s3,8(sp)
    80001c6a:	1800                	addi	s0,sp,48
    80001c6c:	89aa                	mv	s3,a0
    80001c6e:	84ae                	mv	s1,a1
    80001c70:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001c72:	922ff0ef          	jal	80000d94 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c76:	86ca                	mv	a3,s2
    80001c78:	864e                	mv	a2,s3
    80001c7a:	85a6                	mv	a1,s1
    80001c7c:	6928                	ld	a0,80(a0)
    80001c7e:	ce1fe0ef          	jal	8000095e <copyinstr>
    80001c82:	00054c63          	bltz	a0,80001c9a <fetchstr+0x3c>
  return strlen(buf);
    80001c86:	8526                	mv	a0,s1
    80001c88:	e60fe0ef          	jal	800002e8 <strlen>
}
    80001c8c:	70a2                	ld	ra,40(sp)
    80001c8e:	7402                	ld	s0,32(sp)
    80001c90:	64e2                	ld	s1,24(sp)
    80001c92:	6942                	ld	s2,16(sp)
    80001c94:	69a2                	ld	s3,8(sp)
    80001c96:	6145                	addi	sp,sp,48
    80001c98:	8082                	ret
    return -1;
    80001c9a:	557d                	li	a0,-1
    80001c9c:	bfc5                	j	80001c8c <fetchstr+0x2e>

0000000080001c9e <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001c9e:	1101                	addi	sp,sp,-32
    80001ca0:	ec06                	sd	ra,24(sp)
    80001ca2:	e822                	sd	s0,16(sp)
    80001ca4:	e426                	sd	s1,8(sp)
    80001ca6:	1000                	addi	s0,sp,32
    80001ca8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001caa:	f0bff0ef          	jal	80001bb4 <argraw>
    80001cae:	c088                	sw	a0,0(s1)
}
    80001cb0:	60e2                	ld	ra,24(sp)
    80001cb2:	6442                	ld	s0,16(sp)
    80001cb4:	64a2                	ld	s1,8(sp)
    80001cb6:	6105                	addi	sp,sp,32
    80001cb8:	8082                	ret

0000000080001cba <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cba:	1101                	addi	sp,sp,-32
    80001cbc:	ec06                	sd	ra,24(sp)
    80001cbe:	e822                	sd	s0,16(sp)
    80001cc0:	e426                	sd	s1,8(sp)
    80001cc2:	1000                	addi	s0,sp,32
    80001cc4:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cc6:	eefff0ef          	jal	80001bb4 <argraw>
    80001cca:	e088                	sd	a0,0(s1)
}
    80001ccc:	60e2                	ld	ra,24(sp)
    80001cce:	6442                	ld	s0,16(sp)
    80001cd0:	64a2                	ld	s1,8(sp)
    80001cd2:	6105                	addi	sp,sp,32
    80001cd4:	8082                	ret

0000000080001cd6 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cd6:	1101                	addi	sp,sp,-32
    80001cd8:	ec06                	sd	ra,24(sp)
    80001cda:	e822                	sd	s0,16(sp)
    80001cdc:	e426                	sd	s1,8(sp)
    80001cde:	e04a                	sd	s2,0(sp)
    80001ce0:	1000                	addi	s0,sp,32
    80001ce2:	892e                	mv	s2,a1
    80001ce4:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001ce6:	ecfff0ef          	jal	80001bb4 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001cea:	8626                	mv	a2,s1
    80001cec:	85ca                	mv	a1,s2
    80001cee:	f71ff0ef          	jal	80001c5e <fetchstr>
}
    80001cf2:	60e2                	ld	ra,24(sp)
    80001cf4:	6442                	ld	s0,16(sp)
    80001cf6:	64a2                	ld	s1,8(sp)
    80001cf8:	6902                	ld	s2,0(sp)
    80001cfa:	6105                	addi	sp,sp,32
    80001cfc:	8082                	ret

0000000080001cfe <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001cfe:	1101                	addi	sp,sp,-32
    80001d00:	ec06                	sd	ra,24(sp)
    80001d02:	e822                	sd	s0,16(sp)
    80001d04:	e426                	sd	s1,8(sp)
    80001d06:	e04a                	sd	s2,0(sp)
    80001d08:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d0a:	88aff0ef          	jal	80000d94 <myproc>
    80001d0e:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d10:	05853903          	ld	s2,88(a0)
    80001d14:	0a893783          	ld	a5,168(s2)
    80001d18:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d1c:	37fd                	addiw	a5,a5,-1
    80001d1e:	4751                	li	a4,20
    80001d20:	00f76f63          	bltu	a4,a5,80001d3e <syscall+0x40>
    80001d24:	00369713          	slli	a4,a3,0x3
    80001d28:	00006797          	auipc	a5,0x6
    80001d2c:	a3078793          	addi	a5,a5,-1488 # 80007758 <syscalls>
    80001d30:	97ba                	add	a5,a5,a4
    80001d32:	639c                	ld	a5,0(a5)
    80001d34:	c789                	beqz	a5,80001d3e <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d36:	9782                	jalr	a5
    80001d38:	06a93823          	sd	a0,112(s2)
    80001d3c:	a829                	j	80001d56 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d3e:	15848613          	addi	a2,s1,344
    80001d42:	588c                	lw	a1,48(s1)
    80001d44:	00005517          	auipc	a0,0x5
    80001d48:	5cc50513          	addi	a0,a0,1484 # 80007310 <etext+0x310>
    80001d4c:	5c0030ef          	jal	8000530c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d50:	6cbc                	ld	a5,88(s1)
    80001d52:	577d                	li	a4,-1
    80001d54:	fbb8                	sd	a4,112(a5)
  }
}
    80001d56:	60e2                	ld	ra,24(sp)
    80001d58:	6442                	ld	s0,16(sp)
    80001d5a:	64a2                	ld	s1,8(sp)
    80001d5c:	6902                	ld	s2,0(sp)
    80001d5e:	6105                	addi	sp,sp,32
    80001d60:	8082                	ret

0000000080001d62 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001d62:	1101                	addi	sp,sp,-32
    80001d64:	ec06                	sd	ra,24(sp)
    80001d66:	e822                	sd	s0,16(sp)
    80001d68:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d6a:	fec40593          	addi	a1,s0,-20
    80001d6e:	4501                	li	a0,0
    80001d70:	f2fff0ef          	jal	80001c9e <argint>
  kexit(n);
    80001d74:	fec42503          	lw	a0,-20(s0)
    80001d78:	f26ff0ef          	jal	8000149e <kexit>
  return 0;  // not reached
}
    80001d7c:	4501                	li	a0,0
    80001d7e:	60e2                	ld	ra,24(sp)
    80001d80:	6442                	ld	s0,16(sp)
    80001d82:	6105                	addi	sp,sp,32
    80001d84:	8082                	ret

0000000080001d86 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d86:	1141                	addi	sp,sp,-16
    80001d88:	e406                	sd	ra,8(sp)
    80001d8a:	e022                	sd	s0,0(sp)
    80001d8c:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d8e:	806ff0ef          	jal	80000d94 <myproc>
}
    80001d92:	5908                	lw	a0,48(a0)
    80001d94:	60a2                	ld	ra,8(sp)
    80001d96:	6402                	ld	s0,0(sp)
    80001d98:	0141                	addi	sp,sp,16
    80001d9a:	8082                	ret

0000000080001d9c <sys_fork>:

uint64
sys_fork(void)
{
    80001d9c:	1141                	addi	sp,sp,-16
    80001d9e:	e406                	sd	ra,8(sp)
    80001da0:	e022                	sd	s0,0(sp)
    80001da2:	0800                	addi	s0,sp,16
  return kfork();
    80001da4:	b46ff0ef          	jal	800010ea <kfork>
}
    80001da8:	60a2                	ld	ra,8(sp)
    80001daa:	6402                	ld	s0,0(sp)
    80001dac:	0141                	addi	sp,sp,16
    80001dae:	8082                	ret

0000000080001db0 <sys_wait>:

uint64
sys_wait(void)
{
    80001db0:	1101                	addi	sp,sp,-32
    80001db2:	ec06                	sd	ra,24(sp)
    80001db4:	e822                	sd	s0,16(sp)
    80001db6:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001db8:	fe840593          	addi	a1,s0,-24
    80001dbc:	4501                	li	a0,0
    80001dbe:	efdff0ef          	jal	80001cba <argaddr>
  return kwait(p);
    80001dc2:	fe843503          	ld	a0,-24(s0)
    80001dc6:	833ff0ef          	jal	800015f8 <kwait>
}
    80001dca:	60e2                	ld	ra,24(sp)
    80001dcc:	6442                	ld	s0,16(sp)
    80001dce:	6105                	addi	sp,sp,32
    80001dd0:	8082                	ret

0000000080001dd2 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001dd2:	7179                	addi	sp,sp,-48
    80001dd4:	f406                	sd	ra,40(sp)
    80001dd6:	f022                	sd	s0,32(sp)
    80001dd8:	ec26                	sd	s1,24(sp)
    80001dda:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001ddc:	fd840593          	addi	a1,s0,-40
    80001de0:	4501                	li	a0,0
    80001de2:	ebdff0ef          	jal	80001c9e <argint>
  argint(1, &t);
    80001de6:	fdc40593          	addi	a1,s0,-36
    80001dea:	4505                	li	a0,1
    80001dec:	eb3ff0ef          	jal	80001c9e <argint>
  addr = myproc()->sz;
    80001df0:	fa5fe0ef          	jal	80000d94 <myproc>
    80001df4:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001df6:	fdc42703          	lw	a4,-36(s0)
    80001dfa:	4785                	li	a5,1
    80001dfc:	02f70163          	beq	a4,a5,80001e1e <sys_sbrk+0x4c>
    80001e00:	fd842783          	lw	a5,-40(s0)
    80001e04:	0007cd63          	bltz	a5,80001e1e <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001e08:	97a6                	add	a5,a5,s1
    80001e0a:	0297e863          	bltu	a5,s1,80001e3a <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001e0e:	f87fe0ef          	jal	80000d94 <myproc>
    80001e12:	fd842703          	lw	a4,-40(s0)
    80001e16:	653c                	ld	a5,72(a0)
    80001e18:	97ba                	add	a5,a5,a4
    80001e1a:	e53c                	sd	a5,72(a0)
    80001e1c:	a039                	j	80001e2a <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001e1e:	fd842503          	lw	a0,-40(s0)
    80001e22:	a78ff0ef          	jal	8000109a <growproc>
    80001e26:	00054863          	bltz	a0,80001e36 <sys_sbrk+0x64>
  }
  return addr;
}
    80001e2a:	8526                	mv	a0,s1
    80001e2c:	70a2                	ld	ra,40(sp)
    80001e2e:	7402                	ld	s0,32(sp)
    80001e30:	64e2                	ld	s1,24(sp)
    80001e32:	6145                	addi	sp,sp,48
    80001e34:	8082                	ret
      return -1;
    80001e36:	54fd                	li	s1,-1
    80001e38:	bfcd                	j	80001e2a <sys_sbrk+0x58>
      return -1;
    80001e3a:	54fd                	li	s1,-1
    80001e3c:	b7fd                	j	80001e2a <sys_sbrk+0x58>

0000000080001e3e <sys_pause>:

uint64
sys_pause(void)
{
    80001e3e:	7139                	addi	sp,sp,-64
    80001e40:	fc06                	sd	ra,56(sp)
    80001e42:	f822                	sd	s0,48(sp)
    80001e44:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e46:	fcc40593          	addi	a1,s0,-52
    80001e4a:	4501                	li	a0,0
    80001e4c:	e53ff0ef          	jal	80001c9e <argint>
  if(n < 0)
    80001e50:	fcc42783          	lw	a5,-52(s0)
    80001e54:	0607c863          	bltz	a5,80001ec4 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001e58:	0000c517          	auipc	a0,0xc
    80001e5c:	85850513          	addi	a0,a0,-1960 # 8000d6b0 <tickslock>
    80001e60:	299030ef          	jal	800058f8 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001e64:	fcc42783          	lw	a5,-52(s0)
    80001e68:	c3b9                	beqz	a5,80001eae <sys_pause+0x70>
    80001e6a:	f426                	sd	s1,40(sp)
    80001e6c:	f04a                	sd	s2,32(sp)
    80001e6e:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001e70:	00006997          	auipc	s3,0x6
    80001e74:	9d89a983          	lw	s3,-1576(s3) # 80007848 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e78:	0000c917          	auipc	s2,0xc
    80001e7c:	83890913          	addi	s2,s2,-1992 # 8000d6b0 <tickslock>
    80001e80:	00006497          	auipc	s1,0x6
    80001e84:	9c848493          	addi	s1,s1,-1592 # 80007848 <ticks>
    if(killed(myproc())){
    80001e88:	f0dfe0ef          	jal	80000d94 <myproc>
    80001e8c:	f42ff0ef          	jal	800015ce <killed>
    80001e90:	ed0d                	bnez	a0,80001eca <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001e92:	85ca                	mv	a1,s2
    80001e94:	8526                	mv	a0,s1
    80001e96:	cfcff0ef          	jal	80001392 <sleep>
  while(ticks - ticks0 < n){
    80001e9a:	409c                	lw	a5,0(s1)
    80001e9c:	413787bb          	subw	a5,a5,s3
    80001ea0:	fcc42703          	lw	a4,-52(s0)
    80001ea4:	fee7e2e3          	bltu	a5,a4,80001e88 <sys_pause+0x4a>
    80001ea8:	74a2                	ld	s1,40(sp)
    80001eaa:	7902                	ld	s2,32(sp)
    80001eac:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001eae:	0000c517          	auipc	a0,0xc
    80001eb2:	80250513          	addi	a0,a0,-2046 # 8000d6b0 <tickslock>
    80001eb6:	2d7030ef          	jal	8000598c <release>
  return 0;
    80001eba:	4501                	li	a0,0
}
    80001ebc:	70e2                	ld	ra,56(sp)
    80001ebe:	7442                	ld	s0,48(sp)
    80001ec0:	6121                	addi	sp,sp,64
    80001ec2:	8082                	ret
    n = 0;
    80001ec4:	fc042623          	sw	zero,-52(s0)
    80001ec8:	bf41                	j	80001e58 <sys_pause+0x1a>
      release(&tickslock);
    80001eca:	0000b517          	auipc	a0,0xb
    80001ece:	7e650513          	addi	a0,a0,2022 # 8000d6b0 <tickslock>
    80001ed2:	2bb030ef          	jal	8000598c <release>
      return -1;
    80001ed6:	557d                	li	a0,-1
    80001ed8:	74a2                	ld	s1,40(sp)
    80001eda:	7902                	ld	s2,32(sp)
    80001edc:	69e2                	ld	s3,24(sp)
    80001ede:	bff9                	j	80001ebc <sys_pause+0x7e>

0000000080001ee0 <sys_kill>:

uint64
sys_kill(void)
{
    80001ee0:	1101                	addi	sp,sp,-32
    80001ee2:	ec06                	sd	ra,24(sp)
    80001ee4:	e822                	sd	s0,16(sp)
    80001ee6:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001ee8:	fec40593          	addi	a1,s0,-20
    80001eec:	4501                	li	a0,0
    80001eee:	db1ff0ef          	jal	80001c9e <argint>
  return kkill(pid);
    80001ef2:	fec42503          	lw	a0,-20(s0)
    80001ef6:	e4eff0ef          	jal	80001544 <kkill>
}
    80001efa:	60e2                	ld	ra,24(sp)
    80001efc:	6442                	ld	s0,16(sp)
    80001efe:	6105                	addi	sp,sp,32
    80001f00:	8082                	ret

0000000080001f02 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f02:	1101                	addi	sp,sp,-32
    80001f04:	ec06                	sd	ra,24(sp)
    80001f06:	e822                	sd	s0,16(sp)
    80001f08:	e426                	sd	s1,8(sp)
    80001f0a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f0c:	0000b517          	auipc	a0,0xb
    80001f10:	7a450513          	addi	a0,a0,1956 # 8000d6b0 <tickslock>
    80001f14:	1e5030ef          	jal	800058f8 <acquire>
  xticks = ticks;
    80001f18:	00006797          	auipc	a5,0x6
    80001f1c:	9307a783          	lw	a5,-1744(a5) # 80007848 <ticks>
    80001f20:	84be                	mv	s1,a5
  release(&tickslock);
    80001f22:	0000b517          	auipc	a0,0xb
    80001f26:	78e50513          	addi	a0,a0,1934 # 8000d6b0 <tickslock>
    80001f2a:	263030ef          	jal	8000598c <release>
  return xticks;
}
    80001f2e:	02049513          	slli	a0,s1,0x20
    80001f32:	9101                	srli	a0,a0,0x20
    80001f34:	60e2                	ld	ra,24(sp)
    80001f36:	6442                	ld	s0,16(sp)
    80001f38:	64a2                	ld	s1,8(sp)
    80001f3a:	6105                	addi	sp,sp,32
    80001f3c:	8082                	ret

0000000080001f3e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f3e:	7179                	addi	sp,sp,-48
    80001f40:	f406                	sd	ra,40(sp)
    80001f42:	f022                	sd	s0,32(sp)
    80001f44:	ec26                	sd	s1,24(sp)
    80001f46:	e84a                	sd	s2,16(sp)
    80001f48:	e44e                	sd	s3,8(sp)
    80001f4a:	e052                	sd	s4,0(sp)
    80001f4c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f4e:	00005597          	auipc	a1,0x5
    80001f52:	3e258593          	addi	a1,a1,994 # 80007330 <etext+0x330>
    80001f56:	0000b517          	auipc	a0,0xb
    80001f5a:	77250513          	addi	a0,a0,1906 # 8000d6c8 <bcache>
    80001f5e:	111030ef          	jal	8000586e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f62:	00013797          	auipc	a5,0x13
    80001f66:	76678793          	addi	a5,a5,1894 # 800156c8 <bcache+0x8000>
    80001f6a:	00014717          	auipc	a4,0x14
    80001f6e:	9c670713          	addi	a4,a4,-1594 # 80015930 <bcache+0x8268>
    80001f72:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f76:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f7a:	0000b497          	auipc	s1,0xb
    80001f7e:	76648493          	addi	s1,s1,1894 # 8000d6e0 <bcache+0x18>
    b->next = bcache.head.next;
    80001f82:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f84:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f86:	00005a17          	auipc	s4,0x5
    80001f8a:	3b2a0a13          	addi	s4,s4,946 # 80007338 <etext+0x338>
    b->next = bcache.head.next;
    80001f8e:	2b893783          	ld	a5,696(s2)
    80001f92:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001f94:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001f98:	85d2                	mv	a1,s4
    80001f9a:	01048513          	addi	a0,s1,16
    80001f9e:	328010ef          	jal	800032c6 <initsleeplock>
    bcache.head.next->prev = b;
    80001fa2:	2b893783          	ld	a5,696(s2)
    80001fa6:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001fa8:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fac:	45848493          	addi	s1,s1,1112
    80001fb0:	fd349fe3          	bne	s1,s3,80001f8e <binit+0x50>
  }
}
    80001fb4:	70a2                	ld	ra,40(sp)
    80001fb6:	7402                	ld	s0,32(sp)
    80001fb8:	64e2                	ld	s1,24(sp)
    80001fba:	6942                	ld	s2,16(sp)
    80001fbc:	69a2                	ld	s3,8(sp)
    80001fbe:	6a02                	ld	s4,0(sp)
    80001fc0:	6145                	addi	sp,sp,48
    80001fc2:	8082                	ret

0000000080001fc4 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001fc4:	7179                	addi	sp,sp,-48
    80001fc6:	f406                	sd	ra,40(sp)
    80001fc8:	f022                	sd	s0,32(sp)
    80001fca:	ec26                	sd	s1,24(sp)
    80001fcc:	e84a                	sd	s2,16(sp)
    80001fce:	e44e                	sd	s3,8(sp)
    80001fd0:	1800                	addi	s0,sp,48
    80001fd2:	892a                	mv	s2,a0
    80001fd4:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001fd6:	0000b517          	auipc	a0,0xb
    80001fda:	6f250513          	addi	a0,a0,1778 # 8000d6c8 <bcache>
    80001fde:	11b030ef          	jal	800058f8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001fe2:	00014497          	auipc	s1,0x14
    80001fe6:	99e4b483          	ld	s1,-1634(s1) # 80015980 <bcache+0x82b8>
    80001fea:	00014797          	auipc	a5,0x14
    80001fee:	94678793          	addi	a5,a5,-1722 # 80015930 <bcache+0x8268>
    80001ff2:	02f48b63          	beq	s1,a5,80002028 <bread+0x64>
    80001ff6:	873e                	mv	a4,a5
    80001ff8:	a021                	j	80002000 <bread+0x3c>
    80001ffa:	68a4                	ld	s1,80(s1)
    80001ffc:	02e48663          	beq	s1,a4,80002028 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002000:	449c                	lw	a5,8(s1)
    80002002:	ff279ce3          	bne	a5,s2,80001ffa <bread+0x36>
    80002006:	44dc                	lw	a5,12(s1)
    80002008:	ff3799e3          	bne	a5,s3,80001ffa <bread+0x36>
      b->refcnt++;
    8000200c:	40bc                	lw	a5,64(s1)
    8000200e:	2785                	addiw	a5,a5,1
    80002010:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002012:	0000b517          	auipc	a0,0xb
    80002016:	6b650513          	addi	a0,a0,1718 # 8000d6c8 <bcache>
    8000201a:	173030ef          	jal	8000598c <release>
      acquiresleep(&b->lock);
    8000201e:	01048513          	addi	a0,s1,16
    80002022:	2da010ef          	jal	800032fc <acquiresleep>
      return b;
    80002026:	a889                	j	80002078 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002028:	00014497          	auipc	s1,0x14
    8000202c:	9504b483          	ld	s1,-1712(s1) # 80015978 <bcache+0x82b0>
    80002030:	00014797          	auipc	a5,0x14
    80002034:	90078793          	addi	a5,a5,-1792 # 80015930 <bcache+0x8268>
    80002038:	00f48863          	beq	s1,a5,80002048 <bread+0x84>
    8000203c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000203e:	40bc                	lw	a5,64(s1)
    80002040:	cb91                	beqz	a5,80002054 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002042:	64a4                	ld	s1,72(s1)
    80002044:	fee49de3          	bne	s1,a4,8000203e <bread+0x7a>
  panic("bget: no buffers");
    80002048:	00005517          	auipc	a0,0x5
    8000204c:	2f850513          	addi	a0,a0,760 # 80007340 <etext+0x340>
    80002050:	5e6030ef          	jal	80005636 <panic>
      b->dev = dev;
    80002054:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002058:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000205c:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002060:	4785                	li	a5,1
    80002062:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002064:	0000b517          	auipc	a0,0xb
    80002068:	66450513          	addi	a0,a0,1636 # 8000d6c8 <bcache>
    8000206c:	121030ef          	jal	8000598c <release>
      acquiresleep(&b->lock);
    80002070:	01048513          	addi	a0,s1,16
    80002074:	288010ef          	jal	800032fc <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002078:	409c                	lw	a5,0(s1)
    8000207a:	cb89                	beqz	a5,8000208c <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000207c:	8526                	mv	a0,s1
    8000207e:	70a2                	ld	ra,40(sp)
    80002080:	7402                	ld	s0,32(sp)
    80002082:	64e2                	ld	s1,24(sp)
    80002084:	6942                	ld	s2,16(sp)
    80002086:	69a2                	ld	s3,8(sp)
    80002088:	6145                	addi	sp,sp,48
    8000208a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000208c:	4581                	li	a1,0
    8000208e:	8526                	mv	a0,s1
    80002090:	2e1020ef          	jal	80004b70 <virtio_disk_rw>
    b->valid = 1;
    80002094:	4785                	li	a5,1
    80002096:	c09c                	sw	a5,0(s1)
  return b;
    80002098:	b7d5                	j	8000207c <bread+0xb8>

000000008000209a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000209a:	1101                	addi	sp,sp,-32
    8000209c:	ec06                	sd	ra,24(sp)
    8000209e:	e822                	sd	s0,16(sp)
    800020a0:	e426                	sd	s1,8(sp)
    800020a2:	1000                	addi	s0,sp,32
    800020a4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020a6:	0541                	addi	a0,a0,16
    800020a8:	2d2010ef          	jal	8000337a <holdingsleep>
    800020ac:	c911                	beqz	a0,800020c0 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020ae:	4585                	li	a1,1
    800020b0:	8526                	mv	a0,s1
    800020b2:	2bf020ef          	jal	80004b70 <virtio_disk_rw>
}
    800020b6:	60e2                	ld	ra,24(sp)
    800020b8:	6442                	ld	s0,16(sp)
    800020ba:	64a2                	ld	s1,8(sp)
    800020bc:	6105                	addi	sp,sp,32
    800020be:	8082                	ret
    panic("bwrite");
    800020c0:	00005517          	auipc	a0,0x5
    800020c4:	29850513          	addi	a0,a0,664 # 80007358 <etext+0x358>
    800020c8:	56e030ef          	jal	80005636 <panic>

00000000800020cc <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020cc:	1101                	addi	sp,sp,-32
    800020ce:	ec06                	sd	ra,24(sp)
    800020d0:	e822                	sd	s0,16(sp)
    800020d2:	e426                	sd	s1,8(sp)
    800020d4:	e04a                	sd	s2,0(sp)
    800020d6:	1000                	addi	s0,sp,32
    800020d8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020da:	01050913          	addi	s2,a0,16
    800020de:	854a                	mv	a0,s2
    800020e0:	29a010ef          	jal	8000337a <holdingsleep>
    800020e4:	c125                	beqz	a0,80002144 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800020e6:	854a                	mv	a0,s2
    800020e8:	25a010ef          	jal	80003342 <releasesleep>

  acquire(&bcache.lock);
    800020ec:	0000b517          	auipc	a0,0xb
    800020f0:	5dc50513          	addi	a0,a0,1500 # 8000d6c8 <bcache>
    800020f4:	005030ef          	jal	800058f8 <acquire>
  b->refcnt--;
    800020f8:	40bc                	lw	a5,64(s1)
    800020fa:	37fd                	addiw	a5,a5,-1
    800020fc:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800020fe:	e79d                	bnez	a5,8000212c <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002100:	68b8                	ld	a4,80(s1)
    80002102:	64bc                	ld	a5,72(s1)
    80002104:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002106:	68b8                	ld	a4,80(s1)
    80002108:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000210a:	00013797          	auipc	a5,0x13
    8000210e:	5be78793          	addi	a5,a5,1470 # 800156c8 <bcache+0x8000>
    80002112:	2b87b703          	ld	a4,696(a5)
    80002116:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002118:	00014717          	auipc	a4,0x14
    8000211c:	81870713          	addi	a4,a4,-2024 # 80015930 <bcache+0x8268>
    80002120:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002122:	2b87b703          	ld	a4,696(a5)
    80002126:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002128:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000212c:	0000b517          	auipc	a0,0xb
    80002130:	59c50513          	addi	a0,a0,1436 # 8000d6c8 <bcache>
    80002134:	059030ef          	jal	8000598c <release>
}
    80002138:	60e2                	ld	ra,24(sp)
    8000213a:	6442                	ld	s0,16(sp)
    8000213c:	64a2                	ld	s1,8(sp)
    8000213e:	6902                	ld	s2,0(sp)
    80002140:	6105                	addi	sp,sp,32
    80002142:	8082                	ret
    panic("brelse");
    80002144:	00005517          	auipc	a0,0x5
    80002148:	21c50513          	addi	a0,a0,540 # 80007360 <etext+0x360>
    8000214c:	4ea030ef          	jal	80005636 <panic>

0000000080002150 <bpin>:

void
bpin(struct buf *b) {
    80002150:	1101                	addi	sp,sp,-32
    80002152:	ec06                	sd	ra,24(sp)
    80002154:	e822                	sd	s0,16(sp)
    80002156:	e426                	sd	s1,8(sp)
    80002158:	1000                	addi	s0,sp,32
    8000215a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000215c:	0000b517          	auipc	a0,0xb
    80002160:	56c50513          	addi	a0,a0,1388 # 8000d6c8 <bcache>
    80002164:	794030ef          	jal	800058f8 <acquire>
  b->refcnt++;
    80002168:	40bc                	lw	a5,64(s1)
    8000216a:	2785                	addiw	a5,a5,1
    8000216c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000216e:	0000b517          	auipc	a0,0xb
    80002172:	55a50513          	addi	a0,a0,1370 # 8000d6c8 <bcache>
    80002176:	017030ef          	jal	8000598c <release>
}
    8000217a:	60e2                	ld	ra,24(sp)
    8000217c:	6442                	ld	s0,16(sp)
    8000217e:	64a2                	ld	s1,8(sp)
    80002180:	6105                	addi	sp,sp,32
    80002182:	8082                	ret

0000000080002184 <bunpin>:

void
bunpin(struct buf *b) {
    80002184:	1101                	addi	sp,sp,-32
    80002186:	ec06                	sd	ra,24(sp)
    80002188:	e822                	sd	s0,16(sp)
    8000218a:	e426                	sd	s1,8(sp)
    8000218c:	1000                	addi	s0,sp,32
    8000218e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002190:	0000b517          	auipc	a0,0xb
    80002194:	53850513          	addi	a0,a0,1336 # 8000d6c8 <bcache>
    80002198:	760030ef          	jal	800058f8 <acquire>
  b->refcnt--;
    8000219c:	40bc                	lw	a5,64(s1)
    8000219e:	37fd                	addiw	a5,a5,-1
    800021a0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021a2:	0000b517          	auipc	a0,0xb
    800021a6:	52650513          	addi	a0,a0,1318 # 8000d6c8 <bcache>
    800021aa:	7e2030ef          	jal	8000598c <release>
}
    800021ae:	60e2                	ld	ra,24(sp)
    800021b0:	6442                	ld	s0,16(sp)
    800021b2:	64a2                	ld	s1,8(sp)
    800021b4:	6105                	addi	sp,sp,32
    800021b6:	8082                	ret

00000000800021b8 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800021b8:	1101                	addi	sp,sp,-32
    800021ba:	ec06                	sd	ra,24(sp)
    800021bc:	e822                	sd	s0,16(sp)
    800021be:	e426                	sd	s1,8(sp)
    800021c0:	e04a                	sd	s2,0(sp)
    800021c2:	1000                	addi	s0,sp,32
    800021c4:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021c6:	00d5d79b          	srliw	a5,a1,0xd
    800021ca:	00014597          	auipc	a1,0x14
    800021ce:	bda5a583          	lw	a1,-1062(a1) # 80015da4 <sb+0x1c>
    800021d2:	9dbd                	addw	a1,a1,a5
    800021d4:	df1ff0ef          	jal	80001fc4 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800021d8:	0074f713          	andi	a4,s1,7
    800021dc:	4785                	li	a5,1
    800021de:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800021e2:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800021e4:	90d9                	srli	s1,s1,0x36
    800021e6:	00950733          	add	a4,a0,s1
    800021ea:	05874703          	lbu	a4,88(a4)
    800021ee:	00e7f6b3          	and	a3,a5,a4
    800021f2:	c29d                	beqz	a3,80002218 <bfree+0x60>
    800021f4:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800021f6:	94aa                	add	s1,s1,a0
    800021f8:	fff7c793          	not	a5,a5
    800021fc:	8f7d                	and	a4,a4,a5
    800021fe:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002202:	000010ef          	jal	80003202 <log_write>
  brelse(bp);
    80002206:	854a                	mv	a0,s2
    80002208:	ec5ff0ef          	jal	800020cc <brelse>
}
    8000220c:	60e2                	ld	ra,24(sp)
    8000220e:	6442                	ld	s0,16(sp)
    80002210:	64a2                	ld	s1,8(sp)
    80002212:	6902                	ld	s2,0(sp)
    80002214:	6105                	addi	sp,sp,32
    80002216:	8082                	ret
    panic("freeing free block");
    80002218:	00005517          	auipc	a0,0x5
    8000221c:	15050513          	addi	a0,a0,336 # 80007368 <etext+0x368>
    80002220:	416030ef          	jal	80005636 <panic>

0000000080002224 <balloc>:
{
    80002224:	715d                	addi	sp,sp,-80
    80002226:	e486                	sd	ra,72(sp)
    80002228:	e0a2                	sd	s0,64(sp)
    8000222a:	fc26                	sd	s1,56(sp)
    8000222c:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000222e:	00014797          	auipc	a5,0x14
    80002232:	b5e7a783          	lw	a5,-1186(a5) # 80015d8c <sb+0x4>
    80002236:	0e078263          	beqz	a5,8000231a <balloc+0xf6>
    8000223a:	f84a                	sd	s2,48(sp)
    8000223c:	f44e                	sd	s3,40(sp)
    8000223e:	f052                	sd	s4,32(sp)
    80002240:	ec56                	sd	s5,24(sp)
    80002242:	e85a                	sd	s6,16(sp)
    80002244:	e45e                	sd	s7,8(sp)
    80002246:	e062                	sd	s8,0(sp)
    80002248:	8baa                	mv	s7,a0
    8000224a:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000224c:	00014b17          	auipc	s6,0x14
    80002250:	b3cb0b13          	addi	s6,s6,-1220 # 80015d88 <sb>
      m = 1 << (bi % 8);
    80002254:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002256:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002258:	6c09                	lui	s8,0x2
    8000225a:	a09d                	j	800022c0 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000225c:	97ca                	add	a5,a5,s2
    8000225e:	8e55                	or	a2,a2,a3
    80002260:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002264:	854a                	mv	a0,s2
    80002266:	79d000ef          	jal	80003202 <log_write>
        brelse(bp);
    8000226a:	854a                	mv	a0,s2
    8000226c:	e61ff0ef          	jal	800020cc <brelse>
  bp = bread(dev, bno);
    80002270:	85a6                	mv	a1,s1
    80002272:	855e                	mv	a0,s7
    80002274:	d51ff0ef          	jal	80001fc4 <bread>
    80002278:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000227a:	40000613          	li	a2,1024
    8000227e:	4581                	li	a1,0
    80002280:	05850513          	addi	a0,a0,88
    80002284:	edbfd0ef          	jal	8000015e <memset>
  log_write(bp);
    80002288:	854a                	mv	a0,s2
    8000228a:	779000ef          	jal	80003202 <log_write>
  brelse(bp);
    8000228e:	854a                	mv	a0,s2
    80002290:	e3dff0ef          	jal	800020cc <brelse>
}
    80002294:	7942                	ld	s2,48(sp)
    80002296:	79a2                	ld	s3,40(sp)
    80002298:	7a02                	ld	s4,32(sp)
    8000229a:	6ae2                	ld	s5,24(sp)
    8000229c:	6b42                	ld	s6,16(sp)
    8000229e:	6ba2                	ld	s7,8(sp)
    800022a0:	6c02                	ld	s8,0(sp)
}
    800022a2:	8526                	mv	a0,s1
    800022a4:	60a6                	ld	ra,72(sp)
    800022a6:	6406                	ld	s0,64(sp)
    800022a8:	74e2                	ld	s1,56(sp)
    800022aa:	6161                	addi	sp,sp,80
    800022ac:	8082                	ret
    brelse(bp);
    800022ae:	854a                	mv	a0,s2
    800022b0:	e1dff0ef          	jal	800020cc <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800022b4:	015c0abb          	addw	s5,s8,s5
    800022b8:	004b2783          	lw	a5,4(s6)
    800022bc:	04faf863          	bgeu	s5,a5,8000230c <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800022c0:	40dad59b          	sraiw	a1,s5,0xd
    800022c4:	01cb2783          	lw	a5,28(s6)
    800022c8:	9dbd                	addw	a1,a1,a5
    800022ca:	855e                	mv	a0,s7
    800022cc:	cf9ff0ef          	jal	80001fc4 <bread>
    800022d0:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022d2:	004b2503          	lw	a0,4(s6)
    800022d6:	84d6                	mv	s1,s5
    800022d8:	4701                	li	a4,0
    800022da:	fca4fae3          	bgeu	s1,a0,800022ae <balloc+0x8a>
      m = 1 << (bi % 8);
    800022de:	00777693          	andi	a3,a4,7
    800022e2:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800022e6:	41f7579b          	sraiw	a5,a4,0x1f
    800022ea:	01d7d79b          	srliw	a5,a5,0x1d
    800022ee:	9fb9                	addw	a5,a5,a4
    800022f0:	4037d79b          	sraiw	a5,a5,0x3
    800022f4:	00f90633          	add	a2,s2,a5
    800022f8:	05864603          	lbu	a2,88(a2)
    800022fc:	00c6f5b3          	and	a1,a3,a2
    80002300:	ddb1                	beqz	a1,8000225c <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002302:	2705                	addiw	a4,a4,1
    80002304:	2485                	addiw	s1,s1,1
    80002306:	fd471ae3          	bne	a4,s4,800022da <balloc+0xb6>
    8000230a:	b755                	j	800022ae <balloc+0x8a>
    8000230c:	7942                	ld	s2,48(sp)
    8000230e:	79a2                	ld	s3,40(sp)
    80002310:	7a02                	ld	s4,32(sp)
    80002312:	6ae2                	ld	s5,24(sp)
    80002314:	6b42                	ld	s6,16(sp)
    80002316:	6ba2                	ld	s7,8(sp)
    80002318:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000231a:	00005517          	auipc	a0,0x5
    8000231e:	06650513          	addi	a0,a0,102 # 80007380 <etext+0x380>
    80002322:	7eb020ef          	jal	8000530c <printf>
  return 0;
    80002326:	4481                	li	s1,0
    80002328:	bfad                	j	800022a2 <balloc+0x7e>

000000008000232a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000232a:	7179                	addi	sp,sp,-48
    8000232c:	f406                	sd	ra,40(sp)
    8000232e:	f022                	sd	s0,32(sp)
    80002330:	ec26                	sd	s1,24(sp)
    80002332:	e84a                	sd	s2,16(sp)
    80002334:	e44e                	sd	s3,8(sp)
    80002336:	1800                	addi	s0,sp,48
    80002338:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000233a:	47ad                	li	a5,11
    8000233c:	02b7e363          	bltu	a5,a1,80002362 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002340:	02059793          	slli	a5,a1,0x20
    80002344:	01e7d593          	srli	a1,a5,0x1e
    80002348:	00b509b3          	add	s3,a0,a1
    8000234c:	0509a483          	lw	s1,80(s3)
    80002350:	e0b5                	bnez	s1,800023b4 <bmap+0x8a>
      addr = balloc(ip->dev);
    80002352:	4108                	lw	a0,0(a0)
    80002354:	ed1ff0ef          	jal	80002224 <balloc>
    80002358:	84aa                	mv	s1,a0
      if(addr == 0)
    8000235a:	cd29                	beqz	a0,800023b4 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    8000235c:	04a9a823          	sw	a0,80(s3)
    80002360:	a891                	j	800023b4 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002362:	ff45879b          	addiw	a5,a1,-12
    80002366:	873e                	mv	a4,a5
    80002368:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    8000236a:	0ff00793          	li	a5,255
    8000236e:	06e7e763          	bltu	a5,a4,800023dc <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002372:	08052483          	lw	s1,128(a0)
    80002376:	e891                	bnez	s1,8000238a <bmap+0x60>
      addr = balloc(ip->dev);
    80002378:	4108                	lw	a0,0(a0)
    8000237a:	eabff0ef          	jal	80002224 <balloc>
    8000237e:	84aa                	mv	s1,a0
      if(addr == 0)
    80002380:	c915                	beqz	a0,800023b4 <bmap+0x8a>
    80002382:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002384:	08a92023          	sw	a0,128(s2)
    80002388:	a011                	j	8000238c <bmap+0x62>
    8000238a:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    8000238c:	85a6                	mv	a1,s1
    8000238e:	00092503          	lw	a0,0(s2)
    80002392:	c33ff0ef          	jal	80001fc4 <bread>
    80002396:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002398:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    8000239c:	02099713          	slli	a4,s3,0x20
    800023a0:	01e75593          	srli	a1,a4,0x1e
    800023a4:	97ae                	add	a5,a5,a1
    800023a6:	89be                	mv	s3,a5
    800023a8:	4384                	lw	s1,0(a5)
    800023aa:	cc89                	beqz	s1,800023c4 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800023ac:	8552                	mv	a0,s4
    800023ae:	d1fff0ef          	jal	800020cc <brelse>
    return addr;
    800023b2:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800023b4:	8526                	mv	a0,s1
    800023b6:	70a2                	ld	ra,40(sp)
    800023b8:	7402                	ld	s0,32(sp)
    800023ba:	64e2                	ld	s1,24(sp)
    800023bc:	6942                	ld	s2,16(sp)
    800023be:	69a2                	ld	s3,8(sp)
    800023c0:	6145                	addi	sp,sp,48
    800023c2:	8082                	ret
      addr = balloc(ip->dev);
    800023c4:	00092503          	lw	a0,0(s2)
    800023c8:	e5dff0ef          	jal	80002224 <balloc>
    800023cc:	84aa                	mv	s1,a0
      if(addr){
    800023ce:	dd79                	beqz	a0,800023ac <bmap+0x82>
        a[bn] = addr;
    800023d0:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800023d4:	8552                	mv	a0,s4
    800023d6:	62d000ef          	jal	80003202 <log_write>
    800023da:	bfc9                	j	800023ac <bmap+0x82>
    800023dc:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800023de:	00005517          	auipc	a0,0x5
    800023e2:	fba50513          	addi	a0,a0,-70 # 80007398 <etext+0x398>
    800023e6:	250030ef          	jal	80005636 <panic>

00000000800023ea <iget>:
{
    800023ea:	7179                	addi	sp,sp,-48
    800023ec:	f406                	sd	ra,40(sp)
    800023ee:	f022                	sd	s0,32(sp)
    800023f0:	ec26                	sd	s1,24(sp)
    800023f2:	e84a                	sd	s2,16(sp)
    800023f4:	e44e                	sd	s3,8(sp)
    800023f6:	e052                	sd	s4,0(sp)
    800023f8:	1800                	addi	s0,sp,48
    800023fa:	892a                	mv	s2,a0
    800023fc:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800023fe:	00014517          	auipc	a0,0x14
    80002402:	9aa50513          	addi	a0,a0,-1622 # 80015da8 <itable>
    80002406:	4f2030ef          	jal	800058f8 <acquire>
  empty = 0;
    8000240a:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000240c:	00014497          	auipc	s1,0x14
    80002410:	9b448493          	addi	s1,s1,-1612 # 80015dc0 <itable+0x18>
    80002414:	00015697          	auipc	a3,0x15
    80002418:	43c68693          	addi	a3,a3,1084 # 80017850 <log>
    8000241c:	a809                	j	8000242e <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000241e:	e781                	bnez	a5,80002426 <iget+0x3c>
    80002420:	00099363          	bnez	s3,80002426 <iget+0x3c>
      empty = ip;
    80002424:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002426:	08848493          	addi	s1,s1,136
    8000242a:	02d48563          	beq	s1,a3,80002454 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000242e:	449c                	lw	a5,8(s1)
    80002430:	fef057e3          	blez	a5,8000241e <iget+0x34>
    80002434:	4098                	lw	a4,0(s1)
    80002436:	ff2718e3          	bne	a4,s2,80002426 <iget+0x3c>
    8000243a:	40d8                	lw	a4,4(s1)
    8000243c:	ff4715e3          	bne	a4,s4,80002426 <iget+0x3c>
      ip->ref++;
    80002440:	2785                	addiw	a5,a5,1
    80002442:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002444:	00014517          	auipc	a0,0x14
    80002448:	96450513          	addi	a0,a0,-1692 # 80015da8 <itable>
    8000244c:	540030ef          	jal	8000598c <release>
      return ip;
    80002450:	89a6                	mv	s3,s1
    80002452:	a015                	j	80002476 <iget+0x8c>
  if(empty == 0)
    80002454:	02098a63          	beqz	s3,80002488 <iget+0x9e>
  ip->dev = dev;
    80002458:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    8000245c:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80002460:	4785                	li	a5,1
    80002462:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002466:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000246a:	00014517          	auipc	a0,0x14
    8000246e:	93e50513          	addi	a0,a0,-1730 # 80015da8 <itable>
    80002472:	51a030ef          	jal	8000598c <release>
}
    80002476:	854e                	mv	a0,s3
    80002478:	70a2                	ld	ra,40(sp)
    8000247a:	7402                	ld	s0,32(sp)
    8000247c:	64e2                	ld	s1,24(sp)
    8000247e:	6942                	ld	s2,16(sp)
    80002480:	69a2                	ld	s3,8(sp)
    80002482:	6a02                	ld	s4,0(sp)
    80002484:	6145                	addi	sp,sp,48
    80002486:	8082                	ret
    panic("iget: no inodes");
    80002488:	00005517          	auipc	a0,0x5
    8000248c:	f2850513          	addi	a0,a0,-216 # 800073b0 <etext+0x3b0>
    80002490:	1a6030ef          	jal	80005636 <panic>

0000000080002494 <iinit>:
{
    80002494:	7179                	addi	sp,sp,-48
    80002496:	f406                	sd	ra,40(sp)
    80002498:	f022                	sd	s0,32(sp)
    8000249a:	ec26                	sd	s1,24(sp)
    8000249c:	e84a                	sd	s2,16(sp)
    8000249e:	e44e                	sd	s3,8(sp)
    800024a0:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800024a2:	00005597          	auipc	a1,0x5
    800024a6:	f1e58593          	addi	a1,a1,-226 # 800073c0 <etext+0x3c0>
    800024aa:	00014517          	auipc	a0,0x14
    800024ae:	8fe50513          	addi	a0,a0,-1794 # 80015da8 <itable>
    800024b2:	3bc030ef          	jal	8000586e <initlock>
  for(i = 0; i < NINODE; i++) {
    800024b6:	00014497          	auipc	s1,0x14
    800024ba:	91a48493          	addi	s1,s1,-1766 # 80015dd0 <itable+0x28>
    800024be:	00015997          	auipc	s3,0x15
    800024c2:	3a298993          	addi	s3,s3,930 # 80017860 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800024c6:	00005917          	auipc	s2,0x5
    800024ca:	f0290913          	addi	s2,s2,-254 # 800073c8 <etext+0x3c8>
    800024ce:	85ca                	mv	a1,s2
    800024d0:	8526                	mv	a0,s1
    800024d2:	5f5000ef          	jal	800032c6 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800024d6:	08848493          	addi	s1,s1,136
    800024da:	ff349ae3          	bne	s1,s3,800024ce <iinit+0x3a>
}
    800024de:	70a2                	ld	ra,40(sp)
    800024e0:	7402                	ld	s0,32(sp)
    800024e2:	64e2                	ld	s1,24(sp)
    800024e4:	6942                	ld	s2,16(sp)
    800024e6:	69a2                	ld	s3,8(sp)
    800024e8:	6145                	addi	sp,sp,48
    800024ea:	8082                	ret

00000000800024ec <ialloc>:
{
    800024ec:	7139                	addi	sp,sp,-64
    800024ee:	fc06                	sd	ra,56(sp)
    800024f0:	f822                	sd	s0,48(sp)
    800024f2:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800024f4:	00014717          	auipc	a4,0x14
    800024f8:	8a072703          	lw	a4,-1888(a4) # 80015d94 <sb+0xc>
    800024fc:	4785                	li	a5,1
    800024fe:	06e7f063          	bgeu	a5,a4,8000255e <ialloc+0x72>
    80002502:	f426                	sd	s1,40(sp)
    80002504:	f04a                	sd	s2,32(sp)
    80002506:	ec4e                	sd	s3,24(sp)
    80002508:	e852                	sd	s4,16(sp)
    8000250a:	e456                	sd	s5,8(sp)
    8000250c:	e05a                	sd	s6,0(sp)
    8000250e:	8aaa                	mv	s5,a0
    80002510:	8b2e                	mv	s6,a1
    80002512:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002514:	00014a17          	auipc	s4,0x14
    80002518:	874a0a13          	addi	s4,s4,-1932 # 80015d88 <sb>
    8000251c:	00495593          	srli	a1,s2,0x4
    80002520:	018a2783          	lw	a5,24(s4)
    80002524:	9dbd                	addw	a1,a1,a5
    80002526:	8556                	mv	a0,s5
    80002528:	a9dff0ef          	jal	80001fc4 <bread>
    8000252c:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000252e:	05850993          	addi	s3,a0,88
    80002532:	00f97793          	andi	a5,s2,15
    80002536:	079a                	slli	a5,a5,0x6
    80002538:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000253a:	00099783          	lh	a5,0(s3)
    8000253e:	cb9d                	beqz	a5,80002574 <ialloc+0x88>
    brelse(bp);
    80002540:	b8dff0ef          	jal	800020cc <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002544:	0905                	addi	s2,s2,1
    80002546:	00ca2703          	lw	a4,12(s4)
    8000254a:	0009079b          	sext.w	a5,s2
    8000254e:	fce7e7e3          	bltu	a5,a4,8000251c <ialloc+0x30>
    80002552:	74a2                	ld	s1,40(sp)
    80002554:	7902                	ld	s2,32(sp)
    80002556:	69e2                	ld	s3,24(sp)
    80002558:	6a42                	ld	s4,16(sp)
    8000255a:	6aa2                	ld	s5,8(sp)
    8000255c:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000255e:	00005517          	auipc	a0,0x5
    80002562:	e7250513          	addi	a0,a0,-398 # 800073d0 <etext+0x3d0>
    80002566:	5a7020ef          	jal	8000530c <printf>
  return 0;
    8000256a:	4501                	li	a0,0
}
    8000256c:	70e2                	ld	ra,56(sp)
    8000256e:	7442                	ld	s0,48(sp)
    80002570:	6121                	addi	sp,sp,64
    80002572:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002574:	04000613          	li	a2,64
    80002578:	4581                	li	a1,0
    8000257a:	854e                	mv	a0,s3
    8000257c:	be3fd0ef          	jal	8000015e <memset>
      dip->type = type;
    80002580:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002584:	8526                	mv	a0,s1
    80002586:	47d000ef          	jal	80003202 <log_write>
      brelse(bp);
    8000258a:	8526                	mv	a0,s1
    8000258c:	b41ff0ef          	jal	800020cc <brelse>
      return iget(dev, inum);
    80002590:	0009059b          	sext.w	a1,s2
    80002594:	8556                	mv	a0,s5
    80002596:	e55ff0ef          	jal	800023ea <iget>
    8000259a:	74a2                	ld	s1,40(sp)
    8000259c:	7902                	ld	s2,32(sp)
    8000259e:	69e2                	ld	s3,24(sp)
    800025a0:	6a42                	ld	s4,16(sp)
    800025a2:	6aa2                	ld	s5,8(sp)
    800025a4:	6b02                	ld	s6,0(sp)
    800025a6:	b7d9                	j	8000256c <ialloc+0x80>

00000000800025a8 <iupdate>:
{
    800025a8:	1101                	addi	sp,sp,-32
    800025aa:	ec06                	sd	ra,24(sp)
    800025ac:	e822                	sd	s0,16(sp)
    800025ae:	e426                	sd	s1,8(sp)
    800025b0:	e04a                	sd	s2,0(sp)
    800025b2:	1000                	addi	s0,sp,32
    800025b4:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800025b6:	415c                	lw	a5,4(a0)
    800025b8:	0047d79b          	srliw	a5,a5,0x4
    800025bc:	00013597          	auipc	a1,0x13
    800025c0:	7e45a583          	lw	a1,2020(a1) # 80015da0 <sb+0x18>
    800025c4:	9dbd                	addw	a1,a1,a5
    800025c6:	4108                	lw	a0,0(a0)
    800025c8:	9fdff0ef          	jal	80001fc4 <bread>
    800025cc:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800025ce:	05850793          	addi	a5,a0,88
    800025d2:	40d8                	lw	a4,4(s1)
    800025d4:	8b3d                	andi	a4,a4,15
    800025d6:	071a                	slli	a4,a4,0x6
    800025d8:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800025da:	04449703          	lh	a4,68(s1)
    800025de:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800025e2:	04649703          	lh	a4,70(s1)
    800025e6:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800025ea:	04849703          	lh	a4,72(s1)
    800025ee:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800025f2:	04a49703          	lh	a4,74(s1)
    800025f6:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800025fa:	44f8                	lw	a4,76(s1)
    800025fc:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800025fe:	03400613          	li	a2,52
    80002602:	05048593          	addi	a1,s1,80
    80002606:	00c78513          	addi	a0,a5,12
    8000260a:	bb5fd0ef          	jal	800001be <memmove>
  log_write(bp);
    8000260e:	854a                	mv	a0,s2
    80002610:	3f3000ef          	jal	80003202 <log_write>
  brelse(bp);
    80002614:	854a                	mv	a0,s2
    80002616:	ab7ff0ef          	jal	800020cc <brelse>
}
    8000261a:	60e2                	ld	ra,24(sp)
    8000261c:	6442                	ld	s0,16(sp)
    8000261e:	64a2                	ld	s1,8(sp)
    80002620:	6902                	ld	s2,0(sp)
    80002622:	6105                	addi	sp,sp,32
    80002624:	8082                	ret

0000000080002626 <idup>:
{
    80002626:	1101                	addi	sp,sp,-32
    80002628:	ec06                	sd	ra,24(sp)
    8000262a:	e822                	sd	s0,16(sp)
    8000262c:	e426                	sd	s1,8(sp)
    8000262e:	1000                	addi	s0,sp,32
    80002630:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002632:	00013517          	auipc	a0,0x13
    80002636:	77650513          	addi	a0,a0,1910 # 80015da8 <itable>
    8000263a:	2be030ef          	jal	800058f8 <acquire>
  ip->ref++;
    8000263e:	449c                	lw	a5,8(s1)
    80002640:	2785                	addiw	a5,a5,1
    80002642:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002644:	00013517          	auipc	a0,0x13
    80002648:	76450513          	addi	a0,a0,1892 # 80015da8 <itable>
    8000264c:	340030ef          	jal	8000598c <release>
}
    80002650:	8526                	mv	a0,s1
    80002652:	60e2                	ld	ra,24(sp)
    80002654:	6442                	ld	s0,16(sp)
    80002656:	64a2                	ld	s1,8(sp)
    80002658:	6105                	addi	sp,sp,32
    8000265a:	8082                	ret

000000008000265c <ilock>:
{
    8000265c:	1101                	addi	sp,sp,-32
    8000265e:	ec06                	sd	ra,24(sp)
    80002660:	e822                	sd	s0,16(sp)
    80002662:	e426                	sd	s1,8(sp)
    80002664:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002666:	cd19                	beqz	a0,80002684 <ilock+0x28>
    80002668:	84aa                	mv	s1,a0
    8000266a:	451c                	lw	a5,8(a0)
    8000266c:	00f05c63          	blez	a5,80002684 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002670:	0541                	addi	a0,a0,16
    80002672:	48b000ef          	jal	800032fc <acquiresleep>
  if(ip->valid == 0){
    80002676:	40bc                	lw	a5,64(s1)
    80002678:	cf89                	beqz	a5,80002692 <ilock+0x36>
}
    8000267a:	60e2                	ld	ra,24(sp)
    8000267c:	6442                	ld	s0,16(sp)
    8000267e:	64a2                	ld	s1,8(sp)
    80002680:	6105                	addi	sp,sp,32
    80002682:	8082                	ret
    80002684:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002686:	00005517          	auipc	a0,0x5
    8000268a:	d6250513          	addi	a0,a0,-670 # 800073e8 <etext+0x3e8>
    8000268e:	7a9020ef          	jal	80005636 <panic>
    80002692:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002694:	40dc                	lw	a5,4(s1)
    80002696:	0047d79b          	srliw	a5,a5,0x4
    8000269a:	00013597          	auipc	a1,0x13
    8000269e:	7065a583          	lw	a1,1798(a1) # 80015da0 <sb+0x18>
    800026a2:	9dbd                	addw	a1,a1,a5
    800026a4:	4088                	lw	a0,0(s1)
    800026a6:	91fff0ef          	jal	80001fc4 <bread>
    800026aa:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026ac:	05850593          	addi	a1,a0,88
    800026b0:	40dc                	lw	a5,4(s1)
    800026b2:	8bbd                	andi	a5,a5,15
    800026b4:	079a                	slli	a5,a5,0x6
    800026b6:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800026b8:	00059783          	lh	a5,0(a1)
    800026bc:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800026c0:	00259783          	lh	a5,2(a1)
    800026c4:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800026c8:	00459783          	lh	a5,4(a1)
    800026cc:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800026d0:	00659783          	lh	a5,6(a1)
    800026d4:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800026d8:	459c                	lw	a5,8(a1)
    800026da:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800026dc:	03400613          	li	a2,52
    800026e0:	05b1                	addi	a1,a1,12
    800026e2:	05048513          	addi	a0,s1,80
    800026e6:	ad9fd0ef          	jal	800001be <memmove>
    brelse(bp);
    800026ea:	854a                	mv	a0,s2
    800026ec:	9e1ff0ef          	jal	800020cc <brelse>
    ip->valid = 1;
    800026f0:	4785                	li	a5,1
    800026f2:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800026f4:	04449783          	lh	a5,68(s1)
    800026f8:	c399                	beqz	a5,800026fe <ilock+0xa2>
    800026fa:	6902                	ld	s2,0(sp)
    800026fc:	bfbd                	j	8000267a <ilock+0x1e>
      panic("ilock: no type");
    800026fe:	00005517          	auipc	a0,0x5
    80002702:	cf250513          	addi	a0,a0,-782 # 800073f0 <etext+0x3f0>
    80002706:	731020ef          	jal	80005636 <panic>

000000008000270a <iunlock>:
{
    8000270a:	1101                	addi	sp,sp,-32
    8000270c:	ec06                	sd	ra,24(sp)
    8000270e:	e822                	sd	s0,16(sp)
    80002710:	e426                	sd	s1,8(sp)
    80002712:	e04a                	sd	s2,0(sp)
    80002714:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002716:	c505                	beqz	a0,8000273e <iunlock+0x34>
    80002718:	84aa                	mv	s1,a0
    8000271a:	01050913          	addi	s2,a0,16
    8000271e:	854a                	mv	a0,s2
    80002720:	45b000ef          	jal	8000337a <holdingsleep>
    80002724:	cd09                	beqz	a0,8000273e <iunlock+0x34>
    80002726:	449c                	lw	a5,8(s1)
    80002728:	00f05b63          	blez	a5,8000273e <iunlock+0x34>
  releasesleep(&ip->lock);
    8000272c:	854a                	mv	a0,s2
    8000272e:	415000ef          	jal	80003342 <releasesleep>
}
    80002732:	60e2                	ld	ra,24(sp)
    80002734:	6442                	ld	s0,16(sp)
    80002736:	64a2                	ld	s1,8(sp)
    80002738:	6902                	ld	s2,0(sp)
    8000273a:	6105                	addi	sp,sp,32
    8000273c:	8082                	ret
    panic("iunlock");
    8000273e:	00005517          	auipc	a0,0x5
    80002742:	cc250513          	addi	a0,a0,-830 # 80007400 <etext+0x400>
    80002746:	6f1020ef          	jal	80005636 <panic>

000000008000274a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000274a:	7179                	addi	sp,sp,-48
    8000274c:	f406                	sd	ra,40(sp)
    8000274e:	f022                	sd	s0,32(sp)
    80002750:	ec26                	sd	s1,24(sp)
    80002752:	e84a                	sd	s2,16(sp)
    80002754:	e44e                	sd	s3,8(sp)
    80002756:	1800                	addi	s0,sp,48
    80002758:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000275a:	05050493          	addi	s1,a0,80
    8000275e:	08050913          	addi	s2,a0,128
    80002762:	a021                	j	8000276a <itrunc+0x20>
    80002764:	0491                	addi	s1,s1,4
    80002766:	01248b63          	beq	s1,s2,8000277c <itrunc+0x32>
    if(ip->addrs[i]){
    8000276a:	408c                	lw	a1,0(s1)
    8000276c:	dde5                	beqz	a1,80002764 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000276e:	0009a503          	lw	a0,0(s3)
    80002772:	a47ff0ef          	jal	800021b8 <bfree>
      ip->addrs[i] = 0;
    80002776:	0004a023          	sw	zero,0(s1)
    8000277a:	b7ed                	j	80002764 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000277c:	0809a583          	lw	a1,128(s3)
    80002780:	ed89                	bnez	a1,8000279a <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002782:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002786:	854e                	mv	a0,s3
    80002788:	e21ff0ef          	jal	800025a8 <iupdate>
}
    8000278c:	70a2                	ld	ra,40(sp)
    8000278e:	7402                	ld	s0,32(sp)
    80002790:	64e2                	ld	s1,24(sp)
    80002792:	6942                	ld	s2,16(sp)
    80002794:	69a2                	ld	s3,8(sp)
    80002796:	6145                	addi	sp,sp,48
    80002798:	8082                	ret
    8000279a:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    8000279c:	0009a503          	lw	a0,0(s3)
    800027a0:	825ff0ef          	jal	80001fc4 <bread>
    800027a4:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800027a6:	05850493          	addi	s1,a0,88
    800027aa:	45850913          	addi	s2,a0,1112
    800027ae:	a021                	j	800027b6 <itrunc+0x6c>
    800027b0:	0491                	addi	s1,s1,4
    800027b2:	01248963          	beq	s1,s2,800027c4 <itrunc+0x7a>
      if(a[j])
    800027b6:	408c                	lw	a1,0(s1)
    800027b8:	dde5                	beqz	a1,800027b0 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800027ba:	0009a503          	lw	a0,0(s3)
    800027be:	9fbff0ef          	jal	800021b8 <bfree>
    800027c2:	b7fd                	j	800027b0 <itrunc+0x66>
    brelse(bp);
    800027c4:	8552                	mv	a0,s4
    800027c6:	907ff0ef          	jal	800020cc <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800027ca:	0809a583          	lw	a1,128(s3)
    800027ce:	0009a503          	lw	a0,0(s3)
    800027d2:	9e7ff0ef          	jal	800021b8 <bfree>
    ip->addrs[NDIRECT] = 0;
    800027d6:	0809a023          	sw	zero,128(s3)
    800027da:	6a02                	ld	s4,0(sp)
    800027dc:	b75d                	j	80002782 <itrunc+0x38>

00000000800027de <iput>:
{
    800027de:	1101                	addi	sp,sp,-32
    800027e0:	ec06                	sd	ra,24(sp)
    800027e2:	e822                	sd	s0,16(sp)
    800027e4:	e426                	sd	s1,8(sp)
    800027e6:	1000                	addi	s0,sp,32
    800027e8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800027ea:	00013517          	auipc	a0,0x13
    800027ee:	5be50513          	addi	a0,a0,1470 # 80015da8 <itable>
    800027f2:	106030ef          	jal	800058f8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800027f6:	4498                	lw	a4,8(s1)
    800027f8:	4785                	li	a5,1
    800027fa:	02f70063          	beq	a4,a5,8000281a <iput+0x3c>
  ip->ref--;
    800027fe:	449c                	lw	a5,8(s1)
    80002800:	37fd                	addiw	a5,a5,-1
    80002802:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002804:	00013517          	auipc	a0,0x13
    80002808:	5a450513          	addi	a0,a0,1444 # 80015da8 <itable>
    8000280c:	180030ef          	jal	8000598c <release>
}
    80002810:	60e2                	ld	ra,24(sp)
    80002812:	6442                	ld	s0,16(sp)
    80002814:	64a2                	ld	s1,8(sp)
    80002816:	6105                	addi	sp,sp,32
    80002818:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000281a:	40bc                	lw	a5,64(s1)
    8000281c:	d3ed                	beqz	a5,800027fe <iput+0x20>
    8000281e:	04a49783          	lh	a5,74(s1)
    80002822:	fff1                	bnez	a5,800027fe <iput+0x20>
    80002824:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002826:	01048793          	addi	a5,s1,16
    8000282a:	893e                	mv	s2,a5
    8000282c:	853e                	mv	a0,a5
    8000282e:	2cf000ef          	jal	800032fc <acquiresleep>
    release(&itable.lock);
    80002832:	00013517          	auipc	a0,0x13
    80002836:	57650513          	addi	a0,a0,1398 # 80015da8 <itable>
    8000283a:	152030ef          	jal	8000598c <release>
    itrunc(ip);
    8000283e:	8526                	mv	a0,s1
    80002840:	f0bff0ef          	jal	8000274a <itrunc>
    ip->type = 0;
    80002844:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002848:	8526                	mv	a0,s1
    8000284a:	d5fff0ef          	jal	800025a8 <iupdate>
    ip->valid = 0;
    8000284e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002852:	854a                	mv	a0,s2
    80002854:	2ef000ef          	jal	80003342 <releasesleep>
    acquire(&itable.lock);
    80002858:	00013517          	auipc	a0,0x13
    8000285c:	55050513          	addi	a0,a0,1360 # 80015da8 <itable>
    80002860:	098030ef          	jal	800058f8 <acquire>
    80002864:	6902                	ld	s2,0(sp)
    80002866:	bf61                	j	800027fe <iput+0x20>

0000000080002868 <iunlockput>:
{
    80002868:	1101                	addi	sp,sp,-32
    8000286a:	ec06                	sd	ra,24(sp)
    8000286c:	e822                	sd	s0,16(sp)
    8000286e:	e426                	sd	s1,8(sp)
    80002870:	1000                	addi	s0,sp,32
    80002872:	84aa                	mv	s1,a0
  iunlock(ip);
    80002874:	e97ff0ef          	jal	8000270a <iunlock>
  iput(ip);
    80002878:	8526                	mv	a0,s1
    8000287a:	f65ff0ef          	jal	800027de <iput>
}
    8000287e:	60e2                	ld	ra,24(sp)
    80002880:	6442                	ld	s0,16(sp)
    80002882:	64a2                	ld	s1,8(sp)
    80002884:	6105                	addi	sp,sp,32
    80002886:	8082                	ret

0000000080002888 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002888:	00013717          	auipc	a4,0x13
    8000288c:	50c72703          	lw	a4,1292(a4) # 80015d94 <sb+0xc>
    80002890:	4785                	li	a5,1
    80002892:	0ae7fe63          	bgeu	a5,a4,8000294e <ireclaim+0xc6>
{
    80002896:	7139                	addi	sp,sp,-64
    80002898:	fc06                	sd	ra,56(sp)
    8000289a:	f822                	sd	s0,48(sp)
    8000289c:	f426                	sd	s1,40(sp)
    8000289e:	f04a                	sd	s2,32(sp)
    800028a0:	ec4e                	sd	s3,24(sp)
    800028a2:	e852                	sd	s4,16(sp)
    800028a4:	e456                	sd	s5,8(sp)
    800028a6:	e05a                	sd	s6,0(sp)
    800028a8:	0080                	addi	s0,sp,64
    800028aa:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800028ac:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800028ae:	00013a17          	auipc	s4,0x13
    800028b2:	4daa0a13          	addi	s4,s4,1242 # 80015d88 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800028b6:	00005b17          	auipc	s6,0x5
    800028ba:	b52b0b13          	addi	s6,s6,-1198 # 80007408 <etext+0x408>
    800028be:	a099                	j	80002904 <ireclaim+0x7c>
    800028c0:	85ce                	mv	a1,s3
    800028c2:	855a                	mv	a0,s6
    800028c4:	249020ef          	jal	8000530c <printf>
      ip = iget(dev, inum);
    800028c8:	85ce                	mv	a1,s3
    800028ca:	8556                	mv	a0,s5
    800028cc:	b1fff0ef          	jal	800023ea <iget>
    800028d0:	89aa                	mv	s3,a0
    brelse(bp);
    800028d2:	854a                	mv	a0,s2
    800028d4:	ff8ff0ef          	jal	800020cc <brelse>
    if (ip) {
    800028d8:	00098f63          	beqz	s3,800028f6 <ireclaim+0x6e>
      begin_op();
    800028dc:	78c000ef          	jal	80003068 <begin_op>
      ilock(ip);
    800028e0:	854e                	mv	a0,s3
    800028e2:	d7bff0ef          	jal	8000265c <ilock>
      iunlock(ip);
    800028e6:	854e                	mv	a0,s3
    800028e8:	e23ff0ef          	jal	8000270a <iunlock>
      iput(ip);
    800028ec:	854e                	mv	a0,s3
    800028ee:	ef1ff0ef          	jal	800027de <iput>
      end_op();
    800028f2:	7e6000ef          	jal	800030d8 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800028f6:	0485                	addi	s1,s1,1
    800028f8:	00ca2703          	lw	a4,12(s4)
    800028fc:	0004879b          	sext.w	a5,s1
    80002900:	02e7fd63          	bgeu	a5,a4,8000293a <ireclaim+0xb2>
    80002904:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002908:	0044d593          	srli	a1,s1,0x4
    8000290c:	018a2783          	lw	a5,24(s4)
    80002910:	9dbd                	addw	a1,a1,a5
    80002912:	8556                	mv	a0,s5
    80002914:	eb0ff0ef          	jal	80001fc4 <bread>
    80002918:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    8000291a:	05850793          	addi	a5,a0,88
    8000291e:	00f9f713          	andi	a4,s3,15
    80002922:	071a                	slli	a4,a4,0x6
    80002924:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002926:	00079703          	lh	a4,0(a5)
    8000292a:	c701                	beqz	a4,80002932 <ireclaim+0xaa>
    8000292c:	00679783          	lh	a5,6(a5)
    80002930:	dbc1                	beqz	a5,800028c0 <ireclaim+0x38>
    brelse(bp);
    80002932:	854a                	mv	a0,s2
    80002934:	f98ff0ef          	jal	800020cc <brelse>
    if (ip) {
    80002938:	bf7d                	j	800028f6 <ireclaim+0x6e>
}
    8000293a:	70e2                	ld	ra,56(sp)
    8000293c:	7442                	ld	s0,48(sp)
    8000293e:	74a2                	ld	s1,40(sp)
    80002940:	7902                	ld	s2,32(sp)
    80002942:	69e2                	ld	s3,24(sp)
    80002944:	6a42                	ld	s4,16(sp)
    80002946:	6aa2                	ld	s5,8(sp)
    80002948:	6b02                	ld	s6,0(sp)
    8000294a:	6121                	addi	sp,sp,64
    8000294c:	8082                	ret
    8000294e:	8082                	ret

0000000080002950 <fsinit>:
fsinit(int dev) {
    80002950:	1101                	addi	sp,sp,-32
    80002952:	ec06                	sd	ra,24(sp)
    80002954:	e822                	sd	s0,16(sp)
    80002956:	e426                	sd	s1,8(sp)
    80002958:	e04a                	sd	s2,0(sp)
    8000295a:	1000                	addi	s0,sp,32
    8000295c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    8000295e:	4585                	li	a1,1
    80002960:	e64ff0ef          	jal	80001fc4 <bread>
    80002964:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002966:	02000613          	li	a2,32
    8000296a:	05850593          	addi	a1,a0,88
    8000296e:	00013517          	auipc	a0,0x13
    80002972:	41a50513          	addi	a0,a0,1050 # 80015d88 <sb>
    80002976:	849fd0ef          	jal	800001be <memmove>
  brelse(bp);
    8000297a:	8526                	mv	a0,s1
    8000297c:	f50ff0ef          	jal	800020cc <brelse>
  if(sb.magic != FSMAGIC)
    80002980:	00013717          	auipc	a4,0x13
    80002984:	40872703          	lw	a4,1032(a4) # 80015d88 <sb>
    80002988:	102037b7          	lui	a5,0x10203
    8000298c:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002990:	02f71263          	bne	a4,a5,800029b4 <fsinit+0x64>
  initlog(dev, &sb);
    80002994:	00013597          	auipc	a1,0x13
    80002998:	3f458593          	addi	a1,a1,1012 # 80015d88 <sb>
    8000299c:	854a                	mv	a0,s2
    8000299e:	648000ef          	jal	80002fe6 <initlog>
  ireclaim(dev);
    800029a2:	854a                	mv	a0,s2
    800029a4:	ee5ff0ef          	jal	80002888 <ireclaim>
}
    800029a8:	60e2                	ld	ra,24(sp)
    800029aa:	6442                	ld	s0,16(sp)
    800029ac:	64a2                	ld	s1,8(sp)
    800029ae:	6902                	ld	s2,0(sp)
    800029b0:	6105                	addi	sp,sp,32
    800029b2:	8082                	ret
    panic("invalid file system");
    800029b4:	00005517          	auipc	a0,0x5
    800029b8:	a7450513          	addi	a0,a0,-1420 # 80007428 <etext+0x428>
    800029bc:	47b020ef          	jal	80005636 <panic>

00000000800029c0 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    800029c0:	1141                	addi	sp,sp,-16
    800029c2:	e406                	sd	ra,8(sp)
    800029c4:	e022                	sd	s0,0(sp)
    800029c6:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    800029c8:	411c                	lw	a5,0(a0)
    800029ca:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    800029cc:	415c                	lw	a5,4(a0)
    800029ce:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    800029d0:	04451783          	lh	a5,68(a0)
    800029d4:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    800029d8:	04a51783          	lh	a5,74(a0)
    800029dc:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    800029e0:	04c56783          	lwu	a5,76(a0)
    800029e4:	e99c                	sd	a5,16(a1)
}
    800029e6:	60a2                	ld	ra,8(sp)
    800029e8:	6402                	ld	s0,0(sp)
    800029ea:	0141                	addi	sp,sp,16
    800029ec:	8082                	ret

00000000800029ee <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    800029ee:	457c                	lw	a5,76(a0)
    800029f0:	0ed7e663          	bltu	a5,a3,80002adc <readi+0xee>
{
    800029f4:	7159                	addi	sp,sp,-112
    800029f6:	f486                	sd	ra,104(sp)
    800029f8:	f0a2                	sd	s0,96(sp)
    800029fa:	eca6                	sd	s1,88(sp)
    800029fc:	e0d2                	sd	s4,64(sp)
    800029fe:	fc56                	sd	s5,56(sp)
    80002a00:	f85a                	sd	s6,48(sp)
    80002a02:	f45e                	sd	s7,40(sp)
    80002a04:	1880                	addi	s0,sp,112
    80002a06:	8b2a                	mv	s6,a0
    80002a08:	8bae                	mv	s7,a1
    80002a0a:	8a32                	mv	s4,a2
    80002a0c:	84b6                	mv	s1,a3
    80002a0e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002a10:	9f35                	addw	a4,a4,a3
    return 0;
    80002a12:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002a14:	0ad76b63          	bltu	a4,a3,80002aca <readi+0xdc>
    80002a18:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002a1a:	00e7f463          	bgeu	a5,a4,80002a22 <readi+0x34>
    n = ip->size - off;
    80002a1e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a22:	080a8b63          	beqz	s5,80002ab8 <readi+0xca>
    80002a26:	e8ca                	sd	s2,80(sp)
    80002a28:	f062                	sd	s8,32(sp)
    80002a2a:	ec66                	sd	s9,24(sp)
    80002a2c:	e86a                	sd	s10,16(sp)
    80002a2e:	e46e                	sd	s11,8(sp)
    80002a30:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a32:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002a36:	5c7d                	li	s8,-1
    80002a38:	a80d                	j	80002a6a <readi+0x7c>
    80002a3a:	020d1d93          	slli	s11,s10,0x20
    80002a3e:	020ddd93          	srli	s11,s11,0x20
    80002a42:	05890613          	addi	a2,s2,88
    80002a46:	86ee                	mv	a3,s11
    80002a48:	963e                	add	a2,a2,a5
    80002a4a:	85d2                	mv	a1,s4
    80002a4c:	855e                	mv	a0,s7
    80002a4e:	c9ffe0ef          	jal	800016ec <either_copyout>
    80002a52:	05850363          	beq	a0,s8,80002a98 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002a56:	854a                	mv	a0,s2
    80002a58:	e74ff0ef          	jal	800020cc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002a5c:	013d09bb          	addw	s3,s10,s3
    80002a60:	009d04bb          	addw	s1,s10,s1
    80002a64:	9a6e                	add	s4,s4,s11
    80002a66:	0559f363          	bgeu	s3,s5,80002aac <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002a6a:	00a4d59b          	srliw	a1,s1,0xa
    80002a6e:	855a                	mv	a0,s6
    80002a70:	8bbff0ef          	jal	8000232a <bmap>
    80002a74:	85aa                	mv	a1,a0
    if(addr == 0)
    80002a76:	c139                	beqz	a0,80002abc <readi+0xce>
    bp = bread(ip->dev, addr);
    80002a78:	000b2503          	lw	a0,0(s6)
    80002a7c:	d48ff0ef          	jal	80001fc4 <bread>
    80002a80:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002a82:	3ff4f793          	andi	a5,s1,1023
    80002a86:	40fc873b          	subw	a4,s9,a5
    80002a8a:	413a86bb          	subw	a3,s5,s3
    80002a8e:	8d3a                	mv	s10,a4
    80002a90:	fae6f5e3          	bgeu	a3,a4,80002a3a <readi+0x4c>
    80002a94:	8d36                	mv	s10,a3
    80002a96:	b755                	j	80002a3a <readi+0x4c>
      brelse(bp);
    80002a98:	854a                	mv	a0,s2
    80002a9a:	e32ff0ef          	jal	800020cc <brelse>
      tot = -1;
    80002a9e:	59fd                	li	s3,-1
      break;
    80002aa0:	6946                	ld	s2,80(sp)
    80002aa2:	7c02                	ld	s8,32(sp)
    80002aa4:	6ce2                	ld	s9,24(sp)
    80002aa6:	6d42                	ld	s10,16(sp)
    80002aa8:	6da2                	ld	s11,8(sp)
    80002aaa:	a831                	j	80002ac6 <readi+0xd8>
    80002aac:	6946                	ld	s2,80(sp)
    80002aae:	7c02                	ld	s8,32(sp)
    80002ab0:	6ce2                	ld	s9,24(sp)
    80002ab2:	6d42                	ld	s10,16(sp)
    80002ab4:	6da2                	ld	s11,8(sp)
    80002ab6:	a801                	j	80002ac6 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ab8:	89d6                	mv	s3,s5
    80002aba:	a031                	j	80002ac6 <readi+0xd8>
    80002abc:	6946                	ld	s2,80(sp)
    80002abe:	7c02                	ld	s8,32(sp)
    80002ac0:	6ce2                	ld	s9,24(sp)
    80002ac2:	6d42                	ld	s10,16(sp)
    80002ac4:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002ac6:	854e                	mv	a0,s3
    80002ac8:	69a6                	ld	s3,72(sp)
}
    80002aca:	70a6                	ld	ra,104(sp)
    80002acc:	7406                	ld	s0,96(sp)
    80002ace:	64e6                	ld	s1,88(sp)
    80002ad0:	6a06                	ld	s4,64(sp)
    80002ad2:	7ae2                	ld	s5,56(sp)
    80002ad4:	7b42                	ld	s6,48(sp)
    80002ad6:	7ba2                	ld	s7,40(sp)
    80002ad8:	6165                	addi	sp,sp,112
    80002ada:	8082                	ret
    return 0;
    80002adc:	4501                	li	a0,0
}
    80002ade:	8082                	ret

0000000080002ae0 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ae0:	457c                	lw	a5,76(a0)
    80002ae2:	0ed7eb63          	bltu	a5,a3,80002bd8 <writei+0xf8>
{
    80002ae6:	7159                	addi	sp,sp,-112
    80002ae8:	f486                	sd	ra,104(sp)
    80002aea:	f0a2                	sd	s0,96(sp)
    80002aec:	e8ca                	sd	s2,80(sp)
    80002aee:	e0d2                	sd	s4,64(sp)
    80002af0:	fc56                	sd	s5,56(sp)
    80002af2:	f85a                	sd	s6,48(sp)
    80002af4:	f45e                	sd	s7,40(sp)
    80002af6:	1880                	addi	s0,sp,112
    80002af8:	8aaa                	mv	s5,a0
    80002afa:	8bae                	mv	s7,a1
    80002afc:	8a32                	mv	s4,a2
    80002afe:	8936                	mv	s2,a3
    80002b00:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002b02:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002b06:	00043737          	lui	a4,0x43
    80002b0a:	0cf76963          	bltu	a4,a5,80002bdc <writei+0xfc>
    80002b0e:	0cd7e763          	bltu	a5,a3,80002bdc <writei+0xfc>
    80002b12:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b14:	0a0b0a63          	beqz	s6,80002bc8 <writei+0xe8>
    80002b18:	eca6                	sd	s1,88(sp)
    80002b1a:	f062                	sd	s8,32(sp)
    80002b1c:	ec66                	sd	s9,24(sp)
    80002b1e:	e86a                	sd	s10,16(sp)
    80002b20:	e46e                	sd	s11,8(sp)
    80002b22:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b24:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002b28:	5c7d                	li	s8,-1
    80002b2a:	a825                	j	80002b62 <writei+0x82>
    80002b2c:	020d1d93          	slli	s11,s10,0x20
    80002b30:	020ddd93          	srli	s11,s11,0x20
    80002b34:	05848513          	addi	a0,s1,88
    80002b38:	86ee                	mv	a3,s11
    80002b3a:	8652                	mv	a2,s4
    80002b3c:	85de                	mv	a1,s7
    80002b3e:	953e                	add	a0,a0,a5
    80002b40:	bf7fe0ef          	jal	80001736 <either_copyin>
    80002b44:	05850663          	beq	a0,s8,80002b90 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002b48:	8526                	mv	a0,s1
    80002b4a:	6b8000ef          	jal	80003202 <log_write>
    brelse(bp);
    80002b4e:	8526                	mv	a0,s1
    80002b50:	d7cff0ef          	jal	800020cc <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002b54:	013d09bb          	addw	s3,s10,s3
    80002b58:	012d093b          	addw	s2,s10,s2
    80002b5c:	9a6e                	add	s4,s4,s11
    80002b5e:	0369fc63          	bgeu	s3,s6,80002b96 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002b62:	00a9559b          	srliw	a1,s2,0xa
    80002b66:	8556                	mv	a0,s5
    80002b68:	fc2ff0ef          	jal	8000232a <bmap>
    80002b6c:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b6e:	c505                	beqz	a0,80002b96 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002b70:	000aa503          	lw	a0,0(s5)
    80002b74:	c50ff0ef          	jal	80001fc4 <bread>
    80002b78:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b7a:	3ff97793          	andi	a5,s2,1023
    80002b7e:	40fc873b          	subw	a4,s9,a5
    80002b82:	413b06bb          	subw	a3,s6,s3
    80002b86:	8d3a                	mv	s10,a4
    80002b88:	fae6f2e3          	bgeu	a3,a4,80002b2c <writei+0x4c>
    80002b8c:	8d36                	mv	s10,a3
    80002b8e:	bf79                	j	80002b2c <writei+0x4c>
      brelse(bp);
    80002b90:	8526                	mv	a0,s1
    80002b92:	d3aff0ef          	jal	800020cc <brelse>
  }

  if(off > ip->size)
    80002b96:	04caa783          	lw	a5,76(s5)
    80002b9a:	0327f963          	bgeu	a5,s2,80002bcc <writei+0xec>
    ip->size = off;
    80002b9e:	052aa623          	sw	s2,76(s5)
    80002ba2:	64e6                	ld	s1,88(sp)
    80002ba4:	7c02                	ld	s8,32(sp)
    80002ba6:	6ce2                	ld	s9,24(sp)
    80002ba8:	6d42                	ld	s10,16(sp)
    80002baa:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002bac:	8556                	mv	a0,s5
    80002bae:	9fbff0ef          	jal	800025a8 <iupdate>

  return tot;
    80002bb2:	854e                	mv	a0,s3
    80002bb4:	69a6                	ld	s3,72(sp)
}
    80002bb6:	70a6                	ld	ra,104(sp)
    80002bb8:	7406                	ld	s0,96(sp)
    80002bba:	6946                	ld	s2,80(sp)
    80002bbc:	6a06                	ld	s4,64(sp)
    80002bbe:	7ae2                	ld	s5,56(sp)
    80002bc0:	7b42                	ld	s6,48(sp)
    80002bc2:	7ba2                	ld	s7,40(sp)
    80002bc4:	6165                	addi	sp,sp,112
    80002bc6:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002bc8:	89da                	mv	s3,s6
    80002bca:	b7cd                	j	80002bac <writei+0xcc>
    80002bcc:	64e6                	ld	s1,88(sp)
    80002bce:	7c02                	ld	s8,32(sp)
    80002bd0:	6ce2                	ld	s9,24(sp)
    80002bd2:	6d42                	ld	s10,16(sp)
    80002bd4:	6da2                	ld	s11,8(sp)
    80002bd6:	bfd9                	j	80002bac <writei+0xcc>
    return -1;
    80002bd8:	557d                	li	a0,-1
}
    80002bda:	8082                	ret
    return -1;
    80002bdc:	557d                	li	a0,-1
    80002bde:	bfe1                	j	80002bb6 <writei+0xd6>

0000000080002be0 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002be0:	1141                	addi	sp,sp,-16
    80002be2:	e406                	sd	ra,8(sp)
    80002be4:	e022                	sd	s0,0(sp)
    80002be6:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002be8:	4639                	li	a2,14
    80002bea:	e48fd0ef          	jal	80000232 <strncmp>
}
    80002bee:	60a2                	ld	ra,8(sp)
    80002bf0:	6402                	ld	s0,0(sp)
    80002bf2:	0141                	addi	sp,sp,16
    80002bf4:	8082                	ret

0000000080002bf6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002bf6:	711d                	addi	sp,sp,-96
    80002bf8:	ec86                	sd	ra,88(sp)
    80002bfa:	e8a2                	sd	s0,80(sp)
    80002bfc:	e4a6                	sd	s1,72(sp)
    80002bfe:	e0ca                	sd	s2,64(sp)
    80002c00:	fc4e                	sd	s3,56(sp)
    80002c02:	f852                	sd	s4,48(sp)
    80002c04:	f456                	sd	s5,40(sp)
    80002c06:	f05a                	sd	s6,32(sp)
    80002c08:	ec5e                	sd	s7,24(sp)
    80002c0a:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002c0c:	04451703          	lh	a4,68(a0)
    80002c10:	4785                	li	a5,1
    80002c12:	00f71f63          	bne	a4,a5,80002c30 <dirlookup+0x3a>
    80002c16:	892a                	mv	s2,a0
    80002c18:	8aae                	mv	s5,a1
    80002c1a:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c1c:	457c                	lw	a5,76(a0)
    80002c1e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c20:	fa040a13          	addi	s4,s0,-96
    80002c24:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002c26:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002c2a:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c2c:	e39d                	bnez	a5,80002c52 <dirlookup+0x5c>
    80002c2e:	a8b9                	j	80002c8c <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002c30:	00005517          	auipc	a0,0x5
    80002c34:	81050513          	addi	a0,a0,-2032 # 80007440 <etext+0x440>
    80002c38:	1ff020ef          	jal	80005636 <panic>
      panic("dirlookup read");
    80002c3c:	00005517          	auipc	a0,0x5
    80002c40:	81c50513          	addi	a0,a0,-2020 # 80007458 <etext+0x458>
    80002c44:	1f3020ef          	jal	80005636 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002c48:	24c1                	addiw	s1,s1,16
    80002c4a:	04c92783          	lw	a5,76(s2)
    80002c4e:	02f4fe63          	bgeu	s1,a5,80002c8a <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002c52:	874e                	mv	a4,s3
    80002c54:	86a6                	mv	a3,s1
    80002c56:	8652                	mv	a2,s4
    80002c58:	4581                	li	a1,0
    80002c5a:	854a                	mv	a0,s2
    80002c5c:	d93ff0ef          	jal	800029ee <readi>
    80002c60:	fd351ee3          	bne	a0,s3,80002c3c <dirlookup+0x46>
    if(de.inum == 0)
    80002c64:	fa045783          	lhu	a5,-96(s0)
    80002c68:	d3e5                	beqz	a5,80002c48 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002c6a:	85da                	mv	a1,s6
    80002c6c:	8556                	mv	a0,s5
    80002c6e:	f73ff0ef          	jal	80002be0 <namecmp>
    80002c72:	f979                	bnez	a0,80002c48 <dirlookup+0x52>
      if(poff)
    80002c74:	000b8463          	beqz	s7,80002c7c <dirlookup+0x86>
        *poff = off;
    80002c78:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002c7c:	fa045583          	lhu	a1,-96(s0)
    80002c80:	00092503          	lw	a0,0(s2)
    80002c84:	f66ff0ef          	jal	800023ea <iget>
    80002c88:	a011                	j	80002c8c <dirlookup+0x96>
  return 0;
    80002c8a:	4501                	li	a0,0
}
    80002c8c:	60e6                	ld	ra,88(sp)
    80002c8e:	6446                	ld	s0,80(sp)
    80002c90:	64a6                	ld	s1,72(sp)
    80002c92:	6906                	ld	s2,64(sp)
    80002c94:	79e2                	ld	s3,56(sp)
    80002c96:	7a42                	ld	s4,48(sp)
    80002c98:	7aa2                	ld	s5,40(sp)
    80002c9a:	7b02                	ld	s6,32(sp)
    80002c9c:	6be2                	ld	s7,24(sp)
    80002c9e:	6125                	addi	sp,sp,96
    80002ca0:	8082                	ret

0000000080002ca2 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
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
    80002cb6:	e862                	sd	s8,16(sp)
    80002cb8:	e466                	sd	s9,8(sp)
    80002cba:	e06a                	sd	s10,0(sp)
    80002cbc:	1080                	addi	s0,sp,96
    80002cbe:	84aa                	mv	s1,a0
    80002cc0:	8b2e                	mv	s6,a1
    80002cc2:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002cc4:	00054703          	lbu	a4,0(a0)
    80002cc8:	02f00793          	li	a5,47
    80002ccc:	00f70f63          	beq	a4,a5,80002cea <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002cd0:	8c4fe0ef          	jal	80000d94 <myproc>
    80002cd4:	15053503          	ld	a0,336(a0)
    80002cd8:	94fff0ef          	jal	80002626 <idup>
    80002cdc:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002cde:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002ce2:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002ce4:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002ce6:	4b85                	li	s7,1
    80002ce8:	a879                	j	80002d86 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002cea:	4585                	li	a1,1
    80002cec:	852e                	mv	a0,a1
    80002cee:	efcff0ef          	jal	800023ea <iget>
    80002cf2:	8a2a                	mv	s4,a0
    80002cf4:	b7ed                	j	80002cde <namex+0x3c>
      iunlockput(ip);
    80002cf6:	8552                	mv	a0,s4
    80002cf8:	b71ff0ef          	jal	80002868 <iunlockput>
      return 0;
    80002cfc:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002cfe:	8552                	mv	a0,s4
    80002d00:	60e6                	ld	ra,88(sp)
    80002d02:	6446                	ld	s0,80(sp)
    80002d04:	64a6                	ld	s1,72(sp)
    80002d06:	6906                	ld	s2,64(sp)
    80002d08:	79e2                	ld	s3,56(sp)
    80002d0a:	7a42                	ld	s4,48(sp)
    80002d0c:	7aa2                	ld	s5,40(sp)
    80002d0e:	7b02                	ld	s6,32(sp)
    80002d10:	6be2                	ld	s7,24(sp)
    80002d12:	6c42                	ld	s8,16(sp)
    80002d14:	6ca2                	ld	s9,8(sp)
    80002d16:	6d02                	ld	s10,0(sp)
    80002d18:	6125                	addi	sp,sp,96
    80002d1a:	8082                	ret
      iunlock(ip);
    80002d1c:	8552                	mv	a0,s4
    80002d1e:	9edff0ef          	jal	8000270a <iunlock>
      return ip;
    80002d22:	bff1                	j	80002cfe <namex+0x5c>
      iunlockput(ip);
    80002d24:	8552                	mv	a0,s4
    80002d26:	b43ff0ef          	jal	80002868 <iunlockput>
      return 0;
    80002d2a:	8a4a                	mv	s4,s2
    80002d2c:	bfc9                	j	80002cfe <namex+0x5c>
  len = path - s;
    80002d2e:	40990633          	sub	a2,s2,s1
    80002d32:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002d36:	09ac5463          	bge	s8,s10,80002dbe <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002d3a:	8666                	mv	a2,s9
    80002d3c:	85a6                	mv	a1,s1
    80002d3e:	8556                	mv	a0,s5
    80002d40:	c7efd0ef          	jal	800001be <memmove>
    80002d44:	84ca                	mv	s1,s2
  while(*path == '/')
    80002d46:	0004c783          	lbu	a5,0(s1)
    80002d4a:	01379763          	bne	a5,s3,80002d58 <namex+0xb6>
    path++;
    80002d4e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d50:	0004c783          	lbu	a5,0(s1)
    80002d54:	ff378de3          	beq	a5,s3,80002d4e <namex+0xac>
    ilock(ip);
    80002d58:	8552                	mv	a0,s4
    80002d5a:	903ff0ef          	jal	8000265c <ilock>
    if(ip->type != T_DIR){
    80002d5e:	044a1783          	lh	a5,68(s4)
    80002d62:	f9779ae3          	bne	a5,s7,80002cf6 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002d66:	000b0563          	beqz	s6,80002d70 <namex+0xce>
    80002d6a:	0004c783          	lbu	a5,0(s1)
    80002d6e:	d7dd                	beqz	a5,80002d1c <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002d70:	4601                	li	a2,0
    80002d72:	85d6                	mv	a1,s5
    80002d74:	8552                	mv	a0,s4
    80002d76:	e81ff0ef          	jal	80002bf6 <dirlookup>
    80002d7a:	892a                	mv	s2,a0
    80002d7c:	d545                	beqz	a0,80002d24 <namex+0x82>
    iunlockput(ip);
    80002d7e:	8552                	mv	a0,s4
    80002d80:	ae9ff0ef          	jal	80002868 <iunlockput>
    ip = next;
    80002d84:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002d86:	0004c783          	lbu	a5,0(s1)
    80002d8a:	01379763          	bne	a5,s3,80002d98 <namex+0xf6>
    path++;
    80002d8e:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002d90:	0004c783          	lbu	a5,0(s1)
    80002d94:	ff378de3          	beq	a5,s3,80002d8e <namex+0xec>
  if(*path == 0)
    80002d98:	cf8d                	beqz	a5,80002dd2 <namex+0x130>
  while(*path != '/' && *path != 0)
    80002d9a:	0004c783          	lbu	a5,0(s1)
    80002d9e:	fd178713          	addi	a4,a5,-47
    80002da2:	cb19                	beqz	a4,80002db8 <namex+0x116>
    80002da4:	cb91                	beqz	a5,80002db8 <namex+0x116>
    80002da6:	8926                	mv	s2,s1
    path++;
    80002da8:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002daa:	00094783          	lbu	a5,0(s2)
    80002dae:	fd178713          	addi	a4,a5,-47
    80002db2:	df35                	beqz	a4,80002d2e <namex+0x8c>
    80002db4:	fbf5                	bnez	a5,80002da8 <namex+0x106>
    80002db6:	bfa5                	j	80002d2e <namex+0x8c>
    80002db8:	8926                	mv	s2,s1
  len = path - s;
    80002dba:	4d01                	li	s10,0
    80002dbc:	4601                	li	a2,0
    memmove(name, s, len);
    80002dbe:	2601                	sext.w	a2,a2
    80002dc0:	85a6                	mv	a1,s1
    80002dc2:	8556                	mv	a0,s5
    80002dc4:	bfafd0ef          	jal	800001be <memmove>
    name[len] = 0;
    80002dc8:	9d56                	add	s10,s10,s5
    80002dca:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffde498>
    80002dce:	84ca                	mv	s1,s2
    80002dd0:	bf9d                	j	80002d46 <namex+0xa4>
  if(nameiparent){
    80002dd2:	f20b06e3          	beqz	s6,80002cfe <namex+0x5c>
    iput(ip);
    80002dd6:	8552                	mv	a0,s4
    80002dd8:	a07ff0ef          	jal	800027de <iput>
    return 0;
    80002ddc:	4a01                	li	s4,0
    80002dde:	b705                	j	80002cfe <namex+0x5c>

0000000080002de0 <dirlink>:
{
    80002de0:	715d                	addi	sp,sp,-80
    80002de2:	e486                	sd	ra,72(sp)
    80002de4:	e0a2                	sd	s0,64(sp)
    80002de6:	f84a                	sd	s2,48(sp)
    80002de8:	ec56                	sd	s5,24(sp)
    80002dea:	e85a                	sd	s6,16(sp)
    80002dec:	0880                	addi	s0,sp,80
    80002dee:	892a                	mv	s2,a0
    80002df0:	8aae                	mv	s5,a1
    80002df2:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002df4:	4601                	li	a2,0
    80002df6:	e01ff0ef          	jal	80002bf6 <dirlookup>
    80002dfa:	ed1d                	bnez	a0,80002e38 <dirlink+0x58>
    80002dfc:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002dfe:	04c92483          	lw	s1,76(s2)
    80002e02:	c4b9                	beqz	s1,80002e50 <dirlink+0x70>
    80002e04:	f44e                	sd	s3,40(sp)
    80002e06:	f052                	sd	s4,32(sp)
    80002e08:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e0a:	fb040a13          	addi	s4,s0,-80
    80002e0e:	49c1                	li	s3,16
    80002e10:	874e                	mv	a4,s3
    80002e12:	86a6                	mv	a3,s1
    80002e14:	8652                	mv	a2,s4
    80002e16:	4581                	li	a1,0
    80002e18:	854a                	mv	a0,s2
    80002e1a:	bd5ff0ef          	jal	800029ee <readi>
    80002e1e:	03351163          	bne	a0,s3,80002e40 <dirlink+0x60>
    if(de.inum == 0)
    80002e22:	fb045783          	lhu	a5,-80(s0)
    80002e26:	c39d                	beqz	a5,80002e4c <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002e28:	24c1                	addiw	s1,s1,16
    80002e2a:	04c92783          	lw	a5,76(s2)
    80002e2e:	fef4e1e3          	bltu	s1,a5,80002e10 <dirlink+0x30>
    80002e32:	79a2                	ld	s3,40(sp)
    80002e34:	7a02                	ld	s4,32(sp)
    80002e36:	a829                	j	80002e50 <dirlink+0x70>
    iput(ip);
    80002e38:	9a7ff0ef          	jal	800027de <iput>
    return -1;
    80002e3c:	557d                	li	a0,-1
    80002e3e:	a83d                	j	80002e7c <dirlink+0x9c>
      panic("dirlink read");
    80002e40:	00004517          	auipc	a0,0x4
    80002e44:	62850513          	addi	a0,a0,1576 # 80007468 <etext+0x468>
    80002e48:	7ee020ef          	jal	80005636 <panic>
    80002e4c:	79a2                	ld	s3,40(sp)
    80002e4e:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002e50:	4639                	li	a2,14
    80002e52:	85d6                	mv	a1,s5
    80002e54:	fb240513          	addi	a0,s0,-78
    80002e58:	c14fd0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80002e5c:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002e60:	4741                	li	a4,16
    80002e62:	86a6                	mv	a3,s1
    80002e64:	fb040613          	addi	a2,s0,-80
    80002e68:	4581                	li	a1,0
    80002e6a:	854a                	mv	a0,s2
    80002e6c:	c75ff0ef          	jal	80002ae0 <writei>
    80002e70:	1541                	addi	a0,a0,-16
    80002e72:	00a03533          	snez	a0,a0
    80002e76:	40a0053b          	negw	a0,a0
    80002e7a:	74e2                	ld	s1,56(sp)
}
    80002e7c:	60a6                	ld	ra,72(sp)
    80002e7e:	6406                	ld	s0,64(sp)
    80002e80:	7942                	ld	s2,48(sp)
    80002e82:	6ae2                	ld	s5,24(sp)
    80002e84:	6b42                	ld	s6,16(sp)
    80002e86:	6161                	addi	sp,sp,80
    80002e88:	8082                	ret

0000000080002e8a <namei>:

struct inode*
namei(char *path)
{
    80002e8a:	1101                	addi	sp,sp,-32
    80002e8c:	ec06                	sd	ra,24(sp)
    80002e8e:	e822                	sd	s0,16(sp)
    80002e90:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002e92:	fe040613          	addi	a2,s0,-32
    80002e96:	4581                	li	a1,0
    80002e98:	e0bff0ef          	jal	80002ca2 <namex>
}
    80002e9c:	60e2                	ld	ra,24(sp)
    80002e9e:	6442                	ld	s0,16(sp)
    80002ea0:	6105                	addi	sp,sp,32
    80002ea2:	8082                	ret

0000000080002ea4 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002ea4:	1141                	addi	sp,sp,-16
    80002ea6:	e406                	sd	ra,8(sp)
    80002ea8:	e022                	sd	s0,0(sp)
    80002eaa:	0800                	addi	s0,sp,16
    80002eac:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002eae:	4585                	li	a1,1
    80002eb0:	df3ff0ef          	jal	80002ca2 <namex>
}
    80002eb4:	60a2                	ld	ra,8(sp)
    80002eb6:	6402                	ld	s0,0(sp)
    80002eb8:	0141                	addi	sp,sp,16
    80002eba:	8082                	ret

0000000080002ebc <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002ebc:	1101                	addi	sp,sp,-32
    80002ebe:	ec06                	sd	ra,24(sp)
    80002ec0:	e822                	sd	s0,16(sp)
    80002ec2:	e426                	sd	s1,8(sp)
    80002ec4:	e04a                	sd	s2,0(sp)
    80002ec6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002ec8:	00015917          	auipc	s2,0x15
    80002ecc:	98890913          	addi	s2,s2,-1656 # 80017850 <log>
    80002ed0:	01892583          	lw	a1,24(s2)
    80002ed4:	02492503          	lw	a0,36(s2)
    80002ed8:	8ecff0ef          	jal	80001fc4 <bread>
    80002edc:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002ede:	02892603          	lw	a2,40(s2)
    80002ee2:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002ee4:	00c05f63          	blez	a2,80002f02 <write_head+0x46>
    80002ee8:	00015717          	auipc	a4,0x15
    80002eec:	99470713          	addi	a4,a4,-1644 # 8001787c <log+0x2c>
    80002ef0:	87aa                	mv	a5,a0
    80002ef2:	060a                	slli	a2,a2,0x2
    80002ef4:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002ef6:	4314                	lw	a3,0(a4)
    80002ef8:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002efa:	0711                	addi	a4,a4,4
    80002efc:	0791                	addi	a5,a5,4
    80002efe:	fec79ce3          	bne	a5,a2,80002ef6 <write_head+0x3a>
  }
  bwrite(buf);
    80002f02:	8526                	mv	a0,s1
    80002f04:	996ff0ef          	jal	8000209a <bwrite>
  brelse(buf);
    80002f08:	8526                	mv	a0,s1
    80002f0a:	9c2ff0ef          	jal	800020cc <brelse>
}
    80002f0e:	60e2                	ld	ra,24(sp)
    80002f10:	6442                	ld	s0,16(sp)
    80002f12:	64a2                	ld	s1,8(sp)
    80002f14:	6902                	ld	s2,0(sp)
    80002f16:	6105                	addi	sp,sp,32
    80002f18:	8082                	ret

0000000080002f1a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f1a:	00015797          	auipc	a5,0x15
    80002f1e:	95e7a783          	lw	a5,-1698(a5) # 80017878 <log+0x28>
    80002f22:	0cf05163          	blez	a5,80002fe4 <install_trans+0xca>
{
    80002f26:	715d                	addi	sp,sp,-80
    80002f28:	e486                	sd	ra,72(sp)
    80002f2a:	e0a2                	sd	s0,64(sp)
    80002f2c:	fc26                	sd	s1,56(sp)
    80002f2e:	f84a                	sd	s2,48(sp)
    80002f30:	f44e                	sd	s3,40(sp)
    80002f32:	f052                	sd	s4,32(sp)
    80002f34:	ec56                	sd	s5,24(sp)
    80002f36:	e85a                	sd	s6,16(sp)
    80002f38:	e45e                	sd	s7,8(sp)
    80002f3a:	e062                	sd	s8,0(sp)
    80002f3c:	0880                	addi	s0,sp,80
    80002f3e:	8b2a                	mv	s6,a0
    80002f40:	00015a97          	auipc	s5,0x15
    80002f44:	93ca8a93          	addi	s5,s5,-1732 # 8001787c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f48:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002f4a:	00004c17          	auipc	s8,0x4
    80002f4e:	52ec0c13          	addi	s8,s8,1326 # 80007478 <etext+0x478>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f52:	00015a17          	auipc	s4,0x15
    80002f56:	8fea0a13          	addi	s4,s4,-1794 # 80017850 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002f5a:	40000b93          	li	s7,1024
    80002f5e:	a025                	j	80002f86 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80002f60:	000aa603          	lw	a2,0(s5)
    80002f64:	85ce                	mv	a1,s3
    80002f66:	8562                	mv	a0,s8
    80002f68:	3a4020ef          	jal	8000530c <printf>
    80002f6c:	a839                	j	80002f8a <install_trans+0x70>
    brelse(lbuf);
    80002f6e:	854a                	mv	a0,s2
    80002f70:	95cff0ef          	jal	800020cc <brelse>
    brelse(dbuf);
    80002f74:	8526                	mv	a0,s1
    80002f76:	956ff0ef          	jal	800020cc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80002f7a:	2985                	addiw	s3,s3,1
    80002f7c:	0a91                	addi	s5,s5,4
    80002f7e:	028a2783          	lw	a5,40(s4)
    80002f82:	04f9d563          	bge	s3,a5,80002fcc <install_trans+0xb2>
    if(recovering) {
    80002f86:	fc0b1de3          	bnez	s6,80002f60 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80002f8a:	018a2583          	lw	a1,24(s4)
    80002f8e:	013585bb          	addw	a1,a1,s3
    80002f92:	2585                	addiw	a1,a1,1
    80002f94:	024a2503          	lw	a0,36(s4)
    80002f98:	82cff0ef          	jal	80001fc4 <bread>
    80002f9c:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80002f9e:	000aa583          	lw	a1,0(s5)
    80002fa2:	024a2503          	lw	a0,36(s4)
    80002fa6:	81eff0ef          	jal	80001fc4 <bread>
    80002faa:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80002fac:	865e                	mv	a2,s7
    80002fae:	05890593          	addi	a1,s2,88
    80002fb2:	05850513          	addi	a0,a0,88
    80002fb6:	a08fd0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    80002fba:	8526                	mv	a0,s1
    80002fbc:	8deff0ef          	jal	8000209a <bwrite>
    if(recovering == 0)
    80002fc0:	fa0b17e3          	bnez	s6,80002f6e <install_trans+0x54>
      bunpin(dbuf);
    80002fc4:	8526                	mv	a0,s1
    80002fc6:	9beff0ef          	jal	80002184 <bunpin>
    80002fca:	b755                	j	80002f6e <install_trans+0x54>
}
    80002fcc:	60a6                	ld	ra,72(sp)
    80002fce:	6406                	ld	s0,64(sp)
    80002fd0:	74e2                	ld	s1,56(sp)
    80002fd2:	7942                	ld	s2,48(sp)
    80002fd4:	79a2                	ld	s3,40(sp)
    80002fd6:	7a02                	ld	s4,32(sp)
    80002fd8:	6ae2                	ld	s5,24(sp)
    80002fda:	6b42                	ld	s6,16(sp)
    80002fdc:	6ba2                	ld	s7,8(sp)
    80002fde:	6c02                	ld	s8,0(sp)
    80002fe0:	6161                	addi	sp,sp,80
    80002fe2:	8082                	ret
    80002fe4:	8082                	ret

0000000080002fe6 <initlog>:
{
    80002fe6:	7179                	addi	sp,sp,-48
    80002fe8:	f406                	sd	ra,40(sp)
    80002fea:	f022                	sd	s0,32(sp)
    80002fec:	ec26                	sd	s1,24(sp)
    80002fee:	e84a                	sd	s2,16(sp)
    80002ff0:	e44e                	sd	s3,8(sp)
    80002ff2:	1800                	addi	s0,sp,48
    80002ff4:	84aa                	mv	s1,a0
    80002ff6:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80002ff8:	00015917          	auipc	s2,0x15
    80002ffc:	85890913          	addi	s2,s2,-1960 # 80017850 <log>
    80003000:	00004597          	auipc	a1,0x4
    80003004:	49858593          	addi	a1,a1,1176 # 80007498 <etext+0x498>
    80003008:	854a                	mv	a0,s2
    8000300a:	065020ef          	jal	8000586e <initlock>
  log.start = sb->logstart;
    8000300e:	0149a583          	lw	a1,20(s3)
    80003012:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003016:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    8000301a:	8526                	mv	a0,s1
    8000301c:	fa9fe0ef          	jal	80001fc4 <bread>
  log.lh.n = lh->n;
    80003020:	4d30                	lw	a2,88(a0)
    80003022:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003026:	00c05f63          	blez	a2,80003044 <initlog+0x5e>
    8000302a:	87aa                	mv	a5,a0
    8000302c:	00015717          	auipc	a4,0x15
    80003030:	85070713          	addi	a4,a4,-1968 # 8001787c <log+0x2c>
    80003034:	060a                	slli	a2,a2,0x2
    80003036:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003038:	4ff4                	lw	a3,92(a5)
    8000303a:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000303c:	0791                	addi	a5,a5,4
    8000303e:	0711                	addi	a4,a4,4
    80003040:	fec79ce3          	bne	a5,a2,80003038 <initlog+0x52>
  brelse(buf);
    80003044:	888ff0ef          	jal	800020cc <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003048:	4505                	li	a0,1
    8000304a:	ed1ff0ef          	jal	80002f1a <install_trans>
  log.lh.n = 0;
    8000304e:	00015797          	auipc	a5,0x15
    80003052:	8207a523          	sw	zero,-2006(a5) # 80017878 <log+0x28>
  write_head(); // clear the log
    80003056:	e67ff0ef          	jal	80002ebc <write_head>
}
    8000305a:	70a2                	ld	ra,40(sp)
    8000305c:	7402                	ld	s0,32(sp)
    8000305e:	64e2                	ld	s1,24(sp)
    80003060:	6942                	ld	s2,16(sp)
    80003062:	69a2                	ld	s3,8(sp)
    80003064:	6145                	addi	sp,sp,48
    80003066:	8082                	ret

0000000080003068 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003068:	1101                	addi	sp,sp,-32
    8000306a:	ec06                	sd	ra,24(sp)
    8000306c:	e822                	sd	s0,16(sp)
    8000306e:	e426                	sd	s1,8(sp)
    80003070:	e04a                	sd	s2,0(sp)
    80003072:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003074:	00014517          	auipc	a0,0x14
    80003078:	7dc50513          	addi	a0,a0,2012 # 80017850 <log>
    8000307c:	07d020ef          	jal	800058f8 <acquire>
  while(1){
    if(log.committing){
    80003080:	00014497          	auipc	s1,0x14
    80003084:	7d048493          	addi	s1,s1,2000 # 80017850 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003088:	4979                	li	s2,30
    8000308a:	a029                	j	80003094 <begin_op+0x2c>
      sleep(&log, &log.lock);
    8000308c:	85a6                	mv	a1,s1
    8000308e:	8526                	mv	a0,s1
    80003090:	b02fe0ef          	jal	80001392 <sleep>
    if(log.committing){
    80003094:	509c                	lw	a5,32(s1)
    80003096:	fbfd                	bnez	a5,8000308c <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003098:	4cd8                	lw	a4,28(s1)
    8000309a:	2705                	addiw	a4,a4,1
    8000309c:	0027179b          	slliw	a5,a4,0x2
    800030a0:	9fb9                	addw	a5,a5,a4
    800030a2:	0017979b          	slliw	a5,a5,0x1
    800030a6:	5494                	lw	a3,40(s1)
    800030a8:	9fb5                	addw	a5,a5,a3
    800030aa:	00f95763          	bge	s2,a5,800030b8 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800030ae:	85a6                	mv	a1,s1
    800030b0:	8526                	mv	a0,s1
    800030b2:	ae0fe0ef          	jal	80001392 <sleep>
    800030b6:	bff9                	j	80003094 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800030b8:	00014797          	auipc	a5,0x14
    800030bc:	7ae7aa23          	sw	a4,1972(a5) # 8001786c <log+0x1c>
      release(&log.lock);
    800030c0:	00014517          	auipc	a0,0x14
    800030c4:	79050513          	addi	a0,a0,1936 # 80017850 <log>
    800030c8:	0c5020ef          	jal	8000598c <release>
      break;
    }
  }
}
    800030cc:	60e2                	ld	ra,24(sp)
    800030ce:	6442                	ld	s0,16(sp)
    800030d0:	64a2                	ld	s1,8(sp)
    800030d2:	6902                	ld	s2,0(sp)
    800030d4:	6105                	addi	sp,sp,32
    800030d6:	8082                	ret

00000000800030d8 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800030d8:	7139                	addi	sp,sp,-64
    800030da:	fc06                	sd	ra,56(sp)
    800030dc:	f822                	sd	s0,48(sp)
    800030de:	f426                	sd	s1,40(sp)
    800030e0:	f04a                	sd	s2,32(sp)
    800030e2:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800030e4:	00014497          	auipc	s1,0x14
    800030e8:	76c48493          	addi	s1,s1,1900 # 80017850 <log>
    800030ec:	8526                	mv	a0,s1
    800030ee:	00b020ef          	jal	800058f8 <acquire>
  log.outstanding -= 1;
    800030f2:	4cdc                	lw	a5,28(s1)
    800030f4:	37fd                	addiw	a5,a5,-1
    800030f6:	893e                	mv	s2,a5
    800030f8:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800030fa:	509c                	lw	a5,32(s1)
    800030fc:	e7b1                	bnez	a5,80003148 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    800030fe:	04091e63          	bnez	s2,8000315a <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003102:	00014497          	auipc	s1,0x14
    80003106:	74e48493          	addi	s1,s1,1870 # 80017850 <log>
    8000310a:	4785                	li	a5,1
    8000310c:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000310e:	8526                	mv	a0,s1
    80003110:	07d020ef          	jal	8000598c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003114:	549c                	lw	a5,40(s1)
    80003116:	06f04463          	bgtz	a5,8000317e <end_op+0xa6>
    acquire(&log.lock);
    8000311a:	00014517          	auipc	a0,0x14
    8000311e:	73650513          	addi	a0,a0,1846 # 80017850 <log>
    80003122:	7d6020ef          	jal	800058f8 <acquire>
    log.committing = 0;
    80003126:	00014797          	auipc	a5,0x14
    8000312a:	7407a523          	sw	zero,1866(a5) # 80017870 <log+0x20>
    wakeup(&log);
    8000312e:	00014517          	auipc	a0,0x14
    80003132:	72250513          	addi	a0,a0,1826 # 80017850 <log>
    80003136:	aa8fe0ef          	jal	800013de <wakeup>
    release(&log.lock);
    8000313a:	00014517          	auipc	a0,0x14
    8000313e:	71650513          	addi	a0,a0,1814 # 80017850 <log>
    80003142:	04b020ef          	jal	8000598c <release>
}
    80003146:	a035                	j	80003172 <end_op+0x9a>
    80003148:	ec4e                	sd	s3,24(sp)
    8000314a:	e852                	sd	s4,16(sp)
    8000314c:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000314e:	00004517          	auipc	a0,0x4
    80003152:	35250513          	addi	a0,a0,850 # 800074a0 <etext+0x4a0>
    80003156:	4e0020ef          	jal	80005636 <panic>
    wakeup(&log);
    8000315a:	00014517          	auipc	a0,0x14
    8000315e:	6f650513          	addi	a0,a0,1782 # 80017850 <log>
    80003162:	a7cfe0ef          	jal	800013de <wakeup>
  release(&log.lock);
    80003166:	00014517          	auipc	a0,0x14
    8000316a:	6ea50513          	addi	a0,a0,1770 # 80017850 <log>
    8000316e:	01f020ef          	jal	8000598c <release>
}
    80003172:	70e2                	ld	ra,56(sp)
    80003174:	7442                	ld	s0,48(sp)
    80003176:	74a2                	ld	s1,40(sp)
    80003178:	7902                	ld	s2,32(sp)
    8000317a:	6121                	addi	sp,sp,64
    8000317c:	8082                	ret
    8000317e:	ec4e                	sd	s3,24(sp)
    80003180:	e852                	sd	s4,16(sp)
    80003182:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003184:	00014a97          	auipc	s5,0x14
    80003188:	6f8a8a93          	addi	s5,s5,1784 # 8001787c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    8000318c:	00014a17          	auipc	s4,0x14
    80003190:	6c4a0a13          	addi	s4,s4,1732 # 80017850 <log>
    80003194:	018a2583          	lw	a1,24(s4)
    80003198:	012585bb          	addw	a1,a1,s2
    8000319c:	2585                	addiw	a1,a1,1
    8000319e:	024a2503          	lw	a0,36(s4)
    800031a2:	e23fe0ef          	jal	80001fc4 <bread>
    800031a6:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800031a8:	000aa583          	lw	a1,0(s5)
    800031ac:	024a2503          	lw	a0,36(s4)
    800031b0:	e15fe0ef          	jal	80001fc4 <bread>
    800031b4:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800031b6:	40000613          	li	a2,1024
    800031ba:	05850593          	addi	a1,a0,88
    800031be:	05848513          	addi	a0,s1,88
    800031c2:	ffdfc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    800031c6:	8526                	mv	a0,s1
    800031c8:	ed3fe0ef          	jal	8000209a <bwrite>
    brelse(from);
    800031cc:	854e                	mv	a0,s3
    800031ce:	efffe0ef          	jal	800020cc <brelse>
    brelse(to);
    800031d2:	8526                	mv	a0,s1
    800031d4:	ef9fe0ef          	jal	800020cc <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031d8:	2905                	addiw	s2,s2,1
    800031da:	0a91                	addi	s5,s5,4
    800031dc:	028a2783          	lw	a5,40(s4)
    800031e0:	faf94ae3          	blt	s2,a5,80003194 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800031e4:	cd9ff0ef          	jal	80002ebc <write_head>
    install_trans(0); // Now install writes to home locations
    800031e8:	4501                	li	a0,0
    800031ea:	d31ff0ef          	jal	80002f1a <install_trans>
    log.lh.n = 0;
    800031ee:	00014797          	auipc	a5,0x14
    800031f2:	6807a523          	sw	zero,1674(a5) # 80017878 <log+0x28>
    write_head();    // Erase the transaction from the log
    800031f6:	cc7ff0ef          	jal	80002ebc <write_head>
    800031fa:	69e2                	ld	s3,24(sp)
    800031fc:	6a42                	ld	s4,16(sp)
    800031fe:	6aa2                	ld	s5,8(sp)
    80003200:	bf29                	j	8000311a <end_op+0x42>

0000000080003202 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003202:	1101                	addi	sp,sp,-32
    80003204:	ec06                	sd	ra,24(sp)
    80003206:	e822                	sd	s0,16(sp)
    80003208:	e426                	sd	s1,8(sp)
    8000320a:	1000                	addi	s0,sp,32
    8000320c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000320e:	00014517          	auipc	a0,0x14
    80003212:	64250513          	addi	a0,a0,1602 # 80017850 <log>
    80003216:	6e2020ef          	jal	800058f8 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000321a:	00014617          	auipc	a2,0x14
    8000321e:	65e62603          	lw	a2,1630(a2) # 80017878 <log+0x28>
    80003222:	47f5                	li	a5,29
    80003224:	04c7cd63          	blt	a5,a2,8000327e <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003228:	00014797          	auipc	a5,0x14
    8000322c:	6447a783          	lw	a5,1604(a5) # 8001786c <log+0x1c>
    80003230:	04f05d63          	blez	a5,8000328a <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003234:	4781                	li	a5,0
    80003236:	06c05063          	blez	a2,80003296 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000323a:	44cc                	lw	a1,12(s1)
    8000323c:	00014717          	auipc	a4,0x14
    80003240:	64070713          	addi	a4,a4,1600 # 8001787c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003244:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003246:	4314                	lw	a3,0(a4)
    80003248:	04b68763          	beq	a3,a1,80003296 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    8000324c:	2785                	addiw	a5,a5,1
    8000324e:	0711                	addi	a4,a4,4
    80003250:	fef61be3          	bne	a2,a5,80003246 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003254:	060a                	slli	a2,a2,0x2
    80003256:	02060613          	addi	a2,a2,32
    8000325a:	00014797          	auipc	a5,0x14
    8000325e:	5f678793          	addi	a5,a5,1526 # 80017850 <log>
    80003262:	97b2                	add	a5,a5,a2
    80003264:	44d8                	lw	a4,12(s1)
    80003266:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003268:	8526                	mv	a0,s1
    8000326a:	ee7fe0ef          	jal	80002150 <bpin>
    log.lh.n++;
    8000326e:	00014717          	auipc	a4,0x14
    80003272:	5e270713          	addi	a4,a4,1506 # 80017850 <log>
    80003276:	571c                	lw	a5,40(a4)
    80003278:	2785                	addiw	a5,a5,1
    8000327a:	d71c                	sw	a5,40(a4)
    8000327c:	a815                	j	800032b0 <log_write+0xae>
    panic("too big a transaction");
    8000327e:	00004517          	auipc	a0,0x4
    80003282:	23250513          	addi	a0,a0,562 # 800074b0 <etext+0x4b0>
    80003286:	3b0020ef          	jal	80005636 <panic>
    panic("log_write outside of trans");
    8000328a:	00004517          	auipc	a0,0x4
    8000328e:	23e50513          	addi	a0,a0,574 # 800074c8 <etext+0x4c8>
    80003292:	3a4020ef          	jal	80005636 <panic>
  log.lh.block[i] = b->blockno;
    80003296:	00279693          	slli	a3,a5,0x2
    8000329a:	02068693          	addi	a3,a3,32
    8000329e:	00014717          	auipc	a4,0x14
    800032a2:	5b270713          	addi	a4,a4,1458 # 80017850 <log>
    800032a6:	9736                	add	a4,a4,a3
    800032a8:	44d4                	lw	a3,12(s1)
    800032aa:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800032ac:	faf60ee3          	beq	a2,a5,80003268 <log_write+0x66>
  }
  release(&log.lock);
    800032b0:	00014517          	auipc	a0,0x14
    800032b4:	5a050513          	addi	a0,a0,1440 # 80017850 <log>
    800032b8:	6d4020ef          	jal	8000598c <release>
}
    800032bc:	60e2                	ld	ra,24(sp)
    800032be:	6442                	ld	s0,16(sp)
    800032c0:	64a2                	ld	s1,8(sp)
    800032c2:	6105                	addi	sp,sp,32
    800032c4:	8082                	ret

00000000800032c6 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800032c6:	1101                	addi	sp,sp,-32
    800032c8:	ec06                	sd	ra,24(sp)
    800032ca:	e822                	sd	s0,16(sp)
    800032cc:	e426                	sd	s1,8(sp)
    800032ce:	e04a                	sd	s2,0(sp)
    800032d0:	1000                	addi	s0,sp,32
    800032d2:	84aa                	mv	s1,a0
    800032d4:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800032d6:	00004597          	auipc	a1,0x4
    800032da:	21258593          	addi	a1,a1,530 # 800074e8 <etext+0x4e8>
    800032de:	0521                	addi	a0,a0,8
    800032e0:	58e020ef          	jal	8000586e <initlock>
  lk->name = name;
    800032e4:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800032e8:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800032ec:	0204a423          	sw	zero,40(s1)
}
    800032f0:	60e2                	ld	ra,24(sp)
    800032f2:	6442                	ld	s0,16(sp)
    800032f4:	64a2                	ld	s1,8(sp)
    800032f6:	6902                	ld	s2,0(sp)
    800032f8:	6105                	addi	sp,sp,32
    800032fa:	8082                	ret

00000000800032fc <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800032fc:	1101                	addi	sp,sp,-32
    800032fe:	ec06                	sd	ra,24(sp)
    80003300:	e822                	sd	s0,16(sp)
    80003302:	e426                	sd	s1,8(sp)
    80003304:	e04a                	sd	s2,0(sp)
    80003306:	1000                	addi	s0,sp,32
    80003308:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000330a:	00850913          	addi	s2,a0,8
    8000330e:	854a                	mv	a0,s2
    80003310:	5e8020ef          	jal	800058f8 <acquire>
  while (lk->locked) {
    80003314:	409c                	lw	a5,0(s1)
    80003316:	c799                	beqz	a5,80003324 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003318:	85ca                	mv	a1,s2
    8000331a:	8526                	mv	a0,s1
    8000331c:	876fe0ef          	jal	80001392 <sleep>
  while (lk->locked) {
    80003320:	409c                	lw	a5,0(s1)
    80003322:	fbfd                	bnez	a5,80003318 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003324:	4785                	li	a5,1
    80003326:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003328:	a6dfd0ef          	jal	80000d94 <myproc>
    8000332c:	591c                	lw	a5,48(a0)
    8000332e:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003330:	854a                	mv	a0,s2
    80003332:	65a020ef          	jal	8000598c <release>
}
    80003336:	60e2                	ld	ra,24(sp)
    80003338:	6442                	ld	s0,16(sp)
    8000333a:	64a2                	ld	s1,8(sp)
    8000333c:	6902                	ld	s2,0(sp)
    8000333e:	6105                	addi	sp,sp,32
    80003340:	8082                	ret

0000000080003342 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003342:	1101                	addi	sp,sp,-32
    80003344:	ec06                	sd	ra,24(sp)
    80003346:	e822                	sd	s0,16(sp)
    80003348:	e426                	sd	s1,8(sp)
    8000334a:	e04a                	sd	s2,0(sp)
    8000334c:	1000                	addi	s0,sp,32
    8000334e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003350:	00850913          	addi	s2,a0,8
    80003354:	854a                	mv	a0,s2
    80003356:	5a2020ef          	jal	800058f8 <acquire>
  lk->locked = 0;
    8000335a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000335e:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003362:	8526                	mv	a0,s1
    80003364:	87afe0ef          	jal	800013de <wakeup>
  release(&lk->lk);
    80003368:	854a                	mv	a0,s2
    8000336a:	622020ef          	jal	8000598c <release>
}
    8000336e:	60e2                	ld	ra,24(sp)
    80003370:	6442                	ld	s0,16(sp)
    80003372:	64a2                	ld	s1,8(sp)
    80003374:	6902                	ld	s2,0(sp)
    80003376:	6105                	addi	sp,sp,32
    80003378:	8082                	ret

000000008000337a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000337a:	7179                	addi	sp,sp,-48
    8000337c:	f406                	sd	ra,40(sp)
    8000337e:	f022                	sd	s0,32(sp)
    80003380:	ec26                	sd	s1,24(sp)
    80003382:	e84a                	sd	s2,16(sp)
    80003384:	1800                	addi	s0,sp,48
    80003386:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003388:	00850913          	addi	s2,a0,8
    8000338c:	854a                	mv	a0,s2
    8000338e:	56a020ef          	jal	800058f8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003392:	409c                	lw	a5,0(s1)
    80003394:	ef81                	bnez	a5,800033ac <holdingsleep+0x32>
    80003396:	4481                	li	s1,0
  release(&lk->lk);
    80003398:	854a                	mv	a0,s2
    8000339a:	5f2020ef          	jal	8000598c <release>
  return r;
}
    8000339e:	8526                	mv	a0,s1
    800033a0:	70a2                	ld	ra,40(sp)
    800033a2:	7402                	ld	s0,32(sp)
    800033a4:	64e2                	ld	s1,24(sp)
    800033a6:	6942                	ld	s2,16(sp)
    800033a8:	6145                	addi	sp,sp,48
    800033aa:	8082                	ret
    800033ac:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800033ae:	0284a983          	lw	s3,40(s1)
    800033b2:	9e3fd0ef          	jal	80000d94 <myproc>
    800033b6:	5904                	lw	s1,48(a0)
    800033b8:	413484b3          	sub	s1,s1,s3
    800033bc:	0014b493          	seqz	s1,s1
    800033c0:	69a2                	ld	s3,8(sp)
    800033c2:	bfd9                	j	80003398 <holdingsleep+0x1e>

00000000800033c4 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800033c4:	1141                	addi	sp,sp,-16
    800033c6:	e406                	sd	ra,8(sp)
    800033c8:	e022                	sd	s0,0(sp)
    800033ca:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800033cc:	00004597          	auipc	a1,0x4
    800033d0:	12c58593          	addi	a1,a1,300 # 800074f8 <etext+0x4f8>
    800033d4:	00014517          	auipc	a0,0x14
    800033d8:	5c450513          	addi	a0,a0,1476 # 80017998 <ftable>
    800033dc:	492020ef          	jal	8000586e <initlock>
}
    800033e0:	60a2                	ld	ra,8(sp)
    800033e2:	6402                	ld	s0,0(sp)
    800033e4:	0141                	addi	sp,sp,16
    800033e6:	8082                	ret

00000000800033e8 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800033e8:	1101                	addi	sp,sp,-32
    800033ea:	ec06                	sd	ra,24(sp)
    800033ec:	e822                	sd	s0,16(sp)
    800033ee:	e426                	sd	s1,8(sp)
    800033f0:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800033f2:	00014517          	auipc	a0,0x14
    800033f6:	5a650513          	addi	a0,a0,1446 # 80017998 <ftable>
    800033fa:	4fe020ef          	jal	800058f8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800033fe:	00014497          	auipc	s1,0x14
    80003402:	5b248493          	addi	s1,s1,1458 # 800179b0 <ftable+0x18>
    80003406:	00015717          	auipc	a4,0x15
    8000340a:	54a70713          	addi	a4,a4,1354 # 80018950 <disk>
    if(f->ref == 0){
    8000340e:	40dc                	lw	a5,4(s1)
    80003410:	cf89                	beqz	a5,8000342a <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003412:	02848493          	addi	s1,s1,40
    80003416:	fee49ce3          	bne	s1,a4,8000340e <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000341a:	00014517          	auipc	a0,0x14
    8000341e:	57e50513          	addi	a0,a0,1406 # 80017998 <ftable>
    80003422:	56a020ef          	jal	8000598c <release>
  return 0;
    80003426:	4481                	li	s1,0
    80003428:	a809                	j	8000343a <filealloc+0x52>
      f->ref = 1;
    8000342a:	4785                	li	a5,1
    8000342c:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000342e:	00014517          	auipc	a0,0x14
    80003432:	56a50513          	addi	a0,a0,1386 # 80017998 <ftable>
    80003436:	556020ef          	jal	8000598c <release>
}
    8000343a:	8526                	mv	a0,s1
    8000343c:	60e2                	ld	ra,24(sp)
    8000343e:	6442                	ld	s0,16(sp)
    80003440:	64a2                	ld	s1,8(sp)
    80003442:	6105                	addi	sp,sp,32
    80003444:	8082                	ret

0000000080003446 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003446:	1101                	addi	sp,sp,-32
    80003448:	ec06                	sd	ra,24(sp)
    8000344a:	e822                	sd	s0,16(sp)
    8000344c:	e426                	sd	s1,8(sp)
    8000344e:	1000                	addi	s0,sp,32
    80003450:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003452:	00014517          	auipc	a0,0x14
    80003456:	54650513          	addi	a0,a0,1350 # 80017998 <ftable>
    8000345a:	49e020ef          	jal	800058f8 <acquire>
  if(f->ref < 1)
    8000345e:	40dc                	lw	a5,4(s1)
    80003460:	02f05063          	blez	a5,80003480 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003464:	2785                	addiw	a5,a5,1
    80003466:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003468:	00014517          	auipc	a0,0x14
    8000346c:	53050513          	addi	a0,a0,1328 # 80017998 <ftable>
    80003470:	51c020ef          	jal	8000598c <release>
  return f;
}
    80003474:	8526                	mv	a0,s1
    80003476:	60e2                	ld	ra,24(sp)
    80003478:	6442                	ld	s0,16(sp)
    8000347a:	64a2                	ld	s1,8(sp)
    8000347c:	6105                	addi	sp,sp,32
    8000347e:	8082                	ret
    panic("filedup");
    80003480:	00004517          	auipc	a0,0x4
    80003484:	08050513          	addi	a0,a0,128 # 80007500 <etext+0x500>
    80003488:	1ae020ef          	jal	80005636 <panic>

000000008000348c <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    8000348c:	7139                	addi	sp,sp,-64
    8000348e:	fc06                	sd	ra,56(sp)
    80003490:	f822                	sd	s0,48(sp)
    80003492:	f426                	sd	s1,40(sp)
    80003494:	0080                	addi	s0,sp,64
    80003496:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003498:	00014517          	auipc	a0,0x14
    8000349c:	50050513          	addi	a0,a0,1280 # 80017998 <ftable>
    800034a0:	458020ef          	jal	800058f8 <acquire>
  if(f->ref < 1)
    800034a4:	40dc                	lw	a5,4(s1)
    800034a6:	04f05a63          	blez	a5,800034fa <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800034aa:	37fd                	addiw	a5,a5,-1
    800034ac:	c0dc                	sw	a5,4(s1)
    800034ae:	06f04063          	bgtz	a5,8000350e <fileclose+0x82>
    800034b2:	f04a                	sd	s2,32(sp)
    800034b4:	ec4e                	sd	s3,24(sp)
    800034b6:	e852                	sd	s4,16(sp)
    800034b8:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800034ba:	0004a903          	lw	s2,0(s1)
    800034be:	0094c783          	lbu	a5,9(s1)
    800034c2:	89be                	mv	s3,a5
    800034c4:	689c                	ld	a5,16(s1)
    800034c6:	8a3e                	mv	s4,a5
    800034c8:	6c9c                	ld	a5,24(s1)
    800034ca:	8abe                	mv	s5,a5
  f->ref = 0;
    800034cc:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800034d0:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800034d4:	00014517          	auipc	a0,0x14
    800034d8:	4c450513          	addi	a0,a0,1220 # 80017998 <ftable>
    800034dc:	4b0020ef          	jal	8000598c <release>

  if(ff.type == FD_PIPE){
    800034e0:	4785                	li	a5,1
    800034e2:	04f90163          	beq	s2,a5,80003524 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800034e6:	ffe9079b          	addiw	a5,s2,-2
    800034ea:	4705                	li	a4,1
    800034ec:	04f77563          	bgeu	a4,a5,80003536 <fileclose+0xaa>
    800034f0:	7902                	ld	s2,32(sp)
    800034f2:	69e2                	ld	s3,24(sp)
    800034f4:	6a42                	ld	s4,16(sp)
    800034f6:	6aa2                	ld	s5,8(sp)
    800034f8:	a00d                	j	8000351a <fileclose+0x8e>
    800034fa:	f04a                	sd	s2,32(sp)
    800034fc:	ec4e                	sd	s3,24(sp)
    800034fe:	e852                	sd	s4,16(sp)
    80003500:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003502:	00004517          	auipc	a0,0x4
    80003506:	00650513          	addi	a0,a0,6 # 80007508 <etext+0x508>
    8000350a:	12c020ef          	jal	80005636 <panic>
    release(&ftable.lock);
    8000350e:	00014517          	auipc	a0,0x14
    80003512:	48a50513          	addi	a0,a0,1162 # 80017998 <ftable>
    80003516:	476020ef          	jal	8000598c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000351a:	70e2                	ld	ra,56(sp)
    8000351c:	7442                	ld	s0,48(sp)
    8000351e:	74a2                	ld	s1,40(sp)
    80003520:	6121                	addi	sp,sp,64
    80003522:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003524:	85ce                	mv	a1,s3
    80003526:	8552                	mv	a0,s4
    80003528:	348000ef          	jal	80003870 <pipeclose>
    8000352c:	7902                	ld	s2,32(sp)
    8000352e:	69e2                	ld	s3,24(sp)
    80003530:	6a42                	ld	s4,16(sp)
    80003532:	6aa2                	ld	s5,8(sp)
    80003534:	b7dd                	j	8000351a <fileclose+0x8e>
    begin_op();
    80003536:	b33ff0ef          	jal	80003068 <begin_op>
    iput(ff.ip);
    8000353a:	8556                	mv	a0,s5
    8000353c:	aa2ff0ef          	jal	800027de <iput>
    end_op();
    80003540:	b99ff0ef          	jal	800030d8 <end_op>
    80003544:	7902                	ld	s2,32(sp)
    80003546:	69e2                	ld	s3,24(sp)
    80003548:	6a42                	ld	s4,16(sp)
    8000354a:	6aa2                	ld	s5,8(sp)
    8000354c:	b7f9                	j	8000351a <fileclose+0x8e>

000000008000354e <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000354e:	715d                	addi	sp,sp,-80
    80003550:	e486                	sd	ra,72(sp)
    80003552:	e0a2                	sd	s0,64(sp)
    80003554:	fc26                	sd	s1,56(sp)
    80003556:	f052                	sd	s4,32(sp)
    80003558:	0880                	addi	s0,sp,80
    8000355a:	84aa                	mv	s1,a0
    8000355c:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000355e:	837fd0ef          	jal	80000d94 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003562:	409c                	lw	a5,0(s1)
    80003564:	37f9                	addiw	a5,a5,-2
    80003566:	4705                	li	a4,1
    80003568:	04f76263          	bltu	a4,a5,800035ac <filestat+0x5e>
    8000356c:	f84a                	sd	s2,48(sp)
    8000356e:	f44e                	sd	s3,40(sp)
    80003570:	89aa                	mv	s3,a0
    ilock(f->ip);
    80003572:	6c88                	ld	a0,24(s1)
    80003574:	8e8ff0ef          	jal	8000265c <ilock>
    stati(f->ip, &st);
    80003578:	fb840913          	addi	s2,s0,-72
    8000357c:	85ca                	mv	a1,s2
    8000357e:	6c88                	ld	a0,24(s1)
    80003580:	c40ff0ef          	jal	800029c0 <stati>
    iunlock(f->ip);
    80003584:	6c88                	ld	a0,24(s1)
    80003586:	984ff0ef          	jal	8000270a <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    8000358a:	46e1                	li	a3,24
    8000358c:	864a                	mv	a2,s2
    8000358e:	85d2                	mv	a1,s4
    80003590:	0509b503          	ld	a0,80(s3)
    80003594:	d26fd0ef          	jal	80000aba <copyout>
    80003598:	41f5551b          	sraiw	a0,a0,0x1f
    8000359c:	7942                	ld	s2,48(sp)
    8000359e:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800035a0:	60a6                	ld	ra,72(sp)
    800035a2:	6406                	ld	s0,64(sp)
    800035a4:	74e2                	ld	s1,56(sp)
    800035a6:	7a02                	ld	s4,32(sp)
    800035a8:	6161                	addi	sp,sp,80
    800035aa:	8082                	ret
  return -1;
    800035ac:	557d                	li	a0,-1
    800035ae:	bfcd                	j	800035a0 <filestat+0x52>

00000000800035b0 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800035b0:	7179                	addi	sp,sp,-48
    800035b2:	f406                	sd	ra,40(sp)
    800035b4:	f022                	sd	s0,32(sp)
    800035b6:	e84a                	sd	s2,16(sp)
    800035b8:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800035ba:	00854783          	lbu	a5,8(a0)
    800035be:	cfd1                	beqz	a5,8000365a <fileread+0xaa>
    800035c0:	ec26                	sd	s1,24(sp)
    800035c2:	e44e                	sd	s3,8(sp)
    800035c4:	84aa                	mv	s1,a0
    800035c6:	892e                	mv	s2,a1
    800035c8:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800035ca:	411c                	lw	a5,0(a0)
    800035cc:	4705                	li	a4,1
    800035ce:	04e78363          	beq	a5,a4,80003614 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800035d2:	470d                	li	a4,3
    800035d4:	04e78763          	beq	a5,a4,80003622 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800035d8:	4709                	li	a4,2
    800035da:	06e79a63          	bne	a5,a4,8000364e <fileread+0x9e>
    ilock(f->ip);
    800035de:	6d08                	ld	a0,24(a0)
    800035e0:	87cff0ef          	jal	8000265c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800035e4:	874e                	mv	a4,s3
    800035e6:	5094                	lw	a3,32(s1)
    800035e8:	864a                	mv	a2,s2
    800035ea:	4585                	li	a1,1
    800035ec:	6c88                	ld	a0,24(s1)
    800035ee:	c00ff0ef          	jal	800029ee <readi>
    800035f2:	892a                	mv	s2,a0
    800035f4:	00a05563          	blez	a0,800035fe <fileread+0x4e>
      f->off += r;
    800035f8:	509c                	lw	a5,32(s1)
    800035fa:	9fa9                	addw	a5,a5,a0
    800035fc:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800035fe:	6c88                	ld	a0,24(s1)
    80003600:	90aff0ef          	jal	8000270a <iunlock>
    80003604:	64e2                	ld	s1,24(sp)
    80003606:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003608:	854a                	mv	a0,s2
    8000360a:	70a2                	ld	ra,40(sp)
    8000360c:	7402                	ld	s0,32(sp)
    8000360e:	6942                	ld	s2,16(sp)
    80003610:	6145                	addi	sp,sp,48
    80003612:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003614:	6908                	ld	a0,16(a0)
    80003616:	3b0000ef          	jal	800039c6 <piperead>
    8000361a:	892a                	mv	s2,a0
    8000361c:	64e2                	ld	s1,24(sp)
    8000361e:	69a2                	ld	s3,8(sp)
    80003620:	b7e5                	j	80003608 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003622:	02451783          	lh	a5,36(a0)
    80003626:	03079693          	slli	a3,a5,0x30
    8000362a:	92c1                	srli	a3,a3,0x30
    8000362c:	4725                	li	a4,9
    8000362e:	02d76963          	bltu	a4,a3,80003660 <fileread+0xb0>
    80003632:	0792                	slli	a5,a5,0x4
    80003634:	00014717          	auipc	a4,0x14
    80003638:	2c470713          	addi	a4,a4,708 # 800178f8 <devsw>
    8000363c:	97ba                	add	a5,a5,a4
    8000363e:	639c                	ld	a5,0(a5)
    80003640:	c78d                	beqz	a5,8000366a <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80003642:	4505                	li	a0,1
    80003644:	9782                	jalr	a5
    80003646:	892a                	mv	s2,a0
    80003648:	64e2                	ld	s1,24(sp)
    8000364a:	69a2                	ld	s3,8(sp)
    8000364c:	bf75                	j	80003608 <fileread+0x58>
    panic("fileread");
    8000364e:	00004517          	auipc	a0,0x4
    80003652:	eca50513          	addi	a0,a0,-310 # 80007518 <etext+0x518>
    80003656:	7e1010ef          	jal	80005636 <panic>
    return -1;
    8000365a:	57fd                	li	a5,-1
    8000365c:	893e                	mv	s2,a5
    8000365e:	b76d                	j	80003608 <fileread+0x58>
      return -1;
    80003660:	57fd                	li	a5,-1
    80003662:	893e                	mv	s2,a5
    80003664:	64e2                	ld	s1,24(sp)
    80003666:	69a2                	ld	s3,8(sp)
    80003668:	b745                	j	80003608 <fileread+0x58>
    8000366a:	57fd                	li	a5,-1
    8000366c:	893e                	mv	s2,a5
    8000366e:	64e2                	ld	s1,24(sp)
    80003670:	69a2                	ld	s3,8(sp)
    80003672:	bf59                	j	80003608 <fileread+0x58>

0000000080003674 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003674:	00954783          	lbu	a5,9(a0)
    80003678:	10078f63          	beqz	a5,80003796 <filewrite+0x122>
{
    8000367c:	711d                	addi	sp,sp,-96
    8000367e:	ec86                	sd	ra,88(sp)
    80003680:	e8a2                	sd	s0,80(sp)
    80003682:	e0ca                	sd	s2,64(sp)
    80003684:	f456                	sd	s5,40(sp)
    80003686:	f05a                	sd	s6,32(sp)
    80003688:	1080                	addi	s0,sp,96
    8000368a:	892a                	mv	s2,a0
    8000368c:	8b2e                	mv	s6,a1
    8000368e:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003690:	411c                	lw	a5,0(a0)
    80003692:	4705                	li	a4,1
    80003694:	02e78a63          	beq	a5,a4,800036c8 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003698:	470d                	li	a4,3
    8000369a:	02e78b63          	beq	a5,a4,800036d0 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000369e:	4709                	li	a4,2
    800036a0:	0ce79f63          	bne	a5,a4,8000377e <filewrite+0x10a>
    800036a4:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800036a6:	0ac05a63          	blez	a2,8000375a <filewrite+0xe6>
    800036aa:	e4a6                	sd	s1,72(sp)
    800036ac:	fc4e                	sd	s3,56(sp)
    800036ae:	ec5e                	sd	s7,24(sp)
    800036b0:	e862                	sd	s8,16(sp)
    800036b2:	e466                	sd	s9,8(sp)
    int i = 0;
    800036b4:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800036b6:	6b85                	lui	s7,0x1
    800036b8:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800036bc:	6785                	lui	a5,0x1
    800036be:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800036c2:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800036c4:	4c05                	li	s8,1
    800036c6:	a8ad                	j	80003740 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800036c8:	6908                	ld	a0,16(a0)
    800036ca:	204000ef          	jal	800038ce <pipewrite>
    800036ce:	a04d                	j	80003770 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800036d0:	02451783          	lh	a5,36(a0)
    800036d4:	03079693          	slli	a3,a5,0x30
    800036d8:	92c1                	srli	a3,a3,0x30
    800036da:	4725                	li	a4,9
    800036dc:	0ad76f63          	bltu	a4,a3,8000379a <filewrite+0x126>
    800036e0:	0792                	slli	a5,a5,0x4
    800036e2:	00014717          	auipc	a4,0x14
    800036e6:	21670713          	addi	a4,a4,534 # 800178f8 <devsw>
    800036ea:	97ba                	add	a5,a5,a4
    800036ec:	679c                	ld	a5,8(a5)
    800036ee:	cbc5                	beqz	a5,8000379e <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800036f0:	4505                	li	a0,1
    800036f2:	9782                	jalr	a5
    800036f4:	a8b5                	j	80003770 <filewrite+0xfc>
      if(n1 > max)
    800036f6:	2981                	sext.w	s3,s3
      begin_op();
    800036f8:	971ff0ef          	jal	80003068 <begin_op>
      ilock(f->ip);
    800036fc:	01893503          	ld	a0,24(s2)
    80003700:	f5dfe0ef          	jal	8000265c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003704:	874e                	mv	a4,s3
    80003706:	02092683          	lw	a3,32(s2)
    8000370a:	016a0633          	add	a2,s4,s6
    8000370e:	85e2                	mv	a1,s8
    80003710:	01893503          	ld	a0,24(s2)
    80003714:	bccff0ef          	jal	80002ae0 <writei>
    80003718:	84aa                	mv	s1,a0
    8000371a:	00a05763          	blez	a0,80003728 <filewrite+0xb4>
        f->off += r;
    8000371e:	02092783          	lw	a5,32(s2)
    80003722:	9fa9                	addw	a5,a5,a0
    80003724:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003728:	01893503          	ld	a0,24(s2)
    8000372c:	fdffe0ef          	jal	8000270a <iunlock>
      end_op();
    80003730:	9a9ff0ef          	jal	800030d8 <end_op>

      if(r != n1){
    80003734:	02999563          	bne	s3,s1,8000375e <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80003738:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    8000373c:	015a5963          	bge	s4,s5,8000374e <filewrite+0xda>
      int n1 = n - i;
    80003740:	414a87bb          	subw	a5,s5,s4
    80003744:	89be                	mv	s3,a5
      if(n1 > max)
    80003746:	fafbd8e3          	bge	s7,a5,800036f6 <filewrite+0x82>
    8000374a:	89e6                	mv	s3,s9
    8000374c:	b76d                	j	800036f6 <filewrite+0x82>
    8000374e:	64a6                	ld	s1,72(sp)
    80003750:	79e2                	ld	s3,56(sp)
    80003752:	6be2                	ld	s7,24(sp)
    80003754:	6c42                	ld	s8,16(sp)
    80003756:	6ca2                	ld	s9,8(sp)
    80003758:	a801                	j	80003768 <filewrite+0xf4>
    int i = 0;
    8000375a:	4a01                	li	s4,0
    8000375c:	a031                	j	80003768 <filewrite+0xf4>
    8000375e:	64a6                	ld	s1,72(sp)
    80003760:	79e2                	ld	s3,56(sp)
    80003762:	6be2                	ld	s7,24(sp)
    80003764:	6c42                	ld	s8,16(sp)
    80003766:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003768:	034a9d63          	bne	s5,s4,800037a2 <filewrite+0x12e>
    8000376c:	8556                	mv	a0,s5
    8000376e:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003770:	60e6                	ld	ra,88(sp)
    80003772:	6446                	ld	s0,80(sp)
    80003774:	6906                	ld	s2,64(sp)
    80003776:	7aa2                	ld	s5,40(sp)
    80003778:	7b02                	ld	s6,32(sp)
    8000377a:	6125                	addi	sp,sp,96
    8000377c:	8082                	ret
    8000377e:	e4a6                	sd	s1,72(sp)
    80003780:	fc4e                	sd	s3,56(sp)
    80003782:	f852                	sd	s4,48(sp)
    80003784:	ec5e                	sd	s7,24(sp)
    80003786:	e862                	sd	s8,16(sp)
    80003788:	e466                	sd	s9,8(sp)
    panic("filewrite");
    8000378a:	00004517          	auipc	a0,0x4
    8000378e:	d9e50513          	addi	a0,a0,-610 # 80007528 <etext+0x528>
    80003792:	6a5010ef          	jal	80005636 <panic>
    return -1;
    80003796:	557d                	li	a0,-1
}
    80003798:	8082                	ret
      return -1;
    8000379a:	557d                	li	a0,-1
    8000379c:	bfd1                	j	80003770 <filewrite+0xfc>
    8000379e:	557d                	li	a0,-1
    800037a0:	bfc1                	j	80003770 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800037a2:	557d                	li	a0,-1
    800037a4:	7a42                	ld	s4,48(sp)
    800037a6:	b7e9                	j	80003770 <filewrite+0xfc>

00000000800037a8 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800037a8:	7179                	addi	sp,sp,-48
    800037aa:	f406                	sd	ra,40(sp)
    800037ac:	f022                	sd	s0,32(sp)
    800037ae:	ec26                	sd	s1,24(sp)
    800037b0:	e052                	sd	s4,0(sp)
    800037b2:	1800                	addi	s0,sp,48
    800037b4:	84aa                	mv	s1,a0
    800037b6:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800037b8:	0005b023          	sd	zero,0(a1)
    800037bc:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800037c0:	c29ff0ef          	jal	800033e8 <filealloc>
    800037c4:	e088                	sd	a0,0(s1)
    800037c6:	c549                	beqz	a0,80003850 <pipealloc+0xa8>
    800037c8:	c21ff0ef          	jal	800033e8 <filealloc>
    800037cc:	00aa3023          	sd	a0,0(s4)
    800037d0:	cd25                	beqz	a0,80003848 <pipealloc+0xa0>
    800037d2:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800037d4:	931fc0ef          	jal	80000104 <kalloc>
    800037d8:	892a                	mv	s2,a0
    800037da:	c12d                	beqz	a0,8000383c <pipealloc+0x94>
    800037dc:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800037de:	4985                	li	s3,1
    800037e0:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800037e4:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800037e8:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800037ec:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800037f0:	00004597          	auipc	a1,0x4
    800037f4:	d4858593          	addi	a1,a1,-696 # 80007538 <etext+0x538>
    800037f8:	076020ef          	jal	8000586e <initlock>
  (*f0)->type = FD_PIPE;
    800037fc:	609c                	ld	a5,0(s1)
    800037fe:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003802:	609c                	ld	a5,0(s1)
    80003804:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003808:	609c                	ld	a5,0(s1)
    8000380a:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000380e:	609c                	ld	a5,0(s1)
    80003810:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003814:	000a3783          	ld	a5,0(s4)
    80003818:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000381c:	000a3783          	ld	a5,0(s4)
    80003820:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003824:	000a3783          	ld	a5,0(s4)
    80003828:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000382c:	000a3783          	ld	a5,0(s4)
    80003830:	0127b823          	sd	s2,16(a5)
  return 0;
    80003834:	4501                	li	a0,0
    80003836:	6942                	ld	s2,16(sp)
    80003838:	69a2                	ld	s3,8(sp)
    8000383a:	a01d                	j	80003860 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000383c:	6088                	ld	a0,0(s1)
    8000383e:	c119                	beqz	a0,80003844 <pipealloc+0x9c>
    80003840:	6942                	ld	s2,16(sp)
    80003842:	a029                	j	8000384c <pipealloc+0xa4>
    80003844:	6942                	ld	s2,16(sp)
    80003846:	a029                	j	80003850 <pipealloc+0xa8>
    80003848:	6088                	ld	a0,0(s1)
    8000384a:	c10d                	beqz	a0,8000386c <pipealloc+0xc4>
    fileclose(*f0);
    8000384c:	c41ff0ef          	jal	8000348c <fileclose>
  if(*f1)
    80003850:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003854:	557d                	li	a0,-1
  if(*f1)
    80003856:	c789                	beqz	a5,80003860 <pipealloc+0xb8>
    fileclose(*f1);
    80003858:	853e                	mv	a0,a5
    8000385a:	c33ff0ef          	jal	8000348c <fileclose>
  return -1;
    8000385e:	557d                	li	a0,-1
}
    80003860:	70a2                	ld	ra,40(sp)
    80003862:	7402                	ld	s0,32(sp)
    80003864:	64e2                	ld	s1,24(sp)
    80003866:	6a02                	ld	s4,0(sp)
    80003868:	6145                	addi	sp,sp,48
    8000386a:	8082                	ret
  return -1;
    8000386c:	557d                	li	a0,-1
    8000386e:	bfcd                	j	80003860 <pipealloc+0xb8>

0000000080003870 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003870:	1101                	addi	sp,sp,-32
    80003872:	ec06                	sd	ra,24(sp)
    80003874:	e822                	sd	s0,16(sp)
    80003876:	e426                	sd	s1,8(sp)
    80003878:	e04a                	sd	s2,0(sp)
    8000387a:	1000                	addi	s0,sp,32
    8000387c:	84aa                	mv	s1,a0
    8000387e:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003880:	078020ef          	jal	800058f8 <acquire>
  if(writable){
    80003884:	02090763          	beqz	s2,800038b2 <pipeclose+0x42>
    pi->writeopen = 0;
    80003888:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    8000388c:	21848513          	addi	a0,s1,536
    80003890:	b4ffd0ef          	jal	800013de <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003894:	2204a783          	lw	a5,544(s1)
    80003898:	e781                	bnez	a5,800038a0 <pipeclose+0x30>
    8000389a:	2244a783          	lw	a5,548(s1)
    8000389e:	c38d                	beqz	a5,800038c0 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800038a0:	8526                	mv	a0,s1
    800038a2:	0ea020ef          	jal	8000598c <release>
}
    800038a6:	60e2                	ld	ra,24(sp)
    800038a8:	6442                	ld	s0,16(sp)
    800038aa:	64a2                	ld	s1,8(sp)
    800038ac:	6902                	ld	s2,0(sp)
    800038ae:	6105                	addi	sp,sp,32
    800038b0:	8082                	ret
    pi->readopen = 0;
    800038b2:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800038b6:	21c48513          	addi	a0,s1,540
    800038ba:	b25fd0ef          	jal	800013de <wakeup>
    800038be:	bfd9                	j	80003894 <pipeclose+0x24>
    release(&pi->lock);
    800038c0:	8526                	mv	a0,s1
    800038c2:	0ca020ef          	jal	8000598c <release>
    kfree((char*)pi);
    800038c6:	8526                	mv	a0,s1
    800038c8:	f54fc0ef          	jal	8000001c <kfree>
    800038cc:	bfe9                	j	800038a6 <pipeclose+0x36>

00000000800038ce <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800038ce:	7159                	addi	sp,sp,-112
    800038d0:	f486                	sd	ra,104(sp)
    800038d2:	f0a2                	sd	s0,96(sp)
    800038d4:	eca6                	sd	s1,88(sp)
    800038d6:	e8ca                	sd	s2,80(sp)
    800038d8:	e4ce                	sd	s3,72(sp)
    800038da:	e0d2                	sd	s4,64(sp)
    800038dc:	fc56                	sd	s5,56(sp)
    800038de:	1880                	addi	s0,sp,112
    800038e0:	84aa                	mv	s1,a0
    800038e2:	8aae                	mv	s5,a1
    800038e4:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800038e6:	caefd0ef          	jal	80000d94 <myproc>
    800038ea:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800038ec:	8526                	mv	a0,s1
    800038ee:	00a020ef          	jal	800058f8 <acquire>
  while(i < n){
    800038f2:	0d405263          	blez	s4,800039b6 <pipewrite+0xe8>
    800038f6:	f85a                	sd	s6,48(sp)
    800038f8:	f45e                	sd	s7,40(sp)
    800038fa:	f062                	sd	s8,32(sp)
    800038fc:	ec66                	sd	s9,24(sp)
    800038fe:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003900:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003902:	f9f40c13          	addi	s8,s0,-97
    80003906:	4b85                	li	s7,1
    80003908:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    8000390a:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    8000390e:	21c48c93          	addi	s9,s1,540
    80003912:	a82d                	j	8000394c <pipewrite+0x7e>
      release(&pi->lock);
    80003914:	8526                	mv	a0,s1
    80003916:	076020ef          	jal	8000598c <release>
      return -1;
    8000391a:	597d                	li	s2,-1
    8000391c:	7b42                	ld	s6,48(sp)
    8000391e:	7ba2                	ld	s7,40(sp)
    80003920:	7c02                	ld	s8,32(sp)
    80003922:	6ce2                	ld	s9,24(sp)
    80003924:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003926:	854a                	mv	a0,s2
    80003928:	70a6                	ld	ra,104(sp)
    8000392a:	7406                	ld	s0,96(sp)
    8000392c:	64e6                	ld	s1,88(sp)
    8000392e:	6946                	ld	s2,80(sp)
    80003930:	69a6                	ld	s3,72(sp)
    80003932:	6a06                	ld	s4,64(sp)
    80003934:	7ae2                	ld	s5,56(sp)
    80003936:	6165                	addi	sp,sp,112
    80003938:	8082                	ret
      wakeup(&pi->nread);
    8000393a:	856a                	mv	a0,s10
    8000393c:	aa3fd0ef          	jal	800013de <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003940:	85a6                	mv	a1,s1
    80003942:	8566                	mv	a0,s9
    80003944:	a4ffd0ef          	jal	80001392 <sleep>
  while(i < n){
    80003948:	05495a63          	bge	s2,s4,8000399c <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    8000394c:	2204a783          	lw	a5,544(s1)
    80003950:	d3f1                	beqz	a5,80003914 <pipewrite+0x46>
    80003952:	854e                	mv	a0,s3
    80003954:	c7bfd0ef          	jal	800015ce <killed>
    80003958:	fd55                	bnez	a0,80003914 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000395a:	2184a783          	lw	a5,536(s1)
    8000395e:	21c4a703          	lw	a4,540(s1)
    80003962:	2007879b          	addiw	a5,a5,512
    80003966:	fcf70ae3          	beq	a4,a5,8000393a <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000396a:	86de                	mv	a3,s7
    8000396c:	01590633          	add	a2,s2,s5
    80003970:	85e2                	mv	a1,s8
    80003972:	0509b503          	ld	a0,80(s3)
    80003976:	a02fd0ef          	jal	80000b78 <copyin>
    8000397a:	05650063          	beq	a0,s6,800039ba <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000397e:	21c4a783          	lw	a5,540(s1)
    80003982:	0017871b          	addiw	a4,a5,1
    80003986:	20e4ae23          	sw	a4,540(s1)
    8000398a:	1ff7f793          	andi	a5,a5,511
    8000398e:	97a6                	add	a5,a5,s1
    80003990:	f9f44703          	lbu	a4,-97(s0)
    80003994:	00e78c23          	sb	a4,24(a5)
      i++;
    80003998:	2905                	addiw	s2,s2,1
    8000399a:	b77d                	j	80003948 <pipewrite+0x7a>
    8000399c:	7b42                	ld	s6,48(sp)
    8000399e:	7ba2                	ld	s7,40(sp)
    800039a0:	7c02                	ld	s8,32(sp)
    800039a2:	6ce2                	ld	s9,24(sp)
    800039a4:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    800039a6:	21848513          	addi	a0,s1,536
    800039aa:	a35fd0ef          	jal	800013de <wakeup>
  release(&pi->lock);
    800039ae:	8526                	mv	a0,s1
    800039b0:	7dd010ef          	jal	8000598c <release>
  return i;
    800039b4:	bf8d                	j	80003926 <pipewrite+0x58>
  int i = 0;
    800039b6:	4901                	li	s2,0
    800039b8:	b7fd                	j	800039a6 <pipewrite+0xd8>
    800039ba:	7b42                	ld	s6,48(sp)
    800039bc:	7ba2                	ld	s7,40(sp)
    800039be:	7c02                	ld	s8,32(sp)
    800039c0:	6ce2                	ld	s9,24(sp)
    800039c2:	6d42                	ld	s10,16(sp)
    800039c4:	b7cd                	j	800039a6 <pipewrite+0xd8>

00000000800039c6 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800039c6:	711d                	addi	sp,sp,-96
    800039c8:	ec86                	sd	ra,88(sp)
    800039ca:	e8a2                	sd	s0,80(sp)
    800039cc:	e4a6                	sd	s1,72(sp)
    800039ce:	e0ca                	sd	s2,64(sp)
    800039d0:	fc4e                	sd	s3,56(sp)
    800039d2:	f852                	sd	s4,48(sp)
    800039d4:	f456                	sd	s5,40(sp)
    800039d6:	1080                	addi	s0,sp,96
    800039d8:	84aa                	mv	s1,a0
    800039da:	892e                	mv	s2,a1
    800039dc:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800039de:	bb6fd0ef          	jal	80000d94 <myproc>
    800039e2:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800039e4:	8526                	mv	a0,s1
    800039e6:	713010ef          	jal	800058f8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039ea:	2184a703          	lw	a4,536(s1)
    800039ee:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800039f2:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800039f6:	02f71763          	bne	a4,a5,80003a24 <piperead+0x5e>
    800039fa:	2244a783          	lw	a5,548(s1)
    800039fe:	cf85                	beqz	a5,80003a36 <piperead+0x70>
    if(killed(pr)){
    80003a00:	8552                	mv	a0,s4
    80003a02:	bcdfd0ef          	jal	800015ce <killed>
    80003a06:	e11d                	bnez	a0,80003a2c <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003a08:	85a6                	mv	a1,s1
    80003a0a:	854e                	mv	a0,s3
    80003a0c:	987fd0ef          	jal	80001392 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003a10:	2184a703          	lw	a4,536(s1)
    80003a14:	21c4a783          	lw	a5,540(s1)
    80003a18:	fef701e3          	beq	a4,a5,800039fa <piperead+0x34>
    80003a1c:	f05a                	sd	s6,32(sp)
    80003a1e:	ec5e                	sd	s7,24(sp)
    80003a20:	e862                	sd	s8,16(sp)
    80003a22:	a829                	j	80003a3c <piperead+0x76>
    80003a24:	f05a                	sd	s6,32(sp)
    80003a26:	ec5e                	sd	s7,24(sp)
    80003a28:	e862                	sd	s8,16(sp)
    80003a2a:	a809                	j	80003a3c <piperead+0x76>
      release(&pi->lock);
    80003a2c:	8526                	mv	a0,s1
    80003a2e:	75f010ef          	jal	8000598c <release>
      return -1;
    80003a32:	59fd                	li	s3,-1
    80003a34:	a09d                	j	80003a9a <piperead+0xd4>
    80003a36:	f05a                	sd	s6,32(sp)
    80003a38:	ec5e                	sd	s7,24(sp)
    80003a3a:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a3c:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a3e:	faf40c13          	addi	s8,s0,-81
    80003a42:	4b85                	li	s7,1
    80003a44:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a46:	05505063          	blez	s5,80003a86 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003a4a:	2184a783          	lw	a5,536(s1)
    80003a4e:	21c4a703          	lw	a4,540(s1)
    80003a52:	02f70a63          	beq	a4,a5,80003a86 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003a56:	0017871b          	addiw	a4,a5,1
    80003a5a:	20e4ac23          	sw	a4,536(s1)
    80003a5e:	1ff7f793          	andi	a5,a5,511
    80003a62:	97a6                	add	a5,a5,s1
    80003a64:	0187c783          	lbu	a5,24(a5)
    80003a68:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003a6c:	86de                	mv	a3,s7
    80003a6e:	8662                	mv	a2,s8
    80003a70:	85ca                	mv	a1,s2
    80003a72:	050a3503          	ld	a0,80(s4)
    80003a76:	844fd0ef          	jal	80000aba <copyout>
    80003a7a:	01650663          	beq	a0,s6,80003a86 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003a7e:	2985                	addiw	s3,s3,1
    80003a80:	0905                	addi	s2,s2,1
    80003a82:	fd3a94e3          	bne	s5,s3,80003a4a <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003a86:	21c48513          	addi	a0,s1,540
    80003a8a:	955fd0ef          	jal	800013de <wakeup>
  release(&pi->lock);
    80003a8e:	8526                	mv	a0,s1
    80003a90:	6fd010ef          	jal	8000598c <release>
    80003a94:	7b02                	ld	s6,32(sp)
    80003a96:	6be2                	ld	s7,24(sp)
    80003a98:	6c42                	ld	s8,16(sp)
  return i;
}
    80003a9a:	854e                	mv	a0,s3
    80003a9c:	60e6                	ld	ra,88(sp)
    80003a9e:	6446                	ld	s0,80(sp)
    80003aa0:	64a6                	ld	s1,72(sp)
    80003aa2:	6906                	ld	s2,64(sp)
    80003aa4:	79e2                	ld	s3,56(sp)
    80003aa6:	7a42                	ld	s4,48(sp)
    80003aa8:	7aa2                	ld	s5,40(sp)
    80003aaa:	6125                	addi	sp,sp,96
    80003aac:	8082                	ret

0000000080003aae <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003aae:	1141                	addi	sp,sp,-16
    80003ab0:	e406                	sd	ra,8(sp)
    80003ab2:	e022                	sd	s0,0(sp)
    80003ab4:	0800                	addi	s0,sp,16
    80003ab6:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003ab8:	0035151b          	slliw	a0,a0,0x3
    80003abc:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003abe:	8b89                	andi	a5,a5,2
    80003ac0:	c399                	beqz	a5,80003ac6 <flags2perm+0x18>
      perm |= PTE_W;
    80003ac2:	00456513          	ori	a0,a0,4
    return perm;
}
    80003ac6:	60a2                	ld	ra,8(sp)
    80003ac8:	6402                	ld	s0,0(sp)
    80003aca:	0141                	addi	sp,sp,16
    80003acc:	8082                	ret

0000000080003ace <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003ace:	de010113          	addi	sp,sp,-544
    80003ad2:	20113c23          	sd	ra,536(sp)
    80003ad6:	20813823          	sd	s0,528(sp)
    80003ada:	20913423          	sd	s1,520(sp)
    80003ade:	21213023          	sd	s2,512(sp)
    80003ae2:	1400                	addi	s0,sp,544
    80003ae4:	892a                	mv	s2,a0
    80003ae6:	dea43823          	sd	a0,-528(s0)
    80003aea:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003aee:	aa6fd0ef          	jal	80000d94 <myproc>
    80003af2:	84aa                	mv	s1,a0

  begin_op();
    80003af4:	d74ff0ef          	jal	80003068 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003af8:	854a                	mv	a0,s2
    80003afa:	b90ff0ef          	jal	80002e8a <namei>
    80003afe:	cd21                	beqz	a0,80003b56 <kexec+0x88>
    80003b00:	fbd2                	sd	s4,496(sp)
    80003b02:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003b04:	b59fe0ef          	jal	8000265c <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003b08:	04000713          	li	a4,64
    80003b0c:	4681                	li	a3,0
    80003b0e:	e5040613          	addi	a2,s0,-432
    80003b12:	4581                	li	a1,0
    80003b14:	8552                	mv	a0,s4
    80003b16:	ed9fe0ef          	jal	800029ee <readi>
    80003b1a:	04000793          	li	a5,64
    80003b1e:	00f51a63          	bne	a0,a5,80003b32 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003b22:	e5042703          	lw	a4,-432(s0)
    80003b26:	464c47b7          	lui	a5,0x464c4
    80003b2a:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003b2e:	02f70863          	beq	a4,a5,80003b5e <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003b32:	8552                	mv	a0,s4
    80003b34:	d35fe0ef          	jal	80002868 <iunlockput>
    end_op();
    80003b38:	da0ff0ef          	jal	800030d8 <end_op>
  }
  return -1;
    80003b3c:	557d                	li	a0,-1
    80003b3e:	7a5e                	ld	s4,496(sp)
}
    80003b40:	21813083          	ld	ra,536(sp)
    80003b44:	21013403          	ld	s0,528(sp)
    80003b48:	20813483          	ld	s1,520(sp)
    80003b4c:	20013903          	ld	s2,512(sp)
    80003b50:	22010113          	addi	sp,sp,544
    80003b54:	8082                	ret
    end_op();
    80003b56:	d82ff0ef          	jal	800030d8 <end_op>
    return -1;
    80003b5a:	557d                	li	a0,-1
    80003b5c:	b7d5                	j	80003b40 <kexec+0x72>
    80003b5e:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003b60:	8526                	mv	a0,s1
    80003b62:	b3cfd0ef          	jal	80000e9e <proc_pagetable>
    80003b66:	8b2a                	mv	s6,a0
    80003b68:	26050d63          	beqz	a0,80003de2 <kexec+0x314>
    80003b6c:	ffce                	sd	s3,504(sp)
    80003b6e:	f7d6                	sd	s5,488(sp)
    80003b70:	efde                	sd	s7,472(sp)
    80003b72:	ebe2                	sd	s8,464(sp)
    80003b74:	e7e6                	sd	s9,456(sp)
    80003b76:	e3ea                	sd	s10,448(sp)
    80003b78:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b7a:	e8845783          	lhu	a5,-376(s0)
    80003b7e:	0e078963          	beqz	a5,80003c70 <kexec+0x1a2>
    80003b82:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003b86:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003b88:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003b8a:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003b8e:	6c85                	lui	s9,0x1
    80003b90:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003b94:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003b98:	6a85                	lui	s5,0x1
    80003b9a:	a085                	j	80003bfa <kexec+0x12c>
      panic("loadseg: address should exist");
    80003b9c:	00004517          	auipc	a0,0x4
    80003ba0:	9a450513          	addi	a0,a0,-1628 # 80007540 <etext+0x540>
    80003ba4:	293010ef          	jal	80005636 <panic>
    if(sz - i < PGSIZE)
    80003ba8:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003baa:	874a                	mv	a4,s2
    80003bac:	009b86bb          	addw	a3,s7,s1
    80003bb0:	4581                	li	a1,0
    80003bb2:	8552                	mv	a0,s4
    80003bb4:	e3bfe0ef          	jal	800029ee <readi>
    80003bb8:	22a91963          	bne	s2,a0,80003dea <kexec+0x31c>
  for(i = 0; i < sz; i += PGSIZE){
    80003bbc:	009a84bb          	addw	s1,s5,s1
    80003bc0:	0334f263          	bgeu	s1,s3,80003be4 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003bc4:	02049593          	slli	a1,s1,0x20
    80003bc8:	9181                	srli	a1,a1,0x20
    80003bca:	95e2                	add	a1,a1,s8
    80003bcc:	855a                	mv	a0,s6
    80003bce:	8bffc0ef          	jal	8000048c <walkaddr>
    80003bd2:	862a                	mv	a2,a0
    if(pa == 0)
    80003bd4:	d561                	beqz	a0,80003b9c <kexec+0xce>
    if(sz - i < PGSIZE)
    80003bd6:	409987bb          	subw	a5,s3,s1
    80003bda:	893e                	mv	s2,a5
    80003bdc:	fcfcf6e3          	bgeu	s9,a5,80003ba8 <kexec+0xda>
    80003be0:	8956                	mv	s2,s5
    80003be2:	b7d9                	j	80003ba8 <kexec+0xda>
    sz = sz1;
    80003be4:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003be8:	2d05                	addiw	s10,s10,1
    80003bea:	e0843783          	ld	a5,-504(s0)
    80003bee:	0387869b          	addiw	a3,a5,56
    80003bf2:	e8845783          	lhu	a5,-376(s0)
    80003bf6:	06fd5e63          	bge	s10,a5,80003c72 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003bfa:	e0d43423          	sd	a3,-504(s0)
    80003bfe:	876e                	mv	a4,s11
    80003c00:	e1840613          	addi	a2,s0,-488
    80003c04:	4581                	li	a1,0
    80003c06:	8552                	mv	a0,s4
    80003c08:	de7fe0ef          	jal	800029ee <readi>
    80003c0c:	1db51d63          	bne	a0,s11,80003de6 <kexec+0x318>
    if(ph.type != ELF_PROG_LOAD)
    80003c10:	e1842783          	lw	a5,-488(s0)
    80003c14:	4705                	li	a4,1
    80003c16:	fce799e3          	bne	a5,a4,80003be8 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003c1a:	e4043483          	ld	s1,-448(s0)
    80003c1e:	e3843783          	ld	a5,-456(s0)
    80003c22:	1ef4e263          	bltu	s1,a5,80003e06 <kexec+0x338>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003c26:	e2843783          	ld	a5,-472(s0)
    80003c2a:	94be                	add	s1,s1,a5
    80003c2c:	1ef4e063          	bltu	s1,a5,80003e0c <kexec+0x33e>
    if(ph.vaddr % PGSIZE != 0)
    80003c30:	de843703          	ld	a4,-536(s0)
    80003c34:	8ff9                	and	a5,a5,a4
    80003c36:	1c079e63          	bnez	a5,80003e12 <kexec+0x344>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003c3a:	e1c42503          	lw	a0,-484(s0)
    80003c3e:	e71ff0ef          	jal	80003aae <flags2perm>
    80003c42:	86aa                	mv	a3,a0
    80003c44:	8626                	mv	a2,s1
    80003c46:	85ca                	mv	a1,s2
    80003c48:	855a                	mv	a0,s6
    80003c4a:	b19fc0ef          	jal	80000762 <uvmalloc>
    80003c4e:	dea43c23          	sd	a0,-520(s0)
    80003c52:	1c050363          	beqz	a0,80003e18 <kexec+0x34a>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c56:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c5a:	00098863          	beqz	s3,80003c6a <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003c5e:	e2843c03          	ld	s8,-472(s0)
    80003c62:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003c66:	4481                	li	s1,0
    80003c68:	bfb1                	j	80003bc4 <kexec+0xf6>
    sz = sz1;
    80003c6a:	df843903          	ld	s2,-520(s0)
    80003c6e:	bfad                	j	80003be8 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c70:	4901                	li	s2,0
  iunlockput(ip);
    80003c72:	8552                	mv	a0,s4
    80003c74:	bf5fe0ef          	jal	80002868 <iunlockput>
  end_op();
    80003c78:	c60ff0ef          	jal	800030d8 <end_op>
  p = myproc();
    80003c7c:	918fd0ef          	jal	80000d94 <myproc>
    80003c80:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003c82:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003c86:	6985                	lui	s3,0x1
    80003c88:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003c8a:	99ca                	add	s3,s3,s2
    80003c8c:	77fd                	lui	a5,0xfffff
    80003c8e:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003c92:	4691                	li	a3,4
    80003c94:	660d                	lui	a2,0x3
    80003c96:	964e                	add	a2,a2,s3
    80003c98:	85ce                	mv	a1,s3
    80003c9a:	855a                	mv	a0,s6
    80003c9c:	ac7fc0ef          	jal	80000762 <uvmalloc>
    80003ca0:	8a2a                	mv	s4,a0
    80003ca2:	e105                	bnez	a0,80003cc2 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003ca4:	85ce                	mv	a1,s3
    80003ca6:	855a                	mv	a0,s6
    80003ca8:	a7afd0ef          	jal	80000f22 <proc_freepagetable>
  return -1;
    80003cac:	557d                	li	a0,-1
    80003cae:	79fe                	ld	s3,504(sp)
    80003cb0:	7a5e                	ld	s4,496(sp)
    80003cb2:	7abe                	ld	s5,488(sp)
    80003cb4:	7b1e                	ld	s6,480(sp)
    80003cb6:	6bfe                	ld	s7,472(sp)
    80003cb8:	6c5e                	ld	s8,464(sp)
    80003cba:	6cbe                	ld	s9,456(sp)
    80003cbc:	6d1e                	ld	s10,448(sp)
    80003cbe:	7dfa                	ld	s11,440(sp)
    80003cc0:	b541                	j	80003b40 <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003cc2:	75f5                	lui	a1,0xffffd
    80003cc4:	95aa                	add	a1,a1,a0
    80003cc6:	855a                	mv	a0,s6
    80003cc8:	c6dfc0ef          	jal	80000934 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003ccc:	7bf9                	lui	s7,0xffffe
    80003cce:	9bd2                	add	s7,s7,s4
  for(argc = 0; argv[argc]; argc++) {
    80003cd0:	e0043783          	ld	a5,-512(s0)
    80003cd4:	6388                	ld	a0,0(a5)
  sp = sz;
    80003cd6:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003cd8:	4481                	li	s1,0
    ustack[argc] = sp;
    80003cda:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003cde:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003ce2:	cd21                	beqz	a0,80003d3a <kexec+0x26c>
    sp -= strlen(argv[argc]) + 1;
    80003ce4:	e04fc0ef          	jal	800002e8 <strlen>
    80003ce8:	0015079b          	addiw	a5,a0,1
    80003cec:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003cf0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003cf4:	13796563          	bltu	s2,s7,80003e1e <kexec+0x350>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003cf8:	e0043d83          	ld	s11,-512(s0)
    80003cfc:	000db983          	ld	s3,0(s11)
    80003d00:	854e                	mv	a0,s3
    80003d02:	de6fc0ef          	jal	800002e8 <strlen>
    80003d06:	0015069b          	addiw	a3,a0,1
    80003d0a:	864e                	mv	a2,s3
    80003d0c:	85ca                	mv	a1,s2
    80003d0e:	855a                	mv	a0,s6
    80003d10:	dabfc0ef          	jal	80000aba <copyout>
    80003d14:	10054763          	bltz	a0,80003e22 <kexec+0x354>
    ustack[argc] = sp;
    80003d18:	00349793          	slli	a5,s1,0x3
    80003d1c:	97e6                	add	a5,a5,s9
    80003d1e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffde498>
  for(argc = 0; argv[argc]; argc++) {
    80003d22:	0485                	addi	s1,s1,1
    80003d24:	008d8793          	addi	a5,s11,8
    80003d28:	e0f43023          	sd	a5,-512(s0)
    80003d2c:	008db503          	ld	a0,8(s11)
    80003d30:	c509                	beqz	a0,80003d3a <kexec+0x26c>
    if(argc >= MAXARG)
    80003d32:	fb8499e3          	bne	s1,s8,80003ce4 <kexec+0x216>
  sz = sz1;
    80003d36:	89d2                	mv	s3,s4
    80003d38:	b7b5                	j	80003ca4 <kexec+0x1d6>
  ustack[argc] = 0;
    80003d3a:	00349793          	slli	a5,s1,0x3
    80003d3e:	f9078793          	addi	a5,a5,-112
    80003d42:	97a2                	add	a5,a5,s0
    80003d44:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003d48:	00349693          	slli	a3,s1,0x3
    80003d4c:	06a1                	addi	a3,a3,8
    80003d4e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003d52:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003d56:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003d58:	f57966e3          	bltu	s2,s7,80003ca4 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003d5c:	e9040613          	addi	a2,s0,-368
    80003d60:	85ca                	mv	a1,s2
    80003d62:	855a                	mv	a0,s6
    80003d64:	d57fc0ef          	jal	80000aba <copyout>
    80003d68:	f2054ee3          	bltz	a0,80003ca4 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80003d6c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003d70:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003d74:	df043783          	ld	a5,-528(s0)
    80003d78:	0007c703          	lbu	a4,0(a5)
    80003d7c:	cf11                	beqz	a4,80003d98 <kexec+0x2ca>
    80003d7e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003d80:	02f00693          	li	a3,47
    80003d84:	a029                	j	80003d8e <kexec+0x2c0>
  for(last=s=path; *s; s++)
    80003d86:	0785                	addi	a5,a5,1
    80003d88:	fff7c703          	lbu	a4,-1(a5)
    80003d8c:	c711                	beqz	a4,80003d98 <kexec+0x2ca>
    if(*s == '/')
    80003d8e:	fed71ce3          	bne	a4,a3,80003d86 <kexec+0x2b8>
      last = s+1;
    80003d92:	def43823          	sd	a5,-528(s0)
    80003d96:	bfc5                	j	80003d86 <kexec+0x2b8>
  safestrcpy(p->name, last, sizeof(p->name));
    80003d98:	4641                	li	a2,16
    80003d9a:	df043583          	ld	a1,-528(s0)
    80003d9e:	158a8513          	addi	a0,s5,344
    80003da2:	d10fc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003da6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003daa:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003dae:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003db2:	058ab783          	ld	a5,88(s5)
    80003db6:	e6843703          	ld	a4,-408(s0)
    80003dba:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003dbc:	058ab783          	ld	a5,88(s5)
    80003dc0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003dc4:	85ea                	mv	a1,s10
    80003dc6:	95cfd0ef          	jal	80000f22 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003dca:	0004851b          	sext.w	a0,s1
    80003dce:	79fe                	ld	s3,504(sp)
    80003dd0:	7a5e                	ld	s4,496(sp)
    80003dd2:	7abe                	ld	s5,488(sp)
    80003dd4:	7b1e                	ld	s6,480(sp)
    80003dd6:	6bfe                	ld	s7,472(sp)
    80003dd8:	6c5e                	ld	s8,464(sp)
    80003dda:	6cbe                	ld	s9,456(sp)
    80003ddc:	6d1e                	ld	s10,448(sp)
    80003dde:	7dfa                	ld	s11,440(sp)
    80003de0:	b385                	j	80003b40 <kexec+0x72>
    80003de2:	7b1e                	ld	s6,480(sp)
    80003de4:	b3b9                	j	80003b32 <kexec+0x64>
    80003de6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003dea:	df843583          	ld	a1,-520(s0)
    80003dee:	855a                	mv	a0,s6
    80003df0:	932fd0ef          	jal	80000f22 <proc_freepagetable>
  if(ip){
    80003df4:	79fe                	ld	s3,504(sp)
    80003df6:	7abe                	ld	s5,488(sp)
    80003df8:	7b1e                	ld	s6,480(sp)
    80003dfa:	6bfe                	ld	s7,472(sp)
    80003dfc:	6c5e                	ld	s8,464(sp)
    80003dfe:	6cbe                	ld	s9,456(sp)
    80003e00:	6d1e                	ld	s10,448(sp)
    80003e02:	7dfa                	ld	s11,440(sp)
    80003e04:	b33d                	j	80003b32 <kexec+0x64>
    80003e06:	df243c23          	sd	s2,-520(s0)
    80003e0a:	b7c5                	j	80003dea <kexec+0x31c>
    80003e0c:	df243c23          	sd	s2,-520(s0)
    80003e10:	bfe9                	j	80003dea <kexec+0x31c>
    80003e12:	df243c23          	sd	s2,-520(s0)
    80003e16:	bfd1                	j	80003dea <kexec+0x31c>
    80003e18:	df243c23          	sd	s2,-520(s0)
    80003e1c:	b7f9                	j	80003dea <kexec+0x31c>
  sz = sz1;
    80003e1e:	89d2                	mv	s3,s4
    80003e20:	b551                	j	80003ca4 <kexec+0x1d6>
    80003e22:	89d2                	mv	s3,s4
    80003e24:	b541                	j	80003ca4 <kexec+0x1d6>

0000000080003e26 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003e26:	7179                	addi	sp,sp,-48
    80003e28:	f406                	sd	ra,40(sp)
    80003e2a:	f022                	sd	s0,32(sp)
    80003e2c:	ec26                	sd	s1,24(sp)
    80003e2e:	e84a                	sd	s2,16(sp)
    80003e30:	1800                	addi	s0,sp,48
    80003e32:	892e                	mv	s2,a1
    80003e34:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003e36:	fdc40593          	addi	a1,s0,-36
    80003e3a:	e65fd0ef          	jal	80001c9e <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003e3e:	fdc42703          	lw	a4,-36(s0)
    80003e42:	47bd                	li	a5,15
    80003e44:	02e7ea63          	bltu	a5,a4,80003e78 <argfd+0x52>
    80003e48:	f4dfc0ef          	jal	80000d94 <myproc>
    80003e4c:	fdc42703          	lw	a4,-36(s0)
    80003e50:	00371793          	slli	a5,a4,0x3
    80003e54:	0d078793          	addi	a5,a5,208
    80003e58:	953e                	add	a0,a0,a5
    80003e5a:	611c                	ld	a5,0(a0)
    80003e5c:	c385                	beqz	a5,80003e7c <argfd+0x56>
    return -1;
  if(pfd)
    80003e5e:	00090463          	beqz	s2,80003e66 <argfd+0x40>
    *pfd = fd;
    80003e62:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003e66:	4501                	li	a0,0
  if(pf)
    80003e68:	c091                	beqz	s1,80003e6c <argfd+0x46>
    *pf = f;
    80003e6a:	e09c                	sd	a5,0(s1)
}
    80003e6c:	70a2                	ld	ra,40(sp)
    80003e6e:	7402                	ld	s0,32(sp)
    80003e70:	64e2                	ld	s1,24(sp)
    80003e72:	6942                	ld	s2,16(sp)
    80003e74:	6145                	addi	sp,sp,48
    80003e76:	8082                	ret
    return -1;
    80003e78:	557d                	li	a0,-1
    80003e7a:	bfcd                	j	80003e6c <argfd+0x46>
    80003e7c:	557d                	li	a0,-1
    80003e7e:	b7fd                	j	80003e6c <argfd+0x46>

0000000080003e80 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003e80:	1101                	addi	sp,sp,-32
    80003e82:	ec06                	sd	ra,24(sp)
    80003e84:	e822                	sd	s0,16(sp)
    80003e86:	e426                	sd	s1,8(sp)
    80003e88:	1000                	addi	s0,sp,32
    80003e8a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003e8c:	f09fc0ef          	jal	80000d94 <myproc>
    80003e90:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003e92:	0d050793          	addi	a5,a0,208
    80003e96:	4501                	li	a0,0
    80003e98:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003e9a:	6398                	ld	a4,0(a5)
    80003e9c:	cb19                	beqz	a4,80003eb2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003e9e:	2505                	addiw	a0,a0,1
    80003ea0:	07a1                	addi	a5,a5,8
    80003ea2:	fed51ce3          	bne	a0,a3,80003e9a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003ea6:	557d                	li	a0,-1
}
    80003ea8:	60e2                	ld	ra,24(sp)
    80003eaa:	6442                	ld	s0,16(sp)
    80003eac:	64a2                	ld	s1,8(sp)
    80003eae:	6105                	addi	sp,sp,32
    80003eb0:	8082                	ret
      p->ofile[fd] = f;
    80003eb2:	00351793          	slli	a5,a0,0x3
    80003eb6:	0d078793          	addi	a5,a5,208
    80003eba:	963e                	add	a2,a2,a5
    80003ebc:	e204                	sd	s1,0(a2)
      return fd;
    80003ebe:	b7ed                	j	80003ea8 <fdalloc+0x28>

0000000080003ec0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003ec0:	715d                	addi	sp,sp,-80
    80003ec2:	e486                	sd	ra,72(sp)
    80003ec4:	e0a2                	sd	s0,64(sp)
    80003ec6:	fc26                	sd	s1,56(sp)
    80003ec8:	f84a                	sd	s2,48(sp)
    80003eca:	f44e                	sd	s3,40(sp)
    80003ecc:	f052                	sd	s4,32(sp)
    80003ece:	ec56                	sd	s5,24(sp)
    80003ed0:	e85a                	sd	s6,16(sp)
    80003ed2:	0880                	addi	s0,sp,80
    80003ed4:	892e                	mv	s2,a1
    80003ed6:	8a2e                	mv	s4,a1
    80003ed8:	8ab2                	mv	s5,a2
    80003eda:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003edc:	fb040593          	addi	a1,s0,-80
    80003ee0:	fc5fe0ef          	jal	80002ea4 <nameiparent>
    80003ee4:	84aa                	mv	s1,a0
    80003ee6:	10050763          	beqz	a0,80003ff4 <create+0x134>
    return 0;

  ilock(dp);
    80003eea:	f72fe0ef          	jal	8000265c <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003eee:	4601                	li	a2,0
    80003ef0:	fb040593          	addi	a1,s0,-80
    80003ef4:	8526                	mv	a0,s1
    80003ef6:	d01fe0ef          	jal	80002bf6 <dirlookup>
    80003efa:	89aa                	mv	s3,a0
    80003efc:	c131                	beqz	a0,80003f40 <create+0x80>
    iunlockput(dp);
    80003efe:	8526                	mv	a0,s1
    80003f00:	969fe0ef          	jal	80002868 <iunlockput>
    ilock(ip);
    80003f04:	854e                	mv	a0,s3
    80003f06:	f56fe0ef          	jal	8000265c <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80003f0a:	4789                	li	a5,2
    80003f0c:	02f91563          	bne	s2,a5,80003f36 <create+0x76>
    80003f10:	0449d783          	lhu	a5,68(s3)
    80003f14:	37f9                	addiw	a5,a5,-2
    80003f16:	17c2                	slli	a5,a5,0x30
    80003f18:	93c1                	srli	a5,a5,0x30
    80003f1a:	4705                	li	a4,1
    80003f1c:	00f76d63          	bltu	a4,a5,80003f36 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80003f20:	854e                	mv	a0,s3
    80003f22:	60a6                	ld	ra,72(sp)
    80003f24:	6406                	ld	s0,64(sp)
    80003f26:	74e2                	ld	s1,56(sp)
    80003f28:	7942                	ld	s2,48(sp)
    80003f2a:	79a2                	ld	s3,40(sp)
    80003f2c:	7a02                	ld	s4,32(sp)
    80003f2e:	6ae2                	ld	s5,24(sp)
    80003f30:	6b42                	ld	s6,16(sp)
    80003f32:	6161                	addi	sp,sp,80
    80003f34:	8082                	ret
    iunlockput(ip);
    80003f36:	854e                	mv	a0,s3
    80003f38:	931fe0ef          	jal	80002868 <iunlockput>
    return 0;
    80003f3c:	4981                	li	s3,0
    80003f3e:	b7cd                	j	80003f20 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80003f40:	85ca                	mv	a1,s2
    80003f42:	4088                	lw	a0,0(s1)
    80003f44:	da8fe0ef          	jal	800024ec <ialloc>
    80003f48:	892a                	mv	s2,a0
    80003f4a:	cd15                	beqz	a0,80003f86 <create+0xc6>
  ilock(ip);
    80003f4c:	f10fe0ef          	jal	8000265c <ilock>
  ip->major = major;
    80003f50:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80003f54:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80003f58:	4785                	li	a5,1
    80003f5a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80003f5e:	854a                	mv	a0,s2
    80003f60:	e48fe0ef          	jal	800025a8 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80003f64:	4705                	li	a4,1
    80003f66:	02ea0463          	beq	s4,a4,80003f8e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80003f6a:	00492603          	lw	a2,4(s2)
    80003f6e:	fb040593          	addi	a1,s0,-80
    80003f72:	8526                	mv	a0,s1
    80003f74:	e6dfe0ef          	jal	80002de0 <dirlink>
    80003f78:	06054263          	bltz	a0,80003fdc <create+0x11c>
  iunlockput(dp);
    80003f7c:	8526                	mv	a0,s1
    80003f7e:	8ebfe0ef          	jal	80002868 <iunlockput>
  return ip;
    80003f82:	89ca                	mv	s3,s2
    80003f84:	bf71                	j	80003f20 <create+0x60>
    iunlockput(dp);
    80003f86:	8526                	mv	a0,s1
    80003f88:	8e1fe0ef          	jal	80002868 <iunlockput>
    return 0;
    80003f8c:	bf51                	j	80003f20 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80003f8e:	00492603          	lw	a2,4(s2)
    80003f92:	00003597          	auipc	a1,0x3
    80003f96:	5ce58593          	addi	a1,a1,1486 # 80007560 <etext+0x560>
    80003f9a:	854a                	mv	a0,s2
    80003f9c:	e45fe0ef          	jal	80002de0 <dirlink>
    80003fa0:	02054e63          	bltz	a0,80003fdc <create+0x11c>
    80003fa4:	40d0                	lw	a2,4(s1)
    80003fa6:	00003597          	auipc	a1,0x3
    80003faa:	5c258593          	addi	a1,a1,1474 # 80007568 <etext+0x568>
    80003fae:	854a                	mv	a0,s2
    80003fb0:	e31fe0ef          	jal	80002de0 <dirlink>
    80003fb4:	02054463          	bltz	a0,80003fdc <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80003fb8:	00492603          	lw	a2,4(s2)
    80003fbc:	fb040593          	addi	a1,s0,-80
    80003fc0:	8526                	mv	a0,s1
    80003fc2:	e1ffe0ef          	jal	80002de0 <dirlink>
    80003fc6:	00054b63          	bltz	a0,80003fdc <create+0x11c>
    dp->nlink++;  // for ".."
    80003fca:	04a4d783          	lhu	a5,74(s1)
    80003fce:	2785                	addiw	a5,a5,1
    80003fd0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	dd2fe0ef          	jal	800025a8 <iupdate>
    80003fda:	b74d                	j	80003f7c <create+0xbc>
  ip->nlink = 0;
    80003fdc:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80003fe0:	854a                	mv	a0,s2
    80003fe2:	dc6fe0ef          	jal	800025a8 <iupdate>
  iunlockput(ip);
    80003fe6:	854a                	mv	a0,s2
    80003fe8:	881fe0ef          	jal	80002868 <iunlockput>
  iunlockput(dp);
    80003fec:	8526                	mv	a0,s1
    80003fee:	87bfe0ef          	jal	80002868 <iunlockput>
  return 0;
    80003ff2:	b73d                	j	80003f20 <create+0x60>
    return 0;
    80003ff4:	89aa                	mv	s3,a0
    80003ff6:	b72d                	j	80003f20 <create+0x60>

0000000080003ff8 <sys_dup>:
{
    80003ff8:	7179                	addi	sp,sp,-48
    80003ffa:	f406                	sd	ra,40(sp)
    80003ffc:	f022                	sd	s0,32(sp)
    80003ffe:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004000:	fd840613          	addi	a2,s0,-40
    80004004:	4581                	li	a1,0
    80004006:	4501                	li	a0,0
    80004008:	e1fff0ef          	jal	80003e26 <argfd>
    return -1;
    8000400c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000400e:	02054363          	bltz	a0,80004034 <sys_dup+0x3c>
    80004012:	ec26                	sd	s1,24(sp)
    80004014:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004016:	fd843483          	ld	s1,-40(s0)
    8000401a:	8526                	mv	a0,s1
    8000401c:	e65ff0ef          	jal	80003e80 <fdalloc>
    80004020:	892a                	mv	s2,a0
    return -1;
    80004022:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004024:	00054d63          	bltz	a0,8000403e <sys_dup+0x46>
  filedup(f);
    80004028:	8526                	mv	a0,s1
    8000402a:	c1cff0ef          	jal	80003446 <filedup>
  return fd;
    8000402e:	87ca                	mv	a5,s2
    80004030:	64e2                	ld	s1,24(sp)
    80004032:	6942                	ld	s2,16(sp)
}
    80004034:	853e                	mv	a0,a5
    80004036:	70a2                	ld	ra,40(sp)
    80004038:	7402                	ld	s0,32(sp)
    8000403a:	6145                	addi	sp,sp,48
    8000403c:	8082                	ret
    8000403e:	64e2                	ld	s1,24(sp)
    80004040:	6942                	ld	s2,16(sp)
    80004042:	bfcd                	j	80004034 <sys_dup+0x3c>

0000000080004044 <sys_read>:
{
    80004044:	7179                	addi	sp,sp,-48
    80004046:	f406                	sd	ra,40(sp)
    80004048:	f022                	sd	s0,32(sp)
    8000404a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000404c:	fd840593          	addi	a1,s0,-40
    80004050:	4505                	li	a0,1
    80004052:	c69fd0ef          	jal	80001cba <argaddr>
  argint(2, &n);
    80004056:	fe440593          	addi	a1,s0,-28
    8000405a:	4509                	li	a0,2
    8000405c:	c43fd0ef          	jal	80001c9e <argint>
  if(argfd(0, 0, &f) < 0)
    80004060:	fe840613          	addi	a2,s0,-24
    80004064:	4581                	li	a1,0
    80004066:	4501                	li	a0,0
    80004068:	dbfff0ef          	jal	80003e26 <argfd>
    8000406c:	87aa                	mv	a5,a0
    return -1;
    8000406e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004070:	0007ca63          	bltz	a5,80004084 <sys_read+0x40>
  return fileread(f, p, n);
    80004074:	fe442603          	lw	a2,-28(s0)
    80004078:	fd843583          	ld	a1,-40(s0)
    8000407c:	fe843503          	ld	a0,-24(s0)
    80004080:	d30ff0ef          	jal	800035b0 <fileread>
}
    80004084:	70a2                	ld	ra,40(sp)
    80004086:	7402                	ld	s0,32(sp)
    80004088:	6145                	addi	sp,sp,48
    8000408a:	8082                	ret

000000008000408c <sys_write>:
{
    8000408c:	7179                	addi	sp,sp,-48
    8000408e:	f406                	sd	ra,40(sp)
    80004090:	f022                	sd	s0,32(sp)
    80004092:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004094:	fd840593          	addi	a1,s0,-40
    80004098:	4505                	li	a0,1
    8000409a:	c21fd0ef          	jal	80001cba <argaddr>
  argint(2, &n);
    8000409e:	fe440593          	addi	a1,s0,-28
    800040a2:	4509                	li	a0,2
    800040a4:	bfbfd0ef          	jal	80001c9e <argint>
  if(argfd(0, 0, &f) < 0)
    800040a8:	fe840613          	addi	a2,s0,-24
    800040ac:	4581                	li	a1,0
    800040ae:	4501                	li	a0,0
    800040b0:	d77ff0ef          	jal	80003e26 <argfd>
    800040b4:	87aa                	mv	a5,a0
    return -1;
    800040b6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800040b8:	0007ca63          	bltz	a5,800040cc <sys_write+0x40>
  return filewrite(f, p, n);
    800040bc:	fe442603          	lw	a2,-28(s0)
    800040c0:	fd843583          	ld	a1,-40(s0)
    800040c4:	fe843503          	ld	a0,-24(s0)
    800040c8:	dacff0ef          	jal	80003674 <filewrite>
}
    800040cc:	70a2                	ld	ra,40(sp)
    800040ce:	7402                	ld	s0,32(sp)
    800040d0:	6145                	addi	sp,sp,48
    800040d2:	8082                	ret

00000000800040d4 <sys_close>:
{
    800040d4:	1101                	addi	sp,sp,-32
    800040d6:	ec06                	sd	ra,24(sp)
    800040d8:	e822                	sd	s0,16(sp)
    800040da:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800040dc:	fe040613          	addi	a2,s0,-32
    800040e0:	fec40593          	addi	a1,s0,-20
    800040e4:	4501                	li	a0,0
    800040e6:	d41ff0ef          	jal	80003e26 <argfd>
    return -1;
    800040ea:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800040ec:	02054163          	bltz	a0,8000410e <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    800040f0:	ca5fc0ef          	jal	80000d94 <myproc>
    800040f4:	fec42783          	lw	a5,-20(s0)
    800040f8:	078e                	slli	a5,a5,0x3
    800040fa:	0d078793          	addi	a5,a5,208
    800040fe:	953e                	add	a0,a0,a5
    80004100:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004104:	fe043503          	ld	a0,-32(s0)
    80004108:	b84ff0ef          	jal	8000348c <fileclose>
  return 0;
    8000410c:	4781                	li	a5,0
}
    8000410e:	853e                	mv	a0,a5
    80004110:	60e2                	ld	ra,24(sp)
    80004112:	6442                	ld	s0,16(sp)
    80004114:	6105                	addi	sp,sp,32
    80004116:	8082                	ret

0000000080004118 <sys_fstat>:
{
    80004118:	1101                	addi	sp,sp,-32
    8000411a:	ec06                	sd	ra,24(sp)
    8000411c:	e822                	sd	s0,16(sp)
    8000411e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004120:	fe040593          	addi	a1,s0,-32
    80004124:	4505                	li	a0,1
    80004126:	b95fd0ef          	jal	80001cba <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000412a:	fe840613          	addi	a2,s0,-24
    8000412e:	4581                	li	a1,0
    80004130:	4501                	li	a0,0
    80004132:	cf5ff0ef          	jal	80003e26 <argfd>
    80004136:	87aa                	mv	a5,a0
    return -1;
    80004138:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000413a:	0007c863          	bltz	a5,8000414a <sys_fstat+0x32>
  return filestat(f, st);
    8000413e:	fe043583          	ld	a1,-32(s0)
    80004142:	fe843503          	ld	a0,-24(s0)
    80004146:	c08ff0ef          	jal	8000354e <filestat>
}
    8000414a:	60e2                	ld	ra,24(sp)
    8000414c:	6442                	ld	s0,16(sp)
    8000414e:	6105                	addi	sp,sp,32
    80004150:	8082                	ret

0000000080004152 <sys_link>:
{
    80004152:	7169                	addi	sp,sp,-304
    80004154:	f606                	sd	ra,296(sp)
    80004156:	f222                	sd	s0,288(sp)
    80004158:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000415a:	08000613          	li	a2,128
    8000415e:	ed040593          	addi	a1,s0,-304
    80004162:	4501                	li	a0,0
    80004164:	b73fd0ef          	jal	80001cd6 <argstr>
    return -1;
    80004168:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000416a:	0c054e63          	bltz	a0,80004246 <sys_link+0xf4>
    8000416e:	08000613          	li	a2,128
    80004172:	f5040593          	addi	a1,s0,-176
    80004176:	4505                	li	a0,1
    80004178:	b5ffd0ef          	jal	80001cd6 <argstr>
    return -1;
    8000417c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000417e:	0c054463          	bltz	a0,80004246 <sys_link+0xf4>
    80004182:	ee26                	sd	s1,280(sp)
  begin_op();
    80004184:	ee5fe0ef          	jal	80003068 <begin_op>
  if((ip = namei(old)) == 0){
    80004188:	ed040513          	addi	a0,s0,-304
    8000418c:	cfffe0ef          	jal	80002e8a <namei>
    80004190:	84aa                	mv	s1,a0
    80004192:	c53d                	beqz	a0,80004200 <sys_link+0xae>
  ilock(ip);
    80004194:	cc8fe0ef          	jal	8000265c <ilock>
  if(ip->type == T_DIR){
    80004198:	04449703          	lh	a4,68(s1)
    8000419c:	4785                	li	a5,1
    8000419e:	06f70663          	beq	a4,a5,8000420a <sys_link+0xb8>
    800041a2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800041a4:	04a4d783          	lhu	a5,74(s1)
    800041a8:	2785                	addiw	a5,a5,1
    800041aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800041ae:	8526                	mv	a0,s1
    800041b0:	bf8fe0ef          	jal	800025a8 <iupdate>
  iunlock(ip);
    800041b4:	8526                	mv	a0,s1
    800041b6:	d54fe0ef          	jal	8000270a <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800041ba:	fd040593          	addi	a1,s0,-48
    800041be:	f5040513          	addi	a0,s0,-176
    800041c2:	ce3fe0ef          	jal	80002ea4 <nameiparent>
    800041c6:	892a                	mv	s2,a0
    800041c8:	cd21                	beqz	a0,80004220 <sys_link+0xce>
  ilock(dp);
    800041ca:	c92fe0ef          	jal	8000265c <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800041ce:	854a                	mv	a0,s2
    800041d0:	00092703          	lw	a4,0(s2)
    800041d4:	409c                	lw	a5,0(s1)
    800041d6:	04f71263          	bne	a4,a5,8000421a <sys_link+0xc8>
    800041da:	40d0                	lw	a2,4(s1)
    800041dc:	fd040593          	addi	a1,s0,-48
    800041e0:	c01fe0ef          	jal	80002de0 <dirlink>
    800041e4:	02054b63          	bltz	a0,8000421a <sys_link+0xc8>
  iunlockput(dp);
    800041e8:	854a                	mv	a0,s2
    800041ea:	e7efe0ef          	jal	80002868 <iunlockput>
  iput(ip);
    800041ee:	8526                	mv	a0,s1
    800041f0:	deefe0ef          	jal	800027de <iput>
  end_op();
    800041f4:	ee5fe0ef          	jal	800030d8 <end_op>
  return 0;
    800041f8:	4781                	li	a5,0
    800041fa:	64f2                	ld	s1,280(sp)
    800041fc:	6952                	ld	s2,272(sp)
    800041fe:	a0a1                	j	80004246 <sys_link+0xf4>
    end_op();
    80004200:	ed9fe0ef          	jal	800030d8 <end_op>
    return -1;
    80004204:	57fd                	li	a5,-1
    80004206:	64f2                	ld	s1,280(sp)
    80004208:	a83d                	j	80004246 <sys_link+0xf4>
    iunlockput(ip);
    8000420a:	8526                	mv	a0,s1
    8000420c:	e5cfe0ef          	jal	80002868 <iunlockput>
    end_op();
    80004210:	ec9fe0ef          	jal	800030d8 <end_op>
    return -1;
    80004214:	57fd                	li	a5,-1
    80004216:	64f2                	ld	s1,280(sp)
    80004218:	a03d                	j	80004246 <sys_link+0xf4>
    iunlockput(dp);
    8000421a:	854a                	mv	a0,s2
    8000421c:	e4cfe0ef          	jal	80002868 <iunlockput>
  ilock(ip);
    80004220:	8526                	mv	a0,s1
    80004222:	c3afe0ef          	jal	8000265c <ilock>
  ip->nlink--;
    80004226:	04a4d783          	lhu	a5,74(s1)
    8000422a:	37fd                	addiw	a5,a5,-1
    8000422c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004230:	8526                	mv	a0,s1
    80004232:	b76fe0ef          	jal	800025a8 <iupdate>
  iunlockput(ip);
    80004236:	8526                	mv	a0,s1
    80004238:	e30fe0ef          	jal	80002868 <iunlockput>
  end_op();
    8000423c:	e9dfe0ef          	jal	800030d8 <end_op>
  return -1;
    80004240:	57fd                	li	a5,-1
    80004242:	64f2                	ld	s1,280(sp)
    80004244:	6952                	ld	s2,272(sp)
}
    80004246:	853e                	mv	a0,a5
    80004248:	70b2                	ld	ra,296(sp)
    8000424a:	7412                	ld	s0,288(sp)
    8000424c:	6155                	addi	sp,sp,304
    8000424e:	8082                	ret

0000000080004250 <sys_unlink>:
{
    80004250:	7151                	addi	sp,sp,-240
    80004252:	f586                	sd	ra,232(sp)
    80004254:	f1a2                	sd	s0,224(sp)
    80004256:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004258:	08000613          	li	a2,128
    8000425c:	f3040593          	addi	a1,s0,-208
    80004260:	4501                	li	a0,0
    80004262:	a75fd0ef          	jal	80001cd6 <argstr>
    80004266:	14054d63          	bltz	a0,800043c0 <sys_unlink+0x170>
    8000426a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000426c:	dfdfe0ef          	jal	80003068 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004270:	fb040593          	addi	a1,s0,-80
    80004274:	f3040513          	addi	a0,s0,-208
    80004278:	c2dfe0ef          	jal	80002ea4 <nameiparent>
    8000427c:	84aa                	mv	s1,a0
    8000427e:	c955                	beqz	a0,80004332 <sys_unlink+0xe2>
  ilock(dp);
    80004280:	bdcfe0ef          	jal	8000265c <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004284:	00003597          	auipc	a1,0x3
    80004288:	2dc58593          	addi	a1,a1,732 # 80007560 <etext+0x560>
    8000428c:	fb040513          	addi	a0,s0,-80
    80004290:	951fe0ef          	jal	80002be0 <namecmp>
    80004294:	10050b63          	beqz	a0,800043aa <sys_unlink+0x15a>
    80004298:	00003597          	auipc	a1,0x3
    8000429c:	2d058593          	addi	a1,a1,720 # 80007568 <etext+0x568>
    800042a0:	fb040513          	addi	a0,s0,-80
    800042a4:	93dfe0ef          	jal	80002be0 <namecmp>
    800042a8:	10050163          	beqz	a0,800043aa <sys_unlink+0x15a>
    800042ac:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800042ae:	f2c40613          	addi	a2,s0,-212
    800042b2:	fb040593          	addi	a1,s0,-80
    800042b6:	8526                	mv	a0,s1
    800042b8:	93ffe0ef          	jal	80002bf6 <dirlookup>
    800042bc:	892a                	mv	s2,a0
    800042be:	0e050563          	beqz	a0,800043a8 <sys_unlink+0x158>
    800042c2:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800042c4:	b98fe0ef          	jal	8000265c <ilock>
  if(ip->nlink < 1)
    800042c8:	04a91783          	lh	a5,74(s2)
    800042cc:	06f05863          	blez	a5,8000433c <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800042d0:	04491703          	lh	a4,68(s2)
    800042d4:	4785                	li	a5,1
    800042d6:	06f70963          	beq	a4,a5,80004348 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800042da:	fc040993          	addi	s3,s0,-64
    800042de:	4641                	li	a2,16
    800042e0:	4581                	li	a1,0
    800042e2:	854e                	mv	a0,s3
    800042e4:	e7bfb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800042e8:	4741                	li	a4,16
    800042ea:	f2c42683          	lw	a3,-212(s0)
    800042ee:	864e                	mv	a2,s3
    800042f0:	4581                	li	a1,0
    800042f2:	8526                	mv	a0,s1
    800042f4:	fecfe0ef          	jal	80002ae0 <writei>
    800042f8:	47c1                	li	a5,16
    800042fa:	08f51863          	bne	a0,a5,8000438a <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    800042fe:	04491703          	lh	a4,68(s2)
    80004302:	4785                	li	a5,1
    80004304:	08f70963          	beq	a4,a5,80004396 <sys_unlink+0x146>
  iunlockput(dp);
    80004308:	8526                	mv	a0,s1
    8000430a:	d5efe0ef          	jal	80002868 <iunlockput>
  ip->nlink--;
    8000430e:	04a95783          	lhu	a5,74(s2)
    80004312:	37fd                	addiw	a5,a5,-1
    80004314:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004318:	854a                	mv	a0,s2
    8000431a:	a8efe0ef          	jal	800025a8 <iupdate>
  iunlockput(ip);
    8000431e:	854a                	mv	a0,s2
    80004320:	d48fe0ef          	jal	80002868 <iunlockput>
  end_op();
    80004324:	db5fe0ef          	jal	800030d8 <end_op>
  return 0;
    80004328:	4501                	li	a0,0
    8000432a:	64ee                	ld	s1,216(sp)
    8000432c:	694e                	ld	s2,208(sp)
    8000432e:	69ae                	ld	s3,200(sp)
    80004330:	a061                	j	800043b8 <sys_unlink+0x168>
    end_op();
    80004332:	da7fe0ef          	jal	800030d8 <end_op>
    return -1;
    80004336:	557d                	li	a0,-1
    80004338:	64ee                	ld	s1,216(sp)
    8000433a:	a8bd                	j	800043b8 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000433c:	00003517          	auipc	a0,0x3
    80004340:	23450513          	addi	a0,a0,564 # 80007570 <etext+0x570>
    80004344:	2f2010ef          	jal	80005636 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004348:	04c92703          	lw	a4,76(s2)
    8000434c:	02000793          	li	a5,32
    80004350:	f8e7f5e3          	bgeu	a5,a4,800042da <sys_unlink+0x8a>
    80004354:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004356:	4741                	li	a4,16
    80004358:	86ce                	mv	a3,s3
    8000435a:	f1840613          	addi	a2,s0,-232
    8000435e:	4581                	li	a1,0
    80004360:	854a                	mv	a0,s2
    80004362:	e8cfe0ef          	jal	800029ee <readi>
    80004366:	47c1                	li	a5,16
    80004368:	00f51b63          	bne	a0,a5,8000437e <sys_unlink+0x12e>
    if(de.inum != 0)
    8000436c:	f1845783          	lhu	a5,-232(s0)
    80004370:	ebb1                	bnez	a5,800043c4 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004372:	29c1                	addiw	s3,s3,16
    80004374:	04c92783          	lw	a5,76(s2)
    80004378:	fcf9efe3          	bltu	s3,a5,80004356 <sys_unlink+0x106>
    8000437c:	bfb9                	j	800042da <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000437e:	00003517          	auipc	a0,0x3
    80004382:	20a50513          	addi	a0,a0,522 # 80007588 <etext+0x588>
    80004386:	2b0010ef          	jal	80005636 <panic>
    panic("unlink: writei");
    8000438a:	00003517          	auipc	a0,0x3
    8000438e:	21650513          	addi	a0,a0,534 # 800075a0 <etext+0x5a0>
    80004392:	2a4010ef          	jal	80005636 <panic>
    dp->nlink--;
    80004396:	04a4d783          	lhu	a5,74(s1)
    8000439a:	37fd                	addiw	a5,a5,-1
    8000439c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800043a0:	8526                	mv	a0,s1
    800043a2:	a06fe0ef          	jal	800025a8 <iupdate>
    800043a6:	b78d                	j	80004308 <sys_unlink+0xb8>
    800043a8:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800043aa:	8526                	mv	a0,s1
    800043ac:	cbcfe0ef          	jal	80002868 <iunlockput>
  end_op();
    800043b0:	d29fe0ef          	jal	800030d8 <end_op>
  return -1;
    800043b4:	557d                	li	a0,-1
    800043b6:	64ee                	ld	s1,216(sp)
}
    800043b8:	70ae                	ld	ra,232(sp)
    800043ba:	740e                	ld	s0,224(sp)
    800043bc:	616d                	addi	sp,sp,240
    800043be:	8082                	ret
    return -1;
    800043c0:	557d                	li	a0,-1
    800043c2:	bfdd                	j	800043b8 <sys_unlink+0x168>
    iunlockput(ip);
    800043c4:	854a                	mv	a0,s2
    800043c6:	ca2fe0ef          	jal	80002868 <iunlockput>
    goto bad;
    800043ca:	694e                	ld	s2,208(sp)
    800043cc:	69ae                	ld	s3,200(sp)
    800043ce:	bff1                	j	800043aa <sys_unlink+0x15a>

00000000800043d0 <sys_open>:

uint64
sys_open(void)
{
    800043d0:	7131                	addi	sp,sp,-192
    800043d2:	fd06                	sd	ra,184(sp)
    800043d4:	f922                	sd	s0,176(sp)
    800043d6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800043d8:	f4c40593          	addi	a1,s0,-180
    800043dc:	4505                	li	a0,1
    800043de:	8c1fd0ef          	jal	80001c9e <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043e2:	08000613          	li	a2,128
    800043e6:	f5040593          	addi	a1,s0,-176
    800043ea:	4501                	li	a0,0
    800043ec:	8ebfd0ef          	jal	80001cd6 <argstr>
    800043f0:	87aa                	mv	a5,a0
    return -1;
    800043f2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800043f4:	0a07c363          	bltz	a5,8000449a <sys_open+0xca>
    800043f8:	f526                	sd	s1,168(sp)

  begin_op();
    800043fa:	c6ffe0ef          	jal	80003068 <begin_op>

  if(omode & O_CREATE){
    800043fe:	f4c42783          	lw	a5,-180(s0)
    80004402:	2007f793          	andi	a5,a5,512
    80004406:	c3dd                	beqz	a5,800044ac <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004408:	4681                	li	a3,0
    8000440a:	4601                	li	a2,0
    8000440c:	4589                	li	a1,2
    8000440e:	f5040513          	addi	a0,s0,-176
    80004412:	aafff0ef          	jal	80003ec0 <create>
    80004416:	84aa                	mv	s1,a0
    if(ip == 0){
    80004418:	c549                	beqz	a0,800044a2 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000441a:	04449703          	lh	a4,68(s1)
    8000441e:	478d                	li	a5,3
    80004420:	00f71763          	bne	a4,a5,8000442e <sys_open+0x5e>
    80004424:	0464d703          	lhu	a4,70(s1)
    80004428:	47a5                	li	a5,9
    8000442a:	0ae7ee63          	bltu	a5,a4,800044e6 <sys_open+0x116>
    8000442e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004430:	fb9fe0ef          	jal	800033e8 <filealloc>
    80004434:	892a                	mv	s2,a0
    80004436:	c561                	beqz	a0,800044fe <sys_open+0x12e>
    80004438:	ed4e                	sd	s3,152(sp)
    8000443a:	a47ff0ef          	jal	80003e80 <fdalloc>
    8000443e:	89aa                	mv	s3,a0
    80004440:	0a054b63          	bltz	a0,800044f6 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004444:	04449703          	lh	a4,68(s1)
    80004448:	478d                	li	a5,3
    8000444a:	0cf70363          	beq	a4,a5,80004510 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000444e:	4789                	li	a5,2
    80004450:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004454:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004458:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000445c:	f4c42783          	lw	a5,-180(s0)
    80004460:	0017f713          	andi	a4,a5,1
    80004464:	00174713          	xori	a4,a4,1
    80004468:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000446c:	0037f713          	andi	a4,a5,3
    80004470:	00e03733          	snez	a4,a4
    80004474:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004478:	4007f793          	andi	a5,a5,1024
    8000447c:	c791                	beqz	a5,80004488 <sys_open+0xb8>
    8000447e:	04449703          	lh	a4,68(s1)
    80004482:	4789                	li	a5,2
    80004484:	08f70d63          	beq	a4,a5,8000451e <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004488:	8526                	mv	a0,s1
    8000448a:	a80fe0ef          	jal	8000270a <iunlock>
  end_op();
    8000448e:	c4bfe0ef          	jal	800030d8 <end_op>

  return fd;
    80004492:	854e                	mv	a0,s3
    80004494:	74aa                	ld	s1,168(sp)
    80004496:	790a                	ld	s2,160(sp)
    80004498:	69ea                	ld	s3,152(sp)
}
    8000449a:	70ea                	ld	ra,184(sp)
    8000449c:	744a                	ld	s0,176(sp)
    8000449e:	6129                	addi	sp,sp,192
    800044a0:	8082                	ret
      end_op();
    800044a2:	c37fe0ef          	jal	800030d8 <end_op>
      return -1;
    800044a6:	557d                	li	a0,-1
    800044a8:	74aa                	ld	s1,168(sp)
    800044aa:	bfc5                	j	8000449a <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800044ac:	f5040513          	addi	a0,s0,-176
    800044b0:	9dbfe0ef          	jal	80002e8a <namei>
    800044b4:	84aa                	mv	s1,a0
    800044b6:	c11d                	beqz	a0,800044dc <sys_open+0x10c>
    ilock(ip);
    800044b8:	9a4fe0ef          	jal	8000265c <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800044bc:	04449703          	lh	a4,68(s1)
    800044c0:	4785                	li	a5,1
    800044c2:	f4f71ce3          	bne	a4,a5,8000441a <sys_open+0x4a>
    800044c6:	f4c42783          	lw	a5,-180(s0)
    800044ca:	d3b5                	beqz	a5,8000442e <sys_open+0x5e>
      iunlockput(ip);
    800044cc:	8526                	mv	a0,s1
    800044ce:	b9afe0ef          	jal	80002868 <iunlockput>
      end_op();
    800044d2:	c07fe0ef          	jal	800030d8 <end_op>
      return -1;
    800044d6:	557d                	li	a0,-1
    800044d8:	74aa                	ld	s1,168(sp)
    800044da:	b7c1                	j	8000449a <sys_open+0xca>
      end_op();
    800044dc:	bfdfe0ef          	jal	800030d8 <end_op>
      return -1;
    800044e0:	557d                	li	a0,-1
    800044e2:	74aa                	ld	s1,168(sp)
    800044e4:	bf5d                	j	8000449a <sys_open+0xca>
    iunlockput(ip);
    800044e6:	8526                	mv	a0,s1
    800044e8:	b80fe0ef          	jal	80002868 <iunlockput>
    end_op();
    800044ec:	bedfe0ef          	jal	800030d8 <end_op>
    return -1;
    800044f0:	557d                	li	a0,-1
    800044f2:	74aa                	ld	s1,168(sp)
    800044f4:	b75d                	j	8000449a <sys_open+0xca>
      fileclose(f);
    800044f6:	854a                	mv	a0,s2
    800044f8:	f95fe0ef          	jal	8000348c <fileclose>
    800044fc:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800044fe:	8526                	mv	a0,s1
    80004500:	b68fe0ef          	jal	80002868 <iunlockput>
    end_op();
    80004504:	bd5fe0ef          	jal	800030d8 <end_op>
    return -1;
    80004508:	557d                	li	a0,-1
    8000450a:	74aa                	ld	s1,168(sp)
    8000450c:	790a                	ld	s2,160(sp)
    8000450e:	b771                	j	8000449a <sys_open+0xca>
    f->type = FD_DEVICE;
    80004510:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004514:	04649783          	lh	a5,70(s1)
    80004518:	02f91223          	sh	a5,36(s2)
    8000451c:	bf35                	j	80004458 <sys_open+0x88>
    itrunc(ip);
    8000451e:	8526                	mv	a0,s1
    80004520:	a2afe0ef          	jal	8000274a <itrunc>
    80004524:	b795                	j	80004488 <sys_open+0xb8>

0000000080004526 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004526:	7175                	addi	sp,sp,-144
    80004528:	e506                	sd	ra,136(sp)
    8000452a:	e122                	sd	s0,128(sp)
    8000452c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000452e:	b3bfe0ef          	jal	80003068 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004532:	08000613          	li	a2,128
    80004536:	f7040593          	addi	a1,s0,-144
    8000453a:	4501                	li	a0,0
    8000453c:	f9afd0ef          	jal	80001cd6 <argstr>
    80004540:	02054363          	bltz	a0,80004566 <sys_mkdir+0x40>
    80004544:	4681                	li	a3,0
    80004546:	4601                	li	a2,0
    80004548:	4585                	li	a1,1
    8000454a:	f7040513          	addi	a0,s0,-144
    8000454e:	973ff0ef          	jal	80003ec0 <create>
    80004552:	c911                	beqz	a0,80004566 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004554:	b14fe0ef          	jal	80002868 <iunlockput>
  end_op();
    80004558:	b81fe0ef          	jal	800030d8 <end_op>
  return 0;
    8000455c:	4501                	li	a0,0
}
    8000455e:	60aa                	ld	ra,136(sp)
    80004560:	640a                	ld	s0,128(sp)
    80004562:	6149                	addi	sp,sp,144
    80004564:	8082                	ret
    end_op();
    80004566:	b73fe0ef          	jal	800030d8 <end_op>
    return -1;
    8000456a:	557d                	li	a0,-1
    8000456c:	bfcd                	j	8000455e <sys_mkdir+0x38>

000000008000456e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000456e:	7135                	addi	sp,sp,-160
    80004570:	ed06                	sd	ra,152(sp)
    80004572:	e922                	sd	s0,144(sp)
    80004574:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004576:	af3fe0ef          	jal	80003068 <begin_op>
  argint(1, &major);
    8000457a:	f6c40593          	addi	a1,s0,-148
    8000457e:	4505                	li	a0,1
    80004580:	f1efd0ef          	jal	80001c9e <argint>
  argint(2, &minor);
    80004584:	f6840593          	addi	a1,s0,-152
    80004588:	4509                	li	a0,2
    8000458a:	f14fd0ef          	jal	80001c9e <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000458e:	08000613          	li	a2,128
    80004592:	f7040593          	addi	a1,s0,-144
    80004596:	4501                	li	a0,0
    80004598:	f3efd0ef          	jal	80001cd6 <argstr>
    8000459c:	02054563          	bltz	a0,800045c6 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800045a0:	f6841683          	lh	a3,-152(s0)
    800045a4:	f6c41603          	lh	a2,-148(s0)
    800045a8:	458d                	li	a1,3
    800045aa:	f7040513          	addi	a0,s0,-144
    800045ae:	913ff0ef          	jal	80003ec0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800045b2:	c911                	beqz	a0,800045c6 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800045b4:	ab4fe0ef          	jal	80002868 <iunlockput>
  end_op();
    800045b8:	b21fe0ef          	jal	800030d8 <end_op>
  return 0;
    800045bc:	4501                	li	a0,0
}
    800045be:	60ea                	ld	ra,152(sp)
    800045c0:	644a                	ld	s0,144(sp)
    800045c2:	610d                	addi	sp,sp,160
    800045c4:	8082                	ret
    end_op();
    800045c6:	b13fe0ef          	jal	800030d8 <end_op>
    return -1;
    800045ca:	557d                	li	a0,-1
    800045cc:	bfcd                	j	800045be <sys_mknod+0x50>

00000000800045ce <sys_chdir>:

uint64
sys_chdir(void)
{
    800045ce:	7135                	addi	sp,sp,-160
    800045d0:	ed06                	sd	ra,152(sp)
    800045d2:	e922                	sd	s0,144(sp)
    800045d4:	e14a                	sd	s2,128(sp)
    800045d6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800045d8:	fbcfc0ef          	jal	80000d94 <myproc>
    800045dc:	892a                	mv	s2,a0
  
  begin_op();
    800045de:	a8bfe0ef          	jal	80003068 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800045e2:	08000613          	li	a2,128
    800045e6:	f6040593          	addi	a1,s0,-160
    800045ea:	4501                	li	a0,0
    800045ec:	eeafd0ef          	jal	80001cd6 <argstr>
    800045f0:	04054363          	bltz	a0,80004636 <sys_chdir+0x68>
    800045f4:	e526                	sd	s1,136(sp)
    800045f6:	f6040513          	addi	a0,s0,-160
    800045fa:	891fe0ef          	jal	80002e8a <namei>
    800045fe:	84aa                	mv	s1,a0
    80004600:	c915                	beqz	a0,80004634 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004602:	85afe0ef          	jal	8000265c <ilock>
  if(ip->type != T_DIR){
    80004606:	04449703          	lh	a4,68(s1)
    8000460a:	4785                	li	a5,1
    8000460c:	02f71963          	bne	a4,a5,8000463e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004610:	8526                	mv	a0,s1
    80004612:	8f8fe0ef          	jal	8000270a <iunlock>
  iput(p->cwd);
    80004616:	15093503          	ld	a0,336(s2)
    8000461a:	9c4fe0ef          	jal	800027de <iput>
  end_op();
    8000461e:	abbfe0ef          	jal	800030d8 <end_op>
  p->cwd = ip;
    80004622:	14993823          	sd	s1,336(s2)
  return 0;
    80004626:	4501                	li	a0,0
    80004628:	64aa                	ld	s1,136(sp)
}
    8000462a:	60ea                	ld	ra,152(sp)
    8000462c:	644a                	ld	s0,144(sp)
    8000462e:	690a                	ld	s2,128(sp)
    80004630:	610d                	addi	sp,sp,160
    80004632:	8082                	ret
    80004634:	64aa                	ld	s1,136(sp)
    end_op();
    80004636:	aa3fe0ef          	jal	800030d8 <end_op>
    return -1;
    8000463a:	557d                	li	a0,-1
    8000463c:	b7fd                	j	8000462a <sys_chdir+0x5c>
    iunlockput(ip);
    8000463e:	8526                	mv	a0,s1
    80004640:	a28fe0ef          	jal	80002868 <iunlockput>
    end_op();
    80004644:	a95fe0ef          	jal	800030d8 <end_op>
    return -1;
    80004648:	557d                	li	a0,-1
    8000464a:	64aa                	ld	s1,136(sp)
    8000464c:	bff9                	j	8000462a <sys_chdir+0x5c>

000000008000464e <sys_exec>:

uint64
sys_exec(void)
{
    8000464e:	7105                	addi	sp,sp,-480
    80004650:	ef86                	sd	ra,472(sp)
    80004652:	eba2                	sd	s0,464(sp)
    80004654:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004656:	e2840593          	addi	a1,s0,-472
    8000465a:	4505                	li	a0,1
    8000465c:	e5efd0ef          	jal	80001cba <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004660:	08000613          	li	a2,128
    80004664:	f3040593          	addi	a1,s0,-208
    80004668:	4501                	li	a0,0
    8000466a:	e6cfd0ef          	jal	80001cd6 <argstr>
    8000466e:	87aa                	mv	a5,a0
    return -1;
    80004670:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004672:	0e07c063          	bltz	a5,80004752 <sys_exec+0x104>
    80004676:	e7a6                	sd	s1,456(sp)
    80004678:	e3ca                	sd	s2,448(sp)
    8000467a:	ff4e                	sd	s3,440(sp)
    8000467c:	fb52                	sd	s4,432(sp)
    8000467e:	f756                	sd	s5,424(sp)
    80004680:	f35a                	sd	s6,416(sp)
    80004682:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004684:	e3040a13          	addi	s4,s0,-464
    80004688:	10000613          	li	a2,256
    8000468c:	4581                	li	a1,0
    8000468e:	8552                	mv	a0,s4
    80004690:	acffb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004694:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004696:	89d2                	mv	s3,s4
    80004698:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000469a:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000469e:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800046a0:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800046a4:	00391513          	slli	a0,s2,0x3
    800046a8:	85d6                	mv	a1,s5
    800046aa:	e2843783          	ld	a5,-472(s0)
    800046ae:	953e                	add	a0,a0,a5
    800046b0:	d64fd0ef          	jal	80001c14 <fetchaddr>
    800046b4:	02054663          	bltz	a0,800046e0 <sys_exec+0x92>
    if(uarg == 0){
    800046b8:	e2043783          	ld	a5,-480(s0)
    800046bc:	c7a1                	beqz	a5,80004704 <sys_exec+0xb6>
    argv[i] = kalloc();
    800046be:	a47fb0ef          	jal	80000104 <kalloc>
    800046c2:	85aa                	mv	a1,a0
    800046c4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800046c8:	cd01                	beqz	a0,800046e0 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800046ca:	865a                	mv	a2,s6
    800046cc:	e2043503          	ld	a0,-480(s0)
    800046d0:	d8efd0ef          	jal	80001c5e <fetchstr>
    800046d4:	00054663          	bltz	a0,800046e0 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800046d8:	0905                	addi	s2,s2,1
    800046da:	09a1                	addi	s3,s3,8
    800046dc:	fd7914e3          	bne	s2,s7,800046a4 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046e0:	100a0a13          	addi	s4,s4,256
    800046e4:	6088                	ld	a0,0(s1)
    800046e6:	cd31                	beqz	a0,80004742 <sys_exec+0xf4>
    kfree(argv[i]);
    800046e8:	935fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800046ec:	04a1                	addi	s1,s1,8
    800046ee:	ff449be3          	bne	s1,s4,800046e4 <sys_exec+0x96>
  return -1;
    800046f2:	557d                	li	a0,-1
    800046f4:	64be                	ld	s1,456(sp)
    800046f6:	691e                	ld	s2,448(sp)
    800046f8:	79fa                	ld	s3,440(sp)
    800046fa:	7a5a                	ld	s4,432(sp)
    800046fc:	7aba                	ld	s5,424(sp)
    800046fe:	7b1a                	ld	s6,416(sp)
    80004700:	6bfa                	ld	s7,408(sp)
    80004702:	a881                	j	80004752 <sys_exec+0x104>
      argv[i] = 0;
    80004704:	0009079b          	sext.w	a5,s2
    80004708:	e3040593          	addi	a1,s0,-464
    8000470c:	078e                	slli	a5,a5,0x3
    8000470e:	97ae                	add	a5,a5,a1
    80004710:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004714:	f3040513          	addi	a0,s0,-208
    80004718:	bb6ff0ef          	jal	80003ace <kexec>
    8000471c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000471e:	100a0a13          	addi	s4,s4,256
    80004722:	6088                	ld	a0,0(s1)
    80004724:	c511                	beqz	a0,80004730 <sys_exec+0xe2>
    kfree(argv[i]);
    80004726:	8f7fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000472a:	04a1                	addi	s1,s1,8
    8000472c:	ff449be3          	bne	s1,s4,80004722 <sys_exec+0xd4>
  return ret;
    80004730:	854a                	mv	a0,s2
    80004732:	64be                	ld	s1,456(sp)
    80004734:	691e                	ld	s2,448(sp)
    80004736:	79fa                	ld	s3,440(sp)
    80004738:	7a5a                	ld	s4,432(sp)
    8000473a:	7aba                	ld	s5,424(sp)
    8000473c:	7b1a                	ld	s6,416(sp)
    8000473e:	6bfa                	ld	s7,408(sp)
    80004740:	a809                	j	80004752 <sys_exec+0x104>
  return -1;
    80004742:	557d                	li	a0,-1
    80004744:	64be                	ld	s1,456(sp)
    80004746:	691e                	ld	s2,448(sp)
    80004748:	79fa                	ld	s3,440(sp)
    8000474a:	7a5a                	ld	s4,432(sp)
    8000474c:	7aba                	ld	s5,424(sp)
    8000474e:	7b1a                	ld	s6,416(sp)
    80004750:	6bfa                	ld	s7,408(sp)
}
    80004752:	60fe                	ld	ra,472(sp)
    80004754:	645e                	ld	s0,464(sp)
    80004756:	613d                	addi	sp,sp,480
    80004758:	8082                	ret

000000008000475a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000475a:	7139                	addi	sp,sp,-64
    8000475c:	fc06                	sd	ra,56(sp)
    8000475e:	f822                	sd	s0,48(sp)
    80004760:	f426                	sd	s1,40(sp)
    80004762:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004764:	e30fc0ef          	jal	80000d94 <myproc>
    80004768:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000476a:	fd840593          	addi	a1,s0,-40
    8000476e:	4501                	li	a0,0
    80004770:	d4afd0ef          	jal	80001cba <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004774:	fc840593          	addi	a1,s0,-56
    80004778:	fd040513          	addi	a0,s0,-48
    8000477c:	82cff0ef          	jal	800037a8 <pipealloc>
    return -1;
    80004780:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004782:	0a054763          	bltz	a0,80004830 <sys_pipe+0xd6>
  fd0 = -1;
    80004786:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000478a:	fd043503          	ld	a0,-48(s0)
    8000478e:	ef2ff0ef          	jal	80003e80 <fdalloc>
    80004792:	fca42223          	sw	a0,-60(s0)
    80004796:	08054463          	bltz	a0,8000481e <sys_pipe+0xc4>
    8000479a:	fc843503          	ld	a0,-56(s0)
    8000479e:	ee2ff0ef          	jal	80003e80 <fdalloc>
    800047a2:	fca42023          	sw	a0,-64(s0)
    800047a6:	06054263          	bltz	a0,8000480a <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047aa:	4691                	li	a3,4
    800047ac:	fc440613          	addi	a2,s0,-60
    800047b0:	fd843583          	ld	a1,-40(s0)
    800047b4:	68a8                	ld	a0,80(s1)
    800047b6:	b04fc0ef          	jal	80000aba <copyout>
    800047ba:	00054e63          	bltz	a0,800047d6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800047be:	4691                	li	a3,4
    800047c0:	fc040613          	addi	a2,s0,-64
    800047c4:	fd843583          	ld	a1,-40(s0)
    800047c8:	95b6                	add	a1,a1,a3
    800047ca:	68a8                	ld	a0,80(s1)
    800047cc:	aeefc0ef          	jal	80000aba <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800047d0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800047d2:	04055f63          	bgez	a0,80004830 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800047d6:	fc442783          	lw	a5,-60(s0)
    800047da:	078e                	slli	a5,a5,0x3
    800047dc:	0d078793          	addi	a5,a5,208
    800047e0:	97a6                	add	a5,a5,s1
    800047e2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800047e6:	fc042783          	lw	a5,-64(s0)
    800047ea:	078e                	slli	a5,a5,0x3
    800047ec:	0d078793          	addi	a5,a5,208
    800047f0:	97a6                	add	a5,a5,s1
    800047f2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800047f6:	fd043503          	ld	a0,-48(s0)
    800047fa:	c93fe0ef          	jal	8000348c <fileclose>
    fileclose(wf);
    800047fe:	fc843503          	ld	a0,-56(s0)
    80004802:	c8bfe0ef          	jal	8000348c <fileclose>
    return -1;
    80004806:	57fd                	li	a5,-1
    80004808:	a025                	j	80004830 <sys_pipe+0xd6>
    if(fd0 >= 0)
    8000480a:	fc442783          	lw	a5,-60(s0)
    8000480e:	0007c863          	bltz	a5,8000481e <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004812:	078e                	slli	a5,a5,0x3
    80004814:	0d078793          	addi	a5,a5,208
    80004818:	97a6                	add	a5,a5,s1
    8000481a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000481e:	fd043503          	ld	a0,-48(s0)
    80004822:	c6bfe0ef          	jal	8000348c <fileclose>
    fileclose(wf);
    80004826:	fc843503          	ld	a0,-56(s0)
    8000482a:	c63fe0ef          	jal	8000348c <fileclose>
    return -1;
    8000482e:	57fd                	li	a5,-1
}
    80004830:	853e                	mv	a0,a5
    80004832:	70e2                	ld	ra,56(sp)
    80004834:	7442                	ld	s0,48(sp)
    80004836:	74a2                	ld	s1,40(sp)
    80004838:	6121                	addi	sp,sp,64
    8000483a:	8082                	ret
    8000483c:	0000                	unimp
	...

0000000080004840 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004840:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004842:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004844:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004846:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004848:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000484a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000484c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000484e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004850:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004852:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004854:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004856:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004858:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000485a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000485c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000485e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004860:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004862:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004864:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004866:	abcfd0ef          	jal	80001b22 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000486a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000486c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000486e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004870:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004872:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004874:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004876:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004878:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000487a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000487c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000487e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004880:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004882:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004884:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004886:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004888:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000488a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000488c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000488e:	10200073          	sret
    80004892:	00000013          	nop
    80004896:	00000013          	nop
    8000489a:	00000013          	nop

000000008000489e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000489e:	1141                	addi	sp,sp,-16
    800048a0:	e406                	sd	ra,8(sp)
    800048a2:	e022                	sd	s0,0(sp)
    800048a4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800048a6:	0c000737          	lui	a4,0xc000
    800048aa:	4785                	li	a5,1
    800048ac:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800048ae:	c35c                	sw	a5,4(a4)
}
    800048b0:	60a2                	ld	ra,8(sp)
    800048b2:	6402                	ld	s0,0(sp)
    800048b4:	0141                	addi	sp,sp,16
    800048b6:	8082                	ret

00000000800048b8 <plicinithart>:

void
plicinithart(void)
{
    800048b8:	1141                	addi	sp,sp,-16
    800048ba:	e406                	sd	ra,8(sp)
    800048bc:	e022                	sd	s0,0(sp)
    800048be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048c0:	ca0fc0ef          	jal	80000d60 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800048c4:	0085171b          	slliw	a4,a0,0x8
    800048c8:	0c0027b7          	lui	a5,0xc002
    800048cc:	97ba                	add	a5,a5,a4
    800048ce:	40200713          	li	a4,1026
    800048d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800048d6:	00d5151b          	slliw	a0,a0,0xd
    800048da:	0c2017b7          	lui	a5,0xc201
    800048de:	97aa                	add	a5,a5,a0
    800048e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800048e4:	60a2                	ld	ra,8(sp)
    800048e6:	6402                	ld	s0,0(sp)
    800048e8:	0141                	addi	sp,sp,16
    800048ea:	8082                	ret

00000000800048ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800048ec:	1141                	addi	sp,sp,-16
    800048ee:	e406                	sd	ra,8(sp)
    800048f0:	e022                	sd	s0,0(sp)
    800048f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800048f4:	c6cfc0ef          	jal	80000d60 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800048f8:	00d5151b          	slliw	a0,a0,0xd
    800048fc:	0c2017b7          	lui	a5,0xc201
    80004900:	97aa                	add	a5,a5,a0
  return irq;
}
    80004902:	43c8                	lw	a0,4(a5)
    80004904:	60a2                	ld	ra,8(sp)
    80004906:	6402                	ld	s0,0(sp)
    80004908:	0141                	addi	sp,sp,16
    8000490a:	8082                	ret

000000008000490c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000490c:	1101                	addi	sp,sp,-32
    8000490e:	ec06                	sd	ra,24(sp)
    80004910:	e822                	sd	s0,16(sp)
    80004912:	e426                	sd	s1,8(sp)
    80004914:	1000                	addi	s0,sp,32
    80004916:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004918:	c48fc0ef          	jal	80000d60 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    8000491c:	00d5179b          	slliw	a5,a0,0xd
    80004920:	0c201737          	lui	a4,0xc201
    80004924:	97ba                	add	a5,a5,a4
    80004926:	c3c4                	sw	s1,4(a5)
}
    80004928:	60e2                	ld	ra,24(sp)
    8000492a:	6442                	ld	s0,16(sp)
    8000492c:	64a2                	ld	s1,8(sp)
    8000492e:	6105                	addi	sp,sp,32
    80004930:	8082                	ret

0000000080004932 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004932:	1141                	addi	sp,sp,-16
    80004934:	e406                	sd	ra,8(sp)
    80004936:	e022                	sd	s0,0(sp)
    80004938:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000493a:	479d                	li	a5,7
    8000493c:	04a7ca63          	blt	a5,a0,80004990 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004940:	00014797          	auipc	a5,0x14
    80004944:	01078793          	addi	a5,a5,16 # 80018950 <disk>
    80004948:	97aa                	add	a5,a5,a0
    8000494a:	0187c783          	lbu	a5,24(a5)
    8000494e:	e7b9                	bnez	a5,8000499c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004950:	00451693          	slli	a3,a0,0x4
    80004954:	00014797          	auipc	a5,0x14
    80004958:	ffc78793          	addi	a5,a5,-4 # 80018950 <disk>
    8000495c:	6398                	ld	a4,0(a5)
    8000495e:	9736                	add	a4,a4,a3
    80004960:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004964:	6398                	ld	a4,0(a5)
    80004966:	9736                	add	a4,a4,a3
    80004968:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    8000496c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004970:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004974:	97aa                	add	a5,a5,a0
    80004976:	4705                	li	a4,1
    80004978:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    8000497c:	00014517          	auipc	a0,0x14
    80004980:	fec50513          	addi	a0,a0,-20 # 80018968 <disk+0x18>
    80004984:	a5bfc0ef          	jal	800013de <wakeup>
}
    80004988:	60a2                	ld	ra,8(sp)
    8000498a:	6402                	ld	s0,0(sp)
    8000498c:	0141                	addi	sp,sp,16
    8000498e:	8082                	ret
    panic("free_desc 1");
    80004990:	00003517          	auipc	a0,0x3
    80004994:	c2050513          	addi	a0,a0,-992 # 800075b0 <etext+0x5b0>
    80004998:	49f000ef          	jal	80005636 <panic>
    panic("free_desc 2");
    8000499c:	00003517          	auipc	a0,0x3
    800049a0:	c2450513          	addi	a0,a0,-988 # 800075c0 <etext+0x5c0>
    800049a4:	493000ef          	jal	80005636 <panic>

00000000800049a8 <virtio_disk_init>:
{
    800049a8:	1101                	addi	sp,sp,-32
    800049aa:	ec06                	sd	ra,24(sp)
    800049ac:	e822                	sd	s0,16(sp)
    800049ae:	e426                	sd	s1,8(sp)
    800049b0:	e04a                	sd	s2,0(sp)
    800049b2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800049b4:	00003597          	auipc	a1,0x3
    800049b8:	c1c58593          	addi	a1,a1,-996 # 800075d0 <etext+0x5d0>
    800049bc:	00014517          	auipc	a0,0x14
    800049c0:	0bc50513          	addi	a0,a0,188 # 80018a78 <disk+0x128>
    800049c4:	6ab000ef          	jal	8000586e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049c8:	100017b7          	lui	a5,0x10001
    800049cc:	4398                	lw	a4,0(a5)
    800049ce:	2701                	sext.w	a4,a4
    800049d0:	747277b7          	lui	a5,0x74727
    800049d4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800049d8:	14f71863          	bne	a4,a5,80004b28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049dc:	100017b7          	lui	a5,0x10001
    800049e0:	43dc                	lw	a5,4(a5)
    800049e2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800049e4:	4709                	li	a4,2
    800049e6:	14e79163          	bne	a5,a4,80004b28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049ea:	100017b7          	lui	a5,0x10001
    800049ee:	479c                	lw	a5,8(a5)
    800049f0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800049f2:	12e79b63          	bne	a5,a4,80004b28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800049f6:	100017b7          	lui	a5,0x10001
    800049fa:	47d8                	lw	a4,12(a5)
    800049fc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800049fe:	554d47b7          	lui	a5,0x554d4
    80004a02:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004a06:	12f71163          	bne	a4,a5,80004b28 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a0a:	100017b7          	lui	a5,0x10001
    80004a0e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a12:	4705                	li	a4,1
    80004a14:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a16:	470d                	li	a4,3
    80004a18:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004a1a:	10001737          	lui	a4,0x10001
    80004a1e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004a20:	c7ffe6b7          	lui	a3,0xc7ffe
    80004a24:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fddbf7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004a28:	8f75                	and	a4,a4,a3
    80004a2a:	100016b7          	lui	a3,0x10001
    80004a2e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a30:	472d                	li	a4,11
    80004a32:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004a34:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004a38:	439c                	lw	a5,0(a5)
    80004a3a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004a3e:	8ba1                	andi	a5,a5,8
    80004a40:	0e078a63          	beqz	a5,80004b34 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004a44:	100017b7          	lui	a5,0x10001
    80004a48:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004a4c:	43fc                	lw	a5,68(a5)
    80004a4e:	2781                	sext.w	a5,a5
    80004a50:	0e079863          	bnez	a5,80004b40 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004a54:	100017b7          	lui	a5,0x10001
    80004a58:	5bdc                	lw	a5,52(a5)
    80004a5a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004a5c:	0e078863          	beqz	a5,80004b4c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004a60:	471d                	li	a4,7
    80004a62:	0ef77b63          	bgeu	a4,a5,80004b58 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004a66:	e9efb0ef          	jal	80000104 <kalloc>
    80004a6a:	00014497          	auipc	s1,0x14
    80004a6e:	ee648493          	addi	s1,s1,-282 # 80018950 <disk>
    80004a72:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004a74:	e90fb0ef          	jal	80000104 <kalloc>
    80004a78:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004a7a:	e8afb0ef          	jal	80000104 <kalloc>
    80004a7e:	87aa                	mv	a5,a0
    80004a80:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004a82:	6088                	ld	a0,0(s1)
    80004a84:	0e050063          	beqz	a0,80004b64 <virtio_disk_init+0x1bc>
    80004a88:	00014717          	auipc	a4,0x14
    80004a8c:	ed073703          	ld	a4,-304(a4) # 80018958 <disk+0x8>
    80004a90:	cb71                	beqz	a4,80004b64 <virtio_disk_init+0x1bc>
    80004a92:	cbe9                	beqz	a5,80004b64 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004a94:	6605                	lui	a2,0x1
    80004a96:	4581                	li	a1,0
    80004a98:	ec6fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004a9c:	00014497          	auipc	s1,0x14
    80004aa0:	eb448493          	addi	s1,s1,-332 # 80018950 <disk>
    80004aa4:	6605                	lui	a2,0x1
    80004aa6:	4581                	li	a1,0
    80004aa8:	6488                	ld	a0,8(s1)
    80004aaa:	eb4fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    80004aae:	6605                	lui	a2,0x1
    80004ab0:	4581                	li	a1,0
    80004ab2:	6888                	ld	a0,16(s1)
    80004ab4:	eaafb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004ab8:	100017b7          	lui	a5,0x10001
    80004abc:	4721                	li	a4,8
    80004abe:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004ac0:	4098                	lw	a4,0(s1)
    80004ac2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004ac6:	40d8                	lw	a4,4(s1)
    80004ac8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004acc:	649c                	ld	a5,8(s1)
    80004ace:	0007869b          	sext.w	a3,a5
    80004ad2:	10001737          	lui	a4,0x10001
    80004ad6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004ada:	9781                	srai	a5,a5,0x20
    80004adc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004ae0:	689c                	ld	a5,16(s1)
    80004ae2:	0007869b          	sext.w	a3,a5
    80004ae6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004aea:	9781                	srai	a5,a5,0x20
    80004aec:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004af0:	4785                	li	a5,1
    80004af2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004af4:	00f48c23          	sb	a5,24(s1)
    80004af8:	00f48ca3          	sb	a5,25(s1)
    80004afc:	00f48d23          	sb	a5,26(s1)
    80004b00:	00f48da3          	sb	a5,27(s1)
    80004b04:	00f48e23          	sb	a5,28(s1)
    80004b08:	00f48ea3          	sb	a5,29(s1)
    80004b0c:	00f48f23          	sb	a5,30(s1)
    80004b10:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004b14:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b18:	07272823          	sw	s2,112(a4)
}
    80004b1c:	60e2                	ld	ra,24(sp)
    80004b1e:	6442                	ld	s0,16(sp)
    80004b20:	64a2                	ld	s1,8(sp)
    80004b22:	6902                	ld	s2,0(sp)
    80004b24:	6105                	addi	sp,sp,32
    80004b26:	8082                	ret
    panic("could not find virtio disk");
    80004b28:	00003517          	auipc	a0,0x3
    80004b2c:	ab850513          	addi	a0,a0,-1352 # 800075e0 <etext+0x5e0>
    80004b30:	307000ef          	jal	80005636 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004b34:	00003517          	auipc	a0,0x3
    80004b38:	acc50513          	addi	a0,a0,-1332 # 80007600 <etext+0x600>
    80004b3c:	2fb000ef          	jal	80005636 <panic>
    panic("virtio disk should not be ready");
    80004b40:	00003517          	auipc	a0,0x3
    80004b44:	ae050513          	addi	a0,a0,-1312 # 80007620 <etext+0x620>
    80004b48:	2ef000ef          	jal	80005636 <panic>
    panic("virtio disk has no queue 0");
    80004b4c:	00003517          	auipc	a0,0x3
    80004b50:	af450513          	addi	a0,a0,-1292 # 80007640 <etext+0x640>
    80004b54:	2e3000ef          	jal	80005636 <panic>
    panic("virtio disk max queue too short");
    80004b58:	00003517          	auipc	a0,0x3
    80004b5c:	b0850513          	addi	a0,a0,-1272 # 80007660 <etext+0x660>
    80004b60:	2d7000ef          	jal	80005636 <panic>
    panic("virtio disk kalloc");
    80004b64:	00003517          	auipc	a0,0x3
    80004b68:	b1c50513          	addi	a0,a0,-1252 # 80007680 <etext+0x680>
    80004b6c:	2cb000ef          	jal	80005636 <panic>

0000000080004b70 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004b70:	711d                	addi	sp,sp,-96
    80004b72:	ec86                	sd	ra,88(sp)
    80004b74:	e8a2                	sd	s0,80(sp)
    80004b76:	e4a6                	sd	s1,72(sp)
    80004b78:	e0ca                	sd	s2,64(sp)
    80004b7a:	fc4e                	sd	s3,56(sp)
    80004b7c:	f852                	sd	s4,48(sp)
    80004b7e:	f456                	sd	s5,40(sp)
    80004b80:	f05a                	sd	s6,32(sp)
    80004b82:	ec5e                	sd	s7,24(sp)
    80004b84:	e862                	sd	s8,16(sp)
    80004b86:	1080                	addi	s0,sp,96
    80004b88:	89aa                	mv	s3,a0
    80004b8a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004b8c:	00c52b83          	lw	s7,12(a0)
    80004b90:	001b9b9b          	slliw	s7,s7,0x1
    80004b94:	1b82                	slli	s7,s7,0x20
    80004b96:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004b9a:	00014517          	auipc	a0,0x14
    80004b9e:	ede50513          	addi	a0,a0,-290 # 80018a78 <disk+0x128>
    80004ba2:	557000ef          	jal	800058f8 <acquire>
  for(int i = 0; i < NUM; i++){
    80004ba6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004ba8:	00014a97          	auipc	s5,0x14
    80004bac:	da8a8a93          	addi	s5,s5,-600 # 80018950 <disk>
  for(int i = 0; i < 3; i++){
    80004bb0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004bb2:	5c7d                	li	s8,-1
    80004bb4:	a095                	j	80004c18 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004bb6:	00fa8733          	add	a4,s5,a5
    80004bba:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004bbe:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004bc0:	0207c563          	bltz	a5,80004bea <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004bc4:	2905                	addiw	s2,s2,1
    80004bc6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004bc8:	05490c63          	beq	s2,s4,80004c20 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004bcc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004bce:	00014717          	auipc	a4,0x14
    80004bd2:	d8270713          	addi	a4,a4,-638 # 80018950 <disk>
    80004bd6:	4781                	li	a5,0
    if(disk.free[i]){
    80004bd8:	01874683          	lbu	a3,24(a4)
    80004bdc:	fee9                	bnez	a3,80004bb6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004bde:	2785                	addiw	a5,a5,1
    80004be0:	0705                	addi	a4,a4,1
    80004be2:	fe979be3          	bne	a5,s1,80004bd8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004be6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004bea:	01205d63          	blez	s2,80004c04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004bee:	fa042503          	lw	a0,-96(s0)
    80004bf2:	d41ff0ef          	jal	80004932 <free_desc>
      for(int j = 0; j < i; j++)
    80004bf6:	4785                	li	a5,1
    80004bf8:	0127d663          	bge	a5,s2,80004c04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004bfc:	fa442503          	lw	a0,-92(s0)
    80004c00:	d33ff0ef          	jal	80004932 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004c04:	00014597          	auipc	a1,0x14
    80004c08:	e7458593          	addi	a1,a1,-396 # 80018a78 <disk+0x128>
    80004c0c:	00014517          	auipc	a0,0x14
    80004c10:	d5c50513          	addi	a0,a0,-676 # 80018968 <disk+0x18>
    80004c14:	f7efc0ef          	jal	80001392 <sleep>
  for(int i = 0; i < 3; i++){
    80004c18:	fa040613          	addi	a2,s0,-96
    80004c1c:	4901                	li	s2,0
    80004c1e:	b77d                	j	80004bcc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c20:	fa042503          	lw	a0,-96(s0)
    80004c24:	00451693          	slli	a3,a0,0x4

  if(write)
    80004c28:	00014797          	auipc	a5,0x14
    80004c2c:	d2878793          	addi	a5,a5,-728 # 80018950 <disk>
    80004c30:	00451713          	slli	a4,a0,0x4
    80004c34:	0a070713          	addi	a4,a4,160
    80004c38:	973e                	add	a4,a4,a5
    80004c3a:	01603633          	snez	a2,s6
    80004c3e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004c40:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004c44:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c48:	6398                	ld	a4,0(a5)
    80004c4a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004c4c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004c50:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004c52:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004c54:	6390                	ld	a2,0(a5)
    80004c56:	00d60833          	add	a6,a2,a3
    80004c5a:	4741                	li	a4,16
    80004c5c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004c60:	4585                	li	a1,1
    80004c62:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004c66:	fa442703          	lw	a4,-92(s0)
    80004c6a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004c6e:	0712                	slli	a4,a4,0x4
    80004c70:	963a                	add	a2,a2,a4
    80004c72:	05898813          	addi	a6,s3,88
    80004c76:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004c7a:	0007b883          	ld	a7,0(a5)
    80004c7e:	9746                	add	a4,a4,a7
    80004c80:	40000613          	li	a2,1024
    80004c84:	c710                	sw	a2,8(a4)
  if(write)
    80004c86:	001b3613          	seqz	a2,s6
    80004c8a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004c8e:	8e4d                	or	a2,a2,a1
    80004c90:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004c94:	fa842603          	lw	a2,-88(s0)
    80004c98:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004c9c:	00451813          	slli	a6,a0,0x4
    80004ca0:	02080813          	addi	a6,a6,32
    80004ca4:	983e                	add	a6,a6,a5
    80004ca6:	577d                	li	a4,-1
    80004ca8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004cac:	0612                	slli	a2,a2,0x4
    80004cae:	98b2                	add	a7,a7,a2
    80004cb0:	03068713          	addi	a4,a3,48
    80004cb4:	973e                	add	a4,a4,a5
    80004cb6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004cba:	6398                	ld	a4,0(a5)
    80004cbc:	9732                	add	a4,a4,a2
    80004cbe:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004cc0:	4689                	li	a3,2
    80004cc2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004cc6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004cca:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004cce:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004cd2:	6794                	ld	a3,8(a5)
    80004cd4:	0026d703          	lhu	a4,2(a3)
    80004cd8:	8b1d                	andi	a4,a4,7
    80004cda:	0706                	slli	a4,a4,0x1
    80004cdc:	96ba                	add	a3,a3,a4
    80004cde:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004ce2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004ce6:	6798                	ld	a4,8(a5)
    80004ce8:	00275783          	lhu	a5,2(a4)
    80004cec:	2785                	addiw	a5,a5,1
    80004cee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004cf2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004cf6:	100017b7          	lui	a5,0x10001
    80004cfa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004cfe:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004d02:	00014917          	auipc	s2,0x14
    80004d06:	d7690913          	addi	s2,s2,-650 # 80018a78 <disk+0x128>
  while(b->disk == 1) {
    80004d0a:	84ae                	mv	s1,a1
    80004d0c:	00b79a63          	bne	a5,a1,80004d20 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004d10:	85ca                	mv	a1,s2
    80004d12:	854e                	mv	a0,s3
    80004d14:	e7efc0ef          	jal	80001392 <sleep>
  while(b->disk == 1) {
    80004d18:	0049a783          	lw	a5,4(s3)
    80004d1c:	fe978ae3          	beq	a5,s1,80004d10 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004d20:	fa042903          	lw	s2,-96(s0)
    80004d24:	00491713          	slli	a4,s2,0x4
    80004d28:	02070713          	addi	a4,a4,32
    80004d2c:	00014797          	auipc	a5,0x14
    80004d30:	c2478793          	addi	a5,a5,-988 # 80018950 <disk>
    80004d34:	97ba                	add	a5,a5,a4
    80004d36:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004d3a:	00014997          	auipc	s3,0x14
    80004d3e:	c1698993          	addi	s3,s3,-1002 # 80018950 <disk>
    80004d42:	00491713          	slli	a4,s2,0x4
    80004d46:	0009b783          	ld	a5,0(s3)
    80004d4a:	97ba                	add	a5,a5,a4
    80004d4c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004d50:	854a                	mv	a0,s2
    80004d52:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004d56:	bddff0ef          	jal	80004932 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004d5a:	8885                	andi	s1,s1,1
    80004d5c:	f0fd                	bnez	s1,80004d42 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004d5e:	00014517          	auipc	a0,0x14
    80004d62:	d1a50513          	addi	a0,a0,-742 # 80018a78 <disk+0x128>
    80004d66:	427000ef          	jal	8000598c <release>
}
    80004d6a:	60e6                	ld	ra,88(sp)
    80004d6c:	6446                	ld	s0,80(sp)
    80004d6e:	64a6                	ld	s1,72(sp)
    80004d70:	6906                	ld	s2,64(sp)
    80004d72:	79e2                	ld	s3,56(sp)
    80004d74:	7a42                	ld	s4,48(sp)
    80004d76:	7aa2                	ld	s5,40(sp)
    80004d78:	7b02                	ld	s6,32(sp)
    80004d7a:	6be2                	ld	s7,24(sp)
    80004d7c:	6c42                	ld	s8,16(sp)
    80004d7e:	6125                	addi	sp,sp,96
    80004d80:	8082                	ret

0000000080004d82 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004d82:	1101                	addi	sp,sp,-32
    80004d84:	ec06                	sd	ra,24(sp)
    80004d86:	e822                	sd	s0,16(sp)
    80004d88:	e426                	sd	s1,8(sp)
    80004d8a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004d8c:	00014497          	auipc	s1,0x14
    80004d90:	bc448493          	addi	s1,s1,-1084 # 80018950 <disk>
    80004d94:	00014517          	auipc	a0,0x14
    80004d98:	ce450513          	addi	a0,a0,-796 # 80018a78 <disk+0x128>
    80004d9c:	35d000ef          	jal	800058f8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004da0:	100017b7          	lui	a5,0x10001
    80004da4:	53bc                	lw	a5,96(a5)
    80004da6:	8b8d                	andi	a5,a5,3
    80004da8:	10001737          	lui	a4,0x10001
    80004dac:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004dae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004db2:	689c                	ld	a5,16(s1)
    80004db4:	0204d703          	lhu	a4,32(s1)
    80004db8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004dbc:	04f70863          	beq	a4,a5,80004e0c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004dc0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004dc4:	6898                	ld	a4,16(s1)
    80004dc6:	0204d783          	lhu	a5,32(s1)
    80004dca:	8b9d                	andi	a5,a5,7
    80004dcc:	078e                	slli	a5,a5,0x3
    80004dce:	97ba                	add	a5,a5,a4
    80004dd0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004dd2:	00479713          	slli	a4,a5,0x4
    80004dd6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004dda:	9726                	add	a4,a4,s1
    80004ddc:	01074703          	lbu	a4,16(a4)
    80004de0:	e329                	bnez	a4,80004e22 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004de2:	0792                	slli	a5,a5,0x4
    80004de4:	02078793          	addi	a5,a5,32
    80004de8:	97a6                	add	a5,a5,s1
    80004dea:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004dec:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004df0:	deefc0ef          	jal	800013de <wakeup>

    disk.used_idx += 1;
    80004df4:	0204d783          	lhu	a5,32(s1)
    80004df8:	2785                	addiw	a5,a5,1
    80004dfa:	17c2                	slli	a5,a5,0x30
    80004dfc:	93c1                	srli	a5,a5,0x30
    80004dfe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004e02:	6898                	ld	a4,16(s1)
    80004e04:	00275703          	lhu	a4,2(a4)
    80004e08:	faf71ce3          	bne	a4,a5,80004dc0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004e0c:	00014517          	auipc	a0,0x14
    80004e10:	c6c50513          	addi	a0,a0,-916 # 80018a78 <disk+0x128>
    80004e14:	379000ef          	jal	8000598c <release>
}
    80004e18:	60e2                	ld	ra,24(sp)
    80004e1a:	6442                	ld	s0,16(sp)
    80004e1c:	64a2                	ld	s1,8(sp)
    80004e1e:	6105                	addi	sp,sp,32
    80004e20:	8082                	ret
      panic("virtio_disk_intr status");
    80004e22:	00003517          	auipc	a0,0x3
    80004e26:	87650513          	addi	a0,a0,-1930 # 80007698 <etext+0x698>
    80004e2a:	00d000ef          	jal	80005636 <panic>

0000000080004e2e <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004e2e:	1141                	addi	sp,sp,-16
    80004e30:	e406                	sd	ra,8(sp)
    80004e32:	e022                	sd	s0,0(sp)
    80004e34:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004e36:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004e3a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004e3e:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004e42:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004e46:	577d                	li	a4,-1
    80004e48:	177e                	slli	a4,a4,0x3f
    80004e4a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004e4c:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004e50:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004e54:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004e58:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004e5c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004e60:	000f4737          	lui	a4,0xf4
    80004e64:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004e68:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004e6a:	14d79073          	csrw	stimecmp,a5
}
    80004e6e:	60a2                	ld	ra,8(sp)
    80004e70:	6402                	ld	s0,0(sp)
    80004e72:	0141                	addi	sp,sp,16
    80004e74:	8082                	ret

0000000080004e76 <start>:
{
    80004e76:	1141                	addi	sp,sp,-16
    80004e78:	e406                	sd	ra,8(sp)
    80004e7a:	e022                	sd	s0,0(sp)
    80004e7c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004e7e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004e82:	7779                	lui	a4,0xffffe
    80004e84:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffddc97>
    80004e88:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004e8a:	6705                	lui	a4,0x1
    80004e8c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004e90:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004e92:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004e96:	ffffb797          	auipc	a5,0xffffb
    80004e9a:	47e78793          	addi	a5,a5,1150 # 80000314 <main>
    80004e9e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004ea2:	4781                	li	a5,0
    80004ea4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004ea8:	67c1                	lui	a5,0x10
    80004eaa:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004eac:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004eb0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004eb4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004eb8:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004ebc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004ec0:	57fd                	li	a5,-1
    80004ec2:	83a9                	srli	a5,a5,0xa
    80004ec4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004ec8:	47bd                	li	a5,15
    80004eca:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004ece:	f61ff0ef          	jal	80004e2e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004ed2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004ed6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004ed8:	823e                	mv	tp,a5
  asm volatile("mret");
    80004eda:	30200073          	mret
}
    80004ede:	60a2                	ld	ra,8(sp)
    80004ee0:	6402                	ld	s0,0(sp)
    80004ee2:	0141                	addi	sp,sp,16
    80004ee4:	8082                	ret

0000000080004ee6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004ee6:	7119                	addi	sp,sp,-128
    80004ee8:	fc86                	sd	ra,120(sp)
    80004eea:	f8a2                	sd	s0,112(sp)
    80004eec:	f4a6                	sd	s1,104(sp)
    80004eee:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80004ef0:	06c05b63          	blez	a2,80004f66 <consolewrite+0x80>
    80004ef4:	f0ca                	sd	s2,96(sp)
    80004ef6:	ecce                	sd	s3,88(sp)
    80004ef8:	e8d2                	sd	s4,80(sp)
    80004efa:	e4d6                	sd	s5,72(sp)
    80004efc:	e0da                	sd	s6,64(sp)
    80004efe:	fc5e                	sd	s7,56(sp)
    80004f00:	f862                	sd	s8,48(sp)
    80004f02:	f466                	sd	s9,40(sp)
    80004f04:	f06a                	sd	s10,32(sp)
    80004f06:	8b2a                	mv	s6,a0
    80004f08:	8bae                	mv	s7,a1
    80004f0a:	8a32                	mv	s4,a2
  int i = 0;
    80004f0c:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    80004f0e:	02000c93          	li	s9,32
    80004f12:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004f16:	f8040a93          	addi	s5,s0,-128
    80004f1a:	5c7d                	li	s8,-1
    80004f1c:	a025                	j	80004f44 <consolewrite+0x5e>
    if(nn > n - i)
    80004f1e:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80004f22:	86ce                	mv	a3,s3
    80004f24:	01748633          	add	a2,s1,s7
    80004f28:	85da                	mv	a1,s6
    80004f2a:	8556                	mv	a0,s5
    80004f2c:	80bfc0ef          	jal	80001736 <either_copyin>
    80004f30:	03850d63          	beq	a0,s8,80004f6a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80004f34:	85ce                	mv	a1,s3
    80004f36:	8556                	mv	a0,s5
    80004f38:	7b4000ef          	jal	800056ec <uartwrite>
    i += nn;
    80004f3c:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80004f40:	0144d963          	bge	s1,s4,80004f52 <consolewrite+0x6c>
    if(nn > n - i)
    80004f44:	409a07bb          	subw	a5,s4,s1
    80004f48:	893e                	mv	s2,a5
    80004f4a:	fcfcdae3          	bge	s9,a5,80004f1e <consolewrite+0x38>
    80004f4e:	896a                	mv	s2,s10
    80004f50:	b7f9                	j	80004f1e <consolewrite+0x38>
    80004f52:	7906                	ld	s2,96(sp)
    80004f54:	69e6                	ld	s3,88(sp)
    80004f56:	6a46                	ld	s4,80(sp)
    80004f58:	6aa6                	ld	s5,72(sp)
    80004f5a:	6b06                	ld	s6,64(sp)
    80004f5c:	7be2                	ld	s7,56(sp)
    80004f5e:	7c42                	ld	s8,48(sp)
    80004f60:	7ca2                	ld	s9,40(sp)
    80004f62:	7d02                	ld	s10,32(sp)
    80004f64:	a821                	j	80004f7c <consolewrite+0x96>
  int i = 0;
    80004f66:	4481                	li	s1,0
    80004f68:	a811                	j	80004f7c <consolewrite+0x96>
    80004f6a:	7906                	ld	s2,96(sp)
    80004f6c:	69e6                	ld	s3,88(sp)
    80004f6e:	6a46                	ld	s4,80(sp)
    80004f70:	6aa6                	ld	s5,72(sp)
    80004f72:	6b06                	ld	s6,64(sp)
    80004f74:	7be2                	ld	s7,56(sp)
    80004f76:	7c42                	ld	s8,48(sp)
    80004f78:	7ca2                	ld	s9,40(sp)
    80004f7a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    80004f7c:	8526                	mv	a0,s1
    80004f7e:	70e6                	ld	ra,120(sp)
    80004f80:	7446                	ld	s0,112(sp)
    80004f82:	74a6                	ld	s1,104(sp)
    80004f84:	6109                	addi	sp,sp,128
    80004f86:	8082                	ret

0000000080004f88 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80004f88:	711d                	addi	sp,sp,-96
    80004f8a:	ec86                	sd	ra,88(sp)
    80004f8c:	e8a2                	sd	s0,80(sp)
    80004f8e:	e4a6                	sd	s1,72(sp)
    80004f90:	e0ca                	sd	s2,64(sp)
    80004f92:	fc4e                	sd	s3,56(sp)
    80004f94:	f852                	sd	s4,48(sp)
    80004f96:	f05a                	sd	s6,32(sp)
    80004f98:	ec5e                	sd	s7,24(sp)
    80004f9a:	1080                	addi	s0,sp,96
    80004f9c:	8b2a                	mv	s6,a0
    80004f9e:	8a2e                	mv	s4,a1
    80004fa0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80004fa2:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80004fa4:	0001c517          	auipc	a0,0x1c
    80004fa8:	aec50513          	addi	a0,a0,-1300 # 80020a90 <cons>
    80004fac:	14d000ef          	jal	800058f8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80004fb0:	0001c497          	auipc	s1,0x1c
    80004fb4:	ae048493          	addi	s1,s1,-1312 # 80020a90 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80004fb8:	0001c917          	auipc	s2,0x1c
    80004fbc:	b7090913          	addi	s2,s2,-1168 # 80020b28 <cons+0x98>
  while(n > 0){
    80004fc0:	0b305b63          	blez	s3,80005076 <consoleread+0xee>
    while(cons.r == cons.w){
    80004fc4:	0984a783          	lw	a5,152(s1)
    80004fc8:	09c4a703          	lw	a4,156(s1)
    80004fcc:	0af71063          	bne	a4,a5,8000506c <consoleread+0xe4>
      if(killed(myproc())){
    80004fd0:	dc5fb0ef          	jal	80000d94 <myproc>
    80004fd4:	dfafc0ef          	jal	800015ce <killed>
    80004fd8:	e12d                	bnez	a0,8000503a <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    80004fda:	85a6                	mv	a1,s1
    80004fdc:	854a                	mv	a0,s2
    80004fde:	bb4fc0ef          	jal	80001392 <sleep>
    while(cons.r == cons.w){
    80004fe2:	0984a783          	lw	a5,152(s1)
    80004fe6:	09c4a703          	lw	a4,156(s1)
    80004fea:	fef703e3          	beq	a4,a5,80004fd0 <consoleread+0x48>
    80004fee:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80004ff0:	0001c717          	auipc	a4,0x1c
    80004ff4:	aa070713          	addi	a4,a4,-1376 # 80020a90 <cons>
    80004ff8:	0017869b          	addiw	a3,a5,1
    80004ffc:	08d72c23          	sw	a3,152(a4)
    80005000:	07f7f693          	andi	a3,a5,127
    80005004:	9736                	add	a4,a4,a3
    80005006:	01874703          	lbu	a4,24(a4)
    8000500a:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    8000500e:	4691                	li	a3,4
    80005010:	04da8663          	beq	s5,a3,8000505c <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005014:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005018:	4685                	li	a3,1
    8000501a:	faf40613          	addi	a2,s0,-81
    8000501e:	85d2                	mv	a1,s4
    80005020:	855a                	mv	a0,s6
    80005022:	ecafc0ef          	jal	800016ec <either_copyout>
    80005026:	57fd                	li	a5,-1
    80005028:	04f50663          	beq	a0,a5,80005074 <consoleread+0xec>
      break;

    dst++;
    8000502c:	0a05                	addi	s4,s4,1
    --n;
    8000502e:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005030:	47a9                	li	a5,10
    80005032:	04fa8b63          	beq	s5,a5,80005088 <consoleread+0x100>
    80005036:	7aa2                	ld	s5,40(sp)
    80005038:	b761                	j	80004fc0 <consoleread+0x38>
        release(&cons.lock);
    8000503a:	0001c517          	auipc	a0,0x1c
    8000503e:	a5650513          	addi	a0,a0,-1450 # 80020a90 <cons>
    80005042:	14b000ef          	jal	8000598c <release>
        return -1;
    80005046:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005048:	60e6                	ld	ra,88(sp)
    8000504a:	6446                	ld	s0,80(sp)
    8000504c:	64a6                	ld	s1,72(sp)
    8000504e:	6906                	ld	s2,64(sp)
    80005050:	79e2                	ld	s3,56(sp)
    80005052:	7a42                	ld	s4,48(sp)
    80005054:	7b02                	ld	s6,32(sp)
    80005056:	6be2                	ld	s7,24(sp)
    80005058:	6125                	addi	sp,sp,96
    8000505a:	8082                	ret
      if(n < target){
    8000505c:	0179fa63          	bgeu	s3,s7,80005070 <consoleread+0xe8>
        cons.r--;
    80005060:	0001c717          	auipc	a4,0x1c
    80005064:	acf72423          	sw	a5,-1336(a4) # 80020b28 <cons+0x98>
    80005068:	7aa2                	ld	s5,40(sp)
    8000506a:	a031                	j	80005076 <consoleread+0xee>
    8000506c:	f456                	sd	s5,40(sp)
    8000506e:	b749                	j	80004ff0 <consoleread+0x68>
    80005070:	7aa2                	ld	s5,40(sp)
    80005072:	a011                	j	80005076 <consoleread+0xee>
    80005074:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005076:	0001c517          	auipc	a0,0x1c
    8000507a:	a1a50513          	addi	a0,a0,-1510 # 80020a90 <cons>
    8000507e:	10f000ef          	jal	8000598c <release>
  return target - n;
    80005082:	413b853b          	subw	a0,s7,s3
    80005086:	b7c9                	j	80005048 <consoleread+0xc0>
    80005088:	7aa2                	ld	s5,40(sp)
    8000508a:	b7f5                	j	80005076 <consoleread+0xee>

000000008000508c <consputc>:
{
    8000508c:	1141                	addi	sp,sp,-16
    8000508e:	e406                	sd	ra,8(sp)
    80005090:	e022                	sd	s0,0(sp)
    80005092:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005094:	10000793          	li	a5,256
    80005098:	00f50863          	beq	a0,a5,800050a8 <consputc+0x1c>
    uartputc_sync(c);
    8000509c:	6e4000ef          	jal	80005780 <uartputc_sync>
}
    800050a0:	60a2                	ld	ra,8(sp)
    800050a2:	6402                	ld	s0,0(sp)
    800050a4:	0141                	addi	sp,sp,16
    800050a6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800050a8:	4521                	li	a0,8
    800050aa:	6d6000ef          	jal	80005780 <uartputc_sync>
    800050ae:	02000513          	li	a0,32
    800050b2:	6ce000ef          	jal	80005780 <uartputc_sync>
    800050b6:	4521                	li	a0,8
    800050b8:	6c8000ef          	jal	80005780 <uartputc_sync>
    800050bc:	b7d5                	j	800050a0 <consputc+0x14>

00000000800050be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800050be:	1101                	addi	sp,sp,-32
    800050c0:	ec06                	sd	ra,24(sp)
    800050c2:	e822                	sd	s0,16(sp)
    800050c4:	e426                	sd	s1,8(sp)
    800050c6:	1000                	addi	s0,sp,32
    800050c8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800050ca:	0001c517          	auipc	a0,0x1c
    800050ce:	9c650513          	addi	a0,a0,-1594 # 80020a90 <cons>
    800050d2:	027000ef          	jal	800058f8 <acquire>

  switch(c){
    800050d6:	47d5                	li	a5,21
    800050d8:	08f48d63          	beq	s1,a5,80005172 <consoleintr+0xb4>
    800050dc:	0297c563          	blt	a5,s1,80005106 <consoleintr+0x48>
    800050e0:	47a1                	li	a5,8
    800050e2:	0ef48263          	beq	s1,a5,800051c6 <consoleintr+0x108>
    800050e6:	47c1                	li	a5,16
    800050e8:	10f49363          	bne	s1,a5,800051ee <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800050ec:	e94fc0ef          	jal	80001780 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800050f0:	0001c517          	auipc	a0,0x1c
    800050f4:	9a050513          	addi	a0,a0,-1632 # 80020a90 <cons>
    800050f8:	095000ef          	jal	8000598c <release>
}
    800050fc:	60e2                	ld	ra,24(sp)
    800050fe:	6442                	ld	s0,16(sp)
    80005100:	64a2                	ld	s1,8(sp)
    80005102:	6105                	addi	sp,sp,32
    80005104:	8082                	ret
  switch(c){
    80005106:	07f00793          	li	a5,127
    8000510a:	0af48e63          	beq	s1,a5,800051c6 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000510e:	0001c717          	auipc	a4,0x1c
    80005112:	98270713          	addi	a4,a4,-1662 # 80020a90 <cons>
    80005116:	0a072783          	lw	a5,160(a4)
    8000511a:	09872703          	lw	a4,152(a4)
    8000511e:	9f99                	subw	a5,a5,a4
    80005120:	07f00713          	li	a4,127
    80005124:	fcf766e3          	bltu	a4,a5,800050f0 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005128:	47b5                	li	a5,13
    8000512a:	0cf48563          	beq	s1,a5,800051f4 <consoleintr+0x136>
      consputc(c);
    8000512e:	8526                	mv	a0,s1
    80005130:	f5dff0ef          	jal	8000508c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005134:	0001c717          	auipc	a4,0x1c
    80005138:	95c70713          	addi	a4,a4,-1700 # 80020a90 <cons>
    8000513c:	0a072683          	lw	a3,160(a4)
    80005140:	0016879b          	addiw	a5,a3,1
    80005144:	863e                	mv	a2,a5
    80005146:	0af72023          	sw	a5,160(a4)
    8000514a:	07f6f693          	andi	a3,a3,127
    8000514e:	9736                	add	a4,a4,a3
    80005150:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005154:	ff648713          	addi	a4,s1,-10
    80005158:	c371                	beqz	a4,8000521c <consoleintr+0x15e>
    8000515a:	14f1                	addi	s1,s1,-4
    8000515c:	c0e1                	beqz	s1,8000521c <consoleintr+0x15e>
    8000515e:	0001c717          	auipc	a4,0x1c
    80005162:	9ca72703          	lw	a4,-1590(a4) # 80020b28 <cons+0x98>
    80005166:	9f99                	subw	a5,a5,a4
    80005168:	08000713          	li	a4,128
    8000516c:	f8e792e3          	bne	a5,a4,800050f0 <consoleintr+0x32>
    80005170:	a075                	j	8000521c <consoleintr+0x15e>
    80005172:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005174:	0001c717          	auipc	a4,0x1c
    80005178:	91c70713          	addi	a4,a4,-1764 # 80020a90 <cons>
    8000517c:	0a072783          	lw	a5,160(a4)
    80005180:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005184:	0001c497          	auipc	s1,0x1c
    80005188:	90c48493          	addi	s1,s1,-1780 # 80020a90 <cons>
    while(cons.e != cons.w &&
    8000518c:	4929                	li	s2,10
    8000518e:	02f70863          	beq	a4,a5,800051be <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005192:	37fd                	addiw	a5,a5,-1
    80005194:	07f7f713          	andi	a4,a5,127
    80005198:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000519a:	01874703          	lbu	a4,24(a4)
    8000519e:	03270263          	beq	a4,s2,800051c2 <consoleintr+0x104>
      cons.e--;
    800051a2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800051a6:	10000513          	li	a0,256
    800051aa:	ee3ff0ef          	jal	8000508c <consputc>
    while(cons.e != cons.w &&
    800051ae:	0a04a783          	lw	a5,160(s1)
    800051b2:	09c4a703          	lw	a4,156(s1)
    800051b6:	fcf71ee3          	bne	a4,a5,80005192 <consoleintr+0xd4>
    800051ba:	6902                	ld	s2,0(sp)
    800051bc:	bf15                	j	800050f0 <consoleintr+0x32>
    800051be:	6902                	ld	s2,0(sp)
    800051c0:	bf05                	j	800050f0 <consoleintr+0x32>
    800051c2:	6902                	ld	s2,0(sp)
    800051c4:	b735                	j	800050f0 <consoleintr+0x32>
    if(cons.e != cons.w){
    800051c6:	0001c717          	auipc	a4,0x1c
    800051ca:	8ca70713          	addi	a4,a4,-1846 # 80020a90 <cons>
    800051ce:	0a072783          	lw	a5,160(a4)
    800051d2:	09c72703          	lw	a4,156(a4)
    800051d6:	f0f70de3          	beq	a4,a5,800050f0 <consoleintr+0x32>
      cons.e--;
    800051da:	37fd                	addiw	a5,a5,-1
    800051dc:	0001c717          	auipc	a4,0x1c
    800051e0:	94f72a23          	sw	a5,-1708(a4) # 80020b30 <cons+0xa0>
      consputc(BACKSPACE);
    800051e4:	10000513          	li	a0,256
    800051e8:	ea5ff0ef          	jal	8000508c <consputc>
    800051ec:	b711                	j	800050f0 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800051ee:	f00481e3          	beqz	s1,800050f0 <consoleintr+0x32>
    800051f2:	bf31                	j	8000510e <consoleintr+0x50>
      consputc(c);
    800051f4:	4529                	li	a0,10
    800051f6:	e97ff0ef          	jal	8000508c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800051fa:	0001c797          	auipc	a5,0x1c
    800051fe:	89678793          	addi	a5,a5,-1898 # 80020a90 <cons>
    80005202:	0a07a703          	lw	a4,160(a5)
    80005206:	0017069b          	addiw	a3,a4,1
    8000520a:	8636                	mv	a2,a3
    8000520c:	0ad7a023          	sw	a3,160(a5)
    80005210:	07f77713          	andi	a4,a4,127
    80005214:	97ba                	add	a5,a5,a4
    80005216:	4729                	li	a4,10
    80005218:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000521c:	0001c797          	auipc	a5,0x1c
    80005220:	90c7a823          	sw	a2,-1776(a5) # 80020b2c <cons+0x9c>
        wakeup(&cons.r);
    80005224:	0001c517          	auipc	a0,0x1c
    80005228:	90450513          	addi	a0,a0,-1788 # 80020b28 <cons+0x98>
    8000522c:	9b2fc0ef          	jal	800013de <wakeup>
    80005230:	b5c1                	j	800050f0 <consoleintr+0x32>

0000000080005232 <consoleinit>:

void
consoleinit(void)
{
    80005232:	1141                	addi	sp,sp,-16
    80005234:	e406                	sd	ra,8(sp)
    80005236:	e022                	sd	s0,0(sp)
    80005238:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000523a:	00002597          	auipc	a1,0x2
    8000523e:	47658593          	addi	a1,a1,1142 # 800076b0 <etext+0x6b0>
    80005242:	0001c517          	auipc	a0,0x1c
    80005246:	84e50513          	addi	a0,a0,-1970 # 80020a90 <cons>
    8000524a:	624000ef          	jal	8000586e <initlock>

  uartinit();
    8000524e:	448000ef          	jal	80005696 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005252:	00012797          	auipc	a5,0x12
    80005256:	6a678793          	addi	a5,a5,1702 # 800178f8 <devsw>
    8000525a:	00000717          	auipc	a4,0x0
    8000525e:	d2e70713          	addi	a4,a4,-722 # 80004f88 <consoleread>
    80005262:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005264:	00000717          	auipc	a4,0x0
    80005268:	c8270713          	addi	a4,a4,-894 # 80004ee6 <consolewrite>
    8000526c:	ef98                	sd	a4,24(a5)
}
    8000526e:	60a2                	ld	ra,8(sp)
    80005270:	6402                	ld	s0,0(sp)
    80005272:	0141                	addi	sp,sp,16
    80005274:	8082                	ret

0000000080005276 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005276:	7139                	addi	sp,sp,-64
    80005278:	fc06                	sd	ra,56(sp)
    8000527a:	f822                	sd	s0,48(sp)
    8000527c:	f04a                	sd	s2,32(sp)
    8000527e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005280:	c219                	beqz	a2,80005286 <printint+0x10>
    80005282:	08054163          	bltz	a0,80005304 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005286:	4301                	li	t1,0

  i = 0;
    80005288:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000528c:	86ca                	mv	a3,s2
  i = 0;
    8000528e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005290:	00002817          	auipc	a6,0x2
    80005294:	57880813          	addi	a6,a6,1400 # 80007808 <digits>
    80005298:	88ba                	mv	a7,a4
    8000529a:	0017061b          	addiw	a2,a4,1
    8000529e:	8732                	mv	a4,a2
    800052a0:	02b577b3          	remu	a5,a0,a1
    800052a4:	97c2                	add	a5,a5,a6
    800052a6:	0007c783          	lbu	a5,0(a5)
    800052aa:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800052ae:	87aa                	mv	a5,a0
    800052b0:	02b55533          	divu	a0,a0,a1
    800052b4:	0685                	addi	a3,a3,1
    800052b6:	feb7f1e3          	bgeu	a5,a1,80005298 <printint+0x22>

  if(sign)
    800052ba:	00030c63          	beqz	t1,800052d2 <printint+0x5c>
    buf[i++] = '-';
    800052be:	fe060793          	addi	a5,a2,-32
    800052c2:	00878633          	add	a2,a5,s0
    800052c6:	02d00793          	li	a5,45
    800052ca:	fef60423          	sb	a5,-24(a2)
    800052ce:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800052d2:	02e05463          	blez	a4,800052fa <printint+0x84>
    800052d6:	f426                	sd	s1,40(sp)
    800052d8:	377d                	addiw	a4,a4,-1
    800052da:	00e904b3          	add	s1,s2,a4
    800052de:	197d                	addi	s2,s2,-1
    800052e0:	993a                	add	s2,s2,a4
    800052e2:	1702                	slli	a4,a4,0x20
    800052e4:	9301                	srli	a4,a4,0x20
    800052e6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800052ea:	0004c503          	lbu	a0,0(s1)
    800052ee:	d9fff0ef          	jal	8000508c <consputc>
  while(--i >= 0)
    800052f2:	14fd                	addi	s1,s1,-1
    800052f4:	ff249be3          	bne	s1,s2,800052ea <printint+0x74>
    800052f8:	74a2                	ld	s1,40(sp)
}
    800052fa:	70e2                	ld	ra,56(sp)
    800052fc:	7442                	ld	s0,48(sp)
    800052fe:	7902                	ld	s2,32(sp)
    80005300:	6121                	addi	sp,sp,64
    80005302:	8082                	ret
    x = -xx;
    80005304:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005308:	4305                	li	t1,1
    x = -xx;
    8000530a:	bfbd                	j	80005288 <printint+0x12>

000000008000530c <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000530c:	7131                	addi	sp,sp,-192
    8000530e:	fc86                	sd	ra,120(sp)
    80005310:	f8a2                	sd	s0,112(sp)
    80005312:	f0ca                	sd	s2,96(sp)
    80005314:	0100                	addi	s0,sp,128
    80005316:	892a                	mv	s2,a0
    80005318:	e40c                	sd	a1,8(s0)
    8000531a:	e810                	sd	a2,16(s0)
    8000531c:	ec14                	sd	a3,24(s0)
    8000531e:	f018                	sd	a4,32(s0)
    80005320:	f41c                	sd	a5,40(s0)
    80005322:	03043823          	sd	a6,48(s0)
    80005326:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    8000532a:	00002797          	auipc	a5,0x2
    8000532e:	5267a783          	lw	a5,1318(a5) # 80007850 <panicking>
    80005332:	cf9d                	beqz	a5,80005370 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005334:	00840793          	addi	a5,s0,8
    80005338:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000533c:	00094503          	lbu	a0,0(s2)
    80005340:	22050663          	beqz	a0,8000556c <printf+0x260>
    80005344:	f4a6                	sd	s1,104(sp)
    80005346:	ecce                	sd	s3,88(sp)
    80005348:	e8d2                	sd	s4,80(sp)
    8000534a:	e4d6                	sd	s5,72(sp)
    8000534c:	e0da                	sd	s6,64(sp)
    8000534e:	fc5e                	sd	s7,56(sp)
    80005350:	f862                	sd	s8,48(sp)
    80005352:	f06a                	sd	s10,32(sp)
    80005354:	ec6e                	sd	s11,24(sp)
    80005356:	4a01                	li	s4,0
    if(cx != '%'){
    80005358:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000535c:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005360:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005364:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80005368:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000536a:	06400b93          	li	s7,100
    8000536e:	a015                	j	80005392 <printf+0x86>
    acquire(&pr.lock);
    80005370:	0001b517          	auipc	a0,0x1b
    80005374:	7c850513          	addi	a0,a0,1992 # 80020b38 <pr>
    80005378:	580000ef          	jal	800058f8 <acquire>
    8000537c:	bf65                	j	80005334 <printf+0x28>
      consputc(cx);
    8000537e:	d0fff0ef          	jal	8000508c <consputc>
      continue;
    80005382:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005384:	2485                	addiw	s1,s1,1
    80005386:	8a26                	mv	s4,s1
    80005388:	94ca                	add	s1,s1,s2
    8000538a:	0004c503          	lbu	a0,0(s1)
    8000538e:	1c050663          	beqz	a0,8000555a <printf+0x24e>
    if(cx != '%'){
    80005392:	ff3516e3          	bne	a0,s3,8000537e <printf+0x72>
    i++;
    80005396:	001a079b          	addiw	a5,s4,1
    8000539a:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000539c:	00f90733          	add	a4,s2,a5
    800053a0:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800053a4:	200a8963          	beqz	s5,800055b6 <printf+0x2aa>
    800053a8:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    800053ac:	1e068c63          	beqz	a3,800055a4 <printf+0x298>
    if(c0 == 'd'){
    800053b0:	037a8863          	beq	s5,s7,800053e0 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800053b4:	f94a8713          	addi	a4,s5,-108
    800053b8:	00173713          	seqz	a4,a4
    800053bc:	f9c68613          	addi	a2,a3,-100
    800053c0:	ee05                	bnez	a2,800053f8 <printf+0xec>
    800053c2:	cb1d                	beqz	a4,800053f8 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800053c4:	f8843783          	ld	a5,-120(s0)
    800053c8:	00878713          	addi	a4,a5,8
    800053cc:	f8e43423          	sd	a4,-120(s0)
    800053d0:	4605                	li	a2,1
    800053d2:	85da                	mv	a1,s6
    800053d4:	6388                	ld	a0,0(a5)
    800053d6:	ea1ff0ef          	jal	80005276 <printint>
      i += 1;
    800053da:	002a049b          	addiw	s1,s4,2
    800053de:	b75d                	j	80005384 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800053e0:	f8843783          	ld	a5,-120(s0)
    800053e4:	00878713          	addi	a4,a5,8
    800053e8:	f8e43423          	sd	a4,-120(s0)
    800053ec:	4605                	li	a2,1
    800053ee:	85da                	mv	a1,s6
    800053f0:	4388                	lw	a0,0(a5)
    800053f2:	e85ff0ef          	jal	80005276 <printint>
    800053f6:	b779                	j	80005384 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800053f8:	97ca                	add	a5,a5,s2
    800053fa:	8636                	mv	a2,a3
    800053fc:	0027c683          	lbu	a3,2(a5)
    80005400:	a2c9                	j	800055c2 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005402:	f8843783          	ld	a5,-120(s0)
    80005406:	00878713          	addi	a4,a5,8
    8000540a:	f8e43423          	sd	a4,-120(s0)
    8000540e:	4605                	li	a2,1
    80005410:	45a9                	li	a1,10
    80005412:	6388                	ld	a0,0(a5)
    80005414:	e63ff0ef          	jal	80005276 <printint>
      i += 2;
    80005418:	003a049b          	addiw	s1,s4,3
    8000541c:	b7a5                	j	80005384 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000541e:	f8843783          	ld	a5,-120(s0)
    80005422:	00878713          	addi	a4,a5,8
    80005426:	f8e43423          	sd	a4,-120(s0)
    8000542a:	4601                	li	a2,0
    8000542c:	85da                	mv	a1,s6
    8000542e:	0007e503          	lwu	a0,0(a5)
    80005432:	e45ff0ef          	jal	80005276 <printint>
    80005436:	b7b9                	j	80005384 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005438:	f8843783          	ld	a5,-120(s0)
    8000543c:	00878713          	addi	a4,a5,8
    80005440:	f8e43423          	sd	a4,-120(s0)
    80005444:	4601                	li	a2,0
    80005446:	85da                	mv	a1,s6
    80005448:	6388                	ld	a0,0(a5)
    8000544a:	e2dff0ef          	jal	80005276 <printint>
      i += 1;
    8000544e:	002a049b          	addiw	s1,s4,2
    80005452:	bf0d                	j	80005384 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005454:	f8843783          	ld	a5,-120(s0)
    80005458:	00878713          	addi	a4,a5,8
    8000545c:	f8e43423          	sd	a4,-120(s0)
    80005460:	4601                	li	a2,0
    80005462:	45a9                	li	a1,10
    80005464:	6388                	ld	a0,0(a5)
    80005466:	e11ff0ef          	jal	80005276 <printint>
      i += 2;
    8000546a:	003a049b          	addiw	s1,s4,3
    8000546e:	bf19                	j	80005384 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005470:	f8843783          	ld	a5,-120(s0)
    80005474:	00878713          	addi	a4,a5,8
    80005478:	f8e43423          	sd	a4,-120(s0)
    8000547c:	4601                	li	a2,0
    8000547e:	45c1                	li	a1,16
    80005480:	0007e503          	lwu	a0,0(a5)
    80005484:	df3ff0ef          	jal	80005276 <printint>
    80005488:	bdf5                	j	80005384 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    8000548a:	f8843783          	ld	a5,-120(s0)
    8000548e:	00878713          	addi	a4,a5,8
    80005492:	f8e43423          	sd	a4,-120(s0)
    80005496:	45c1                	li	a1,16
    80005498:	6388                	ld	a0,0(a5)
    8000549a:	dddff0ef          	jal	80005276 <printint>
      i += 1;
    8000549e:	002a049b          	addiw	s1,s4,2
    800054a2:	b5cd                	j	80005384 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800054a4:	f8843783          	ld	a5,-120(s0)
    800054a8:	00878713          	addi	a4,a5,8
    800054ac:	f8e43423          	sd	a4,-120(s0)
    800054b0:	4601                	li	a2,0
    800054b2:	45c1                	li	a1,16
    800054b4:	6388                	ld	a0,0(a5)
    800054b6:	dc1ff0ef          	jal	80005276 <printint>
      i += 2;
    800054ba:	003a049b          	addiw	s1,s4,3
    800054be:	b5d9                	j	80005384 <printf+0x78>
    800054c0:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800054c2:	f8843783          	ld	a5,-120(s0)
    800054c6:	00878713          	addi	a4,a5,8
    800054ca:	f8e43423          	sd	a4,-120(s0)
    800054ce:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800054d2:	03000513          	li	a0,48
    800054d6:	bb7ff0ef          	jal	8000508c <consputc>
  consputc('x');
    800054da:	07800513          	li	a0,120
    800054de:	bafff0ef          	jal	8000508c <consputc>
    800054e2:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800054e4:	00002c97          	auipc	s9,0x2
    800054e8:	324c8c93          	addi	s9,s9,804 # 80007808 <digits>
    800054ec:	03cad793          	srli	a5,s5,0x3c
    800054f0:	97e6                	add	a5,a5,s9
    800054f2:	0007c503          	lbu	a0,0(a5)
    800054f6:	b97ff0ef          	jal	8000508c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800054fa:	0a92                	slli	s5,s5,0x4
    800054fc:	3a7d                	addiw	s4,s4,-1
    800054fe:	fe0a17e3          	bnez	s4,800054ec <printf+0x1e0>
    80005502:	7ca2                	ld	s9,40(sp)
    80005504:	b541                	j	80005384 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80005506:	f8843783          	ld	a5,-120(s0)
    8000550a:	00878713          	addi	a4,a5,8
    8000550e:	f8e43423          	sd	a4,-120(s0)
    80005512:	4388                	lw	a0,0(a5)
    80005514:	b79ff0ef          	jal	8000508c <consputc>
    80005518:	b5b5                	j	80005384 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    8000551a:	f8843783          	ld	a5,-120(s0)
    8000551e:	00878713          	addi	a4,a5,8
    80005522:	f8e43423          	sd	a4,-120(s0)
    80005526:	0007ba03          	ld	s4,0(a5)
    8000552a:	000a0d63          	beqz	s4,80005544 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000552e:	000a4503          	lbu	a0,0(s4)
    80005532:	e40509e3          	beqz	a0,80005384 <printf+0x78>
        consputc(*s);
    80005536:	b57ff0ef          	jal	8000508c <consputc>
      for(; *s; s++)
    8000553a:	0a05                	addi	s4,s4,1
    8000553c:	000a4503          	lbu	a0,0(s4)
    80005540:	f97d                	bnez	a0,80005536 <printf+0x22a>
    80005542:	b589                	j	80005384 <printf+0x78>
        s = "(null)";
    80005544:	00002a17          	auipc	s4,0x2
    80005548:	174a0a13          	addi	s4,s4,372 # 800076b8 <etext+0x6b8>
      for(; *s; s++)
    8000554c:	02800513          	li	a0,40
    80005550:	b7dd                	j	80005536 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005552:	8556                	mv	a0,s5
    80005554:	b39ff0ef          	jal	8000508c <consputc>
    80005558:	b535                	j	80005384 <printf+0x78>
    8000555a:	74a6                	ld	s1,104(sp)
    8000555c:	69e6                	ld	s3,88(sp)
    8000555e:	6a46                	ld	s4,80(sp)
    80005560:	6aa6                	ld	s5,72(sp)
    80005562:	6b06                	ld	s6,64(sp)
    80005564:	7be2                	ld	s7,56(sp)
    80005566:	7c42                	ld	s8,48(sp)
    80005568:	7d02                	ld	s10,32(sp)
    8000556a:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000556c:	00002797          	auipc	a5,0x2
    80005570:	2e47a783          	lw	a5,740(a5) # 80007850 <panicking>
    80005574:	c38d                	beqz	a5,80005596 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80005576:	4501                	li	a0,0
    80005578:	70e6                	ld	ra,120(sp)
    8000557a:	7446                	ld	s0,112(sp)
    8000557c:	7906                	ld	s2,96(sp)
    8000557e:	6129                	addi	sp,sp,192
    80005580:	8082                	ret
    80005582:	74a6                	ld	s1,104(sp)
    80005584:	69e6                	ld	s3,88(sp)
    80005586:	6a46                	ld	s4,80(sp)
    80005588:	6aa6                	ld	s5,72(sp)
    8000558a:	6b06                	ld	s6,64(sp)
    8000558c:	7be2                	ld	s7,56(sp)
    8000558e:	7c42                	ld	s8,48(sp)
    80005590:	7d02                	ld	s10,32(sp)
    80005592:	6de2                	ld	s11,24(sp)
    80005594:	bfe1                	j	8000556c <printf+0x260>
    release(&pr.lock);
    80005596:	0001b517          	auipc	a0,0x1b
    8000559a:	5a250513          	addi	a0,a0,1442 # 80020b38 <pr>
    8000559e:	3ee000ef          	jal	8000598c <release>
  return 0;
    800055a2:	bfd1                	j	80005576 <printf+0x26a>
    if(c0 == 'd'){
    800055a4:	e37a8ee3          	beq	s5,s7,800053e0 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800055a8:	f94a8713          	addi	a4,s5,-108
    800055ac:	00173713          	seqz	a4,a4
    800055b0:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800055b2:	4781                	li	a5,0
    800055b4:	a00d                	j	800055d6 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800055b6:	f94a8713          	addi	a4,s5,-108
    800055ba:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800055be:	8656                	mv	a2,s5
    800055c0:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800055c2:	f9460793          	addi	a5,a2,-108
    800055c6:	0017b793          	seqz	a5,a5
    800055ca:	8ff9                	and	a5,a5,a4
    800055cc:	f9c68593          	addi	a1,a3,-100
    800055d0:	e199                	bnez	a1,800055d6 <printf+0x2ca>
    800055d2:	e20798e3          	bnez	a5,80005402 <printf+0xf6>
    } else if(c0 == 'u'){
    800055d6:	e58a84e3          	beq	s5,s8,8000541e <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    800055da:	f8b60593          	addi	a1,a2,-117
    800055de:	e199                	bnez	a1,800055e4 <printf+0x2d8>
    800055e0:	e4071ce3          	bnez	a4,80005438 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800055e4:	f8b68593          	addi	a1,a3,-117
    800055e8:	e199                	bnez	a1,800055ee <printf+0x2e2>
    800055ea:	e60795e3          	bnez	a5,80005454 <printf+0x148>
    } else if(c0 == 'x'){
    800055ee:	e9aa81e3          	beq	s5,s10,80005470 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    800055f2:	f8860613          	addi	a2,a2,-120
    800055f6:	e219                	bnez	a2,800055fc <printf+0x2f0>
    800055f8:	e80719e3          	bnez	a4,8000548a <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800055fc:	f8868693          	addi	a3,a3,-120
    80005600:	e299                	bnez	a3,80005606 <printf+0x2fa>
    80005602:	ea0791e3          	bnez	a5,800054a4 <printf+0x198>
    } else if(c0 == 'p'){
    80005606:	ebba8de3          	beq	s5,s11,800054c0 <printf+0x1b4>
    } else if(c0 == 'c'){
    8000560a:	06300793          	li	a5,99
    8000560e:	eefa8ce3          	beq	s5,a5,80005506 <printf+0x1fa>
    } else if(c0 == 's'){
    80005612:	07300793          	li	a5,115
    80005616:	f0fa82e3          	beq	s5,a5,8000551a <printf+0x20e>
    } else if(c0 == '%'){
    8000561a:	02500793          	li	a5,37
    8000561e:	f2fa8ae3          	beq	s5,a5,80005552 <printf+0x246>
    } else if(c0 == 0){
    80005622:	f60a80e3          	beqz	s5,80005582 <printf+0x276>
      consputc('%');
    80005626:	02500513          	li	a0,37
    8000562a:	a63ff0ef          	jal	8000508c <consputc>
      consputc(c0);
    8000562e:	8556                	mv	a0,s5
    80005630:	a5dff0ef          	jal	8000508c <consputc>
    80005634:	bb81                	j	80005384 <printf+0x78>

0000000080005636 <panic>:

void
panic(char *s)
{
    80005636:	1101                	addi	sp,sp,-32
    80005638:	ec06                	sd	ra,24(sp)
    8000563a:	e822                	sd	s0,16(sp)
    8000563c:	e426                	sd	s1,8(sp)
    8000563e:	e04a                	sd	s2,0(sp)
    80005640:	1000                	addi	s0,sp,32
    80005642:	892a                	mv	s2,a0
  panicking = 1;
    80005644:	4485                	li	s1,1
    80005646:	00002797          	auipc	a5,0x2
    8000564a:	2097a523          	sw	s1,522(a5) # 80007850 <panicking>
  printf("panic: ");
    8000564e:	00002517          	auipc	a0,0x2
    80005652:	07250513          	addi	a0,a0,114 # 800076c0 <etext+0x6c0>
    80005656:	cb7ff0ef          	jal	8000530c <printf>
  printf("%s\n", s);
    8000565a:	85ca                	mv	a1,s2
    8000565c:	00002517          	auipc	a0,0x2
    80005660:	06c50513          	addi	a0,a0,108 # 800076c8 <etext+0x6c8>
    80005664:	ca9ff0ef          	jal	8000530c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005668:	00002797          	auipc	a5,0x2
    8000566c:	1e97a223          	sw	s1,484(a5) # 8000784c <panicked>
  for(;;)
    80005670:	a001                	j	80005670 <panic+0x3a>

0000000080005672 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005672:	1141                	addi	sp,sp,-16
    80005674:	e406                	sd	ra,8(sp)
    80005676:	e022                	sd	s0,0(sp)
    80005678:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000567a:	00002597          	auipc	a1,0x2
    8000567e:	05658593          	addi	a1,a1,86 # 800076d0 <etext+0x6d0>
    80005682:	0001b517          	auipc	a0,0x1b
    80005686:	4b650513          	addi	a0,a0,1206 # 80020b38 <pr>
    8000568a:	1e4000ef          	jal	8000586e <initlock>
}
    8000568e:	60a2                	ld	ra,8(sp)
    80005690:	6402                	ld	s0,0(sp)
    80005692:	0141                	addi	sp,sp,16
    80005694:	8082                	ret

0000000080005696 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005696:	1141                	addi	sp,sp,-16
    80005698:	e406                	sd	ra,8(sp)
    8000569a:	e022                	sd	s0,0(sp)
    8000569c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000569e:	100007b7          	lui	a5,0x10000
    800056a2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800056a6:	10000737          	lui	a4,0x10000
    800056aa:	f8000693          	li	a3,-128
    800056ae:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800056b2:	468d                	li	a3,3
    800056b4:	10000637          	lui	a2,0x10000
    800056b8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800056bc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800056c0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800056c4:	8732                	mv	a4,a2
    800056c6:	461d                	li	a2,7
    800056c8:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800056cc:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800056d0:	00002597          	auipc	a1,0x2
    800056d4:	00858593          	addi	a1,a1,8 # 800076d8 <etext+0x6d8>
    800056d8:	0001b517          	auipc	a0,0x1b
    800056dc:	47850513          	addi	a0,a0,1144 # 80020b50 <tx_lock>
    800056e0:	18e000ef          	jal	8000586e <initlock>
}
    800056e4:	60a2                	ld	ra,8(sp)
    800056e6:	6402                	ld	s0,0(sp)
    800056e8:	0141                	addi	sp,sp,16
    800056ea:	8082                	ret

00000000800056ec <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800056ec:	715d                	addi	sp,sp,-80
    800056ee:	e486                	sd	ra,72(sp)
    800056f0:	e0a2                	sd	s0,64(sp)
    800056f2:	fc26                	sd	s1,56(sp)
    800056f4:	ec56                	sd	s5,24(sp)
    800056f6:	0880                	addi	s0,sp,80
    800056f8:	8aaa                	mv	s5,a0
    800056fa:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800056fc:	0001b517          	auipc	a0,0x1b
    80005700:	45450513          	addi	a0,a0,1108 # 80020b50 <tx_lock>
    80005704:	1f4000ef          	jal	800058f8 <acquire>

  int i = 0;
  while(i < n){ 
    80005708:	06905063          	blez	s1,80005768 <uartwrite+0x7c>
    8000570c:	f84a                	sd	s2,48(sp)
    8000570e:	f44e                	sd	s3,40(sp)
    80005710:	f052                	sd	s4,32(sp)
    80005712:	e85a                	sd	s6,16(sp)
    80005714:	e45e                	sd	s7,8(sp)
    80005716:	8a56                	mv	s4,s5
    80005718:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    8000571a:	00002497          	auipc	s1,0x2
    8000571e:	13e48493          	addi	s1,s1,318 # 80007858 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005722:	0001b997          	auipc	s3,0x1b
    80005726:	42e98993          	addi	s3,s3,1070 # 80020b50 <tx_lock>
    8000572a:	00002917          	auipc	s2,0x2
    8000572e:	12a90913          	addi	s2,s2,298 # 80007854 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005732:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005736:	4b05                	li	s6,1
    80005738:	a005                	j	80005758 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    8000573a:	85ce                	mv	a1,s3
    8000573c:	854a                	mv	a0,s2
    8000573e:	c55fb0ef          	jal	80001392 <sleep>
    while(tx_busy != 0){
    80005742:	409c                	lw	a5,0(s1)
    80005744:	fbfd                	bnez	a5,8000573a <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005746:	000a4783          	lbu	a5,0(s4)
    8000574a:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000574e:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005752:	0a05                	addi	s4,s4,1
    80005754:	015a0563          	beq	s4,s5,8000575e <uartwrite+0x72>
    while(tx_busy != 0){
    80005758:	409c                	lw	a5,0(s1)
    8000575a:	f3e5                	bnez	a5,8000573a <uartwrite+0x4e>
    8000575c:	b7ed                	j	80005746 <uartwrite+0x5a>
    8000575e:	7942                	ld	s2,48(sp)
    80005760:	79a2                	ld	s3,40(sp)
    80005762:	7a02                	ld	s4,32(sp)
    80005764:	6b42                	ld	s6,16(sp)
    80005766:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005768:	0001b517          	auipc	a0,0x1b
    8000576c:	3e850513          	addi	a0,a0,1000 # 80020b50 <tx_lock>
    80005770:	21c000ef          	jal	8000598c <release>
}
    80005774:	60a6                	ld	ra,72(sp)
    80005776:	6406                	ld	s0,64(sp)
    80005778:	74e2                	ld	s1,56(sp)
    8000577a:	6ae2                	ld	s5,24(sp)
    8000577c:	6161                	addi	sp,sp,80
    8000577e:	8082                	ret

0000000080005780 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005780:	1101                	addi	sp,sp,-32
    80005782:	ec06                	sd	ra,24(sp)
    80005784:	e822                	sd	s0,16(sp)
    80005786:	e426                	sd	s1,8(sp)
    80005788:	1000                	addi	s0,sp,32
    8000578a:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000578c:	00002797          	auipc	a5,0x2
    80005790:	0c47a783          	lw	a5,196(a5) # 80007850 <panicking>
    80005794:	cf95                	beqz	a5,800057d0 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005796:	00002797          	auipc	a5,0x2
    8000579a:	0b67a783          	lw	a5,182(a5) # 8000784c <panicked>
    8000579e:	ef85                	bnez	a5,800057d6 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800057a0:	10000737          	lui	a4,0x10000
    800057a4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800057a6:	00074783          	lbu	a5,0(a4)
    800057aa:	0207f793          	andi	a5,a5,32
    800057ae:	dfe5                	beqz	a5,800057a6 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    800057b0:	0ff4f513          	zext.b	a0,s1
    800057b4:	100007b7          	lui	a5,0x10000
    800057b8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800057bc:	00002797          	auipc	a5,0x2
    800057c0:	0947a783          	lw	a5,148(a5) # 80007850 <panicking>
    800057c4:	cb91                	beqz	a5,800057d8 <uartputc_sync+0x58>
    pop_off();
}
    800057c6:	60e2                	ld	ra,24(sp)
    800057c8:	6442                	ld	s0,16(sp)
    800057ca:	64a2                	ld	s1,8(sp)
    800057cc:	6105                	addi	sp,sp,32
    800057ce:	8082                	ret
    push_off();
    800057d0:	0e4000ef          	jal	800058b4 <push_off>
    800057d4:	b7c9                	j	80005796 <uartputc_sync+0x16>
    for(;;)
    800057d6:	a001                	j	800057d6 <uartputc_sync+0x56>
    pop_off();
    800057d8:	164000ef          	jal	8000593c <pop_off>
}
    800057dc:	b7ed                	j	800057c6 <uartputc_sync+0x46>

00000000800057de <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800057de:	1141                	addi	sp,sp,-16
    800057e0:	e406                	sd	ra,8(sp)
    800057e2:	e022                	sd	s0,0(sp)
    800057e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800057e6:	100007b7          	lui	a5,0x10000
    800057ea:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800057ee:	8b85                	andi	a5,a5,1
    800057f0:	cb89                	beqz	a5,80005802 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800057f2:	100007b7          	lui	a5,0x10000
    800057f6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800057fa:	60a2                	ld	ra,8(sp)
    800057fc:	6402                	ld	s0,0(sp)
    800057fe:	0141                	addi	sp,sp,16
    80005800:	8082                	ret
    return -1;
    80005802:	557d                	li	a0,-1
    80005804:	bfdd                	j	800057fa <uartgetc+0x1c>

0000000080005806 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005806:	1101                	addi	sp,sp,-32
    80005808:	ec06                	sd	ra,24(sp)
    8000580a:	e822                	sd	s0,16(sp)
    8000580c:	e426                	sd	s1,8(sp)
    8000580e:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005810:	100007b7          	lui	a5,0x10000
    80005814:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005818:	0001b517          	auipc	a0,0x1b
    8000581c:	33850513          	addi	a0,a0,824 # 80020b50 <tx_lock>
    80005820:	0d8000ef          	jal	800058f8 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005824:	100007b7          	lui	a5,0x10000
    80005828:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000582c:	0207f793          	andi	a5,a5,32
    80005830:	ef99                	bnez	a5,8000584e <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005832:	0001b517          	auipc	a0,0x1b
    80005836:	31e50513          	addi	a0,a0,798 # 80020b50 <tx_lock>
    8000583a:	152000ef          	jal	8000598c <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000583e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005840:	f9fff0ef          	jal	800057de <uartgetc>
    if(c == -1)
    80005844:	02950063          	beq	a0,s1,80005864 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005848:	877ff0ef          	jal	800050be <consoleintr>
  while(1){
    8000584c:	bfd5                	j	80005840 <uartintr+0x3a>
    tx_busy = 0;
    8000584e:	00002797          	auipc	a5,0x2
    80005852:	0007a523          	sw	zero,10(a5) # 80007858 <tx_busy>
    wakeup(&tx_chan);
    80005856:	00002517          	auipc	a0,0x2
    8000585a:	ffe50513          	addi	a0,a0,-2 # 80007854 <tx_chan>
    8000585e:	b81fb0ef          	jal	800013de <wakeup>
    80005862:	bfc1                	j	80005832 <uartintr+0x2c>
  }
}
    80005864:	60e2                	ld	ra,24(sp)
    80005866:	6442                	ld	s0,16(sp)
    80005868:	64a2                	ld	s1,8(sp)
    8000586a:	6105                	addi	sp,sp,32
    8000586c:	8082                	ret

000000008000586e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000586e:	1141                	addi	sp,sp,-16
    80005870:	e406                	sd	ra,8(sp)
    80005872:	e022                	sd	s0,0(sp)
    80005874:	0800                	addi	s0,sp,16
  lk->name = name;
    80005876:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005878:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000587c:	00053823          	sd	zero,16(a0)
}
    80005880:	60a2                	ld	ra,8(sp)
    80005882:	6402                	ld	s0,0(sp)
    80005884:	0141                	addi	sp,sp,16
    80005886:	8082                	ret

0000000080005888 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005888:	411c                	lw	a5,0(a0)
    8000588a:	e399                	bnez	a5,80005890 <holding+0x8>
    8000588c:	4501                	li	a0,0
  return r;
}
    8000588e:	8082                	ret
{
    80005890:	1101                	addi	sp,sp,-32
    80005892:	ec06                	sd	ra,24(sp)
    80005894:	e822                	sd	s0,16(sp)
    80005896:	e426                	sd	s1,8(sp)
    80005898:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000589a:	691c                	ld	a5,16(a0)
    8000589c:	84be                	mv	s1,a5
    8000589e:	cd6fb0ef          	jal	80000d74 <mycpu>
    800058a2:	40a48533          	sub	a0,s1,a0
    800058a6:	00153513          	seqz	a0,a0
}
    800058aa:	60e2                	ld	ra,24(sp)
    800058ac:	6442                	ld	s0,16(sp)
    800058ae:	64a2                	ld	s1,8(sp)
    800058b0:	6105                	addi	sp,sp,32
    800058b2:	8082                	ret

00000000800058b4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800058b4:	1101                	addi	sp,sp,-32
    800058b6:	ec06                	sd	ra,24(sp)
    800058b8:	e822                	sd	s0,16(sp)
    800058ba:	e426                	sd	s1,8(sp)
    800058bc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800058be:	100027f3          	csrr	a5,sstatus
    800058c2:	84be                	mv	s1,a5
    800058c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800058c8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800058ca:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    800058ce:	ca6fb0ef          	jal	80000d74 <mycpu>
    800058d2:	5d3c                	lw	a5,120(a0)
    800058d4:	cb99                	beqz	a5,800058ea <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800058d6:	c9efb0ef          	jal	80000d74 <mycpu>
    800058da:	5d3c                	lw	a5,120(a0)
    800058dc:	2785                	addiw	a5,a5,1
    800058de:	dd3c                	sw	a5,120(a0)
}
    800058e0:	60e2                	ld	ra,24(sp)
    800058e2:	6442                	ld	s0,16(sp)
    800058e4:	64a2                	ld	s1,8(sp)
    800058e6:	6105                	addi	sp,sp,32
    800058e8:	8082                	ret
    mycpu()->intena = old;
    800058ea:	c8afb0ef          	jal	80000d74 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800058ee:	0014d793          	srli	a5,s1,0x1
    800058f2:	8b85                	andi	a5,a5,1
    800058f4:	dd7c                	sw	a5,124(a0)
    800058f6:	b7c5                	j	800058d6 <push_off+0x22>

00000000800058f8 <acquire>:
{
    800058f8:	1101                	addi	sp,sp,-32
    800058fa:	ec06                	sd	ra,24(sp)
    800058fc:	e822                	sd	s0,16(sp)
    800058fe:	e426                	sd	s1,8(sp)
    80005900:	1000                	addi	s0,sp,32
    80005902:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005904:	fb1ff0ef          	jal	800058b4 <push_off>
  if(holding(lk))
    80005908:	8526                	mv	a0,s1
    8000590a:	f7fff0ef          	jal	80005888 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000590e:	4705                	li	a4,1
  if(holding(lk))
    80005910:	e105                	bnez	a0,80005930 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005912:	87ba                	mv	a5,a4
    80005914:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005918:	2781                	sext.w	a5,a5
    8000591a:	ffe5                	bnez	a5,80005912 <acquire+0x1a>
  __sync_synchronize();
    8000591c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005920:	c54fb0ef          	jal	80000d74 <mycpu>
    80005924:	e888                	sd	a0,16(s1)
}
    80005926:	60e2                	ld	ra,24(sp)
    80005928:	6442                	ld	s0,16(sp)
    8000592a:	64a2                	ld	s1,8(sp)
    8000592c:	6105                	addi	sp,sp,32
    8000592e:	8082                	ret
    panic("acquire");
    80005930:	00002517          	auipc	a0,0x2
    80005934:	db050513          	addi	a0,a0,-592 # 800076e0 <etext+0x6e0>
    80005938:	cffff0ef          	jal	80005636 <panic>

000000008000593c <pop_off>:

void
pop_off(void)
{
    8000593c:	1141                	addi	sp,sp,-16
    8000593e:	e406                	sd	ra,8(sp)
    80005940:	e022                	sd	s0,0(sp)
    80005942:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005944:	c30fb0ef          	jal	80000d74 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005948:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000594c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000594e:	e39d                	bnez	a5,80005974 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005950:	5d3c                	lw	a5,120(a0)
    80005952:	02f05763          	blez	a5,80005980 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005956:	37fd                	addiw	a5,a5,-1
    80005958:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    8000595a:	eb89                	bnez	a5,8000596c <pop_off+0x30>
    8000595c:	5d7c                	lw	a5,124(a0)
    8000595e:	c799                	beqz	a5,8000596c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005960:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005964:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005968:	10079073          	csrw	sstatus,a5
    intr_on();
}
    8000596c:	60a2                	ld	ra,8(sp)
    8000596e:	6402                	ld	s0,0(sp)
    80005970:	0141                	addi	sp,sp,16
    80005972:	8082                	ret
    panic("pop_off - interruptible");
    80005974:	00002517          	auipc	a0,0x2
    80005978:	d7450513          	addi	a0,a0,-652 # 800076e8 <etext+0x6e8>
    8000597c:	cbbff0ef          	jal	80005636 <panic>
    panic("pop_off");
    80005980:	00002517          	auipc	a0,0x2
    80005984:	d8050513          	addi	a0,a0,-640 # 80007700 <etext+0x700>
    80005988:	cafff0ef          	jal	80005636 <panic>

000000008000598c <release>:
{
    8000598c:	1101                	addi	sp,sp,-32
    8000598e:	ec06                	sd	ra,24(sp)
    80005990:	e822                	sd	s0,16(sp)
    80005992:	e426                	sd	s1,8(sp)
    80005994:	1000                	addi	s0,sp,32
    80005996:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005998:	ef1ff0ef          	jal	80005888 <holding>
    8000599c:	c105                	beqz	a0,800059bc <release+0x30>
  lk->cpu = 0;
    8000599e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800059a2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    800059a6:	0310000f          	fence	rw,w
    800059aa:	0004a023          	sw	zero,0(s1)
  pop_off();
    800059ae:	f8fff0ef          	jal	8000593c <pop_off>
}
    800059b2:	60e2                	ld	ra,24(sp)
    800059b4:	6442                	ld	s0,16(sp)
    800059b6:	64a2                	ld	s1,8(sp)
    800059b8:	6105                	addi	sp,sp,32
    800059ba:	8082                	ret
    panic("release");
    800059bc:	00002517          	auipc	a0,0x2
    800059c0:	d4c50513          	addi	a0,a0,-692 # 80007708 <etext+0x708>
    800059c4:	c73ff0ef          	jal	80005636 <panic>
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
