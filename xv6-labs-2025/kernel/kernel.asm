
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	0001c117          	auipc	sp,0x1c
    80000004:	06010113          	addi	sp,sp,96 # 8001c060 <stack0>
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
    80000016:	4e0050ef          	jal	800054f6 <start>

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

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= SMALLPGSTOP)
    80000028:	00024797          	auipc	a5,0x24
    8000002c:	11078793          	addi	a5,a5,272 # 80024138 <end>
    80000030:	00f53733          	sltu	a4,a0,a5
    80000034:	04300793          	li	a5,67
    80000038:	07e6                	slli	a5,a5,0x19
    8000003a:	17fd                	addi	a5,a5,-1
    8000003c:	00a7b7b3          	sltu	a5,a5,a0
    80000040:	8fd9                	or	a5,a5,a4
    80000042:	ef95                	bnez	a5,8000007e <kfree+0x62>
    80000044:	84aa                	mv	s1,a0
    80000046:	03451793          	slli	a5,a0,0x34
    8000004a:	eb95                	bnez	a5,8000007e <kfree+0x62>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    8000004c:	6605                	lui	a2,0x1
    8000004e:	4585                	li	a1,1
    80000050:	24c000ef          	jal	8000029c <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000054:	00009917          	auipc	s2,0x9
    80000058:	9bc90913          	addi	s2,s2,-1604 # 80008a10 <kmem>
    8000005c:	854a                	mv	a0,s2
    8000005e:	71b050ef          	jal	80005f78 <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	79f050ef          	jal	8000600c <release>
}
    80000072:	60e2                	ld	ra,24(sp)
    80000074:	6442                	ld	s0,16(sp)
    80000076:	64a2                	ld	s1,8(sp)
    80000078:	6902                	ld	s2,0(sp)
    8000007a:	6105                	addi	sp,sp,32
    8000007c:	8082                	ret
    panic("kfree");
    8000007e:	00008517          	auipc	a0,0x8
    80000082:	f8250513          	addi	a0,a0,-126 # 80008000 <etext>
    80000086:	431050ef          	jal	80005cb6 <panic>

000000008000008a <freerange>:
{
    8000008a:	7179                	addi	sp,sp,-48
    8000008c:	f406                	sd	ra,40(sp)
    8000008e:	f022                	sd	s0,32(sp)
    80000090:	ec26                	sd	s1,24(sp)
    80000092:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    80000094:	6785                	lui	a5,0x1
    80000096:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    8000009a:	00e504b3          	add	s1,a0,a4
    8000009e:	777d                	lui	a4,0xfffff
    800000a0:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000a2:	94be                	add	s1,s1,a5
    800000a4:	0295e263          	bltu	a1,s1,800000c8 <freerange+0x3e>
    800000a8:	e84a                	sd	s2,16(sp)
    800000aa:	e44e                	sd	s3,8(sp)
    800000ac:	e052                	sd	s4,0(sp)
    800000ae:	892e                	mv	s2,a1
    kfree(p);
    800000b0:	8a3a                	mv	s4,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b2:	89be                	mv	s3,a5
    kfree(p);
    800000b4:	01448533          	add	a0,s1,s4
    800000b8:	f65ff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000bc:	94ce                	add	s1,s1,s3
    800000be:	fe997be3          	bgeu	s2,s1,800000b4 <freerange+0x2a>
    800000c2:	6942                	ld	s2,16(sp)
    800000c4:	69a2                	ld	s3,8(sp)
    800000c6:	6a02                	ld	s4,0(sp)
}
    800000c8:	70a2                	ld	ra,40(sp)
    800000ca:	7402                	ld	s0,32(sp)
    800000cc:	64e2                	ld	s1,24(sp)
    800000ce:	6145                	addi	sp,sp,48
    800000d0:	8082                	ret

00000000800000d2 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    800000d2:	1101                	addi	sp,sp,-32
    800000d4:	ec06                	sd	ra,24(sp)
    800000d6:	e822                	sd	s0,16(sp)
    800000d8:	e426                	sd	s1,8(sp)
    800000da:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800000dc:	00009517          	auipc	a0,0x9
    800000e0:	93450513          	addi	a0,a0,-1740 # 80008a10 <kmem>
    800000e4:	695050ef          	jal	80005f78 <acquire>
  r = kmem.freelist;
    800000e8:	00009497          	auipc	s1,0x9
    800000ec:	9404b483          	ld	s1,-1728(s1) # 80008a28 <kmem+0x18>
  if(r)
    800000f0:	c49d                	beqz	s1,8000011e <kalloc+0x4c>
    kmem.freelist = r->next;
    800000f2:	609c                	ld	a5,0(s1)
    800000f4:	00009717          	auipc	a4,0x9
    800000f8:	92f73a23          	sd	a5,-1740(a4) # 80008a28 <kmem+0x18>
  release(&kmem.lock);
    800000fc:	00009517          	auipc	a0,0x9
    80000100:	91450513          	addi	a0,a0,-1772 # 80008a10 <kmem>
    80000104:	709050ef          	jal	8000600c <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    80000108:	6605                	lui	a2,0x1
    8000010a:	4595                	li	a1,5
    8000010c:	8526                	mv	a0,s1
    8000010e:	18e000ef          	jal	8000029c <memset>
  return (void*)r;
}
    80000112:	8526                	mv	a0,s1
    80000114:	60e2                	ld	ra,24(sp)
    80000116:	6442                	ld	s0,16(sp)
    80000118:	64a2                	ld	s1,8(sp)
    8000011a:	6105                	addi	sp,sp,32
    8000011c:	8082                	ret
  release(&kmem.lock);
    8000011e:	00009517          	auipc	a0,0x9
    80000122:	8f250513          	addi	a0,a0,-1806 # 80008a10 <kmem>
    80000126:	6e7050ef          	jal	8000600c <release>
  if(r)
    8000012a:	b7e5                	j	80000112 <kalloc+0x40>

000000008000012c <superalloc>:
// Allocate one 2 MB page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
superalloc(void)
{
    8000012c:	1101                	addi	sp,sp,-32
    8000012e:	ec06                	sd	ra,24(sp)
    80000130:	e822                	sd	s0,16(sp)
    80000132:	e426                	sd	s1,8(sp)
    80000134:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&supmem.lock);
    80000136:	00009517          	auipc	a0,0x9
    8000013a:	8fa50513          	addi	a0,a0,-1798 # 80008a30 <supmem>
    8000013e:	63b050ef          	jal	80005f78 <acquire>
  r = supmem.freelist;
    80000142:	00009497          	auipc	s1,0x9
    80000146:	9064b483          	ld	s1,-1786(s1) # 80008a48 <supmem+0x18>
  if(r)
    8000014a:	c885                	beqz	s1,8000017a <superalloc+0x4e>
    supmem.freelist = r->next;
    8000014c:	609c                	ld	a5,0(s1)
    8000014e:	00009717          	auipc	a4,0x9
    80000152:	8ef73d23          	sd	a5,-1798(a4) # 80008a48 <supmem+0x18>
  release(&supmem.lock);
    80000156:	00009517          	auipc	a0,0x9
    8000015a:	8da50513          	addi	a0,a0,-1830 # 80008a30 <supmem>
    8000015e:	6af050ef          	jal	8000600c <release>

  if(r)
    memset((char*)r, 5, SUPERPGSIZE); // fill with junk
    80000162:	00200637          	lui	a2,0x200
    80000166:	4595                	li	a1,5
    80000168:	8526                	mv	a0,s1
    8000016a:	132000ef          	jal	8000029c <memset>
  return (void*)r;
}
    8000016e:	8526                	mv	a0,s1
    80000170:	60e2                	ld	ra,24(sp)
    80000172:	6442                	ld	s0,16(sp)
    80000174:	64a2                	ld	s1,8(sp)
    80000176:	6105                	addi	sp,sp,32
    80000178:	8082                	ret
  release(&supmem.lock);
    8000017a:	00009517          	auipc	a0,0x9
    8000017e:	8b650513          	addi	a0,a0,-1866 # 80008a30 <supmem>
    80000182:	68b050ef          	jal	8000600c <release>
  if(r)
    80000186:	b7e5                	j	8000016e <superalloc+0x42>

0000000080000188 <superfree>:
// which normally should have been returned by a
// call to superalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
superfree(void *pa)
{
    80000188:	1101                	addi	sp,sp,-32
    8000018a:	ec06                	sd	ra,24(sp)
    8000018c:	e822                	sd	s0,16(sp)
    8000018e:	e426                	sd	s1,8(sp)
    80000190:	e04a                	sd	s2,0(sp)
    80000192:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % SUPERPGSIZE) != 0 || (uint64)pa < SMALLPGSTOP || (uint64)pa >= PHYSTOP)
    80000194:	02b51793          	slli	a5,a0,0x2b
    80000198:	ebb1                	bnez	a5,800001ec <superfree+0x64>
    8000019a:	84aa                	mv	s1,a0
    8000019c:	fbd00793          	li	a5,-67
    800001a0:	07e6                	slli	a5,a5,0x19
    800001a2:	97aa                	add	a5,a5,a0
    800001a4:	02000737          	lui	a4,0x2000
    800001a8:	04e7f263          	bgeu	a5,a4,800001ec <superfree+0x64>
    panic("superfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, SUPERPGSIZE);
    800001ac:	00200637          	lui	a2,0x200
    800001b0:	4585                	li	a1,1
    800001b2:	0ea000ef          	jal	8000029c <memset>

  r = (struct run*)pa;

  acquire(&supmem.lock);
    800001b6:	00009917          	auipc	s2,0x9
    800001ba:	85a90913          	addi	s2,s2,-1958 # 80008a10 <kmem>
    800001be:	00009517          	auipc	a0,0x9
    800001c2:	87250513          	addi	a0,a0,-1934 # 80008a30 <supmem>
    800001c6:	5b3050ef          	jal	80005f78 <acquire>
  r->next = supmem.freelist;
    800001ca:	03893783          	ld	a5,56(s2)
    800001ce:	e09c                	sd	a5,0(s1)
  supmem.freelist = r;
    800001d0:	02993c23          	sd	s1,56(s2)
  release(&supmem.lock);
    800001d4:	00009517          	auipc	a0,0x9
    800001d8:	85c50513          	addi	a0,a0,-1956 # 80008a30 <supmem>
    800001dc:	631050ef          	jal	8000600c <release>
}
    800001e0:	60e2                	ld	ra,24(sp)
    800001e2:	6442                	ld	s0,16(sp)
    800001e4:	64a2                	ld	s1,8(sp)
    800001e6:	6902                	ld	s2,0(sp)
    800001e8:	6105                	addi	sp,sp,32
    800001ea:	8082                	ret
    panic("superfree");
    800001ec:	00008517          	auipc	a0,0x8
    800001f0:	e2450513          	addi	a0,a0,-476 # 80008010 <etext+0x10>
    800001f4:	2c3050ef          	jal	80005cb6 <panic>

00000000800001f8 <superfreerange>:
{
    800001f8:	7179                	addi	sp,sp,-48
    800001fa:	f406                	sd	ra,40(sp)
    800001fc:	f022                	sd	s0,32(sp)
    800001fe:	ec26                	sd	s1,24(sp)
    80000200:	1800                	addi	s0,sp,48
  p = (char*)SUPERPGROUNDUP((uint64)pa_start);
    80000202:	002007b7          	lui	a5,0x200
    80000206:	fff78713          	addi	a4,a5,-1 # 1fffff <_entry-0x7fe00001>
    8000020a:	00e504b3          	add	s1,a0,a4
    8000020e:	ffe00737          	lui	a4,0xffe00
    80000212:	8cf9                	and	s1,s1,a4
  for(; p + SUPERPGSIZE <= (char*)pa_end; p += SUPERPGSIZE)
    80000214:	94be                	add	s1,s1,a5
    80000216:	0295e263          	bltu	a1,s1,8000023a <superfreerange+0x42>
    8000021a:	e84a                	sd	s2,16(sp)
    8000021c:	e44e                	sd	s3,8(sp)
    8000021e:	e052                	sd	s4,0(sp)
    80000220:	892e                	mv	s2,a1
    superfree(p);
    80000222:	8a3a                	mv	s4,a4
  for(; p + SUPERPGSIZE <= (char*)pa_end; p += SUPERPGSIZE)
    80000224:	89be                	mv	s3,a5
    superfree(p);
    80000226:	01448533          	add	a0,s1,s4
    8000022a:	f5fff0ef          	jal	80000188 <superfree>
  for(; p + SUPERPGSIZE <= (char*)pa_end; p += SUPERPGSIZE)
    8000022e:	94ce                	add	s1,s1,s3
    80000230:	fe997be3          	bgeu	s2,s1,80000226 <superfreerange+0x2e>
    80000234:	6942                	ld	s2,16(sp)
    80000236:	69a2                	ld	s3,8(sp)
    80000238:	6a02                	ld	s4,0(sp)
}
    8000023a:	70a2                	ld	ra,40(sp)
    8000023c:	7402                	ld	s0,32(sp)
    8000023e:	64e2                	ld	s1,24(sp)
    80000240:	6145                	addi	sp,sp,48
    80000242:	8082                	ret

0000000080000244 <kinit>:
{
    80000244:	1141                	addi	sp,sp,-16
    80000246:	e406                	sd	ra,8(sp)
    80000248:	e022                	sd	s0,0(sp)
    8000024a:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000024c:	00008597          	auipc	a1,0x8
    80000250:	dd458593          	addi	a1,a1,-556 # 80008020 <etext+0x20>
    80000254:	00008517          	auipc	a0,0x8
    80000258:	7bc50513          	addi	a0,a0,1980 # 80008a10 <kmem>
    8000025c:	493050ef          	jal	80005eee <initlock>
  initlock(&supmem.lock, "supmem");
    80000260:	00008597          	auipc	a1,0x8
    80000264:	dc858593          	addi	a1,a1,-568 # 80008028 <etext+0x28>
    80000268:	00008517          	auipc	a0,0x8
    8000026c:	7c850513          	addi	a0,a0,1992 # 80008a30 <supmem>
    80000270:	47f050ef          	jal	80005eee <initlock>
  freerange(end, (void*)SMALLPGSTOP);
    80000274:	04300593          	li	a1,67
    80000278:	05e6                	slli	a1,a1,0x19
    8000027a:	00024517          	auipc	a0,0x24
    8000027e:	ebe50513          	addi	a0,a0,-322 # 80024138 <end>
    80000282:	e09ff0ef          	jal	8000008a <freerange>
  superfreerange((void*)SMALLPGSTOP, (void*)PHYSTOP);
    80000286:	45c5                	li	a1,17
    80000288:	05ee                	slli	a1,a1,0x1b
    8000028a:	04300513          	li	a0,67
    8000028e:	0566                	slli	a0,a0,0x19
    80000290:	f69ff0ef          	jal	800001f8 <superfreerange>
}
    80000294:	60a2                	ld	ra,8(sp)
    80000296:	6402                	ld	s0,0(sp)
    80000298:	0141                	addi	sp,sp,16
    8000029a:	8082                	ret

000000008000029c <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    8000029c:	1141                	addi	sp,sp,-16
    8000029e:	e406                	sd	ra,8(sp)
    800002a0:	e022                	sd	s0,0(sp)
    800002a2:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002a4:	ca19                	beqz	a2,800002ba <memset+0x1e>
    800002a6:	87aa                	mv	a5,a0
    800002a8:	1602                	slli	a2,a2,0x20
    800002aa:	9201                	srli	a2,a2,0x20
    800002ac:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002b0:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002b4:	0785                	addi	a5,a5,1
    800002b6:	fee79de3          	bne	a5,a4,800002b0 <memset+0x14>
  }
  return dst;
}
    800002ba:	60a2                	ld	ra,8(sp)
    800002bc:	6402                	ld	s0,0(sp)
    800002be:	0141                	addi	sp,sp,16
    800002c0:	8082                	ret

00000000800002c2 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002c2:	1141                	addi	sp,sp,-16
    800002c4:	e406                	sd	ra,8(sp)
    800002c6:	e022                	sd	s0,0(sp)
    800002c8:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002ca:	c61d                	beqz	a2,800002f8 <memcmp+0x36>
    800002cc:	1602                	slli	a2,a2,0x20
    800002ce:	9201                	srli	a2,a2,0x20
    800002d0:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    800002d4:	00054783          	lbu	a5,0(a0)
    800002d8:	0005c703          	lbu	a4,0(a1)
    800002dc:	00e79863          	bne	a5,a4,800002ec <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    800002e0:	0505                	addi	a0,a0,1
    800002e2:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002e4:	fed518e3          	bne	a0,a3,800002d4 <memcmp+0x12>
  }

  return 0;
    800002e8:	4501                	li	a0,0
    800002ea:	a019                	j	800002f0 <memcmp+0x2e>
      return *s1 - *s2;
    800002ec:	40e7853b          	subw	a0,a5,a4
}
    800002f0:	60a2                	ld	ra,8(sp)
    800002f2:	6402                	ld	s0,0(sp)
    800002f4:	0141                	addi	sp,sp,16
    800002f6:	8082                	ret
  return 0;
    800002f8:	4501                	li	a0,0
    800002fa:	bfdd                	j	800002f0 <memcmp+0x2e>

00000000800002fc <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e406                	sd	ra,8(sp)
    80000300:	e022                	sd	s0,0(sp)
    80000302:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    80000304:	c205                	beqz	a2,80000324 <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    80000306:	02a5e363          	bltu	a1,a0,8000032c <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    8000030a:	1602                	slli	a2,a2,0x20
    8000030c:	9201                	srli	a2,a2,0x20
    8000030e:	00c587b3          	add	a5,a1,a2
{
    80000312:	872a                	mv	a4,a0
      *d++ = *s++;
    80000314:	0585                	addi	a1,a1,1
    80000316:	0705                	addi	a4,a4,1 # ffffffffffe00001 <end+0xffffffff7fddbec9>
    80000318:	fff5c683          	lbu	a3,-1(a1)
    8000031c:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000320:	feb79ae3          	bne	a5,a1,80000314 <memmove+0x18>

  return dst;
}
    80000324:	60a2                	ld	ra,8(sp)
    80000326:	6402                	ld	s0,0(sp)
    80000328:	0141                	addi	sp,sp,16
    8000032a:	8082                	ret
  if(s < d && s + n > d){
    8000032c:	02061693          	slli	a3,a2,0x20
    80000330:	9281                	srli	a3,a3,0x20
    80000332:	00d58733          	add	a4,a1,a3
    80000336:	fce57ae3          	bgeu	a0,a4,8000030a <memmove+0xe>
    d += n;
    8000033a:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    8000033c:	fff6079b          	addiw	a5,a2,-1 # 1fffff <_entry-0x7fe00001>
    80000340:	1782                	slli	a5,a5,0x20
    80000342:	9381                	srli	a5,a5,0x20
    80000344:	fff7c793          	not	a5,a5
    80000348:	97ba                	add	a5,a5,a4
      *--d = *--s;
    8000034a:	177d                	addi	a4,a4,-1
    8000034c:	16fd                	addi	a3,a3,-1
    8000034e:	00074603          	lbu	a2,0(a4)
    80000352:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000356:	fee79ae3          	bne	a5,a4,8000034a <memmove+0x4e>
    8000035a:	b7e9                	j	80000324 <memmove+0x28>

000000008000035c <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    8000035c:	1141                	addi	sp,sp,-16
    8000035e:	e406                	sd	ra,8(sp)
    80000360:	e022                	sd	s0,0(sp)
    80000362:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000364:	f99ff0ef          	jal	800002fc <memmove>
}
    80000368:	60a2                	ld	ra,8(sp)
    8000036a:	6402                	ld	s0,0(sp)
    8000036c:	0141                	addi	sp,sp,16
    8000036e:	8082                	ret

0000000080000370 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000370:	1141                	addi	sp,sp,-16
    80000372:	e406                	sd	ra,8(sp)
    80000374:	e022                	sd	s0,0(sp)
    80000376:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000378:	ce11                	beqz	a2,80000394 <strncmp+0x24>
    8000037a:	00054783          	lbu	a5,0(a0)
    8000037e:	cf89                	beqz	a5,80000398 <strncmp+0x28>
    80000380:	0005c703          	lbu	a4,0(a1)
    80000384:	00f71a63          	bne	a4,a5,80000398 <strncmp+0x28>
    n--, p++, q++;
    80000388:	367d                	addiw	a2,a2,-1
    8000038a:	0505                	addi	a0,a0,1
    8000038c:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000038e:	f675                	bnez	a2,8000037a <strncmp+0xa>
  if(n == 0)
    return 0;
    80000390:	4501                	li	a0,0
    80000392:	a801                	j	800003a2 <strncmp+0x32>
    80000394:	4501                	li	a0,0
    80000396:	a031                	j	800003a2 <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    80000398:	00054503          	lbu	a0,0(a0)
    8000039c:	0005c783          	lbu	a5,0(a1)
    800003a0:	9d1d                	subw	a0,a0,a5
}
    800003a2:	60a2                	ld	ra,8(sp)
    800003a4:	6402                	ld	s0,0(sp)
    800003a6:	0141                	addi	sp,sp,16
    800003a8:	8082                	ret

00000000800003aa <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003aa:	1141                	addi	sp,sp,-16
    800003ac:	e406                	sd	ra,8(sp)
    800003ae:	e022                	sd	s0,0(sp)
    800003b0:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003b2:	87aa                	mv	a5,a0
    800003b4:	a011                	j	800003b8 <strncpy+0xe>
    800003b6:	8636                	mv	a2,a3
    800003b8:	02c05863          	blez	a2,800003e8 <strncpy+0x3e>
    800003bc:	fff6069b          	addiw	a3,a2,-1
    800003c0:	8836                	mv	a6,a3
    800003c2:	0785                	addi	a5,a5,1
    800003c4:	0005c703          	lbu	a4,0(a1)
    800003c8:	fee78fa3          	sb	a4,-1(a5)
    800003cc:	0585                	addi	a1,a1,1
    800003ce:	f765                	bnez	a4,800003b6 <strncpy+0xc>
    ;
  while(n-- > 0)
    800003d0:	873e                	mv	a4,a5
    800003d2:	01005b63          	blez	a6,800003e8 <strncpy+0x3e>
    800003d6:	9fb1                	addw	a5,a5,a2
    800003d8:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    800003da:	0705                	addi	a4,a4,1
    800003dc:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800003e0:	40e786bb          	subw	a3,a5,a4
    800003e4:	fed04be3          	bgtz	a3,800003da <strncpy+0x30>
  return os;
}
    800003e8:	60a2                	ld	ra,8(sp)
    800003ea:	6402                	ld	s0,0(sp)
    800003ec:	0141                	addi	sp,sp,16
    800003ee:	8082                	ret

00000000800003f0 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003f0:	1141                	addi	sp,sp,-16
    800003f2:	e406                	sd	ra,8(sp)
    800003f4:	e022                	sd	s0,0(sp)
    800003f6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800003f8:	02c05363          	blez	a2,8000041e <safestrcpy+0x2e>
    800003fc:	fff6069b          	addiw	a3,a2,-1
    80000400:	1682                	slli	a3,a3,0x20
    80000402:	9281                	srli	a3,a3,0x20
    80000404:	96ae                	add	a3,a3,a1
    80000406:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000408:	00d58963          	beq	a1,a3,8000041a <safestrcpy+0x2a>
    8000040c:	0585                	addi	a1,a1,1
    8000040e:	0785                	addi	a5,a5,1
    80000410:	fff5c703          	lbu	a4,-1(a1)
    80000414:	fee78fa3          	sb	a4,-1(a5)
    80000418:	fb65                	bnez	a4,80000408 <safestrcpy+0x18>
    ;
  *s = 0;
    8000041a:	00078023          	sb	zero,0(a5)
  return os;
}
    8000041e:	60a2                	ld	ra,8(sp)
    80000420:	6402                	ld	s0,0(sp)
    80000422:	0141                	addi	sp,sp,16
    80000424:	8082                	ret

0000000080000426 <strlen>:

int
strlen(const char *s)
{
    80000426:	1141                	addi	sp,sp,-16
    80000428:	e406                	sd	ra,8(sp)
    8000042a:	e022                	sd	s0,0(sp)
    8000042c:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    8000042e:	00054783          	lbu	a5,0(a0)
    80000432:	cf91                	beqz	a5,8000044e <strlen+0x28>
    80000434:	00150793          	addi	a5,a0,1
    80000438:	86be                	mv	a3,a5
    8000043a:	0785                	addi	a5,a5,1
    8000043c:	fff7c703          	lbu	a4,-1(a5)
    80000440:	ff65                	bnez	a4,80000438 <strlen+0x12>
    80000442:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    80000446:	60a2                	ld	ra,8(sp)
    80000448:	6402                	ld	s0,0(sp)
    8000044a:	0141                	addi	sp,sp,16
    8000044c:	8082                	ret
  for(n = 0; s[n]; n++)
    8000044e:	4501                	li	a0,0
    80000450:	bfdd                	j	80000446 <strlen+0x20>

0000000080000452 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000452:	1141                	addi	sp,sp,-16
    80000454:	e406                	sd	ra,8(sp)
    80000456:	e022                	sd	s0,0(sp)
    80000458:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000045a:	6b3000ef          	jal	8000130c <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    8000045e:	00008717          	auipc	a4,0x8
    80000462:	58270713          	addi	a4,a4,1410 # 800089e0 <started>
  if(cpuid() == 0){
    80000466:	c51d                	beqz	a0,80000494 <main+0x42>
    while(started == 0)
    80000468:	431c                	lw	a5,0(a4)
    8000046a:	2781                	sext.w	a5,a5
    8000046c:	dff5                	beqz	a5,80000468 <main+0x16>
      ;
    __sync_synchronize();
    8000046e:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    80000472:	69b000ef          	jal	8000130c <cpuid>
    80000476:	85aa                	mv	a1,a0
    80000478:	00008517          	auipc	a0,0x8
    8000047c:	bd850513          	addi	a0,a0,-1064 # 80008050 <etext+0x50>
    80000480:	50c050ef          	jal	8000598c <printf>
    kvminithart();    // turn on paging
    80000484:	080000ef          	jal	80000504 <kvminithart>
    trapinithart();   // install kernel trap vector
    80000488:	24d010ef          	jal	80001ed4 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    8000048c:	2ad040ef          	jal	80004f38 <plicinithart>
  }

  scheduler();        
    80000490:	38a010ef          	jal	8000181a <scheduler>
    consoleinit();
    80000494:	41e050ef          	jal	800058b2 <consoleinit>
    printfinit();
    80000498:	05b050ef          	jal	80005cf2 <printfinit>
    printf("\n");
    8000049c:	00008517          	auipc	a0,0x8
    800004a0:	b9450513          	addi	a0,a0,-1132 # 80008030 <etext+0x30>
    800004a4:	4e8050ef          	jal	8000598c <printf>
    printf("xv6 kernel is booting\n");
    800004a8:	00008517          	auipc	a0,0x8
    800004ac:	b9050513          	addi	a0,a0,-1136 # 80008038 <etext+0x38>
    800004b0:	4dc050ef          	jal	8000598c <printf>
    printf("\n");
    800004b4:	00008517          	auipc	a0,0x8
    800004b8:	b7c50513          	addi	a0,a0,-1156 # 80008030 <etext+0x30>
    800004bc:	4d0050ef          	jal	8000598c <printf>
    kinit();         // physical page allocator
    800004c0:	d85ff0ef          	jal	80000244 <kinit>
    kvminit();       // create kernel page table
    800004c4:	50c000ef          	jal	800009d0 <kvminit>
    kvminithart();   // turn on paging
    800004c8:	03c000ef          	jal	80000504 <kvminithart>
    procinit();      // process table
    800004cc:	595000ef          	jal	80001260 <procinit>
    trapinit();      // trap vectors
    800004d0:	1e1010ef          	jal	80001eb0 <trapinit>
    trapinithart();  // install kernel trap vector
    800004d4:	201010ef          	jal	80001ed4 <trapinithart>
    plicinit();      // set up interrupt controller
    800004d8:	247040ef          	jal	80004f1e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004dc:	25d040ef          	jal	80004f38 <plicinithart>
    binit();         // buffer cache
    800004e0:	0d4020ef          	jal	800025b4 <binit>
    iinit();         // inode table
    800004e4:	626020ef          	jal	80002b0a <iinit>
    fileinit();      // file table
    800004e8:	552030ef          	jal	80003a3a <fileinit>
    virtio_disk_init(); // emulated hard disk
    800004ec:	33d040ef          	jal	80005028 <virtio_disk_init>
    userinit();      // first user process
    800004f0:	190010ef          	jal	80001680 <userinit>
    __sync_synchronize();
    800004f4:	0330000f          	fence	rw,rw
    started = 1;
    800004f8:	4785                	li	a5,1
    800004fa:	00008717          	auipc	a4,0x8
    800004fe:	4ef72323          	sw	a5,1254(a4) # 800089e0 <started>
    80000502:	b779                	j	80000490 <main+0x3e>

0000000080000504 <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    80000504:	1141                	addi	sp,sp,-16
    80000506:	e406                	sd	ra,8(sp)
    80000508:	e022                	sd	s0,0(sp)
    8000050a:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    8000050c:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000510:	00008797          	auipc	a5,0x8
    80000514:	4d87b783          	ld	a5,1240(a5) # 800089e8 <kernel_pagetable>
    80000518:	83b1                	srli	a5,a5,0xc
    8000051a:	577d                	li	a4,-1
    8000051c:	177e                	slli	a4,a4,0x3f
    8000051e:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000520:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    80000524:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000528:	60a2                	ld	ra,8(sp)
    8000052a:	6402                	ld	s0,0(sp)
    8000052c:	0141                	addi	sp,sp,16
    8000052e:	8082                	ret

0000000080000530 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc, int *level_out)
{
    80000530:	715d                	addi	sp,sp,-80
    80000532:	e486                	sd	ra,72(sp)
    80000534:	e0a2                	sd	s0,64(sp)
    80000536:	fc26                	sd	s1,56(sp)
    80000538:	f84a                	sd	s2,48(sp)
    8000053a:	f44e                	sd	s3,40(sp)
    8000053c:	f052                	sd	s4,32(sp)
    8000053e:	ec56                	sd	s5,24(sp)
    80000540:	e85a                	sd	s6,16(sp)
    80000542:	e45e                	sd	s7,8(sp)
    80000544:	0880                	addi	s0,sp,80
    80000546:	84aa                	mv	s1,a0
    80000548:	89ae                	mv	s3,a1
    8000054a:	8bb2                	mv	s7,a2
    8000054c:	8b36                	mv	s6,a3
  if(va >= MAXVA)
    8000054e:	57fd                	li	a5,-1
    80000550:	83e9                	srli	a5,a5,0x1a
    80000552:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000554:	4a89                	li	s5,2
  if(va >= MAXVA)
    80000556:	04b7eb63          	bltu	a5,a1,800005ac <walk+0x7c>
    pte_t *pte = &pagetable[PX(level, va)];
    8000055a:	0149d933          	srl	s2,s3,s4
    8000055e:	1ff97913          	andi	s2,s2,511
    80000562:	090e                	slli	s2,s2,0x3
    80000564:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    80000566:	00093483          	ld	s1,0(s2)
    8000056a:	0014f793          	andi	a5,s1,1
    8000056e:	cba1                	beqz	a5,800005be <walk+0x8e>
      pagetable = (pagetable_t)PTE2PA(*pte);
#ifdef LAB_PGTBL
      if(PTE_LEAF(*pte)) {
    80000570:	00e4f793          	andi	a5,s1,14
    80000574:	e3b1                	bnez	a5,800005b8 <walk+0x88>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000576:	80a9                	srli	s1,s1,0xa
    80000578:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    8000057a:	3afd                	addiw	s5,s5,-1
    8000057c:	3a5d                	addiw	s4,s4,-9
    8000057e:	fc0a9ee3          	bnez	s5,8000055a <walk+0x2a>
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }

  *level_out = 0;
    80000582:	000b2023          	sw	zero,0(s6)
  return &pagetable[PX(0, va)];
    80000586:	00c9d993          	srli	s3,s3,0xc
    8000058a:	1ff9f993          	andi	s3,s3,511
    8000058e:	098e                	slli	s3,s3,0x3
    80000590:	01348933          	add	s2,s1,s3
}
    80000594:	854a                	mv	a0,s2
    80000596:	60a6                	ld	ra,72(sp)
    80000598:	6406                	ld	s0,64(sp)
    8000059a:	74e2                	ld	s1,56(sp)
    8000059c:	7942                	ld	s2,48(sp)
    8000059e:	79a2                	ld	s3,40(sp)
    800005a0:	7a02                	ld	s4,32(sp)
    800005a2:	6ae2                	ld	s5,24(sp)
    800005a4:	6b42                	ld	s6,16(sp)
    800005a6:	6ba2                	ld	s7,8(sp)
    800005a8:	6161                	addi	sp,sp,80
    800005aa:	8082                	ret
    panic("walk");
    800005ac:	00008517          	auipc	a0,0x8
    800005b0:	abc50513          	addi	a0,a0,-1348 # 80008068 <etext+0x68>
    800005b4:	702050ef          	jal	80005cb6 <panic>
        *level_out = level;
    800005b8:	015b2023          	sw	s5,0(s6)
        return pte;
    800005bc:	bfe1                	j	80000594 <walk+0x64>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005be:	020b8263          	beqz	s7,800005e2 <walk+0xb2>
    800005c2:	b11ff0ef          	jal	800000d2 <kalloc>
    800005c6:	84aa                	mv	s1,a0
    800005c8:	cd19                	beqz	a0,800005e6 <walk+0xb6>
      memset(pagetable, 0, PGSIZE);
    800005ca:	6605                	lui	a2,0x1
    800005cc:	4581                	li	a1,0
    800005ce:	ccfff0ef          	jal	8000029c <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005d2:	00c4d793          	srli	a5,s1,0xc
    800005d6:	07aa                	slli	a5,a5,0xa
    800005d8:	0017e793          	ori	a5,a5,1
    800005dc:	00f93023          	sd	a5,0(s2)
    800005e0:	bf69                	j	8000057a <walk+0x4a>
        return 0;
    800005e2:	4901                	li	s2,0
    800005e4:	bf45                	j	80000594 <walk+0x64>
    800005e6:	892a                	mv	s2,a0
    800005e8:	b775                	j	80000594 <walk+0x64>

00000000800005ea <superwalk>:
//   30..38 -- 9 bits of level-2 index.
//   21..29 -- 9 bits of level-1 index.
//    0..20 -- 21 bits of byte offset within the page.
pte_t *
superwalk(pagetable_t pagetable, uint64 va, int alloc)
{
    800005ea:	7179                	addi	sp,sp,-48
    800005ec:	f406                	sd	ra,40(sp)
    800005ee:	f022                	sd	s0,32(sp)
    800005f0:	ec26                	sd	s1,24(sp)
    800005f2:	e84a                	sd	s2,16(sp)
    800005f4:	e44e                	sd	s3,8(sp)
    800005f6:	1800                	addi	s0,sp,48
  if(va >= MAXVA)
    800005f8:	57fd                	li	a5,-1
    800005fa:	83e9                	srli	a5,a5,0x1a
    800005fc:	04b7e163          	bltu	a5,a1,8000063e <superwalk+0x54>
    80000600:	84ae                	mv	s1,a1
    panic("superwalk");

  pte_t *pte = &pagetable[PX(2, va)];
    80000602:	01e5d793          	srli	a5,a1,0x1e
    80000606:	078e                	slli	a5,a5,0x3
    80000608:	00f50933          	add	s2,a0,a5
  if(*pte & PTE_V) {
    8000060c:	00093503          	ld	a0,0(s2)
    80000610:	00157793          	andi	a5,a0,1
    80000614:	cb9d                	beqz	a5,8000064a <superwalk+0x60>
    if (*pte & (PTE_R | PTE_W | PTE_X)) { // already leaf?
    80000616:	00e57793          	andi	a5,a0,14
    8000061a:	eb91                	bnez	a5,8000062e <superwalk+0x44>
      return pte;
    }
    pagetable = (pagetable_t)PTE2PA(*pte);
    8000061c:	8129                	srli	a0,a0,0xa
    8000061e:	00c51993          	slli	s3,a0,0xc
      return 0;
    memset(pagetable, 0, PGSIZE);
    *pte = PA2PTE(pagetable) | PTE_V;
  }

  return &pagetable[PX(1, va)];
    80000622:	80d5                	srli	s1,s1,0x15
    80000624:	1ff4f493          	andi	s1,s1,511
    80000628:	048e                	slli	s1,s1,0x3
    8000062a:	00998933          	add	s2,s3,s1
}
    8000062e:	854a                	mv	a0,s2
    80000630:	70a2                	ld	ra,40(sp)
    80000632:	7402                	ld	s0,32(sp)
    80000634:	64e2                	ld	s1,24(sp)
    80000636:	6942                	ld	s2,16(sp)
    80000638:	69a2                	ld	s3,8(sp)
    8000063a:	6145                	addi	sp,sp,48
    8000063c:	8082                	ret
    panic("superwalk");
    8000063e:	00008517          	auipc	a0,0x8
    80000642:	a3250513          	addi	a0,a0,-1486 # 80008070 <etext+0x70>
    80000646:	670050ef          	jal	80005cb6 <panic>
    if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    8000064a:	c20d                	beqz	a2,8000066c <superwalk+0x82>
    8000064c:	a87ff0ef          	jal	800000d2 <kalloc>
    80000650:	89aa                	mv	s3,a0
    80000652:	cd19                	beqz	a0,80000670 <superwalk+0x86>
    memset(pagetable, 0, PGSIZE);
    80000654:	6605                	lui	a2,0x1
    80000656:	4581                	li	a1,0
    80000658:	c45ff0ef          	jal	8000029c <memset>
    *pte = PA2PTE(pagetable) | PTE_V;
    8000065c:	00c9d793          	srli	a5,s3,0xc
    80000660:	07aa                	slli	a5,a5,0xa
    80000662:	0017e793          	ori	a5,a5,1
    80000666:	00f93023          	sd	a5,0(s2)
    8000066a:	bf65                	j	80000622 <superwalk+0x38>
      return 0;
    8000066c:	4901                	li	s2,0
    8000066e:	b7c1                	j	8000062e <superwalk+0x44>
    80000670:	892a                	mv	s2,a0
    80000672:	bf75                	j	8000062e <superwalk+0x44>

0000000080000674 <walkaddr>:
{
  pte_t *pte;
  uint64 pa;
  int lvl;

  if(va >= MAXVA)
    80000674:	57fd                	li	a5,-1
    80000676:	83e9                	srli	a5,a5,0x1a
    80000678:	00b7f463          	bgeu	a5,a1,80000680 <walkaddr+0xc>
    return 0;
    8000067c:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    8000067e:	8082                	ret
{
    80000680:	1101                	addi	sp,sp,-32
    80000682:	ec06                	sd	ra,24(sp)
    80000684:	e822                	sd	s0,16(sp)
    80000686:	1000                	addi	s0,sp,32
  pte = walk(pagetable, va, 0, &lvl);
    80000688:	fec40693          	addi	a3,s0,-20
    8000068c:	4601                	li	a2,0
    8000068e:	ea3ff0ef          	jal	80000530 <walk>
  if(pte == 0)
    80000692:	c901                	beqz	a0,800006a2 <walkaddr+0x2e>
  if((*pte & PTE_V) == 0)
    80000694:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    80000696:	0117f693          	andi	a3,a5,17
    8000069a:	4745                	li	a4,17
    return 0;
    8000069c:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    8000069e:	00e68663          	beq	a3,a4,800006aa <walkaddr+0x36>
}
    800006a2:	60e2                	ld	ra,24(sp)
    800006a4:	6442                	ld	s0,16(sp)
    800006a6:	6105                	addi	sp,sp,32
    800006a8:	8082                	ret
  pa = PTE2PA(*pte);
    800006aa:	83a9                	srli	a5,a5,0xa
    800006ac:	00c79513          	slli	a0,a5,0xc
  return pa;
    800006b0:	bfcd                	j	800006a2 <walkaddr+0x2e>

00000000800006b2 <vmprint>:


#if defined(LAB_PGTBL) || defined(SOL_MMAP) || defined(SOL_COW)
void
vmprint(pagetable_t pagetable) {
    800006b2:	7119                	addi	sp,sp,-128
    800006b4:	fc86                	sd	ra,120(sp)
    800006b6:	f8a2                	sd	s0,112(sp)
    800006b8:	f4a6                	sd	s1,104(sp)
    800006ba:	f0ca                	sd	s2,96(sp)
    800006bc:	ecce                	sd	s3,88(sp)
    800006be:	e8d2                	sd	s4,80(sp)
    800006c0:	e4d6                	sd	s5,72(sp)
    800006c2:	e0da                	sd	s6,64(sp)
    800006c4:	fc5e                	sd	s7,56(sp)
    800006c6:	f862                	sd	s8,48(sp)
    800006c8:	f466                	sd	s9,40(sp)
    800006ca:	f06a                	sd	s10,32(sp)
    800006cc:	ec6e                	sd	s11,24(sp)
    800006ce:	0100                	addi	s0,sp,128
    800006d0:	84aa                	mv	s1,a0
  printf("page table %p\n", pagetable);
    800006d2:	85aa                	mv	a1,a0
    800006d4:	00008517          	auipc	a0,0x8
    800006d8:	9ac50513          	addi	a0,a0,-1620 # 80008080 <etext+0x80>
    800006dc:	2b0050ef          	jal	8000598c <printf>

  // For loop the l2 page table
  for(uint64 l2 = 0; l2 < 512; l2++){
    800006e0:	f8943423          	sd	s1,-120(s0)
  printf("page table %p\n", pagetable);
    800006e4:	4d01                	li	s10,0
        if((pte & PTE_V) == 0){
          continue;
        }
        uint64 l0va = l1va | (l0 << 12);
        uint64 pa = PTE2PA(pte);
        printf(".. .. .. %p: pte %p pa %p\n", (void *)l0va, (void *)pte, (void *)pa);
    800006e6:	00008b17          	auipc	s6,0x8
    800006ea:	9dab0b13          	addi	s6,s6,-1574 # 800080c0 <etext+0xc0>
      for(uint64 l0 = 0; l0 < 512; l0++){
    800006ee:	6a05                	lui	s4,0x1
    800006f0:	002009b7          	lui	s3,0x200
    800006f4:	a0a5                	j	8000075c <vmprint+0xaa>
    800006f6:	0921                	addi	s2,s2,8
    800006f8:	94d2                	add	s1,s1,s4
    800006fa:	03348063          	beq	s1,s3,8000071a <vmprint+0x68>
        pte_t pte = l0pa[l0];
    800006fe:	00093603          	ld	a2,0(s2)
        if((pte & PTE_V) == 0){
    80000702:	00167793          	andi	a5,a2,1
    80000706:	dbe5                	beqz	a5,800006f6 <vmprint+0x44>
        uint64 pa = PTE2PA(pte);
    80000708:	00a65693          	srli	a3,a2,0xa
        printf(".. .. .. %p: pte %p pa %p\n", (void *)l0va, (void *)pte, (void *)pa);
    8000070c:	06b2                	slli	a3,a3,0xc
    8000070e:	009ae5b3          	or	a1,s5,s1
    80000712:	855a                	mv	a0,s6
    80000714:	278050ef          	jal	8000598c <printf>
    80000718:	bff9                	j	800006f6 <vmprint+0x44>
    for(uint64 l1 = 0; l1 < 512; l1++){
    8000071a:	0c21                	addi	s8,s8,8
    8000071c:	9bce                	add	s7,s7,s3
    8000071e:	039b8363          	beq	s7,s9,80000744 <vmprint+0x92>
      pte_t pte = l1pa[l1];
    80000722:	000c3603          	ld	a2,0(s8)
      if((pte & PTE_V) == 0){
    80000726:	00167793          	andi	a5,a2,1
    8000072a:	dbe5                	beqz	a5,8000071a <vmprint+0x68>
      uint64 l1va = va | (l1 << 21);
    8000072c:	01abeab3          	or	s5,s7,s10
      pagetable_t l0pa = (pagetable_t) PTE2PA(pte);
    80000730:	00a65913          	srli	s2,a2,0xa
    80000734:	0932                	slli	s2,s2,0xc
      printf(".. .. %p: pte %p pa %p\n", (void *)l1va, (void *)pte, (void *)l0pa);
    80000736:	86ca                	mv	a3,s2
    80000738:	85d6                	mv	a1,s5
    8000073a:	856e                	mv	a0,s11
    8000073c:	250050ef          	jal	8000598c <printf>
    80000740:	4481                	li	s1,0
    80000742:	bf75                	j	800006fe <vmprint+0x4c>
  for(uint64 l2 = 0; l2 < 512; l2++){
    80000744:	f8843783          	ld	a5,-120(s0)
    80000748:	07a1                	addi	a5,a5,8
    8000074a:	f8f43423          	sd	a5,-120(s0)
    8000074e:	400007b7          	lui	a5,0x40000
    80000752:	9d3e                	add	s10,s10,a5
    80000754:	4785                	li	a5,1
    80000756:	179e                	slli	a5,a5,0x27
    80000758:	02fd0b63          	beq	s10,a5,8000078e <vmprint+0xdc>
    pte_t pte = pagetable[l2];
    8000075c:	f8843783          	ld	a5,-120(s0)
    80000760:	6390                	ld	a2,0(a5)
    if((pte & PTE_V) == 0){
    80000762:	00167793          	andi	a5,a2,1
    80000766:	dff9                	beqz	a5,80000744 <vmprint+0x92>
    pagetable_t l1pa = (pagetable_t) PTE2PA(pte);
    80000768:	00a65c13          	srli	s8,a2,0xa
    8000076c:	0c32                	slli	s8,s8,0xc
    printf(".. %p: pte %p pa %p\n", (void *)va, (void *)pte, (void *)l1pa);
    8000076e:	86e2                	mv	a3,s8
    80000770:	85ea                	mv	a1,s10
    80000772:	00008517          	auipc	a0,0x8
    80000776:	91e50513          	addi	a0,a0,-1762 # 80008090 <etext+0x90>
    8000077a:	212050ef          	jal	8000598c <printf>
    8000077e:	4b81                	li	s7,0
      printf(".. .. %p: pte %p pa %p\n", (void *)l1va, (void *)pte, (void *)l0pa);
    80000780:	00008d97          	auipc	s11,0x8
    80000784:	928d8d93          	addi	s11,s11,-1752 # 800080a8 <etext+0xa8>
    for(uint64 l1 = 0; l1 < 512; l1++){
    80000788:	40000cb7          	lui	s9,0x40000
    8000078c:	bf59                	j	80000722 <vmprint+0x70>
      }
    }
  }

}
    8000078e:	70e6                	ld	ra,120(sp)
    80000790:	7446                	ld	s0,112(sp)
    80000792:	74a6                	ld	s1,104(sp)
    80000794:	7906                	ld	s2,96(sp)
    80000796:	69e6                	ld	s3,88(sp)
    80000798:	6a46                	ld	s4,80(sp)
    8000079a:	6aa6                	ld	s5,72(sp)
    8000079c:	6b06                	ld	s6,64(sp)
    8000079e:	7be2                	ld	s7,56(sp)
    800007a0:	7c42                	ld	s8,48(sp)
    800007a2:	7ca2                	ld	s9,40(sp)
    800007a4:	7d02                	ld	s10,32(sp)
    800007a6:	6de2                	ld	s11,24(sp)
    800007a8:	6109                	addi	sp,sp,128
    800007aa:	8082                	ret

00000000800007ac <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() or superwalk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    800007ac:	711d                	addi	sp,sp,-96
    800007ae:	ec86                	sd	ra,88(sp)
    800007b0:	e8a2                	sd	s0,80(sp)
    800007b2:	1080                	addi	s0,sp,96
  uint64 a, last;
  pte_t *pte;
  int lvl;

  if((va % PGSIZE) != 0)
    800007b4:	03459793          	slli	a5,a1,0x34
    800007b8:	ebad                	bnez	a5,8000082a <mappages+0x7e>
    800007ba:	f852                	sd	s4,48(sp)
    800007bc:	f456                	sd	s5,40(sp)
    800007be:	8a2a                	mv	s4,a0
    800007c0:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    800007c2:	03461793          	slli	a5,a2,0x34
    800007c6:	e3c1                	bnez	a5,80000846 <mappages+0x9a>
    panic("mappages: size not aligned");

  if(size == 0)
    800007c8:	ca59                	beqz	a2,8000085e <mappages+0xb2>
    800007ca:	e4a6                	sd	s1,72(sp)
    800007cc:	e0ca                	sd	s2,64(sp)
    800007ce:	fc4e                	sd	s3,56(sp)
    800007d0:	f05a                	sd	s6,32(sp)
    800007d2:	ec5e                	sd	s7,24(sp)
    panic("mappages: size");

  // map super pages
  if ((size % SUPERPGSIZE) == 0 && size >= SUPERPGSIZE) {
    800007d4:	02b61793          	slli	a5,a2,0x2b
    800007d8:	e789                	bnez	a5,800007e2 <mappages+0x36>
    800007da:	002007b7          	lui	a5,0x200
    800007de:	08f67c63          	bgeu	a2,a5,80000876 <mappages+0xca>
    800007e2:	e862                	sd	s8,16(sp)
    }
    return 0;
  }
  
  a = va;
  last = va + size - PGSIZE;
    800007e4:	80060913          	addi	s2,a2,-2048 # 800 <_entry-0x7ffff800>
    800007e8:	80090913          	addi	s2,s2,-2048
    800007ec:	992e                	add	s2,s2,a1
  a = va;
    800007ee:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1, &lvl)) == 0)
    800007f0:	fac40b93          	addi	s7,s0,-84
    800007f4:	4b05                	li	s6,1
    800007f6:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    800007fa:	6c05                	lui	s8,0x1
    if((pte = walk(pagetable, a, 1, &lvl)) == 0)
    800007fc:	86de                	mv	a3,s7
    800007fe:	865a                	mv	a2,s6
    80000800:	85a6                	mv	a1,s1
    80000802:	8552                	mv	a0,s4
    80000804:	d2dff0ef          	jal	80000530 <walk>
    80000808:	c969                	beqz	a0,800008da <mappages+0x12e>
    if(*pte & PTE_V)
    8000080a:	611c                	ld	a5,0(a0)
    8000080c:	8b85                	andi	a5,a5,1
    8000080e:	efc5                	bnez	a5,800008c6 <mappages+0x11a>
    *pte = PA2PTE(pa) | perm | PTE_V;
    80000810:	013487b3          	add	a5,s1,s3
    80000814:	83b1                	srli	a5,a5,0xc
    80000816:	07aa                	slli	a5,a5,0xa
    80000818:	0157e7b3          	or	a5,a5,s5
    8000081c:	0017e793          	ori	a5,a5,1
    80000820:	e11c                	sd	a5,0(a0)
    if(a == last)
    80000822:	0d248963          	beq	s1,s2,800008f4 <mappages+0x148>
    a += PGSIZE;
    80000826:	94e2                	add	s1,s1,s8
    if((pte = walk(pagetable, a, 1, &lvl)) == 0)
    80000828:	bfd1                	j	800007fc <mappages+0x50>
    8000082a:	e4a6                	sd	s1,72(sp)
    8000082c:	e0ca                	sd	s2,64(sp)
    8000082e:	fc4e                	sd	s3,56(sp)
    80000830:	f852                	sd	s4,48(sp)
    80000832:	f456                	sd	s5,40(sp)
    80000834:	f05a                	sd	s6,32(sp)
    80000836:	ec5e                	sd	s7,24(sp)
    80000838:	e862                	sd	s8,16(sp)
    panic("mappages: va not aligned");
    8000083a:	00008517          	auipc	a0,0x8
    8000083e:	8a650513          	addi	a0,a0,-1882 # 800080e0 <etext+0xe0>
    80000842:	474050ef          	jal	80005cb6 <panic>
    80000846:	e4a6                	sd	s1,72(sp)
    80000848:	e0ca                	sd	s2,64(sp)
    8000084a:	fc4e                	sd	s3,56(sp)
    8000084c:	f05a                	sd	s6,32(sp)
    8000084e:	ec5e                	sd	s7,24(sp)
    80000850:	e862                	sd	s8,16(sp)
    panic("mappages: size not aligned");
    80000852:	00008517          	auipc	a0,0x8
    80000856:	8ae50513          	addi	a0,a0,-1874 # 80008100 <etext+0x100>
    8000085a:	45c050ef          	jal	80005cb6 <panic>
    8000085e:	e4a6                	sd	s1,72(sp)
    80000860:	e0ca                	sd	s2,64(sp)
    80000862:	fc4e                	sd	s3,56(sp)
    80000864:	f05a                	sd	s6,32(sp)
    80000866:	ec5e                	sd	s7,24(sp)
    80000868:	e862                	sd	s8,16(sp)
    panic("mappages: size");
    8000086a:	00008517          	auipc	a0,0x8
    8000086e:	8b650513          	addi	a0,a0,-1866 # 80008120 <etext+0x120>
    80000872:	444050ef          	jal	80005cb6 <panic>
    last = va + size - SUPERPGSIZE;
    80000876:	ffe007b7          	lui	a5,0xffe00
    8000087a:	00f60933          	add	s2,a2,a5
    8000087e:	992e                	add	s2,s2,a1
    a = va;
    80000880:	84ae                	mv	s1,a1
      if((pte = superwalk(pagetable, a, 1)) == 0)
    80000882:	4b05                	li	s6,1
    80000884:	40b689b3          	sub	s3,a3,a1
      a += SUPERPGSIZE;
    80000888:	00200bb7          	lui	s7,0x200
      if((pte = superwalk(pagetable, a, 1)) == 0)
    8000088c:	865a                	mv	a2,s6
    8000088e:	85a6                	mv	a1,s1
    80000890:	8552                	mv	a0,s4
    80000892:	d59ff0ef          	jal	800005ea <superwalk>
    80000896:	cd15                	beqz	a0,800008d2 <mappages+0x126>
      if(*pte & PTE_V) {
    80000898:	611c                	ld	a5,0(a0)
    8000089a:	8b85                	andi	a5,a5,1
    8000089c:	ef91                	bnez	a5,800008b8 <mappages+0x10c>
      *pte = PA2PTE(pa) | perm | PTE_V;
    8000089e:	013487b3          	add	a5,s1,s3
    800008a2:	83b1                	srli	a5,a5,0xc
    800008a4:	07aa                	slli	a5,a5,0xa
    800008a6:	0157e7b3          	or	a5,a5,s5
    800008aa:	0017e793          	ori	a5,a5,1
    800008ae:	e11c                	sd	a5,0(a0)
      if(a == last)
    800008b0:	03248363          	beq	s1,s2,800008d6 <mappages+0x12a>
      a += SUPERPGSIZE;
    800008b4:	94de                	add	s1,s1,s7
      if((pte = superwalk(pagetable, a, 1)) == 0)
    800008b6:	bfd9                	j	8000088c <mappages+0xe0>
    800008b8:	e862                	sd	s8,16(sp)
        panic("mappages: super remap");
    800008ba:	00008517          	auipc	a0,0x8
    800008be:	87650513          	addi	a0,a0,-1930 # 80008130 <etext+0x130>
    800008c2:	3f4050ef          	jal	80005cb6 <panic>
      panic("mappages: remap");
    800008c6:	00008517          	auipc	a0,0x8
    800008ca:	88250513          	addi	a0,a0,-1918 # 80008148 <etext+0x148>
    800008ce:	3e8050ef          	jal	80005cb6 <panic>
        return -1;
    800008d2:	557d                	li	a0,-1
    800008d4:	a029                	j	800008de <mappages+0x132>
    return 0;
    800008d6:	4501                	li	a0,0
    800008d8:	a019                	j	800008de <mappages+0x132>
      return -1;
    800008da:	557d                	li	a0,-1
    800008dc:	6c42                	ld	s8,16(sp)
    pa += PGSIZE;
  }
  return 0;
}
    800008de:	64a6                	ld	s1,72(sp)
    800008e0:	6906                	ld	s2,64(sp)
    800008e2:	79e2                	ld	s3,56(sp)
    800008e4:	7a42                	ld	s4,48(sp)
    800008e6:	7aa2                	ld	s5,40(sp)
    800008e8:	7b02                	ld	s6,32(sp)
    800008ea:	6be2                	ld	s7,24(sp)
    800008ec:	60e6                	ld	ra,88(sp)
    800008ee:	6446                	ld	s0,80(sp)
    800008f0:	6125                	addi	sp,sp,96
    800008f2:	8082                	ret
  return 0;
    800008f4:	4501                	li	a0,0
    800008f6:	6c42                	ld	s8,16(sp)
    800008f8:	b7dd                	j	800008de <mappages+0x132>

00000000800008fa <kvmmap>:
{
    800008fa:	1141                	addi	sp,sp,-16
    800008fc:	e406                	sd	ra,8(sp)
    800008fe:	e022                	sd	s0,0(sp)
    80000900:	0800                	addi	s0,sp,16
    80000902:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    80000904:	86b2                	mv	a3,a2
    80000906:	863e                	mv	a2,a5
    80000908:	ea5ff0ef          	jal	800007ac <mappages>
    8000090c:	e509                	bnez	a0,80000916 <kvmmap+0x1c>
}
    8000090e:	60a2                	ld	ra,8(sp)
    80000910:	6402                	ld	s0,0(sp)
    80000912:	0141                	addi	sp,sp,16
    80000914:	8082                	ret
    panic("kvmmap");
    80000916:	00008517          	auipc	a0,0x8
    8000091a:	84250513          	addi	a0,a0,-1982 # 80008158 <etext+0x158>
    8000091e:	398050ef          	jal	80005cb6 <panic>

0000000080000922 <kvmmake>:
{
    80000922:	1101                	addi	sp,sp,-32
    80000924:	ec06                	sd	ra,24(sp)
    80000926:	e822                	sd	s0,16(sp)
    80000928:	e426                	sd	s1,8(sp)
    8000092a:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    8000092c:	fa6ff0ef          	jal	800000d2 <kalloc>
    80000930:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    80000932:	6605                	lui	a2,0x1
    80000934:	4581                	li	a1,0
    80000936:	967ff0ef          	jal	8000029c <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000093a:	4719                	li	a4,6
    8000093c:	6685                	lui	a3,0x1
    8000093e:	10000637          	lui	a2,0x10000
    80000942:	85b2                	mv	a1,a2
    80000944:	8526                	mv	a0,s1
    80000946:	fb5ff0ef          	jal	800008fa <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    8000094a:	4719                	li	a4,6
    8000094c:	6685                	lui	a3,0x1
    8000094e:	10001637          	lui	a2,0x10001
    80000952:	85b2                	mv	a1,a2
    80000954:	8526                	mv	a0,s1
    80000956:	fa5ff0ef          	jal	800008fa <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    8000095a:	4719                	li	a4,6
    8000095c:	040006b7          	lui	a3,0x4000
    80000960:	0c000637          	lui	a2,0xc000
    80000964:	85b2                	mv	a1,a2
    80000966:	8526                	mv	a0,s1
    80000968:	f93ff0ef          	jal	800008fa <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    8000096c:	4729                	li	a4,10
    8000096e:	80007697          	auipc	a3,0x80007
    80000972:	69268693          	addi	a3,a3,1682 # 8000 <_entry-0x7fff8000>
    80000976:	4605                	li	a2,1
    80000978:	067e                	slli	a2,a2,0x1f
    8000097a:	85b2                	mv	a1,a2
    8000097c:	8526                	mv	a0,s1
    8000097e:	f7dff0ef          	jal	800008fa <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    80000982:	4719                	li	a4,6
    80000984:	00007697          	auipc	a3,0x7
    80000988:	67c68693          	addi	a3,a3,1660 # 80008000 <etext>
    8000098c:	47c5                	li	a5,17
    8000098e:	07ee                	slli	a5,a5,0x1b
    80000990:	40d786b3          	sub	a3,a5,a3
    80000994:	00007617          	auipc	a2,0x7
    80000998:	66c60613          	addi	a2,a2,1644 # 80008000 <etext>
    8000099c:	85b2                	mv	a1,a2
    8000099e:	8526                	mv	a0,s1
    800009a0:	f5bff0ef          	jal	800008fa <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800009a4:	4729                	li	a4,10
    800009a6:	6685                	lui	a3,0x1
    800009a8:	00006617          	auipc	a2,0x6
    800009ac:	65860613          	addi	a2,a2,1624 # 80007000 <_trampoline>
    800009b0:	040005b7          	lui	a1,0x4000
    800009b4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800009b6:	05b2                	slli	a1,a1,0xc
    800009b8:	8526                	mv	a0,s1
    800009ba:	f41ff0ef          	jal	800008fa <kvmmap>
  proc_mapstacks(kpgtbl);
    800009be:	8526                	mv	a0,s1
    800009c0:	007000ef          	jal	800011c6 <proc_mapstacks>
}
    800009c4:	8526                	mv	a0,s1
    800009c6:	60e2                	ld	ra,24(sp)
    800009c8:	6442                	ld	s0,16(sp)
    800009ca:	64a2                	ld	s1,8(sp)
    800009cc:	6105                	addi	sp,sp,32
    800009ce:	8082                	ret

00000000800009d0 <kvminit>:
{
    800009d0:	1141                	addi	sp,sp,-16
    800009d2:	e406                	sd	ra,8(sp)
    800009d4:	e022                	sd	s0,0(sp)
    800009d6:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800009d8:	f4bff0ef          	jal	80000922 <kvmmake>
    800009dc:	00008797          	auipc	a5,0x8
    800009e0:	00a7b623          	sd	a0,12(a5) # 800089e8 <kernel_pagetable>
}
    800009e4:	60a2                	ld	ra,8(sp)
    800009e6:	6402                	ld	s0,0(sp)
    800009e8:	0141                	addi	sp,sp,16
    800009ea:	8082                	ret

00000000800009ec <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800009ec:	1101                	addi	sp,sp,-32
    800009ee:	ec06                	sd	ra,24(sp)
    800009f0:	e822                	sd	s0,16(sp)
    800009f2:	e426                	sd	s1,8(sp)
    800009f4:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800009f6:	edcff0ef          	jal	800000d2 <kalloc>
    800009fa:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800009fc:	c509                	beqz	a0,80000a06 <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800009fe:	6605                	lui	a2,0x1
    80000a00:	4581                	li	a1,0
    80000a02:	89bff0ef          	jal	8000029c <memset>
  return pagetable;
}
    80000a06:	8526                	mv	a0,s1
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret

0000000080000a12 <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000a12:	7175                	addi	sp,sp,-144
    80000a14:	e506                	sd	ra,136(sp)
    80000a16:	e122                	sd	s0,128(sp)
    80000a18:	0900                	addi	s0,sp,144
  uint64 a;
  pte_t *pte;
  int sz = PGSIZE;
  int lvl;

  if((va % PGSIZE) != 0)
    80000a1a:	03459793          	slli	a5,a1,0x34
    80000a1e:	ef95                	bnez	a5,80000a5a <uvmunmap+0x48>
    80000a20:	f8ca                	sd	s2,112(sp)
    80000a22:	f4ce                	sd	s3,104(sp)
    80000a24:	ecd6                	sd	s5,88(sp)
    80000a26:	e4de                	sd	s7,72(sp)
    80000a28:	e0e2                	sd	s8,64(sp)
    80000a2a:	8aaa                	mv	s5,a0
    80000a2c:	892e                	mv	s2,a1
    80000a2e:	8c36                	mv	s8,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000a30:	0632                	slli	a2,a2,0xc
    80000a32:	00b609b3          	add	s3,a2,a1
  int sz = PGSIZE;
    80000a36:	6b85                	lui	s7,0x1
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000a38:	0d35fe63          	bgeu	a1,s3,80000b14 <uvmunmap+0x102>
    80000a3c:	fca6                	sd	s1,120(sp)
    80000a3e:	f0d2                	sd	s4,96(sp)
    80000a40:	e8da                	sd	s6,80(sp)
    80000a42:	fc66                	sd	s9,56(sp)
    80000a44:	f86a                	sd	s10,48(sp)
    80000a46:	f46e                	sd	s11,40(sp)
    if((pte = walk(pagetable, a, 0, &lvl)) == 0) // leaf page table entry allocated?
    80000a48:	f8c40b13          	addi	s6,s0,-116
      continue;
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
      continue;
    if(PTE_FLAGS(*pte) == PTE_V)
    80000a4c:	4a05                	li	s4,1
      panic("uvmunmap: not a leaf");
    if (lvl == 2) {
    80000a4e:	4d09                	li	s10,2
      sz = SUPERPGSIZE;
    }
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      if (lvl == 1) {
        uint64 v = SUPERPGROUNDDOWN(a);
    80000a50:	002007b7          	lui	a5,0x200
    80000a54:	fff78d93          	addi	s11,a5,-1 # 1fffff <_entry-0x7fe00001>
    80000a58:	aa31                	j	80000b74 <uvmunmap+0x162>
    80000a5a:	fca6                	sd	s1,120(sp)
    80000a5c:	f8ca                	sd	s2,112(sp)
    80000a5e:	f4ce                	sd	s3,104(sp)
    80000a60:	f0d2                	sd	s4,96(sp)
    80000a62:	ecd6                	sd	s5,88(sp)
    80000a64:	e8da                	sd	s6,80(sp)
    80000a66:	e4de                	sd	s7,72(sp)
    80000a68:	e0e2                	sd	s8,64(sp)
    80000a6a:	fc66                	sd	s9,56(sp)
    80000a6c:	f86a                	sd	s10,48(sp)
    80000a6e:	f46e                	sd	s11,40(sp)
    panic("uvmunmap: not aligned");
    80000a70:	00007517          	auipc	a0,0x7
    80000a74:	6f050513          	addi	a0,a0,1776 # 80008160 <etext+0x160>
    80000a78:	23e050ef          	jal	80005cb6 <panic>
      panic("uvmunmap: not a leaf");
    80000a7c:	00007517          	auipc	a0,0x7
    80000a80:	6fc50513          	addi	a0,a0,1788 # 80008178 <etext+0x178>
    80000a84:	232050ef          	jal	80005cb6 <panic>
      panic("uvmunmap: invalid PTE level");
    80000a88:	00007517          	auipc	a0,0x7
    80000a8c:	70850513          	addi	a0,a0,1800 # 80008190 <etext+0x190>
    80000a90:	226050ef          	jal	80005cb6 <panic>
          char *mem;
          uint flags;

          uint64 p = pa;

          flags = PTE_FLAGS(*pte);
    80000a94:	3ff57713          	andi	a4,a0,1023
    80000a98:	f6e43c23          	sd	a4,-136(s0)
          *pte = 0;
    80000a9c:	0004b023          	sd	zero,0(s1)
          // copy memory before the address a
          for (; v < a; v += PGSIZE) {
            if ((mem = kalloc()) == 0) {
              panic("uvmunmap: fail to demote superpage because of kalloc");
            }
            memmove(mem, (char*)p, PGSIZE);
    80000aa0:	40fc87b3          	sub	a5,s9,a5
    80000aa4:	00200737          	lui	a4,0x200
    80000aa8:	97ba                	add	a5,a5,a4
    80000aaa:	f6f43823          	sd	a5,-144(s0)
            if ((mem = kalloc()) == 0) {
    80000aae:	e24ff0ef          	jal	800000d2 <kalloc>
    80000ab2:	84aa                	mv	s1,a0
    80000ab4:	c91d                	beqz	a0,80000aea <uvmunmap+0xd8>
            memmove(mem, (char*)p, PGSIZE);
    80000ab6:	6605                	lui	a2,0x1
    80000ab8:	f7043783          	ld	a5,-144(s0)
    80000abc:	017785b3          	add	a1,a5,s7
    80000ac0:	83dff0ef          	jal	800002fc <memmove>

            if(mappages(pagetable, v, PGSIZE, (uint64)mem, flags) != 0){
    80000ac4:	f7843703          	ld	a4,-136(s0)
    80000ac8:	86a6                	mv	a3,s1
    80000aca:	6605                	lui	a2,0x1
    80000acc:	85de                	mv	a1,s7
    80000ace:	8556                	mv	a0,s5
    80000ad0:	cddff0ef          	jal	800007ac <mappages>
    80000ad4:	e10d                	bnez	a0,80000af6 <uvmunmap+0xe4>
          for (; v < a; v += PGSIZE) {
    80000ad6:	6785                	lui	a5,0x1
    80000ad8:	9bbe                	add	s7,s7,a5
    80000ada:	fd2beae3          	bltu	s7,s2,80000aae <uvmunmap+0x9c>
              kfree(mem);
              panic("uvmunmap: fail to demote superpage because of mappages");
            }
            p += PGSIZE;
          }
          superfree((void*)pa);
    80000ade:	8566                	mv	a0,s9
    80000ae0:	ea8ff0ef          	jal	80000188 <superfree>
      sz = SUPERPGSIZE;
    80000ae4:	00200bb7          	lui	s7,0x200
          continue;
    80000ae8:	a059                	j	80000b6e <uvmunmap+0x15c>
              panic("uvmunmap: fail to demote superpage because of kalloc");
    80000aea:	00007517          	auipc	a0,0x7
    80000aee:	6c650513          	addi	a0,a0,1734 # 800081b0 <etext+0x1b0>
    80000af2:	1c4050ef          	jal	80005cb6 <panic>
              kfree(mem);
    80000af6:	8526                	mv	a0,s1
    80000af8:	d24ff0ef          	jal	8000001c <kfree>
              panic("uvmunmap: fail to demote superpage because of mappages");
    80000afc:	00007517          	auipc	a0,0x7
    80000b00:	6ec50513          	addi	a0,a0,1772 # 800081e8 <etext+0x1e8>
    80000b04:	1b2050ef          	jal	80005cb6 <panic>
    80000b08:	74e6                	ld	s1,120(sp)
    80000b0a:	7a06                	ld	s4,96(sp)
    80000b0c:	6b46                	ld	s6,80(sp)
    80000b0e:	7ce2                	ld	s9,56(sp)
    80000b10:	7d42                	ld	s10,48(sp)
    80000b12:	7da2                	ld	s11,40(sp)
    80000b14:	7946                	ld	s2,112(sp)
    80000b16:	79a6                	ld	s3,104(sp)
    80000b18:	6ae6                	ld	s5,88(sp)
    80000b1a:	6ba6                	ld	s7,72(sp)
    80000b1c:	6c06                	ld	s8,64(sp)
        kfree((void*)pa);
      }
    }
    *pte = 0;
  }
}
    80000b1e:	60aa                	ld	ra,136(sp)
    80000b20:	640a                	ld	s0,128(sp)
    80000b22:	6149                	addi	sp,sp,144
    80000b24:	8082                	ret
      sz = SUPERPGSIZE;
    80000b26:	00200bb7          	lui	s7,0x200
    if(do_free){
    80000b2a:	040c0063          	beqz	s8,80000b6a <uvmunmap+0x158>
      uint64 pa = PTE2PA(*pte);
    80000b2e:	00a55c93          	srli	s9,a0,0xa
    80000b32:	0cb2                	slli	s9,s9,0xc
        uint64 v = SUPERPGROUNDDOWN(a);
    80000b34:	01b907b3          	add	a5,s2,s11
    80000b38:	ffe00737          	lui	a4,0xffe00
    80000b3c:	8ff9                	and	a5,a5,a4
    80000b3e:	00200737          	lui	a4,0x200
    80000b42:	40e78bb3          	sub	s7,a5,a4
        if (v < a && ((a - v) % SUPERPGSIZE) != 0) {
    80000b46:	012bf763          	bgeu	s7,s2,80000b54 <uvmunmap+0x142>
    80000b4a:	41790733          	sub	a4,s2,s7
    80000b4e:	01b77733          	and	a4,a4,s11
    80000b52:	f329                	bnez	a4,80000a94 <uvmunmap+0x82>
        superfree((void*)pa);
    80000b54:	8566                	mv	a0,s9
    80000b56:	e32ff0ef          	jal	80000188 <superfree>
      sz = SUPERPGSIZE;
    80000b5a:	00200bb7          	lui	s7,0x200
    80000b5e:	a031                	j	80000b6a <uvmunmap+0x158>
      uint64 pa = PTE2PA(*pte);
    80000b60:	8129                	srli	a0,a0,0xa
        kfree((void*)pa);
    80000b62:	0532                	slli	a0,a0,0xc
    80000b64:	cb8ff0ef          	jal	8000001c <kfree>
    sz = PGSIZE;
    80000b68:	6b85                	lui	s7,0x1
    *pte = 0;
    80000b6a:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += sz){
    80000b6e:	995e                	add	s2,s2,s7
    80000b70:	f9397ce3          	bgeu	s2,s3,80000b08 <uvmunmap+0xf6>
    if((pte = walk(pagetable, a, 0, &lvl)) == 0) // leaf page table entry allocated?
    80000b74:	86da                	mv	a3,s6
    80000b76:	4601                	li	a2,0
    80000b78:	85ca                	mv	a1,s2
    80000b7a:	8556                	mv	a0,s5
    80000b7c:	9b5ff0ef          	jal	80000530 <walk>
    80000b80:	84aa                	mv	s1,a0
    80000b82:	d575                	beqz	a0,80000b6e <uvmunmap+0x15c>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80000b84:	6108                	ld	a0,0(a0)
    80000b86:	00157793          	andi	a5,a0,1
    80000b8a:	d3f5                	beqz	a5,80000b6e <uvmunmap+0x15c>
    if(PTE_FLAGS(*pte) == PTE_V)
    80000b8c:	3ff57793          	andi	a5,a0,1023
    80000b90:	ef4786e3          	beq	a5,s4,80000a7c <uvmunmap+0x6a>
    if (lvl == 2) {
    80000b94:	f8c42783          	lw	a5,-116(s0)
    80000b98:	efa788e3          	beq	a5,s10,80000a88 <uvmunmap+0x76>
    if (lvl == 1) {
    80000b9c:	f94785e3          	beq	a5,s4,80000b26 <uvmunmap+0x114>
    sz = PGSIZE;
    80000ba0:	6b85                	lui	s7,0x1
    if(do_free){
    80000ba2:	fc0c04e3          	beqz	s8,80000b6a <uvmunmap+0x158>
    80000ba6:	bf6d                	j	80000b60 <uvmunmap+0x14e>

0000000080000ba8 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000ba8:	1101                	addi	sp,sp,-32
    80000baa:	ec06                	sd	ra,24(sp)
    80000bac:	e822                	sd	s0,16(sp)
    80000bae:	e426                	sd	s1,8(sp)
    80000bb0:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    80000bb2:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000bb4:	00b67d63          	bgeu	a2,a1,80000bce <uvmdealloc+0x26>
    80000bb8:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000bba:	6785                	lui	a5,0x1
    80000bbc:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000bbe:	00f60733          	add	a4,a2,a5
    80000bc2:	76fd                	lui	a3,0xfffff
    80000bc4:	8f75                	and	a4,a4,a3
    80000bc6:	97ae                	add	a5,a5,a1
    80000bc8:	8ff5                	and	a5,a5,a3
    80000bca:	00f76863          	bltu	a4,a5,80000bda <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    80000bce:	8526                	mv	a0,s1
    80000bd0:	60e2                	ld	ra,24(sp)
    80000bd2:	6442                	ld	s0,16(sp)
    80000bd4:	64a2                	ld	s1,8(sp)
    80000bd6:	6105                	addi	sp,sp,32
    80000bd8:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000bda:	8f99                	sub	a5,a5,a4
    80000bdc:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    80000bde:	4685                	li	a3,1
    80000be0:	0007861b          	sext.w	a2,a5
    80000be4:	85ba                	mv	a1,a4
    80000be6:	e2dff0ef          	jal	80000a12 <uvmunmap>
    80000bea:	b7d5                	j	80000bce <uvmdealloc+0x26>

0000000080000bec <uvmalloc>:
{
    80000bec:	711d                	addi	sp,sp,-96
    80000bee:	ec86                	sd	ra,88(sp)
    80000bf0:	e8a2                	sd	s0,80(sp)
    80000bf2:	e0ca                	sd	s2,64(sp)
    80000bf4:	1080                	addi	s0,sp,96
    return oldsz;
    80000bf6:	892e                	mv	s2,a1
  if(newsz < oldsz)
    80000bf8:	06b66e63          	bltu	a2,a1,80000c74 <uvmalloc+0x88>
    80000bfc:	e4a6                	sd	s1,72(sp)
    80000bfe:	fc4e                	sd	s3,56(sp)
    80000c00:	f05a                	sd	s6,32(sp)
    80000c02:	e06a                	sd	s10,0(sp)
    80000c04:	8b2a                	mv	s6,a0
    80000c06:	89b2                	mv	s3,a2
  oldsz = PGROUNDUP(oldsz);
    80000c08:	6785                	lui	a5,0x1
    80000c0a:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000c0c:	95be                	add	a1,a1,a5
    80000c0e:	77fd                	lui	a5,0xfffff
    80000c10:	00f5f4b3          	and	s1,a1,a5
    80000c14:	8d26                	mv	s10,s1
  for(a = oldsz; a < newsz; a += sz){
    80000c16:	12c4f063          	bgeu	s1,a2,80000d36 <uvmalloc+0x14a>
    80000c1a:	f852                	sd	s4,48(sp)
    80000c1c:	f456                	sd	s5,40(sp)
    80000c1e:	ec5e                	sd	s7,24(sp)
    80000c20:	e862                	sd	s8,16(sp)
    80000c22:	e466                	sd	s9,8(sp)
    if ((a % SUPERPGSIZE) == 0 &&     // address is two-megabyte-aligned?
    80000c24:	00200bb7          	lui	s7,0x200
    80000c28:	fffb8c13          	addi	s8,s7,-1 # 1fffff <_entry-0x7fe00001>
    memset(mem, 0, sz);
    80000c2c:	6a05                	lui	s4,0x1
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000c2e:	0126ea93          	ori	s5,a3,18
    80000c32:	a89d                	j	80000ca8 <uvmalloc+0xbc>
        uvmdealloc(pagetable, a, oldsz);
    80000c34:	866a                	mv	a2,s10
    80000c36:	85a6                	mv	a1,s1
    80000c38:	855a                	mv	a0,s6
    80000c3a:	f6fff0ef          	jal	80000ba8 <uvmdealloc>
        return 0;
    80000c3e:	64a6                	ld	s1,72(sp)
    80000c40:	79e2                	ld	s3,56(sp)
    80000c42:	7a42                	ld	s4,48(sp)
    80000c44:	7aa2                	ld	s5,40(sp)
    80000c46:	7b02                	ld	s6,32(sp)
    80000c48:	6be2                	ld	s7,24(sp)
    80000c4a:	6c42                	ld	s8,16(sp)
    80000c4c:	6ca2                	ld	s9,8(sp)
    80000c4e:	6d02                	ld	s10,0(sp)
    80000c50:	a015                	j	80000c74 <uvmalloc+0x88>
        superfree(mem);
    80000c52:	8566                	mv	a0,s9
    80000c54:	d34ff0ef          	jal	80000188 <superfree>
        uvmdealloc(pagetable, a, oldsz);
    80000c58:	866a                	mv	a2,s10
    80000c5a:	85a6                	mv	a1,s1
    80000c5c:	855a                	mv	a0,s6
    80000c5e:	f4bff0ef          	jal	80000ba8 <uvmdealloc>
        return 0;
    80000c62:	64a6                	ld	s1,72(sp)
    80000c64:	79e2                	ld	s3,56(sp)
    80000c66:	7a42                	ld	s4,48(sp)
    80000c68:	7aa2                	ld	s5,40(sp)
    80000c6a:	7b02                	ld	s6,32(sp)
    80000c6c:	6be2                	ld	s7,24(sp)
    80000c6e:	6c42                	ld	s8,16(sp)
    80000c70:	6ca2                	ld	s9,8(sp)
    80000c72:	6d02                	ld	s10,0(sp)
}
    80000c74:	854a                	mv	a0,s2
    80000c76:	60e6                	ld	ra,88(sp)
    80000c78:	6446                	ld	s0,80(sp)
    80000c7a:	6906                	ld	s2,64(sp)
    80000c7c:	6125                	addi	sp,sp,96
    80000c7e:	8082                	ret
    mem = kalloc();
    80000c80:	c52ff0ef          	jal	800000d2 <kalloc>
    80000c84:	892a                	mv	s2,a0
    if(mem == 0){
    80000c86:	c939                	beqz	a0,80000cdc <uvmalloc+0xf0>
    memset(mem, 0, sz);
    80000c88:	8652                	mv	a2,s4
    80000c8a:	4581                	li	a1,0
    80000c8c:	e10ff0ef          	jal	8000029c <memset>
    if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000c90:	8756                	mv	a4,s5
    80000c92:	86ca                	mv	a3,s2
    80000c94:	8652                	mv	a2,s4
    80000c96:	85a6                	mv	a1,s1
    80000c98:	855a                	mv	a0,s6
    80000c9a:	b13ff0ef          	jal	800007ac <mappages>
    80000c9e:	ed31                	bnez	a0,80000cfa <uvmalloc+0x10e>
    sz = PGSIZE;
    80000ca0:	87d2                	mv	a5,s4
  for(a = oldsz; a < newsz; a += sz){
    80000ca2:	94be                	add	s1,s1,a5
    80000ca4:	0734fe63          	bgeu	s1,s3,80000d20 <uvmalloc+0x134>
    if ((a % SUPERPGSIZE) == 0 &&     // address is two-megabyte-aligned?
    80000ca8:	0184f933          	and	s2,s1,s8
    80000cac:	fc091ae3          	bnez	s2,80000c80 <uvmalloc+0x94>
        (a + SUPERPGSIZE) <= newsz) { // full 2 MB fits?
    80000cb0:	017487b3          	add	a5,s1,s7
    if ((a % SUPERPGSIZE) == 0 &&     // address is two-megabyte-aligned?
    80000cb4:	fcf9e6e3          	bltu	s3,a5,80000c80 <uvmalloc+0x94>
      mem = superalloc();
    80000cb8:	c74ff0ef          	jal	8000012c <superalloc>
    80000cbc:	8caa                	mv	s9,a0
      if(mem == 0){
    80000cbe:	d93d                	beqz	a0,80000c34 <uvmalloc+0x48>
      memset(mem, 0, sz);
    80000cc0:	865e                	mv	a2,s7
    80000cc2:	4581                	li	a1,0
    80000cc4:	dd8ff0ef          	jal	8000029c <memset>
      if(mappages(pagetable, a, sz, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    80000cc8:	8756                	mv	a4,s5
    80000cca:	86e6                	mv	a3,s9
    80000ccc:	865e                	mv	a2,s7
    80000cce:	85a6                	mv	a1,s1
    80000cd0:	855a                	mv	a0,s6
    80000cd2:	adbff0ef          	jal	800007ac <mappages>
    80000cd6:	fd35                	bnez	a0,80000c52 <uvmalloc+0x66>
      sz = SUPERPGSIZE;
    80000cd8:	87de                	mv	a5,s7
    80000cda:	b7e1                	j	80000ca2 <uvmalloc+0xb6>
      uvmdealloc(pagetable, a, oldsz);
    80000cdc:	866a                	mv	a2,s10
    80000cde:	85a6                	mv	a1,s1
    80000ce0:	855a                	mv	a0,s6
    80000ce2:	ec7ff0ef          	jal	80000ba8 <uvmdealloc>
      return 0;
    80000ce6:	64a6                	ld	s1,72(sp)
    80000ce8:	79e2                	ld	s3,56(sp)
    80000cea:	7a42                	ld	s4,48(sp)
    80000cec:	7aa2                	ld	s5,40(sp)
    80000cee:	7b02                	ld	s6,32(sp)
    80000cf0:	6be2                	ld	s7,24(sp)
    80000cf2:	6c42                	ld	s8,16(sp)
    80000cf4:	6ca2                	ld	s9,8(sp)
    80000cf6:	6d02                	ld	s10,0(sp)
    80000cf8:	bfb5                	j	80000c74 <uvmalloc+0x88>
      kfree(mem);
    80000cfa:	854a                	mv	a0,s2
    80000cfc:	b20ff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000d00:	866a                	mv	a2,s10
    80000d02:	85a6                	mv	a1,s1
    80000d04:	855a                	mv	a0,s6
    80000d06:	ea3ff0ef          	jal	80000ba8 <uvmdealloc>
      return 0;
    80000d0a:	4901                	li	s2,0
    80000d0c:	64a6                	ld	s1,72(sp)
    80000d0e:	79e2                	ld	s3,56(sp)
    80000d10:	7a42                	ld	s4,48(sp)
    80000d12:	7aa2                	ld	s5,40(sp)
    80000d14:	7b02                	ld	s6,32(sp)
    80000d16:	6be2                	ld	s7,24(sp)
    80000d18:	6c42                	ld	s8,16(sp)
    80000d1a:	6ca2                	ld	s9,8(sp)
    80000d1c:	6d02                	ld	s10,0(sp)
    80000d1e:	bf99                	j	80000c74 <uvmalloc+0x88>
  return newsz;
    80000d20:	894e                	mv	s2,s3
    80000d22:	64a6                	ld	s1,72(sp)
    80000d24:	79e2                	ld	s3,56(sp)
    80000d26:	7a42                	ld	s4,48(sp)
    80000d28:	7aa2                	ld	s5,40(sp)
    80000d2a:	7b02                	ld	s6,32(sp)
    80000d2c:	6be2                	ld	s7,24(sp)
    80000d2e:	6c42                	ld	s8,16(sp)
    80000d30:	6ca2                	ld	s9,8(sp)
    80000d32:	6d02                	ld	s10,0(sp)
    80000d34:	b781                	j	80000c74 <uvmalloc+0x88>
    80000d36:	8932                	mv	s2,a2
    80000d38:	64a6                	ld	s1,72(sp)
    80000d3a:	79e2                	ld	s3,56(sp)
    80000d3c:	7b02                	ld	s6,32(sp)
    80000d3e:	6d02                	ld	s10,0(sp)
    80000d40:	bf15                	j	80000c74 <uvmalloc+0x88>

0000000080000d42 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000d42:	7179                	addi	sp,sp,-48
    80000d44:	f406                	sd	ra,40(sp)
    80000d46:	f022                	sd	s0,32(sp)
    80000d48:	ec26                	sd	s1,24(sp)
    80000d4a:	e84a                	sd	s2,16(sp)
    80000d4c:	e44e                	sd	s3,8(sp)
    80000d4e:	1800                	addi	s0,sp,48
    80000d50:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000d52:	84aa                	mv	s1,a0
    80000d54:	6905                	lui	s2,0x1
    80000d56:	992a                	add	s2,s2,a0
    80000d58:	a811                	j	80000d6c <freewalk+0x2a>
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      // backtrace();
      panic("freewalk: leaf");
    80000d5a:	00007517          	auipc	a0,0x7
    80000d5e:	4c650513          	addi	a0,a0,1222 # 80008220 <etext+0x220>
    80000d62:	755040ef          	jal	80005cb6 <panic>
  for(int i = 0; i < 512; i++){
    80000d66:	04a1                	addi	s1,s1,8
    80000d68:	03248163          	beq	s1,s2,80000d8a <freewalk+0x48>
    pte_t pte = pagetable[i];
    80000d6c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d6e:	0017f713          	andi	a4,a5,1
    80000d72:	db75                	beqz	a4,80000d66 <freewalk+0x24>
    80000d74:	00e7f713          	andi	a4,a5,14
    80000d78:	f36d                	bnez	a4,80000d5a <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    80000d7a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    80000d7c:	00c79513          	slli	a0,a5,0xc
    80000d80:	fc3ff0ef          	jal	80000d42 <freewalk>
      pagetable[i] = 0;
    80000d84:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000d88:	bff9                	j	80000d66 <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    80000d8a:	854e                	mv	a0,s3
    80000d8c:	a90ff0ef          	jal	8000001c <kfree>
}
    80000d90:	70a2                	ld	ra,40(sp)
    80000d92:	7402                	ld	s0,32(sp)
    80000d94:	64e2                	ld	s1,24(sp)
    80000d96:	6942                	ld	s2,16(sp)
    80000d98:	69a2                	ld	s3,8(sp)
    80000d9a:	6145                	addi	sp,sp,48
    80000d9c:	8082                	ret

0000000080000d9e <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    80000d9e:	1101                	addi	sp,sp,-32
    80000da0:	ec06                	sd	ra,24(sp)
    80000da2:	e822                	sd	s0,16(sp)
    80000da4:	e426                	sd	s1,8(sp)
    80000da6:	1000                	addi	s0,sp,32
    80000da8:	84aa                	mv	s1,a0
  if(sz > 0)
    80000daa:	e989                	bnez	a1,80000dbc <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    80000dac:	8526                	mv	a0,s1
    80000dae:	f95ff0ef          	jal	80000d42 <freewalk>
}
    80000db2:	60e2                	ld	ra,24(sp)
    80000db4:	6442                	ld	s0,16(sp)
    80000db6:	64a2                	ld	s1,8(sp)
    80000db8:	6105                	addi	sp,sp,32
    80000dba:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    80000dbc:	6785                	lui	a5,0x1
    80000dbe:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    80000dc0:	95be                	add	a1,a1,a5
    80000dc2:	4685                	li	a3,1
    80000dc4:	00c5d613          	srli	a2,a1,0xc
    80000dc8:	4581                	li	a1,0
    80000dca:	c49ff0ef          	jal	80000a12 <uvmunmap>
    80000dce:	bff9                	j	80000dac <uvmfree+0xe>

0000000080000dd0 <uvmcopy>:
  uint flags;
  char *mem;
  int szinc = PGSIZE;
  int lvl;

  for(i = 0; i < sz; i += szinc){
    80000dd0:	0e060763          	beqz	a2,80000ebe <uvmcopy+0xee>
{
    80000dd4:	7119                	addi	sp,sp,-128
    80000dd6:	fc86                	sd	ra,120(sp)
    80000dd8:	f8a2                	sd	s0,112(sp)
    80000dda:	f4a6                	sd	s1,104(sp)
    80000ddc:	f0ca                	sd	s2,96(sp)
    80000dde:	ecce                	sd	s3,88(sp)
    80000de0:	e8d2                	sd	s4,80(sp)
    80000de2:	e4d6                	sd	s5,72(sp)
    80000de4:	e0da                	sd	s6,64(sp)
    80000de6:	fc5e                	sd	s7,56(sp)
    80000de8:	f862                	sd	s8,48(sp)
    80000dea:	f466                	sd	s9,40(sp)
    80000dec:	f06a                	sd	s10,32(sp)
    80000dee:	ec6e                	sd	s11,24(sp)
    80000df0:	0100                	addi	s0,sp,128
    80000df2:	8a2a                	mv	s4,a0
    80000df4:	8bae                	mv	s7,a1
    80000df6:	89b2                	mv	s3,a2
  int szinc = PGSIZE;
    80000df8:	6905                	lui	s2,0x1
  for(i = 0; i < sz; i += szinc){
    80000dfa:	4481                	li	s1,0
    if((pte = walk(old, i, 0, &lvl)) == 0)
    80000dfc:	f8c40b13          	addi	s6,s0,-116
      continue;
    }
    szinc = PGSIZE;
    pa = PTE2PA(*pte);
    flags = PTE_FLAGS(*pte);
    if (lvl == 1) {
    80000e00:	4c05                	li	s8,1
        goto err;
      }
    } else {
      if((mem = kalloc()) == 0)
        goto err;
      memmove(mem, (char*)pa, PGSIZE);
    80000e02:	8aca                	mv	s5,s2
      memmove(mem, (char*)pa, SUPERPGSIZE);
    80000e04:	00200cb7          	lui	s9,0x200
    80000e08:	a02d                	j	80000e32 <uvmcopy+0x62>
      if((mem = superalloc()) == 0)
    80000e0a:	b22ff0ef          	jal	8000012c <superalloc>
    80000e0e:	8daa                	mv	s11,a0
    80000e10:	cd35                	beqz	a0,80000e8c <uvmcopy+0xbc>
      memmove(mem, (char*)pa, SUPERPGSIZE);
    80000e12:	8666                	mv	a2,s9
    80000e14:	85ea                	mv	a1,s10
    80000e16:	ce6ff0ef          	jal	800002fc <memmove>
      if(mappages(new, i, SUPERPGSIZE, (uint64)mem, flags) != 0){
    80000e1a:	874a                	mv	a4,s2
    80000e1c:	86ee                	mv	a3,s11
    80000e1e:	8666                	mv	a2,s9
    80000e20:	85a6                	mv	a1,s1
    80000e22:	855e                	mv	a0,s7
    80000e24:	989ff0ef          	jal	800007ac <mappages>
    80000e28:	e939                	bnez	a0,80000e7e <uvmcopy+0xae>
      szinc = SUPERPGSIZE;
    80000e2a:	8966                	mv	s2,s9
  for(i = 0; i < sz; i += szinc){
    80000e2c:	94ca                	add	s1,s1,s2
    80000e2e:	0934f663          	bgeu	s1,s3,80000eba <uvmcopy+0xea>
    if((pte = walk(old, i, 0, &lvl)) == 0)
    80000e32:	86da                	mv	a3,s6
    80000e34:	4601                	li	a2,0
    80000e36:	85a6                	mv	a1,s1
    80000e38:	8552                	mv	a0,s4
    80000e3a:	ef6ff0ef          	jal	80000530 <walk>
    80000e3e:	d57d                	beqz	a0,80000e2c <uvmcopy+0x5c>
    if((*pte & PTE_V) == 0) {
    80000e40:	6118                	ld	a4,0(a0)
    80000e42:	00177793          	andi	a5,a4,1
    80000e46:	d3fd                	beqz	a5,80000e2c <uvmcopy+0x5c>
    pa = PTE2PA(*pte);
    80000e48:	00a75d13          	srli	s10,a4,0xa
    80000e4c:	0d32                	slli	s10,s10,0xc
    flags = PTE_FLAGS(*pte);
    80000e4e:	3ff77913          	andi	s2,a4,1023
    if (lvl == 1) {
    80000e52:	f8c42783          	lw	a5,-116(s0)
    80000e56:	fb878ae3          	beq	a5,s8,80000e0a <uvmcopy+0x3a>
      if((mem = kalloc()) == 0)
    80000e5a:	a78ff0ef          	jal	800000d2 <kalloc>
    80000e5e:	8daa                	mv	s11,a0
    80000e60:	c515                	beqz	a0,80000e8c <uvmcopy+0xbc>
      memmove(mem, (char*)pa, PGSIZE);
    80000e62:	8656                	mv	a2,s5
    80000e64:	85ea                	mv	a1,s10
    80000e66:	c96ff0ef          	jal	800002fc <memmove>
      if(mappages(new, i, PGSIZE, (uint64)mem, flags) != 0){
    80000e6a:	874a                	mv	a4,s2
    80000e6c:	86ee                	mv	a3,s11
    80000e6e:	8656                	mv	a2,s5
    80000e70:	85a6                	mv	a1,s1
    80000e72:	855e                	mv	a0,s7
    80000e74:	939ff0ef          	jal	800007ac <mappages>
    80000e78:	e519                	bnez	a0,80000e86 <uvmcopy+0xb6>
    szinc = PGSIZE;
    80000e7a:	8956                	mv	s2,s5
    80000e7c:	bf45                	j	80000e2c <uvmcopy+0x5c>
        superfree(mem);
    80000e7e:	856e                	mv	a0,s11
    80000e80:	b08ff0ef          	jal	80000188 <superfree>
        goto err;
    80000e84:	a021                	j	80000e8c <uvmcopy+0xbc>
        kfree(mem);
    80000e86:	856e                	mv	a0,s11
    80000e88:	994ff0ef          	jal	8000001c <kfree>
    }
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000e8c:	4685                	li	a3,1
    80000e8e:	00c4d613          	srli	a2,s1,0xc
    80000e92:	4581                	li	a1,0
    80000e94:	855e                	mv	a0,s7
    80000e96:	b7dff0ef          	jal	80000a12 <uvmunmap>
  return -1;
    80000e9a:	557d                	li	a0,-1
}
    80000e9c:	70e6                	ld	ra,120(sp)
    80000e9e:	7446                	ld	s0,112(sp)
    80000ea0:	74a6                	ld	s1,104(sp)
    80000ea2:	7906                	ld	s2,96(sp)
    80000ea4:	69e6                	ld	s3,88(sp)
    80000ea6:	6a46                	ld	s4,80(sp)
    80000ea8:	6aa6                	ld	s5,72(sp)
    80000eaa:	6b06                	ld	s6,64(sp)
    80000eac:	7be2                	ld	s7,56(sp)
    80000eae:	7c42                	ld	s8,48(sp)
    80000eb0:	7ca2                	ld	s9,40(sp)
    80000eb2:	7d02                	ld	s10,32(sp)
    80000eb4:	6de2                	ld	s11,24(sp)
    80000eb6:	6109                	addi	sp,sp,128
    80000eb8:	8082                	ret
  return 0;
    80000eba:	4501                	li	a0,0
    80000ebc:	b7c5                	j	80000e9c <uvmcopy+0xcc>
    80000ebe:	4501                	li	a0,0
}
    80000ec0:	8082                	ret

0000000080000ec2 <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000ec2:	1101                	addi	sp,sp,-32
    80000ec4:	ec06                	sd	ra,24(sp)
    80000ec6:	e822                	sd	s0,16(sp)
    80000ec8:	1000                	addi	s0,sp,32
  pte_t *pte;
  int lvl;
  
  pte = walk(pagetable, va, 0, &lvl);
    80000eca:	fec40693          	addi	a3,s0,-20
    80000ece:	4601                	li	a2,0
    80000ed0:	e60ff0ef          	jal	80000530 <walk>
  if(pte == 0)
    80000ed4:	c901                	beqz	a0,80000ee4 <uvmclear+0x22>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000ed6:	611c                	ld	a5,0(a0)
    80000ed8:	9bbd                	andi	a5,a5,-17
    80000eda:	e11c                	sd	a5,0(a0)
}
    80000edc:	60e2                	ld	ra,24(sp)
    80000ede:	6442                	ld	s0,16(sp)
    80000ee0:	6105                	addi	sp,sp,32
    80000ee2:	8082                	ret
    panic("uvmclear");
    80000ee4:	00007517          	auipc	a0,0x7
    80000ee8:	34c50513          	addi	a0,a0,844 # 80008230 <etext+0x230>
    80000eec:	5cb040ef          	jal	80005cb6 <panic>

0000000080000ef0 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000ef0:	cac5                	beqz	a3,80000fa0 <copyinstr+0xb0>
{
    80000ef2:	715d                	addi	sp,sp,-80
    80000ef4:	e486                	sd	ra,72(sp)
    80000ef6:	e0a2                	sd	s0,64(sp)
    80000ef8:	fc26                	sd	s1,56(sp)
    80000efa:	f84a                	sd	s2,48(sp)
    80000efc:	f44e                	sd	s3,40(sp)
    80000efe:	f052                	sd	s4,32(sp)
    80000f00:	ec56                	sd	s5,24(sp)
    80000f02:	e85a                	sd	s6,16(sp)
    80000f04:	e45e                	sd	s7,8(sp)
    80000f06:	0880                	addi	s0,sp,80
    80000f08:	8aaa                	mv	s5,a0
    80000f0a:	84ae                	mv	s1,a1
    80000f0c:	8bb2                	mv	s7,a2
    80000f0e:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000f10:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000f12:	6a05                	lui	s4,0x1
    80000f14:	a82d                	j	80000f4e <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000f16:	00078023          	sb	zero,0(a5)
        got_null = 1;
    80000f1a:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000f1c:	0017c793          	xori	a5,a5,1
    80000f20:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000f24:	60a6                	ld	ra,72(sp)
    80000f26:	6406                	ld	s0,64(sp)
    80000f28:	74e2                	ld	s1,56(sp)
    80000f2a:	7942                	ld	s2,48(sp)
    80000f2c:	79a2                	ld	s3,40(sp)
    80000f2e:	7a02                	ld	s4,32(sp)
    80000f30:	6ae2                	ld	s5,24(sp)
    80000f32:	6b42                	ld	s6,16(sp)
    80000f34:	6ba2                	ld	s7,8(sp)
    80000f36:	6161                	addi	sp,sp,80
    80000f38:	8082                	ret
    80000f3a:	fff98713          	addi	a4,s3,-1 # 1fffff <_entry-0x7fe00001>
    80000f3e:	9726                	add	a4,a4,s1
      --max;
    80000f40:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80000f44:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000f48:	04e58463          	beq	a1,a4,80000f90 <copyinstr+0xa0>
{
    80000f4c:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80000f4e:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000f52:	85ca                	mv	a1,s2
    80000f54:	8556                	mv	a0,s5
    80000f56:	f1eff0ef          	jal	80000674 <walkaddr>
    if(pa0 == 0)
    80000f5a:	cd0d                	beqz	a0,80000f94 <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000f5c:	417906b3          	sub	a3,s2,s7
    80000f60:	96d2                	add	a3,a3,s4
    if(n > max)
    80000f62:	00d9f363          	bgeu	s3,a3,80000f68 <copyinstr+0x78>
    80000f66:	86ce                	mv	a3,s3
    while(n > 0){
    80000f68:	ca85                	beqz	a3,80000f98 <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80000f6a:	01750633          	add	a2,a0,s7
    80000f6e:	41260633          	sub	a2,a2,s2
    80000f72:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80000f74:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80000f76:	96a6                	add	a3,a3,s1
    80000f78:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000f7a:	00f60733          	add	a4,a2,a5
    80000f7e:	00074703          	lbu	a4,0(a4) # 200000 <_entry-0x7fe00000>
    80000f82:	db51                	beqz	a4,80000f16 <copyinstr+0x26>
        *dst = *p;
    80000f84:	00e78023          	sb	a4,0(a5)
      dst++;
    80000f88:	0785                	addi	a5,a5,1
    while(n > 0){
    80000f8a:	fed797e3          	bne	a5,a3,80000f78 <copyinstr+0x88>
    80000f8e:	b775                	j	80000f3a <copyinstr+0x4a>
    80000f90:	4781                	li	a5,0
    80000f92:	b769                	j	80000f1c <copyinstr+0x2c>
      return -1;
    80000f94:	557d                	li	a0,-1
    80000f96:	b779                	j	80000f24 <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80000f98:	6b85                	lui	s7,0x1
    80000f9a:	9bca                	add	s7,s7,s2
    80000f9c:	87a6                	mv	a5,s1
    80000f9e:	b77d                	j	80000f4c <copyinstr+0x5c>
  int got_null = 0;
    80000fa0:	4781                	li	a5,0
  if(got_null){
    80000fa2:	0017c793          	xori	a5,a5,1
    80000fa6:	40f0053b          	negw	a0,a5
}
    80000faa:	8082                	ret

0000000080000fac <ismapped>:
  }
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va) {
    80000fac:	1101                	addi	sp,sp,-32
    80000fae:	ec06                	sd	ra,24(sp)
    80000fb0:	e822                	sd	s0,16(sp)
    80000fb2:	1000                	addi	s0,sp,32
  int lvl;
  pte_t *pte = walk(pagetable, va, 0, &lvl);
    80000fb4:	fec40693          	addi	a3,s0,-20
    80000fb8:	4601                	li	a2,0
    80000fba:	d76ff0ef          	jal	80000530 <walk>
  if (pte == 0) {
    80000fbe:	c119                	beqz	a0,80000fc4 <ismapped+0x18>
    return 0;
  }
  if (*pte & PTE_V){
    80000fc0:	6108                	ld	a0,0(a0)
    80000fc2:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000fc4:	60e2                	ld	ra,24(sp)
    80000fc6:	6442                	ld	s0,16(sp)
    80000fc8:	6105                	addi	sp,sp,32
    80000fca:	8082                	ret

0000000080000fcc <vmfault>:
{
    80000fcc:	7179                	addi	sp,sp,-48
    80000fce:	f406                	sd	ra,40(sp)
    80000fd0:	f022                	sd	s0,32(sp)
    80000fd2:	e84a                	sd	s2,16(sp)
    80000fd4:	e44e                	sd	s3,8(sp)
    80000fd6:	1800                	addi	s0,sp,48
    80000fd8:	89aa                	mv	s3,a0
    80000fda:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80000fdc:	364000ef          	jal	80001340 <myproc>
  if (va >= p->sz)
    80000fe0:	653c                	ld	a5,72(a0)
    80000fe2:	00f96a63          	bltu	s2,a5,80000ff6 <vmfault+0x2a>
    return 0;
    80000fe6:	4981                	li	s3,0
}
    80000fe8:	854e                	mv	a0,s3
    80000fea:	70a2                	ld	ra,40(sp)
    80000fec:	7402                	ld	s0,32(sp)
    80000fee:	6942                	ld	s2,16(sp)
    80000ff0:	69a2                	ld	s3,8(sp)
    80000ff2:	6145                	addi	sp,sp,48
    80000ff4:	8082                	ret
    80000ff6:	ec26                	sd	s1,24(sp)
    80000ff8:	e052                	sd	s4,0(sp)
    80000ffa:	84aa                	mv	s1,a0
  va = PGROUNDDOWN(va);
    80000ffc:	77fd                	lui	a5,0xfffff
    80000ffe:	00f97a33          	and	s4,s2,a5
  if(ismapped(pagetable, va)) {
    80001002:	85d2                	mv	a1,s4
    80001004:	854e                	mv	a0,s3
    80001006:	fa7ff0ef          	jal	80000fac <ismapped>
    return 0;
    8000100a:	4981                	li	s3,0
  if(ismapped(pagetable, va)) {
    8000100c:	c501                	beqz	a0,80001014 <vmfault+0x48>
    8000100e:	64e2                	ld	s1,24(sp)
    80001010:	6a02                	ld	s4,0(sp)
    80001012:	bfd9                	j	80000fe8 <vmfault+0x1c>
  mem = (uint64) kalloc();
    80001014:	8beff0ef          	jal	800000d2 <kalloc>
    80001018:	892a                	mv	s2,a0
  if(mem == 0)
    8000101a:	c905                	beqz	a0,8000104a <vmfault+0x7e>
  mem = (uint64) kalloc();
    8000101c:	89aa                	mv	s3,a0
  memset((void *) mem, 0, PGSIZE);
    8000101e:	6605                	lui	a2,0x1
    80001020:	4581                	li	a1,0
    80001022:	a7aff0ef          	jal	8000029c <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80001026:	4759                	li	a4,22
    80001028:	86ca                	mv	a3,s2
    8000102a:	6605                	lui	a2,0x1
    8000102c:	85d2                	mv	a1,s4
    8000102e:	68a8                	ld	a0,80(s1)
    80001030:	f7cff0ef          	jal	800007ac <mappages>
    80001034:	e501                	bnez	a0,8000103c <vmfault+0x70>
    80001036:	64e2                	ld	s1,24(sp)
    80001038:	6a02                	ld	s4,0(sp)
    8000103a:	b77d                	j	80000fe8 <vmfault+0x1c>
    kfree((void *)mem);
    8000103c:	854a                	mv	a0,s2
    8000103e:	fdffe0ef          	jal	8000001c <kfree>
    return 0;
    80001042:	4981                	li	s3,0
    80001044:	64e2                	ld	s1,24(sp)
    80001046:	6a02                	ld	s4,0(sp)
    80001048:	b745                	j	80000fe8 <vmfault+0x1c>
    8000104a:	64e2                	ld	s1,24(sp)
    8000104c:	6a02                	ld	s4,0(sp)
    8000104e:	bf69                	j	80000fe8 <vmfault+0x1c>

0000000080001050 <copyout>:
  while(len > 0){
    80001050:	ced9                	beqz	a3,800010ee <copyout+0x9e>
{
    80001052:	7119                	addi	sp,sp,-128
    80001054:	fc86                	sd	ra,120(sp)
    80001056:	f8a2                	sd	s0,112(sp)
    80001058:	f4a6                	sd	s1,104(sp)
    8000105a:	f0ca                	sd	s2,96(sp)
    8000105c:	ecce                	sd	s3,88(sp)
    8000105e:	e8d2                	sd	s4,80(sp)
    80001060:	e4d6                	sd	s5,72(sp)
    80001062:	e0da                	sd	s6,64(sp)
    80001064:	fc5e                	sd	s7,56(sp)
    80001066:	f862                	sd	s8,48(sp)
    80001068:	f466                	sd	s9,40(sp)
    8000106a:	f06a                	sd	s10,32(sp)
    8000106c:	ec6e                	sd	s11,24(sp)
    8000106e:	0100                	addi	s0,sp,128
    80001070:	8baa                	mv	s7,a0
    80001072:	8a2e                	mv	s4,a1
    80001074:	8b32                	mv	s6,a2
    80001076:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80001078:	7d7d                	lui	s10,0xfffff
    if (va0 >= MAXVA)
    8000107a:	5cfd                	li	s9,-1
    8000107c:	01acdc93          	srli	s9,s9,0x1a
    if((pte = walk(pagetable, va0, 0, &lvl)) == 0) {
    80001080:	f8c40d93          	addi	s11,s0,-116
    n = PGSIZE - (dstva - va0);
    80001084:	6c05                	lui	s8,0x1
    80001086:	a005                	j	800010a6 <copyout+0x56>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80001088:	409a0533          	sub	a0,s4,s1
    8000108c:	0009061b          	sext.w	a2,s2
    80001090:	85da                	mv	a1,s6
    80001092:	954e                	add	a0,a0,s3
    80001094:	a68ff0ef          	jal	800002fc <memmove>
    len -= n;
    80001098:	412a8ab3          	sub	s5,s5,s2
    src += n;
    8000109c:	9b4a                	add	s6,s6,s2
    dstva = va0 + PGSIZE;
    8000109e:	01848a33          	add	s4,s1,s8
  while(len > 0){
    800010a2:	040a8463          	beqz	s5,800010ea <copyout+0x9a>
    va0 = PGROUNDDOWN(dstva);
    800010a6:	01aa74b3          	and	s1,s4,s10
    if (va0 >= MAXVA)
    800010aa:	049ce463          	bltu	s9,s1,800010f2 <copyout+0xa2>
    pa0 = walkaddr(pagetable, va0);
    800010ae:	85a6                	mv	a1,s1
    800010b0:	855e                	mv	a0,s7
    800010b2:	dc2ff0ef          	jal	80000674 <walkaddr>
    800010b6:	89aa                	mv	s3,a0
    if(pa0 == 0) {
    800010b8:	e901                	bnez	a0,800010c8 <copyout+0x78>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    800010ba:	4601                	li	a2,0
    800010bc:	85a6                	mv	a1,s1
    800010be:	855e                	mv	a0,s7
    800010c0:	f0dff0ef          	jal	80000fcc <vmfault>
    800010c4:	89aa                	mv	s3,a0
    800010c6:	c531                	beqz	a0,80001112 <copyout+0xc2>
    if((pte = walk(pagetable, va0, 0, &lvl)) == 0) {
    800010c8:	86ee                	mv	a3,s11
    800010ca:	4601                	li	a2,0
    800010cc:	85a6                	mv	a1,s1
    800010ce:	855e                	mv	a0,s7
    800010d0:	c60ff0ef          	jal	80000530 <walk>
    800010d4:	c129                	beqz	a0,80001116 <copyout+0xc6>
    if((*pte & PTE_W) == 0)
    800010d6:	611c                	ld	a5,0(a0)
    800010d8:	8b91                	andi	a5,a5,4
    800010da:	c3a1                	beqz	a5,8000111a <copyout+0xca>
    n = PGSIZE - (dstva - va0);
    800010dc:	41448933          	sub	s2,s1,s4
    800010e0:	9962                	add	s2,s2,s8
    if(n > len)
    800010e2:	fb2af3e3          	bgeu	s5,s2,80001088 <copyout+0x38>
    800010e6:	8956                	mv	s2,s5
    800010e8:	b745                	j	80001088 <copyout+0x38>
  return 0;
    800010ea:	4501                	li	a0,0
    800010ec:	a021                	j	800010f4 <copyout+0xa4>
    800010ee:	4501                	li	a0,0
}
    800010f0:	8082                	ret
      return -1;
    800010f2:	557d                	li	a0,-1
}
    800010f4:	70e6                	ld	ra,120(sp)
    800010f6:	7446                	ld	s0,112(sp)
    800010f8:	74a6                	ld	s1,104(sp)
    800010fa:	7906                	ld	s2,96(sp)
    800010fc:	69e6                	ld	s3,88(sp)
    800010fe:	6a46                	ld	s4,80(sp)
    80001100:	6aa6                	ld	s5,72(sp)
    80001102:	6b06                	ld	s6,64(sp)
    80001104:	7be2                	ld	s7,56(sp)
    80001106:	7c42                	ld	s8,48(sp)
    80001108:	7ca2                	ld	s9,40(sp)
    8000110a:	7d02                	ld	s10,32(sp)
    8000110c:	6de2                	ld	s11,24(sp)
    8000110e:	6109                	addi	sp,sp,128
    80001110:	8082                	ret
        return -1;
    80001112:	557d                	li	a0,-1
    80001114:	b7c5                	j	800010f4 <copyout+0xa4>
      return -1;
    80001116:	557d                	li	a0,-1
    80001118:	bff1                	j	800010f4 <copyout+0xa4>
      return -1;
    8000111a:	557d                	li	a0,-1
    8000111c:	bfe1                	j	800010f4 <copyout+0xa4>

000000008000111e <copyin>:
  while(len > 0){
    8000111e:	c6c9                	beqz	a3,800011a8 <copyin+0x8a>
{
    80001120:	715d                	addi	sp,sp,-80
    80001122:	e486                	sd	ra,72(sp)
    80001124:	e0a2                	sd	s0,64(sp)
    80001126:	fc26                	sd	s1,56(sp)
    80001128:	f84a                	sd	s2,48(sp)
    8000112a:	f44e                	sd	s3,40(sp)
    8000112c:	f052                	sd	s4,32(sp)
    8000112e:	ec56                	sd	s5,24(sp)
    80001130:	e85a                	sd	s6,16(sp)
    80001132:	e45e                	sd	s7,8(sp)
    80001134:	e062                	sd	s8,0(sp)
    80001136:	0880                	addi	s0,sp,80
    80001138:	8baa                	mv	s7,a0
    8000113a:	8aae                	mv	s5,a1
    8000113c:	8932                	mv	s2,a2
    8000113e:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80001140:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80001142:	6b05                	lui	s6,0x1
    80001144:	a035                	j	80001170 <copyin+0x52>
    80001146:	412984b3          	sub	s1,s3,s2
    8000114a:	94da                	add	s1,s1,s6
    if(n > len)
    8000114c:	009a7363          	bgeu	s4,s1,80001152 <copyin+0x34>
    80001150:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80001152:	413905b3          	sub	a1,s2,s3
    80001156:	0004861b          	sext.w	a2,s1
    8000115a:	95aa                	add	a1,a1,a0
    8000115c:	8556                	mv	a0,s5
    8000115e:	99eff0ef          	jal	800002fc <memmove>
    len -= n;
    80001162:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80001166:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80001168:	01698933          	add	s2,s3,s6
  while(len > 0){
    8000116c:	020a0163          	beqz	s4,8000118e <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80001170:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80001174:	85ce                	mv	a1,s3
    80001176:	855e                	mv	a0,s7
    80001178:	cfcff0ef          	jal	80000674 <walkaddr>
    if(pa0 == 0) {
    8000117c:	f569                	bnez	a0,80001146 <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    8000117e:	4601                	li	a2,0
    80001180:	85ce                	mv	a1,s3
    80001182:	855e                	mv	a0,s7
    80001184:	e49ff0ef          	jal	80000fcc <vmfault>
    80001188:	fd5d                	bnez	a0,80001146 <copyin+0x28>
        return -1;
    8000118a:	557d                	li	a0,-1
    8000118c:	a011                	j	80001190 <copyin+0x72>
  return 0;
    8000118e:	4501                	li	a0,0
}
    80001190:	60a6                	ld	ra,72(sp)
    80001192:	6406                	ld	s0,64(sp)
    80001194:	74e2                	ld	s1,56(sp)
    80001196:	7942                	ld	s2,48(sp)
    80001198:	79a2                	ld	s3,40(sp)
    8000119a:	7a02                	ld	s4,32(sp)
    8000119c:	6ae2                	ld	s5,24(sp)
    8000119e:	6b42                	ld	s6,16(sp)
    800011a0:	6ba2                	ld	s7,8(sp)
    800011a2:	6c02                	ld	s8,0(sp)
    800011a4:	6161                	addi	sp,sp,80
    800011a6:	8082                	ret
  return 0;
    800011a8:	4501                	li	a0,0
}
    800011aa:	8082                	ret

00000000800011ac <pgpte>:



#ifdef LAB_PGTBL
pte_t*
pgpte(pagetable_t pagetable, uint64 va) {
    800011ac:	1101                	addi	sp,sp,-32
    800011ae:	ec06                	sd	ra,24(sp)
    800011b0:	e822                	sd	s0,16(sp)
    800011b2:	1000                	addi	s0,sp,32
  int lvl;
  return walk(pagetable, va, 0, &lvl);
    800011b4:	fec40693          	addi	a3,s0,-20
    800011b8:	4601                	li	a2,0
    800011ba:	b76ff0ef          	jal	80000530 <walk>
}
    800011be:	60e2                	ld	ra,24(sp)
    800011c0:	6442                	ld	s0,16(sp)
    800011c2:	6105                	addi	sp,sp,32
    800011c4:	8082                	ret

00000000800011c6 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    800011c6:	715d                	addi	sp,sp,-80
    800011c8:	e486                	sd	ra,72(sp)
    800011ca:	e0a2                	sd	s0,64(sp)
    800011cc:	fc26                	sd	s1,56(sp)
    800011ce:	f84a                	sd	s2,48(sp)
    800011d0:	f44e                	sd	s3,40(sp)
    800011d2:	f052                	sd	s4,32(sp)
    800011d4:	ec56                	sd	s5,24(sp)
    800011d6:	e85a                	sd	s6,16(sp)
    800011d8:	e45e                	sd	s7,8(sp)
    800011da:	e062                	sd	s8,0(sp)
    800011dc:	0880                	addi	s0,sp,80
    800011de:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    800011e0:	00008497          	auipc	s1,0x8
    800011e4:	ca048493          	addi	s1,s1,-864 # 80008e80 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    800011e8:	8c26                	mv	s8,s1
    800011ea:	410417b7          	lui	a5,0x41041
    800011ee:	04078793          	addi	a5,a5,64 # 41041040 <_entry-0x3efbefc0>
    800011f2:	01e79993          	slli	s3,a5,0x1e
    800011f6:	99be                	add	s3,s3,a5
    800011f8:	fff9c993          	not	s3,s3
    800011fc:	01000937          	lui	s2,0x1000
    80001200:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    80001202:	093a                	slli	s2,s2,0xe
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001204:	4b99                	li	s7,6
    80001206:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80001208:	00010a97          	auipc	s5,0x10
    8000120c:	a78a8a93          	addi	s5,s5,-1416 # 80010c80 <tickslock>
    char *pa = kalloc();
    80001210:	ec3fe0ef          	jal	800000d2 <kalloc>
    80001214:	862a                	mv	a2,a0
    if(pa == 0)
    80001216:	cd1d                	beqz	a0,80001254 <proc_mapstacks+0x8e>
    uint64 va = KSTACK((int) (p - proc));
    80001218:	418485b3          	sub	a1,s1,s8
    8000121c:	858d                	srai	a1,a1,0x3
    8000121e:	033585b3          	mul	a1,a1,s3
    80001222:	00d5959b          	slliw	a1,a1,0xd
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80001226:	875e                	mv	a4,s7
    80001228:	86da                	mv	a3,s6
    8000122a:	40b905b3          	sub	a1,s2,a1
    8000122e:	8552                	mv	a0,s4
    80001230:	ecaff0ef          	jal	800008fa <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001234:	1f848493          	addi	s1,s1,504
    80001238:	fd549ce3          	bne	s1,s5,80001210 <proc_mapstacks+0x4a>
  }
}
    8000123c:	60a6                	ld	ra,72(sp)
    8000123e:	6406                	ld	s0,64(sp)
    80001240:	74e2                	ld	s1,56(sp)
    80001242:	7942                	ld	s2,48(sp)
    80001244:	79a2                	ld	s3,40(sp)
    80001246:	7a02                	ld	s4,32(sp)
    80001248:	6ae2                	ld	s5,24(sp)
    8000124a:	6b42                	ld	s6,16(sp)
    8000124c:	6ba2                	ld	s7,8(sp)
    8000124e:	6c02                	ld	s8,0(sp)
    80001250:	6161                	addi	sp,sp,80
    80001252:	8082                	ret
      panic("kalloc");
    80001254:	00007517          	auipc	a0,0x7
    80001258:	fec50513          	addi	a0,a0,-20 # 80008240 <etext+0x240>
    8000125c:	25b040ef          	jal	80005cb6 <panic>

0000000080001260 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80001260:	7139                	addi	sp,sp,-64
    80001262:	fc06                	sd	ra,56(sp)
    80001264:	f822                	sd	s0,48(sp)
    80001266:	f426                	sd	s1,40(sp)
    80001268:	f04a                	sd	s2,32(sp)
    8000126a:	ec4e                	sd	s3,24(sp)
    8000126c:	e852                	sd	s4,16(sp)
    8000126e:	e456                	sd	s5,8(sp)
    80001270:	e05a                	sd	s6,0(sp)
    80001272:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80001274:	00007597          	auipc	a1,0x7
    80001278:	fd458593          	addi	a1,a1,-44 # 80008248 <etext+0x248>
    8000127c:	00007517          	auipc	a0,0x7
    80001280:	7d450513          	addi	a0,a0,2004 # 80008a50 <pid_lock>
    80001284:	46b040ef          	jal	80005eee <initlock>
  initlock(&wait_lock, "wait_lock");
    80001288:	00007597          	auipc	a1,0x7
    8000128c:	fc858593          	addi	a1,a1,-56 # 80008250 <etext+0x250>
    80001290:	00007517          	auipc	a0,0x7
    80001294:	7d850513          	addi	a0,a0,2008 # 80008a68 <wait_lock>
    80001298:	457040ef          	jal	80005eee <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000129c:	00008497          	auipc	s1,0x8
    800012a0:	be448493          	addi	s1,s1,-1052 # 80008e80 <proc>
      initlock(&p->lock, "proc");
    800012a4:	00007a97          	auipc	s5,0x7
    800012a8:	fbca8a93          	addi	s5,s5,-68 # 80008260 <etext+0x260>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    800012ac:	8a26                	mv	s4,s1
    800012ae:	410417b7          	lui	a5,0x41041
    800012b2:	04078793          	addi	a5,a5,64 # 41041040 <_entry-0x3efbefc0>
    800012b6:	01e79993          	slli	s3,a5,0x1e
    800012ba:	99be                	add	s3,s3,a5
    800012bc:	fff9c993          	not	s3,s3
    800012c0:	01000937          	lui	s2,0x1000
    800012c4:	197d                	addi	s2,s2,-1 # ffffff <_entry-0x7f000001>
    800012c6:	093a                	slli	s2,s2,0xe
  for(p = proc; p < &proc[NPROC]; p++) {
    800012c8:	00010b17          	auipc	s6,0x10
    800012cc:	9b8b0b13          	addi	s6,s6,-1608 # 80010c80 <tickslock>
      initlock(&p->lock, "proc");
    800012d0:	85d6                	mv	a1,s5
    800012d2:	8526                	mv	a0,s1
    800012d4:	41b040ef          	jal	80005eee <initlock>
      p->state = UNUSED;
    800012d8:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    800012dc:	414487b3          	sub	a5,s1,s4
    800012e0:	878d                	srai	a5,a5,0x3
    800012e2:	033787b3          	mul	a5,a5,s3
    800012e6:	00d7979b          	slliw	a5,a5,0xd
    800012ea:	40f907b3          	sub	a5,s2,a5
    800012ee:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    800012f0:	1f848493          	addi	s1,s1,504
    800012f4:	fd649ee3          	bne	s1,s6,800012d0 <procinit+0x70>
  }
}
    800012f8:	70e2                	ld	ra,56(sp)
    800012fa:	7442                	ld	s0,48(sp)
    800012fc:	74a2                	ld	s1,40(sp)
    800012fe:	7902                	ld	s2,32(sp)
    80001300:	69e2                	ld	s3,24(sp)
    80001302:	6a42                	ld	s4,16(sp)
    80001304:	6aa2                	ld	s5,8(sp)
    80001306:	6b02                	ld	s6,0(sp)
    80001308:	6121                	addi	sp,sp,64
    8000130a:	8082                	ret

000000008000130c <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    8000130c:	1141                	addi	sp,sp,-16
    8000130e:	e406                	sd	ra,8(sp)
    80001310:	e022                	sd	s0,0(sp)
    80001312:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001314:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001316:	2501                	sext.w	a0,a0
    80001318:	60a2                	ld	ra,8(sp)
    8000131a:	6402                	ld	s0,0(sp)
    8000131c:	0141                	addi	sp,sp,16
    8000131e:	8082                	ret

0000000080001320 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    80001320:	1141                	addi	sp,sp,-16
    80001322:	e406                	sd	ra,8(sp)
    80001324:	e022                	sd	s0,0(sp)
    80001326:	0800                	addi	s0,sp,16
    80001328:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    8000132a:	2781                	sext.w	a5,a5
    8000132c:	079e                	slli	a5,a5,0x7
  return c;
}
    8000132e:	00007517          	auipc	a0,0x7
    80001332:	75250513          	addi	a0,a0,1874 # 80008a80 <cpus>
    80001336:	953e                	add	a0,a0,a5
    80001338:	60a2                	ld	ra,8(sp)
    8000133a:	6402                	ld	s0,0(sp)
    8000133c:	0141                	addi	sp,sp,16
    8000133e:	8082                	ret

0000000080001340 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    80001340:	1101                	addi	sp,sp,-32
    80001342:	ec06                	sd	ra,24(sp)
    80001344:	e822                	sd	s0,16(sp)
    80001346:	e426                	sd	s1,8(sp)
    80001348:	1000                	addi	s0,sp,32
  push_off();
    8000134a:	3eb040ef          	jal	80005f34 <push_off>
    8000134e:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    80001350:	2781                	sext.w	a5,a5
    80001352:	079e                	slli	a5,a5,0x7
    80001354:	00007717          	auipc	a4,0x7
    80001358:	6fc70713          	addi	a4,a4,1788 # 80008a50 <pid_lock>
    8000135c:	97ba                	add	a5,a5,a4
    8000135e:	7b9c                	ld	a5,48(a5)
    80001360:	84be                	mv	s1,a5
  pop_off();
    80001362:	45b040ef          	jal	80005fbc <pop_off>
  return p;
}
    80001366:	8526                	mv	a0,s1
    80001368:	60e2                	ld	ra,24(sp)
    8000136a:	6442                	ld	s0,16(sp)
    8000136c:	64a2                	ld	s1,8(sp)
    8000136e:	6105                	addi	sp,sp,32
    80001370:	8082                	ret

0000000080001372 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001372:	7179                	addi	sp,sp,-48
    80001374:	f406                	sd	ra,40(sp)
    80001376:	f022                	sd	s0,32(sp)
    80001378:	ec26                	sd	s1,24(sp)
    8000137a:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000137c:	fc5ff0ef          	jal	80001340 <myproc>
    80001380:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001382:	48b040ef          	jal	8000600c <release>

  if (first) {
    80001386:	00007797          	auipc	a5,0x7
    8000138a:	64a7a783          	lw	a5,1610(a5) # 800089d0 <first.1>
    8000138e:	cf95                	beqz	a5,800013ca <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    80001390:	4505                	li	a0,1
    80001392:	435010ef          	jal	80002fc6 <fsinit>

    first = 0;
    80001396:	00007797          	auipc	a5,0x7
    8000139a:	6207ad23          	sw	zero,1594(a5) # 800089d0 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000139e:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    800013a2:	00007797          	auipc	a5,0x7
    800013a6:	ec678793          	addi	a5,a5,-314 # 80008268 <etext+0x268>
    800013aa:	fcf43823          	sd	a5,-48(s0)
    800013ae:	fc043c23          	sd	zero,-40(s0)
    800013b2:	fd040593          	addi	a1,s0,-48
    800013b6:	853e                	mv	a0,a5
    800013b8:	58d020ef          	jal	80004144 <kexec>
    800013bc:	6cbc                	ld	a5,88(s1)
    800013be:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800013c0:	6cbc                	ld	a5,88(s1)
    800013c2:	7bb8                	ld	a4,112(a5)
    800013c4:	57fd                	li	a5,-1
    800013c6:	02f70d63          	beq	a4,a5,80001400 <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800013ca:	327000ef          	jal	80001ef0 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800013ce:	68a8                	ld	a0,80(s1)
    800013d0:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800013d2:	04000737          	lui	a4,0x4000
    800013d6:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800013d8:	0732                	slli	a4,a4,0xc
    800013da:	00006797          	auipc	a5,0x6
    800013de:	cc278793          	addi	a5,a5,-830 # 8000709c <userret>
    800013e2:	00006697          	auipc	a3,0x6
    800013e6:	c1e68693          	addi	a3,a3,-994 # 80007000 <_trampoline>
    800013ea:	8f95                	sub	a5,a5,a3
    800013ec:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800013ee:	577d                	li	a4,-1
    800013f0:	177e                	slli	a4,a4,0x3f
    800013f2:	8d59                	or	a0,a0,a4
    800013f4:	9782                	jalr	a5
}
    800013f6:	70a2                	ld	ra,40(sp)
    800013f8:	7402                	ld	s0,32(sp)
    800013fa:	64e2                	ld	s1,24(sp)
    800013fc:	6145                	addi	sp,sp,48
    800013fe:	8082                	ret
      panic("exec");
    80001400:	00007517          	auipc	a0,0x7
    80001404:	e7050513          	addi	a0,a0,-400 # 80008270 <etext+0x270>
    80001408:	0af040ef          	jal	80005cb6 <panic>

000000008000140c <allocpid>:
{
    8000140c:	1101                	addi	sp,sp,-32
    8000140e:	ec06                	sd	ra,24(sp)
    80001410:	e822                	sd	s0,16(sp)
    80001412:	e426                	sd	s1,8(sp)
    80001414:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001416:	00007517          	auipc	a0,0x7
    8000141a:	63a50513          	addi	a0,a0,1594 # 80008a50 <pid_lock>
    8000141e:	35b040ef          	jal	80005f78 <acquire>
  pid = nextpid;
    80001422:	00007797          	auipc	a5,0x7
    80001426:	5b278793          	addi	a5,a5,1458 # 800089d4 <nextpid>
    8000142a:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000142c:	0014871b          	addiw	a4,s1,1
    80001430:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001432:	00007517          	auipc	a0,0x7
    80001436:	61e50513          	addi	a0,a0,1566 # 80008a50 <pid_lock>
    8000143a:	3d3040ef          	jal	8000600c <release>
}
    8000143e:	8526                	mv	a0,s1
    80001440:	60e2                	ld	ra,24(sp)
    80001442:	6442                	ld	s0,16(sp)
    80001444:	64a2                	ld	s1,8(sp)
    80001446:	6105                	addi	sp,sp,32
    80001448:	8082                	ret

000000008000144a <proc_pagetable>:
{
    8000144a:	1101                	addi	sp,sp,-32
    8000144c:	ec06                	sd	ra,24(sp)
    8000144e:	e822                	sd	s0,16(sp)
    80001450:	e426                	sd	s1,8(sp)
    80001452:	e04a                	sd	s2,0(sp)
    80001454:	1000                	addi	s0,sp,32
    80001456:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001458:	d94ff0ef          	jal	800009ec <uvmcreate>
    8000145c:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000145e:	c929                	beqz	a0,800014b0 <proc_pagetable+0x66>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    80001460:	4729                	li	a4,10
    80001462:	00006697          	auipc	a3,0x6
    80001466:	b9e68693          	addi	a3,a3,-1122 # 80007000 <_trampoline>
    8000146a:	6605                	lui	a2,0x1
    8000146c:	040005b7          	lui	a1,0x4000
    80001470:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001472:	05b2                	slli	a1,a1,0xc
    80001474:	b38ff0ef          	jal	800007ac <mappages>
    80001478:	04054363          	bltz	a0,800014be <proc_pagetable+0x74>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000147c:	4719                	li	a4,6
    8000147e:	05893683          	ld	a3,88(s2)
    80001482:	6605                	lui	a2,0x1
    80001484:	020005b7          	lui	a1,0x2000
    80001488:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    8000148a:	05b6                	slli	a1,a1,0xd
    8000148c:	8526                	mv	a0,s1
    8000148e:	b1eff0ef          	jal	800007ac <mappages>
    80001492:	02054c63          	bltz	a0,800014ca <proc_pagetable+0x80>
  if(mappages(pagetable, USYSCALL, PGSIZE,
    80001496:	4749                	li	a4,18
    80001498:	06093683          	ld	a3,96(s2)
    8000149c:	6605                	lui	a2,0x1
    8000149e:	040005b7          	lui	a1,0x4000
    800014a2:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    800014a4:	05b2                	slli	a1,a1,0xc
    800014a6:	8526                	mv	a0,s1
    800014a8:	b04ff0ef          	jal	800007ac <mappages>
    800014ac:	02054e63          	bltz	a0,800014e8 <proc_pagetable+0x9e>
}
    800014b0:	8526                	mv	a0,s1
    800014b2:	60e2                	ld	ra,24(sp)
    800014b4:	6442                	ld	s0,16(sp)
    800014b6:	64a2                	ld	s1,8(sp)
    800014b8:	6902                	ld	s2,0(sp)
    800014ba:	6105                	addi	sp,sp,32
    800014bc:	8082                	ret
    uvmfree(pagetable, 0);
    800014be:	4581                	li	a1,0
    800014c0:	8526                	mv	a0,s1
    800014c2:	8ddff0ef          	jal	80000d9e <uvmfree>
    return 0;
    800014c6:	4481                	li	s1,0
    800014c8:	b7e5                	j	800014b0 <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800014ca:	4681                	li	a3,0
    800014cc:	4605                	li	a2,1
    800014ce:	040005b7          	lui	a1,0x4000
    800014d2:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800014d4:	05b2                	slli	a1,a1,0xc
    800014d6:	8526                	mv	a0,s1
    800014d8:	d3aff0ef          	jal	80000a12 <uvmunmap>
    uvmfree(pagetable, 0);
    800014dc:	4581                	li	a1,0
    800014de:	8526                	mv	a0,s1
    800014e0:	8bfff0ef          	jal	80000d9e <uvmfree>
    return 0;
    800014e4:	4481                	li	s1,0
    800014e6:	b7e9                	j	800014b0 <proc_pagetable+0x66>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800014e8:	4681                	li	a3,0
    800014ea:	4605                	li	a2,1
    800014ec:	040005b7          	lui	a1,0x4000
    800014f0:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800014f2:	05b2                	slli	a1,a1,0xc
    800014f4:	8526                	mv	a0,s1
    800014f6:	d1cff0ef          	jal	80000a12 <uvmunmap>
    uvmfree(pagetable, 0);
    800014fa:	4581                	li	a1,0
    800014fc:	8526                	mv	a0,s1
    800014fe:	8a1ff0ef          	jal	80000d9e <uvmfree>
    return 0;
    80001502:	4481                	li	s1,0
    80001504:	b775                	j	800014b0 <proc_pagetable+0x66>

0000000080001506 <proc_freepagetable>:
{
    80001506:	1101                	addi	sp,sp,-32
    80001508:	ec06                	sd	ra,24(sp)
    8000150a:	e822                	sd	s0,16(sp)
    8000150c:	e426                	sd	s1,8(sp)
    8000150e:	e04a                	sd	s2,0(sp)
    80001510:	1000                	addi	s0,sp,32
    80001512:	84aa                	mv	s1,a0
    80001514:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80001516:	4681                	li	a3,0
    80001518:	4605                	li	a2,1
    8000151a:	040005b7          	lui	a1,0x4000
    8000151e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001520:	05b2                	slli	a1,a1,0xc
    80001522:	cf0ff0ef          	jal	80000a12 <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80001526:	4681                	li	a3,0
    80001528:	4605                	li	a2,1
    8000152a:	020005b7          	lui	a1,0x2000
    8000152e:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001530:	05b6                	slli	a1,a1,0xd
    80001532:	8526                	mv	a0,s1
    80001534:	cdeff0ef          	jal	80000a12 <uvmunmap>
  uvmunmap(pagetable, USYSCALL, 1, 0);
    80001538:	4681                	li	a3,0
    8000153a:	4605                	li	a2,1
    8000153c:	040005b7          	lui	a1,0x4000
    80001540:	15f5                	addi	a1,a1,-3 # 3fffffd <_entry-0x7c000003>
    80001542:	05b2                	slli	a1,a1,0xc
    80001544:	8526                	mv	a0,s1
    80001546:	cccff0ef          	jal	80000a12 <uvmunmap>
  uvmfree(pagetable, sz);
    8000154a:	85ca                	mv	a1,s2
    8000154c:	8526                	mv	a0,s1
    8000154e:	851ff0ef          	jal	80000d9e <uvmfree>
}
    80001552:	60e2                	ld	ra,24(sp)
    80001554:	6442                	ld	s0,16(sp)
    80001556:	64a2                	ld	s1,8(sp)
    80001558:	6902                	ld	s2,0(sp)
    8000155a:	6105                	addi	sp,sp,32
    8000155c:	8082                	ret

000000008000155e <freeproc>:
{
    8000155e:	1101                	addi	sp,sp,-32
    80001560:	ec06                	sd	ra,24(sp)
    80001562:	e822                	sd	s0,16(sp)
    80001564:	e426                	sd	s1,8(sp)
    80001566:	1000                	addi	s0,sp,32
    80001568:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000156a:	6d28                	ld	a0,88(a0)
    8000156c:	c119                	beqz	a0,80001572 <freeproc+0x14>
    kfree((void*)p->trapframe);
    8000156e:	aaffe0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80001572:	0404bc23          	sd	zero,88(s1)
  if(p->usyscall)
    80001576:	70a8                	ld	a0,96(s1)
    80001578:	c119                	beqz	a0,8000157e <freeproc+0x20>
    kfree((void*)p->usyscall);
    8000157a:	aa3fe0ef          	jal	8000001c <kfree>
  p->usyscall = 0;
    8000157e:	0604b023          	sd	zero,96(s1)
  if(p->pagetable)
    80001582:	68a8                	ld	a0,80(s1)
    80001584:	c501                	beqz	a0,8000158c <freeproc+0x2e>
    proc_freepagetable(p->pagetable, p->sz);
    80001586:	64ac                	ld	a1,72(s1)
    80001588:	f7fff0ef          	jal	80001506 <proc_freepagetable>
  p->pagetable = 0;
    8000158c:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001590:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    80001594:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001598:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    8000159c:	16048023          	sb	zero,352(s1)
  p->chan = 0;
    800015a0:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    800015a4:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    800015a8:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    800015ac:	0004ac23          	sw	zero,24(s1)
}
    800015b0:	60e2                	ld	ra,24(sp)
    800015b2:	6442                	ld	s0,16(sp)
    800015b4:	64a2                	ld	s1,8(sp)
    800015b6:	6105                	addi	sp,sp,32
    800015b8:	8082                	ret

00000000800015ba <allocproc>:
{
    800015ba:	1101                	addi	sp,sp,-32
    800015bc:	ec06                	sd	ra,24(sp)
    800015be:	e822                	sd	s0,16(sp)
    800015c0:	e426                	sd	s1,8(sp)
    800015c2:	e04a                	sd	s2,0(sp)
    800015c4:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    800015c6:	00008497          	auipc	s1,0x8
    800015ca:	8ba48493          	addi	s1,s1,-1862 # 80008e80 <proc>
    800015ce:	0000f917          	auipc	s2,0xf
    800015d2:	6b290913          	addi	s2,s2,1714 # 80010c80 <tickslock>
    acquire(&p->lock);
    800015d6:	8526                	mv	a0,s1
    800015d8:	1a1040ef          	jal	80005f78 <acquire>
    if(p->state == UNUSED) {
    800015dc:	4c9c                	lw	a5,24(s1)
    800015de:	cb91                	beqz	a5,800015f2 <allocproc+0x38>
      release(&p->lock);
    800015e0:	8526                	mv	a0,s1
    800015e2:	22b040ef          	jal	8000600c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800015e6:	1f848493          	addi	s1,s1,504
    800015ea:	ff2496e3          	bne	s1,s2,800015d6 <allocproc+0x1c>
  return 0;
    800015ee:	4481                	li	s1,0
    800015f0:	a889                	j	80001642 <allocproc+0x88>
  p->pid = allocpid();
    800015f2:	e1bff0ef          	jal	8000140c <allocpid>
    800015f6:	d888                	sw	a0,48(s1)
  p->state = USED;
    800015f8:	4785                	li	a5,1
    800015fa:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    800015fc:	ad7fe0ef          	jal	800000d2 <kalloc>
    80001600:	892a                	mv	s2,a0
    80001602:	eca8                	sd	a0,88(s1)
    80001604:	c531                	beqz	a0,80001650 <allocproc+0x96>
  if((p->usyscall = (struct usyscall *)kalloc()) == 0){
    80001606:	acdfe0ef          	jal	800000d2 <kalloc>
    8000160a:	892a                	mv	s2,a0
    8000160c:	f0a8                	sd	a0,96(s1)
    8000160e:	c929                	beqz	a0,80001660 <allocproc+0xa6>
  p->pagetable = proc_pagetable(p);
    80001610:	8526                	mv	a0,s1
    80001612:	e39ff0ef          	jal	8000144a <proc_pagetable>
    80001616:	892a                	mv	s2,a0
    80001618:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    8000161a:	c939                	beqz	a0,80001670 <allocproc+0xb6>
  p->usyscall->pid = p->pid;
    8000161c:	70bc                	ld	a5,96(s1)
    8000161e:	5898                	lw	a4,48(s1)
    80001620:	c398                	sw	a4,0(a5)
  memset(&p->context, 0, sizeof(p->context));
    80001622:	07000613          	li	a2,112
    80001626:	4581                	li	a1,0
    80001628:	06848513          	addi	a0,s1,104
    8000162c:	c71fe0ef          	jal	8000029c <memset>
  p->context.ra = (uint64)forkret;
    80001630:	00000797          	auipc	a5,0x0
    80001634:	d4278793          	addi	a5,a5,-702 # 80001372 <forkret>
    80001638:	f4bc                	sd	a5,104(s1)
  p->context.sp = p->kstack + PGSIZE;
    8000163a:	60bc                	ld	a5,64(s1)
    8000163c:	6705                	lui	a4,0x1
    8000163e:	97ba                	add	a5,a5,a4
    80001640:	f8bc                	sd	a5,112(s1)
}
    80001642:	8526                	mv	a0,s1
    80001644:	60e2                	ld	ra,24(sp)
    80001646:	6442                	ld	s0,16(sp)
    80001648:	64a2                	ld	s1,8(sp)
    8000164a:	6902                	ld	s2,0(sp)
    8000164c:	6105                	addi	sp,sp,32
    8000164e:	8082                	ret
    freeproc(p);
    80001650:	8526                	mv	a0,s1
    80001652:	f0dff0ef          	jal	8000155e <freeproc>
    release(&p->lock);
    80001656:	8526                	mv	a0,s1
    80001658:	1b5040ef          	jal	8000600c <release>
    return 0;
    8000165c:	84ca                	mv	s1,s2
    8000165e:	b7d5                	j	80001642 <allocproc+0x88>
    freeproc(p);
    80001660:	8526                	mv	a0,s1
    80001662:	efdff0ef          	jal	8000155e <freeproc>
    release(&p->lock);
    80001666:	8526                	mv	a0,s1
    80001668:	1a5040ef          	jal	8000600c <release>
    return 0;
    8000166c:	84ca                	mv	s1,s2
    8000166e:	bfd1                	j	80001642 <allocproc+0x88>
    freeproc(p);
    80001670:	8526                	mv	a0,s1
    80001672:	eedff0ef          	jal	8000155e <freeproc>
    release(&p->lock);
    80001676:	8526                	mv	a0,s1
    80001678:	195040ef          	jal	8000600c <release>
    return 0;
    8000167c:	84ca                	mv	s1,s2
    8000167e:	b7d1                	j	80001642 <allocproc+0x88>

0000000080001680 <userinit>:
{
    80001680:	1101                	addi	sp,sp,-32
    80001682:	ec06                	sd	ra,24(sp)
    80001684:	e822                	sd	s0,16(sp)
    80001686:	e426                	sd	s1,8(sp)
    80001688:	1000                	addi	s0,sp,32
  p = allocproc();
    8000168a:	f31ff0ef          	jal	800015ba <allocproc>
    8000168e:	84aa                	mv	s1,a0
  initproc = p;
    80001690:	00007797          	auipc	a5,0x7
    80001694:	36a7b023          	sd	a0,864(a5) # 800089f0 <initproc>
  p->cwd = namei("/");
    80001698:	00007517          	auipc	a0,0x7
    8000169c:	be050513          	addi	a0,a0,-1056 # 80008278 <etext+0x278>
    800016a0:	661010ef          	jal	80003500 <namei>
    800016a4:	14a4bc23          	sd	a0,344(s1)
  p->state = RUNNABLE;
    800016a8:	478d                	li	a5,3
    800016aa:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    800016ac:	8526                	mv	a0,s1
    800016ae:	15f040ef          	jal	8000600c <release>
}
    800016b2:	60e2                	ld	ra,24(sp)
    800016b4:	6442                	ld	s0,16(sp)
    800016b6:	64a2                	ld	s1,8(sp)
    800016b8:	6105                	addi	sp,sp,32
    800016ba:	8082                	ret

00000000800016bc <growproc>:
{
    800016bc:	1101                	addi	sp,sp,-32
    800016be:	ec06                	sd	ra,24(sp)
    800016c0:	e822                	sd	s0,16(sp)
    800016c2:	e426                	sd	s1,8(sp)
    800016c4:	e04a                	sd	s2,0(sp)
    800016c6:	1000                	addi	s0,sp,32
    800016c8:	892a                	mv	s2,a0
  struct proc *p = myproc();
    800016ca:	c77ff0ef          	jal	80001340 <myproc>
    800016ce:	84aa                	mv	s1,a0
  sz = p->sz;
    800016d0:	652c                	ld	a1,72(a0)
  if(n > 0){
    800016d2:	01204c63          	bgtz	s2,800016ea <growproc+0x2e>
  } else if(n < 0){
    800016d6:	02094463          	bltz	s2,800016fe <growproc+0x42>
  p->sz = sz;
    800016da:	e4ac                	sd	a1,72(s1)
  return 0;
    800016dc:	4501                	li	a0,0
}
    800016de:	60e2                	ld	ra,24(sp)
    800016e0:	6442                	ld	s0,16(sp)
    800016e2:	64a2                	ld	s1,8(sp)
    800016e4:	6902                	ld	s2,0(sp)
    800016e6:	6105                	addi	sp,sp,32
    800016e8:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    800016ea:	4691                	li	a3,4
    800016ec:	00b90633          	add	a2,s2,a1
    800016f0:	6928                	ld	a0,80(a0)
    800016f2:	cfaff0ef          	jal	80000bec <uvmalloc>
    800016f6:	85aa                	mv	a1,a0
    800016f8:	f16d                	bnez	a0,800016da <growproc+0x1e>
      return -1;
    800016fa:	557d                	li	a0,-1
    800016fc:	b7cd                	j	800016de <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    800016fe:	00b90633          	add	a2,s2,a1
    80001702:	6928                	ld	a0,80(a0)
    80001704:	ca4ff0ef          	jal	80000ba8 <uvmdealloc>
    80001708:	85aa                	mv	a1,a0
    8000170a:	bfc1                	j	800016da <growproc+0x1e>

000000008000170c <kfork>:
{
    8000170c:	7139                	addi	sp,sp,-64
    8000170e:	fc06                	sd	ra,56(sp)
    80001710:	f822                	sd	s0,48(sp)
    80001712:	f426                	sd	s1,40(sp)
    80001714:	e456                	sd	s5,8(sp)
    80001716:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001718:	c29ff0ef          	jal	80001340 <myproc>
    8000171c:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    8000171e:	e9dff0ef          	jal	800015ba <allocproc>
    80001722:	0e050a63          	beqz	a0,80001816 <kfork+0x10a>
    80001726:	e852                	sd	s4,16(sp)
    80001728:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    8000172a:	048ab603          	ld	a2,72(s5)
    8000172e:	692c                	ld	a1,80(a0)
    80001730:	050ab503          	ld	a0,80(s5)
    80001734:	e9cff0ef          	jal	80000dd0 <uvmcopy>
    80001738:	04054863          	bltz	a0,80001788 <kfork+0x7c>
    8000173c:	f04a                	sd	s2,32(sp)
    8000173e:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    80001740:	048ab783          	ld	a5,72(s5)
    80001744:	04fa3423          	sd	a5,72(s4) # 1048 <_entry-0x7fffefb8>
  *(np->trapframe) = *(p->trapframe);
    80001748:	058ab683          	ld	a3,88(s5)
    8000174c:	87b6                	mv	a5,a3
    8000174e:	058a3703          	ld	a4,88(s4)
    80001752:	12068693          	addi	a3,a3,288
    80001756:	6388                	ld	a0,0(a5)
    80001758:	678c                	ld	a1,8(a5)
    8000175a:	6b90                	ld	a2,16(a5)
    8000175c:	e308                	sd	a0,0(a4)
    8000175e:	e70c                	sd	a1,8(a4)
    80001760:	eb10                	sd	a2,16(a4)
    80001762:	6f90                	ld	a2,24(a5)
    80001764:	ef10                	sd	a2,24(a4)
    80001766:	02078793          	addi	a5,a5,32
    8000176a:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    8000176e:	fed794e3          	bne	a5,a3,80001756 <kfork+0x4a>
  np->trapframe->a0 = 0;
    80001772:	058a3783          	ld	a5,88(s4)
    80001776:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    8000177a:	0d8a8493          	addi	s1,s5,216
    8000177e:	0d8a0913          	addi	s2,s4,216
    80001782:	158a8993          	addi	s3,s5,344
    80001786:	a831                	j	800017a2 <kfork+0x96>
    freeproc(np);
    80001788:	8552                	mv	a0,s4
    8000178a:	dd5ff0ef          	jal	8000155e <freeproc>
    release(&np->lock);
    8000178e:	8552                	mv	a0,s4
    80001790:	07d040ef          	jal	8000600c <release>
    return -1;
    80001794:	54fd                	li	s1,-1
    80001796:	6a42                	ld	s4,16(sp)
    80001798:	a885                	j	80001808 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    8000179a:	04a1                	addi	s1,s1,8
    8000179c:	0921                	addi	s2,s2,8
    8000179e:	01348963          	beq	s1,s3,800017b0 <kfork+0xa4>
    if(p->ofile[i])
    800017a2:	6088                	ld	a0,0(s1)
    800017a4:	d97d                	beqz	a0,8000179a <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    800017a6:	316020ef          	jal	80003abc <filedup>
    800017aa:	00a93023          	sd	a0,0(s2)
    800017ae:	b7f5                	j	8000179a <kfork+0x8e>
  np->cwd = idup(p->cwd);
    800017b0:	158ab503          	ld	a0,344(s5)
    800017b4:	4e8010ef          	jal	80002c9c <idup>
    800017b8:	14aa3c23          	sd	a0,344(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    800017bc:	4641                	li	a2,16
    800017be:	160a8593          	addi	a1,s5,352
    800017c2:	160a0513          	addi	a0,s4,352
    800017c6:	c2bfe0ef          	jal	800003f0 <safestrcpy>
  pid = np->pid;
    800017ca:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    800017ce:	8552                	mv	a0,s4
    800017d0:	03d040ef          	jal	8000600c <release>
  acquire(&wait_lock);
    800017d4:	00007517          	auipc	a0,0x7
    800017d8:	29450513          	addi	a0,a0,660 # 80008a68 <wait_lock>
    800017dc:	79c040ef          	jal	80005f78 <acquire>
  np->parent = p;
    800017e0:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    800017e4:	00007517          	auipc	a0,0x7
    800017e8:	28450513          	addi	a0,a0,644 # 80008a68 <wait_lock>
    800017ec:	021040ef          	jal	8000600c <release>
  acquire(&np->lock);
    800017f0:	8552                	mv	a0,s4
    800017f2:	786040ef          	jal	80005f78 <acquire>
  np->state = RUNNABLE;
    800017f6:	478d                	li	a5,3
    800017f8:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    800017fc:	8552                	mv	a0,s4
    800017fe:	00f040ef          	jal	8000600c <release>
  return pid;
    80001802:	7902                	ld	s2,32(sp)
    80001804:	69e2                	ld	s3,24(sp)
    80001806:	6a42                	ld	s4,16(sp)
}
    80001808:	8526                	mv	a0,s1
    8000180a:	70e2                	ld	ra,56(sp)
    8000180c:	7442                	ld	s0,48(sp)
    8000180e:	74a2                	ld	s1,40(sp)
    80001810:	6aa2                	ld	s5,8(sp)
    80001812:	6121                	addi	sp,sp,64
    80001814:	8082                	ret
    return -1;
    80001816:	54fd                	li	s1,-1
    80001818:	bfc5                	j	80001808 <kfork+0xfc>

000000008000181a <scheduler>:
{
    8000181a:	715d                	addi	sp,sp,-80
    8000181c:	e486                	sd	ra,72(sp)
    8000181e:	e0a2                	sd	s0,64(sp)
    80001820:	fc26                	sd	s1,56(sp)
    80001822:	f84a                	sd	s2,48(sp)
    80001824:	f44e                	sd	s3,40(sp)
    80001826:	f052                	sd	s4,32(sp)
    80001828:	ec56                	sd	s5,24(sp)
    8000182a:	e85a                	sd	s6,16(sp)
    8000182c:	e45e                	sd	s7,8(sp)
    8000182e:	e062                	sd	s8,0(sp)
    80001830:	0880                	addi	s0,sp,80
    80001832:	8792                	mv	a5,tp
  int id = r_tp();
    80001834:	2781                	sext.w	a5,a5
  c->proc = 0;
    80001836:	00779b13          	slli	s6,a5,0x7
    8000183a:	00007717          	auipc	a4,0x7
    8000183e:	21670713          	addi	a4,a4,534 # 80008a50 <pid_lock>
    80001842:	975a                	add	a4,a4,s6
    80001844:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    80001848:	00007717          	auipc	a4,0x7
    8000184c:	24070713          	addi	a4,a4,576 # 80008a88 <cpus+0x8>
    80001850:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    80001852:	4c11                	li	s8,4
        c->proc = p;
    80001854:	079e                	slli	a5,a5,0x7
    80001856:	00007a17          	auipc	s4,0x7
    8000185a:	1faa0a13          	addi	s4,s4,506 # 80008a50 <pid_lock>
    8000185e:	9a3e                	add	s4,s4,a5
        found = 1;
    80001860:	4b85                	li	s7,1
    80001862:	a83d                	j	800018a0 <scheduler+0x86>
      release(&p->lock);
    80001864:	8526                	mv	a0,s1
    80001866:	7a6040ef          	jal	8000600c <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    8000186a:	1f848493          	addi	s1,s1,504
    8000186e:	03248563          	beq	s1,s2,80001898 <scheduler+0x7e>
      acquire(&p->lock);
    80001872:	8526                	mv	a0,s1
    80001874:	704040ef          	jal	80005f78 <acquire>
      if(p->state == RUNNABLE) {
    80001878:	4c9c                	lw	a5,24(s1)
    8000187a:	ff3795e3          	bne	a5,s3,80001864 <scheduler+0x4a>
        p->state = RUNNING;
    8000187e:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    80001882:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    80001886:	06848593          	addi	a1,s1,104
    8000188a:	855a                	mv	a0,s6
    8000188c:	5ba000ef          	jal	80001e46 <swtch>
        c->proc = 0;
    80001890:	020a3823          	sd	zero,48(s4)
        found = 1;
    80001894:	8ade                	mv	s5,s7
    80001896:	b7f9                	j	80001864 <scheduler+0x4a>
    if(found == 0) {
    80001898:	000a9463          	bnez	s5,800018a0 <scheduler+0x86>
      asm volatile("wfi");
    8000189c:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800018a4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018a8:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800018ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800018b0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800018b2:	10079073          	csrw	sstatus,a5
    int found = 0;
    800018b6:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    800018b8:	00007497          	auipc	s1,0x7
    800018bc:	5c848493          	addi	s1,s1,1480 # 80008e80 <proc>
      if(p->state == RUNNABLE) {
    800018c0:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    800018c2:	0000f917          	auipc	s2,0xf
    800018c6:	3be90913          	addi	s2,s2,958 # 80010c80 <tickslock>
    800018ca:	b765                	j	80001872 <scheduler+0x58>

00000000800018cc <sched>:
{
    800018cc:	7179                	addi	sp,sp,-48
    800018ce:	f406                	sd	ra,40(sp)
    800018d0:	f022                	sd	s0,32(sp)
    800018d2:	ec26                	sd	s1,24(sp)
    800018d4:	e84a                	sd	s2,16(sp)
    800018d6:	e44e                	sd	s3,8(sp)
    800018d8:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    800018da:	a67ff0ef          	jal	80001340 <myproc>
    800018de:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    800018e0:	628040ef          	jal	80005f08 <holding>
    800018e4:	c935                	beqz	a0,80001958 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    800018e6:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    800018e8:	2781                	sext.w	a5,a5
    800018ea:	079e                	slli	a5,a5,0x7
    800018ec:	00007717          	auipc	a4,0x7
    800018f0:	16470713          	addi	a4,a4,356 # 80008a50 <pid_lock>
    800018f4:	97ba                	add	a5,a5,a4
    800018f6:	0a87a703          	lw	a4,168(a5)
    800018fa:	4785                	li	a5,1
    800018fc:	06f71463          	bne	a4,a5,80001964 <sched+0x98>
  if(p->state == RUNNING)
    80001900:	4c98                	lw	a4,24(s1)
    80001902:	4791                	li	a5,4
    80001904:	06f70663          	beq	a4,a5,80001970 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001908:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000190c:	8b89                	andi	a5,a5,2
  if(intr_get())
    8000190e:	e7bd                	bnez	a5,8000197c <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001910:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    80001912:	00007917          	auipc	s2,0x7
    80001916:	13e90913          	addi	s2,s2,318 # 80008a50 <pid_lock>
    8000191a:	2781                	sext.w	a5,a5
    8000191c:	079e                	slli	a5,a5,0x7
    8000191e:	97ca                	add	a5,a5,s2
    80001920:	0ac7a983          	lw	s3,172(a5)
    80001924:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    80001926:	2781                	sext.w	a5,a5
    80001928:	079e                	slli	a5,a5,0x7
    8000192a:	07a1                	addi	a5,a5,8
    8000192c:	00007597          	auipc	a1,0x7
    80001930:	15458593          	addi	a1,a1,340 # 80008a80 <cpus>
    80001934:	95be                	add	a1,a1,a5
    80001936:	06848513          	addi	a0,s1,104
    8000193a:	50c000ef          	jal	80001e46 <swtch>
    8000193e:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    80001940:	2781                	sext.w	a5,a5
    80001942:	079e                	slli	a5,a5,0x7
    80001944:	993e                	add	s2,s2,a5
    80001946:	0b392623          	sw	s3,172(s2)
}
    8000194a:	70a2                	ld	ra,40(sp)
    8000194c:	7402                	ld	s0,32(sp)
    8000194e:	64e2                	ld	s1,24(sp)
    80001950:	6942                	ld	s2,16(sp)
    80001952:	69a2                	ld	s3,8(sp)
    80001954:	6145                	addi	sp,sp,48
    80001956:	8082                	ret
    panic("sched p->lock");
    80001958:	00007517          	auipc	a0,0x7
    8000195c:	92850513          	addi	a0,a0,-1752 # 80008280 <etext+0x280>
    80001960:	356040ef          	jal	80005cb6 <panic>
    panic("sched locks");
    80001964:	00007517          	auipc	a0,0x7
    80001968:	92c50513          	addi	a0,a0,-1748 # 80008290 <etext+0x290>
    8000196c:	34a040ef          	jal	80005cb6 <panic>
    panic("sched RUNNING");
    80001970:	00007517          	auipc	a0,0x7
    80001974:	93050513          	addi	a0,a0,-1744 # 800082a0 <etext+0x2a0>
    80001978:	33e040ef          	jal	80005cb6 <panic>
    panic("sched interruptible");
    8000197c:	00007517          	auipc	a0,0x7
    80001980:	93450513          	addi	a0,a0,-1740 # 800082b0 <etext+0x2b0>
    80001984:	332040ef          	jal	80005cb6 <panic>

0000000080001988 <yield>:
{
    80001988:	1101                	addi	sp,sp,-32
    8000198a:	ec06                	sd	ra,24(sp)
    8000198c:	e822                	sd	s0,16(sp)
    8000198e:	e426                	sd	s1,8(sp)
    80001990:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    80001992:	9afff0ef          	jal	80001340 <myproc>
    80001996:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001998:	5e0040ef          	jal	80005f78 <acquire>
  p->state = RUNNABLE;
    8000199c:	478d                	li	a5,3
    8000199e:	cc9c                	sw	a5,24(s1)
  sched();
    800019a0:	f2dff0ef          	jal	800018cc <sched>
  release(&p->lock);
    800019a4:	8526                	mv	a0,s1
    800019a6:	666040ef          	jal	8000600c <release>
}
    800019aa:	60e2                	ld	ra,24(sp)
    800019ac:	6442                	ld	s0,16(sp)
    800019ae:	64a2                	ld	s1,8(sp)
    800019b0:	6105                	addi	sp,sp,32
    800019b2:	8082                	ret

00000000800019b4 <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    800019b4:	7179                	addi	sp,sp,-48
    800019b6:	f406                	sd	ra,40(sp)
    800019b8:	f022                	sd	s0,32(sp)
    800019ba:	ec26                	sd	s1,24(sp)
    800019bc:	e84a                	sd	s2,16(sp)
    800019be:	e44e                	sd	s3,8(sp)
    800019c0:	1800                	addi	s0,sp,48
    800019c2:	89aa                	mv	s3,a0
    800019c4:	892e                	mv	s2,a1
  struct proc *p = myproc();
    800019c6:	97bff0ef          	jal	80001340 <myproc>
    800019ca:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    800019cc:	5ac040ef          	jal	80005f78 <acquire>
  release(lk);
    800019d0:	854a                	mv	a0,s2
    800019d2:	63a040ef          	jal	8000600c <release>

  // Go to sleep.
  p->chan = chan;
    800019d6:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    800019da:	4789                	li	a5,2
    800019dc:	cc9c                	sw	a5,24(s1)

  sched();
    800019de:	eefff0ef          	jal	800018cc <sched>

  // Tidy up.
  p->chan = 0;
    800019e2:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    800019e6:	8526                	mv	a0,s1
    800019e8:	624040ef          	jal	8000600c <release>
  acquire(lk);
    800019ec:	854a                	mv	a0,s2
    800019ee:	58a040ef          	jal	80005f78 <acquire>
}
    800019f2:	70a2                	ld	ra,40(sp)
    800019f4:	7402                	ld	s0,32(sp)
    800019f6:	64e2                	ld	s1,24(sp)
    800019f8:	6942                	ld	s2,16(sp)
    800019fa:	69a2                	ld	s3,8(sp)
    800019fc:	6145                	addi	sp,sp,48
    800019fe:	8082                	ret

0000000080001a00 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001a00:	7139                	addi	sp,sp,-64
    80001a02:	fc06                	sd	ra,56(sp)
    80001a04:	f822                	sd	s0,48(sp)
    80001a06:	f426                	sd	s1,40(sp)
    80001a08:	f04a                	sd	s2,32(sp)
    80001a0a:	ec4e                	sd	s3,24(sp)
    80001a0c:	e852                	sd	s4,16(sp)
    80001a0e:	e456                	sd	s5,8(sp)
    80001a10:	0080                	addi	s0,sp,64
    80001a12:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    80001a14:	00007497          	auipc	s1,0x7
    80001a18:	46c48493          	addi	s1,s1,1132 # 80008e80 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001a1c:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001a1e:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a20:	0000f917          	auipc	s2,0xf
    80001a24:	26090913          	addi	s2,s2,608 # 80010c80 <tickslock>
    80001a28:	a801                	j	80001a38 <wakeup+0x38>
      }
      release(&p->lock);
    80001a2a:	8526                	mv	a0,s1
    80001a2c:	5e0040ef          	jal	8000600c <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    80001a30:	1f848493          	addi	s1,s1,504
    80001a34:	03248263          	beq	s1,s2,80001a58 <wakeup+0x58>
    if(p != myproc()){
    80001a38:	909ff0ef          	jal	80001340 <myproc>
    80001a3c:	fe950ae3          	beq	a0,s1,80001a30 <wakeup+0x30>
      acquire(&p->lock);
    80001a40:	8526                	mv	a0,s1
    80001a42:	536040ef          	jal	80005f78 <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    80001a46:	4c9c                	lw	a5,24(s1)
    80001a48:	ff3791e3          	bne	a5,s3,80001a2a <wakeup+0x2a>
    80001a4c:	709c                	ld	a5,32(s1)
    80001a4e:	fd479ee3          	bne	a5,s4,80001a2a <wakeup+0x2a>
        p->state = RUNNABLE;
    80001a52:	0154ac23          	sw	s5,24(s1)
    80001a56:	bfd1                	j	80001a2a <wakeup+0x2a>
    }
  }
}
    80001a58:	70e2                	ld	ra,56(sp)
    80001a5a:	7442                	ld	s0,48(sp)
    80001a5c:	74a2                	ld	s1,40(sp)
    80001a5e:	7902                	ld	s2,32(sp)
    80001a60:	69e2                	ld	s3,24(sp)
    80001a62:	6a42                	ld	s4,16(sp)
    80001a64:	6aa2                	ld	s5,8(sp)
    80001a66:	6121                	addi	sp,sp,64
    80001a68:	8082                	ret

0000000080001a6a <reparent>:
{
    80001a6a:	7179                	addi	sp,sp,-48
    80001a6c:	f406                	sd	ra,40(sp)
    80001a6e:	f022                	sd	s0,32(sp)
    80001a70:	ec26                	sd	s1,24(sp)
    80001a72:	e84a                	sd	s2,16(sp)
    80001a74:	e44e                	sd	s3,8(sp)
    80001a76:	e052                	sd	s4,0(sp)
    80001a78:	1800                	addi	s0,sp,48
    80001a7a:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a7c:	00007497          	auipc	s1,0x7
    80001a80:	40448493          	addi	s1,s1,1028 # 80008e80 <proc>
      pp->parent = initproc;
    80001a84:	00007a17          	auipc	s4,0x7
    80001a88:	f6ca0a13          	addi	s4,s4,-148 # 800089f0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001a8c:	0000f997          	auipc	s3,0xf
    80001a90:	1f498993          	addi	s3,s3,500 # 80010c80 <tickslock>
    80001a94:	a029                	j	80001a9e <reparent+0x34>
    80001a96:	1f848493          	addi	s1,s1,504
    80001a9a:	01348b63          	beq	s1,s3,80001ab0 <reparent+0x46>
    if(pp->parent == p){
    80001a9e:	7c9c                	ld	a5,56(s1)
    80001aa0:	ff279be3          	bne	a5,s2,80001a96 <reparent+0x2c>
      pp->parent = initproc;
    80001aa4:	000a3503          	ld	a0,0(s4)
    80001aa8:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001aaa:	f57ff0ef          	jal	80001a00 <wakeup>
    80001aae:	b7e5                	j	80001a96 <reparent+0x2c>
}
    80001ab0:	70a2                	ld	ra,40(sp)
    80001ab2:	7402                	ld	s0,32(sp)
    80001ab4:	64e2                	ld	s1,24(sp)
    80001ab6:	6942                	ld	s2,16(sp)
    80001ab8:	69a2                	ld	s3,8(sp)
    80001aba:	6a02                	ld	s4,0(sp)
    80001abc:	6145                	addi	sp,sp,48
    80001abe:	8082                	ret

0000000080001ac0 <kexit>:
{
    80001ac0:	7179                	addi	sp,sp,-48
    80001ac2:	f406                	sd	ra,40(sp)
    80001ac4:	f022                	sd	s0,32(sp)
    80001ac6:	ec26                	sd	s1,24(sp)
    80001ac8:	e84a                	sd	s2,16(sp)
    80001aca:	e44e                	sd	s3,8(sp)
    80001acc:	e052                	sd	s4,0(sp)
    80001ace:	1800                	addi	s0,sp,48
    80001ad0:	8a2a                	mv	s4,a0
  struct proc *p = myproc();
    80001ad2:	86fff0ef          	jal	80001340 <myproc>
    80001ad6:	89aa                	mv	s3,a0
  if(p == initproc)
    80001ad8:	00007797          	auipc	a5,0x7
    80001adc:	f187b783          	ld	a5,-232(a5) # 800089f0 <initproc>
    80001ae0:	0d850493          	addi	s1,a0,216
    80001ae4:	15850913          	addi	s2,a0,344
    80001ae8:	00a79b63          	bne	a5,a0,80001afe <kexit+0x3e>
    panic("init exiting");
    80001aec:	00006517          	auipc	a0,0x6
    80001af0:	7dc50513          	addi	a0,a0,2012 # 800082c8 <etext+0x2c8>
    80001af4:	1c2040ef          	jal	80005cb6 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001af8:	04a1                	addi	s1,s1,8
    80001afa:	01248963          	beq	s1,s2,80001b0c <kexit+0x4c>
    if(p->ofile[fd]){
    80001afe:	6088                	ld	a0,0(s1)
    80001b00:	dd65                	beqz	a0,80001af8 <kexit+0x38>
      fileclose(f);
    80001b02:	000020ef          	jal	80003b02 <fileclose>
      p->ofile[fd] = 0;
    80001b06:	0004b023          	sd	zero,0(s1)
    80001b0a:	b7fd                	j	80001af8 <kexit+0x38>
  begin_op();
    80001b0c:	3d3010ef          	jal	800036de <begin_op>
  iput(p->cwd);
    80001b10:	1589b503          	ld	a0,344(s3)
    80001b14:	340010ef          	jal	80002e54 <iput>
  end_op();
    80001b18:	437010ef          	jal	8000374e <end_op>
  p->cwd = 0;
    80001b1c:	1409bc23          	sd	zero,344(s3)
  acquire(&wait_lock);
    80001b20:	00007517          	auipc	a0,0x7
    80001b24:	f4850513          	addi	a0,a0,-184 # 80008a68 <wait_lock>
    80001b28:	450040ef          	jal	80005f78 <acquire>
  reparent(p);
    80001b2c:	854e                	mv	a0,s3
    80001b2e:	f3dff0ef          	jal	80001a6a <reparent>
  wakeup(p->parent);
    80001b32:	0389b503          	ld	a0,56(s3)
    80001b36:	ecbff0ef          	jal	80001a00 <wakeup>
  acquire(&p->lock);
    80001b3a:	854e                	mv	a0,s3
    80001b3c:	43c040ef          	jal	80005f78 <acquire>
  p->xstate = status;
    80001b40:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    80001b44:	4795                	li	a5,5
    80001b46:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    80001b4a:	00007517          	auipc	a0,0x7
    80001b4e:	f1e50513          	addi	a0,a0,-226 # 80008a68 <wait_lock>
    80001b52:	4ba040ef          	jal	8000600c <release>
  sched();
    80001b56:	d77ff0ef          	jal	800018cc <sched>
  panic("zombie exit");
    80001b5a:	00006517          	auipc	a0,0x6
    80001b5e:	77e50513          	addi	a0,a0,1918 # 800082d8 <etext+0x2d8>
    80001b62:	154040ef          	jal	80005cb6 <panic>

0000000080001b66 <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    80001b66:	7179                	addi	sp,sp,-48
    80001b68:	f406                	sd	ra,40(sp)
    80001b6a:	f022                	sd	s0,32(sp)
    80001b6c:	ec26                	sd	s1,24(sp)
    80001b6e:	e84a                	sd	s2,16(sp)
    80001b70:	e44e                	sd	s3,8(sp)
    80001b72:	1800                	addi	s0,sp,48
    80001b74:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    80001b76:	00007497          	auipc	s1,0x7
    80001b7a:	30a48493          	addi	s1,s1,778 # 80008e80 <proc>
    80001b7e:	0000f997          	auipc	s3,0xf
    80001b82:	10298993          	addi	s3,s3,258 # 80010c80 <tickslock>
    acquire(&p->lock);
    80001b86:	8526                	mv	a0,s1
    80001b88:	3f0040ef          	jal	80005f78 <acquire>
    if(p->pid == pid){
    80001b8c:	589c                	lw	a5,48(s1)
    80001b8e:	01278b63          	beq	a5,s2,80001ba4 <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    80001b92:	8526                	mv	a0,s1
    80001b94:	478040ef          	jal	8000600c <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001b98:	1f848493          	addi	s1,s1,504
    80001b9c:	ff3495e3          	bne	s1,s3,80001b86 <kkill+0x20>
  }
  return -1;
    80001ba0:	557d                	li	a0,-1
    80001ba2:	a819                	j	80001bb8 <kkill+0x52>
      p->killed = 1;
    80001ba4:	4785                	li	a5,1
    80001ba6:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001ba8:	4c98                	lw	a4,24(s1)
    80001baa:	4789                	li	a5,2
    80001bac:	00f70d63          	beq	a4,a5,80001bc6 <kkill+0x60>
      release(&p->lock);
    80001bb0:	8526                	mv	a0,s1
    80001bb2:	45a040ef          	jal	8000600c <release>
      return 0;
    80001bb6:	4501                	li	a0,0
}
    80001bb8:	70a2                	ld	ra,40(sp)
    80001bba:	7402                	ld	s0,32(sp)
    80001bbc:	64e2                	ld	s1,24(sp)
    80001bbe:	6942                	ld	s2,16(sp)
    80001bc0:	69a2                	ld	s3,8(sp)
    80001bc2:	6145                	addi	sp,sp,48
    80001bc4:	8082                	ret
        p->state = RUNNABLE;
    80001bc6:	478d                	li	a5,3
    80001bc8:	cc9c                	sw	a5,24(s1)
    80001bca:	b7dd                	j	80001bb0 <kkill+0x4a>

0000000080001bcc <setkilled>:

void
setkilled(struct proc *p)
{
    80001bcc:	1101                	addi	sp,sp,-32
    80001bce:	ec06                	sd	ra,24(sp)
    80001bd0:	e822                	sd	s0,16(sp)
    80001bd2:	e426                	sd	s1,8(sp)
    80001bd4:	1000                	addi	s0,sp,32
    80001bd6:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001bd8:	3a0040ef          	jal	80005f78 <acquire>
  p->killed = 1;
    80001bdc:	4785                	li	a5,1
    80001bde:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001be0:	8526                	mv	a0,s1
    80001be2:	42a040ef          	jal	8000600c <release>
}
    80001be6:	60e2                	ld	ra,24(sp)
    80001be8:	6442                	ld	s0,16(sp)
    80001bea:	64a2                	ld	s1,8(sp)
    80001bec:	6105                	addi	sp,sp,32
    80001bee:	8082                	ret

0000000080001bf0 <killed>:

int
killed(struct proc *p)
{
    80001bf0:	1101                	addi	sp,sp,-32
    80001bf2:	ec06                	sd	ra,24(sp)
    80001bf4:	e822                	sd	s0,16(sp)
    80001bf6:	e426                	sd	s1,8(sp)
    80001bf8:	e04a                	sd	s2,0(sp)
    80001bfa:	1000                	addi	s0,sp,32
    80001bfc:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001bfe:	37a040ef          	jal	80005f78 <acquire>
  k = p->killed;
    80001c02:	549c                	lw	a5,40(s1)
    80001c04:	893e                	mv	s2,a5
  release(&p->lock);
    80001c06:	8526                	mv	a0,s1
    80001c08:	404040ef          	jal	8000600c <release>
  return k;
}
    80001c0c:	854a                	mv	a0,s2
    80001c0e:	60e2                	ld	ra,24(sp)
    80001c10:	6442                	ld	s0,16(sp)
    80001c12:	64a2                	ld	s1,8(sp)
    80001c14:	6902                	ld	s2,0(sp)
    80001c16:	6105                	addi	sp,sp,32
    80001c18:	8082                	ret

0000000080001c1a <kwait>:
{
    80001c1a:	715d                	addi	sp,sp,-80
    80001c1c:	e486                	sd	ra,72(sp)
    80001c1e:	e0a2                	sd	s0,64(sp)
    80001c20:	fc26                	sd	s1,56(sp)
    80001c22:	f84a                	sd	s2,48(sp)
    80001c24:	f44e                	sd	s3,40(sp)
    80001c26:	f052                	sd	s4,32(sp)
    80001c28:	ec56                	sd	s5,24(sp)
    80001c2a:	e85a                	sd	s6,16(sp)
    80001c2c:	e45e                	sd	s7,8(sp)
    80001c2e:	0880                	addi	s0,sp,80
    80001c30:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    80001c32:	f0eff0ef          	jal	80001340 <myproc>
    80001c36:	892a                	mv	s2,a0
  acquire(&wait_lock);
    80001c38:	00007517          	auipc	a0,0x7
    80001c3c:	e3050513          	addi	a0,a0,-464 # 80008a68 <wait_lock>
    80001c40:	338040ef          	jal	80005f78 <acquire>
        if(pp->state == ZOMBIE){
    80001c44:	4a15                	li	s4,5
        havekids = 1;
    80001c46:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001c48:	0000f997          	auipc	s3,0xf
    80001c4c:	03898993          	addi	s3,s3,56 # 80010c80 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001c50:	00007b17          	auipc	s6,0x7
    80001c54:	e18b0b13          	addi	s6,s6,-488 # 80008a68 <wait_lock>
    80001c58:	a869                	j	80001cf2 <kwait+0xd8>
          pid = pp->pid;
    80001c5a:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001c5e:	000b8c63          	beqz	s7,80001c76 <kwait+0x5c>
    80001c62:	4691                	li	a3,4
    80001c64:	02c48613          	addi	a2,s1,44
    80001c68:	85de                	mv	a1,s7
    80001c6a:	05093503          	ld	a0,80(s2)
    80001c6e:	be2ff0ef          	jal	80001050 <copyout>
    80001c72:	02054a63          	bltz	a0,80001ca6 <kwait+0x8c>
          freeproc(pp);
    80001c76:	8526                	mv	a0,s1
    80001c78:	8e7ff0ef          	jal	8000155e <freeproc>
          release(&pp->lock);
    80001c7c:	8526                	mv	a0,s1
    80001c7e:	38e040ef          	jal	8000600c <release>
          release(&wait_lock);
    80001c82:	00007517          	auipc	a0,0x7
    80001c86:	de650513          	addi	a0,a0,-538 # 80008a68 <wait_lock>
    80001c8a:	382040ef          	jal	8000600c <release>
}
    80001c8e:	854e                	mv	a0,s3
    80001c90:	60a6                	ld	ra,72(sp)
    80001c92:	6406                	ld	s0,64(sp)
    80001c94:	74e2                	ld	s1,56(sp)
    80001c96:	7942                	ld	s2,48(sp)
    80001c98:	79a2                	ld	s3,40(sp)
    80001c9a:	7a02                	ld	s4,32(sp)
    80001c9c:	6ae2                	ld	s5,24(sp)
    80001c9e:	6b42                	ld	s6,16(sp)
    80001ca0:	6ba2                	ld	s7,8(sp)
    80001ca2:	6161                	addi	sp,sp,80
    80001ca4:	8082                	ret
            release(&pp->lock);
    80001ca6:	8526                	mv	a0,s1
    80001ca8:	364040ef          	jal	8000600c <release>
            release(&wait_lock);
    80001cac:	00007517          	auipc	a0,0x7
    80001cb0:	dbc50513          	addi	a0,a0,-580 # 80008a68 <wait_lock>
    80001cb4:	358040ef          	jal	8000600c <release>
            return -1;
    80001cb8:	59fd                	li	s3,-1
    80001cba:	bfd1                	j	80001c8e <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cbc:	1f848493          	addi	s1,s1,504
    80001cc0:	03348063          	beq	s1,s3,80001ce0 <kwait+0xc6>
      if(pp->parent == p){
    80001cc4:	7c9c                	ld	a5,56(s1)
    80001cc6:	ff279be3          	bne	a5,s2,80001cbc <kwait+0xa2>
        acquire(&pp->lock);
    80001cca:	8526                	mv	a0,s1
    80001ccc:	2ac040ef          	jal	80005f78 <acquire>
        if(pp->state == ZOMBIE){
    80001cd0:	4c9c                	lw	a5,24(s1)
    80001cd2:	f94784e3          	beq	a5,s4,80001c5a <kwait+0x40>
        release(&pp->lock);
    80001cd6:	8526                	mv	a0,s1
    80001cd8:	334040ef          	jal	8000600c <release>
        havekids = 1;
    80001cdc:	8756                	mv	a4,s5
    80001cde:	bff9                	j	80001cbc <kwait+0xa2>
    if(!havekids || killed(p)){
    80001ce0:	cf19                	beqz	a4,80001cfe <kwait+0xe4>
    80001ce2:	854a                	mv	a0,s2
    80001ce4:	f0dff0ef          	jal	80001bf0 <killed>
    80001ce8:	e919                	bnez	a0,80001cfe <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001cea:	85da                	mv	a1,s6
    80001cec:	854a                	mv	a0,s2
    80001cee:	cc7ff0ef          	jal	800019b4 <sleep>
    havekids = 0;
    80001cf2:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001cf4:	00007497          	auipc	s1,0x7
    80001cf8:	18c48493          	addi	s1,s1,396 # 80008e80 <proc>
    80001cfc:	b7e1                	j	80001cc4 <kwait+0xaa>
      release(&wait_lock);
    80001cfe:	00007517          	auipc	a0,0x7
    80001d02:	d6a50513          	addi	a0,a0,-662 # 80008a68 <wait_lock>
    80001d06:	306040ef          	jal	8000600c <release>
      return -1;
    80001d0a:	59fd                	li	s3,-1
    80001d0c:	b749                	j	80001c8e <kwait+0x74>

0000000080001d0e <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001d0e:	7179                	addi	sp,sp,-48
    80001d10:	f406                	sd	ra,40(sp)
    80001d12:	f022                	sd	s0,32(sp)
    80001d14:	ec26                	sd	s1,24(sp)
    80001d16:	e84a                	sd	s2,16(sp)
    80001d18:	e44e                	sd	s3,8(sp)
    80001d1a:	e052                	sd	s4,0(sp)
    80001d1c:	1800                	addi	s0,sp,48
    80001d1e:	84aa                	mv	s1,a0
    80001d20:	8a2e                	mv	s4,a1
    80001d22:	89b2                	mv	s3,a2
    80001d24:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001d26:	e1aff0ef          	jal	80001340 <myproc>
  if(user_dst){
    80001d2a:	cc99                	beqz	s1,80001d48 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    80001d2c:	86ca                	mv	a3,s2
    80001d2e:	864e                	mv	a2,s3
    80001d30:	85d2                	mv	a1,s4
    80001d32:	6928                	ld	a0,80(a0)
    80001d34:	b1cff0ef          	jal	80001050 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    80001d38:	70a2                	ld	ra,40(sp)
    80001d3a:	7402                	ld	s0,32(sp)
    80001d3c:	64e2                	ld	s1,24(sp)
    80001d3e:	6942                	ld	s2,16(sp)
    80001d40:	69a2                	ld	s3,8(sp)
    80001d42:	6a02                	ld	s4,0(sp)
    80001d44:	6145                	addi	sp,sp,48
    80001d46:	8082                	ret
    memmove((char *)dst, src, len);
    80001d48:	0009061b          	sext.w	a2,s2
    80001d4c:	85ce                	mv	a1,s3
    80001d4e:	8552                	mv	a0,s4
    80001d50:	dacfe0ef          	jal	800002fc <memmove>
    return 0;
    80001d54:	8526                	mv	a0,s1
    80001d56:	b7cd                	j	80001d38 <either_copyout+0x2a>

0000000080001d58 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001d58:	7179                	addi	sp,sp,-48
    80001d5a:	f406                	sd	ra,40(sp)
    80001d5c:	f022                	sd	s0,32(sp)
    80001d5e:	ec26                	sd	s1,24(sp)
    80001d60:	e84a                	sd	s2,16(sp)
    80001d62:	e44e                	sd	s3,8(sp)
    80001d64:	e052                	sd	s4,0(sp)
    80001d66:	1800                	addi	s0,sp,48
    80001d68:	8a2a                	mv	s4,a0
    80001d6a:	84ae                	mv	s1,a1
    80001d6c:	89b2                	mv	s3,a2
    80001d6e:	8936                	mv	s2,a3
  struct proc *p = myproc();
    80001d70:	dd0ff0ef          	jal	80001340 <myproc>
  if(user_src){
    80001d74:	cc99                	beqz	s1,80001d92 <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    80001d76:	86ca                	mv	a3,s2
    80001d78:	864e                	mv	a2,s3
    80001d7a:	85d2                	mv	a1,s4
    80001d7c:	6928                	ld	a0,80(a0)
    80001d7e:	ba0ff0ef          	jal	8000111e <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    80001d82:	70a2                	ld	ra,40(sp)
    80001d84:	7402                	ld	s0,32(sp)
    80001d86:	64e2                	ld	s1,24(sp)
    80001d88:	6942                	ld	s2,16(sp)
    80001d8a:	69a2                	ld	s3,8(sp)
    80001d8c:	6a02                	ld	s4,0(sp)
    80001d8e:	6145                	addi	sp,sp,48
    80001d90:	8082                	ret
    memmove(dst, (char*)src, len);
    80001d92:	0009061b          	sext.w	a2,s2
    80001d96:	85ce                	mv	a1,s3
    80001d98:	8552                	mv	a0,s4
    80001d9a:	d62fe0ef          	jal	800002fc <memmove>
    return 0;
    80001d9e:	8526                	mv	a0,s1
    80001da0:	b7cd                	j	80001d82 <either_copyin+0x2a>

0000000080001da2 <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001da2:	715d                	addi	sp,sp,-80
    80001da4:	e486                	sd	ra,72(sp)
    80001da6:	e0a2                	sd	s0,64(sp)
    80001da8:	fc26                	sd	s1,56(sp)
    80001daa:	f84a                	sd	s2,48(sp)
    80001dac:	f44e                	sd	s3,40(sp)
    80001dae:	f052                	sd	s4,32(sp)
    80001db0:	ec56                	sd	s5,24(sp)
    80001db2:	e85a                	sd	s6,16(sp)
    80001db4:	e45e                	sd	s7,8(sp)
    80001db6:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001db8:	00006517          	auipc	a0,0x6
    80001dbc:	27850513          	addi	a0,a0,632 # 80008030 <etext+0x30>
    80001dc0:	3cd030ef          	jal	8000598c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001dc4:	00007497          	auipc	s1,0x7
    80001dc8:	21c48493          	addi	s1,s1,540 # 80008fe0 <proc+0x160>
    80001dcc:	0000f917          	auipc	s2,0xf
    80001dd0:	01490913          	addi	s2,s2,20 # 80010de0 <bcache+0x148>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001dd4:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001dd6:	00006997          	auipc	s3,0x6
    80001dda:	51298993          	addi	s3,s3,1298 # 800082e8 <etext+0x2e8>
    printf("%d %s %s", p->pid, state, p->name);
    80001dde:	00006a97          	auipc	s5,0x6
    80001de2:	512a8a93          	addi	s5,s5,1298 # 800082f0 <etext+0x2f0>
    printf("\n");
    80001de6:	00006a17          	auipc	s4,0x6
    80001dea:	24aa0a13          	addi	s4,s4,586 # 80008030 <etext+0x30>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001dee:	00007b97          	auipc	s7,0x7
    80001df2:	a6ab8b93          	addi	s7,s7,-1430 # 80008858 <states.0>
    80001df6:	a829                	j	80001e10 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001df8:	ed06a583          	lw	a1,-304(a3)
    80001dfc:	8556                	mv	a0,s5
    80001dfe:	38f030ef          	jal	8000598c <printf>
    printf("\n");
    80001e02:	8552                	mv	a0,s4
    80001e04:	389030ef          	jal	8000598c <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001e08:	1f848493          	addi	s1,s1,504
    80001e0c:	03248263          	beq	s1,s2,80001e30 <procdump+0x8e>
    if(p->state == UNUSED)
    80001e10:	86a6                	mv	a3,s1
    80001e12:	eb84a783          	lw	a5,-328(s1)
    80001e16:	dbed                	beqz	a5,80001e08 <procdump+0x66>
      state = "???";
    80001e18:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001e1a:	fcfb6fe3          	bltu	s6,a5,80001df8 <procdump+0x56>
    80001e1e:	02079713          	slli	a4,a5,0x20
    80001e22:	01d75793          	srli	a5,a4,0x1d
    80001e26:	97de                	add	a5,a5,s7
    80001e28:	6390                	ld	a2,0(a5)
    80001e2a:	f679                	bnez	a2,80001df8 <procdump+0x56>
      state = "???";
    80001e2c:	864e                	mv	a2,s3
    80001e2e:	b7e9                	j	80001df8 <procdump+0x56>
  }
}
    80001e30:	60a6                	ld	ra,72(sp)
    80001e32:	6406                	ld	s0,64(sp)
    80001e34:	74e2                	ld	s1,56(sp)
    80001e36:	7942                	ld	s2,48(sp)
    80001e38:	79a2                	ld	s3,40(sp)
    80001e3a:	7a02                	ld	s4,32(sp)
    80001e3c:	6ae2                	ld	s5,24(sp)
    80001e3e:	6b42                	ld	s6,16(sp)
    80001e40:	6ba2                	ld	s7,8(sp)
    80001e42:	6161                	addi	sp,sp,80
    80001e44:	8082                	ret

0000000080001e46 <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001e46:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001e4a:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001e4e:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001e50:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001e52:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001e56:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001e5a:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001e5e:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001e62:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001e66:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001e6a:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001e6e:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001e72:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001e76:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001e7a:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001e7e:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001e82:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001e84:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001e86:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001e8a:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001e8e:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001e92:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001e96:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001e9a:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001e9e:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001ea2:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001ea6:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001eaa:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001eae:	8082                	ret

0000000080001eb0 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001eb0:	1141                	addi	sp,sp,-16
    80001eb2:	e406                	sd	ra,8(sp)
    80001eb4:	e022                	sd	s0,0(sp)
    80001eb6:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001eb8:	00006597          	auipc	a1,0x6
    80001ebc:	47858593          	addi	a1,a1,1144 # 80008330 <etext+0x330>
    80001ec0:	0000f517          	auipc	a0,0xf
    80001ec4:	dc050513          	addi	a0,a0,-576 # 80010c80 <tickslock>
    80001ec8:	026040ef          	jal	80005eee <initlock>
}
    80001ecc:	60a2                	ld	ra,8(sp)
    80001ece:	6402                	ld	s0,0(sp)
    80001ed0:	0141                	addi	sp,sp,16
    80001ed2:	8082                	ret

0000000080001ed4 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001ed4:	1141                	addi	sp,sp,-16
    80001ed6:	e406                	sd	ra,8(sp)
    80001ed8:	e022                	sd	s0,0(sp)
    80001eda:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001edc:	00003797          	auipc	a5,0x3
    80001ee0:	fe478793          	addi	a5,a5,-28 # 80004ec0 <kernelvec>
    80001ee4:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001ee8:	60a2                	ld	ra,8(sp)
    80001eea:	6402                	ld	s0,0(sp)
    80001eec:	0141                	addi	sp,sp,16
    80001eee:	8082                	ret

0000000080001ef0 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80001ef0:	1141                	addi	sp,sp,-16
    80001ef2:	e406                	sd	ra,8(sp)
    80001ef4:	e022                	sd	s0,0(sp)
    80001ef6:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001ef8:	c48ff0ef          	jal	80001340 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001efc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001f00:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f02:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001f06:	04000737          	lui	a4,0x4000
    80001f0a:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001f0c:	0732                	slli	a4,a4,0xc
    80001f0e:	00005797          	auipc	a5,0x5
    80001f12:	0f278793          	addi	a5,a5,242 # 80007000 <_trampoline>
    80001f16:	00005697          	auipc	a3,0x5
    80001f1a:	0ea68693          	addi	a3,a3,234 # 80007000 <_trampoline>
    80001f1e:	8f95                	sub	a5,a5,a3
    80001f20:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001f22:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001f26:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001f28:	18002773          	csrr	a4,satp
    80001f2c:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001f2e:	6d38                	ld	a4,88(a0)
    80001f30:	613c                	ld	a5,64(a0)
    80001f32:	6685                	lui	a3,0x1
    80001f34:	97b6                	add	a5,a5,a3
    80001f36:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001f38:	6d3c                	ld	a5,88(a0)
    80001f3a:	00000717          	auipc	a4,0x0
    80001f3e:	0fc70713          	addi	a4,a4,252 # 80002036 <usertrap>
    80001f42:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001f44:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001f46:	8712                	mv	a4,tp
    80001f48:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f4a:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001f4e:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001f52:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f56:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001f5a:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f5c:	6f9c                	ld	a5,24(a5)
    80001f5e:	14179073          	csrw	sepc,a5
}
    80001f62:	60a2                	ld	ra,8(sp)
    80001f64:	6402                	ld	s0,0(sp)
    80001f66:	0141                	addi	sp,sp,16
    80001f68:	8082                	ret

0000000080001f6a <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001f6a:	1141                	addi	sp,sp,-16
    80001f6c:	e406                	sd	ra,8(sp)
    80001f6e:	e022                	sd	s0,0(sp)
    80001f70:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001f72:	b9aff0ef          	jal	8000130c <cpuid>
    80001f76:	cd11                	beqz	a0,80001f92 <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001f78:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001f7c:	000f4737          	lui	a4,0xf4
    80001f80:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001f84:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001f86:	14d79073          	csrw	stimecmp,a5
}
    80001f8a:	60a2                	ld	ra,8(sp)
    80001f8c:	6402                	ld	s0,0(sp)
    80001f8e:	0141                	addi	sp,sp,16
    80001f90:	8082                	ret
    acquire(&tickslock);
    80001f92:	0000f517          	auipc	a0,0xf
    80001f96:	cee50513          	addi	a0,a0,-786 # 80010c80 <tickslock>
    80001f9a:	7df030ef          	jal	80005f78 <acquire>
    ticks++;
    80001f9e:	00007717          	auipc	a4,0x7
    80001fa2:	a5a70713          	addi	a4,a4,-1446 # 800089f8 <ticks>
    80001fa6:	431c                	lw	a5,0(a4)
    80001fa8:	2785                	addiw	a5,a5,1
    80001faa:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001fac:	853a                	mv	a0,a4
    80001fae:	a53ff0ef          	jal	80001a00 <wakeup>
    release(&tickslock);
    80001fb2:	0000f517          	auipc	a0,0xf
    80001fb6:	cce50513          	addi	a0,a0,-818 # 80010c80 <tickslock>
    80001fba:	052040ef          	jal	8000600c <release>
    80001fbe:	bf6d                	j	80001f78 <clockintr+0xe>

0000000080001fc0 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001fc0:	1101                	addi	sp,sp,-32
    80001fc2:	ec06                	sd	ra,24(sp)
    80001fc4:	e822                	sd	s0,16(sp)
    80001fc6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001fc8:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001fcc:	57fd                	li	a5,-1
    80001fce:	17fe                	slli	a5,a5,0x3f
    80001fd0:	07a5                	addi	a5,a5,9
    80001fd2:	00f70c63          	beq	a4,a5,80001fea <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001fd6:	57fd                	li	a5,-1
    80001fd8:	17fe                	slli	a5,a5,0x3f
    80001fda:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001fdc:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001fde:	04f70863          	beq	a4,a5,8000202e <devintr+0x6e>
  }
}
    80001fe2:	60e2                	ld	ra,24(sp)
    80001fe4:	6442                	ld	s0,16(sp)
    80001fe6:	6105                	addi	sp,sp,32
    80001fe8:	8082                	ret
    80001fea:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001fec:	781020ef          	jal	80004f6c <plic_claim>
    80001ff0:	872a                	mv	a4,a0
    80001ff2:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001ff4:	47a9                	li	a5,10
    80001ff6:	00f50963          	beq	a0,a5,80002008 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80001ffa:	4785                	li	a5,1
    80001ffc:	00f50963          	beq	a0,a5,8000200e <devintr+0x4e>
    return 1;
    80002000:	4505                	li	a0,1
    } else if(irq){
    80002002:	eb09                	bnez	a4,80002014 <devintr+0x54>
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	bff1                	j	80001fe2 <devintr+0x22>
      uartintr();
    80002008:	67f030ef          	jal	80005e86 <uartintr>
    if(irq)
    8000200c:	a819                	j	80002022 <devintr+0x62>
      virtio_disk_intr();
    8000200e:	3f4030ef          	jal	80005402 <virtio_disk_intr>
    if(irq)
    80002012:	a801                	j	80002022 <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80002014:	85ba                	mv	a1,a4
    80002016:	00006517          	auipc	a0,0x6
    8000201a:	32250513          	addi	a0,a0,802 # 80008338 <etext+0x338>
    8000201e:	16f030ef          	jal	8000598c <printf>
      plic_complete(irq);
    80002022:	8526                	mv	a0,s1
    80002024:	769020ef          	jal	80004f8c <plic_complete>
    return 1;
    80002028:	4505                	li	a0,1
    8000202a:	64a2                	ld	s1,8(sp)
    8000202c:	bf5d                	j	80001fe2 <devintr+0x22>
    clockintr();
    8000202e:	f3dff0ef          	jal	80001f6a <clockintr>
    return 2;
    80002032:	4509                	li	a0,2
    80002034:	b77d                	j	80001fe2 <devintr+0x22>

0000000080002036 <usertrap>:
{
    80002036:	1101                	addi	sp,sp,-32
    80002038:	ec06                	sd	ra,24(sp)
    8000203a:	e822                	sd	s0,16(sp)
    8000203c:	e426                	sd	s1,8(sp)
    8000203e:	e04a                	sd	s2,0(sp)
    80002040:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002042:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80002046:	1007f793          	andi	a5,a5,256
    8000204a:	eba5                	bnez	a5,800020ba <usertrap+0x84>
  asm volatile("csrw stvec, %0" : : "r" (x));
    8000204c:	00003797          	auipc	a5,0x3
    80002050:	e7478793          	addi	a5,a5,-396 # 80004ec0 <kernelvec>
    80002054:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80002058:	ae8ff0ef          	jal	80001340 <myproc>
    8000205c:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    8000205e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002060:	14102773          	csrr	a4,sepc
    80002064:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002066:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    8000206a:	47a1                	li	a5,8
    8000206c:	04f70d63          	beq	a4,a5,800020c6 <usertrap+0x90>
  } else if((which_dev = devintr()) != 0){
    80002070:	f51ff0ef          	jal	80001fc0 <devintr>
    80002074:	892a                	mv	s2,a0
    80002076:	e945                	bnez	a0,80002126 <usertrap+0xf0>
    80002078:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    8000207c:	47bd                	li	a5,15
    8000207e:	08f70863          	beq	a4,a5,8000210e <usertrap+0xd8>
    80002082:	14202773          	csrr	a4,scause
    80002086:	47b5                	li	a5,13
    80002088:	08f70363          	beq	a4,a5,8000210e <usertrap+0xd8>
    8000208c:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80002090:	5890                	lw	a2,48(s1)
    80002092:	00006517          	auipc	a0,0x6
    80002096:	2e650513          	addi	a0,a0,742 # 80008378 <etext+0x378>
    8000209a:	0f3030ef          	jal	8000598c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    8000209e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800020a2:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    800020a6:	00006517          	auipc	a0,0x6
    800020aa:	30250513          	addi	a0,a0,770 # 800083a8 <etext+0x3a8>
    800020ae:	0df030ef          	jal	8000598c <printf>
    setkilled(p);
    800020b2:	8526                	mv	a0,s1
    800020b4:	b19ff0ef          	jal	80001bcc <setkilled>
    800020b8:	a035                	j	800020e4 <usertrap+0xae>
    panic("usertrap: not from user mode");
    800020ba:	00006517          	auipc	a0,0x6
    800020be:	29e50513          	addi	a0,a0,670 # 80008358 <etext+0x358>
    800020c2:	3f5030ef          	jal	80005cb6 <panic>
    if(killed(p))
    800020c6:	b2bff0ef          	jal	80001bf0 <killed>
    800020ca:	ed15                	bnez	a0,80002106 <usertrap+0xd0>
    p->trapframe->epc += 4;
    800020cc:	6cb8                	ld	a4,88(s1)
    800020ce:	6f1c                	ld	a5,24(a4)
    800020d0:	0791                	addi	a5,a5,4
    800020d2:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800020d4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800020d8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800020dc:	10079073          	csrw	sstatus,a5
    syscall();
    800020e0:	240000ef          	jal	80002320 <syscall>
  if(killed(p))
    800020e4:	8526                	mv	a0,s1
    800020e6:	b0bff0ef          	jal	80001bf0 <killed>
    800020ea:	e139                	bnez	a0,80002130 <usertrap+0xfa>
  prepare_return();
    800020ec:	e05ff0ef          	jal	80001ef0 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800020f0:	68a8                	ld	a0,80(s1)
    800020f2:	8131                	srli	a0,a0,0xc
    800020f4:	57fd                	li	a5,-1
    800020f6:	17fe                	slli	a5,a5,0x3f
    800020f8:	8d5d                	or	a0,a0,a5
}
    800020fa:	60e2                	ld	ra,24(sp)
    800020fc:	6442                	ld	s0,16(sp)
    800020fe:	64a2                	ld	s1,8(sp)
    80002100:	6902                	ld	s2,0(sp)
    80002102:	6105                	addi	sp,sp,32
    80002104:	8082                	ret
      kexit(-1);
    80002106:	557d                	li	a0,-1
    80002108:	9b9ff0ef          	jal	80001ac0 <kexit>
    8000210c:	b7c1                	j	800020cc <usertrap+0x96>
  asm volatile("csrr %0, stval" : "=r" (x) );
    8000210e:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80002112:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80002116:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80002118:	00163613          	seqz	a2,a2
    8000211c:	68a8                	ld	a0,80(s1)
    8000211e:	eaffe0ef          	jal	80000fcc <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80002122:	f169                	bnez	a0,800020e4 <usertrap+0xae>
    80002124:	b7a5                	j	8000208c <usertrap+0x56>
  if(killed(p))
    80002126:	8526                	mv	a0,s1
    80002128:	ac9ff0ef          	jal	80001bf0 <killed>
    8000212c:	c511                	beqz	a0,80002138 <usertrap+0x102>
    8000212e:	a011                	j	80002132 <usertrap+0xfc>
    80002130:	4901                	li	s2,0
    kexit(-1);
    80002132:	557d                	li	a0,-1
    80002134:	98dff0ef          	jal	80001ac0 <kexit>
  if(which_dev == 2)
    80002138:	4789                	li	a5,2
    8000213a:	faf919e3          	bne	s2,a5,800020ec <usertrap+0xb6>
    yield();
    8000213e:	84bff0ef          	jal	80001988 <yield>
    80002142:	b76d                	j	800020ec <usertrap+0xb6>

0000000080002144 <kerneltrap>:
{
    80002144:	7179                	addi	sp,sp,-48
    80002146:	f406                	sd	ra,40(sp)
    80002148:	f022                	sd	s0,32(sp)
    8000214a:	ec26                	sd	s1,24(sp)
    8000214c:	e84a                	sd	s2,16(sp)
    8000214e:	e44e                	sd	s3,8(sp)
    80002150:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80002152:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002156:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    8000215a:	142027f3          	csrr	a5,scause
    8000215e:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80002160:	1004f793          	andi	a5,s1,256
    80002164:	c795                	beqz	a5,80002190 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80002166:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000216a:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    8000216c:	eb85                	bnez	a5,8000219c <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    8000216e:	e53ff0ef          	jal	80001fc0 <devintr>
    80002172:	c91d                	beqz	a0,800021a8 <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80002174:	4789                	li	a5,2
    80002176:	04f50a63          	beq	a0,a5,800021ca <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    8000217a:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000217e:	10049073          	csrw	sstatus,s1
}
    80002182:	70a2                	ld	ra,40(sp)
    80002184:	7402                	ld	s0,32(sp)
    80002186:	64e2                	ld	s1,24(sp)
    80002188:	6942                	ld	s2,16(sp)
    8000218a:	69a2                	ld	s3,8(sp)
    8000218c:	6145                	addi	sp,sp,48
    8000218e:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80002190:	00006517          	auipc	a0,0x6
    80002194:	24050513          	addi	a0,a0,576 # 800083d0 <etext+0x3d0>
    80002198:	31f030ef          	jal	80005cb6 <panic>
    panic("kerneltrap: interrupts enabled");
    8000219c:	00006517          	auipc	a0,0x6
    800021a0:	25c50513          	addi	a0,a0,604 # 800083f8 <etext+0x3f8>
    800021a4:	313030ef          	jal	80005cb6 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    800021a8:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    800021ac:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    800021b0:	85ce                	mv	a1,s3
    800021b2:	00006517          	auipc	a0,0x6
    800021b6:	26650513          	addi	a0,a0,614 # 80008418 <etext+0x418>
    800021ba:	7d2030ef          	jal	8000598c <printf>
    panic("kerneltrap");
    800021be:	00006517          	auipc	a0,0x6
    800021c2:	28250513          	addi	a0,a0,642 # 80008440 <etext+0x440>
    800021c6:	2f1030ef          	jal	80005cb6 <panic>
  if(which_dev == 2 && myproc() != 0)
    800021ca:	976ff0ef          	jal	80001340 <myproc>
    800021ce:	d555                	beqz	a0,8000217a <kerneltrap+0x36>
    yield();
    800021d0:	fb8ff0ef          	jal	80001988 <yield>
    800021d4:	b75d                	j	8000217a <kerneltrap+0x36>

00000000800021d6 <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    800021d6:	1101                	addi	sp,sp,-32
    800021d8:	ec06                	sd	ra,24(sp)
    800021da:	e822                	sd	s0,16(sp)
    800021dc:	e426                	sd	s1,8(sp)
    800021de:	1000                	addi	s0,sp,32
    800021e0:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    800021e2:	95eff0ef          	jal	80001340 <myproc>
  switch (n) {
    800021e6:	4795                	li	a5,5
    800021e8:	0497e163          	bltu	a5,s1,8000222a <argraw+0x54>
    800021ec:	048a                	slli	s1,s1,0x2
    800021ee:	00006717          	auipc	a4,0x6
    800021f2:	69a70713          	addi	a4,a4,1690 # 80008888 <states.0+0x30>
    800021f6:	94ba                	add	s1,s1,a4
    800021f8:	409c                	lw	a5,0(s1)
    800021fa:	97ba                	add	a5,a5,a4
    800021fc:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    800021fe:	6d3c                	ld	a5,88(a0)
    80002200:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80002202:	60e2                	ld	ra,24(sp)
    80002204:	6442                	ld	s0,16(sp)
    80002206:	64a2                	ld	s1,8(sp)
    80002208:	6105                	addi	sp,sp,32
    8000220a:	8082                	ret
    return p->trapframe->a1;
    8000220c:	6d3c                	ld	a5,88(a0)
    8000220e:	7fa8                	ld	a0,120(a5)
    80002210:	bfcd                	j	80002202 <argraw+0x2c>
    return p->trapframe->a2;
    80002212:	6d3c                	ld	a5,88(a0)
    80002214:	63c8                	ld	a0,128(a5)
    80002216:	b7f5                	j	80002202 <argraw+0x2c>
    return p->trapframe->a3;
    80002218:	6d3c                	ld	a5,88(a0)
    8000221a:	67c8                	ld	a0,136(a5)
    8000221c:	b7dd                	j	80002202 <argraw+0x2c>
    return p->trapframe->a4;
    8000221e:	6d3c                	ld	a5,88(a0)
    80002220:	6bc8                	ld	a0,144(a5)
    80002222:	b7c5                	j	80002202 <argraw+0x2c>
    return p->trapframe->a5;
    80002224:	6d3c                	ld	a5,88(a0)
    80002226:	6fc8                	ld	a0,152(a5)
    80002228:	bfe9                	j	80002202 <argraw+0x2c>
  panic("argraw");
    8000222a:	00006517          	auipc	a0,0x6
    8000222e:	22650513          	addi	a0,a0,550 # 80008450 <etext+0x450>
    80002232:	285030ef          	jal	80005cb6 <panic>

0000000080002236 <fetchaddr>:
{
    80002236:	1101                	addi	sp,sp,-32
    80002238:	ec06                	sd	ra,24(sp)
    8000223a:	e822                	sd	s0,16(sp)
    8000223c:	e426                	sd	s1,8(sp)
    8000223e:	e04a                	sd	s2,0(sp)
    80002240:	1000                	addi	s0,sp,32
    80002242:	84aa                	mv	s1,a0
    80002244:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80002246:	8faff0ef          	jal	80001340 <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000224a:	653c                	ld	a5,72(a0)
    8000224c:	02f4f663          	bgeu	s1,a5,80002278 <fetchaddr+0x42>
    80002250:	00848713          	addi	a4,s1,8
    80002254:	02e7e463          	bltu	a5,a4,8000227c <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002258:	46a1                	li	a3,8
    8000225a:	8626                	mv	a2,s1
    8000225c:	85ca                	mv	a1,s2
    8000225e:	6928                	ld	a0,80(a0)
    80002260:	ebffe0ef          	jal	8000111e <copyin>
    80002264:	00a03533          	snez	a0,a0
    80002268:	40a0053b          	negw	a0,a0
}
    8000226c:	60e2                	ld	ra,24(sp)
    8000226e:	6442                	ld	s0,16(sp)
    80002270:	64a2                	ld	s1,8(sp)
    80002272:	6902                	ld	s2,0(sp)
    80002274:	6105                	addi	sp,sp,32
    80002276:	8082                	ret
    return -1;
    80002278:	557d                	li	a0,-1
    8000227a:	bfcd                	j	8000226c <fetchaddr+0x36>
    8000227c:	557d                	li	a0,-1
    8000227e:	b7fd                	j	8000226c <fetchaddr+0x36>

0000000080002280 <fetchstr>:
{
    80002280:	7179                	addi	sp,sp,-48
    80002282:	f406                	sd	ra,40(sp)
    80002284:	f022                	sd	s0,32(sp)
    80002286:	ec26                	sd	s1,24(sp)
    80002288:	e84a                	sd	s2,16(sp)
    8000228a:	e44e                	sd	s3,8(sp)
    8000228c:	1800                	addi	s0,sp,48
    8000228e:	89aa                	mv	s3,a0
    80002290:	84ae                	mv	s1,a1
    80002292:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80002294:	8acff0ef          	jal	80001340 <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80002298:	86ca                	mv	a3,s2
    8000229a:	864e                	mv	a2,s3
    8000229c:	85a6                	mv	a1,s1
    8000229e:	6928                	ld	a0,80(a0)
    800022a0:	c51fe0ef          	jal	80000ef0 <copyinstr>
    800022a4:	00054c63          	bltz	a0,800022bc <fetchstr+0x3c>
  return strlen(buf);
    800022a8:	8526                	mv	a0,s1
    800022aa:	97cfe0ef          	jal	80000426 <strlen>
}
    800022ae:	70a2                	ld	ra,40(sp)
    800022b0:	7402                	ld	s0,32(sp)
    800022b2:	64e2                	ld	s1,24(sp)
    800022b4:	6942                	ld	s2,16(sp)
    800022b6:	69a2                	ld	s3,8(sp)
    800022b8:	6145                	addi	sp,sp,48
    800022ba:	8082                	ret
    return -1;
    800022bc:	557d                	li	a0,-1
    800022be:	bfc5                	j	800022ae <fetchstr+0x2e>

00000000800022c0 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    800022c0:	1101                	addi	sp,sp,-32
    800022c2:	ec06                	sd	ra,24(sp)
    800022c4:	e822                	sd	s0,16(sp)
    800022c6:	e426                	sd	s1,8(sp)
    800022c8:	1000                	addi	s0,sp,32
    800022ca:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800022cc:	f0bff0ef          	jal	800021d6 <argraw>
    800022d0:	c088                	sw	a0,0(s1)
}
    800022d2:	60e2                	ld	ra,24(sp)
    800022d4:	6442                	ld	s0,16(sp)
    800022d6:	64a2                	ld	s1,8(sp)
    800022d8:	6105                	addi	sp,sp,32
    800022da:	8082                	ret

00000000800022dc <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    800022dc:	1101                	addi	sp,sp,-32
    800022de:	ec06                	sd	ra,24(sp)
    800022e0:	e822                	sd	s0,16(sp)
    800022e2:	e426                	sd	s1,8(sp)
    800022e4:	1000                	addi	s0,sp,32
    800022e6:	84ae                	mv	s1,a1
  *ip = argraw(n);
    800022e8:	eefff0ef          	jal	800021d6 <argraw>
    800022ec:	e088                	sd	a0,0(s1)
}
    800022ee:	60e2                	ld	ra,24(sp)
    800022f0:	6442                	ld	s0,16(sp)
    800022f2:	64a2                	ld	s1,8(sp)
    800022f4:	6105                	addi	sp,sp,32
    800022f6:	8082                	ret

00000000800022f8 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    800022f8:	1101                	addi	sp,sp,-32
    800022fa:	ec06                	sd	ra,24(sp)
    800022fc:	e822                	sd	s0,16(sp)
    800022fe:	e426                	sd	s1,8(sp)
    80002300:	e04a                	sd	s2,0(sp)
    80002302:	1000                	addi	s0,sp,32
    80002304:	892e                	mv	s2,a1
    80002306:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80002308:	ecfff0ef          	jal	800021d6 <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    8000230c:	8626                	mv	a2,s1
    8000230e:	85ca                	mv	a1,s2
    80002310:	f71ff0ef          	jal	80002280 <fetchstr>
}
    80002314:	60e2                	ld	ra,24(sp)
    80002316:	6442                	ld	s0,16(sp)
    80002318:	64a2                	ld	s1,8(sp)
    8000231a:	6902                	ld	s2,0(sp)
    8000231c:	6105                	addi	sp,sp,32
    8000231e:	8082                	ret

0000000080002320 <syscall>:
};


void
syscall(void)
{
    80002320:	1101                	addi	sp,sp,-32
    80002322:	ec06                	sd	ra,24(sp)
    80002324:	e822                	sd	s0,16(sp)
    80002326:	e426                	sd	s1,8(sp)
    80002328:	e04a                	sd	s2,0(sp)
    8000232a:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    8000232c:	814ff0ef          	jal	80001340 <myproc>
    80002330:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80002332:	05853903          	ld	s2,88(a0)
    80002336:	0a893783          	ld	a5,168(s2)
    8000233a:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    8000233e:	37fd                	addiw	a5,a5,-1
    80002340:	02100713          	li	a4,33
    80002344:	00f76f63          	bltu	a4,a5,80002362 <syscall+0x42>
    80002348:	00369713          	slli	a4,a3,0x3
    8000234c:	00006797          	auipc	a5,0x6
    80002350:	55478793          	addi	a5,a5,1364 # 800088a0 <syscalls>
    80002354:	97ba                	add	a5,a5,a4
    80002356:	639c                	ld	a5,0(a5)
    80002358:	c789                	beqz	a5,80002362 <syscall+0x42>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    8000235a:	9782                	jalr	a5
    8000235c:	06a93823          	sd	a0,112(s2)
    80002360:	a829                	j	8000237a <syscall+0x5a>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80002362:	16048613          	addi	a2,s1,352
    80002366:	588c                	lw	a1,48(s1)
    80002368:	00006517          	auipc	a0,0x6
    8000236c:	0f050513          	addi	a0,a0,240 # 80008458 <etext+0x458>
    80002370:	61c030ef          	jal	8000598c <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80002374:	6cbc                	ld	a5,88(s1)
    80002376:	577d                	li	a4,-1
    80002378:	fbb8                	sd	a4,112(a5)
  }
}
    8000237a:	60e2                	ld	ra,24(sp)
    8000237c:	6442                	ld	s0,16(sp)
    8000237e:	64a2                	ld	s1,8(sp)
    80002380:	6902                	ld	s2,0(sp)
    80002382:	6105                	addi	sp,sp,32
    80002384:	8082                	ret

0000000080002386 <sys_exit>:
#endif
#include "vm.h"

uint64
sys_exit(void)
{
    80002386:	1101                	addi	sp,sp,-32
    80002388:	ec06                	sd	ra,24(sp)
    8000238a:	e822                	sd	s0,16(sp)
    8000238c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000238e:	fec40593          	addi	a1,s0,-20
    80002392:	4501                	li	a0,0
    80002394:	f2dff0ef          	jal	800022c0 <argint>
  kexit(n);
    80002398:	fec42503          	lw	a0,-20(s0)
    8000239c:	f24ff0ef          	jal	80001ac0 <kexit>
  return 0;  // not reached
}
    800023a0:	4501                	li	a0,0
    800023a2:	60e2                	ld	ra,24(sp)
    800023a4:	6442                	ld	s0,16(sp)
    800023a6:	6105                	addi	sp,sp,32
    800023a8:	8082                	ret

00000000800023aa <sys_getpid>:

uint64
sys_getpid(void)
{
    800023aa:	1141                	addi	sp,sp,-16
    800023ac:	e406                	sd	ra,8(sp)
    800023ae:	e022                	sd	s0,0(sp)
    800023b0:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800023b2:	f8ffe0ef          	jal	80001340 <myproc>
}
    800023b6:	5908                	lw	a0,48(a0)
    800023b8:	60a2                	ld	ra,8(sp)
    800023ba:	6402                	ld	s0,0(sp)
    800023bc:	0141                	addi	sp,sp,16
    800023be:	8082                	ret

00000000800023c0 <sys_fork>:

uint64
sys_fork(void)
{
    800023c0:	1141                	addi	sp,sp,-16
    800023c2:	e406                	sd	ra,8(sp)
    800023c4:	e022                	sd	s0,0(sp)
    800023c6:	0800                	addi	s0,sp,16
  return kfork();
    800023c8:	b44ff0ef          	jal	8000170c <kfork>
}
    800023cc:	60a2                	ld	ra,8(sp)
    800023ce:	6402                	ld	s0,0(sp)
    800023d0:	0141                	addi	sp,sp,16
    800023d2:	8082                	ret

00000000800023d4 <sys_wait>:

uint64
sys_wait(void)
{
    800023d4:	1101                	addi	sp,sp,-32
    800023d6:	ec06                	sd	ra,24(sp)
    800023d8:	e822                	sd	s0,16(sp)
    800023da:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800023dc:	fe840593          	addi	a1,s0,-24
    800023e0:	4501                	li	a0,0
    800023e2:	efbff0ef          	jal	800022dc <argaddr>
  return kwait(p);
    800023e6:	fe843503          	ld	a0,-24(s0)
    800023ea:	831ff0ef          	jal	80001c1a <kwait>
}
    800023ee:	60e2                	ld	ra,24(sp)
    800023f0:	6442                	ld	s0,16(sp)
    800023f2:	6105                	addi	sp,sp,32
    800023f4:	8082                	ret

00000000800023f6 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800023f6:	7179                	addi	sp,sp,-48
    800023f8:	f406                	sd	ra,40(sp)
    800023fa:	f022                	sd	s0,32(sp)
    800023fc:	ec26                	sd	s1,24(sp)
    800023fe:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002400:	fd840593          	addi	a1,s0,-40
    80002404:	4501                	li	a0,0
    80002406:	ebbff0ef          	jal	800022c0 <argint>
  argint(1, &t);
    8000240a:	fdc40593          	addi	a1,s0,-36
    8000240e:	4505                	li	a0,1
    80002410:	eb1ff0ef          	jal	800022c0 <argint>
  addr = myproc()->sz;
    80002414:	f2dfe0ef          	jal	80001340 <myproc>
    80002418:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    8000241a:	fdc42703          	lw	a4,-36(s0)
    8000241e:	4785                	li	a5,1
    80002420:	02f70163          	beq	a4,a5,80002442 <sys_sbrk+0x4c>
    80002424:	fd842783          	lw	a5,-40(s0)
    80002428:	0007cd63          	bltz	a5,80002442 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    8000242c:	97a6                	add	a5,a5,s1
    8000242e:	0297e863          	bltu	a5,s1,8000245e <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    80002432:	f0ffe0ef          	jal	80001340 <myproc>
    80002436:	fd842703          	lw	a4,-40(s0)
    8000243a:	653c                	ld	a5,72(a0)
    8000243c:	97ba                	add	a5,a5,a4
    8000243e:	e53c                	sd	a5,72(a0)
    80002440:	a039                	j	8000244e <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    80002442:	fd842503          	lw	a0,-40(s0)
    80002446:	a76ff0ef          	jal	800016bc <growproc>
    8000244a:	00054863          	bltz	a0,8000245a <sys_sbrk+0x64>
  }
  return addr;
}
    8000244e:	8526                	mv	a0,s1
    80002450:	70a2                	ld	ra,40(sp)
    80002452:	7402                	ld	s0,32(sp)
    80002454:	64e2                	ld	s1,24(sp)
    80002456:	6145                	addi	sp,sp,48
    80002458:	8082                	ret
      return -1;
    8000245a:	54fd                	li	s1,-1
    8000245c:	bfcd                	j	8000244e <sys_sbrk+0x58>
      return -1;
    8000245e:	54fd                	li	s1,-1
    80002460:	b7fd                	j	8000244e <sys_sbrk+0x58>

0000000080002462 <sys_pause>:

uint64
sys_pause(void)
{
    80002462:	7139                	addi	sp,sp,-64
    80002464:	fc06                	sd	ra,56(sp)
    80002466:	f822                	sd	s0,48(sp)
    80002468:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;


  argint(0, &n);
    8000246a:	fcc40593          	addi	a1,s0,-52
    8000246e:	4501                	li	a0,0
    80002470:	e51ff0ef          	jal	800022c0 <argint>
  if(n < 0)
    80002474:	fcc42783          	lw	a5,-52(s0)
    80002478:	0607c863          	bltz	a5,800024e8 <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    8000247c:	0000f517          	auipc	a0,0xf
    80002480:	80450513          	addi	a0,a0,-2044 # 80010c80 <tickslock>
    80002484:	2f5030ef          	jal	80005f78 <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    80002488:	fcc42783          	lw	a5,-52(s0)
    8000248c:	c3b9                	beqz	a5,800024d2 <sys_pause+0x70>
    8000248e:	f426                	sd	s1,40(sp)
    80002490:	f04a                	sd	s2,32(sp)
    80002492:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    80002494:	00006997          	auipc	s3,0x6
    80002498:	5649a983          	lw	s3,1380(s3) # 800089f8 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000249c:	0000e917          	auipc	s2,0xe
    800024a0:	7e490913          	addi	s2,s2,2020 # 80010c80 <tickslock>
    800024a4:	00006497          	auipc	s1,0x6
    800024a8:	55448493          	addi	s1,s1,1364 # 800089f8 <ticks>
    if(killed(myproc())){
    800024ac:	e95fe0ef          	jal	80001340 <myproc>
    800024b0:	f40ff0ef          	jal	80001bf0 <killed>
    800024b4:	ed0d                	bnez	a0,800024ee <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    800024b6:	85ca                	mv	a1,s2
    800024b8:	8526                	mv	a0,s1
    800024ba:	cfaff0ef          	jal	800019b4 <sleep>
  while(ticks - ticks0 < n){
    800024be:	409c                	lw	a5,0(s1)
    800024c0:	413787bb          	subw	a5,a5,s3
    800024c4:	fcc42703          	lw	a4,-52(s0)
    800024c8:	fee7e2e3          	bltu	a5,a4,800024ac <sys_pause+0x4a>
    800024cc:	74a2                	ld	s1,40(sp)
    800024ce:	7902                	ld	s2,32(sp)
    800024d0:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    800024d2:	0000e517          	auipc	a0,0xe
    800024d6:	7ae50513          	addi	a0,a0,1966 # 80010c80 <tickslock>
    800024da:	333030ef          	jal	8000600c <release>
  return 0;
    800024de:	4501                	li	a0,0
}
    800024e0:	70e2                	ld	ra,56(sp)
    800024e2:	7442                	ld	s0,48(sp)
    800024e4:	6121                	addi	sp,sp,64
    800024e6:	8082                	ret
    n = 0;
    800024e8:	fc042623          	sw	zero,-52(s0)
    800024ec:	bf41                	j	8000247c <sys_pause+0x1a>
      release(&tickslock);
    800024ee:	0000e517          	auipc	a0,0xe
    800024f2:	79250513          	addi	a0,a0,1938 # 80010c80 <tickslock>
    800024f6:	317030ef          	jal	8000600c <release>
      return -1;
    800024fa:	557d                	li	a0,-1
    800024fc:	74a2                	ld	s1,40(sp)
    800024fe:	7902                	ld	s2,32(sp)
    80002500:	69e2                	ld	s3,24(sp)
    80002502:	bff9                	j	800024e0 <sys_pause+0x7e>

0000000080002504 <sys_pgpte>:


#ifdef LAB_PGTBL
int
sys_pgpte(void)
{
    80002504:	7179                	addi	sp,sp,-48
    80002506:	f406                	sd	ra,40(sp)
    80002508:	f022                	sd	s0,32(sp)
    8000250a:	ec26                	sd	s1,24(sp)
    8000250c:	1800                	addi	s0,sp,48
  uint64 va;
  struct proc *p;  

  p = myproc();
    8000250e:	e33fe0ef          	jal	80001340 <myproc>
    80002512:	84aa                	mv	s1,a0
  argaddr(0, &va);
    80002514:	fd840593          	addi	a1,s0,-40
    80002518:	4501                	li	a0,0
    8000251a:	dc3ff0ef          	jal	800022dc <argaddr>
  pte_t *pte = pgpte(p->pagetable, va);
    8000251e:	fd843583          	ld	a1,-40(s0)
    80002522:	68a8                	ld	a0,80(s1)
    80002524:	c89fe0ef          	jal	800011ac <pgpte>
    80002528:	87aa                	mv	a5,a0
  if(pte != 0) {
      return (uint64) *pte;
  }
  return 0;
    8000252a:	4501                	li	a0,0
  if(pte != 0) {
    8000252c:	c391                	beqz	a5,80002530 <sys_pgpte+0x2c>
      return (uint64) *pte;
    8000252e:	4388                	lw	a0,0(a5)
}
    80002530:	70a2                	ld	ra,40(sp)
    80002532:	7402                	ld	s0,32(sp)
    80002534:	64e2                	ld	s1,24(sp)
    80002536:	6145                	addi	sp,sp,48
    80002538:	8082                	ret

000000008000253a <sys_kpgtbl>:
#endif

#ifdef LAB_PGTBL
int
sys_kpgtbl(void)
{
    8000253a:	1141                	addi	sp,sp,-16
    8000253c:	e406                	sd	ra,8(sp)
    8000253e:	e022                	sd	s0,0(sp)
    80002540:	0800                	addi	s0,sp,16
  struct proc *p;  

  p = myproc();
    80002542:	dfffe0ef          	jal	80001340 <myproc>
  vmprint(p->pagetable);
    80002546:	6928                	ld	a0,80(a0)
    80002548:	96afe0ef          	jal	800006b2 <vmprint>
  return 0;
}
    8000254c:	4501                	li	a0,0
    8000254e:	60a2                	ld	ra,8(sp)
    80002550:	6402                	ld	s0,0(sp)
    80002552:	0141                	addi	sp,sp,16
    80002554:	8082                	ret

0000000080002556 <sys_kill>:
#endif


uint64
sys_kill(void)
{
    80002556:	1101                	addi	sp,sp,-32
    80002558:	ec06                	sd	ra,24(sp)
    8000255a:	e822                	sd	s0,16(sp)
    8000255c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000255e:	fec40593          	addi	a1,s0,-20
    80002562:	4501                	li	a0,0
    80002564:	d5dff0ef          	jal	800022c0 <argint>
  return kkill(pid);
    80002568:	fec42503          	lw	a0,-20(s0)
    8000256c:	dfaff0ef          	jal	80001b66 <kkill>
}
    80002570:	60e2                	ld	ra,24(sp)
    80002572:	6442                	ld	s0,16(sp)
    80002574:	6105                	addi	sp,sp,32
    80002576:	8082                	ret

0000000080002578 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002578:	1101                	addi	sp,sp,-32
    8000257a:	ec06                	sd	ra,24(sp)
    8000257c:	e822                	sd	s0,16(sp)
    8000257e:	e426                	sd	s1,8(sp)
    80002580:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002582:	0000e517          	auipc	a0,0xe
    80002586:	6fe50513          	addi	a0,a0,1790 # 80010c80 <tickslock>
    8000258a:	1ef030ef          	jal	80005f78 <acquire>
  xticks = ticks;
    8000258e:	00006797          	auipc	a5,0x6
    80002592:	46a7a783          	lw	a5,1130(a5) # 800089f8 <ticks>
    80002596:	84be                	mv	s1,a5
  release(&tickslock);
    80002598:	0000e517          	auipc	a0,0xe
    8000259c:	6e850513          	addi	a0,a0,1768 # 80010c80 <tickslock>
    800025a0:	26d030ef          	jal	8000600c <release>
  return xticks;
}
    800025a4:	02049513          	slli	a0,s1,0x20
    800025a8:	9101                	srli	a0,a0,0x20
    800025aa:	60e2                	ld	ra,24(sp)
    800025ac:	6442                	ld	s0,16(sp)
    800025ae:	64a2                	ld	s1,8(sp)
    800025b0:	6105                	addi	sp,sp,32
    800025b2:	8082                	ret

00000000800025b4 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800025b4:	7179                	addi	sp,sp,-48
    800025b6:	f406                	sd	ra,40(sp)
    800025b8:	f022                	sd	s0,32(sp)
    800025ba:	ec26                	sd	s1,24(sp)
    800025bc:	e84a                	sd	s2,16(sp)
    800025be:	e44e                	sd	s3,8(sp)
    800025c0:	e052                	sd	s4,0(sp)
    800025c2:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800025c4:	00006597          	auipc	a1,0x6
    800025c8:	eb458593          	addi	a1,a1,-332 # 80008478 <etext+0x478>
    800025cc:	0000e517          	auipc	a0,0xe
    800025d0:	6cc50513          	addi	a0,a0,1740 # 80010c98 <bcache>
    800025d4:	11b030ef          	jal	80005eee <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800025d8:	00016797          	auipc	a5,0x16
    800025dc:	6c078793          	addi	a5,a5,1728 # 80018c98 <bcache+0x8000>
    800025e0:	00017717          	auipc	a4,0x17
    800025e4:	92070713          	addi	a4,a4,-1760 # 80018f00 <bcache+0x8268>
    800025e8:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800025ec:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800025f0:	0000e497          	auipc	s1,0xe
    800025f4:	6c048493          	addi	s1,s1,1728 # 80010cb0 <bcache+0x18>
    b->next = bcache.head.next;
    800025f8:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800025fa:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800025fc:	00006a17          	auipc	s4,0x6
    80002600:	e84a0a13          	addi	s4,s4,-380 # 80008480 <etext+0x480>
    b->next = bcache.head.next;
    80002604:	2b893783          	ld	a5,696(s2)
    80002608:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000260a:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000260e:	85d2                	mv	a1,s4
    80002610:	01048513          	addi	a0,s1,16
    80002614:	328010ef          	jal	8000393c <initsleeplock>
    bcache.head.next->prev = b;
    80002618:	2b893783          	ld	a5,696(s2)
    8000261c:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000261e:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002622:	45848493          	addi	s1,s1,1112
    80002626:	fd349fe3          	bne	s1,s3,80002604 <binit+0x50>
  }
}
    8000262a:	70a2                	ld	ra,40(sp)
    8000262c:	7402                	ld	s0,32(sp)
    8000262e:	64e2                	ld	s1,24(sp)
    80002630:	6942                	ld	s2,16(sp)
    80002632:	69a2                	ld	s3,8(sp)
    80002634:	6a02                	ld	s4,0(sp)
    80002636:	6145                	addi	sp,sp,48
    80002638:	8082                	ret

000000008000263a <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000263a:	7179                	addi	sp,sp,-48
    8000263c:	f406                	sd	ra,40(sp)
    8000263e:	f022                	sd	s0,32(sp)
    80002640:	ec26                	sd	s1,24(sp)
    80002642:	e84a                	sd	s2,16(sp)
    80002644:	e44e                	sd	s3,8(sp)
    80002646:	1800                	addi	s0,sp,48
    80002648:	892a                	mv	s2,a0
    8000264a:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    8000264c:	0000e517          	auipc	a0,0xe
    80002650:	64c50513          	addi	a0,a0,1612 # 80010c98 <bcache>
    80002654:	125030ef          	jal	80005f78 <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002658:	00017497          	auipc	s1,0x17
    8000265c:	8f84b483          	ld	s1,-1800(s1) # 80018f50 <bcache+0x82b8>
    80002660:	00017797          	auipc	a5,0x17
    80002664:	8a078793          	addi	a5,a5,-1888 # 80018f00 <bcache+0x8268>
    80002668:	02f48b63          	beq	s1,a5,8000269e <bread+0x64>
    8000266c:	873e                	mv	a4,a5
    8000266e:	a021                	j	80002676 <bread+0x3c>
    80002670:	68a4                	ld	s1,80(s1)
    80002672:	02e48663          	beq	s1,a4,8000269e <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    80002676:	449c                	lw	a5,8(s1)
    80002678:	ff279ce3          	bne	a5,s2,80002670 <bread+0x36>
    8000267c:	44dc                	lw	a5,12(s1)
    8000267e:	ff3799e3          	bne	a5,s3,80002670 <bread+0x36>
      b->refcnt++;
    80002682:	40bc                	lw	a5,64(s1)
    80002684:	2785                	addiw	a5,a5,1
    80002686:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002688:	0000e517          	auipc	a0,0xe
    8000268c:	61050513          	addi	a0,a0,1552 # 80010c98 <bcache>
    80002690:	17d030ef          	jal	8000600c <release>
      acquiresleep(&b->lock);
    80002694:	01048513          	addi	a0,s1,16
    80002698:	2da010ef          	jal	80003972 <acquiresleep>
      return b;
    8000269c:	a889                	j	800026ee <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000269e:	00017497          	auipc	s1,0x17
    800026a2:	8aa4b483          	ld	s1,-1878(s1) # 80018f48 <bcache+0x82b0>
    800026a6:	00017797          	auipc	a5,0x17
    800026aa:	85a78793          	addi	a5,a5,-1958 # 80018f00 <bcache+0x8268>
    800026ae:	00f48863          	beq	s1,a5,800026be <bread+0x84>
    800026b2:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800026b4:	40bc                	lw	a5,64(s1)
    800026b6:	cb91                	beqz	a5,800026ca <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800026b8:	64a4                	ld	s1,72(s1)
    800026ba:	fee49de3          	bne	s1,a4,800026b4 <bread+0x7a>
  panic("bget: no buffers");
    800026be:	00006517          	auipc	a0,0x6
    800026c2:	dca50513          	addi	a0,a0,-566 # 80008488 <etext+0x488>
    800026c6:	5f0030ef          	jal	80005cb6 <panic>
      b->dev = dev;
    800026ca:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    800026ce:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    800026d2:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800026d6:	4785                	li	a5,1
    800026d8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800026da:	0000e517          	auipc	a0,0xe
    800026de:	5be50513          	addi	a0,a0,1470 # 80010c98 <bcache>
    800026e2:	12b030ef          	jal	8000600c <release>
      acquiresleep(&b->lock);
    800026e6:	01048513          	addi	a0,s1,16
    800026ea:	288010ef          	jal	80003972 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800026ee:	409c                	lw	a5,0(s1)
    800026f0:	cb89                	beqz	a5,80002702 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800026f2:	8526                	mv	a0,s1
    800026f4:	70a2                	ld	ra,40(sp)
    800026f6:	7402                	ld	s0,32(sp)
    800026f8:	64e2                	ld	s1,24(sp)
    800026fa:	6942                	ld	s2,16(sp)
    800026fc:	69a2                	ld	s3,8(sp)
    800026fe:	6145                	addi	sp,sp,48
    80002700:	8082                	ret
    virtio_disk_rw(b, 0);
    80002702:	4581                	li	a1,0
    80002704:	8526                	mv	a0,s1
    80002706:	2eb020ef          	jal	800051f0 <virtio_disk_rw>
    b->valid = 1;
    8000270a:	4785                	li	a5,1
    8000270c:	c09c                	sw	a5,0(s1)
  return b;
    8000270e:	b7d5                	j	800026f2 <bread+0xb8>

0000000080002710 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002710:	1101                	addi	sp,sp,-32
    80002712:	ec06                	sd	ra,24(sp)
    80002714:	e822                	sd	s0,16(sp)
    80002716:	e426                	sd	s1,8(sp)
    80002718:	1000                	addi	s0,sp,32
    8000271a:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000271c:	0541                	addi	a0,a0,16
    8000271e:	2d2010ef          	jal	800039f0 <holdingsleep>
    80002722:	c911                	beqz	a0,80002736 <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002724:	4585                	li	a1,1
    80002726:	8526                	mv	a0,s1
    80002728:	2c9020ef          	jal	800051f0 <virtio_disk_rw>
}
    8000272c:	60e2                	ld	ra,24(sp)
    8000272e:	6442                	ld	s0,16(sp)
    80002730:	64a2                	ld	s1,8(sp)
    80002732:	6105                	addi	sp,sp,32
    80002734:	8082                	ret
    panic("bwrite");
    80002736:	00006517          	auipc	a0,0x6
    8000273a:	d6a50513          	addi	a0,a0,-662 # 800084a0 <etext+0x4a0>
    8000273e:	578030ef          	jal	80005cb6 <panic>

0000000080002742 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002742:	1101                	addi	sp,sp,-32
    80002744:	ec06                	sd	ra,24(sp)
    80002746:	e822                	sd	s0,16(sp)
    80002748:	e426                	sd	s1,8(sp)
    8000274a:	e04a                	sd	s2,0(sp)
    8000274c:	1000                	addi	s0,sp,32
    8000274e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002750:	01050913          	addi	s2,a0,16
    80002754:	854a                	mv	a0,s2
    80002756:	29a010ef          	jal	800039f0 <holdingsleep>
    8000275a:	c125                	beqz	a0,800027ba <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    8000275c:	854a                	mv	a0,s2
    8000275e:	25a010ef          	jal	800039b8 <releasesleep>

  acquire(&bcache.lock);
    80002762:	0000e517          	auipc	a0,0xe
    80002766:	53650513          	addi	a0,a0,1334 # 80010c98 <bcache>
    8000276a:	00f030ef          	jal	80005f78 <acquire>
  b->refcnt--;
    8000276e:	40bc                	lw	a5,64(s1)
    80002770:	37fd                	addiw	a5,a5,-1
    80002772:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002774:	e79d                	bnez	a5,800027a2 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002776:	68b8                	ld	a4,80(s1)
    80002778:	64bc                	ld	a5,72(s1)
    8000277a:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    8000277c:	68b8                	ld	a4,80(s1)
    8000277e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002780:	00016797          	auipc	a5,0x16
    80002784:	51878793          	addi	a5,a5,1304 # 80018c98 <bcache+0x8000>
    80002788:	2b87b703          	ld	a4,696(a5)
    8000278c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000278e:	00016717          	auipc	a4,0x16
    80002792:	77270713          	addi	a4,a4,1906 # 80018f00 <bcache+0x8268>
    80002796:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002798:	2b87b703          	ld	a4,696(a5)
    8000279c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000279e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800027a2:	0000e517          	auipc	a0,0xe
    800027a6:	4f650513          	addi	a0,a0,1270 # 80010c98 <bcache>
    800027aa:	063030ef          	jal	8000600c <release>
}
    800027ae:	60e2                	ld	ra,24(sp)
    800027b0:	6442                	ld	s0,16(sp)
    800027b2:	64a2                	ld	s1,8(sp)
    800027b4:	6902                	ld	s2,0(sp)
    800027b6:	6105                	addi	sp,sp,32
    800027b8:	8082                	ret
    panic("brelse");
    800027ba:	00006517          	auipc	a0,0x6
    800027be:	cee50513          	addi	a0,a0,-786 # 800084a8 <etext+0x4a8>
    800027c2:	4f4030ef          	jal	80005cb6 <panic>

00000000800027c6 <bpin>:

void
bpin(struct buf *b) {
    800027c6:	1101                	addi	sp,sp,-32
    800027c8:	ec06                	sd	ra,24(sp)
    800027ca:	e822                	sd	s0,16(sp)
    800027cc:	e426                	sd	s1,8(sp)
    800027ce:	1000                	addi	s0,sp,32
    800027d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800027d2:	0000e517          	auipc	a0,0xe
    800027d6:	4c650513          	addi	a0,a0,1222 # 80010c98 <bcache>
    800027da:	79e030ef          	jal	80005f78 <acquire>
  b->refcnt++;
    800027de:	40bc                	lw	a5,64(s1)
    800027e0:	2785                	addiw	a5,a5,1
    800027e2:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800027e4:	0000e517          	auipc	a0,0xe
    800027e8:	4b450513          	addi	a0,a0,1204 # 80010c98 <bcache>
    800027ec:	021030ef          	jal	8000600c <release>
}
    800027f0:	60e2                	ld	ra,24(sp)
    800027f2:	6442                	ld	s0,16(sp)
    800027f4:	64a2                	ld	s1,8(sp)
    800027f6:	6105                	addi	sp,sp,32
    800027f8:	8082                	ret

00000000800027fa <bunpin>:

void
bunpin(struct buf *b) {
    800027fa:	1101                	addi	sp,sp,-32
    800027fc:	ec06                	sd	ra,24(sp)
    800027fe:	e822                	sd	s0,16(sp)
    80002800:	e426                	sd	s1,8(sp)
    80002802:	1000                	addi	s0,sp,32
    80002804:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002806:	0000e517          	auipc	a0,0xe
    8000280a:	49250513          	addi	a0,a0,1170 # 80010c98 <bcache>
    8000280e:	76a030ef          	jal	80005f78 <acquire>
  b->refcnt--;
    80002812:	40bc                	lw	a5,64(s1)
    80002814:	37fd                	addiw	a5,a5,-1
    80002816:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002818:	0000e517          	auipc	a0,0xe
    8000281c:	48050513          	addi	a0,a0,1152 # 80010c98 <bcache>
    80002820:	7ec030ef          	jal	8000600c <release>
}
    80002824:	60e2                	ld	ra,24(sp)
    80002826:	6442                	ld	s0,16(sp)
    80002828:	64a2                	ld	s1,8(sp)
    8000282a:	6105                	addi	sp,sp,32
    8000282c:	8082                	ret

000000008000282e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000282e:	1101                	addi	sp,sp,-32
    80002830:	ec06                	sd	ra,24(sp)
    80002832:	e822                	sd	s0,16(sp)
    80002834:	e426                	sd	s1,8(sp)
    80002836:	e04a                	sd	s2,0(sp)
    80002838:	1000                	addi	s0,sp,32
    8000283a:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    8000283c:	00d5d79b          	srliw	a5,a1,0xd
    80002840:	00017597          	auipc	a1,0x17
    80002844:	b345a583          	lw	a1,-1228(a1) # 80019374 <sb+0x1c>
    80002848:	9dbd                	addw	a1,a1,a5
    8000284a:	df1ff0ef          	jal	8000263a <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000284e:	0074f713          	andi	a4,s1,7
    80002852:	4785                	li	a5,1
    80002854:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    80002858:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000285a:	90d9                	srli	s1,s1,0x36
    8000285c:	00950733          	add	a4,a0,s1
    80002860:	05874703          	lbu	a4,88(a4)
    80002864:	00e7f6b3          	and	a3,a5,a4
    80002868:	c29d                	beqz	a3,8000288e <bfree+0x60>
    8000286a:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000286c:	94aa                	add	s1,s1,a0
    8000286e:	fff7c793          	not	a5,a5
    80002872:	8f7d                	and	a4,a4,a5
    80002874:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    80002878:	000010ef          	jal	80003878 <log_write>
  brelse(bp);
    8000287c:	854a                	mv	a0,s2
    8000287e:	ec5ff0ef          	jal	80002742 <brelse>
}
    80002882:	60e2                	ld	ra,24(sp)
    80002884:	6442                	ld	s0,16(sp)
    80002886:	64a2                	ld	s1,8(sp)
    80002888:	6902                	ld	s2,0(sp)
    8000288a:	6105                	addi	sp,sp,32
    8000288c:	8082                	ret
    panic("freeing free block");
    8000288e:	00006517          	auipc	a0,0x6
    80002892:	c2250513          	addi	a0,a0,-990 # 800084b0 <etext+0x4b0>
    80002896:	420030ef          	jal	80005cb6 <panic>

000000008000289a <balloc>:
{
    8000289a:	715d                	addi	sp,sp,-80
    8000289c:	e486                	sd	ra,72(sp)
    8000289e:	e0a2                	sd	s0,64(sp)
    800028a0:	fc26                	sd	s1,56(sp)
    800028a2:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800028a4:	00017797          	auipc	a5,0x17
    800028a8:	ab87a783          	lw	a5,-1352(a5) # 8001935c <sb+0x4>
    800028ac:	0e078263          	beqz	a5,80002990 <balloc+0xf6>
    800028b0:	f84a                	sd	s2,48(sp)
    800028b2:	f44e                	sd	s3,40(sp)
    800028b4:	f052                	sd	s4,32(sp)
    800028b6:	ec56                	sd	s5,24(sp)
    800028b8:	e85a                	sd	s6,16(sp)
    800028ba:	e45e                	sd	s7,8(sp)
    800028bc:	e062                	sd	s8,0(sp)
    800028be:	8baa                	mv	s7,a0
    800028c0:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800028c2:	00017b17          	auipc	s6,0x17
    800028c6:	a96b0b13          	addi	s6,s6,-1386 # 80019358 <sb>
      m = 1 << (bi % 8);
    800028ca:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800028cc:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800028ce:	6c09                	lui	s8,0x2
    800028d0:	a09d                	j	80002936 <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    800028d2:	97ca                	add	a5,a5,s2
    800028d4:	8e55                	or	a2,a2,a3
    800028d6:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    800028da:	854a                	mv	a0,s2
    800028dc:	79d000ef          	jal	80003878 <log_write>
        brelse(bp);
    800028e0:	854a                	mv	a0,s2
    800028e2:	e61ff0ef          	jal	80002742 <brelse>
  bp = bread(dev, bno);
    800028e6:	85a6                	mv	a1,s1
    800028e8:	855e                	mv	a0,s7
    800028ea:	d51ff0ef          	jal	8000263a <bread>
    800028ee:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    800028f0:	40000613          	li	a2,1024
    800028f4:	4581                	li	a1,0
    800028f6:	05850513          	addi	a0,a0,88
    800028fa:	9a3fd0ef          	jal	8000029c <memset>
  log_write(bp);
    800028fe:	854a                	mv	a0,s2
    80002900:	779000ef          	jal	80003878 <log_write>
  brelse(bp);
    80002904:	854a                	mv	a0,s2
    80002906:	e3dff0ef          	jal	80002742 <brelse>
}
    8000290a:	7942                	ld	s2,48(sp)
    8000290c:	79a2                	ld	s3,40(sp)
    8000290e:	7a02                	ld	s4,32(sp)
    80002910:	6ae2                	ld	s5,24(sp)
    80002912:	6b42                	ld	s6,16(sp)
    80002914:	6ba2                	ld	s7,8(sp)
    80002916:	6c02                	ld	s8,0(sp)
}
    80002918:	8526                	mv	a0,s1
    8000291a:	60a6                	ld	ra,72(sp)
    8000291c:	6406                	ld	s0,64(sp)
    8000291e:	74e2                	ld	s1,56(sp)
    80002920:	6161                	addi	sp,sp,80
    80002922:	8082                	ret
    brelse(bp);
    80002924:	854a                	mv	a0,s2
    80002926:	e1dff0ef          	jal	80002742 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000292a:	015c0abb          	addw	s5,s8,s5
    8000292e:	004b2783          	lw	a5,4(s6)
    80002932:	04faf863          	bgeu	s5,a5,80002982 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    80002936:	40dad59b          	sraiw	a1,s5,0xd
    8000293a:	01cb2783          	lw	a5,28(s6)
    8000293e:	9dbd                	addw	a1,a1,a5
    80002940:	855e                	mv	a0,s7
    80002942:	cf9ff0ef          	jal	8000263a <bread>
    80002946:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002948:	004b2503          	lw	a0,4(s6)
    8000294c:	84d6                	mv	s1,s5
    8000294e:	4701                	li	a4,0
    80002950:	fca4fae3          	bgeu	s1,a0,80002924 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002954:	00777693          	andi	a3,a4,7
    80002958:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    8000295c:	41f7579b          	sraiw	a5,a4,0x1f
    80002960:	01d7d79b          	srliw	a5,a5,0x1d
    80002964:	9fb9                	addw	a5,a5,a4
    80002966:	4037d79b          	sraiw	a5,a5,0x3
    8000296a:	00f90633          	add	a2,s2,a5
    8000296e:	05864603          	lbu	a2,88(a2)
    80002972:	00c6f5b3          	and	a1,a3,a2
    80002976:	ddb1                	beqz	a1,800028d2 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002978:	2705                	addiw	a4,a4,1
    8000297a:	2485                	addiw	s1,s1,1
    8000297c:	fd471ae3          	bne	a4,s4,80002950 <balloc+0xb6>
    80002980:	b755                	j	80002924 <balloc+0x8a>
    80002982:	7942                	ld	s2,48(sp)
    80002984:	79a2                	ld	s3,40(sp)
    80002986:	7a02                	ld	s4,32(sp)
    80002988:	6ae2                	ld	s5,24(sp)
    8000298a:	6b42                	ld	s6,16(sp)
    8000298c:	6ba2                	ld	s7,8(sp)
    8000298e:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    80002990:	00006517          	auipc	a0,0x6
    80002994:	b3850513          	addi	a0,a0,-1224 # 800084c8 <etext+0x4c8>
    80002998:	7f5020ef          	jal	8000598c <printf>
  return 0;
    8000299c:	4481                	li	s1,0
    8000299e:	bfad                	j	80002918 <balloc+0x7e>

00000000800029a0 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800029a0:	7179                	addi	sp,sp,-48
    800029a2:	f406                	sd	ra,40(sp)
    800029a4:	f022                	sd	s0,32(sp)
    800029a6:	ec26                	sd	s1,24(sp)
    800029a8:	e84a                	sd	s2,16(sp)
    800029aa:	e44e                	sd	s3,8(sp)
    800029ac:	1800                	addi	s0,sp,48
    800029ae:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800029b0:	47ad                	li	a5,11
    800029b2:	02b7e363          	bltu	a5,a1,800029d8 <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800029b6:	02059793          	slli	a5,a1,0x20
    800029ba:	01e7d593          	srli	a1,a5,0x1e
    800029be:	00b509b3          	add	s3,a0,a1
    800029c2:	0509a483          	lw	s1,80(s3)
    800029c6:	e0b5                	bnez	s1,80002a2a <bmap+0x8a>
      addr = balloc(ip->dev);
    800029c8:	4108                	lw	a0,0(a0)
    800029ca:	ed1ff0ef          	jal	8000289a <balloc>
    800029ce:	84aa                	mv	s1,a0
      if(addr == 0)
    800029d0:	cd29                	beqz	a0,80002a2a <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    800029d2:	04a9a823          	sw	a0,80(s3)
    800029d6:	a891                	j	80002a2a <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    800029d8:	ff45879b          	addiw	a5,a1,-12
    800029dc:	873e                	mv	a4,a5
    800029de:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    800029e0:	0ff00793          	li	a5,255
    800029e4:	06e7e763          	bltu	a5,a4,80002a52 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    800029e8:	08052483          	lw	s1,128(a0)
    800029ec:	e891                	bnez	s1,80002a00 <bmap+0x60>
      addr = balloc(ip->dev);
    800029ee:	4108                	lw	a0,0(a0)
    800029f0:	eabff0ef          	jal	8000289a <balloc>
    800029f4:	84aa                	mv	s1,a0
      if(addr == 0)
    800029f6:	c915                	beqz	a0,80002a2a <bmap+0x8a>
    800029f8:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    800029fa:	08a92023          	sw	a0,128(s2)
    800029fe:	a011                	j	80002a02 <bmap+0x62>
    80002a00:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002a02:	85a6                	mv	a1,s1
    80002a04:	00092503          	lw	a0,0(s2)
    80002a08:	c33ff0ef          	jal	8000263a <bread>
    80002a0c:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002a0e:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002a12:	02099713          	slli	a4,s3,0x20
    80002a16:	01e75593          	srli	a1,a4,0x1e
    80002a1a:	97ae                	add	a5,a5,a1
    80002a1c:	89be                	mv	s3,a5
    80002a1e:	4384                	lw	s1,0(a5)
    80002a20:	cc89                	beqz	s1,80002a3a <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002a22:	8552                	mv	a0,s4
    80002a24:	d1fff0ef          	jal	80002742 <brelse>
    return addr;
    80002a28:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    80002a2a:	8526                	mv	a0,s1
    80002a2c:	70a2                	ld	ra,40(sp)
    80002a2e:	7402                	ld	s0,32(sp)
    80002a30:	64e2                	ld	s1,24(sp)
    80002a32:	6942                	ld	s2,16(sp)
    80002a34:	69a2                	ld	s3,8(sp)
    80002a36:	6145                	addi	sp,sp,48
    80002a38:	8082                	ret
      addr = balloc(ip->dev);
    80002a3a:	00092503          	lw	a0,0(s2)
    80002a3e:	e5dff0ef          	jal	8000289a <balloc>
    80002a42:	84aa                	mv	s1,a0
      if(addr){
    80002a44:	dd79                	beqz	a0,80002a22 <bmap+0x82>
        a[bn] = addr;
    80002a46:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    80002a4a:	8552                	mv	a0,s4
    80002a4c:	62d000ef          	jal	80003878 <log_write>
    80002a50:	bfc9                	j	80002a22 <bmap+0x82>
    80002a52:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002a54:	00006517          	auipc	a0,0x6
    80002a58:	a8c50513          	addi	a0,a0,-1396 # 800084e0 <etext+0x4e0>
    80002a5c:	25a030ef          	jal	80005cb6 <panic>

0000000080002a60 <iget>:
{
    80002a60:	7179                	addi	sp,sp,-48
    80002a62:	f406                	sd	ra,40(sp)
    80002a64:	f022                	sd	s0,32(sp)
    80002a66:	ec26                	sd	s1,24(sp)
    80002a68:	e84a                	sd	s2,16(sp)
    80002a6a:	e44e                	sd	s3,8(sp)
    80002a6c:	e052                	sd	s4,0(sp)
    80002a6e:	1800                	addi	s0,sp,48
    80002a70:	892a                	mv	s2,a0
    80002a72:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    80002a74:	00017517          	auipc	a0,0x17
    80002a78:	90450513          	addi	a0,a0,-1788 # 80019378 <itable>
    80002a7c:	4fc030ef          	jal	80005f78 <acquire>
  empty = 0;
    80002a80:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a82:	00017497          	auipc	s1,0x17
    80002a86:	90e48493          	addi	s1,s1,-1778 # 80019390 <itable+0x18>
    80002a8a:	00018697          	auipc	a3,0x18
    80002a8e:	39668693          	addi	a3,a3,918 # 8001ae20 <log>
    80002a92:	a809                	j	80002aa4 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002a94:	e781                	bnez	a5,80002a9c <iget+0x3c>
    80002a96:	00099363          	bnez	s3,80002a9c <iget+0x3c>
      empty = ip;
    80002a9a:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002a9c:	08848493          	addi	s1,s1,136
    80002aa0:	02d48563          	beq	s1,a3,80002aca <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002aa4:	449c                	lw	a5,8(s1)
    80002aa6:	fef057e3          	blez	a5,80002a94 <iget+0x34>
    80002aaa:	4098                	lw	a4,0(s1)
    80002aac:	ff2718e3          	bne	a4,s2,80002a9c <iget+0x3c>
    80002ab0:	40d8                	lw	a4,4(s1)
    80002ab2:	ff4715e3          	bne	a4,s4,80002a9c <iget+0x3c>
      ip->ref++;
    80002ab6:	2785                	addiw	a5,a5,1
    80002ab8:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    80002aba:	00017517          	auipc	a0,0x17
    80002abe:	8be50513          	addi	a0,a0,-1858 # 80019378 <itable>
    80002ac2:	54a030ef          	jal	8000600c <release>
      return ip;
    80002ac6:	89a6                	mv	s3,s1
    80002ac8:	a015                	j	80002aec <iget+0x8c>
  if(empty == 0)
    80002aca:	02098a63          	beqz	s3,80002afe <iget+0x9e>
  ip->dev = dev;
    80002ace:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002ad2:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    80002ad6:	4785                	li	a5,1
    80002ad8:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002adc:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80002ae0:	00017517          	auipc	a0,0x17
    80002ae4:	89850513          	addi	a0,a0,-1896 # 80019378 <itable>
    80002ae8:	524030ef          	jal	8000600c <release>
}
    80002aec:	854e                	mv	a0,s3
    80002aee:	70a2                	ld	ra,40(sp)
    80002af0:	7402                	ld	s0,32(sp)
    80002af2:	64e2                	ld	s1,24(sp)
    80002af4:	6942                	ld	s2,16(sp)
    80002af6:	69a2                	ld	s3,8(sp)
    80002af8:	6a02                	ld	s4,0(sp)
    80002afa:	6145                	addi	sp,sp,48
    80002afc:	8082                	ret
    panic("iget: no inodes");
    80002afe:	00006517          	auipc	a0,0x6
    80002b02:	9fa50513          	addi	a0,a0,-1542 # 800084f8 <etext+0x4f8>
    80002b06:	1b0030ef          	jal	80005cb6 <panic>

0000000080002b0a <iinit>:
{
    80002b0a:	7179                	addi	sp,sp,-48
    80002b0c:	f406                	sd	ra,40(sp)
    80002b0e:	f022                	sd	s0,32(sp)
    80002b10:	ec26                	sd	s1,24(sp)
    80002b12:	e84a                	sd	s2,16(sp)
    80002b14:	e44e                	sd	s3,8(sp)
    80002b16:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002b18:	00006597          	auipc	a1,0x6
    80002b1c:	9f058593          	addi	a1,a1,-1552 # 80008508 <etext+0x508>
    80002b20:	00017517          	auipc	a0,0x17
    80002b24:	85850513          	addi	a0,a0,-1960 # 80019378 <itable>
    80002b28:	3c6030ef          	jal	80005eee <initlock>
  for(i = 0; i < NINODE; i++) {
    80002b2c:	00017497          	auipc	s1,0x17
    80002b30:	87448493          	addi	s1,s1,-1932 # 800193a0 <itable+0x28>
    80002b34:	00018997          	auipc	s3,0x18
    80002b38:	2fc98993          	addi	s3,s3,764 # 8001ae30 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002b3c:	00006917          	auipc	s2,0x6
    80002b40:	9d490913          	addi	s2,s2,-1580 # 80008510 <etext+0x510>
    80002b44:	85ca                	mv	a1,s2
    80002b46:	8526                	mv	a0,s1
    80002b48:	5f5000ef          	jal	8000393c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002b4c:	08848493          	addi	s1,s1,136
    80002b50:	ff349ae3          	bne	s1,s3,80002b44 <iinit+0x3a>
}
    80002b54:	70a2                	ld	ra,40(sp)
    80002b56:	7402                	ld	s0,32(sp)
    80002b58:	64e2                	ld	s1,24(sp)
    80002b5a:	6942                	ld	s2,16(sp)
    80002b5c:	69a2                	ld	s3,8(sp)
    80002b5e:	6145                	addi	sp,sp,48
    80002b60:	8082                	ret

0000000080002b62 <ialloc>:
{
    80002b62:	7139                	addi	sp,sp,-64
    80002b64:	fc06                	sd	ra,56(sp)
    80002b66:	f822                	sd	s0,48(sp)
    80002b68:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    80002b6a:	00016717          	auipc	a4,0x16
    80002b6e:	7fa72703          	lw	a4,2042(a4) # 80019364 <sb+0xc>
    80002b72:	4785                	li	a5,1
    80002b74:	06e7f063          	bgeu	a5,a4,80002bd4 <ialloc+0x72>
    80002b78:	f426                	sd	s1,40(sp)
    80002b7a:	f04a                	sd	s2,32(sp)
    80002b7c:	ec4e                	sd	s3,24(sp)
    80002b7e:	e852                	sd	s4,16(sp)
    80002b80:	e456                	sd	s5,8(sp)
    80002b82:	e05a                	sd	s6,0(sp)
    80002b84:	8aaa                	mv	s5,a0
    80002b86:	8b2e                	mv	s6,a1
    80002b88:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    80002b8a:	00016a17          	auipc	s4,0x16
    80002b8e:	7cea0a13          	addi	s4,s4,1998 # 80019358 <sb>
    80002b92:	00495593          	srli	a1,s2,0x4
    80002b96:	018a2783          	lw	a5,24(s4)
    80002b9a:	9dbd                	addw	a1,a1,a5
    80002b9c:	8556                	mv	a0,s5
    80002b9e:	a9dff0ef          	jal	8000263a <bread>
    80002ba2:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002ba4:	05850993          	addi	s3,a0,88
    80002ba8:	00f97793          	andi	a5,s2,15
    80002bac:	079a                	slli	a5,a5,0x6
    80002bae:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002bb0:	00099783          	lh	a5,0(s3)
    80002bb4:	cb9d                	beqz	a5,80002bea <ialloc+0x88>
    brelse(bp);
    80002bb6:	b8dff0ef          	jal	80002742 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002bba:	0905                	addi	s2,s2,1
    80002bbc:	00ca2703          	lw	a4,12(s4)
    80002bc0:	0009079b          	sext.w	a5,s2
    80002bc4:	fce7e7e3          	bltu	a5,a4,80002b92 <ialloc+0x30>
    80002bc8:	74a2                	ld	s1,40(sp)
    80002bca:	7902                	ld	s2,32(sp)
    80002bcc:	69e2                	ld	s3,24(sp)
    80002bce:	6a42                	ld	s4,16(sp)
    80002bd0:	6aa2                	ld	s5,8(sp)
    80002bd2:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002bd4:	00006517          	auipc	a0,0x6
    80002bd8:	94450513          	addi	a0,a0,-1724 # 80008518 <etext+0x518>
    80002bdc:	5b1020ef          	jal	8000598c <printf>
  return 0;
    80002be0:	4501                	li	a0,0
}
    80002be2:	70e2                	ld	ra,56(sp)
    80002be4:	7442                	ld	s0,48(sp)
    80002be6:	6121                	addi	sp,sp,64
    80002be8:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002bea:	04000613          	li	a2,64
    80002bee:	4581                	li	a1,0
    80002bf0:	854e                	mv	a0,s3
    80002bf2:	eaafd0ef          	jal	8000029c <memset>
      dip->type = type;
    80002bf6:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002bfa:	8526                	mv	a0,s1
    80002bfc:	47d000ef          	jal	80003878 <log_write>
      brelse(bp);
    80002c00:	8526                	mv	a0,s1
    80002c02:	b41ff0ef          	jal	80002742 <brelse>
      return iget(dev, inum);
    80002c06:	0009059b          	sext.w	a1,s2
    80002c0a:	8556                	mv	a0,s5
    80002c0c:	e55ff0ef          	jal	80002a60 <iget>
    80002c10:	74a2                	ld	s1,40(sp)
    80002c12:	7902                	ld	s2,32(sp)
    80002c14:	69e2                	ld	s3,24(sp)
    80002c16:	6a42                	ld	s4,16(sp)
    80002c18:	6aa2                	ld	s5,8(sp)
    80002c1a:	6b02                	ld	s6,0(sp)
    80002c1c:	b7d9                	j	80002be2 <ialloc+0x80>

0000000080002c1e <iupdate>:
{
    80002c1e:	1101                	addi	sp,sp,-32
    80002c20:	ec06                	sd	ra,24(sp)
    80002c22:	e822                	sd	s0,16(sp)
    80002c24:	e426                	sd	s1,8(sp)
    80002c26:	e04a                	sd	s2,0(sp)
    80002c28:	1000                	addi	s0,sp,32
    80002c2a:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c2c:	415c                	lw	a5,4(a0)
    80002c2e:	0047d79b          	srliw	a5,a5,0x4
    80002c32:	00016597          	auipc	a1,0x16
    80002c36:	73e5a583          	lw	a1,1854(a1) # 80019370 <sb+0x18>
    80002c3a:	9dbd                	addw	a1,a1,a5
    80002c3c:	4108                	lw	a0,0(a0)
    80002c3e:	9fdff0ef          	jal	8000263a <bread>
    80002c42:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c44:	05850793          	addi	a5,a0,88
    80002c48:	40d8                	lw	a4,4(s1)
    80002c4a:	8b3d                	andi	a4,a4,15
    80002c4c:	071a                	slli	a4,a4,0x6
    80002c4e:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002c50:	04449703          	lh	a4,68(s1)
    80002c54:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    80002c58:	04649703          	lh	a4,70(s1)
    80002c5c:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002c60:	04849703          	lh	a4,72(s1)
    80002c64:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    80002c68:	04a49703          	lh	a4,74(s1)
    80002c6c:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    80002c70:	44f8                	lw	a4,76(s1)
    80002c72:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c74:	03400613          	li	a2,52
    80002c78:	05048593          	addi	a1,s1,80
    80002c7c:	00c78513          	addi	a0,a5,12
    80002c80:	e7cfd0ef          	jal	800002fc <memmove>
  log_write(bp);
    80002c84:	854a                	mv	a0,s2
    80002c86:	3f3000ef          	jal	80003878 <log_write>
  brelse(bp);
    80002c8a:	854a                	mv	a0,s2
    80002c8c:	ab7ff0ef          	jal	80002742 <brelse>
}
    80002c90:	60e2                	ld	ra,24(sp)
    80002c92:	6442                	ld	s0,16(sp)
    80002c94:	64a2                	ld	s1,8(sp)
    80002c96:	6902                	ld	s2,0(sp)
    80002c98:	6105                	addi	sp,sp,32
    80002c9a:	8082                	ret

0000000080002c9c <idup>:
{
    80002c9c:	1101                	addi	sp,sp,-32
    80002c9e:	ec06                	sd	ra,24(sp)
    80002ca0:	e822                	sd	s0,16(sp)
    80002ca2:	e426                	sd	s1,8(sp)
    80002ca4:	1000                	addi	s0,sp,32
    80002ca6:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002ca8:	00016517          	auipc	a0,0x16
    80002cac:	6d050513          	addi	a0,a0,1744 # 80019378 <itable>
    80002cb0:	2c8030ef          	jal	80005f78 <acquire>
  ip->ref++;
    80002cb4:	449c                	lw	a5,8(s1)
    80002cb6:	2785                	addiw	a5,a5,1
    80002cb8:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002cba:	00016517          	auipc	a0,0x16
    80002cbe:	6be50513          	addi	a0,a0,1726 # 80019378 <itable>
    80002cc2:	34a030ef          	jal	8000600c <release>
}
    80002cc6:	8526                	mv	a0,s1
    80002cc8:	60e2                	ld	ra,24(sp)
    80002cca:	6442                	ld	s0,16(sp)
    80002ccc:	64a2                	ld	s1,8(sp)
    80002cce:	6105                	addi	sp,sp,32
    80002cd0:	8082                	ret

0000000080002cd2 <ilock>:
{
    80002cd2:	1101                	addi	sp,sp,-32
    80002cd4:	ec06                	sd	ra,24(sp)
    80002cd6:	e822                	sd	s0,16(sp)
    80002cd8:	e426                	sd	s1,8(sp)
    80002cda:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002cdc:	cd19                	beqz	a0,80002cfa <ilock+0x28>
    80002cde:	84aa                	mv	s1,a0
    80002ce0:	451c                	lw	a5,8(a0)
    80002ce2:	00f05c63          	blez	a5,80002cfa <ilock+0x28>
  acquiresleep(&ip->lock);
    80002ce6:	0541                	addi	a0,a0,16
    80002ce8:	48b000ef          	jal	80003972 <acquiresleep>
  if(ip->valid == 0){
    80002cec:	40bc                	lw	a5,64(s1)
    80002cee:	cf89                	beqz	a5,80002d08 <ilock+0x36>
}
    80002cf0:	60e2                	ld	ra,24(sp)
    80002cf2:	6442                	ld	s0,16(sp)
    80002cf4:	64a2                	ld	s1,8(sp)
    80002cf6:	6105                	addi	sp,sp,32
    80002cf8:	8082                	ret
    80002cfa:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002cfc:	00006517          	auipc	a0,0x6
    80002d00:	83450513          	addi	a0,a0,-1996 # 80008530 <etext+0x530>
    80002d04:	7b3020ef          	jal	80005cb6 <panic>
    80002d08:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002d0a:	40dc                	lw	a5,4(s1)
    80002d0c:	0047d79b          	srliw	a5,a5,0x4
    80002d10:	00016597          	auipc	a1,0x16
    80002d14:	6605a583          	lw	a1,1632(a1) # 80019370 <sb+0x18>
    80002d18:	9dbd                	addw	a1,a1,a5
    80002d1a:	4088                	lw	a0,0(s1)
    80002d1c:	91fff0ef          	jal	8000263a <bread>
    80002d20:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002d22:	05850593          	addi	a1,a0,88
    80002d26:	40dc                	lw	a5,4(s1)
    80002d28:	8bbd                	andi	a5,a5,15
    80002d2a:	079a                	slli	a5,a5,0x6
    80002d2c:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002d2e:	00059783          	lh	a5,0(a1)
    80002d32:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002d36:	00259783          	lh	a5,2(a1)
    80002d3a:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002d3e:	00459783          	lh	a5,4(a1)
    80002d42:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002d46:	00659783          	lh	a5,6(a1)
    80002d4a:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002d4e:	459c                	lw	a5,8(a1)
    80002d50:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002d52:	03400613          	li	a2,52
    80002d56:	05b1                	addi	a1,a1,12
    80002d58:	05048513          	addi	a0,s1,80
    80002d5c:	da0fd0ef          	jal	800002fc <memmove>
    brelse(bp);
    80002d60:	854a                	mv	a0,s2
    80002d62:	9e1ff0ef          	jal	80002742 <brelse>
    ip->valid = 1;
    80002d66:	4785                	li	a5,1
    80002d68:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002d6a:	04449783          	lh	a5,68(s1)
    80002d6e:	c399                	beqz	a5,80002d74 <ilock+0xa2>
    80002d70:	6902                	ld	s2,0(sp)
    80002d72:	bfbd                	j	80002cf0 <ilock+0x1e>
      panic("ilock: no type");
    80002d74:	00005517          	auipc	a0,0x5
    80002d78:	7c450513          	addi	a0,a0,1988 # 80008538 <etext+0x538>
    80002d7c:	73b020ef          	jal	80005cb6 <panic>

0000000080002d80 <iunlock>:
{
    80002d80:	1101                	addi	sp,sp,-32
    80002d82:	ec06                	sd	ra,24(sp)
    80002d84:	e822                	sd	s0,16(sp)
    80002d86:	e426                	sd	s1,8(sp)
    80002d88:	e04a                	sd	s2,0(sp)
    80002d8a:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d8c:	c505                	beqz	a0,80002db4 <iunlock+0x34>
    80002d8e:	84aa                	mv	s1,a0
    80002d90:	01050913          	addi	s2,a0,16
    80002d94:	854a                	mv	a0,s2
    80002d96:	45b000ef          	jal	800039f0 <holdingsleep>
    80002d9a:	cd09                	beqz	a0,80002db4 <iunlock+0x34>
    80002d9c:	449c                	lw	a5,8(s1)
    80002d9e:	00f05b63          	blez	a5,80002db4 <iunlock+0x34>
  releasesleep(&ip->lock);
    80002da2:	854a                	mv	a0,s2
    80002da4:	415000ef          	jal	800039b8 <releasesleep>
}
    80002da8:	60e2                	ld	ra,24(sp)
    80002daa:	6442                	ld	s0,16(sp)
    80002dac:	64a2                	ld	s1,8(sp)
    80002dae:	6902                	ld	s2,0(sp)
    80002db0:	6105                	addi	sp,sp,32
    80002db2:	8082                	ret
    panic("iunlock");
    80002db4:	00005517          	auipc	a0,0x5
    80002db8:	79450513          	addi	a0,a0,1940 # 80008548 <etext+0x548>
    80002dbc:	6fb020ef          	jal	80005cb6 <panic>

0000000080002dc0 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002dc0:	7179                	addi	sp,sp,-48
    80002dc2:	f406                	sd	ra,40(sp)
    80002dc4:	f022                	sd	s0,32(sp)
    80002dc6:	ec26                	sd	s1,24(sp)
    80002dc8:	e84a                	sd	s2,16(sp)
    80002dca:	e44e                	sd	s3,8(sp)
    80002dcc:	1800                	addi	s0,sp,48
    80002dce:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002dd0:	05050493          	addi	s1,a0,80
    80002dd4:	08050913          	addi	s2,a0,128
    80002dd8:	a021                	j	80002de0 <itrunc+0x20>
    80002dda:	0491                	addi	s1,s1,4
    80002ddc:	01248b63          	beq	s1,s2,80002df2 <itrunc+0x32>
    if(ip->addrs[i]){
    80002de0:	408c                	lw	a1,0(s1)
    80002de2:	dde5                	beqz	a1,80002dda <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002de4:	0009a503          	lw	a0,0(s3)
    80002de8:	a47ff0ef          	jal	8000282e <bfree>
      ip->addrs[i] = 0;
    80002dec:	0004a023          	sw	zero,0(s1)
    80002df0:	b7ed                	j	80002dda <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002df2:	0809a583          	lw	a1,128(s3)
    80002df6:	ed89                	bnez	a1,80002e10 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002df8:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002dfc:	854e                	mv	a0,s3
    80002dfe:	e21ff0ef          	jal	80002c1e <iupdate>
}
    80002e02:	70a2                	ld	ra,40(sp)
    80002e04:	7402                	ld	s0,32(sp)
    80002e06:	64e2                	ld	s1,24(sp)
    80002e08:	6942                	ld	s2,16(sp)
    80002e0a:	69a2                	ld	s3,8(sp)
    80002e0c:	6145                	addi	sp,sp,48
    80002e0e:	8082                	ret
    80002e10:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002e12:	0009a503          	lw	a0,0(s3)
    80002e16:	825ff0ef          	jal	8000263a <bread>
    80002e1a:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002e1c:	05850493          	addi	s1,a0,88
    80002e20:	45850913          	addi	s2,a0,1112
    80002e24:	a021                	j	80002e2c <itrunc+0x6c>
    80002e26:	0491                	addi	s1,s1,4
    80002e28:	01248963          	beq	s1,s2,80002e3a <itrunc+0x7a>
      if(a[j])
    80002e2c:	408c                	lw	a1,0(s1)
    80002e2e:	dde5                	beqz	a1,80002e26 <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002e30:	0009a503          	lw	a0,0(s3)
    80002e34:	9fbff0ef          	jal	8000282e <bfree>
    80002e38:	b7fd                	j	80002e26 <itrunc+0x66>
    brelse(bp);
    80002e3a:	8552                	mv	a0,s4
    80002e3c:	907ff0ef          	jal	80002742 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e40:	0809a583          	lw	a1,128(s3)
    80002e44:	0009a503          	lw	a0,0(s3)
    80002e48:	9e7ff0ef          	jal	8000282e <bfree>
    ip->addrs[NDIRECT] = 0;
    80002e4c:	0809a023          	sw	zero,128(s3)
    80002e50:	6a02                	ld	s4,0(sp)
    80002e52:	b75d                	j	80002df8 <itrunc+0x38>

0000000080002e54 <iput>:
{
    80002e54:	1101                	addi	sp,sp,-32
    80002e56:	ec06                	sd	ra,24(sp)
    80002e58:	e822                	sd	s0,16(sp)
    80002e5a:	e426                	sd	s1,8(sp)
    80002e5c:	1000                	addi	s0,sp,32
    80002e5e:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002e60:	00016517          	auipc	a0,0x16
    80002e64:	51850513          	addi	a0,a0,1304 # 80019378 <itable>
    80002e68:	110030ef          	jal	80005f78 <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e6c:	4498                	lw	a4,8(s1)
    80002e6e:	4785                	li	a5,1
    80002e70:	02f70063          	beq	a4,a5,80002e90 <iput+0x3c>
  ip->ref--;
    80002e74:	449c                	lw	a5,8(s1)
    80002e76:	37fd                	addiw	a5,a5,-1
    80002e78:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002e7a:	00016517          	auipc	a0,0x16
    80002e7e:	4fe50513          	addi	a0,a0,1278 # 80019378 <itable>
    80002e82:	18a030ef          	jal	8000600c <release>
}
    80002e86:	60e2                	ld	ra,24(sp)
    80002e88:	6442                	ld	s0,16(sp)
    80002e8a:	64a2                	ld	s1,8(sp)
    80002e8c:	6105                	addi	sp,sp,32
    80002e8e:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e90:	40bc                	lw	a5,64(s1)
    80002e92:	d3ed                	beqz	a5,80002e74 <iput+0x20>
    80002e94:	04a49783          	lh	a5,74(s1)
    80002e98:	fff1                	bnez	a5,80002e74 <iput+0x20>
    80002e9a:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002e9c:	01048793          	addi	a5,s1,16
    80002ea0:	893e                	mv	s2,a5
    80002ea2:	853e                	mv	a0,a5
    80002ea4:	2cf000ef          	jal	80003972 <acquiresleep>
    release(&itable.lock);
    80002ea8:	00016517          	auipc	a0,0x16
    80002eac:	4d050513          	addi	a0,a0,1232 # 80019378 <itable>
    80002eb0:	15c030ef          	jal	8000600c <release>
    itrunc(ip);
    80002eb4:	8526                	mv	a0,s1
    80002eb6:	f0bff0ef          	jal	80002dc0 <itrunc>
    ip->type = 0;
    80002eba:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002ebe:	8526                	mv	a0,s1
    80002ec0:	d5fff0ef          	jal	80002c1e <iupdate>
    ip->valid = 0;
    80002ec4:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002ec8:	854a                	mv	a0,s2
    80002eca:	2ef000ef          	jal	800039b8 <releasesleep>
    acquire(&itable.lock);
    80002ece:	00016517          	auipc	a0,0x16
    80002ed2:	4aa50513          	addi	a0,a0,1194 # 80019378 <itable>
    80002ed6:	0a2030ef          	jal	80005f78 <acquire>
    80002eda:	6902                	ld	s2,0(sp)
    80002edc:	bf61                	j	80002e74 <iput+0x20>

0000000080002ede <iunlockput>:
{
    80002ede:	1101                	addi	sp,sp,-32
    80002ee0:	ec06                	sd	ra,24(sp)
    80002ee2:	e822                	sd	s0,16(sp)
    80002ee4:	e426                	sd	s1,8(sp)
    80002ee6:	1000                	addi	s0,sp,32
    80002ee8:	84aa                	mv	s1,a0
  iunlock(ip);
    80002eea:	e97ff0ef          	jal	80002d80 <iunlock>
  iput(ip);
    80002eee:	8526                	mv	a0,s1
    80002ef0:	f65ff0ef          	jal	80002e54 <iput>
}
    80002ef4:	60e2                	ld	ra,24(sp)
    80002ef6:	6442                	ld	s0,16(sp)
    80002ef8:	64a2                	ld	s1,8(sp)
    80002efa:	6105                	addi	sp,sp,32
    80002efc:	8082                	ret

0000000080002efe <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002efe:	00016717          	auipc	a4,0x16
    80002f02:	46672703          	lw	a4,1126(a4) # 80019364 <sb+0xc>
    80002f06:	4785                	li	a5,1
    80002f08:	0ae7fe63          	bgeu	a5,a4,80002fc4 <ireclaim+0xc6>
{
    80002f0c:	7139                	addi	sp,sp,-64
    80002f0e:	fc06                	sd	ra,56(sp)
    80002f10:	f822                	sd	s0,48(sp)
    80002f12:	f426                	sd	s1,40(sp)
    80002f14:	f04a                	sd	s2,32(sp)
    80002f16:	ec4e                	sd	s3,24(sp)
    80002f18:	e852                	sd	s4,16(sp)
    80002f1a:	e456                	sd	s5,8(sp)
    80002f1c:	e05a                	sd	s6,0(sp)
    80002f1e:	0080                	addi	s0,sp,64
    80002f20:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002f22:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002f24:	00016a17          	auipc	s4,0x16
    80002f28:	434a0a13          	addi	s4,s4,1076 # 80019358 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002f2c:	00005b17          	auipc	s6,0x5
    80002f30:	624b0b13          	addi	s6,s6,1572 # 80008550 <etext+0x550>
    80002f34:	a099                	j	80002f7a <ireclaim+0x7c>
    80002f36:	85ce                	mv	a1,s3
    80002f38:	855a                	mv	a0,s6
    80002f3a:	253020ef          	jal	8000598c <printf>
      ip = iget(dev, inum);
    80002f3e:	85ce                	mv	a1,s3
    80002f40:	8556                	mv	a0,s5
    80002f42:	b1fff0ef          	jal	80002a60 <iget>
    80002f46:	89aa                	mv	s3,a0
    brelse(bp);
    80002f48:	854a                	mv	a0,s2
    80002f4a:	ff8ff0ef          	jal	80002742 <brelse>
    if (ip) {
    80002f4e:	00098f63          	beqz	s3,80002f6c <ireclaim+0x6e>
      begin_op();
    80002f52:	78c000ef          	jal	800036de <begin_op>
      ilock(ip);
    80002f56:	854e                	mv	a0,s3
    80002f58:	d7bff0ef          	jal	80002cd2 <ilock>
      iunlock(ip);
    80002f5c:	854e                	mv	a0,s3
    80002f5e:	e23ff0ef          	jal	80002d80 <iunlock>
      iput(ip);
    80002f62:	854e                	mv	a0,s3
    80002f64:	ef1ff0ef          	jal	80002e54 <iput>
      end_op();
    80002f68:	7e6000ef          	jal	8000374e <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002f6c:	0485                	addi	s1,s1,1
    80002f6e:	00ca2703          	lw	a4,12(s4)
    80002f72:	0004879b          	sext.w	a5,s1
    80002f76:	02e7fd63          	bgeu	a5,a4,80002fb0 <ireclaim+0xb2>
    80002f7a:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002f7e:	0044d593          	srli	a1,s1,0x4
    80002f82:	018a2783          	lw	a5,24(s4)
    80002f86:	9dbd                	addw	a1,a1,a5
    80002f88:	8556                	mv	a0,s5
    80002f8a:	eb0ff0ef          	jal	8000263a <bread>
    80002f8e:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002f90:	05850793          	addi	a5,a0,88
    80002f94:	00f9f713          	andi	a4,s3,15
    80002f98:	071a                	slli	a4,a4,0x6
    80002f9a:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002f9c:	00079703          	lh	a4,0(a5)
    80002fa0:	c701                	beqz	a4,80002fa8 <ireclaim+0xaa>
    80002fa2:	00679783          	lh	a5,6(a5)
    80002fa6:	dbc1                	beqz	a5,80002f36 <ireclaim+0x38>
    brelse(bp);
    80002fa8:	854a                	mv	a0,s2
    80002faa:	f98ff0ef          	jal	80002742 <brelse>
    if (ip) {
    80002fae:	bf7d                	j	80002f6c <ireclaim+0x6e>
}
    80002fb0:	70e2                	ld	ra,56(sp)
    80002fb2:	7442                	ld	s0,48(sp)
    80002fb4:	74a2                	ld	s1,40(sp)
    80002fb6:	7902                	ld	s2,32(sp)
    80002fb8:	69e2                	ld	s3,24(sp)
    80002fba:	6a42                	ld	s4,16(sp)
    80002fbc:	6aa2                	ld	s5,8(sp)
    80002fbe:	6b02                	ld	s6,0(sp)
    80002fc0:	6121                	addi	sp,sp,64
    80002fc2:	8082                	ret
    80002fc4:	8082                	ret

0000000080002fc6 <fsinit>:
fsinit(int dev) {
    80002fc6:	1101                	addi	sp,sp,-32
    80002fc8:	ec06                	sd	ra,24(sp)
    80002fca:	e822                	sd	s0,16(sp)
    80002fcc:	e426                	sd	s1,8(sp)
    80002fce:	e04a                	sd	s2,0(sp)
    80002fd0:	1000                	addi	s0,sp,32
    80002fd2:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002fd4:	4585                	li	a1,1
    80002fd6:	e64ff0ef          	jal	8000263a <bread>
    80002fda:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002fdc:	02000613          	li	a2,32
    80002fe0:	05850593          	addi	a1,a0,88
    80002fe4:	00016517          	auipc	a0,0x16
    80002fe8:	37450513          	addi	a0,a0,884 # 80019358 <sb>
    80002fec:	b10fd0ef          	jal	800002fc <memmove>
  brelse(bp);
    80002ff0:	8526                	mv	a0,s1
    80002ff2:	f50ff0ef          	jal	80002742 <brelse>
  if(sb.magic != FSMAGIC)
    80002ff6:	00016717          	auipc	a4,0x16
    80002ffa:	36272703          	lw	a4,866(a4) # 80019358 <sb>
    80002ffe:	102037b7          	lui	a5,0x10203
    80003002:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80003006:	02f71263          	bne	a4,a5,8000302a <fsinit+0x64>
  initlog(dev, &sb);
    8000300a:	00016597          	auipc	a1,0x16
    8000300e:	34e58593          	addi	a1,a1,846 # 80019358 <sb>
    80003012:	854a                	mv	a0,s2
    80003014:	648000ef          	jal	8000365c <initlog>
  ireclaim(dev);
    80003018:	854a                	mv	a0,s2
    8000301a:	ee5ff0ef          	jal	80002efe <ireclaim>
}
    8000301e:	60e2                	ld	ra,24(sp)
    80003020:	6442                	ld	s0,16(sp)
    80003022:	64a2                	ld	s1,8(sp)
    80003024:	6902                	ld	s2,0(sp)
    80003026:	6105                	addi	sp,sp,32
    80003028:	8082                	ret
    panic("invalid file system");
    8000302a:	00005517          	auipc	a0,0x5
    8000302e:	54650513          	addi	a0,a0,1350 # 80008570 <etext+0x570>
    80003032:	485020ef          	jal	80005cb6 <panic>

0000000080003036 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80003036:	1141                	addi	sp,sp,-16
    80003038:	e406                	sd	ra,8(sp)
    8000303a:	e022                	sd	s0,0(sp)
    8000303c:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    8000303e:	411c                	lw	a5,0(a0)
    80003040:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80003042:	415c                	lw	a5,4(a0)
    80003044:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80003046:	04451783          	lh	a5,68(a0)
    8000304a:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    8000304e:	04a51783          	lh	a5,74(a0)
    80003052:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80003056:	04c56783          	lwu	a5,76(a0)
    8000305a:	e99c                	sd	a5,16(a1)
}
    8000305c:	60a2                	ld	ra,8(sp)
    8000305e:	6402                	ld	s0,0(sp)
    80003060:	0141                	addi	sp,sp,16
    80003062:	8082                	ret

0000000080003064 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003064:	457c                	lw	a5,76(a0)
    80003066:	0ed7e663          	bltu	a5,a3,80003152 <readi+0xee>
{
    8000306a:	7159                	addi	sp,sp,-112
    8000306c:	f486                	sd	ra,104(sp)
    8000306e:	f0a2                	sd	s0,96(sp)
    80003070:	eca6                	sd	s1,88(sp)
    80003072:	e0d2                	sd	s4,64(sp)
    80003074:	fc56                	sd	s5,56(sp)
    80003076:	f85a                	sd	s6,48(sp)
    80003078:	f45e                	sd	s7,40(sp)
    8000307a:	1880                	addi	s0,sp,112
    8000307c:	8b2a                	mv	s6,a0
    8000307e:	8bae                	mv	s7,a1
    80003080:	8a32                	mv	s4,a2
    80003082:	84b6                	mv	s1,a3
    80003084:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80003086:	9f35                	addw	a4,a4,a3
    return 0;
    80003088:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    8000308a:	0ad76b63          	bltu	a4,a3,80003140 <readi+0xdc>
    8000308e:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80003090:	00e7f463          	bgeu	a5,a4,80003098 <readi+0x34>
    n = ip->size - off;
    80003094:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80003098:	080a8b63          	beqz	s5,8000312e <readi+0xca>
    8000309c:	e8ca                	sd	s2,80(sp)
    8000309e:	f062                	sd	s8,32(sp)
    800030a0:	ec66                	sd	s9,24(sp)
    800030a2:	e86a                	sd	s10,16(sp)
    800030a4:	e46e                	sd	s11,8(sp)
    800030a6:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    800030a8:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    800030ac:	5c7d                	li	s8,-1
    800030ae:	a80d                	j	800030e0 <readi+0x7c>
    800030b0:	020d1d93          	slli	s11,s10,0x20
    800030b4:	020ddd93          	srli	s11,s11,0x20
    800030b8:	05890613          	addi	a2,s2,88
    800030bc:	86ee                	mv	a3,s11
    800030be:	963e                	add	a2,a2,a5
    800030c0:	85d2                	mv	a1,s4
    800030c2:	855e                	mv	a0,s7
    800030c4:	c4bfe0ef          	jal	80001d0e <either_copyout>
    800030c8:	05850363          	beq	a0,s8,8000310e <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    800030cc:	854a                	mv	a0,s2
    800030ce:	e74ff0ef          	jal	80002742 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    800030d2:	013d09bb          	addw	s3,s10,s3
    800030d6:	009d04bb          	addw	s1,s10,s1
    800030da:	9a6e                	add	s4,s4,s11
    800030dc:	0559f363          	bgeu	s3,s5,80003122 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    800030e0:	00a4d59b          	srliw	a1,s1,0xa
    800030e4:	855a                	mv	a0,s6
    800030e6:	8bbff0ef          	jal	800029a0 <bmap>
    800030ea:	85aa                	mv	a1,a0
    if(addr == 0)
    800030ec:	c139                	beqz	a0,80003132 <readi+0xce>
    bp = bread(ip->dev, addr);
    800030ee:	000b2503          	lw	a0,0(s6)
    800030f2:	d48ff0ef          	jal	8000263a <bread>
    800030f6:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800030f8:	3ff4f793          	andi	a5,s1,1023
    800030fc:	40fc873b          	subw	a4,s9,a5
    80003100:	413a86bb          	subw	a3,s5,s3
    80003104:	8d3a                	mv	s10,a4
    80003106:	fae6f5e3          	bgeu	a3,a4,800030b0 <readi+0x4c>
    8000310a:	8d36                	mv	s10,a3
    8000310c:	b755                	j	800030b0 <readi+0x4c>
      brelse(bp);
    8000310e:	854a                	mv	a0,s2
    80003110:	e32ff0ef          	jal	80002742 <brelse>
      tot = -1;
    80003114:	59fd                	li	s3,-1
      break;
    80003116:	6946                	ld	s2,80(sp)
    80003118:	7c02                	ld	s8,32(sp)
    8000311a:	6ce2                	ld	s9,24(sp)
    8000311c:	6d42                	ld	s10,16(sp)
    8000311e:	6da2                	ld	s11,8(sp)
    80003120:	a831                	j	8000313c <readi+0xd8>
    80003122:	6946                	ld	s2,80(sp)
    80003124:	7c02                	ld	s8,32(sp)
    80003126:	6ce2                	ld	s9,24(sp)
    80003128:	6d42                	ld	s10,16(sp)
    8000312a:	6da2                	ld	s11,8(sp)
    8000312c:	a801                	j	8000313c <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    8000312e:	89d6                	mv	s3,s5
    80003130:	a031                	j	8000313c <readi+0xd8>
    80003132:	6946                	ld	s2,80(sp)
    80003134:	7c02                	ld	s8,32(sp)
    80003136:	6ce2                	ld	s9,24(sp)
    80003138:	6d42                	ld	s10,16(sp)
    8000313a:	6da2                	ld	s11,8(sp)
  }
  return tot;
    8000313c:	854e                	mv	a0,s3
    8000313e:	69a6                	ld	s3,72(sp)
}
    80003140:	70a6                	ld	ra,104(sp)
    80003142:	7406                	ld	s0,96(sp)
    80003144:	64e6                	ld	s1,88(sp)
    80003146:	6a06                	ld	s4,64(sp)
    80003148:	7ae2                	ld	s5,56(sp)
    8000314a:	7b42                	ld	s6,48(sp)
    8000314c:	7ba2                	ld	s7,40(sp)
    8000314e:	6165                	addi	sp,sp,112
    80003150:	8082                	ret
    return 0;
    80003152:	4501                	li	a0,0
}
    80003154:	8082                	ret

0000000080003156 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80003156:	457c                	lw	a5,76(a0)
    80003158:	0ed7eb63          	bltu	a5,a3,8000324e <writei+0xf8>
{
    8000315c:	7159                	addi	sp,sp,-112
    8000315e:	f486                	sd	ra,104(sp)
    80003160:	f0a2                	sd	s0,96(sp)
    80003162:	e8ca                	sd	s2,80(sp)
    80003164:	e0d2                	sd	s4,64(sp)
    80003166:	fc56                	sd	s5,56(sp)
    80003168:	f85a                	sd	s6,48(sp)
    8000316a:	f45e                	sd	s7,40(sp)
    8000316c:	1880                	addi	s0,sp,112
    8000316e:	8aaa                	mv	s5,a0
    80003170:	8bae                	mv	s7,a1
    80003172:	8a32                	mv	s4,a2
    80003174:	8936                	mv	s2,a3
    80003176:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80003178:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    8000317c:	00043737          	lui	a4,0x43
    80003180:	0cf76963          	bltu	a4,a5,80003252 <writei+0xfc>
    80003184:	0cd7e763          	bltu	a5,a3,80003252 <writei+0xfc>
    80003188:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000318a:	0a0b0a63          	beqz	s6,8000323e <writei+0xe8>
    8000318e:	eca6                	sd	s1,88(sp)
    80003190:	f062                	sd	s8,32(sp)
    80003192:	ec66                	sd	s9,24(sp)
    80003194:	e86a                	sd	s10,16(sp)
    80003196:	e46e                	sd	s11,8(sp)
    80003198:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    8000319a:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    8000319e:	5c7d                	li	s8,-1
    800031a0:	a825                	j	800031d8 <writei+0x82>
    800031a2:	020d1d93          	slli	s11,s10,0x20
    800031a6:	020ddd93          	srli	s11,s11,0x20
    800031aa:	05848513          	addi	a0,s1,88
    800031ae:	86ee                	mv	a3,s11
    800031b0:	8652                	mv	a2,s4
    800031b2:	85de                	mv	a1,s7
    800031b4:	953e                	add	a0,a0,a5
    800031b6:	ba3fe0ef          	jal	80001d58 <either_copyin>
    800031ba:	05850663          	beq	a0,s8,80003206 <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    800031be:	8526                	mv	a0,s1
    800031c0:	6b8000ef          	jal	80003878 <log_write>
    brelse(bp);
    800031c4:	8526                	mv	a0,s1
    800031c6:	d7cff0ef          	jal	80002742 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800031ca:	013d09bb          	addw	s3,s10,s3
    800031ce:	012d093b          	addw	s2,s10,s2
    800031d2:	9a6e                	add	s4,s4,s11
    800031d4:	0369fc63          	bgeu	s3,s6,8000320c <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    800031d8:	00a9559b          	srliw	a1,s2,0xa
    800031dc:	8556                	mv	a0,s5
    800031de:	fc2ff0ef          	jal	800029a0 <bmap>
    800031e2:	85aa                	mv	a1,a0
    if(addr == 0)
    800031e4:	c505                	beqz	a0,8000320c <writei+0xb6>
    bp = bread(ip->dev, addr);
    800031e6:	000aa503          	lw	a0,0(s5)
    800031ea:	c50ff0ef          	jal	8000263a <bread>
    800031ee:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    800031f0:	3ff97793          	andi	a5,s2,1023
    800031f4:	40fc873b          	subw	a4,s9,a5
    800031f8:	413b06bb          	subw	a3,s6,s3
    800031fc:	8d3a                	mv	s10,a4
    800031fe:	fae6f2e3          	bgeu	a3,a4,800031a2 <writei+0x4c>
    80003202:	8d36                	mv	s10,a3
    80003204:	bf79                	j	800031a2 <writei+0x4c>
      brelse(bp);
    80003206:	8526                	mv	a0,s1
    80003208:	d3aff0ef          	jal	80002742 <brelse>
  }

  if(off > ip->size)
    8000320c:	04caa783          	lw	a5,76(s5)
    80003210:	0327f963          	bgeu	a5,s2,80003242 <writei+0xec>
    ip->size = off;
    80003214:	052aa623          	sw	s2,76(s5)
    80003218:	64e6                	ld	s1,88(sp)
    8000321a:	7c02                	ld	s8,32(sp)
    8000321c:	6ce2                	ld	s9,24(sp)
    8000321e:	6d42                	ld	s10,16(sp)
    80003220:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80003222:	8556                	mv	a0,s5
    80003224:	9fbff0ef          	jal	80002c1e <iupdate>

  return tot;
    80003228:	854e                	mv	a0,s3
    8000322a:	69a6                	ld	s3,72(sp)
}
    8000322c:	70a6                	ld	ra,104(sp)
    8000322e:	7406                	ld	s0,96(sp)
    80003230:	6946                	ld	s2,80(sp)
    80003232:	6a06                	ld	s4,64(sp)
    80003234:	7ae2                	ld	s5,56(sp)
    80003236:	7b42                	ld	s6,48(sp)
    80003238:	7ba2                	ld	s7,40(sp)
    8000323a:	6165                	addi	sp,sp,112
    8000323c:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    8000323e:	89da                	mv	s3,s6
    80003240:	b7cd                	j	80003222 <writei+0xcc>
    80003242:	64e6                	ld	s1,88(sp)
    80003244:	7c02                	ld	s8,32(sp)
    80003246:	6ce2                	ld	s9,24(sp)
    80003248:	6d42                	ld	s10,16(sp)
    8000324a:	6da2                	ld	s11,8(sp)
    8000324c:	bfd9                	j	80003222 <writei+0xcc>
    return -1;
    8000324e:	557d                	li	a0,-1
}
    80003250:	8082                	ret
    return -1;
    80003252:	557d                	li	a0,-1
    80003254:	bfe1                	j	8000322c <writei+0xd6>

0000000080003256 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80003256:	1141                	addi	sp,sp,-16
    80003258:	e406                	sd	ra,8(sp)
    8000325a:	e022                	sd	s0,0(sp)
    8000325c:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    8000325e:	4639                	li	a2,14
    80003260:	910fd0ef          	jal	80000370 <strncmp>
}
    80003264:	60a2                	ld	ra,8(sp)
    80003266:	6402                	ld	s0,0(sp)
    80003268:	0141                	addi	sp,sp,16
    8000326a:	8082                	ret

000000008000326c <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000326c:	711d                	addi	sp,sp,-96
    8000326e:	ec86                	sd	ra,88(sp)
    80003270:	e8a2                	sd	s0,80(sp)
    80003272:	e4a6                	sd	s1,72(sp)
    80003274:	e0ca                	sd	s2,64(sp)
    80003276:	fc4e                	sd	s3,56(sp)
    80003278:	f852                	sd	s4,48(sp)
    8000327a:	f456                	sd	s5,40(sp)
    8000327c:	f05a                	sd	s6,32(sp)
    8000327e:	ec5e                	sd	s7,24(sp)
    80003280:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003282:	04451703          	lh	a4,68(a0)
    80003286:	4785                	li	a5,1
    80003288:	00f71f63          	bne	a4,a5,800032a6 <dirlookup+0x3a>
    8000328c:	892a                	mv	s2,a0
    8000328e:	8aae                	mv	s5,a1
    80003290:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003292:	457c                	lw	a5,76(a0)
    80003294:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003296:	fa040a13          	addi	s4,s0,-96
    8000329a:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    8000329c:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    800032a0:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032a2:	e39d                	bnez	a5,800032c8 <dirlookup+0x5c>
    800032a4:	a8b9                	j	80003302 <dirlookup+0x96>
    panic("dirlookup not DIR");
    800032a6:	00005517          	auipc	a0,0x5
    800032aa:	2e250513          	addi	a0,a0,738 # 80008588 <etext+0x588>
    800032ae:	209020ef          	jal	80005cb6 <panic>
      panic("dirlookup read");
    800032b2:	00005517          	auipc	a0,0x5
    800032b6:	2ee50513          	addi	a0,a0,750 # 800085a0 <etext+0x5a0>
    800032ba:	1fd020ef          	jal	80005cb6 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800032be:	24c1                	addiw	s1,s1,16
    800032c0:	04c92783          	lw	a5,76(s2)
    800032c4:	02f4fe63          	bgeu	s1,a5,80003300 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032c8:	874e                	mv	a4,s3
    800032ca:	86a6                	mv	a3,s1
    800032cc:	8652                	mv	a2,s4
    800032ce:	4581                	li	a1,0
    800032d0:	854a                	mv	a0,s2
    800032d2:	d93ff0ef          	jal	80003064 <readi>
    800032d6:	fd351ee3          	bne	a0,s3,800032b2 <dirlookup+0x46>
    if(de.inum == 0)
    800032da:	fa045783          	lhu	a5,-96(s0)
    800032de:	d3e5                	beqz	a5,800032be <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    800032e0:	85da                	mv	a1,s6
    800032e2:	8556                	mv	a0,s5
    800032e4:	f73ff0ef          	jal	80003256 <namecmp>
    800032e8:	f979                	bnez	a0,800032be <dirlookup+0x52>
      if(poff)
    800032ea:	000b8463          	beqz	s7,800032f2 <dirlookup+0x86>
        *poff = off;
    800032ee:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    800032f2:	fa045583          	lhu	a1,-96(s0)
    800032f6:	00092503          	lw	a0,0(s2)
    800032fa:	f66ff0ef          	jal	80002a60 <iget>
    800032fe:	a011                	j	80003302 <dirlookup+0x96>
  return 0;
    80003300:	4501                	li	a0,0
}
    80003302:	60e6                	ld	ra,88(sp)
    80003304:	6446                	ld	s0,80(sp)
    80003306:	64a6                	ld	s1,72(sp)
    80003308:	6906                	ld	s2,64(sp)
    8000330a:	79e2                	ld	s3,56(sp)
    8000330c:	7a42                	ld	s4,48(sp)
    8000330e:	7aa2                	ld	s5,40(sp)
    80003310:	7b02                	ld	s6,32(sp)
    80003312:	6be2                	ld	s7,24(sp)
    80003314:	6125                	addi	sp,sp,96
    80003316:	8082                	ret

0000000080003318 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80003318:	711d                	addi	sp,sp,-96
    8000331a:	ec86                	sd	ra,88(sp)
    8000331c:	e8a2                	sd	s0,80(sp)
    8000331e:	e4a6                	sd	s1,72(sp)
    80003320:	e0ca                	sd	s2,64(sp)
    80003322:	fc4e                	sd	s3,56(sp)
    80003324:	f852                	sd	s4,48(sp)
    80003326:	f456                	sd	s5,40(sp)
    80003328:	f05a                	sd	s6,32(sp)
    8000332a:	ec5e                	sd	s7,24(sp)
    8000332c:	e862                	sd	s8,16(sp)
    8000332e:	e466                	sd	s9,8(sp)
    80003330:	e06a                	sd	s10,0(sp)
    80003332:	1080                	addi	s0,sp,96
    80003334:	84aa                	mv	s1,a0
    80003336:	8b2e                	mv	s6,a1
    80003338:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    8000333a:	00054703          	lbu	a4,0(a0)
    8000333e:	02f00793          	li	a5,47
    80003342:	00f70f63          	beq	a4,a5,80003360 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80003346:	ffbfd0ef          	jal	80001340 <myproc>
    8000334a:	15853503          	ld	a0,344(a0)
    8000334e:	94fff0ef          	jal	80002c9c <idup>
    80003352:	8a2a                	mv	s4,a0
  while(*path == '/')
    80003354:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80003358:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    8000335a:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    8000335c:	4b85                	li	s7,1
    8000335e:	a879                	j	800033fc <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80003360:	4585                	li	a1,1
    80003362:	852e                	mv	a0,a1
    80003364:	efcff0ef          	jal	80002a60 <iget>
    80003368:	8a2a                	mv	s4,a0
    8000336a:	b7ed                	j	80003354 <namex+0x3c>
      iunlockput(ip);
    8000336c:	8552                	mv	a0,s4
    8000336e:	b71ff0ef          	jal	80002ede <iunlockput>
      return 0;
    80003372:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80003374:	8552                	mv	a0,s4
    80003376:	60e6                	ld	ra,88(sp)
    80003378:	6446                	ld	s0,80(sp)
    8000337a:	64a6                	ld	s1,72(sp)
    8000337c:	6906                	ld	s2,64(sp)
    8000337e:	79e2                	ld	s3,56(sp)
    80003380:	7a42                	ld	s4,48(sp)
    80003382:	7aa2                	ld	s5,40(sp)
    80003384:	7b02                	ld	s6,32(sp)
    80003386:	6be2                	ld	s7,24(sp)
    80003388:	6c42                	ld	s8,16(sp)
    8000338a:	6ca2                	ld	s9,8(sp)
    8000338c:	6d02                	ld	s10,0(sp)
    8000338e:	6125                	addi	sp,sp,96
    80003390:	8082                	ret
      iunlock(ip);
    80003392:	8552                	mv	a0,s4
    80003394:	9edff0ef          	jal	80002d80 <iunlock>
      return ip;
    80003398:	bff1                	j	80003374 <namex+0x5c>
      iunlockput(ip);
    8000339a:	8552                	mv	a0,s4
    8000339c:	b43ff0ef          	jal	80002ede <iunlockput>
      return 0;
    800033a0:	8a4a                	mv	s4,s2
    800033a2:	bfc9                	j	80003374 <namex+0x5c>
  len = path - s;
    800033a4:	40990633          	sub	a2,s2,s1
    800033a8:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    800033ac:	09ac5463          	bge	s8,s10,80003434 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    800033b0:	8666                	mv	a2,s9
    800033b2:	85a6                	mv	a1,s1
    800033b4:	8556                	mv	a0,s5
    800033b6:	f47fc0ef          	jal	800002fc <memmove>
    800033ba:	84ca                	mv	s1,s2
  while(*path == '/')
    800033bc:	0004c783          	lbu	a5,0(s1)
    800033c0:	01379763          	bne	a5,s3,800033ce <namex+0xb6>
    path++;
    800033c4:	0485                	addi	s1,s1,1
  while(*path == '/')
    800033c6:	0004c783          	lbu	a5,0(s1)
    800033ca:	ff378de3          	beq	a5,s3,800033c4 <namex+0xac>
    ilock(ip);
    800033ce:	8552                	mv	a0,s4
    800033d0:	903ff0ef          	jal	80002cd2 <ilock>
    if(ip->type != T_DIR){
    800033d4:	044a1783          	lh	a5,68(s4)
    800033d8:	f9779ae3          	bne	a5,s7,8000336c <namex+0x54>
    if(nameiparent && *path == '\0'){
    800033dc:	000b0563          	beqz	s6,800033e6 <namex+0xce>
    800033e0:	0004c783          	lbu	a5,0(s1)
    800033e4:	d7dd                	beqz	a5,80003392 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    800033e6:	4601                	li	a2,0
    800033e8:	85d6                	mv	a1,s5
    800033ea:	8552                	mv	a0,s4
    800033ec:	e81ff0ef          	jal	8000326c <dirlookup>
    800033f0:	892a                	mv	s2,a0
    800033f2:	d545                	beqz	a0,8000339a <namex+0x82>
    iunlockput(ip);
    800033f4:	8552                	mv	a0,s4
    800033f6:	ae9ff0ef          	jal	80002ede <iunlockput>
    ip = next;
    800033fa:	8a4a                	mv	s4,s2
  while(*path == '/')
    800033fc:	0004c783          	lbu	a5,0(s1)
    80003400:	01379763          	bne	a5,s3,8000340e <namex+0xf6>
    path++;
    80003404:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003406:	0004c783          	lbu	a5,0(s1)
    8000340a:	ff378de3          	beq	a5,s3,80003404 <namex+0xec>
  if(*path == 0)
    8000340e:	cf8d                	beqz	a5,80003448 <namex+0x130>
  while(*path != '/' && *path != 0)
    80003410:	0004c783          	lbu	a5,0(s1)
    80003414:	fd178713          	addi	a4,a5,-47
    80003418:	cb19                	beqz	a4,8000342e <namex+0x116>
    8000341a:	cb91                	beqz	a5,8000342e <namex+0x116>
    8000341c:	8926                	mv	s2,s1
    path++;
    8000341e:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80003420:	00094783          	lbu	a5,0(s2)
    80003424:	fd178713          	addi	a4,a5,-47
    80003428:	df35                	beqz	a4,800033a4 <namex+0x8c>
    8000342a:	fbf5                	bnez	a5,8000341e <namex+0x106>
    8000342c:	bfa5                	j	800033a4 <namex+0x8c>
    8000342e:	8926                	mv	s2,s1
  len = path - s;
    80003430:	4d01                	li	s10,0
    80003432:	4601                	li	a2,0
    memmove(name, s, len);
    80003434:	2601                	sext.w	a2,a2
    80003436:	85a6                	mv	a1,s1
    80003438:	8556                	mv	a0,s5
    8000343a:	ec3fc0ef          	jal	800002fc <memmove>
    name[len] = 0;
    8000343e:	9d56                	add	s10,s10,s5
    80003440:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7ffdaec8>
    80003444:	84ca                	mv	s1,s2
    80003446:	bf9d                	j	800033bc <namex+0xa4>
  if(nameiparent){
    80003448:	f20b06e3          	beqz	s6,80003374 <namex+0x5c>
    iput(ip);
    8000344c:	8552                	mv	a0,s4
    8000344e:	a07ff0ef          	jal	80002e54 <iput>
    return 0;
    80003452:	4a01                	li	s4,0
    80003454:	b705                	j	80003374 <namex+0x5c>

0000000080003456 <dirlink>:
{
    80003456:	715d                	addi	sp,sp,-80
    80003458:	e486                	sd	ra,72(sp)
    8000345a:	e0a2                	sd	s0,64(sp)
    8000345c:	f84a                	sd	s2,48(sp)
    8000345e:	ec56                	sd	s5,24(sp)
    80003460:	e85a                	sd	s6,16(sp)
    80003462:	0880                	addi	s0,sp,80
    80003464:	892a                	mv	s2,a0
    80003466:	8aae                	mv	s5,a1
    80003468:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000346a:	4601                	li	a2,0
    8000346c:	e01ff0ef          	jal	8000326c <dirlookup>
    80003470:	ed1d                	bnez	a0,800034ae <dirlink+0x58>
    80003472:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003474:	04c92483          	lw	s1,76(s2)
    80003478:	c4b9                	beqz	s1,800034c6 <dirlink+0x70>
    8000347a:	f44e                	sd	s3,40(sp)
    8000347c:	f052                	sd	s4,32(sp)
    8000347e:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003480:	fb040a13          	addi	s4,s0,-80
    80003484:	49c1                	li	s3,16
    80003486:	874e                	mv	a4,s3
    80003488:	86a6                	mv	a3,s1
    8000348a:	8652                	mv	a2,s4
    8000348c:	4581                	li	a1,0
    8000348e:	854a                	mv	a0,s2
    80003490:	bd5ff0ef          	jal	80003064 <readi>
    80003494:	03351163          	bne	a0,s3,800034b6 <dirlink+0x60>
    if(de.inum == 0)
    80003498:	fb045783          	lhu	a5,-80(s0)
    8000349c:	c39d                	beqz	a5,800034c2 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000349e:	24c1                	addiw	s1,s1,16
    800034a0:	04c92783          	lw	a5,76(s2)
    800034a4:	fef4e1e3          	bltu	s1,a5,80003486 <dirlink+0x30>
    800034a8:	79a2                	ld	s3,40(sp)
    800034aa:	7a02                	ld	s4,32(sp)
    800034ac:	a829                	j	800034c6 <dirlink+0x70>
    iput(ip);
    800034ae:	9a7ff0ef          	jal	80002e54 <iput>
    return -1;
    800034b2:	557d                	li	a0,-1
    800034b4:	a83d                	j	800034f2 <dirlink+0x9c>
      panic("dirlink read");
    800034b6:	00005517          	auipc	a0,0x5
    800034ba:	0fa50513          	addi	a0,a0,250 # 800085b0 <etext+0x5b0>
    800034be:	7f8020ef          	jal	80005cb6 <panic>
    800034c2:	79a2                	ld	s3,40(sp)
    800034c4:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800034c6:	4639                	li	a2,14
    800034c8:	85d6                	mv	a1,s5
    800034ca:	fb240513          	addi	a0,s0,-78
    800034ce:	eddfc0ef          	jal	800003aa <strncpy>
  de.inum = inum;
    800034d2:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800034d6:	4741                	li	a4,16
    800034d8:	86a6                	mv	a3,s1
    800034da:	fb040613          	addi	a2,s0,-80
    800034de:	4581                	li	a1,0
    800034e0:	854a                	mv	a0,s2
    800034e2:	c75ff0ef          	jal	80003156 <writei>
    800034e6:	1541                	addi	a0,a0,-16
    800034e8:	00a03533          	snez	a0,a0
    800034ec:	40a0053b          	negw	a0,a0
    800034f0:	74e2                	ld	s1,56(sp)
}
    800034f2:	60a6                	ld	ra,72(sp)
    800034f4:	6406                	ld	s0,64(sp)
    800034f6:	7942                	ld	s2,48(sp)
    800034f8:	6ae2                	ld	s5,24(sp)
    800034fa:	6b42                	ld	s6,16(sp)
    800034fc:	6161                	addi	sp,sp,80
    800034fe:	8082                	ret

0000000080003500 <namei>:

struct inode*
namei(char *path)
{
    80003500:	1101                	addi	sp,sp,-32
    80003502:	ec06                	sd	ra,24(sp)
    80003504:	e822                	sd	s0,16(sp)
    80003506:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    80003508:	fe040613          	addi	a2,s0,-32
    8000350c:	4581                	li	a1,0
    8000350e:	e0bff0ef          	jal	80003318 <namex>
}
    80003512:	60e2                	ld	ra,24(sp)
    80003514:	6442                	ld	s0,16(sp)
    80003516:	6105                	addi	sp,sp,32
    80003518:	8082                	ret

000000008000351a <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000351a:	1141                	addi	sp,sp,-16
    8000351c:	e406                	sd	ra,8(sp)
    8000351e:	e022                	sd	s0,0(sp)
    80003520:	0800                	addi	s0,sp,16
    80003522:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003524:	4585                	li	a1,1
    80003526:	df3ff0ef          	jal	80003318 <namex>
}
    8000352a:	60a2                	ld	ra,8(sp)
    8000352c:	6402                	ld	s0,0(sp)
    8000352e:	0141                	addi	sp,sp,16
    80003530:	8082                	ret

0000000080003532 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003532:	1101                	addi	sp,sp,-32
    80003534:	ec06                	sd	ra,24(sp)
    80003536:	e822                	sd	s0,16(sp)
    80003538:	e426                	sd	s1,8(sp)
    8000353a:	e04a                	sd	s2,0(sp)
    8000353c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000353e:	00018917          	auipc	s2,0x18
    80003542:	8e290913          	addi	s2,s2,-1822 # 8001ae20 <log>
    80003546:	01892583          	lw	a1,24(s2)
    8000354a:	02492503          	lw	a0,36(s2)
    8000354e:	8ecff0ef          	jal	8000263a <bread>
    80003552:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003554:	02892603          	lw	a2,40(s2)
    80003558:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000355a:	00c05f63          	blez	a2,80003578 <write_head+0x46>
    8000355e:	00018717          	auipc	a4,0x18
    80003562:	8ee70713          	addi	a4,a4,-1810 # 8001ae4c <log+0x2c>
    80003566:	87aa                	mv	a5,a0
    80003568:	060a                	slli	a2,a2,0x2
    8000356a:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    8000356c:	4314                	lw	a3,0(a4)
    8000356e:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    80003570:	0711                	addi	a4,a4,4
    80003572:	0791                	addi	a5,a5,4
    80003574:	fec79ce3          	bne	a5,a2,8000356c <write_head+0x3a>
  }
  bwrite(buf);
    80003578:	8526                	mv	a0,s1
    8000357a:	996ff0ef          	jal	80002710 <bwrite>
  brelse(buf);
    8000357e:	8526                	mv	a0,s1
    80003580:	9c2ff0ef          	jal	80002742 <brelse>
}
    80003584:	60e2                	ld	ra,24(sp)
    80003586:	6442                	ld	s0,16(sp)
    80003588:	64a2                	ld	s1,8(sp)
    8000358a:	6902                	ld	s2,0(sp)
    8000358c:	6105                	addi	sp,sp,32
    8000358e:	8082                	ret

0000000080003590 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003590:	00018797          	auipc	a5,0x18
    80003594:	8b87a783          	lw	a5,-1864(a5) # 8001ae48 <log+0x28>
    80003598:	0cf05163          	blez	a5,8000365a <install_trans+0xca>
{
    8000359c:	715d                	addi	sp,sp,-80
    8000359e:	e486                	sd	ra,72(sp)
    800035a0:	e0a2                	sd	s0,64(sp)
    800035a2:	fc26                	sd	s1,56(sp)
    800035a4:	f84a                	sd	s2,48(sp)
    800035a6:	f44e                	sd	s3,40(sp)
    800035a8:	f052                	sd	s4,32(sp)
    800035aa:	ec56                	sd	s5,24(sp)
    800035ac:	e85a                	sd	s6,16(sp)
    800035ae:	e45e                	sd	s7,8(sp)
    800035b0:	e062                	sd	s8,0(sp)
    800035b2:	0880                	addi	s0,sp,80
    800035b4:	8b2a                	mv	s6,a0
    800035b6:	00018a97          	auipc	s5,0x18
    800035ba:	896a8a93          	addi	s5,s5,-1898 # 8001ae4c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035be:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800035c0:	00005c17          	auipc	s8,0x5
    800035c4:	000c0c13          	mv	s8,s8
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800035c8:	00018a17          	auipc	s4,0x18
    800035cc:	858a0a13          	addi	s4,s4,-1960 # 8001ae20 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800035d0:	40000b93          	li	s7,1024
    800035d4:	a025                	j	800035fc <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800035d6:	000aa603          	lw	a2,0(s5)
    800035da:	85ce                	mv	a1,s3
    800035dc:	8562                	mv	a0,s8
    800035de:	3ae020ef          	jal	8000598c <printf>
    800035e2:	a839                	j	80003600 <install_trans+0x70>
    brelse(lbuf);
    800035e4:	854a                	mv	a0,s2
    800035e6:	95cff0ef          	jal	80002742 <brelse>
    brelse(dbuf);
    800035ea:	8526                	mv	a0,s1
    800035ec:	956ff0ef          	jal	80002742 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800035f0:	2985                	addiw	s3,s3,1
    800035f2:	0a91                	addi	s5,s5,4
    800035f4:	028a2783          	lw	a5,40(s4)
    800035f8:	04f9d563          	bge	s3,a5,80003642 <install_trans+0xb2>
    if(recovering) {
    800035fc:	fc0b1de3          	bnez	s6,800035d6 <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003600:	018a2583          	lw	a1,24(s4)
    80003604:	013585bb          	addw	a1,a1,s3
    80003608:	2585                	addiw	a1,a1,1
    8000360a:	024a2503          	lw	a0,36(s4)
    8000360e:	82cff0ef          	jal	8000263a <bread>
    80003612:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003614:	000aa583          	lw	a1,0(s5)
    80003618:	024a2503          	lw	a0,36(s4)
    8000361c:	81eff0ef          	jal	8000263a <bread>
    80003620:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003622:	865e                	mv	a2,s7
    80003624:	05890593          	addi	a1,s2,88
    80003628:	05850513          	addi	a0,a0,88
    8000362c:	cd1fc0ef          	jal	800002fc <memmove>
    bwrite(dbuf);  // write dst to disk
    80003630:	8526                	mv	a0,s1
    80003632:	8deff0ef          	jal	80002710 <bwrite>
    if(recovering == 0)
    80003636:	fa0b17e3          	bnez	s6,800035e4 <install_trans+0x54>
      bunpin(dbuf);
    8000363a:	8526                	mv	a0,s1
    8000363c:	9beff0ef          	jal	800027fa <bunpin>
    80003640:	b755                	j	800035e4 <install_trans+0x54>
}
    80003642:	60a6                	ld	ra,72(sp)
    80003644:	6406                	ld	s0,64(sp)
    80003646:	74e2                	ld	s1,56(sp)
    80003648:	7942                	ld	s2,48(sp)
    8000364a:	79a2                	ld	s3,40(sp)
    8000364c:	7a02                	ld	s4,32(sp)
    8000364e:	6ae2                	ld	s5,24(sp)
    80003650:	6b42                	ld	s6,16(sp)
    80003652:	6ba2                	ld	s7,8(sp)
    80003654:	6c02                	ld	s8,0(sp)
    80003656:	6161                	addi	sp,sp,80
    80003658:	8082                	ret
    8000365a:	8082                	ret

000000008000365c <initlog>:
{
    8000365c:	7179                	addi	sp,sp,-48
    8000365e:	f406                	sd	ra,40(sp)
    80003660:	f022                	sd	s0,32(sp)
    80003662:	ec26                	sd	s1,24(sp)
    80003664:	e84a                	sd	s2,16(sp)
    80003666:	e44e                	sd	s3,8(sp)
    80003668:	1800                	addi	s0,sp,48
    8000366a:	84aa                	mv	s1,a0
    8000366c:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000366e:	00017917          	auipc	s2,0x17
    80003672:	7b290913          	addi	s2,s2,1970 # 8001ae20 <log>
    80003676:	00005597          	auipc	a1,0x5
    8000367a:	f6a58593          	addi	a1,a1,-150 # 800085e0 <etext+0x5e0>
    8000367e:	854a                	mv	a0,s2
    80003680:	06f020ef          	jal	80005eee <initlock>
  log.start = sb->logstart;
    80003684:	0149a583          	lw	a1,20(s3)
    80003688:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    8000368c:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    80003690:	8526                	mv	a0,s1
    80003692:	fa9fe0ef          	jal	8000263a <bread>
  log.lh.n = lh->n;
    80003696:	4d30                	lw	a2,88(a0)
    80003698:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    8000369c:	00c05f63          	blez	a2,800036ba <initlog+0x5e>
    800036a0:	87aa                	mv	a5,a0
    800036a2:	00017717          	auipc	a4,0x17
    800036a6:	7aa70713          	addi	a4,a4,1962 # 8001ae4c <log+0x2c>
    800036aa:	060a                	slli	a2,a2,0x2
    800036ac:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800036ae:	4ff4                	lw	a3,92(a5)
    800036b0:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800036b2:	0791                	addi	a5,a5,4
    800036b4:	0711                	addi	a4,a4,4
    800036b6:	fec79ce3          	bne	a5,a2,800036ae <initlog+0x52>
  brelse(buf);
    800036ba:	888ff0ef          	jal	80002742 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800036be:	4505                	li	a0,1
    800036c0:	ed1ff0ef          	jal	80003590 <install_trans>
  log.lh.n = 0;
    800036c4:	00017797          	auipc	a5,0x17
    800036c8:	7807a223          	sw	zero,1924(a5) # 8001ae48 <log+0x28>
  write_head(); // clear the log
    800036cc:	e67ff0ef          	jal	80003532 <write_head>
}
    800036d0:	70a2                	ld	ra,40(sp)
    800036d2:	7402                	ld	s0,32(sp)
    800036d4:	64e2                	ld	s1,24(sp)
    800036d6:	6942                	ld	s2,16(sp)
    800036d8:	69a2                	ld	s3,8(sp)
    800036da:	6145                	addi	sp,sp,48
    800036dc:	8082                	ret

00000000800036de <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800036de:	1101                	addi	sp,sp,-32
    800036e0:	ec06                	sd	ra,24(sp)
    800036e2:	e822                	sd	s0,16(sp)
    800036e4:	e426                	sd	s1,8(sp)
    800036e6:	e04a                	sd	s2,0(sp)
    800036e8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800036ea:	00017517          	auipc	a0,0x17
    800036ee:	73650513          	addi	a0,a0,1846 # 8001ae20 <log>
    800036f2:	087020ef          	jal	80005f78 <acquire>
  while(1){
    if(log.committing){
    800036f6:	00017497          	auipc	s1,0x17
    800036fa:	72a48493          	addi	s1,s1,1834 # 8001ae20 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    800036fe:	4979                	li	s2,30
    80003700:	a029                	j	8000370a <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003702:	85a6                	mv	a1,s1
    80003704:	8526                	mv	a0,s1
    80003706:	aaefe0ef          	jal	800019b4 <sleep>
    if(log.committing){
    8000370a:	509c                	lw	a5,32(s1)
    8000370c:	fbfd                	bnez	a5,80003702 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    8000370e:	4cd8                	lw	a4,28(s1)
    80003710:	2705                	addiw	a4,a4,1
    80003712:	0027179b          	slliw	a5,a4,0x2
    80003716:	9fb9                	addw	a5,a5,a4
    80003718:	0017979b          	slliw	a5,a5,0x1
    8000371c:	5494                	lw	a3,40(s1)
    8000371e:	9fb5                	addw	a5,a5,a3
    80003720:	00f95763          	bge	s2,a5,8000372e <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003724:	85a6                	mv	a1,s1
    80003726:	8526                	mv	a0,s1
    80003728:	a8cfe0ef          	jal	800019b4 <sleep>
    8000372c:	bff9                	j	8000370a <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    8000372e:	00017797          	auipc	a5,0x17
    80003732:	70e7a723          	sw	a4,1806(a5) # 8001ae3c <log+0x1c>
      release(&log.lock);
    80003736:	00017517          	auipc	a0,0x17
    8000373a:	6ea50513          	addi	a0,a0,1770 # 8001ae20 <log>
    8000373e:	0cf020ef          	jal	8000600c <release>
      break;
    }
  }
}
    80003742:	60e2                	ld	ra,24(sp)
    80003744:	6442                	ld	s0,16(sp)
    80003746:	64a2                	ld	s1,8(sp)
    80003748:	6902                	ld	s2,0(sp)
    8000374a:	6105                	addi	sp,sp,32
    8000374c:	8082                	ret

000000008000374e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000374e:	7139                	addi	sp,sp,-64
    80003750:	fc06                	sd	ra,56(sp)
    80003752:	f822                	sd	s0,48(sp)
    80003754:	f426                	sd	s1,40(sp)
    80003756:	f04a                	sd	s2,32(sp)
    80003758:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000375a:	00017497          	auipc	s1,0x17
    8000375e:	6c648493          	addi	s1,s1,1734 # 8001ae20 <log>
    80003762:	8526                	mv	a0,s1
    80003764:	015020ef          	jal	80005f78 <acquire>
  log.outstanding -= 1;
    80003768:	4cdc                	lw	a5,28(s1)
    8000376a:	37fd                	addiw	a5,a5,-1
    8000376c:	893e                	mv	s2,a5
    8000376e:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    80003770:	509c                	lw	a5,32(s1)
    80003772:	e7b1                	bnez	a5,800037be <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    80003774:	04091e63          	bnez	s2,800037d0 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    80003778:	00017497          	auipc	s1,0x17
    8000377c:	6a848493          	addi	s1,s1,1704 # 8001ae20 <log>
    80003780:	4785                	li	a5,1
    80003782:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003784:	8526                	mv	a0,s1
    80003786:	087020ef          	jal	8000600c <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000378a:	549c                	lw	a5,40(s1)
    8000378c:	06f04463          	bgtz	a5,800037f4 <end_op+0xa6>
    acquire(&log.lock);
    80003790:	00017517          	auipc	a0,0x17
    80003794:	69050513          	addi	a0,a0,1680 # 8001ae20 <log>
    80003798:	7e0020ef          	jal	80005f78 <acquire>
    log.committing = 0;
    8000379c:	00017797          	auipc	a5,0x17
    800037a0:	6a07a223          	sw	zero,1700(a5) # 8001ae40 <log+0x20>
    wakeup(&log);
    800037a4:	00017517          	auipc	a0,0x17
    800037a8:	67c50513          	addi	a0,a0,1660 # 8001ae20 <log>
    800037ac:	a54fe0ef          	jal	80001a00 <wakeup>
    release(&log.lock);
    800037b0:	00017517          	auipc	a0,0x17
    800037b4:	67050513          	addi	a0,a0,1648 # 8001ae20 <log>
    800037b8:	055020ef          	jal	8000600c <release>
}
    800037bc:	a035                	j	800037e8 <end_op+0x9a>
    800037be:	ec4e                	sd	s3,24(sp)
    800037c0:	e852                	sd	s4,16(sp)
    800037c2:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800037c4:	00005517          	auipc	a0,0x5
    800037c8:	e2450513          	addi	a0,a0,-476 # 800085e8 <etext+0x5e8>
    800037cc:	4ea020ef          	jal	80005cb6 <panic>
    wakeup(&log);
    800037d0:	00017517          	auipc	a0,0x17
    800037d4:	65050513          	addi	a0,a0,1616 # 8001ae20 <log>
    800037d8:	a28fe0ef          	jal	80001a00 <wakeup>
  release(&log.lock);
    800037dc:	00017517          	auipc	a0,0x17
    800037e0:	64450513          	addi	a0,a0,1604 # 8001ae20 <log>
    800037e4:	029020ef          	jal	8000600c <release>
}
    800037e8:	70e2                	ld	ra,56(sp)
    800037ea:	7442                	ld	s0,48(sp)
    800037ec:	74a2                	ld	s1,40(sp)
    800037ee:	7902                	ld	s2,32(sp)
    800037f0:	6121                	addi	sp,sp,64
    800037f2:	8082                	ret
    800037f4:	ec4e                	sd	s3,24(sp)
    800037f6:	e852                	sd	s4,16(sp)
    800037f8:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    800037fa:	00017a97          	auipc	s5,0x17
    800037fe:	652a8a93          	addi	s5,s5,1618 # 8001ae4c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003802:	00017a17          	auipc	s4,0x17
    80003806:	61ea0a13          	addi	s4,s4,1566 # 8001ae20 <log>
    8000380a:	018a2583          	lw	a1,24(s4)
    8000380e:	012585bb          	addw	a1,a1,s2
    80003812:	2585                	addiw	a1,a1,1
    80003814:	024a2503          	lw	a0,36(s4)
    80003818:	e23fe0ef          	jal	8000263a <bread>
    8000381c:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    8000381e:	000aa583          	lw	a1,0(s5)
    80003822:	024a2503          	lw	a0,36(s4)
    80003826:	e15fe0ef          	jal	8000263a <bread>
    8000382a:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000382c:	40000613          	li	a2,1024
    80003830:	05850593          	addi	a1,a0,88
    80003834:	05848513          	addi	a0,s1,88
    80003838:	ac5fc0ef          	jal	800002fc <memmove>
    bwrite(to);  // write the log
    8000383c:	8526                	mv	a0,s1
    8000383e:	ed3fe0ef          	jal	80002710 <bwrite>
    brelse(from);
    80003842:	854e                	mv	a0,s3
    80003844:	efffe0ef          	jal	80002742 <brelse>
    brelse(to);
    80003848:	8526                	mv	a0,s1
    8000384a:	ef9fe0ef          	jal	80002742 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000384e:	2905                	addiw	s2,s2,1
    80003850:	0a91                	addi	s5,s5,4
    80003852:	028a2783          	lw	a5,40(s4)
    80003856:	faf94ae3          	blt	s2,a5,8000380a <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000385a:	cd9ff0ef          	jal	80003532 <write_head>
    install_trans(0); // Now install writes to home locations
    8000385e:	4501                	li	a0,0
    80003860:	d31ff0ef          	jal	80003590 <install_trans>
    log.lh.n = 0;
    80003864:	00017797          	auipc	a5,0x17
    80003868:	5e07a223          	sw	zero,1508(a5) # 8001ae48 <log+0x28>
    write_head();    // Erase the transaction from the log
    8000386c:	cc7ff0ef          	jal	80003532 <write_head>
    80003870:	69e2                	ld	s3,24(sp)
    80003872:	6a42                	ld	s4,16(sp)
    80003874:	6aa2                	ld	s5,8(sp)
    80003876:	bf29                	j	80003790 <end_op+0x42>

0000000080003878 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003878:	1101                	addi	sp,sp,-32
    8000387a:	ec06                	sd	ra,24(sp)
    8000387c:	e822                	sd	s0,16(sp)
    8000387e:	e426                	sd	s1,8(sp)
    80003880:	1000                	addi	s0,sp,32
    80003882:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    80003884:	00017517          	auipc	a0,0x17
    80003888:	59c50513          	addi	a0,a0,1436 # 8001ae20 <log>
    8000388c:	6ec020ef          	jal	80005f78 <acquire>
  if (log.lh.n >= LOGBLOCKS)
    80003890:	00017617          	auipc	a2,0x17
    80003894:	5b862603          	lw	a2,1464(a2) # 8001ae48 <log+0x28>
    80003898:	47f5                	li	a5,29
    8000389a:	04c7cd63          	blt	a5,a2,800038f4 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    8000389e:	00017797          	auipc	a5,0x17
    800038a2:	59e7a783          	lw	a5,1438(a5) # 8001ae3c <log+0x1c>
    800038a6:	04f05d63          	blez	a5,80003900 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800038aa:	4781                	li	a5,0
    800038ac:	06c05063          	blez	a2,8000390c <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038b0:	44cc                	lw	a1,12(s1)
    800038b2:	00017717          	auipc	a4,0x17
    800038b6:	59a70713          	addi	a4,a4,1434 # 8001ae4c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800038ba:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800038bc:	4314                	lw	a3,0(a4)
    800038be:	04b68763          	beq	a3,a1,8000390c <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    800038c2:	2785                	addiw	a5,a5,1
    800038c4:	0711                	addi	a4,a4,4
    800038c6:	fef61be3          	bne	a2,a5,800038bc <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800038ca:	060a                	slli	a2,a2,0x2
    800038cc:	02060613          	addi	a2,a2,32
    800038d0:	00017797          	auipc	a5,0x17
    800038d4:	55078793          	addi	a5,a5,1360 # 8001ae20 <log>
    800038d8:	97b2                	add	a5,a5,a2
    800038da:	44d8                	lw	a4,12(s1)
    800038dc:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800038de:	8526                	mv	a0,s1
    800038e0:	ee7fe0ef          	jal	800027c6 <bpin>
    log.lh.n++;
    800038e4:	00017717          	auipc	a4,0x17
    800038e8:	53c70713          	addi	a4,a4,1340 # 8001ae20 <log>
    800038ec:	571c                	lw	a5,40(a4)
    800038ee:	2785                	addiw	a5,a5,1
    800038f0:	d71c                	sw	a5,40(a4)
    800038f2:	a815                	j	80003926 <log_write+0xae>
    panic("too big a transaction");
    800038f4:	00005517          	auipc	a0,0x5
    800038f8:	d0450513          	addi	a0,a0,-764 # 800085f8 <etext+0x5f8>
    800038fc:	3ba020ef          	jal	80005cb6 <panic>
    panic("log_write outside of trans");
    80003900:	00005517          	auipc	a0,0x5
    80003904:	d1050513          	addi	a0,a0,-752 # 80008610 <etext+0x610>
    80003908:	3ae020ef          	jal	80005cb6 <panic>
  log.lh.block[i] = b->blockno;
    8000390c:	00279693          	slli	a3,a5,0x2
    80003910:	02068693          	addi	a3,a3,32
    80003914:	00017717          	auipc	a4,0x17
    80003918:	50c70713          	addi	a4,a4,1292 # 8001ae20 <log>
    8000391c:	9736                	add	a4,a4,a3
    8000391e:	44d4                	lw	a3,12(s1)
    80003920:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003922:	faf60ee3          	beq	a2,a5,800038de <log_write+0x66>
  }
  release(&log.lock);
    80003926:	00017517          	auipc	a0,0x17
    8000392a:	4fa50513          	addi	a0,a0,1274 # 8001ae20 <log>
    8000392e:	6de020ef          	jal	8000600c <release>
}
    80003932:	60e2                	ld	ra,24(sp)
    80003934:	6442                	ld	s0,16(sp)
    80003936:	64a2                	ld	s1,8(sp)
    80003938:	6105                	addi	sp,sp,32
    8000393a:	8082                	ret

000000008000393c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000393c:	1101                	addi	sp,sp,-32
    8000393e:	ec06                	sd	ra,24(sp)
    80003940:	e822                	sd	s0,16(sp)
    80003942:	e426                	sd	s1,8(sp)
    80003944:	e04a                	sd	s2,0(sp)
    80003946:	1000                	addi	s0,sp,32
    80003948:	84aa                	mv	s1,a0
    8000394a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000394c:	00005597          	auipc	a1,0x5
    80003950:	ce458593          	addi	a1,a1,-796 # 80008630 <etext+0x630>
    80003954:	0521                	addi	a0,a0,8
    80003956:	598020ef          	jal	80005eee <initlock>
  lk->name = name;
    8000395a:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000395e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003962:	0204a423          	sw	zero,40(s1)
}
    80003966:	60e2                	ld	ra,24(sp)
    80003968:	6442                	ld	s0,16(sp)
    8000396a:	64a2                	ld	s1,8(sp)
    8000396c:	6902                	ld	s2,0(sp)
    8000396e:	6105                	addi	sp,sp,32
    80003970:	8082                	ret

0000000080003972 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003972:	1101                	addi	sp,sp,-32
    80003974:	ec06                	sd	ra,24(sp)
    80003976:	e822                	sd	s0,16(sp)
    80003978:	e426                	sd	s1,8(sp)
    8000397a:	e04a                	sd	s2,0(sp)
    8000397c:	1000                	addi	s0,sp,32
    8000397e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003980:	00850913          	addi	s2,a0,8
    80003984:	854a                	mv	a0,s2
    80003986:	5f2020ef          	jal	80005f78 <acquire>
  while (lk->locked) {
    8000398a:	409c                	lw	a5,0(s1)
    8000398c:	c799                	beqz	a5,8000399a <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    8000398e:	85ca                	mv	a1,s2
    80003990:	8526                	mv	a0,s1
    80003992:	822fe0ef          	jal	800019b4 <sleep>
  while (lk->locked) {
    80003996:	409c                	lw	a5,0(s1)
    80003998:	fbfd                	bnez	a5,8000398e <acquiresleep+0x1c>
  }
  lk->locked = 1;
    8000399a:	4785                	li	a5,1
    8000399c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000399e:	9a3fd0ef          	jal	80001340 <myproc>
    800039a2:	591c                	lw	a5,48(a0)
    800039a4:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800039a6:	854a                	mv	a0,s2
    800039a8:	664020ef          	jal	8000600c <release>
}
    800039ac:	60e2                	ld	ra,24(sp)
    800039ae:	6442                	ld	s0,16(sp)
    800039b0:	64a2                	ld	s1,8(sp)
    800039b2:	6902                	ld	s2,0(sp)
    800039b4:	6105                	addi	sp,sp,32
    800039b6:	8082                	ret

00000000800039b8 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800039b8:	1101                	addi	sp,sp,-32
    800039ba:	ec06                	sd	ra,24(sp)
    800039bc:	e822                	sd	s0,16(sp)
    800039be:	e426                	sd	s1,8(sp)
    800039c0:	e04a                	sd	s2,0(sp)
    800039c2:	1000                	addi	s0,sp,32
    800039c4:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800039c6:	00850913          	addi	s2,a0,8
    800039ca:	854a                	mv	a0,s2
    800039cc:	5ac020ef          	jal	80005f78 <acquire>
  lk->locked = 0;
    800039d0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039d4:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039d8:	8526                	mv	a0,s1
    800039da:	826fe0ef          	jal	80001a00 <wakeup>
  release(&lk->lk);
    800039de:	854a                	mv	a0,s2
    800039e0:	62c020ef          	jal	8000600c <release>
}
    800039e4:	60e2                	ld	ra,24(sp)
    800039e6:	6442                	ld	s0,16(sp)
    800039e8:	64a2                	ld	s1,8(sp)
    800039ea:	6902                	ld	s2,0(sp)
    800039ec:	6105                	addi	sp,sp,32
    800039ee:	8082                	ret

00000000800039f0 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039f0:	7179                	addi	sp,sp,-48
    800039f2:	f406                	sd	ra,40(sp)
    800039f4:	f022                	sd	s0,32(sp)
    800039f6:	ec26                	sd	s1,24(sp)
    800039f8:	e84a                	sd	s2,16(sp)
    800039fa:	1800                	addi	s0,sp,48
    800039fc:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039fe:	00850913          	addi	s2,a0,8
    80003a02:	854a                	mv	a0,s2
    80003a04:	574020ef          	jal	80005f78 <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a08:	409c                	lw	a5,0(s1)
    80003a0a:	ef81                	bnez	a5,80003a22 <holdingsleep+0x32>
    80003a0c:	4481                	li	s1,0
  release(&lk->lk);
    80003a0e:	854a                	mv	a0,s2
    80003a10:	5fc020ef          	jal	8000600c <release>
  return r;
}
    80003a14:	8526                	mv	a0,s1
    80003a16:	70a2                	ld	ra,40(sp)
    80003a18:	7402                	ld	s0,32(sp)
    80003a1a:	64e2                	ld	s1,24(sp)
    80003a1c:	6942                	ld	s2,16(sp)
    80003a1e:	6145                	addi	sp,sp,48
    80003a20:	8082                	ret
    80003a22:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a24:	0284a983          	lw	s3,40(s1)
    80003a28:	919fd0ef          	jal	80001340 <myproc>
    80003a2c:	5904                	lw	s1,48(a0)
    80003a2e:	413484b3          	sub	s1,s1,s3
    80003a32:	0014b493          	seqz	s1,s1
    80003a36:	69a2                	ld	s3,8(sp)
    80003a38:	bfd9                	j	80003a0e <holdingsleep+0x1e>

0000000080003a3a <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    80003a3a:	1141                	addi	sp,sp,-16
    80003a3c:	e406                	sd	ra,8(sp)
    80003a3e:	e022                	sd	s0,0(sp)
    80003a40:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003a42:	00005597          	auipc	a1,0x5
    80003a46:	bfe58593          	addi	a1,a1,-1026 # 80008640 <etext+0x640>
    80003a4a:	00017517          	auipc	a0,0x17
    80003a4e:	51e50513          	addi	a0,a0,1310 # 8001af68 <ftable>
    80003a52:	49c020ef          	jal	80005eee <initlock>
}
    80003a56:	60a2                	ld	ra,8(sp)
    80003a58:	6402                	ld	s0,0(sp)
    80003a5a:	0141                	addi	sp,sp,16
    80003a5c:	8082                	ret

0000000080003a5e <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003a5e:	1101                	addi	sp,sp,-32
    80003a60:	ec06                	sd	ra,24(sp)
    80003a62:	e822                	sd	s0,16(sp)
    80003a64:	e426                	sd	s1,8(sp)
    80003a66:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    80003a68:	00017517          	auipc	a0,0x17
    80003a6c:	50050513          	addi	a0,a0,1280 # 8001af68 <ftable>
    80003a70:	508020ef          	jal	80005f78 <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a74:	00017497          	auipc	s1,0x17
    80003a78:	50c48493          	addi	s1,s1,1292 # 8001af80 <ftable+0x18>
    80003a7c:	00018717          	auipc	a4,0x18
    80003a80:	4a470713          	addi	a4,a4,1188 # 8001bf20 <disk>
    if(f->ref == 0){
    80003a84:	40dc                	lw	a5,4(s1)
    80003a86:	cf89                	beqz	a5,80003aa0 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a88:	02848493          	addi	s1,s1,40
    80003a8c:	fee49ce3          	bne	s1,a4,80003a84 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a90:	00017517          	auipc	a0,0x17
    80003a94:	4d850513          	addi	a0,a0,1240 # 8001af68 <ftable>
    80003a98:	574020ef          	jal	8000600c <release>
  return 0;
    80003a9c:	4481                	li	s1,0
    80003a9e:	a809                	j	80003ab0 <filealloc+0x52>
      f->ref = 1;
    80003aa0:	4785                	li	a5,1
    80003aa2:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003aa4:	00017517          	auipc	a0,0x17
    80003aa8:	4c450513          	addi	a0,a0,1220 # 8001af68 <ftable>
    80003aac:	560020ef          	jal	8000600c <release>
}
    80003ab0:	8526                	mv	a0,s1
    80003ab2:	60e2                	ld	ra,24(sp)
    80003ab4:	6442                	ld	s0,16(sp)
    80003ab6:	64a2                	ld	s1,8(sp)
    80003ab8:	6105                	addi	sp,sp,32
    80003aba:	8082                	ret

0000000080003abc <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003abc:	1101                	addi	sp,sp,-32
    80003abe:	ec06                	sd	ra,24(sp)
    80003ac0:	e822                	sd	s0,16(sp)
    80003ac2:	e426                	sd	s1,8(sp)
    80003ac4:	1000                	addi	s0,sp,32
    80003ac6:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003ac8:	00017517          	auipc	a0,0x17
    80003acc:	4a050513          	addi	a0,a0,1184 # 8001af68 <ftable>
    80003ad0:	4a8020ef          	jal	80005f78 <acquire>
  if(f->ref < 1)
    80003ad4:	40dc                	lw	a5,4(s1)
    80003ad6:	02f05063          	blez	a5,80003af6 <filedup+0x3a>
    panic("filedup");
  f->ref++;
    80003ada:	2785                	addiw	a5,a5,1
    80003adc:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003ade:	00017517          	auipc	a0,0x17
    80003ae2:	48a50513          	addi	a0,a0,1162 # 8001af68 <ftable>
    80003ae6:	526020ef          	jal	8000600c <release>
  return f;
}
    80003aea:	8526                	mv	a0,s1
    80003aec:	60e2                	ld	ra,24(sp)
    80003aee:	6442                	ld	s0,16(sp)
    80003af0:	64a2                	ld	s1,8(sp)
    80003af2:	6105                	addi	sp,sp,32
    80003af4:	8082                	ret
    panic("filedup");
    80003af6:	00005517          	auipc	a0,0x5
    80003afa:	b5250513          	addi	a0,a0,-1198 # 80008648 <etext+0x648>
    80003afe:	1b8020ef          	jal	80005cb6 <panic>

0000000080003b02 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003b02:	7139                	addi	sp,sp,-64
    80003b04:	fc06                	sd	ra,56(sp)
    80003b06:	f822                	sd	s0,48(sp)
    80003b08:	f426                	sd	s1,40(sp)
    80003b0a:	0080                	addi	s0,sp,64
    80003b0c:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003b0e:	00017517          	auipc	a0,0x17
    80003b12:	45a50513          	addi	a0,a0,1114 # 8001af68 <ftable>
    80003b16:	462020ef          	jal	80005f78 <acquire>
  if(f->ref < 1)
    80003b1a:	40dc                	lw	a5,4(s1)
    80003b1c:	04f05a63          	blez	a5,80003b70 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003b20:	37fd                	addiw	a5,a5,-1
    80003b22:	c0dc                	sw	a5,4(s1)
    80003b24:	06f04063          	bgtz	a5,80003b84 <fileclose+0x82>
    80003b28:	f04a                	sd	s2,32(sp)
    80003b2a:	ec4e                	sd	s3,24(sp)
    80003b2c:	e852                	sd	s4,16(sp)
    80003b2e:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003b30:	0004a903          	lw	s2,0(s1)
    80003b34:	0094c783          	lbu	a5,9(s1)
    80003b38:	89be                	mv	s3,a5
    80003b3a:	689c                	ld	a5,16(s1)
    80003b3c:	8a3e                	mv	s4,a5
    80003b3e:	6c9c                	ld	a5,24(s1)
    80003b40:	8abe                	mv	s5,a5
  f->ref = 0;
    80003b42:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003b46:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003b4a:	00017517          	auipc	a0,0x17
    80003b4e:	41e50513          	addi	a0,a0,1054 # 8001af68 <ftable>
    80003b52:	4ba020ef          	jal	8000600c <release>

  if(ff.type == FD_PIPE){
    80003b56:	4785                	li	a5,1
    80003b58:	04f90163          	beq	s2,a5,80003b9a <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003b5c:	ffe9079b          	addiw	a5,s2,-2
    80003b60:	4705                	li	a4,1
    80003b62:	04f77563          	bgeu	a4,a5,80003bac <fileclose+0xaa>
    80003b66:	7902                	ld	s2,32(sp)
    80003b68:	69e2                	ld	s3,24(sp)
    80003b6a:	6a42                	ld	s4,16(sp)
    80003b6c:	6aa2                	ld	s5,8(sp)
    80003b6e:	a00d                	j	80003b90 <fileclose+0x8e>
    80003b70:	f04a                	sd	s2,32(sp)
    80003b72:	ec4e                	sd	s3,24(sp)
    80003b74:	e852                	sd	s4,16(sp)
    80003b76:	e456                	sd	s5,8(sp)
    panic("fileclose");
    80003b78:	00005517          	auipc	a0,0x5
    80003b7c:	ad850513          	addi	a0,a0,-1320 # 80008650 <etext+0x650>
    80003b80:	136020ef          	jal	80005cb6 <panic>
    release(&ftable.lock);
    80003b84:	00017517          	auipc	a0,0x17
    80003b88:	3e450513          	addi	a0,a0,996 # 8001af68 <ftable>
    80003b8c:	480020ef          	jal	8000600c <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    80003b90:	70e2                	ld	ra,56(sp)
    80003b92:	7442                	ld	s0,48(sp)
    80003b94:	74a2                	ld	s1,40(sp)
    80003b96:	6121                	addi	sp,sp,64
    80003b98:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b9a:	85ce                	mv	a1,s3
    80003b9c:	8552                	mv	a0,s4
    80003b9e:	348000ef          	jal	80003ee6 <pipeclose>
    80003ba2:	7902                	ld	s2,32(sp)
    80003ba4:	69e2                	ld	s3,24(sp)
    80003ba6:	6a42                	ld	s4,16(sp)
    80003ba8:	6aa2                	ld	s5,8(sp)
    80003baa:	b7dd                	j	80003b90 <fileclose+0x8e>
    begin_op();
    80003bac:	b33ff0ef          	jal	800036de <begin_op>
    iput(ff.ip);
    80003bb0:	8556                	mv	a0,s5
    80003bb2:	aa2ff0ef          	jal	80002e54 <iput>
    end_op();
    80003bb6:	b99ff0ef          	jal	8000374e <end_op>
    80003bba:	7902                	ld	s2,32(sp)
    80003bbc:	69e2                	ld	s3,24(sp)
    80003bbe:	6a42                	ld	s4,16(sp)
    80003bc0:	6aa2                	ld	s5,8(sp)
    80003bc2:	b7f9                	j	80003b90 <fileclose+0x8e>

0000000080003bc4 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003bc4:	715d                	addi	sp,sp,-80
    80003bc6:	e486                	sd	ra,72(sp)
    80003bc8:	e0a2                	sd	s0,64(sp)
    80003bca:	fc26                	sd	s1,56(sp)
    80003bcc:	f052                	sd	s4,32(sp)
    80003bce:	0880                	addi	s0,sp,80
    80003bd0:	84aa                	mv	s1,a0
    80003bd2:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80003bd4:	f6cfd0ef          	jal	80001340 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003bd8:	409c                	lw	a5,0(s1)
    80003bda:	37f9                	addiw	a5,a5,-2
    80003bdc:	4705                	li	a4,1
    80003bde:	04f76263          	bltu	a4,a5,80003c22 <filestat+0x5e>
    80003be2:	f84a                	sd	s2,48(sp)
    80003be4:	f44e                	sd	s3,40(sp)
    80003be6:	89aa                	mv	s3,a0
    ilock(f->ip);
    80003be8:	6c88                	ld	a0,24(s1)
    80003bea:	8e8ff0ef          	jal	80002cd2 <ilock>
    stati(f->ip, &st);
    80003bee:	fb840913          	addi	s2,s0,-72
    80003bf2:	85ca                	mv	a1,s2
    80003bf4:	6c88                	ld	a0,24(s1)
    80003bf6:	c40ff0ef          	jal	80003036 <stati>
    iunlock(f->ip);
    80003bfa:	6c88                	ld	a0,24(s1)
    80003bfc:	984ff0ef          	jal	80002d80 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c00:	46e1                	li	a3,24
    80003c02:	864a                	mv	a2,s2
    80003c04:	85d2                	mv	a1,s4
    80003c06:	0509b503          	ld	a0,80(s3)
    80003c0a:	c46fd0ef          	jal	80001050 <copyout>
    80003c0e:	41f5551b          	sraiw	a0,a0,0x1f
    80003c12:	7942                	ld	s2,48(sp)
    80003c14:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    80003c16:	60a6                	ld	ra,72(sp)
    80003c18:	6406                	ld	s0,64(sp)
    80003c1a:	74e2                	ld	s1,56(sp)
    80003c1c:	7a02                	ld	s4,32(sp)
    80003c1e:	6161                	addi	sp,sp,80
    80003c20:	8082                	ret
  return -1;
    80003c22:	557d                	li	a0,-1
    80003c24:	bfcd                	j	80003c16 <filestat+0x52>

0000000080003c26 <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c26:	7179                	addi	sp,sp,-48
    80003c28:	f406                	sd	ra,40(sp)
    80003c2a:	f022                	sd	s0,32(sp)
    80003c2c:	e84a                	sd	s2,16(sp)
    80003c2e:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c30:	00854783          	lbu	a5,8(a0)
    80003c34:	cfd1                	beqz	a5,80003cd0 <fileread+0xaa>
    80003c36:	ec26                	sd	s1,24(sp)
    80003c38:	e44e                	sd	s3,8(sp)
    80003c3a:	84aa                	mv	s1,a0
    80003c3c:	892e                	mv	s2,a1
    80003c3e:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c40:	411c                	lw	a5,0(a0)
    80003c42:	4705                	li	a4,1
    80003c44:	04e78363          	beq	a5,a4,80003c8a <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c48:	470d                	li	a4,3
    80003c4a:	04e78763          	beq	a5,a4,80003c98 <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c4e:	4709                	li	a4,2
    80003c50:	06e79a63          	bne	a5,a4,80003cc4 <fileread+0x9e>
    ilock(f->ip);
    80003c54:	6d08                	ld	a0,24(a0)
    80003c56:	87cff0ef          	jal	80002cd2 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c5a:	874e                	mv	a4,s3
    80003c5c:	5094                	lw	a3,32(s1)
    80003c5e:	864a                	mv	a2,s2
    80003c60:	4585                	li	a1,1
    80003c62:	6c88                	ld	a0,24(s1)
    80003c64:	c00ff0ef          	jal	80003064 <readi>
    80003c68:	892a                	mv	s2,a0
    80003c6a:	00a05563          	blez	a0,80003c74 <fileread+0x4e>
      f->off += r;
    80003c6e:	509c                	lw	a5,32(s1)
    80003c70:	9fa9                	addw	a5,a5,a0
    80003c72:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c74:	6c88                	ld	a0,24(s1)
    80003c76:	90aff0ef          	jal	80002d80 <iunlock>
    80003c7a:	64e2                	ld	s1,24(sp)
    80003c7c:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    80003c7e:	854a                	mv	a0,s2
    80003c80:	70a2                	ld	ra,40(sp)
    80003c82:	7402                	ld	s0,32(sp)
    80003c84:	6942                	ld	s2,16(sp)
    80003c86:	6145                	addi	sp,sp,48
    80003c88:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c8a:	6908                	ld	a0,16(a0)
    80003c8c:	3b0000ef          	jal	8000403c <piperead>
    80003c90:	892a                	mv	s2,a0
    80003c92:	64e2                	ld	s1,24(sp)
    80003c94:	69a2                	ld	s3,8(sp)
    80003c96:	b7e5                	j	80003c7e <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c98:	02451783          	lh	a5,36(a0)
    80003c9c:	03079693          	slli	a3,a5,0x30
    80003ca0:	92c1                	srli	a3,a3,0x30
    80003ca2:	4725                	li	a4,9
    80003ca4:	02d76963          	bltu	a4,a3,80003cd6 <fileread+0xb0>
    80003ca8:	0792                	slli	a5,a5,0x4
    80003caa:	00017717          	auipc	a4,0x17
    80003cae:	21e70713          	addi	a4,a4,542 # 8001aec8 <devsw>
    80003cb2:	97ba                	add	a5,a5,a4
    80003cb4:	639c                	ld	a5,0(a5)
    80003cb6:	c78d                	beqz	a5,80003ce0 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    80003cb8:	4505                	li	a0,1
    80003cba:	9782                	jalr	a5
    80003cbc:	892a                	mv	s2,a0
    80003cbe:	64e2                	ld	s1,24(sp)
    80003cc0:	69a2                	ld	s3,8(sp)
    80003cc2:	bf75                	j	80003c7e <fileread+0x58>
    panic("fileread");
    80003cc4:	00005517          	auipc	a0,0x5
    80003cc8:	99c50513          	addi	a0,a0,-1636 # 80008660 <etext+0x660>
    80003ccc:	7eb010ef          	jal	80005cb6 <panic>
    return -1;
    80003cd0:	57fd                	li	a5,-1
    80003cd2:	893e                	mv	s2,a5
    80003cd4:	b76d                	j	80003c7e <fileread+0x58>
      return -1;
    80003cd6:	57fd                	li	a5,-1
    80003cd8:	893e                	mv	s2,a5
    80003cda:	64e2                	ld	s1,24(sp)
    80003cdc:	69a2                	ld	s3,8(sp)
    80003cde:	b745                	j	80003c7e <fileread+0x58>
    80003ce0:	57fd                	li	a5,-1
    80003ce2:	893e                	mv	s2,a5
    80003ce4:	64e2                	ld	s1,24(sp)
    80003ce6:	69a2                	ld	s3,8(sp)
    80003ce8:	bf59                	j	80003c7e <fileread+0x58>

0000000080003cea <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    80003cea:	00954783          	lbu	a5,9(a0)
    80003cee:	10078f63          	beqz	a5,80003e0c <filewrite+0x122>
{
    80003cf2:	711d                	addi	sp,sp,-96
    80003cf4:	ec86                	sd	ra,88(sp)
    80003cf6:	e8a2                	sd	s0,80(sp)
    80003cf8:	e0ca                	sd	s2,64(sp)
    80003cfa:	f456                	sd	s5,40(sp)
    80003cfc:	f05a                	sd	s6,32(sp)
    80003cfe:	1080                	addi	s0,sp,96
    80003d00:	892a                	mv	s2,a0
    80003d02:	8b2e                	mv	s6,a1
    80003d04:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d06:	411c                	lw	a5,0(a0)
    80003d08:	4705                	li	a4,1
    80003d0a:	02e78a63          	beq	a5,a4,80003d3e <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d0e:	470d                	li	a4,3
    80003d10:	02e78b63          	beq	a5,a4,80003d46 <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d14:	4709                	li	a4,2
    80003d16:	0ce79f63          	bne	a5,a4,80003df4 <filewrite+0x10a>
    80003d1a:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d1c:	0ac05a63          	blez	a2,80003dd0 <filewrite+0xe6>
    80003d20:	e4a6                	sd	s1,72(sp)
    80003d22:	fc4e                	sd	s3,56(sp)
    80003d24:	ec5e                	sd	s7,24(sp)
    80003d26:	e862                	sd	s8,16(sp)
    80003d28:	e466                	sd	s9,8(sp)
    int i = 0;
    80003d2a:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003d2c:	6b85                	lui	s7,0x1
    80003d2e:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003d32:	6785                	lui	a5,0x1
    80003d34:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    80003d38:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d3a:	4c05                	li	s8,1
    80003d3c:	a8ad                	j	80003db6 <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003d3e:	6908                	ld	a0,16(a0)
    80003d40:	204000ef          	jal	80003f44 <pipewrite>
    80003d44:	a04d                	j	80003de6 <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d46:	02451783          	lh	a5,36(a0)
    80003d4a:	03079693          	slli	a3,a5,0x30
    80003d4e:	92c1                	srli	a3,a3,0x30
    80003d50:	4725                	li	a4,9
    80003d52:	0ad76f63          	bltu	a4,a3,80003e10 <filewrite+0x126>
    80003d56:	0792                	slli	a5,a5,0x4
    80003d58:	00017717          	auipc	a4,0x17
    80003d5c:	17070713          	addi	a4,a4,368 # 8001aec8 <devsw>
    80003d60:	97ba                	add	a5,a5,a4
    80003d62:	679c                	ld	a5,8(a5)
    80003d64:	cbc5                	beqz	a5,80003e14 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    80003d66:	4505                	li	a0,1
    80003d68:	9782                	jalr	a5
    80003d6a:	a8b5                	j	80003de6 <filewrite+0xfc>
      if(n1 > max)
    80003d6c:	2981                	sext.w	s3,s3
      begin_op();
    80003d6e:	971ff0ef          	jal	800036de <begin_op>
      ilock(f->ip);
    80003d72:	01893503          	ld	a0,24(s2)
    80003d76:	f5dfe0ef          	jal	80002cd2 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d7a:	874e                	mv	a4,s3
    80003d7c:	02092683          	lw	a3,32(s2)
    80003d80:	016a0633          	add	a2,s4,s6
    80003d84:	85e2                	mv	a1,s8
    80003d86:	01893503          	ld	a0,24(s2)
    80003d8a:	bccff0ef          	jal	80003156 <writei>
    80003d8e:	84aa                	mv	s1,a0
    80003d90:	00a05763          	blez	a0,80003d9e <filewrite+0xb4>
        f->off += r;
    80003d94:	02092783          	lw	a5,32(s2)
    80003d98:	9fa9                	addw	a5,a5,a0
    80003d9a:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003d9e:	01893503          	ld	a0,24(s2)
    80003da2:	fdffe0ef          	jal	80002d80 <iunlock>
      end_op();
    80003da6:	9a9ff0ef          	jal	8000374e <end_op>

      if(r != n1){
    80003daa:	02999563          	bne	s3,s1,80003dd4 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    80003dae:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    80003db2:	015a5963          	bge	s4,s5,80003dc4 <filewrite+0xda>
      int n1 = n - i;
    80003db6:	414a87bb          	subw	a5,s5,s4
    80003dba:	89be                	mv	s3,a5
      if(n1 > max)
    80003dbc:	fafbd8e3          	bge	s7,a5,80003d6c <filewrite+0x82>
    80003dc0:	89e6                	mv	s3,s9
    80003dc2:	b76d                	j	80003d6c <filewrite+0x82>
    80003dc4:	64a6                	ld	s1,72(sp)
    80003dc6:	79e2                	ld	s3,56(sp)
    80003dc8:	6be2                	ld	s7,24(sp)
    80003dca:	6c42                	ld	s8,16(sp)
    80003dcc:	6ca2                	ld	s9,8(sp)
    80003dce:	a801                	j	80003dde <filewrite+0xf4>
    int i = 0;
    80003dd0:	4a01                	li	s4,0
    80003dd2:	a031                	j	80003dde <filewrite+0xf4>
    80003dd4:	64a6                	ld	s1,72(sp)
    80003dd6:	79e2                	ld	s3,56(sp)
    80003dd8:	6be2                	ld	s7,24(sp)
    80003dda:	6c42                	ld	s8,16(sp)
    80003ddc:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003dde:	034a9d63          	bne	s5,s4,80003e18 <filewrite+0x12e>
    80003de2:	8556                	mv	a0,s5
    80003de4:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003de6:	60e6                	ld	ra,88(sp)
    80003de8:	6446                	ld	s0,80(sp)
    80003dea:	6906                	ld	s2,64(sp)
    80003dec:	7aa2                	ld	s5,40(sp)
    80003dee:	7b02                	ld	s6,32(sp)
    80003df0:	6125                	addi	sp,sp,96
    80003df2:	8082                	ret
    80003df4:	e4a6                	sd	s1,72(sp)
    80003df6:	fc4e                	sd	s3,56(sp)
    80003df8:	f852                	sd	s4,48(sp)
    80003dfa:	ec5e                	sd	s7,24(sp)
    80003dfc:	e862                	sd	s8,16(sp)
    80003dfe:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003e00:	00005517          	auipc	a0,0x5
    80003e04:	87050513          	addi	a0,a0,-1936 # 80008670 <etext+0x670>
    80003e08:	6af010ef          	jal	80005cb6 <panic>
    return -1;
    80003e0c:	557d                	li	a0,-1
}
    80003e0e:	8082                	ret
      return -1;
    80003e10:	557d                	li	a0,-1
    80003e12:	bfd1                	j	80003de6 <filewrite+0xfc>
    80003e14:	557d                	li	a0,-1
    80003e16:	bfc1                	j	80003de6 <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80003e18:	557d                	li	a0,-1
    80003e1a:	7a42                	ld	s4,48(sp)
    80003e1c:	b7e9                	j	80003de6 <filewrite+0xfc>

0000000080003e1e <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e1e:	7179                	addi	sp,sp,-48
    80003e20:	f406                	sd	ra,40(sp)
    80003e22:	f022                	sd	s0,32(sp)
    80003e24:	ec26                	sd	s1,24(sp)
    80003e26:	e052                	sd	s4,0(sp)
    80003e28:	1800                	addi	s0,sp,48
    80003e2a:	84aa                	mv	s1,a0
    80003e2c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e2e:	0005b023          	sd	zero,0(a1)
    80003e32:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e36:	c29ff0ef          	jal	80003a5e <filealloc>
    80003e3a:	e088                	sd	a0,0(s1)
    80003e3c:	c549                	beqz	a0,80003ec6 <pipealloc+0xa8>
    80003e3e:	c21ff0ef          	jal	80003a5e <filealloc>
    80003e42:	00aa3023          	sd	a0,0(s4)
    80003e46:	cd25                	beqz	a0,80003ebe <pipealloc+0xa0>
    80003e48:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e4a:	a88fc0ef          	jal	800000d2 <kalloc>
    80003e4e:	892a                	mv	s2,a0
    80003e50:	c12d                	beqz	a0,80003eb2 <pipealloc+0x94>
    80003e52:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003e54:	4985                	li	s3,1
    80003e56:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e5a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e5e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e62:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e66:	00005597          	auipc	a1,0x5
    80003e6a:	81a58593          	addi	a1,a1,-2022 # 80008680 <etext+0x680>
    80003e6e:	080020ef          	jal	80005eee <initlock>
  (*f0)->type = FD_PIPE;
    80003e72:	609c                	ld	a5,0(s1)
    80003e74:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e78:	609c                	ld	a5,0(s1)
    80003e7a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e7e:	609c                	ld	a5,0(s1)
    80003e80:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e84:	609c                	ld	a5,0(s1)
    80003e86:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e8a:	000a3783          	ld	a5,0(s4)
    80003e8e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e92:	000a3783          	ld	a5,0(s4)
    80003e96:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e9a:	000a3783          	ld	a5,0(s4)
    80003e9e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ea2:	000a3783          	ld	a5,0(s4)
    80003ea6:	0127b823          	sd	s2,16(a5)
  return 0;
    80003eaa:	4501                	li	a0,0
    80003eac:	6942                	ld	s2,16(sp)
    80003eae:	69a2                	ld	s3,8(sp)
    80003eb0:	a01d                	j	80003ed6 <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003eb2:	6088                	ld	a0,0(s1)
    80003eb4:	c119                	beqz	a0,80003eba <pipealloc+0x9c>
    80003eb6:	6942                	ld	s2,16(sp)
    80003eb8:	a029                	j	80003ec2 <pipealloc+0xa4>
    80003eba:	6942                	ld	s2,16(sp)
    80003ebc:	a029                	j	80003ec6 <pipealloc+0xa8>
    80003ebe:	6088                	ld	a0,0(s1)
    80003ec0:	c10d                	beqz	a0,80003ee2 <pipealloc+0xc4>
    fileclose(*f0);
    80003ec2:	c41ff0ef          	jal	80003b02 <fileclose>
  if(*f1)
    80003ec6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eca:	557d                	li	a0,-1
  if(*f1)
    80003ecc:	c789                	beqz	a5,80003ed6 <pipealloc+0xb8>
    fileclose(*f1);
    80003ece:	853e                	mv	a0,a5
    80003ed0:	c33ff0ef          	jal	80003b02 <fileclose>
  return -1;
    80003ed4:	557d                	li	a0,-1
}
    80003ed6:	70a2                	ld	ra,40(sp)
    80003ed8:	7402                	ld	s0,32(sp)
    80003eda:	64e2                	ld	s1,24(sp)
    80003edc:	6a02                	ld	s4,0(sp)
    80003ede:	6145                	addi	sp,sp,48
    80003ee0:	8082                	ret
  return -1;
    80003ee2:	557d                	li	a0,-1
    80003ee4:	bfcd                	j	80003ed6 <pipealloc+0xb8>

0000000080003ee6 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ee6:	1101                	addi	sp,sp,-32
    80003ee8:	ec06                	sd	ra,24(sp)
    80003eea:	e822                	sd	s0,16(sp)
    80003eec:	e426                	sd	s1,8(sp)
    80003eee:	e04a                	sd	s2,0(sp)
    80003ef0:	1000                	addi	s0,sp,32
    80003ef2:	84aa                	mv	s1,a0
    80003ef4:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ef6:	082020ef          	jal	80005f78 <acquire>
  if(writable){
    80003efa:	02090763          	beqz	s2,80003f28 <pipeclose+0x42>
    pi->writeopen = 0;
    80003efe:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f02:	21848513          	addi	a0,s1,536
    80003f06:	afbfd0ef          	jal	80001a00 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f0a:	2204a783          	lw	a5,544(s1)
    80003f0e:	e781                	bnez	a5,80003f16 <pipeclose+0x30>
    80003f10:	2244a783          	lw	a5,548(s1)
    80003f14:	c38d                	beqz	a5,80003f36 <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80003f16:	8526                	mv	a0,s1
    80003f18:	0f4020ef          	jal	8000600c <release>
}
    80003f1c:	60e2                	ld	ra,24(sp)
    80003f1e:	6442                	ld	s0,16(sp)
    80003f20:	64a2                	ld	s1,8(sp)
    80003f22:	6902                	ld	s2,0(sp)
    80003f24:	6105                	addi	sp,sp,32
    80003f26:	8082                	ret
    pi->readopen = 0;
    80003f28:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f2c:	21c48513          	addi	a0,s1,540
    80003f30:	ad1fd0ef          	jal	80001a00 <wakeup>
    80003f34:	bfd9                	j	80003f0a <pipeclose+0x24>
    release(&pi->lock);
    80003f36:	8526                	mv	a0,s1
    80003f38:	0d4020ef          	jal	8000600c <release>
    kfree((char*)pi);
    80003f3c:	8526                	mv	a0,s1
    80003f3e:	8defc0ef          	jal	8000001c <kfree>
    80003f42:	bfe9                	j	80003f1c <pipeclose+0x36>

0000000080003f44 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f44:	7159                	addi	sp,sp,-112
    80003f46:	f486                	sd	ra,104(sp)
    80003f48:	f0a2                	sd	s0,96(sp)
    80003f4a:	eca6                	sd	s1,88(sp)
    80003f4c:	e8ca                	sd	s2,80(sp)
    80003f4e:	e4ce                	sd	s3,72(sp)
    80003f50:	e0d2                	sd	s4,64(sp)
    80003f52:	fc56                	sd	s5,56(sp)
    80003f54:	1880                	addi	s0,sp,112
    80003f56:	84aa                	mv	s1,a0
    80003f58:	8aae                	mv	s5,a1
    80003f5a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f5c:	be4fd0ef          	jal	80001340 <myproc>
    80003f60:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f62:	8526                	mv	a0,s1
    80003f64:	014020ef          	jal	80005f78 <acquire>
  while(i < n){
    80003f68:	0d405263          	blez	s4,8000402c <pipewrite+0xe8>
    80003f6c:	f85a                	sd	s6,48(sp)
    80003f6e:	f45e                	sd	s7,40(sp)
    80003f70:	f062                	sd	s8,32(sp)
    80003f72:	ec66                	sd	s9,24(sp)
    80003f74:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003f76:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f78:	f9f40c13          	addi	s8,s0,-97
    80003f7c:	4b85                	li	s7,1
    80003f7e:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f80:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f84:	21c48c93          	addi	s9,s1,540
    80003f88:	a82d                	j	80003fc2 <pipewrite+0x7e>
      release(&pi->lock);
    80003f8a:	8526                	mv	a0,s1
    80003f8c:	080020ef          	jal	8000600c <release>
      return -1;
    80003f90:	597d                	li	s2,-1
    80003f92:	7b42                	ld	s6,48(sp)
    80003f94:	7ba2                	ld	s7,40(sp)
    80003f96:	7c02                	ld	s8,32(sp)
    80003f98:	6ce2                	ld	s9,24(sp)
    80003f9a:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f9c:	854a                	mv	a0,s2
    80003f9e:	70a6                	ld	ra,104(sp)
    80003fa0:	7406                	ld	s0,96(sp)
    80003fa2:	64e6                	ld	s1,88(sp)
    80003fa4:	6946                	ld	s2,80(sp)
    80003fa6:	69a6                	ld	s3,72(sp)
    80003fa8:	6a06                	ld	s4,64(sp)
    80003faa:	7ae2                	ld	s5,56(sp)
    80003fac:	6165                	addi	sp,sp,112
    80003fae:	8082                	ret
      wakeup(&pi->nread);
    80003fb0:	856a                	mv	a0,s10
    80003fb2:	a4ffd0ef          	jal	80001a00 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fb6:	85a6                	mv	a1,s1
    80003fb8:	8566                	mv	a0,s9
    80003fba:	9fbfd0ef          	jal	800019b4 <sleep>
  while(i < n){
    80003fbe:	05495a63          	bge	s2,s4,80004012 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003fc2:	2204a783          	lw	a5,544(s1)
    80003fc6:	d3f1                	beqz	a5,80003f8a <pipewrite+0x46>
    80003fc8:	854e                	mv	a0,s3
    80003fca:	c27fd0ef          	jal	80001bf0 <killed>
    80003fce:	fd55                	bnez	a0,80003f8a <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003fd0:	2184a783          	lw	a5,536(s1)
    80003fd4:	21c4a703          	lw	a4,540(s1)
    80003fd8:	2007879b          	addiw	a5,a5,512
    80003fdc:	fcf70ae3          	beq	a4,a5,80003fb0 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fe0:	86de                	mv	a3,s7
    80003fe2:	01590633          	add	a2,s2,s5
    80003fe6:	85e2                	mv	a1,s8
    80003fe8:	0509b503          	ld	a0,80(s3)
    80003fec:	932fd0ef          	jal	8000111e <copyin>
    80003ff0:	05650063          	beq	a0,s6,80004030 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ff4:	21c4a783          	lw	a5,540(s1)
    80003ff8:	0017871b          	addiw	a4,a5,1
    80003ffc:	20e4ae23          	sw	a4,540(s1)
    80004000:	1ff7f793          	andi	a5,a5,511
    80004004:	97a6                	add	a5,a5,s1
    80004006:	f9f44703          	lbu	a4,-97(s0)
    8000400a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000400e:	2905                	addiw	s2,s2,1
    80004010:	b77d                	j	80003fbe <pipewrite+0x7a>
    80004012:	7b42                	ld	s6,48(sp)
    80004014:	7ba2                	ld	s7,40(sp)
    80004016:	7c02                	ld	s8,32(sp)
    80004018:	6ce2                	ld	s9,24(sp)
    8000401a:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    8000401c:	21848513          	addi	a0,s1,536
    80004020:	9e1fd0ef          	jal	80001a00 <wakeup>
  release(&pi->lock);
    80004024:	8526                	mv	a0,s1
    80004026:	7e7010ef          	jal	8000600c <release>
  return i;
    8000402a:	bf8d                	j	80003f9c <pipewrite+0x58>
  int i = 0;
    8000402c:	4901                	li	s2,0
    8000402e:	b7fd                	j	8000401c <pipewrite+0xd8>
    80004030:	7b42                	ld	s6,48(sp)
    80004032:	7ba2                	ld	s7,40(sp)
    80004034:	7c02                	ld	s8,32(sp)
    80004036:	6ce2                	ld	s9,24(sp)
    80004038:	6d42                	ld	s10,16(sp)
    8000403a:	b7cd                	j	8000401c <pipewrite+0xd8>

000000008000403c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000403c:	711d                	addi	sp,sp,-96
    8000403e:	ec86                	sd	ra,88(sp)
    80004040:	e8a2                	sd	s0,80(sp)
    80004042:	e4a6                	sd	s1,72(sp)
    80004044:	e0ca                	sd	s2,64(sp)
    80004046:	fc4e                	sd	s3,56(sp)
    80004048:	f852                	sd	s4,48(sp)
    8000404a:	f456                	sd	s5,40(sp)
    8000404c:	1080                	addi	s0,sp,96
    8000404e:	84aa                	mv	s1,a0
    80004050:	892e                	mv	s2,a1
    80004052:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004054:	aecfd0ef          	jal	80001340 <myproc>
    80004058:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000405a:	8526                	mv	a0,s1
    8000405c:	71d010ef          	jal	80005f78 <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004060:	2184a703          	lw	a4,536(s1)
    80004064:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004068:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000406c:	02f71763          	bne	a4,a5,8000409a <piperead+0x5e>
    80004070:	2244a783          	lw	a5,548(s1)
    80004074:	cf85                	beqz	a5,800040ac <piperead+0x70>
    if(killed(pr)){
    80004076:	8552                	mv	a0,s4
    80004078:	b79fd0ef          	jal	80001bf0 <killed>
    8000407c:	e11d                	bnez	a0,800040a2 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000407e:	85a6                	mv	a1,s1
    80004080:	854e                	mv	a0,s3
    80004082:	933fd0ef          	jal	800019b4 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004086:	2184a703          	lw	a4,536(s1)
    8000408a:	21c4a783          	lw	a5,540(s1)
    8000408e:	fef701e3          	beq	a4,a5,80004070 <piperead+0x34>
    80004092:	f05a                	sd	s6,32(sp)
    80004094:	ec5e                	sd	s7,24(sp)
    80004096:	e862                	sd	s8,16(sp)
    80004098:	a829                	j	800040b2 <piperead+0x76>
    8000409a:	f05a                	sd	s6,32(sp)
    8000409c:	ec5e                	sd	s7,24(sp)
    8000409e:	e862                	sd	s8,16(sp)
    800040a0:	a809                	j	800040b2 <piperead+0x76>
      release(&pi->lock);
    800040a2:	8526                	mv	a0,s1
    800040a4:	769010ef          	jal	8000600c <release>
      return -1;
    800040a8:	59fd                	li	s3,-1
    800040aa:	a09d                	j	80004110 <piperead+0xd4>
    800040ac:	f05a                	sd	s6,32(sp)
    800040ae:	ec5e                	sd	s7,24(sp)
    800040b0:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040b2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040b4:	faf40c13          	addi	s8,s0,-81
    800040b8:	4b85                	li	s7,1
    800040ba:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040bc:	05505063          	blez	s5,800040fc <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    800040c0:	2184a783          	lw	a5,536(s1)
    800040c4:	21c4a703          	lw	a4,540(s1)
    800040c8:	02f70a63          	beq	a4,a5,800040fc <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040cc:	0017871b          	addiw	a4,a5,1
    800040d0:	20e4ac23          	sw	a4,536(s1)
    800040d4:	1ff7f793          	andi	a5,a5,511
    800040d8:	97a6                	add	a5,a5,s1
    800040da:	0187c783          	lbu	a5,24(a5)
    800040de:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040e2:	86de                	mv	a3,s7
    800040e4:	8662                	mv	a2,s8
    800040e6:	85ca                	mv	a1,s2
    800040e8:	050a3503          	ld	a0,80(s4)
    800040ec:	f65fc0ef          	jal	80001050 <copyout>
    800040f0:	01650663          	beq	a0,s6,800040fc <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f4:	2985                	addiw	s3,s3,1
    800040f6:	0905                	addi	s2,s2,1
    800040f8:	fd3a94e3          	bne	s5,s3,800040c0 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040fc:	21c48513          	addi	a0,s1,540
    80004100:	901fd0ef          	jal	80001a00 <wakeup>
  release(&pi->lock);
    80004104:	8526                	mv	a0,s1
    80004106:	707010ef          	jal	8000600c <release>
    8000410a:	7b02                	ld	s6,32(sp)
    8000410c:	6be2                	ld	s7,24(sp)
    8000410e:	6c42                	ld	s8,16(sp)
  return i;
}
    80004110:	854e                	mv	a0,s3
    80004112:	60e6                	ld	ra,88(sp)
    80004114:	6446                	ld	s0,80(sp)
    80004116:	64a6                	ld	s1,72(sp)
    80004118:	6906                	ld	s2,64(sp)
    8000411a:	79e2                	ld	s3,56(sp)
    8000411c:	7a42                	ld	s4,48(sp)
    8000411e:	7aa2                	ld	s5,40(sp)
    80004120:	6125                	addi	sp,sp,96
    80004122:	8082                	ret

0000000080004124 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80004124:	1141                	addi	sp,sp,-16
    80004126:	e406                	sd	ra,8(sp)
    80004128:	e022                	sd	s0,0(sp)
    8000412a:	0800                	addi	s0,sp,16
    8000412c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000412e:	0035151b          	slliw	a0,a0,0x3
    80004132:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80004134:	8b89                	andi	a5,a5,2
    80004136:	c399                	beqz	a5,8000413c <flags2perm+0x18>
      perm |= PTE_W;
    80004138:	00456513          	ori	a0,a0,4
    return perm;
}
    8000413c:	60a2                	ld	ra,8(sp)
    8000413e:	6402                	ld	s0,0(sp)
    80004140:	0141                	addi	sp,sp,16
    80004142:	8082                	ret

0000000080004144 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80004144:	de010113          	addi	sp,sp,-544
    80004148:	20113c23          	sd	ra,536(sp)
    8000414c:	20813823          	sd	s0,528(sp)
    80004150:	20913423          	sd	s1,520(sp)
    80004154:	21213023          	sd	s2,512(sp)
    80004158:	1400                	addi	s0,sp,544
    8000415a:	892a                	mv	s2,a0
    8000415c:	dea43823          	sd	a0,-528(s0)
    80004160:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004164:	9dcfd0ef          	jal	80001340 <myproc>
    80004168:	84aa                	mv	s1,a0

  begin_op();
    8000416a:	d74ff0ef          	jal	800036de <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    8000416e:	854a                	mv	a0,s2
    80004170:	b90ff0ef          	jal	80003500 <namei>
    80004174:	cd21                	beqz	a0,800041cc <kexec+0x88>
    80004176:	fbd2                	sd	s4,496(sp)
    80004178:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    8000417a:	b59fe0ef          	jal	80002cd2 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000417e:	04000713          	li	a4,64
    80004182:	4681                	li	a3,0
    80004184:	e5040613          	addi	a2,s0,-432
    80004188:	4581                	li	a1,0
    8000418a:	8552                	mv	a0,s4
    8000418c:	ed9fe0ef          	jal	80003064 <readi>
    80004190:	04000793          	li	a5,64
    80004194:	00f51a63          	bne	a0,a5,800041a8 <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80004198:	e5042703          	lw	a4,-432(s0)
    8000419c:	464c47b7          	lui	a5,0x464c4
    800041a0:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041a4:	02f70863          	beq	a4,a5,800041d4 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041a8:	8552                	mv	a0,s4
    800041aa:	d35fe0ef          	jal	80002ede <iunlockput>
    end_op();
    800041ae:	da0ff0ef          	jal	8000374e <end_op>
  }
  return -1;
    800041b2:	557d                	li	a0,-1
    800041b4:	7a5e                	ld	s4,496(sp)
}
    800041b6:	21813083          	ld	ra,536(sp)
    800041ba:	21013403          	ld	s0,528(sp)
    800041be:	20813483          	ld	s1,520(sp)
    800041c2:	20013903          	ld	s2,512(sp)
    800041c6:	22010113          	addi	sp,sp,544
    800041ca:	8082                	ret
    end_op();
    800041cc:	d82ff0ef          	jal	8000374e <end_op>
    return -1;
    800041d0:	557d                	li	a0,-1
    800041d2:	b7d5                	j	800041b6 <kexec+0x72>
    800041d4:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    800041d6:	8526                	mv	a0,s1
    800041d8:	a72fd0ef          	jal	8000144a <proc_pagetable>
    800041dc:	8b2a                	mv	s6,a0
    800041de:	26050f63          	beqz	a0,8000445c <kexec+0x318>
    800041e2:	ffce                	sd	s3,504(sp)
    800041e4:	f7d6                	sd	s5,488(sp)
    800041e6:	efde                	sd	s7,472(sp)
    800041e8:	ebe2                	sd	s8,464(sp)
    800041ea:	e7e6                	sd	s9,456(sp)
    800041ec:	e3ea                	sd	s10,448(sp)
    800041ee:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041f0:	e8845783          	lhu	a5,-376(s0)
    800041f4:	0e078963          	beqz	a5,800042e6 <kexec+0x1a2>
    800041f8:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800041fc:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800041fe:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004200:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80004204:	6c85                	lui	s9,0x1
    80004206:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000420a:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    8000420e:	6a85                	lui	s5,0x1
    80004210:	a085                	j	80004270 <kexec+0x12c>
      panic("loadseg: address should exist");
    80004212:	00004517          	auipc	a0,0x4
    80004216:	47650513          	addi	a0,a0,1142 # 80008688 <etext+0x688>
    8000421a:	29d010ef          	jal	80005cb6 <panic>
    if(sz - i < PGSIZE)
    8000421e:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004220:	874a                	mv	a4,s2
    80004222:	009b86bb          	addw	a3,s7,s1
    80004226:	4581                	li	a1,0
    80004228:	8552                	mv	a0,s4
    8000422a:	e3bfe0ef          	jal	80003064 <readi>
    8000422e:	22a91b63          	bne	s2,a0,80004464 <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80004232:	009a84bb          	addw	s1,s5,s1
    80004236:	0334f263          	bgeu	s1,s3,8000425a <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    8000423a:	02049593          	slli	a1,s1,0x20
    8000423e:	9181                	srli	a1,a1,0x20
    80004240:	95e2                	add	a1,a1,s8
    80004242:	855a                	mv	a0,s6
    80004244:	c30fc0ef          	jal	80000674 <walkaddr>
    80004248:	862a                	mv	a2,a0
    if(pa == 0)
    8000424a:	d561                	beqz	a0,80004212 <kexec+0xce>
    if(sz - i < PGSIZE)
    8000424c:	409987bb          	subw	a5,s3,s1
    80004250:	893e                	mv	s2,a5
    80004252:	fcfcf6e3          	bgeu	s9,a5,8000421e <kexec+0xda>
    80004256:	8956                	mv	s2,s5
    80004258:	b7d9                	j	8000421e <kexec+0xda>
    sz = sz1;
    8000425a:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000425e:	2d05                	addiw	s10,s10,1
    80004260:	e0843783          	ld	a5,-504(s0)
    80004264:	0387869b          	addiw	a3,a5,56
    80004268:	e8845783          	lhu	a5,-376(s0)
    8000426c:	06fd5e63          	bge	s10,a5,800042e8 <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004270:	e0d43423          	sd	a3,-504(s0)
    80004274:	876e                	mv	a4,s11
    80004276:	e1840613          	addi	a2,s0,-488
    8000427a:	4581                	li	a1,0
    8000427c:	8552                	mv	a0,s4
    8000427e:	de7fe0ef          	jal	80003064 <readi>
    80004282:	1db51f63          	bne	a0,s11,80004460 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80004286:	e1842783          	lw	a5,-488(s0)
    8000428a:	4705                	li	a4,1
    8000428c:	fce799e3          	bne	a5,a4,8000425e <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80004290:	e4043483          	ld	s1,-448(s0)
    80004294:	e3843783          	ld	a5,-456(s0)
    80004298:	1ef4e463          	bltu	s1,a5,80004480 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000429c:	e2843783          	ld	a5,-472(s0)
    800042a0:	94be                	add	s1,s1,a5
    800042a2:	1ef4e263          	bltu	s1,a5,80004486 <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    800042a6:	de843703          	ld	a4,-536(s0)
    800042aa:	8ff9                	and	a5,a5,a4
    800042ac:	1e079063          	bnez	a5,8000448c <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800042b0:	e1c42503          	lw	a0,-484(s0)
    800042b4:	e71ff0ef          	jal	80004124 <flags2perm>
    800042b8:	86aa                	mv	a3,a0
    800042ba:	8626                	mv	a2,s1
    800042bc:	85ca                	mv	a1,s2
    800042be:	855a                	mv	a0,s6
    800042c0:	92dfc0ef          	jal	80000bec <uvmalloc>
    800042c4:	dea43c23          	sd	a0,-520(s0)
    800042c8:	1c050563          	beqz	a0,80004492 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042cc:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042d0:	00098863          	beqz	s3,800042e0 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800042d4:	e2843c03          	ld	s8,-472(s0)
    800042d8:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800042dc:	4481                	li	s1,0
    800042de:	bfb1                	j	8000423a <kexec+0xf6>
    sz = sz1;
    800042e0:	df843903          	ld	s2,-520(s0)
    800042e4:	bfad                	j	8000425e <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042e6:	4901                	li	s2,0
  iunlockput(ip);
    800042e8:	8552                	mv	a0,s4
    800042ea:	bf5fe0ef          	jal	80002ede <iunlockput>
  end_op();
    800042ee:	c60ff0ef          	jal	8000374e <end_op>
  p = myproc();
    800042f2:	84efd0ef          	jal	80001340 <myproc>
    800042f6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042f8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042fc:	6985                	lui	s3,0x1
    800042fe:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80004300:	99ca                	add	s3,s3,s2
    80004302:	77fd                	lui	a5,0xfffff
    80004304:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80004308:	4691                	li	a3,4
    8000430a:	6609                	lui	a2,0x2
    8000430c:	964e                	add	a2,a2,s3
    8000430e:	85ce                	mv	a1,s3
    80004310:	855a                	mv	a0,s6
    80004312:	8dbfc0ef          	jal	80000bec <uvmalloc>
    80004316:	8a2a                	mv	s4,a0
    80004318:	e105                	bnez	a0,80004338 <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    8000431a:	85ce                	mv	a1,s3
    8000431c:	855a                	mv	a0,s6
    8000431e:	9e8fd0ef          	jal	80001506 <proc_freepagetable>
  return -1;
    80004322:	557d                	li	a0,-1
    80004324:	79fe                	ld	s3,504(sp)
    80004326:	7a5e                	ld	s4,496(sp)
    80004328:	7abe                	ld	s5,488(sp)
    8000432a:	7b1e                	ld	s6,480(sp)
    8000432c:	6bfe                	ld	s7,472(sp)
    8000432e:	6c5e                	ld	s8,464(sp)
    80004330:	6cbe                	ld	s9,456(sp)
    80004332:	6d1e                	ld	s10,448(sp)
    80004334:	7dfa                	ld	s11,440(sp)
    80004336:	b541                	j	800041b6 <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80004338:	75f9                	lui	a1,0xffffe
    8000433a:	95aa                	add	a1,a1,a0
    8000433c:	855a                	mv	a0,s6
    8000433e:	b85fc0ef          	jal	80000ec2 <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80004342:	800a0b93          	addi	s7,s4,-2048
    80004346:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    8000434a:	e0043783          	ld	a5,-512(s0)
    8000434e:	6388                	ld	a0,0(a5)
  sp = sz;
    80004350:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80004352:	4481                	li	s1,0
    ustack[argc] = sp;
    80004354:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80004358:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    8000435c:	cd21                	beqz	a0,800043b4 <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    8000435e:	8c8fc0ef          	jal	80000426 <strlen>
    80004362:	0015079b          	addiw	a5,a0,1
    80004366:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000436a:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    8000436e:	13796563          	bltu	s2,s7,80004498 <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004372:	e0043d83          	ld	s11,-512(s0)
    80004376:	000db983          	ld	s3,0(s11)
    8000437a:	854e                	mv	a0,s3
    8000437c:	8aafc0ef          	jal	80000426 <strlen>
    80004380:	0015069b          	addiw	a3,a0,1
    80004384:	864e                	mv	a2,s3
    80004386:	85ca                	mv	a1,s2
    80004388:	855a                	mv	a0,s6
    8000438a:	cc7fc0ef          	jal	80001050 <copyout>
    8000438e:	10054763          	bltz	a0,8000449c <kexec+0x358>
    ustack[argc] = sp;
    80004392:	00349793          	slli	a5,s1,0x3
    80004396:	97e6                	add	a5,a5,s9
    80004398:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7ffdaec8>
  for(argc = 0; argv[argc]; argc++) {
    8000439c:	0485                	addi	s1,s1,1
    8000439e:	008d8793          	addi	a5,s11,8
    800043a2:	e0f43023          	sd	a5,-512(s0)
    800043a6:	008db503          	ld	a0,8(s11)
    800043aa:	c509                	beqz	a0,800043b4 <kexec+0x270>
    if(argc >= MAXARG)
    800043ac:	fb8499e3          	bne	s1,s8,8000435e <kexec+0x21a>
  sz = sz1;
    800043b0:	89d2                	mv	s3,s4
    800043b2:	b7a5                	j	8000431a <kexec+0x1d6>
  ustack[argc] = 0;
    800043b4:	00349793          	slli	a5,s1,0x3
    800043b8:	f9078793          	addi	a5,a5,-112
    800043bc:	97a2                	add	a5,a5,s0
    800043be:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    800043c2:	00349693          	slli	a3,s1,0x3
    800043c6:	06a1                	addi	a3,a3,8
    800043c8:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043cc:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    800043d0:	89d2                	mv	s3,s4
  if(sp < stackbase)
    800043d2:	f57964e3          	bltu	s2,s7,8000431a <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043d6:	e9040613          	addi	a2,s0,-368
    800043da:	85ca                	mv	a1,s2
    800043dc:	855a                	mv	a0,s6
    800043de:	c73fc0ef          	jal	80001050 <copyout>
    800043e2:	f2054ce3          	bltz	a0,8000431a <kexec+0x1d6>
  p->trapframe->a1 = sp;
    800043e6:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    800043ea:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043ee:	df043783          	ld	a5,-528(s0)
    800043f2:	0007c703          	lbu	a4,0(a5)
    800043f6:	cf11                	beqz	a4,80004412 <kexec+0x2ce>
    800043f8:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043fa:	02f00693          	li	a3,47
    800043fe:	a029                	j	80004408 <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80004400:	0785                	addi	a5,a5,1
    80004402:	fff7c703          	lbu	a4,-1(a5)
    80004406:	c711                	beqz	a4,80004412 <kexec+0x2ce>
    if(*s == '/')
    80004408:	fed71ce3          	bne	a4,a3,80004400 <kexec+0x2bc>
      last = s+1;
    8000440c:	def43823          	sd	a5,-528(s0)
    80004410:	bfc5                	j	80004400 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004412:	4641                	li	a2,16
    80004414:	df043583          	ld	a1,-528(s0)
    80004418:	160a8513          	addi	a0,s5,352
    8000441c:	fd5fb0ef          	jal	800003f0 <safestrcpy>
  oldpagetable = p->pagetable;
    80004420:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004424:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    80004428:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    8000442c:	058ab783          	ld	a5,88(s5)
    80004430:	e6843703          	ld	a4,-408(s0)
    80004434:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004436:	058ab783          	ld	a5,88(s5)
    8000443a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000443e:	85ea                	mv	a1,s10
    80004440:	8c6fd0ef          	jal	80001506 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004444:	0004851b          	sext.w	a0,s1
    80004448:	79fe                	ld	s3,504(sp)
    8000444a:	7a5e                	ld	s4,496(sp)
    8000444c:	7abe                	ld	s5,488(sp)
    8000444e:	7b1e                	ld	s6,480(sp)
    80004450:	6bfe                	ld	s7,472(sp)
    80004452:	6c5e                	ld	s8,464(sp)
    80004454:	6cbe                	ld	s9,456(sp)
    80004456:	6d1e                	ld	s10,448(sp)
    80004458:	7dfa                	ld	s11,440(sp)
    8000445a:	bbb1                	j	800041b6 <kexec+0x72>
    8000445c:	7b1e                	ld	s6,480(sp)
    8000445e:	b3a9                	j	800041a8 <kexec+0x64>
    80004460:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004464:	df843583          	ld	a1,-520(s0)
    80004468:	855a                	mv	a0,s6
    8000446a:	89cfd0ef          	jal	80001506 <proc_freepagetable>
  if(ip){
    8000446e:	79fe                	ld	s3,504(sp)
    80004470:	7abe                	ld	s5,488(sp)
    80004472:	7b1e                	ld	s6,480(sp)
    80004474:	6bfe                	ld	s7,472(sp)
    80004476:	6c5e                	ld	s8,464(sp)
    80004478:	6cbe                	ld	s9,456(sp)
    8000447a:	6d1e                	ld	s10,448(sp)
    8000447c:	7dfa                	ld	s11,440(sp)
    8000447e:	b32d                	j	800041a8 <kexec+0x64>
    80004480:	df243c23          	sd	s2,-520(s0)
    80004484:	b7c5                	j	80004464 <kexec+0x320>
    80004486:	df243c23          	sd	s2,-520(s0)
    8000448a:	bfe9                	j	80004464 <kexec+0x320>
    8000448c:	df243c23          	sd	s2,-520(s0)
    80004490:	bfd1                	j	80004464 <kexec+0x320>
    80004492:	df243c23          	sd	s2,-520(s0)
    80004496:	b7f9                	j	80004464 <kexec+0x320>
  sz = sz1;
    80004498:	89d2                	mv	s3,s4
    8000449a:	b541                	j	8000431a <kexec+0x1d6>
    8000449c:	89d2                	mv	s3,s4
    8000449e:	bdb5                	j	8000431a <kexec+0x1d6>

00000000800044a0 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044a0:	7179                	addi	sp,sp,-48
    800044a2:	f406                	sd	ra,40(sp)
    800044a4:	f022                	sd	s0,32(sp)
    800044a6:	ec26                	sd	s1,24(sp)
    800044a8:	e84a                	sd	s2,16(sp)
    800044aa:	1800                	addi	s0,sp,48
    800044ac:	892e                	mv	s2,a1
    800044ae:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800044b0:	fdc40593          	addi	a1,s0,-36
    800044b4:	e0dfd0ef          	jal	800022c0 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800044b8:	fdc42703          	lw	a4,-36(s0)
    800044bc:	47bd                	li	a5,15
    800044be:	02e7ea63          	bltu	a5,a4,800044f2 <argfd+0x52>
    800044c2:	e7ffc0ef          	jal	80001340 <myproc>
    800044c6:	fdc42703          	lw	a4,-36(s0)
    800044ca:	00371793          	slli	a5,a4,0x3
    800044ce:	0d078793          	addi	a5,a5,208
    800044d2:	953e                	add	a0,a0,a5
    800044d4:	651c                	ld	a5,8(a0)
    800044d6:	c385                	beqz	a5,800044f6 <argfd+0x56>
    return -1;
  if(pfd)
    800044d8:	00090463          	beqz	s2,800044e0 <argfd+0x40>
    *pfd = fd;
    800044dc:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    800044e0:	4501                	li	a0,0
  if(pf)
    800044e2:	c091                	beqz	s1,800044e6 <argfd+0x46>
    *pf = f;
    800044e4:	e09c                	sd	a5,0(s1)
}
    800044e6:	70a2                	ld	ra,40(sp)
    800044e8:	7402                	ld	s0,32(sp)
    800044ea:	64e2                	ld	s1,24(sp)
    800044ec:	6942                	ld	s2,16(sp)
    800044ee:	6145                	addi	sp,sp,48
    800044f0:	8082                	ret
    return -1;
    800044f2:	557d                	li	a0,-1
    800044f4:	bfcd                	j	800044e6 <argfd+0x46>
    800044f6:	557d                	li	a0,-1
    800044f8:	b7fd                	j	800044e6 <argfd+0x46>

00000000800044fa <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800044fa:	1101                	addi	sp,sp,-32
    800044fc:	ec06                	sd	ra,24(sp)
    800044fe:	e822                	sd	s0,16(sp)
    80004500:	e426                	sd	s1,8(sp)
    80004502:	1000                	addi	s0,sp,32
    80004504:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    80004506:	e3bfc0ef          	jal	80001340 <myproc>
    8000450a:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    8000450c:	0d850793          	addi	a5,a0,216
    80004510:	4501                	li	a0,0
    80004512:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004514:	6398                	ld	a4,0(a5)
    80004516:	cb19                	beqz	a4,8000452c <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    80004518:	2505                	addiw	a0,a0,1
    8000451a:	07a1                	addi	a5,a5,8
    8000451c:	fed51ce3          	bne	a0,a3,80004514 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004520:	557d                	li	a0,-1
}
    80004522:	60e2                	ld	ra,24(sp)
    80004524:	6442                	ld	s0,16(sp)
    80004526:	64a2                	ld	s1,8(sp)
    80004528:	6105                	addi	sp,sp,32
    8000452a:	8082                	ret
      p->ofile[fd] = f;
    8000452c:	00351793          	slli	a5,a0,0x3
    80004530:	0d078793          	addi	a5,a5,208
    80004534:	963e                	add	a2,a2,a5
    80004536:	e604                	sd	s1,8(a2)
      return fd;
    80004538:	b7ed                	j	80004522 <fdalloc+0x28>

000000008000453a <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000453a:	715d                	addi	sp,sp,-80
    8000453c:	e486                	sd	ra,72(sp)
    8000453e:	e0a2                	sd	s0,64(sp)
    80004540:	fc26                	sd	s1,56(sp)
    80004542:	f84a                	sd	s2,48(sp)
    80004544:	f44e                	sd	s3,40(sp)
    80004546:	f052                	sd	s4,32(sp)
    80004548:	ec56                	sd	s5,24(sp)
    8000454a:	e85a                	sd	s6,16(sp)
    8000454c:	0880                	addi	s0,sp,80
    8000454e:	892e                	mv	s2,a1
    80004550:	8a2e                	mv	s4,a1
    80004552:	8ab2                	mv	s5,a2
    80004554:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    80004556:	fb040593          	addi	a1,s0,-80
    8000455a:	fc1fe0ef          	jal	8000351a <nameiparent>
    8000455e:	84aa                	mv	s1,a0
    80004560:	10050763          	beqz	a0,8000466e <create+0x134>
    return 0;

  ilock(dp);
    80004564:	f6efe0ef          	jal	80002cd2 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    80004568:	4601                	li	a2,0
    8000456a:	fb040593          	addi	a1,s0,-80
    8000456e:	8526                	mv	a0,s1
    80004570:	cfdfe0ef          	jal	8000326c <dirlookup>
    80004574:	89aa                	mv	s3,a0
    80004576:	c131                	beqz	a0,800045ba <create+0x80>
    iunlockput(dp);
    80004578:	8526                	mv	a0,s1
    8000457a:	965fe0ef          	jal	80002ede <iunlockput>
    ilock(ip);
    8000457e:	854e                	mv	a0,s3
    80004580:	f52fe0ef          	jal	80002cd2 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004584:	4789                	li	a5,2
    80004586:	02f91563          	bne	s2,a5,800045b0 <create+0x76>
    8000458a:	0449d783          	lhu	a5,68(s3)
    8000458e:	37f9                	addiw	a5,a5,-2
    80004590:	17c2                	slli	a5,a5,0x30
    80004592:	93c1                	srli	a5,a5,0x30
    80004594:	4705                	li	a4,1
    80004596:	00f76d63          	bltu	a4,a5,800045b0 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    8000459a:	854e                	mv	a0,s3
    8000459c:	60a6                	ld	ra,72(sp)
    8000459e:	6406                	ld	s0,64(sp)
    800045a0:	74e2                	ld	s1,56(sp)
    800045a2:	7942                	ld	s2,48(sp)
    800045a4:	79a2                	ld	s3,40(sp)
    800045a6:	7a02                	ld	s4,32(sp)
    800045a8:	6ae2                	ld	s5,24(sp)
    800045aa:	6b42                	ld	s6,16(sp)
    800045ac:	6161                	addi	sp,sp,80
    800045ae:	8082                	ret
    iunlockput(ip);
    800045b0:	854e                	mv	a0,s3
    800045b2:	92dfe0ef          	jal	80002ede <iunlockput>
    return 0;
    800045b6:	4981                	li	s3,0
    800045b8:	b7cd                	j	8000459a <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    800045ba:	85ca                	mv	a1,s2
    800045bc:	4088                	lw	a0,0(s1)
    800045be:	da4fe0ef          	jal	80002b62 <ialloc>
    800045c2:	892a                	mv	s2,a0
    800045c4:	cd15                	beqz	a0,80004600 <create+0xc6>
  ilock(ip);
    800045c6:	f0cfe0ef          	jal	80002cd2 <ilock>
  ip->major = major;
    800045ca:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    800045ce:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    800045d2:	4785                	li	a5,1
    800045d4:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800045d8:	854a                	mv	a0,s2
    800045da:	e44fe0ef          	jal	80002c1e <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    800045de:	4705                	li	a4,1
    800045e0:	02ea0463          	beq	s4,a4,80004608 <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    800045e4:	00492603          	lw	a2,4(s2)
    800045e8:	fb040593          	addi	a1,s0,-80
    800045ec:	8526                	mv	a0,s1
    800045ee:	e69fe0ef          	jal	80003456 <dirlink>
    800045f2:	06054263          	bltz	a0,80004656 <create+0x11c>
  iunlockput(dp);
    800045f6:	8526                	mv	a0,s1
    800045f8:	8e7fe0ef          	jal	80002ede <iunlockput>
  return ip;
    800045fc:	89ca                	mv	s3,s2
    800045fe:	bf71                	j	8000459a <create+0x60>
    iunlockput(dp);
    80004600:	8526                	mv	a0,s1
    80004602:	8ddfe0ef          	jal	80002ede <iunlockput>
    return 0;
    80004606:	bf51                	j	8000459a <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    80004608:	00492603          	lw	a2,4(s2)
    8000460c:	00004597          	auipc	a1,0x4
    80004610:	09c58593          	addi	a1,a1,156 # 800086a8 <etext+0x6a8>
    80004614:	854a                	mv	a0,s2
    80004616:	e41fe0ef          	jal	80003456 <dirlink>
    8000461a:	02054e63          	bltz	a0,80004656 <create+0x11c>
    8000461e:	40d0                	lw	a2,4(s1)
    80004620:	00004597          	auipc	a1,0x4
    80004624:	09058593          	addi	a1,a1,144 # 800086b0 <etext+0x6b0>
    80004628:	854a                	mv	a0,s2
    8000462a:	e2dfe0ef          	jal	80003456 <dirlink>
    8000462e:	02054463          	bltz	a0,80004656 <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004632:	00492603          	lw	a2,4(s2)
    80004636:	fb040593          	addi	a1,s0,-80
    8000463a:	8526                	mv	a0,s1
    8000463c:	e1bfe0ef          	jal	80003456 <dirlink>
    80004640:	00054b63          	bltz	a0,80004656 <create+0x11c>
    dp->nlink++;  // for ".."
    80004644:	04a4d783          	lhu	a5,74(s1)
    80004648:	2785                	addiw	a5,a5,1
    8000464a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000464e:	8526                	mv	a0,s1
    80004650:	dcefe0ef          	jal	80002c1e <iupdate>
    80004654:	b74d                	j	800045f6 <create+0xbc>
  ip->nlink = 0;
    80004656:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    8000465a:	854a                	mv	a0,s2
    8000465c:	dc2fe0ef          	jal	80002c1e <iupdate>
  iunlockput(ip);
    80004660:	854a                	mv	a0,s2
    80004662:	87dfe0ef          	jal	80002ede <iunlockput>
  iunlockput(dp);
    80004666:	8526                	mv	a0,s1
    80004668:	877fe0ef          	jal	80002ede <iunlockput>
  return 0;
    8000466c:	b73d                	j	8000459a <create+0x60>
    return 0;
    8000466e:	89aa                	mv	s3,a0
    80004670:	b72d                	j	8000459a <create+0x60>

0000000080004672 <sys_dup>:
{
    80004672:	7179                	addi	sp,sp,-48
    80004674:	f406                	sd	ra,40(sp)
    80004676:	f022                	sd	s0,32(sp)
    80004678:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    8000467a:	fd840613          	addi	a2,s0,-40
    8000467e:	4581                	li	a1,0
    80004680:	4501                	li	a0,0
    80004682:	e1fff0ef          	jal	800044a0 <argfd>
    return -1;
    80004686:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    80004688:	02054363          	bltz	a0,800046ae <sys_dup+0x3c>
    8000468c:	ec26                	sd	s1,24(sp)
    8000468e:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    80004690:	fd843483          	ld	s1,-40(s0)
    80004694:	8526                	mv	a0,s1
    80004696:	e65ff0ef          	jal	800044fa <fdalloc>
    8000469a:	892a                	mv	s2,a0
    return -1;
    8000469c:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    8000469e:	00054d63          	bltz	a0,800046b8 <sys_dup+0x46>
  filedup(f);
    800046a2:	8526                	mv	a0,s1
    800046a4:	c18ff0ef          	jal	80003abc <filedup>
  return fd;
    800046a8:	87ca                	mv	a5,s2
    800046aa:	64e2                	ld	s1,24(sp)
    800046ac:	6942                	ld	s2,16(sp)
}
    800046ae:	853e                	mv	a0,a5
    800046b0:	70a2                	ld	ra,40(sp)
    800046b2:	7402                	ld	s0,32(sp)
    800046b4:	6145                	addi	sp,sp,48
    800046b6:	8082                	ret
    800046b8:	64e2                	ld	s1,24(sp)
    800046ba:	6942                	ld	s2,16(sp)
    800046bc:	bfcd                	j	800046ae <sys_dup+0x3c>

00000000800046be <sys_read>:
{
    800046be:	7179                	addi	sp,sp,-48
    800046c0:	f406                	sd	ra,40(sp)
    800046c2:	f022                	sd	s0,32(sp)
    800046c4:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800046c6:	fd840593          	addi	a1,s0,-40
    800046ca:	4505                	li	a0,1
    800046cc:	c11fd0ef          	jal	800022dc <argaddr>
  argint(2, &n);
    800046d0:	fe440593          	addi	a1,s0,-28
    800046d4:	4509                	li	a0,2
    800046d6:	bebfd0ef          	jal	800022c0 <argint>
  if(argfd(0, 0, &f) < 0)
    800046da:	fe840613          	addi	a2,s0,-24
    800046de:	4581                	li	a1,0
    800046e0:	4501                	li	a0,0
    800046e2:	dbfff0ef          	jal	800044a0 <argfd>
    800046e6:	87aa                	mv	a5,a0
    return -1;
    800046e8:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800046ea:	0007ca63          	bltz	a5,800046fe <sys_read+0x40>
  return fileread(f, p, n);
    800046ee:	fe442603          	lw	a2,-28(s0)
    800046f2:	fd843583          	ld	a1,-40(s0)
    800046f6:	fe843503          	ld	a0,-24(s0)
    800046fa:	d2cff0ef          	jal	80003c26 <fileread>
}
    800046fe:	70a2                	ld	ra,40(sp)
    80004700:	7402                	ld	s0,32(sp)
    80004702:	6145                	addi	sp,sp,48
    80004704:	8082                	ret

0000000080004706 <sys_write>:
{
    80004706:	7179                	addi	sp,sp,-48
    80004708:	f406                	sd	ra,40(sp)
    8000470a:	f022                	sd	s0,32(sp)
    8000470c:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    8000470e:	fd840593          	addi	a1,s0,-40
    80004712:	4505                	li	a0,1
    80004714:	bc9fd0ef          	jal	800022dc <argaddr>
  argint(2, &n);
    80004718:	fe440593          	addi	a1,s0,-28
    8000471c:	4509                	li	a0,2
    8000471e:	ba3fd0ef          	jal	800022c0 <argint>
  if(argfd(0, 0, &f) < 0)
    80004722:	fe840613          	addi	a2,s0,-24
    80004726:	4581                	li	a1,0
    80004728:	4501                	li	a0,0
    8000472a:	d77ff0ef          	jal	800044a0 <argfd>
    8000472e:	87aa                	mv	a5,a0
    return -1;
    80004730:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004732:	0007ca63          	bltz	a5,80004746 <sys_write+0x40>
  return filewrite(f, p, n);
    80004736:	fe442603          	lw	a2,-28(s0)
    8000473a:	fd843583          	ld	a1,-40(s0)
    8000473e:	fe843503          	ld	a0,-24(s0)
    80004742:	da8ff0ef          	jal	80003cea <filewrite>
}
    80004746:	70a2                	ld	ra,40(sp)
    80004748:	7402                	ld	s0,32(sp)
    8000474a:	6145                	addi	sp,sp,48
    8000474c:	8082                	ret

000000008000474e <sys_close>:
{
    8000474e:	1101                	addi	sp,sp,-32
    80004750:	ec06                	sd	ra,24(sp)
    80004752:	e822                	sd	s0,16(sp)
    80004754:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    80004756:	fe040613          	addi	a2,s0,-32
    8000475a:	fec40593          	addi	a1,s0,-20
    8000475e:	4501                	li	a0,0
    80004760:	d41ff0ef          	jal	800044a0 <argfd>
    return -1;
    80004764:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    80004766:	02054163          	bltz	a0,80004788 <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    8000476a:	bd7fc0ef          	jal	80001340 <myproc>
    8000476e:	fec42783          	lw	a5,-20(s0)
    80004772:	078e                	slli	a5,a5,0x3
    80004774:	0d078793          	addi	a5,a5,208
    80004778:	953e                	add	a0,a0,a5
    8000477a:	00053423          	sd	zero,8(a0)
  fileclose(f);
    8000477e:	fe043503          	ld	a0,-32(s0)
    80004782:	b80ff0ef          	jal	80003b02 <fileclose>
  return 0;
    80004786:	4781                	li	a5,0
}
    80004788:	853e                	mv	a0,a5
    8000478a:	60e2                	ld	ra,24(sp)
    8000478c:	6442                	ld	s0,16(sp)
    8000478e:	6105                	addi	sp,sp,32
    80004790:	8082                	ret

0000000080004792 <sys_fstat>:
{
    80004792:	1101                	addi	sp,sp,-32
    80004794:	ec06                	sd	ra,24(sp)
    80004796:	e822                	sd	s0,16(sp)
    80004798:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    8000479a:	fe040593          	addi	a1,s0,-32
    8000479e:	4505                	li	a0,1
    800047a0:	b3dfd0ef          	jal	800022dc <argaddr>
  if(argfd(0, 0, &f) < 0)
    800047a4:	fe840613          	addi	a2,s0,-24
    800047a8:	4581                	li	a1,0
    800047aa:	4501                	li	a0,0
    800047ac:	cf5ff0ef          	jal	800044a0 <argfd>
    800047b0:	87aa                	mv	a5,a0
    return -1;
    800047b2:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800047b4:	0007c863          	bltz	a5,800047c4 <sys_fstat+0x32>
  return filestat(f, st);
    800047b8:	fe043583          	ld	a1,-32(s0)
    800047bc:	fe843503          	ld	a0,-24(s0)
    800047c0:	c04ff0ef          	jal	80003bc4 <filestat>
}
    800047c4:	60e2                	ld	ra,24(sp)
    800047c6:	6442                	ld	s0,16(sp)
    800047c8:	6105                	addi	sp,sp,32
    800047ca:	8082                	ret

00000000800047cc <sys_link>:
{
    800047cc:	7169                	addi	sp,sp,-304
    800047ce:	f606                	sd	ra,296(sp)
    800047d0:	f222                	sd	s0,288(sp)
    800047d2:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047d4:	08000613          	li	a2,128
    800047d8:	ed040593          	addi	a1,s0,-304
    800047dc:	4501                	li	a0,0
    800047de:	b1bfd0ef          	jal	800022f8 <argstr>
    return -1;
    800047e2:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047e4:	0c054e63          	bltz	a0,800048c0 <sys_link+0xf4>
    800047e8:	08000613          	li	a2,128
    800047ec:	f5040593          	addi	a1,s0,-176
    800047f0:	4505                	li	a0,1
    800047f2:	b07fd0ef          	jal	800022f8 <argstr>
    return -1;
    800047f6:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800047f8:	0c054463          	bltz	a0,800048c0 <sys_link+0xf4>
    800047fc:	ee26                	sd	s1,280(sp)
  begin_op();
    800047fe:	ee1fe0ef          	jal	800036de <begin_op>
  if((ip = namei(old)) == 0){
    80004802:	ed040513          	addi	a0,s0,-304
    80004806:	cfbfe0ef          	jal	80003500 <namei>
    8000480a:	84aa                	mv	s1,a0
    8000480c:	c53d                	beqz	a0,8000487a <sys_link+0xae>
  ilock(ip);
    8000480e:	cc4fe0ef          	jal	80002cd2 <ilock>
  if(ip->type == T_DIR){
    80004812:	04449703          	lh	a4,68(s1)
    80004816:	4785                	li	a5,1
    80004818:	06f70663          	beq	a4,a5,80004884 <sys_link+0xb8>
    8000481c:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    8000481e:	04a4d783          	lhu	a5,74(s1)
    80004822:	2785                	addiw	a5,a5,1
    80004824:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    80004828:	8526                	mv	a0,s1
    8000482a:	bf4fe0ef          	jal	80002c1e <iupdate>
  iunlock(ip);
    8000482e:	8526                	mv	a0,s1
    80004830:	d50fe0ef          	jal	80002d80 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004834:	fd040593          	addi	a1,s0,-48
    80004838:	f5040513          	addi	a0,s0,-176
    8000483c:	cdffe0ef          	jal	8000351a <nameiparent>
    80004840:	892a                	mv	s2,a0
    80004842:	cd21                	beqz	a0,8000489a <sys_link+0xce>
  ilock(dp);
    80004844:	c8efe0ef          	jal	80002cd2 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    80004848:	854a                	mv	a0,s2
    8000484a:	00092703          	lw	a4,0(s2)
    8000484e:	409c                	lw	a5,0(s1)
    80004850:	04f71263          	bne	a4,a5,80004894 <sys_link+0xc8>
    80004854:	40d0                	lw	a2,4(s1)
    80004856:	fd040593          	addi	a1,s0,-48
    8000485a:	bfdfe0ef          	jal	80003456 <dirlink>
    8000485e:	02054b63          	bltz	a0,80004894 <sys_link+0xc8>
  iunlockput(dp);
    80004862:	854a                	mv	a0,s2
    80004864:	e7afe0ef          	jal	80002ede <iunlockput>
  iput(ip);
    80004868:	8526                	mv	a0,s1
    8000486a:	deafe0ef          	jal	80002e54 <iput>
  end_op();
    8000486e:	ee1fe0ef          	jal	8000374e <end_op>
  return 0;
    80004872:	4781                	li	a5,0
    80004874:	64f2                	ld	s1,280(sp)
    80004876:	6952                	ld	s2,272(sp)
    80004878:	a0a1                	j	800048c0 <sys_link+0xf4>
    end_op();
    8000487a:	ed5fe0ef          	jal	8000374e <end_op>
    return -1;
    8000487e:	57fd                	li	a5,-1
    80004880:	64f2                	ld	s1,280(sp)
    80004882:	a83d                	j	800048c0 <sys_link+0xf4>
    iunlockput(ip);
    80004884:	8526                	mv	a0,s1
    80004886:	e58fe0ef          	jal	80002ede <iunlockput>
    end_op();
    8000488a:	ec5fe0ef          	jal	8000374e <end_op>
    return -1;
    8000488e:	57fd                	li	a5,-1
    80004890:	64f2                	ld	s1,280(sp)
    80004892:	a03d                	j	800048c0 <sys_link+0xf4>
    iunlockput(dp);
    80004894:	854a                	mv	a0,s2
    80004896:	e48fe0ef          	jal	80002ede <iunlockput>
  ilock(ip);
    8000489a:	8526                	mv	a0,s1
    8000489c:	c36fe0ef          	jal	80002cd2 <ilock>
  ip->nlink--;
    800048a0:	04a4d783          	lhu	a5,74(s1)
    800048a4:	37fd                	addiw	a5,a5,-1
    800048a6:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800048aa:	8526                	mv	a0,s1
    800048ac:	b72fe0ef          	jal	80002c1e <iupdate>
  iunlockput(ip);
    800048b0:	8526                	mv	a0,s1
    800048b2:	e2cfe0ef          	jal	80002ede <iunlockput>
  end_op();
    800048b6:	e99fe0ef          	jal	8000374e <end_op>
  return -1;
    800048ba:	57fd                	li	a5,-1
    800048bc:	64f2                	ld	s1,280(sp)
    800048be:	6952                	ld	s2,272(sp)
}
    800048c0:	853e                	mv	a0,a5
    800048c2:	70b2                	ld	ra,296(sp)
    800048c4:	7412                	ld	s0,288(sp)
    800048c6:	6155                	addi	sp,sp,304
    800048c8:	8082                	ret

00000000800048ca <sys_unlink>:
{
    800048ca:	7151                	addi	sp,sp,-240
    800048cc:	f586                	sd	ra,232(sp)
    800048ce:	f1a2                	sd	s0,224(sp)
    800048d0:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    800048d2:	08000613          	li	a2,128
    800048d6:	f3040593          	addi	a1,s0,-208
    800048da:	4501                	li	a0,0
    800048dc:	a1dfd0ef          	jal	800022f8 <argstr>
    800048e0:	14054d63          	bltz	a0,80004a3a <sys_unlink+0x170>
    800048e4:	eda6                	sd	s1,216(sp)
  begin_op();
    800048e6:	df9fe0ef          	jal	800036de <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    800048ea:	fb040593          	addi	a1,s0,-80
    800048ee:	f3040513          	addi	a0,s0,-208
    800048f2:	c29fe0ef          	jal	8000351a <nameiparent>
    800048f6:	84aa                	mv	s1,a0
    800048f8:	c955                	beqz	a0,800049ac <sys_unlink+0xe2>
  ilock(dp);
    800048fa:	bd8fe0ef          	jal	80002cd2 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    800048fe:	00004597          	auipc	a1,0x4
    80004902:	daa58593          	addi	a1,a1,-598 # 800086a8 <etext+0x6a8>
    80004906:	fb040513          	addi	a0,s0,-80
    8000490a:	94dfe0ef          	jal	80003256 <namecmp>
    8000490e:	10050b63          	beqz	a0,80004a24 <sys_unlink+0x15a>
    80004912:	00004597          	auipc	a1,0x4
    80004916:	d9e58593          	addi	a1,a1,-610 # 800086b0 <etext+0x6b0>
    8000491a:	fb040513          	addi	a0,s0,-80
    8000491e:	939fe0ef          	jal	80003256 <namecmp>
    80004922:	10050163          	beqz	a0,80004a24 <sys_unlink+0x15a>
    80004926:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    80004928:	f2c40613          	addi	a2,s0,-212
    8000492c:	fb040593          	addi	a1,s0,-80
    80004930:	8526                	mv	a0,s1
    80004932:	93bfe0ef          	jal	8000326c <dirlookup>
    80004936:	892a                	mv	s2,a0
    80004938:	0e050563          	beqz	a0,80004a22 <sys_unlink+0x158>
    8000493c:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    8000493e:	b94fe0ef          	jal	80002cd2 <ilock>
  if(ip->nlink < 1)
    80004942:	04a91783          	lh	a5,74(s2)
    80004946:	06f05863          	blez	a5,800049b6 <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000494a:	04491703          	lh	a4,68(s2)
    8000494e:	4785                	li	a5,1
    80004950:	06f70963          	beq	a4,a5,800049c2 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004954:	fc040993          	addi	s3,s0,-64
    80004958:	4641                	li	a2,16
    8000495a:	4581                	li	a1,0
    8000495c:	854e                	mv	a0,s3
    8000495e:	93ffb0ef          	jal	8000029c <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004962:	4741                	li	a4,16
    80004964:	f2c42683          	lw	a3,-212(s0)
    80004968:	864e                	mv	a2,s3
    8000496a:	4581                	li	a1,0
    8000496c:	8526                	mv	a0,s1
    8000496e:	fe8fe0ef          	jal	80003156 <writei>
    80004972:	47c1                	li	a5,16
    80004974:	08f51863          	bne	a0,a5,80004a04 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    80004978:	04491703          	lh	a4,68(s2)
    8000497c:	4785                	li	a5,1
    8000497e:	08f70963          	beq	a4,a5,80004a10 <sys_unlink+0x146>
  iunlockput(dp);
    80004982:	8526                	mv	a0,s1
    80004984:	d5afe0ef          	jal	80002ede <iunlockput>
  ip->nlink--;
    80004988:	04a95783          	lhu	a5,74(s2)
    8000498c:	37fd                	addiw	a5,a5,-1
    8000498e:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    80004992:	854a                	mv	a0,s2
    80004994:	a8afe0ef          	jal	80002c1e <iupdate>
  iunlockput(ip);
    80004998:	854a                	mv	a0,s2
    8000499a:	d44fe0ef          	jal	80002ede <iunlockput>
  end_op();
    8000499e:	db1fe0ef          	jal	8000374e <end_op>
  return 0;
    800049a2:	4501                	li	a0,0
    800049a4:	64ee                	ld	s1,216(sp)
    800049a6:	694e                	ld	s2,208(sp)
    800049a8:	69ae                	ld	s3,200(sp)
    800049aa:	a061                	j	80004a32 <sys_unlink+0x168>
    end_op();
    800049ac:	da3fe0ef          	jal	8000374e <end_op>
    return -1;
    800049b0:	557d                	li	a0,-1
    800049b2:	64ee                	ld	s1,216(sp)
    800049b4:	a8bd                	j	80004a32 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800049b6:	00004517          	auipc	a0,0x4
    800049ba:	d0250513          	addi	a0,a0,-766 # 800086b8 <etext+0x6b8>
    800049be:	2f8010ef          	jal	80005cb6 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049c2:	04c92703          	lw	a4,76(s2)
    800049c6:	02000793          	li	a5,32
    800049ca:	f8e7f5e3          	bgeu	a5,a4,80004954 <sys_unlink+0x8a>
    800049ce:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800049d0:	4741                	li	a4,16
    800049d2:	86ce                	mv	a3,s3
    800049d4:	f1840613          	addi	a2,s0,-232
    800049d8:	4581                	li	a1,0
    800049da:	854a                	mv	a0,s2
    800049dc:	e88fe0ef          	jal	80003064 <readi>
    800049e0:	47c1                	li	a5,16
    800049e2:	00f51b63          	bne	a0,a5,800049f8 <sys_unlink+0x12e>
    if(de.inum != 0)
    800049e6:	f1845783          	lhu	a5,-232(s0)
    800049ea:	ebb1                	bnez	a5,80004a3e <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800049ec:	29c1                	addiw	s3,s3,16
    800049ee:	04c92783          	lw	a5,76(s2)
    800049f2:	fcf9efe3          	bltu	s3,a5,800049d0 <sys_unlink+0x106>
    800049f6:	bfb9                	j	80004954 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    800049f8:	00004517          	auipc	a0,0x4
    800049fc:	cd850513          	addi	a0,a0,-808 # 800086d0 <etext+0x6d0>
    80004a00:	2b6010ef          	jal	80005cb6 <panic>
    panic("unlink: writei");
    80004a04:	00004517          	auipc	a0,0x4
    80004a08:	ce450513          	addi	a0,a0,-796 # 800086e8 <etext+0x6e8>
    80004a0c:	2aa010ef          	jal	80005cb6 <panic>
    dp->nlink--;
    80004a10:	04a4d783          	lhu	a5,74(s1)
    80004a14:	37fd                	addiw	a5,a5,-1
    80004a16:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004a1a:	8526                	mv	a0,s1
    80004a1c:	a02fe0ef          	jal	80002c1e <iupdate>
    80004a20:	b78d                	j	80004982 <sys_unlink+0xb8>
    80004a22:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004a24:	8526                	mv	a0,s1
    80004a26:	cb8fe0ef          	jal	80002ede <iunlockput>
  end_op();
    80004a2a:	d25fe0ef          	jal	8000374e <end_op>
  return -1;
    80004a2e:	557d                	li	a0,-1
    80004a30:	64ee                	ld	s1,216(sp)
}
    80004a32:	70ae                	ld	ra,232(sp)
    80004a34:	740e                	ld	s0,224(sp)
    80004a36:	616d                	addi	sp,sp,240
    80004a38:	8082                	ret
    return -1;
    80004a3a:	557d                	li	a0,-1
    80004a3c:	bfdd                	j	80004a32 <sys_unlink+0x168>
    iunlockput(ip);
    80004a3e:	854a                	mv	a0,s2
    80004a40:	c9efe0ef          	jal	80002ede <iunlockput>
    goto bad;
    80004a44:	694e                	ld	s2,208(sp)
    80004a46:	69ae                	ld	s3,200(sp)
    80004a48:	bff1                	j	80004a24 <sys_unlink+0x15a>

0000000080004a4a <sys_open>:

uint64
sys_open(void)
{
    80004a4a:	7131                	addi	sp,sp,-192
    80004a4c:	fd06                	sd	ra,184(sp)
    80004a4e:	f922                	sd	s0,176(sp)
    80004a50:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004a52:	f4c40593          	addi	a1,s0,-180
    80004a56:	4505                	li	a0,1
    80004a58:	869fd0ef          	jal	800022c0 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a5c:	08000613          	li	a2,128
    80004a60:	f5040593          	addi	a1,s0,-176
    80004a64:	4501                	li	a0,0
    80004a66:	893fd0ef          	jal	800022f8 <argstr>
    80004a6a:	87aa                	mv	a5,a0
    return -1;
    80004a6c:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004a6e:	0a07c363          	bltz	a5,80004b14 <sys_open+0xca>
    80004a72:	f526                	sd	s1,168(sp)

  begin_op();
    80004a74:	c6bfe0ef          	jal	800036de <begin_op>

  if(omode & O_CREATE){
    80004a78:	f4c42783          	lw	a5,-180(s0)
    80004a7c:	2007f793          	andi	a5,a5,512
    80004a80:	c3dd                	beqz	a5,80004b26 <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    80004a82:	4681                	li	a3,0
    80004a84:	4601                	li	a2,0
    80004a86:	4589                	li	a1,2
    80004a88:	f5040513          	addi	a0,s0,-176
    80004a8c:	aafff0ef          	jal	8000453a <create>
    80004a90:	84aa                	mv	s1,a0
    if(ip == 0){
    80004a92:	c549                	beqz	a0,80004b1c <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    80004a94:	04449703          	lh	a4,68(s1)
    80004a98:	478d                	li	a5,3
    80004a9a:	00f71763          	bne	a4,a5,80004aa8 <sys_open+0x5e>
    80004a9e:	0464d703          	lhu	a4,70(s1)
    80004aa2:	47a5                	li	a5,9
    80004aa4:	0ae7ee63          	bltu	a5,a4,80004b60 <sys_open+0x116>
    80004aa8:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    80004aaa:	fb5fe0ef          	jal	80003a5e <filealloc>
    80004aae:	892a                	mv	s2,a0
    80004ab0:	c561                	beqz	a0,80004b78 <sys_open+0x12e>
    80004ab2:	ed4e                	sd	s3,152(sp)
    80004ab4:	a47ff0ef          	jal	800044fa <fdalloc>
    80004ab8:	89aa                	mv	s3,a0
    80004aba:	0a054b63          	bltz	a0,80004b70 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    80004abe:	04449703          	lh	a4,68(s1)
    80004ac2:	478d                	li	a5,3
    80004ac4:	0cf70363          	beq	a4,a5,80004b8a <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    80004ac8:	4789                	li	a5,2
    80004aca:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004ace:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004ad2:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    80004ad6:	f4c42783          	lw	a5,-180(s0)
    80004ada:	0017f713          	andi	a4,a5,1
    80004ade:	00174713          	xori	a4,a4,1
    80004ae2:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ae6:	0037f713          	andi	a4,a5,3
    80004aea:	00e03733          	snez	a4,a4
    80004aee:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004af2:	4007f793          	andi	a5,a5,1024
    80004af6:	c791                	beqz	a5,80004b02 <sys_open+0xb8>
    80004af8:	04449703          	lh	a4,68(s1)
    80004afc:	4789                	li	a5,2
    80004afe:	08f70d63          	beq	a4,a5,80004b98 <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004b02:	8526                	mv	a0,s1
    80004b04:	a7cfe0ef          	jal	80002d80 <iunlock>
  end_op();
    80004b08:	c47fe0ef          	jal	8000374e <end_op>

  return fd;
    80004b0c:	854e                	mv	a0,s3
    80004b0e:	74aa                	ld	s1,168(sp)
    80004b10:	790a                	ld	s2,160(sp)
    80004b12:	69ea                	ld	s3,152(sp)
}
    80004b14:	70ea                	ld	ra,184(sp)
    80004b16:	744a                	ld	s0,176(sp)
    80004b18:	6129                	addi	sp,sp,192
    80004b1a:	8082                	ret
      end_op();
    80004b1c:	c33fe0ef          	jal	8000374e <end_op>
      return -1;
    80004b20:	557d                	li	a0,-1
    80004b22:	74aa                	ld	s1,168(sp)
    80004b24:	bfc5                	j	80004b14 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    80004b26:	f5040513          	addi	a0,s0,-176
    80004b2a:	9d7fe0ef          	jal	80003500 <namei>
    80004b2e:	84aa                	mv	s1,a0
    80004b30:	c11d                	beqz	a0,80004b56 <sys_open+0x10c>
    ilock(ip);
    80004b32:	9a0fe0ef          	jal	80002cd2 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    80004b36:	04449703          	lh	a4,68(s1)
    80004b3a:	4785                	li	a5,1
    80004b3c:	f4f71ce3          	bne	a4,a5,80004a94 <sys_open+0x4a>
    80004b40:	f4c42783          	lw	a5,-180(s0)
    80004b44:	d3b5                	beqz	a5,80004aa8 <sys_open+0x5e>
      iunlockput(ip);
    80004b46:	8526                	mv	a0,s1
    80004b48:	b96fe0ef          	jal	80002ede <iunlockput>
      end_op();
    80004b4c:	c03fe0ef          	jal	8000374e <end_op>
      return -1;
    80004b50:	557d                	li	a0,-1
    80004b52:	74aa                	ld	s1,168(sp)
    80004b54:	b7c1                	j	80004b14 <sys_open+0xca>
      end_op();
    80004b56:	bf9fe0ef          	jal	8000374e <end_op>
      return -1;
    80004b5a:	557d                	li	a0,-1
    80004b5c:	74aa                	ld	s1,168(sp)
    80004b5e:	bf5d                	j	80004b14 <sys_open+0xca>
    iunlockput(ip);
    80004b60:	8526                	mv	a0,s1
    80004b62:	b7cfe0ef          	jal	80002ede <iunlockput>
    end_op();
    80004b66:	be9fe0ef          	jal	8000374e <end_op>
    return -1;
    80004b6a:	557d                	li	a0,-1
    80004b6c:	74aa                	ld	s1,168(sp)
    80004b6e:	b75d                	j	80004b14 <sys_open+0xca>
      fileclose(f);
    80004b70:	854a                	mv	a0,s2
    80004b72:	f91fe0ef          	jal	80003b02 <fileclose>
    80004b76:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    80004b78:	8526                	mv	a0,s1
    80004b7a:	b64fe0ef          	jal	80002ede <iunlockput>
    end_op();
    80004b7e:	bd1fe0ef          	jal	8000374e <end_op>
    return -1;
    80004b82:	557d                	li	a0,-1
    80004b84:	74aa                	ld	s1,168(sp)
    80004b86:	790a                	ld	s2,160(sp)
    80004b88:	b771                	j	80004b14 <sys_open+0xca>
    f->type = FD_DEVICE;
    80004b8a:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    80004b8e:	04649783          	lh	a5,70(s1)
    80004b92:	02f91223          	sh	a5,36(s2)
    80004b96:	bf35                	j	80004ad2 <sys_open+0x88>
    itrunc(ip);
    80004b98:	8526                	mv	a0,s1
    80004b9a:	a26fe0ef          	jal	80002dc0 <itrunc>
    80004b9e:	b795                	j	80004b02 <sys_open+0xb8>

0000000080004ba0 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ba0:	7175                	addi	sp,sp,-144
    80004ba2:	e506                	sd	ra,136(sp)
    80004ba4:	e122                	sd	s0,128(sp)
    80004ba6:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    80004ba8:	b37fe0ef          	jal	800036de <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    80004bac:	08000613          	li	a2,128
    80004bb0:	f7040593          	addi	a1,s0,-144
    80004bb4:	4501                	li	a0,0
    80004bb6:	f42fd0ef          	jal	800022f8 <argstr>
    80004bba:	02054363          	bltz	a0,80004be0 <sys_mkdir+0x40>
    80004bbe:	4681                	li	a3,0
    80004bc0:	4601                	li	a2,0
    80004bc2:	4585                	li	a1,1
    80004bc4:	f7040513          	addi	a0,s0,-144
    80004bc8:	973ff0ef          	jal	8000453a <create>
    80004bcc:	c911                	beqz	a0,80004be0 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004bce:	b10fe0ef          	jal	80002ede <iunlockput>
  end_op();
    80004bd2:	b7dfe0ef          	jal	8000374e <end_op>
  return 0;
    80004bd6:	4501                	li	a0,0
}
    80004bd8:	60aa                	ld	ra,136(sp)
    80004bda:	640a                	ld	s0,128(sp)
    80004bdc:	6149                	addi	sp,sp,144
    80004bde:	8082                	ret
    end_op();
    80004be0:	b6ffe0ef          	jal	8000374e <end_op>
    return -1;
    80004be4:	557d                	li	a0,-1
    80004be6:	bfcd                	j	80004bd8 <sys_mkdir+0x38>

0000000080004be8 <sys_mknod>:

uint64
sys_mknod(void)
{
    80004be8:	7135                	addi	sp,sp,-160
    80004bea:	ed06                	sd	ra,152(sp)
    80004bec:	e922                	sd	s0,144(sp)
    80004bee:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004bf0:	aeffe0ef          	jal	800036de <begin_op>
  argint(1, &major);
    80004bf4:	f6c40593          	addi	a1,s0,-148
    80004bf8:	4505                	li	a0,1
    80004bfa:	ec6fd0ef          	jal	800022c0 <argint>
  argint(2, &minor);
    80004bfe:	f6840593          	addi	a1,s0,-152
    80004c02:	4509                	li	a0,2
    80004c04:	ebcfd0ef          	jal	800022c0 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c08:	08000613          	li	a2,128
    80004c0c:	f7040593          	addi	a1,s0,-144
    80004c10:	4501                	li	a0,0
    80004c12:	ee6fd0ef          	jal	800022f8 <argstr>
    80004c16:	02054563          	bltz	a0,80004c40 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    80004c1a:	f6841683          	lh	a3,-152(s0)
    80004c1e:	f6c41603          	lh	a2,-148(s0)
    80004c22:	458d                	li	a1,3
    80004c24:	f7040513          	addi	a0,s0,-144
    80004c28:	913ff0ef          	jal	8000453a <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004c2c:	c911                	beqz	a0,80004c40 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004c2e:	ab0fe0ef          	jal	80002ede <iunlockput>
  end_op();
    80004c32:	b1dfe0ef          	jal	8000374e <end_op>
  return 0;
    80004c36:	4501                	li	a0,0
}
    80004c38:	60ea                	ld	ra,152(sp)
    80004c3a:	644a                	ld	s0,144(sp)
    80004c3c:	610d                	addi	sp,sp,160
    80004c3e:	8082                	ret
    end_op();
    80004c40:	b0ffe0ef          	jal	8000374e <end_op>
    return -1;
    80004c44:	557d                	li	a0,-1
    80004c46:	bfcd                	j	80004c38 <sys_mknod+0x50>

0000000080004c48 <sys_chdir>:

uint64
sys_chdir(void)
{
    80004c48:	7135                	addi	sp,sp,-160
    80004c4a:	ed06                	sd	ra,152(sp)
    80004c4c:	e922                	sd	s0,144(sp)
    80004c4e:	e14a                	sd	s2,128(sp)
    80004c50:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004c52:	eeefc0ef          	jal	80001340 <myproc>
    80004c56:	892a                	mv	s2,a0
  
  begin_op();
    80004c58:	a87fe0ef          	jal	800036de <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004c5c:	08000613          	li	a2,128
    80004c60:	f6040593          	addi	a1,s0,-160
    80004c64:	4501                	li	a0,0
    80004c66:	e92fd0ef          	jal	800022f8 <argstr>
    80004c6a:	04054363          	bltz	a0,80004cb0 <sys_chdir+0x68>
    80004c6e:	e526                	sd	s1,136(sp)
    80004c70:	f6040513          	addi	a0,s0,-160
    80004c74:	88dfe0ef          	jal	80003500 <namei>
    80004c78:	84aa                	mv	s1,a0
    80004c7a:	c915                	beqz	a0,80004cae <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    80004c7c:	856fe0ef          	jal	80002cd2 <ilock>
  if(ip->type != T_DIR){
    80004c80:	04449703          	lh	a4,68(s1)
    80004c84:	4785                	li	a5,1
    80004c86:	02f71963          	bne	a4,a5,80004cb8 <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    80004c8a:	8526                	mv	a0,s1
    80004c8c:	8f4fe0ef          	jal	80002d80 <iunlock>
  iput(p->cwd);
    80004c90:	15893503          	ld	a0,344(s2)
    80004c94:	9c0fe0ef          	jal	80002e54 <iput>
  end_op();
    80004c98:	ab7fe0ef          	jal	8000374e <end_op>
  p->cwd = ip;
    80004c9c:	14993c23          	sd	s1,344(s2)
  return 0;
    80004ca0:	4501                	li	a0,0
    80004ca2:	64aa                	ld	s1,136(sp)
}
    80004ca4:	60ea                	ld	ra,152(sp)
    80004ca6:	644a                	ld	s0,144(sp)
    80004ca8:	690a                	ld	s2,128(sp)
    80004caa:	610d                	addi	sp,sp,160
    80004cac:	8082                	ret
    80004cae:	64aa                	ld	s1,136(sp)
    end_op();
    80004cb0:	a9ffe0ef          	jal	8000374e <end_op>
    return -1;
    80004cb4:	557d                	li	a0,-1
    80004cb6:	b7fd                	j	80004ca4 <sys_chdir+0x5c>
    iunlockput(ip);
    80004cb8:	8526                	mv	a0,s1
    80004cba:	a24fe0ef          	jal	80002ede <iunlockput>
    end_op();
    80004cbe:	a91fe0ef          	jal	8000374e <end_op>
    return -1;
    80004cc2:	557d                	li	a0,-1
    80004cc4:	64aa                	ld	s1,136(sp)
    80004cc6:	bff9                	j	80004ca4 <sys_chdir+0x5c>

0000000080004cc8 <sys_exec>:

uint64
sys_exec(void)
{
    80004cc8:	7105                	addi	sp,sp,-480
    80004cca:	ef86                	sd	ra,472(sp)
    80004ccc:	eba2                	sd	s0,464(sp)
    80004cce:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004cd0:	e2840593          	addi	a1,s0,-472
    80004cd4:	4505                	li	a0,1
    80004cd6:	e06fd0ef          	jal	800022dc <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    80004cda:	08000613          	li	a2,128
    80004cde:	f3040593          	addi	a1,s0,-208
    80004ce2:	4501                	li	a0,0
    80004ce4:	e14fd0ef          	jal	800022f8 <argstr>
    80004ce8:	87aa                	mv	a5,a0
    return -1;
    80004cea:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004cec:	0e07c063          	bltz	a5,80004dcc <sys_exec+0x104>
    80004cf0:	e7a6                	sd	s1,456(sp)
    80004cf2:	e3ca                	sd	s2,448(sp)
    80004cf4:	ff4e                	sd	s3,440(sp)
    80004cf6:	fb52                	sd	s4,432(sp)
    80004cf8:	f756                	sd	s5,424(sp)
    80004cfa:	f35a                	sd	s6,416(sp)
    80004cfc:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004cfe:	e3040a13          	addi	s4,s0,-464
    80004d02:	10000613          	li	a2,256
    80004d06:	4581                	li	a1,0
    80004d08:	8552                	mv	a0,s4
    80004d0a:	d92fb0ef          	jal	8000029c <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004d0e:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004d10:	89d2                	mv	s3,s4
    80004d12:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004d14:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004d18:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    80004d1a:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004d1e:	00391513          	slli	a0,s2,0x3
    80004d22:	85d6                	mv	a1,s5
    80004d24:	e2843783          	ld	a5,-472(s0)
    80004d28:	953e                	add	a0,a0,a5
    80004d2a:	d0cfd0ef          	jal	80002236 <fetchaddr>
    80004d2e:	02054663          	bltz	a0,80004d5a <sys_exec+0x92>
    if(uarg == 0){
    80004d32:	e2043783          	ld	a5,-480(s0)
    80004d36:	c7a1                	beqz	a5,80004d7e <sys_exec+0xb6>
    argv[i] = kalloc();
    80004d38:	b9afb0ef          	jal	800000d2 <kalloc>
    80004d3c:	85aa                	mv	a1,a0
    80004d3e:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004d42:	cd01                	beqz	a0,80004d5a <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004d44:	865a                	mv	a2,s6
    80004d46:	e2043503          	ld	a0,-480(s0)
    80004d4a:	d36fd0ef          	jal	80002280 <fetchstr>
    80004d4e:	00054663          	bltz	a0,80004d5a <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004d52:	0905                	addi	s2,s2,1
    80004d54:	09a1                	addi	s3,s3,8
    80004d56:	fd7914e3          	bne	s2,s7,80004d1e <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004d5a:	100a0a13          	addi	s4,s4,256
    80004d5e:	6088                	ld	a0,0(s1)
    80004d60:	cd31                	beqz	a0,80004dbc <sys_exec+0xf4>
    kfree(argv[i]);
    80004d62:	abafb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004d66:	04a1                	addi	s1,s1,8
    80004d68:	ff449be3          	bne	s1,s4,80004d5e <sys_exec+0x96>
  return -1;
    80004d6c:	557d                	li	a0,-1
    80004d6e:	64be                	ld	s1,456(sp)
    80004d70:	691e                	ld	s2,448(sp)
    80004d72:	79fa                	ld	s3,440(sp)
    80004d74:	7a5a                	ld	s4,432(sp)
    80004d76:	7aba                	ld	s5,424(sp)
    80004d78:	7b1a                	ld	s6,416(sp)
    80004d7a:	6bfa                	ld	s7,408(sp)
    80004d7c:	a881                	j	80004dcc <sys_exec+0x104>
      argv[i] = 0;
    80004d7e:	0009079b          	sext.w	a5,s2
    80004d82:	e3040593          	addi	a1,s0,-464
    80004d86:	078e                	slli	a5,a5,0x3
    80004d88:	97ae                	add	a5,a5,a1
    80004d8a:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    80004d8e:	f3040513          	addi	a0,s0,-208
    80004d92:	bb2ff0ef          	jal	80004144 <kexec>
    80004d96:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004d98:	100a0a13          	addi	s4,s4,256
    80004d9c:	6088                	ld	a0,0(s1)
    80004d9e:	c511                	beqz	a0,80004daa <sys_exec+0xe2>
    kfree(argv[i]);
    80004da0:	a7cfb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80004da4:	04a1                	addi	s1,s1,8
    80004da6:	ff449be3          	bne	s1,s4,80004d9c <sys_exec+0xd4>
  return ret;
    80004daa:	854a                	mv	a0,s2
    80004dac:	64be                	ld	s1,456(sp)
    80004dae:	691e                	ld	s2,448(sp)
    80004db0:	79fa                	ld	s3,440(sp)
    80004db2:	7a5a                	ld	s4,432(sp)
    80004db4:	7aba                	ld	s5,424(sp)
    80004db6:	7b1a                	ld	s6,416(sp)
    80004db8:	6bfa                	ld	s7,408(sp)
    80004dba:	a809                	j	80004dcc <sys_exec+0x104>
  return -1;
    80004dbc:	557d                	li	a0,-1
    80004dbe:	64be                	ld	s1,456(sp)
    80004dc0:	691e                	ld	s2,448(sp)
    80004dc2:	79fa                	ld	s3,440(sp)
    80004dc4:	7a5a                	ld	s4,432(sp)
    80004dc6:	7aba                	ld	s5,424(sp)
    80004dc8:	7b1a                	ld	s6,416(sp)
    80004dca:	6bfa                	ld	s7,408(sp)
}
    80004dcc:	60fe                	ld	ra,472(sp)
    80004dce:	645e                	ld	s0,464(sp)
    80004dd0:	613d                	addi	sp,sp,480
    80004dd2:	8082                	ret

0000000080004dd4 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004dd4:	7139                	addi	sp,sp,-64
    80004dd6:	fc06                	sd	ra,56(sp)
    80004dd8:	f822                	sd	s0,48(sp)
    80004dda:	f426                	sd	s1,40(sp)
    80004ddc:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004dde:	d62fc0ef          	jal	80001340 <myproc>
    80004de2:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004de4:	fd840593          	addi	a1,s0,-40
    80004de8:	4501                	li	a0,0
    80004dea:	cf2fd0ef          	jal	800022dc <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004dee:	fc840593          	addi	a1,s0,-56
    80004df2:	fd040513          	addi	a0,s0,-48
    80004df6:	828ff0ef          	jal	80003e1e <pipealloc>
    return -1;
    80004dfa:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004dfc:	0a054763          	bltz	a0,80004eaa <sys_pipe+0xd6>
  fd0 = -1;
    80004e00:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004e04:	fd043503          	ld	a0,-48(s0)
    80004e08:	ef2ff0ef          	jal	800044fa <fdalloc>
    80004e0c:	fca42223          	sw	a0,-60(s0)
    80004e10:	08054463          	bltz	a0,80004e98 <sys_pipe+0xc4>
    80004e14:	fc843503          	ld	a0,-56(s0)
    80004e18:	ee2ff0ef          	jal	800044fa <fdalloc>
    80004e1c:	fca42023          	sw	a0,-64(s0)
    80004e20:	06054263          	bltz	a0,80004e84 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004e24:	4691                	li	a3,4
    80004e26:	fc440613          	addi	a2,s0,-60
    80004e2a:	fd843583          	ld	a1,-40(s0)
    80004e2e:	68a8                	ld	a0,80(s1)
    80004e30:	a20fc0ef          	jal	80001050 <copyout>
    80004e34:	00054e63          	bltz	a0,80004e50 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004e38:	4691                	li	a3,4
    80004e3a:	fc040613          	addi	a2,s0,-64
    80004e3e:	fd843583          	ld	a1,-40(s0)
    80004e42:	95b6                	add	a1,a1,a3
    80004e44:	68a8                	ld	a0,80(s1)
    80004e46:	a0afc0ef          	jal	80001050 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004e4a:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004e4c:	04055f63          	bgez	a0,80004eaa <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80004e50:	fc442783          	lw	a5,-60(s0)
    80004e54:	078e                	slli	a5,a5,0x3
    80004e56:	0d078793          	addi	a5,a5,208
    80004e5a:	97a6                	add	a5,a5,s1
    80004e5c:	0007b423          	sd	zero,8(a5)
    p->ofile[fd1] = 0;
    80004e60:	fc042783          	lw	a5,-64(s0)
    80004e64:	078e                	slli	a5,a5,0x3
    80004e66:	0d078793          	addi	a5,a5,208
    80004e6a:	97a6                	add	a5,a5,s1
    80004e6c:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004e70:	fd043503          	ld	a0,-48(s0)
    80004e74:	c8ffe0ef          	jal	80003b02 <fileclose>
    fileclose(wf);
    80004e78:	fc843503          	ld	a0,-56(s0)
    80004e7c:	c87fe0ef          	jal	80003b02 <fileclose>
    return -1;
    80004e80:	57fd                	li	a5,-1
    80004e82:	a025                	j	80004eaa <sys_pipe+0xd6>
    if(fd0 >= 0)
    80004e84:	fc442783          	lw	a5,-60(s0)
    80004e88:	0007c863          	bltz	a5,80004e98 <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004e8c:	078e                	slli	a5,a5,0x3
    80004e8e:	0d078793          	addi	a5,a5,208
    80004e92:	97a6                	add	a5,a5,s1
    80004e94:	0007b423          	sd	zero,8(a5)
    fileclose(rf);
    80004e98:	fd043503          	ld	a0,-48(s0)
    80004e9c:	c67fe0ef          	jal	80003b02 <fileclose>
    fileclose(wf);
    80004ea0:	fc843503          	ld	a0,-56(s0)
    80004ea4:	c5ffe0ef          	jal	80003b02 <fileclose>
    return -1;
    80004ea8:	57fd                	li	a5,-1
}
    80004eaa:	853e                	mv	a0,a5
    80004eac:	70e2                	ld	ra,56(sp)
    80004eae:	7442                	ld	s0,48(sp)
    80004eb0:	74a2                	ld	s1,40(sp)
    80004eb2:	6121                	addi	sp,sp,64
    80004eb4:	8082                	ret
	...

0000000080004ec0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004ec0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004ec2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004ec4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004ec6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004ec8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80004eca:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80004ecc:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80004ece:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004ed0:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004ed2:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004ed4:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004ed6:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004ed8:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80004eda:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80004edc:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80004ede:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004ee0:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004ee2:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004ee4:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004ee6:	a5efd0ef          	jal	80002144 <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80004eea:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80004eec:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80004eee:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004ef0:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004ef2:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004ef4:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004ef6:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004ef8:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80004efa:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80004efc:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80004efe:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004f00:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004f02:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004f04:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004f06:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004f08:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80004f0a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80004f0c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80004f0e:	10200073          	sret
    80004f12:	00000013          	nop
    80004f16:	00000013          	nop
    80004f1a:	00000013          	nop

0000000080004f1e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004f1e:	1141                	addi	sp,sp,-16
    80004f20:	e406                	sd	ra,8(sp)
    80004f22:	e022                	sd	s0,0(sp)
    80004f24:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004f26:	0c000737          	lui	a4,0xc000
    80004f2a:	4785                	li	a5,1
    80004f2c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004f2e:	c35c                	sw	a5,4(a4)
}
    80004f30:	60a2                	ld	ra,8(sp)
    80004f32:	6402                	ld	s0,0(sp)
    80004f34:	0141                	addi	sp,sp,16
    80004f36:	8082                	ret

0000000080004f38 <plicinithart>:

void
plicinithart(void)
{
    80004f38:	1141                	addi	sp,sp,-16
    80004f3a:	e406                	sd	ra,8(sp)
    80004f3c:	e022                	sd	s0,0(sp)
    80004f3e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004f40:	bccfc0ef          	jal	8000130c <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004f44:	0085171b          	slliw	a4,a0,0x8
    80004f48:	0c0027b7          	lui	a5,0xc002
    80004f4c:	97ba                	add	a5,a5,a4
    80004f4e:	40200713          	li	a4,1026
    80004f52:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004f56:	00d5151b          	slliw	a0,a0,0xd
    80004f5a:	0c2017b7          	lui	a5,0xc201
    80004f5e:	97aa                	add	a5,a5,a0
    80004f60:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004f64:	60a2                	ld	ra,8(sp)
    80004f66:	6402                	ld	s0,0(sp)
    80004f68:	0141                	addi	sp,sp,16
    80004f6a:	8082                	ret

0000000080004f6c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004f6c:	1141                	addi	sp,sp,-16
    80004f6e:	e406                	sd	ra,8(sp)
    80004f70:	e022                	sd	s0,0(sp)
    80004f72:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004f74:	b98fc0ef          	jal	8000130c <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004f78:	00d5151b          	slliw	a0,a0,0xd
    80004f7c:	0c2017b7          	lui	a5,0xc201
    80004f80:	97aa                	add	a5,a5,a0
  return irq;
}
    80004f82:	43c8                	lw	a0,4(a5)
    80004f84:	60a2                	ld	ra,8(sp)
    80004f86:	6402                	ld	s0,0(sp)
    80004f88:	0141                	addi	sp,sp,16
    80004f8a:	8082                	ret

0000000080004f8c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004f8c:	1101                	addi	sp,sp,-32
    80004f8e:	ec06                	sd	ra,24(sp)
    80004f90:	e822                	sd	s0,16(sp)
    80004f92:	e426                	sd	s1,8(sp)
    80004f94:	1000                	addi	s0,sp,32
    80004f96:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004f98:	b74fc0ef          	jal	8000130c <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004f9c:	00d5179b          	slliw	a5,a0,0xd
    80004fa0:	0c201737          	lui	a4,0xc201
    80004fa4:	97ba                	add	a5,a5,a4
    80004fa6:	c3c4                	sw	s1,4(a5)
}
    80004fa8:	60e2                	ld	ra,24(sp)
    80004faa:	6442                	ld	s0,16(sp)
    80004fac:	64a2                	ld	s1,8(sp)
    80004fae:	6105                	addi	sp,sp,32
    80004fb0:	8082                	ret

0000000080004fb2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004fb2:	1141                	addi	sp,sp,-16
    80004fb4:	e406                	sd	ra,8(sp)
    80004fb6:	e022                	sd	s0,0(sp)
    80004fb8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004fba:	479d                	li	a5,7
    80004fbc:	04a7ca63          	blt	a5,a0,80005010 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004fc0:	00017797          	auipc	a5,0x17
    80004fc4:	f6078793          	addi	a5,a5,-160 # 8001bf20 <disk>
    80004fc8:	97aa                	add	a5,a5,a0
    80004fca:	0187c783          	lbu	a5,24(a5)
    80004fce:	e7b9                	bnez	a5,8000501c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004fd0:	00451693          	slli	a3,a0,0x4
    80004fd4:	00017797          	auipc	a5,0x17
    80004fd8:	f4c78793          	addi	a5,a5,-180 # 8001bf20 <disk>
    80004fdc:	6398                	ld	a4,0(a5)
    80004fde:	9736                	add	a4,a4,a3
    80004fe0:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004fe4:	6398                	ld	a4,0(a5)
    80004fe6:	9736                	add	a4,a4,a3
    80004fe8:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004fec:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004ff0:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004ff4:	97aa                	add	a5,a5,a0
    80004ff6:	4705                	li	a4,1
    80004ff8:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004ffc:	00017517          	auipc	a0,0x17
    80005000:	f3c50513          	addi	a0,a0,-196 # 8001bf38 <disk+0x18>
    80005004:	9fdfc0ef          	jal	80001a00 <wakeup>
}
    80005008:	60a2                	ld	ra,8(sp)
    8000500a:	6402                	ld	s0,0(sp)
    8000500c:	0141                	addi	sp,sp,16
    8000500e:	8082                	ret
    panic("free_desc 1");
    80005010:	00003517          	auipc	a0,0x3
    80005014:	6e850513          	addi	a0,a0,1768 # 800086f8 <etext+0x6f8>
    80005018:	49f000ef          	jal	80005cb6 <panic>
    panic("free_desc 2");
    8000501c:	00003517          	auipc	a0,0x3
    80005020:	6ec50513          	addi	a0,a0,1772 # 80008708 <etext+0x708>
    80005024:	493000ef          	jal	80005cb6 <panic>

0000000080005028 <virtio_disk_init>:
{
    80005028:	1101                	addi	sp,sp,-32
    8000502a:	ec06                	sd	ra,24(sp)
    8000502c:	e822                	sd	s0,16(sp)
    8000502e:	e426                	sd	s1,8(sp)
    80005030:	e04a                	sd	s2,0(sp)
    80005032:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005034:	00003597          	auipc	a1,0x3
    80005038:	6e458593          	addi	a1,a1,1764 # 80008718 <etext+0x718>
    8000503c:	00017517          	auipc	a0,0x17
    80005040:	00c50513          	addi	a0,a0,12 # 8001c048 <disk+0x128>
    80005044:	6ab000ef          	jal	80005eee <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005048:	100017b7          	lui	a5,0x10001
    8000504c:	4398                	lw	a4,0(a5)
    8000504e:	2701                	sext.w	a4,a4
    80005050:	747277b7          	lui	a5,0x74727
    80005054:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80005058:	14f71863          	bne	a4,a5,800051a8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    8000505c:	100017b7          	lui	a5,0x10001
    80005060:	43dc                	lw	a5,4(a5)
    80005062:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005064:	4709                	li	a4,2
    80005066:	14e79163          	bne	a5,a4,800051a8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000506a:	100017b7          	lui	a5,0x10001
    8000506e:	479c                	lw	a5,8(a5)
    80005070:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005072:	12e79b63          	bne	a5,a4,800051a8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80005076:	100017b7          	lui	a5,0x10001
    8000507a:	47d8                	lw	a4,12(a5)
    8000507c:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000507e:	554d47b7          	lui	a5,0x554d4
    80005082:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80005086:	12f71163          	bne	a4,a5,800051a8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000508a:	100017b7          	lui	a5,0x10001
    8000508e:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005092:	4705                	li	a4,1
    80005094:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80005096:	470d                	li	a4,3
    80005098:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000509a:	10001737          	lui	a4,0x10001
    8000509e:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800050a0:	c7ffe6b7          	lui	a3,0xc7ffe
    800050a4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47fda627>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800050a8:	8f75                	and	a4,a4,a3
    800050aa:	100016b7          	lui	a3,0x10001
    800050ae:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    800050b0:	472d                	li	a4,11
    800050b2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800050b4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    800050b8:	439c                	lw	a5,0(a5)
    800050ba:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800050be:	8ba1                	andi	a5,a5,8
    800050c0:	0e078a63          	beqz	a5,800051b4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800050c4:	100017b7          	lui	a5,0x10001
    800050c8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800050cc:	43fc                	lw	a5,68(a5)
    800050ce:	2781                	sext.w	a5,a5
    800050d0:	0e079863          	bnez	a5,800051c0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800050d4:	100017b7          	lui	a5,0x10001
    800050d8:	5bdc                	lw	a5,52(a5)
    800050da:	2781                	sext.w	a5,a5
  if(max == 0)
    800050dc:	0e078863          	beqz	a5,800051cc <virtio_disk_init+0x1a4>
  if(max < NUM)
    800050e0:	471d                	li	a4,7
    800050e2:	0ef77b63          	bgeu	a4,a5,800051d8 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    800050e6:	fedfa0ef          	jal	800000d2 <kalloc>
    800050ea:	00017497          	auipc	s1,0x17
    800050ee:	e3648493          	addi	s1,s1,-458 # 8001bf20 <disk>
    800050f2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800050f4:	fdffa0ef          	jal	800000d2 <kalloc>
    800050f8:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800050fa:	fd9fa0ef          	jal	800000d2 <kalloc>
    800050fe:	87aa                	mv	a5,a0
    80005100:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80005102:	6088                	ld	a0,0(s1)
    80005104:	0e050063          	beqz	a0,800051e4 <virtio_disk_init+0x1bc>
    80005108:	00017717          	auipc	a4,0x17
    8000510c:	e2073703          	ld	a4,-480(a4) # 8001bf28 <disk+0x8>
    80005110:	cb71                	beqz	a4,800051e4 <virtio_disk_init+0x1bc>
    80005112:	cbe9                	beqz	a5,800051e4 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80005114:	6605                	lui	a2,0x1
    80005116:	4581                	li	a1,0
    80005118:	984fb0ef          	jal	8000029c <memset>
  memset(disk.avail, 0, PGSIZE);
    8000511c:	00017497          	auipc	s1,0x17
    80005120:	e0448493          	addi	s1,s1,-508 # 8001bf20 <disk>
    80005124:	6605                	lui	a2,0x1
    80005126:	4581                	li	a1,0
    80005128:	6488                	ld	a0,8(s1)
    8000512a:	972fb0ef          	jal	8000029c <memset>
  memset(disk.used, 0, PGSIZE);
    8000512e:	6605                	lui	a2,0x1
    80005130:	4581                	li	a1,0
    80005132:	6888                	ld	a0,16(s1)
    80005134:	968fb0ef          	jal	8000029c <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80005138:	100017b7          	lui	a5,0x10001
    8000513c:	4721                	li	a4,8
    8000513e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005140:	4098                	lw	a4,0(s1)
    80005142:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005146:	40d8                	lw	a4,4(s1)
    80005148:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000514c:	649c                	ld	a5,8(s1)
    8000514e:	0007869b          	sext.w	a3,a5
    80005152:	10001737          	lui	a4,0x10001
    80005156:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    8000515a:	9781                	srai	a5,a5,0x20
    8000515c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80005160:	689c                	ld	a5,16(s1)
    80005162:	0007869b          	sext.w	a3,a5
    80005166:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    8000516a:	9781                	srai	a5,a5,0x20
    8000516c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80005170:	4785                	li	a5,1
    80005172:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80005174:	00f48c23          	sb	a5,24(s1)
    80005178:	00f48ca3          	sb	a5,25(s1)
    8000517c:	00f48d23          	sb	a5,26(s1)
    80005180:	00f48da3          	sb	a5,27(s1)
    80005184:	00f48e23          	sb	a5,28(s1)
    80005188:	00f48ea3          	sb	a5,29(s1)
    8000518c:	00f48f23          	sb	a5,30(s1)
    80005190:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005194:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005198:	07272823          	sw	s2,112(a4)
}
    8000519c:	60e2                	ld	ra,24(sp)
    8000519e:	6442                	ld	s0,16(sp)
    800051a0:	64a2                	ld	s1,8(sp)
    800051a2:	6902                	ld	s2,0(sp)
    800051a4:	6105                	addi	sp,sp,32
    800051a6:	8082                	ret
    panic("could not find virtio disk");
    800051a8:	00003517          	auipc	a0,0x3
    800051ac:	58050513          	addi	a0,a0,1408 # 80008728 <etext+0x728>
    800051b0:	307000ef          	jal	80005cb6 <panic>
    panic("virtio disk FEATURES_OK unset");
    800051b4:	00003517          	auipc	a0,0x3
    800051b8:	59450513          	addi	a0,a0,1428 # 80008748 <etext+0x748>
    800051bc:	2fb000ef          	jal	80005cb6 <panic>
    panic("virtio disk should not be ready");
    800051c0:	00003517          	auipc	a0,0x3
    800051c4:	5a850513          	addi	a0,a0,1448 # 80008768 <etext+0x768>
    800051c8:	2ef000ef          	jal	80005cb6 <panic>
    panic("virtio disk has no queue 0");
    800051cc:	00003517          	auipc	a0,0x3
    800051d0:	5bc50513          	addi	a0,a0,1468 # 80008788 <etext+0x788>
    800051d4:	2e3000ef          	jal	80005cb6 <panic>
    panic("virtio disk max queue too short");
    800051d8:	00003517          	auipc	a0,0x3
    800051dc:	5d050513          	addi	a0,a0,1488 # 800087a8 <etext+0x7a8>
    800051e0:	2d7000ef          	jal	80005cb6 <panic>
    panic("virtio disk kalloc");
    800051e4:	00003517          	auipc	a0,0x3
    800051e8:	5e450513          	addi	a0,a0,1508 # 800087c8 <etext+0x7c8>
    800051ec:	2cb000ef          	jal	80005cb6 <panic>

00000000800051f0 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800051f0:	711d                	addi	sp,sp,-96
    800051f2:	ec86                	sd	ra,88(sp)
    800051f4:	e8a2                	sd	s0,80(sp)
    800051f6:	e4a6                	sd	s1,72(sp)
    800051f8:	e0ca                	sd	s2,64(sp)
    800051fa:	fc4e                	sd	s3,56(sp)
    800051fc:	f852                	sd	s4,48(sp)
    800051fe:	f456                	sd	s5,40(sp)
    80005200:	f05a                	sd	s6,32(sp)
    80005202:	ec5e                	sd	s7,24(sp)
    80005204:	e862                	sd	s8,16(sp)
    80005206:	1080                	addi	s0,sp,96
    80005208:	89aa                	mv	s3,a0
    8000520a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    8000520c:	00c52b83          	lw	s7,12(a0)
    80005210:	001b9b9b          	slliw	s7,s7,0x1
    80005214:	1b82                	slli	s7,s7,0x20
    80005216:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    8000521a:	00017517          	auipc	a0,0x17
    8000521e:	e2e50513          	addi	a0,a0,-466 # 8001c048 <disk+0x128>
    80005222:	557000ef          	jal	80005f78 <acquire>
  for(int i = 0; i < NUM; i++){
    80005226:	44a1                	li	s1,8
      disk.free[i] = 0;
    80005228:	00017a97          	auipc	s5,0x17
    8000522c:	cf8a8a93          	addi	s5,s5,-776 # 8001bf20 <disk>
  for(int i = 0; i < 3; i++){
    80005230:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80005232:	5c7d                	li	s8,-1
    80005234:	a095                	j	80005298 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80005236:	00fa8733          	add	a4,s5,a5
    8000523a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    8000523e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80005240:	0207c563          	bltz	a5,8000526a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80005244:	2905                	addiw	s2,s2,1
    80005246:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80005248:	05490c63          	beq	s2,s4,800052a0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    8000524c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    8000524e:	00017717          	auipc	a4,0x17
    80005252:	cd270713          	addi	a4,a4,-814 # 8001bf20 <disk>
    80005256:	4781                	li	a5,0
    if(disk.free[i]){
    80005258:	01874683          	lbu	a3,24(a4)
    8000525c:	fee9                	bnez	a3,80005236 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    8000525e:	2785                	addiw	a5,a5,1
    80005260:	0705                	addi	a4,a4,1
    80005262:	fe979be3          	bne	a5,s1,80005258 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80005266:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    8000526a:	01205d63          	blez	s2,80005284 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000526e:	fa042503          	lw	a0,-96(s0)
    80005272:	d41ff0ef          	jal	80004fb2 <free_desc>
      for(int j = 0; j < i; j++)
    80005276:	4785                	li	a5,1
    80005278:	0127d663          	bge	a5,s2,80005284 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    8000527c:	fa442503          	lw	a0,-92(s0)
    80005280:	d33ff0ef          	jal	80004fb2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005284:	00017597          	auipc	a1,0x17
    80005288:	dc458593          	addi	a1,a1,-572 # 8001c048 <disk+0x128>
    8000528c:	00017517          	auipc	a0,0x17
    80005290:	cac50513          	addi	a0,a0,-852 # 8001bf38 <disk+0x18>
    80005294:	f20fc0ef          	jal	800019b4 <sleep>
  for(int i = 0; i < 3; i++){
    80005298:	fa040613          	addi	a2,s0,-96
    8000529c:	4901                	li	s2,0
    8000529e:	b77d                	j	8000524c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800052a0:	fa042503          	lw	a0,-96(s0)
    800052a4:	00451693          	slli	a3,a0,0x4

  if(write)
    800052a8:	00017797          	auipc	a5,0x17
    800052ac:	c7878793          	addi	a5,a5,-904 # 8001bf20 <disk>
    800052b0:	00451713          	slli	a4,a0,0x4
    800052b4:	0a070713          	addi	a4,a4,160
    800052b8:	973e                	add	a4,a4,a5
    800052ba:	01603633          	snez	a2,s6
    800052be:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800052c0:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    800052c4:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800052c8:	6398                	ld	a4,0(a5)
    800052ca:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800052cc:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    800052d0:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    800052d2:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800052d4:	6390                	ld	a2,0(a5)
    800052d6:	00d60833          	add	a6,a2,a3
    800052da:	4741                	li	a4,16
    800052dc:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800052e0:	4585                	li	a1,1
    800052e2:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    800052e6:	fa442703          	lw	a4,-92(s0)
    800052ea:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800052ee:	0712                	slli	a4,a4,0x4
    800052f0:	963a                	add	a2,a2,a4
    800052f2:	05898813          	addi	a6,s3,88
    800052f6:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    800052fa:	0007b883          	ld	a7,0(a5)
    800052fe:	9746                	add	a4,a4,a7
    80005300:	40000613          	li	a2,1024
    80005304:	c710                	sw	a2,8(a4)
  if(write)
    80005306:	001b3613          	seqz	a2,s6
    8000530a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000530e:	8e4d                	or	a2,a2,a1
    80005310:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80005314:	fa842603          	lw	a2,-88(s0)
    80005318:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    8000531c:	00451813          	slli	a6,a0,0x4
    80005320:	02080813          	addi	a6,a6,32
    80005324:	983e                	add	a6,a6,a5
    80005326:	577d                	li	a4,-1
    80005328:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    8000532c:	0612                	slli	a2,a2,0x4
    8000532e:	98b2                	add	a7,a7,a2
    80005330:	03068713          	addi	a4,a3,48
    80005334:	973e                	add	a4,a4,a5
    80005336:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    8000533a:	6398                	ld	a4,0(a5)
    8000533c:	9732                	add	a4,a4,a2
    8000533e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80005340:	4689                	li	a3,2
    80005342:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80005346:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    8000534a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    8000534e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80005352:	6794                	ld	a3,8(a5)
    80005354:	0026d703          	lhu	a4,2(a3)
    80005358:	8b1d                	andi	a4,a4,7
    8000535a:	0706                	slli	a4,a4,0x1
    8000535c:	96ba                	add	a3,a3,a4
    8000535e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80005362:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005366:	6798                	ld	a4,8(a5)
    80005368:	00275783          	lhu	a5,2(a4)
    8000536c:	2785                	addiw	a5,a5,1
    8000536e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005372:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005376:	100017b7          	lui	a5,0x10001
    8000537a:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    8000537e:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80005382:	00017917          	auipc	s2,0x17
    80005386:	cc690913          	addi	s2,s2,-826 # 8001c048 <disk+0x128>
  while(b->disk == 1) {
    8000538a:	84ae                	mv	s1,a1
    8000538c:	00b79a63          	bne	a5,a1,800053a0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80005390:	85ca                	mv	a1,s2
    80005392:	854e                	mv	a0,s3
    80005394:	e20fc0ef          	jal	800019b4 <sleep>
  while(b->disk == 1) {
    80005398:	0049a783          	lw	a5,4(s3)
    8000539c:	fe978ae3          	beq	a5,s1,80005390 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    800053a0:	fa042903          	lw	s2,-96(s0)
    800053a4:	00491713          	slli	a4,s2,0x4
    800053a8:	02070713          	addi	a4,a4,32
    800053ac:	00017797          	auipc	a5,0x17
    800053b0:	b7478793          	addi	a5,a5,-1164 # 8001bf20 <disk>
    800053b4:	97ba                	add	a5,a5,a4
    800053b6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800053ba:	00017997          	auipc	s3,0x17
    800053be:	b6698993          	addi	s3,s3,-1178 # 8001bf20 <disk>
    800053c2:	00491713          	slli	a4,s2,0x4
    800053c6:	0009b783          	ld	a5,0(s3)
    800053ca:	97ba                	add	a5,a5,a4
    800053cc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800053d0:	854a                	mv	a0,s2
    800053d2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800053d6:	bddff0ef          	jal	80004fb2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800053da:	8885                	andi	s1,s1,1
    800053dc:	f0fd                	bnez	s1,800053c2 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800053de:	00017517          	auipc	a0,0x17
    800053e2:	c6a50513          	addi	a0,a0,-918 # 8001c048 <disk+0x128>
    800053e6:	427000ef          	jal	8000600c <release>
}
    800053ea:	60e6                	ld	ra,88(sp)
    800053ec:	6446                	ld	s0,80(sp)
    800053ee:	64a6                	ld	s1,72(sp)
    800053f0:	6906                	ld	s2,64(sp)
    800053f2:	79e2                	ld	s3,56(sp)
    800053f4:	7a42                	ld	s4,48(sp)
    800053f6:	7aa2                	ld	s5,40(sp)
    800053f8:	7b02                	ld	s6,32(sp)
    800053fa:	6be2                	ld	s7,24(sp)
    800053fc:	6c42                	ld	s8,16(sp)
    800053fe:	6125                	addi	sp,sp,96
    80005400:	8082                	ret

0000000080005402 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005402:	1101                	addi	sp,sp,-32
    80005404:	ec06                	sd	ra,24(sp)
    80005406:	e822                	sd	s0,16(sp)
    80005408:	e426                	sd	s1,8(sp)
    8000540a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000540c:	00017497          	auipc	s1,0x17
    80005410:	b1448493          	addi	s1,s1,-1260 # 8001bf20 <disk>
    80005414:	00017517          	auipc	a0,0x17
    80005418:	c3450513          	addi	a0,a0,-972 # 8001c048 <disk+0x128>
    8000541c:	35d000ef          	jal	80005f78 <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005420:	100017b7          	lui	a5,0x10001
    80005424:	53bc                	lw	a5,96(a5)
    80005426:	8b8d                	andi	a5,a5,3
    80005428:	10001737          	lui	a4,0x10001
    8000542c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000542e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005432:	689c                	ld	a5,16(s1)
    80005434:	0204d703          	lhu	a4,32(s1)
    80005438:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000543c:	04f70863          	beq	a4,a5,8000548c <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005440:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005444:	6898                	ld	a4,16(s1)
    80005446:	0204d783          	lhu	a5,32(s1)
    8000544a:	8b9d                	andi	a5,a5,7
    8000544c:	078e                	slli	a5,a5,0x3
    8000544e:	97ba                	add	a5,a5,a4
    80005450:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005452:	00479713          	slli	a4,a5,0x4
    80005456:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000545a:	9726                	add	a4,a4,s1
    8000545c:	01074703          	lbu	a4,16(a4)
    80005460:	e329                	bnez	a4,800054a2 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005462:	0792                	slli	a5,a5,0x4
    80005464:	02078793          	addi	a5,a5,32
    80005468:	97a6                	add	a5,a5,s1
    8000546a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000546c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005470:	d90fc0ef          	jal	80001a00 <wakeup>

    disk.used_idx += 1;
    80005474:	0204d783          	lhu	a5,32(s1)
    80005478:	2785                	addiw	a5,a5,1
    8000547a:	17c2                	slli	a5,a5,0x30
    8000547c:	93c1                	srli	a5,a5,0x30
    8000547e:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005482:	6898                	ld	a4,16(s1)
    80005484:	00275703          	lhu	a4,2(a4)
    80005488:	faf71ce3          	bne	a4,a5,80005440 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    8000548c:	00017517          	auipc	a0,0x17
    80005490:	bbc50513          	addi	a0,a0,-1092 # 8001c048 <disk+0x128>
    80005494:	379000ef          	jal	8000600c <release>
}
    80005498:	60e2                	ld	ra,24(sp)
    8000549a:	6442                	ld	s0,16(sp)
    8000549c:	64a2                	ld	s1,8(sp)
    8000549e:	6105                	addi	sp,sp,32
    800054a0:	8082                	ret
      panic("virtio_disk_intr status");
    800054a2:	00003517          	auipc	a0,0x3
    800054a6:	33e50513          	addi	a0,a0,830 # 800087e0 <etext+0x7e0>
    800054aa:	00d000ef          	jal	80005cb6 <panic>

00000000800054ae <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800054ae:	1141                	addi	sp,sp,-16
    800054b0:	e406                	sd	ra,8(sp)
    800054b2:	e022                	sd	s0,0(sp)
    800054b4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800054b6:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800054ba:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800054be:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800054c2:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800054c6:	577d                	li	a4,-1
    800054c8:	177e                	slli	a4,a4,0x3f
    800054ca:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800054cc:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    800054d0:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    800054d4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    800054d8:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    800054dc:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    800054e0:	000f4737          	lui	a4,0xf4
    800054e4:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    800054e8:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    800054ea:	14d79073          	csrw	stimecmp,a5
}
    800054ee:	60a2                	ld	ra,8(sp)
    800054f0:	6402                	ld	s0,0(sp)
    800054f2:	0141                	addi	sp,sp,16
    800054f4:	8082                	ret

00000000800054f6 <start>:
{
    800054f6:	1141                	addi	sp,sp,-16
    800054f8:	e406                	sd	ra,8(sp)
    800054fa:	e022                	sd	s0,0(sp)
    800054fc:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800054fe:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005502:	7779                	lui	a4,0xffffe
    80005504:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffda6c7>
    80005508:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000550a:	6705                	lui	a4,0x1
    8000550c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005510:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005512:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005516:	ffffb797          	auipc	a5,0xffffb
    8000551a:	f3c78793          	addi	a5,a5,-196 # 80000452 <main>
    8000551e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005522:	4781                	li	a5,0
    80005524:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005528:	67c1                	lui	a5,0x10
    8000552a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000552c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005530:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005534:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80005538:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    8000553c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005540:	57fd                	li	a5,-1
    80005542:	83a9                	srli	a5,a5,0xa
    80005544:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005548:	47bd                	li	a5,15
    8000554a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000554e:	f61ff0ef          	jal	800054ae <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005552:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005556:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005558:	823e                	mv	tp,a5
  asm volatile("mret");
    8000555a:	30200073          	mret
}
    8000555e:	60a2                	ld	ra,8(sp)
    80005560:	6402                	ld	s0,0(sp)
    80005562:	0141                	addi	sp,sp,16
    80005564:	8082                	ret

0000000080005566 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005566:	7119                	addi	sp,sp,-128
    80005568:	fc86                	sd	ra,120(sp)
    8000556a:	f8a2                	sd	s0,112(sp)
    8000556c:	f4a6                	sd	s1,104(sp)
    8000556e:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    80005570:	06c05b63          	blez	a2,800055e6 <consolewrite+0x80>
    80005574:	f0ca                	sd	s2,96(sp)
    80005576:	ecce                	sd	s3,88(sp)
    80005578:	e8d2                	sd	s4,80(sp)
    8000557a:	e4d6                	sd	s5,72(sp)
    8000557c:	e0da                	sd	s6,64(sp)
    8000557e:	fc5e                	sd	s7,56(sp)
    80005580:	f862                	sd	s8,48(sp)
    80005582:	f466                	sd	s9,40(sp)
    80005584:	f06a                	sd	s10,32(sp)
    80005586:	8b2a                	mv	s6,a0
    80005588:	8bae                	mv	s7,a1
    8000558a:	8a32                	mv	s4,a2
  int i = 0;
    8000558c:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    8000558e:	02000c93          	li	s9,32
    80005592:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    80005596:	f8040a93          	addi	s5,s0,-128
    8000559a:	5c7d                	li	s8,-1
    8000559c:	a025                	j	800055c4 <consolewrite+0x5e>
    if(nn > n - i)
    8000559e:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800055a2:	86ce                	mv	a3,s3
    800055a4:	01748633          	add	a2,s1,s7
    800055a8:	85da                	mv	a1,s6
    800055aa:	8556                	mv	a0,s5
    800055ac:	facfc0ef          	jal	80001d58 <either_copyin>
    800055b0:	03850d63          	beq	a0,s8,800055ea <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    800055b4:	85ce                	mv	a1,s3
    800055b6:	8556                	mv	a0,s5
    800055b8:	7b4000ef          	jal	80005d6c <uartwrite>
    i += nn;
    800055bc:	009904bb          	addw	s1,s2,s1
  while(i < n){
    800055c0:	0144d963          	bge	s1,s4,800055d2 <consolewrite+0x6c>
    if(nn > n - i)
    800055c4:	409a07bb          	subw	a5,s4,s1
    800055c8:	893e                	mv	s2,a5
    800055ca:	fcfcdae3          	bge	s9,a5,8000559e <consolewrite+0x38>
    800055ce:	896a                	mv	s2,s10
    800055d0:	b7f9                	j	8000559e <consolewrite+0x38>
    800055d2:	7906                	ld	s2,96(sp)
    800055d4:	69e6                	ld	s3,88(sp)
    800055d6:	6a46                	ld	s4,80(sp)
    800055d8:	6aa6                	ld	s5,72(sp)
    800055da:	6b06                	ld	s6,64(sp)
    800055dc:	7be2                	ld	s7,56(sp)
    800055de:	7c42                	ld	s8,48(sp)
    800055e0:	7ca2                	ld	s9,40(sp)
    800055e2:	7d02                	ld	s10,32(sp)
    800055e4:	a821                	j	800055fc <consolewrite+0x96>
  int i = 0;
    800055e6:	4481                	li	s1,0
    800055e8:	a811                	j	800055fc <consolewrite+0x96>
    800055ea:	7906                	ld	s2,96(sp)
    800055ec:	69e6                	ld	s3,88(sp)
    800055ee:	6a46                	ld	s4,80(sp)
    800055f0:	6aa6                	ld	s5,72(sp)
    800055f2:	6b06                	ld	s6,64(sp)
    800055f4:	7be2                	ld	s7,56(sp)
    800055f6:	7c42                	ld	s8,48(sp)
    800055f8:	7ca2                	ld	s9,40(sp)
    800055fa:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    800055fc:	8526                	mv	a0,s1
    800055fe:	70e6                	ld	ra,120(sp)
    80005600:	7446                	ld	s0,112(sp)
    80005602:	74a6                	ld	s1,104(sp)
    80005604:	6109                	addi	sp,sp,128
    80005606:	8082                	ret

0000000080005608 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005608:	711d                	addi	sp,sp,-96
    8000560a:	ec86                	sd	ra,88(sp)
    8000560c:	e8a2                	sd	s0,80(sp)
    8000560e:	e4a6                	sd	s1,72(sp)
    80005610:	e0ca                	sd	s2,64(sp)
    80005612:	fc4e                	sd	s3,56(sp)
    80005614:	f852                	sd	s4,48(sp)
    80005616:	f05a                	sd	s6,32(sp)
    80005618:	ec5e                	sd	s7,24(sp)
    8000561a:	1080                	addi	s0,sp,96
    8000561c:	8b2a                	mv	s6,a0
    8000561e:	8a2e                	mv	s4,a1
    80005620:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005622:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80005624:	0001f517          	auipc	a0,0x1f
    80005628:	a3c50513          	addi	a0,a0,-1476 # 80024060 <cons>
    8000562c:	14d000ef          	jal	80005f78 <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005630:	0001f497          	auipc	s1,0x1f
    80005634:	a3048493          	addi	s1,s1,-1488 # 80024060 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005638:	0001f917          	auipc	s2,0x1f
    8000563c:	ac090913          	addi	s2,s2,-1344 # 800240f8 <cons+0x98>
  while(n > 0){
    80005640:	0b305b63          	blez	s3,800056f6 <consoleread+0xee>
    while(cons.r == cons.w){
    80005644:	0984a783          	lw	a5,152(s1)
    80005648:	09c4a703          	lw	a4,156(s1)
    8000564c:	0af71063          	bne	a4,a5,800056ec <consoleread+0xe4>
      if(killed(myproc())){
    80005650:	cf1fb0ef          	jal	80001340 <myproc>
    80005654:	d9cfc0ef          	jal	80001bf0 <killed>
    80005658:	e12d                	bnez	a0,800056ba <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000565a:	85a6                	mv	a1,s1
    8000565c:	854a                	mv	a0,s2
    8000565e:	b56fc0ef          	jal	800019b4 <sleep>
    while(cons.r == cons.w){
    80005662:	0984a783          	lw	a5,152(s1)
    80005666:	09c4a703          	lw	a4,156(s1)
    8000566a:	fef703e3          	beq	a4,a5,80005650 <consoleread+0x48>
    8000566e:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005670:	0001f717          	auipc	a4,0x1f
    80005674:	9f070713          	addi	a4,a4,-1552 # 80024060 <cons>
    80005678:	0017869b          	addiw	a3,a5,1
    8000567c:	08d72c23          	sw	a3,152(a4)
    80005680:	07f7f693          	andi	a3,a5,127
    80005684:	9736                	add	a4,a4,a3
    80005686:	01874703          	lbu	a4,24(a4)
    8000568a:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    8000568e:	4691                	li	a3,4
    80005690:	04da8663          	beq	s5,a3,800056dc <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    80005694:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005698:	4685                	li	a3,1
    8000569a:	faf40613          	addi	a2,s0,-81
    8000569e:	85d2                	mv	a1,s4
    800056a0:	855a                	mv	a0,s6
    800056a2:	e6cfc0ef          	jal	80001d0e <either_copyout>
    800056a6:	57fd                	li	a5,-1
    800056a8:	04f50663          	beq	a0,a5,800056f4 <consoleread+0xec>
      break;

    dst++;
    800056ac:	0a05                	addi	s4,s4,1
    --n;
    800056ae:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800056b0:	47a9                	li	a5,10
    800056b2:	04fa8b63          	beq	s5,a5,80005708 <consoleread+0x100>
    800056b6:	7aa2                	ld	s5,40(sp)
    800056b8:	b761                	j	80005640 <consoleread+0x38>
        release(&cons.lock);
    800056ba:	0001f517          	auipc	a0,0x1f
    800056be:	9a650513          	addi	a0,a0,-1626 # 80024060 <cons>
    800056c2:	14b000ef          	jal	8000600c <release>
        return -1;
    800056c6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800056c8:	60e6                	ld	ra,88(sp)
    800056ca:	6446                	ld	s0,80(sp)
    800056cc:	64a6                	ld	s1,72(sp)
    800056ce:	6906                	ld	s2,64(sp)
    800056d0:	79e2                	ld	s3,56(sp)
    800056d2:	7a42                	ld	s4,48(sp)
    800056d4:	7b02                	ld	s6,32(sp)
    800056d6:	6be2                	ld	s7,24(sp)
    800056d8:	6125                	addi	sp,sp,96
    800056da:	8082                	ret
      if(n < target){
    800056dc:	0179fa63          	bgeu	s3,s7,800056f0 <consoleread+0xe8>
        cons.r--;
    800056e0:	0001f717          	auipc	a4,0x1f
    800056e4:	a0f72c23          	sw	a5,-1512(a4) # 800240f8 <cons+0x98>
    800056e8:	7aa2                	ld	s5,40(sp)
    800056ea:	a031                	j	800056f6 <consoleread+0xee>
    800056ec:	f456                	sd	s5,40(sp)
    800056ee:	b749                	j	80005670 <consoleread+0x68>
    800056f0:	7aa2                	ld	s5,40(sp)
    800056f2:	a011                	j	800056f6 <consoleread+0xee>
    800056f4:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    800056f6:	0001f517          	auipc	a0,0x1f
    800056fa:	96a50513          	addi	a0,a0,-1686 # 80024060 <cons>
    800056fe:	10f000ef          	jal	8000600c <release>
  return target - n;
    80005702:	413b853b          	subw	a0,s7,s3
    80005706:	b7c9                	j	800056c8 <consoleread+0xc0>
    80005708:	7aa2                	ld	s5,40(sp)
    8000570a:	b7f5                	j	800056f6 <consoleread+0xee>

000000008000570c <consputc>:
{
    8000570c:	1141                	addi	sp,sp,-16
    8000570e:	e406                	sd	ra,8(sp)
    80005710:	e022                	sd	s0,0(sp)
    80005712:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005714:	10000793          	li	a5,256
    80005718:	00f50863          	beq	a0,a5,80005728 <consputc+0x1c>
    uartputc_sync(c);
    8000571c:	6e4000ef          	jal	80005e00 <uartputc_sync>
}
    80005720:	60a2                	ld	ra,8(sp)
    80005722:	6402                	ld	s0,0(sp)
    80005724:	0141                	addi	sp,sp,16
    80005726:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005728:	4521                	li	a0,8
    8000572a:	6d6000ef          	jal	80005e00 <uartputc_sync>
    8000572e:	02000513          	li	a0,32
    80005732:	6ce000ef          	jal	80005e00 <uartputc_sync>
    80005736:	4521                	li	a0,8
    80005738:	6c8000ef          	jal	80005e00 <uartputc_sync>
    8000573c:	b7d5                	j	80005720 <consputc+0x14>

000000008000573e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000573e:	1101                	addi	sp,sp,-32
    80005740:	ec06                	sd	ra,24(sp)
    80005742:	e822                	sd	s0,16(sp)
    80005744:	e426                	sd	s1,8(sp)
    80005746:	1000                	addi	s0,sp,32
    80005748:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000574a:	0001f517          	auipc	a0,0x1f
    8000574e:	91650513          	addi	a0,a0,-1770 # 80024060 <cons>
    80005752:	027000ef          	jal	80005f78 <acquire>

  switch(c){
    80005756:	47d5                	li	a5,21
    80005758:	08f48d63          	beq	s1,a5,800057f2 <consoleintr+0xb4>
    8000575c:	0297c563          	blt	a5,s1,80005786 <consoleintr+0x48>
    80005760:	47a1                	li	a5,8
    80005762:	0ef48263          	beq	s1,a5,80005846 <consoleintr+0x108>
    80005766:	47c1                	li	a5,16
    80005768:	10f49363          	bne	s1,a5,8000586e <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    8000576c:	e36fc0ef          	jal	80001da2 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005770:	0001f517          	auipc	a0,0x1f
    80005774:	8f050513          	addi	a0,a0,-1808 # 80024060 <cons>
    80005778:	095000ef          	jal	8000600c <release>
}
    8000577c:	60e2                	ld	ra,24(sp)
    8000577e:	6442                	ld	s0,16(sp)
    80005780:	64a2                	ld	s1,8(sp)
    80005782:	6105                	addi	sp,sp,32
    80005784:	8082                	ret
  switch(c){
    80005786:	07f00793          	li	a5,127
    8000578a:	0af48e63          	beq	s1,a5,80005846 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000578e:	0001f717          	auipc	a4,0x1f
    80005792:	8d270713          	addi	a4,a4,-1838 # 80024060 <cons>
    80005796:	0a072783          	lw	a5,160(a4)
    8000579a:	09872703          	lw	a4,152(a4)
    8000579e:	9f99                	subw	a5,a5,a4
    800057a0:	07f00713          	li	a4,127
    800057a4:	fcf766e3          	bltu	a4,a5,80005770 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800057a8:	47b5                	li	a5,13
    800057aa:	0cf48563          	beq	s1,a5,80005874 <consoleintr+0x136>
      consputc(c);
    800057ae:	8526                	mv	a0,s1
    800057b0:	f5dff0ef          	jal	8000570c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800057b4:	0001f717          	auipc	a4,0x1f
    800057b8:	8ac70713          	addi	a4,a4,-1876 # 80024060 <cons>
    800057bc:	0a072683          	lw	a3,160(a4)
    800057c0:	0016879b          	addiw	a5,a3,1
    800057c4:	863e                	mv	a2,a5
    800057c6:	0af72023          	sw	a5,160(a4)
    800057ca:	07f6f693          	andi	a3,a3,127
    800057ce:	9736                	add	a4,a4,a3
    800057d0:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    800057d4:	ff648713          	addi	a4,s1,-10
    800057d8:	c371                	beqz	a4,8000589c <consoleintr+0x15e>
    800057da:	14f1                	addi	s1,s1,-4
    800057dc:	c0e1                	beqz	s1,8000589c <consoleintr+0x15e>
    800057de:	0001f717          	auipc	a4,0x1f
    800057e2:	91a72703          	lw	a4,-1766(a4) # 800240f8 <cons+0x98>
    800057e6:	9f99                	subw	a5,a5,a4
    800057e8:	08000713          	li	a4,128
    800057ec:	f8e792e3          	bne	a5,a4,80005770 <consoleintr+0x32>
    800057f0:	a075                	j	8000589c <consoleintr+0x15e>
    800057f2:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    800057f4:	0001f717          	auipc	a4,0x1f
    800057f8:	86c70713          	addi	a4,a4,-1940 # 80024060 <cons>
    800057fc:	0a072783          	lw	a5,160(a4)
    80005800:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005804:	0001f497          	auipc	s1,0x1f
    80005808:	85c48493          	addi	s1,s1,-1956 # 80024060 <cons>
    while(cons.e != cons.w &&
    8000580c:	4929                	li	s2,10
    8000580e:	02f70863          	beq	a4,a5,8000583e <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005812:	37fd                	addiw	a5,a5,-1
    80005814:	07f7f713          	andi	a4,a5,127
    80005818:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000581a:	01874703          	lbu	a4,24(a4)
    8000581e:	03270263          	beq	a4,s2,80005842 <consoleintr+0x104>
      cons.e--;
    80005822:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005826:	10000513          	li	a0,256
    8000582a:	ee3ff0ef          	jal	8000570c <consputc>
    while(cons.e != cons.w &&
    8000582e:	0a04a783          	lw	a5,160(s1)
    80005832:	09c4a703          	lw	a4,156(s1)
    80005836:	fcf71ee3          	bne	a4,a5,80005812 <consoleintr+0xd4>
    8000583a:	6902                	ld	s2,0(sp)
    8000583c:	bf15                	j	80005770 <consoleintr+0x32>
    8000583e:	6902                	ld	s2,0(sp)
    80005840:	bf05                	j	80005770 <consoleintr+0x32>
    80005842:	6902                	ld	s2,0(sp)
    80005844:	b735                	j	80005770 <consoleintr+0x32>
    if(cons.e != cons.w){
    80005846:	0001f717          	auipc	a4,0x1f
    8000584a:	81a70713          	addi	a4,a4,-2022 # 80024060 <cons>
    8000584e:	0a072783          	lw	a5,160(a4)
    80005852:	09c72703          	lw	a4,156(a4)
    80005856:	f0f70de3          	beq	a4,a5,80005770 <consoleintr+0x32>
      cons.e--;
    8000585a:	37fd                	addiw	a5,a5,-1
    8000585c:	0001f717          	auipc	a4,0x1f
    80005860:	8af72223          	sw	a5,-1884(a4) # 80024100 <cons+0xa0>
      consputc(BACKSPACE);
    80005864:	10000513          	li	a0,256
    80005868:	ea5ff0ef          	jal	8000570c <consputc>
    8000586c:	b711                	j	80005770 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000586e:	f00481e3          	beqz	s1,80005770 <consoleintr+0x32>
    80005872:	bf31                	j	8000578e <consoleintr+0x50>
      consputc(c);
    80005874:	4529                	li	a0,10
    80005876:	e97ff0ef          	jal	8000570c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    8000587a:	0001e797          	auipc	a5,0x1e
    8000587e:	7e678793          	addi	a5,a5,2022 # 80024060 <cons>
    80005882:	0a07a703          	lw	a4,160(a5)
    80005886:	0017069b          	addiw	a3,a4,1
    8000588a:	8636                	mv	a2,a3
    8000588c:	0ad7a023          	sw	a3,160(a5)
    80005890:	07f77713          	andi	a4,a4,127
    80005894:	97ba                	add	a5,a5,a4
    80005896:	4729                	li	a4,10
    80005898:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    8000589c:	0001f797          	auipc	a5,0x1f
    800058a0:	86c7a023          	sw	a2,-1952(a5) # 800240fc <cons+0x9c>
        wakeup(&cons.r);
    800058a4:	0001f517          	auipc	a0,0x1f
    800058a8:	85450513          	addi	a0,a0,-1964 # 800240f8 <cons+0x98>
    800058ac:	954fc0ef          	jal	80001a00 <wakeup>
    800058b0:	b5c1                	j	80005770 <consoleintr+0x32>

00000000800058b2 <consoleinit>:

void
consoleinit(void)
{
    800058b2:	1141                	addi	sp,sp,-16
    800058b4:	e406                	sd	ra,8(sp)
    800058b6:	e022                	sd	s0,0(sp)
    800058b8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800058ba:	00003597          	auipc	a1,0x3
    800058be:	f3e58593          	addi	a1,a1,-194 # 800087f8 <etext+0x7f8>
    800058c2:	0001e517          	auipc	a0,0x1e
    800058c6:	79e50513          	addi	a0,a0,1950 # 80024060 <cons>
    800058ca:	624000ef          	jal	80005eee <initlock>

  uartinit();
    800058ce:	448000ef          	jal	80005d16 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    800058d2:	00015797          	auipc	a5,0x15
    800058d6:	5f678793          	addi	a5,a5,1526 # 8001aec8 <devsw>
    800058da:	00000717          	auipc	a4,0x0
    800058de:	d2e70713          	addi	a4,a4,-722 # 80005608 <consoleread>
    800058e2:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    800058e4:	00000717          	auipc	a4,0x0
    800058e8:	c8270713          	addi	a4,a4,-894 # 80005566 <consolewrite>
    800058ec:	ef98                	sd	a4,24(a5)
}
    800058ee:	60a2                	ld	ra,8(sp)
    800058f0:	6402                	ld	s0,0(sp)
    800058f2:	0141                	addi	sp,sp,16
    800058f4:	8082                	ret

00000000800058f6 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    800058f6:	7139                	addi	sp,sp,-64
    800058f8:	fc06                	sd	ra,56(sp)
    800058fa:	f822                	sd	s0,48(sp)
    800058fc:	f04a                	sd	s2,32(sp)
    800058fe:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005900:	c219                	beqz	a2,80005906 <printint+0x10>
    80005902:	08054163          	bltz	a0,80005984 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005906:	4301                	li	t1,0

  i = 0;
    80005908:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000590c:	86ca                	mv	a3,s2
  i = 0;
    8000590e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005910:	00003817          	auipc	a6,0x3
    80005914:	0a880813          	addi	a6,a6,168 # 800089b8 <digits>
    80005918:	88ba                	mv	a7,a4
    8000591a:	0017061b          	addiw	a2,a4,1
    8000591e:	8732                	mv	a4,a2
    80005920:	02b577b3          	remu	a5,a0,a1
    80005924:	97c2                	add	a5,a5,a6
    80005926:	0007c783          	lbu	a5,0(a5)
    8000592a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000592e:	87aa                	mv	a5,a0
    80005930:	02b55533          	divu	a0,a0,a1
    80005934:	0685                	addi	a3,a3,1
    80005936:	feb7f1e3          	bgeu	a5,a1,80005918 <printint+0x22>

  if(sign)
    8000593a:	00030c63          	beqz	t1,80005952 <printint+0x5c>
    buf[i++] = '-';
    8000593e:	fe060793          	addi	a5,a2,-32
    80005942:	00878633          	add	a2,a5,s0
    80005946:	02d00793          	li	a5,45
    8000594a:	fef60423          	sb	a5,-24(a2)
    8000594e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80005952:	02e05463          	blez	a4,8000597a <printint+0x84>
    80005956:	f426                	sd	s1,40(sp)
    80005958:	377d                	addiw	a4,a4,-1
    8000595a:	00e904b3          	add	s1,s2,a4
    8000595e:	197d                	addi	s2,s2,-1
    80005960:	993a                	add	s2,s2,a4
    80005962:	1702                	slli	a4,a4,0x20
    80005964:	9301                	srli	a4,a4,0x20
    80005966:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000596a:	0004c503          	lbu	a0,0(s1)
    8000596e:	d9fff0ef          	jal	8000570c <consputc>
  while(--i >= 0)
    80005972:	14fd                	addi	s1,s1,-1
    80005974:	ff249be3          	bne	s1,s2,8000596a <printint+0x74>
    80005978:	74a2                	ld	s1,40(sp)
}
    8000597a:	70e2                	ld	ra,56(sp)
    8000597c:	7442                	ld	s0,48(sp)
    8000597e:	7902                	ld	s2,32(sp)
    80005980:	6121                	addi	sp,sp,64
    80005982:	8082                	ret
    x = -xx;
    80005984:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    80005988:	4305                	li	t1,1
    x = -xx;
    8000598a:	bfbd                	j	80005908 <printint+0x12>

000000008000598c <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    8000598c:	7131                	addi	sp,sp,-192
    8000598e:	fc86                	sd	ra,120(sp)
    80005990:	f8a2                	sd	s0,112(sp)
    80005992:	f0ca                	sd	s2,96(sp)
    80005994:	0100                	addi	s0,sp,128
    80005996:	892a                	mv	s2,a0
    80005998:	e40c                	sd	a1,8(s0)
    8000599a:	e810                	sd	a2,16(s0)
    8000599c:	ec14                	sd	a3,24(s0)
    8000599e:	f018                	sd	a4,32(s0)
    800059a0:	f41c                	sd	a5,40(s0)
    800059a2:	03043823          	sd	a6,48(s0)
    800059a6:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    800059aa:	00003797          	auipc	a5,0x3
    800059ae:	0567a783          	lw	a5,86(a5) # 80008a00 <panicking>
    800059b2:	cf9d                	beqz	a5,800059f0 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800059b4:	00840793          	addi	a5,s0,8
    800059b8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800059bc:	00094503          	lbu	a0,0(s2)
    800059c0:	22050663          	beqz	a0,80005bec <printf+0x260>
    800059c4:	f4a6                	sd	s1,104(sp)
    800059c6:	ecce                	sd	s3,88(sp)
    800059c8:	e8d2                	sd	s4,80(sp)
    800059ca:	e4d6                	sd	s5,72(sp)
    800059cc:	e0da                	sd	s6,64(sp)
    800059ce:	fc5e                	sd	s7,56(sp)
    800059d0:	f862                	sd	s8,48(sp)
    800059d2:	f06a                	sd	s10,32(sp)
    800059d4:	ec6e                	sd	s11,24(sp)
    800059d6:	4a01                	li	s4,0
    if(cx != '%'){
    800059d8:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    800059dc:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    800059e0:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    800059e4:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    800059e8:	4b29                	li	s6,10
    if(c0 == 'd'){
    800059ea:	06400b93          	li	s7,100
    800059ee:	a015                	j	80005a12 <printf+0x86>
    acquire(&pr.lock);
    800059f0:	0001e517          	auipc	a0,0x1e
    800059f4:	71850513          	addi	a0,a0,1816 # 80024108 <pr>
    800059f8:	580000ef          	jal	80005f78 <acquire>
    800059fc:	bf65                	j	800059b4 <printf+0x28>
      consputc(cx);
    800059fe:	d0fff0ef          	jal	8000570c <consputc>
      continue;
    80005a02:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005a04:	2485                	addiw	s1,s1,1
    80005a06:	8a26                	mv	s4,s1
    80005a08:	94ca                	add	s1,s1,s2
    80005a0a:	0004c503          	lbu	a0,0(s1)
    80005a0e:	1c050663          	beqz	a0,80005bda <printf+0x24e>
    if(cx != '%'){
    80005a12:	ff3516e3          	bne	a0,s3,800059fe <printf+0x72>
    i++;
    80005a16:	001a079b          	addiw	a5,s4,1
    80005a1a:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    80005a1c:	00f90733          	add	a4,s2,a5
    80005a20:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005a24:	200a8963          	beqz	s5,80005c36 <printf+0x2aa>
    80005a28:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    80005a2c:	1e068c63          	beqz	a3,80005c24 <printf+0x298>
    if(c0 == 'd'){
    80005a30:	037a8863          	beq	s5,s7,80005a60 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005a34:	f94a8713          	addi	a4,s5,-108
    80005a38:	00173713          	seqz	a4,a4
    80005a3c:	f9c68613          	addi	a2,a3,-100
    80005a40:	ee05                	bnez	a2,80005a78 <printf+0xec>
    80005a42:	cb1d                	beqz	a4,80005a78 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    80005a44:	f8843783          	ld	a5,-120(s0)
    80005a48:	00878713          	addi	a4,a5,8
    80005a4c:	f8e43423          	sd	a4,-120(s0)
    80005a50:	4605                	li	a2,1
    80005a52:	85da                	mv	a1,s6
    80005a54:	6388                	ld	a0,0(a5)
    80005a56:	ea1ff0ef          	jal	800058f6 <printint>
      i += 1;
    80005a5a:	002a049b          	addiw	s1,s4,2
    80005a5e:	b75d                	j	80005a04 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    80005a60:	f8843783          	ld	a5,-120(s0)
    80005a64:	00878713          	addi	a4,a5,8
    80005a68:	f8e43423          	sd	a4,-120(s0)
    80005a6c:	4605                	li	a2,1
    80005a6e:	85da                	mv	a1,s6
    80005a70:	4388                	lw	a0,0(a5)
    80005a72:	e85ff0ef          	jal	800058f6 <printint>
    80005a76:	b779                	j	80005a04 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    80005a78:	97ca                	add	a5,a5,s2
    80005a7a:	8636                	mv	a2,a3
    80005a7c:	0027c683          	lbu	a3,2(a5)
    80005a80:	a2c9                	j	80005c42 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    80005a82:	f8843783          	ld	a5,-120(s0)
    80005a86:	00878713          	addi	a4,a5,8
    80005a8a:	f8e43423          	sd	a4,-120(s0)
    80005a8e:	4605                	li	a2,1
    80005a90:	45a9                	li	a1,10
    80005a92:	6388                	ld	a0,0(a5)
    80005a94:	e63ff0ef          	jal	800058f6 <printint>
      i += 2;
    80005a98:	003a049b          	addiw	s1,s4,3
    80005a9c:	b7a5                	j	80005a04 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    80005a9e:	f8843783          	ld	a5,-120(s0)
    80005aa2:	00878713          	addi	a4,a5,8
    80005aa6:	f8e43423          	sd	a4,-120(s0)
    80005aaa:	4601                	li	a2,0
    80005aac:	85da                	mv	a1,s6
    80005aae:	0007e503          	lwu	a0,0(a5)
    80005ab2:	e45ff0ef          	jal	800058f6 <printint>
    80005ab6:	b7b9                	j	80005a04 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005ab8:	f8843783          	ld	a5,-120(s0)
    80005abc:	00878713          	addi	a4,a5,8
    80005ac0:	f8e43423          	sd	a4,-120(s0)
    80005ac4:	4601                	li	a2,0
    80005ac6:	85da                	mv	a1,s6
    80005ac8:	6388                	ld	a0,0(a5)
    80005aca:	e2dff0ef          	jal	800058f6 <printint>
      i += 1;
    80005ace:	002a049b          	addiw	s1,s4,2
    80005ad2:	bf0d                	j	80005a04 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005ad4:	f8843783          	ld	a5,-120(s0)
    80005ad8:	00878713          	addi	a4,a5,8
    80005adc:	f8e43423          	sd	a4,-120(s0)
    80005ae0:	4601                	li	a2,0
    80005ae2:	45a9                	li	a1,10
    80005ae4:	6388                	ld	a0,0(a5)
    80005ae6:	e11ff0ef          	jal	800058f6 <printint>
      i += 2;
    80005aea:	003a049b          	addiw	s1,s4,3
    80005aee:	bf19                	j	80005a04 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005af0:	f8843783          	ld	a5,-120(s0)
    80005af4:	00878713          	addi	a4,a5,8
    80005af8:	f8e43423          	sd	a4,-120(s0)
    80005afc:	4601                	li	a2,0
    80005afe:	45c1                	li	a1,16
    80005b00:	0007e503          	lwu	a0,0(a5)
    80005b04:	df3ff0ef          	jal	800058f6 <printint>
    80005b08:	bdf5                	j	80005a04 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005b0a:	f8843783          	ld	a5,-120(s0)
    80005b0e:	00878713          	addi	a4,a5,8
    80005b12:	f8e43423          	sd	a4,-120(s0)
    80005b16:	45c1                	li	a1,16
    80005b18:	6388                	ld	a0,0(a5)
    80005b1a:	dddff0ef          	jal	800058f6 <printint>
      i += 1;
    80005b1e:	002a049b          	addiw	s1,s4,2
    80005b22:	b5cd                	j	80005a04 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005b24:	f8843783          	ld	a5,-120(s0)
    80005b28:	00878713          	addi	a4,a5,8
    80005b2c:	f8e43423          	sd	a4,-120(s0)
    80005b30:	4601                	li	a2,0
    80005b32:	45c1                	li	a1,16
    80005b34:	6388                	ld	a0,0(a5)
    80005b36:	dc1ff0ef          	jal	800058f6 <printint>
      i += 2;
    80005b3a:	003a049b          	addiw	s1,s4,3
    80005b3e:	b5d9                	j	80005a04 <printf+0x78>
    80005b40:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    80005b42:	f8843783          	ld	a5,-120(s0)
    80005b46:	00878713          	addi	a4,a5,8
    80005b4a:	f8e43423          	sd	a4,-120(s0)
    80005b4e:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80005b52:	03000513          	li	a0,48
    80005b56:	bb7ff0ef          	jal	8000570c <consputc>
  consputc('x');
    80005b5a:	07800513          	li	a0,120
    80005b5e:	bafff0ef          	jal	8000570c <consputc>
    80005b62:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005b64:	00003c97          	auipc	s9,0x3
    80005b68:	e54c8c93          	addi	s9,s9,-428 # 800089b8 <digits>
    80005b6c:	03cad793          	srli	a5,s5,0x3c
    80005b70:	97e6                	add	a5,a5,s9
    80005b72:	0007c503          	lbu	a0,0(a5)
    80005b76:	b97ff0ef          	jal	8000570c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80005b7a:	0a92                	slli	s5,s5,0x4
    80005b7c:	3a7d                	addiw	s4,s4,-1
    80005b7e:	fe0a17e3          	bnez	s4,80005b6c <printf+0x1e0>
    80005b82:	7ca2                	ld	s9,40(sp)
    80005b84:	b541                	j	80005a04 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    80005b86:	f8843783          	ld	a5,-120(s0)
    80005b8a:	00878713          	addi	a4,a5,8
    80005b8e:	f8e43423          	sd	a4,-120(s0)
    80005b92:	4388                	lw	a0,0(a5)
    80005b94:	b79ff0ef          	jal	8000570c <consputc>
    80005b98:	b5b5                	j	80005a04 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    80005b9a:	f8843783          	ld	a5,-120(s0)
    80005b9e:	00878713          	addi	a4,a5,8
    80005ba2:	f8e43423          	sd	a4,-120(s0)
    80005ba6:	0007ba03          	ld	s4,0(a5)
    80005baa:	000a0d63          	beqz	s4,80005bc4 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    80005bae:	000a4503          	lbu	a0,0(s4)
    80005bb2:	e40509e3          	beqz	a0,80005a04 <printf+0x78>
        consputc(*s);
    80005bb6:	b57ff0ef          	jal	8000570c <consputc>
      for(; *s; s++)
    80005bba:	0a05                	addi	s4,s4,1
    80005bbc:	000a4503          	lbu	a0,0(s4)
    80005bc0:	f97d                	bnez	a0,80005bb6 <printf+0x22a>
    80005bc2:	b589                	j	80005a04 <printf+0x78>
        s = "(null)";
    80005bc4:	00003a17          	auipc	s4,0x3
    80005bc8:	c3ca0a13          	addi	s4,s4,-964 # 80008800 <etext+0x800>
      for(; *s; s++)
    80005bcc:	02800513          	li	a0,40
    80005bd0:	b7dd                	j	80005bb6 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005bd2:	8556                	mv	a0,s5
    80005bd4:	b39ff0ef          	jal	8000570c <consputc>
    80005bd8:	b535                	j	80005a04 <printf+0x78>
    80005bda:	74a6                	ld	s1,104(sp)
    80005bdc:	69e6                	ld	s3,88(sp)
    80005bde:	6a46                	ld	s4,80(sp)
    80005be0:	6aa6                	ld	s5,72(sp)
    80005be2:	6b06                	ld	s6,64(sp)
    80005be4:	7be2                	ld	s7,56(sp)
    80005be6:	7c42                	ld	s8,48(sp)
    80005be8:	7d02                	ld	s10,32(sp)
    80005bea:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    80005bec:	00003797          	auipc	a5,0x3
    80005bf0:	e147a783          	lw	a5,-492(a5) # 80008a00 <panicking>
    80005bf4:	c38d                	beqz	a5,80005c16 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80005bf6:	4501                	li	a0,0
    80005bf8:	70e6                	ld	ra,120(sp)
    80005bfa:	7446                	ld	s0,112(sp)
    80005bfc:	7906                	ld	s2,96(sp)
    80005bfe:	6129                	addi	sp,sp,192
    80005c00:	8082                	ret
    80005c02:	74a6                	ld	s1,104(sp)
    80005c04:	69e6                	ld	s3,88(sp)
    80005c06:	6a46                	ld	s4,80(sp)
    80005c08:	6aa6                	ld	s5,72(sp)
    80005c0a:	6b06                	ld	s6,64(sp)
    80005c0c:	7be2                	ld	s7,56(sp)
    80005c0e:	7c42                	ld	s8,48(sp)
    80005c10:	7d02                	ld	s10,32(sp)
    80005c12:	6de2                	ld	s11,24(sp)
    80005c14:	bfe1                	j	80005bec <printf+0x260>
    release(&pr.lock);
    80005c16:	0001e517          	auipc	a0,0x1e
    80005c1a:	4f250513          	addi	a0,a0,1266 # 80024108 <pr>
    80005c1e:	3ee000ef          	jal	8000600c <release>
  return 0;
    80005c22:	bfd1                	j	80005bf6 <printf+0x26a>
    if(c0 == 'd'){
    80005c24:	e37a8ee3          	beq	s5,s7,80005a60 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005c28:	f94a8713          	addi	a4,s5,-108
    80005c2c:	00173713          	seqz	a4,a4
    80005c30:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005c32:	4781                	li	a5,0
    80005c34:	a00d                	j	80005c56 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    80005c36:	f94a8713          	addi	a4,s5,-108
    80005c3a:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    80005c3e:	8656                	mv	a2,s5
    80005c40:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005c42:	f9460793          	addi	a5,a2,-108
    80005c46:	0017b793          	seqz	a5,a5
    80005c4a:	8ff9                	and	a5,a5,a4
    80005c4c:	f9c68593          	addi	a1,a3,-100
    80005c50:	e199                	bnez	a1,80005c56 <printf+0x2ca>
    80005c52:	e20798e3          	bnez	a5,80005a82 <printf+0xf6>
    } else if(c0 == 'u'){
    80005c56:	e58a84e3          	beq	s5,s8,80005a9e <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    80005c5a:	f8b60593          	addi	a1,a2,-117
    80005c5e:	e199                	bnez	a1,80005c64 <printf+0x2d8>
    80005c60:	e4071ce3          	bnez	a4,80005ab8 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005c64:	f8b68593          	addi	a1,a3,-117
    80005c68:	e199                	bnez	a1,80005c6e <printf+0x2e2>
    80005c6a:	e60795e3          	bnez	a5,80005ad4 <printf+0x148>
    } else if(c0 == 'x'){
    80005c6e:	e9aa81e3          	beq	s5,s10,80005af0 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    80005c72:	f8860613          	addi	a2,a2,-120
    80005c76:	e219                	bnez	a2,80005c7c <printf+0x2f0>
    80005c78:	e80719e3          	bnez	a4,80005b0a <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    80005c7c:	f8868693          	addi	a3,a3,-120
    80005c80:	e299                	bnez	a3,80005c86 <printf+0x2fa>
    80005c82:	ea0791e3          	bnez	a5,80005b24 <printf+0x198>
    } else if(c0 == 'p'){
    80005c86:	ebba8de3          	beq	s5,s11,80005b40 <printf+0x1b4>
    } else if(c0 == 'c'){
    80005c8a:	06300793          	li	a5,99
    80005c8e:	eefa8ce3          	beq	s5,a5,80005b86 <printf+0x1fa>
    } else if(c0 == 's'){
    80005c92:	07300793          	li	a5,115
    80005c96:	f0fa82e3          	beq	s5,a5,80005b9a <printf+0x20e>
    } else if(c0 == '%'){
    80005c9a:	02500793          	li	a5,37
    80005c9e:	f2fa8ae3          	beq	s5,a5,80005bd2 <printf+0x246>
    } else if(c0 == 0){
    80005ca2:	f60a80e3          	beqz	s5,80005c02 <printf+0x276>
      consputc('%');
    80005ca6:	02500513          	li	a0,37
    80005caa:	a63ff0ef          	jal	8000570c <consputc>
      consputc(c0);
    80005cae:	8556                	mv	a0,s5
    80005cb0:	a5dff0ef          	jal	8000570c <consputc>
    80005cb4:	bb81                	j	80005a04 <printf+0x78>

0000000080005cb6 <panic>:

void
panic(char *s)
{
    80005cb6:	1101                	addi	sp,sp,-32
    80005cb8:	ec06                	sd	ra,24(sp)
    80005cba:	e822                	sd	s0,16(sp)
    80005cbc:	e426                	sd	s1,8(sp)
    80005cbe:	e04a                	sd	s2,0(sp)
    80005cc0:	1000                	addi	s0,sp,32
    80005cc2:	892a                	mv	s2,a0
  panicking = 1;
    80005cc4:	4485                	li	s1,1
    80005cc6:	00003797          	auipc	a5,0x3
    80005cca:	d297ad23          	sw	s1,-710(a5) # 80008a00 <panicking>
  printf("panic: ");
    80005cce:	00003517          	auipc	a0,0x3
    80005cd2:	b3a50513          	addi	a0,a0,-1222 # 80008808 <etext+0x808>
    80005cd6:	cb7ff0ef          	jal	8000598c <printf>
  printf("%s\n", s);
    80005cda:	85ca                	mv	a1,s2
    80005cdc:	00003517          	auipc	a0,0x3
    80005ce0:	b3450513          	addi	a0,a0,-1228 # 80008810 <etext+0x810>
    80005ce4:	ca9ff0ef          	jal	8000598c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ce8:	00003797          	auipc	a5,0x3
    80005cec:	d097aa23          	sw	s1,-748(a5) # 800089fc <panicked>
  for(;;)
    80005cf0:	a001                	j	80005cf0 <panic+0x3a>

0000000080005cf2 <printfinit>:
    ;
}

void
printfinit(void)
{
    80005cf2:	1141                	addi	sp,sp,-16
    80005cf4:	e406                	sd	ra,8(sp)
    80005cf6:	e022                	sd	s0,0(sp)
    80005cf8:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    80005cfa:	00003597          	auipc	a1,0x3
    80005cfe:	b1e58593          	addi	a1,a1,-1250 # 80008818 <etext+0x818>
    80005d02:	0001e517          	auipc	a0,0x1e
    80005d06:	40650513          	addi	a0,a0,1030 # 80024108 <pr>
    80005d0a:	1e4000ef          	jal	80005eee <initlock>
}
    80005d0e:	60a2                	ld	ra,8(sp)
    80005d10:	6402                	ld	s0,0(sp)
    80005d12:	0141                	addi	sp,sp,16
    80005d14:	8082                	ret

0000000080005d16 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    80005d16:	1141                	addi	sp,sp,-16
    80005d18:	e406                	sd	ra,8(sp)
    80005d1a:	e022                	sd	s0,0(sp)
    80005d1c:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    80005d1e:	100007b7          	lui	a5,0x10000
    80005d22:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80005d26:	10000737          	lui	a4,0x10000
    80005d2a:	f8000693          	li	a3,-128
    80005d2e:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    80005d32:	468d                	li	a3,3
    80005d34:	10000637          	lui	a2,0x10000
    80005d38:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80005d3c:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80005d40:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    80005d44:	8732                	mv	a4,a2
    80005d46:	461d                	li	a2,7
    80005d48:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80005d4c:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    80005d50:	00003597          	auipc	a1,0x3
    80005d54:	ad058593          	addi	a1,a1,-1328 # 80008820 <etext+0x820>
    80005d58:	0001e517          	auipc	a0,0x1e
    80005d5c:	3c850513          	addi	a0,a0,968 # 80024120 <tx_lock>
    80005d60:	18e000ef          	jal	80005eee <initlock>
}
    80005d64:	60a2                	ld	ra,8(sp)
    80005d66:	6402                	ld	s0,0(sp)
    80005d68:	0141                	addi	sp,sp,16
    80005d6a:	8082                	ret

0000000080005d6c <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    80005d6c:	715d                	addi	sp,sp,-80
    80005d6e:	e486                	sd	ra,72(sp)
    80005d70:	e0a2                	sd	s0,64(sp)
    80005d72:	fc26                	sd	s1,56(sp)
    80005d74:	ec56                	sd	s5,24(sp)
    80005d76:	0880                	addi	s0,sp,80
    80005d78:	8aaa                	mv	s5,a0
    80005d7a:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005d7c:	0001e517          	auipc	a0,0x1e
    80005d80:	3a450513          	addi	a0,a0,932 # 80024120 <tx_lock>
    80005d84:	1f4000ef          	jal	80005f78 <acquire>

  int i = 0;
  while(i < n){ 
    80005d88:	06905063          	blez	s1,80005de8 <uartwrite+0x7c>
    80005d8c:	f84a                	sd	s2,48(sp)
    80005d8e:	f44e                	sd	s3,40(sp)
    80005d90:	f052                	sd	s4,32(sp)
    80005d92:	e85a                	sd	s6,16(sp)
    80005d94:	e45e                	sd	s7,8(sp)
    80005d96:	8a56                	mv	s4,s5
    80005d98:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005d9a:	00003497          	auipc	s1,0x3
    80005d9e:	c6e48493          	addi	s1,s1,-914 # 80008a08 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005da2:	0001e997          	auipc	s3,0x1e
    80005da6:	37e98993          	addi	s3,s3,894 # 80024120 <tx_lock>
    80005daa:	00003917          	auipc	s2,0x3
    80005dae:	c5a90913          	addi	s2,s2,-934 # 80008a04 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005db2:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005db6:	4b05                	li	s6,1
    80005db8:	a005                	j	80005dd8 <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005dba:	85ce                	mv	a1,s3
    80005dbc:	854a                	mv	a0,s2
    80005dbe:	bf7fb0ef          	jal	800019b4 <sleep>
    while(tx_busy != 0){
    80005dc2:	409c                	lw	a5,0(s1)
    80005dc4:	fbfd                	bnez	a5,80005dba <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005dc6:	000a4783          	lbu	a5,0(s4)
    80005dca:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005dce:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005dd2:	0a05                	addi	s4,s4,1
    80005dd4:	015a0563          	beq	s4,s5,80005dde <uartwrite+0x72>
    while(tx_busy != 0){
    80005dd8:	409c                	lw	a5,0(s1)
    80005dda:	f3e5                	bnez	a5,80005dba <uartwrite+0x4e>
    80005ddc:	b7ed                	j	80005dc6 <uartwrite+0x5a>
    80005dde:	7942                	ld	s2,48(sp)
    80005de0:	79a2                	ld	s3,40(sp)
    80005de2:	7a02                	ld	s4,32(sp)
    80005de4:	6b42                	ld	s6,16(sp)
    80005de6:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005de8:	0001e517          	auipc	a0,0x1e
    80005dec:	33850513          	addi	a0,a0,824 # 80024120 <tx_lock>
    80005df0:	21c000ef          	jal	8000600c <release>
}
    80005df4:	60a6                	ld	ra,72(sp)
    80005df6:	6406                	ld	s0,64(sp)
    80005df8:	74e2                	ld	s1,56(sp)
    80005dfa:	6ae2                	ld	s5,24(sp)
    80005dfc:	6161                	addi	sp,sp,80
    80005dfe:	8082                	ret

0000000080005e00 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005e00:	1101                	addi	sp,sp,-32
    80005e02:	ec06                	sd	ra,24(sp)
    80005e04:	e822                	sd	s0,16(sp)
    80005e06:	e426                	sd	s1,8(sp)
    80005e08:	1000                	addi	s0,sp,32
    80005e0a:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005e0c:	00003797          	auipc	a5,0x3
    80005e10:	bf47a783          	lw	a5,-1036(a5) # 80008a00 <panicking>
    80005e14:	cf95                	beqz	a5,80005e50 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005e16:	00003797          	auipc	a5,0x3
    80005e1a:	be67a783          	lw	a5,-1050(a5) # 800089fc <panicked>
    80005e1e:	ef85                	bnez	a5,80005e56 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005e20:	10000737          	lui	a4,0x10000
    80005e24:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005e26:	00074783          	lbu	a5,0(a4)
    80005e2a:	0207f793          	andi	a5,a5,32
    80005e2e:	dfe5                	beqz	a5,80005e26 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005e30:	0ff4f513          	zext.b	a0,s1
    80005e34:	100007b7          	lui	a5,0x10000
    80005e38:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005e3c:	00003797          	auipc	a5,0x3
    80005e40:	bc47a783          	lw	a5,-1084(a5) # 80008a00 <panicking>
    80005e44:	cb91                	beqz	a5,80005e58 <uartputc_sync+0x58>
    pop_off();
}
    80005e46:	60e2                	ld	ra,24(sp)
    80005e48:	6442                	ld	s0,16(sp)
    80005e4a:	64a2                	ld	s1,8(sp)
    80005e4c:	6105                	addi	sp,sp,32
    80005e4e:	8082                	ret
    push_off();
    80005e50:	0e4000ef          	jal	80005f34 <push_off>
    80005e54:	b7c9                	j	80005e16 <uartputc_sync+0x16>
    for(;;)
    80005e56:	a001                	j	80005e56 <uartputc_sync+0x56>
    pop_off();
    80005e58:	164000ef          	jal	80005fbc <pop_off>
}
    80005e5c:	b7ed                	j	80005e46 <uartputc_sync+0x46>

0000000080005e5e <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005e5e:	1141                	addi	sp,sp,-16
    80005e60:	e406                	sd	ra,8(sp)
    80005e62:	e022                	sd	s0,0(sp)
    80005e64:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005e66:	100007b7          	lui	a5,0x10000
    80005e6a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005e6e:	8b85                	andi	a5,a5,1
    80005e70:	cb89                	beqz	a5,80005e82 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005e72:	100007b7          	lui	a5,0x10000
    80005e76:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005e7a:	60a2                	ld	ra,8(sp)
    80005e7c:	6402                	ld	s0,0(sp)
    80005e7e:	0141                	addi	sp,sp,16
    80005e80:	8082                	ret
    return -1;
    80005e82:	557d                	li	a0,-1
    80005e84:	bfdd                	j	80005e7a <uartgetc+0x1c>

0000000080005e86 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005e86:	1101                	addi	sp,sp,-32
    80005e88:	ec06                	sd	ra,24(sp)
    80005e8a:	e822                	sd	s0,16(sp)
    80005e8c:	e426                	sd	s1,8(sp)
    80005e8e:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005e90:	100007b7          	lui	a5,0x10000
    80005e94:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005e98:	0001e517          	auipc	a0,0x1e
    80005e9c:	28850513          	addi	a0,a0,648 # 80024120 <tx_lock>
    80005ea0:	0d8000ef          	jal	80005f78 <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005ea4:	100007b7          	lui	a5,0x10000
    80005ea8:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005eac:	0207f793          	andi	a5,a5,32
    80005eb0:	ef99                	bnez	a5,80005ece <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005eb2:	0001e517          	auipc	a0,0x1e
    80005eb6:	26e50513          	addi	a0,a0,622 # 80024120 <tx_lock>
    80005eba:	152000ef          	jal	8000600c <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005ebe:	54fd                	li	s1,-1
    int c = uartgetc();
    80005ec0:	f9fff0ef          	jal	80005e5e <uartgetc>
    if(c == -1)
    80005ec4:	02950063          	beq	a0,s1,80005ee4 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005ec8:	877ff0ef          	jal	8000573e <consoleintr>
  while(1){
    80005ecc:	bfd5                	j	80005ec0 <uartintr+0x3a>
    tx_busy = 0;
    80005ece:	00003797          	auipc	a5,0x3
    80005ed2:	b207ad23          	sw	zero,-1222(a5) # 80008a08 <tx_busy>
    wakeup(&tx_chan);
    80005ed6:	00003517          	auipc	a0,0x3
    80005eda:	b2e50513          	addi	a0,a0,-1234 # 80008a04 <tx_chan>
    80005ede:	b23fb0ef          	jal	80001a00 <wakeup>
    80005ee2:	bfc1                	j	80005eb2 <uartintr+0x2c>
  }
}
    80005ee4:	60e2                	ld	ra,24(sp)
    80005ee6:	6442                	ld	s0,16(sp)
    80005ee8:	64a2                	ld	s1,8(sp)
    80005eea:	6105                	addi	sp,sp,32
    80005eec:	8082                	ret

0000000080005eee <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005eee:	1141                	addi	sp,sp,-16
    80005ef0:	e406                	sd	ra,8(sp)
    80005ef2:	e022                	sd	s0,0(sp)
    80005ef4:	0800                	addi	s0,sp,16
  lk->name = name;
    80005ef6:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005ef8:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005efc:	00053823          	sd	zero,16(a0)
}
    80005f00:	60a2                	ld	ra,8(sp)
    80005f02:	6402                	ld	s0,0(sp)
    80005f04:	0141                	addi	sp,sp,16
    80005f06:	8082                	ret

0000000080005f08 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005f08:	411c                	lw	a5,0(a0)
    80005f0a:	e399                	bnez	a5,80005f10 <holding+0x8>
    80005f0c:	4501                	li	a0,0
  return r;
}
    80005f0e:	8082                	ret
{
    80005f10:	1101                	addi	sp,sp,-32
    80005f12:	ec06                	sd	ra,24(sp)
    80005f14:	e822                	sd	s0,16(sp)
    80005f16:	e426                	sd	s1,8(sp)
    80005f18:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005f1a:	691c                	ld	a5,16(a0)
    80005f1c:	84be                	mv	s1,a5
    80005f1e:	c02fb0ef          	jal	80001320 <mycpu>
    80005f22:	40a48533          	sub	a0,s1,a0
    80005f26:	00153513          	seqz	a0,a0
}
    80005f2a:	60e2                	ld	ra,24(sp)
    80005f2c:	6442                	ld	s0,16(sp)
    80005f2e:	64a2                	ld	s1,8(sp)
    80005f30:	6105                	addi	sp,sp,32
    80005f32:	8082                	ret

0000000080005f34 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005f34:	1101                	addi	sp,sp,-32
    80005f36:	ec06                	sd	ra,24(sp)
    80005f38:	e822                	sd	s0,16(sp)
    80005f3a:	e426                	sd	s1,8(sp)
    80005f3c:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005f3e:	100027f3          	csrr	a5,sstatus
    80005f42:	84be                	mv	s1,a5
    80005f44:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005f48:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005f4a:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005f4e:	bd2fb0ef          	jal	80001320 <mycpu>
    80005f52:	5d3c                	lw	a5,120(a0)
    80005f54:	cb99                	beqz	a5,80005f6a <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005f56:	bcafb0ef          	jal	80001320 <mycpu>
    80005f5a:	5d3c                	lw	a5,120(a0)
    80005f5c:	2785                	addiw	a5,a5,1
    80005f5e:	dd3c                	sw	a5,120(a0)
}
    80005f60:	60e2                	ld	ra,24(sp)
    80005f62:	6442                	ld	s0,16(sp)
    80005f64:	64a2                	ld	s1,8(sp)
    80005f66:	6105                	addi	sp,sp,32
    80005f68:	8082                	ret
    mycpu()->intena = old;
    80005f6a:	bb6fb0ef          	jal	80001320 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005f6e:	0014d793          	srli	a5,s1,0x1
    80005f72:	8b85                	andi	a5,a5,1
    80005f74:	dd7c                	sw	a5,124(a0)
    80005f76:	b7c5                	j	80005f56 <push_off+0x22>

0000000080005f78 <acquire>:
{
    80005f78:	1101                	addi	sp,sp,-32
    80005f7a:	ec06                	sd	ra,24(sp)
    80005f7c:	e822                	sd	s0,16(sp)
    80005f7e:	e426                	sd	s1,8(sp)
    80005f80:	1000                	addi	s0,sp,32
    80005f82:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005f84:	fb1ff0ef          	jal	80005f34 <push_off>
  if(holding(lk))
    80005f88:	8526                	mv	a0,s1
    80005f8a:	f7fff0ef          	jal	80005f08 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005f8e:	4705                	li	a4,1
  if(holding(lk))
    80005f90:	e105                	bnez	a0,80005fb0 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005f92:	87ba                	mv	a5,a4
    80005f94:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005f98:	2781                	sext.w	a5,a5
    80005f9a:	ffe5                	bnez	a5,80005f92 <acquire+0x1a>
  __sync_synchronize();
    80005f9c:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005fa0:	b80fb0ef          	jal	80001320 <mycpu>
    80005fa4:	e888                	sd	a0,16(s1)
}
    80005fa6:	60e2                	ld	ra,24(sp)
    80005fa8:	6442                	ld	s0,16(sp)
    80005faa:	64a2                	ld	s1,8(sp)
    80005fac:	6105                	addi	sp,sp,32
    80005fae:	8082                	ret
    panic("acquire");
    80005fb0:	00003517          	auipc	a0,0x3
    80005fb4:	87850513          	addi	a0,a0,-1928 # 80008828 <etext+0x828>
    80005fb8:	cffff0ef          	jal	80005cb6 <panic>

0000000080005fbc <pop_off>:

void
pop_off(void)
{
    80005fbc:	1141                	addi	sp,sp,-16
    80005fbe:	e406                	sd	ra,8(sp)
    80005fc0:	e022                	sd	s0,0(sp)
    80005fc2:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005fc4:	b5cfb0ef          	jal	80001320 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005fc8:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005fcc:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005fce:	e39d                	bnez	a5,80005ff4 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005fd0:	5d3c                	lw	a5,120(a0)
    80005fd2:	02f05763          	blez	a5,80006000 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005fd6:	37fd                	addiw	a5,a5,-1
    80005fd8:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005fda:	eb89                	bnez	a5,80005fec <pop_off+0x30>
    80005fdc:	5d7c                	lw	a5,124(a0)
    80005fde:	c799                	beqz	a5,80005fec <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005fe0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005fe4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005fe8:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005fec:	60a2                	ld	ra,8(sp)
    80005fee:	6402                	ld	s0,0(sp)
    80005ff0:	0141                	addi	sp,sp,16
    80005ff2:	8082                	ret
    panic("pop_off - interruptible");
    80005ff4:	00003517          	auipc	a0,0x3
    80005ff8:	83c50513          	addi	a0,a0,-1988 # 80008830 <etext+0x830>
    80005ffc:	cbbff0ef          	jal	80005cb6 <panic>
    panic("pop_off");
    80006000:	00003517          	auipc	a0,0x3
    80006004:	84850513          	addi	a0,a0,-1976 # 80008848 <etext+0x848>
    80006008:	cafff0ef          	jal	80005cb6 <panic>

000000008000600c <release>:
{
    8000600c:	1101                	addi	sp,sp,-32
    8000600e:	ec06                	sd	ra,24(sp)
    80006010:	e822                	sd	s0,16(sp)
    80006012:	e426                	sd	s1,8(sp)
    80006014:	1000                	addi	s0,sp,32
    80006016:	84aa                	mv	s1,a0
  if(!holding(lk))
    80006018:	ef1ff0ef          	jal	80005f08 <holding>
    8000601c:	c105                	beqz	a0,8000603c <release+0x30>
  lk->cpu = 0;
    8000601e:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80006022:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80006026:	0310000f          	fence	rw,w
    8000602a:	0004a023          	sw	zero,0(s1)
  pop_off();
    8000602e:	f8fff0ef          	jal	80005fbc <pop_off>
}
    80006032:	60e2                	ld	ra,24(sp)
    80006034:	6442                	ld	s0,16(sp)
    80006036:	64a2                	ld	s1,8(sp)
    80006038:	6105                	addi	sp,sp,32
    8000603a:	8082                	ret
    panic("release");
    8000603c:	00003517          	auipc	a0,0x3
    80006040:	81450513          	addi	a0,a0,-2028 # 80008850 <etext+0x850>
    80006044:	c73ff0ef          	jal	80005cb6 <panic>
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
