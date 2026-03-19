
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00014117          	auipc	sp,0x14
    80000004:	ed010113          	addi	sp,sp,-304 # 80013ed0 <stack0>
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
    80000016:	1c0050ef          	jal	800051d6 <start>

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
    80000028:	0001c797          	auipc	a5,0x1c
    8000002c:	f8078793          	addi	a5,a5,-128 # 8001bfa8 <end>
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
    8000005c:	3fd050ef          	jal	80005c58 <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	481050ef          	jal	80005cec <release>
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
    80000084:	113050ef          	jal	80005996 <panic>

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
    800000e8:	2e7050ef          	jal	80005bce <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	0001c517          	auipc	a0,0x1c
    800000f4:	eb850513          	addi	a0,a0,-328 # 8001bfa8 <end>
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
    80000116:	343050ef          	jal	80005c58 <acquire>
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
    80000136:	3b7050ef          	jal	80005cec <release>

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
    80000158:	395050ef          	jal	80005cec <release>
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
    80000334:	22d000ef          	jal	80000d60 <cpuid>
    80000338:	85aa                	mv	a1,a0
    8000033a:	00007517          	auipc	a0,0x7
    8000033e:	cfe50513          	addi	a0,a0,-770 # 80007038 <etext+0x38>
    80000342:	32a050ef          	jal	8000566c <printf>
    kvminithart();    // turn on paging
    80000346:	080000ef          	jal	800003c6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034a:	56a010ef          	jal	800018b4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034e:	0cb040ef          	jal	80004c18 <plicinithart>
  }

  scheduler();        
    80000352:	6a7000ef          	jal	800011f8 <scheduler>
    consoleinit();
    80000356:	23c050ef          	jal	80005592 <consoleinit>
    printfinit();
    8000035a:	678050ef          	jal	800059d2 <printfinit>
    printf("\n");
    8000035e:	00007517          	auipc	a0,0x7
    80000362:	cba50513          	addi	a0,a0,-838 # 80007018 <etext+0x18>
    80000366:	306050ef          	jal	8000566c <printf>
    printf("xv6 kernel is booting\n");
    8000036a:	00007517          	auipc	a0,0x7
    8000036e:	cb650513          	addi	a0,a0,-842 # 80007020 <etext+0x20>
    80000372:	2fa050ef          	jal	8000566c <printf>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	2ee050ef          	jal	8000566c <printf>
    kinit();         // physical page allocator
    80000382:	d4fff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    80000386:	2cc000ef          	jal	80000652 <kvminit>
    kvminithart();   // turn on paging
    8000038a:	03c000ef          	jal	800003c6 <kvminithart>
    procinit();      // process table
    8000038e:	11d000ef          	jal	80000caa <procinit>
    trapinit();      // trap vectors
    80000392:	4fe010ef          	jal	80001890 <trapinit>
    trapinithart();  // install kernel trap vector
    80000396:	51e010ef          	jal	800018b4 <trapinithart>
    plicinit();      // set up interrupt controller
    8000039a:	065040ef          	jal	80004bfe <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039e:	07b040ef          	jal	80004c18 <plicinithart>
    binit();         // buffer cache
    800003a2:	39f010ef          	jal	80001f40 <binit>
    iinit();         // inode table
    800003a6:	1a0020ef          	jal	80002546 <iinit>
    fileinit();      // file table
    800003aa:	15c030ef          	jal	80003506 <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	15b040ef          	jal	80004d08 <virtio_disk_init>
    userinit();      // first user process
    800003b2:	4ad000ef          	jal	8000105e <userinit>
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
    80000460:	536050ef          	jal	80005996 <panic>
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
    80000538:	45e050ef          	jal	80005996 <panic>
    panic("mappages: size not aligned");
    8000053c:	00007517          	auipc	a0,0x7
    80000540:	b3c50513          	addi	a0,a0,-1220 # 80007078 <etext+0x78>
    80000544:	452050ef          	jal	80005996 <panic>
    panic("mappages: size");
    80000548:	00007517          	auipc	a0,0x7
    8000054c:	b5050513          	addi	a0,a0,-1200 # 80007098 <etext+0x98>
    80000550:	446050ef          	jal	80005996 <panic>
      panic("mappages: remap");
    80000554:	00007517          	auipc	a0,0x7
    80000558:	b5450513          	addi	a0,a0,-1196 # 800070a8 <etext+0xa8>
    8000055c:	43a050ef          	jal	80005996 <panic>
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
    800005a0:	3f6050ef          	jal	80005996 <panic>

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
    800006d6:	2c0050ef          	jal	80005996 <panic>
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
    8000082c:	16a050ef          	jal	80005996 <panic>
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
    8000095a:	03c050ef          	jal	80005996 <panic>

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
    80000c24:	0c048493          	addi	s1,s1,192 # 80007ce0 <proc>
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
    80000c50:	00008a97          	auipc	s5,0x8
    80000c54:	ea0a8a93          	addi	s5,s5,-352 # 80008af0 <tickslock>
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
    80000ca6:	4f1040ef          	jal	80005996 <panic>

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
    80000cca:	bea50513          	addi	a0,a0,-1046 # 800078b0 <pid_lock>
    80000cce:	701040ef          	jal	80005bce <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cd2:	00006597          	auipc	a1,0x6
    80000cd6:	43658593          	addi	a1,a1,1078 # 80007108 <etext+0x108>
    80000cda:	00007517          	auipc	a0,0x7
    80000cde:	bee50513          	addi	a0,a0,-1042 # 800078c8 <wait_lock>
    80000ce2:	6ed040ef          	jal	80005bce <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000ce6:	00007497          	auipc	s1,0x7
    80000cea:	ffa48493          	addi	s1,s1,-6 # 80007ce0 <proc>
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
    80000d1a:	00008a17          	auipc	s4,0x8
    80000d1e:	dd6a0a13          	addi	s4,s4,-554 # 80008af0 <tickslock>
      initlock(&p->lock, "proc");
    80000d22:	85da                	mv	a1,s6
    80000d24:	8526                	mv	a0,s1
    80000d26:	6a9040ef          	jal	80005bce <initlock>
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
    80000d86:	b5e50513          	addi	a0,a0,-1186 # 800078e0 <cpus>
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
    80000d9e:	677040ef          	jal	80005c14 <push_off>
    80000da2:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000da4:	2781                	sext.w	a5,a5
    80000da6:	079e                	slli	a5,a5,0x7
    80000da8:	00007717          	auipc	a4,0x7
    80000dac:	b0870713          	addi	a4,a4,-1272 # 800078b0 <pid_lock>
    80000db0:	97ba                	add	a5,a5,a4
    80000db2:	7b9c                	ld	a5,48(a5)
    80000db4:	84be                	mv	s1,a5
  pop_off();
    80000db6:	6e7040ef          	jal	80005c9c <pop_off>
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
    80000dd6:	717040ef          	jal	80005cec <release>

  if (first) {
    80000dda:	00007797          	auipc	a5,0x7
    80000dde:	a767a783          	lw	a5,-1418(a5) # 80007850 <first.1>
    80000de2:	cf95                	beqz	a5,80000e1e <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000de4:	4505                	li	a0,1
    80000de6:	4ab010ef          	jal	80002a90 <fsinit>

    first = 0;
    80000dea:	00007797          	auipc	a5,0x7
    80000dee:	a607a323          	sw	zero,-1434(a5) # 80007850 <first.1>
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
    80000e0c:	605020ef          	jal	80003c10 <kexec>
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
    80000e1e:	2b3000ef          	jal	800018d0 <prepare_return>
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
    80000e5c:	33b040ef          	jal	80005996 <panic>

0000000080000e60 <allocpid>:
{
    80000e60:	1101                	addi	sp,sp,-32
    80000e62:	ec06                	sd	ra,24(sp)
    80000e64:	e822                	sd	s0,16(sp)
    80000e66:	e426                	sd	s1,8(sp)
    80000e68:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e6a:	00007517          	auipc	a0,0x7
    80000e6e:	a4650513          	addi	a0,a0,-1466 # 800078b0 <pid_lock>
    80000e72:	5e7040ef          	jal	80005c58 <acquire>
  pid = nextpid;
    80000e76:	00007797          	auipc	a5,0x7
    80000e7a:	9de78793          	addi	a5,a5,-1570 # 80007854 <nextpid>
    80000e7e:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e80:	0014871b          	addiw	a4,s1,1
    80000e84:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e86:	00007517          	auipc	a0,0x7
    80000e8a:	a2a50513          	addi	a0,a0,-1494 # 800078b0 <pid_lock>
    80000e8e:	65f040ef          	jal	80005cec <release>
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
    80000fc8:	d1c48493          	addi	s1,s1,-740 # 80007ce0 <proc>
    80000fcc:	00008917          	auipc	s2,0x8
    80000fd0:	b2490913          	addi	s2,s2,-1244 # 80008af0 <tickslock>
    acquire(&p->lock);
    80000fd4:	8526                	mv	a0,s1
    80000fd6:	483040ef          	jal	80005c58 <acquire>
    if(p->state == UNUSED) {
    80000fda:	4c9c                	lw	a5,24(s1)
    80000fdc:	c385                	beqz	a5,80000ffc <allocproc+0x44>
      release(&p->lock);
    80000fde:	8526                	mv	a0,s1
    80000fe0:	50d040ef          	jal	80005cec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fe4:	16848493          	addi	s1,s1,360
    80000fe8:	ff2496e3          	bne	s1,s2,80000fd4 <allocproc+0x1c>
  return 0;
    80000fec:	4481                	li	s1,0
}
    80000fee:	8526                	mv	a0,s1
    80000ff0:	60e2                	ld	ra,24(sp)
    80000ff2:	6442                	ld	s0,16(sp)
    80000ff4:	64a2                	ld	s1,8(sp)
    80000ff6:	6902                	ld	s2,0(sp)
    80000ff8:	6105                	addi	sp,sp,32
    80000ffa:	8082                	ret
  p->pid = allocpid();
    80000ffc:	e65ff0ef          	jal	80000e60 <allocpid>
    80001000:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001002:	4785                	li	a5,1
    80001004:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001006:	8feff0ef          	jal	80000104 <kalloc>
    8000100a:	892a                	mv	s2,a0
    8000100c:	eca8                	sd	a0,88(s1)
    8000100e:	c905                	beqz	a0,8000103e <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80001010:	8526                	mv	a0,s1
    80001012:	e8dff0ef          	jal	80000e9e <proc_pagetable>
    80001016:	892a                	mv	s2,a0
    80001018:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000101a:	c915                	beqz	a0,8000104e <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    8000101c:	07000613          	li	a2,112
    80001020:	4581                	li	a1,0
    80001022:	06048513          	addi	a0,s1,96
    80001026:	938ff0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    8000102a:	00000797          	auipc	a5,0x0
    8000102e:	d9c78793          	addi	a5,a5,-612 # 80000dc6 <forkret>
    80001032:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001034:	60bc                	ld	a5,64(s1)
    80001036:	6705                	lui	a4,0x1
    80001038:	97ba                	add	a5,a5,a4
    8000103a:	f4bc                	sd	a5,104(s1)
  return p;
    8000103c:	bf4d                	j	80000fee <allocproc+0x36>
    freeproc(p);
    8000103e:	8526                	mv	a0,s1
    80001040:	f29ff0ef          	jal	80000f68 <freeproc>
    release(&p->lock);
    80001044:	8526                	mv	a0,s1
    80001046:	4a7040ef          	jal	80005cec <release>
    return 0;
    8000104a:	84ca                	mv	s1,s2
    8000104c:	b74d                	j	80000fee <allocproc+0x36>
    freeproc(p);
    8000104e:	8526                	mv	a0,s1
    80001050:	f19ff0ef          	jal	80000f68 <freeproc>
    release(&p->lock);
    80001054:	8526                	mv	a0,s1
    80001056:	497040ef          	jal	80005cec <release>
    return 0;
    8000105a:	84ca                	mv	s1,s2
    8000105c:	bf49                	j	80000fee <allocproc+0x36>

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
    8000106e:	00007797          	auipc	a5,0x7
    80001072:	80a7b123          	sd	a0,-2046(a5) # 80007870 <initproc>
  p->cwd = namei("/");
    80001076:	00006517          	auipc	a0,0x6
    8000107a:	0ba50513          	addi	a0,a0,186 # 80007130 <etext+0x130>
    8000107e:	74f010ef          	jal	80002fcc <namei>
    80001082:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001086:	478d                	li	a5,3
    80001088:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    8000108a:	8526                	mv	a0,s1
    8000108c:	461040ef          	jal	80005cec <release>
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
    8000116e:	37f040ef          	jal	80005cec <release>
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
    80001184:	404020ef          	jal	80003588 <filedup>
    80001188:	00a93023          	sd	a0,0(s2)
    8000118c:	b7f5                	j	80001178 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    8000118e:	150ab503          	ld	a0,336(s5)
    80001192:	546010ef          	jal	800026d8 <idup>
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
    800011ae:	33f040ef          	jal	80005cec <release>
  acquire(&wait_lock);
    800011b2:	00006517          	auipc	a0,0x6
    800011b6:	71650513          	addi	a0,a0,1814 # 800078c8 <wait_lock>
    800011ba:	29f040ef          	jal	80005c58 <acquire>
  np->parent = p;
    800011be:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800011c2:	00006517          	auipc	a0,0x6
    800011c6:	70650513          	addi	a0,a0,1798 # 800078c8 <wait_lock>
    800011ca:	323040ef          	jal	80005cec <release>
  acquire(&np->lock);
    800011ce:	8552                	mv	a0,s4
    800011d0:	289040ef          	jal	80005c58 <acquire>
  np->state = RUNNABLE;
    800011d4:	478d                	li	a5,3
    800011d6:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800011da:	8552                	mv	a0,s4
    800011dc:	311040ef          	jal	80005cec <release>
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
    8000120c:	0880                	addi	s0,sp,80
    8000120e:	8792                	mv	a5,tp
  int id = r_tp();
    80001210:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001212:	00779b13          	slli	s6,a5,0x7
    80001216:	00006717          	auipc	a4,0x6
    8000121a:	69a70713          	addi	a4,a4,1690 # 800078b0 <pid_lock>
    8000121e:	975a                	add	a4,a4,s6
    80001220:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001224:	00006717          	auipc	a4,0x6
    80001228:	6c470713          	addi	a4,a4,1732 # 800078e8 <cpus+0x8>
    8000122c:	9b3a                	add	s6,s6,a4
      if(p->state == RUNNABLE) {
    8000122e:	4a0d                	li	s4,3
        p->state = RUNNING;
    80001230:	4b91                	li	s7,4
        c->proc = p;
    80001232:	079e                	slli	a5,a5,0x7
    80001234:	00006a97          	auipc	s5,0x6
    80001238:	67ca8a93          	addi	s5,s5,1660 # 800078b0 <pid_lock>
    8000123c:	9abe                	add	s5,s5,a5
    8000123e:	a0a9                	j	80001288 <scheduler+0x90>
      release(&p->lock);
    80001240:	8526                	mv	a0,s1
    80001242:	2ab040ef          	jal	80005cec <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001246:	16848493          	addi	s1,s1,360
    8000124a:	03348663          	beq	s1,s3,80001276 <scheduler+0x7e>
      acquire(&p->lock);
    8000124e:	8526                	mv	a0,s1
    80001250:	209040ef          	jal	80005c58 <acquire>
      if(p->state != UNUSED) {
    80001254:	4c9c                	lw	a5,24(s1)
    80001256:	d7ed                	beqz	a5,80001240 <scheduler+0x48>
        nproc++;
    80001258:	2905                	addiw	s2,s2,1
      if(p->state == RUNNABLE) {
    8000125a:	ff4793e3          	bne	a5,s4,80001240 <scheduler+0x48>
        p->state = RUNNING;
    8000125e:	0174ac23          	sw	s7,24(s1)
        c->proc = p;
    80001262:	029ab823          	sd	s1,48(s5)
        swtch(&c->context, &p->context);
    80001266:	06048593          	addi	a1,s1,96
    8000126a:	855a                	mv	a0,s6
    8000126c:	5ba000ef          	jal	80001826 <swtch>
        c->proc = 0;
    80001270:	020ab823          	sd	zero,48(s5)
    80001274:	b7f1                	j	80001240 <scheduler+0x48>
    if(nproc <= 2) {   // only init and sh exist
    80001276:	4789                	li	a5,2
    80001278:	0127c863          	blt	a5,s2,80001288 <scheduler+0x90>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000127c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001280:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001284:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001288:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000128c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001290:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001294:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001298:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000129a:	10079073          	csrw	sstatus,a5
    int nproc = 0;
    8000129e:	4901                	li	s2,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800012a0:	00007497          	auipc	s1,0x7
    800012a4:	a4048493          	addi	s1,s1,-1472 # 80007ce0 <proc>
    800012a8:	00008997          	auipc	s3,0x8
    800012ac:	84898993          	addi	s3,s3,-1976 # 80008af0 <tickslock>
    800012b0:	bf79                	j	8000124e <scheduler+0x56>

00000000800012b2 <sched>:
{
    800012b2:	7179                	addi	sp,sp,-48
    800012b4:	f406                	sd	ra,40(sp)
    800012b6:	f022                	sd	s0,32(sp)
    800012b8:	ec26                	sd	s1,24(sp)
    800012ba:	e84a                	sd	s2,16(sp)
    800012bc:	e44e                	sd	s3,8(sp)
    800012be:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800012c0:	ad5ff0ef          	jal	80000d94 <myproc>
    800012c4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012c6:	123040ef          	jal	80005be8 <holding>
    800012ca:	c935                	beqz	a0,8000133e <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012cc:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012ce:	2781                	sext.w	a5,a5
    800012d0:	079e                	slli	a5,a5,0x7
    800012d2:	00006717          	auipc	a4,0x6
    800012d6:	5de70713          	addi	a4,a4,1502 # 800078b0 <pid_lock>
    800012da:	97ba                	add	a5,a5,a4
    800012dc:	0a87a703          	lw	a4,168(a5)
    800012e0:	4785                	li	a5,1
    800012e2:	06f71463          	bne	a4,a5,8000134a <sched+0x98>
  if(p->state == RUNNING)
    800012e6:	4c98                	lw	a4,24(s1)
    800012e8:	4791                	li	a5,4
    800012ea:	06f70663          	beq	a4,a5,80001356 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800012ee:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800012f2:	8b89                	andi	a5,a5,2
  if(intr_get())
    800012f4:	e7bd                	bnez	a5,80001362 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012f6:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    800012f8:	00006917          	auipc	s2,0x6
    800012fc:	5b890913          	addi	s2,s2,1464 # 800078b0 <pid_lock>
    80001300:	2781                	sext.w	a5,a5
    80001302:	079e                	slli	a5,a5,0x7
    80001304:	97ca                	add	a5,a5,s2
    80001306:	0ac7a983          	lw	s3,172(a5)
    8000130a:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000130c:	2781                	sext.w	a5,a5
    8000130e:	079e                	slli	a5,a5,0x7
    80001310:	07a1                	addi	a5,a5,8
    80001312:	00006597          	auipc	a1,0x6
    80001316:	5ce58593          	addi	a1,a1,1486 # 800078e0 <cpus>
    8000131a:	95be                	add	a1,a1,a5
    8000131c:	06048513          	addi	a0,s1,96
    80001320:	506000ef          	jal	80001826 <swtch>
    80001324:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001326:	2781                	sext.w	a5,a5
    80001328:	079e                	slli	a5,a5,0x7
    8000132a:	993e                	add	s2,s2,a5
    8000132c:	0b392623          	sw	s3,172(s2)
}
    80001330:	70a2                	ld	ra,40(sp)
    80001332:	7402                	ld	s0,32(sp)
    80001334:	64e2                	ld	s1,24(sp)
    80001336:	6942                	ld	s2,16(sp)
    80001338:	69a2                	ld	s3,8(sp)
    8000133a:	6145                	addi	sp,sp,48
    8000133c:	8082                	ret
    panic("sched p->lock");
    8000133e:	00006517          	auipc	a0,0x6
    80001342:	dfa50513          	addi	a0,a0,-518 # 80007138 <etext+0x138>
    80001346:	650040ef          	jal	80005996 <panic>
    panic("sched locks");
    8000134a:	00006517          	auipc	a0,0x6
    8000134e:	dfe50513          	addi	a0,a0,-514 # 80007148 <etext+0x148>
    80001352:	644040ef          	jal	80005996 <panic>
    panic("sched RUNNING");
    80001356:	00006517          	auipc	a0,0x6
    8000135a:	e0250513          	addi	a0,a0,-510 # 80007158 <etext+0x158>
    8000135e:	638040ef          	jal	80005996 <panic>
    panic("sched interruptible");
    80001362:	00006517          	auipc	a0,0x6
    80001366:	e0650513          	addi	a0,a0,-506 # 80007168 <etext+0x168>
    8000136a:	62c040ef          	jal	80005996 <panic>

000000008000136e <yield>:
{
    8000136e:	1101                	addi	sp,sp,-32
    80001370:	ec06                	sd	ra,24(sp)
    80001372:	e822                	sd	s0,16(sp)
    80001374:	e426                	sd	s1,8(sp)
    80001376:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001378:	a1dff0ef          	jal	80000d94 <myproc>
    8000137c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000137e:	0db040ef          	jal	80005c58 <acquire>
  p->state = RUNNABLE;
    80001382:	478d                	li	a5,3
    80001384:	cc9c                	sw	a5,24(s1)
  sched();
    80001386:	f2dff0ef          	jal	800012b2 <sched>
  release(&p->lock);
    8000138a:	8526                	mv	a0,s1
    8000138c:	161040ef          	jal	80005cec <release>
}
    80001390:	60e2                	ld	ra,24(sp)
    80001392:	6442                	ld	s0,16(sp)
    80001394:	64a2                	ld	s1,8(sp)
    80001396:	6105                	addi	sp,sp,32
    80001398:	8082                	ret

000000008000139a <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000139a:	7179                	addi	sp,sp,-48
    8000139c:	f406                	sd	ra,40(sp)
    8000139e:	f022                	sd	s0,32(sp)
    800013a0:	ec26                	sd	s1,24(sp)
    800013a2:	e84a                	sd	s2,16(sp)
    800013a4:	e44e                	sd	s3,8(sp)
    800013a6:	1800                	addi	s0,sp,48
    800013a8:	89aa                	mv	s3,a0
    800013aa:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800013ac:	9e9ff0ef          	jal	80000d94 <myproc>
    800013b0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013b2:	0a7040ef          	jal	80005c58 <acquire>
  release(lk);
    800013b6:	854a                	mv	a0,s2
    800013b8:	135040ef          	jal	80005cec <release>

  // Go to sleep.
  p->chan = chan;
    800013bc:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800013c0:	4789                	li	a5,2
    800013c2:	cc9c                	sw	a5,24(s1)

  sched();
    800013c4:	eefff0ef          	jal	800012b2 <sched>

  // Tidy up.
  p->chan = 0;
    800013c8:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800013cc:	8526                	mv	a0,s1
    800013ce:	11f040ef          	jal	80005cec <release>
  acquire(lk);
    800013d2:	854a                	mv	a0,s2
    800013d4:	085040ef          	jal	80005c58 <acquire>
}
    800013d8:	70a2                	ld	ra,40(sp)
    800013da:	7402                	ld	s0,32(sp)
    800013dc:	64e2                	ld	s1,24(sp)
    800013de:	6942                	ld	s2,16(sp)
    800013e0:	69a2                	ld	s3,8(sp)
    800013e2:	6145                	addi	sp,sp,48
    800013e4:	8082                	ret

00000000800013e6 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    800013e6:	7179                	addi	sp,sp,-48
    800013e8:	f406                	sd	ra,40(sp)
    800013ea:	f022                	sd	s0,32(sp)
    800013ec:	ec26                	sd	s1,24(sp)
    800013ee:	e84a                	sd	s2,16(sp)
    800013f0:	e44e                	sd	s3,8(sp)
    800013f2:	e052                	sd	s4,0(sp)
    800013f4:	1800                	addi	s0,sp,48
    800013f6:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013f8:	00007497          	auipc	s1,0x7
    800013fc:	8e848493          	addi	s1,s1,-1816 # 80007ce0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001400:	4989                	li	s3,2
  for(p = proc; p < &proc[NPROC]; p++) {
    80001402:	00007917          	auipc	s2,0x7
    80001406:	6ee90913          	addi	s2,s2,1774 # 80008af0 <tickslock>
    8000140a:	a801                	j	8000141a <wakeup+0x34>
        p->state = RUNNABLE;
      }
      release(&p->lock);
    8000140c:	8526                	mv	a0,s1
    8000140e:	0df040ef          	jal	80005cec <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001412:	16848493          	addi	s1,s1,360
    80001416:	03248263          	beq	s1,s2,8000143a <wakeup+0x54>
    if(p != myproc()){
    8000141a:	97bff0ef          	jal	80000d94 <myproc>
    8000141e:	fe950ae3          	beq	a0,s1,80001412 <wakeup+0x2c>
      acquire(&p->lock);
    80001422:	8526                	mv	a0,s1
    80001424:	035040ef          	jal	80005c58 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001428:	4c9c                	lw	a5,24(s1)
    8000142a:	ff3791e3          	bne	a5,s3,8000140c <wakeup+0x26>
    8000142e:	709c                	ld	a5,32(s1)
    80001430:	fd479ee3          	bne	a5,s4,8000140c <wakeup+0x26>
        p->state = RUNNABLE;
    80001434:	478d                	li	a5,3
    80001436:	cc9c                	sw	a5,24(s1)
    80001438:	bfd1                	j	8000140c <wakeup+0x26>
    }
  }
}
    8000143a:	70a2                	ld	ra,40(sp)
    8000143c:	7402                	ld	s0,32(sp)
    8000143e:	64e2                	ld	s1,24(sp)
    80001440:	6942                	ld	s2,16(sp)
    80001442:	69a2                	ld	s3,8(sp)
    80001444:	6a02                	ld	s4,0(sp)
    80001446:	6145                	addi	sp,sp,48
    80001448:	8082                	ret

000000008000144a <reparent>:
{
    8000144a:	7179                	addi	sp,sp,-48
    8000144c:	f406                	sd	ra,40(sp)
    8000144e:	f022                	sd	s0,32(sp)
    80001450:	ec26                	sd	s1,24(sp)
    80001452:	e84a                	sd	s2,16(sp)
    80001454:	e44e                	sd	s3,8(sp)
    80001456:	e052                	sd	s4,0(sp)
    80001458:	1800                	addi	s0,sp,48
    8000145a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000145c:	00007497          	auipc	s1,0x7
    80001460:	88448493          	addi	s1,s1,-1916 # 80007ce0 <proc>
      pp->parent = initproc;
    80001464:	00006a17          	auipc	s4,0x6
    80001468:	40ca0a13          	addi	s4,s4,1036 # 80007870 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000146c:	00007997          	auipc	s3,0x7
    80001470:	68498993          	addi	s3,s3,1668 # 80008af0 <tickslock>
    80001474:	a029                	j	8000147e <reparent+0x34>
    80001476:	16848493          	addi	s1,s1,360
    8000147a:	01348b63          	beq	s1,s3,80001490 <reparent+0x46>
    if(pp->parent == p){
    8000147e:	7c9c                	ld	a5,56(s1)
    80001480:	ff279be3          	bne	a5,s2,80001476 <reparent+0x2c>
      pp->parent = initproc;
    80001484:	000a3503          	ld	a0,0(s4)
    80001488:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000148a:	f5dff0ef          	jal	800013e6 <wakeup>
    8000148e:	b7e5                	j	80001476 <reparent+0x2c>
}
    80001490:	70a2                	ld	ra,40(sp)
    80001492:	7402                	ld	s0,32(sp)
    80001494:	64e2                	ld	s1,24(sp)
    80001496:	6942                	ld	s2,16(sp)
    80001498:	69a2                	ld	s3,8(sp)
    8000149a:	6a02                	ld	s4,0(sp)
    8000149c:	6145                	addi	sp,sp,48
    8000149e:	8082                	ret

00000000800014a0 <kexit>:
{
    800014a0:	7179                	addi	sp,sp,-48
    800014a2:	f406                	sd	ra,40(sp)
    800014a4:	f022                	sd	s0,32(sp)
    800014a6:	ec26                	sd	s1,24(sp)
    800014a8:	e84a                	sd	s2,16(sp)
    800014aa:	e44e                	sd	s3,8(sp)
    800014ac:	e052                	sd	s4,0(sp)
    800014ae:	1800                	addi	s0,sp,48
    800014b0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014b2:	8e3ff0ef          	jal	80000d94 <myproc>
    800014b6:	89aa                	mv	s3,a0
  if(p == initproc)
    800014b8:	00006797          	auipc	a5,0x6
    800014bc:	3b87b783          	ld	a5,952(a5) # 80007870 <initproc>
    800014c0:	0d050493          	addi	s1,a0,208
    800014c4:	15050913          	addi	s2,a0,336
    800014c8:	00a79b63          	bne	a5,a0,800014de <kexit+0x3e>
    panic("init exiting");
    800014cc:	00006517          	auipc	a0,0x6
    800014d0:	cb450513          	addi	a0,a0,-844 # 80007180 <etext+0x180>
    800014d4:	4c2040ef          	jal	80005996 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800014d8:	04a1                	addi	s1,s1,8
    800014da:	01248963          	beq	s1,s2,800014ec <kexit+0x4c>
    if(p->ofile[fd]){
    800014de:	6088                	ld	a0,0(s1)
    800014e0:	dd65                	beqz	a0,800014d8 <kexit+0x38>
      fileclose(f);
    800014e2:	0ec020ef          	jal	800035ce <fileclose>
      p->ofile[fd] = 0;
    800014e6:	0004b023          	sd	zero,0(s1)
    800014ea:	b7fd                	j	800014d8 <kexit+0x38>
  begin_op();
    800014ec:	4bf010ef          	jal	800031aa <begin_op>
  iput(p->cwd);
    800014f0:	1509b503          	ld	a0,336(s3)
    800014f4:	42a010ef          	jal	8000291e <iput>
  end_op();
    800014f8:	523010ef          	jal	8000321a <end_op>
  p->cwd = 0;
    800014fc:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001500:	00006517          	auipc	a0,0x6
    80001504:	3c850513          	addi	a0,a0,968 # 800078c8 <wait_lock>
    80001508:	750040ef          	jal	80005c58 <acquire>
  reparent(p);
    8000150c:	854e                	mv	a0,s3
    8000150e:	f3dff0ef          	jal	8000144a <reparent>
  wakeup(p->parent);
    80001512:	0389b503          	ld	a0,56(s3)
    80001516:	ed1ff0ef          	jal	800013e6 <wakeup>
  acquire(&p->lock);
    8000151a:	854e                	mv	a0,s3
    8000151c:	73c040ef          	jal	80005c58 <acquire>
  p->xstate = status;
    80001520:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001524:	4795                	li	a5,5
    80001526:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    8000152a:	00006517          	auipc	a0,0x6
    8000152e:	39e50513          	addi	a0,a0,926 # 800078c8 <wait_lock>
    80001532:	7ba040ef          	jal	80005cec <release>
  sched();
    80001536:	d7dff0ef          	jal	800012b2 <sched>
  panic("zombie exit");
    8000153a:	00006517          	auipc	a0,0x6
    8000153e:	c5650513          	addi	a0,a0,-938 # 80007190 <etext+0x190>
    80001542:	454040ef          	jal	80005996 <panic>

0000000080001546 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001546:	7179                	addi	sp,sp,-48
    80001548:	f406                	sd	ra,40(sp)
    8000154a:	f022                	sd	s0,32(sp)
    8000154c:	ec26                	sd	s1,24(sp)
    8000154e:	e84a                	sd	s2,16(sp)
    80001550:	e44e                	sd	s3,8(sp)
    80001552:	1800                	addi	s0,sp,48
    80001554:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001556:	00006497          	auipc	s1,0x6
    8000155a:	78a48493          	addi	s1,s1,1930 # 80007ce0 <proc>
    8000155e:	00007997          	auipc	s3,0x7
    80001562:	59298993          	addi	s3,s3,1426 # 80008af0 <tickslock>
    acquire(&p->lock);
    80001566:	8526                	mv	a0,s1
    80001568:	6f0040ef          	jal	80005c58 <acquire>
    if(p->pid == pid){
    8000156c:	589c                	lw	a5,48(s1)
    8000156e:	03278163          	beq	a5,s2,80001590 <kkill+0x4a>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001572:	8526                	mv	a0,s1
    80001574:	778040ef          	jal	80005cec <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001578:	16848493          	addi	s1,s1,360
    8000157c:	ff3495e3          	bne	s1,s3,80001566 <kkill+0x20>
  }
  return -1;
    80001580:	557d                	li	a0,-1
}
    80001582:	70a2                	ld	ra,40(sp)
    80001584:	7402                	ld	s0,32(sp)
    80001586:	64e2                	ld	s1,24(sp)
    80001588:	6942                	ld	s2,16(sp)
    8000158a:	69a2                	ld	s3,8(sp)
    8000158c:	6145                	addi	sp,sp,48
    8000158e:	8082                	ret
      p->killed = 1;
    80001590:	4785                	li	a5,1
    80001592:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001594:	4c98                	lw	a4,24(s1)
    80001596:	4789                	li	a5,2
    80001598:	00f70763          	beq	a4,a5,800015a6 <kkill+0x60>
      release(&p->lock);
    8000159c:	8526                	mv	a0,s1
    8000159e:	74e040ef          	jal	80005cec <release>
      return 0;
    800015a2:	4501                	li	a0,0
    800015a4:	bff9                	j	80001582 <kkill+0x3c>
        p->state = RUNNABLE;
    800015a6:	478d                	li	a5,3
    800015a8:	cc9c                	sw	a5,24(s1)
    800015aa:	bfcd                	j	8000159c <kkill+0x56>

00000000800015ac <setkilled>:

void
setkilled(struct proc *p)
{
    800015ac:	1101                	addi	sp,sp,-32
    800015ae:	ec06                	sd	ra,24(sp)
    800015b0:	e822                	sd	s0,16(sp)
    800015b2:	e426                	sd	s1,8(sp)
    800015b4:	1000                	addi	s0,sp,32
    800015b6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015b8:	6a0040ef          	jal	80005c58 <acquire>
  p->killed = 1;
    800015bc:	4785                	li	a5,1
    800015be:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015c0:	8526                	mv	a0,s1
    800015c2:	72a040ef          	jal	80005cec <release>
}
    800015c6:	60e2                	ld	ra,24(sp)
    800015c8:	6442                	ld	s0,16(sp)
    800015ca:	64a2                	ld	s1,8(sp)
    800015cc:	6105                	addi	sp,sp,32
    800015ce:	8082                	ret

00000000800015d0 <killed>:

int
killed(struct proc *p)
{
    800015d0:	1101                	addi	sp,sp,-32
    800015d2:	ec06                	sd	ra,24(sp)
    800015d4:	e822                	sd	s0,16(sp)
    800015d6:	e426                	sd	s1,8(sp)
    800015d8:	e04a                	sd	s2,0(sp)
    800015da:	1000                	addi	s0,sp,32
    800015dc:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015de:	67a040ef          	jal	80005c58 <acquire>
  k = p->killed;
    800015e2:	549c                	lw	a5,40(s1)
    800015e4:	893e                	mv	s2,a5
  release(&p->lock);
    800015e6:	8526                	mv	a0,s1
    800015e8:	704040ef          	jal	80005cec <release>
  return k;
}
    800015ec:	854a                	mv	a0,s2
    800015ee:	60e2                	ld	ra,24(sp)
    800015f0:	6442                	ld	s0,16(sp)
    800015f2:	64a2                	ld	s1,8(sp)
    800015f4:	6902                	ld	s2,0(sp)
    800015f6:	6105                	addi	sp,sp,32
    800015f8:	8082                	ret

00000000800015fa <kwait>:
{
    800015fa:	715d                	addi	sp,sp,-80
    800015fc:	e486                	sd	ra,72(sp)
    800015fe:	e0a2                	sd	s0,64(sp)
    80001600:	fc26                	sd	s1,56(sp)
    80001602:	f84a                	sd	s2,48(sp)
    80001604:	f44e                	sd	s3,40(sp)
    80001606:	f052                	sd	s4,32(sp)
    80001608:	ec56                	sd	s5,24(sp)
    8000160a:	e85a                	sd	s6,16(sp)
    8000160c:	e45e                	sd	s7,8(sp)
    8000160e:	0880                	addi	s0,sp,80
    80001610:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001612:	f82ff0ef          	jal	80000d94 <myproc>
    80001616:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001618:	00006517          	auipc	a0,0x6
    8000161c:	2b050513          	addi	a0,a0,688 # 800078c8 <wait_lock>
    80001620:	638040ef          	jal	80005c58 <acquire>
        if(pp->state == ZOMBIE){
    80001624:	4a15                	li	s4,5
        havekids = 1;
    80001626:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001628:	00007997          	auipc	s3,0x7
    8000162c:	4c898993          	addi	s3,s3,1224 # 80008af0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001630:	00006b17          	auipc	s6,0x6
    80001634:	298b0b13          	addi	s6,s6,664 # 800078c8 <wait_lock>
    80001638:	a869                	j	800016d2 <kwait+0xd8>
          pid = pp->pid;
    8000163a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000163e:	000b8c63          	beqz	s7,80001656 <kwait+0x5c>
    80001642:	4691                	li	a3,4
    80001644:	02c48613          	addi	a2,s1,44
    80001648:	85de                	mv	a1,s7
    8000164a:	05093503          	ld	a0,80(s2)
    8000164e:	c6cff0ef          	jal	80000aba <copyout>
    80001652:	02054a63          	bltz	a0,80001686 <kwait+0x8c>
          freeproc(pp);
    80001656:	8526                	mv	a0,s1
    80001658:	911ff0ef          	jal	80000f68 <freeproc>
          release(&pp->lock);
    8000165c:	8526                	mv	a0,s1
    8000165e:	68e040ef          	jal	80005cec <release>
          release(&wait_lock);
    80001662:	00006517          	auipc	a0,0x6
    80001666:	26650513          	addi	a0,a0,614 # 800078c8 <wait_lock>
    8000166a:	682040ef          	jal	80005cec <release>
}
    8000166e:	854e                	mv	a0,s3
    80001670:	60a6                	ld	ra,72(sp)
    80001672:	6406                	ld	s0,64(sp)
    80001674:	74e2                	ld	s1,56(sp)
    80001676:	7942                	ld	s2,48(sp)
    80001678:	79a2                	ld	s3,40(sp)
    8000167a:	7a02                	ld	s4,32(sp)
    8000167c:	6ae2                	ld	s5,24(sp)
    8000167e:	6b42                	ld	s6,16(sp)
    80001680:	6ba2                	ld	s7,8(sp)
    80001682:	6161                	addi	sp,sp,80
    80001684:	8082                	ret
            release(&pp->lock);
    80001686:	8526                	mv	a0,s1
    80001688:	664040ef          	jal	80005cec <release>
            release(&wait_lock);
    8000168c:	00006517          	auipc	a0,0x6
    80001690:	23c50513          	addi	a0,a0,572 # 800078c8 <wait_lock>
    80001694:	658040ef          	jal	80005cec <release>
            return -1;
    80001698:	59fd                	li	s3,-1
    8000169a:	bfd1                	j	8000166e <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000169c:	16848493          	addi	s1,s1,360
    800016a0:	03348063          	beq	s1,s3,800016c0 <kwait+0xc6>
      if(pp->parent == p){
    800016a4:	7c9c                	ld	a5,56(s1)
    800016a6:	ff279be3          	bne	a5,s2,8000169c <kwait+0xa2>
        acquire(&pp->lock);
    800016aa:	8526                	mv	a0,s1
    800016ac:	5ac040ef          	jal	80005c58 <acquire>
        if(pp->state == ZOMBIE){
    800016b0:	4c9c                	lw	a5,24(s1)
    800016b2:	f94784e3          	beq	a5,s4,8000163a <kwait+0x40>
        release(&pp->lock);
    800016b6:	8526                	mv	a0,s1
    800016b8:	634040ef          	jal	80005cec <release>
        havekids = 1;
    800016bc:	8756                	mv	a4,s5
    800016be:	bff9                	j	8000169c <kwait+0xa2>
    if(!havekids || killed(p)){
    800016c0:	cf19                	beqz	a4,800016de <kwait+0xe4>
    800016c2:	854a                	mv	a0,s2
    800016c4:	f0dff0ef          	jal	800015d0 <killed>
    800016c8:	e919                	bnez	a0,800016de <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016ca:	85da                	mv	a1,s6
    800016cc:	854a                	mv	a0,s2
    800016ce:	ccdff0ef          	jal	8000139a <sleep>
    havekids = 0;
    800016d2:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016d4:	00006497          	auipc	s1,0x6
    800016d8:	60c48493          	addi	s1,s1,1548 # 80007ce0 <proc>
    800016dc:	b7e1                	j	800016a4 <kwait+0xaa>
      release(&wait_lock);
    800016de:	00006517          	auipc	a0,0x6
    800016e2:	1ea50513          	addi	a0,a0,490 # 800078c8 <wait_lock>
    800016e6:	606040ef          	jal	80005cec <release>
      return -1;
    800016ea:	59fd                	li	s3,-1
    800016ec:	b749                	j	8000166e <kwait+0x74>

00000000800016ee <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016ee:	7179                	addi	sp,sp,-48
    800016f0:	f406                	sd	ra,40(sp)
    800016f2:	f022                	sd	s0,32(sp)
    800016f4:	ec26                	sd	s1,24(sp)
    800016f6:	e84a                	sd	s2,16(sp)
    800016f8:	e44e                	sd	s3,8(sp)
    800016fa:	e052                	sd	s4,0(sp)
    800016fc:	1800                	addi	s0,sp,48
    800016fe:	84aa                	mv	s1,a0
    80001700:	8a2e                	mv	s4,a1
    80001702:	89b2                	mv	s3,a2
    80001704:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001706:	e8eff0ef          	jal	80000d94 <myproc>
  if(user_dst){
    8000170a:	cc99                	beqz	s1,80001728 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    8000170c:	86ca                	mv	a3,s2
    8000170e:	864e                	mv	a2,s3
    80001710:	85d2                	mv	a1,s4
    80001712:	6928                	ld	a0,80(a0)
    80001714:	ba6ff0ef          	jal	80000aba <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001718:	70a2                	ld	ra,40(sp)
    8000171a:	7402                	ld	s0,32(sp)
    8000171c:	64e2                	ld	s1,24(sp)
    8000171e:	6942                	ld	s2,16(sp)
    80001720:	69a2                	ld	s3,8(sp)
    80001722:	6a02                	ld	s4,0(sp)
    80001724:	6145                	addi	sp,sp,48
    80001726:	8082                	ret
    memmove((char *)dst, src, len);
    80001728:	0009061b          	sext.w	a2,s2
    8000172c:	85ce                	mv	a1,s3
    8000172e:	8552                	mv	a0,s4
    80001730:	a8ffe0ef          	jal	800001be <memmove>
    return 0;
    80001734:	8526                	mv	a0,s1
    80001736:	b7cd                	j	80001718 <either_copyout+0x2a>

0000000080001738 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001738:	7179                	addi	sp,sp,-48
    8000173a:	f406                	sd	ra,40(sp)
    8000173c:	f022                	sd	s0,32(sp)
    8000173e:	ec26                	sd	s1,24(sp)
    80001740:	e84a                	sd	s2,16(sp)
    80001742:	e44e                	sd	s3,8(sp)
    80001744:	e052                	sd	s4,0(sp)
    80001746:	1800                	addi	s0,sp,48
    80001748:	8a2a                	mv	s4,a0
    8000174a:	84ae                	mv	s1,a1
    8000174c:	89b2                	mv	s3,a2
    8000174e:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001750:	e44ff0ef          	jal	80000d94 <myproc>
  if(user_src){
    80001754:	cc99                	beqz	s1,80001772 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001756:	86ca                	mv	a3,s2
    80001758:	864e                	mv	a2,s3
    8000175a:	85d2                	mv	a1,s4
    8000175c:	6928                	ld	a0,80(a0)
    8000175e:	c1aff0ef          	jal	80000b78 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001762:	70a2                	ld	ra,40(sp)
    80001764:	7402                	ld	s0,32(sp)
    80001766:	64e2                	ld	s1,24(sp)
    80001768:	6942                	ld	s2,16(sp)
    8000176a:	69a2                	ld	s3,8(sp)
    8000176c:	6a02                	ld	s4,0(sp)
    8000176e:	6145                	addi	sp,sp,48
    80001770:	8082                	ret
    memmove(dst, (char*)src, len);
    80001772:	0009061b          	sext.w	a2,s2
    80001776:	85ce                	mv	a1,s3
    80001778:	8552                	mv	a0,s4
    8000177a:	a45fe0ef          	jal	800001be <memmove>
    return 0;
    8000177e:	8526                	mv	a0,s1
    80001780:	b7cd                	j	80001762 <either_copyin+0x2a>

0000000080001782 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001782:	715d                	addi	sp,sp,-80
    80001784:	e486                	sd	ra,72(sp)
    80001786:	e0a2                	sd	s0,64(sp)
    80001788:	fc26                	sd	s1,56(sp)
    8000178a:	f84a                	sd	s2,48(sp)
    8000178c:	f44e                	sd	s3,40(sp)
    8000178e:	f052                	sd	s4,32(sp)
    80001790:	ec56                	sd	s5,24(sp)
    80001792:	e85a                	sd	s6,16(sp)
    80001794:	e45e                	sd	s7,8(sp)
    80001796:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001798:	00006517          	auipc	a0,0x6
    8000179c:	88050513          	addi	a0,a0,-1920 # 80007018 <etext+0x18>
    800017a0:	6cd030ef          	jal	8000566c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017a4:	00006497          	auipc	s1,0x6
    800017a8:	69448493          	addi	s1,s1,1684 # 80007e38 <proc+0x158>
    800017ac:	00007917          	auipc	s2,0x7
    800017b0:	49c90913          	addi	s2,s2,1180 # 80008c48 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017b4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017b6:	00006997          	auipc	s3,0x6
    800017ba:	9ea98993          	addi	s3,s3,-1558 # 800071a0 <etext+0x1a0>
    printf("%d %s %s", p->pid, state, p->name);
    800017be:	00006a97          	auipc	s5,0x6
    800017c2:	9eaa8a93          	addi	s5,s5,-1558 # 800071a8 <etext+0x1a8>
    printf("\n");
    800017c6:	00006a17          	auipc	s4,0x6
    800017ca:	852a0a13          	addi	s4,s4,-1966 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ce:	00006b97          	auipc	s7,0x6
    800017d2:	f62b8b93          	addi	s7,s7,-158 # 80007730 <states.0>
    800017d6:	a829                	j	800017f0 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017d8:	ed86a583          	lw	a1,-296(a3)
    800017dc:	8556                	mv	a0,s5
    800017de:	68f030ef          	jal	8000566c <printf>
    printf("\n");
    800017e2:	8552                	mv	a0,s4
    800017e4:	689030ef          	jal	8000566c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017e8:	16848493          	addi	s1,s1,360
    800017ec:	03248263          	beq	s1,s2,80001810 <procdump+0x8e>
    if(p->state == UNUSED)
    800017f0:	86a6                	mv	a3,s1
    800017f2:	ec04a783          	lw	a5,-320(s1)
    800017f6:	dbed                	beqz	a5,800017e8 <procdump+0x66>
      state = "???";
    800017f8:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017fa:	fcfb6fe3          	bltu	s6,a5,800017d8 <procdump+0x56>
    800017fe:	02079713          	slli	a4,a5,0x20
    80001802:	01d75793          	srli	a5,a4,0x1d
    80001806:	97de                	add	a5,a5,s7
    80001808:	6390                	ld	a2,0(a5)
    8000180a:	f679                	bnez	a2,800017d8 <procdump+0x56>
      state = "???";
    8000180c:	864e                	mv	a2,s3
    8000180e:	b7e9                	j	800017d8 <procdump+0x56>
  }
}
    80001810:	60a6                	ld	ra,72(sp)
    80001812:	6406                	ld	s0,64(sp)
    80001814:	74e2                	ld	s1,56(sp)
    80001816:	7942                	ld	s2,48(sp)
    80001818:	79a2                	ld	s3,40(sp)
    8000181a:	7a02                	ld	s4,32(sp)
    8000181c:	6ae2                	ld	s5,24(sp)
    8000181e:	6b42                	ld	s6,16(sp)
    80001820:	6ba2                	ld	s7,8(sp)
    80001822:	6161                	addi	sp,sp,80
    80001824:	8082                	ret

0000000080001826 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001826:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    8000182a:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    8000182e:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001830:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001832:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001836:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    8000183a:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    8000183e:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001842:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001846:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    8000184a:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    8000184e:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001852:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001856:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    8000185a:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    8000185e:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001862:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001864:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001866:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    8000186a:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    8000186e:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001872:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001876:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    8000187a:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    8000187e:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001882:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001886:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    8000188a:	0685bd83          	ld	s11,104(a1)
        
        ret
    8000188e:	8082                	ret

0000000080001890 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001890:	1141                	addi	sp,sp,-16
    80001892:	e406                	sd	ra,8(sp)
    80001894:	e022                	sd	s0,0(sp)
    80001896:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001898:	00006597          	auipc	a1,0x6
    8000189c:	95058593          	addi	a1,a1,-1712 # 800071e8 <etext+0x1e8>
    800018a0:	00007517          	auipc	a0,0x7
    800018a4:	25050513          	addi	a0,a0,592 # 80008af0 <tickslock>
    800018a8:	326040ef          	jal	80005bce <initlock>
}
    800018ac:	60a2                	ld	ra,8(sp)
    800018ae:	6402                	ld	s0,0(sp)
    800018b0:	0141                	addi	sp,sp,16
    800018b2:	8082                	ret

00000000800018b4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018b4:	1141                	addi	sp,sp,-16
    800018b6:	e406                	sd	ra,8(sp)
    800018b8:	e022                	sd	s0,0(sp)
    800018ba:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018bc:	00003797          	auipc	a5,0x3
    800018c0:	2e478793          	addi	a5,a5,740 # 80004ba0 <kernelvec>
    800018c4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018c8:	60a2                	ld	ra,8(sp)
    800018ca:	6402                	ld	s0,0(sp)
    800018cc:	0141                	addi	sp,sp,16
    800018ce:	8082                	ret

00000000800018d0 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018d0:	1141                	addi	sp,sp,-16
    800018d2:	e406                	sd	ra,8(sp)
    800018d4:	e022                	sd	s0,0(sp)
    800018d6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018d8:	cbcff0ef          	jal	80000d94 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018dc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018e0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018e2:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018e6:	04000737          	lui	a4,0x4000
    800018ea:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018ec:	0732                	slli	a4,a4,0xc
    800018ee:	00004797          	auipc	a5,0x4
    800018f2:	71278793          	addi	a5,a5,1810 # 80006000 <_trampoline>
    800018f6:	00004697          	auipc	a3,0x4
    800018fa:	70a68693          	addi	a3,a3,1802 # 80006000 <_trampoline>
    800018fe:	8f95                	sub	a5,a5,a3
    80001900:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001902:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001906:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001908:	18002773          	csrr	a4,satp
    8000190c:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    8000190e:	6d38                	ld	a4,88(a0)
    80001910:	613c                	ld	a5,64(a0)
    80001912:	6685                	lui	a3,0x1
    80001914:	97b6                	add	a5,a5,a3
    80001916:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001918:	6d3c                	ld	a5,88(a0)
    8000191a:	00000717          	auipc	a4,0x0
    8000191e:	0fc70713          	addi	a4,a4,252 # 80001a16 <usertrap>
    80001922:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001924:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001926:	8712                	mv	a4,tp
    80001928:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000192a:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    8000192e:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001932:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001936:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    8000193a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000193c:	6f9c                	ld	a5,24(a5)
    8000193e:	14179073          	csrw	sepc,a5
}
    80001942:	60a2                	ld	ra,8(sp)
    80001944:	6402                	ld	s0,0(sp)
    80001946:	0141                	addi	sp,sp,16
    80001948:	8082                	ret

000000008000194a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    8000194a:	1141                	addi	sp,sp,-16
    8000194c:	e406                	sd	ra,8(sp)
    8000194e:	e022                	sd	s0,0(sp)
    80001950:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001952:	c0eff0ef          	jal	80000d60 <cpuid>
    80001956:	cd11                	beqz	a0,80001972 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001958:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    8000195c:	000f4737          	lui	a4,0xf4
    80001960:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001964:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001966:	14d79073          	csrw	stimecmp,a5
}
    8000196a:	60a2                	ld	ra,8(sp)
    8000196c:	6402                	ld	s0,0(sp)
    8000196e:	0141                	addi	sp,sp,16
    80001970:	8082                	ret
    acquire(&tickslock);
    80001972:	00007517          	auipc	a0,0x7
    80001976:	17e50513          	addi	a0,a0,382 # 80008af0 <tickslock>
    8000197a:	2de040ef          	jal	80005c58 <acquire>
    ticks++;
    8000197e:	00006717          	auipc	a4,0x6
    80001982:	efa70713          	addi	a4,a4,-262 # 80007878 <ticks>
    80001986:	431c                	lw	a5,0(a4)
    80001988:	2785                	addiw	a5,a5,1
    8000198a:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    8000198c:	853a                	mv	a0,a4
    8000198e:	a59ff0ef          	jal	800013e6 <wakeup>
    release(&tickslock);
    80001992:	00007517          	auipc	a0,0x7
    80001996:	15e50513          	addi	a0,a0,350 # 80008af0 <tickslock>
    8000199a:	352040ef          	jal	80005cec <release>
    8000199e:	bf6d                	j	80001958 <clockintr+0xe>

00000000800019a0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019a0:	1101                	addi	sp,sp,-32
    800019a2:	ec06                	sd	ra,24(sp)
    800019a4:	e822                	sd	s0,16(sp)
    800019a6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019a8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019ac:	57fd                	li	a5,-1
    800019ae:	17fe                	slli	a5,a5,0x3f
    800019b0:	07a5                	addi	a5,a5,9
    800019b2:	00f70c63          	beq	a4,a5,800019ca <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019b6:	57fd                	li	a5,-1
    800019b8:	17fe                	slli	a5,a5,0x3f
    800019ba:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019bc:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019be:	04f70863          	beq	a4,a5,80001a0e <devintr+0x6e>
  }
}
    800019c2:	60e2                	ld	ra,24(sp)
    800019c4:	6442                	ld	s0,16(sp)
    800019c6:	6105                	addi	sp,sp,32
    800019c8:	8082                	ret
    800019ca:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019cc:	280030ef          	jal	80004c4c <plic_claim>
    800019d0:	872a                	mv	a4,a0
    800019d2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019d4:	47a9                	li	a5,10
    800019d6:	00f50963          	beq	a0,a5,800019e8 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    800019da:	4785                	li	a5,1
    800019dc:	00f50963          	beq	a0,a5,800019ee <devintr+0x4e>
    return 1;
    800019e0:	4505                	li	a0,1
    } else if(irq){
    800019e2:	eb09                	bnez	a4,800019f4 <devintr+0x54>
    800019e4:	64a2                	ld	s1,8(sp)
    800019e6:	bff1                	j	800019c2 <devintr+0x22>
      uartintr();
    800019e8:	17e040ef          	jal	80005b66 <uartintr>
    if(irq)
    800019ec:	a819                	j	80001a02 <devintr+0x62>
      virtio_disk_intr();
    800019ee:	6f4030ef          	jal	800050e2 <virtio_disk_intr>
    if(irq)
    800019f2:	a801                	j	80001a02 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    800019f4:	85ba                	mv	a1,a4
    800019f6:	00005517          	auipc	a0,0x5
    800019fa:	7fa50513          	addi	a0,a0,2042 # 800071f0 <etext+0x1f0>
    800019fe:	46f030ef          	jal	8000566c <printf>
      plic_complete(irq);
    80001a02:	8526                	mv	a0,s1
    80001a04:	268030ef          	jal	80004c6c <plic_complete>
    return 1;
    80001a08:	4505                	li	a0,1
    80001a0a:	64a2                	ld	s1,8(sp)
    80001a0c:	bf5d                	j	800019c2 <devintr+0x22>
    clockintr();
    80001a0e:	f3dff0ef          	jal	8000194a <clockintr>
    return 2;
    80001a12:	4509                	li	a0,2
    80001a14:	b77d                	j	800019c2 <devintr+0x22>

0000000080001a16 <usertrap>:
{
    80001a16:	1101                	addi	sp,sp,-32
    80001a18:	ec06                	sd	ra,24(sp)
    80001a1a:	e822                	sd	s0,16(sp)
    80001a1c:	e426                	sd	s1,8(sp)
    80001a1e:	e04a                	sd	s2,0(sp)
    80001a20:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a22:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a26:	1007f793          	andi	a5,a5,256
    80001a2a:	eba5                	bnez	a5,80001a9a <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a2c:	00003797          	auipc	a5,0x3
    80001a30:	17478793          	addi	a5,a5,372 # 80004ba0 <kernelvec>
    80001a34:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a38:	b5cff0ef          	jal	80000d94 <myproc>
    80001a3c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a3e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a40:	14102773          	csrr	a4,sepc
    80001a44:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a46:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a4a:	47a1                	li	a5,8
    80001a4c:	04f70d63          	beq	a4,a5,80001aa6 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a50:	f51ff0ef          	jal	800019a0 <devintr>
    80001a54:	892a                	mv	s2,a0
    80001a56:	e945                	bnez	a0,80001b06 <usertrap+0xf0>
    80001a58:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a5c:	47bd                	li	a5,15
    80001a5e:	08f70863          	beq	a4,a5,80001aee <usertrap+0xd8>
    80001a62:	14202773          	csrr	a4,scause
    80001a66:	47b5                	li	a5,13
    80001a68:	08f70363          	beq	a4,a5,80001aee <usertrap+0xd8>
    80001a6c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a70:	5890                	lw	a2,48(s1)
    80001a72:	00005517          	auipc	a0,0x5
    80001a76:	7be50513          	addi	a0,a0,1982 # 80007230 <etext+0x230>
    80001a7a:	3f3030ef          	jal	8000566c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a7e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a82:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a86:	00005517          	auipc	a0,0x5
    80001a8a:	7da50513          	addi	a0,a0,2010 # 80007260 <etext+0x260>
    80001a8e:	3df030ef          	jal	8000566c <printf>
    setkilled(p);
    80001a92:	8526                	mv	a0,s1
    80001a94:	b19ff0ef          	jal	800015ac <setkilled>
    80001a98:	a035                	j	80001ac4 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001a9a:	00005517          	auipc	a0,0x5
    80001a9e:	77650513          	addi	a0,a0,1910 # 80007210 <etext+0x210>
    80001aa2:	6f5030ef          	jal	80005996 <panic>
    if(killed(p))
    80001aa6:	b2bff0ef          	jal	800015d0 <killed>
    80001aaa:	ed15                	bnez	a0,80001ae6 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001aac:	6cb8                	ld	a4,88(s1)
    80001aae:	6f1c                	ld	a5,24(a4)
    80001ab0:	0791                	addi	a5,a5,4
    80001ab2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ab4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001ab8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001abc:	10079073          	csrw	sstatus,a5
    syscall();
    80001ac0:	240000ef          	jal	80001d00 <syscall>
  if(killed(p))
    80001ac4:	8526                	mv	a0,s1
    80001ac6:	b0bff0ef          	jal	800015d0 <killed>
    80001aca:	e139                	bnez	a0,80001b10 <usertrap+0xfa>
  prepare_return();
    80001acc:	e05ff0ef          	jal	800018d0 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ad0:	68a8                	ld	a0,80(s1)
    80001ad2:	8131                	srli	a0,a0,0xc
    80001ad4:	57fd                	li	a5,-1
    80001ad6:	17fe                	slli	a5,a5,0x3f
    80001ad8:	8d5d                	or	a0,a0,a5
}
    80001ada:	60e2                	ld	ra,24(sp)
    80001adc:	6442                	ld	s0,16(sp)
    80001ade:	64a2                	ld	s1,8(sp)
    80001ae0:	6902                	ld	s2,0(sp)
    80001ae2:	6105                	addi	sp,sp,32
    80001ae4:	8082                	ret
      kexit(-1);
    80001ae6:	557d                	li	a0,-1
    80001ae8:	9b9ff0ef          	jal	800014a0 <kexit>
    80001aec:	b7c1                	j	80001aac <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001aee:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001af2:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001af6:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001af8:	00163613          	seqz	a2,a2
    80001afc:	68a8                	ld	a0,80(s1)
    80001afe:	f39fe0ef          	jal	80000a36 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b02:	f169                	bnez	a0,80001ac4 <usertrap+0xae>
    80001b04:	b7a5                	j	80001a6c <usertrap+0x56>
  if(killed(p))
    80001b06:	8526                	mv	a0,s1
    80001b08:	ac9ff0ef          	jal	800015d0 <killed>
    80001b0c:	c511                	beqz	a0,80001b18 <usertrap+0x102>
    80001b0e:	a011                	j	80001b12 <usertrap+0xfc>
    80001b10:	4901                	li	s2,0
    kexit(-1);
    80001b12:	557d                	li	a0,-1
    80001b14:	98dff0ef          	jal	800014a0 <kexit>
  if(which_dev == 2)
    80001b18:	4789                	li	a5,2
    80001b1a:	faf919e3          	bne	s2,a5,80001acc <usertrap+0xb6>
    yield();
    80001b1e:	851ff0ef          	jal	8000136e <yield>
    80001b22:	b76d                	j	80001acc <usertrap+0xb6>

0000000080001b24 <kerneltrap>:
{
    80001b24:	7179                	addi	sp,sp,-48
    80001b26:	f406                	sd	ra,40(sp)
    80001b28:	f022                	sd	s0,32(sp)
    80001b2a:	ec26                	sd	s1,24(sp)
    80001b2c:	e84a                	sd	s2,16(sp)
    80001b2e:	e44e                	sd	s3,8(sp)
    80001b30:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b32:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b36:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b3a:	142027f3          	csrr	a5,scause
    80001b3e:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001b40:	1004f793          	andi	a5,s1,256
    80001b44:	c795                	beqz	a5,80001b70 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b4a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b4c:	eb85                	bnez	a5,80001b7c <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001b4e:	e53ff0ef          	jal	800019a0 <devintr>
    80001b52:	c91d                	beqz	a0,80001b88 <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001b54:	4789                	li	a5,2
    80001b56:	04f50a63          	beq	a0,a5,80001baa <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b5a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b5e:	10049073          	csrw	sstatus,s1
}
    80001b62:	70a2                	ld	ra,40(sp)
    80001b64:	7402                	ld	s0,32(sp)
    80001b66:	64e2                	ld	s1,24(sp)
    80001b68:	6942                	ld	s2,16(sp)
    80001b6a:	69a2                	ld	s3,8(sp)
    80001b6c:	6145                	addi	sp,sp,48
    80001b6e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b70:	00005517          	auipc	a0,0x5
    80001b74:	71850513          	addi	a0,a0,1816 # 80007288 <etext+0x288>
    80001b78:	61f030ef          	jal	80005996 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b7c:	00005517          	auipc	a0,0x5
    80001b80:	73450513          	addi	a0,a0,1844 # 800072b0 <etext+0x2b0>
    80001b84:	613030ef          	jal	80005996 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b88:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b8c:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b90:	85ce                	mv	a1,s3
    80001b92:	00005517          	auipc	a0,0x5
    80001b96:	73e50513          	addi	a0,a0,1854 # 800072d0 <etext+0x2d0>
    80001b9a:	2d3030ef          	jal	8000566c <printf>
    panic("kerneltrap");
    80001b9e:	00005517          	auipc	a0,0x5
    80001ba2:	75a50513          	addi	a0,a0,1882 # 800072f8 <etext+0x2f8>
    80001ba6:	5f1030ef          	jal	80005996 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001baa:	9eaff0ef          	jal	80000d94 <myproc>
    80001bae:	d555                	beqz	a0,80001b5a <kerneltrap+0x36>
    yield();
    80001bb0:	fbeff0ef          	jal	8000136e <yield>
    80001bb4:	b75d                	j	80001b5a <kerneltrap+0x36>

0000000080001bb6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bb6:	1101                	addi	sp,sp,-32
    80001bb8:	ec06                	sd	ra,24(sp)
    80001bba:	e822                	sd	s0,16(sp)
    80001bbc:	e426                	sd	s1,8(sp)
    80001bbe:	1000                	addi	s0,sp,32
    80001bc0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bc2:	9d2ff0ef          	jal	80000d94 <myproc>
  switch (n) {
    80001bc6:	4795                	li	a5,5
    80001bc8:	0497e163          	bltu	a5,s1,80001c0a <argraw+0x54>
    80001bcc:	048a                	slli	s1,s1,0x2
    80001bce:	00006717          	auipc	a4,0x6
    80001bd2:	b9270713          	addi	a4,a4,-1134 # 80007760 <states.0+0x30>
    80001bd6:	94ba                	add	s1,s1,a4
    80001bd8:	409c                	lw	a5,0(s1)
    80001bda:	97ba                	add	a5,a5,a4
    80001bdc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001bde:	6d3c                	ld	a5,88(a0)
    80001be0:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001be2:	60e2                	ld	ra,24(sp)
    80001be4:	6442                	ld	s0,16(sp)
    80001be6:	64a2                	ld	s1,8(sp)
    80001be8:	6105                	addi	sp,sp,32
    80001bea:	8082                	ret
    return p->trapframe->a1;
    80001bec:	6d3c                	ld	a5,88(a0)
    80001bee:	7fa8                	ld	a0,120(a5)
    80001bf0:	bfcd                	j	80001be2 <argraw+0x2c>
    return p->trapframe->a2;
    80001bf2:	6d3c                	ld	a5,88(a0)
    80001bf4:	63c8                	ld	a0,128(a5)
    80001bf6:	b7f5                	j	80001be2 <argraw+0x2c>
    return p->trapframe->a3;
    80001bf8:	6d3c                	ld	a5,88(a0)
    80001bfa:	67c8                	ld	a0,136(a5)
    80001bfc:	b7dd                	j	80001be2 <argraw+0x2c>
    return p->trapframe->a4;
    80001bfe:	6d3c                	ld	a5,88(a0)
    80001c00:	6bc8                	ld	a0,144(a5)
    80001c02:	b7c5                	j	80001be2 <argraw+0x2c>
    return p->trapframe->a5;
    80001c04:	6d3c                	ld	a5,88(a0)
    80001c06:	6fc8                	ld	a0,152(a5)
    80001c08:	bfe9                	j	80001be2 <argraw+0x2c>
  panic("argraw");
    80001c0a:	00005517          	auipc	a0,0x5
    80001c0e:	6fe50513          	addi	a0,a0,1790 # 80007308 <etext+0x308>
    80001c12:	585030ef          	jal	80005996 <panic>

0000000080001c16 <fetchaddr>:
{
    80001c16:	1101                	addi	sp,sp,-32
    80001c18:	ec06                	sd	ra,24(sp)
    80001c1a:	e822                	sd	s0,16(sp)
    80001c1c:	e426                	sd	s1,8(sp)
    80001c1e:	e04a                	sd	s2,0(sp)
    80001c20:	1000                	addi	s0,sp,32
    80001c22:	84aa                	mv	s1,a0
    80001c24:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c26:	96eff0ef          	jal	80000d94 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c2a:	653c                	ld	a5,72(a0)
    80001c2c:	02f4f663          	bgeu	s1,a5,80001c58 <fetchaddr+0x42>
    80001c30:	00848713          	addi	a4,s1,8
    80001c34:	02e7e463          	bltu	a5,a4,80001c5c <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c38:	46a1                	li	a3,8
    80001c3a:	8626                	mv	a2,s1
    80001c3c:	85ca                	mv	a1,s2
    80001c3e:	6928                	ld	a0,80(a0)
    80001c40:	f39fe0ef          	jal	80000b78 <copyin>
    80001c44:	00a03533          	snez	a0,a0
    80001c48:	40a0053b          	negw	a0,a0
}
    80001c4c:	60e2                	ld	ra,24(sp)
    80001c4e:	6442                	ld	s0,16(sp)
    80001c50:	64a2                	ld	s1,8(sp)
    80001c52:	6902                	ld	s2,0(sp)
    80001c54:	6105                	addi	sp,sp,32
    80001c56:	8082                	ret
    return -1;
    80001c58:	557d                	li	a0,-1
    80001c5a:	bfcd                	j	80001c4c <fetchaddr+0x36>
    80001c5c:	557d                	li	a0,-1
    80001c5e:	b7fd                	j	80001c4c <fetchaddr+0x36>

0000000080001c60 <fetchstr>:
{
    80001c60:	7179                	addi	sp,sp,-48
    80001c62:	f406                	sd	ra,40(sp)
    80001c64:	f022                	sd	s0,32(sp)
    80001c66:	ec26                	sd	s1,24(sp)
    80001c68:	e84a                	sd	s2,16(sp)
    80001c6a:	e44e                	sd	s3,8(sp)
    80001c6c:	1800                	addi	s0,sp,48
    80001c6e:	89aa                	mv	s3,a0
    80001c70:	84ae                	mv	s1,a1
    80001c72:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001c74:	920ff0ef          	jal	80000d94 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c78:	86ca                	mv	a3,s2
    80001c7a:	864e                	mv	a2,s3
    80001c7c:	85a6                	mv	a1,s1
    80001c7e:	6928                	ld	a0,80(a0)
    80001c80:	cdffe0ef          	jal	8000095e <copyinstr>
    80001c84:	00054c63          	bltz	a0,80001c9c <fetchstr+0x3c>
  return strlen(buf);
    80001c88:	8526                	mv	a0,s1
    80001c8a:	e5efe0ef          	jal	800002e8 <strlen>
}
    80001c8e:	70a2                	ld	ra,40(sp)
    80001c90:	7402                	ld	s0,32(sp)
    80001c92:	64e2                	ld	s1,24(sp)
    80001c94:	6942                	ld	s2,16(sp)
    80001c96:	69a2                	ld	s3,8(sp)
    80001c98:	6145                	addi	sp,sp,48
    80001c9a:	8082                	ret
    return -1;
    80001c9c:	557d                	li	a0,-1
    80001c9e:	bfc5                	j	80001c8e <fetchstr+0x2e>

0000000080001ca0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ca0:	1101                	addi	sp,sp,-32
    80001ca2:	ec06                	sd	ra,24(sp)
    80001ca4:	e822                	sd	s0,16(sp)
    80001ca6:	e426                	sd	s1,8(sp)
    80001ca8:	1000                	addi	s0,sp,32
    80001caa:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cac:	f0bff0ef          	jal	80001bb6 <argraw>
    80001cb0:	c088                	sw	a0,0(s1)
}
    80001cb2:	60e2                	ld	ra,24(sp)
    80001cb4:	6442                	ld	s0,16(sp)
    80001cb6:	64a2                	ld	s1,8(sp)
    80001cb8:	6105                	addi	sp,sp,32
    80001cba:	8082                	ret

0000000080001cbc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cbc:	1101                	addi	sp,sp,-32
    80001cbe:	ec06                	sd	ra,24(sp)
    80001cc0:	e822                	sd	s0,16(sp)
    80001cc2:	e426                	sd	s1,8(sp)
    80001cc4:	1000                	addi	s0,sp,32
    80001cc6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cc8:	eefff0ef          	jal	80001bb6 <argraw>
    80001ccc:	e088                	sd	a0,0(s1)
}
    80001cce:	60e2                	ld	ra,24(sp)
    80001cd0:	6442                	ld	s0,16(sp)
    80001cd2:	64a2                	ld	s1,8(sp)
    80001cd4:	6105                	addi	sp,sp,32
    80001cd6:	8082                	ret

0000000080001cd8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cd8:	1101                	addi	sp,sp,-32
    80001cda:	ec06                	sd	ra,24(sp)
    80001cdc:	e822                	sd	s0,16(sp)
    80001cde:	e426                	sd	s1,8(sp)
    80001ce0:	e04a                	sd	s2,0(sp)
    80001ce2:	1000                	addi	s0,sp,32
    80001ce4:	892e                	mv	s2,a1
    80001ce6:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001ce8:	ecfff0ef          	jal	80001bb6 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001cec:	8626                	mv	a2,s1
    80001cee:	85ca                	mv	a1,s2
    80001cf0:	f71ff0ef          	jal	80001c60 <fetchstr>
}
    80001cf4:	60e2                	ld	ra,24(sp)
    80001cf6:	6442                	ld	s0,16(sp)
    80001cf8:	64a2                	ld	s1,8(sp)
    80001cfa:	6902                	ld	s2,0(sp)
    80001cfc:	6105                	addi	sp,sp,32
    80001cfe:	8082                	ret

0000000080001d00 <syscall>:
[SYS_symlink]   sys_symlink,
};

void
syscall(void)
{
    80001d00:	1101                	addi	sp,sp,-32
    80001d02:	ec06                	sd	ra,24(sp)
    80001d04:	e822                	sd	s0,16(sp)
    80001d06:	e426                	sd	s1,8(sp)
    80001d08:	e04a                	sd	s2,0(sp)
    80001d0a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001d0c:	888ff0ef          	jal	80000d94 <myproc>
    80001d10:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d12:	05853903          	ld	s2,88(a0)
    80001d16:	0a893783          	ld	a5,168(s2)
    80001d1a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d1e:	37fd                	addiw	a5,a5,-1
    80001d20:	4755                	li	a4,21
    80001d22:	00f76f63          	bltu	a4,a5,80001d40 <syscall+0x40>
    80001d26:	00369713          	slli	a4,a3,0x3
    80001d2a:	00006797          	auipc	a5,0x6
    80001d2e:	a4e78793          	addi	a5,a5,-1458 # 80007778 <syscalls>
    80001d32:	97ba                	add	a5,a5,a4
    80001d34:	639c                	ld	a5,0(a5)
    80001d36:	c789                	beqz	a5,80001d40 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001d38:	9782                	jalr	a5
    80001d3a:	06a93823          	sd	a0,112(s2)
    80001d3e:	a829                	j	80001d58 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001d40:	15848613          	addi	a2,s1,344
    80001d44:	588c                	lw	a1,48(s1)
    80001d46:	00005517          	auipc	a0,0x5
    80001d4a:	5ca50513          	addi	a0,a0,1482 # 80007310 <etext+0x310>
    80001d4e:	11f030ef          	jal	8000566c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001d52:	6cbc                	ld	a5,88(s1)
    80001d54:	577d                	li	a4,-1
    80001d56:	fbb8                	sd	a4,112(a5)
  }
}
    80001d58:	60e2                	ld	ra,24(sp)
    80001d5a:	6442                	ld	s0,16(sp)
    80001d5c:	64a2                	ld	s1,8(sp)
    80001d5e:	6902                	ld	s2,0(sp)
    80001d60:	6105                	addi	sp,sp,32
    80001d62:	8082                	ret

0000000080001d64 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001d64:	1101                	addi	sp,sp,-32
    80001d66:	ec06                	sd	ra,24(sp)
    80001d68:	e822                	sd	s0,16(sp)
    80001d6a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001d6c:	fec40593          	addi	a1,s0,-20
    80001d70:	4501                	li	a0,0
    80001d72:	f2fff0ef          	jal	80001ca0 <argint>
  kexit(n);
    80001d76:	fec42503          	lw	a0,-20(s0)
    80001d7a:	f26ff0ef          	jal	800014a0 <kexit>
  return 0;  // not reached
}
    80001d7e:	4501                	li	a0,0
    80001d80:	60e2                	ld	ra,24(sp)
    80001d82:	6442                	ld	s0,16(sp)
    80001d84:	6105                	addi	sp,sp,32
    80001d86:	8082                	ret

0000000080001d88 <sys_getpid>:

uint64
sys_getpid(void)
{
    80001d88:	1141                	addi	sp,sp,-16
    80001d8a:	e406                	sd	ra,8(sp)
    80001d8c:	e022                	sd	s0,0(sp)
    80001d8e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001d90:	804ff0ef          	jal	80000d94 <myproc>
}
    80001d94:	5908                	lw	a0,48(a0)
    80001d96:	60a2                	ld	ra,8(sp)
    80001d98:	6402                	ld	s0,0(sp)
    80001d9a:	0141                	addi	sp,sp,16
    80001d9c:	8082                	ret

0000000080001d9e <sys_fork>:

uint64
sys_fork(void)
{
    80001d9e:	1141                	addi	sp,sp,-16
    80001da0:	e406                	sd	ra,8(sp)
    80001da2:	e022                	sd	s0,0(sp)
    80001da4:	0800                	addi	s0,sp,16
  return kfork();
    80001da6:	b44ff0ef          	jal	800010ea <kfork>
}
    80001daa:	60a2                	ld	ra,8(sp)
    80001dac:	6402                	ld	s0,0(sp)
    80001dae:	0141                	addi	sp,sp,16
    80001db0:	8082                	ret

0000000080001db2 <sys_wait>:

uint64
sys_wait(void)
{
    80001db2:	1101                	addi	sp,sp,-32
    80001db4:	ec06                	sd	ra,24(sp)
    80001db6:	e822                	sd	s0,16(sp)
    80001db8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001dba:	fe840593          	addi	a1,s0,-24
    80001dbe:	4501                	li	a0,0
    80001dc0:	efdff0ef          	jal	80001cbc <argaddr>
  return kwait(p);
    80001dc4:	fe843503          	ld	a0,-24(s0)
    80001dc8:	833ff0ef          	jal	800015fa <kwait>
}
    80001dcc:	60e2                	ld	ra,24(sp)
    80001dce:	6442                	ld	s0,16(sp)
    80001dd0:	6105                	addi	sp,sp,32
    80001dd2:	8082                	ret

0000000080001dd4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001dd4:	7179                	addi	sp,sp,-48
    80001dd6:	f406                	sd	ra,40(sp)
    80001dd8:	f022                	sd	s0,32(sp)
    80001dda:	ec26                	sd	s1,24(sp)
    80001ddc:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001dde:	fd840593          	addi	a1,s0,-40
    80001de2:	4501                	li	a0,0
    80001de4:	ebdff0ef          	jal	80001ca0 <argint>
  argint(1, &t);
    80001de8:	fdc40593          	addi	a1,s0,-36
    80001dec:	4505                	li	a0,1
    80001dee:	eb3ff0ef          	jal	80001ca0 <argint>
  addr = myproc()->sz;
    80001df2:	fa3fe0ef          	jal	80000d94 <myproc>
    80001df6:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001df8:	fdc42703          	lw	a4,-36(s0)
    80001dfc:	4785                	li	a5,1
    80001dfe:	02f70163          	beq	a4,a5,80001e20 <sys_sbrk+0x4c>
    80001e02:	fd842783          	lw	a5,-40(s0)
    80001e06:	0007cd63          	bltz	a5,80001e20 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001e0a:	97a6                	add	a5,a5,s1
    80001e0c:	0297e863          	bltu	a5,s1,80001e3c <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001e10:	f85fe0ef          	jal	80000d94 <myproc>
    80001e14:	fd842703          	lw	a4,-40(s0)
    80001e18:	653c                	ld	a5,72(a0)
    80001e1a:	97ba                	add	a5,a5,a4
    80001e1c:	e53c                	sd	a5,72(a0)
    80001e1e:	a039                	j	80001e2c <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001e20:	fd842503          	lw	a0,-40(s0)
    80001e24:	a76ff0ef          	jal	8000109a <growproc>
    80001e28:	00054863          	bltz	a0,80001e38 <sys_sbrk+0x64>
  }
  return addr;
}
    80001e2c:	8526                	mv	a0,s1
    80001e2e:	70a2                	ld	ra,40(sp)
    80001e30:	7402                	ld	s0,32(sp)
    80001e32:	64e2                	ld	s1,24(sp)
    80001e34:	6145                	addi	sp,sp,48
    80001e36:	8082                	ret
      return -1;
    80001e38:	54fd                	li	s1,-1
    80001e3a:	bfcd                	j	80001e2c <sys_sbrk+0x58>
      return -1;
    80001e3c:	54fd                	li	s1,-1
    80001e3e:	b7fd                	j	80001e2c <sys_sbrk+0x58>

0000000080001e40 <sys_pause>:

uint64
sys_pause(void)
{
    80001e40:	7139                	addi	sp,sp,-64
    80001e42:	fc06                	sd	ra,56(sp)
    80001e44:	f822                	sd	s0,48(sp)
    80001e46:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001e48:	fcc40593          	addi	a1,s0,-52
    80001e4c:	4501                	li	a0,0
    80001e4e:	e53ff0ef          	jal	80001ca0 <argint>
  if(n < 0)
    80001e52:	fcc42783          	lw	a5,-52(s0)
    80001e56:	0607c863          	bltz	a5,80001ec6 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001e5a:	00007517          	auipc	a0,0x7
    80001e5e:	c9650513          	addi	a0,a0,-874 # 80008af0 <tickslock>
    80001e62:	5f7030ef          	jal	80005c58 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001e66:	fcc42783          	lw	a5,-52(s0)
    80001e6a:	c3b9                	beqz	a5,80001eb0 <sys_pause+0x70>
    80001e6c:	f426                	sd	s1,40(sp)
    80001e6e:	f04a                	sd	s2,32(sp)
    80001e70:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001e72:	00006997          	auipc	s3,0x6
    80001e76:	a069a983          	lw	s3,-1530(s3) # 80007878 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001e7a:	00007917          	auipc	s2,0x7
    80001e7e:	c7690913          	addi	s2,s2,-906 # 80008af0 <tickslock>
    80001e82:	00006497          	auipc	s1,0x6
    80001e86:	9f648493          	addi	s1,s1,-1546 # 80007878 <ticks>
    if(killed(myproc())){
    80001e8a:	f0bfe0ef          	jal	80000d94 <myproc>
    80001e8e:	f42ff0ef          	jal	800015d0 <killed>
    80001e92:	ed0d                	bnez	a0,80001ecc <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001e94:	85ca                	mv	a1,s2
    80001e96:	8526                	mv	a0,s1
    80001e98:	d02ff0ef          	jal	8000139a <sleep>
  while(ticks - ticks0 < n){
    80001e9c:	409c                	lw	a5,0(s1)
    80001e9e:	413787bb          	subw	a5,a5,s3
    80001ea2:	fcc42703          	lw	a4,-52(s0)
    80001ea6:	fee7e2e3          	bltu	a5,a4,80001e8a <sys_pause+0x4a>
    80001eaa:	74a2                	ld	s1,40(sp)
    80001eac:	7902                	ld	s2,32(sp)
    80001eae:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001eb0:	00007517          	auipc	a0,0x7
    80001eb4:	c4050513          	addi	a0,a0,-960 # 80008af0 <tickslock>
    80001eb8:	635030ef          	jal	80005cec <release>
  return 0;
    80001ebc:	4501                	li	a0,0
}
    80001ebe:	70e2                	ld	ra,56(sp)
    80001ec0:	7442                	ld	s0,48(sp)
    80001ec2:	6121                	addi	sp,sp,64
    80001ec4:	8082                	ret
    n = 0;
    80001ec6:	fc042623          	sw	zero,-52(s0)
    80001eca:	bf41                	j	80001e5a <sys_pause+0x1a>
      release(&tickslock);
    80001ecc:	00007517          	auipc	a0,0x7
    80001ed0:	c2450513          	addi	a0,a0,-988 # 80008af0 <tickslock>
    80001ed4:	619030ef          	jal	80005cec <release>
      return -1;
    80001ed8:	557d                	li	a0,-1
    80001eda:	74a2                	ld	s1,40(sp)
    80001edc:	7902                	ld	s2,32(sp)
    80001ede:	69e2                	ld	s3,24(sp)
    80001ee0:	bff9                	j	80001ebe <sys_pause+0x7e>

0000000080001ee2 <sys_kill>:

uint64
sys_kill(void)
{
    80001ee2:	1101                	addi	sp,sp,-32
    80001ee4:	ec06                	sd	ra,24(sp)
    80001ee6:	e822                	sd	s0,16(sp)
    80001ee8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001eea:	fec40593          	addi	a1,s0,-20
    80001eee:	4501                	li	a0,0
    80001ef0:	db1ff0ef          	jal	80001ca0 <argint>
  return kkill(pid);
    80001ef4:	fec42503          	lw	a0,-20(s0)
    80001ef8:	e4eff0ef          	jal	80001546 <kkill>
}
    80001efc:	60e2                	ld	ra,24(sp)
    80001efe:	6442                	ld	s0,16(sp)
    80001f00:	6105                	addi	sp,sp,32
    80001f02:	8082                	ret

0000000080001f04 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f04:	1101                	addi	sp,sp,-32
    80001f06:	ec06                	sd	ra,24(sp)
    80001f08:	e822                	sd	s0,16(sp)
    80001f0a:	e426                	sd	s1,8(sp)
    80001f0c:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001f0e:	00007517          	auipc	a0,0x7
    80001f12:	be250513          	addi	a0,a0,-1054 # 80008af0 <tickslock>
    80001f16:	543030ef          	jal	80005c58 <acquire>
  xticks = ticks;
    80001f1a:	00006797          	auipc	a5,0x6
    80001f1e:	95e7a783          	lw	a5,-1698(a5) # 80007878 <ticks>
    80001f22:	84be                	mv	s1,a5
  release(&tickslock);
    80001f24:	00007517          	auipc	a0,0x7
    80001f28:	bcc50513          	addi	a0,a0,-1076 # 80008af0 <tickslock>
    80001f2c:	5c1030ef          	jal	80005cec <release>
  return xticks;
}
    80001f30:	02049513          	slli	a0,s1,0x20
    80001f34:	9101                	srli	a0,a0,0x20
    80001f36:	60e2                	ld	ra,24(sp)
    80001f38:	6442                	ld	s0,16(sp)
    80001f3a:	64a2                	ld	s1,8(sp)
    80001f3c:	6105                	addi	sp,sp,32
    80001f3e:	8082                	ret

0000000080001f40 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80001f40:	7179                	addi	sp,sp,-48
    80001f42:	f406                	sd	ra,40(sp)
    80001f44:	f022                	sd	s0,32(sp)
    80001f46:	ec26                	sd	s1,24(sp)
    80001f48:	e84a                	sd	s2,16(sp)
    80001f4a:	e44e                	sd	s3,8(sp)
    80001f4c:	e052                	sd	s4,0(sp)
    80001f4e:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80001f50:	00005597          	auipc	a1,0x5
    80001f54:	3e058593          	addi	a1,a1,992 # 80007330 <etext+0x330>
    80001f58:	00007517          	auipc	a0,0x7
    80001f5c:	bb050513          	addi	a0,a0,-1104 # 80008b08 <bcache>
    80001f60:	46f030ef          	jal	80005bce <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80001f64:	0000f797          	auipc	a5,0xf
    80001f68:	ba478793          	addi	a5,a5,-1116 # 80010b08 <bcache+0x8000>
    80001f6c:	0000f717          	auipc	a4,0xf
    80001f70:	e0470713          	addi	a4,a4,-508 # 80010d70 <bcache+0x8268>
    80001f74:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80001f78:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001f7c:	00007497          	auipc	s1,0x7
    80001f80:	ba448493          	addi	s1,s1,-1116 # 80008b20 <bcache+0x18>
    b->next = bcache.head.next;
    80001f84:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80001f86:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80001f88:	00005a17          	auipc	s4,0x5
    80001f8c:	3b0a0a13          	addi	s4,s4,944 # 80007338 <etext+0x338>
    b->next = bcache.head.next;
    80001f90:	2b893783          	ld	a5,696(s2)
    80001f94:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80001f96:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80001f9a:	85d2                	mv	a1,s4
    80001f9c:	01048513          	addi	a0,s1,16
    80001fa0:	468010ef          	jal	80003408 <initsleeplock>
    bcache.head.next->prev = b;
    80001fa4:	2b893783          	ld	a5,696(s2)
    80001fa8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80001faa:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80001fae:	45848493          	addi	s1,s1,1112
    80001fb2:	fd349fe3          	bne	s1,s3,80001f90 <binit+0x50>
  }
}
    80001fb6:	70a2                	ld	ra,40(sp)
    80001fb8:	7402                	ld	s0,32(sp)
    80001fba:	64e2                	ld	s1,24(sp)
    80001fbc:	6942                	ld	s2,16(sp)
    80001fbe:	69a2                	ld	s3,8(sp)
    80001fc0:	6a02                	ld	s4,0(sp)
    80001fc2:	6145                	addi	sp,sp,48
    80001fc4:	8082                	ret

0000000080001fc6 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80001fc6:	7179                	addi	sp,sp,-48
    80001fc8:	f406                	sd	ra,40(sp)
    80001fca:	f022                	sd	s0,32(sp)
    80001fcc:	ec26                	sd	s1,24(sp)
    80001fce:	e84a                	sd	s2,16(sp)
    80001fd0:	e44e                	sd	s3,8(sp)
    80001fd2:	1800                	addi	s0,sp,48
    80001fd4:	892a                	mv	s2,a0
    80001fd6:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80001fd8:	00007517          	auipc	a0,0x7
    80001fdc:	b3050513          	addi	a0,a0,-1232 # 80008b08 <bcache>
    80001fe0:	479030ef          	jal	80005c58 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80001fe4:	0000f497          	auipc	s1,0xf
    80001fe8:	ddc4b483          	ld	s1,-548(s1) # 80010dc0 <bcache+0x82b8>
    80001fec:	0000f797          	auipc	a5,0xf
    80001ff0:	d8478793          	addi	a5,a5,-636 # 80010d70 <bcache+0x8268>
    80001ff4:	02f48b63          	beq	s1,a5,8000202a <bread+0x64>
    80001ff8:	873e                	mv	a4,a5
    80001ffa:	a021                	j	80002002 <bread+0x3c>
    80001ffc:	68a4                	ld	s1,80(s1)
    80001ffe:	02e48663          	beq	s1,a4,8000202a <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002002:	449c                	lw	a5,8(s1)
    80002004:	ff279ce3          	bne	a5,s2,80001ffc <bread+0x36>
    80002008:	44dc                	lw	a5,12(s1)
    8000200a:	ff3799e3          	bne	a5,s3,80001ffc <bread+0x36>
      b->refcnt++;
    8000200e:	40bc                	lw	a5,64(s1)
    80002010:	2785                	addiw	a5,a5,1
    80002012:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002014:	00007517          	auipc	a0,0x7
    80002018:	af450513          	addi	a0,a0,-1292 # 80008b08 <bcache>
    8000201c:	4d1030ef          	jal	80005cec <release>
      acquiresleep(&b->lock);
    80002020:	01048513          	addi	a0,s1,16
    80002024:	41a010ef          	jal	8000343e <acquiresleep>
      return b;
    80002028:	a889                	j	8000207a <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000202a:	0000f497          	auipc	s1,0xf
    8000202e:	d8e4b483          	ld	s1,-626(s1) # 80010db8 <bcache+0x82b0>
    80002032:	0000f797          	auipc	a5,0xf
    80002036:	d3e78793          	addi	a5,a5,-706 # 80010d70 <bcache+0x8268>
    8000203a:	00f48863          	beq	s1,a5,8000204a <bread+0x84>
    8000203e:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002040:	40bc                	lw	a5,64(s1)
    80002042:	cb91                	beqz	a5,80002056 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002044:	64a4                	ld	s1,72(s1)
    80002046:	fee49de3          	bne	s1,a4,80002040 <bread+0x7a>
  panic("bget: no buffers");
    8000204a:	00005517          	auipc	a0,0x5
    8000204e:	2f650513          	addi	a0,a0,758 # 80007340 <etext+0x340>
    80002052:	145030ef          	jal	80005996 <panic>
      b->dev = dev;
    80002056:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    8000205a:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    8000205e:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002062:	4785                	li	a5,1
    80002064:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002066:	00007517          	auipc	a0,0x7
    8000206a:	aa250513          	addi	a0,a0,-1374 # 80008b08 <bcache>
    8000206e:	47f030ef          	jal	80005cec <release>
      acquiresleep(&b->lock);
    80002072:	01048513          	addi	a0,s1,16
    80002076:	3c8010ef          	jal	8000343e <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    8000207a:	409c                	lw	a5,0(s1)
    8000207c:	cb89                	beqz	a5,8000208e <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000207e:	8526                	mv	a0,s1
    80002080:	70a2                	ld	ra,40(sp)
    80002082:	7402                	ld	s0,32(sp)
    80002084:	64e2                	ld	s1,24(sp)
    80002086:	6942                	ld	s2,16(sp)
    80002088:	69a2                	ld	s3,8(sp)
    8000208a:	6145                	addi	sp,sp,48
    8000208c:	8082                	ret
    virtio_disk_rw(b, 0);
    8000208e:	4581                	li	a1,0
    80002090:	8526                	mv	a0,s1
    80002092:	63f020ef          	jal	80004ed0 <virtio_disk_rw>
    b->valid = 1;
    80002096:	4785                	li	a5,1
    80002098:	c09c                	sw	a5,0(s1)
  return b;
    8000209a:	b7d5                	j	8000207e <bread+0xb8>

000000008000209c <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000209c:	1101                	addi	sp,sp,-32
    8000209e:	ec06                	sd	ra,24(sp)
    800020a0:	e822                	sd	s0,16(sp)
    800020a2:	e426                	sd	s1,8(sp)
    800020a4:	1000                	addi	s0,sp,32
    800020a6:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020a8:	0541                	addi	a0,a0,16
    800020aa:	412010ef          	jal	800034bc <holdingsleep>
    800020ae:	c911                	beqz	a0,800020c2 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800020b0:	4585                	li	a1,1
    800020b2:	8526                	mv	a0,s1
    800020b4:	61d020ef          	jal	80004ed0 <virtio_disk_rw>
}
    800020b8:	60e2                	ld	ra,24(sp)
    800020ba:	6442                	ld	s0,16(sp)
    800020bc:	64a2                	ld	s1,8(sp)
    800020be:	6105                	addi	sp,sp,32
    800020c0:	8082                	ret
    panic("bwrite");
    800020c2:	00005517          	auipc	a0,0x5
    800020c6:	29650513          	addi	a0,a0,662 # 80007358 <etext+0x358>
    800020ca:	0cd030ef          	jal	80005996 <panic>

00000000800020ce <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800020ce:	1101                	addi	sp,sp,-32
    800020d0:	ec06                	sd	ra,24(sp)
    800020d2:	e822                	sd	s0,16(sp)
    800020d4:	e426                	sd	s1,8(sp)
    800020d6:	e04a                	sd	s2,0(sp)
    800020d8:	1000                	addi	s0,sp,32
    800020da:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800020dc:	01050913          	addi	s2,a0,16
    800020e0:	854a                	mv	a0,s2
    800020e2:	3da010ef          	jal	800034bc <holdingsleep>
    800020e6:	c125                	beqz	a0,80002146 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800020e8:	854a                	mv	a0,s2
    800020ea:	39a010ef          	jal	80003484 <releasesleep>

  acquire(&bcache.lock);
    800020ee:	00007517          	auipc	a0,0x7
    800020f2:	a1a50513          	addi	a0,a0,-1510 # 80008b08 <bcache>
    800020f6:	363030ef          	jal	80005c58 <acquire>
  b->refcnt--;
    800020fa:	40bc                	lw	a5,64(s1)
    800020fc:	37fd                	addiw	a5,a5,-1
    800020fe:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002100:	e79d                	bnez	a5,8000212e <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002102:	68b8                	ld	a4,80(s1)
    80002104:	64bc                	ld	a5,72(s1)
    80002106:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002108:	68b8                	ld	a4,80(s1)
    8000210a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000210c:	0000f797          	auipc	a5,0xf
    80002110:	9fc78793          	addi	a5,a5,-1540 # 80010b08 <bcache+0x8000>
    80002114:	2b87b703          	ld	a4,696(a5)
    80002118:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000211a:	0000f717          	auipc	a4,0xf
    8000211e:	c5670713          	addi	a4,a4,-938 # 80010d70 <bcache+0x8268>
    80002122:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002124:	2b87b703          	ld	a4,696(a5)
    80002128:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000212a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000212e:	00007517          	auipc	a0,0x7
    80002132:	9da50513          	addi	a0,a0,-1574 # 80008b08 <bcache>
    80002136:	3b7030ef          	jal	80005cec <release>
}
    8000213a:	60e2                	ld	ra,24(sp)
    8000213c:	6442                	ld	s0,16(sp)
    8000213e:	64a2                	ld	s1,8(sp)
    80002140:	6902                	ld	s2,0(sp)
    80002142:	6105                	addi	sp,sp,32
    80002144:	8082                	ret
    panic("brelse");
    80002146:	00005517          	auipc	a0,0x5
    8000214a:	21a50513          	addi	a0,a0,538 # 80007360 <etext+0x360>
    8000214e:	049030ef          	jal	80005996 <panic>

0000000080002152 <bpin>:

void
bpin(struct buf *b) {
    80002152:	1101                	addi	sp,sp,-32
    80002154:	ec06                	sd	ra,24(sp)
    80002156:	e822                	sd	s0,16(sp)
    80002158:	e426                	sd	s1,8(sp)
    8000215a:	1000                	addi	s0,sp,32
    8000215c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000215e:	00007517          	auipc	a0,0x7
    80002162:	9aa50513          	addi	a0,a0,-1622 # 80008b08 <bcache>
    80002166:	2f3030ef          	jal	80005c58 <acquire>
  b->refcnt++;
    8000216a:	40bc                	lw	a5,64(s1)
    8000216c:	2785                	addiw	a5,a5,1
    8000216e:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002170:	00007517          	auipc	a0,0x7
    80002174:	99850513          	addi	a0,a0,-1640 # 80008b08 <bcache>
    80002178:	375030ef          	jal	80005cec <release>
}
    8000217c:	60e2                	ld	ra,24(sp)
    8000217e:	6442                	ld	s0,16(sp)
    80002180:	64a2                	ld	s1,8(sp)
    80002182:	6105                	addi	sp,sp,32
    80002184:	8082                	ret

0000000080002186 <bunpin>:

void
bunpin(struct buf *b) {
    80002186:	1101                	addi	sp,sp,-32
    80002188:	ec06                	sd	ra,24(sp)
    8000218a:	e822                	sd	s0,16(sp)
    8000218c:	e426                	sd	s1,8(sp)
    8000218e:	1000                	addi	s0,sp,32
    80002190:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002192:	00007517          	auipc	a0,0x7
    80002196:	97650513          	addi	a0,a0,-1674 # 80008b08 <bcache>
    8000219a:	2bf030ef          	jal	80005c58 <acquire>
  b->refcnt--;
    8000219e:	40bc                	lw	a5,64(s1)
    800021a0:	37fd                	addiw	a5,a5,-1
    800021a2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800021a4:	00007517          	auipc	a0,0x7
    800021a8:	96450513          	addi	a0,a0,-1692 # 80008b08 <bcache>
    800021ac:	341030ef          	jal	80005cec <release>
}
    800021b0:	60e2                	ld	ra,24(sp)
    800021b2:	6442                	ld	s0,16(sp)
    800021b4:	64a2                	ld	s1,8(sp)
    800021b6:	6105                	addi	sp,sp,32
    800021b8:	8082                	ret

00000000800021ba <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800021ba:	1101                	addi	sp,sp,-32
    800021bc:	ec06                	sd	ra,24(sp)
    800021be:	e822                	sd	s0,16(sp)
    800021c0:	e426                	sd	s1,8(sp)
    800021c2:	e04a                	sd	s2,0(sp)
    800021c4:	1000                	addi	s0,sp,32
    800021c6:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800021c8:	00d5d79b          	srliw	a5,a1,0xd
    800021cc:	0000f597          	auipc	a1,0xf
    800021d0:	0185a583          	lw	a1,24(a1) # 800111e4 <sb+0x1c>
    800021d4:	9dbd                	addw	a1,a1,a5
    800021d6:	df1ff0ef          	jal	80001fc6 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800021da:	0074f713          	andi	a4,s1,7
    800021de:	4785                	li	a5,1
    800021e0:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800021e4:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800021e6:	90d9                	srli	s1,s1,0x36
    800021e8:	00950733          	add	a4,a0,s1
    800021ec:	05874703          	lbu	a4,88(a4)
    800021f0:	00e7f6b3          	and	a3,a5,a4
    800021f4:	c29d                	beqz	a3,8000221a <bfree+0x60>
    800021f6:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800021f8:	94aa                	add	s1,s1,a0
    800021fa:	fff7c793          	not	a5,a5
    800021fe:	8f7d                	and	a4,a4,a5
    80002200:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002204:	140010ef          	jal	80003344 <log_write>
  brelse(bp);
    80002208:	854a                	mv	a0,s2
    8000220a:	ec5ff0ef          	jal	800020ce <brelse>
}
    8000220e:	60e2                	ld	ra,24(sp)
    80002210:	6442                	ld	s0,16(sp)
    80002212:	64a2                	ld	s1,8(sp)
    80002214:	6902                	ld	s2,0(sp)
    80002216:	6105                	addi	sp,sp,32
    80002218:	8082                	ret
    panic("freeing free block");
    8000221a:	00005517          	auipc	a0,0x5
    8000221e:	14e50513          	addi	a0,a0,334 # 80007368 <etext+0x368>
    80002222:	774030ef          	jal	80005996 <panic>

0000000080002226 <balloc>:
{
    80002226:	715d                	addi	sp,sp,-80
    80002228:	e486                	sd	ra,72(sp)
    8000222a:	e0a2                	sd	s0,64(sp)
    8000222c:	fc26                	sd	s1,56(sp)
    8000222e:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002230:	0000f797          	auipc	a5,0xf
    80002234:	f9c7a783          	lw	a5,-100(a5) # 800111cc <sb+0x4>
    80002238:	0e078263          	beqz	a5,8000231c <balloc+0xf6>
    8000223c:	f84a                	sd	s2,48(sp)
    8000223e:	f44e                	sd	s3,40(sp)
    80002240:	f052                	sd	s4,32(sp)
    80002242:	ec56                	sd	s5,24(sp)
    80002244:	e85a                	sd	s6,16(sp)
    80002246:	e45e                	sd	s7,8(sp)
    80002248:	e062                	sd	s8,0(sp)
    8000224a:	8baa                	mv	s7,a0
    8000224c:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    8000224e:	0000fb17          	auipc	s6,0xf
    80002252:	f7ab0b13          	addi	s6,s6,-134 # 800111c8 <sb>
      m = 1 << (bi % 8);
    80002256:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002258:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    8000225a:	6c09                	lui	s8,0x2
    8000225c:	a09d                	j	800022c2 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    8000225e:	97ca                	add	a5,a5,s2
    80002260:	8e55                	or	a2,a2,a3
    80002262:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002266:	854a                	mv	a0,s2
    80002268:	0dc010ef          	jal	80003344 <log_write>
        brelse(bp);
    8000226c:	854a                	mv	a0,s2
    8000226e:	e61ff0ef          	jal	800020ce <brelse>
  bp = bread(dev, bno);
    80002272:	85a6                	mv	a1,s1
    80002274:	855e                	mv	a0,s7
    80002276:	d51ff0ef          	jal	80001fc6 <bread>
    8000227a:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000227c:	40000613          	li	a2,1024
    80002280:	4581                	li	a1,0
    80002282:	05850513          	addi	a0,a0,88
    80002286:	ed9fd0ef          	jal	8000015e <memset>
  log_write(bp);
    8000228a:	854a                	mv	a0,s2
    8000228c:	0b8010ef          	jal	80003344 <log_write>
  brelse(bp);
    80002290:	854a                	mv	a0,s2
    80002292:	e3dff0ef          	jal	800020ce <brelse>
}
    80002296:	7942                	ld	s2,48(sp)
    80002298:	79a2                	ld	s3,40(sp)
    8000229a:	7a02                	ld	s4,32(sp)
    8000229c:	6ae2                	ld	s5,24(sp)
    8000229e:	6b42                	ld	s6,16(sp)
    800022a0:	6ba2                	ld	s7,8(sp)
    800022a2:	6c02                	ld	s8,0(sp)
}
    800022a4:	8526                	mv	a0,s1
    800022a6:	60a6                	ld	ra,72(sp)
    800022a8:	6406                	ld	s0,64(sp)
    800022aa:	74e2                	ld	s1,56(sp)
    800022ac:	6161                	addi	sp,sp,80
    800022ae:	8082                	ret
    brelse(bp);
    800022b0:	854a                	mv	a0,s2
    800022b2:	e1dff0ef          	jal	800020ce <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800022b6:	015c0abb          	addw	s5,s8,s5
    800022ba:	004b2783          	lw	a5,4(s6)
    800022be:	04faf863          	bgeu	s5,a5,8000230e <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800022c2:	40dad59b          	sraiw	a1,s5,0xd
    800022c6:	01cb2783          	lw	a5,28(s6)
    800022ca:	9dbd                	addw	a1,a1,a5
    800022cc:	855e                	mv	a0,s7
    800022ce:	cf9ff0ef          	jal	80001fc6 <bread>
    800022d2:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800022d4:	004b2503          	lw	a0,4(s6)
    800022d8:	84d6                	mv	s1,s5
    800022da:	4701                	li	a4,0
    800022dc:	fca4fae3          	bgeu	s1,a0,800022b0 <balloc+0x8a>
      m = 1 << (bi % 8);
    800022e0:	00777693          	andi	a3,a4,7
    800022e4:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800022e8:	41f7579b          	sraiw	a5,a4,0x1f
    800022ec:	01d7d79b          	srliw	a5,a5,0x1d
    800022f0:	9fb9                	addw	a5,a5,a4
    800022f2:	4037d79b          	sraiw	a5,a5,0x3
    800022f6:	00f90633          	add	a2,s2,a5
    800022fa:	05864603          	lbu	a2,88(a2)
    800022fe:	00c6f5b3          	and	a1,a3,a2
    80002302:	ddb1                	beqz	a1,8000225e <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002304:	2705                	addiw	a4,a4,1
    80002306:	2485                	addiw	s1,s1,1
    80002308:	fd471ae3          	bne	a4,s4,800022dc <balloc+0xb6>
    8000230c:	b755                	j	800022b0 <balloc+0x8a>
    8000230e:	7942                	ld	s2,48(sp)
    80002310:	79a2                	ld	s3,40(sp)
    80002312:	7a02                	ld	s4,32(sp)
    80002314:	6ae2                	ld	s5,24(sp)
    80002316:	6b42                	ld	s6,16(sp)
    80002318:	6ba2                	ld	s7,8(sp)
    8000231a:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    8000231c:	00005517          	auipc	a0,0x5
    80002320:	06450513          	addi	a0,a0,100 # 80007380 <etext+0x380>
    80002324:	348030ef          	jal	8000566c <printf>
  return 0;
    80002328:	4481                	li	s1,0
    8000232a:	bfad                	j	800022a4 <balloc+0x7e>

000000008000232c <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000232c:	7139                	addi	sp,sp,-64
    8000232e:	fc06                	sd	ra,56(sp)
    80002330:	f822                	sd	s0,48(sp)
    80002332:	f426                	sd	s1,40(sp)
    80002334:	f04a                	sd	s2,32(sp)
    80002336:	ec4e                	sd	s3,24(sp)
    80002338:	0080                	addi	s0,sp,64
    8000233a:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    8000233c:	47a9                	li	a5,10
    8000233e:	02b7eb63          	bltu	a5,a1,80002374 <bmap+0x48>
    if((addr = ip->addrs[bn]) == 0){
    80002342:	02059793          	slli	a5,a1,0x20
    80002346:	01e7d593          	srli	a1,a5,0x1e
    8000234a:	00b509b3          	add	s3,a0,a1
    8000234e:	0509a483          	lw	s1,80(s3)
    80002352:	c889                	beqz	s1,80002364 <bmap+0x38>
    return addr;
  }


  panic("bmap: out of range");
}
    80002354:	8526                	mv	a0,s1
    80002356:	70e2                	ld	ra,56(sp)
    80002358:	7442                	ld	s0,48(sp)
    8000235a:	74a2                	ld	s1,40(sp)
    8000235c:	7902                	ld	s2,32(sp)
    8000235e:	69e2                	ld	s3,24(sp)
    80002360:	6121                	addi	sp,sp,64
    80002362:	8082                	ret
      addr = balloc(ip->dev);
    80002364:	4108                	lw	a0,0(a0)
    80002366:	ec1ff0ef          	jal	80002226 <balloc>
    8000236a:	84aa                	mv	s1,a0
      if(addr == 0)
    8000236c:	d565                	beqz	a0,80002354 <bmap+0x28>
      ip->addrs[bn] = addr;
    8000236e:	04a9a823          	sw	a0,80(s3)
    80002372:	b7cd                	j	80002354 <bmap+0x28>
  bn -= NDIRECT;
    80002374:	ff55879b          	addiw	a5,a1,-11
    80002378:	873e                	mv	a4,a5
    8000237a:	89be                	mv	s3,a5
  if(bn < NINDIRECT){
    8000237c:	0ff00793          	li	a5,255
    80002380:	04e7ef63          	bltu	a5,a4,800023de <bmap+0xb2>
    if((addr = ip->addrs[NDIRECT]) == 0){
    80002384:	5d64                	lw	s1,124(a0)
    80002386:	e891                	bnez	s1,8000239a <bmap+0x6e>
      addr = balloc(ip->dev);
    80002388:	4108                	lw	a0,0(a0)
    8000238a:	e9dff0ef          	jal	80002226 <balloc>
    8000238e:	84aa                	mv	s1,a0
      if(addr == 0)
    80002390:	d171                	beqz	a0,80002354 <bmap+0x28>
    80002392:	e852                	sd	s4,16(sp)
      ip->addrs[NDIRECT] = addr;
    80002394:	06a92e23          	sw	a0,124(s2)
    80002398:	a011                	j	8000239c <bmap+0x70>
    8000239a:	e852                	sd	s4,16(sp)
    bp = bread(ip->dev, addr);
    8000239c:	85a6                	mv	a1,s1
    8000239e:	00092503          	lw	a0,0(s2)
    800023a2:	c25ff0ef          	jal	80001fc6 <bread>
    800023a6:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800023a8:	05850713          	addi	a4,a0,88
    if((addr = a[bn]) == 0){
    800023ac:	02099693          	slli	a3,s3,0x20
    800023b0:	01e6d793          	srli	a5,a3,0x1e
    800023b4:	97ba                	add	a5,a5,a4
    800023b6:	89be                	mv	s3,a5
    800023b8:	4384                	lw	s1,0(a5)
    800023ba:	c491                	beqz	s1,800023c6 <bmap+0x9a>
    brelse(bp);
    800023bc:	8552                	mv	a0,s4
    800023be:	d11ff0ef          	jal	800020ce <brelse>
    return addr;
    800023c2:	6a42                	ld	s4,16(sp)
    800023c4:	bf41                	j	80002354 <bmap+0x28>
      addr = balloc(ip->dev);
    800023c6:	00092503          	lw	a0,0(s2)
    800023ca:	e5dff0ef          	jal	80002226 <balloc>
    800023ce:	84aa                	mv	s1,a0
      if(addr){
    800023d0:	d575                	beqz	a0,800023bc <bmap+0x90>
        a[bn] = addr;
    800023d2:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800023d6:	8552                	mv	a0,s4
    800023d8:	76d000ef          	jal	80003344 <log_write>
    800023dc:	b7c5                	j	800023bc <bmap+0x90>
  bn -= NINDIRECT;
    800023de:	ef55879b          	addiw	a5,a1,-267
    800023e2:	873e                	mv	a4,a5
    800023e4:	89be                	mv	s3,a5
  if(bn < NDBINDIRECT){
    800023e6:	67c1                	lui	a5,0x10
    800023e8:	0af77263          	bgeu	a4,a5,8000248c <bmap+0x160>
    if((addr = ip->addrs[NDIRECT+1]) == 0){
    800023ec:	08052483          	lw	s1,128(a0)
    800023f0:	e899                	bnez	s1,80002406 <bmap+0xda>
      addr = balloc(ip->dev);
    800023f2:	4108                	lw	a0,0(a0)
    800023f4:	e33ff0ef          	jal	80002226 <balloc>
    800023f8:	84aa                	mv	s1,a0
      if(addr == 0)
    800023fa:	dd29                	beqz	a0,80002354 <bmap+0x28>
    800023fc:	e852                	sd	s4,16(sp)
    800023fe:	e456                	sd	s5,8(sp)
      ip->addrs[NDIRECT+1] = addr;
    80002400:	08a92023          	sw	a0,128(s2)
    80002404:	a019                	j	8000240a <bmap+0xde>
    80002406:	e852                	sd	s4,16(sp)
    80002408:	e456                	sd	s5,8(sp)
    l2idx = bn & DBINDL1IDXMASK;
    8000240a:	0ff9f793          	zext.b	a5,s3
    8000240e:	8abe                	mv	s5,a5
    bp = bread(ip->dev, addr);
    80002410:	85a6                	mv	a1,s1
    80002412:	00092503          	lw	a0,0(s2)
    80002416:	bb1ff0ef          	jal	80001fc6 <bread>
    8000241a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000241c:	05850793          	addi	a5,a0,88
    if((addr = a[l1idx]) == 0){
    80002420:	0089d59b          	srliw	a1,s3,0x8
    80002424:	058a                	slli	a1,a1,0x2
    80002426:	97ae                	add	a5,a5,a1
    80002428:	89be                	mv	s3,a5
    8000242a:	4384                	lw	s1,0(a5)
    8000242c:	c885                	beqz	s1,8000245c <bmap+0x130>
    brelse(bp);
    8000242e:	8552                	mv	a0,s4
    80002430:	c9fff0ef          	jal	800020ce <brelse>
    bp = bread(ip->dev, addr);
    80002434:	85a6                	mv	a1,s1
    80002436:	00092503          	lw	a0,0(s2)
    8000243a:	b8dff0ef          	jal	80001fc6 <bread>
    8000243e:	89aa                	mv	s3,a0
    a = (uint*)bp->data;
    80002440:	05850793          	addi	a5,a0,88
    if((addr = a[l2idx]) == 0){
    80002444:	002a9713          	slli	a4,s5,0x2
    80002448:	97ba                	add	a5,a5,a4
    8000244a:	8a3e                	mv	s4,a5
    8000244c:	4384                	lw	s1,0(a5)
    8000244e:	c09d                	beqz	s1,80002474 <bmap+0x148>
    brelse(bp);
    80002450:	854e                	mv	a0,s3
    80002452:	c7dff0ef          	jal	800020ce <brelse>
    return addr;
    80002456:	6a42                	ld	s4,16(sp)
    80002458:	6aa2                	ld	s5,8(sp)
    8000245a:	bded                	j	80002354 <bmap+0x28>
      addr = balloc(ip->dev);
    8000245c:	00092503          	lw	a0,0(s2)
    80002460:	dc7ff0ef          	jal	80002226 <balloc>
    80002464:	84aa                	mv	s1,a0
      if(addr){
    80002466:	d561                	beqz	a0,8000242e <bmap+0x102>
        a[l1idx] = addr;
    80002468:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    8000246c:	8552                	mv	a0,s4
    8000246e:	6d7000ef          	jal	80003344 <log_write>
    80002472:	bf75                	j	8000242e <bmap+0x102>
      addr = balloc(ip->dev);
    80002474:	00092503          	lw	a0,0(s2)
    80002478:	dafff0ef          	jal	80002226 <balloc>
    8000247c:	84aa                	mv	s1,a0
      if(addr){
    8000247e:	d969                	beqz	a0,80002450 <bmap+0x124>
        a[l2idx] = addr;
    80002480:	00aa2023          	sw	a0,0(s4) # 2000 <_entry-0x7fffe000>
        log_write(bp);
    80002484:	854e                	mv	a0,s3
    80002486:	6bf000ef          	jal	80003344 <log_write>
    8000248a:	b7d9                	j	80002450 <bmap+0x124>
    8000248c:	e852                	sd	s4,16(sp)
    8000248e:	e456                	sd	s5,8(sp)
  panic("bmap: out of range");
    80002490:	00005517          	auipc	a0,0x5
    80002494:	f0850513          	addi	a0,a0,-248 # 80007398 <etext+0x398>
    80002498:	4fe030ef          	jal	80005996 <panic>

000000008000249c <iget>:
{
    8000249c:	7179                	addi	sp,sp,-48
    8000249e:	f406                	sd	ra,40(sp)
    800024a0:	f022                	sd	s0,32(sp)
    800024a2:	ec26                	sd	s1,24(sp)
    800024a4:	e84a                	sd	s2,16(sp)
    800024a6:	e44e                	sd	s3,8(sp)
    800024a8:	e052                	sd	s4,0(sp)
    800024aa:	1800                	addi	s0,sp,48
    800024ac:	892a                	mv	s2,a0
    800024ae:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800024b0:	0000f517          	auipc	a0,0xf
    800024b4:	d3850513          	addi	a0,a0,-712 # 800111e8 <itable>
    800024b8:	7a0030ef          	jal	80005c58 <acquire>
  empty = 0;
    800024bc:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024be:	0000f497          	auipc	s1,0xf
    800024c2:	d4248493          	addi	s1,s1,-702 # 80011200 <itable+0x18>
    800024c6:	00010697          	auipc	a3,0x10
    800024ca:	7ca68693          	addi	a3,a3,1994 # 80012c90 <log>
    800024ce:	a809                	j	800024e0 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800024d0:	e781                	bnez	a5,800024d8 <iget+0x3c>
    800024d2:	00099363          	bnez	s3,800024d8 <iget+0x3c>
      empty = ip;
    800024d6:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800024d8:	08848493          	addi	s1,s1,136
    800024dc:	02d48563          	beq	s1,a3,80002506 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800024e0:	449c                	lw	a5,8(s1)
    800024e2:	fef057e3          	blez	a5,800024d0 <iget+0x34>
    800024e6:	4098                	lw	a4,0(s1)
    800024e8:	ff2718e3          	bne	a4,s2,800024d8 <iget+0x3c>
    800024ec:	40d8                	lw	a4,4(s1)
    800024ee:	ff4715e3          	bne	a4,s4,800024d8 <iget+0x3c>
      ip->ref++;
    800024f2:	2785                	addiw	a5,a5,1 # 10001 <_entry-0x7ffeffff>
    800024f4:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800024f6:	0000f517          	auipc	a0,0xf
    800024fa:	cf250513          	addi	a0,a0,-782 # 800111e8 <itable>
    800024fe:	7ee030ef          	jal	80005cec <release>
      return ip;
    80002502:	89a6                	mv	s3,s1
    80002504:	a015                	j	80002528 <iget+0x8c>
  if(empty == 0)
    80002506:	02098a63          	beqz	s3,8000253a <iget+0x9e>
  ip->dev = dev;
    8000250a:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    8000250e:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80002512:	4785                	li	a5,1
    80002514:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002518:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    8000251c:	0000f517          	auipc	a0,0xf
    80002520:	ccc50513          	addi	a0,a0,-820 # 800111e8 <itable>
    80002524:	7c8030ef          	jal	80005cec <release>
}
    80002528:	854e                	mv	a0,s3
    8000252a:	70a2                	ld	ra,40(sp)
    8000252c:	7402                	ld	s0,32(sp)
    8000252e:	64e2                	ld	s1,24(sp)
    80002530:	6942                	ld	s2,16(sp)
    80002532:	69a2                	ld	s3,8(sp)
    80002534:	6a02                	ld	s4,0(sp)
    80002536:	6145                	addi	sp,sp,48
    80002538:	8082                	ret
    panic("iget: no inodes");
    8000253a:	00005517          	auipc	a0,0x5
    8000253e:	e7650513          	addi	a0,a0,-394 # 800073b0 <etext+0x3b0>
    80002542:	454030ef          	jal	80005996 <panic>

0000000080002546 <iinit>:
{
    80002546:	7179                	addi	sp,sp,-48
    80002548:	f406                	sd	ra,40(sp)
    8000254a:	f022                	sd	s0,32(sp)
    8000254c:	ec26                	sd	s1,24(sp)
    8000254e:	e84a                	sd	s2,16(sp)
    80002550:	e44e                	sd	s3,8(sp)
    80002552:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002554:	00005597          	auipc	a1,0x5
    80002558:	e6c58593          	addi	a1,a1,-404 # 800073c0 <etext+0x3c0>
    8000255c:	0000f517          	auipc	a0,0xf
    80002560:	c8c50513          	addi	a0,a0,-884 # 800111e8 <itable>
    80002564:	66a030ef          	jal	80005bce <initlock>
  for(i = 0; i < NINODE; i++) {
    80002568:	0000f497          	auipc	s1,0xf
    8000256c:	ca848493          	addi	s1,s1,-856 # 80011210 <itable+0x28>
    80002570:	00010997          	auipc	s3,0x10
    80002574:	73098993          	addi	s3,s3,1840 # 80012ca0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002578:	00005917          	auipc	s2,0x5
    8000257c:	e5090913          	addi	s2,s2,-432 # 800073c8 <etext+0x3c8>
    80002580:	85ca                	mv	a1,s2
    80002582:	8526                	mv	a0,s1
    80002584:	685000ef          	jal	80003408 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002588:	08848493          	addi	s1,s1,136
    8000258c:	ff349ae3          	bne	s1,s3,80002580 <iinit+0x3a>
}
    80002590:	70a2                	ld	ra,40(sp)
    80002592:	7402                	ld	s0,32(sp)
    80002594:	64e2                	ld	s1,24(sp)
    80002596:	6942                	ld	s2,16(sp)
    80002598:	69a2                	ld	s3,8(sp)
    8000259a:	6145                	addi	sp,sp,48
    8000259c:	8082                	ret

000000008000259e <ialloc>:
{
    8000259e:	7139                	addi	sp,sp,-64
    800025a0:	fc06                	sd	ra,56(sp)
    800025a2:	f822                	sd	s0,48(sp)
    800025a4:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800025a6:	0000f717          	auipc	a4,0xf
    800025aa:	c2e72703          	lw	a4,-978(a4) # 800111d4 <sb+0xc>
    800025ae:	4785                	li	a5,1
    800025b0:	06e7f063          	bgeu	a5,a4,80002610 <ialloc+0x72>
    800025b4:	f426                	sd	s1,40(sp)
    800025b6:	f04a                	sd	s2,32(sp)
    800025b8:	ec4e                	sd	s3,24(sp)
    800025ba:	e852                	sd	s4,16(sp)
    800025bc:	e456                	sd	s5,8(sp)
    800025be:	e05a                	sd	s6,0(sp)
    800025c0:	8aaa                	mv	s5,a0
    800025c2:	8b2e                	mv	s6,a1
    800025c4:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800025c6:	0000fa17          	auipc	s4,0xf
    800025ca:	c02a0a13          	addi	s4,s4,-1022 # 800111c8 <sb>
    800025ce:	00495593          	srli	a1,s2,0x4
    800025d2:	018a2783          	lw	a5,24(s4)
    800025d6:	9dbd                	addw	a1,a1,a5
    800025d8:	8556                	mv	a0,s5
    800025da:	9edff0ef          	jal	80001fc6 <bread>
    800025de:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800025e0:	05850993          	addi	s3,a0,88
    800025e4:	00f97793          	andi	a5,s2,15
    800025e8:	079a                	slli	a5,a5,0x6
    800025ea:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800025ec:	00099783          	lh	a5,0(s3)
    800025f0:	cb9d                	beqz	a5,80002626 <ialloc+0x88>
    brelse(bp);
    800025f2:	addff0ef          	jal	800020ce <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800025f6:	0905                	addi	s2,s2,1
    800025f8:	00ca2703          	lw	a4,12(s4)
    800025fc:	0009079b          	sext.w	a5,s2
    80002600:	fce7e7e3          	bltu	a5,a4,800025ce <ialloc+0x30>
    80002604:	74a2                	ld	s1,40(sp)
    80002606:	7902                	ld	s2,32(sp)
    80002608:	69e2                	ld	s3,24(sp)
    8000260a:	6a42                	ld	s4,16(sp)
    8000260c:	6aa2                	ld	s5,8(sp)
    8000260e:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002610:	00005517          	auipc	a0,0x5
    80002614:	dc050513          	addi	a0,a0,-576 # 800073d0 <etext+0x3d0>
    80002618:	054030ef          	jal	8000566c <printf>
  return 0;
    8000261c:	4501                	li	a0,0
}
    8000261e:	70e2                	ld	ra,56(sp)
    80002620:	7442                	ld	s0,48(sp)
    80002622:	6121                	addi	sp,sp,64
    80002624:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002626:	04000613          	li	a2,64
    8000262a:	4581                	li	a1,0
    8000262c:	854e                	mv	a0,s3
    8000262e:	b31fd0ef          	jal	8000015e <memset>
      dip->type = type;
    80002632:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002636:	8526                	mv	a0,s1
    80002638:	50d000ef          	jal	80003344 <log_write>
      brelse(bp);
    8000263c:	8526                	mv	a0,s1
    8000263e:	a91ff0ef          	jal	800020ce <brelse>
      return iget(dev, inum);
    80002642:	0009059b          	sext.w	a1,s2
    80002646:	8556                	mv	a0,s5
    80002648:	e55ff0ef          	jal	8000249c <iget>
    8000264c:	74a2                	ld	s1,40(sp)
    8000264e:	7902                	ld	s2,32(sp)
    80002650:	69e2                	ld	s3,24(sp)
    80002652:	6a42                	ld	s4,16(sp)
    80002654:	6aa2                	ld	s5,8(sp)
    80002656:	6b02                	ld	s6,0(sp)
    80002658:	b7d9                	j	8000261e <ialloc+0x80>

000000008000265a <iupdate>:
{
    8000265a:	1101                	addi	sp,sp,-32
    8000265c:	ec06                	sd	ra,24(sp)
    8000265e:	e822                	sd	s0,16(sp)
    80002660:	e426                	sd	s1,8(sp)
    80002662:	e04a                	sd	s2,0(sp)
    80002664:	1000                	addi	s0,sp,32
    80002666:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002668:	415c                	lw	a5,4(a0)
    8000266a:	0047d79b          	srliw	a5,a5,0x4
    8000266e:	0000f597          	auipc	a1,0xf
    80002672:	b725a583          	lw	a1,-1166(a1) # 800111e0 <sb+0x18>
    80002676:	9dbd                	addw	a1,a1,a5
    80002678:	4108                	lw	a0,0(a0)
    8000267a:	94dff0ef          	jal	80001fc6 <bread>
    8000267e:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002680:	05850793          	addi	a5,a0,88
    80002684:	40d8                	lw	a4,4(s1)
    80002686:	8b3d                	andi	a4,a4,15
    80002688:	071a                	slli	a4,a4,0x6
    8000268a:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    8000268c:	04449703          	lh	a4,68(s1)
    80002690:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002694:	04649703          	lh	a4,70(s1)
    80002698:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    8000269c:	04849703          	lh	a4,72(s1)
    800026a0:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800026a4:	04a49703          	lh	a4,74(s1)
    800026a8:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800026ac:	44f8                	lw	a4,76(s1)
    800026ae:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026b0:	03400613          	li	a2,52
    800026b4:	05048593          	addi	a1,s1,80
    800026b8:	00c78513          	addi	a0,a5,12
    800026bc:	b03fd0ef          	jal	800001be <memmove>
  log_write(bp);
    800026c0:	854a                	mv	a0,s2
    800026c2:	483000ef          	jal	80003344 <log_write>
  brelse(bp);
    800026c6:	854a                	mv	a0,s2
    800026c8:	a07ff0ef          	jal	800020ce <brelse>
}
    800026cc:	60e2                	ld	ra,24(sp)
    800026ce:	6442                	ld	s0,16(sp)
    800026d0:	64a2                	ld	s1,8(sp)
    800026d2:	6902                	ld	s2,0(sp)
    800026d4:	6105                	addi	sp,sp,32
    800026d6:	8082                	ret

00000000800026d8 <idup>:
{
    800026d8:	1101                	addi	sp,sp,-32
    800026da:	ec06                	sd	ra,24(sp)
    800026dc:	e822                	sd	s0,16(sp)
    800026de:	e426                	sd	s1,8(sp)
    800026e0:	1000                	addi	s0,sp,32
    800026e2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800026e4:	0000f517          	auipc	a0,0xf
    800026e8:	b0450513          	addi	a0,a0,-1276 # 800111e8 <itable>
    800026ec:	56c030ef          	jal	80005c58 <acquire>
  ip->ref++;
    800026f0:	449c                	lw	a5,8(s1)
    800026f2:	2785                	addiw	a5,a5,1
    800026f4:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800026f6:	0000f517          	auipc	a0,0xf
    800026fa:	af250513          	addi	a0,a0,-1294 # 800111e8 <itable>
    800026fe:	5ee030ef          	jal	80005cec <release>
}
    80002702:	8526                	mv	a0,s1
    80002704:	60e2                	ld	ra,24(sp)
    80002706:	6442                	ld	s0,16(sp)
    80002708:	64a2                	ld	s1,8(sp)
    8000270a:	6105                	addi	sp,sp,32
    8000270c:	8082                	ret

000000008000270e <ilock>:
{
    8000270e:	1101                	addi	sp,sp,-32
    80002710:	ec06                	sd	ra,24(sp)
    80002712:	e822                	sd	s0,16(sp)
    80002714:	e426                	sd	s1,8(sp)
    80002716:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002718:	cd19                	beqz	a0,80002736 <ilock+0x28>
    8000271a:	84aa                	mv	s1,a0
    8000271c:	451c                	lw	a5,8(a0)
    8000271e:	00f05c63          	blez	a5,80002736 <ilock+0x28>
  acquiresleep(&ip->lock);
    80002722:	0541                	addi	a0,a0,16
    80002724:	51b000ef          	jal	8000343e <acquiresleep>
  if(ip->valid == 0){
    80002728:	40bc                	lw	a5,64(s1)
    8000272a:	cf89                	beqz	a5,80002744 <ilock+0x36>
}
    8000272c:	60e2                	ld	ra,24(sp)
    8000272e:	6442                	ld	s0,16(sp)
    80002730:	64a2                	ld	s1,8(sp)
    80002732:	6105                	addi	sp,sp,32
    80002734:	8082                	ret
    80002736:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002738:	00005517          	auipc	a0,0x5
    8000273c:	cb050513          	addi	a0,a0,-848 # 800073e8 <etext+0x3e8>
    80002740:	256030ef          	jal	80005996 <panic>
    80002744:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002746:	40dc                	lw	a5,4(s1)
    80002748:	0047d79b          	srliw	a5,a5,0x4
    8000274c:	0000f597          	auipc	a1,0xf
    80002750:	a945a583          	lw	a1,-1388(a1) # 800111e0 <sb+0x18>
    80002754:	9dbd                	addw	a1,a1,a5
    80002756:	4088                	lw	a0,0(s1)
    80002758:	86fff0ef          	jal	80001fc6 <bread>
    8000275c:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    8000275e:	05850593          	addi	a1,a0,88
    80002762:	40dc                	lw	a5,4(s1)
    80002764:	8bbd                	andi	a5,a5,15
    80002766:	079a                	slli	a5,a5,0x6
    80002768:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    8000276a:	00059783          	lh	a5,0(a1)
    8000276e:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002772:	00259783          	lh	a5,2(a1)
    80002776:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    8000277a:	00459783          	lh	a5,4(a1)
    8000277e:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002782:	00659783          	lh	a5,6(a1)
    80002786:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    8000278a:	459c                	lw	a5,8(a1)
    8000278c:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    8000278e:	03400613          	li	a2,52
    80002792:	05b1                	addi	a1,a1,12
    80002794:	05048513          	addi	a0,s1,80
    80002798:	a27fd0ef          	jal	800001be <memmove>
    brelse(bp);
    8000279c:	854a                	mv	a0,s2
    8000279e:	931ff0ef          	jal	800020ce <brelse>
    ip->valid = 1;
    800027a2:	4785                	li	a5,1
    800027a4:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027a6:	04449783          	lh	a5,68(s1)
    800027aa:	c399                	beqz	a5,800027b0 <ilock+0xa2>
    800027ac:	6902                	ld	s2,0(sp)
    800027ae:	bfbd                	j	8000272c <ilock+0x1e>
      panic("ilock: no type");
    800027b0:	00005517          	auipc	a0,0x5
    800027b4:	c4050513          	addi	a0,a0,-960 # 800073f0 <etext+0x3f0>
    800027b8:	1de030ef          	jal	80005996 <panic>

00000000800027bc <iunlock>:
{
    800027bc:	1101                	addi	sp,sp,-32
    800027be:	ec06                	sd	ra,24(sp)
    800027c0:	e822                	sd	s0,16(sp)
    800027c2:	e426                	sd	s1,8(sp)
    800027c4:	e04a                	sd	s2,0(sp)
    800027c6:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800027c8:	c505                	beqz	a0,800027f0 <iunlock+0x34>
    800027ca:	84aa                	mv	s1,a0
    800027cc:	01050913          	addi	s2,a0,16
    800027d0:	854a                	mv	a0,s2
    800027d2:	4eb000ef          	jal	800034bc <holdingsleep>
    800027d6:	cd09                	beqz	a0,800027f0 <iunlock+0x34>
    800027d8:	449c                	lw	a5,8(s1)
    800027da:	00f05b63          	blez	a5,800027f0 <iunlock+0x34>
  releasesleep(&ip->lock);
    800027de:	854a                	mv	a0,s2
    800027e0:	4a5000ef          	jal	80003484 <releasesleep>
}
    800027e4:	60e2                	ld	ra,24(sp)
    800027e6:	6442                	ld	s0,16(sp)
    800027e8:	64a2                	ld	s1,8(sp)
    800027ea:	6902                	ld	s2,0(sp)
    800027ec:	6105                	addi	sp,sp,32
    800027ee:	8082                	ret
    panic("iunlock");
    800027f0:	00005517          	auipc	a0,0x5
    800027f4:	c1050513          	addi	a0,a0,-1008 # 80007400 <etext+0x400>
    800027f8:	19e030ef          	jal	80005996 <panic>

00000000800027fc <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800027fc:	715d                	addi	sp,sp,-80
    800027fe:	e486                	sd	ra,72(sp)
    80002800:	e0a2                	sd	s0,64(sp)
    80002802:	fc26                	sd	s1,56(sp)
    80002804:	f84a                	sd	s2,48(sp)
    80002806:	f44e                	sd	s3,40(sp)
    80002808:	0880                	addi	s0,sp,80
    8000280a:	89aa                	mv	s3,a0
  int i, j, k;
  struct buf *bp, *bp2;
  uint *a, *a2;

  for(i = 0; i < NDIRECT; i++){
    8000280c:	05050493          	addi	s1,a0,80
    80002810:	07c50913          	addi	s2,a0,124
    80002814:	a021                	j	8000281c <itrunc+0x20>
    80002816:	0491                	addi	s1,s1,4
    80002818:	01248b63          	beq	s1,s2,8000282e <itrunc+0x32>
    if(ip->addrs[i]){
    8000281c:	408c                	lw	a1,0(s1)
    8000281e:	dde5                	beqz	a1,80002816 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002820:	0009a503          	lw	a0,0(s3)
    80002824:	997ff0ef          	jal	800021ba <bfree>
      ip->addrs[i] = 0;
    80002828:	0004a023          	sw	zero,0(s1)
    8000282c:	b7ed                	j	80002816 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    8000282e:	07c9a583          	lw	a1,124(s3)
    80002832:	e185                	bnez	a1,80002852 <itrunc+0x56>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  if(ip->addrs[NDIRECT+1]){
    80002834:	0809a583          	lw	a1,128(s3)
    80002838:	edb9                	bnez	a1,80002896 <itrunc+0x9a>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    ip->addrs[NDIRECT+1] = 0;
  }

  ip->size = 0;
    8000283a:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    8000283e:	854e                	mv	a0,s3
    80002840:	e1bff0ef          	jal	8000265a <iupdate>
}
    80002844:	60a6                	ld	ra,72(sp)
    80002846:	6406                	ld	s0,64(sp)
    80002848:	74e2                	ld	s1,56(sp)
    8000284a:	7942                	ld	s2,48(sp)
    8000284c:	79a2                	ld	s3,40(sp)
    8000284e:	6161                	addi	sp,sp,80
    80002850:	8082                	ret
    80002852:	f052                	sd	s4,32(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002854:	0009a503          	lw	a0,0(s3)
    80002858:	f6eff0ef          	jal	80001fc6 <bread>
    8000285c:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    8000285e:	05850493          	addi	s1,a0,88
    80002862:	45850913          	addi	s2,a0,1112
    80002866:	a021                	j	8000286e <itrunc+0x72>
    80002868:	0491                	addi	s1,s1,4
    8000286a:	01248963          	beq	s1,s2,8000287c <itrunc+0x80>
      if(a[j])
    8000286e:	408c                	lw	a1,0(s1)
    80002870:	dde5                	beqz	a1,80002868 <itrunc+0x6c>
        bfree(ip->dev, a[j]);
    80002872:	0009a503          	lw	a0,0(s3)
    80002876:	945ff0ef          	jal	800021ba <bfree>
    8000287a:	b7fd                	j	80002868 <itrunc+0x6c>
    brelse(bp);
    8000287c:	8552                	mv	a0,s4
    8000287e:	851ff0ef          	jal	800020ce <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002882:	07c9a583          	lw	a1,124(s3)
    80002886:	0009a503          	lw	a0,0(s3)
    8000288a:	931ff0ef          	jal	800021ba <bfree>
    ip->addrs[NDIRECT] = 0;
    8000288e:	0609ae23          	sw	zero,124(s3)
    80002892:	7a02                	ld	s4,32(sp)
    80002894:	b745                	j	80002834 <itrunc+0x38>
    80002896:	f052                	sd	s4,32(sp)
    80002898:	ec56                	sd	s5,24(sp)
    8000289a:	e85a                	sd	s6,16(sp)
    8000289c:	e45e                	sd	s7,8(sp)
    8000289e:	e062                	sd	s8,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT+1]);
    800028a0:	0009a503          	lw	a0,0(s3)
    800028a4:	f22ff0ef          	jal	80001fc6 <bread>
    800028a8:	8c2a                	mv	s8,a0
    for(j = 0; j < NINDIRECT; j++){
    800028aa:	05850a13          	addi	s4,a0,88
    800028ae:	45850b13          	addi	s6,a0,1112
    800028b2:	a03d                	j	800028e0 <itrunc+0xe4>
            bfree(ip->dev, a2[k]);
    800028b4:	0009a503          	lw	a0,0(s3)
    800028b8:	903ff0ef          	jal	800021ba <bfree>
        for(k = 0; k < NINDIRECT; k++){
    800028bc:	0491                	addi	s1,s1,4
    800028be:	01248563          	beq	s1,s2,800028c8 <itrunc+0xcc>
          if(a2[k])
    800028c2:	408c                	lw	a1,0(s1)
    800028c4:	dde5                	beqz	a1,800028bc <itrunc+0xc0>
    800028c6:	b7fd                	j	800028b4 <itrunc+0xb8>
        brelse(bp2);
    800028c8:	855e                	mv	a0,s7
    800028ca:	805ff0ef          	jal	800020ce <brelse>
        bfree(ip->dev, a[j]);
    800028ce:	000aa583          	lw	a1,0(s5)
    800028d2:	0009a503          	lw	a0,0(s3)
    800028d6:	8e5ff0ef          	jal	800021ba <bfree>
    for(j = 0; j < NINDIRECT; j++){
    800028da:	0a11                	addi	s4,s4,4
    800028dc:	036a0063          	beq	s4,s6,800028fc <itrunc+0x100>
      if(a[j]) {
    800028e0:	8ad2                	mv	s5,s4
    800028e2:	000a2583          	lw	a1,0(s4)
    800028e6:	d9f5                	beqz	a1,800028da <itrunc+0xde>
        bp2 = bread(ip->dev, a[j]);
    800028e8:	0009a503          	lw	a0,0(s3)
    800028ec:	edaff0ef          	jal	80001fc6 <bread>
    800028f0:	8baa                	mv	s7,a0
        for(k = 0; k < NINDIRECT; k++){
    800028f2:	05850493          	addi	s1,a0,88
    800028f6:	45850913          	addi	s2,a0,1112
    800028fa:	b7e1                	j	800028c2 <itrunc+0xc6>
    brelse(bp);
    800028fc:	8562                	mv	a0,s8
    800028fe:	fd0ff0ef          	jal	800020ce <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT+1]);
    80002902:	0809a583          	lw	a1,128(s3)
    80002906:	0009a503          	lw	a0,0(s3)
    8000290a:	8b1ff0ef          	jal	800021ba <bfree>
    ip->addrs[NDIRECT+1] = 0;
    8000290e:	0809a023          	sw	zero,128(s3)
    80002912:	7a02                	ld	s4,32(sp)
    80002914:	6ae2                	ld	s5,24(sp)
    80002916:	6b42                	ld	s6,16(sp)
    80002918:	6ba2                	ld	s7,8(sp)
    8000291a:	6c02                	ld	s8,0(sp)
    8000291c:	bf39                	j	8000283a <itrunc+0x3e>

000000008000291e <iput>:
{
    8000291e:	1101                	addi	sp,sp,-32
    80002920:	ec06                	sd	ra,24(sp)
    80002922:	e822                	sd	s0,16(sp)
    80002924:	e426                	sd	s1,8(sp)
    80002926:	1000                	addi	s0,sp,32
    80002928:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000292a:	0000f517          	auipc	a0,0xf
    8000292e:	8be50513          	addi	a0,a0,-1858 # 800111e8 <itable>
    80002932:	326030ef          	jal	80005c58 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002936:	4498                	lw	a4,8(s1)
    80002938:	4785                	li	a5,1
    8000293a:	02f70063          	beq	a4,a5,8000295a <iput+0x3c>
  ip->ref--;
    8000293e:	449c                	lw	a5,8(s1)
    80002940:	37fd                	addiw	a5,a5,-1
    80002942:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002944:	0000f517          	auipc	a0,0xf
    80002948:	8a450513          	addi	a0,a0,-1884 # 800111e8 <itable>
    8000294c:	3a0030ef          	jal	80005cec <release>
}
    80002950:	60e2                	ld	ra,24(sp)
    80002952:	6442                	ld	s0,16(sp)
    80002954:	64a2                	ld	s1,8(sp)
    80002956:	6105                	addi	sp,sp,32
    80002958:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    8000295a:	40bc                	lw	a5,64(s1)
    8000295c:	d3ed                	beqz	a5,8000293e <iput+0x20>
    8000295e:	04a49783          	lh	a5,74(s1)
    80002962:	fff1                	bnez	a5,8000293e <iput+0x20>
    80002964:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002966:	01048793          	addi	a5,s1,16
    8000296a:	893e                	mv	s2,a5
    8000296c:	853e                	mv	a0,a5
    8000296e:	2d1000ef          	jal	8000343e <acquiresleep>
    release(&itable.lock);
    80002972:	0000f517          	auipc	a0,0xf
    80002976:	87650513          	addi	a0,a0,-1930 # 800111e8 <itable>
    8000297a:	372030ef          	jal	80005cec <release>
    itrunc(ip);
    8000297e:	8526                	mv	a0,s1
    80002980:	e7dff0ef          	jal	800027fc <itrunc>
    ip->type = 0;
    80002984:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002988:	8526                	mv	a0,s1
    8000298a:	cd1ff0ef          	jal	8000265a <iupdate>
    ip->valid = 0;
    8000298e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002992:	854a                	mv	a0,s2
    80002994:	2f1000ef          	jal	80003484 <releasesleep>
    acquire(&itable.lock);
    80002998:	0000f517          	auipc	a0,0xf
    8000299c:	85050513          	addi	a0,a0,-1968 # 800111e8 <itable>
    800029a0:	2b8030ef          	jal	80005c58 <acquire>
    800029a4:	6902                	ld	s2,0(sp)
    800029a6:	bf61                	j	8000293e <iput+0x20>

00000000800029a8 <iunlockput>:
{
    800029a8:	1101                	addi	sp,sp,-32
    800029aa:	ec06                	sd	ra,24(sp)
    800029ac:	e822                	sd	s0,16(sp)
    800029ae:	e426                	sd	s1,8(sp)
    800029b0:	1000                	addi	s0,sp,32
    800029b2:	84aa                	mv	s1,a0
  iunlock(ip);
    800029b4:	e09ff0ef          	jal	800027bc <iunlock>
  iput(ip);
    800029b8:	8526                	mv	a0,s1
    800029ba:	f65ff0ef          	jal	8000291e <iput>
}
    800029be:	60e2                	ld	ra,24(sp)
    800029c0:	6442                	ld	s0,16(sp)
    800029c2:	64a2                	ld	s1,8(sp)
    800029c4:	6105                	addi	sp,sp,32
    800029c6:	8082                	ret

00000000800029c8 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029c8:	0000f717          	auipc	a4,0xf
    800029cc:	80c72703          	lw	a4,-2036(a4) # 800111d4 <sb+0xc>
    800029d0:	4785                	li	a5,1
    800029d2:	0ae7fe63          	bgeu	a5,a4,80002a8e <ireclaim+0xc6>
{
    800029d6:	7139                	addi	sp,sp,-64
    800029d8:	fc06                	sd	ra,56(sp)
    800029da:	f822                	sd	s0,48(sp)
    800029dc:	f426                	sd	s1,40(sp)
    800029de:	f04a                	sd	s2,32(sp)
    800029e0:	ec4e                	sd	s3,24(sp)
    800029e2:	e852                	sd	s4,16(sp)
    800029e4:	e456                	sd	s5,8(sp)
    800029e6:	e05a                	sd	s6,0(sp)
    800029e8:	0080                	addi	s0,sp,64
    800029ea:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029ec:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800029ee:	0000ea17          	auipc	s4,0xe
    800029f2:	7daa0a13          	addi	s4,s4,2010 # 800111c8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800029f6:	00005b17          	auipc	s6,0x5
    800029fa:	a12b0b13          	addi	s6,s6,-1518 # 80007408 <etext+0x408>
    800029fe:	a099                	j	80002a44 <ireclaim+0x7c>
    80002a00:	85ce                	mv	a1,s3
    80002a02:	855a                	mv	a0,s6
    80002a04:	469020ef          	jal	8000566c <printf>
      ip = iget(dev, inum);
    80002a08:	85ce                	mv	a1,s3
    80002a0a:	8556                	mv	a0,s5
    80002a0c:	a91ff0ef          	jal	8000249c <iget>
    80002a10:	89aa                	mv	s3,a0
    brelse(bp);
    80002a12:	854a                	mv	a0,s2
    80002a14:	ebaff0ef          	jal	800020ce <brelse>
    if (ip) {
    80002a18:	00098f63          	beqz	s3,80002a36 <ireclaim+0x6e>
      begin_op();
    80002a1c:	78e000ef          	jal	800031aa <begin_op>
      ilock(ip);
    80002a20:	854e                	mv	a0,s3
    80002a22:	cedff0ef          	jal	8000270e <ilock>
      iunlock(ip);
    80002a26:	854e                	mv	a0,s3
    80002a28:	d95ff0ef          	jal	800027bc <iunlock>
      iput(ip);
    80002a2c:	854e                	mv	a0,s3
    80002a2e:	ef1ff0ef          	jal	8000291e <iput>
      end_op();
    80002a32:	7e8000ef          	jal	8000321a <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002a36:	0485                	addi	s1,s1,1
    80002a38:	00ca2703          	lw	a4,12(s4)
    80002a3c:	0004879b          	sext.w	a5,s1
    80002a40:	02e7fd63          	bgeu	a5,a4,80002a7a <ireclaim+0xb2>
    80002a44:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002a48:	0044d593          	srli	a1,s1,0x4
    80002a4c:	018a2783          	lw	a5,24(s4)
    80002a50:	9dbd                	addw	a1,a1,a5
    80002a52:	8556                	mv	a0,s5
    80002a54:	d72ff0ef          	jal	80001fc6 <bread>
    80002a58:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002a5a:	05850793          	addi	a5,a0,88
    80002a5e:	00f9f713          	andi	a4,s3,15
    80002a62:	071a                	slli	a4,a4,0x6
    80002a64:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002a66:	00079703          	lh	a4,0(a5)
    80002a6a:	c701                	beqz	a4,80002a72 <ireclaim+0xaa>
    80002a6c:	00679783          	lh	a5,6(a5)
    80002a70:	dbc1                	beqz	a5,80002a00 <ireclaim+0x38>
    brelse(bp);
    80002a72:	854a                	mv	a0,s2
    80002a74:	e5aff0ef          	jal	800020ce <brelse>
    if (ip) {
    80002a78:	bf7d                	j	80002a36 <ireclaim+0x6e>
}
    80002a7a:	70e2                	ld	ra,56(sp)
    80002a7c:	7442                	ld	s0,48(sp)
    80002a7e:	74a2                	ld	s1,40(sp)
    80002a80:	7902                	ld	s2,32(sp)
    80002a82:	69e2                	ld	s3,24(sp)
    80002a84:	6a42                	ld	s4,16(sp)
    80002a86:	6aa2                	ld	s5,8(sp)
    80002a88:	6b02                	ld	s6,0(sp)
    80002a8a:	6121                	addi	sp,sp,64
    80002a8c:	8082                	ret
    80002a8e:	8082                	ret

0000000080002a90 <fsinit>:
fsinit(int dev) {
    80002a90:	1101                	addi	sp,sp,-32
    80002a92:	ec06                	sd	ra,24(sp)
    80002a94:	e822                	sd	s0,16(sp)
    80002a96:	e426                	sd	s1,8(sp)
    80002a98:	e04a                	sd	s2,0(sp)
    80002a9a:	1000                	addi	s0,sp,32
    80002a9c:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a9e:	4585                	li	a1,1
    80002aa0:	d26ff0ef          	jal	80001fc6 <bread>
    80002aa4:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002aa6:	02000613          	li	a2,32
    80002aaa:	05850593          	addi	a1,a0,88
    80002aae:	0000e517          	auipc	a0,0xe
    80002ab2:	71a50513          	addi	a0,a0,1818 # 800111c8 <sb>
    80002ab6:	f08fd0ef          	jal	800001be <memmove>
  brelse(bp);
    80002aba:	8526                	mv	a0,s1
    80002abc:	e12ff0ef          	jal	800020ce <brelse>
  if(sb.magic != FSMAGIC)
    80002ac0:	0000e717          	auipc	a4,0xe
    80002ac4:	70872703          	lw	a4,1800(a4) # 800111c8 <sb>
    80002ac8:	102037b7          	lui	a5,0x10203
    80002acc:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002ad0:	02f71263          	bne	a4,a5,80002af4 <fsinit+0x64>
  initlog(dev, &sb);
    80002ad4:	0000e597          	auipc	a1,0xe
    80002ad8:	6f458593          	addi	a1,a1,1780 # 800111c8 <sb>
    80002adc:	854a                	mv	a0,s2
    80002ade:	64a000ef          	jal	80003128 <initlog>
  ireclaim(dev);
    80002ae2:	854a                	mv	a0,s2
    80002ae4:	ee5ff0ef          	jal	800029c8 <ireclaim>
}
    80002ae8:	60e2                	ld	ra,24(sp)
    80002aea:	6442                	ld	s0,16(sp)
    80002aec:	64a2                	ld	s1,8(sp)
    80002aee:	6902                	ld	s2,0(sp)
    80002af0:	6105                	addi	sp,sp,32
    80002af2:	8082                	ret
    panic("invalid file system");
    80002af4:	00005517          	auipc	a0,0x5
    80002af8:	93450513          	addi	a0,a0,-1740 # 80007428 <etext+0x428>
    80002afc:	69b020ef          	jal	80005996 <panic>

0000000080002b00 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002b00:	1141                	addi	sp,sp,-16
    80002b02:	e406                	sd	ra,8(sp)
    80002b04:	e022                	sd	s0,0(sp)
    80002b06:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002b08:	411c                	lw	a5,0(a0)
    80002b0a:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002b0c:	415c                	lw	a5,4(a0)
    80002b0e:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002b10:	04451783          	lh	a5,68(a0)
    80002b14:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002b18:	04a51783          	lh	a5,74(a0)
    80002b1c:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002b20:	04c56783          	lwu	a5,76(a0)
    80002b24:	e99c                	sd	a5,16(a1)
}
    80002b26:	60a2                	ld	ra,8(sp)
    80002b28:	6402                	ld	s0,0(sp)
    80002b2a:	0141                	addi	sp,sp,16
    80002b2c:	8082                	ret

0000000080002b2e <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002b2e:	457c                	lw	a5,76(a0)
    80002b30:	0ed7e663          	bltu	a5,a3,80002c1c <readi+0xee>
{
    80002b34:	7159                	addi	sp,sp,-112
    80002b36:	f486                	sd	ra,104(sp)
    80002b38:	f0a2                	sd	s0,96(sp)
    80002b3a:	eca6                	sd	s1,88(sp)
    80002b3c:	e0d2                	sd	s4,64(sp)
    80002b3e:	fc56                	sd	s5,56(sp)
    80002b40:	f85a                	sd	s6,48(sp)
    80002b42:	f45e                	sd	s7,40(sp)
    80002b44:	1880                	addi	s0,sp,112
    80002b46:	8b2a                	mv	s6,a0
    80002b48:	8bae                	mv	s7,a1
    80002b4a:	8a32                	mv	s4,a2
    80002b4c:	84b6                	mv	s1,a3
    80002b4e:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002b50:	9f35                	addw	a4,a4,a3
    return 0;
    80002b52:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002b54:	0ad76b63          	bltu	a4,a3,80002c0a <readi+0xdc>
    80002b58:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002b5a:	00e7f463          	bgeu	a5,a4,80002b62 <readi+0x34>
    n = ip->size - off;
    80002b5e:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b62:	080a8b63          	beqz	s5,80002bf8 <readi+0xca>
    80002b66:	e8ca                	sd	s2,80(sp)
    80002b68:	f062                	sd	s8,32(sp)
    80002b6a:	ec66                	sd	s9,24(sp)
    80002b6c:	e86a                	sd	s10,16(sp)
    80002b6e:	e46e                	sd	s11,8(sp)
    80002b70:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b72:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002b76:	5c7d                	li	s8,-1
    80002b78:	a80d                	j	80002baa <readi+0x7c>
    80002b7a:	020d1d93          	slli	s11,s10,0x20
    80002b7e:	020ddd93          	srli	s11,s11,0x20
    80002b82:	05890613          	addi	a2,s2,88
    80002b86:	86ee                	mv	a3,s11
    80002b88:	963e                	add	a2,a2,a5
    80002b8a:	85d2                	mv	a1,s4
    80002b8c:	855e                	mv	a0,s7
    80002b8e:	b61fe0ef          	jal	800016ee <either_copyout>
    80002b92:	05850363          	beq	a0,s8,80002bd8 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002b96:	854a                	mv	a0,s2
    80002b98:	d36ff0ef          	jal	800020ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b9c:	013d09bb          	addw	s3,s10,s3
    80002ba0:	009d04bb          	addw	s1,s10,s1
    80002ba4:	9a6e                	add	s4,s4,s11
    80002ba6:	0559f363          	bgeu	s3,s5,80002bec <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002baa:	00a4d59b          	srliw	a1,s1,0xa
    80002bae:	855a                	mv	a0,s6
    80002bb0:	f7cff0ef          	jal	8000232c <bmap>
    80002bb4:	85aa                	mv	a1,a0
    if(addr == 0)
    80002bb6:	c139                	beqz	a0,80002bfc <readi+0xce>
    bp = bread(ip->dev, addr);
    80002bb8:	000b2503          	lw	a0,0(s6)
    80002bbc:	c0aff0ef          	jal	80001fc6 <bread>
    80002bc0:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002bc2:	3ff4f793          	andi	a5,s1,1023
    80002bc6:	40fc873b          	subw	a4,s9,a5
    80002bca:	413a86bb          	subw	a3,s5,s3
    80002bce:	8d3a                	mv	s10,a4
    80002bd0:	fae6f5e3          	bgeu	a3,a4,80002b7a <readi+0x4c>
    80002bd4:	8d36                	mv	s10,a3
    80002bd6:	b755                	j	80002b7a <readi+0x4c>
      brelse(bp);
    80002bd8:	854a                	mv	a0,s2
    80002bda:	cf4ff0ef          	jal	800020ce <brelse>
      tot = -1;
    80002bde:	59fd                	li	s3,-1
      break;
    80002be0:	6946                	ld	s2,80(sp)
    80002be2:	7c02                	ld	s8,32(sp)
    80002be4:	6ce2                	ld	s9,24(sp)
    80002be6:	6d42                	ld	s10,16(sp)
    80002be8:	6da2                	ld	s11,8(sp)
    80002bea:	a831                	j	80002c06 <readi+0xd8>
    80002bec:	6946                	ld	s2,80(sp)
    80002bee:	7c02                	ld	s8,32(sp)
    80002bf0:	6ce2                	ld	s9,24(sp)
    80002bf2:	6d42                	ld	s10,16(sp)
    80002bf4:	6da2                	ld	s11,8(sp)
    80002bf6:	a801                	j	80002c06 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002bf8:	89d6                	mv	s3,s5
    80002bfa:	a031                	j	80002c06 <readi+0xd8>
    80002bfc:	6946                	ld	s2,80(sp)
    80002bfe:	7c02                	ld	s8,32(sp)
    80002c00:	6ce2                	ld	s9,24(sp)
    80002c02:	6d42                	ld	s10,16(sp)
    80002c04:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002c06:	854e                	mv	a0,s3
    80002c08:	69a6                	ld	s3,72(sp)
}
    80002c0a:	70a6                	ld	ra,104(sp)
    80002c0c:	7406                	ld	s0,96(sp)
    80002c0e:	64e6                	ld	s1,88(sp)
    80002c10:	6a06                	ld	s4,64(sp)
    80002c12:	7ae2                	ld	s5,56(sp)
    80002c14:	7b42                	ld	s6,48(sp)
    80002c16:	7ba2                	ld	s7,40(sp)
    80002c18:	6165                	addi	sp,sp,112
    80002c1a:	8082                	ret
    return 0;
    80002c1c:	4501                	li	a0,0
}
    80002c1e:	8082                	ret

0000000080002c20 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c20:	457c                	lw	a5,76(a0)
    80002c22:	0ed7ec63          	bltu	a5,a3,80002d1a <writei+0xfa>
{
    80002c26:	7159                	addi	sp,sp,-112
    80002c28:	f486                	sd	ra,104(sp)
    80002c2a:	f0a2                	sd	s0,96(sp)
    80002c2c:	e8ca                	sd	s2,80(sp)
    80002c2e:	e0d2                	sd	s4,64(sp)
    80002c30:	fc56                	sd	s5,56(sp)
    80002c32:	f85a                	sd	s6,48(sp)
    80002c34:	f45e                	sd	s7,40(sp)
    80002c36:	1880                	addi	s0,sp,112
    80002c38:	8aaa                	mv	s5,a0
    80002c3a:	8bae                	mv	s7,a1
    80002c3c:	8a32                	mv	s4,a2
    80002c3e:	8936                	mv	s2,a3
    80002c40:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002c42:	9f35                	addw	a4,a4,a3
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002c44:	040437b7          	lui	a5,0x4043
    80002c48:	c0078793          	addi	a5,a5,-1024 # 4042c00 <_entry-0x7bfbd400>
    80002c4c:	0ce7e963          	bltu	a5,a4,80002d1e <writei+0xfe>
    80002c50:	0cd76763          	bltu	a4,a3,80002d1e <writei+0xfe>
    80002c54:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c56:	0a0b0a63          	beqz	s6,80002d0a <writei+0xea>
    80002c5a:	eca6                	sd	s1,88(sp)
    80002c5c:	f062                	sd	s8,32(sp)
    80002c5e:	ec66                	sd	s9,24(sp)
    80002c60:	e86a                	sd	s10,16(sp)
    80002c62:	e46e                	sd	s11,8(sp)
    80002c64:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c66:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002c6a:	5c7d                	li	s8,-1
    80002c6c:	a825                	j	80002ca4 <writei+0x84>
    80002c6e:	020d1d93          	slli	s11,s10,0x20
    80002c72:	020ddd93          	srli	s11,s11,0x20
    80002c76:	05848513          	addi	a0,s1,88
    80002c7a:	86ee                	mv	a3,s11
    80002c7c:	8652                	mv	a2,s4
    80002c7e:	85de                	mv	a1,s7
    80002c80:	953e                	add	a0,a0,a5
    80002c82:	ab7fe0ef          	jal	80001738 <either_copyin>
    80002c86:	05850663          	beq	a0,s8,80002cd2 <writei+0xb2>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002c8a:	8526                	mv	a0,s1
    80002c8c:	6b8000ef          	jal	80003344 <log_write>
    brelse(bp);
    80002c90:	8526                	mv	a0,s1
    80002c92:	c3cff0ef          	jal	800020ce <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c96:	013d09bb          	addw	s3,s10,s3
    80002c9a:	012d093b          	addw	s2,s10,s2
    80002c9e:	9a6e                	add	s4,s4,s11
    80002ca0:	0369fc63          	bgeu	s3,s6,80002cd8 <writei+0xb8>
    uint addr = bmap(ip, off/BSIZE);
    80002ca4:	00a9559b          	srliw	a1,s2,0xa
    80002ca8:	8556                	mv	a0,s5
    80002caa:	e82ff0ef          	jal	8000232c <bmap>
    80002cae:	85aa                	mv	a1,a0
    if(addr == 0)
    80002cb0:	c505                	beqz	a0,80002cd8 <writei+0xb8>
    bp = bread(ip->dev, addr);
    80002cb2:	000aa503          	lw	a0,0(s5)
    80002cb6:	b10ff0ef          	jal	80001fc6 <bread>
    80002cba:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cbc:	3ff97793          	andi	a5,s2,1023
    80002cc0:	40fc873b          	subw	a4,s9,a5
    80002cc4:	413b06bb          	subw	a3,s6,s3
    80002cc8:	8d3a                	mv	s10,a4
    80002cca:	fae6f2e3          	bgeu	a3,a4,80002c6e <writei+0x4e>
    80002cce:	8d36                	mv	s10,a3
    80002cd0:	bf79                	j	80002c6e <writei+0x4e>
      brelse(bp);
    80002cd2:	8526                	mv	a0,s1
    80002cd4:	bfaff0ef          	jal	800020ce <brelse>
  }

  if(off > ip->size)
    80002cd8:	04caa783          	lw	a5,76(s5)
    80002cdc:	0327f963          	bgeu	a5,s2,80002d0e <writei+0xee>
    ip->size = off;
    80002ce0:	052aa623          	sw	s2,76(s5)
    80002ce4:	64e6                	ld	s1,88(sp)
    80002ce6:	7c02                	ld	s8,32(sp)
    80002ce8:	6ce2                	ld	s9,24(sp)
    80002cea:	6d42                	ld	s10,16(sp)
    80002cec:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002cee:	8556                	mv	a0,s5
    80002cf0:	96bff0ef          	jal	8000265a <iupdate>

  return tot;
    80002cf4:	854e                	mv	a0,s3
    80002cf6:	69a6                	ld	s3,72(sp)
}
    80002cf8:	70a6                	ld	ra,104(sp)
    80002cfa:	7406                	ld	s0,96(sp)
    80002cfc:	6946                	ld	s2,80(sp)
    80002cfe:	6a06                	ld	s4,64(sp)
    80002d00:	7ae2                	ld	s5,56(sp)
    80002d02:	7b42                	ld	s6,48(sp)
    80002d04:	7ba2                	ld	s7,40(sp)
    80002d06:	6165                	addi	sp,sp,112
    80002d08:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002d0a:	89da                	mv	s3,s6
    80002d0c:	b7cd                	j	80002cee <writei+0xce>
    80002d0e:	64e6                	ld	s1,88(sp)
    80002d10:	7c02                	ld	s8,32(sp)
    80002d12:	6ce2                	ld	s9,24(sp)
    80002d14:	6d42                	ld	s10,16(sp)
    80002d16:	6da2                	ld	s11,8(sp)
    80002d18:	bfd9                	j	80002cee <writei+0xce>
    return -1;
    80002d1a:	557d                	li	a0,-1
}
    80002d1c:	8082                	ret
    return -1;
    80002d1e:	557d                	li	a0,-1
    80002d20:	bfe1                	j	80002cf8 <writei+0xd8>

0000000080002d22 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002d22:	1141                	addi	sp,sp,-16
    80002d24:	e406                	sd	ra,8(sp)
    80002d26:	e022                	sd	s0,0(sp)
    80002d28:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002d2a:	4639                	li	a2,14
    80002d2c:	d06fd0ef          	jal	80000232 <strncmp>
}
    80002d30:	60a2                	ld	ra,8(sp)
    80002d32:	6402                	ld	s0,0(sp)
    80002d34:	0141                	addi	sp,sp,16
    80002d36:	8082                	ret

0000000080002d38 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002d38:	711d                	addi	sp,sp,-96
    80002d3a:	ec86                	sd	ra,88(sp)
    80002d3c:	e8a2                	sd	s0,80(sp)
    80002d3e:	e4a6                	sd	s1,72(sp)
    80002d40:	e0ca                	sd	s2,64(sp)
    80002d42:	fc4e                	sd	s3,56(sp)
    80002d44:	f852                	sd	s4,48(sp)
    80002d46:	f456                	sd	s5,40(sp)
    80002d48:	f05a                	sd	s6,32(sp)
    80002d4a:	ec5e                	sd	s7,24(sp)
    80002d4c:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002d4e:	04451703          	lh	a4,68(a0)
    80002d52:	4785                	li	a5,1
    80002d54:	00f71f63          	bne	a4,a5,80002d72 <dirlookup+0x3a>
    80002d58:	892a                	mv	s2,a0
    80002d5a:	8aae                	mv	s5,a1
    80002d5c:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d5e:	457c                	lw	a5,76(a0)
    80002d60:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d62:	fa040a13          	addi	s4,s0,-96
    80002d66:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002d68:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002d6c:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d6e:	e39d                	bnez	a5,80002d94 <dirlookup+0x5c>
    80002d70:	a8b9                	j	80002dce <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002d72:	00004517          	auipc	a0,0x4
    80002d76:	6ce50513          	addi	a0,a0,1742 # 80007440 <etext+0x440>
    80002d7a:	41d020ef          	jal	80005996 <panic>
      panic("dirlookup read");
    80002d7e:	00004517          	auipc	a0,0x4
    80002d82:	6da50513          	addi	a0,a0,1754 # 80007458 <etext+0x458>
    80002d86:	411020ef          	jal	80005996 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d8a:	24c1                	addiw	s1,s1,16
    80002d8c:	04c92783          	lw	a5,76(s2)
    80002d90:	02f4fe63          	bgeu	s1,a5,80002dcc <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d94:	874e                	mv	a4,s3
    80002d96:	86a6                	mv	a3,s1
    80002d98:	8652                	mv	a2,s4
    80002d9a:	4581                	li	a1,0
    80002d9c:	854a                	mv	a0,s2
    80002d9e:	d91ff0ef          	jal	80002b2e <readi>
    80002da2:	fd351ee3          	bne	a0,s3,80002d7e <dirlookup+0x46>
    if(de.inum == 0)
    80002da6:	fa045783          	lhu	a5,-96(s0)
    80002daa:	d3e5                	beqz	a5,80002d8a <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002dac:	85da                	mv	a1,s6
    80002dae:	8556                	mv	a0,s5
    80002db0:	f73ff0ef          	jal	80002d22 <namecmp>
    80002db4:	f979                	bnez	a0,80002d8a <dirlookup+0x52>
      if(poff)
    80002db6:	000b8463          	beqz	s7,80002dbe <dirlookup+0x86>
        *poff = off;
    80002dba:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002dbe:	fa045583          	lhu	a1,-96(s0)
    80002dc2:	00092503          	lw	a0,0(s2)
    80002dc6:	ed6ff0ef          	jal	8000249c <iget>
    80002dca:	a011                	j	80002dce <dirlookup+0x96>
  return 0;
    80002dcc:	4501                	li	a0,0
}
    80002dce:	60e6                	ld	ra,88(sp)
    80002dd0:	6446                	ld	s0,80(sp)
    80002dd2:	64a6                	ld	s1,72(sp)
    80002dd4:	6906                	ld	s2,64(sp)
    80002dd6:	79e2                	ld	s3,56(sp)
    80002dd8:	7a42                	ld	s4,48(sp)
    80002dda:	7aa2                	ld	s5,40(sp)
    80002ddc:	7b02                	ld	s6,32(sp)
    80002dde:	6be2                	ld	s7,24(sp)
    80002de0:	6125                	addi	sp,sp,96
    80002de2:	8082                	ret

0000000080002de4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002de4:	711d                	addi	sp,sp,-96
    80002de6:	ec86                	sd	ra,88(sp)
    80002de8:	e8a2                	sd	s0,80(sp)
    80002dea:	e4a6                	sd	s1,72(sp)
    80002dec:	e0ca                	sd	s2,64(sp)
    80002dee:	fc4e                	sd	s3,56(sp)
    80002df0:	f852                	sd	s4,48(sp)
    80002df2:	f456                	sd	s5,40(sp)
    80002df4:	f05a                	sd	s6,32(sp)
    80002df6:	ec5e                	sd	s7,24(sp)
    80002df8:	e862                	sd	s8,16(sp)
    80002dfa:	e466                	sd	s9,8(sp)
    80002dfc:	e06a                	sd	s10,0(sp)
    80002dfe:	1080                	addi	s0,sp,96
    80002e00:	84aa                	mv	s1,a0
    80002e02:	8b2e                	mv	s6,a1
    80002e04:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002e06:	00054703          	lbu	a4,0(a0)
    80002e0a:	02f00793          	li	a5,47
    80002e0e:	00f70f63          	beq	a4,a5,80002e2c <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002e12:	f83fd0ef          	jal	80000d94 <myproc>
    80002e16:	15053503          	ld	a0,336(a0)
    80002e1a:	8bfff0ef          	jal	800026d8 <idup>
    80002e1e:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002e20:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002e24:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002e26:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002e28:	4b85                	li	s7,1
    80002e2a:	a879                	j	80002ec8 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002e2c:	4585                	li	a1,1
    80002e2e:	852e                	mv	a0,a1
    80002e30:	e6cff0ef          	jal	8000249c <iget>
    80002e34:	8a2a                	mv	s4,a0
    80002e36:	b7ed                	j	80002e20 <namex+0x3c>
      iunlockput(ip);
    80002e38:	8552                	mv	a0,s4
    80002e3a:	b6fff0ef          	jal	800029a8 <iunlockput>
      return 0;
    80002e3e:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002e40:	8552                	mv	a0,s4
    80002e42:	60e6                	ld	ra,88(sp)
    80002e44:	6446                	ld	s0,80(sp)
    80002e46:	64a6                	ld	s1,72(sp)
    80002e48:	6906                	ld	s2,64(sp)
    80002e4a:	79e2                	ld	s3,56(sp)
    80002e4c:	7a42                	ld	s4,48(sp)
    80002e4e:	7aa2                	ld	s5,40(sp)
    80002e50:	7b02                	ld	s6,32(sp)
    80002e52:	6be2                	ld	s7,24(sp)
    80002e54:	6c42                	ld	s8,16(sp)
    80002e56:	6ca2                	ld	s9,8(sp)
    80002e58:	6d02                	ld	s10,0(sp)
    80002e5a:	6125                	addi	sp,sp,96
    80002e5c:	8082                	ret
      iunlock(ip);
    80002e5e:	8552                	mv	a0,s4
    80002e60:	95dff0ef          	jal	800027bc <iunlock>
      return ip;
    80002e64:	bff1                	j	80002e40 <namex+0x5c>
      iunlockput(ip);
    80002e66:	8552                	mv	a0,s4
    80002e68:	b41ff0ef          	jal	800029a8 <iunlockput>
      return 0;
    80002e6c:	8a4a                	mv	s4,s2
    80002e6e:	bfc9                	j	80002e40 <namex+0x5c>
  len = path - s;
    80002e70:	40990633          	sub	a2,s2,s1
    80002e74:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002e78:	09ac5463          	bge	s8,s10,80002f00 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002e7c:	8666                	mv	a2,s9
    80002e7e:	85a6                	mv	a1,s1
    80002e80:	8556                	mv	a0,s5
    80002e82:	b3cfd0ef          	jal	800001be <memmove>
    80002e86:	84ca                	mv	s1,s2
  while(*path == '/')
    80002e88:	0004c783          	lbu	a5,0(s1)
    80002e8c:	01379763          	bne	a5,s3,80002e9a <namex+0xb6>
    path++;
    80002e90:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e92:	0004c783          	lbu	a5,0(s1)
    80002e96:	ff378de3          	beq	a5,s3,80002e90 <namex+0xac>
    ilock(ip);
    80002e9a:	8552                	mv	a0,s4
    80002e9c:	873ff0ef          	jal	8000270e <ilock>
    if(ip->type != T_DIR){
    80002ea0:	044a1783          	lh	a5,68(s4)
    80002ea4:	f9779ae3          	bne	a5,s7,80002e38 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002ea8:	000b0563          	beqz	s6,80002eb2 <namex+0xce>
    80002eac:	0004c783          	lbu	a5,0(s1)
    80002eb0:	d7dd                	beqz	a5,80002e5e <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002eb2:	4601                	li	a2,0
    80002eb4:	85d6                	mv	a1,s5
    80002eb6:	8552                	mv	a0,s4
    80002eb8:	e81ff0ef          	jal	80002d38 <dirlookup>
    80002ebc:	892a                	mv	s2,a0
    80002ebe:	d545                	beqz	a0,80002e66 <namex+0x82>
    iunlockput(ip);
    80002ec0:	8552                	mv	a0,s4
    80002ec2:	ae7ff0ef          	jal	800029a8 <iunlockput>
    ip = next;
    80002ec6:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002ec8:	0004c783          	lbu	a5,0(s1)
    80002ecc:	01379763          	bne	a5,s3,80002eda <namex+0xf6>
    path++;
    80002ed0:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ed2:	0004c783          	lbu	a5,0(s1)
    80002ed6:	ff378de3          	beq	a5,s3,80002ed0 <namex+0xec>
  if(*path == 0)
    80002eda:	cf8d                	beqz	a5,80002f14 <namex+0x130>
  while(*path != '/' && *path != 0)
    80002edc:	0004c783          	lbu	a5,0(s1)
    80002ee0:	fd178713          	addi	a4,a5,-47
    80002ee4:	cb19                	beqz	a4,80002efa <namex+0x116>
    80002ee6:	cb91                	beqz	a5,80002efa <namex+0x116>
    80002ee8:	8926                	mv	s2,s1
    path++;
    80002eea:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002eec:	00094783          	lbu	a5,0(s2)
    80002ef0:	fd178713          	addi	a4,a5,-47
    80002ef4:	df35                	beqz	a4,80002e70 <namex+0x8c>
    80002ef6:	fbf5                	bnez	a5,80002eea <namex+0x106>
    80002ef8:	bfa5                	j	80002e70 <namex+0x8c>
    80002efa:	8926                	mv	s2,s1
  len = path - s;
    80002efc:	4d01                	li	s10,0
    80002efe:	4601                	li	a2,0
    memmove(name, s, len);
    80002f00:	2601                	sext.w	a2,a2
    80002f02:	85a6                	mv	a1,s1
    80002f04:	8556                	mv	a0,s5
    80002f06:	ab8fd0ef          	jal	800001be <memmove>
    name[len] = 0;
    80002f0a:	9d56                	add	s10,s10,s5
    80002f0c:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffe3058>
    80002f10:	84ca                	mv	s1,s2
    80002f12:	bf9d                	j	80002e88 <namex+0xa4>
  if(nameiparent){
    80002f14:	f20b06e3          	beqz	s6,80002e40 <namex+0x5c>
    iput(ip);
    80002f18:	8552                	mv	a0,s4
    80002f1a:	a05ff0ef          	jal	8000291e <iput>
    return 0;
    80002f1e:	4a01                	li	s4,0
    80002f20:	b705                	j	80002e40 <namex+0x5c>

0000000080002f22 <dirlink>:
{
    80002f22:	715d                	addi	sp,sp,-80
    80002f24:	e486                	sd	ra,72(sp)
    80002f26:	e0a2                	sd	s0,64(sp)
    80002f28:	f84a                	sd	s2,48(sp)
    80002f2a:	ec56                	sd	s5,24(sp)
    80002f2c:	e85a                	sd	s6,16(sp)
    80002f2e:	0880                	addi	s0,sp,80
    80002f30:	892a                	mv	s2,a0
    80002f32:	8aae                	mv	s5,a1
    80002f34:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002f36:	4601                	li	a2,0
    80002f38:	e01ff0ef          	jal	80002d38 <dirlookup>
    80002f3c:	ed1d                	bnez	a0,80002f7a <dirlink+0x58>
    80002f3e:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f40:	04c92483          	lw	s1,76(s2)
    80002f44:	c4b9                	beqz	s1,80002f92 <dirlink+0x70>
    80002f46:	f44e                	sd	s3,40(sp)
    80002f48:	f052                	sd	s4,32(sp)
    80002f4a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f4c:	fb040a13          	addi	s4,s0,-80
    80002f50:	49c1                	li	s3,16
    80002f52:	874e                	mv	a4,s3
    80002f54:	86a6                	mv	a3,s1
    80002f56:	8652                	mv	a2,s4
    80002f58:	4581                	li	a1,0
    80002f5a:	854a                	mv	a0,s2
    80002f5c:	bd3ff0ef          	jal	80002b2e <readi>
    80002f60:	03351163          	bne	a0,s3,80002f82 <dirlink+0x60>
    if(de.inum == 0)
    80002f64:	fb045783          	lhu	a5,-80(s0)
    80002f68:	c39d                	beqz	a5,80002f8e <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f6a:	24c1                	addiw	s1,s1,16
    80002f6c:	04c92783          	lw	a5,76(s2)
    80002f70:	fef4e1e3          	bltu	s1,a5,80002f52 <dirlink+0x30>
    80002f74:	79a2                	ld	s3,40(sp)
    80002f76:	7a02                	ld	s4,32(sp)
    80002f78:	a829                	j	80002f92 <dirlink+0x70>
    iput(ip);
    80002f7a:	9a5ff0ef          	jal	8000291e <iput>
    return -1;
    80002f7e:	557d                	li	a0,-1
    80002f80:	a83d                	j	80002fbe <dirlink+0x9c>
      panic("dirlink read");
    80002f82:	00004517          	auipc	a0,0x4
    80002f86:	4e650513          	addi	a0,a0,1254 # 80007468 <etext+0x468>
    80002f8a:	20d020ef          	jal	80005996 <panic>
    80002f8e:	79a2                	ld	s3,40(sp)
    80002f90:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002f92:	4639                	li	a2,14
    80002f94:	85d6                	mv	a1,s5
    80002f96:	fb240513          	addi	a0,s0,-78
    80002f9a:	ad2fd0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80002f9e:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002fa2:	4741                	li	a4,16
    80002fa4:	86a6                	mv	a3,s1
    80002fa6:	fb040613          	addi	a2,s0,-80
    80002faa:	4581                	li	a1,0
    80002fac:	854a                	mv	a0,s2
    80002fae:	c73ff0ef          	jal	80002c20 <writei>
    80002fb2:	1541                	addi	a0,a0,-16
    80002fb4:	00a03533          	snez	a0,a0
    80002fb8:	40a0053b          	negw	a0,a0
    80002fbc:	74e2                	ld	s1,56(sp)
}
    80002fbe:	60a6                	ld	ra,72(sp)
    80002fc0:	6406                	ld	s0,64(sp)
    80002fc2:	7942                	ld	s2,48(sp)
    80002fc4:	6ae2                	ld	s5,24(sp)
    80002fc6:	6b42                	ld	s6,16(sp)
    80002fc8:	6161                	addi	sp,sp,80
    80002fca:	8082                	ret

0000000080002fcc <namei>:

struct inode*
namei(char *path)
{
    80002fcc:	1101                	addi	sp,sp,-32
    80002fce:	ec06                	sd	ra,24(sp)
    80002fd0:	e822                	sd	s0,16(sp)
    80002fd2:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002fd4:	fe040613          	addi	a2,s0,-32
    80002fd8:	4581                	li	a1,0
    80002fda:	e0bff0ef          	jal	80002de4 <namex>
}
    80002fde:	60e2                	ld	ra,24(sp)
    80002fe0:	6442                	ld	s0,16(sp)
    80002fe2:	6105                	addi	sp,sp,32
    80002fe4:	8082                	ret

0000000080002fe6 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002fe6:	1141                	addi	sp,sp,-16
    80002fe8:	e406                	sd	ra,8(sp)
    80002fea:	e022                	sd	s0,0(sp)
    80002fec:	0800                	addi	s0,sp,16
    80002fee:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002ff0:	4585                	li	a1,1
    80002ff2:	df3ff0ef          	jal	80002de4 <namex>
}
    80002ff6:	60a2                	ld	ra,8(sp)
    80002ff8:	6402                	ld	s0,0(sp)
    80002ffa:	0141                	addi	sp,sp,16
    80002ffc:	8082                	ret

0000000080002ffe <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002ffe:	1101                	addi	sp,sp,-32
    80003000:	ec06                	sd	ra,24(sp)
    80003002:	e822                	sd	s0,16(sp)
    80003004:	e426                	sd	s1,8(sp)
    80003006:	e04a                	sd	s2,0(sp)
    80003008:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000300a:	00010917          	auipc	s2,0x10
    8000300e:	c8690913          	addi	s2,s2,-890 # 80012c90 <log>
    80003012:	01892583          	lw	a1,24(s2)
    80003016:	02492503          	lw	a0,36(s2)
    8000301a:	fadfe0ef          	jal	80001fc6 <bread>
    8000301e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003020:	02892603          	lw	a2,40(s2)
    80003024:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003026:	00c05f63          	blez	a2,80003044 <write_head+0x46>
    8000302a:	00010717          	auipc	a4,0x10
    8000302e:	c9270713          	addi	a4,a4,-878 # 80012cbc <log+0x2c>
    80003032:	87aa                	mv	a5,a0
    80003034:	060a                	slli	a2,a2,0x2
    80003036:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003038:	4314                	lw	a3,0(a4)
    8000303a:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    8000303c:	0711                	addi	a4,a4,4
    8000303e:	0791                	addi	a5,a5,4
    80003040:	fec79ce3          	bne	a5,a2,80003038 <write_head+0x3a>
  }
  bwrite(buf);
    80003044:	8526                	mv	a0,s1
    80003046:	856ff0ef          	jal	8000209c <bwrite>
  brelse(buf);
    8000304a:	8526                	mv	a0,s1
    8000304c:	882ff0ef          	jal	800020ce <brelse>
}
    80003050:	60e2                	ld	ra,24(sp)
    80003052:	6442                	ld	s0,16(sp)
    80003054:	64a2                	ld	s1,8(sp)
    80003056:	6902                	ld	s2,0(sp)
    80003058:	6105                	addi	sp,sp,32
    8000305a:	8082                	ret

000000008000305c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000305c:	00010797          	auipc	a5,0x10
    80003060:	c5c7a783          	lw	a5,-932(a5) # 80012cb8 <log+0x28>
    80003064:	0cf05163          	blez	a5,80003126 <install_trans+0xca>
{
    80003068:	715d                	addi	sp,sp,-80
    8000306a:	e486                	sd	ra,72(sp)
    8000306c:	e0a2                	sd	s0,64(sp)
    8000306e:	fc26                	sd	s1,56(sp)
    80003070:	f84a                	sd	s2,48(sp)
    80003072:	f44e                	sd	s3,40(sp)
    80003074:	f052                	sd	s4,32(sp)
    80003076:	ec56                	sd	s5,24(sp)
    80003078:	e85a                	sd	s6,16(sp)
    8000307a:	e45e                	sd	s7,8(sp)
    8000307c:	e062                	sd	s8,0(sp)
    8000307e:	0880                	addi	s0,sp,80
    80003080:	8b2a                	mv	s6,a0
    80003082:	00010a97          	auipc	s5,0x10
    80003086:	c3aa8a93          	addi	s5,s5,-966 # 80012cbc <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000308a:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000308c:	00004c17          	auipc	s8,0x4
    80003090:	3ecc0c13          	addi	s8,s8,1004 # 80007478 <etext+0x478>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003094:	00010a17          	auipc	s4,0x10
    80003098:	bfca0a13          	addi	s4,s4,-1028 # 80012c90 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000309c:	40000b93          	li	s7,1024
    800030a0:	a025                	j	800030c8 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800030a2:	000aa603          	lw	a2,0(s5)
    800030a6:	85ce                	mv	a1,s3
    800030a8:	8562                	mv	a0,s8
    800030aa:	5c2020ef          	jal	8000566c <printf>
    800030ae:	a839                	j	800030cc <install_trans+0x70>
    brelse(lbuf);
    800030b0:	854a                	mv	a0,s2
    800030b2:	81cff0ef          	jal	800020ce <brelse>
    brelse(dbuf);
    800030b6:	8526                	mv	a0,s1
    800030b8:	816ff0ef          	jal	800020ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800030bc:	2985                	addiw	s3,s3,1
    800030be:	0a91                	addi	s5,s5,4
    800030c0:	028a2783          	lw	a5,40(s4)
    800030c4:	04f9d563          	bge	s3,a5,8000310e <install_trans+0xb2>
    if(recovering) {
    800030c8:	fc0b1de3          	bnez	s6,800030a2 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800030cc:	018a2583          	lw	a1,24(s4)
    800030d0:	013585bb          	addw	a1,a1,s3
    800030d4:	2585                	addiw	a1,a1,1
    800030d6:	024a2503          	lw	a0,36(s4)
    800030da:	eedfe0ef          	jal	80001fc6 <bread>
    800030de:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800030e0:	000aa583          	lw	a1,0(s5)
    800030e4:	024a2503          	lw	a0,36(s4)
    800030e8:	edffe0ef          	jal	80001fc6 <bread>
    800030ec:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800030ee:	865e                	mv	a2,s7
    800030f0:	05890593          	addi	a1,s2,88
    800030f4:	05850513          	addi	a0,a0,88
    800030f8:	8c6fd0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    800030fc:	8526                	mv	a0,s1
    800030fe:	f9ffe0ef          	jal	8000209c <bwrite>
    if(recovering == 0)
    80003102:	fa0b17e3          	bnez	s6,800030b0 <install_trans+0x54>
      bunpin(dbuf);
    80003106:	8526                	mv	a0,s1
    80003108:	87eff0ef          	jal	80002186 <bunpin>
    8000310c:	b755                	j	800030b0 <install_trans+0x54>
}
    8000310e:	60a6                	ld	ra,72(sp)
    80003110:	6406                	ld	s0,64(sp)
    80003112:	74e2                	ld	s1,56(sp)
    80003114:	7942                	ld	s2,48(sp)
    80003116:	79a2                	ld	s3,40(sp)
    80003118:	7a02                	ld	s4,32(sp)
    8000311a:	6ae2                	ld	s5,24(sp)
    8000311c:	6b42                	ld	s6,16(sp)
    8000311e:	6ba2                	ld	s7,8(sp)
    80003120:	6c02                	ld	s8,0(sp)
    80003122:	6161                	addi	sp,sp,80
    80003124:	8082                	ret
    80003126:	8082                	ret

0000000080003128 <initlog>:
{
    80003128:	7179                	addi	sp,sp,-48
    8000312a:	f406                	sd	ra,40(sp)
    8000312c:	f022                	sd	s0,32(sp)
    8000312e:	ec26                	sd	s1,24(sp)
    80003130:	e84a                	sd	s2,16(sp)
    80003132:	e44e                	sd	s3,8(sp)
    80003134:	1800                	addi	s0,sp,48
    80003136:	84aa                	mv	s1,a0
    80003138:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000313a:	00010917          	auipc	s2,0x10
    8000313e:	b5690913          	addi	s2,s2,-1194 # 80012c90 <log>
    80003142:	00004597          	auipc	a1,0x4
    80003146:	35658593          	addi	a1,a1,854 # 80007498 <etext+0x498>
    8000314a:	854a                	mv	a0,s2
    8000314c:	283020ef          	jal	80005bce <initlock>
  log.start = sb->logstart;
    80003150:	0149a583          	lw	a1,20(s3)
    80003154:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003158:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    8000315c:	8526                	mv	a0,s1
    8000315e:	e69fe0ef          	jal	80001fc6 <bread>
  log.lh.n = lh->n;
    80003162:	4d30                	lw	a2,88(a0)
    80003164:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003168:	00c05f63          	blez	a2,80003186 <initlog+0x5e>
    8000316c:	87aa                	mv	a5,a0
    8000316e:	00010717          	auipc	a4,0x10
    80003172:	b4e70713          	addi	a4,a4,-1202 # 80012cbc <log+0x2c>
    80003176:	060a                	slli	a2,a2,0x2
    80003178:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    8000317a:	4ff4                	lw	a3,92(a5)
    8000317c:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000317e:	0791                	addi	a5,a5,4
    80003180:	0711                	addi	a4,a4,4
    80003182:	fec79ce3          	bne	a5,a2,8000317a <initlog+0x52>
  brelse(buf);
    80003186:	f49fe0ef          	jal	800020ce <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000318a:	4505                	li	a0,1
    8000318c:	ed1ff0ef          	jal	8000305c <install_trans>
  log.lh.n = 0;
    80003190:	00010797          	auipc	a5,0x10
    80003194:	b207a423          	sw	zero,-1240(a5) # 80012cb8 <log+0x28>
  write_head(); // clear the log
    80003198:	e67ff0ef          	jal	80002ffe <write_head>
}
    8000319c:	70a2                	ld	ra,40(sp)
    8000319e:	7402                	ld	s0,32(sp)
    800031a0:	64e2                	ld	s1,24(sp)
    800031a2:	6942                	ld	s2,16(sp)
    800031a4:	69a2                	ld	s3,8(sp)
    800031a6:	6145                	addi	sp,sp,48
    800031a8:	8082                	ret

00000000800031aa <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800031aa:	1101                	addi	sp,sp,-32
    800031ac:	ec06                	sd	ra,24(sp)
    800031ae:	e822                	sd	s0,16(sp)
    800031b0:	e426                	sd	s1,8(sp)
    800031b2:	e04a                	sd	s2,0(sp)
    800031b4:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800031b6:	00010517          	auipc	a0,0x10
    800031ba:	ada50513          	addi	a0,a0,-1318 # 80012c90 <log>
    800031be:	29b020ef          	jal	80005c58 <acquire>
  while(1){
    if(log.committing){
    800031c2:	00010497          	auipc	s1,0x10
    800031c6:	ace48493          	addi	s1,s1,-1330 # 80012c90 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800031ca:	4979                	li	s2,30
    800031cc:	a029                	j	800031d6 <begin_op+0x2c>
      sleep(&log, &log.lock);
    800031ce:	85a6                	mv	a1,s1
    800031d0:	8526                	mv	a0,s1
    800031d2:	9c8fe0ef          	jal	8000139a <sleep>
    if(log.committing){
    800031d6:	509c                	lw	a5,32(s1)
    800031d8:	fbfd                	bnez	a5,800031ce <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800031da:	4cd8                	lw	a4,28(s1)
    800031dc:	2705                	addiw	a4,a4,1
    800031de:	0027179b          	slliw	a5,a4,0x2
    800031e2:	9fb9                	addw	a5,a5,a4
    800031e4:	0017979b          	slliw	a5,a5,0x1
    800031e8:	5494                	lw	a3,40(s1)
    800031ea:	9fb5                	addw	a5,a5,a3
    800031ec:	00f95763          	bge	s2,a5,800031fa <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800031f0:	85a6                	mv	a1,s1
    800031f2:	8526                	mv	a0,s1
    800031f4:	9a6fe0ef          	jal	8000139a <sleep>
    800031f8:	bff9                	j	800031d6 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800031fa:	00010797          	auipc	a5,0x10
    800031fe:	aae7a923          	sw	a4,-1358(a5) # 80012cac <log+0x1c>
      release(&log.lock);
    80003202:	00010517          	auipc	a0,0x10
    80003206:	a8e50513          	addi	a0,a0,-1394 # 80012c90 <log>
    8000320a:	2e3020ef          	jal	80005cec <release>
      break;
    }
  }
}
    8000320e:	60e2                	ld	ra,24(sp)
    80003210:	6442                	ld	s0,16(sp)
    80003212:	64a2                	ld	s1,8(sp)
    80003214:	6902                	ld	s2,0(sp)
    80003216:	6105                	addi	sp,sp,32
    80003218:	8082                	ret

000000008000321a <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000321a:	7139                	addi	sp,sp,-64
    8000321c:	fc06                	sd	ra,56(sp)
    8000321e:	f822                	sd	s0,48(sp)
    80003220:	f426                	sd	s1,40(sp)
    80003222:	f04a                	sd	s2,32(sp)
    80003224:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003226:	00010497          	auipc	s1,0x10
    8000322a:	a6a48493          	addi	s1,s1,-1430 # 80012c90 <log>
    8000322e:	8526                	mv	a0,s1
    80003230:	229020ef          	jal	80005c58 <acquire>
  log.outstanding -= 1;
    80003234:	4cdc                	lw	a5,28(s1)
    80003236:	37fd                	addiw	a5,a5,-1
    80003238:	893e                	mv	s2,a5
    8000323a:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    8000323c:	509c                	lw	a5,32(s1)
    8000323e:	e7b1                	bnez	a5,8000328a <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003240:	04091e63          	bnez	s2,8000329c <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003244:	00010497          	auipc	s1,0x10
    80003248:	a4c48493          	addi	s1,s1,-1460 # 80012c90 <log>
    8000324c:	4785                	li	a5,1
    8000324e:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003250:	8526                	mv	a0,s1
    80003252:	29b020ef          	jal	80005cec <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003256:	549c                	lw	a5,40(s1)
    80003258:	06f04463          	bgtz	a5,800032c0 <end_op+0xa6>
    acquire(&log.lock);
    8000325c:	00010517          	auipc	a0,0x10
    80003260:	a3450513          	addi	a0,a0,-1484 # 80012c90 <log>
    80003264:	1f5020ef          	jal	80005c58 <acquire>
    log.committing = 0;
    80003268:	00010797          	auipc	a5,0x10
    8000326c:	a407a423          	sw	zero,-1464(a5) # 80012cb0 <log+0x20>
    wakeup(&log);
    80003270:	00010517          	auipc	a0,0x10
    80003274:	a2050513          	addi	a0,a0,-1504 # 80012c90 <log>
    80003278:	96efe0ef          	jal	800013e6 <wakeup>
    release(&log.lock);
    8000327c:	00010517          	auipc	a0,0x10
    80003280:	a1450513          	addi	a0,a0,-1516 # 80012c90 <log>
    80003284:	269020ef          	jal	80005cec <release>
}
    80003288:	a035                	j	800032b4 <end_op+0x9a>
    8000328a:	ec4e                	sd	s3,24(sp)
    8000328c:	e852                	sd	s4,16(sp)
    8000328e:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003290:	00004517          	auipc	a0,0x4
    80003294:	21050513          	addi	a0,a0,528 # 800074a0 <etext+0x4a0>
    80003298:	6fe020ef          	jal	80005996 <panic>
    wakeup(&log);
    8000329c:	00010517          	auipc	a0,0x10
    800032a0:	9f450513          	addi	a0,a0,-1548 # 80012c90 <log>
    800032a4:	942fe0ef          	jal	800013e6 <wakeup>
  release(&log.lock);
    800032a8:	00010517          	auipc	a0,0x10
    800032ac:	9e850513          	addi	a0,a0,-1560 # 80012c90 <log>
    800032b0:	23d020ef          	jal	80005cec <release>
}
    800032b4:	70e2                	ld	ra,56(sp)
    800032b6:	7442                	ld	s0,48(sp)
    800032b8:	74a2                	ld	s1,40(sp)
    800032ba:	7902                	ld	s2,32(sp)
    800032bc:	6121                	addi	sp,sp,64
    800032be:	8082                	ret
    800032c0:	ec4e                	sd	s3,24(sp)
    800032c2:	e852                	sd	s4,16(sp)
    800032c4:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800032c6:	00010a97          	auipc	s5,0x10
    800032ca:	9f6a8a93          	addi	s5,s5,-1546 # 80012cbc <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800032ce:	00010a17          	auipc	s4,0x10
    800032d2:	9c2a0a13          	addi	s4,s4,-1598 # 80012c90 <log>
    800032d6:	018a2583          	lw	a1,24(s4)
    800032da:	012585bb          	addw	a1,a1,s2
    800032de:	2585                	addiw	a1,a1,1
    800032e0:	024a2503          	lw	a0,36(s4)
    800032e4:	ce3fe0ef          	jal	80001fc6 <bread>
    800032e8:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800032ea:	000aa583          	lw	a1,0(s5)
    800032ee:	024a2503          	lw	a0,36(s4)
    800032f2:	cd5fe0ef          	jal	80001fc6 <bread>
    800032f6:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800032f8:	40000613          	li	a2,1024
    800032fc:	05850593          	addi	a1,a0,88
    80003300:	05848513          	addi	a0,s1,88
    80003304:	ebbfc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    80003308:	8526                	mv	a0,s1
    8000330a:	d93fe0ef          	jal	8000209c <bwrite>
    brelse(from);
    8000330e:	854e                	mv	a0,s3
    80003310:	dbffe0ef          	jal	800020ce <brelse>
    brelse(to);
    80003314:	8526                	mv	a0,s1
    80003316:	db9fe0ef          	jal	800020ce <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000331a:	2905                	addiw	s2,s2,1
    8000331c:	0a91                	addi	s5,s5,4
    8000331e:	028a2783          	lw	a5,40(s4)
    80003322:	faf94ae3          	blt	s2,a5,800032d6 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003326:	cd9ff0ef          	jal	80002ffe <write_head>
    install_trans(0); // Now install writes to home locations
    8000332a:	4501                	li	a0,0
    8000332c:	d31ff0ef          	jal	8000305c <install_trans>
    log.lh.n = 0;
    80003330:	00010797          	auipc	a5,0x10
    80003334:	9807a423          	sw	zero,-1656(a5) # 80012cb8 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003338:	cc7ff0ef          	jal	80002ffe <write_head>
    8000333c:	69e2                	ld	s3,24(sp)
    8000333e:	6a42                	ld	s4,16(sp)
    80003340:	6aa2                	ld	s5,8(sp)
    80003342:	bf29                	j	8000325c <end_op+0x42>

0000000080003344 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003344:	1101                	addi	sp,sp,-32
    80003346:	ec06                	sd	ra,24(sp)
    80003348:	e822                	sd	s0,16(sp)
    8000334a:	e426                	sd	s1,8(sp)
    8000334c:	1000                	addi	s0,sp,32
    8000334e:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003350:	00010517          	auipc	a0,0x10
    80003354:	94050513          	addi	a0,a0,-1728 # 80012c90 <log>
    80003358:	101020ef          	jal	80005c58 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    8000335c:	00010617          	auipc	a2,0x10
    80003360:	95c62603          	lw	a2,-1700(a2) # 80012cb8 <log+0x28>
    80003364:	47f5                	li	a5,29
    80003366:	04c7cd63          	blt	a5,a2,800033c0 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000336a:	00010797          	auipc	a5,0x10
    8000336e:	9427a783          	lw	a5,-1726(a5) # 80012cac <log+0x1c>
    80003372:	04f05d63          	blez	a5,800033cc <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003376:	4781                	li	a5,0
    80003378:	06c05063          	blez	a2,800033d8 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000337c:	44cc                	lw	a1,12(s1)
    8000337e:	00010717          	auipc	a4,0x10
    80003382:	93e70713          	addi	a4,a4,-1730 # 80012cbc <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003386:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003388:	4314                	lw	a3,0(a4)
    8000338a:	04b68763          	beq	a3,a1,800033d8 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    8000338e:	2785                	addiw	a5,a5,1
    80003390:	0711                	addi	a4,a4,4
    80003392:	fef61be3          	bne	a2,a5,80003388 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003396:	060a                	slli	a2,a2,0x2
    80003398:	02060613          	addi	a2,a2,32
    8000339c:	00010797          	auipc	a5,0x10
    800033a0:	8f478793          	addi	a5,a5,-1804 # 80012c90 <log>
    800033a4:	97b2                	add	a5,a5,a2
    800033a6:	44d8                	lw	a4,12(s1)
    800033a8:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800033aa:	8526                	mv	a0,s1
    800033ac:	da7fe0ef          	jal	80002152 <bpin>
    log.lh.n++;
    800033b0:	00010717          	auipc	a4,0x10
    800033b4:	8e070713          	addi	a4,a4,-1824 # 80012c90 <log>
    800033b8:	571c                	lw	a5,40(a4)
    800033ba:	2785                	addiw	a5,a5,1
    800033bc:	d71c                	sw	a5,40(a4)
    800033be:	a815                	j	800033f2 <log_write+0xae>
    panic("too big a transaction");
    800033c0:	00004517          	auipc	a0,0x4
    800033c4:	0f050513          	addi	a0,a0,240 # 800074b0 <etext+0x4b0>
    800033c8:	5ce020ef          	jal	80005996 <panic>
    panic("log_write outside of trans");
    800033cc:	00004517          	auipc	a0,0x4
    800033d0:	0fc50513          	addi	a0,a0,252 # 800074c8 <etext+0x4c8>
    800033d4:	5c2020ef          	jal	80005996 <panic>
  log.lh.block[i] = b->blockno;
    800033d8:	00279693          	slli	a3,a5,0x2
    800033dc:	02068693          	addi	a3,a3,32
    800033e0:	00010717          	auipc	a4,0x10
    800033e4:	8b070713          	addi	a4,a4,-1872 # 80012c90 <log>
    800033e8:	9736                	add	a4,a4,a3
    800033ea:	44d4                	lw	a3,12(s1)
    800033ec:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800033ee:	faf60ee3          	beq	a2,a5,800033aa <log_write+0x66>
  }
  release(&log.lock);
    800033f2:	00010517          	auipc	a0,0x10
    800033f6:	89e50513          	addi	a0,a0,-1890 # 80012c90 <log>
    800033fa:	0f3020ef          	jal	80005cec <release>
}
    800033fe:	60e2                	ld	ra,24(sp)
    80003400:	6442                	ld	s0,16(sp)
    80003402:	64a2                	ld	s1,8(sp)
    80003404:	6105                	addi	sp,sp,32
    80003406:	8082                	ret

0000000080003408 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003408:	1101                	addi	sp,sp,-32
    8000340a:	ec06                	sd	ra,24(sp)
    8000340c:	e822                	sd	s0,16(sp)
    8000340e:	e426                	sd	s1,8(sp)
    80003410:	e04a                	sd	s2,0(sp)
    80003412:	1000                	addi	s0,sp,32
    80003414:	84aa                	mv	s1,a0
    80003416:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003418:	00004597          	auipc	a1,0x4
    8000341c:	0d058593          	addi	a1,a1,208 # 800074e8 <etext+0x4e8>
    80003420:	0521                	addi	a0,a0,8
    80003422:	7ac020ef          	jal	80005bce <initlock>
  lk->name = name;
    80003426:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000342a:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000342e:	0204a423          	sw	zero,40(s1)
}
    80003432:	60e2                	ld	ra,24(sp)
    80003434:	6442                	ld	s0,16(sp)
    80003436:	64a2                	ld	s1,8(sp)
    80003438:	6902                	ld	s2,0(sp)
    8000343a:	6105                	addi	sp,sp,32
    8000343c:	8082                	ret

000000008000343e <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000343e:	1101                	addi	sp,sp,-32
    80003440:	ec06                	sd	ra,24(sp)
    80003442:	e822                	sd	s0,16(sp)
    80003444:	e426                	sd	s1,8(sp)
    80003446:	e04a                	sd	s2,0(sp)
    80003448:	1000                	addi	s0,sp,32
    8000344a:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000344c:	00850913          	addi	s2,a0,8
    80003450:	854a                	mv	a0,s2
    80003452:	007020ef          	jal	80005c58 <acquire>
  while (lk->locked) {
    80003456:	409c                	lw	a5,0(s1)
    80003458:	c799                	beqz	a5,80003466 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000345a:	85ca                	mv	a1,s2
    8000345c:	8526                	mv	a0,s1
    8000345e:	f3dfd0ef          	jal	8000139a <sleep>
  while (lk->locked) {
    80003462:	409c                	lw	a5,0(s1)
    80003464:	fbfd                	bnez	a5,8000345a <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003466:	4785                	li	a5,1
    80003468:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000346a:	92bfd0ef          	jal	80000d94 <myproc>
    8000346e:	591c                	lw	a5,48(a0)
    80003470:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003472:	854a                	mv	a0,s2
    80003474:	079020ef          	jal	80005cec <release>
}
    80003478:	60e2                	ld	ra,24(sp)
    8000347a:	6442                	ld	s0,16(sp)
    8000347c:	64a2                	ld	s1,8(sp)
    8000347e:	6902                	ld	s2,0(sp)
    80003480:	6105                	addi	sp,sp,32
    80003482:	8082                	ret

0000000080003484 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003484:	1101                	addi	sp,sp,-32
    80003486:	ec06                	sd	ra,24(sp)
    80003488:	e822                	sd	s0,16(sp)
    8000348a:	e426                	sd	s1,8(sp)
    8000348c:	e04a                	sd	s2,0(sp)
    8000348e:	1000                	addi	s0,sp,32
    80003490:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003492:	00850913          	addi	s2,a0,8
    80003496:	854a                	mv	a0,s2
    80003498:	7c0020ef          	jal	80005c58 <acquire>
  lk->locked = 0;
    8000349c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800034a0:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800034a4:	8526                	mv	a0,s1
    800034a6:	f41fd0ef          	jal	800013e6 <wakeup>
  release(&lk->lk);
    800034aa:	854a                	mv	a0,s2
    800034ac:	041020ef          	jal	80005cec <release>
}
    800034b0:	60e2                	ld	ra,24(sp)
    800034b2:	6442                	ld	s0,16(sp)
    800034b4:	64a2                	ld	s1,8(sp)
    800034b6:	6902                	ld	s2,0(sp)
    800034b8:	6105                	addi	sp,sp,32
    800034ba:	8082                	ret

00000000800034bc <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800034bc:	7179                	addi	sp,sp,-48
    800034be:	f406                	sd	ra,40(sp)
    800034c0:	f022                	sd	s0,32(sp)
    800034c2:	ec26                	sd	s1,24(sp)
    800034c4:	e84a                	sd	s2,16(sp)
    800034c6:	1800                	addi	s0,sp,48
    800034c8:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800034ca:	00850913          	addi	s2,a0,8
    800034ce:	854a                	mv	a0,s2
    800034d0:	788020ef          	jal	80005c58 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800034d4:	409c                	lw	a5,0(s1)
    800034d6:	ef81                	bnez	a5,800034ee <holdingsleep+0x32>
    800034d8:	4481                	li	s1,0
  release(&lk->lk);
    800034da:	854a                	mv	a0,s2
    800034dc:	011020ef          	jal	80005cec <release>
  return r;
}
    800034e0:	8526                	mv	a0,s1
    800034e2:	70a2                	ld	ra,40(sp)
    800034e4:	7402                	ld	s0,32(sp)
    800034e6:	64e2                	ld	s1,24(sp)
    800034e8:	6942                	ld	s2,16(sp)
    800034ea:	6145                	addi	sp,sp,48
    800034ec:	8082                	ret
    800034ee:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800034f0:	0284a983          	lw	s3,40(s1)
    800034f4:	8a1fd0ef          	jal	80000d94 <myproc>
    800034f8:	5904                	lw	s1,48(a0)
    800034fa:	413484b3          	sub	s1,s1,s3
    800034fe:	0014b493          	seqz	s1,s1
    80003502:	69a2                	ld	s3,8(sp)
    80003504:	bfd9                	j	800034da <holdingsleep+0x1e>

0000000080003506 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003506:	1141                	addi	sp,sp,-16
    80003508:	e406                	sd	ra,8(sp)
    8000350a:	e022                	sd	s0,0(sp)
    8000350c:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    8000350e:	00004597          	auipc	a1,0x4
    80003512:	fea58593          	addi	a1,a1,-22 # 800074f8 <etext+0x4f8>
    80003516:	00010517          	auipc	a0,0x10
    8000351a:	8c250513          	addi	a0,a0,-1854 # 80012dd8 <ftable>
    8000351e:	6b0020ef          	jal	80005bce <initlock>
}
    80003522:	60a2                	ld	ra,8(sp)
    80003524:	6402                	ld	s0,0(sp)
    80003526:	0141                	addi	sp,sp,16
    80003528:	8082                	ret

000000008000352a <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    8000352a:	1101                	addi	sp,sp,-32
    8000352c:	ec06                	sd	ra,24(sp)
    8000352e:	e822                	sd	s0,16(sp)
    80003530:	e426                	sd	s1,8(sp)
    80003532:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003534:	00010517          	auipc	a0,0x10
    80003538:	8a450513          	addi	a0,a0,-1884 # 80012dd8 <ftable>
    8000353c:	71c020ef          	jal	80005c58 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003540:	00010497          	auipc	s1,0x10
    80003544:	8b048493          	addi	s1,s1,-1872 # 80012df0 <ftable+0x18>
    80003548:	00011717          	auipc	a4,0x11
    8000354c:	84870713          	addi	a4,a4,-1976 # 80013d90 <disk>
    if(f->ref == 0){
    80003550:	40dc                	lw	a5,4(s1)
    80003552:	cf89                	beqz	a5,8000356c <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003554:	02848493          	addi	s1,s1,40
    80003558:	fee49ce3          	bne	s1,a4,80003550 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    8000355c:	00010517          	auipc	a0,0x10
    80003560:	87c50513          	addi	a0,a0,-1924 # 80012dd8 <ftable>
    80003564:	788020ef          	jal	80005cec <release>
  return 0;
    80003568:	4481                	li	s1,0
    8000356a:	a809                	j	8000357c <filealloc+0x52>
      f->ref = 1;
    8000356c:	4785                	li	a5,1
    8000356e:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003570:	00010517          	auipc	a0,0x10
    80003574:	86850513          	addi	a0,a0,-1944 # 80012dd8 <ftable>
    80003578:	774020ef          	jal	80005cec <release>
}
    8000357c:	8526                	mv	a0,s1
    8000357e:	60e2                	ld	ra,24(sp)
    80003580:	6442                	ld	s0,16(sp)
    80003582:	64a2                	ld	s1,8(sp)
    80003584:	6105                	addi	sp,sp,32
    80003586:	8082                	ret

0000000080003588 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003588:	1101                	addi	sp,sp,-32
    8000358a:	ec06                	sd	ra,24(sp)
    8000358c:	e822                	sd	s0,16(sp)
    8000358e:	e426                	sd	s1,8(sp)
    80003590:	1000                	addi	s0,sp,32
    80003592:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003594:	00010517          	auipc	a0,0x10
    80003598:	84450513          	addi	a0,a0,-1980 # 80012dd8 <ftable>
    8000359c:	6bc020ef          	jal	80005c58 <acquire>
  if(f->ref < 1)
    800035a0:	40dc                	lw	a5,4(s1)
    800035a2:	02f05063          	blez	a5,800035c2 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    800035a6:	2785                	addiw	a5,a5,1
    800035a8:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    800035aa:	00010517          	auipc	a0,0x10
    800035ae:	82e50513          	addi	a0,a0,-2002 # 80012dd8 <ftable>
    800035b2:	73a020ef          	jal	80005cec <release>
  return f;
}
    800035b6:	8526                	mv	a0,s1
    800035b8:	60e2                	ld	ra,24(sp)
    800035ba:	6442                	ld	s0,16(sp)
    800035bc:	64a2                	ld	s1,8(sp)
    800035be:	6105                	addi	sp,sp,32
    800035c0:	8082                	ret
    panic("filedup");
    800035c2:	00004517          	auipc	a0,0x4
    800035c6:	f3e50513          	addi	a0,a0,-194 # 80007500 <etext+0x500>
    800035ca:	3cc020ef          	jal	80005996 <panic>

00000000800035ce <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    800035ce:	7139                	addi	sp,sp,-64
    800035d0:	fc06                	sd	ra,56(sp)
    800035d2:	f822                	sd	s0,48(sp)
    800035d4:	f426                	sd	s1,40(sp)
    800035d6:	0080                	addi	s0,sp,64
    800035d8:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    800035da:	0000f517          	auipc	a0,0xf
    800035de:	7fe50513          	addi	a0,a0,2046 # 80012dd8 <ftable>
    800035e2:	676020ef          	jal	80005c58 <acquire>
  if(f->ref < 1)
    800035e6:	40dc                	lw	a5,4(s1)
    800035e8:	04f05a63          	blez	a5,8000363c <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800035ec:	37fd                	addiw	a5,a5,-1
    800035ee:	c0dc                	sw	a5,4(s1)
    800035f0:	06f04063          	bgtz	a5,80003650 <fileclose+0x82>
    800035f4:	f04a                	sd	s2,32(sp)
    800035f6:	ec4e                	sd	s3,24(sp)
    800035f8:	e852                	sd	s4,16(sp)
    800035fa:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800035fc:	0004a903          	lw	s2,0(s1)
    80003600:	0094c783          	lbu	a5,9(s1)
    80003604:	89be                	mv	s3,a5
    80003606:	689c                	ld	a5,16(s1)
    80003608:	8a3e                	mv	s4,a5
    8000360a:	6c9c                	ld	a5,24(s1)
    8000360c:	8abe                	mv	s5,a5
  f->ref = 0;
    8000360e:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003612:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003616:	0000f517          	auipc	a0,0xf
    8000361a:	7c250513          	addi	a0,a0,1986 # 80012dd8 <ftable>
    8000361e:	6ce020ef          	jal	80005cec <release>

  if(ff.type == FD_PIPE){
    80003622:	4785                	li	a5,1
    80003624:	04f90163          	beq	s2,a5,80003666 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003628:	ffe9079b          	addiw	a5,s2,-2
    8000362c:	4705                	li	a4,1
    8000362e:	04f77563          	bgeu	a4,a5,80003678 <fileclose+0xaa>
    80003632:	7902                	ld	s2,32(sp)
    80003634:	69e2                	ld	s3,24(sp)
    80003636:	6a42                	ld	s4,16(sp)
    80003638:	6aa2                	ld	s5,8(sp)
    8000363a:	a00d                	j	8000365c <fileclose+0x8e>
    8000363c:	f04a                	sd	s2,32(sp)
    8000363e:	ec4e                	sd	s3,24(sp)
    80003640:	e852                	sd	s4,16(sp)
    80003642:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003644:	00004517          	auipc	a0,0x4
    80003648:	ec450513          	addi	a0,a0,-316 # 80007508 <etext+0x508>
    8000364c:	34a020ef          	jal	80005996 <panic>
    release(&ftable.lock);
    80003650:	0000f517          	auipc	a0,0xf
    80003654:	78850513          	addi	a0,a0,1928 # 80012dd8 <ftable>
    80003658:	694020ef          	jal	80005cec <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    8000365c:	70e2                	ld	ra,56(sp)
    8000365e:	7442                	ld	s0,48(sp)
    80003660:	74a2                	ld	s1,40(sp)
    80003662:	6121                	addi	sp,sp,64
    80003664:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003666:	85ce                	mv	a1,s3
    80003668:	8552                	mv	a0,s4
    8000366a:	348000ef          	jal	800039b2 <pipeclose>
    8000366e:	7902                	ld	s2,32(sp)
    80003670:	69e2                	ld	s3,24(sp)
    80003672:	6a42                	ld	s4,16(sp)
    80003674:	6aa2                	ld	s5,8(sp)
    80003676:	b7dd                	j	8000365c <fileclose+0x8e>
    begin_op();
    80003678:	b33ff0ef          	jal	800031aa <begin_op>
    iput(ff.ip);
    8000367c:	8556                	mv	a0,s5
    8000367e:	aa0ff0ef          	jal	8000291e <iput>
    end_op();
    80003682:	b99ff0ef          	jal	8000321a <end_op>
    80003686:	7902                	ld	s2,32(sp)
    80003688:	69e2                	ld	s3,24(sp)
    8000368a:	6a42                	ld	s4,16(sp)
    8000368c:	6aa2                	ld	s5,8(sp)
    8000368e:	b7f9                	j	8000365c <fileclose+0x8e>

0000000080003690 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003690:	715d                	addi	sp,sp,-80
    80003692:	e486                	sd	ra,72(sp)
    80003694:	e0a2                	sd	s0,64(sp)
    80003696:	fc26                	sd	s1,56(sp)
    80003698:	f052                	sd	s4,32(sp)
    8000369a:	0880                	addi	s0,sp,80
    8000369c:	84aa                	mv	s1,a0
    8000369e:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    800036a0:	ef4fd0ef          	jal	80000d94 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    800036a4:	409c                	lw	a5,0(s1)
    800036a6:	37f9                	addiw	a5,a5,-2
    800036a8:	4705                	li	a4,1
    800036aa:	04f76263          	bltu	a4,a5,800036ee <filestat+0x5e>
    800036ae:	f84a                	sd	s2,48(sp)
    800036b0:	f44e                	sd	s3,40(sp)
    800036b2:	89aa                	mv	s3,a0
    ilock(f->ip);
    800036b4:	6c88                	ld	a0,24(s1)
    800036b6:	858ff0ef          	jal	8000270e <ilock>
    stati(f->ip, &st);
    800036ba:	fb840913          	addi	s2,s0,-72
    800036be:	85ca                	mv	a1,s2
    800036c0:	6c88                	ld	a0,24(s1)
    800036c2:	c3eff0ef          	jal	80002b00 <stati>
    iunlock(f->ip);
    800036c6:	6c88                	ld	a0,24(s1)
    800036c8:	8f4ff0ef          	jal	800027bc <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    800036cc:	46e1                	li	a3,24
    800036ce:	864a                	mv	a2,s2
    800036d0:	85d2                	mv	a1,s4
    800036d2:	0509b503          	ld	a0,80(s3)
    800036d6:	be4fd0ef          	jal	80000aba <copyout>
    800036da:	41f5551b          	sraiw	a0,a0,0x1f
    800036de:	7942                	ld	s2,48(sp)
    800036e0:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    800036e2:	60a6                	ld	ra,72(sp)
    800036e4:	6406                	ld	s0,64(sp)
    800036e6:	74e2                	ld	s1,56(sp)
    800036e8:	7a02                	ld	s4,32(sp)
    800036ea:	6161                	addi	sp,sp,80
    800036ec:	8082                	ret
  return -1;
    800036ee:	557d                	li	a0,-1
    800036f0:	bfcd                	j	800036e2 <filestat+0x52>

00000000800036f2 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800036f2:	7179                	addi	sp,sp,-48
    800036f4:	f406                	sd	ra,40(sp)
    800036f6:	f022                	sd	s0,32(sp)
    800036f8:	e84a                	sd	s2,16(sp)
    800036fa:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800036fc:	00854783          	lbu	a5,8(a0)
    80003700:	cfd1                	beqz	a5,8000379c <fileread+0xaa>
    80003702:	ec26                	sd	s1,24(sp)
    80003704:	e44e                	sd	s3,8(sp)
    80003706:	84aa                	mv	s1,a0
    80003708:	892e                	mv	s2,a1
    8000370a:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    8000370c:	411c                	lw	a5,0(a0)
    8000370e:	4705                	li	a4,1
    80003710:	04e78363          	beq	a5,a4,80003756 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003714:	470d                	li	a4,3
    80003716:	04e78763          	beq	a5,a4,80003764 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    8000371a:	4709                	li	a4,2
    8000371c:	06e79a63          	bne	a5,a4,80003790 <fileread+0x9e>
    ilock(f->ip);
    80003720:	6d08                	ld	a0,24(a0)
    80003722:	fedfe0ef          	jal	8000270e <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003726:	874e                	mv	a4,s3
    80003728:	5094                	lw	a3,32(s1)
    8000372a:	864a                	mv	a2,s2
    8000372c:	4585                	li	a1,1
    8000372e:	6c88                	ld	a0,24(s1)
    80003730:	bfeff0ef          	jal	80002b2e <readi>
    80003734:	892a                	mv	s2,a0
    80003736:	00a05563          	blez	a0,80003740 <fileread+0x4e>
      f->off += r;
    8000373a:	509c                	lw	a5,32(s1)
    8000373c:	9fa9                	addw	a5,a5,a0
    8000373e:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003740:	6c88                	ld	a0,24(s1)
    80003742:	87aff0ef          	jal	800027bc <iunlock>
    80003746:	64e2                	ld	s1,24(sp)
    80003748:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    8000374a:	854a                	mv	a0,s2
    8000374c:	70a2                	ld	ra,40(sp)
    8000374e:	7402                	ld	s0,32(sp)
    80003750:	6942                	ld	s2,16(sp)
    80003752:	6145                	addi	sp,sp,48
    80003754:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003756:	6908                	ld	a0,16(a0)
    80003758:	3b0000ef          	jal	80003b08 <piperead>
    8000375c:	892a                	mv	s2,a0
    8000375e:	64e2                	ld	s1,24(sp)
    80003760:	69a2                	ld	s3,8(sp)
    80003762:	b7e5                	j	8000374a <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003764:	02451783          	lh	a5,36(a0)
    80003768:	03079693          	slli	a3,a5,0x30
    8000376c:	92c1                	srli	a3,a3,0x30
    8000376e:	4725                	li	a4,9
    80003770:	02d76963          	bltu	a4,a3,800037a2 <fileread+0xb0>
    80003774:	0792                	slli	a5,a5,0x4
    80003776:	0000f717          	auipc	a4,0xf
    8000377a:	5c270713          	addi	a4,a4,1474 # 80012d38 <devsw>
    8000377e:	97ba                	add	a5,a5,a4
    80003780:	639c                	ld	a5,0(a5)
    80003782:	c78d                	beqz	a5,800037ac <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80003784:	4505                	li	a0,1
    80003786:	9782                	jalr	a5
    80003788:	892a                	mv	s2,a0
    8000378a:	64e2                	ld	s1,24(sp)
    8000378c:	69a2                	ld	s3,8(sp)
    8000378e:	bf75                	j	8000374a <fileread+0x58>
    panic("fileread");
    80003790:	00004517          	auipc	a0,0x4
    80003794:	d8850513          	addi	a0,a0,-632 # 80007518 <etext+0x518>
    80003798:	1fe020ef          	jal	80005996 <panic>
    return -1;
    8000379c:	57fd                	li	a5,-1
    8000379e:	893e                	mv	s2,a5
    800037a0:	b76d                	j	8000374a <fileread+0x58>
      return -1;
    800037a2:	57fd                	li	a5,-1
    800037a4:	893e                	mv	s2,a5
    800037a6:	64e2                	ld	s1,24(sp)
    800037a8:	69a2                	ld	s3,8(sp)
    800037aa:	b745                	j	8000374a <fileread+0x58>
    800037ac:	57fd                	li	a5,-1
    800037ae:	893e                	mv	s2,a5
    800037b0:	64e2                	ld	s1,24(sp)
    800037b2:	69a2                	ld	s3,8(sp)
    800037b4:	bf59                	j	8000374a <fileread+0x58>

00000000800037b6 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    800037b6:	00954783          	lbu	a5,9(a0)
    800037ba:	10078f63          	beqz	a5,800038d8 <filewrite+0x122>
{
    800037be:	711d                	addi	sp,sp,-96
    800037c0:	ec86                	sd	ra,88(sp)
    800037c2:	e8a2                	sd	s0,80(sp)
    800037c4:	e0ca                	sd	s2,64(sp)
    800037c6:	f456                	sd	s5,40(sp)
    800037c8:	f05a                	sd	s6,32(sp)
    800037ca:	1080                	addi	s0,sp,96
    800037cc:	892a                	mv	s2,a0
    800037ce:	8b2e                	mv	s6,a1
    800037d0:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    800037d2:	411c                	lw	a5,0(a0)
    800037d4:	4705                	li	a4,1
    800037d6:	02e78a63          	beq	a5,a4,8000380a <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800037da:	470d                	li	a4,3
    800037dc:	02e78b63          	beq	a5,a4,80003812 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    800037e0:	4709                	li	a4,2
    800037e2:	0ce79f63          	bne	a5,a4,800038c0 <filewrite+0x10a>
    800037e6:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800037e8:	0ac05a63          	blez	a2,8000389c <filewrite+0xe6>
    800037ec:	e4a6                	sd	s1,72(sp)
    800037ee:	fc4e                	sd	s3,56(sp)
    800037f0:	ec5e                	sd	s7,24(sp)
    800037f2:	e862                	sd	s8,16(sp)
    800037f4:	e466                	sd	s9,8(sp)
    int i = 0;
    800037f6:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800037f8:	6b85                	lui	s7,0x1
    800037fa:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800037fe:	6785                	lui	a5,0x1
    80003800:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80003804:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003806:	4c05                	li	s8,1
    80003808:	a8ad                	j	80003882 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    8000380a:	6908                	ld	a0,16(a0)
    8000380c:	204000ef          	jal	80003a10 <pipewrite>
    80003810:	a04d                	j	800038b2 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003812:	02451783          	lh	a5,36(a0)
    80003816:	03079693          	slli	a3,a5,0x30
    8000381a:	92c1                	srli	a3,a3,0x30
    8000381c:	4725                	li	a4,9
    8000381e:	0ad76f63          	bltu	a4,a3,800038dc <filewrite+0x126>
    80003822:	0792                	slli	a5,a5,0x4
    80003824:	0000f717          	auipc	a4,0xf
    80003828:	51470713          	addi	a4,a4,1300 # 80012d38 <devsw>
    8000382c:	97ba                	add	a5,a5,a4
    8000382e:	679c                	ld	a5,8(a5)
    80003830:	cbc5                	beqz	a5,800038e0 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80003832:	4505                	li	a0,1
    80003834:	9782                	jalr	a5
    80003836:	a8b5                	j	800038b2 <filewrite+0xfc>
      if(n1 > max)
    80003838:	2981                	sext.w	s3,s3
      begin_op();
    8000383a:	971ff0ef          	jal	800031aa <begin_op>
      ilock(f->ip);
    8000383e:	01893503          	ld	a0,24(s2)
    80003842:	ecdfe0ef          	jal	8000270e <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003846:	874e                	mv	a4,s3
    80003848:	02092683          	lw	a3,32(s2)
    8000384c:	016a0633          	add	a2,s4,s6
    80003850:	85e2                	mv	a1,s8
    80003852:	01893503          	ld	a0,24(s2)
    80003856:	bcaff0ef          	jal	80002c20 <writei>
    8000385a:	84aa                	mv	s1,a0
    8000385c:	00a05763          	blez	a0,8000386a <filewrite+0xb4>
        f->off += r;
    80003860:	02092783          	lw	a5,32(s2)
    80003864:	9fa9                	addw	a5,a5,a0
    80003866:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    8000386a:	01893503          	ld	a0,24(s2)
    8000386e:	f4ffe0ef          	jal	800027bc <iunlock>
      end_op();
    80003872:	9a9ff0ef          	jal	8000321a <end_op>

      if(r != n1){
    80003876:	02999563          	bne	s3,s1,800038a0 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    8000387a:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    8000387e:	015a5963          	bge	s4,s5,80003890 <filewrite+0xda>
      int n1 = n - i;
    80003882:	414a87bb          	subw	a5,s5,s4
    80003886:	89be                	mv	s3,a5
      if(n1 > max)
    80003888:	fafbd8e3          	bge	s7,a5,80003838 <filewrite+0x82>
    8000388c:	89e6                	mv	s3,s9
    8000388e:	b76d                	j	80003838 <filewrite+0x82>
    80003890:	64a6                	ld	s1,72(sp)
    80003892:	79e2                	ld	s3,56(sp)
    80003894:	6be2                	ld	s7,24(sp)
    80003896:	6c42                	ld	s8,16(sp)
    80003898:	6ca2                	ld	s9,8(sp)
    8000389a:	a801                	j	800038aa <filewrite+0xf4>
    int i = 0;
    8000389c:	4a01                	li	s4,0
    8000389e:	a031                	j	800038aa <filewrite+0xf4>
    800038a0:	64a6                	ld	s1,72(sp)
    800038a2:	79e2                	ld	s3,56(sp)
    800038a4:	6be2                	ld	s7,24(sp)
    800038a6:	6c42                	ld	s8,16(sp)
    800038a8:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    800038aa:	034a9d63          	bne	s5,s4,800038e4 <filewrite+0x12e>
    800038ae:	8556                	mv	a0,s5
    800038b0:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    800038b2:	60e6                	ld	ra,88(sp)
    800038b4:	6446                	ld	s0,80(sp)
    800038b6:	6906                	ld	s2,64(sp)
    800038b8:	7aa2                	ld	s5,40(sp)
    800038ba:	7b02                	ld	s6,32(sp)
    800038bc:	6125                	addi	sp,sp,96
    800038be:	8082                	ret
    800038c0:	e4a6                	sd	s1,72(sp)
    800038c2:	fc4e                	sd	s3,56(sp)
    800038c4:	f852                	sd	s4,48(sp)
    800038c6:	ec5e                	sd	s7,24(sp)
    800038c8:	e862                	sd	s8,16(sp)
    800038ca:	e466                	sd	s9,8(sp)
    panic("filewrite");
    800038cc:	00004517          	auipc	a0,0x4
    800038d0:	c5c50513          	addi	a0,a0,-932 # 80007528 <etext+0x528>
    800038d4:	0c2020ef          	jal	80005996 <panic>
    return -1;
    800038d8:	557d                	li	a0,-1
}
    800038da:	8082                	ret
      return -1;
    800038dc:	557d                	li	a0,-1
    800038de:	bfd1                	j	800038b2 <filewrite+0xfc>
    800038e0:	557d                	li	a0,-1
    800038e2:	bfc1                	j	800038b2 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    800038e4:	557d                	li	a0,-1
    800038e6:	7a42                	ld	s4,48(sp)
    800038e8:	b7e9                	j	800038b2 <filewrite+0xfc>

00000000800038ea <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800038ea:	7179                	addi	sp,sp,-48
    800038ec:	f406                	sd	ra,40(sp)
    800038ee:	f022                	sd	s0,32(sp)
    800038f0:	ec26                	sd	s1,24(sp)
    800038f2:	e052                	sd	s4,0(sp)
    800038f4:	1800                	addi	s0,sp,48
    800038f6:	84aa                	mv	s1,a0
    800038f8:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800038fa:	0005b023          	sd	zero,0(a1)
    800038fe:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003902:	c29ff0ef          	jal	8000352a <filealloc>
    80003906:	e088                	sd	a0,0(s1)
    80003908:	c549                	beqz	a0,80003992 <pipealloc+0xa8>
    8000390a:	c21ff0ef          	jal	8000352a <filealloc>
    8000390e:	00aa3023          	sd	a0,0(s4)
    80003912:	cd25                	beqz	a0,8000398a <pipealloc+0xa0>
    80003914:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003916:	feefc0ef          	jal	80000104 <kalloc>
    8000391a:	892a                	mv	s2,a0
    8000391c:	c12d                	beqz	a0,8000397e <pipealloc+0x94>
    8000391e:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003920:	4985                	li	s3,1
    80003922:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003926:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    8000392a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    8000392e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003932:	00004597          	auipc	a1,0x4
    80003936:	c0658593          	addi	a1,a1,-1018 # 80007538 <etext+0x538>
    8000393a:	294020ef          	jal	80005bce <initlock>
  (*f0)->type = FD_PIPE;
    8000393e:	609c                	ld	a5,0(s1)
    80003940:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003944:	609c                	ld	a5,0(s1)
    80003946:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    8000394a:	609c                	ld	a5,0(s1)
    8000394c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003950:	609c                	ld	a5,0(s1)
    80003952:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003956:	000a3783          	ld	a5,0(s4)
    8000395a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    8000395e:	000a3783          	ld	a5,0(s4)
    80003962:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003966:	000a3783          	ld	a5,0(s4)
    8000396a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    8000396e:	000a3783          	ld	a5,0(s4)
    80003972:	0127b823          	sd	s2,16(a5)
  return 0;
    80003976:	4501                	li	a0,0
    80003978:	6942                	ld	s2,16(sp)
    8000397a:	69a2                	ld	s3,8(sp)
    8000397c:	a01d                	j	800039a2 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    8000397e:	6088                	ld	a0,0(s1)
    80003980:	c119                	beqz	a0,80003986 <pipealloc+0x9c>
    80003982:	6942                	ld	s2,16(sp)
    80003984:	a029                	j	8000398e <pipealloc+0xa4>
    80003986:	6942                	ld	s2,16(sp)
    80003988:	a029                	j	80003992 <pipealloc+0xa8>
    8000398a:	6088                	ld	a0,0(s1)
    8000398c:	c10d                	beqz	a0,800039ae <pipealloc+0xc4>
    fileclose(*f0);
    8000398e:	c41ff0ef          	jal	800035ce <fileclose>
  if(*f1)
    80003992:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003996:	557d                	li	a0,-1
  if(*f1)
    80003998:	c789                	beqz	a5,800039a2 <pipealloc+0xb8>
    fileclose(*f1);
    8000399a:	853e                	mv	a0,a5
    8000399c:	c33ff0ef          	jal	800035ce <fileclose>
  return -1;
    800039a0:	557d                	li	a0,-1
}
    800039a2:	70a2                	ld	ra,40(sp)
    800039a4:	7402                	ld	s0,32(sp)
    800039a6:	64e2                	ld	s1,24(sp)
    800039a8:	6a02                	ld	s4,0(sp)
    800039aa:	6145                	addi	sp,sp,48
    800039ac:	8082                	ret
  return -1;
    800039ae:	557d                	li	a0,-1
    800039b0:	bfcd                	j	800039a2 <pipealloc+0xb8>

00000000800039b2 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    800039b2:	1101                	addi	sp,sp,-32
    800039b4:	ec06                	sd	ra,24(sp)
    800039b6:	e822                	sd	s0,16(sp)
    800039b8:	e426                	sd	s1,8(sp)
    800039ba:	e04a                	sd	s2,0(sp)
    800039bc:	1000                	addi	s0,sp,32
    800039be:	84aa                	mv	s1,a0
    800039c0:	892e                	mv	s2,a1
  acquire(&pi->lock);
    800039c2:	296020ef          	jal	80005c58 <acquire>
  if(writable){
    800039c6:	02090763          	beqz	s2,800039f4 <pipeclose+0x42>
    pi->writeopen = 0;
    800039ca:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    800039ce:	21848513          	addi	a0,s1,536
    800039d2:	a15fd0ef          	jal	800013e6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    800039d6:	2204a783          	lw	a5,544(s1)
    800039da:	e781                	bnez	a5,800039e2 <pipeclose+0x30>
    800039dc:	2244a783          	lw	a5,548(s1)
    800039e0:	c38d                	beqz	a5,80003a02 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    800039e2:	8526                	mv	a0,s1
    800039e4:	308020ef          	jal	80005cec <release>
}
    800039e8:	60e2                	ld	ra,24(sp)
    800039ea:	6442                	ld	s0,16(sp)
    800039ec:	64a2                	ld	s1,8(sp)
    800039ee:	6902                	ld	s2,0(sp)
    800039f0:	6105                	addi	sp,sp,32
    800039f2:	8082                	ret
    pi->readopen = 0;
    800039f4:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800039f8:	21c48513          	addi	a0,s1,540
    800039fc:	9ebfd0ef          	jal	800013e6 <wakeup>
    80003a00:	bfd9                	j	800039d6 <pipeclose+0x24>
    release(&pi->lock);
    80003a02:	8526                	mv	a0,s1
    80003a04:	2e8020ef          	jal	80005cec <release>
    kfree((char*)pi);
    80003a08:	8526                	mv	a0,s1
    80003a0a:	e12fc0ef          	jal	8000001c <kfree>
    80003a0e:	bfe9                	j	800039e8 <pipeclose+0x36>

0000000080003a10 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003a10:	7159                	addi	sp,sp,-112
    80003a12:	f486                	sd	ra,104(sp)
    80003a14:	f0a2                	sd	s0,96(sp)
    80003a16:	eca6                	sd	s1,88(sp)
    80003a18:	e8ca                	sd	s2,80(sp)
    80003a1a:	e4ce                	sd	s3,72(sp)
    80003a1c:	e0d2                	sd	s4,64(sp)
    80003a1e:	fc56                	sd	s5,56(sp)
    80003a20:	1880                	addi	s0,sp,112
    80003a22:	84aa                	mv	s1,a0
    80003a24:	8aae                	mv	s5,a1
    80003a26:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003a28:	b6cfd0ef          	jal	80000d94 <myproc>
    80003a2c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003a2e:	8526                	mv	a0,s1
    80003a30:	228020ef          	jal	80005c58 <acquire>
  while(i < n){
    80003a34:	0d405263          	blez	s4,80003af8 <pipewrite+0xe8>
    80003a38:	f85a                	sd	s6,48(sp)
    80003a3a:	f45e                	sd	s7,40(sp)
    80003a3c:	f062                	sd	s8,32(sp)
    80003a3e:	ec66                	sd	s9,24(sp)
    80003a40:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003a42:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a44:	f9f40c13          	addi	s8,s0,-97
    80003a48:	4b85                	li	s7,1
    80003a4a:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003a4c:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003a50:	21c48c93          	addi	s9,s1,540
    80003a54:	a82d                	j	80003a8e <pipewrite+0x7e>
      release(&pi->lock);
    80003a56:	8526                	mv	a0,s1
    80003a58:	294020ef          	jal	80005cec <release>
      return -1;
    80003a5c:	597d                	li	s2,-1
    80003a5e:	7b42                	ld	s6,48(sp)
    80003a60:	7ba2                	ld	s7,40(sp)
    80003a62:	7c02                	ld	s8,32(sp)
    80003a64:	6ce2                	ld	s9,24(sp)
    80003a66:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003a68:	854a                	mv	a0,s2
    80003a6a:	70a6                	ld	ra,104(sp)
    80003a6c:	7406                	ld	s0,96(sp)
    80003a6e:	64e6                	ld	s1,88(sp)
    80003a70:	6946                	ld	s2,80(sp)
    80003a72:	69a6                	ld	s3,72(sp)
    80003a74:	6a06                	ld	s4,64(sp)
    80003a76:	7ae2                	ld	s5,56(sp)
    80003a78:	6165                	addi	sp,sp,112
    80003a7a:	8082                	ret
      wakeup(&pi->nread);
    80003a7c:	856a                	mv	a0,s10
    80003a7e:	969fd0ef          	jal	800013e6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003a82:	85a6                	mv	a1,s1
    80003a84:	8566                	mv	a0,s9
    80003a86:	915fd0ef          	jal	8000139a <sleep>
  while(i < n){
    80003a8a:	05495a63          	bge	s2,s4,80003ade <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003a8e:	2204a783          	lw	a5,544(s1)
    80003a92:	d3f1                	beqz	a5,80003a56 <pipewrite+0x46>
    80003a94:	854e                	mv	a0,s3
    80003a96:	b3bfd0ef          	jal	800015d0 <killed>
    80003a9a:	fd55                	bnez	a0,80003a56 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003a9c:	2184a783          	lw	a5,536(s1)
    80003aa0:	21c4a703          	lw	a4,540(s1)
    80003aa4:	2007879b          	addiw	a5,a5,512
    80003aa8:	fcf70ae3          	beq	a4,a5,80003a7c <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003aac:	86de                	mv	a3,s7
    80003aae:	01590633          	add	a2,s2,s5
    80003ab2:	85e2                	mv	a1,s8
    80003ab4:	0509b503          	ld	a0,80(s3)
    80003ab8:	8c0fd0ef          	jal	80000b78 <copyin>
    80003abc:	05650063          	beq	a0,s6,80003afc <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ac0:	21c4a783          	lw	a5,540(s1)
    80003ac4:	0017871b          	addiw	a4,a5,1
    80003ac8:	20e4ae23          	sw	a4,540(s1)
    80003acc:	1ff7f793          	andi	a5,a5,511
    80003ad0:	97a6                	add	a5,a5,s1
    80003ad2:	f9f44703          	lbu	a4,-97(s0)
    80003ad6:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ada:	2905                	addiw	s2,s2,1
    80003adc:	b77d                	j	80003a8a <pipewrite+0x7a>
    80003ade:	7b42                	ld	s6,48(sp)
    80003ae0:	7ba2                	ld	s7,40(sp)
    80003ae2:	7c02                	ld	s8,32(sp)
    80003ae4:	6ce2                	ld	s9,24(sp)
    80003ae6:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003ae8:	21848513          	addi	a0,s1,536
    80003aec:	8fbfd0ef          	jal	800013e6 <wakeup>
  release(&pi->lock);
    80003af0:	8526                	mv	a0,s1
    80003af2:	1fa020ef          	jal	80005cec <release>
  return i;
    80003af6:	bf8d                	j	80003a68 <pipewrite+0x58>
  int i = 0;
    80003af8:	4901                	li	s2,0
    80003afa:	b7fd                	j	80003ae8 <pipewrite+0xd8>
    80003afc:	7b42                	ld	s6,48(sp)
    80003afe:	7ba2                	ld	s7,40(sp)
    80003b00:	7c02                	ld	s8,32(sp)
    80003b02:	6ce2                	ld	s9,24(sp)
    80003b04:	6d42                	ld	s10,16(sp)
    80003b06:	b7cd                	j	80003ae8 <pipewrite+0xd8>

0000000080003b08 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003b08:	711d                	addi	sp,sp,-96
    80003b0a:	ec86                	sd	ra,88(sp)
    80003b0c:	e8a2                	sd	s0,80(sp)
    80003b0e:	e4a6                	sd	s1,72(sp)
    80003b10:	e0ca                	sd	s2,64(sp)
    80003b12:	fc4e                	sd	s3,56(sp)
    80003b14:	f852                	sd	s4,48(sp)
    80003b16:	f456                	sd	s5,40(sp)
    80003b18:	1080                	addi	s0,sp,96
    80003b1a:	84aa                	mv	s1,a0
    80003b1c:	892e                	mv	s2,a1
    80003b1e:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003b20:	a74fd0ef          	jal	80000d94 <myproc>
    80003b24:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003b26:	8526                	mv	a0,s1
    80003b28:	130020ef          	jal	80005c58 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b2c:	2184a703          	lw	a4,536(s1)
    80003b30:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b34:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b38:	02f71763          	bne	a4,a5,80003b66 <piperead+0x5e>
    80003b3c:	2244a783          	lw	a5,548(s1)
    80003b40:	cf85                	beqz	a5,80003b78 <piperead+0x70>
    if(killed(pr)){
    80003b42:	8552                	mv	a0,s4
    80003b44:	a8dfd0ef          	jal	800015d0 <killed>
    80003b48:	e11d                	bnez	a0,80003b6e <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b4a:	85a6                	mv	a1,s1
    80003b4c:	854e                	mv	a0,s3
    80003b4e:	84dfd0ef          	jal	8000139a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b52:	2184a703          	lw	a4,536(s1)
    80003b56:	21c4a783          	lw	a5,540(s1)
    80003b5a:	fef701e3          	beq	a4,a5,80003b3c <piperead+0x34>
    80003b5e:	f05a                	sd	s6,32(sp)
    80003b60:	ec5e                	sd	s7,24(sp)
    80003b62:	e862                	sd	s8,16(sp)
    80003b64:	a829                	j	80003b7e <piperead+0x76>
    80003b66:	f05a                	sd	s6,32(sp)
    80003b68:	ec5e                	sd	s7,24(sp)
    80003b6a:	e862                	sd	s8,16(sp)
    80003b6c:	a809                	j	80003b7e <piperead+0x76>
      release(&pi->lock);
    80003b6e:	8526                	mv	a0,s1
    80003b70:	17c020ef          	jal	80005cec <release>
      return -1;
    80003b74:	59fd                	li	s3,-1
    80003b76:	a09d                	j	80003bdc <piperead+0xd4>
    80003b78:	f05a                	sd	s6,32(sp)
    80003b7a:	ec5e                	sd	s7,24(sp)
    80003b7c:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b7e:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b80:	faf40c13          	addi	s8,s0,-81
    80003b84:	4b85                	li	s7,1
    80003b86:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b88:	05505063          	blez	s5,80003bc8 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003b8c:	2184a783          	lw	a5,536(s1)
    80003b90:	21c4a703          	lw	a4,540(s1)
    80003b94:	02f70a63          	beq	a4,a5,80003bc8 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003b98:	0017871b          	addiw	a4,a5,1
    80003b9c:	20e4ac23          	sw	a4,536(s1)
    80003ba0:	1ff7f793          	andi	a5,a5,511
    80003ba4:	97a6                	add	a5,a5,s1
    80003ba6:	0187c783          	lbu	a5,24(a5)
    80003baa:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003bae:	86de                	mv	a3,s7
    80003bb0:	8662                	mv	a2,s8
    80003bb2:	85ca                	mv	a1,s2
    80003bb4:	050a3503          	ld	a0,80(s4)
    80003bb8:	f03fc0ef          	jal	80000aba <copyout>
    80003bbc:	01650663          	beq	a0,s6,80003bc8 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003bc0:	2985                	addiw	s3,s3,1
    80003bc2:	0905                	addi	s2,s2,1
    80003bc4:	fd3a94e3          	bne	s5,s3,80003b8c <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003bc8:	21c48513          	addi	a0,s1,540
    80003bcc:	81bfd0ef          	jal	800013e6 <wakeup>
  release(&pi->lock);
    80003bd0:	8526                	mv	a0,s1
    80003bd2:	11a020ef          	jal	80005cec <release>
    80003bd6:	7b02                	ld	s6,32(sp)
    80003bd8:	6be2                	ld	s7,24(sp)
    80003bda:	6c42                	ld	s8,16(sp)
  return i;
}
    80003bdc:	854e                	mv	a0,s3
    80003bde:	60e6                	ld	ra,88(sp)
    80003be0:	6446                	ld	s0,80(sp)
    80003be2:	64a6                	ld	s1,72(sp)
    80003be4:	6906                	ld	s2,64(sp)
    80003be6:	79e2                	ld	s3,56(sp)
    80003be8:	7a42                	ld	s4,48(sp)
    80003bea:	7aa2                	ld	s5,40(sp)
    80003bec:	6125                	addi	sp,sp,96
    80003bee:	8082                	ret

0000000080003bf0 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003bf0:	1141                	addi	sp,sp,-16
    80003bf2:	e406                	sd	ra,8(sp)
    80003bf4:	e022                	sd	s0,0(sp)
    80003bf6:	0800                	addi	s0,sp,16
    80003bf8:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003bfa:	0035151b          	slliw	a0,a0,0x3
    80003bfe:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003c00:	8b89                	andi	a5,a5,2
    80003c02:	c399                	beqz	a5,80003c08 <flags2perm+0x18>
      perm |= PTE_W;
    80003c04:	00456513          	ori	a0,a0,4
    return perm;
}
    80003c08:	60a2                	ld	ra,8(sp)
    80003c0a:	6402                	ld	s0,0(sp)
    80003c0c:	0141                	addi	sp,sp,16
    80003c0e:	8082                	ret

0000000080003c10 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003c10:	de010113          	addi	sp,sp,-544
    80003c14:	20113c23          	sd	ra,536(sp)
    80003c18:	20813823          	sd	s0,528(sp)
    80003c1c:	20913423          	sd	s1,520(sp)
    80003c20:	21213023          	sd	s2,512(sp)
    80003c24:	1400                	addi	s0,sp,544
    80003c26:	892a                	mv	s2,a0
    80003c28:	dea43823          	sd	a0,-528(s0)
    80003c2c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003c30:	964fd0ef          	jal	80000d94 <myproc>
    80003c34:	84aa                	mv	s1,a0

  begin_op();
    80003c36:	d74ff0ef          	jal	800031aa <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003c3a:	854a                	mv	a0,s2
    80003c3c:	b90ff0ef          	jal	80002fcc <namei>
    80003c40:	cd21                	beqz	a0,80003c98 <kexec+0x88>
    80003c42:	fbd2                	sd	s4,496(sp)
    80003c44:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003c46:	ac9fe0ef          	jal	8000270e <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003c4a:	04000713          	li	a4,64
    80003c4e:	4681                	li	a3,0
    80003c50:	e5040613          	addi	a2,s0,-432
    80003c54:	4581                	li	a1,0
    80003c56:	8552                	mv	a0,s4
    80003c58:	ed7fe0ef          	jal	80002b2e <readi>
    80003c5c:	04000793          	li	a5,64
    80003c60:	00f51a63          	bne	a0,a5,80003c74 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003c64:	e5042703          	lw	a4,-432(s0)
    80003c68:	464c47b7          	lui	a5,0x464c4
    80003c6c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003c70:	02f70863          	beq	a4,a5,80003ca0 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003c74:	8552                	mv	a0,s4
    80003c76:	d33fe0ef          	jal	800029a8 <iunlockput>
    end_op();
    80003c7a:	da0ff0ef          	jal	8000321a <end_op>
  }
  return -1;
    80003c7e:	557d                	li	a0,-1
    80003c80:	7a5e                	ld	s4,496(sp)
}
    80003c82:	21813083          	ld	ra,536(sp)
    80003c86:	21013403          	ld	s0,528(sp)
    80003c8a:	20813483          	ld	s1,520(sp)
    80003c8e:	20013903          	ld	s2,512(sp)
    80003c92:	22010113          	addi	sp,sp,544
    80003c96:	8082                	ret
    end_op();
    80003c98:	d82ff0ef          	jal	8000321a <end_op>
    return -1;
    80003c9c:	557d                	li	a0,-1
    80003c9e:	b7d5                	j	80003c82 <kexec+0x72>
    80003ca0:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003ca2:	8526                	mv	a0,s1
    80003ca4:	9fafd0ef          	jal	80000e9e <proc_pagetable>
    80003ca8:	8b2a                	mv	s6,a0
    80003caa:	26050f63          	beqz	a0,80003f28 <kexec+0x318>
    80003cae:	ffce                	sd	s3,504(sp)
    80003cb0:	f7d6                	sd	s5,488(sp)
    80003cb2:	efde                	sd	s7,472(sp)
    80003cb4:	ebe2                	sd	s8,464(sp)
    80003cb6:	e7e6                	sd	s9,456(sp)
    80003cb8:	e3ea                	sd	s10,448(sp)
    80003cba:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cbc:	e8845783          	lhu	a5,-376(s0)
    80003cc0:	0e078963          	beqz	a5,80003db2 <kexec+0x1a2>
    80003cc4:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003cc8:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003cca:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003ccc:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003cd0:	6c85                	lui	s9,0x1
    80003cd2:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003cd6:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003cda:	6a85                	lui	s5,0x1
    80003cdc:	a085                	j	80003d3c <kexec+0x12c>
      panic("loadseg: address should exist");
    80003cde:	00004517          	auipc	a0,0x4
    80003ce2:	86250513          	addi	a0,a0,-1950 # 80007540 <etext+0x540>
    80003ce6:	4b1010ef          	jal	80005996 <panic>
    if(sz - i < PGSIZE)
    80003cea:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003cec:	874a                	mv	a4,s2
    80003cee:	009b86bb          	addw	a3,s7,s1
    80003cf2:	4581                	li	a1,0
    80003cf4:	8552                	mv	a0,s4
    80003cf6:	e39fe0ef          	jal	80002b2e <readi>
    80003cfa:	22a91b63          	bne	s2,a0,80003f30 <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80003cfe:	009a84bb          	addw	s1,s5,s1
    80003d02:	0334f263          	bgeu	s1,s3,80003d26 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003d06:	02049593          	slli	a1,s1,0x20
    80003d0a:	9181                	srli	a1,a1,0x20
    80003d0c:	95e2                	add	a1,a1,s8
    80003d0e:	855a                	mv	a0,s6
    80003d10:	f7cfc0ef          	jal	8000048c <walkaddr>
    80003d14:	862a                	mv	a2,a0
    if(pa == 0)
    80003d16:	d561                	beqz	a0,80003cde <kexec+0xce>
    if(sz - i < PGSIZE)
    80003d18:	409987bb          	subw	a5,s3,s1
    80003d1c:	893e                	mv	s2,a5
    80003d1e:	fcfcf6e3          	bgeu	s9,a5,80003cea <kexec+0xda>
    80003d22:	8956                	mv	s2,s5
    80003d24:	b7d9                	j	80003cea <kexec+0xda>
    sz = sz1;
    80003d26:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003d2a:	2d05                	addiw	s10,s10,1
    80003d2c:	e0843783          	ld	a5,-504(s0)
    80003d30:	0387869b          	addiw	a3,a5,56
    80003d34:	e8845783          	lhu	a5,-376(s0)
    80003d38:	06fd5e63          	bge	s10,a5,80003db4 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003d3c:	e0d43423          	sd	a3,-504(s0)
    80003d40:	876e                	mv	a4,s11
    80003d42:	e1840613          	addi	a2,s0,-488
    80003d46:	4581                	li	a1,0
    80003d48:	8552                	mv	a0,s4
    80003d4a:	de5fe0ef          	jal	80002b2e <readi>
    80003d4e:	1db51f63          	bne	a0,s11,80003f2c <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80003d52:	e1842783          	lw	a5,-488(s0)
    80003d56:	4705                	li	a4,1
    80003d58:	fce799e3          	bne	a5,a4,80003d2a <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003d5c:	e4043483          	ld	s1,-448(s0)
    80003d60:	e3843783          	ld	a5,-456(s0)
    80003d64:	1ef4e463          	bltu	s1,a5,80003f4c <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d68:	e2843783          	ld	a5,-472(s0)
    80003d6c:	94be                	add	s1,s1,a5
    80003d6e:	1ef4e263          	bltu	s1,a5,80003f52 <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80003d72:	de843703          	ld	a4,-536(s0)
    80003d76:	8ff9                	and	a5,a5,a4
    80003d78:	1e079063          	bnez	a5,80003f58 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d7c:	e1c42503          	lw	a0,-484(s0)
    80003d80:	e71ff0ef          	jal	80003bf0 <flags2perm>
    80003d84:	86aa                	mv	a3,a0
    80003d86:	8626                	mv	a2,s1
    80003d88:	85ca                	mv	a1,s2
    80003d8a:	855a                	mv	a0,s6
    80003d8c:	9d7fc0ef          	jal	80000762 <uvmalloc>
    80003d90:	dea43c23          	sd	a0,-520(s0)
    80003d94:	1c050563          	beqz	a0,80003f5e <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d98:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d9c:	00098863          	beqz	s3,80003dac <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003da0:	e2843c03          	ld	s8,-472(s0)
    80003da4:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003da8:	4481                	li	s1,0
    80003daa:	bfb1                	j	80003d06 <kexec+0xf6>
    sz = sz1;
    80003dac:	df843903          	ld	s2,-520(s0)
    80003db0:	bfad                	j	80003d2a <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003db2:	4901                	li	s2,0
  iunlockput(ip);
    80003db4:	8552                	mv	a0,s4
    80003db6:	bf3fe0ef          	jal	800029a8 <iunlockput>
  end_op();
    80003dba:	c60ff0ef          	jal	8000321a <end_op>
  p = myproc();
    80003dbe:	fd7fc0ef          	jal	80000d94 <myproc>
    80003dc2:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003dc4:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003dc8:	6985                	lui	s3,0x1
    80003dca:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003dcc:	99ca                	add	s3,s3,s2
    80003dce:	77fd                	lui	a5,0xfffff
    80003dd0:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003dd4:	4691                	li	a3,4
    80003dd6:	6609                	lui	a2,0x2
    80003dd8:	964e                	add	a2,a2,s3
    80003dda:	85ce                	mv	a1,s3
    80003ddc:	855a                	mv	a0,s6
    80003dde:	985fc0ef          	jal	80000762 <uvmalloc>
    80003de2:	8a2a                	mv	s4,a0
    80003de4:	e105                	bnez	a0,80003e04 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003de6:	85ce                	mv	a1,s3
    80003de8:	855a                	mv	a0,s6
    80003dea:	938fd0ef          	jal	80000f22 <proc_freepagetable>
  return -1;
    80003dee:	557d                	li	a0,-1
    80003df0:	79fe                	ld	s3,504(sp)
    80003df2:	7a5e                	ld	s4,496(sp)
    80003df4:	7abe                	ld	s5,488(sp)
    80003df6:	7b1e                	ld	s6,480(sp)
    80003df8:	6bfe                	ld	s7,472(sp)
    80003dfa:	6c5e                	ld	s8,464(sp)
    80003dfc:	6cbe                	ld	s9,456(sp)
    80003dfe:	6d1e                	ld	s10,448(sp)
    80003e00:	7dfa                	ld	s11,440(sp)
    80003e02:	b541                	j	80003c82 <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003e04:	75f9                	lui	a1,0xffffe
    80003e06:	95aa                	add	a1,a1,a0
    80003e08:	855a                	mv	a0,s6
    80003e0a:	b2bfc0ef          	jal	80000934 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003e0e:	800a0b93          	addi	s7,s4,-2048
    80003e12:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80003e16:	e0043783          	ld	a5,-512(s0)
    80003e1a:	6388                	ld	a0,0(a5)
  sp = sz;
    80003e1c:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003e1e:	4481                	li	s1,0
    ustack[argc] = sp;
    80003e20:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003e24:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003e28:	cd21                	beqz	a0,80003e80 <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80003e2a:	cbefc0ef          	jal	800002e8 <strlen>
    80003e2e:	0015079b          	addiw	a5,a0,1
    80003e32:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003e36:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003e3a:	13796563          	bltu	s2,s7,80003f64 <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003e3e:	e0043d83          	ld	s11,-512(s0)
    80003e42:	000db983          	ld	s3,0(s11)
    80003e46:	854e                	mv	a0,s3
    80003e48:	ca0fc0ef          	jal	800002e8 <strlen>
    80003e4c:	0015069b          	addiw	a3,a0,1
    80003e50:	864e                	mv	a2,s3
    80003e52:	85ca                	mv	a1,s2
    80003e54:	855a                	mv	a0,s6
    80003e56:	c65fc0ef          	jal	80000aba <copyout>
    80003e5a:	10054763          	bltz	a0,80003f68 <kexec+0x358>
    ustack[argc] = sp;
    80003e5e:	00349793          	slli	a5,s1,0x3
    80003e62:	97e6                	add	a5,a5,s9
    80003e64:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffe3058>
  for(argc = 0; argv[argc]; argc++) {
    80003e68:	0485                	addi	s1,s1,1
    80003e6a:	008d8793          	addi	a5,s11,8
    80003e6e:	e0f43023          	sd	a5,-512(s0)
    80003e72:	008db503          	ld	a0,8(s11)
    80003e76:	c509                	beqz	a0,80003e80 <kexec+0x270>
    if(argc >= MAXARG)
    80003e78:	fb8499e3          	bne	s1,s8,80003e2a <kexec+0x21a>
  sz = sz1;
    80003e7c:	89d2                	mv	s3,s4
    80003e7e:	b7a5                	j	80003de6 <kexec+0x1d6>
  ustack[argc] = 0;
    80003e80:	00349793          	slli	a5,s1,0x3
    80003e84:	f9078793          	addi	a5,a5,-112
    80003e88:	97a2                	add	a5,a5,s0
    80003e8a:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e8e:	00349693          	slli	a3,s1,0x3
    80003e92:	06a1                	addi	a3,a3,8
    80003e94:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e98:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e9c:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003e9e:	f57964e3          	bltu	s2,s7,80003de6 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003ea2:	e9040613          	addi	a2,s0,-368
    80003ea6:	85ca                	mv	a1,s2
    80003ea8:	855a                	mv	a0,s6
    80003eaa:	c11fc0ef          	jal	80000aba <copyout>
    80003eae:	f2054ce3          	bltz	a0,80003de6 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80003eb2:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003eb6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003eba:	df043783          	ld	a5,-528(s0)
    80003ebe:	0007c703          	lbu	a4,0(a5)
    80003ec2:	cf11                	beqz	a4,80003ede <kexec+0x2ce>
    80003ec4:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003ec6:	02f00693          	li	a3,47
    80003eca:	a029                	j	80003ed4 <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80003ecc:	0785                	addi	a5,a5,1
    80003ece:	fff7c703          	lbu	a4,-1(a5)
    80003ed2:	c711                	beqz	a4,80003ede <kexec+0x2ce>
    if(*s == '/')
    80003ed4:	fed71ce3          	bne	a4,a3,80003ecc <kexec+0x2bc>
      last = s+1;
    80003ed8:	def43823          	sd	a5,-528(s0)
    80003edc:	bfc5                	j	80003ecc <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80003ede:	4641                	li	a2,16
    80003ee0:	df043583          	ld	a1,-528(s0)
    80003ee4:	158a8513          	addi	a0,s5,344
    80003ee8:	bcafc0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    80003eec:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003ef0:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003ef4:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80003ef8:	058ab783          	ld	a5,88(s5)
    80003efc:	e6843703          	ld	a4,-408(s0)
    80003f00:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003f02:	058ab783          	ld	a5,88(s5)
    80003f06:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003f0a:	85ea                	mv	a1,s10
    80003f0c:	816fd0ef          	jal	80000f22 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003f10:	0004851b          	sext.w	a0,s1
    80003f14:	79fe                	ld	s3,504(sp)
    80003f16:	7a5e                	ld	s4,496(sp)
    80003f18:	7abe                	ld	s5,488(sp)
    80003f1a:	7b1e                	ld	s6,480(sp)
    80003f1c:	6bfe                	ld	s7,472(sp)
    80003f1e:	6c5e                	ld	s8,464(sp)
    80003f20:	6cbe                	ld	s9,456(sp)
    80003f22:	6d1e                	ld	s10,448(sp)
    80003f24:	7dfa                	ld	s11,440(sp)
    80003f26:	bbb1                	j	80003c82 <kexec+0x72>
    80003f28:	7b1e                	ld	s6,480(sp)
    80003f2a:	b3a9                	j	80003c74 <kexec+0x64>
    80003f2c:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003f30:	df843583          	ld	a1,-520(s0)
    80003f34:	855a                	mv	a0,s6
    80003f36:	fedfc0ef          	jal	80000f22 <proc_freepagetable>
  if(ip){
    80003f3a:	79fe                	ld	s3,504(sp)
    80003f3c:	7abe                	ld	s5,488(sp)
    80003f3e:	7b1e                	ld	s6,480(sp)
    80003f40:	6bfe                	ld	s7,472(sp)
    80003f42:	6c5e                	ld	s8,464(sp)
    80003f44:	6cbe                	ld	s9,456(sp)
    80003f46:	6d1e                	ld	s10,448(sp)
    80003f48:	7dfa                	ld	s11,440(sp)
    80003f4a:	b32d                	j	80003c74 <kexec+0x64>
    80003f4c:	df243c23          	sd	s2,-520(s0)
    80003f50:	b7c5                	j	80003f30 <kexec+0x320>
    80003f52:	df243c23          	sd	s2,-520(s0)
    80003f56:	bfe9                	j	80003f30 <kexec+0x320>
    80003f58:	df243c23          	sd	s2,-520(s0)
    80003f5c:	bfd1                	j	80003f30 <kexec+0x320>
    80003f5e:	df243c23          	sd	s2,-520(s0)
    80003f62:	b7f9                	j	80003f30 <kexec+0x320>
  sz = sz1;
    80003f64:	89d2                	mv	s3,s4
    80003f66:	b541                	j	80003de6 <kexec+0x1d6>
    80003f68:	89d2                	mv	s3,s4
    80003f6a:	bdb5                	j	80003de6 <kexec+0x1d6>

0000000080003f6c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f6c:	7179                	addi	sp,sp,-48
    80003f6e:	f406                	sd	ra,40(sp)
    80003f70:	f022                	sd	s0,32(sp)
    80003f72:	ec26                	sd	s1,24(sp)
    80003f74:	e84a                	sd	s2,16(sp)
    80003f76:	1800                	addi	s0,sp,48
    80003f78:	892e                	mv	s2,a1
    80003f7a:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f7c:	fdc40593          	addi	a1,s0,-36
    80003f80:	d21fd0ef          	jal	80001ca0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f84:	fdc42703          	lw	a4,-36(s0)
    80003f88:	47bd                	li	a5,15
    80003f8a:	02e7ea63          	bltu	a5,a4,80003fbe <argfd+0x52>
    80003f8e:	e07fc0ef          	jal	80000d94 <myproc>
    80003f92:	fdc42703          	lw	a4,-36(s0)
    80003f96:	00371793          	slli	a5,a4,0x3
    80003f9a:	0d078793          	addi	a5,a5,208
    80003f9e:	953e                	add	a0,a0,a5
    80003fa0:	611c                	ld	a5,0(a0)
    80003fa2:	c385                	beqz	a5,80003fc2 <argfd+0x56>
    return -1;
  if(pfd)
    80003fa4:	00090463          	beqz	s2,80003fac <argfd+0x40>
    *pfd = fd;
    80003fa8:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003fac:	4501                	li	a0,0
  if(pf)
    80003fae:	c091                	beqz	s1,80003fb2 <argfd+0x46>
    *pf = f;
    80003fb0:	e09c                	sd	a5,0(s1)
}
    80003fb2:	70a2                	ld	ra,40(sp)
    80003fb4:	7402                	ld	s0,32(sp)
    80003fb6:	64e2                	ld	s1,24(sp)
    80003fb8:	6942                	ld	s2,16(sp)
    80003fba:	6145                	addi	sp,sp,48
    80003fbc:	8082                	ret
    return -1;
    80003fbe:	557d                	li	a0,-1
    80003fc0:	bfcd                	j	80003fb2 <argfd+0x46>
    80003fc2:	557d                	li	a0,-1
    80003fc4:	b7fd                	j	80003fb2 <argfd+0x46>

0000000080003fc6 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003fc6:	1101                	addi	sp,sp,-32
    80003fc8:	ec06                	sd	ra,24(sp)
    80003fca:	e822                	sd	s0,16(sp)
    80003fcc:	e426                	sd	s1,8(sp)
    80003fce:	1000                	addi	s0,sp,32
    80003fd0:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003fd2:	dc3fc0ef          	jal	80000d94 <myproc>
    80003fd6:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003fd8:	0d050793          	addi	a5,a0,208
    80003fdc:	4501                	li	a0,0
    80003fde:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003fe0:	6398                	ld	a4,0(a5)
    80003fe2:	cb19                	beqz	a4,80003ff8 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003fe4:	2505                	addiw	a0,a0,1
    80003fe6:	07a1                	addi	a5,a5,8
    80003fe8:	fed51ce3          	bne	a0,a3,80003fe0 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003fec:	557d                	li	a0,-1
}
    80003fee:	60e2                	ld	ra,24(sp)
    80003ff0:	6442                	ld	s0,16(sp)
    80003ff2:	64a2                	ld	s1,8(sp)
    80003ff4:	6105                	addi	sp,sp,32
    80003ff6:	8082                	ret
      p->ofile[fd] = f;
    80003ff8:	00351793          	slli	a5,a0,0x3
    80003ffc:	0d078793          	addi	a5,a5,208
    80004000:	963e                	add	a2,a2,a5
    80004002:	e204                	sd	s1,0(a2)
      return fd;
    80004004:	b7ed                	j	80003fee <fdalloc+0x28>

0000000080004006 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80004006:	715d                	addi	sp,sp,-80
    80004008:	e486                	sd	ra,72(sp)
    8000400a:	e0a2                	sd	s0,64(sp)
    8000400c:	fc26                	sd	s1,56(sp)
    8000400e:	f84a                	sd	s2,48(sp)
    80004010:	f44e                	sd	s3,40(sp)
    80004012:	f052                	sd	s4,32(sp)
    80004014:	ec56                	sd	s5,24(sp)
    80004016:	e85a                	sd	s6,16(sp)
    80004018:	0880                	addi	s0,sp,80
    8000401a:	892e                	mv	s2,a1
    8000401c:	8a2e                	mv	s4,a1
    8000401e:	8ab2                	mv	s5,a2
    80004020:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004022:	fb040593          	addi	a1,s0,-80
    80004026:	fc1fe0ef          	jal	80002fe6 <nameiparent>
    8000402a:	84aa                	mv	s1,a0
    8000402c:	10050763          	beqz	a0,8000413a <create+0x134>
    return 0;

  ilock(dp);
    80004030:	edefe0ef          	jal	8000270e <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004034:	4601                	li	a2,0
    80004036:	fb040593          	addi	a1,s0,-80
    8000403a:	8526                	mv	a0,s1
    8000403c:	cfdfe0ef          	jal	80002d38 <dirlookup>
    80004040:	89aa                	mv	s3,a0
    80004042:	c131                	beqz	a0,80004086 <create+0x80>
    iunlockput(dp);
    80004044:	8526                	mv	a0,s1
    80004046:	963fe0ef          	jal	800029a8 <iunlockput>
    ilock(ip);
    8000404a:	854e                	mv	a0,s3
    8000404c:	ec2fe0ef          	jal	8000270e <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004050:	4789                	li	a5,2
    80004052:	02f91563          	bne	s2,a5,8000407c <create+0x76>
    80004056:	0449d783          	lhu	a5,68(s3)
    8000405a:	37f9                	addiw	a5,a5,-2
    8000405c:	17c2                	slli	a5,a5,0x30
    8000405e:	93c1                	srli	a5,a5,0x30
    80004060:	4705                	li	a4,1
    80004062:	00f76d63          	bltu	a4,a5,8000407c <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004066:	854e                	mv	a0,s3
    80004068:	60a6                	ld	ra,72(sp)
    8000406a:	6406                	ld	s0,64(sp)
    8000406c:	74e2                	ld	s1,56(sp)
    8000406e:	7942                	ld	s2,48(sp)
    80004070:	79a2                	ld	s3,40(sp)
    80004072:	7a02                	ld	s4,32(sp)
    80004074:	6ae2                	ld	s5,24(sp)
    80004076:	6b42                	ld	s6,16(sp)
    80004078:	6161                	addi	sp,sp,80
    8000407a:	8082                	ret
    iunlockput(ip);
    8000407c:	854e                	mv	a0,s3
    8000407e:	92bfe0ef          	jal	800029a8 <iunlockput>
    return 0;
    80004082:	4981                	li	s3,0
    80004084:	b7cd                	j	80004066 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004086:	85ca                	mv	a1,s2
    80004088:	4088                	lw	a0,0(s1)
    8000408a:	d14fe0ef          	jal	8000259e <ialloc>
    8000408e:	892a                	mv	s2,a0
    80004090:	cd15                	beqz	a0,800040cc <create+0xc6>
  ilock(ip);
    80004092:	e7cfe0ef          	jal	8000270e <ilock>
  ip->major = major;
    80004096:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    8000409a:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    8000409e:	4785                	li	a5,1
    800040a0:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800040a4:	854a                	mv	a0,s2
    800040a6:	db4fe0ef          	jal	8000265a <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800040aa:	4705                	li	a4,1
    800040ac:	02ea0463          	beq	s4,a4,800040d4 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800040b0:	00492603          	lw	a2,4(s2)
    800040b4:	fb040593          	addi	a1,s0,-80
    800040b8:	8526                	mv	a0,s1
    800040ba:	e69fe0ef          	jal	80002f22 <dirlink>
    800040be:	06054263          	bltz	a0,80004122 <create+0x11c>
  iunlockput(dp);
    800040c2:	8526                	mv	a0,s1
    800040c4:	8e5fe0ef          	jal	800029a8 <iunlockput>
  return ip;
    800040c8:	89ca                	mv	s3,s2
    800040ca:	bf71                	j	80004066 <create+0x60>
    iunlockput(dp);
    800040cc:	8526                	mv	a0,s1
    800040ce:	8dbfe0ef          	jal	800029a8 <iunlockput>
    return 0;
    800040d2:	bf51                	j	80004066 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800040d4:	00492603          	lw	a2,4(s2)
    800040d8:	00003597          	auipc	a1,0x3
    800040dc:	48858593          	addi	a1,a1,1160 # 80007560 <etext+0x560>
    800040e0:	854a                	mv	a0,s2
    800040e2:	e41fe0ef          	jal	80002f22 <dirlink>
    800040e6:	02054e63          	bltz	a0,80004122 <create+0x11c>
    800040ea:	40d0                	lw	a2,4(s1)
    800040ec:	00003597          	auipc	a1,0x3
    800040f0:	47c58593          	addi	a1,a1,1148 # 80007568 <etext+0x568>
    800040f4:	854a                	mv	a0,s2
    800040f6:	e2dfe0ef          	jal	80002f22 <dirlink>
    800040fa:	02054463          	bltz	a0,80004122 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800040fe:	00492603          	lw	a2,4(s2)
    80004102:	fb040593          	addi	a1,s0,-80
    80004106:	8526                	mv	a0,s1
    80004108:	e1bfe0ef          	jal	80002f22 <dirlink>
    8000410c:	00054b63          	bltz	a0,80004122 <create+0x11c>
    dp->nlink++;  // for ".."
    80004110:	04a4d783          	lhu	a5,74(s1)
    80004114:	2785                	addiw	a5,a5,1
    80004116:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000411a:	8526                	mv	a0,s1
    8000411c:	d3efe0ef          	jal	8000265a <iupdate>
    80004120:	b74d                	j	800040c2 <create+0xbc>
  ip->nlink = 0;
    80004122:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    80004126:	854a                	mv	a0,s2
    80004128:	d32fe0ef          	jal	8000265a <iupdate>
  iunlockput(ip);
    8000412c:	854a                	mv	a0,s2
    8000412e:	87bfe0ef          	jal	800029a8 <iunlockput>
  iunlockput(dp);
    80004132:	8526                	mv	a0,s1
    80004134:	875fe0ef          	jal	800029a8 <iunlockput>
  return 0;
    80004138:	b73d                	j	80004066 <create+0x60>
    return 0;
    8000413a:	89aa                	mv	s3,a0
    8000413c:	b72d                	j	80004066 <create+0x60>

000000008000413e <sys_dup>:
{
    8000413e:	7179                	addi	sp,sp,-48
    80004140:	f406                	sd	ra,40(sp)
    80004142:	f022                	sd	s0,32(sp)
    80004144:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004146:	fd840613          	addi	a2,s0,-40
    8000414a:	4581                	li	a1,0
    8000414c:	4501                	li	a0,0
    8000414e:	e1fff0ef          	jal	80003f6c <argfd>
    return -1;
    80004152:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004154:	02054363          	bltz	a0,8000417a <sys_dup+0x3c>
    80004158:	ec26                	sd	s1,24(sp)
    8000415a:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    8000415c:	fd843483          	ld	s1,-40(s0)
    80004160:	8526                	mv	a0,s1
    80004162:	e65ff0ef          	jal	80003fc6 <fdalloc>
    80004166:	892a                	mv	s2,a0
    return -1;
    80004168:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000416a:	00054d63          	bltz	a0,80004184 <sys_dup+0x46>
  filedup(f);
    8000416e:	8526                	mv	a0,s1
    80004170:	c18ff0ef          	jal	80003588 <filedup>
  return fd;
    80004174:	87ca                	mv	a5,s2
    80004176:	64e2                	ld	s1,24(sp)
    80004178:	6942                	ld	s2,16(sp)
}
    8000417a:	853e                	mv	a0,a5
    8000417c:	70a2                	ld	ra,40(sp)
    8000417e:	7402                	ld	s0,32(sp)
    80004180:	6145                	addi	sp,sp,48
    80004182:	8082                	ret
    80004184:	64e2                	ld	s1,24(sp)
    80004186:	6942                	ld	s2,16(sp)
    80004188:	bfcd                	j	8000417a <sys_dup+0x3c>

000000008000418a <sys_read>:
{
    8000418a:	7179                	addi	sp,sp,-48
    8000418c:	f406                	sd	ra,40(sp)
    8000418e:	f022                	sd	s0,32(sp)
    80004190:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004192:	fd840593          	addi	a1,s0,-40
    80004196:	4505                	li	a0,1
    80004198:	b25fd0ef          	jal	80001cbc <argaddr>
  argint(2, &n);
    8000419c:	fe440593          	addi	a1,s0,-28
    800041a0:	4509                	li	a0,2
    800041a2:	afffd0ef          	jal	80001ca0 <argint>
  if(argfd(0, 0, &f) < 0)
    800041a6:	fe840613          	addi	a2,s0,-24
    800041aa:	4581                	li	a1,0
    800041ac:	4501                	li	a0,0
    800041ae:	dbfff0ef          	jal	80003f6c <argfd>
    800041b2:	87aa                	mv	a5,a0
    return -1;
    800041b4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041b6:	0007ca63          	bltz	a5,800041ca <sys_read+0x40>
  return fileread(f, p, n);
    800041ba:	fe442603          	lw	a2,-28(s0)
    800041be:	fd843583          	ld	a1,-40(s0)
    800041c2:	fe843503          	ld	a0,-24(s0)
    800041c6:	d2cff0ef          	jal	800036f2 <fileread>
}
    800041ca:	70a2                	ld	ra,40(sp)
    800041cc:	7402                	ld	s0,32(sp)
    800041ce:	6145                	addi	sp,sp,48
    800041d0:	8082                	ret

00000000800041d2 <sys_write>:
{
    800041d2:	7179                	addi	sp,sp,-48
    800041d4:	f406                	sd	ra,40(sp)
    800041d6:	f022                	sd	s0,32(sp)
    800041d8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800041da:	fd840593          	addi	a1,s0,-40
    800041de:	4505                	li	a0,1
    800041e0:	addfd0ef          	jal	80001cbc <argaddr>
  argint(2, &n);
    800041e4:	fe440593          	addi	a1,s0,-28
    800041e8:	4509                	li	a0,2
    800041ea:	ab7fd0ef          	jal	80001ca0 <argint>
  if(argfd(0, 0, &f) < 0)
    800041ee:	fe840613          	addi	a2,s0,-24
    800041f2:	4581                	li	a1,0
    800041f4:	4501                	li	a0,0
    800041f6:	d77ff0ef          	jal	80003f6c <argfd>
    800041fa:	87aa                	mv	a5,a0
    return -1;
    800041fc:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041fe:	0007ca63          	bltz	a5,80004212 <sys_write+0x40>
  return filewrite(f, p, n);
    80004202:	fe442603          	lw	a2,-28(s0)
    80004206:	fd843583          	ld	a1,-40(s0)
    8000420a:	fe843503          	ld	a0,-24(s0)
    8000420e:	da8ff0ef          	jal	800037b6 <filewrite>
}
    80004212:	70a2                	ld	ra,40(sp)
    80004214:	7402                	ld	s0,32(sp)
    80004216:	6145                	addi	sp,sp,48
    80004218:	8082                	ret

000000008000421a <sys_close>:
{
    8000421a:	1101                	addi	sp,sp,-32
    8000421c:	ec06                	sd	ra,24(sp)
    8000421e:	e822                	sd	s0,16(sp)
    80004220:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004222:	fe040613          	addi	a2,s0,-32
    80004226:	fec40593          	addi	a1,s0,-20
    8000422a:	4501                	li	a0,0
    8000422c:	d41ff0ef          	jal	80003f6c <argfd>
    return -1;
    80004230:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004232:	02054163          	bltz	a0,80004254 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    80004236:	b5ffc0ef          	jal	80000d94 <myproc>
    8000423a:	fec42783          	lw	a5,-20(s0)
    8000423e:	078e                	slli	a5,a5,0x3
    80004240:	0d078793          	addi	a5,a5,208
    80004244:	953e                	add	a0,a0,a5
    80004246:	00053023          	sd	zero,0(a0)
  fileclose(f);
    8000424a:	fe043503          	ld	a0,-32(s0)
    8000424e:	b80ff0ef          	jal	800035ce <fileclose>
  return 0;
    80004252:	4781                	li	a5,0
}
    80004254:	853e                	mv	a0,a5
    80004256:	60e2                	ld	ra,24(sp)
    80004258:	6442                	ld	s0,16(sp)
    8000425a:	6105                	addi	sp,sp,32
    8000425c:	8082                	ret

000000008000425e <sys_fstat>:
{
    8000425e:	1101                	addi	sp,sp,-32
    80004260:	ec06                	sd	ra,24(sp)
    80004262:	e822                	sd	s0,16(sp)
    80004264:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004266:	fe040593          	addi	a1,s0,-32
    8000426a:	4505                	li	a0,1
    8000426c:	a51fd0ef          	jal	80001cbc <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004270:	fe840613          	addi	a2,s0,-24
    80004274:	4581                	li	a1,0
    80004276:	4501                	li	a0,0
    80004278:	cf5ff0ef          	jal	80003f6c <argfd>
    8000427c:	87aa                	mv	a5,a0
    return -1;
    8000427e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004280:	0007c863          	bltz	a5,80004290 <sys_fstat+0x32>
  return filestat(f, st);
    80004284:	fe043583          	ld	a1,-32(s0)
    80004288:	fe843503          	ld	a0,-24(s0)
    8000428c:	c04ff0ef          	jal	80003690 <filestat>
}
    80004290:	60e2                	ld	ra,24(sp)
    80004292:	6442                	ld	s0,16(sp)
    80004294:	6105                	addi	sp,sp,32
    80004296:	8082                	ret

0000000080004298 <sys_link>:
{
    80004298:	7169                	addi	sp,sp,-304
    8000429a:	f606                	sd	ra,296(sp)
    8000429c:	f222                	sd	s0,288(sp)
    8000429e:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042a0:	08000613          	li	a2,128
    800042a4:	ed040593          	addi	a1,s0,-304
    800042a8:	4501                	li	a0,0
    800042aa:	a2ffd0ef          	jal	80001cd8 <argstr>
    return -1;
    800042ae:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042b0:	0c054e63          	bltz	a0,8000438c <sys_link+0xf4>
    800042b4:	08000613          	li	a2,128
    800042b8:	f5040593          	addi	a1,s0,-176
    800042bc:	4505                	li	a0,1
    800042be:	a1bfd0ef          	jal	80001cd8 <argstr>
    return -1;
    800042c2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800042c4:	0c054463          	bltz	a0,8000438c <sys_link+0xf4>
    800042c8:	ee26                	sd	s1,280(sp)
  begin_op();
    800042ca:	ee1fe0ef          	jal	800031aa <begin_op>
  if((ip = namei(old)) == 0){
    800042ce:	ed040513          	addi	a0,s0,-304
    800042d2:	cfbfe0ef          	jal	80002fcc <namei>
    800042d6:	84aa                	mv	s1,a0
    800042d8:	c53d                	beqz	a0,80004346 <sys_link+0xae>
  ilock(ip);
    800042da:	c34fe0ef          	jal	8000270e <ilock>
  if(ip->type == T_DIR){
    800042de:	04449703          	lh	a4,68(s1)
    800042e2:	4785                	li	a5,1
    800042e4:	06f70663          	beq	a4,a5,80004350 <sys_link+0xb8>
    800042e8:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042ea:	04a4d783          	lhu	a5,74(s1)
    800042ee:	2785                	addiw	a5,a5,1
    800042f0:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800042f4:	8526                	mv	a0,s1
    800042f6:	b64fe0ef          	jal	8000265a <iupdate>
  iunlock(ip);
    800042fa:	8526                	mv	a0,s1
    800042fc:	cc0fe0ef          	jal	800027bc <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004300:	fd040593          	addi	a1,s0,-48
    80004304:	f5040513          	addi	a0,s0,-176
    80004308:	cdffe0ef          	jal	80002fe6 <nameiparent>
    8000430c:	892a                	mv	s2,a0
    8000430e:	cd21                	beqz	a0,80004366 <sys_link+0xce>
  ilock(dp);
    80004310:	bfefe0ef          	jal	8000270e <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004314:	854a                	mv	a0,s2
    80004316:	00092703          	lw	a4,0(s2)
    8000431a:	409c                	lw	a5,0(s1)
    8000431c:	04f71263          	bne	a4,a5,80004360 <sys_link+0xc8>
    80004320:	40d0                	lw	a2,4(s1)
    80004322:	fd040593          	addi	a1,s0,-48
    80004326:	bfdfe0ef          	jal	80002f22 <dirlink>
    8000432a:	02054b63          	bltz	a0,80004360 <sys_link+0xc8>
  iunlockput(dp);
    8000432e:	854a                	mv	a0,s2
    80004330:	e78fe0ef          	jal	800029a8 <iunlockput>
  iput(ip);
    80004334:	8526                	mv	a0,s1
    80004336:	de8fe0ef          	jal	8000291e <iput>
  end_op();
    8000433a:	ee1fe0ef          	jal	8000321a <end_op>
  return 0;
    8000433e:	4781                	li	a5,0
    80004340:	64f2                	ld	s1,280(sp)
    80004342:	6952                	ld	s2,272(sp)
    80004344:	a0a1                	j	8000438c <sys_link+0xf4>
    end_op();
    80004346:	ed5fe0ef          	jal	8000321a <end_op>
    return -1;
    8000434a:	57fd                	li	a5,-1
    8000434c:	64f2                	ld	s1,280(sp)
    8000434e:	a83d                	j	8000438c <sys_link+0xf4>
    iunlockput(ip);
    80004350:	8526                	mv	a0,s1
    80004352:	e56fe0ef          	jal	800029a8 <iunlockput>
    end_op();
    80004356:	ec5fe0ef          	jal	8000321a <end_op>
    return -1;
    8000435a:	57fd                	li	a5,-1
    8000435c:	64f2                	ld	s1,280(sp)
    8000435e:	a03d                	j	8000438c <sys_link+0xf4>
    iunlockput(dp);
    80004360:	854a                	mv	a0,s2
    80004362:	e46fe0ef          	jal	800029a8 <iunlockput>
  ilock(ip);
    80004366:	8526                	mv	a0,s1
    80004368:	ba6fe0ef          	jal	8000270e <ilock>
  ip->nlink--;
    8000436c:	04a4d783          	lhu	a5,74(s1)
    80004370:	37fd                	addiw	a5,a5,-1
    80004372:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004376:	8526                	mv	a0,s1
    80004378:	ae2fe0ef          	jal	8000265a <iupdate>
  iunlockput(ip);
    8000437c:	8526                	mv	a0,s1
    8000437e:	e2afe0ef          	jal	800029a8 <iunlockput>
  end_op();
    80004382:	e99fe0ef          	jal	8000321a <end_op>
  return -1;
    80004386:	57fd                	li	a5,-1
    80004388:	64f2                	ld	s1,280(sp)
    8000438a:	6952                	ld	s2,272(sp)
}
    8000438c:	853e                	mv	a0,a5
    8000438e:	70b2                	ld	ra,296(sp)
    80004390:	7412                	ld	s0,288(sp)
    80004392:	6155                	addi	sp,sp,304
    80004394:	8082                	ret

0000000080004396 <sys_unlink>:
{
    80004396:	7151                	addi	sp,sp,-240
    80004398:	f586                	sd	ra,232(sp)
    8000439a:	f1a2                	sd	s0,224(sp)
    8000439c:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    8000439e:	08000613          	li	a2,128
    800043a2:	f3040593          	addi	a1,s0,-208
    800043a6:	4501                	li	a0,0
    800043a8:	931fd0ef          	jal	80001cd8 <argstr>
    800043ac:	14054d63          	bltz	a0,80004506 <sys_unlink+0x170>
    800043b0:	eda6                	sd	s1,216(sp)
  begin_op();
    800043b2:	df9fe0ef          	jal	800031aa <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800043b6:	fb040593          	addi	a1,s0,-80
    800043ba:	f3040513          	addi	a0,s0,-208
    800043be:	c29fe0ef          	jal	80002fe6 <nameiparent>
    800043c2:	84aa                	mv	s1,a0
    800043c4:	c955                	beqz	a0,80004478 <sys_unlink+0xe2>
  ilock(dp);
    800043c6:	b48fe0ef          	jal	8000270e <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800043ca:	00003597          	auipc	a1,0x3
    800043ce:	19658593          	addi	a1,a1,406 # 80007560 <etext+0x560>
    800043d2:	fb040513          	addi	a0,s0,-80
    800043d6:	94dfe0ef          	jal	80002d22 <namecmp>
    800043da:	10050b63          	beqz	a0,800044f0 <sys_unlink+0x15a>
    800043de:	00003597          	auipc	a1,0x3
    800043e2:	18a58593          	addi	a1,a1,394 # 80007568 <etext+0x568>
    800043e6:	fb040513          	addi	a0,s0,-80
    800043ea:	939fe0ef          	jal	80002d22 <namecmp>
    800043ee:	10050163          	beqz	a0,800044f0 <sys_unlink+0x15a>
    800043f2:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800043f4:	f2c40613          	addi	a2,s0,-212
    800043f8:	fb040593          	addi	a1,s0,-80
    800043fc:	8526                	mv	a0,s1
    800043fe:	93bfe0ef          	jal	80002d38 <dirlookup>
    80004402:	892a                	mv	s2,a0
    80004404:	0e050563          	beqz	a0,800044ee <sys_unlink+0x158>
    80004408:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    8000440a:	b04fe0ef          	jal	8000270e <ilock>
  if(ip->nlink < 1)
    8000440e:	04a91783          	lh	a5,74(s2)
    80004412:	06f05863          	blez	a5,80004482 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    80004416:	04491703          	lh	a4,68(s2)
    8000441a:	4785                	li	a5,1
    8000441c:	06f70963          	beq	a4,a5,8000448e <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004420:	fc040993          	addi	s3,s0,-64
    80004424:	4641                	li	a2,16
    80004426:	4581                	li	a1,0
    80004428:	854e                	mv	a0,s3
    8000442a:	d35fb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000442e:	4741                	li	a4,16
    80004430:	f2c42683          	lw	a3,-212(s0)
    80004434:	864e                	mv	a2,s3
    80004436:	4581                	li	a1,0
    80004438:	8526                	mv	a0,s1
    8000443a:	fe6fe0ef          	jal	80002c20 <writei>
    8000443e:	47c1                	li	a5,16
    80004440:	08f51863          	bne	a0,a5,800044d0 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80004444:	04491703          	lh	a4,68(s2)
    80004448:	4785                	li	a5,1
    8000444a:	08f70963          	beq	a4,a5,800044dc <sys_unlink+0x146>
  iunlockput(dp);
    8000444e:	8526                	mv	a0,s1
    80004450:	d58fe0ef          	jal	800029a8 <iunlockput>
  ip->nlink--;
    80004454:	04a95783          	lhu	a5,74(s2)
    80004458:	37fd                	addiw	a5,a5,-1
    8000445a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000445e:	854a                	mv	a0,s2
    80004460:	9fafe0ef          	jal	8000265a <iupdate>
  iunlockput(ip);
    80004464:	854a                	mv	a0,s2
    80004466:	d42fe0ef          	jal	800029a8 <iunlockput>
  end_op();
    8000446a:	db1fe0ef          	jal	8000321a <end_op>
  return 0;
    8000446e:	4501                	li	a0,0
    80004470:	64ee                	ld	s1,216(sp)
    80004472:	694e                	ld	s2,208(sp)
    80004474:	69ae                	ld	s3,200(sp)
    80004476:	a061                	j	800044fe <sys_unlink+0x168>
    end_op();
    80004478:	da3fe0ef          	jal	8000321a <end_op>
    return -1;
    8000447c:	557d                	li	a0,-1
    8000447e:	64ee                	ld	s1,216(sp)
    80004480:	a8bd                	j	800044fe <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    80004482:	00003517          	auipc	a0,0x3
    80004486:	0ee50513          	addi	a0,a0,238 # 80007570 <etext+0x570>
    8000448a:	50c010ef          	jal	80005996 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    8000448e:	04c92703          	lw	a4,76(s2)
    80004492:	02000793          	li	a5,32
    80004496:	f8e7f5e3          	bgeu	a5,a4,80004420 <sys_unlink+0x8a>
    8000449a:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000449c:	4741                	li	a4,16
    8000449e:	86ce                	mv	a3,s3
    800044a0:	f1840613          	addi	a2,s0,-232
    800044a4:	4581                	li	a1,0
    800044a6:	854a                	mv	a0,s2
    800044a8:	e86fe0ef          	jal	80002b2e <readi>
    800044ac:	47c1                	li	a5,16
    800044ae:	00f51b63          	bne	a0,a5,800044c4 <sys_unlink+0x12e>
    if(de.inum != 0)
    800044b2:	f1845783          	lhu	a5,-232(s0)
    800044b6:	ebb1                	bnez	a5,8000450a <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800044b8:	29c1                	addiw	s3,s3,16
    800044ba:	04c92783          	lw	a5,76(s2)
    800044be:	fcf9efe3          	bltu	s3,a5,8000449c <sys_unlink+0x106>
    800044c2:	bfb9                	j	80004420 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800044c4:	00003517          	auipc	a0,0x3
    800044c8:	0c450513          	addi	a0,a0,196 # 80007588 <etext+0x588>
    800044cc:	4ca010ef          	jal	80005996 <panic>
    panic("unlink: writei");
    800044d0:	00003517          	auipc	a0,0x3
    800044d4:	0d050513          	addi	a0,a0,208 # 800075a0 <etext+0x5a0>
    800044d8:	4be010ef          	jal	80005996 <panic>
    dp->nlink--;
    800044dc:	04a4d783          	lhu	a5,74(s1)
    800044e0:	37fd                	addiw	a5,a5,-1
    800044e2:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800044e6:	8526                	mv	a0,s1
    800044e8:	972fe0ef          	jal	8000265a <iupdate>
    800044ec:	b78d                	j	8000444e <sys_unlink+0xb8>
    800044ee:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800044f0:	8526                	mv	a0,s1
    800044f2:	cb6fe0ef          	jal	800029a8 <iunlockput>
  end_op();
    800044f6:	d25fe0ef          	jal	8000321a <end_op>
  return -1;
    800044fa:	557d                	li	a0,-1
    800044fc:	64ee                	ld	s1,216(sp)
}
    800044fe:	70ae                	ld	ra,232(sp)
    80004500:	740e                	ld	s0,224(sp)
    80004502:	616d                	addi	sp,sp,240
    80004504:	8082                	ret
    return -1;
    80004506:	557d                	li	a0,-1
    80004508:	bfdd                	j	800044fe <sys_unlink+0x168>
    iunlockput(ip);
    8000450a:	854a                	mv	a0,s2
    8000450c:	c9cfe0ef          	jal	800029a8 <iunlockput>
    goto bad;
    80004510:	694e                	ld	s2,208(sp)
    80004512:	69ae                	ld	s3,200(sp)
    80004514:	bff1                	j	800044f0 <sys_unlink+0x15a>

0000000080004516 <sys_open>:

uint64
sys_open(void)
{
    80004516:	710d                	addi	sp,sp,-352
    80004518:	ee86                	sd	ra,344(sp)
    8000451a:	eaa2                	sd	s0,336(sp)
    8000451c:	1280                	addi	s0,sp,352
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    8000451e:	f2c40593          	addi	a1,s0,-212
    80004522:	4505                	li	a0,1
    80004524:	f7cfd0ef          	jal	80001ca0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004528:	08000613          	li	a2,128
    8000452c:	f3040593          	addi	a1,s0,-208
    80004530:	4501                	li	a0,0
    80004532:	fa6fd0ef          	jal	80001cd8 <argstr>
    80004536:	20054e63          	bltz	a0,80004752 <sys_open+0x23c>
    8000453a:	e6a6                	sd	s1,328(sp)
    return -1;

  begin_op();
    8000453c:	c6ffe0ef          	jal	800031aa <begin_op>

  if(omode & O_CREATE){
    80004540:	f2c42783          	lw	a5,-212(s0)
    80004544:	2007f793          	andi	a5,a5,512
    80004548:	cba1                	beqz	a5,80004598 <sys_open+0x82>
    ip = create(path, T_FILE, 0, 0);
    8000454a:	4681                	li	a3,0
    8000454c:	4601                	li	a2,0
    8000454e:	4589                	li	a1,2
    80004550:	f3040513          	addi	a0,s0,-208
    80004554:	ab3ff0ef          	jal	80004006 <create>
    80004558:	84aa                	mv	s1,a0
    if(ip == 0){
    8000455a:	c915                	beqz	a0,8000458e <sys_open+0x78>
    8000455c:	e2ca                	sd	s2,320(sp)
    8000455e:	fe4e                	sd	s3,312(sp)
    80004560:	fa52                	sd	s4,304(sp)
    80004562:	f656                	sd	s5,296(sp)
    80004564:	f25a                	sd	s6,288(sp)
    80004566:	ee5e                	sd	s7,280(sp)
      iunlockput(ip);
      end_op();
      return -1;
    }
  }
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004568:	04449783          	lh	a5,68(s1)
    8000456c:	470d                	li	a4,3
    8000456e:	06e78463          	beq	a5,a4,800045d6 <sys_open+0xc0>
  }

  // Follow the symbolic link
  // Return -1 if the depth of links reaches some threshold
  int dol = 0, threshold = 10; // depth of link
  while(ip->type == T_SYMLINK && (omode & O_NOFOLLOW) == 0) {
    80004572:	4711                	li	a4,4
    80004574:	1ae79163          	bne	a5,a4,80004716 <sys_open+0x200>
    80004578:	492d                	li	s2,11
    8000457a:	6a05                	lui	s4,0x1
    8000457c:	800a0a13          	addi	s4,s4,-2048 # 800 <_entry-0x7ffff800>
    char tpath[MAXPATH];

    if(readi(ip, 0, (uint64)tpath, 0, sizeof(tpath)) == 0)
    80004580:	ea840993          	addi	s3,s0,-344
    80004584:	08000a93          	li	s5,128
    if((ip = namei(tpath)) == 0){
      end_op();
      return -1;
    }
    ilock(ip);
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004588:	4b05                	li	s6,1
  while(ip->type == T_SYMLINK && (omode & O_NOFOLLOW) == 0) {
    8000458a:	8bbe                	mv	s7,a5
    8000458c:	a221                	j	80004694 <sys_open+0x17e>
      end_op();
    8000458e:	c8dfe0ef          	jal	8000321a <end_op>
      return -1;
    80004592:	557d                	li	a0,-1
    80004594:	64b6                	ld	s1,328(sp)
    80004596:	a285                	j	800046f6 <sys_open+0x1e0>
    if((ip = namei(path)) == 0){
    80004598:	f3040513          	addi	a0,s0,-208
    8000459c:	a31fe0ef          	jal	80002fcc <namei>
    800045a0:	84aa                	mv	s1,a0
    800045a2:	cd09                	beqz	a0,800045bc <sys_open+0xa6>
    ilock(ip);
    800045a4:	96afe0ef          	jal	8000270e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800045a8:	04449703          	lh	a4,68(s1)
    800045ac:	4785                	li	a5,1
    800045ae:	faf717e3          	bne	a4,a5,8000455c <sys_open+0x46>
    800045b2:	f2c42783          	lw	a5,-212(s0)
    800045b6:	eb81                	bnez	a5,800045c6 <sys_open+0xb0>
    800045b8:	fe4e                	sd	s3,312(sp)
    800045ba:	a805                	j	800045ea <sys_open+0xd4>
      end_op();
    800045bc:	c5ffe0ef          	jal	8000321a <end_op>
      return -1;
    800045c0:	557d                	li	a0,-1
    800045c2:	64b6                	ld	s1,328(sp)
    800045c4:	aa0d                	j	800046f6 <sys_open+0x1e0>
      iunlockput(ip);
    800045c6:	8526                	mv	a0,s1
    800045c8:	be0fe0ef          	jal	800029a8 <iunlockput>
      end_op();
    800045cc:	c4ffe0ef          	jal	8000321a <end_op>
      return -1;
    800045d0:	557d                	li	a0,-1
    800045d2:	64b6                	ld	s1,328(sp)
    800045d4:	a20d                	j	800046f6 <sys_open+0x1e0>
  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800045d6:	0464d703          	lhu	a4,70(s1)
    800045da:	47a5                	li	a5,9
    800045dc:	06e7ee63          	bltu	a5,a4,80004658 <sys_open+0x142>
    800045e0:	6916                	ld	s2,320(sp)
    800045e2:	7a52                	ld	s4,304(sp)
    800045e4:	7ab2                	ld	s5,296(sp)
    800045e6:	7b12                	ld	s6,288(sp)
    800045e8:	6bf2                	ld	s7,280(sp)
      end_op();
      return -1;
    }
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800045ea:	f41fe0ef          	jal	8000352a <filealloc>
    800045ee:	89aa                	mv	s3,a0
    800045f0:	12050d63          	beqz	a0,8000472a <sys_open+0x214>
    800045f4:	e2ca                	sd	s2,320(sp)
    800045f6:	9d1ff0ef          	jal	80003fc6 <fdalloc>
    800045fa:	892a                	mv	s2,a0
    800045fc:	12054363          	bltz	a0,80004722 <sys_open+0x20c>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004600:	04449703          	lh	a4,68(s1)
    80004604:	478d                	li	a5,3
    80004606:	12f70b63          	beq	a4,a5,8000473c <sys_open+0x226>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000460a:	4789                	li	a5,2
    8000460c:	00f9a023          	sw	a5,0(s3)
    f->off = 0;
    80004610:	0209a023          	sw	zero,32(s3)
  }
  f->ip = ip;
    80004614:	0099bc23          	sd	s1,24(s3)
  f->readable = !(omode & O_WRONLY);
    80004618:	f2c42783          	lw	a5,-212(s0)
    8000461c:	0017f713          	andi	a4,a5,1
    80004620:	00174713          	xori	a4,a4,1
    80004624:	00e98423          	sb	a4,8(s3)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004628:	0037f713          	andi	a4,a5,3
    8000462c:	00e03733          	snez	a4,a4
    80004630:	00e984a3          	sb	a4,9(s3)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004634:	4007f793          	andi	a5,a5,1024
    80004638:	c791                	beqz	a5,80004644 <sys_open+0x12e>
    8000463a:	04449703          	lh	a4,68(s1)
    8000463e:	4789                	li	a5,2
    80004640:	10f70563          	beq	a4,a5,8000474a <sys_open+0x234>
    itrunc(ip);
  }

  iunlock(ip);
    80004644:	8526                	mv	a0,s1
    80004646:	976fe0ef          	jal	800027bc <iunlock>
  end_op();
    8000464a:	bd1fe0ef          	jal	8000321a <end_op>

  return fd;
    8000464e:	854a                	mv	a0,s2
    80004650:	64b6                	ld	s1,328(sp)
    80004652:	6916                	ld	s2,320(sp)
    80004654:	79f2                	ld	s3,312(sp)
    80004656:	a045                	j	800046f6 <sys_open+0x1e0>
    iunlockput(ip);
    80004658:	8526                	mv	a0,s1
    8000465a:	b4efe0ef          	jal	800029a8 <iunlockput>
    end_op();
    8000465e:	bbdfe0ef          	jal	8000321a <end_op>
    return -1;
    80004662:	557d                	li	a0,-1
    80004664:	64b6                	ld	s1,328(sp)
    80004666:	6916                	ld	s2,320(sp)
    80004668:	79f2                	ld	s3,312(sp)
    8000466a:	7a52                	ld	s4,304(sp)
    8000466c:	7ab2                	ld	s5,296(sp)
    8000466e:	7b12                	ld	s6,288(sp)
    80004670:	6bf2                	ld	s7,280(sp)
    80004672:	a051                	j	800046f6 <sys_open+0x1e0>
      panic("istargetpathempty: sys_open");
    80004674:	00003517          	auipc	a0,0x3
    80004678:	f3c50513          	addi	a0,a0,-196 # 800075b0 <etext+0x5b0>
    8000467c:	31a010ef          	jal	80005996 <panic>
      end_op();
    80004680:	b9bfe0ef          	jal	8000321a <end_op>
      return -1;
    80004684:	a08d                	j	800046e6 <sys_open+0x1d0>
    if(dol > threshold) {
    80004686:	397d                	addiw	s2,s2,-1
    80004688:	04090a63          	beqz	s2,800046dc <sys_open+0x1c6>
  while(ip->type == T_SYMLINK && (omode & O_NOFOLLOW) == 0) {
    8000468c:	04449783          	lh	a5,68(s1)
    80004690:	07779763          	bne	a5,s7,800046fe <sys_open+0x1e8>
    80004694:	f2c42783          	lw	a5,-212(s0)
    80004698:	0147f7b3          	and	a5,a5,s4
    8000469c:	e7bd                	bnez	a5,8000470a <sys_open+0x1f4>
    if(readi(ip, 0, (uint64)tpath, 0, sizeof(tpath)) == 0)
    8000469e:	8756                	mv	a4,s5
    800046a0:	4681                	li	a3,0
    800046a2:	864e                	mv	a2,s3
    800046a4:	4581                	li	a1,0
    800046a6:	8526                	mv	a0,s1
    800046a8:	c86fe0ef          	jal	80002b2e <readi>
    800046ac:	d561                	beqz	a0,80004674 <sys_open+0x15e>
    iunlockput(ip);
    800046ae:	8526                	mv	a0,s1
    800046b0:	af8fe0ef          	jal	800029a8 <iunlockput>
    if((ip = namei(tpath)) == 0){
    800046b4:	854e                	mv	a0,s3
    800046b6:	917fe0ef          	jal	80002fcc <namei>
    800046ba:	84aa                	mv	s1,a0
    800046bc:	d171                	beqz	a0,80004680 <sys_open+0x16a>
    ilock(ip);
    800046be:	850fe0ef          	jal	8000270e <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800046c2:	04449783          	lh	a5,68(s1)
    800046c6:	fd6790e3          	bne	a5,s6,80004686 <sys_open+0x170>
    800046ca:	f2c42783          	lw	a5,-212(s0)
    800046ce:	dfc5                	beqz	a5,80004686 <sys_open+0x170>
      iunlockput(ip);
    800046d0:	8526                	mv	a0,s1
    800046d2:	ad6fe0ef          	jal	800029a8 <iunlockput>
      end_op();
    800046d6:	b45fe0ef          	jal	8000321a <end_op>
      return -1;
    800046da:	a031                	j	800046e6 <sys_open+0x1d0>
      iunlockput(ip);
    800046dc:	8526                	mv	a0,s1
    800046de:	acafe0ef          	jal	800029a8 <iunlockput>
      end_op();
    800046e2:	b39fe0ef          	jal	8000321a <end_op>
      return -1;
    800046e6:	557d                	li	a0,-1
    800046e8:	64b6                	ld	s1,328(sp)
    800046ea:	6916                	ld	s2,320(sp)
    800046ec:	79f2                	ld	s3,312(sp)
    800046ee:	7a52                	ld	s4,304(sp)
    800046f0:	7ab2                	ld	s5,296(sp)
    800046f2:	7b12                	ld	s6,288(sp)
    800046f4:	6bf2                	ld	s7,280(sp)
}
    800046f6:	60f6                	ld	ra,344(sp)
    800046f8:	6456                	ld	s0,336(sp)
    800046fa:	6135                	addi	sp,sp,352
    800046fc:	8082                	ret
    800046fe:	6916                	ld	s2,320(sp)
    80004700:	7a52                	ld	s4,304(sp)
    80004702:	7ab2                	ld	s5,296(sp)
    80004704:	7b12                	ld	s6,288(sp)
    80004706:	6bf2                	ld	s7,280(sp)
    80004708:	b5cd                	j	800045ea <sys_open+0xd4>
    8000470a:	6916                	ld	s2,320(sp)
    8000470c:	7a52                	ld	s4,304(sp)
    8000470e:	7ab2                	ld	s5,296(sp)
    80004710:	7b12                	ld	s6,288(sp)
    80004712:	6bf2                	ld	s7,280(sp)
    80004714:	bdd9                	j	800045ea <sys_open+0xd4>
    80004716:	6916                	ld	s2,320(sp)
    80004718:	7a52                	ld	s4,304(sp)
    8000471a:	7ab2                	ld	s5,296(sp)
    8000471c:	7b12                	ld	s6,288(sp)
    8000471e:	6bf2                	ld	s7,280(sp)
    80004720:	b5e9                	j	800045ea <sys_open+0xd4>
      fileclose(f);
    80004722:	854e                	mv	a0,s3
    80004724:	eabfe0ef          	jal	800035ce <fileclose>
    80004728:	6916                	ld	s2,320(sp)
    iunlockput(ip);
    8000472a:	8526                	mv	a0,s1
    8000472c:	a7cfe0ef          	jal	800029a8 <iunlockput>
    end_op();
    80004730:	aebfe0ef          	jal	8000321a <end_op>
    return -1;
    80004734:	557d                	li	a0,-1
    80004736:	64b6                	ld	s1,328(sp)
    80004738:	79f2                	ld	s3,312(sp)
    8000473a:	bf75                	j	800046f6 <sys_open+0x1e0>
    f->type = FD_DEVICE;
    8000473c:	00e9a023          	sw	a4,0(s3)
    f->major = ip->major;
    80004740:	04649783          	lh	a5,70(s1)
    80004744:	02f99223          	sh	a5,36(s3)
    80004748:	b5f1                	j	80004614 <sys_open+0xfe>
    itrunc(ip);
    8000474a:	8526                	mv	a0,s1
    8000474c:	8b0fe0ef          	jal	800027fc <itrunc>
    80004750:	bdd5                	j	80004644 <sys_open+0x12e>
    return -1;
    80004752:	557d                	li	a0,-1
    80004754:	b74d                	j	800046f6 <sys_open+0x1e0>

0000000080004756 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004756:	7175                	addi	sp,sp,-144
    80004758:	e506                	sd	ra,136(sp)
    8000475a:	e122                	sd	s0,128(sp)
    8000475c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000475e:	a4dfe0ef          	jal	800031aa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004762:	08000613          	li	a2,128
    80004766:	f7040593          	addi	a1,s0,-144
    8000476a:	4501                	li	a0,0
    8000476c:	d6cfd0ef          	jal	80001cd8 <argstr>
    80004770:	02054363          	bltz	a0,80004796 <sys_mkdir+0x40>
    80004774:	4681                	li	a3,0
    80004776:	4601                	li	a2,0
    80004778:	4585                	li	a1,1
    8000477a:	f7040513          	addi	a0,s0,-144
    8000477e:	889ff0ef          	jal	80004006 <create>
    80004782:	c911                	beqz	a0,80004796 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004784:	a24fe0ef          	jal	800029a8 <iunlockput>
  end_op();
    80004788:	a93fe0ef          	jal	8000321a <end_op>
  return 0;
    8000478c:	4501                	li	a0,0
}
    8000478e:	60aa                	ld	ra,136(sp)
    80004790:	640a                	ld	s0,128(sp)
    80004792:	6149                	addi	sp,sp,144
    80004794:	8082                	ret
    end_op();
    80004796:	a85fe0ef          	jal	8000321a <end_op>
    return -1;
    8000479a:	557d                	li	a0,-1
    8000479c:	bfcd                	j	8000478e <sys_mkdir+0x38>

000000008000479e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000479e:	7135                	addi	sp,sp,-160
    800047a0:	ed06                	sd	ra,152(sp)
    800047a2:	e922                	sd	s0,144(sp)
    800047a4:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    800047a6:	a05fe0ef          	jal	800031aa <begin_op>
  argint(1, &major);
    800047aa:	f6c40593          	addi	a1,s0,-148
    800047ae:	4505                	li	a0,1
    800047b0:	cf0fd0ef          	jal	80001ca0 <argint>
  argint(2, &minor);
    800047b4:	f6840593          	addi	a1,s0,-152
    800047b8:	4509                	li	a0,2
    800047ba:	ce6fd0ef          	jal	80001ca0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800047be:	08000613          	li	a2,128
    800047c2:	f7040593          	addi	a1,s0,-144
    800047c6:	4501                	li	a0,0
    800047c8:	d10fd0ef          	jal	80001cd8 <argstr>
    800047cc:	02054563          	bltz	a0,800047f6 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800047d0:	f6841683          	lh	a3,-152(s0)
    800047d4:	f6c41603          	lh	a2,-148(s0)
    800047d8:	458d                	li	a1,3
    800047da:	f7040513          	addi	a0,s0,-144
    800047de:	829ff0ef          	jal	80004006 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800047e2:	c911                	beqz	a0,800047f6 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800047e4:	9c4fe0ef          	jal	800029a8 <iunlockput>
  end_op();
    800047e8:	a33fe0ef          	jal	8000321a <end_op>
  return 0;
    800047ec:	4501                	li	a0,0
}
    800047ee:	60ea                	ld	ra,152(sp)
    800047f0:	644a                	ld	s0,144(sp)
    800047f2:	610d                	addi	sp,sp,160
    800047f4:	8082                	ret
    end_op();
    800047f6:	a25fe0ef          	jal	8000321a <end_op>
    return -1;
    800047fa:	557d                	li	a0,-1
    800047fc:	bfcd                	j	800047ee <sys_mknod+0x50>

00000000800047fe <sys_chdir>:

uint64
sys_chdir(void)
{
    800047fe:	7135                	addi	sp,sp,-160
    80004800:	ed06                	sd	ra,152(sp)
    80004802:	e922                	sd	s0,144(sp)
    80004804:	e14a                	sd	s2,128(sp)
    80004806:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004808:	d8cfc0ef          	jal	80000d94 <myproc>
    8000480c:	892a                	mv	s2,a0
  
  begin_op();
    8000480e:	99dfe0ef          	jal	800031aa <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004812:	08000613          	li	a2,128
    80004816:	f6040593          	addi	a1,s0,-160
    8000481a:	4501                	li	a0,0
    8000481c:	cbcfd0ef          	jal	80001cd8 <argstr>
    80004820:	04054363          	bltz	a0,80004866 <sys_chdir+0x68>
    80004824:	e526                	sd	s1,136(sp)
    80004826:	f6040513          	addi	a0,s0,-160
    8000482a:	fa2fe0ef          	jal	80002fcc <namei>
    8000482e:	84aa                	mv	s1,a0
    80004830:	c915                	beqz	a0,80004864 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004832:	eddfd0ef          	jal	8000270e <ilock>
  if(ip->type != T_DIR){
    80004836:	04449703          	lh	a4,68(s1)
    8000483a:	4785                	li	a5,1
    8000483c:	02f71963          	bne	a4,a5,8000486e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004840:	8526                	mv	a0,s1
    80004842:	f7bfd0ef          	jal	800027bc <iunlock>
  iput(p->cwd);
    80004846:	15093503          	ld	a0,336(s2)
    8000484a:	8d4fe0ef          	jal	8000291e <iput>
  end_op();
    8000484e:	9cdfe0ef          	jal	8000321a <end_op>
  p->cwd = ip;
    80004852:	14993823          	sd	s1,336(s2)
  return 0;
    80004856:	4501                	li	a0,0
    80004858:	64aa                	ld	s1,136(sp)
}
    8000485a:	60ea                	ld	ra,152(sp)
    8000485c:	644a                	ld	s0,144(sp)
    8000485e:	690a                	ld	s2,128(sp)
    80004860:	610d                	addi	sp,sp,160
    80004862:	8082                	ret
    80004864:	64aa                	ld	s1,136(sp)
    end_op();
    80004866:	9b5fe0ef          	jal	8000321a <end_op>
    return -1;
    8000486a:	557d                	li	a0,-1
    8000486c:	b7fd                	j	8000485a <sys_chdir+0x5c>
    iunlockput(ip);
    8000486e:	8526                	mv	a0,s1
    80004870:	938fe0ef          	jal	800029a8 <iunlockput>
    end_op();
    80004874:	9a7fe0ef          	jal	8000321a <end_op>
    return -1;
    80004878:	557d                	li	a0,-1
    8000487a:	64aa                	ld	s1,136(sp)
    8000487c:	bff9                	j	8000485a <sys_chdir+0x5c>

000000008000487e <sys_exec>:

uint64
sys_exec(void)
{
    8000487e:	7105                	addi	sp,sp,-480
    80004880:	ef86                	sd	ra,472(sp)
    80004882:	eba2                	sd	s0,464(sp)
    80004884:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004886:	e2840593          	addi	a1,s0,-472
    8000488a:	4505                	li	a0,1
    8000488c:	c30fd0ef          	jal	80001cbc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004890:	08000613          	li	a2,128
    80004894:	f3040593          	addi	a1,s0,-208
    80004898:	4501                	li	a0,0
    8000489a:	c3efd0ef          	jal	80001cd8 <argstr>
    8000489e:	87aa                	mv	a5,a0
    return -1;
    800048a0:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    800048a2:	0e07c063          	bltz	a5,80004982 <sys_exec+0x104>
    800048a6:	e7a6                	sd	s1,456(sp)
    800048a8:	e3ca                	sd	s2,448(sp)
    800048aa:	ff4e                	sd	s3,440(sp)
    800048ac:	fb52                	sd	s4,432(sp)
    800048ae:	f756                	sd	s5,424(sp)
    800048b0:	f35a                	sd	s6,416(sp)
    800048b2:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    800048b4:	e3040a13          	addi	s4,s0,-464
    800048b8:	10000613          	li	a2,256
    800048bc:	4581                	li	a1,0
    800048be:	8552                	mv	a0,s4
    800048c0:	89ffb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    800048c4:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    800048c6:	89d2                	mv	s3,s4
    800048c8:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800048ca:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800048ce:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800048d0:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800048d4:	00391513          	slli	a0,s2,0x3
    800048d8:	85d6                	mv	a1,s5
    800048da:	e2843783          	ld	a5,-472(s0)
    800048de:	953e                	add	a0,a0,a5
    800048e0:	b36fd0ef          	jal	80001c16 <fetchaddr>
    800048e4:	02054663          	bltz	a0,80004910 <sys_exec+0x92>
    if(uarg == 0){
    800048e8:	e2043783          	ld	a5,-480(s0)
    800048ec:	c7a1                	beqz	a5,80004934 <sys_exec+0xb6>
    argv[i] = kalloc();
    800048ee:	817fb0ef          	jal	80000104 <kalloc>
    800048f2:	85aa                	mv	a1,a0
    800048f4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800048f8:	cd01                	beqz	a0,80004910 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800048fa:	865a                	mv	a2,s6
    800048fc:	e2043503          	ld	a0,-480(s0)
    80004900:	b60fd0ef          	jal	80001c60 <fetchstr>
    80004904:	00054663          	bltz	a0,80004910 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004908:	0905                	addi	s2,s2,1
    8000490a:	09a1                	addi	s3,s3,8
    8000490c:	fd7914e3          	bne	s2,s7,800048d4 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004910:	100a0a13          	addi	s4,s4,256
    80004914:	6088                	ld	a0,0(s1)
    80004916:	cd31                	beqz	a0,80004972 <sys_exec+0xf4>
    kfree(argv[i]);
    80004918:	f04fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000491c:	04a1                	addi	s1,s1,8
    8000491e:	ff449be3          	bne	s1,s4,80004914 <sys_exec+0x96>
  return -1;
    80004922:	557d                	li	a0,-1
    80004924:	64be                	ld	s1,456(sp)
    80004926:	691e                	ld	s2,448(sp)
    80004928:	79fa                	ld	s3,440(sp)
    8000492a:	7a5a                	ld	s4,432(sp)
    8000492c:	7aba                	ld	s5,424(sp)
    8000492e:	7b1a                	ld	s6,416(sp)
    80004930:	6bfa                	ld	s7,408(sp)
    80004932:	a881                	j	80004982 <sys_exec+0x104>
      argv[i] = 0;
    80004934:	0009079b          	sext.w	a5,s2
    80004938:	e3040593          	addi	a1,s0,-464
    8000493c:	078e                	slli	a5,a5,0x3
    8000493e:	97ae                	add	a5,a5,a1
    80004940:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004944:	f3040513          	addi	a0,s0,-208
    80004948:	ac8ff0ef          	jal	80003c10 <kexec>
    8000494c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000494e:	100a0a13          	addi	s4,s4,256
    80004952:	6088                	ld	a0,0(s1)
    80004954:	c511                	beqz	a0,80004960 <sys_exec+0xe2>
    kfree(argv[i]);
    80004956:	ec6fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000495a:	04a1                	addi	s1,s1,8
    8000495c:	ff449be3          	bne	s1,s4,80004952 <sys_exec+0xd4>
  return ret;
    80004960:	854a                	mv	a0,s2
    80004962:	64be                	ld	s1,456(sp)
    80004964:	691e                	ld	s2,448(sp)
    80004966:	79fa                	ld	s3,440(sp)
    80004968:	7a5a                	ld	s4,432(sp)
    8000496a:	7aba                	ld	s5,424(sp)
    8000496c:	7b1a                	ld	s6,416(sp)
    8000496e:	6bfa                	ld	s7,408(sp)
    80004970:	a809                	j	80004982 <sys_exec+0x104>
  return -1;
    80004972:	557d                	li	a0,-1
    80004974:	64be                	ld	s1,456(sp)
    80004976:	691e                	ld	s2,448(sp)
    80004978:	79fa                	ld	s3,440(sp)
    8000497a:	7a5a                	ld	s4,432(sp)
    8000497c:	7aba                	ld	s5,424(sp)
    8000497e:	7b1a                	ld	s6,416(sp)
    80004980:	6bfa                	ld	s7,408(sp)
}
    80004982:	60fe                	ld	ra,472(sp)
    80004984:	645e                	ld	s0,464(sp)
    80004986:	613d                	addi	sp,sp,480
    80004988:	8082                	ret

000000008000498a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000498a:	7139                	addi	sp,sp,-64
    8000498c:	fc06                	sd	ra,56(sp)
    8000498e:	f822                	sd	s0,48(sp)
    80004990:	f426                	sd	s1,40(sp)
    80004992:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004994:	c00fc0ef          	jal	80000d94 <myproc>
    80004998:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000499a:	fd840593          	addi	a1,s0,-40
    8000499e:	4501                	li	a0,0
    800049a0:	b1cfd0ef          	jal	80001cbc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    800049a4:	fc840593          	addi	a1,s0,-56
    800049a8:	fd040513          	addi	a0,s0,-48
    800049ac:	f3ffe0ef          	jal	800038ea <pipealloc>
    return -1;
    800049b0:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    800049b2:	0a054763          	bltz	a0,80004a60 <sys_pipe+0xd6>
  fd0 = -1;
    800049b6:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    800049ba:	fd043503          	ld	a0,-48(s0)
    800049be:	e08ff0ef          	jal	80003fc6 <fdalloc>
    800049c2:	fca42223          	sw	a0,-60(s0)
    800049c6:	08054463          	bltz	a0,80004a4e <sys_pipe+0xc4>
    800049ca:	fc843503          	ld	a0,-56(s0)
    800049ce:	df8ff0ef          	jal	80003fc6 <fdalloc>
    800049d2:	fca42023          	sw	a0,-64(s0)
    800049d6:	06054263          	bltz	a0,80004a3a <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800049da:	4691                	li	a3,4
    800049dc:	fc440613          	addi	a2,s0,-60
    800049e0:	fd843583          	ld	a1,-40(s0)
    800049e4:	68a8                	ld	a0,80(s1)
    800049e6:	8d4fc0ef          	jal	80000aba <copyout>
    800049ea:	00054e63          	bltz	a0,80004a06 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800049ee:	4691                	li	a3,4
    800049f0:	fc040613          	addi	a2,s0,-64
    800049f4:	fd843583          	ld	a1,-40(s0)
    800049f8:	95b6                	add	a1,a1,a3
    800049fa:	68a8                	ld	a0,80(s1)
    800049fc:	8befc0ef          	jal	80000aba <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004a00:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a02:	04055f63          	bgez	a0,80004a60 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80004a06:	fc442783          	lw	a5,-60(s0)
    80004a0a:	078e                	slli	a5,a5,0x3
    80004a0c:	0d078793          	addi	a5,a5,208
    80004a10:	97a6                	add	a5,a5,s1
    80004a12:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004a16:	fc042783          	lw	a5,-64(s0)
    80004a1a:	078e                	slli	a5,a5,0x3
    80004a1c:	0d078793          	addi	a5,a5,208
    80004a20:	97a6                	add	a5,a5,s1
    80004a22:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004a26:	fd043503          	ld	a0,-48(s0)
    80004a2a:	ba5fe0ef          	jal	800035ce <fileclose>
    fileclose(wf);
    80004a2e:	fc843503          	ld	a0,-56(s0)
    80004a32:	b9dfe0ef          	jal	800035ce <fileclose>
    return -1;
    80004a36:	57fd                	li	a5,-1
    80004a38:	a025                	j	80004a60 <sys_pipe+0xd6>
    if(fd0 >= 0)
    80004a3a:	fc442783          	lw	a5,-60(s0)
    80004a3e:	0007c863          	bltz	a5,80004a4e <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004a42:	078e                	slli	a5,a5,0x3
    80004a44:	0d078793          	addi	a5,a5,208
    80004a48:	97a6                	add	a5,a5,s1
    80004a4a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004a4e:	fd043503          	ld	a0,-48(s0)
    80004a52:	b7dfe0ef          	jal	800035ce <fileclose>
    fileclose(wf);
    80004a56:	fc843503          	ld	a0,-56(s0)
    80004a5a:	b75fe0ef          	jal	800035ce <fileclose>
    return -1;
    80004a5e:	57fd                	li	a5,-1
}
    80004a60:	853e                	mv	a0,a5
    80004a62:	70e2                	ld	ra,56(sp)
    80004a64:	7442                	ld	s0,48(sp)
    80004a66:	74a2                	ld	s1,40(sp)
    80004a68:	6121                	addi	sp,sp,64
    80004a6a:	8082                	ret

0000000080004a6c <sys_symlink>:


uint64
sys_symlink(void)
{
    80004a6c:	7129                	addi	sp,sp,-320
    80004a6e:	fe06                	sd	ra,312(sp)
    80004a70:	fa22                	sd	s0,304(sp)
    80004a72:	ee4e                	sd	s3,280(sp)
    80004a74:	0280                	addi	s0,sp,320
  char target[MAXPATH];
  char name[DIRSIZ];
  struct inode *dp, *ip;
  uint len;

  if((len = argstr(0, target, MAXPATH)) < 0)
    80004a76:	08000613          	li	a2,128
    80004a7a:	ed040593          	addi	a1,s0,-304
    80004a7e:	4501                	li	a0,0
    80004a80:	a58fd0ef          	jal	80001cd8 <argstr>
    80004a84:	89aa                	mv	s3,a0
    return -1;

  if(argstr(1, path, MAXPATH) < 0)
    80004a86:	08000613          	li	a2,128
    80004a8a:	f5040593          	addi	a1,s0,-176
    80004a8e:	4505                	li	a0,1
    80004a90:	a48fd0ef          	jal	80001cd8 <argstr>
    return -1;
    80004a94:	57fd                	li	a5,-1
  if(argstr(1, path, MAXPATH) < 0)
    80004a96:	0a054263          	bltz	a0,80004b3a <sys_symlink+0xce>
    80004a9a:	f626                	sd	s1,296(sp)

  // BEGIN
  begin_op();
    80004a9c:	f0efe0ef          	jal	800031aa <begin_op>

  // Find pareent directory of path
  dp = nameiparent(path, name);
    80004aa0:	ec040593          	addi	a1,s0,-320
    80004aa4:	f5040513          	addi	a0,s0,-176
    80004aa8:	d3efe0ef          	jal	80002fe6 <nameiparent>
    80004aac:	84aa                	mv	s1,a0
  if(dp == 0) {
    80004aae:	c935                	beqz	a0,80004b22 <sys_symlink+0xb6>
    end_op();
    return -1;
  }
  ilock(dp);
    80004ab0:	c5ffd0ef          	jal	8000270e <ilock>

  // Fail if name already exists
  if(dirlookup(dp, name, 0) != 0) {
    80004ab4:	4601                	li	a2,0
    80004ab6:	ec040593          	addi	a1,s0,-320
    80004aba:	8526                	mv	a0,s1
    80004abc:	a7cfe0ef          	jal	80002d38 <dirlookup>
    80004ac0:	e535                	bnez	a0,80004b2c <sys_symlink+0xc0>
    80004ac2:	f24a                	sd	s2,288(sp)
    end_op();
    return -1;
  }

  // Create a path inode
  ip = ialloc(dp->dev, T_SYMLINK);
    80004ac4:	4591                	li	a1,4
    80004ac6:	4088                	lw	a0,0(s1)
    80004ac8:	ad7fd0ef          	jal	8000259e <ialloc>
    80004acc:	892a                	mv	s2,a0
  if(ip == 0) {
    80004ace:	cd25                	beqz	a0,80004b46 <sys_symlink+0xda>
    iunlockput(dp);
    end_op();
    return -1;
  }

  ilock(ip);
    80004ad0:	c3ffd0ef          	jal	8000270e <ilock>

  // Write target path to path data block
  if(writei(ip, 0, (uint64)target, 0, len) != len) {
    80004ad4:	874e                	mv	a4,s3
    80004ad6:	4681                	li	a3,0
    80004ad8:	ed040613          	addi	a2,s0,-304
    80004adc:	4581                	li	a1,0
    80004ade:	854a                	mv	a0,s2
    80004ae0:	940fe0ef          	jal	80002c20 <writei>
    80004ae4:	06a99a63          	bne	s3,a0,80004b58 <sys_symlink+0xec>
    end_op();
    return -1;
  }

  // Add directory entry
  if(dirlink(dp, name, ip->inum) < 0) {
    80004ae8:	00492603          	lw	a2,4(s2)
    80004aec:	ec040593          	addi	a1,s0,-320
    80004af0:	8526                	mv	a0,s1
    80004af2:	c30fe0ef          	jal	80002f22 <dirlink>
    80004af6:	08054063          	bltz	a0,80004b76 <sys_symlink+0x10a>
    end_op();
    return -1;
  }

  // Update inode metadata
  ip->size = len;
    80004afa:	05392623          	sw	s3,76(s2)
  ip->nlink = 1;
    80004afe:	4785                	li	a5,1
    80004b00:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004b04:	854a                	mv	a0,s2
    80004b06:	b55fd0ef          	jal	8000265a <iupdate>

  // End
  iunlockput(dp);
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	e9dfd0ef          	jal	800029a8 <iunlockput>
  iunlockput(ip);
    80004b10:	854a                	mv	a0,s2
    80004b12:	e97fd0ef          	jal	800029a8 <iunlockput>
  end_op();
    80004b16:	f04fe0ef          	jal	8000321a <end_op>

  return 0;
    80004b1a:	4781                	li	a5,0
    80004b1c:	74b2                	ld	s1,296(sp)
    80004b1e:	7912                	ld	s2,288(sp)
    80004b20:	a829                	j	80004b3a <sys_symlink+0xce>
    end_op();
    80004b22:	ef8fe0ef          	jal	8000321a <end_op>
    return -1;
    80004b26:	57fd                	li	a5,-1
    80004b28:	74b2                	ld	s1,296(sp)
    80004b2a:	a801                	j	80004b3a <sys_symlink+0xce>
    iunlockput(dp);
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	e7bfd0ef          	jal	800029a8 <iunlockput>
    end_op();
    80004b32:	ee8fe0ef          	jal	8000321a <end_op>
    return -1;
    80004b36:	57fd                	li	a5,-1
    80004b38:	74b2                	ld	s1,296(sp)
}
    80004b3a:	853e                	mv	a0,a5
    80004b3c:	70f2                	ld	ra,312(sp)
    80004b3e:	7452                	ld	s0,304(sp)
    80004b40:	69f2                	ld	s3,280(sp)
    80004b42:	6131                	addi	sp,sp,320
    80004b44:	8082                	ret
    iunlockput(dp);
    80004b46:	8526                	mv	a0,s1
    80004b48:	e61fd0ef          	jal	800029a8 <iunlockput>
    end_op();
    80004b4c:	ecefe0ef          	jal	8000321a <end_op>
    return -1;
    80004b50:	57fd                	li	a5,-1
    80004b52:	74b2                	ld	s1,296(sp)
    80004b54:	7912                	ld	s2,288(sp)
    80004b56:	b7d5                	j	80004b3a <sys_symlink+0xce>
    itrunc(ip);
    80004b58:	854a                	mv	a0,s2
    80004b5a:	ca3fd0ef          	jal	800027fc <itrunc>
    iunlockput(dp);
    80004b5e:	8526                	mv	a0,s1
    80004b60:	e49fd0ef          	jal	800029a8 <iunlockput>
    iunlockput(ip);
    80004b64:	854a                	mv	a0,s2
    80004b66:	e43fd0ef          	jal	800029a8 <iunlockput>
    end_op();
    80004b6a:	eb0fe0ef          	jal	8000321a <end_op>
    return -1;
    80004b6e:	57fd                	li	a5,-1
    80004b70:	74b2                	ld	s1,296(sp)
    80004b72:	7912                	ld	s2,288(sp)
    80004b74:	b7d9                	j	80004b3a <sys_symlink+0xce>
    itrunc(ip);
    80004b76:	854a                	mv	a0,s2
    80004b78:	c85fd0ef          	jal	800027fc <itrunc>
    iunlockput(ip);
    80004b7c:	854a                	mv	a0,s2
    80004b7e:	e2bfd0ef          	jal	800029a8 <iunlockput>
    iunlockput(dp);
    80004b82:	8526                	mv	a0,s1
    80004b84:	e25fd0ef          	jal	800029a8 <iunlockput>
    end_op();
    80004b88:	e92fe0ef          	jal	8000321a <end_op>
    return -1;
    80004b8c:	57fd                	li	a5,-1
    80004b8e:	74b2                	ld	s1,296(sp)
    80004b90:	7912                	ld	s2,288(sp)
    80004b92:	b765                	j	80004b3a <sys_symlink+0xce>
	...

0000000080004ba0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004ba0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004ba2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004ba4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004ba6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004ba8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80004baa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80004bac:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80004bae:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004bb0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004bb2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004bb4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004bb6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004bb8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80004bba:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80004bbc:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80004bbe:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004bc0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004bc2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004bc4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004bc6:	f5ffc0ef          	jal	80001b24 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80004bca:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80004bcc:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80004bce:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004bd0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004bd2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004bd4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004bd6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004bd8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80004bda:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80004bdc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80004bde:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004be0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004be2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004be4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004be6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004be8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80004bea:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80004bec:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80004bee:	10200073          	sret
    80004bf2:	00000013          	nop
    80004bf6:	00000013          	nop
    80004bfa:	00000013          	nop

0000000080004bfe <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004bfe:	1141                	addi	sp,sp,-16
    80004c00:	e406                	sd	ra,8(sp)
    80004c02:	e022                	sd	s0,0(sp)
    80004c04:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004c06:	0c000737          	lui	a4,0xc000
    80004c0a:	4785                	li	a5,1
    80004c0c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004c0e:	c35c                	sw	a5,4(a4)
}
    80004c10:	60a2                	ld	ra,8(sp)
    80004c12:	6402                	ld	s0,0(sp)
    80004c14:	0141                	addi	sp,sp,16
    80004c16:	8082                	ret

0000000080004c18 <plicinithart>:

void
plicinithart(void)
{
    80004c18:	1141                	addi	sp,sp,-16
    80004c1a:	e406                	sd	ra,8(sp)
    80004c1c:	e022                	sd	s0,0(sp)
    80004c1e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004c20:	940fc0ef          	jal	80000d60 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004c24:	0085171b          	slliw	a4,a0,0x8
    80004c28:	0c0027b7          	lui	a5,0xc002
    80004c2c:	97ba                	add	a5,a5,a4
    80004c2e:	40200713          	li	a4,1026
    80004c32:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004c36:	00d5151b          	slliw	a0,a0,0xd
    80004c3a:	0c2017b7          	lui	a5,0xc201
    80004c3e:	97aa                	add	a5,a5,a0
    80004c40:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004c44:	60a2                	ld	ra,8(sp)
    80004c46:	6402                	ld	s0,0(sp)
    80004c48:	0141                	addi	sp,sp,16
    80004c4a:	8082                	ret

0000000080004c4c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004c4c:	1141                	addi	sp,sp,-16
    80004c4e:	e406                	sd	ra,8(sp)
    80004c50:	e022                	sd	s0,0(sp)
    80004c52:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004c54:	90cfc0ef          	jal	80000d60 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004c58:	00d5151b          	slliw	a0,a0,0xd
    80004c5c:	0c2017b7          	lui	a5,0xc201
    80004c60:	97aa                	add	a5,a5,a0
  return irq;
}
    80004c62:	43c8                	lw	a0,4(a5)
    80004c64:	60a2                	ld	ra,8(sp)
    80004c66:	6402                	ld	s0,0(sp)
    80004c68:	0141                	addi	sp,sp,16
    80004c6a:	8082                	ret

0000000080004c6c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004c6c:	1101                	addi	sp,sp,-32
    80004c6e:	ec06                	sd	ra,24(sp)
    80004c70:	e822                	sd	s0,16(sp)
    80004c72:	e426                	sd	s1,8(sp)
    80004c74:	1000                	addi	s0,sp,32
    80004c76:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004c78:	8e8fc0ef          	jal	80000d60 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004c7c:	00d5179b          	slliw	a5,a0,0xd
    80004c80:	0c201737          	lui	a4,0xc201
    80004c84:	97ba                	add	a5,a5,a4
    80004c86:	c3c4                	sw	s1,4(a5)
}
    80004c88:	60e2                	ld	ra,24(sp)
    80004c8a:	6442                	ld	s0,16(sp)
    80004c8c:	64a2                	ld	s1,8(sp)
    80004c8e:	6105                	addi	sp,sp,32
    80004c90:	8082                	ret

0000000080004c92 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004c92:	1141                	addi	sp,sp,-16
    80004c94:	e406                	sd	ra,8(sp)
    80004c96:	e022                	sd	s0,0(sp)
    80004c98:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004c9a:	479d                	li	a5,7
    80004c9c:	04a7ca63          	blt	a5,a0,80004cf0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004ca0:	0000f797          	auipc	a5,0xf
    80004ca4:	0f078793          	addi	a5,a5,240 # 80013d90 <disk>
    80004ca8:	97aa                	add	a5,a5,a0
    80004caa:	0187c783          	lbu	a5,24(a5)
    80004cae:	e7b9                	bnez	a5,80004cfc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004cb0:	00451693          	slli	a3,a0,0x4
    80004cb4:	0000f797          	auipc	a5,0xf
    80004cb8:	0dc78793          	addi	a5,a5,220 # 80013d90 <disk>
    80004cbc:	6398                	ld	a4,0(a5)
    80004cbe:	9736                	add	a4,a4,a3
    80004cc0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004cc4:	6398                	ld	a4,0(a5)
    80004cc6:	9736                	add	a4,a4,a3
    80004cc8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004ccc:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004cd0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004cd4:	97aa                	add	a5,a5,a0
    80004cd6:	4705                	li	a4,1
    80004cd8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004cdc:	0000f517          	auipc	a0,0xf
    80004ce0:	0cc50513          	addi	a0,a0,204 # 80013da8 <disk+0x18>
    80004ce4:	f02fc0ef          	jal	800013e6 <wakeup>
}
    80004ce8:	60a2                	ld	ra,8(sp)
    80004cea:	6402                	ld	s0,0(sp)
    80004cec:	0141                	addi	sp,sp,16
    80004cee:	8082                	ret
    panic("free_desc 1");
    80004cf0:	00003517          	auipc	a0,0x3
    80004cf4:	8e050513          	addi	a0,a0,-1824 # 800075d0 <etext+0x5d0>
    80004cf8:	49f000ef          	jal	80005996 <panic>
    panic("free_desc 2");
    80004cfc:	00003517          	auipc	a0,0x3
    80004d00:	8e450513          	addi	a0,a0,-1820 # 800075e0 <etext+0x5e0>
    80004d04:	493000ef          	jal	80005996 <panic>

0000000080004d08 <virtio_disk_init>:
{
    80004d08:	1101                	addi	sp,sp,-32
    80004d0a:	ec06                	sd	ra,24(sp)
    80004d0c:	e822                	sd	s0,16(sp)
    80004d0e:	e426                	sd	s1,8(sp)
    80004d10:	e04a                	sd	s2,0(sp)
    80004d12:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004d14:	00003597          	auipc	a1,0x3
    80004d18:	8dc58593          	addi	a1,a1,-1828 # 800075f0 <etext+0x5f0>
    80004d1c:	0000f517          	auipc	a0,0xf
    80004d20:	19c50513          	addi	a0,a0,412 # 80013eb8 <disk+0x128>
    80004d24:	6ab000ef          	jal	80005bce <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004d28:	100017b7          	lui	a5,0x10001
    80004d2c:	4398                	lw	a4,0(a5)
    80004d2e:	2701                	sext.w	a4,a4
    80004d30:	747277b7          	lui	a5,0x74727
    80004d34:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004d38:	14f71863          	bne	a4,a5,80004e88 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004d3c:	100017b7          	lui	a5,0x10001
    80004d40:	43dc                	lw	a5,4(a5)
    80004d42:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004d44:	4709                	li	a4,2
    80004d46:	14e79163          	bne	a5,a4,80004e88 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004d4a:	100017b7          	lui	a5,0x10001
    80004d4e:	479c                	lw	a5,8(a5)
    80004d50:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004d52:	12e79b63          	bne	a5,a4,80004e88 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004d56:	100017b7          	lui	a5,0x10001
    80004d5a:	47d8                	lw	a4,12(a5)
    80004d5c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004d5e:	554d47b7          	lui	a5,0x554d4
    80004d62:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004d66:	12f71163          	bne	a4,a5,80004e88 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004d6a:	100017b7          	lui	a5,0x10001
    80004d6e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004d72:	4705                	li	a4,1
    80004d74:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004d76:	470d                	li	a4,3
    80004d78:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004d7a:	10001737          	lui	a4,0x10001
    80004d7e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004d80:	c7ffe6b7          	lui	a3,0xc7ffe
    80004d84:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fe27b7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004d88:	8f75                	and	a4,a4,a3
    80004d8a:	100016b7          	lui	a3,0x10001
    80004d8e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004d90:	472d                	li	a4,11
    80004d92:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004d94:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004d98:	439c                	lw	a5,0(a5)
    80004d9a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004d9e:	8ba1                	andi	a5,a5,8
    80004da0:	0e078a63          	beqz	a5,80004e94 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004da4:	100017b7          	lui	a5,0x10001
    80004da8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004dac:	43fc                	lw	a5,68(a5)
    80004dae:	2781                	sext.w	a5,a5
    80004db0:	0e079863          	bnez	a5,80004ea0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004db4:	100017b7          	lui	a5,0x10001
    80004db8:	5bdc                	lw	a5,52(a5)
    80004dba:	2781                	sext.w	a5,a5
  if(max == 0)
    80004dbc:	0e078863          	beqz	a5,80004eac <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004dc0:	471d                	li	a4,7
    80004dc2:	0ef77b63          	bgeu	a4,a5,80004eb8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004dc6:	b3efb0ef          	jal	80000104 <kalloc>
    80004dca:	0000f497          	auipc	s1,0xf
    80004dce:	fc648493          	addi	s1,s1,-58 # 80013d90 <disk>
    80004dd2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004dd4:	b30fb0ef          	jal	80000104 <kalloc>
    80004dd8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004dda:	b2afb0ef          	jal	80000104 <kalloc>
    80004dde:	87aa                	mv	a5,a0
    80004de0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004de2:	6088                	ld	a0,0(s1)
    80004de4:	0e050063          	beqz	a0,80004ec4 <virtio_disk_init+0x1bc>
    80004de8:	0000f717          	auipc	a4,0xf
    80004dec:	fb073703          	ld	a4,-80(a4) # 80013d98 <disk+0x8>
    80004df0:	cb71                	beqz	a4,80004ec4 <virtio_disk_init+0x1bc>
    80004df2:	cbe9                	beqz	a5,80004ec4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004df4:	6605                	lui	a2,0x1
    80004df6:	4581                	li	a1,0
    80004df8:	b66fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004dfc:	0000f497          	auipc	s1,0xf
    80004e00:	f9448493          	addi	s1,s1,-108 # 80013d90 <disk>
    80004e04:	6605                	lui	a2,0x1
    80004e06:	4581                	li	a1,0
    80004e08:	6488                	ld	a0,8(s1)
    80004e0a:	b54fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    80004e0e:	6605                	lui	a2,0x1
    80004e10:	4581                	li	a1,0
    80004e12:	6888                	ld	a0,16(s1)
    80004e14:	b4afb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004e18:	100017b7          	lui	a5,0x10001
    80004e1c:	4721                	li	a4,8
    80004e1e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004e20:	4098                	lw	a4,0(s1)
    80004e22:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004e26:	40d8                	lw	a4,4(s1)
    80004e28:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004e2c:	649c                	ld	a5,8(s1)
    80004e2e:	0007869b          	sext.w	a3,a5
    80004e32:	10001737          	lui	a4,0x10001
    80004e36:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004e3a:	9781                	srai	a5,a5,0x20
    80004e3c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004e40:	689c                	ld	a5,16(s1)
    80004e42:	0007869b          	sext.w	a3,a5
    80004e46:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004e4a:	9781                	srai	a5,a5,0x20
    80004e4c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004e50:	4785                	li	a5,1
    80004e52:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004e54:	00f48c23          	sb	a5,24(s1)
    80004e58:	00f48ca3          	sb	a5,25(s1)
    80004e5c:	00f48d23          	sb	a5,26(s1)
    80004e60:	00f48da3          	sb	a5,27(s1)
    80004e64:	00f48e23          	sb	a5,28(s1)
    80004e68:	00f48ea3          	sb	a5,29(s1)
    80004e6c:	00f48f23          	sb	a5,30(s1)
    80004e70:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004e74:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004e78:	07272823          	sw	s2,112(a4)
}
    80004e7c:	60e2                	ld	ra,24(sp)
    80004e7e:	6442                	ld	s0,16(sp)
    80004e80:	64a2                	ld	s1,8(sp)
    80004e82:	6902                	ld	s2,0(sp)
    80004e84:	6105                	addi	sp,sp,32
    80004e86:	8082                	ret
    panic("could not find virtio disk");
    80004e88:	00002517          	auipc	a0,0x2
    80004e8c:	77850513          	addi	a0,a0,1912 # 80007600 <etext+0x600>
    80004e90:	307000ef          	jal	80005996 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004e94:	00002517          	auipc	a0,0x2
    80004e98:	78c50513          	addi	a0,a0,1932 # 80007620 <etext+0x620>
    80004e9c:	2fb000ef          	jal	80005996 <panic>
    panic("virtio disk should not be ready");
    80004ea0:	00002517          	auipc	a0,0x2
    80004ea4:	7a050513          	addi	a0,a0,1952 # 80007640 <etext+0x640>
    80004ea8:	2ef000ef          	jal	80005996 <panic>
    panic("virtio disk has no queue 0");
    80004eac:	00002517          	auipc	a0,0x2
    80004eb0:	7b450513          	addi	a0,a0,1972 # 80007660 <etext+0x660>
    80004eb4:	2e3000ef          	jal	80005996 <panic>
    panic("virtio disk max queue too short");
    80004eb8:	00002517          	auipc	a0,0x2
    80004ebc:	7c850513          	addi	a0,a0,1992 # 80007680 <etext+0x680>
    80004ec0:	2d7000ef          	jal	80005996 <panic>
    panic("virtio disk kalloc");
    80004ec4:	00002517          	auipc	a0,0x2
    80004ec8:	7dc50513          	addi	a0,a0,2012 # 800076a0 <etext+0x6a0>
    80004ecc:	2cb000ef          	jal	80005996 <panic>

0000000080004ed0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004ed0:	711d                	addi	sp,sp,-96
    80004ed2:	ec86                	sd	ra,88(sp)
    80004ed4:	e8a2                	sd	s0,80(sp)
    80004ed6:	e4a6                	sd	s1,72(sp)
    80004ed8:	e0ca                	sd	s2,64(sp)
    80004eda:	fc4e                	sd	s3,56(sp)
    80004edc:	f852                	sd	s4,48(sp)
    80004ede:	f456                	sd	s5,40(sp)
    80004ee0:	f05a                	sd	s6,32(sp)
    80004ee2:	ec5e                	sd	s7,24(sp)
    80004ee4:	e862                	sd	s8,16(sp)
    80004ee6:	1080                	addi	s0,sp,96
    80004ee8:	89aa                	mv	s3,a0
    80004eea:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004eec:	00c52b83          	lw	s7,12(a0)
    80004ef0:	001b9b9b          	slliw	s7,s7,0x1
    80004ef4:	1b82                	slli	s7,s7,0x20
    80004ef6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004efa:	0000f517          	auipc	a0,0xf
    80004efe:	fbe50513          	addi	a0,a0,-66 # 80013eb8 <disk+0x128>
    80004f02:	557000ef          	jal	80005c58 <acquire>
  for(int i = 0; i < NUM; i++){
    80004f06:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004f08:	0000fa97          	auipc	s5,0xf
    80004f0c:	e88a8a93          	addi	s5,s5,-376 # 80013d90 <disk>
  for(int i = 0; i < 3; i++){
    80004f10:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004f12:	5c7d                	li	s8,-1
    80004f14:	a095                	j	80004f78 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004f16:	00fa8733          	add	a4,s5,a5
    80004f1a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004f1e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004f20:	0207c563          	bltz	a5,80004f4a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004f24:	2905                	addiw	s2,s2,1
    80004f26:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004f28:	05490c63          	beq	s2,s4,80004f80 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004f2c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004f2e:	0000f717          	auipc	a4,0xf
    80004f32:	e6270713          	addi	a4,a4,-414 # 80013d90 <disk>
    80004f36:	4781                	li	a5,0
    if(disk.free[i]){
    80004f38:	01874683          	lbu	a3,24(a4)
    80004f3c:	fee9                	bnez	a3,80004f16 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004f3e:	2785                	addiw	a5,a5,1
    80004f40:	0705                	addi	a4,a4,1
    80004f42:	fe979be3          	bne	a5,s1,80004f38 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004f46:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004f4a:	01205d63          	blez	s2,80004f64 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004f4e:	fa042503          	lw	a0,-96(s0)
    80004f52:	d41ff0ef          	jal	80004c92 <free_desc>
      for(int j = 0; j < i; j++)
    80004f56:	4785                	li	a5,1
    80004f58:	0127d663          	bge	a5,s2,80004f64 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004f5c:	fa442503          	lw	a0,-92(s0)
    80004f60:	d33ff0ef          	jal	80004c92 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004f64:	0000f597          	auipc	a1,0xf
    80004f68:	f5458593          	addi	a1,a1,-172 # 80013eb8 <disk+0x128>
    80004f6c:	0000f517          	auipc	a0,0xf
    80004f70:	e3c50513          	addi	a0,a0,-452 # 80013da8 <disk+0x18>
    80004f74:	c26fc0ef          	jal	8000139a <sleep>
  for(int i = 0; i < 3; i++){
    80004f78:	fa040613          	addi	a2,s0,-96
    80004f7c:	4901                	li	s2,0
    80004f7e:	b77d                	j	80004f2c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004f80:	fa042503          	lw	a0,-96(s0)
    80004f84:	00451693          	slli	a3,a0,0x4

  if(write)
    80004f88:	0000f797          	auipc	a5,0xf
    80004f8c:	e0878793          	addi	a5,a5,-504 # 80013d90 <disk>
    80004f90:	00451713          	slli	a4,a0,0x4
    80004f94:	0a070713          	addi	a4,a4,160
    80004f98:	973e                	add	a4,a4,a5
    80004f9a:	01603633          	snez	a2,s6
    80004f9e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004fa0:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004fa4:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004fa8:	6398                	ld	a4,0(a5)
    80004faa:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004fac:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004fb0:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004fb2:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004fb4:	6390                	ld	a2,0(a5)
    80004fb6:	00d60833          	add	a6,a2,a3
    80004fba:	4741                	li	a4,16
    80004fbc:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004fc0:	4585                	li	a1,1
    80004fc2:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004fc6:	fa442703          	lw	a4,-92(s0)
    80004fca:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004fce:	0712                	slli	a4,a4,0x4
    80004fd0:	963a                	add	a2,a2,a4
    80004fd2:	05898813          	addi	a6,s3,88
    80004fd6:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004fda:	0007b883          	ld	a7,0(a5)
    80004fde:	9746                	add	a4,a4,a7
    80004fe0:	40000613          	li	a2,1024
    80004fe4:	c710                	sw	a2,8(a4)
  if(write)
    80004fe6:	001b3613          	seqz	a2,s6
    80004fea:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004fee:	8e4d                	or	a2,a2,a1
    80004ff0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004ff4:	fa842603          	lw	a2,-88(s0)
    80004ff8:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004ffc:	00451813          	slli	a6,a0,0x4
    80005000:	02080813          	addi	a6,a6,32
    80005004:	983e                	add	a6,a6,a5
    80005006:	577d                	li	a4,-1
    80005008:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000500c:	0612                	slli	a2,a2,0x4
    8000500e:	98b2                	add	a7,a7,a2
    80005010:	03068713          	addi	a4,a3,48
    80005014:	973e                	add	a4,a4,a5
    80005016:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000501a:	6398                	ld	a4,0(a5)
    8000501c:	9732                	add	a4,a4,a2
    8000501e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005020:	4689                	li	a3,2
    80005022:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005026:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000502a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    8000502e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005032:	6794                	ld	a3,8(a5)
    80005034:	0026d703          	lhu	a4,2(a3)
    80005038:	8b1d                	andi	a4,a4,7
    8000503a:	0706                	slli	a4,a4,0x1
    8000503c:	96ba                	add	a3,a3,a4
    8000503e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005042:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005046:	6798                	ld	a4,8(a5)
    80005048:	00275783          	lhu	a5,2(a4)
    8000504c:	2785                	addiw	a5,a5,1
    8000504e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005052:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005056:	100017b7          	lui	a5,0x10001
    8000505a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000505e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005062:	0000f917          	auipc	s2,0xf
    80005066:	e5690913          	addi	s2,s2,-426 # 80013eb8 <disk+0x128>
  while(b->disk == 1) {
    8000506a:	84ae                	mv	s1,a1
    8000506c:	00b79a63          	bne	a5,a1,80005080 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005070:	85ca                	mv	a1,s2
    80005072:	854e                	mv	a0,s3
    80005074:	b26fc0ef          	jal	8000139a <sleep>
  while(b->disk == 1) {
    80005078:	0049a783          	lw	a5,4(s3)
    8000507c:	fe978ae3          	beq	a5,s1,80005070 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005080:	fa042903          	lw	s2,-96(s0)
    80005084:	00491713          	slli	a4,s2,0x4
    80005088:	02070713          	addi	a4,a4,32
    8000508c:	0000f797          	auipc	a5,0xf
    80005090:	d0478793          	addi	a5,a5,-764 # 80013d90 <disk>
    80005094:	97ba                	add	a5,a5,a4
    80005096:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000509a:	0000f997          	auipc	s3,0xf
    8000509e:	cf698993          	addi	s3,s3,-778 # 80013d90 <disk>
    800050a2:	00491713          	slli	a4,s2,0x4
    800050a6:	0009b783          	ld	a5,0(s3)
    800050aa:	97ba                	add	a5,a5,a4
    800050ac:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800050b0:	854a                	mv	a0,s2
    800050b2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800050b6:	bddff0ef          	jal	80004c92 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800050ba:	8885                	andi	s1,s1,1
    800050bc:	f0fd                	bnez	s1,800050a2 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800050be:	0000f517          	auipc	a0,0xf
    800050c2:	dfa50513          	addi	a0,a0,-518 # 80013eb8 <disk+0x128>
    800050c6:	427000ef          	jal	80005cec <release>
}
    800050ca:	60e6                	ld	ra,88(sp)
    800050cc:	6446                	ld	s0,80(sp)
    800050ce:	64a6                	ld	s1,72(sp)
    800050d0:	6906                	ld	s2,64(sp)
    800050d2:	79e2                	ld	s3,56(sp)
    800050d4:	7a42                	ld	s4,48(sp)
    800050d6:	7aa2                	ld	s5,40(sp)
    800050d8:	7b02                	ld	s6,32(sp)
    800050da:	6be2                	ld	s7,24(sp)
    800050dc:	6c42                	ld	s8,16(sp)
    800050de:	6125                	addi	sp,sp,96
    800050e0:	8082                	ret

00000000800050e2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800050e2:	1101                	addi	sp,sp,-32
    800050e4:	ec06                	sd	ra,24(sp)
    800050e6:	e822                	sd	s0,16(sp)
    800050e8:	e426                	sd	s1,8(sp)
    800050ea:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800050ec:	0000f497          	auipc	s1,0xf
    800050f0:	ca448493          	addi	s1,s1,-860 # 80013d90 <disk>
    800050f4:	0000f517          	auipc	a0,0xf
    800050f8:	dc450513          	addi	a0,a0,-572 # 80013eb8 <disk+0x128>
    800050fc:	35d000ef          	jal	80005c58 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005100:	100017b7          	lui	a5,0x10001
    80005104:	53bc                	lw	a5,96(a5)
    80005106:	8b8d                	andi	a5,a5,3
    80005108:	10001737          	lui	a4,0x10001
    8000510c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000510e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005112:	689c                	ld	a5,16(s1)
    80005114:	0204d703          	lhu	a4,32(s1)
    80005118:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000511c:	04f70863          	beq	a4,a5,8000516c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005120:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005124:	6898                	ld	a4,16(s1)
    80005126:	0204d783          	lhu	a5,32(s1)
    8000512a:	8b9d                	andi	a5,a5,7
    8000512c:	078e                	slli	a5,a5,0x3
    8000512e:	97ba                	add	a5,a5,a4
    80005130:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005132:	00479713          	slli	a4,a5,0x4
    80005136:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000513a:	9726                	add	a4,a4,s1
    8000513c:	01074703          	lbu	a4,16(a4)
    80005140:	e329                	bnez	a4,80005182 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005142:	0792                	slli	a5,a5,0x4
    80005144:	02078793          	addi	a5,a5,32
    80005148:	97a6                	add	a5,a5,s1
    8000514a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000514c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005150:	a96fc0ef          	jal	800013e6 <wakeup>

    disk.used_idx += 1;
    80005154:	0204d783          	lhu	a5,32(s1)
    80005158:	2785                	addiw	a5,a5,1
    8000515a:	17c2                	slli	a5,a5,0x30
    8000515c:	93c1                	srli	a5,a5,0x30
    8000515e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005162:	6898                	ld	a4,16(s1)
    80005164:	00275703          	lhu	a4,2(a4)
    80005168:	faf71ce3          	bne	a4,a5,80005120 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000516c:	0000f517          	auipc	a0,0xf
    80005170:	d4c50513          	addi	a0,a0,-692 # 80013eb8 <disk+0x128>
    80005174:	379000ef          	jal	80005cec <release>
}
    80005178:	60e2                	ld	ra,24(sp)
    8000517a:	6442                	ld	s0,16(sp)
    8000517c:	64a2                	ld	s1,8(sp)
    8000517e:	6105                	addi	sp,sp,32
    80005180:	8082                	ret
      panic("virtio_disk_intr status");
    80005182:	00002517          	auipc	a0,0x2
    80005186:	53650513          	addi	a0,a0,1334 # 800076b8 <etext+0x6b8>
    8000518a:	00d000ef          	jal	80005996 <panic>

000000008000518e <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000518e:	1141                	addi	sp,sp,-16
    80005190:	e406                	sd	ra,8(sp)
    80005192:	e022                	sd	s0,0(sp)
    80005194:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005196:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    8000519a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    8000519e:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800051a2:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800051a6:	577d                	li	a4,-1
    800051a8:	177e                	slli	a4,a4,0x3f
    800051aa:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800051ac:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800051b0:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800051b4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800051b8:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    800051bc:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    800051c0:	000f4737          	lui	a4,0xf4
    800051c4:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800051c8:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800051ca:	14d79073          	csrw	stimecmp,a5
}
    800051ce:	60a2                	ld	ra,8(sp)
    800051d0:	6402                	ld	s0,0(sp)
    800051d2:	0141                	addi	sp,sp,16
    800051d4:	8082                	ret

00000000800051d6 <start>:
{
    800051d6:	1141                	addi	sp,sp,-16
    800051d8:	e406                	sd	ra,8(sp)
    800051da:	e022                	sd	s0,0(sp)
    800051dc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800051de:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800051e2:	7779                	lui	a4,0xffffe
    800051e4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffe2857>
    800051e8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800051ea:	6705                	lui	a4,0x1
    800051ec:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800051f0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800051f2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800051f6:	ffffb797          	auipc	a5,0xffffb
    800051fa:	11e78793          	addi	a5,a5,286 # 80000314 <main>
    800051fe:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005202:	4781                	li	a5,0
    80005204:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005208:	67c1                	lui	a5,0x10
    8000520a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000520c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005210:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005214:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80005218:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    8000521c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005220:	57fd                	li	a5,-1
    80005222:	83a9                	srli	a5,a5,0xa
    80005224:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005228:	47bd                	li	a5,15
    8000522a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000522e:	f61ff0ef          	jal	8000518e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005232:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005236:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005238:	823e                	mv	tp,a5
  asm volatile("mret");
    8000523a:	30200073          	mret
}
    8000523e:	60a2                	ld	ra,8(sp)
    80005240:	6402                	ld	s0,0(sp)
    80005242:	0141                	addi	sp,sp,16
    80005244:	8082                	ret

0000000080005246 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005246:	7119                	addi	sp,sp,-128
    80005248:	fc86                	sd	ra,120(sp)
    8000524a:	f8a2                	sd	s0,112(sp)
    8000524c:	f4a6                	sd	s1,104(sp)
    8000524e:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005250:	06c05b63          	blez	a2,800052c6 <consolewrite+0x80>
    80005254:	f0ca                	sd	s2,96(sp)
    80005256:	ecce                	sd	s3,88(sp)
    80005258:	e8d2                	sd	s4,80(sp)
    8000525a:	e4d6                	sd	s5,72(sp)
    8000525c:	e0da                	sd	s6,64(sp)
    8000525e:	fc5e                	sd	s7,56(sp)
    80005260:	f862                	sd	s8,48(sp)
    80005262:	f466                	sd	s9,40(sp)
    80005264:	f06a                	sd	s10,32(sp)
    80005266:	8b2a                	mv	s6,a0
    80005268:	8bae                	mv	s7,a1
    8000526a:	8a32                	mv	s4,a2
  int i = 0;
    8000526c:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    8000526e:	02000c93          	li	s9,32
    80005272:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005276:	f8040a93          	addi	s5,s0,-128
    8000527a:	5c7d                	li	s8,-1
    8000527c:	a025                	j	800052a4 <consolewrite+0x5e>
    if(nn > n - i)
    8000527e:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005282:	86ce                	mv	a3,s3
    80005284:	01748633          	add	a2,s1,s7
    80005288:	85da                	mv	a1,s6
    8000528a:	8556                	mv	a0,s5
    8000528c:	cacfc0ef          	jal	80001738 <either_copyin>
    80005290:	03850d63          	beq	a0,s8,800052ca <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80005294:	85ce                	mv	a1,s3
    80005296:	8556                	mv	a0,s5
    80005298:	7b4000ef          	jal	80005a4c <uartwrite>
    i += nn;
    8000529c:	009904bb          	addw	s1,s2,s1
  while(i < n){
    800052a0:	0144d963          	bge	s1,s4,800052b2 <consolewrite+0x6c>
    if(nn > n - i)
    800052a4:	409a07bb          	subw	a5,s4,s1
    800052a8:	893e                	mv	s2,a5
    800052aa:	fcfcdae3          	bge	s9,a5,8000527e <consolewrite+0x38>
    800052ae:	896a                	mv	s2,s10
    800052b0:	b7f9                	j	8000527e <consolewrite+0x38>
    800052b2:	7906                	ld	s2,96(sp)
    800052b4:	69e6                	ld	s3,88(sp)
    800052b6:	6a46                	ld	s4,80(sp)
    800052b8:	6aa6                	ld	s5,72(sp)
    800052ba:	6b06                	ld	s6,64(sp)
    800052bc:	7be2                	ld	s7,56(sp)
    800052be:	7c42                	ld	s8,48(sp)
    800052c0:	7ca2                	ld	s9,40(sp)
    800052c2:	7d02                	ld	s10,32(sp)
    800052c4:	a821                	j	800052dc <consolewrite+0x96>
  int i = 0;
    800052c6:	4481                	li	s1,0
    800052c8:	a811                	j	800052dc <consolewrite+0x96>
    800052ca:	7906                	ld	s2,96(sp)
    800052cc:	69e6                	ld	s3,88(sp)
    800052ce:	6a46                	ld	s4,80(sp)
    800052d0:	6aa6                	ld	s5,72(sp)
    800052d2:	6b06                	ld	s6,64(sp)
    800052d4:	7be2                	ld	s7,56(sp)
    800052d6:	7c42                	ld	s8,48(sp)
    800052d8:	7ca2                	ld	s9,40(sp)
    800052da:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    800052dc:	8526                	mv	a0,s1
    800052de:	70e6                	ld	ra,120(sp)
    800052e0:	7446                	ld	s0,112(sp)
    800052e2:	74a6                	ld	s1,104(sp)
    800052e4:	6109                	addi	sp,sp,128
    800052e6:	8082                	ret

00000000800052e8 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800052e8:	711d                	addi	sp,sp,-96
    800052ea:	ec86                	sd	ra,88(sp)
    800052ec:	e8a2                	sd	s0,80(sp)
    800052ee:	e4a6                	sd	s1,72(sp)
    800052f0:	e0ca                	sd	s2,64(sp)
    800052f2:	fc4e                	sd	s3,56(sp)
    800052f4:	f852                	sd	s4,48(sp)
    800052f6:	f05a                	sd	s6,32(sp)
    800052f8:	ec5e                	sd	s7,24(sp)
    800052fa:	1080                	addi	s0,sp,96
    800052fc:	8b2a                	mv	s6,a0
    800052fe:	8a2e                	mv	s4,a1
    80005300:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005302:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80005304:	00017517          	auipc	a0,0x17
    80005308:	bcc50513          	addi	a0,a0,-1076 # 8001bed0 <cons>
    8000530c:	14d000ef          	jal	80005c58 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005310:	00017497          	auipc	s1,0x17
    80005314:	bc048493          	addi	s1,s1,-1088 # 8001bed0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005318:	00017917          	auipc	s2,0x17
    8000531c:	c5090913          	addi	s2,s2,-944 # 8001bf68 <cons+0x98>
  while(n > 0){
    80005320:	0b305b63          	blez	s3,800053d6 <consoleread+0xee>
    while(cons.r == cons.w){
    80005324:	0984a783          	lw	a5,152(s1)
    80005328:	09c4a703          	lw	a4,156(s1)
    8000532c:	0af71063          	bne	a4,a5,800053cc <consoleread+0xe4>
      if(killed(myproc())){
    80005330:	a65fb0ef          	jal	80000d94 <myproc>
    80005334:	a9cfc0ef          	jal	800015d0 <killed>
    80005338:	e12d                	bnez	a0,8000539a <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000533a:	85a6                	mv	a1,s1
    8000533c:	854a                	mv	a0,s2
    8000533e:	85cfc0ef          	jal	8000139a <sleep>
    while(cons.r == cons.w){
    80005342:	0984a783          	lw	a5,152(s1)
    80005346:	09c4a703          	lw	a4,156(s1)
    8000534a:	fef703e3          	beq	a4,a5,80005330 <consoleread+0x48>
    8000534e:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005350:	00017717          	auipc	a4,0x17
    80005354:	b8070713          	addi	a4,a4,-1152 # 8001bed0 <cons>
    80005358:	0017869b          	addiw	a3,a5,1
    8000535c:	08d72c23          	sw	a3,152(a4)
    80005360:	07f7f693          	andi	a3,a5,127
    80005364:	9736                	add	a4,a4,a3
    80005366:	01874703          	lbu	a4,24(a4)
    8000536a:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    8000536e:	4691                	li	a3,4
    80005370:	04da8663          	beq	s5,a3,800053bc <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005374:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005378:	4685                	li	a3,1
    8000537a:	faf40613          	addi	a2,s0,-81
    8000537e:	85d2                	mv	a1,s4
    80005380:	855a                	mv	a0,s6
    80005382:	b6cfc0ef          	jal	800016ee <either_copyout>
    80005386:	57fd                	li	a5,-1
    80005388:	04f50663          	beq	a0,a5,800053d4 <consoleread+0xec>
      break;

    dst++;
    8000538c:	0a05                	addi	s4,s4,1
    --n;
    8000538e:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005390:	47a9                	li	a5,10
    80005392:	04fa8b63          	beq	s5,a5,800053e8 <consoleread+0x100>
    80005396:	7aa2                	ld	s5,40(sp)
    80005398:	b761                	j	80005320 <consoleread+0x38>
        release(&cons.lock);
    8000539a:	00017517          	auipc	a0,0x17
    8000539e:	b3650513          	addi	a0,a0,-1226 # 8001bed0 <cons>
    800053a2:	14b000ef          	jal	80005cec <release>
        return -1;
    800053a6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800053a8:	60e6                	ld	ra,88(sp)
    800053aa:	6446                	ld	s0,80(sp)
    800053ac:	64a6                	ld	s1,72(sp)
    800053ae:	6906                	ld	s2,64(sp)
    800053b0:	79e2                	ld	s3,56(sp)
    800053b2:	7a42                	ld	s4,48(sp)
    800053b4:	7b02                	ld	s6,32(sp)
    800053b6:	6be2                	ld	s7,24(sp)
    800053b8:	6125                	addi	sp,sp,96
    800053ba:	8082                	ret
      if(n < target){
    800053bc:	0179fa63          	bgeu	s3,s7,800053d0 <consoleread+0xe8>
        cons.r--;
    800053c0:	00017717          	auipc	a4,0x17
    800053c4:	baf72423          	sw	a5,-1112(a4) # 8001bf68 <cons+0x98>
    800053c8:	7aa2                	ld	s5,40(sp)
    800053ca:	a031                	j	800053d6 <consoleread+0xee>
    800053cc:	f456                	sd	s5,40(sp)
    800053ce:	b749                	j	80005350 <consoleread+0x68>
    800053d0:	7aa2                	ld	s5,40(sp)
    800053d2:	a011                	j	800053d6 <consoleread+0xee>
    800053d4:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    800053d6:	00017517          	auipc	a0,0x17
    800053da:	afa50513          	addi	a0,a0,-1286 # 8001bed0 <cons>
    800053de:	10f000ef          	jal	80005cec <release>
  return target - n;
    800053e2:	413b853b          	subw	a0,s7,s3
    800053e6:	b7c9                	j	800053a8 <consoleread+0xc0>
    800053e8:	7aa2                	ld	s5,40(sp)
    800053ea:	b7f5                	j	800053d6 <consoleread+0xee>

00000000800053ec <consputc>:
{
    800053ec:	1141                	addi	sp,sp,-16
    800053ee:	e406                	sd	ra,8(sp)
    800053f0:	e022                	sd	s0,0(sp)
    800053f2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800053f4:	10000793          	li	a5,256
    800053f8:	00f50863          	beq	a0,a5,80005408 <consputc+0x1c>
    uartputc_sync(c);
    800053fc:	6e4000ef          	jal	80005ae0 <uartputc_sync>
}
    80005400:	60a2                	ld	ra,8(sp)
    80005402:	6402                	ld	s0,0(sp)
    80005404:	0141                	addi	sp,sp,16
    80005406:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005408:	4521                	li	a0,8
    8000540a:	6d6000ef          	jal	80005ae0 <uartputc_sync>
    8000540e:	02000513          	li	a0,32
    80005412:	6ce000ef          	jal	80005ae0 <uartputc_sync>
    80005416:	4521                	li	a0,8
    80005418:	6c8000ef          	jal	80005ae0 <uartputc_sync>
    8000541c:	b7d5                	j	80005400 <consputc+0x14>

000000008000541e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000541e:	1101                	addi	sp,sp,-32
    80005420:	ec06                	sd	ra,24(sp)
    80005422:	e822                	sd	s0,16(sp)
    80005424:	e426                	sd	s1,8(sp)
    80005426:	1000                	addi	s0,sp,32
    80005428:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000542a:	00017517          	auipc	a0,0x17
    8000542e:	aa650513          	addi	a0,a0,-1370 # 8001bed0 <cons>
    80005432:	027000ef          	jal	80005c58 <acquire>

  switch(c){
    80005436:	47d5                	li	a5,21
    80005438:	08f48d63          	beq	s1,a5,800054d2 <consoleintr+0xb4>
    8000543c:	0297c563          	blt	a5,s1,80005466 <consoleintr+0x48>
    80005440:	47a1                	li	a5,8
    80005442:	0ef48263          	beq	s1,a5,80005526 <consoleintr+0x108>
    80005446:	47c1                	li	a5,16
    80005448:	10f49363          	bne	s1,a5,8000554e <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    8000544c:	b36fc0ef          	jal	80001782 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005450:	00017517          	auipc	a0,0x17
    80005454:	a8050513          	addi	a0,a0,-1408 # 8001bed0 <cons>
    80005458:	095000ef          	jal	80005cec <release>
}
    8000545c:	60e2                	ld	ra,24(sp)
    8000545e:	6442                	ld	s0,16(sp)
    80005460:	64a2                	ld	s1,8(sp)
    80005462:	6105                	addi	sp,sp,32
    80005464:	8082                	ret
  switch(c){
    80005466:	07f00793          	li	a5,127
    8000546a:	0af48e63          	beq	s1,a5,80005526 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000546e:	00017717          	auipc	a4,0x17
    80005472:	a6270713          	addi	a4,a4,-1438 # 8001bed0 <cons>
    80005476:	0a072783          	lw	a5,160(a4)
    8000547a:	09872703          	lw	a4,152(a4)
    8000547e:	9f99                	subw	a5,a5,a4
    80005480:	07f00713          	li	a4,127
    80005484:	fcf766e3          	bltu	a4,a5,80005450 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005488:	47b5                	li	a5,13
    8000548a:	0cf48563          	beq	s1,a5,80005554 <consoleintr+0x136>
      consputc(c);
    8000548e:	8526                	mv	a0,s1
    80005490:	f5dff0ef          	jal	800053ec <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005494:	00017717          	auipc	a4,0x17
    80005498:	a3c70713          	addi	a4,a4,-1476 # 8001bed0 <cons>
    8000549c:	0a072683          	lw	a3,160(a4)
    800054a0:	0016879b          	addiw	a5,a3,1
    800054a4:	863e                	mv	a2,a5
    800054a6:	0af72023          	sw	a5,160(a4)
    800054aa:	07f6f693          	andi	a3,a3,127
    800054ae:	9736                	add	a4,a4,a3
    800054b0:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800054b4:	ff648713          	addi	a4,s1,-10
    800054b8:	c371                	beqz	a4,8000557c <consoleintr+0x15e>
    800054ba:	14f1                	addi	s1,s1,-4
    800054bc:	c0e1                	beqz	s1,8000557c <consoleintr+0x15e>
    800054be:	00017717          	auipc	a4,0x17
    800054c2:	aaa72703          	lw	a4,-1366(a4) # 8001bf68 <cons+0x98>
    800054c6:	9f99                	subw	a5,a5,a4
    800054c8:	08000713          	li	a4,128
    800054cc:	f8e792e3          	bne	a5,a4,80005450 <consoleintr+0x32>
    800054d0:	a075                	j	8000557c <consoleintr+0x15e>
    800054d2:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800054d4:	00017717          	auipc	a4,0x17
    800054d8:	9fc70713          	addi	a4,a4,-1540 # 8001bed0 <cons>
    800054dc:	0a072783          	lw	a5,160(a4)
    800054e0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800054e4:	00017497          	auipc	s1,0x17
    800054e8:	9ec48493          	addi	s1,s1,-1556 # 8001bed0 <cons>
    while(cons.e != cons.w &&
    800054ec:	4929                	li	s2,10
    800054ee:	02f70863          	beq	a4,a5,8000551e <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800054f2:	37fd                	addiw	a5,a5,-1
    800054f4:	07f7f713          	andi	a4,a5,127
    800054f8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800054fa:	01874703          	lbu	a4,24(a4)
    800054fe:	03270263          	beq	a4,s2,80005522 <consoleintr+0x104>
      cons.e--;
    80005502:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005506:	10000513          	li	a0,256
    8000550a:	ee3ff0ef          	jal	800053ec <consputc>
    while(cons.e != cons.w &&
    8000550e:	0a04a783          	lw	a5,160(s1)
    80005512:	09c4a703          	lw	a4,156(s1)
    80005516:	fcf71ee3          	bne	a4,a5,800054f2 <consoleintr+0xd4>
    8000551a:	6902                	ld	s2,0(sp)
    8000551c:	bf15                	j	80005450 <consoleintr+0x32>
    8000551e:	6902                	ld	s2,0(sp)
    80005520:	bf05                	j	80005450 <consoleintr+0x32>
    80005522:	6902                	ld	s2,0(sp)
    80005524:	b735                	j	80005450 <consoleintr+0x32>
    if(cons.e != cons.w){
    80005526:	00017717          	auipc	a4,0x17
    8000552a:	9aa70713          	addi	a4,a4,-1622 # 8001bed0 <cons>
    8000552e:	0a072783          	lw	a5,160(a4)
    80005532:	09c72703          	lw	a4,156(a4)
    80005536:	f0f70de3          	beq	a4,a5,80005450 <consoleintr+0x32>
      cons.e--;
    8000553a:	37fd                	addiw	a5,a5,-1
    8000553c:	00017717          	auipc	a4,0x17
    80005540:	a2f72a23          	sw	a5,-1484(a4) # 8001bf70 <cons+0xa0>
      consputc(BACKSPACE);
    80005544:	10000513          	li	a0,256
    80005548:	ea5ff0ef          	jal	800053ec <consputc>
    8000554c:	b711                	j	80005450 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000554e:	f00481e3          	beqz	s1,80005450 <consoleintr+0x32>
    80005552:	bf31                	j	8000546e <consoleintr+0x50>
      consputc(c);
    80005554:	4529                	li	a0,10
    80005556:	e97ff0ef          	jal	800053ec <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000555a:	00017797          	auipc	a5,0x17
    8000555e:	97678793          	addi	a5,a5,-1674 # 8001bed0 <cons>
    80005562:	0a07a703          	lw	a4,160(a5)
    80005566:	0017069b          	addiw	a3,a4,1
    8000556a:	8636                	mv	a2,a3
    8000556c:	0ad7a023          	sw	a3,160(a5)
    80005570:	07f77713          	andi	a4,a4,127
    80005574:	97ba                	add	a5,a5,a4
    80005576:	4729                	li	a4,10
    80005578:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000557c:	00017797          	auipc	a5,0x17
    80005580:	9ec7a823          	sw	a2,-1552(a5) # 8001bf6c <cons+0x9c>
        wakeup(&cons.r);
    80005584:	00017517          	auipc	a0,0x17
    80005588:	9e450513          	addi	a0,a0,-1564 # 8001bf68 <cons+0x98>
    8000558c:	e5bfb0ef          	jal	800013e6 <wakeup>
    80005590:	b5c1                	j	80005450 <consoleintr+0x32>

0000000080005592 <consoleinit>:

void
consoleinit(void)
{
    80005592:	1141                	addi	sp,sp,-16
    80005594:	e406                	sd	ra,8(sp)
    80005596:	e022                	sd	s0,0(sp)
    80005598:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000559a:	00002597          	auipc	a1,0x2
    8000559e:	13658593          	addi	a1,a1,310 # 800076d0 <etext+0x6d0>
    800055a2:	00017517          	auipc	a0,0x17
    800055a6:	92e50513          	addi	a0,a0,-1746 # 8001bed0 <cons>
    800055aa:	624000ef          	jal	80005bce <initlock>

  uartinit();
    800055ae:	448000ef          	jal	800059f6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800055b2:	0000d797          	auipc	a5,0xd
    800055b6:	78678793          	addi	a5,a5,1926 # 80012d38 <devsw>
    800055ba:	00000717          	auipc	a4,0x0
    800055be:	d2e70713          	addi	a4,a4,-722 # 800052e8 <consoleread>
    800055c2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800055c4:	00000717          	auipc	a4,0x0
    800055c8:	c8270713          	addi	a4,a4,-894 # 80005246 <consolewrite>
    800055cc:	ef98                	sd	a4,24(a5)
}
    800055ce:	60a2                	ld	ra,8(sp)
    800055d0:	6402                	ld	s0,0(sp)
    800055d2:	0141                	addi	sp,sp,16
    800055d4:	8082                	ret

00000000800055d6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800055d6:	7139                	addi	sp,sp,-64
    800055d8:	fc06                	sd	ra,56(sp)
    800055da:	f822                	sd	s0,48(sp)
    800055dc:	f04a                	sd	s2,32(sp)
    800055de:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800055e0:	c219                	beqz	a2,800055e6 <printint+0x10>
    800055e2:	08054163          	bltz	a0,80005664 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    800055e6:	4301                	li	t1,0

  i = 0;
    800055e8:	fc840913          	addi	s2,s0,-56
    x = xx;
    800055ec:	86ca                	mv	a3,s2
  i = 0;
    800055ee:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800055f0:	00002817          	auipc	a6,0x2
    800055f4:	24080813          	addi	a6,a6,576 # 80007830 <digits>
    800055f8:	88ba                	mv	a7,a4
    800055fa:	0017061b          	addiw	a2,a4,1
    800055fe:	8732                	mv	a4,a2
    80005600:	02b577b3          	remu	a5,a0,a1
    80005604:	97c2                	add	a5,a5,a6
    80005606:	0007c783          	lbu	a5,0(a5)
    8000560a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000560e:	87aa                	mv	a5,a0
    80005610:	02b55533          	divu	a0,a0,a1
    80005614:	0685                	addi	a3,a3,1
    80005616:	feb7f1e3          	bgeu	a5,a1,800055f8 <printint+0x22>

  if(sign)
    8000561a:	00030c63          	beqz	t1,80005632 <printint+0x5c>
    buf[i++] = '-';
    8000561e:	fe060793          	addi	a5,a2,-32
    80005622:	00878633          	add	a2,a5,s0
    80005626:	02d00793          	li	a5,45
    8000562a:	fef60423          	sb	a5,-24(a2)
    8000562e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80005632:	02e05463          	blez	a4,8000565a <printint+0x84>
    80005636:	f426                	sd	s1,40(sp)
    80005638:	377d                	addiw	a4,a4,-1
    8000563a:	00e904b3          	add	s1,s2,a4
    8000563e:	197d                	addi	s2,s2,-1
    80005640:	993a                	add	s2,s2,a4
    80005642:	1702                	slli	a4,a4,0x20
    80005644:	9301                	srli	a4,a4,0x20
    80005646:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000564a:	0004c503          	lbu	a0,0(s1)
    8000564e:	d9fff0ef          	jal	800053ec <consputc>
  while(--i >= 0)
    80005652:	14fd                	addi	s1,s1,-1
    80005654:	ff249be3          	bne	s1,s2,8000564a <printint+0x74>
    80005658:	74a2                	ld	s1,40(sp)
}
    8000565a:	70e2                	ld	ra,56(sp)
    8000565c:	7442                	ld	s0,48(sp)
    8000565e:	7902                	ld	s2,32(sp)
    80005660:	6121                	addi	sp,sp,64
    80005662:	8082                	ret
    x = -xx;
    80005664:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005668:	4305                	li	t1,1
    x = -xx;
    8000566a:	bfbd                	j	800055e8 <printint+0x12>

000000008000566c <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000566c:	7131                	addi	sp,sp,-192
    8000566e:	fc86                	sd	ra,120(sp)
    80005670:	f8a2                	sd	s0,112(sp)
    80005672:	f0ca                	sd	s2,96(sp)
    80005674:	0100                	addi	s0,sp,128
    80005676:	892a                	mv	s2,a0
    80005678:	e40c                	sd	a1,8(s0)
    8000567a:	e810                	sd	a2,16(s0)
    8000567c:	ec14                	sd	a3,24(s0)
    8000567e:	f018                	sd	a4,32(s0)
    80005680:	f41c                	sd	a5,40(s0)
    80005682:	03043823          	sd	a6,48(s0)
    80005686:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    8000568a:	00002797          	auipc	a5,0x2
    8000568e:	1f67a783          	lw	a5,502(a5) # 80007880 <panicking>
    80005692:	cf9d                	beqz	a5,800056d0 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005694:	00840793          	addi	a5,s0,8
    80005698:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000569c:	00094503          	lbu	a0,0(s2)
    800056a0:	22050663          	beqz	a0,800058cc <printf+0x260>
    800056a4:	f4a6                	sd	s1,104(sp)
    800056a6:	ecce                	sd	s3,88(sp)
    800056a8:	e8d2                	sd	s4,80(sp)
    800056aa:	e4d6                	sd	s5,72(sp)
    800056ac:	e0da                	sd	s6,64(sp)
    800056ae:	fc5e                	sd	s7,56(sp)
    800056b0:	f862                	sd	s8,48(sp)
    800056b2:	f06a                	sd	s10,32(sp)
    800056b4:	ec6e                	sd	s11,24(sp)
    800056b6:	4a01                	li	s4,0
    if(cx != '%'){
    800056b8:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800056bc:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800056c0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800056c4:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    800056c8:	4b29                	li	s6,10
    if(c0 == 'd'){
    800056ca:	06400b93          	li	s7,100
    800056ce:	a015                	j	800056f2 <printf+0x86>
    acquire(&pr.lock);
    800056d0:	00017517          	auipc	a0,0x17
    800056d4:	8a850513          	addi	a0,a0,-1880 # 8001bf78 <pr>
    800056d8:	580000ef          	jal	80005c58 <acquire>
    800056dc:	bf65                	j	80005694 <printf+0x28>
      consputc(cx);
    800056de:	d0fff0ef          	jal	800053ec <consputc>
      continue;
    800056e2:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800056e4:	2485                	addiw	s1,s1,1
    800056e6:	8a26                	mv	s4,s1
    800056e8:	94ca                	add	s1,s1,s2
    800056ea:	0004c503          	lbu	a0,0(s1)
    800056ee:	1c050663          	beqz	a0,800058ba <printf+0x24e>
    if(cx != '%'){
    800056f2:	ff3516e3          	bne	a0,s3,800056de <printf+0x72>
    i++;
    800056f6:	001a079b          	addiw	a5,s4,1
    800056fa:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800056fc:	00f90733          	add	a4,s2,a5
    80005700:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005704:	200a8963          	beqz	s5,80005916 <printf+0x2aa>
    80005708:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    8000570c:	1e068c63          	beqz	a3,80005904 <printf+0x298>
    if(c0 == 'd'){
    80005710:	037a8863          	beq	s5,s7,80005740 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005714:	f94a8713          	addi	a4,s5,-108
    80005718:	00173713          	seqz	a4,a4
    8000571c:	f9c68613          	addi	a2,a3,-100
    80005720:	ee05                	bnez	a2,80005758 <printf+0xec>
    80005722:	cb1d                	beqz	a4,80005758 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    80005724:	f8843783          	ld	a5,-120(s0)
    80005728:	00878713          	addi	a4,a5,8
    8000572c:	f8e43423          	sd	a4,-120(s0)
    80005730:	4605                	li	a2,1
    80005732:	85da                	mv	a1,s6
    80005734:	6388                	ld	a0,0(a5)
    80005736:	ea1ff0ef          	jal	800055d6 <printint>
      i += 1;
    8000573a:	002a049b          	addiw	s1,s4,2
    8000573e:	b75d                	j	800056e4 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    80005740:	f8843783          	ld	a5,-120(s0)
    80005744:	00878713          	addi	a4,a5,8
    80005748:	f8e43423          	sd	a4,-120(s0)
    8000574c:	4605                	li	a2,1
    8000574e:	85da                	mv	a1,s6
    80005750:	4388                	lw	a0,0(a5)
    80005752:	e85ff0ef          	jal	800055d6 <printint>
    80005756:	b779                	j	800056e4 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    80005758:	97ca                	add	a5,a5,s2
    8000575a:	8636                	mv	a2,a3
    8000575c:	0027c683          	lbu	a3,2(a5)
    80005760:	a2c9                	j	80005922 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005762:	f8843783          	ld	a5,-120(s0)
    80005766:	00878713          	addi	a4,a5,8
    8000576a:	f8e43423          	sd	a4,-120(s0)
    8000576e:	4605                	li	a2,1
    80005770:	45a9                	li	a1,10
    80005772:	6388                	ld	a0,0(a5)
    80005774:	e63ff0ef          	jal	800055d6 <printint>
      i += 2;
    80005778:	003a049b          	addiw	s1,s4,3
    8000577c:	b7a5                	j	800056e4 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000577e:	f8843783          	ld	a5,-120(s0)
    80005782:	00878713          	addi	a4,a5,8
    80005786:	f8e43423          	sd	a4,-120(s0)
    8000578a:	4601                	li	a2,0
    8000578c:	85da                	mv	a1,s6
    8000578e:	0007e503          	lwu	a0,0(a5)
    80005792:	e45ff0ef          	jal	800055d6 <printint>
    80005796:	b7b9                	j	800056e4 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005798:	f8843783          	ld	a5,-120(s0)
    8000579c:	00878713          	addi	a4,a5,8
    800057a0:	f8e43423          	sd	a4,-120(s0)
    800057a4:	4601                	li	a2,0
    800057a6:	85da                	mv	a1,s6
    800057a8:	6388                	ld	a0,0(a5)
    800057aa:	e2dff0ef          	jal	800055d6 <printint>
      i += 1;
    800057ae:	002a049b          	addiw	s1,s4,2
    800057b2:	bf0d                	j	800056e4 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    800057b4:	f8843783          	ld	a5,-120(s0)
    800057b8:	00878713          	addi	a4,a5,8
    800057bc:	f8e43423          	sd	a4,-120(s0)
    800057c0:	4601                	li	a2,0
    800057c2:	45a9                	li	a1,10
    800057c4:	6388                	ld	a0,0(a5)
    800057c6:	e11ff0ef          	jal	800055d6 <printint>
      i += 2;
    800057ca:	003a049b          	addiw	s1,s4,3
    800057ce:	bf19                	j	800056e4 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    800057d0:	f8843783          	ld	a5,-120(s0)
    800057d4:	00878713          	addi	a4,a5,8
    800057d8:	f8e43423          	sd	a4,-120(s0)
    800057dc:	4601                	li	a2,0
    800057de:	45c1                	li	a1,16
    800057e0:	0007e503          	lwu	a0,0(a5)
    800057e4:	df3ff0ef          	jal	800055d6 <printint>
    800057e8:	bdf5                	j	800056e4 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800057ea:	f8843783          	ld	a5,-120(s0)
    800057ee:	00878713          	addi	a4,a5,8
    800057f2:	f8e43423          	sd	a4,-120(s0)
    800057f6:	45c1                	li	a1,16
    800057f8:	6388                	ld	a0,0(a5)
    800057fa:	dddff0ef          	jal	800055d6 <printint>
      i += 1;
    800057fe:	002a049b          	addiw	s1,s4,2
    80005802:	b5cd                	j	800056e4 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005804:	f8843783          	ld	a5,-120(s0)
    80005808:	00878713          	addi	a4,a5,8
    8000580c:	f8e43423          	sd	a4,-120(s0)
    80005810:	4601                	li	a2,0
    80005812:	45c1                	li	a1,16
    80005814:	6388                	ld	a0,0(a5)
    80005816:	dc1ff0ef          	jal	800055d6 <printint>
      i += 2;
    8000581a:	003a049b          	addiw	s1,s4,3
    8000581e:	b5d9                	j	800056e4 <printf+0x78>
    80005820:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    80005822:	f8843783          	ld	a5,-120(s0)
    80005826:	00878713          	addi	a4,a5,8
    8000582a:	f8e43423          	sd	a4,-120(s0)
    8000582e:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80005832:	03000513          	li	a0,48
    80005836:	bb7ff0ef          	jal	800053ec <consputc>
  consputc('x');
    8000583a:	07800513          	li	a0,120
    8000583e:	bafff0ef          	jal	800053ec <consputc>
    80005842:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005844:	00002c97          	auipc	s9,0x2
    80005848:	fecc8c93          	addi	s9,s9,-20 # 80007830 <digits>
    8000584c:	03cad793          	srli	a5,s5,0x3c
    80005850:	97e6                	add	a5,a5,s9
    80005852:	0007c503          	lbu	a0,0(a5)
    80005856:	b97ff0ef          	jal	800053ec <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    8000585a:	0a92                	slli	s5,s5,0x4
    8000585c:	3a7d                	addiw	s4,s4,-1
    8000585e:	fe0a17e3          	bnez	s4,8000584c <printf+0x1e0>
    80005862:	7ca2                	ld	s9,40(sp)
    80005864:	b541                	j	800056e4 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80005866:	f8843783          	ld	a5,-120(s0)
    8000586a:	00878713          	addi	a4,a5,8
    8000586e:	f8e43423          	sd	a4,-120(s0)
    80005872:	4388                	lw	a0,0(a5)
    80005874:	b79ff0ef          	jal	800053ec <consputc>
    80005878:	b5b5                	j	800056e4 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    8000587a:	f8843783          	ld	a5,-120(s0)
    8000587e:	00878713          	addi	a4,a5,8
    80005882:	f8e43423          	sd	a4,-120(s0)
    80005886:	0007ba03          	ld	s4,0(a5)
    8000588a:	000a0d63          	beqz	s4,800058a4 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000588e:	000a4503          	lbu	a0,0(s4)
    80005892:	e40509e3          	beqz	a0,800056e4 <printf+0x78>
        consputc(*s);
    80005896:	b57ff0ef          	jal	800053ec <consputc>
      for(; *s; s++)
    8000589a:	0a05                	addi	s4,s4,1
    8000589c:	000a4503          	lbu	a0,0(s4)
    800058a0:	f97d                	bnez	a0,80005896 <printf+0x22a>
    800058a2:	b589                	j	800056e4 <printf+0x78>
        s = "(null)";
    800058a4:	00002a17          	auipc	s4,0x2
    800058a8:	e34a0a13          	addi	s4,s4,-460 # 800076d8 <etext+0x6d8>
      for(; *s; s++)
    800058ac:	02800513          	li	a0,40
    800058b0:	b7dd                	j	80005896 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    800058b2:	8556                	mv	a0,s5
    800058b4:	b39ff0ef          	jal	800053ec <consputc>
    800058b8:	b535                	j	800056e4 <printf+0x78>
    800058ba:	74a6                	ld	s1,104(sp)
    800058bc:	69e6                	ld	s3,88(sp)
    800058be:	6a46                	ld	s4,80(sp)
    800058c0:	6aa6                	ld	s5,72(sp)
    800058c2:	6b06                	ld	s6,64(sp)
    800058c4:	7be2                	ld	s7,56(sp)
    800058c6:	7c42                	ld	s8,48(sp)
    800058c8:	7d02                	ld	s10,32(sp)
    800058ca:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    800058cc:	00002797          	auipc	a5,0x2
    800058d0:	fb47a783          	lw	a5,-76(a5) # 80007880 <panicking>
    800058d4:	c38d                	beqz	a5,800058f6 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    800058d6:	4501                	li	a0,0
    800058d8:	70e6                	ld	ra,120(sp)
    800058da:	7446                	ld	s0,112(sp)
    800058dc:	7906                	ld	s2,96(sp)
    800058de:	6129                	addi	sp,sp,192
    800058e0:	8082                	ret
    800058e2:	74a6                	ld	s1,104(sp)
    800058e4:	69e6                	ld	s3,88(sp)
    800058e6:	6a46                	ld	s4,80(sp)
    800058e8:	6aa6                	ld	s5,72(sp)
    800058ea:	6b06                	ld	s6,64(sp)
    800058ec:	7be2                	ld	s7,56(sp)
    800058ee:	7c42                	ld	s8,48(sp)
    800058f0:	7d02                	ld	s10,32(sp)
    800058f2:	6de2                	ld	s11,24(sp)
    800058f4:	bfe1                	j	800058cc <printf+0x260>
    release(&pr.lock);
    800058f6:	00016517          	auipc	a0,0x16
    800058fa:	68250513          	addi	a0,a0,1666 # 8001bf78 <pr>
    800058fe:	3ee000ef          	jal	80005cec <release>
  return 0;
    80005902:	bfd1                	j	800058d6 <printf+0x26a>
    if(c0 == 'd'){
    80005904:	e37a8ee3          	beq	s5,s7,80005740 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005908:	f94a8713          	addi	a4,s5,-108
    8000590c:	00173713          	seqz	a4,a4
    80005910:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005912:	4781                	li	a5,0
    80005914:	a00d                	j	80005936 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    80005916:	f94a8713          	addi	a4,s5,-108
    8000591a:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    8000591e:	8656                	mv	a2,s5
    80005920:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005922:	f9460793          	addi	a5,a2,-108
    80005926:	0017b793          	seqz	a5,a5
    8000592a:	8ff9                	and	a5,a5,a4
    8000592c:	f9c68593          	addi	a1,a3,-100
    80005930:	e199                	bnez	a1,80005936 <printf+0x2ca>
    80005932:	e20798e3          	bnez	a5,80005762 <printf+0xf6>
    } else if(c0 == 'u'){
    80005936:	e58a84e3          	beq	s5,s8,8000577e <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    8000593a:	f8b60593          	addi	a1,a2,-117
    8000593e:	e199                	bnez	a1,80005944 <printf+0x2d8>
    80005940:	e4071ce3          	bnez	a4,80005798 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005944:	f8b68593          	addi	a1,a3,-117
    80005948:	e199                	bnez	a1,8000594e <printf+0x2e2>
    8000594a:	e60795e3          	bnez	a5,800057b4 <printf+0x148>
    } else if(c0 == 'x'){
    8000594e:	e9aa81e3          	beq	s5,s10,800057d0 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    80005952:	f8860613          	addi	a2,a2,-120
    80005956:	e219                	bnez	a2,8000595c <printf+0x2f0>
    80005958:	e80719e3          	bnez	a4,800057ea <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    8000595c:	f8868693          	addi	a3,a3,-120
    80005960:	e299                	bnez	a3,80005966 <printf+0x2fa>
    80005962:	ea0791e3          	bnez	a5,80005804 <printf+0x198>
    } else if(c0 == 'p'){
    80005966:	ebba8de3          	beq	s5,s11,80005820 <printf+0x1b4>
    } else if(c0 == 'c'){
    8000596a:	06300793          	li	a5,99
    8000596e:	eefa8ce3          	beq	s5,a5,80005866 <printf+0x1fa>
    } else if(c0 == 's'){
    80005972:	07300793          	li	a5,115
    80005976:	f0fa82e3          	beq	s5,a5,8000587a <printf+0x20e>
    } else if(c0 == '%'){
    8000597a:	02500793          	li	a5,37
    8000597e:	f2fa8ae3          	beq	s5,a5,800058b2 <printf+0x246>
    } else if(c0 == 0){
    80005982:	f60a80e3          	beqz	s5,800058e2 <printf+0x276>
      consputc('%');
    80005986:	02500513          	li	a0,37
    8000598a:	a63ff0ef          	jal	800053ec <consputc>
      consputc(c0);
    8000598e:	8556                	mv	a0,s5
    80005990:	a5dff0ef          	jal	800053ec <consputc>
    80005994:	bb81                	j	800056e4 <printf+0x78>

0000000080005996 <panic>:

void
panic(char *s)
{
    80005996:	1101                	addi	sp,sp,-32
    80005998:	ec06                	sd	ra,24(sp)
    8000599a:	e822                	sd	s0,16(sp)
    8000599c:	e426                	sd	s1,8(sp)
    8000599e:	e04a                	sd	s2,0(sp)
    800059a0:	1000                	addi	s0,sp,32
    800059a2:	892a                	mv	s2,a0
  panicking = 1;
    800059a4:	4485                	li	s1,1
    800059a6:	00002797          	auipc	a5,0x2
    800059aa:	ec97ad23          	sw	s1,-294(a5) # 80007880 <panicking>
  printf("panic: ");
    800059ae:	00002517          	auipc	a0,0x2
    800059b2:	d3250513          	addi	a0,a0,-718 # 800076e0 <etext+0x6e0>
    800059b6:	cb7ff0ef          	jal	8000566c <printf>
  printf("%s\n", s);
    800059ba:	85ca                	mv	a1,s2
    800059bc:	00002517          	auipc	a0,0x2
    800059c0:	d2c50513          	addi	a0,a0,-724 # 800076e8 <etext+0x6e8>
    800059c4:	ca9ff0ef          	jal	8000566c <printf>
  panicked = 1; // freeze uart output from other CPUs
    800059c8:	00002797          	auipc	a5,0x2
    800059cc:	ea97aa23          	sw	s1,-332(a5) # 8000787c <panicked>
  for(;;)
    800059d0:	a001                	j	800059d0 <panic+0x3a>

00000000800059d2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800059d2:	1141                	addi	sp,sp,-16
    800059d4:	e406                	sd	ra,8(sp)
    800059d6:	e022                	sd	s0,0(sp)
    800059d8:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    800059da:	00002597          	auipc	a1,0x2
    800059de:	d1658593          	addi	a1,a1,-746 # 800076f0 <etext+0x6f0>
    800059e2:	00016517          	auipc	a0,0x16
    800059e6:	59650513          	addi	a0,a0,1430 # 8001bf78 <pr>
    800059ea:	1e4000ef          	jal	80005bce <initlock>
}
    800059ee:	60a2                	ld	ra,8(sp)
    800059f0:	6402                	ld	s0,0(sp)
    800059f2:	0141                	addi	sp,sp,16
    800059f4:	8082                	ret

00000000800059f6 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    800059f6:	1141                	addi	sp,sp,-16
    800059f8:	e406                	sd	ra,8(sp)
    800059fa:	e022                	sd	s0,0(sp)
    800059fc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800059fe:	100007b7          	lui	a5,0x10000
    80005a02:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005a06:	10000737          	lui	a4,0x10000
    80005a0a:	f8000693          	li	a3,-128
    80005a0e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005a12:	468d                	li	a3,3
    80005a14:	10000637          	lui	a2,0x10000
    80005a18:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005a1c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005a20:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005a24:	8732                	mv	a4,a2
    80005a26:	461d                	li	a2,7
    80005a28:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005a2c:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005a30:	00002597          	auipc	a1,0x2
    80005a34:	cc858593          	addi	a1,a1,-824 # 800076f8 <etext+0x6f8>
    80005a38:	00016517          	auipc	a0,0x16
    80005a3c:	55850513          	addi	a0,a0,1368 # 8001bf90 <tx_lock>
    80005a40:	18e000ef          	jal	80005bce <initlock>
}
    80005a44:	60a2                	ld	ra,8(sp)
    80005a46:	6402                	ld	s0,0(sp)
    80005a48:	0141                	addi	sp,sp,16
    80005a4a:	8082                	ret

0000000080005a4c <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005a4c:	715d                	addi	sp,sp,-80
    80005a4e:	e486                	sd	ra,72(sp)
    80005a50:	e0a2                	sd	s0,64(sp)
    80005a52:	fc26                	sd	s1,56(sp)
    80005a54:	ec56                	sd	s5,24(sp)
    80005a56:	0880                	addi	s0,sp,80
    80005a58:	8aaa                	mv	s5,a0
    80005a5a:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005a5c:	00016517          	auipc	a0,0x16
    80005a60:	53450513          	addi	a0,a0,1332 # 8001bf90 <tx_lock>
    80005a64:	1f4000ef          	jal	80005c58 <acquire>

  int i = 0;
  while(i < n){ 
    80005a68:	06905063          	blez	s1,80005ac8 <uartwrite+0x7c>
    80005a6c:	f84a                	sd	s2,48(sp)
    80005a6e:	f44e                	sd	s3,40(sp)
    80005a70:	f052                	sd	s4,32(sp)
    80005a72:	e85a                	sd	s6,16(sp)
    80005a74:	e45e                	sd	s7,8(sp)
    80005a76:	8a56                	mv	s4,s5
    80005a78:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005a7a:	00002497          	auipc	s1,0x2
    80005a7e:	e0e48493          	addi	s1,s1,-498 # 80007888 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005a82:	00016997          	auipc	s3,0x16
    80005a86:	50e98993          	addi	s3,s3,1294 # 8001bf90 <tx_lock>
    80005a8a:	00002917          	auipc	s2,0x2
    80005a8e:	dfa90913          	addi	s2,s2,-518 # 80007884 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005a92:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005a96:	4b05                	li	s6,1
    80005a98:	a005                	j	80005ab8 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005a9a:	85ce                	mv	a1,s3
    80005a9c:	854a                	mv	a0,s2
    80005a9e:	8fdfb0ef          	jal	8000139a <sleep>
    while(tx_busy != 0){
    80005aa2:	409c                	lw	a5,0(s1)
    80005aa4:	fbfd                	bnez	a5,80005a9a <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005aa6:	000a4783          	lbu	a5,0(s4)
    80005aaa:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005aae:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005ab2:	0a05                	addi	s4,s4,1
    80005ab4:	015a0563          	beq	s4,s5,80005abe <uartwrite+0x72>
    while(tx_busy != 0){
    80005ab8:	409c                	lw	a5,0(s1)
    80005aba:	f3e5                	bnez	a5,80005a9a <uartwrite+0x4e>
    80005abc:	b7ed                	j	80005aa6 <uartwrite+0x5a>
    80005abe:	7942                	ld	s2,48(sp)
    80005ac0:	79a2                	ld	s3,40(sp)
    80005ac2:	7a02                	ld	s4,32(sp)
    80005ac4:	6b42                	ld	s6,16(sp)
    80005ac6:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005ac8:	00016517          	auipc	a0,0x16
    80005acc:	4c850513          	addi	a0,a0,1224 # 8001bf90 <tx_lock>
    80005ad0:	21c000ef          	jal	80005cec <release>
}
    80005ad4:	60a6                	ld	ra,72(sp)
    80005ad6:	6406                	ld	s0,64(sp)
    80005ad8:	74e2                	ld	s1,56(sp)
    80005ada:	6ae2                	ld	s5,24(sp)
    80005adc:	6161                	addi	sp,sp,80
    80005ade:	8082                	ret

0000000080005ae0 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005ae0:	1101                	addi	sp,sp,-32
    80005ae2:	ec06                	sd	ra,24(sp)
    80005ae4:	e822                	sd	s0,16(sp)
    80005ae6:	e426                	sd	s1,8(sp)
    80005ae8:	1000                	addi	s0,sp,32
    80005aea:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005aec:	00002797          	auipc	a5,0x2
    80005af0:	d947a783          	lw	a5,-620(a5) # 80007880 <panicking>
    80005af4:	cf95                	beqz	a5,80005b30 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005af6:	00002797          	auipc	a5,0x2
    80005afa:	d867a783          	lw	a5,-634(a5) # 8000787c <panicked>
    80005afe:	ef85                	bnez	a5,80005b36 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005b00:	10000737          	lui	a4,0x10000
    80005b04:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005b06:	00074783          	lbu	a5,0(a4)
    80005b0a:	0207f793          	andi	a5,a5,32
    80005b0e:	dfe5                	beqz	a5,80005b06 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005b10:	0ff4f513          	zext.b	a0,s1
    80005b14:	100007b7          	lui	a5,0x10000
    80005b18:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005b1c:	00002797          	auipc	a5,0x2
    80005b20:	d647a783          	lw	a5,-668(a5) # 80007880 <panicking>
    80005b24:	cb91                	beqz	a5,80005b38 <uartputc_sync+0x58>
    pop_off();
}
    80005b26:	60e2                	ld	ra,24(sp)
    80005b28:	6442                	ld	s0,16(sp)
    80005b2a:	64a2                	ld	s1,8(sp)
    80005b2c:	6105                	addi	sp,sp,32
    80005b2e:	8082                	ret
    push_off();
    80005b30:	0e4000ef          	jal	80005c14 <push_off>
    80005b34:	b7c9                	j	80005af6 <uartputc_sync+0x16>
    for(;;)
    80005b36:	a001                	j	80005b36 <uartputc_sync+0x56>
    pop_off();
    80005b38:	164000ef          	jal	80005c9c <pop_off>
}
    80005b3c:	b7ed                	j	80005b26 <uartputc_sync+0x46>

0000000080005b3e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005b3e:	1141                	addi	sp,sp,-16
    80005b40:	e406                	sd	ra,8(sp)
    80005b42:	e022                	sd	s0,0(sp)
    80005b44:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005b46:	100007b7          	lui	a5,0x10000
    80005b4a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005b4e:	8b85                	andi	a5,a5,1
    80005b50:	cb89                	beqz	a5,80005b62 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005b52:	100007b7          	lui	a5,0x10000
    80005b56:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005b5a:	60a2                	ld	ra,8(sp)
    80005b5c:	6402                	ld	s0,0(sp)
    80005b5e:	0141                	addi	sp,sp,16
    80005b60:	8082                	ret
    return -1;
    80005b62:	557d                	li	a0,-1
    80005b64:	bfdd                	j	80005b5a <uartgetc+0x1c>

0000000080005b66 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005b66:	1101                	addi	sp,sp,-32
    80005b68:	ec06                	sd	ra,24(sp)
    80005b6a:	e822                	sd	s0,16(sp)
    80005b6c:	e426                	sd	s1,8(sp)
    80005b6e:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005b70:	100007b7          	lui	a5,0x10000
    80005b74:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005b78:	00016517          	auipc	a0,0x16
    80005b7c:	41850513          	addi	a0,a0,1048 # 8001bf90 <tx_lock>
    80005b80:	0d8000ef          	jal	80005c58 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005b84:	100007b7          	lui	a5,0x10000
    80005b88:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005b8c:	0207f793          	andi	a5,a5,32
    80005b90:	ef99                	bnez	a5,80005bae <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005b92:	00016517          	auipc	a0,0x16
    80005b96:	3fe50513          	addi	a0,a0,1022 # 8001bf90 <tx_lock>
    80005b9a:	152000ef          	jal	80005cec <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005b9e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005ba0:	f9fff0ef          	jal	80005b3e <uartgetc>
    if(c == -1)
    80005ba4:	02950063          	beq	a0,s1,80005bc4 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005ba8:	877ff0ef          	jal	8000541e <consoleintr>
  while(1){
    80005bac:	bfd5                	j	80005ba0 <uartintr+0x3a>
    tx_busy = 0;
    80005bae:	00002797          	auipc	a5,0x2
    80005bb2:	cc07ad23          	sw	zero,-806(a5) # 80007888 <tx_busy>
    wakeup(&tx_chan);
    80005bb6:	00002517          	auipc	a0,0x2
    80005bba:	cce50513          	addi	a0,a0,-818 # 80007884 <tx_chan>
    80005bbe:	829fb0ef          	jal	800013e6 <wakeup>
    80005bc2:	bfc1                	j	80005b92 <uartintr+0x2c>
  }
}
    80005bc4:	60e2                	ld	ra,24(sp)
    80005bc6:	6442                	ld	s0,16(sp)
    80005bc8:	64a2                	ld	s1,8(sp)
    80005bca:	6105                	addi	sp,sp,32
    80005bcc:	8082                	ret

0000000080005bce <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005bce:	1141                	addi	sp,sp,-16
    80005bd0:	e406                	sd	ra,8(sp)
    80005bd2:	e022                	sd	s0,0(sp)
    80005bd4:	0800                	addi	s0,sp,16
  lk->name = name;
    80005bd6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005bd8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005bdc:	00053823          	sd	zero,16(a0)
}
    80005be0:	60a2                	ld	ra,8(sp)
    80005be2:	6402                	ld	s0,0(sp)
    80005be4:	0141                	addi	sp,sp,16
    80005be6:	8082                	ret

0000000080005be8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005be8:	411c                	lw	a5,0(a0)
    80005bea:	e399                	bnez	a5,80005bf0 <holding+0x8>
    80005bec:	4501                	li	a0,0
  return r;
}
    80005bee:	8082                	ret
{
    80005bf0:	1101                	addi	sp,sp,-32
    80005bf2:	ec06                	sd	ra,24(sp)
    80005bf4:	e822                	sd	s0,16(sp)
    80005bf6:	e426                	sd	s1,8(sp)
    80005bf8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005bfa:	691c                	ld	a5,16(a0)
    80005bfc:	84be                	mv	s1,a5
    80005bfe:	976fb0ef          	jal	80000d74 <mycpu>
    80005c02:	40a48533          	sub	a0,s1,a0
    80005c06:	00153513          	seqz	a0,a0
}
    80005c0a:	60e2                	ld	ra,24(sp)
    80005c0c:	6442                	ld	s0,16(sp)
    80005c0e:	64a2                	ld	s1,8(sp)
    80005c10:	6105                	addi	sp,sp,32
    80005c12:	8082                	ret

0000000080005c14 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005c14:	1101                	addi	sp,sp,-32
    80005c16:	ec06                	sd	ra,24(sp)
    80005c18:	e822                	sd	s0,16(sp)
    80005c1a:	e426                	sd	s1,8(sp)
    80005c1c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005c1e:	100027f3          	csrr	a5,sstatus
    80005c22:	84be                	mv	s1,a5
    80005c24:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005c28:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005c2a:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005c2e:	946fb0ef          	jal	80000d74 <mycpu>
    80005c32:	5d3c                	lw	a5,120(a0)
    80005c34:	cb99                	beqz	a5,80005c4a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005c36:	93efb0ef          	jal	80000d74 <mycpu>
    80005c3a:	5d3c                	lw	a5,120(a0)
    80005c3c:	2785                	addiw	a5,a5,1
    80005c3e:	dd3c                	sw	a5,120(a0)
}
    80005c40:	60e2                	ld	ra,24(sp)
    80005c42:	6442                	ld	s0,16(sp)
    80005c44:	64a2                	ld	s1,8(sp)
    80005c46:	6105                	addi	sp,sp,32
    80005c48:	8082                	ret
    mycpu()->intena = old;
    80005c4a:	92afb0ef          	jal	80000d74 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005c4e:	0014d793          	srli	a5,s1,0x1
    80005c52:	8b85                	andi	a5,a5,1
    80005c54:	dd7c                	sw	a5,124(a0)
    80005c56:	b7c5                	j	80005c36 <push_off+0x22>

0000000080005c58 <acquire>:
{
    80005c58:	1101                	addi	sp,sp,-32
    80005c5a:	ec06                	sd	ra,24(sp)
    80005c5c:	e822                	sd	s0,16(sp)
    80005c5e:	e426                	sd	s1,8(sp)
    80005c60:	1000                	addi	s0,sp,32
    80005c62:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005c64:	fb1ff0ef          	jal	80005c14 <push_off>
  if(holding(lk))
    80005c68:	8526                	mv	a0,s1
    80005c6a:	f7fff0ef          	jal	80005be8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005c6e:	4705                	li	a4,1
  if(holding(lk))
    80005c70:	e105                	bnez	a0,80005c90 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005c72:	87ba                	mv	a5,a4
    80005c74:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005c78:	2781                	sext.w	a5,a5
    80005c7a:	ffe5                	bnez	a5,80005c72 <acquire+0x1a>
  __sync_synchronize();
    80005c7c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005c80:	8f4fb0ef          	jal	80000d74 <mycpu>
    80005c84:	e888                	sd	a0,16(s1)
}
    80005c86:	60e2                	ld	ra,24(sp)
    80005c88:	6442                	ld	s0,16(sp)
    80005c8a:	64a2                	ld	s1,8(sp)
    80005c8c:	6105                	addi	sp,sp,32
    80005c8e:	8082                	ret
    panic("acquire");
    80005c90:	00002517          	auipc	a0,0x2
    80005c94:	a7050513          	addi	a0,a0,-1424 # 80007700 <etext+0x700>
    80005c98:	cffff0ef          	jal	80005996 <panic>

0000000080005c9c <pop_off>:

void
pop_off(void)
{
    80005c9c:	1141                	addi	sp,sp,-16
    80005c9e:	e406                	sd	ra,8(sp)
    80005ca0:	e022                	sd	s0,0(sp)
    80005ca2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005ca4:	8d0fb0ef          	jal	80000d74 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005ca8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005cac:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005cae:	e39d                	bnez	a5,80005cd4 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005cb0:	5d3c                	lw	a5,120(a0)
    80005cb2:	02f05763          	blez	a5,80005ce0 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005cb6:	37fd                	addiw	a5,a5,-1
    80005cb8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005cba:	eb89                	bnez	a5,80005ccc <pop_off+0x30>
    80005cbc:	5d7c                	lw	a5,124(a0)
    80005cbe:	c799                	beqz	a5,80005ccc <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005cc0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005cc4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005cc8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005ccc:	60a2                	ld	ra,8(sp)
    80005cce:	6402                	ld	s0,0(sp)
    80005cd0:	0141                	addi	sp,sp,16
    80005cd2:	8082                	ret
    panic("pop_off - interruptible");
    80005cd4:	00002517          	auipc	a0,0x2
    80005cd8:	a3450513          	addi	a0,a0,-1484 # 80007708 <etext+0x708>
    80005cdc:	cbbff0ef          	jal	80005996 <panic>
    panic("pop_off");
    80005ce0:	00002517          	auipc	a0,0x2
    80005ce4:	a4050513          	addi	a0,a0,-1472 # 80007720 <etext+0x720>
    80005ce8:	cafff0ef          	jal	80005996 <panic>

0000000080005cec <release>:
{
    80005cec:	1101                	addi	sp,sp,-32
    80005cee:	ec06                	sd	ra,24(sp)
    80005cf0:	e822                	sd	s0,16(sp)
    80005cf2:	e426                	sd	s1,8(sp)
    80005cf4:	1000                	addi	s0,sp,32
    80005cf6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005cf8:	ef1ff0ef          	jal	80005be8 <holding>
    80005cfc:	c105                	beqz	a0,80005d1c <release+0x30>
  lk->cpu = 0;
    80005cfe:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005d02:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005d06:	0310000f          	fence	rw,w
    80005d0a:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005d0e:	f8fff0ef          	jal	80005c9c <pop_off>
}
    80005d12:	60e2                	ld	ra,24(sp)
    80005d14:	6442                	ld	s0,16(sp)
    80005d16:	64a2                	ld	s1,8(sp)
    80005d18:	6105                	addi	sp,sp,32
    80005d1a:	8082                	ret
    panic("release");
    80005d1c:	00002517          	auipc	a0,0x2
    80005d20:	a0c50513          	addi	a0,a0,-1524 # 80007728 <etext+0x728>
    80005d24:	c73ff0ef          	jal	80005996 <panic>
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
