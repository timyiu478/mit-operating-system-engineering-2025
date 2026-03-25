
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
    80000004:	d2010113          	addi	sp,sp,-736 # 80024d20 <stack0>
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
    80000016:	490050ef          	jal	800054a6 <start>

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
    8000002c:	dd078793          	addi	a5,a5,-560 # 8002cdf8 <end>
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
    80000056:	89e90913          	addi	s2,s2,-1890 # 800078f0 <kmem>
    8000005a:	854a                	mv	a0,s2
    8000005c:	6cd050ef          	jal	80005f28 <acquire>
  r->next = kmem.freelist;
    80000060:	01893783          	ld	a5,24(s2)
    80000064:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000066:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006a:	854a                	mv	a0,s2
    8000006c:	751050ef          	jal	80005fbc <release>
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
    80000084:	3e3050ef          	jal	80005c66 <panic>

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
    800000e4:	81050513          	addi	a0,a0,-2032 # 800078f0 <kmem>
    800000e8:	5b7050ef          	jal	80005e9e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000ec:	45c5                	li	a1,17
    800000ee:	05ee                	slli	a1,a1,0x1b
    800000f0:	0002d517          	auipc	a0,0x2d
    800000f4:	d0850513          	addi	a0,a0,-760 # 8002cdf8 <end>
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
    80000112:	7e250513          	addi	a0,a0,2018 # 800078f0 <kmem>
    80000116:	613050ef          	jal	80005f28 <acquire>
  r = kmem.freelist;
    8000011a:	00007497          	auipc	s1,0x7
    8000011e:	7ee4b483          	ld	s1,2030(s1) # 80007908 <kmem+0x18>
  if(r)
    80000122:	c49d                	beqz	s1,80000150 <kalloc+0x4c>
    kmem.freelist = r->next;
    80000124:	609c                	ld	a5,0(s1)
    80000126:	00007717          	auipc	a4,0x7
    8000012a:	7ef73123          	sd	a5,2018(a4) # 80007908 <kmem+0x18>
  release(&kmem.lock);
    8000012e:	00007517          	auipc	a0,0x7
    80000132:	7c250513          	addi	a0,a0,1986 # 800078f0 <kmem>
    80000136:	687050ef          	jal	80005fbc <release>

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
    80000154:	7a050513          	addi	a0,a0,1952 # 800078f0 <kmem>
    80000158:	665050ef          	jal	80005fbc <release>
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
    8000031c:	5a1000ef          	jal	800010bc <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000320:	00007717          	auipc	a4,0x7
    80000324:	5a070713          	addi	a4,a4,1440 # 800078c0 <started>
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
    80000334:	589000ef          	jal	800010bc <cpuid>
    80000338:	85aa                	mv	a1,a0
    8000033a:	00007517          	auipc	a0,0x7
    8000033e:	cfe50513          	addi	a0,a0,-770 # 80007038 <etext+0x38>
    80000342:	5fa050ef          	jal	8000593c <printf>
    kvminithart();    // turn on paging
    80000346:	080000ef          	jal	800003c6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000034a:	16d010ef          	jal	80001cb6 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000034e:	39b040ef          	jal	80004ee8 <plicinithart>
  }

  scheduler();        
    80000352:	24a010ef          	jal	8000159c <scheduler>
    consoleinit();
    80000356:	50c050ef          	jal	80005862 <consoleinit>
    printfinit();
    8000035a:	149050ef          	jal	80005ca2 <printfinit>
    printf("\n");
    8000035e:	00007517          	auipc	a0,0x7
    80000362:	cba50513          	addi	a0,a0,-838 # 80007018 <etext+0x18>
    80000366:	5d6050ef          	jal	8000593c <printf>
    printf("xv6 kernel is booting\n");
    8000036a:	00007517          	auipc	a0,0x7
    8000036e:	cb650513          	addi	a0,a0,-842 # 80007020 <etext+0x20>
    80000372:	5ca050ef          	jal	8000593c <printf>
    printf("\n");
    80000376:	00007517          	auipc	a0,0x7
    8000037a:	ca250513          	addi	a0,a0,-862 # 80007018 <etext+0x18>
    8000037e:	5be050ef          	jal	8000593c <printf>
    kinit();         // physical page allocator
    80000382:	d4fff0ef          	jal	800000d0 <kinit>
    kvminit();       // create kernel page table
    80000386:	2cc000ef          	jal	80000652 <kvminit>
    kvminithart();   // turn on paging
    8000038a:	03c000ef          	jal	800003c6 <kvminithart>
    procinit();      // process table
    8000038e:	479000ef          	jal	80001006 <procinit>
    trapinit();      // trap vectors
    80000392:	101010ef          	jal	80001c92 <trapinit>
    trapinithart();  // install kernel trap vector
    80000396:	121010ef          	jal	80001cb6 <trapinithart>
    plicinit();      // set up interrupt controller
    8000039a:	335040ef          	jal	80004ece <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000039e:	34b040ef          	jal	80004ee8 <plicinithart>
    binit();         // buffer cache
    800003a2:	1c6020ef          	jal	80002568 <binit>
    iinit();         // inode table
    800003a6:	718020ef          	jal	80002abe <iinit>
    fileinit();      // file table
    800003aa:	644030ef          	jal	800039ee <fileinit>
    virtio_disk_init(); // emulated hard disk
    800003ae:	42b040ef          	jal	80004fd8 <virtio_disk_init>
    userinit();      // first user process
    800003b2:	014010ef          	jal	800013c6 <userinit>
    __sync_synchronize();
    800003b6:	0330000f          	fence	rw,rw
    started = 1;
    800003ba:	4785                	li	a5,1
    800003bc:	00007717          	auipc	a4,0x7
    800003c0:	50f72223          	sw	a5,1284(a4) # 800078c0 <started>
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
    800003d6:	4f67b783          	ld	a5,1270(a5) # 800078c8 <kernel_pagetable>
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
    80000460:	007050ef          	jal	80005c66 <panic>
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
    80000538:	72e050ef          	jal	80005c66 <panic>
    panic("mappages: size not aligned");
    8000053c:	00007517          	auipc	a0,0x7
    80000540:	b3c50513          	addi	a0,a0,-1220 # 80007078 <etext+0x78>
    80000544:	722050ef          	jal	80005c66 <panic>
    panic("mappages: size");
    80000548:	00007517          	auipc	a0,0x7
    8000054c:	b5050513          	addi	a0,a0,-1200 # 80007098 <etext+0x98>
    80000550:	716050ef          	jal	80005c66 <panic>
      panic("mappages: remap");
    80000554:	00007517          	auipc	a0,0x7
    80000558:	b5450513          	addi	a0,a0,-1196 # 800070a8 <etext+0xa8>
    8000055c:	70a050ef          	jal	80005c66 <panic>
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
    800005a0:	6c6050ef          	jal	80005c66 <panic>

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
    80000642:	121000ef          	jal	80000f62 <proc_mapstacks>
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
    80000662:	26a7b523          	sd	a0,618(a5) # 800078c8 <kernel_pagetable>
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
    800006d6:	590050ef          	jal	80005c66 <panic>
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
    8000082c:	43a050ef          	jal	80005c66 <panic>
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
    8000095a:	30c050ef          	jal	80005c66 <panic>

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
    80000a4e:	6a2000ef          	jal	800010f0 <myproc>
    80000a52:	89aa                	mv	s3,a0
  if (va >= p->sz) {
    80000a54:	653c                	ld	a5,72(a0)
    80000a56:	16f96863          	bltu	s2,a5,80000bc6 <vmfault+0x190>
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
    80000a7e:	180a1463          	bnez	s4,80000c06 <vmfault+0x1d0>
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
    80000aaa:	16050163          	beqz	a0,80000c0c <vmfault+0x1d6>
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
    80000ad0:	1787b783          	ld	a5,376(a5) # fffffffffffff178 <end+0xffffffff7ffd2380>
    80000ad4:	40f70b33          	sub	s6,a4,a5
    begin_op();
    80000ad8:	3bb020ef          	jal	80003692 <begin_op>
    ilock(p->vma[i].f->ip);
    80000adc:	014907b3          	add	a5,s2,s4
    80000ae0:	0792                	slli	a5,a5,0x4
    80000ae2:	97ce                	add	a5,a5,s3
    80000ae4:	1907b783          	ld	a5,400(a5)
    80000ae8:	6f88                	ld	a0,24(a5)
    80000aea:	19c020ef          	jal	80002c86 <ilock>
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
    80000b12:	506020ef          	jal	80003018 <readi>
    80000b16:	8aaa                	mv	s5,a0
    iunlock(p->vma[i].f->ip);
    80000b18:	014907b3          	add	a5,s2,s4
    80000b1c:	0792                	slli	a5,a5,0x4
    80000b1e:	97ce                	add	a5,a5,s3
    80000b20:	1907b783          	ld	a5,400(a5)
    80000b24:	6f88                	ld	a0,24(a5)
    80000b26:	20e020ef          	jal	80002d34 <iunlock>
    end_op();
    80000b2a:	3d9020ef          	jal	80003702 <end_op>
    if (n < PGSIZE) {
    80000b2e:	6785                	lui	a5,0x1
    80000b30:	06fae763          	bltu	s5,a5,80000b9e <vmfault+0x168>
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
    80000b70:	e131                	bnez	a0,80000bb4 <vmfault+0x17e>
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
      p->killed = 1; // fatal fault
    80000b92:	4785                	li	a5,1
    80000b94:	02f9a423          	sw	a5,40(s3)
      return -1;
    80000b98:	57fd                	li	a5,-1
    80000b9a:	8bbe                	mv	s7,a5
    80000b9c:	b7cd                	j	80000b7e <vmfault+0x148>
      memset((void*)(mem + n), 0, PGSIZE - n);
    80000b9e:	020a9513          	slli	a0,s5,0x20
    80000ba2:	9101                	srli	a0,a0,0x20
    80000ba4:	6605                	lui	a2,0x1
    80000ba6:	4156063b          	subw	a2,a2,s5
    80000baa:	4581                	li	a1,0
    80000bac:	9562                	add	a0,a0,s8
    80000bae:	db0ff0ef          	jal	8000015e <memset>
    80000bb2:	b749                	j	80000b34 <vmfault+0xfe>
      kfree((void *)mem);
    80000bb4:	8562                	mv	a0,s8
    80000bb6:	c66ff0ef          	jal	8000001c <kfree>
      return 0;
    80000bba:	4b81                	li	s7,0
    80000bbc:	7aa2                	ld	s5,40(sp)
    80000bbe:	7b02                	ld	s6,32(sp)
    80000bc0:	6c42                	ld	s8,16(sp)
    80000bc2:	6ca2                	ld	s9,8(sp)
    80000bc4:	bf6d                	j	80000b7e <vmfault+0x148>
  va = PGROUNDDOWN(va);
    80000bc6:	77fd                	lui	a5,0xfffff
    80000bc8:	00f97933          	and	s2,s2,a5
  if(ismapped(pagetable, va)) {
    80000bcc:	85ca                	mv	a1,s2
    80000bce:	8526                	mv	a0,s1
    80000bd0:	e4bff0ef          	jal	80000a1a <ismapped>
    return 0;
    80000bd4:	4b81                	li	s7,0
  if(ismapped(pagetable, va)) {
    80000bd6:	f545                	bnez	a0,80000b7e <vmfault+0x148>
  mem = (uint64) kalloc();
    80000bd8:	d2cff0ef          	jal	80000104 <kalloc>
    80000bdc:	84aa                	mv	s1,a0
  if(mem == 0)
    80000bde:	d145                	beqz	a0,80000b7e <vmfault+0x148>
  mem = (uint64) kalloc();
    80000be0:	8baa                	mv	s7,a0
  memset((void *) mem, 0, PGSIZE);
    80000be2:	6605                	lui	a2,0x1
    80000be4:	4581                	li	a1,0
    80000be6:	d78ff0ef          	jal	8000015e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000bea:	4759                	li	a4,22
    80000bec:	86a6                	mv	a3,s1
    80000bee:	6605                	lui	a2,0x1
    80000bf0:	85ca                	mv	a1,s2
    80000bf2:	0509b503          	ld	a0,80(s3)
    80000bf6:	8d1ff0ef          	jal	800004c6 <mappages>
    80000bfa:	d151                	beqz	a0,80000b7e <vmfault+0x148>
    kfree((void *)mem);
    80000bfc:	8526                	mv	a0,s1
    80000bfe:	c1eff0ef          	jal	8000001c <kfree>
    return 0;
    80000c02:	4b81                	li	s7,0
    80000c04:	bfad                	j	80000b7e <vmfault+0x148>
    80000c06:	f456                	sd	s5,40(sp)
    80000c08:	e862                	sd	s8,16(sp)
    80000c0a:	bd59                	j	80000aa0 <vmfault+0x6a>
    80000c0c:	7aa2                	ld	s5,40(sp)
    80000c0e:	6c42                	ld	s8,16(sp)
    80000c10:	b7bd                	j	80000b7e <vmfault+0x148>

0000000080000c12 <copyout>:
  while(len > 0){
    80000c12:	cad1                	beqz	a3,80000ca6 <copyout+0x94>
{
    80000c14:	711d                	addi	sp,sp,-96
    80000c16:	ec86                	sd	ra,88(sp)
    80000c18:	e8a2                	sd	s0,80(sp)
    80000c1a:	e4a6                	sd	s1,72(sp)
    80000c1c:	e0ca                	sd	s2,64(sp)
    80000c1e:	fc4e                	sd	s3,56(sp)
    80000c20:	f852                	sd	s4,48(sp)
    80000c22:	f456                	sd	s5,40(sp)
    80000c24:	f05a                	sd	s6,32(sp)
    80000c26:	ec5e                	sd	s7,24(sp)
    80000c28:	e862                	sd	s8,16(sp)
    80000c2a:	e466                	sd	s9,8(sp)
    80000c2c:	e06a                	sd	s10,0(sp)
    80000c2e:	1080                	addi	s0,sp,96
    80000c30:	8baa                	mv	s7,a0
    80000c32:	8a2e                	mv	s4,a1
    80000c34:	8b32                	mv	s6,a2
    80000c36:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000c38:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80000c3a:	5cfd                	li	s9,-1
    80000c3c:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000c40:	6c05                	lui	s8,0x1
    80000c42:	a005                	j	80000c62 <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000c44:	409a0533          	sub	a0,s4,s1
    80000c48:	0009061b          	sext.w	a2,s2
    80000c4c:	85da                	mv	a1,s6
    80000c4e:	954e                	add	a0,a0,s3
    80000c50:	d6eff0ef          	jal	800001be <memmove>
    len -= n;
    80000c54:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000c58:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000c5a:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80000c5e:	040a8263          	beqz	s5,80000ca2 <copyout+0x90>
    va0 = PGROUNDDOWN(dstva);
    80000c62:	01aa74b3          	and	s1,s4,s10
    if(va0 >= MAXVA)
    80000c66:	049ce263          	bltu	s9,s1,80000caa <copyout+0x98>
    pa0 = walkaddr(pagetable, va0);
    80000c6a:	85a6                	mv	a1,s1
    80000c6c:	855e                	mv	a0,s7
    80000c6e:	81fff0ef          	jal	8000048c <walkaddr>
    80000c72:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80000c74:	e901                	bnez	a0,80000c84 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000c76:	4601                	li	a2,0
    80000c78:	85a6                	mv	a1,s1
    80000c7a:	855e                	mv	a0,s7
    80000c7c:	dbbff0ef          	jal	80000a36 <vmfault>
    80000c80:	89aa                	mv	s3,a0
    80000c82:	c139                	beqz	a0,80000cc8 <copyout+0xb6>
    pte = walk(pagetable, va0, 0);
    80000c84:	4601                	li	a2,0
    80000c86:	85a6                	mv	a1,s1
    80000c88:	855e                	mv	a0,s7
    80000c8a:	f68ff0ef          	jal	800003f2 <walk>
    if((*pte & PTE_W) == 0)
    80000c8e:	611c                	ld	a5,0(a0)
    80000c90:	8b91                	andi	a5,a5,4
    80000c92:	cf8d                	beqz	a5,80000ccc <copyout+0xba>
    n = PGSIZE - (dstva - va0);
    80000c94:	41448933          	sub	s2,s1,s4
    80000c98:	9962                	add	s2,s2,s8
    if(n > len)
    80000c9a:	fb2af5e3          	bgeu	s5,s2,80000c44 <copyout+0x32>
    80000c9e:	8956                	mv	s2,s5
    80000ca0:	b755                	j	80000c44 <copyout+0x32>
  return 0;
    80000ca2:	4501                	li	a0,0
    80000ca4:	a021                	j	80000cac <copyout+0x9a>
    80000ca6:	4501                	li	a0,0
}
    80000ca8:	8082                	ret
      return -1;
    80000caa:	557d                	li	a0,-1
}
    80000cac:	60e6                	ld	ra,88(sp)
    80000cae:	6446                	ld	s0,80(sp)
    80000cb0:	64a6                	ld	s1,72(sp)
    80000cb2:	6906                	ld	s2,64(sp)
    80000cb4:	79e2                	ld	s3,56(sp)
    80000cb6:	7a42                	ld	s4,48(sp)
    80000cb8:	7aa2                	ld	s5,40(sp)
    80000cba:	7b02                	ld	s6,32(sp)
    80000cbc:	6be2                	ld	s7,24(sp)
    80000cbe:	6c42                	ld	s8,16(sp)
    80000cc0:	6ca2                	ld	s9,8(sp)
    80000cc2:	6d02                	ld	s10,0(sp)
    80000cc4:	6125                	addi	sp,sp,96
    80000cc6:	8082                	ret
        return -1;
    80000cc8:	557d                	li	a0,-1
    80000cca:	b7cd                	j	80000cac <copyout+0x9a>
      return -1;
    80000ccc:	557d                	li	a0,-1
    80000cce:	bff9                	j	80000cac <copyout+0x9a>

0000000080000cd0 <copyin>:
  while(len > 0){
    80000cd0:	c6c9                	beqz	a3,80000d5a <copyin+0x8a>
{
    80000cd2:	715d                	addi	sp,sp,-80
    80000cd4:	e486                	sd	ra,72(sp)
    80000cd6:	e0a2                	sd	s0,64(sp)
    80000cd8:	fc26                	sd	s1,56(sp)
    80000cda:	f84a                	sd	s2,48(sp)
    80000cdc:	f44e                	sd	s3,40(sp)
    80000cde:	f052                	sd	s4,32(sp)
    80000ce0:	ec56                	sd	s5,24(sp)
    80000ce2:	e85a                	sd	s6,16(sp)
    80000ce4:	e45e                	sd	s7,8(sp)
    80000ce6:	e062                	sd	s8,0(sp)
    80000ce8:	0880                	addi	s0,sp,80
    80000cea:	8baa                	mv	s7,a0
    80000cec:	8aae                	mv	s5,a1
    80000cee:	8932                	mv	s2,a2
    80000cf0:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000cf2:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000cf4:	6b05                	lui	s6,0x1
    80000cf6:	a035                	j	80000d22 <copyin+0x52>
    80000cf8:	412984b3          	sub	s1,s3,s2
    80000cfc:	94da                	add	s1,s1,s6
    if(n > len)
    80000cfe:	009a7363          	bgeu	s4,s1,80000d04 <copyin+0x34>
    80000d02:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000d04:	413905b3          	sub	a1,s2,s3
    80000d08:	0004861b          	sext.w	a2,s1
    80000d0c:	95aa                	add	a1,a1,a0
    80000d0e:	8556                	mv	a0,s5
    80000d10:	caeff0ef          	jal	800001be <memmove>
    len -= n;
    80000d14:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000d18:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000d1a:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000d1e:	020a0163          	beqz	s4,80000d40 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000d22:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000d26:	85ce                	mv	a1,s3
    80000d28:	855e                	mv	a0,s7
    80000d2a:	f62ff0ef          	jal	8000048c <walkaddr>
    if(pa0 == 0) {
    80000d2e:	f569                	bnez	a0,80000cf8 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000d30:	4601                	li	a2,0
    80000d32:	85ce                	mv	a1,s3
    80000d34:	855e                	mv	a0,s7
    80000d36:	d01ff0ef          	jal	80000a36 <vmfault>
    80000d3a:	fd5d                	bnez	a0,80000cf8 <copyin+0x28>
        return -1;
    80000d3c:	557d                	li	a0,-1
    80000d3e:	a011                	j	80000d42 <copyin+0x72>
  return 0;
    80000d40:	4501                	li	a0,0
}
    80000d42:	60a6                	ld	ra,72(sp)
    80000d44:	6406                	ld	s0,64(sp)
    80000d46:	74e2                	ld	s1,56(sp)
    80000d48:	7942                	ld	s2,48(sp)
    80000d4a:	79a2                	ld	s3,40(sp)
    80000d4c:	7a02                	ld	s4,32(sp)
    80000d4e:	6ae2                	ld	s5,24(sp)
    80000d50:	6b42                	ld	s6,16(sp)
    80000d52:	6ba2                	ld	s7,8(sp)
    80000d54:	6c02                	ld	s8,0(sp)
    80000d56:	6161                	addi	sp,sp,80
    80000d58:	8082                	ret
  return 0;
    80000d5a:	4501                	li	a0,0
}
    80000d5c:	8082                	ret

0000000080000d5e <uvmunmap_vma>:

int
uvmunmap_vma(pagetable_t pagetable, struct VMA *vma, uint64 addr, uint64 end)
{
    80000d5e:	7175                	addi	sp,sp,-144
    80000d60:	e506                	sd	ra,136(sp)
    80000d62:	e122                	sd	s0,128(sp)
    80000d64:	0900                	addi	s0,sp,144
    80000d66:	f8a43423          	sd	a0,-120(s0)
    80000d6a:	f6b43c23          	sd	a1,-136(s0)
  if (vma->valid == 0)
    80000d6e:	419c                	lw	a5,0(a1)
    80000d70:	1c078463          	beqz	a5,80000f38 <uvmunmap_vma+0x1da>
    80000d74:	f86a                	sd	s10,48(sp)
    return -1;

  // No overlap
  if (vma->end <= addr || vma->start >= end)
    80000d76:	0105bd03          	ld	s10,16(a1)
    80000d7a:	1da67163          	bgeu	a2,s10,80000f3c <uvmunmap_vma+0x1de>
    80000d7e:	659c                	ld	a5,8(a1)
    80000d80:	1cd7f163          	bgeu	a5,a3,80000f42 <uvmunmap_vma+0x1e4>

  // Calculate correct unmap range for this VMA
  uint64 unmap_start = (addr > vma->start) ? addr : vma->start;
  uint64 unmap_end   = (end < vma->end)    ? end  : vma->end;

  if (unmap_start != vma->start && unmap_end != vma->end) {
    80000d84:	01a6f463          	bgeu	a3,s10,80000d8c <uvmunmap_vma+0x2e>
    80000d88:	04c7ef63          	bltu	a5,a2,80000de6 <uvmunmap_vma+0x88>
    80000d8c:	fca6                	sd	s1,120(sp)
  uint64 unmap_start = (addr > vma->start) ? addr : vma->start;
    80000d8e:	f6f43823          	sd	a5,-144(s0)
    80000d92:	00c7f463          	bgeu	a5,a2,80000d9a <uvmunmap_vma+0x3c>
    80000d96:	f6c43823          	sd	a2,-144(s0)
  uint64 unmap_end   = (end < vma->end)    ? end  : vma->end;
    80000d9a:	01a6f363          	bgeu	a3,s10,80000da0 <uvmunmap_vma+0x42>
    80000d9e:	8d36                	mv	s10,a3
    return -1;
  }
  
  // If the file is mapped MAP_SHARED,
  // write the dirty page back to the file.
  if (vma->flags & MAP_SHARED) {
    80000da0:	f7843683          	ld	a3,-136(s0)
    80000da4:	4ed8                	lw	a4,28(a3)
    80000da6:	8b05                	andi	a4,a4,1
    80000da8:	10070363          	beqz	a4,80000eae <uvmunmap_vma+0x150>
    80000dac:	ecd6                	sd	s5,88(sp)
    uint64 addr = unmap_start;
    uint offset = vma->offset + (addr - vma->start);
    pte_t *pte;

    for(; addr < unmap_end; addr += PGSIZE){
    80000dae:	f7043a83          	ld	s5,-144(s0)
    80000db2:	13aafa63          	bgeu	s5,s10,80000ee6 <uvmunmap_vma+0x188>
    80000db6:	f8ca                	sd	s2,112(sp)
    80000db8:	f4ce                	sd	s3,104(sp)
    80000dba:	f0d2                	sd	s4,96(sp)
    80000dbc:	e8da                	sd	s6,80(sp)
    80000dbe:	e4de                	sd	s7,72(sp)
    80000dc0:	e0e2                	sd	s8,64(sp)
    80000dc2:	fc66                	sd	s9,56(sp)
    80000dc4:	f46e                	sd	s11,40(sp)
    uint offset = vma->offset + (addr - vma->start);
    80000dc6:	40fa87bb          	subw	a5,s5,a5
    80000dca:	0286ab83          	lw	s7,40(a3) # fffffffffffff028 <end+0xffffffff7ffd2230>
    80000dce:	00fb8bbb          	addw	s7,s7,a5

      // write back to file without expanding the file size
      int size = f->ip->size - offset; // file length starts from offset
      if (size < 0) {
        break;
      } else if (size < n) {
    80000dd2:	6d85                	lui	s11,0x1
        n = size;
      }

      while(i < n){
        int n1 = n - i;
        if(n1 > max)
    80000dd4:	c00d8c13          	addi	s8,s11,-1024 # c00 <_entry-0x7ffff400>
    80000dd8:	6785                	lui	a5,0x1
    80000dda:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80000dde:	f8f42223          	sw	a5,-124(s0)
          n1 = max;
        begin_op();
        ilock(f->ip);
        // printf("write back, vma %p, unmmap_end %p, addr %p, offset %d, file size %d, n %d , n1 %d\n", (void *)vma, (void *)unmap_end, (void *)addr, offset, f->ip->size, n, n1);
        if ((r = writei(f->ip, 1, addr + i, offset, n1)) > 0)
    80000de2:	4c85                	li	s9,1
    80000de4:	a88d                	j	80000e56 <uvmunmap_vma+0xf8>
    printf("munmap: cant punch a hole in the middle of a region\n");
    80000de6:	00006517          	auipc	a0,0x6
    80000dea:	31250513          	addi	a0,a0,786 # 800070f8 <etext+0xf8>
    80000dee:	34f040ef          	jal	8000593c <printf>
    return -1;
    80000df2:	557d                	li	a0,-1
    80000df4:	7d42                	ld	s10,48(sp)
    80000df6:	a0e5                	j	80000ede <uvmunmap_vma+0x180>
        if(n1 > max)
    80000df8:	2481                	sext.w	s1,s1
        begin_op();
    80000dfa:	099020ef          	jal	80003692 <begin_op>
        ilock(f->ip);
    80000dfe:	018a3503          	ld	a0,24(s4) # 1018 <_entry-0x7fffefe8>
    80000e02:	685010ef          	jal	80002c86 <ilock>
        if ((r = writei(f->ip, 1, addr + i, offset, n1)) > 0)
    80000e06:	8726                	mv	a4,s1
    80000e08:	86de                	mv	a3,s7
    80000e0a:	01598633          	add	a2,s3,s5
    80000e0e:	85e6                	mv	a1,s9
    80000e10:	018a3503          	ld	a0,24(s4)
    80000e14:	2f6020ef          	jal	8000310a <writei>
    80000e18:	892a                	mv	s2,a0
    80000e1a:	00a05463          	blez	a0,80000e22 <uvmunmap_vma+0xc4>
          offset += r;
    80000e1e:	01750bbb          	addw	s7,a0,s7
        iunlock(f->ip);
    80000e22:	018a3503          	ld	a0,24(s4)
    80000e26:	70f010ef          	jal	80002d34 <iunlock>
        end_op();
    80000e2a:	0d9020ef          	jal	80003702 <end_op>
        if(r != n1){
    80000e2e:	00991f63          	bne	s2,s1,80000e4c <uvmunmap_vma+0xee>
          // error from writei
          break;
        }
        i += r;
    80000e32:	013489bb          	addw	s3,s1,s3
      while(i < n){
    80000e36:	0169db63          	bge	s3,s6,80000e4c <uvmunmap_vma+0xee>
        int n1 = n - i;
    80000e3a:	413b07bb          	subw	a5,s6,s3
    80000e3e:	84be                	mv	s1,a5
        if(n1 > max)
    80000e40:	fafc5ce3          	bge	s8,a5,80000df8 <uvmunmap_vma+0x9a>
    80000e44:	f8442483          	lw	s1,-124(s0)
    80000e48:	bf45                	j	80000df8 <uvmunmap_vma+0x9a>
      while(i < n){
    80000e4a:	4981                	li	s3,0
      }
      if (i != n)
    80000e4c:	0f3b1e63          	bne	s6,s3,80000f48 <uvmunmap_vma+0x1ea>
    for(; addr < unmap_end; addr += PGSIZE){
    80000e50:	9aee                	add	s5,s5,s11
    80000e52:	05aaf563          	bgeu	s5,s10,80000e9c <uvmunmap_vma+0x13e>
      if((pte = walk(pagetable, addr, 0)) == 0) // leaf page table entry allocated?
    80000e56:	4601                	li	a2,0
    80000e58:	85d6                	mv	a1,s5
    80000e5a:	f8843503          	ld	a0,-120(s0)
    80000e5e:	d94ff0ef          	jal	800003f2 <walk>
    80000e62:	d57d                	beqz	a0,80000e50 <uvmunmap_vma+0xf2>
      if((*pte & PTE_V) == 0 || (*pte & PTE_D) == 0)
    80000e64:	611c                	ld	a5,0(a0)
    80000e66:	0817f793          	andi	a5,a5,129
    80000e6a:	08100713          	li	a4,129
    80000e6e:	fee791e3          	bne	a5,a4,80000e50 <uvmunmap_vma+0xf2>
      struct file *f = vma->f;
    80000e72:	f7843783          	ld	a5,-136(s0)
    80000e76:	0207ba03          	ld	s4,32(a5)
      int size = f->ip->size - offset; // file length starts from offset
    80000e7a:	018a3783          	ld	a5,24(s4)
    80000e7e:	47fc                	lw	a5,76(a5)
    80000e80:	417787bb          	subw	a5,a5,s7
    80000e84:	873e                	mv	a4,a5
      if (size < 0) {
    80000e86:	0607c263          	bltz	a5,80000eea <uvmunmap_vma+0x18c>
      } else if (size < n) {
    80000e8a:	8b3e                	mv	s6,a5
    80000e8c:	00fdd363          	bge	s11,a5,80000e92 <uvmunmap_vma+0x134>
    80000e90:	6b05                	lui	s6,0x1
    80000e92:	2b01                	sext.w	s6,s6
      while(i < n){
    80000e94:	fae05be3          	blez	a4,80000e4a <uvmunmap_vma+0xec>
    80000e98:	4981                	li	s3,0
    80000e9a:	b745                	j	80000e3a <uvmunmap_vma+0xdc>
    80000e9c:	7946                	ld	s2,112(sp)
    80000e9e:	79a6                	ld	s3,104(sp)
    80000ea0:	7a06                	ld	s4,96(sp)
    80000ea2:	6ae6                	ld	s5,88(sp)
    80000ea4:	6b46                	ld	s6,80(sp)
    80000ea6:	6ba6                	ld	s7,72(sp)
    80000ea8:	6c06                	ld	s8,64(sp)
    80000eaa:	7ce2                	ld	s9,56(sp)
    80000eac:	7da2                	ld	s11,40(sp)
        return -1;
    }
  }

  // Unmap the pages
  uvmunmap(pagetable, unmap_start, (unmap_end-unmap_start)/PGSIZE, 1);
    80000eae:	f7043483          	ld	s1,-144(s0)
    80000eb2:	409d0633          	sub	a2,s10,s1
    80000eb6:	4685                	li	a3,1
    80000eb8:	8231                	srli	a2,a2,0xc
    80000eba:	85a6                	mv	a1,s1
    80000ebc:	f8843503          	ld	a0,-120(s0)
    80000ec0:	fd4ff0ef          	jal	80000694 <uvmunmap>

  if (unmap_start == vma->start && unmap_end == vma->end) {
    80000ec4:	f7843783          	ld	a5,-136(s0)
    80000ec8:	679c                	ld	a5,8(a5)
    80000eca:	02978a63          	beq	a5,s1,80000efe <uvmunmap_vma+0x1a0>
    // Shrink from front
    vma->offset += (unmap_end - vma->start);
    vma->start = unmap_end;
  } else {
    // Shrink from back
    vma->end = unmap_start;
    80000ece:	f7843783          	ld	a5,-136(s0)
    80000ed2:	f7043703          	ld	a4,-144(s0)
    80000ed6:	eb98                	sd	a4,16(a5)
  }

  return 0;
    80000ed8:	4501                	li	a0,0
    80000eda:	74e6                	ld	s1,120(sp)
    80000edc:	7d42                	ld	s10,48(sp)
}
    80000ede:	60aa                	ld	ra,136(sp)
    80000ee0:	640a                	ld	s0,128(sp)
    80000ee2:	6149                	addi	sp,sp,144
    80000ee4:	8082                	ret
    80000ee6:	6ae6                	ld	s5,88(sp)
    80000ee8:	b7d9                	j	80000eae <uvmunmap_vma+0x150>
    80000eea:	7946                	ld	s2,112(sp)
    80000eec:	79a6                	ld	s3,104(sp)
    80000eee:	7a06                	ld	s4,96(sp)
    80000ef0:	6ae6                	ld	s5,88(sp)
    80000ef2:	6b46                	ld	s6,80(sp)
    80000ef4:	6ba6                	ld	s7,72(sp)
    80000ef6:	6c06                	ld	s8,64(sp)
    80000ef8:	7ce2                	ld	s9,56(sp)
    80000efa:	7da2                	ld	s11,40(sp)
    80000efc:	bf4d                	j	80000eae <uvmunmap_vma+0x150>
  if (unmap_start == vma->start && unmap_end == vma->end) {
    80000efe:	f7843703          	ld	a4,-136(s0)
    80000f02:	6b18                	ld	a4,16(a4)
    80000f04:	01a70f63          	beq	a4,s10,80000f22 <uvmunmap_vma+0x1c4>
    vma->offset += (unmap_end - vma->start);
    80000f08:	40fd07bb          	subw	a5,s10,a5
    80000f0c:	f7843683          	ld	a3,-136(s0)
    80000f10:	5698                	lw	a4,40(a3)
    80000f12:	9fb9                	addw	a5,a5,a4
    80000f14:	d69c                	sw	a5,40(a3)
    vma->start = unmap_end;
    80000f16:	01a6b423          	sd	s10,8(a3)
  return 0;
    80000f1a:	4501                	li	a0,0
    80000f1c:	74e6                	ld	s1,120(sp)
    80000f1e:	7d42                	ld	s10,48(sp)
    80000f20:	bf7d                	j	80000ede <uvmunmap_vma+0x180>
    fileclose(vma->f);
    80000f22:	f7843483          	ld	s1,-136(s0)
    80000f26:	7088                	ld	a0,32(s1)
    80000f28:	38f020ef          	jal	80003ab6 <fileclose>
    vma->valid = 0;
    80000f2c:	0004a023          	sw	zero,0(s1)
  return 0;
    80000f30:	4501                	li	a0,0
    vma->valid = 0;
    80000f32:	74e6                	ld	s1,120(sp)
    80000f34:	7d42                	ld	s10,48(sp)
    80000f36:	b765                	j	80000ede <uvmunmap_vma+0x180>
    return -1;
    80000f38:	557d                	li	a0,-1
    80000f3a:	b755                	j	80000ede <uvmunmap_vma+0x180>
      return -1;
    80000f3c:	557d                	li	a0,-1
    80000f3e:	7d42                	ld	s10,48(sp)
    80000f40:	bf79                	j	80000ede <uvmunmap_vma+0x180>
    80000f42:	557d                	li	a0,-1
    80000f44:	7d42                	ld	s10,48(sp)
    80000f46:	bf61                	j	80000ede <uvmunmap_vma+0x180>
        return -1;
    80000f48:	557d                	li	a0,-1
    80000f4a:	74e6                	ld	s1,120(sp)
    80000f4c:	7946                	ld	s2,112(sp)
    80000f4e:	79a6                	ld	s3,104(sp)
    80000f50:	7a06                	ld	s4,96(sp)
    80000f52:	6ae6                	ld	s5,88(sp)
    80000f54:	6b46                	ld	s6,80(sp)
    80000f56:	6ba6                	ld	s7,72(sp)
    80000f58:	6c06                	ld	s8,64(sp)
    80000f5a:	7ce2                	ld	s9,56(sp)
    80000f5c:	7d42                	ld	s10,48(sp)
    80000f5e:	7da2                	ld	s11,40(sp)
    80000f60:	bfbd                	j	80000ede <uvmunmap_vma+0x180>

0000000080000f62 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000f62:	715d                	addi	sp,sp,-80
    80000f64:	e486                	sd	ra,72(sp)
    80000f66:	e0a2                	sd	s0,64(sp)
    80000f68:	fc26                	sd	s1,56(sp)
    80000f6a:	f84a                	sd	s2,48(sp)
    80000f6c:	f44e                	sd	s3,40(sp)
    80000f6e:	f052                	sd	s4,32(sp)
    80000f70:	ec56                	sd	s5,24(sp)
    80000f72:	e85a                	sd	s6,16(sp)
    80000f74:	e45e                	sd	s7,8(sp)
    80000f76:	e062                	sd	s8,0(sp)
    80000f78:	0880                	addi	s0,sp,80
    80000f7a:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f7c:	00007497          	auipc	s1,0x7
    80000f80:	dc448493          	addi	s1,s1,-572 # 80007d40 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000f84:	8c26                	mv	s8,s1
    80000f86:	000e37b7          	lui	a5,0xe3
    80000f8a:	27b78793          	addi	a5,a5,635 # e327b <_entry-0x7ff1cd85>
    80000f8e:	07b2                	slli	a5,a5,0xc
    80000f90:	97778793          	addi	a5,a5,-1673
    80000f94:	193d5937          	lui	s2,0x193d5
    80000f98:	bb790913          	addi	s2,s2,-1097 # 193d4bb7 <_entry-0x66c2b449>
    80000f9c:	1902                	slli	s2,s2,0x20
    80000f9e:	993e                	add	s2,s2,a5
    80000fa0:	040009b7          	lui	s3,0x4000
    80000fa4:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000fa6:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000fa8:	4b99                	li	s7,6
    80000faa:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fac:	00019a97          	auipc	s5,0x19
    80000fb0:	994a8a93          	addi	s5,s5,-1644 # 80019940 <tickslock>
    char *pa = kalloc();
    80000fb4:	950ff0ef          	jal	80000104 <kalloc>
    80000fb8:	862a                	mv	a2,a0
    if(pa == 0)
    80000fba:	c121                	beqz	a0,80000ffa <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    80000fbc:	418485b3          	sub	a1,s1,s8
    80000fc0:	8591                	srai	a1,a1,0x4
    80000fc2:	032585b3          	mul	a1,a1,s2
    80000fc6:	05b6                	slli	a1,a1,0xd
    80000fc8:	6789                	lui	a5,0x2
    80000fca:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000fcc:	875e                	mv	a4,s7
    80000fce:	86da                	mv	a3,s6
    80000fd0:	40b985b3          	sub	a1,s3,a1
    80000fd4:	8552                	mv	a0,s4
    80000fd6:	da6ff0ef          	jal	8000057c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fda:	47048493          	addi	s1,s1,1136
    80000fde:	fd549be3          	bne	s1,s5,80000fb4 <proc_mapstacks+0x52>
  }
}
    80000fe2:	60a6                	ld	ra,72(sp)
    80000fe4:	6406                	ld	s0,64(sp)
    80000fe6:	74e2                	ld	s1,56(sp)
    80000fe8:	7942                	ld	s2,48(sp)
    80000fea:	79a2                	ld	s3,40(sp)
    80000fec:	7a02                	ld	s4,32(sp)
    80000fee:	6ae2                	ld	s5,24(sp)
    80000ff0:	6b42                	ld	s6,16(sp)
    80000ff2:	6ba2                	ld	s7,8(sp)
    80000ff4:	6c02                	ld	s8,0(sp)
    80000ff6:	6161                	addi	sp,sp,80
    80000ff8:	8082                	ret
      panic("kalloc");
    80000ffa:	00006517          	auipc	a0,0x6
    80000ffe:	13650513          	addi	a0,a0,310 # 80007130 <etext+0x130>
    80001002:	465040ef          	jal	80005c66 <panic>

0000000080001006 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001006:	7139                	addi	sp,sp,-64
    80001008:	fc06                	sd	ra,56(sp)
    8000100a:	f822                	sd	s0,48(sp)
    8000100c:	f426                	sd	s1,40(sp)
    8000100e:	f04a                	sd	s2,32(sp)
    80001010:	ec4e                	sd	s3,24(sp)
    80001012:	e852                	sd	s4,16(sp)
    80001014:	e456                	sd	s5,8(sp)
    80001016:	e05a                	sd	s6,0(sp)
    80001018:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    8000101a:	00006597          	auipc	a1,0x6
    8000101e:	11e58593          	addi	a1,a1,286 # 80007138 <etext+0x138>
    80001022:	00007517          	auipc	a0,0x7
    80001026:	8ee50513          	addi	a0,a0,-1810 # 80007910 <pid_lock>
    8000102a:	675040ef          	jal	80005e9e <initlock>
  initlock(&wait_lock, "wait_lock");
    8000102e:	00006597          	auipc	a1,0x6
    80001032:	11258593          	addi	a1,a1,274 # 80007140 <etext+0x140>
    80001036:	00007517          	auipc	a0,0x7
    8000103a:	8f250513          	addi	a0,a0,-1806 # 80007928 <wait_lock>
    8000103e:	661040ef          	jal	80005e9e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001042:	00007497          	auipc	s1,0x7
    80001046:	cfe48493          	addi	s1,s1,-770 # 80007d40 <proc>
      initlock(&p->lock, "proc");
    8000104a:	00006b17          	auipc	s6,0x6
    8000104e:	106b0b13          	addi	s6,s6,262 # 80007150 <etext+0x150>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80001052:	8aa6                	mv	s5,s1
    80001054:	000e37b7          	lui	a5,0xe3
    80001058:	27b78793          	addi	a5,a5,635 # e327b <_entry-0x7ff1cd85>
    8000105c:	07b2                	slli	a5,a5,0xc
    8000105e:	97778793          	addi	a5,a5,-1673
    80001062:	193d5937          	lui	s2,0x193d5
    80001066:	bb790913          	addi	s2,s2,-1097 # 193d4bb7 <_entry-0x66c2b449>
    8000106a:	1902                	slli	s2,s2,0x20
    8000106c:	993e                	add	s2,s2,a5
    8000106e:	040009b7          	lui	s3,0x4000
    80001072:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80001074:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80001076:	00019a17          	auipc	s4,0x19
    8000107a:	8caa0a13          	addi	s4,s4,-1846 # 80019940 <tickslock>
      initlock(&p->lock, "proc");
    8000107e:	85da                	mv	a1,s6
    80001080:	8526                	mv	a0,s1
    80001082:	61d040ef          	jal	80005e9e <initlock>
      p->state = UNUSED;
    80001086:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    8000108a:	415487b3          	sub	a5,s1,s5
    8000108e:	8791                	srai	a5,a5,0x4
    80001090:	032787b3          	mul	a5,a5,s2
    80001094:	07b6                	slli	a5,a5,0xd
    80001096:	6709                	lui	a4,0x2
    80001098:	9fb9                	addw	a5,a5,a4
    8000109a:	40f987b3          	sub	a5,s3,a5
    8000109e:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800010a0:	47048493          	addi	s1,s1,1136
    800010a4:	fd449de3          	bne	s1,s4,8000107e <procinit+0x78>
  }
}
    800010a8:	70e2                	ld	ra,56(sp)
    800010aa:	7442                	ld	s0,48(sp)
    800010ac:	74a2                	ld	s1,40(sp)
    800010ae:	7902                	ld	s2,32(sp)
    800010b0:	69e2                	ld	s3,24(sp)
    800010b2:	6a42                	ld	s4,16(sp)
    800010b4:	6aa2                	ld	s5,8(sp)
    800010b6:	6b02                	ld	s6,0(sp)
    800010b8:	6121                	addi	sp,sp,64
    800010ba:	8082                	ret

00000000800010bc <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    800010bc:	1141                	addi	sp,sp,-16
    800010be:	e406                	sd	ra,8(sp)
    800010c0:	e022                	sd	s0,0(sp)
    800010c2:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    800010c4:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    800010c6:	2501                	sext.w	a0,a0
    800010c8:	60a2                	ld	ra,8(sp)
    800010ca:	6402                	ld	s0,0(sp)
    800010cc:	0141                	addi	sp,sp,16
    800010ce:	8082                	ret

00000000800010d0 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    800010d0:	1141                	addi	sp,sp,-16
    800010d2:	e406                	sd	ra,8(sp)
    800010d4:	e022                	sd	s0,0(sp)
    800010d6:	0800                	addi	s0,sp,16
    800010d8:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    800010da:	2781                	sext.w	a5,a5
    800010dc:	079e                	slli	a5,a5,0x7
  return c;
}
    800010de:	00007517          	auipc	a0,0x7
    800010e2:	86250513          	addi	a0,a0,-1950 # 80007940 <cpus>
    800010e6:	953e                	add	a0,a0,a5
    800010e8:	60a2                	ld	ra,8(sp)
    800010ea:	6402                	ld	s0,0(sp)
    800010ec:	0141                	addi	sp,sp,16
    800010ee:	8082                	ret

00000000800010f0 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    800010f0:	1101                	addi	sp,sp,-32
    800010f2:	ec06                	sd	ra,24(sp)
    800010f4:	e822                	sd	s0,16(sp)
    800010f6:	e426                	sd	s1,8(sp)
    800010f8:	1000                	addi	s0,sp,32
  push_off();
    800010fa:	5eb040ef          	jal	80005ee4 <push_off>
    800010fe:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001100:	2781                	sext.w	a5,a5
    80001102:	079e                	slli	a5,a5,0x7
    80001104:	00007717          	auipc	a4,0x7
    80001108:	80c70713          	addi	a4,a4,-2036 # 80007910 <pid_lock>
    8000110c:	97ba                	add	a5,a5,a4
    8000110e:	7b9c                	ld	a5,48(a5)
    80001110:	84be                	mv	s1,a5
  pop_off();
    80001112:	65b040ef          	jal	80005f6c <pop_off>
  return p;
}
    80001116:	8526                	mv	a0,s1
    80001118:	60e2                	ld	ra,24(sp)
    8000111a:	6442                	ld	s0,16(sp)
    8000111c:	64a2                	ld	s1,8(sp)
    8000111e:	6105                	addi	sp,sp,32
    80001120:	8082                	ret

0000000080001122 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001122:	7179                	addi	sp,sp,-48
    80001124:	f406                	sd	ra,40(sp)
    80001126:	f022                	sd	s0,32(sp)
    80001128:	ec26                	sd	s1,24(sp)
    8000112a:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000112c:	fc5ff0ef          	jal	800010f0 <myproc>
    80001130:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001132:	68b040ef          	jal	80005fbc <release>

  if (first) {
    80001136:	00006797          	auipc	a5,0x6
    8000113a:	77a7a783          	lw	a5,1914(a5) # 800078b0 <first.1>
    8000113e:	cf95                	beqz	a5,8000117a <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001140:	4505                	li	a0,1
    80001142:	639010ef          	jal	80002f7a <fsinit>

    first = 0;
    80001146:	00006797          	auipc	a5,0x6
    8000114a:	7607a523          	sw	zero,1898(a5) # 800078b0 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000114e:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001152:	00006797          	auipc	a5,0x6
    80001156:	00678793          	addi	a5,a5,6 # 80007158 <etext+0x158>
    8000115a:	fcf43823          	sd	a5,-48(s0)
    8000115e:	fc043c23          	sd	zero,-40(s0)
    80001162:	fd040593          	addi	a1,s0,-48
    80001166:	853e                	mv	a0,a5
    80001168:	791020ef          	jal	800040f8 <kexec>
    8000116c:	6cbc                	ld	a5,88(s1)
    8000116e:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80001170:	6cbc                	ld	a5,88(s1)
    80001172:	7bb8                	ld	a4,112(a5)
    80001174:	57fd                	li	a5,-1
    80001176:	02f70d63          	beq	a4,a5,800011b0 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    8000117a:	359000ef          	jal	80001cd2 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    8000117e:	68a8                	ld	a0,80(s1)
    80001180:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001182:	04000737          	lui	a4,0x4000
    80001186:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001188:	0732                	slli	a4,a4,0xc
    8000118a:	00005797          	auipc	a5,0x5
    8000118e:	f1278793          	addi	a5,a5,-238 # 8000609c <userret>
    80001192:	00005697          	auipc	a3,0x5
    80001196:	e6e68693          	addi	a3,a3,-402 # 80006000 <_trampoline>
    8000119a:	8f95                	sub	a5,a5,a3
    8000119c:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    8000119e:	577d                	li	a4,-1
    800011a0:	177e                	slli	a4,a4,0x3f
    800011a2:	8d59                	or	a0,a0,a4
    800011a4:	9782                	jalr	a5
}
    800011a6:	70a2                	ld	ra,40(sp)
    800011a8:	7402                	ld	s0,32(sp)
    800011aa:	64e2                	ld	s1,24(sp)
    800011ac:	6145                	addi	sp,sp,48
    800011ae:	8082                	ret
      panic("exec");
    800011b0:	00006517          	auipc	a0,0x6
    800011b4:	fb050513          	addi	a0,a0,-80 # 80007160 <etext+0x160>
    800011b8:	2af040ef          	jal	80005c66 <panic>

00000000800011bc <allocpid>:
{
    800011bc:	1101                	addi	sp,sp,-32
    800011be:	ec06                	sd	ra,24(sp)
    800011c0:	e822                	sd	s0,16(sp)
    800011c2:	e426                	sd	s1,8(sp)
    800011c4:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    800011c6:	00006517          	auipc	a0,0x6
    800011ca:	74a50513          	addi	a0,a0,1866 # 80007910 <pid_lock>
    800011ce:	55b040ef          	jal	80005f28 <acquire>
  pid = nextpid;
    800011d2:	00006797          	auipc	a5,0x6
    800011d6:	6e278793          	addi	a5,a5,1762 # 800078b4 <nextpid>
    800011da:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    800011dc:	0014871b          	addiw	a4,s1,1
    800011e0:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    800011e2:	00006517          	auipc	a0,0x6
    800011e6:	72e50513          	addi	a0,a0,1838 # 80007910 <pid_lock>
    800011ea:	5d3040ef          	jal	80005fbc <release>
}
    800011ee:	8526                	mv	a0,s1
    800011f0:	60e2                	ld	ra,24(sp)
    800011f2:	6442                	ld	s0,16(sp)
    800011f4:	64a2                	ld	s1,8(sp)
    800011f6:	6105                	addi	sp,sp,32
    800011f8:	8082                	ret

00000000800011fa <proc_pagetable>:
{
    800011fa:	1101                	addi	sp,sp,-32
    800011fc:	ec06                	sd	ra,24(sp)
    800011fe:	e822                	sd	s0,16(sp)
    80001200:	e426                	sd	s1,8(sp)
    80001202:	e04a                	sd	s2,0(sp)
    80001204:	1000                	addi	s0,sp,32
    80001206:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001208:	c66ff0ef          	jal	8000066e <uvmcreate>
    8000120c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000120e:	cd05                	beqz	a0,80001246 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001210:	4729                	li	a4,10
    80001212:	00005697          	auipc	a3,0x5
    80001216:	dee68693          	addi	a3,a3,-530 # 80006000 <_trampoline>
    8000121a:	6605                	lui	a2,0x1
    8000121c:	040005b7          	lui	a1,0x4000
    80001220:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001222:	05b2                	slli	a1,a1,0xc
    80001224:	aa2ff0ef          	jal	800004c6 <mappages>
    80001228:	02054663          	bltz	a0,80001254 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000122c:	4719                	li	a4,6
    8000122e:	05893683          	ld	a3,88(s2)
    80001232:	6605                	lui	a2,0x1
    80001234:	020005b7          	lui	a1,0x2000
    80001238:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000123a:	05b6                	slli	a1,a1,0xd
    8000123c:	8526                	mv	a0,s1
    8000123e:	a88ff0ef          	jal	800004c6 <mappages>
    80001242:	00054f63          	bltz	a0,80001260 <proc_pagetable+0x66>
}
    80001246:	8526                	mv	a0,s1
    80001248:	60e2                	ld	ra,24(sp)
    8000124a:	6442                	ld	s0,16(sp)
    8000124c:	64a2                	ld	s1,8(sp)
    8000124e:	6902                	ld	s2,0(sp)
    80001250:	6105                	addi	sp,sp,32
    80001252:	8082                	ret
    uvmfree(pagetable, 0);
    80001254:	4581                	li	a1,0
    80001256:	8526                	mv	a0,s1
    80001258:	e10ff0ef          	jal	80000868 <uvmfree>
    return 0;
    8000125c:	4481                	li	s1,0
    8000125e:	b7e5                	j	80001246 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001260:	4681                	li	a3,0
    80001262:	4605                	li	a2,1
    80001264:	040005b7          	lui	a1,0x4000
    80001268:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000126a:	05b2                	slli	a1,a1,0xc
    8000126c:	8526                	mv	a0,s1
    8000126e:	c26ff0ef          	jal	80000694 <uvmunmap>
    uvmfree(pagetable, 0);
    80001272:	4581                	li	a1,0
    80001274:	8526                	mv	a0,s1
    80001276:	df2ff0ef          	jal	80000868 <uvmfree>
    return 0;
    8000127a:	4481                	li	s1,0
    8000127c:	b7e9                	j	80001246 <proc_pagetable+0x4c>

000000008000127e <proc_freepagetable>:
{
    8000127e:	1101                	addi	sp,sp,-32
    80001280:	ec06                	sd	ra,24(sp)
    80001282:	e822                	sd	s0,16(sp)
    80001284:	e426                	sd	s1,8(sp)
    80001286:	e04a                	sd	s2,0(sp)
    80001288:	1000                	addi	s0,sp,32
    8000128a:	84aa                	mv	s1,a0
    8000128c:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000128e:	4681                	li	a3,0
    80001290:	4605                	li	a2,1
    80001292:	040005b7          	lui	a1,0x4000
    80001296:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001298:	05b2                	slli	a1,a1,0xc
    8000129a:	bfaff0ef          	jal	80000694 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    8000129e:	4681                	li	a3,0
    800012a0:	4605                	li	a2,1
    800012a2:	020005b7          	lui	a1,0x2000
    800012a6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800012a8:	05b6                	slli	a1,a1,0xd
    800012aa:	8526                	mv	a0,s1
    800012ac:	be8ff0ef          	jal	80000694 <uvmunmap>
  uvmfree(pagetable, sz);
    800012b0:	85ca                	mv	a1,s2
    800012b2:	8526                	mv	a0,s1
    800012b4:	db4ff0ef          	jal	80000868 <uvmfree>
}
    800012b8:	60e2                	ld	ra,24(sp)
    800012ba:	6442                	ld	s0,16(sp)
    800012bc:	64a2                	ld	s1,8(sp)
    800012be:	6902                	ld	s2,0(sp)
    800012c0:	6105                	addi	sp,sp,32
    800012c2:	8082                	ret

00000000800012c4 <freeproc>:
{
    800012c4:	1101                	addi	sp,sp,-32
    800012c6:	ec06                	sd	ra,24(sp)
    800012c8:	e822                	sd	s0,16(sp)
    800012ca:	e426                	sd	s1,8(sp)
    800012cc:	1000                	addi	s0,sp,32
    800012ce:	84aa                	mv	s1,a0
  if(p->trapframe)
    800012d0:	6d28                	ld	a0,88(a0)
    800012d2:	c119                	beqz	a0,800012d8 <freeproc+0x14>
    kfree((void*)p->trapframe);
    800012d4:	d49fe0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    800012d8:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    800012dc:	68a8                	ld	a0,80(s1)
    800012de:	c501                	beqz	a0,800012e6 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    800012e0:	64ac                	ld	a1,72(s1)
    800012e2:	f9dff0ef          	jal	8000127e <proc_freepagetable>
  p->pagetable = 0;
    800012e6:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    800012ea:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    800012ee:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    800012f2:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    800012f6:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    800012fa:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800012fe:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001302:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001306:	0004ac23          	sw	zero,24(s1)
}
    8000130a:	60e2                	ld	ra,24(sp)
    8000130c:	6442                	ld	s0,16(sp)
    8000130e:	64a2                	ld	s1,8(sp)
    80001310:	6105                	addi	sp,sp,32
    80001312:	8082                	ret

0000000080001314 <allocproc>:
{
    80001314:	1101                	addi	sp,sp,-32
    80001316:	ec06                	sd	ra,24(sp)
    80001318:	e822                	sd	s0,16(sp)
    8000131a:	e426                	sd	s1,8(sp)
    8000131c:	e04a                	sd	s2,0(sp)
    8000131e:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80001320:	00007497          	auipc	s1,0x7
    80001324:	a2048493          	addi	s1,s1,-1504 # 80007d40 <proc>
    80001328:	00018917          	auipc	s2,0x18
    8000132c:	61890913          	addi	s2,s2,1560 # 80019940 <tickslock>
    acquire(&p->lock);
    80001330:	8526                	mv	a0,s1
    80001332:	3f7040ef          	jal	80005f28 <acquire>
    if(p->state == UNUSED) {
    80001336:	4c9c                	lw	a5,24(s1)
    80001338:	cb91                	beqz	a5,8000134c <allocproc+0x38>
      release(&p->lock);
    8000133a:	8526                	mv	a0,s1
    8000133c:	481040ef          	jal	80005fbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001340:	47048493          	addi	s1,s1,1136
    80001344:	ff2496e3          	bne	s1,s2,80001330 <allocproc+0x1c>
  return 0;
    80001348:	4481                	li	s1,0
    8000134a:	a0b9                	j	80001398 <allocproc+0x84>
  p->pid = allocpid();
    8000134c:	e71ff0ef          	jal	800011bc <allocpid>
    80001350:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001352:	4785                	li	a5,1
    80001354:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001356:	daffe0ef          	jal	80000104 <kalloc>
    8000135a:	892a                	mv	s2,a0
    8000135c:	eca8                	sd	a0,88(s1)
    8000135e:	c521                	beqz	a0,800013a6 <allocproc+0x92>
  p->pagetable = proc_pagetable(p);
    80001360:	8526                	mv	a0,s1
    80001362:	e99ff0ef          	jal	800011fa <proc_pagetable>
    80001366:	892a                	mv	s2,a0
    80001368:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000136a:	c531                	beqz	a0,800013b6 <allocproc+0xa2>
  p->mmap_base = TRAPFRAME;
    8000136c:	020007b7          	lui	a5,0x2000
    80001370:	17fd                	addi	a5,a5,-1 # 1ffffff <_entry-0x7e000001>
    80001372:	07b6                	slli	a5,a5,0xd
    80001374:	16f4b423          	sd	a5,360(s1)
  memset(&p->context, 0, sizeof(p->context));
    80001378:	07000613          	li	a2,112
    8000137c:	4581                	li	a1,0
    8000137e:	06048513          	addi	a0,s1,96
    80001382:	dddfe0ef          	jal	8000015e <memset>
  p->context.ra = (uint64)forkret;
    80001386:	00000797          	auipc	a5,0x0
    8000138a:	d9c78793          	addi	a5,a5,-612 # 80001122 <forkret>
    8000138e:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001390:	60bc                	ld	a5,64(s1)
    80001392:	6705                	lui	a4,0x1
    80001394:	97ba                	add	a5,a5,a4
    80001396:	f4bc                	sd	a5,104(s1)
}
    80001398:	8526                	mv	a0,s1
    8000139a:	60e2                	ld	ra,24(sp)
    8000139c:	6442                	ld	s0,16(sp)
    8000139e:	64a2                	ld	s1,8(sp)
    800013a0:	6902                	ld	s2,0(sp)
    800013a2:	6105                	addi	sp,sp,32
    800013a4:	8082                	ret
    freeproc(p);
    800013a6:	8526                	mv	a0,s1
    800013a8:	f1dff0ef          	jal	800012c4 <freeproc>
    release(&p->lock);
    800013ac:	8526                	mv	a0,s1
    800013ae:	40f040ef          	jal	80005fbc <release>
    return 0;
    800013b2:	84ca                	mv	s1,s2
    800013b4:	b7d5                	j	80001398 <allocproc+0x84>
    freeproc(p);
    800013b6:	8526                	mv	a0,s1
    800013b8:	f0dff0ef          	jal	800012c4 <freeproc>
    release(&p->lock);
    800013bc:	8526                	mv	a0,s1
    800013be:	3ff040ef          	jal	80005fbc <release>
    return 0;
    800013c2:	84ca                	mv	s1,s2
    800013c4:	bfd1                	j	80001398 <allocproc+0x84>

00000000800013c6 <userinit>:
{
    800013c6:	1101                	addi	sp,sp,-32
    800013c8:	ec06                	sd	ra,24(sp)
    800013ca:	e822                	sd	s0,16(sp)
    800013cc:	e426                	sd	s1,8(sp)
    800013ce:	1000                	addi	s0,sp,32
  p = allocproc();
    800013d0:	f45ff0ef          	jal	80001314 <allocproc>
    800013d4:	84aa                	mv	s1,a0
  initproc = p;
    800013d6:	00006797          	auipc	a5,0x6
    800013da:	4ea7bd23          	sd	a0,1274(a5) # 800078d0 <initproc>
  p->cwd = namei("/");
    800013de:	00006517          	auipc	a0,0x6
    800013e2:	d8a50513          	addi	a0,a0,-630 # 80007168 <etext+0x168>
    800013e6:	0ce020ef          	jal	800034b4 <namei>
    800013ea:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    800013ee:	478d                	li	a5,3
    800013f0:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800013f2:	8526                	mv	a0,s1
    800013f4:	3c9040ef          	jal	80005fbc <release>
}
    800013f8:	60e2                	ld	ra,24(sp)
    800013fa:	6442                	ld	s0,16(sp)
    800013fc:	64a2                	ld	s1,8(sp)
    800013fe:	6105                	addi	sp,sp,32
    80001400:	8082                	ret

0000000080001402 <growproc>:
{
    80001402:	1101                	addi	sp,sp,-32
    80001404:	ec06                	sd	ra,24(sp)
    80001406:	e822                	sd	s0,16(sp)
    80001408:	e426                	sd	s1,8(sp)
    8000140a:	e04a                	sd	s2,0(sp)
    8000140c:	1000                	addi	s0,sp,32
    8000140e:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001410:	ce1ff0ef          	jal	800010f0 <myproc>
    80001414:	84aa                	mv	s1,a0
  sz = p->sz;
    80001416:	652c                	ld	a1,72(a0)
  if(n > 0){
    80001418:	01204c63          	bgtz	s2,80001430 <growproc+0x2e>
  } else if(n < 0){
    8000141c:	02094463          	bltz	s2,80001444 <growproc+0x42>
  p->sz = sz;
    80001420:	e4ac                	sd	a1,72(s1)
  return 0;
    80001422:	4501                	li	a0,0
}
    80001424:	60e2                	ld	ra,24(sp)
    80001426:	6442                	ld	s0,16(sp)
    80001428:	64a2                	ld	s1,8(sp)
    8000142a:	6902                	ld	s2,0(sp)
    8000142c:	6105                	addi	sp,sp,32
    8000142e:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001430:	4691                	li	a3,4
    80001432:	00b90633          	add	a2,s2,a1
    80001436:	6928                	ld	a0,80(a0)
    80001438:	b2aff0ef          	jal	80000762 <uvmalloc>
    8000143c:	85aa                	mv	a1,a0
    8000143e:	f16d                	bnez	a0,80001420 <growproc+0x1e>
      return -1;
    80001440:	557d                	li	a0,-1
    80001442:	b7cd                	j	80001424 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001444:	00b90633          	add	a2,s2,a1
    80001448:	6928                	ld	a0,80(a0)
    8000144a:	ad4ff0ef          	jal	8000071e <uvmdealloc>
    8000144e:	85aa                	mv	a1,a0
    80001450:	bfc1                	j	80001420 <growproc+0x1e>

0000000080001452 <kfork>:
{
    80001452:	7139                	addi	sp,sp,-64
    80001454:	fc06                	sd	ra,56(sp)
    80001456:	f822                	sd	s0,48(sp)
    80001458:	f426                	sd	s1,40(sp)
    8000145a:	e456                	sd	s5,8(sp)
    8000145c:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    8000145e:	c93ff0ef          	jal	800010f0 <myproc>
    80001462:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001464:	eb1ff0ef          	jal	80001314 <allocproc>
    80001468:	12050863          	beqz	a0,80001598 <kfork+0x146>
    8000146c:	e852                	sd	s4,16(sp)
    8000146e:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    80001470:	048ab603          	ld	a2,72(s5)
    80001474:	692c                	ld	a1,80(a0)
    80001476:	050ab503          	ld	a0,80(s5)
    8000147a:	c20ff0ef          	jal	8000089a <uvmcopy>
    8000147e:	02054263          	bltz	a0,800014a2 <kfork+0x50>
    80001482:	f04a                	sd	s2,32(sp)
    80001484:	ec4e                	sd	s3,24(sp)
    80001486:	e05a                	sd	s6,0(sp)
  np->sz = p->sz;
    80001488:	048ab783          	ld	a5,72(s5)
    8000148c:	04fa3423          	sd	a5,72(s4)
  for (uint i=0; i < NVMA; i++) {
    80001490:	170a8493          	addi	s1,s5,368
    80001494:	170a0913          	addi	s2,s4,368
    80001498:	470a8993          	addi	s3,s5,1136
      memmove(&np->vma[i], &p->vma[i], sizeof(struct VMA));
    8000149c:	03000b13          	li	s6,48
    800014a0:	a005                	j	800014c0 <kfork+0x6e>
    freeproc(np);
    800014a2:	8552                	mv	a0,s4
    800014a4:	e21ff0ef          	jal	800012c4 <freeproc>
    release(&np->lock);
    800014a8:	8552                	mv	a0,s4
    800014aa:	313040ef          	jal	80005fbc <release>
    return -1;
    800014ae:	54fd                	li	s1,-1
    800014b0:	6a42                	ld	s4,16(sp)
    800014b2:	a8e1                	j	8000158a <kfork+0x138>
  for (uint i=0; i < NVMA; i++) {
    800014b4:	03048493          	addi	s1,s1,48
    800014b8:	03090913          	addi	s2,s2,48
    800014bc:	01348f63          	beq	s1,s3,800014da <kfork+0x88>
    if (p->vma[i].valid) {
    800014c0:	409c                	lw	a5,0(s1)
    800014c2:	dbed                	beqz	a5,800014b4 <kfork+0x62>
      memmove(&np->vma[i], &p->vma[i], sizeof(struct VMA));
    800014c4:	865a                	mv	a2,s6
    800014c6:	85a6                	mv	a1,s1
    800014c8:	854a                	mv	a0,s2
    800014ca:	cf5fe0ef          	jal	800001be <memmove>
      p->vma[i].f = filedup(np->vma[i].f);
    800014ce:	02093503          	ld	a0,32(s2)
    800014d2:	59e020ef          	jal	80003a70 <filedup>
    800014d6:	f088                	sd	a0,32(s1)
    800014d8:	bff1                	j	800014b4 <kfork+0x62>
  *(np->trapframe) = *(p->trapframe);
    800014da:	058ab683          	ld	a3,88(s5)
    800014de:	87b6                	mv	a5,a3
    800014e0:	058a3703          	ld	a4,88(s4)
    800014e4:	12068693          	addi	a3,a3,288
    800014e8:	6388                	ld	a0,0(a5)
    800014ea:	678c                	ld	a1,8(a5)
    800014ec:	6b90                	ld	a2,16(a5)
    800014ee:	e308                	sd	a0,0(a4)
    800014f0:	e70c                	sd	a1,8(a4)
    800014f2:	eb10                	sd	a2,16(a4)
    800014f4:	6f90                	ld	a2,24(a5)
    800014f6:	ef10                	sd	a2,24(a4)
    800014f8:	02078793          	addi	a5,a5,32
    800014fc:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001500:	fed794e3          	bne	a5,a3,800014e8 <kfork+0x96>
  np->trapframe->a0 = 0;
    80001504:	058a3783          	ld	a5,88(s4)
    80001508:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000150c:	0d0a8493          	addi	s1,s5,208
    80001510:	0d0a0913          	addi	s2,s4,208
    80001514:	150a8993          	addi	s3,s5,336
    80001518:	a029                	j	80001522 <kfork+0xd0>
    8000151a:	04a1                	addi	s1,s1,8
    8000151c:	0921                	addi	s2,s2,8
    8000151e:	01348963          	beq	s1,s3,80001530 <kfork+0xde>
    if(p->ofile[i])
    80001522:	6088                	ld	a0,0(s1)
    80001524:	d97d                	beqz	a0,8000151a <kfork+0xc8>
      np->ofile[i] = filedup(p->ofile[i]);
    80001526:	54a020ef          	jal	80003a70 <filedup>
    8000152a:	00a93023          	sd	a0,0(s2)
    8000152e:	b7f5                	j	8000151a <kfork+0xc8>
  np->cwd = idup(p->cwd);
    80001530:	150ab503          	ld	a0,336(s5)
    80001534:	71c010ef          	jal	80002c50 <idup>
    80001538:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    8000153c:	4641                	li	a2,16
    8000153e:	158a8593          	addi	a1,s5,344
    80001542:	158a0513          	addi	a0,s4,344
    80001546:	d6dfe0ef          	jal	800002b2 <safestrcpy>
  pid = np->pid;
    8000154a:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    8000154e:	8552                	mv	a0,s4
    80001550:	26d040ef          	jal	80005fbc <release>
  acquire(&wait_lock);
    80001554:	00006517          	auipc	a0,0x6
    80001558:	3d450513          	addi	a0,a0,980 # 80007928 <wait_lock>
    8000155c:	1cd040ef          	jal	80005f28 <acquire>
  np->parent = p;
    80001560:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    80001564:	00006517          	auipc	a0,0x6
    80001568:	3c450513          	addi	a0,a0,964 # 80007928 <wait_lock>
    8000156c:	251040ef          	jal	80005fbc <release>
  acquire(&np->lock);
    80001570:	8552                	mv	a0,s4
    80001572:	1b7040ef          	jal	80005f28 <acquire>
  np->state = RUNNABLE;
    80001576:	478d                	li	a5,3
    80001578:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    8000157c:	8552                	mv	a0,s4
    8000157e:	23f040ef          	jal	80005fbc <release>
  return pid;
    80001582:	7902                	ld	s2,32(sp)
    80001584:	69e2                	ld	s3,24(sp)
    80001586:	6a42                	ld	s4,16(sp)
    80001588:	6b02                	ld	s6,0(sp)
}
    8000158a:	8526                	mv	a0,s1
    8000158c:	70e2                	ld	ra,56(sp)
    8000158e:	7442                	ld	s0,48(sp)
    80001590:	74a2                	ld	s1,40(sp)
    80001592:	6aa2                	ld	s5,8(sp)
    80001594:	6121                	addi	sp,sp,64
    80001596:	8082                	ret
    return -1;
    80001598:	54fd                	li	s1,-1
    8000159a:	bfc5                	j	8000158a <kfork+0x138>

000000008000159c <scheduler>:
{
    8000159c:	715d                	addi	sp,sp,-80
    8000159e:	e486                	sd	ra,72(sp)
    800015a0:	e0a2                	sd	s0,64(sp)
    800015a2:	fc26                	sd	s1,56(sp)
    800015a4:	f84a                	sd	s2,48(sp)
    800015a6:	f44e                	sd	s3,40(sp)
    800015a8:	f052                	sd	s4,32(sp)
    800015aa:	ec56                	sd	s5,24(sp)
    800015ac:	e85a                	sd	s6,16(sp)
    800015ae:	e45e                	sd	s7,8(sp)
    800015b0:	e062                	sd	s8,0(sp)
    800015b2:	0880                	addi	s0,sp,80
    800015b4:	8792                	mv	a5,tp
  int id = r_tp();
    800015b6:	2781                	sext.w	a5,a5
  c->proc = 0;
    800015b8:	00779b13          	slli	s6,a5,0x7
    800015bc:	00006717          	auipc	a4,0x6
    800015c0:	35470713          	addi	a4,a4,852 # 80007910 <pid_lock>
    800015c4:	975a                	add	a4,a4,s6
    800015c6:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800015ca:	00006717          	auipc	a4,0x6
    800015ce:	37e70713          	addi	a4,a4,894 # 80007948 <cpus+0x8>
    800015d2:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800015d4:	4c11                	li	s8,4
        c->proc = p;
    800015d6:	079e                	slli	a5,a5,0x7
    800015d8:	00006a17          	auipc	s4,0x6
    800015dc:	338a0a13          	addi	s4,s4,824 # 80007910 <pid_lock>
    800015e0:	9a3e                	add	s4,s4,a5
        found = 1;
    800015e2:	4b85                	li	s7,1
    800015e4:	a83d                	j	80001622 <scheduler+0x86>
      release(&p->lock);
    800015e6:	8526                	mv	a0,s1
    800015e8:	1d5040ef          	jal	80005fbc <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800015ec:	47048493          	addi	s1,s1,1136
    800015f0:	03248563          	beq	s1,s2,8000161a <scheduler+0x7e>
      acquire(&p->lock);
    800015f4:	8526                	mv	a0,s1
    800015f6:	133040ef          	jal	80005f28 <acquire>
      if(p->state == RUNNABLE) {
    800015fa:	4c9c                	lw	a5,24(s1)
    800015fc:	ff3795e3          	bne	a5,s3,800015e6 <scheduler+0x4a>
        p->state = RUNNING;
    80001600:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001604:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001608:	06048593          	addi	a1,s1,96
    8000160c:	855a                	mv	a0,s6
    8000160e:	61a000ef          	jal	80001c28 <swtch>
        c->proc = 0;
    80001612:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001616:	8ade                	mv	s5,s7
    80001618:	b7f9                	j	800015e6 <scheduler+0x4a>
    if(found == 0) {
    8000161a:	000a9463          	bnez	s5,80001622 <scheduler+0x86>
      asm volatile("wfi");
    8000161e:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001622:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001626:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000162a:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000162e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001632:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001634:	10079073          	csrw	sstatus,a5
    int found = 0;
    80001638:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000163a:	00006497          	auipc	s1,0x6
    8000163e:	70648493          	addi	s1,s1,1798 # 80007d40 <proc>
      if(p->state == RUNNABLE) {
    80001642:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    80001644:	00018917          	auipc	s2,0x18
    80001648:	2fc90913          	addi	s2,s2,764 # 80019940 <tickslock>
    8000164c:	b765                	j	800015f4 <scheduler+0x58>

000000008000164e <sched>:
{
    8000164e:	7179                	addi	sp,sp,-48
    80001650:	f406                	sd	ra,40(sp)
    80001652:	f022                	sd	s0,32(sp)
    80001654:	ec26                	sd	s1,24(sp)
    80001656:	e84a                	sd	s2,16(sp)
    80001658:	e44e                	sd	s3,8(sp)
    8000165a:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    8000165c:	a95ff0ef          	jal	800010f0 <myproc>
    80001660:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001662:	057040ef          	jal	80005eb8 <holding>
    80001666:	c935                	beqz	a0,800016da <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001668:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    8000166a:	2781                	sext.w	a5,a5
    8000166c:	079e                	slli	a5,a5,0x7
    8000166e:	00006717          	auipc	a4,0x6
    80001672:	2a270713          	addi	a4,a4,674 # 80007910 <pid_lock>
    80001676:	97ba                	add	a5,a5,a4
    80001678:	0a87a703          	lw	a4,168(a5)
    8000167c:	4785                	li	a5,1
    8000167e:	06f71463          	bne	a4,a5,800016e6 <sched+0x98>
  if(p->state == RUNNING)
    80001682:	4c98                	lw	a4,24(s1)
    80001684:	4791                	li	a5,4
    80001686:	06f70663          	beq	a4,a5,800016f2 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000168a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000168e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001690:	e7bd                	bnez	a5,800016fe <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001692:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001694:	00006917          	auipc	s2,0x6
    80001698:	27c90913          	addi	s2,s2,636 # 80007910 <pid_lock>
    8000169c:	2781                	sext.w	a5,a5
    8000169e:	079e                	slli	a5,a5,0x7
    800016a0:	97ca                	add	a5,a5,s2
    800016a2:	0ac7a983          	lw	s3,172(a5)
    800016a6:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    800016a8:	2781                	sext.w	a5,a5
    800016aa:	079e                	slli	a5,a5,0x7
    800016ac:	07a1                	addi	a5,a5,8
    800016ae:	00006597          	auipc	a1,0x6
    800016b2:	29258593          	addi	a1,a1,658 # 80007940 <cpus>
    800016b6:	95be                	add	a1,a1,a5
    800016b8:	06048513          	addi	a0,s1,96
    800016bc:	56c000ef          	jal	80001c28 <swtch>
    800016c0:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800016c2:	2781                	sext.w	a5,a5
    800016c4:	079e                	slli	a5,a5,0x7
    800016c6:	993e                	add	s2,s2,a5
    800016c8:	0b392623          	sw	s3,172(s2)
}
    800016cc:	70a2                	ld	ra,40(sp)
    800016ce:	7402                	ld	s0,32(sp)
    800016d0:	64e2                	ld	s1,24(sp)
    800016d2:	6942                	ld	s2,16(sp)
    800016d4:	69a2                	ld	s3,8(sp)
    800016d6:	6145                	addi	sp,sp,48
    800016d8:	8082                	ret
    panic("sched p->lock");
    800016da:	00006517          	auipc	a0,0x6
    800016de:	a9650513          	addi	a0,a0,-1386 # 80007170 <etext+0x170>
    800016e2:	584040ef          	jal	80005c66 <panic>
    panic("sched locks");
    800016e6:	00006517          	auipc	a0,0x6
    800016ea:	a9a50513          	addi	a0,a0,-1382 # 80007180 <etext+0x180>
    800016ee:	578040ef          	jal	80005c66 <panic>
    panic("sched RUNNING");
    800016f2:	00006517          	auipc	a0,0x6
    800016f6:	a9e50513          	addi	a0,a0,-1378 # 80007190 <etext+0x190>
    800016fa:	56c040ef          	jal	80005c66 <panic>
    panic("sched interruptible");
    800016fe:	00006517          	auipc	a0,0x6
    80001702:	aa250513          	addi	a0,a0,-1374 # 800071a0 <etext+0x1a0>
    80001706:	560040ef          	jal	80005c66 <panic>

000000008000170a <yield>:
{
    8000170a:	1101                	addi	sp,sp,-32
    8000170c:	ec06                	sd	ra,24(sp)
    8000170e:	e822                	sd	s0,16(sp)
    80001710:	e426                	sd	s1,8(sp)
    80001712:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001714:	9ddff0ef          	jal	800010f0 <myproc>
    80001718:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000171a:	00f040ef          	jal	80005f28 <acquire>
  p->state = RUNNABLE;
    8000171e:	478d                	li	a5,3
    80001720:	cc9c                	sw	a5,24(s1)
  sched();
    80001722:	f2dff0ef          	jal	8000164e <sched>
  release(&p->lock);
    80001726:	8526                	mv	a0,s1
    80001728:	095040ef          	jal	80005fbc <release>
}
    8000172c:	60e2                	ld	ra,24(sp)
    8000172e:	6442                	ld	s0,16(sp)
    80001730:	64a2                	ld	s1,8(sp)
    80001732:	6105                	addi	sp,sp,32
    80001734:	8082                	ret

0000000080001736 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    80001736:	7179                	addi	sp,sp,-48
    80001738:	f406                	sd	ra,40(sp)
    8000173a:	f022                	sd	s0,32(sp)
    8000173c:	ec26                	sd	s1,24(sp)
    8000173e:	e84a                	sd	s2,16(sp)
    80001740:	e44e                	sd	s3,8(sp)
    80001742:	1800                	addi	s0,sp,48
    80001744:	89aa                	mv	s3,a0
    80001746:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001748:	9a9ff0ef          	jal	800010f0 <myproc>
    8000174c:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    8000174e:	7da040ef          	jal	80005f28 <acquire>
  release(lk);
    80001752:	854a                	mv	a0,s2
    80001754:	069040ef          	jal	80005fbc <release>

  // Go to sleep.
  p->chan = chan;
    80001758:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    8000175c:	4789                	li	a5,2
    8000175e:	cc9c                	sw	a5,24(s1)

  sched();
    80001760:	eefff0ef          	jal	8000164e <sched>

  // Tidy up.
  p->chan = 0;
    80001764:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    80001768:	8526                	mv	a0,s1
    8000176a:	053040ef          	jal	80005fbc <release>
  acquire(lk);
    8000176e:	854a                	mv	a0,s2
    80001770:	7b8040ef          	jal	80005f28 <acquire>
}
    80001774:	70a2                	ld	ra,40(sp)
    80001776:	7402                	ld	s0,32(sp)
    80001778:	64e2                	ld	s1,24(sp)
    8000177a:	6942                	ld	s2,16(sp)
    8000177c:	69a2                	ld	s3,8(sp)
    8000177e:	6145                	addi	sp,sp,48
    80001780:	8082                	ret

0000000080001782 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001782:	7139                	addi	sp,sp,-64
    80001784:	fc06                	sd	ra,56(sp)
    80001786:	f822                	sd	s0,48(sp)
    80001788:	f426                	sd	s1,40(sp)
    8000178a:	f04a                	sd	s2,32(sp)
    8000178c:	ec4e                	sd	s3,24(sp)
    8000178e:	e852                	sd	s4,16(sp)
    80001790:	e456                	sd	s5,8(sp)
    80001792:	0080                	addi	s0,sp,64
    80001794:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001796:	00006497          	auipc	s1,0x6
    8000179a:	5aa48493          	addi	s1,s1,1450 # 80007d40 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    8000179e:	4989                	li	s3,2
        p->state = RUNNABLE;
    800017a0:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    800017a2:	00018917          	auipc	s2,0x18
    800017a6:	19e90913          	addi	s2,s2,414 # 80019940 <tickslock>
    800017aa:	a801                	j	800017ba <wakeup+0x38>
      }
      release(&p->lock);
    800017ac:	8526                	mv	a0,s1
    800017ae:	00f040ef          	jal	80005fbc <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800017b2:	47048493          	addi	s1,s1,1136
    800017b6:	03248263          	beq	s1,s2,800017da <wakeup+0x58>
    if(p != myproc()){
    800017ba:	937ff0ef          	jal	800010f0 <myproc>
    800017be:	fe950ae3          	beq	a0,s1,800017b2 <wakeup+0x30>
      acquire(&p->lock);
    800017c2:	8526                	mv	a0,s1
    800017c4:	764040ef          	jal	80005f28 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800017c8:	4c9c                	lw	a5,24(s1)
    800017ca:	ff3791e3          	bne	a5,s3,800017ac <wakeup+0x2a>
    800017ce:	709c                	ld	a5,32(s1)
    800017d0:	fd479ee3          	bne	a5,s4,800017ac <wakeup+0x2a>
        p->state = RUNNABLE;
    800017d4:	0154ac23          	sw	s5,24(s1)
    800017d8:	bfd1                	j	800017ac <wakeup+0x2a>
    }
  }
}
    800017da:	70e2                	ld	ra,56(sp)
    800017dc:	7442                	ld	s0,48(sp)
    800017de:	74a2                	ld	s1,40(sp)
    800017e0:	7902                	ld	s2,32(sp)
    800017e2:	69e2                	ld	s3,24(sp)
    800017e4:	6a42                	ld	s4,16(sp)
    800017e6:	6aa2                	ld	s5,8(sp)
    800017e8:	6121                	addi	sp,sp,64
    800017ea:	8082                	ret

00000000800017ec <reparent>:
{
    800017ec:	7179                	addi	sp,sp,-48
    800017ee:	f406                	sd	ra,40(sp)
    800017f0:	f022                	sd	s0,32(sp)
    800017f2:	ec26                	sd	s1,24(sp)
    800017f4:	e84a                	sd	s2,16(sp)
    800017f6:	e44e                	sd	s3,8(sp)
    800017f8:	e052                	sd	s4,0(sp)
    800017fa:	1800                	addi	s0,sp,48
    800017fc:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800017fe:	00006497          	auipc	s1,0x6
    80001802:	54248493          	addi	s1,s1,1346 # 80007d40 <proc>
      pp->parent = initproc;
    80001806:	00006a17          	auipc	s4,0x6
    8000180a:	0caa0a13          	addi	s4,s4,202 # 800078d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    8000180e:	00018997          	auipc	s3,0x18
    80001812:	13298993          	addi	s3,s3,306 # 80019940 <tickslock>
    80001816:	a029                	j	80001820 <reparent+0x34>
    80001818:	47048493          	addi	s1,s1,1136
    8000181c:	01348b63          	beq	s1,s3,80001832 <reparent+0x46>
    if(pp->parent == p){
    80001820:	7c9c                	ld	a5,56(s1)
    80001822:	ff279be3          	bne	a5,s2,80001818 <reparent+0x2c>
      pp->parent = initproc;
    80001826:	000a3503          	ld	a0,0(s4)
    8000182a:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    8000182c:	f57ff0ef          	jal	80001782 <wakeup>
    80001830:	b7e5                	j	80001818 <reparent+0x2c>
}
    80001832:	70a2                	ld	ra,40(sp)
    80001834:	7402                	ld	s0,32(sp)
    80001836:	64e2                	ld	s1,24(sp)
    80001838:	6942                	ld	s2,16(sp)
    8000183a:	69a2                	ld	s3,8(sp)
    8000183c:	6a02                	ld	s4,0(sp)
    8000183e:	6145                	addi	sp,sp,48
    80001840:	8082                	ret

0000000080001842 <kexit>:
{
    80001842:	715d                	addi	sp,sp,-80
    80001844:	e486                	sd	ra,72(sp)
    80001846:	e0a2                	sd	s0,64(sp)
    80001848:	fc26                	sd	s1,56(sp)
    8000184a:	f84a                	sd	s2,48(sp)
    8000184c:	f44e                	sd	s3,40(sp)
    8000184e:	ec56                	sd	s5,24(sp)
    80001850:	0880                	addi	s0,sp,80
    80001852:	8aaa                	mv	s5,a0
  struct proc *p = myproc();
    80001854:	89dff0ef          	jal	800010f0 <myproc>
    80001858:	892a                	mv	s2,a0
  if(p == initproc)
    8000185a:	00006797          	auipc	a5,0x6
    8000185e:	0767b783          	ld	a5,118(a5) # 800078d0 <initproc>
    80001862:	0d050493          	addi	s1,a0,208
    80001866:	15050993          	addi	s3,a0,336
    8000186a:	00a78663          	beq	a5,a0,80001876 <kexit+0x34>
    8000186e:	f052                	sd	s4,32(sp)
    80001870:	e85a                	sd	s6,16(sp)
    80001872:	e45e                	sd	s7,8(sp)
    80001874:	a829                	j	8000188e <kexit+0x4c>
    80001876:	f052                	sd	s4,32(sp)
    80001878:	e85a                	sd	s6,16(sp)
    8000187a:	e45e                	sd	s7,8(sp)
    panic("init exiting");
    8000187c:	00006517          	auipc	a0,0x6
    80001880:	93c50513          	addi	a0,a0,-1732 # 800071b8 <etext+0x1b8>
    80001884:	3e2040ef          	jal	80005c66 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001888:	04a1                	addi	s1,s1,8
    8000188a:	01348963          	beq	s1,s3,8000189c <kexit+0x5a>
    if(p->ofile[fd]){
    8000188e:	6088                	ld	a0,0(s1)
    80001890:	dd65                	beqz	a0,80001888 <kexit+0x46>
      fileclose(f);
    80001892:	224020ef          	jal	80003ab6 <fileclose>
      p->ofile[fd] = 0;
    80001896:	0004b023          	sd	zero,0(s1)
    8000189a:	b7fd                	j	80001888 <kexit+0x46>
    8000189c:	17090493          	addi	s1,s2,368
    800018a0:	47090a13          	addi	s4,s2,1136
    if (uvmunmap_vma(p->pagetable, vma, vma->start, vma->end) == -1)
    800018a4:	5b7d                	li	s6,-1
      printf("kexit: failed to unmap vma");
    800018a6:	00006b97          	auipc	s7,0x6
    800018aa:	922b8b93          	addi	s7,s7,-1758 # 800071c8 <etext+0x1c8>
    800018ae:	a809                	j	800018c0 <kexit+0x7e>
    800018b0:	855e                	mv	a0,s7
    800018b2:	08a040ef          	jal	8000593c <printf>
    800018b6:	a00d                	j	800018d8 <kexit+0x96>
  for (uint i=0; i < NVMA; i++) {
    800018b8:	03048493          	addi	s1,s1,48
    800018bc:	03448963          	beq	s1,s4,800018ee <kexit+0xac>
    if (vma->valid == 0)
    800018c0:	89a6                	mv	s3,s1
    800018c2:	409c                	lw	a5,0(s1)
    800018c4:	dbf5                	beqz	a5,800018b8 <kexit+0x76>
    if (uvmunmap_vma(p->pagetable, vma, vma->start, vma->end) == -1)
    800018c6:	6894                	ld	a3,16(s1)
    800018c8:	6490                	ld	a2,8(s1)
    800018ca:	85a6                	mv	a1,s1
    800018cc:	05093503          	ld	a0,80(s2)
    800018d0:	c8eff0ef          	jal	80000d5e <uvmunmap_vma>
    800018d4:	fd650ee3          	beq	a0,s6,800018b0 <kexit+0x6e>
    if (vma->start == p->mmap_base) {
    800018d8:	0089b703          	ld	a4,8(s3)
    800018dc:	16893783          	ld	a5,360(s2)
    800018e0:	fcf71ce3          	bne	a4,a5,800018b8 <kexit+0x76>
      p->mmap_base = vma->end;
    800018e4:	0109b783          	ld	a5,16(s3)
    800018e8:	16f93423          	sd	a5,360(s2)
    800018ec:	b7f1                	j	800018b8 <kexit+0x76>
  begin_op();
    800018ee:	5a5010ef          	jal	80003692 <begin_op>
  iput(p->cwd);
    800018f2:	15093503          	ld	a0,336(s2)
    800018f6:	512010ef          	jal	80002e08 <iput>
  end_op();
    800018fa:	609010ef          	jal	80003702 <end_op>
  p->cwd = 0;
    800018fe:	14093823          	sd	zero,336(s2)
  acquire(&wait_lock);
    80001902:	00006517          	auipc	a0,0x6
    80001906:	02650513          	addi	a0,a0,38 # 80007928 <wait_lock>
    8000190a:	61e040ef          	jal	80005f28 <acquire>
  reparent(p);
    8000190e:	854a                	mv	a0,s2
    80001910:	eddff0ef          	jal	800017ec <reparent>
  wakeup(p->parent);
    80001914:	03893503          	ld	a0,56(s2)
    80001918:	e6bff0ef          	jal	80001782 <wakeup>
  acquire(&p->lock);
    8000191c:	854a                	mv	a0,s2
    8000191e:	60a040ef          	jal	80005f28 <acquire>
  p->xstate = status;
    80001922:	03592623          	sw	s5,44(s2)
  p->state = ZOMBIE;
    80001926:	4795                	li	a5,5
    80001928:	00f92c23          	sw	a5,24(s2)
  release(&wait_lock);
    8000192c:	00006517          	auipc	a0,0x6
    80001930:	ffc50513          	addi	a0,a0,-4 # 80007928 <wait_lock>
    80001934:	688040ef          	jal	80005fbc <release>
  sched();
    80001938:	d17ff0ef          	jal	8000164e <sched>
  panic("zombie exit");
    8000193c:	00006517          	auipc	a0,0x6
    80001940:	8ac50513          	addi	a0,a0,-1876 # 800071e8 <etext+0x1e8>
    80001944:	322040ef          	jal	80005c66 <panic>

0000000080001948 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001948:	7179                	addi	sp,sp,-48
    8000194a:	f406                	sd	ra,40(sp)
    8000194c:	f022                	sd	s0,32(sp)
    8000194e:	ec26                	sd	s1,24(sp)
    80001950:	e84a                	sd	s2,16(sp)
    80001952:	e44e                	sd	s3,8(sp)
    80001954:	1800                	addi	s0,sp,48
    80001956:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001958:	00006497          	auipc	s1,0x6
    8000195c:	3e848493          	addi	s1,s1,1000 # 80007d40 <proc>
    80001960:	00018997          	auipc	s3,0x18
    80001964:	fe098993          	addi	s3,s3,-32 # 80019940 <tickslock>
    acquire(&p->lock);
    80001968:	8526                	mv	a0,s1
    8000196a:	5be040ef          	jal	80005f28 <acquire>
    if(p->pid == pid){
    8000196e:	589c                	lw	a5,48(s1)
    80001970:	01278b63          	beq	a5,s2,80001986 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001974:	8526                	mv	a0,s1
    80001976:	646040ef          	jal	80005fbc <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000197a:	47048493          	addi	s1,s1,1136
    8000197e:	ff3495e3          	bne	s1,s3,80001968 <kkill+0x20>
  }
  return -1;
    80001982:	557d                	li	a0,-1
    80001984:	a819                	j	8000199a <kkill+0x52>
      p->killed = 1;
    80001986:	4785                	li	a5,1
    80001988:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000198a:	4c98                	lw	a4,24(s1)
    8000198c:	4789                	li	a5,2
    8000198e:	00f70d63          	beq	a4,a5,800019a8 <kkill+0x60>
      release(&p->lock);
    80001992:	8526                	mv	a0,s1
    80001994:	628040ef          	jal	80005fbc <release>
      return 0;
    80001998:	4501                	li	a0,0
}
    8000199a:	70a2                	ld	ra,40(sp)
    8000199c:	7402                	ld	s0,32(sp)
    8000199e:	64e2                	ld	s1,24(sp)
    800019a0:	6942                	ld	s2,16(sp)
    800019a2:	69a2                	ld	s3,8(sp)
    800019a4:	6145                	addi	sp,sp,48
    800019a6:	8082                	ret
        p->state = RUNNABLE;
    800019a8:	478d                	li	a5,3
    800019aa:	cc9c                	sw	a5,24(s1)
    800019ac:	b7dd                	j	80001992 <kkill+0x4a>

00000000800019ae <setkilled>:

void
setkilled(struct proc *p)
{
    800019ae:	1101                	addi	sp,sp,-32
    800019b0:	ec06                	sd	ra,24(sp)
    800019b2:	e822                	sd	s0,16(sp)
    800019b4:	e426                	sd	s1,8(sp)
    800019b6:	1000                	addi	s0,sp,32
    800019b8:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800019ba:	56e040ef          	jal	80005f28 <acquire>
  p->killed = 1;
    800019be:	4785                	li	a5,1
    800019c0:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800019c2:	8526                	mv	a0,s1
    800019c4:	5f8040ef          	jal	80005fbc <release>
}
    800019c8:	60e2                	ld	ra,24(sp)
    800019ca:	6442                	ld	s0,16(sp)
    800019cc:	64a2                	ld	s1,8(sp)
    800019ce:	6105                	addi	sp,sp,32
    800019d0:	8082                	ret

00000000800019d2 <killed>:

int
killed(struct proc *p)
{
    800019d2:	1101                	addi	sp,sp,-32
    800019d4:	ec06                	sd	ra,24(sp)
    800019d6:	e822                	sd	s0,16(sp)
    800019d8:	e426                	sd	s1,8(sp)
    800019da:	e04a                	sd	s2,0(sp)
    800019dc:	1000                	addi	s0,sp,32
    800019de:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800019e0:	548040ef          	jal	80005f28 <acquire>
  k = p->killed;
    800019e4:	549c                	lw	a5,40(s1)
    800019e6:	893e                	mv	s2,a5
  release(&p->lock);
    800019e8:	8526                	mv	a0,s1
    800019ea:	5d2040ef          	jal	80005fbc <release>
  return k;
}
    800019ee:	854a                	mv	a0,s2
    800019f0:	60e2                	ld	ra,24(sp)
    800019f2:	6442                	ld	s0,16(sp)
    800019f4:	64a2                	ld	s1,8(sp)
    800019f6:	6902                	ld	s2,0(sp)
    800019f8:	6105                	addi	sp,sp,32
    800019fa:	8082                	ret

00000000800019fc <kwait>:
{
    800019fc:	715d                	addi	sp,sp,-80
    800019fe:	e486                	sd	ra,72(sp)
    80001a00:	e0a2                	sd	s0,64(sp)
    80001a02:	fc26                	sd	s1,56(sp)
    80001a04:	f84a                	sd	s2,48(sp)
    80001a06:	f44e                	sd	s3,40(sp)
    80001a08:	f052                	sd	s4,32(sp)
    80001a0a:	ec56                	sd	s5,24(sp)
    80001a0c:	e85a                	sd	s6,16(sp)
    80001a0e:	e45e                	sd	s7,8(sp)
    80001a10:	0880                	addi	s0,sp,80
    80001a12:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001a14:	edcff0ef          	jal	800010f0 <myproc>
    80001a18:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001a1a:	00006517          	auipc	a0,0x6
    80001a1e:	f0e50513          	addi	a0,a0,-242 # 80007928 <wait_lock>
    80001a22:	506040ef          	jal	80005f28 <acquire>
        if(pp->state == ZOMBIE){
    80001a26:	4a15                	li	s4,5
        havekids = 1;
    80001a28:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a2a:	00018997          	auipc	s3,0x18
    80001a2e:	f1698993          	addi	s3,s3,-234 # 80019940 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001a32:	00006b17          	auipc	s6,0x6
    80001a36:	ef6b0b13          	addi	s6,s6,-266 # 80007928 <wait_lock>
    80001a3a:	a869                	j	80001ad4 <kwait+0xd8>
          pid = pp->pid;
    80001a3c:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001a40:	000b8c63          	beqz	s7,80001a58 <kwait+0x5c>
    80001a44:	4691                	li	a3,4
    80001a46:	02c48613          	addi	a2,s1,44
    80001a4a:	85de                	mv	a1,s7
    80001a4c:	05093503          	ld	a0,80(s2)
    80001a50:	9c2ff0ef          	jal	80000c12 <copyout>
    80001a54:	02054a63          	bltz	a0,80001a88 <kwait+0x8c>
          freeproc(pp);
    80001a58:	8526                	mv	a0,s1
    80001a5a:	86bff0ef          	jal	800012c4 <freeproc>
          release(&pp->lock);
    80001a5e:	8526                	mv	a0,s1
    80001a60:	55c040ef          	jal	80005fbc <release>
          release(&wait_lock);
    80001a64:	00006517          	auipc	a0,0x6
    80001a68:	ec450513          	addi	a0,a0,-316 # 80007928 <wait_lock>
    80001a6c:	550040ef          	jal	80005fbc <release>
}
    80001a70:	854e                	mv	a0,s3
    80001a72:	60a6                	ld	ra,72(sp)
    80001a74:	6406                	ld	s0,64(sp)
    80001a76:	74e2                	ld	s1,56(sp)
    80001a78:	7942                	ld	s2,48(sp)
    80001a7a:	79a2                	ld	s3,40(sp)
    80001a7c:	7a02                	ld	s4,32(sp)
    80001a7e:	6ae2                	ld	s5,24(sp)
    80001a80:	6b42                	ld	s6,16(sp)
    80001a82:	6ba2                	ld	s7,8(sp)
    80001a84:	6161                	addi	sp,sp,80
    80001a86:	8082                	ret
            release(&pp->lock);
    80001a88:	8526                	mv	a0,s1
    80001a8a:	532040ef          	jal	80005fbc <release>
            release(&wait_lock);
    80001a8e:	00006517          	auipc	a0,0x6
    80001a92:	e9a50513          	addi	a0,a0,-358 # 80007928 <wait_lock>
    80001a96:	526040ef          	jal	80005fbc <release>
            return -1;
    80001a9a:	59fd                	li	s3,-1
    80001a9c:	bfd1                	j	80001a70 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a9e:	47048493          	addi	s1,s1,1136
    80001aa2:	03348063          	beq	s1,s3,80001ac2 <kwait+0xc6>
      if(pp->parent == p){
    80001aa6:	7c9c                	ld	a5,56(s1)
    80001aa8:	ff279be3          	bne	a5,s2,80001a9e <kwait+0xa2>
        acquire(&pp->lock);
    80001aac:	8526                	mv	a0,s1
    80001aae:	47a040ef          	jal	80005f28 <acquire>
        if(pp->state == ZOMBIE){
    80001ab2:	4c9c                	lw	a5,24(s1)
    80001ab4:	f94784e3          	beq	a5,s4,80001a3c <kwait+0x40>
        release(&pp->lock);
    80001ab8:	8526                	mv	a0,s1
    80001aba:	502040ef          	jal	80005fbc <release>
        havekids = 1;
    80001abe:	8756                	mv	a4,s5
    80001ac0:	bff9                	j	80001a9e <kwait+0xa2>
    if(!havekids || killed(p)){
    80001ac2:	cf19                	beqz	a4,80001ae0 <kwait+0xe4>
    80001ac4:	854a                	mv	a0,s2
    80001ac6:	f0dff0ef          	jal	800019d2 <killed>
    80001aca:	e919                	bnez	a0,80001ae0 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001acc:	85da                	mv	a1,s6
    80001ace:	854a                	mv	a0,s2
    80001ad0:	c67ff0ef          	jal	80001736 <sleep>
    havekids = 0;
    80001ad4:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001ad6:	00006497          	auipc	s1,0x6
    80001ada:	26a48493          	addi	s1,s1,618 # 80007d40 <proc>
    80001ade:	b7e1                	j	80001aa6 <kwait+0xaa>
      release(&wait_lock);
    80001ae0:	00006517          	auipc	a0,0x6
    80001ae4:	e4850513          	addi	a0,a0,-440 # 80007928 <wait_lock>
    80001ae8:	4d4040ef          	jal	80005fbc <release>
      return -1;
    80001aec:	59fd                	li	s3,-1
    80001aee:	b749                	j	80001a70 <kwait+0x74>

0000000080001af0 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001af0:	7179                	addi	sp,sp,-48
    80001af2:	f406                	sd	ra,40(sp)
    80001af4:	f022                	sd	s0,32(sp)
    80001af6:	ec26                	sd	s1,24(sp)
    80001af8:	e84a                	sd	s2,16(sp)
    80001afa:	e44e                	sd	s3,8(sp)
    80001afc:	e052                	sd	s4,0(sp)
    80001afe:	1800                	addi	s0,sp,48
    80001b00:	84aa                	mv	s1,a0
    80001b02:	8a2e                	mv	s4,a1
    80001b04:	89b2                	mv	s3,a2
    80001b06:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001b08:	de8ff0ef          	jal	800010f0 <myproc>
  if(user_dst){
    80001b0c:	cc99                	beqz	s1,80001b2a <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001b0e:	86ca                	mv	a3,s2
    80001b10:	864e                	mv	a2,s3
    80001b12:	85d2                	mv	a1,s4
    80001b14:	6928                	ld	a0,80(a0)
    80001b16:	8fcff0ef          	jal	80000c12 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001b1a:	70a2                	ld	ra,40(sp)
    80001b1c:	7402                	ld	s0,32(sp)
    80001b1e:	64e2                	ld	s1,24(sp)
    80001b20:	6942                	ld	s2,16(sp)
    80001b22:	69a2                	ld	s3,8(sp)
    80001b24:	6a02                	ld	s4,0(sp)
    80001b26:	6145                	addi	sp,sp,48
    80001b28:	8082                	ret
    memmove((char *)dst, src, len);
    80001b2a:	0009061b          	sext.w	a2,s2
    80001b2e:	85ce                	mv	a1,s3
    80001b30:	8552                	mv	a0,s4
    80001b32:	e8cfe0ef          	jal	800001be <memmove>
    return 0;
    80001b36:	8526                	mv	a0,s1
    80001b38:	b7cd                	j	80001b1a <either_copyout+0x2a>

0000000080001b3a <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001b3a:	7179                	addi	sp,sp,-48
    80001b3c:	f406                	sd	ra,40(sp)
    80001b3e:	f022                	sd	s0,32(sp)
    80001b40:	ec26                	sd	s1,24(sp)
    80001b42:	e84a                	sd	s2,16(sp)
    80001b44:	e44e                	sd	s3,8(sp)
    80001b46:	e052                	sd	s4,0(sp)
    80001b48:	1800                	addi	s0,sp,48
    80001b4a:	8a2a                	mv	s4,a0
    80001b4c:	84ae                	mv	s1,a1
    80001b4e:	89b2                	mv	s3,a2
    80001b50:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001b52:	d9eff0ef          	jal	800010f0 <myproc>
  if(user_src){
    80001b56:	cc99                	beqz	s1,80001b74 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001b58:	86ca                	mv	a3,s2
    80001b5a:	864e                	mv	a2,s3
    80001b5c:	85d2                	mv	a1,s4
    80001b5e:	6928                	ld	a0,80(a0)
    80001b60:	970ff0ef          	jal	80000cd0 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001b64:	70a2                	ld	ra,40(sp)
    80001b66:	7402                	ld	s0,32(sp)
    80001b68:	64e2                	ld	s1,24(sp)
    80001b6a:	6942                	ld	s2,16(sp)
    80001b6c:	69a2                	ld	s3,8(sp)
    80001b6e:	6a02                	ld	s4,0(sp)
    80001b70:	6145                	addi	sp,sp,48
    80001b72:	8082                	ret
    memmove(dst, (char*)src, len);
    80001b74:	0009061b          	sext.w	a2,s2
    80001b78:	85ce                	mv	a1,s3
    80001b7a:	8552                	mv	a0,s4
    80001b7c:	e42fe0ef          	jal	800001be <memmove>
    return 0;
    80001b80:	8526                	mv	a0,s1
    80001b82:	b7cd                	j	80001b64 <either_copyin+0x2a>

0000000080001b84 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001b84:	715d                	addi	sp,sp,-80
    80001b86:	e486                	sd	ra,72(sp)
    80001b88:	e0a2                	sd	s0,64(sp)
    80001b8a:	fc26                	sd	s1,56(sp)
    80001b8c:	f84a                	sd	s2,48(sp)
    80001b8e:	f44e                	sd	s3,40(sp)
    80001b90:	f052                	sd	s4,32(sp)
    80001b92:	ec56                	sd	s5,24(sp)
    80001b94:	e85a                	sd	s6,16(sp)
    80001b96:	e45e                	sd	s7,8(sp)
    80001b98:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001b9a:	00005517          	auipc	a0,0x5
    80001b9e:	47e50513          	addi	a0,a0,1150 # 80007018 <etext+0x18>
    80001ba2:	59b030ef          	jal	8000593c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001ba6:	00006497          	auipc	s1,0x6
    80001baa:	2f248493          	addi	s1,s1,754 # 80007e98 <proc+0x158>
    80001bae:	00018917          	auipc	s2,0x18
    80001bb2:	eea90913          	addi	s2,s2,-278 # 80019a98 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bb6:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001bb8:	00005997          	auipc	s3,0x5
    80001bbc:	64098993          	addi	s3,s3,1600 # 800071f8 <etext+0x1f8>
    printf("%d %s %s", p->pid, state, p->name);
    80001bc0:	00005a97          	auipc	s5,0x5
    80001bc4:	640a8a93          	addi	s5,s5,1600 # 80007200 <etext+0x200>
    printf("\n");
    80001bc8:	00005a17          	auipc	s4,0x5
    80001bcc:	450a0a13          	addi	s4,s4,1104 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bd0:	00006b97          	auipc	s7,0x6
    80001bd4:	bb8b8b93          	addi	s7,s7,-1096 # 80007788 <states.0>
    80001bd8:	a829                	j	80001bf2 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001bda:	ed86a583          	lw	a1,-296(a3)
    80001bde:	8556                	mv	a0,s5
    80001be0:	55d030ef          	jal	8000593c <printf>
    printf("\n");
    80001be4:	8552                	mv	a0,s4
    80001be6:	557030ef          	jal	8000593c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001bea:	47048493          	addi	s1,s1,1136
    80001bee:	03248263          	beq	s1,s2,80001c12 <procdump+0x8e>
    if(p->state == UNUSED)
    80001bf2:	86a6                	mv	a3,s1
    80001bf4:	ec04a783          	lw	a5,-320(s1)
    80001bf8:	dbed                	beqz	a5,80001bea <procdump+0x66>
      state = "???";
    80001bfa:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001bfc:	fcfb6fe3          	bltu	s6,a5,80001bda <procdump+0x56>
    80001c00:	02079713          	slli	a4,a5,0x20
    80001c04:	01d75793          	srli	a5,a4,0x1d
    80001c08:	97de                	add	a5,a5,s7
    80001c0a:	6390                	ld	a2,0(a5)
    80001c0c:	f679                	bnez	a2,80001bda <procdump+0x56>
      state = "???";
    80001c0e:	864e                	mv	a2,s3
    80001c10:	b7e9                	j	80001bda <procdump+0x56>
  }
}
    80001c12:	60a6                	ld	ra,72(sp)
    80001c14:	6406                	ld	s0,64(sp)
    80001c16:	74e2                	ld	s1,56(sp)
    80001c18:	7942                	ld	s2,48(sp)
    80001c1a:	79a2                	ld	s3,40(sp)
    80001c1c:	7a02                	ld	s4,32(sp)
    80001c1e:	6ae2                	ld	s5,24(sp)
    80001c20:	6b42                	ld	s6,16(sp)
    80001c22:	6ba2                	ld	s7,8(sp)
    80001c24:	6161                	addi	sp,sp,80
    80001c26:	8082                	ret

0000000080001c28 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001c28:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001c2c:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001c30:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001c32:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001c34:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001c38:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001c3c:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001c40:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001c44:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001c48:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001c4c:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001c50:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001c54:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001c58:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001c5c:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001c60:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001c64:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001c66:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001c68:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001c6c:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001c70:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001c74:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001c78:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001c7c:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001c80:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001c84:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001c88:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001c8c:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001c90:	8082                	ret

0000000080001c92 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001c92:	1141                	addi	sp,sp,-16
    80001c94:	e406                	sd	ra,8(sp)
    80001c96:	e022                	sd	s0,0(sp)
    80001c98:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001c9a:	00005597          	auipc	a1,0x5
    80001c9e:	5a658593          	addi	a1,a1,1446 # 80007240 <etext+0x240>
    80001ca2:	00018517          	auipc	a0,0x18
    80001ca6:	c9e50513          	addi	a0,a0,-866 # 80019940 <tickslock>
    80001caa:	1f4040ef          	jal	80005e9e <initlock>
}
    80001cae:	60a2                	ld	ra,8(sp)
    80001cb0:	6402                	ld	s0,0(sp)
    80001cb2:	0141                	addi	sp,sp,16
    80001cb4:	8082                	ret

0000000080001cb6 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001cb6:	1141                	addi	sp,sp,-16
    80001cb8:	e406                	sd	ra,8(sp)
    80001cba:	e022                	sd	s0,0(sp)
    80001cbc:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cbe:	00003797          	auipc	a5,0x3
    80001cc2:	1b278793          	addi	a5,a5,434 # 80004e70 <kernelvec>
    80001cc6:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001cca:	60a2                	ld	ra,8(sp)
    80001ccc:	6402                	ld	s0,0(sp)
    80001cce:	0141                	addi	sp,sp,16
    80001cd0:	8082                	ret

0000000080001cd2 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80001cd2:	1141                	addi	sp,sp,-16
    80001cd4:	e406                	sd	ra,8(sp)
    80001cd6:	e022                	sd	s0,0(sp)
    80001cd8:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001cda:	c16ff0ef          	jal	800010f0 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cde:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001ce2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ce4:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001ce8:	04000737          	lui	a4,0x4000
    80001cec:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001cee:	0732                	slli	a4,a4,0xc
    80001cf0:	00004797          	auipc	a5,0x4
    80001cf4:	31078793          	addi	a5,a5,784 # 80006000 <_trampoline>
    80001cf8:	00004697          	auipc	a3,0x4
    80001cfc:	30868693          	addi	a3,a3,776 # 80006000 <_trampoline>
    80001d00:	8f95                	sub	a5,a5,a3
    80001d02:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001d04:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001d08:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001d0a:	18002773          	csrr	a4,satp
    80001d0e:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001d10:	6d38                	ld	a4,88(a0)
    80001d12:	613c                	ld	a5,64(a0)
    80001d14:	6685                	lui	a3,0x1
    80001d16:	97b6                	add	a5,a5,a3
    80001d18:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001d1a:	6d3c                	ld	a5,88(a0)
    80001d1c:	00000717          	auipc	a4,0x0
    80001d20:	0fc70713          	addi	a4,a4,252 # 80001e18 <usertrap>
    80001d24:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001d26:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001d28:	8712                	mv	a4,tp
    80001d2a:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d2c:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001d30:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001d34:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d38:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001d3c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001d3e:	6f9c                	ld	a5,24(a5)
    80001d40:	14179073          	csrw	sepc,a5
}
    80001d44:	60a2                	ld	ra,8(sp)
    80001d46:	6402                	ld	s0,0(sp)
    80001d48:	0141                	addi	sp,sp,16
    80001d4a:	8082                	ret

0000000080001d4c <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001d4c:	1141                	addi	sp,sp,-16
    80001d4e:	e406                	sd	ra,8(sp)
    80001d50:	e022                	sd	s0,0(sp)
    80001d52:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001d54:	b68ff0ef          	jal	800010bc <cpuid>
    80001d58:	cd11                	beqz	a0,80001d74 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001d5a:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001d5e:	000f4737          	lui	a4,0xf4
    80001d62:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001d66:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001d68:	14d79073          	csrw	stimecmp,a5
}
    80001d6c:	60a2                	ld	ra,8(sp)
    80001d6e:	6402                	ld	s0,0(sp)
    80001d70:	0141                	addi	sp,sp,16
    80001d72:	8082                	ret
    acquire(&tickslock);
    80001d74:	00018517          	auipc	a0,0x18
    80001d78:	bcc50513          	addi	a0,a0,-1076 # 80019940 <tickslock>
    80001d7c:	1ac040ef          	jal	80005f28 <acquire>
    ticks++;
    80001d80:	00006717          	auipc	a4,0x6
    80001d84:	b5870713          	addi	a4,a4,-1192 # 800078d8 <ticks>
    80001d88:	431c                	lw	a5,0(a4)
    80001d8a:	2785                	addiw	a5,a5,1
    80001d8c:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001d8e:	853a                	mv	a0,a4
    80001d90:	9f3ff0ef          	jal	80001782 <wakeup>
    release(&tickslock);
    80001d94:	00018517          	auipc	a0,0x18
    80001d98:	bac50513          	addi	a0,a0,-1108 # 80019940 <tickslock>
    80001d9c:	220040ef          	jal	80005fbc <release>
    80001da0:	bf6d                	j	80001d5a <clockintr+0xe>

0000000080001da2 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001da2:	1101                	addi	sp,sp,-32
    80001da4:	ec06                	sd	ra,24(sp)
    80001da6:	e822                	sd	s0,16(sp)
    80001da8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001daa:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001dae:	57fd                	li	a5,-1
    80001db0:	17fe                	slli	a5,a5,0x3f
    80001db2:	07a5                	addi	a5,a5,9
    80001db4:	00f70c63          	beq	a4,a5,80001dcc <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001db8:	57fd                	li	a5,-1
    80001dba:	17fe                	slli	a5,a5,0x3f
    80001dbc:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001dbe:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001dc0:	04f70863          	beq	a4,a5,80001e10 <devintr+0x6e>
  }
}
    80001dc4:	60e2                	ld	ra,24(sp)
    80001dc6:	6442                	ld	s0,16(sp)
    80001dc8:	6105                	addi	sp,sp,32
    80001dca:	8082                	ret
    80001dcc:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001dce:	14e030ef          	jal	80004f1c <plic_claim>
    80001dd2:	872a                	mv	a4,a0
    80001dd4:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001dd6:	47a9                	li	a5,10
    80001dd8:	00f50963          	beq	a0,a5,80001dea <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80001ddc:	4785                	li	a5,1
    80001dde:	00f50963          	beq	a0,a5,80001df0 <devintr+0x4e>
    return 1;
    80001de2:	4505                	li	a0,1
    } else if(irq){
    80001de4:	eb09                	bnez	a4,80001df6 <devintr+0x54>
    80001de6:	64a2                	ld	s1,8(sp)
    80001de8:	bff1                	j	80001dc4 <devintr+0x22>
      uartintr();
    80001dea:	04c040ef          	jal	80005e36 <uartintr>
    if(irq)
    80001dee:	a819                	j	80001e04 <devintr+0x62>
      virtio_disk_intr();
    80001df0:	5c2030ef          	jal	800053b2 <virtio_disk_intr>
    if(irq)
    80001df4:	a801                	j	80001e04 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80001df6:	85ba                	mv	a1,a4
    80001df8:	00005517          	auipc	a0,0x5
    80001dfc:	45050513          	addi	a0,a0,1104 # 80007248 <etext+0x248>
    80001e00:	33d030ef          	jal	8000593c <printf>
      plic_complete(irq);
    80001e04:	8526                	mv	a0,s1
    80001e06:	136030ef          	jal	80004f3c <plic_complete>
    return 1;
    80001e0a:	4505                	li	a0,1
    80001e0c:	64a2                	ld	s1,8(sp)
    80001e0e:	bf5d                	j	80001dc4 <devintr+0x22>
    clockintr();
    80001e10:	f3dff0ef          	jal	80001d4c <clockintr>
    return 2;
    80001e14:	4509                	li	a0,2
    80001e16:	b77d                	j	80001dc4 <devintr+0x22>

0000000080001e18 <usertrap>:
{
    80001e18:	1101                	addi	sp,sp,-32
    80001e1a:	ec06                	sd	ra,24(sp)
    80001e1c:	e822                	sd	s0,16(sp)
    80001e1e:	e426                	sd	s1,8(sp)
    80001e20:	e04a                	sd	s2,0(sp)
    80001e22:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e24:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001e28:	1007f793          	andi	a5,a5,256
    80001e2c:	eba5                	bnez	a5,80001e9c <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001e2e:	00003797          	auipc	a5,0x3
    80001e32:	04278793          	addi	a5,a5,66 # 80004e70 <kernelvec>
    80001e36:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001e3a:	ab6ff0ef          	jal	800010f0 <myproc>
    80001e3e:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001e40:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e42:	14102773          	csrr	a4,sepc
    80001e46:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001e48:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001e4c:	47a1                	li	a5,8
    80001e4e:	04f70d63          	beq	a4,a5,80001ea8 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001e52:	f51ff0ef          	jal	80001da2 <devintr>
    80001e56:	892a                	mv	s2,a0
    80001e58:	e945                	bnez	a0,80001f08 <usertrap+0xf0>
    80001e5a:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001e5e:	47bd                	li	a5,15
    80001e60:	08f70863          	beq	a4,a5,80001ef0 <usertrap+0xd8>
    80001e64:	14202773          	csrr	a4,scause
    80001e68:	47b5                	li	a5,13
    80001e6a:	08f70363          	beq	a4,a5,80001ef0 <usertrap+0xd8>
    80001e6e:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001e72:	5890                	lw	a2,48(s1)
    80001e74:	00005517          	auipc	a0,0x5
    80001e78:	41450513          	addi	a0,a0,1044 # 80007288 <etext+0x288>
    80001e7c:	2c1030ef          	jal	8000593c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e80:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e84:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001e88:	00005517          	auipc	a0,0x5
    80001e8c:	43050513          	addi	a0,a0,1072 # 800072b8 <etext+0x2b8>
    80001e90:	2ad030ef          	jal	8000593c <printf>
    setkilled(p);
    80001e94:	8526                	mv	a0,s1
    80001e96:	b19ff0ef          	jal	800019ae <setkilled>
    80001e9a:	a035                	j	80001ec6 <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001e9c:	00005517          	auipc	a0,0x5
    80001ea0:	3cc50513          	addi	a0,a0,972 # 80007268 <etext+0x268>
    80001ea4:	5c3030ef          	jal	80005c66 <panic>
    if(killed(p))
    80001ea8:	b2bff0ef          	jal	800019d2 <killed>
    80001eac:	ed15                	bnez	a0,80001ee8 <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001eae:	6cb8                	ld	a4,88(s1)
    80001eb0:	6f1c                	ld	a5,24(a4)
    80001eb2:	0791                	addi	a5,a5,4
    80001eb4:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eb6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001eba:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ebe:	10079073          	csrw	sstatus,a5
    syscall();
    80001ec2:	240000ef          	jal	80002102 <syscall>
  if(killed(p))
    80001ec6:	8526                	mv	a0,s1
    80001ec8:	b0bff0ef          	jal	800019d2 <killed>
    80001ecc:	e139                	bnez	a0,80001f12 <usertrap+0xfa>
  prepare_return();
    80001ece:	e05ff0ef          	jal	80001cd2 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ed2:	68a8                	ld	a0,80(s1)
    80001ed4:	8131                	srli	a0,a0,0xc
    80001ed6:	57fd                	li	a5,-1
    80001ed8:	17fe                	slli	a5,a5,0x3f
    80001eda:	8d5d                	or	a0,a0,a5
}
    80001edc:	60e2                	ld	ra,24(sp)
    80001ede:	6442                	ld	s0,16(sp)
    80001ee0:	64a2                	ld	s1,8(sp)
    80001ee2:	6902                	ld	s2,0(sp)
    80001ee4:	6105                	addi	sp,sp,32
    80001ee6:	8082                	ret
      kexit(-1);
    80001ee8:	557d                	li	a0,-1
    80001eea:	959ff0ef          	jal	80001842 <kexit>
    80001eee:	b7c1                	j	80001eae <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001ef0:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef4:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001ef8:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001efa:	00163613          	seqz	a2,a2
    80001efe:	68a8                	ld	a0,80(s1)
    80001f00:	b37fe0ef          	jal	80000a36 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001f04:	f169                	bnez	a0,80001ec6 <usertrap+0xae>
    80001f06:	b7a5                	j	80001e6e <usertrap+0x56>
  if(killed(p))
    80001f08:	8526                	mv	a0,s1
    80001f0a:	ac9ff0ef          	jal	800019d2 <killed>
    80001f0e:	c511                	beqz	a0,80001f1a <usertrap+0x102>
    80001f10:	a011                	j	80001f14 <usertrap+0xfc>
    80001f12:	4901                	li	s2,0
    kexit(-1);
    80001f14:	557d                	li	a0,-1
    80001f16:	92dff0ef          	jal	80001842 <kexit>
  if(which_dev == 2)
    80001f1a:	4789                	li	a5,2
    80001f1c:	faf919e3          	bne	s2,a5,80001ece <usertrap+0xb6>
    yield();
    80001f20:	feaff0ef          	jal	8000170a <yield>
    80001f24:	b76d                	j	80001ece <usertrap+0xb6>

0000000080001f26 <kerneltrap>:
{
    80001f26:	7179                	addi	sp,sp,-48
    80001f28:	f406                	sd	ra,40(sp)
    80001f2a:	f022                	sd	s0,32(sp)
    80001f2c:	ec26                	sd	s1,24(sp)
    80001f2e:	e84a                	sd	s2,16(sp)
    80001f30:	e44e                	sd	s3,8(sp)
    80001f32:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f34:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f38:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f3c:	142027f3          	csrr	a5,scause
    80001f40:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001f42:	1004f793          	andi	a5,s1,256
    80001f46:	c795                	beqz	a5,80001f72 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f48:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f4c:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001f4e:	eb85                	bnez	a5,80001f7e <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001f50:	e53ff0ef          	jal	80001da2 <devintr>
    80001f54:	c91d                	beqz	a0,80001f8a <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001f56:	4789                	li	a5,2
    80001f58:	04f50a63          	beq	a0,a5,80001fac <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f5c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f60:	10049073          	csrw	sstatus,s1
}
    80001f64:	70a2                	ld	ra,40(sp)
    80001f66:	7402                	ld	s0,32(sp)
    80001f68:	64e2                	ld	s1,24(sp)
    80001f6a:	6942                	ld	s2,16(sp)
    80001f6c:	69a2                	ld	s3,8(sp)
    80001f6e:	6145                	addi	sp,sp,48
    80001f70:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001f72:	00005517          	auipc	a0,0x5
    80001f76:	36e50513          	addi	a0,a0,878 # 800072e0 <etext+0x2e0>
    80001f7a:	4ed030ef          	jal	80005c66 <panic>
    panic("kerneltrap: interrupts enabled");
    80001f7e:	00005517          	auipc	a0,0x5
    80001f82:	38a50513          	addi	a0,a0,906 # 80007308 <etext+0x308>
    80001f86:	4e1030ef          	jal	80005c66 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f8a:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f8e:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001f92:	85ce                	mv	a1,s3
    80001f94:	00005517          	auipc	a0,0x5
    80001f98:	39450513          	addi	a0,a0,916 # 80007328 <etext+0x328>
    80001f9c:	1a1030ef          	jal	8000593c <printf>
    panic("kerneltrap");
    80001fa0:	00005517          	auipc	a0,0x5
    80001fa4:	3b050513          	addi	a0,a0,944 # 80007350 <etext+0x350>
    80001fa8:	4bf030ef          	jal	80005c66 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001fac:	944ff0ef          	jal	800010f0 <myproc>
    80001fb0:	d555                	beqz	a0,80001f5c <kerneltrap+0x36>
    yield();
    80001fb2:	f58ff0ef          	jal	8000170a <yield>
    80001fb6:	b75d                	j	80001f5c <kerneltrap+0x36>

0000000080001fb8 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fb8:	1101                	addi	sp,sp,-32
    80001fba:	ec06                	sd	ra,24(sp)
    80001fbc:	e822                	sd	s0,16(sp)
    80001fbe:	e426                	sd	s1,8(sp)
    80001fc0:	1000                	addi	s0,sp,32
    80001fc2:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001fc4:	92cff0ef          	jal	800010f0 <myproc>
  switch (n) {
    80001fc8:	4795                	li	a5,5
    80001fca:	0497e163          	bltu	a5,s1,8000200c <argraw+0x54>
    80001fce:	048a                	slli	s1,s1,0x2
    80001fd0:	00005717          	auipc	a4,0x5
    80001fd4:	7e870713          	addi	a4,a4,2024 # 800077b8 <states.0+0x30>
    80001fd8:	94ba                	add	s1,s1,a4
    80001fda:	409c                	lw	a5,0(s1)
    80001fdc:	97ba                	add	a5,a5,a4
    80001fde:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001fe0:	6d3c                	ld	a5,88(a0)
    80001fe2:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001fe4:	60e2                	ld	ra,24(sp)
    80001fe6:	6442                	ld	s0,16(sp)
    80001fe8:	64a2                	ld	s1,8(sp)
    80001fea:	6105                	addi	sp,sp,32
    80001fec:	8082                	ret
    return p->trapframe->a1;
    80001fee:	6d3c                	ld	a5,88(a0)
    80001ff0:	7fa8                	ld	a0,120(a5)
    80001ff2:	bfcd                	j	80001fe4 <argraw+0x2c>
    return p->trapframe->a2;
    80001ff4:	6d3c                	ld	a5,88(a0)
    80001ff6:	63c8                	ld	a0,128(a5)
    80001ff8:	b7f5                	j	80001fe4 <argraw+0x2c>
    return p->trapframe->a3;
    80001ffa:	6d3c                	ld	a5,88(a0)
    80001ffc:	67c8                	ld	a0,136(a5)
    80001ffe:	b7dd                	j	80001fe4 <argraw+0x2c>
    return p->trapframe->a4;
    80002000:	6d3c                	ld	a5,88(a0)
    80002002:	6bc8                	ld	a0,144(a5)
    80002004:	b7c5                	j	80001fe4 <argraw+0x2c>
    return p->trapframe->a5;
    80002006:	6d3c                	ld	a5,88(a0)
    80002008:	6fc8                	ld	a0,152(a5)
    8000200a:	bfe9                	j	80001fe4 <argraw+0x2c>
  panic("argraw");
    8000200c:	00005517          	auipc	a0,0x5
    80002010:	35450513          	addi	a0,a0,852 # 80007360 <etext+0x360>
    80002014:	453030ef          	jal	80005c66 <panic>

0000000080002018 <fetchaddr>:
{
    80002018:	1101                	addi	sp,sp,-32
    8000201a:	ec06                	sd	ra,24(sp)
    8000201c:	e822                	sd	s0,16(sp)
    8000201e:	e426                	sd	s1,8(sp)
    80002020:	e04a                	sd	s2,0(sp)
    80002022:	1000                	addi	s0,sp,32
    80002024:	84aa                	mv	s1,a0
    80002026:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002028:	8c8ff0ef          	jal	800010f0 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000202c:	653c                	ld	a5,72(a0)
    8000202e:	02f4f663          	bgeu	s1,a5,8000205a <fetchaddr+0x42>
    80002032:	00848713          	addi	a4,s1,8
    80002036:	02e7e463          	bltu	a5,a4,8000205e <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000203a:	46a1                	li	a3,8
    8000203c:	8626                	mv	a2,s1
    8000203e:	85ca                	mv	a1,s2
    80002040:	6928                	ld	a0,80(a0)
    80002042:	c8ffe0ef          	jal	80000cd0 <copyin>
    80002046:	00a03533          	snez	a0,a0
    8000204a:	40a0053b          	negw	a0,a0
}
    8000204e:	60e2                	ld	ra,24(sp)
    80002050:	6442                	ld	s0,16(sp)
    80002052:	64a2                	ld	s1,8(sp)
    80002054:	6902                	ld	s2,0(sp)
    80002056:	6105                	addi	sp,sp,32
    80002058:	8082                	ret
    return -1;
    8000205a:	557d                	li	a0,-1
    8000205c:	bfcd                	j	8000204e <fetchaddr+0x36>
    8000205e:	557d                	li	a0,-1
    80002060:	b7fd                	j	8000204e <fetchaddr+0x36>

0000000080002062 <fetchstr>:
{
    80002062:	7179                	addi	sp,sp,-48
    80002064:	f406                	sd	ra,40(sp)
    80002066:	f022                	sd	s0,32(sp)
    80002068:	ec26                	sd	s1,24(sp)
    8000206a:	e84a                	sd	s2,16(sp)
    8000206c:	e44e                	sd	s3,8(sp)
    8000206e:	1800                	addi	s0,sp,48
    80002070:	89aa                	mv	s3,a0
    80002072:	84ae                	mv	s1,a1
    80002074:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002076:	87aff0ef          	jal	800010f0 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    8000207a:	86ca                	mv	a3,s2
    8000207c:	864e                	mv	a2,s3
    8000207e:	85a6                	mv	a1,s1
    80002080:	6928                	ld	a0,80(a0)
    80002082:	8ddfe0ef          	jal	8000095e <copyinstr>
    80002086:	00054c63          	bltz	a0,8000209e <fetchstr+0x3c>
  return strlen(buf);
    8000208a:	8526                	mv	a0,s1
    8000208c:	a5cfe0ef          	jal	800002e8 <strlen>
}
    80002090:	70a2                	ld	ra,40(sp)
    80002092:	7402                	ld	s0,32(sp)
    80002094:	64e2                	ld	s1,24(sp)
    80002096:	6942                	ld	s2,16(sp)
    80002098:	69a2                	ld	s3,8(sp)
    8000209a:	6145                	addi	sp,sp,48
    8000209c:	8082                	ret
    return -1;
    8000209e:	557d                	li	a0,-1
    800020a0:	bfc5                	j	80002090 <fetchstr+0x2e>

00000000800020a2 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800020a2:	1101                	addi	sp,sp,-32
    800020a4:	ec06                	sd	ra,24(sp)
    800020a6:	e822                	sd	s0,16(sp)
    800020a8:	e426                	sd	s1,8(sp)
    800020aa:	1000                	addi	s0,sp,32
    800020ac:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020ae:	f0bff0ef          	jal	80001fb8 <argraw>
    800020b2:	c088                	sw	a0,0(s1)
}
    800020b4:	60e2                	ld	ra,24(sp)
    800020b6:	6442                	ld	s0,16(sp)
    800020b8:	64a2                	ld	s1,8(sp)
    800020ba:	6105                	addi	sp,sp,32
    800020bc:	8082                	ret

00000000800020be <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800020be:	1101                	addi	sp,sp,-32
    800020c0:	ec06                	sd	ra,24(sp)
    800020c2:	e822                	sd	s0,16(sp)
    800020c4:	e426                	sd	s1,8(sp)
    800020c6:	1000                	addi	s0,sp,32
    800020c8:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800020ca:	eefff0ef          	jal	80001fb8 <argraw>
    800020ce:	e088                	sd	a0,0(s1)
}
    800020d0:	60e2                	ld	ra,24(sp)
    800020d2:	6442                	ld	s0,16(sp)
    800020d4:	64a2                	ld	s1,8(sp)
    800020d6:	6105                	addi	sp,sp,32
    800020d8:	8082                	ret

00000000800020da <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800020da:	1101                	addi	sp,sp,-32
    800020dc:	ec06                	sd	ra,24(sp)
    800020de:	e822                	sd	s0,16(sp)
    800020e0:	e426                	sd	s1,8(sp)
    800020e2:	e04a                	sd	s2,0(sp)
    800020e4:	1000                	addi	s0,sp,32
    800020e6:	892e                	mv	s2,a1
    800020e8:	84b2                	mv	s1,a2
  *ip = argraw(n);
    800020ea:	ecfff0ef          	jal	80001fb8 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    800020ee:	8626                	mv	a2,s1
    800020f0:	85ca                	mv	a1,s2
    800020f2:	f71ff0ef          	jal	80002062 <fetchstr>
}
    800020f6:	60e2                	ld	ra,24(sp)
    800020f8:	6442                	ld	s0,16(sp)
    800020fa:	64a2                	ld	s1,8(sp)
    800020fc:	6902                	ld	s2,0(sp)
    800020fe:	6105                	addi	sp,sp,32
    80002100:	8082                	ret

0000000080002102 <syscall>:
[SYS_munmap]    sys_munmap,
};

void
syscall(void)
{
    80002102:	1101                	addi	sp,sp,-32
    80002104:	ec06                	sd	ra,24(sp)
    80002106:	e822                	sd	s0,16(sp)
    80002108:	e426                	sd	s1,8(sp)
    8000210a:	e04a                	sd	s2,0(sp)
    8000210c:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000210e:	fe3fe0ef          	jal	800010f0 <myproc>
    80002112:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002114:	05853903          	ld	s2,88(a0)
    80002118:	0a893783          	ld	a5,168(s2)
    8000211c:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80002120:	37fd                	addiw	a5,a5,-1
    80002122:	4759                	li	a4,22
    80002124:	00f76f63          	bltu	a4,a5,80002142 <syscall+0x40>
    80002128:	00369713          	slli	a4,a3,0x3
    8000212c:	00005797          	auipc	a5,0x5
    80002130:	6a478793          	addi	a5,a5,1700 # 800077d0 <syscalls>
    80002134:	97ba                	add	a5,a5,a4
    80002136:	639c                	ld	a5,0(a5)
    80002138:	c789                	beqz	a5,80002142 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000213a:	9782                	jalr	a5
    8000213c:	06a93823          	sd	a0,112(s2)
    80002140:	a829                	j	8000215a <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002142:	15848613          	addi	a2,s1,344
    80002146:	588c                	lw	a1,48(s1)
    80002148:	00005517          	auipc	a0,0x5
    8000214c:	22050513          	addi	a0,a0,544 # 80007368 <etext+0x368>
    80002150:	7ec030ef          	jal	8000593c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002154:	6cbc                	ld	a5,88(s1)
    80002156:	577d                	li	a4,-1
    80002158:	fbb8                	sd	a4,112(a5)
  }
}
    8000215a:	60e2                	ld	ra,24(sp)
    8000215c:	6442                	ld	s0,16(sp)
    8000215e:	64a2                	ld	s1,8(sp)
    80002160:	6902                	ld	s2,0(sp)
    80002162:	6105                	addi	sp,sp,32
    80002164:	8082                	ret

0000000080002166 <sys_exit>:
#include "fcntl.h"


uint64
sys_exit(void)
{
    80002166:	1101                	addi	sp,sp,-32
    80002168:	ec06                	sd	ra,24(sp)
    8000216a:	e822                	sd	s0,16(sp)
    8000216c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000216e:	fec40593          	addi	a1,s0,-20
    80002172:	4501                	li	a0,0
    80002174:	f2fff0ef          	jal	800020a2 <argint>
  kexit(n);
    80002178:	fec42503          	lw	a0,-20(s0)
    8000217c:	ec6ff0ef          	jal	80001842 <kexit>
  return 0;  // not reached
}
    80002180:	4501                	li	a0,0
    80002182:	60e2                	ld	ra,24(sp)
    80002184:	6442                	ld	s0,16(sp)
    80002186:	6105                	addi	sp,sp,32
    80002188:	8082                	ret

000000008000218a <sys_getpid>:

uint64
sys_getpid(void)
{
    8000218a:	1141                	addi	sp,sp,-16
    8000218c:	e406                	sd	ra,8(sp)
    8000218e:	e022                	sd	s0,0(sp)
    80002190:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002192:	f5ffe0ef          	jal	800010f0 <myproc>
}
    80002196:	5908                	lw	a0,48(a0)
    80002198:	60a2                	ld	ra,8(sp)
    8000219a:	6402                	ld	s0,0(sp)
    8000219c:	0141                	addi	sp,sp,16
    8000219e:	8082                	ret

00000000800021a0 <sys_fork>:

uint64
sys_fork(void)
{
    800021a0:	1141                	addi	sp,sp,-16
    800021a2:	e406                	sd	ra,8(sp)
    800021a4:	e022                	sd	s0,0(sp)
    800021a6:	0800                	addi	s0,sp,16
  return kfork();
    800021a8:	aaaff0ef          	jal	80001452 <kfork>
}
    800021ac:	60a2                	ld	ra,8(sp)
    800021ae:	6402                	ld	s0,0(sp)
    800021b0:	0141                	addi	sp,sp,16
    800021b2:	8082                	ret

00000000800021b4 <sys_wait>:

uint64
sys_wait(void)
{
    800021b4:	1101                	addi	sp,sp,-32
    800021b6:	ec06                	sd	ra,24(sp)
    800021b8:	e822                	sd	s0,16(sp)
    800021ba:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021bc:	fe840593          	addi	a1,s0,-24
    800021c0:	4501                	li	a0,0
    800021c2:	efdff0ef          	jal	800020be <argaddr>
  return kwait(p);
    800021c6:	fe843503          	ld	a0,-24(s0)
    800021ca:	833ff0ef          	jal	800019fc <kwait>
}
    800021ce:	60e2                	ld	ra,24(sp)
    800021d0:	6442                	ld	s0,16(sp)
    800021d2:	6105                	addi	sp,sp,32
    800021d4:	8082                	ret

00000000800021d6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021d6:	7179                	addi	sp,sp,-48
    800021d8:	f406                	sd	ra,40(sp)
    800021da:	f022                	sd	s0,32(sp)
    800021dc:	ec26                	sd	s1,24(sp)
    800021de:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    800021e0:	fd840593          	addi	a1,s0,-40
    800021e4:	4501                	li	a0,0
    800021e6:	ebdff0ef          	jal	800020a2 <argint>
  argint(1, &t);
    800021ea:	fdc40593          	addi	a1,s0,-36
    800021ee:	4505                	li	a0,1
    800021f0:	eb3ff0ef          	jal	800020a2 <argint>
  addr = myproc()->sz;
    800021f4:	efdfe0ef          	jal	800010f0 <myproc>
    800021f8:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    800021fa:	fdc42703          	lw	a4,-36(s0)
    800021fe:	4785                	li	a5,1
    80002200:	02f70163          	beq	a4,a5,80002222 <sys_sbrk+0x4c>
    80002204:	fd842783          	lw	a5,-40(s0)
    80002208:	0007cd63          	bltz	a5,80002222 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    8000220c:	97a6                	add	a5,a5,s1
    8000220e:	0297e863          	bltu	a5,s1,8000223e <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80002212:	edffe0ef          	jal	800010f0 <myproc>
    80002216:	fd842703          	lw	a4,-40(s0)
    8000221a:	653c                	ld	a5,72(a0)
    8000221c:	97ba                	add	a5,a5,a4
    8000221e:	e53c                	sd	a5,72(a0)
    80002220:	a039                	j	8000222e <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80002222:	fd842503          	lw	a0,-40(s0)
    80002226:	9dcff0ef          	jal	80001402 <growproc>
    8000222a:	00054863          	bltz	a0,8000223a <sys_sbrk+0x64>
  }
  return addr;
}
    8000222e:	8526                	mv	a0,s1
    80002230:	70a2                	ld	ra,40(sp)
    80002232:	7402                	ld	s0,32(sp)
    80002234:	64e2                	ld	s1,24(sp)
    80002236:	6145                	addi	sp,sp,48
    80002238:	8082                	ret
      return -1;
    8000223a:	54fd                	li	s1,-1
    8000223c:	bfcd                	j	8000222e <sys_sbrk+0x58>
      return -1;
    8000223e:	54fd                	li	s1,-1
    80002240:	b7fd                	j	8000222e <sys_sbrk+0x58>

0000000080002242 <sys_pause>:

uint64
sys_pause(void)
{
    80002242:	7139                	addi	sp,sp,-64
    80002244:	fc06                	sd	ra,56(sp)
    80002246:	f822                	sd	s0,48(sp)
    80002248:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000224a:	fcc40593          	addi	a1,s0,-52
    8000224e:	4501                	li	a0,0
    80002250:	e53ff0ef          	jal	800020a2 <argint>
  if(n < 0)
    80002254:	fcc42783          	lw	a5,-52(s0)
    80002258:	0607c863          	bltz	a5,800022c8 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    8000225c:	00017517          	auipc	a0,0x17
    80002260:	6e450513          	addi	a0,a0,1764 # 80019940 <tickslock>
    80002264:	4c5030ef          	jal	80005f28 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002268:	fcc42783          	lw	a5,-52(s0)
    8000226c:	c3b9                	beqz	a5,800022b2 <sys_pause+0x70>
    8000226e:	f426                	sd	s1,40(sp)
    80002270:	f04a                	sd	s2,32(sp)
    80002272:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002274:	00005997          	auipc	s3,0x5
    80002278:	6649a983          	lw	s3,1636(s3) # 800078d8 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000227c:	00017917          	auipc	s2,0x17
    80002280:	6c490913          	addi	s2,s2,1732 # 80019940 <tickslock>
    80002284:	00005497          	auipc	s1,0x5
    80002288:	65448493          	addi	s1,s1,1620 # 800078d8 <ticks>
    if(killed(myproc())){
    8000228c:	e65fe0ef          	jal	800010f0 <myproc>
    80002290:	f42ff0ef          	jal	800019d2 <killed>
    80002294:	ed0d                	bnez	a0,800022ce <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80002296:	85ca                	mv	a1,s2
    80002298:	8526                	mv	a0,s1
    8000229a:	c9cff0ef          	jal	80001736 <sleep>
  while(ticks - ticks0 < n){
    8000229e:	409c                	lw	a5,0(s1)
    800022a0:	413787bb          	subw	a5,a5,s3
    800022a4:	fcc42703          	lw	a4,-52(s0)
    800022a8:	fee7e2e3          	bltu	a5,a4,8000228c <sys_pause+0x4a>
    800022ac:	74a2                	ld	s1,40(sp)
    800022ae:	7902                	ld	s2,32(sp)
    800022b0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800022b2:	00017517          	auipc	a0,0x17
    800022b6:	68e50513          	addi	a0,a0,1678 # 80019940 <tickslock>
    800022ba:	503030ef          	jal	80005fbc <release>
  return 0;
    800022be:	4501                	li	a0,0
}
    800022c0:	70e2                	ld	ra,56(sp)
    800022c2:	7442                	ld	s0,48(sp)
    800022c4:	6121                	addi	sp,sp,64
    800022c6:	8082                	ret
    n = 0;
    800022c8:	fc042623          	sw	zero,-52(s0)
    800022cc:	bf41                	j	8000225c <sys_pause+0x1a>
      release(&tickslock);
    800022ce:	00017517          	auipc	a0,0x17
    800022d2:	67250513          	addi	a0,a0,1650 # 80019940 <tickslock>
    800022d6:	4e7030ef          	jal	80005fbc <release>
      return -1;
    800022da:	557d                	li	a0,-1
    800022dc:	74a2                	ld	s1,40(sp)
    800022de:	7902                	ld	s2,32(sp)
    800022e0:	69e2                	ld	s3,24(sp)
    800022e2:	bff9                	j	800022c0 <sys_pause+0x7e>

00000000800022e4 <sys_kill>:

uint64
sys_kill(void)
{
    800022e4:	1101                	addi	sp,sp,-32
    800022e6:	ec06                	sd	ra,24(sp)
    800022e8:	e822                	sd	s0,16(sp)
    800022ea:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022ec:	fec40593          	addi	a1,s0,-20
    800022f0:	4501                	li	a0,0
    800022f2:	db1ff0ef          	jal	800020a2 <argint>
  return kkill(pid);
    800022f6:	fec42503          	lw	a0,-20(s0)
    800022fa:	e4eff0ef          	jal	80001948 <kkill>
}
    800022fe:	60e2                	ld	ra,24(sp)
    80002300:	6442                	ld	s0,16(sp)
    80002302:	6105                	addi	sp,sp,32
    80002304:	8082                	ret

0000000080002306 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002306:	1101                	addi	sp,sp,-32
    80002308:	ec06                	sd	ra,24(sp)
    8000230a:	e822                	sd	s0,16(sp)
    8000230c:	e426                	sd	s1,8(sp)
    8000230e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002310:	00017517          	auipc	a0,0x17
    80002314:	63050513          	addi	a0,a0,1584 # 80019940 <tickslock>
    80002318:	411030ef          	jal	80005f28 <acquire>
  xticks = ticks;
    8000231c:	00005797          	auipc	a5,0x5
    80002320:	5bc7a783          	lw	a5,1468(a5) # 800078d8 <ticks>
    80002324:	84be                	mv	s1,a5
  release(&tickslock);
    80002326:	00017517          	auipc	a0,0x17
    8000232a:	61a50513          	addi	a0,a0,1562 # 80019940 <tickslock>
    8000232e:	48f030ef          	jal	80005fbc <release>
  return xticks;
}
    80002332:	02049513          	slli	a0,s1,0x20
    80002336:	9101                	srli	a0,a0,0x20
    80002338:	60e2                	ld	ra,24(sp)
    8000233a:	6442                	ld	s0,16(sp)
    8000233c:	64a2                	ld	s1,8(sp)
    8000233e:	6105                	addi	sp,sp,32
    80002340:	8082                	ret

0000000080002342 <sys_mmap>:

uint64
sys_mmap(void)
{
    80002342:	711d                	addi	sp,sp,-96
    80002344:	ec86                	sd	ra,88(sp)
    80002346:	e8a2                	sd	s0,80(sp)
    80002348:	e0ca                	sd	s2,64(sp)
    8000234a:	1080                	addi	s0,sp,96
  uint64 addr;
  int len, prot, flags, fd, offset;

  argaddr(0, &addr);
    8000234c:	fb840593          	addi	a1,s0,-72
    80002350:	4501                	li	a0,0
    80002352:	d6dff0ef          	jal	800020be <argaddr>
  argint(1, &len);
    80002356:	fb440593          	addi	a1,s0,-76
    8000235a:	4505                	li	a0,1
    8000235c:	d47ff0ef          	jal	800020a2 <argint>
  argint(2, &prot);
    80002360:	fb040593          	addi	a1,s0,-80
    80002364:	4509                	li	a0,2
    80002366:	d3dff0ef          	jal	800020a2 <argint>
  argint(3, &flags);
    8000236a:	fac40593          	addi	a1,s0,-84
    8000236e:	450d                	li	a0,3
    80002370:	d33ff0ef          	jal	800020a2 <argint>
  argint(4, &fd);
    80002374:	fa840593          	addi	a1,s0,-88
    80002378:	4511                	li	a0,4
    8000237a:	d29ff0ef          	jal	800020a2 <argint>
  argint(5, &offset);
    8000237e:	fa440593          	addi	a1,s0,-92
    80002382:	4515                	li	a0,5
    80002384:	d1fff0ef          	jal	800020a2 <argint>

  if (len == 0)
    80002388:	fb442783          	lw	a5,-76(s0)
    return -1;
    8000238c:	597d                	li	s2,-1
  if (len == 0)
    8000238e:	0e078c63          	beqz	a5,80002486 <sys_mmap+0x144>

  if (addr != 0) {
    80002392:	fb843783          	ld	a5,-72(s0)
    80002396:	e7d1                	bnez	a5,80002422 <sys_mmap+0xe0>
    80002398:	e4a6                	sd	s1,72(sp)
    8000239a:	fc4e                	sd	s3,56(sp)
    printf("mmap: only support addr = 0");
    return -1;
  }

  struct proc *p = myproc();
    8000239c:	d55fe0ef          	jal	800010f0 <myproc>
    800023a0:	89aa                	mv	s3,a0

  if (((prot & PROT_READ) > 0) & !p->ofile[fd]->readable) {
    800023a2:	fb042483          	lw	s1,-80(s0)
    800023a6:	fa842783          	lw	a5,-88(s0)
    800023aa:	078e                	slli	a5,a5,0x3
    800023ac:	0d078793          	addi	a5,a5,208
    800023b0:	97aa                	add	a5,a5,a0
    800023b2:	6388                	ld	a0,0(a5)
    800023b4:	0014f793          	andi	a5,s1,1
    800023b8:	c789                	beqz	a5,800023c2 <sys_mmap+0x80>
    800023ba:	00854783          	lbu	a5,8(a0)
    // printf("mmap: target file is not readable\n");
    return -1;
    800023be:	597d                	li	s2,-1
  if (((prot & PROT_READ) > 0) & !p->ofile[fd]->readable) {
    800023c0:	cbe9                	beqz	a5,80002492 <sys_mmap+0x150>
  }
  if (((prot & PROT_WRITE) > 0) & !p->ofile[fd]->writable & (flags & MAP_SHARED)) {
    800023c2:	8085                	srli	s1,s1,0x1
    800023c4:	00954783          	lbu	a5,9(a0)
    800023c8:	0017b793          	seqz	a5,a5
    800023cc:	fac42703          	lw	a4,-84(s0)
    800023d0:	8cfd                	and	s1,s1,a5
    800023d2:	8cf9                	and	s1,s1,a4
    // printf("mmap: target file is not writable\n");
    return -1;
    800023d4:	597d                	li	s2,-1
  if (((prot & PROT_WRITE) > 0) & !p->ofile[fd]->writable & (flags & MAP_SHARED)) {
    800023d6:	e0e9                	bnez	s1,80002498 <sys_mmap+0x156>
  }

  // Allocate new virtual pages 
  uint64 size = PGROUNDUP(len);
    800023d8:	fb442783          	lw	a5,-76(s0)
    800023dc:	6685                	lui	a3,0x1
    800023de:	36fd                	addiw	a3,a3,-1 # fff <_entry-0x7ffff001>
    800023e0:	9ebd                	addw	a3,a3,a5
    800023e2:	77fd                	lui	a5,0xfffff
    800023e4:	8efd                	and	a3,a3,a5
  uint64 start = PGROUNDDOWN(p->mmap_base - size);
    800023e6:	1689b903          	ld	s2,360(s3)
    800023ea:	40d90933          	sub	s2,s2,a3
    800023ee:	00f97933          	and	s2,s2,a5

  // Check if address overlap with other memory regions
  if (start < p->sz || start >= TRAPFRAME) {
    800023f2:	0489b783          	ld	a5,72(s3)
    800023f6:	02f96d63          	bltu	s2,a5,80002430 <sys_mmap+0xee>
    800023fa:	fdfff7b7          	lui	a5,0xfdfff
    800023fe:	07ba                	slli	a5,a5,0xe
    80002400:	83e9                	srli	a5,a5,0x1a
    80002402:	0327e763          	bltu	a5,s2,80002430 <sys_mmap+0xee>
    80002406:	17098793          	addi	a5,s3,368
    return -1;
  }

  // Find free vma
  int i = 0;
  for (; i < NVMA; i++) {
    8000240a:	4641                	li	a2,16
    if (p->vma[i].valid == 0)
    8000240c:	4398                	lw	a4,0(a5)
    8000240e:	c70d                	beqz	a4,80002438 <sys_mmap+0xf6>
  for (; i < NVMA; i++) {
    80002410:	2485                	addiw	s1,s1,1
    80002412:	03078793          	addi	a5,a5,48 # fffffffffdfff030 <end+0xffffffff7dfd2238>
    80002416:	fec49be3          	bne	s1,a2,8000240c <sys_mmap+0xca>
      break;
  }
  if (i == NVMA) {
    return -1;
    8000241a:	597d                	li	s2,-1
    8000241c:	64a6                	ld	s1,72(sp)
    8000241e:	79e2                	ld	s3,56(sp)
    80002420:	a09d                	j	80002486 <sys_mmap+0x144>
    printf("mmap: only support addr = 0");
    80002422:	00005517          	auipc	a0,0x5
    80002426:	f6650513          	addi	a0,a0,-154 # 80007388 <etext+0x388>
    8000242a:	512030ef          	jal	8000593c <printf>
    return -1;
    8000242e:	a8a1                	j	80002486 <sys_mmap+0x144>
    return -1;
    80002430:	597d                	li	s2,-1
    80002432:	64a6                	ld	s1,72(sp)
    80002434:	79e2                	ld	s3,56(sp)
    80002436:	a881                	j	80002486 <sys_mmap+0x144>
    80002438:	f852                	sd	s4,48(sp)
    8000243a:	f456                	sd	s5,40(sp)
  }

  // Set and use the free VMA slot
  p->vma[i].start  = start;
    8000243c:	00149a93          	slli	s5,s1,0x1
    80002440:	009a87b3          	add	a5,s5,s1
    80002444:	0792                	slli	a5,a5,0x4
    80002446:	00f98a33          	add	s4,s3,a5
    8000244a:	172a3c23          	sd	s2,376(s4)
  p->vma[i].end    = start + size;
    8000244e:	96ca                	add	a3,a3,s2
    80002450:	18da3023          	sd	a3,384(s4)
  p->vma[i].f   = filedup(p->ofile[fd]);
    80002454:	61c010ef          	jal	80003a70 <filedup>
    80002458:	18aa3823          	sd	a0,400(s4)
  p->vma[i].offset = offset;
    8000245c:	fa442783          	lw	a5,-92(s0)
    80002460:	18fa2c23          	sw	a5,408(s4)
  p->vma[i].prot   = prot;
    80002464:	fb042783          	lw	a5,-80(s0)
    80002468:	18fa2423          	sw	a5,392(s4)
  p->vma[i].flags  = flags;
    8000246c:	fac42783          	lw	a5,-84(s0)
    80002470:	18fa2623          	sw	a5,396(s4)
  p->vma[i].valid  = 1;
    80002474:	4705                	li	a4,1
    80002476:	16ea2823          	sw	a4,368(s4)

  // Move the mmap top downward for the next mapping
  p->mmap_base = start;
    8000247a:	1729b423          	sd	s2,360(s3)
    8000247e:	64a6                	ld	s1,72(sp)
    80002480:	79e2                	ld	s3,56(sp)
    80002482:	7a42                	ld	s4,48(sp)
    80002484:	7aa2                	ld	s5,40(sp)

  return start;
}
    80002486:	854a                	mv	a0,s2
    80002488:	60e6                	ld	ra,88(sp)
    8000248a:	6446                	ld	s0,80(sp)
    8000248c:	6906                	ld	s2,64(sp)
    8000248e:	6125                	addi	sp,sp,96
    80002490:	8082                	ret
    80002492:	64a6                	ld	s1,72(sp)
    80002494:	79e2                	ld	s3,56(sp)
    80002496:	bfc5                	j	80002486 <sys_mmap+0x144>
    80002498:	64a6                	ld	s1,72(sp)
    8000249a:	79e2                	ld	s3,56(sp)
    8000249c:	b7ed                	j	80002486 <sys_mmap+0x144>

000000008000249e <sys_munmap>:

// Assumption: either unmap at the start, or at the end, or the whole region 
// (but not punch a hole in the middle of a region)
uint64
sys_munmap(void)
{
    8000249e:	7139                	addi	sp,sp,-64
    800024a0:	fc06                	sd	ra,56(sp)
    800024a2:	f822                	sd	s0,48(sp)
    800024a4:	f426                	sd	s1,40(sp)
    800024a6:	0080                	addi	s0,sp,64
  uint64 addr, end;
  int len;

  argaddr(0, &addr);
    800024a8:	fc840593          	addi	a1,s0,-56
    800024ac:	4501                	li	a0,0
    800024ae:	c11ff0ef          	jal	800020be <argaddr>
  argint(1, &len);
    800024b2:	fc440593          	addi	a1,s0,-60
    800024b6:	4505                	li	a0,1
    800024b8:	bebff0ef          	jal	800020a2 <argint>

  if (addr == 0 || len == 0 || (addr % PGSIZE) != 0)
    800024bc:	fc843783          	ld	a5,-56(s0)
    return -1;
    800024c0:	54fd                	li	s1,-1
  if (addr == 0 || len == 0 || (addr % PGSIZE) != 0)
    800024c2:	c3d1                	beqz	a5,80002546 <sys_munmap+0xa8>
    800024c4:	fc442703          	lw	a4,-60(s0)
    800024c8:	cf3d                	beqz	a4,80002546 <sys_munmap+0xa8>
    800024ca:	03479693          	slli	a3,a5,0x34
    800024ce:	0346d493          	srli	s1,a3,0x34
    800024d2:	e6c9                	bnez	a3,8000255c <sys_munmap+0xbe>
    800024d4:	f04a                	sd	s2,32(sp)
    800024d6:	ec4e                	sd	s3,24(sp)

  end = PGROUNDUP(addr + len);
    800024d8:	6685                	lui	a3,0x1
    800024da:	16fd                	addi	a3,a3,-1 # fff <_entry-0x7ffff001>
    800024dc:	97b6                	add	a5,a5,a3
    800024de:	97ba                	add	a5,a5,a4
    800024e0:	777d                	lui	a4,0xfffff
    800024e2:	8ff9                	and	a5,a5,a4
    800024e4:	89be                	mv	s3,a5

  struct proc *p = myproc();
    800024e6:	c0bfe0ef          	jal	800010f0 <myproc>
    800024ea:	892a                	mv	s2,a0

  for (uint i=0; i < NVMA; i++) {
    struct VMA *vma = &p->vma[i];

    if (vma->valid == 0 || vma->end <= addr || vma->start >= end)
    800024ec:	fc843603          	ld	a2,-56(s0)
    800024f0:	17050793          	addi	a5,a0,368
  for (uint i=0; i < NVMA; i++) {
    800024f4:	4701                	li	a4,0
    800024f6:	45c1                	li	a1,16
    800024f8:	a031                	j	80002504 <sys_munmap+0x66>
    800024fa:	2705                	addiw	a4,a4,1 # fffffffffffff001 <end+0xffffffff7ffd2209>
    800024fc:	03078793          	addi	a5,a5,48
    80002500:	02b70b63          	beq	a4,a1,80002536 <sys_munmap+0x98>
    if (vma->valid == 0 || vma->end <= addr || vma->start >= end)
    80002504:	4394                	lw	a3,0(a5)
    80002506:	daf5                	beqz	a3,800024fa <sys_munmap+0x5c>
    80002508:	6b94                	ld	a3,16(a5)
    8000250a:	fed678e3          	bgeu	a2,a3,800024fa <sys_munmap+0x5c>
    8000250e:	6794                	ld	a3,8(a5)
    80002510:	ff36f5e3          	bgeu	a3,s3,800024fa <sys_munmap+0x5c>
    struct VMA *vma = &p->vma[i];
    80002514:	1702                	slli	a4,a4,0x20
    80002516:	9301                	srli	a4,a4,0x20
    80002518:	00171593          	slli	a1,a4,0x1
    8000251c:	95ba                	add	a1,a1,a4
    8000251e:	0592                	slli	a1,a1,0x4
    80002520:	17058593          	addi	a1,a1,368
      continue;

    if (uvmunmap_vma(p->pagetable, vma, addr, end) == -1)
    80002524:	86ce                	mv	a3,s3
    80002526:	95ca                	add	a1,a1,s2
    80002528:	05093503          	ld	a0,80(s2)
    8000252c:	833fe0ef          	jal	80000d5e <uvmunmap_vma>
    80002530:	57fd                	li	a5,-1
    80002532:	02f50763          	beq	a0,a5,80002560 <sys_munmap+0xc2>
      return -1;
    break;
  }

  if (addr == p->mmap_base) {
    80002536:	16893703          	ld	a4,360(s2)
    8000253a:	fc843783          	ld	a5,-56(s0)
    8000253e:	00f70a63          	beq	a4,a5,80002552 <sys_munmap+0xb4>
    80002542:	7902                	ld	s2,32(sp)
    80002544:	69e2                	ld	s3,24(sp)
    p->mmap_base = end;
  }

  return 0;
}
    80002546:	8526                	mv	a0,s1
    80002548:	70e2                	ld	ra,56(sp)
    8000254a:	7442                	ld	s0,48(sp)
    8000254c:	74a2                	ld	s1,40(sp)
    8000254e:	6121                	addi	sp,sp,64
    80002550:	8082                	ret
    p->mmap_base = end;
    80002552:	17393423          	sd	s3,360(s2)
    80002556:	7902                	ld	s2,32(sp)
    80002558:	69e2                	ld	s3,24(sp)
    8000255a:	b7f5                	j	80002546 <sys_munmap+0xa8>
    return -1;
    8000255c:	54fd                	li	s1,-1
    8000255e:	b7e5                	j	80002546 <sys_munmap+0xa8>
      return -1;
    80002560:	54fd                	li	s1,-1
    80002562:	7902                	ld	s2,32(sp)
    80002564:	69e2                	ld	s3,24(sp)
    80002566:	b7c5                	j	80002546 <sys_munmap+0xa8>

0000000080002568 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002568:	7179                	addi	sp,sp,-48
    8000256a:	f406                	sd	ra,40(sp)
    8000256c:	f022                	sd	s0,32(sp)
    8000256e:	ec26                	sd	s1,24(sp)
    80002570:	e84a                	sd	s2,16(sp)
    80002572:	e44e                	sd	s3,8(sp)
    80002574:	e052                	sd	s4,0(sp)
    80002576:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002578:	00005597          	auipc	a1,0x5
    8000257c:	e3058593          	addi	a1,a1,-464 # 800073a8 <etext+0x3a8>
    80002580:	00017517          	auipc	a0,0x17
    80002584:	3d850513          	addi	a0,a0,984 # 80019958 <bcache>
    80002588:	117030ef          	jal	80005e9e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000258c:	0001f797          	auipc	a5,0x1f
    80002590:	3cc78793          	addi	a5,a5,972 # 80021958 <bcache+0x8000>
    80002594:	0001f717          	auipc	a4,0x1f
    80002598:	62c70713          	addi	a4,a4,1580 # 80021bc0 <bcache+0x8268>
    8000259c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025a0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025a4:	00017497          	auipc	s1,0x17
    800025a8:	3cc48493          	addi	s1,s1,972 # 80019970 <bcache+0x18>
    b->next = bcache.head.next;
    800025ac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025ae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025b0:	00005a17          	auipc	s4,0x5
    800025b4:	e00a0a13          	addi	s4,s4,-512 # 800073b0 <etext+0x3b0>
    b->next = bcache.head.next;
    800025b8:	2b893783          	ld	a5,696(s2)
    800025bc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800025be:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800025c2:	85d2                	mv	a1,s4
    800025c4:	01048513          	addi	a0,s1,16
    800025c8:	328010ef          	jal	800038f0 <initsleeplock>
    bcache.head.next->prev = b;
    800025cc:	2b893783          	ld	a5,696(s2)
    800025d0:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800025d2:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025d6:	45848493          	addi	s1,s1,1112
    800025da:	fd349fe3          	bne	s1,s3,800025b8 <binit+0x50>
  }
}
    800025de:	70a2                	ld	ra,40(sp)
    800025e0:	7402                	ld	s0,32(sp)
    800025e2:	64e2                	ld	s1,24(sp)
    800025e4:	6942                	ld	s2,16(sp)
    800025e6:	69a2                	ld	s3,8(sp)
    800025e8:	6a02                	ld	s4,0(sp)
    800025ea:	6145                	addi	sp,sp,48
    800025ec:	8082                	ret

00000000800025ee <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800025ee:	7179                	addi	sp,sp,-48
    800025f0:	f406                	sd	ra,40(sp)
    800025f2:	f022                	sd	s0,32(sp)
    800025f4:	ec26                	sd	s1,24(sp)
    800025f6:	e84a                	sd	s2,16(sp)
    800025f8:	e44e                	sd	s3,8(sp)
    800025fa:	1800                	addi	s0,sp,48
    800025fc:	892a                	mv	s2,a0
    800025fe:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002600:	00017517          	auipc	a0,0x17
    80002604:	35850513          	addi	a0,a0,856 # 80019958 <bcache>
    80002608:	121030ef          	jal	80005f28 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000260c:	0001f497          	auipc	s1,0x1f
    80002610:	6044b483          	ld	s1,1540(s1) # 80021c10 <bcache+0x82b8>
    80002614:	0001f797          	auipc	a5,0x1f
    80002618:	5ac78793          	addi	a5,a5,1452 # 80021bc0 <bcache+0x8268>
    8000261c:	02f48b63          	beq	s1,a5,80002652 <bread+0x64>
    80002620:	873e                	mv	a4,a5
    80002622:	a021                	j	8000262a <bread+0x3c>
    80002624:	68a4                	ld	s1,80(s1)
    80002626:	02e48663          	beq	s1,a4,80002652 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    8000262a:	449c                	lw	a5,8(s1)
    8000262c:	ff279ce3          	bne	a5,s2,80002624 <bread+0x36>
    80002630:	44dc                	lw	a5,12(s1)
    80002632:	ff3799e3          	bne	a5,s3,80002624 <bread+0x36>
      b->refcnt++;
    80002636:	40bc                	lw	a5,64(s1)
    80002638:	2785                	addiw	a5,a5,1
    8000263a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000263c:	00017517          	auipc	a0,0x17
    80002640:	31c50513          	addi	a0,a0,796 # 80019958 <bcache>
    80002644:	179030ef          	jal	80005fbc <release>
      acquiresleep(&b->lock);
    80002648:	01048513          	addi	a0,s1,16
    8000264c:	2da010ef          	jal	80003926 <acquiresleep>
      return b;
    80002650:	a889                	j	800026a2 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002652:	0001f497          	auipc	s1,0x1f
    80002656:	5b64b483          	ld	s1,1462(s1) # 80021c08 <bcache+0x82b0>
    8000265a:	0001f797          	auipc	a5,0x1f
    8000265e:	56678793          	addi	a5,a5,1382 # 80021bc0 <bcache+0x8268>
    80002662:	00f48863          	beq	s1,a5,80002672 <bread+0x84>
    80002666:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002668:	40bc                	lw	a5,64(s1)
    8000266a:	cb91                	beqz	a5,8000267e <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000266c:	64a4                	ld	s1,72(s1)
    8000266e:	fee49de3          	bne	s1,a4,80002668 <bread+0x7a>
  panic("bget: no buffers");
    80002672:	00005517          	auipc	a0,0x5
    80002676:	d4650513          	addi	a0,a0,-698 # 800073b8 <etext+0x3b8>
    8000267a:	5ec030ef          	jal	80005c66 <panic>
      b->dev = dev;
    8000267e:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002682:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002686:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000268a:	4785                	li	a5,1
    8000268c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000268e:	00017517          	auipc	a0,0x17
    80002692:	2ca50513          	addi	a0,a0,714 # 80019958 <bcache>
    80002696:	127030ef          	jal	80005fbc <release>
      acquiresleep(&b->lock);
    8000269a:	01048513          	addi	a0,s1,16
    8000269e:	288010ef          	jal	80003926 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026a2:	409c                	lw	a5,0(s1)
    800026a4:	cb89                	beqz	a5,800026b6 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026a6:	8526                	mv	a0,s1
    800026a8:	70a2                	ld	ra,40(sp)
    800026aa:	7402                	ld	s0,32(sp)
    800026ac:	64e2                	ld	s1,24(sp)
    800026ae:	6942                	ld	s2,16(sp)
    800026b0:	69a2                	ld	s3,8(sp)
    800026b2:	6145                	addi	sp,sp,48
    800026b4:	8082                	ret
    virtio_disk_rw(b, 0);
    800026b6:	4581                	li	a1,0
    800026b8:	8526                	mv	a0,s1
    800026ba:	2e7020ef          	jal	800051a0 <virtio_disk_rw>
    b->valid = 1;
    800026be:	4785                	li	a5,1
    800026c0:	c09c                	sw	a5,0(s1)
  return b;
    800026c2:	b7d5                	j	800026a6 <bread+0xb8>

00000000800026c4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800026c4:	1101                	addi	sp,sp,-32
    800026c6:	ec06                	sd	ra,24(sp)
    800026c8:	e822                	sd	s0,16(sp)
    800026ca:	e426                	sd	s1,8(sp)
    800026cc:	1000                	addi	s0,sp,32
    800026ce:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800026d0:	0541                	addi	a0,a0,16
    800026d2:	2d2010ef          	jal	800039a4 <holdingsleep>
    800026d6:	c911                	beqz	a0,800026ea <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800026d8:	4585                	li	a1,1
    800026da:	8526                	mv	a0,s1
    800026dc:	2c5020ef          	jal	800051a0 <virtio_disk_rw>
}
    800026e0:	60e2                	ld	ra,24(sp)
    800026e2:	6442                	ld	s0,16(sp)
    800026e4:	64a2                	ld	s1,8(sp)
    800026e6:	6105                	addi	sp,sp,32
    800026e8:	8082                	ret
    panic("bwrite");
    800026ea:	00005517          	auipc	a0,0x5
    800026ee:	ce650513          	addi	a0,a0,-794 # 800073d0 <etext+0x3d0>
    800026f2:	574030ef          	jal	80005c66 <panic>

00000000800026f6 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800026f6:	1101                	addi	sp,sp,-32
    800026f8:	ec06                	sd	ra,24(sp)
    800026fa:	e822                	sd	s0,16(sp)
    800026fc:	e426                	sd	s1,8(sp)
    800026fe:	e04a                	sd	s2,0(sp)
    80002700:	1000                	addi	s0,sp,32
    80002702:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002704:	01050913          	addi	s2,a0,16
    80002708:	854a                	mv	a0,s2
    8000270a:	29a010ef          	jal	800039a4 <holdingsleep>
    8000270e:	c125                	beqz	a0,8000276e <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002710:	854a                	mv	a0,s2
    80002712:	25a010ef          	jal	8000396c <releasesleep>

  acquire(&bcache.lock);
    80002716:	00017517          	auipc	a0,0x17
    8000271a:	24250513          	addi	a0,a0,578 # 80019958 <bcache>
    8000271e:	00b030ef          	jal	80005f28 <acquire>
  b->refcnt--;
    80002722:	40bc                	lw	a5,64(s1)
    80002724:	37fd                	addiw	a5,a5,-1
    80002726:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002728:	e79d                	bnez	a5,80002756 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000272a:	68b8                	ld	a4,80(s1)
    8000272c:	64bc                	ld	a5,72(s1)
    8000272e:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002730:	68b8                	ld	a4,80(s1)
    80002732:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002734:	0001f797          	auipc	a5,0x1f
    80002738:	22478793          	addi	a5,a5,548 # 80021958 <bcache+0x8000>
    8000273c:	2b87b703          	ld	a4,696(a5)
    80002740:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002742:	0001f717          	auipc	a4,0x1f
    80002746:	47e70713          	addi	a4,a4,1150 # 80021bc0 <bcache+0x8268>
    8000274a:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000274c:	2b87b703          	ld	a4,696(a5)
    80002750:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002752:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002756:	00017517          	auipc	a0,0x17
    8000275a:	20250513          	addi	a0,a0,514 # 80019958 <bcache>
    8000275e:	05f030ef          	jal	80005fbc <release>
}
    80002762:	60e2                	ld	ra,24(sp)
    80002764:	6442                	ld	s0,16(sp)
    80002766:	64a2                	ld	s1,8(sp)
    80002768:	6902                	ld	s2,0(sp)
    8000276a:	6105                	addi	sp,sp,32
    8000276c:	8082                	ret
    panic("brelse");
    8000276e:	00005517          	auipc	a0,0x5
    80002772:	c6a50513          	addi	a0,a0,-918 # 800073d8 <etext+0x3d8>
    80002776:	4f0030ef          	jal	80005c66 <panic>

000000008000277a <bpin>:

void
bpin(struct buf *b) {
    8000277a:	1101                	addi	sp,sp,-32
    8000277c:	ec06                	sd	ra,24(sp)
    8000277e:	e822                	sd	s0,16(sp)
    80002780:	e426                	sd	s1,8(sp)
    80002782:	1000                	addi	s0,sp,32
    80002784:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002786:	00017517          	auipc	a0,0x17
    8000278a:	1d250513          	addi	a0,a0,466 # 80019958 <bcache>
    8000278e:	79a030ef          	jal	80005f28 <acquire>
  b->refcnt++;
    80002792:	40bc                	lw	a5,64(s1)
    80002794:	2785                	addiw	a5,a5,1
    80002796:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002798:	00017517          	auipc	a0,0x17
    8000279c:	1c050513          	addi	a0,a0,448 # 80019958 <bcache>
    800027a0:	01d030ef          	jal	80005fbc <release>
}
    800027a4:	60e2                	ld	ra,24(sp)
    800027a6:	6442                	ld	s0,16(sp)
    800027a8:	64a2                	ld	s1,8(sp)
    800027aa:	6105                	addi	sp,sp,32
    800027ac:	8082                	ret

00000000800027ae <bunpin>:

void
bunpin(struct buf *b) {
    800027ae:	1101                	addi	sp,sp,-32
    800027b0:	ec06                	sd	ra,24(sp)
    800027b2:	e822                	sd	s0,16(sp)
    800027b4:	e426                	sd	s1,8(sp)
    800027b6:	1000                	addi	s0,sp,32
    800027b8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027ba:	00017517          	auipc	a0,0x17
    800027be:	19e50513          	addi	a0,a0,414 # 80019958 <bcache>
    800027c2:	766030ef          	jal	80005f28 <acquire>
  b->refcnt--;
    800027c6:	40bc                	lw	a5,64(s1)
    800027c8:	37fd                	addiw	a5,a5,-1
    800027ca:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027cc:	00017517          	auipc	a0,0x17
    800027d0:	18c50513          	addi	a0,a0,396 # 80019958 <bcache>
    800027d4:	7e8030ef          	jal	80005fbc <release>
}
    800027d8:	60e2                	ld	ra,24(sp)
    800027da:	6442                	ld	s0,16(sp)
    800027dc:	64a2                	ld	s1,8(sp)
    800027de:	6105                	addi	sp,sp,32
    800027e0:	8082                	ret

00000000800027e2 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800027e2:	1101                	addi	sp,sp,-32
    800027e4:	ec06                	sd	ra,24(sp)
    800027e6:	e822                	sd	s0,16(sp)
    800027e8:	e426                	sd	s1,8(sp)
    800027ea:	e04a                	sd	s2,0(sp)
    800027ec:	1000                	addi	s0,sp,32
    800027ee:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800027f0:	00d5d79b          	srliw	a5,a1,0xd
    800027f4:	00020597          	auipc	a1,0x20
    800027f8:	8405a583          	lw	a1,-1984(a1) # 80022034 <sb+0x1c>
    800027fc:	9dbd                	addw	a1,a1,a5
    800027fe:	df1ff0ef          	jal	800025ee <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002802:	0074f713          	andi	a4,s1,7
    80002806:	4785                	li	a5,1
    80002808:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000280c:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000280e:	90d9                	srli	s1,s1,0x36
    80002810:	00950733          	add	a4,a0,s1
    80002814:	05874703          	lbu	a4,88(a4)
    80002818:	00e7f6b3          	and	a3,a5,a4
    8000281c:	c29d                	beqz	a3,80002842 <bfree+0x60>
    8000281e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    80002820:	94aa                	add	s1,s1,a0
    80002822:	fff7c793          	not	a5,a5
    80002826:	8f7d                	and	a4,a4,a5
    80002828:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    8000282c:	000010ef          	jal	8000382c <log_write>
  brelse(bp);
    80002830:	854a                	mv	a0,s2
    80002832:	ec5ff0ef          	jal	800026f6 <brelse>
}
    80002836:	60e2                	ld	ra,24(sp)
    80002838:	6442                	ld	s0,16(sp)
    8000283a:	64a2                	ld	s1,8(sp)
    8000283c:	6902                	ld	s2,0(sp)
    8000283e:	6105                	addi	sp,sp,32
    80002840:	8082                	ret
    panic("freeing free block");
    80002842:	00005517          	auipc	a0,0x5
    80002846:	b9e50513          	addi	a0,a0,-1122 # 800073e0 <etext+0x3e0>
    8000284a:	41c030ef          	jal	80005c66 <panic>

000000008000284e <balloc>:
{
    8000284e:	715d                	addi	sp,sp,-80
    80002850:	e486                	sd	ra,72(sp)
    80002852:	e0a2                	sd	s0,64(sp)
    80002854:	fc26                	sd	s1,56(sp)
    80002856:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    80002858:	0001f797          	auipc	a5,0x1f
    8000285c:	7c47a783          	lw	a5,1988(a5) # 8002201c <sb+0x4>
    80002860:	0e078263          	beqz	a5,80002944 <balloc+0xf6>
    80002864:	f84a                	sd	s2,48(sp)
    80002866:	f44e                	sd	s3,40(sp)
    80002868:	f052                	sd	s4,32(sp)
    8000286a:	ec56                	sd	s5,24(sp)
    8000286c:	e85a                	sd	s6,16(sp)
    8000286e:	e45e                	sd	s7,8(sp)
    80002870:	e062                	sd	s8,0(sp)
    80002872:	8baa                	mv	s7,a0
    80002874:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002876:	0001fb17          	auipc	s6,0x1f
    8000287a:	7a2b0b13          	addi	s6,s6,1954 # 80022018 <sb>
      m = 1 << (bi % 8);
    8000287e:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002880:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002882:	6c09                	lui	s8,0x2
    80002884:	a09d                	j	800028ea <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002886:	97ca                	add	a5,a5,s2
    80002888:	8e55                	or	a2,a2,a3
    8000288a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000288e:	854a                	mv	a0,s2
    80002890:	79d000ef          	jal	8000382c <log_write>
        brelse(bp);
    80002894:	854a                	mv	a0,s2
    80002896:	e61ff0ef          	jal	800026f6 <brelse>
  bp = bread(dev, bno);
    8000289a:	85a6                	mv	a1,s1
    8000289c:	855e                	mv	a0,s7
    8000289e:	d51ff0ef          	jal	800025ee <bread>
    800028a2:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028a4:	40000613          	li	a2,1024
    800028a8:	4581                	li	a1,0
    800028aa:	05850513          	addi	a0,a0,88
    800028ae:	8b1fd0ef          	jal	8000015e <memset>
  log_write(bp);
    800028b2:	854a                	mv	a0,s2
    800028b4:	779000ef          	jal	8000382c <log_write>
  brelse(bp);
    800028b8:	854a                	mv	a0,s2
    800028ba:	e3dff0ef          	jal	800026f6 <brelse>
}
    800028be:	7942                	ld	s2,48(sp)
    800028c0:	79a2                	ld	s3,40(sp)
    800028c2:	7a02                	ld	s4,32(sp)
    800028c4:	6ae2                	ld	s5,24(sp)
    800028c6:	6b42                	ld	s6,16(sp)
    800028c8:	6ba2                	ld	s7,8(sp)
    800028ca:	6c02                	ld	s8,0(sp)
}
    800028cc:	8526                	mv	a0,s1
    800028ce:	60a6                	ld	ra,72(sp)
    800028d0:	6406                	ld	s0,64(sp)
    800028d2:	74e2                	ld	s1,56(sp)
    800028d4:	6161                	addi	sp,sp,80
    800028d6:	8082                	ret
    brelse(bp);
    800028d8:	854a                	mv	a0,s2
    800028da:	e1dff0ef          	jal	800026f6 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800028de:	015c0abb          	addw	s5,s8,s5
    800028e2:	004b2783          	lw	a5,4(s6)
    800028e6:	04faf863          	bgeu	s5,a5,80002936 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800028ea:	40dad59b          	sraiw	a1,s5,0xd
    800028ee:	01cb2783          	lw	a5,28(s6)
    800028f2:	9dbd                	addw	a1,a1,a5
    800028f4:	855e                	mv	a0,s7
    800028f6:	cf9ff0ef          	jal	800025ee <bread>
    800028fa:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028fc:	004b2503          	lw	a0,4(s6)
    80002900:	84d6                	mv	s1,s5
    80002902:	4701                	li	a4,0
    80002904:	fca4fae3          	bgeu	s1,a0,800028d8 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002908:	00777693          	andi	a3,a4,7
    8000290c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002910:	41f7579b          	sraiw	a5,a4,0x1f
    80002914:	01d7d79b          	srliw	a5,a5,0x1d
    80002918:	9fb9                	addw	a5,a5,a4
    8000291a:	4037d79b          	sraiw	a5,a5,0x3
    8000291e:	00f90633          	add	a2,s2,a5
    80002922:	05864603          	lbu	a2,88(a2)
    80002926:	00c6f5b3          	and	a1,a3,a2
    8000292a:	ddb1                	beqz	a1,80002886 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000292c:	2705                	addiw	a4,a4,1
    8000292e:	2485                	addiw	s1,s1,1
    80002930:	fd471ae3          	bne	a4,s4,80002904 <balloc+0xb6>
    80002934:	b755                	j	800028d8 <balloc+0x8a>
    80002936:	7942                	ld	s2,48(sp)
    80002938:	79a2                	ld	s3,40(sp)
    8000293a:	7a02                	ld	s4,32(sp)
    8000293c:	6ae2                	ld	s5,24(sp)
    8000293e:	6b42                	ld	s6,16(sp)
    80002940:	6ba2                	ld	s7,8(sp)
    80002942:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002944:	00005517          	auipc	a0,0x5
    80002948:	ab450513          	addi	a0,a0,-1356 # 800073f8 <etext+0x3f8>
    8000294c:	7f1020ef          	jal	8000593c <printf>
  return 0;
    80002950:	4481                	li	s1,0
    80002952:	bfad                	j	800028cc <balloc+0x7e>

0000000080002954 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002954:	7179                	addi	sp,sp,-48
    80002956:	f406                	sd	ra,40(sp)
    80002958:	f022                	sd	s0,32(sp)
    8000295a:	ec26                	sd	s1,24(sp)
    8000295c:	e84a                	sd	s2,16(sp)
    8000295e:	e44e                	sd	s3,8(sp)
    80002960:	1800                	addi	s0,sp,48
    80002962:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002964:	47ad                	li	a5,11
    80002966:	02b7e363          	bltu	a5,a1,8000298c <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000296a:	02059793          	slli	a5,a1,0x20
    8000296e:	01e7d593          	srli	a1,a5,0x1e
    80002972:	00b509b3          	add	s3,a0,a1
    80002976:	0509a483          	lw	s1,80(s3)
    8000297a:	e0b5                	bnez	s1,800029de <bmap+0x8a>
      addr = balloc(ip->dev);
    8000297c:	4108                	lw	a0,0(a0)
    8000297e:	ed1ff0ef          	jal	8000284e <balloc>
    80002982:	84aa                	mv	s1,a0
      if(addr == 0)
    80002984:	cd29                	beqz	a0,800029de <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002986:	04a9a823          	sw	a0,80(s3)
    8000298a:	a891                	j	800029de <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000298c:	ff45879b          	addiw	a5,a1,-12
    80002990:	873e                	mv	a4,a5
    80002992:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80002994:	0ff00793          	li	a5,255
    80002998:	06e7e763          	bltu	a5,a4,80002a06 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000299c:	08052483          	lw	s1,128(a0)
    800029a0:	e891                	bnez	s1,800029b4 <bmap+0x60>
      addr = balloc(ip->dev);
    800029a2:	4108                	lw	a0,0(a0)
    800029a4:	eabff0ef          	jal	8000284e <balloc>
    800029a8:	84aa                	mv	s1,a0
      if(addr == 0)
    800029aa:	c915                	beqz	a0,800029de <bmap+0x8a>
    800029ac:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029ae:	08a92023          	sw	a0,128(s2)
    800029b2:	a011                	j	800029b6 <bmap+0x62>
    800029b4:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    800029b6:	85a6                	mv	a1,s1
    800029b8:	00092503          	lw	a0,0(s2)
    800029bc:	c33ff0ef          	jal	800025ee <bread>
    800029c0:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    800029c2:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    800029c6:	02099713          	slli	a4,s3,0x20
    800029ca:	01e75593          	srli	a1,a4,0x1e
    800029ce:	97ae                	add	a5,a5,a1
    800029d0:	89be                	mv	s3,a5
    800029d2:	4384                	lw	s1,0(a5)
    800029d4:	cc89                	beqz	s1,800029ee <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800029d6:	8552                	mv	a0,s4
    800029d8:	d1fff0ef          	jal	800026f6 <brelse>
    return addr;
    800029dc:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800029de:	8526                	mv	a0,s1
    800029e0:	70a2                	ld	ra,40(sp)
    800029e2:	7402                	ld	s0,32(sp)
    800029e4:	64e2                	ld	s1,24(sp)
    800029e6:	6942                	ld	s2,16(sp)
    800029e8:	69a2                	ld	s3,8(sp)
    800029ea:	6145                	addi	sp,sp,48
    800029ec:	8082                	ret
      addr = balloc(ip->dev);
    800029ee:	00092503          	lw	a0,0(s2)
    800029f2:	e5dff0ef          	jal	8000284e <balloc>
    800029f6:	84aa                	mv	s1,a0
      if(addr){
    800029f8:	dd79                	beqz	a0,800029d6 <bmap+0x82>
        a[bn] = addr;
    800029fa:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800029fe:	8552                	mv	a0,s4
    80002a00:	62d000ef          	jal	8000382c <log_write>
    80002a04:	bfc9                	j	800029d6 <bmap+0x82>
    80002a06:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002a08:	00005517          	auipc	a0,0x5
    80002a0c:	a0850513          	addi	a0,a0,-1528 # 80007410 <etext+0x410>
    80002a10:	256030ef          	jal	80005c66 <panic>

0000000080002a14 <iget>:
{
    80002a14:	7179                	addi	sp,sp,-48
    80002a16:	f406                	sd	ra,40(sp)
    80002a18:	f022                	sd	s0,32(sp)
    80002a1a:	ec26                	sd	s1,24(sp)
    80002a1c:	e84a                	sd	s2,16(sp)
    80002a1e:	e44e                	sd	s3,8(sp)
    80002a20:	e052                	sd	s4,0(sp)
    80002a22:	1800                	addi	s0,sp,48
    80002a24:	892a                	mv	s2,a0
    80002a26:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a28:	0001f517          	auipc	a0,0x1f
    80002a2c:	61050513          	addi	a0,a0,1552 # 80022038 <itable>
    80002a30:	4f8030ef          	jal	80005f28 <acquire>
  empty = 0;
    80002a34:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a36:	0001f497          	auipc	s1,0x1f
    80002a3a:	61a48493          	addi	s1,s1,1562 # 80022050 <itable+0x18>
    80002a3e:	00021697          	auipc	a3,0x21
    80002a42:	0a268693          	addi	a3,a3,162 # 80023ae0 <log>
    80002a46:	a809                	j	80002a58 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a48:	e781                	bnez	a5,80002a50 <iget+0x3c>
    80002a4a:	00099363          	bnez	s3,80002a50 <iget+0x3c>
      empty = ip;
    80002a4e:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a50:	08848493          	addi	s1,s1,136
    80002a54:	02d48563          	beq	s1,a3,80002a7e <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002a58:	449c                	lw	a5,8(s1)
    80002a5a:	fef057e3          	blez	a5,80002a48 <iget+0x34>
    80002a5e:	4098                	lw	a4,0(s1)
    80002a60:	ff2718e3          	bne	a4,s2,80002a50 <iget+0x3c>
    80002a64:	40d8                	lw	a4,4(s1)
    80002a66:	ff4715e3          	bne	a4,s4,80002a50 <iget+0x3c>
      ip->ref++;
    80002a6a:	2785                	addiw	a5,a5,1
    80002a6c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002a6e:	0001f517          	auipc	a0,0x1f
    80002a72:	5ca50513          	addi	a0,a0,1482 # 80022038 <itable>
    80002a76:	546030ef          	jal	80005fbc <release>
      return ip;
    80002a7a:	89a6                	mv	s3,s1
    80002a7c:	a015                	j	80002aa0 <iget+0x8c>
  if(empty == 0)
    80002a7e:	02098a63          	beqz	s3,80002ab2 <iget+0x9e>
  ip->dev = dev;
    80002a82:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002a86:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80002a8a:	4785                	li	a5,1
    80002a8c:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002a90:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80002a94:	0001f517          	auipc	a0,0x1f
    80002a98:	5a450513          	addi	a0,a0,1444 # 80022038 <itable>
    80002a9c:	520030ef          	jal	80005fbc <release>
}
    80002aa0:	854e                	mv	a0,s3
    80002aa2:	70a2                	ld	ra,40(sp)
    80002aa4:	7402                	ld	s0,32(sp)
    80002aa6:	64e2                	ld	s1,24(sp)
    80002aa8:	6942                	ld	s2,16(sp)
    80002aaa:	69a2                	ld	s3,8(sp)
    80002aac:	6a02                	ld	s4,0(sp)
    80002aae:	6145                	addi	sp,sp,48
    80002ab0:	8082                	ret
    panic("iget: no inodes");
    80002ab2:	00005517          	auipc	a0,0x5
    80002ab6:	97650513          	addi	a0,a0,-1674 # 80007428 <etext+0x428>
    80002aba:	1ac030ef          	jal	80005c66 <panic>

0000000080002abe <iinit>:
{
    80002abe:	7179                	addi	sp,sp,-48
    80002ac0:	f406                	sd	ra,40(sp)
    80002ac2:	f022                	sd	s0,32(sp)
    80002ac4:	ec26                	sd	s1,24(sp)
    80002ac6:	e84a                	sd	s2,16(sp)
    80002ac8:	e44e                	sd	s3,8(sp)
    80002aca:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002acc:	00005597          	auipc	a1,0x5
    80002ad0:	96c58593          	addi	a1,a1,-1684 # 80007438 <etext+0x438>
    80002ad4:	0001f517          	auipc	a0,0x1f
    80002ad8:	56450513          	addi	a0,a0,1380 # 80022038 <itable>
    80002adc:	3c2030ef          	jal	80005e9e <initlock>
  for(i = 0; i < NINODE; i++) {
    80002ae0:	0001f497          	auipc	s1,0x1f
    80002ae4:	58048493          	addi	s1,s1,1408 # 80022060 <itable+0x28>
    80002ae8:	00021997          	auipc	s3,0x21
    80002aec:	00898993          	addi	s3,s3,8 # 80023af0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002af0:	00005917          	auipc	s2,0x5
    80002af4:	95090913          	addi	s2,s2,-1712 # 80007440 <etext+0x440>
    80002af8:	85ca                	mv	a1,s2
    80002afa:	8526                	mv	a0,s1
    80002afc:	5f5000ef          	jal	800038f0 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b00:	08848493          	addi	s1,s1,136
    80002b04:	ff349ae3          	bne	s1,s3,80002af8 <iinit+0x3a>
}
    80002b08:	70a2                	ld	ra,40(sp)
    80002b0a:	7402                	ld	s0,32(sp)
    80002b0c:	64e2                	ld	s1,24(sp)
    80002b0e:	6942                	ld	s2,16(sp)
    80002b10:	69a2                	ld	s3,8(sp)
    80002b12:	6145                	addi	sp,sp,48
    80002b14:	8082                	ret

0000000080002b16 <ialloc>:
{
    80002b16:	7139                	addi	sp,sp,-64
    80002b18:	fc06                	sd	ra,56(sp)
    80002b1a:	f822                	sd	s0,48(sp)
    80002b1c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b1e:	0001f717          	auipc	a4,0x1f
    80002b22:	50672703          	lw	a4,1286(a4) # 80022024 <sb+0xc>
    80002b26:	4785                	li	a5,1
    80002b28:	06e7f063          	bgeu	a5,a4,80002b88 <ialloc+0x72>
    80002b2c:	f426                	sd	s1,40(sp)
    80002b2e:	f04a                	sd	s2,32(sp)
    80002b30:	ec4e                	sd	s3,24(sp)
    80002b32:	e852                	sd	s4,16(sp)
    80002b34:	e456                	sd	s5,8(sp)
    80002b36:	e05a                	sd	s6,0(sp)
    80002b38:	8aaa                	mv	s5,a0
    80002b3a:	8b2e                	mv	s6,a1
    80002b3c:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002b3e:	0001fa17          	auipc	s4,0x1f
    80002b42:	4daa0a13          	addi	s4,s4,1242 # 80022018 <sb>
    80002b46:	00495593          	srli	a1,s2,0x4
    80002b4a:	018a2783          	lw	a5,24(s4)
    80002b4e:	9dbd                	addw	a1,a1,a5
    80002b50:	8556                	mv	a0,s5
    80002b52:	a9dff0ef          	jal	800025ee <bread>
    80002b56:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002b58:	05850993          	addi	s3,a0,88
    80002b5c:	00f97793          	andi	a5,s2,15
    80002b60:	079a                	slli	a5,a5,0x6
    80002b62:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002b64:	00099783          	lh	a5,0(s3)
    80002b68:	cb9d                	beqz	a5,80002b9e <ialloc+0x88>
    brelse(bp);
    80002b6a:	b8dff0ef          	jal	800026f6 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b6e:	0905                	addi	s2,s2,1
    80002b70:	00ca2703          	lw	a4,12(s4)
    80002b74:	0009079b          	sext.w	a5,s2
    80002b78:	fce7e7e3          	bltu	a5,a4,80002b46 <ialloc+0x30>
    80002b7c:	74a2                	ld	s1,40(sp)
    80002b7e:	7902                	ld	s2,32(sp)
    80002b80:	69e2                	ld	s3,24(sp)
    80002b82:	6a42                	ld	s4,16(sp)
    80002b84:	6aa2                	ld	s5,8(sp)
    80002b86:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002b88:	00005517          	auipc	a0,0x5
    80002b8c:	8c050513          	addi	a0,a0,-1856 # 80007448 <etext+0x448>
    80002b90:	5ad020ef          	jal	8000593c <printf>
  return 0;
    80002b94:	4501                	li	a0,0
}
    80002b96:	70e2                	ld	ra,56(sp)
    80002b98:	7442                	ld	s0,48(sp)
    80002b9a:	6121                	addi	sp,sp,64
    80002b9c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b9e:	04000613          	li	a2,64
    80002ba2:	4581                	li	a1,0
    80002ba4:	854e                	mv	a0,s3
    80002ba6:	db8fd0ef          	jal	8000015e <memset>
      dip->type = type;
    80002baa:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bae:	8526                	mv	a0,s1
    80002bb0:	47d000ef          	jal	8000382c <log_write>
      brelse(bp);
    80002bb4:	8526                	mv	a0,s1
    80002bb6:	b41ff0ef          	jal	800026f6 <brelse>
      return iget(dev, inum);
    80002bba:	0009059b          	sext.w	a1,s2
    80002bbe:	8556                	mv	a0,s5
    80002bc0:	e55ff0ef          	jal	80002a14 <iget>
    80002bc4:	74a2                	ld	s1,40(sp)
    80002bc6:	7902                	ld	s2,32(sp)
    80002bc8:	69e2                	ld	s3,24(sp)
    80002bca:	6a42                	ld	s4,16(sp)
    80002bcc:	6aa2                	ld	s5,8(sp)
    80002bce:	6b02                	ld	s6,0(sp)
    80002bd0:	b7d9                	j	80002b96 <ialloc+0x80>

0000000080002bd2 <iupdate>:
{
    80002bd2:	1101                	addi	sp,sp,-32
    80002bd4:	ec06                	sd	ra,24(sp)
    80002bd6:	e822                	sd	s0,16(sp)
    80002bd8:	e426                	sd	s1,8(sp)
    80002bda:	e04a                	sd	s2,0(sp)
    80002bdc:	1000                	addi	s0,sp,32
    80002bde:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002be0:	415c                	lw	a5,4(a0)
    80002be2:	0047d79b          	srliw	a5,a5,0x4
    80002be6:	0001f597          	auipc	a1,0x1f
    80002bea:	44a5a583          	lw	a1,1098(a1) # 80022030 <sb+0x18>
    80002bee:	9dbd                	addw	a1,a1,a5
    80002bf0:	4108                	lw	a0,0(a0)
    80002bf2:	9fdff0ef          	jal	800025ee <bread>
    80002bf6:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002bf8:	05850793          	addi	a5,a0,88
    80002bfc:	40d8                	lw	a4,4(s1)
    80002bfe:	8b3d                	andi	a4,a4,15
    80002c00:	071a                	slli	a4,a4,0x6
    80002c02:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c04:	04449703          	lh	a4,68(s1)
    80002c08:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c0c:	04649703          	lh	a4,70(s1)
    80002c10:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c14:	04849703          	lh	a4,72(s1)
    80002c18:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c1c:	04a49703          	lh	a4,74(s1)
    80002c20:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c24:	44f8                	lw	a4,76(s1)
    80002c26:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c28:	03400613          	li	a2,52
    80002c2c:	05048593          	addi	a1,s1,80
    80002c30:	00c78513          	addi	a0,a5,12
    80002c34:	d8afd0ef          	jal	800001be <memmove>
  log_write(bp);
    80002c38:	854a                	mv	a0,s2
    80002c3a:	3f3000ef          	jal	8000382c <log_write>
  brelse(bp);
    80002c3e:	854a                	mv	a0,s2
    80002c40:	ab7ff0ef          	jal	800026f6 <brelse>
}
    80002c44:	60e2                	ld	ra,24(sp)
    80002c46:	6442                	ld	s0,16(sp)
    80002c48:	64a2                	ld	s1,8(sp)
    80002c4a:	6902                	ld	s2,0(sp)
    80002c4c:	6105                	addi	sp,sp,32
    80002c4e:	8082                	ret

0000000080002c50 <idup>:
{
    80002c50:	1101                	addi	sp,sp,-32
    80002c52:	ec06                	sd	ra,24(sp)
    80002c54:	e822                	sd	s0,16(sp)
    80002c56:	e426                	sd	s1,8(sp)
    80002c58:	1000                	addi	s0,sp,32
    80002c5a:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002c5c:	0001f517          	auipc	a0,0x1f
    80002c60:	3dc50513          	addi	a0,a0,988 # 80022038 <itable>
    80002c64:	2c4030ef          	jal	80005f28 <acquire>
  ip->ref++;
    80002c68:	449c                	lw	a5,8(s1)
    80002c6a:	2785                	addiw	a5,a5,1
    80002c6c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002c6e:	0001f517          	auipc	a0,0x1f
    80002c72:	3ca50513          	addi	a0,a0,970 # 80022038 <itable>
    80002c76:	346030ef          	jal	80005fbc <release>
}
    80002c7a:	8526                	mv	a0,s1
    80002c7c:	60e2                	ld	ra,24(sp)
    80002c7e:	6442                	ld	s0,16(sp)
    80002c80:	64a2                	ld	s1,8(sp)
    80002c82:	6105                	addi	sp,sp,32
    80002c84:	8082                	ret

0000000080002c86 <ilock>:
{
    80002c86:	1101                	addi	sp,sp,-32
    80002c88:	ec06                	sd	ra,24(sp)
    80002c8a:	e822                	sd	s0,16(sp)
    80002c8c:	e426                	sd	s1,8(sp)
    80002c8e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c90:	cd19                	beqz	a0,80002cae <ilock+0x28>
    80002c92:	84aa                	mv	s1,a0
    80002c94:	451c                	lw	a5,8(a0)
    80002c96:	00f05c63          	blez	a5,80002cae <ilock+0x28>
  acquiresleep(&ip->lock);
    80002c9a:	0541                	addi	a0,a0,16
    80002c9c:	48b000ef          	jal	80003926 <acquiresleep>
  if(ip->valid == 0){
    80002ca0:	40bc                	lw	a5,64(s1)
    80002ca2:	cf89                	beqz	a5,80002cbc <ilock+0x36>
}
    80002ca4:	60e2                	ld	ra,24(sp)
    80002ca6:	6442                	ld	s0,16(sp)
    80002ca8:	64a2                	ld	s1,8(sp)
    80002caa:	6105                	addi	sp,sp,32
    80002cac:	8082                	ret
    80002cae:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002cb0:	00004517          	auipc	a0,0x4
    80002cb4:	7b050513          	addi	a0,a0,1968 # 80007460 <etext+0x460>
    80002cb8:	7af020ef          	jal	80005c66 <panic>
    80002cbc:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cbe:	40dc                	lw	a5,4(s1)
    80002cc0:	0047d79b          	srliw	a5,a5,0x4
    80002cc4:	0001f597          	auipc	a1,0x1f
    80002cc8:	36c5a583          	lw	a1,876(a1) # 80022030 <sb+0x18>
    80002ccc:	9dbd                	addw	a1,a1,a5
    80002cce:	4088                	lw	a0,0(s1)
    80002cd0:	91fff0ef          	jal	800025ee <bread>
    80002cd4:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002cd6:	05850593          	addi	a1,a0,88
    80002cda:	40dc                	lw	a5,4(s1)
    80002cdc:	8bbd                	andi	a5,a5,15
    80002cde:	079a                	slli	a5,a5,0x6
    80002ce0:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002ce2:	00059783          	lh	a5,0(a1)
    80002ce6:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002cea:	00259783          	lh	a5,2(a1)
    80002cee:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002cf2:	00459783          	lh	a5,4(a1)
    80002cf6:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002cfa:	00659783          	lh	a5,6(a1)
    80002cfe:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d02:	459c                	lw	a5,8(a1)
    80002d04:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d06:	03400613          	li	a2,52
    80002d0a:	05b1                	addi	a1,a1,12
    80002d0c:	05048513          	addi	a0,s1,80
    80002d10:	caefd0ef          	jal	800001be <memmove>
    brelse(bp);
    80002d14:	854a                	mv	a0,s2
    80002d16:	9e1ff0ef          	jal	800026f6 <brelse>
    ip->valid = 1;
    80002d1a:	4785                	li	a5,1
    80002d1c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d1e:	04449783          	lh	a5,68(s1)
    80002d22:	c399                	beqz	a5,80002d28 <ilock+0xa2>
    80002d24:	6902                	ld	s2,0(sp)
    80002d26:	bfbd                	j	80002ca4 <ilock+0x1e>
      panic("ilock: no type");
    80002d28:	00004517          	auipc	a0,0x4
    80002d2c:	74050513          	addi	a0,a0,1856 # 80007468 <etext+0x468>
    80002d30:	737020ef          	jal	80005c66 <panic>

0000000080002d34 <iunlock>:
{
    80002d34:	1101                	addi	sp,sp,-32
    80002d36:	ec06                	sd	ra,24(sp)
    80002d38:	e822                	sd	s0,16(sp)
    80002d3a:	e426                	sd	s1,8(sp)
    80002d3c:	e04a                	sd	s2,0(sp)
    80002d3e:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d40:	c505                	beqz	a0,80002d68 <iunlock+0x34>
    80002d42:	84aa                	mv	s1,a0
    80002d44:	01050913          	addi	s2,a0,16
    80002d48:	854a                	mv	a0,s2
    80002d4a:	45b000ef          	jal	800039a4 <holdingsleep>
    80002d4e:	cd09                	beqz	a0,80002d68 <iunlock+0x34>
    80002d50:	449c                	lw	a5,8(s1)
    80002d52:	00f05b63          	blez	a5,80002d68 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002d56:	854a                	mv	a0,s2
    80002d58:	415000ef          	jal	8000396c <releasesleep>
}
    80002d5c:	60e2                	ld	ra,24(sp)
    80002d5e:	6442                	ld	s0,16(sp)
    80002d60:	64a2                	ld	s1,8(sp)
    80002d62:	6902                	ld	s2,0(sp)
    80002d64:	6105                	addi	sp,sp,32
    80002d66:	8082                	ret
    panic("iunlock");
    80002d68:	00004517          	auipc	a0,0x4
    80002d6c:	71050513          	addi	a0,a0,1808 # 80007478 <etext+0x478>
    80002d70:	6f7020ef          	jal	80005c66 <panic>

0000000080002d74 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d74:	7179                	addi	sp,sp,-48
    80002d76:	f406                	sd	ra,40(sp)
    80002d78:	f022                	sd	s0,32(sp)
    80002d7a:	ec26                	sd	s1,24(sp)
    80002d7c:	e84a                	sd	s2,16(sp)
    80002d7e:	e44e                	sd	s3,8(sp)
    80002d80:	1800                	addi	s0,sp,48
    80002d82:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d84:	05050493          	addi	s1,a0,80
    80002d88:	08050913          	addi	s2,a0,128
    80002d8c:	a021                	j	80002d94 <itrunc+0x20>
    80002d8e:	0491                	addi	s1,s1,4
    80002d90:	01248b63          	beq	s1,s2,80002da6 <itrunc+0x32>
    if(ip->addrs[i]){
    80002d94:	408c                	lw	a1,0(s1)
    80002d96:	dde5                	beqz	a1,80002d8e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002d98:	0009a503          	lw	a0,0(s3)
    80002d9c:	a47ff0ef          	jal	800027e2 <bfree>
      ip->addrs[i] = 0;
    80002da0:	0004a023          	sw	zero,0(s1)
    80002da4:	b7ed                	j	80002d8e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002da6:	0809a583          	lw	a1,128(s3)
    80002daa:	ed89                	bnez	a1,80002dc4 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002dac:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002db0:	854e                	mv	a0,s3
    80002db2:	e21ff0ef          	jal	80002bd2 <iupdate>
}
    80002db6:	70a2                	ld	ra,40(sp)
    80002db8:	7402                	ld	s0,32(sp)
    80002dba:	64e2                	ld	s1,24(sp)
    80002dbc:	6942                	ld	s2,16(sp)
    80002dbe:	69a2                	ld	s3,8(sp)
    80002dc0:	6145                	addi	sp,sp,48
    80002dc2:	8082                	ret
    80002dc4:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002dc6:	0009a503          	lw	a0,0(s3)
    80002dca:	825ff0ef          	jal	800025ee <bread>
    80002dce:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002dd0:	05850493          	addi	s1,a0,88
    80002dd4:	45850913          	addi	s2,a0,1112
    80002dd8:	a021                	j	80002de0 <itrunc+0x6c>
    80002dda:	0491                	addi	s1,s1,4
    80002ddc:	01248963          	beq	s1,s2,80002dee <itrunc+0x7a>
      if(a[j])
    80002de0:	408c                	lw	a1,0(s1)
    80002de2:	dde5                	beqz	a1,80002dda <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002de4:	0009a503          	lw	a0,0(s3)
    80002de8:	9fbff0ef          	jal	800027e2 <bfree>
    80002dec:	b7fd                	j	80002dda <itrunc+0x66>
    brelse(bp);
    80002dee:	8552                	mv	a0,s4
    80002df0:	907ff0ef          	jal	800026f6 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002df4:	0809a583          	lw	a1,128(s3)
    80002df8:	0009a503          	lw	a0,0(s3)
    80002dfc:	9e7ff0ef          	jal	800027e2 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e00:	0809a023          	sw	zero,128(s3)
    80002e04:	6a02                	ld	s4,0(sp)
    80002e06:	b75d                	j	80002dac <itrunc+0x38>

0000000080002e08 <iput>:
{
    80002e08:	1101                	addi	sp,sp,-32
    80002e0a:	ec06                	sd	ra,24(sp)
    80002e0c:	e822                	sd	s0,16(sp)
    80002e0e:	e426                	sd	s1,8(sp)
    80002e10:	1000                	addi	s0,sp,32
    80002e12:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e14:	0001f517          	auipc	a0,0x1f
    80002e18:	22450513          	addi	a0,a0,548 # 80022038 <itable>
    80002e1c:	10c030ef          	jal	80005f28 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e20:	4498                	lw	a4,8(s1)
    80002e22:	4785                	li	a5,1
    80002e24:	02f70063          	beq	a4,a5,80002e44 <iput+0x3c>
  ip->ref--;
    80002e28:	449c                	lw	a5,8(s1)
    80002e2a:	37fd                	addiw	a5,a5,-1
    80002e2c:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e2e:	0001f517          	auipc	a0,0x1f
    80002e32:	20a50513          	addi	a0,a0,522 # 80022038 <itable>
    80002e36:	186030ef          	jal	80005fbc <release>
}
    80002e3a:	60e2                	ld	ra,24(sp)
    80002e3c:	6442                	ld	s0,16(sp)
    80002e3e:	64a2                	ld	s1,8(sp)
    80002e40:	6105                	addi	sp,sp,32
    80002e42:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e44:	40bc                	lw	a5,64(s1)
    80002e46:	d3ed                	beqz	a5,80002e28 <iput+0x20>
    80002e48:	04a49783          	lh	a5,74(s1)
    80002e4c:	fff1                	bnez	a5,80002e28 <iput+0x20>
    80002e4e:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e50:	01048793          	addi	a5,s1,16
    80002e54:	893e                	mv	s2,a5
    80002e56:	853e                	mv	a0,a5
    80002e58:	2cf000ef          	jal	80003926 <acquiresleep>
    release(&itable.lock);
    80002e5c:	0001f517          	auipc	a0,0x1f
    80002e60:	1dc50513          	addi	a0,a0,476 # 80022038 <itable>
    80002e64:	158030ef          	jal	80005fbc <release>
    itrunc(ip);
    80002e68:	8526                	mv	a0,s1
    80002e6a:	f0bff0ef          	jal	80002d74 <itrunc>
    ip->type = 0;
    80002e6e:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e72:	8526                	mv	a0,s1
    80002e74:	d5fff0ef          	jal	80002bd2 <iupdate>
    ip->valid = 0;
    80002e78:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e7c:	854a                	mv	a0,s2
    80002e7e:	2ef000ef          	jal	8000396c <releasesleep>
    acquire(&itable.lock);
    80002e82:	0001f517          	auipc	a0,0x1f
    80002e86:	1b650513          	addi	a0,a0,438 # 80022038 <itable>
    80002e8a:	09e030ef          	jal	80005f28 <acquire>
    80002e8e:	6902                	ld	s2,0(sp)
    80002e90:	bf61                	j	80002e28 <iput+0x20>

0000000080002e92 <iunlockput>:
{
    80002e92:	1101                	addi	sp,sp,-32
    80002e94:	ec06                	sd	ra,24(sp)
    80002e96:	e822                	sd	s0,16(sp)
    80002e98:	e426                	sd	s1,8(sp)
    80002e9a:	1000                	addi	s0,sp,32
    80002e9c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e9e:	e97ff0ef          	jal	80002d34 <iunlock>
  iput(ip);
    80002ea2:	8526                	mv	a0,s1
    80002ea4:	f65ff0ef          	jal	80002e08 <iput>
}
    80002ea8:	60e2                	ld	ra,24(sp)
    80002eaa:	6442                	ld	s0,16(sp)
    80002eac:	64a2                	ld	s1,8(sp)
    80002eae:	6105                	addi	sp,sp,32
    80002eb0:	8082                	ret

0000000080002eb2 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002eb2:	0001f717          	auipc	a4,0x1f
    80002eb6:	17272703          	lw	a4,370(a4) # 80022024 <sb+0xc>
    80002eba:	4785                	li	a5,1
    80002ebc:	0ae7fe63          	bgeu	a5,a4,80002f78 <ireclaim+0xc6>
{
    80002ec0:	7139                	addi	sp,sp,-64
    80002ec2:	fc06                	sd	ra,56(sp)
    80002ec4:	f822                	sd	s0,48(sp)
    80002ec6:	f426                	sd	s1,40(sp)
    80002ec8:	f04a                	sd	s2,32(sp)
    80002eca:	ec4e                	sd	s3,24(sp)
    80002ecc:	e852                	sd	s4,16(sp)
    80002ece:	e456                	sd	s5,8(sp)
    80002ed0:	e05a                	sd	s6,0(sp)
    80002ed2:	0080                	addi	s0,sp,64
    80002ed4:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002ed6:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002ed8:	0001fa17          	auipc	s4,0x1f
    80002edc:	140a0a13          	addi	s4,s4,320 # 80022018 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002ee0:	00004b17          	auipc	s6,0x4
    80002ee4:	5a0b0b13          	addi	s6,s6,1440 # 80007480 <etext+0x480>
    80002ee8:	a099                	j	80002f2e <ireclaim+0x7c>
    80002eea:	85ce                	mv	a1,s3
    80002eec:	855a                	mv	a0,s6
    80002eee:	24f020ef          	jal	8000593c <printf>
      ip = iget(dev, inum);
    80002ef2:	85ce                	mv	a1,s3
    80002ef4:	8556                	mv	a0,s5
    80002ef6:	b1fff0ef          	jal	80002a14 <iget>
    80002efa:	89aa                	mv	s3,a0
    brelse(bp);
    80002efc:	854a                	mv	a0,s2
    80002efe:	ff8ff0ef          	jal	800026f6 <brelse>
    if (ip) {
    80002f02:	00098f63          	beqz	s3,80002f20 <ireclaim+0x6e>
      begin_op();
    80002f06:	78c000ef          	jal	80003692 <begin_op>
      ilock(ip);
    80002f0a:	854e                	mv	a0,s3
    80002f0c:	d7bff0ef          	jal	80002c86 <ilock>
      iunlock(ip);
    80002f10:	854e                	mv	a0,s3
    80002f12:	e23ff0ef          	jal	80002d34 <iunlock>
      iput(ip);
    80002f16:	854e                	mv	a0,s3
    80002f18:	ef1ff0ef          	jal	80002e08 <iput>
      end_op();
    80002f1c:	7e6000ef          	jal	80003702 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002f20:	0485                	addi	s1,s1,1
    80002f22:	00ca2703          	lw	a4,12(s4)
    80002f26:	0004879b          	sext.w	a5,s1
    80002f2a:	02e7fd63          	bgeu	a5,a4,80002f64 <ireclaim+0xb2>
    80002f2e:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002f32:	0044d593          	srli	a1,s1,0x4
    80002f36:	018a2783          	lw	a5,24(s4)
    80002f3a:	9dbd                	addw	a1,a1,a5
    80002f3c:	8556                	mv	a0,s5
    80002f3e:	eb0ff0ef          	jal	800025ee <bread>
    80002f42:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002f44:	05850793          	addi	a5,a0,88
    80002f48:	00f9f713          	andi	a4,s3,15
    80002f4c:	071a                	slli	a4,a4,0x6
    80002f4e:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002f50:	00079703          	lh	a4,0(a5)
    80002f54:	c701                	beqz	a4,80002f5c <ireclaim+0xaa>
    80002f56:	00679783          	lh	a5,6(a5)
    80002f5a:	dbc1                	beqz	a5,80002eea <ireclaim+0x38>
    brelse(bp);
    80002f5c:	854a                	mv	a0,s2
    80002f5e:	f98ff0ef          	jal	800026f6 <brelse>
    if (ip) {
    80002f62:	bf7d                	j	80002f20 <ireclaim+0x6e>
}
    80002f64:	70e2                	ld	ra,56(sp)
    80002f66:	7442                	ld	s0,48(sp)
    80002f68:	74a2                	ld	s1,40(sp)
    80002f6a:	7902                	ld	s2,32(sp)
    80002f6c:	69e2                	ld	s3,24(sp)
    80002f6e:	6a42                	ld	s4,16(sp)
    80002f70:	6aa2                	ld	s5,8(sp)
    80002f72:	6b02                	ld	s6,0(sp)
    80002f74:	6121                	addi	sp,sp,64
    80002f76:	8082                	ret
    80002f78:	8082                	ret

0000000080002f7a <fsinit>:
fsinit(int dev) {
    80002f7a:	1101                	addi	sp,sp,-32
    80002f7c:	ec06                	sd	ra,24(sp)
    80002f7e:	e822                	sd	s0,16(sp)
    80002f80:	e426                	sd	s1,8(sp)
    80002f82:	e04a                	sd	s2,0(sp)
    80002f84:	1000                	addi	s0,sp,32
    80002f86:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002f88:	4585                	li	a1,1
    80002f8a:	e64ff0ef          	jal	800025ee <bread>
    80002f8e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002f90:	02000613          	li	a2,32
    80002f94:	05850593          	addi	a1,a0,88
    80002f98:	0001f517          	auipc	a0,0x1f
    80002f9c:	08050513          	addi	a0,a0,128 # 80022018 <sb>
    80002fa0:	a1efd0ef          	jal	800001be <memmove>
  brelse(bp);
    80002fa4:	8526                	mv	a0,s1
    80002fa6:	f50ff0ef          	jal	800026f6 <brelse>
  if(sb.magic != FSMAGIC)
    80002faa:	0001f717          	auipc	a4,0x1f
    80002fae:	06e72703          	lw	a4,110(a4) # 80022018 <sb>
    80002fb2:	102037b7          	lui	a5,0x10203
    80002fb6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002fba:	02f71263          	bne	a4,a5,80002fde <fsinit+0x64>
  initlog(dev, &sb);
    80002fbe:	0001f597          	auipc	a1,0x1f
    80002fc2:	05a58593          	addi	a1,a1,90 # 80022018 <sb>
    80002fc6:	854a                	mv	a0,s2
    80002fc8:	648000ef          	jal	80003610 <initlog>
  ireclaim(dev);
    80002fcc:	854a                	mv	a0,s2
    80002fce:	ee5ff0ef          	jal	80002eb2 <ireclaim>
}
    80002fd2:	60e2                	ld	ra,24(sp)
    80002fd4:	6442                	ld	s0,16(sp)
    80002fd6:	64a2                	ld	s1,8(sp)
    80002fd8:	6902                	ld	s2,0(sp)
    80002fda:	6105                	addi	sp,sp,32
    80002fdc:	8082                	ret
    panic("invalid file system");
    80002fde:	00004517          	auipc	a0,0x4
    80002fe2:	4c250513          	addi	a0,a0,1218 # 800074a0 <etext+0x4a0>
    80002fe6:	481020ef          	jal	80005c66 <panic>

0000000080002fea <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002fea:	1141                	addi	sp,sp,-16
    80002fec:	e406                	sd	ra,8(sp)
    80002fee:	e022                	sd	s0,0(sp)
    80002ff0:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ff2:	411c                	lw	a5,0(a0)
    80002ff4:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ff6:	415c                	lw	a5,4(a0)
    80002ff8:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ffa:	04451783          	lh	a5,68(a0)
    80002ffe:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80003002:	04a51783          	lh	a5,74(a0)
    80003006:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    8000300a:	04c56783          	lwu	a5,76(a0)
    8000300e:	e99c                	sd	a5,16(a1)
}
    80003010:	60a2                	ld	ra,8(sp)
    80003012:	6402                	ld	s0,0(sp)
    80003014:	0141                	addi	sp,sp,16
    80003016:	8082                	ret

0000000080003018 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003018:	457c                	lw	a5,76(a0)
    8000301a:	0ed7e663          	bltu	a5,a3,80003106 <readi+0xee>
{
    8000301e:	7159                	addi	sp,sp,-112
    80003020:	f486                	sd	ra,104(sp)
    80003022:	f0a2                	sd	s0,96(sp)
    80003024:	eca6                	sd	s1,88(sp)
    80003026:	e0d2                	sd	s4,64(sp)
    80003028:	fc56                	sd	s5,56(sp)
    8000302a:	f85a                	sd	s6,48(sp)
    8000302c:	f45e                	sd	s7,40(sp)
    8000302e:	1880                	addi	s0,sp,112
    80003030:	8b2a                	mv	s6,a0
    80003032:	8bae                	mv	s7,a1
    80003034:	8a32                	mv	s4,a2
    80003036:	84b6                	mv	s1,a3
    80003038:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    8000303a:	9f35                	addw	a4,a4,a3
    return 0;
    8000303c:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000303e:	0ad76b63          	bltu	a4,a3,800030f4 <readi+0xdc>
    80003042:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003044:	00e7f463          	bgeu	a5,a4,8000304c <readi+0x34>
    n = ip->size - off;
    80003048:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000304c:	080a8b63          	beqz	s5,800030e2 <readi+0xca>
    80003050:	e8ca                	sd	s2,80(sp)
    80003052:	f062                	sd	s8,32(sp)
    80003054:	ec66                	sd	s9,24(sp)
    80003056:	e86a                	sd	s10,16(sp)
    80003058:	e46e                	sd	s11,8(sp)
    8000305a:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000305c:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80003060:	5c7d                	li	s8,-1
    80003062:	a80d                	j	80003094 <readi+0x7c>
    80003064:	020d1d93          	slli	s11,s10,0x20
    80003068:	020ddd93          	srli	s11,s11,0x20
    8000306c:	05890613          	addi	a2,s2,88
    80003070:	86ee                	mv	a3,s11
    80003072:	963e                	add	a2,a2,a5
    80003074:	85d2                	mv	a1,s4
    80003076:	855e                	mv	a0,s7
    80003078:	a79fe0ef          	jal	80001af0 <either_copyout>
    8000307c:	05850363          	beq	a0,s8,800030c2 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80003080:	854a                	mv	a0,s2
    80003082:	e74ff0ef          	jal	800026f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003086:	013d09bb          	addw	s3,s10,s3
    8000308a:	009d04bb          	addw	s1,s10,s1
    8000308e:	9a6e                	add	s4,s4,s11
    80003090:	0559f363          	bgeu	s3,s5,800030d6 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80003094:	00a4d59b          	srliw	a1,s1,0xa
    80003098:	855a                	mv	a0,s6
    8000309a:	8bbff0ef          	jal	80002954 <bmap>
    8000309e:	85aa                	mv	a1,a0
    if(addr == 0)
    800030a0:	c139                	beqz	a0,800030e6 <readi+0xce>
    bp = bread(ip->dev, addr);
    800030a2:	000b2503          	lw	a0,0(s6)
    800030a6:	d48ff0ef          	jal	800025ee <bread>
    800030aa:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030ac:	3ff4f793          	andi	a5,s1,1023
    800030b0:	40fc873b          	subw	a4,s9,a5
    800030b4:	413a86bb          	subw	a3,s5,s3
    800030b8:	8d3a                	mv	s10,a4
    800030ba:	fae6f5e3          	bgeu	a3,a4,80003064 <readi+0x4c>
    800030be:	8d36                	mv	s10,a3
    800030c0:	b755                	j	80003064 <readi+0x4c>
      brelse(bp);
    800030c2:	854a                	mv	a0,s2
    800030c4:	e32ff0ef          	jal	800026f6 <brelse>
      tot = -1;
    800030c8:	59fd                	li	s3,-1
      break;
    800030ca:	6946                	ld	s2,80(sp)
    800030cc:	7c02                	ld	s8,32(sp)
    800030ce:	6ce2                	ld	s9,24(sp)
    800030d0:	6d42                	ld	s10,16(sp)
    800030d2:	6da2                	ld	s11,8(sp)
    800030d4:	a831                	j	800030f0 <readi+0xd8>
    800030d6:	6946                	ld	s2,80(sp)
    800030d8:	7c02                	ld	s8,32(sp)
    800030da:	6ce2                	ld	s9,24(sp)
    800030dc:	6d42                	ld	s10,16(sp)
    800030de:	6da2                	ld	s11,8(sp)
    800030e0:	a801                	j	800030f0 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030e2:	89d6                	mv	s3,s5
    800030e4:	a031                	j	800030f0 <readi+0xd8>
    800030e6:	6946                	ld	s2,80(sp)
    800030e8:	7c02                	ld	s8,32(sp)
    800030ea:	6ce2                	ld	s9,24(sp)
    800030ec:	6d42                	ld	s10,16(sp)
    800030ee:	6da2                	ld	s11,8(sp)
  }
  return tot;
    800030f0:	854e                	mv	a0,s3
    800030f2:	69a6                	ld	s3,72(sp)
}
    800030f4:	70a6                	ld	ra,104(sp)
    800030f6:	7406                	ld	s0,96(sp)
    800030f8:	64e6                	ld	s1,88(sp)
    800030fa:	6a06                	ld	s4,64(sp)
    800030fc:	7ae2                	ld	s5,56(sp)
    800030fe:	7b42                	ld	s6,48(sp)
    80003100:	7ba2                	ld	s7,40(sp)
    80003102:	6165                	addi	sp,sp,112
    80003104:	8082                	ret
    return 0;
    80003106:	4501                	li	a0,0
}
    80003108:	8082                	ret

000000008000310a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    8000310a:	457c                	lw	a5,76(a0)
    8000310c:	0ed7eb63          	bltu	a5,a3,80003202 <writei+0xf8>
{
    80003110:	7159                	addi	sp,sp,-112
    80003112:	f486                	sd	ra,104(sp)
    80003114:	f0a2                	sd	s0,96(sp)
    80003116:	e8ca                	sd	s2,80(sp)
    80003118:	e0d2                	sd	s4,64(sp)
    8000311a:	fc56                	sd	s5,56(sp)
    8000311c:	f85a                	sd	s6,48(sp)
    8000311e:	f45e                	sd	s7,40(sp)
    80003120:	1880                	addi	s0,sp,112
    80003122:	8aaa                	mv	s5,a0
    80003124:	8bae                	mv	s7,a1
    80003126:	8a32                	mv	s4,a2
    80003128:	8936                	mv	s2,a3
    8000312a:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    8000312c:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80003130:	00043737          	lui	a4,0x43
    80003134:	0cf76963          	bltu	a4,a5,80003206 <writei+0xfc>
    80003138:	0cd7e763          	bltu	a5,a3,80003206 <writei+0xfc>
    8000313c:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000313e:	0a0b0a63          	beqz	s6,800031f2 <writei+0xe8>
    80003142:	eca6                	sd	s1,88(sp)
    80003144:	f062                	sd	s8,32(sp)
    80003146:	ec66                	sd	s9,24(sp)
    80003148:	e86a                	sd	s10,16(sp)
    8000314a:	e46e                	sd	s11,8(sp)
    8000314c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000314e:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003152:	5c7d                	li	s8,-1
    80003154:	a825                	j	8000318c <writei+0x82>
    80003156:	020d1d93          	slli	s11,s10,0x20
    8000315a:	020ddd93          	srli	s11,s11,0x20
    8000315e:	05848513          	addi	a0,s1,88
    80003162:	86ee                	mv	a3,s11
    80003164:	8652                	mv	a2,s4
    80003166:	85de                	mv	a1,s7
    80003168:	953e                	add	a0,a0,a5
    8000316a:	9d1fe0ef          	jal	80001b3a <either_copyin>
    8000316e:	05850663          	beq	a0,s8,800031ba <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003172:	8526                	mv	a0,s1
    80003174:	6b8000ef          	jal	8000382c <log_write>
    brelse(bp);
    80003178:	8526                	mv	a0,s1
    8000317a:	d7cff0ef          	jal	800026f6 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000317e:	013d09bb          	addw	s3,s10,s3
    80003182:	012d093b          	addw	s2,s10,s2
    80003186:	9a6e                	add	s4,s4,s11
    80003188:	0369fc63          	bgeu	s3,s6,800031c0 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    8000318c:	00a9559b          	srliw	a1,s2,0xa
    80003190:	8556                	mv	a0,s5
    80003192:	fc2ff0ef          	jal	80002954 <bmap>
    80003196:	85aa                	mv	a1,a0
    if(addr == 0)
    80003198:	c505                	beqz	a0,800031c0 <writei+0xb6>
    bp = bread(ip->dev, addr);
    8000319a:	000aa503          	lw	a0,0(s5)
    8000319e:	c50ff0ef          	jal	800025ee <bread>
    800031a2:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031a4:	3ff97793          	andi	a5,s2,1023
    800031a8:	40fc873b          	subw	a4,s9,a5
    800031ac:	413b06bb          	subw	a3,s6,s3
    800031b0:	8d3a                	mv	s10,a4
    800031b2:	fae6f2e3          	bgeu	a3,a4,80003156 <writei+0x4c>
    800031b6:	8d36                	mv	s10,a3
    800031b8:	bf79                	j	80003156 <writei+0x4c>
      brelse(bp);
    800031ba:	8526                	mv	a0,s1
    800031bc:	d3aff0ef          	jal	800026f6 <brelse>
  }

  if(off > ip->size)
    800031c0:	04caa783          	lw	a5,76(s5)
    800031c4:	0327f963          	bgeu	a5,s2,800031f6 <writei+0xec>
    ip->size = off;
    800031c8:	052aa623          	sw	s2,76(s5)
    800031cc:	64e6                	ld	s1,88(sp)
    800031ce:	7c02                	ld	s8,32(sp)
    800031d0:	6ce2                	ld	s9,24(sp)
    800031d2:	6d42                	ld	s10,16(sp)
    800031d4:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    800031d6:	8556                	mv	a0,s5
    800031d8:	9fbff0ef          	jal	80002bd2 <iupdate>

  return tot;
    800031dc:	854e                	mv	a0,s3
    800031de:	69a6                	ld	s3,72(sp)
}
    800031e0:	70a6                	ld	ra,104(sp)
    800031e2:	7406                	ld	s0,96(sp)
    800031e4:	6946                	ld	s2,80(sp)
    800031e6:	6a06                	ld	s4,64(sp)
    800031e8:	7ae2                	ld	s5,56(sp)
    800031ea:	7b42                	ld	s6,48(sp)
    800031ec:	7ba2                	ld	s7,40(sp)
    800031ee:	6165                	addi	sp,sp,112
    800031f0:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031f2:	89da                	mv	s3,s6
    800031f4:	b7cd                	j	800031d6 <writei+0xcc>
    800031f6:	64e6                	ld	s1,88(sp)
    800031f8:	7c02                	ld	s8,32(sp)
    800031fa:	6ce2                	ld	s9,24(sp)
    800031fc:	6d42                	ld	s10,16(sp)
    800031fe:	6da2                	ld	s11,8(sp)
    80003200:	bfd9                	j	800031d6 <writei+0xcc>
    return -1;
    80003202:	557d                	li	a0,-1
}
    80003204:	8082                	ret
    return -1;
    80003206:	557d                	li	a0,-1
    80003208:	bfe1                	j	800031e0 <writei+0xd6>

000000008000320a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    8000320a:	1141                	addi	sp,sp,-16
    8000320c:	e406                	sd	ra,8(sp)
    8000320e:	e022                	sd	s0,0(sp)
    80003210:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80003212:	4639                	li	a2,14
    80003214:	81efd0ef          	jal	80000232 <strncmp>
}
    80003218:	60a2                	ld	ra,8(sp)
    8000321a:	6402                	ld	s0,0(sp)
    8000321c:	0141                	addi	sp,sp,16
    8000321e:	8082                	ret

0000000080003220 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003220:	711d                	addi	sp,sp,-96
    80003222:	ec86                	sd	ra,88(sp)
    80003224:	e8a2                	sd	s0,80(sp)
    80003226:	e4a6                	sd	s1,72(sp)
    80003228:	e0ca                	sd	s2,64(sp)
    8000322a:	fc4e                	sd	s3,56(sp)
    8000322c:	f852                	sd	s4,48(sp)
    8000322e:	f456                	sd	s5,40(sp)
    80003230:	f05a                	sd	s6,32(sp)
    80003232:	ec5e                	sd	s7,24(sp)
    80003234:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003236:	04451703          	lh	a4,68(a0)
    8000323a:	4785                	li	a5,1
    8000323c:	00f71f63          	bne	a4,a5,8000325a <dirlookup+0x3a>
    80003240:	892a                	mv	s2,a0
    80003242:	8aae                	mv	s5,a1
    80003244:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003246:	457c                	lw	a5,76(a0)
    80003248:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000324a:	fa040a13          	addi	s4,s0,-96
    8000324e:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80003250:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003254:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003256:	e39d                	bnez	a5,8000327c <dirlookup+0x5c>
    80003258:	a8b9                	j	800032b6 <dirlookup+0x96>
    panic("dirlookup not DIR");
    8000325a:	00004517          	auipc	a0,0x4
    8000325e:	25e50513          	addi	a0,a0,606 # 800074b8 <etext+0x4b8>
    80003262:	205020ef          	jal	80005c66 <panic>
      panic("dirlookup read");
    80003266:	00004517          	auipc	a0,0x4
    8000326a:	26a50513          	addi	a0,a0,618 # 800074d0 <etext+0x4d0>
    8000326e:	1f9020ef          	jal	80005c66 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003272:	24c1                	addiw	s1,s1,16
    80003274:	04c92783          	lw	a5,76(s2)
    80003278:	02f4fe63          	bgeu	s1,a5,800032b4 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000327c:	874e                	mv	a4,s3
    8000327e:	86a6                	mv	a3,s1
    80003280:	8652                	mv	a2,s4
    80003282:	4581                	li	a1,0
    80003284:	854a                	mv	a0,s2
    80003286:	d93ff0ef          	jal	80003018 <readi>
    8000328a:	fd351ee3          	bne	a0,s3,80003266 <dirlookup+0x46>
    if(de.inum == 0)
    8000328e:	fa045783          	lhu	a5,-96(s0)
    80003292:	d3e5                	beqz	a5,80003272 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80003294:	85da                	mv	a1,s6
    80003296:	8556                	mv	a0,s5
    80003298:	f73ff0ef          	jal	8000320a <namecmp>
    8000329c:	f979                	bnez	a0,80003272 <dirlookup+0x52>
      if(poff)
    8000329e:	000b8463          	beqz	s7,800032a6 <dirlookup+0x86>
        *poff = off;
    800032a2:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800032a6:	fa045583          	lhu	a1,-96(s0)
    800032aa:	00092503          	lw	a0,0(s2)
    800032ae:	f66ff0ef          	jal	80002a14 <iget>
    800032b2:	a011                	j	800032b6 <dirlookup+0x96>
  return 0;
    800032b4:	4501                	li	a0,0
}
    800032b6:	60e6                	ld	ra,88(sp)
    800032b8:	6446                	ld	s0,80(sp)
    800032ba:	64a6                	ld	s1,72(sp)
    800032bc:	6906                	ld	s2,64(sp)
    800032be:	79e2                	ld	s3,56(sp)
    800032c0:	7a42                	ld	s4,48(sp)
    800032c2:	7aa2                	ld	s5,40(sp)
    800032c4:	7b02                	ld	s6,32(sp)
    800032c6:	6be2                	ld	s7,24(sp)
    800032c8:	6125                	addi	sp,sp,96
    800032ca:	8082                	ret

00000000800032cc <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800032cc:	711d                	addi	sp,sp,-96
    800032ce:	ec86                	sd	ra,88(sp)
    800032d0:	e8a2                	sd	s0,80(sp)
    800032d2:	e4a6                	sd	s1,72(sp)
    800032d4:	e0ca                	sd	s2,64(sp)
    800032d6:	fc4e                	sd	s3,56(sp)
    800032d8:	f852                	sd	s4,48(sp)
    800032da:	f456                	sd	s5,40(sp)
    800032dc:	f05a                	sd	s6,32(sp)
    800032de:	ec5e                	sd	s7,24(sp)
    800032e0:	e862                	sd	s8,16(sp)
    800032e2:	e466                	sd	s9,8(sp)
    800032e4:	e06a                	sd	s10,0(sp)
    800032e6:	1080                	addi	s0,sp,96
    800032e8:	84aa                	mv	s1,a0
    800032ea:	8b2e                	mv	s6,a1
    800032ec:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800032ee:	00054703          	lbu	a4,0(a0)
    800032f2:	02f00793          	li	a5,47
    800032f6:	00f70f63          	beq	a4,a5,80003314 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800032fa:	df7fd0ef          	jal	800010f0 <myproc>
    800032fe:	15053503          	ld	a0,336(a0)
    80003302:	94fff0ef          	jal	80002c50 <idup>
    80003306:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003308:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    8000330c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    8000330e:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80003310:	4b85                	li	s7,1
    80003312:	a879                	j	800033b0 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003314:	4585                	li	a1,1
    80003316:	852e                	mv	a0,a1
    80003318:	efcff0ef          	jal	80002a14 <iget>
    8000331c:	8a2a                	mv	s4,a0
    8000331e:	b7ed                	j	80003308 <namex+0x3c>
      iunlockput(ip);
    80003320:	8552                	mv	a0,s4
    80003322:	b71ff0ef          	jal	80002e92 <iunlockput>
      return 0;
    80003326:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003328:	8552                	mv	a0,s4
    8000332a:	60e6                	ld	ra,88(sp)
    8000332c:	6446                	ld	s0,80(sp)
    8000332e:	64a6                	ld	s1,72(sp)
    80003330:	6906                	ld	s2,64(sp)
    80003332:	79e2                	ld	s3,56(sp)
    80003334:	7a42                	ld	s4,48(sp)
    80003336:	7aa2                	ld	s5,40(sp)
    80003338:	7b02                	ld	s6,32(sp)
    8000333a:	6be2                	ld	s7,24(sp)
    8000333c:	6c42                	ld	s8,16(sp)
    8000333e:	6ca2                	ld	s9,8(sp)
    80003340:	6d02                	ld	s10,0(sp)
    80003342:	6125                	addi	sp,sp,96
    80003344:	8082                	ret
      iunlock(ip);
    80003346:	8552                	mv	a0,s4
    80003348:	9edff0ef          	jal	80002d34 <iunlock>
      return ip;
    8000334c:	bff1                	j	80003328 <namex+0x5c>
      iunlockput(ip);
    8000334e:	8552                	mv	a0,s4
    80003350:	b43ff0ef          	jal	80002e92 <iunlockput>
      return 0;
    80003354:	8a4a                	mv	s4,s2
    80003356:	bfc9                	j	80003328 <namex+0x5c>
  len = path - s;
    80003358:	40990633          	sub	a2,s2,s1
    8000335c:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80003360:	09ac5463          	bge	s8,s10,800033e8 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80003364:	8666                	mv	a2,s9
    80003366:	85a6                	mv	a1,s1
    80003368:	8556                	mv	a0,s5
    8000336a:	e55fc0ef          	jal	800001be <memmove>
    8000336e:	84ca                	mv	s1,s2
  while(*path == '/')
    80003370:	0004c783          	lbu	a5,0(s1)
    80003374:	01379763          	bne	a5,s3,80003382 <namex+0xb6>
    path++;
    80003378:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000337a:	0004c783          	lbu	a5,0(s1)
    8000337e:	ff378de3          	beq	a5,s3,80003378 <namex+0xac>
    ilock(ip);
    80003382:	8552                	mv	a0,s4
    80003384:	903ff0ef          	jal	80002c86 <ilock>
    if(ip->type != T_DIR){
    80003388:	044a1783          	lh	a5,68(s4)
    8000338c:	f9779ae3          	bne	a5,s7,80003320 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003390:	000b0563          	beqz	s6,8000339a <namex+0xce>
    80003394:	0004c783          	lbu	a5,0(s1)
    80003398:	d7dd                	beqz	a5,80003346 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000339a:	4601                	li	a2,0
    8000339c:	85d6                	mv	a1,s5
    8000339e:	8552                	mv	a0,s4
    800033a0:	e81ff0ef          	jal	80003220 <dirlookup>
    800033a4:	892a                	mv	s2,a0
    800033a6:	d545                	beqz	a0,8000334e <namex+0x82>
    iunlockput(ip);
    800033a8:	8552                	mv	a0,s4
    800033aa:	ae9ff0ef          	jal	80002e92 <iunlockput>
    ip = next;
    800033ae:	8a4a                	mv	s4,s2
  while(*path == '/')
    800033b0:	0004c783          	lbu	a5,0(s1)
    800033b4:	01379763          	bne	a5,s3,800033c2 <namex+0xf6>
    path++;
    800033b8:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033ba:	0004c783          	lbu	a5,0(s1)
    800033be:	ff378de3          	beq	a5,s3,800033b8 <namex+0xec>
  if(*path == 0)
    800033c2:	cf8d                	beqz	a5,800033fc <namex+0x130>
  while(*path != '/' && *path != 0)
    800033c4:	0004c783          	lbu	a5,0(s1)
    800033c8:	fd178713          	addi	a4,a5,-47
    800033cc:	cb19                	beqz	a4,800033e2 <namex+0x116>
    800033ce:	cb91                	beqz	a5,800033e2 <namex+0x116>
    800033d0:	8926                	mv	s2,s1
    path++;
    800033d2:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    800033d4:	00094783          	lbu	a5,0(s2)
    800033d8:	fd178713          	addi	a4,a5,-47
    800033dc:	df35                	beqz	a4,80003358 <namex+0x8c>
    800033de:	fbf5                	bnez	a5,800033d2 <namex+0x106>
    800033e0:	bfa5                	j	80003358 <namex+0x8c>
    800033e2:	8926                	mv	s2,s1
  len = path - s;
    800033e4:	4d01                	li	s10,0
    800033e6:	4601                	li	a2,0
    memmove(name, s, len);
    800033e8:	2601                	sext.w	a2,a2
    800033ea:	85a6                	mv	a1,s1
    800033ec:	8556                	mv	a0,s5
    800033ee:	dd1fc0ef          	jal	800001be <memmove>
    name[len] = 0;
    800033f2:	9d56                	add	s10,s10,s5
    800033f4:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffd2208>
    800033f8:	84ca                	mv	s1,s2
    800033fa:	bf9d                	j	80003370 <namex+0xa4>
  if(nameiparent){
    800033fc:	f20b06e3          	beqz	s6,80003328 <namex+0x5c>
    iput(ip);
    80003400:	8552                	mv	a0,s4
    80003402:	a07ff0ef          	jal	80002e08 <iput>
    return 0;
    80003406:	4a01                	li	s4,0
    80003408:	b705                	j	80003328 <namex+0x5c>

000000008000340a <dirlink>:
{
    8000340a:	715d                	addi	sp,sp,-80
    8000340c:	e486                	sd	ra,72(sp)
    8000340e:	e0a2                	sd	s0,64(sp)
    80003410:	f84a                	sd	s2,48(sp)
    80003412:	ec56                	sd	s5,24(sp)
    80003414:	e85a                	sd	s6,16(sp)
    80003416:	0880                	addi	s0,sp,80
    80003418:	892a                	mv	s2,a0
    8000341a:	8aae                	mv	s5,a1
    8000341c:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000341e:	4601                	li	a2,0
    80003420:	e01ff0ef          	jal	80003220 <dirlookup>
    80003424:	ed1d                	bnez	a0,80003462 <dirlink+0x58>
    80003426:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003428:	04c92483          	lw	s1,76(s2)
    8000342c:	c4b9                	beqz	s1,8000347a <dirlink+0x70>
    8000342e:	f44e                	sd	s3,40(sp)
    80003430:	f052                	sd	s4,32(sp)
    80003432:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003434:	fb040a13          	addi	s4,s0,-80
    80003438:	49c1                	li	s3,16
    8000343a:	874e                	mv	a4,s3
    8000343c:	86a6                	mv	a3,s1
    8000343e:	8652                	mv	a2,s4
    80003440:	4581                	li	a1,0
    80003442:	854a                	mv	a0,s2
    80003444:	bd5ff0ef          	jal	80003018 <readi>
    80003448:	03351163          	bne	a0,s3,8000346a <dirlink+0x60>
    if(de.inum == 0)
    8000344c:	fb045783          	lhu	a5,-80(s0)
    80003450:	c39d                	beqz	a5,80003476 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003452:	24c1                	addiw	s1,s1,16
    80003454:	04c92783          	lw	a5,76(s2)
    80003458:	fef4e1e3          	bltu	s1,a5,8000343a <dirlink+0x30>
    8000345c:	79a2                	ld	s3,40(sp)
    8000345e:	7a02                	ld	s4,32(sp)
    80003460:	a829                	j	8000347a <dirlink+0x70>
    iput(ip);
    80003462:	9a7ff0ef          	jal	80002e08 <iput>
    return -1;
    80003466:	557d                	li	a0,-1
    80003468:	a83d                	j	800034a6 <dirlink+0x9c>
      panic("dirlink read");
    8000346a:	00004517          	auipc	a0,0x4
    8000346e:	07650513          	addi	a0,a0,118 # 800074e0 <etext+0x4e0>
    80003472:	7f4020ef          	jal	80005c66 <panic>
    80003476:	79a2                	ld	s3,40(sp)
    80003478:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    8000347a:	4639                	li	a2,14
    8000347c:	85d6                	mv	a1,s5
    8000347e:	fb240513          	addi	a0,s0,-78
    80003482:	debfc0ef          	jal	8000026c <strncpy>
  de.inum = inum;
    80003486:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000348a:	4741                	li	a4,16
    8000348c:	86a6                	mv	a3,s1
    8000348e:	fb040613          	addi	a2,s0,-80
    80003492:	4581                	li	a1,0
    80003494:	854a                	mv	a0,s2
    80003496:	c75ff0ef          	jal	8000310a <writei>
    8000349a:	1541                	addi	a0,a0,-16
    8000349c:	00a03533          	snez	a0,a0
    800034a0:	40a0053b          	negw	a0,a0
    800034a4:	74e2                	ld	s1,56(sp)
}
    800034a6:	60a6                	ld	ra,72(sp)
    800034a8:	6406                	ld	s0,64(sp)
    800034aa:	7942                	ld	s2,48(sp)
    800034ac:	6ae2                	ld	s5,24(sp)
    800034ae:	6b42                	ld	s6,16(sp)
    800034b0:	6161                	addi	sp,sp,80
    800034b2:	8082                	ret

00000000800034b4 <namei>:

struct inode*
namei(char *path)
{
    800034b4:	1101                	addi	sp,sp,-32
    800034b6:	ec06                	sd	ra,24(sp)
    800034b8:	e822                	sd	s0,16(sp)
    800034ba:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800034bc:	fe040613          	addi	a2,s0,-32
    800034c0:	4581                	li	a1,0
    800034c2:	e0bff0ef          	jal	800032cc <namex>
}
    800034c6:	60e2                	ld	ra,24(sp)
    800034c8:	6442                	ld	s0,16(sp)
    800034ca:	6105                	addi	sp,sp,32
    800034cc:	8082                	ret

00000000800034ce <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800034ce:	1141                	addi	sp,sp,-16
    800034d0:	e406                	sd	ra,8(sp)
    800034d2:	e022                	sd	s0,0(sp)
    800034d4:	0800                	addi	s0,sp,16
    800034d6:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800034d8:	4585                	li	a1,1
    800034da:	df3ff0ef          	jal	800032cc <namex>
}
    800034de:	60a2                	ld	ra,8(sp)
    800034e0:	6402                	ld	s0,0(sp)
    800034e2:	0141                	addi	sp,sp,16
    800034e4:	8082                	ret

00000000800034e6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800034e6:	1101                	addi	sp,sp,-32
    800034e8:	ec06                	sd	ra,24(sp)
    800034ea:	e822                	sd	s0,16(sp)
    800034ec:	e426                	sd	s1,8(sp)
    800034ee:	e04a                	sd	s2,0(sp)
    800034f0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800034f2:	00020917          	auipc	s2,0x20
    800034f6:	5ee90913          	addi	s2,s2,1518 # 80023ae0 <log>
    800034fa:	01892583          	lw	a1,24(s2)
    800034fe:	02492503          	lw	a0,36(s2)
    80003502:	8ecff0ef          	jal	800025ee <bread>
    80003506:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003508:	02892603          	lw	a2,40(s2)
    8000350c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000350e:	00c05f63          	blez	a2,8000352c <write_head+0x46>
    80003512:	00020717          	auipc	a4,0x20
    80003516:	5fa70713          	addi	a4,a4,1530 # 80023b0c <log+0x2c>
    8000351a:	87aa                	mv	a5,a0
    8000351c:	060a                	slli	a2,a2,0x2
    8000351e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80003520:	4314                	lw	a3,0(a4)
    80003522:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003524:	0711                	addi	a4,a4,4
    80003526:	0791                	addi	a5,a5,4
    80003528:	fec79ce3          	bne	a5,a2,80003520 <write_head+0x3a>
  }
  bwrite(buf);
    8000352c:	8526                	mv	a0,s1
    8000352e:	996ff0ef          	jal	800026c4 <bwrite>
  brelse(buf);
    80003532:	8526                	mv	a0,s1
    80003534:	9c2ff0ef          	jal	800026f6 <brelse>
}
    80003538:	60e2                	ld	ra,24(sp)
    8000353a:	6442                	ld	s0,16(sp)
    8000353c:	64a2                	ld	s1,8(sp)
    8000353e:	6902                	ld	s2,0(sp)
    80003540:	6105                	addi	sp,sp,32
    80003542:	8082                	ret

0000000080003544 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003544:	00020797          	auipc	a5,0x20
    80003548:	5c47a783          	lw	a5,1476(a5) # 80023b08 <log+0x28>
    8000354c:	0cf05163          	blez	a5,8000360e <install_trans+0xca>
{
    80003550:	715d                	addi	sp,sp,-80
    80003552:	e486                	sd	ra,72(sp)
    80003554:	e0a2                	sd	s0,64(sp)
    80003556:	fc26                	sd	s1,56(sp)
    80003558:	f84a                	sd	s2,48(sp)
    8000355a:	f44e                	sd	s3,40(sp)
    8000355c:	f052                	sd	s4,32(sp)
    8000355e:	ec56                	sd	s5,24(sp)
    80003560:	e85a                	sd	s6,16(sp)
    80003562:	e45e                	sd	s7,8(sp)
    80003564:	e062                	sd	s8,0(sp)
    80003566:	0880                	addi	s0,sp,80
    80003568:	8b2a                	mv	s6,a0
    8000356a:	00020a97          	auipc	s5,0x20
    8000356e:	5a2a8a93          	addi	s5,s5,1442 # 80023b0c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003572:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003574:	00004c17          	auipc	s8,0x4
    80003578:	f7cc0c13          	addi	s8,s8,-132 # 800074f0 <etext+0x4f0>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000357c:	00020a17          	auipc	s4,0x20
    80003580:	564a0a13          	addi	s4,s4,1380 # 80023ae0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003584:	40000b93          	li	s7,1024
    80003588:	a025                	j	800035b0 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000358a:	000aa603          	lw	a2,0(s5)
    8000358e:	85ce                	mv	a1,s3
    80003590:	8562                	mv	a0,s8
    80003592:	3aa020ef          	jal	8000593c <printf>
    80003596:	a839                	j	800035b4 <install_trans+0x70>
    brelse(lbuf);
    80003598:	854a                	mv	a0,s2
    8000359a:	95cff0ef          	jal	800026f6 <brelse>
    brelse(dbuf);
    8000359e:	8526                	mv	a0,s1
    800035a0:	956ff0ef          	jal	800026f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035a4:	2985                	addiw	s3,s3,1
    800035a6:	0a91                	addi	s5,s5,4
    800035a8:	028a2783          	lw	a5,40(s4)
    800035ac:	04f9d563          	bge	s3,a5,800035f6 <install_trans+0xb2>
    if(recovering) {
    800035b0:	fc0b1de3          	bnez	s6,8000358a <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035b4:	018a2583          	lw	a1,24(s4)
    800035b8:	013585bb          	addw	a1,a1,s3
    800035bc:	2585                	addiw	a1,a1,1
    800035be:	024a2503          	lw	a0,36(s4)
    800035c2:	82cff0ef          	jal	800025ee <bread>
    800035c6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800035c8:	000aa583          	lw	a1,0(s5)
    800035cc:	024a2503          	lw	a0,36(s4)
    800035d0:	81eff0ef          	jal	800025ee <bread>
    800035d4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035d6:	865e                	mv	a2,s7
    800035d8:	05890593          	addi	a1,s2,88
    800035dc:	05850513          	addi	a0,a0,88
    800035e0:	bdffc0ef          	jal	800001be <memmove>
    bwrite(dbuf);  // write dst to disk
    800035e4:	8526                	mv	a0,s1
    800035e6:	8deff0ef          	jal	800026c4 <bwrite>
    if(recovering == 0)
    800035ea:	fa0b17e3          	bnez	s6,80003598 <install_trans+0x54>
      bunpin(dbuf);
    800035ee:	8526                	mv	a0,s1
    800035f0:	9beff0ef          	jal	800027ae <bunpin>
    800035f4:	b755                	j	80003598 <install_trans+0x54>
}
    800035f6:	60a6                	ld	ra,72(sp)
    800035f8:	6406                	ld	s0,64(sp)
    800035fa:	74e2                	ld	s1,56(sp)
    800035fc:	7942                	ld	s2,48(sp)
    800035fe:	79a2                	ld	s3,40(sp)
    80003600:	7a02                	ld	s4,32(sp)
    80003602:	6ae2                	ld	s5,24(sp)
    80003604:	6b42                	ld	s6,16(sp)
    80003606:	6ba2                	ld	s7,8(sp)
    80003608:	6c02                	ld	s8,0(sp)
    8000360a:	6161                	addi	sp,sp,80
    8000360c:	8082                	ret
    8000360e:	8082                	ret

0000000080003610 <initlog>:
{
    80003610:	7179                	addi	sp,sp,-48
    80003612:	f406                	sd	ra,40(sp)
    80003614:	f022                	sd	s0,32(sp)
    80003616:	ec26                	sd	s1,24(sp)
    80003618:	e84a                	sd	s2,16(sp)
    8000361a:	e44e                	sd	s3,8(sp)
    8000361c:	1800                	addi	s0,sp,48
    8000361e:	84aa                	mv	s1,a0
    80003620:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003622:	00020917          	auipc	s2,0x20
    80003626:	4be90913          	addi	s2,s2,1214 # 80023ae0 <log>
    8000362a:	00004597          	auipc	a1,0x4
    8000362e:	ee658593          	addi	a1,a1,-282 # 80007510 <etext+0x510>
    80003632:	854a                	mv	a0,s2
    80003634:	06b020ef          	jal	80005e9e <initlock>
  log.start = sb->logstart;
    80003638:	0149a583          	lw	a1,20(s3)
    8000363c:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003640:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003644:	8526                	mv	a0,s1
    80003646:	fa9fe0ef          	jal	800025ee <bread>
  log.lh.n = lh->n;
    8000364a:	4d30                	lw	a2,88(a0)
    8000364c:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003650:	00c05f63          	blez	a2,8000366e <initlog+0x5e>
    80003654:	87aa                	mv	a5,a0
    80003656:	00020717          	auipc	a4,0x20
    8000365a:	4b670713          	addi	a4,a4,1206 # 80023b0c <log+0x2c>
    8000365e:	060a                	slli	a2,a2,0x2
    80003660:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003662:	4ff4                	lw	a3,92(a5)
    80003664:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003666:	0791                	addi	a5,a5,4
    80003668:	0711                	addi	a4,a4,4
    8000366a:	fec79ce3          	bne	a5,a2,80003662 <initlog+0x52>
  brelse(buf);
    8000366e:	888ff0ef          	jal	800026f6 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003672:	4505                	li	a0,1
    80003674:	ed1ff0ef          	jal	80003544 <install_trans>
  log.lh.n = 0;
    80003678:	00020797          	auipc	a5,0x20
    8000367c:	4807a823          	sw	zero,1168(a5) # 80023b08 <log+0x28>
  write_head(); // clear the log
    80003680:	e67ff0ef          	jal	800034e6 <write_head>
}
    80003684:	70a2                	ld	ra,40(sp)
    80003686:	7402                	ld	s0,32(sp)
    80003688:	64e2                	ld	s1,24(sp)
    8000368a:	6942                	ld	s2,16(sp)
    8000368c:	69a2                	ld	s3,8(sp)
    8000368e:	6145                	addi	sp,sp,48
    80003690:	8082                	ret

0000000080003692 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003692:	1101                	addi	sp,sp,-32
    80003694:	ec06                	sd	ra,24(sp)
    80003696:	e822                	sd	s0,16(sp)
    80003698:	e426                	sd	s1,8(sp)
    8000369a:	e04a                	sd	s2,0(sp)
    8000369c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000369e:	00020517          	auipc	a0,0x20
    800036a2:	44250513          	addi	a0,a0,1090 # 80023ae0 <log>
    800036a6:	083020ef          	jal	80005f28 <acquire>
  while(1){
    if(log.committing){
    800036aa:	00020497          	auipc	s1,0x20
    800036ae:	43648493          	addi	s1,s1,1078 # 80023ae0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800036b2:	4979                	li	s2,30
    800036b4:	a029                	j	800036be <begin_op+0x2c>
      sleep(&log, &log.lock);
    800036b6:	85a6                	mv	a1,s1
    800036b8:	8526                	mv	a0,s1
    800036ba:	87cfe0ef          	jal	80001736 <sleep>
    if(log.committing){
    800036be:	509c                	lw	a5,32(s1)
    800036c0:	fbfd                	bnez	a5,800036b6 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800036c2:	4cd8                	lw	a4,28(s1)
    800036c4:	2705                	addiw	a4,a4,1
    800036c6:	0027179b          	slliw	a5,a4,0x2
    800036ca:	9fb9                	addw	a5,a5,a4
    800036cc:	0017979b          	slliw	a5,a5,0x1
    800036d0:	5494                	lw	a3,40(s1)
    800036d2:	9fb5                	addw	a5,a5,a3
    800036d4:	00f95763          	bge	s2,a5,800036e2 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800036d8:	85a6                	mv	a1,s1
    800036da:	8526                	mv	a0,s1
    800036dc:	85afe0ef          	jal	80001736 <sleep>
    800036e0:	bff9                	j	800036be <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800036e2:	00020797          	auipc	a5,0x20
    800036e6:	40e7ad23          	sw	a4,1050(a5) # 80023afc <log+0x1c>
      release(&log.lock);
    800036ea:	00020517          	auipc	a0,0x20
    800036ee:	3f650513          	addi	a0,a0,1014 # 80023ae0 <log>
    800036f2:	0cb020ef          	jal	80005fbc <release>
      break;
    }
  }
}
    800036f6:	60e2                	ld	ra,24(sp)
    800036f8:	6442                	ld	s0,16(sp)
    800036fa:	64a2                	ld	s1,8(sp)
    800036fc:	6902                	ld	s2,0(sp)
    800036fe:	6105                	addi	sp,sp,32
    80003700:	8082                	ret

0000000080003702 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003702:	7139                	addi	sp,sp,-64
    80003704:	fc06                	sd	ra,56(sp)
    80003706:	f822                	sd	s0,48(sp)
    80003708:	f426                	sd	s1,40(sp)
    8000370a:	f04a                	sd	s2,32(sp)
    8000370c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000370e:	00020497          	auipc	s1,0x20
    80003712:	3d248493          	addi	s1,s1,978 # 80023ae0 <log>
    80003716:	8526                	mv	a0,s1
    80003718:	011020ef          	jal	80005f28 <acquire>
  log.outstanding -= 1;
    8000371c:	4cdc                	lw	a5,28(s1)
    8000371e:	37fd                	addiw	a5,a5,-1
    80003720:	893e                	mv	s2,a5
    80003722:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003724:	509c                	lw	a5,32(s1)
    80003726:	e7b1                	bnez	a5,80003772 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003728:	04091e63          	bnez	s2,80003784 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    8000372c:	00020497          	auipc	s1,0x20
    80003730:	3b448493          	addi	s1,s1,948 # 80023ae0 <log>
    80003734:	4785                	li	a5,1
    80003736:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003738:	8526                	mv	a0,s1
    8000373a:	083020ef          	jal	80005fbc <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000373e:	549c                	lw	a5,40(s1)
    80003740:	06f04463          	bgtz	a5,800037a8 <end_op+0xa6>
    acquire(&log.lock);
    80003744:	00020517          	auipc	a0,0x20
    80003748:	39c50513          	addi	a0,a0,924 # 80023ae0 <log>
    8000374c:	7dc020ef          	jal	80005f28 <acquire>
    log.committing = 0;
    80003750:	00020797          	auipc	a5,0x20
    80003754:	3a07a823          	sw	zero,944(a5) # 80023b00 <log+0x20>
    wakeup(&log);
    80003758:	00020517          	auipc	a0,0x20
    8000375c:	38850513          	addi	a0,a0,904 # 80023ae0 <log>
    80003760:	822fe0ef          	jal	80001782 <wakeup>
    release(&log.lock);
    80003764:	00020517          	auipc	a0,0x20
    80003768:	37c50513          	addi	a0,a0,892 # 80023ae0 <log>
    8000376c:	051020ef          	jal	80005fbc <release>
}
    80003770:	a035                	j	8000379c <end_op+0x9a>
    80003772:	ec4e                	sd	s3,24(sp)
    80003774:	e852                	sd	s4,16(sp)
    80003776:	e456                	sd	s5,8(sp)
    panic("log.committing");
    80003778:	00004517          	auipc	a0,0x4
    8000377c:	da050513          	addi	a0,a0,-608 # 80007518 <etext+0x518>
    80003780:	4e6020ef          	jal	80005c66 <panic>
    wakeup(&log);
    80003784:	00020517          	auipc	a0,0x20
    80003788:	35c50513          	addi	a0,a0,860 # 80023ae0 <log>
    8000378c:	ff7fd0ef          	jal	80001782 <wakeup>
  release(&log.lock);
    80003790:	00020517          	auipc	a0,0x20
    80003794:	35050513          	addi	a0,a0,848 # 80023ae0 <log>
    80003798:	025020ef          	jal	80005fbc <release>
}
    8000379c:	70e2                	ld	ra,56(sp)
    8000379e:	7442                	ld	s0,48(sp)
    800037a0:	74a2                	ld	s1,40(sp)
    800037a2:	7902                	ld	s2,32(sp)
    800037a4:	6121                	addi	sp,sp,64
    800037a6:	8082                	ret
    800037a8:	ec4e                	sd	s3,24(sp)
    800037aa:	e852                	sd	s4,16(sp)
    800037ac:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800037ae:	00020a97          	auipc	s5,0x20
    800037b2:	35ea8a93          	addi	s5,s5,862 # 80023b0c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800037b6:	00020a17          	auipc	s4,0x20
    800037ba:	32aa0a13          	addi	s4,s4,810 # 80023ae0 <log>
    800037be:	018a2583          	lw	a1,24(s4)
    800037c2:	012585bb          	addw	a1,a1,s2
    800037c6:	2585                	addiw	a1,a1,1
    800037c8:	024a2503          	lw	a0,36(s4)
    800037cc:	e23fe0ef          	jal	800025ee <bread>
    800037d0:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800037d2:	000aa583          	lw	a1,0(s5)
    800037d6:	024a2503          	lw	a0,36(s4)
    800037da:	e15fe0ef          	jal	800025ee <bread>
    800037de:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037e0:	40000613          	li	a2,1024
    800037e4:	05850593          	addi	a1,a0,88
    800037e8:	05848513          	addi	a0,s1,88
    800037ec:	9d3fc0ef          	jal	800001be <memmove>
    bwrite(to);  // write the log
    800037f0:	8526                	mv	a0,s1
    800037f2:	ed3fe0ef          	jal	800026c4 <bwrite>
    brelse(from);
    800037f6:	854e                	mv	a0,s3
    800037f8:	efffe0ef          	jal	800026f6 <brelse>
    brelse(to);
    800037fc:	8526                	mv	a0,s1
    800037fe:	ef9fe0ef          	jal	800026f6 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003802:	2905                	addiw	s2,s2,1
    80003804:	0a91                	addi	s5,s5,4
    80003806:	028a2783          	lw	a5,40(s4)
    8000380a:	faf94ae3          	blt	s2,a5,800037be <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000380e:	cd9ff0ef          	jal	800034e6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003812:	4501                	li	a0,0
    80003814:	d31ff0ef          	jal	80003544 <install_trans>
    log.lh.n = 0;
    80003818:	00020797          	auipc	a5,0x20
    8000381c:	2e07a823          	sw	zero,752(a5) # 80023b08 <log+0x28>
    write_head();    // Erase the transaction from the log
    80003820:	cc7ff0ef          	jal	800034e6 <write_head>
    80003824:	69e2                	ld	s3,24(sp)
    80003826:	6a42                	ld	s4,16(sp)
    80003828:	6aa2                	ld	s5,8(sp)
    8000382a:	bf29                	j	80003744 <end_op+0x42>

000000008000382c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000382c:	1101                	addi	sp,sp,-32
    8000382e:	ec06                	sd	ra,24(sp)
    80003830:	e822                	sd	s0,16(sp)
    80003832:	e426                	sd	s1,8(sp)
    80003834:	1000                	addi	s0,sp,32
    80003836:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003838:	00020517          	auipc	a0,0x20
    8000383c:	2a850513          	addi	a0,a0,680 # 80023ae0 <log>
    80003840:	6e8020ef          	jal	80005f28 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003844:	00020617          	auipc	a2,0x20
    80003848:	2c462603          	lw	a2,708(a2) # 80023b08 <log+0x28>
    8000384c:	47f5                	li	a5,29
    8000384e:	04c7cd63          	blt	a5,a2,800038a8 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003852:	00020797          	auipc	a5,0x20
    80003856:	2aa7a783          	lw	a5,682(a5) # 80023afc <log+0x1c>
    8000385a:	04f05d63          	blez	a5,800038b4 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    8000385e:	4781                	li	a5,0
    80003860:	06c05063          	blez	a2,800038c0 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003864:	44cc                	lw	a1,12(s1)
    80003866:	00020717          	auipc	a4,0x20
    8000386a:	2a670713          	addi	a4,a4,678 # 80023b0c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    8000386e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003870:	4314                	lw	a3,0(a4)
    80003872:	04b68763          	beq	a3,a1,800038c0 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003876:	2785                	addiw	a5,a5,1
    80003878:	0711                	addi	a4,a4,4
    8000387a:	fef61be3          	bne	a2,a5,80003870 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000387e:	060a                	slli	a2,a2,0x2
    80003880:	02060613          	addi	a2,a2,32
    80003884:	00020797          	auipc	a5,0x20
    80003888:	25c78793          	addi	a5,a5,604 # 80023ae0 <log>
    8000388c:	97b2                	add	a5,a5,a2
    8000388e:	44d8                	lw	a4,12(s1)
    80003890:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003892:	8526                	mv	a0,s1
    80003894:	ee7fe0ef          	jal	8000277a <bpin>
    log.lh.n++;
    80003898:	00020717          	auipc	a4,0x20
    8000389c:	24870713          	addi	a4,a4,584 # 80023ae0 <log>
    800038a0:	571c                	lw	a5,40(a4)
    800038a2:	2785                	addiw	a5,a5,1
    800038a4:	d71c                	sw	a5,40(a4)
    800038a6:	a815                	j	800038da <log_write+0xae>
    panic("too big a transaction");
    800038a8:	00004517          	auipc	a0,0x4
    800038ac:	c8050513          	addi	a0,a0,-896 # 80007528 <etext+0x528>
    800038b0:	3b6020ef          	jal	80005c66 <panic>
    panic("log_write outside of trans");
    800038b4:	00004517          	auipc	a0,0x4
    800038b8:	c8c50513          	addi	a0,a0,-884 # 80007540 <etext+0x540>
    800038bc:	3aa020ef          	jal	80005c66 <panic>
  log.lh.block[i] = b->blockno;
    800038c0:	00279693          	slli	a3,a5,0x2
    800038c4:	02068693          	addi	a3,a3,32
    800038c8:	00020717          	auipc	a4,0x20
    800038cc:	21870713          	addi	a4,a4,536 # 80023ae0 <log>
    800038d0:	9736                	add	a4,a4,a3
    800038d2:	44d4                	lw	a3,12(s1)
    800038d4:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038d6:	faf60ee3          	beq	a2,a5,80003892 <log_write+0x66>
  }
  release(&log.lock);
    800038da:	00020517          	auipc	a0,0x20
    800038de:	20650513          	addi	a0,a0,518 # 80023ae0 <log>
    800038e2:	6da020ef          	jal	80005fbc <release>
}
    800038e6:	60e2                	ld	ra,24(sp)
    800038e8:	6442                	ld	s0,16(sp)
    800038ea:	64a2                	ld	s1,8(sp)
    800038ec:	6105                	addi	sp,sp,32
    800038ee:	8082                	ret

00000000800038f0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038f0:	1101                	addi	sp,sp,-32
    800038f2:	ec06                	sd	ra,24(sp)
    800038f4:	e822                	sd	s0,16(sp)
    800038f6:	e426                	sd	s1,8(sp)
    800038f8:	e04a                	sd	s2,0(sp)
    800038fa:	1000                	addi	s0,sp,32
    800038fc:	84aa                	mv	s1,a0
    800038fe:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003900:	00004597          	auipc	a1,0x4
    80003904:	c6058593          	addi	a1,a1,-928 # 80007560 <etext+0x560>
    80003908:	0521                	addi	a0,a0,8
    8000390a:	594020ef          	jal	80005e9e <initlock>
  lk->name = name;
    8000390e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003912:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003916:	0204a423          	sw	zero,40(s1)
}
    8000391a:	60e2                	ld	ra,24(sp)
    8000391c:	6442                	ld	s0,16(sp)
    8000391e:	64a2                	ld	s1,8(sp)
    80003920:	6902                	ld	s2,0(sp)
    80003922:	6105                	addi	sp,sp,32
    80003924:	8082                	ret

0000000080003926 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003926:	1101                	addi	sp,sp,-32
    80003928:	ec06                	sd	ra,24(sp)
    8000392a:	e822                	sd	s0,16(sp)
    8000392c:	e426                	sd	s1,8(sp)
    8000392e:	e04a                	sd	s2,0(sp)
    80003930:	1000                	addi	s0,sp,32
    80003932:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003934:	00850913          	addi	s2,a0,8
    80003938:	854a                	mv	a0,s2
    8000393a:	5ee020ef          	jal	80005f28 <acquire>
  while (lk->locked) {
    8000393e:	409c                	lw	a5,0(s1)
    80003940:	c799                	beqz	a5,8000394e <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003942:	85ca                	mv	a1,s2
    80003944:	8526                	mv	a0,s1
    80003946:	df1fd0ef          	jal	80001736 <sleep>
  while (lk->locked) {
    8000394a:	409c                	lw	a5,0(s1)
    8000394c:	fbfd                	bnez	a5,80003942 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000394e:	4785                	li	a5,1
    80003950:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003952:	f9efd0ef          	jal	800010f0 <myproc>
    80003956:	591c                	lw	a5,48(a0)
    80003958:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000395a:	854a                	mv	a0,s2
    8000395c:	660020ef          	jal	80005fbc <release>
}
    80003960:	60e2                	ld	ra,24(sp)
    80003962:	6442                	ld	s0,16(sp)
    80003964:	64a2                	ld	s1,8(sp)
    80003966:	6902                	ld	s2,0(sp)
    80003968:	6105                	addi	sp,sp,32
    8000396a:	8082                	ret

000000008000396c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000396c:	1101                	addi	sp,sp,-32
    8000396e:	ec06                	sd	ra,24(sp)
    80003970:	e822                	sd	s0,16(sp)
    80003972:	e426                	sd	s1,8(sp)
    80003974:	e04a                	sd	s2,0(sp)
    80003976:	1000                	addi	s0,sp,32
    80003978:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000397a:	00850913          	addi	s2,a0,8
    8000397e:	854a                	mv	a0,s2
    80003980:	5a8020ef          	jal	80005f28 <acquire>
  lk->locked = 0;
    80003984:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003988:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000398c:	8526                	mv	a0,s1
    8000398e:	df5fd0ef          	jal	80001782 <wakeup>
  release(&lk->lk);
    80003992:	854a                	mv	a0,s2
    80003994:	628020ef          	jal	80005fbc <release>
}
    80003998:	60e2                	ld	ra,24(sp)
    8000399a:	6442                	ld	s0,16(sp)
    8000399c:	64a2                	ld	s1,8(sp)
    8000399e:	6902                	ld	s2,0(sp)
    800039a0:	6105                	addi	sp,sp,32
    800039a2:	8082                	ret

00000000800039a4 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039a4:	7179                	addi	sp,sp,-48
    800039a6:	f406                	sd	ra,40(sp)
    800039a8:	f022                	sd	s0,32(sp)
    800039aa:	ec26                	sd	s1,24(sp)
    800039ac:	e84a                	sd	s2,16(sp)
    800039ae:	1800                	addi	s0,sp,48
    800039b0:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039b2:	00850913          	addi	s2,a0,8
    800039b6:	854a                	mv	a0,s2
    800039b8:	570020ef          	jal	80005f28 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039bc:	409c                	lw	a5,0(s1)
    800039be:	ef81                	bnez	a5,800039d6 <holdingsleep+0x32>
    800039c0:	4481                	li	s1,0
  release(&lk->lk);
    800039c2:	854a                	mv	a0,s2
    800039c4:	5f8020ef          	jal	80005fbc <release>
  return r;
}
    800039c8:	8526                	mv	a0,s1
    800039ca:	70a2                	ld	ra,40(sp)
    800039cc:	7402                	ld	s0,32(sp)
    800039ce:	64e2                	ld	s1,24(sp)
    800039d0:	6942                	ld	s2,16(sp)
    800039d2:	6145                	addi	sp,sp,48
    800039d4:	8082                	ret
    800039d6:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800039d8:	0284a983          	lw	s3,40(s1)
    800039dc:	f14fd0ef          	jal	800010f0 <myproc>
    800039e0:	5904                	lw	s1,48(a0)
    800039e2:	413484b3          	sub	s1,s1,s3
    800039e6:	0014b493          	seqz	s1,s1
    800039ea:	69a2                	ld	s3,8(sp)
    800039ec:	bfd9                	j	800039c2 <holdingsleep+0x1e>

00000000800039ee <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039ee:	1141                	addi	sp,sp,-16
    800039f0:	e406                	sd	ra,8(sp)
    800039f2:	e022                	sd	s0,0(sp)
    800039f4:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039f6:	00004597          	auipc	a1,0x4
    800039fa:	b7a58593          	addi	a1,a1,-1158 # 80007570 <etext+0x570>
    800039fe:	00020517          	auipc	a0,0x20
    80003a02:	22a50513          	addi	a0,a0,554 # 80023c28 <ftable>
    80003a06:	498020ef          	jal	80005e9e <initlock>
}
    80003a0a:	60a2                	ld	ra,8(sp)
    80003a0c:	6402                	ld	s0,0(sp)
    80003a0e:	0141                	addi	sp,sp,16
    80003a10:	8082                	ret

0000000080003a12 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a12:	1101                	addi	sp,sp,-32
    80003a14:	ec06                	sd	ra,24(sp)
    80003a16:	e822                	sd	s0,16(sp)
    80003a18:	e426                	sd	s1,8(sp)
    80003a1a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a1c:	00020517          	auipc	a0,0x20
    80003a20:	20c50513          	addi	a0,a0,524 # 80023c28 <ftable>
    80003a24:	504020ef          	jal	80005f28 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a28:	00020497          	auipc	s1,0x20
    80003a2c:	21848493          	addi	s1,s1,536 # 80023c40 <ftable+0x18>
    80003a30:	00021717          	auipc	a4,0x21
    80003a34:	1b070713          	addi	a4,a4,432 # 80024be0 <disk>
    if(f->ref == 0){
    80003a38:	40dc                	lw	a5,4(s1)
    80003a3a:	cf89                	beqz	a5,80003a54 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a3c:	02848493          	addi	s1,s1,40
    80003a40:	fee49ce3          	bne	s1,a4,80003a38 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a44:	00020517          	auipc	a0,0x20
    80003a48:	1e450513          	addi	a0,a0,484 # 80023c28 <ftable>
    80003a4c:	570020ef          	jal	80005fbc <release>
  return 0;
    80003a50:	4481                	li	s1,0
    80003a52:	a809                	j	80003a64 <filealloc+0x52>
      f->ref = 1;
    80003a54:	4785                	li	a5,1
    80003a56:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a58:	00020517          	auipc	a0,0x20
    80003a5c:	1d050513          	addi	a0,a0,464 # 80023c28 <ftable>
    80003a60:	55c020ef          	jal	80005fbc <release>
}
    80003a64:	8526                	mv	a0,s1
    80003a66:	60e2                	ld	ra,24(sp)
    80003a68:	6442                	ld	s0,16(sp)
    80003a6a:	64a2                	ld	s1,8(sp)
    80003a6c:	6105                	addi	sp,sp,32
    80003a6e:	8082                	ret

0000000080003a70 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a70:	1101                	addi	sp,sp,-32
    80003a72:	ec06                	sd	ra,24(sp)
    80003a74:	e822                	sd	s0,16(sp)
    80003a76:	e426                	sd	s1,8(sp)
    80003a78:	1000                	addi	s0,sp,32
    80003a7a:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a7c:	00020517          	auipc	a0,0x20
    80003a80:	1ac50513          	addi	a0,a0,428 # 80023c28 <ftable>
    80003a84:	4a4020ef          	jal	80005f28 <acquire>
  if(f->ref < 1)
    80003a88:	40dc                	lw	a5,4(s1)
    80003a8a:	02f05063          	blez	a5,80003aaa <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003a8e:	2785                	addiw	a5,a5,1
    80003a90:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a92:	00020517          	auipc	a0,0x20
    80003a96:	19650513          	addi	a0,a0,406 # 80023c28 <ftable>
    80003a9a:	522020ef          	jal	80005fbc <release>
  return f;
}
    80003a9e:	8526                	mv	a0,s1
    80003aa0:	60e2                	ld	ra,24(sp)
    80003aa2:	6442                	ld	s0,16(sp)
    80003aa4:	64a2                	ld	s1,8(sp)
    80003aa6:	6105                	addi	sp,sp,32
    80003aa8:	8082                	ret
    panic("filedup");
    80003aaa:	00004517          	auipc	a0,0x4
    80003aae:	ace50513          	addi	a0,a0,-1330 # 80007578 <etext+0x578>
    80003ab2:	1b4020ef          	jal	80005c66 <panic>

0000000080003ab6 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003ab6:	7139                	addi	sp,sp,-64
    80003ab8:	fc06                	sd	ra,56(sp)
    80003aba:	f822                	sd	s0,48(sp)
    80003abc:	f426                	sd	s1,40(sp)
    80003abe:	0080                	addi	s0,sp,64
    80003ac0:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003ac2:	00020517          	auipc	a0,0x20
    80003ac6:	16650513          	addi	a0,a0,358 # 80023c28 <ftable>
    80003aca:	45e020ef          	jal	80005f28 <acquire>
  if(f->ref < 1)
    80003ace:	40dc                	lw	a5,4(s1)
    80003ad0:	04f05a63          	blez	a5,80003b24 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003ad4:	37fd                	addiw	a5,a5,-1
    80003ad6:	c0dc                	sw	a5,4(s1)
    80003ad8:	06f04063          	bgtz	a5,80003b38 <fileclose+0x82>
    80003adc:	f04a                	sd	s2,32(sp)
    80003ade:	ec4e                	sd	s3,24(sp)
    80003ae0:	e852                	sd	s4,16(sp)
    80003ae2:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ae4:	0004a903          	lw	s2,0(s1)
    80003ae8:	0094c783          	lbu	a5,9(s1)
    80003aec:	89be                	mv	s3,a5
    80003aee:	689c                	ld	a5,16(s1)
    80003af0:	8a3e                	mv	s4,a5
    80003af2:	6c9c                	ld	a5,24(s1)
    80003af4:	8abe                	mv	s5,a5
  f->ref = 0;
    80003af6:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003afa:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003afe:	00020517          	auipc	a0,0x20
    80003b02:	12a50513          	addi	a0,a0,298 # 80023c28 <ftable>
    80003b06:	4b6020ef          	jal	80005fbc <release>

  if(ff.type == FD_PIPE){
    80003b0a:	4785                	li	a5,1
    80003b0c:	04f90163          	beq	s2,a5,80003b4e <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b10:	ffe9079b          	addiw	a5,s2,-2
    80003b14:	4705                	li	a4,1
    80003b16:	04f77563          	bgeu	a4,a5,80003b60 <fileclose+0xaa>
    80003b1a:	7902                	ld	s2,32(sp)
    80003b1c:	69e2                	ld	s3,24(sp)
    80003b1e:	6a42                	ld	s4,16(sp)
    80003b20:	6aa2                	ld	s5,8(sp)
    80003b22:	a00d                	j	80003b44 <fileclose+0x8e>
    80003b24:	f04a                	sd	s2,32(sp)
    80003b26:	ec4e                	sd	s3,24(sp)
    80003b28:	e852                	sd	s4,16(sp)
    80003b2a:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b2c:	00004517          	auipc	a0,0x4
    80003b30:	a5450513          	addi	a0,a0,-1452 # 80007580 <etext+0x580>
    80003b34:	132020ef          	jal	80005c66 <panic>
    release(&ftable.lock);
    80003b38:	00020517          	auipc	a0,0x20
    80003b3c:	0f050513          	addi	a0,a0,240 # 80023c28 <ftable>
    80003b40:	47c020ef          	jal	80005fbc <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b44:	70e2                	ld	ra,56(sp)
    80003b46:	7442                	ld	s0,48(sp)
    80003b48:	74a2                	ld	s1,40(sp)
    80003b4a:	6121                	addi	sp,sp,64
    80003b4c:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b4e:	85ce                	mv	a1,s3
    80003b50:	8552                	mv	a0,s4
    80003b52:	348000ef          	jal	80003e9a <pipeclose>
    80003b56:	7902                	ld	s2,32(sp)
    80003b58:	69e2                	ld	s3,24(sp)
    80003b5a:	6a42                	ld	s4,16(sp)
    80003b5c:	6aa2                	ld	s5,8(sp)
    80003b5e:	b7dd                	j	80003b44 <fileclose+0x8e>
    begin_op();
    80003b60:	b33ff0ef          	jal	80003692 <begin_op>
    iput(ff.ip);
    80003b64:	8556                	mv	a0,s5
    80003b66:	aa2ff0ef          	jal	80002e08 <iput>
    end_op();
    80003b6a:	b99ff0ef          	jal	80003702 <end_op>
    80003b6e:	7902                	ld	s2,32(sp)
    80003b70:	69e2                	ld	s3,24(sp)
    80003b72:	6a42                	ld	s4,16(sp)
    80003b74:	6aa2                	ld	s5,8(sp)
    80003b76:	b7f9                	j	80003b44 <fileclose+0x8e>

0000000080003b78 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b78:	715d                	addi	sp,sp,-80
    80003b7a:	e486                	sd	ra,72(sp)
    80003b7c:	e0a2                	sd	s0,64(sp)
    80003b7e:	fc26                	sd	s1,56(sp)
    80003b80:	f052                	sd	s4,32(sp)
    80003b82:	0880                	addi	s0,sp,80
    80003b84:	84aa                	mv	s1,a0
    80003b86:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80003b88:	d68fd0ef          	jal	800010f0 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b8c:	409c                	lw	a5,0(s1)
    80003b8e:	37f9                	addiw	a5,a5,-2
    80003b90:	4705                	li	a4,1
    80003b92:	04f76263          	bltu	a4,a5,80003bd6 <filestat+0x5e>
    80003b96:	f84a                	sd	s2,48(sp)
    80003b98:	f44e                	sd	s3,40(sp)
    80003b9a:	89aa                	mv	s3,a0
    ilock(f->ip);
    80003b9c:	6c88                	ld	a0,24(s1)
    80003b9e:	8e8ff0ef          	jal	80002c86 <ilock>
    stati(f->ip, &st);
    80003ba2:	fb840913          	addi	s2,s0,-72
    80003ba6:	85ca                	mv	a1,s2
    80003ba8:	6c88                	ld	a0,24(s1)
    80003baa:	c40ff0ef          	jal	80002fea <stati>
    iunlock(f->ip);
    80003bae:	6c88                	ld	a0,24(s1)
    80003bb0:	984ff0ef          	jal	80002d34 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bb4:	46e1                	li	a3,24
    80003bb6:	864a                	mv	a2,s2
    80003bb8:	85d2                	mv	a1,s4
    80003bba:	0509b503          	ld	a0,80(s3)
    80003bbe:	854fd0ef          	jal	80000c12 <copyout>
    80003bc2:	41f5551b          	sraiw	a0,a0,0x1f
    80003bc6:	7942                	ld	s2,48(sp)
    80003bc8:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003bca:	60a6                	ld	ra,72(sp)
    80003bcc:	6406                	ld	s0,64(sp)
    80003bce:	74e2                	ld	s1,56(sp)
    80003bd0:	7a02                	ld	s4,32(sp)
    80003bd2:	6161                	addi	sp,sp,80
    80003bd4:	8082                	ret
  return -1;
    80003bd6:	557d                	li	a0,-1
    80003bd8:	bfcd                	j	80003bca <filestat+0x52>

0000000080003bda <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003bda:	7179                	addi	sp,sp,-48
    80003bdc:	f406                	sd	ra,40(sp)
    80003bde:	f022                	sd	s0,32(sp)
    80003be0:	e84a                	sd	s2,16(sp)
    80003be2:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003be4:	00854783          	lbu	a5,8(a0)
    80003be8:	cfd1                	beqz	a5,80003c84 <fileread+0xaa>
    80003bea:	ec26                	sd	s1,24(sp)
    80003bec:	e44e                	sd	s3,8(sp)
    80003bee:	84aa                	mv	s1,a0
    80003bf0:	892e                	mv	s2,a1
    80003bf2:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80003bf4:	411c                	lw	a5,0(a0)
    80003bf6:	4705                	li	a4,1
    80003bf8:	04e78363          	beq	a5,a4,80003c3e <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003bfc:	470d                	li	a4,3
    80003bfe:	04e78763          	beq	a5,a4,80003c4c <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c02:	4709                	li	a4,2
    80003c04:	06e79a63          	bne	a5,a4,80003c78 <fileread+0x9e>
    ilock(f->ip);
    80003c08:	6d08                	ld	a0,24(a0)
    80003c0a:	87cff0ef          	jal	80002c86 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c0e:	874e                	mv	a4,s3
    80003c10:	5094                	lw	a3,32(s1)
    80003c12:	864a                	mv	a2,s2
    80003c14:	4585                	li	a1,1
    80003c16:	6c88                	ld	a0,24(s1)
    80003c18:	c00ff0ef          	jal	80003018 <readi>
    80003c1c:	892a                	mv	s2,a0
    80003c1e:	00a05563          	blez	a0,80003c28 <fileread+0x4e>
      f->off += r;
    80003c22:	509c                	lw	a5,32(s1)
    80003c24:	9fa9                	addw	a5,a5,a0
    80003c26:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c28:	6c88                	ld	a0,24(s1)
    80003c2a:	90aff0ef          	jal	80002d34 <iunlock>
    80003c2e:	64e2                	ld	s1,24(sp)
    80003c30:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c32:	854a                	mv	a0,s2
    80003c34:	70a2                	ld	ra,40(sp)
    80003c36:	7402                	ld	s0,32(sp)
    80003c38:	6942                	ld	s2,16(sp)
    80003c3a:	6145                	addi	sp,sp,48
    80003c3c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c3e:	6908                	ld	a0,16(a0)
    80003c40:	3b0000ef          	jal	80003ff0 <piperead>
    80003c44:	892a                	mv	s2,a0
    80003c46:	64e2                	ld	s1,24(sp)
    80003c48:	69a2                	ld	s3,8(sp)
    80003c4a:	b7e5                	j	80003c32 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c4c:	02451783          	lh	a5,36(a0)
    80003c50:	03079693          	slli	a3,a5,0x30
    80003c54:	92c1                	srli	a3,a3,0x30
    80003c56:	4725                	li	a4,9
    80003c58:	02d76963          	bltu	a4,a3,80003c8a <fileread+0xb0>
    80003c5c:	0792                	slli	a5,a5,0x4
    80003c5e:	00020717          	auipc	a4,0x20
    80003c62:	f2a70713          	addi	a4,a4,-214 # 80023b88 <devsw>
    80003c66:	97ba                	add	a5,a5,a4
    80003c68:	639c                	ld	a5,0(a5)
    80003c6a:	c78d                	beqz	a5,80003c94 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80003c6c:	4505                	li	a0,1
    80003c6e:	9782                	jalr	a5
    80003c70:	892a                	mv	s2,a0
    80003c72:	64e2                	ld	s1,24(sp)
    80003c74:	69a2                	ld	s3,8(sp)
    80003c76:	bf75                	j	80003c32 <fileread+0x58>
    panic("fileread");
    80003c78:	00004517          	auipc	a0,0x4
    80003c7c:	91850513          	addi	a0,a0,-1768 # 80007590 <etext+0x590>
    80003c80:	7e7010ef          	jal	80005c66 <panic>
    return -1;
    80003c84:	57fd                	li	a5,-1
    80003c86:	893e                	mv	s2,a5
    80003c88:	b76d                	j	80003c32 <fileread+0x58>
      return -1;
    80003c8a:	57fd                	li	a5,-1
    80003c8c:	893e                	mv	s2,a5
    80003c8e:	64e2                	ld	s1,24(sp)
    80003c90:	69a2                	ld	s3,8(sp)
    80003c92:	b745                	j	80003c32 <fileread+0x58>
    80003c94:	57fd                	li	a5,-1
    80003c96:	893e                	mv	s2,a5
    80003c98:	64e2                	ld	s1,24(sp)
    80003c9a:	69a2                	ld	s3,8(sp)
    80003c9c:	bf59                	j	80003c32 <fileread+0x58>

0000000080003c9e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003c9e:	00954783          	lbu	a5,9(a0)
    80003ca2:	10078f63          	beqz	a5,80003dc0 <filewrite+0x122>
{
    80003ca6:	711d                	addi	sp,sp,-96
    80003ca8:	ec86                	sd	ra,88(sp)
    80003caa:	e8a2                	sd	s0,80(sp)
    80003cac:	e0ca                	sd	s2,64(sp)
    80003cae:	f456                	sd	s5,40(sp)
    80003cb0:	f05a                	sd	s6,32(sp)
    80003cb2:	1080                	addi	s0,sp,96
    80003cb4:	892a                	mv	s2,a0
    80003cb6:	8b2e                	mv	s6,a1
    80003cb8:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003cba:	411c                	lw	a5,0(a0)
    80003cbc:	4705                	li	a4,1
    80003cbe:	02e78a63          	beq	a5,a4,80003cf2 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003cc2:	470d                	li	a4,3
    80003cc4:	02e78b63          	beq	a5,a4,80003cfa <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003cc8:	4709                	li	a4,2
    80003cca:	0ce79f63          	bne	a5,a4,80003da8 <filewrite+0x10a>
    80003cce:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003cd0:	0ac05a63          	blez	a2,80003d84 <filewrite+0xe6>
    80003cd4:	e4a6                	sd	s1,72(sp)
    80003cd6:	fc4e                	sd	s3,56(sp)
    80003cd8:	ec5e                	sd	s7,24(sp)
    80003cda:	e862                	sd	s8,16(sp)
    80003cdc:	e466                	sd	s9,8(sp)
    int i = 0;
    80003cde:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003ce0:	6b85                	lui	s7,0x1
    80003ce2:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003ce6:	6785                	lui	a5,0x1
    80003ce8:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80003cec:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003cee:	4c05                	li	s8,1
    80003cf0:	a8ad                	j	80003d6a <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003cf2:	6908                	ld	a0,16(a0)
    80003cf4:	204000ef          	jal	80003ef8 <pipewrite>
    80003cf8:	a04d                	j	80003d9a <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003cfa:	02451783          	lh	a5,36(a0)
    80003cfe:	03079693          	slli	a3,a5,0x30
    80003d02:	92c1                	srli	a3,a3,0x30
    80003d04:	4725                	li	a4,9
    80003d06:	0ad76f63          	bltu	a4,a3,80003dc4 <filewrite+0x126>
    80003d0a:	0792                	slli	a5,a5,0x4
    80003d0c:	00020717          	auipc	a4,0x20
    80003d10:	e7c70713          	addi	a4,a4,-388 # 80023b88 <devsw>
    80003d14:	97ba                	add	a5,a5,a4
    80003d16:	679c                	ld	a5,8(a5)
    80003d18:	cbc5                	beqz	a5,80003dc8 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80003d1a:	4505                	li	a0,1
    80003d1c:	9782                	jalr	a5
    80003d1e:	a8b5                	j	80003d9a <filewrite+0xfc>
      if(n1 > max)
    80003d20:	2981                	sext.w	s3,s3
      begin_op();
    80003d22:	971ff0ef          	jal	80003692 <begin_op>
      ilock(f->ip);
    80003d26:	01893503          	ld	a0,24(s2)
    80003d2a:	f5dfe0ef          	jal	80002c86 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d2e:	874e                	mv	a4,s3
    80003d30:	02092683          	lw	a3,32(s2)
    80003d34:	016a0633          	add	a2,s4,s6
    80003d38:	85e2                	mv	a1,s8
    80003d3a:	01893503          	ld	a0,24(s2)
    80003d3e:	bccff0ef          	jal	8000310a <writei>
    80003d42:	84aa                	mv	s1,a0
    80003d44:	00a05763          	blez	a0,80003d52 <filewrite+0xb4>
        f->off += r;
    80003d48:	02092783          	lw	a5,32(s2)
    80003d4c:	9fa9                	addw	a5,a5,a0
    80003d4e:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d52:	01893503          	ld	a0,24(s2)
    80003d56:	fdffe0ef          	jal	80002d34 <iunlock>
      end_op();
    80003d5a:	9a9ff0ef          	jal	80003702 <end_op>

      if(r != n1){
    80003d5e:	02999563          	bne	s3,s1,80003d88 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80003d62:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003d66:	015a5963          	bge	s4,s5,80003d78 <filewrite+0xda>
      int n1 = n - i;
    80003d6a:	414a87bb          	subw	a5,s5,s4
    80003d6e:	89be                	mv	s3,a5
      if(n1 > max)
    80003d70:	fafbd8e3          	bge	s7,a5,80003d20 <filewrite+0x82>
    80003d74:	89e6                	mv	s3,s9
    80003d76:	b76d                	j	80003d20 <filewrite+0x82>
    80003d78:	64a6                	ld	s1,72(sp)
    80003d7a:	79e2                	ld	s3,56(sp)
    80003d7c:	6be2                	ld	s7,24(sp)
    80003d7e:	6c42                	ld	s8,16(sp)
    80003d80:	6ca2                	ld	s9,8(sp)
    80003d82:	a801                	j	80003d92 <filewrite+0xf4>
    int i = 0;
    80003d84:	4a01                	li	s4,0
    80003d86:	a031                	j	80003d92 <filewrite+0xf4>
    80003d88:	64a6                	ld	s1,72(sp)
    80003d8a:	79e2                	ld	s3,56(sp)
    80003d8c:	6be2                	ld	s7,24(sp)
    80003d8e:	6c42                	ld	s8,16(sp)
    80003d90:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003d92:	034a9d63          	bne	s5,s4,80003dcc <filewrite+0x12e>
    80003d96:	8556                	mv	a0,s5
    80003d98:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003d9a:	60e6                	ld	ra,88(sp)
    80003d9c:	6446                	ld	s0,80(sp)
    80003d9e:	6906                	ld	s2,64(sp)
    80003da0:	7aa2                	ld	s5,40(sp)
    80003da2:	7b02                	ld	s6,32(sp)
    80003da4:	6125                	addi	sp,sp,96
    80003da6:	8082                	ret
    80003da8:	e4a6                	sd	s1,72(sp)
    80003daa:	fc4e                	sd	s3,56(sp)
    80003dac:	f852                	sd	s4,48(sp)
    80003dae:	ec5e                	sd	s7,24(sp)
    80003db0:	e862                	sd	s8,16(sp)
    80003db2:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003db4:	00003517          	auipc	a0,0x3
    80003db8:	7ec50513          	addi	a0,a0,2028 # 800075a0 <etext+0x5a0>
    80003dbc:	6ab010ef          	jal	80005c66 <panic>
    return -1;
    80003dc0:	557d                	li	a0,-1
}
    80003dc2:	8082                	ret
      return -1;
    80003dc4:	557d                	li	a0,-1
    80003dc6:	bfd1                	j	80003d9a <filewrite+0xfc>
    80003dc8:	557d                	li	a0,-1
    80003dca:	bfc1                	j	80003d9a <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80003dcc:	557d                	li	a0,-1
    80003dce:	7a42                	ld	s4,48(sp)
    80003dd0:	b7e9                	j	80003d9a <filewrite+0xfc>

0000000080003dd2 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dd2:	7179                	addi	sp,sp,-48
    80003dd4:	f406                	sd	ra,40(sp)
    80003dd6:	f022                	sd	s0,32(sp)
    80003dd8:	ec26                	sd	s1,24(sp)
    80003dda:	e052                	sd	s4,0(sp)
    80003ddc:	1800                	addi	s0,sp,48
    80003dde:	84aa                	mv	s1,a0
    80003de0:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003de2:	0005b023          	sd	zero,0(a1)
    80003de6:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003dea:	c29ff0ef          	jal	80003a12 <filealloc>
    80003dee:	e088                	sd	a0,0(s1)
    80003df0:	c549                	beqz	a0,80003e7a <pipealloc+0xa8>
    80003df2:	c21ff0ef          	jal	80003a12 <filealloc>
    80003df6:	00aa3023          	sd	a0,0(s4)
    80003dfa:	cd25                	beqz	a0,80003e72 <pipealloc+0xa0>
    80003dfc:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003dfe:	b06fc0ef          	jal	80000104 <kalloc>
    80003e02:	892a                	mv	s2,a0
    80003e04:	c12d                	beqz	a0,80003e66 <pipealloc+0x94>
    80003e06:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e08:	4985                	li	s3,1
    80003e0a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e0e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e12:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e16:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e1a:	00003597          	auipc	a1,0x3
    80003e1e:	79658593          	addi	a1,a1,1942 # 800075b0 <etext+0x5b0>
    80003e22:	07c020ef          	jal	80005e9e <initlock>
  (*f0)->type = FD_PIPE;
    80003e26:	609c                	ld	a5,0(s1)
    80003e28:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e2c:	609c                	ld	a5,0(s1)
    80003e2e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e32:	609c                	ld	a5,0(s1)
    80003e34:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e38:	609c                	ld	a5,0(s1)
    80003e3a:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e3e:	000a3783          	ld	a5,0(s4)
    80003e42:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e46:	000a3783          	ld	a5,0(s4)
    80003e4a:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e4e:	000a3783          	ld	a5,0(s4)
    80003e52:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e56:	000a3783          	ld	a5,0(s4)
    80003e5a:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e5e:	4501                	li	a0,0
    80003e60:	6942                	ld	s2,16(sp)
    80003e62:	69a2                	ld	s3,8(sp)
    80003e64:	a01d                	j	80003e8a <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e66:	6088                	ld	a0,0(s1)
    80003e68:	c119                	beqz	a0,80003e6e <pipealloc+0x9c>
    80003e6a:	6942                	ld	s2,16(sp)
    80003e6c:	a029                	j	80003e76 <pipealloc+0xa4>
    80003e6e:	6942                	ld	s2,16(sp)
    80003e70:	a029                	j	80003e7a <pipealloc+0xa8>
    80003e72:	6088                	ld	a0,0(s1)
    80003e74:	c10d                	beqz	a0,80003e96 <pipealloc+0xc4>
    fileclose(*f0);
    80003e76:	c41ff0ef          	jal	80003ab6 <fileclose>
  if(*f1)
    80003e7a:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003e7e:	557d                	li	a0,-1
  if(*f1)
    80003e80:	c789                	beqz	a5,80003e8a <pipealloc+0xb8>
    fileclose(*f1);
    80003e82:	853e                	mv	a0,a5
    80003e84:	c33ff0ef          	jal	80003ab6 <fileclose>
  return -1;
    80003e88:	557d                	li	a0,-1
}
    80003e8a:	70a2                	ld	ra,40(sp)
    80003e8c:	7402                	ld	s0,32(sp)
    80003e8e:	64e2                	ld	s1,24(sp)
    80003e90:	6a02                	ld	s4,0(sp)
    80003e92:	6145                	addi	sp,sp,48
    80003e94:	8082                	ret
  return -1;
    80003e96:	557d                	li	a0,-1
    80003e98:	bfcd                	j	80003e8a <pipealloc+0xb8>

0000000080003e9a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003e9a:	1101                	addi	sp,sp,-32
    80003e9c:	ec06                	sd	ra,24(sp)
    80003e9e:	e822                	sd	s0,16(sp)
    80003ea0:	e426                	sd	s1,8(sp)
    80003ea2:	e04a                	sd	s2,0(sp)
    80003ea4:	1000                	addi	s0,sp,32
    80003ea6:	84aa                	mv	s1,a0
    80003ea8:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003eaa:	07e020ef          	jal	80005f28 <acquire>
  if(writable){
    80003eae:	02090763          	beqz	s2,80003edc <pipeclose+0x42>
    pi->writeopen = 0;
    80003eb2:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003eb6:	21848513          	addi	a0,s1,536
    80003eba:	8c9fd0ef          	jal	80001782 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ebe:	2204a783          	lw	a5,544(s1)
    80003ec2:	e781                	bnez	a5,80003eca <pipeclose+0x30>
    80003ec4:	2244a783          	lw	a5,548(s1)
    80003ec8:	c38d                	beqz	a5,80003eea <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80003eca:	8526                	mv	a0,s1
    80003ecc:	0f0020ef          	jal	80005fbc <release>
}
    80003ed0:	60e2                	ld	ra,24(sp)
    80003ed2:	6442                	ld	s0,16(sp)
    80003ed4:	64a2                	ld	s1,8(sp)
    80003ed6:	6902                	ld	s2,0(sp)
    80003ed8:	6105                	addi	sp,sp,32
    80003eda:	8082                	ret
    pi->readopen = 0;
    80003edc:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003ee0:	21c48513          	addi	a0,s1,540
    80003ee4:	89ffd0ef          	jal	80001782 <wakeup>
    80003ee8:	bfd9                	j	80003ebe <pipeclose+0x24>
    release(&pi->lock);
    80003eea:	8526                	mv	a0,s1
    80003eec:	0d0020ef          	jal	80005fbc <release>
    kfree((char*)pi);
    80003ef0:	8526                	mv	a0,s1
    80003ef2:	92afc0ef          	jal	8000001c <kfree>
    80003ef6:	bfe9                	j	80003ed0 <pipeclose+0x36>

0000000080003ef8 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003ef8:	7159                	addi	sp,sp,-112
    80003efa:	f486                	sd	ra,104(sp)
    80003efc:	f0a2                	sd	s0,96(sp)
    80003efe:	eca6                	sd	s1,88(sp)
    80003f00:	e8ca                	sd	s2,80(sp)
    80003f02:	e4ce                	sd	s3,72(sp)
    80003f04:	e0d2                	sd	s4,64(sp)
    80003f06:	fc56                	sd	s5,56(sp)
    80003f08:	1880                	addi	s0,sp,112
    80003f0a:	84aa                	mv	s1,a0
    80003f0c:	8aae                	mv	s5,a1
    80003f0e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f10:	9e0fd0ef          	jal	800010f0 <myproc>
    80003f14:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f16:	8526                	mv	a0,s1
    80003f18:	010020ef          	jal	80005f28 <acquire>
  while(i < n){
    80003f1c:	0d405263          	blez	s4,80003fe0 <pipewrite+0xe8>
    80003f20:	f85a                	sd	s6,48(sp)
    80003f22:	f45e                	sd	s7,40(sp)
    80003f24:	f062                	sd	s8,32(sp)
    80003f26:	ec66                	sd	s9,24(sp)
    80003f28:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003f2a:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f2c:	f9f40c13          	addi	s8,s0,-97
    80003f30:	4b85                	li	s7,1
    80003f32:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f34:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f38:	21c48c93          	addi	s9,s1,540
    80003f3c:	a82d                	j	80003f76 <pipewrite+0x7e>
      release(&pi->lock);
    80003f3e:	8526                	mv	a0,s1
    80003f40:	07c020ef          	jal	80005fbc <release>
      return -1;
    80003f44:	597d                	li	s2,-1
    80003f46:	7b42                	ld	s6,48(sp)
    80003f48:	7ba2                	ld	s7,40(sp)
    80003f4a:	7c02                	ld	s8,32(sp)
    80003f4c:	6ce2                	ld	s9,24(sp)
    80003f4e:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f50:	854a                	mv	a0,s2
    80003f52:	70a6                	ld	ra,104(sp)
    80003f54:	7406                	ld	s0,96(sp)
    80003f56:	64e6                	ld	s1,88(sp)
    80003f58:	6946                	ld	s2,80(sp)
    80003f5a:	69a6                	ld	s3,72(sp)
    80003f5c:	6a06                	ld	s4,64(sp)
    80003f5e:	7ae2                	ld	s5,56(sp)
    80003f60:	6165                	addi	sp,sp,112
    80003f62:	8082                	ret
      wakeup(&pi->nread);
    80003f64:	856a                	mv	a0,s10
    80003f66:	81dfd0ef          	jal	80001782 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003f6a:	85a6                	mv	a1,s1
    80003f6c:	8566                	mv	a0,s9
    80003f6e:	fc8fd0ef          	jal	80001736 <sleep>
  while(i < n){
    80003f72:	05495a63          	bge	s2,s4,80003fc6 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003f76:	2204a783          	lw	a5,544(s1)
    80003f7a:	d3f1                	beqz	a5,80003f3e <pipewrite+0x46>
    80003f7c:	854e                	mv	a0,s3
    80003f7e:	a55fd0ef          	jal	800019d2 <killed>
    80003f82:	fd55                	bnez	a0,80003f3e <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003f84:	2184a783          	lw	a5,536(s1)
    80003f88:	21c4a703          	lw	a4,540(s1)
    80003f8c:	2007879b          	addiw	a5,a5,512
    80003f90:	fcf70ae3          	beq	a4,a5,80003f64 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f94:	86de                	mv	a3,s7
    80003f96:	01590633          	add	a2,s2,s5
    80003f9a:	85e2                	mv	a1,s8
    80003f9c:	0509b503          	ld	a0,80(s3)
    80003fa0:	d31fc0ef          	jal	80000cd0 <copyin>
    80003fa4:	05650063          	beq	a0,s6,80003fe4 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fa8:	21c4a783          	lw	a5,540(s1)
    80003fac:	0017871b          	addiw	a4,a5,1
    80003fb0:	20e4ae23          	sw	a4,540(s1)
    80003fb4:	1ff7f793          	andi	a5,a5,511
    80003fb8:	97a6                	add	a5,a5,s1
    80003fba:	f9f44703          	lbu	a4,-97(s0)
    80003fbe:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fc2:	2905                	addiw	s2,s2,1
    80003fc4:	b77d                	j	80003f72 <pipewrite+0x7a>
    80003fc6:	7b42                	ld	s6,48(sp)
    80003fc8:	7ba2                	ld	s7,40(sp)
    80003fca:	7c02                	ld	s8,32(sp)
    80003fcc:	6ce2                	ld	s9,24(sp)
    80003fce:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003fd0:	21848513          	addi	a0,s1,536
    80003fd4:	faefd0ef          	jal	80001782 <wakeup>
  release(&pi->lock);
    80003fd8:	8526                	mv	a0,s1
    80003fda:	7e3010ef          	jal	80005fbc <release>
  return i;
    80003fde:	bf8d                	j	80003f50 <pipewrite+0x58>
  int i = 0;
    80003fe0:	4901                	li	s2,0
    80003fe2:	b7fd                	j	80003fd0 <pipewrite+0xd8>
    80003fe4:	7b42                	ld	s6,48(sp)
    80003fe6:	7ba2                	ld	s7,40(sp)
    80003fe8:	7c02                	ld	s8,32(sp)
    80003fea:	6ce2                	ld	s9,24(sp)
    80003fec:	6d42                	ld	s10,16(sp)
    80003fee:	b7cd                	j	80003fd0 <pipewrite+0xd8>

0000000080003ff0 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ff0:	711d                	addi	sp,sp,-96
    80003ff2:	ec86                	sd	ra,88(sp)
    80003ff4:	e8a2                	sd	s0,80(sp)
    80003ff6:	e4a6                	sd	s1,72(sp)
    80003ff8:	e0ca                	sd	s2,64(sp)
    80003ffa:	fc4e                	sd	s3,56(sp)
    80003ffc:	f852                	sd	s4,48(sp)
    80003ffe:	f456                	sd	s5,40(sp)
    80004000:	1080                	addi	s0,sp,96
    80004002:	84aa                	mv	s1,a0
    80004004:	892e                	mv	s2,a1
    80004006:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004008:	8e8fd0ef          	jal	800010f0 <myproc>
    8000400c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000400e:	8526                	mv	a0,s1
    80004010:	719010ef          	jal	80005f28 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004014:	2184a703          	lw	a4,536(s1)
    80004018:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000401c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004020:	02f71763          	bne	a4,a5,8000404e <piperead+0x5e>
    80004024:	2244a783          	lw	a5,548(s1)
    80004028:	cf85                	beqz	a5,80004060 <piperead+0x70>
    if(killed(pr)){
    8000402a:	8552                	mv	a0,s4
    8000402c:	9a7fd0ef          	jal	800019d2 <killed>
    80004030:	e11d                	bnez	a0,80004056 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004032:	85a6                	mv	a1,s1
    80004034:	854e                	mv	a0,s3
    80004036:	f00fd0ef          	jal	80001736 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000403a:	2184a703          	lw	a4,536(s1)
    8000403e:	21c4a783          	lw	a5,540(s1)
    80004042:	fef701e3          	beq	a4,a5,80004024 <piperead+0x34>
    80004046:	f05a                	sd	s6,32(sp)
    80004048:	ec5e                	sd	s7,24(sp)
    8000404a:	e862                	sd	s8,16(sp)
    8000404c:	a829                	j	80004066 <piperead+0x76>
    8000404e:	f05a                	sd	s6,32(sp)
    80004050:	ec5e                	sd	s7,24(sp)
    80004052:	e862                	sd	s8,16(sp)
    80004054:	a809                	j	80004066 <piperead+0x76>
      release(&pi->lock);
    80004056:	8526                	mv	a0,s1
    80004058:	765010ef          	jal	80005fbc <release>
      return -1;
    8000405c:	59fd                	li	s3,-1
    8000405e:	a09d                	j	800040c4 <piperead+0xd4>
    80004060:	f05a                	sd	s6,32(sp)
    80004062:	ec5e                	sd	s7,24(sp)
    80004064:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004066:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004068:	faf40c13          	addi	s8,s0,-81
    8000406c:	4b85                	li	s7,1
    8000406e:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004070:	05505063          	blez	s5,800040b0 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80004074:	2184a783          	lw	a5,536(s1)
    80004078:	21c4a703          	lw	a4,540(s1)
    8000407c:	02f70a63          	beq	a4,a5,800040b0 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004080:	0017871b          	addiw	a4,a5,1
    80004084:	20e4ac23          	sw	a4,536(s1)
    80004088:	1ff7f793          	andi	a5,a5,511
    8000408c:	97a6                	add	a5,a5,s1
    8000408e:	0187c783          	lbu	a5,24(a5)
    80004092:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004096:	86de                	mv	a3,s7
    80004098:	8662                	mv	a2,s8
    8000409a:	85ca                	mv	a1,s2
    8000409c:	050a3503          	ld	a0,80(s4)
    800040a0:	b73fc0ef          	jal	80000c12 <copyout>
    800040a4:	01650663          	beq	a0,s6,800040b0 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a8:	2985                	addiw	s3,s3,1
    800040aa:	0905                	addi	s2,s2,1
    800040ac:	fd3a94e3          	bne	s5,s3,80004074 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040b0:	21c48513          	addi	a0,s1,540
    800040b4:	ecefd0ef          	jal	80001782 <wakeup>
  release(&pi->lock);
    800040b8:	8526                	mv	a0,s1
    800040ba:	703010ef          	jal	80005fbc <release>
    800040be:	7b02                	ld	s6,32(sp)
    800040c0:	6be2                	ld	s7,24(sp)
    800040c2:	6c42                	ld	s8,16(sp)
  return i;
}
    800040c4:	854e                	mv	a0,s3
    800040c6:	60e6                	ld	ra,88(sp)
    800040c8:	6446                	ld	s0,80(sp)
    800040ca:	64a6                	ld	s1,72(sp)
    800040cc:	6906                	ld	s2,64(sp)
    800040ce:	79e2                	ld	s3,56(sp)
    800040d0:	7a42                	ld	s4,48(sp)
    800040d2:	7aa2                	ld	s5,40(sp)
    800040d4:	6125                	addi	sp,sp,96
    800040d6:	8082                	ret

00000000800040d8 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    800040d8:	1141                	addi	sp,sp,-16
    800040da:	e406                	sd	ra,8(sp)
    800040dc:	e022                	sd	s0,0(sp)
    800040de:	0800                	addi	s0,sp,16
    800040e0:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800040e2:	0035151b          	slliw	a0,a0,0x3
    800040e6:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    800040e8:	8b89                	andi	a5,a5,2
    800040ea:	c399                	beqz	a5,800040f0 <flags2perm+0x18>
      perm |= PTE_W;
    800040ec:	00456513          	ori	a0,a0,4
    return perm;
}
    800040f0:	60a2                	ld	ra,8(sp)
    800040f2:	6402                	ld	s0,0(sp)
    800040f4:	0141                	addi	sp,sp,16
    800040f6:	8082                	ret

00000000800040f8 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    800040f8:	de010113          	addi	sp,sp,-544
    800040fc:	20113c23          	sd	ra,536(sp)
    80004100:	20813823          	sd	s0,528(sp)
    80004104:	20913423          	sd	s1,520(sp)
    80004108:	21213023          	sd	s2,512(sp)
    8000410c:	1400                	addi	s0,sp,544
    8000410e:	892a                	mv	s2,a0
    80004110:	dea43823          	sd	a0,-528(s0)
    80004114:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004118:	fd9fc0ef          	jal	800010f0 <myproc>
    8000411c:	84aa                	mv	s1,a0

  begin_op();
    8000411e:	d74ff0ef          	jal	80003692 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80004122:	854a                	mv	a0,s2
    80004124:	b90ff0ef          	jal	800034b4 <namei>
    80004128:	cd21                	beqz	a0,80004180 <kexec+0x88>
    8000412a:	fbd2                	sd	s4,496(sp)
    8000412c:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000412e:	b59fe0ef          	jal	80002c86 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004132:	04000713          	li	a4,64
    80004136:	4681                	li	a3,0
    80004138:	e5040613          	addi	a2,s0,-432
    8000413c:	4581                	li	a1,0
    8000413e:	8552                	mv	a0,s4
    80004140:	ed9fe0ef          	jal	80003018 <readi>
    80004144:	04000793          	li	a5,64
    80004148:	00f51a63          	bne	a0,a5,8000415c <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    8000414c:	e5042703          	lw	a4,-432(s0)
    80004150:	464c47b7          	lui	a5,0x464c4
    80004154:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004158:	02f70863          	beq	a4,a5,80004188 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000415c:	8552                	mv	a0,s4
    8000415e:	d35fe0ef          	jal	80002e92 <iunlockput>
    end_op();
    80004162:	da0ff0ef          	jal	80003702 <end_op>
  }
  return -1;
    80004166:	557d                	li	a0,-1
    80004168:	7a5e                	ld	s4,496(sp)
}
    8000416a:	21813083          	ld	ra,536(sp)
    8000416e:	21013403          	ld	s0,528(sp)
    80004172:	20813483          	ld	s1,520(sp)
    80004176:	20013903          	ld	s2,512(sp)
    8000417a:	22010113          	addi	sp,sp,544
    8000417e:	8082                	ret
    end_op();
    80004180:	d82ff0ef          	jal	80003702 <end_op>
    return -1;
    80004184:	557d                	li	a0,-1
    80004186:	b7d5                	j	8000416a <kexec+0x72>
    80004188:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    8000418a:	8526                	mv	a0,s1
    8000418c:	86efd0ef          	jal	800011fa <proc_pagetable>
    80004190:	8b2a                	mv	s6,a0
    80004192:	26050f63          	beqz	a0,80004410 <kexec+0x318>
    80004196:	ffce                	sd	s3,504(sp)
    80004198:	f7d6                	sd	s5,488(sp)
    8000419a:	efde                	sd	s7,472(sp)
    8000419c:	ebe2                	sd	s8,464(sp)
    8000419e:	e7e6                	sd	s9,456(sp)
    800041a0:	e3ea                	sd	s10,448(sp)
    800041a2:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041a4:	e8845783          	lhu	a5,-376(s0)
    800041a8:	0e078963          	beqz	a5,8000429a <kexec+0x1a2>
    800041ac:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041b0:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041b2:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800041b4:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    800041b8:	6c85                	lui	s9,0x1
    800041ba:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800041be:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    800041c2:	6a85                	lui	s5,0x1
    800041c4:	a085                	j	80004224 <kexec+0x12c>
      panic("loadseg: address should exist");
    800041c6:	00003517          	auipc	a0,0x3
    800041ca:	3f250513          	addi	a0,a0,1010 # 800075b8 <etext+0x5b8>
    800041ce:	299010ef          	jal	80005c66 <panic>
    if(sz - i < PGSIZE)
    800041d2:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800041d4:	874a                	mv	a4,s2
    800041d6:	009b86bb          	addw	a3,s7,s1
    800041da:	4581                	li	a1,0
    800041dc:	8552                	mv	a0,s4
    800041de:	e3bfe0ef          	jal	80003018 <readi>
    800041e2:	22a91b63          	bne	s2,a0,80004418 <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    800041e6:	009a84bb          	addw	s1,s5,s1
    800041ea:	0334f263          	bgeu	s1,s3,8000420e <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    800041ee:	02049593          	slli	a1,s1,0x20
    800041f2:	9181                	srli	a1,a1,0x20
    800041f4:	95e2                	add	a1,a1,s8
    800041f6:	855a                	mv	a0,s6
    800041f8:	a94fc0ef          	jal	8000048c <walkaddr>
    800041fc:	862a                	mv	a2,a0
    if(pa == 0)
    800041fe:	d561                	beqz	a0,800041c6 <kexec+0xce>
    if(sz - i < PGSIZE)
    80004200:	409987bb          	subw	a5,s3,s1
    80004204:	893e                	mv	s2,a5
    80004206:	fcfcf6e3          	bgeu	s9,a5,800041d2 <kexec+0xda>
    8000420a:	8956                	mv	s2,s5
    8000420c:	b7d9                	j	800041d2 <kexec+0xda>
    sz = sz1;
    8000420e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004212:	2d05                	addiw	s10,s10,1
    80004214:	e0843783          	ld	a5,-504(s0)
    80004218:	0387869b          	addiw	a3,a5,56
    8000421c:	e8845783          	lhu	a5,-376(s0)
    80004220:	06fd5e63          	bge	s10,a5,8000429c <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004224:	e0d43423          	sd	a3,-504(s0)
    80004228:	876e                	mv	a4,s11
    8000422a:	e1840613          	addi	a2,s0,-488
    8000422e:	4581                	li	a1,0
    80004230:	8552                	mv	a0,s4
    80004232:	de7fe0ef          	jal	80003018 <readi>
    80004236:	1db51f63          	bne	a0,s11,80004414 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    8000423a:	e1842783          	lw	a5,-488(s0)
    8000423e:	4705                	li	a4,1
    80004240:	fce799e3          	bne	a5,a4,80004212 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80004244:	e4043483          	ld	s1,-448(s0)
    80004248:	e3843783          	ld	a5,-456(s0)
    8000424c:	1ef4e463          	bltu	s1,a5,80004434 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004250:	e2843783          	ld	a5,-472(s0)
    80004254:	94be                	add	s1,s1,a5
    80004256:	1ef4e263          	bltu	s1,a5,8000443a <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    8000425a:	de843703          	ld	a4,-536(s0)
    8000425e:	8ff9                	and	a5,a5,a4
    80004260:	1e079063          	bnez	a5,80004440 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004264:	e1c42503          	lw	a0,-484(s0)
    80004268:	e71ff0ef          	jal	800040d8 <flags2perm>
    8000426c:	86aa                	mv	a3,a0
    8000426e:	8626                	mv	a2,s1
    80004270:	85ca                	mv	a1,s2
    80004272:	855a                	mv	a0,s6
    80004274:	ceefc0ef          	jal	80000762 <uvmalloc>
    80004278:	dea43c23          	sd	a0,-520(s0)
    8000427c:	1c050563          	beqz	a0,80004446 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004280:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004284:	00098863          	beqz	s3,80004294 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004288:	e2843c03          	ld	s8,-472(s0)
    8000428c:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004290:	4481                	li	s1,0
    80004292:	bfb1                	j	800041ee <kexec+0xf6>
    sz = sz1;
    80004294:	df843903          	ld	s2,-520(s0)
    80004298:	bfad                	j	80004212 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000429a:	4901                	li	s2,0
  iunlockput(ip);
    8000429c:	8552                	mv	a0,s4
    8000429e:	bf5fe0ef          	jal	80002e92 <iunlockput>
  end_op();
    800042a2:	c60ff0ef          	jal	80003702 <end_op>
  p = myproc();
    800042a6:	e4bfc0ef          	jal	800010f0 <myproc>
    800042aa:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042ac:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042b0:	6985                	lui	s3,0x1
    800042b2:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    800042b4:	99ca                	add	s3,s3,s2
    800042b6:	77fd                	lui	a5,0xfffff
    800042b8:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    800042bc:	4691                	li	a3,4
    800042be:	6609                	lui	a2,0x2
    800042c0:	964e                	add	a2,a2,s3
    800042c2:	85ce                	mv	a1,s3
    800042c4:	855a                	mv	a0,s6
    800042c6:	c9cfc0ef          	jal	80000762 <uvmalloc>
    800042ca:	8a2a                	mv	s4,a0
    800042cc:	e105                	bnez	a0,800042ec <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    800042ce:	85ce                	mv	a1,s3
    800042d0:	855a                	mv	a0,s6
    800042d2:	fadfc0ef          	jal	8000127e <proc_freepagetable>
  return -1;
    800042d6:	557d                	li	a0,-1
    800042d8:	79fe                	ld	s3,504(sp)
    800042da:	7a5e                	ld	s4,496(sp)
    800042dc:	7abe                	ld	s5,488(sp)
    800042de:	7b1e                	ld	s6,480(sp)
    800042e0:	6bfe                	ld	s7,472(sp)
    800042e2:	6c5e                	ld	s8,464(sp)
    800042e4:	6cbe                	ld	s9,456(sp)
    800042e6:	6d1e                	ld	s10,448(sp)
    800042e8:	7dfa                	ld	s11,440(sp)
    800042ea:	b541                	j	8000416a <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    800042ec:	75f9                	lui	a1,0xffffe
    800042ee:	95aa                	add	a1,a1,a0
    800042f0:	855a                	mv	a0,s6
    800042f2:	e42fc0ef          	jal	80000934 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    800042f6:	800a0b93          	addi	s7,s4,-2048
    800042fa:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    800042fe:	e0043783          	ld	a5,-512(s0)
    80004302:	6388                	ld	a0,0(a5)
  sp = sz;
    80004304:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004306:	4481                	li	s1,0
    ustack[argc] = sp;
    80004308:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    8000430c:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80004310:	cd21                	beqz	a0,80004368 <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80004312:	fd7fb0ef          	jal	800002e8 <strlen>
    80004316:	0015079b          	addiw	a5,a0,1
    8000431a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000431e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80004322:	13796563          	bltu	s2,s7,8000444c <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004326:	e0043d83          	ld	s11,-512(s0)
    8000432a:	000db983          	ld	s3,0(s11)
    8000432e:	854e                	mv	a0,s3
    80004330:	fb9fb0ef          	jal	800002e8 <strlen>
    80004334:	0015069b          	addiw	a3,a0,1
    80004338:	864e                	mv	a2,s3
    8000433a:	85ca                	mv	a1,s2
    8000433c:	855a                	mv	a0,s6
    8000433e:	8d5fc0ef          	jal	80000c12 <copyout>
    80004342:	10054763          	bltz	a0,80004450 <kexec+0x358>
    ustack[argc] = sp;
    80004346:	00349793          	slli	a5,s1,0x3
    8000434a:	97e6                	add	a5,a5,s9
    8000434c:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffd2208>
  for(argc = 0; argv[argc]; argc++) {
    80004350:	0485                	addi	s1,s1,1
    80004352:	008d8793          	addi	a5,s11,8
    80004356:	e0f43023          	sd	a5,-512(s0)
    8000435a:	008db503          	ld	a0,8(s11)
    8000435e:	c509                	beqz	a0,80004368 <kexec+0x270>
    if(argc >= MAXARG)
    80004360:	fb8499e3          	bne	s1,s8,80004312 <kexec+0x21a>
  sz = sz1;
    80004364:	89d2                	mv	s3,s4
    80004366:	b7a5                	j	800042ce <kexec+0x1d6>
  ustack[argc] = 0;
    80004368:	00349793          	slli	a5,s1,0x3
    8000436c:	f9078793          	addi	a5,a5,-112
    80004370:	97a2                	add	a5,a5,s0
    80004372:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80004376:	00349693          	slli	a3,s1,0x3
    8000437a:	06a1                	addi	a3,a3,8
    8000437c:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004380:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004384:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004386:	f57964e3          	bltu	s2,s7,800042ce <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000438a:	e9040613          	addi	a2,s0,-368
    8000438e:	85ca                	mv	a1,s2
    80004390:	855a                	mv	a0,s6
    80004392:	881fc0ef          	jal	80000c12 <copyout>
    80004396:	f2054ce3          	bltz	a0,800042ce <kexec+0x1d6>
  p->trapframe->a1 = sp;
    8000439a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000439e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043a2:	df043783          	ld	a5,-528(s0)
    800043a6:	0007c703          	lbu	a4,0(a5)
    800043aa:	cf11                	beqz	a4,800043c6 <kexec+0x2ce>
    800043ac:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043ae:	02f00693          	li	a3,47
    800043b2:	a029                	j	800043bc <kexec+0x2c4>
  for(last=s=path; *s; s++)
    800043b4:	0785                	addi	a5,a5,1
    800043b6:	fff7c703          	lbu	a4,-1(a5)
    800043ba:	c711                	beqz	a4,800043c6 <kexec+0x2ce>
    if(*s == '/')
    800043bc:	fed71ce3          	bne	a4,a3,800043b4 <kexec+0x2bc>
      last = s+1;
    800043c0:	def43823          	sd	a5,-528(s0)
    800043c4:	bfc5                	j	800043b4 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    800043c6:	4641                	li	a2,16
    800043c8:	df043583          	ld	a1,-528(s0)
    800043cc:	158a8513          	addi	a0,s5,344
    800043d0:	ee3fb0ef          	jal	800002b2 <safestrcpy>
  oldpagetable = p->pagetable;
    800043d4:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043d8:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    800043dc:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    800043e0:	058ab783          	ld	a5,88(s5)
    800043e4:	e6843703          	ld	a4,-408(s0)
    800043e8:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043ea:	058ab783          	ld	a5,88(s5)
    800043ee:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043f2:	85ea                	mv	a1,s10
    800043f4:	e8bfc0ef          	jal	8000127e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800043f8:	0004851b          	sext.w	a0,s1
    800043fc:	79fe                	ld	s3,504(sp)
    800043fe:	7a5e                	ld	s4,496(sp)
    80004400:	7abe                	ld	s5,488(sp)
    80004402:	7b1e                	ld	s6,480(sp)
    80004404:	6bfe                	ld	s7,472(sp)
    80004406:	6c5e                	ld	s8,464(sp)
    80004408:	6cbe                	ld	s9,456(sp)
    8000440a:	6d1e                	ld	s10,448(sp)
    8000440c:	7dfa                	ld	s11,440(sp)
    8000440e:	bbb1                	j	8000416a <kexec+0x72>
    80004410:	7b1e                	ld	s6,480(sp)
    80004412:	b3a9                	j	8000415c <kexec+0x64>
    80004414:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004418:	df843583          	ld	a1,-520(s0)
    8000441c:	855a                	mv	a0,s6
    8000441e:	e61fc0ef          	jal	8000127e <proc_freepagetable>
  if(ip){
    80004422:	79fe                	ld	s3,504(sp)
    80004424:	7abe                	ld	s5,488(sp)
    80004426:	7b1e                	ld	s6,480(sp)
    80004428:	6bfe                	ld	s7,472(sp)
    8000442a:	6c5e                	ld	s8,464(sp)
    8000442c:	6cbe                	ld	s9,456(sp)
    8000442e:	6d1e                	ld	s10,448(sp)
    80004430:	7dfa                	ld	s11,440(sp)
    80004432:	b32d                	j	8000415c <kexec+0x64>
    80004434:	df243c23          	sd	s2,-520(s0)
    80004438:	b7c5                	j	80004418 <kexec+0x320>
    8000443a:	df243c23          	sd	s2,-520(s0)
    8000443e:	bfe9                	j	80004418 <kexec+0x320>
    80004440:	df243c23          	sd	s2,-520(s0)
    80004444:	bfd1                	j	80004418 <kexec+0x320>
    80004446:	df243c23          	sd	s2,-520(s0)
    8000444a:	b7f9                	j	80004418 <kexec+0x320>
  sz = sz1;
    8000444c:	89d2                	mv	s3,s4
    8000444e:	b541                	j	800042ce <kexec+0x1d6>
    80004450:	89d2                	mv	s3,s4
    80004452:	bdb5                	j	800042ce <kexec+0x1d6>

0000000080004454 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004454:	7179                	addi	sp,sp,-48
    80004456:	f406                	sd	ra,40(sp)
    80004458:	f022                	sd	s0,32(sp)
    8000445a:	ec26                	sd	s1,24(sp)
    8000445c:	e84a                	sd	s2,16(sp)
    8000445e:	1800                	addi	s0,sp,48
    80004460:	892e                	mv	s2,a1
    80004462:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80004464:	fdc40593          	addi	a1,s0,-36
    80004468:	c3bfd0ef          	jal	800020a2 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    8000446c:	fdc42703          	lw	a4,-36(s0)
    80004470:	47bd                	li	a5,15
    80004472:	02e7ea63          	bltu	a5,a4,800044a6 <argfd+0x52>
    80004476:	c7bfc0ef          	jal	800010f0 <myproc>
    8000447a:	fdc42703          	lw	a4,-36(s0)
    8000447e:	00371793          	slli	a5,a4,0x3
    80004482:	0d078793          	addi	a5,a5,208
    80004486:	953e                	add	a0,a0,a5
    80004488:	611c                	ld	a5,0(a0)
    8000448a:	c385                	beqz	a5,800044aa <argfd+0x56>
    return -1;
  if(pfd)
    8000448c:	00090463          	beqz	s2,80004494 <argfd+0x40>
    *pfd = fd;
    80004490:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004494:	4501                	li	a0,0
  if(pf)
    80004496:	c091                	beqz	s1,8000449a <argfd+0x46>
    *pf = f;
    80004498:	e09c                	sd	a5,0(s1)
}
    8000449a:	70a2                	ld	ra,40(sp)
    8000449c:	7402                	ld	s0,32(sp)
    8000449e:	64e2                	ld	s1,24(sp)
    800044a0:	6942                	ld	s2,16(sp)
    800044a2:	6145                	addi	sp,sp,48
    800044a4:	8082                	ret
    return -1;
    800044a6:	557d                	li	a0,-1
    800044a8:	bfcd                	j	8000449a <argfd+0x46>
    800044aa:	557d                	li	a0,-1
    800044ac:	b7fd                	j	8000449a <argfd+0x46>

00000000800044ae <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044ae:	1101                	addi	sp,sp,-32
    800044b0:	ec06                	sd	ra,24(sp)
    800044b2:	e822                	sd	s0,16(sp)
    800044b4:	e426                	sd	s1,8(sp)
    800044b6:	1000                	addi	s0,sp,32
    800044b8:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    800044ba:	c37fc0ef          	jal	800010f0 <myproc>
    800044be:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    800044c0:	0d050793          	addi	a5,a0,208
    800044c4:	4501                	li	a0,0
    800044c6:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    800044c8:	6398                	ld	a4,0(a5)
    800044ca:	cb19                	beqz	a4,800044e0 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    800044cc:	2505                	addiw	a0,a0,1
    800044ce:	07a1                	addi	a5,a5,8
    800044d0:	fed51ce3          	bne	a0,a3,800044c8 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    800044d4:	557d                	li	a0,-1
}
    800044d6:	60e2                	ld	ra,24(sp)
    800044d8:	6442                	ld	s0,16(sp)
    800044da:	64a2                	ld	s1,8(sp)
    800044dc:	6105                	addi	sp,sp,32
    800044de:	8082                	ret
      p->ofile[fd] = f;
    800044e0:	00351793          	slli	a5,a0,0x3
    800044e4:	0d078793          	addi	a5,a5,208
    800044e8:	963e                	add	a2,a2,a5
    800044ea:	e204                	sd	s1,0(a2)
      return fd;
    800044ec:	b7ed                	j	800044d6 <fdalloc+0x28>

00000000800044ee <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    800044ee:	715d                	addi	sp,sp,-80
    800044f0:	e486                	sd	ra,72(sp)
    800044f2:	e0a2                	sd	s0,64(sp)
    800044f4:	fc26                	sd	s1,56(sp)
    800044f6:	f84a                	sd	s2,48(sp)
    800044f8:	f44e                	sd	s3,40(sp)
    800044fa:	f052                	sd	s4,32(sp)
    800044fc:	ec56                	sd	s5,24(sp)
    800044fe:	e85a                	sd	s6,16(sp)
    80004500:	0880                	addi	s0,sp,80
    80004502:	892e                	mv	s2,a1
    80004504:	8a2e                	mv	s4,a1
    80004506:	8ab2                	mv	s5,a2
    80004508:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000450a:	fb040593          	addi	a1,s0,-80
    8000450e:	fc1fe0ef          	jal	800034ce <nameiparent>
    80004512:	84aa                	mv	s1,a0
    80004514:	10050763          	beqz	a0,80004622 <create+0x134>
    return 0;

  ilock(dp);
    80004518:	f6efe0ef          	jal	80002c86 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000451c:	4601                	li	a2,0
    8000451e:	fb040593          	addi	a1,s0,-80
    80004522:	8526                	mv	a0,s1
    80004524:	cfdfe0ef          	jal	80003220 <dirlookup>
    80004528:	89aa                	mv	s3,a0
    8000452a:	c131                	beqz	a0,8000456e <create+0x80>
    iunlockput(dp);
    8000452c:	8526                	mv	a0,s1
    8000452e:	965fe0ef          	jal	80002e92 <iunlockput>
    ilock(ip);
    80004532:	854e                	mv	a0,s3
    80004534:	f52fe0ef          	jal	80002c86 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004538:	4789                	li	a5,2
    8000453a:	02f91563          	bne	s2,a5,80004564 <create+0x76>
    8000453e:	0449d783          	lhu	a5,68(s3)
    80004542:	37f9                	addiw	a5,a5,-2
    80004544:	17c2                	slli	a5,a5,0x30
    80004546:	93c1                	srli	a5,a5,0x30
    80004548:	4705                	li	a4,1
    8000454a:	00f76d63          	bltu	a4,a5,80004564 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000454e:	854e                	mv	a0,s3
    80004550:	60a6                	ld	ra,72(sp)
    80004552:	6406                	ld	s0,64(sp)
    80004554:	74e2                	ld	s1,56(sp)
    80004556:	7942                	ld	s2,48(sp)
    80004558:	79a2                	ld	s3,40(sp)
    8000455a:	7a02                	ld	s4,32(sp)
    8000455c:	6ae2                	ld	s5,24(sp)
    8000455e:	6b42                	ld	s6,16(sp)
    80004560:	6161                	addi	sp,sp,80
    80004562:	8082                	ret
    iunlockput(ip);
    80004564:	854e                	mv	a0,s3
    80004566:	92dfe0ef          	jal	80002e92 <iunlockput>
    return 0;
    8000456a:	4981                	li	s3,0
    8000456c:	b7cd                	j	8000454e <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    8000456e:	85ca                	mv	a1,s2
    80004570:	4088                	lw	a0,0(s1)
    80004572:	da4fe0ef          	jal	80002b16 <ialloc>
    80004576:	892a                	mv	s2,a0
    80004578:	cd15                	beqz	a0,800045b4 <create+0xc6>
  ilock(ip);
    8000457a:	f0cfe0ef          	jal	80002c86 <ilock>
  ip->major = major;
    8000457e:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004582:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004586:	4785                	li	a5,1
    80004588:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000458c:	854a                	mv	a0,s2
    8000458e:	e44fe0ef          	jal	80002bd2 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004592:	4705                	li	a4,1
    80004594:	02ea0463          	beq	s4,a4,800045bc <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004598:	00492603          	lw	a2,4(s2)
    8000459c:	fb040593          	addi	a1,s0,-80
    800045a0:	8526                	mv	a0,s1
    800045a2:	e69fe0ef          	jal	8000340a <dirlink>
    800045a6:	06054263          	bltz	a0,8000460a <create+0x11c>
  iunlockput(dp);
    800045aa:	8526                	mv	a0,s1
    800045ac:	8e7fe0ef          	jal	80002e92 <iunlockput>
  return ip;
    800045b0:	89ca                	mv	s3,s2
    800045b2:	bf71                	j	8000454e <create+0x60>
    iunlockput(dp);
    800045b4:	8526                	mv	a0,s1
    800045b6:	8ddfe0ef          	jal	80002e92 <iunlockput>
    return 0;
    800045ba:	bf51                	j	8000454e <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800045bc:	00492603          	lw	a2,4(s2)
    800045c0:	00003597          	auipc	a1,0x3
    800045c4:	01858593          	addi	a1,a1,24 # 800075d8 <etext+0x5d8>
    800045c8:	854a                	mv	a0,s2
    800045ca:	e41fe0ef          	jal	8000340a <dirlink>
    800045ce:	02054e63          	bltz	a0,8000460a <create+0x11c>
    800045d2:	40d0                	lw	a2,4(s1)
    800045d4:	00003597          	auipc	a1,0x3
    800045d8:	00c58593          	addi	a1,a1,12 # 800075e0 <etext+0x5e0>
    800045dc:	854a                	mv	a0,s2
    800045de:	e2dfe0ef          	jal	8000340a <dirlink>
    800045e2:	02054463          	bltz	a0,8000460a <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800045e6:	00492603          	lw	a2,4(s2)
    800045ea:	fb040593          	addi	a1,s0,-80
    800045ee:	8526                	mv	a0,s1
    800045f0:	e1bfe0ef          	jal	8000340a <dirlink>
    800045f4:	00054b63          	bltz	a0,8000460a <create+0x11c>
    dp->nlink++;  // for ".."
    800045f8:	04a4d783          	lhu	a5,74(s1)
    800045fc:	2785                	addiw	a5,a5,1
    800045fe:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004602:	8526                	mv	a0,s1
    80004604:	dcefe0ef          	jal	80002bd2 <iupdate>
    80004608:	b74d                	j	800045aa <create+0xbc>
  ip->nlink = 0;
    8000460a:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    8000460e:	854a                	mv	a0,s2
    80004610:	dc2fe0ef          	jal	80002bd2 <iupdate>
  iunlockput(ip);
    80004614:	854a                	mv	a0,s2
    80004616:	87dfe0ef          	jal	80002e92 <iunlockput>
  iunlockput(dp);
    8000461a:	8526                	mv	a0,s1
    8000461c:	877fe0ef          	jal	80002e92 <iunlockput>
  return 0;
    80004620:	b73d                	j	8000454e <create+0x60>
    return 0;
    80004622:	89aa                	mv	s3,a0
    80004624:	b72d                	j	8000454e <create+0x60>

0000000080004626 <sys_dup>:
{
    80004626:	7179                	addi	sp,sp,-48
    80004628:	f406                	sd	ra,40(sp)
    8000462a:	f022                	sd	s0,32(sp)
    8000462c:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000462e:	fd840613          	addi	a2,s0,-40
    80004632:	4581                	li	a1,0
    80004634:	4501                	li	a0,0
    80004636:	e1fff0ef          	jal	80004454 <argfd>
    return -1;
    8000463a:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000463c:	02054363          	bltz	a0,80004662 <sys_dup+0x3c>
    80004640:	ec26                	sd	s1,24(sp)
    80004642:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004644:	fd843483          	ld	s1,-40(s0)
    80004648:	8526                	mv	a0,s1
    8000464a:	e65ff0ef          	jal	800044ae <fdalloc>
    8000464e:	892a                	mv	s2,a0
    return -1;
    80004650:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004652:	00054d63          	bltz	a0,8000466c <sys_dup+0x46>
  filedup(f);
    80004656:	8526                	mv	a0,s1
    80004658:	c18ff0ef          	jal	80003a70 <filedup>
  return fd;
    8000465c:	87ca                	mv	a5,s2
    8000465e:	64e2                	ld	s1,24(sp)
    80004660:	6942                	ld	s2,16(sp)
}
    80004662:	853e                	mv	a0,a5
    80004664:	70a2                	ld	ra,40(sp)
    80004666:	7402                	ld	s0,32(sp)
    80004668:	6145                	addi	sp,sp,48
    8000466a:	8082                	ret
    8000466c:	64e2                	ld	s1,24(sp)
    8000466e:	6942                	ld	s2,16(sp)
    80004670:	bfcd                	j	80004662 <sys_dup+0x3c>

0000000080004672 <sys_read>:
{
    80004672:	7179                	addi	sp,sp,-48
    80004674:	f406                	sd	ra,40(sp)
    80004676:	f022                	sd	s0,32(sp)
    80004678:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000467a:	fd840593          	addi	a1,s0,-40
    8000467e:	4505                	li	a0,1
    80004680:	a3ffd0ef          	jal	800020be <argaddr>
  argint(2, &n);
    80004684:	fe440593          	addi	a1,s0,-28
    80004688:	4509                	li	a0,2
    8000468a:	a19fd0ef          	jal	800020a2 <argint>
  if(argfd(0, 0, &f) < 0)
    8000468e:	fe840613          	addi	a2,s0,-24
    80004692:	4581                	li	a1,0
    80004694:	4501                	li	a0,0
    80004696:	dbfff0ef          	jal	80004454 <argfd>
    8000469a:	87aa                	mv	a5,a0
    return -1;
    8000469c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000469e:	0007ca63          	bltz	a5,800046b2 <sys_read+0x40>
  return fileread(f, p, n);
    800046a2:	fe442603          	lw	a2,-28(s0)
    800046a6:	fd843583          	ld	a1,-40(s0)
    800046aa:	fe843503          	ld	a0,-24(s0)
    800046ae:	d2cff0ef          	jal	80003bda <fileread>
}
    800046b2:	70a2                	ld	ra,40(sp)
    800046b4:	7402                	ld	s0,32(sp)
    800046b6:	6145                	addi	sp,sp,48
    800046b8:	8082                	ret

00000000800046ba <sys_write>:
{
    800046ba:	7179                	addi	sp,sp,-48
    800046bc:	f406                	sd	ra,40(sp)
    800046be:	f022                	sd	s0,32(sp)
    800046c0:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046c2:	fd840593          	addi	a1,s0,-40
    800046c6:	4505                	li	a0,1
    800046c8:	9f7fd0ef          	jal	800020be <argaddr>
  argint(2, &n);
    800046cc:	fe440593          	addi	a1,s0,-28
    800046d0:	4509                	li	a0,2
    800046d2:	9d1fd0ef          	jal	800020a2 <argint>
  if(argfd(0, 0, &f) < 0)
    800046d6:	fe840613          	addi	a2,s0,-24
    800046da:	4581                	li	a1,0
    800046dc:	4501                	li	a0,0
    800046de:	d77ff0ef          	jal	80004454 <argfd>
    800046e2:	87aa                	mv	a5,a0
    return -1;
    800046e4:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046e6:	0007ca63          	bltz	a5,800046fa <sys_write+0x40>
  return filewrite(f, p, n);
    800046ea:	fe442603          	lw	a2,-28(s0)
    800046ee:	fd843583          	ld	a1,-40(s0)
    800046f2:	fe843503          	ld	a0,-24(s0)
    800046f6:	da8ff0ef          	jal	80003c9e <filewrite>
}
    800046fa:	70a2                	ld	ra,40(sp)
    800046fc:	7402                	ld	s0,32(sp)
    800046fe:	6145                	addi	sp,sp,48
    80004700:	8082                	ret

0000000080004702 <sys_close>:
{
    80004702:	1101                	addi	sp,sp,-32
    80004704:	ec06                	sd	ra,24(sp)
    80004706:	e822                	sd	s0,16(sp)
    80004708:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000470a:	fe040613          	addi	a2,s0,-32
    8000470e:	fec40593          	addi	a1,s0,-20
    80004712:	4501                	li	a0,0
    80004714:	d41ff0ef          	jal	80004454 <argfd>
    return -1;
    80004718:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000471a:	02054163          	bltz	a0,8000473c <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    8000471e:	9d3fc0ef          	jal	800010f0 <myproc>
    80004722:	fec42783          	lw	a5,-20(s0)
    80004726:	078e                	slli	a5,a5,0x3
    80004728:	0d078793          	addi	a5,a5,208
    8000472c:	953e                	add	a0,a0,a5
    8000472e:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004732:	fe043503          	ld	a0,-32(s0)
    80004736:	b80ff0ef          	jal	80003ab6 <fileclose>
  return 0;
    8000473a:	4781                	li	a5,0
}
    8000473c:	853e                	mv	a0,a5
    8000473e:	60e2                	ld	ra,24(sp)
    80004740:	6442                	ld	s0,16(sp)
    80004742:	6105                	addi	sp,sp,32
    80004744:	8082                	ret

0000000080004746 <sys_fstat>:
{
    80004746:	1101                	addi	sp,sp,-32
    80004748:	ec06                	sd	ra,24(sp)
    8000474a:	e822                	sd	s0,16(sp)
    8000474c:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000474e:	fe040593          	addi	a1,s0,-32
    80004752:	4505                	li	a0,1
    80004754:	96bfd0ef          	jal	800020be <argaddr>
  if(argfd(0, 0, &f) < 0)
    80004758:	fe840613          	addi	a2,s0,-24
    8000475c:	4581                	li	a1,0
    8000475e:	4501                	li	a0,0
    80004760:	cf5ff0ef          	jal	80004454 <argfd>
    80004764:	87aa                	mv	a5,a0
    return -1;
    80004766:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004768:	0007c863          	bltz	a5,80004778 <sys_fstat+0x32>
  return filestat(f, st);
    8000476c:	fe043583          	ld	a1,-32(s0)
    80004770:	fe843503          	ld	a0,-24(s0)
    80004774:	c04ff0ef          	jal	80003b78 <filestat>
}
    80004778:	60e2                	ld	ra,24(sp)
    8000477a:	6442                	ld	s0,16(sp)
    8000477c:	6105                	addi	sp,sp,32
    8000477e:	8082                	ret

0000000080004780 <sys_link>:
{
    80004780:	7169                	addi	sp,sp,-304
    80004782:	f606                	sd	ra,296(sp)
    80004784:	f222                	sd	s0,288(sp)
    80004786:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004788:	08000613          	li	a2,128
    8000478c:	ed040593          	addi	a1,s0,-304
    80004790:	4501                	li	a0,0
    80004792:	949fd0ef          	jal	800020da <argstr>
    return -1;
    80004796:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004798:	0c054e63          	bltz	a0,80004874 <sys_link+0xf4>
    8000479c:	08000613          	li	a2,128
    800047a0:	f5040593          	addi	a1,s0,-176
    800047a4:	4505                	li	a0,1
    800047a6:	935fd0ef          	jal	800020da <argstr>
    return -1;
    800047aa:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047ac:	0c054463          	bltz	a0,80004874 <sys_link+0xf4>
    800047b0:	ee26                	sd	s1,280(sp)
  begin_op();
    800047b2:	ee1fe0ef          	jal	80003692 <begin_op>
  if((ip = namei(old)) == 0){
    800047b6:	ed040513          	addi	a0,s0,-304
    800047ba:	cfbfe0ef          	jal	800034b4 <namei>
    800047be:	84aa                	mv	s1,a0
    800047c0:	c53d                	beqz	a0,8000482e <sys_link+0xae>
  ilock(ip);
    800047c2:	cc4fe0ef          	jal	80002c86 <ilock>
  if(ip->type == T_DIR){
    800047c6:	04449703          	lh	a4,68(s1)
    800047ca:	4785                	li	a5,1
    800047cc:	06f70663          	beq	a4,a5,80004838 <sys_link+0xb8>
    800047d0:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800047d2:	04a4d783          	lhu	a5,74(s1)
    800047d6:	2785                	addiw	a5,a5,1
    800047d8:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800047dc:	8526                	mv	a0,s1
    800047de:	bf4fe0ef          	jal	80002bd2 <iupdate>
  iunlock(ip);
    800047e2:	8526                	mv	a0,s1
    800047e4:	d50fe0ef          	jal	80002d34 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800047e8:	fd040593          	addi	a1,s0,-48
    800047ec:	f5040513          	addi	a0,s0,-176
    800047f0:	cdffe0ef          	jal	800034ce <nameiparent>
    800047f4:	892a                	mv	s2,a0
    800047f6:	cd21                	beqz	a0,8000484e <sys_link+0xce>
  ilock(dp);
    800047f8:	c8efe0ef          	jal	80002c86 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800047fc:	854a                	mv	a0,s2
    800047fe:	00092703          	lw	a4,0(s2)
    80004802:	409c                	lw	a5,0(s1)
    80004804:	04f71263          	bne	a4,a5,80004848 <sys_link+0xc8>
    80004808:	40d0                	lw	a2,4(s1)
    8000480a:	fd040593          	addi	a1,s0,-48
    8000480e:	bfdfe0ef          	jal	8000340a <dirlink>
    80004812:	02054b63          	bltz	a0,80004848 <sys_link+0xc8>
  iunlockput(dp);
    80004816:	854a                	mv	a0,s2
    80004818:	e7afe0ef          	jal	80002e92 <iunlockput>
  iput(ip);
    8000481c:	8526                	mv	a0,s1
    8000481e:	deafe0ef          	jal	80002e08 <iput>
  end_op();
    80004822:	ee1fe0ef          	jal	80003702 <end_op>
  return 0;
    80004826:	4781                	li	a5,0
    80004828:	64f2                	ld	s1,280(sp)
    8000482a:	6952                	ld	s2,272(sp)
    8000482c:	a0a1                	j	80004874 <sys_link+0xf4>
    end_op();
    8000482e:	ed5fe0ef          	jal	80003702 <end_op>
    return -1;
    80004832:	57fd                	li	a5,-1
    80004834:	64f2                	ld	s1,280(sp)
    80004836:	a83d                	j	80004874 <sys_link+0xf4>
    iunlockput(ip);
    80004838:	8526                	mv	a0,s1
    8000483a:	e58fe0ef          	jal	80002e92 <iunlockput>
    end_op();
    8000483e:	ec5fe0ef          	jal	80003702 <end_op>
    return -1;
    80004842:	57fd                	li	a5,-1
    80004844:	64f2                	ld	s1,280(sp)
    80004846:	a03d                	j	80004874 <sys_link+0xf4>
    iunlockput(dp);
    80004848:	854a                	mv	a0,s2
    8000484a:	e48fe0ef          	jal	80002e92 <iunlockput>
  ilock(ip);
    8000484e:	8526                	mv	a0,s1
    80004850:	c36fe0ef          	jal	80002c86 <ilock>
  ip->nlink--;
    80004854:	04a4d783          	lhu	a5,74(s1)
    80004858:	37fd                	addiw	a5,a5,-1
    8000485a:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000485e:	8526                	mv	a0,s1
    80004860:	b72fe0ef          	jal	80002bd2 <iupdate>
  iunlockput(ip);
    80004864:	8526                	mv	a0,s1
    80004866:	e2cfe0ef          	jal	80002e92 <iunlockput>
  end_op();
    8000486a:	e99fe0ef          	jal	80003702 <end_op>
  return -1;
    8000486e:	57fd                	li	a5,-1
    80004870:	64f2                	ld	s1,280(sp)
    80004872:	6952                	ld	s2,272(sp)
}
    80004874:	853e                	mv	a0,a5
    80004876:	70b2                	ld	ra,296(sp)
    80004878:	7412                	ld	s0,288(sp)
    8000487a:	6155                	addi	sp,sp,304
    8000487c:	8082                	ret

000000008000487e <sys_unlink>:
{
    8000487e:	7151                	addi	sp,sp,-240
    80004880:	f586                	sd	ra,232(sp)
    80004882:	f1a2                	sd	s0,224(sp)
    80004884:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004886:	08000613          	li	a2,128
    8000488a:	f3040593          	addi	a1,s0,-208
    8000488e:	4501                	li	a0,0
    80004890:	84bfd0ef          	jal	800020da <argstr>
    80004894:	14054d63          	bltz	a0,800049ee <sys_unlink+0x170>
    80004898:	eda6                	sd	s1,216(sp)
  begin_op();
    8000489a:	df9fe0ef          	jal	80003692 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000489e:	fb040593          	addi	a1,s0,-80
    800048a2:	f3040513          	addi	a0,s0,-208
    800048a6:	c29fe0ef          	jal	800034ce <nameiparent>
    800048aa:	84aa                	mv	s1,a0
    800048ac:	c955                	beqz	a0,80004960 <sys_unlink+0xe2>
  ilock(dp);
    800048ae:	bd8fe0ef          	jal	80002c86 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048b2:	00003597          	auipc	a1,0x3
    800048b6:	d2658593          	addi	a1,a1,-730 # 800075d8 <etext+0x5d8>
    800048ba:	fb040513          	addi	a0,s0,-80
    800048be:	94dfe0ef          	jal	8000320a <namecmp>
    800048c2:	10050b63          	beqz	a0,800049d8 <sys_unlink+0x15a>
    800048c6:	00003597          	auipc	a1,0x3
    800048ca:	d1a58593          	addi	a1,a1,-742 # 800075e0 <etext+0x5e0>
    800048ce:	fb040513          	addi	a0,s0,-80
    800048d2:	939fe0ef          	jal	8000320a <namecmp>
    800048d6:	10050163          	beqz	a0,800049d8 <sys_unlink+0x15a>
    800048da:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800048dc:	f2c40613          	addi	a2,s0,-212
    800048e0:	fb040593          	addi	a1,s0,-80
    800048e4:	8526                	mv	a0,s1
    800048e6:	93bfe0ef          	jal	80003220 <dirlookup>
    800048ea:	892a                	mv	s2,a0
    800048ec:	0e050563          	beqz	a0,800049d6 <sys_unlink+0x158>
    800048f0:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800048f2:	b94fe0ef          	jal	80002c86 <ilock>
  if(ip->nlink < 1)
    800048f6:	04a91783          	lh	a5,74(s2)
    800048fa:	06f05863          	blez	a5,8000496a <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800048fe:	04491703          	lh	a4,68(s2)
    80004902:	4785                	li	a5,1
    80004904:	06f70963          	beq	a4,a5,80004976 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004908:	fc040993          	addi	s3,s0,-64
    8000490c:	4641                	li	a2,16
    8000490e:	4581                	li	a1,0
    80004910:	854e                	mv	a0,s3
    80004912:	84dfb0ef          	jal	8000015e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004916:	4741                	li	a4,16
    80004918:	f2c42683          	lw	a3,-212(s0)
    8000491c:	864e                	mv	a2,s3
    8000491e:	4581                	li	a1,0
    80004920:	8526                	mv	a0,s1
    80004922:	fe8fe0ef          	jal	8000310a <writei>
    80004926:	47c1                	li	a5,16
    80004928:	08f51863          	bne	a0,a5,800049b8 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    8000492c:	04491703          	lh	a4,68(s2)
    80004930:	4785                	li	a5,1
    80004932:	08f70963          	beq	a4,a5,800049c4 <sys_unlink+0x146>
  iunlockput(dp);
    80004936:	8526                	mv	a0,s1
    80004938:	d5afe0ef          	jal	80002e92 <iunlockput>
  ip->nlink--;
    8000493c:	04a95783          	lhu	a5,74(s2)
    80004940:	37fd                	addiw	a5,a5,-1
    80004942:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004946:	854a                	mv	a0,s2
    80004948:	a8afe0ef          	jal	80002bd2 <iupdate>
  iunlockput(ip);
    8000494c:	854a                	mv	a0,s2
    8000494e:	d44fe0ef          	jal	80002e92 <iunlockput>
  end_op();
    80004952:	db1fe0ef          	jal	80003702 <end_op>
  return 0;
    80004956:	4501                	li	a0,0
    80004958:	64ee                	ld	s1,216(sp)
    8000495a:	694e                	ld	s2,208(sp)
    8000495c:	69ae                	ld	s3,200(sp)
    8000495e:	a061                	j	800049e6 <sys_unlink+0x168>
    end_op();
    80004960:	da3fe0ef          	jal	80003702 <end_op>
    return -1;
    80004964:	557d                	li	a0,-1
    80004966:	64ee                	ld	s1,216(sp)
    80004968:	a8bd                	j	800049e6 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000496a:	00003517          	auipc	a0,0x3
    8000496e:	c7e50513          	addi	a0,a0,-898 # 800075e8 <etext+0x5e8>
    80004972:	2f4010ef          	jal	80005c66 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004976:	04c92703          	lw	a4,76(s2)
    8000497a:	02000793          	li	a5,32
    8000497e:	f8e7f5e3          	bgeu	a5,a4,80004908 <sys_unlink+0x8a>
    80004982:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004984:	4741                	li	a4,16
    80004986:	86ce                	mv	a3,s3
    80004988:	f1840613          	addi	a2,s0,-232
    8000498c:	4581                	li	a1,0
    8000498e:	854a                	mv	a0,s2
    80004990:	e88fe0ef          	jal	80003018 <readi>
    80004994:	47c1                	li	a5,16
    80004996:	00f51b63          	bne	a0,a5,800049ac <sys_unlink+0x12e>
    if(de.inum != 0)
    8000499a:	f1845783          	lhu	a5,-232(s0)
    8000499e:	ebb1                	bnez	a5,800049f2 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049a0:	29c1                	addiw	s3,s3,16
    800049a2:	04c92783          	lw	a5,76(s2)
    800049a6:	fcf9efe3          	bltu	s3,a5,80004984 <sys_unlink+0x106>
    800049aa:	bfb9                	j	80004908 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800049ac:	00003517          	auipc	a0,0x3
    800049b0:	c5450513          	addi	a0,a0,-940 # 80007600 <etext+0x600>
    800049b4:	2b2010ef          	jal	80005c66 <panic>
    panic("unlink: writei");
    800049b8:	00003517          	auipc	a0,0x3
    800049bc:	c6050513          	addi	a0,a0,-928 # 80007618 <etext+0x618>
    800049c0:	2a6010ef          	jal	80005c66 <panic>
    dp->nlink--;
    800049c4:	04a4d783          	lhu	a5,74(s1)
    800049c8:	37fd                	addiw	a5,a5,-1
    800049ca:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800049ce:	8526                	mv	a0,s1
    800049d0:	a02fe0ef          	jal	80002bd2 <iupdate>
    800049d4:	b78d                	j	80004936 <sys_unlink+0xb8>
    800049d6:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800049d8:	8526                	mv	a0,s1
    800049da:	cb8fe0ef          	jal	80002e92 <iunlockput>
  end_op();
    800049de:	d25fe0ef          	jal	80003702 <end_op>
  return -1;
    800049e2:	557d                	li	a0,-1
    800049e4:	64ee                	ld	s1,216(sp)
}
    800049e6:	70ae                	ld	ra,232(sp)
    800049e8:	740e                	ld	s0,224(sp)
    800049ea:	616d                	addi	sp,sp,240
    800049ec:	8082                	ret
    return -1;
    800049ee:	557d                	li	a0,-1
    800049f0:	bfdd                	j	800049e6 <sys_unlink+0x168>
    iunlockput(ip);
    800049f2:	854a                	mv	a0,s2
    800049f4:	c9efe0ef          	jal	80002e92 <iunlockput>
    goto bad;
    800049f8:	694e                	ld	s2,208(sp)
    800049fa:	69ae                	ld	s3,200(sp)
    800049fc:	bff1                	j	800049d8 <sys_unlink+0x15a>

00000000800049fe <sys_open>:

uint64
sys_open(void)
{
    800049fe:	7131                	addi	sp,sp,-192
    80004a00:	fd06                	sd	ra,184(sp)
    80004a02:	f922                	sd	s0,176(sp)
    80004a04:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a06:	f4c40593          	addi	a1,s0,-180
    80004a0a:	4505                	li	a0,1
    80004a0c:	e96fd0ef          	jal	800020a2 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a10:	08000613          	li	a2,128
    80004a14:	f5040593          	addi	a1,s0,-176
    80004a18:	4501                	li	a0,0
    80004a1a:	ec0fd0ef          	jal	800020da <argstr>
    80004a1e:	87aa                	mv	a5,a0
    return -1;
    80004a20:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a22:	0a07c363          	bltz	a5,80004ac8 <sys_open+0xca>
    80004a26:	f526                	sd	s1,168(sp)

  begin_op();
    80004a28:	c6bfe0ef          	jal	80003692 <begin_op>

  if(omode & O_CREATE){
    80004a2c:	f4c42783          	lw	a5,-180(s0)
    80004a30:	2007f793          	andi	a5,a5,512
    80004a34:	c3dd                	beqz	a5,80004ada <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004a36:	4681                	li	a3,0
    80004a38:	4601                	li	a2,0
    80004a3a:	4589                	li	a1,2
    80004a3c:	f5040513          	addi	a0,s0,-176
    80004a40:	aafff0ef          	jal	800044ee <create>
    80004a44:	84aa                	mv	s1,a0
    if(ip == 0){
    80004a46:	c549                	beqz	a0,80004ad0 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004a48:	04449703          	lh	a4,68(s1)
    80004a4c:	478d                	li	a5,3
    80004a4e:	00f71763          	bne	a4,a5,80004a5c <sys_open+0x5e>
    80004a52:	0464d703          	lhu	a4,70(s1)
    80004a56:	47a5                	li	a5,9
    80004a58:	0ae7ee63          	bltu	a5,a4,80004b14 <sys_open+0x116>
    80004a5c:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004a5e:	fb5fe0ef          	jal	80003a12 <filealloc>
    80004a62:	892a                	mv	s2,a0
    80004a64:	c561                	beqz	a0,80004b2c <sys_open+0x12e>
    80004a66:	ed4e                	sd	s3,152(sp)
    80004a68:	a47ff0ef          	jal	800044ae <fdalloc>
    80004a6c:	89aa                	mv	s3,a0
    80004a6e:	0a054b63          	bltz	a0,80004b24 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004a72:	04449703          	lh	a4,68(s1)
    80004a76:	478d                	li	a5,3
    80004a78:	0cf70363          	beq	a4,a5,80004b3e <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004a7c:	4789                	li	a5,2
    80004a7e:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004a82:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004a86:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004a8a:	f4c42783          	lw	a5,-180(s0)
    80004a8e:	0017f713          	andi	a4,a5,1
    80004a92:	00174713          	xori	a4,a4,1
    80004a96:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004a9a:	0037f713          	andi	a4,a5,3
    80004a9e:	00e03733          	snez	a4,a4
    80004aa2:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004aa6:	4007f793          	andi	a5,a5,1024
    80004aaa:	c791                	beqz	a5,80004ab6 <sys_open+0xb8>
    80004aac:	04449703          	lh	a4,68(s1)
    80004ab0:	4789                	li	a5,2
    80004ab2:	08f70d63          	beq	a4,a5,80004b4c <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	a7cfe0ef          	jal	80002d34 <iunlock>
  end_op();
    80004abc:	c47fe0ef          	jal	80003702 <end_op>

  return fd;
    80004ac0:	854e                	mv	a0,s3
    80004ac2:	74aa                	ld	s1,168(sp)
    80004ac4:	790a                	ld	s2,160(sp)
    80004ac6:	69ea                	ld	s3,152(sp)
}
    80004ac8:	70ea                	ld	ra,184(sp)
    80004aca:	744a                	ld	s0,176(sp)
    80004acc:	6129                	addi	sp,sp,192
    80004ace:	8082                	ret
      end_op();
    80004ad0:	c33fe0ef          	jal	80003702 <end_op>
      return -1;
    80004ad4:	557d                	li	a0,-1
    80004ad6:	74aa                	ld	s1,168(sp)
    80004ad8:	bfc5                	j	80004ac8 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004ada:	f5040513          	addi	a0,s0,-176
    80004ade:	9d7fe0ef          	jal	800034b4 <namei>
    80004ae2:	84aa                	mv	s1,a0
    80004ae4:	c11d                	beqz	a0,80004b0a <sys_open+0x10c>
    ilock(ip);
    80004ae6:	9a0fe0ef          	jal	80002c86 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004aea:	04449703          	lh	a4,68(s1)
    80004aee:	4785                	li	a5,1
    80004af0:	f4f71ce3          	bne	a4,a5,80004a48 <sys_open+0x4a>
    80004af4:	f4c42783          	lw	a5,-180(s0)
    80004af8:	d3b5                	beqz	a5,80004a5c <sys_open+0x5e>
      iunlockput(ip);
    80004afa:	8526                	mv	a0,s1
    80004afc:	b96fe0ef          	jal	80002e92 <iunlockput>
      end_op();
    80004b00:	c03fe0ef          	jal	80003702 <end_op>
      return -1;
    80004b04:	557d                	li	a0,-1
    80004b06:	74aa                	ld	s1,168(sp)
    80004b08:	b7c1                	j	80004ac8 <sys_open+0xca>
      end_op();
    80004b0a:	bf9fe0ef          	jal	80003702 <end_op>
      return -1;
    80004b0e:	557d                	li	a0,-1
    80004b10:	74aa                	ld	s1,168(sp)
    80004b12:	bf5d                	j	80004ac8 <sys_open+0xca>
    iunlockput(ip);
    80004b14:	8526                	mv	a0,s1
    80004b16:	b7cfe0ef          	jal	80002e92 <iunlockput>
    end_op();
    80004b1a:	be9fe0ef          	jal	80003702 <end_op>
    return -1;
    80004b1e:	557d                	li	a0,-1
    80004b20:	74aa                	ld	s1,168(sp)
    80004b22:	b75d                	j	80004ac8 <sys_open+0xca>
      fileclose(f);
    80004b24:	854a                	mv	a0,s2
    80004b26:	f91fe0ef          	jal	80003ab6 <fileclose>
    80004b2a:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004b2c:	8526                	mv	a0,s1
    80004b2e:	b64fe0ef          	jal	80002e92 <iunlockput>
    end_op();
    80004b32:	bd1fe0ef          	jal	80003702 <end_op>
    return -1;
    80004b36:	557d                	li	a0,-1
    80004b38:	74aa                	ld	s1,168(sp)
    80004b3a:	790a                	ld	s2,160(sp)
    80004b3c:	b771                	j	80004ac8 <sys_open+0xca>
    f->type = FD_DEVICE;
    80004b3e:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004b42:	04649783          	lh	a5,70(s1)
    80004b46:	02f91223          	sh	a5,36(s2)
    80004b4a:	bf35                	j	80004a86 <sys_open+0x88>
    itrunc(ip);
    80004b4c:	8526                	mv	a0,s1
    80004b4e:	a26fe0ef          	jal	80002d74 <itrunc>
    80004b52:	b795                	j	80004ab6 <sys_open+0xb8>

0000000080004b54 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004b54:	7175                	addi	sp,sp,-144
    80004b56:	e506                	sd	ra,136(sp)
    80004b58:	e122                	sd	s0,128(sp)
    80004b5a:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004b5c:	b37fe0ef          	jal	80003692 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004b60:	08000613          	li	a2,128
    80004b64:	f7040593          	addi	a1,s0,-144
    80004b68:	4501                	li	a0,0
    80004b6a:	d70fd0ef          	jal	800020da <argstr>
    80004b6e:	02054363          	bltz	a0,80004b94 <sys_mkdir+0x40>
    80004b72:	4681                	li	a3,0
    80004b74:	4601                	li	a2,0
    80004b76:	4585                	li	a1,1
    80004b78:	f7040513          	addi	a0,s0,-144
    80004b7c:	973ff0ef          	jal	800044ee <create>
    80004b80:	c911                	beqz	a0,80004b94 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004b82:	b10fe0ef          	jal	80002e92 <iunlockput>
  end_op();
    80004b86:	b7dfe0ef          	jal	80003702 <end_op>
  return 0;
    80004b8a:	4501                	li	a0,0
}
    80004b8c:	60aa                	ld	ra,136(sp)
    80004b8e:	640a                	ld	s0,128(sp)
    80004b90:	6149                	addi	sp,sp,144
    80004b92:	8082                	ret
    end_op();
    80004b94:	b6ffe0ef          	jal	80003702 <end_op>
    return -1;
    80004b98:	557d                	li	a0,-1
    80004b9a:	bfcd                	j	80004b8c <sys_mkdir+0x38>

0000000080004b9c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004b9c:	7135                	addi	sp,sp,-160
    80004b9e:	ed06                	sd	ra,152(sp)
    80004ba0:	e922                	sd	s0,144(sp)
    80004ba2:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004ba4:	aeffe0ef          	jal	80003692 <begin_op>
  argint(1, &major);
    80004ba8:	f6c40593          	addi	a1,s0,-148
    80004bac:	4505                	li	a0,1
    80004bae:	cf4fd0ef          	jal	800020a2 <argint>
  argint(2, &minor);
    80004bb2:	f6840593          	addi	a1,s0,-152
    80004bb6:	4509                	li	a0,2
    80004bb8:	ceafd0ef          	jal	800020a2 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004bbc:	08000613          	li	a2,128
    80004bc0:	f7040593          	addi	a1,s0,-144
    80004bc4:	4501                	li	a0,0
    80004bc6:	d14fd0ef          	jal	800020da <argstr>
    80004bca:	02054563          	bltz	a0,80004bf4 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004bce:	f6841683          	lh	a3,-152(s0)
    80004bd2:	f6c41603          	lh	a2,-148(s0)
    80004bd6:	458d                	li	a1,3
    80004bd8:	f7040513          	addi	a0,s0,-144
    80004bdc:	913ff0ef          	jal	800044ee <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004be0:	c911                	beqz	a0,80004bf4 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004be2:	ab0fe0ef          	jal	80002e92 <iunlockput>
  end_op();
    80004be6:	b1dfe0ef          	jal	80003702 <end_op>
  return 0;
    80004bea:	4501                	li	a0,0
}
    80004bec:	60ea                	ld	ra,152(sp)
    80004bee:	644a                	ld	s0,144(sp)
    80004bf0:	610d                	addi	sp,sp,160
    80004bf2:	8082                	ret
    end_op();
    80004bf4:	b0ffe0ef          	jal	80003702 <end_op>
    return -1;
    80004bf8:	557d                	li	a0,-1
    80004bfa:	bfcd                	j	80004bec <sys_mknod+0x50>

0000000080004bfc <sys_chdir>:

uint64
sys_chdir(void)
{
    80004bfc:	7135                	addi	sp,sp,-160
    80004bfe:	ed06                	sd	ra,152(sp)
    80004c00:	e922                	sd	s0,144(sp)
    80004c02:	e14a                	sd	s2,128(sp)
    80004c04:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004c06:	ceafc0ef          	jal	800010f0 <myproc>
    80004c0a:	892a                	mv	s2,a0
  
  begin_op();
    80004c0c:	a87fe0ef          	jal	80003692 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004c10:	08000613          	li	a2,128
    80004c14:	f6040593          	addi	a1,s0,-160
    80004c18:	4501                	li	a0,0
    80004c1a:	cc0fd0ef          	jal	800020da <argstr>
    80004c1e:	04054363          	bltz	a0,80004c64 <sys_chdir+0x68>
    80004c22:	e526                	sd	s1,136(sp)
    80004c24:	f6040513          	addi	a0,s0,-160
    80004c28:	88dfe0ef          	jal	800034b4 <namei>
    80004c2c:	84aa                	mv	s1,a0
    80004c2e:	c915                	beqz	a0,80004c62 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004c30:	856fe0ef          	jal	80002c86 <ilock>
  if(ip->type != T_DIR){
    80004c34:	04449703          	lh	a4,68(s1)
    80004c38:	4785                	li	a5,1
    80004c3a:	02f71963          	bne	a4,a5,80004c6c <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004c3e:	8526                	mv	a0,s1
    80004c40:	8f4fe0ef          	jal	80002d34 <iunlock>
  iput(p->cwd);
    80004c44:	15093503          	ld	a0,336(s2)
    80004c48:	9c0fe0ef          	jal	80002e08 <iput>
  end_op();
    80004c4c:	ab7fe0ef          	jal	80003702 <end_op>
  p->cwd = ip;
    80004c50:	14993823          	sd	s1,336(s2)
  return 0;
    80004c54:	4501                	li	a0,0
    80004c56:	64aa                	ld	s1,136(sp)
}
    80004c58:	60ea                	ld	ra,152(sp)
    80004c5a:	644a                	ld	s0,144(sp)
    80004c5c:	690a                	ld	s2,128(sp)
    80004c5e:	610d                	addi	sp,sp,160
    80004c60:	8082                	ret
    80004c62:	64aa                	ld	s1,136(sp)
    end_op();
    80004c64:	a9ffe0ef          	jal	80003702 <end_op>
    return -1;
    80004c68:	557d                	li	a0,-1
    80004c6a:	b7fd                	j	80004c58 <sys_chdir+0x5c>
    iunlockput(ip);
    80004c6c:	8526                	mv	a0,s1
    80004c6e:	a24fe0ef          	jal	80002e92 <iunlockput>
    end_op();
    80004c72:	a91fe0ef          	jal	80003702 <end_op>
    return -1;
    80004c76:	557d                	li	a0,-1
    80004c78:	64aa                	ld	s1,136(sp)
    80004c7a:	bff9                	j	80004c58 <sys_chdir+0x5c>

0000000080004c7c <sys_exec>:

uint64
sys_exec(void)
{
    80004c7c:	7105                	addi	sp,sp,-480
    80004c7e:	ef86                	sd	ra,472(sp)
    80004c80:	eba2                	sd	s0,464(sp)
    80004c82:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004c84:	e2840593          	addi	a1,s0,-472
    80004c88:	4505                	li	a0,1
    80004c8a:	c34fd0ef          	jal	800020be <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004c8e:	08000613          	li	a2,128
    80004c92:	f3040593          	addi	a1,s0,-208
    80004c96:	4501                	li	a0,0
    80004c98:	c42fd0ef          	jal	800020da <argstr>
    80004c9c:	87aa                	mv	a5,a0
    return -1;
    80004c9e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004ca0:	0e07c063          	bltz	a5,80004d80 <sys_exec+0x104>
    80004ca4:	e7a6                	sd	s1,456(sp)
    80004ca6:	e3ca                	sd	s2,448(sp)
    80004ca8:	ff4e                	sd	s3,440(sp)
    80004caa:	fb52                	sd	s4,432(sp)
    80004cac:	f756                	sd	s5,424(sp)
    80004cae:	f35a                	sd	s6,416(sp)
    80004cb0:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004cb2:	e3040a13          	addi	s4,s0,-464
    80004cb6:	10000613          	li	a2,256
    80004cba:	4581                	li	a1,0
    80004cbc:	8552                	mv	a0,s4
    80004cbe:	ca0fb0ef          	jal	8000015e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004cc2:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004cc4:	89d2                	mv	s3,s4
    80004cc6:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004cc8:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004ccc:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004cce:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004cd2:	00391513          	slli	a0,s2,0x3
    80004cd6:	85d6                	mv	a1,s5
    80004cd8:	e2843783          	ld	a5,-472(s0)
    80004cdc:	953e                	add	a0,a0,a5
    80004cde:	b3afd0ef          	jal	80002018 <fetchaddr>
    80004ce2:	02054663          	bltz	a0,80004d0e <sys_exec+0x92>
    if(uarg == 0){
    80004ce6:	e2043783          	ld	a5,-480(s0)
    80004cea:	c7a1                	beqz	a5,80004d32 <sys_exec+0xb6>
    argv[i] = kalloc();
    80004cec:	c18fb0ef          	jal	80000104 <kalloc>
    80004cf0:	85aa                	mv	a1,a0
    80004cf2:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004cf6:	cd01                	beqz	a0,80004d0e <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004cf8:	865a                	mv	a2,s6
    80004cfa:	e2043503          	ld	a0,-480(s0)
    80004cfe:	b64fd0ef          	jal	80002062 <fetchstr>
    80004d02:	00054663          	bltz	a0,80004d0e <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004d06:	0905                	addi	s2,s2,1
    80004d08:	09a1                	addi	s3,s3,8
    80004d0a:	fd7914e3          	bne	s2,s7,80004cd2 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004d0e:	100a0a13          	addi	s4,s4,256
    80004d12:	6088                	ld	a0,0(s1)
    80004d14:	cd31                	beqz	a0,80004d70 <sys_exec+0xf4>
    kfree(argv[i]);
    80004d16:	b06fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004d1a:	04a1                	addi	s1,s1,8
    80004d1c:	ff449be3          	bne	s1,s4,80004d12 <sys_exec+0x96>
  return -1;
    80004d20:	557d                	li	a0,-1
    80004d22:	64be                	ld	s1,456(sp)
    80004d24:	691e                	ld	s2,448(sp)
    80004d26:	79fa                	ld	s3,440(sp)
    80004d28:	7a5a                	ld	s4,432(sp)
    80004d2a:	7aba                	ld	s5,424(sp)
    80004d2c:	7b1a                	ld	s6,416(sp)
    80004d2e:	6bfa                	ld	s7,408(sp)
    80004d30:	a881                	j	80004d80 <sys_exec+0x104>
      argv[i] = 0;
    80004d32:	0009079b          	sext.w	a5,s2
    80004d36:	e3040593          	addi	a1,s0,-464
    80004d3a:	078e                	slli	a5,a5,0x3
    80004d3c:	97ae                	add	a5,a5,a1
    80004d3e:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004d42:	f3040513          	addi	a0,s0,-208
    80004d46:	bb2ff0ef          	jal	800040f8 <kexec>
    80004d4a:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004d4c:	100a0a13          	addi	s4,s4,256
    80004d50:	6088                	ld	a0,0(s1)
    80004d52:	c511                	beqz	a0,80004d5e <sys_exec+0xe2>
    kfree(argv[i]);
    80004d54:	ac8fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004d58:	04a1                	addi	s1,s1,8
    80004d5a:	ff449be3          	bne	s1,s4,80004d50 <sys_exec+0xd4>
  return ret;
    80004d5e:	854a                	mv	a0,s2
    80004d60:	64be                	ld	s1,456(sp)
    80004d62:	691e                	ld	s2,448(sp)
    80004d64:	79fa                	ld	s3,440(sp)
    80004d66:	7a5a                	ld	s4,432(sp)
    80004d68:	7aba                	ld	s5,424(sp)
    80004d6a:	7b1a                	ld	s6,416(sp)
    80004d6c:	6bfa                	ld	s7,408(sp)
    80004d6e:	a809                	j	80004d80 <sys_exec+0x104>
  return -1;
    80004d70:	557d                	li	a0,-1
    80004d72:	64be                	ld	s1,456(sp)
    80004d74:	691e                	ld	s2,448(sp)
    80004d76:	79fa                	ld	s3,440(sp)
    80004d78:	7a5a                	ld	s4,432(sp)
    80004d7a:	7aba                	ld	s5,424(sp)
    80004d7c:	7b1a                	ld	s6,416(sp)
    80004d7e:	6bfa                	ld	s7,408(sp)
}
    80004d80:	60fe                	ld	ra,472(sp)
    80004d82:	645e                	ld	s0,464(sp)
    80004d84:	613d                	addi	sp,sp,480
    80004d86:	8082                	ret

0000000080004d88 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004d88:	7139                	addi	sp,sp,-64
    80004d8a:	fc06                	sd	ra,56(sp)
    80004d8c:	f822                	sd	s0,48(sp)
    80004d8e:	f426                	sd	s1,40(sp)
    80004d90:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004d92:	b5efc0ef          	jal	800010f0 <myproc>
    80004d96:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004d98:	fd840593          	addi	a1,s0,-40
    80004d9c:	4501                	li	a0,0
    80004d9e:	b20fd0ef          	jal	800020be <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004da2:	fc840593          	addi	a1,s0,-56
    80004da6:	fd040513          	addi	a0,s0,-48
    80004daa:	828ff0ef          	jal	80003dd2 <pipealloc>
    return -1;
    80004dae:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004db0:	0a054763          	bltz	a0,80004e5e <sys_pipe+0xd6>
  fd0 = -1;
    80004db4:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004db8:	fd043503          	ld	a0,-48(s0)
    80004dbc:	ef2ff0ef          	jal	800044ae <fdalloc>
    80004dc0:	fca42223          	sw	a0,-60(s0)
    80004dc4:	08054463          	bltz	a0,80004e4c <sys_pipe+0xc4>
    80004dc8:	fc843503          	ld	a0,-56(s0)
    80004dcc:	ee2ff0ef          	jal	800044ae <fdalloc>
    80004dd0:	fca42023          	sw	a0,-64(s0)
    80004dd4:	06054263          	bltz	a0,80004e38 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004dd8:	4691                	li	a3,4
    80004dda:	fc440613          	addi	a2,s0,-60
    80004dde:	fd843583          	ld	a1,-40(s0)
    80004de2:	68a8                	ld	a0,80(s1)
    80004de4:	e2ffb0ef          	jal	80000c12 <copyout>
    80004de8:	00054e63          	bltz	a0,80004e04 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004dec:	4691                	li	a3,4
    80004dee:	fc040613          	addi	a2,s0,-64
    80004df2:	fd843583          	ld	a1,-40(s0)
    80004df6:	95b6                	add	a1,a1,a3
    80004df8:	68a8                	ld	a0,80(s1)
    80004dfa:	e19fb0ef          	jal	80000c12 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004dfe:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004e00:	04055f63          	bgez	a0,80004e5e <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80004e04:	fc442783          	lw	a5,-60(s0)
    80004e08:	078e                	slli	a5,a5,0x3
    80004e0a:	0d078793          	addi	a5,a5,208
    80004e0e:	97a6                	add	a5,a5,s1
    80004e10:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004e14:	fc042783          	lw	a5,-64(s0)
    80004e18:	078e                	slli	a5,a5,0x3
    80004e1a:	0d078793          	addi	a5,a5,208
    80004e1e:	97a6                	add	a5,a5,s1
    80004e20:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004e24:	fd043503          	ld	a0,-48(s0)
    80004e28:	c8ffe0ef          	jal	80003ab6 <fileclose>
    fileclose(wf);
    80004e2c:	fc843503          	ld	a0,-56(s0)
    80004e30:	c87fe0ef          	jal	80003ab6 <fileclose>
    return -1;
    80004e34:	57fd                	li	a5,-1
    80004e36:	a025                	j	80004e5e <sys_pipe+0xd6>
    if(fd0 >= 0)
    80004e38:	fc442783          	lw	a5,-60(s0)
    80004e3c:	0007c863          	bltz	a5,80004e4c <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004e40:	078e                	slli	a5,a5,0x3
    80004e42:	0d078793          	addi	a5,a5,208
    80004e46:	97a6                	add	a5,a5,s1
    80004e48:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004e4c:	fd043503          	ld	a0,-48(s0)
    80004e50:	c67fe0ef          	jal	80003ab6 <fileclose>
    fileclose(wf);
    80004e54:	fc843503          	ld	a0,-56(s0)
    80004e58:	c5ffe0ef          	jal	80003ab6 <fileclose>
    return -1;
    80004e5c:	57fd                	li	a5,-1
}
    80004e5e:	853e                	mv	a0,a5
    80004e60:	70e2                	ld	ra,56(sp)
    80004e62:	7442                	ld	s0,48(sp)
    80004e64:	74a2                	ld	s1,40(sp)
    80004e66:	6121                	addi	sp,sp,64
    80004e68:	8082                	ret
    80004e6a:	0000                	unimp
    80004e6c:	0000                	unimp
	...

0000000080004e70 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004e70:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004e72:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004e74:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004e76:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004e78:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80004e7a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80004e7c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80004e7e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004e80:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004e82:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004e84:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004e86:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004e88:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80004e8a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80004e8c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80004e8e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004e90:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004e92:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004e94:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004e96:	890fd0ef          	jal	80001f26 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80004e9a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80004e9c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80004e9e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004ea0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004ea2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004ea4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004ea6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004ea8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80004eaa:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80004eac:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80004eae:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004eb0:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004eb2:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004eb4:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004eb6:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004eb8:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80004eba:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80004ebc:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80004ebe:	10200073          	sret
    80004ec2:	00000013          	nop
    80004ec6:	00000013          	nop
    80004eca:	00000013          	nop

0000000080004ece <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004ece:	1141                	addi	sp,sp,-16
    80004ed0:	e406                	sd	ra,8(sp)
    80004ed2:	e022                	sd	s0,0(sp)
    80004ed4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004ed6:	0c000737          	lui	a4,0xc000
    80004eda:	4785                	li	a5,1
    80004edc:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004ede:	c35c                	sw	a5,4(a4)
}
    80004ee0:	60a2                	ld	ra,8(sp)
    80004ee2:	6402                	ld	s0,0(sp)
    80004ee4:	0141                	addi	sp,sp,16
    80004ee6:	8082                	ret

0000000080004ee8 <plicinithart>:

void
plicinithart(void)
{
    80004ee8:	1141                	addi	sp,sp,-16
    80004eea:	e406                	sd	ra,8(sp)
    80004eec:	e022                	sd	s0,0(sp)
    80004eee:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ef0:	9ccfc0ef          	jal	800010bc <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004ef4:	0085171b          	slliw	a4,a0,0x8
    80004ef8:	0c0027b7          	lui	a5,0xc002
    80004efc:	97ba                	add	a5,a5,a4
    80004efe:	40200713          	li	a4,1026
    80004f02:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004f06:	00d5151b          	slliw	a0,a0,0xd
    80004f0a:	0c2017b7          	lui	a5,0xc201
    80004f0e:	97aa                	add	a5,a5,a0
    80004f10:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004f14:	60a2                	ld	ra,8(sp)
    80004f16:	6402                	ld	s0,0(sp)
    80004f18:	0141                	addi	sp,sp,16
    80004f1a:	8082                	ret

0000000080004f1c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004f1c:	1141                	addi	sp,sp,-16
    80004f1e:	e406                	sd	ra,8(sp)
    80004f20:	e022                	sd	s0,0(sp)
    80004f22:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004f24:	998fc0ef          	jal	800010bc <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004f28:	00d5151b          	slliw	a0,a0,0xd
    80004f2c:	0c2017b7          	lui	a5,0xc201
    80004f30:	97aa                	add	a5,a5,a0
  return irq;
}
    80004f32:	43c8                	lw	a0,4(a5)
    80004f34:	60a2                	ld	ra,8(sp)
    80004f36:	6402                	ld	s0,0(sp)
    80004f38:	0141                	addi	sp,sp,16
    80004f3a:	8082                	ret

0000000080004f3c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004f3c:	1101                	addi	sp,sp,-32
    80004f3e:	ec06                	sd	ra,24(sp)
    80004f40:	e822                	sd	s0,16(sp)
    80004f42:	e426                	sd	s1,8(sp)
    80004f44:	1000                	addi	s0,sp,32
    80004f46:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004f48:	974fc0ef          	jal	800010bc <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004f4c:	00d5179b          	slliw	a5,a0,0xd
    80004f50:	0c201737          	lui	a4,0xc201
    80004f54:	97ba                	add	a5,a5,a4
    80004f56:	c3c4                	sw	s1,4(a5)
}
    80004f58:	60e2                	ld	ra,24(sp)
    80004f5a:	6442                	ld	s0,16(sp)
    80004f5c:	64a2                	ld	s1,8(sp)
    80004f5e:	6105                	addi	sp,sp,32
    80004f60:	8082                	ret

0000000080004f62 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004f62:	1141                	addi	sp,sp,-16
    80004f64:	e406                	sd	ra,8(sp)
    80004f66:	e022                	sd	s0,0(sp)
    80004f68:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004f6a:	479d                	li	a5,7
    80004f6c:	04a7ca63          	blt	a5,a0,80004fc0 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004f70:	00020797          	auipc	a5,0x20
    80004f74:	c7078793          	addi	a5,a5,-912 # 80024be0 <disk>
    80004f78:	97aa                	add	a5,a5,a0
    80004f7a:	0187c783          	lbu	a5,24(a5)
    80004f7e:	e7b9                	bnez	a5,80004fcc <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004f80:	00451693          	slli	a3,a0,0x4
    80004f84:	00020797          	auipc	a5,0x20
    80004f88:	c5c78793          	addi	a5,a5,-932 # 80024be0 <disk>
    80004f8c:	6398                	ld	a4,0(a5)
    80004f8e:	9736                	add	a4,a4,a3
    80004f90:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004f94:	6398                	ld	a4,0(a5)
    80004f96:	9736                	add	a4,a4,a3
    80004f98:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004f9c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004fa0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004fa4:	97aa                	add	a5,a5,a0
    80004fa6:	4705                	li	a4,1
    80004fa8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004fac:	00020517          	auipc	a0,0x20
    80004fb0:	c4c50513          	addi	a0,a0,-948 # 80024bf8 <disk+0x18>
    80004fb4:	fcefc0ef          	jal	80001782 <wakeup>
}
    80004fb8:	60a2                	ld	ra,8(sp)
    80004fba:	6402                	ld	s0,0(sp)
    80004fbc:	0141                	addi	sp,sp,16
    80004fbe:	8082                	ret
    panic("free_desc 1");
    80004fc0:	00002517          	auipc	a0,0x2
    80004fc4:	66850513          	addi	a0,a0,1640 # 80007628 <etext+0x628>
    80004fc8:	49f000ef          	jal	80005c66 <panic>
    panic("free_desc 2");
    80004fcc:	00002517          	auipc	a0,0x2
    80004fd0:	66c50513          	addi	a0,a0,1644 # 80007638 <etext+0x638>
    80004fd4:	493000ef          	jal	80005c66 <panic>

0000000080004fd8 <virtio_disk_init>:
{
    80004fd8:	1101                	addi	sp,sp,-32
    80004fda:	ec06                	sd	ra,24(sp)
    80004fdc:	e822                	sd	s0,16(sp)
    80004fde:	e426                	sd	s1,8(sp)
    80004fe0:	e04a                	sd	s2,0(sp)
    80004fe2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004fe4:	00002597          	auipc	a1,0x2
    80004fe8:	66458593          	addi	a1,a1,1636 # 80007648 <etext+0x648>
    80004fec:	00020517          	auipc	a0,0x20
    80004ff0:	d1c50513          	addi	a0,a0,-740 # 80024d08 <disk+0x128>
    80004ff4:	6ab000ef          	jal	80005e9e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004ff8:	100017b7          	lui	a5,0x10001
    80004ffc:	4398                	lw	a4,0(a5)
    80004ffe:	2701                	sext.w	a4,a4
    80005000:	747277b7          	lui	a5,0x74727
    80005004:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005008:	14f71863          	bne	a4,a5,80005158 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000500c:	100017b7          	lui	a5,0x10001
    80005010:	43dc                	lw	a5,4(a5)
    80005012:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005014:	4709                	li	a4,2
    80005016:	14e79163          	bne	a5,a4,80005158 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000501a:	100017b7          	lui	a5,0x10001
    8000501e:	479c                	lw	a5,8(a5)
    80005020:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005022:	12e79b63          	bne	a5,a4,80005158 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005026:	100017b7          	lui	a5,0x10001
    8000502a:	47d8                	lw	a4,12(a5)
    8000502c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000502e:	554d47b7          	lui	a5,0x554d4
    80005032:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005036:	12f71163          	bne	a4,a5,80005158 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000503a:	100017b7          	lui	a5,0x10001
    8000503e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005042:	4705                	li	a4,1
    80005044:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005046:	470d                	li	a4,3
    80005048:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000504a:	10001737          	lui	a4,0x10001
    8000504e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005050:	c7ffe6b7          	lui	a3,0xc7ffe
    80005054:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fd1967>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80005058:	8f75                	and	a4,a4,a3
    8000505a:	100016b7          	lui	a3,0x10001
    8000505e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005060:	472d                	li	a4,11
    80005062:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005064:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80005068:	439c                	lw	a5,0(a5)
    8000506a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    8000506e:	8ba1                	andi	a5,a5,8
    80005070:	0e078a63          	beqz	a5,80005164 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005074:	100017b7          	lui	a5,0x10001
    80005078:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    8000507c:	43fc                	lw	a5,68(a5)
    8000507e:	2781                	sext.w	a5,a5
    80005080:	0e079863          	bnez	a5,80005170 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005084:	100017b7          	lui	a5,0x10001
    80005088:	5bdc                	lw	a5,52(a5)
    8000508a:	2781                	sext.w	a5,a5
  if(max == 0)
    8000508c:	0e078863          	beqz	a5,8000517c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80005090:	471d                	li	a4,7
    80005092:	0ef77b63          	bgeu	a4,a5,80005188 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80005096:	86efb0ef          	jal	80000104 <kalloc>
    8000509a:	00020497          	auipc	s1,0x20
    8000509e:	b4648493          	addi	s1,s1,-1210 # 80024be0 <disk>
    800050a2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800050a4:	860fb0ef          	jal	80000104 <kalloc>
    800050a8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800050aa:	85afb0ef          	jal	80000104 <kalloc>
    800050ae:	87aa                	mv	a5,a0
    800050b0:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800050b2:	6088                	ld	a0,0(s1)
    800050b4:	0e050063          	beqz	a0,80005194 <virtio_disk_init+0x1bc>
    800050b8:	00020717          	auipc	a4,0x20
    800050bc:	b3073703          	ld	a4,-1232(a4) # 80024be8 <disk+0x8>
    800050c0:	cb71                	beqz	a4,80005194 <virtio_disk_init+0x1bc>
    800050c2:	cbe9                	beqz	a5,80005194 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    800050c4:	6605                	lui	a2,0x1
    800050c6:	4581                	li	a1,0
    800050c8:	896fb0ef          	jal	8000015e <memset>
  memset(disk.avail, 0, PGSIZE);
    800050cc:	00020497          	auipc	s1,0x20
    800050d0:	b1448493          	addi	s1,s1,-1260 # 80024be0 <disk>
    800050d4:	6605                	lui	a2,0x1
    800050d6:	4581                	li	a1,0
    800050d8:	6488                	ld	a0,8(s1)
    800050da:	884fb0ef          	jal	8000015e <memset>
  memset(disk.used, 0, PGSIZE);
    800050de:	6605                	lui	a2,0x1
    800050e0:	4581                	li	a1,0
    800050e2:	6888                	ld	a0,16(s1)
    800050e4:	87afb0ef          	jal	8000015e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800050e8:	100017b7          	lui	a5,0x10001
    800050ec:	4721                	li	a4,8
    800050ee:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800050f0:	4098                	lw	a4,0(s1)
    800050f2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800050f6:	40d8                	lw	a4,4(s1)
    800050f8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800050fc:	649c                	ld	a5,8(s1)
    800050fe:	0007869b          	sext.w	a3,a5
    80005102:	10001737          	lui	a4,0x10001
    80005106:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000510a:	9781                	srai	a5,a5,0x20
    8000510c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005110:	689c                	ld	a5,16(s1)
    80005112:	0007869b          	sext.w	a3,a5
    80005116:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000511a:	9781                	srai	a5,a5,0x20
    8000511c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005120:	4785                	li	a5,1
    80005122:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005124:	00f48c23          	sb	a5,24(s1)
    80005128:	00f48ca3          	sb	a5,25(s1)
    8000512c:	00f48d23          	sb	a5,26(s1)
    80005130:	00f48da3          	sb	a5,27(s1)
    80005134:	00f48e23          	sb	a5,28(s1)
    80005138:	00f48ea3          	sb	a5,29(s1)
    8000513c:	00f48f23          	sb	a5,30(s1)
    80005140:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005144:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005148:	07272823          	sw	s2,112(a4)
}
    8000514c:	60e2                	ld	ra,24(sp)
    8000514e:	6442                	ld	s0,16(sp)
    80005150:	64a2                	ld	s1,8(sp)
    80005152:	6902                	ld	s2,0(sp)
    80005154:	6105                	addi	sp,sp,32
    80005156:	8082                	ret
    panic("could not find virtio disk");
    80005158:	00002517          	auipc	a0,0x2
    8000515c:	50050513          	addi	a0,a0,1280 # 80007658 <etext+0x658>
    80005160:	307000ef          	jal	80005c66 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005164:	00002517          	auipc	a0,0x2
    80005168:	51450513          	addi	a0,a0,1300 # 80007678 <etext+0x678>
    8000516c:	2fb000ef          	jal	80005c66 <panic>
    panic("virtio disk should not be ready");
    80005170:	00002517          	auipc	a0,0x2
    80005174:	52850513          	addi	a0,a0,1320 # 80007698 <etext+0x698>
    80005178:	2ef000ef          	jal	80005c66 <panic>
    panic("virtio disk has no queue 0");
    8000517c:	00002517          	auipc	a0,0x2
    80005180:	53c50513          	addi	a0,a0,1340 # 800076b8 <etext+0x6b8>
    80005184:	2e3000ef          	jal	80005c66 <panic>
    panic("virtio disk max queue too short");
    80005188:	00002517          	auipc	a0,0x2
    8000518c:	55050513          	addi	a0,a0,1360 # 800076d8 <etext+0x6d8>
    80005190:	2d7000ef          	jal	80005c66 <panic>
    panic("virtio disk kalloc");
    80005194:	00002517          	auipc	a0,0x2
    80005198:	56450513          	addi	a0,a0,1380 # 800076f8 <etext+0x6f8>
    8000519c:	2cb000ef          	jal	80005c66 <panic>

00000000800051a0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800051a0:	711d                	addi	sp,sp,-96
    800051a2:	ec86                	sd	ra,88(sp)
    800051a4:	e8a2                	sd	s0,80(sp)
    800051a6:	e4a6                	sd	s1,72(sp)
    800051a8:	e0ca                	sd	s2,64(sp)
    800051aa:	fc4e                	sd	s3,56(sp)
    800051ac:	f852                	sd	s4,48(sp)
    800051ae:	f456                	sd	s5,40(sp)
    800051b0:	f05a                	sd	s6,32(sp)
    800051b2:	ec5e                	sd	s7,24(sp)
    800051b4:	e862                	sd	s8,16(sp)
    800051b6:	1080                	addi	s0,sp,96
    800051b8:	89aa                	mv	s3,a0
    800051ba:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800051bc:	00c52b83          	lw	s7,12(a0)
    800051c0:	001b9b9b          	slliw	s7,s7,0x1
    800051c4:	1b82                	slli	s7,s7,0x20
    800051c6:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    800051ca:	00020517          	auipc	a0,0x20
    800051ce:	b3e50513          	addi	a0,a0,-1218 # 80024d08 <disk+0x128>
    800051d2:	557000ef          	jal	80005f28 <acquire>
  for(int i = 0; i < NUM; i++){
    800051d6:	44a1                	li	s1,8
      disk.free[i] = 0;
    800051d8:	00020a97          	auipc	s5,0x20
    800051dc:	a08a8a93          	addi	s5,s5,-1528 # 80024be0 <disk>
  for(int i = 0; i < 3; i++){
    800051e0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    800051e2:	5c7d                	li	s8,-1
    800051e4:	a095                	j	80005248 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    800051e6:	00fa8733          	add	a4,s5,a5
    800051ea:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    800051ee:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    800051f0:	0207c563          	bltz	a5,8000521a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    800051f4:	2905                	addiw	s2,s2,1
    800051f6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    800051f8:	05490c63          	beq	s2,s4,80005250 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    800051fc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    800051fe:	00020717          	auipc	a4,0x20
    80005202:	9e270713          	addi	a4,a4,-1566 # 80024be0 <disk>
    80005206:	4781                	li	a5,0
    if(disk.free[i]){
    80005208:	01874683          	lbu	a3,24(a4)
    8000520c:	fee9                	bnez	a3,800051e6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8000520e:	2785                	addiw	a5,a5,1
    80005210:	0705                	addi	a4,a4,1
    80005212:	fe979be3          	bne	a5,s1,80005208 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005216:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8000521a:	01205d63          	blez	s2,80005234 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000521e:	fa042503          	lw	a0,-96(s0)
    80005222:	d41ff0ef          	jal	80004f62 <free_desc>
      for(int j = 0; j < i; j++)
    80005226:	4785                	li	a5,1
    80005228:	0127d663          	bge	a5,s2,80005234 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000522c:	fa442503          	lw	a0,-92(s0)
    80005230:	d33ff0ef          	jal	80004f62 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005234:	00020597          	auipc	a1,0x20
    80005238:	ad458593          	addi	a1,a1,-1324 # 80024d08 <disk+0x128>
    8000523c:	00020517          	auipc	a0,0x20
    80005240:	9bc50513          	addi	a0,a0,-1604 # 80024bf8 <disk+0x18>
    80005244:	cf2fc0ef          	jal	80001736 <sleep>
  for(int i = 0; i < 3; i++){
    80005248:	fa040613          	addi	a2,s0,-96
    8000524c:	4901                	li	s2,0
    8000524e:	b77d                	j	800051fc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005250:	fa042503          	lw	a0,-96(s0)
    80005254:	00451693          	slli	a3,a0,0x4

  if(write)
    80005258:	00020797          	auipc	a5,0x20
    8000525c:	98878793          	addi	a5,a5,-1656 # 80024be0 <disk>
    80005260:	00451713          	slli	a4,a0,0x4
    80005264:	0a070713          	addi	a4,a4,160
    80005268:	973e                	add	a4,a4,a5
    8000526a:	01603633          	snez	a2,s6
    8000526e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005270:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80005274:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005278:	6398                	ld	a4,0(a5)
    8000527a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    8000527c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80005280:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80005282:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80005284:	6390                	ld	a2,0(a5)
    80005286:	00d60833          	add	a6,a2,a3
    8000528a:	4741                	li	a4,16
    8000528c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005290:	4585                	li	a1,1
    80005292:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80005296:	fa442703          	lw	a4,-92(s0)
    8000529a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    8000529e:	0712                	slli	a4,a4,0x4
    800052a0:	963a                	add	a2,a2,a4
    800052a2:	05898813          	addi	a6,s3,88
    800052a6:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800052aa:	0007b883          	ld	a7,0(a5)
    800052ae:	9746                	add	a4,a4,a7
    800052b0:	40000613          	li	a2,1024
    800052b4:	c710                	sw	a2,8(a4)
  if(write)
    800052b6:	001b3613          	seqz	a2,s6
    800052ba:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800052be:	8e4d                	or	a2,a2,a1
    800052c0:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    800052c4:	fa842603          	lw	a2,-88(s0)
    800052c8:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800052cc:	00451813          	slli	a6,a0,0x4
    800052d0:	02080813          	addi	a6,a6,32
    800052d4:	983e                	add	a6,a6,a5
    800052d6:	577d                	li	a4,-1
    800052d8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800052dc:	0612                	slli	a2,a2,0x4
    800052de:	98b2                	add	a7,a7,a2
    800052e0:	03068713          	addi	a4,a3,48
    800052e4:	973e                	add	a4,a4,a5
    800052e6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    800052ea:	6398                	ld	a4,0(a5)
    800052ec:	9732                	add	a4,a4,a2
    800052ee:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800052f0:	4689                	li	a3,2
    800052f2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    800052f6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800052fa:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    800052fe:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005302:	6794                	ld	a3,8(a5)
    80005304:	0026d703          	lhu	a4,2(a3)
    80005308:	8b1d                	andi	a4,a4,7
    8000530a:	0706                	slli	a4,a4,0x1
    8000530c:	96ba                	add	a3,a3,a4
    8000530e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005312:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005316:	6798                	ld	a4,8(a5)
    80005318:	00275783          	lhu	a5,2(a4)
    8000531c:	2785                	addiw	a5,a5,1
    8000531e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005322:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005326:	100017b7          	lui	a5,0x10001
    8000532a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000532e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005332:	00020917          	auipc	s2,0x20
    80005336:	9d690913          	addi	s2,s2,-1578 # 80024d08 <disk+0x128>
  while(b->disk == 1) {
    8000533a:	84ae                	mv	s1,a1
    8000533c:	00b79a63          	bne	a5,a1,80005350 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005340:	85ca                	mv	a1,s2
    80005342:	854e                	mv	a0,s3
    80005344:	bf2fc0ef          	jal	80001736 <sleep>
  while(b->disk == 1) {
    80005348:	0049a783          	lw	a5,4(s3)
    8000534c:	fe978ae3          	beq	a5,s1,80005340 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80005350:	fa042903          	lw	s2,-96(s0)
    80005354:	00491713          	slli	a4,s2,0x4
    80005358:	02070713          	addi	a4,a4,32
    8000535c:	00020797          	auipc	a5,0x20
    80005360:	88478793          	addi	a5,a5,-1916 # 80024be0 <disk>
    80005364:	97ba                	add	a5,a5,a4
    80005366:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000536a:	00020997          	auipc	s3,0x20
    8000536e:	87698993          	addi	s3,s3,-1930 # 80024be0 <disk>
    80005372:	00491713          	slli	a4,s2,0x4
    80005376:	0009b783          	ld	a5,0(s3)
    8000537a:	97ba                	add	a5,a5,a4
    8000537c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005380:	854a                	mv	a0,s2
    80005382:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005386:	bddff0ef          	jal	80004f62 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000538a:	8885                	andi	s1,s1,1
    8000538c:	f0fd                	bnez	s1,80005372 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000538e:	00020517          	auipc	a0,0x20
    80005392:	97a50513          	addi	a0,a0,-1670 # 80024d08 <disk+0x128>
    80005396:	427000ef          	jal	80005fbc <release>
}
    8000539a:	60e6                	ld	ra,88(sp)
    8000539c:	6446                	ld	s0,80(sp)
    8000539e:	64a6                	ld	s1,72(sp)
    800053a0:	6906                	ld	s2,64(sp)
    800053a2:	79e2                	ld	s3,56(sp)
    800053a4:	7a42                	ld	s4,48(sp)
    800053a6:	7aa2                	ld	s5,40(sp)
    800053a8:	7b02                	ld	s6,32(sp)
    800053aa:	6be2                	ld	s7,24(sp)
    800053ac:	6c42                	ld	s8,16(sp)
    800053ae:	6125                	addi	sp,sp,96
    800053b0:	8082                	ret

00000000800053b2 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800053b2:	1101                	addi	sp,sp,-32
    800053b4:	ec06                	sd	ra,24(sp)
    800053b6:	e822                	sd	s0,16(sp)
    800053b8:	e426                	sd	s1,8(sp)
    800053ba:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800053bc:	00020497          	auipc	s1,0x20
    800053c0:	82448493          	addi	s1,s1,-2012 # 80024be0 <disk>
    800053c4:	00020517          	auipc	a0,0x20
    800053c8:	94450513          	addi	a0,a0,-1724 # 80024d08 <disk+0x128>
    800053cc:	35d000ef          	jal	80005f28 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800053d0:	100017b7          	lui	a5,0x10001
    800053d4:	53bc                	lw	a5,96(a5)
    800053d6:	8b8d                	andi	a5,a5,3
    800053d8:	10001737          	lui	a4,0x10001
    800053dc:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800053de:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800053e2:	689c                	ld	a5,16(s1)
    800053e4:	0204d703          	lhu	a4,32(s1)
    800053e8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    800053ec:	04f70863          	beq	a4,a5,8000543c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800053f0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800053f4:	6898                	ld	a4,16(s1)
    800053f6:	0204d783          	lhu	a5,32(s1)
    800053fa:	8b9d                	andi	a5,a5,7
    800053fc:	078e                	slli	a5,a5,0x3
    800053fe:	97ba                	add	a5,a5,a4
    80005400:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005402:	00479713          	slli	a4,a5,0x4
    80005406:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000540a:	9726                	add	a4,a4,s1
    8000540c:	01074703          	lbu	a4,16(a4)
    80005410:	e329                	bnez	a4,80005452 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005412:	0792                	slli	a5,a5,0x4
    80005414:	02078793          	addi	a5,a5,32
    80005418:	97a6                	add	a5,a5,s1
    8000541a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000541c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005420:	b62fc0ef          	jal	80001782 <wakeup>

    disk.used_idx += 1;
    80005424:	0204d783          	lhu	a5,32(s1)
    80005428:	2785                	addiw	a5,a5,1
    8000542a:	17c2                	slli	a5,a5,0x30
    8000542c:	93c1                	srli	a5,a5,0x30
    8000542e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005432:	6898                	ld	a4,16(s1)
    80005434:	00275703          	lhu	a4,2(a4)
    80005438:	faf71ce3          	bne	a4,a5,800053f0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000543c:	00020517          	auipc	a0,0x20
    80005440:	8cc50513          	addi	a0,a0,-1844 # 80024d08 <disk+0x128>
    80005444:	379000ef          	jal	80005fbc <release>
}
    80005448:	60e2                	ld	ra,24(sp)
    8000544a:	6442                	ld	s0,16(sp)
    8000544c:	64a2                	ld	s1,8(sp)
    8000544e:	6105                	addi	sp,sp,32
    80005450:	8082                	ret
      panic("virtio_disk_intr status");
    80005452:	00002517          	auipc	a0,0x2
    80005456:	2be50513          	addi	a0,a0,702 # 80007710 <etext+0x710>
    8000545a:	00d000ef          	jal	80005c66 <panic>

000000008000545e <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    8000545e:	1141                	addi	sp,sp,-16
    80005460:	e406                	sd	ra,8(sp)
    80005462:	e022                	sd	s0,0(sp)
    80005464:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005466:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    8000546a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    8000546e:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80005472:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80005476:	577d                	li	a4,-1
    80005478:	177e                	slli	a4,a4,0x3f
    8000547a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    8000547c:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80005480:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80005484:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005488:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    8000548c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80005490:	000f4737          	lui	a4,0xf4
    80005494:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005498:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000549a:	14d79073          	csrw	stimecmp,a5
}
    8000549e:	60a2                	ld	ra,8(sp)
    800054a0:	6402                	ld	s0,0(sp)
    800054a2:	0141                	addi	sp,sp,16
    800054a4:	8082                	ret

00000000800054a6 <start>:
{
    800054a6:	1141                	addi	sp,sp,-16
    800054a8:	e406                	sd	ra,8(sp)
    800054aa:	e022                	sd	s0,0(sp)
    800054ac:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800054ae:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800054b2:	7779                	lui	a4,0xffffe
    800054b4:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffd1a07>
    800054b8:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    800054ba:	6705                	lui	a4,0x1
    800054bc:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    800054c0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800054c2:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    800054c6:	ffffb797          	auipc	a5,0xffffb
    800054ca:	e4e78793          	addi	a5,a5,-434 # 80000314 <main>
    800054ce:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    800054d2:	4781                	li	a5,0
    800054d4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    800054d8:	67c1                	lui	a5,0x10
    800054da:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    800054dc:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    800054e0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    800054e4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    800054e8:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    800054ec:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    800054f0:	57fd                	li	a5,-1
    800054f2:	83a9                	srli	a5,a5,0xa
    800054f4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    800054f8:	47bd                	li	a5,15
    800054fa:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    800054fe:	f61ff0ef          	jal	8000545e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005502:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005506:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005508:	823e                	mv	tp,a5
  asm volatile("mret");
    8000550a:	30200073          	mret
}
    8000550e:	60a2                	ld	ra,8(sp)
    80005510:	6402                	ld	s0,0(sp)
    80005512:	0141                	addi	sp,sp,16
    80005514:	8082                	ret

0000000080005516 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005516:	7119                	addi	sp,sp,-128
    80005518:	fc86                	sd	ra,120(sp)
    8000551a:	f8a2                	sd	s0,112(sp)
    8000551c:	f4a6                	sd	s1,104(sp)
    8000551e:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005520:	06c05b63          	blez	a2,80005596 <consolewrite+0x80>
    80005524:	f0ca                	sd	s2,96(sp)
    80005526:	ecce                	sd	s3,88(sp)
    80005528:	e8d2                	sd	s4,80(sp)
    8000552a:	e4d6                	sd	s5,72(sp)
    8000552c:	e0da                	sd	s6,64(sp)
    8000552e:	fc5e                	sd	s7,56(sp)
    80005530:	f862                	sd	s8,48(sp)
    80005532:	f466                	sd	s9,40(sp)
    80005534:	f06a                	sd	s10,32(sp)
    80005536:	8b2a                	mv	s6,a0
    80005538:	8bae                	mv	s7,a1
    8000553a:	8a32                	mv	s4,a2
  int i = 0;
    8000553c:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    8000553e:	02000c93          	li	s9,32
    80005542:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005546:	f8040a93          	addi	s5,s0,-128
    8000554a:	5c7d                	li	s8,-1
    8000554c:	a025                	j	80005574 <consolewrite+0x5e>
    if(nn > n - i)
    8000554e:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005552:	86ce                	mv	a3,s3
    80005554:	01748633          	add	a2,s1,s7
    80005558:	85da                	mv	a1,s6
    8000555a:	8556                	mv	a0,s5
    8000555c:	ddefc0ef          	jal	80001b3a <either_copyin>
    80005560:	03850d63          	beq	a0,s8,8000559a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80005564:	85ce                	mv	a1,s3
    80005566:	8556                	mv	a0,s5
    80005568:	7b4000ef          	jal	80005d1c <uartwrite>
    i += nn;
    8000556c:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005570:	0144d963          	bge	s1,s4,80005582 <consolewrite+0x6c>
    if(nn > n - i)
    80005574:	409a07bb          	subw	a5,s4,s1
    80005578:	893e                	mv	s2,a5
    8000557a:	fcfcdae3          	bge	s9,a5,8000554e <consolewrite+0x38>
    8000557e:	896a                	mv	s2,s10
    80005580:	b7f9                	j	8000554e <consolewrite+0x38>
    80005582:	7906                	ld	s2,96(sp)
    80005584:	69e6                	ld	s3,88(sp)
    80005586:	6a46                	ld	s4,80(sp)
    80005588:	6aa6                	ld	s5,72(sp)
    8000558a:	6b06                	ld	s6,64(sp)
    8000558c:	7be2                	ld	s7,56(sp)
    8000558e:	7c42                	ld	s8,48(sp)
    80005590:	7ca2                	ld	s9,40(sp)
    80005592:	7d02                	ld	s10,32(sp)
    80005594:	a821                	j	800055ac <consolewrite+0x96>
  int i = 0;
    80005596:	4481                	li	s1,0
    80005598:	a811                	j	800055ac <consolewrite+0x96>
    8000559a:	7906                	ld	s2,96(sp)
    8000559c:	69e6                	ld	s3,88(sp)
    8000559e:	6a46                	ld	s4,80(sp)
    800055a0:	6aa6                	ld	s5,72(sp)
    800055a2:	6b06                	ld	s6,64(sp)
    800055a4:	7be2                	ld	s7,56(sp)
    800055a6:	7c42                	ld	s8,48(sp)
    800055a8:	7ca2                	ld	s9,40(sp)
    800055aa:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    800055ac:	8526                	mv	a0,s1
    800055ae:	70e6                	ld	ra,120(sp)
    800055b0:	7446                	ld	s0,112(sp)
    800055b2:	74a6                	ld	s1,104(sp)
    800055b4:	6109                	addi	sp,sp,128
    800055b6:	8082                	ret

00000000800055b8 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    800055b8:	711d                	addi	sp,sp,-96
    800055ba:	ec86                	sd	ra,88(sp)
    800055bc:	e8a2                	sd	s0,80(sp)
    800055be:	e4a6                	sd	s1,72(sp)
    800055c0:	e0ca                	sd	s2,64(sp)
    800055c2:	fc4e                	sd	s3,56(sp)
    800055c4:	f852                	sd	s4,48(sp)
    800055c6:	f05a                	sd	s6,32(sp)
    800055c8:	ec5e                	sd	s7,24(sp)
    800055ca:	1080                	addi	s0,sp,96
    800055cc:	8b2a                	mv	s6,a0
    800055ce:	8a2e                	mv	s4,a1
    800055d0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800055d2:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    800055d4:	00027517          	auipc	a0,0x27
    800055d8:	74c50513          	addi	a0,a0,1868 # 8002cd20 <cons>
    800055dc:	14d000ef          	jal	80005f28 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800055e0:	00027497          	auipc	s1,0x27
    800055e4:	74048493          	addi	s1,s1,1856 # 8002cd20 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800055e8:	00027917          	auipc	s2,0x27
    800055ec:	7d090913          	addi	s2,s2,2000 # 8002cdb8 <cons+0x98>
  while(n > 0){
    800055f0:	0b305b63          	blez	s3,800056a6 <consoleread+0xee>
    while(cons.r == cons.w){
    800055f4:	0984a783          	lw	a5,152(s1)
    800055f8:	09c4a703          	lw	a4,156(s1)
    800055fc:	0af71063          	bne	a4,a5,8000569c <consoleread+0xe4>
      if(killed(myproc())){
    80005600:	af1fb0ef          	jal	800010f0 <myproc>
    80005604:	bcefc0ef          	jal	800019d2 <killed>
    80005608:	e12d                	bnez	a0,8000566a <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000560a:	85a6                	mv	a1,s1
    8000560c:	854a                	mv	a0,s2
    8000560e:	928fc0ef          	jal	80001736 <sleep>
    while(cons.r == cons.w){
    80005612:	0984a783          	lw	a5,152(s1)
    80005616:	09c4a703          	lw	a4,156(s1)
    8000561a:	fef703e3          	beq	a4,a5,80005600 <consoleread+0x48>
    8000561e:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005620:	00027717          	auipc	a4,0x27
    80005624:	70070713          	addi	a4,a4,1792 # 8002cd20 <cons>
    80005628:	0017869b          	addiw	a3,a5,1
    8000562c:	08d72c23          	sw	a3,152(a4)
    80005630:	07f7f693          	andi	a3,a5,127
    80005634:	9736                	add	a4,a4,a3
    80005636:	01874703          	lbu	a4,24(a4)
    8000563a:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    8000563e:	4691                	li	a3,4
    80005640:	04da8663          	beq	s5,a3,8000568c <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005644:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005648:	4685                	li	a3,1
    8000564a:	faf40613          	addi	a2,s0,-81
    8000564e:	85d2                	mv	a1,s4
    80005650:	855a                	mv	a0,s6
    80005652:	c9efc0ef          	jal	80001af0 <either_copyout>
    80005656:	57fd                	li	a5,-1
    80005658:	04f50663          	beq	a0,a5,800056a4 <consoleread+0xec>
      break;

    dst++;
    8000565c:	0a05                	addi	s4,s4,1
    --n;
    8000565e:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005660:	47a9                	li	a5,10
    80005662:	04fa8b63          	beq	s5,a5,800056b8 <consoleread+0x100>
    80005666:	7aa2                	ld	s5,40(sp)
    80005668:	b761                	j	800055f0 <consoleread+0x38>
        release(&cons.lock);
    8000566a:	00027517          	auipc	a0,0x27
    8000566e:	6b650513          	addi	a0,a0,1718 # 8002cd20 <cons>
    80005672:	14b000ef          	jal	80005fbc <release>
        return -1;
    80005676:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005678:	60e6                	ld	ra,88(sp)
    8000567a:	6446                	ld	s0,80(sp)
    8000567c:	64a6                	ld	s1,72(sp)
    8000567e:	6906                	ld	s2,64(sp)
    80005680:	79e2                	ld	s3,56(sp)
    80005682:	7a42                	ld	s4,48(sp)
    80005684:	7b02                	ld	s6,32(sp)
    80005686:	6be2                	ld	s7,24(sp)
    80005688:	6125                	addi	sp,sp,96
    8000568a:	8082                	ret
      if(n < target){
    8000568c:	0179fa63          	bgeu	s3,s7,800056a0 <consoleread+0xe8>
        cons.r--;
    80005690:	00027717          	auipc	a4,0x27
    80005694:	72f72423          	sw	a5,1832(a4) # 8002cdb8 <cons+0x98>
    80005698:	7aa2                	ld	s5,40(sp)
    8000569a:	a031                	j	800056a6 <consoleread+0xee>
    8000569c:	f456                	sd	s5,40(sp)
    8000569e:	b749                	j	80005620 <consoleread+0x68>
    800056a0:	7aa2                	ld	s5,40(sp)
    800056a2:	a011                	j	800056a6 <consoleread+0xee>
    800056a4:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    800056a6:	00027517          	auipc	a0,0x27
    800056aa:	67a50513          	addi	a0,a0,1658 # 8002cd20 <cons>
    800056ae:	10f000ef          	jal	80005fbc <release>
  return target - n;
    800056b2:	413b853b          	subw	a0,s7,s3
    800056b6:	b7c9                	j	80005678 <consoleread+0xc0>
    800056b8:	7aa2                	ld	s5,40(sp)
    800056ba:	b7f5                	j	800056a6 <consoleread+0xee>

00000000800056bc <consputc>:
{
    800056bc:	1141                	addi	sp,sp,-16
    800056be:	e406                	sd	ra,8(sp)
    800056c0:	e022                	sd	s0,0(sp)
    800056c2:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    800056c4:	10000793          	li	a5,256
    800056c8:	00f50863          	beq	a0,a5,800056d8 <consputc+0x1c>
    uartputc_sync(c);
    800056cc:	6e4000ef          	jal	80005db0 <uartputc_sync>
}
    800056d0:	60a2                	ld	ra,8(sp)
    800056d2:	6402                	ld	s0,0(sp)
    800056d4:	0141                	addi	sp,sp,16
    800056d6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800056d8:	4521                	li	a0,8
    800056da:	6d6000ef          	jal	80005db0 <uartputc_sync>
    800056de:	02000513          	li	a0,32
    800056e2:	6ce000ef          	jal	80005db0 <uartputc_sync>
    800056e6:	4521                	li	a0,8
    800056e8:	6c8000ef          	jal	80005db0 <uartputc_sync>
    800056ec:	b7d5                	j	800056d0 <consputc+0x14>

00000000800056ee <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800056ee:	1101                	addi	sp,sp,-32
    800056f0:	ec06                	sd	ra,24(sp)
    800056f2:	e822                	sd	s0,16(sp)
    800056f4:	e426                	sd	s1,8(sp)
    800056f6:	1000                	addi	s0,sp,32
    800056f8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800056fa:	00027517          	auipc	a0,0x27
    800056fe:	62650513          	addi	a0,a0,1574 # 8002cd20 <cons>
    80005702:	027000ef          	jal	80005f28 <acquire>

  switch(c){
    80005706:	47d5                	li	a5,21
    80005708:	08f48d63          	beq	s1,a5,800057a2 <consoleintr+0xb4>
    8000570c:	0297c563          	blt	a5,s1,80005736 <consoleintr+0x48>
    80005710:	47a1                	li	a5,8
    80005712:	0ef48263          	beq	s1,a5,800057f6 <consoleintr+0x108>
    80005716:	47c1                	li	a5,16
    80005718:	10f49363          	bne	s1,a5,8000581e <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    8000571c:	c68fc0ef          	jal	80001b84 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005720:	00027517          	auipc	a0,0x27
    80005724:	60050513          	addi	a0,a0,1536 # 8002cd20 <cons>
    80005728:	095000ef          	jal	80005fbc <release>
}
    8000572c:	60e2                	ld	ra,24(sp)
    8000572e:	6442                	ld	s0,16(sp)
    80005730:	64a2                	ld	s1,8(sp)
    80005732:	6105                	addi	sp,sp,32
    80005734:	8082                	ret
  switch(c){
    80005736:	07f00793          	li	a5,127
    8000573a:	0af48e63          	beq	s1,a5,800057f6 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000573e:	00027717          	auipc	a4,0x27
    80005742:	5e270713          	addi	a4,a4,1506 # 8002cd20 <cons>
    80005746:	0a072783          	lw	a5,160(a4)
    8000574a:	09872703          	lw	a4,152(a4)
    8000574e:	9f99                	subw	a5,a5,a4
    80005750:	07f00713          	li	a4,127
    80005754:	fcf766e3          	bltu	a4,a5,80005720 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005758:	47b5                	li	a5,13
    8000575a:	0cf48563          	beq	s1,a5,80005824 <consoleintr+0x136>
      consputc(c);
    8000575e:	8526                	mv	a0,s1
    80005760:	f5dff0ef          	jal	800056bc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005764:	00027717          	auipc	a4,0x27
    80005768:	5bc70713          	addi	a4,a4,1468 # 8002cd20 <cons>
    8000576c:	0a072683          	lw	a3,160(a4)
    80005770:	0016879b          	addiw	a5,a3,1
    80005774:	863e                	mv	a2,a5
    80005776:	0af72023          	sw	a5,160(a4)
    8000577a:	07f6f693          	andi	a3,a3,127
    8000577e:	9736                	add	a4,a4,a3
    80005780:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005784:	ff648713          	addi	a4,s1,-10
    80005788:	c371                	beqz	a4,8000584c <consoleintr+0x15e>
    8000578a:	14f1                	addi	s1,s1,-4
    8000578c:	c0e1                	beqz	s1,8000584c <consoleintr+0x15e>
    8000578e:	00027717          	auipc	a4,0x27
    80005792:	62a72703          	lw	a4,1578(a4) # 8002cdb8 <cons+0x98>
    80005796:	9f99                	subw	a5,a5,a4
    80005798:	08000713          	li	a4,128
    8000579c:	f8e792e3          	bne	a5,a4,80005720 <consoleintr+0x32>
    800057a0:	a075                	j	8000584c <consoleintr+0x15e>
    800057a2:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800057a4:	00027717          	auipc	a4,0x27
    800057a8:	57c70713          	addi	a4,a4,1404 # 8002cd20 <cons>
    800057ac:	0a072783          	lw	a5,160(a4)
    800057b0:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800057b4:	00027497          	auipc	s1,0x27
    800057b8:	56c48493          	addi	s1,s1,1388 # 8002cd20 <cons>
    while(cons.e != cons.w &&
    800057bc:	4929                	li	s2,10
    800057be:	02f70863          	beq	a4,a5,800057ee <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    800057c2:	37fd                	addiw	a5,a5,-1
    800057c4:	07f7f713          	andi	a4,a5,127
    800057c8:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    800057ca:	01874703          	lbu	a4,24(a4)
    800057ce:	03270263          	beq	a4,s2,800057f2 <consoleintr+0x104>
      cons.e--;
    800057d2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800057d6:	10000513          	li	a0,256
    800057da:	ee3ff0ef          	jal	800056bc <consputc>
    while(cons.e != cons.w &&
    800057de:	0a04a783          	lw	a5,160(s1)
    800057e2:	09c4a703          	lw	a4,156(s1)
    800057e6:	fcf71ee3          	bne	a4,a5,800057c2 <consoleintr+0xd4>
    800057ea:	6902                	ld	s2,0(sp)
    800057ec:	bf15                	j	80005720 <consoleintr+0x32>
    800057ee:	6902                	ld	s2,0(sp)
    800057f0:	bf05                	j	80005720 <consoleintr+0x32>
    800057f2:	6902                	ld	s2,0(sp)
    800057f4:	b735                	j	80005720 <consoleintr+0x32>
    if(cons.e != cons.w){
    800057f6:	00027717          	auipc	a4,0x27
    800057fa:	52a70713          	addi	a4,a4,1322 # 8002cd20 <cons>
    800057fe:	0a072783          	lw	a5,160(a4)
    80005802:	09c72703          	lw	a4,156(a4)
    80005806:	f0f70de3          	beq	a4,a5,80005720 <consoleintr+0x32>
      cons.e--;
    8000580a:	37fd                	addiw	a5,a5,-1
    8000580c:	00027717          	auipc	a4,0x27
    80005810:	5af72a23          	sw	a5,1460(a4) # 8002cdc0 <cons+0xa0>
      consputc(BACKSPACE);
    80005814:	10000513          	li	a0,256
    80005818:	ea5ff0ef          	jal	800056bc <consputc>
    8000581c:	b711                	j	80005720 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000581e:	f00481e3          	beqz	s1,80005720 <consoleintr+0x32>
    80005822:	bf31                	j	8000573e <consoleintr+0x50>
      consputc(c);
    80005824:	4529                	li	a0,10
    80005826:	e97ff0ef          	jal	800056bc <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000582a:	00027797          	auipc	a5,0x27
    8000582e:	4f678793          	addi	a5,a5,1270 # 8002cd20 <cons>
    80005832:	0a07a703          	lw	a4,160(a5)
    80005836:	0017069b          	addiw	a3,a4,1
    8000583a:	8636                	mv	a2,a3
    8000583c:	0ad7a023          	sw	a3,160(a5)
    80005840:	07f77713          	andi	a4,a4,127
    80005844:	97ba                	add	a5,a5,a4
    80005846:	4729                	li	a4,10
    80005848:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000584c:	00027797          	auipc	a5,0x27
    80005850:	56c7a823          	sw	a2,1392(a5) # 8002cdbc <cons+0x9c>
        wakeup(&cons.r);
    80005854:	00027517          	auipc	a0,0x27
    80005858:	56450513          	addi	a0,a0,1380 # 8002cdb8 <cons+0x98>
    8000585c:	f27fb0ef          	jal	80001782 <wakeup>
    80005860:	b5c1                	j	80005720 <consoleintr+0x32>

0000000080005862 <consoleinit>:

void
consoleinit(void)
{
    80005862:	1141                	addi	sp,sp,-16
    80005864:	e406                	sd	ra,8(sp)
    80005866:	e022                	sd	s0,0(sp)
    80005868:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000586a:	00002597          	auipc	a1,0x2
    8000586e:	ebe58593          	addi	a1,a1,-322 # 80007728 <etext+0x728>
    80005872:	00027517          	auipc	a0,0x27
    80005876:	4ae50513          	addi	a0,a0,1198 # 8002cd20 <cons>
    8000587a:	624000ef          	jal	80005e9e <initlock>

  uartinit();
    8000587e:	448000ef          	jal	80005cc6 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005882:	0001e797          	auipc	a5,0x1e
    80005886:	30678793          	addi	a5,a5,774 # 80023b88 <devsw>
    8000588a:	00000717          	auipc	a4,0x0
    8000588e:	d2e70713          	addi	a4,a4,-722 # 800055b8 <consoleread>
    80005892:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005894:	00000717          	auipc	a4,0x0
    80005898:	c8270713          	addi	a4,a4,-894 # 80005516 <consolewrite>
    8000589c:	ef98                	sd	a4,24(a5)
}
    8000589e:	60a2                	ld	ra,8(sp)
    800058a0:	6402                	ld	s0,0(sp)
    800058a2:	0141                	addi	sp,sp,16
    800058a4:	8082                	ret

00000000800058a6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800058a6:	7139                	addi	sp,sp,-64
    800058a8:	fc06                	sd	ra,56(sp)
    800058aa:	f822                	sd	s0,48(sp)
    800058ac:	f04a                	sd	s2,32(sp)
    800058ae:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    800058b0:	c219                	beqz	a2,800058b6 <printint+0x10>
    800058b2:	08054163          	bltz	a0,80005934 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    800058b6:	4301                	li	t1,0

  i = 0;
    800058b8:	fc840913          	addi	s2,s0,-56
    x = xx;
    800058bc:	86ca                	mv	a3,s2
  i = 0;
    800058be:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    800058c0:	00002817          	auipc	a6,0x2
    800058c4:	fd080813          	addi	a6,a6,-48 # 80007890 <digits>
    800058c8:	88ba                	mv	a7,a4
    800058ca:	0017061b          	addiw	a2,a4,1
    800058ce:	8732                	mv	a4,a2
    800058d0:	02b577b3          	remu	a5,a0,a1
    800058d4:	97c2                	add	a5,a5,a6
    800058d6:	0007c783          	lbu	a5,0(a5)
    800058da:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800058de:	87aa                	mv	a5,a0
    800058e0:	02b55533          	divu	a0,a0,a1
    800058e4:	0685                	addi	a3,a3,1
    800058e6:	feb7f1e3          	bgeu	a5,a1,800058c8 <printint+0x22>

  if(sign)
    800058ea:	00030c63          	beqz	t1,80005902 <printint+0x5c>
    buf[i++] = '-';
    800058ee:	fe060793          	addi	a5,a2,-32
    800058f2:	00878633          	add	a2,a5,s0
    800058f6:	02d00793          	li	a5,45
    800058fa:	fef60423          	sb	a5,-24(a2)
    800058fe:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80005902:	02e05463          	blez	a4,8000592a <printint+0x84>
    80005906:	f426                	sd	s1,40(sp)
    80005908:	377d                	addiw	a4,a4,-1
    8000590a:	00e904b3          	add	s1,s2,a4
    8000590e:	197d                	addi	s2,s2,-1
    80005910:	993a                	add	s2,s2,a4
    80005912:	1702                	slli	a4,a4,0x20
    80005914:	9301                	srli	a4,a4,0x20
    80005916:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000591a:	0004c503          	lbu	a0,0(s1)
    8000591e:	d9fff0ef          	jal	800056bc <consputc>
  while(--i >= 0)
    80005922:	14fd                	addi	s1,s1,-1
    80005924:	ff249be3          	bne	s1,s2,8000591a <printint+0x74>
    80005928:	74a2                	ld	s1,40(sp)
}
    8000592a:	70e2                	ld	ra,56(sp)
    8000592c:	7442                	ld	s0,48(sp)
    8000592e:	7902                	ld	s2,32(sp)
    80005930:	6121                	addi	sp,sp,64
    80005932:	8082                	ret
    x = -xx;
    80005934:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005938:	4305                	li	t1,1
    x = -xx;
    8000593a:	bfbd                	j	800058b8 <printint+0x12>

000000008000593c <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000593c:	7131                	addi	sp,sp,-192
    8000593e:	fc86                	sd	ra,120(sp)
    80005940:	f8a2                	sd	s0,112(sp)
    80005942:	f0ca                	sd	s2,96(sp)
    80005944:	0100                	addi	s0,sp,128
    80005946:	892a                	mv	s2,a0
    80005948:	e40c                	sd	a1,8(s0)
    8000594a:	e810                	sd	a2,16(s0)
    8000594c:	ec14                	sd	a3,24(s0)
    8000594e:	f018                	sd	a4,32(s0)
    80005950:	f41c                	sd	a5,40(s0)
    80005952:	03043823          	sd	a6,48(s0)
    80005956:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    8000595a:	00002797          	auipc	a5,0x2
    8000595e:	f867a783          	lw	a5,-122(a5) # 800078e0 <panicking>
    80005962:	cf9d                	beqz	a5,800059a0 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005964:	00840793          	addi	a5,s0,8
    80005968:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000596c:	00094503          	lbu	a0,0(s2)
    80005970:	22050663          	beqz	a0,80005b9c <printf+0x260>
    80005974:	f4a6                	sd	s1,104(sp)
    80005976:	ecce                	sd	s3,88(sp)
    80005978:	e8d2                	sd	s4,80(sp)
    8000597a:	e4d6                	sd	s5,72(sp)
    8000597c:	e0da                	sd	s6,64(sp)
    8000597e:	fc5e                	sd	s7,56(sp)
    80005980:	f862                	sd	s8,48(sp)
    80005982:	f06a                	sd	s10,32(sp)
    80005984:	ec6e                	sd	s11,24(sp)
    80005986:	4a01                	li	s4,0
    if(cx != '%'){
    80005988:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000598c:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005990:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005994:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80005998:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000599a:	06400b93          	li	s7,100
    8000599e:	a015                	j	800059c2 <printf+0x86>
    acquire(&pr.lock);
    800059a0:	00027517          	auipc	a0,0x27
    800059a4:	42850513          	addi	a0,a0,1064 # 8002cdc8 <pr>
    800059a8:	580000ef          	jal	80005f28 <acquire>
    800059ac:	bf65                	j	80005964 <printf+0x28>
      consputc(cx);
    800059ae:	d0fff0ef          	jal	800056bc <consputc>
      continue;
    800059b2:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800059b4:	2485                	addiw	s1,s1,1
    800059b6:	8a26                	mv	s4,s1
    800059b8:	94ca                	add	s1,s1,s2
    800059ba:	0004c503          	lbu	a0,0(s1)
    800059be:	1c050663          	beqz	a0,80005b8a <printf+0x24e>
    if(cx != '%'){
    800059c2:	ff3516e3          	bne	a0,s3,800059ae <printf+0x72>
    i++;
    800059c6:	001a079b          	addiw	a5,s4,1
    800059ca:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    800059cc:	00f90733          	add	a4,s2,a5
    800059d0:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800059d4:	200a8963          	beqz	s5,80005be6 <printf+0x2aa>
    800059d8:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    800059dc:	1e068c63          	beqz	a3,80005bd4 <printf+0x298>
    if(c0 == 'd'){
    800059e0:	037a8863          	beq	s5,s7,80005a10 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800059e4:	f94a8713          	addi	a4,s5,-108
    800059e8:	00173713          	seqz	a4,a4
    800059ec:	f9c68613          	addi	a2,a3,-100
    800059f0:	ee05                	bnez	a2,80005a28 <printf+0xec>
    800059f2:	cb1d                	beqz	a4,80005a28 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800059f4:	f8843783          	ld	a5,-120(s0)
    800059f8:	00878713          	addi	a4,a5,8
    800059fc:	f8e43423          	sd	a4,-120(s0)
    80005a00:	4605                	li	a2,1
    80005a02:	85da                	mv	a1,s6
    80005a04:	6388                	ld	a0,0(a5)
    80005a06:	ea1ff0ef          	jal	800058a6 <printint>
      i += 1;
    80005a0a:	002a049b          	addiw	s1,s4,2
    80005a0e:	b75d                	j	800059b4 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    80005a10:	f8843783          	ld	a5,-120(s0)
    80005a14:	00878713          	addi	a4,a5,8
    80005a18:	f8e43423          	sd	a4,-120(s0)
    80005a1c:	4605                	li	a2,1
    80005a1e:	85da                	mv	a1,s6
    80005a20:	4388                	lw	a0,0(a5)
    80005a22:	e85ff0ef          	jal	800058a6 <printint>
    80005a26:	b779                	j	800059b4 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    80005a28:	97ca                	add	a5,a5,s2
    80005a2a:	8636                	mv	a2,a3
    80005a2c:	0027c683          	lbu	a3,2(a5)
    80005a30:	a2c9                	j	80005bf2 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005a32:	f8843783          	ld	a5,-120(s0)
    80005a36:	00878713          	addi	a4,a5,8
    80005a3a:	f8e43423          	sd	a4,-120(s0)
    80005a3e:	4605                	li	a2,1
    80005a40:	45a9                	li	a1,10
    80005a42:	6388                	ld	a0,0(a5)
    80005a44:	e63ff0ef          	jal	800058a6 <printint>
      i += 2;
    80005a48:	003a049b          	addiw	s1,s4,3
    80005a4c:	b7a5                	j	800059b4 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    80005a4e:	f8843783          	ld	a5,-120(s0)
    80005a52:	00878713          	addi	a4,a5,8
    80005a56:	f8e43423          	sd	a4,-120(s0)
    80005a5a:	4601                	li	a2,0
    80005a5c:	85da                	mv	a1,s6
    80005a5e:	0007e503          	lwu	a0,0(a5)
    80005a62:	e45ff0ef          	jal	800058a6 <printint>
    80005a66:	b7b9                	j	800059b4 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005a68:	f8843783          	ld	a5,-120(s0)
    80005a6c:	00878713          	addi	a4,a5,8
    80005a70:	f8e43423          	sd	a4,-120(s0)
    80005a74:	4601                	li	a2,0
    80005a76:	85da                	mv	a1,s6
    80005a78:	6388                	ld	a0,0(a5)
    80005a7a:	e2dff0ef          	jal	800058a6 <printint>
      i += 1;
    80005a7e:	002a049b          	addiw	s1,s4,2
    80005a82:	bf0d                	j	800059b4 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005a84:	f8843783          	ld	a5,-120(s0)
    80005a88:	00878713          	addi	a4,a5,8
    80005a8c:	f8e43423          	sd	a4,-120(s0)
    80005a90:	4601                	li	a2,0
    80005a92:	45a9                	li	a1,10
    80005a94:	6388                	ld	a0,0(a5)
    80005a96:	e11ff0ef          	jal	800058a6 <printint>
      i += 2;
    80005a9a:	003a049b          	addiw	s1,s4,3
    80005a9e:	bf19                	j	800059b4 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005aa0:	f8843783          	ld	a5,-120(s0)
    80005aa4:	00878713          	addi	a4,a5,8
    80005aa8:	f8e43423          	sd	a4,-120(s0)
    80005aac:	4601                	li	a2,0
    80005aae:	45c1                	li	a1,16
    80005ab0:	0007e503          	lwu	a0,0(a5)
    80005ab4:	df3ff0ef          	jal	800058a6 <printint>
    80005ab8:	bdf5                	j	800059b4 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005aba:	f8843783          	ld	a5,-120(s0)
    80005abe:	00878713          	addi	a4,a5,8
    80005ac2:	f8e43423          	sd	a4,-120(s0)
    80005ac6:	45c1                	li	a1,16
    80005ac8:	6388                	ld	a0,0(a5)
    80005aca:	dddff0ef          	jal	800058a6 <printint>
      i += 1;
    80005ace:	002a049b          	addiw	s1,s4,2
    80005ad2:	b5cd                	j	800059b4 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005ad4:	f8843783          	ld	a5,-120(s0)
    80005ad8:	00878713          	addi	a4,a5,8
    80005adc:	f8e43423          	sd	a4,-120(s0)
    80005ae0:	4601                	li	a2,0
    80005ae2:	45c1                	li	a1,16
    80005ae4:	6388                	ld	a0,0(a5)
    80005ae6:	dc1ff0ef          	jal	800058a6 <printint>
      i += 2;
    80005aea:	003a049b          	addiw	s1,s4,3
    80005aee:	b5d9                	j	800059b4 <printf+0x78>
    80005af0:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    80005af2:	f8843783          	ld	a5,-120(s0)
    80005af6:	00878713          	addi	a4,a5,8
    80005afa:	f8e43423          	sd	a4,-120(s0)
    80005afe:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80005b02:	03000513          	li	a0,48
    80005b06:	bb7ff0ef          	jal	800056bc <consputc>
  consputc('x');
    80005b0a:	07800513          	li	a0,120
    80005b0e:	bafff0ef          	jal	800056bc <consputc>
    80005b12:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005b14:	00002c97          	auipc	s9,0x2
    80005b18:	d7cc8c93          	addi	s9,s9,-644 # 80007890 <digits>
    80005b1c:	03cad793          	srli	a5,s5,0x3c
    80005b20:	97e6                	add	a5,a5,s9
    80005b22:	0007c503          	lbu	a0,0(a5)
    80005b26:	b97ff0ef          	jal	800056bc <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005b2a:	0a92                	slli	s5,s5,0x4
    80005b2c:	3a7d                	addiw	s4,s4,-1
    80005b2e:	fe0a17e3          	bnez	s4,80005b1c <printf+0x1e0>
    80005b32:	7ca2                	ld	s9,40(sp)
    80005b34:	b541                	j	800059b4 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80005b36:	f8843783          	ld	a5,-120(s0)
    80005b3a:	00878713          	addi	a4,a5,8
    80005b3e:	f8e43423          	sd	a4,-120(s0)
    80005b42:	4388                	lw	a0,0(a5)
    80005b44:	b79ff0ef          	jal	800056bc <consputc>
    80005b48:	b5b5                	j	800059b4 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80005b4a:	f8843783          	ld	a5,-120(s0)
    80005b4e:	00878713          	addi	a4,a5,8
    80005b52:	f8e43423          	sd	a4,-120(s0)
    80005b56:	0007ba03          	ld	s4,0(a5)
    80005b5a:	000a0d63          	beqz	s4,80005b74 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    80005b5e:	000a4503          	lbu	a0,0(s4)
    80005b62:	e40509e3          	beqz	a0,800059b4 <printf+0x78>
        consputc(*s);
    80005b66:	b57ff0ef          	jal	800056bc <consputc>
      for(; *s; s++)
    80005b6a:	0a05                	addi	s4,s4,1
    80005b6c:	000a4503          	lbu	a0,0(s4)
    80005b70:	f97d                	bnez	a0,80005b66 <printf+0x22a>
    80005b72:	b589                	j	800059b4 <printf+0x78>
        s = "(null)";
    80005b74:	00002a17          	auipc	s4,0x2
    80005b78:	bbca0a13          	addi	s4,s4,-1092 # 80007730 <etext+0x730>
      for(; *s; s++)
    80005b7c:	02800513          	li	a0,40
    80005b80:	b7dd                	j	80005b66 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005b82:	8556                	mv	a0,s5
    80005b84:	b39ff0ef          	jal	800056bc <consputc>
    80005b88:	b535                	j	800059b4 <printf+0x78>
    80005b8a:	74a6                	ld	s1,104(sp)
    80005b8c:	69e6                	ld	s3,88(sp)
    80005b8e:	6a46                	ld	s4,80(sp)
    80005b90:	6aa6                	ld	s5,72(sp)
    80005b92:	6b06                	ld	s6,64(sp)
    80005b94:	7be2                	ld	s7,56(sp)
    80005b96:	7c42                	ld	s8,48(sp)
    80005b98:	7d02                	ld	s10,32(sp)
    80005b9a:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    80005b9c:	00002797          	auipc	a5,0x2
    80005ba0:	d447a783          	lw	a5,-700(a5) # 800078e0 <panicking>
    80005ba4:	c38d                	beqz	a5,80005bc6 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80005ba6:	4501                	li	a0,0
    80005ba8:	70e6                	ld	ra,120(sp)
    80005baa:	7446                	ld	s0,112(sp)
    80005bac:	7906                	ld	s2,96(sp)
    80005bae:	6129                	addi	sp,sp,192
    80005bb0:	8082                	ret
    80005bb2:	74a6                	ld	s1,104(sp)
    80005bb4:	69e6                	ld	s3,88(sp)
    80005bb6:	6a46                	ld	s4,80(sp)
    80005bb8:	6aa6                	ld	s5,72(sp)
    80005bba:	6b06                	ld	s6,64(sp)
    80005bbc:	7be2                	ld	s7,56(sp)
    80005bbe:	7c42                	ld	s8,48(sp)
    80005bc0:	7d02                	ld	s10,32(sp)
    80005bc2:	6de2                	ld	s11,24(sp)
    80005bc4:	bfe1                	j	80005b9c <printf+0x260>
    release(&pr.lock);
    80005bc6:	00027517          	auipc	a0,0x27
    80005bca:	20250513          	addi	a0,a0,514 # 8002cdc8 <pr>
    80005bce:	3ee000ef          	jal	80005fbc <release>
  return 0;
    80005bd2:	bfd1                	j	80005ba6 <printf+0x26a>
    if(c0 == 'd'){
    80005bd4:	e37a8ee3          	beq	s5,s7,80005a10 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005bd8:	f94a8713          	addi	a4,s5,-108
    80005bdc:	00173713          	seqz	a4,a4
    80005be0:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005be2:	4781                	li	a5,0
    80005be4:	a00d                	j	80005c06 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    80005be6:	f94a8713          	addi	a4,s5,-108
    80005bea:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    80005bee:	8656                	mv	a2,s5
    80005bf0:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005bf2:	f9460793          	addi	a5,a2,-108
    80005bf6:	0017b793          	seqz	a5,a5
    80005bfa:	8ff9                	and	a5,a5,a4
    80005bfc:	f9c68593          	addi	a1,a3,-100
    80005c00:	e199                	bnez	a1,80005c06 <printf+0x2ca>
    80005c02:	e20798e3          	bnez	a5,80005a32 <printf+0xf6>
    } else if(c0 == 'u'){
    80005c06:	e58a84e3          	beq	s5,s8,80005a4e <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    80005c0a:	f8b60593          	addi	a1,a2,-117
    80005c0e:	e199                	bnez	a1,80005c14 <printf+0x2d8>
    80005c10:	e4071ce3          	bnez	a4,80005a68 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005c14:	f8b68593          	addi	a1,a3,-117
    80005c18:	e199                	bnez	a1,80005c1e <printf+0x2e2>
    80005c1a:	e60795e3          	bnez	a5,80005a84 <printf+0x148>
    } else if(c0 == 'x'){
    80005c1e:	e9aa81e3          	beq	s5,s10,80005aa0 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    80005c22:	f8860613          	addi	a2,a2,-120
    80005c26:	e219                	bnez	a2,80005c2c <printf+0x2f0>
    80005c28:	e80719e3          	bnez	a4,80005aba <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005c2c:	f8868693          	addi	a3,a3,-120
    80005c30:	e299                	bnez	a3,80005c36 <printf+0x2fa>
    80005c32:	ea0791e3          	bnez	a5,80005ad4 <printf+0x198>
    } else if(c0 == 'p'){
    80005c36:	ebba8de3          	beq	s5,s11,80005af0 <printf+0x1b4>
    } else if(c0 == 'c'){
    80005c3a:	06300793          	li	a5,99
    80005c3e:	eefa8ce3          	beq	s5,a5,80005b36 <printf+0x1fa>
    } else if(c0 == 's'){
    80005c42:	07300793          	li	a5,115
    80005c46:	f0fa82e3          	beq	s5,a5,80005b4a <printf+0x20e>
    } else if(c0 == '%'){
    80005c4a:	02500793          	li	a5,37
    80005c4e:	f2fa8ae3          	beq	s5,a5,80005b82 <printf+0x246>
    } else if(c0 == 0){
    80005c52:	f60a80e3          	beqz	s5,80005bb2 <printf+0x276>
      consputc('%');
    80005c56:	02500513          	li	a0,37
    80005c5a:	a63ff0ef          	jal	800056bc <consputc>
      consputc(c0);
    80005c5e:	8556                	mv	a0,s5
    80005c60:	a5dff0ef          	jal	800056bc <consputc>
    80005c64:	bb81                	j	800059b4 <printf+0x78>

0000000080005c66 <panic>:

void
panic(char *s)
{
    80005c66:	1101                	addi	sp,sp,-32
    80005c68:	ec06                	sd	ra,24(sp)
    80005c6a:	e822                	sd	s0,16(sp)
    80005c6c:	e426                	sd	s1,8(sp)
    80005c6e:	e04a                	sd	s2,0(sp)
    80005c70:	1000                	addi	s0,sp,32
    80005c72:	892a                	mv	s2,a0
  panicking = 1;
    80005c74:	4485                	li	s1,1
    80005c76:	00002797          	auipc	a5,0x2
    80005c7a:	c697a523          	sw	s1,-918(a5) # 800078e0 <panicking>
  printf("panic: ");
    80005c7e:	00002517          	auipc	a0,0x2
    80005c82:	aba50513          	addi	a0,a0,-1350 # 80007738 <etext+0x738>
    80005c86:	cb7ff0ef          	jal	8000593c <printf>
  printf("%s\n", s);
    80005c8a:	85ca                	mv	a1,s2
    80005c8c:	00002517          	auipc	a0,0x2
    80005c90:	ab450513          	addi	a0,a0,-1356 # 80007740 <etext+0x740>
    80005c94:	ca9ff0ef          	jal	8000593c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005c98:	00002797          	auipc	a5,0x2
    80005c9c:	c497a223          	sw	s1,-956(a5) # 800078dc <panicked>
  for(;;)
    80005ca0:	a001                	j	80005ca0 <panic+0x3a>

0000000080005ca2 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005ca2:	1141                	addi	sp,sp,-16
    80005ca4:	e406                	sd	ra,8(sp)
    80005ca6:	e022                	sd	s0,0(sp)
    80005ca8:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005caa:	00002597          	auipc	a1,0x2
    80005cae:	a9e58593          	addi	a1,a1,-1378 # 80007748 <etext+0x748>
    80005cb2:	00027517          	auipc	a0,0x27
    80005cb6:	11650513          	addi	a0,a0,278 # 8002cdc8 <pr>
    80005cba:	1e4000ef          	jal	80005e9e <initlock>
}
    80005cbe:	60a2                	ld	ra,8(sp)
    80005cc0:	6402                	ld	s0,0(sp)
    80005cc2:	0141                	addi	sp,sp,16
    80005cc4:	8082                	ret

0000000080005cc6 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005cc6:	1141                	addi	sp,sp,-16
    80005cc8:	e406                	sd	ra,8(sp)
    80005cca:	e022                	sd	s0,0(sp)
    80005ccc:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005cce:	100007b7          	lui	a5,0x10000
    80005cd2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005cd6:	10000737          	lui	a4,0x10000
    80005cda:	f8000693          	li	a3,-128
    80005cde:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005ce2:	468d                	li	a3,3
    80005ce4:	10000637          	lui	a2,0x10000
    80005ce8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005cec:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005cf0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005cf4:	8732                	mv	a4,a2
    80005cf6:	461d                	li	a2,7
    80005cf8:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005cfc:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005d00:	00002597          	auipc	a1,0x2
    80005d04:	a5058593          	addi	a1,a1,-1456 # 80007750 <etext+0x750>
    80005d08:	00027517          	auipc	a0,0x27
    80005d0c:	0d850513          	addi	a0,a0,216 # 8002cde0 <tx_lock>
    80005d10:	18e000ef          	jal	80005e9e <initlock>
}
    80005d14:	60a2                	ld	ra,8(sp)
    80005d16:	6402                	ld	s0,0(sp)
    80005d18:	0141                	addi	sp,sp,16
    80005d1a:	8082                	ret

0000000080005d1c <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005d1c:	715d                	addi	sp,sp,-80
    80005d1e:	e486                	sd	ra,72(sp)
    80005d20:	e0a2                	sd	s0,64(sp)
    80005d22:	fc26                	sd	s1,56(sp)
    80005d24:	ec56                	sd	s5,24(sp)
    80005d26:	0880                	addi	s0,sp,80
    80005d28:	8aaa                	mv	s5,a0
    80005d2a:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005d2c:	00027517          	auipc	a0,0x27
    80005d30:	0b450513          	addi	a0,a0,180 # 8002cde0 <tx_lock>
    80005d34:	1f4000ef          	jal	80005f28 <acquire>

  int i = 0;
  while(i < n){ 
    80005d38:	06905063          	blez	s1,80005d98 <uartwrite+0x7c>
    80005d3c:	f84a                	sd	s2,48(sp)
    80005d3e:	f44e                	sd	s3,40(sp)
    80005d40:	f052                	sd	s4,32(sp)
    80005d42:	e85a                	sd	s6,16(sp)
    80005d44:	e45e                	sd	s7,8(sp)
    80005d46:	8a56                	mv	s4,s5
    80005d48:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005d4a:	00002497          	auipc	s1,0x2
    80005d4e:	b9e48493          	addi	s1,s1,-1122 # 800078e8 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005d52:	00027997          	auipc	s3,0x27
    80005d56:	08e98993          	addi	s3,s3,142 # 8002cde0 <tx_lock>
    80005d5a:	00002917          	auipc	s2,0x2
    80005d5e:	b8a90913          	addi	s2,s2,-1142 # 800078e4 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005d62:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005d66:	4b05                	li	s6,1
    80005d68:	a005                	j	80005d88 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005d6a:	85ce                	mv	a1,s3
    80005d6c:	854a                	mv	a0,s2
    80005d6e:	9c9fb0ef          	jal	80001736 <sleep>
    while(tx_busy != 0){
    80005d72:	409c                	lw	a5,0(s1)
    80005d74:	fbfd                	bnez	a5,80005d6a <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005d76:	000a4783          	lbu	a5,0(s4)
    80005d7a:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005d7e:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005d82:	0a05                	addi	s4,s4,1
    80005d84:	015a0563          	beq	s4,s5,80005d8e <uartwrite+0x72>
    while(tx_busy != 0){
    80005d88:	409c                	lw	a5,0(s1)
    80005d8a:	f3e5                	bnez	a5,80005d6a <uartwrite+0x4e>
    80005d8c:	b7ed                	j	80005d76 <uartwrite+0x5a>
    80005d8e:	7942                	ld	s2,48(sp)
    80005d90:	79a2                	ld	s3,40(sp)
    80005d92:	7a02                	ld	s4,32(sp)
    80005d94:	6b42                	ld	s6,16(sp)
    80005d96:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005d98:	00027517          	auipc	a0,0x27
    80005d9c:	04850513          	addi	a0,a0,72 # 8002cde0 <tx_lock>
    80005da0:	21c000ef          	jal	80005fbc <release>
}
    80005da4:	60a6                	ld	ra,72(sp)
    80005da6:	6406                	ld	s0,64(sp)
    80005da8:	74e2                	ld	s1,56(sp)
    80005daa:	6ae2                	ld	s5,24(sp)
    80005dac:	6161                	addi	sp,sp,80
    80005dae:	8082                	ret

0000000080005db0 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005db0:	1101                	addi	sp,sp,-32
    80005db2:	ec06                	sd	ra,24(sp)
    80005db4:	e822                	sd	s0,16(sp)
    80005db6:	e426                	sd	s1,8(sp)
    80005db8:	1000                	addi	s0,sp,32
    80005dba:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005dbc:	00002797          	auipc	a5,0x2
    80005dc0:	b247a783          	lw	a5,-1244(a5) # 800078e0 <panicking>
    80005dc4:	cf95                	beqz	a5,80005e00 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005dc6:	00002797          	auipc	a5,0x2
    80005dca:	b167a783          	lw	a5,-1258(a5) # 800078dc <panicked>
    80005dce:	ef85                	bnez	a5,80005e06 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005dd0:	10000737          	lui	a4,0x10000
    80005dd4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005dd6:	00074783          	lbu	a5,0(a4)
    80005dda:	0207f793          	andi	a5,a5,32
    80005dde:	dfe5                	beqz	a5,80005dd6 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005de0:	0ff4f513          	zext.b	a0,s1
    80005de4:	100007b7          	lui	a5,0x10000
    80005de8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005dec:	00002797          	auipc	a5,0x2
    80005df0:	af47a783          	lw	a5,-1292(a5) # 800078e0 <panicking>
    80005df4:	cb91                	beqz	a5,80005e08 <uartputc_sync+0x58>
    pop_off();
}
    80005df6:	60e2                	ld	ra,24(sp)
    80005df8:	6442                	ld	s0,16(sp)
    80005dfa:	64a2                	ld	s1,8(sp)
    80005dfc:	6105                	addi	sp,sp,32
    80005dfe:	8082                	ret
    push_off();
    80005e00:	0e4000ef          	jal	80005ee4 <push_off>
    80005e04:	b7c9                	j	80005dc6 <uartputc_sync+0x16>
    for(;;)
    80005e06:	a001                	j	80005e06 <uartputc_sync+0x56>
    pop_off();
    80005e08:	164000ef          	jal	80005f6c <pop_off>
}
    80005e0c:	b7ed                	j	80005df6 <uartputc_sync+0x46>

0000000080005e0e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005e0e:	1141                	addi	sp,sp,-16
    80005e10:	e406                	sd	ra,8(sp)
    80005e12:	e022                	sd	s0,0(sp)
    80005e14:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005e16:	100007b7          	lui	a5,0x10000
    80005e1a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005e1e:	8b85                	andi	a5,a5,1
    80005e20:	cb89                	beqz	a5,80005e32 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005e22:	100007b7          	lui	a5,0x10000
    80005e26:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005e2a:	60a2                	ld	ra,8(sp)
    80005e2c:	6402                	ld	s0,0(sp)
    80005e2e:	0141                	addi	sp,sp,16
    80005e30:	8082                	ret
    return -1;
    80005e32:	557d                	li	a0,-1
    80005e34:	bfdd                	j	80005e2a <uartgetc+0x1c>

0000000080005e36 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005e36:	1101                	addi	sp,sp,-32
    80005e38:	ec06                	sd	ra,24(sp)
    80005e3a:	e822                	sd	s0,16(sp)
    80005e3c:	e426                	sd	s1,8(sp)
    80005e3e:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005e40:	100007b7          	lui	a5,0x10000
    80005e44:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005e48:	00027517          	auipc	a0,0x27
    80005e4c:	f9850513          	addi	a0,a0,-104 # 8002cde0 <tx_lock>
    80005e50:	0d8000ef          	jal	80005f28 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005e54:	100007b7          	lui	a5,0x10000
    80005e58:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005e5c:	0207f793          	andi	a5,a5,32
    80005e60:	ef99                	bnez	a5,80005e7e <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005e62:	00027517          	auipc	a0,0x27
    80005e66:	f7e50513          	addi	a0,a0,-130 # 8002cde0 <tx_lock>
    80005e6a:	152000ef          	jal	80005fbc <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005e6e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005e70:	f9fff0ef          	jal	80005e0e <uartgetc>
    if(c == -1)
    80005e74:	02950063          	beq	a0,s1,80005e94 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005e78:	877ff0ef          	jal	800056ee <consoleintr>
  while(1){
    80005e7c:	bfd5                	j	80005e70 <uartintr+0x3a>
    tx_busy = 0;
    80005e7e:	00002797          	auipc	a5,0x2
    80005e82:	a607a523          	sw	zero,-1430(a5) # 800078e8 <tx_busy>
    wakeup(&tx_chan);
    80005e86:	00002517          	auipc	a0,0x2
    80005e8a:	a5e50513          	addi	a0,a0,-1442 # 800078e4 <tx_chan>
    80005e8e:	8f5fb0ef          	jal	80001782 <wakeup>
    80005e92:	bfc1                	j	80005e62 <uartintr+0x2c>
  }
}
    80005e94:	60e2                	ld	ra,24(sp)
    80005e96:	6442                	ld	s0,16(sp)
    80005e98:	64a2                	ld	s1,8(sp)
    80005e9a:	6105                	addi	sp,sp,32
    80005e9c:	8082                	ret

0000000080005e9e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005e9e:	1141                	addi	sp,sp,-16
    80005ea0:	e406                	sd	ra,8(sp)
    80005ea2:	e022                	sd	s0,0(sp)
    80005ea4:	0800                	addi	s0,sp,16
  lk->name = name;
    80005ea6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005ea8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005eac:	00053823          	sd	zero,16(a0)
}
    80005eb0:	60a2                	ld	ra,8(sp)
    80005eb2:	6402                	ld	s0,0(sp)
    80005eb4:	0141                	addi	sp,sp,16
    80005eb6:	8082                	ret

0000000080005eb8 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005eb8:	411c                	lw	a5,0(a0)
    80005eba:	e399                	bnez	a5,80005ec0 <holding+0x8>
    80005ebc:	4501                	li	a0,0
  return r;
}
    80005ebe:	8082                	ret
{
    80005ec0:	1101                	addi	sp,sp,-32
    80005ec2:	ec06                	sd	ra,24(sp)
    80005ec4:	e822                	sd	s0,16(sp)
    80005ec6:	e426                	sd	s1,8(sp)
    80005ec8:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005eca:	691c                	ld	a5,16(a0)
    80005ecc:	84be                	mv	s1,a5
    80005ece:	a02fb0ef          	jal	800010d0 <mycpu>
    80005ed2:	40a48533          	sub	a0,s1,a0
    80005ed6:	00153513          	seqz	a0,a0
}
    80005eda:	60e2                	ld	ra,24(sp)
    80005edc:	6442                	ld	s0,16(sp)
    80005ede:	64a2                	ld	s1,8(sp)
    80005ee0:	6105                	addi	sp,sp,32
    80005ee2:	8082                	ret

0000000080005ee4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005ee4:	1101                	addi	sp,sp,-32
    80005ee6:	ec06                	sd	ra,24(sp)
    80005ee8:	e822                	sd	s0,16(sp)
    80005eea:	e426                	sd	s1,8(sp)
    80005eec:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005eee:	100027f3          	csrr	a5,sstatus
    80005ef2:	84be                	mv	s1,a5
    80005ef4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005ef8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005efa:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005efe:	9d2fb0ef          	jal	800010d0 <mycpu>
    80005f02:	5d3c                	lw	a5,120(a0)
    80005f04:	cb99                	beqz	a5,80005f1a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005f06:	9cafb0ef          	jal	800010d0 <mycpu>
    80005f0a:	5d3c                	lw	a5,120(a0)
    80005f0c:	2785                	addiw	a5,a5,1
    80005f0e:	dd3c                	sw	a5,120(a0)
}
    80005f10:	60e2                	ld	ra,24(sp)
    80005f12:	6442                	ld	s0,16(sp)
    80005f14:	64a2                	ld	s1,8(sp)
    80005f16:	6105                	addi	sp,sp,32
    80005f18:	8082                	ret
    mycpu()->intena = old;
    80005f1a:	9b6fb0ef          	jal	800010d0 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005f1e:	0014d793          	srli	a5,s1,0x1
    80005f22:	8b85                	andi	a5,a5,1
    80005f24:	dd7c                	sw	a5,124(a0)
    80005f26:	b7c5                	j	80005f06 <push_off+0x22>

0000000080005f28 <acquire>:
{
    80005f28:	1101                	addi	sp,sp,-32
    80005f2a:	ec06                	sd	ra,24(sp)
    80005f2c:	e822                	sd	s0,16(sp)
    80005f2e:	e426                	sd	s1,8(sp)
    80005f30:	1000                	addi	s0,sp,32
    80005f32:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005f34:	fb1ff0ef          	jal	80005ee4 <push_off>
  if(holding(lk))
    80005f38:	8526                	mv	a0,s1
    80005f3a:	f7fff0ef          	jal	80005eb8 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005f3e:	4705                	li	a4,1
  if(holding(lk))
    80005f40:	e105                	bnez	a0,80005f60 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005f42:	87ba                	mv	a5,a4
    80005f44:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005f48:	2781                	sext.w	a5,a5
    80005f4a:	ffe5                	bnez	a5,80005f42 <acquire+0x1a>
  __sync_synchronize();
    80005f4c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005f50:	980fb0ef          	jal	800010d0 <mycpu>
    80005f54:	e888                	sd	a0,16(s1)
}
    80005f56:	60e2                	ld	ra,24(sp)
    80005f58:	6442                	ld	s0,16(sp)
    80005f5a:	64a2                	ld	s1,8(sp)
    80005f5c:	6105                	addi	sp,sp,32
    80005f5e:	8082                	ret
    panic("acquire");
    80005f60:	00001517          	auipc	a0,0x1
    80005f64:	7f850513          	addi	a0,a0,2040 # 80007758 <etext+0x758>
    80005f68:	cffff0ef          	jal	80005c66 <panic>

0000000080005f6c <pop_off>:

void
pop_off(void)
{
    80005f6c:	1141                	addi	sp,sp,-16
    80005f6e:	e406                	sd	ra,8(sp)
    80005f70:	e022                	sd	s0,0(sp)
    80005f72:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005f74:	95cfb0ef          	jal	800010d0 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005f78:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005f7c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005f7e:	e39d                	bnez	a5,80005fa4 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005f80:	5d3c                	lw	a5,120(a0)
    80005f82:	02f05763          	blez	a5,80005fb0 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005f86:	37fd                	addiw	a5,a5,-1
    80005f88:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005f8a:	eb89                	bnez	a5,80005f9c <pop_off+0x30>
    80005f8c:	5d7c                	lw	a5,124(a0)
    80005f8e:	c799                	beqz	a5,80005f9c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005f90:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005f94:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005f98:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005f9c:	60a2                	ld	ra,8(sp)
    80005f9e:	6402                	ld	s0,0(sp)
    80005fa0:	0141                	addi	sp,sp,16
    80005fa2:	8082                	ret
    panic("pop_off - interruptible");
    80005fa4:	00001517          	auipc	a0,0x1
    80005fa8:	7bc50513          	addi	a0,a0,1980 # 80007760 <etext+0x760>
    80005fac:	cbbff0ef          	jal	80005c66 <panic>
    panic("pop_off");
    80005fb0:	00001517          	auipc	a0,0x1
    80005fb4:	7c850513          	addi	a0,a0,1992 # 80007778 <etext+0x778>
    80005fb8:	cafff0ef          	jal	80005c66 <panic>

0000000080005fbc <release>:
{
    80005fbc:	1101                	addi	sp,sp,-32
    80005fbe:	ec06                	sd	ra,24(sp)
    80005fc0:	e822                	sd	s0,16(sp)
    80005fc2:	e426                	sd	s1,8(sp)
    80005fc4:	1000                	addi	s0,sp,32
    80005fc6:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005fc8:	ef1ff0ef          	jal	80005eb8 <holding>
    80005fcc:	c105                	beqz	a0,80005fec <release+0x30>
  lk->cpu = 0;
    80005fce:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005fd2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005fd6:	0310000f          	fence	rw,w
    80005fda:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005fde:	f8fff0ef          	jal	80005f6c <pop_off>
}
    80005fe2:	60e2                	ld	ra,24(sp)
    80005fe4:	6442                	ld	s0,16(sp)
    80005fe6:	64a2                	ld	s1,8(sp)
    80005fe8:	6105                	addi	sp,sp,32
    80005fea:	8082                	ret
    panic("release");
    80005fec:	00001517          	auipc	a0,0x1
    80005ff0:	79450513          	addi	a0,a0,1940 # 80007780 <etext+0x780>
    80005ff4:	c73ff0ef          	jal	80005c66 <panic>
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
