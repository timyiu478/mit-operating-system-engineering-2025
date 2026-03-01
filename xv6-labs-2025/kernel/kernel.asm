
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
    80000004:	2c010113          	addi	sp,sp,704 # 800192c0 <stack0>
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
    80000016:	791040ef          	jal	80004fa6 <start>

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
    8000002c:	37078793          	addi	a5,a5,880 # 80021398 <end>
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
    80000056:	83e90913          	addi	s2,s2,-1986 # 80007890 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	22f050ef          	jal	80005a8a <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	2b3050ef          	jal	80005b1e <release>
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
    80000084:	764050ef          	jal	800057e8 <panic>

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
    800000e4:	7b050513          	addi	a0,a0,1968 # 80007890 <kmem>
    800000e8:	119050ef          	jal	80005a00 <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	00021517          	auipc	a0,0x21
    800000f4:	2a850513          	addi	a0,a0,680 # 80021398 <end>
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
    80000112:	78250513          	addi	a0,a0,1922 # 80007890 <kmem>
    80000116:	175050ef          	jal	80005a8a <acquire>
  r = kmem.freelist;
    8000011a:	00007497          	auipc	s1,0x7
    8000011e:	78e4b483          	ld	s1,1934(s1) # 800078a8 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	00007717          	auipc	a4,0x7
    8000012a:	78f73123          	sd	a5,1922(a4) # 800078a8 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	00007517          	auipc	a0,0x7
    80000132:	76250513          	addi	a0,a0,1890 # 80007890 <kmem>
    80000136:	1e9050ef          	jal	80005b1e <release>

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
    80000154:	74050513          	addi	a0,a0,1856 # 80007890 <kmem>
    80000158:	1c7050ef          	jal	80005b1e <release>
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
    8000031c:	239000ef          	jal	80000d54 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000320:	00007717          	auipc	a4,0x7
    80000324:	54070713          	addi	a4,a4,1344 # 80007860 <started>
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
    80000334:	221000ef          	jal	80000d54 <cpuid>
    80000338:	85aa                	mv	a1,a0
    8000033a:	00007517          	auipc	a0,0x7
    8000033e:	cfe50513          	addi	a0,a0,-770 # 80007038 <etext+0x38>
    80000342:	0fa050ef          	jal	8000543c <printf>
    kvminithart();    // turn on paging
    80000346:	080000ef          	jal	800003c6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034a:	5d2010ef          	jal	8000191c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034e:	69a040ef          	jal	800049e8 <plicinithart>
  }

  scheduler();        
    80000352:	711000ef          	jal	80001262 <scheduler>
    consoleinit();
    80000356:	00c050ef          	jal	80005362 <consoleinit>
    printfinit();
    8000035a:	40c050ef          	jal	80005766 <printfinit>
    printf("\n");
    8000035e:	00007517          	auipc	a0,0x7
    80000362:	cba50513          	addi	a0,a0,-838 # 80007018 <etext+0x18>
    80000366:	0d6050ef          	jal	8000543c <printf>
    printf("xv6 kernel is booting\n");
    8000036a:	00007517          	auipc	a0,0x7
    8000036e:	cb650513          	addi	a0,a0,-842 # 80007020 <etext+0x20>
    80000372:	0ca050ef          	jal	8000543c <printf>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	0be050ef          	jal	8000543c <printf>
    kinit();         // physical page allocator
    80000382:	d4fff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    80000386:	2cc000ef          	jal	80000652 <kvminit>
    kvminithart();   // turn on paging
    8000038a:	03c000ef          	jal	800003c6 <kvminithart>
    procinit();      // process table
    8000038e:	117000ef          	jal	80000ca4 <procinit>
    trapinit();      // trap vectors
    80000392:	566010ef          	jal	800018f8 <trapinit>
    trapinithart();  // install kernel trap vector
    80000396:	586010ef          	jal	8000191c <trapinithart>
    plicinit();      // set up interrupt controller
    8000039a:	634040ef          	jal	800049ce <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039e:	64a040ef          	jal	800049e8 <plicinithart>
    binit();         // buffer cache
    800003a2:	4c1010ef          	jal	80002062 <binit>
    iinit();         // inode table
    800003a6:	212020ef          	jal	800025b8 <iinit>
    fileinit();      // file table
    800003aa:	13e030ef          	jal	800034e8 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	72a040ef          	jal	80004ad8 <virtio_disk_init>
    userinit();      // first user process
    800003b2:	4cd000ef          	jal	8000107e <userinit>
    __sync_synchronize();
    800003b6:	0330000f          	fence	rw,rw
    started = 1;
    800003ba:	4785                	li	a5,1
    800003bc:	00007717          	auipc	a4,0x7
    800003c0:	4af72223          	sw	a5,1188(a4) # 80007860 <started>
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
    800003d6:	4967b783          	ld	a5,1174(a5) # 80007868 <kernel_pagetable>
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
    80000460:	388050ef          	jal	800057e8 <panic>
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
    80000538:	2b0050ef          	jal	800057e8 <panic>
    panic("mappages: size not aligned");
    8000053c:	00007517          	auipc	a0,0x7
    80000540:	b3c50513          	addi	a0,a0,-1220 # 80007078 <etext+0x78>
    80000544:	2a4050ef          	jal	800057e8 <panic>
    panic("mappages: size");
    80000548:	00007517          	auipc	a0,0x7
    8000054c:	b5050513          	addi	a0,a0,-1200 # 80007098 <etext+0x98>
    80000550:	298050ef          	jal	800057e8 <panic>
      panic("mappages: remap");
    80000554:	00007517          	auipc	a0,0x7
    80000558:	b5450513          	addi	a0,a0,-1196 # 800070a8 <etext+0xa8>
    8000055c:	28c050ef          	jal	800057e8 <panic>
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
    800005a0:	248050ef          	jal	800057e8 <panic>

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
    80000662:	20a7b523          	sd	a0,522(a5) # 80007868 <kernel_pagetable>
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
    800006d6:	112050ef          	jal	800057e8 <panic>
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
    8000082c:	7bd040ef          	jal	800057e8 <panic>
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
    8000095a:	68f040ef          	jal	800057e8 <panic>

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
    80000a46:	342000ef          	jal	80000d88 <myproc>
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
    80000c24:	0c048493          	addi	s1,s1,192 # 80007ce0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c28:	8c26                	mv	s8,s1
    80000c2a:	1a1f67b7          	lui	a5,0x1a1f6
    80000c2e:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    80000c32:	7d634937          	lui	s2,0x7d634
    80000c36:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    80000c3a:	1902                	slli	s2,s2,0x20
    80000c3c:	993e                	add	s2,s2,a5
    80000c3e:	040009b7          	lui	s3,0x4000
    80000c42:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000c44:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c46:	4b99                	li	s7,6
    80000c48:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c4a:	0000da97          	auipc	s5,0xd
    80000c4e:	296a8a93          	addi	s5,s5,662 # 8000dee0 <tickslock>
    char *pa = kalloc();
    80000c52:	cb2ff0ef          	jal	80000104 <kalloc>
    80000c56:	862a                	mv	a2,a0
    if(pa == 0)
    80000c58:	c121                	beqz	a0,80000c98 <proc_mapstacks+0x92>
    uint64 va = KSTACK((int) (p - proc));
    80000c5a:	418485b3          	sub	a1,s1,s8
    80000c5e:	858d                	srai	a1,a1,0x3
    80000c60:	032585b3          	mul	a1,a1,s2
    80000c64:	05b6                	slli	a1,a1,0xd
    80000c66:	6789                	lui	a5,0x2
    80000c68:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c6a:	875e                	mv	a4,s7
    80000c6c:	86da                	mv	a3,s6
    80000c6e:	40b985b3          	sub	a1,s3,a1
    80000c72:	8552                	mv	a0,s4
    80000c74:	909ff0ef          	jal	8000057c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c78:	18848493          	addi	s1,s1,392
    80000c7c:	fd549be3          	bne	s1,s5,80000c52 <proc_mapstacks+0x4c>
  }
}
    80000c80:	60a6                	ld	ra,72(sp)
    80000c82:	6406                	ld	s0,64(sp)
    80000c84:	74e2                	ld	s1,56(sp)
    80000c86:	7942                	ld	s2,48(sp)
    80000c88:	79a2                	ld	s3,40(sp)
    80000c8a:	7a02                	ld	s4,32(sp)
    80000c8c:	6ae2                	ld	s5,24(sp)
    80000c8e:	6b42                	ld	s6,16(sp)
    80000c90:	6ba2                	ld	s7,8(sp)
    80000c92:	6c02                	ld	s8,0(sp)
    80000c94:	6161                	addi	sp,sp,80
    80000c96:	8082                	ret
      panic("kalloc");
    80000c98:	00006517          	auipc	a0,0x6
    80000c9c:	46050513          	addi	a0,a0,1120 # 800070f8 <etext+0xf8>
    80000ca0:	349040ef          	jal	800057e8 <panic>

0000000080000ca4 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000ca4:	7139                	addi	sp,sp,-64
    80000ca6:	fc06                	sd	ra,56(sp)
    80000ca8:	f822                	sd	s0,48(sp)
    80000caa:	f426                	sd	s1,40(sp)
    80000cac:	f04a                	sd	s2,32(sp)
    80000cae:	ec4e                	sd	s3,24(sp)
    80000cb0:	e852                	sd	s4,16(sp)
    80000cb2:	e456                	sd	s5,8(sp)
    80000cb4:	e05a                	sd	s6,0(sp)
    80000cb6:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cb8:	00006597          	auipc	a1,0x6
    80000cbc:	44858593          	addi	a1,a1,1096 # 80007100 <etext+0x100>
    80000cc0:	00007517          	auipc	a0,0x7
    80000cc4:	bf050513          	addi	a0,a0,-1040 # 800078b0 <pid_lock>
    80000cc8:	539040ef          	jal	80005a00 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000ccc:	00006597          	auipc	a1,0x6
    80000cd0:	43c58593          	addi	a1,a1,1084 # 80007108 <etext+0x108>
    80000cd4:	00007517          	auipc	a0,0x7
    80000cd8:	bf450513          	addi	a0,a0,-1036 # 800078c8 <wait_lock>
    80000cdc:	525040ef          	jal	80005a00 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce0:	00007497          	auipc	s1,0x7
    80000ce4:	00048493          	mv	s1,s1
      initlock(&p->lock, "proc");
    80000ce8:	00006b17          	auipc	s6,0x6
    80000cec:	430b0b13          	addi	s6,s6,1072 # 80007118 <etext+0x118>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000cf0:	8aa6                	mv	s5,s1
    80000cf2:	1a1f67b7          	lui	a5,0x1a1f6
    80000cf6:	8d178793          	addi	a5,a5,-1839 # 1a1f58d1 <_entry-0x65e0a72f>
    80000cfa:	7d634937          	lui	s2,0x7d634
    80000cfe:	3eb90913          	addi	s2,s2,1003 # 7d6343eb <_entry-0x29cbc15>
    80000d02:	1902                	slli	s2,s2,0x20
    80000d04:	993e                	add	s2,s2,a5
    80000d06:	040009b7          	lui	s3,0x4000
    80000d0a:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000d0c:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d0e:	0000da17          	auipc	s4,0xd
    80000d12:	1d2a0a13          	addi	s4,s4,466 # 8000dee0 <tickslock>
      initlock(&p->lock, "proc");
    80000d16:	85da                	mv	a1,s6
    80000d18:	8526                	mv	a0,s1
    80000d1a:	4e7040ef          	jal	80005a00 <initlock>
      p->state = UNUSED;
    80000d1e:	0004ac23          	sw	zero,24(s1) # 80007cf8 <proc+0x18>
      p->kstack = KSTACK((int) (p - proc));
    80000d22:	415487b3          	sub	a5,s1,s5
    80000d26:	878d                	srai	a5,a5,0x3
    80000d28:	032787b3          	mul	a5,a5,s2
    80000d2c:	07b6                	slli	a5,a5,0xd
    80000d2e:	6709                	lui	a4,0x2
    80000d30:	9fb9                	addw	a5,a5,a4
    80000d32:	40f987b3          	sub	a5,s3,a5
    80000d36:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d38:	18848493          	addi	s1,s1,392
    80000d3c:	fd449de3          	bne	s1,s4,80000d16 <procinit+0x72>
  }
}
    80000d40:	70e2                	ld	ra,56(sp)
    80000d42:	7442                	ld	s0,48(sp)
    80000d44:	74a2                	ld	s1,40(sp)
    80000d46:	7902                	ld	s2,32(sp)
    80000d48:	69e2                	ld	s3,24(sp)
    80000d4a:	6a42                	ld	s4,16(sp)
    80000d4c:	6aa2                	ld	s5,8(sp)
    80000d4e:	6b02                	ld	s6,0(sp)
    80000d50:	6121                	addi	sp,sp,64
    80000d52:	8082                	ret

0000000080000d54 <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d54:	1141                	addi	sp,sp,-16
    80000d56:	e406                	sd	ra,8(sp)
    80000d58:	e022                	sd	s0,0(sp)
    80000d5a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d5c:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d5e:	2501                	sext.w	a0,a0
    80000d60:	60a2                	ld	ra,8(sp)
    80000d62:	6402                	ld	s0,0(sp)
    80000d64:	0141                	addi	sp,sp,16
    80000d66:	8082                	ret

0000000080000d68 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d68:	1141                	addi	sp,sp,-16
    80000d6a:	e406                	sd	ra,8(sp)
    80000d6c:	e022                	sd	s0,0(sp)
    80000d6e:	0800                	addi	s0,sp,16
    80000d70:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d72:	2781                	sext.w	a5,a5
    80000d74:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d76:	00007517          	auipc	a0,0x7
    80000d7a:	b6a50513          	addi	a0,a0,-1174 # 800078e0 <cpus>
    80000d7e:	953e                	add	a0,a0,a5
    80000d80:	60a2                	ld	ra,8(sp)
    80000d82:	6402                	ld	s0,0(sp)
    80000d84:	0141                	addi	sp,sp,16
    80000d86:	8082                	ret

0000000080000d88 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d88:	1101                	addi	sp,sp,-32
    80000d8a:	ec06                	sd	ra,24(sp)
    80000d8c:	e822                	sd	s0,16(sp)
    80000d8e:	e426                	sd	s1,8(sp)
    80000d90:	1000                	addi	s0,sp,32
  push_off();
    80000d92:	4b5040ef          	jal	80005a46 <push_off>
    80000d96:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d98:	2781                	sext.w	a5,a5
    80000d9a:	079e                	slli	a5,a5,0x7
    80000d9c:	00007717          	auipc	a4,0x7
    80000da0:	b1470713          	addi	a4,a4,-1260 # 800078b0 <pid_lock>
    80000da4:	97ba                	add	a5,a5,a4
    80000da6:	7b9c                	ld	a5,48(a5)
    80000da8:	84be                	mv	s1,a5
  pop_off();
    80000daa:	525040ef          	jal	80005ace <pop_off>
  return p;
}
    80000dae:	8526                	mv	a0,s1
    80000db0:	60e2                	ld	ra,24(sp)
    80000db2:	6442                	ld	s0,16(sp)
    80000db4:	64a2                	ld	s1,8(sp)
    80000db6:	6105                	addi	sp,sp,32
    80000db8:	8082                	ret

0000000080000dba <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000dba:	7179                	addi	sp,sp,-48
    80000dbc:	f406                	sd	ra,40(sp)
    80000dbe:	f022                	sd	s0,32(sp)
    80000dc0:	ec26                	sd	s1,24(sp)
    80000dc2:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000dc4:	fc5ff0ef          	jal	80000d88 <myproc>
    80000dc8:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000dca:	555040ef          	jal	80005b1e <release>

  if (first) {
    80000dce:	00007797          	auipc	a5,0x7
    80000dd2:	a827a783          	lw	a5,-1406(a5) # 80007850 <first.1>
    80000dd6:	cf95                	beqz	a5,80000e12 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dd8:	4505                	li	a0,1
    80000dda:	49b010ef          	jal	80002a74 <fsinit>

    first = 0;
    80000dde:	00007797          	auipc	a5,0x7
    80000de2:	a607a923          	sw	zero,-1422(a5) # 80007850 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000de6:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000dea:	00006797          	auipc	a5,0x6
    80000dee:	33678793          	addi	a5,a5,822 # 80007120 <etext+0x120>
    80000df2:	fcf43823          	sd	a5,-48(s0)
    80000df6:	fc043c23          	sd	zero,-40(s0)
    80000dfa:	fd040593          	addi	a1,s0,-48
    80000dfe:	853e                	mv	a0,a5
    80000e00:	5f3020ef          	jal	80003bf2 <kexec>
    80000e04:	6cbc                	ld	a5,88(s1)
    80000e06:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000e08:	6cbc                	ld	a5,88(s1)
    80000e0a:	7bb8                	ld	a4,112(a5)
    80000e0c:	57fd                	li	a5,-1
    80000e0e:	02f70d63          	beq	a4,a5,80000e48 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e12:	327000ef          	jal	80001938 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e16:	68a8                	ld	a0,80(s1)
    80000e18:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e1a:	04000737          	lui	a4,0x4000
    80000e1e:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e20:	0732                	slli	a4,a4,0xc
    80000e22:	00005797          	auipc	a5,0x5
    80000e26:	27a78793          	addi	a5,a5,634 # 8000609c <userret>
    80000e2a:	00005697          	auipc	a3,0x5
    80000e2e:	1d668693          	addi	a3,a3,470 # 80006000 <_trampoline>
    80000e32:	8f95                	sub	a5,a5,a3
    80000e34:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e36:	577d                	li	a4,-1
    80000e38:	177e                	slli	a4,a4,0x3f
    80000e3a:	8d59                	or	a0,a0,a4
    80000e3c:	9782                	jalr	a5
}
    80000e3e:	70a2                	ld	ra,40(sp)
    80000e40:	7402                	ld	s0,32(sp)
    80000e42:	64e2                	ld	s1,24(sp)
    80000e44:	6145                	addi	sp,sp,48
    80000e46:	8082                	ret
      panic("exec");
    80000e48:	00006517          	auipc	a0,0x6
    80000e4c:	2e050513          	addi	a0,a0,736 # 80007128 <etext+0x128>
    80000e50:	199040ef          	jal	800057e8 <panic>

0000000080000e54 <allocpid>:
{
    80000e54:	1101                	addi	sp,sp,-32
    80000e56:	ec06                	sd	ra,24(sp)
    80000e58:	e822                	sd	s0,16(sp)
    80000e5a:	e426                	sd	s1,8(sp)
    80000e5c:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e5e:	00007517          	auipc	a0,0x7
    80000e62:	a5250513          	addi	a0,a0,-1454 # 800078b0 <pid_lock>
    80000e66:	425040ef          	jal	80005a8a <acquire>
  pid = nextpid;
    80000e6a:	00007797          	auipc	a5,0x7
    80000e6e:	9ea78793          	addi	a5,a5,-1558 # 80007854 <nextpid>
    80000e72:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e74:	0014871b          	addiw	a4,s1,1
    80000e78:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e7a:	00007517          	auipc	a0,0x7
    80000e7e:	a3650513          	addi	a0,a0,-1482 # 800078b0 <pid_lock>
    80000e82:	49d040ef          	jal	80005b1e <release>
}
    80000e86:	8526                	mv	a0,s1
    80000e88:	60e2                	ld	ra,24(sp)
    80000e8a:	6442                	ld	s0,16(sp)
    80000e8c:	64a2                	ld	s1,8(sp)
    80000e8e:	6105                	addi	sp,sp,32
    80000e90:	8082                	ret

0000000080000e92 <proc_pagetable>:
{
    80000e92:	1101                	addi	sp,sp,-32
    80000e94:	ec06                	sd	ra,24(sp)
    80000e96:	e822                	sd	s0,16(sp)
    80000e98:	e426                	sd	s1,8(sp)
    80000e9a:	e04a                	sd	s2,0(sp)
    80000e9c:	1000                	addi	s0,sp,32
    80000e9e:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000ea0:	fceff0ef          	jal	8000066e <uvmcreate>
    80000ea4:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000ea6:	cd05                	beqz	a0,80000ede <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000ea8:	4729                	li	a4,10
    80000eaa:	00005697          	auipc	a3,0x5
    80000eae:	15668693          	addi	a3,a3,342 # 80006000 <_trampoline>
    80000eb2:	6605                	lui	a2,0x1
    80000eb4:	040005b7          	lui	a1,0x4000
    80000eb8:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eba:	05b2                	slli	a1,a1,0xc
    80000ebc:	e0aff0ef          	jal	800004c6 <mappages>
    80000ec0:	02054663          	bltz	a0,80000eec <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000ec4:	4719                	li	a4,6
    80000ec6:	05893683          	ld	a3,88(s2)
    80000eca:	6605                	lui	a2,0x1
    80000ecc:	020005b7          	lui	a1,0x2000
    80000ed0:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ed2:	05b6                	slli	a1,a1,0xd
    80000ed4:	8526                	mv	a0,s1
    80000ed6:	df0ff0ef          	jal	800004c6 <mappages>
    80000eda:	00054f63          	bltz	a0,80000ef8 <proc_pagetable+0x66>
}
    80000ede:	8526                	mv	a0,s1
    80000ee0:	60e2                	ld	ra,24(sp)
    80000ee2:	6442                	ld	s0,16(sp)
    80000ee4:	64a2                	ld	s1,8(sp)
    80000ee6:	6902                	ld	s2,0(sp)
    80000ee8:	6105                	addi	sp,sp,32
    80000eea:	8082                	ret
    uvmfree(pagetable, 0);
    80000eec:	4581                	li	a1,0
    80000eee:	8526                	mv	a0,s1
    80000ef0:	979ff0ef          	jal	80000868 <uvmfree>
    return 0;
    80000ef4:	4481                	li	s1,0
    80000ef6:	b7e5                	j	80000ede <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000ef8:	4681                	li	a3,0
    80000efa:	4605                	li	a2,1
    80000efc:	040005b7          	lui	a1,0x4000
    80000f00:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f02:	05b2                	slli	a1,a1,0xc
    80000f04:	8526                	mv	a0,s1
    80000f06:	f8eff0ef          	jal	80000694 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f0a:	4581                	li	a1,0
    80000f0c:	8526                	mv	a0,s1
    80000f0e:	95bff0ef          	jal	80000868 <uvmfree>
    return 0;
    80000f12:	4481                	li	s1,0
    80000f14:	b7e9                	j	80000ede <proc_pagetable+0x4c>

0000000080000f16 <proc_freepagetable>:
{
    80000f16:	1101                	addi	sp,sp,-32
    80000f18:	ec06                	sd	ra,24(sp)
    80000f1a:	e822                	sd	s0,16(sp)
    80000f1c:	e426                	sd	s1,8(sp)
    80000f1e:	e04a                	sd	s2,0(sp)
    80000f20:	1000                	addi	s0,sp,32
    80000f22:	84aa                	mv	s1,a0
    80000f24:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f26:	4681                	li	a3,0
    80000f28:	4605                	li	a2,1
    80000f2a:	040005b7          	lui	a1,0x4000
    80000f2e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f30:	05b2                	slli	a1,a1,0xc
    80000f32:	f62ff0ef          	jal	80000694 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f36:	4681                	li	a3,0
    80000f38:	4605                	li	a2,1
    80000f3a:	020005b7          	lui	a1,0x2000
    80000f3e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f40:	05b6                	slli	a1,a1,0xd
    80000f42:	8526                	mv	a0,s1
    80000f44:	f50ff0ef          	jal	80000694 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f48:	85ca                	mv	a1,s2
    80000f4a:	8526                	mv	a0,s1
    80000f4c:	91dff0ef          	jal	80000868 <uvmfree>
}
    80000f50:	60e2                	ld	ra,24(sp)
    80000f52:	6442                	ld	s0,16(sp)
    80000f54:	64a2                	ld	s1,8(sp)
    80000f56:	6902                	ld	s2,0(sp)
    80000f58:	6105                	addi	sp,sp,32
    80000f5a:	8082                	ret

0000000080000f5c <freeproc>:
{
    80000f5c:	1101                	addi	sp,sp,-32
    80000f5e:	ec06                	sd	ra,24(sp)
    80000f60:	e822                	sd	s0,16(sp)
    80000f62:	e426                	sd	s1,8(sp)
    80000f64:	1000                	addi	s0,sp,32
    80000f66:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f68:	6d28                	ld	a0,88(a0)
    80000f6a:	c119                	beqz	a0,80000f70 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f6c:	8b0ff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f70:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f74:	68a8                	ld	a0,80(s1)
    80000f76:	c501                	beqz	a0,80000f7e <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f78:	64ac                	ld	a1,72(s1)
    80000f7a:	f9dff0ef          	jal	80000f16 <proc_freepagetable>
  p->pagetable = 0;
    80000f7e:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f82:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f86:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f8a:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f8e:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f92:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f96:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f9a:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f9e:	0004ac23          	sw	zero,24(s1)
}
    80000fa2:	60e2                	ld	ra,24(sp)
    80000fa4:	6442                	ld	s0,16(sp)
    80000fa6:	64a2                	ld	s1,8(sp)
    80000fa8:	6105                	addi	sp,sp,32
    80000faa:	8082                	ret

0000000080000fac <allocproc>:
{
    80000fac:	1101                	addi	sp,sp,-32
    80000fae:	ec06                	sd	ra,24(sp)
    80000fb0:	e822                	sd	s0,16(sp)
    80000fb2:	e426                	sd	s1,8(sp)
    80000fb4:	e04a                	sd	s2,0(sp)
    80000fb6:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb8:	00007497          	auipc	s1,0x7
    80000fbc:	d2848493          	addi	s1,s1,-728 # 80007ce0 <proc>
    80000fc0:	0000d917          	auipc	s2,0xd
    80000fc4:	f2090913          	addi	s2,s2,-224 # 8000dee0 <tickslock>
    acquire(&p->lock);
    80000fc8:	8526                	mv	a0,s1
    80000fca:	2c1040ef          	jal	80005a8a <acquire>
    if(p->state == UNUSED) {
    80000fce:	4c9c                	lw	a5,24(s1)
    80000fd0:	cb91                	beqz	a5,80000fe4 <allocproc+0x38>
      release(&p->lock);
    80000fd2:	8526                	mv	a0,s1
    80000fd4:	34b040ef          	jal	80005b1e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fd8:	18848493          	addi	s1,s1,392
    80000fdc:	ff2496e3          	bne	s1,s2,80000fc8 <allocproc+0x1c>
  return 0;
    80000fe0:	4481                	li	s1,0
    80000fe2:	a8b9                	j	80001040 <allocproc+0x94>
  p->pid = allocpid();
    80000fe4:	e71ff0ef          	jal	80000e54 <allocpid>
    80000fe8:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fea:	4785                	li	a5,1
    80000fec:	cc9c                	sw	a5,24(s1)
  p->ticks = 0;
    80000fee:	1604a423          	sw	zero,360(s1)
  p->handler = 0;
    80000ff2:	1604bc23          	sd	zero,376(s1)
  p->interval = 0;
    80000ff6:	1604a623          	sw	zero,364(s1)
  p->sigreturn = true;
    80000ffa:	16f48823          	sb	a5,368(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000ffe:	906ff0ef          	jal	80000104 <kalloc>
    80001002:	892a                	mv	s2,a0
    80001004:	eca8                	sd	a0,88(s1)
    80001006:	c521                	beqz	a0,8000104e <allocproc+0xa2>
  if((p->saved_trapframe = (struct trapframe *)kalloc()) == 0){
    80001008:	8fcff0ef          	jal	80000104 <kalloc>
    8000100c:	892a                	mv	s2,a0
    8000100e:	18a4b023          	sd	a0,384(s1)
    80001012:	c531                	beqz	a0,8000105e <allocproc+0xb2>
  p->pagetable = proc_pagetable(p);
    80001014:	8526                	mv	a0,s1
    80001016:	e7dff0ef          	jal	80000e92 <proc_pagetable>
    8000101a:	892a                	mv	s2,a0
    8000101c:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000101e:	c921                	beqz	a0,8000106e <allocproc+0xc2>
  memset(&p->context, 0, sizeof(p->context));
    80001020:	07000613          	li	a2,112
    80001024:	4581                	li	a1,0
    80001026:	06048513          	addi	a0,s1,96
    8000102a:	934ff0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    8000102e:	00000797          	auipc	a5,0x0
    80001032:	d8c78793          	addi	a5,a5,-628 # 80000dba <forkret>
    80001036:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001038:	60bc                	ld	a5,64(s1)
    8000103a:	6705                	lui	a4,0x1
    8000103c:	97ba                	add	a5,a5,a4
    8000103e:	f4bc                	sd	a5,104(s1)
}
    80001040:	8526                	mv	a0,s1
    80001042:	60e2                	ld	ra,24(sp)
    80001044:	6442                	ld	s0,16(sp)
    80001046:	64a2                	ld	s1,8(sp)
    80001048:	6902                	ld	s2,0(sp)
    8000104a:	6105                	addi	sp,sp,32
    8000104c:	8082                	ret
    freeproc(p);
    8000104e:	8526                	mv	a0,s1
    80001050:	f0dff0ef          	jal	80000f5c <freeproc>
    release(&p->lock);
    80001054:	8526                	mv	a0,s1
    80001056:	2c9040ef          	jal	80005b1e <release>
    return 0;
    8000105a:	84ca                	mv	s1,s2
    8000105c:	b7d5                	j	80001040 <allocproc+0x94>
    freeproc(p);
    8000105e:	8526                	mv	a0,s1
    80001060:	efdff0ef          	jal	80000f5c <freeproc>
    release(&p->lock);
    80001064:	8526                	mv	a0,s1
    80001066:	2b9040ef          	jal	80005b1e <release>
    return 0;
    8000106a:	84ca                	mv	s1,s2
    8000106c:	bfd1                	j	80001040 <allocproc+0x94>
    freeproc(p);
    8000106e:	8526                	mv	a0,s1
    80001070:	eedff0ef          	jal	80000f5c <freeproc>
    release(&p->lock);
    80001074:	8526                	mv	a0,s1
    80001076:	2a9040ef          	jal	80005b1e <release>
    return 0;
    8000107a:	84ca                	mv	s1,s2
    8000107c:	b7d1                	j	80001040 <allocproc+0x94>

000000008000107e <userinit>:
{
    8000107e:	1101                	addi	sp,sp,-32
    80001080:	ec06                	sd	ra,24(sp)
    80001082:	e822                	sd	s0,16(sp)
    80001084:	e426                	sd	s1,8(sp)
    80001086:	1000                	addi	s0,sp,32
  p = allocproc();
    80001088:	f25ff0ef          	jal	80000fac <allocproc>
    8000108c:	84aa                	mv	s1,a0
  initproc = p;
    8000108e:	00006797          	auipc	a5,0x6
    80001092:	7ea7b123          	sd	a0,2018(a5) # 80007870 <initproc>
  p->cwd = namei("/");
    80001096:	00006517          	auipc	a0,0x6
    8000109a:	09a50513          	addi	a0,a0,154 # 80007130 <etext+0x130>
    8000109e:	711010ef          	jal	80002fae <namei>
    800010a2:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800010a6:	478d                	li	a5,3
    800010a8:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800010aa:	8526                	mv	a0,s1
    800010ac:	273040ef          	jal	80005b1e <release>
}
    800010b0:	60e2                	ld	ra,24(sp)
    800010b2:	6442                	ld	s0,16(sp)
    800010b4:	64a2                	ld	s1,8(sp)
    800010b6:	6105                	addi	sp,sp,32
    800010b8:	8082                	ret

00000000800010ba <growproc>:
{
    800010ba:	1101                	addi	sp,sp,-32
    800010bc:	ec06                	sd	ra,24(sp)
    800010be:	e822                	sd	s0,16(sp)
    800010c0:	e426                	sd	s1,8(sp)
    800010c2:	e04a                	sd	s2,0(sp)
    800010c4:	1000                	addi	s0,sp,32
    800010c6:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800010c8:	cc1ff0ef          	jal	80000d88 <myproc>
    800010cc:	84aa                	mv	s1,a0
  sz = p->sz;
    800010ce:	652c                	ld	a1,72(a0)
  if(n > 0){
    800010d0:	01204c63          	bgtz	s2,800010e8 <growproc+0x2e>
  } else if(n < 0){
    800010d4:	02094463          	bltz	s2,800010fc <growproc+0x42>
  p->sz = sz;
    800010d8:	e4ac                	sd	a1,72(s1)
  return 0;
    800010da:	4501                	li	a0,0
}
    800010dc:	60e2                	ld	ra,24(sp)
    800010de:	6442                	ld	s0,16(sp)
    800010e0:	64a2                	ld	s1,8(sp)
    800010e2:	6902                	ld	s2,0(sp)
    800010e4:	6105                	addi	sp,sp,32
    800010e6:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010e8:	4691                	li	a3,4
    800010ea:	00b90633          	add	a2,s2,a1
    800010ee:	6928                	ld	a0,80(a0)
    800010f0:	e72ff0ef          	jal	80000762 <uvmalloc>
    800010f4:	85aa                	mv	a1,a0
    800010f6:	f16d                	bnez	a0,800010d8 <growproc+0x1e>
      return -1;
    800010f8:	557d                	li	a0,-1
    800010fa:	b7cd                	j	800010dc <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010fc:	00b90633          	add	a2,s2,a1
    80001100:	6928                	ld	a0,80(a0)
    80001102:	e1cff0ef          	jal	8000071e <uvmdealloc>
    80001106:	85aa                	mv	a1,a0
    80001108:	bfc1                	j	800010d8 <growproc+0x1e>

000000008000110a <kfork>:
{
    8000110a:	7139                	addi	sp,sp,-64
    8000110c:	fc06                	sd	ra,56(sp)
    8000110e:	f822                	sd	s0,48(sp)
    80001110:	f426                	sd	s1,40(sp)
    80001112:	e456                	sd	s5,8(sp)
    80001114:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001116:	c73ff0ef          	jal	80000d88 <myproc>
    8000111a:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000111c:	e91ff0ef          	jal	80000fac <allocproc>
    80001120:	12050f63          	beqz	a0,8000125e <kfork+0x154>
    80001124:	ec4e                	sd	s3,24(sp)
    80001126:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001128:	048ab603          	ld	a2,72(s5)
    8000112c:	692c                	ld	a1,80(a0)
    8000112e:	050ab503          	ld	a0,80(s5)
    80001132:	f68ff0ef          	jal	8000089a <uvmcopy>
    80001136:	08054d63          	bltz	a0,800011d0 <kfork+0xc6>
    8000113a:	f04a                	sd	s2,32(sp)
    8000113c:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    8000113e:	048ab783          	ld	a5,72(s5)
    80001142:	04f9b423          	sd	a5,72(s3)
  np->interval = p->interval;
    80001146:	16caa783          	lw	a5,364(s5)
    8000114a:	16f9a623          	sw	a5,364(s3)
  np->handler = p->handler;
    8000114e:	178ab783          	ld	a5,376(s5)
    80001152:	16f9bc23          	sd	a5,376(s3)
  np->ticks = p->ticks;
    80001156:	168aa783          	lw	a5,360(s5)
    8000115a:	16f9a423          	sw	a5,360(s3)
  np->sigreturn = p->sigreturn;
    8000115e:	170ac783          	lbu	a5,368(s5)
    80001162:	16f98823          	sb	a5,368(s3)
  *(np->trapframe) = *(p->trapframe);
    80001166:	058ab683          	ld	a3,88(s5)
    8000116a:	87b6                	mv	a5,a3
    8000116c:	0589b703          	ld	a4,88(s3)
    80001170:	12068693          	addi	a3,a3,288
    80001174:	6388                	ld	a0,0(a5)
    80001176:	678c                	ld	a1,8(a5)
    80001178:	6b90                	ld	a2,16(a5)
    8000117a:	e308                	sd	a0,0(a4)
    8000117c:	e70c                	sd	a1,8(a4)
    8000117e:	eb10                	sd	a2,16(a4)
    80001180:	6f90                	ld	a2,24(a5)
    80001182:	ef10                	sd	a2,24(a4)
    80001184:	02078793          	addi	a5,a5,32
    80001188:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    8000118c:	fed794e3          	bne	a5,a3,80001174 <kfork+0x6a>
  *(np->saved_trapframe) = *(p->saved_trapframe);
    80001190:	180ab683          	ld	a3,384(s5)
    80001194:	87b6                	mv	a5,a3
    80001196:	1809b703          	ld	a4,384(s3)
    8000119a:	12068693          	addi	a3,a3,288
    8000119e:	6388                	ld	a0,0(a5)
    800011a0:	678c                	ld	a1,8(a5)
    800011a2:	6b90                	ld	a2,16(a5)
    800011a4:	e308                	sd	a0,0(a4)
    800011a6:	e70c                	sd	a1,8(a4)
    800011a8:	eb10                	sd	a2,16(a4)
    800011aa:	6f90                	ld	a2,24(a5)
    800011ac:	ef10                	sd	a2,24(a4)
    800011ae:	02078793          	addi	a5,a5,32
    800011b2:	02070713          	addi	a4,a4,32
    800011b6:	fed794e3          	bne	a5,a3,8000119e <kfork+0x94>
  np->trapframe->a0 = 0;
    800011ba:	0589b783          	ld	a5,88(s3)
    800011be:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800011c2:	0d0a8493          	addi	s1,s5,208
    800011c6:	0d098913          	addi	s2,s3,208
    800011ca:	150a8a13          	addi	s4,s5,336
    800011ce:	a831                	j	800011ea <kfork+0xe0>
    freeproc(np);
    800011d0:	854e                	mv	a0,s3
    800011d2:	d8bff0ef          	jal	80000f5c <freeproc>
    release(&np->lock);
    800011d6:	854e                	mv	a0,s3
    800011d8:	147040ef          	jal	80005b1e <release>
    return -1;
    800011dc:	54fd                	li	s1,-1
    800011de:	69e2                	ld	s3,24(sp)
    800011e0:	a885                	j	80001250 <kfork+0x146>
  for(i = 0; i < NOFILE; i++)
    800011e2:	04a1                	addi	s1,s1,8
    800011e4:	0921                	addi	s2,s2,8
    800011e6:	01448963          	beq	s1,s4,800011f8 <kfork+0xee>
    if(p->ofile[i])
    800011ea:	6088                	ld	a0,0(s1)
    800011ec:	d97d                	beqz	a0,800011e2 <kfork+0xd8>
      np->ofile[i] = filedup(p->ofile[i]);
    800011ee:	37c020ef          	jal	8000356a <filedup>
    800011f2:	00a93023          	sd	a0,0(s2)
    800011f6:	b7f5                	j	800011e2 <kfork+0xd8>
  np->cwd = idup(p->cwd);
    800011f8:	150ab503          	ld	a0,336(s5)
    800011fc:	54e010ef          	jal	8000274a <idup>
    80001200:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001204:	4641                	li	a2,16
    80001206:	158a8593          	addi	a1,s5,344
    8000120a:	15898513          	addi	a0,s3,344
    8000120e:	8a4ff0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    80001212:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    80001216:	854e                	mv	a0,s3
    80001218:	107040ef          	jal	80005b1e <release>
  acquire(&wait_lock);
    8000121c:	00006517          	auipc	a0,0x6
    80001220:	6ac50513          	addi	a0,a0,1708 # 800078c8 <wait_lock>
    80001224:	067040ef          	jal	80005a8a <acquire>
  np->parent = p;
    80001228:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    8000122c:	00006517          	auipc	a0,0x6
    80001230:	69c50513          	addi	a0,a0,1692 # 800078c8 <wait_lock>
    80001234:	0eb040ef          	jal	80005b1e <release>
  acquire(&np->lock);
    80001238:	854e                	mv	a0,s3
    8000123a:	051040ef          	jal	80005a8a <acquire>
  np->state = RUNNABLE;
    8000123e:	478d                	li	a5,3
    80001240:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    80001244:	854e                	mv	a0,s3
    80001246:	0d9040ef          	jal	80005b1e <release>
  return pid;
    8000124a:	7902                	ld	s2,32(sp)
    8000124c:	69e2                	ld	s3,24(sp)
    8000124e:	6a42                	ld	s4,16(sp)
}
    80001250:	8526                	mv	a0,s1
    80001252:	70e2                	ld	ra,56(sp)
    80001254:	7442                	ld	s0,48(sp)
    80001256:	74a2                	ld	s1,40(sp)
    80001258:	6aa2                	ld	s5,8(sp)
    8000125a:	6121                	addi	sp,sp,64
    8000125c:	8082                	ret
    return -1;
    8000125e:	54fd                	li	s1,-1
    80001260:	bfc5                	j	80001250 <kfork+0x146>

0000000080001262 <scheduler>:
{
    80001262:	715d                	addi	sp,sp,-80
    80001264:	e486                	sd	ra,72(sp)
    80001266:	e0a2                	sd	s0,64(sp)
    80001268:	fc26                	sd	s1,56(sp)
    8000126a:	f84a                	sd	s2,48(sp)
    8000126c:	f44e                	sd	s3,40(sp)
    8000126e:	f052                	sd	s4,32(sp)
    80001270:	ec56                	sd	s5,24(sp)
    80001272:	e85a                	sd	s6,16(sp)
    80001274:	e45e                	sd	s7,8(sp)
    80001276:	e062                	sd	s8,0(sp)
    80001278:	0880                	addi	s0,sp,80
    8000127a:	8792                	mv	a5,tp
  int id = r_tp();
    8000127c:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000127e:	00779b13          	slli	s6,a5,0x7
    80001282:	00006717          	auipc	a4,0x6
    80001286:	62e70713          	addi	a4,a4,1582 # 800078b0 <pid_lock>
    8000128a:	975a                	add	a4,a4,s6
    8000128c:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001290:	00006717          	auipc	a4,0x6
    80001294:	65870713          	addi	a4,a4,1624 # 800078e8 <cpus+0x8>
    80001298:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    8000129a:	4c11                	li	s8,4
        c->proc = p;
    8000129c:	079e                	slli	a5,a5,0x7
    8000129e:	00006a17          	auipc	s4,0x6
    800012a2:	612a0a13          	addi	s4,s4,1554 # 800078b0 <pid_lock>
    800012a6:	9a3e                	add	s4,s4,a5
        found = 1;
    800012a8:	4b85                	li	s7,1
    800012aa:	a83d                	j	800012e8 <scheduler+0x86>
      release(&p->lock);
    800012ac:	8526                	mv	a0,s1
    800012ae:	071040ef          	jal	80005b1e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800012b2:	18848493          	addi	s1,s1,392
    800012b6:	03248563          	beq	s1,s2,800012e0 <scheduler+0x7e>
      acquire(&p->lock);
    800012ba:	8526                	mv	a0,s1
    800012bc:	7ce040ef          	jal	80005a8a <acquire>
      if(p->state == RUNNABLE) {
    800012c0:	4c9c                	lw	a5,24(s1)
    800012c2:	ff3795e3          	bne	a5,s3,800012ac <scheduler+0x4a>
        p->state = RUNNING;
    800012c6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800012ca:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800012ce:	06048593          	addi	a1,s1,96
    800012d2:	855a                	mv	a0,s6
    800012d4:	5ba000ef          	jal	8000188e <swtch>
        c->proc = 0;
    800012d8:	020a3823          	sd	zero,48(s4)
        found = 1;
    800012dc:	8ade                	mv	s5,s7
    800012de:	b7f9                	j	800012ac <scheduler+0x4a>
    if(found == 0) {
    800012e0:	000a9463          	bnez	s5,800012e8 <scheduler+0x86>
      asm volatile("wfi");
    800012e4:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012e8:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800012ec:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012f0:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012f4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800012f8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800012fa:	10079073          	csrw	sstatus,a5
    int found = 0;
    800012fe:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001300:	00007497          	auipc	s1,0x7
    80001304:	9e048493          	addi	s1,s1,-1568 # 80007ce0 <proc>
      if(p->state == RUNNABLE) {
    80001308:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000130a:	0000d917          	auipc	s2,0xd
    8000130e:	bd690913          	addi	s2,s2,-1066 # 8000dee0 <tickslock>
    80001312:	b765                	j	800012ba <scheduler+0x58>

0000000080001314 <sched>:
{
    80001314:	7179                	addi	sp,sp,-48
    80001316:	f406                	sd	ra,40(sp)
    80001318:	f022                	sd	s0,32(sp)
    8000131a:	ec26                	sd	s1,24(sp)
    8000131c:	e84a                	sd	s2,16(sp)
    8000131e:	e44e                	sd	s3,8(sp)
    80001320:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001322:	a67ff0ef          	jal	80000d88 <myproc>
    80001326:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001328:	6f2040ef          	jal	80005a1a <holding>
    8000132c:	c935                	beqz	a0,800013a0 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000132e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001330:	2781                	sext.w	a5,a5
    80001332:	079e                	slli	a5,a5,0x7
    80001334:	00006717          	auipc	a4,0x6
    80001338:	57c70713          	addi	a4,a4,1404 # 800078b0 <pid_lock>
    8000133c:	97ba                	add	a5,a5,a4
    8000133e:	0a87a703          	lw	a4,168(a5)
    80001342:	4785                	li	a5,1
    80001344:	06f71463          	bne	a4,a5,800013ac <sched+0x98>
  if(p->state == RUNNING)
    80001348:	4c98                	lw	a4,24(s1)
    8000134a:	4791                	li	a5,4
    8000134c:	06f70663          	beq	a4,a5,800013b8 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001350:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001354:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001356:	e7bd                	bnez	a5,800013c4 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001358:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000135a:	00006917          	auipc	s2,0x6
    8000135e:	55690913          	addi	s2,s2,1366 # 800078b0 <pid_lock>
    80001362:	2781                	sext.w	a5,a5
    80001364:	079e                	slli	a5,a5,0x7
    80001366:	97ca                	add	a5,a5,s2
    80001368:	0ac7a983          	lw	s3,172(a5)
    8000136c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000136e:	2781                	sext.w	a5,a5
    80001370:	079e                	slli	a5,a5,0x7
    80001372:	07a1                	addi	a5,a5,8
    80001374:	00006597          	auipc	a1,0x6
    80001378:	56c58593          	addi	a1,a1,1388 # 800078e0 <cpus>
    8000137c:	95be                	add	a1,a1,a5
    8000137e:	06048513          	addi	a0,s1,96
    80001382:	50c000ef          	jal	8000188e <swtch>
    80001386:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001388:	2781                	sext.w	a5,a5
    8000138a:	079e                	slli	a5,a5,0x7
    8000138c:	993e                	add	s2,s2,a5
    8000138e:	0b392623          	sw	s3,172(s2)
}
    80001392:	70a2                	ld	ra,40(sp)
    80001394:	7402                	ld	s0,32(sp)
    80001396:	64e2                	ld	s1,24(sp)
    80001398:	6942                	ld	s2,16(sp)
    8000139a:	69a2                	ld	s3,8(sp)
    8000139c:	6145                	addi	sp,sp,48
    8000139e:	8082                	ret
    panic("sched p->lock");
    800013a0:	00006517          	auipc	a0,0x6
    800013a4:	d9850513          	addi	a0,a0,-616 # 80007138 <etext+0x138>
    800013a8:	440040ef          	jal	800057e8 <panic>
    panic("sched locks");
    800013ac:	00006517          	auipc	a0,0x6
    800013b0:	d9c50513          	addi	a0,a0,-612 # 80007148 <etext+0x148>
    800013b4:	434040ef          	jal	800057e8 <panic>
    panic("sched RUNNING");
    800013b8:	00006517          	auipc	a0,0x6
    800013bc:	da050513          	addi	a0,a0,-608 # 80007158 <etext+0x158>
    800013c0:	428040ef          	jal	800057e8 <panic>
    panic("sched interruptible");
    800013c4:	00006517          	auipc	a0,0x6
    800013c8:	da450513          	addi	a0,a0,-604 # 80007168 <etext+0x168>
    800013cc:	41c040ef          	jal	800057e8 <panic>

00000000800013d0 <yield>:
{
    800013d0:	1101                	addi	sp,sp,-32
    800013d2:	ec06                	sd	ra,24(sp)
    800013d4:	e822                	sd	s0,16(sp)
    800013d6:	e426                	sd	s1,8(sp)
    800013d8:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    800013da:	9afff0ef          	jal	80000d88 <myproc>
    800013de:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800013e0:	6aa040ef          	jal	80005a8a <acquire>
  p->state = RUNNABLE;
    800013e4:	478d                	li	a5,3
    800013e6:	cc9c                	sw	a5,24(s1)
  sched();
    800013e8:	f2dff0ef          	jal	80001314 <sched>
  release(&p->lock);
    800013ec:	8526                	mv	a0,s1
    800013ee:	730040ef          	jal	80005b1e <release>
}
    800013f2:	60e2                	ld	ra,24(sp)
    800013f4:	6442                	ld	s0,16(sp)
    800013f6:	64a2                	ld	s1,8(sp)
    800013f8:	6105                	addi	sp,sp,32
    800013fa:	8082                	ret

00000000800013fc <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800013fc:	7179                	addi	sp,sp,-48
    800013fe:	f406                	sd	ra,40(sp)
    80001400:	f022                	sd	s0,32(sp)
    80001402:	ec26                	sd	s1,24(sp)
    80001404:	e84a                	sd	s2,16(sp)
    80001406:	e44e                	sd	s3,8(sp)
    80001408:	1800                	addi	s0,sp,48
    8000140a:	89aa                	mv	s3,a0
    8000140c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000140e:	97bff0ef          	jal	80000d88 <myproc>
    80001412:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001414:	676040ef          	jal	80005a8a <acquire>
  release(lk);
    80001418:	854a                	mv	a0,s2
    8000141a:	704040ef          	jal	80005b1e <release>

  // Go to sleep.
  p->chan = chan;
    8000141e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001422:	4789                	li	a5,2
    80001424:	cc9c                	sw	a5,24(s1)

  sched();
    80001426:	eefff0ef          	jal	80001314 <sched>

  // Tidy up.
  p->chan = 0;
    8000142a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000142e:	8526                	mv	a0,s1
    80001430:	6ee040ef          	jal	80005b1e <release>
  acquire(lk);
    80001434:	854a                	mv	a0,s2
    80001436:	654040ef          	jal	80005a8a <acquire>
}
    8000143a:	70a2                	ld	ra,40(sp)
    8000143c:	7402                	ld	s0,32(sp)
    8000143e:	64e2                	ld	s1,24(sp)
    80001440:	6942                	ld	s2,16(sp)
    80001442:	69a2                	ld	s3,8(sp)
    80001444:	6145                	addi	sp,sp,48
    80001446:	8082                	ret

0000000080001448 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001448:	7139                	addi	sp,sp,-64
    8000144a:	fc06                	sd	ra,56(sp)
    8000144c:	f822                	sd	s0,48(sp)
    8000144e:	f426                	sd	s1,40(sp)
    80001450:	f04a                	sd	s2,32(sp)
    80001452:	ec4e                	sd	s3,24(sp)
    80001454:	e852                	sd	s4,16(sp)
    80001456:	e456                	sd	s5,8(sp)
    80001458:	0080                	addi	s0,sp,64
    8000145a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000145c:	00007497          	auipc	s1,0x7
    80001460:	88448493          	addi	s1,s1,-1916 # 80007ce0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001464:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001466:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001468:	0000d917          	auipc	s2,0xd
    8000146c:	a7890913          	addi	s2,s2,-1416 # 8000dee0 <tickslock>
    80001470:	a801                	j	80001480 <wakeup+0x38>
      }
      release(&p->lock);
    80001472:	8526                	mv	a0,s1
    80001474:	6aa040ef          	jal	80005b1e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001478:	18848493          	addi	s1,s1,392
    8000147c:	03248263          	beq	s1,s2,800014a0 <wakeup+0x58>
    if(p != myproc()){
    80001480:	909ff0ef          	jal	80000d88 <myproc>
    80001484:	fe950ae3          	beq	a0,s1,80001478 <wakeup+0x30>
      acquire(&p->lock);
    80001488:	8526                	mv	a0,s1
    8000148a:	600040ef          	jal	80005a8a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000148e:	4c9c                	lw	a5,24(s1)
    80001490:	ff3791e3          	bne	a5,s3,80001472 <wakeup+0x2a>
    80001494:	709c                	ld	a5,32(s1)
    80001496:	fd479ee3          	bne	a5,s4,80001472 <wakeup+0x2a>
        p->state = RUNNABLE;
    8000149a:	0154ac23          	sw	s5,24(s1)
    8000149e:	bfd1                	j	80001472 <wakeup+0x2a>
    }
  }
}
    800014a0:	70e2                	ld	ra,56(sp)
    800014a2:	7442                	ld	s0,48(sp)
    800014a4:	74a2                	ld	s1,40(sp)
    800014a6:	7902                	ld	s2,32(sp)
    800014a8:	69e2                	ld	s3,24(sp)
    800014aa:	6a42                	ld	s4,16(sp)
    800014ac:	6aa2                	ld	s5,8(sp)
    800014ae:	6121                	addi	sp,sp,64
    800014b0:	8082                	ret

00000000800014b2 <reparent>:
{
    800014b2:	7179                	addi	sp,sp,-48
    800014b4:	f406                	sd	ra,40(sp)
    800014b6:	f022                	sd	s0,32(sp)
    800014b8:	ec26                	sd	s1,24(sp)
    800014ba:	e84a                	sd	s2,16(sp)
    800014bc:	e44e                	sd	s3,8(sp)
    800014be:	e052                	sd	s4,0(sp)
    800014c0:	1800                	addi	s0,sp,48
    800014c2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014c4:	00007497          	auipc	s1,0x7
    800014c8:	81c48493          	addi	s1,s1,-2020 # 80007ce0 <proc>
      pp->parent = initproc;
    800014cc:	00006a17          	auipc	s4,0x6
    800014d0:	3a4a0a13          	addi	s4,s4,932 # 80007870 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800014d4:	0000d997          	auipc	s3,0xd
    800014d8:	a0c98993          	addi	s3,s3,-1524 # 8000dee0 <tickslock>
    800014dc:	a029                	j	800014e6 <reparent+0x34>
    800014de:	18848493          	addi	s1,s1,392
    800014e2:	01348b63          	beq	s1,s3,800014f8 <reparent+0x46>
    if(pp->parent == p){
    800014e6:	7c9c                	ld	a5,56(s1)
    800014e8:	ff279be3          	bne	a5,s2,800014de <reparent+0x2c>
      pp->parent = initproc;
    800014ec:	000a3503          	ld	a0,0(s4)
    800014f0:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    800014f2:	f57ff0ef          	jal	80001448 <wakeup>
    800014f6:	b7e5                	j	800014de <reparent+0x2c>
}
    800014f8:	70a2                	ld	ra,40(sp)
    800014fa:	7402                	ld	s0,32(sp)
    800014fc:	64e2                	ld	s1,24(sp)
    800014fe:	6942                	ld	s2,16(sp)
    80001500:	69a2                	ld	s3,8(sp)
    80001502:	6a02                	ld	s4,0(sp)
    80001504:	6145                	addi	sp,sp,48
    80001506:	8082                	ret

0000000080001508 <kexit>:
{
    80001508:	7179                	addi	sp,sp,-48
    8000150a:	f406                	sd	ra,40(sp)
    8000150c:	f022                	sd	s0,32(sp)
    8000150e:	ec26                	sd	s1,24(sp)
    80001510:	e84a                	sd	s2,16(sp)
    80001512:	e44e                	sd	s3,8(sp)
    80001514:	e052                	sd	s4,0(sp)
    80001516:	1800                	addi	s0,sp,48
    80001518:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    8000151a:	86fff0ef          	jal	80000d88 <myproc>
    8000151e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001520:	00006797          	auipc	a5,0x6
    80001524:	3507b783          	ld	a5,848(a5) # 80007870 <initproc>
    80001528:	0d050493          	addi	s1,a0,208
    8000152c:	15050913          	addi	s2,a0,336
    80001530:	00a79b63          	bne	a5,a0,80001546 <kexit+0x3e>
    panic("init exiting");
    80001534:	00006517          	auipc	a0,0x6
    80001538:	c4c50513          	addi	a0,a0,-948 # 80007180 <etext+0x180>
    8000153c:	2ac040ef          	jal	800057e8 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001540:	04a1                	addi	s1,s1,8
    80001542:	01248963          	beq	s1,s2,80001554 <kexit+0x4c>
    if(p->ofile[fd]){
    80001546:	6088                	ld	a0,0(s1)
    80001548:	dd65                	beqz	a0,80001540 <kexit+0x38>
      fileclose(f);
    8000154a:	066020ef          	jal	800035b0 <fileclose>
      p->ofile[fd] = 0;
    8000154e:	0004b023          	sd	zero,0(s1)
    80001552:	b7fd                	j	80001540 <kexit+0x38>
  begin_op();
    80001554:	439010ef          	jal	8000318c <begin_op>
  iput(p->cwd);
    80001558:	1509b503          	ld	a0,336(s3)
    8000155c:	3a6010ef          	jal	80002902 <iput>
  end_op();
    80001560:	49d010ef          	jal	800031fc <end_op>
  p->cwd = 0;
    80001564:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001568:	00006517          	auipc	a0,0x6
    8000156c:	36050513          	addi	a0,a0,864 # 800078c8 <wait_lock>
    80001570:	51a040ef          	jal	80005a8a <acquire>
  reparent(p);
    80001574:	854e                	mv	a0,s3
    80001576:	f3dff0ef          	jal	800014b2 <reparent>
  wakeup(p->parent);
    8000157a:	0389b503          	ld	a0,56(s3)
    8000157e:	ecbff0ef          	jal	80001448 <wakeup>
  acquire(&p->lock);
    80001582:	854e                	mv	a0,s3
    80001584:	506040ef          	jal	80005a8a <acquire>
  p->xstate = status;
    80001588:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000158c:	4795                	li	a5,5
    8000158e:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001592:	00006517          	auipc	a0,0x6
    80001596:	33650513          	addi	a0,a0,822 # 800078c8 <wait_lock>
    8000159a:	584040ef          	jal	80005b1e <release>
  sched();
    8000159e:	d77ff0ef          	jal	80001314 <sched>
  panic("zombie exit");
    800015a2:	00006517          	auipc	a0,0x6
    800015a6:	bee50513          	addi	a0,a0,-1042 # 80007190 <etext+0x190>
    800015aa:	23e040ef          	jal	800057e8 <panic>

00000000800015ae <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800015ae:	7179                	addi	sp,sp,-48
    800015b0:	f406                	sd	ra,40(sp)
    800015b2:	f022                	sd	s0,32(sp)
    800015b4:	ec26                	sd	s1,24(sp)
    800015b6:	e84a                	sd	s2,16(sp)
    800015b8:	e44e                	sd	s3,8(sp)
    800015ba:	1800                	addi	s0,sp,48
    800015bc:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800015be:	00006497          	auipc	s1,0x6
    800015c2:	72248493          	addi	s1,s1,1826 # 80007ce0 <proc>
    800015c6:	0000d997          	auipc	s3,0xd
    800015ca:	91a98993          	addi	s3,s3,-1766 # 8000dee0 <tickslock>
    acquire(&p->lock);
    800015ce:	8526                	mv	a0,s1
    800015d0:	4ba040ef          	jal	80005a8a <acquire>
    if(p->pid == pid){
    800015d4:	589c                	lw	a5,48(s1)
    800015d6:	01278b63          	beq	a5,s2,800015ec <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    800015da:	8526                	mv	a0,s1
    800015dc:	542040ef          	jal	80005b1e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    800015e0:	18848493          	addi	s1,s1,392
    800015e4:	ff3495e3          	bne	s1,s3,800015ce <kkill+0x20>
  }
  return -1;
    800015e8:	557d                	li	a0,-1
    800015ea:	a819                	j	80001600 <kkill+0x52>
      p->killed = 1;
    800015ec:	4785                	li	a5,1
    800015ee:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    800015f0:	4c98                	lw	a4,24(s1)
    800015f2:	4789                	li	a5,2
    800015f4:	00f70d63          	beq	a4,a5,8000160e <kkill+0x60>
      release(&p->lock);
    800015f8:	8526                	mv	a0,s1
    800015fa:	524040ef          	jal	80005b1e <release>
      return 0;
    800015fe:	4501                	li	a0,0
}
    80001600:	70a2                	ld	ra,40(sp)
    80001602:	7402                	ld	s0,32(sp)
    80001604:	64e2                	ld	s1,24(sp)
    80001606:	6942                	ld	s2,16(sp)
    80001608:	69a2                	ld	s3,8(sp)
    8000160a:	6145                	addi	sp,sp,48
    8000160c:	8082                	ret
        p->state = RUNNABLE;
    8000160e:	478d                	li	a5,3
    80001610:	cc9c                	sw	a5,24(s1)
    80001612:	b7dd                	j	800015f8 <kkill+0x4a>

0000000080001614 <setkilled>:

void
setkilled(struct proc *p)
{
    80001614:	1101                	addi	sp,sp,-32
    80001616:	ec06                	sd	ra,24(sp)
    80001618:	e822                	sd	s0,16(sp)
    8000161a:	e426                	sd	s1,8(sp)
    8000161c:	1000                	addi	s0,sp,32
    8000161e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001620:	46a040ef          	jal	80005a8a <acquire>
  p->killed = 1;
    80001624:	4785                	li	a5,1
    80001626:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001628:	8526                	mv	a0,s1
    8000162a:	4f4040ef          	jal	80005b1e <release>
}
    8000162e:	60e2                	ld	ra,24(sp)
    80001630:	6442                	ld	s0,16(sp)
    80001632:	64a2                	ld	s1,8(sp)
    80001634:	6105                	addi	sp,sp,32
    80001636:	8082                	ret

0000000080001638 <killed>:

int
killed(struct proc *p)
{
    80001638:	1101                	addi	sp,sp,-32
    8000163a:	ec06                	sd	ra,24(sp)
    8000163c:	e822                	sd	s0,16(sp)
    8000163e:	e426                	sd	s1,8(sp)
    80001640:	e04a                	sd	s2,0(sp)
    80001642:	1000                	addi	s0,sp,32
    80001644:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001646:	444040ef          	jal	80005a8a <acquire>
  k = p->killed;
    8000164a:	549c                	lw	a5,40(s1)
    8000164c:	893e                	mv	s2,a5
  release(&p->lock);
    8000164e:	8526                	mv	a0,s1
    80001650:	4ce040ef          	jal	80005b1e <release>
  return k;
}
    80001654:	854a                	mv	a0,s2
    80001656:	60e2                	ld	ra,24(sp)
    80001658:	6442                	ld	s0,16(sp)
    8000165a:	64a2                	ld	s1,8(sp)
    8000165c:	6902                	ld	s2,0(sp)
    8000165e:	6105                	addi	sp,sp,32
    80001660:	8082                	ret

0000000080001662 <kwait>:
{
    80001662:	715d                	addi	sp,sp,-80
    80001664:	e486                	sd	ra,72(sp)
    80001666:	e0a2                	sd	s0,64(sp)
    80001668:	fc26                	sd	s1,56(sp)
    8000166a:	f84a                	sd	s2,48(sp)
    8000166c:	f44e                	sd	s3,40(sp)
    8000166e:	f052                	sd	s4,32(sp)
    80001670:	ec56                	sd	s5,24(sp)
    80001672:	e85a                	sd	s6,16(sp)
    80001674:	e45e                	sd	s7,8(sp)
    80001676:	0880                	addi	s0,sp,80
    80001678:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    8000167a:	f0eff0ef          	jal	80000d88 <myproc>
    8000167e:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001680:	00006517          	auipc	a0,0x6
    80001684:	24850513          	addi	a0,a0,584 # 800078c8 <wait_lock>
    80001688:	402040ef          	jal	80005a8a <acquire>
        if(pp->state == ZOMBIE){
    8000168c:	4a15                	li	s4,5
        havekids = 1;
    8000168e:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001690:	0000d997          	auipc	s3,0xd
    80001694:	85098993          	addi	s3,s3,-1968 # 8000dee0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001698:	00006b17          	auipc	s6,0x6
    8000169c:	230b0b13          	addi	s6,s6,560 # 800078c8 <wait_lock>
    800016a0:	a869                	j	8000173a <kwait+0xd8>
          pid = pp->pid;
    800016a2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800016a6:	000b8c63          	beqz	s7,800016be <kwait+0x5c>
    800016aa:	4691                	li	a3,4
    800016ac:	02c48613          	addi	a2,s1,44
    800016b0:	85de                	mv	a1,s7
    800016b2:	05093503          	ld	a0,80(s2)
    800016b6:	c04ff0ef          	jal	80000aba <copyout>
    800016ba:	02054a63          	bltz	a0,800016ee <kwait+0x8c>
          freeproc(pp);
    800016be:	8526                	mv	a0,s1
    800016c0:	89dff0ef          	jal	80000f5c <freeproc>
          release(&pp->lock);
    800016c4:	8526                	mv	a0,s1
    800016c6:	458040ef          	jal	80005b1e <release>
          release(&wait_lock);
    800016ca:	00006517          	auipc	a0,0x6
    800016ce:	1fe50513          	addi	a0,a0,510 # 800078c8 <wait_lock>
    800016d2:	44c040ef          	jal	80005b1e <release>
}
    800016d6:	854e                	mv	a0,s3
    800016d8:	60a6                	ld	ra,72(sp)
    800016da:	6406                	ld	s0,64(sp)
    800016dc:	74e2                	ld	s1,56(sp)
    800016de:	7942                	ld	s2,48(sp)
    800016e0:	79a2                	ld	s3,40(sp)
    800016e2:	7a02                	ld	s4,32(sp)
    800016e4:	6ae2                	ld	s5,24(sp)
    800016e6:	6b42                	ld	s6,16(sp)
    800016e8:	6ba2                	ld	s7,8(sp)
    800016ea:	6161                	addi	sp,sp,80
    800016ec:	8082                	ret
            release(&pp->lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	42e040ef          	jal	80005b1e <release>
            release(&wait_lock);
    800016f4:	00006517          	auipc	a0,0x6
    800016f8:	1d450513          	addi	a0,a0,468 # 800078c8 <wait_lock>
    800016fc:	422040ef          	jal	80005b1e <release>
            return -1;
    80001700:	59fd                	li	s3,-1
    80001702:	bfd1                	j	800016d6 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001704:	18848493          	addi	s1,s1,392
    80001708:	03348063          	beq	s1,s3,80001728 <kwait+0xc6>
      if(pp->parent == p){
    8000170c:	7c9c                	ld	a5,56(s1)
    8000170e:	ff279be3          	bne	a5,s2,80001704 <kwait+0xa2>
        acquire(&pp->lock);
    80001712:	8526                	mv	a0,s1
    80001714:	376040ef          	jal	80005a8a <acquire>
        if(pp->state == ZOMBIE){
    80001718:	4c9c                	lw	a5,24(s1)
    8000171a:	f94784e3          	beq	a5,s4,800016a2 <kwait+0x40>
        release(&pp->lock);
    8000171e:	8526                	mv	a0,s1
    80001720:	3fe040ef          	jal	80005b1e <release>
        havekids = 1;
    80001724:	8756                	mv	a4,s5
    80001726:	bff9                	j	80001704 <kwait+0xa2>
    if(!havekids || killed(p)){
    80001728:	cf19                	beqz	a4,80001746 <kwait+0xe4>
    8000172a:	854a                	mv	a0,s2
    8000172c:	f0dff0ef          	jal	80001638 <killed>
    80001730:	e919                	bnez	a0,80001746 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001732:	85da                	mv	a1,s6
    80001734:	854a                	mv	a0,s2
    80001736:	cc7ff0ef          	jal	800013fc <sleep>
    havekids = 0;
    8000173a:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000173c:	00006497          	auipc	s1,0x6
    80001740:	5a448493          	addi	s1,s1,1444 # 80007ce0 <proc>
    80001744:	b7e1                	j	8000170c <kwait+0xaa>
      release(&wait_lock);
    80001746:	00006517          	auipc	a0,0x6
    8000174a:	18250513          	addi	a0,a0,386 # 800078c8 <wait_lock>
    8000174e:	3d0040ef          	jal	80005b1e <release>
      return -1;
    80001752:	59fd                	li	s3,-1
    80001754:	b749                	j	800016d6 <kwait+0x74>

0000000080001756 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001756:	7179                	addi	sp,sp,-48
    80001758:	f406                	sd	ra,40(sp)
    8000175a:	f022                	sd	s0,32(sp)
    8000175c:	ec26                	sd	s1,24(sp)
    8000175e:	e84a                	sd	s2,16(sp)
    80001760:	e44e                	sd	s3,8(sp)
    80001762:	e052                	sd	s4,0(sp)
    80001764:	1800                	addi	s0,sp,48
    80001766:	84aa                	mv	s1,a0
    80001768:	8a2e                	mv	s4,a1
    8000176a:	89b2                	mv	s3,a2
    8000176c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000176e:	e1aff0ef          	jal	80000d88 <myproc>
  if(user_dst){
    80001772:	cc99                	beqz	s1,80001790 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001774:	86ca                	mv	a3,s2
    80001776:	864e                	mv	a2,s3
    80001778:	85d2                	mv	a1,s4
    8000177a:	6928                	ld	a0,80(a0)
    8000177c:	b3eff0ef          	jal	80000aba <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001780:	70a2                	ld	ra,40(sp)
    80001782:	7402                	ld	s0,32(sp)
    80001784:	64e2                	ld	s1,24(sp)
    80001786:	6942                	ld	s2,16(sp)
    80001788:	69a2                	ld	s3,8(sp)
    8000178a:	6a02                	ld	s4,0(sp)
    8000178c:	6145                	addi	sp,sp,48
    8000178e:	8082                	ret
    memmove((char *)dst, src, len);
    80001790:	0009061b          	sext.w	a2,s2
    80001794:	85ce                	mv	a1,s3
    80001796:	8552                	mv	a0,s4
    80001798:	a27fe0ef          	jal	800001be <memmove>
    return 0;
    8000179c:	8526                	mv	a0,s1
    8000179e:	b7cd                	j	80001780 <either_copyout+0x2a>

00000000800017a0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800017a0:	7179                	addi	sp,sp,-48
    800017a2:	f406                	sd	ra,40(sp)
    800017a4:	f022                	sd	s0,32(sp)
    800017a6:	ec26                	sd	s1,24(sp)
    800017a8:	e84a                	sd	s2,16(sp)
    800017aa:	e44e                	sd	s3,8(sp)
    800017ac:	e052                	sd	s4,0(sp)
    800017ae:	1800                	addi	s0,sp,48
    800017b0:	8a2a                	mv	s4,a0
    800017b2:	84ae                	mv	s1,a1
    800017b4:	89b2                	mv	s3,a2
    800017b6:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800017b8:	dd0ff0ef          	jal	80000d88 <myproc>
  if(user_src){
    800017bc:	cc99                	beqz	s1,800017da <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800017be:	86ca                	mv	a3,s2
    800017c0:	864e                	mv	a2,s3
    800017c2:	85d2                	mv	a1,s4
    800017c4:	6928                	ld	a0,80(a0)
    800017c6:	bb2ff0ef          	jal	80000b78 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800017ca:	70a2                	ld	ra,40(sp)
    800017cc:	7402                	ld	s0,32(sp)
    800017ce:	64e2                	ld	s1,24(sp)
    800017d0:	6942                	ld	s2,16(sp)
    800017d2:	69a2                	ld	s3,8(sp)
    800017d4:	6a02                	ld	s4,0(sp)
    800017d6:	6145                	addi	sp,sp,48
    800017d8:	8082                	ret
    memmove(dst, (char*)src, len);
    800017da:	0009061b          	sext.w	a2,s2
    800017de:	85ce                	mv	a1,s3
    800017e0:	8552                	mv	a0,s4
    800017e2:	9ddfe0ef          	jal	800001be <memmove>
    return 0;
    800017e6:	8526                	mv	a0,s1
    800017e8:	b7cd                	j	800017ca <either_copyin+0x2a>

00000000800017ea <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    800017ea:	715d                	addi	sp,sp,-80
    800017ec:	e486                	sd	ra,72(sp)
    800017ee:	e0a2                	sd	s0,64(sp)
    800017f0:	fc26                	sd	s1,56(sp)
    800017f2:	f84a                	sd	s2,48(sp)
    800017f4:	f44e                	sd	s3,40(sp)
    800017f6:	f052                	sd	s4,32(sp)
    800017f8:	ec56                	sd	s5,24(sp)
    800017fa:	e85a                	sd	s6,16(sp)
    800017fc:	e45e                	sd	s7,8(sp)
    800017fe:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001800:	00006517          	auipc	a0,0x6
    80001804:	81850513          	addi	a0,a0,-2024 # 80007018 <etext+0x18>
    80001808:	435030ef          	jal	8000543c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    8000180c:	00006497          	auipc	s1,0x6
    80001810:	62c48493          	addi	s1,s1,1580 # 80007e38 <proc+0x158>
    80001814:	0000d917          	auipc	s2,0xd
    80001818:	82490913          	addi	s2,s2,-2012 # 8000e038 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    8000181c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    8000181e:	00006997          	auipc	s3,0x6
    80001822:	98298993          	addi	s3,s3,-1662 # 800071a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    80001826:	00006a97          	auipc	s5,0x6
    8000182a:	982a8a93          	addi	s5,s5,-1662 # 800071a8 <etext+0x1a8>
    printf("\n");
    8000182e:	00005a17          	auipc	s4,0x5
    80001832:	7eaa0a13          	addi	s4,s4,2026 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001836:	00006b97          	auipc	s7,0x6
    8000183a:	ef2b8b93          	addi	s7,s7,-270 # 80007728 <states.0>
    8000183e:	a829                	j	80001858 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001840:	ed86a583          	lw	a1,-296(a3)
    80001844:	8556                	mv	a0,s5
    80001846:	3f7030ef          	jal	8000543c <printf>
    printf("\n");
    8000184a:	8552                	mv	a0,s4
    8000184c:	3f1030ef          	jal	8000543c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001850:	18848493          	addi	s1,s1,392
    80001854:	03248263          	beq	s1,s2,80001878 <procdump+0x8e>
    if(p->state == UNUSED)
    80001858:	86a6                	mv	a3,s1
    8000185a:	ec04a783          	lw	a5,-320(s1)
    8000185e:	dbed                	beqz	a5,80001850 <procdump+0x66>
      state = "???";
    80001860:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001862:	fcfb6fe3          	bltu	s6,a5,80001840 <procdump+0x56>
    80001866:	02079713          	slli	a4,a5,0x20
    8000186a:	01d75793          	srli	a5,a4,0x1d
    8000186e:	97de                	add	a5,a5,s7
    80001870:	6390                	ld	a2,0(a5)
    80001872:	f679                	bnez	a2,80001840 <procdump+0x56>
      state = "???";
    80001874:	864e                	mv	a2,s3
    80001876:	b7e9                	j	80001840 <procdump+0x56>
  }
}
    80001878:	60a6                	ld	ra,72(sp)
    8000187a:	6406                	ld	s0,64(sp)
    8000187c:	74e2                	ld	s1,56(sp)
    8000187e:	7942                	ld	s2,48(sp)
    80001880:	79a2                	ld	s3,40(sp)
    80001882:	7a02                	ld	s4,32(sp)
    80001884:	6ae2                	ld	s5,24(sp)
    80001886:	6b42                	ld	s6,16(sp)
    80001888:	6ba2                	ld	s7,8(sp)
    8000188a:	6161                	addi	sp,sp,80
    8000188c:	8082                	ret

000000008000188e <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000188e:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001892:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001896:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001898:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    8000189a:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000189e:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    800018a2:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    800018a6:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    800018aa:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    800018ae:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    800018b2:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    800018b6:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    800018ba:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    800018be:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    800018c2:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    800018c6:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    800018ca:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    800018cc:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    800018ce:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    800018d2:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    800018d6:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    800018da:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    800018de:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    800018e2:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    800018e6:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    800018ea:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    800018ee:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    800018f2:	0685bd83          	ld	s11,104(a1)
        
        ret
    800018f6:	8082                	ret

00000000800018f8 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    800018f8:	1141                	addi	sp,sp,-16
    800018fa:	e406                	sd	ra,8(sp)
    800018fc:	e022                	sd	s0,0(sp)
    800018fe:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001900:	00006597          	auipc	a1,0x6
    80001904:	8e858593          	addi	a1,a1,-1816 # 800071e8 <etext+0x1e8>
    80001908:	0000c517          	auipc	a0,0xc
    8000190c:	5d850513          	addi	a0,a0,1496 # 8000dee0 <tickslock>
    80001910:	0f0040ef          	jal	80005a00 <initlock>
}
    80001914:	60a2                	ld	ra,8(sp)
    80001916:	6402                	ld	s0,0(sp)
    80001918:	0141                	addi	sp,sp,16
    8000191a:	8082                	ret

000000008000191c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    8000191c:	1141                	addi	sp,sp,-16
    8000191e:	e406                	sd	ra,8(sp)
    80001920:	e022                	sd	s0,0(sp)
    80001922:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001924:	00003797          	auipc	a5,0x3
    80001928:	04c78793          	addi	a5,a5,76 # 80004970 <kernelvec>
    8000192c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001930:	60a2                	ld	ra,8(sp)
    80001932:	6402                	ld	s0,0(sp)
    80001934:	0141                	addi	sp,sp,16
    80001936:	8082                	ret

0000000080001938 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80001938:	1141                	addi	sp,sp,-16
    8000193a:	e406                	sd	ra,8(sp)
    8000193c:	e022                	sd	s0,0(sp)
    8000193e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001940:	c48ff0ef          	jal	80000d88 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001944:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001948:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000194a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    8000194e:	04000737          	lui	a4,0x4000
    80001952:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001954:	0732                	slli	a4,a4,0xc
    80001956:	00004797          	auipc	a5,0x4
    8000195a:	6aa78793          	addi	a5,a5,1706 # 80006000 <_trampoline>
    8000195e:	00004697          	auipc	a3,0x4
    80001962:	6a268693          	addi	a3,a3,1698 # 80006000 <_trampoline>
    80001966:	8f95                	sub	a5,a5,a3
    80001968:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000196a:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000196e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001970:	18002773          	csrr	a4,satp
    80001974:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001976:	6d38                	ld	a4,88(a0)
    80001978:	613c                	ld	a5,64(a0)
    8000197a:	6685                	lui	a3,0x1
    8000197c:	97b6                	add	a5,a5,a3
    8000197e:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001980:	6d3c                	ld	a5,88(a0)
    80001982:	00000717          	auipc	a4,0x0
    80001986:	0fc70713          	addi	a4,a4,252 # 80001a7e <usertrap>
    8000198a:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000198c:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000198e:	8712                	mv	a4,tp
    80001990:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001992:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001996:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    8000199a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000199e:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    800019a2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    800019a4:	6f9c                	ld	a5,24(a5)
    800019a6:	14179073          	csrw	sepc,a5
}
    800019aa:	60a2                	ld	ra,8(sp)
    800019ac:	6402                	ld	s0,0(sp)
    800019ae:	0141                	addi	sp,sp,16
    800019b0:	8082                	ret

00000000800019b2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    800019b2:	1141                	addi	sp,sp,-16
    800019b4:	e406                	sd	ra,8(sp)
    800019b6:	e022                	sd	s0,0(sp)
    800019b8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800019ba:	b9aff0ef          	jal	80000d54 <cpuid>
    800019be:	cd11                	beqz	a0,800019da <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    800019c0:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    800019c4:	000f4737          	lui	a4,0xf4
    800019c8:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800019cc:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800019ce:	14d79073          	csrw	stimecmp,a5
}
    800019d2:	60a2                	ld	ra,8(sp)
    800019d4:	6402                	ld	s0,0(sp)
    800019d6:	0141                	addi	sp,sp,16
    800019d8:	8082                	ret
    acquire(&tickslock);
    800019da:	0000c517          	auipc	a0,0xc
    800019de:	50650513          	addi	a0,a0,1286 # 8000dee0 <tickslock>
    800019e2:	0a8040ef          	jal	80005a8a <acquire>
    ticks++;
    800019e6:	00006717          	auipc	a4,0x6
    800019ea:	e9270713          	addi	a4,a4,-366 # 80007878 <ticks>
    800019ee:	431c                	lw	a5,0(a4)
    800019f0:	2785                	addiw	a5,a5,1
    800019f2:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    800019f4:	853a                	mv	a0,a4
    800019f6:	a53ff0ef          	jal	80001448 <wakeup>
    release(&tickslock);
    800019fa:	0000c517          	auipc	a0,0xc
    800019fe:	4e650513          	addi	a0,a0,1254 # 8000dee0 <tickslock>
    80001a02:	11c040ef          	jal	80005b1e <release>
    80001a06:	bf6d                	j	800019c0 <clockintr+0xe>

0000000080001a08 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001a08:	1101                	addi	sp,sp,-32
    80001a0a:	ec06                	sd	ra,24(sp)
    80001a0c:	e822                	sd	s0,16(sp)
    80001a0e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a10:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001a14:	57fd                	li	a5,-1
    80001a16:	17fe                	slli	a5,a5,0x3f
    80001a18:	07a5                	addi	a5,a5,9
    80001a1a:	00f70c63          	beq	a4,a5,80001a32 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001a1e:	57fd                	li	a5,-1
    80001a20:	17fe                	slli	a5,a5,0x3f
    80001a22:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001a24:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001a26:	04f70863          	beq	a4,a5,80001a76 <devintr+0x6e>
  }
}
    80001a2a:	60e2                	ld	ra,24(sp)
    80001a2c:	6442                	ld	s0,16(sp)
    80001a2e:	6105                	addi	sp,sp,32
    80001a30:	8082                	ret
    80001a32:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001a34:	7e9020ef          	jal	80004a1c <plic_claim>
    80001a38:	872a                	mv	a4,a0
    80001a3a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001a3c:	47a9                	li	a5,10
    80001a3e:	00f50963          	beq	a0,a5,80001a50 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80001a42:	4785                	li	a5,1
    80001a44:	00f50963          	beq	a0,a5,80001a56 <devintr+0x4e>
    return 1;
    80001a48:	4505                	li	a0,1
    } else if(irq){
    80001a4a:	eb09                	bnez	a4,80001a5c <devintr+0x54>
    80001a4c:	64a2                	ld	s1,8(sp)
    80001a4e:	bff1                	j	80001a2a <devintr+0x22>
      uartintr();
    80001a50:	749030ef          	jal	80005998 <uartintr>
    if(irq)
    80001a54:	a819                	j	80001a6a <devintr+0x62>
      virtio_disk_intr();
    80001a56:	45c030ef          	jal	80004eb2 <virtio_disk_intr>
    if(irq)
    80001a5a:	a801                	j	80001a6a <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80001a5c:	85ba                	mv	a1,a4
    80001a5e:	00005517          	auipc	a0,0x5
    80001a62:	79250513          	addi	a0,a0,1938 # 800071f0 <etext+0x1f0>
    80001a66:	1d7030ef          	jal	8000543c <printf>
      plic_complete(irq);
    80001a6a:	8526                	mv	a0,s1
    80001a6c:	7d1020ef          	jal	80004a3c <plic_complete>
    return 1;
    80001a70:	4505                	li	a0,1
    80001a72:	64a2                	ld	s1,8(sp)
    80001a74:	bf5d                	j	80001a2a <devintr+0x22>
    clockintr();
    80001a76:	f3dff0ef          	jal	800019b2 <clockintr>
    return 2;
    80001a7a:	4509                	li	a0,2
    80001a7c:	b77d                	j	80001a2a <devintr+0x22>

0000000080001a7e <usertrap>:
{
    80001a7e:	1101                	addi	sp,sp,-32
    80001a80:	ec06                	sd	ra,24(sp)
    80001a82:	e822                	sd	s0,16(sp)
    80001a84:	e426                	sd	s1,8(sp)
    80001a86:	e04a                	sd	s2,0(sp)
    80001a88:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a8a:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a8e:	1007f793          	andi	a5,a5,256
    80001a92:	eba5                	bnez	a5,80001b02 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a94:	00003797          	auipc	a5,0x3
    80001a98:	edc78793          	addi	a5,a5,-292 # 80004970 <kernelvec>
    80001a9c:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001aa0:	ae8ff0ef          	jal	80000d88 <myproc>
    80001aa4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001aa6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001aa8:	14102773          	csrr	a4,sepc
    80001aac:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001aae:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ab2:	47a1                	li	a5,8
    80001ab4:	04f70d63          	beq	a4,a5,80001b0e <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001ab8:	f51ff0ef          	jal	80001a08 <devintr>
    80001abc:	892a                	mv	s2,a0
    80001abe:	e945                	bnez	a0,80001b6e <usertrap+0xf0>
    80001ac0:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001ac4:	47bd                	li	a5,15
    80001ac6:	08f70863          	beq	a4,a5,80001b56 <usertrap+0xd8>
    80001aca:	14202773          	csrr	a4,scause
    80001ace:	47b5                	li	a5,13
    80001ad0:	08f70363          	beq	a4,a5,80001b56 <usertrap+0xd8>
    80001ad4:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001ad8:	5890                	lw	a2,48(s1)
    80001ada:	00005517          	auipc	a0,0x5
    80001ade:	75650513          	addi	a0,a0,1878 # 80007230 <etext+0x230>
    80001ae2:	15b030ef          	jal	8000543c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ae6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001aea:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001aee:	00005517          	auipc	a0,0x5
    80001af2:	77250513          	addi	a0,a0,1906 # 80007260 <etext+0x260>
    80001af6:	147030ef          	jal	8000543c <printf>
    setkilled(p);
    80001afa:	8526                	mv	a0,s1
    80001afc:	b19ff0ef          	jal	80001614 <setkilled>
    80001b00:	a035                	j	80001b2c <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001b02:	00005517          	auipc	a0,0x5
    80001b06:	70e50513          	addi	a0,a0,1806 # 80007210 <etext+0x210>
    80001b0a:	4df030ef          	jal	800057e8 <panic>
    if(killed(p))
    80001b0e:	b2bff0ef          	jal	80001638 <killed>
    80001b12:	ed15                	bnez	a0,80001b4e <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001b14:	6cb8                	ld	a4,88(s1)
    80001b16:	6f1c                	ld	a5,24(a4)
    80001b18:	0791                	addi	a5,a5,4
    80001b1a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b1c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001b20:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b24:	10079073          	csrw	sstatus,a5
    syscall();
    80001b28:	27c000ef          	jal	80001da4 <syscall>
  if(killed(p))
    80001b2c:	8526                	mv	a0,s1
    80001b2e:	b0bff0ef          	jal	80001638 <killed>
    80001b32:	e139                	bnez	a0,80001b78 <usertrap+0xfa>
  prepare_return();
    80001b34:	e05ff0ef          	jal	80001938 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001b38:	68a8                	ld	a0,80(s1)
    80001b3a:	8131                	srli	a0,a0,0xc
    80001b3c:	57fd                	li	a5,-1
    80001b3e:	17fe                	slli	a5,a5,0x3f
    80001b40:	8d5d                	or	a0,a0,a5
}
    80001b42:	60e2                	ld	ra,24(sp)
    80001b44:	6442                	ld	s0,16(sp)
    80001b46:	64a2                	ld	s1,8(sp)
    80001b48:	6902                	ld	s2,0(sp)
    80001b4a:	6105                	addi	sp,sp,32
    80001b4c:	8082                	ret
      kexit(-1);
    80001b4e:	557d                	li	a0,-1
    80001b50:	9b9ff0ef          	jal	80001508 <kexit>
    80001b54:	b7c1                	j	80001b14 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b56:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b5a:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001b5e:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001b60:	00163613          	seqz	a2,a2
    80001b64:	68a8                	ld	a0,80(s1)
    80001b66:	ed1fe0ef          	jal	80000a36 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b6a:	f169                	bnez	a0,80001b2c <usertrap+0xae>
    80001b6c:	b7a5                	j	80001ad4 <usertrap+0x56>
  if(killed(p))
    80001b6e:	8526                	mv	a0,s1
    80001b70:	ac9ff0ef          	jal	80001638 <killed>
    80001b74:	c511                	beqz	a0,80001b80 <usertrap+0x102>
    80001b76:	a011                	j	80001b7a <usertrap+0xfc>
    80001b78:	4901                	li	s2,0
    kexit(-1);
    80001b7a:	557d                	li	a0,-1
    80001b7c:	98dff0ef          	jal	80001508 <kexit>
  if(which_dev == 2) {
    80001b80:	4789                	li	a5,2
    80001b82:	faf919e3          	bne	s2,a5,80001b34 <usertrap+0xb6>
    if (p->ticks < p->interval && p->sigreturn) {
    80001b86:	1684a783          	lw	a5,360(s1)
    80001b8a:	16c4a703          	lw	a4,364(s1)
    80001b8e:	00e7d963          	bge	a5,a4,80001ba0 <usertrap+0x122>
    80001b92:	1704c703          	lbu	a4,368(s1)
    80001b96:	cb01                	beqz	a4,80001ba6 <usertrap+0x128>
      p->ticks++;
    80001b98:	2785                	addiw	a5,a5,1
    80001b9a:	16f4a423          	sw	a5,360(s1)
    80001b9e:	a021                	j	80001ba6 <usertrap+0x128>
    } else if (p->sigreturn) {
    80001ba0:	1704c783          	lbu	a5,368(s1)
    80001ba4:	e781                	bnez	a5,80001bac <usertrap+0x12e>
    yield();
    80001ba6:	82bff0ef          	jal	800013d0 <yield>
    80001baa:	b769                	j	80001b34 <usertrap+0xb6>
      memmove(p->saved_trapframe, p->trapframe, sizeof(struct trapframe));
    80001bac:	12000613          	li	a2,288
    80001bb0:	6cac                	ld	a1,88(s1)
    80001bb2:	1804b503          	ld	a0,384(s1)
    80001bb6:	e08fe0ef          	jal	800001be <memmove>
      p->trapframe->epc = p->handler;
    80001bba:	6cbc                	ld	a5,88(s1)
    80001bbc:	1784b703          	ld	a4,376(s1)
    80001bc0:	ef98                	sd	a4,24(a5)
      p->sigreturn = false;
    80001bc2:	16048823          	sb	zero,368(s1)
    80001bc6:	b7c5                	j	80001ba6 <usertrap+0x128>

0000000080001bc8 <kerneltrap>:
{
    80001bc8:	7179                	addi	sp,sp,-48
    80001bca:	f406                	sd	ra,40(sp)
    80001bcc:	f022                	sd	s0,32(sp)
    80001bce:	ec26                	sd	s1,24(sp)
    80001bd0:	e84a                	sd	s2,16(sp)
    80001bd2:	e44e                	sd	s3,8(sp)
    80001bd4:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001bd6:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bda:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bde:	142027f3          	csrr	a5,scause
    80001be2:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001be4:	1004f793          	andi	a5,s1,256
    80001be8:	c795                	beqz	a5,80001c14 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bea:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001bee:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001bf0:	eb85                	bnez	a5,80001c20 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001bf2:	e17ff0ef          	jal	80001a08 <devintr>
    80001bf6:	c91d                	beqz	a0,80001c2c <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001bf8:	4789                	li	a5,2
    80001bfa:	04f50a63          	beq	a0,a5,80001c4e <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bfe:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001c02:	10049073          	csrw	sstatus,s1
}
    80001c06:	70a2                	ld	ra,40(sp)
    80001c08:	7402                	ld	s0,32(sp)
    80001c0a:	64e2                	ld	s1,24(sp)
    80001c0c:	6942                	ld	s2,16(sp)
    80001c0e:	69a2                	ld	s3,8(sp)
    80001c10:	6145                	addi	sp,sp,48
    80001c12:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001c14:	00005517          	auipc	a0,0x5
    80001c18:	67450513          	addi	a0,a0,1652 # 80007288 <etext+0x288>
    80001c1c:	3cd030ef          	jal	800057e8 <panic>
    panic("kerneltrap: interrupts enabled");
    80001c20:	00005517          	auipc	a0,0x5
    80001c24:	69050513          	addi	a0,a0,1680 # 800072b0 <etext+0x2b0>
    80001c28:	3c1030ef          	jal	800057e8 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001c2c:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001c30:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001c34:	85ce                	mv	a1,s3
    80001c36:	00005517          	auipc	a0,0x5
    80001c3a:	69a50513          	addi	a0,a0,1690 # 800072d0 <etext+0x2d0>
    80001c3e:	7fe030ef          	jal	8000543c <printf>
    panic("kerneltrap");
    80001c42:	00005517          	auipc	a0,0x5
    80001c46:	6b650513          	addi	a0,a0,1718 # 800072f8 <etext+0x2f8>
    80001c4a:	39f030ef          	jal	800057e8 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001c4e:	93aff0ef          	jal	80000d88 <myproc>
    80001c52:	d555                	beqz	a0,80001bfe <kerneltrap+0x36>
    yield();
    80001c54:	f7cff0ef          	jal	800013d0 <yield>
    80001c58:	b75d                	j	80001bfe <kerneltrap+0x36>

0000000080001c5a <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001c5a:	1101                	addi	sp,sp,-32
    80001c5c:	ec06                	sd	ra,24(sp)
    80001c5e:	e822                	sd	s0,16(sp)
    80001c60:	e426                	sd	s1,8(sp)
    80001c62:	1000                	addi	s0,sp,32
    80001c64:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001c66:	922ff0ef          	jal	80000d88 <myproc>
  switch (n) {
    80001c6a:	4795                	li	a5,5
    80001c6c:	0497e163          	bltu	a5,s1,80001cae <argraw+0x54>
    80001c70:	048a                	slli	s1,s1,0x2
    80001c72:	00006717          	auipc	a4,0x6
    80001c76:	ae670713          	addi	a4,a4,-1306 # 80007758 <states.0+0x30>
    80001c7a:	94ba                	add	s1,s1,a4
    80001c7c:	409c                	lw	a5,0(s1)
    80001c7e:	97ba                	add	a5,a5,a4
    80001c80:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001c82:	6d3c                	ld	a5,88(a0)
    80001c84:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001c86:	60e2                	ld	ra,24(sp)
    80001c88:	6442                	ld	s0,16(sp)
    80001c8a:	64a2                	ld	s1,8(sp)
    80001c8c:	6105                	addi	sp,sp,32
    80001c8e:	8082                	ret
    return p->trapframe->a1;
    80001c90:	6d3c                	ld	a5,88(a0)
    80001c92:	7fa8                	ld	a0,120(a5)
    80001c94:	bfcd                	j	80001c86 <argraw+0x2c>
    return p->trapframe->a2;
    80001c96:	6d3c                	ld	a5,88(a0)
    80001c98:	63c8                	ld	a0,128(a5)
    80001c9a:	b7f5                	j	80001c86 <argraw+0x2c>
    return p->trapframe->a3;
    80001c9c:	6d3c                	ld	a5,88(a0)
    80001c9e:	67c8                	ld	a0,136(a5)
    80001ca0:	b7dd                	j	80001c86 <argraw+0x2c>
    return p->trapframe->a4;
    80001ca2:	6d3c                	ld	a5,88(a0)
    80001ca4:	6bc8                	ld	a0,144(a5)
    80001ca6:	b7c5                	j	80001c86 <argraw+0x2c>
    return p->trapframe->a5;
    80001ca8:	6d3c                	ld	a5,88(a0)
    80001caa:	6fc8                	ld	a0,152(a5)
    80001cac:	bfe9                	j	80001c86 <argraw+0x2c>
  panic("argraw");
    80001cae:	00005517          	auipc	a0,0x5
    80001cb2:	65a50513          	addi	a0,a0,1626 # 80007308 <etext+0x308>
    80001cb6:	333030ef          	jal	800057e8 <panic>

0000000080001cba <fetchaddr>:
{
    80001cba:	1101                	addi	sp,sp,-32
    80001cbc:	ec06                	sd	ra,24(sp)
    80001cbe:	e822                	sd	s0,16(sp)
    80001cc0:	e426                	sd	s1,8(sp)
    80001cc2:	e04a                	sd	s2,0(sp)
    80001cc4:	1000                	addi	s0,sp,32
    80001cc6:	84aa                	mv	s1,a0
    80001cc8:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001cca:	8beff0ef          	jal	80000d88 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001cce:	653c                	ld	a5,72(a0)
    80001cd0:	02f4f663          	bgeu	s1,a5,80001cfc <fetchaddr+0x42>
    80001cd4:	00848713          	addi	a4,s1,8
    80001cd8:	02e7e463          	bltu	a5,a4,80001d00 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001cdc:	46a1                	li	a3,8
    80001cde:	8626                	mv	a2,s1
    80001ce0:	85ca                	mv	a1,s2
    80001ce2:	6928                	ld	a0,80(a0)
    80001ce4:	e95fe0ef          	jal	80000b78 <copyin>
    80001ce8:	00a03533          	snez	a0,a0
    80001cec:	40a0053b          	negw	a0,a0
}
    80001cf0:	60e2                	ld	ra,24(sp)
    80001cf2:	6442                	ld	s0,16(sp)
    80001cf4:	64a2                	ld	s1,8(sp)
    80001cf6:	6902                	ld	s2,0(sp)
    80001cf8:	6105                	addi	sp,sp,32
    80001cfa:	8082                	ret
    return -1;
    80001cfc:	557d                	li	a0,-1
    80001cfe:	bfcd                	j	80001cf0 <fetchaddr+0x36>
    80001d00:	557d                	li	a0,-1
    80001d02:	b7fd                	j	80001cf0 <fetchaddr+0x36>

0000000080001d04 <fetchstr>:
{
    80001d04:	7179                	addi	sp,sp,-48
    80001d06:	f406                	sd	ra,40(sp)
    80001d08:	f022                	sd	s0,32(sp)
    80001d0a:	ec26                	sd	s1,24(sp)
    80001d0c:	e84a                	sd	s2,16(sp)
    80001d0e:	e44e                	sd	s3,8(sp)
    80001d10:	1800                	addi	s0,sp,48
    80001d12:	89aa                	mv	s3,a0
    80001d14:	84ae                	mv	s1,a1
    80001d16:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001d18:	870ff0ef          	jal	80000d88 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001d1c:	86ca                	mv	a3,s2
    80001d1e:	864e                	mv	a2,s3
    80001d20:	85a6                	mv	a1,s1
    80001d22:	6928                	ld	a0,80(a0)
    80001d24:	c3bfe0ef          	jal	8000095e <copyinstr>
    80001d28:	00054c63          	bltz	a0,80001d40 <fetchstr+0x3c>
  return strlen(buf);
    80001d2c:	8526                	mv	a0,s1
    80001d2e:	dbafe0ef          	jal	800002e8 <strlen>
}
    80001d32:	70a2                	ld	ra,40(sp)
    80001d34:	7402                	ld	s0,32(sp)
    80001d36:	64e2                	ld	s1,24(sp)
    80001d38:	6942                	ld	s2,16(sp)
    80001d3a:	69a2                	ld	s3,8(sp)
    80001d3c:	6145                	addi	sp,sp,48
    80001d3e:	8082                	ret
    return -1;
    80001d40:	557d                	li	a0,-1
    80001d42:	bfc5                	j	80001d32 <fetchstr+0x2e>

0000000080001d44 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001d44:	1101                	addi	sp,sp,-32
    80001d46:	ec06                	sd	ra,24(sp)
    80001d48:	e822                	sd	s0,16(sp)
    80001d4a:	e426                	sd	s1,8(sp)
    80001d4c:	1000                	addi	s0,sp,32
    80001d4e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d50:	f0bff0ef          	jal	80001c5a <argraw>
    80001d54:	c088                	sw	a0,0(s1)
}
    80001d56:	60e2                	ld	ra,24(sp)
    80001d58:	6442                	ld	s0,16(sp)
    80001d5a:	64a2                	ld	s1,8(sp)
    80001d5c:	6105                	addi	sp,sp,32
    80001d5e:	8082                	ret

0000000080001d60 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001d60:	1101                	addi	sp,sp,-32
    80001d62:	ec06                	sd	ra,24(sp)
    80001d64:	e822                	sd	s0,16(sp)
    80001d66:	e426                	sd	s1,8(sp)
    80001d68:	1000                	addi	s0,sp,32
    80001d6a:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001d6c:	eefff0ef          	jal	80001c5a <argraw>
    80001d70:	e088                	sd	a0,0(s1)
}
    80001d72:	60e2                	ld	ra,24(sp)
    80001d74:	6442                	ld	s0,16(sp)
    80001d76:	64a2                	ld	s1,8(sp)
    80001d78:	6105                	addi	sp,sp,32
    80001d7a:	8082                	ret

0000000080001d7c <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001d7c:	1101                	addi	sp,sp,-32
    80001d7e:	ec06                	sd	ra,24(sp)
    80001d80:	e822                	sd	s0,16(sp)
    80001d82:	e426                	sd	s1,8(sp)
    80001d84:	e04a                	sd	s2,0(sp)
    80001d86:	1000                	addi	s0,sp,32
    80001d88:	892e                	mv	s2,a1
    80001d8a:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001d8c:	ecfff0ef          	jal	80001c5a <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001d90:	8626                	mv	a2,s1
    80001d92:	85ca                	mv	a1,s2
    80001d94:	f71ff0ef          	jal	80001d04 <fetchstr>
}
    80001d98:	60e2                	ld	ra,24(sp)
    80001d9a:	6442                	ld	s0,16(sp)
    80001d9c:	64a2                	ld	s1,8(sp)
    80001d9e:	6902                	ld	s2,0(sp)
    80001da0:	6105                	addi	sp,sp,32
    80001da2:	8082                	ret

0000000080001da4 <syscall>:
[SYS_sigreturn]   sys_sigreturn,
};

void
syscall(void)
{
    80001da4:	1101                	addi	sp,sp,-32
    80001da6:	ec06                	sd	ra,24(sp)
    80001da8:	e822                	sd	s0,16(sp)
    80001daa:	e426                	sd	s1,8(sp)
    80001dac:	e04a                	sd	s2,0(sp)
    80001dae:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001db0:	fd9fe0ef          	jal	80000d88 <myproc>
    80001db4:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001db6:	05853903          	ld	s2,88(a0)
    80001dba:	0a893783          	ld	a5,168(s2)
    80001dbe:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001dc2:	37fd                	addiw	a5,a5,-1
    80001dc4:	4759                	li	a4,22
    80001dc6:	00f76f63          	bltu	a4,a5,80001de4 <syscall+0x40>
    80001dca:	00369713          	slli	a4,a3,0x3
    80001dce:	00006797          	auipc	a5,0x6
    80001dd2:	9a278793          	addi	a5,a5,-1630 # 80007770 <syscalls>
    80001dd6:	97ba                	add	a5,a5,a4
    80001dd8:	639c                	ld	a5,0(a5)
    80001dda:	c789                	beqz	a5,80001de4 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001ddc:	9782                	jalr	a5
    80001dde:	06a93823          	sd	a0,112(s2)
    80001de2:	a829                	j	80001dfc <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001de4:	15848613          	addi	a2,s1,344
    80001de8:	588c                	lw	a1,48(s1)
    80001dea:	00005517          	auipc	a0,0x5
    80001dee:	52650513          	addi	a0,a0,1318 # 80007310 <etext+0x310>
    80001df2:	64a030ef          	jal	8000543c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001df6:	6cbc                	ld	a5,88(s1)
    80001df8:	577d                	li	a4,-1
    80001dfa:	fbb8                	sd	a4,112(a5)
  }
}
    80001dfc:	60e2                	ld	ra,24(sp)
    80001dfe:	6442                	ld	s0,16(sp)
    80001e00:	64a2                	ld	s1,8(sp)
    80001e02:	6902                	ld	s2,0(sp)
    80001e04:	6105                	addi	sp,sp,32
    80001e06:	8082                	ret

0000000080001e08 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001e08:	1101                	addi	sp,sp,-32
    80001e0a:	ec06                	sd	ra,24(sp)
    80001e0c:	e822                	sd	s0,16(sp)
    80001e0e:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001e10:	fec40593          	addi	a1,s0,-20
    80001e14:	4501                	li	a0,0
    80001e16:	f2fff0ef          	jal	80001d44 <argint>
  kexit(n);
    80001e1a:	fec42503          	lw	a0,-20(s0)
    80001e1e:	eeaff0ef          	jal	80001508 <kexit>
  return 0;  // not reached
}
    80001e22:	4501                	li	a0,0
    80001e24:	60e2                	ld	ra,24(sp)
    80001e26:	6442                	ld	s0,16(sp)
    80001e28:	6105                	addi	sp,sp,32
    80001e2a:	8082                	ret

0000000080001e2c <sys_getpid>:

uint64
sys_getpid(void)
{
    80001e2c:	1141                	addi	sp,sp,-16
    80001e2e:	e406                	sd	ra,8(sp)
    80001e30:	e022                	sd	s0,0(sp)
    80001e32:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001e34:	f55fe0ef          	jal	80000d88 <myproc>
}
    80001e38:	5908                	lw	a0,48(a0)
    80001e3a:	60a2                	ld	ra,8(sp)
    80001e3c:	6402                	ld	s0,0(sp)
    80001e3e:	0141                	addi	sp,sp,16
    80001e40:	8082                	ret

0000000080001e42 <sys_fork>:

uint64
sys_fork(void)
{
    80001e42:	1141                	addi	sp,sp,-16
    80001e44:	e406                	sd	ra,8(sp)
    80001e46:	e022                	sd	s0,0(sp)
    80001e48:	0800                	addi	s0,sp,16
  return kfork();
    80001e4a:	ac0ff0ef          	jal	8000110a <kfork>
}
    80001e4e:	60a2                	ld	ra,8(sp)
    80001e50:	6402                	ld	s0,0(sp)
    80001e52:	0141                	addi	sp,sp,16
    80001e54:	8082                	ret

0000000080001e56 <sys_wait>:

uint64
sys_wait(void)
{
    80001e56:	1101                	addi	sp,sp,-32
    80001e58:	ec06                	sd	ra,24(sp)
    80001e5a:	e822                	sd	s0,16(sp)
    80001e5c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e5e:	fe840593          	addi	a1,s0,-24
    80001e62:	4501                	li	a0,0
    80001e64:	efdff0ef          	jal	80001d60 <argaddr>
  return kwait(p);
    80001e68:	fe843503          	ld	a0,-24(s0)
    80001e6c:	ff6ff0ef          	jal	80001662 <kwait>
}
    80001e70:	60e2                	ld	ra,24(sp)
    80001e72:	6442                	ld	s0,16(sp)
    80001e74:	6105                	addi	sp,sp,32
    80001e76:	8082                	ret

0000000080001e78 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e78:	7179                	addi	sp,sp,-48
    80001e7a:	f406                	sd	ra,40(sp)
    80001e7c:	f022                	sd	s0,32(sp)
    80001e7e:	ec26                	sd	s1,24(sp)
    80001e80:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001e82:	fd840593          	addi	a1,s0,-40
    80001e86:	4501                	li	a0,0
    80001e88:	ebdff0ef          	jal	80001d44 <argint>
  argint(1, &t);
    80001e8c:	fdc40593          	addi	a1,s0,-36
    80001e90:	4505                	li	a0,1
    80001e92:	eb3ff0ef          	jal	80001d44 <argint>
  addr = myproc()->sz;
    80001e96:	ef3fe0ef          	jal	80000d88 <myproc>
    80001e9a:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001e9c:	fdc42703          	lw	a4,-36(s0)
    80001ea0:	4785                	li	a5,1
    80001ea2:	02f70163          	beq	a4,a5,80001ec4 <sys_sbrk+0x4c>
    80001ea6:	fd842783          	lw	a5,-40(s0)
    80001eaa:	0007cd63          	bltz	a5,80001ec4 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001eae:	97a6                	add	a5,a5,s1
    80001eb0:	0297e863          	bltu	a5,s1,80001ee0 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001eb4:	ed5fe0ef          	jal	80000d88 <myproc>
    80001eb8:	fd842703          	lw	a4,-40(s0)
    80001ebc:	653c                	ld	a5,72(a0)
    80001ebe:	97ba                	add	a5,a5,a4
    80001ec0:	e53c                	sd	a5,72(a0)
    80001ec2:	a039                	j	80001ed0 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001ec4:	fd842503          	lw	a0,-40(s0)
    80001ec8:	9f2ff0ef          	jal	800010ba <growproc>
    80001ecc:	00054863          	bltz	a0,80001edc <sys_sbrk+0x64>
  }
  return addr;
}
    80001ed0:	8526                	mv	a0,s1
    80001ed2:	70a2                	ld	ra,40(sp)
    80001ed4:	7402                	ld	s0,32(sp)
    80001ed6:	64e2                	ld	s1,24(sp)
    80001ed8:	6145                	addi	sp,sp,48
    80001eda:	8082                	ret
      return -1;
    80001edc:	54fd                	li	s1,-1
    80001ede:	bfcd                	j	80001ed0 <sys_sbrk+0x58>
      return -1;
    80001ee0:	54fd                	li	s1,-1
    80001ee2:	b7fd                	j	80001ed0 <sys_sbrk+0x58>

0000000080001ee4 <sys_pause>:

uint64
sys_pause(void)
{
    80001ee4:	7139                	addi	sp,sp,-64
    80001ee6:	fc06                	sd	ra,56(sp)
    80001ee8:	f822                	sd	s0,48(sp)
    80001eea:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001eec:	fcc40593          	addi	a1,s0,-52
    80001ef0:	4501                	li	a0,0
    80001ef2:	e53ff0ef          	jal	80001d44 <argint>
  if(n < 0)
    80001ef6:	fcc42783          	lw	a5,-52(s0)
    80001efa:	0607ca63          	bltz	a5,80001f6e <sys_pause+0x8a>
    n = 0;
  acquire(&tickslock);
    80001efe:	0000c517          	auipc	a0,0xc
    80001f02:	fe250513          	addi	a0,a0,-30 # 8000dee0 <tickslock>
    80001f06:	385030ef          	jal	80005a8a <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001f0a:	fcc42783          	lw	a5,-52(s0)
    80001f0e:	c3b9                	beqz	a5,80001f54 <sys_pause+0x70>
    80001f10:	f426                	sd	s1,40(sp)
    80001f12:	f04a                	sd	s2,32(sp)
    80001f14:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001f16:	00006997          	auipc	s3,0x6
    80001f1a:	9629a983          	lw	s3,-1694(s3) # 80007878 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001f1e:	0000c917          	auipc	s2,0xc
    80001f22:	fc290913          	addi	s2,s2,-62 # 8000dee0 <tickslock>
    80001f26:	00006497          	auipc	s1,0x6
    80001f2a:	95248493          	addi	s1,s1,-1710 # 80007878 <ticks>
    if(killed(myproc())){
    80001f2e:	e5bfe0ef          	jal	80000d88 <myproc>
    80001f32:	f06ff0ef          	jal	80001638 <killed>
    80001f36:	ed1d                	bnez	a0,80001f74 <sys_pause+0x90>
    sleep(&ticks, &tickslock);
    80001f38:	85ca                	mv	a1,s2
    80001f3a:	8526                	mv	a0,s1
    80001f3c:	cc0ff0ef          	jal	800013fc <sleep>
  while(ticks - ticks0 < n){
    80001f40:	409c                	lw	a5,0(s1)
    80001f42:	413787bb          	subw	a5,a5,s3
    80001f46:	fcc42703          	lw	a4,-52(s0)
    80001f4a:	fee7e2e3          	bltu	a5,a4,80001f2e <sys_pause+0x4a>
    80001f4e:	74a2                	ld	s1,40(sp)
    80001f50:	7902                	ld	s2,32(sp)
    80001f52:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001f54:	0000c517          	auipc	a0,0xc
    80001f58:	f8c50513          	addi	a0,a0,-116 # 8000dee0 <tickslock>
    80001f5c:	3c3030ef          	jal	80005b1e <release>

  backtrace();
    80001f60:	02b030ef          	jal	8000578a <backtrace>

  return 0;
    80001f64:	4501                	li	a0,0
}
    80001f66:	70e2                	ld	ra,56(sp)
    80001f68:	7442                	ld	s0,48(sp)
    80001f6a:	6121                	addi	sp,sp,64
    80001f6c:	8082                	ret
    n = 0;
    80001f6e:	fc042623          	sw	zero,-52(s0)
    80001f72:	b771                	j	80001efe <sys_pause+0x1a>
      release(&tickslock);
    80001f74:	0000c517          	auipc	a0,0xc
    80001f78:	f6c50513          	addi	a0,a0,-148 # 8000dee0 <tickslock>
    80001f7c:	3a3030ef          	jal	80005b1e <release>
      return -1;
    80001f80:	557d                	li	a0,-1
    80001f82:	74a2                	ld	s1,40(sp)
    80001f84:	7902                	ld	s2,32(sp)
    80001f86:	69e2                	ld	s3,24(sp)
    80001f88:	bff9                	j	80001f66 <sys_pause+0x82>

0000000080001f8a <sys_kill>:

uint64
sys_kill(void)
{
    80001f8a:	1101                	addi	sp,sp,-32
    80001f8c:	ec06                	sd	ra,24(sp)
    80001f8e:	e822                	sd	s0,16(sp)
    80001f90:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f92:	fec40593          	addi	a1,s0,-20
    80001f96:	4501                	li	a0,0
    80001f98:	dadff0ef          	jal	80001d44 <argint>
  return kkill(pid);
    80001f9c:	fec42503          	lw	a0,-20(s0)
    80001fa0:	e0eff0ef          	jal	800015ae <kkill>
}
    80001fa4:	60e2                	ld	ra,24(sp)
    80001fa6:	6442                	ld	s0,16(sp)
    80001fa8:	6105                	addi	sp,sp,32
    80001faa:	8082                	ret

0000000080001fac <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001fac:	1101                	addi	sp,sp,-32
    80001fae:	ec06                	sd	ra,24(sp)
    80001fb0:	e822                	sd	s0,16(sp)
    80001fb2:	e426                	sd	s1,8(sp)
    80001fb4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001fb6:	0000c517          	auipc	a0,0xc
    80001fba:	f2a50513          	addi	a0,a0,-214 # 8000dee0 <tickslock>
    80001fbe:	2cd030ef          	jal	80005a8a <acquire>
  xticks = ticks;
    80001fc2:	00006797          	auipc	a5,0x6
    80001fc6:	8b67a783          	lw	a5,-1866(a5) # 80007878 <ticks>
    80001fca:	84be                	mv	s1,a5
  release(&tickslock);
    80001fcc:	0000c517          	auipc	a0,0xc
    80001fd0:	f1450513          	addi	a0,a0,-236 # 8000dee0 <tickslock>
    80001fd4:	34b030ef          	jal	80005b1e <release>
  return xticks;
}
    80001fd8:	02049513          	slli	a0,s1,0x20
    80001fdc:	9101                	srli	a0,a0,0x20
    80001fde:	60e2                	ld	ra,24(sp)
    80001fe0:	6442                	ld	s0,16(sp)
    80001fe2:	64a2                	ld	s1,8(sp)
    80001fe4:	6105                	addi	sp,sp,32
    80001fe6:	8082                	ret

0000000080001fe8 <sys_sigalarm>:

uint64
sys_sigalarm(void)
{
    80001fe8:	1101                	addi	sp,sp,-32
    80001fea:	ec06                	sd	ra,24(sp)
    80001fec:	e822                	sd	s0,16(sp)
    80001fee:	1000                	addi	s0,sp,32
  int interval;
  uint64 handler;
  struct proc *p;  

  argint(0, &interval);
    80001ff0:	fec40593          	addi	a1,s0,-20
    80001ff4:	4501                	li	a0,0
    80001ff6:	d4fff0ef          	jal	80001d44 <argint>
  if(interval < 0)
    80001ffa:	fec42783          	lw	a5,-20(s0)
    return -1;
    80001ffe:	557d                	li	a0,-1
  if(interval < 0)
    80002000:	0207c263          	bltz	a5,80002024 <sys_sigalarm+0x3c>
  argaddr(1, &handler);
    80002004:	fe040593          	addi	a1,s0,-32
    80002008:	4505                	li	a0,1
    8000200a:	d57ff0ef          	jal	80001d60 <argaddr>

  p = myproc();
    8000200e:	d7bfe0ef          	jal	80000d88 <myproc>

  p->interval = interval;
    80002012:	fec42783          	lw	a5,-20(s0)
    80002016:	16f52623          	sw	a5,364(a0)
  p->handler = handler;
    8000201a:	fe043783          	ld	a5,-32(s0)
    8000201e:	16f53c23          	sd	a5,376(a0)

  return 0;
    80002022:	4501                	li	a0,0
}
    80002024:	60e2                	ld	ra,24(sp)
    80002026:	6442                	ld	s0,16(sp)
    80002028:	6105                	addi	sp,sp,32
    8000202a:	8082                	ret

000000008000202c <sys_sigreturn>:

uint64
sys_sigreturn(void)
{
    8000202c:	1101                	addi	sp,sp,-32
    8000202e:	ec06                	sd	ra,24(sp)
    80002030:	e822                	sd	s0,16(sp)
    80002032:	e426                	sd	s1,8(sp)
    80002034:	1000                	addi	s0,sp,32
  struct proc *p;  

  p = myproc();
    80002036:	d53fe0ef          	jal	80000d88 <myproc>
    8000203a:	84aa                	mv	s1,a0

  // re-arm
  p->ticks = 0;
    8000203c:	16052423          	sw	zero,360(a0)
  p->sigreturn = true;
    80002040:	4785                	li	a5,1
    80002042:	16f50823          	sb	a5,368(a0)

  // restore registers by restoring the trapframe
  memmove(p->trapframe, p->saved_trapframe, sizeof(struct trapframe));
    80002046:	12000613          	li	a2,288
    8000204a:	18053583          	ld	a1,384(a0)
    8000204e:	6d28                	ld	a0,88(a0)
    80002050:	96efe0ef          	jal	800001be <memmove>

  // restore a0
  return p->trapframe->a0;
    80002054:	6cbc                	ld	a5,88(s1)
}
    80002056:	7ba8                	ld	a0,112(a5)
    80002058:	60e2                	ld	ra,24(sp)
    8000205a:	6442                	ld	s0,16(sp)
    8000205c:	64a2                	ld	s1,8(sp)
    8000205e:	6105                	addi	sp,sp,32
    80002060:	8082                	ret

0000000080002062 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002062:	7179                	addi	sp,sp,-48
    80002064:	f406                	sd	ra,40(sp)
    80002066:	f022                	sd	s0,32(sp)
    80002068:	ec26                	sd	s1,24(sp)
    8000206a:	e84a                	sd	s2,16(sp)
    8000206c:	e44e                	sd	s3,8(sp)
    8000206e:	e052                	sd	s4,0(sp)
    80002070:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002072:	00005597          	auipc	a1,0x5
    80002076:	2be58593          	addi	a1,a1,702 # 80007330 <etext+0x330>
    8000207a:	0000c517          	auipc	a0,0xc
    8000207e:	e7e50513          	addi	a0,a0,-386 # 8000def8 <bcache>
    80002082:	17f030ef          	jal	80005a00 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002086:	00014797          	auipc	a5,0x14
    8000208a:	e7278793          	addi	a5,a5,-398 # 80015ef8 <bcache+0x8000>
    8000208e:	00014717          	auipc	a4,0x14
    80002092:	0d270713          	addi	a4,a4,210 # 80016160 <bcache+0x8268>
    80002096:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000209a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000209e:	0000c497          	auipc	s1,0xc
    800020a2:	e7248493          	addi	s1,s1,-398 # 8000df10 <bcache+0x18>
    b->next = bcache.head.next;
    800020a6:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800020a8:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800020aa:	00005a17          	auipc	s4,0x5
    800020ae:	28ea0a13          	addi	s4,s4,654 # 80007338 <etext+0x338>
    b->next = bcache.head.next;
    800020b2:	2b893783          	ld	a5,696(s2)
    800020b6:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800020b8:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800020bc:	85d2                	mv	a1,s4
    800020be:	01048513          	addi	a0,s1,16
    800020c2:	328010ef          	jal	800033ea <initsleeplock>
    bcache.head.next->prev = b;
    800020c6:	2b893783          	ld	a5,696(s2)
    800020ca:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800020cc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020d0:	45848493          	addi	s1,s1,1112
    800020d4:	fd349fe3          	bne	s1,s3,800020b2 <binit+0x50>
  }
}
    800020d8:	70a2                	ld	ra,40(sp)
    800020da:	7402                	ld	s0,32(sp)
    800020dc:	64e2                	ld	s1,24(sp)
    800020de:	6942                	ld	s2,16(sp)
    800020e0:	69a2                	ld	s3,8(sp)
    800020e2:	6a02                	ld	s4,0(sp)
    800020e4:	6145                	addi	sp,sp,48
    800020e6:	8082                	ret

00000000800020e8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800020e8:	7179                	addi	sp,sp,-48
    800020ea:	f406                	sd	ra,40(sp)
    800020ec:	f022                	sd	s0,32(sp)
    800020ee:	ec26                	sd	s1,24(sp)
    800020f0:	e84a                	sd	s2,16(sp)
    800020f2:	e44e                	sd	s3,8(sp)
    800020f4:	1800                	addi	s0,sp,48
    800020f6:	892a                	mv	s2,a0
    800020f8:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800020fa:	0000c517          	auipc	a0,0xc
    800020fe:	dfe50513          	addi	a0,a0,-514 # 8000def8 <bcache>
    80002102:	189030ef          	jal	80005a8a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002106:	00014497          	auipc	s1,0x14
    8000210a:	0aa4b483          	ld	s1,170(s1) # 800161b0 <bcache+0x82b8>
    8000210e:	00014797          	auipc	a5,0x14
    80002112:	05278793          	addi	a5,a5,82 # 80016160 <bcache+0x8268>
    80002116:	02f48b63          	beq	s1,a5,8000214c <bread+0x64>
    8000211a:	873e                	mv	a4,a5
    8000211c:	a021                	j	80002124 <bread+0x3c>
    8000211e:	68a4                	ld	s1,80(s1)
    80002120:	02e48663          	beq	s1,a4,8000214c <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002124:	449c                	lw	a5,8(s1)
    80002126:	ff279ce3          	bne	a5,s2,8000211e <bread+0x36>
    8000212a:	44dc                	lw	a5,12(s1)
    8000212c:	ff3799e3          	bne	a5,s3,8000211e <bread+0x36>
      b->refcnt++;
    80002130:	40bc                	lw	a5,64(s1)
    80002132:	2785                	addiw	a5,a5,1
    80002134:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002136:	0000c517          	auipc	a0,0xc
    8000213a:	dc250513          	addi	a0,a0,-574 # 8000def8 <bcache>
    8000213e:	1e1030ef          	jal	80005b1e <release>
      acquiresleep(&b->lock);
    80002142:	01048513          	addi	a0,s1,16
    80002146:	2da010ef          	jal	80003420 <acquiresleep>
      return b;
    8000214a:	a889                	j	8000219c <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000214c:	00014497          	auipc	s1,0x14
    80002150:	05c4b483          	ld	s1,92(s1) # 800161a8 <bcache+0x82b0>
    80002154:	00014797          	auipc	a5,0x14
    80002158:	00c78793          	addi	a5,a5,12 # 80016160 <bcache+0x8268>
    8000215c:	00f48863          	beq	s1,a5,8000216c <bread+0x84>
    80002160:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002162:	40bc                	lw	a5,64(s1)
    80002164:	cb91                	beqz	a5,80002178 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002166:	64a4                	ld	s1,72(s1)
    80002168:	fee49de3          	bne	s1,a4,80002162 <bread+0x7a>
  panic("bget: no buffers");
    8000216c:	00005517          	auipc	a0,0x5
    80002170:	1d450513          	addi	a0,a0,468 # 80007340 <etext+0x340>
    80002174:	674030ef          	jal	800057e8 <panic>
      b->dev = dev;
    80002178:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000217c:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002180:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002184:	4785                	li	a5,1
    80002186:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002188:	0000c517          	auipc	a0,0xc
    8000218c:	d7050513          	addi	a0,a0,-656 # 8000def8 <bcache>
    80002190:	18f030ef          	jal	80005b1e <release>
      acquiresleep(&b->lock);
    80002194:	01048513          	addi	a0,s1,16
    80002198:	288010ef          	jal	80003420 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000219c:	409c                	lw	a5,0(s1)
    8000219e:	cb89                	beqz	a5,800021b0 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800021a0:	8526                	mv	a0,s1
    800021a2:	70a2                	ld	ra,40(sp)
    800021a4:	7402                	ld	s0,32(sp)
    800021a6:	64e2                	ld	s1,24(sp)
    800021a8:	6942                	ld	s2,16(sp)
    800021aa:	69a2                	ld	s3,8(sp)
    800021ac:	6145                	addi	sp,sp,48
    800021ae:	8082                	ret
    virtio_disk_rw(b, 0);
    800021b0:	4581                	li	a1,0
    800021b2:	8526                	mv	a0,s1
    800021b4:	2ed020ef          	jal	80004ca0 <virtio_disk_rw>
    b->valid = 1;
    800021b8:	4785                	li	a5,1
    800021ba:	c09c                	sw	a5,0(s1)
  return b;
    800021bc:	b7d5                	j	800021a0 <bread+0xb8>

00000000800021be <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800021be:	1101                	addi	sp,sp,-32
    800021c0:	ec06                	sd	ra,24(sp)
    800021c2:	e822                	sd	s0,16(sp)
    800021c4:	e426                	sd	s1,8(sp)
    800021c6:	1000                	addi	s0,sp,32
    800021c8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021ca:	0541                	addi	a0,a0,16
    800021cc:	2d2010ef          	jal	8000349e <holdingsleep>
    800021d0:	c911                	beqz	a0,800021e4 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021d2:	4585                	li	a1,1
    800021d4:	8526                	mv	a0,s1
    800021d6:	2cb020ef          	jal	80004ca0 <virtio_disk_rw>
}
    800021da:	60e2                	ld	ra,24(sp)
    800021dc:	6442                	ld	s0,16(sp)
    800021de:	64a2                	ld	s1,8(sp)
    800021e0:	6105                	addi	sp,sp,32
    800021e2:	8082                	ret
    panic("bwrite");
    800021e4:	00005517          	auipc	a0,0x5
    800021e8:	17450513          	addi	a0,a0,372 # 80007358 <etext+0x358>
    800021ec:	5fc030ef          	jal	800057e8 <panic>

00000000800021f0 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800021f0:	1101                	addi	sp,sp,-32
    800021f2:	ec06                	sd	ra,24(sp)
    800021f4:	e822                	sd	s0,16(sp)
    800021f6:	e426                	sd	s1,8(sp)
    800021f8:	e04a                	sd	s2,0(sp)
    800021fa:	1000                	addi	s0,sp,32
    800021fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021fe:	01050913          	addi	s2,a0,16
    80002202:	854a                	mv	a0,s2
    80002204:	29a010ef          	jal	8000349e <holdingsleep>
    80002208:	c125                	beqz	a0,80002268 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    8000220a:	854a                	mv	a0,s2
    8000220c:	25a010ef          	jal	80003466 <releasesleep>

  acquire(&bcache.lock);
    80002210:	0000c517          	auipc	a0,0xc
    80002214:	ce850513          	addi	a0,a0,-792 # 8000def8 <bcache>
    80002218:	073030ef          	jal	80005a8a <acquire>
  b->refcnt--;
    8000221c:	40bc                	lw	a5,64(s1)
    8000221e:	37fd                	addiw	a5,a5,-1
    80002220:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002222:	e79d                	bnez	a5,80002250 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002224:	68b8                	ld	a4,80(s1)
    80002226:	64bc                	ld	a5,72(s1)
    80002228:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000222a:	68b8                	ld	a4,80(s1)
    8000222c:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000222e:	00014797          	auipc	a5,0x14
    80002232:	cca78793          	addi	a5,a5,-822 # 80015ef8 <bcache+0x8000>
    80002236:	2b87b703          	ld	a4,696(a5)
    8000223a:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000223c:	00014717          	auipc	a4,0x14
    80002240:	f2470713          	addi	a4,a4,-220 # 80016160 <bcache+0x8268>
    80002244:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002246:	2b87b703          	ld	a4,696(a5)
    8000224a:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000224c:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002250:	0000c517          	auipc	a0,0xc
    80002254:	ca850513          	addi	a0,a0,-856 # 8000def8 <bcache>
    80002258:	0c7030ef          	jal	80005b1e <release>
}
    8000225c:	60e2                	ld	ra,24(sp)
    8000225e:	6442                	ld	s0,16(sp)
    80002260:	64a2                	ld	s1,8(sp)
    80002262:	6902                	ld	s2,0(sp)
    80002264:	6105                	addi	sp,sp,32
    80002266:	8082                	ret
    panic("brelse");
    80002268:	00005517          	auipc	a0,0x5
    8000226c:	0f850513          	addi	a0,a0,248 # 80007360 <etext+0x360>
    80002270:	578030ef          	jal	800057e8 <panic>

0000000080002274 <bpin>:

void
bpin(struct buf *b) {
    80002274:	1101                	addi	sp,sp,-32
    80002276:	ec06                	sd	ra,24(sp)
    80002278:	e822                	sd	s0,16(sp)
    8000227a:	e426                	sd	s1,8(sp)
    8000227c:	1000                	addi	s0,sp,32
    8000227e:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002280:	0000c517          	auipc	a0,0xc
    80002284:	c7850513          	addi	a0,a0,-904 # 8000def8 <bcache>
    80002288:	003030ef          	jal	80005a8a <acquire>
  b->refcnt++;
    8000228c:	40bc                	lw	a5,64(s1)
    8000228e:	2785                	addiw	a5,a5,1
    80002290:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002292:	0000c517          	auipc	a0,0xc
    80002296:	c6650513          	addi	a0,a0,-922 # 8000def8 <bcache>
    8000229a:	085030ef          	jal	80005b1e <release>
}
    8000229e:	60e2                	ld	ra,24(sp)
    800022a0:	6442                	ld	s0,16(sp)
    800022a2:	64a2                	ld	s1,8(sp)
    800022a4:	6105                	addi	sp,sp,32
    800022a6:	8082                	ret

00000000800022a8 <bunpin>:

void
bunpin(struct buf *b) {
    800022a8:	1101                	addi	sp,sp,-32
    800022aa:	ec06                	sd	ra,24(sp)
    800022ac:	e822                	sd	s0,16(sp)
    800022ae:	e426                	sd	s1,8(sp)
    800022b0:	1000                	addi	s0,sp,32
    800022b2:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800022b4:	0000c517          	auipc	a0,0xc
    800022b8:	c4450513          	addi	a0,a0,-956 # 8000def8 <bcache>
    800022bc:	7ce030ef          	jal	80005a8a <acquire>
  b->refcnt--;
    800022c0:	40bc                	lw	a5,64(s1)
    800022c2:	37fd                	addiw	a5,a5,-1
    800022c4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800022c6:	0000c517          	auipc	a0,0xc
    800022ca:	c3250513          	addi	a0,a0,-974 # 8000def8 <bcache>
    800022ce:	051030ef          	jal	80005b1e <release>
}
    800022d2:	60e2                	ld	ra,24(sp)
    800022d4:	6442                	ld	s0,16(sp)
    800022d6:	64a2                	ld	s1,8(sp)
    800022d8:	6105                	addi	sp,sp,32
    800022da:	8082                	ret

00000000800022dc <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800022dc:	1101                	addi	sp,sp,-32
    800022de:	ec06                	sd	ra,24(sp)
    800022e0:	e822                	sd	s0,16(sp)
    800022e2:	e426                	sd	s1,8(sp)
    800022e4:	e04a                	sd	s2,0(sp)
    800022e6:	1000                	addi	s0,sp,32
    800022e8:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800022ea:	00d5d79b          	srliw	a5,a1,0xd
    800022ee:	00014597          	auipc	a1,0x14
    800022f2:	2e65a583          	lw	a1,742(a1) # 800165d4 <sb+0x1c>
    800022f6:	9dbd                	addw	a1,a1,a5
    800022f8:	df1ff0ef          	jal	800020e8 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800022fc:	0074f713          	andi	a4,s1,7
    80002300:	4785                	li	a5,1
    80002302:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002306:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    80002308:	90d9                	srli	s1,s1,0x36
    8000230a:	00950733          	add	a4,a0,s1
    8000230e:	05874703          	lbu	a4,88(a4)
    80002312:	00e7f6b3          	and	a3,a5,a4
    80002316:	c29d                	beqz	a3,8000233c <bfree+0x60>
    80002318:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000231a:	94aa                	add	s1,s1,a0
    8000231c:	fff7c793          	not	a5,a5
    80002320:	8f7d                	and	a4,a4,a5
    80002322:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002326:	000010ef          	jal	80003326 <log_write>
  brelse(bp);
    8000232a:	854a                	mv	a0,s2
    8000232c:	ec5ff0ef          	jal	800021f0 <brelse>
}
    80002330:	60e2                	ld	ra,24(sp)
    80002332:	6442                	ld	s0,16(sp)
    80002334:	64a2                	ld	s1,8(sp)
    80002336:	6902                	ld	s2,0(sp)
    80002338:	6105                	addi	sp,sp,32
    8000233a:	8082                	ret
    panic("freeing free block");
    8000233c:	00005517          	auipc	a0,0x5
    80002340:	02c50513          	addi	a0,a0,44 # 80007368 <etext+0x368>
    80002344:	4a4030ef          	jal	800057e8 <panic>

0000000080002348 <balloc>:
{
    80002348:	715d                	addi	sp,sp,-80
    8000234a:	e486                	sd	ra,72(sp)
    8000234c:	e0a2                	sd	s0,64(sp)
    8000234e:	fc26                	sd	s1,56(sp)
    80002350:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002352:	00014797          	auipc	a5,0x14
    80002356:	26a7a783          	lw	a5,618(a5) # 800165bc <sb+0x4>
    8000235a:	0e078263          	beqz	a5,8000243e <balloc+0xf6>
    8000235e:	f84a                	sd	s2,48(sp)
    80002360:	f44e                	sd	s3,40(sp)
    80002362:	f052                	sd	s4,32(sp)
    80002364:	ec56                	sd	s5,24(sp)
    80002366:	e85a                	sd	s6,16(sp)
    80002368:	e45e                	sd	s7,8(sp)
    8000236a:	e062                	sd	s8,0(sp)
    8000236c:	8baa                	mv	s7,a0
    8000236e:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002370:	00014b17          	auipc	s6,0x14
    80002374:	248b0b13          	addi	s6,s6,584 # 800165b8 <sb>
      m = 1 << (bi % 8);
    80002378:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000237a:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000237c:	6c09                	lui	s8,0x2
    8000237e:	a09d                	j	800023e4 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002380:	97ca                	add	a5,a5,s2
    80002382:	8e55                	or	a2,a2,a3
    80002384:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002388:	854a                	mv	a0,s2
    8000238a:	79d000ef          	jal	80003326 <log_write>
        brelse(bp);
    8000238e:	854a                	mv	a0,s2
    80002390:	e61ff0ef          	jal	800021f0 <brelse>
  bp = bread(dev, bno);
    80002394:	85a6                	mv	a1,s1
    80002396:	855e                	mv	a0,s7
    80002398:	d51ff0ef          	jal	800020e8 <bread>
    8000239c:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000239e:	40000613          	li	a2,1024
    800023a2:	4581                	li	a1,0
    800023a4:	05850513          	addi	a0,a0,88
    800023a8:	db7fd0ef          	jal	8000015e <memset>
  log_write(bp);
    800023ac:	854a                	mv	a0,s2
    800023ae:	779000ef          	jal	80003326 <log_write>
  brelse(bp);
    800023b2:	854a                	mv	a0,s2
    800023b4:	e3dff0ef          	jal	800021f0 <brelse>
}
    800023b8:	7942                	ld	s2,48(sp)
    800023ba:	79a2                	ld	s3,40(sp)
    800023bc:	7a02                	ld	s4,32(sp)
    800023be:	6ae2                	ld	s5,24(sp)
    800023c0:	6b42                	ld	s6,16(sp)
    800023c2:	6ba2                	ld	s7,8(sp)
    800023c4:	6c02                	ld	s8,0(sp)
}
    800023c6:	8526                	mv	a0,s1
    800023c8:	60a6                	ld	ra,72(sp)
    800023ca:	6406                	ld	s0,64(sp)
    800023cc:	74e2                	ld	s1,56(sp)
    800023ce:	6161                	addi	sp,sp,80
    800023d0:	8082                	ret
    brelse(bp);
    800023d2:	854a                	mv	a0,s2
    800023d4:	e1dff0ef          	jal	800021f0 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800023d8:	015c0abb          	addw	s5,s8,s5
    800023dc:	004b2783          	lw	a5,4(s6)
    800023e0:	04faf863          	bgeu	s5,a5,80002430 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800023e4:	40dad59b          	sraiw	a1,s5,0xd
    800023e8:	01cb2783          	lw	a5,28(s6)
    800023ec:	9dbd                	addw	a1,a1,a5
    800023ee:	855e                	mv	a0,s7
    800023f0:	cf9ff0ef          	jal	800020e8 <bread>
    800023f4:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023f6:	004b2503          	lw	a0,4(s6)
    800023fa:	84d6                	mv	s1,s5
    800023fc:	4701                	li	a4,0
    800023fe:	fca4fae3          	bgeu	s1,a0,800023d2 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002402:	00777693          	andi	a3,a4,7
    80002406:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000240a:	41f7579b          	sraiw	a5,a4,0x1f
    8000240e:	01d7d79b          	srliw	a5,a5,0x1d
    80002412:	9fb9                	addw	a5,a5,a4
    80002414:	4037d79b          	sraiw	a5,a5,0x3
    80002418:	00f90633          	add	a2,s2,a5
    8000241c:	05864603          	lbu	a2,88(a2)
    80002420:	00c6f5b3          	and	a1,a3,a2
    80002424:	ddb1                	beqz	a1,80002380 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002426:	2705                	addiw	a4,a4,1
    80002428:	2485                	addiw	s1,s1,1
    8000242a:	fd471ae3          	bne	a4,s4,800023fe <balloc+0xb6>
    8000242e:	b755                	j	800023d2 <balloc+0x8a>
    80002430:	7942                	ld	s2,48(sp)
    80002432:	79a2                	ld	s3,40(sp)
    80002434:	7a02                	ld	s4,32(sp)
    80002436:	6ae2                	ld	s5,24(sp)
    80002438:	6b42                	ld	s6,16(sp)
    8000243a:	6ba2                	ld	s7,8(sp)
    8000243c:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000243e:	00005517          	auipc	a0,0x5
    80002442:	f4250513          	addi	a0,a0,-190 # 80007380 <etext+0x380>
    80002446:	7f7020ef          	jal	8000543c <printf>
  return 0;
    8000244a:	4481                	li	s1,0
    8000244c:	bfad                	j	800023c6 <balloc+0x7e>

000000008000244e <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000244e:	7179                	addi	sp,sp,-48
    80002450:	f406                	sd	ra,40(sp)
    80002452:	f022                	sd	s0,32(sp)
    80002454:	ec26                	sd	s1,24(sp)
    80002456:	e84a                	sd	s2,16(sp)
    80002458:	e44e                	sd	s3,8(sp)
    8000245a:	1800                	addi	s0,sp,48
    8000245c:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000245e:	47ad                	li	a5,11
    80002460:	02b7e363          	bltu	a5,a1,80002486 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    80002464:	02059793          	slli	a5,a1,0x20
    80002468:	01e7d593          	srli	a1,a5,0x1e
    8000246c:	00b509b3          	add	s3,a0,a1
    80002470:	0509a483          	lw	s1,80(s3)
    80002474:	e0b5                	bnez	s1,800024d8 <bmap+0x8a>
      addr = balloc(ip->dev);
    80002476:	4108                	lw	a0,0(a0)
    80002478:	ed1ff0ef          	jal	80002348 <balloc>
    8000247c:	84aa                	mv	s1,a0
      if(addr == 0)
    8000247e:	cd29                	beqz	a0,800024d8 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002480:	04a9a823          	sw	a0,80(s3)
    80002484:	a891                	j	800024d8 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    80002486:	ff45879b          	addiw	a5,a1,-12
    8000248a:	873e                	mv	a4,a5
    8000248c:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    8000248e:	0ff00793          	li	a5,255
    80002492:	06e7e763          	bltu	a5,a4,80002500 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002496:	08052483          	lw	s1,128(a0)
    8000249a:	e891                	bnez	s1,800024ae <bmap+0x60>
      addr = balloc(ip->dev);
    8000249c:	4108                	lw	a0,0(a0)
    8000249e:	eabff0ef          	jal	80002348 <balloc>
    800024a2:	84aa                	mv	s1,a0
      if(addr == 0)
    800024a4:	c915                	beqz	a0,800024d8 <bmap+0x8a>
    800024a6:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800024a8:	08a92023          	sw	a0,128(s2)
    800024ac:	a011                	j	800024b0 <bmap+0x62>
    800024ae:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800024b0:	85a6                	mv	a1,s1
    800024b2:	00092503          	lw	a0,0(s2)
    800024b6:	c33ff0ef          	jal	800020e8 <bread>
    800024ba:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800024bc:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800024c0:	02099713          	slli	a4,s3,0x20
    800024c4:	01e75593          	srli	a1,a4,0x1e
    800024c8:	97ae                	add	a5,a5,a1
    800024ca:	89be                	mv	s3,a5
    800024cc:	4384                	lw	s1,0(a5)
    800024ce:	cc89                	beqz	s1,800024e8 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800024d0:	8552                	mv	a0,s4
    800024d2:	d1fff0ef          	jal	800021f0 <brelse>
    return addr;
    800024d6:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800024d8:	8526                	mv	a0,s1
    800024da:	70a2                	ld	ra,40(sp)
    800024dc:	7402                	ld	s0,32(sp)
    800024de:	64e2                	ld	s1,24(sp)
    800024e0:	6942                	ld	s2,16(sp)
    800024e2:	69a2                	ld	s3,8(sp)
    800024e4:	6145                	addi	sp,sp,48
    800024e6:	8082                	ret
      addr = balloc(ip->dev);
    800024e8:	00092503          	lw	a0,0(s2)
    800024ec:	e5dff0ef          	jal	80002348 <balloc>
    800024f0:	84aa                	mv	s1,a0
      if(addr){
    800024f2:	dd79                	beqz	a0,800024d0 <bmap+0x82>
        a[bn] = addr;
    800024f4:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800024f8:	8552                	mv	a0,s4
    800024fa:	62d000ef          	jal	80003326 <log_write>
    800024fe:	bfc9                	j	800024d0 <bmap+0x82>
    80002500:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002502:	00005517          	auipc	a0,0x5
    80002506:	e9650513          	addi	a0,a0,-362 # 80007398 <etext+0x398>
    8000250a:	2de030ef          	jal	800057e8 <panic>

000000008000250e <iget>:
{
    8000250e:	7179                	addi	sp,sp,-48
    80002510:	f406                	sd	ra,40(sp)
    80002512:	f022                	sd	s0,32(sp)
    80002514:	ec26                	sd	s1,24(sp)
    80002516:	e84a                	sd	s2,16(sp)
    80002518:	e44e                	sd	s3,8(sp)
    8000251a:	e052                	sd	s4,0(sp)
    8000251c:	1800                	addi	s0,sp,48
    8000251e:	892a                	mv	s2,a0
    80002520:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002522:	00014517          	auipc	a0,0x14
    80002526:	0b650513          	addi	a0,a0,182 # 800165d8 <itable>
    8000252a:	560030ef          	jal	80005a8a <acquire>
  empty = 0;
    8000252e:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002530:	00014497          	auipc	s1,0x14
    80002534:	0c048493          	addi	s1,s1,192 # 800165f0 <itable+0x18>
    80002538:	00016697          	auipc	a3,0x16
    8000253c:	b4868693          	addi	a3,a3,-1208 # 80018080 <log>
    80002540:	a809                	j	80002552 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002542:	e781                	bnez	a5,8000254a <iget+0x3c>
    80002544:	00099363          	bnez	s3,8000254a <iget+0x3c>
      empty = ip;
    80002548:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    8000254a:	08848493          	addi	s1,s1,136
    8000254e:	02d48563          	beq	s1,a3,80002578 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002552:	449c                	lw	a5,8(s1)
    80002554:	fef057e3          	blez	a5,80002542 <iget+0x34>
    80002558:	4098                	lw	a4,0(s1)
    8000255a:	ff2718e3          	bne	a4,s2,8000254a <iget+0x3c>
    8000255e:	40d8                	lw	a4,4(s1)
    80002560:	ff4715e3          	bne	a4,s4,8000254a <iget+0x3c>
      ip->ref++;
    80002564:	2785                	addiw	a5,a5,1
    80002566:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002568:	00014517          	auipc	a0,0x14
    8000256c:	07050513          	addi	a0,a0,112 # 800165d8 <itable>
    80002570:	5ae030ef          	jal	80005b1e <release>
      return ip;
    80002574:	89a6                	mv	s3,s1
    80002576:	a015                	j	8000259a <iget+0x8c>
  if(empty == 0)
    80002578:	02098a63          	beqz	s3,800025ac <iget+0x9e>
  ip->dev = dev;
    8000257c:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002580:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80002584:	4785                	li	a5,1
    80002586:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    8000258a:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000258e:	00014517          	auipc	a0,0x14
    80002592:	04a50513          	addi	a0,a0,74 # 800165d8 <itable>
    80002596:	588030ef          	jal	80005b1e <release>
}
    8000259a:	854e                	mv	a0,s3
    8000259c:	70a2                	ld	ra,40(sp)
    8000259e:	7402                	ld	s0,32(sp)
    800025a0:	64e2                	ld	s1,24(sp)
    800025a2:	6942                	ld	s2,16(sp)
    800025a4:	69a2                	ld	s3,8(sp)
    800025a6:	6a02                	ld	s4,0(sp)
    800025a8:	6145                	addi	sp,sp,48
    800025aa:	8082                	ret
    panic("iget: no inodes");
    800025ac:	00005517          	auipc	a0,0x5
    800025b0:	e0450513          	addi	a0,a0,-508 # 800073b0 <etext+0x3b0>
    800025b4:	234030ef          	jal	800057e8 <panic>

00000000800025b8 <iinit>:
{
    800025b8:	7179                	addi	sp,sp,-48
    800025ba:	f406                	sd	ra,40(sp)
    800025bc:	f022                	sd	s0,32(sp)
    800025be:	ec26                	sd	s1,24(sp)
    800025c0:	e84a                	sd	s2,16(sp)
    800025c2:	e44e                	sd	s3,8(sp)
    800025c4:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    800025c6:	00005597          	auipc	a1,0x5
    800025ca:	dfa58593          	addi	a1,a1,-518 # 800073c0 <etext+0x3c0>
    800025ce:	00014517          	auipc	a0,0x14
    800025d2:	00a50513          	addi	a0,a0,10 # 800165d8 <itable>
    800025d6:	42a030ef          	jal	80005a00 <initlock>
  for(i = 0; i < NINODE; i++) {
    800025da:	00014497          	auipc	s1,0x14
    800025de:	02648493          	addi	s1,s1,38 # 80016600 <itable+0x28>
    800025e2:	00016997          	auipc	s3,0x16
    800025e6:	aae98993          	addi	s3,s3,-1362 # 80018090 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025ea:	00005917          	auipc	s2,0x5
    800025ee:	dde90913          	addi	s2,s2,-546 # 800073c8 <etext+0x3c8>
    800025f2:	85ca                	mv	a1,s2
    800025f4:	8526                	mv	a0,s1
    800025f6:	5f5000ef          	jal	800033ea <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025fa:	08848493          	addi	s1,s1,136
    800025fe:	ff349ae3          	bne	s1,s3,800025f2 <iinit+0x3a>
}
    80002602:	70a2                	ld	ra,40(sp)
    80002604:	7402                	ld	s0,32(sp)
    80002606:	64e2                	ld	s1,24(sp)
    80002608:	6942                	ld	s2,16(sp)
    8000260a:	69a2                	ld	s3,8(sp)
    8000260c:	6145                	addi	sp,sp,48
    8000260e:	8082                	ret

0000000080002610 <ialloc>:
{
    80002610:	7139                	addi	sp,sp,-64
    80002612:	fc06                	sd	ra,56(sp)
    80002614:	f822                	sd	s0,48(sp)
    80002616:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002618:	00014717          	auipc	a4,0x14
    8000261c:	fac72703          	lw	a4,-84(a4) # 800165c4 <sb+0xc>
    80002620:	4785                	li	a5,1
    80002622:	06e7f063          	bgeu	a5,a4,80002682 <ialloc+0x72>
    80002626:	f426                	sd	s1,40(sp)
    80002628:	f04a                	sd	s2,32(sp)
    8000262a:	ec4e                	sd	s3,24(sp)
    8000262c:	e852                	sd	s4,16(sp)
    8000262e:	e456                	sd	s5,8(sp)
    80002630:	e05a                	sd	s6,0(sp)
    80002632:	8aaa                	mv	s5,a0
    80002634:	8b2e                	mv	s6,a1
    80002636:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002638:	00014a17          	auipc	s4,0x14
    8000263c:	f80a0a13          	addi	s4,s4,-128 # 800165b8 <sb>
    80002640:	00495593          	srli	a1,s2,0x4
    80002644:	018a2783          	lw	a5,24(s4)
    80002648:	9dbd                	addw	a1,a1,a5
    8000264a:	8556                	mv	a0,s5
    8000264c:	a9dff0ef          	jal	800020e8 <bread>
    80002650:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002652:	05850993          	addi	s3,a0,88
    80002656:	00f97793          	andi	a5,s2,15
    8000265a:	079a                	slli	a5,a5,0x6
    8000265c:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    8000265e:	00099783          	lh	a5,0(s3)
    80002662:	cb9d                	beqz	a5,80002698 <ialloc+0x88>
    brelse(bp);
    80002664:	b8dff0ef          	jal	800021f0 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002668:	0905                	addi	s2,s2,1
    8000266a:	00ca2703          	lw	a4,12(s4)
    8000266e:	0009079b          	sext.w	a5,s2
    80002672:	fce7e7e3          	bltu	a5,a4,80002640 <ialloc+0x30>
    80002676:	74a2                	ld	s1,40(sp)
    80002678:	7902                	ld	s2,32(sp)
    8000267a:	69e2                	ld	s3,24(sp)
    8000267c:	6a42                	ld	s4,16(sp)
    8000267e:	6aa2                	ld	s5,8(sp)
    80002680:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002682:	00005517          	auipc	a0,0x5
    80002686:	d4e50513          	addi	a0,a0,-690 # 800073d0 <etext+0x3d0>
    8000268a:	5b3020ef          	jal	8000543c <printf>
  return 0;
    8000268e:	4501                	li	a0,0
}
    80002690:	70e2                	ld	ra,56(sp)
    80002692:	7442                	ld	s0,48(sp)
    80002694:	6121                	addi	sp,sp,64
    80002696:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002698:	04000613          	li	a2,64
    8000269c:	4581                	li	a1,0
    8000269e:	854e                	mv	a0,s3
    800026a0:	abffd0ef          	jal	8000015e <memset>
      dip->type = type;
    800026a4:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    800026a8:	8526                	mv	a0,s1
    800026aa:	47d000ef          	jal	80003326 <log_write>
      brelse(bp);
    800026ae:	8526                	mv	a0,s1
    800026b0:	b41ff0ef          	jal	800021f0 <brelse>
      return iget(dev, inum);
    800026b4:	0009059b          	sext.w	a1,s2
    800026b8:	8556                	mv	a0,s5
    800026ba:	e55ff0ef          	jal	8000250e <iget>
    800026be:	74a2                	ld	s1,40(sp)
    800026c0:	7902                	ld	s2,32(sp)
    800026c2:	69e2                	ld	s3,24(sp)
    800026c4:	6a42                	ld	s4,16(sp)
    800026c6:	6aa2                	ld	s5,8(sp)
    800026c8:	6b02                	ld	s6,0(sp)
    800026ca:	b7d9                	j	80002690 <ialloc+0x80>

00000000800026cc <iupdate>:
{
    800026cc:	1101                	addi	sp,sp,-32
    800026ce:	ec06                	sd	ra,24(sp)
    800026d0:	e822                	sd	s0,16(sp)
    800026d2:	e426                	sd	s1,8(sp)
    800026d4:	e04a                	sd	s2,0(sp)
    800026d6:	1000                	addi	s0,sp,32
    800026d8:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026da:	415c                	lw	a5,4(a0)
    800026dc:	0047d79b          	srliw	a5,a5,0x4
    800026e0:	00014597          	auipc	a1,0x14
    800026e4:	ef05a583          	lw	a1,-272(a1) # 800165d0 <sb+0x18>
    800026e8:	9dbd                	addw	a1,a1,a5
    800026ea:	4108                	lw	a0,0(a0)
    800026ec:	9fdff0ef          	jal	800020e8 <bread>
    800026f0:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026f2:	05850793          	addi	a5,a0,88
    800026f6:	40d8                	lw	a4,4(s1)
    800026f8:	8b3d                	andi	a4,a4,15
    800026fa:	071a                	slli	a4,a4,0x6
    800026fc:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026fe:	04449703          	lh	a4,68(s1)
    80002702:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002706:	04649703          	lh	a4,70(s1)
    8000270a:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000270e:	04849703          	lh	a4,72(s1)
    80002712:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002716:	04a49703          	lh	a4,74(s1)
    8000271a:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    8000271e:	44f8                	lw	a4,76(s1)
    80002720:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002722:	03400613          	li	a2,52
    80002726:	05048593          	addi	a1,s1,80
    8000272a:	00c78513          	addi	a0,a5,12
    8000272e:	a91fd0ef          	jal	800001be <memmove>
  log_write(bp);
    80002732:	854a                	mv	a0,s2
    80002734:	3f3000ef          	jal	80003326 <log_write>
  brelse(bp);
    80002738:	854a                	mv	a0,s2
    8000273a:	ab7ff0ef          	jal	800021f0 <brelse>
}
    8000273e:	60e2                	ld	ra,24(sp)
    80002740:	6442                	ld	s0,16(sp)
    80002742:	64a2                	ld	s1,8(sp)
    80002744:	6902                	ld	s2,0(sp)
    80002746:	6105                	addi	sp,sp,32
    80002748:	8082                	ret

000000008000274a <idup>:
{
    8000274a:	1101                	addi	sp,sp,-32
    8000274c:	ec06                	sd	ra,24(sp)
    8000274e:	e822                	sd	s0,16(sp)
    80002750:	e426                	sd	s1,8(sp)
    80002752:	1000                	addi	s0,sp,32
    80002754:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002756:	00014517          	auipc	a0,0x14
    8000275a:	e8250513          	addi	a0,a0,-382 # 800165d8 <itable>
    8000275e:	32c030ef          	jal	80005a8a <acquire>
  ip->ref++;
    80002762:	449c                	lw	a5,8(s1)
    80002764:	2785                	addiw	a5,a5,1
    80002766:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002768:	00014517          	auipc	a0,0x14
    8000276c:	e7050513          	addi	a0,a0,-400 # 800165d8 <itable>
    80002770:	3ae030ef          	jal	80005b1e <release>
}
    80002774:	8526                	mv	a0,s1
    80002776:	60e2                	ld	ra,24(sp)
    80002778:	6442                	ld	s0,16(sp)
    8000277a:	64a2                	ld	s1,8(sp)
    8000277c:	6105                	addi	sp,sp,32
    8000277e:	8082                	ret

0000000080002780 <ilock>:
{
    80002780:	1101                	addi	sp,sp,-32
    80002782:	ec06                	sd	ra,24(sp)
    80002784:	e822                	sd	s0,16(sp)
    80002786:	e426                	sd	s1,8(sp)
    80002788:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    8000278a:	cd19                	beqz	a0,800027a8 <ilock+0x28>
    8000278c:	84aa                	mv	s1,a0
    8000278e:	451c                	lw	a5,8(a0)
    80002790:	00f05c63          	blez	a5,800027a8 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002794:	0541                	addi	a0,a0,16
    80002796:	48b000ef          	jal	80003420 <acquiresleep>
  if(ip->valid == 0){
    8000279a:	40bc                	lw	a5,64(s1)
    8000279c:	cf89                	beqz	a5,800027b6 <ilock+0x36>
}
    8000279e:	60e2                	ld	ra,24(sp)
    800027a0:	6442                	ld	s0,16(sp)
    800027a2:	64a2                	ld	s1,8(sp)
    800027a4:	6105                	addi	sp,sp,32
    800027a6:	8082                	ret
    800027a8:	e04a                	sd	s2,0(sp)
    panic("ilock");
    800027aa:	00005517          	auipc	a0,0x5
    800027ae:	c3e50513          	addi	a0,a0,-962 # 800073e8 <etext+0x3e8>
    800027b2:	036030ef          	jal	800057e8 <panic>
    800027b6:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800027b8:	40dc                	lw	a5,4(s1)
    800027ba:	0047d79b          	srliw	a5,a5,0x4
    800027be:	00014597          	auipc	a1,0x14
    800027c2:	e125a583          	lw	a1,-494(a1) # 800165d0 <sb+0x18>
    800027c6:	9dbd                	addw	a1,a1,a5
    800027c8:	4088                	lw	a0,0(s1)
    800027ca:	91fff0ef          	jal	800020e8 <bread>
    800027ce:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027d0:	05850593          	addi	a1,a0,88
    800027d4:	40dc                	lw	a5,4(s1)
    800027d6:	8bbd                	andi	a5,a5,15
    800027d8:	079a                	slli	a5,a5,0x6
    800027da:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027dc:	00059783          	lh	a5,0(a1)
    800027e0:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027e4:	00259783          	lh	a5,2(a1)
    800027e8:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027ec:	00459783          	lh	a5,4(a1)
    800027f0:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027f4:	00659783          	lh	a5,6(a1)
    800027f8:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027fc:	459c                	lw	a5,8(a1)
    800027fe:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002800:	03400613          	li	a2,52
    80002804:	05b1                	addi	a1,a1,12
    80002806:	05048513          	addi	a0,s1,80
    8000280a:	9b5fd0ef          	jal	800001be <memmove>
    brelse(bp);
    8000280e:	854a                	mv	a0,s2
    80002810:	9e1ff0ef          	jal	800021f0 <brelse>
    ip->valid = 1;
    80002814:	4785                	li	a5,1
    80002816:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002818:	04449783          	lh	a5,68(s1)
    8000281c:	c399                	beqz	a5,80002822 <ilock+0xa2>
    8000281e:	6902                	ld	s2,0(sp)
    80002820:	bfbd                	j	8000279e <ilock+0x1e>
      panic("ilock: no type");
    80002822:	00005517          	auipc	a0,0x5
    80002826:	bce50513          	addi	a0,a0,-1074 # 800073f0 <etext+0x3f0>
    8000282a:	7bf020ef          	jal	800057e8 <panic>

000000008000282e <iunlock>:
{
    8000282e:	1101                	addi	sp,sp,-32
    80002830:	ec06                	sd	ra,24(sp)
    80002832:	e822                	sd	s0,16(sp)
    80002834:	e426                	sd	s1,8(sp)
    80002836:	e04a                	sd	s2,0(sp)
    80002838:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    8000283a:	c505                	beqz	a0,80002862 <iunlock+0x34>
    8000283c:	84aa                	mv	s1,a0
    8000283e:	01050913          	addi	s2,a0,16
    80002842:	854a                	mv	a0,s2
    80002844:	45b000ef          	jal	8000349e <holdingsleep>
    80002848:	cd09                	beqz	a0,80002862 <iunlock+0x34>
    8000284a:	449c                	lw	a5,8(s1)
    8000284c:	00f05b63          	blez	a5,80002862 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002850:	854a                	mv	a0,s2
    80002852:	415000ef          	jal	80003466 <releasesleep>
}
    80002856:	60e2                	ld	ra,24(sp)
    80002858:	6442                	ld	s0,16(sp)
    8000285a:	64a2                	ld	s1,8(sp)
    8000285c:	6902                	ld	s2,0(sp)
    8000285e:	6105                	addi	sp,sp,32
    80002860:	8082                	ret
    panic("iunlock");
    80002862:	00005517          	auipc	a0,0x5
    80002866:	b9e50513          	addi	a0,a0,-1122 # 80007400 <etext+0x400>
    8000286a:	77f020ef          	jal	800057e8 <panic>

000000008000286e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    8000286e:	7179                	addi	sp,sp,-48
    80002870:	f406                	sd	ra,40(sp)
    80002872:	f022                	sd	s0,32(sp)
    80002874:	ec26                	sd	s1,24(sp)
    80002876:	e84a                	sd	s2,16(sp)
    80002878:	e44e                	sd	s3,8(sp)
    8000287a:	1800                	addi	s0,sp,48
    8000287c:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    8000287e:	05050493          	addi	s1,a0,80
    80002882:	08050913          	addi	s2,a0,128
    80002886:	a021                	j	8000288e <itrunc+0x20>
    80002888:	0491                	addi	s1,s1,4
    8000288a:	01248b63          	beq	s1,s2,800028a0 <itrunc+0x32>
    if(ip->addrs[i]){
    8000288e:	408c                	lw	a1,0(s1)
    80002890:	dde5                	beqz	a1,80002888 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002892:	0009a503          	lw	a0,0(s3)
    80002896:	a47ff0ef          	jal	800022dc <bfree>
      ip->addrs[i] = 0;
    8000289a:	0004a023          	sw	zero,0(s1)
    8000289e:	b7ed                	j	80002888 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    800028a0:	0809a583          	lw	a1,128(s3)
    800028a4:	ed89                	bnez	a1,800028be <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    800028a6:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    800028aa:	854e                	mv	a0,s3
    800028ac:	e21ff0ef          	jal	800026cc <iupdate>
}
    800028b0:	70a2                	ld	ra,40(sp)
    800028b2:	7402                	ld	s0,32(sp)
    800028b4:	64e2                	ld	s1,24(sp)
    800028b6:	6942                	ld	s2,16(sp)
    800028b8:	69a2                	ld	s3,8(sp)
    800028ba:	6145                	addi	sp,sp,48
    800028bc:	8082                	ret
    800028be:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    800028c0:	0009a503          	lw	a0,0(s3)
    800028c4:	825ff0ef          	jal	800020e8 <bread>
    800028c8:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028ca:	05850493          	addi	s1,a0,88
    800028ce:	45850913          	addi	s2,a0,1112
    800028d2:	a021                	j	800028da <itrunc+0x6c>
    800028d4:	0491                	addi	s1,s1,4
    800028d6:	01248963          	beq	s1,s2,800028e8 <itrunc+0x7a>
      if(a[j])
    800028da:	408c                	lw	a1,0(s1)
    800028dc:	dde5                	beqz	a1,800028d4 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028de:	0009a503          	lw	a0,0(s3)
    800028e2:	9fbff0ef          	jal	800022dc <bfree>
    800028e6:	b7fd                	j	800028d4 <itrunc+0x66>
    brelse(bp);
    800028e8:	8552                	mv	a0,s4
    800028ea:	907ff0ef          	jal	800021f0 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028ee:	0809a583          	lw	a1,128(s3)
    800028f2:	0009a503          	lw	a0,0(s3)
    800028f6:	9e7ff0ef          	jal	800022dc <bfree>
    ip->addrs[NDIRECT] = 0;
    800028fa:	0809a023          	sw	zero,128(s3)
    800028fe:	6a02                	ld	s4,0(sp)
    80002900:	b75d                	j	800028a6 <itrunc+0x38>

0000000080002902 <iput>:
{
    80002902:	1101                	addi	sp,sp,-32
    80002904:	ec06                	sd	ra,24(sp)
    80002906:	e822                	sd	s0,16(sp)
    80002908:	e426                	sd	s1,8(sp)
    8000290a:	1000                	addi	s0,sp,32
    8000290c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000290e:	00014517          	auipc	a0,0x14
    80002912:	cca50513          	addi	a0,a0,-822 # 800165d8 <itable>
    80002916:	174030ef          	jal	80005a8a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000291a:	4498                	lw	a4,8(s1)
    8000291c:	4785                	li	a5,1
    8000291e:	02f70063          	beq	a4,a5,8000293e <iput+0x3c>
  ip->ref--;
    80002922:	449c                	lw	a5,8(s1)
    80002924:	37fd                	addiw	a5,a5,-1
    80002926:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002928:	00014517          	auipc	a0,0x14
    8000292c:	cb050513          	addi	a0,a0,-848 # 800165d8 <itable>
    80002930:	1ee030ef          	jal	80005b1e <release>
}
    80002934:	60e2                	ld	ra,24(sp)
    80002936:	6442                	ld	s0,16(sp)
    80002938:	64a2                	ld	s1,8(sp)
    8000293a:	6105                	addi	sp,sp,32
    8000293c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000293e:	40bc                	lw	a5,64(s1)
    80002940:	d3ed                	beqz	a5,80002922 <iput+0x20>
    80002942:	04a49783          	lh	a5,74(s1)
    80002946:	fff1                	bnez	a5,80002922 <iput+0x20>
    80002948:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    8000294a:	01048793          	addi	a5,s1,16
    8000294e:	893e                	mv	s2,a5
    80002950:	853e                	mv	a0,a5
    80002952:	2cf000ef          	jal	80003420 <acquiresleep>
    release(&itable.lock);
    80002956:	00014517          	auipc	a0,0x14
    8000295a:	c8250513          	addi	a0,a0,-894 # 800165d8 <itable>
    8000295e:	1c0030ef          	jal	80005b1e <release>
    itrunc(ip);
    80002962:	8526                	mv	a0,s1
    80002964:	f0bff0ef          	jal	8000286e <itrunc>
    ip->type = 0;
    80002968:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    8000296c:	8526                	mv	a0,s1
    8000296e:	d5fff0ef          	jal	800026cc <iupdate>
    ip->valid = 0;
    80002972:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002976:	854a                	mv	a0,s2
    80002978:	2ef000ef          	jal	80003466 <releasesleep>
    acquire(&itable.lock);
    8000297c:	00014517          	auipc	a0,0x14
    80002980:	c5c50513          	addi	a0,a0,-932 # 800165d8 <itable>
    80002984:	106030ef          	jal	80005a8a <acquire>
    80002988:	6902                	ld	s2,0(sp)
    8000298a:	bf61                	j	80002922 <iput+0x20>

000000008000298c <iunlockput>:
{
    8000298c:	1101                	addi	sp,sp,-32
    8000298e:	ec06                	sd	ra,24(sp)
    80002990:	e822                	sd	s0,16(sp)
    80002992:	e426                	sd	s1,8(sp)
    80002994:	1000                	addi	s0,sp,32
    80002996:	84aa                	mv	s1,a0
  iunlock(ip);
    80002998:	e97ff0ef          	jal	8000282e <iunlock>
  iput(ip);
    8000299c:	8526                	mv	a0,s1
    8000299e:	f65ff0ef          	jal	80002902 <iput>
}
    800029a2:	60e2                	ld	ra,24(sp)
    800029a4:	6442                	ld	s0,16(sp)
    800029a6:	64a2                	ld	s1,8(sp)
    800029a8:	6105                	addi	sp,sp,32
    800029aa:	8082                	ret

00000000800029ac <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029ac:	00014717          	auipc	a4,0x14
    800029b0:	c1872703          	lw	a4,-1000(a4) # 800165c4 <sb+0xc>
    800029b4:	4785                	li	a5,1
    800029b6:	0ae7fe63          	bgeu	a5,a4,80002a72 <ireclaim+0xc6>
{
    800029ba:	7139                	addi	sp,sp,-64
    800029bc:	fc06                	sd	ra,56(sp)
    800029be:	f822                	sd	s0,48(sp)
    800029c0:	f426                	sd	s1,40(sp)
    800029c2:	f04a                	sd	s2,32(sp)
    800029c4:	ec4e                	sd	s3,24(sp)
    800029c6:	e852                	sd	s4,16(sp)
    800029c8:	e456                	sd	s5,8(sp)
    800029ca:	e05a                	sd	s6,0(sp)
    800029cc:	0080                	addi	s0,sp,64
    800029ce:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029d0:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800029d2:	00014a17          	auipc	s4,0x14
    800029d6:	be6a0a13          	addi	s4,s4,-1050 # 800165b8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800029da:	00005b17          	auipc	s6,0x5
    800029de:	a2eb0b13          	addi	s6,s6,-1490 # 80007408 <etext+0x408>
    800029e2:	a099                	j	80002a28 <ireclaim+0x7c>
    800029e4:	85ce                	mv	a1,s3
    800029e6:	855a                	mv	a0,s6
    800029e8:	255020ef          	jal	8000543c <printf>
      ip = iget(dev, inum);
    800029ec:	85ce                	mv	a1,s3
    800029ee:	8556                	mv	a0,s5
    800029f0:	b1fff0ef          	jal	8000250e <iget>
    800029f4:	89aa                	mv	s3,a0
    brelse(bp);
    800029f6:	854a                	mv	a0,s2
    800029f8:	ff8ff0ef          	jal	800021f0 <brelse>
    if (ip) {
    800029fc:	00098f63          	beqz	s3,80002a1a <ireclaim+0x6e>
      begin_op();
    80002a00:	78c000ef          	jal	8000318c <begin_op>
      ilock(ip);
    80002a04:	854e                	mv	a0,s3
    80002a06:	d7bff0ef          	jal	80002780 <ilock>
      iunlock(ip);
    80002a0a:	854e                	mv	a0,s3
    80002a0c:	e23ff0ef          	jal	8000282e <iunlock>
      iput(ip);
    80002a10:	854e                	mv	a0,s3
    80002a12:	ef1ff0ef          	jal	80002902 <iput>
      end_op();
    80002a16:	7e6000ef          	jal	800031fc <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002a1a:	0485                	addi	s1,s1,1
    80002a1c:	00ca2703          	lw	a4,12(s4)
    80002a20:	0004879b          	sext.w	a5,s1
    80002a24:	02e7fd63          	bgeu	a5,a4,80002a5e <ireclaim+0xb2>
    80002a28:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002a2c:	0044d593          	srli	a1,s1,0x4
    80002a30:	018a2783          	lw	a5,24(s4)
    80002a34:	9dbd                	addw	a1,a1,a5
    80002a36:	8556                	mv	a0,s5
    80002a38:	eb0ff0ef          	jal	800020e8 <bread>
    80002a3c:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002a3e:	05850793          	addi	a5,a0,88
    80002a42:	00f9f713          	andi	a4,s3,15
    80002a46:	071a                	slli	a4,a4,0x6
    80002a48:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002a4a:	00079703          	lh	a4,0(a5)
    80002a4e:	c701                	beqz	a4,80002a56 <ireclaim+0xaa>
    80002a50:	00679783          	lh	a5,6(a5)
    80002a54:	dbc1                	beqz	a5,800029e4 <ireclaim+0x38>
    brelse(bp);
    80002a56:	854a                	mv	a0,s2
    80002a58:	f98ff0ef          	jal	800021f0 <brelse>
    if (ip) {
    80002a5c:	bf7d                	j	80002a1a <ireclaim+0x6e>
}
    80002a5e:	70e2                	ld	ra,56(sp)
    80002a60:	7442                	ld	s0,48(sp)
    80002a62:	74a2                	ld	s1,40(sp)
    80002a64:	7902                	ld	s2,32(sp)
    80002a66:	69e2                	ld	s3,24(sp)
    80002a68:	6a42                	ld	s4,16(sp)
    80002a6a:	6aa2                	ld	s5,8(sp)
    80002a6c:	6b02                	ld	s6,0(sp)
    80002a6e:	6121                	addi	sp,sp,64
    80002a70:	8082                	ret
    80002a72:	8082                	ret

0000000080002a74 <fsinit>:
fsinit(int dev) {
    80002a74:	1101                	addi	sp,sp,-32
    80002a76:	ec06                	sd	ra,24(sp)
    80002a78:	e822                	sd	s0,16(sp)
    80002a7a:	e426                	sd	s1,8(sp)
    80002a7c:	e04a                	sd	s2,0(sp)
    80002a7e:	1000                	addi	s0,sp,32
    80002a80:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a82:	4585                	li	a1,1
    80002a84:	e64ff0ef          	jal	800020e8 <bread>
    80002a88:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a8a:	02000613          	li	a2,32
    80002a8e:	05850593          	addi	a1,a0,88
    80002a92:	00014517          	auipc	a0,0x14
    80002a96:	b2650513          	addi	a0,a0,-1242 # 800165b8 <sb>
    80002a9a:	f24fd0ef          	jal	800001be <memmove>
  brelse(bp);
    80002a9e:	8526                	mv	a0,s1
    80002aa0:	f50ff0ef          	jal	800021f0 <brelse>
  if(sb.magic != FSMAGIC)
    80002aa4:	00014717          	auipc	a4,0x14
    80002aa8:	b1472703          	lw	a4,-1260(a4) # 800165b8 <sb>
    80002aac:	102037b7          	lui	a5,0x10203
    80002ab0:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ab4:	02f71263          	bne	a4,a5,80002ad8 <fsinit+0x64>
  initlog(dev, &sb);
    80002ab8:	00014597          	auipc	a1,0x14
    80002abc:	b0058593          	addi	a1,a1,-1280 # 800165b8 <sb>
    80002ac0:	854a                	mv	a0,s2
    80002ac2:	648000ef          	jal	8000310a <initlog>
  ireclaim(dev);
    80002ac6:	854a                	mv	a0,s2
    80002ac8:	ee5ff0ef          	jal	800029ac <ireclaim>
}
    80002acc:	60e2                	ld	ra,24(sp)
    80002ace:	6442                	ld	s0,16(sp)
    80002ad0:	64a2                	ld	s1,8(sp)
    80002ad2:	6902                	ld	s2,0(sp)
    80002ad4:	6105                	addi	sp,sp,32
    80002ad6:	8082                	ret
    panic("invalid file system");
    80002ad8:	00005517          	auipc	a0,0x5
    80002adc:	95050513          	addi	a0,a0,-1712 # 80007428 <etext+0x428>
    80002ae0:	509020ef          	jal	800057e8 <panic>

0000000080002ae4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002ae4:	1141                	addi	sp,sp,-16
    80002ae6:	e406                	sd	ra,8(sp)
    80002ae8:	e022                	sd	s0,0(sp)
    80002aea:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002aec:	411c                	lw	a5,0(a0)
    80002aee:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002af0:	415c                	lw	a5,4(a0)
    80002af2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002af4:	04451783          	lh	a5,68(a0)
    80002af8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002afc:	04a51783          	lh	a5,74(a0)
    80002b00:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002b04:	04c56783          	lwu	a5,76(a0)
    80002b08:	e99c                	sd	a5,16(a1)
}
    80002b0a:	60a2                	ld	ra,8(sp)
    80002b0c:	6402                	ld	s0,0(sp)
    80002b0e:	0141                	addi	sp,sp,16
    80002b10:	8082                	ret

0000000080002b12 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b12:	457c                	lw	a5,76(a0)
    80002b14:	0ed7e663          	bltu	a5,a3,80002c00 <readi+0xee>
{
    80002b18:	7159                	addi	sp,sp,-112
    80002b1a:	f486                	sd	ra,104(sp)
    80002b1c:	f0a2                	sd	s0,96(sp)
    80002b1e:	eca6                	sd	s1,88(sp)
    80002b20:	e0d2                	sd	s4,64(sp)
    80002b22:	fc56                	sd	s5,56(sp)
    80002b24:	f85a                	sd	s6,48(sp)
    80002b26:	f45e                	sd	s7,40(sp)
    80002b28:	1880                	addi	s0,sp,112
    80002b2a:	8b2a                	mv	s6,a0
    80002b2c:	8bae                	mv	s7,a1
    80002b2e:	8a32                	mv	s4,a2
    80002b30:	84b6                	mv	s1,a3
    80002b32:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002b34:	9f35                	addw	a4,a4,a3
    return 0;
    80002b36:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002b38:	0ad76b63          	bltu	a4,a3,80002bee <readi+0xdc>
    80002b3c:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002b3e:	00e7f463          	bgeu	a5,a4,80002b46 <readi+0x34>
    n = ip->size - off;
    80002b42:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b46:	080a8b63          	beqz	s5,80002bdc <readi+0xca>
    80002b4a:	e8ca                	sd	s2,80(sp)
    80002b4c:	f062                	sd	s8,32(sp)
    80002b4e:	ec66                	sd	s9,24(sp)
    80002b50:	e86a                	sd	s10,16(sp)
    80002b52:	e46e                	sd	s11,8(sp)
    80002b54:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b56:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002b5a:	5c7d                	li	s8,-1
    80002b5c:	a80d                	j	80002b8e <readi+0x7c>
    80002b5e:	020d1d93          	slli	s11,s10,0x20
    80002b62:	020ddd93          	srli	s11,s11,0x20
    80002b66:	05890613          	addi	a2,s2,88
    80002b6a:	86ee                	mv	a3,s11
    80002b6c:	963e                	add	a2,a2,a5
    80002b6e:	85d2                	mv	a1,s4
    80002b70:	855e                	mv	a0,s7
    80002b72:	be5fe0ef          	jal	80001756 <either_copyout>
    80002b76:	05850363          	beq	a0,s8,80002bbc <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002b7a:	854a                	mv	a0,s2
    80002b7c:	e74ff0ef          	jal	800021f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b80:	013d09bb          	addw	s3,s10,s3
    80002b84:	009d04bb          	addw	s1,s10,s1
    80002b88:	9a6e                	add	s4,s4,s11
    80002b8a:	0559f363          	bgeu	s3,s5,80002bd0 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b8e:	00a4d59b          	srliw	a1,s1,0xa
    80002b92:	855a                	mv	a0,s6
    80002b94:	8bbff0ef          	jal	8000244e <bmap>
    80002b98:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b9a:	c139                	beqz	a0,80002be0 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002b9c:	000b2503          	lw	a0,0(s6)
    80002ba0:	d48ff0ef          	jal	800020e8 <bread>
    80002ba4:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ba6:	3ff4f793          	andi	a5,s1,1023
    80002baa:	40fc873b          	subw	a4,s9,a5
    80002bae:	413a86bb          	subw	a3,s5,s3
    80002bb2:	8d3a                	mv	s10,a4
    80002bb4:	fae6f5e3          	bgeu	a3,a4,80002b5e <readi+0x4c>
    80002bb8:	8d36                	mv	s10,a3
    80002bba:	b755                	j	80002b5e <readi+0x4c>
      brelse(bp);
    80002bbc:	854a                	mv	a0,s2
    80002bbe:	e32ff0ef          	jal	800021f0 <brelse>
      tot = -1;
    80002bc2:	59fd                	li	s3,-1
      break;
    80002bc4:	6946                	ld	s2,80(sp)
    80002bc6:	7c02                	ld	s8,32(sp)
    80002bc8:	6ce2                	ld	s9,24(sp)
    80002bca:	6d42                	ld	s10,16(sp)
    80002bcc:	6da2                	ld	s11,8(sp)
    80002bce:	a831                	j	80002bea <readi+0xd8>
    80002bd0:	6946                	ld	s2,80(sp)
    80002bd2:	7c02                	ld	s8,32(sp)
    80002bd4:	6ce2                	ld	s9,24(sp)
    80002bd6:	6d42                	ld	s10,16(sp)
    80002bd8:	6da2                	ld	s11,8(sp)
    80002bda:	a801                	j	80002bea <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002bdc:	89d6                	mv	s3,s5
    80002bde:	a031                	j	80002bea <readi+0xd8>
    80002be0:	6946                	ld	s2,80(sp)
    80002be2:	7c02                	ld	s8,32(sp)
    80002be4:	6ce2                	ld	s9,24(sp)
    80002be6:	6d42                	ld	s10,16(sp)
    80002be8:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002bea:	854e                	mv	a0,s3
    80002bec:	69a6                	ld	s3,72(sp)
}
    80002bee:	70a6                	ld	ra,104(sp)
    80002bf0:	7406                	ld	s0,96(sp)
    80002bf2:	64e6                	ld	s1,88(sp)
    80002bf4:	6a06                	ld	s4,64(sp)
    80002bf6:	7ae2                	ld	s5,56(sp)
    80002bf8:	7b42                	ld	s6,48(sp)
    80002bfa:	7ba2                	ld	s7,40(sp)
    80002bfc:	6165                	addi	sp,sp,112
    80002bfe:	8082                	ret
    return 0;
    80002c00:	4501                	li	a0,0
}
    80002c02:	8082                	ret

0000000080002c04 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c04:	457c                	lw	a5,76(a0)
    80002c06:	0ed7eb63          	bltu	a5,a3,80002cfc <writei+0xf8>
{
    80002c0a:	7159                	addi	sp,sp,-112
    80002c0c:	f486                	sd	ra,104(sp)
    80002c0e:	f0a2                	sd	s0,96(sp)
    80002c10:	e8ca                	sd	s2,80(sp)
    80002c12:	e0d2                	sd	s4,64(sp)
    80002c14:	fc56                	sd	s5,56(sp)
    80002c16:	f85a                	sd	s6,48(sp)
    80002c18:	f45e                	sd	s7,40(sp)
    80002c1a:	1880                	addi	s0,sp,112
    80002c1c:	8aaa                	mv	s5,a0
    80002c1e:	8bae                	mv	s7,a1
    80002c20:	8a32                	mv	s4,a2
    80002c22:	8936                	mv	s2,a3
    80002c24:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002c26:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002c2a:	00043737          	lui	a4,0x43
    80002c2e:	0cf76963          	bltu	a4,a5,80002d00 <writei+0xfc>
    80002c32:	0cd7e763          	bltu	a5,a3,80002d00 <writei+0xfc>
    80002c36:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c38:	0a0b0a63          	beqz	s6,80002cec <writei+0xe8>
    80002c3c:	eca6                	sd	s1,88(sp)
    80002c3e:	f062                	sd	s8,32(sp)
    80002c40:	ec66                	sd	s9,24(sp)
    80002c42:	e86a                	sd	s10,16(sp)
    80002c44:	e46e                	sd	s11,8(sp)
    80002c46:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c48:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002c4c:	5c7d                	li	s8,-1
    80002c4e:	a825                	j	80002c86 <writei+0x82>
    80002c50:	020d1d93          	slli	s11,s10,0x20
    80002c54:	020ddd93          	srli	s11,s11,0x20
    80002c58:	05848513          	addi	a0,s1,88
    80002c5c:	86ee                	mv	a3,s11
    80002c5e:	8652                	mv	a2,s4
    80002c60:	85de                	mv	a1,s7
    80002c62:	953e                	add	a0,a0,a5
    80002c64:	b3dfe0ef          	jal	800017a0 <either_copyin>
    80002c68:	05850663          	beq	a0,s8,80002cb4 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002c6c:	8526                	mv	a0,s1
    80002c6e:	6b8000ef          	jal	80003326 <log_write>
    brelse(bp);
    80002c72:	8526                	mv	a0,s1
    80002c74:	d7cff0ef          	jal	800021f0 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c78:	013d09bb          	addw	s3,s10,s3
    80002c7c:	012d093b          	addw	s2,s10,s2
    80002c80:	9a6e                	add	s4,s4,s11
    80002c82:	0369fc63          	bgeu	s3,s6,80002cba <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002c86:	00a9559b          	srliw	a1,s2,0xa
    80002c8a:	8556                	mv	a0,s5
    80002c8c:	fc2ff0ef          	jal	8000244e <bmap>
    80002c90:	85aa                	mv	a1,a0
    if(addr == 0)
    80002c92:	c505                	beqz	a0,80002cba <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002c94:	000aa503          	lw	a0,0(s5)
    80002c98:	c50ff0ef          	jal	800020e8 <bread>
    80002c9c:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c9e:	3ff97793          	andi	a5,s2,1023
    80002ca2:	40fc873b          	subw	a4,s9,a5
    80002ca6:	413b06bb          	subw	a3,s6,s3
    80002caa:	8d3a                	mv	s10,a4
    80002cac:	fae6f2e3          	bgeu	a3,a4,80002c50 <writei+0x4c>
    80002cb0:	8d36                	mv	s10,a3
    80002cb2:	bf79                	j	80002c50 <writei+0x4c>
      brelse(bp);
    80002cb4:	8526                	mv	a0,s1
    80002cb6:	d3aff0ef          	jal	800021f0 <brelse>
  }

  if(off > ip->size)
    80002cba:	04caa783          	lw	a5,76(s5)
    80002cbe:	0327f963          	bgeu	a5,s2,80002cf0 <writei+0xec>
    ip->size = off;
    80002cc2:	052aa623          	sw	s2,76(s5)
    80002cc6:	64e6                	ld	s1,88(sp)
    80002cc8:	7c02                	ld	s8,32(sp)
    80002cca:	6ce2                	ld	s9,24(sp)
    80002ccc:	6d42                	ld	s10,16(sp)
    80002cce:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002cd0:	8556                	mv	a0,s5
    80002cd2:	9fbff0ef          	jal	800026cc <iupdate>

  return tot;
    80002cd6:	854e                	mv	a0,s3
    80002cd8:	69a6                	ld	s3,72(sp)
}
    80002cda:	70a6                	ld	ra,104(sp)
    80002cdc:	7406                	ld	s0,96(sp)
    80002cde:	6946                	ld	s2,80(sp)
    80002ce0:	6a06                	ld	s4,64(sp)
    80002ce2:	7ae2                	ld	s5,56(sp)
    80002ce4:	7b42                	ld	s6,48(sp)
    80002ce6:	7ba2                	ld	s7,40(sp)
    80002ce8:	6165                	addi	sp,sp,112
    80002cea:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002cec:	89da                	mv	s3,s6
    80002cee:	b7cd                	j	80002cd0 <writei+0xcc>
    80002cf0:	64e6                	ld	s1,88(sp)
    80002cf2:	7c02                	ld	s8,32(sp)
    80002cf4:	6ce2                	ld	s9,24(sp)
    80002cf6:	6d42                	ld	s10,16(sp)
    80002cf8:	6da2                	ld	s11,8(sp)
    80002cfa:	bfd9                	j	80002cd0 <writei+0xcc>
    return -1;
    80002cfc:	557d                	li	a0,-1
}
    80002cfe:	8082                	ret
    return -1;
    80002d00:	557d                	li	a0,-1
    80002d02:	bfe1                	j	80002cda <writei+0xd6>

0000000080002d04 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002d04:	1141                	addi	sp,sp,-16
    80002d06:	e406                	sd	ra,8(sp)
    80002d08:	e022                	sd	s0,0(sp)
    80002d0a:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002d0c:	4639                	li	a2,14
    80002d0e:	d24fd0ef          	jal	80000232 <strncmp>
}
    80002d12:	60a2                	ld	ra,8(sp)
    80002d14:	6402                	ld	s0,0(sp)
    80002d16:	0141                	addi	sp,sp,16
    80002d18:	8082                	ret

0000000080002d1a <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002d1a:	711d                	addi	sp,sp,-96
    80002d1c:	ec86                	sd	ra,88(sp)
    80002d1e:	e8a2                	sd	s0,80(sp)
    80002d20:	e4a6                	sd	s1,72(sp)
    80002d22:	e0ca                	sd	s2,64(sp)
    80002d24:	fc4e                	sd	s3,56(sp)
    80002d26:	f852                	sd	s4,48(sp)
    80002d28:	f456                	sd	s5,40(sp)
    80002d2a:	f05a                	sd	s6,32(sp)
    80002d2c:	ec5e                	sd	s7,24(sp)
    80002d2e:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002d30:	04451703          	lh	a4,68(a0)
    80002d34:	4785                	li	a5,1
    80002d36:	00f71f63          	bne	a4,a5,80002d54 <dirlookup+0x3a>
    80002d3a:	892a                	mv	s2,a0
    80002d3c:	8aae                	mv	s5,a1
    80002d3e:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d40:	457c                	lw	a5,76(a0)
    80002d42:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d44:	fa040a13          	addi	s4,s0,-96
    80002d48:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002d4a:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002d4e:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d50:	e39d                	bnez	a5,80002d76 <dirlookup+0x5c>
    80002d52:	a8b9                	j	80002db0 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002d54:	00004517          	auipc	a0,0x4
    80002d58:	6ec50513          	addi	a0,a0,1772 # 80007440 <etext+0x440>
    80002d5c:	28d020ef          	jal	800057e8 <panic>
      panic("dirlookup read");
    80002d60:	00004517          	auipc	a0,0x4
    80002d64:	6f850513          	addi	a0,a0,1784 # 80007458 <etext+0x458>
    80002d68:	281020ef          	jal	800057e8 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d6c:	24c1                	addiw	s1,s1,16
    80002d6e:	04c92783          	lw	a5,76(s2)
    80002d72:	02f4fe63          	bgeu	s1,a5,80002dae <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d76:	874e                	mv	a4,s3
    80002d78:	86a6                	mv	a3,s1
    80002d7a:	8652                	mv	a2,s4
    80002d7c:	4581                	li	a1,0
    80002d7e:	854a                	mv	a0,s2
    80002d80:	d93ff0ef          	jal	80002b12 <readi>
    80002d84:	fd351ee3          	bne	a0,s3,80002d60 <dirlookup+0x46>
    if(de.inum == 0)
    80002d88:	fa045783          	lhu	a5,-96(s0)
    80002d8c:	d3e5                	beqz	a5,80002d6c <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002d8e:	85da                	mv	a1,s6
    80002d90:	8556                	mv	a0,s5
    80002d92:	f73ff0ef          	jal	80002d04 <namecmp>
    80002d96:	f979                	bnez	a0,80002d6c <dirlookup+0x52>
      if(poff)
    80002d98:	000b8463          	beqz	s7,80002da0 <dirlookup+0x86>
        *poff = off;
    80002d9c:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002da0:	fa045583          	lhu	a1,-96(s0)
    80002da4:	00092503          	lw	a0,0(s2)
    80002da8:	f66ff0ef          	jal	8000250e <iget>
    80002dac:	a011                	j	80002db0 <dirlookup+0x96>
  return 0;
    80002dae:	4501                	li	a0,0
}
    80002db0:	60e6                	ld	ra,88(sp)
    80002db2:	6446                	ld	s0,80(sp)
    80002db4:	64a6                	ld	s1,72(sp)
    80002db6:	6906                	ld	s2,64(sp)
    80002db8:	79e2                	ld	s3,56(sp)
    80002dba:	7a42                	ld	s4,48(sp)
    80002dbc:	7aa2                	ld	s5,40(sp)
    80002dbe:	7b02                	ld	s6,32(sp)
    80002dc0:	6be2                	ld	s7,24(sp)
    80002dc2:	6125                	addi	sp,sp,96
    80002dc4:	8082                	ret

0000000080002dc6 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002dc6:	711d                	addi	sp,sp,-96
    80002dc8:	ec86                	sd	ra,88(sp)
    80002dca:	e8a2                	sd	s0,80(sp)
    80002dcc:	e4a6                	sd	s1,72(sp)
    80002dce:	e0ca                	sd	s2,64(sp)
    80002dd0:	fc4e                	sd	s3,56(sp)
    80002dd2:	f852                	sd	s4,48(sp)
    80002dd4:	f456                	sd	s5,40(sp)
    80002dd6:	f05a                	sd	s6,32(sp)
    80002dd8:	ec5e                	sd	s7,24(sp)
    80002dda:	e862                	sd	s8,16(sp)
    80002ddc:	e466                	sd	s9,8(sp)
    80002dde:	e06a                	sd	s10,0(sp)
    80002de0:	1080                	addi	s0,sp,96
    80002de2:	84aa                	mv	s1,a0
    80002de4:	8b2e                	mv	s6,a1
    80002de6:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002de8:	00054703          	lbu	a4,0(a0)
    80002dec:	02f00793          	li	a5,47
    80002df0:	00f70f63          	beq	a4,a5,80002e0e <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002df4:	f95fd0ef          	jal	80000d88 <myproc>
    80002df8:	15053503          	ld	a0,336(a0)
    80002dfc:	94fff0ef          	jal	8000274a <idup>
    80002e00:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002e02:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002e06:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002e08:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002e0a:	4b85                	li	s7,1
    80002e0c:	a879                	j	80002eaa <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002e0e:	4585                	li	a1,1
    80002e10:	852e                	mv	a0,a1
    80002e12:	efcff0ef          	jal	8000250e <iget>
    80002e16:	8a2a                	mv	s4,a0
    80002e18:	b7ed                	j	80002e02 <namex+0x3c>
      iunlockput(ip);
    80002e1a:	8552                	mv	a0,s4
    80002e1c:	b71ff0ef          	jal	8000298c <iunlockput>
      return 0;
    80002e20:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002e22:	8552                	mv	a0,s4
    80002e24:	60e6                	ld	ra,88(sp)
    80002e26:	6446                	ld	s0,80(sp)
    80002e28:	64a6                	ld	s1,72(sp)
    80002e2a:	6906                	ld	s2,64(sp)
    80002e2c:	79e2                	ld	s3,56(sp)
    80002e2e:	7a42                	ld	s4,48(sp)
    80002e30:	7aa2                	ld	s5,40(sp)
    80002e32:	7b02                	ld	s6,32(sp)
    80002e34:	6be2                	ld	s7,24(sp)
    80002e36:	6c42                	ld	s8,16(sp)
    80002e38:	6ca2                	ld	s9,8(sp)
    80002e3a:	6d02                	ld	s10,0(sp)
    80002e3c:	6125                	addi	sp,sp,96
    80002e3e:	8082                	ret
      iunlock(ip);
    80002e40:	8552                	mv	a0,s4
    80002e42:	9edff0ef          	jal	8000282e <iunlock>
      return ip;
    80002e46:	bff1                	j	80002e22 <namex+0x5c>
      iunlockput(ip);
    80002e48:	8552                	mv	a0,s4
    80002e4a:	b43ff0ef          	jal	8000298c <iunlockput>
      return 0;
    80002e4e:	8a4a                	mv	s4,s2
    80002e50:	bfc9                	j	80002e22 <namex+0x5c>
  len = path - s;
    80002e52:	40990633          	sub	a2,s2,s1
    80002e56:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002e5a:	09ac5463          	bge	s8,s10,80002ee2 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002e5e:	8666                	mv	a2,s9
    80002e60:	85a6                	mv	a1,s1
    80002e62:	8556                	mv	a0,s5
    80002e64:	b5afd0ef          	jal	800001be <memmove>
    80002e68:	84ca                	mv	s1,s2
  while(*path == '/')
    80002e6a:	0004c783          	lbu	a5,0(s1)
    80002e6e:	01379763          	bne	a5,s3,80002e7c <namex+0xb6>
    path++;
    80002e72:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e74:	0004c783          	lbu	a5,0(s1)
    80002e78:	ff378de3          	beq	a5,s3,80002e72 <namex+0xac>
    ilock(ip);
    80002e7c:	8552                	mv	a0,s4
    80002e7e:	903ff0ef          	jal	80002780 <ilock>
    if(ip->type != T_DIR){
    80002e82:	044a1783          	lh	a5,68(s4)
    80002e86:	f9779ae3          	bne	a5,s7,80002e1a <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002e8a:	000b0563          	beqz	s6,80002e94 <namex+0xce>
    80002e8e:	0004c783          	lbu	a5,0(s1)
    80002e92:	d7dd                	beqz	a5,80002e40 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002e94:	4601                	li	a2,0
    80002e96:	85d6                	mv	a1,s5
    80002e98:	8552                	mv	a0,s4
    80002e9a:	e81ff0ef          	jal	80002d1a <dirlookup>
    80002e9e:	892a                	mv	s2,a0
    80002ea0:	d545                	beqz	a0,80002e48 <namex+0x82>
    iunlockput(ip);
    80002ea2:	8552                	mv	a0,s4
    80002ea4:	ae9ff0ef          	jal	8000298c <iunlockput>
    ip = next;
    80002ea8:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002eaa:	0004c783          	lbu	a5,0(s1)
    80002eae:	01379763          	bne	a5,s3,80002ebc <namex+0xf6>
    path++;
    80002eb2:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002eb4:	0004c783          	lbu	a5,0(s1)
    80002eb8:	ff378de3          	beq	a5,s3,80002eb2 <namex+0xec>
  if(*path == 0)
    80002ebc:	cf8d                	beqz	a5,80002ef6 <namex+0x130>
  while(*path != '/' && *path != 0)
    80002ebe:	0004c783          	lbu	a5,0(s1)
    80002ec2:	fd178713          	addi	a4,a5,-47
    80002ec6:	cb19                	beqz	a4,80002edc <namex+0x116>
    80002ec8:	cb91                	beqz	a5,80002edc <namex+0x116>
    80002eca:	8926                	mv	s2,s1
    path++;
    80002ecc:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002ece:	00094783          	lbu	a5,0(s2)
    80002ed2:	fd178713          	addi	a4,a5,-47
    80002ed6:	df35                	beqz	a4,80002e52 <namex+0x8c>
    80002ed8:	fbf5                	bnez	a5,80002ecc <namex+0x106>
    80002eda:	bfa5                	j	80002e52 <namex+0x8c>
    80002edc:	8926                	mv	s2,s1
  len = path - s;
    80002ede:	4d01                	li	s10,0
    80002ee0:	4601                	li	a2,0
    memmove(name, s, len);
    80002ee2:	2601                	sext.w	a2,a2
    80002ee4:	85a6                	mv	a1,s1
    80002ee6:	8556                	mv	a0,s5
    80002ee8:	ad6fd0ef          	jal	800001be <memmove>
    name[len] = 0;
    80002eec:	9d56                	add	s10,s10,s5
    80002eee:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffddc68>
    80002ef2:	84ca                	mv	s1,s2
    80002ef4:	bf9d                	j	80002e6a <namex+0xa4>
  if(nameiparent){
    80002ef6:	f20b06e3          	beqz	s6,80002e22 <namex+0x5c>
    iput(ip);
    80002efa:	8552                	mv	a0,s4
    80002efc:	a07ff0ef          	jal	80002902 <iput>
    return 0;
    80002f00:	4a01                	li	s4,0
    80002f02:	b705                	j	80002e22 <namex+0x5c>

0000000080002f04 <dirlink>:
{
    80002f04:	715d                	addi	sp,sp,-80
    80002f06:	e486                	sd	ra,72(sp)
    80002f08:	e0a2                	sd	s0,64(sp)
    80002f0a:	f84a                	sd	s2,48(sp)
    80002f0c:	ec56                	sd	s5,24(sp)
    80002f0e:	e85a                	sd	s6,16(sp)
    80002f10:	0880                	addi	s0,sp,80
    80002f12:	892a                	mv	s2,a0
    80002f14:	8aae                	mv	s5,a1
    80002f16:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002f18:	4601                	li	a2,0
    80002f1a:	e01ff0ef          	jal	80002d1a <dirlookup>
    80002f1e:	ed1d                	bnez	a0,80002f5c <dirlink+0x58>
    80002f20:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f22:	04c92483          	lw	s1,76(s2)
    80002f26:	c4b9                	beqz	s1,80002f74 <dirlink+0x70>
    80002f28:	f44e                	sd	s3,40(sp)
    80002f2a:	f052                	sd	s4,32(sp)
    80002f2c:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f2e:	fb040a13          	addi	s4,s0,-80
    80002f32:	49c1                	li	s3,16
    80002f34:	874e                	mv	a4,s3
    80002f36:	86a6                	mv	a3,s1
    80002f38:	8652                	mv	a2,s4
    80002f3a:	4581                	li	a1,0
    80002f3c:	854a                	mv	a0,s2
    80002f3e:	bd5ff0ef          	jal	80002b12 <readi>
    80002f42:	03351163          	bne	a0,s3,80002f64 <dirlink+0x60>
    if(de.inum == 0)
    80002f46:	fb045783          	lhu	a5,-80(s0)
    80002f4a:	c39d                	beqz	a5,80002f70 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f4c:	24c1                	addiw	s1,s1,16
    80002f4e:	04c92783          	lw	a5,76(s2)
    80002f52:	fef4e1e3          	bltu	s1,a5,80002f34 <dirlink+0x30>
    80002f56:	79a2                	ld	s3,40(sp)
    80002f58:	7a02                	ld	s4,32(sp)
    80002f5a:	a829                	j	80002f74 <dirlink+0x70>
    iput(ip);
    80002f5c:	9a7ff0ef          	jal	80002902 <iput>
    return -1;
    80002f60:	557d                	li	a0,-1
    80002f62:	a83d                	j	80002fa0 <dirlink+0x9c>
      panic("dirlink read");
    80002f64:	00004517          	auipc	a0,0x4
    80002f68:	50450513          	addi	a0,a0,1284 # 80007468 <etext+0x468>
    80002f6c:	07d020ef          	jal	800057e8 <panic>
    80002f70:	79a2                	ld	s3,40(sp)
    80002f72:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002f74:	4639                	li	a2,14
    80002f76:	85d6                	mv	a1,s5
    80002f78:	fb240513          	addi	a0,s0,-78
    80002f7c:	af0fd0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80002f80:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f84:	4741                	li	a4,16
    80002f86:	86a6                	mv	a3,s1
    80002f88:	fb040613          	addi	a2,s0,-80
    80002f8c:	4581                	li	a1,0
    80002f8e:	854a                	mv	a0,s2
    80002f90:	c75ff0ef          	jal	80002c04 <writei>
    80002f94:	1541                	addi	a0,a0,-16
    80002f96:	00a03533          	snez	a0,a0
    80002f9a:	40a0053b          	negw	a0,a0
    80002f9e:	74e2                	ld	s1,56(sp)
}
    80002fa0:	60a6                	ld	ra,72(sp)
    80002fa2:	6406                	ld	s0,64(sp)
    80002fa4:	7942                	ld	s2,48(sp)
    80002fa6:	6ae2                	ld	s5,24(sp)
    80002fa8:	6b42                	ld	s6,16(sp)
    80002faa:	6161                	addi	sp,sp,80
    80002fac:	8082                	ret

0000000080002fae <namei>:

struct inode*
namei(char *path)
{
    80002fae:	1101                	addi	sp,sp,-32
    80002fb0:	ec06                	sd	ra,24(sp)
    80002fb2:	e822                	sd	s0,16(sp)
    80002fb4:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002fb6:	fe040613          	addi	a2,s0,-32
    80002fba:	4581                	li	a1,0
    80002fbc:	e0bff0ef          	jal	80002dc6 <namex>
}
    80002fc0:	60e2                	ld	ra,24(sp)
    80002fc2:	6442                	ld	s0,16(sp)
    80002fc4:	6105                	addi	sp,sp,32
    80002fc6:	8082                	ret

0000000080002fc8 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002fc8:	1141                	addi	sp,sp,-16
    80002fca:	e406                	sd	ra,8(sp)
    80002fcc:	e022                	sd	s0,0(sp)
    80002fce:	0800                	addi	s0,sp,16
    80002fd0:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002fd2:	4585                	li	a1,1
    80002fd4:	df3ff0ef          	jal	80002dc6 <namex>
}
    80002fd8:	60a2                	ld	ra,8(sp)
    80002fda:	6402                	ld	s0,0(sp)
    80002fdc:	0141                	addi	sp,sp,16
    80002fde:	8082                	ret

0000000080002fe0 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002fe0:	1101                	addi	sp,sp,-32
    80002fe2:	ec06                	sd	ra,24(sp)
    80002fe4:	e822                	sd	s0,16(sp)
    80002fe6:	e426                	sd	s1,8(sp)
    80002fe8:	e04a                	sd	s2,0(sp)
    80002fea:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002fec:	00015917          	auipc	s2,0x15
    80002ff0:	09490913          	addi	s2,s2,148 # 80018080 <log>
    80002ff4:	01892583          	lw	a1,24(s2)
    80002ff8:	02492503          	lw	a0,36(s2)
    80002ffc:	8ecff0ef          	jal	800020e8 <bread>
    80003000:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003002:	02892603          	lw	a2,40(s2)
    80003006:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003008:	00c05f63          	blez	a2,80003026 <write_head+0x46>
    8000300c:	00015717          	auipc	a4,0x15
    80003010:	0a070713          	addi	a4,a4,160 # 800180ac <log+0x2c>
    80003014:	87aa                	mv	a5,a0
    80003016:	060a                	slli	a2,a2,0x2
    80003018:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000301a:	4314                	lw	a3,0(a4)
    8000301c:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000301e:	0711                	addi	a4,a4,4
    80003020:	0791                	addi	a5,a5,4
    80003022:	fec79ce3          	bne	a5,a2,8000301a <write_head+0x3a>
  }
  bwrite(buf);
    80003026:	8526                	mv	a0,s1
    80003028:	996ff0ef          	jal	800021be <bwrite>
  brelse(buf);
    8000302c:	8526                	mv	a0,s1
    8000302e:	9c2ff0ef          	jal	800021f0 <brelse>
}
    80003032:	60e2                	ld	ra,24(sp)
    80003034:	6442                	ld	s0,16(sp)
    80003036:	64a2                	ld	s1,8(sp)
    80003038:	6902                	ld	s2,0(sp)
    8000303a:	6105                	addi	sp,sp,32
    8000303c:	8082                	ret

000000008000303e <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000303e:	00015797          	auipc	a5,0x15
    80003042:	06a7a783          	lw	a5,106(a5) # 800180a8 <log+0x28>
    80003046:	0cf05163          	blez	a5,80003108 <install_trans+0xca>
{
    8000304a:	715d                	addi	sp,sp,-80
    8000304c:	e486                	sd	ra,72(sp)
    8000304e:	e0a2                	sd	s0,64(sp)
    80003050:	fc26                	sd	s1,56(sp)
    80003052:	f84a                	sd	s2,48(sp)
    80003054:	f44e                	sd	s3,40(sp)
    80003056:	f052                	sd	s4,32(sp)
    80003058:	ec56                	sd	s5,24(sp)
    8000305a:	e85a                	sd	s6,16(sp)
    8000305c:	e45e                	sd	s7,8(sp)
    8000305e:	e062                	sd	s8,0(sp)
    80003060:	0880                	addi	s0,sp,80
    80003062:	8b2a                	mv	s6,a0
    80003064:	00015a97          	auipc	s5,0x15
    80003068:	048a8a93          	addi	s5,s5,72 # 800180ac <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000306c:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000306e:	00004c17          	auipc	s8,0x4
    80003072:	40ac0c13          	addi	s8,s8,1034 # 80007478 <etext+0x478>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003076:	00015a17          	auipc	s4,0x15
    8000307a:	00aa0a13          	addi	s4,s4,10 # 80018080 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000307e:	40000b93          	li	s7,1024
    80003082:	a025                	j	800030aa <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003084:	000aa603          	lw	a2,0(s5)
    80003088:	85ce                	mv	a1,s3
    8000308a:	8562                	mv	a0,s8
    8000308c:	3b0020ef          	jal	8000543c <printf>
    80003090:	a839                	j	800030ae <install_trans+0x70>
    brelse(lbuf);
    80003092:	854a                	mv	a0,s2
    80003094:	95cff0ef          	jal	800021f0 <brelse>
    brelse(dbuf);
    80003098:	8526                	mv	a0,s1
    8000309a:	956ff0ef          	jal	800021f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000309e:	2985                	addiw	s3,s3,1
    800030a0:	0a91                	addi	s5,s5,4
    800030a2:	028a2783          	lw	a5,40(s4)
    800030a6:	04f9d563          	bge	s3,a5,800030f0 <install_trans+0xb2>
    if(recovering) {
    800030aa:	fc0b1de3          	bnez	s6,80003084 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800030ae:	018a2583          	lw	a1,24(s4)
    800030b2:	013585bb          	addw	a1,a1,s3
    800030b6:	2585                	addiw	a1,a1,1
    800030b8:	024a2503          	lw	a0,36(s4)
    800030bc:	82cff0ef          	jal	800020e8 <bread>
    800030c0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800030c2:	000aa583          	lw	a1,0(s5)
    800030c6:	024a2503          	lw	a0,36(s4)
    800030ca:	81eff0ef          	jal	800020e8 <bread>
    800030ce:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800030d0:	865e                	mv	a2,s7
    800030d2:	05890593          	addi	a1,s2,88
    800030d6:	05850513          	addi	a0,a0,88
    800030da:	8e4fd0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    800030de:	8526                	mv	a0,s1
    800030e0:	8deff0ef          	jal	800021be <bwrite>
    if(recovering == 0)
    800030e4:	fa0b17e3          	bnez	s6,80003092 <install_trans+0x54>
      bunpin(dbuf);
    800030e8:	8526                	mv	a0,s1
    800030ea:	9beff0ef          	jal	800022a8 <bunpin>
    800030ee:	b755                	j	80003092 <install_trans+0x54>
}
    800030f0:	60a6                	ld	ra,72(sp)
    800030f2:	6406                	ld	s0,64(sp)
    800030f4:	74e2                	ld	s1,56(sp)
    800030f6:	7942                	ld	s2,48(sp)
    800030f8:	79a2                	ld	s3,40(sp)
    800030fa:	7a02                	ld	s4,32(sp)
    800030fc:	6ae2                	ld	s5,24(sp)
    800030fe:	6b42                	ld	s6,16(sp)
    80003100:	6ba2                	ld	s7,8(sp)
    80003102:	6c02                	ld	s8,0(sp)
    80003104:	6161                	addi	sp,sp,80
    80003106:	8082                	ret
    80003108:	8082                	ret

000000008000310a <initlog>:
{
    8000310a:	7179                	addi	sp,sp,-48
    8000310c:	f406                	sd	ra,40(sp)
    8000310e:	f022                	sd	s0,32(sp)
    80003110:	ec26                	sd	s1,24(sp)
    80003112:	e84a                	sd	s2,16(sp)
    80003114:	e44e                	sd	s3,8(sp)
    80003116:	1800                	addi	s0,sp,48
    80003118:	84aa                	mv	s1,a0
    8000311a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000311c:	00015917          	auipc	s2,0x15
    80003120:	f6490913          	addi	s2,s2,-156 # 80018080 <log>
    80003124:	00004597          	auipc	a1,0x4
    80003128:	37458593          	addi	a1,a1,884 # 80007498 <etext+0x498>
    8000312c:	854a                	mv	a0,s2
    8000312e:	0d3020ef          	jal	80005a00 <initlock>
  log.start = sb->logstart;
    80003132:	0149a583          	lw	a1,20(s3)
    80003136:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    8000313a:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    8000313e:	8526                	mv	a0,s1
    80003140:	fa9fe0ef          	jal	800020e8 <bread>
  log.lh.n = lh->n;
    80003144:	4d30                	lw	a2,88(a0)
    80003146:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    8000314a:	00c05f63          	blez	a2,80003168 <initlog+0x5e>
    8000314e:	87aa                	mv	a5,a0
    80003150:	00015717          	auipc	a4,0x15
    80003154:	f5c70713          	addi	a4,a4,-164 # 800180ac <log+0x2c>
    80003158:	060a                	slli	a2,a2,0x2
    8000315a:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000315c:	4ff4                	lw	a3,92(a5)
    8000315e:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003160:	0791                	addi	a5,a5,4
    80003162:	0711                	addi	a4,a4,4
    80003164:	fec79ce3          	bne	a5,a2,8000315c <initlog+0x52>
  brelse(buf);
    80003168:	888ff0ef          	jal	800021f0 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000316c:	4505                	li	a0,1
    8000316e:	ed1ff0ef          	jal	8000303e <install_trans>
  log.lh.n = 0;
    80003172:	00015797          	auipc	a5,0x15
    80003176:	f207ab23          	sw	zero,-202(a5) # 800180a8 <log+0x28>
  write_head(); // clear the log
    8000317a:	e67ff0ef          	jal	80002fe0 <write_head>
}
    8000317e:	70a2                	ld	ra,40(sp)
    80003180:	7402                	ld	s0,32(sp)
    80003182:	64e2                	ld	s1,24(sp)
    80003184:	6942                	ld	s2,16(sp)
    80003186:	69a2                	ld	s3,8(sp)
    80003188:	6145                	addi	sp,sp,48
    8000318a:	8082                	ret

000000008000318c <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    8000318c:	1101                	addi	sp,sp,-32
    8000318e:	ec06                	sd	ra,24(sp)
    80003190:	e822                	sd	s0,16(sp)
    80003192:	e426                	sd	s1,8(sp)
    80003194:	e04a                	sd	s2,0(sp)
    80003196:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003198:	00015517          	auipc	a0,0x15
    8000319c:	ee850513          	addi	a0,a0,-280 # 80018080 <log>
    800031a0:	0eb020ef          	jal	80005a8a <acquire>
  while(1){
    if(log.committing){
    800031a4:	00015497          	auipc	s1,0x15
    800031a8:	edc48493          	addi	s1,s1,-292 # 80018080 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800031ac:	4979                	li	s2,30
    800031ae:	a029                	j	800031b8 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800031b0:	85a6                	mv	a1,s1
    800031b2:	8526                	mv	a0,s1
    800031b4:	a48fe0ef          	jal	800013fc <sleep>
    if(log.committing){
    800031b8:	509c                	lw	a5,32(s1)
    800031ba:	fbfd                	bnez	a5,800031b0 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800031bc:	4cd8                	lw	a4,28(s1)
    800031be:	2705                	addiw	a4,a4,1
    800031c0:	0027179b          	slliw	a5,a4,0x2
    800031c4:	9fb9                	addw	a5,a5,a4
    800031c6:	0017979b          	slliw	a5,a5,0x1
    800031ca:	5494                	lw	a3,40(s1)
    800031cc:	9fb5                	addw	a5,a5,a3
    800031ce:	00f95763          	bge	s2,a5,800031dc <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800031d2:	85a6                	mv	a1,s1
    800031d4:	8526                	mv	a0,s1
    800031d6:	a26fe0ef          	jal	800013fc <sleep>
    800031da:	bff9                	j	800031b8 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800031dc:	00015797          	auipc	a5,0x15
    800031e0:	ece7a023          	sw	a4,-320(a5) # 8001809c <log+0x1c>
      release(&log.lock);
    800031e4:	00015517          	auipc	a0,0x15
    800031e8:	e9c50513          	addi	a0,a0,-356 # 80018080 <log>
    800031ec:	133020ef          	jal	80005b1e <release>
      break;
    }
  }
}
    800031f0:	60e2                	ld	ra,24(sp)
    800031f2:	6442                	ld	s0,16(sp)
    800031f4:	64a2                	ld	s1,8(sp)
    800031f6:	6902                	ld	s2,0(sp)
    800031f8:	6105                	addi	sp,sp,32
    800031fa:	8082                	ret

00000000800031fc <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800031fc:	7139                	addi	sp,sp,-64
    800031fe:	fc06                	sd	ra,56(sp)
    80003200:	f822                	sd	s0,48(sp)
    80003202:	f426                	sd	s1,40(sp)
    80003204:	f04a                	sd	s2,32(sp)
    80003206:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003208:	00015497          	auipc	s1,0x15
    8000320c:	e7848493          	addi	s1,s1,-392 # 80018080 <log>
    80003210:	8526                	mv	a0,s1
    80003212:	079020ef          	jal	80005a8a <acquire>
  log.outstanding -= 1;
    80003216:	4cdc                	lw	a5,28(s1)
    80003218:	37fd                	addiw	a5,a5,-1
    8000321a:	893e                	mv	s2,a5
    8000321c:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    8000321e:	509c                	lw	a5,32(s1)
    80003220:	e7b1                	bnez	a5,8000326c <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003222:	04091e63          	bnez	s2,8000327e <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003226:	00015497          	auipc	s1,0x15
    8000322a:	e5a48493          	addi	s1,s1,-422 # 80018080 <log>
    8000322e:	4785                	li	a5,1
    80003230:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003232:	8526                	mv	a0,s1
    80003234:	0eb020ef          	jal	80005b1e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003238:	549c                	lw	a5,40(s1)
    8000323a:	06f04463          	bgtz	a5,800032a2 <end_op+0xa6>
    acquire(&log.lock);
    8000323e:	00015517          	auipc	a0,0x15
    80003242:	e4250513          	addi	a0,a0,-446 # 80018080 <log>
    80003246:	045020ef          	jal	80005a8a <acquire>
    log.committing = 0;
    8000324a:	00015797          	auipc	a5,0x15
    8000324e:	e407ab23          	sw	zero,-426(a5) # 800180a0 <log+0x20>
    wakeup(&log);
    80003252:	00015517          	auipc	a0,0x15
    80003256:	e2e50513          	addi	a0,a0,-466 # 80018080 <log>
    8000325a:	9eefe0ef          	jal	80001448 <wakeup>
    release(&log.lock);
    8000325e:	00015517          	auipc	a0,0x15
    80003262:	e2250513          	addi	a0,a0,-478 # 80018080 <log>
    80003266:	0b9020ef          	jal	80005b1e <release>
}
    8000326a:	a035                	j	80003296 <end_op+0x9a>
    8000326c:	ec4e                	sd	s3,24(sp)
    8000326e:	e852                	sd	s4,16(sp)
    80003270:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003272:	00004517          	auipc	a0,0x4
    80003276:	22e50513          	addi	a0,a0,558 # 800074a0 <etext+0x4a0>
    8000327a:	56e020ef          	jal	800057e8 <panic>
    wakeup(&log);
    8000327e:	00015517          	auipc	a0,0x15
    80003282:	e0250513          	addi	a0,a0,-510 # 80018080 <log>
    80003286:	9c2fe0ef          	jal	80001448 <wakeup>
  release(&log.lock);
    8000328a:	00015517          	auipc	a0,0x15
    8000328e:	df650513          	addi	a0,a0,-522 # 80018080 <log>
    80003292:	08d020ef          	jal	80005b1e <release>
}
    80003296:	70e2                	ld	ra,56(sp)
    80003298:	7442                	ld	s0,48(sp)
    8000329a:	74a2                	ld	s1,40(sp)
    8000329c:	7902                	ld	s2,32(sp)
    8000329e:	6121                	addi	sp,sp,64
    800032a0:	8082                	ret
    800032a2:	ec4e                	sd	s3,24(sp)
    800032a4:	e852                	sd	s4,16(sp)
    800032a6:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800032a8:	00015a97          	auipc	s5,0x15
    800032ac:	e04a8a93          	addi	s5,s5,-508 # 800180ac <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800032b0:	00015a17          	auipc	s4,0x15
    800032b4:	dd0a0a13          	addi	s4,s4,-560 # 80018080 <log>
    800032b8:	018a2583          	lw	a1,24(s4)
    800032bc:	012585bb          	addw	a1,a1,s2
    800032c0:	2585                	addiw	a1,a1,1
    800032c2:	024a2503          	lw	a0,36(s4)
    800032c6:	e23fe0ef          	jal	800020e8 <bread>
    800032ca:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800032cc:	000aa583          	lw	a1,0(s5)
    800032d0:	024a2503          	lw	a0,36(s4)
    800032d4:	e15fe0ef          	jal	800020e8 <bread>
    800032d8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800032da:	40000613          	li	a2,1024
    800032de:	05850593          	addi	a1,a0,88
    800032e2:	05848513          	addi	a0,s1,88
    800032e6:	ed9fc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    800032ea:	8526                	mv	a0,s1
    800032ec:	ed3fe0ef          	jal	800021be <bwrite>
    brelse(from);
    800032f0:	854e                	mv	a0,s3
    800032f2:	efffe0ef          	jal	800021f0 <brelse>
    brelse(to);
    800032f6:	8526                	mv	a0,s1
    800032f8:	ef9fe0ef          	jal	800021f0 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800032fc:	2905                	addiw	s2,s2,1
    800032fe:	0a91                	addi	s5,s5,4
    80003300:	028a2783          	lw	a5,40(s4)
    80003304:	faf94ae3          	blt	s2,a5,800032b8 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003308:	cd9ff0ef          	jal	80002fe0 <write_head>
    install_trans(0); // Now install writes to home locations
    8000330c:	4501                	li	a0,0
    8000330e:	d31ff0ef          	jal	8000303e <install_trans>
    log.lh.n = 0;
    80003312:	00015797          	auipc	a5,0x15
    80003316:	d807ab23          	sw	zero,-618(a5) # 800180a8 <log+0x28>
    write_head();    // Erase the transaction from the log
    8000331a:	cc7ff0ef          	jal	80002fe0 <write_head>
    8000331e:	69e2                	ld	s3,24(sp)
    80003320:	6a42                	ld	s4,16(sp)
    80003322:	6aa2                	ld	s5,8(sp)
    80003324:	bf29                	j	8000323e <end_op+0x42>

0000000080003326 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003326:	1101                	addi	sp,sp,-32
    80003328:	ec06                	sd	ra,24(sp)
    8000332a:	e822                	sd	s0,16(sp)
    8000332c:	e426                	sd	s1,8(sp)
    8000332e:	1000                	addi	s0,sp,32
    80003330:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003332:	00015517          	auipc	a0,0x15
    80003336:	d4e50513          	addi	a0,a0,-690 # 80018080 <log>
    8000333a:	750020ef          	jal	80005a8a <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000333e:	00015617          	auipc	a2,0x15
    80003342:	d6a62603          	lw	a2,-662(a2) # 800180a8 <log+0x28>
    80003346:	47f5                	li	a5,29
    80003348:	04c7cd63          	blt	a5,a2,800033a2 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000334c:	00015797          	auipc	a5,0x15
    80003350:	d507a783          	lw	a5,-688(a5) # 8001809c <log+0x1c>
    80003354:	04f05d63          	blez	a5,800033ae <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003358:	4781                	li	a5,0
    8000335a:	06c05063          	blez	a2,800033ba <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000335e:	44cc                	lw	a1,12(s1)
    80003360:	00015717          	auipc	a4,0x15
    80003364:	d4c70713          	addi	a4,a4,-692 # 800180ac <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003368:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000336a:	4314                	lw	a3,0(a4)
    8000336c:	04b68763          	beq	a3,a1,800033ba <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003370:	2785                	addiw	a5,a5,1
    80003372:	0711                	addi	a4,a4,4
    80003374:	fef61be3          	bne	a2,a5,8000336a <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003378:	060a                	slli	a2,a2,0x2
    8000337a:	02060613          	addi	a2,a2,32
    8000337e:	00015797          	auipc	a5,0x15
    80003382:	d0278793          	addi	a5,a5,-766 # 80018080 <log>
    80003386:	97b2                	add	a5,a5,a2
    80003388:	44d8                	lw	a4,12(s1)
    8000338a:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000338c:	8526                	mv	a0,s1
    8000338e:	ee7fe0ef          	jal	80002274 <bpin>
    log.lh.n++;
    80003392:	00015717          	auipc	a4,0x15
    80003396:	cee70713          	addi	a4,a4,-786 # 80018080 <log>
    8000339a:	571c                	lw	a5,40(a4)
    8000339c:	2785                	addiw	a5,a5,1
    8000339e:	d71c                	sw	a5,40(a4)
    800033a0:	a815                	j	800033d4 <log_write+0xae>
    panic("too big a transaction");
    800033a2:	00004517          	auipc	a0,0x4
    800033a6:	10e50513          	addi	a0,a0,270 # 800074b0 <etext+0x4b0>
    800033aa:	43e020ef          	jal	800057e8 <panic>
    panic("log_write outside of trans");
    800033ae:	00004517          	auipc	a0,0x4
    800033b2:	11a50513          	addi	a0,a0,282 # 800074c8 <etext+0x4c8>
    800033b6:	432020ef          	jal	800057e8 <panic>
  log.lh.block[i] = b->blockno;
    800033ba:	00279693          	slli	a3,a5,0x2
    800033be:	02068693          	addi	a3,a3,32
    800033c2:	00015717          	auipc	a4,0x15
    800033c6:	cbe70713          	addi	a4,a4,-834 # 80018080 <log>
    800033ca:	9736                	add	a4,a4,a3
    800033cc:	44d4                	lw	a3,12(s1)
    800033ce:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800033d0:	faf60ee3          	beq	a2,a5,8000338c <log_write+0x66>
  }
  release(&log.lock);
    800033d4:	00015517          	auipc	a0,0x15
    800033d8:	cac50513          	addi	a0,a0,-852 # 80018080 <log>
    800033dc:	742020ef          	jal	80005b1e <release>
}
    800033e0:	60e2                	ld	ra,24(sp)
    800033e2:	6442                	ld	s0,16(sp)
    800033e4:	64a2                	ld	s1,8(sp)
    800033e6:	6105                	addi	sp,sp,32
    800033e8:	8082                	ret

00000000800033ea <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800033ea:	1101                	addi	sp,sp,-32
    800033ec:	ec06                	sd	ra,24(sp)
    800033ee:	e822                	sd	s0,16(sp)
    800033f0:	e426                	sd	s1,8(sp)
    800033f2:	e04a                	sd	s2,0(sp)
    800033f4:	1000                	addi	s0,sp,32
    800033f6:	84aa                	mv	s1,a0
    800033f8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800033fa:	00004597          	auipc	a1,0x4
    800033fe:	0ee58593          	addi	a1,a1,238 # 800074e8 <etext+0x4e8>
    80003402:	0521                	addi	a0,a0,8
    80003404:	5fc020ef          	jal	80005a00 <initlock>
  lk->name = name;
    80003408:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000340c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003410:	0204a423          	sw	zero,40(s1)
}
    80003414:	60e2                	ld	ra,24(sp)
    80003416:	6442                	ld	s0,16(sp)
    80003418:	64a2                	ld	s1,8(sp)
    8000341a:	6902                	ld	s2,0(sp)
    8000341c:	6105                	addi	sp,sp,32
    8000341e:	8082                	ret

0000000080003420 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003420:	1101                	addi	sp,sp,-32
    80003422:	ec06                	sd	ra,24(sp)
    80003424:	e822                	sd	s0,16(sp)
    80003426:	e426                	sd	s1,8(sp)
    80003428:	e04a                	sd	s2,0(sp)
    8000342a:	1000                	addi	s0,sp,32
    8000342c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000342e:	00850913          	addi	s2,a0,8
    80003432:	854a                	mv	a0,s2
    80003434:	656020ef          	jal	80005a8a <acquire>
  while (lk->locked) {
    80003438:	409c                	lw	a5,0(s1)
    8000343a:	c799                	beqz	a5,80003448 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000343c:	85ca                	mv	a1,s2
    8000343e:	8526                	mv	a0,s1
    80003440:	fbdfd0ef          	jal	800013fc <sleep>
  while (lk->locked) {
    80003444:	409c                	lw	a5,0(s1)
    80003446:	fbfd                	bnez	a5,8000343c <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003448:	4785                	li	a5,1
    8000344a:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000344c:	93dfd0ef          	jal	80000d88 <myproc>
    80003450:	591c                	lw	a5,48(a0)
    80003452:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003454:	854a                	mv	a0,s2
    80003456:	6c8020ef          	jal	80005b1e <release>
}
    8000345a:	60e2                	ld	ra,24(sp)
    8000345c:	6442                	ld	s0,16(sp)
    8000345e:	64a2                	ld	s1,8(sp)
    80003460:	6902                	ld	s2,0(sp)
    80003462:	6105                	addi	sp,sp,32
    80003464:	8082                	ret

0000000080003466 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003466:	1101                	addi	sp,sp,-32
    80003468:	ec06                	sd	ra,24(sp)
    8000346a:	e822                	sd	s0,16(sp)
    8000346c:	e426                	sd	s1,8(sp)
    8000346e:	e04a                	sd	s2,0(sp)
    80003470:	1000                	addi	s0,sp,32
    80003472:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003474:	00850913          	addi	s2,a0,8
    80003478:	854a                	mv	a0,s2
    8000347a:	610020ef          	jal	80005a8a <acquire>
  lk->locked = 0;
    8000347e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003482:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003486:	8526                	mv	a0,s1
    80003488:	fc1fd0ef          	jal	80001448 <wakeup>
  release(&lk->lk);
    8000348c:	854a                	mv	a0,s2
    8000348e:	690020ef          	jal	80005b1e <release>
}
    80003492:	60e2                	ld	ra,24(sp)
    80003494:	6442                	ld	s0,16(sp)
    80003496:	64a2                	ld	s1,8(sp)
    80003498:	6902                	ld	s2,0(sp)
    8000349a:	6105                	addi	sp,sp,32
    8000349c:	8082                	ret

000000008000349e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000349e:	7179                	addi	sp,sp,-48
    800034a0:	f406                	sd	ra,40(sp)
    800034a2:	f022                	sd	s0,32(sp)
    800034a4:	ec26                	sd	s1,24(sp)
    800034a6:	e84a                	sd	s2,16(sp)
    800034a8:	1800                	addi	s0,sp,48
    800034aa:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800034ac:	00850913          	addi	s2,a0,8
    800034b0:	854a                	mv	a0,s2
    800034b2:	5d8020ef          	jal	80005a8a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800034b6:	409c                	lw	a5,0(s1)
    800034b8:	ef81                	bnez	a5,800034d0 <holdingsleep+0x32>
    800034ba:	4481                	li	s1,0
  release(&lk->lk);
    800034bc:	854a                	mv	a0,s2
    800034be:	660020ef          	jal	80005b1e <release>
  return r;
}
    800034c2:	8526                	mv	a0,s1
    800034c4:	70a2                	ld	ra,40(sp)
    800034c6:	7402                	ld	s0,32(sp)
    800034c8:	64e2                	ld	s1,24(sp)
    800034ca:	6942                	ld	s2,16(sp)
    800034cc:	6145                	addi	sp,sp,48
    800034ce:	8082                	ret
    800034d0:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800034d2:	0284a983          	lw	s3,40(s1)
    800034d6:	8b3fd0ef          	jal	80000d88 <myproc>
    800034da:	5904                	lw	s1,48(a0)
    800034dc:	413484b3          	sub	s1,s1,s3
    800034e0:	0014b493          	seqz	s1,s1
    800034e4:	69a2                	ld	s3,8(sp)
    800034e6:	bfd9                	j	800034bc <holdingsleep+0x1e>

00000000800034e8 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800034e8:	1141                	addi	sp,sp,-16
    800034ea:	e406                	sd	ra,8(sp)
    800034ec:	e022                	sd	s0,0(sp)
    800034ee:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800034f0:	00004597          	auipc	a1,0x4
    800034f4:	00858593          	addi	a1,a1,8 # 800074f8 <etext+0x4f8>
    800034f8:	00015517          	auipc	a0,0x15
    800034fc:	cd050513          	addi	a0,a0,-816 # 800181c8 <ftable>
    80003500:	500020ef          	jal	80005a00 <initlock>
}
    80003504:	60a2                	ld	ra,8(sp)
    80003506:	6402                	ld	s0,0(sp)
    80003508:	0141                	addi	sp,sp,16
    8000350a:	8082                	ret

000000008000350c <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000350c:	1101                	addi	sp,sp,-32
    8000350e:	ec06                	sd	ra,24(sp)
    80003510:	e822                	sd	s0,16(sp)
    80003512:	e426                	sd	s1,8(sp)
    80003514:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003516:	00015517          	auipc	a0,0x15
    8000351a:	cb250513          	addi	a0,a0,-846 # 800181c8 <ftable>
    8000351e:	56c020ef          	jal	80005a8a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003522:	00015497          	auipc	s1,0x15
    80003526:	cbe48493          	addi	s1,s1,-834 # 800181e0 <ftable+0x18>
    8000352a:	00016717          	auipc	a4,0x16
    8000352e:	c5670713          	addi	a4,a4,-938 # 80019180 <disk>
    if(f->ref == 0){
    80003532:	40dc                	lw	a5,4(s1)
    80003534:	cf89                	beqz	a5,8000354e <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003536:	02848493          	addi	s1,s1,40
    8000353a:	fee49ce3          	bne	s1,a4,80003532 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000353e:	00015517          	auipc	a0,0x15
    80003542:	c8a50513          	addi	a0,a0,-886 # 800181c8 <ftable>
    80003546:	5d8020ef          	jal	80005b1e <release>
  return 0;
    8000354a:	4481                	li	s1,0
    8000354c:	a809                	j	8000355e <filealloc+0x52>
      f->ref = 1;
    8000354e:	4785                	li	a5,1
    80003550:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003552:	00015517          	auipc	a0,0x15
    80003556:	c7650513          	addi	a0,a0,-906 # 800181c8 <ftable>
    8000355a:	5c4020ef          	jal	80005b1e <release>
}
    8000355e:	8526                	mv	a0,s1
    80003560:	60e2                	ld	ra,24(sp)
    80003562:	6442                	ld	s0,16(sp)
    80003564:	64a2                	ld	s1,8(sp)
    80003566:	6105                	addi	sp,sp,32
    80003568:	8082                	ret

000000008000356a <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    8000356a:	1101                	addi	sp,sp,-32
    8000356c:	ec06                	sd	ra,24(sp)
    8000356e:	e822                	sd	s0,16(sp)
    80003570:	e426                	sd	s1,8(sp)
    80003572:	1000                	addi	s0,sp,32
    80003574:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003576:	00015517          	auipc	a0,0x15
    8000357a:	c5250513          	addi	a0,a0,-942 # 800181c8 <ftable>
    8000357e:	50c020ef          	jal	80005a8a <acquire>
  if(f->ref < 1)
    80003582:	40dc                	lw	a5,4(s1)
    80003584:	02f05063          	blez	a5,800035a4 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003588:	2785                	addiw	a5,a5,1
    8000358a:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    8000358c:	00015517          	auipc	a0,0x15
    80003590:	c3c50513          	addi	a0,a0,-964 # 800181c8 <ftable>
    80003594:	58a020ef          	jal	80005b1e <release>
  return f;
}
    80003598:	8526                	mv	a0,s1
    8000359a:	60e2                	ld	ra,24(sp)
    8000359c:	6442                	ld	s0,16(sp)
    8000359e:	64a2                	ld	s1,8(sp)
    800035a0:	6105                	addi	sp,sp,32
    800035a2:	8082                	ret
    panic("filedup");
    800035a4:	00004517          	auipc	a0,0x4
    800035a8:	f5c50513          	addi	a0,a0,-164 # 80007500 <etext+0x500>
    800035ac:	23c020ef          	jal	800057e8 <panic>

00000000800035b0 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800035b0:	7139                	addi	sp,sp,-64
    800035b2:	fc06                	sd	ra,56(sp)
    800035b4:	f822                	sd	s0,48(sp)
    800035b6:	f426                	sd	s1,40(sp)
    800035b8:	0080                	addi	s0,sp,64
    800035ba:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800035bc:	00015517          	auipc	a0,0x15
    800035c0:	c0c50513          	addi	a0,a0,-1012 # 800181c8 <ftable>
    800035c4:	4c6020ef          	jal	80005a8a <acquire>
  if(f->ref < 1)
    800035c8:	40dc                	lw	a5,4(s1)
    800035ca:	04f05a63          	blez	a5,8000361e <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800035ce:	37fd                	addiw	a5,a5,-1
    800035d0:	c0dc                	sw	a5,4(s1)
    800035d2:	06f04063          	bgtz	a5,80003632 <fileclose+0x82>
    800035d6:	f04a                	sd	s2,32(sp)
    800035d8:	ec4e                	sd	s3,24(sp)
    800035da:	e852                	sd	s4,16(sp)
    800035dc:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800035de:	0004a903          	lw	s2,0(s1)
    800035e2:	0094c783          	lbu	a5,9(s1)
    800035e6:	89be                	mv	s3,a5
    800035e8:	689c                	ld	a5,16(s1)
    800035ea:	8a3e                	mv	s4,a5
    800035ec:	6c9c                	ld	a5,24(s1)
    800035ee:	8abe                	mv	s5,a5
  f->ref = 0;
    800035f0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800035f4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800035f8:	00015517          	auipc	a0,0x15
    800035fc:	bd050513          	addi	a0,a0,-1072 # 800181c8 <ftable>
    80003600:	51e020ef          	jal	80005b1e <release>

  if(ff.type == FD_PIPE){
    80003604:	4785                	li	a5,1
    80003606:	04f90163          	beq	s2,a5,80003648 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    8000360a:	ffe9079b          	addiw	a5,s2,-2
    8000360e:	4705                	li	a4,1
    80003610:	04f77563          	bgeu	a4,a5,8000365a <fileclose+0xaa>
    80003614:	7902                	ld	s2,32(sp)
    80003616:	69e2                	ld	s3,24(sp)
    80003618:	6a42                	ld	s4,16(sp)
    8000361a:	6aa2                	ld	s5,8(sp)
    8000361c:	a00d                	j	8000363e <fileclose+0x8e>
    8000361e:	f04a                	sd	s2,32(sp)
    80003620:	ec4e                	sd	s3,24(sp)
    80003622:	e852                	sd	s4,16(sp)
    80003624:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003626:	00004517          	auipc	a0,0x4
    8000362a:	ee250513          	addi	a0,a0,-286 # 80007508 <etext+0x508>
    8000362e:	1ba020ef          	jal	800057e8 <panic>
    release(&ftable.lock);
    80003632:	00015517          	auipc	a0,0x15
    80003636:	b9650513          	addi	a0,a0,-1130 # 800181c8 <ftable>
    8000363a:	4e4020ef          	jal	80005b1e <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000363e:	70e2                	ld	ra,56(sp)
    80003640:	7442                	ld	s0,48(sp)
    80003642:	74a2                	ld	s1,40(sp)
    80003644:	6121                	addi	sp,sp,64
    80003646:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003648:	85ce                	mv	a1,s3
    8000364a:	8552                	mv	a0,s4
    8000364c:	348000ef          	jal	80003994 <pipeclose>
    80003650:	7902                	ld	s2,32(sp)
    80003652:	69e2                	ld	s3,24(sp)
    80003654:	6a42                	ld	s4,16(sp)
    80003656:	6aa2                	ld	s5,8(sp)
    80003658:	b7dd                	j	8000363e <fileclose+0x8e>
    begin_op();
    8000365a:	b33ff0ef          	jal	8000318c <begin_op>
    iput(ff.ip);
    8000365e:	8556                	mv	a0,s5
    80003660:	aa2ff0ef          	jal	80002902 <iput>
    end_op();
    80003664:	b99ff0ef          	jal	800031fc <end_op>
    80003668:	7902                	ld	s2,32(sp)
    8000366a:	69e2                	ld	s3,24(sp)
    8000366c:	6a42                	ld	s4,16(sp)
    8000366e:	6aa2                	ld	s5,8(sp)
    80003670:	b7f9                	j	8000363e <fileclose+0x8e>

0000000080003672 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003672:	715d                	addi	sp,sp,-80
    80003674:	e486                	sd	ra,72(sp)
    80003676:	e0a2                	sd	s0,64(sp)
    80003678:	fc26                	sd	s1,56(sp)
    8000367a:	f052                	sd	s4,32(sp)
    8000367c:	0880                	addi	s0,sp,80
    8000367e:	84aa                	mv	s1,a0
    80003680:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80003682:	f06fd0ef          	jal	80000d88 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003686:	409c                	lw	a5,0(s1)
    80003688:	37f9                	addiw	a5,a5,-2
    8000368a:	4705                	li	a4,1
    8000368c:	04f76263          	bltu	a4,a5,800036d0 <filestat+0x5e>
    80003690:	f84a                	sd	s2,48(sp)
    80003692:	f44e                	sd	s3,40(sp)
    80003694:	89aa                	mv	s3,a0
    ilock(f->ip);
    80003696:	6c88                	ld	a0,24(s1)
    80003698:	8e8ff0ef          	jal	80002780 <ilock>
    stati(f->ip, &st);
    8000369c:	fb840913          	addi	s2,s0,-72
    800036a0:	85ca                	mv	a1,s2
    800036a2:	6c88                	ld	a0,24(s1)
    800036a4:	c40ff0ef          	jal	80002ae4 <stati>
    iunlock(f->ip);
    800036a8:	6c88                	ld	a0,24(s1)
    800036aa:	984ff0ef          	jal	8000282e <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800036ae:	46e1                	li	a3,24
    800036b0:	864a                	mv	a2,s2
    800036b2:	85d2                	mv	a1,s4
    800036b4:	0509b503          	ld	a0,80(s3)
    800036b8:	c02fd0ef          	jal	80000aba <copyout>
    800036bc:	41f5551b          	sraiw	a0,a0,0x1f
    800036c0:	7942                	ld	s2,48(sp)
    800036c2:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800036c4:	60a6                	ld	ra,72(sp)
    800036c6:	6406                	ld	s0,64(sp)
    800036c8:	74e2                	ld	s1,56(sp)
    800036ca:	7a02                	ld	s4,32(sp)
    800036cc:	6161                	addi	sp,sp,80
    800036ce:	8082                	ret
  return -1;
    800036d0:	557d                	li	a0,-1
    800036d2:	bfcd                	j	800036c4 <filestat+0x52>

00000000800036d4 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800036d4:	7179                	addi	sp,sp,-48
    800036d6:	f406                	sd	ra,40(sp)
    800036d8:	f022                	sd	s0,32(sp)
    800036da:	e84a                	sd	s2,16(sp)
    800036dc:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800036de:	00854783          	lbu	a5,8(a0)
    800036e2:	cfd1                	beqz	a5,8000377e <fileread+0xaa>
    800036e4:	ec26                	sd	s1,24(sp)
    800036e6:	e44e                	sd	s3,8(sp)
    800036e8:	84aa                	mv	s1,a0
    800036ea:	892e                	mv	s2,a1
    800036ec:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800036ee:	411c                	lw	a5,0(a0)
    800036f0:	4705                	li	a4,1
    800036f2:	04e78363          	beq	a5,a4,80003738 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036f6:	470d                	li	a4,3
    800036f8:	04e78763          	beq	a5,a4,80003746 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800036fc:	4709                	li	a4,2
    800036fe:	06e79a63          	bne	a5,a4,80003772 <fileread+0x9e>
    ilock(f->ip);
    80003702:	6d08                	ld	a0,24(a0)
    80003704:	87cff0ef          	jal	80002780 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003708:	874e                	mv	a4,s3
    8000370a:	5094                	lw	a3,32(s1)
    8000370c:	864a                	mv	a2,s2
    8000370e:	4585                	li	a1,1
    80003710:	6c88                	ld	a0,24(s1)
    80003712:	c00ff0ef          	jal	80002b12 <readi>
    80003716:	892a                	mv	s2,a0
    80003718:	00a05563          	blez	a0,80003722 <fileread+0x4e>
      f->off += r;
    8000371c:	509c                	lw	a5,32(s1)
    8000371e:	9fa9                	addw	a5,a5,a0
    80003720:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003722:	6c88                	ld	a0,24(s1)
    80003724:	90aff0ef          	jal	8000282e <iunlock>
    80003728:	64e2                	ld	s1,24(sp)
    8000372a:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000372c:	854a                	mv	a0,s2
    8000372e:	70a2                	ld	ra,40(sp)
    80003730:	7402                	ld	s0,32(sp)
    80003732:	6942                	ld	s2,16(sp)
    80003734:	6145                	addi	sp,sp,48
    80003736:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003738:	6908                	ld	a0,16(a0)
    8000373a:	3b0000ef          	jal	80003aea <piperead>
    8000373e:	892a                	mv	s2,a0
    80003740:	64e2                	ld	s1,24(sp)
    80003742:	69a2                	ld	s3,8(sp)
    80003744:	b7e5                	j	8000372c <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003746:	02451783          	lh	a5,36(a0)
    8000374a:	03079693          	slli	a3,a5,0x30
    8000374e:	92c1                	srli	a3,a3,0x30
    80003750:	4725                	li	a4,9
    80003752:	02d76963          	bltu	a4,a3,80003784 <fileread+0xb0>
    80003756:	0792                	slli	a5,a5,0x4
    80003758:	00015717          	auipc	a4,0x15
    8000375c:	9d070713          	addi	a4,a4,-1584 # 80018128 <devsw>
    80003760:	97ba                	add	a5,a5,a4
    80003762:	639c                	ld	a5,0(a5)
    80003764:	c78d                	beqz	a5,8000378e <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80003766:	4505                	li	a0,1
    80003768:	9782                	jalr	a5
    8000376a:	892a                	mv	s2,a0
    8000376c:	64e2                	ld	s1,24(sp)
    8000376e:	69a2                	ld	s3,8(sp)
    80003770:	bf75                	j	8000372c <fileread+0x58>
    panic("fileread");
    80003772:	00004517          	auipc	a0,0x4
    80003776:	da650513          	addi	a0,a0,-602 # 80007518 <etext+0x518>
    8000377a:	06e020ef          	jal	800057e8 <panic>
    return -1;
    8000377e:	57fd                	li	a5,-1
    80003780:	893e                	mv	s2,a5
    80003782:	b76d                	j	8000372c <fileread+0x58>
      return -1;
    80003784:	57fd                	li	a5,-1
    80003786:	893e                	mv	s2,a5
    80003788:	64e2                	ld	s1,24(sp)
    8000378a:	69a2                	ld	s3,8(sp)
    8000378c:	b745                	j	8000372c <fileread+0x58>
    8000378e:	57fd                	li	a5,-1
    80003790:	893e                	mv	s2,a5
    80003792:	64e2                	ld	s1,24(sp)
    80003794:	69a2                	ld	s3,8(sp)
    80003796:	bf59                	j	8000372c <fileread+0x58>

0000000080003798 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003798:	00954783          	lbu	a5,9(a0)
    8000379c:	10078f63          	beqz	a5,800038ba <filewrite+0x122>
{
    800037a0:	711d                	addi	sp,sp,-96
    800037a2:	ec86                	sd	ra,88(sp)
    800037a4:	e8a2                	sd	s0,80(sp)
    800037a6:	e0ca                	sd	s2,64(sp)
    800037a8:	f456                	sd	s5,40(sp)
    800037aa:	f05a                	sd	s6,32(sp)
    800037ac:	1080                	addi	s0,sp,96
    800037ae:	892a                	mv	s2,a0
    800037b0:	8b2e                	mv	s6,a1
    800037b2:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800037b4:	411c                	lw	a5,0(a0)
    800037b6:	4705                	li	a4,1
    800037b8:	02e78a63          	beq	a5,a4,800037ec <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037bc:	470d                	li	a4,3
    800037be:	02e78b63          	beq	a5,a4,800037f4 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800037c2:	4709                	li	a4,2
    800037c4:	0ce79f63          	bne	a5,a4,800038a2 <filewrite+0x10a>
    800037c8:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800037ca:	0ac05a63          	blez	a2,8000387e <filewrite+0xe6>
    800037ce:	e4a6                	sd	s1,72(sp)
    800037d0:	fc4e                	sd	s3,56(sp)
    800037d2:	ec5e                	sd	s7,24(sp)
    800037d4:	e862                	sd	s8,16(sp)
    800037d6:	e466                	sd	s9,8(sp)
    int i = 0;
    800037d8:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800037da:	6b85                	lui	s7,0x1
    800037dc:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800037e0:	6785                	lui	a5,0x1
    800037e2:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800037e6:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800037e8:	4c05                	li	s8,1
    800037ea:	a8ad                	j	80003864 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800037ec:	6908                	ld	a0,16(a0)
    800037ee:	204000ef          	jal	800039f2 <pipewrite>
    800037f2:	a04d                	j	80003894 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800037f4:	02451783          	lh	a5,36(a0)
    800037f8:	03079693          	slli	a3,a5,0x30
    800037fc:	92c1                	srli	a3,a3,0x30
    800037fe:	4725                	li	a4,9
    80003800:	0ad76f63          	bltu	a4,a3,800038be <filewrite+0x126>
    80003804:	0792                	slli	a5,a5,0x4
    80003806:	00015717          	auipc	a4,0x15
    8000380a:	92270713          	addi	a4,a4,-1758 # 80018128 <devsw>
    8000380e:	97ba                	add	a5,a5,a4
    80003810:	679c                	ld	a5,8(a5)
    80003812:	cbc5                	beqz	a5,800038c2 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80003814:	4505                	li	a0,1
    80003816:	9782                	jalr	a5
    80003818:	a8b5                	j	80003894 <filewrite+0xfc>
      if(n1 > max)
    8000381a:	2981                	sext.w	s3,s3
      begin_op();
    8000381c:	971ff0ef          	jal	8000318c <begin_op>
      ilock(f->ip);
    80003820:	01893503          	ld	a0,24(s2)
    80003824:	f5dfe0ef          	jal	80002780 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003828:	874e                	mv	a4,s3
    8000382a:	02092683          	lw	a3,32(s2)
    8000382e:	016a0633          	add	a2,s4,s6
    80003832:	85e2                	mv	a1,s8
    80003834:	01893503          	ld	a0,24(s2)
    80003838:	bccff0ef          	jal	80002c04 <writei>
    8000383c:	84aa                	mv	s1,a0
    8000383e:	00a05763          	blez	a0,8000384c <filewrite+0xb4>
        f->off += r;
    80003842:	02092783          	lw	a5,32(s2)
    80003846:	9fa9                	addw	a5,a5,a0
    80003848:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000384c:	01893503          	ld	a0,24(s2)
    80003850:	fdffe0ef          	jal	8000282e <iunlock>
      end_op();
    80003854:	9a9ff0ef          	jal	800031fc <end_op>

      if(r != n1){
    80003858:	02999563          	bne	s3,s1,80003882 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    8000385c:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003860:	015a5963          	bge	s4,s5,80003872 <filewrite+0xda>
      int n1 = n - i;
    80003864:	414a87bb          	subw	a5,s5,s4
    80003868:	89be                	mv	s3,a5
      if(n1 > max)
    8000386a:	fafbd8e3          	bge	s7,a5,8000381a <filewrite+0x82>
    8000386e:	89e6                	mv	s3,s9
    80003870:	b76d                	j	8000381a <filewrite+0x82>
    80003872:	64a6                	ld	s1,72(sp)
    80003874:	79e2                	ld	s3,56(sp)
    80003876:	6be2                	ld	s7,24(sp)
    80003878:	6c42                	ld	s8,16(sp)
    8000387a:	6ca2                	ld	s9,8(sp)
    8000387c:	a801                	j	8000388c <filewrite+0xf4>
    int i = 0;
    8000387e:	4a01                	li	s4,0
    80003880:	a031                	j	8000388c <filewrite+0xf4>
    80003882:	64a6                	ld	s1,72(sp)
    80003884:	79e2                	ld	s3,56(sp)
    80003886:	6be2                	ld	s7,24(sp)
    80003888:	6c42                	ld	s8,16(sp)
    8000388a:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    8000388c:	034a9d63          	bne	s5,s4,800038c6 <filewrite+0x12e>
    80003890:	8556                	mv	a0,s5
    80003892:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003894:	60e6                	ld	ra,88(sp)
    80003896:	6446                	ld	s0,80(sp)
    80003898:	6906                	ld	s2,64(sp)
    8000389a:	7aa2                	ld	s5,40(sp)
    8000389c:	7b02                	ld	s6,32(sp)
    8000389e:	6125                	addi	sp,sp,96
    800038a0:	8082                	ret
    800038a2:	e4a6                	sd	s1,72(sp)
    800038a4:	fc4e                	sd	s3,56(sp)
    800038a6:	f852                	sd	s4,48(sp)
    800038a8:	ec5e                	sd	s7,24(sp)
    800038aa:	e862                	sd	s8,16(sp)
    800038ac:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800038ae:	00004517          	auipc	a0,0x4
    800038b2:	c7a50513          	addi	a0,a0,-902 # 80007528 <etext+0x528>
    800038b6:	733010ef          	jal	800057e8 <panic>
    return -1;
    800038ba:	557d                	li	a0,-1
}
    800038bc:	8082                	ret
      return -1;
    800038be:	557d                	li	a0,-1
    800038c0:	bfd1                	j	80003894 <filewrite+0xfc>
    800038c2:	557d                	li	a0,-1
    800038c4:	bfc1                	j	80003894 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800038c6:	557d                	li	a0,-1
    800038c8:	7a42                	ld	s4,48(sp)
    800038ca:	b7e9                	j	80003894 <filewrite+0xfc>

00000000800038cc <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800038cc:	7179                	addi	sp,sp,-48
    800038ce:	f406                	sd	ra,40(sp)
    800038d0:	f022                	sd	s0,32(sp)
    800038d2:	ec26                	sd	s1,24(sp)
    800038d4:	e052                	sd	s4,0(sp)
    800038d6:	1800                	addi	s0,sp,48
    800038d8:	84aa                	mv	s1,a0
    800038da:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800038dc:	0005b023          	sd	zero,0(a1)
    800038e0:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800038e4:	c29ff0ef          	jal	8000350c <filealloc>
    800038e8:	e088                	sd	a0,0(s1)
    800038ea:	c549                	beqz	a0,80003974 <pipealloc+0xa8>
    800038ec:	c21ff0ef          	jal	8000350c <filealloc>
    800038f0:	00aa3023          	sd	a0,0(s4)
    800038f4:	cd25                	beqz	a0,8000396c <pipealloc+0xa0>
    800038f6:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800038f8:	80dfc0ef          	jal	80000104 <kalloc>
    800038fc:	892a                	mv	s2,a0
    800038fe:	c12d                	beqz	a0,80003960 <pipealloc+0x94>
    80003900:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003902:	4985                	li	s3,1
    80003904:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003908:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000390c:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003910:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003914:	00004597          	auipc	a1,0x4
    80003918:	c2458593          	addi	a1,a1,-988 # 80007538 <etext+0x538>
    8000391c:	0e4020ef          	jal	80005a00 <initlock>
  (*f0)->type = FD_PIPE;
    80003920:	609c                	ld	a5,0(s1)
    80003922:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003926:	609c                	ld	a5,0(s1)
    80003928:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000392c:	609c                	ld	a5,0(s1)
    8000392e:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003932:	609c                	ld	a5,0(s1)
    80003934:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003938:	000a3783          	ld	a5,0(s4)
    8000393c:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003940:	000a3783          	ld	a5,0(s4)
    80003944:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003948:	000a3783          	ld	a5,0(s4)
    8000394c:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003950:	000a3783          	ld	a5,0(s4)
    80003954:	0127b823          	sd	s2,16(a5)
  return 0;
    80003958:	4501                	li	a0,0
    8000395a:	6942                	ld	s2,16(sp)
    8000395c:	69a2                	ld	s3,8(sp)
    8000395e:	a01d                	j	80003984 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003960:	6088                	ld	a0,0(s1)
    80003962:	c119                	beqz	a0,80003968 <pipealloc+0x9c>
    80003964:	6942                	ld	s2,16(sp)
    80003966:	a029                	j	80003970 <pipealloc+0xa4>
    80003968:	6942                	ld	s2,16(sp)
    8000396a:	a029                	j	80003974 <pipealloc+0xa8>
    8000396c:	6088                	ld	a0,0(s1)
    8000396e:	c10d                	beqz	a0,80003990 <pipealloc+0xc4>
    fileclose(*f0);
    80003970:	c41ff0ef          	jal	800035b0 <fileclose>
  if(*f1)
    80003974:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003978:	557d                	li	a0,-1
  if(*f1)
    8000397a:	c789                	beqz	a5,80003984 <pipealloc+0xb8>
    fileclose(*f1);
    8000397c:	853e                	mv	a0,a5
    8000397e:	c33ff0ef          	jal	800035b0 <fileclose>
  return -1;
    80003982:	557d                	li	a0,-1
}
    80003984:	70a2                	ld	ra,40(sp)
    80003986:	7402                	ld	s0,32(sp)
    80003988:	64e2                	ld	s1,24(sp)
    8000398a:	6a02                	ld	s4,0(sp)
    8000398c:	6145                	addi	sp,sp,48
    8000398e:	8082                	ret
  return -1;
    80003990:	557d                	li	a0,-1
    80003992:	bfcd                	j	80003984 <pipealloc+0xb8>

0000000080003994 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003994:	1101                	addi	sp,sp,-32
    80003996:	ec06                	sd	ra,24(sp)
    80003998:	e822                	sd	s0,16(sp)
    8000399a:	e426                	sd	s1,8(sp)
    8000399c:	e04a                	sd	s2,0(sp)
    8000399e:	1000                	addi	s0,sp,32
    800039a0:	84aa                	mv	s1,a0
    800039a2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800039a4:	0e6020ef          	jal	80005a8a <acquire>
  if(writable){
    800039a8:	02090763          	beqz	s2,800039d6 <pipeclose+0x42>
    pi->writeopen = 0;
    800039ac:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800039b0:	21848513          	addi	a0,s1,536
    800039b4:	a95fd0ef          	jal	80001448 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800039b8:	2204a783          	lw	a5,544(s1)
    800039bc:	e781                	bnez	a5,800039c4 <pipeclose+0x30>
    800039be:	2244a783          	lw	a5,548(s1)
    800039c2:	c38d                	beqz	a5,800039e4 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800039c4:	8526                	mv	a0,s1
    800039c6:	158020ef          	jal	80005b1e <release>
}
    800039ca:	60e2                	ld	ra,24(sp)
    800039cc:	6442                	ld	s0,16(sp)
    800039ce:	64a2                	ld	s1,8(sp)
    800039d0:	6902                	ld	s2,0(sp)
    800039d2:	6105                	addi	sp,sp,32
    800039d4:	8082                	ret
    pi->readopen = 0;
    800039d6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800039da:	21c48513          	addi	a0,s1,540
    800039de:	a6bfd0ef          	jal	80001448 <wakeup>
    800039e2:	bfd9                	j	800039b8 <pipeclose+0x24>
    release(&pi->lock);
    800039e4:	8526                	mv	a0,s1
    800039e6:	138020ef          	jal	80005b1e <release>
    kfree((char*)pi);
    800039ea:	8526                	mv	a0,s1
    800039ec:	e30fc0ef          	jal	8000001c <kfree>
    800039f0:	bfe9                	j	800039ca <pipeclose+0x36>

00000000800039f2 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800039f2:	7159                	addi	sp,sp,-112
    800039f4:	f486                	sd	ra,104(sp)
    800039f6:	f0a2                	sd	s0,96(sp)
    800039f8:	eca6                	sd	s1,88(sp)
    800039fa:	e8ca                	sd	s2,80(sp)
    800039fc:	e4ce                	sd	s3,72(sp)
    800039fe:	e0d2                	sd	s4,64(sp)
    80003a00:	fc56                	sd	s5,56(sp)
    80003a02:	1880                	addi	s0,sp,112
    80003a04:	84aa                	mv	s1,a0
    80003a06:	8aae                	mv	s5,a1
    80003a08:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003a0a:	b7efd0ef          	jal	80000d88 <myproc>
    80003a0e:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003a10:	8526                	mv	a0,s1
    80003a12:	078020ef          	jal	80005a8a <acquire>
  while(i < n){
    80003a16:	0d405263          	blez	s4,80003ada <pipewrite+0xe8>
    80003a1a:	f85a                	sd	s6,48(sp)
    80003a1c:	f45e                	sd	s7,40(sp)
    80003a1e:	f062                	sd	s8,32(sp)
    80003a20:	ec66                	sd	s9,24(sp)
    80003a22:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003a24:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a26:	f9f40c13          	addi	s8,s0,-97
    80003a2a:	4b85                	li	s7,1
    80003a2c:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003a2e:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003a32:	21c48c93          	addi	s9,s1,540
    80003a36:	a82d                	j	80003a70 <pipewrite+0x7e>
      release(&pi->lock);
    80003a38:	8526                	mv	a0,s1
    80003a3a:	0e4020ef          	jal	80005b1e <release>
      return -1;
    80003a3e:	597d                	li	s2,-1
    80003a40:	7b42                	ld	s6,48(sp)
    80003a42:	7ba2                	ld	s7,40(sp)
    80003a44:	7c02                	ld	s8,32(sp)
    80003a46:	6ce2                	ld	s9,24(sp)
    80003a48:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003a4a:	854a                	mv	a0,s2
    80003a4c:	70a6                	ld	ra,104(sp)
    80003a4e:	7406                	ld	s0,96(sp)
    80003a50:	64e6                	ld	s1,88(sp)
    80003a52:	6946                	ld	s2,80(sp)
    80003a54:	69a6                	ld	s3,72(sp)
    80003a56:	6a06                	ld	s4,64(sp)
    80003a58:	7ae2                	ld	s5,56(sp)
    80003a5a:	6165                	addi	sp,sp,112
    80003a5c:	8082                	ret
      wakeup(&pi->nread);
    80003a5e:	856a                	mv	a0,s10
    80003a60:	9e9fd0ef          	jal	80001448 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003a64:	85a6                	mv	a1,s1
    80003a66:	8566                	mv	a0,s9
    80003a68:	995fd0ef          	jal	800013fc <sleep>
  while(i < n){
    80003a6c:	05495a63          	bge	s2,s4,80003ac0 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003a70:	2204a783          	lw	a5,544(s1)
    80003a74:	d3f1                	beqz	a5,80003a38 <pipewrite+0x46>
    80003a76:	854e                	mv	a0,s3
    80003a78:	bc1fd0ef          	jal	80001638 <killed>
    80003a7c:	fd55                	bnez	a0,80003a38 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003a7e:	2184a783          	lw	a5,536(s1)
    80003a82:	21c4a703          	lw	a4,540(s1)
    80003a86:	2007879b          	addiw	a5,a5,512
    80003a8a:	fcf70ae3          	beq	a4,a5,80003a5e <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a8e:	86de                	mv	a3,s7
    80003a90:	01590633          	add	a2,s2,s5
    80003a94:	85e2                	mv	a1,s8
    80003a96:	0509b503          	ld	a0,80(s3)
    80003a9a:	8defd0ef          	jal	80000b78 <copyin>
    80003a9e:	05650063          	beq	a0,s6,80003ade <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003aa2:	21c4a783          	lw	a5,540(s1)
    80003aa6:	0017871b          	addiw	a4,a5,1
    80003aaa:	20e4ae23          	sw	a4,540(s1)
    80003aae:	1ff7f793          	andi	a5,a5,511
    80003ab2:	97a6                	add	a5,a5,s1
    80003ab4:	f9f44703          	lbu	a4,-97(s0)
    80003ab8:	00e78c23          	sb	a4,24(a5)
      i++;
    80003abc:	2905                	addiw	s2,s2,1
    80003abe:	b77d                	j	80003a6c <pipewrite+0x7a>
    80003ac0:	7b42                	ld	s6,48(sp)
    80003ac2:	7ba2                	ld	s7,40(sp)
    80003ac4:	7c02                	ld	s8,32(sp)
    80003ac6:	6ce2                	ld	s9,24(sp)
    80003ac8:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003aca:	21848513          	addi	a0,s1,536
    80003ace:	97bfd0ef          	jal	80001448 <wakeup>
  release(&pi->lock);
    80003ad2:	8526                	mv	a0,s1
    80003ad4:	04a020ef          	jal	80005b1e <release>
  return i;
    80003ad8:	bf8d                	j	80003a4a <pipewrite+0x58>
  int i = 0;
    80003ada:	4901                	li	s2,0
    80003adc:	b7fd                	j	80003aca <pipewrite+0xd8>
    80003ade:	7b42                	ld	s6,48(sp)
    80003ae0:	7ba2                	ld	s7,40(sp)
    80003ae2:	7c02                	ld	s8,32(sp)
    80003ae4:	6ce2                	ld	s9,24(sp)
    80003ae6:	6d42                	ld	s10,16(sp)
    80003ae8:	b7cd                	j	80003aca <pipewrite+0xd8>

0000000080003aea <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003aea:	711d                	addi	sp,sp,-96
    80003aec:	ec86                	sd	ra,88(sp)
    80003aee:	e8a2                	sd	s0,80(sp)
    80003af0:	e4a6                	sd	s1,72(sp)
    80003af2:	e0ca                	sd	s2,64(sp)
    80003af4:	fc4e                	sd	s3,56(sp)
    80003af6:	f852                	sd	s4,48(sp)
    80003af8:	f456                	sd	s5,40(sp)
    80003afa:	1080                	addi	s0,sp,96
    80003afc:	84aa                	mv	s1,a0
    80003afe:	892e                	mv	s2,a1
    80003b00:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003b02:	a86fd0ef          	jal	80000d88 <myproc>
    80003b06:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003b08:	8526                	mv	a0,s1
    80003b0a:	781010ef          	jal	80005a8a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b0e:	2184a703          	lw	a4,536(s1)
    80003b12:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b16:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b1a:	02f71763          	bne	a4,a5,80003b48 <piperead+0x5e>
    80003b1e:	2244a783          	lw	a5,548(s1)
    80003b22:	cf85                	beqz	a5,80003b5a <piperead+0x70>
    if(killed(pr)){
    80003b24:	8552                	mv	a0,s4
    80003b26:	b13fd0ef          	jal	80001638 <killed>
    80003b2a:	e11d                	bnez	a0,80003b50 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b2c:	85a6                	mv	a1,s1
    80003b2e:	854e                	mv	a0,s3
    80003b30:	8cdfd0ef          	jal	800013fc <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b34:	2184a703          	lw	a4,536(s1)
    80003b38:	21c4a783          	lw	a5,540(s1)
    80003b3c:	fef701e3          	beq	a4,a5,80003b1e <piperead+0x34>
    80003b40:	f05a                	sd	s6,32(sp)
    80003b42:	ec5e                	sd	s7,24(sp)
    80003b44:	e862                	sd	s8,16(sp)
    80003b46:	a829                	j	80003b60 <piperead+0x76>
    80003b48:	f05a                	sd	s6,32(sp)
    80003b4a:	ec5e                	sd	s7,24(sp)
    80003b4c:	e862                	sd	s8,16(sp)
    80003b4e:	a809                	j	80003b60 <piperead+0x76>
      release(&pi->lock);
    80003b50:	8526                	mv	a0,s1
    80003b52:	7cd010ef          	jal	80005b1e <release>
      return -1;
    80003b56:	59fd                	li	s3,-1
    80003b58:	a09d                	j	80003bbe <piperead+0xd4>
    80003b5a:	f05a                	sd	s6,32(sp)
    80003b5c:	ec5e                	sd	s7,24(sp)
    80003b5e:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b60:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b62:	faf40c13          	addi	s8,s0,-81
    80003b66:	4b85                	li	s7,1
    80003b68:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b6a:	05505063          	blez	s5,80003baa <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003b6e:	2184a783          	lw	a5,536(s1)
    80003b72:	21c4a703          	lw	a4,540(s1)
    80003b76:	02f70a63          	beq	a4,a5,80003baa <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003b7a:	0017871b          	addiw	a4,a5,1
    80003b7e:	20e4ac23          	sw	a4,536(s1)
    80003b82:	1ff7f793          	andi	a5,a5,511
    80003b86:	97a6                	add	a5,a5,s1
    80003b88:	0187c783          	lbu	a5,24(a5)
    80003b8c:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b90:	86de                	mv	a3,s7
    80003b92:	8662                	mv	a2,s8
    80003b94:	85ca                	mv	a1,s2
    80003b96:	050a3503          	ld	a0,80(s4)
    80003b9a:	f21fc0ef          	jal	80000aba <copyout>
    80003b9e:	01650663          	beq	a0,s6,80003baa <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ba2:	2985                	addiw	s3,s3,1
    80003ba4:	0905                	addi	s2,s2,1
    80003ba6:	fd3a94e3          	bne	s5,s3,80003b6e <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003baa:	21c48513          	addi	a0,s1,540
    80003bae:	89bfd0ef          	jal	80001448 <wakeup>
  release(&pi->lock);
    80003bb2:	8526                	mv	a0,s1
    80003bb4:	76b010ef          	jal	80005b1e <release>
    80003bb8:	7b02                	ld	s6,32(sp)
    80003bba:	6be2                	ld	s7,24(sp)
    80003bbc:	6c42                	ld	s8,16(sp)
  return i;
}
    80003bbe:	854e                	mv	a0,s3
    80003bc0:	60e6                	ld	ra,88(sp)
    80003bc2:	6446                	ld	s0,80(sp)
    80003bc4:	64a6                	ld	s1,72(sp)
    80003bc6:	6906                	ld	s2,64(sp)
    80003bc8:	79e2                	ld	s3,56(sp)
    80003bca:	7a42                	ld	s4,48(sp)
    80003bcc:	7aa2                	ld	s5,40(sp)
    80003bce:	6125                	addi	sp,sp,96
    80003bd0:	8082                	ret

0000000080003bd2 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003bd2:	1141                	addi	sp,sp,-16
    80003bd4:	e406                	sd	ra,8(sp)
    80003bd6:	e022                	sd	s0,0(sp)
    80003bd8:	0800                	addi	s0,sp,16
    80003bda:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003bdc:	0035151b          	slliw	a0,a0,0x3
    80003be0:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003be2:	8b89                	andi	a5,a5,2
    80003be4:	c399                	beqz	a5,80003bea <flags2perm+0x18>
      perm |= PTE_W;
    80003be6:	00456513          	ori	a0,a0,4
    return perm;
}
    80003bea:	60a2                	ld	ra,8(sp)
    80003bec:	6402                	ld	s0,0(sp)
    80003bee:	0141                	addi	sp,sp,16
    80003bf0:	8082                	ret

0000000080003bf2 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003bf2:	de010113          	addi	sp,sp,-544
    80003bf6:	20113c23          	sd	ra,536(sp)
    80003bfa:	20813823          	sd	s0,528(sp)
    80003bfe:	20913423          	sd	s1,520(sp)
    80003c02:	21213023          	sd	s2,512(sp)
    80003c06:	1400                	addi	s0,sp,544
    80003c08:	892a                	mv	s2,a0
    80003c0a:	dea43823          	sd	a0,-528(s0)
    80003c0e:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003c12:	976fd0ef          	jal	80000d88 <myproc>
    80003c16:	84aa                	mv	s1,a0

  begin_op();
    80003c18:	d74ff0ef          	jal	8000318c <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003c1c:	854a                	mv	a0,s2
    80003c1e:	b90ff0ef          	jal	80002fae <namei>
    80003c22:	cd21                	beqz	a0,80003c7a <kexec+0x88>
    80003c24:	fbd2                	sd	s4,496(sp)
    80003c26:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003c28:	b59fe0ef          	jal	80002780 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003c2c:	04000713          	li	a4,64
    80003c30:	4681                	li	a3,0
    80003c32:	e5040613          	addi	a2,s0,-432
    80003c36:	4581                	li	a1,0
    80003c38:	8552                	mv	a0,s4
    80003c3a:	ed9fe0ef          	jal	80002b12 <readi>
    80003c3e:	04000793          	li	a5,64
    80003c42:	00f51a63          	bne	a0,a5,80003c56 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003c46:	e5042703          	lw	a4,-432(s0)
    80003c4a:	464c47b7          	lui	a5,0x464c4
    80003c4e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003c52:	02f70863          	beq	a4,a5,80003c82 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003c56:	8552                	mv	a0,s4
    80003c58:	d35fe0ef          	jal	8000298c <iunlockput>
    end_op();
    80003c5c:	da0ff0ef          	jal	800031fc <end_op>
  }
  return -1;
    80003c60:	557d                	li	a0,-1
    80003c62:	7a5e                	ld	s4,496(sp)
}
    80003c64:	21813083          	ld	ra,536(sp)
    80003c68:	21013403          	ld	s0,528(sp)
    80003c6c:	20813483          	ld	s1,520(sp)
    80003c70:	20013903          	ld	s2,512(sp)
    80003c74:	22010113          	addi	sp,sp,544
    80003c78:	8082                	ret
    end_op();
    80003c7a:	d82ff0ef          	jal	800031fc <end_op>
    return -1;
    80003c7e:	557d                	li	a0,-1
    80003c80:	b7d5                	j	80003c64 <kexec+0x72>
    80003c82:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003c84:	8526                	mv	a0,s1
    80003c86:	a0cfd0ef          	jal	80000e92 <proc_pagetable>
    80003c8a:	8b2a                	mv	s6,a0
    80003c8c:	26050f63          	beqz	a0,80003f0a <kexec+0x318>
    80003c90:	ffce                	sd	s3,504(sp)
    80003c92:	f7d6                	sd	s5,488(sp)
    80003c94:	efde                	sd	s7,472(sp)
    80003c96:	ebe2                	sd	s8,464(sp)
    80003c98:	e7e6                	sd	s9,456(sp)
    80003c9a:	e3ea                	sd	s10,448(sp)
    80003c9c:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c9e:	e8845783          	lhu	a5,-376(s0)
    80003ca2:	0e078963          	beqz	a5,80003d94 <kexec+0x1a2>
    80003ca6:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003caa:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cac:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003cae:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003cb2:	6c85                	lui	s9,0x1
    80003cb4:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003cb8:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003cbc:	6a85                	lui	s5,0x1
    80003cbe:	a085                	j	80003d1e <kexec+0x12c>
      panic("loadseg: address should exist");
    80003cc0:	00004517          	auipc	a0,0x4
    80003cc4:	88050513          	addi	a0,a0,-1920 # 80007540 <etext+0x540>
    80003cc8:	321010ef          	jal	800057e8 <panic>
    if(sz - i < PGSIZE)
    80003ccc:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003cce:	874a                	mv	a4,s2
    80003cd0:	009b86bb          	addw	a3,s7,s1
    80003cd4:	4581                	li	a1,0
    80003cd6:	8552                	mv	a0,s4
    80003cd8:	e3bfe0ef          	jal	80002b12 <readi>
    80003cdc:	22a91b63          	bne	s2,a0,80003f12 <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80003ce0:	009a84bb          	addw	s1,s5,s1
    80003ce4:	0334f263          	bgeu	s1,s3,80003d08 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003ce8:	02049593          	slli	a1,s1,0x20
    80003cec:	9181                	srli	a1,a1,0x20
    80003cee:	95e2                	add	a1,a1,s8
    80003cf0:	855a                	mv	a0,s6
    80003cf2:	f9afc0ef          	jal	8000048c <walkaddr>
    80003cf6:	862a                	mv	a2,a0
    if(pa == 0)
    80003cf8:	d561                	beqz	a0,80003cc0 <kexec+0xce>
    if(sz - i < PGSIZE)
    80003cfa:	409987bb          	subw	a5,s3,s1
    80003cfe:	893e                	mv	s2,a5
    80003d00:	fcfcf6e3          	bgeu	s9,a5,80003ccc <kexec+0xda>
    80003d04:	8956                	mv	s2,s5
    80003d06:	b7d9                	j	80003ccc <kexec+0xda>
    sz = sz1;
    80003d08:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d0c:	2d05                	addiw	s10,s10,1
    80003d0e:	e0843783          	ld	a5,-504(s0)
    80003d12:	0387869b          	addiw	a3,a5,56
    80003d16:	e8845783          	lhu	a5,-376(s0)
    80003d1a:	06fd5e63          	bge	s10,a5,80003d96 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d1e:	e0d43423          	sd	a3,-504(s0)
    80003d22:	876e                	mv	a4,s11
    80003d24:	e1840613          	addi	a2,s0,-488
    80003d28:	4581                	li	a1,0
    80003d2a:	8552                	mv	a0,s4
    80003d2c:	de7fe0ef          	jal	80002b12 <readi>
    80003d30:	1db51f63          	bne	a0,s11,80003f0e <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80003d34:	e1842783          	lw	a5,-488(s0)
    80003d38:	4705                	li	a4,1
    80003d3a:	fce799e3          	bne	a5,a4,80003d0c <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003d3e:	e4043483          	ld	s1,-448(s0)
    80003d42:	e3843783          	ld	a5,-456(s0)
    80003d46:	1ef4e463          	bltu	s1,a5,80003f2e <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d4a:	e2843783          	ld	a5,-472(s0)
    80003d4e:	94be                	add	s1,s1,a5
    80003d50:	1ef4e263          	bltu	s1,a5,80003f34 <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80003d54:	de843703          	ld	a4,-536(s0)
    80003d58:	8ff9                	and	a5,a5,a4
    80003d5a:	1e079063          	bnez	a5,80003f3a <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d5e:	e1c42503          	lw	a0,-484(s0)
    80003d62:	e71ff0ef          	jal	80003bd2 <flags2perm>
    80003d66:	86aa                	mv	a3,a0
    80003d68:	8626                	mv	a2,s1
    80003d6a:	85ca                	mv	a1,s2
    80003d6c:	855a                	mv	a0,s6
    80003d6e:	9f5fc0ef          	jal	80000762 <uvmalloc>
    80003d72:	dea43c23          	sd	a0,-520(s0)
    80003d76:	1c050563          	beqz	a0,80003f40 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d7a:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d7e:	00098863          	beqz	s3,80003d8e <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d82:	e2843c03          	ld	s8,-472(s0)
    80003d86:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d8a:	4481                	li	s1,0
    80003d8c:	bfb1                	j	80003ce8 <kexec+0xf6>
    sz = sz1;
    80003d8e:	df843903          	ld	s2,-520(s0)
    80003d92:	bfad                	j	80003d0c <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d94:	4901                	li	s2,0
  iunlockput(ip);
    80003d96:	8552                	mv	a0,s4
    80003d98:	bf5fe0ef          	jal	8000298c <iunlockput>
  end_op();
    80003d9c:	c60ff0ef          	jal	800031fc <end_op>
  p = myproc();
    80003da0:	fe9fc0ef          	jal	80000d88 <myproc>
    80003da4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003da6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003daa:	6985                	lui	s3,0x1
    80003dac:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003dae:	99ca                	add	s3,s3,s2
    80003db0:	77fd                	lui	a5,0xfffff
    80003db2:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003db6:	4691                	li	a3,4
    80003db8:	6609                	lui	a2,0x2
    80003dba:	964e                	add	a2,a2,s3
    80003dbc:	85ce                	mv	a1,s3
    80003dbe:	855a                	mv	a0,s6
    80003dc0:	9a3fc0ef          	jal	80000762 <uvmalloc>
    80003dc4:	8a2a                	mv	s4,a0
    80003dc6:	e105                	bnez	a0,80003de6 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003dc8:	85ce                	mv	a1,s3
    80003dca:	855a                	mv	a0,s6
    80003dcc:	94afd0ef          	jal	80000f16 <proc_freepagetable>
  return -1;
    80003dd0:	557d                	li	a0,-1
    80003dd2:	79fe                	ld	s3,504(sp)
    80003dd4:	7a5e                	ld	s4,496(sp)
    80003dd6:	7abe                	ld	s5,488(sp)
    80003dd8:	7b1e                	ld	s6,480(sp)
    80003dda:	6bfe                	ld	s7,472(sp)
    80003ddc:	6c5e                	ld	s8,464(sp)
    80003dde:	6cbe                	ld	s9,456(sp)
    80003de0:	6d1e                	ld	s10,448(sp)
    80003de2:	7dfa                	ld	s11,440(sp)
    80003de4:	b541                	j	80003c64 <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003de6:	75f9                	lui	a1,0xffffe
    80003de8:	95aa                	add	a1,a1,a0
    80003dea:	855a                	mv	a0,s6
    80003dec:	b49fc0ef          	jal	80000934 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003df0:	800a0b93          	addi	s7,s4,-2048
    80003df4:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80003df8:	e0043783          	ld	a5,-512(s0)
    80003dfc:	6388                	ld	a0,0(a5)
  sp = sz;
    80003dfe:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003e00:	4481                	li	s1,0
    ustack[argc] = sp;
    80003e02:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003e06:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003e0a:	cd21                	beqz	a0,80003e62 <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80003e0c:	cdcfc0ef          	jal	800002e8 <strlen>
    80003e10:	0015079b          	addiw	a5,a0,1
    80003e14:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e18:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003e1c:	13796563          	bltu	s2,s7,80003f46 <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003e20:	e0043d83          	ld	s11,-512(s0)
    80003e24:	000db983          	ld	s3,0(s11)
    80003e28:	854e                	mv	a0,s3
    80003e2a:	cbefc0ef          	jal	800002e8 <strlen>
    80003e2e:	0015069b          	addiw	a3,a0,1
    80003e32:	864e                	mv	a2,s3
    80003e34:	85ca                	mv	a1,s2
    80003e36:	855a                	mv	a0,s6
    80003e38:	c83fc0ef          	jal	80000aba <copyout>
    80003e3c:	10054763          	bltz	a0,80003f4a <kexec+0x358>
    ustack[argc] = sp;
    80003e40:	00349793          	slli	a5,s1,0x3
    80003e44:	97e6                	add	a5,a5,s9
    80003e46:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffddc68>
  for(argc = 0; argv[argc]; argc++) {
    80003e4a:	0485                	addi	s1,s1,1
    80003e4c:	008d8793          	addi	a5,s11,8
    80003e50:	e0f43023          	sd	a5,-512(s0)
    80003e54:	008db503          	ld	a0,8(s11)
    80003e58:	c509                	beqz	a0,80003e62 <kexec+0x270>
    if(argc >= MAXARG)
    80003e5a:	fb8499e3          	bne	s1,s8,80003e0c <kexec+0x21a>
  sz = sz1;
    80003e5e:	89d2                	mv	s3,s4
    80003e60:	b7a5                	j	80003dc8 <kexec+0x1d6>
  ustack[argc] = 0;
    80003e62:	00349793          	slli	a5,s1,0x3
    80003e66:	f9078793          	addi	a5,a5,-112
    80003e6a:	97a2                	add	a5,a5,s0
    80003e6c:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e70:	00349693          	slli	a3,s1,0x3
    80003e74:	06a1                	addi	a3,a3,8
    80003e76:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e7a:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e7e:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003e80:	f57964e3          	bltu	s2,s7,80003dc8 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e84:	e9040613          	addi	a2,s0,-368
    80003e88:	85ca                	mv	a1,s2
    80003e8a:	855a                	mv	a0,s6
    80003e8c:	c2ffc0ef          	jal	80000aba <copyout>
    80003e90:	f2054ce3          	bltz	a0,80003dc8 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80003e94:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003e98:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003e9c:	df043783          	ld	a5,-528(s0)
    80003ea0:	0007c703          	lbu	a4,0(a5)
    80003ea4:	cf11                	beqz	a4,80003ec0 <kexec+0x2ce>
    80003ea6:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003ea8:	02f00693          	li	a3,47
    80003eac:	a029                	j	80003eb6 <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80003eae:	0785                	addi	a5,a5,1
    80003eb0:	fff7c703          	lbu	a4,-1(a5)
    80003eb4:	c711                	beqz	a4,80003ec0 <kexec+0x2ce>
    if(*s == '/')
    80003eb6:	fed71ce3          	bne	a4,a3,80003eae <kexec+0x2bc>
      last = s+1;
    80003eba:	def43823          	sd	a5,-528(s0)
    80003ebe:	bfc5                	j	80003eae <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80003ec0:	4641                	li	a2,16
    80003ec2:	df043583          	ld	a1,-528(s0)
    80003ec6:	158a8513          	addi	a0,s5,344
    80003eca:	be8fc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003ece:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003ed2:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003ed6:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80003eda:	058ab783          	ld	a5,88(s5)
    80003ede:	e6843703          	ld	a4,-408(s0)
    80003ee2:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003ee4:	058ab783          	ld	a5,88(s5)
    80003ee8:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003eec:	85ea                	mv	a1,s10
    80003eee:	828fd0ef          	jal	80000f16 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003ef2:	0004851b          	sext.w	a0,s1
    80003ef6:	79fe                	ld	s3,504(sp)
    80003ef8:	7a5e                	ld	s4,496(sp)
    80003efa:	7abe                	ld	s5,488(sp)
    80003efc:	7b1e                	ld	s6,480(sp)
    80003efe:	6bfe                	ld	s7,472(sp)
    80003f00:	6c5e                	ld	s8,464(sp)
    80003f02:	6cbe                	ld	s9,456(sp)
    80003f04:	6d1e                	ld	s10,448(sp)
    80003f06:	7dfa                	ld	s11,440(sp)
    80003f08:	bbb1                	j	80003c64 <kexec+0x72>
    80003f0a:	7b1e                	ld	s6,480(sp)
    80003f0c:	b3a9                	j	80003c56 <kexec+0x64>
    80003f0e:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003f12:	df843583          	ld	a1,-520(s0)
    80003f16:	855a                	mv	a0,s6
    80003f18:	ffffc0ef          	jal	80000f16 <proc_freepagetable>
  if(ip){
    80003f1c:	79fe                	ld	s3,504(sp)
    80003f1e:	7abe                	ld	s5,488(sp)
    80003f20:	7b1e                	ld	s6,480(sp)
    80003f22:	6bfe                	ld	s7,472(sp)
    80003f24:	6c5e                	ld	s8,464(sp)
    80003f26:	6cbe                	ld	s9,456(sp)
    80003f28:	6d1e                	ld	s10,448(sp)
    80003f2a:	7dfa                	ld	s11,440(sp)
    80003f2c:	b32d                	j	80003c56 <kexec+0x64>
    80003f2e:	df243c23          	sd	s2,-520(s0)
    80003f32:	b7c5                	j	80003f12 <kexec+0x320>
    80003f34:	df243c23          	sd	s2,-520(s0)
    80003f38:	bfe9                	j	80003f12 <kexec+0x320>
    80003f3a:	df243c23          	sd	s2,-520(s0)
    80003f3e:	bfd1                	j	80003f12 <kexec+0x320>
    80003f40:	df243c23          	sd	s2,-520(s0)
    80003f44:	b7f9                	j	80003f12 <kexec+0x320>
  sz = sz1;
    80003f46:	89d2                	mv	s3,s4
    80003f48:	b541                	j	80003dc8 <kexec+0x1d6>
    80003f4a:	89d2                	mv	s3,s4
    80003f4c:	bdb5                	j	80003dc8 <kexec+0x1d6>

0000000080003f4e <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f4e:	7179                	addi	sp,sp,-48
    80003f50:	f406                	sd	ra,40(sp)
    80003f52:	f022                	sd	s0,32(sp)
    80003f54:	ec26                	sd	s1,24(sp)
    80003f56:	e84a                	sd	s2,16(sp)
    80003f58:	1800                	addi	s0,sp,48
    80003f5a:	892e                	mv	s2,a1
    80003f5c:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f5e:	fdc40593          	addi	a1,s0,-36
    80003f62:	de3fd0ef          	jal	80001d44 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f66:	fdc42703          	lw	a4,-36(s0)
    80003f6a:	47bd                	li	a5,15
    80003f6c:	02e7ea63          	bltu	a5,a4,80003fa0 <argfd+0x52>
    80003f70:	e19fc0ef          	jal	80000d88 <myproc>
    80003f74:	fdc42703          	lw	a4,-36(s0)
    80003f78:	00371793          	slli	a5,a4,0x3
    80003f7c:	0d078793          	addi	a5,a5,208
    80003f80:	953e                	add	a0,a0,a5
    80003f82:	611c                	ld	a5,0(a0)
    80003f84:	c385                	beqz	a5,80003fa4 <argfd+0x56>
    return -1;
  if(pfd)
    80003f86:	00090463          	beqz	s2,80003f8e <argfd+0x40>
    *pfd = fd;
    80003f8a:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003f8e:	4501                	li	a0,0
  if(pf)
    80003f90:	c091                	beqz	s1,80003f94 <argfd+0x46>
    *pf = f;
    80003f92:	e09c                	sd	a5,0(s1)
}
    80003f94:	70a2                	ld	ra,40(sp)
    80003f96:	7402                	ld	s0,32(sp)
    80003f98:	64e2                	ld	s1,24(sp)
    80003f9a:	6942                	ld	s2,16(sp)
    80003f9c:	6145                	addi	sp,sp,48
    80003f9e:	8082                	ret
    return -1;
    80003fa0:	557d                	li	a0,-1
    80003fa2:	bfcd                	j	80003f94 <argfd+0x46>
    80003fa4:	557d                	li	a0,-1
    80003fa6:	b7fd                	j	80003f94 <argfd+0x46>

0000000080003fa8 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003fa8:	1101                	addi	sp,sp,-32
    80003faa:	ec06                	sd	ra,24(sp)
    80003fac:	e822                	sd	s0,16(sp)
    80003fae:	e426                	sd	s1,8(sp)
    80003fb0:	1000                	addi	s0,sp,32
    80003fb2:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003fb4:	dd5fc0ef          	jal	80000d88 <myproc>
    80003fb8:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003fba:	0d050793          	addi	a5,a0,208
    80003fbe:	4501                	li	a0,0
    80003fc0:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003fc2:	6398                	ld	a4,0(a5)
    80003fc4:	cb19                	beqz	a4,80003fda <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003fc6:	2505                	addiw	a0,a0,1
    80003fc8:	07a1                	addi	a5,a5,8
    80003fca:	fed51ce3          	bne	a0,a3,80003fc2 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003fce:	557d                	li	a0,-1
}
    80003fd0:	60e2                	ld	ra,24(sp)
    80003fd2:	6442                	ld	s0,16(sp)
    80003fd4:	64a2                	ld	s1,8(sp)
    80003fd6:	6105                	addi	sp,sp,32
    80003fd8:	8082                	ret
      p->ofile[fd] = f;
    80003fda:	00351793          	slli	a5,a0,0x3
    80003fde:	0d078793          	addi	a5,a5,208
    80003fe2:	963e                	add	a2,a2,a5
    80003fe4:	e204                	sd	s1,0(a2)
      return fd;
    80003fe6:	b7ed                	j	80003fd0 <fdalloc+0x28>

0000000080003fe8 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003fe8:	715d                	addi	sp,sp,-80
    80003fea:	e486                	sd	ra,72(sp)
    80003fec:	e0a2                	sd	s0,64(sp)
    80003fee:	fc26                	sd	s1,56(sp)
    80003ff0:	f84a                	sd	s2,48(sp)
    80003ff2:	f44e                	sd	s3,40(sp)
    80003ff4:	f052                	sd	s4,32(sp)
    80003ff6:	ec56                	sd	s5,24(sp)
    80003ff8:	e85a                	sd	s6,16(sp)
    80003ffa:	0880                	addi	s0,sp,80
    80003ffc:	892e                	mv	s2,a1
    80003ffe:	8a2e                	mv	s4,a1
    80004000:	8ab2                	mv	s5,a2
    80004002:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004004:	fb040593          	addi	a1,s0,-80
    80004008:	fc1fe0ef          	jal	80002fc8 <nameiparent>
    8000400c:	84aa                	mv	s1,a0
    8000400e:	10050763          	beqz	a0,8000411c <create+0x134>
    return 0;

  ilock(dp);
    80004012:	f6efe0ef          	jal	80002780 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004016:	4601                	li	a2,0
    80004018:	fb040593          	addi	a1,s0,-80
    8000401c:	8526                	mv	a0,s1
    8000401e:	cfdfe0ef          	jal	80002d1a <dirlookup>
    80004022:	89aa                	mv	s3,a0
    80004024:	c131                	beqz	a0,80004068 <create+0x80>
    iunlockput(dp);
    80004026:	8526                	mv	a0,s1
    80004028:	965fe0ef          	jal	8000298c <iunlockput>
    ilock(ip);
    8000402c:	854e                	mv	a0,s3
    8000402e:	f52fe0ef          	jal	80002780 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004032:	4789                	li	a5,2
    80004034:	02f91563          	bne	s2,a5,8000405e <create+0x76>
    80004038:	0449d783          	lhu	a5,68(s3)
    8000403c:	37f9                	addiw	a5,a5,-2
    8000403e:	17c2                	slli	a5,a5,0x30
    80004040:	93c1                	srli	a5,a5,0x30
    80004042:	4705                	li	a4,1
    80004044:	00f76d63          	bltu	a4,a5,8000405e <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004048:	854e                	mv	a0,s3
    8000404a:	60a6                	ld	ra,72(sp)
    8000404c:	6406                	ld	s0,64(sp)
    8000404e:	74e2                	ld	s1,56(sp)
    80004050:	7942                	ld	s2,48(sp)
    80004052:	79a2                	ld	s3,40(sp)
    80004054:	7a02                	ld	s4,32(sp)
    80004056:	6ae2                	ld	s5,24(sp)
    80004058:	6b42                	ld	s6,16(sp)
    8000405a:	6161                	addi	sp,sp,80
    8000405c:	8082                	ret
    iunlockput(ip);
    8000405e:	854e                	mv	a0,s3
    80004060:	92dfe0ef          	jal	8000298c <iunlockput>
    return 0;
    80004064:	4981                	li	s3,0
    80004066:	b7cd                	j	80004048 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004068:	85ca                	mv	a1,s2
    8000406a:	4088                	lw	a0,0(s1)
    8000406c:	da4fe0ef          	jal	80002610 <ialloc>
    80004070:	892a                	mv	s2,a0
    80004072:	cd15                	beqz	a0,800040ae <create+0xc6>
  ilock(ip);
    80004074:	f0cfe0ef          	jal	80002780 <ilock>
  ip->major = major;
    80004078:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    8000407c:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004080:	4785                	li	a5,1
    80004082:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004086:	854a                	mv	a0,s2
    80004088:	e44fe0ef          	jal	800026cc <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    8000408c:	4705                	li	a4,1
    8000408e:	02ea0463          	beq	s4,a4,800040b6 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004092:	00492603          	lw	a2,4(s2)
    80004096:	fb040593          	addi	a1,s0,-80
    8000409a:	8526                	mv	a0,s1
    8000409c:	e69fe0ef          	jal	80002f04 <dirlink>
    800040a0:	06054263          	bltz	a0,80004104 <create+0x11c>
  iunlockput(dp);
    800040a4:	8526                	mv	a0,s1
    800040a6:	8e7fe0ef          	jal	8000298c <iunlockput>
  return ip;
    800040aa:	89ca                	mv	s3,s2
    800040ac:	bf71                	j	80004048 <create+0x60>
    iunlockput(dp);
    800040ae:	8526                	mv	a0,s1
    800040b0:	8ddfe0ef          	jal	8000298c <iunlockput>
    return 0;
    800040b4:	bf51                	j	80004048 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800040b6:	00492603          	lw	a2,4(s2)
    800040ba:	00003597          	auipc	a1,0x3
    800040be:	4a658593          	addi	a1,a1,1190 # 80007560 <etext+0x560>
    800040c2:	854a                	mv	a0,s2
    800040c4:	e41fe0ef          	jal	80002f04 <dirlink>
    800040c8:	02054e63          	bltz	a0,80004104 <create+0x11c>
    800040cc:	40d0                	lw	a2,4(s1)
    800040ce:	00003597          	auipc	a1,0x3
    800040d2:	49a58593          	addi	a1,a1,1178 # 80007568 <etext+0x568>
    800040d6:	854a                	mv	a0,s2
    800040d8:	e2dfe0ef          	jal	80002f04 <dirlink>
    800040dc:	02054463          	bltz	a0,80004104 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800040e0:	00492603          	lw	a2,4(s2)
    800040e4:	fb040593          	addi	a1,s0,-80
    800040e8:	8526                	mv	a0,s1
    800040ea:	e1bfe0ef          	jal	80002f04 <dirlink>
    800040ee:	00054b63          	bltz	a0,80004104 <create+0x11c>
    dp->nlink++;  // for ".."
    800040f2:	04a4d783          	lhu	a5,74(s1)
    800040f6:	2785                	addiw	a5,a5,1
    800040f8:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800040fc:	8526                	mv	a0,s1
    800040fe:	dcefe0ef          	jal	800026cc <iupdate>
    80004102:	b74d                	j	800040a4 <create+0xbc>
  ip->nlink = 0;
    80004104:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004108:	854a                	mv	a0,s2
    8000410a:	dc2fe0ef          	jal	800026cc <iupdate>
  iunlockput(ip);
    8000410e:	854a                	mv	a0,s2
    80004110:	87dfe0ef          	jal	8000298c <iunlockput>
  iunlockput(dp);
    80004114:	8526                	mv	a0,s1
    80004116:	877fe0ef          	jal	8000298c <iunlockput>
  return 0;
    8000411a:	b73d                	j	80004048 <create+0x60>
    return 0;
    8000411c:	89aa                	mv	s3,a0
    8000411e:	b72d                	j	80004048 <create+0x60>

0000000080004120 <sys_dup>:
{
    80004120:	7179                	addi	sp,sp,-48
    80004122:	f406                	sd	ra,40(sp)
    80004124:	f022                	sd	s0,32(sp)
    80004126:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004128:	fd840613          	addi	a2,s0,-40
    8000412c:	4581                	li	a1,0
    8000412e:	4501                	li	a0,0
    80004130:	e1fff0ef          	jal	80003f4e <argfd>
    return -1;
    80004134:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004136:	02054363          	bltz	a0,8000415c <sys_dup+0x3c>
    8000413a:	ec26                	sd	s1,24(sp)
    8000413c:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000413e:	fd843483          	ld	s1,-40(s0)
    80004142:	8526                	mv	a0,s1
    80004144:	e65ff0ef          	jal	80003fa8 <fdalloc>
    80004148:	892a                	mv	s2,a0
    return -1;
    8000414a:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000414c:	00054d63          	bltz	a0,80004166 <sys_dup+0x46>
  filedup(f);
    80004150:	8526                	mv	a0,s1
    80004152:	c18ff0ef          	jal	8000356a <filedup>
  return fd;
    80004156:	87ca                	mv	a5,s2
    80004158:	64e2                	ld	s1,24(sp)
    8000415a:	6942                	ld	s2,16(sp)
}
    8000415c:	853e                	mv	a0,a5
    8000415e:	70a2                	ld	ra,40(sp)
    80004160:	7402                	ld	s0,32(sp)
    80004162:	6145                	addi	sp,sp,48
    80004164:	8082                	ret
    80004166:	64e2                	ld	s1,24(sp)
    80004168:	6942                	ld	s2,16(sp)
    8000416a:	bfcd                	j	8000415c <sys_dup+0x3c>

000000008000416c <sys_read>:
{
    8000416c:	7179                	addi	sp,sp,-48
    8000416e:	f406                	sd	ra,40(sp)
    80004170:	f022                	sd	s0,32(sp)
    80004172:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004174:	fd840593          	addi	a1,s0,-40
    80004178:	4505                	li	a0,1
    8000417a:	be7fd0ef          	jal	80001d60 <argaddr>
  argint(2, &n);
    8000417e:	fe440593          	addi	a1,s0,-28
    80004182:	4509                	li	a0,2
    80004184:	bc1fd0ef          	jal	80001d44 <argint>
  if(argfd(0, 0, &f) < 0)
    80004188:	fe840613          	addi	a2,s0,-24
    8000418c:	4581                	li	a1,0
    8000418e:	4501                	li	a0,0
    80004190:	dbfff0ef          	jal	80003f4e <argfd>
    80004194:	87aa                	mv	a5,a0
    return -1;
    80004196:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004198:	0007ca63          	bltz	a5,800041ac <sys_read+0x40>
  return fileread(f, p, n);
    8000419c:	fe442603          	lw	a2,-28(s0)
    800041a0:	fd843583          	ld	a1,-40(s0)
    800041a4:	fe843503          	ld	a0,-24(s0)
    800041a8:	d2cff0ef          	jal	800036d4 <fileread>
}
    800041ac:	70a2                	ld	ra,40(sp)
    800041ae:	7402                	ld	s0,32(sp)
    800041b0:	6145                	addi	sp,sp,48
    800041b2:	8082                	ret

00000000800041b4 <sys_write>:
{
    800041b4:	7179                	addi	sp,sp,-48
    800041b6:	f406                	sd	ra,40(sp)
    800041b8:	f022                	sd	s0,32(sp)
    800041ba:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041bc:	fd840593          	addi	a1,s0,-40
    800041c0:	4505                	li	a0,1
    800041c2:	b9ffd0ef          	jal	80001d60 <argaddr>
  argint(2, &n);
    800041c6:	fe440593          	addi	a1,s0,-28
    800041ca:	4509                	li	a0,2
    800041cc:	b79fd0ef          	jal	80001d44 <argint>
  if(argfd(0, 0, &f) < 0)
    800041d0:	fe840613          	addi	a2,s0,-24
    800041d4:	4581                	li	a1,0
    800041d6:	4501                	li	a0,0
    800041d8:	d77ff0ef          	jal	80003f4e <argfd>
    800041dc:	87aa                	mv	a5,a0
    return -1;
    800041de:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041e0:	0007ca63          	bltz	a5,800041f4 <sys_write+0x40>
  return filewrite(f, p, n);
    800041e4:	fe442603          	lw	a2,-28(s0)
    800041e8:	fd843583          	ld	a1,-40(s0)
    800041ec:	fe843503          	ld	a0,-24(s0)
    800041f0:	da8ff0ef          	jal	80003798 <filewrite>
}
    800041f4:	70a2                	ld	ra,40(sp)
    800041f6:	7402                	ld	s0,32(sp)
    800041f8:	6145                	addi	sp,sp,48
    800041fa:	8082                	ret

00000000800041fc <sys_close>:
{
    800041fc:	1101                	addi	sp,sp,-32
    800041fe:	ec06                	sd	ra,24(sp)
    80004200:	e822                	sd	s0,16(sp)
    80004202:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004204:	fe040613          	addi	a2,s0,-32
    80004208:	fec40593          	addi	a1,s0,-20
    8000420c:	4501                	li	a0,0
    8000420e:	d41ff0ef          	jal	80003f4e <argfd>
    return -1;
    80004212:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004214:	02054163          	bltz	a0,80004236 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004218:	b71fc0ef          	jal	80000d88 <myproc>
    8000421c:	fec42783          	lw	a5,-20(s0)
    80004220:	078e                	slli	a5,a5,0x3
    80004222:	0d078793          	addi	a5,a5,208
    80004226:	953e                	add	a0,a0,a5
    80004228:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000422c:	fe043503          	ld	a0,-32(s0)
    80004230:	b80ff0ef          	jal	800035b0 <fileclose>
  return 0;
    80004234:	4781                	li	a5,0
}
    80004236:	853e                	mv	a0,a5
    80004238:	60e2                	ld	ra,24(sp)
    8000423a:	6442                	ld	s0,16(sp)
    8000423c:	6105                	addi	sp,sp,32
    8000423e:	8082                	ret

0000000080004240 <sys_fstat>:
{
    80004240:	1101                	addi	sp,sp,-32
    80004242:	ec06                	sd	ra,24(sp)
    80004244:	e822                	sd	s0,16(sp)
    80004246:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004248:	fe040593          	addi	a1,s0,-32
    8000424c:	4505                	li	a0,1
    8000424e:	b13fd0ef          	jal	80001d60 <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004252:	fe840613          	addi	a2,s0,-24
    80004256:	4581                	li	a1,0
    80004258:	4501                	li	a0,0
    8000425a:	cf5ff0ef          	jal	80003f4e <argfd>
    8000425e:	87aa                	mv	a5,a0
    return -1;
    80004260:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004262:	0007c863          	bltz	a5,80004272 <sys_fstat+0x32>
  return filestat(f, st);
    80004266:	fe043583          	ld	a1,-32(s0)
    8000426a:	fe843503          	ld	a0,-24(s0)
    8000426e:	c04ff0ef          	jal	80003672 <filestat>
}
    80004272:	60e2                	ld	ra,24(sp)
    80004274:	6442                	ld	s0,16(sp)
    80004276:	6105                	addi	sp,sp,32
    80004278:	8082                	ret

000000008000427a <sys_link>:
{
    8000427a:	7169                	addi	sp,sp,-304
    8000427c:	f606                	sd	ra,296(sp)
    8000427e:	f222                	sd	s0,288(sp)
    80004280:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004282:	08000613          	li	a2,128
    80004286:	ed040593          	addi	a1,s0,-304
    8000428a:	4501                	li	a0,0
    8000428c:	af1fd0ef          	jal	80001d7c <argstr>
    return -1;
    80004290:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004292:	0c054e63          	bltz	a0,8000436e <sys_link+0xf4>
    80004296:	08000613          	li	a2,128
    8000429a:	f5040593          	addi	a1,s0,-176
    8000429e:	4505                	li	a0,1
    800042a0:	addfd0ef          	jal	80001d7c <argstr>
    return -1;
    800042a4:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042a6:	0c054463          	bltz	a0,8000436e <sys_link+0xf4>
    800042aa:	ee26                	sd	s1,280(sp)
  begin_op();
    800042ac:	ee1fe0ef          	jal	8000318c <begin_op>
  if((ip = namei(old)) == 0){
    800042b0:	ed040513          	addi	a0,s0,-304
    800042b4:	cfbfe0ef          	jal	80002fae <namei>
    800042b8:	84aa                	mv	s1,a0
    800042ba:	c53d                	beqz	a0,80004328 <sys_link+0xae>
  ilock(ip);
    800042bc:	cc4fe0ef          	jal	80002780 <ilock>
  if(ip->type == T_DIR){
    800042c0:	04449703          	lh	a4,68(s1)
    800042c4:	4785                	li	a5,1
    800042c6:	06f70663          	beq	a4,a5,80004332 <sys_link+0xb8>
    800042ca:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042cc:	04a4d783          	lhu	a5,74(s1)
    800042d0:	2785                	addiw	a5,a5,1
    800042d2:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800042d6:	8526                	mv	a0,s1
    800042d8:	bf4fe0ef          	jal	800026cc <iupdate>
  iunlock(ip);
    800042dc:	8526                	mv	a0,s1
    800042de:	d50fe0ef          	jal	8000282e <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800042e2:	fd040593          	addi	a1,s0,-48
    800042e6:	f5040513          	addi	a0,s0,-176
    800042ea:	cdffe0ef          	jal	80002fc8 <nameiparent>
    800042ee:	892a                	mv	s2,a0
    800042f0:	cd21                	beqz	a0,80004348 <sys_link+0xce>
  ilock(dp);
    800042f2:	c8efe0ef          	jal	80002780 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800042f6:	854a                	mv	a0,s2
    800042f8:	00092703          	lw	a4,0(s2)
    800042fc:	409c                	lw	a5,0(s1)
    800042fe:	04f71263          	bne	a4,a5,80004342 <sys_link+0xc8>
    80004302:	40d0                	lw	a2,4(s1)
    80004304:	fd040593          	addi	a1,s0,-48
    80004308:	bfdfe0ef          	jal	80002f04 <dirlink>
    8000430c:	02054b63          	bltz	a0,80004342 <sys_link+0xc8>
  iunlockput(dp);
    80004310:	854a                	mv	a0,s2
    80004312:	e7afe0ef          	jal	8000298c <iunlockput>
  iput(ip);
    80004316:	8526                	mv	a0,s1
    80004318:	deafe0ef          	jal	80002902 <iput>
  end_op();
    8000431c:	ee1fe0ef          	jal	800031fc <end_op>
  return 0;
    80004320:	4781                	li	a5,0
    80004322:	64f2                	ld	s1,280(sp)
    80004324:	6952                	ld	s2,272(sp)
    80004326:	a0a1                	j	8000436e <sys_link+0xf4>
    end_op();
    80004328:	ed5fe0ef          	jal	800031fc <end_op>
    return -1;
    8000432c:	57fd                	li	a5,-1
    8000432e:	64f2                	ld	s1,280(sp)
    80004330:	a83d                	j	8000436e <sys_link+0xf4>
    iunlockput(ip);
    80004332:	8526                	mv	a0,s1
    80004334:	e58fe0ef          	jal	8000298c <iunlockput>
    end_op();
    80004338:	ec5fe0ef          	jal	800031fc <end_op>
    return -1;
    8000433c:	57fd                	li	a5,-1
    8000433e:	64f2                	ld	s1,280(sp)
    80004340:	a03d                	j	8000436e <sys_link+0xf4>
    iunlockput(dp);
    80004342:	854a                	mv	a0,s2
    80004344:	e48fe0ef          	jal	8000298c <iunlockput>
  ilock(ip);
    80004348:	8526                	mv	a0,s1
    8000434a:	c36fe0ef          	jal	80002780 <ilock>
  ip->nlink--;
    8000434e:	04a4d783          	lhu	a5,74(s1)
    80004352:	37fd                	addiw	a5,a5,-1
    80004354:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004358:	8526                	mv	a0,s1
    8000435a:	b72fe0ef          	jal	800026cc <iupdate>
  iunlockput(ip);
    8000435e:	8526                	mv	a0,s1
    80004360:	e2cfe0ef          	jal	8000298c <iunlockput>
  end_op();
    80004364:	e99fe0ef          	jal	800031fc <end_op>
  return -1;
    80004368:	57fd                	li	a5,-1
    8000436a:	64f2                	ld	s1,280(sp)
    8000436c:	6952                	ld	s2,272(sp)
}
    8000436e:	853e                	mv	a0,a5
    80004370:	70b2                	ld	ra,296(sp)
    80004372:	7412                	ld	s0,288(sp)
    80004374:	6155                	addi	sp,sp,304
    80004376:	8082                	ret

0000000080004378 <sys_unlink>:
{
    80004378:	7151                	addi	sp,sp,-240
    8000437a:	f586                	sd	ra,232(sp)
    8000437c:	f1a2                	sd	s0,224(sp)
    8000437e:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004380:	08000613          	li	a2,128
    80004384:	f3040593          	addi	a1,s0,-208
    80004388:	4501                	li	a0,0
    8000438a:	9f3fd0ef          	jal	80001d7c <argstr>
    8000438e:	14054d63          	bltz	a0,800044e8 <sys_unlink+0x170>
    80004392:	eda6                	sd	s1,216(sp)
  begin_op();
    80004394:	df9fe0ef          	jal	8000318c <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004398:	fb040593          	addi	a1,s0,-80
    8000439c:	f3040513          	addi	a0,s0,-208
    800043a0:	c29fe0ef          	jal	80002fc8 <nameiparent>
    800043a4:	84aa                	mv	s1,a0
    800043a6:	c955                	beqz	a0,8000445a <sys_unlink+0xe2>
  ilock(dp);
    800043a8:	bd8fe0ef          	jal	80002780 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800043ac:	00003597          	auipc	a1,0x3
    800043b0:	1b458593          	addi	a1,a1,436 # 80007560 <etext+0x560>
    800043b4:	fb040513          	addi	a0,s0,-80
    800043b8:	94dfe0ef          	jal	80002d04 <namecmp>
    800043bc:	10050b63          	beqz	a0,800044d2 <sys_unlink+0x15a>
    800043c0:	00003597          	auipc	a1,0x3
    800043c4:	1a858593          	addi	a1,a1,424 # 80007568 <etext+0x568>
    800043c8:	fb040513          	addi	a0,s0,-80
    800043cc:	939fe0ef          	jal	80002d04 <namecmp>
    800043d0:	10050163          	beqz	a0,800044d2 <sys_unlink+0x15a>
    800043d4:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800043d6:	f2c40613          	addi	a2,s0,-212
    800043da:	fb040593          	addi	a1,s0,-80
    800043de:	8526                	mv	a0,s1
    800043e0:	93bfe0ef          	jal	80002d1a <dirlookup>
    800043e4:	892a                	mv	s2,a0
    800043e6:	0e050563          	beqz	a0,800044d0 <sys_unlink+0x158>
    800043ea:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800043ec:	b94fe0ef          	jal	80002780 <ilock>
  if(ip->nlink < 1)
    800043f0:	04a91783          	lh	a5,74(s2)
    800043f4:	06f05863          	blez	a5,80004464 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800043f8:	04491703          	lh	a4,68(s2)
    800043fc:	4785                	li	a5,1
    800043fe:	06f70963          	beq	a4,a5,80004470 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004402:	fc040993          	addi	s3,s0,-64
    80004406:	4641                	li	a2,16
    80004408:	4581                	li	a1,0
    8000440a:	854e                	mv	a0,s3
    8000440c:	d53fb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004410:	4741                	li	a4,16
    80004412:	f2c42683          	lw	a3,-212(s0)
    80004416:	864e                	mv	a2,s3
    80004418:	4581                	li	a1,0
    8000441a:	8526                	mv	a0,s1
    8000441c:	fe8fe0ef          	jal	80002c04 <writei>
    80004420:	47c1                	li	a5,16
    80004422:	08f51863          	bne	a0,a5,800044b2 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80004426:	04491703          	lh	a4,68(s2)
    8000442a:	4785                	li	a5,1
    8000442c:	08f70963          	beq	a4,a5,800044be <sys_unlink+0x146>
  iunlockput(dp);
    80004430:	8526                	mv	a0,s1
    80004432:	d5afe0ef          	jal	8000298c <iunlockput>
  ip->nlink--;
    80004436:	04a95783          	lhu	a5,74(s2)
    8000443a:	37fd                	addiw	a5,a5,-1
    8000443c:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004440:	854a                	mv	a0,s2
    80004442:	a8afe0ef          	jal	800026cc <iupdate>
  iunlockput(ip);
    80004446:	854a                	mv	a0,s2
    80004448:	d44fe0ef          	jal	8000298c <iunlockput>
  end_op();
    8000444c:	db1fe0ef          	jal	800031fc <end_op>
  return 0;
    80004450:	4501                	li	a0,0
    80004452:	64ee                	ld	s1,216(sp)
    80004454:	694e                	ld	s2,208(sp)
    80004456:	69ae                	ld	s3,200(sp)
    80004458:	a061                	j	800044e0 <sys_unlink+0x168>
    end_op();
    8000445a:	da3fe0ef          	jal	800031fc <end_op>
    return -1;
    8000445e:	557d                	li	a0,-1
    80004460:	64ee                	ld	s1,216(sp)
    80004462:	a8bd                	j	800044e0 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004464:	00003517          	auipc	a0,0x3
    80004468:	10c50513          	addi	a0,a0,268 # 80007570 <etext+0x570>
    8000446c:	37c010ef          	jal	800057e8 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004470:	04c92703          	lw	a4,76(s2)
    80004474:	02000793          	li	a5,32
    80004478:	f8e7f5e3          	bgeu	a5,a4,80004402 <sys_unlink+0x8a>
    8000447c:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000447e:	4741                	li	a4,16
    80004480:	86ce                	mv	a3,s3
    80004482:	f1840613          	addi	a2,s0,-232
    80004486:	4581                	li	a1,0
    80004488:	854a                	mv	a0,s2
    8000448a:	e88fe0ef          	jal	80002b12 <readi>
    8000448e:	47c1                	li	a5,16
    80004490:	00f51b63          	bne	a0,a5,800044a6 <sys_unlink+0x12e>
    if(de.inum != 0)
    80004494:	f1845783          	lhu	a5,-232(s0)
    80004498:	ebb1                	bnez	a5,800044ec <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000449a:	29c1                	addiw	s3,s3,16
    8000449c:	04c92783          	lw	a5,76(s2)
    800044a0:	fcf9efe3          	bltu	s3,a5,8000447e <sys_unlink+0x106>
    800044a4:	bfb9                	j	80004402 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800044a6:	00003517          	auipc	a0,0x3
    800044aa:	0e250513          	addi	a0,a0,226 # 80007588 <etext+0x588>
    800044ae:	33a010ef          	jal	800057e8 <panic>
    panic("unlink: writei");
    800044b2:	00003517          	auipc	a0,0x3
    800044b6:	0ee50513          	addi	a0,a0,238 # 800075a0 <etext+0x5a0>
    800044ba:	32e010ef          	jal	800057e8 <panic>
    dp->nlink--;
    800044be:	04a4d783          	lhu	a5,74(s1)
    800044c2:	37fd                	addiw	a5,a5,-1
    800044c4:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800044c8:	8526                	mv	a0,s1
    800044ca:	a02fe0ef          	jal	800026cc <iupdate>
    800044ce:	b78d                	j	80004430 <sys_unlink+0xb8>
    800044d0:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800044d2:	8526                	mv	a0,s1
    800044d4:	cb8fe0ef          	jal	8000298c <iunlockput>
  end_op();
    800044d8:	d25fe0ef          	jal	800031fc <end_op>
  return -1;
    800044dc:	557d                	li	a0,-1
    800044de:	64ee                	ld	s1,216(sp)
}
    800044e0:	70ae                	ld	ra,232(sp)
    800044e2:	740e                	ld	s0,224(sp)
    800044e4:	616d                	addi	sp,sp,240
    800044e6:	8082                	ret
    return -1;
    800044e8:	557d                	li	a0,-1
    800044ea:	bfdd                	j	800044e0 <sys_unlink+0x168>
    iunlockput(ip);
    800044ec:	854a                	mv	a0,s2
    800044ee:	c9efe0ef          	jal	8000298c <iunlockput>
    goto bad;
    800044f2:	694e                	ld	s2,208(sp)
    800044f4:	69ae                	ld	s3,200(sp)
    800044f6:	bff1                	j	800044d2 <sys_unlink+0x15a>

00000000800044f8 <sys_open>:

uint64
sys_open(void)
{
    800044f8:	7131                	addi	sp,sp,-192
    800044fa:	fd06                	sd	ra,184(sp)
    800044fc:	f922                	sd	s0,176(sp)
    800044fe:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004500:	f4c40593          	addi	a1,s0,-180
    80004504:	4505                	li	a0,1
    80004506:	83ffd0ef          	jal	80001d44 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000450a:	08000613          	li	a2,128
    8000450e:	f5040593          	addi	a1,s0,-176
    80004512:	4501                	li	a0,0
    80004514:	869fd0ef          	jal	80001d7c <argstr>
    80004518:	87aa                	mv	a5,a0
    return -1;
    8000451a:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    8000451c:	0a07c363          	bltz	a5,800045c2 <sys_open+0xca>
    80004520:	f526                	sd	s1,168(sp)

  begin_op();
    80004522:	c6bfe0ef          	jal	8000318c <begin_op>

  if(omode & O_CREATE){
    80004526:	f4c42783          	lw	a5,-180(s0)
    8000452a:	2007f793          	andi	a5,a5,512
    8000452e:	c3dd                	beqz	a5,800045d4 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004530:	4681                	li	a3,0
    80004532:	4601                	li	a2,0
    80004534:	4589                	li	a1,2
    80004536:	f5040513          	addi	a0,s0,-176
    8000453a:	aafff0ef          	jal	80003fe8 <create>
    8000453e:	84aa                	mv	s1,a0
    if(ip == 0){
    80004540:	c549                	beqz	a0,800045ca <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004542:	04449703          	lh	a4,68(s1)
    80004546:	478d                	li	a5,3
    80004548:	00f71763          	bne	a4,a5,80004556 <sys_open+0x5e>
    8000454c:	0464d703          	lhu	a4,70(s1)
    80004550:	47a5                	li	a5,9
    80004552:	0ae7ee63          	bltu	a5,a4,8000460e <sys_open+0x116>
    80004556:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004558:	fb5fe0ef          	jal	8000350c <filealloc>
    8000455c:	892a                	mv	s2,a0
    8000455e:	c561                	beqz	a0,80004626 <sys_open+0x12e>
    80004560:	ed4e                	sd	s3,152(sp)
    80004562:	a47ff0ef          	jal	80003fa8 <fdalloc>
    80004566:	89aa                	mv	s3,a0
    80004568:	0a054b63          	bltz	a0,8000461e <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    8000456c:	04449703          	lh	a4,68(s1)
    80004570:	478d                	li	a5,3
    80004572:	0cf70363          	beq	a4,a5,80004638 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004576:	4789                	li	a5,2
    80004578:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    8000457c:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004580:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004584:	f4c42783          	lw	a5,-180(s0)
    80004588:	0017f713          	andi	a4,a5,1
    8000458c:	00174713          	xori	a4,a4,1
    80004590:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004594:	0037f713          	andi	a4,a5,3
    80004598:	00e03733          	snez	a4,a4
    8000459c:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    800045a0:	4007f793          	andi	a5,a5,1024
    800045a4:	c791                	beqz	a5,800045b0 <sys_open+0xb8>
    800045a6:	04449703          	lh	a4,68(s1)
    800045aa:	4789                	li	a5,2
    800045ac:	08f70d63          	beq	a4,a5,80004646 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    800045b0:	8526                	mv	a0,s1
    800045b2:	a7cfe0ef          	jal	8000282e <iunlock>
  end_op();
    800045b6:	c47fe0ef          	jal	800031fc <end_op>

  return fd;
    800045ba:	854e                	mv	a0,s3
    800045bc:	74aa                	ld	s1,168(sp)
    800045be:	790a                	ld	s2,160(sp)
    800045c0:	69ea                	ld	s3,152(sp)
}
    800045c2:	70ea                	ld	ra,184(sp)
    800045c4:	744a                	ld	s0,176(sp)
    800045c6:	6129                	addi	sp,sp,192
    800045c8:	8082                	ret
      end_op();
    800045ca:	c33fe0ef          	jal	800031fc <end_op>
      return -1;
    800045ce:	557d                	li	a0,-1
    800045d0:	74aa                	ld	s1,168(sp)
    800045d2:	bfc5                	j	800045c2 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800045d4:	f5040513          	addi	a0,s0,-176
    800045d8:	9d7fe0ef          	jal	80002fae <namei>
    800045dc:	84aa                	mv	s1,a0
    800045de:	c11d                	beqz	a0,80004604 <sys_open+0x10c>
    ilock(ip);
    800045e0:	9a0fe0ef          	jal	80002780 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800045e4:	04449703          	lh	a4,68(s1)
    800045e8:	4785                	li	a5,1
    800045ea:	f4f71ce3          	bne	a4,a5,80004542 <sys_open+0x4a>
    800045ee:	f4c42783          	lw	a5,-180(s0)
    800045f2:	d3b5                	beqz	a5,80004556 <sys_open+0x5e>
      iunlockput(ip);
    800045f4:	8526                	mv	a0,s1
    800045f6:	b96fe0ef          	jal	8000298c <iunlockput>
      end_op();
    800045fa:	c03fe0ef          	jal	800031fc <end_op>
      return -1;
    800045fe:	557d                	li	a0,-1
    80004600:	74aa                	ld	s1,168(sp)
    80004602:	b7c1                	j	800045c2 <sys_open+0xca>
      end_op();
    80004604:	bf9fe0ef          	jal	800031fc <end_op>
      return -1;
    80004608:	557d                	li	a0,-1
    8000460a:	74aa                	ld	s1,168(sp)
    8000460c:	bf5d                	j	800045c2 <sys_open+0xca>
    iunlockput(ip);
    8000460e:	8526                	mv	a0,s1
    80004610:	b7cfe0ef          	jal	8000298c <iunlockput>
    end_op();
    80004614:	be9fe0ef          	jal	800031fc <end_op>
    return -1;
    80004618:	557d                	li	a0,-1
    8000461a:	74aa                	ld	s1,168(sp)
    8000461c:	b75d                	j	800045c2 <sys_open+0xca>
      fileclose(f);
    8000461e:	854a                	mv	a0,s2
    80004620:	f91fe0ef          	jal	800035b0 <fileclose>
    80004624:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004626:	8526                	mv	a0,s1
    80004628:	b64fe0ef          	jal	8000298c <iunlockput>
    end_op();
    8000462c:	bd1fe0ef          	jal	800031fc <end_op>
    return -1;
    80004630:	557d                	li	a0,-1
    80004632:	74aa                	ld	s1,168(sp)
    80004634:	790a                	ld	s2,160(sp)
    80004636:	b771                	j	800045c2 <sys_open+0xca>
    f->type = FD_DEVICE;
    80004638:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    8000463c:	04649783          	lh	a5,70(s1)
    80004640:	02f91223          	sh	a5,36(s2)
    80004644:	bf35                	j	80004580 <sys_open+0x88>
    itrunc(ip);
    80004646:	8526                	mv	a0,s1
    80004648:	a26fe0ef          	jal	8000286e <itrunc>
    8000464c:	b795                	j	800045b0 <sys_open+0xb8>

000000008000464e <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000464e:	7175                	addi	sp,sp,-144
    80004650:	e506                	sd	ra,136(sp)
    80004652:	e122                	sd	s0,128(sp)
    80004654:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004656:	b37fe0ef          	jal	8000318c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    8000465a:	08000613          	li	a2,128
    8000465e:	f7040593          	addi	a1,s0,-144
    80004662:	4501                	li	a0,0
    80004664:	f18fd0ef          	jal	80001d7c <argstr>
    80004668:	02054363          	bltz	a0,8000468e <sys_mkdir+0x40>
    8000466c:	4681                	li	a3,0
    8000466e:	4601                	li	a2,0
    80004670:	4585                	li	a1,1
    80004672:	f7040513          	addi	a0,s0,-144
    80004676:	973ff0ef          	jal	80003fe8 <create>
    8000467a:	c911                	beqz	a0,8000468e <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    8000467c:	b10fe0ef          	jal	8000298c <iunlockput>
  end_op();
    80004680:	b7dfe0ef          	jal	800031fc <end_op>
  return 0;
    80004684:	4501                	li	a0,0
}
    80004686:	60aa                	ld	ra,136(sp)
    80004688:	640a                	ld	s0,128(sp)
    8000468a:	6149                	addi	sp,sp,144
    8000468c:	8082                	ret
    end_op();
    8000468e:	b6ffe0ef          	jal	800031fc <end_op>
    return -1;
    80004692:	557d                	li	a0,-1
    80004694:	bfcd                	j	80004686 <sys_mkdir+0x38>

0000000080004696 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004696:	7135                	addi	sp,sp,-160
    80004698:	ed06                	sd	ra,152(sp)
    8000469a:	e922                	sd	s0,144(sp)
    8000469c:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    8000469e:	aeffe0ef          	jal	8000318c <begin_op>
  argint(1, &major);
    800046a2:	f6c40593          	addi	a1,s0,-148
    800046a6:	4505                	li	a0,1
    800046a8:	e9cfd0ef          	jal	80001d44 <argint>
  argint(2, &minor);
    800046ac:	f6840593          	addi	a1,s0,-152
    800046b0:	4509                	li	a0,2
    800046b2:	e92fd0ef          	jal	80001d44 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046b6:	08000613          	li	a2,128
    800046ba:	f7040593          	addi	a1,s0,-144
    800046be:	4501                	li	a0,0
    800046c0:	ebcfd0ef          	jal	80001d7c <argstr>
    800046c4:	02054563          	bltz	a0,800046ee <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800046c8:	f6841683          	lh	a3,-152(s0)
    800046cc:	f6c41603          	lh	a2,-148(s0)
    800046d0:	458d                	li	a1,3
    800046d2:	f7040513          	addi	a0,s0,-144
    800046d6:	913ff0ef          	jal	80003fe8 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046da:	c911                	beqz	a0,800046ee <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800046dc:	ab0fe0ef          	jal	8000298c <iunlockput>
  end_op();
    800046e0:	b1dfe0ef          	jal	800031fc <end_op>
  return 0;
    800046e4:	4501                	li	a0,0
}
    800046e6:	60ea                	ld	ra,152(sp)
    800046e8:	644a                	ld	s0,144(sp)
    800046ea:	610d                	addi	sp,sp,160
    800046ec:	8082                	ret
    end_op();
    800046ee:	b0ffe0ef          	jal	800031fc <end_op>
    return -1;
    800046f2:	557d                	li	a0,-1
    800046f4:	bfcd                	j	800046e6 <sys_mknod+0x50>

00000000800046f6 <sys_chdir>:

uint64
sys_chdir(void)
{
    800046f6:	7135                	addi	sp,sp,-160
    800046f8:	ed06                	sd	ra,152(sp)
    800046fa:	e922                	sd	s0,144(sp)
    800046fc:	e14a                	sd	s2,128(sp)
    800046fe:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004700:	e88fc0ef          	jal	80000d88 <myproc>
    80004704:	892a                	mv	s2,a0
  
  begin_op();
    80004706:	a87fe0ef          	jal	8000318c <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    8000470a:	08000613          	li	a2,128
    8000470e:	f6040593          	addi	a1,s0,-160
    80004712:	4501                	li	a0,0
    80004714:	e68fd0ef          	jal	80001d7c <argstr>
    80004718:	04054363          	bltz	a0,8000475e <sys_chdir+0x68>
    8000471c:	e526                	sd	s1,136(sp)
    8000471e:	f6040513          	addi	a0,s0,-160
    80004722:	88dfe0ef          	jal	80002fae <namei>
    80004726:	84aa                	mv	s1,a0
    80004728:	c915                	beqz	a0,8000475c <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    8000472a:	856fe0ef          	jal	80002780 <ilock>
  if(ip->type != T_DIR){
    8000472e:	04449703          	lh	a4,68(s1)
    80004732:	4785                	li	a5,1
    80004734:	02f71963          	bne	a4,a5,80004766 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004738:	8526                	mv	a0,s1
    8000473a:	8f4fe0ef          	jal	8000282e <iunlock>
  iput(p->cwd);
    8000473e:	15093503          	ld	a0,336(s2)
    80004742:	9c0fe0ef          	jal	80002902 <iput>
  end_op();
    80004746:	ab7fe0ef          	jal	800031fc <end_op>
  p->cwd = ip;
    8000474a:	14993823          	sd	s1,336(s2)
  return 0;
    8000474e:	4501                	li	a0,0
    80004750:	64aa                	ld	s1,136(sp)
}
    80004752:	60ea                	ld	ra,152(sp)
    80004754:	644a                	ld	s0,144(sp)
    80004756:	690a                	ld	s2,128(sp)
    80004758:	610d                	addi	sp,sp,160
    8000475a:	8082                	ret
    8000475c:	64aa                	ld	s1,136(sp)
    end_op();
    8000475e:	a9ffe0ef          	jal	800031fc <end_op>
    return -1;
    80004762:	557d                	li	a0,-1
    80004764:	b7fd                	j	80004752 <sys_chdir+0x5c>
    iunlockput(ip);
    80004766:	8526                	mv	a0,s1
    80004768:	a24fe0ef          	jal	8000298c <iunlockput>
    end_op();
    8000476c:	a91fe0ef          	jal	800031fc <end_op>
    return -1;
    80004770:	557d                	li	a0,-1
    80004772:	64aa                	ld	s1,136(sp)
    80004774:	bff9                	j	80004752 <sys_chdir+0x5c>

0000000080004776 <sys_exec>:

uint64
sys_exec(void)
{
    80004776:	7105                	addi	sp,sp,-480
    80004778:	ef86                	sd	ra,472(sp)
    8000477a:	eba2                	sd	s0,464(sp)
    8000477c:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    8000477e:	e2840593          	addi	a1,s0,-472
    80004782:	4505                	li	a0,1
    80004784:	ddcfd0ef          	jal	80001d60 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004788:	08000613          	li	a2,128
    8000478c:	f3040593          	addi	a1,s0,-208
    80004790:	4501                	li	a0,0
    80004792:	deafd0ef          	jal	80001d7c <argstr>
    80004796:	87aa                	mv	a5,a0
    return -1;
    80004798:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    8000479a:	0e07c063          	bltz	a5,8000487a <sys_exec+0x104>
    8000479e:	e7a6                	sd	s1,456(sp)
    800047a0:	e3ca                	sd	s2,448(sp)
    800047a2:	ff4e                	sd	s3,440(sp)
    800047a4:	fb52                	sd	s4,432(sp)
    800047a6:	f756                	sd	s5,424(sp)
    800047a8:	f35a                	sd	s6,416(sp)
    800047aa:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800047ac:	e3040a13          	addi	s4,s0,-464
    800047b0:	10000613          	li	a2,256
    800047b4:	4581                	li	a1,0
    800047b6:	8552                	mv	a0,s4
    800047b8:	9a7fb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800047bc:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800047be:	89d2                	mv	s3,s4
    800047c0:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047c2:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047c6:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800047c8:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047cc:	00391513          	slli	a0,s2,0x3
    800047d0:	85d6                	mv	a1,s5
    800047d2:	e2843783          	ld	a5,-472(s0)
    800047d6:	953e                	add	a0,a0,a5
    800047d8:	ce2fd0ef          	jal	80001cba <fetchaddr>
    800047dc:	02054663          	bltz	a0,80004808 <sys_exec+0x92>
    if(uarg == 0){
    800047e0:	e2043783          	ld	a5,-480(s0)
    800047e4:	c7a1                	beqz	a5,8000482c <sys_exec+0xb6>
    argv[i] = kalloc();
    800047e6:	91ffb0ef          	jal	80000104 <kalloc>
    800047ea:	85aa                	mv	a1,a0
    800047ec:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800047f0:	cd01                	beqz	a0,80004808 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047f2:	865a                	mv	a2,s6
    800047f4:	e2043503          	ld	a0,-480(s0)
    800047f8:	d0cfd0ef          	jal	80001d04 <fetchstr>
    800047fc:	00054663          	bltz	a0,80004808 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004800:	0905                	addi	s2,s2,1
    80004802:	09a1                	addi	s3,s3,8
    80004804:	fd7914e3          	bne	s2,s7,800047cc <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004808:	100a0a13          	addi	s4,s4,256
    8000480c:	6088                	ld	a0,0(s1)
    8000480e:	cd31                	beqz	a0,8000486a <sys_exec+0xf4>
    kfree(argv[i]);
    80004810:	80dfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004814:	04a1                	addi	s1,s1,8
    80004816:	ff449be3          	bne	s1,s4,8000480c <sys_exec+0x96>
  return -1;
    8000481a:	557d                	li	a0,-1
    8000481c:	64be                	ld	s1,456(sp)
    8000481e:	691e                	ld	s2,448(sp)
    80004820:	79fa                	ld	s3,440(sp)
    80004822:	7a5a                	ld	s4,432(sp)
    80004824:	7aba                	ld	s5,424(sp)
    80004826:	7b1a                	ld	s6,416(sp)
    80004828:	6bfa                	ld	s7,408(sp)
    8000482a:	a881                	j	8000487a <sys_exec+0x104>
      argv[i] = 0;
    8000482c:	0009079b          	sext.w	a5,s2
    80004830:	e3040593          	addi	a1,s0,-464
    80004834:	078e                	slli	a5,a5,0x3
    80004836:	97ae                	add	a5,a5,a1
    80004838:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    8000483c:	f3040513          	addi	a0,s0,-208
    80004840:	bb2ff0ef          	jal	80003bf2 <kexec>
    80004844:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004846:	100a0a13          	addi	s4,s4,256
    8000484a:	6088                	ld	a0,0(s1)
    8000484c:	c511                	beqz	a0,80004858 <sys_exec+0xe2>
    kfree(argv[i]);
    8000484e:	fcefb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004852:	04a1                	addi	s1,s1,8
    80004854:	ff449be3          	bne	s1,s4,8000484a <sys_exec+0xd4>
  return ret;
    80004858:	854a                	mv	a0,s2
    8000485a:	64be                	ld	s1,456(sp)
    8000485c:	691e                	ld	s2,448(sp)
    8000485e:	79fa                	ld	s3,440(sp)
    80004860:	7a5a                	ld	s4,432(sp)
    80004862:	7aba                	ld	s5,424(sp)
    80004864:	7b1a                	ld	s6,416(sp)
    80004866:	6bfa                	ld	s7,408(sp)
    80004868:	a809                	j	8000487a <sys_exec+0x104>
  return -1;
    8000486a:	557d                	li	a0,-1
    8000486c:	64be                	ld	s1,456(sp)
    8000486e:	691e                	ld	s2,448(sp)
    80004870:	79fa                	ld	s3,440(sp)
    80004872:	7a5a                	ld	s4,432(sp)
    80004874:	7aba                	ld	s5,424(sp)
    80004876:	7b1a                	ld	s6,416(sp)
    80004878:	6bfa                	ld	s7,408(sp)
}
    8000487a:	60fe                	ld	ra,472(sp)
    8000487c:	645e                	ld	s0,464(sp)
    8000487e:	613d                	addi	sp,sp,480
    80004880:	8082                	ret

0000000080004882 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004882:	7139                	addi	sp,sp,-64
    80004884:	fc06                	sd	ra,56(sp)
    80004886:	f822                	sd	s0,48(sp)
    80004888:	f426                	sd	s1,40(sp)
    8000488a:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    8000488c:	cfcfc0ef          	jal	80000d88 <myproc>
    80004890:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004892:	fd840593          	addi	a1,s0,-40
    80004896:	4501                	li	a0,0
    80004898:	cc8fd0ef          	jal	80001d60 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    8000489c:	fc840593          	addi	a1,s0,-56
    800048a0:	fd040513          	addi	a0,s0,-48
    800048a4:	828ff0ef          	jal	800038cc <pipealloc>
    return -1;
    800048a8:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800048aa:	0a054763          	bltz	a0,80004958 <sys_pipe+0xd6>
  fd0 = -1;
    800048ae:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800048b2:	fd043503          	ld	a0,-48(s0)
    800048b6:	ef2ff0ef          	jal	80003fa8 <fdalloc>
    800048ba:	fca42223          	sw	a0,-60(s0)
    800048be:	08054463          	bltz	a0,80004946 <sys_pipe+0xc4>
    800048c2:	fc843503          	ld	a0,-56(s0)
    800048c6:	ee2ff0ef          	jal	80003fa8 <fdalloc>
    800048ca:	fca42023          	sw	a0,-64(s0)
    800048ce:	06054263          	bltz	a0,80004932 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048d2:	4691                	li	a3,4
    800048d4:	fc440613          	addi	a2,s0,-60
    800048d8:	fd843583          	ld	a1,-40(s0)
    800048dc:	68a8                	ld	a0,80(s1)
    800048de:	9dcfc0ef          	jal	80000aba <copyout>
    800048e2:	00054e63          	bltz	a0,800048fe <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800048e6:	4691                	li	a3,4
    800048e8:	fc040613          	addi	a2,s0,-64
    800048ec:	fd843583          	ld	a1,-40(s0)
    800048f0:	95b6                	add	a1,a1,a3
    800048f2:	68a8                	ld	a0,80(s1)
    800048f4:	9c6fc0ef          	jal	80000aba <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800048f8:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048fa:	04055f63          	bgez	a0,80004958 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800048fe:	fc442783          	lw	a5,-60(s0)
    80004902:	078e                	slli	a5,a5,0x3
    80004904:	0d078793          	addi	a5,a5,208
    80004908:	97a6                	add	a5,a5,s1
    8000490a:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    8000490e:	fc042783          	lw	a5,-64(s0)
    80004912:	078e                	slli	a5,a5,0x3
    80004914:	0d078793          	addi	a5,a5,208
    80004918:	97a6                	add	a5,a5,s1
    8000491a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000491e:	fd043503          	ld	a0,-48(s0)
    80004922:	c8ffe0ef          	jal	800035b0 <fileclose>
    fileclose(wf);
    80004926:	fc843503          	ld	a0,-56(s0)
    8000492a:	c87fe0ef          	jal	800035b0 <fileclose>
    return -1;
    8000492e:	57fd                	li	a5,-1
    80004930:	a025                	j	80004958 <sys_pipe+0xd6>
    if(fd0 >= 0)
    80004932:	fc442783          	lw	a5,-60(s0)
    80004936:	0007c863          	bltz	a5,80004946 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    8000493a:	078e                	slli	a5,a5,0x3
    8000493c:	0d078793          	addi	a5,a5,208
    80004940:	97a6                	add	a5,a5,s1
    80004942:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004946:	fd043503          	ld	a0,-48(s0)
    8000494a:	c67fe0ef          	jal	800035b0 <fileclose>
    fileclose(wf);
    8000494e:	fc843503          	ld	a0,-56(s0)
    80004952:	c5ffe0ef          	jal	800035b0 <fileclose>
    return -1;
    80004956:	57fd                	li	a5,-1
}
    80004958:	853e                	mv	a0,a5
    8000495a:	70e2                	ld	ra,56(sp)
    8000495c:	7442                	ld	s0,48(sp)
    8000495e:	74a2                	ld	s1,40(sp)
    80004960:	6121                	addi	sp,sp,64
    80004962:	8082                	ret
	...

0000000080004970 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004970:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004972:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004974:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004976:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004978:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000497a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000497c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000497e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004980:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004982:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004984:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004986:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004988:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000498a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000498c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000498e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004990:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004992:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004994:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004996:	a32fd0ef          	jal	80001bc8 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000499a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000499c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000499e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    800049a0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    800049a2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    800049a4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    800049a6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    800049a8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    800049aa:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    800049ac:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    800049ae:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    800049b0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    800049b2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    800049b4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    800049b6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    800049b8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    800049ba:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    800049bc:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    800049be:	10200073          	sret
    800049c2:	00000013          	nop
    800049c6:	00000013          	nop
    800049ca:	00000013          	nop

00000000800049ce <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800049ce:	1141                	addi	sp,sp,-16
    800049d0:	e406                	sd	ra,8(sp)
    800049d2:	e022                	sd	s0,0(sp)
    800049d4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800049d6:	0c000737          	lui	a4,0xc000
    800049da:	4785                	li	a5,1
    800049dc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800049de:	c35c                	sw	a5,4(a4)
}
    800049e0:	60a2                	ld	ra,8(sp)
    800049e2:	6402                	ld	s0,0(sp)
    800049e4:	0141                	addi	sp,sp,16
    800049e6:	8082                	ret

00000000800049e8 <plicinithart>:

void
plicinithart(void)
{
    800049e8:	1141                	addi	sp,sp,-16
    800049ea:	e406                	sd	ra,8(sp)
    800049ec:	e022                	sd	s0,0(sp)
    800049ee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049f0:	b64fc0ef          	jal	80000d54 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800049f4:	0085171b          	slliw	a4,a0,0x8
    800049f8:	0c0027b7          	lui	a5,0xc002
    800049fc:	97ba                	add	a5,a5,a4
    800049fe:	40200713          	li	a4,1026
    80004a02:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004a06:	00d5151b          	slliw	a0,a0,0xd
    80004a0a:	0c2017b7          	lui	a5,0xc201
    80004a0e:	97aa                	add	a5,a5,a0
    80004a10:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004a14:	60a2                	ld	ra,8(sp)
    80004a16:	6402                	ld	s0,0(sp)
    80004a18:	0141                	addi	sp,sp,16
    80004a1a:	8082                	ret

0000000080004a1c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004a1c:	1141                	addi	sp,sp,-16
    80004a1e:	e406                	sd	ra,8(sp)
    80004a20:	e022                	sd	s0,0(sp)
    80004a22:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004a24:	b30fc0ef          	jal	80000d54 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004a28:	00d5151b          	slliw	a0,a0,0xd
    80004a2c:	0c2017b7          	lui	a5,0xc201
    80004a30:	97aa                	add	a5,a5,a0
  return irq;
}
    80004a32:	43c8                	lw	a0,4(a5)
    80004a34:	60a2                	ld	ra,8(sp)
    80004a36:	6402                	ld	s0,0(sp)
    80004a38:	0141                	addi	sp,sp,16
    80004a3a:	8082                	ret

0000000080004a3c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004a3c:	1101                	addi	sp,sp,-32
    80004a3e:	ec06                	sd	ra,24(sp)
    80004a40:	e822                	sd	s0,16(sp)
    80004a42:	e426                	sd	s1,8(sp)
    80004a44:	1000                	addi	s0,sp,32
    80004a46:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004a48:	b0cfc0ef          	jal	80000d54 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004a4c:	00d5179b          	slliw	a5,a0,0xd
    80004a50:	0c201737          	lui	a4,0xc201
    80004a54:	97ba                	add	a5,a5,a4
    80004a56:	c3c4                	sw	s1,4(a5)
}
    80004a58:	60e2                	ld	ra,24(sp)
    80004a5a:	6442                	ld	s0,16(sp)
    80004a5c:	64a2                	ld	s1,8(sp)
    80004a5e:	6105                	addi	sp,sp,32
    80004a60:	8082                	ret

0000000080004a62 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a62:	1141                	addi	sp,sp,-16
    80004a64:	e406                	sd	ra,8(sp)
    80004a66:	e022                	sd	s0,0(sp)
    80004a68:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a6a:	479d                	li	a5,7
    80004a6c:	04a7ca63          	blt	a5,a0,80004ac0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a70:	00014797          	auipc	a5,0x14
    80004a74:	71078793          	addi	a5,a5,1808 # 80019180 <disk>
    80004a78:	97aa                	add	a5,a5,a0
    80004a7a:	0187c783          	lbu	a5,24(a5)
    80004a7e:	e7b9                	bnez	a5,80004acc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a80:	00451693          	slli	a3,a0,0x4
    80004a84:	00014797          	auipc	a5,0x14
    80004a88:	6fc78793          	addi	a5,a5,1788 # 80019180 <disk>
    80004a8c:	6398                	ld	a4,0(a5)
    80004a8e:	9736                	add	a4,a4,a3
    80004a90:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004a94:	6398                	ld	a4,0(a5)
    80004a96:	9736                	add	a4,a4,a3
    80004a98:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004a9c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004aa0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004aa4:	97aa                	add	a5,a5,a0
    80004aa6:	4705                	li	a4,1
    80004aa8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004aac:	00014517          	auipc	a0,0x14
    80004ab0:	6ec50513          	addi	a0,a0,1772 # 80019198 <disk+0x18>
    80004ab4:	995fc0ef          	jal	80001448 <wakeup>
}
    80004ab8:	60a2                	ld	ra,8(sp)
    80004aba:	6402                	ld	s0,0(sp)
    80004abc:	0141                	addi	sp,sp,16
    80004abe:	8082                	ret
    panic("free_desc 1");
    80004ac0:	00003517          	auipc	a0,0x3
    80004ac4:	af050513          	addi	a0,a0,-1296 # 800075b0 <etext+0x5b0>
    80004ac8:	521000ef          	jal	800057e8 <panic>
    panic("free_desc 2");
    80004acc:	00003517          	auipc	a0,0x3
    80004ad0:	af450513          	addi	a0,a0,-1292 # 800075c0 <etext+0x5c0>
    80004ad4:	515000ef          	jal	800057e8 <panic>

0000000080004ad8 <virtio_disk_init>:
{
    80004ad8:	1101                	addi	sp,sp,-32
    80004ada:	ec06                	sd	ra,24(sp)
    80004adc:	e822                	sd	s0,16(sp)
    80004ade:	e426                	sd	s1,8(sp)
    80004ae0:	e04a                	sd	s2,0(sp)
    80004ae2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004ae4:	00003597          	auipc	a1,0x3
    80004ae8:	aec58593          	addi	a1,a1,-1300 # 800075d0 <etext+0x5d0>
    80004aec:	00014517          	auipc	a0,0x14
    80004af0:	7bc50513          	addi	a0,a0,1980 # 800192a8 <disk+0x128>
    80004af4:	70d000ef          	jal	80005a00 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004af8:	100017b7          	lui	a5,0x10001
    80004afc:	4398                	lw	a4,0(a5)
    80004afe:	2701                	sext.w	a4,a4
    80004b00:	747277b7          	lui	a5,0x74727
    80004b04:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004b08:	14f71863          	bne	a4,a5,80004c58 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b0c:	100017b7          	lui	a5,0x10001
    80004b10:	43dc                	lw	a5,4(a5)
    80004b12:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004b14:	4709                	li	a4,2
    80004b16:	14e79163          	bne	a5,a4,80004c58 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b1a:	100017b7          	lui	a5,0x10001
    80004b1e:	479c                	lw	a5,8(a5)
    80004b20:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004b22:	12e79b63          	bne	a5,a4,80004c58 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004b26:	100017b7          	lui	a5,0x10001
    80004b2a:	47d8                	lw	a4,12(a5)
    80004b2c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004b2e:	554d47b7          	lui	a5,0x554d4
    80004b32:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004b36:	12f71163          	bne	a4,a5,80004c58 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b3a:	100017b7          	lui	a5,0x10001
    80004b3e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b42:	4705                	li	a4,1
    80004b44:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b46:	470d                	li	a4,3
    80004b48:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004b4a:	10001737          	lui	a4,0x10001
    80004b4e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004b50:	c7ffe6b7          	lui	a3,0xc7ffe
    80004b54:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdd3c7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004b58:	8f75                	and	a4,a4,a3
    80004b5a:	100016b7          	lui	a3,0x10001
    80004b5e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b60:	472d                	li	a4,11
    80004b62:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b64:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b68:	439c                	lw	a5,0(a5)
    80004b6a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b6e:	8ba1                	andi	a5,a5,8
    80004b70:	0e078a63          	beqz	a5,80004c64 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b74:	100017b7          	lui	a5,0x10001
    80004b78:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b7c:	43fc                	lw	a5,68(a5)
    80004b7e:	2781                	sext.w	a5,a5
    80004b80:	0e079863          	bnez	a5,80004c70 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004b84:	100017b7          	lui	a5,0x10001
    80004b88:	5bdc                	lw	a5,52(a5)
    80004b8a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004b8c:	0e078863          	beqz	a5,80004c7c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004b90:	471d                	li	a4,7
    80004b92:	0ef77b63          	bgeu	a4,a5,80004c88 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004b96:	d6efb0ef          	jal	80000104 <kalloc>
    80004b9a:	00014497          	auipc	s1,0x14
    80004b9e:	5e648493          	addi	s1,s1,1510 # 80019180 <disk>
    80004ba2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004ba4:	d60fb0ef          	jal	80000104 <kalloc>
    80004ba8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004baa:	d5afb0ef          	jal	80000104 <kalloc>
    80004bae:	87aa                	mv	a5,a0
    80004bb0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004bb2:	6088                	ld	a0,0(s1)
    80004bb4:	0e050063          	beqz	a0,80004c94 <virtio_disk_init+0x1bc>
    80004bb8:	00014717          	auipc	a4,0x14
    80004bbc:	5d073703          	ld	a4,1488(a4) # 80019188 <disk+0x8>
    80004bc0:	cb71                	beqz	a4,80004c94 <virtio_disk_init+0x1bc>
    80004bc2:	cbe9                	beqz	a5,80004c94 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004bc4:	6605                	lui	a2,0x1
    80004bc6:	4581                	li	a1,0
    80004bc8:	d96fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004bcc:	00014497          	auipc	s1,0x14
    80004bd0:	5b448493          	addi	s1,s1,1460 # 80019180 <disk>
    80004bd4:	6605                	lui	a2,0x1
    80004bd6:	4581                	li	a1,0
    80004bd8:	6488                	ld	a0,8(s1)
    80004bda:	d84fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    80004bde:	6605                	lui	a2,0x1
    80004be0:	4581                	li	a1,0
    80004be2:	6888                	ld	a0,16(s1)
    80004be4:	d7afb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004be8:	100017b7          	lui	a5,0x10001
    80004bec:	4721                	li	a4,8
    80004bee:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004bf0:	4098                	lw	a4,0(s1)
    80004bf2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004bf6:	40d8                	lw	a4,4(s1)
    80004bf8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004bfc:	649c                	ld	a5,8(s1)
    80004bfe:	0007869b          	sext.w	a3,a5
    80004c02:	10001737          	lui	a4,0x10001
    80004c06:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004c0a:	9781                	srai	a5,a5,0x20
    80004c0c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004c10:	689c                	ld	a5,16(s1)
    80004c12:	0007869b          	sext.w	a3,a5
    80004c16:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004c1a:	9781                	srai	a5,a5,0x20
    80004c1c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004c20:	4785                	li	a5,1
    80004c22:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004c24:	00f48c23          	sb	a5,24(s1)
    80004c28:	00f48ca3          	sb	a5,25(s1)
    80004c2c:	00f48d23          	sb	a5,26(s1)
    80004c30:	00f48da3          	sb	a5,27(s1)
    80004c34:	00f48e23          	sb	a5,28(s1)
    80004c38:	00f48ea3          	sb	a5,29(s1)
    80004c3c:	00f48f23          	sb	a5,30(s1)
    80004c40:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c44:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c48:	07272823          	sw	s2,112(a4)
}
    80004c4c:	60e2                	ld	ra,24(sp)
    80004c4e:	6442                	ld	s0,16(sp)
    80004c50:	64a2                	ld	s1,8(sp)
    80004c52:	6902                	ld	s2,0(sp)
    80004c54:	6105                	addi	sp,sp,32
    80004c56:	8082                	ret
    panic("could not find virtio disk");
    80004c58:	00003517          	auipc	a0,0x3
    80004c5c:	98850513          	addi	a0,a0,-1656 # 800075e0 <etext+0x5e0>
    80004c60:	389000ef          	jal	800057e8 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004c64:	00003517          	auipc	a0,0x3
    80004c68:	99c50513          	addi	a0,a0,-1636 # 80007600 <etext+0x600>
    80004c6c:	37d000ef          	jal	800057e8 <panic>
    panic("virtio disk should not be ready");
    80004c70:	00003517          	auipc	a0,0x3
    80004c74:	9b050513          	addi	a0,a0,-1616 # 80007620 <etext+0x620>
    80004c78:	371000ef          	jal	800057e8 <panic>
    panic("virtio disk has no queue 0");
    80004c7c:	00003517          	auipc	a0,0x3
    80004c80:	9c450513          	addi	a0,a0,-1596 # 80007640 <etext+0x640>
    80004c84:	365000ef          	jal	800057e8 <panic>
    panic("virtio disk max queue too short");
    80004c88:	00003517          	auipc	a0,0x3
    80004c8c:	9d850513          	addi	a0,a0,-1576 # 80007660 <etext+0x660>
    80004c90:	359000ef          	jal	800057e8 <panic>
    panic("virtio disk kalloc");
    80004c94:	00003517          	auipc	a0,0x3
    80004c98:	9ec50513          	addi	a0,a0,-1556 # 80007680 <etext+0x680>
    80004c9c:	34d000ef          	jal	800057e8 <panic>

0000000080004ca0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ca0:	711d                	addi	sp,sp,-96
    80004ca2:	ec86                	sd	ra,88(sp)
    80004ca4:	e8a2                	sd	s0,80(sp)
    80004ca6:	e4a6                	sd	s1,72(sp)
    80004ca8:	e0ca                	sd	s2,64(sp)
    80004caa:	fc4e                	sd	s3,56(sp)
    80004cac:	f852                	sd	s4,48(sp)
    80004cae:	f456                	sd	s5,40(sp)
    80004cb0:	f05a                	sd	s6,32(sp)
    80004cb2:	ec5e                	sd	s7,24(sp)
    80004cb4:	e862                	sd	s8,16(sp)
    80004cb6:	1080                	addi	s0,sp,96
    80004cb8:	89aa                	mv	s3,a0
    80004cba:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004cbc:	00c52b83          	lw	s7,12(a0)
    80004cc0:	001b9b9b          	slliw	s7,s7,0x1
    80004cc4:	1b82                	slli	s7,s7,0x20
    80004cc6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004cca:	00014517          	auipc	a0,0x14
    80004cce:	5de50513          	addi	a0,a0,1502 # 800192a8 <disk+0x128>
    80004cd2:	5b9000ef          	jal	80005a8a <acquire>
  for(int i = 0; i < NUM; i++){
    80004cd6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004cd8:	00014a97          	auipc	s5,0x14
    80004cdc:	4a8a8a93          	addi	s5,s5,1192 # 80019180 <disk>
  for(int i = 0; i < 3; i++){
    80004ce0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004ce2:	5c7d                	li	s8,-1
    80004ce4:	a095                	j	80004d48 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004ce6:	00fa8733          	add	a4,s5,a5
    80004cea:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004cee:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004cf0:	0207c563          	bltz	a5,80004d1a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004cf4:	2905                	addiw	s2,s2,1
    80004cf6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004cf8:	05490c63          	beq	s2,s4,80004d50 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004cfc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004cfe:	00014717          	auipc	a4,0x14
    80004d02:	48270713          	addi	a4,a4,1154 # 80019180 <disk>
    80004d06:	4781                	li	a5,0
    if(disk.free[i]){
    80004d08:	01874683          	lbu	a3,24(a4)
    80004d0c:	fee9                	bnez	a3,80004ce6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004d0e:	2785                	addiw	a5,a5,1
    80004d10:	0705                	addi	a4,a4,1
    80004d12:	fe979be3          	bne	a5,s1,80004d08 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004d16:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004d1a:	01205d63          	blez	s2,80004d34 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004d1e:	fa042503          	lw	a0,-96(s0)
    80004d22:	d41ff0ef          	jal	80004a62 <free_desc>
      for(int j = 0; j < i; j++)
    80004d26:	4785                	li	a5,1
    80004d28:	0127d663          	bge	a5,s2,80004d34 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004d2c:	fa442503          	lw	a0,-92(s0)
    80004d30:	d33ff0ef          	jal	80004a62 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d34:	00014597          	auipc	a1,0x14
    80004d38:	57458593          	addi	a1,a1,1396 # 800192a8 <disk+0x128>
    80004d3c:	00014517          	auipc	a0,0x14
    80004d40:	45c50513          	addi	a0,a0,1116 # 80019198 <disk+0x18>
    80004d44:	eb8fc0ef          	jal	800013fc <sleep>
  for(int i = 0; i < 3; i++){
    80004d48:	fa040613          	addi	a2,s0,-96
    80004d4c:	4901                	li	s2,0
    80004d4e:	b77d                	j	80004cfc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d50:	fa042503          	lw	a0,-96(s0)
    80004d54:	00451693          	slli	a3,a0,0x4

  if(write)
    80004d58:	00014797          	auipc	a5,0x14
    80004d5c:	42878793          	addi	a5,a5,1064 # 80019180 <disk>
    80004d60:	00451713          	slli	a4,a0,0x4
    80004d64:	0a070713          	addi	a4,a4,160
    80004d68:	973e                	add	a4,a4,a5
    80004d6a:	01603633          	snez	a2,s6
    80004d6e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004d70:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004d74:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d78:	6398                	ld	a4,0(a5)
    80004d7a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d7c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004d80:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d82:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004d84:	6390                	ld	a2,0(a5)
    80004d86:	00d60833          	add	a6,a2,a3
    80004d8a:	4741                	li	a4,16
    80004d8c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004d90:	4585                	li	a1,1
    80004d92:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004d96:	fa442703          	lw	a4,-92(s0)
    80004d9a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004d9e:	0712                	slli	a4,a4,0x4
    80004da0:	963a                	add	a2,a2,a4
    80004da2:	05898813          	addi	a6,s3,88
    80004da6:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004daa:	0007b883          	ld	a7,0(a5)
    80004dae:	9746                	add	a4,a4,a7
    80004db0:	40000613          	li	a2,1024
    80004db4:	c710                	sw	a2,8(a4)
  if(write)
    80004db6:	001b3613          	seqz	a2,s6
    80004dba:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004dbe:	8e4d                	or	a2,a2,a1
    80004dc0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004dc4:	fa842603          	lw	a2,-88(s0)
    80004dc8:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004dcc:	00451813          	slli	a6,a0,0x4
    80004dd0:	02080813          	addi	a6,a6,32
    80004dd4:	983e                	add	a6,a6,a5
    80004dd6:	577d                	li	a4,-1
    80004dd8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004ddc:	0612                	slli	a2,a2,0x4
    80004dde:	98b2                	add	a7,a7,a2
    80004de0:	03068713          	addi	a4,a3,48
    80004de4:	973e                	add	a4,a4,a5
    80004de6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004dea:	6398                	ld	a4,0(a5)
    80004dec:	9732                	add	a4,a4,a2
    80004dee:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004df0:	4689                	li	a3,2
    80004df2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004df6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004dfa:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004dfe:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004e02:	6794                	ld	a3,8(a5)
    80004e04:	0026d703          	lhu	a4,2(a3)
    80004e08:	8b1d                	andi	a4,a4,7
    80004e0a:	0706                	slli	a4,a4,0x1
    80004e0c:	96ba                	add	a3,a3,a4
    80004e0e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004e12:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004e16:	6798                	ld	a4,8(a5)
    80004e18:	00275783          	lhu	a5,2(a4)
    80004e1c:	2785                	addiw	a5,a5,1
    80004e1e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004e22:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004e26:	100017b7          	lui	a5,0x10001
    80004e2a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004e2e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004e32:	00014917          	auipc	s2,0x14
    80004e36:	47690913          	addi	s2,s2,1142 # 800192a8 <disk+0x128>
  while(b->disk == 1) {
    80004e3a:	84ae                	mv	s1,a1
    80004e3c:	00b79a63          	bne	a5,a1,80004e50 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004e40:	85ca                	mv	a1,s2
    80004e42:	854e                	mv	a0,s3
    80004e44:	db8fc0ef          	jal	800013fc <sleep>
  while(b->disk == 1) {
    80004e48:	0049a783          	lw	a5,4(s3)
    80004e4c:	fe978ae3          	beq	a5,s1,80004e40 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004e50:	fa042903          	lw	s2,-96(s0)
    80004e54:	00491713          	slli	a4,s2,0x4
    80004e58:	02070713          	addi	a4,a4,32
    80004e5c:	00014797          	auipc	a5,0x14
    80004e60:	32478793          	addi	a5,a5,804 # 80019180 <disk>
    80004e64:	97ba                	add	a5,a5,a4
    80004e66:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004e6a:	00014997          	auipc	s3,0x14
    80004e6e:	31698993          	addi	s3,s3,790 # 80019180 <disk>
    80004e72:	00491713          	slli	a4,s2,0x4
    80004e76:	0009b783          	ld	a5,0(s3)
    80004e7a:	97ba                	add	a5,a5,a4
    80004e7c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004e80:	854a                	mv	a0,s2
    80004e82:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004e86:	bddff0ef          	jal	80004a62 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004e8a:	8885                	andi	s1,s1,1
    80004e8c:	f0fd                	bnez	s1,80004e72 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004e8e:	00014517          	auipc	a0,0x14
    80004e92:	41a50513          	addi	a0,a0,1050 # 800192a8 <disk+0x128>
    80004e96:	489000ef          	jal	80005b1e <release>
}
    80004e9a:	60e6                	ld	ra,88(sp)
    80004e9c:	6446                	ld	s0,80(sp)
    80004e9e:	64a6                	ld	s1,72(sp)
    80004ea0:	6906                	ld	s2,64(sp)
    80004ea2:	79e2                	ld	s3,56(sp)
    80004ea4:	7a42                	ld	s4,48(sp)
    80004ea6:	7aa2                	ld	s5,40(sp)
    80004ea8:	7b02                	ld	s6,32(sp)
    80004eaa:	6be2                	ld	s7,24(sp)
    80004eac:	6c42                	ld	s8,16(sp)
    80004eae:	6125                	addi	sp,sp,96
    80004eb0:	8082                	ret

0000000080004eb2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004eb2:	1101                	addi	sp,sp,-32
    80004eb4:	ec06                	sd	ra,24(sp)
    80004eb6:	e822                	sd	s0,16(sp)
    80004eb8:	e426                	sd	s1,8(sp)
    80004eba:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004ebc:	00014497          	auipc	s1,0x14
    80004ec0:	2c448493          	addi	s1,s1,708 # 80019180 <disk>
    80004ec4:	00014517          	auipc	a0,0x14
    80004ec8:	3e450513          	addi	a0,a0,996 # 800192a8 <disk+0x128>
    80004ecc:	3bf000ef          	jal	80005a8a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004ed0:	100017b7          	lui	a5,0x10001
    80004ed4:	53bc                	lw	a5,96(a5)
    80004ed6:	8b8d                	andi	a5,a5,3
    80004ed8:	10001737          	lui	a4,0x10001
    80004edc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004ede:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004ee2:	689c                	ld	a5,16(s1)
    80004ee4:	0204d703          	lhu	a4,32(s1)
    80004ee8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004eec:	04f70863          	beq	a4,a5,80004f3c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004ef0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004ef4:	6898                	ld	a4,16(s1)
    80004ef6:	0204d783          	lhu	a5,32(s1)
    80004efa:	8b9d                	andi	a5,a5,7
    80004efc:	078e                	slli	a5,a5,0x3
    80004efe:	97ba                	add	a5,a5,a4
    80004f00:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004f02:	00479713          	slli	a4,a5,0x4
    80004f06:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004f0a:	9726                	add	a4,a4,s1
    80004f0c:	01074703          	lbu	a4,16(a4)
    80004f10:	e329                	bnez	a4,80004f52 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004f12:	0792                	slli	a5,a5,0x4
    80004f14:	02078793          	addi	a5,a5,32
    80004f18:	97a6                	add	a5,a5,s1
    80004f1a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004f1c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004f20:	d28fc0ef          	jal	80001448 <wakeup>

    disk.used_idx += 1;
    80004f24:	0204d783          	lhu	a5,32(s1)
    80004f28:	2785                	addiw	a5,a5,1
    80004f2a:	17c2                	slli	a5,a5,0x30
    80004f2c:	93c1                	srli	a5,a5,0x30
    80004f2e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004f32:	6898                	ld	a4,16(s1)
    80004f34:	00275703          	lhu	a4,2(a4)
    80004f38:	faf71ce3          	bne	a4,a5,80004ef0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004f3c:	00014517          	auipc	a0,0x14
    80004f40:	36c50513          	addi	a0,a0,876 # 800192a8 <disk+0x128>
    80004f44:	3db000ef          	jal	80005b1e <release>
}
    80004f48:	60e2                	ld	ra,24(sp)
    80004f4a:	6442                	ld	s0,16(sp)
    80004f4c:	64a2                	ld	s1,8(sp)
    80004f4e:	6105                	addi	sp,sp,32
    80004f50:	8082                	ret
      panic("virtio_disk_intr status");
    80004f52:	00002517          	auipc	a0,0x2
    80004f56:	74650513          	addi	a0,a0,1862 # 80007698 <etext+0x698>
    80004f5a:	08f000ef          	jal	800057e8 <panic>

0000000080004f5e <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004f5e:	1141                	addi	sp,sp,-16
    80004f60:	e406                	sd	ra,8(sp)
    80004f62:	e022                	sd	s0,0(sp)
    80004f64:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004f66:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004f6a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004f6e:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004f72:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004f76:	577d                	li	a4,-1
    80004f78:	177e                	slli	a4,a4,0x3f
    80004f7a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004f7c:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004f80:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004f84:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004f88:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004f8c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004f90:	000f4737          	lui	a4,0xf4
    80004f94:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004f98:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004f9a:	14d79073          	csrw	stimecmp,a5
}
    80004f9e:	60a2                	ld	ra,8(sp)
    80004fa0:	6402                	ld	s0,0(sp)
    80004fa2:	0141                	addi	sp,sp,16
    80004fa4:	8082                	ret

0000000080004fa6 <start>:
{
    80004fa6:	1141                	addi	sp,sp,-16
    80004fa8:	e406                	sd	ra,8(sp)
    80004faa:	e022                	sd	s0,0(sp)
    80004fac:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004fae:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004fb2:	7779                	lui	a4,0xffffe
    80004fb4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdd467>
    80004fb8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004fba:	6705                	lui	a4,0x1
    80004fbc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004fc0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004fc2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004fc6:	ffffb797          	auipc	a5,0xffffb
    80004fca:	34e78793          	addi	a5,a5,846 # 80000314 <main>
    80004fce:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004fd2:	4781                	li	a5,0
    80004fd4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004fd8:	67c1                	lui	a5,0x10
    80004fda:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004fdc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004fe0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004fe4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004fe8:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004fec:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004ff0:	57fd                	li	a5,-1
    80004ff2:	83a9                	srli	a5,a5,0xa
    80004ff4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004ff8:	47bd                	li	a5,15
    80004ffa:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004ffe:	f61ff0ef          	jal	80004f5e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005002:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005006:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005008:	823e                	mv	tp,a5
  asm volatile("mret");
    8000500a:	30200073          	mret
}
    8000500e:	60a2                	ld	ra,8(sp)
    80005010:	6402                	ld	s0,0(sp)
    80005012:	0141                	addi	sp,sp,16
    80005014:	8082                	ret

0000000080005016 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005016:	7119                	addi	sp,sp,-128
    80005018:	fc86                	sd	ra,120(sp)
    8000501a:	f8a2                	sd	s0,112(sp)
    8000501c:	f4a6                	sd	s1,104(sp)
    8000501e:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005020:	06c05b63          	blez	a2,80005096 <consolewrite+0x80>
    80005024:	f0ca                	sd	s2,96(sp)
    80005026:	ecce                	sd	s3,88(sp)
    80005028:	e8d2                	sd	s4,80(sp)
    8000502a:	e4d6                	sd	s5,72(sp)
    8000502c:	e0da                	sd	s6,64(sp)
    8000502e:	fc5e                	sd	s7,56(sp)
    80005030:	f862                	sd	s8,48(sp)
    80005032:	f466                	sd	s9,40(sp)
    80005034:	f06a                	sd	s10,32(sp)
    80005036:	8b2a                	mv	s6,a0
    80005038:	8bae                	mv	s7,a1
    8000503a:	8a32                	mv	s4,a2
  int i = 0;
    8000503c:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    8000503e:	02000c93          	li	s9,32
    80005042:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005046:	f8040a93          	addi	s5,s0,-128
    8000504a:	5c7d                	li	s8,-1
    8000504c:	a025                	j	80005074 <consolewrite+0x5e>
    if(nn > n - i)
    8000504e:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005052:	86ce                	mv	a3,s3
    80005054:	01748633          	add	a2,s1,s7
    80005058:	85da                	mv	a1,s6
    8000505a:	8556                	mv	a0,s5
    8000505c:	f44fc0ef          	jal	800017a0 <either_copyin>
    80005060:	03850d63          	beq	a0,s8,8000509a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80005064:	85ce                	mv	a1,s3
    80005066:	8556                	mv	a0,s5
    80005068:	017000ef          	jal	8000587e <uartwrite>
    i += nn;
    8000506c:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005070:	0144d963          	bge	s1,s4,80005082 <consolewrite+0x6c>
    if(nn > n - i)
    80005074:	409a07bb          	subw	a5,s4,s1
    80005078:	893e                	mv	s2,a5
    8000507a:	fcfcdae3          	bge	s9,a5,8000504e <consolewrite+0x38>
    8000507e:	896a                	mv	s2,s10
    80005080:	b7f9                	j	8000504e <consolewrite+0x38>
    80005082:	7906                	ld	s2,96(sp)
    80005084:	69e6                	ld	s3,88(sp)
    80005086:	6a46                	ld	s4,80(sp)
    80005088:	6aa6                	ld	s5,72(sp)
    8000508a:	6b06                	ld	s6,64(sp)
    8000508c:	7be2                	ld	s7,56(sp)
    8000508e:	7c42                	ld	s8,48(sp)
    80005090:	7ca2                	ld	s9,40(sp)
    80005092:	7d02                	ld	s10,32(sp)
    80005094:	a821                	j	800050ac <consolewrite+0x96>
  int i = 0;
    80005096:	4481                	li	s1,0
    80005098:	a811                	j	800050ac <consolewrite+0x96>
    8000509a:	7906                	ld	s2,96(sp)
    8000509c:	69e6                	ld	s3,88(sp)
    8000509e:	6a46                	ld	s4,80(sp)
    800050a0:	6aa6                	ld	s5,72(sp)
    800050a2:	6b06                	ld	s6,64(sp)
    800050a4:	7be2                	ld	s7,56(sp)
    800050a6:	7c42                	ld	s8,48(sp)
    800050a8:	7ca2                	ld	s9,40(sp)
    800050aa:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    800050ac:	8526                	mv	a0,s1
    800050ae:	70e6                	ld	ra,120(sp)
    800050b0:	7446                	ld	s0,112(sp)
    800050b2:	74a6                	ld	s1,104(sp)
    800050b4:	6109                	addi	sp,sp,128
    800050b6:	8082                	ret

00000000800050b8 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800050b8:	711d                	addi	sp,sp,-96
    800050ba:	ec86                	sd	ra,88(sp)
    800050bc:	e8a2                	sd	s0,80(sp)
    800050be:	e4a6                	sd	s1,72(sp)
    800050c0:	e0ca                	sd	s2,64(sp)
    800050c2:	fc4e                	sd	s3,56(sp)
    800050c4:	f852                	sd	s4,48(sp)
    800050c6:	f05a                	sd	s6,32(sp)
    800050c8:	ec5e                	sd	s7,24(sp)
    800050ca:	1080                	addi	s0,sp,96
    800050cc:	8b2a                	mv	s6,a0
    800050ce:	8a2e                	mv	s4,a1
    800050d0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800050d2:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    800050d4:	0001c517          	auipc	a0,0x1c
    800050d8:	1ec50513          	addi	a0,a0,492 # 800212c0 <cons>
    800050dc:	1af000ef          	jal	80005a8a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800050e0:	0001c497          	auipc	s1,0x1c
    800050e4:	1e048493          	addi	s1,s1,480 # 800212c0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800050e8:	0001c917          	auipc	s2,0x1c
    800050ec:	27090913          	addi	s2,s2,624 # 80021358 <cons+0x98>
  while(n > 0){
    800050f0:	0b305b63          	blez	s3,800051a6 <consoleread+0xee>
    while(cons.r == cons.w){
    800050f4:	0984a783          	lw	a5,152(s1)
    800050f8:	09c4a703          	lw	a4,156(s1)
    800050fc:	0af71063          	bne	a4,a5,8000519c <consoleread+0xe4>
      if(killed(myproc())){
    80005100:	c89fb0ef          	jal	80000d88 <myproc>
    80005104:	d34fc0ef          	jal	80001638 <killed>
    80005108:	e12d                	bnez	a0,8000516a <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000510a:	85a6                	mv	a1,s1
    8000510c:	854a                	mv	a0,s2
    8000510e:	aeefc0ef          	jal	800013fc <sleep>
    while(cons.r == cons.w){
    80005112:	0984a783          	lw	a5,152(s1)
    80005116:	09c4a703          	lw	a4,156(s1)
    8000511a:	fef703e3          	beq	a4,a5,80005100 <consoleread+0x48>
    8000511e:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005120:	0001c717          	auipc	a4,0x1c
    80005124:	1a070713          	addi	a4,a4,416 # 800212c0 <cons>
    80005128:	0017869b          	addiw	a3,a5,1
    8000512c:	08d72c23          	sw	a3,152(a4)
    80005130:	07f7f693          	andi	a3,a5,127
    80005134:	9736                	add	a4,a4,a3
    80005136:	01874703          	lbu	a4,24(a4)
    8000513a:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    8000513e:	4691                	li	a3,4
    80005140:	04da8663          	beq	s5,a3,8000518c <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005144:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005148:	4685                	li	a3,1
    8000514a:	faf40613          	addi	a2,s0,-81
    8000514e:	85d2                	mv	a1,s4
    80005150:	855a                	mv	a0,s6
    80005152:	e04fc0ef          	jal	80001756 <either_copyout>
    80005156:	57fd                	li	a5,-1
    80005158:	04f50663          	beq	a0,a5,800051a4 <consoleread+0xec>
      break;

    dst++;
    8000515c:	0a05                	addi	s4,s4,1
    --n;
    8000515e:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005160:	47a9                	li	a5,10
    80005162:	04fa8b63          	beq	s5,a5,800051b8 <consoleread+0x100>
    80005166:	7aa2                	ld	s5,40(sp)
    80005168:	b761                	j	800050f0 <consoleread+0x38>
        release(&cons.lock);
    8000516a:	0001c517          	auipc	a0,0x1c
    8000516e:	15650513          	addi	a0,a0,342 # 800212c0 <cons>
    80005172:	1ad000ef          	jal	80005b1e <release>
        return -1;
    80005176:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005178:	60e6                	ld	ra,88(sp)
    8000517a:	6446                	ld	s0,80(sp)
    8000517c:	64a6                	ld	s1,72(sp)
    8000517e:	6906                	ld	s2,64(sp)
    80005180:	79e2                	ld	s3,56(sp)
    80005182:	7a42                	ld	s4,48(sp)
    80005184:	7b02                	ld	s6,32(sp)
    80005186:	6be2                	ld	s7,24(sp)
    80005188:	6125                	addi	sp,sp,96
    8000518a:	8082                	ret
      if(n < target){
    8000518c:	0179fa63          	bgeu	s3,s7,800051a0 <consoleread+0xe8>
        cons.r--;
    80005190:	0001c717          	auipc	a4,0x1c
    80005194:	1cf72423          	sw	a5,456(a4) # 80021358 <cons+0x98>
    80005198:	7aa2                	ld	s5,40(sp)
    8000519a:	a031                	j	800051a6 <consoleread+0xee>
    8000519c:	f456                	sd	s5,40(sp)
    8000519e:	b749                	j	80005120 <consoleread+0x68>
    800051a0:	7aa2                	ld	s5,40(sp)
    800051a2:	a011                	j	800051a6 <consoleread+0xee>
    800051a4:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    800051a6:	0001c517          	auipc	a0,0x1c
    800051aa:	11a50513          	addi	a0,a0,282 # 800212c0 <cons>
    800051ae:	171000ef          	jal	80005b1e <release>
  return target - n;
    800051b2:	413b853b          	subw	a0,s7,s3
    800051b6:	b7c9                	j	80005178 <consoleread+0xc0>
    800051b8:	7aa2                	ld	s5,40(sp)
    800051ba:	b7f5                	j	800051a6 <consoleread+0xee>

00000000800051bc <consputc>:
{
    800051bc:	1141                	addi	sp,sp,-16
    800051be:	e406                	sd	ra,8(sp)
    800051c0:	e022                	sd	s0,0(sp)
    800051c2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800051c4:	10000793          	li	a5,256
    800051c8:	00f50863          	beq	a0,a5,800051d8 <consputc+0x1c>
    uartputc_sync(c);
    800051cc:	746000ef          	jal	80005912 <uartputc_sync>
}
    800051d0:	60a2                	ld	ra,8(sp)
    800051d2:	6402                	ld	s0,0(sp)
    800051d4:	0141                	addi	sp,sp,16
    800051d6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800051d8:	4521                	li	a0,8
    800051da:	738000ef          	jal	80005912 <uartputc_sync>
    800051de:	02000513          	li	a0,32
    800051e2:	730000ef          	jal	80005912 <uartputc_sync>
    800051e6:	4521                	li	a0,8
    800051e8:	72a000ef          	jal	80005912 <uartputc_sync>
    800051ec:	b7d5                	j	800051d0 <consputc+0x14>

00000000800051ee <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800051ee:	1101                	addi	sp,sp,-32
    800051f0:	ec06                	sd	ra,24(sp)
    800051f2:	e822                	sd	s0,16(sp)
    800051f4:	e426                	sd	s1,8(sp)
    800051f6:	1000                	addi	s0,sp,32
    800051f8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800051fa:	0001c517          	auipc	a0,0x1c
    800051fe:	0c650513          	addi	a0,a0,198 # 800212c0 <cons>
    80005202:	089000ef          	jal	80005a8a <acquire>

  switch(c){
    80005206:	47d5                	li	a5,21
    80005208:	08f48d63          	beq	s1,a5,800052a2 <consoleintr+0xb4>
    8000520c:	0297c563          	blt	a5,s1,80005236 <consoleintr+0x48>
    80005210:	47a1                	li	a5,8
    80005212:	0ef48263          	beq	s1,a5,800052f6 <consoleintr+0x108>
    80005216:	47c1                	li	a5,16
    80005218:	10f49363          	bne	s1,a5,8000531e <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    8000521c:	dcefc0ef          	jal	800017ea <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005220:	0001c517          	auipc	a0,0x1c
    80005224:	0a050513          	addi	a0,a0,160 # 800212c0 <cons>
    80005228:	0f7000ef          	jal	80005b1e <release>
}
    8000522c:	60e2                	ld	ra,24(sp)
    8000522e:	6442                	ld	s0,16(sp)
    80005230:	64a2                	ld	s1,8(sp)
    80005232:	6105                	addi	sp,sp,32
    80005234:	8082                	ret
  switch(c){
    80005236:	07f00793          	li	a5,127
    8000523a:	0af48e63          	beq	s1,a5,800052f6 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000523e:	0001c717          	auipc	a4,0x1c
    80005242:	08270713          	addi	a4,a4,130 # 800212c0 <cons>
    80005246:	0a072783          	lw	a5,160(a4)
    8000524a:	09872703          	lw	a4,152(a4)
    8000524e:	9f99                	subw	a5,a5,a4
    80005250:	07f00713          	li	a4,127
    80005254:	fcf766e3          	bltu	a4,a5,80005220 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005258:	47b5                	li	a5,13
    8000525a:	0cf48563          	beq	s1,a5,80005324 <consoleintr+0x136>
      consputc(c);
    8000525e:	8526                	mv	a0,s1
    80005260:	f5dff0ef          	jal	800051bc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005264:	0001c717          	auipc	a4,0x1c
    80005268:	05c70713          	addi	a4,a4,92 # 800212c0 <cons>
    8000526c:	0a072683          	lw	a3,160(a4)
    80005270:	0016879b          	addiw	a5,a3,1
    80005274:	863e                	mv	a2,a5
    80005276:	0af72023          	sw	a5,160(a4)
    8000527a:	07f6f693          	andi	a3,a3,127
    8000527e:	9736                	add	a4,a4,a3
    80005280:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005284:	ff648713          	addi	a4,s1,-10
    80005288:	c371                	beqz	a4,8000534c <consoleintr+0x15e>
    8000528a:	14f1                	addi	s1,s1,-4
    8000528c:	c0e1                	beqz	s1,8000534c <consoleintr+0x15e>
    8000528e:	0001c717          	auipc	a4,0x1c
    80005292:	0ca72703          	lw	a4,202(a4) # 80021358 <cons+0x98>
    80005296:	9f99                	subw	a5,a5,a4
    80005298:	08000713          	li	a4,128
    8000529c:	f8e792e3          	bne	a5,a4,80005220 <consoleintr+0x32>
    800052a0:	a075                	j	8000534c <consoleintr+0x15e>
    800052a2:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800052a4:	0001c717          	auipc	a4,0x1c
    800052a8:	01c70713          	addi	a4,a4,28 # 800212c0 <cons>
    800052ac:	0a072783          	lw	a5,160(a4)
    800052b0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800052b4:	0001c497          	auipc	s1,0x1c
    800052b8:	00c48493          	addi	s1,s1,12 # 800212c0 <cons>
    while(cons.e != cons.w &&
    800052bc:	4929                	li	s2,10
    800052be:	02f70863          	beq	a4,a5,800052ee <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800052c2:	37fd                	addiw	a5,a5,-1
    800052c4:	07f7f713          	andi	a4,a5,127
    800052c8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800052ca:	01874703          	lbu	a4,24(a4)
    800052ce:	03270263          	beq	a4,s2,800052f2 <consoleintr+0x104>
      cons.e--;
    800052d2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800052d6:	10000513          	li	a0,256
    800052da:	ee3ff0ef          	jal	800051bc <consputc>
    while(cons.e != cons.w &&
    800052de:	0a04a783          	lw	a5,160(s1)
    800052e2:	09c4a703          	lw	a4,156(s1)
    800052e6:	fcf71ee3          	bne	a4,a5,800052c2 <consoleintr+0xd4>
    800052ea:	6902                	ld	s2,0(sp)
    800052ec:	bf15                	j	80005220 <consoleintr+0x32>
    800052ee:	6902                	ld	s2,0(sp)
    800052f0:	bf05                	j	80005220 <consoleintr+0x32>
    800052f2:	6902                	ld	s2,0(sp)
    800052f4:	b735                	j	80005220 <consoleintr+0x32>
    if(cons.e != cons.w){
    800052f6:	0001c717          	auipc	a4,0x1c
    800052fa:	fca70713          	addi	a4,a4,-54 # 800212c0 <cons>
    800052fe:	0a072783          	lw	a5,160(a4)
    80005302:	09c72703          	lw	a4,156(a4)
    80005306:	f0f70de3          	beq	a4,a5,80005220 <consoleintr+0x32>
      cons.e--;
    8000530a:	37fd                	addiw	a5,a5,-1
    8000530c:	0001c717          	auipc	a4,0x1c
    80005310:	04f72a23          	sw	a5,84(a4) # 80021360 <cons+0xa0>
      consputc(BACKSPACE);
    80005314:	10000513          	li	a0,256
    80005318:	ea5ff0ef          	jal	800051bc <consputc>
    8000531c:	b711                	j	80005220 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000531e:	f00481e3          	beqz	s1,80005220 <consoleintr+0x32>
    80005322:	bf31                	j	8000523e <consoleintr+0x50>
      consputc(c);
    80005324:	4529                	li	a0,10
    80005326:	e97ff0ef          	jal	800051bc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000532a:	0001c797          	auipc	a5,0x1c
    8000532e:	f9678793          	addi	a5,a5,-106 # 800212c0 <cons>
    80005332:	0a07a703          	lw	a4,160(a5)
    80005336:	0017069b          	addiw	a3,a4,1
    8000533a:	8636                	mv	a2,a3
    8000533c:	0ad7a023          	sw	a3,160(a5)
    80005340:	07f77713          	andi	a4,a4,127
    80005344:	97ba                	add	a5,a5,a4
    80005346:	4729                	li	a4,10
    80005348:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000534c:	0001c797          	auipc	a5,0x1c
    80005350:	00c7a823          	sw	a2,16(a5) # 8002135c <cons+0x9c>
        wakeup(&cons.r);
    80005354:	0001c517          	auipc	a0,0x1c
    80005358:	00450513          	addi	a0,a0,4 # 80021358 <cons+0x98>
    8000535c:	8ecfc0ef          	jal	80001448 <wakeup>
    80005360:	b5c1                	j	80005220 <consoleintr+0x32>

0000000080005362 <consoleinit>:

void
consoleinit(void)
{
    80005362:	1141                	addi	sp,sp,-16
    80005364:	e406                	sd	ra,8(sp)
    80005366:	e022                	sd	s0,0(sp)
    80005368:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000536a:	00002597          	auipc	a1,0x2
    8000536e:	34658593          	addi	a1,a1,838 # 800076b0 <etext+0x6b0>
    80005372:	0001c517          	auipc	a0,0x1c
    80005376:	f4e50513          	addi	a0,a0,-178 # 800212c0 <cons>
    8000537a:	686000ef          	jal	80005a00 <initlock>

  uartinit();
    8000537e:	4aa000ef          	jal	80005828 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005382:	00013797          	auipc	a5,0x13
    80005386:	da678793          	addi	a5,a5,-602 # 80018128 <devsw>
    8000538a:	00000717          	auipc	a4,0x0
    8000538e:	d2e70713          	addi	a4,a4,-722 # 800050b8 <consoleread>
    80005392:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005394:	00000717          	auipc	a4,0x0
    80005398:	c8270713          	addi	a4,a4,-894 # 80005016 <consolewrite>
    8000539c:	ef98                	sd	a4,24(a5)
}
    8000539e:	60a2                	ld	ra,8(sp)
    800053a0:	6402                	ld	s0,0(sp)
    800053a2:	0141                	addi	sp,sp,16
    800053a4:	8082                	ret

00000000800053a6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800053a6:	7139                	addi	sp,sp,-64
    800053a8:	fc06                	sd	ra,56(sp)
    800053aa:	f822                	sd	s0,48(sp)
    800053ac:	f04a                	sd	s2,32(sp)
    800053ae:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800053b0:	c219                	beqz	a2,800053b6 <printint+0x10>
    800053b2:	08054163          	bltz	a0,80005434 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    800053b6:	4301                	li	t1,0

  i = 0;
    800053b8:	fc840913          	addi	s2,s0,-56
    x = xx;
    800053bc:	86ca                	mv	a3,s2
  i = 0;
    800053be:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800053c0:	00002817          	auipc	a6,0x2
    800053c4:	47080813          	addi	a6,a6,1136 # 80007830 <digits>
    800053c8:	88ba                	mv	a7,a4
    800053ca:	0017061b          	addiw	a2,a4,1
    800053ce:	8732                	mv	a4,a2
    800053d0:	02b577b3          	remu	a5,a0,a1
    800053d4:	97c2                	add	a5,a5,a6
    800053d6:	0007c783          	lbu	a5,0(a5)
    800053da:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800053de:	87aa                	mv	a5,a0
    800053e0:	02b55533          	divu	a0,a0,a1
    800053e4:	0685                	addi	a3,a3,1
    800053e6:	feb7f1e3          	bgeu	a5,a1,800053c8 <printint+0x22>

  if(sign)
    800053ea:	00030c63          	beqz	t1,80005402 <printint+0x5c>
    buf[i++] = '-';
    800053ee:	fe060793          	addi	a5,a2,-32
    800053f2:	00878633          	add	a2,a5,s0
    800053f6:	02d00793          	li	a5,45
    800053fa:	fef60423          	sb	a5,-24(a2)
    800053fe:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80005402:	02e05463          	blez	a4,8000542a <printint+0x84>
    80005406:	f426                	sd	s1,40(sp)
    80005408:	377d                	addiw	a4,a4,-1
    8000540a:	00e904b3          	add	s1,s2,a4
    8000540e:	197d                	addi	s2,s2,-1
    80005410:	993a                	add	s2,s2,a4
    80005412:	1702                	slli	a4,a4,0x20
    80005414:	9301                	srli	a4,a4,0x20
    80005416:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000541a:	0004c503          	lbu	a0,0(s1)
    8000541e:	d9fff0ef          	jal	800051bc <consputc>
  while(--i >= 0)
    80005422:	14fd                	addi	s1,s1,-1
    80005424:	ff249be3          	bne	s1,s2,8000541a <printint+0x74>
    80005428:	74a2                	ld	s1,40(sp)
}
    8000542a:	70e2                	ld	ra,56(sp)
    8000542c:	7442                	ld	s0,48(sp)
    8000542e:	7902                	ld	s2,32(sp)
    80005430:	6121                	addi	sp,sp,64
    80005432:	8082                	ret
    x = -xx;
    80005434:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005438:	4305                	li	t1,1
    x = -xx;
    8000543a:	bfbd                	j	800053b8 <printint+0x12>

000000008000543c <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000543c:	7131                	addi	sp,sp,-192
    8000543e:	fc86                	sd	ra,120(sp)
    80005440:	f8a2                	sd	s0,112(sp)
    80005442:	f0ca                	sd	s2,96(sp)
    80005444:	0100                	addi	s0,sp,128
    80005446:	892a                	mv	s2,a0
    80005448:	e40c                	sd	a1,8(s0)
    8000544a:	e810                	sd	a2,16(s0)
    8000544c:	ec14                	sd	a3,24(s0)
    8000544e:	f018                	sd	a4,32(s0)
    80005450:	f41c                	sd	a5,40(s0)
    80005452:	03043823          	sd	a6,48(s0)
    80005456:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    8000545a:	00002797          	auipc	a5,0x2
    8000545e:	4267a783          	lw	a5,1062(a5) # 80007880 <panicking>
    80005462:	cf9d                	beqz	a5,800054a0 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005464:	00840793          	addi	a5,s0,8
    80005468:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000546c:	00094503          	lbu	a0,0(s2)
    80005470:	22050663          	beqz	a0,8000569c <printf+0x260>
    80005474:	f4a6                	sd	s1,104(sp)
    80005476:	ecce                	sd	s3,88(sp)
    80005478:	e8d2                	sd	s4,80(sp)
    8000547a:	e4d6                	sd	s5,72(sp)
    8000547c:	e0da                	sd	s6,64(sp)
    8000547e:	fc5e                	sd	s7,56(sp)
    80005480:	f862                	sd	s8,48(sp)
    80005482:	f06a                	sd	s10,32(sp)
    80005484:	ec6e                	sd	s11,24(sp)
    80005486:	4a01                	li	s4,0
    if(cx != '%'){
    80005488:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000548c:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005490:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005494:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80005498:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000549a:	06400b93          	li	s7,100
    8000549e:	a015                	j	800054c2 <printf+0x86>
    acquire(&pr.lock);
    800054a0:	0001c517          	auipc	a0,0x1c
    800054a4:	ec850513          	addi	a0,a0,-312 # 80021368 <pr>
    800054a8:	5e2000ef          	jal	80005a8a <acquire>
    800054ac:	bf65                	j	80005464 <printf+0x28>
      consputc(cx);
    800054ae:	d0fff0ef          	jal	800051bc <consputc>
      continue;
    800054b2:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800054b4:	2485                	addiw	s1,s1,1
    800054b6:	8a26                	mv	s4,s1
    800054b8:	94ca                	add	s1,s1,s2
    800054ba:	0004c503          	lbu	a0,0(s1)
    800054be:	1c050663          	beqz	a0,8000568a <printf+0x24e>
    if(cx != '%'){
    800054c2:	ff3516e3          	bne	a0,s3,800054ae <printf+0x72>
    i++;
    800054c6:	001a079b          	addiw	a5,s4,1
    800054ca:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800054cc:	00f90733          	add	a4,s2,a5
    800054d0:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800054d4:	200a8963          	beqz	s5,800056e6 <printf+0x2aa>
    800054d8:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    800054dc:	1e068c63          	beqz	a3,800056d4 <printf+0x298>
    if(c0 == 'd'){
    800054e0:	037a8863          	beq	s5,s7,80005510 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800054e4:	f94a8713          	addi	a4,s5,-108
    800054e8:	00173713          	seqz	a4,a4
    800054ec:	f9c68613          	addi	a2,a3,-100
    800054f0:	ee05                	bnez	a2,80005528 <printf+0xec>
    800054f2:	cb1d                	beqz	a4,80005528 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800054f4:	f8843783          	ld	a5,-120(s0)
    800054f8:	00878713          	addi	a4,a5,8
    800054fc:	f8e43423          	sd	a4,-120(s0)
    80005500:	4605                	li	a2,1
    80005502:	85da                	mv	a1,s6
    80005504:	6388                	ld	a0,0(a5)
    80005506:	ea1ff0ef          	jal	800053a6 <printint>
      i += 1;
    8000550a:	002a049b          	addiw	s1,s4,2
    8000550e:	b75d                	j	800054b4 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    80005510:	f8843783          	ld	a5,-120(s0)
    80005514:	00878713          	addi	a4,a5,8
    80005518:	f8e43423          	sd	a4,-120(s0)
    8000551c:	4605                	li	a2,1
    8000551e:	85da                	mv	a1,s6
    80005520:	4388                	lw	a0,0(a5)
    80005522:	e85ff0ef          	jal	800053a6 <printint>
    80005526:	b779                	j	800054b4 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    80005528:	97ca                	add	a5,a5,s2
    8000552a:	8636                	mv	a2,a3
    8000552c:	0027c683          	lbu	a3,2(a5)
    80005530:	a2c9                	j	800056f2 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005532:	f8843783          	ld	a5,-120(s0)
    80005536:	00878713          	addi	a4,a5,8
    8000553a:	f8e43423          	sd	a4,-120(s0)
    8000553e:	4605                	li	a2,1
    80005540:	45a9                	li	a1,10
    80005542:	6388                	ld	a0,0(a5)
    80005544:	e63ff0ef          	jal	800053a6 <printint>
      i += 2;
    80005548:	003a049b          	addiw	s1,s4,3
    8000554c:	b7a5                	j	800054b4 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000554e:	f8843783          	ld	a5,-120(s0)
    80005552:	00878713          	addi	a4,a5,8
    80005556:	f8e43423          	sd	a4,-120(s0)
    8000555a:	4601                	li	a2,0
    8000555c:	85da                	mv	a1,s6
    8000555e:	0007e503          	lwu	a0,0(a5)
    80005562:	e45ff0ef          	jal	800053a6 <printint>
    80005566:	b7b9                	j	800054b4 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005568:	f8843783          	ld	a5,-120(s0)
    8000556c:	00878713          	addi	a4,a5,8
    80005570:	f8e43423          	sd	a4,-120(s0)
    80005574:	4601                	li	a2,0
    80005576:	85da                	mv	a1,s6
    80005578:	6388                	ld	a0,0(a5)
    8000557a:	e2dff0ef          	jal	800053a6 <printint>
      i += 1;
    8000557e:	002a049b          	addiw	s1,s4,2
    80005582:	bf0d                	j	800054b4 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005584:	f8843783          	ld	a5,-120(s0)
    80005588:	00878713          	addi	a4,a5,8
    8000558c:	f8e43423          	sd	a4,-120(s0)
    80005590:	4601                	li	a2,0
    80005592:	45a9                	li	a1,10
    80005594:	6388                	ld	a0,0(a5)
    80005596:	e11ff0ef          	jal	800053a6 <printint>
      i += 2;
    8000559a:	003a049b          	addiw	s1,s4,3
    8000559e:	bf19                	j	800054b4 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    800055a0:	f8843783          	ld	a5,-120(s0)
    800055a4:	00878713          	addi	a4,a5,8
    800055a8:	f8e43423          	sd	a4,-120(s0)
    800055ac:	4601                	li	a2,0
    800055ae:	45c1                	li	a1,16
    800055b0:	0007e503          	lwu	a0,0(a5)
    800055b4:	df3ff0ef          	jal	800053a6 <printint>
    800055b8:	bdf5                	j	800054b4 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800055ba:	f8843783          	ld	a5,-120(s0)
    800055be:	00878713          	addi	a4,a5,8
    800055c2:	f8e43423          	sd	a4,-120(s0)
    800055c6:	45c1                	li	a1,16
    800055c8:	6388                	ld	a0,0(a5)
    800055ca:	dddff0ef          	jal	800053a6 <printint>
      i += 1;
    800055ce:	002a049b          	addiw	s1,s4,2
    800055d2:	b5cd                	j	800054b4 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800055d4:	f8843783          	ld	a5,-120(s0)
    800055d8:	00878713          	addi	a4,a5,8
    800055dc:	f8e43423          	sd	a4,-120(s0)
    800055e0:	4601                	li	a2,0
    800055e2:	45c1                	li	a1,16
    800055e4:	6388                	ld	a0,0(a5)
    800055e6:	dc1ff0ef          	jal	800053a6 <printint>
      i += 2;
    800055ea:	003a049b          	addiw	s1,s4,3
    800055ee:	b5d9                	j	800054b4 <printf+0x78>
    800055f0:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800055f2:	f8843783          	ld	a5,-120(s0)
    800055f6:	00878713          	addi	a4,a5,8
    800055fa:	f8e43423          	sd	a4,-120(s0)
    800055fe:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80005602:	03000513          	li	a0,48
    80005606:	bb7ff0ef          	jal	800051bc <consputc>
  consputc('x');
    8000560a:	07800513          	li	a0,120
    8000560e:	bafff0ef          	jal	800051bc <consputc>
    80005612:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005614:	00002c97          	auipc	s9,0x2
    80005618:	21cc8c93          	addi	s9,s9,540 # 80007830 <digits>
    8000561c:	03cad793          	srli	a5,s5,0x3c
    80005620:	97e6                	add	a5,a5,s9
    80005622:	0007c503          	lbu	a0,0(a5)
    80005626:	b97ff0ef          	jal	800051bc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000562a:	0a92                	slli	s5,s5,0x4
    8000562c:	3a7d                	addiw	s4,s4,-1
    8000562e:	fe0a17e3          	bnez	s4,8000561c <printf+0x1e0>
    80005632:	7ca2                	ld	s9,40(sp)
    80005634:	b541                	j	800054b4 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80005636:	f8843783          	ld	a5,-120(s0)
    8000563a:	00878713          	addi	a4,a5,8
    8000563e:	f8e43423          	sd	a4,-120(s0)
    80005642:	4388                	lw	a0,0(a5)
    80005644:	b79ff0ef          	jal	800051bc <consputc>
    80005648:	b5b5                	j	800054b4 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    8000564a:	f8843783          	ld	a5,-120(s0)
    8000564e:	00878713          	addi	a4,a5,8
    80005652:	f8e43423          	sd	a4,-120(s0)
    80005656:	0007ba03          	ld	s4,0(a5)
    8000565a:	000a0d63          	beqz	s4,80005674 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000565e:	000a4503          	lbu	a0,0(s4)
    80005662:	e40509e3          	beqz	a0,800054b4 <printf+0x78>
        consputc(*s);
    80005666:	b57ff0ef          	jal	800051bc <consputc>
      for(; *s; s++)
    8000566a:	0a05                	addi	s4,s4,1
    8000566c:	000a4503          	lbu	a0,0(s4)
    80005670:	f97d                	bnez	a0,80005666 <printf+0x22a>
    80005672:	b589                	j	800054b4 <printf+0x78>
        s = "(null)";
    80005674:	00002a17          	auipc	s4,0x2
    80005678:	044a0a13          	addi	s4,s4,68 # 800076b8 <etext+0x6b8>
      for(; *s; s++)
    8000567c:	02800513          	li	a0,40
    80005680:	b7dd                	j	80005666 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005682:	8556                	mv	a0,s5
    80005684:	b39ff0ef          	jal	800051bc <consputc>
    80005688:	b535                	j	800054b4 <printf+0x78>
    8000568a:	74a6                	ld	s1,104(sp)
    8000568c:	69e6                	ld	s3,88(sp)
    8000568e:	6a46                	ld	s4,80(sp)
    80005690:	6aa6                	ld	s5,72(sp)
    80005692:	6b06                	ld	s6,64(sp)
    80005694:	7be2                	ld	s7,56(sp)
    80005696:	7c42                	ld	s8,48(sp)
    80005698:	7d02                	ld	s10,32(sp)
    8000569a:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000569c:	00002797          	auipc	a5,0x2
    800056a0:	1e47a783          	lw	a5,484(a5) # 80007880 <panicking>
    800056a4:	c38d                	beqz	a5,800056c6 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    800056a6:	4501                	li	a0,0
    800056a8:	70e6                	ld	ra,120(sp)
    800056aa:	7446                	ld	s0,112(sp)
    800056ac:	7906                	ld	s2,96(sp)
    800056ae:	6129                	addi	sp,sp,192
    800056b0:	8082                	ret
    800056b2:	74a6                	ld	s1,104(sp)
    800056b4:	69e6                	ld	s3,88(sp)
    800056b6:	6a46                	ld	s4,80(sp)
    800056b8:	6aa6                	ld	s5,72(sp)
    800056ba:	6b06                	ld	s6,64(sp)
    800056bc:	7be2                	ld	s7,56(sp)
    800056be:	7c42                	ld	s8,48(sp)
    800056c0:	7d02                	ld	s10,32(sp)
    800056c2:	6de2                	ld	s11,24(sp)
    800056c4:	bfe1                	j	8000569c <printf+0x260>
    release(&pr.lock);
    800056c6:	0001c517          	auipc	a0,0x1c
    800056ca:	ca250513          	addi	a0,a0,-862 # 80021368 <pr>
    800056ce:	450000ef          	jal	80005b1e <release>
  return 0;
    800056d2:	bfd1                	j	800056a6 <printf+0x26a>
    if(c0 == 'd'){
    800056d4:	e37a8ee3          	beq	s5,s7,80005510 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800056d8:	f94a8713          	addi	a4,s5,-108
    800056dc:	00173713          	seqz	a4,a4
    800056e0:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800056e2:	4781                	li	a5,0
    800056e4:	a00d                	j	80005706 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800056e6:	f94a8713          	addi	a4,s5,-108
    800056ea:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800056ee:	8656                	mv	a2,s5
    800056f0:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800056f2:	f9460793          	addi	a5,a2,-108
    800056f6:	0017b793          	seqz	a5,a5
    800056fa:	8ff9                	and	a5,a5,a4
    800056fc:	f9c68593          	addi	a1,a3,-100
    80005700:	e199                	bnez	a1,80005706 <printf+0x2ca>
    80005702:	e20798e3          	bnez	a5,80005532 <printf+0xf6>
    } else if(c0 == 'u'){
    80005706:	e58a84e3          	beq	s5,s8,8000554e <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    8000570a:	f8b60593          	addi	a1,a2,-117
    8000570e:	e199                	bnez	a1,80005714 <printf+0x2d8>
    80005710:	e4071ce3          	bnez	a4,80005568 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005714:	f8b68593          	addi	a1,a3,-117
    80005718:	e199                	bnez	a1,8000571e <printf+0x2e2>
    8000571a:	e60795e3          	bnez	a5,80005584 <printf+0x148>
    } else if(c0 == 'x'){
    8000571e:	e9aa81e3          	beq	s5,s10,800055a0 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    80005722:	f8860613          	addi	a2,a2,-120
    80005726:	e219                	bnez	a2,8000572c <printf+0x2f0>
    80005728:	e80719e3          	bnez	a4,800055ba <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000572c:	f8868693          	addi	a3,a3,-120
    80005730:	e299                	bnez	a3,80005736 <printf+0x2fa>
    80005732:	ea0791e3          	bnez	a5,800055d4 <printf+0x198>
    } else if(c0 == 'p'){
    80005736:	ebba8de3          	beq	s5,s11,800055f0 <printf+0x1b4>
    } else if(c0 == 'c'){
    8000573a:	06300793          	li	a5,99
    8000573e:	eefa8ce3          	beq	s5,a5,80005636 <printf+0x1fa>
    } else if(c0 == 's'){
    80005742:	07300793          	li	a5,115
    80005746:	f0fa82e3          	beq	s5,a5,8000564a <printf+0x20e>
    } else if(c0 == '%'){
    8000574a:	02500793          	li	a5,37
    8000574e:	f2fa8ae3          	beq	s5,a5,80005682 <printf+0x246>
    } else if(c0 == 0){
    80005752:	f60a80e3          	beqz	s5,800056b2 <printf+0x276>
      consputc('%');
    80005756:	02500513          	li	a0,37
    8000575a:	a63ff0ef          	jal	800051bc <consputc>
      consputc(c0);
    8000575e:	8556                	mv	a0,s5
    80005760:	a5dff0ef          	jal	800051bc <consputc>
    80005764:	bb81                	j	800054b4 <printf+0x78>

0000000080005766 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005766:	1141                	addi	sp,sp,-16
    80005768:	e406                	sd	ra,8(sp)
    8000576a:	e022                	sd	s0,0(sp)
    8000576c:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000576e:	00002597          	auipc	a1,0x2
    80005772:	f5258593          	addi	a1,a1,-174 # 800076c0 <etext+0x6c0>
    80005776:	0001c517          	auipc	a0,0x1c
    8000577a:	bf250513          	addi	a0,a0,-1038 # 80021368 <pr>
    8000577e:	282000ef          	jal	80005a00 <initlock>
}
    80005782:	60a2                	ld	ra,8(sp)
    80005784:	6402                	ld	s0,0(sp)
    80005786:	0141                	addi	sp,sp,16
    80005788:	8082                	ret

000000008000578a <backtrace>:

void
backtrace(void)
{
    8000578a:	7179                	addi	sp,sp,-48
    8000578c:	f406                	sd	ra,40(sp)
    8000578e:	f022                	sd	s0,32(sp)
    80005790:	e84a                	sd	s2,16(sp)
    80005792:	1800                	addi	s0,sp,48
  printf("backtrace:\n");
    80005794:	00002517          	auipc	a0,0x2
    80005798:	f3450513          	addi	a0,a0,-204 # 800076c8 <etext+0x6c8>
    8000579c:	ca1ff0ef          	jal	8000543c <printf>
  asm volatile("mv %0, s0" : "=r" (x) );
    800057a0:	8922                	mv	s2,s0
  uint64 fp = r_fp();                    // current frame pointer (s0)

  // Remember which page this stack lives on
  uint64 stack_page = PGROUNDDOWN(fp);

  while (fp != 0 && PGROUNDDOWN(fp) == stack_page) {
    800057a2:	02090a63          	beqz	s2,800057d6 <backtrace+0x4c>
    800057a6:	ec26                	sd	s1,24(sp)
    800057a8:	e44e                	sd	s3,8(sp)
    800057aa:	e052                	sd	s4,0(sp)
  uint64 fp = r_fp();                    // current frame pointer (s0)
    800057ac:	84ca                	mv	s1,s2
    uint64 ra = *(uint64*)(fp - 8);
    // print the saved return address
    printf("%p\n", (void *)ra);
    800057ae:	00002997          	auipc	s3,0x2
    800057b2:	f2a98993          	addi	s3,s3,-214 # 800076d8 <etext+0x6d8>
  while (fp != 0 && PGROUNDDOWN(fp) == stack_page) {
    800057b6:	6a05                	lui	s4,0x1
    printf("%p\n", (void *)ra);
    800057b8:	ff84b583          	ld	a1,-8(s1)
    800057bc:	854e                	mv	a0,s3
    800057be:	c7fff0ef          	jal	8000543c <printf>

    // move to the previous frame
    fp = *(uint64*)(fp - 16);
    800057c2:	ff04b483          	ld	s1,-16(s1)
  while (fp != 0 && PGROUNDDOWN(fp) == stack_page) {
    800057c6:	cc89                	beqz	s1,800057e0 <backtrace+0x56>
    800057c8:	0124c7b3          	xor	a5,s1,s2
    800057cc:	ff47e6e3          	bltu	a5,s4,800057b8 <backtrace+0x2e>
    800057d0:	64e2                	ld	s1,24(sp)
    800057d2:	69a2                	ld	s3,8(sp)
    800057d4:	6a02                	ld	s4,0(sp)
  }
}
    800057d6:	70a2                	ld	ra,40(sp)
    800057d8:	7402                	ld	s0,32(sp)
    800057da:	6942                	ld	s2,16(sp)
    800057dc:	6145                	addi	sp,sp,48
    800057de:	8082                	ret
    800057e0:	64e2                	ld	s1,24(sp)
    800057e2:	69a2                	ld	s3,8(sp)
    800057e4:	6a02                	ld	s4,0(sp)
    800057e6:	bfc5                	j	800057d6 <backtrace+0x4c>

00000000800057e8 <panic>:
{
    800057e8:	1101                	addi	sp,sp,-32
    800057ea:	ec06                	sd	ra,24(sp)
    800057ec:	e822                	sd	s0,16(sp)
    800057ee:	e426                	sd	s1,8(sp)
    800057f0:	e04a                	sd	s2,0(sp)
    800057f2:	1000                	addi	s0,sp,32
    800057f4:	892a                	mv	s2,a0
  panicking = 1;
    800057f6:	4485                	li	s1,1
    800057f8:	00002797          	auipc	a5,0x2
    800057fc:	0897a423          	sw	s1,136(a5) # 80007880 <panicking>
  printf("panic: ");
    80005800:	00002517          	auipc	a0,0x2
    80005804:	ee050513          	addi	a0,a0,-288 # 800076e0 <etext+0x6e0>
    80005808:	c35ff0ef          	jal	8000543c <printf>
  printf("%s\n", s);
    8000580c:	85ca                	mv	a1,s2
    8000580e:	00002517          	auipc	a0,0x2
    80005812:	eda50513          	addi	a0,a0,-294 # 800076e8 <etext+0x6e8>
    80005816:	c27ff0ef          	jal	8000543c <printf>
  backtrace();
    8000581a:	f71ff0ef          	jal	8000578a <backtrace>
  panicked = 1; // freeze uart output from other CPUs
    8000581e:	00002797          	auipc	a5,0x2
    80005822:	0497af23          	sw	s1,94(a5) # 8000787c <panicked>
  for(;;)
    80005826:	a001                	j	80005826 <panic+0x3e>

0000000080005828 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005828:	1141                	addi	sp,sp,-16
    8000582a:	e406                	sd	ra,8(sp)
    8000582c:	e022                	sd	s0,0(sp)
    8000582e:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005830:	100007b7          	lui	a5,0x10000
    80005834:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005838:	10000737          	lui	a4,0x10000
    8000583c:	f8000693          	li	a3,-128
    80005840:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005844:	468d                	li	a3,3
    80005846:	10000637          	lui	a2,0x10000
    8000584a:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    8000584e:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005852:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005856:	8732                	mv	a4,a2
    80005858:	461d                	li	a2,7
    8000585a:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    8000585e:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005862:	00002597          	auipc	a1,0x2
    80005866:	e8e58593          	addi	a1,a1,-370 # 800076f0 <etext+0x6f0>
    8000586a:	0001c517          	auipc	a0,0x1c
    8000586e:	b1650513          	addi	a0,a0,-1258 # 80021380 <tx_lock>
    80005872:	18e000ef          	jal	80005a00 <initlock>
}
    80005876:	60a2                	ld	ra,8(sp)
    80005878:	6402                	ld	s0,0(sp)
    8000587a:	0141                	addi	sp,sp,16
    8000587c:	8082                	ret

000000008000587e <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    8000587e:	715d                	addi	sp,sp,-80
    80005880:	e486                	sd	ra,72(sp)
    80005882:	e0a2                	sd	s0,64(sp)
    80005884:	fc26                	sd	s1,56(sp)
    80005886:	ec56                	sd	s5,24(sp)
    80005888:	0880                	addi	s0,sp,80
    8000588a:	8aaa                	mv	s5,a0
    8000588c:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    8000588e:	0001c517          	auipc	a0,0x1c
    80005892:	af250513          	addi	a0,a0,-1294 # 80021380 <tx_lock>
    80005896:	1f4000ef          	jal	80005a8a <acquire>

  int i = 0;
  while(i < n){ 
    8000589a:	06905063          	blez	s1,800058fa <uartwrite+0x7c>
    8000589e:	f84a                	sd	s2,48(sp)
    800058a0:	f44e                	sd	s3,40(sp)
    800058a2:	f052                	sd	s4,32(sp)
    800058a4:	e85a                	sd	s6,16(sp)
    800058a6:	e45e                	sd	s7,8(sp)
    800058a8:	8a56                	mv	s4,s5
    800058aa:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    800058ac:	00002497          	auipc	s1,0x2
    800058b0:	fdc48493          	addi	s1,s1,-36 # 80007888 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    800058b4:	0001c997          	auipc	s3,0x1c
    800058b8:	acc98993          	addi	s3,s3,-1332 # 80021380 <tx_lock>
    800058bc:	00002917          	auipc	s2,0x2
    800058c0:	fc890913          	addi	s2,s2,-56 # 80007884 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    800058c4:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    800058c8:	4b05                	li	s6,1
    800058ca:	a005                	j	800058ea <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    800058cc:	85ce                	mv	a1,s3
    800058ce:	854a                	mv	a0,s2
    800058d0:	b2dfb0ef          	jal	800013fc <sleep>
    while(tx_busy != 0){
    800058d4:	409c                	lw	a5,0(s1)
    800058d6:	fbfd                	bnez	a5,800058cc <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    800058d8:	000a4783          	lbu	a5,0(s4) # 1000 <_entry-0x7ffff000>
    800058dc:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    800058e0:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    800058e4:	0a05                	addi	s4,s4,1
    800058e6:	015a0563          	beq	s4,s5,800058f0 <uartwrite+0x72>
    while(tx_busy != 0){
    800058ea:	409c                	lw	a5,0(s1)
    800058ec:	f3e5                	bnez	a5,800058cc <uartwrite+0x4e>
    800058ee:	b7ed                	j	800058d8 <uartwrite+0x5a>
    800058f0:	7942                	ld	s2,48(sp)
    800058f2:	79a2                	ld	s3,40(sp)
    800058f4:	7a02                	ld	s4,32(sp)
    800058f6:	6b42                	ld	s6,16(sp)
    800058f8:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    800058fa:	0001c517          	auipc	a0,0x1c
    800058fe:	a8650513          	addi	a0,a0,-1402 # 80021380 <tx_lock>
    80005902:	21c000ef          	jal	80005b1e <release>
}
    80005906:	60a6                	ld	ra,72(sp)
    80005908:	6406                	ld	s0,64(sp)
    8000590a:	74e2                	ld	s1,56(sp)
    8000590c:	6ae2                	ld	s5,24(sp)
    8000590e:	6161                	addi	sp,sp,80
    80005910:	8082                	ret

0000000080005912 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005912:	1101                	addi	sp,sp,-32
    80005914:	ec06                	sd	ra,24(sp)
    80005916:	e822                	sd	s0,16(sp)
    80005918:	e426                	sd	s1,8(sp)
    8000591a:	1000                	addi	s0,sp,32
    8000591c:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000591e:	00002797          	auipc	a5,0x2
    80005922:	f627a783          	lw	a5,-158(a5) # 80007880 <panicking>
    80005926:	cf95                	beqz	a5,80005962 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005928:	00002797          	auipc	a5,0x2
    8000592c:	f547a783          	lw	a5,-172(a5) # 8000787c <panicked>
    80005930:	ef85                	bnez	a5,80005968 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005932:	10000737          	lui	a4,0x10000
    80005936:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005938:	00074783          	lbu	a5,0(a4)
    8000593c:	0207f793          	andi	a5,a5,32
    80005940:	dfe5                	beqz	a5,80005938 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005942:	0ff4f513          	zext.b	a0,s1
    80005946:	100007b7          	lui	a5,0x10000
    8000594a:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    8000594e:	00002797          	auipc	a5,0x2
    80005952:	f327a783          	lw	a5,-206(a5) # 80007880 <panicking>
    80005956:	cb91                	beqz	a5,8000596a <uartputc_sync+0x58>
    pop_off();
}
    80005958:	60e2                	ld	ra,24(sp)
    8000595a:	6442                	ld	s0,16(sp)
    8000595c:	64a2                	ld	s1,8(sp)
    8000595e:	6105                	addi	sp,sp,32
    80005960:	8082                	ret
    push_off();
    80005962:	0e4000ef          	jal	80005a46 <push_off>
    80005966:	b7c9                	j	80005928 <uartputc_sync+0x16>
    for(;;)
    80005968:	a001                	j	80005968 <uartputc_sync+0x56>
    pop_off();
    8000596a:	164000ef          	jal	80005ace <pop_off>
}
    8000596e:	b7ed                	j	80005958 <uartputc_sync+0x46>

0000000080005970 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005970:	1141                	addi	sp,sp,-16
    80005972:	e406                	sd	ra,8(sp)
    80005974:	e022                	sd	s0,0(sp)
    80005976:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005978:	100007b7          	lui	a5,0x10000
    8000597c:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005980:	8b85                	andi	a5,a5,1
    80005982:	cb89                	beqz	a5,80005994 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005984:	100007b7          	lui	a5,0x10000
    80005988:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    8000598c:	60a2                	ld	ra,8(sp)
    8000598e:	6402                	ld	s0,0(sp)
    80005990:	0141                	addi	sp,sp,16
    80005992:	8082                	ret
    return -1;
    80005994:	557d                	li	a0,-1
    80005996:	bfdd                	j	8000598c <uartgetc+0x1c>

0000000080005998 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005998:	1101                	addi	sp,sp,-32
    8000599a:	ec06                	sd	ra,24(sp)
    8000599c:	e822                	sd	s0,16(sp)
    8000599e:	e426                	sd	s1,8(sp)
    800059a0:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    800059a2:	100007b7          	lui	a5,0x10000
    800059a6:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    800059aa:	0001c517          	auipc	a0,0x1c
    800059ae:	9d650513          	addi	a0,a0,-1578 # 80021380 <tx_lock>
    800059b2:	0d8000ef          	jal	80005a8a <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    800059b6:	100007b7          	lui	a5,0x10000
    800059ba:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800059be:	0207f793          	andi	a5,a5,32
    800059c2:	ef99                	bnez	a5,800059e0 <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    800059c4:	0001c517          	auipc	a0,0x1c
    800059c8:	9bc50513          	addi	a0,a0,-1604 # 80021380 <tx_lock>
    800059cc:	152000ef          	jal	80005b1e <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800059d0:	54fd                	li	s1,-1
    int c = uartgetc();
    800059d2:	f9fff0ef          	jal	80005970 <uartgetc>
    if(c == -1)
    800059d6:	02950063          	beq	a0,s1,800059f6 <uartintr+0x5e>
      break;
    consoleintr(c);
    800059da:	815ff0ef          	jal	800051ee <consoleintr>
  while(1){
    800059de:	bfd5                	j	800059d2 <uartintr+0x3a>
    tx_busy = 0;
    800059e0:	00002797          	auipc	a5,0x2
    800059e4:	ea07a423          	sw	zero,-344(a5) # 80007888 <tx_busy>
    wakeup(&tx_chan);
    800059e8:	00002517          	auipc	a0,0x2
    800059ec:	e9c50513          	addi	a0,a0,-356 # 80007884 <tx_chan>
    800059f0:	a59fb0ef          	jal	80001448 <wakeup>
    800059f4:	bfc1                	j	800059c4 <uartintr+0x2c>
  }
}
    800059f6:	60e2                	ld	ra,24(sp)
    800059f8:	6442                	ld	s0,16(sp)
    800059fa:	64a2                	ld	s1,8(sp)
    800059fc:	6105                	addi	sp,sp,32
    800059fe:	8082                	ret

0000000080005a00 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005a00:	1141                	addi	sp,sp,-16
    80005a02:	e406                	sd	ra,8(sp)
    80005a04:	e022                	sd	s0,0(sp)
    80005a06:	0800                	addi	s0,sp,16
  lk->name = name;
    80005a08:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005a0a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005a0e:	00053823          	sd	zero,16(a0)
}
    80005a12:	60a2                	ld	ra,8(sp)
    80005a14:	6402                	ld	s0,0(sp)
    80005a16:	0141                	addi	sp,sp,16
    80005a18:	8082                	ret

0000000080005a1a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005a1a:	411c                	lw	a5,0(a0)
    80005a1c:	e399                	bnez	a5,80005a22 <holding+0x8>
    80005a1e:	4501                	li	a0,0
  return r;
}
    80005a20:	8082                	ret
{
    80005a22:	1101                	addi	sp,sp,-32
    80005a24:	ec06                	sd	ra,24(sp)
    80005a26:	e822                	sd	s0,16(sp)
    80005a28:	e426                	sd	s1,8(sp)
    80005a2a:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005a2c:	691c                	ld	a5,16(a0)
    80005a2e:	84be                	mv	s1,a5
    80005a30:	b38fb0ef          	jal	80000d68 <mycpu>
    80005a34:	40a48533          	sub	a0,s1,a0
    80005a38:	00153513          	seqz	a0,a0
}
    80005a3c:	60e2                	ld	ra,24(sp)
    80005a3e:	6442                	ld	s0,16(sp)
    80005a40:	64a2                	ld	s1,8(sp)
    80005a42:	6105                	addi	sp,sp,32
    80005a44:	8082                	ret

0000000080005a46 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005a46:	1101                	addi	sp,sp,-32
    80005a48:	ec06                	sd	ra,24(sp)
    80005a4a:	e822                	sd	s0,16(sp)
    80005a4c:	e426                	sd	s1,8(sp)
    80005a4e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a50:	100027f3          	csrr	a5,sstatus
    80005a54:	84be                	mv	s1,a5
    80005a56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005a5a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005a5c:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005a60:	b08fb0ef          	jal	80000d68 <mycpu>
    80005a64:	5d3c                	lw	a5,120(a0)
    80005a66:	cb99                	beqz	a5,80005a7c <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005a68:	b00fb0ef          	jal	80000d68 <mycpu>
    80005a6c:	5d3c                	lw	a5,120(a0)
    80005a6e:	2785                	addiw	a5,a5,1
    80005a70:	dd3c                	sw	a5,120(a0)
}
    80005a72:	60e2                	ld	ra,24(sp)
    80005a74:	6442                	ld	s0,16(sp)
    80005a76:	64a2                	ld	s1,8(sp)
    80005a78:	6105                	addi	sp,sp,32
    80005a7a:	8082                	ret
    mycpu()->intena = old;
    80005a7c:	aecfb0ef          	jal	80000d68 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005a80:	0014d793          	srli	a5,s1,0x1
    80005a84:	8b85                	andi	a5,a5,1
    80005a86:	dd7c                	sw	a5,124(a0)
    80005a88:	b7c5                	j	80005a68 <push_off+0x22>

0000000080005a8a <acquire>:
{
    80005a8a:	1101                	addi	sp,sp,-32
    80005a8c:	ec06                	sd	ra,24(sp)
    80005a8e:	e822                	sd	s0,16(sp)
    80005a90:	e426                	sd	s1,8(sp)
    80005a92:	1000                	addi	s0,sp,32
    80005a94:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005a96:	fb1ff0ef          	jal	80005a46 <push_off>
  if(holding(lk))
    80005a9a:	8526                	mv	a0,s1
    80005a9c:	f7fff0ef          	jal	80005a1a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005aa0:	4705                	li	a4,1
  if(holding(lk))
    80005aa2:	e105                	bnez	a0,80005ac2 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005aa4:	87ba                	mv	a5,a4
    80005aa6:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005aaa:	2781                	sext.w	a5,a5
    80005aac:	ffe5                	bnez	a5,80005aa4 <acquire+0x1a>
  __sync_synchronize();
    80005aae:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005ab2:	ab6fb0ef          	jal	80000d68 <mycpu>
    80005ab6:	e888                	sd	a0,16(s1)
}
    80005ab8:	60e2                	ld	ra,24(sp)
    80005aba:	6442                	ld	s0,16(sp)
    80005abc:	64a2                	ld	s1,8(sp)
    80005abe:	6105                	addi	sp,sp,32
    80005ac0:	8082                	ret
    panic("acquire");
    80005ac2:	00002517          	auipc	a0,0x2
    80005ac6:	c3650513          	addi	a0,a0,-970 # 800076f8 <etext+0x6f8>
    80005aca:	d1fff0ef          	jal	800057e8 <panic>

0000000080005ace <pop_off>:

void
pop_off(void)
{
    80005ace:	1141                	addi	sp,sp,-16
    80005ad0:	e406                	sd	ra,8(sp)
    80005ad2:	e022                	sd	s0,0(sp)
    80005ad4:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005ad6:	a92fb0ef          	jal	80000d68 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005ada:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005ade:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005ae0:	e39d                	bnez	a5,80005b06 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005ae2:	5d3c                	lw	a5,120(a0)
    80005ae4:	02f05763          	blez	a5,80005b12 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005ae8:	37fd                	addiw	a5,a5,-1
    80005aea:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005aec:	eb89                	bnez	a5,80005afe <pop_off+0x30>
    80005aee:	5d7c                	lw	a5,124(a0)
    80005af0:	c799                	beqz	a5,80005afe <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005af2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005af6:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005afa:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005afe:	60a2                	ld	ra,8(sp)
    80005b00:	6402                	ld	s0,0(sp)
    80005b02:	0141                	addi	sp,sp,16
    80005b04:	8082                	ret
    panic("pop_off - interruptible");
    80005b06:	00002517          	auipc	a0,0x2
    80005b0a:	bfa50513          	addi	a0,a0,-1030 # 80007700 <etext+0x700>
    80005b0e:	cdbff0ef          	jal	800057e8 <panic>
    panic("pop_off");
    80005b12:	00002517          	auipc	a0,0x2
    80005b16:	c0650513          	addi	a0,a0,-1018 # 80007718 <etext+0x718>
    80005b1a:	ccfff0ef          	jal	800057e8 <panic>

0000000080005b1e <release>:
{
    80005b1e:	1101                	addi	sp,sp,-32
    80005b20:	ec06                	sd	ra,24(sp)
    80005b22:	e822                	sd	s0,16(sp)
    80005b24:	e426                	sd	s1,8(sp)
    80005b26:	1000                	addi	s0,sp,32
    80005b28:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005b2a:	ef1ff0ef          	jal	80005a1a <holding>
    80005b2e:	c105                	beqz	a0,80005b4e <release+0x30>
  lk->cpu = 0;
    80005b30:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005b34:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005b38:	0310000f          	fence	rw,w
    80005b3c:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005b40:	f8fff0ef          	jal	80005ace <pop_off>
}
    80005b44:	60e2                	ld	ra,24(sp)
    80005b46:	6442                	ld	s0,16(sp)
    80005b48:	64a2                	ld	s1,8(sp)
    80005b4a:	6105                	addi	sp,sp,32
    80005b4c:	8082                	ret
    panic("release");
    80005b4e:	00002517          	auipc	a0,0x2
    80005b52:	bd250513          	addi	a0,a0,-1070 # 80007720 <etext+0x720>
    80005b56:	c93ff0ef          	jal	800057e8 <panic>
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
