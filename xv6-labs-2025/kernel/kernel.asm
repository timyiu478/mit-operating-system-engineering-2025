
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
    80000004:	cb010113          	addi	sp,sp,-848 # 8001acb0 <stack0>
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
    80000016:	761040ef          	jal	80004f76 <start>

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
    8000002c:	d6078793          	addi	a5,a5,-672 # 80022d88 <end>
    80000030:	00f53733          	sltu	a4,a0,a5
    80000034:	47c5                	li	a5,17
    80000036:	07ee                	slli	a5,a5,0x1b
    80000038:	17fd                	addi	a5,a5,-1
    8000003a:	00a7b7b3          	sltu	a5,a5,a0
    8000003e:	8fd9                	or	a5,a5,a4
    80000040:	eb95                	bnez	a5,80000074 <kfree+0x58>
    80000042:	84aa                	mv	s1,a0
    80000044:	03451793          	slli	a5,a0,0x34
    80000048:	e795                	bnez	a5,80000074 <kfree+0x58>
  memset(pa, 1, PGSIZE);
#endif
  
  r = (struct run*)pa;

  acquire(&kmem.lock);
    8000004a:	00008917          	auipc	s2,0x8
    8000004e:	83690913          	addi	s2,s2,-1994 # 80007880 <kmem>
    80000052:	854a                	mv	a0,s2
    80000054:	1a5050ef          	jal	800059f8 <acquire>
  r->next = kmem.freelist;
    80000058:	01893783          	ld	a5,24(s2)
    8000005c:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    8000005e:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    80000062:	854a                	mv	a0,s2
    80000064:	229050ef          	jal	80005a8c <release>
}
    80000068:	60e2                	ld	ra,24(sp)
    8000006a:	6442                	ld	s0,16(sp)
    8000006c:	64a2                	ld	s1,8(sp)
    8000006e:	6902                	ld	s2,0(sp)
    80000070:	6105                	addi	sp,sp,32
    80000072:	8082                	ret
    panic("kfree");
    80000074:	00007517          	auipc	a0,0x7
    80000078:	f8c50513          	addi	a0,a0,-116 # 80007000 <etext>
    8000007c:	6ba050ef          	jal	80005736 <panic>

0000000080000080 <freerange>:
{
    80000080:	7179                	addi	sp,sp,-48
    80000082:	f406                	sd	ra,40(sp)
    80000084:	f022                	sd	s0,32(sp)
    80000086:	ec26                	sd	s1,24(sp)
    80000088:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    8000008a:	6785                	lui	a5,0x1
    8000008c:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    80000090:	00e504b3          	add	s1,a0,a4
    80000094:	777d                	lui	a4,0xfffff
    80000096:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000098:	94be                	add	s1,s1,a5
    8000009a:	0295e263          	bltu	a1,s1,800000be <freerange+0x3e>
    8000009e:	e84a                	sd	s2,16(sp)
    800000a0:	e44e                	sd	s3,8(sp)
    800000a2:	e052                	sd	s4,0(sp)
    800000a4:	892e                	mv	s2,a1
    kfree(p);
    800000a6:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000a8:	89be                	mv	s3,a5
    kfree(p);
    800000aa:	01448533          	add	a0,s1,s4
    800000ae:	f6fff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    800000b2:	94ce                	add	s1,s1,s3
    800000b4:	fe997be3          	bgeu	s2,s1,800000aa <freerange+0x2a>
    800000b8:	6942                	ld	s2,16(sp)
    800000ba:	69a2                	ld	s3,8(sp)
    800000bc:	6a02                	ld	s4,0(sp)
}
    800000be:	70a2                	ld	ra,40(sp)
    800000c0:	7402                	ld	s0,32(sp)
    800000c2:	64e2                	ld	s1,24(sp)
    800000c4:	6145                	addi	sp,sp,48
    800000c6:	8082                	ret

00000000800000c8 <kinit>:
{
    800000c8:	1141                	addi	sp,sp,-16
    800000ca:	e406                	sd	ra,8(sp)
    800000cc:	e022                	sd	s0,0(sp)
    800000ce:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000d0:	00007597          	auipc	a1,0x7
    800000d4:	f4058593          	addi	a1,a1,-192 # 80007010 <etext+0x10>
    800000d8:	00007517          	auipc	a0,0x7
    800000dc:	7a850513          	addi	a0,a0,1960 # 80007880 <kmem>
    800000e0:	08f050ef          	jal	8000596e <initlock>
  freerange(end, (void*)PHYSTOP);
    800000e4:	45c5                	li	a1,17
    800000e6:	05ee                	slli	a1,a1,0x1b
    800000e8:	00023517          	auipc	a0,0x23
    800000ec:	ca050513          	addi	a0,a0,-864 # 80022d88 <end>
    800000f0:	f91ff0ef          	jal	80000080 <freerange>
}
    800000f4:	60a2                	ld	ra,8(sp)
    800000f6:	6402                	ld	s0,0(sp)
    800000f8:	0141                	addi	sp,sp,16
    800000fa:	8082                	ret

00000000800000fc <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000fc:	1101                	addi	sp,sp,-32
    800000fe:	ec06                	sd	ra,24(sp)
    80000100:	e822                	sd	s0,16(sp)
    80000102:	e426                	sd	s1,8(sp)
    80000104:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000106:	00007517          	auipc	a0,0x7
    8000010a:	77a50513          	addi	a0,a0,1914 # 80007880 <kmem>
    8000010e:	0eb050ef          	jal	800059f8 <acquire>
  r = kmem.freelist;
    80000112:	00007497          	auipc	s1,0x7
    80000116:	7864b483          	ld	s1,1926(s1) # 80007898 <kmem+0x18>
  if(r) {
    8000011a:	c491                	beqz	s1,80000126 <kalloc+0x2a>
    kmem.freelist = r->next;
    8000011c:	609c                	ld	a5,0(s1)
    8000011e:	00007717          	auipc	a4,0x7
    80000122:	76f73d23          	sd	a5,1914(a4) # 80007898 <kmem+0x18>
  }
  release(&kmem.lock);
    80000126:	00007517          	auipc	a0,0x7
    8000012a:	75a50513          	addi	a0,a0,1882 # 80007880 <kmem>
    8000012e:	15f050ef          	jal	80005a8c <release>
#ifndef LAB_SYSCALL
  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
#endif
  return (void*)r;
}
    80000132:	8526                	mv	a0,s1
    80000134:	60e2                	ld	ra,24(sp)
    80000136:	6442                	ld	s0,16(sp)
    80000138:	64a2                	ld	s1,8(sp)
    8000013a:	6105                	addi	sp,sp,32
    8000013c:	8082                	ret

000000008000013e <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000013e:	1141                	addi	sp,sp,-16
    80000140:	e406                	sd	ra,8(sp)
    80000142:	e022                	sd	s0,0(sp)
    80000144:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    80000146:	ca19                	beqz	a2,8000015c <memset+0x1e>
    80000148:	87aa                	mv	a5,a0
    8000014a:	1602                	slli	a2,a2,0x20
    8000014c:	9201                	srli	a2,a2,0x20
    8000014e:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    80000152:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000156:	0785                	addi	a5,a5,1
    80000158:	fee79de3          	bne	a5,a4,80000152 <memset+0x14>
  }
  return dst;
}
    8000015c:	60a2                	ld	ra,8(sp)
    8000015e:	6402                	ld	s0,0(sp)
    80000160:	0141                	addi	sp,sp,16
    80000162:	8082                	ret

0000000080000164 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    80000164:	1141                	addi	sp,sp,-16
    80000166:	e406                	sd	ra,8(sp)
    80000168:	e022                	sd	s0,0(sp)
    8000016a:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    8000016c:	c61d                	beqz	a2,8000019a <memcmp+0x36>
    8000016e:	1602                	slli	a2,a2,0x20
    80000170:	9201                	srli	a2,a2,0x20
    80000172:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    80000176:	00054783          	lbu	a5,0(a0)
    8000017a:	0005c703          	lbu	a4,0(a1)
    8000017e:	00e79863          	bne	a5,a4,8000018e <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    80000182:	0505                	addi	a0,a0,1
    80000184:	0585                	addi	a1,a1,1
  while(n-- > 0){
    80000186:	fed518e3          	bne	a0,a3,80000176 <memcmp+0x12>
  }

  return 0;
    8000018a:	4501                	li	a0,0
    8000018c:	a019                	j	80000192 <memcmp+0x2e>
      return *s1 - *s2;
    8000018e:	40e7853b          	subw	a0,a5,a4
}
    80000192:	60a2                	ld	ra,8(sp)
    80000194:	6402                	ld	s0,0(sp)
    80000196:	0141                	addi	sp,sp,16
    80000198:	8082                	ret
  return 0;
    8000019a:	4501                	li	a0,0
    8000019c:	bfdd                	j	80000192 <memcmp+0x2e>

000000008000019e <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e406                	sd	ra,8(sp)
    800001a2:	e022                	sd	s0,0(sp)
    800001a4:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001a6:	c205                	beqz	a2,800001c6 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001a8:	02a5e363          	bltu	a1,a0,800001ce <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001ac:	1602                	slli	a2,a2,0x20
    800001ae:	9201                	srli	a2,a2,0x20
    800001b0:	00c587b3          	add	a5,a1,a2
{
    800001b4:	872a                	mv	a4,a0
      *d++ = *s++;
    800001b6:	0585                	addi	a1,a1,1
    800001b8:	0705                	addi	a4,a4,1
    800001ba:	fff5c683          	lbu	a3,-1(a1)
    800001be:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    800001c2:	feb79ae3          	bne	a5,a1,800001b6 <memmove+0x18>

  return dst;
}
    800001c6:	60a2                	ld	ra,8(sp)
    800001c8:	6402                	ld	s0,0(sp)
    800001ca:	0141                	addi	sp,sp,16
    800001cc:	8082                	ret
  if(s < d && s + n > d){
    800001ce:	02061693          	slli	a3,a2,0x20
    800001d2:	9281                	srli	a3,a3,0x20
    800001d4:	00d58733          	add	a4,a1,a3
    800001d8:	fce57ae3          	bgeu	a0,a4,800001ac <memmove+0xe>
    d += n;
    800001dc:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    800001de:	fff6079b          	addiw	a5,a2,-1
    800001e2:	1782                	slli	a5,a5,0x20
    800001e4:	9381                	srli	a5,a5,0x20
    800001e6:	fff7c793          	not	a5,a5
    800001ea:	97ba                	add	a5,a5,a4
      *--d = *--s;
    800001ec:	177d                	addi	a4,a4,-1
    800001ee:	16fd                	addi	a3,a3,-1
    800001f0:	00074603          	lbu	a2,0(a4)
    800001f4:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    800001f8:	fee79ae3          	bne	a5,a4,800001ec <memmove+0x4e>
    800001fc:	b7e9                	j	800001c6 <memmove+0x28>

00000000800001fe <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    800001fe:	1141                	addi	sp,sp,-16
    80000200:	e406                	sd	ra,8(sp)
    80000202:	e022                	sd	s0,0(sp)
    80000204:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000206:	f99ff0ef          	jal	8000019e <memmove>
}
    8000020a:	60a2                	ld	ra,8(sp)
    8000020c:	6402                	ld	s0,0(sp)
    8000020e:	0141                	addi	sp,sp,16
    80000210:	8082                	ret

0000000080000212 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000212:	1141                	addi	sp,sp,-16
    80000214:	e406                	sd	ra,8(sp)
    80000216:	e022                	sd	s0,0(sp)
    80000218:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    8000021a:	ce11                	beqz	a2,80000236 <strncmp+0x24>
    8000021c:	00054783          	lbu	a5,0(a0)
    80000220:	cf89                	beqz	a5,8000023a <strncmp+0x28>
    80000222:	0005c703          	lbu	a4,0(a1)
    80000226:	00f71a63          	bne	a4,a5,8000023a <strncmp+0x28>
    n--, p++, q++;
    8000022a:	367d                	addiw	a2,a2,-1
    8000022c:	0505                	addi	a0,a0,1
    8000022e:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000230:	f675                	bnez	a2,8000021c <strncmp+0xa>
  if(n == 0)
    return 0;
    80000232:	4501                	li	a0,0
    80000234:	a801                	j	80000244 <strncmp+0x32>
    80000236:	4501                	li	a0,0
    80000238:	a031                	j	80000244 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    8000023a:	00054503          	lbu	a0,0(a0)
    8000023e:	0005c783          	lbu	a5,0(a1)
    80000242:	9d1d                	subw	a0,a0,a5
}
    80000244:	60a2                	ld	ra,8(sp)
    80000246:	6402                	ld	s0,0(sp)
    80000248:	0141                	addi	sp,sp,16
    8000024a:	8082                	ret

000000008000024c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000024c:	1141                	addi	sp,sp,-16
    8000024e:	e406                	sd	ra,8(sp)
    80000250:	e022                	sd	s0,0(sp)
    80000252:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000254:	87aa                	mv	a5,a0
    80000256:	a011                	j	8000025a <strncpy+0xe>
    80000258:	8636                	mv	a2,a3
    8000025a:	02c05863          	blez	a2,8000028a <strncpy+0x3e>
    8000025e:	fff6069b          	addiw	a3,a2,-1
    80000262:	8836                	mv	a6,a3
    80000264:	0785                	addi	a5,a5,1
    80000266:	0005c703          	lbu	a4,0(a1)
    8000026a:	fee78fa3          	sb	a4,-1(a5)
    8000026e:	0585                	addi	a1,a1,1
    80000270:	f765                	bnez	a4,80000258 <strncpy+0xc>
    ;
  while(n-- > 0)
    80000272:	873e                	mv	a4,a5
    80000274:	01005b63          	blez	a6,8000028a <strncpy+0x3e>
    80000278:	9fb1                	addw	a5,a5,a2
    8000027a:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    8000027c:	0705                	addi	a4,a4,1
    8000027e:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    80000282:	40e786bb          	subw	a3,a5,a4
    80000286:	fed04be3          	bgtz	a3,8000027c <strncpy+0x30>
  return os;
}
    8000028a:	60a2                	ld	ra,8(sp)
    8000028c:	6402                	ld	s0,0(sp)
    8000028e:	0141                	addi	sp,sp,16
    80000290:	8082                	ret

0000000080000292 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    80000292:	1141                	addi	sp,sp,-16
    80000294:	e406                	sd	ra,8(sp)
    80000296:	e022                	sd	s0,0(sp)
    80000298:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    8000029a:	02c05363          	blez	a2,800002c0 <safestrcpy+0x2e>
    8000029e:	fff6069b          	addiw	a3,a2,-1
    800002a2:	1682                	slli	a3,a3,0x20
    800002a4:	9281                	srli	a3,a3,0x20
    800002a6:	96ae                	add	a3,a3,a1
    800002a8:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002aa:	00d58963          	beq	a1,a3,800002bc <safestrcpy+0x2a>
    800002ae:	0585                	addi	a1,a1,1
    800002b0:	0785                	addi	a5,a5,1
    800002b2:	fff5c703          	lbu	a4,-1(a1)
    800002b6:	fee78fa3          	sb	a4,-1(a5)
    800002ba:	fb65                	bnez	a4,800002aa <safestrcpy+0x18>
    ;
  *s = 0;
    800002bc:	00078023          	sb	zero,0(a5)
  return os;
}
    800002c0:	60a2                	ld	ra,8(sp)
    800002c2:	6402                	ld	s0,0(sp)
    800002c4:	0141                	addi	sp,sp,16
    800002c6:	8082                	ret

00000000800002c8 <strlen>:

int
strlen(const char *s)
{
    800002c8:	1141                	addi	sp,sp,-16
    800002ca:	e406                	sd	ra,8(sp)
    800002cc:	e022                	sd	s0,0(sp)
    800002ce:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    800002d0:	00054783          	lbu	a5,0(a0)
    800002d4:	cf91                	beqz	a5,800002f0 <strlen+0x28>
    800002d6:	00150793          	addi	a5,a0,1
    800002da:	86be                	mv	a3,a5
    800002dc:	0785                	addi	a5,a5,1
    800002de:	fff7c703          	lbu	a4,-1(a5)
    800002e2:	ff65                	bnez	a4,800002da <strlen+0x12>
    800002e4:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    800002e8:	60a2                	ld	ra,8(sp)
    800002ea:	6402                	ld	s0,0(sp)
    800002ec:	0141                	addi	sp,sp,16
    800002ee:	8082                	ret
  for(n = 0; s[n]; n++)
    800002f0:	4501                	li	a0,0
    800002f2:	bfdd                	j	800002e8 <strlen+0x20>

00000000800002f4 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    800002f4:	1141                	addi	sp,sp,-16
    800002f6:	e406                	sd	ra,8(sp)
    800002f8:	e022                	sd	s0,0(sp)
    800002fa:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    800002fc:	24f000ef          	jal	80000d4a <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000300:	00007717          	auipc	a4,0x7
    80000304:	55070713          	addi	a4,a4,1360 # 80007850 <started>
  if(cpuid() == 0){
    80000308:	c51d                	beqz	a0,80000336 <main+0x42>
    while(started == 0)
    8000030a:	431c                	lw	a5,0(a4)
    8000030c:	2781                	sext.w	a5,a5
    8000030e:	dff5                	beqz	a5,8000030a <main+0x16>
      ;
    __sync_synchronize();
    80000310:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000314:	237000ef          	jal	80000d4a <cpuid>
    80000318:	85aa                	mv	a1,a0
    8000031a:	00007517          	auipc	a0,0x7
    8000031e:	d1e50513          	addi	a0,a0,-738 # 80007038 <etext+0x38>
    80000322:	0ea050ef          	jal	8000540c <printf>
    kvminithart();    // turn on paging
    80000326:	080000ef          	jal	800003a6 <kvminithart>
    trapinithart();   // install kernel trap vector
    8000032a:	590010ef          	jal	800018ba <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000032e:	68a040ef          	jal	800049b8 <plicinithart>
  }

  scheduler();        
    80000332:	6cf000ef          	jal	80001200 <scheduler>
    consoleinit();
    80000336:	7fd040ef          	jal	80005332 <consoleinit>
    printfinit();
    8000033a:	438050ef          	jal	80005772 <printfinit>
    printf("\n");
    8000033e:	00007517          	auipc	a0,0x7
    80000342:	cda50513          	addi	a0,a0,-806 # 80007018 <etext+0x18>
    80000346:	0c6050ef          	jal	8000540c <printf>
    printf("xv6 kernel is booting\n");
    8000034a:	00007517          	auipc	a0,0x7
    8000034e:	cd650513          	addi	a0,a0,-810 # 80007020 <etext+0x20>
    80000352:	0ba050ef          	jal	8000540c <printf>
    printf("\n");
    80000356:	00007517          	auipc	a0,0x7
    8000035a:	cc250513          	addi	a0,a0,-830 # 80007018 <etext+0x18>
    8000035e:	0ae050ef          	jal	8000540c <printf>
    kinit();         // physical page allocator
    80000362:	d67ff0ef          	jal	800000c8 <kinit>
    kvminit();       // create kernel page table
    80000366:	2cc000ef          	jal	80000632 <kvminit>
    kvminithart();   // turn on paging
    8000036a:	03c000ef          	jal	800003a6 <kvminithart>
    procinit();      // process table
    8000036e:	12f000ef          	jal	80000c9c <procinit>
    trapinit();      // trap vectors
    80000372:	524010ef          	jal	80001896 <trapinit>
    trapinithart();  // install kernel trap vector
    80000376:	544010ef          	jal	800018ba <trapinithart>
    plicinit();      // set up interrupt controller
    8000037a:	624040ef          	jal	8000499e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    8000037e:	63a040ef          	jal	800049b8 <plicinithart>
    binit();         // buffer cache
    80000382:	4b9010ef          	jal	8000203a <binit>
    iinit();         // inode table
    80000386:	20a020ef          	jal	80002590 <iinit>
    fileinit();      // file table
    8000038a:	136030ef          	jal	800034c0 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000038e:	71a040ef          	jal	80004aa8 <virtio_disk_init>
    userinit();      // first user process
    80000392:	4b7000ef          	jal	80001048 <userinit>
    __sync_synchronize();
    80000396:	0330000f          	fence	rw,rw
    started = 1;
    8000039a:	4785                	li	a5,1
    8000039c:	00007717          	auipc	a4,0x7
    800003a0:	4af72a23          	sw	a5,1204(a4) # 80007850 <started>
    800003a4:	b779                	j	80000332 <main+0x3e>

00000000800003a6 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    800003a6:	1141                	addi	sp,sp,-16
    800003a8:	e406                	sd	ra,8(sp)
    800003aa:	e022                	sd	s0,0(sp)
    800003ac:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    800003ae:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    800003b2:	00007797          	auipc	a5,0x7
    800003b6:	4a67b783          	ld	a5,1190(a5) # 80007858 <kernel_pagetable>
    800003ba:	83b1                	srli	a5,a5,0xc
    800003bc:	577d                	li	a4,-1
    800003be:	177e                	slli	a4,a4,0x3f
    800003c0:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    800003c2:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    800003c6:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    800003ca:	60a2                	ld	ra,8(sp)
    800003cc:	6402                	ld	s0,0(sp)
    800003ce:	0141                	addi	sp,sp,16
    800003d0:	8082                	ret

00000000800003d2 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    800003d2:	7139                	addi	sp,sp,-64
    800003d4:	fc06                	sd	ra,56(sp)
    800003d6:	f822                	sd	s0,48(sp)
    800003d8:	f426                	sd	s1,40(sp)
    800003da:	f04a                	sd	s2,32(sp)
    800003dc:	ec4e                	sd	s3,24(sp)
    800003de:	e852                	sd	s4,16(sp)
    800003e0:	e456                	sd	s5,8(sp)
    800003e2:	e05a                	sd	s6,0(sp)
    800003e4:	0080                	addi	s0,sp,64
    800003e6:	84aa                	mv	s1,a0
    800003e8:	89ae                	mv	s3,a1
    800003ea:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    800003ec:	57fd                	li	a5,-1
    800003ee:	83e9                	srli	a5,a5,0x1a
    800003f0:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    800003f2:	4ab1                	li	s5,12
  if(va >= MAXVA)
    800003f4:	04b7e263          	bltu	a5,a1,80000438 <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    800003f8:	0149d933          	srl	s2,s3,s4
    800003fc:	1ff97913          	andi	s2,s2,511
    80000400:	090e                	slli	s2,s2,0x3
    80000402:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000404:	00093483          	ld	s1,0(s2)
    80000408:	0014f793          	andi	a5,s1,1
    8000040c:	cf85                	beqz	a5,80000444 <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    8000040e:	80a9                	srli	s1,s1,0xa
    80000410:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000412:	3a5d                	addiw	s4,s4,-9
    80000414:	ff5a12e3          	bne	s4,s5,800003f8 <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    80000418:	00c9d513          	srli	a0,s3,0xc
    8000041c:	1ff57513          	andi	a0,a0,511
    80000420:	050e                	slli	a0,a0,0x3
    80000422:	9526                	add	a0,a0,s1
}
    80000424:	70e2                	ld	ra,56(sp)
    80000426:	7442                	ld	s0,48(sp)
    80000428:	74a2                	ld	s1,40(sp)
    8000042a:	7902                	ld	s2,32(sp)
    8000042c:	69e2                	ld	s3,24(sp)
    8000042e:	6a42                	ld	s4,16(sp)
    80000430:	6aa2                	ld	s5,8(sp)
    80000432:	6b02                	ld	s6,0(sp)
    80000434:	6121                	addi	sp,sp,64
    80000436:	8082                	ret
    panic("walk");
    80000438:	00007517          	auipc	a0,0x7
    8000043c:	c1850513          	addi	a0,a0,-1000 # 80007050 <etext+0x50>
    80000440:	2f6050ef          	jal	80005736 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    80000444:	020b0263          	beqz	s6,80000468 <walk+0x96>
    80000448:	cb5ff0ef          	jal	800000fc <kalloc>
    8000044c:	84aa                	mv	s1,a0
    8000044e:	d979                	beqz	a0,80000424 <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    80000450:	6605                	lui	a2,0x1
    80000452:	4581                	li	a1,0
    80000454:	cebff0ef          	jal	8000013e <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    80000458:	00c4d793          	srli	a5,s1,0xc
    8000045c:	07aa                	slli	a5,a5,0xa
    8000045e:	0017e793          	ori	a5,a5,1
    80000462:	00f93023          	sd	a5,0(s2)
    80000466:	b775                	j	80000412 <walk+0x40>
        return 0;
    80000468:	4501                	li	a0,0
    8000046a:	bf6d                	j	80000424 <walk+0x52>

000000008000046c <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    8000046c:	57fd                	li	a5,-1
    8000046e:	83e9                	srli	a5,a5,0x1a
    80000470:	00b7f463          	bgeu	a5,a1,80000478 <walkaddr+0xc>
    return 0;
    80000474:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    80000476:	8082                	ret
{
    80000478:	1141                	addi	sp,sp,-16
    8000047a:	e406                	sd	ra,8(sp)
    8000047c:	e022                	sd	s0,0(sp)
    8000047e:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    80000480:	4601                	li	a2,0
    80000482:	f51ff0ef          	jal	800003d2 <walk>
  if(pte == 0)
    80000486:	c901                	beqz	a0,80000496 <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    80000488:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    8000048a:	0117f693          	andi	a3,a5,17
    8000048e:	4745                	li	a4,17
    return 0;
    80000490:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    80000492:	00e68663          	beq	a3,a4,8000049e <walkaddr+0x32>
}
    80000496:	60a2                	ld	ra,8(sp)
    80000498:	6402                	ld	s0,0(sp)
    8000049a:	0141                	addi	sp,sp,16
    8000049c:	8082                	ret
  pa = PTE2PA(*pte);
    8000049e:	83a9                	srli	a5,a5,0xa
    800004a0:	00c79513          	slli	a0,a5,0xc
  return pa;
    800004a4:	bfcd                	j	80000496 <walkaddr+0x2a>

00000000800004a6 <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800004a6:	715d                	addi	sp,sp,-80
    800004a8:	e486                	sd	ra,72(sp)
    800004aa:	e0a2                	sd	s0,64(sp)
    800004ac:	fc26                	sd	s1,56(sp)
    800004ae:	f84a                	sd	s2,48(sp)
    800004b0:	f44e                	sd	s3,40(sp)
    800004b2:	f052                	sd	s4,32(sp)
    800004b4:	ec56                	sd	s5,24(sp)
    800004b6:	e85a                	sd	s6,16(sp)
    800004b8:	e45e                	sd	s7,8(sp)
    800004ba:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800004bc:	03459793          	slli	a5,a1,0x34
    800004c0:	eba1                	bnez	a5,80000510 <mappages+0x6a>
    800004c2:	8a2a                	mv	s4,a0
    800004c4:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800004c6:	03461793          	slli	a5,a2,0x34
    800004ca:	eba9                	bnez	a5,8000051c <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    800004cc:	ce31                	beqz	a2,80000528 <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    800004ce:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    800004d2:	80060613          	addi	a2,a2,-2048
    800004d6:	00b60933          	add	s2,a2,a1
  a = va;
    800004da:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    800004dc:	4b05                	li	s6,1
    800004de:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800004e2:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    800004e4:	865a                	mv	a2,s6
    800004e6:	85a6                	mv	a1,s1
    800004e8:	8552                	mv	a0,s4
    800004ea:	ee9ff0ef          	jal	800003d2 <walk>
    800004ee:	c929                	beqz	a0,80000540 <mappages+0x9a>
    if(*pte & PTE_V)
    800004f0:	611c                	ld	a5,0(a0)
    800004f2:	8b85                	andi	a5,a5,1
    800004f4:	e3a1                	bnez	a5,80000534 <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    800004f6:	013487b3          	add	a5,s1,s3
    800004fa:	83b1                	srli	a5,a5,0xc
    800004fc:	07aa                	slli	a5,a5,0xa
    800004fe:	0157e7b3          	or	a5,a5,s5
    80000502:	0017e793          	ori	a5,a5,1
    80000506:	e11c                	sd	a5,0(a0)
    if(a == last)
    80000508:	05248863          	beq	s1,s2,80000558 <mappages+0xb2>
    a += PGSIZE;
    8000050c:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    8000050e:	bfd9                	j	800004e4 <mappages+0x3e>
    panic("mappages: va not aligned");
    80000510:	00007517          	auipc	a0,0x7
    80000514:	b4850513          	addi	a0,a0,-1208 # 80007058 <etext+0x58>
    80000518:	21e050ef          	jal	80005736 <panic>
    panic("mappages: size not aligned");
    8000051c:	00007517          	auipc	a0,0x7
    80000520:	b5c50513          	addi	a0,a0,-1188 # 80007078 <etext+0x78>
    80000524:	212050ef          	jal	80005736 <panic>
    panic("mappages: size");
    80000528:	00007517          	auipc	a0,0x7
    8000052c:	b7050513          	addi	a0,a0,-1168 # 80007098 <etext+0x98>
    80000530:	206050ef          	jal	80005736 <panic>
      panic("mappages: remap");
    80000534:	00007517          	auipc	a0,0x7
    80000538:	b7450513          	addi	a0,a0,-1164 # 800070a8 <etext+0xa8>
    8000053c:	1fa050ef          	jal	80005736 <panic>
      return -1;
    80000540:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    80000542:	60a6                	ld	ra,72(sp)
    80000544:	6406                	ld	s0,64(sp)
    80000546:	74e2                	ld	s1,56(sp)
    80000548:	7942                	ld	s2,48(sp)
    8000054a:	79a2                	ld	s3,40(sp)
    8000054c:	7a02                	ld	s4,32(sp)
    8000054e:	6ae2                	ld	s5,24(sp)
    80000550:	6b42                	ld	s6,16(sp)
    80000552:	6ba2                	ld	s7,8(sp)
    80000554:	6161                	addi	sp,sp,80
    80000556:	8082                	ret
  return 0;
    80000558:	4501                	li	a0,0
    8000055a:	b7e5                	j	80000542 <mappages+0x9c>

000000008000055c <kvmmap>:
{
    8000055c:	1141                	addi	sp,sp,-16
    8000055e:	e406                	sd	ra,8(sp)
    80000560:	e022                	sd	s0,0(sp)
    80000562:	0800                	addi	s0,sp,16
    80000564:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000566:	86b2                	mv	a3,a2
    80000568:	863e                	mv	a2,a5
    8000056a:	f3dff0ef          	jal	800004a6 <mappages>
    8000056e:	e509                	bnez	a0,80000578 <kvmmap+0x1c>
}
    80000570:	60a2                	ld	ra,8(sp)
    80000572:	6402                	ld	s0,0(sp)
    80000574:	0141                	addi	sp,sp,16
    80000576:	8082                	ret
    panic("kvmmap");
    80000578:	00007517          	auipc	a0,0x7
    8000057c:	b4050513          	addi	a0,a0,-1216 # 800070b8 <etext+0xb8>
    80000580:	1b6050ef          	jal	80005736 <panic>

0000000080000584 <kvmmake>:
{
    80000584:	1101                	addi	sp,sp,-32
    80000586:	ec06                	sd	ra,24(sp)
    80000588:	e822                	sd	s0,16(sp)
    8000058a:	e426                	sd	s1,8(sp)
    8000058c:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000058e:	b6fff0ef          	jal	800000fc <kalloc>
    80000592:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000594:	6605                	lui	a2,0x1
    80000596:	4581                	li	a1,0
    80000598:	ba7ff0ef          	jal	8000013e <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000059c:	4719                	li	a4,6
    8000059e:	6685                	lui	a3,0x1
    800005a0:	10000637          	lui	a2,0x10000
    800005a4:	85b2                	mv	a1,a2
    800005a6:	8526                	mv	a0,s1
    800005a8:	fb5ff0ef          	jal	8000055c <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    800005ac:	4719                	li	a4,6
    800005ae:	6685                	lui	a3,0x1
    800005b0:	10001637          	lui	a2,0x10001
    800005b4:	85b2                	mv	a1,a2
    800005b6:	8526                	mv	a0,s1
    800005b8:	fa5ff0ef          	jal	8000055c <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    800005bc:	4719                	li	a4,6
    800005be:	040006b7          	lui	a3,0x4000
    800005c2:	0c000637          	lui	a2,0xc000
    800005c6:	85b2                	mv	a1,a2
    800005c8:	8526                	mv	a0,s1
    800005ca:	f93ff0ef          	jal	8000055c <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    800005ce:	4729                	li	a4,10
    800005d0:	80007697          	auipc	a3,0x80007
    800005d4:	a3068693          	addi	a3,a3,-1488 # 7000 <_entry-0x7fff9000>
    800005d8:	4605                	li	a2,1
    800005da:	067e                	slli	a2,a2,0x1f
    800005dc:	85b2                	mv	a1,a2
    800005de:	8526                	mv	a0,s1
    800005e0:	f7dff0ef          	jal	8000055c <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    800005e4:	4719                	li	a4,6
    800005e6:	00007697          	auipc	a3,0x7
    800005ea:	a1a68693          	addi	a3,a3,-1510 # 80007000 <etext>
    800005ee:	47c5                	li	a5,17
    800005f0:	07ee                	slli	a5,a5,0x1b
    800005f2:	40d786b3          	sub	a3,a5,a3
    800005f6:	00007617          	auipc	a2,0x7
    800005fa:	a0a60613          	addi	a2,a2,-1526 # 80007000 <etext>
    800005fe:	85b2                	mv	a1,a2
    80000600:	8526                	mv	a0,s1
    80000602:	f5bff0ef          	jal	8000055c <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    80000606:	4729                	li	a4,10
    80000608:	6685                	lui	a3,0x1
    8000060a:	00006617          	auipc	a2,0x6
    8000060e:	9f660613          	addi	a2,a2,-1546 # 80006000 <_trampoline>
    80000612:	040005b7          	lui	a1,0x4000
    80000616:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000618:	05b2                	slli	a1,a1,0xc
    8000061a:	8526                	mv	a0,s1
    8000061c:	f41ff0ef          	jal	8000055c <kvmmap>
  proc_mapstacks(kpgtbl);
    80000620:	8526                	mv	a0,s1
    80000622:	5de000ef          	jal	80000c00 <proc_mapstacks>
}
    80000626:	8526                	mv	a0,s1
    80000628:	60e2                	ld	ra,24(sp)
    8000062a:	6442                	ld	s0,16(sp)
    8000062c:	64a2                	ld	s1,8(sp)
    8000062e:	6105                	addi	sp,sp,32
    80000630:	8082                	ret

0000000080000632 <kvminit>:
{
    80000632:	1141                	addi	sp,sp,-16
    80000634:	e406                	sd	ra,8(sp)
    80000636:	e022                	sd	s0,0(sp)
    80000638:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    8000063a:	f4bff0ef          	jal	80000584 <kvmmake>
    8000063e:	00007797          	auipc	a5,0x7
    80000642:	20a7bd23          	sd	a0,538(a5) # 80007858 <kernel_pagetable>
}
    80000646:	60a2                	ld	ra,8(sp)
    80000648:	6402                	ld	s0,0(sp)
    8000064a:	0141                	addi	sp,sp,16
    8000064c:	8082                	ret

000000008000064e <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    8000064e:	1101                	addi	sp,sp,-32
    80000650:	ec06                	sd	ra,24(sp)
    80000652:	e822                	sd	s0,16(sp)
    80000654:	e426                	sd	s1,8(sp)
    80000656:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    80000658:	aa5ff0ef          	jal	800000fc <kalloc>
    8000065c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000065e:	c509                	beqz	a0,80000668 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    80000660:	6605                	lui	a2,0x1
    80000662:	4581                	li	a1,0
    80000664:	adbff0ef          	jal	8000013e <memset>
  return pagetable;
}
    80000668:	8526                	mv	a0,s1
    8000066a:	60e2                	ld	ra,24(sp)
    8000066c:	6442                	ld	s0,16(sp)
    8000066e:	64a2                	ld	s1,8(sp)
    80000670:	6105                	addi	sp,sp,32
    80000672:	8082                	ret

0000000080000674 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000674:	715d                	addi	sp,sp,-80
    80000676:	e486                	sd	ra,72(sp)
    80000678:	e0a2                	sd	s0,64(sp)
    8000067a:	0880                	addi	s0,sp,80
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;

  if((va % PGSIZE) != 0)
    8000067c:	03459793          	slli	a5,a1,0x34
    80000680:	e39d                	bnez	a5,800006a6 <uvmunmap+0x32>
    80000682:	f84a                	sd	s2,48(sp)
    80000684:	f44e                	sd	s3,40(sp)
    80000686:	f052                	sd	s4,32(sp)
    80000688:	ec56                	sd	s5,24(sp)
    8000068a:	e85a                	sd	s6,16(sp)
    8000068c:	e45e                	sd	s7,8(sp)
    8000068e:	8a2a                	mv	s4,a0
    80000690:	892e                	mv	s2,a1
    80000692:	8b36                	mv	s6,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000694:	0632                	slli	a2,a2,0xc
    80000696:	00b609b3          	add	s3,a2,a1
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
      continue;
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
      continue;
    sz = PGSIZE;
    if(PTE_FLAGS(*pte) == PTE_V)
    8000069a:	4b85                	li	s7,1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    8000069c:	6a85                	lui	s5,0x1
    8000069e:	0735f463          	bgeu	a1,s3,80000706 <uvmunmap+0x92>
    800006a2:	fc26                	sd	s1,56(sp)
    800006a4:	a80d                	j	800006d6 <uvmunmap+0x62>
    800006a6:	fc26                	sd	s1,56(sp)
    800006a8:	f84a                	sd	s2,48(sp)
    800006aa:	f44e                	sd	s3,40(sp)
    800006ac:	f052                	sd	s4,32(sp)
    800006ae:	ec56                	sd	s5,24(sp)
    800006b0:	e85a                	sd	s6,16(sp)
    800006b2:	e45e                	sd	s7,8(sp)
    panic("uvmunmap: not aligned");
    800006b4:	00007517          	auipc	a0,0x7
    800006b8:	a0c50513          	addi	a0,a0,-1524 # 800070c0 <etext+0xc0>
    800006bc:	07a050ef          	jal	80005736 <panic>
      panic("uvmunmap: not a leaf");
    800006c0:	00007517          	auipc	a0,0x7
    800006c4:	a1850513          	addi	a0,a0,-1512 # 800070d8 <etext+0xd8>
    800006c8:	06e050ef          	jal	80005736 <panic>
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    800006cc:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    800006d0:	9956                	add	s2,s2,s5
    800006d2:	03397963          	bgeu	s2,s3,80000704 <uvmunmap+0x90>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    800006d6:	4601                	li	a2,0
    800006d8:	85ca                	mv	a1,s2
    800006da:	8552                	mv	a0,s4
    800006dc:	cf7ff0ef          	jal	800003d2 <walk>
    800006e0:	84aa                	mv	s1,a0
    800006e2:	d57d                	beqz	a0,800006d0 <uvmunmap+0x5c>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    800006e4:	611c                	ld	a5,0(a0)
    800006e6:	0017f713          	andi	a4,a5,1
    800006ea:	d37d                	beqz	a4,800006d0 <uvmunmap+0x5c>
    if(PTE_FLAGS(*pte) == PTE_V)
    800006ec:	3ff7f713          	andi	a4,a5,1023
    800006f0:	fd7708e3          	beq	a4,s7,800006c0 <uvmunmap+0x4c>
    if(do_free){
    800006f4:	fc0b0ce3          	beqz	s6,800006cc <uvmunmap+0x58>
      uint64 pa = PTE2PA(*pte);
    800006f8:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    800006fa:	00c79513          	slli	a0,a5,0xc
    800006fe:	91fff0ef          	jal	8000001c <kfree>
    80000702:	b7e9                	j	800006cc <uvmunmap+0x58>
    80000704:	74e2                	ld	s1,56(sp)
    80000706:	7942                	ld	s2,48(sp)
    80000708:	79a2                	ld	s3,40(sp)
    8000070a:	7a02                	ld	s4,32(sp)
    8000070c:	6ae2                	ld	s5,24(sp)
    8000070e:	6b42                	ld	s6,16(sp)
    80000710:	6ba2                	ld	s7,8(sp)
  }
}
    80000712:	60a6                	ld	ra,72(sp)
    80000714:	6406                	ld	s0,64(sp)
    80000716:	6161                	addi	sp,sp,80
    80000718:	8082                	ret

000000008000071a <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000071a:	1101                	addi	sp,sp,-32
    8000071c:	ec06                	sd	ra,24(sp)
    8000071e:	e822                	sd	s0,16(sp)
    80000720:	e426                	sd	s1,8(sp)
    80000722:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000724:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000726:	00b67d63          	bgeu	a2,a1,80000740 <uvmdealloc+0x26>
    8000072a:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    8000072c:	6785                	lui	a5,0x1
    8000072e:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000730:	00f60733          	add	a4,a2,a5
    80000734:	76fd                	lui	a3,0xfffff
    80000736:	8f75                	and	a4,a4,a3
    80000738:	97ae                	add	a5,a5,a1
    8000073a:	8ff5                	and	a5,a5,a3
    8000073c:	00f76863          	bltu	a4,a5,8000074c <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000740:	8526                	mv	a0,s1
    80000742:	60e2                	ld	ra,24(sp)
    80000744:	6442                	ld	s0,16(sp)
    80000746:	64a2                	ld	s1,8(sp)
    80000748:	6105                	addi	sp,sp,32
    8000074a:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000074c:	8f99                	sub	a5,a5,a4
    8000074e:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000750:	4685                	li	a3,1
    80000752:	0007861b          	sext.w	a2,a5
    80000756:	85ba                	mv	a1,a4
    80000758:	f1dff0ef          	jal	80000674 <uvmunmap>
    8000075c:	b7d5                	j	80000740 <uvmdealloc+0x26>

000000008000075e <uvmalloc>:
  if(newsz < oldsz)
    8000075e:	08b66d63          	bltu	a2,a1,800007f8 <uvmalloc+0x9a>
{
    80000762:	715d                	addi	sp,sp,-80
    80000764:	e486                	sd	ra,72(sp)
    80000766:	e0a2                	sd	s0,64(sp)
    80000768:	f84a                	sd	s2,48(sp)
    8000076a:	f052                	sd	s4,32(sp)
    8000076c:	ec56                	sd	s5,24(sp)
    8000076e:	e45e                	sd	s7,8(sp)
    80000770:	0880                	addi	s0,sp,80
    80000772:	8aaa                	mv	s5,a0
    80000774:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    80000776:	6785                	lui	a5,0x1
    80000778:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000077a:	95be                	add	a1,a1,a5
    8000077c:	77fd                	lui	a5,0xfffff
    8000077e:	00f5f933          	and	s2,a1,a5
    80000782:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += sz){
    80000784:	06c97c63          	bgeu	s2,a2,800007fc <uvmalloc+0x9e>
    80000788:	fc26                	sd	s1,56(sp)
    8000078a:	f44e                	sd	s3,40(sp)
    8000078c:	e85a                	sd	s6,16(sp)
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000078e:	0126eb13          	ori	s6,a3,18
    80000792:	6985                	lui	s3,0x1
    mem = kalloc();
    80000794:	969ff0ef          	jal	800000fc <kalloc>
    80000798:	84aa                	mv	s1,a0
    if(mem == 0){
    8000079a:	c10d                	beqz	a0,800007bc <uvmalloc+0x5e>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    8000079c:	875a                	mv	a4,s6
    8000079e:	86aa                	mv	a3,a0
    800007a0:	864e                	mv	a2,s3
    800007a2:	85ca                	mv	a1,s2
    800007a4:	8556                	mv	a0,s5
    800007a6:	d01ff0ef          	jal	800004a6 <mappages>
    800007aa:	e915                	bnez	a0,800007de <uvmalloc+0x80>
  for(a = oldsz; a < newsz; a += sz){
    800007ac:	994e                	add	s2,s2,s3
    800007ae:	ff4963e3          	bltu	s2,s4,80000794 <uvmalloc+0x36>
  return newsz;
    800007b2:	8552                	mv	a0,s4
    800007b4:	74e2                	ld	s1,56(sp)
    800007b6:	79a2                	ld	s3,40(sp)
    800007b8:	6b42                	ld	s6,16(sp)
    800007ba:	a811                	j	800007ce <uvmalloc+0x70>
      uvmdealloc(pagetable, a, oldsz);
    800007bc:	865e                	mv	a2,s7
    800007be:	85ca                	mv	a1,s2
    800007c0:	8556                	mv	a0,s5
    800007c2:	f59ff0ef          	jal	8000071a <uvmdealloc>
      return 0;
    800007c6:	4501                	li	a0,0
    800007c8:	74e2                	ld	s1,56(sp)
    800007ca:	79a2                	ld	s3,40(sp)
    800007cc:	6b42                	ld	s6,16(sp)
}
    800007ce:	60a6                	ld	ra,72(sp)
    800007d0:	6406                	ld	s0,64(sp)
    800007d2:	7942                	ld	s2,48(sp)
    800007d4:	7a02                	ld	s4,32(sp)
    800007d6:	6ae2                	ld	s5,24(sp)
    800007d8:	6ba2                	ld	s7,8(sp)
    800007da:	6161                	addi	sp,sp,80
    800007dc:	8082                	ret
      kfree(mem);
    800007de:	8526                	mv	a0,s1
    800007e0:	83dff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    800007e4:	865e                	mv	a2,s7
    800007e6:	85ca                	mv	a1,s2
    800007e8:	8556                	mv	a0,s5
    800007ea:	f31ff0ef          	jal	8000071a <uvmdealloc>
      return 0;
    800007ee:	4501                	li	a0,0
    800007f0:	74e2                	ld	s1,56(sp)
    800007f2:	79a2                	ld	s3,40(sp)
    800007f4:	6b42                	ld	s6,16(sp)
    800007f6:	bfe1                	j	800007ce <uvmalloc+0x70>
    return oldsz;
    800007f8:	852e                	mv	a0,a1
}
    800007fa:	8082                	ret
  return newsz;
    800007fc:	8532                	mv	a0,a2
    800007fe:	bfc1                	j	800007ce <uvmalloc+0x70>

0000000080000800 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000800:	7179                	addi	sp,sp,-48
    80000802:	f406                	sd	ra,40(sp)
    80000804:	f022                	sd	s0,32(sp)
    80000806:	ec26                	sd	s1,24(sp)
    80000808:	e84a                	sd	s2,16(sp)
    8000080a:	e44e                	sd	s3,8(sp)
    8000080c:	1800                	addi	s0,sp,48
    8000080e:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000810:	84aa                	mv	s1,a0
    80000812:	6905                	lui	s2,0x1
    80000814:	992a                	add	s2,s2,a0
    80000816:	a811                	j	8000082a <freewalk+0x2a>
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      // backtrace();
      panic("freewalk: leaf");
    80000818:	00007517          	auipc	a0,0x7
    8000081c:	8d850513          	addi	a0,a0,-1832 # 800070f0 <etext+0xf0>
    80000820:	717040ef          	jal	80005736 <panic>
  for(int i = 0; i < 512; i++){
    80000824:	04a1                	addi	s1,s1,8
    80000826:	03248163          	beq	s1,s2,80000848 <freewalk+0x48>
    pte_t pte = pagetable[i];
    8000082a:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000082c:	0017f713          	andi	a4,a5,1
    80000830:	db75                	beqz	a4,80000824 <freewalk+0x24>
    80000832:	00e7f713          	andi	a4,a5,14
    80000836:	f36d                	bnez	a4,80000818 <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80000838:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000083a:	00c79513          	slli	a0,a5,0xc
    8000083e:	fc3ff0ef          	jal	80000800 <freewalk>
      pagetable[i] = 0;
    80000842:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000846:	bff9                	j	80000824 <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    80000848:	854e                	mv	a0,s3
    8000084a:	fd2ff0ef          	jal	8000001c <kfree>
}
    8000084e:	70a2                	ld	ra,40(sp)
    80000850:	7402                	ld	s0,32(sp)
    80000852:	64e2                	ld	s1,24(sp)
    80000854:	6942                	ld	s2,16(sp)
    80000856:	69a2                	ld	s3,8(sp)
    80000858:	6145                	addi	sp,sp,48
    8000085a:	8082                	ret

000000008000085c <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    8000085c:	1101                	addi	sp,sp,-32
    8000085e:	ec06                	sd	ra,24(sp)
    80000860:	e822                	sd	s0,16(sp)
    80000862:	e426                	sd	s1,8(sp)
    80000864:	1000                	addi	s0,sp,32
    80000866:	84aa                	mv	s1,a0
  if(sz > 0)
    80000868:	e989                	bnez	a1,8000087a <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    8000086a:	8526                	mv	a0,s1
    8000086c:	f95ff0ef          	jal	80000800 <freewalk>
}
    80000870:	60e2                	ld	ra,24(sp)
    80000872:	6442                	ld	s0,16(sp)
    80000874:	64a2                	ld	s1,8(sp)
    80000876:	6105                	addi	sp,sp,32
    80000878:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    8000087a:	6785                	lui	a5,0x1
    8000087c:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000087e:	95be                	add	a1,a1,a5
    80000880:	4685                	li	a3,1
    80000882:	00c5d613          	srli	a2,a1,0xc
    80000886:	4581                	li	a1,0
    80000888:	dedff0ef          	jal	80000674 <uvmunmap>
    8000088c:	bff9                	j	8000086a <uvmfree+0xe>

000000008000088e <uvmcopy>:
  uint64 pa, i;
  uint flags;
  char *mem;
  int szinc = PGSIZE;

  for(i = 0; i < sz; i += szinc){
    8000088e:	ca59                	beqz	a2,80000924 <uvmcopy+0x96>
{
    80000890:	715d                	addi	sp,sp,-80
    80000892:	e486                	sd	ra,72(sp)
    80000894:	e0a2                	sd	s0,64(sp)
    80000896:	fc26                	sd	s1,56(sp)
    80000898:	f84a                	sd	s2,48(sp)
    8000089a:	f44e                	sd	s3,40(sp)
    8000089c:	f052                	sd	s4,32(sp)
    8000089e:	ec56                	sd	s5,24(sp)
    800008a0:	e85a                	sd	s6,16(sp)
    800008a2:	e45e                	sd	s7,8(sp)
    800008a4:	0880                	addi	s0,sp,80
    800008a6:	8b2a                	mv	s6,a0
    800008a8:	8bae                	mv	s7,a1
    800008aa:	8ab2                	mv	s5,a2
  for(i = 0; i < sz; i += szinc){
    800008ac:	4481                	li	s1,0
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if((mem = kalloc()) == 0)
      goto err;
    memmove(mem, (char*)pa, PGSIZE);
    800008ae:	6a05                	lui	s4,0x1
    800008b0:	a021                	j	800008b8 <uvmcopy+0x2a>
  for(i = 0; i < sz; i += szinc){
    800008b2:	94d2                	add	s1,s1,s4
    800008b4:	0554fc63          	bgeu	s1,s5,8000090c <uvmcopy+0x7e>
    if((pte = walk(old, i, 0)) == 0)
    800008b8:	4601                	li	a2,0
    800008ba:	85a6                	mv	a1,s1
    800008bc:	855a                	mv	a0,s6
    800008be:	b15ff0ef          	jal	800003d2 <walk>
    800008c2:	d965                	beqz	a0,800008b2 <uvmcopy+0x24>
    if((*pte & PTE_V) == 0) {
    800008c4:	00053983          	ld	s3,0(a0)
    800008c8:	0019f793          	andi	a5,s3,1
    800008cc:	d3fd                	beqz	a5,800008b2 <uvmcopy+0x24>
    if((mem = kalloc()) == 0)
    800008ce:	82fff0ef          	jal	800000fc <kalloc>
    800008d2:	892a                	mv	s2,a0
    800008d4:	c11d                	beqz	a0,800008fa <uvmcopy+0x6c>
    pa = PTE2PA(*pte);
    800008d6:	00a9d593          	srli	a1,s3,0xa
    memmove(mem, (char*)pa, PGSIZE);
    800008da:	8652                	mv	a2,s4
    800008dc:	05b2                	slli	a1,a1,0xc
    800008de:	8c1ff0ef          	jal	8000019e <memmove>
    if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    800008e2:	3ff9f713          	andi	a4,s3,1023
    800008e6:	86ca                	mv	a3,s2
    800008e8:	8652                	mv	a2,s4
    800008ea:	85a6                	mv	a1,s1
    800008ec:	855e                	mv	a0,s7
    800008ee:	bb9ff0ef          	jal	800004a6 <mappages>
    800008f2:	d161                	beqz	a0,800008b2 <uvmcopy+0x24>
      kfree(mem);
    800008f4:	854a                	mv	a0,s2
    800008f6:	f26ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    800008fa:	4685                	li	a3,1
    800008fc:	00c4d613          	srli	a2,s1,0xc
    80000900:	4581                	li	a1,0
    80000902:	855e                	mv	a0,s7
    80000904:	d71ff0ef          	jal	80000674 <uvmunmap>
  return -1;
    80000908:	557d                	li	a0,-1
    8000090a:	a011                	j	8000090e <uvmcopy+0x80>
  return 0;
    8000090c:	4501                	li	a0,0
}
    8000090e:	60a6                	ld	ra,72(sp)
    80000910:	6406                	ld	s0,64(sp)
    80000912:	74e2                	ld	s1,56(sp)
    80000914:	7942                	ld	s2,48(sp)
    80000916:	79a2                	ld	s3,40(sp)
    80000918:	7a02                	ld	s4,32(sp)
    8000091a:	6ae2                	ld	s5,24(sp)
    8000091c:	6b42                	ld	s6,16(sp)
    8000091e:	6ba2                	ld	s7,8(sp)
    80000920:	6161                	addi	sp,sp,80
    80000922:	8082                	ret
  return 0;
    80000924:	4501                	li	a0,0
}
    80000926:	8082                	ret

0000000080000928 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000928:	1141                	addi	sp,sp,-16
    8000092a:	e406                	sd	ra,8(sp)
    8000092c:	e022                	sd	s0,0(sp)
    8000092e:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000930:	4601                	li	a2,0
    80000932:	aa1ff0ef          	jal	800003d2 <walk>
  if(pte == 0)
    80000936:	c901                	beqz	a0,80000946 <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000938:	611c                	ld	a5,0(a0)
    8000093a:	9bbd                	andi	a5,a5,-17
    8000093c:	e11c                	sd	a5,0(a0)
}
    8000093e:	60a2                	ld	ra,8(sp)
    80000940:	6402                	ld	s0,0(sp)
    80000942:	0141                	addi	sp,sp,16
    80000944:	8082                	ret
    panic("uvmclear");
    80000946:	00006517          	auipc	a0,0x6
    8000094a:	7ba50513          	addi	a0,a0,1978 # 80007100 <etext+0x100>
    8000094e:	5e9040ef          	jal	80005736 <panic>

0000000080000952 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000952:	cac5                	beqz	a3,80000a02 <copyinstr+0xb0>
{
    80000954:	715d                	addi	sp,sp,-80
    80000956:	e486                	sd	ra,72(sp)
    80000958:	e0a2                	sd	s0,64(sp)
    8000095a:	fc26                	sd	s1,56(sp)
    8000095c:	f84a                	sd	s2,48(sp)
    8000095e:	f44e                	sd	s3,40(sp)
    80000960:	f052                	sd	s4,32(sp)
    80000962:	ec56                	sd	s5,24(sp)
    80000964:	e85a                	sd	s6,16(sp)
    80000966:	e45e                	sd	s7,8(sp)
    80000968:	0880                	addi	s0,sp,80
    8000096a:	8aaa                	mv	s5,a0
    8000096c:	84ae                	mv	s1,a1
    8000096e:	8bb2                	mv	s7,a2
    80000970:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000972:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000974:	6a05                	lui	s4,0x1
    80000976:	a82d                	j	800009b0 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000978:	00078023          	sb	zero,0(a5)
        got_null = 1;
    8000097c:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    8000097e:	0017c793          	xori	a5,a5,1
    80000982:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000986:	60a6                	ld	ra,72(sp)
    80000988:	6406                	ld	s0,64(sp)
    8000098a:	74e2                	ld	s1,56(sp)
    8000098c:	7942                	ld	s2,48(sp)
    8000098e:	79a2                	ld	s3,40(sp)
    80000990:	7a02                	ld	s4,32(sp)
    80000992:	6ae2                	ld	s5,24(sp)
    80000994:	6b42                	ld	s6,16(sp)
    80000996:	6ba2                	ld	s7,8(sp)
    80000998:	6161                	addi	sp,sp,80
    8000099a:	8082                	ret
    8000099c:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    800009a0:	9726                	add	a4,a4,s1
      --max;
    800009a2:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    800009a6:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    800009aa:	04e58463          	beq	a1,a4,800009f2 <copyinstr+0xa0>
{
    800009ae:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    800009b0:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    800009b4:	85ca                	mv	a1,s2
    800009b6:	8556                	mv	a0,s5
    800009b8:	ab5ff0ef          	jal	8000046c <walkaddr>
    if(pa0 == 0)
    800009bc:	cd0d                	beqz	a0,800009f6 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    800009be:	417906b3          	sub	a3,s2,s7
    800009c2:	96d2                	add	a3,a3,s4
    if(n > max)
    800009c4:	00d9f363          	bgeu	s3,a3,800009ca <copyinstr+0x78>
    800009c8:	86ce                	mv	a3,s3
    while(n > 0){
    800009ca:	ca85                	beqz	a3,800009fa <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    800009cc:	01750633          	add	a2,a0,s7
    800009d0:	41260633          	sub	a2,a2,s2
    800009d4:	87a6                	mv	a5,s1
      if(*p == '\0'){
    800009d6:	8e05                	sub	a2,a2,s1
    while(n > 0){
    800009d8:	96a6                	add	a3,a3,s1
    800009da:	85be                	mv	a1,a5
      if(*p == '\0'){
    800009dc:	00f60733          	add	a4,a2,a5
    800009e0:	00074703          	lbu	a4,0(a4)
    800009e4:	db51                	beqz	a4,80000978 <copyinstr+0x26>
        *dst = *p;
    800009e6:	00e78023          	sb	a4,0(a5)
      dst++;
    800009ea:	0785                	addi	a5,a5,1
    while(n > 0){
    800009ec:	fed797e3          	bne	a5,a3,800009da <copyinstr+0x88>
    800009f0:	b775                	j	8000099c <copyinstr+0x4a>
    800009f2:	4781                	li	a5,0
    800009f4:	b769                	j	8000097e <copyinstr+0x2c>
      return -1;
    800009f6:	557d                	li	a0,-1
    800009f8:	b779                	j	80000986 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    800009fa:	6b85                	lui	s7,0x1
    800009fc:	9bca                	add	s7,s7,s2
    800009fe:	87a6                	mv	a5,s1
    80000a00:	b77d                	j	800009ae <copyinstr+0x5c>
  int got_null = 0;
    80000a02:	4781                	li	a5,0
  if(got_null){
    80000a04:	0017c793          	xori	a5,a5,1
    80000a08:	40f0053b          	negw	a0,a5
}
    80000a0c:	8082                	ret

0000000080000a0e <ismapped>:
  }
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va) {
    80000a0e:	1141                	addi	sp,sp,-16
    80000a10:	e406                	sd	ra,8(sp)
    80000a12:	e022                	sd	s0,0(sp)
    80000a14:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000a16:	4601                	li	a2,0
    80000a18:	9bbff0ef          	jal	800003d2 <walk>
  if (pte == 0) {
    80000a1c:	c119                	beqz	a0,80000a22 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    80000a1e:	6108                	ld	a0,0(a0)
    80000a20:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000a22:	60a2                	ld	ra,8(sp)
    80000a24:	6402                	ld	s0,0(sp)
    80000a26:	0141                	addi	sp,sp,16
    80000a28:	8082                	ret

0000000080000a2a <vmfault>:
{
    80000a2a:	7179                	addi	sp,sp,-48
    80000a2c:	f406                	sd	ra,40(sp)
    80000a2e:	f022                	sd	s0,32(sp)
    80000a30:	e84a                	sd	s2,16(sp)
    80000a32:	e44e                	sd	s3,8(sp)
    80000a34:	1800                	addi	s0,sp,48
    80000a36:	89aa                	mv	s3,a0
    80000a38:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80000a3a:	344000ef          	jal	80000d7e <myproc>
  if (va >= p->sz)
    80000a3e:	653c                	ld	a5,72(a0)
    80000a40:	00f96a63          	bltu	s2,a5,80000a54 <vmfault+0x2a>
    return 0;
    80000a44:	4981                	li	s3,0
}
    80000a46:	854e                	mv	a0,s3
    80000a48:	70a2                	ld	ra,40(sp)
    80000a4a:	7402                	ld	s0,32(sp)
    80000a4c:	6942                	ld	s2,16(sp)
    80000a4e:	69a2                	ld	s3,8(sp)
    80000a50:	6145                	addi	sp,sp,48
    80000a52:	8082                	ret
    80000a54:	ec26                	sd	s1,24(sp)
    80000a56:	e052                	sd	s4,0(sp)
    80000a58:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80000a5a:	77fd                	lui	a5,0xfffff
    80000a5c:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80000a60:	85d2                	mv	a1,s4
    80000a62:	854e                	mv	a0,s3
    80000a64:	fabff0ef          	jal	80000a0e <ismapped>
    return 0;
    80000a68:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    80000a6a:	c501                	beqz	a0,80000a72 <vmfault+0x48>
    80000a6c:	64e2                	ld	s1,24(sp)
    80000a6e:	6a02                	ld	s4,0(sp)
    80000a70:	bfd9                	j	80000a46 <vmfault+0x1c>
  mem = (uint64) kalloc();
    80000a72:	e8aff0ef          	jal	800000fc <kalloc>
    80000a76:	892a                	mv	s2,a0
  if(mem == 0)
    80000a78:	c905                	beqz	a0,80000aa8 <vmfault+0x7e>
  mem = (uint64) kalloc();
    80000a7a:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    80000a7c:	6605                	lui	a2,0x1
    80000a7e:	4581                	li	a1,0
    80000a80:	ebeff0ef          	jal	8000013e <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000a84:	4759                	li	a4,22
    80000a86:	86ca                	mv	a3,s2
    80000a88:	6605                	lui	a2,0x1
    80000a8a:	85d2                	mv	a1,s4
    80000a8c:	68a8                	ld	a0,80(s1)
    80000a8e:	a19ff0ef          	jal	800004a6 <mappages>
    80000a92:	e501                	bnez	a0,80000a9a <vmfault+0x70>
    80000a94:	64e2                	ld	s1,24(sp)
    80000a96:	6a02                	ld	s4,0(sp)
    80000a98:	b77d                	j	80000a46 <vmfault+0x1c>
    kfree((void *)mem);
    80000a9a:	854a                	mv	a0,s2
    80000a9c:	d80ff0ef          	jal	8000001c <kfree>
    return 0;
    80000aa0:	4981                	li	s3,0
    80000aa2:	64e2                	ld	s1,24(sp)
    80000aa4:	6a02                	ld	s4,0(sp)
    80000aa6:	b745                	j	80000a46 <vmfault+0x1c>
    80000aa8:	64e2                	ld	s1,24(sp)
    80000aaa:	6a02                	ld	s4,0(sp)
    80000aac:	bf69                	j	80000a46 <vmfault+0x1c>

0000000080000aae <copyout>:
  while(len > 0){
    80000aae:	cad9                	beqz	a3,80000b44 <copyout+0x96>
{
    80000ab0:	711d                	addi	sp,sp,-96
    80000ab2:	ec86                	sd	ra,88(sp)
    80000ab4:	e8a2                	sd	s0,80(sp)
    80000ab6:	e4a6                	sd	s1,72(sp)
    80000ab8:	e0ca                	sd	s2,64(sp)
    80000aba:	fc4e                	sd	s3,56(sp)
    80000abc:	f852                	sd	s4,48(sp)
    80000abe:	f456                	sd	s5,40(sp)
    80000ac0:	f05a                	sd	s6,32(sp)
    80000ac2:	ec5e                	sd	s7,24(sp)
    80000ac4:	e862                	sd	s8,16(sp)
    80000ac6:	e466                	sd	s9,8(sp)
    80000ac8:	e06a                	sd	s10,0(sp)
    80000aca:	1080                	addi	s0,sp,96
    80000acc:	8baa                	mv	s7,a0
    80000ace:	8a2e                	mv	s4,a1
    80000ad0:	8b32                	mv	s6,a2
    80000ad2:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000ad4:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    80000ad6:	5cfd                	li	s9,-1
    80000ad8:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000adc:	6c05                	lui	s8,0x1
    80000ade:	a005                	j	80000afe <copyout+0x50>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000ae0:	409a0533          	sub	a0,s4,s1
    80000ae4:	0009061b          	sext.w	a2,s2
    80000ae8:	85da                	mv	a1,s6
    80000aea:	954e                	add	a0,a0,s3
    80000aec:	eb2ff0ef          	jal	8000019e <memmove>
    len -= n;
    80000af0:	412a8ab3          	sub	s5,s5,s2
    src += n;
    80000af4:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    80000af6:	01848a33          	add	s4,s1,s8
  while(len > 0){
    80000afa:	040a8363          	beqz	s5,80000b40 <copyout+0x92>
    va0 = PGROUNDDOWN(dstva);
    80000afe:	01aa74b3          	and	s1,s4,s10
    if (va0 >= MAXVA)
    80000b02:	049ce363          	bltu	s9,s1,80000b48 <copyout+0x9a>
    pa0 = walkaddr(pagetable, va0);
    80000b06:	85a6                	mv	a1,s1
    80000b08:	855e                	mv	a0,s7
    80000b0a:	963ff0ef          	jal	8000046c <walkaddr>
    80000b0e:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    80000b10:	e901                	bnez	a0,80000b20 <copyout+0x72>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000b12:	4601                	li	a2,0
    80000b14:	85a6                	mv	a1,s1
    80000b16:	855e                	mv	a0,s7
    80000b18:	f13ff0ef          	jal	80000a2a <vmfault>
    80000b1c:	89aa                	mv	s3,a0
    80000b1e:	c521                	beqz	a0,80000b66 <copyout+0xb8>
    if((pte = walk(pagetable, va0, 0)) == 0) {
    80000b20:	4601                	li	a2,0
    80000b22:	85a6                	mv	a1,s1
    80000b24:	855e                	mv	a0,s7
    80000b26:	8adff0ef          	jal	800003d2 <walk>
    80000b2a:	c121                	beqz	a0,80000b6a <copyout+0xbc>
    if((*pte & PTE_W) == 0)
    80000b2c:	611c                	ld	a5,0(a0)
    80000b2e:	8b91                	andi	a5,a5,4
    80000b30:	cf9d                	beqz	a5,80000b6e <copyout+0xc0>
    n = PGSIZE - (dstva - va0);
    80000b32:	41448933          	sub	s2,s1,s4
    80000b36:	9962                	add	s2,s2,s8
    if(n > len)
    80000b38:	fb2af4e3          	bgeu	s5,s2,80000ae0 <copyout+0x32>
    80000b3c:	8956                	mv	s2,s5
    80000b3e:	b74d                	j	80000ae0 <copyout+0x32>
  return 0;
    80000b40:	4501                	li	a0,0
    80000b42:	a021                	j	80000b4a <copyout+0x9c>
    80000b44:	4501                	li	a0,0
}
    80000b46:	8082                	ret
      return -1;
    80000b48:	557d                	li	a0,-1
}
    80000b4a:	60e6                	ld	ra,88(sp)
    80000b4c:	6446                	ld	s0,80(sp)
    80000b4e:	64a6                	ld	s1,72(sp)
    80000b50:	6906                	ld	s2,64(sp)
    80000b52:	79e2                	ld	s3,56(sp)
    80000b54:	7a42                	ld	s4,48(sp)
    80000b56:	7aa2                	ld	s5,40(sp)
    80000b58:	7b02                	ld	s6,32(sp)
    80000b5a:	6be2                	ld	s7,24(sp)
    80000b5c:	6c42                	ld	s8,16(sp)
    80000b5e:	6ca2                	ld	s9,8(sp)
    80000b60:	6d02                	ld	s10,0(sp)
    80000b62:	6125                	addi	sp,sp,96
    80000b64:	8082                	ret
        return -1;
    80000b66:	557d                	li	a0,-1
    80000b68:	b7cd                	j	80000b4a <copyout+0x9c>
      return -1;
    80000b6a:	557d                	li	a0,-1
    80000b6c:	bff9                	j	80000b4a <copyout+0x9c>
      return -1;
    80000b6e:	557d                	li	a0,-1
    80000b70:	bfe9                	j	80000b4a <copyout+0x9c>

0000000080000b72 <copyin>:
  while(len > 0){
    80000b72:	c6c9                	beqz	a3,80000bfc <copyin+0x8a>
{
    80000b74:	715d                	addi	sp,sp,-80
    80000b76:	e486                	sd	ra,72(sp)
    80000b78:	e0a2                	sd	s0,64(sp)
    80000b7a:	fc26                	sd	s1,56(sp)
    80000b7c:	f84a                	sd	s2,48(sp)
    80000b7e:	f44e                	sd	s3,40(sp)
    80000b80:	f052                	sd	s4,32(sp)
    80000b82:	ec56                	sd	s5,24(sp)
    80000b84:	e85a                	sd	s6,16(sp)
    80000b86:	e45e                	sd	s7,8(sp)
    80000b88:	e062                	sd	s8,0(sp)
    80000b8a:	0880                	addi	s0,sp,80
    80000b8c:	8baa                	mv	s7,a0
    80000b8e:	8aae                	mv	s5,a1
    80000b90:	8932                	mv	s2,a2
    80000b92:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000b94:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000b96:	6b05                	lui	s6,0x1
    80000b98:	a035                	j	80000bc4 <copyin+0x52>
    80000b9a:	412984b3          	sub	s1,s3,s2
    80000b9e:	94da                	add	s1,s1,s6
    if(n > len)
    80000ba0:	009a7363          	bgeu	s4,s1,80000ba6 <copyin+0x34>
    80000ba4:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000ba6:	413905b3          	sub	a1,s2,s3
    80000baa:	0004861b          	sext.w	a2,s1
    80000bae:	95aa                	add	a1,a1,a0
    80000bb0:	8556                	mv	a0,s5
    80000bb2:	decff0ef          	jal	8000019e <memmove>
    len -= n;
    80000bb6:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000bba:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000bbc:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000bc0:	020a0163          	beqz	s4,80000be2 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000bc4:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000bc8:	85ce                	mv	a1,s3
    80000bca:	855e                	mv	a0,s7
    80000bcc:	8a1ff0ef          	jal	8000046c <walkaddr>
    if(pa0 == 0) {
    80000bd0:	f569                	bnez	a0,80000b9a <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000bd2:	4601                	li	a2,0
    80000bd4:	85ce                	mv	a1,s3
    80000bd6:	855e                	mv	a0,s7
    80000bd8:	e53ff0ef          	jal	80000a2a <vmfault>
    80000bdc:	fd5d                	bnez	a0,80000b9a <copyin+0x28>
        return -1;
    80000bde:	557d                	li	a0,-1
    80000be0:	a011                	j	80000be4 <copyin+0x72>
  return 0;
    80000be2:	4501                	li	a0,0
}
    80000be4:	60a6                	ld	ra,72(sp)
    80000be6:	6406                	ld	s0,64(sp)
    80000be8:	74e2                	ld	s1,56(sp)
    80000bea:	7942                	ld	s2,48(sp)
    80000bec:	79a2                	ld	s3,40(sp)
    80000bee:	7a02                	ld	s4,32(sp)
    80000bf0:	6ae2                	ld	s5,24(sp)
    80000bf2:	6b42                	ld	s6,16(sp)
    80000bf4:	6ba2                	ld	s7,8(sp)
    80000bf6:	6c02                	ld	s8,0(sp)
    80000bf8:	6161                	addi	sp,sp,80
    80000bfa:	8082                	ret
  return 0;
    80000bfc:	4501                	li	a0,0
}
    80000bfe:	8082                	ret

0000000080000c00 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000c00:	715d                	addi	sp,sp,-80
    80000c02:	e486                	sd	ra,72(sp)
    80000c04:	e0a2                	sd	s0,64(sp)
    80000c06:	fc26                	sd	s1,56(sp)
    80000c08:	f84a                	sd	s2,48(sp)
    80000c0a:	f44e                	sd	s3,40(sp)
    80000c0c:	f052                	sd	s4,32(sp)
    80000c0e:	ec56                	sd	s5,24(sp)
    80000c10:	e85a                	sd	s6,16(sp)
    80000c12:	e45e                	sd	s7,8(sp)
    80000c14:	e062                	sd	s8,0(sp)
    80000c16:	0880                	addi	s0,sp,80
    80000c18:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c1a:	00007497          	auipc	s1,0x7
    80000c1e:	0b648493          	addi	s1,s1,182 # 80007cd0 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000c22:	8c26                	mv	s8,s1
    80000c24:	421087b7          	lui	a5,0x42108
    80000c28:	42078793          	addi	a5,a5,1056 # 42108420 <_entry-0x3def7be0>
    80000c2c:	01e79993          	slli	s3,a5,0x1e
    80000c30:	99be                	add	s3,s3,a5
    80000c32:	fff9c993          	not	s3,s3
    80000c36:	04000937          	lui	s2,0x4000
    80000c3a:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000c3c:	0932                	slli	s2,s2,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c3e:	4b99                	li	s7,6
    80000c40:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c42:	0000fa97          	auipc	s5,0xf
    80000c46:	c8ea8a93          	addi	s5,s5,-882 # 8000f8d0 <tickslock>
    char *pa = kalloc();
    80000c4a:	cb2ff0ef          	jal	800000fc <kalloc>
    80000c4e:	862a                	mv	a2,a0
    if(pa == 0)
    80000c50:	c121                	beqz	a0,80000c90 <proc_mapstacks+0x90>
    uint64 va = KSTACK((int) (p - proc));
    80000c52:	418485b3          	sub	a1,s1,s8
    80000c56:	8591                	srai	a1,a1,0x4
    80000c58:	033585b3          	mul	a1,a1,s3
    80000c5c:	05b6                	slli	a1,a1,0xd
    80000c5e:	6789                	lui	a5,0x2
    80000c60:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000c62:	875e                	mv	a4,s7
    80000c64:	86da                	mv	a3,s6
    80000c66:	40b905b3          	sub	a1,s2,a1
    80000c6a:	8552                	mv	a0,s4
    80000c6c:	8f1ff0ef          	jal	8000055c <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000c70:	1f048493          	addi	s1,s1,496
    80000c74:	fd549be3          	bne	s1,s5,80000c4a <proc_mapstacks+0x4a>
  }
}
    80000c78:	60a6                	ld	ra,72(sp)
    80000c7a:	6406                	ld	s0,64(sp)
    80000c7c:	74e2                	ld	s1,56(sp)
    80000c7e:	7942                	ld	s2,48(sp)
    80000c80:	79a2                	ld	s3,40(sp)
    80000c82:	7a02                	ld	s4,32(sp)
    80000c84:	6ae2                	ld	s5,24(sp)
    80000c86:	6b42                	ld	s6,16(sp)
    80000c88:	6ba2                	ld	s7,8(sp)
    80000c8a:	6c02                	ld	s8,0(sp)
    80000c8c:	6161                	addi	sp,sp,80
    80000c8e:	8082                	ret
      panic("kalloc");
    80000c90:	00006517          	auipc	a0,0x6
    80000c94:	48050513          	addi	a0,a0,1152 # 80007110 <etext+0x110>
    80000c98:	29f040ef          	jal	80005736 <panic>

0000000080000c9c <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000c9c:	7139                	addi	sp,sp,-64
    80000c9e:	fc06                	sd	ra,56(sp)
    80000ca0:	f822                	sd	s0,48(sp)
    80000ca2:	f426                	sd	s1,40(sp)
    80000ca4:	f04a                	sd	s2,32(sp)
    80000ca6:	ec4e                	sd	s3,24(sp)
    80000ca8:	e852                	sd	s4,16(sp)
    80000caa:	e456                	sd	s5,8(sp)
    80000cac:	e05a                	sd	s6,0(sp)
    80000cae:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000cb0:	00006597          	auipc	a1,0x6
    80000cb4:	46858593          	addi	a1,a1,1128 # 80007118 <etext+0x118>
    80000cb8:	00007517          	auipc	a0,0x7
    80000cbc:	be850513          	addi	a0,a0,-1048 # 800078a0 <pid_lock>
    80000cc0:	4af040ef          	jal	8000596e <initlock>
  initlock(&wait_lock, "wait_lock");
    80000cc4:	00006597          	auipc	a1,0x6
    80000cc8:	45c58593          	addi	a1,a1,1116 # 80007120 <etext+0x120>
    80000ccc:	00007517          	auipc	a0,0x7
    80000cd0:	bec50513          	addi	a0,a0,-1044 # 800078b8 <wait_lock>
    80000cd4:	49b040ef          	jal	8000596e <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000cd8:	00007497          	auipc	s1,0x7
    80000cdc:	ff848493          	addi	s1,s1,-8 # 80007cd0 <proc>
      initlock(&p->lock, "proc");
    80000ce0:	00006b17          	auipc	s6,0x6
    80000ce4:	450b0b13          	addi	s6,s6,1104 # 80007130 <etext+0x130>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000ce8:	8aa6                	mv	s5,s1
    80000cea:	421087b7          	lui	a5,0x42108
    80000cee:	42078793          	addi	a5,a5,1056 # 42108420 <_entry-0x3def7be0>
    80000cf2:	01e79993          	slli	s3,a5,0x1e
    80000cf6:	99be                	add	s3,s3,a5
    80000cf8:	fff9c993          	not	s3,s3
    80000cfc:	04000937          	lui	s2,0x4000
    80000d00:	197d                	addi	s2,s2,-1 # 3ffffff <_entry-0x7c000001>
    80000d02:	0932                	slli	s2,s2,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d04:	0000fa17          	auipc	s4,0xf
    80000d08:	bcca0a13          	addi	s4,s4,-1076 # 8000f8d0 <tickslock>
      initlock(&p->lock, "proc");
    80000d0c:	85da                	mv	a1,s6
    80000d0e:	8526                	mv	a0,s1
    80000d10:	45f040ef          	jal	8000596e <initlock>
      p->state = UNUSED;
    80000d14:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000d18:	415487b3          	sub	a5,s1,s5
    80000d1c:	8791                	srai	a5,a5,0x4
    80000d1e:	033787b3          	mul	a5,a5,s3
    80000d22:	07b6                	slli	a5,a5,0xd
    80000d24:	6709                	lui	a4,0x2
    80000d26:	9fb9                	addw	a5,a5,a4
    80000d28:	40f907b3          	sub	a5,s2,a5
    80000d2c:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000d2e:	1f048493          	addi	s1,s1,496
    80000d32:	fd449de3          	bne	s1,s4,80000d0c <procinit+0x70>
  }
}
    80000d36:	70e2                	ld	ra,56(sp)
    80000d38:	7442                	ld	s0,48(sp)
    80000d3a:	74a2                	ld	s1,40(sp)
    80000d3c:	7902                	ld	s2,32(sp)
    80000d3e:	69e2                	ld	s3,24(sp)
    80000d40:	6a42                	ld	s4,16(sp)
    80000d42:	6aa2                	ld	s5,8(sp)
    80000d44:	6b02                	ld	s6,0(sp)
    80000d46:	6121                	addi	sp,sp,64
    80000d48:	8082                	ret

0000000080000d4a <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000d4a:	1141                	addi	sp,sp,-16
    80000d4c:	e406                	sd	ra,8(sp)
    80000d4e:	e022                	sd	s0,0(sp)
    80000d50:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000d52:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80000d54:	2501                	sext.w	a0,a0
    80000d56:	60a2                	ld	ra,8(sp)
    80000d58:	6402                	ld	s0,0(sp)
    80000d5a:	0141                	addi	sp,sp,16
    80000d5c:	8082                	ret

0000000080000d5e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80000d5e:	1141                	addi	sp,sp,-16
    80000d60:	e406                	sd	ra,8(sp)
    80000d62:	e022                	sd	s0,0(sp)
    80000d64:	0800                	addi	s0,sp,16
    80000d66:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80000d68:	2781                	sext.w	a5,a5
    80000d6a:	079e                	slli	a5,a5,0x7
  return c;
}
    80000d6c:	00007517          	auipc	a0,0x7
    80000d70:	b6450513          	addi	a0,a0,-1180 # 800078d0 <cpus>
    80000d74:	953e                	add	a0,a0,a5
    80000d76:	60a2                	ld	ra,8(sp)
    80000d78:	6402                	ld	s0,0(sp)
    80000d7a:	0141                	addi	sp,sp,16
    80000d7c:	8082                	ret

0000000080000d7e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80000d7e:	1101                	addi	sp,sp,-32
    80000d80:	ec06                	sd	ra,24(sp)
    80000d82:	e822                	sd	s0,16(sp)
    80000d84:	e426                	sd	s1,8(sp)
    80000d86:	1000                	addi	s0,sp,32
  push_off();
    80000d88:	42d040ef          	jal	800059b4 <push_off>
    80000d8c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80000d8e:	2781                	sext.w	a5,a5
    80000d90:	079e                	slli	a5,a5,0x7
    80000d92:	00007717          	auipc	a4,0x7
    80000d96:	b0e70713          	addi	a4,a4,-1266 # 800078a0 <pid_lock>
    80000d9a:	97ba                	add	a5,a5,a4
    80000d9c:	7b9c                	ld	a5,48(a5)
    80000d9e:	84be                	mv	s1,a5
  pop_off();
    80000da0:	49d040ef          	jal	80005a3c <pop_off>
  return p;
}
    80000da4:	8526                	mv	a0,s1
    80000da6:	60e2                	ld	ra,24(sp)
    80000da8:	6442                	ld	s0,16(sp)
    80000daa:	64a2                	ld	s1,8(sp)
    80000dac:	6105                	addi	sp,sp,32
    80000dae:	8082                	ret

0000000080000db0 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80000db0:	7179                	addi	sp,sp,-48
    80000db2:	f406                	sd	ra,40(sp)
    80000db4:	f022                	sd	s0,32(sp)
    80000db6:	ec26                	sd	s1,24(sp)
    80000db8:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    80000dba:	fc5ff0ef          	jal	80000d7e <myproc>
    80000dbe:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80000dc0:	4cd040ef          	jal	80005a8c <release>

  if (first) {
    80000dc4:	00007797          	auipc	a5,0x7
    80000dc8:	a7c7a783          	lw	a5,-1412(a5) # 80007840 <first.1>
    80000dcc:	cf95                	beqz	a5,80000e08 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80000dce:	4505                	li	a0,1
    80000dd0:	47d010ef          	jal	80002a4c <fsinit>

    first = 0;
    80000dd4:	00007797          	auipc	a5,0x7
    80000dd8:	a607a623          	sw	zero,-1428(a5) # 80007840 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    80000ddc:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80000de0:	00006797          	auipc	a5,0x6
    80000de4:	35878793          	addi	a5,a5,856 # 80007138 <etext+0x138>
    80000de8:	fcf43823          	sd	a5,-48(s0)
    80000dec:	fc043c23          	sd	zero,-40(s0)
    80000df0:	fd040593          	addi	a1,s0,-48
    80000df4:	853e                	mv	a0,a5
    80000df6:	5d5020ef          	jal	80003bca <kexec>
    80000dfa:	6cbc                	ld	a5,88(s1)
    80000dfc:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    80000dfe:	6cbc                	ld	a5,88(s1)
    80000e00:	7bb8                	ld	a4,112(a5)
    80000e02:	57fd                	li	a5,-1
    80000e04:	02f70d63          	beq	a4,a5,80000e3e <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    80000e08:	2cf000ef          	jal	800018d6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80000e0c:	68a8                	ld	a0,80(s1)
    80000e0e:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80000e10:	04000737          	lui	a4,0x4000
    80000e14:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80000e16:	0732                	slli	a4,a4,0xc
    80000e18:	00005797          	auipc	a5,0x5
    80000e1c:	28478793          	addi	a5,a5,644 # 8000609c <userret>
    80000e20:	00005697          	auipc	a3,0x5
    80000e24:	1e068693          	addi	a3,a3,480 # 80006000 <_trampoline>
    80000e28:	8f95                	sub	a5,a5,a3
    80000e2a:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    80000e2c:	577d                	li	a4,-1
    80000e2e:	177e                	slli	a4,a4,0x3f
    80000e30:	8d59                	or	a0,a0,a4
    80000e32:	9782                	jalr	a5
}
    80000e34:	70a2                	ld	ra,40(sp)
    80000e36:	7402                	ld	s0,32(sp)
    80000e38:	64e2                	ld	s1,24(sp)
    80000e3a:	6145                	addi	sp,sp,48
    80000e3c:	8082                	ret
      panic("exec");
    80000e3e:	00006517          	auipc	a0,0x6
    80000e42:	30250513          	addi	a0,a0,770 # 80007140 <etext+0x140>
    80000e46:	0f1040ef          	jal	80005736 <panic>

0000000080000e4a <allocpid>:
{
    80000e4a:	1101                	addi	sp,sp,-32
    80000e4c:	ec06                	sd	ra,24(sp)
    80000e4e:	e822                	sd	s0,16(sp)
    80000e50:	e426                	sd	s1,8(sp)
    80000e52:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80000e54:	00007517          	auipc	a0,0x7
    80000e58:	a4c50513          	addi	a0,a0,-1460 # 800078a0 <pid_lock>
    80000e5c:	39d040ef          	jal	800059f8 <acquire>
  pid = nextpid;
    80000e60:	00007797          	auipc	a5,0x7
    80000e64:	9e478793          	addi	a5,a5,-1564 # 80007844 <nextpid>
    80000e68:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    80000e6a:	0014871b          	addiw	a4,s1,1
    80000e6e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80000e70:	00007517          	auipc	a0,0x7
    80000e74:	a3050513          	addi	a0,a0,-1488 # 800078a0 <pid_lock>
    80000e78:	415040ef          	jal	80005a8c <release>
}
    80000e7c:	8526                	mv	a0,s1
    80000e7e:	60e2                	ld	ra,24(sp)
    80000e80:	6442                	ld	s0,16(sp)
    80000e82:	64a2                	ld	s1,8(sp)
    80000e84:	6105                	addi	sp,sp,32
    80000e86:	8082                	ret

0000000080000e88 <proc_pagetable>:
{
    80000e88:	1101                	addi	sp,sp,-32
    80000e8a:	ec06                	sd	ra,24(sp)
    80000e8c:	e822                	sd	s0,16(sp)
    80000e8e:	e426                	sd	s1,8(sp)
    80000e90:	e04a                	sd	s2,0(sp)
    80000e92:	1000                	addi	s0,sp,32
    80000e94:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80000e96:	fb8ff0ef          	jal	8000064e <uvmcreate>
    80000e9a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    80000e9c:	cd05                	beqz	a0,80000ed4 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000e9e:	4729                	li	a4,10
    80000ea0:	00005697          	auipc	a3,0x5
    80000ea4:	16068693          	addi	a3,a3,352 # 80006000 <_trampoline>
    80000ea8:	6605                	lui	a2,0x1
    80000eaa:	040005b7          	lui	a1,0x4000
    80000eae:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000eb0:	05b2                	slli	a1,a1,0xc
    80000eb2:	df4ff0ef          	jal	800004a6 <mappages>
    80000eb6:	02054663          	bltz	a0,80000ee2 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    80000eba:	4719                	li	a4,6
    80000ebc:	05893683          	ld	a3,88(s2)
    80000ec0:	6605                	lui	a2,0x1
    80000ec2:	020005b7          	lui	a1,0x2000
    80000ec6:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000ec8:	05b6                	slli	a1,a1,0xd
    80000eca:	8526                	mv	a0,s1
    80000ecc:	ddaff0ef          	jal	800004a6 <mappages>
    80000ed0:	00054f63          	bltz	a0,80000eee <proc_pagetable+0x66>
}
    80000ed4:	8526                	mv	a0,s1
    80000ed6:	60e2                	ld	ra,24(sp)
    80000ed8:	6442                	ld	s0,16(sp)
    80000eda:	64a2                	ld	s1,8(sp)
    80000edc:	6902                	ld	s2,0(sp)
    80000ede:	6105                	addi	sp,sp,32
    80000ee0:	8082                	ret
    uvmfree(pagetable, 0);
    80000ee2:	4581                	li	a1,0
    80000ee4:	8526                	mv	a0,s1
    80000ee6:	977ff0ef          	jal	8000085c <uvmfree>
    return 0;
    80000eea:	4481                	li	s1,0
    80000eec:	b7e5                	j	80000ed4 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000eee:	4681                	li	a3,0
    80000ef0:	4605                	li	a2,1
    80000ef2:	040005b7          	lui	a1,0x4000
    80000ef6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000ef8:	05b2                	slli	a1,a1,0xc
    80000efa:	8526                	mv	a0,s1
    80000efc:	f78ff0ef          	jal	80000674 <uvmunmap>
    uvmfree(pagetable, 0);
    80000f00:	4581                	li	a1,0
    80000f02:	8526                	mv	a0,s1
    80000f04:	959ff0ef          	jal	8000085c <uvmfree>
    return 0;
    80000f08:	4481                	li	s1,0
    80000f0a:	b7e9                	j	80000ed4 <proc_pagetable+0x4c>

0000000080000f0c <proc_freepagetable>:
{
    80000f0c:	1101                	addi	sp,sp,-32
    80000f0e:	ec06                	sd	ra,24(sp)
    80000f10:	e822                	sd	s0,16(sp)
    80000f12:	e426                	sd	s1,8(sp)
    80000f14:	e04a                	sd	s2,0(sp)
    80000f16:	1000                	addi	s0,sp,32
    80000f18:	84aa                	mv	s1,a0
    80000f1a:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f1c:	4681                	li	a3,0
    80000f1e:	4605                	li	a2,1
    80000f20:	040005b7          	lui	a1,0x4000
    80000f24:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80000f26:	05b2                	slli	a1,a1,0xc
    80000f28:	f4cff0ef          	jal	80000674 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000f2c:	4681                	li	a3,0
    80000f2e:	4605                	li	a2,1
    80000f30:	020005b7          	lui	a1,0x2000
    80000f34:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80000f36:	05b6                	slli	a1,a1,0xd
    80000f38:	8526                	mv	a0,s1
    80000f3a:	f3aff0ef          	jal	80000674 <uvmunmap>
  uvmfree(pagetable, sz);
    80000f3e:	85ca                	mv	a1,s2
    80000f40:	8526                	mv	a0,s1
    80000f42:	91bff0ef          	jal	8000085c <uvmfree>
}
    80000f46:	60e2                	ld	ra,24(sp)
    80000f48:	6442                	ld	s0,16(sp)
    80000f4a:	64a2                	ld	s1,8(sp)
    80000f4c:	6902                	ld	s2,0(sp)
    80000f4e:	6105                	addi	sp,sp,32
    80000f50:	8082                	ret

0000000080000f52 <freeproc>:
{
    80000f52:	1101                	addi	sp,sp,-32
    80000f54:	ec06                	sd	ra,24(sp)
    80000f56:	e822                	sd	s0,16(sp)
    80000f58:	e426                	sd	s1,8(sp)
    80000f5a:	1000                	addi	s0,sp,32
    80000f5c:	84aa                	mv	s1,a0
  if(p->trapframe)
    80000f5e:	6d28                	ld	a0,88(a0)
    80000f60:	c119                	beqz	a0,80000f66 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80000f62:	8baff0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80000f66:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    80000f6a:	68a8                	ld	a0,80(s1)
    80000f6c:	c501                	beqz	a0,80000f74 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    80000f6e:	64ac                	ld	a1,72(s1)
    80000f70:	f9dff0ef          	jal	80000f0c <proc_freepagetable>
  p->pagetable = 0;
    80000f74:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80000f78:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80000f7c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80000f80:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80000f84:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80000f88:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    80000f8c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80000f90:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80000f94:	0004ac23          	sw	zero,24(s1)
}
    80000f98:	60e2                	ld	ra,24(sp)
    80000f9a:	6442                	ld	s0,16(sp)
    80000f9c:	64a2                	ld	s1,8(sp)
    80000f9e:	6105                	addi	sp,sp,32
    80000fa0:	8082                	ret

0000000080000fa2 <allocproc>:
{
    80000fa2:	1101                	addi	sp,sp,-32
    80000fa4:	ec06                	sd	ra,24(sp)
    80000fa6:	e822                	sd	s0,16(sp)
    80000fa8:	e426                	sd	s1,8(sp)
    80000faa:	e04a                	sd	s2,0(sp)
    80000fac:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fae:	00007497          	auipc	s1,0x7
    80000fb2:	d2248493          	addi	s1,s1,-734 # 80007cd0 <proc>
    80000fb6:	0000f917          	auipc	s2,0xf
    80000fba:	91a90913          	addi	s2,s2,-1766 # 8000f8d0 <tickslock>
    acquire(&p->lock);
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	239040ef          	jal	800059f8 <acquire>
    if(p->state == UNUSED) {
    80000fc4:	4c9c                	lw	a5,24(s1)
    80000fc6:	cb91                	beqz	a5,80000fda <allocproc+0x38>
      release(&p->lock);
    80000fc8:	8526                	mv	a0,s1
    80000fca:	2c3040ef          	jal	80005a8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fce:	1f048493          	addi	s1,s1,496
    80000fd2:	ff2496e3          	bne	s1,s2,80000fbe <allocproc+0x1c>
  return 0;
    80000fd6:	4481                	li	s1,0
    80000fd8:	a089                	j	8000101a <allocproc+0x78>
  p->pid = allocpid();
    80000fda:	e71ff0ef          	jal	80000e4a <allocpid>
    80000fde:	d888                	sw	a0,48(s1)
  p->state = USED;
    80000fe0:	4785                	li	a5,1
    80000fe2:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80000fe4:	918ff0ef          	jal	800000fc <kalloc>
    80000fe8:	892a                	mv	s2,a0
    80000fea:	eca8                	sd	a0,88(s1)
    80000fec:	cd15                	beqz	a0,80001028 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    80000fee:	8526                	mv	a0,s1
    80000ff0:	e99ff0ef          	jal	80000e88 <proc_pagetable>
    80000ff4:	892a                	mv	s2,a0
    80000ff6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    80000ff8:	c121                	beqz	a0,80001038 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    80000ffa:	07000613          	li	a2,112
    80000ffe:	4581                	li	a1,0
    80001000:	06048513          	addi	a0,s1,96
    80001004:	93aff0ef          	jal	8000013e <memset>
  p->context.ra = (uint64)forkret;
    80001008:	00000797          	auipc	a5,0x0
    8000100c:	da878793          	addi	a5,a5,-600 # 80000db0 <forkret>
    80001010:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    80001012:	60bc                	ld	a5,64(s1)
    80001014:	6705                	lui	a4,0x1
    80001016:	97ba                	add	a5,a5,a4
    80001018:	f4bc                	sd	a5,104(s1)
}
    8000101a:	8526                	mv	a0,s1
    8000101c:	60e2                	ld	ra,24(sp)
    8000101e:	6442                	ld	s0,16(sp)
    80001020:	64a2                	ld	s1,8(sp)
    80001022:	6902                	ld	s2,0(sp)
    80001024:	6105                	addi	sp,sp,32
    80001026:	8082                	ret
    freeproc(p);
    80001028:	8526                	mv	a0,s1
    8000102a:	f29ff0ef          	jal	80000f52 <freeproc>
    release(&p->lock);
    8000102e:	8526                	mv	a0,s1
    80001030:	25d040ef          	jal	80005a8c <release>
    return 0;
    80001034:	84ca                	mv	s1,s2
    80001036:	b7d5                	j	8000101a <allocproc+0x78>
    freeproc(p);
    80001038:	8526                	mv	a0,s1
    8000103a:	f19ff0ef          	jal	80000f52 <freeproc>
    release(&p->lock);
    8000103e:	8526                	mv	a0,s1
    80001040:	24d040ef          	jal	80005a8c <release>
    return 0;
    80001044:	84ca                	mv	s1,s2
    80001046:	bfd1                	j	8000101a <allocproc+0x78>

0000000080001048 <userinit>:
{
    80001048:	1101                	addi	sp,sp,-32
    8000104a:	ec06                	sd	ra,24(sp)
    8000104c:	e822                	sd	s0,16(sp)
    8000104e:	e426                	sd	s1,8(sp)
    80001050:	1000                	addi	s0,sp,32
  p = allocproc();
    80001052:	f51ff0ef          	jal	80000fa2 <allocproc>
    80001056:	84aa                	mv	s1,a0
  initproc = p;
    80001058:	00007797          	auipc	a5,0x7
    8000105c:	80a7b423          	sd	a0,-2040(a5) # 80007860 <initproc>
  p->cwd = namei("/");
    80001060:	00006517          	auipc	a0,0x6
    80001064:	0e850513          	addi	a0,a0,232 # 80007148 <etext+0x148>
    80001068:	71f010ef          	jal	80002f86 <namei>
    8000106c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001070:	478d                	li	a5,3
    80001072:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001074:	8526                	mv	a0,s1
    80001076:	217040ef          	jal	80005a8c <release>
}
    8000107a:	60e2                	ld	ra,24(sp)
    8000107c:	6442                	ld	s0,16(sp)
    8000107e:	64a2                	ld	s1,8(sp)
    80001080:	6105                	addi	sp,sp,32
    80001082:	8082                	ret

0000000080001084 <growproc>:
{
    80001084:	1101                	addi	sp,sp,-32
    80001086:	ec06                	sd	ra,24(sp)
    80001088:	e822                	sd	s0,16(sp)
    8000108a:	e426                	sd	s1,8(sp)
    8000108c:	e04a                	sd	s2,0(sp)
    8000108e:	1000                	addi	s0,sp,32
    80001090:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001092:	cedff0ef          	jal	80000d7e <myproc>
    80001096:	84aa                	mv	s1,a0
  sz = p->sz;
    80001098:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000109a:	01204c63          	bgtz	s2,800010b2 <growproc+0x2e>
  } else if(n < 0){
    8000109e:	02094463          	bltz	s2,800010c6 <growproc+0x42>
  p->sz = sz;
    800010a2:	e4ac                	sd	a1,72(s1)
  return 0;
    800010a4:	4501                	li	a0,0
}
    800010a6:	60e2                	ld	ra,24(sp)
    800010a8:	6442                	ld	s0,16(sp)
    800010aa:	64a2                	ld	s1,8(sp)
    800010ac:	6902                	ld	s2,0(sp)
    800010ae:	6105                	addi	sp,sp,32
    800010b0:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800010b2:	4691                	li	a3,4
    800010b4:	00b90633          	add	a2,s2,a1
    800010b8:	6928                	ld	a0,80(a0)
    800010ba:	ea4ff0ef          	jal	8000075e <uvmalloc>
    800010be:	85aa                	mv	a1,a0
    800010c0:	f16d                	bnez	a0,800010a2 <growproc+0x1e>
      return -1;
    800010c2:	557d                	li	a0,-1
    800010c4:	b7cd                	j	800010a6 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800010c6:	00b90633          	add	a2,s2,a1
    800010ca:	6928                	ld	a0,80(a0)
    800010cc:	e4eff0ef          	jal	8000071a <uvmdealloc>
    800010d0:	85aa                	mv	a1,a0
    800010d2:	bfc1                	j	800010a2 <growproc+0x1e>

00000000800010d4 <kfork>:
{
    800010d4:	7139                	addi	sp,sp,-64
    800010d6:	fc06                	sd	ra,56(sp)
    800010d8:	f822                	sd	s0,48(sp)
    800010da:	f426                	sd	s1,40(sp)
    800010dc:	e456                	sd	s5,8(sp)
    800010de:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    800010e0:	c9fff0ef          	jal	80000d7e <myproc>
    800010e4:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    800010e6:	ebdff0ef          	jal	80000fa2 <allocproc>
    800010ea:	10050963          	beqz	a0,800011fc <kfork+0x128>
    800010ee:	ec4e                	sd	s3,24(sp)
    800010f0:	89aa                	mv	s3,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800010f2:	048ab603          	ld	a2,72(s5)
    800010f6:	692c                	ld	a1,80(a0)
    800010f8:	050ab503          	ld	a0,80(s5)
    800010fc:	f92ff0ef          	jal	8000088e <uvmcopy>
    80001100:	06054763          	bltz	a0,8000116e <kfork+0x9a>
    80001104:	f04a                	sd	s2,32(sp)
    80001106:	e852                	sd	s4,16(sp)
  np->sz = p->sz;
    80001108:	048ab783          	ld	a5,72(s5)
    8000110c:	04f9b423          	sd	a5,72(s3)
  np->mask = p->mask;
    80001110:	1e8aa783          	lw	a5,488(s5)
    80001114:	1ef9a423          	sw	a5,488(s3)
  strncpy(np->allowPath, p->allowPath, strlen(p->allowPath));
    80001118:	168a8493          	addi	s1,s5,360
    8000111c:	8526                	mv	a0,s1
    8000111e:	9aaff0ef          	jal	800002c8 <strlen>
    80001122:	862a                	mv	a2,a0
    80001124:	85a6                	mv	a1,s1
    80001126:	16898513          	addi	a0,s3,360
    8000112a:	922ff0ef          	jal	8000024c <strncpy>
  *(np->trapframe) = *(p->trapframe);
    8000112e:	058ab683          	ld	a3,88(s5)
    80001132:	87b6                	mv	a5,a3
    80001134:	0589b703          	ld	a4,88(s3)
    80001138:	12068693          	addi	a3,a3,288
    8000113c:	6388                	ld	a0,0(a5)
    8000113e:	678c                	ld	a1,8(a5)
    80001140:	6b90                	ld	a2,16(a5)
    80001142:	e308                	sd	a0,0(a4)
    80001144:	e70c                	sd	a1,8(a4)
    80001146:	eb10                	sd	a2,16(a4)
    80001148:	6f90                	ld	a2,24(a5)
    8000114a:	ef10                	sd	a2,24(a4)
    8000114c:	02078793          	addi	a5,a5,32
    80001150:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    80001154:	fed794e3          	bne	a5,a3,8000113c <kfork+0x68>
  np->trapframe->a0 = 0;
    80001158:	0589b783          	ld	a5,88(s3)
    8000115c:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    80001160:	0d0a8493          	addi	s1,s5,208
    80001164:	0d098913          	addi	s2,s3,208
    80001168:	150a8a13          	addi	s4,s5,336
    8000116c:	a831                	j	80001188 <kfork+0xb4>
    freeproc(np);
    8000116e:	854e                	mv	a0,s3
    80001170:	de3ff0ef          	jal	80000f52 <freeproc>
    release(&np->lock);
    80001174:	854e                	mv	a0,s3
    80001176:	117040ef          	jal	80005a8c <release>
    return -1;
    8000117a:	54fd                	li	s1,-1
    8000117c:	69e2                	ld	s3,24(sp)
    8000117e:	a885                	j	800011ee <kfork+0x11a>
  for(i = 0; i < NOFILE; i++)
    80001180:	04a1                	addi	s1,s1,8
    80001182:	0921                	addi	s2,s2,8
    80001184:	01448963          	beq	s1,s4,80001196 <kfork+0xc2>
    if(p->ofile[i])
    80001188:	6088                	ld	a0,0(s1)
    8000118a:	d97d                	beqz	a0,80001180 <kfork+0xac>
      np->ofile[i] = filedup(p->ofile[i]);
    8000118c:	3b6020ef          	jal	80003542 <filedup>
    80001190:	00a93023          	sd	a0,0(s2)
    80001194:	b7f5                	j	80001180 <kfork+0xac>
  np->cwd = idup(p->cwd);
    80001196:	150ab503          	ld	a0,336(s5)
    8000119a:	588010ef          	jal	80002722 <idup>
    8000119e:	14a9b823          	sd	a0,336(s3)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800011a2:	4641                	li	a2,16
    800011a4:	158a8593          	addi	a1,s5,344
    800011a8:	15898513          	addi	a0,s3,344
    800011ac:	8e6ff0ef          	jal	80000292 <safestrcpy>
  pid = np->pid;
    800011b0:	0309a483          	lw	s1,48(s3)
  release(&np->lock);
    800011b4:	854e                	mv	a0,s3
    800011b6:	0d7040ef          	jal	80005a8c <release>
  acquire(&wait_lock);
    800011ba:	00006517          	auipc	a0,0x6
    800011be:	6fe50513          	addi	a0,a0,1790 # 800078b8 <wait_lock>
    800011c2:	037040ef          	jal	800059f8 <acquire>
  np->parent = p;
    800011c6:	0359bc23          	sd	s5,56(s3)
  release(&wait_lock);
    800011ca:	00006517          	auipc	a0,0x6
    800011ce:	6ee50513          	addi	a0,a0,1774 # 800078b8 <wait_lock>
    800011d2:	0bb040ef          	jal	80005a8c <release>
  acquire(&np->lock);
    800011d6:	854e                	mv	a0,s3
    800011d8:	021040ef          	jal	800059f8 <acquire>
  np->state = RUNNABLE;
    800011dc:	478d                	li	a5,3
    800011de:	00f9ac23          	sw	a5,24(s3)
  release(&np->lock);
    800011e2:	854e                	mv	a0,s3
    800011e4:	0a9040ef          	jal	80005a8c <release>
  return pid;
    800011e8:	7902                	ld	s2,32(sp)
    800011ea:	69e2                	ld	s3,24(sp)
    800011ec:	6a42                	ld	s4,16(sp)
}
    800011ee:	8526                	mv	a0,s1
    800011f0:	70e2                	ld	ra,56(sp)
    800011f2:	7442                	ld	s0,48(sp)
    800011f4:	74a2                	ld	s1,40(sp)
    800011f6:	6aa2                	ld	s5,8(sp)
    800011f8:	6121                	addi	sp,sp,64
    800011fa:	8082                	ret
    return -1;
    800011fc:	54fd                	li	s1,-1
    800011fe:	bfc5                	j	800011ee <kfork+0x11a>

0000000080001200 <scheduler>:
{
    80001200:	715d                	addi	sp,sp,-80
    80001202:	e486                	sd	ra,72(sp)
    80001204:	e0a2                	sd	s0,64(sp)
    80001206:	fc26                	sd	s1,56(sp)
    80001208:	f84a                	sd	s2,48(sp)
    8000120a:	f44e                	sd	s3,40(sp)
    8000120c:	f052                	sd	s4,32(sp)
    8000120e:	ec56                	sd	s5,24(sp)
    80001210:	e85a                	sd	s6,16(sp)
    80001212:	e45e                	sd	s7,8(sp)
    80001214:	e062                	sd	s8,0(sp)
    80001216:	0880                	addi	s0,sp,80
    80001218:	8792                	mv	a5,tp
  int id = r_tp();
    8000121a:	2781                	sext.w	a5,a5
  c->proc = 0;
    8000121c:	00779b13          	slli	s6,a5,0x7
    80001220:	00006717          	auipc	a4,0x6
    80001224:	68070713          	addi	a4,a4,1664 # 800078a0 <pid_lock>
    80001228:	975a                	add	a4,a4,s6
    8000122a:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    8000122e:	00006717          	auipc	a4,0x6
    80001232:	6aa70713          	addi	a4,a4,1706 # 800078d8 <cpus+0x8>
    80001236:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001238:	4c11                	li	s8,4
        c->proc = p;
    8000123a:	079e                	slli	a5,a5,0x7
    8000123c:	00006a17          	auipc	s4,0x6
    80001240:	664a0a13          	addi	s4,s4,1636 # 800078a0 <pid_lock>
    80001244:	9a3e                	add	s4,s4,a5
        found = 1;
    80001246:	4b85                	li	s7,1
    80001248:	a83d                	j	80001286 <scheduler+0x86>
      release(&p->lock);
    8000124a:	8526                	mv	a0,s1
    8000124c:	041040ef          	jal	80005a8c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    80001250:	1f048493          	addi	s1,s1,496
    80001254:	03248563          	beq	s1,s2,8000127e <scheduler+0x7e>
      acquire(&p->lock);
    80001258:	8526                	mv	a0,s1
    8000125a:	79e040ef          	jal	800059f8 <acquire>
      if(p->state == RUNNABLE) {
    8000125e:	4c9c                	lw	a5,24(s1)
    80001260:	ff3795e3          	bne	a5,s3,8000124a <scheduler+0x4a>
        p->state = RUNNING;
    80001264:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001268:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    8000126c:	06048593          	addi	a1,s1,96
    80001270:	855a                	mv	a0,s6
    80001272:	5ba000ef          	jal	8000182c <swtch>
        c->proc = 0;
    80001276:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000127a:	8ade                	mv	s5,s7
    8000127c:	b7f9                	j	8000124a <scheduler+0x4a>
    if(found == 0) {
    8000127e:	000a9463          	bnez	s5,80001286 <scheduler+0x86>
      asm volatile("wfi");
    80001282:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001286:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000128a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000128e:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001292:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001296:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001298:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000129c:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    8000129e:	00007497          	auipc	s1,0x7
    800012a2:	a3248493          	addi	s1,s1,-1486 # 80007cd0 <proc>
      if(p->state == RUNNABLE) {
    800012a6:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800012a8:	0000e917          	auipc	s2,0xe
    800012ac:	62890913          	addi	s2,s2,1576 # 8000f8d0 <tickslock>
    800012b0:	b765                	j	80001258 <scheduler+0x58>

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
    800012c0:	abfff0ef          	jal	80000d7e <myproc>
    800012c4:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800012c6:	6c2040ef          	jal	80005988 <holding>
    800012ca:	c935                	beqz	a0,8000133e <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    800012cc:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800012ce:	2781                	sext.w	a5,a5
    800012d0:	079e                	slli	a5,a5,0x7
    800012d2:	00006717          	auipc	a4,0x6
    800012d6:	5ce70713          	addi	a4,a4,1486 # 800078a0 <pid_lock>
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
    800012fc:	5a890913          	addi	s2,s2,1448 # 800078a0 <pid_lock>
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
    80001316:	5be58593          	addi	a1,a1,1470 # 800078d0 <cpus>
    8000131a:	95be                	add	a1,a1,a5
    8000131c:	06048513          	addi	a0,s1,96
    80001320:	50c000ef          	jal	8000182c <swtch>
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
    80001342:	e1250513          	addi	a0,a0,-494 # 80007150 <etext+0x150>
    80001346:	3f0040ef          	jal	80005736 <panic>
    panic("sched locks");
    8000134a:	00006517          	auipc	a0,0x6
    8000134e:	e1650513          	addi	a0,a0,-490 # 80007160 <etext+0x160>
    80001352:	3e4040ef          	jal	80005736 <panic>
    panic("sched RUNNING");
    80001356:	00006517          	auipc	a0,0x6
    8000135a:	e1a50513          	addi	a0,a0,-486 # 80007170 <etext+0x170>
    8000135e:	3d8040ef          	jal	80005736 <panic>
    panic("sched interruptible");
    80001362:	00006517          	auipc	a0,0x6
    80001366:	e1e50513          	addi	a0,a0,-482 # 80007180 <etext+0x180>
    8000136a:	3cc040ef          	jal	80005736 <panic>

000000008000136e <yield>:
{
    8000136e:	1101                	addi	sp,sp,-32
    80001370:	ec06                	sd	ra,24(sp)
    80001372:	e822                	sd	s0,16(sp)
    80001374:	e426                	sd	s1,8(sp)
    80001376:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001378:	a07ff0ef          	jal	80000d7e <myproc>
    8000137c:	84aa                	mv	s1,a0
  acquire(&p->lock);
    8000137e:	67a040ef          	jal	800059f8 <acquire>
  p->state = RUNNABLE;
    80001382:	478d                	li	a5,3
    80001384:	cc9c                	sw	a5,24(s1)
  sched();
    80001386:	f2dff0ef          	jal	800012b2 <sched>
  release(&p->lock);
    8000138a:	8526                	mv	a0,s1
    8000138c:	700040ef          	jal	80005a8c <release>
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
    800013ac:	9d3ff0ef          	jal	80000d7e <myproc>
    800013b0:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800013b2:	646040ef          	jal	800059f8 <acquire>
  release(lk);
    800013b6:	854a                	mv	a0,s2
    800013b8:	6d4040ef          	jal	80005a8c <release>

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
    800013ce:	6be040ef          	jal	80005a8c <release>
  acquire(lk);
    800013d2:	854a                	mv	a0,s2
    800013d4:	624040ef          	jal	800059f8 <acquire>
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
    800013e6:	7139                	addi	sp,sp,-64
    800013e8:	fc06                	sd	ra,56(sp)
    800013ea:	f822                	sd	s0,48(sp)
    800013ec:	f426                	sd	s1,40(sp)
    800013ee:	f04a                	sd	s2,32(sp)
    800013f0:	ec4e                	sd	s3,24(sp)
    800013f2:	e852                	sd	s4,16(sp)
    800013f4:	e456                	sd	s5,8(sp)
    800013f6:	0080                	addi	s0,sp,64
    800013f8:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    800013fa:	00007497          	auipc	s1,0x7
    800013fe:	8d648493          	addi	s1,s1,-1834 # 80007cd0 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001402:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001404:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001406:	0000e917          	auipc	s2,0xe
    8000140a:	4ca90913          	addi	s2,s2,1226 # 8000f8d0 <tickslock>
    8000140e:	a801                	j	8000141e <wakeup+0x38>
      }
      release(&p->lock);
    80001410:	8526                	mv	a0,s1
    80001412:	67a040ef          	jal	80005a8c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001416:	1f048493          	addi	s1,s1,496
    8000141a:	03248263          	beq	s1,s2,8000143e <wakeup+0x58>
    if(p != myproc()){
    8000141e:	961ff0ef          	jal	80000d7e <myproc>
    80001422:	fe950ae3          	beq	a0,s1,80001416 <wakeup+0x30>
      acquire(&p->lock);
    80001426:	8526                	mv	a0,s1
    80001428:	5d0040ef          	jal	800059f8 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    8000142c:	4c9c                	lw	a5,24(s1)
    8000142e:	ff3791e3          	bne	a5,s3,80001410 <wakeup+0x2a>
    80001432:	709c                	ld	a5,32(s1)
    80001434:	fd479ee3          	bne	a5,s4,80001410 <wakeup+0x2a>
        p->state = RUNNABLE;
    80001438:	0154ac23          	sw	s5,24(s1)
    8000143c:	bfd1                	j	80001410 <wakeup+0x2a>
    }
  }
}
    8000143e:	70e2                	ld	ra,56(sp)
    80001440:	7442                	ld	s0,48(sp)
    80001442:	74a2                	ld	s1,40(sp)
    80001444:	7902                	ld	s2,32(sp)
    80001446:	69e2                	ld	s3,24(sp)
    80001448:	6a42                	ld	s4,16(sp)
    8000144a:	6aa2                	ld	s5,8(sp)
    8000144c:	6121                	addi	sp,sp,64
    8000144e:	8082                	ret

0000000080001450 <reparent>:
{
    80001450:	7179                	addi	sp,sp,-48
    80001452:	f406                	sd	ra,40(sp)
    80001454:	f022                	sd	s0,32(sp)
    80001456:	ec26                	sd	s1,24(sp)
    80001458:	e84a                	sd	s2,16(sp)
    8000145a:	e44e                	sd	s3,8(sp)
    8000145c:	e052                	sd	s4,0(sp)
    8000145e:	1800                	addi	s0,sp,48
    80001460:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001462:	00007497          	auipc	s1,0x7
    80001466:	86e48493          	addi	s1,s1,-1938 # 80007cd0 <proc>
      pp->parent = initproc;
    8000146a:	00006a17          	auipc	s4,0x6
    8000146e:	3f6a0a13          	addi	s4,s4,1014 # 80007860 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001472:	0000e997          	auipc	s3,0xe
    80001476:	45e98993          	addi	s3,s3,1118 # 8000f8d0 <tickslock>
    8000147a:	a029                	j	80001484 <reparent+0x34>
    8000147c:	1f048493          	addi	s1,s1,496
    80001480:	01348b63          	beq	s1,s3,80001496 <reparent+0x46>
    if(pp->parent == p){
    80001484:	7c9c                	ld	a5,56(s1)
    80001486:	ff279be3          	bne	a5,s2,8000147c <reparent+0x2c>
      pp->parent = initproc;
    8000148a:	000a3503          	ld	a0,0(s4)
    8000148e:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001490:	f57ff0ef          	jal	800013e6 <wakeup>
    80001494:	b7e5                	j	8000147c <reparent+0x2c>
}
    80001496:	70a2                	ld	ra,40(sp)
    80001498:	7402                	ld	s0,32(sp)
    8000149a:	64e2                	ld	s1,24(sp)
    8000149c:	6942                	ld	s2,16(sp)
    8000149e:	69a2                	ld	s3,8(sp)
    800014a0:	6a02                	ld	s4,0(sp)
    800014a2:	6145                	addi	sp,sp,48
    800014a4:	8082                	ret

00000000800014a6 <kexit>:
{
    800014a6:	7179                	addi	sp,sp,-48
    800014a8:	f406                	sd	ra,40(sp)
    800014aa:	f022                	sd	s0,32(sp)
    800014ac:	ec26                	sd	s1,24(sp)
    800014ae:	e84a                	sd	s2,16(sp)
    800014b0:	e44e                	sd	s3,8(sp)
    800014b2:	e052                	sd	s4,0(sp)
    800014b4:	1800                	addi	s0,sp,48
    800014b6:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    800014b8:	8c7ff0ef          	jal	80000d7e <myproc>
    800014bc:	89aa                	mv	s3,a0
  if(p == initproc)
    800014be:	00006797          	auipc	a5,0x6
    800014c2:	3a27b783          	ld	a5,930(a5) # 80007860 <initproc>
    800014c6:	0d050493          	addi	s1,a0,208
    800014ca:	15050913          	addi	s2,a0,336
    800014ce:	00a79b63          	bne	a5,a0,800014e4 <kexit+0x3e>
    panic("init exiting");
    800014d2:	00006517          	auipc	a0,0x6
    800014d6:	cc650513          	addi	a0,a0,-826 # 80007198 <etext+0x198>
    800014da:	25c040ef          	jal	80005736 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    800014de:	04a1                	addi	s1,s1,8
    800014e0:	01248963          	beq	s1,s2,800014f2 <kexit+0x4c>
    if(p->ofile[fd]){
    800014e4:	6088                	ld	a0,0(s1)
    800014e6:	dd65                	beqz	a0,800014de <kexit+0x38>
      fileclose(f);
    800014e8:	0a0020ef          	jal	80003588 <fileclose>
      p->ofile[fd] = 0;
    800014ec:	0004b023          	sd	zero,0(s1)
    800014f0:	b7fd                	j	800014de <kexit+0x38>
  begin_op();
    800014f2:	473010ef          	jal	80003164 <begin_op>
  iput(p->cwd);
    800014f6:	1509b503          	ld	a0,336(s3)
    800014fa:	3e0010ef          	jal	800028da <iput>
  end_op();
    800014fe:	4d7010ef          	jal	800031d4 <end_op>
  p->cwd = 0;
    80001502:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001506:	00006517          	auipc	a0,0x6
    8000150a:	3b250513          	addi	a0,a0,946 # 800078b8 <wait_lock>
    8000150e:	4ea040ef          	jal	800059f8 <acquire>
  reparent(p);
    80001512:	854e                	mv	a0,s3
    80001514:	f3dff0ef          	jal	80001450 <reparent>
  wakeup(p->parent);
    80001518:	0389b503          	ld	a0,56(s3)
    8000151c:	ecbff0ef          	jal	800013e6 <wakeup>
  acquire(&p->lock);
    80001520:	854e                	mv	a0,s3
    80001522:	4d6040ef          	jal	800059f8 <acquire>
  p->xstate = status;
    80001526:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    8000152a:	4795                	li	a5,5
    8000152c:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001530:	00006517          	auipc	a0,0x6
    80001534:	38850513          	addi	a0,a0,904 # 800078b8 <wait_lock>
    80001538:	554040ef          	jal	80005a8c <release>
  sched();
    8000153c:	d77ff0ef          	jal	800012b2 <sched>
  panic("zombie exit");
    80001540:	00006517          	auipc	a0,0x6
    80001544:	c6850513          	addi	a0,a0,-920 # 800071a8 <etext+0x1a8>
    80001548:	1ee040ef          	jal	80005736 <panic>

000000008000154c <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    8000154c:	7179                	addi	sp,sp,-48
    8000154e:	f406                	sd	ra,40(sp)
    80001550:	f022                	sd	s0,32(sp)
    80001552:	ec26                	sd	s1,24(sp)
    80001554:	e84a                	sd	s2,16(sp)
    80001556:	e44e                	sd	s3,8(sp)
    80001558:	1800                	addi	s0,sp,48
    8000155a:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    8000155c:	00006497          	auipc	s1,0x6
    80001560:	77448493          	addi	s1,s1,1908 # 80007cd0 <proc>
    80001564:	0000e997          	auipc	s3,0xe
    80001568:	36c98993          	addi	s3,s3,876 # 8000f8d0 <tickslock>
    acquire(&p->lock);
    8000156c:	8526                	mv	a0,s1
    8000156e:	48a040ef          	jal	800059f8 <acquire>
    if(p->pid == pid){
    80001572:	589c                	lw	a5,48(s1)
    80001574:	01278b63          	beq	a5,s2,8000158a <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001578:	8526                	mv	a0,s1
    8000157a:	512040ef          	jal	80005a8c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    8000157e:	1f048493          	addi	s1,s1,496
    80001582:	ff3495e3          	bne	s1,s3,8000156c <kkill+0x20>
  }
  return -1;
    80001586:	557d                	li	a0,-1
    80001588:	a819                	j	8000159e <kkill+0x52>
      p->killed = 1;
    8000158a:	4785                	li	a5,1
    8000158c:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    8000158e:	4c98                	lw	a4,24(s1)
    80001590:	4789                	li	a5,2
    80001592:	00f70d63          	beq	a4,a5,800015ac <kkill+0x60>
      release(&p->lock);
    80001596:	8526                	mv	a0,s1
    80001598:	4f4040ef          	jal	80005a8c <release>
      return 0;
    8000159c:	4501                	li	a0,0
}
    8000159e:	70a2                	ld	ra,40(sp)
    800015a0:	7402                	ld	s0,32(sp)
    800015a2:	64e2                	ld	s1,24(sp)
    800015a4:	6942                	ld	s2,16(sp)
    800015a6:	69a2                	ld	s3,8(sp)
    800015a8:	6145                	addi	sp,sp,48
    800015aa:	8082                	ret
        p->state = RUNNABLE;
    800015ac:	478d                	li	a5,3
    800015ae:	cc9c                	sw	a5,24(s1)
    800015b0:	b7dd                	j	80001596 <kkill+0x4a>

00000000800015b2 <setkilled>:

void
setkilled(struct proc *p)
{
    800015b2:	1101                	addi	sp,sp,-32
    800015b4:	ec06                	sd	ra,24(sp)
    800015b6:	e822                	sd	s0,16(sp)
    800015b8:	e426                	sd	s1,8(sp)
    800015ba:	1000                	addi	s0,sp,32
    800015bc:	84aa                	mv	s1,a0
  acquire(&p->lock);
    800015be:	43a040ef          	jal	800059f8 <acquire>
  p->killed = 1;
    800015c2:	4785                	li	a5,1
    800015c4:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    800015c6:	8526                	mv	a0,s1
    800015c8:	4c4040ef          	jal	80005a8c <release>
}
    800015cc:	60e2                	ld	ra,24(sp)
    800015ce:	6442                	ld	s0,16(sp)
    800015d0:	64a2                	ld	s1,8(sp)
    800015d2:	6105                	addi	sp,sp,32
    800015d4:	8082                	ret

00000000800015d6 <killed>:

int
killed(struct proc *p)
{
    800015d6:	1101                	addi	sp,sp,-32
    800015d8:	ec06                	sd	ra,24(sp)
    800015da:	e822                	sd	s0,16(sp)
    800015dc:	e426                	sd	s1,8(sp)
    800015de:	e04a                	sd	s2,0(sp)
    800015e0:	1000                	addi	s0,sp,32
    800015e2:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    800015e4:	414040ef          	jal	800059f8 <acquire>
  k = p->killed;
    800015e8:	549c                	lw	a5,40(s1)
    800015ea:	893e                	mv	s2,a5
  release(&p->lock);
    800015ec:	8526                	mv	a0,s1
    800015ee:	49e040ef          	jal	80005a8c <release>
  return k;
}
    800015f2:	854a                	mv	a0,s2
    800015f4:	60e2                	ld	ra,24(sp)
    800015f6:	6442                	ld	s0,16(sp)
    800015f8:	64a2                	ld	s1,8(sp)
    800015fa:	6902                	ld	s2,0(sp)
    800015fc:	6105                	addi	sp,sp,32
    800015fe:	8082                	ret

0000000080001600 <kwait>:
{
    80001600:	715d                	addi	sp,sp,-80
    80001602:	e486                	sd	ra,72(sp)
    80001604:	e0a2                	sd	s0,64(sp)
    80001606:	fc26                	sd	s1,56(sp)
    80001608:	f84a                	sd	s2,48(sp)
    8000160a:	f44e                	sd	s3,40(sp)
    8000160c:	f052                	sd	s4,32(sp)
    8000160e:	ec56                	sd	s5,24(sp)
    80001610:	e85a                	sd	s6,16(sp)
    80001612:	e45e                	sd	s7,8(sp)
    80001614:	0880                	addi	s0,sp,80
    80001616:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001618:	f66ff0ef          	jal	80000d7e <myproc>
    8000161c:	892a                	mv	s2,a0
  acquire(&wait_lock);
    8000161e:	00006517          	auipc	a0,0x6
    80001622:	29a50513          	addi	a0,a0,666 # 800078b8 <wait_lock>
    80001626:	3d2040ef          	jal	800059f8 <acquire>
        if(pp->state == ZOMBIE){
    8000162a:	4a15                	li	s4,5
        havekids = 1;
    8000162c:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000162e:	0000e997          	auipc	s3,0xe
    80001632:	2a298993          	addi	s3,s3,674 # 8000f8d0 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001636:	00006b17          	auipc	s6,0x6
    8000163a:	282b0b13          	addi	s6,s6,642 # 800078b8 <wait_lock>
    8000163e:	a869                	j	800016d8 <kwait+0xd8>
          pid = pp->pid;
    80001640:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001644:	000b8c63          	beqz	s7,8000165c <kwait+0x5c>
    80001648:	4691                	li	a3,4
    8000164a:	02c48613          	addi	a2,s1,44
    8000164e:	85de                	mv	a1,s7
    80001650:	05093503          	ld	a0,80(s2)
    80001654:	c5aff0ef          	jal	80000aae <copyout>
    80001658:	02054a63          	bltz	a0,8000168c <kwait+0x8c>
          freeproc(pp);
    8000165c:	8526                	mv	a0,s1
    8000165e:	8f5ff0ef          	jal	80000f52 <freeproc>
          release(&pp->lock);
    80001662:	8526                	mv	a0,s1
    80001664:	428040ef          	jal	80005a8c <release>
          release(&wait_lock);
    80001668:	00006517          	auipc	a0,0x6
    8000166c:	25050513          	addi	a0,a0,592 # 800078b8 <wait_lock>
    80001670:	41c040ef          	jal	80005a8c <release>
}
    80001674:	854e                	mv	a0,s3
    80001676:	60a6                	ld	ra,72(sp)
    80001678:	6406                	ld	s0,64(sp)
    8000167a:	74e2                	ld	s1,56(sp)
    8000167c:	7942                	ld	s2,48(sp)
    8000167e:	79a2                	ld	s3,40(sp)
    80001680:	7a02                	ld	s4,32(sp)
    80001682:	6ae2                	ld	s5,24(sp)
    80001684:	6b42                	ld	s6,16(sp)
    80001686:	6ba2                	ld	s7,8(sp)
    80001688:	6161                	addi	sp,sp,80
    8000168a:	8082                	ret
            release(&pp->lock);
    8000168c:	8526                	mv	a0,s1
    8000168e:	3fe040ef          	jal	80005a8c <release>
            release(&wait_lock);
    80001692:	00006517          	auipc	a0,0x6
    80001696:	22650513          	addi	a0,a0,550 # 800078b8 <wait_lock>
    8000169a:	3f2040ef          	jal	80005a8c <release>
            return -1;
    8000169e:	59fd                	li	s3,-1
    800016a0:	bfd1                	j	80001674 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016a2:	1f048493          	addi	s1,s1,496
    800016a6:	03348063          	beq	s1,s3,800016c6 <kwait+0xc6>
      if(pp->parent == p){
    800016aa:	7c9c                	ld	a5,56(s1)
    800016ac:	ff279be3          	bne	a5,s2,800016a2 <kwait+0xa2>
        acquire(&pp->lock);
    800016b0:	8526                	mv	a0,s1
    800016b2:	346040ef          	jal	800059f8 <acquire>
        if(pp->state == ZOMBIE){
    800016b6:	4c9c                	lw	a5,24(s1)
    800016b8:	f94784e3          	beq	a5,s4,80001640 <kwait+0x40>
        release(&pp->lock);
    800016bc:	8526                	mv	a0,s1
    800016be:	3ce040ef          	jal	80005a8c <release>
        havekids = 1;
    800016c2:	8756                	mv	a4,s5
    800016c4:	bff9                	j	800016a2 <kwait+0xa2>
    if(!havekids || killed(p)){
    800016c6:	cf19                	beqz	a4,800016e4 <kwait+0xe4>
    800016c8:	854a                	mv	a0,s2
    800016ca:	f0dff0ef          	jal	800015d6 <killed>
    800016ce:	e919                	bnez	a0,800016e4 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800016d0:	85da                	mv	a1,s6
    800016d2:	854a                	mv	a0,s2
    800016d4:	cc7ff0ef          	jal	8000139a <sleep>
    havekids = 0;
    800016d8:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800016da:	00006497          	auipc	s1,0x6
    800016de:	5f648493          	addi	s1,s1,1526 # 80007cd0 <proc>
    800016e2:	b7e1                	j	800016aa <kwait+0xaa>
      release(&wait_lock);
    800016e4:	00006517          	auipc	a0,0x6
    800016e8:	1d450513          	addi	a0,a0,468 # 800078b8 <wait_lock>
    800016ec:	3a0040ef          	jal	80005a8c <release>
      return -1;
    800016f0:	59fd                	li	s3,-1
    800016f2:	b749                	j	80001674 <kwait+0x74>

00000000800016f4 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    800016f4:	7179                	addi	sp,sp,-48
    800016f6:	f406                	sd	ra,40(sp)
    800016f8:	f022                	sd	s0,32(sp)
    800016fa:	ec26                	sd	s1,24(sp)
    800016fc:	e84a                	sd	s2,16(sp)
    800016fe:	e44e                	sd	s3,8(sp)
    80001700:	e052                	sd	s4,0(sp)
    80001702:	1800                	addi	s0,sp,48
    80001704:	84aa                	mv	s1,a0
    80001706:	8a2e                	mv	s4,a1
    80001708:	89b2                	mv	s3,a2
    8000170a:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000170c:	e72ff0ef          	jal	80000d7e <myproc>
  if(user_dst){
    80001710:	cc99                	beqz	s1,8000172e <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001712:	86ca                	mv	a3,s2
    80001714:	864e                	mv	a2,s3
    80001716:	85d2                	mv	a1,s4
    80001718:	6928                	ld	a0,80(a0)
    8000171a:	b94ff0ef          	jal	80000aae <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    8000171e:	70a2                	ld	ra,40(sp)
    80001720:	7402                	ld	s0,32(sp)
    80001722:	64e2                	ld	s1,24(sp)
    80001724:	6942                	ld	s2,16(sp)
    80001726:	69a2                	ld	s3,8(sp)
    80001728:	6a02                	ld	s4,0(sp)
    8000172a:	6145                	addi	sp,sp,48
    8000172c:	8082                	ret
    memmove((char *)dst, src, len);
    8000172e:	0009061b          	sext.w	a2,s2
    80001732:	85ce                	mv	a1,s3
    80001734:	8552                	mv	a0,s4
    80001736:	a69fe0ef          	jal	8000019e <memmove>
    return 0;
    8000173a:	8526                	mv	a0,s1
    8000173c:	b7cd                	j	8000171e <either_copyout+0x2a>

000000008000173e <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    8000173e:	7179                	addi	sp,sp,-48
    80001740:	f406                	sd	ra,40(sp)
    80001742:	f022                	sd	s0,32(sp)
    80001744:	ec26                	sd	s1,24(sp)
    80001746:	e84a                	sd	s2,16(sp)
    80001748:	e44e                	sd	s3,8(sp)
    8000174a:	e052                	sd	s4,0(sp)
    8000174c:	1800                	addi	s0,sp,48
    8000174e:	8a2a                	mv	s4,a0
    80001750:	84ae                	mv	s1,a1
    80001752:	89b2                	mv	s3,a2
    80001754:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001756:	e28ff0ef          	jal	80000d7e <myproc>
  if(user_src){
    8000175a:	cc99                	beqz	s1,80001778 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    8000175c:	86ca                	mv	a3,s2
    8000175e:	864e                	mv	a2,s3
    80001760:	85d2                	mv	a1,s4
    80001762:	6928                	ld	a0,80(a0)
    80001764:	c0eff0ef          	jal	80000b72 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001768:	70a2                	ld	ra,40(sp)
    8000176a:	7402                	ld	s0,32(sp)
    8000176c:	64e2                	ld	s1,24(sp)
    8000176e:	6942                	ld	s2,16(sp)
    80001770:	69a2                	ld	s3,8(sp)
    80001772:	6a02                	ld	s4,0(sp)
    80001774:	6145                	addi	sp,sp,48
    80001776:	8082                	ret
    memmove(dst, (char*)src, len);
    80001778:	0009061b          	sext.w	a2,s2
    8000177c:	85ce                	mv	a1,s3
    8000177e:	8552                	mv	a0,s4
    80001780:	a1ffe0ef          	jal	8000019e <memmove>
    return 0;
    80001784:	8526                	mv	a0,s1
    80001786:	b7cd                	j	80001768 <either_copyin+0x2a>

0000000080001788 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001788:	715d                	addi	sp,sp,-80
    8000178a:	e486                	sd	ra,72(sp)
    8000178c:	e0a2                	sd	s0,64(sp)
    8000178e:	fc26                	sd	s1,56(sp)
    80001790:	f84a                	sd	s2,48(sp)
    80001792:	f44e                	sd	s3,40(sp)
    80001794:	f052                	sd	s4,32(sp)
    80001796:	ec56                	sd	s5,24(sp)
    80001798:	e85a                	sd	s6,16(sp)
    8000179a:	e45e                	sd	s7,8(sp)
    8000179c:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    8000179e:	00006517          	auipc	a0,0x6
    800017a2:	87a50513          	addi	a0,a0,-1926 # 80007018 <etext+0x18>
    800017a6:	467030ef          	jal	8000540c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017aa:	00006497          	auipc	s1,0x6
    800017ae:	67e48493          	addi	s1,s1,1662 # 80007e28 <proc+0x158>
    800017b2:	0000e917          	auipc	s2,0xe
    800017b6:	27690913          	addi	s2,s2,630 # 8000fa28 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017ba:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    800017bc:	00006997          	auipc	s3,0x6
    800017c0:	9fc98993          	addi	s3,s3,-1540 # 800071b8 <etext+0x1b8>
    printf("%d %s %s", p->pid, state, p->name);
    800017c4:	00006a97          	auipc	s5,0x6
    800017c8:	9fca8a93          	addi	s5,s5,-1540 # 800071c0 <etext+0x1c0>
    printf("\n");
    800017cc:	00006a17          	auipc	s4,0x6
    800017d0:	84ca0a13          	addi	s4,s4,-1972 # 80007018 <etext+0x18>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800017d4:	00006b97          	auipc	s7,0x6
    800017d8:	f54b8b93          	addi	s7,s7,-172 # 80007728 <states.0>
    800017dc:	a829                	j	800017f6 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    800017de:	ed86a583          	lw	a1,-296(a3)
    800017e2:	8556                	mv	a0,s5
    800017e4:	429030ef          	jal	8000540c <printf>
    printf("\n");
    800017e8:	8552                	mv	a0,s4
    800017ea:	423030ef          	jal	8000540c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    800017ee:	1f048493          	addi	s1,s1,496
    800017f2:	03248263          	beq	s1,s2,80001816 <procdump+0x8e>
    if(p->state == UNUSED)
    800017f6:	86a6                	mv	a3,s1
    800017f8:	ec04a783          	lw	a5,-320(s1)
    800017fc:	dbed                	beqz	a5,800017ee <procdump+0x66>
      state = "???";
    800017fe:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001800:	fcfb6fe3          	bltu	s6,a5,800017de <procdump+0x56>
    80001804:	02079713          	slli	a4,a5,0x20
    80001808:	01d75793          	srli	a5,a4,0x1d
    8000180c:	97de                	add	a5,a5,s7
    8000180e:	6390                	ld	a2,0(a5)
    80001810:	f679                	bnez	a2,800017de <procdump+0x56>
      state = "???";
    80001812:	864e                	mv	a2,s3
    80001814:	b7e9                	j	800017de <procdump+0x56>
  }
}
    80001816:	60a6                	ld	ra,72(sp)
    80001818:	6406                	ld	s0,64(sp)
    8000181a:	74e2                	ld	s1,56(sp)
    8000181c:	7942                	ld	s2,48(sp)
    8000181e:	79a2                	ld	s3,40(sp)
    80001820:	7a02                	ld	s4,32(sp)
    80001822:	6ae2                	ld	s5,24(sp)
    80001824:	6b42                	ld	s6,16(sp)
    80001826:	6ba2                	ld	s7,8(sp)
    80001828:	6161                	addi	sp,sp,80
    8000182a:	8082                	ret

000000008000182c <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    8000182c:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001830:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001834:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001836:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001838:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    8000183c:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001840:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001844:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001848:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    8000184c:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001850:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001854:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001858:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    8000185c:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001860:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001864:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001868:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    8000186a:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    8000186c:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001870:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001874:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001878:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    8000187c:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001880:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001884:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001888:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    8000188c:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001890:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001894:	8082                	ret

0000000080001896 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001896:	1141                	addi	sp,sp,-16
    80001898:	e406                	sd	ra,8(sp)
    8000189a:	e022                	sd	s0,0(sp)
    8000189c:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    8000189e:	00006597          	auipc	a1,0x6
    800018a2:	96258593          	addi	a1,a1,-1694 # 80007200 <etext+0x200>
    800018a6:	0000e517          	auipc	a0,0xe
    800018aa:	02a50513          	addi	a0,a0,42 # 8000f8d0 <tickslock>
    800018ae:	0c0040ef          	jal	8000596e <initlock>
}
    800018b2:	60a2                	ld	ra,8(sp)
    800018b4:	6402                	ld	s0,0(sp)
    800018b6:	0141                	addi	sp,sp,16
    800018b8:	8082                	ret

00000000800018ba <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    800018ba:	1141                	addi	sp,sp,-16
    800018bc:	e406                	sd	ra,8(sp)
    800018be:	e022                	sd	s0,0(sp)
    800018c0:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    800018c2:	00003797          	auipc	a5,0x3
    800018c6:	07e78793          	addi	a5,a5,126 # 80004940 <kernelvec>
    800018ca:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    800018ce:	60a2                	ld	ra,8(sp)
    800018d0:	6402                	ld	s0,0(sp)
    800018d2:	0141                	addi	sp,sp,16
    800018d4:	8082                	ret

00000000800018d6 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    800018d6:	1141                	addi	sp,sp,-16
    800018d8:	e406                	sd	ra,8(sp)
    800018da:	e022                	sd	s0,0(sp)
    800018dc:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    800018de:	ca0ff0ef          	jal	80000d7e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018e2:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018e6:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018e8:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    800018ec:	04000737          	lui	a4,0x4000
    800018f0:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800018f2:	0732                	slli	a4,a4,0xc
    800018f4:	00004797          	auipc	a5,0x4
    800018f8:	70c78793          	addi	a5,a5,1804 # 80006000 <_trampoline>
    800018fc:	00004697          	auipc	a3,0x4
    80001900:	70468693          	addi	a3,a3,1796 # 80006000 <_trampoline>
    80001904:	8f95                	sub	a5,a5,a3
    80001906:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001908:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    8000190c:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    8000190e:	18002773          	csrr	a4,satp
    80001912:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001914:	6d38                	ld	a4,88(a0)
    80001916:	613c                	ld	a5,64(a0)
    80001918:	6685                	lui	a3,0x1
    8000191a:	97b6                	add	a5,a5,a3
    8000191c:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    8000191e:	6d3c                	ld	a5,88(a0)
    80001920:	00000717          	auipc	a4,0x0
    80001924:	0fc70713          	addi	a4,a4,252 # 80001a1c <usertrap>
    80001928:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    8000192a:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    8000192c:	8712                	mv	a4,tp
    8000192e:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001930:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001934:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001938:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000193c:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001940:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001942:	6f9c                	ld	a5,24(a5)
    80001944:	14179073          	csrw	sepc,a5
}
    80001948:	60a2                	ld	ra,8(sp)
    8000194a:	6402                	ld	s0,0(sp)
    8000194c:	0141                	addi	sp,sp,16
    8000194e:	8082                	ret

0000000080001950 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001950:	1141                	addi	sp,sp,-16
    80001952:	e406                	sd	ra,8(sp)
    80001954:	e022                	sd	s0,0(sp)
    80001956:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001958:	bf2ff0ef          	jal	80000d4a <cpuid>
    8000195c:	cd11                	beqz	a0,80001978 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    8000195e:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001962:	000f4737          	lui	a4,0xf4
    80001966:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    8000196a:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000196c:	14d79073          	csrw	stimecmp,a5
}
    80001970:	60a2                	ld	ra,8(sp)
    80001972:	6402                	ld	s0,0(sp)
    80001974:	0141                	addi	sp,sp,16
    80001976:	8082                	ret
    acquire(&tickslock);
    80001978:	0000e517          	auipc	a0,0xe
    8000197c:	f5850513          	addi	a0,a0,-168 # 8000f8d0 <tickslock>
    80001980:	078040ef          	jal	800059f8 <acquire>
    ticks++;
    80001984:	00006717          	auipc	a4,0x6
    80001988:	ee470713          	addi	a4,a4,-284 # 80007868 <ticks>
    8000198c:	431c                	lw	a5,0(a4)
    8000198e:	2785                	addiw	a5,a5,1
    80001990:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001992:	853a                	mv	a0,a4
    80001994:	a53ff0ef          	jal	800013e6 <wakeup>
    release(&tickslock);
    80001998:	0000e517          	auipc	a0,0xe
    8000199c:	f3850513          	addi	a0,a0,-200 # 8000f8d0 <tickslock>
    800019a0:	0ec040ef          	jal	80005a8c <release>
    800019a4:	bf6d                	j	8000195e <clockintr+0xe>

00000000800019a6 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    800019a6:	1101                	addi	sp,sp,-32
    800019a8:	ec06                	sd	ra,24(sp)
    800019aa:	e822                	sd	s0,16(sp)
    800019ac:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    800019ae:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    800019b2:	57fd                	li	a5,-1
    800019b4:	17fe                	slli	a5,a5,0x3f
    800019b6:	07a5                	addi	a5,a5,9
    800019b8:	00f70c63          	beq	a4,a5,800019d0 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    800019bc:	57fd                	li	a5,-1
    800019be:	17fe                	slli	a5,a5,0x3f
    800019c0:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    800019c2:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    800019c4:	04f70863          	beq	a4,a5,80001a14 <devintr+0x6e>
  }
}
    800019c8:	60e2                	ld	ra,24(sp)
    800019ca:	6442                	ld	s0,16(sp)
    800019cc:	6105                	addi	sp,sp,32
    800019ce:	8082                	ret
    800019d0:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    800019d2:	01a030ef          	jal	800049ec <plic_claim>
    800019d6:	872a                	mv	a4,a0
    800019d8:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    800019da:	47a9                	li	a5,10
    800019dc:	00f50963          	beq	a0,a5,800019ee <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    800019e0:	4785                	li	a5,1
    800019e2:	00f50963          	beq	a0,a5,800019f4 <devintr+0x4e>
    return 1;
    800019e6:	4505                	li	a0,1
    } else if(irq){
    800019e8:	eb09                	bnez	a4,800019fa <devintr+0x54>
    800019ea:	64a2                	ld	s1,8(sp)
    800019ec:	bff1                	j	800019c8 <devintr+0x22>
      uartintr();
    800019ee:	719030ef          	jal	80005906 <uartintr>
    if(irq)
    800019f2:	a819                	j	80001a08 <devintr+0x62>
      virtio_disk_intr();
    800019f4:	48e030ef          	jal	80004e82 <virtio_disk_intr>
    if(irq)
    800019f8:	a801                	j	80001a08 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    800019fa:	85ba                	mv	a1,a4
    800019fc:	00006517          	auipc	a0,0x6
    80001a00:	80c50513          	addi	a0,a0,-2036 # 80007208 <etext+0x208>
    80001a04:	209030ef          	jal	8000540c <printf>
      plic_complete(irq);
    80001a08:	8526                	mv	a0,s1
    80001a0a:	002030ef          	jal	80004a0c <plic_complete>
    return 1;
    80001a0e:	4505                	li	a0,1
    80001a10:	64a2                	ld	s1,8(sp)
    80001a12:	bf5d                	j	800019c8 <devintr+0x22>
    clockintr();
    80001a14:	f3dff0ef          	jal	80001950 <clockintr>
    return 2;
    80001a18:	4509                	li	a0,2
    80001a1a:	b77d                	j	800019c8 <devintr+0x22>

0000000080001a1c <usertrap>:
{
    80001a1c:	1101                	addi	sp,sp,-32
    80001a1e:	ec06                	sd	ra,24(sp)
    80001a20:	e822                	sd	s0,16(sp)
    80001a22:	e426                	sd	s1,8(sp)
    80001a24:	e04a                	sd	s2,0(sp)
    80001a26:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001a28:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001a2c:	1007f793          	andi	a5,a5,256
    80001a30:	eba5                	bnez	a5,80001aa0 <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001a32:	00003797          	auipc	a5,0x3
    80001a36:	f0e78793          	addi	a5,a5,-242 # 80004940 <kernelvec>
    80001a3a:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001a3e:	b40ff0ef          	jal	80000d7e <myproc>
    80001a42:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001a44:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a46:	14102773          	csrr	a4,sepc
    80001a4a:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001a4c:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001a50:	47a1                	li	a5,8
    80001a52:	04f70d63          	beq	a4,a5,80001aac <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80001a56:	f51ff0ef          	jal	800019a6 <devintr>
    80001a5a:	892a                	mv	s2,a0
    80001a5c:	e945                	bnez	a0,80001b0c <usertrap+0xf0>
    80001a5e:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001a62:	47bd                	li	a5,15
    80001a64:	08f70863          	beq	a4,a5,80001af4 <usertrap+0xd8>
    80001a68:	14202773          	csrr	a4,scause
    80001a6c:	47b5                	li	a5,13
    80001a6e:	08f70363          	beq	a4,a5,80001af4 <usertrap+0xd8>
    80001a72:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001a76:	5890                	lw	a2,48(s1)
    80001a78:	00005517          	auipc	a0,0x5
    80001a7c:	7d050513          	addi	a0,a0,2000 # 80007248 <etext+0x248>
    80001a80:	18d030ef          	jal	8000540c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001a84:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001a88:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001a8c:	00005517          	auipc	a0,0x5
    80001a90:	7ec50513          	addi	a0,a0,2028 # 80007278 <etext+0x278>
    80001a94:	179030ef          	jal	8000540c <printf>
    setkilled(p);
    80001a98:	8526                	mv	a0,s1
    80001a9a:	b19ff0ef          	jal	800015b2 <setkilled>
    80001a9e:	a035                	j	80001aca <usertrap+0xae>
    panic("usertrap: not from user mode");
    80001aa0:	00005517          	auipc	a0,0x5
    80001aa4:	78850513          	addi	a0,a0,1928 # 80007228 <etext+0x228>
    80001aa8:	48f030ef          	jal	80005736 <panic>
    if(killed(p))
    80001aac:	b2bff0ef          	jal	800015d6 <killed>
    80001ab0:	ed15                	bnez	a0,80001aec <usertrap+0xd0>
    p->trapframe->epc += 4;
    80001ab2:	6cb8                	ld	a4,88(s1)
    80001ab4:	6f1c                	ld	a5,24(a4)
    80001ab6:	0791                	addi	a5,a5,4
    80001ab8:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001aba:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001abe:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ac2:	10079073          	csrw	sstatus,a5
    syscall();
    80001ac6:	240000ef          	jal	80001d06 <syscall>
  if(killed(p))
    80001aca:	8526                	mv	a0,s1
    80001acc:	b0bff0ef          	jal	800015d6 <killed>
    80001ad0:	e139                	bnez	a0,80001b16 <usertrap+0xfa>
  prepare_return();
    80001ad2:	e05ff0ef          	jal	800018d6 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001ad6:	68a8                	ld	a0,80(s1)
    80001ad8:	8131                	srli	a0,a0,0xc
    80001ada:	57fd                	li	a5,-1
    80001adc:	17fe                	slli	a5,a5,0x3f
    80001ade:	8d5d                	or	a0,a0,a5
}
    80001ae0:	60e2                	ld	ra,24(sp)
    80001ae2:	6442                	ld	s0,16(sp)
    80001ae4:	64a2                	ld	s1,8(sp)
    80001ae6:	6902                	ld	s2,0(sp)
    80001ae8:	6105                	addi	sp,sp,32
    80001aea:	8082                	ret
      kexit(-1);
    80001aec:	557d                	li	a0,-1
    80001aee:	9b9ff0ef          	jal	800014a6 <kexit>
    80001af2:	b7c1                	j	80001ab2 <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001af4:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001af8:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001afc:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001afe:	00163613          	seqz	a2,a2
    80001b02:	68a8                	ld	a0,80(s1)
    80001b04:	f27fe0ef          	jal	80000a2a <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001b08:	f169                	bnez	a0,80001aca <usertrap+0xae>
    80001b0a:	b7a5                	j	80001a72 <usertrap+0x56>
  if(killed(p))
    80001b0c:	8526                	mv	a0,s1
    80001b0e:	ac9ff0ef          	jal	800015d6 <killed>
    80001b12:	c511                	beqz	a0,80001b1e <usertrap+0x102>
    80001b14:	a011                	j	80001b18 <usertrap+0xfc>
    80001b16:	4901                	li	s2,0
    kexit(-1);
    80001b18:	557d                	li	a0,-1
    80001b1a:	98dff0ef          	jal	800014a6 <kexit>
  if(which_dev == 2)
    80001b1e:	4789                	li	a5,2
    80001b20:	faf919e3          	bne	s2,a5,80001ad2 <usertrap+0xb6>
    yield();
    80001b24:	84bff0ef          	jal	8000136e <yield>
    80001b28:	b76d                	j	80001ad2 <usertrap+0xb6>

0000000080001b2a <kerneltrap>:
{
    80001b2a:	7179                	addi	sp,sp,-48
    80001b2c:	f406                	sd	ra,40(sp)
    80001b2e:	f022                	sd	s0,32(sp)
    80001b30:	ec26                	sd	s1,24(sp)
    80001b32:	e84a                	sd	s2,16(sp)
    80001b34:	e44e                	sd	s3,8(sp)
    80001b36:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b38:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b3c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001b40:	142027f3          	csrr	a5,scause
    80001b44:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001b46:	1004f793          	andi	a5,s1,256
    80001b4a:	c795                	beqz	a5,80001b76 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b4c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001b50:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001b52:	eb85                	bnez	a5,80001b82 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001b54:	e53ff0ef          	jal	800019a6 <devintr>
    80001b58:	c91d                	beqz	a0,80001b8e <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001b5a:	4789                	li	a5,2
    80001b5c:	04f50a63          	beq	a0,a5,80001bb0 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b60:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b64:	10049073          	csrw	sstatus,s1
}
    80001b68:	70a2                	ld	ra,40(sp)
    80001b6a:	7402                	ld	s0,32(sp)
    80001b6c:	64e2                	ld	s1,24(sp)
    80001b6e:	6942                	ld	s2,16(sp)
    80001b70:	69a2                	ld	s3,8(sp)
    80001b72:	6145                	addi	sp,sp,48
    80001b74:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001b76:	00005517          	auipc	a0,0x5
    80001b7a:	72a50513          	addi	a0,a0,1834 # 800072a0 <etext+0x2a0>
    80001b7e:	3b9030ef          	jal	80005736 <panic>
    panic("kerneltrap: interrupts enabled");
    80001b82:	00005517          	auipc	a0,0x5
    80001b86:	74650513          	addi	a0,a0,1862 # 800072c8 <etext+0x2c8>
    80001b8a:	3ad030ef          	jal	80005736 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001b8e:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001b92:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001b96:	85ce                	mv	a1,s3
    80001b98:	00005517          	auipc	a0,0x5
    80001b9c:	75050513          	addi	a0,a0,1872 # 800072e8 <etext+0x2e8>
    80001ba0:	06d030ef          	jal	8000540c <printf>
    panic("kerneltrap");
    80001ba4:	00005517          	auipc	a0,0x5
    80001ba8:	76c50513          	addi	a0,a0,1900 # 80007310 <etext+0x310>
    80001bac:	38b030ef          	jal	80005736 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001bb0:	9ceff0ef          	jal	80000d7e <myproc>
    80001bb4:	d555                	beqz	a0,80001b60 <kerneltrap+0x36>
    yield();
    80001bb6:	fb8ff0ef          	jal	8000136e <yield>
    80001bba:	b75d                	j	80001b60 <kerneltrap+0x36>

0000000080001bbc <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001bbc:	1101                	addi	sp,sp,-32
    80001bbe:	ec06                	sd	ra,24(sp)
    80001bc0:	e822                	sd	s0,16(sp)
    80001bc2:	e426                	sd	s1,8(sp)
    80001bc4:	1000                	addi	s0,sp,32
    80001bc6:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001bc8:	9b6ff0ef          	jal	80000d7e <myproc>
  switch (n) {
    80001bcc:	4795                	li	a5,5
    80001bce:	0497e163          	bltu	a5,s1,80001c10 <argraw+0x54>
    80001bd2:	048a                	slli	s1,s1,0x2
    80001bd4:	00006717          	auipc	a4,0x6
    80001bd8:	b8470713          	addi	a4,a4,-1148 # 80007758 <states.0+0x30>
    80001bdc:	94ba                	add	s1,s1,a4
    80001bde:	409c                	lw	a5,0(s1)
    80001be0:	97ba                	add	a5,a5,a4
    80001be2:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001be4:	6d3c                	ld	a5,88(a0)
    80001be6:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001be8:	60e2                	ld	ra,24(sp)
    80001bea:	6442                	ld	s0,16(sp)
    80001bec:	64a2                	ld	s1,8(sp)
    80001bee:	6105                	addi	sp,sp,32
    80001bf0:	8082                	ret
    return p->trapframe->a1;
    80001bf2:	6d3c                	ld	a5,88(a0)
    80001bf4:	7fa8                	ld	a0,120(a5)
    80001bf6:	bfcd                	j	80001be8 <argraw+0x2c>
    return p->trapframe->a2;
    80001bf8:	6d3c                	ld	a5,88(a0)
    80001bfa:	63c8                	ld	a0,128(a5)
    80001bfc:	b7f5                	j	80001be8 <argraw+0x2c>
    return p->trapframe->a3;
    80001bfe:	6d3c                	ld	a5,88(a0)
    80001c00:	67c8                	ld	a0,136(a5)
    80001c02:	b7dd                	j	80001be8 <argraw+0x2c>
    return p->trapframe->a4;
    80001c04:	6d3c                	ld	a5,88(a0)
    80001c06:	6bc8                	ld	a0,144(a5)
    80001c08:	b7c5                	j	80001be8 <argraw+0x2c>
    return p->trapframe->a5;
    80001c0a:	6d3c                	ld	a5,88(a0)
    80001c0c:	6fc8                	ld	a0,152(a5)
    80001c0e:	bfe9                	j	80001be8 <argraw+0x2c>
  panic("argraw");
    80001c10:	00005517          	auipc	a0,0x5
    80001c14:	71050513          	addi	a0,a0,1808 # 80007320 <etext+0x320>
    80001c18:	31f030ef          	jal	80005736 <panic>

0000000080001c1c <fetchaddr>:
{
    80001c1c:	1101                	addi	sp,sp,-32
    80001c1e:	ec06                	sd	ra,24(sp)
    80001c20:	e822                	sd	s0,16(sp)
    80001c22:	e426                	sd	s1,8(sp)
    80001c24:	e04a                	sd	s2,0(sp)
    80001c26:	1000                	addi	s0,sp,32
    80001c28:	84aa                	mv	s1,a0
    80001c2a:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001c2c:	952ff0ef          	jal	80000d7e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001c30:	653c                	ld	a5,72(a0)
    80001c32:	02f4f663          	bgeu	s1,a5,80001c5e <fetchaddr+0x42>
    80001c36:	00848713          	addi	a4,s1,8
    80001c3a:	02e7e463          	bltu	a5,a4,80001c62 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001c3e:	46a1                	li	a3,8
    80001c40:	8626                	mv	a2,s1
    80001c42:	85ca                	mv	a1,s2
    80001c44:	6928                	ld	a0,80(a0)
    80001c46:	f2dfe0ef          	jal	80000b72 <copyin>
    80001c4a:	00a03533          	snez	a0,a0
    80001c4e:	40a0053b          	negw	a0,a0
}
    80001c52:	60e2                	ld	ra,24(sp)
    80001c54:	6442                	ld	s0,16(sp)
    80001c56:	64a2                	ld	s1,8(sp)
    80001c58:	6902                	ld	s2,0(sp)
    80001c5a:	6105                	addi	sp,sp,32
    80001c5c:	8082                	ret
    return -1;
    80001c5e:	557d                	li	a0,-1
    80001c60:	bfcd                	j	80001c52 <fetchaddr+0x36>
    80001c62:	557d                	li	a0,-1
    80001c64:	b7fd                	j	80001c52 <fetchaddr+0x36>

0000000080001c66 <fetchstr>:
{
    80001c66:	7179                	addi	sp,sp,-48
    80001c68:	f406                	sd	ra,40(sp)
    80001c6a:	f022                	sd	s0,32(sp)
    80001c6c:	ec26                	sd	s1,24(sp)
    80001c6e:	e84a                	sd	s2,16(sp)
    80001c70:	e44e                	sd	s3,8(sp)
    80001c72:	1800                	addi	s0,sp,48
    80001c74:	89aa                	mv	s3,a0
    80001c76:	84ae                	mv	s1,a1
    80001c78:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001c7a:	904ff0ef          	jal	80000d7e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001c7e:	86ca                	mv	a3,s2
    80001c80:	864e                	mv	a2,s3
    80001c82:	85a6                	mv	a1,s1
    80001c84:	6928                	ld	a0,80(a0)
    80001c86:	ccdfe0ef          	jal	80000952 <copyinstr>
    80001c8a:	00054c63          	bltz	a0,80001ca2 <fetchstr+0x3c>
  return strlen(buf);
    80001c8e:	8526                	mv	a0,s1
    80001c90:	e38fe0ef          	jal	800002c8 <strlen>
}
    80001c94:	70a2                	ld	ra,40(sp)
    80001c96:	7402                	ld	s0,32(sp)
    80001c98:	64e2                	ld	s1,24(sp)
    80001c9a:	6942                	ld	s2,16(sp)
    80001c9c:	69a2                	ld	s3,8(sp)
    80001c9e:	6145                	addi	sp,sp,48
    80001ca0:	8082                	ret
    return -1;
    80001ca2:	557d                	li	a0,-1
    80001ca4:	bfc5                	j	80001c94 <fetchstr+0x2e>

0000000080001ca6 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001ca6:	1101                	addi	sp,sp,-32
    80001ca8:	ec06                	sd	ra,24(sp)
    80001caa:	e822                	sd	s0,16(sp)
    80001cac:	e426                	sd	s1,8(sp)
    80001cae:	1000                	addi	s0,sp,32
    80001cb0:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cb2:	f0bff0ef          	jal	80001bbc <argraw>
    80001cb6:	c088                	sw	a0,0(s1)
}
    80001cb8:	60e2                	ld	ra,24(sp)
    80001cba:	6442                	ld	s0,16(sp)
    80001cbc:	64a2                	ld	s1,8(sp)
    80001cbe:	6105                	addi	sp,sp,32
    80001cc0:	8082                	ret

0000000080001cc2 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001cc2:	1101                	addi	sp,sp,-32
    80001cc4:	ec06                	sd	ra,24(sp)
    80001cc6:	e822                	sd	s0,16(sp)
    80001cc8:	e426                	sd	s1,8(sp)
    80001cca:	1000                	addi	s0,sp,32
    80001ccc:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001cce:	eefff0ef          	jal	80001bbc <argraw>
    80001cd2:	e088                	sd	a0,0(s1)
}
    80001cd4:	60e2                	ld	ra,24(sp)
    80001cd6:	6442                	ld	s0,16(sp)
    80001cd8:	64a2                	ld	s1,8(sp)
    80001cda:	6105                	addi	sp,sp,32
    80001cdc:	8082                	ret

0000000080001cde <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001cde:	1101                	addi	sp,sp,-32
    80001ce0:	ec06                	sd	ra,24(sp)
    80001ce2:	e822                	sd	s0,16(sp)
    80001ce4:	e426                	sd	s1,8(sp)
    80001ce6:	e04a                	sd	s2,0(sp)
    80001ce8:	1000                	addi	s0,sp,32
    80001cea:	892e                	mv	s2,a1
    80001cec:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001cee:	ecfff0ef          	jal	80001bbc <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001cf2:	8626                	mv	a2,s1
    80001cf4:	85ca                	mv	a1,s2
    80001cf6:	f71ff0ef          	jal	80001c66 <fetchstr>
}
    80001cfa:	60e2                	ld	ra,24(sp)
    80001cfc:	6442                	ld	s0,16(sp)
    80001cfe:	64a2                	ld	s1,8(sp)
    80001d00:	6902                	ld	s2,0(sp)
    80001d02:	6105                	addi	sp,sp,32
    80001d04:	8082                	ret

0000000080001d06 <syscall>:
[SYS_interpose]   sys_interpose,
};

void
syscall(void)
{
    80001d06:	7171                	addi	sp,sp,-176
    80001d08:	f506                	sd	ra,168(sp)
    80001d0a:	f122                	sd	s0,160(sp)
    80001d0c:	ed26                	sd	s1,152(sp)
    80001d0e:	e94a                	sd	s2,144(sp)
    80001d10:	1900                	addi	s0,sp,176
  int num;
  char path[MAXPATH];
  struct proc *p = myproc();
    80001d12:	86cff0ef          	jal	80000d7e <myproc>
    80001d16:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001d18:	05853903          	ld	s2,88(a0)
    80001d1c:	0a893783          	ld	a5,168(s2)
    80001d20:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001d24:	37fd                	addiw	a5,a5,-1
    80001d26:	4755                	li	a4,21
    80001d28:	0af76663          	bltu	a4,a5,80001dd4 <syscall+0xce>
    80001d2c:	e152                	sd	s4,128(sp)
    80001d2e:	00369713          	slli	a4,a3,0x3
    80001d32:	00006797          	auipc	a5,0x6
    80001d36:	a3e78793          	addi	a5,a5,-1474 # 80007770 <syscalls>
    80001d3a:	97ba                	add	a5,a5,a4
    80001d3c:	639c                	ld	a5,0(a5)
    80001d3e:	8a3e                	mv	s4,a5
    80001d40:	cbc9                	beqz	a5,80001dd2 <syscall+0xcc>
    // Check if the system call must be rejected
    if ((p->mask & (1 << num)) > 0) {
    80001d42:	4785                	li	a5,1
    80001d44:	00d797bb          	sllw	a5,a5,a3
    80001d48:	1e852703          	lw	a4,488(a0)
    80001d4c:	8ff9                	and	a5,a5,a4
    80001d4e:	06f05d63          	blez	a5,80001dc8 <syscall+0xc2>
      // Check if the pathname matches the allowed pathname
      if (num == SYS_open || num == SYS_exec) {
    80001d52:	9add                	andi	a3,a3,-9
    80001d54:	479d                	li	a5,7
    80001d56:	00f68763          	beq	a3,a5,80001d64 <syscall+0x5e>
          p->trapframe->a0 = syscalls[num]();
          return;
        }
      }
      // Reject the system call
      p->trapframe->a0 = -1;
    80001d5a:	6cbc                	ld	a5,88(s1)
    80001d5c:	577d                	li	a4,-1
    80001d5e:	fbb8                	sd	a4,112(a5)
      return;
    80001d60:	6a0a                	ld	s4,128(sp)
    80001d62:	a069                	j	80001dec <syscall+0xe6>
        if(argstr(0, path, MAXPATH) < 0) {
    80001d64:	08000613          	li	a2,128
    80001d68:	f5040593          	addi	a1,s0,-176
    80001d6c:	4501                	li	a0,0
    80001d6e:	f71ff0ef          	jal	80001cde <argstr>
    80001d72:	02054e63          	bltz	a0,80001dae <syscall+0xa8>
    80001d76:	e54e                	sd	s3,136(sp)
        int len = strlen(p->allowPath);
    80001d78:	16848913          	addi	s2,s1,360
    80001d7c:	854a                	mv	a0,s2
    80001d7e:	d4afe0ef          	jal	800002c8 <strlen>
    80001d82:	89aa                	mv	s3,a0
        if (strncmp(path, p->allowPath, len) == 0 && (path[len] == '/' || path[len] == '\0')) {
    80001d84:	862a                	mv	a2,a0
    80001d86:	85ca                	mv	a1,s2
    80001d88:	f5040513          	addi	a0,s0,-176
    80001d8c:	c86fe0ef          	jal	80000212 <strncmp>
    80001d90:	e915                	bnez	a0,80001dc4 <syscall+0xbe>
    80001d92:	fe098793          	addi	a5,s3,-32
    80001d96:	ff040713          	addi	a4,s0,-16
    80001d9a:	00e78933          	add	s2,a5,a4
    80001d9e:	f8094783          	lbu	a5,-128(s2)
    80001da2:	fd178713          	addi	a4,a5,-47
    80001da6:	cb09                	beqz	a4,80001db8 <syscall+0xb2>
    80001da8:	cb81                	beqz	a5,80001db8 <syscall+0xb2>
    80001daa:	69aa                	ld	s3,136(sp)
    80001dac:	b77d                	j	80001d5a <syscall+0x54>
          p->trapframe->a0 = -1;
    80001dae:	6cbc                	ld	a5,88(s1)
    80001db0:	577d                	li	a4,-1
    80001db2:	fbb8                	sd	a4,112(a5)
          return;
    80001db4:	6a0a                	ld	s4,128(sp)
    80001db6:	a81d                	j	80001dec <syscall+0xe6>
          p->trapframe->a0 = syscalls[num]();
    80001db8:	6ca4                	ld	s1,88(s1)
    80001dba:	9a02                	jalr	s4
    80001dbc:	f8a8                	sd	a0,112(s1)
          return;
    80001dbe:	69aa                	ld	s3,136(sp)
    80001dc0:	6a0a                	ld	s4,128(sp)
    80001dc2:	a02d                	j	80001dec <syscall+0xe6>
    80001dc4:	69aa                	ld	s3,136(sp)
    80001dc6:	bf51                	j	80001d5a <syscall+0x54>
    }
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001dc8:	9a02                	jalr	s4
    80001dca:	06a93823          	sd	a0,112(s2)
    80001dce:	6a0a                	ld	s4,128(sp)
    80001dd0:	a831                	j	80001dec <syscall+0xe6>
    80001dd2:	6a0a                	ld	s4,128(sp)
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001dd4:	15848613          	addi	a2,s1,344
    80001dd8:	588c                	lw	a1,48(s1)
    80001dda:	00005517          	auipc	a0,0x5
    80001dde:	54e50513          	addi	a0,a0,1358 # 80007328 <etext+0x328>
    80001de2:	62a030ef          	jal	8000540c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001de6:	6cbc                	ld	a5,88(s1)
    80001de8:	577d                	li	a4,-1
    80001dea:	fbb8                	sd	a4,112(a5)
  }
}
    80001dec:	70aa                	ld	ra,168(sp)
    80001dee:	740a                	ld	s0,160(sp)
    80001df0:	64ea                	ld	s1,152(sp)
    80001df2:	694a                	ld	s2,144(sp)
    80001df4:	614d                	addi	sp,sp,176
    80001df6:	8082                	ret

0000000080001df8 <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    80001df8:	1101                	addi	sp,sp,-32
    80001dfa:	ec06                	sd	ra,24(sp)
    80001dfc:	e822                	sd	s0,16(sp)
    80001dfe:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80001e00:	fec40593          	addi	a1,s0,-20
    80001e04:	4501                	li	a0,0
    80001e06:	ea1ff0ef          	jal	80001ca6 <argint>
  kexit(n);
    80001e0a:	fec42503          	lw	a0,-20(s0)
    80001e0e:	e98ff0ef          	jal	800014a6 <kexit>
  return 0;  // not reached
}
    80001e12:	4501                	li	a0,0
    80001e14:	60e2                	ld	ra,24(sp)
    80001e16:	6442                	ld	s0,16(sp)
    80001e18:	6105                	addi	sp,sp,32
    80001e1a:	8082                	ret

0000000080001e1c <sys_getpid>:

uint64
sys_getpid(void)
{
    80001e1c:	1141                	addi	sp,sp,-16
    80001e1e:	e406                	sd	ra,8(sp)
    80001e20:	e022                	sd	s0,0(sp)
    80001e22:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80001e24:	f5bfe0ef          	jal	80000d7e <myproc>
}
    80001e28:	5908                	lw	a0,48(a0)
    80001e2a:	60a2                	ld	ra,8(sp)
    80001e2c:	6402                	ld	s0,0(sp)
    80001e2e:	0141                	addi	sp,sp,16
    80001e30:	8082                	ret

0000000080001e32 <sys_fork>:

uint64
sys_fork(void)
{
    80001e32:	1141                	addi	sp,sp,-16
    80001e34:	e406                	sd	ra,8(sp)
    80001e36:	e022                	sd	s0,0(sp)
    80001e38:	0800                	addi	s0,sp,16
  return kfork();
    80001e3a:	a9aff0ef          	jal	800010d4 <kfork>
}
    80001e3e:	60a2                	ld	ra,8(sp)
    80001e40:	6402                	ld	s0,0(sp)
    80001e42:	0141                	addi	sp,sp,16
    80001e44:	8082                	ret

0000000080001e46 <sys_wait>:

uint64
sys_wait(void)
{
    80001e46:	1101                	addi	sp,sp,-32
    80001e48:	ec06                	sd	ra,24(sp)
    80001e4a:	e822                	sd	s0,16(sp)
    80001e4c:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80001e4e:	fe840593          	addi	a1,s0,-24
    80001e52:	4501                	li	a0,0
    80001e54:	e6fff0ef          	jal	80001cc2 <argaddr>
  return kwait(p);
    80001e58:	fe843503          	ld	a0,-24(s0)
    80001e5c:	fa4ff0ef          	jal	80001600 <kwait>
}
    80001e60:	60e2                	ld	ra,24(sp)
    80001e62:	6442                	ld	s0,16(sp)
    80001e64:	6105                	addi	sp,sp,32
    80001e66:	8082                	ret

0000000080001e68 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80001e68:	7179                	addi	sp,sp,-48
    80001e6a:	f406                	sd	ra,40(sp)
    80001e6c:	f022                	sd	s0,32(sp)
    80001e6e:	ec26                	sd	s1,24(sp)
    80001e70:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80001e72:	fd840593          	addi	a1,s0,-40
    80001e76:	4501                	li	a0,0
    80001e78:	e2fff0ef          	jal	80001ca6 <argint>
  argint(1, &t);
    80001e7c:	fdc40593          	addi	a1,s0,-36
    80001e80:	4505                	li	a0,1
    80001e82:	e25ff0ef          	jal	80001ca6 <argint>
  addr = myproc()->sz;
    80001e86:	ef9fe0ef          	jal	80000d7e <myproc>
    80001e8a:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    80001e8c:	fdc42703          	lw	a4,-36(s0)
    80001e90:	4785                	li	a5,1
    80001e92:	02f70163          	beq	a4,a5,80001eb4 <sys_sbrk+0x4c>
    80001e96:	fd842783          	lw	a5,-40(s0)
    80001e9a:	0007cd63          	bltz	a5,80001eb4 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    80001e9e:	97a6                	add	a5,a5,s1
    80001ea0:	0297e863          	bltu	a5,s1,80001ed0 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80001ea4:	edbfe0ef          	jal	80000d7e <myproc>
    80001ea8:	fd842703          	lw	a4,-40(s0)
    80001eac:	653c                	ld	a5,72(a0)
    80001eae:	97ba                	add	a5,a5,a4
    80001eb0:	e53c                	sd	a5,72(a0)
    80001eb2:	a039                	j	80001ec0 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80001eb4:	fd842503          	lw	a0,-40(s0)
    80001eb8:	9ccff0ef          	jal	80001084 <growproc>
    80001ebc:	00054863          	bltz	a0,80001ecc <sys_sbrk+0x64>
  }
  return addr;
}
    80001ec0:	8526                	mv	a0,s1
    80001ec2:	70a2                	ld	ra,40(sp)
    80001ec4:	7402                	ld	s0,32(sp)
    80001ec6:	64e2                	ld	s1,24(sp)
    80001ec8:	6145                	addi	sp,sp,48
    80001eca:	8082                	ret
      return -1;
    80001ecc:	54fd                	li	s1,-1
    80001ece:	bfcd                	j	80001ec0 <sys_sbrk+0x58>
      return -1;
    80001ed0:	54fd                	li	s1,-1
    80001ed2:	b7fd                	j	80001ec0 <sys_sbrk+0x58>

0000000080001ed4 <sys_pause>:

uint64
sys_pause(void)
{
    80001ed4:	7139                	addi	sp,sp,-64
    80001ed6:	fc06                	sd	ra,56(sp)
    80001ed8:	f822                	sd	s0,48(sp)
    80001eda:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80001edc:	fcc40593          	addi	a1,s0,-52
    80001ee0:	4501                	li	a0,0
    80001ee2:	dc5ff0ef          	jal	80001ca6 <argint>
  if(n < 0)
    80001ee6:	fcc42783          	lw	a5,-52(s0)
    80001eea:	0607c863          	bltz	a5,80001f5a <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80001eee:	0000e517          	auipc	a0,0xe
    80001ef2:	9e250513          	addi	a0,a0,-1566 # 8000f8d0 <tickslock>
    80001ef6:	303030ef          	jal	800059f8 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80001efa:	fcc42783          	lw	a5,-52(s0)
    80001efe:	c3b9                	beqz	a5,80001f44 <sys_pause+0x70>
    80001f00:	f426                	sd	s1,40(sp)
    80001f02:	f04a                	sd	s2,32(sp)
    80001f04:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80001f06:	00006997          	auipc	s3,0x6
    80001f0a:	9629a983          	lw	s3,-1694(s3) # 80007868 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80001f0e:	0000e917          	auipc	s2,0xe
    80001f12:	9c290913          	addi	s2,s2,-1598 # 8000f8d0 <tickslock>
    80001f16:	00006497          	auipc	s1,0x6
    80001f1a:	95248493          	addi	s1,s1,-1710 # 80007868 <ticks>
    if(killed(myproc())){
    80001f1e:	e61fe0ef          	jal	80000d7e <myproc>
    80001f22:	eb4ff0ef          	jal	800015d6 <killed>
    80001f26:	ed0d                	bnez	a0,80001f60 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    80001f28:	85ca                	mv	a1,s2
    80001f2a:	8526                	mv	a0,s1
    80001f2c:	c6eff0ef          	jal	8000139a <sleep>
  while(ticks - ticks0 < n){
    80001f30:	409c                	lw	a5,0(s1)
    80001f32:	413787bb          	subw	a5,a5,s3
    80001f36:	fcc42703          	lw	a4,-52(s0)
    80001f3a:	fee7e2e3          	bltu	a5,a4,80001f1e <sys_pause+0x4a>
    80001f3e:	74a2                	ld	s1,40(sp)
    80001f40:	7902                	ld	s2,32(sp)
    80001f42:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80001f44:	0000e517          	auipc	a0,0xe
    80001f48:	98c50513          	addi	a0,a0,-1652 # 8000f8d0 <tickslock>
    80001f4c:	341030ef          	jal	80005a8c <release>
  return 0;
    80001f50:	4501                	li	a0,0
}
    80001f52:	70e2                	ld	ra,56(sp)
    80001f54:	7442                	ld	s0,48(sp)
    80001f56:	6121                	addi	sp,sp,64
    80001f58:	8082                	ret
    n = 0;
    80001f5a:	fc042623          	sw	zero,-52(s0)
    80001f5e:	bf41                	j	80001eee <sys_pause+0x1a>
      release(&tickslock);
    80001f60:	0000e517          	auipc	a0,0xe
    80001f64:	97050513          	addi	a0,a0,-1680 # 8000f8d0 <tickslock>
    80001f68:	325030ef          	jal	80005a8c <release>
      return -1;
    80001f6c:	557d                	li	a0,-1
    80001f6e:	74a2                	ld	s1,40(sp)
    80001f70:	7902                	ld	s2,32(sp)
    80001f72:	69e2                	ld	s3,24(sp)
    80001f74:	bff9                	j	80001f52 <sys_pause+0x7e>

0000000080001f76 <sys_kill>:

uint64
sys_kill(void)
{
    80001f76:	1101                	addi	sp,sp,-32
    80001f78:	ec06                	sd	ra,24(sp)
    80001f7a:	e822                	sd	s0,16(sp)
    80001f7c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80001f7e:	fec40593          	addi	a1,s0,-20
    80001f82:	4501                	li	a0,0
    80001f84:	d23ff0ef          	jal	80001ca6 <argint>
  return kkill(pid);
    80001f88:	fec42503          	lw	a0,-20(s0)
    80001f8c:	dc0ff0ef          	jal	8000154c <kkill>
}
    80001f90:	60e2                	ld	ra,24(sp)
    80001f92:	6442                	ld	s0,16(sp)
    80001f94:	6105                	addi	sp,sp,32
    80001f96:	8082                	ret

0000000080001f98 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80001f98:	1101                	addi	sp,sp,-32
    80001f9a:	ec06                	sd	ra,24(sp)
    80001f9c:	e822                	sd	s0,16(sp)
    80001f9e:	e426                	sd	s1,8(sp)
    80001fa0:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80001fa2:	0000e517          	auipc	a0,0xe
    80001fa6:	92e50513          	addi	a0,a0,-1746 # 8000f8d0 <tickslock>
    80001faa:	24f030ef          	jal	800059f8 <acquire>
  xticks = ticks;
    80001fae:	00006797          	auipc	a5,0x6
    80001fb2:	8ba7a783          	lw	a5,-1862(a5) # 80007868 <ticks>
    80001fb6:	84be                	mv	s1,a5
  release(&tickslock);
    80001fb8:	0000e517          	auipc	a0,0xe
    80001fbc:	91850513          	addi	a0,a0,-1768 # 8000f8d0 <tickslock>
    80001fc0:	2cd030ef          	jal	80005a8c <release>
  return xticks;
}
    80001fc4:	02049513          	slli	a0,s1,0x20
    80001fc8:	9101                	srli	a0,a0,0x20
    80001fca:	60e2                	ld	ra,24(sp)
    80001fcc:	6442                	ld	s0,16(sp)
    80001fce:	64a2                	ld	s1,8(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret

0000000080001fd4 <sys_interpose>:
// Arguments: an integer mask and a path.
// The mask's bits specify which system calls to reject.
// The second argument of sys_interpose is the pathname allowed.
uint64
sys_interpose(void)
{
    80001fd4:	7171                	addi	sp,sp,-176
    80001fd6:	f506                	sd	ra,168(sp)
    80001fd8:	f122                	sd	s0,160(sp)
    80001fda:	1900                	addi	s0,sp,176
  int mask;
  char path[MAXPATH];

  argint(0, &mask);
    80001fdc:	fdc40593          	addi	a1,s0,-36
    80001fe0:	4501                	li	a0,0
    80001fe2:	cc5ff0ef          	jal	80001ca6 <argint>

  if (argstr(1, path, MAXPATH) < 0) {
    80001fe6:	08000613          	li	a2,128
    80001fea:	f5840593          	addi	a1,s0,-168
    80001fee:	4505                	li	a0,1
    80001ff0:	cefff0ef          	jal	80001cde <argstr>
    return -1;
    80001ff4:	57fd                	li	a5,-1
  if (argstr(1, path, MAXPATH) < 0) {
    80001ff6:	02054d63          	bltz	a0,80002030 <sys_interpose+0x5c>
    80001ffa:	ed26                	sd	s1,152(sp)
  }

  struct proc *p = myproc();
    80001ffc:	d83fe0ef          	jal	80000d7e <myproc>

  // record the mask and allow path arguments
  p->mask = mask;
    80002000:	fdc42783          	lw	a5,-36(s0)
    80002004:	1ef52423          	sw	a5,488(a0)
  memset(p->allowPath, '\0', MAXPATH);
    80002008:	16850493          	addi	s1,a0,360
    8000200c:	08000613          	li	a2,128
    80002010:	4581                	li	a1,0
    80002012:	8526                	mv	a0,s1
    80002014:	92afe0ef          	jal	8000013e <memset>
  strncpy(p->allowPath, path, strlen(path));
    80002018:	f5840513          	addi	a0,s0,-168
    8000201c:	aacfe0ef          	jal	800002c8 <strlen>
    80002020:	862a                	mv	a2,a0
    80002022:	f5840593          	addi	a1,s0,-168
    80002026:	8526                	mv	a0,s1
    80002028:	a24fe0ef          	jal	8000024c <strncpy>

  return 0;
    8000202c:	4781                	li	a5,0
    8000202e:	64ea                	ld	s1,152(sp)
}
    80002030:	853e                	mv	a0,a5
    80002032:	70aa                	ld	ra,168(sp)
    80002034:	740a                	ld	s0,160(sp)
    80002036:	614d                	addi	sp,sp,176
    80002038:	8082                	ret

000000008000203a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000203a:	7179                	addi	sp,sp,-48
    8000203c:	f406                	sd	ra,40(sp)
    8000203e:	f022                	sd	s0,32(sp)
    80002040:	ec26                	sd	s1,24(sp)
    80002042:	e84a                	sd	s2,16(sp)
    80002044:	e44e                	sd	s3,8(sp)
    80002046:	e052                	sd	s4,0(sp)
    80002048:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000204a:	00005597          	auipc	a1,0x5
    8000204e:	2fe58593          	addi	a1,a1,766 # 80007348 <etext+0x348>
    80002052:	0000e517          	auipc	a0,0xe
    80002056:	89650513          	addi	a0,a0,-1898 # 8000f8e8 <bcache>
    8000205a:	115030ef          	jal	8000596e <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000205e:	00016797          	auipc	a5,0x16
    80002062:	88a78793          	addi	a5,a5,-1910 # 800178e8 <bcache+0x8000>
    80002066:	00016717          	auipc	a4,0x16
    8000206a:	aea70713          	addi	a4,a4,-1302 # 80017b50 <bcache+0x8268>
    8000206e:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002072:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002076:	0000e497          	auipc	s1,0xe
    8000207a:	88a48493          	addi	s1,s1,-1910 # 8000f900 <bcache+0x18>
    b->next = bcache.head.next;
    8000207e:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002080:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002082:	00005a17          	auipc	s4,0x5
    80002086:	2cea0a13          	addi	s4,s4,718 # 80007350 <etext+0x350>
    b->next = bcache.head.next;
    8000208a:	2b893783          	ld	a5,696(s2)
    8000208e:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002090:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002094:	85d2                	mv	a1,s4
    80002096:	01048513          	addi	a0,s1,16
    8000209a:	328010ef          	jal	800033c2 <initsleeplock>
    bcache.head.next->prev = b;
    8000209e:	2b893783          	ld	a5,696(s2)
    800020a2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800020a4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800020a8:	45848493          	addi	s1,s1,1112
    800020ac:	fd349fe3          	bne	s1,s3,8000208a <binit+0x50>
  }
}
    800020b0:	70a2                	ld	ra,40(sp)
    800020b2:	7402                	ld	s0,32(sp)
    800020b4:	64e2                	ld	s1,24(sp)
    800020b6:	6942                	ld	s2,16(sp)
    800020b8:	69a2                	ld	s3,8(sp)
    800020ba:	6a02                	ld	s4,0(sp)
    800020bc:	6145                	addi	sp,sp,48
    800020be:	8082                	ret

00000000800020c0 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800020c0:	7179                	addi	sp,sp,-48
    800020c2:	f406                	sd	ra,40(sp)
    800020c4:	f022                	sd	s0,32(sp)
    800020c6:	ec26                	sd	s1,24(sp)
    800020c8:	e84a                	sd	s2,16(sp)
    800020ca:	e44e                	sd	s3,8(sp)
    800020cc:	1800                	addi	s0,sp,48
    800020ce:	892a                	mv	s2,a0
    800020d0:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    800020d2:	0000e517          	auipc	a0,0xe
    800020d6:	81650513          	addi	a0,a0,-2026 # 8000f8e8 <bcache>
    800020da:	11f030ef          	jal	800059f8 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800020de:	00016497          	auipc	s1,0x16
    800020e2:	ac24b483          	ld	s1,-1342(s1) # 80017ba0 <bcache+0x82b8>
    800020e6:	00016797          	auipc	a5,0x16
    800020ea:	a6a78793          	addi	a5,a5,-1430 # 80017b50 <bcache+0x8268>
    800020ee:	02f48b63          	beq	s1,a5,80002124 <bread+0x64>
    800020f2:	873e                	mv	a4,a5
    800020f4:	a021                	j	800020fc <bread+0x3c>
    800020f6:	68a4                	ld	s1,80(s1)
    800020f8:	02e48663          	beq	s1,a4,80002124 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800020fc:	449c                	lw	a5,8(s1)
    800020fe:	ff279ce3          	bne	a5,s2,800020f6 <bread+0x36>
    80002102:	44dc                	lw	a5,12(s1)
    80002104:	ff3799e3          	bne	a5,s3,800020f6 <bread+0x36>
      b->refcnt++;
    80002108:	40bc                	lw	a5,64(s1)
    8000210a:	2785                	addiw	a5,a5,1
    8000210c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000210e:	0000d517          	auipc	a0,0xd
    80002112:	7da50513          	addi	a0,a0,2010 # 8000f8e8 <bcache>
    80002116:	177030ef          	jal	80005a8c <release>
      acquiresleep(&b->lock);
    8000211a:	01048513          	addi	a0,s1,16
    8000211e:	2da010ef          	jal	800033f8 <acquiresleep>
      return b;
    80002122:	a889                	j	80002174 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002124:	00016497          	auipc	s1,0x16
    80002128:	a744b483          	ld	s1,-1420(s1) # 80017b98 <bcache+0x82b0>
    8000212c:	00016797          	auipc	a5,0x16
    80002130:	a2478793          	addi	a5,a5,-1500 # 80017b50 <bcache+0x8268>
    80002134:	00f48863          	beq	s1,a5,80002144 <bread+0x84>
    80002138:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000213a:	40bc                	lw	a5,64(s1)
    8000213c:	cb91                	beqz	a5,80002150 <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000213e:	64a4                	ld	s1,72(s1)
    80002140:	fee49de3          	bne	s1,a4,8000213a <bread+0x7a>
  panic("bget: no buffers");
    80002144:	00005517          	auipc	a0,0x5
    80002148:	21450513          	addi	a0,a0,532 # 80007358 <etext+0x358>
    8000214c:	5ea030ef          	jal	80005736 <panic>
      b->dev = dev;
    80002150:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002154:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002158:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000215c:	4785                	li	a5,1
    8000215e:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002160:	0000d517          	auipc	a0,0xd
    80002164:	78850513          	addi	a0,a0,1928 # 8000f8e8 <bcache>
    80002168:	125030ef          	jal	80005a8c <release>
      acquiresleep(&b->lock);
    8000216c:	01048513          	addi	a0,s1,16
    80002170:	288010ef          	jal	800033f8 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002174:	409c                	lw	a5,0(s1)
    80002176:	cb89                	beqz	a5,80002188 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002178:	8526                	mv	a0,s1
    8000217a:	70a2                	ld	ra,40(sp)
    8000217c:	7402                	ld	s0,32(sp)
    8000217e:	64e2                	ld	s1,24(sp)
    80002180:	6942                	ld	s2,16(sp)
    80002182:	69a2                	ld	s3,8(sp)
    80002184:	6145                	addi	sp,sp,48
    80002186:	8082                	ret
    virtio_disk_rw(b, 0);
    80002188:	4581                	li	a1,0
    8000218a:	8526                	mv	a0,s1
    8000218c:	2e5020ef          	jal	80004c70 <virtio_disk_rw>
    b->valid = 1;
    80002190:	4785                	li	a5,1
    80002192:	c09c                	sw	a5,0(s1)
  return b;
    80002194:	b7d5                	j	80002178 <bread+0xb8>

0000000080002196 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002196:	1101                	addi	sp,sp,-32
    80002198:	ec06                	sd	ra,24(sp)
    8000219a:	e822                	sd	s0,16(sp)
    8000219c:	e426                	sd	s1,8(sp)
    8000219e:	1000                	addi	s0,sp,32
    800021a0:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021a2:	0541                	addi	a0,a0,16
    800021a4:	2d2010ef          	jal	80003476 <holdingsleep>
    800021a8:	c911                	beqz	a0,800021bc <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800021aa:	4585                	li	a1,1
    800021ac:	8526                	mv	a0,s1
    800021ae:	2c3020ef          	jal	80004c70 <virtio_disk_rw>
}
    800021b2:	60e2                	ld	ra,24(sp)
    800021b4:	6442                	ld	s0,16(sp)
    800021b6:	64a2                	ld	s1,8(sp)
    800021b8:	6105                	addi	sp,sp,32
    800021ba:	8082                	ret
    panic("bwrite");
    800021bc:	00005517          	auipc	a0,0x5
    800021c0:	1b450513          	addi	a0,a0,436 # 80007370 <etext+0x370>
    800021c4:	572030ef          	jal	80005736 <panic>

00000000800021c8 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800021c8:	1101                	addi	sp,sp,-32
    800021ca:	ec06                	sd	ra,24(sp)
    800021cc:	e822                	sd	s0,16(sp)
    800021ce:	e426                	sd	s1,8(sp)
    800021d0:	e04a                	sd	s2,0(sp)
    800021d2:	1000                	addi	s0,sp,32
    800021d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800021d6:	01050913          	addi	s2,a0,16
    800021da:	854a                	mv	a0,s2
    800021dc:	29a010ef          	jal	80003476 <holdingsleep>
    800021e0:	c125                	beqz	a0,80002240 <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    800021e2:	854a                	mv	a0,s2
    800021e4:	25a010ef          	jal	8000343e <releasesleep>

  acquire(&bcache.lock);
    800021e8:	0000d517          	auipc	a0,0xd
    800021ec:	70050513          	addi	a0,a0,1792 # 8000f8e8 <bcache>
    800021f0:	009030ef          	jal	800059f8 <acquire>
  b->refcnt--;
    800021f4:	40bc                	lw	a5,64(s1)
    800021f6:	37fd                	addiw	a5,a5,-1
    800021f8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800021fa:	e79d                	bnez	a5,80002228 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800021fc:	68b8                	ld	a4,80(s1)
    800021fe:	64bc                	ld	a5,72(s1)
    80002200:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    80002202:	68b8                	ld	a4,80(s1)
    80002204:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002206:	00015797          	auipc	a5,0x15
    8000220a:	6e278793          	addi	a5,a5,1762 # 800178e8 <bcache+0x8000>
    8000220e:	2b87b703          	ld	a4,696(a5)
    80002212:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002214:	00016717          	auipc	a4,0x16
    80002218:	93c70713          	addi	a4,a4,-1732 # 80017b50 <bcache+0x8268>
    8000221c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000221e:	2b87b703          	ld	a4,696(a5)
    80002222:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002224:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002228:	0000d517          	auipc	a0,0xd
    8000222c:	6c050513          	addi	a0,a0,1728 # 8000f8e8 <bcache>
    80002230:	05d030ef          	jal	80005a8c <release>
}
    80002234:	60e2                	ld	ra,24(sp)
    80002236:	6442                	ld	s0,16(sp)
    80002238:	64a2                	ld	s1,8(sp)
    8000223a:	6902                	ld	s2,0(sp)
    8000223c:	6105                	addi	sp,sp,32
    8000223e:	8082                	ret
    panic("brelse");
    80002240:	00005517          	auipc	a0,0x5
    80002244:	13850513          	addi	a0,a0,312 # 80007378 <etext+0x378>
    80002248:	4ee030ef          	jal	80005736 <panic>

000000008000224c <bpin>:

void
bpin(struct buf *b) {
    8000224c:	1101                	addi	sp,sp,-32
    8000224e:	ec06                	sd	ra,24(sp)
    80002250:	e822                	sd	s0,16(sp)
    80002252:	e426                	sd	s1,8(sp)
    80002254:	1000                	addi	s0,sp,32
    80002256:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002258:	0000d517          	auipc	a0,0xd
    8000225c:	69050513          	addi	a0,a0,1680 # 8000f8e8 <bcache>
    80002260:	798030ef          	jal	800059f8 <acquire>
  b->refcnt++;
    80002264:	40bc                	lw	a5,64(s1)
    80002266:	2785                	addiw	a5,a5,1
    80002268:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000226a:	0000d517          	auipc	a0,0xd
    8000226e:	67e50513          	addi	a0,a0,1662 # 8000f8e8 <bcache>
    80002272:	01b030ef          	jal	80005a8c <release>
}
    80002276:	60e2                	ld	ra,24(sp)
    80002278:	6442                	ld	s0,16(sp)
    8000227a:	64a2                	ld	s1,8(sp)
    8000227c:	6105                	addi	sp,sp,32
    8000227e:	8082                	ret

0000000080002280 <bunpin>:

void
bunpin(struct buf *b) {
    80002280:	1101                	addi	sp,sp,-32
    80002282:	ec06                	sd	ra,24(sp)
    80002284:	e822                	sd	s0,16(sp)
    80002286:	e426                	sd	s1,8(sp)
    80002288:	1000                	addi	s0,sp,32
    8000228a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000228c:	0000d517          	auipc	a0,0xd
    80002290:	65c50513          	addi	a0,a0,1628 # 8000f8e8 <bcache>
    80002294:	764030ef          	jal	800059f8 <acquire>
  b->refcnt--;
    80002298:	40bc                	lw	a5,64(s1)
    8000229a:	37fd                	addiw	a5,a5,-1
    8000229c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000229e:	0000d517          	auipc	a0,0xd
    800022a2:	64a50513          	addi	a0,a0,1610 # 8000f8e8 <bcache>
    800022a6:	7e6030ef          	jal	80005a8c <release>
}
    800022aa:	60e2                	ld	ra,24(sp)
    800022ac:	6442                	ld	s0,16(sp)
    800022ae:	64a2                	ld	s1,8(sp)
    800022b0:	6105                	addi	sp,sp,32
    800022b2:	8082                	ret

00000000800022b4 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    800022b4:	1101                	addi	sp,sp,-32
    800022b6:	ec06                	sd	ra,24(sp)
    800022b8:	e822                	sd	s0,16(sp)
    800022ba:	e426                	sd	s1,8(sp)
    800022bc:	e04a                	sd	s2,0(sp)
    800022be:	1000                	addi	s0,sp,32
    800022c0:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    800022c2:	00d5d79b          	srliw	a5,a1,0xd
    800022c6:	00016597          	auipc	a1,0x16
    800022ca:	cfe5a583          	lw	a1,-770(a1) # 80017fc4 <sb+0x1c>
    800022ce:	9dbd                	addw	a1,a1,a5
    800022d0:	df1ff0ef          	jal	800020c0 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    800022d4:	0074f713          	andi	a4,s1,7
    800022d8:	4785                	li	a5,1
    800022da:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    800022de:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    800022e0:	90d9                	srli	s1,s1,0x36
    800022e2:	00950733          	add	a4,a0,s1
    800022e6:	05874703          	lbu	a4,88(a4)
    800022ea:	00e7f6b3          	and	a3,a5,a4
    800022ee:	c29d                	beqz	a3,80002314 <bfree+0x60>
    800022f0:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800022f2:	94aa                	add	s1,s1,a0
    800022f4:	fff7c793          	not	a5,a5
    800022f8:	8f7d                	and	a4,a4,a5
    800022fa:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800022fe:	000010ef          	jal	800032fe <log_write>
  brelse(bp);
    80002302:	854a                	mv	a0,s2
    80002304:	ec5ff0ef          	jal	800021c8 <brelse>
}
    80002308:	60e2                	ld	ra,24(sp)
    8000230a:	6442                	ld	s0,16(sp)
    8000230c:	64a2                	ld	s1,8(sp)
    8000230e:	6902                	ld	s2,0(sp)
    80002310:	6105                	addi	sp,sp,32
    80002312:	8082                	ret
    panic("freeing free block");
    80002314:	00005517          	auipc	a0,0x5
    80002318:	06c50513          	addi	a0,a0,108 # 80007380 <etext+0x380>
    8000231c:	41a030ef          	jal	80005736 <panic>

0000000080002320 <balloc>:
{
    80002320:	715d                	addi	sp,sp,-80
    80002322:	e486                	sd	ra,72(sp)
    80002324:	e0a2                	sd	s0,64(sp)
    80002326:	fc26                	sd	s1,56(sp)
    80002328:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    8000232a:	00016797          	auipc	a5,0x16
    8000232e:	c827a783          	lw	a5,-894(a5) # 80017fac <sb+0x4>
    80002332:	0e078263          	beqz	a5,80002416 <balloc+0xf6>
    80002336:	f84a                	sd	s2,48(sp)
    80002338:	f44e                	sd	s3,40(sp)
    8000233a:	f052                	sd	s4,32(sp)
    8000233c:	ec56                	sd	s5,24(sp)
    8000233e:	e85a                	sd	s6,16(sp)
    80002340:	e45e                	sd	s7,8(sp)
    80002342:	e062                	sd	s8,0(sp)
    80002344:	8baa                	mv	s7,a0
    80002346:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    80002348:	00016b17          	auipc	s6,0x16
    8000234c:	c60b0b13          	addi	s6,s6,-928 # 80017fa8 <sb>
      m = 1 << (bi % 8);
    80002350:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002352:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002354:	6c09                	lui	s8,0x2
    80002356:	a09d                	j	800023bc <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002358:	97ca                	add	a5,a5,s2
    8000235a:	8e55                	or	a2,a2,a3
    8000235c:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    80002360:	854a                	mv	a0,s2
    80002362:	79d000ef          	jal	800032fe <log_write>
        brelse(bp);
    80002366:	854a                	mv	a0,s2
    80002368:	e61ff0ef          	jal	800021c8 <brelse>
  bp = bread(dev, bno);
    8000236c:	85a6                	mv	a1,s1
    8000236e:	855e                	mv	a0,s7
    80002370:	d51ff0ef          	jal	800020c0 <bread>
    80002374:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002376:	40000613          	li	a2,1024
    8000237a:	4581                	li	a1,0
    8000237c:	05850513          	addi	a0,a0,88
    80002380:	dbffd0ef          	jal	8000013e <memset>
  log_write(bp);
    80002384:	854a                	mv	a0,s2
    80002386:	779000ef          	jal	800032fe <log_write>
  brelse(bp);
    8000238a:	854a                	mv	a0,s2
    8000238c:	e3dff0ef          	jal	800021c8 <brelse>
}
    80002390:	7942                	ld	s2,48(sp)
    80002392:	79a2                	ld	s3,40(sp)
    80002394:	7a02                	ld	s4,32(sp)
    80002396:	6ae2                	ld	s5,24(sp)
    80002398:	6b42                	ld	s6,16(sp)
    8000239a:	6ba2                	ld	s7,8(sp)
    8000239c:	6c02                	ld	s8,0(sp)
}
    8000239e:	8526                	mv	a0,s1
    800023a0:	60a6                	ld	ra,72(sp)
    800023a2:	6406                	ld	s0,64(sp)
    800023a4:	74e2                	ld	s1,56(sp)
    800023a6:	6161                	addi	sp,sp,80
    800023a8:	8082                	ret
    brelse(bp);
    800023aa:	854a                	mv	a0,s2
    800023ac:	e1dff0ef          	jal	800021c8 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    800023b0:	015c0abb          	addw	s5,s8,s5
    800023b4:	004b2783          	lw	a5,4(s6)
    800023b8:	04faf863          	bgeu	s5,a5,80002408 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    800023bc:	40dad59b          	sraiw	a1,s5,0xd
    800023c0:	01cb2783          	lw	a5,28(s6)
    800023c4:	9dbd                	addw	a1,a1,a5
    800023c6:	855e                	mv	a0,s7
    800023c8:	cf9ff0ef          	jal	800020c0 <bread>
    800023cc:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023ce:	004b2503          	lw	a0,4(s6)
    800023d2:	84d6                	mv	s1,s5
    800023d4:	4701                	li	a4,0
    800023d6:	fca4fae3          	bgeu	s1,a0,800023aa <balloc+0x8a>
      m = 1 << (bi % 8);
    800023da:	00777693          	andi	a3,a4,7
    800023de:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800023e2:	41f7579b          	sraiw	a5,a4,0x1f
    800023e6:	01d7d79b          	srliw	a5,a5,0x1d
    800023ea:	9fb9                	addw	a5,a5,a4
    800023ec:	4037d79b          	sraiw	a5,a5,0x3
    800023f0:	00f90633          	add	a2,s2,a5
    800023f4:	05864603          	lbu	a2,88(a2)
    800023f8:	00c6f5b3          	and	a1,a3,a2
    800023fc:	ddb1                	beqz	a1,80002358 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800023fe:	2705                	addiw	a4,a4,1
    80002400:	2485                	addiw	s1,s1,1
    80002402:	fd471ae3          	bne	a4,s4,800023d6 <balloc+0xb6>
    80002406:	b755                	j	800023aa <balloc+0x8a>
    80002408:	7942                	ld	s2,48(sp)
    8000240a:	79a2                	ld	s3,40(sp)
    8000240c:	7a02                	ld	s4,32(sp)
    8000240e:	6ae2                	ld	s5,24(sp)
    80002410:	6b42                	ld	s6,16(sp)
    80002412:	6ba2                	ld	s7,8(sp)
    80002414:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002416:	00005517          	auipc	a0,0x5
    8000241a:	f8250513          	addi	a0,a0,-126 # 80007398 <etext+0x398>
    8000241e:	7ef020ef          	jal	8000540c <printf>
  return 0;
    80002422:	4481                	li	s1,0
    80002424:	bfad                	j	8000239e <balloc+0x7e>

0000000080002426 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002426:	7179                	addi	sp,sp,-48
    80002428:	f406                	sd	ra,40(sp)
    8000242a:	f022                	sd	s0,32(sp)
    8000242c:	ec26                	sd	s1,24(sp)
    8000242e:	e84a                	sd	s2,16(sp)
    80002430:	e44e                	sd	s3,8(sp)
    80002432:	1800                	addi	s0,sp,48
    80002434:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    80002436:	47ad                	li	a5,11
    80002438:	02b7e363          	bltu	a5,a1,8000245e <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    8000243c:	02059793          	slli	a5,a1,0x20
    80002440:	01e7d593          	srli	a1,a5,0x1e
    80002444:	00b509b3          	add	s3,a0,a1
    80002448:	0509a483          	lw	s1,80(s3)
    8000244c:	e0b5                	bnez	s1,800024b0 <bmap+0x8a>
      addr = balloc(ip->dev);
    8000244e:	4108                	lw	a0,0(a0)
    80002450:	ed1ff0ef          	jal	80002320 <balloc>
    80002454:	84aa                	mv	s1,a0
      if(addr == 0)
    80002456:	cd29                	beqz	a0,800024b0 <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002458:	04a9a823          	sw	a0,80(s3)
    8000245c:	a891                	j	800024b0 <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000245e:	ff45879b          	addiw	a5,a1,-12
    80002462:	873e                	mv	a4,a5
    80002464:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80002466:	0ff00793          	li	a5,255
    8000246a:	06e7e763          	bltu	a5,a4,800024d8 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000246e:	08052483          	lw	s1,128(a0)
    80002472:	e891                	bnez	s1,80002486 <bmap+0x60>
      addr = balloc(ip->dev);
    80002474:	4108                	lw	a0,0(a0)
    80002476:	eabff0ef          	jal	80002320 <balloc>
    8000247a:	84aa                	mv	s1,a0
      if(addr == 0)
    8000247c:	c915                	beqz	a0,800024b0 <bmap+0x8a>
    8000247e:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002480:	08a92023          	sw	a0,128(s2)
    80002484:	a011                	j	80002488 <bmap+0x62>
    80002486:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002488:	85a6                	mv	a1,s1
    8000248a:	00092503          	lw	a0,0(s2)
    8000248e:	c33ff0ef          	jal	800020c0 <bread>
    80002492:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002494:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002498:	02099713          	slli	a4,s3,0x20
    8000249c:	01e75593          	srli	a1,a4,0x1e
    800024a0:	97ae                	add	a5,a5,a1
    800024a2:	89be                	mv	s3,a5
    800024a4:	4384                	lw	s1,0(a5)
    800024a6:	cc89                	beqz	s1,800024c0 <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    800024a8:	8552                	mv	a0,s4
    800024aa:	d1fff0ef          	jal	800021c8 <brelse>
    return addr;
    800024ae:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    800024b0:	8526                	mv	a0,s1
    800024b2:	70a2                	ld	ra,40(sp)
    800024b4:	7402                	ld	s0,32(sp)
    800024b6:	64e2                	ld	s1,24(sp)
    800024b8:	6942                	ld	s2,16(sp)
    800024ba:	69a2                	ld	s3,8(sp)
    800024bc:	6145                	addi	sp,sp,48
    800024be:	8082                	ret
      addr = balloc(ip->dev);
    800024c0:	00092503          	lw	a0,0(s2)
    800024c4:	e5dff0ef          	jal	80002320 <balloc>
    800024c8:	84aa                	mv	s1,a0
      if(addr){
    800024ca:	dd79                	beqz	a0,800024a8 <bmap+0x82>
        a[bn] = addr;
    800024cc:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    800024d0:	8552                	mv	a0,s4
    800024d2:	62d000ef          	jal	800032fe <log_write>
    800024d6:	bfc9                	j	800024a8 <bmap+0x82>
    800024d8:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    800024da:	00005517          	auipc	a0,0x5
    800024de:	ed650513          	addi	a0,a0,-298 # 800073b0 <etext+0x3b0>
    800024e2:	254030ef          	jal	80005736 <panic>

00000000800024e6 <iget>:
{
    800024e6:	7179                	addi	sp,sp,-48
    800024e8:	f406                	sd	ra,40(sp)
    800024ea:	f022                	sd	s0,32(sp)
    800024ec:	ec26                	sd	s1,24(sp)
    800024ee:	e84a                	sd	s2,16(sp)
    800024f0:	e44e                	sd	s3,8(sp)
    800024f2:	e052                	sd	s4,0(sp)
    800024f4:	1800                	addi	s0,sp,48
    800024f6:	892a                	mv	s2,a0
    800024f8:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800024fa:	00016517          	auipc	a0,0x16
    800024fe:	ace50513          	addi	a0,a0,-1330 # 80017fc8 <itable>
    80002502:	4f6030ef          	jal	800059f8 <acquire>
  empty = 0;
    80002506:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002508:	00016497          	auipc	s1,0x16
    8000250c:	ad848493          	addi	s1,s1,-1320 # 80017fe0 <itable+0x18>
    80002510:	00017697          	auipc	a3,0x17
    80002514:	56068693          	addi	a3,a3,1376 # 80019a70 <log>
    80002518:	a809                	j	8000252a <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000251a:	e781                	bnez	a5,80002522 <iget+0x3c>
    8000251c:	00099363          	bnez	s3,80002522 <iget+0x3c>
      empty = ip;
    80002520:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002522:	08848493          	addi	s1,s1,136
    80002526:	02d48563          	beq	s1,a3,80002550 <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    8000252a:	449c                	lw	a5,8(s1)
    8000252c:	fef057e3          	blez	a5,8000251a <iget+0x34>
    80002530:	4098                	lw	a4,0(s1)
    80002532:	ff2718e3          	bne	a4,s2,80002522 <iget+0x3c>
    80002536:	40d8                	lw	a4,4(s1)
    80002538:	ff4715e3          	bne	a4,s4,80002522 <iget+0x3c>
      ip->ref++;
    8000253c:	2785                	addiw	a5,a5,1
    8000253e:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002540:	00016517          	auipc	a0,0x16
    80002544:	a8850513          	addi	a0,a0,-1400 # 80017fc8 <itable>
    80002548:	544030ef          	jal	80005a8c <release>
      return ip;
    8000254c:	89a6                	mv	s3,s1
    8000254e:	a015                	j	80002572 <iget+0x8c>
  if(empty == 0)
    80002550:	02098a63          	beqz	s3,80002584 <iget+0x9e>
  ip->dev = dev;
    80002554:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002558:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    8000255c:	4785                	li	a5,1
    8000255e:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002562:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80002566:	00016517          	auipc	a0,0x16
    8000256a:	a6250513          	addi	a0,a0,-1438 # 80017fc8 <itable>
    8000256e:	51e030ef          	jal	80005a8c <release>
}
    80002572:	854e                	mv	a0,s3
    80002574:	70a2                	ld	ra,40(sp)
    80002576:	7402                	ld	s0,32(sp)
    80002578:	64e2                	ld	s1,24(sp)
    8000257a:	6942                	ld	s2,16(sp)
    8000257c:	69a2                	ld	s3,8(sp)
    8000257e:	6a02                	ld	s4,0(sp)
    80002580:	6145                	addi	sp,sp,48
    80002582:	8082                	ret
    panic("iget: no inodes");
    80002584:	00005517          	auipc	a0,0x5
    80002588:	e4450513          	addi	a0,a0,-444 # 800073c8 <etext+0x3c8>
    8000258c:	1aa030ef          	jal	80005736 <panic>

0000000080002590 <iinit>:
{
    80002590:	7179                	addi	sp,sp,-48
    80002592:	f406                	sd	ra,40(sp)
    80002594:	f022                	sd	s0,32(sp)
    80002596:	ec26                	sd	s1,24(sp)
    80002598:	e84a                	sd	s2,16(sp)
    8000259a:	e44e                	sd	s3,8(sp)
    8000259c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000259e:	00005597          	auipc	a1,0x5
    800025a2:	e3a58593          	addi	a1,a1,-454 # 800073d8 <etext+0x3d8>
    800025a6:	00016517          	auipc	a0,0x16
    800025aa:	a2250513          	addi	a0,a0,-1502 # 80017fc8 <itable>
    800025ae:	3c0030ef          	jal	8000596e <initlock>
  for(i = 0; i < NINODE; i++) {
    800025b2:	00016497          	auipc	s1,0x16
    800025b6:	a3e48493          	addi	s1,s1,-1474 # 80017ff0 <itable+0x28>
    800025ba:	00017997          	auipc	s3,0x17
    800025be:	4c698993          	addi	s3,s3,1222 # 80019a80 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    800025c2:	00005917          	auipc	s2,0x5
    800025c6:	e1e90913          	addi	s2,s2,-482 # 800073e0 <etext+0x3e0>
    800025ca:	85ca                	mv	a1,s2
    800025cc:	8526                	mv	a0,s1
    800025ce:	5f5000ef          	jal	800033c2 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    800025d2:	08848493          	addi	s1,s1,136
    800025d6:	ff349ae3          	bne	s1,s3,800025ca <iinit+0x3a>
}
    800025da:	70a2                	ld	ra,40(sp)
    800025dc:	7402                	ld	s0,32(sp)
    800025de:	64e2                	ld	s1,24(sp)
    800025e0:	6942                	ld	s2,16(sp)
    800025e2:	69a2                	ld	s3,8(sp)
    800025e4:	6145                	addi	sp,sp,48
    800025e6:	8082                	ret

00000000800025e8 <ialloc>:
{
    800025e8:	7139                	addi	sp,sp,-64
    800025ea:	fc06                	sd	ra,56(sp)
    800025ec:	f822                	sd	s0,48(sp)
    800025ee:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    800025f0:	00016717          	auipc	a4,0x16
    800025f4:	9c472703          	lw	a4,-1596(a4) # 80017fb4 <sb+0xc>
    800025f8:	4785                	li	a5,1
    800025fa:	06e7f063          	bgeu	a5,a4,8000265a <ialloc+0x72>
    800025fe:	f426                	sd	s1,40(sp)
    80002600:	f04a                	sd	s2,32(sp)
    80002602:	ec4e                	sd	s3,24(sp)
    80002604:	e852                	sd	s4,16(sp)
    80002606:	e456                	sd	s5,8(sp)
    80002608:	e05a                	sd	s6,0(sp)
    8000260a:	8aaa                	mv	s5,a0
    8000260c:	8b2e                	mv	s6,a1
    8000260e:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002610:	00016a17          	auipc	s4,0x16
    80002614:	998a0a13          	addi	s4,s4,-1640 # 80017fa8 <sb>
    80002618:	00495593          	srli	a1,s2,0x4
    8000261c:	018a2783          	lw	a5,24(s4)
    80002620:	9dbd                	addw	a1,a1,a5
    80002622:	8556                	mv	a0,s5
    80002624:	a9dff0ef          	jal	800020c0 <bread>
    80002628:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    8000262a:	05850993          	addi	s3,a0,88
    8000262e:	00f97793          	andi	a5,s2,15
    80002632:	079a                	slli	a5,a5,0x6
    80002634:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002636:	00099783          	lh	a5,0(s3)
    8000263a:	cb9d                	beqz	a5,80002670 <ialloc+0x88>
    brelse(bp);
    8000263c:	b8dff0ef          	jal	800021c8 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002640:	0905                	addi	s2,s2,1
    80002642:	00ca2703          	lw	a4,12(s4)
    80002646:	0009079b          	sext.w	a5,s2
    8000264a:	fce7e7e3          	bltu	a5,a4,80002618 <ialloc+0x30>
    8000264e:	74a2                	ld	s1,40(sp)
    80002650:	7902                	ld	s2,32(sp)
    80002652:	69e2                	ld	s3,24(sp)
    80002654:	6a42                	ld	s4,16(sp)
    80002656:	6aa2                	ld	s5,8(sp)
    80002658:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    8000265a:	00005517          	auipc	a0,0x5
    8000265e:	d8e50513          	addi	a0,a0,-626 # 800073e8 <etext+0x3e8>
    80002662:	5ab020ef          	jal	8000540c <printf>
  return 0;
    80002666:	4501                	li	a0,0
}
    80002668:	70e2                	ld	ra,56(sp)
    8000266a:	7442                	ld	s0,48(sp)
    8000266c:	6121                	addi	sp,sp,64
    8000266e:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002670:	04000613          	li	a2,64
    80002674:	4581                	li	a1,0
    80002676:	854e                	mv	a0,s3
    80002678:	ac7fd0ef          	jal	8000013e <memset>
      dip->type = type;
    8000267c:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002680:	8526                	mv	a0,s1
    80002682:	47d000ef          	jal	800032fe <log_write>
      brelse(bp);
    80002686:	8526                	mv	a0,s1
    80002688:	b41ff0ef          	jal	800021c8 <brelse>
      return iget(dev, inum);
    8000268c:	0009059b          	sext.w	a1,s2
    80002690:	8556                	mv	a0,s5
    80002692:	e55ff0ef          	jal	800024e6 <iget>
    80002696:	74a2                	ld	s1,40(sp)
    80002698:	7902                	ld	s2,32(sp)
    8000269a:	69e2                	ld	s3,24(sp)
    8000269c:	6a42                	ld	s4,16(sp)
    8000269e:	6aa2                	ld	s5,8(sp)
    800026a0:	6b02                	ld	s6,0(sp)
    800026a2:	b7d9                	j	80002668 <ialloc+0x80>

00000000800026a4 <iupdate>:
{
    800026a4:	1101                	addi	sp,sp,-32
    800026a6:	ec06                	sd	ra,24(sp)
    800026a8:	e822                	sd	s0,16(sp)
    800026aa:	e426                	sd	s1,8(sp)
    800026ac:	e04a                	sd	s2,0(sp)
    800026ae:	1000                	addi	s0,sp,32
    800026b0:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    800026b2:	415c                	lw	a5,4(a0)
    800026b4:	0047d79b          	srliw	a5,a5,0x4
    800026b8:	00016597          	auipc	a1,0x16
    800026bc:	9085a583          	lw	a1,-1784(a1) # 80017fc0 <sb+0x18>
    800026c0:	9dbd                	addw	a1,a1,a5
    800026c2:	4108                	lw	a0,0(a0)
    800026c4:	9fdff0ef          	jal	800020c0 <bread>
    800026c8:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    800026ca:	05850793          	addi	a5,a0,88
    800026ce:	40d8                	lw	a4,4(s1)
    800026d0:	8b3d                	andi	a4,a4,15
    800026d2:	071a                	slli	a4,a4,0x6
    800026d4:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    800026d6:	04449703          	lh	a4,68(s1)
    800026da:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    800026de:	04649703          	lh	a4,70(s1)
    800026e2:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    800026e6:	04849703          	lh	a4,72(s1)
    800026ea:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    800026ee:	04a49703          	lh	a4,74(s1)
    800026f2:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800026f6:	44f8                	lw	a4,76(s1)
    800026f8:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800026fa:	03400613          	li	a2,52
    800026fe:	05048593          	addi	a1,s1,80
    80002702:	00c78513          	addi	a0,a5,12
    80002706:	a99fd0ef          	jal	8000019e <memmove>
  log_write(bp);
    8000270a:	854a                	mv	a0,s2
    8000270c:	3f3000ef          	jal	800032fe <log_write>
  brelse(bp);
    80002710:	854a                	mv	a0,s2
    80002712:	ab7ff0ef          	jal	800021c8 <brelse>
}
    80002716:	60e2                	ld	ra,24(sp)
    80002718:	6442                	ld	s0,16(sp)
    8000271a:	64a2                	ld	s1,8(sp)
    8000271c:	6902                	ld	s2,0(sp)
    8000271e:	6105                	addi	sp,sp,32
    80002720:	8082                	ret

0000000080002722 <idup>:
{
    80002722:	1101                	addi	sp,sp,-32
    80002724:	ec06                	sd	ra,24(sp)
    80002726:	e822                	sd	s0,16(sp)
    80002728:	e426                	sd	s1,8(sp)
    8000272a:	1000                	addi	s0,sp,32
    8000272c:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    8000272e:	00016517          	auipc	a0,0x16
    80002732:	89a50513          	addi	a0,a0,-1894 # 80017fc8 <itable>
    80002736:	2c2030ef          	jal	800059f8 <acquire>
  ip->ref++;
    8000273a:	449c                	lw	a5,8(s1)
    8000273c:	2785                	addiw	a5,a5,1
    8000273e:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002740:	00016517          	auipc	a0,0x16
    80002744:	88850513          	addi	a0,a0,-1912 # 80017fc8 <itable>
    80002748:	344030ef          	jal	80005a8c <release>
}
    8000274c:	8526                	mv	a0,s1
    8000274e:	60e2                	ld	ra,24(sp)
    80002750:	6442                	ld	s0,16(sp)
    80002752:	64a2                	ld	s1,8(sp)
    80002754:	6105                	addi	sp,sp,32
    80002756:	8082                	ret

0000000080002758 <ilock>:
{
    80002758:	1101                	addi	sp,sp,-32
    8000275a:	ec06                	sd	ra,24(sp)
    8000275c:	e822                	sd	s0,16(sp)
    8000275e:	e426                	sd	s1,8(sp)
    80002760:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002762:	cd19                	beqz	a0,80002780 <ilock+0x28>
    80002764:	84aa                	mv	s1,a0
    80002766:	451c                	lw	a5,8(a0)
    80002768:	00f05c63          	blez	a5,80002780 <ilock+0x28>
  acquiresleep(&ip->lock);
    8000276c:	0541                	addi	a0,a0,16
    8000276e:	48b000ef          	jal	800033f8 <acquiresleep>
  if(ip->valid == 0){
    80002772:	40bc                	lw	a5,64(s1)
    80002774:	cf89                	beqz	a5,8000278e <ilock+0x36>
}
    80002776:	60e2                	ld	ra,24(sp)
    80002778:	6442                	ld	s0,16(sp)
    8000277a:	64a2                	ld	s1,8(sp)
    8000277c:	6105                	addi	sp,sp,32
    8000277e:	8082                	ret
    80002780:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002782:	00005517          	auipc	a0,0x5
    80002786:	c7e50513          	addi	a0,a0,-898 # 80007400 <etext+0x400>
    8000278a:	7ad020ef          	jal	80005736 <panic>
    8000278e:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002790:	40dc                	lw	a5,4(s1)
    80002792:	0047d79b          	srliw	a5,a5,0x4
    80002796:	00016597          	auipc	a1,0x16
    8000279a:	82a5a583          	lw	a1,-2006(a1) # 80017fc0 <sb+0x18>
    8000279e:	9dbd                	addw	a1,a1,a5
    800027a0:	4088                	lw	a0,0(s1)
    800027a2:	91fff0ef          	jal	800020c0 <bread>
    800027a6:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    800027a8:	05850593          	addi	a1,a0,88
    800027ac:	40dc                	lw	a5,4(s1)
    800027ae:	8bbd                	andi	a5,a5,15
    800027b0:	079a                	slli	a5,a5,0x6
    800027b2:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    800027b4:	00059783          	lh	a5,0(a1)
    800027b8:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    800027bc:	00259783          	lh	a5,2(a1)
    800027c0:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    800027c4:	00459783          	lh	a5,4(a1)
    800027c8:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    800027cc:	00659783          	lh	a5,6(a1)
    800027d0:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    800027d4:	459c                	lw	a5,8(a1)
    800027d6:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    800027d8:	03400613          	li	a2,52
    800027dc:	05b1                	addi	a1,a1,12
    800027de:	05048513          	addi	a0,s1,80
    800027e2:	9bdfd0ef          	jal	8000019e <memmove>
    brelse(bp);
    800027e6:	854a                	mv	a0,s2
    800027e8:	9e1ff0ef          	jal	800021c8 <brelse>
    ip->valid = 1;
    800027ec:	4785                	li	a5,1
    800027ee:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    800027f0:	04449783          	lh	a5,68(s1)
    800027f4:	c399                	beqz	a5,800027fa <ilock+0xa2>
    800027f6:	6902                	ld	s2,0(sp)
    800027f8:	bfbd                	j	80002776 <ilock+0x1e>
      panic("ilock: no type");
    800027fa:	00005517          	auipc	a0,0x5
    800027fe:	c0e50513          	addi	a0,a0,-1010 # 80007408 <etext+0x408>
    80002802:	735020ef          	jal	80005736 <panic>

0000000080002806 <iunlock>:
{
    80002806:	1101                	addi	sp,sp,-32
    80002808:	ec06                	sd	ra,24(sp)
    8000280a:	e822                	sd	s0,16(sp)
    8000280c:	e426                	sd	s1,8(sp)
    8000280e:	e04a                	sd	s2,0(sp)
    80002810:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002812:	c505                	beqz	a0,8000283a <iunlock+0x34>
    80002814:	84aa                	mv	s1,a0
    80002816:	01050913          	addi	s2,a0,16
    8000281a:	854a                	mv	a0,s2
    8000281c:	45b000ef          	jal	80003476 <holdingsleep>
    80002820:	cd09                	beqz	a0,8000283a <iunlock+0x34>
    80002822:	449c                	lw	a5,8(s1)
    80002824:	00f05b63          	blez	a5,8000283a <iunlock+0x34>
  releasesleep(&ip->lock);
    80002828:	854a                	mv	a0,s2
    8000282a:	415000ef          	jal	8000343e <releasesleep>
}
    8000282e:	60e2                	ld	ra,24(sp)
    80002830:	6442                	ld	s0,16(sp)
    80002832:	64a2                	ld	s1,8(sp)
    80002834:	6902                	ld	s2,0(sp)
    80002836:	6105                	addi	sp,sp,32
    80002838:	8082                	ret
    panic("iunlock");
    8000283a:	00005517          	auipc	a0,0x5
    8000283e:	bde50513          	addi	a0,a0,-1058 # 80007418 <etext+0x418>
    80002842:	6f5020ef          	jal	80005736 <panic>

0000000080002846 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002846:	7179                	addi	sp,sp,-48
    80002848:	f406                	sd	ra,40(sp)
    8000284a:	f022                	sd	s0,32(sp)
    8000284c:	ec26                	sd	s1,24(sp)
    8000284e:	e84a                	sd	s2,16(sp)
    80002850:	e44e                	sd	s3,8(sp)
    80002852:	1800                	addi	s0,sp,48
    80002854:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002856:	05050493          	addi	s1,a0,80
    8000285a:	08050913          	addi	s2,a0,128
    8000285e:	a021                	j	80002866 <itrunc+0x20>
    80002860:	0491                	addi	s1,s1,4
    80002862:	01248b63          	beq	s1,s2,80002878 <itrunc+0x32>
    if(ip->addrs[i]){
    80002866:	408c                	lw	a1,0(s1)
    80002868:	dde5                	beqz	a1,80002860 <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    8000286a:	0009a503          	lw	a0,0(s3)
    8000286e:	a47ff0ef          	jal	800022b4 <bfree>
      ip->addrs[i] = 0;
    80002872:	0004a023          	sw	zero,0(s1)
    80002876:	b7ed                	j	80002860 <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002878:	0809a583          	lw	a1,128(s3)
    8000287c:	ed89                	bnez	a1,80002896 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    8000287e:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002882:	854e                	mv	a0,s3
    80002884:	e21ff0ef          	jal	800026a4 <iupdate>
}
    80002888:	70a2                	ld	ra,40(sp)
    8000288a:	7402                	ld	s0,32(sp)
    8000288c:	64e2                	ld	s1,24(sp)
    8000288e:	6942                	ld	s2,16(sp)
    80002890:	69a2                	ld	s3,8(sp)
    80002892:	6145                	addi	sp,sp,48
    80002894:	8082                	ret
    80002896:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002898:	0009a503          	lw	a0,0(s3)
    8000289c:	825ff0ef          	jal	800020c0 <bread>
    800028a0:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    800028a2:	05850493          	addi	s1,a0,88
    800028a6:	45850913          	addi	s2,a0,1112
    800028aa:	a021                	j	800028b2 <itrunc+0x6c>
    800028ac:	0491                	addi	s1,s1,4
    800028ae:	01248963          	beq	s1,s2,800028c0 <itrunc+0x7a>
      if(a[j])
    800028b2:	408c                	lw	a1,0(s1)
    800028b4:	dde5                	beqz	a1,800028ac <itrunc+0x66>
        bfree(ip->dev, a[j]);
    800028b6:	0009a503          	lw	a0,0(s3)
    800028ba:	9fbff0ef          	jal	800022b4 <bfree>
    800028be:	b7fd                	j	800028ac <itrunc+0x66>
    brelse(bp);
    800028c0:	8552                	mv	a0,s4
    800028c2:	907ff0ef          	jal	800021c8 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    800028c6:	0809a583          	lw	a1,128(s3)
    800028ca:	0009a503          	lw	a0,0(s3)
    800028ce:	9e7ff0ef          	jal	800022b4 <bfree>
    ip->addrs[NDIRECT] = 0;
    800028d2:	0809a023          	sw	zero,128(s3)
    800028d6:	6a02                	ld	s4,0(sp)
    800028d8:	b75d                	j	8000287e <itrunc+0x38>

00000000800028da <iput>:
{
    800028da:	1101                	addi	sp,sp,-32
    800028dc:	ec06                	sd	ra,24(sp)
    800028de:	e822                	sd	s0,16(sp)
    800028e0:	e426                	sd	s1,8(sp)
    800028e2:	1000                	addi	s0,sp,32
    800028e4:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028e6:	00015517          	auipc	a0,0x15
    800028ea:	6e250513          	addi	a0,a0,1762 # 80017fc8 <itable>
    800028ee:	10a030ef          	jal	800059f8 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    800028f2:	4498                	lw	a4,8(s1)
    800028f4:	4785                	li	a5,1
    800028f6:	02f70063          	beq	a4,a5,80002916 <iput+0x3c>
  ip->ref--;
    800028fa:	449c                	lw	a5,8(s1)
    800028fc:	37fd                	addiw	a5,a5,-1
    800028fe:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002900:	00015517          	auipc	a0,0x15
    80002904:	6c850513          	addi	a0,a0,1736 # 80017fc8 <itable>
    80002908:	184030ef          	jal	80005a8c <release>
}
    8000290c:	60e2                	ld	ra,24(sp)
    8000290e:	6442                	ld	s0,16(sp)
    80002910:	64a2                	ld	s1,8(sp)
    80002912:	6105                	addi	sp,sp,32
    80002914:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002916:	40bc                	lw	a5,64(s1)
    80002918:	d3ed                	beqz	a5,800028fa <iput+0x20>
    8000291a:	04a49783          	lh	a5,74(s1)
    8000291e:	fff1                	bnez	a5,800028fa <iput+0x20>
    80002920:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002922:	01048793          	addi	a5,s1,16
    80002926:	893e                	mv	s2,a5
    80002928:	853e                	mv	a0,a5
    8000292a:	2cf000ef          	jal	800033f8 <acquiresleep>
    release(&itable.lock);
    8000292e:	00015517          	auipc	a0,0x15
    80002932:	69a50513          	addi	a0,a0,1690 # 80017fc8 <itable>
    80002936:	156030ef          	jal	80005a8c <release>
    itrunc(ip);
    8000293a:	8526                	mv	a0,s1
    8000293c:	f0bff0ef          	jal	80002846 <itrunc>
    ip->type = 0;
    80002940:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002944:	8526                	mv	a0,s1
    80002946:	d5fff0ef          	jal	800026a4 <iupdate>
    ip->valid = 0;
    8000294a:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    8000294e:	854a                	mv	a0,s2
    80002950:	2ef000ef          	jal	8000343e <releasesleep>
    acquire(&itable.lock);
    80002954:	00015517          	auipc	a0,0x15
    80002958:	67450513          	addi	a0,a0,1652 # 80017fc8 <itable>
    8000295c:	09c030ef          	jal	800059f8 <acquire>
    80002960:	6902                	ld	s2,0(sp)
    80002962:	bf61                	j	800028fa <iput+0x20>

0000000080002964 <iunlockput>:
{
    80002964:	1101                	addi	sp,sp,-32
    80002966:	ec06                	sd	ra,24(sp)
    80002968:	e822                	sd	s0,16(sp)
    8000296a:	e426                	sd	s1,8(sp)
    8000296c:	1000                	addi	s0,sp,32
    8000296e:	84aa                	mv	s1,a0
  iunlock(ip);
    80002970:	e97ff0ef          	jal	80002806 <iunlock>
  iput(ip);
    80002974:	8526                	mv	a0,s1
    80002976:	f65ff0ef          	jal	800028da <iput>
}
    8000297a:	60e2                	ld	ra,24(sp)
    8000297c:	6442                	ld	s0,16(sp)
    8000297e:	64a2                	ld	s1,8(sp)
    80002980:	6105                	addi	sp,sp,32
    80002982:	8082                	ret

0000000080002984 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002984:	00015717          	auipc	a4,0x15
    80002988:	63072703          	lw	a4,1584(a4) # 80017fb4 <sb+0xc>
    8000298c:	4785                	li	a5,1
    8000298e:	0ae7fe63          	bgeu	a5,a4,80002a4a <ireclaim+0xc6>
{
    80002992:	7139                	addi	sp,sp,-64
    80002994:	fc06                	sd	ra,56(sp)
    80002996:	f822                	sd	s0,48(sp)
    80002998:	f426                	sd	s1,40(sp)
    8000299a:	f04a                	sd	s2,32(sp)
    8000299c:	ec4e                	sd	s3,24(sp)
    8000299e:	e852                	sd	s4,16(sp)
    800029a0:	e456                	sd	s5,8(sp)
    800029a2:	e05a                	sd	s6,0(sp)
    800029a4:	0080                	addi	s0,sp,64
    800029a6:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029a8:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    800029aa:	00015a17          	auipc	s4,0x15
    800029ae:	5fea0a13          	addi	s4,s4,1534 # 80017fa8 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    800029b2:	00005b17          	auipc	s6,0x5
    800029b6:	a6eb0b13          	addi	s6,s6,-1426 # 80007420 <etext+0x420>
    800029ba:	a099                	j	80002a00 <ireclaim+0x7c>
    800029bc:	85ce                	mv	a1,s3
    800029be:	855a                	mv	a0,s6
    800029c0:	24d020ef          	jal	8000540c <printf>
      ip = iget(dev, inum);
    800029c4:	85ce                	mv	a1,s3
    800029c6:	8556                	mv	a0,s5
    800029c8:	b1fff0ef          	jal	800024e6 <iget>
    800029cc:	89aa                	mv	s3,a0
    brelse(bp);
    800029ce:	854a                	mv	a0,s2
    800029d0:	ff8ff0ef          	jal	800021c8 <brelse>
    if (ip) {
    800029d4:	00098f63          	beqz	s3,800029f2 <ireclaim+0x6e>
      begin_op();
    800029d8:	78c000ef          	jal	80003164 <begin_op>
      ilock(ip);
    800029dc:	854e                	mv	a0,s3
    800029de:	d7bff0ef          	jal	80002758 <ilock>
      iunlock(ip);
    800029e2:	854e                	mv	a0,s3
    800029e4:	e23ff0ef          	jal	80002806 <iunlock>
      iput(ip);
    800029e8:	854e                	mv	a0,s3
    800029ea:	ef1ff0ef          	jal	800028da <iput>
      end_op();
    800029ee:	7e6000ef          	jal	800031d4 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    800029f2:	0485                	addi	s1,s1,1
    800029f4:	00ca2703          	lw	a4,12(s4)
    800029f8:	0004879b          	sext.w	a5,s1
    800029fc:	02e7fd63          	bgeu	a5,a4,80002a36 <ireclaim+0xb2>
    80002a00:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002a04:	0044d593          	srli	a1,s1,0x4
    80002a08:	018a2783          	lw	a5,24(s4)
    80002a0c:	9dbd                	addw	a1,a1,a5
    80002a0e:	8556                	mv	a0,s5
    80002a10:	eb0ff0ef          	jal	800020c0 <bread>
    80002a14:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002a16:	05850793          	addi	a5,a0,88
    80002a1a:	00f9f713          	andi	a4,s3,15
    80002a1e:	071a                	slli	a4,a4,0x6
    80002a20:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002a22:	00079703          	lh	a4,0(a5)
    80002a26:	c701                	beqz	a4,80002a2e <ireclaim+0xaa>
    80002a28:	00679783          	lh	a5,6(a5)
    80002a2c:	dbc1                	beqz	a5,800029bc <ireclaim+0x38>
    brelse(bp);
    80002a2e:	854a                	mv	a0,s2
    80002a30:	f98ff0ef          	jal	800021c8 <brelse>
    if (ip) {
    80002a34:	bf7d                	j	800029f2 <ireclaim+0x6e>
}
    80002a36:	70e2                	ld	ra,56(sp)
    80002a38:	7442                	ld	s0,48(sp)
    80002a3a:	74a2                	ld	s1,40(sp)
    80002a3c:	7902                	ld	s2,32(sp)
    80002a3e:	69e2                	ld	s3,24(sp)
    80002a40:	6a42                	ld	s4,16(sp)
    80002a42:	6aa2                	ld	s5,8(sp)
    80002a44:	6b02                	ld	s6,0(sp)
    80002a46:	6121                	addi	sp,sp,64
    80002a48:	8082                	ret
    80002a4a:	8082                	ret

0000000080002a4c <fsinit>:
fsinit(int dev) {
    80002a4c:	1101                	addi	sp,sp,-32
    80002a4e:	ec06                	sd	ra,24(sp)
    80002a50:	e822                	sd	s0,16(sp)
    80002a52:	e426                	sd	s1,8(sp)
    80002a54:	e04a                	sd	s2,0(sp)
    80002a56:	1000                	addi	s0,sp,32
    80002a58:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002a5a:	4585                	li	a1,1
    80002a5c:	e64ff0ef          	jal	800020c0 <bread>
    80002a60:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002a62:	02000613          	li	a2,32
    80002a66:	05850593          	addi	a1,a0,88
    80002a6a:	00015517          	auipc	a0,0x15
    80002a6e:	53e50513          	addi	a0,a0,1342 # 80017fa8 <sb>
    80002a72:	f2cfd0ef          	jal	8000019e <memmove>
  brelse(bp);
    80002a76:	8526                	mv	a0,s1
    80002a78:	f50ff0ef          	jal	800021c8 <brelse>
  if(sb.magic != FSMAGIC)
    80002a7c:	00015717          	auipc	a4,0x15
    80002a80:	52c72703          	lw	a4,1324(a4) # 80017fa8 <sb>
    80002a84:	102037b7          	lui	a5,0x10203
    80002a88:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a8c:	02f71263          	bne	a4,a5,80002ab0 <fsinit+0x64>
  initlog(dev, &sb);
    80002a90:	00015597          	auipc	a1,0x15
    80002a94:	51858593          	addi	a1,a1,1304 # 80017fa8 <sb>
    80002a98:	854a                	mv	a0,s2
    80002a9a:	648000ef          	jal	800030e2 <initlog>
  ireclaim(dev);
    80002a9e:	854a                	mv	a0,s2
    80002aa0:	ee5ff0ef          	jal	80002984 <ireclaim>
}
    80002aa4:	60e2                	ld	ra,24(sp)
    80002aa6:	6442                	ld	s0,16(sp)
    80002aa8:	64a2                	ld	s1,8(sp)
    80002aaa:	6902                	ld	s2,0(sp)
    80002aac:	6105                	addi	sp,sp,32
    80002aae:	8082                	ret
    panic("invalid file system");
    80002ab0:	00005517          	auipc	a0,0x5
    80002ab4:	99050513          	addi	a0,a0,-1648 # 80007440 <etext+0x440>
    80002ab8:	47f020ef          	jal	80005736 <panic>

0000000080002abc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002abc:	1141                	addi	sp,sp,-16
    80002abe:	e406                	sd	ra,8(sp)
    80002ac0:	e022                	sd	s0,0(sp)
    80002ac2:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002ac4:	411c                	lw	a5,0(a0)
    80002ac6:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ac8:	415c                	lw	a5,4(a0)
    80002aca:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002acc:	04451783          	lh	a5,68(a0)
    80002ad0:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002ad4:	04a51783          	lh	a5,74(a0)
    80002ad8:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002adc:	04c56783          	lwu	a5,76(a0)
    80002ae0:	e99c                	sd	a5,16(a1)
}
    80002ae2:	60a2                	ld	ra,8(sp)
    80002ae4:	6402                	ld	s0,0(sp)
    80002ae6:	0141                	addi	sp,sp,16
    80002ae8:	8082                	ret

0000000080002aea <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002aea:	457c                	lw	a5,76(a0)
    80002aec:	0ed7e663          	bltu	a5,a3,80002bd8 <readi+0xee>
{
    80002af0:	7159                	addi	sp,sp,-112
    80002af2:	f486                	sd	ra,104(sp)
    80002af4:	f0a2                	sd	s0,96(sp)
    80002af6:	eca6                	sd	s1,88(sp)
    80002af8:	e0d2                	sd	s4,64(sp)
    80002afa:	fc56                	sd	s5,56(sp)
    80002afc:	f85a                	sd	s6,48(sp)
    80002afe:	f45e                	sd	s7,40(sp)
    80002b00:	1880                	addi	s0,sp,112
    80002b02:	8b2a                	mv	s6,a0
    80002b04:	8bae                	mv	s7,a1
    80002b06:	8a32                	mv	s4,a2
    80002b08:	84b6                	mv	s1,a3
    80002b0a:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002b0c:	9f35                	addw	a4,a4,a3
    return 0;
    80002b0e:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002b10:	0ad76b63          	bltu	a4,a3,80002bc6 <readi+0xdc>
    80002b14:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002b16:	00e7f463          	bgeu	a5,a4,80002b1e <readi+0x34>
    n = ip->size - off;
    80002b1a:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b1e:	080a8b63          	beqz	s5,80002bb4 <readi+0xca>
    80002b22:	e8ca                	sd	s2,80(sp)
    80002b24:	f062                	sd	s8,32(sp)
    80002b26:	ec66                	sd	s9,24(sp)
    80002b28:	e86a                	sd	s10,16(sp)
    80002b2a:	e46e                	sd	s11,8(sp)
    80002b2c:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b2e:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002b32:	5c7d                	li	s8,-1
    80002b34:	a80d                	j	80002b66 <readi+0x7c>
    80002b36:	020d1d93          	slli	s11,s10,0x20
    80002b3a:	020ddd93          	srli	s11,s11,0x20
    80002b3e:	05890613          	addi	a2,s2,88
    80002b42:	86ee                	mv	a3,s11
    80002b44:	963e                	add	a2,a2,a5
    80002b46:	85d2                	mv	a1,s4
    80002b48:	855e                	mv	a0,s7
    80002b4a:	babfe0ef          	jal	800016f4 <either_copyout>
    80002b4e:	05850363          	beq	a0,s8,80002b94 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002b52:	854a                	mv	a0,s2
    80002b54:	e74ff0ef          	jal	800021c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002b58:	013d09bb          	addw	s3,s10,s3
    80002b5c:	009d04bb          	addw	s1,s10,s1
    80002b60:	9a6e                	add	s4,s4,s11
    80002b62:	0559f363          	bgeu	s3,s5,80002ba8 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002b66:	00a4d59b          	srliw	a1,s1,0xa
    80002b6a:	855a                	mv	a0,s6
    80002b6c:	8bbff0ef          	jal	80002426 <bmap>
    80002b70:	85aa                	mv	a1,a0
    if(addr == 0)
    80002b72:	c139                	beqz	a0,80002bb8 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002b74:	000b2503          	lw	a0,0(s6)
    80002b78:	d48ff0ef          	jal	800020c0 <bread>
    80002b7c:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002b7e:	3ff4f793          	andi	a5,s1,1023
    80002b82:	40fc873b          	subw	a4,s9,a5
    80002b86:	413a86bb          	subw	a3,s5,s3
    80002b8a:	8d3a                	mv	s10,a4
    80002b8c:	fae6f5e3          	bgeu	a3,a4,80002b36 <readi+0x4c>
    80002b90:	8d36                	mv	s10,a3
    80002b92:	b755                	j	80002b36 <readi+0x4c>
      brelse(bp);
    80002b94:	854a                	mv	a0,s2
    80002b96:	e32ff0ef          	jal	800021c8 <brelse>
      tot = -1;
    80002b9a:	59fd                	li	s3,-1
      break;
    80002b9c:	6946                	ld	s2,80(sp)
    80002b9e:	7c02                	ld	s8,32(sp)
    80002ba0:	6ce2                	ld	s9,24(sp)
    80002ba2:	6d42                	ld	s10,16(sp)
    80002ba4:	6da2                	ld	s11,8(sp)
    80002ba6:	a831                	j	80002bc2 <readi+0xd8>
    80002ba8:	6946                	ld	s2,80(sp)
    80002baa:	7c02                	ld	s8,32(sp)
    80002bac:	6ce2                	ld	s9,24(sp)
    80002bae:	6d42                	ld	s10,16(sp)
    80002bb0:	6da2                	ld	s11,8(sp)
    80002bb2:	a801                	j	80002bc2 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002bb4:	89d6                	mv	s3,s5
    80002bb6:	a031                	j	80002bc2 <readi+0xd8>
    80002bb8:	6946                	ld	s2,80(sp)
    80002bba:	7c02                	ld	s8,32(sp)
    80002bbc:	6ce2                	ld	s9,24(sp)
    80002bbe:	6d42                	ld	s10,16(sp)
    80002bc0:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002bc2:	854e                	mv	a0,s3
    80002bc4:	69a6                	ld	s3,72(sp)
}
    80002bc6:	70a6                	ld	ra,104(sp)
    80002bc8:	7406                	ld	s0,96(sp)
    80002bca:	64e6                	ld	s1,88(sp)
    80002bcc:	6a06                	ld	s4,64(sp)
    80002bce:	7ae2                	ld	s5,56(sp)
    80002bd0:	7b42                	ld	s6,48(sp)
    80002bd2:	7ba2                	ld	s7,40(sp)
    80002bd4:	6165                	addi	sp,sp,112
    80002bd6:	8082                	ret
    return 0;
    80002bd8:	4501                	li	a0,0
}
    80002bda:	8082                	ret

0000000080002bdc <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002bdc:	457c                	lw	a5,76(a0)
    80002bde:	0ed7eb63          	bltu	a5,a3,80002cd4 <writei+0xf8>
{
    80002be2:	7159                	addi	sp,sp,-112
    80002be4:	f486                	sd	ra,104(sp)
    80002be6:	f0a2                	sd	s0,96(sp)
    80002be8:	e8ca                	sd	s2,80(sp)
    80002bea:	e0d2                	sd	s4,64(sp)
    80002bec:	fc56                	sd	s5,56(sp)
    80002bee:	f85a                	sd	s6,48(sp)
    80002bf0:	f45e                	sd	s7,40(sp)
    80002bf2:	1880                	addi	s0,sp,112
    80002bf4:	8aaa                	mv	s5,a0
    80002bf6:	8bae                	mv	s7,a1
    80002bf8:	8a32                	mv	s4,a2
    80002bfa:	8936                	mv	s2,a3
    80002bfc:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002bfe:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002c02:	00043737          	lui	a4,0x43
    80002c06:	0cf76963          	bltu	a4,a5,80002cd8 <writei+0xfc>
    80002c0a:	0cd7e763          	bltu	a5,a3,80002cd8 <writei+0xfc>
    80002c0e:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c10:	0a0b0a63          	beqz	s6,80002cc4 <writei+0xe8>
    80002c14:	eca6                	sd	s1,88(sp)
    80002c16:	f062                	sd	s8,32(sp)
    80002c18:	ec66                	sd	s9,24(sp)
    80002c1a:	e86a                	sd	s10,16(sp)
    80002c1c:	e46e                	sd	s11,8(sp)
    80002c1e:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c20:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002c24:	5c7d                	li	s8,-1
    80002c26:	a825                	j	80002c5e <writei+0x82>
    80002c28:	020d1d93          	slli	s11,s10,0x20
    80002c2c:	020ddd93          	srli	s11,s11,0x20
    80002c30:	05848513          	addi	a0,s1,88
    80002c34:	86ee                	mv	a3,s11
    80002c36:	8652                	mv	a2,s4
    80002c38:	85de                	mv	a1,s7
    80002c3a:	953e                	add	a0,a0,a5
    80002c3c:	b03fe0ef          	jal	8000173e <either_copyin>
    80002c40:	05850663          	beq	a0,s8,80002c8c <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002c44:	8526                	mv	a0,s1
    80002c46:	6b8000ef          	jal	800032fe <log_write>
    brelse(bp);
    80002c4a:	8526                	mv	a0,s1
    80002c4c:	d7cff0ef          	jal	800021c8 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002c50:	013d09bb          	addw	s3,s10,s3
    80002c54:	012d093b          	addw	s2,s10,s2
    80002c58:	9a6e                	add	s4,s4,s11
    80002c5a:	0369fc63          	bgeu	s3,s6,80002c92 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002c5e:	00a9559b          	srliw	a1,s2,0xa
    80002c62:	8556                	mv	a0,s5
    80002c64:	fc2ff0ef          	jal	80002426 <bmap>
    80002c68:	85aa                	mv	a1,a0
    if(addr == 0)
    80002c6a:	c505                	beqz	a0,80002c92 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002c6c:	000aa503          	lw	a0,0(s5)
    80002c70:	c50ff0ef          	jal	800020c0 <bread>
    80002c74:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002c76:	3ff97793          	andi	a5,s2,1023
    80002c7a:	40fc873b          	subw	a4,s9,a5
    80002c7e:	413b06bb          	subw	a3,s6,s3
    80002c82:	8d3a                	mv	s10,a4
    80002c84:	fae6f2e3          	bgeu	a3,a4,80002c28 <writei+0x4c>
    80002c88:	8d36                	mv	s10,a3
    80002c8a:	bf79                	j	80002c28 <writei+0x4c>
      brelse(bp);
    80002c8c:	8526                	mv	a0,s1
    80002c8e:	d3aff0ef          	jal	800021c8 <brelse>
  }

  if(off > ip->size)
    80002c92:	04caa783          	lw	a5,76(s5)
    80002c96:	0327f963          	bgeu	a5,s2,80002cc8 <writei+0xec>
    ip->size = off;
    80002c9a:	052aa623          	sw	s2,76(s5)
    80002c9e:	64e6                	ld	s1,88(sp)
    80002ca0:	7c02                	ld	s8,32(sp)
    80002ca2:	6ce2                	ld	s9,24(sp)
    80002ca4:	6d42                	ld	s10,16(sp)
    80002ca6:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002ca8:	8556                	mv	a0,s5
    80002caa:	9fbff0ef          	jal	800026a4 <iupdate>

  return tot;
    80002cae:	854e                	mv	a0,s3
    80002cb0:	69a6                	ld	s3,72(sp)
}
    80002cb2:	70a6                	ld	ra,104(sp)
    80002cb4:	7406                	ld	s0,96(sp)
    80002cb6:	6946                	ld	s2,80(sp)
    80002cb8:	6a06                	ld	s4,64(sp)
    80002cba:	7ae2                	ld	s5,56(sp)
    80002cbc:	7b42                	ld	s6,48(sp)
    80002cbe:	7ba2                	ld	s7,40(sp)
    80002cc0:	6165                	addi	sp,sp,112
    80002cc2:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002cc4:	89da                	mv	s3,s6
    80002cc6:	b7cd                	j	80002ca8 <writei+0xcc>
    80002cc8:	64e6                	ld	s1,88(sp)
    80002cca:	7c02                	ld	s8,32(sp)
    80002ccc:	6ce2                	ld	s9,24(sp)
    80002cce:	6d42                	ld	s10,16(sp)
    80002cd0:	6da2                	ld	s11,8(sp)
    80002cd2:	bfd9                	j	80002ca8 <writei+0xcc>
    return -1;
    80002cd4:	557d                	li	a0,-1
}
    80002cd6:	8082                	ret
    return -1;
    80002cd8:	557d                	li	a0,-1
    80002cda:	bfe1                	j	80002cb2 <writei+0xd6>

0000000080002cdc <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002cdc:	1141                	addi	sp,sp,-16
    80002cde:	e406                	sd	ra,8(sp)
    80002ce0:	e022                	sd	s0,0(sp)
    80002ce2:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002ce4:	4639                	li	a2,14
    80002ce6:	d2cfd0ef          	jal	80000212 <strncmp>
}
    80002cea:	60a2                	ld	ra,8(sp)
    80002cec:	6402                	ld	s0,0(sp)
    80002cee:	0141                	addi	sp,sp,16
    80002cf0:	8082                	ret

0000000080002cf2 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002cf2:	711d                	addi	sp,sp,-96
    80002cf4:	ec86                	sd	ra,88(sp)
    80002cf6:	e8a2                	sd	s0,80(sp)
    80002cf8:	e4a6                	sd	s1,72(sp)
    80002cfa:	e0ca                	sd	s2,64(sp)
    80002cfc:	fc4e                	sd	s3,56(sp)
    80002cfe:	f852                	sd	s4,48(sp)
    80002d00:	f456                	sd	s5,40(sp)
    80002d02:	f05a                	sd	s6,32(sp)
    80002d04:	ec5e                	sd	s7,24(sp)
    80002d06:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002d08:	04451703          	lh	a4,68(a0)
    80002d0c:	4785                	li	a5,1
    80002d0e:	00f71f63          	bne	a4,a5,80002d2c <dirlookup+0x3a>
    80002d12:	892a                	mv	s2,a0
    80002d14:	8aae                	mv	s5,a1
    80002d16:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d18:	457c                	lw	a5,76(a0)
    80002d1a:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d1c:	fa040a13          	addi	s4,s0,-96
    80002d20:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002d22:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002d26:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d28:	e39d                	bnez	a5,80002d4e <dirlookup+0x5c>
    80002d2a:	a8b9                	j	80002d88 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002d2c:	00004517          	auipc	a0,0x4
    80002d30:	72c50513          	addi	a0,a0,1836 # 80007458 <etext+0x458>
    80002d34:	203020ef          	jal	80005736 <panic>
      panic("dirlookup read");
    80002d38:	00004517          	auipc	a0,0x4
    80002d3c:	73850513          	addi	a0,a0,1848 # 80007470 <etext+0x470>
    80002d40:	1f7020ef          	jal	80005736 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002d44:	24c1                	addiw	s1,s1,16
    80002d46:	04c92783          	lw	a5,76(s2)
    80002d4a:	02f4fe63          	bgeu	s1,a5,80002d86 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002d4e:	874e                	mv	a4,s3
    80002d50:	86a6                	mv	a3,s1
    80002d52:	8652                	mv	a2,s4
    80002d54:	4581                	li	a1,0
    80002d56:	854a                	mv	a0,s2
    80002d58:	d93ff0ef          	jal	80002aea <readi>
    80002d5c:	fd351ee3          	bne	a0,s3,80002d38 <dirlookup+0x46>
    if(de.inum == 0)
    80002d60:	fa045783          	lhu	a5,-96(s0)
    80002d64:	d3e5                	beqz	a5,80002d44 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002d66:	85da                	mv	a1,s6
    80002d68:	8556                	mv	a0,s5
    80002d6a:	f73ff0ef          	jal	80002cdc <namecmp>
    80002d6e:	f979                	bnez	a0,80002d44 <dirlookup+0x52>
      if(poff)
    80002d70:	000b8463          	beqz	s7,80002d78 <dirlookup+0x86>
        *poff = off;
    80002d74:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002d78:	fa045583          	lhu	a1,-96(s0)
    80002d7c:	00092503          	lw	a0,0(s2)
    80002d80:	f66ff0ef          	jal	800024e6 <iget>
    80002d84:	a011                	j	80002d88 <dirlookup+0x96>
  return 0;
    80002d86:	4501                	li	a0,0
}
    80002d88:	60e6                	ld	ra,88(sp)
    80002d8a:	6446                	ld	s0,80(sp)
    80002d8c:	64a6                	ld	s1,72(sp)
    80002d8e:	6906                	ld	s2,64(sp)
    80002d90:	79e2                	ld	s3,56(sp)
    80002d92:	7a42                	ld	s4,48(sp)
    80002d94:	7aa2                	ld	s5,40(sp)
    80002d96:	7b02                	ld	s6,32(sp)
    80002d98:	6be2                	ld	s7,24(sp)
    80002d9a:	6125                	addi	sp,sp,96
    80002d9c:	8082                	ret

0000000080002d9e <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002d9e:	711d                	addi	sp,sp,-96
    80002da0:	ec86                	sd	ra,88(sp)
    80002da2:	e8a2                	sd	s0,80(sp)
    80002da4:	e4a6                	sd	s1,72(sp)
    80002da6:	e0ca                	sd	s2,64(sp)
    80002da8:	fc4e                	sd	s3,56(sp)
    80002daa:	f852                	sd	s4,48(sp)
    80002dac:	f456                	sd	s5,40(sp)
    80002dae:	f05a                	sd	s6,32(sp)
    80002db0:	ec5e                	sd	s7,24(sp)
    80002db2:	e862                	sd	s8,16(sp)
    80002db4:	e466                	sd	s9,8(sp)
    80002db6:	e06a                	sd	s10,0(sp)
    80002db8:	1080                	addi	s0,sp,96
    80002dba:	84aa                	mv	s1,a0
    80002dbc:	8b2e                	mv	s6,a1
    80002dbe:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002dc0:	00054703          	lbu	a4,0(a0)
    80002dc4:	02f00793          	li	a5,47
    80002dc8:	00f70f63          	beq	a4,a5,80002de6 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002dcc:	fb3fd0ef          	jal	80000d7e <myproc>
    80002dd0:	15053503          	ld	a0,336(a0)
    80002dd4:	94fff0ef          	jal	80002722 <idup>
    80002dd8:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002dda:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002dde:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002de0:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002de2:	4b85                	li	s7,1
    80002de4:	a879                	j	80002e82 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002de6:	4585                	li	a1,1
    80002de8:	852e                	mv	a0,a1
    80002dea:	efcff0ef          	jal	800024e6 <iget>
    80002dee:	8a2a                	mv	s4,a0
    80002df0:	b7ed                	j	80002dda <namex+0x3c>
      iunlockput(ip);
    80002df2:	8552                	mv	a0,s4
    80002df4:	b71ff0ef          	jal	80002964 <iunlockput>
      return 0;
    80002df8:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002dfa:	8552                	mv	a0,s4
    80002dfc:	60e6                	ld	ra,88(sp)
    80002dfe:	6446                	ld	s0,80(sp)
    80002e00:	64a6                	ld	s1,72(sp)
    80002e02:	6906                	ld	s2,64(sp)
    80002e04:	79e2                	ld	s3,56(sp)
    80002e06:	7a42                	ld	s4,48(sp)
    80002e08:	7aa2                	ld	s5,40(sp)
    80002e0a:	7b02                	ld	s6,32(sp)
    80002e0c:	6be2                	ld	s7,24(sp)
    80002e0e:	6c42                	ld	s8,16(sp)
    80002e10:	6ca2                	ld	s9,8(sp)
    80002e12:	6d02                	ld	s10,0(sp)
    80002e14:	6125                	addi	sp,sp,96
    80002e16:	8082                	ret
      iunlock(ip);
    80002e18:	8552                	mv	a0,s4
    80002e1a:	9edff0ef          	jal	80002806 <iunlock>
      return ip;
    80002e1e:	bff1                	j	80002dfa <namex+0x5c>
      iunlockput(ip);
    80002e20:	8552                	mv	a0,s4
    80002e22:	b43ff0ef          	jal	80002964 <iunlockput>
      return 0;
    80002e26:	8a4a                	mv	s4,s2
    80002e28:	bfc9                	j	80002dfa <namex+0x5c>
  len = path - s;
    80002e2a:	40990633          	sub	a2,s2,s1
    80002e2e:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002e32:	09ac5463          	bge	s8,s10,80002eba <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002e36:	8666                	mv	a2,s9
    80002e38:	85a6                	mv	a1,s1
    80002e3a:	8556                	mv	a0,s5
    80002e3c:	b62fd0ef          	jal	8000019e <memmove>
    80002e40:	84ca                	mv	s1,s2
  while(*path == '/')
    80002e42:	0004c783          	lbu	a5,0(s1)
    80002e46:	01379763          	bne	a5,s3,80002e54 <namex+0xb6>
    path++;
    80002e4a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e4c:	0004c783          	lbu	a5,0(s1)
    80002e50:	ff378de3          	beq	a5,s3,80002e4a <namex+0xac>
    ilock(ip);
    80002e54:	8552                	mv	a0,s4
    80002e56:	903ff0ef          	jal	80002758 <ilock>
    if(ip->type != T_DIR){
    80002e5a:	044a1783          	lh	a5,68(s4)
    80002e5e:	f9779ae3          	bne	a5,s7,80002df2 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80002e62:	000b0563          	beqz	s6,80002e6c <namex+0xce>
    80002e66:	0004c783          	lbu	a5,0(s1)
    80002e6a:	d7dd                	beqz	a5,80002e18 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    80002e6c:	4601                	li	a2,0
    80002e6e:	85d6                	mv	a1,s5
    80002e70:	8552                	mv	a0,s4
    80002e72:	e81ff0ef          	jal	80002cf2 <dirlookup>
    80002e76:	892a                	mv	s2,a0
    80002e78:	d545                	beqz	a0,80002e20 <namex+0x82>
    iunlockput(ip);
    80002e7a:	8552                	mv	a0,s4
    80002e7c:	ae9ff0ef          	jal	80002964 <iunlockput>
    ip = next;
    80002e80:	8a4a                	mv	s4,s2
  while(*path == '/')
    80002e82:	0004c783          	lbu	a5,0(s1)
    80002e86:	01379763          	bne	a5,s3,80002e94 <namex+0xf6>
    path++;
    80002e8a:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002e8c:	0004c783          	lbu	a5,0(s1)
    80002e90:	ff378de3          	beq	a5,s3,80002e8a <namex+0xec>
  if(*path == 0)
    80002e94:	cf8d                	beqz	a5,80002ece <namex+0x130>
  while(*path != '/' && *path != 0)
    80002e96:	0004c783          	lbu	a5,0(s1)
    80002e9a:	fd178713          	addi	a4,a5,-47
    80002e9e:	cb19                	beqz	a4,80002eb4 <namex+0x116>
    80002ea0:	cb91                	beqz	a5,80002eb4 <namex+0x116>
    80002ea2:	8926                	mv	s2,s1
    path++;
    80002ea4:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80002ea6:	00094783          	lbu	a5,0(s2)
    80002eaa:	fd178713          	addi	a4,a5,-47
    80002eae:	df35                	beqz	a4,80002e2a <namex+0x8c>
    80002eb0:	fbf5                	bnez	a5,80002ea4 <namex+0x106>
    80002eb2:	bfa5                	j	80002e2a <namex+0x8c>
    80002eb4:	8926                	mv	s2,s1
  len = path - s;
    80002eb6:	4d01                	li	s10,0
    80002eb8:	4601                	li	a2,0
    memmove(name, s, len);
    80002eba:	2601                	sext.w	a2,a2
    80002ebc:	85a6                	mv	a1,s1
    80002ebe:	8556                	mv	a0,s5
    80002ec0:	adefd0ef          	jal	8000019e <memmove>
    name[len] = 0;
    80002ec4:	9d56                	add	s10,s10,s5
    80002ec6:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdc278>
    80002eca:	84ca                	mv	s1,s2
    80002ecc:	bf9d                	j	80002e42 <namex+0xa4>
  if(nameiparent){
    80002ece:	f20b06e3          	beqz	s6,80002dfa <namex+0x5c>
    iput(ip);
    80002ed2:	8552                	mv	a0,s4
    80002ed4:	a07ff0ef          	jal	800028da <iput>
    return 0;
    80002ed8:	4a01                	li	s4,0
    80002eda:	b705                	j	80002dfa <namex+0x5c>

0000000080002edc <dirlink>:
{
    80002edc:	715d                	addi	sp,sp,-80
    80002ede:	e486                	sd	ra,72(sp)
    80002ee0:	e0a2                	sd	s0,64(sp)
    80002ee2:	f84a                	sd	s2,48(sp)
    80002ee4:	ec56                	sd	s5,24(sp)
    80002ee6:	e85a                	sd	s6,16(sp)
    80002ee8:	0880                	addi	s0,sp,80
    80002eea:	892a                	mv	s2,a0
    80002eec:	8aae                	mv	s5,a1
    80002eee:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80002ef0:	4601                	li	a2,0
    80002ef2:	e01ff0ef          	jal	80002cf2 <dirlookup>
    80002ef6:	ed1d                	bnez	a0,80002f34 <dirlink+0x58>
    80002ef8:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002efa:	04c92483          	lw	s1,76(s2)
    80002efe:	c4b9                	beqz	s1,80002f4c <dirlink+0x70>
    80002f00:	f44e                	sd	s3,40(sp)
    80002f02:	f052                	sd	s4,32(sp)
    80002f04:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f06:	fb040a13          	addi	s4,s0,-80
    80002f0a:	49c1                	li	s3,16
    80002f0c:	874e                	mv	a4,s3
    80002f0e:	86a6                	mv	a3,s1
    80002f10:	8652                	mv	a2,s4
    80002f12:	4581                	li	a1,0
    80002f14:	854a                	mv	a0,s2
    80002f16:	bd5ff0ef          	jal	80002aea <readi>
    80002f1a:	03351163          	bne	a0,s3,80002f3c <dirlink+0x60>
    if(de.inum == 0)
    80002f1e:	fb045783          	lhu	a5,-80(s0)
    80002f22:	c39d                	beqz	a5,80002f48 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002f24:	24c1                	addiw	s1,s1,16
    80002f26:	04c92783          	lw	a5,76(s2)
    80002f2a:	fef4e1e3          	bltu	s1,a5,80002f0c <dirlink+0x30>
    80002f2e:	79a2                	ld	s3,40(sp)
    80002f30:	7a02                	ld	s4,32(sp)
    80002f32:	a829                	j	80002f4c <dirlink+0x70>
    iput(ip);
    80002f34:	9a7ff0ef          	jal	800028da <iput>
    return -1;
    80002f38:	557d                	li	a0,-1
    80002f3a:	a83d                	j	80002f78 <dirlink+0x9c>
      panic("dirlink read");
    80002f3c:	00004517          	auipc	a0,0x4
    80002f40:	54450513          	addi	a0,a0,1348 # 80007480 <etext+0x480>
    80002f44:	7f2020ef          	jal	80005736 <panic>
    80002f48:	79a2                	ld	s3,40(sp)
    80002f4a:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    80002f4c:	4639                	li	a2,14
    80002f4e:	85d6                	mv	a1,s5
    80002f50:	fb240513          	addi	a0,s0,-78
    80002f54:	af8fd0ef          	jal	8000024c <strncpy>
  de.inum = inum;
    80002f58:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002f5c:	4741                	li	a4,16
    80002f5e:	86a6                	mv	a3,s1
    80002f60:	fb040613          	addi	a2,s0,-80
    80002f64:	4581                	li	a1,0
    80002f66:	854a                	mv	a0,s2
    80002f68:	c75ff0ef          	jal	80002bdc <writei>
    80002f6c:	1541                	addi	a0,a0,-16
    80002f6e:	00a03533          	snez	a0,a0
    80002f72:	40a0053b          	negw	a0,a0
    80002f76:	74e2                	ld	s1,56(sp)
}
    80002f78:	60a6                	ld	ra,72(sp)
    80002f7a:	6406                	ld	s0,64(sp)
    80002f7c:	7942                	ld	s2,48(sp)
    80002f7e:	6ae2                	ld	s5,24(sp)
    80002f80:	6b42                	ld	s6,16(sp)
    80002f82:	6161                	addi	sp,sp,80
    80002f84:	8082                	ret

0000000080002f86 <namei>:

struct inode*
namei(char *path)
{
    80002f86:	1101                	addi	sp,sp,-32
    80002f88:	ec06                	sd	ra,24(sp)
    80002f8a:	e822                	sd	s0,16(sp)
    80002f8c:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80002f8e:	fe040613          	addi	a2,s0,-32
    80002f92:	4581                	li	a1,0
    80002f94:	e0bff0ef          	jal	80002d9e <namex>
}
    80002f98:	60e2                	ld	ra,24(sp)
    80002f9a:	6442                	ld	s0,16(sp)
    80002f9c:	6105                	addi	sp,sp,32
    80002f9e:	8082                	ret

0000000080002fa0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    80002fa0:	1141                	addi	sp,sp,-16
    80002fa2:	e406                	sd	ra,8(sp)
    80002fa4:	e022                	sd	s0,0(sp)
    80002fa6:	0800                	addi	s0,sp,16
    80002fa8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80002faa:	4585                	li	a1,1
    80002fac:	df3ff0ef          	jal	80002d9e <namex>
}
    80002fb0:	60a2                	ld	ra,8(sp)
    80002fb2:	6402                	ld	s0,0(sp)
    80002fb4:	0141                	addi	sp,sp,16
    80002fb6:	8082                	ret

0000000080002fb8 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80002fb8:	1101                	addi	sp,sp,-32
    80002fba:	ec06                	sd	ra,24(sp)
    80002fbc:	e822                	sd	s0,16(sp)
    80002fbe:	e426                	sd	s1,8(sp)
    80002fc0:	e04a                	sd	s2,0(sp)
    80002fc2:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80002fc4:	00017917          	auipc	s2,0x17
    80002fc8:	aac90913          	addi	s2,s2,-1364 # 80019a70 <log>
    80002fcc:	01892583          	lw	a1,24(s2)
    80002fd0:	02492503          	lw	a0,36(s2)
    80002fd4:	8ecff0ef          	jal	800020c0 <bread>
    80002fd8:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80002fda:	02892603          	lw	a2,40(s2)
    80002fde:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80002fe0:	00c05f63          	blez	a2,80002ffe <write_head+0x46>
    80002fe4:	00017717          	auipc	a4,0x17
    80002fe8:	ab870713          	addi	a4,a4,-1352 # 80019a9c <log+0x2c>
    80002fec:	87aa                	mv	a5,a0
    80002fee:	060a                	slli	a2,a2,0x2
    80002ff0:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    80002ff2:	4314                	lw	a3,0(a4)
    80002ff4:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80002ff6:	0711                	addi	a4,a4,4
    80002ff8:	0791                	addi	a5,a5,4
    80002ffa:	fec79ce3          	bne	a5,a2,80002ff2 <write_head+0x3a>
  }
  bwrite(buf);
    80002ffe:	8526                	mv	a0,s1
    80003000:	996ff0ef          	jal	80002196 <bwrite>
  brelse(buf);
    80003004:	8526                	mv	a0,s1
    80003006:	9c2ff0ef          	jal	800021c8 <brelse>
}
    8000300a:	60e2                	ld	ra,24(sp)
    8000300c:	6442                	ld	s0,16(sp)
    8000300e:	64a2                	ld	s1,8(sp)
    80003010:	6902                	ld	s2,0(sp)
    80003012:	6105                	addi	sp,sp,32
    80003014:	8082                	ret

0000000080003016 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003016:	00017797          	auipc	a5,0x17
    8000301a:	a827a783          	lw	a5,-1406(a5) # 80019a98 <log+0x28>
    8000301e:	0cf05163          	blez	a5,800030e0 <install_trans+0xca>
{
    80003022:	715d                	addi	sp,sp,-80
    80003024:	e486                	sd	ra,72(sp)
    80003026:	e0a2                	sd	s0,64(sp)
    80003028:	fc26                	sd	s1,56(sp)
    8000302a:	f84a                	sd	s2,48(sp)
    8000302c:	f44e                	sd	s3,40(sp)
    8000302e:	f052                	sd	s4,32(sp)
    80003030:	ec56                	sd	s5,24(sp)
    80003032:	e85a                	sd	s6,16(sp)
    80003034:	e45e                	sd	s7,8(sp)
    80003036:	e062                	sd	s8,0(sp)
    80003038:	0880                	addi	s0,sp,80
    8000303a:	8b2a                	mv	s6,a0
    8000303c:	00017a97          	auipc	s5,0x17
    80003040:	a60a8a93          	addi	s5,s5,-1440 # 80019a9c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003044:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    80003046:	00004c17          	auipc	s8,0x4
    8000304a:	44ac0c13          	addi	s8,s8,1098 # 80007490 <etext+0x490>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000304e:	00017a17          	auipc	s4,0x17
    80003052:	a22a0a13          	addi	s4,s4,-1502 # 80019a70 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003056:	40000b93          	li	s7,1024
    8000305a:	a025                	j	80003082 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000305c:	000aa603          	lw	a2,0(s5)
    80003060:	85ce                	mv	a1,s3
    80003062:	8562                	mv	a0,s8
    80003064:	3a8020ef          	jal	8000540c <printf>
    80003068:	a839                	j	80003086 <install_trans+0x70>
    brelse(lbuf);
    8000306a:	854a                	mv	a0,s2
    8000306c:	95cff0ef          	jal	800021c8 <brelse>
    brelse(dbuf);
    80003070:	8526                	mv	a0,s1
    80003072:	956ff0ef          	jal	800021c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003076:	2985                	addiw	s3,s3,1
    80003078:	0a91                	addi	s5,s5,4
    8000307a:	028a2783          	lw	a5,40(s4)
    8000307e:	04f9d563          	bge	s3,a5,800030c8 <install_trans+0xb2>
    if(recovering) {
    80003082:	fc0b1de3          	bnez	s6,8000305c <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003086:	018a2583          	lw	a1,24(s4)
    8000308a:	013585bb          	addw	a1,a1,s3
    8000308e:	2585                	addiw	a1,a1,1
    80003090:	024a2503          	lw	a0,36(s4)
    80003094:	82cff0ef          	jal	800020c0 <bread>
    80003098:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    8000309a:	000aa583          	lw	a1,0(s5)
    8000309e:	024a2503          	lw	a0,36(s4)
    800030a2:	81eff0ef          	jal	800020c0 <bread>
    800030a6:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800030a8:	865e                	mv	a2,s7
    800030aa:	05890593          	addi	a1,s2,88
    800030ae:	05850513          	addi	a0,a0,88
    800030b2:	8ecfd0ef          	jal	8000019e <memmove>
    bwrite(dbuf);  // write dst to disk
    800030b6:	8526                	mv	a0,s1
    800030b8:	8deff0ef          	jal	80002196 <bwrite>
    if(recovering == 0)
    800030bc:	fa0b17e3          	bnez	s6,8000306a <install_trans+0x54>
      bunpin(dbuf);
    800030c0:	8526                	mv	a0,s1
    800030c2:	9beff0ef          	jal	80002280 <bunpin>
    800030c6:	b755                	j	8000306a <install_trans+0x54>
}
    800030c8:	60a6                	ld	ra,72(sp)
    800030ca:	6406                	ld	s0,64(sp)
    800030cc:	74e2                	ld	s1,56(sp)
    800030ce:	7942                	ld	s2,48(sp)
    800030d0:	79a2                	ld	s3,40(sp)
    800030d2:	7a02                	ld	s4,32(sp)
    800030d4:	6ae2                	ld	s5,24(sp)
    800030d6:	6b42                	ld	s6,16(sp)
    800030d8:	6ba2                	ld	s7,8(sp)
    800030da:	6c02                	ld	s8,0(sp)
    800030dc:	6161                	addi	sp,sp,80
    800030de:	8082                	ret
    800030e0:	8082                	ret

00000000800030e2 <initlog>:
{
    800030e2:	7179                	addi	sp,sp,-48
    800030e4:	f406                	sd	ra,40(sp)
    800030e6:	f022                	sd	s0,32(sp)
    800030e8:	ec26                	sd	s1,24(sp)
    800030ea:	e84a                	sd	s2,16(sp)
    800030ec:	e44e                	sd	s3,8(sp)
    800030ee:	1800                	addi	s0,sp,48
    800030f0:	84aa                	mv	s1,a0
    800030f2:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800030f4:	00017917          	auipc	s2,0x17
    800030f8:	97c90913          	addi	s2,s2,-1668 # 80019a70 <log>
    800030fc:	00004597          	auipc	a1,0x4
    80003100:	3b458593          	addi	a1,a1,948 # 800074b0 <etext+0x4b0>
    80003104:	854a                	mv	a0,s2
    80003106:	069020ef          	jal	8000596e <initlock>
  log.start = sb->logstart;
    8000310a:	0149a583          	lw	a1,20(s3)
    8000310e:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    80003112:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003116:	8526                	mv	a0,s1
    80003118:	fa9fe0ef          	jal	800020c0 <bread>
  log.lh.n = lh->n;
    8000311c:	4d30                	lw	a2,88(a0)
    8000311e:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    80003122:	00c05f63          	blez	a2,80003140 <initlog+0x5e>
    80003126:	87aa                	mv	a5,a0
    80003128:	00017717          	auipc	a4,0x17
    8000312c:	97470713          	addi	a4,a4,-1676 # 80019a9c <log+0x2c>
    80003130:	060a                	slli	a2,a2,0x2
    80003132:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    80003134:	4ff4                	lw	a3,92(a5)
    80003136:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003138:	0791                	addi	a5,a5,4
    8000313a:	0711                	addi	a4,a4,4
    8000313c:	fec79ce3          	bne	a5,a2,80003134 <initlog+0x52>
  brelse(buf);
    80003140:	888ff0ef          	jal	800021c8 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003144:	4505                	li	a0,1
    80003146:	ed1ff0ef          	jal	80003016 <install_trans>
  log.lh.n = 0;
    8000314a:	00017797          	auipc	a5,0x17
    8000314e:	9407a723          	sw	zero,-1714(a5) # 80019a98 <log+0x28>
  write_head(); // clear the log
    80003152:	e67ff0ef          	jal	80002fb8 <write_head>
}
    80003156:	70a2                	ld	ra,40(sp)
    80003158:	7402                	ld	s0,32(sp)
    8000315a:	64e2                	ld	s1,24(sp)
    8000315c:	6942                	ld	s2,16(sp)
    8000315e:	69a2                	ld	s3,8(sp)
    80003160:	6145                	addi	sp,sp,48
    80003162:	8082                	ret

0000000080003164 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003164:	1101                	addi	sp,sp,-32
    80003166:	ec06                	sd	ra,24(sp)
    80003168:	e822                	sd	s0,16(sp)
    8000316a:	e426                	sd	s1,8(sp)
    8000316c:	e04a                	sd	s2,0(sp)
    8000316e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003170:	00017517          	auipc	a0,0x17
    80003174:	90050513          	addi	a0,a0,-1792 # 80019a70 <log>
    80003178:	081020ef          	jal	800059f8 <acquire>
  while(1){
    if(log.committing){
    8000317c:	00017497          	auipc	s1,0x17
    80003180:	8f448493          	addi	s1,s1,-1804 # 80019a70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003184:	4979                	li	s2,30
    80003186:	a029                	j	80003190 <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003188:	85a6                	mv	a1,s1
    8000318a:	8526                	mv	a0,s1
    8000318c:	a0efe0ef          	jal	8000139a <sleep>
    if(log.committing){
    80003190:	509c                	lw	a5,32(s1)
    80003192:	fbfd                	bnez	a5,80003188 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003194:	4cd8                	lw	a4,28(s1)
    80003196:	2705                	addiw	a4,a4,1
    80003198:	0027179b          	slliw	a5,a4,0x2
    8000319c:	9fb9                	addw	a5,a5,a4
    8000319e:	0017979b          	slliw	a5,a5,0x1
    800031a2:	5494                	lw	a3,40(s1)
    800031a4:	9fb5                	addw	a5,a5,a3
    800031a6:	00f95763          	bge	s2,a5,800031b4 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800031aa:	85a6                	mv	a1,s1
    800031ac:	8526                	mv	a0,s1
    800031ae:	9ecfe0ef          	jal	8000139a <sleep>
    800031b2:	bff9                	j	80003190 <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    800031b4:	00017797          	auipc	a5,0x17
    800031b8:	8ce7ac23          	sw	a4,-1832(a5) # 80019a8c <log+0x1c>
      release(&log.lock);
    800031bc:	00017517          	auipc	a0,0x17
    800031c0:	8b450513          	addi	a0,a0,-1868 # 80019a70 <log>
    800031c4:	0c9020ef          	jal	80005a8c <release>
      break;
    }
  }
}
    800031c8:	60e2                	ld	ra,24(sp)
    800031ca:	6442                	ld	s0,16(sp)
    800031cc:	64a2                	ld	s1,8(sp)
    800031ce:	6902                	ld	s2,0(sp)
    800031d0:	6105                	addi	sp,sp,32
    800031d2:	8082                	ret

00000000800031d4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800031d4:	7139                	addi	sp,sp,-64
    800031d6:	fc06                	sd	ra,56(sp)
    800031d8:	f822                	sd	s0,48(sp)
    800031da:	f426                	sd	s1,40(sp)
    800031dc:	f04a                	sd	s2,32(sp)
    800031de:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800031e0:	00017497          	auipc	s1,0x17
    800031e4:	89048493          	addi	s1,s1,-1904 # 80019a70 <log>
    800031e8:	8526                	mv	a0,s1
    800031ea:	00f020ef          	jal	800059f8 <acquire>
  log.outstanding -= 1;
    800031ee:	4cdc                	lw	a5,28(s1)
    800031f0:	37fd                	addiw	a5,a5,-1
    800031f2:	893e                	mv	s2,a5
    800031f4:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800031f6:	509c                	lw	a5,32(s1)
    800031f8:	e7b1                	bnez	a5,80003244 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    800031fa:	04091e63          	bnez	s2,80003256 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    800031fe:	00017497          	auipc	s1,0x17
    80003202:	87248493          	addi	s1,s1,-1934 # 80019a70 <log>
    80003206:	4785                	li	a5,1
    80003208:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000320a:	8526                	mv	a0,s1
    8000320c:	081020ef          	jal	80005a8c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003210:	549c                	lw	a5,40(s1)
    80003212:	06f04463          	bgtz	a5,8000327a <end_op+0xa6>
    acquire(&log.lock);
    80003216:	00017517          	auipc	a0,0x17
    8000321a:	85a50513          	addi	a0,a0,-1958 # 80019a70 <log>
    8000321e:	7da020ef          	jal	800059f8 <acquire>
    log.committing = 0;
    80003222:	00017797          	auipc	a5,0x17
    80003226:	8607a723          	sw	zero,-1938(a5) # 80019a90 <log+0x20>
    wakeup(&log);
    8000322a:	00017517          	auipc	a0,0x17
    8000322e:	84650513          	addi	a0,a0,-1978 # 80019a70 <log>
    80003232:	9b4fe0ef          	jal	800013e6 <wakeup>
    release(&log.lock);
    80003236:	00017517          	auipc	a0,0x17
    8000323a:	83a50513          	addi	a0,a0,-1990 # 80019a70 <log>
    8000323e:	04f020ef          	jal	80005a8c <release>
}
    80003242:	a035                	j	8000326e <end_op+0x9a>
    80003244:	ec4e                	sd	s3,24(sp)
    80003246:	e852                	sd	s4,16(sp)
    80003248:	e456                	sd	s5,8(sp)
    panic("log.committing");
    8000324a:	00004517          	auipc	a0,0x4
    8000324e:	26e50513          	addi	a0,a0,622 # 800074b8 <etext+0x4b8>
    80003252:	4e4020ef          	jal	80005736 <panic>
    wakeup(&log);
    80003256:	00017517          	auipc	a0,0x17
    8000325a:	81a50513          	addi	a0,a0,-2022 # 80019a70 <log>
    8000325e:	988fe0ef          	jal	800013e6 <wakeup>
  release(&log.lock);
    80003262:	00017517          	auipc	a0,0x17
    80003266:	80e50513          	addi	a0,a0,-2034 # 80019a70 <log>
    8000326a:	023020ef          	jal	80005a8c <release>
}
    8000326e:	70e2                	ld	ra,56(sp)
    80003270:	7442                	ld	s0,48(sp)
    80003272:	74a2                	ld	s1,40(sp)
    80003274:	7902                	ld	s2,32(sp)
    80003276:	6121                	addi	sp,sp,64
    80003278:	8082                	ret
    8000327a:	ec4e                	sd	s3,24(sp)
    8000327c:	e852                	sd	s4,16(sp)
    8000327e:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    80003280:	00017a97          	auipc	s5,0x17
    80003284:	81ca8a93          	addi	s5,s5,-2020 # 80019a9c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003288:	00016a17          	auipc	s4,0x16
    8000328c:	7e8a0a13          	addi	s4,s4,2024 # 80019a70 <log>
    80003290:	018a2583          	lw	a1,24(s4)
    80003294:	012585bb          	addw	a1,a1,s2
    80003298:	2585                	addiw	a1,a1,1
    8000329a:	024a2503          	lw	a0,36(s4)
    8000329e:	e23fe0ef          	jal	800020c0 <bread>
    800032a2:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800032a4:	000aa583          	lw	a1,0(s5)
    800032a8:	024a2503          	lw	a0,36(s4)
    800032ac:	e15fe0ef          	jal	800020c0 <bread>
    800032b0:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800032b2:	40000613          	li	a2,1024
    800032b6:	05850593          	addi	a1,a0,88
    800032ba:	05848513          	addi	a0,s1,88
    800032be:	ee1fc0ef          	jal	8000019e <memmove>
    bwrite(to);  // write the log
    800032c2:	8526                	mv	a0,s1
    800032c4:	ed3fe0ef          	jal	80002196 <bwrite>
    brelse(from);
    800032c8:	854e                	mv	a0,s3
    800032ca:	efffe0ef          	jal	800021c8 <brelse>
    brelse(to);
    800032ce:	8526                	mv	a0,s1
    800032d0:	ef9fe0ef          	jal	800021c8 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800032d4:	2905                	addiw	s2,s2,1
    800032d6:	0a91                	addi	s5,s5,4
    800032d8:	028a2783          	lw	a5,40(s4)
    800032dc:	faf94ae3          	blt	s2,a5,80003290 <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800032e0:	cd9ff0ef          	jal	80002fb8 <write_head>
    install_trans(0); // Now install writes to home locations
    800032e4:	4501                	li	a0,0
    800032e6:	d31ff0ef          	jal	80003016 <install_trans>
    log.lh.n = 0;
    800032ea:	00016797          	auipc	a5,0x16
    800032ee:	7a07a723          	sw	zero,1966(a5) # 80019a98 <log+0x28>
    write_head();    // Erase the transaction from the log
    800032f2:	cc7ff0ef          	jal	80002fb8 <write_head>
    800032f6:	69e2                	ld	s3,24(sp)
    800032f8:	6a42                	ld	s4,16(sp)
    800032fa:	6aa2                	ld	s5,8(sp)
    800032fc:	bf29                	j	80003216 <end_op+0x42>

00000000800032fe <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800032fe:	1101                	addi	sp,sp,-32
    80003300:	ec06                	sd	ra,24(sp)
    80003302:	e822                	sd	s0,16(sp)
    80003304:	e426                	sd	s1,8(sp)
    80003306:	1000                	addi	s0,sp,32
    80003308:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000330a:	00016517          	auipc	a0,0x16
    8000330e:	76650513          	addi	a0,a0,1894 # 80019a70 <log>
    80003312:	6e6020ef          	jal	800059f8 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003316:	00016617          	auipc	a2,0x16
    8000331a:	78262603          	lw	a2,1922(a2) # 80019a98 <log+0x28>
    8000331e:	47f5                	li	a5,29
    80003320:	04c7cd63          	blt	a5,a2,8000337a <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003324:	00016797          	auipc	a5,0x16
    80003328:	7687a783          	lw	a5,1896(a5) # 80019a8c <log+0x1c>
    8000332c:	04f05d63          	blez	a5,80003386 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003330:	4781                	li	a5,0
    80003332:	06c05063          	blez	a2,80003392 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003336:	44cc                	lw	a1,12(s1)
    80003338:	00016717          	auipc	a4,0x16
    8000333c:	76470713          	addi	a4,a4,1892 # 80019a9c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    80003340:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003342:	4314                	lw	a3,0(a4)
    80003344:	04b68763          	beq	a3,a1,80003392 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    80003348:	2785                	addiw	a5,a5,1
    8000334a:	0711                	addi	a4,a4,4
    8000334c:	fef61be3          	bne	a2,a5,80003342 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003350:	060a                	slli	a2,a2,0x2
    80003352:	02060613          	addi	a2,a2,32
    80003356:	00016797          	auipc	a5,0x16
    8000335a:	71a78793          	addi	a5,a5,1818 # 80019a70 <log>
    8000335e:	97b2                	add	a5,a5,a2
    80003360:	44d8                	lw	a4,12(s1)
    80003362:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003364:	8526                	mv	a0,s1
    80003366:	ee7fe0ef          	jal	8000224c <bpin>
    log.lh.n++;
    8000336a:	00016717          	auipc	a4,0x16
    8000336e:	70670713          	addi	a4,a4,1798 # 80019a70 <log>
    80003372:	571c                	lw	a5,40(a4)
    80003374:	2785                	addiw	a5,a5,1
    80003376:	d71c                	sw	a5,40(a4)
    80003378:	a815                	j	800033ac <log_write+0xae>
    panic("too big a transaction");
    8000337a:	00004517          	auipc	a0,0x4
    8000337e:	14e50513          	addi	a0,a0,334 # 800074c8 <etext+0x4c8>
    80003382:	3b4020ef          	jal	80005736 <panic>
    panic("log_write outside of trans");
    80003386:	00004517          	auipc	a0,0x4
    8000338a:	15a50513          	addi	a0,a0,346 # 800074e0 <etext+0x4e0>
    8000338e:	3a8020ef          	jal	80005736 <panic>
  log.lh.block[i] = b->blockno;
    80003392:	00279693          	slli	a3,a5,0x2
    80003396:	02068693          	addi	a3,a3,32
    8000339a:	00016717          	auipc	a4,0x16
    8000339e:	6d670713          	addi	a4,a4,1750 # 80019a70 <log>
    800033a2:	9736                	add	a4,a4,a3
    800033a4:	44d4                	lw	a3,12(s1)
    800033a6:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800033a8:	faf60ee3          	beq	a2,a5,80003364 <log_write+0x66>
  }
  release(&log.lock);
    800033ac:	00016517          	auipc	a0,0x16
    800033b0:	6c450513          	addi	a0,a0,1732 # 80019a70 <log>
    800033b4:	6d8020ef          	jal	80005a8c <release>
}
    800033b8:	60e2                	ld	ra,24(sp)
    800033ba:	6442                	ld	s0,16(sp)
    800033bc:	64a2                	ld	s1,8(sp)
    800033be:	6105                	addi	sp,sp,32
    800033c0:	8082                	ret

00000000800033c2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800033c2:	1101                	addi	sp,sp,-32
    800033c4:	ec06                	sd	ra,24(sp)
    800033c6:	e822                	sd	s0,16(sp)
    800033c8:	e426                	sd	s1,8(sp)
    800033ca:	e04a                	sd	s2,0(sp)
    800033cc:	1000                	addi	s0,sp,32
    800033ce:	84aa                	mv	s1,a0
    800033d0:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800033d2:	00004597          	auipc	a1,0x4
    800033d6:	12e58593          	addi	a1,a1,302 # 80007500 <etext+0x500>
    800033da:	0521                	addi	a0,a0,8
    800033dc:	592020ef          	jal	8000596e <initlock>
  lk->name = name;
    800033e0:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800033e4:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800033e8:	0204a423          	sw	zero,40(s1)
}
    800033ec:	60e2                	ld	ra,24(sp)
    800033ee:	6442                	ld	s0,16(sp)
    800033f0:	64a2                	ld	s1,8(sp)
    800033f2:	6902                	ld	s2,0(sp)
    800033f4:	6105                	addi	sp,sp,32
    800033f6:	8082                	ret

00000000800033f8 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800033f8:	1101                	addi	sp,sp,-32
    800033fa:	ec06                	sd	ra,24(sp)
    800033fc:	e822                	sd	s0,16(sp)
    800033fe:	e426                	sd	s1,8(sp)
    80003400:	e04a                	sd	s2,0(sp)
    80003402:	1000                	addi	s0,sp,32
    80003404:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003406:	00850913          	addi	s2,a0,8
    8000340a:	854a                	mv	a0,s2
    8000340c:	5ec020ef          	jal	800059f8 <acquire>
  while (lk->locked) {
    80003410:	409c                	lw	a5,0(s1)
    80003412:	c799                	beqz	a5,80003420 <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    80003414:	85ca                	mv	a1,s2
    80003416:	8526                	mv	a0,s1
    80003418:	f83fd0ef          	jal	8000139a <sleep>
  while (lk->locked) {
    8000341c:	409c                	lw	a5,0(s1)
    8000341e:	fbfd                	bnez	a5,80003414 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    80003420:	4785                	li	a5,1
    80003422:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003424:	95bfd0ef          	jal	80000d7e <myproc>
    80003428:	591c                	lw	a5,48(a0)
    8000342a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000342c:	854a                	mv	a0,s2
    8000342e:	65e020ef          	jal	80005a8c <release>
}
    80003432:	60e2                	ld	ra,24(sp)
    80003434:	6442                	ld	s0,16(sp)
    80003436:	64a2                	ld	s1,8(sp)
    80003438:	6902                	ld	s2,0(sp)
    8000343a:	6105                	addi	sp,sp,32
    8000343c:	8082                	ret

000000008000343e <releasesleep>:

void
releasesleep(struct sleeplock *lk)
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
    80003452:	5a6020ef          	jal	800059f8 <acquire>
  lk->locked = 0;
    80003456:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000345a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000345e:	8526                	mv	a0,s1
    80003460:	f87fd0ef          	jal	800013e6 <wakeup>
  release(&lk->lk);
    80003464:	854a                	mv	a0,s2
    80003466:	626020ef          	jal	80005a8c <release>
}
    8000346a:	60e2                	ld	ra,24(sp)
    8000346c:	6442                	ld	s0,16(sp)
    8000346e:	64a2                	ld	s1,8(sp)
    80003470:	6902                	ld	s2,0(sp)
    80003472:	6105                	addi	sp,sp,32
    80003474:	8082                	ret

0000000080003476 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003476:	7179                	addi	sp,sp,-48
    80003478:	f406                	sd	ra,40(sp)
    8000347a:	f022                	sd	s0,32(sp)
    8000347c:	ec26                	sd	s1,24(sp)
    8000347e:	e84a                	sd	s2,16(sp)
    80003480:	1800                	addi	s0,sp,48
    80003482:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003484:	00850913          	addi	s2,a0,8
    80003488:	854a                	mv	a0,s2
    8000348a:	56e020ef          	jal	800059f8 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000348e:	409c                	lw	a5,0(s1)
    80003490:	ef81                	bnez	a5,800034a8 <holdingsleep+0x32>
    80003492:	4481                	li	s1,0
  release(&lk->lk);
    80003494:	854a                	mv	a0,s2
    80003496:	5f6020ef          	jal	80005a8c <release>
  return r;
}
    8000349a:	8526                	mv	a0,s1
    8000349c:	70a2                	ld	ra,40(sp)
    8000349e:	7402                	ld	s0,32(sp)
    800034a0:	64e2                	ld	s1,24(sp)
    800034a2:	6942                	ld	s2,16(sp)
    800034a4:	6145                	addi	sp,sp,48
    800034a6:	8082                	ret
    800034a8:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    800034aa:	0284a983          	lw	s3,40(s1)
    800034ae:	8d1fd0ef          	jal	80000d7e <myproc>
    800034b2:	5904                	lw	s1,48(a0)
    800034b4:	413484b3          	sub	s1,s1,s3
    800034b8:	0014b493          	seqz	s1,s1
    800034bc:	69a2                	ld	s3,8(sp)
    800034be:	bfd9                	j	80003494 <holdingsleep+0x1e>

00000000800034c0 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800034c0:	1141                	addi	sp,sp,-16
    800034c2:	e406                	sd	ra,8(sp)
    800034c4:	e022                	sd	s0,0(sp)
    800034c6:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800034c8:	00004597          	auipc	a1,0x4
    800034cc:	04858593          	addi	a1,a1,72 # 80007510 <etext+0x510>
    800034d0:	00016517          	auipc	a0,0x16
    800034d4:	6e850513          	addi	a0,a0,1768 # 80019bb8 <ftable>
    800034d8:	496020ef          	jal	8000596e <initlock>
}
    800034dc:	60a2                	ld	ra,8(sp)
    800034de:	6402                	ld	s0,0(sp)
    800034e0:	0141                	addi	sp,sp,16
    800034e2:	8082                	ret

00000000800034e4 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800034e4:	1101                	addi	sp,sp,-32
    800034e6:	ec06                	sd	ra,24(sp)
    800034e8:	e822                	sd	s0,16(sp)
    800034ea:	e426                	sd	s1,8(sp)
    800034ec:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800034ee:	00016517          	auipc	a0,0x16
    800034f2:	6ca50513          	addi	a0,a0,1738 # 80019bb8 <ftable>
    800034f6:	502020ef          	jal	800059f8 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800034fa:	00016497          	auipc	s1,0x16
    800034fe:	6d648493          	addi	s1,s1,1750 # 80019bd0 <ftable+0x18>
    80003502:	00017717          	auipc	a4,0x17
    80003506:	66e70713          	addi	a4,a4,1646 # 8001ab70 <disk>
    if(f->ref == 0){
    8000350a:	40dc                	lw	a5,4(s1)
    8000350c:	cf89                	beqz	a5,80003526 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    8000350e:	02848493          	addi	s1,s1,40
    80003512:	fee49ce3          	bne	s1,a4,8000350a <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003516:	00016517          	auipc	a0,0x16
    8000351a:	6a250513          	addi	a0,a0,1698 # 80019bb8 <ftable>
    8000351e:	56e020ef          	jal	80005a8c <release>
  return 0;
    80003522:	4481                	li	s1,0
    80003524:	a809                	j	80003536 <filealloc+0x52>
      f->ref = 1;
    80003526:	4785                	li	a5,1
    80003528:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    8000352a:	00016517          	auipc	a0,0x16
    8000352e:	68e50513          	addi	a0,a0,1678 # 80019bb8 <ftable>
    80003532:	55a020ef          	jal	80005a8c <release>
}
    80003536:	8526                	mv	a0,s1
    80003538:	60e2                	ld	ra,24(sp)
    8000353a:	6442                	ld	s0,16(sp)
    8000353c:	64a2                	ld	s1,8(sp)
    8000353e:	6105                	addi	sp,sp,32
    80003540:	8082                	ret

0000000080003542 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003542:	1101                	addi	sp,sp,-32
    80003544:	ec06                	sd	ra,24(sp)
    80003546:	e822                	sd	s0,16(sp)
    80003548:	e426                	sd	s1,8(sp)
    8000354a:	1000                	addi	s0,sp,32
    8000354c:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    8000354e:	00016517          	auipc	a0,0x16
    80003552:	66a50513          	addi	a0,a0,1642 # 80019bb8 <ftable>
    80003556:	4a2020ef          	jal	800059f8 <acquire>
  if(f->ref < 1)
    8000355a:	40dc                	lw	a5,4(s1)
    8000355c:	02f05063          	blez	a5,8000357c <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003560:	2785                	addiw	a5,a5,1
    80003562:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003564:	00016517          	auipc	a0,0x16
    80003568:	65450513          	addi	a0,a0,1620 # 80019bb8 <ftable>
    8000356c:	520020ef          	jal	80005a8c <release>
  return f;
}
    80003570:	8526                	mv	a0,s1
    80003572:	60e2                	ld	ra,24(sp)
    80003574:	6442                	ld	s0,16(sp)
    80003576:	64a2                	ld	s1,8(sp)
    80003578:	6105                	addi	sp,sp,32
    8000357a:	8082                	ret
    panic("filedup");
    8000357c:	00004517          	auipc	a0,0x4
    80003580:	f9c50513          	addi	a0,a0,-100 # 80007518 <etext+0x518>
    80003584:	1b2020ef          	jal	80005736 <panic>

0000000080003588 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003588:	7139                	addi	sp,sp,-64
    8000358a:	fc06                	sd	ra,56(sp)
    8000358c:	f822                	sd	s0,48(sp)
    8000358e:	f426                	sd	s1,40(sp)
    80003590:	0080                	addi	s0,sp,64
    80003592:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003594:	00016517          	auipc	a0,0x16
    80003598:	62450513          	addi	a0,a0,1572 # 80019bb8 <ftable>
    8000359c:	45c020ef          	jal	800059f8 <acquire>
  if(f->ref < 1)
    800035a0:	40dc                	lw	a5,4(s1)
    800035a2:	04f05a63          	blez	a5,800035f6 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    800035a6:	37fd                	addiw	a5,a5,-1
    800035a8:	c0dc                	sw	a5,4(s1)
    800035aa:	06f04063          	bgtz	a5,8000360a <fileclose+0x82>
    800035ae:	f04a                	sd	s2,32(sp)
    800035b0:	ec4e                	sd	s3,24(sp)
    800035b2:	e852                	sd	s4,16(sp)
    800035b4:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    800035b6:	0004a903          	lw	s2,0(s1)
    800035ba:	0094c783          	lbu	a5,9(s1)
    800035be:	89be                	mv	s3,a5
    800035c0:	689c                	ld	a5,16(s1)
    800035c2:	8a3e                	mv	s4,a5
    800035c4:	6c9c                	ld	a5,24(s1)
    800035c6:	8abe                	mv	s5,a5
  f->ref = 0;
    800035c8:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    800035cc:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    800035d0:	00016517          	auipc	a0,0x16
    800035d4:	5e850513          	addi	a0,a0,1512 # 80019bb8 <ftable>
    800035d8:	4b4020ef          	jal	80005a8c <release>

  if(ff.type == FD_PIPE){
    800035dc:	4785                	li	a5,1
    800035de:	04f90163          	beq	s2,a5,80003620 <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    800035e2:	ffe9079b          	addiw	a5,s2,-2
    800035e6:	4705                	li	a4,1
    800035e8:	04f77563          	bgeu	a4,a5,80003632 <fileclose+0xaa>
    800035ec:	7902                	ld	s2,32(sp)
    800035ee:	69e2                	ld	s3,24(sp)
    800035f0:	6a42                	ld	s4,16(sp)
    800035f2:	6aa2                	ld	s5,8(sp)
    800035f4:	a00d                	j	80003616 <fileclose+0x8e>
    800035f6:	f04a                	sd	s2,32(sp)
    800035f8:	ec4e                	sd	s3,24(sp)
    800035fa:	e852                	sd	s4,16(sp)
    800035fc:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800035fe:	00004517          	auipc	a0,0x4
    80003602:	f2250513          	addi	a0,a0,-222 # 80007520 <etext+0x520>
    80003606:	130020ef          	jal	80005736 <panic>
    release(&ftable.lock);
    8000360a:	00016517          	auipc	a0,0x16
    8000360e:	5ae50513          	addi	a0,a0,1454 # 80019bb8 <ftable>
    80003612:	47a020ef          	jal	80005a8c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003616:	70e2                	ld	ra,56(sp)
    80003618:	7442                	ld	s0,48(sp)
    8000361a:	74a2                	ld	s1,40(sp)
    8000361c:	6121                	addi	sp,sp,64
    8000361e:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003620:	85ce                	mv	a1,s3
    80003622:	8552                	mv	a0,s4
    80003624:	348000ef          	jal	8000396c <pipeclose>
    80003628:	7902                	ld	s2,32(sp)
    8000362a:	69e2                	ld	s3,24(sp)
    8000362c:	6a42                	ld	s4,16(sp)
    8000362e:	6aa2                	ld	s5,8(sp)
    80003630:	b7dd                	j	80003616 <fileclose+0x8e>
    begin_op();
    80003632:	b33ff0ef          	jal	80003164 <begin_op>
    iput(ff.ip);
    80003636:	8556                	mv	a0,s5
    80003638:	aa2ff0ef          	jal	800028da <iput>
    end_op();
    8000363c:	b99ff0ef          	jal	800031d4 <end_op>
    80003640:	7902                	ld	s2,32(sp)
    80003642:	69e2                	ld	s3,24(sp)
    80003644:	6a42                	ld	s4,16(sp)
    80003646:	6aa2                	ld	s5,8(sp)
    80003648:	b7f9                	j	80003616 <fileclose+0x8e>

000000008000364a <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    8000364a:	715d                	addi	sp,sp,-80
    8000364c:	e486                	sd	ra,72(sp)
    8000364e:	e0a2                	sd	s0,64(sp)
    80003650:	fc26                	sd	s1,56(sp)
    80003652:	f052                	sd	s4,32(sp)
    80003654:	0880                	addi	s0,sp,80
    80003656:	84aa                	mv	s1,a0
    80003658:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    8000365a:	f24fd0ef          	jal	80000d7e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000365e:	409c                	lw	a5,0(s1)
    80003660:	37f9                	addiw	a5,a5,-2
    80003662:	4705                	li	a4,1
    80003664:	04f76263          	bltu	a4,a5,800036a8 <filestat+0x5e>
    80003668:	f84a                	sd	s2,48(sp)
    8000366a:	f44e                	sd	s3,40(sp)
    8000366c:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000366e:	6c88                	ld	a0,24(s1)
    80003670:	8e8ff0ef          	jal	80002758 <ilock>
    stati(f->ip, &st);
    80003674:	fb840913          	addi	s2,s0,-72
    80003678:	85ca                	mv	a1,s2
    8000367a:	6c88                	ld	a0,24(s1)
    8000367c:	c40ff0ef          	jal	80002abc <stati>
    iunlock(f->ip);
    80003680:	6c88                	ld	a0,24(s1)
    80003682:	984ff0ef          	jal	80002806 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003686:	46e1                	li	a3,24
    80003688:	864a                	mv	a2,s2
    8000368a:	85d2                	mv	a1,s4
    8000368c:	0509b503          	ld	a0,80(s3)
    80003690:	c1efd0ef          	jal	80000aae <copyout>
    80003694:	41f5551b          	sraiw	a0,a0,0x1f
    80003698:	7942                	ld	s2,48(sp)
    8000369a:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000369c:	60a6                	ld	ra,72(sp)
    8000369e:	6406                	ld	s0,64(sp)
    800036a0:	74e2                	ld	s1,56(sp)
    800036a2:	7a02                	ld	s4,32(sp)
    800036a4:	6161                	addi	sp,sp,80
    800036a6:	8082                	ret
  return -1;
    800036a8:	557d                	li	a0,-1
    800036aa:	bfcd                	j	8000369c <filestat+0x52>

00000000800036ac <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    800036ac:	7179                	addi	sp,sp,-48
    800036ae:	f406                	sd	ra,40(sp)
    800036b0:	f022                	sd	s0,32(sp)
    800036b2:	e84a                	sd	s2,16(sp)
    800036b4:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    800036b6:	00854783          	lbu	a5,8(a0)
    800036ba:	cfd1                	beqz	a5,80003756 <fileread+0xaa>
    800036bc:	ec26                	sd	s1,24(sp)
    800036be:	e44e                	sd	s3,8(sp)
    800036c0:	84aa                	mv	s1,a0
    800036c2:	892e                	mv	s2,a1
    800036c4:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    800036c6:	411c                	lw	a5,0(a0)
    800036c8:	4705                	li	a4,1
    800036ca:	04e78363          	beq	a5,a4,80003710 <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    800036ce:	470d                	li	a4,3
    800036d0:	04e78763          	beq	a5,a4,8000371e <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    800036d4:	4709                	li	a4,2
    800036d6:	06e79a63          	bne	a5,a4,8000374a <fileread+0x9e>
    ilock(f->ip);
    800036da:	6d08                	ld	a0,24(a0)
    800036dc:	87cff0ef          	jal	80002758 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    800036e0:	874e                	mv	a4,s3
    800036e2:	5094                	lw	a3,32(s1)
    800036e4:	864a                	mv	a2,s2
    800036e6:	4585                	li	a1,1
    800036e8:	6c88                	ld	a0,24(s1)
    800036ea:	c00ff0ef          	jal	80002aea <readi>
    800036ee:	892a                	mv	s2,a0
    800036f0:	00a05563          	blez	a0,800036fa <fileread+0x4e>
      f->off += r;
    800036f4:	509c                	lw	a5,32(s1)
    800036f6:	9fa9                	addw	a5,a5,a0
    800036f8:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800036fa:	6c88                	ld	a0,24(s1)
    800036fc:	90aff0ef          	jal	80002806 <iunlock>
    80003700:	64e2                	ld	s1,24(sp)
    80003702:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003704:	854a                	mv	a0,s2
    80003706:	70a2                	ld	ra,40(sp)
    80003708:	7402                	ld	s0,32(sp)
    8000370a:	6942                	ld	s2,16(sp)
    8000370c:	6145                	addi	sp,sp,48
    8000370e:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003710:	6908                	ld	a0,16(a0)
    80003712:	3b0000ef          	jal	80003ac2 <piperead>
    80003716:	892a                	mv	s2,a0
    80003718:	64e2                	ld	s1,24(sp)
    8000371a:	69a2                	ld	s3,8(sp)
    8000371c:	b7e5                	j	80003704 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    8000371e:	02451783          	lh	a5,36(a0)
    80003722:	03079693          	slli	a3,a5,0x30
    80003726:	92c1                	srli	a3,a3,0x30
    80003728:	4725                	li	a4,9
    8000372a:	02d76963          	bltu	a4,a3,8000375c <fileread+0xb0>
    8000372e:	0792                	slli	a5,a5,0x4
    80003730:	00016717          	auipc	a4,0x16
    80003734:	3e870713          	addi	a4,a4,1000 # 80019b18 <devsw>
    80003738:	97ba                	add	a5,a5,a4
    8000373a:	639c                	ld	a5,0(a5)
    8000373c:	c78d                	beqz	a5,80003766 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    8000373e:	4505                	li	a0,1
    80003740:	9782                	jalr	a5
    80003742:	892a                	mv	s2,a0
    80003744:	64e2                	ld	s1,24(sp)
    80003746:	69a2                	ld	s3,8(sp)
    80003748:	bf75                	j	80003704 <fileread+0x58>
    panic("fileread");
    8000374a:	00004517          	auipc	a0,0x4
    8000374e:	de650513          	addi	a0,a0,-538 # 80007530 <etext+0x530>
    80003752:	7e5010ef          	jal	80005736 <panic>
    return -1;
    80003756:	57fd                	li	a5,-1
    80003758:	893e                	mv	s2,a5
    8000375a:	b76d                	j	80003704 <fileread+0x58>
      return -1;
    8000375c:	57fd                	li	a5,-1
    8000375e:	893e                	mv	s2,a5
    80003760:	64e2                	ld	s1,24(sp)
    80003762:	69a2                	ld	s3,8(sp)
    80003764:	b745                	j	80003704 <fileread+0x58>
    80003766:	57fd                	li	a5,-1
    80003768:	893e                	mv	s2,a5
    8000376a:	64e2                	ld	s1,24(sp)
    8000376c:	69a2                	ld	s3,8(sp)
    8000376e:	bf59                	j	80003704 <fileread+0x58>

0000000080003770 <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003770:	00954783          	lbu	a5,9(a0)
    80003774:	10078f63          	beqz	a5,80003892 <filewrite+0x122>
{
    80003778:	711d                	addi	sp,sp,-96
    8000377a:	ec86                	sd	ra,88(sp)
    8000377c:	e8a2                	sd	s0,80(sp)
    8000377e:	e0ca                	sd	s2,64(sp)
    80003780:	f456                	sd	s5,40(sp)
    80003782:	f05a                	sd	s6,32(sp)
    80003784:	1080                	addi	s0,sp,96
    80003786:	892a                	mv	s2,a0
    80003788:	8b2e                	mv	s6,a1
    8000378a:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000378c:	411c                	lw	a5,0(a0)
    8000378e:	4705                	li	a4,1
    80003790:	02e78a63          	beq	a5,a4,800037c4 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003794:	470d                	li	a4,3
    80003796:	02e78b63          	beq	a5,a4,800037cc <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    8000379a:	4709                	li	a4,2
    8000379c:	0ce79f63          	bne	a5,a4,8000387a <filewrite+0x10a>
    800037a0:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    800037a2:	0ac05a63          	blez	a2,80003856 <filewrite+0xe6>
    800037a6:	e4a6                	sd	s1,72(sp)
    800037a8:	fc4e                	sd	s3,56(sp)
    800037aa:	ec5e                	sd	s7,24(sp)
    800037ac:	e862                	sd	s8,16(sp)
    800037ae:	e466                	sd	s9,8(sp)
    int i = 0;
    800037b0:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    800037b2:	6b85                	lui	s7,0x1
    800037b4:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    800037b8:	6785                	lui	a5,0x1
    800037ba:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    800037be:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800037c0:	4c05                	li	s8,1
    800037c2:	a8ad                	j	8000383c <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    800037c4:	6908                	ld	a0,16(a0)
    800037c6:	204000ef          	jal	800039ca <pipewrite>
    800037ca:	a04d                	j	8000386c <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    800037cc:	02451783          	lh	a5,36(a0)
    800037d0:	03079693          	slli	a3,a5,0x30
    800037d4:	92c1                	srli	a3,a3,0x30
    800037d6:	4725                	li	a4,9
    800037d8:	0ad76f63          	bltu	a4,a3,80003896 <filewrite+0x126>
    800037dc:	0792                	slli	a5,a5,0x4
    800037de:	00016717          	auipc	a4,0x16
    800037e2:	33a70713          	addi	a4,a4,826 # 80019b18 <devsw>
    800037e6:	97ba                	add	a5,a5,a4
    800037e8:	679c                	ld	a5,8(a5)
    800037ea:	cbc5                	beqz	a5,8000389a <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    800037ec:	4505                	li	a0,1
    800037ee:	9782                	jalr	a5
    800037f0:	a8b5                	j	8000386c <filewrite+0xfc>
      if(n1 > max)
    800037f2:	2981                	sext.w	s3,s3
      begin_op();
    800037f4:	971ff0ef          	jal	80003164 <begin_op>
      ilock(f->ip);
    800037f8:	01893503          	ld	a0,24(s2)
    800037fc:	f5dfe0ef          	jal	80002758 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003800:	874e                	mv	a4,s3
    80003802:	02092683          	lw	a3,32(s2)
    80003806:	016a0633          	add	a2,s4,s6
    8000380a:	85e2                	mv	a1,s8
    8000380c:	01893503          	ld	a0,24(s2)
    80003810:	bccff0ef          	jal	80002bdc <writei>
    80003814:	84aa                	mv	s1,a0
    80003816:	00a05763          	blez	a0,80003824 <filewrite+0xb4>
        f->off += r;
    8000381a:	02092783          	lw	a5,32(s2)
    8000381e:	9fa9                	addw	a5,a5,a0
    80003820:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003824:	01893503          	ld	a0,24(s2)
    80003828:	fdffe0ef          	jal	80002806 <iunlock>
      end_op();
    8000382c:	9a9ff0ef          	jal	800031d4 <end_op>

      if(r != n1){
    80003830:	02999563          	bne	s3,s1,8000385a <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80003834:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003838:	015a5963          	bge	s4,s5,8000384a <filewrite+0xda>
      int n1 = n - i;
    8000383c:	414a87bb          	subw	a5,s5,s4
    80003840:	89be                	mv	s3,a5
      if(n1 > max)
    80003842:	fafbd8e3          	bge	s7,a5,800037f2 <filewrite+0x82>
    80003846:	89e6                	mv	s3,s9
    80003848:	b76d                	j	800037f2 <filewrite+0x82>
    8000384a:	64a6                	ld	s1,72(sp)
    8000384c:	79e2                	ld	s3,56(sp)
    8000384e:	6be2                	ld	s7,24(sp)
    80003850:	6c42                	ld	s8,16(sp)
    80003852:	6ca2                	ld	s9,8(sp)
    80003854:	a801                	j	80003864 <filewrite+0xf4>
    int i = 0;
    80003856:	4a01                	li	s4,0
    80003858:	a031                	j	80003864 <filewrite+0xf4>
    8000385a:	64a6                	ld	s1,72(sp)
    8000385c:	79e2                	ld	s3,56(sp)
    8000385e:	6be2                	ld	s7,24(sp)
    80003860:	6c42                	ld	s8,16(sp)
    80003862:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003864:	034a9d63          	bne	s5,s4,8000389e <filewrite+0x12e>
    80003868:	8556                	mv	a0,s5
    8000386a:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    8000386c:	60e6                	ld	ra,88(sp)
    8000386e:	6446                	ld	s0,80(sp)
    80003870:	6906                	ld	s2,64(sp)
    80003872:	7aa2                	ld	s5,40(sp)
    80003874:	7b02                	ld	s6,32(sp)
    80003876:	6125                	addi	sp,sp,96
    80003878:	8082                	ret
    8000387a:	e4a6                	sd	s1,72(sp)
    8000387c:	fc4e                	sd	s3,56(sp)
    8000387e:	f852                	sd	s4,48(sp)
    80003880:	ec5e                	sd	s7,24(sp)
    80003882:	e862                	sd	s8,16(sp)
    80003884:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003886:	00004517          	auipc	a0,0x4
    8000388a:	cba50513          	addi	a0,a0,-838 # 80007540 <etext+0x540>
    8000388e:	6a9010ef          	jal	80005736 <panic>
    return -1;
    80003892:	557d                	li	a0,-1
}
    80003894:	8082                	ret
      return -1;
    80003896:	557d                	li	a0,-1
    80003898:	bfd1                	j	8000386c <filewrite+0xfc>
    8000389a:	557d                	li	a0,-1
    8000389c:	bfc1                	j	8000386c <filewrite+0xfc>
    ret = (i == n ? n : -1);
    8000389e:	557d                	li	a0,-1
    800038a0:	7a42                	ld	s4,48(sp)
    800038a2:	b7e9                	j	8000386c <filewrite+0xfc>

00000000800038a4 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    800038a4:	7179                	addi	sp,sp,-48
    800038a6:	f406                	sd	ra,40(sp)
    800038a8:	f022                	sd	s0,32(sp)
    800038aa:	ec26                	sd	s1,24(sp)
    800038ac:	e052                	sd	s4,0(sp)
    800038ae:	1800                	addi	s0,sp,48
    800038b0:	84aa                	mv	s1,a0
    800038b2:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    800038b4:	0005b023          	sd	zero,0(a1)
    800038b8:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    800038bc:	c29ff0ef          	jal	800034e4 <filealloc>
    800038c0:	e088                	sd	a0,0(s1)
    800038c2:	c549                	beqz	a0,8000394c <pipealloc+0xa8>
    800038c4:	c21ff0ef          	jal	800034e4 <filealloc>
    800038c8:	00aa3023          	sd	a0,0(s4)
    800038cc:	cd25                	beqz	a0,80003944 <pipealloc+0xa0>
    800038ce:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    800038d0:	82dfc0ef          	jal	800000fc <kalloc>
    800038d4:	892a                	mv	s2,a0
    800038d6:	c12d                	beqz	a0,80003938 <pipealloc+0x94>
    800038d8:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    800038da:	4985                	li	s3,1
    800038dc:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    800038e0:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    800038e4:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    800038e8:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    800038ec:	00004597          	auipc	a1,0x4
    800038f0:	c6458593          	addi	a1,a1,-924 # 80007550 <etext+0x550>
    800038f4:	07a020ef          	jal	8000596e <initlock>
  (*f0)->type = FD_PIPE;
    800038f8:	609c                	ld	a5,0(s1)
    800038fa:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    800038fe:	609c                	ld	a5,0(s1)
    80003900:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003904:	609c                	ld	a5,0(s1)
    80003906:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    8000390a:	609c                	ld	a5,0(s1)
    8000390c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003910:	000a3783          	ld	a5,0(s4)
    80003914:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003918:	000a3783          	ld	a5,0(s4)
    8000391c:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003920:	000a3783          	ld	a5,0(s4)
    80003924:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003928:	000a3783          	ld	a5,0(s4)
    8000392c:	0127b823          	sd	s2,16(a5)
  return 0;
    80003930:	4501                	li	a0,0
    80003932:	6942                	ld	s2,16(sp)
    80003934:	69a2                	ld	s3,8(sp)
    80003936:	a01d                	j	8000395c <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003938:	6088                	ld	a0,0(s1)
    8000393a:	c119                	beqz	a0,80003940 <pipealloc+0x9c>
    8000393c:	6942                	ld	s2,16(sp)
    8000393e:	a029                	j	80003948 <pipealloc+0xa4>
    80003940:	6942                	ld	s2,16(sp)
    80003942:	a029                	j	8000394c <pipealloc+0xa8>
    80003944:	6088                	ld	a0,0(s1)
    80003946:	c10d                	beqz	a0,80003968 <pipealloc+0xc4>
    fileclose(*f0);
    80003948:	c41ff0ef          	jal	80003588 <fileclose>
  if(*f1)
    8000394c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003950:	557d                	li	a0,-1
  if(*f1)
    80003952:	c789                	beqz	a5,8000395c <pipealloc+0xb8>
    fileclose(*f1);
    80003954:	853e                	mv	a0,a5
    80003956:	c33ff0ef          	jal	80003588 <fileclose>
  return -1;
    8000395a:	557d                	li	a0,-1
}
    8000395c:	70a2                	ld	ra,40(sp)
    8000395e:	7402                	ld	s0,32(sp)
    80003960:	64e2                	ld	s1,24(sp)
    80003962:	6a02                	ld	s4,0(sp)
    80003964:	6145                	addi	sp,sp,48
    80003966:	8082                	ret
  return -1;
    80003968:	557d                	li	a0,-1
    8000396a:	bfcd                	j	8000395c <pipealloc+0xb8>

000000008000396c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    8000396c:	1101                	addi	sp,sp,-32
    8000396e:	ec06                	sd	ra,24(sp)
    80003970:	e822                	sd	s0,16(sp)
    80003972:	e426                	sd	s1,8(sp)
    80003974:	e04a                	sd	s2,0(sp)
    80003976:	1000                	addi	s0,sp,32
    80003978:	84aa                	mv	s1,a0
    8000397a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    8000397c:	07c020ef          	jal	800059f8 <acquire>
  if(writable){
    80003980:	02090763          	beqz	s2,800039ae <pipeclose+0x42>
    pi->writeopen = 0;
    80003984:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003988:	21848513          	addi	a0,s1,536
    8000398c:	a5bfd0ef          	jal	800013e6 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003990:	2204a783          	lw	a5,544(s1)
    80003994:	e781                	bnez	a5,8000399c <pipeclose+0x30>
    80003996:	2244a783          	lw	a5,548(s1)
    8000399a:	c38d                	beqz	a5,800039bc <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    8000399c:	8526                	mv	a0,s1
    8000399e:	0ee020ef          	jal	80005a8c <release>
}
    800039a2:	60e2                	ld	ra,24(sp)
    800039a4:	6442                	ld	s0,16(sp)
    800039a6:	64a2                	ld	s1,8(sp)
    800039a8:	6902                	ld	s2,0(sp)
    800039aa:	6105                	addi	sp,sp,32
    800039ac:	8082                	ret
    pi->readopen = 0;
    800039ae:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    800039b2:	21c48513          	addi	a0,s1,540
    800039b6:	a31fd0ef          	jal	800013e6 <wakeup>
    800039ba:	bfd9                	j	80003990 <pipeclose+0x24>
    release(&pi->lock);
    800039bc:	8526                	mv	a0,s1
    800039be:	0ce020ef          	jal	80005a8c <release>
    kfree((char*)pi);
    800039c2:	8526                	mv	a0,s1
    800039c4:	e58fc0ef          	jal	8000001c <kfree>
    800039c8:	bfe9                	j	800039a2 <pipeclose+0x36>

00000000800039ca <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    800039ca:	7159                	addi	sp,sp,-112
    800039cc:	f486                	sd	ra,104(sp)
    800039ce:	f0a2                	sd	s0,96(sp)
    800039d0:	eca6                	sd	s1,88(sp)
    800039d2:	e8ca                	sd	s2,80(sp)
    800039d4:	e4ce                	sd	s3,72(sp)
    800039d6:	e0d2                	sd	s4,64(sp)
    800039d8:	fc56                	sd	s5,56(sp)
    800039da:	1880                	addi	s0,sp,112
    800039dc:	84aa                	mv	s1,a0
    800039de:	8aae                	mv	s5,a1
    800039e0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    800039e2:	b9cfd0ef          	jal	80000d7e <myproc>
    800039e6:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    800039e8:	8526                	mv	a0,s1
    800039ea:	00e020ef          	jal	800059f8 <acquire>
  while(i < n){
    800039ee:	0d405263          	blez	s4,80003ab2 <pipewrite+0xe8>
    800039f2:	f85a                	sd	s6,48(sp)
    800039f4:	f45e                	sd	s7,40(sp)
    800039f6:	f062                	sd	s8,32(sp)
    800039f8:	ec66                	sd	s9,24(sp)
    800039fa:	e86a                	sd	s10,16(sp)
  int i = 0;
    800039fc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    800039fe:	f9f40c13          	addi	s8,s0,-97
    80003a02:	4b85                	li	s7,1
    80003a04:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003a06:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003a0a:	21c48c93          	addi	s9,s1,540
    80003a0e:	a82d                	j	80003a48 <pipewrite+0x7e>
      release(&pi->lock);
    80003a10:	8526                	mv	a0,s1
    80003a12:	07a020ef          	jal	80005a8c <release>
      return -1;
    80003a16:	597d                	li	s2,-1
    80003a18:	7b42                	ld	s6,48(sp)
    80003a1a:	7ba2                	ld	s7,40(sp)
    80003a1c:	7c02                	ld	s8,32(sp)
    80003a1e:	6ce2                	ld	s9,24(sp)
    80003a20:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003a22:	854a                	mv	a0,s2
    80003a24:	70a6                	ld	ra,104(sp)
    80003a26:	7406                	ld	s0,96(sp)
    80003a28:	64e6                	ld	s1,88(sp)
    80003a2a:	6946                	ld	s2,80(sp)
    80003a2c:	69a6                	ld	s3,72(sp)
    80003a2e:	6a06                	ld	s4,64(sp)
    80003a30:	7ae2                	ld	s5,56(sp)
    80003a32:	6165                	addi	sp,sp,112
    80003a34:	8082                	ret
      wakeup(&pi->nread);
    80003a36:	856a                	mv	a0,s10
    80003a38:	9affd0ef          	jal	800013e6 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003a3c:	85a6                	mv	a1,s1
    80003a3e:	8566                	mv	a0,s9
    80003a40:	95bfd0ef          	jal	8000139a <sleep>
  while(i < n){
    80003a44:	05495a63          	bge	s2,s4,80003a98 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003a48:	2204a783          	lw	a5,544(s1)
    80003a4c:	d3f1                	beqz	a5,80003a10 <pipewrite+0x46>
    80003a4e:	854e                	mv	a0,s3
    80003a50:	b87fd0ef          	jal	800015d6 <killed>
    80003a54:	fd55                	bnez	a0,80003a10 <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003a56:	2184a783          	lw	a5,536(s1)
    80003a5a:	21c4a703          	lw	a4,540(s1)
    80003a5e:	2007879b          	addiw	a5,a5,512
    80003a62:	fcf70ae3          	beq	a4,a5,80003a36 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003a66:	86de                	mv	a3,s7
    80003a68:	01590633          	add	a2,s2,s5
    80003a6c:	85e2                	mv	a1,s8
    80003a6e:	0509b503          	ld	a0,80(s3)
    80003a72:	900fd0ef          	jal	80000b72 <copyin>
    80003a76:	05650063          	beq	a0,s6,80003ab6 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003a7a:	21c4a783          	lw	a5,540(s1)
    80003a7e:	0017871b          	addiw	a4,a5,1
    80003a82:	20e4ae23          	sw	a4,540(s1)
    80003a86:	1ff7f793          	andi	a5,a5,511
    80003a8a:	97a6                	add	a5,a5,s1
    80003a8c:	f9f44703          	lbu	a4,-97(s0)
    80003a90:	00e78c23          	sb	a4,24(a5)
      i++;
    80003a94:	2905                	addiw	s2,s2,1
    80003a96:	b77d                	j	80003a44 <pipewrite+0x7a>
    80003a98:	7b42                	ld	s6,48(sp)
    80003a9a:	7ba2                	ld	s7,40(sp)
    80003a9c:	7c02                	ld	s8,32(sp)
    80003a9e:	6ce2                	ld	s9,24(sp)
    80003aa0:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003aa2:	21848513          	addi	a0,s1,536
    80003aa6:	941fd0ef          	jal	800013e6 <wakeup>
  release(&pi->lock);
    80003aaa:	8526                	mv	a0,s1
    80003aac:	7e1010ef          	jal	80005a8c <release>
  return i;
    80003ab0:	bf8d                	j	80003a22 <pipewrite+0x58>
  int i = 0;
    80003ab2:	4901                	li	s2,0
    80003ab4:	b7fd                	j	80003aa2 <pipewrite+0xd8>
    80003ab6:	7b42                	ld	s6,48(sp)
    80003ab8:	7ba2                	ld	s7,40(sp)
    80003aba:	7c02                	ld	s8,32(sp)
    80003abc:	6ce2                	ld	s9,24(sp)
    80003abe:	6d42                	ld	s10,16(sp)
    80003ac0:	b7cd                	j	80003aa2 <pipewrite+0xd8>

0000000080003ac2 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003ac2:	711d                	addi	sp,sp,-96
    80003ac4:	ec86                	sd	ra,88(sp)
    80003ac6:	e8a2                	sd	s0,80(sp)
    80003ac8:	e4a6                	sd	s1,72(sp)
    80003aca:	e0ca                	sd	s2,64(sp)
    80003acc:	fc4e                	sd	s3,56(sp)
    80003ace:	f852                	sd	s4,48(sp)
    80003ad0:	f456                	sd	s5,40(sp)
    80003ad2:	1080                	addi	s0,sp,96
    80003ad4:	84aa                	mv	s1,a0
    80003ad6:	892e                	mv	s2,a1
    80003ad8:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003ada:	aa4fd0ef          	jal	80000d7e <myproc>
    80003ade:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003ae0:	8526                	mv	a0,s1
    80003ae2:	717010ef          	jal	800059f8 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ae6:	2184a703          	lw	a4,536(s1)
    80003aea:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003aee:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003af2:	02f71763          	bne	a4,a5,80003b20 <piperead+0x5e>
    80003af6:	2244a783          	lw	a5,548(s1)
    80003afa:	cf85                	beqz	a5,80003b32 <piperead+0x70>
    if(killed(pr)){
    80003afc:	8552                	mv	a0,s4
    80003afe:	ad9fd0ef          	jal	800015d6 <killed>
    80003b02:	e11d                	bnez	a0,80003b28 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003b04:	85a6                	mv	a1,s1
    80003b06:	854e                	mv	a0,s3
    80003b08:	893fd0ef          	jal	8000139a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003b0c:	2184a703          	lw	a4,536(s1)
    80003b10:	21c4a783          	lw	a5,540(s1)
    80003b14:	fef701e3          	beq	a4,a5,80003af6 <piperead+0x34>
    80003b18:	f05a                	sd	s6,32(sp)
    80003b1a:	ec5e                	sd	s7,24(sp)
    80003b1c:	e862                	sd	s8,16(sp)
    80003b1e:	a829                	j	80003b38 <piperead+0x76>
    80003b20:	f05a                	sd	s6,32(sp)
    80003b22:	ec5e                	sd	s7,24(sp)
    80003b24:	e862                	sd	s8,16(sp)
    80003b26:	a809                	j	80003b38 <piperead+0x76>
      release(&pi->lock);
    80003b28:	8526                	mv	a0,s1
    80003b2a:	763010ef          	jal	80005a8c <release>
      return -1;
    80003b2e:	59fd                	li	s3,-1
    80003b30:	a09d                	j	80003b96 <piperead+0xd4>
    80003b32:	f05a                	sd	s6,32(sp)
    80003b34:	ec5e                	sd	s7,24(sp)
    80003b36:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b38:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b3a:	faf40c13          	addi	s8,s0,-81
    80003b3e:	4b85                	li	s7,1
    80003b40:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b42:	05505063          	blez	s5,80003b82 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003b46:	2184a783          	lw	a5,536(s1)
    80003b4a:	21c4a703          	lw	a4,540(s1)
    80003b4e:	02f70a63          	beq	a4,a5,80003b82 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003b52:	0017871b          	addiw	a4,a5,1
    80003b56:	20e4ac23          	sw	a4,536(s1)
    80003b5a:	1ff7f793          	andi	a5,a5,511
    80003b5e:	97a6                	add	a5,a5,s1
    80003b60:	0187c783          	lbu	a5,24(a5)
    80003b64:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003b68:	86de                	mv	a3,s7
    80003b6a:	8662                	mv	a2,s8
    80003b6c:	85ca                	mv	a1,s2
    80003b6e:	050a3503          	ld	a0,80(s4)
    80003b72:	f3dfc0ef          	jal	80000aae <copyout>
    80003b76:	01650663          	beq	a0,s6,80003b82 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003b7a:	2985                	addiw	s3,s3,1
    80003b7c:	0905                	addi	s2,s2,1
    80003b7e:	fd3a94e3          	bne	s5,s3,80003b46 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003b82:	21c48513          	addi	a0,s1,540
    80003b86:	861fd0ef          	jal	800013e6 <wakeup>
  release(&pi->lock);
    80003b8a:	8526                	mv	a0,s1
    80003b8c:	701010ef          	jal	80005a8c <release>
    80003b90:	7b02                	ld	s6,32(sp)
    80003b92:	6be2                	ld	s7,24(sp)
    80003b94:	6c42                	ld	s8,16(sp)
  return i;
}
    80003b96:	854e                	mv	a0,s3
    80003b98:	60e6                	ld	ra,88(sp)
    80003b9a:	6446                	ld	s0,80(sp)
    80003b9c:	64a6                	ld	s1,72(sp)
    80003b9e:	6906                	ld	s2,64(sp)
    80003ba0:	79e2                	ld	s3,56(sp)
    80003ba2:	7a42                	ld	s4,48(sp)
    80003ba4:	7aa2                	ld	s5,40(sp)
    80003ba6:	6125                	addi	sp,sp,96
    80003ba8:	8082                	ret

0000000080003baa <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003baa:	1141                	addi	sp,sp,-16
    80003bac:	e406                	sd	ra,8(sp)
    80003bae:	e022                	sd	s0,0(sp)
    80003bb0:	0800                	addi	s0,sp,16
    80003bb2:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003bb4:	0035151b          	slliw	a0,a0,0x3
    80003bb8:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003bba:	8b89                	andi	a5,a5,2
    80003bbc:	c399                	beqz	a5,80003bc2 <flags2perm+0x18>
      perm |= PTE_W;
    80003bbe:	00456513          	ori	a0,a0,4
    return perm;
}
    80003bc2:	60a2                	ld	ra,8(sp)
    80003bc4:	6402                	ld	s0,0(sp)
    80003bc6:	0141                	addi	sp,sp,16
    80003bc8:	8082                	ret

0000000080003bca <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003bca:	de010113          	addi	sp,sp,-544
    80003bce:	20113c23          	sd	ra,536(sp)
    80003bd2:	20813823          	sd	s0,528(sp)
    80003bd6:	20913423          	sd	s1,520(sp)
    80003bda:	21213023          	sd	s2,512(sp)
    80003bde:	1400                	addi	s0,sp,544
    80003be0:	892a                	mv	s2,a0
    80003be2:	dea43823          	sd	a0,-528(s0)
    80003be6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003bea:	994fd0ef          	jal	80000d7e <myproc>
    80003bee:	84aa                	mv	s1,a0

  begin_op();
    80003bf0:	d74ff0ef          	jal	80003164 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003bf4:	854a                	mv	a0,s2
    80003bf6:	b90ff0ef          	jal	80002f86 <namei>
    80003bfa:	cd21                	beqz	a0,80003c52 <kexec+0x88>
    80003bfc:	fbd2                	sd	s4,496(sp)
    80003bfe:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003c00:	b59fe0ef          	jal	80002758 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003c04:	04000713          	li	a4,64
    80003c08:	4681                	li	a3,0
    80003c0a:	e5040613          	addi	a2,s0,-432
    80003c0e:	4581                	li	a1,0
    80003c10:	8552                	mv	a0,s4
    80003c12:	ed9fe0ef          	jal	80002aea <readi>
    80003c16:	04000793          	li	a5,64
    80003c1a:	00f51a63          	bne	a0,a5,80003c2e <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003c1e:	e5042703          	lw	a4,-432(s0)
    80003c22:	464c47b7          	lui	a5,0x464c4
    80003c26:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003c2a:	02f70863          	beq	a4,a5,80003c5a <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003c2e:	8552                	mv	a0,s4
    80003c30:	d35fe0ef          	jal	80002964 <iunlockput>
    end_op();
    80003c34:	da0ff0ef          	jal	800031d4 <end_op>
  }
  return -1;
    80003c38:	557d                	li	a0,-1
    80003c3a:	7a5e                	ld	s4,496(sp)
}
    80003c3c:	21813083          	ld	ra,536(sp)
    80003c40:	21013403          	ld	s0,528(sp)
    80003c44:	20813483          	ld	s1,520(sp)
    80003c48:	20013903          	ld	s2,512(sp)
    80003c4c:	22010113          	addi	sp,sp,544
    80003c50:	8082                	ret
    end_op();
    80003c52:	d82ff0ef          	jal	800031d4 <end_op>
    return -1;
    80003c56:	557d                	li	a0,-1
    80003c58:	b7d5                	j	80003c3c <kexec+0x72>
    80003c5a:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003c5c:	8526                	mv	a0,s1
    80003c5e:	a2afd0ef          	jal	80000e88 <proc_pagetable>
    80003c62:	8b2a                	mv	s6,a0
    80003c64:	26050f63          	beqz	a0,80003ee2 <kexec+0x318>
    80003c68:	ffce                	sd	s3,504(sp)
    80003c6a:	f7d6                	sd	s5,488(sp)
    80003c6c:	efde                	sd	s7,472(sp)
    80003c6e:	ebe2                	sd	s8,464(sp)
    80003c70:	e7e6                	sd	s9,456(sp)
    80003c72:	e3ea                	sd	s10,448(sp)
    80003c74:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c76:	e8845783          	lhu	a5,-376(s0)
    80003c7a:	0e078963          	beqz	a5,80003d6c <kexec+0x1a2>
    80003c7e:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003c82:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003c84:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003c86:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003c8a:	6c85                	lui	s9,0x1
    80003c8c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003c90:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003c94:	6a85                	lui	s5,0x1
    80003c96:	a085                	j	80003cf6 <kexec+0x12c>
      panic("loadseg: address should exist");
    80003c98:	00004517          	auipc	a0,0x4
    80003c9c:	8c050513          	addi	a0,a0,-1856 # 80007558 <etext+0x558>
    80003ca0:	297010ef          	jal	80005736 <panic>
    if(sz - i < PGSIZE)
    80003ca4:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003ca6:	874a                	mv	a4,s2
    80003ca8:	009b86bb          	addw	a3,s7,s1
    80003cac:	4581                	li	a1,0
    80003cae:	8552                	mv	a0,s4
    80003cb0:	e3bfe0ef          	jal	80002aea <readi>
    80003cb4:	22a91b63          	bne	s2,a0,80003eea <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80003cb8:	009a84bb          	addw	s1,s5,s1
    80003cbc:	0334f263          	bgeu	s1,s3,80003ce0 <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003cc0:	02049593          	slli	a1,s1,0x20
    80003cc4:	9181                	srli	a1,a1,0x20
    80003cc6:	95e2                	add	a1,a1,s8
    80003cc8:	855a                	mv	a0,s6
    80003cca:	fa2fc0ef          	jal	8000046c <walkaddr>
    80003cce:	862a                	mv	a2,a0
    if(pa == 0)
    80003cd0:	d561                	beqz	a0,80003c98 <kexec+0xce>
    if(sz - i < PGSIZE)
    80003cd2:	409987bb          	subw	a5,s3,s1
    80003cd6:	893e                	mv	s2,a5
    80003cd8:	fcfcf6e3          	bgeu	s9,a5,80003ca4 <kexec+0xda>
    80003cdc:	8956                	mv	s2,s5
    80003cde:	b7d9                	j	80003ca4 <kexec+0xda>
    sz = sz1;
    80003ce0:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003ce4:	2d05                	addiw	s10,s10,1
    80003ce6:	e0843783          	ld	a5,-504(s0)
    80003cea:	0387869b          	addiw	a3,a5,56
    80003cee:	e8845783          	lhu	a5,-376(s0)
    80003cf2:	06fd5e63          	bge	s10,a5,80003d6e <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003cf6:	e0d43423          	sd	a3,-504(s0)
    80003cfa:	876e                	mv	a4,s11
    80003cfc:	e1840613          	addi	a2,s0,-488
    80003d00:	4581                	li	a1,0
    80003d02:	8552                	mv	a0,s4
    80003d04:	de7fe0ef          	jal	80002aea <readi>
    80003d08:	1db51f63          	bne	a0,s11,80003ee6 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80003d0c:	e1842783          	lw	a5,-488(s0)
    80003d10:	4705                	li	a4,1
    80003d12:	fce799e3          	bne	a5,a4,80003ce4 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003d16:	e4043483          	ld	s1,-448(s0)
    80003d1a:	e3843783          	ld	a5,-456(s0)
    80003d1e:	1ef4e463          	bltu	s1,a5,80003f06 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003d22:	e2843783          	ld	a5,-472(s0)
    80003d26:	94be                	add	s1,s1,a5
    80003d28:	1ef4e263          	bltu	s1,a5,80003f0c <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80003d2c:	de843703          	ld	a4,-536(s0)
    80003d30:	8ff9                	and	a5,a5,a4
    80003d32:	1e079063          	bnez	a5,80003f12 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003d36:	e1c42503          	lw	a0,-484(s0)
    80003d3a:	e71ff0ef          	jal	80003baa <flags2perm>
    80003d3e:	86aa                	mv	a3,a0
    80003d40:	8626                	mv	a2,s1
    80003d42:	85ca                	mv	a1,s2
    80003d44:	855a                	mv	a0,s6
    80003d46:	a19fc0ef          	jal	8000075e <uvmalloc>
    80003d4a:	dea43c23          	sd	a0,-520(s0)
    80003d4e:	1c050563          	beqz	a0,80003f18 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d52:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d56:	00098863          	beqz	s3,80003d66 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003d5a:	e2843c03          	ld	s8,-472(s0)
    80003d5e:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003d62:	4481                	li	s1,0
    80003d64:	bfb1                	j	80003cc0 <kexec+0xf6>
    sz = sz1;
    80003d66:	df843903          	ld	s2,-520(s0)
    80003d6a:	bfad                	j	80003ce4 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003d6c:	4901                	li	s2,0
  iunlockput(ip);
    80003d6e:	8552                	mv	a0,s4
    80003d70:	bf5fe0ef          	jal	80002964 <iunlockput>
  end_op();
    80003d74:	c60ff0ef          	jal	800031d4 <end_op>
  p = myproc();
    80003d78:	806fd0ef          	jal	80000d7e <myproc>
    80003d7c:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003d7e:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003d82:	6985                	lui	s3,0x1
    80003d84:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003d86:	99ca                	add	s3,s3,s2
    80003d88:	77fd                	lui	a5,0xfffff
    80003d8a:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003d8e:	4691                	li	a3,4
    80003d90:	6609                	lui	a2,0x2
    80003d92:	964e                	add	a2,a2,s3
    80003d94:	85ce                	mv	a1,s3
    80003d96:	855a                	mv	a0,s6
    80003d98:	9c7fc0ef          	jal	8000075e <uvmalloc>
    80003d9c:	8a2a                	mv	s4,a0
    80003d9e:	e105                	bnez	a0,80003dbe <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003da0:	85ce                	mv	a1,s3
    80003da2:	855a                	mv	a0,s6
    80003da4:	968fd0ef          	jal	80000f0c <proc_freepagetable>
  return -1;
    80003da8:	557d                	li	a0,-1
    80003daa:	79fe                	ld	s3,504(sp)
    80003dac:	7a5e                	ld	s4,496(sp)
    80003dae:	7abe                	ld	s5,488(sp)
    80003db0:	7b1e                	ld	s6,480(sp)
    80003db2:	6bfe                	ld	s7,472(sp)
    80003db4:	6c5e                	ld	s8,464(sp)
    80003db6:	6cbe                	ld	s9,456(sp)
    80003db8:	6d1e                	ld	s10,448(sp)
    80003dba:	7dfa                	ld	s11,440(sp)
    80003dbc:	b541                	j	80003c3c <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003dbe:	75f9                	lui	a1,0xffffe
    80003dc0:	95aa                	add	a1,a1,a0
    80003dc2:	855a                	mv	a0,s6
    80003dc4:	b65fc0ef          	jal	80000928 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003dc8:	800a0b93          	addi	s7,s4,-2048
    80003dcc:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80003dd0:	e0043783          	ld	a5,-512(s0)
    80003dd4:	6388                	ld	a0,0(a5)
  sp = sz;
    80003dd6:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003dd8:	4481                	li	s1,0
    ustack[argc] = sp;
    80003dda:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003dde:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003de2:	cd21                	beqz	a0,80003e3a <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80003de4:	ce4fc0ef          	jal	800002c8 <strlen>
    80003de8:	0015079b          	addiw	a5,a0,1
    80003dec:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003df0:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003df4:	13796563          	bltu	s2,s7,80003f1e <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003df8:	e0043d83          	ld	s11,-512(s0)
    80003dfc:	000db983          	ld	s3,0(s11)
    80003e00:	854e                	mv	a0,s3
    80003e02:	cc6fc0ef          	jal	800002c8 <strlen>
    80003e06:	0015069b          	addiw	a3,a0,1
    80003e0a:	864e                	mv	a2,s3
    80003e0c:	85ca                	mv	a1,s2
    80003e0e:	855a                	mv	a0,s6
    80003e10:	c9ffc0ef          	jal	80000aae <copyout>
    80003e14:	10054763          	bltz	a0,80003f22 <kexec+0x358>
    ustack[argc] = sp;
    80003e18:	00349793          	slli	a5,s1,0x3
    80003e1c:	97e6                	add	a5,a5,s9
    80003e1e:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdc278>
  for(argc = 0; argv[argc]; argc++) {
    80003e22:	0485                	addi	s1,s1,1
    80003e24:	008d8793          	addi	a5,s11,8
    80003e28:	e0f43023          	sd	a5,-512(s0)
    80003e2c:	008db503          	ld	a0,8(s11)
    80003e30:	c509                	beqz	a0,80003e3a <kexec+0x270>
    if(argc >= MAXARG)
    80003e32:	fb8499e3          	bne	s1,s8,80003de4 <kexec+0x21a>
  sz = sz1;
    80003e36:	89d2                	mv	s3,s4
    80003e38:	b7a5                	j	80003da0 <kexec+0x1d6>
  ustack[argc] = 0;
    80003e3a:	00349793          	slli	a5,s1,0x3
    80003e3e:	f9078793          	addi	a5,a5,-112
    80003e42:	97a2                	add	a5,a5,s0
    80003e44:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003e48:	00349693          	slli	a3,s1,0x3
    80003e4c:	06a1                	addi	a3,a3,8
    80003e4e:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80003e52:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80003e56:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80003e58:	f57964e3          	bltu	s2,s7,80003da0 <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80003e5c:	e9040613          	addi	a2,s0,-368
    80003e60:	85ca                	mv	a1,s2
    80003e62:	855a                	mv	a0,s6
    80003e64:	c4bfc0ef          	jal	80000aae <copyout>
    80003e68:	f2054ce3          	bltz	a0,80003da0 <kexec+0x1d6>
  p->trapframe->a1 = sp;
    80003e6c:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    80003e70:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80003e74:	df043783          	ld	a5,-528(s0)
    80003e78:	0007c703          	lbu	a4,0(a5)
    80003e7c:	cf11                	beqz	a4,80003e98 <kexec+0x2ce>
    80003e7e:	0785                	addi	a5,a5,1
    if(*s == '/')
    80003e80:	02f00693          	li	a3,47
    80003e84:	a029                	j	80003e8e <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80003e86:	0785                	addi	a5,a5,1
    80003e88:	fff7c703          	lbu	a4,-1(a5)
    80003e8c:	c711                	beqz	a4,80003e98 <kexec+0x2ce>
    if(*s == '/')
    80003e8e:	fed71ce3          	bne	a4,a3,80003e86 <kexec+0x2bc>
      last = s+1;
    80003e92:	def43823          	sd	a5,-528(s0)
    80003e96:	bfc5                	j	80003e86 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80003e98:	4641                	li	a2,16
    80003e9a:	df043583          	ld	a1,-528(s0)
    80003e9e:	158a8513          	addi	a0,s5,344
    80003ea2:	bf0fc0ef          	jal	80000292 <safestrcpy>
  oldpagetable = p->pagetable;
    80003ea6:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80003eaa:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80003eae:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80003eb2:	058ab783          	ld	a5,88(s5)
    80003eb6:	e6843703          	ld	a4,-408(s0)
    80003eba:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80003ebc:	058ab783          	ld	a5,88(s5)
    80003ec0:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80003ec4:	85ea                	mv	a1,s10
    80003ec6:	846fd0ef          	jal	80000f0c <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80003eca:	0004851b          	sext.w	a0,s1
    80003ece:	79fe                	ld	s3,504(sp)
    80003ed0:	7a5e                	ld	s4,496(sp)
    80003ed2:	7abe                	ld	s5,488(sp)
    80003ed4:	7b1e                	ld	s6,480(sp)
    80003ed6:	6bfe                	ld	s7,472(sp)
    80003ed8:	6c5e                	ld	s8,464(sp)
    80003eda:	6cbe                	ld	s9,456(sp)
    80003edc:	6d1e                	ld	s10,448(sp)
    80003ede:	7dfa                	ld	s11,440(sp)
    80003ee0:	bbb1                	j	80003c3c <kexec+0x72>
    80003ee2:	7b1e                	ld	s6,480(sp)
    80003ee4:	b3a9                	j	80003c2e <kexec+0x64>
    80003ee6:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80003eea:	df843583          	ld	a1,-520(s0)
    80003eee:	855a                	mv	a0,s6
    80003ef0:	81cfd0ef          	jal	80000f0c <proc_freepagetable>
  if(ip){
    80003ef4:	79fe                	ld	s3,504(sp)
    80003ef6:	7abe                	ld	s5,488(sp)
    80003ef8:	7b1e                	ld	s6,480(sp)
    80003efa:	6bfe                	ld	s7,472(sp)
    80003efc:	6c5e                	ld	s8,464(sp)
    80003efe:	6cbe                	ld	s9,456(sp)
    80003f00:	6d1e                	ld	s10,448(sp)
    80003f02:	7dfa                	ld	s11,440(sp)
    80003f04:	b32d                	j	80003c2e <kexec+0x64>
    80003f06:	df243c23          	sd	s2,-520(s0)
    80003f0a:	b7c5                	j	80003eea <kexec+0x320>
    80003f0c:	df243c23          	sd	s2,-520(s0)
    80003f10:	bfe9                	j	80003eea <kexec+0x320>
    80003f12:	df243c23          	sd	s2,-520(s0)
    80003f16:	bfd1                	j	80003eea <kexec+0x320>
    80003f18:	df243c23          	sd	s2,-520(s0)
    80003f1c:	b7f9                	j	80003eea <kexec+0x320>
  sz = sz1;
    80003f1e:	89d2                	mv	s3,s4
    80003f20:	b541                	j	80003da0 <kexec+0x1d6>
    80003f22:	89d2                	mv	s3,s4
    80003f24:	bdb5                	j	80003da0 <kexec+0x1d6>

0000000080003f26 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80003f26:	7179                	addi	sp,sp,-48
    80003f28:	f406                	sd	ra,40(sp)
    80003f2a:	f022                	sd	s0,32(sp)
    80003f2c:	ec26                	sd	s1,24(sp)
    80003f2e:	e84a                	sd	s2,16(sp)
    80003f30:	1800                	addi	s0,sp,48
    80003f32:	892e                	mv	s2,a1
    80003f34:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    80003f36:	fdc40593          	addi	a1,s0,-36
    80003f3a:	d6dfd0ef          	jal	80001ca6 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    80003f3e:	fdc42703          	lw	a4,-36(s0)
    80003f42:	47bd                	li	a5,15
    80003f44:	02e7ea63          	bltu	a5,a4,80003f78 <argfd+0x52>
    80003f48:	e37fc0ef          	jal	80000d7e <myproc>
    80003f4c:	fdc42703          	lw	a4,-36(s0)
    80003f50:	00371793          	slli	a5,a4,0x3
    80003f54:	0d078793          	addi	a5,a5,208
    80003f58:	953e                	add	a0,a0,a5
    80003f5a:	611c                	ld	a5,0(a0)
    80003f5c:	c385                	beqz	a5,80003f7c <argfd+0x56>
    return -1;
  if(pfd)
    80003f5e:	00090463          	beqz	s2,80003f66 <argfd+0x40>
    *pfd = fd;
    80003f62:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80003f66:	4501                	li	a0,0
  if(pf)
    80003f68:	c091                	beqz	s1,80003f6c <argfd+0x46>
    *pf = f;
    80003f6a:	e09c                	sd	a5,0(s1)
}
    80003f6c:	70a2                	ld	ra,40(sp)
    80003f6e:	7402                	ld	s0,32(sp)
    80003f70:	64e2                	ld	s1,24(sp)
    80003f72:	6942                	ld	s2,16(sp)
    80003f74:	6145                	addi	sp,sp,48
    80003f76:	8082                	ret
    return -1;
    80003f78:	557d                	li	a0,-1
    80003f7a:	bfcd                	j	80003f6c <argfd+0x46>
    80003f7c:	557d                	li	a0,-1
    80003f7e:	b7fd                	j	80003f6c <argfd+0x46>

0000000080003f80 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80003f80:	1101                	addi	sp,sp,-32
    80003f82:	ec06                	sd	ra,24(sp)
    80003f84:	e822                	sd	s0,16(sp)
    80003f86:	e426                	sd	s1,8(sp)
    80003f88:	1000                	addi	s0,sp,32
    80003f8a:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80003f8c:	df3fc0ef          	jal	80000d7e <myproc>
    80003f90:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80003f92:	0d050793          	addi	a5,a0,208
    80003f96:	4501                	li	a0,0
    80003f98:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80003f9a:	6398                	ld	a4,0(a5)
    80003f9c:	cb19                	beqz	a4,80003fb2 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80003f9e:	2505                	addiw	a0,a0,1
    80003fa0:	07a1                	addi	a5,a5,8
    80003fa2:	fed51ce3          	bne	a0,a3,80003f9a <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80003fa6:	557d                	li	a0,-1
}
    80003fa8:	60e2                	ld	ra,24(sp)
    80003faa:	6442                	ld	s0,16(sp)
    80003fac:	64a2                	ld	s1,8(sp)
    80003fae:	6105                	addi	sp,sp,32
    80003fb0:	8082                	ret
      p->ofile[fd] = f;
    80003fb2:	00351793          	slli	a5,a0,0x3
    80003fb6:	0d078793          	addi	a5,a5,208
    80003fba:	963e                	add	a2,a2,a5
    80003fbc:	e204                	sd	s1,0(a2)
      return fd;
    80003fbe:	b7ed                	j	80003fa8 <fdalloc+0x28>

0000000080003fc0 <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    80003fc0:	715d                	addi	sp,sp,-80
    80003fc2:	e486                	sd	ra,72(sp)
    80003fc4:	e0a2                	sd	s0,64(sp)
    80003fc6:	fc26                	sd	s1,56(sp)
    80003fc8:	f84a                	sd	s2,48(sp)
    80003fca:	f44e                	sd	s3,40(sp)
    80003fcc:	f052                	sd	s4,32(sp)
    80003fce:	ec56                	sd	s5,24(sp)
    80003fd0:	e85a                	sd	s6,16(sp)
    80003fd2:	0880                	addi	s0,sp,80
    80003fd4:	892e                	mv	s2,a1
    80003fd6:	8a2e                	mv	s4,a1
    80003fd8:	8ab2                	mv	s5,a2
    80003fda:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80003fdc:	fb040593          	addi	a1,s0,-80
    80003fe0:	fc1fe0ef          	jal	80002fa0 <nameiparent>
    80003fe4:	84aa                	mv	s1,a0
    80003fe6:	10050763          	beqz	a0,800040f4 <create+0x134>
    return 0;

  ilock(dp);
    80003fea:	f6efe0ef          	jal	80002758 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80003fee:	4601                	li	a2,0
    80003ff0:	fb040593          	addi	a1,s0,-80
    80003ff4:	8526                	mv	a0,s1
    80003ff6:	cfdfe0ef          	jal	80002cf2 <dirlookup>
    80003ffa:	89aa                	mv	s3,a0
    80003ffc:	c131                	beqz	a0,80004040 <create+0x80>
    iunlockput(dp);
    80003ffe:	8526                	mv	a0,s1
    80004000:	965fe0ef          	jal	80002964 <iunlockput>
    ilock(ip);
    80004004:	854e                	mv	a0,s3
    80004006:	f52fe0ef          	jal	80002758 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000400a:	4789                	li	a5,2
    8000400c:	02f91563          	bne	s2,a5,80004036 <create+0x76>
    80004010:	0449d783          	lhu	a5,68(s3)
    80004014:	37f9                	addiw	a5,a5,-2
    80004016:	17c2                	slli	a5,a5,0x30
    80004018:	93c1                	srli	a5,a5,0x30
    8000401a:	4705                	li	a4,1
    8000401c:	00f76d63          	bltu	a4,a5,80004036 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    80004020:	854e                	mv	a0,s3
    80004022:	60a6                	ld	ra,72(sp)
    80004024:	6406                	ld	s0,64(sp)
    80004026:	74e2                	ld	s1,56(sp)
    80004028:	7942                	ld	s2,48(sp)
    8000402a:	79a2                	ld	s3,40(sp)
    8000402c:	7a02                	ld	s4,32(sp)
    8000402e:	6ae2                	ld	s5,24(sp)
    80004030:	6b42                	ld	s6,16(sp)
    80004032:	6161                	addi	sp,sp,80
    80004034:	8082                	ret
    iunlockput(ip);
    80004036:	854e                	mv	a0,s3
    80004038:	92dfe0ef          	jal	80002964 <iunlockput>
    return 0;
    8000403c:	4981                	li	s3,0
    8000403e:	b7cd                	j	80004020 <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    80004040:	85ca                	mv	a1,s2
    80004042:	4088                	lw	a0,0(s1)
    80004044:	da4fe0ef          	jal	800025e8 <ialloc>
    80004048:	892a                	mv	s2,a0
    8000404a:	cd15                	beqz	a0,80004086 <create+0xc6>
  ilock(ip);
    8000404c:	f0cfe0ef          	jal	80002758 <ilock>
  ip->major = major;
    80004050:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004054:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004058:	4785                	li	a5,1
    8000405a:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000405e:	854a                	mv	a0,s2
    80004060:	e44fe0ef          	jal	800026a4 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004064:	4705                	li	a4,1
    80004066:	02ea0463          	beq	s4,a4,8000408e <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    8000406a:	00492603          	lw	a2,4(s2)
    8000406e:	fb040593          	addi	a1,s0,-80
    80004072:	8526                	mv	a0,s1
    80004074:	e69fe0ef          	jal	80002edc <dirlink>
    80004078:	06054263          	bltz	a0,800040dc <create+0x11c>
  iunlockput(dp);
    8000407c:	8526                	mv	a0,s1
    8000407e:	8e7fe0ef          	jal	80002964 <iunlockput>
  return ip;
    80004082:	89ca                	mv	s3,s2
    80004084:	bf71                	j	80004020 <create+0x60>
    iunlockput(dp);
    80004086:	8526                	mv	a0,s1
    80004088:	8ddfe0ef          	jal	80002964 <iunlockput>
    return 0;
    8000408c:	bf51                	j	80004020 <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000408e:	00492603          	lw	a2,4(s2)
    80004092:	00003597          	auipc	a1,0x3
    80004096:	4e658593          	addi	a1,a1,1254 # 80007578 <etext+0x578>
    8000409a:	854a                	mv	a0,s2
    8000409c:	e41fe0ef          	jal	80002edc <dirlink>
    800040a0:	02054e63          	bltz	a0,800040dc <create+0x11c>
    800040a4:	40d0                	lw	a2,4(s1)
    800040a6:	00003597          	auipc	a1,0x3
    800040aa:	4da58593          	addi	a1,a1,1242 # 80007580 <etext+0x580>
    800040ae:	854a                	mv	a0,s2
    800040b0:	e2dfe0ef          	jal	80002edc <dirlink>
    800040b4:	02054463          	bltz	a0,800040dc <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    800040b8:	00492603          	lw	a2,4(s2)
    800040bc:	fb040593          	addi	a1,s0,-80
    800040c0:	8526                	mv	a0,s1
    800040c2:	e1bfe0ef          	jal	80002edc <dirlink>
    800040c6:	00054b63          	bltz	a0,800040dc <create+0x11c>
    dp->nlink++;  // for ".."
    800040ca:	04a4d783          	lhu	a5,74(s1)
    800040ce:	2785                	addiw	a5,a5,1
    800040d0:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800040d4:	8526                	mv	a0,s1
    800040d6:	dcefe0ef          	jal	800026a4 <iupdate>
    800040da:	b74d                	j	8000407c <create+0xbc>
  ip->nlink = 0;
    800040dc:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    800040e0:	854a                	mv	a0,s2
    800040e2:	dc2fe0ef          	jal	800026a4 <iupdate>
  iunlockput(ip);
    800040e6:	854a                	mv	a0,s2
    800040e8:	87dfe0ef          	jal	80002964 <iunlockput>
  iunlockput(dp);
    800040ec:	8526                	mv	a0,s1
    800040ee:	877fe0ef          	jal	80002964 <iunlockput>
  return 0;
    800040f2:	b73d                	j	80004020 <create+0x60>
    return 0;
    800040f4:	89aa                	mv	s3,a0
    800040f6:	b72d                	j	80004020 <create+0x60>

00000000800040f8 <sys_dup>:
{
    800040f8:	7179                	addi	sp,sp,-48
    800040fa:	f406                	sd	ra,40(sp)
    800040fc:	f022                	sd	s0,32(sp)
    800040fe:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    80004100:	fd840613          	addi	a2,s0,-40
    80004104:	4581                	li	a1,0
    80004106:	4501                	li	a0,0
    80004108:	e1fff0ef          	jal	80003f26 <argfd>
    return -1;
    8000410c:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    8000410e:	02054363          	bltz	a0,80004134 <sys_dup+0x3c>
    80004112:	ec26                	sd	s1,24(sp)
    80004114:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004116:	fd843483          	ld	s1,-40(s0)
    8000411a:	8526                	mv	a0,s1
    8000411c:	e65ff0ef          	jal	80003f80 <fdalloc>
    80004120:	892a                	mv	s2,a0
    return -1;
    80004122:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    80004124:	00054d63          	bltz	a0,8000413e <sys_dup+0x46>
  filedup(f);
    80004128:	8526                	mv	a0,s1
    8000412a:	c18ff0ef          	jal	80003542 <filedup>
  return fd;
    8000412e:	87ca                	mv	a5,s2
    80004130:	64e2                	ld	s1,24(sp)
    80004132:	6942                	ld	s2,16(sp)
}
    80004134:	853e                	mv	a0,a5
    80004136:	70a2                	ld	ra,40(sp)
    80004138:	7402                	ld	s0,32(sp)
    8000413a:	6145                	addi	sp,sp,48
    8000413c:	8082                	ret
    8000413e:	64e2                	ld	s1,24(sp)
    80004140:	6942                	ld	s2,16(sp)
    80004142:	bfcd                	j	80004134 <sys_dup+0x3c>

0000000080004144 <sys_read>:
{
    80004144:	7179                	addi	sp,sp,-48
    80004146:	f406                	sd	ra,40(sp)
    80004148:	f022                	sd	s0,32(sp)
    8000414a:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000414c:	fd840593          	addi	a1,s0,-40
    80004150:	4505                	li	a0,1
    80004152:	b71fd0ef          	jal	80001cc2 <argaddr>
  argint(2, &n);
    80004156:	fe440593          	addi	a1,s0,-28
    8000415a:	4509                	li	a0,2
    8000415c:	b4bfd0ef          	jal	80001ca6 <argint>
  if(argfd(0, 0, &f) < 0)
    80004160:	fe840613          	addi	a2,s0,-24
    80004164:	4581                	li	a1,0
    80004166:	4501                	li	a0,0
    80004168:	dbfff0ef          	jal	80003f26 <argfd>
    8000416c:	87aa                	mv	a5,a0
    return -1;
    8000416e:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004170:	0007ca63          	bltz	a5,80004184 <sys_read+0x40>
  return fileread(f, p, n);
    80004174:	fe442603          	lw	a2,-28(s0)
    80004178:	fd843583          	ld	a1,-40(s0)
    8000417c:	fe843503          	ld	a0,-24(s0)
    80004180:	d2cff0ef          	jal	800036ac <fileread>
}
    80004184:	70a2                	ld	ra,40(sp)
    80004186:	7402                	ld	s0,32(sp)
    80004188:	6145                	addi	sp,sp,48
    8000418a:	8082                	ret

000000008000418c <sys_write>:
{
    8000418c:	7179                	addi	sp,sp,-48
    8000418e:	f406                	sd	ra,40(sp)
    80004190:	f022                	sd	s0,32(sp)
    80004192:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004194:	fd840593          	addi	a1,s0,-40
    80004198:	4505                	li	a0,1
    8000419a:	b29fd0ef          	jal	80001cc2 <argaddr>
  argint(2, &n);
    8000419e:	fe440593          	addi	a1,s0,-28
    800041a2:	4509                	li	a0,2
    800041a4:	b03fd0ef          	jal	80001ca6 <argint>
  if(argfd(0, 0, &f) < 0)
    800041a8:	fe840613          	addi	a2,s0,-24
    800041ac:	4581                	li	a1,0
    800041ae:	4501                	li	a0,0
    800041b0:	d77ff0ef          	jal	80003f26 <argfd>
    800041b4:	87aa                	mv	a5,a0
    return -1;
    800041b6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800041b8:	0007ca63          	bltz	a5,800041cc <sys_write+0x40>
  return filewrite(f, p, n);
    800041bc:	fe442603          	lw	a2,-28(s0)
    800041c0:	fd843583          	ld	a1,-40(s0)
    800041c4:	fe843503          	ld	a0,-24(s0)
    800041c8:	da8ff0ef          	jal	80003770 <filewrite>
}
    800041cc:	70a2                	ld	ra,40(sp)
    800041ce:	7402                	ld	s0,32(sp)
    800041d0:	6145                	addi	sp,sp,48
    800041d2:	8082                	ret

00000000800041d4 <sys_close>:
{
    800041d4:	1101                	addi	sp,sp,-32
    800041d6:	ec06                	sd	ra,24(sp)
    800041d8:	e822                	sd	s0,16(sp)
    800041da:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    800041dc:	fe040613          	addi	a2,s0,-32
    800041e0:	fec40593          	addi	a1,s0,-20
    800041e4:	4501                	li	a0,0
    800041e6:	d41ff0ef          	jal	80003f26 <argfd>
    return -1;
    800041ea:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    800041ec:	02054163          	bltz	a0,8000420e <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    800041f0:	b8ffc0ef          	jal	80000d7e <myproc>
    800041f4:	fec42783          	lw	a5,-20(s0)
    800041f8:	078e                	slli	a5,a5,0x3
    800041fa:	0d078793          	addi	a5,a5,208
    800041fe:	953e                	add	a0,a0,a5
    80004200:	00053023          	sd	zero,0(a0)
  fileclose(f);
    80004204:	fe043503          	ld	a0,-32(s0)
    80004208:	b80ff0ef          	jal	80003588 <fileclose>
  return 0;
    8000420c:	4781                	li	a5,0
}
    8000420e:	853e                	mv	a0,a5
    80004210:	60e2                	ld	ra,24(sp)
    80004212:	6442                	ld	s0,16(sp)
    80004214:	6105                	addi	sp,sp,32
    80004216:	8082                	ret

0000000080004218 <sys_fstat>:
{
    80004218:	1101                	addi	sp,sp,-32
    8000421a:	ec06                	sd	ra,24(sp)
    8000421c:	e822                	sd	s0,16(sp)
    8000421e:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    80004220:	fe040593          	addi	a1,s0,-32
    80004224:	4505                	li	a0,1
    80004226:	a9dfd0ef          	jal	80001cc2 <argaddr>
  if(argfd(0, 0, &f) < 0)
    8000422a:	fe840613          	addi	a2,s0,-24
    8000422e:	4581                	li	a1,0
    80004230:	4501                	li	a0,0
    80004232:	cf5ff0ef          	jal	80003f26 <argfd>
    80004236:	87aa                	mv	a5,a0
    return -1;
    80004238:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000423a:	0007c863          	bltz	a5,8000424a <sys_fstat+0x32>
  return filestat(f, st);
    8000423e:	fe043583          	ld	a1,-32(s0)
    80004242:	fe843503          	ld	a0,-24(s0)
    80004246:	c04ff0ef          	jal	8000364a <filestat>
}
    8000424a:	60e2                	ld	ra,24(sp)
    8000424c:	6442                	ld	s0,16(sp)
    8000424e:	6105                	addi	sp,sp,32
    80004250:	8082                	ret

0000000080004252 <sys_link>:
{
    80004252:	7169                	addi	sp,sp,-304
    80004254:	f606                	sd	ra,296(sp)
    80004256:	f222                	sd	s0,288(sp)
    80004258:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000425a:	08000613          	li	a2,128
    8000425e:	ed040593          	addi	a1,s0,-304
    80004262:	4501                	li	a0,0
    80004264:	a7bfd0ef          	jal	80001cde <argstr>
    return -1;
    80004268:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000426a:	0c054e63          	bltz	a0,80004346 <sys_link+0xf4>
    8000426e:	08000613          	li	a2,128
    80004272:	f5040593          	addi	a1,s0,-176
    80004276:	4505                	li	a0,1
    80004278:	a67fd0ef          	jal	80001cde <argstr>
    return -1;
    8000427c:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000427e:	0c054463          	bltz	a0,80004346 <sys_link+0xf4>
    80004282:	ee26                	sd	s1,280(sp)
  begin_op();
    80004284:	ee1fe0ef          	jal	80003164 <begin_op>
  if((ip = namei(old)) == 0){
    80004288:	ed040513          	addi	a0,s0,-304
    8000428c:	cfbfe0ef          	jal	80002f86 <namei>
    80004290:	84aa                	mv	s1,a0
    80004292:	c53d                	beqz	a0,80004300 <sys_link+0xae>
  ilock(ip);
    80004294:	cc4fe0ef          	jal	80002758 <ilock>
  if(ip->type == T_DIR){
    80004298:	04449703          	lh	a4,68(s1)
    8000429c:	4785                	li	a5,1
    8000429e:	06f70663          	beq	a4,a5,8000430a <sys_link+0xb8>
    800042a2:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    800042a4:	04a4d783          	lhu	a5,74(s1)
    800042a8:	2785                	addiw	a5,a5,1
    800042aa:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800042ae:	8526                	mv	a0,s1
    800042b0:	bf4fe0ef          	jal	800026a4 <iupdate>
  iunlock(ip);
    800042b4:	8526                	mv	a0,s1
    800042b6:	d50fe0ef          	jal	80002806 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    800042ba:	fd040593          	addi	a1,s0,-48
    800042be:	f5040513          	addi	a0,s0,-176
    800042c2:	cdffe0ef          	jal	80002fa0 <nameiparent>
    800042c6:	892a                	mv	s2,a0
    800042c8:	cd21                	beqz	a0,80004320 <sys_link+0xce>
  ilock(dp);
    800042ca:	c8efe0ef          	jal	80002758 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    800042ce:	854a                	mv	a0,s2
    800042d0:	00092703          	lw	a4,0(s2)
    800042d4:	409c                	lw	a5,0(s1)
    800042d6:	04f71263          	bne	a4,a5,8000431a <sys_link+0xc8>
    800042da:	40d0                	lw	a2,4(s1)
    800042dc:	fd040593          	addi	a1,s0,-48
    800042e0:	bfdfe0ef          	jal	80002edc <dirlink>
    800042e4:	02054b63          	bltz	a0,8000431a <sys_link+0xc8>
  iunlockput(dp);
    800042e8:	854a                	mv	a0,s2
    800042ea:	e7afe0ef          	jal	80002964 <iunlockput>
  iput(ip);
    800042ee:	8526                	mv	a0,s1
    800042f0:	deafe0ef          	jal	800028da <iput>
  end_op();
    800042f4:	ee1fe0ef          	jal	800031d4 <end_op>
  return 0;
    800042f8:	4781                	li	a5,0
    800042fa:	64f2                	ld	s1,280(sp)
    800042fc:	6952                	ld	s2,272(sp)
    800042fe:	a0a1                	j	80004346 <sys_link+0xf4>
    end_op();
    80004300:	ed5fe0ef          	jal	800031d4 <end_op>
    return -1;
    80004304:	57fd                	li	a5,-1
    80004306:	64f2                	ld	s1,280(sp)
    80004308:	a83d                	j	80004346 <sys_link+0xf4>
    iunlockput(ip);
    8000430a:	8526                	mv	a0,s1
    8000430c:	e58fe0ef          	jal	80002964 <iunlockput>
    end_op();
    80004310:	ec5fe0ef          	jal	800031d4 <end_op>
    return -1;
    80004314:	57fd                	li	a5,-1
    80004316:	64f2                	ld	s1,280(sp)
    80004318:	a03d                	j	80004346 <sys_link+0xf4>
    iunlockput(dp);
    8000431a:	854a                	mv	a0,s2
    8000431c:	e48fe0ef          	jal	80002964 <iunlockput>
  ilock(ip);
    80004320:	8526                	mv	a0,s1
    80004322:	c36fe0ef          	jal	80002758 <ilock>
  ip->nlink--;
    80004326:	04a4d783          	lhu	a5,74(s1)
    8000432a:	37fd                	addiw	a5,a5,-1
    8000432c:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004330:	8526                	mv	a0,s1
    80004332:	b72fe0ef          	jal	800026a4 <iupdate>
  iunlockput(ip);
    80004336:	8526                	mv	a0,s1
    80004338:	e2cfe0ef          	jal	80002964 <iunlockput>
  end_op();
    8000433c:	e99fe0ef          	jal	800031d4 <end_op>
  return -1;
    80004340:	57fd                	li	a5,-1
    80004342:	64f2                	ld	s1,280(sp)
    80004344:	6952                	ld	s2,272(sp)
}
    80004346:	853e                	mv	a0,a5
    80004348:	70b2                	ld	ra,296(sp)
    8000434a:	7412                	ld	s0,288(sp)
    8000434c:	6155                	addi	sp,sp,304
    8000434e:	8082                	ret

0000000080004350 <sys_unlink>:
{
    80004350:	7151                	addi	sp,sp,-240
    80004352:	f586                	sd	ra,232(sp)
    80004354:	f1a2                	sd	s0,224(sp)
    80004356:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004358:	08000613          	li	a2,128
    8000435c:	f3040593          	addi	a1,s0,-208
    80004360:	4501                	li	a0,0
    80004362:	97dfd0ef          	jal	80001cde <argstr>
    80004366:	14054d63          	bltz	a0,800044c0 <sys_unlink+0x170>
    8000436a:	eda6                	sd	s1,216(sp)
  begin_op();
    8000436c:	df9fe0ef          	jal	80003164 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    80004370:	fb040593          	addi	a1,s0,-80
    80004374:	f3040513          	addi	a0,s0,-208
    80004378:	c29fe0ef          	jal	80002fa0 <nameiparent>
    8000437c:	84aa                	mv	s1,a0
    8000437e:	c955                	beqz	a0,80004432 <sys_unlink+0xe2>
  ilock(dp);
    80004380:	bd8fe0ef          	jal	80002758 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004384:	00003597          	auipc	a1,0x3
    80004388:	1f458593          	addi	a1,a1,500 # 80007578 <etext+0x578>
    8000438c:	fb040513          	addi	a0,s0,-80
    80004390:	94dfe0ef          	jal	80002cdc <namecmp>
    80004394:	10050b63          	beqz	a0,800044aa <sys_unlink+0x15a>
    80004398:	00003597          	auipc	a1,0x3
    8000439c:	1e858593          	addi	a1,a1,488 # 80007580 <etext+0x580>
    800043a0:	fb040513          	addi	a0,s0,-80
    800043a4:	939fe0ef          	jal	80002cdc <namecmp>
    800043a8:	10050163          	beqz	a0,800044aa <sys_unlink+0x15a>
    800043ac:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    800043ae:	f2c40613          	addi	a2,s0,-212
    800043b2:	fb040593          	addi	a1,s0,-80
    800043b6:	8526                	mv	a0,s1
    800043b8:	93bfe0ef          	jal	80002cf2 <dirlookup>
    800043bc:	892a                	mv	s2,a0
    800043be:	0e050563          	beqz	a0,800044a8 <sys_unlink+0x158>
    800043c2:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    800043c4:	b94fe0ef          	jal	80002758 <ilock>
  if(ip->nlink < 1)
    800043c8:	04a91783          	lh	a5,74(s2)
    800043cc:	06f05863          	blez	a5,8000443c <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    800043d0:	04491703          	lh	a4,68(s2)
    800043d4:	4785                	li	a5,1
    800043d6:	06f70963          	beq	a4,a5,80004448 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    800043da:	fc040993          	addi	s3,s0,-64
    800043de:	4641                	li	a2,16
    800043e0:	4581                	li	a1,0
    800043e2:	854e                	mv	a0,s3
    800043e4:	d5bfb0ef          	jal	8000013e <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800043e8:	4741                	li	a4,16
    800043ea:	f2c42683          	lw	a3,-212(s0)
    800043ee:	864e                	mv	a2,s3
    800043f0:	4581                	li	a1,0
    800043f2:	8526                	mv	a0,s1
    800043f4:	fe8fe0ef          	jal	80002bdc <writei>
    800043f8:	47c1                	li	a5,16
    800043fa:	08f51863          	bne	a0,a5,8000448a <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    800043fe:	04491703          	lh	a4,68(s2)
    80004402:	4785                	li	a5,1
    80004404:	08f70963          	beq	a4,a5,80004496 <sys_unlink+0x146>
  iunlockput(dp);
    80004408:	8526                	mv	a0,s1
    8000440a:	d5afe0ef          	jal	80002964 <iunlockput>
  ip->nlink--;
    8000440e:	04a95783          	lhu	a5,74(s2)
    80004412:	37fd                	addiw	a5,a5,-1
    80004414:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004418:	854a                	mv	a0,s2
    8000441a:	a8afe0ef          	jal	800026a4 <iupdate>
  iunlockput(ip);
    8000441e:	854a                	mv	a0,s2
    80004420:	d44fe0ef          	jal	80002964 <iunlockput>
  end_op();
    80004424:	db1fe0ef          	jal	800031d4 <end_op>
  return 0;
    80004428:	4501                	li	a0,0
    8000442a:	64ee                	ld	s1,216(sp)
    8000442c:	694e                	ld	s2,208(sp)
    8000442e:	69ae                	ld	s3,200(sp)
    80004430:	a061                	j	800044b8 <sys_unlink+0x168>
    end_op();
    80004432:	da3fe0ef          	jal	800031d4 <end_op>
    return -1;
    80004436:	557d                	li	a0,-1
    80004438:	64ee                	ld	s1,216(sp)
    8000443a:	a8bd                	j	800044b8 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    8000443c:	00003517          	auipc	a0,0x3
    80004440:	14c50513          	addi	a0,a0,332 # 80007588 <etext+0x588>
    80004444:	2f2010ef          	jal	80005736 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004448:	04c92703          	lw	a4,76(s2)
    8000444c:	02000793          	li	a5,32
    80004450:	f8e7f5e3          	bgeu	a5,a4,800043da <sys_unlink+0x8a>
    80004454:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004456:	4741                	li	a4,16
    80004458:	86ce                	mv	a3,s3
    8000445a:	f1840613          	addi	a2,s0,-232
    8000445e:	4581                	li	a1,0
    80004460:	854a                	mv	a0,s2
    80004462:	e88fe0ef          	jal	80002aea <readi>
    80004466:	47c1                	li	a5,16
    80004468:	00f51b63          	bne	a0,a5,8000447e <sys_unlink+0x12e>
    if(de.inum != 0)
    8000446c:	f1845783          	lhu	a5,-232(s0)
    80004470:	ebb1                	bnez	a5,800044c4 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004472:	29c1                	addiw	s3,s3,16
    80004474:	04c92783          	lw	a5,76(s2)
    80004478:	fcf9efe3          	bltu	s3,a5,80004456 <sys_unlink+0x106>
    8000447c:	bfb9                	j	800043da <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000447e:	00003517          	auipc	a0,0x3
    80004482:	12250513          	addi	a0,a0,290 # 800075a0 <etext+0x5a0>
    80004486:	2b0010ef          	jal	80005736 <panic>
    panic("unlink: writei");
    8000448a:	00003517          	auipc	a0,0x3
    8000448e:	12e50513          	addi	a0,a0,302 # 800075b8 <etext+0x5b8>
    80004492:	2a4010ef          	jal	80005736 <panic>
    dp->nlink--;
    80004496:	04a4d783          	lhu	a5,74(s1)
    8000449a:	37fd                	addiw	a5,a5,-1
    8000449c:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    800044a0:	8526                	mv	a0,s1
    800044a2:	a02fe0ef          	jal	800026a4 <iupdate>
    800044a6:	b78d                	j	80004408 <sys_unlink+0xb8>
    800044a8:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    800044aa:	8526                	mv	a0,s1
    800044ac:	cb8fe0ef          	jal	80002964 <iunlockput>
  end_op();
    800044b0:	d25fe0ef          	jal	800031d4 <end_op>
  return -1;
    800044b4:	557d                	li	a0,-1
    800044b6:	64ee                	ld	s1,216(sp)
}
    800044b8:	70ae                	ld	ra,232(sp)
    800044ba:	740e                	ld	s0,224(sp)
    800044bc:	616d                	addi	sp,sp,240
    800044be:	8082                	ret
    return -1;
    800044c0:	557d                	li	a0,-1
    800044c2:	bfdd                	j	800044b8 <sys_unlink+0x168>
    iunlockput(ip);
    800044c4:	854a                	mv	a0,s2
    800044c6:	c9efe0ef          	jal	80002964 <iunlockput>
    goto bad;
    800044ca:	694e                	ld	s2,208(sp)
    800044cc:	69ae                	ld	s3,200(sp)
    800044ce:	bff1                	j	800044aa <sys_unlink+0x15a>

00000000800044d0 <sys_open>:

uint64
sys_open(void)
{
    800044d0:	7131                	addi	sp,sp,-192
    800044d2:	fd06                	sd	ra,184(sp)
    800044d4:	f922                	sd	s0,176(sp)
    800044d6:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    800044d8:	f4c40593          	addi	a1,s0,-180
    800044dc:	4505                	li	a0,1
    800044de:	fc8fd0ef          	jal	80001ca6 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    800044e2:	08000613          	li	a2,128
    800044e6:	f5040593          	addi	a1,s0,-176
    800044ea:	4501                	li	a0,0
    800044ec:	ff2fd0ef          	jal	80001cde <argstr>
    800044f0:	87aa                	mv	a5,a0
    return -1;
    800044f2:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800044f4:	0a07c363          	bltz	a5,8000459a <sys_open+0xca>
    800044f8:	f526                	sd	s1,168(sp)

  begin_op();
    800044fa:	c6bfe0ef          	jal	80003164 <begin_op>

  if(omode & O_CREATE){
    800044fe:	f4c42783          	lw	a5,-180(s0)
    80004502:	2007f793          	andi	a5,a5,512
    80004506:	c3dd                	beqz	a5,800045ac <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004508:	4681                	li	a3,0
    8000450a:	4601                	li	a2,0
    8000450c:	4589                	li	a1,2
    8000450e:	f5040513          	addi	a0,s0,-176
    80004512:	aafff0ef          	jal	80003fc0 <create>
    80004516:	84aa                	mv	s1,a0
    if(ip == 0){
    80004518:	c549                	beqz	a0,800045a2 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    8000451a:	04449703          	lh	a4,68(s1)
    8000451e:	478d                	li	a5,3
    80004520:	00f71763          	bne	a4,a5,8000452e <sys_open+0x5e>
    80004524:	0464d703          	lhu	a4,70(s1)
    80004528:	47a5                	li	a5,9
    8000452a:	0ae7ee63          	bltu	a5,a4,800045e6 <sys_open+0x116>
    8000452e:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004530:	fb5fe0ef          	jal	800034e4 <filealloc>
    80004534:	892a                	mv	s2,a0
    80004536:	c561                	beqz	a0,800045fe <sys_open+0x12e>
    80004538:	ed4e                	sd	s3,152(sp)
    8000453a:	a47ff0ef          	jal	80003f80 <fdalloc>
    8000453e:	89aa                	mv	s3,a0
    80004540:	0a054b63          	bltz	a0,800045f6 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004544:	04449703          	lh	a4,68(s1)
    80004548:	478d                	li	a5,3
    8000454a:	0cf70363          	beq	a4,a5,80004610 <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    8000454e:	4789                	li	a5,2
    80004550:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004554:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004558:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000455c:	f4c42783          	lw	a5,-180(s0)
    80004560:	0017f713          	andi	a4,a5,1
    80004564:	00174713          	xori	a4,a4,1
    80004568:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000456c:	0037f713          	andi	a4,a5,3
    80004570:	00e03733          	snez	a4,a4
    80004574:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004578:	4007f793          	andi	a5,a5,1024
    8000457c:	c791                	beqz	a5,80004588 <sys_open+0xb8>
    8000457e:	04449703          	lh	a4,68(s1)
    80004582:	4789                	li	a5,2
    80004584:	08f70d63          	beq	a4,a5,8000461e <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004588:	8526                	mv	a0,s1
    8000458a:	a7cfe0ef          	jal	80002806 <iunlock>
  end_op();
    8000458e:	c47fe0ef          	jal	800031d4 <end_op>

  return fd;
    80004592:	854e                	mv	a0,s3
    80004594:	74aa                	ld	s1,168(sp)
    80004596:	790a                	ld	s2,160(sp)
    80004598:	69ea                	ld	s3,152(sp)
}
    8000459a:	70ea                	ld	ra,184(sp)
    8000459c:	744a                	ld	s0,176(sp)
    8000459e:	6129                	addi	sp,sp,192
    800045a0:	8082                	ret
      end_op();
    800045a2:	c33fe0ef          	jal	800031d4 <end_op>
      return -1;
    800045a6:	557d                	li	a0,-1
    800045a8:	74aa                	ld	s1,168(sp)
    800045aa:	bfc5                	j	8000459a <sys_open+0xca>
    if((ip = namei(path)) == 0){
    800045ac:	f5040513          	addi	a0,s0,-176
    800045b0:	9d7fe0ef          	jal	80002f86 <namei>
    800045b4:	84aa                	mv	s1,a0
    800045b6:	c11d                	beqz	a0,800045dc <sys_open+0x10c>
    ilock(ip);
    800045b8:	9a0fe0ef          	jal	80002758 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    800045bc:	04449703          	lh	a4,68(s1)
    800045c0:	4785                	li	a5,1
    800045c2:	f4f71ce3          	bne	a4,a5,8000451a <sys_open+0x4a>
    800045c6:	f4c42783          	lw	a5,-180(s0)
    800045ca:	d3b5                	beqz	a5,8000452e <sys_open+0x5e>
      iunlockput(ip);
    800045cc:	8526                	mv	a0,s1
    800045ce:	b96fe0ef          	jal	80002964 <iunlockput>
      end_op();
    800045d2:	c03fe0ef          	jal	800031d4 <end_op>
      return -1;
    800045d6:	557d                	li	a0,-1
    800045d8:	74aa                	ld	s1,168(sp)
    800045da:	b7c1                	j	8000459a <sys_open+0xca>
      end_op();
    800045dc:	bf9fe0ef          	jal	800031d4 <end_op>
      return -1;
    800045e0:	557d                	li	a0,-1
    800045e2:	74aa                	ld	s1,168(sp)
    800045e4:	bf5d                	j	8000459a <sys_open+0xca>
    iunlockput(ip);
    800045e6:	8526                	mv	a0,s1
    800045e8:	b7cfe0ef          	jal	80002964 <iunlockput>
    end_op();
    800045ec:	be9fe0ef          	jal	800031d4 <end_op>
    return -1;
    800045f0:	557d                	li	a0,-1
    800045f2:	74aa                	ld	s1,168(sp)
    800045f4:	b75d                	j	8000459a <sys_open+0xca>
      fileclose(f);
    800045f6:	854a                	mv	a0,s2
    800045f8:	f91fe0ef          	jal	80003588 <fileclose>
    800045fc:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800045fe:	8526                	mv	a0,s1
    80004600:	b64fe0ef          	jal	80002964 <iunlockput>
    end_op();
    80004604:	bd1fe0ef          	jal	800031d4 <end_op>
    return -1;
    80004608:	557d                	li	a0,-1
    8000460a:	74aa                	ld	s1,168(sp)
    8000460c:	790a                	ld	s2,160(sp)
    8000460e:	b771                	j	8000459a <sys_open+0xca>
    f->type = FD_DEVICE;
    80004610:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004614:	04649783          	lh	a5,70(s1)
    80004618:	02f91223          	sh	a5,36(s2)
    8000461c:	bf35                	j	80004558 <sys_open+0x88>
    itrunc(ip);
    8000461e:	8526                	mv	a0,s1
    80004620:	a26fe0ef          	jal	80002846 <itrunc>
    80004624:	b795                	j	80004588 <sys_open+0xb8>

0000000080004626 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004626:	7175                	addi	sp,sp,-144
    80004628:	e506                	sd	ra,136(sp)
    8000462a:	e122                	sd	s0,128(sp)
    8000462c:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    8000462e:	b37fe0ef          	jal	80003164 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004632:	08000613          	li	a2,128
    80004636:	f7040593          	addi	a1,s0,-144
    8000463a:	4501                	li	a0,0
    8000463c:	ea2fd0ef          	jal	80001cde <argstr>
    80004640:	02054363          	bltz	a0,80004666 <sys_mkdir+0x40>
    80004644:	4681                	li	a3,0
    80004646:	4601                	li	a2,0
    80004648:	4585                	li	a1,1
    8000464a:	f7040513          	addi	a0,s0,-144
    8000464e:	973ff0ef          	jal	80003fc0 <create>
    80004652:	c911                	beqz	a0,80004666 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004654:	b10fe0ef          	jal	80002964 <iunlockput>
  end_op();
    80004658:	b7dfe0ef          	jal	800031d4 <end_op>
  return 0;
    8000465c:	4501                	li	a0,0
}
    8000465e:	60aa                	ld	ra,136(sp)
    80004660:	640a                	ld	s0,128(sp)
    80004662:	6149                	addi	sp,sp,144
    80004664:	8082                	ret
    end_op();
    80004666:	b6ffe0ef          	jal	800031d4 <end_op>
    return -1;
    8000466a:	557d                	li	a0,-1
    8000466c:	bfcd                	j	8000465e <sys_mkdir+0x38>

000000008000466e <sys_mknod>:

uint64
sys_mknod(void)
{
    8000466e:	7135                	addi	sp,sp,-160
    80004670:	ed06                	sd	ra,152(sp)
    80004672:	e922                	sd	s0,144(sp)
    80004674:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004676:	aeffe0ef          	jal	80003164 <begin_op>
  argint(1, &major);
    8000467a:	f6c40593          	addi	a1,s0,-148
    8000467e:	4505                	li	a0,1
    80004680:	e26fd0ef          	jal	80001ca6 <argint>
  argint(2, &minor);
    80004684:	f6840593          	addi	a1,s0,-152
    80004688:	4509                	li	a0,2
    8000468a:	e1cfd0ef          	jal	80001ca6 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000468e:	08000613          	li	a2,128
    80004692:	f7040593          	addi	a1,s0,-144
    80004696:	4501                	li	a0,0
    80004698:	e46fd0ef          	jal	80001cde <argstr>
    8000469c:	02054563          	bltz	a0,800046c6 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    800046a0:	f6841683          	lh	a3,-152(s0)
    800046a4:	f6c41603          	lh	a2,-148(s0)
    800046a8:	458d                	li	a1,3
    800046aa:	f7040513          	addi	a0,s0,-144
    800046ae:	913ff0ef          	jal	80003fc0 <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    800046b2:	c911                	beqz	a0,800046c6 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    800046b4:	ab0fe0ef          	jal	80002964 <iunlockput>
  end_op();
    800046b8:	b1dfe0ef          	jal	800031d4 <end_op>
  return 0;
    800046bc:	4501                	li	a0,0
}
    800046be:	60ea                	ld	ra,152(sp)
    800046c0:	644a                	ld	s0,144(sp)
    800046c2:	610d                	addi	sp,sp,160
    800046c4:	8082                	ret
    end_op();
    800046c6:	b0ffe0ef          	jal	800031d4 <end_op>
    return -1;
    800046ca:	557d                	li	a0,-1
    800046cc:	bfcd                	j	800046be <sys_mknod+0x50>

00000000800046ce <sys_chdir>:

uint64
sys_chdir(void)
{
    800046ce:	7135                	addi	sp,sp,-160
    800046d0:	ed06                	sd	ra,152(sp)
    800046d2:	e922                	sd	s0,144(sp)
    800046d4:	e14a                	sd	s2,128(sp)
    800046d6:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    800046d8:	ea6fc0ef          	jal	80000d7e <myproc>
    800046dc:	892a                	mv	s2,a0
  
  begin_op();
    800046de:	a87fe0ef          	jal	80003164 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    800046e2:	08000613          	li	a2,128
    800046e6:	f6040593          	addi	a1,s0,-160
    800046ea:	4501                	li	a0,0
    800046ec:	df2fd0ef          	jal	80001cde <argstr>
    800046f0:	04054363          	bltz	a0,80004736 <sys_chdir+0x68>
    800046f4:	e526                	sd	s1,136(sp)
    800046f6:	f6040513          	addi	a0,s0,-160
    800046fa:	88dfe0ef          	jal	80002f86 <namei>
    800046fe:	84aa                	mv	s1,a0
    80004700:	c915                	beqz	a0,80004734 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004702:	856fe0ef          	jal	80002758 <ilock>
  if(ip->type != T_DIR){
    80004706:	04449703          	lh	a4,68(s1)
    8000470a:	4785                	li	a5,1
    8000470c:	02f71963          	bne	a4,a5,8000473e <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004710:	8526                	mv	a0,s1
    80004712:	8f4fe0ef          	jal	80002806 <iunlock>
  iput(p->cwd);
    80004716:	15093503          	ld	a0,336(s2)
    8000471a:	9c0fe0ef          	jal	800028da <iput>
  end_op();
    8000471e:	ab7fe0ef          	jal	800031d4 <end_op>
  p->cwd = ip;
    80004722:	14993823          	sd	s1,336(s2)
  return 0;
    80004726:	4501                	li	a0,0
    80004728:	64aa                	ld	s1,136(sp)
}
    8000472a:	60ea                	ld	ra,152(sp)
    8000472c:	644a                	ld	s0,144(sp)
    8000472e:	690a                	ld	s2,128(sp)
    80004730:	610d                	addi	sp,sp,160
    80004732:	8082                	ret
    80004734:	64aa                	ld	s1,136(sp)
    end_op();
    80004736:	a9ffe0ef          	jal	800031d4 <end_op>
    return -1;
    8000473a:	557d                	li	a0,-1
    8000473c:	b7fd                	j	8000472a <sys_chdir+0x5c>
    iunlockput(ip);
    8000473e:	8526                	mv	a0,s1
    80004740:	a24fe0ef          	jal	80002964 <iunlockput>
    end_op();
    80004744:	a91fe0ef          	jal	800031d4 <end_op>
    return -1;
    80004748:	557d                	li	a0,-1
    8000474a:	64aa                	ld	s1,136(sp)
    8000474c:	bff9                	j	8000472a <sys_chdir+0x5c>

000000008000474e <sys_exec>:

uint64
sys_exec(void)
{
    8000474e:	7105                	addi	sp,sp,-480
    80004750:	ef86                	sd	ra,472(sp)
    80004752:	eba2                	sd	s0,464(sp)
    80004754:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004756:	e2840593          	addi	a1,s0,-472
    8000475a:	4505                	li	a0,1
    8000475c:	d66fd0ef          	jal	80001cc2 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004760:	08000613          	li	a2,128
    80004764:	f3040593          	addi	a1,s0,-208
    80004768:	4501                	li	a0,0
    8000476a:	d74fd0ef          	jal	80001cde <argstr>
    8000476e:	87aa                	mv	a5,a0
    return -1;
    80004770:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004772:	0e07c063          	bltz	a5,80004852 <sys_exec+0x104>
    80004776:	e7a6                	sd	s1,456(sp)
    80004778:	e3ca                	sd	s2,448(sp)
    8000477a:	ff4e                	sd	s3,440(sp)
    8000477c:	fb52                	sd	s4,432(sp)
    8000477e:	f756                	sd	s5,424(sp)
    80004780:	f35a                	sd	s6,416(sp)
    80004782:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004784:	e3040a13          	addi	s4,s0,-464
    80004788:	10000613          	li	a2,256
    8000478c:	4581                	li	a1,0
    8000478e:	8552                	mv	a0,s4
    80004790:	9affb0ef          	jal	8000013e <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004794:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004796:	89d2                	mv	s3,s4
    80004798:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    8000479a:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000479e:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    800047a0:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    800047a4:	00391513          	slli	a0,s2,0x3
    800047a8:	85d6                	mv	a1,s5
    800047aa:	e2843783          	ld	a5,-472(s0)
    800047ae:	953e                	add	a0,a0,a5
    800047b0:	c6cfd0ef          	jal	80001c1c <fetchaddr>
    800047b4:	02054663          	bltz	a0,800047e0 <sys_exec+0x92>
    if(uarg == 0){
    800047b8:	e2043783          	ld	a5,-480(s0)
    800047bc:	c7a1                	beqz	a5,80004804 <sys_exec+0xb6>
    argv[i] = kalloc();
    800047be:	93ffb0ef          	jal	800000fc <kalloc>
    800047c2:	85aa                	mv	a1,a0
    800047c4:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    800047c8:	cd01                	beqz	a0,800047e0 <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    800047ca:	865a                	mv	a2,s6
    800047cc:	e2043503          	ld	a0,-480(s0)
    800047d0:	c96fd0ef          	jal	80001c66 <fetchstr>
    800047d4:	00054663          	bltz	a0,800047e0 <sys_exec+0x92>
    if(i >= NELEM(argv)){
    800047d8:	0905                	addi	s2,s2,1
    800047da:	09a1                	addi	s3,s3,8
    800047dc:	fd7914e3          	bne	s2,s7,800047a4 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800047e0:	100a0a13          	addi	s4,s4,256
    800047e4:	6088                	ld	a0,0(s1)
    800047e6:	cd31                	beqz	a0,80004842 <sys_exec+0xf4>
    kfree(argv[i]);
    800047e8:	835fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800047ec:	04a1                	addi	s1,s1,8
    800047ee:	ff449be3          	bne	s1,s4,800047e4 <sys_exec+0x96>
  return -1;
    800047f2:	557d                	li	a0,-1
    800047f4:	64be                	ld	s1,456(sp)
    800047f6:	691e                	ld	s2,448(sp)
    800047f8:	79fa                	ld	s3,440(sp)
    800047fa:	7a5a                	ld	s4,432(sp)
    800047fc:	7aba                	ld	s5,424(sp)
    800047fe:	7b1a                	ld	s6,416(sp)
    80004800:	6bfa                	ld	s7,408(sp)
    80004802:	a881                	j	80004852 <sys_exec+0x104>
      argv[i] = 0;
    80004804:	0009079b          	sext.w	a5,s2
    80004808:	e3040593          	addi	a1,s0,-464
    8000480c:	078e                	slli	a5,a5,0x3
    8000480e:	97ae                	add	a5,a5,a1
    80004810:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004814:	f3040513          	addi	a0,s0,-208
    80004818:	bb2ff0ef          	jal	80003bca <kexec>
    8000481c:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000481e:	100a0a13          	addi	s4,s4,256
    80004822:	6088                	ld	a0,0(s1)
    80004824:	c511                	beqz	a0,80004830 <sys_exec+0xe2>
    kfree(argv[i]);
    80004826:	ff6fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000482a:	04a1                	addi	s1,s1,8
    8000482c:	ff449be3          	bne	s1,s4,80004822 <sys_exec+0xd4>
  return ret;
    80004830:	854a                	mv	a0,s2
    80004832:	64be                	ld	s1,456(sp)
    80004834:	691e                	ld	s2,448(sp)
    80004836:	79fa                	ld	s3,440(sp)
    80004838:	7a5a                	ld	s4,432(sp)
    8000483a:	7aba                	ld	s5,424(sp)
    8000483c:	7b1a                	ld	s6,416(sp)
    8000483e:	6bfa                	ld	s7,408(sp)
    80004840:	a809                	j	80004852 <sys_exec+0x104>
  return -1;
    80004842:	557d                	li	a0,-1
    80004844:	64be                	ld	s1,456(sp)
    80004846:	691e                	ld	s2,448(sp)
    80004848:	79fa                	ld	s3,440(sp)
    8000484a:	7a5a                	ld	s4,432(sp)
    8000484c:	7aba                	ld	s5,424(sp)
    8000484e:	7b1a                	ld	s6,416(sp)
    80004850:	6bfa                	ld	s7,408(sp)
}
    80004852:	60fe                	ld	ra,472(sp)
    80004854:	645e                	ld	s0,464(sp)
    80004856:	613d                	addi	sp,sp,480
    80004858:	8082                	ret

000000008000485a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000485a:	7139                	addi	sp,sp,-64
    8000485c:	fc06                	sd	ra,56(sp)
    8000485e:	f822                	sd	s0,48(sp)
    80004860:	f426                	sd	s1,40(sp)
    80004862:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004864:	d1afc0ef          	jal	80000d7e <myproc>
    80004868:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    8000486a:	fd840593          	addi	a1,s0,-40
    8000486e:	4501                	li	a0,0
    80004870:	c52fd0ef          	jal	80001cc2 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004874:	fc840593          	addi	a1,s0,-56
    80004878:	fd040513          	addi	a0,s0,-48
    8000487c:	828ff0ef          	jal	800038a4 <pipealloc>
    return -1;
    80004880:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004882:	0a054763          	bltz	a0,80004930 <sys_pipe+0xd6>
  fd0 = -1;
    80004886:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    8000488a:	fd043503          	ld	a0,-48(s0)
    8000488e:	ef2ff0ef          	jal	80003f80 <fdalloc>
    80004892:	fca42223          	sw	a0,-60(s0)
    80004896:	08054463          	bltz	a0,8000491e <sys_pipe+0xc4>
    8000489a:	fc843503          	ld	a0,-56(s0)
    8000489e:	ee2ff0ef          	jal	80003f80 <fdalloc>
    800048a2:	fca42023          	sw	a0,-64(s0)
    800048a6:	06054263          	bltz	a0,8000490a <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048aa:	4691                	li	a3,4
    800048ac:	fc440613          	addi	a2,s0,-60
    800048b0:	fd843583          	ld	a1,-40(s0)
    800048b4:	68a8                	ld	a0,80(s1)
    800048b6:	9f8fc0ef          	jal	80000aae <copyout>
    800048ba:	00054e63          	bltz	a0,800048d6 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    800048be:	4691                	li	a3,4
    800048c0:	fc040613          	addi	a2,s0,-64
    800048c4:	fd843583          	ld	a1,-40(s0)
    800048c8:	95b6                	add	a1,a1,a3
    800048ca:	68a8                	ld	a0,80(s1)
    800048cc:	9e2fc0ef          	jal	80000aae <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    800048d0:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    800048d2:	04055f63          	bgez	a0,80004930 <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    800048d6:	fc442783          	lw	a5,-60(s0)
    800048da:	078e                	slli	a5,a5,0x3
    800048dc:	0d078793          	addi	a5,a5,208
    800048e0:	97a6                	add	a5,a5,s1
    800048e2:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    800048e6:	fc042783          	lw	a5,-64(s0)
    800048ea:	078e                	slli	a5,a5,0x3
    800048ec:	0d078793          	addi	a5,a5,208
    800048f0:	97a6                	add	a5,a5,s1
    800048f2:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    800048f6:	fd043503          	ld	a0,-48(s0)
    800048fa:	c8ffe0ef          	jal	80003588 <fileclose>
    fileclose(wf);
    800048fe:	fc843503          	ld	a0,-56(s0)
    80004902:	c87fe0ef          	jal	80003588 <fileclose>
    return -1;
    80004906:	57fd                	li	a5,-1
    80004908:	a025                	j	80004930 <sys_pipe+0xd6>
    if(fd0 >= 0)
    8000490a:	fc442783          	lw	a5,-60(s0)
    8000490e:	0007c863          	bltz	a5,8000491e <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004912:	078e                	slli	a5,a5,0x3
    80004914:	0d078793          	addi	a5,a5,208
    80004918:	97a6                	add	a5,a5,s1
    8000491a:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    8000491e:	fd043503          	ld	a0,-48(s0)
    80004922:	c67fe0ef          	jal	80003588 <fileclose>
    fileclose(wf);
    80004926:	fc843503          	ld	a0,-56(s0)
    8000492a:	c5ffe0ef          	jal	80003588 <fileclose>
    return -1;
    8000492e:	57fd                	li	a5,-1
}
    80004930:	853e                	mv	a0,a5
    80004932:	70e2                	ld	ra,56(sp)
    80004934:	7442                	ld	s0,48(sp)
    80004936:	74a2                	ld	s1,40(sp)
    80004938:	6121                	addi	sp,sp,64
    8000493a:	8082                	ret
    8000493c:	0000                	unimp
	...

0000000080004940 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004940:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004942:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004944:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004946:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004948:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    8000494a:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    8000494c:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    8000494e:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004950:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004952:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004954:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004956:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004958:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    8000495a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    8000495c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    8000495e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004960:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004962:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004964:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004966:	9c4fd0ef          	jal	80001b2a <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    8000496a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    8000496c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    8000496e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004970:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004972:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004974:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004976:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004978:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    8000497a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    8000497c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    8000497e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004980:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004982:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004984:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004986:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004988:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    8000498a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    8000498c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    8000498e:	10200073          	sret
    80004992:	00000013          	nop
    80004996:	00000013          	nop
    8000499a:	00000013          	nop

000000008000499e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000499e:	1141                	addi	sp,sp,-16
    800049a0:	e406                	sd	ra,8(sp)
    800049a2:	e022                	sd	s0,0(sp)
    800049a4:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800049a6:	0c000737          	lui	a4,0xc000
    800049aa:	4785                	li	a5,1
    800049ac:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800049ae:	c35c                	sw	a5,4(a4)
}
    800049b0:	60a2                	ld	ra,8(sp)
    800049b2:	6402                	ld	s0,0(sp)
    800049b4:	0141                	addi	sp,sp,16
    800049b6:	8082                	ret

00000000800049b8 <plicinithart>:

void
plicinithart(void)
{
    800049b8:	1141                	addi	sp,sp,-16
    800049ba:	e406                	sd	ra,8(sp)
    800049bc:	e022                	sd	s0,0(sp)
    800049be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049c0:	b8afc0ef          	jal	80000d4a <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800049c4:	0085171b          	slliw	a4,a0,0x8
    800049c8:	0c0027b7          	lui	a5,0xc002
    800049cc:	97ba                	add	a5,a5,a4
    800049ce:	40200713          	li	a4,1026
    800049d2:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800049d6:	00d5151b          	slliw	a0,a0,0xd
    800049da:	0c2017b7          	lui	a5,0xc201
    800049de:	97aa                	add	a5,a5,a0
    800049e0:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    800049e4:	60a2                	ld	ra,8(sp)
    800049e6:	6402                	ld	s0,0(sp)
    800049e8:	0141                	addi	sp,sp,16
    800049ea:	8082                	ret

00000000800049ec <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800049ec:	1141                	addi	sp,sp,-16
    800049ee:	e406                	sd	ra,8(sp)
    800049f0:	e022                	sd	s0,0(sp)
    800049f2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800049f4:	b56fc0ef          	jal	80000d4a <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800049f8:	00d5151b          	slliw	a0,a0,0xd
    800049fc:	0c2017b7          	lui	a5,0xc201
    80004a00:	97aa                	add	a5,a5,a0
  return irq;
}
    80004a02:	43c8                	lw	a0,4(a5)
    80004a04:	60a2                	ld	ra,8(sp)
    80004a06:	6402                	ld	s0,0(sp)
    80004a08:	0141                	addi	sp,sp,16
    80004a0a:	8082                	ret

0000000080004a0c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004a0c:	1101                	addi	sp,sp,-32
    80004a0e:	ec06                	sd	ra,24(sp)
    80004a10:	e822                	sd	s0,16(sp)
    80004a12:	e426                	sd	s1,8(sp)
    80004a14:	1000                	addi	s0,sp,32
    80004a16:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004a18:	b32fc0ef          	jal	80000d4a <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004a1c:	00d5179b          	slliw	a5,a0,0xd
    80004a20:	0c201737          	lui	a4,0xc201
    80004a24:	97ba                	add	a5,a5,a4
    80004a26:	c3c4                	sw	s1,4(a5)
}
    80004a28:	60e2                	ld	ra,24(sp)
    80004a2a:	6442                	ld	s0,16(sp)
    80004a2c:	64a2                	ld	s1,8(sp)
    80004a2e:	6105                	addi	sp,sp,32
    80004a30:	8082                	ret

0000000080004a32 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004a32:	1141                	addi	sp,sp,-16
    80004a34:	e406                	sd	ra,8(sp)
    80004a36:	e022                	sd	s0,0(sp)
    80004a38:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004a3a:	479d                	li	a5,7
    80004a3c:	04a7ca63          	blt	a5,a0,80004a90 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004a40:	00016797          	auipc	a5,0x16
    80004a44:	13078793          	addi	a5,a5,304 # 8001ab70 <disk>
    80004a48:	97aa                	add	a5,a5,a0
    80004a4a:	0187c783          	lbu	a5,24(a5)
    80004a4e:	e7b9                	bnez	a5,80004a9c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004a50:	00451693          	slli	a3,a0,0x4
    80004a54:	00016797          	auipc	a5,0x16
    80004a58:	11c78793          	addi	a5,a5,284 # 8001ab70 <disk>
    80004a5c:	6398                	ld	a4,0(a5)
    80004a5e:	9736                	add	a4,a4,a3
    80004a60:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004a64:	6398                	ld	a4,0(a5)
    80004a66:	9736                	add	a4,a4,a3
    80004a68:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004a6c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004a70:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004a74:	97aa                	add	a5,a5,a0
    80004a76:	4705                	li	a4,1
    80004a78:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004a7c:	00016517          	auipc	a0,0x16
    80004a80:	10c50513          	addi	a0,a0,268 # 8001ab88 <disk+0x18>
    80004a84:	963fc0ef          	jal	800013e6 <wakeup>
}
    80004a88:	60a2                	ld	ra,8(sp)
    80004a8a:	6402                	ld	s0,0(sp)
    80004a8c:	0141                	addi	sp,sp,16
    80004a8e:	8082                	ret
    panic("free_desc 1");
    80004a90:	00003517          	auipc	a0,0x3
    80004a94:	b3850513          	addi	a0,a0,-1224 # 800075c8 <etext+0x5c8>
    80004a98:	49f000ef          	jal	80005736 <panic>
    panic("free_desc 2");
    80004a9c:	00003517          	auipc	a0,0x3
    80004aa0:	b3c50513          	addi	a0,a0,-1220 # 800075d8 <etext+0x5d8>
    80004aa4:	493000ef          	jal	80005736 <panic>

0000000080004aa8 <virtio_disk_init>:
{
    80004aa8:	1101                	addi	sp,sp,-32
    80004aaa:	ec06                	sd	ra,24(sp)
    80004aac:	e822                	sd	s0,16(sp)
    80004aae:	e426                	sd	s1,8(sp)
    80004ab0:	e04a                	sd	s2,0(sp)
    80004ab2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004ab4:	00003597          	auipc	a1,0x3
    80004ab8:	b3458593          	addi	a1,a1,-1228 # 800075e8 <etext+0x5e8>
    80004abc:	00016517          	auipc	a0,0x16
    80004ac0:	1dc50513          	addi	a0,a0,476 # 8001ac98 <disk+0x128>
    80004ac4:	6ab000ef          	jal	8000596e <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004ac8:	100017b7          	lui	a5,0x10001
    80004acc:	4398                	lw	a4,0(a5)
    80004ace:	2701                	sext.w	a4,a4
    80004ad0:	747277b7          	lui	a5,0x74727
    80004ad4:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004ad8:	14f71863          	bne	a4,a5,80004c28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004adc:	100017b7          	lui	a5,0x10001
    80004ae0:	43dc                	lw	a5,4(a5)
    80004ae2:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004ae4:	4709                	li	a4,2
    80004ae6:	14e79163          	bne	a5,a4,80004c28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004aea:	100017b7          	lui	a5,0x10001
    80004aee:	479c                	lw	a5,8(a5)
    80004af0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004af2:	12e79b63          	bne	a5,a4,80004c28 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004af6:	100017b7          	lui	a5,0x10001
    80004afa:	47d8                	lw	a4,12(a5)
    80004afc:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004afe:	554d47b7          	lui	a5,0x554d4
    80004b02:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004b06:	12f71163          	bne	a4,a5,80004c28 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b0a:	100017b7          	lui	a5,0x10001
    80004b0e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b12:	4705                	li	a4,1
    80004b14:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b16:	470d                	li	a4,3
    80004b18:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004b1a:	10001737          	lui	a4,0x10001
    80004b1e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004b20:	c7ffe6b7          	lui	a3,0xc7ffe
    80004b24:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fdb9d7>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004b28:	8f75                	and	a4,a4,a3
    80004b2a:	100016b7          	lui	a3,0x10001
    80004b2e:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b30:	472d                	li	a4,11
    80004b32:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004b34:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004b38:	439c                	lw	a5,0(a5)
    80004b3a:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004b3e:	8ba1                	andi	a5,a5,8
    80004b40:	0e078a63          	beqz	a5,80004c34 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004b44:	100017b7          	lui	a5,0x10001
    80004b48:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004b4c:	43fc                	lw	a5,68(a5)
    80004b4e:	2781                	sext.w	a5,a5
    80004b50:	0e079863          	bnez	a5,80004c40 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004b54:	100017b7          	lui	a5,0x10001
    80004b58:	5bdc                	lw	a5,52(a5)
    80004b5a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004b5c:	0e078863          	beqz	a5,80004c4c <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004b60:	471d                	li	a4,7
    80004b62:	0ef77b63          	bgeu	a4,a5,80004c58 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004b66:	d96fb0ef          	jal	800000fc <kalloc>
    80004b6a:	00016497          	auipc	s1,0x16
    80004b6e:	00648493          	addi	s1,s1,6 # 8001ab70 <disk>
    80004b72:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004b74:	d88fb0ef          	jal	800000fc <kalloc>
    80004b78:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004b7a:	d82fb0ef          	jal	800000fc <kalloc>
    80004b7e:	87aa                	mv	a5,a0
    80004b80:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004b82:	6088                	ld	a0,0(s1)
    80004b84:	0e050063          	beqz	a0,80004c64 <virtio_disk_init+0x1bc>
    80004b88:	00016717          	auipc	a4,0x16
    80004b8c:	ff073703          	ld	a4,-16(a4) # 8001ab78 <disk+0x8>
    80004b90:	cb71                	beqz	a4,80004c64 <virtio_disk_init+0x1bc>
    80004b92:	cbe9                	beqz	a5,80004c64 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004b94:	6605                	lui	a2,0x1
    80004b96:	4581                	li	a1,0
    80004b98:	da6fb0ef          	jal	8000013e <memset>
  memset(disk.avail, 0, PGSIZE);
    80004b9c:	00016497          	auipc	s1,0x16
    80004ba0:	fd448493          	addi	s1,s1,-44 # 8001ab70 <disk>
    80004ba4:	6605                	lui	a2,0x1
    80004ba6:	4581                	li	a1,0
    80004ba8:	6488                	ld	a0,8(s1)
    80004baa:	d94fb0ef          	jal	8000013e <memset>
  memset(disk.used, 0, PGSIZE);
    80004bae:	6605                	lui	a2,0x1
    80004bb0:	4581                	li	a1,0
    80004bb2:	6888                	ld	a0,16(s1)
    80004bb4:	d8afb0ef          	jal	8000013e <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004bb8:	100017b7          	lui	a5,0x10001
    80004bbc:	4721                	li	a4,8
    80004bbe:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004bc0:	4098                	lw	a4,0(s1)
    80004bc2:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004bc6:	40d8                	lw	a4,4(s1)
    80004bc8:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004bcc:	649c                	ld	a5,8(s1)
    80004bce:	0007869b          	sext.w	a3,a5
    80004bd2:	10001737          	lui	a4,0x10001
    80004bd6:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004bda:	9781                	srai	a5,a5,0x20
    80004bdc:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004be0:	689c                	ld	a5,16(s1)
    80004be2:	0007869b          	sext.w	a3,a5
    80004be6:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004bea:	9781                	srai	a5,a5,0x20
    80004bec:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004bf0:	4785                	li	a5,1
    80004bf2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004bf4:	00f48c23          	sb	a5,24(s1)
    80004bf8:	00f48ca3          	sb	a5,25(s1)
    80004bfc:	00f48d23          	sb	a5,26(s1)
    80004c00:	00f48da3          	sb	a5,27(s1)
    80004c04:	00f48e23          	sb	a5,28(s1)
    80004c08:	00f48ea3          	sb	a5,29(s1)
    80004c0c:	00f48f23          	sb	a5,30(s1)
    80004c10:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004c14:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004c18:	07272823          	sw	s2,112(a4)
}
    80004c1c:	60e2                	ld	ra,24(sp)
    80004c1e:	6442                	ld	s0,16(sp)
    80004c20:	64a2                	ld	s1,8(sp)
    80004c22:	6902                	ld	s2,0(sp)
    80004c24:	6105                	addi	sp,sp,32
    80004c26:	8082                	ret
    panic("could not find virtio disk");
    80004c28:	00003517          	auipc	a0,0x3
    80004c2c:	9d050513          	addi	a0,a0,-1584 # 800075f8 <etext+0x5f8>
    80004c30:	307000ef          	jal	80005736 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004c34:	00003517          	auipc	a0,0x3
    80004c38:	9e450513          	addi	a0,a0,-1564 # 80007618 <etext+0x618>
    80004c3c:	2fb000ef          	jal	80005736 <panic>
    panic("virtio disk should not be ready");
    80004c40:	00003517          	auipc	a0,0x3
    80004c44:	9f850513          	addi	a0,a0,-1544 # 80007638 <etext+0x638>
    80004c48:	2ef000ef          	jal	80005736 <panic>
    panic("virtio disk has no queue 0");
    80004c4c:	00003517          	auipc	a0,0x3
    80004c50:	a0c50513          	addi	a0,a0,-1524 # 80007658 <etext+0x658>
    80004c54:	2e3000ef          	jal	80005736 <panic>
    panic("virtio disk max queue too short");
    80004c58:	00003517          	auipc	a0,0x3
    80004c5c:	a2050513          	addi	a0,a0,-1504 # 80007678 <etext+0x678>
    80004c60:	2d7000ef          	jal	80005736 <panic>
    panic("virtio disk kalloc");
    80004c64:	00003517          	auipc	a0,0x3
    80004c68:	a3450513          	addi	a0,a0,-1484 # 80007698 <etext+0x698>
    80004c6c:	2cb000ef          	jal	80005736 <panic>

0000000080004c70 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004c70:	711d                	addi	sp,sp,-96
    80004c72:	ec86                	sd	ra,88(sp)
    80004c74:	e8a2                	sd	s0,80(sp)
    80004c76:	e4a6                	sd	s1,72(sp)
    80004c78:	e0ca                	sd	s2,64(sp)
    80004c7a:	fc4e                	sd	s3,56(sp)
    80004c7c:	f852                	sd	s4,48(sp)
    80004c7e:	f456                	sd	s5,40(sp)
    80004c80:	f05a                	sd	s6,32(sp)
    80004c82:	ec5e                	sd	s7,24(sp)
    80004c84:	e862                	sd	s8,16(sp)
    80004c86:	1080                	addi	s0,sp,96
    80004c88:	89aa                	mv	s3,a0
    80004c8a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004c8c:	00c52b83          	lw	s7,12(a0)
    80004c90:	001b9b9b          	slliw	s7,s7,0x1
    80004c94:	1b82                	slli	s7,s7,0x20
    80004c96:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004c9a:	00016517          	auipc	a0,0x16
    80004c9e:	ffe50513          	addi	a0,a0,-2 # 8001ac98 <disk+0x128>
    80004ca2:	557000ef          	jal	800059f8 <acquire>
  for(int i = 0; i < NUM; i++){
    80004ca6:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004ca8:	00016a97          	auipc	s5,0x16
    80004cac:	ec8a8a93          	addi	s5,s5,-312 # 8001ab70 <disk>
  for(int i = 0; i < 3; i++){
    80004cb0:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004cb2:	5c7d                	li	s8,-1
    80004cb4:	a095                	j	80004d18 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004cb6:	00fa8733          	add	a4,s5,a5
    80004cba:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004cbe:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004cc0:	0207c563          	bltz	a5,80004cea <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004cc4:	2905                	addiw	s2,s2,1
    80004cc6:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004cc8:	05490c63          	beq	s2,s4,80004d20 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004ccc:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004cce:	00016717          	auipc	a4,0x16
    80004cd2:	ea270713          	addi	a4,a4,-350 # 8001ab70 <disk>
    80004cd6:	4781                	li	a5,0
    if(disk.free[i]){
    80004cd8:	01874683          	lbu	a3,24(a4)
    80004cdc:	fee9                	bnez	a3,80004cb6 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004cde:	2785                	addiw	a5,a5,1
    80004ce0:	0705                	addi	a4,a4,1
    80004ce2:	fe979be3          	bne	a5,s1,80004cd8 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004ce6:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004cea:	01205d63          	blez	s2,80004d04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004cee:	fa042503          	lw	a0,-96(s0)
    80004cf2:	d41ff0ef          	jal	80004a32 <free_desc>
      for(int j = 0; j < i; j++)
    80004cf6:	4785                	li	a5,1
    80004cf8:	0127d663          	bge	a5,s2,80004d04 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004cfc:	fa442503          	lw	a0,-92(s0)
    80004d00:	d33ff0ef          	jal	80004a32 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004d04:	00016597          	auipc	a1,0x16
    80004d08:	f9458593          	addi	a1,a1,-108 # 8001ac98 <disk+0x128>
    80004d0c:	00016517          	auipc	a0,0x16
    80004d10:	e7c50513          	addi	a0,a0,-388 # 8001ab88 <disk+0x18>
    80004d14:	e86fc0ef          	jal	8000139a <sleep>
  for(int i = 0; i < 3; i++){
    80004d18:	fa040613          	addi	a2,s0,-96
    80004d1c:	4901                	li	s2,0
    80004d1e:	b77d                	j	80004ccc <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d20:	fa042503          	lw	a0,-96(s0)
    80004d24:	00451693          	slli	a3,a0,0x4

  if(write)
    80004d28:	00016797          	auipc	a5,0x16
    80004d2c:	e4878793          	addi	a5,a5,-440 # 8001ab70 <disk>
    80004d30:	00451713          	slli	a4,a0,0x4
    80004d34:	0a070713          	addi	a4,a4,160
    80004d38:	973e                	add	a4,a4,a5
    80004d3a:	01603633          	snez	a2,s6
    80004d3e:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004d40:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004d44:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d48:	6398                	ld	a4,0(a5)
    80004d4a:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004d4c:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004d50:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004d52:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004d54:	6390                	ld	a2,0(a5)
    80004d56:	00d60833          	add	a6,a2,a3
    80004d5a:	4741                	li	a4,16
    80004d5c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004d60:	4585                	li	a1,1
    80004d62:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004d66:	fa442703          	lw	a4,-92(s0)
    80004d6a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004d6e:	0712                	slli	a4,a4,0x4
    80004d70:	963a                	add	a2,a2,a4
    80004d72:	05898813          	addi	a6,s3,88
    80004d76:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004d7a:	0007b883          	ld	a7,0(a5)
    80004d7e:	9746                	add	a4,a4,a7
    80004d80:	40000613          	li	a2,1024
    80004d84:	c710                	sw	a2,8(a4)
  if(write)
    80004d86:	001b3613          	seqz	a2,s6
    80004d8a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004d8e:	8e4d                	or	a2,a2,a1
    80004d90:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004d94:	fa842603          	lw	a2,-88(s0)
    80004d98:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004d9c:	00451813          	slli	a6,a0,0x4
    80004da0:	02080813          	addi	a6,a6,32
    80004da4:	983e                	add	a6,a6,a5
    80004da6:	577d                	li	a4,-1
    80004da8:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004dac:	0612                	slli	a2,a2,0x4
    80004dae:	98b2                	add	a7,a7,a2
    80004db0:	03068713          	addi	a4,a3,48
    80004db4:	973e                	add	a4,a4,a5
    80004db6:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004dba:	6398                	ld	a4,0(a5)
    80004dbc:	9732                	add	a4,a4,a2
    80004dbe:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004dc0:	4689                	li	a3,2
    80004dc2:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004dc6:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004dca:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004dce:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004dd2:	6794                	ld	a3,8(a5)
    80004dd4:	0026d703          	lhu	a4,2(a3)
    80004dd8:	8b1d                	andi	a4,a4,7
    80004dda:	0706                	slli	a4,a4,0x1
    80004ddc:	96ba                	add	a3,a3,a4
    80004dde:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004de2:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004de6:	6798                	ld	a4,8(a5)
    80004de8:	00275783          	lhu	a5,2(a4)
    80004dec:	2785                	addiw	a5,a5,1
    80004dee:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004df2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004df6:	100017b7          	lui	a5,0x10001
    80004dfa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004dfe:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004e02:	00016917          	auipc	s2,0x16
    80004e06:	e9690913          	addi	s2,s2,-362 # 8001ac98 <disk+0x128>
  while(b->disk == 1) {
    80004e0a:	84ae                	mv	s1,a1
    80004e0c:	00b79a63          	bne	a5,a1,80004e20 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004e10:	85ca                	mv	a1,s2
    80004e12:	854e                	mv	a0,s3
    80004e14:	d86fc0ef          	jal	8000139a <sleep>
  while(b->disk == 1) {
    80004e18:	0049a783          	lw	a5,4(s3)
    80004e1c:	fe978ae3          	beq	a5,s1,80004e10 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004e20:	fa042903          	lw	s2,-96(s0)
    80004e24:	00491713          	slli	a4,s2,0x4
    80004e28:	02070713          	addi	a4,a4,32
    80004e2c:	00016797          	auipc	a5,0x16
    80004e30:	d4478793          	addi	a5,a5,-700 # 8001ab70 <disk>
    80004e34:	97ba                	add	a5,a5,a4
    80004e36:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004e3a:	00016997          	auipc	s3,0x16
    80004e3e:	d3698993          	addi	s3,s3,-714 # 8001ab70 <disk>
    80004e42:	00491713          	slli	a4,s2,0x4
    80004e46:	0009b783          	ld	a5,0(s3)
    80004e4a:	97ba                	add	a5,a5,a4
    80004e4c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80004e50:	854a                	mv	a0,s2
    80004e52:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80004e56:	bddff0ef          	jal	80004a32 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80004e5a:	8885                	andi	s1,s1,1
    80004e5c:	f0fd                	bnez	s1,80004e42 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80004e5e:	00016517          	auipc	a0,0x16
    80004e62:	e3a50513          	addi	a0,a0,-454 # 8001ac98 <disk+0x128>
    80004e66:	427000ef          	jal	80005a8c <release>
}
    80004e6a:	60e6                	ld	ra,88(sp)
    80004e6c:	6446                	ld	s0,80(sp)
    80004e6e:	64a6                	ld	s1,72(sp)
    80004e70:	6906                	ld	s2,64(sp)
    80004e72:	79e2                	ld	s3,56(sp)
    80004e74:	7a42                	ld	s4,48(sp)
    80004e76:	7aa2                	ld	s5,40(sp)
    80004e78:	7b02                	ld	s6,32(sp)
    80004e7a:	6be2                	ld	s7,24(sp)
    80004e7c:	6c42                	ld	s8,16(sp)
    80004e7e:	6125                	addi	sp,sp,96
    80004e80:	8082                	ret

0000000080004e82 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80004e82:	1101                	addi	sp,sp,-32
    80004e84:	ec06                	sd	ra,24(sp)
    80004e86:	e822                	sd	s0,16(sp)
    80004e88:	e426                	sd	s1,8(sp)
    80004e8a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80004e8c:	00016497          	auipc	s1,0x16
    80004e90:	ce448493          	addi	s1,s1,-796 # 8001ab70 <disk>
    80004e94:	00016517          	auipc	a0,0x16
    80004e98:	e0450513          	addi	a0,a0,-508 # 8001ac98 <disk+0x128>
    80004e9c:	35d000ef          	jal	800059f8 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80004ea0:	100017b7          	lui	a5,0x10001
    80004ea4:	53bc                	lw	a5,96(a5)
    80004ea6:	8b8d                	andi	a5,a5,3
    80004ea8:	10001737          	lui	a4,0x10001
    80004eac:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80004eae:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80004eb2:	689c                	ld	a5,16(s1)
    80004eb4:	0204d703          	lhu	a4,32(s1)
    80004eb8:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    80004ebc:	04f70863          	beq	a4,a5,80004f0c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80004ec0:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80004ec4:	6898                	ld	a4,16(s1)
    80004ec6:	0204d783          	lhu	a5,32(s1)
    80004eca:	8b9d                	andi	a5,a5,7
    80004ecc:	078e                	slli	a5,a5,0x3
    80004ece:	97ba                	add	a5,a5,a4
    80004ed0:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80004ed2:	00479713          	slli	a4,a5,0x4
    80004ed6:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    80004eda:	9726                	add	a4,a4,s1
    80004edc:	01074703          	lbu	a4,16(a4)
    80004ee0:	e329                	bnez	a4,80004f22 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80004ee2:	0792                	slli	a5,a5,0x4
    80004ee4:	02078793          	addi	a5,a5,32
    80004ee8:	97a6                	add	a5,a5,s1
    80004eea:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80004eec:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80004ef0:	cf6fc0ef          	jal	800013e6 <wakeup>

    disk.used_idx += 1;
    80004ef4:	0204d783          	lhu	a5,32(s1)
    80004ef8:	2785                	addiw	a5,a5,1
    80004efa:	17c2                	slli	a5,a5,0x30
    80004efc:	93c1                	srli	a5,a5,0x30
    80004efe:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80004f02:	6898                	ld	a4,16(s1)
    80004f04:	00275703          	lhu	a4,2(a4)
    80004f08:	faf71ce3          	bne	a4,a5,80004ec0 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80004f0c:	00016517          	auipc	a0,0x16
    80004f10:	d8c50513          	addi	a0,a0,-628 # 8001ac98 <disk+0x128>
    80004f14:	379000ef          	jal	80005a8c <release>
}
    80004f18:	60e2                	ld	ra,24(sp)
    80004f1a:	6442                	ld	s0,16(sp)
    80004f1c:	64a2                	ld	s1,8(sp)
    80004f1e:	6105                	addi	sp,sp,32
    80004f20:	8082                	ret
      panic("virtio_disk_intr status");
    80004f22:	00002517          	auipc	a0,0x2
    80004f26:	78e50513          	addi	a0,a0,1934 # 800076b0 <etext+0x6b0>
    80004f2a:	00d000ef          	jal	80005736 <panic>

0000000080004f2e <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    80004f2e:	1141                	addi	sp,sp,-16
    80004f30:	e406                	sd	ra,8(sp)
    80004f32:	e022                	sd	s0,0(sp)
    80004f34:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    80004f36:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    80004f3a:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    80004f3e:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    80004f42:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    80004f46:	577d                	li	a4,-1
    80004f48:	177e                	slli	a4,a4,0x3f
    80004f4a:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    80004f4c:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80004f50:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80004f54:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80004f58:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    80004f5c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80004f60:	000f4737          	lui	a4,0xf4
    80004f64:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80004f68:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80004f6a:	14d79073          	csrw	stimecmp,a5
}
    80004f6e:	60a2                	ld	ra,8(sp)
    80004f70:	6402                	ld	s0,0(sp)
    80004f72:	0141                	addi	sp,sp,16
    80004f74:	8082                	ret

0000000080004f76 <start>:
{
    80004f76:	1141                	addi	sp,sp,-16
    80004f78:	e406                	sd	ra,8(sp)
    80004f7a:	e022                	sd	s0,0(sp)
    80004f7c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80004f7e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80004f82:	7779                	lui	a4,0xffffe
    80004f84:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffdba77>
    80004f88:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80004f8a:	6705                	lui	a4,0x1
    80004f8c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80004f90:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80004f92:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80004f96:	ffffb797          	auipc	a5,0xffffb
    80004f9a:	35e78793          	addi	a5,a5,862 # 800002f4 <main>
    80004f9e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80004fa2:	4781                	li	a5,0
    80004fa4:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80004fa8:	67c1                	lui	a5,0x10
    80004faa:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    80004fac:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80004fb0:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80004fb4:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80004fb8:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    80004fbc:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80004fc0:	57fd                	li	a5,-1
    80004fc2:	83a9                	srli	a5,a5,0xa
    80004fc4:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80004fc8:	47bd                	li	a5,15
    80004fca:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80004fce:	f61ff0ef          	jal	80004f2e <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80004fd2:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80004fd6:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80004fd8:	823e                	mv	tp,a5
  asm volatile("mret");
    80004fda:	30200073          	mret
}
    80004fde:	60a2                	ld	ra,8(sp)
    80004fe0:	6402                	ld	s0,0(sp)
    80004fe2:	0141                	addi	sp,sp,16
    80004fe4:	8082                	ret

0000000080004fe6 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80004fe6:	7119                	addi	sp,sp,-128
    80004fe8:	fc86                	sd	ra,120(sp)
    80004fea:	f8a2                	sd	s0,112(sp)
    80004fec:	f4a6                	sd	s1,104(sp)
    80004fee:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80004ff0:	06c05b63          	blez	a2,80005066 <consolewrite+0x80>
    80004ff4:	f0ca                	sd	s2,96(sp)
    80004ff6:	ecce                	sd	s3,88(sp)
    80004ff8:	e8d2                	sd	s4,80(sp)
    80004ffa:	e4d6                	sd	s5,72(sp)
    80004ffc:	e0da                	sd	s6,64(sp)
    80004ffe:	fc5e                	sd	s7,56(sp)
    80005000:	f862                	sd	s8,48(sp)
    80005002:	f466                	sd	s9,40(sp)
    80005004:	f06a                	sd	s10,32(sp)
    80005006:	8b2a                	mv	s6,a0
    80005008:	8bae                	mv	s7,a1
    8000500a:	8a32                	mv	s4,a2
  int i = 0;
    8000500c:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    8000500e:	02000c93          	li	s9,32
    80005012:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005016:	f8040a93          	addi	s5,s0,-128
    8000501a:	5c7d                	li	s8,-1
    8000501c:	a025                	j	80005044 <consolewrite+0x5e>
    if(nn > n - i)
    8000501e:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005022:	86ce                	mv	a3,s3
    80005024:	01748633          	add	a2,s1,s7
    80005028:	85da                	mv	a1,s6
    8000502a:	8556                	mv	a0,s5
    8000502c:	f12fc0ef          	jal	8000173e <either_copyin>
    80005030:	03850d63          	beq	a0,s8,8000506a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    80005034:	85ce                	mv	a1,s3
    80005036:	8556                	mv	a0,s5
    80005038:	7b4000ef          	jal	800057ec <uartwrite>
    i += nn;
    8000503c:	009904bb          	addw	s1,s2,s1
  while(i < n){
    80005040:	0144d963          	bge	s1,s4,80005052 <consolewrite+0x6c>
    if(nn > n - i)
    80005044:	409a07bb          	subw	a5,s4,s1
    80005048:	893e                	mv	s2,a5
    8000504a:	fcfcdae3          	bge	s9,a5,8000501e <consolewrite+0x38>
    8000504e:	896a                	mv	s2,s10
    80005050:	b7f9                	j	8000501e <consolewrite+0x38>
    80005052:	7906                	ld	s2,96(sp)
    80005054:	69e6                	ld	s3,88(sp)
    80005056:	6a46                	ld	s4,80(sp)
    80005058:	6aa6                	ld	s5,72(sp)
    8000505a:	6b06                	ld	s6,64(sp)
    8000505c:	7be2                	ld	s7,56(sp)
    8000505e:	7c42                	ld	s8,48(sp)
    80005060:	7ca2                	ld	s9,40(sp)
    80005062:	7d02                	ld	s10,32(sp)
    80005064:	a821                	j	8000507c <consolewrite+0x96>
  int i = 0;
    80005066:	4481                	li	s1,0
    80005068:	a811                	j	8000507c <consolewrite+0x96>
    8000506a:	7906                	ld	s2,96(sp)
    8000506c:	69e6                	ld	s3,88(sp)
    8000506e:	6a46                	ld	s4,80(sp)
    80005070:	6aa6                	ld	s5,72(sp)
    80005072:	6b06                	ld	s6,64(sp)
    80005074:	7be2                	ld	s7,56(sp)
    80005076:	7c42                	ld	s8,48(sp)
    80005078:	7ca2                	ld	s9,40(sp)
    8000507a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000507c:	8526                	mv	a0,s1
    8000507e:	70e6                	ld	ra,120(sp)
    80005080:	7446                	ld	s0,112(sp)
    80005082:	74a6                	ld	s1,104(sp)
    80005084:	6109                	addi	sp,sp,128
    80005086:	8082                	ret

0000000080005088 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005088:	711d                	addi	sp,sp,-96
    8000508a:	ec86                	sd	ra,88(sp)
    8000508c:	e8a2                	sd	s0,80(sp)
    8000508e:	e4a6                	sd	s1,72(sp)
    80005090:	e0ca                	sd	s2,64(sp)
    80005092:	fc4e                	sd	s3,56(sp)
    80005094:	f852                	sd	s4,48(sp)
    80005096:	f05a                	sd	s6,32(sp)
    80005098:	ec5e                	sd	s7,24(sp)
    8000509a:	1080                	addi	s0,sp,96
    8000509c:	8b2a                	mv	s6,a0
    8000509e:	8a2e                	mv	s4,a1
    800050a0:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    800050a2:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    800050a4:	0001e517          	auipc	a0,0x1e
    800050a8:	c0c50513          	addi	a0,a0,-1012 # 80022cb0 <cons>
    800050ac:	14d000ef          	jal	800059f8 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    800050b0:	0001e497          	auipc	s1,0x1e
    800050b4:	c0048493          	addi	s1,s1,-1024 # 80022cb0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    800050b8:	0001e917          	auipc	s2,0x1e
    800050bc:	c9090913          	addi	s2,s2,-880 # 80022d48 <cons+0x98>
  while(n > 0){
    800050c0:	0b305b63          	blez	s3,80005176 <consoleread+0xee>
    while(cons.r == cons.w){
    800050c4:	0984a783          	lw	a5,152(s1)
    800050c8:	09c4a703          	lw	a4,156(s1)
    800050cc:	0af71063          	bne	a4,a5,8000516c <consoleread+0xe4>
      if(killed(myproc())){
    800050d0:	caffb0ef          	jal	80000d7e <myproc>
    800050d4:	d02fc0ef          	jal	800015d6 <killed>
    800050d8:	e12d                	bnez	a0,8000513a <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    800050da:	85a6                	mv	a1,s1
    800050dc:	854a                	mv	a0,s2
    800050de:	abcfc0ef          	jal	8000139a <sleep>
    while(cons.r == cons.w){
    800050e2:	0984a783          	lw	a5,152(s1)
    800050e6:	09c4a703          	lw	a4,156(s1)
    800050ea:	fef703e3          	beq	a4,a5,800050d0 <consoleread+0x48>
    800050ee:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800050f0:	0001e717          	auipc	a4,0x1e
    800050f4:	bc070713          	addi	a4,a4,-1088 # 80022cb0 <cons>
    800050f8:	0017869b          	addiw	a3,a5,1
    800050fc:	08d72c23          	sw	a3,152(a4)
    80005100:	07f7f693          	andi	a3,a5,127
    80005104:	9736                	add	a4,a4,a3
    80005106:	01874703          	lbu	a4,24(a4)
    8000510a:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    8000510e:	4691                	li	a3,4
    80005110:	04da8663          	beq	s5,a3,8000515c <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005114:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005118:	4685                	li	a3,1
    8000511a:	faf40613          	addi	a2,s0,-81
    8000511e:	85d2                	mv	a1,s4
    80005120:	855a                	mv	a0,s6
    80005122:	dd2fc0ef          	jal	800016f4 <either_copyout>
    80005126:	57fd                	li	a5,-1
    80005128:	04f50663          	beq	a0,a5,80005174 <consoleread+0xec>
      break;

    dst++;
    8000512c:	0a05                	addi	s4,s4,1
    --n;
    8000512e:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    80005130:	47a9                	li	a5,10
    80005132:	04fa8b63          	beq	s5,a5,80005188 <consoleread+0x100>
    80005136:	7aa2                	ld	s5,40(sp)
    80005138:	b761                	j	800050c0 <consoleread+0x38>
        release(&cons.lock);
    8000513a:	0001e517          	auipc	a0,0x1e
    8000513e:	b7650513          	addi	a0,a0,-1162 # 80022cb0 <cons>
    80005142:	14b000ef          	jal	80005a8c <release>
        return -1;
    80005146:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    80005148:	60e6                	ld	ra,88(sp)
    8000514a:	6446                	ld	s0,80(sp)
    8000514c:	64a6                	ld	s1,72(sp)
    8000514e:	6906                	ld	s2,64(sp)
    80005150:	79e2                	ld	s3,56(sp)
    80005152:	7a42                	ld	s4,48(sp)
    80005154:	7b02                	ld	s6,32(sp)
    80005156:	6be2                	ld	s7,24(sp)
    80005158:	6125                	addi	sp,sp,96
    8000515a:	8082                	ret
      if(n < target){
    8000515c:	0179fa63          	bgeu	s3,s7,80005170 <consoleread+0xe8>
        cons.r--;
    80005160:	0001e717          	auipc	a4,0x1e
    80005164:	bef72423          	sw	a5,-1048(a4) # 80022d48 <cons+0x98>
    80005168:	7aa2                	ld	s5,40(sp)
    8000516a:	a031                	j	80005176 <consoleread+0xee>
    8000516c:	f456                	sd	s5,40(sp)
    8000516e:	b749                	j	800050f0 <consoleread+0x68>
    80005170:	7aa2                	ld	s5,40(sp)
    80005172:	a011                	j	80005176 <consoleread+0xee>
    80005174:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005176:	0001e517          	auipc	a0,0x1e
    8000517a:	b3a50513          	addi	a0,a0,-1222 # 80022cb0 <cons>
    8000517e:	10f000ef          	jal	80005a8c <release>
  return target - n;
    80005182:	413b853b          	subw	a0,s7,s3
    80005186:	b7c9                	j	80005148 <consoleread+0xc0>
    80005188:	7aa2                	ld	s5,40(sp)
    8000518a:	b7f5                	j	80005176 <consoleread+0xee>

000000008000518c <consputc>:
{
    8000518c:	1141                	addi	sp,sp,-16
    8000518e:	e406                	sd	ra,8(sp)
    80005190:	e022                	sd	s0,0(sp)
    80005192:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005194:	10000793          	li	a5,256
    80005198:	00f50863          	beq	a0,a5,800051a8 <consputc+0x1c>
    uartputc_sync(c);
    8000519c:	6e4000ef          	jal	80005880 <uartputc_sync>
}
    800051a0:	60a2                	ld	ra,8(sp)
    800051a2:	6402                	ld	s0,0(sp)
    800051a4:	0141                	addi	sp,sp,16
    800051a6:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    800051a8:	4521                	li	a0,8
    800051aa:	6d6000ef          	jal	80005880 <uartputc_sync>
    800051ae:	02000513          	li	a0,32
    800051b2:	6ce000ef          	jal	80005880 <uartputc_sync>
    800051b6:	4521                	li	a0,8
    800051b8:	6c8000ef          	jal	80005880 <uartputc_sync>
    800051bc:	b7d5                	j	800051a0 <consputc+0x14>

00000000800051be <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    800051be:	1101                	addi	sp,sp,-32
    800051c0:	ec06                	sd	ra,24(sp)
    800051c2:	e822                	sd	s0,16(sp)
    800051c4:	e426                	sd	s1,8(sp)
    800051c6:	1000                	addi	s0,sp,32
    800051c8:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    800051ca:	0001e517          	auipc	a0,0x1e
    800051ce:	ae650513          	addi	a0,a0,-1306 # 80022cb0 <cons>
    800051d2:	027000ef          	jal	800059f8 <acquire>

  switch(c){
    800051d6:	47d5                	li	a5,21
    800051d8:	08f48d63          	beq	s1,a5,80005272 <consoleintr+0xb4>
    800051dc:	0297c563          	blt	a5,s1,80005206 <consoleintr+0x48>
    800051e0:	47a1                	li	a5,8
    800051e2:	0ef48263          	beq	s1,a5,800052c6 <consoleintr+0x108>
    800051e6:	47c1                	li	a5,16
    800051e8:	10f49363          	bne	s1,a5,800052ee <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    800051ec:	d9cfc0ef          	jal	80001788 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800051f0:	0001e517          	auipc	a0,0x1e
    800051f4:	ac050513          	addi	a0,a0,-1344 # 80022cb0 <cons>
    800051f8:	095000ef          	jal	80005a8c <release>
}
    800051fc:	60e2                	ld	ra,24(sp)
    800051fe:	6442                	ld	s0,16(sp)
    80005200:	64a2                	ld	s1,8(sp)
    80005202:	6105                	addi	sp,sp,32
    80005204:	8082                	ret
  switch(c){
    80005206:	07f00793          	li	a5,127
    8000520a:	0af48e63          	beq	s1,a5,800052c6 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000520e:	0001e717          	auipc	a4,0x1e
    80005212:	aa270713          	addi	a4,a4,-1374 # 80022cb0 <cons>
    80005216:	0a072783          	lw	a5,160(a4)
    8000521a:	09872703          	lw	a4,152(a4)
    8000521e:	9f99                	subw	a5,a5,a4
    80005220:	07f00713          	li	a4,127
    80005224:	fcf766e3          	bltu	a4,a5,800051f0 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    80005228:	47b5                	li	a5,13
    8000522a:	0cf48563          	beq	s1,a5,800052f4 <consoleintr+0x136>
      consputc(c);
    8000522e:	8526                	mv	a0,s1
    80005230:	f5dff0ef          	jal	8000518c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005234:	0001e717          	auipc	a4,0x1e
    80005238:	a7c70713          	addi	a4,a4,-1412 # 80022cb0 <cons>
    8000523c:	0a072683          	lw	a3,160(a4)
    80005240:	0016879b          	addiw	a5,a3,1
    80005244:	863e                	mv	a2,a5
    80005246:	0af72023          	sw	a5,160(a4)
    8000524a:	07f6f693          	andi	a3,a3,127
    8000524e:	9736                	add	a4,a4,a3
    80005250:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005254:	ff648713          	addi	a4,s1,-10
    80005258:	c371                	beqz	a4,8000531c <consoleintr+0x15e>
    8000525a:	14f1                	addi	s1,s1,-4
    8000525c:	c0e1                	beqz	s1,8000531c <consoleintr+0x15e>
    8000525e:	0001e717          	auipc	a4,0x1e
    80005262:	aea72703          	lw	a4,-1302(a4) # 80022d48 <cons+0x98>
    80005266:	9f99                	subw	a5,a5,a4
    80005268:	08000713          	li	a4,128
    8000526c:	f8e792e3          	bne	a5,a4,800051f0 <consoleintr+0x32>
    80005270:	a075                	j	8000531c <consoleintr+0x15e>
    80005272:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005274:	0001e717          	auipc	a4,0x1e
    80005278:	a3c70713          	addi	a4,a4,-1476 # 80022cb0 <cons>
    8000527c:	0a072783          	lw	a5,160(a4)
    80005280:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005284:	0001e497          	auipc	s1,0x1e
    80005288:	a2c48493          	addi	s1,s1,-1492 # 80022cb0 <cons>
    while(cons.e != cons.w &&
    8000528c:	4929                	li	s2,10
    8000528e:	02f70863          	beq	a4,a5,800052be <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005292:	37fd                	addiw	a5,a5,-1
    80005294:	07f7f713          	andi	a4,a5,127
    80005298:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000529a:	01874703          	lbu	a4,24(a4)
    8000529e:	03270263          	beq	a4,s2,800052c2 <consoleintr+0x104>
      cons.e--;
    800052a2:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    800052a6:	10000513          	li	a0,256
    800052aa:	ee3ff0ef          	jal	8000518c <consputc>
    while(cons.e != cons.w &&
    800052ae:	0a04a783          	lw	a5,160(s1)
    800052b2:	09c4a703          	lw	a4,156(s1)
    800052b6:	fcf71ee3          	bne	a4,a5,80005292 <consoleintr+0xd4>
    800052ba:	6902                	ld	s2,0(sp)
    800052bc:	bf15                	j	800051f0 <consoleintr+0x32>
    800052be:	6902                	ld	s2,0(sp)
    800052c0:	bf05                	j	800051f0 <consoleintr+0x32>
    800052c2:	6902                	ld	s2,0(sp)
    800052c4:	b735                	j	800051f0 <consoleintr+0x32>
    if(cons.e != cons.w){
    800052c6:	0001e717          	auipc	a4,0x1e
    800052ca:	9ea70713          	addi	a4,a4,-1558 # 80022cb0 <cons>
    800052ce:	0a072783          	lw	a5,160(a4)
    800052d2:	09c72703          	lw	a4,156(a4)
    800052d6:	f0f70de3          	beq	a4,a5,800051f0 <consoleintr+0x32>
      cons.e--;
    800052da:	37fd                	addiw	a5,a5,-1
    800052dc:	0001e717          	auipc	a4,0x1e
    800052e0:	a6f72a23          	sw	a5,-1420(a4) # 80022d50 <cons+0xa0>
      consputc(BACKSPACE);
    800052e4:	10000513          	li	a0,256
    800052e8:	ea5ff0ef          	jal	8000518c <consputc>
    800052ec:	b711                	j	800051f0 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800052ee:	f00481e3          	beqz	s1,800051f0 <consoleintr+0x32>
    800052f2:	bf31                	j	8000520e <consoleintr+0x50>
      consputc(c);
    800052f4:	4529                	li	a0,10
    800052f6:	e97ff0ef          	jal	8000518c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800052fa:	0001e797          	auipc	a5,0x1e
    800052fe:	9b678793          	addi	a5,a5,-1610 # 80022cb0 <cons>
    80005302:	0a07a703          	lw	a4,160(a5)
    80005306:	0017069b          	addiw	a3,a4,1
    8000530a:	8636                	mv	a2,a3
    8000530c:	0ad7a023          	sw	a3,160(a5)
    80005310:	07f77713          	andi	a4,a4,127
    80005314:	97ba                	add	a5,a5,a4
    80005316:	4729                	li	a4,10
    80005318:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000531c:	0001e797          	auipc	a5,0x1e
    80005320:	a2c7a823          	sw	a2,-1488(a5) # 80022d4c <cons+0x9c>
        wakeup(&cons.r);
    80005324:	0001e517          	auipc	a0,0x1e
    80005328:	a2450513          	addi	a0,a0,-1500 # 80022d48 <cons+0x98>
    8000532c:	8bafc0ef          	jal	800013e6 <wakeup>
    80005330:	b5c1                	j	800051f0 <consoleintr+0x32>

0000000080005332 <consoleinit>:

void
consoleinit(void)
{
    80005332:	1141                	addi	sp,sp,-16
    80005334:	e406                	sd	ra,8(sp)
    80005336:	e022                	sd	s0,0(sp)
    80005338:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    8000533a:	00002597          	auipc	a1,0x2
    8000533e:	38e58593          	addi	a1,a1,910 # 800076c8 <etext+0x6c8>
    80005342:	0001e517          	auipc	a0,0x1e
    80005346:	96e50513          	addi	a0,a0,-1682 # 80022cb0 <cons>
    8000534a:	624000ef          	jal	8000596e <initlock>

  uartinit();
    8000534e:	448000ef          	jal	80005796 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005352:	00014797          	auipc	a5,0x14
    80005356:	7c678793          	addi	a5,a5,1990 # 80019b18 <devsw>
    8000535a:	00000717          	auipc	a4,0x0
    8000535e:	d2e70713          	addi	a4,a4,-722 # 80005088 <consoleread>
    80005362:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005364:	00000717          	auipc	a4,0x0
    80005368:	c8270713          	addi	a4,a4,-894 # 80004fe6 <consolewrite>
    8000536c:	ef98                	sd	a4,24(a5)
}
    8000536e:	60a2                	ld	ra,8(sp)
    80005370:	6402                	ld	s0,0(sp)
    80005372:	0141                	addi	sp,sp,16
    80005374:	8082                	ret

0000000080005376 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005376:	7139                	addi	sp,sp,-64
    80005378:	fc06                	sd	ra,56(sp)
    8000537a:	f822                	sd	s0,48(sp)
    8000537c:	f04a                	sd	s2,32(sp)
    8000537e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005380:	c219                	beqz	a2,80005386 <printint+0x10>
    80005382:	08054163          	bltz	a0,80005404 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005386:	4301                	li	t1,0

  i = 0;
    80005388:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000538c:	86ca                	mv	a3,s2
  i = 0;
    8000538e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005390:	00002817          	auipc	a6,0x2
    80005394:	49880813          	addi	a6,a6,1176 # 80007828 <digits>
    80005398:	88ba                	mv	a7,a4
    8000539a:	0017061b          	addiw	a2,a4,1
    8000539e:	8732                	mv	a4,a2
    800053a0:	02b577b3          	remu	a5,a0,a1
    800053a4:	97c2                	add	a5,a5,a6
    800053a6:	0007c783          	lbu	a5,0(a5)
    800053aa:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    800053ae:	87aa                	mv	a5,a0
    800053b0:	02b55533          	divu	a0,a0,a1
    800053b4:	0685                	addi	a3,a3,1
    800053b6:	feb7f1e3          	bgeu	a5,a1,80005398 <printint+0x22>

  if(sign)
    800053ba:	00030c63          	beqz	t1,800053d2 <printint+0x5c>
    buf[i++] = '-';
    800053be:	fe060793          	addi	a5,a2,-32
    800053c2:	00878633          	add	a2,a5,s0
    800053c6:	02d00793          	li	a5,45
    800053ca:	fef60423          	sb	a5,-24(a2)
    800053ce:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    800053d2:	02e05463          	blez	a4,800053fa <printint+0x84>
    800053d6:	f426                	sd	s1,40(sp)
    800053d8:	377d                	addiw	a4,a4,-1
    800053da:	00e904b3          	add	s1,s2,a4
    800053de:	197d                	addi	s2,s2,-1
    800053e0:	993a                	add	s2,s2,a4
    800053e2:	1702                	slli	a4,a4,0x20
    800053e4:	9301                	srli	a4,a4,0x20
    800053e6:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800053ea:	0004c503          	lbu	a0,0(s1)
    800053ee:	d9fff0ef          	jal	8000518c <consputc>
  while(--i >= 0)
    800053f2:	14fd                	addi	s1,s1,-1
    800053f4:	ff249be3          	bne	s1,s2,800053ea <printint+0x74>
    800053f8:	74a2                	ld	s1,40(sp)
}
    800053fa:	70e2                	ld	ra,56(sp)
    800053fc:	7442                	ld	s0,48(sp)
    800053fe:	7902                	ld	s2,32(sp)
    80005400:	6121                	addi	sp,sp,64
    80005402:	8082                	ret
    x = -xx;
    80005404:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005408:	4305                	li	t1,1
    x = -xx;
    8000540a:	bfbd                	j	80005388 <printint+0x12>

000000008000540c <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000540c:	7131                	addi	sp,sp,-192
    8000540e:	fc86                	sd	ra,120(sp)
    80005410:	f8a2                	sd	s0,112(sp)
    80005412:	f0ca                	sd	s2,96(sp)
    80005414:	0100                	addi	s0,sp,128
    80005416:	892a                	mv	s2,a0
    80005418:	e40c                	sd	a1,8(s0)
    8000541a:	e810                	sd	a2,16(s0)
    8000541c:	ec14                	sd	a3,24(s0)
    8000541e:	f018                	sd	a4,32(s0)
    80005420:	f41c                	sd	a5,40(s0)
    80005422:	03043823          	sd	a6,48(s0)
    80005426:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    8000542a:	00002797          	auipc	a5,0x2
    8000542e:	4467a783          	lw	a5,1094(a5) # 80007870 <panicking>
    80005432:	cf9d                	beqz	a5,80005470 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    80005434:	00840793          	addi	a5,s0,8
    80005438:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    8000543c:	00094503          	lbu	a0,0(s2)
    80005440:	22050663          	beqz	a0,8000566c <printf+0x260>
    80005444:	f4a6                	sd	s1,104(sp)
    80005446:	ecce                	sd	s3,88(sp)
    80005448:	e8d2                	sd	s4,80(sp)
    8000544a:	e4d6                	sd	s5,72(sp)
    8000544c:	e0da                	sd	s6,64(sp)
    8000544e:	fc5e                	sd	s7,56(sp)
    80005450:	f862                	sd	s8,48(sp)
    80005452:	f06a                	sd	s10,32(sp)
    80005454:	ec6e                	sd	s11,24(sp)
    80005456:	4a01                	li	s4,0
    if(cx != '%'){
    80005458:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000545c:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005460:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005464:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80005468:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000546a:	06400b93          	li	s7,100
    8000546e:	a015                	j	80005492 <printf+0x86>
    acquire(&pr.lock);
    80005470:	0001e517          	auipc	a0,0x1e
    80005474:	8e850513          	addi	a0,a0,-1816 # 80022d58 <pr>
    80005478:	580000ef          	jal	800059f8 <acquire>
    8000547c:	bf65                	j	80005434 <printf+0x28>
      consputc(cx);
    8000547e:	d0fff0ef          	jal	8000518c <consputc>
      continue;
    80005482:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005484:	2485                	addiw	s1,s1,1
    80005486:	8a26                	mv	s4,s1
    80005488:	94ca                	add	s1,s1,s2
    8000548a:	0004c503          	lbu	a0,0(s1)
    8000548e:	1c050663          	beqz	a0,8000565a <printf+0x24e>
    if(cx != '%'){
    80005492:	ff3516e3          	bne	a0,s3,8000547e <printf+0x72>
    i++;
    80005496:	001a079b          	addiw	a5,s4,1
    8000549a:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000549c:	00f90733          	add	a4,s2,a5
    800054a0:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    800054a4:	200a8963          	beqz	s5,800056b6 <printf+0x2aa>
    800054a8:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    800054ac:	1e068c63          	beqz	a3,800056a4 <printf+0x298>
    if(c0 == 'd'){
    800054b0:	037a8863          	beq	s5,s7,800054e0 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800054b4:	f94a8713          	addi	a4,s5,-108
    800054b8:	00173713          	seqz	a4,a4
    800054bc:	f9c68613          	addi	a2,a3,-100
    800054c0:	ee05                	bnez	a2,800054f8 <printf+0xec>
    800054c2:	cb1d                	beqz	a4,800054f8 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    800054c4:	f8843783          	ld	a5,-120(s0)
    800054c8:	00878713          	addi	a4,a5,8
    800054cc:	f8e43423          	sd	a4,-120(s0)
    800054d0:	4605                	li	a2,1
    800054d2:	85da                	mv	a1,s6
    800054d4:	6388                	ld	a0,0(a5)
    800054d6:	ea1ff0ef          	jal	80005376 <printint>
      i += 1;
    800054da:	002a049b          	addiw	s1,s4,2
    800054de:	b75d                	j	80005484 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    800054e0:	f8843783          	ld	a5,-120(s0)
    800054e4:	00878713          	addi	a4,a5,8
    800054e8:	f8e43423          	sd	a4,-120(s0)
    800054ec:	4605                	li	a2,1
    800054ee:	85da                	mv	a1,s6
    800054f0:	4388                	lw	a0,0(a5)
    800054f2:	e85ff0ef          	jal	80005376 <printint>
    800054f6:	b779                	j	80005484 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800054f8:	97ca                	add	a5,a5,s2
    800054fa:	8636                	mv	a2,a3
    800054fc:	0027c683          	lbu	a3,2(a5)
    80005500:	a2c9                	j	800056c2 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005502:	f8843783          	ld	a5,-120(s0)
    80005506:	00878713          	addi	a4,a5,8
    8000550a:	f8e43423          	sd	a4,-120(s0)
    8000550e:	4605                	li	a2,1
    80005510:	45a9                	li	a1,10
    80005512:	6388                	ld	a0,0(a5)
    80005514:	e63ff0ef          	jal	80005376 <printint>
      i += 2;
    80005518:	003a049b          	addiw	s1,s4,3
    8000551c:	b7a5                	j	80005484 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    8000551e:	f8843783          	ld	a5,-120(s0)
    80005522:	00878713          	addi	a4,a5,8
    80005526:	f8e43423          	sd	a4,-120(s0)
    8000552a:	4601                	li	a2,0
    8000552c:	85da                	mv	a1,s6
    8000552e:	0007e503          	lwu	a0,0(a5)
    80005532:	e45ff0ef          	jal	80005376 <printint>
    80005536:	b7b9                	j	80005484 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005538:	f8843783          	ld	a5,-120(s0)
    8000553c:	00878713          	addi	a4,a5,8
    80005540:	f8e43423          	sd	a4,-120(s0)
    80005544:	4601                	li	a2,0
    80005546:	85da                	mv	a1,s6
    80005548:	6388                	ld	a0,0(a5)
    8000554a:	e2dff0ef          	jal	80005376 <printint>
      i += 1;
    8000554e:	002a049b          	addiw	s1,s4,2
    80005552:	bf0d                	j	80005484 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005554:	f8843783          	ld	a5,-120(s0)
    80005558:	00878713          	addi	a4,a5,8
    8000555c:	f8e43423          	sd	a4,-120(s0)
    80005560:	4601                	li	a2,0
    80005562:	45a9                	li	a1,10
    80005564:	6388                	ld	a0,0(a5)
    80005566:	e11ff0ef          	jal	80005376 <printint>
      i += 2;
    8000556a:	003a049b          	addiw	s1,s4,3
    8000556e:	bf19                	j	80005484 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005570:	f8843783          	ld	a5,-120(s0)
    80005574:	00878713          	addi	a4,a5,8
    80005578:	f8e43423          	sd	a4,-120(s0)
    8000557c:	4601                	li	a2,0
    8000557e:	45c1                	li	a1,16
    80005580:	0007e503          	lwu	a0,0(a5)
    80005584:	df3ff0ef          	jal	80005376 <printint>
    80005588:	bdf5                	j	80005484 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    8000558a:	f8843783          	ld	a5,-120(s0)
    8000558e:	00878713          	addi	a4,a5,8
    80005592:	f8e43423          	sd	a4,-120(s0)
    80005596:	45c1                	li	a1,16
    80005598:	6388                	ld	a0,0(a5)
    8000559a:	dddff0ef          	jal	80005376 <printint>
      i += 1;
    8000559e:	002a049b          	addiw	s1,s4,2
    800055a2:	b5cd                	j	80005484 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    800055a4:	f8843783          	ld	a5,-120(s0)
    800055a8:	00878713          	addi	a4,a5,8
    800055ac:	f8e43423          	sd	a4,-120(s0)
    800055b0:	4601                	li	a2,0
    800055b2:	45c1                	li	a1,16
    800055b4:	6388                	ld	a0,0(a5)
    800055b6:	dc1ff0ef          	jal	80005376 <printint>
      i += 2;
    800055ba:	003a049b          	addiw	s1,s4,3
    800055be:	b5d9                	j	80005484 <printf+0x78>
    800055c0:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    800055c2:	f8843783          	ld	a5,-120(s0)
    800055c6:	00878713          	addi	a4,a5,8
    800055ca:	f8e43423          	sd	a4,-120(s0)
    800055ce:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    800055d2:	03000513          	li	a0,48
    800055d6:	bb7ff0ef          	jal	8000518c <consputc>
  consputc('x');
    800055da:	07800513          	li	a0,120
    800055de:	bafff0ef          	jal	8000518c <consputc>
    800055e2:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800055e4:	00002c97          	auipc	s9,0x2
    800055e8:	244c8c93          	addi	s9,s9,580 # 80007828 <digits>
    800055ec:	03cad793          	srli	a5,s5,0x3c
    800055f0:	97e6                	add	a5,a5,s9
    800055f2:	0007c503          	lbu	a0,0(a5)
    800055f6:	b97ff0ef          	jal	8000518c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800055fa:	0a92                	slli	s5,s5,0x4
    800055fc:	3a7d                	addiw	s4,s4,-1
    800055fe:	fe0a17e3          	bnez	s4,800055ec <printf+0x1e0>
    80005602:	7ca2                	ld	s9,40(sp)
    80005604:	b541                	j	80005484 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80005606:	f8843783          	ld	a5,-120(s0)
    8000560a:	00878713          	addi	a4,a5,8
    8000560e:	f8e43423          	sd	a4,-120(s0)
    80005612:	4388                	lw	a0,0(a5)
    80005614:	b79ff0ef          	jal	8000518c <consputc>
    80005618:	b5b5                	j	80005484 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    8000561a:	f8843783          	ld	a5,-120(s0)
    8000561e:	00878713          	addi	a4,a5,8
    80005622:	f8e43423          	sd	a4,-120(s0)
    80005626:	0007ba03          	ld	s4,0(a5)
    8000562a:	000a0d63          	beqz	s4,80005644 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    8000562e:	000a4503          	lbu	a0,0(s4)
    80005632:	e40509e3          	beqz	a0,80005484 <printf+0x78>
        consputc(*s);
    80005636:	b57ff0ef          	jal	8000518c <consputc>
      for(; *s; s++)
    8000563a:	0a05                	addi	s4,s4,1
    8000563c:	000a4503          	lbu	a0,0(s4)
    80005640:	f97d                	bnez	a0,80005636 <printf+0x22a>
    80005642:	b589                	j	80005484 <printf+0x78>
        s = "(null)";
    80005644:	00002a17          	auipc	s4,0x2
    80005648:	08ca0a13          	addi	s4,s4,140 # 800076d0 <etext+0x6d0>
      for(; *s; s++)
    8000564c:	02800513          	li	a0,40
    80005650:	b7dd                	j	80005636 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005652:	8556                	mv	a0,s5
    80005654:	b39ff0ef          	jal	8000518c <consputc>
    80005658:	b535                	j	80005484 <printf+0x78>
    8000565a:	74a6                	ld	s1,104(sp)
    8000565c:	69e6                	ld	s3,88(sp)
    8000565e:	6a46                	ld	s4,80(sp)
    80005660:	6aa6                	ld	s5,72(sp)
    80005662:	6b06                	ld	s6,64(sp)
    80005664:	7be2                	ld	s7,56(sp)
    80005666:	7c42                	ld	s8,48(sp)
    80005668:	7d02                	ld	s10,32(sp)
    8000566a:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000566c:	00002797          	auipc	a5,0x2
    80005670:	2047a783          	lw	a5,516(a5) # 80007870 <panicking>
    80005674:	c38d                	beqz	a5,80005696 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80005676:	4501                	li	a0,0
    80005678:	70e6                	ld	ra,120(sp)
    8000567a:	7446                	ld	s0,112(sp)
    8000567c:	7906                	ld	s2,96(sp)
    8000567e:	6129                	addi	sp,sp,192
    80005680:	8082                	ret
    80005682:	74a6                	ld	s1,104(sp)
    80005684:	69e6                	ld	s3,88(sp)
    80005686:	6a46                	ld	s4,80(sp)
    80005688:	6aa6                	ld	s5,72(sp)
    8000568a:	6b06                	ld	s6,64(sp)
    8000568c:	7be2                	ld	s7,56(sp)
    8000568e:	7c42                	ld	s8,48(sp)
    80005690:	7d02                	ld	s10,32(sp)
    80005692:	6de2                	ld	s11,24(sp)
    80005694:	bfe1                	j	8000566c <printf+0x260>
    release(&pr.lock);
    80005696:	0001d517          	auipc	a0,0x1d
    8000569a:	6c250513          	addi	a0,a0,1730 # 80022d58 <pr>
    8000569e:	3ee000ef          	jal	80005a8c <release>
  return 0;
    800056a2:	bfd1                	j	80005676 <printf+0x26a>
    if(c0 == 'd'){
    800056a4:	e37a8ee3          	beq	s5,s7,800054e0 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    800056a8:	f94a8713          	addi	a4,s5,-108
    800056ac:	00173713          	seqz	a4,a4
    800056b0:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800056b2:	4781                	li	a5,0
    800056b4:	a00d                	j	800056d6 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    800056b6:	f94a8713          	addi	a4,s5,-108
    800056ba:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    800056be:	8656                	mv	a2,s5
    800056c0:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    800056c2:	f9460793          	addi	a5,a2,-108
    800056c6:	0017b793          	seqz	a5,a5
    800056ca:	8ff9                	and	a5,a5,a4
    800056cc:	f9c68593          	addi	a1,a3,-100
    800056d0:	e199                	bnez	a1,800056d6 <printf+0x2ca>
    800056d2:	e20798e3          	bnez	a5,80005502 <printf+0xf6>
    } else if(c0 == 'u'){
    800056d6:	e58a84e3          	beq	s5,s8,8000551e <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    800056da:	f8b60593          	addi	a1,a2,-117
    800056de:	e199                	bnez	a1,800056e4 <printf+0x2d8>
    800056e0:	e4071ce3          	bnez	a4,80005538 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    800056e4:	f8b68593          	addi	a1,a3,-117
    800056e8:	e199                	bnez	a1,800056ee <printf+0x2e2>
    800056ea:	e60795e3          	bnez	a5,80005554 <printf+0x148>
    } else if(c0 == 'x'){
    800056ee:	e9aa81e3          	beq	s5,s10,80005570 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    800056f2:	f8860613          	addi	a2,a2,-120
    800056f6:	e219                	bnez	a2,800056fc <printf+0x2f0>
    800056f8:	e80719e3          	bnez	a4,8000558a <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800056fc:	f8868693          	addi	a3,a3,-120
    80005700:	e299                	bnez	a3,80005706 <printf+0x2fa>
    80005702:	ea0791e3          	bnez	a5,800055a4 <printf+0x198>
    } else if(c0 == 'p'){
    80005706:	ebba8de3          	beq	s5,s11,800055c0 <printf+0x1b4>
    } else if(c0 == 'c'){
    8000570a:	06300793          	li	a5,99
    8000570e:	eefa8ce3          	beq	s5,a5,80005606 <printf+0x1fa>
    } else if(c0 == 's'){
    80005712:	07300793          	li	a5,115
    80005716:	f0fa82e3          	beq	s5,a5,8000561a <printf+0x20e>
    } else if(c0 == '%'){
    8000571a:	02500793          	li	a5,37
    8000571e:	f2fa8ae3          	beq	s5,a5,80005652 <printf+0x246>
    } else if(c0 == 0){
    80005722:	f60a80e3          	beqz	s5,80005682 <printf+0x276>
      consputc('%');
    80005726:	02500513          	li	a0,37
    8000572a:	a63ff0ef          	jal	8000518c <consputc>
      consputc(c0);
    8000572e:	8556                	mv	a0,s5
    80005730:	a5dff0ef          	jal	8000518c <consputc>
    80005734:	bb81                	j	80005484 <printf+0x78>

0000000080005736 <panic>:

void
panic(char *s)
{
    80005736:	1101                	addi	sp,sp,-32
    80005738:	ec06                	sd	ra,24(sp)
    8000573a:	e822                	sd	s0,16(sp)
    8000573c:	e426                	sd	s1,8(sp)
    8000573e:	e04a                	sd	s2,0(sp)
    80005740:	1000                	addi	s0,sp,32
    80005742:	892a                	mv	s2,a0
  panicking = 1;
    80005744:	4485                	li	s1,1
    80005746:	00002797          	auipc	a5,0x2
    8000574a:	1297a523          	sw	s1,298(a5) # 80007870 <panicking>
  printf("panic: ");
    8000574e:	00002517          	auipc	a0,0x2
    80005752:	f8a50513          	addi	a0,a0,-118 # 800076d8 <etext+0x6d8>
    80005756:	cb7ff0ef          	jal	8000540c <printf>
  printf("%s\n", s);
    8000575a:	85ca                	mv	a1,s2
    8000575c:	00002517          	auipc	a0,0x2
    80005760:	f8450513          	addi	a0,a0,-124 # 800076e0 <etext+0x6e0>
    80005764:	ca9ff0ef          	jal	8000540c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005768:	00002797          	auipc	a5,0x2
    8000576c:	1097a223          	sw	s1,260(a5) # 8000786c <panicked>
  for(;;)
    80005770:	a001                	j	80005770 <panic+0x3a>

0000000080005772 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005772:	1141                	addi	sp,sp,-16
    80005774:	e406                	sd	ra,8(sp)
    80005776:	e022                	sd	s0,0(sp)
    80005778:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    8000577a:	00002597          	auipc	a1,0x2
    8000577e:	f6e58593          	addi	a1,a1,-146 # 800076e8 <etext+0x6e8>
    80005782:	0001d517          	auipc	a0,0x1d
    80005786:	5d650513          	addi	a0,a0,1494 # 80022d58 <pr>
    8000578a:	1e4000ef          	jal	8000596e <initlock>
}
    8000578e:	60a2                	ld	ra,8(sp)
    80005790:	6402                	ld	s0,0(sp)
    80005792:	0141                	addi	sp,sp,16
    80005794:	8082                	ret

0000000080005796 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005796:	1141                	addi	sp,sp,-16
    80005798:	e406                	sd	ra,8(sp)
    8000579a:	e022                	sd	s0,0(sp)
    8000579c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000579e:	100007b7          	lui	a5,0x10000
    800057a2:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800057a6:	10000737          	lui	a4,0x10000
    800057aa:	f8000693          	li	a3,-128
    800057ae:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800057b2:	468d                	li	a3,3
    800057b4:	10000637          	lui	a2,0x10000
    800057b8:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800057bc:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800057c0:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800057c4:	8732                	mv	a4,a2
    800057c6:	461d                	li	a2,7
    800057c8:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800057cc:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800057d0:	00002597          	auipc	a1,0x2
    800057d4:	f2058593          	addi	a1,a1,-224 # 800076f0 <etext+0x6f0>
    800057d8:	0001d517          	auipc	a0,0x1d
    800057dc:	59850513          	addi	a0,a0,1432 # 80022d70 <tx_lock>
    800057e0:	18e000ef          	jal	8000596e <initlock>
}
    800057e4:	60a2                	ld	ra,8(sp)
    800057e6:	6402                	ld	s0,0(sp)
    800057e8:	0141                	addi	sp,sp,16
    800057ea:	8082                	ret

00000000800057ec <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800057ec:	715d                	addi	sp,sp,-80
    800057ee:	e486                	sd	ra,72(sp)
    800057f0:	e0a2                	sd	s0,64(sp)
    800057f2:	fc26                	sd	s1,56(sp)
    800057f4:	ec56                	sd	s5,24(sp)
    800057f6:	0880                	addi	s0,sp,80
    800057f8:	8aaa                	mv	s5,a0
    800057fa:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    800057fc:	0001d517          	auipc	a0,0x1d
    80005800:	57450513          	addi	a0,a0,1396 # 80022d70 <tx_lock>
    80005804:	1f4000ef          	jal	800059f8 <acquire>

  int i = 0;
  while(i < n){ 
    80005808:	06905063          	blez	s1,80005868 <uartwrite+0x7c>
    8000580c:	f84a                	sd	s2,48(sp)
    8000580e:	f44e                	sd	s3,40(sp)
    80005810:	f052                	sd	s4,32(sp)
    80005812:	e85a                	sd	s6,16(sp)
    80005814:	e45e                	sd	s7,8(sp)
    80005816:	8a56                	mv	s4,s5
    80005818:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    8000581a:	00002497          	auipc	s1,0x2
    8000581e:	05e48493          	addi	s1,s1,94 # 80007878 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005822:	0001d997          	auipc	s3,0x1d
    80005826:	54e98993          	addi	s3,s3,1358 # 80022d70 <tx_lock>
    8000582a:	00002917          	auipc	s2,0x2
    8000582e:	04a90913          	addi	s2,s2,74 # 80007874 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005832:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005836:	4b05                	li	s6,1
    80005838:	a005                	j	80005858 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    8000583a:	85ce                	mv	a1,s3
    8000583c:	854a                	mv	a0,s2
    8000583e:	b5dfb0ef          	jal	8000139a <sleep>
    while(tx_busy != 0){
    80005842:	409c                	lw	a5,0(s1)
    80005844:	fbfd                	bnez	a5,8000583a <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005846:	000a4783          	lbu	a5,0(s4)
    8000584a:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    8000584e:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005852:	0a05                	addi	s4,s4,1
    80005854:	015a0563          	beq	s4,s5,8000585e <uartwrite+0x72>
    while(tx_busy != 0){
    80005858:	409c                	lw	a5,0(s1)
    8000585a:	f3e5                	bnez	a5,8000583a <uartwrite+0x4e>
    8000585c:	b7ed                	j	80005846 <uartwrite+0x5a>
    8000585e:	7942                	ld	s2,48(sp)
    80005860:	79a2                	ld	s3,40(sp)
    80005862:	7a02                	ld	s4,32(sp)
    80005864:	6b42                	ld	s6,16(sp)
    80005866:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005868:	0001d517          	auipc	a0,0x1d
    8000586c:	50850513          	addi	a0,a0,1288 # 80022d70 <tx_lock>
    80005870:	21c000ef          	jal	80005a8c <release>
}
    80005874:	60a6                	ld	ra,72(sp)
    80005876:	6406                	ld	s0,64(sp)
    80005878:	74e2                	ld	s1,56(sp)
    8000587a:	6ae2                	ld	s5,24(sp)
    8000587c:	6161                	addi	sp,sp,80
    8000587e:	8082                	ret

0000000080005880 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005880:	1101                	addi	sp,sp,-32
    80005882:	ec06                	sd	ra,24(sp)
    80005884:	e822                	sd	s0,16(sp)
    80005886:	e426                	sd	s1,8(sp)
    80005888:	1000                	addi	s0,sp,32
    8000588a:	84aa                	mv	s1,a0
  if(panicking == 0)
    8000588c:	00002797          	auipc	a5,0x2
    80005890:	fe47a783          	lw	a5,-28(a5) # 80007870 <panicking>
    80005894:	cf95                	beqz	a5,800058d0 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005896:	00002797          	auipc	a5,0x2
    8000589a:	fd67a783          	lw	a5,-42(a5) # 8000786c <panicked>
    8000589e:	ef85                	bnez	a5,800058d6 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800058a0:	10000737          	lui	a4,0x10000
    800058a4:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    800058a6:	00074783          	lbu	a5,0(a4)
    800058aa:	0207f793          	andi	a5,a5,32
    800058ae:	dfe5                	beqz	a5,800058a6 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    800058b0:	0ff4f513          	zext.b	a0,s1
    800058b4:	100007b7          	lui	a5,0x10000
    800058b8:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    800058bc:	00002797          	auipc	a5,0x2
    800058c0:	fb47a783          	lw	a5,-76(a5) # 80007870 <panicking>
    800058c4:	cb91                	beqz	a5,800058d8 <uartputc_sync+0x58>
    pop_off();
}
    800058c6:	60e2                	ld	ra,24(sp)
    800058c8:	6442                	ld	s0,16(sp)
    800058ca:	64a2                	ld	s1,8(sp)
    800058cc:	6105                	addi	sp,sp,32
    800058ce:	8082                	ret
    push_off();
    800058d0:	0e4000ef          	jal	800059b4 <push_off>
    800058d4:	b7c9                	j	80005896 <uartputc_sync+0x16>
    for(;;)
    800058d6:	a001                	j	800058d6 <uartputc_sync+0x56>
    pop_off();
    800058d8:	164000ef          	jal	80005a3c <pop_off>
}
    800058dc:	b7ed                	j	800058c6 <uartputc_sync+0x46>

00000000800058de <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800058de:	1141                	addi	sp,sp,-16
    800058e0:	e406                	sd	ra,8(sp)
    800058e2:	e022                	sd	s0,0(sp)
    800058e4:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    800058e6:	100007b7          	lui	a5,0x10000
    800058ea:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800058ee:	8b85                	andi	a5,a5,1
    800058f0:	cb89                	beqz	a5,80005902 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800058f2:	100007b7          	lui	a5,0x10000
    800058f6:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    800058fa:	60a2                	ld	ra,8(sp)
    800058fc:	6402                	ld	s0,0(sp)
    800058fe:	0141                	addi	sp,sp,16
    80005900:	8082                	ret
    return -1;
    80005902:	557d                	li	a0,-1
    80005904:	bfdd                	j	800058fa <uartgetc+0x1c>

0000000080005906 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005906:	1101                	addi	sp,sp,-32
    80005908:	ec06                	sd	ra,24(sp)
    8000590a:	e822                	sd	s0,16(sp)
    8000590c:	e426                	sd	s1,8(sp)
    8000590e:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005910:	100007b7          	lui	a5,0x10000
    80005914:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005918:	0001d517          	auipc	a0,0x1d
    8000591c:	45850513          	addi	a0,a0,1112 # 80022d70 <tx_lock>
    80005920:	0d8000ef          	jal	800059f8 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005924:	100007b7          	lui	a5,0x10000
    80005928:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    8000592c:	0207f793          	andi	a5,a5,32
    80005930:	ef99                	bnez	a5,8000594e <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005932:	0001d517          	auipc	a0,0x1d
    80005936:	43e50513          	addi	a0,a0,1086 # 80022d70 <tx_lock>
    8000593a:	152000ef          	jal	80005a8c <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    8000593e:	54fd                	li	s1,-1
    int c = uartgetc();
    80005940:	f9fff0ef          	jal	800058de <uartgetc>
    if(c == -1)
    80005944:	02950063          	beq	a0,s1,80005964 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005948:	877ff0ef          	jal	800051be <consoleintr>
  while(1){
    8000594c:	bfd5                	j	80005940 <uartintr+0x3a>
    tx_busy = 0;
    8000594e:	00002797          	auipc	a5,0x2
    80005952:	f207a523          	sw	zero,-214(a5) # 80007878 <tx_busy>
    wakeup(&tx_chan);
    80005956:	00002517          	auipc	a0,0x2
    8000595a:	f1e50513          	addi	a0,a0,-226 # 80007874 <tx_chan>
    8000595e:	a89fb0ef          	jal	800013e6 <wakeup>
    80005962:	bfc1                	j	80005932 <uartintr+0x2c>
  }
}
    80005964:	60e2                	ld	ra,24(sp)
    80005966:	6442                	ld	s0,16(sp)
    80005968:	64a2                	ld	s1,8(sp)
    8000596a:	6105                	addi	sp,sp,32
    8000596c:	8082                	ret

000000008000596e <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000596e:	1141                	addi	sp,sp,-16
    80005970:	e406                	sd	ra,8(sp)
    80005972:	e022                	sd	s0,0(sp)
    80005974:	0800                	addi	s0,sp,16
  lk->name = name;
    80005976:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005978:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    8000597c:	00053823          	sd	zero,16(a0)
}
    80005980:	60a2                	ld	ra,8(sp)
    80005982:	6402                	ld	s0,0(sp)
    80005984:	0141                	addi	sp,sp,16
    80005986:	8082                	ret

0000000080005988 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005988:	411c                	lw	a5,0(a0)
    8000598a:	e399                	bnez	a5,80005990 <holding+0x8>
    8000598c:	4501                	li	a0,0
  return r;
}
    8000598e:	8082                	ret
{
    80005990:	1101                	addi	sp,sp,-32
    80005992:	ec06                	sd	ra,24(sp)
    80005994:	e822                	sd	s0,16(sp)
    80005996:	e426                	sd	s1,8(sp)
    80005998:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    8000599a:	691c                	ld	a5,16(a0)
    8000599c:	84be                	mv	s1,a5
    8000599e:	bc0fb0ef          	jal	80000d5e <mycpu>
    800059a2:	40a48533          	sub	a0,s1,a0
    800059a6:	00153513          	seqz	a0,a0
}
    800059aa:	60e2                	ld	ra,24(sp)
    800059ac:	6442                	ld	s0,16(sp)
    800059ae:	64a2                	ld	s1,8(sp)
    800059b0:	6105                	addi	sp,sp,32
    800059b2:	8082                	ret

00000000800059b4 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800059b4:	1101                	addi	sp,sp,-32
    800059b6:	ec06                	sd	ra,24(sp)
    800059b8:	e822                	sd	s0,16(sp)
    800059ba:	e426                	sd	s1,8(sp)
    800059bc:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800059be:	100027f3          	csrr	a5,sstatus
    800059c2:	84be                	mv	s1,a5
    800059c4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800059c8:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800059ca:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    800059ce:	b90fb0ef          	jal	80000d5e <mycpu>
    800059d2:	5d3c                	lw	a5,120(a0)
    800059d4:	cb99                	beqz	a5,800059ea <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800059d6:	b88fb0ef          	jal	80000d5e <mycpu>
    800059da:	5d3c                	lw	a5,120(a0)
    800059dc:	2785                	addiw	a5,a5,1
    800059de:	dd3c                	sw	a5,120(a0)
}
    800059e0:	60e2                	ld	ra,24(sp)
    800059e2:	6442                	ld	s0,16(sp)
    800059e4:	64a2                	ld	s1,8(sp)
    800059e6:	6105                	addi	sp,sp,32
    800059e8:	8082                	ret
    mycpu()->intena = old;
    800059ea:	b74fb0ef          	jal	80000d5e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800059ee:	0014d793          	srli	a5,s1,0x1
    800059f2:	8b85                	andi	a5,a5,1
    800059f4:	dd7c                	sw	a5,124(a0)
    800059f6:	b7c5                	j	800059d6 <push_off+0x22>

00000000800059f8 <acquire>:
{
    800059f8:	1101                	addi	sp,sp,-32
    800059fa:	ec06                	sd	ra,24(sp)
    800059fc:	e822                	sd	s0,16(sp)
    800059fe:	e426                	sd	s1,8(sp)
    80005a00:	1000                	addi	s0,sp,32
    80005a02:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005a04:	fb1ff0ef          	jal	800059b4 <push_off>
  if(holding(lk))
    80005a08:	8526                	mv	a0,s1
    80005a0a:	f7fff0ef          	jal	80005988 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a0e:	4705                	li	a4,1
  if(holding(lk))
    80005a10:	e105                	bnez	a0,80005a30 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005a12:	87ba                	mv	a5,a4
    80005a14:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005a18:	2781                	sext.w	a5,a5
    80005a1a:	ffe5                	bnez	a5,80005a12 <acquire+0x1a>
  __sync_synchronize();
    80005a1c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005a20:	b3efb0ef          	jal	80000d5e <mycpu>
    80005a24:	e888                	sd	a0,16(s1)
}
    80005a26:	60e2                	ld	ra,24(sp)
    80005a28:	6442                	ld	s0,16(sp)
    80005a2a:	64a2                	ld	s1,8(sp)
    80005a2c:	6105                	addi	sp,sp,32
    80005a2e:	8082                	ret
    panic("acquire");
    80005a30:	00002517          	auipc	a0,0x2
    80005a34:	cc850513          	addi	a0,a0,-824 # 800076f8 <etext+0x6f8>
    80005a38:	cffff0ef          	jal	80005736 <panic>

0000000080005a3c <pop_off>:

void
pop_off(void)
{
    80005a3c:	1141                	addi	sp,sp,-16
    80005a3e:	e406                	sd	ra,8(sp)
    80005a40:	e022                	sd	s0,0(sp)
    80005a42:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005a44:	b1afb0ef          	jal	80000d5e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a48:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005a4c:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005a4e:	e39d                	bnez	a5,80005a74 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005a50:	5d3c                	lw	a5,120(a0)
    80005a52:	02f05763          	blez	a5,80005a80 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005a56:	37fd                	addiw	a5,a5,-1
    80005a58:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005a5a:	eb89                	bnez	a5,80005a6c <pop_off+0x30>
    80005a5c:	5d7c                	lw	a5,124(a0)
    80005a5e:	c799                	beqz	a5,80005a6c <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005a60:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005a64:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005a68:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005a6c:	60a2                	ld	ra,8(sp)
    80005a6e:	6402                	ld	s0,0(sp)
    80005a70:	0141                	addi	sp,sp,16
    80005a72:	8082                	ret
    panic("pop_off - interruptible");
    80005a74:	00002517          	auipc	a0,0x2
    80005a78:	c8c50513          	addi	a0,a0,-884 # 80007700 <etext+0x700>
    80005a7c:	cbbff0ef          	jal	80005736 <panic>
    panic("pop_off");
    80005a80:	00002517          	auipc	a0,0x2
    80005a84:	c9850513          	addi	a0,a0,-872 # 80007718 <etext+0x718>
    80005a88:	cafff0ef          	jal	80005736 <panic>

0000000080005a8c <release>:
{
    80005a8c:	1101                	addi	sp,sp,-32
    80005a8e:	ec06                	sd	ra,24(sp)
    80005a90:	e822                	sd	s0,16(sp)
    80005a92:	e426                	sd	s1,8(sp)
    80005a94:	1000                	addi	s0,sp,32
    80005a96:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005a98:	ef1ff0ef          	jal	80005988 <holding>
    80005a9c:	c105                	beqz	a0,80005abc <release+0x30>
  lk->cpu = 0;
    80005a9e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005aa2:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005aa6:	0310000f          	fence	rw,w
    80005aaa:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005aae:	f8fff0ef          	jal	80005a3c <pop_off>
}
    80005ab2:	60e2                	ld	ra,24(sp)
    80005ab4:	6442                	ld	s0,16(sp)
    80005ab6:	64a2                	ld	s1,8(sp)
    80005ab8:	6105                	addi	sp,sp,32
    80005aba:	8082                	ret
    panic("release");
    80005abc:	00002517          	auipc	a0,0x2
    80005ac0:	c6450513          	addi	a0,a0,-924 # 80007720 <etext+0x720>
    80005ac4:	c73ff0ef          	jal	80005736 <panic>
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
