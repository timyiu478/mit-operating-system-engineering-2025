
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
_entry:
        # set up a stack for C.
        # stack0 is declared in start.c,
        # with a 4096-byte stack per CPU.
        # sp = stack0 + ((hartid + 1) * 4096)
        la sp, stack0
    80000000:	00239117          	auipc	sp,0x239
    80000004:	b2010113          	addi	sp,sp,-1248 # 80238b20 <stack0>
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
    80000016:	110050ef          	jal	80005126 <start>

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
    80000028:	892a                	mv	s2,a0
  struct run *r;
  int idx;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP) {
    8000002a:	00241797          	auipc	a5,0x241
    8000002e:	bce78793          	addi	a5,a5,-1074 # 80240bf8 <end>
    80000032:	00f53733          	sltu	a4,a0,a5
    80000036:	47c5                	li	a5,17
    80000038:	07ee                	slli	a5,a5,0x1b
    8000003a:	17fd                	addi	a5,a5,-1
    8000003c:	00a7b7b3          	sltu	a5,a5,a0
    80000040:	8fd9                	or	a5,a5,a4
    80000042:	efa9                	bnez	a5,8000009c <kfree+0x80>
    80000044:	03451793          	slli	a5,a0,0x34
    80000048:	ebb1                	bnez	a5,8000009c <kfree+0x80>
    printf("invalid pa: %p\n", pa);
    panic("kfree");
  }

  idx = PA2IDX((uint64)pa);
    8000004a:	800004b7          	lui	s1,0x80000
    8000004e:	94aa                	add	s1,s1,a0
    80000050:	80b1                	srli	s1,s1,0xc
    80000052:	2481                	sext.w	s1,s1

  acquire(&kmem.lock);
    80000054:	00008517          	auipc	a0,0x8
    80000058:	89c50513          	addi	a0,a0,-1892 # 800078f0 <kmem>
    8000005c:	3af050ef          	jal	80005c0a <acquire>
  if(refcount[idx] == 0) { // double free?
    80000060:	00249713          	slli	a4,s1,0x2
    80000064:	00008797          	auipc	a5,0x8
    80000068:	8ac78793          	addi	a5,a5,-1876 # 80007910 <refcount>
    8000006c:	97ba                	add	a5,a5,a4
    8000006e:	439c                	lw	a5,0(a5)
    80000070:	c3b9                	beqz	a5,800000b6 <kfree+0x9a>
    printf("double free pa: %p\n", pa);
    panic("kfree");
  }
  refcount[idx]--;
    80000072:	37fd                	addiw	a5,a5,-1
    80000074:	048a                	slli	s1,s1,0x2
    80000076:	00008717          	auipc	a4,0x8
    8000007a:	89a70713          	addi	a4,a4,-1894 # 80007910 <refcount>
    8000007e:	9726                	add	a4,a4,s1
    80000080:	c31c                	sw	a5,0(a4)
  if(refcount[idx] == 0) {
    80000082:	c7b9                	beqz	a5,800000d0 <kfree+0xb4>
    r = (struct run*)pa;
  
    r->next = kmem.freelist;
    kmem.freelist = r;
  }
  release(&kmem.lock);
    80000084:	00008517          	auipc	a0,0x8
    80000088:	86c50513          	addi	a0,a0,-1940 # 800078f0 <kmem>
    8000008c:	413050ef          	jal	80005c9e <release>
}
    80000090:	60e2                	ld	ra,24(sp)
    80000092:	6442                	ld	s0,16(sp)
    80000094:	64a2                	ld	s1,8(sp)
    80000096:	6902                	ld	s2,0(sp)
    80000098:	6105                	addi	sp,sp,32
    8000009a:	8082                	ret
    printf("invalid pa: %p\n", pa);
    8000009c:	85ca                	mv	a1,s2
    8000009e:	00007517          	auipc	a0,0x7
    800000a2:	f6250513          	addi	a0,a0,-158 # 80007000 <etext>
    800000a6:	516050ef          	jal	800055bc <printf>
    panic("kfree");
    800000aa:	00007517          	auipc	a0,0x7
    800000ae:	f6650513          	addi	a0,a0,-154 # 80007010 <etext+0x10>
    800000b2:	0b7050ef          	jal	80005968 <panic>
    printf("double free pa: %p\n", pa);
    800000b6:	85ca                	mv	a1,s2
    800000b8:	00007517          	auipc	a0,0x7
    800000bc:	f6850513          	addi	a0,a0,-152 # 80007020 <etext+0x20>
    800000c0:	4fc050ef          	jal	800055bc <printf>
    panic("kfree");
    800000c4:	00007517          	auipc	a0,0x7
    800000c8:	f4c50513          	addi	a0,a0,-180 # 80007010 <etext+0x10>
    800000cc:	09d050ef          	jal	80005968 <panic>
    memset(pa, 1, PGSIZE);
    800000d0:	6605                	lui	a2,0x1
    800000d2:	4585                	li	a1,1
    800000d4:	854a                	mv	a0,s2
    800000d6:	1ce000ef          	jal	800002a4 <memset>
    r->next = kmem.freelist;
    800000da:	00008797          	auipc	a5,0x8
    800000de:	81678793          	addi	a5,a5,-2026 # 800078f0 <kmem>
    800000e2:	6f98                	ld	a4,24(a5)
    800000e4:	00e93023          	sd	a4,0(s2)
    kmem.freelist = r;
    800000e8:	0127bc23          	sd	s2,24(a5)
    800000ec:	bf61                	j	80000084 <kfree+0x68>

00000000800000ee <freerange>:
{
    800000ee:	715d                	addi	sp,sp,-80
    800000f0:	e486                	sd	ra,72(sp)
    800000f2:	e0a2                	sd	s0,64(sp)
    800000f4:	fc26                	sd	s1,56(sp)
    800000f6:	0880                	addi	s0,sp,80
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000f8:	6785                	lui	a5,0x1
    800000fa:	fff78713          	addi	a4,a5,-1 # fff <_entry-0x7ffff001>
    800000fe:	00e504b3          	add	s1,a0,a4
    80000102:	777d                	lui	a4,0xfffff
    80000104:	8cf9                	and	s1,s1,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000106:	94be                	add	s1,s1,a5
    80000108:	0495e863          	bltu	a1,s1,80000158 <freerange+0x6a>
    8000010c:	f84a                	sd	s2,48(sp)
    8000010e:	f44e                	sd	s3,40(sp)
    80000110:	f052                	sd	s4,32(sp)
    80000112:	ec56                	sd	s5,24(sp)
    80000114:	e85a                	sd	s6,16(sp)
    80000116:	e45e                	sd	s7,8(sp)
    80000118:	89ae                	mv	s3,a1
    refcount[PA2IDX(p)] = 1;
    8000011a:	00007a97          	auipc	s5,0x7
    8000011e:	7f6a8a93          	addi	s5,s5,2038 # 80007910 <refcount>
    80000122:	fff80937          	lui	s2,0xfff80
    80000126:	197d                	addi	s2,s2,-1 # fffffffffff7ffff <end+0xffffffff7fd3f407>
    80000128:	0932                	slli	s2,s2,0xc
    8000012a:	4b85                	li	s7,1
    kfree(p);
    8000012c:	8b3a                	mv	s6,a4
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    8000012e:	8a3e                	mv	s4,a5
    refcount[PA2IDX(p)] = 1;
    80000130:	012487b3          	add	a5,s1,s2
    80000134:	83b1                	srli	a5,a5,0xc
    80000136:	078a                	slli	a5,a5,0x2
    80000138:	97d6                	add	a5,a5,s5
    8000013a:	0177a023          	sw	s7,0(a5)
    kfree(p);
    8000013e:	01648533          	add	a0,s1,s6
    80000142:	edbff0ef          	jal	8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE) {
    80000146:	94d2                	add	s1,s1,s4
    80000148:	fe99f4e3          	bgeu	s3,s1,80000130 <freerange+0x42>
    8000014c:	7942                	ld	s2,48(sp)
    8000014e:	79a2                	ld	s3,40(sp)
    80000150:	7a02                	ld	s4,32(sp)
    80000152:	6ae2                	ld	s5,24(sp)
    80000154:	6b42                	ld	s6,16(sp)
    80000156:	6ba2                	ld	s7,8(sp)
}
    80000158:	60a6                	ld	ra,72(sp)
    8000015a:	6406                	ld	s0,64(sp)
    8000015c:	74e2                	ld	s1,56(sp)
    8000015e:	6161                	addi	sp,sp,80
    80000160:	8082                	ret

0000000080000162 <kinit>:
{
    80000162:	1141                	addi	sp,sp,-16
    80000164:	e406                	sd	ra,8(sp)
    80000166:	e022                	sd	s0,0(sp)
    80000168:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    8000016a:	00007597          	auipc	a1,0x7
    8000016e:	ece58593          	addi	a1,a1,-306 # 80007038 <etext+0x38>
    80000172:	00007517          	auipc	a0,0x7
    80000176:	77e50513          	addi	a0,a0,1918 # 800078f0 <kmem>
    8000017a:	207050ef          	jal	80005b80 <initlock>
  freerange(end, (void*)PHYSTOP);
    8000017e:	45c5                	li	a1,17
    80000180:	05ee                	slli	a1,a1,0x1b
    80000182:	00241517          	auipc	a0,0x241
    80000186:	a7650513          	addi	a0,a0,-1418 # 80240bf8 <end>
    8000018a:	f65ff0ef          	jal	800000ee <freerange>
}
    8000018e:	60a2                	ld	ra,8(sp)
    80000190:	6402                	ld	s0,0(sp)
    80000192:	0141                	addi	sp,sp,16
    80000194:	8082                	ret

0000000080000196 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000196:	1101                	addi	sp,sp,-32
    80000198:	ec06                	sd	ra,24(sp)
    8000019a:	e822                	sd	s0,16(sp)
    8000019c:	e426                	sd	s1,8(sp)
    8000019e:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    800001a0:	00007517          	auipc	a0,0x7
    800001a4:	75050513          	addi	a0,a0,1872 # 800078f0 <kmem>
    800001a8:	263050ef          	jal	80005c0a <acquire>
  r = kmem.freelist;
    800001ac:	00007497          	auipc	s1,0x7
    800001b0:	75c4b483          	ld	s1,1884(s1) # 80007908 <kmem+0x18>
  if(r) {
    800001b4:	c8ad                	beqz	s1,80000226 <kalloc+0x90>
    kmem.freelist = r->next;
    800001b6:	609c                	ld	a5,0(s1)
    800001b8:	00007717          	auipc	a4,0x7
    800001bc:	74f73823          	sd	a5,1872(a4) # 80007908 <kmem+0x18>
    if (refcount[PA2IDX((uint64)r)]) {
    800001c0:	800007b7          	lui	a5,0x80000
    800001c4:	97a6                	add	a5,a5,s1
    800001c6:	83b1                	srli	a5,a5,0xc
    800001c8:	00279693          	slli	a3,a5,0x2
    800001cc:	00007717          	auipc	a4,0x7
    800001d0:	74470713          	addi	a4,a4,1860 # 80007910 <refcount>
    800001d4:	9736                	add	a4,a4,a3
    800001d6:	4310                	lw	a2,0(a4)
    800001d8:	ea15                	bnez	a2,8000020c <kalloc+0x76>
      printf("ref count of %p is %d != 1 when kalloc\n", (void *)r, refcount[PA2IDX((uint64)r)]);
      panic("kalloc");
    }
    refcount[PA2IDX((uint64)r)] = 1;
    800001da:	078a                	slli	a5,a5,0x2
    800001dc:	00007717          	auipc	a4,0x7
    800001e0:	73470713          	addi	a4,a4,1844 # 80007910 <refcount>
    800001e4:	97ba                	add	a5,a5,a4
    800001e6:	4705                	li	a4,1
    800001e8:	c398                	sw	a4,0(a5)
  }
  release(&kmem.lock);
    800001ea:	00007517          	auipc	a0,0x7
    800001ee:	70650513          	addi	a0,a0,1798 # 800078f0 <kmem>
    800001f2:	2ad050ef          	jal	80005c9e <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    800001f6:	6605                	lui	a2,0x1
    800001f8:	4595                	li	a1,5
    800001fa:	8526                	mv	a0,s1
    800001fc:	0a8000ef          	jal	800002a4 <memset>
  return (void*)r;
}
    80000200:	8526                	mv	a0,s1
    80000202:	60e2                	ld	ra,24(sp)
    80000204:	6442                	ld	s0,16(sp)
    80000206:	64a2                	ld	s1,8(sp)
    80000208:	6105                	addi	sp,sp,32
    8000020a:	8082                	ret
      printf("ref count of %p is %d != 1 when kalloc\n", (void *)r, refcount[PA2IDX((uint64)r)]);
    8000020c:	85a6                	mv	a1,s1
    8000020e:	00007517          	auipc	a0,0x7
    80000212:	e3250513          	addi	a0,a0,-462 # 80007040 <etext+0x40>
    80000216:	3a6050ef          	jal	800055bc <printf>
      panic("kalloc");
    8000021a:	00007517          	auipc	a0,0x7
    8000021e:	e4e50513          	addi	a0,a0,-434 # 80007068 <etext+0x68>
    80000222:	746050ef          	jal	80005968 <panic>
  release(&kmem.lock);
    80000226:	00007517          	auipc	a0,0x7
    8000022a:	6ca50513          	addi	a0,a0,1738 # 800078f0 <kmem>
    8000022e:	271050ef          	jal	80005c9e <release>
  if(r)
    80000232:	b7f9                	j	80000200 <kalloc+0x6a>

0000000080000234 <kincref>:

// Increase the reference count of the physical memory page by 1
// Expected caller: vm.c:uvmcopy()
void
kincref(uint64 pa)
{
    80000234:	1101                	addi	sp,sp,-32
    80000236:	ec06                	sd	ra,24(sp)
    80000238:	e822                	sd	s0,16(sp)
    8000023a:	e426                	sd	s1,8(sp)
    8000023c:	1000                	addi	s0,sp,32
    8000023e:	84aa                	mv	s1,a0
  acquire(&kmem.lock);
    80000240:	00007517          	auipc	a0,0x7
    80000244:	6b050513          	addi	a0,a0,1712 # 800078f0 <kmem>
    80000248:	1c3050ef          	jal	80005c0a <acquire>
  refcount[PA2IDX(pa)]++;
    8000024c:	800007b7          	lui	a5,0x80000
    80000250:	00f48533          	add	a0,s1,a5
    80000254:	8131                	srli	a0,a0,0xc
    80000256:	050a                	slli	a0,a0,0x2
    80000258:	00007797          	auipc	a5,0x7
    8000025c:	6b878793          	addi	a5,a5,1720 # 80007910 <refcount>
    80000260:	97aa                	add	a5,a5,a0
    80000262:	4398                	lw	a4,0(a5)
    80000264:	2705                	addiw	a4,a4,1
    80000266:	c398                	sw	a4,0(a5)
  release(&kmem.lock);
    80000268:	00007517          	auipc	a0,0x7
    8000026c:	68850513          	addi	a0,a0,1672 # 800078f0 <kmem>
    80000270:	22f050ef          	jal	80005c9e <release>
}
    80000274:	60e2                	ld	ra,24(sp)
    80000276:	6442                	ld	s0,16(sp)
    80000278:	64a2                	ld	s1,8(sp)
    8000027a:	6105                	addi	sp,sp,32
    8000027c:	8082                	ret

000000008000027e <kref>:

// Get reference count of pa
int
kref(uint64 pa)
{
    8000027e:	1141                	addi	sp,sp,-16
    80000280:	e406                	sd	ra,8(sp)
    80000282:	e022                	sd	s0,0(sp)
    80000284:	0800                	addi	s0,sp,16
  return refcount[PA2IDX(pa)];
    80000286:	800007b7          	lui	a5,0x80000
    8000028a:	953e                	add	a0,a0,a5
    8000028c:	8131                	srli	a0,a0,0xc
    8000028e:	050a                	slli	a0,a0,0x2
    80000290:	00007797          	auipc	a5,0x7
    80000294:	68078793          	addi	a5,a5,1664 # 80007910 <refcount>
    80000298:	97aa                	add	a5,a5,a0
}
    8000029a:	4388                	lw	a0,0(a5)
    8000029c:	60a2                	ld	ra,8(sp)
    8000029e:	6402                	ld	s0,0(sp)
    800002a0:	0141                	addi	sp,sp,16
    800002a2:	8082                	ret

00000000800002a4 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    800002a4:	1141                	addi	sp,sp,-16
    800002a6:	e406                	sd	ra,8(sp)
    800002a8:	e022                	sd	s0,0(sp)
    800002aa:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    800002ac:	ca19                	beqz	a2,800002c2 <memset+0x1e>
    800002ae:	87aa                	mv	a5,a0
    800002b0:	1602                	slli	a2,a2,0x20
    800002b2:	9201                	srli	a2,a2,0x20
    800002b4:	00a60733          	add	a4,a2,a0
    cdst[i] = c;
    800002b8:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    800002bc:	0785                	addi	a5,a5,1
    800002be:	fee79de3          	bne	a5,a4,800002b8 <memset+0x14>
  }
  return dst;
}
    800002c2:	60a2                	ld	ra,8(sp)
    800002c4:	6402                	ld	s0,0(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e406                	sd	ra,8(sp)
    800002ce:	e022                	sd	s0,0(sp)
    800002d0:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800002d2:	c61d                	beqz	a2,80000300 <memcmp+0x36>
    800002d4:	1602                	slli	a2,a2,0x20
    800002d6:	9201                	srli	a2,a2,0x20
    800002d8:	00c506b3          	add	a3,a0,a2
    if(*s1 != *s2)
    800002dc:	00054783          	lbu	a5,0(a0)
    800002e0:	0005c703          	lbu	a4,0(a1)
    800002e4:	00e79863          	bne	a5,a4,800002f4 <memcmp+0x2a>
      return *s1 - *s2;
    s1++, s2++;
    800002e8:	0505                	addi	a0,a0,1
    800002ea:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800002ec:	fed518e3          	bne	a0,a3,800002dc <memcmp+0x12>
  }

  return 0;
    800002f0:	4501                	li	a0,0
    800002f2:	a019                	j	800002f8 <memcmp+0x2e>
      return *s1 - *s2;
    800002f4:	40e7853b          	subw	a0,a5,a4
}
    800002f8:	60a2                	ld	ra,8(sp)
    800002fa:	6402                	ld	s0,0(sp)
    800002fc:	0141                	addi	sp,sp,16
    800002fe:	8082                	ret
  return 0;
    80000300:	4501                	li	a0,0
    80000302:	bfdd                	j	800002f8 <memcmp+0x2e>

0000000080000304 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    80000304:	1141                	addi	sp,sp,-16
    80000306:	e406                	sd	ra,8(sp)
    80000308:	e022                	sd	s0,0(sp)
    8000030a:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    8000030c:	c205                	beqz	a2,8000032c <memmove+0x28>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    8000030e:	02a5e363          	bltu	a1,a0,80000334 <memmove+0x30>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    80000312:	1602                	slli	a2,a2,0x20
    80000314:	9201                	srli	a2,a2,0x20
    80000316:	00c587b3          	add	a5,a1,a2
{
    8000031a:	872a                	mv	a4,a0
      *d++ = *s++;
    8000031c:	0585                	addi	a1,a1,1
    8000031e:	0705                	addi	a4,a4,1
    80000320:	fff5c683          	lbu	a3,-1(a1)
    80000324:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    80000328:	feb79ae3          	bne	a5,a1,8000031c <memmove+0x18>

  return dst;
}
    8000032c:	60a2                	ld	ra,8(sp)
    8000032e:	6402                	ld	s0,0(sp)
    80000330:	0141                	addi	sp,sp,16
    80000332:	8082                	ret
  if(s < d && s + n > d){
    80000334:	02061693          	slli	a3,a2,0x20
    80000338:	9281                	srli	a3,a3,0x20
    8000033a:	00d58733          	add	a4,a1,a3
    8000033e:	fce57ae3          	bgeu	a0,a4,80000312 <memmove+0xe>
    d += n;
    80000342:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000344:	fff6079b          	addiw	a5,a2,-1 # fff <_entry-0x7ffff001>
    80000348:	1782                	slli	a5,a5,0x20
    8000034a:	9381                	srli	a5,a5,0x20
    8000034c:	fff7c793          	not	a5,a5
    80000350:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000352:	177d                	addi	a4,a4,-1
    80000354:	16fd                	addi	a3,a3,-1
    80000356:	00074603          	lbu	a2,0(a4)
    8000035a:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    8000035e:	fee79ae3          	bne	a5,a4,80000352 <memmove+0x4e>
    80000362:	b7e9                	j	8000032c <memmove+0x28>

0000000080000364 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000364:	1141                	addi	sp,sp,-16
    80000366:	e406                	sd	ra,8(sp)
    80000368:	e022                	sd	s0,0(sp)
    8000036a:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    8000036c:	f99ff0ef          	jal	80000304 <memmove>
}
    80000370:	60a2                	ld	ra,8(sp)
    80000372:	6402                	ld	s0,0(sp)
    80000374:	0141                	addi	sp,sp,16
    80000376:	8082                	ret

0000000080000378 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000378:	1141                	addi	sp,sp,-16
    8000037a:	e406                	sd	ra,8(sp)
    8000037c:	e022                	sd	s0,0(sp)
    8000037e:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000380:	ce11                	beqz	a2,8000039c <strncmp+0x24>
    80000382:	00054783          	lbu	a5,0(a0)
    80000386:	cf89                	beqz	a5,800003a0 <strncmp+0x28>
    80000388:	0005c703          	lbu	a4,0(a1)
    8000038c:	00f71a63          	bne	a4,a5,800003a0 <strncmp+0x28>
    n--, p++, q++;
    80000390:	367d                	addiw	a2,a2,-1
    80000392:	0505                	addi	a0,a0,1
    80000394:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    80000396:	f675                	bnez	a2,80000382 <strncmp+0xa>
  if(n == 0)
    return 0;
    80000398:	4501                	li	a0,0
    8000039a:	a801                	j	800003aa <strncmp+0x32>
    8000039c:	4501                	li	a0,0
    8000039e:	a031                	j	800003aa <strncmp+0x32>
  return (uchar)*p - (uchar)*q;
    800003a0:	00054503          	lbu	a0,0(a0)
    800003a4:	0005c783          	lbu	a5,0(a1)
    800003a8:	9d1d                	subw	a0,a0,a5
}
    800003aa:	60a2                	ld	ra,8(sp)
    800003ac:	6402                	ld	s0,0(sp)
    800003ae:	0141                	addi	sp,sp,16
    800003b0:	8082                	ret

00000000800003b2 <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    800003b2:	1141                	addi	sp,sp,-16
    800003b4:	e406                	sd	ra,8(sp)
    800003b6:	e022                	sd	s0,0(sp)
    800003b8:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    800003ba:	87aa                	mv	a5,a0
    800003bc:	a011                	j	800003c0 <strncpy+0xe>
    800003be:	8636                	mv	a2,a3
    800003c0:	02c05863          	blez	a2,800003f0 <strncpy+0x3e>
    800003c4:	fff6069b          	addiw	a3,a2,-1
    800003c8:	8836                	mv	a6,a3
    800003ca:	0785                	addi	a5,a5,1
    800003cc:	0005c703          	lbu	a4,0(a1)
    800003d0:	fee78fa3          	sb	a4,-1(a5)
    800003d4:	0585                	addi	a1,a1,1
    800003d6:	f765                	bnez	a4,800003be <strncpy+0xc>
    ;
  while(n-- > 0)
    800003d8:	873e                	mv	a4,a5
    800003da:	01005b63          	blez	a6,800003f0 <strncpy+0x3e>
    800003de:	9fb1                	addw	a5,a5,a2
    800003e0:	37fd                	addiw	a5,a5,-1
    *s++ = 0;
    800003e2:	0705                	addi	a4,a4,1
    800003e4:	fe070fa3          	sb	zero,-1(a4)
  while(n-- > 0)
    800003e8:	40e786bb          	subw	a3,a5,a4
    800003ec:	fed04be3          	bgtz	a3,800003e2 <strncpy+0x30>
  return os;
}
    800003f0:	60a2                	ld	ra,8(sp)
    800003f2:	6402                	ld	s0,0(sp)
    800003f4:	0141                	addi	sp,sp,16
    800003f6:	8082                	ret

00000000800003f8 <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800003f8:	1141                	addi	sp,sp,-16
    800003fa:	e406                	sd	ra,8(sp)
    800003fc:	e022                	sd	s0,0(sp)
    800003fe:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    80000400:	02c05363          	blez	a2,80000426 <safestrcpy+0x2e>
    80000404:	fff6069b          	addiw	a3,a2,-1
    80000408:	1682                	slli	a3,a3,0x20
    8000040a:	9281                	srli	a3,a3,0x20
    8000040c:	96ae                	add	a3,a3,a1
    8000040e:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    80000410:	00d58963          	beq	a1,a3,80000422 <safestrcpy+0x2a>
    80000414:	0585                	addi	a1,a1,1
    80000416:	0785                	addi	a5,a5,1
    80000418:	fff5c703          	lbu	a4,-1(a1)
    8000041c:	fee78fa3          	sb	a4,-1(a5)
    80000420:	fb65                	bnez	a4,80000410 <safestrcpy+0x18>
    ;
  *s = 0;
    80000422:	00078023          	sb	zero,0(a5)
  return os;
}
    80000426:	60a2                	ld	ra,8(sp)
    80000428:	6402                	ld	s0,0(sp)
    8000042a:	0141                	addi	sp,sp,16
    8000042c:	8082                	ret

000000008000042e <strlen>:

int
strlen(const char *s)
{
    8000042e:	1141                	addi	sp,sp,-16
    80000430:	e406                	sd	ra,8(sp)
    80000432:	e022                	sd	s0,0(sp)
    80000434:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000436:	00054783          	lbu	a5,0(a0)
    8000043a:	cf91                	beqz	a5,80000456 <strlen+0x28>
    8000043c:	00150793          	addi	a5,a0,1
    80000440:	86be                	mv	a3,a5
    80000442:	0785                	addi	a5,a5,1
    80000444:	fff7c703          	lbu	a4,-1(a5)
    80000448:	ff65                	bnez	a4,80000440 <strlen+0x12>
    8000044a:	40a6853b          	subw	a0,a3,a0
    ;
  return n;
}
    8000044e:	60a2                	ld	ra,8(sp)
    80000450:	6402                	ld	s0,0(sp)
    80000452:	0141                	addi	sp,sp,16
    80000454:	8082                	ret
  for(n = 0; s[n]; n++)
    80000456:	4501                	li	a0,0
    80000458:	bfdd                	j	8000044e <strlen+0x20>

000000008000045a <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    8000045a:	1141                	addi	sp,sp,-16
    8000045c:	e406                	sd	ra,8(sp)
    8000045e:	e022                	sd	s0,0(sp)
    80000460:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80000462:	399000ef          	jal	80000ffa <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000466:	00007717          	auipc	a4,0x7
    8000046a:	45a70713          	addi	a4,a4,1114 # 800078c0 <started>
  if(cpuid() == 0){
    8000046e:	c51d                	beqz	a0,8000049c <main+0x42>
    while(started == 0)
    80000470:	431c                	lw	a5,0(a4)
    80000472:	2781                	sext.w	a5,a5
    80000474:	dff5                	beqz	a5,80000470 <main+0x16>
      ;
    __sync_synchronize();
    80000476:	0330000f          	fence	rw,rw
    printf("hart %d starting\n", cpuid());
    8000047a:	381000ef          	jal	80000ffa <cpuid>
    8000047e:	85aa                	mv	a1,a0
    80000480:	00007517          	auipc	a0,0x7
    80000484:	c1050513          	addi	a0,a0,-1008 # 80007090 <etext+0x90>
    80000488:	134050ef          	jal	800055bc <printf>
    kvminithart();    // turn on paging
    8000048c:	080000ef          	jal	8000050c <kvminithart>
    trapinithart();   // install kernel trap vector
    80000490:	6bc010ef          	jal	80001b4c <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000494:	6d4040ef          	jal	80004b68 <plicinithart>
  }

  scheduler();        
    80000498:	7fb000ef          	jal	80001492 <scheduler>
    consoleinit();
    8000049c:	046050ef          	jal	800054e2 <consoleinit>
    printfinit();
    800004a0:	446050ef          	jal	800058e6 <printfinit>
    printf("\n");
    800004a4:	00007517          	auipc	a0,0x7
    800004a8:	bcc50513          	addi	a0,a0,-1076 # 80007070 <etext+0x70>
    800004ac:	110050ef          	jal	800055bc <printf>
    printf("xv6 kernel is booting\n");
    800004b0:	00007517          	auipc	a0,0x7
    800004b4:	bc850513          	addi	a0,a0,-1080 # 80007078 <etext+0x78>
    800004b8:	104050ef          	jal	800055bc <printf>
    printf("\n");
    800004bc:	00007517          	auipc	a0,0x7
    800004c0:	bb450513          	addi	a0,a0,-1100 # 80007070 <etext+0x70>
    800004c4:	0f8050ef          	jal	800055bc <printf>
    kinit();         // physical page allocator
    800004c8:	c9bff0ef          	jal	80000162 <kinit>
    kvminit();       // create kernel page table
    800004cc:	2cc000ef          	jal	80000798 <kvminit>
    kvminithart();   // turn on paging
    800004d0:	03c000ef          	jal	8000050c <kvminithart>
    procinit();      // process table
    800004d4:	271000ef          	jal	80000f44 <procinit>
    trapinit();      // trap vectors
    800004d8:	650010ef          	jal	80001b28 <trapinit>
    trapinithart();  // install kernel trap vector
    800004dc:	670010ef          	jal	80001b4c <trapinithart>
    plicinit();      // set up interrupt controller
    800004e0:	66e040ef          	jal	80004b4e <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800004e4:	684040ef          	jal	80004b68 <plicinithart>
    binit();         // buffer cache
    800004e8:	501010ef          	jal	800021e8 <binit>
    iinit();         // inode table
    800004ec:	252020ef          	jal	8000273e <iinit>
    fileinit();      // file table
    800004f0:	17e030ef          	jal	8000366e <fileinit>
    virtio_disk_init(); // emulated hard disk
    800004f4:	764040ef          	jal	80004c58 <virtio_disk_init>
    userinit();      // first user process
    800004f8:	601000ef          	jal	800012f8 <userinit>
    __sync_synchronize();
    800004fc:	0330000f          	fence	rw,rw
    started = 1;
    80000500:	4785                	li	a5,1
    80000502:	00007717          	auipc	a4,0x7
    80000506:	3af72f23          	sw	a5,958(a4) # 800078c0 <started>
    8000050a:	b779                	j	80000498 <main+0x3e>

000000008000050c <kvminithart>:

// Switch the current CPU's h/w page table register to
// the kernel's page table, and enable paging.
void
kvminithart()
{
    8000050c:	1141                	addi	sp,sp,-16
    8000050e:	e406                	sd	ra,8(sp)
    80000510:	e022                	sd	s0,0(sp)
    80000512:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000514:	12000073          	sfence.vma
  // wait for any previous writes to the page table memory to finish.
  sfence_vma();

  w_satp(MAKE_SATP(kernel_pagetable));
    80000518:	00007797          	auipc	a5,0x7
    8000051c:	3b07b783          	ld	a5,944(a5) # 800078c8 <kernel_pagetable>
    80000520:	83b1                	srli	a5,a5,0xc
    80000522:	577d                	li	a4,-1
    80000524:	177e                	slli	a4,a4,0x3f
    80000526:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000528:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000052c:	12000073          	sfence.vma

  // flush stale entries from the TLB.
  sfence_vma();
}
    80000530:	60a2                	ld	ra,8(sp)
    80000532:	6402                	ld	s0,0(sp)
    80000534:	0141                	addi	sp,sp,16
    80000536:	8082                	ret

0000000080000538 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000538:	7139                	addi	sp,sp,-64
    8000053a:	fc06                	sd	ra,56(sp)
    8000053c:	f822                	sd	s0,48(sp)
    8000053e:	f426                	sd	s1,40(sp)
    80000540:	f04a                	sd	s2,32(sp)
    80000542:	ec4e                	sd	s3,24(sp)
    80000544:	e852                	sd	s4,16(sp)
    80000546:	e456                	sd	s5,8(sp)
    80000548:	e05a                	sd	s6,0(sp)
    8000054a:	0080                	addi	s0,sp,64
    8000054c:	84aa                	mv	s1,a0
    8000054e:	89ae                	mv	s3,a1
    80000550:	8b32                	mv	s6,a2
  if(va >= MAXVA)
    80000552:	57fd                	li	a5,-1
    80000554:	83e9                	srli	a5,a5,0x1a
    80000556:	4a79                	li	s4,30
    panic("walk");

  for(int level = 2; level > 0; level--) {
    80000558:	4ab1                	li	s5,12
  if(va >= MAXVA)
    8000055a:	04b7e263          	bltu	a5,a1,8000059e <walk+0x66>
    pte_t *pte = &pagetable[PX(level, va)];
    8000055e:	0149d933          	srl	s2,s3,s4
    80000562:	1ff97913          	andi	s2,s2,511
    80000566:	090e                	slli	s2,s2,0x3
    80000568:	9926                	add	s2,s2,s1
    if(*pte & PTE_V) {
    8000056a:	00093483          	ld	s1,0(s2)
    8000056e:	0014f793          	andi	a5,s1,1
    80000572:	cf85                	beqz	a5,800005aa <walk+0x72>
      pagetable = (pagetable_t)PTE2PA(*pte);
    80000574:	80a9                	srli	s1,s1,0xa
    80000576:	04b2                	slli	s1,s1,0xc
  for(int level = 2; level > 0; level--) {
    80000578:	3a5d                	addiw	s4,s4,-9
    8000057a:	ff5a12e3          	bne	s4,s5,8000055e <walk+0x26>
        return 0;
      memset(pagetable, 0, PGSIZE);
      *pte = PA2PTE(pagetable) | PTE_V;
    }
  }
  return &pagetable[PX(0, va)];
    8000057e:	00c9d513          	srli	a0,s3,0xc
    80000582:	1ff57513          	andi	a0,a0,511
    80000586:	050e                	slli	a0,a0,0x3
    80000588:	9526                	add	a0,a0,s1
}
    8000058a:	70e2                	ld	ra,56(sp)
    8000058c:	7442                	ld	s0,48(sp)
    8000058e:	74a2                	ld	s1,40(sp)
    80000590:	7902                	ld	s2,32(sp)
    80000592:	69e2                	ld	s3,24(sp)
    80000594:	6a42                	ld	s4,16(sp)
    80000596:	6aa2                	ld	s5,8(sp)
    80000598:	6b02                	ld	s6,0(sp)
    8000059a:	6121                	addi	sp,sp,64
    8000059c:	8082                	ret
    panic("walk");
    8000059e:	00007517          	auipc	a0,0x7
    800005a2:	b0a50513          	addi	a0,a0,-1270 # 800070a8 <etext+0xa8>
    800005a6:	3c2050ef          	jal	80005968 <panic>
      if(!alloc || (pagetable = (pde_t*)kalloc()) == 0)
    800005aa:	020b0263          	beqz	s6,800005ce <walk+0x96>
    800005ae:	be9ff0ef          	jal	80000196 <kalloc>
    800005b2:	84aa                	mv	s1,a0
    800005b4:	d979                	beqz	a0,8000058a <walk+0x52>
      memset(pagetable, 0, PGSIZE);
    800005b6:	6605                	lui	a2,0x1
    800005b8:	4581                	li	a1,0
    800005ba:	cebff0ef          	jal	800002a4 <memset>
      *pte = PA2PTE(pagetable) | PTE_V;
    800005be:	00c4d793          	srli	a5,s1,0xc
    800005c2:	07aa                	slli	a5,a5,0xa
    800005c4:	0017e793          	ori	a5,a5,1
    800005c8:	00f93023          	sd	a5,0(s2)
    800005cc:	b775                	j	80000578 <walk+0x40>
        return 0;
    800005ce:	4501                	li	a0,0
    800005d0:	bf6d                	j	8000058a <walk+0x52>

00000000800005d2 <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
  pte_t *pte;
  uint64 pa;

  if(va >= MAXVA)
    800005d2:	57fd                	li	a5,-1
    800005d4:	83e9                	srli	a5,a5,0x1a
    800005d6:	00b7f463          	bgeu	a5,a1,800005de <walkaddr+0xc>
    return 0;
    800005da:	4501                	li	a0,0
    return 0;
  if((*pte & PTE_U) == 0)
    return 0;
  pa = PTE2PA(*pte);
  return pa;
}
    800005dc:	8082                	ret
{
    800005de:	1141                	addi	sp,sp,-16
    800005e0:	e406                	sd	ra,8(sp)
    800005e2:	e022                	sd	s0,0(sp)
    800005e4:	0800                	addi	s0,sp,16
  pte = walk(pagetable, va, 0);
    800005e6:	4601                	li	a2,0
    800005e8:	f51ff0ef          	jal	80000538 <walk>
  if(pte == 0)
    800005ec:	c901                	beqz	a0,800005fc <walkaddr+0x2a>
  if((*pte & PTE_V) == 0)
    800005ee:	611c                	ld	a5,0(a0)
  if((*pte & PTE_U) == 0)
    800005f0:	0117f693          	andi	a3,a5,17
    800005f4:	4745                	li	a4,17
    return 0;
    800005f6:	4501                	li	a0,0
  if((*pte & PTE_U) == 0)
    800005f8:	00e68663          	beq	a3,a4,80000604 <walkaddr+0x32>
}
    800005fc:	60a2                	ld	ra,8(sp)
    800005fe:	6402                	ld	s0,0(sp)
    80000600:	0141                	addi	sp,sp,16
    80000602:	8082                	ret
  pa = PTE2PA(*pte);
    80000604:	83a9                	srli	a5,a5,0xa
    80000606:	00c79513          	slli	a0,a5,0xc
  return pa;
    8000060a:	bfcd                	j	800005fc <walkaddr+0x2a>

000000008000060c <mappages>:
// va and size MUST be page-aligned.
// Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int
mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000060c:	715d                	addi	sp,sp,-80
    8000060e:	e486                	sd	ra,72(sp)
    80000610:	e0a2                	sd	s0,64(sp)
    80000612:	fc26                	sd	s1,56(sp)
    80000614:	f84a                	sd	s2,48(sp)
    80000616:	f44e                	sd	s3,40(sp)
    80000618:	f052                	sd	s4,32(sp)
    8000061a:	ec56                	sd	s5,24(sp)
    8000061c:	e85a                	sd	s6,16(sp)
    8000061e:	e45e                	sd	s7,8(sp)
    80000620:	0880                	addi	s0,sp,80
  uint64 a, last;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    80000622:	03459793          	slli	a5,a1,0x34
    80000626:	eba1                	bnez	a5,80000676 <mappages+0x6a>
    80000628:	8a2a                	mv	s4,a0
    8000062a:	8aba                	mv	s5,a4
    panic("mappages: va not aligned");

  if((size % PGSIZE) != 0)
    8000062c:	03461793          	slli	a5,a2,0x34
    80000630:	eba9                	bnez	a5,80000682 <mappages+0x76>
    panic("mappages: size not aligned");

  if(size == 0)
    80000632:	ce31                	beqz	a2,8000068e <mappages+0x82>
    panic("mappages: size");
  
  a = va;
  last = va + size - PGSIZE;
    80000634:	80060613          	addi	a2,a2,-2048 # 800 <_entry-0x7ffff800>
    80000638:	80060613          	addi	a2,a2,-2048
    8000063c:	00b60933          	add	s2,a2,a1
  a = va;
    80000640:	84ae                	mv	s1,a1
  for(;;){
    if((pte = walk(pagetable, a, 1)) == 0)
    80000642:	4b05                	li	s6,1
    80000644:	40b689b3          	sub	s3,a3,a1
    if(*pte & PTE_V)
      panic("mappages: remap");
    *pte = PA2PTE(pa) | perm | PTE_V;
    if(a == last)
      break;
    a += PGSIZE;
    80000648:	6b85                	lui	s7,0x1
    if((pte = walk(pagetable, a, 1)) == 0)
    8000064a:	865a                	mv	a2,s6
    8000064c:	85a6                	mv	a1,s1
    8000064e:	8552                	mv	a0,s4
    80000650:	ee9ff0ef          	jal	80000538 <walk>
    80000654:	c929                	beqz	a0,800006a6 <mappages+0x9a>
    if(*pte & PTE_V)
    80000656:	611c                	ld	a5,0(a0)
    80000658:	8b85                	andi	a5,a5,1
    8000065a:	e3a1                	bnez	a5,8000069a <mappages+0x8e>
    *pte = PA2PTE(pa) | perm | PTE_V;
    8000065c:	013487b3          	add	a5,s1,s3
    80000660:	83b1                	srli	a5,a5,0xc
    80000662:	07aa                	slli	a5,a5,0xa
    80000664:	0157e7b3          	or	a5,a5,s5
    80000668:	0017e793          	ori	a5,a5,1
    8000066c:	e11c                	sd	a5,0(a0)
    if(a == last)
    8000066e:	05248863          	beq	s1,s2,800006be <mappages+0xb2>
    a += PGSIZE;
    80000672:	94de                	add	s1,s1,s7
    if((pte = walk(pagetable, a, 1)) == 0)
    80000674:	bfd9                	j	8000064a <mappages+0x3e>
    panic("mappages: va not aligned");
    80000676:	00007517          	auipc	a0,0x7
    8000067a:	a3a50513          	addi	a0,a0,-1478 # 800070b0 <etext+0xb0>
    8000067e:	2ea050ef          	jal	80005968 <panic>
    panic("mappages: size not aligned");
    80000682:	00007517          	auipc	a0,0x7
    80000686:	a4e50513          	addi	a0,a0,-1458 # 800070d0 <etext+0xd0>
    8000068a:	2de050ef          	jal	80005968 <panic>
    panic("mappages: size");
    8000068e:	00007517          	auipc	a0,0x7
    80000692:	a6250513          	addi	a0,a0,-1438 # 800070f0 <etext+0xf0>
    80000696:	2d2050ef          	jal	80005968 <panic>
      panic("mappages: remap");
    8000069a:	00007517          	auipc	a0,0x7
    8000069e:	a6650513          	addi	a0,a0,-1434 # 80007100 <etext+0x100>
    800006a2:	2c6050ef          	jal	80005968 <panic>
      return -1;
    800006a6:	557d                	li	a0,-1
    pa += PGSIZE;
  }
  return 0;
}
    800006a8:	60a6                	ld	ra,72(sp)
    800006aa:	6406                	ld	s0,64(sp)
    800006ac:	74e2                	ld	s1,56(sp)
    800006ae:	7942                	ld	s2,48(sp)
    800006b0:	79a2                	ld	s3,40(sp)
    800006b2:	7a02                	ld	s4,32(sp)
    800006b4:	6ae2                	ld	s5,24(sp)
    800006b6:	6b42                	ld	s6,16(sp)
    800006b8:	6ba2                	ld	s7,8(sp)
    800006ba:	6161                	addi	sp,sp,80
    800006bc:	8082                	ret
  return 0;
    800006be:	4501                	li	a0,0
    800006c0:	b7e5                	j	800006a8 <mappages+0x9c>

00000000800006c2 <kvmmap>:
{
    800006c2:	1141                	addi	sp,sp,-16
    800006c4:	e406                	sd	ra,8(sp)
    800006c6:	e022                	sd	s0,0(sp)
    800006c8:	0800                	addi	s0,sp,16
    800006ca:	87b6                	mv	a5,a3
  if(mappages(kpgtbl, va, sz, pa, perm) != 0)
    800006cc:	86b2                	mv	a3,a2
    800006ce:	863e                	mv	a2,a5
    800006d0:	f3dff0ef          	jal	8000060c <mappages>
    800006d4:	e509                	bnez	a0,800006de <kvmmap+0x1c>
}
    800006d6:	60a2                	ld	ra,8(sp)
    800006d8:	6402                	ld	s0,0(sp)
    800006da:	0141                	addi	sp,sp,16
    800006dc:	8082                	ret
    panic("kvmmap");
    800006de:	00007517          	auipc	a0,0x7
    800006e2:	a3250513          	addi	a0,a0,-1486 # 80007110 <etext+0x110>
    800006e6:	282050ef          	jal	80005968 <panic>

00000000800006ea <kvmmake>:
{
    800006ea:	1101                	addi	sp,sp,-32
    800006ec:	ec06                	sd	ra,24(sp)
    800006ee:	e822                	sd	s0,16(sp)
    800006f0:	e426                	sd	s1,8(sp)
    800006f2:	1000                	addi	s0,sp,32
  kpgtbl = (pagetable_t) kalloc();
    800006f4:	aa3ff0ef          	jal	80000196 <kalloc>
    800006f8:	84aa                	mv	s1,a0
  memset(kpgtbl, 0, PGSIZE);
    800006fa:	6605                	lui	a2,0x1
    800006fc:	4581                	li	a1,0
    800006fe:	ba7ff0ef          	jal	800002a4 <memset>
  kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000702:	4719                	li	a4,6
    80000704:	6685                	lui	a3,0x1
    80000706:	10000637          	lui	a2,0x10000
    8000070a:	85b2                	mv	a1,a2
    8000070c:	8526                	mv	a0,s1
    8000070e:	fb5ff0ef          	jal	800006c2 <kvmmap>
  kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000712:	4719                	li	a4,6
    80000714:	6685                	lui	a3,0x1
    80000716:	10001637          	lui	a2,0x10001
    8000071a:	85b2                	mv	a1,a2
    8000071c:	8526                	mv	a0,s1
    8000071e:	fa5ff0ef          	jal	800006c2 <kvmmap>
  kvmmap(kpgtbl, PLIC, PLIC, 0x4000000, PTE_R | PTE_W);
    80000722:	4719                	li	a4,6
    80000724:	040006b7          	lui	a3,0x4000
    80000728:	0c000637          	lui	a2,0xc000
    8000072c:	85b2                	mv	a1,a2
    8000072e:	8526                	mv	a0,s1
    80000730:	f93ff0ef          	jal	800006c2 <kvmmap>
  kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext-KERNBASE, PTE_R | PTE_X);
    80000734:	4729                	li	a4,10
    80000736:	80007697          	auipc	a3,0x80007
    8000073a:	8ca68693          	addi	a3,a3,-1846 # 7000 <_entry-0x7fff9000>
    8000073e:	4605                	li	a2,1
    80000740:	067e                	slli	a2,a2,0x1f
    80000742:	85b2                	mv	a1,a2
    80000744:	8526                	mv	a0,s1
    80000746:	f7dff0ef          	jal	800006c2 <kvmmap>
  kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP-(uint64)etext, PTE_R | PTE_W);
    8000074a:	4719                	li	a4,6
    8000074c:	00007697          	auipc	a3,0x7
    80000750:	8b468693          	addi	a3,a3,-1868 # 80007000 <etext>
    80000754:	47c5                	li	a5,17
    80000756:	07ee                	slli	a5,a5,0x1b
    80000758:	40d786b3          	sub	a3,a5,a3
    8000075c:	00007617          	auipc	a2,0x7
    80000760:	8a460613          	addi	a2,a2,-1884 # 80007000 <etext>
    80000764:	85b2                	mv	a1,a2
    80000766:	8526                	mv	a0,s1
    80000768:	f5bff0ef          	jal	800006c2 <kvmmap>
  kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    8000076c:	4729                	li	a4,10
    8000076e:	6685                	lui	a3,0x1
    80000770:	00006617          	auipc	a2,0x6
    80000774:	89060613          	addi	a2,a2,-1904 # 80006000 <_trampoline>
    80000778:	040005b7          	lui	a1,0x4000
    8000077c:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    8000077e:	05b2                	slli	a1,a1,0xc
    80000780:	8526                	mv	a0,s1
    80000782:	f41ff0ef          	jal	800006c2 <kvmmap>
  proc_mapstacks(kpgtbl);
    80000786:	8526                	mv	a0,s1
    80000788:	718000ef          	jal	80000ea0 <proc_mapstacks>
}
    8000078c:	8526                	mv	a0,s1
    8000078e:	60e2                	ld	ra,24(sp)
    80000790:	6442                	ld	s0,16(sp)
    80000792:	64a2                	ld	s1,8(sp)
    80000794:	6105                	addi	sp,sp,32
    80000796:	8082                	ret

0000000080000798 <kvminit>:
{
    80000798:	1141                	addi	sp,sp,-16
    8000079a:	e406                	sd	ra,8(sp)
    8000079c:	e022                	sd	s0,0(sp)
    8000079e:	0800                	addi	s0,sp,16
  kernel_pagetable = kvmmake();
    800007a0:	f4bff0ef          	jal	800006ea <kvmmake>
    800007a4:	00007797          	auipc	a5,0x7
    800007a8:	12a7b223          	sd	a0,292(a5) # 800078c8 <kernel_pagetable>
}
    800007ac:	60a2                	ld	ra,8(sp)
    800007ae:	6402                	ld	s0,0(sp)
    800007b0:	0141                	addi	sp,sp,16
    800007b2:	8082                	ret

00000000800007b4 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007b4:	1101                	addi	sp,sp,-32
    800007b6:	ec06                	sd	ra,24(sp)
    800007b8:	e822                	sd	s0,16(sp)
    800007ba:	e426                	sd	s1,8(sp)
    800007bc:	1000                	addi	s0,sp,32
  pagetable_t pagetable;
  pagetable = (pagetable_t) kalloc();
    800007be:	9d9ff0ef          	jal	80000196 <kalloc>
    800007c2:	84aa                	mv	s1,a0
  if(pagetable == 0)
    800007c4:	c509                	beqz	a0,800007ce <uvmcreate+0x1a>
    return 0;
  memset(pagetable, 0, PGSIZE);
    800007c6:	6605                	lui	a2,0x1
    800007c8:	4581                	li	a1,0
    800007ca:	adbff0ef          	jal	800002a4 <memset>
  return pagetable;
}
    800007ce:	8526                	mv	a0,s1
    800007d0:	60e2                	ld	ra,24(sp)
    800007d2:	6442                	ld	s0,16(sp)
    800007d4:	64a2                	ld	s1,8(sp)
    800007d6:	6105                	addi	sp,sp,32
    800007d8:	8082                	ret

00000000800007da <uvmunmap>:
// Remove npages of mappings starting from va. va must be
// page-aligned. It's OK if the mappings don't exist.
// Optionally free the physical memory.
void
uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    800007da:	7139                	addi	sp,sp,-64
    800007dc:	fc06                	sd	ra,56(sp)
    800007de:	f822                	sd	s0,48(sp)
    800007e0:	0080                	addi	s0,sp,64
  uint64 a;
  pte_t *pte;

  if((va % PGSIZE) != 0)
    800007e2:	03459793          	slli	a5,a1,0x34
    800007e6:	e38d                	bnez	a5,80000808 <uvmunmap+0x2e>
    800007e8:	f04a                	sd	s2,32(sp)
    800007ea:	ec4e                	sd	s3,24(sp)
    800007ec:	e852                	sd	s4,16(sp)
    800007ee:	e456                	sd	s5,8(sp)
    800007f0:	e05a                	sd	s6,0(sp)
    800007f2:	8a2a                	mv	s4,a0
    800007f4:	892e                	mv	s2,a1
    800007f6:	8ab6                	mv	s5,a3
    panic("uvmunmap: not aligned");

  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    800007f8:	0632                	slli	a2,a2,0xc
    800007fa:	00b609b3          	add	s3,a2,a1
    800007fe:	6b05                	lui	s6,0x1
    80000800:	0535f963          	bgeu	a1,s3,80000852 <uvmunmap+0x78>
    80000804:	f426                	sd	s1,40(sp)
    80000806:	a015                	j	8000082a <uvmunmap+0x50>
    80000808:	f426                	sd	s1,40(sp)
    8000080a:	f04a                	sd	s2,32(sp)
    8000080c:	ec4e                	sd	s3,24(sp)
    8000080e:	e852                	sd	s4,16(sp)
    80000810:	e456                	sd	s5,8(sp)
    80000812:	e05a                	sd	s6,0(sp)
    panic("uvmunmap: not aligned");
    80000814:	00007517          	auipc	a0,0x7
    80000818:	90450513          	addi	a0,a0,-1788 # 80007118 <etext+0x118>
    8000081c:	14c050ef          	jal	80005968 <panic>
      continue;
    if(do_free){
      uint64 pa = PTE2PA(*pte);
      kfree((void*)pa);
    }
    *pte = 0;
    80000820:	0004b023          	sd	zero,0(s1)
  for(a = va; a < va + npages*PGSIZE; a += PGSIZE){
    80000824:	995a                	add	s2,s2,s6
    80000826:	03397563          	bgeu	s2,s3,80000850 <uvmunmap+0x76>
    if((pte = walk(pagetable, a, 0)) == 0) // leaf page table entry allocated?
    8000082a:	4601                	li	a2,0
    8000082c:	85ca                	mv	a1,s2
    8000082e:	8552                	mv	a0,s4
    80000830:	d09ff0ef          	jal	80000538 <walk>
    80000834:	84aa                	mv	s1,a0
    80000836:	d57d                	beqz	a0,80000824 <uvmunmap+0x4a>
    if((*pte & PTE_V) == 0)  // has physical page been allocated?
    80000838:	611c                	ld	a5,0(a0)
    8000083a:	0017f713          	andi	a4,a5,1
    8000083e:	d37d                	beqz	a4,80000824 <uvmunmap+0x4a>
    if(do_free){
    80000840:	fe0a80e3          	beqz	s5,80000820 <uvmunmap+0x46>
      uint64 pa = PTE2PA(*pte);
    80000844:	83a9                	srli	a5,a5,0xa
      kfree((void*)pa);
    80000846:	00c79513          	slli	a0,a5,0xc
    8000084a:	fd2ff0ef          	jal	8000001c <kfree>
    8000084e:	bfc9                	j	80000820 <uvmunmap+0x46>
    80000850:	74a2                	ld	s1,40(sp)
    80000852:	7902                	ld	s2,32(sp)
    80000854:	69e2                	ld	s3,24(sp)
    80000856:	6a42                	ld	s4,16(sp)
    80000858:	6aa2                	ld	s5,8(sp)
    8000085a:	6b02                	ld	s6,0(sp)
  }
}
    8000085c:	70e2                	ld	ra,56(sp)
    8000085e:	7442                	ld	s0,48(sp)
    80000860:	6121                	addi	sp,sp,64
    80000862:	8082                	ret

0000000080000864 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000864:	1101                	addi	sp,sp,-32
    80000866:	ec06                	sd	ra,24(sp)
    80000868:	e822                	sd	s0,16(sp)
    8000086a:	e426                	sd	s1,8(sp)
    8000086c:	1000                	addi	s0,sp,32
  if(newsz >= oldsz)
    return oldsz;
    8000086e:	84ae                	mv	s1,a1
  if(newsz >= oldsz)
    80000870:	00b67d63          	bgeu	a2,a1,8000088a <uvmdealloc+0x26>
    80000874:	84b2                	mv	s1,a2

  if(PGROUNDUP(newsz) < PGROUNDUP(oldsz)){
    80000876:	6785                	lui	a5,0x1
    80000878:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    8000087a:	00f60733          	add	a4,a2,a5
    8000087e:	76fd                	lui	a3,0xfffff
    80000880:	8f75                	and	a4,a4,a3
    80000882:	97ae                	add	a5,a5,a1
    80000884:	8ff5                	and	a5,a5,a3
    80000886:	00f76863          	bltu	a4,a5,80000896 <uvmdealloc+0x32>
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
  }

  return newsz;
}
    8000088a:	8526                	mv	a0,s1
    8000088c:	60e2                	ld	ra,24(sp)
    8000088e:	6442                	ld	s0,16(sp)
    80000890:	64a2                	ld	s1,8(sp)
    80000892:	6105                	addi	sp,sp,32
    80000894:	8082                	ret
    int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    80000896:	8f99                	sub	a5,a5,a4
    80000898:	83b1                	srli	a5,a5,0xc
    uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000089a:	4685                	li	a3,1
    8000089c:	0007861b          	sext.w	a2,a5
    800008a0:	85ba                	mv	a1,a4
    800008a2:	f39ff0ef          	jal	800007da <uvmunmap>
    800008a6:	b7d5                	j	8000088a <uvmdealloc+0x26>

00000000800008a8 <uvmalloc>:
  if(newsz < oldsz)
    800008a8:	0ab66163          	bltu	a2,a1,8000094a <uvmalloc+0xa2>
{
    800008ac:	715d                	addi	sp,sp,-80
    800008ae:	e486                	sd	ra,72(sp)
    800008b0:	e0a2                	sd	s0,64(sp)
    800008b2:	f84a                	sd	s2,48(sp)
    800008b4:	f052                	sd	s4,32(sp)
    800008b6:	ec56                	sd	s5,24(sp)
    800008b8:	e45e                	sd	s7,8(sp)
    800008ba:	0880                	addi	s0,sp,80
    800008bc:	8aaa                	mv	s5,a0
    800008be:	8a32                	mv	s4,a2
  oldsz = PGROUNDUP(oldsz);
    800008c0:	6785                	lui	a5,0x1
    800008c2:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800008c4:	95be                	add	a1,a1,a5
    800008c6:	77fd                	lui	a5,0xfffff
    800008c8:	00f5f933          	and	s2,a1,a5
    800008cc:	8bca                	mv	s7,s2
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008ce:	08c97063          	bgeu	s2,a2,8000094e <uvmalloc+0xa6>
    800008d2:	fc26                	sd	s1,56(sp)
    800008d4:	f44e                	sd	s3,40(sp)
    800008d6:	e85a                	sd	s6,16(sp)
    memset(mem, 0, PGSIZE);
    800008d8:	6985                	lui	s3,0x1
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008da:	0126eb13          	ori	s6,a3,18
    mem = kalloc();
    800008de:	8b9ff0ef          	jal	80000196 <kalloc>
    800008e2:	84aa                	mv	s1,a0
    if(mem == 0){
    800008e4:	c50d                	beqz	a0,8000090e <uvmalloc+0x66>
    memset(mem, 0, PGSIZE);
    800008e6:	864e                	mv	a2,s3
    800008e8:	4581                	li	a1,0
    800008ea:	9bbff0ef          	jal	800002a4 <memset>
    if(mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R|PTE_U|xperm) != 0){
    800008ee:	875a                	mv	a4,s6
    800008f0:	86a6                	mv	a3,s1
    800008f2:	864e                	mv	a2,s3
    800008f4:	85ca                	mv	a1,s2
    800008f6:	8556                	mv	a0,s5
    800008f8:	d15ff0ef          	jal	8000060c <mappages>
    800008fc:	e915                	bnez	a0,80000930 <uvmalloc+0x88>
  for(a = oldsz; a < newsz; a += PGSIZE){
    800008fe:	994e                	add	s2,s2,s3
    80000900:	fd496fe3          	bltu	s2,s4,800008de <uvmalloc+0x36>
  return newsz;
    80000904:	8552                	mv	a0,s4
    80000906:	74e2                	ld	s1,56(sp)
    80000908:	79a2                	ld	s3,40(sp)
    8000090a:	6b42                	ld	s6,16(sp)
    8000090c:	a811                	j	80000920 <uvmalloc+0x78>
      uvmdealloc(pagetable, a, oldsz);
    8000090e:	865e                	mv	a2,s7
    80000910:	85ca                	mv	a1,s2
    80000912:	8556                	mv	a0,s5
    80000914:	f51ff0ef          	jal	80000864 <uvmdealloc>
      return 0;
    80000918:	4501                	li	a0,0
    8000091a:	74e2                	ld	s1,56(sp)
    8000091c:	79a2                	ld	s3,40(sp)
    8000091e:	6b42                	ld	s6,16(sp)
}
    80000920:	60a6                	ld	ra,72(sp)
    80000922:	6406                	ld	s0,64(sp)
    80000924:	7942                	ld	s2,48(sp)
    80000926:	7a02                	ld	s4,32(sp)
    80000928:	6ae2                	ld	s5,24(sp)
    8000092a:	6ba2                	ld	s7,8(sp)
    8000092c:	6161                	addi	sp,sp,80
    8000092e:	8082                	ret
      kfree(mem);
    80000930:	8526                	mv	a0,s1
    80000932:	eeaff0ef          	jal	8000001c <kfree>
      uvmdealloc(pagetable, a, oldsz);
    80000936:	865e                	mv	a2,s7
    80000938:	85ca                	mv	a1,s2
    8000093a:	8556                	mv	a0,s5
    8000093c:	f29ff0ef          	jal	80000864 <uvmdealloc>
      return 0;
    80000940:	4501                	li	a0,0
    80000942:	74e2                	ld	s1,56(sp)
    80000944:	79a2                	ld	s3,40(sp)
    80000946:	6b42                	ld	s6,16(sp)
    80000948:	bfe1                	j	80000920 <uvmalloc+0x78>
    return oldsz;
    8000094a:	852e                	mv	a0,a1
}
    8000094c:	8082                	ret
  return newsz;
    8000094e:	8532                	mv	a0,a2
    80000950:	bfc1                	j	80000920 <uvmalloc+0x78>

0000000080000952 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void
freewalk(pagetable_t pagetable)
{
    80000952:	7179                	addi	sp,sp,-48
    80000954:	f406                	sd	ra,40(sp)
    80000956:	f022                	sd	s0,32(sp)
    80000958:	ec26                	sd	s1,24(sp)
    8000095a:	e84a                	sd	s2,16(sp)
    8000095c:	e44e                	sd	s3,8(sp)
    8000095e:	1800                	addi	s0,sp,48
    80000960:	89aa                	mv	s3,a0
  // there are 2^9 = 512 PTEs in a page table.
  for(int i = 0; i < 512; i++){
    80000962:	84aa                	mv	s1,a0
    80000964:	6905                	lui	s2,0x1
    80000966:	992a                	add	s2,s2,a0
    80000968:	a811                	j	8000097c <freewalk+0x2a>
      // this PTE points to a lower-level page table.
      uint64 child = PTE2PA(pte);
      freewalk((pagetable_t)child);
      pagetable[i] = 0;
    } else if(pte & PTE_V){
      panic("freewalk: leaf");
    8000096a:	00006517          	auipc	a0,0x6
    8000096e:	7c650513          	addi	a0,a0,1990 # 80007130 <etext+0x130>
    80000972:	7f7040ef          	jal	80005968 <panic>
  for(int i = 0; i < 512; i++){
    80000976:	04a1                	addi	s1,s1,8
    80000978:	03248163          	beq	s1,s2,8000099a <freewalk+0x48>
    pte_t pte = pagetable[i];
    8000097c:	609c                	ld	a5,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    8000097e:	0017f713          	andi	a4,a5,1
    80000982:	db75                	beqz	a4,80000976 <freewalk+0x24>
    80000984:	00e7f713          	andi	a4,a5,14
    80000988:	f36d                	bnez	a4,8000096a <freewalk+0x18>
      uint64 child = PTE2PA(pte);
    8000098a:	83a9                	srli	a5,a5,0xa
      freewalk((pagetable_t)child);
    8000098c:	00c79513          	slli	a0,a5,0xc
    80000990:	fc3ff0ef          	jal	80000952 <freewalk>
      pagetable[i] = 0;
    80000994:	0004b023          	sd	zero,0(s1)
    if((pte & PTE_V) && (pte & (PTE_R|PTE_W|PTE_X)) == 0){
    80000998:	bff9                	j	80000976 <freewalk+0x24>
    }
  }
  kfree((void*)pagetable);
    8000099a:	854e                	mv	a0,s3
    8000099c:	e80ff0ef          	jal	8000001c <kfree>
}
    800009a0:	70a2                	ld	ra,40(sp)
    800009a2:	7402                	ld	s0,32(sp)
    800009a4:	64e2                	ld	s1,24(sp)
    800009a6:	6942                	ld	s2,16(sp)
    800009a8:	69a2                	ld	s3,8(sp)
    800009aa:	6145                	addi	sp,sp,48
    800009ac:	8082                	ret

00000000800009ae <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void
uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009ae:	1101                	addi	sp,sp,-32
    800009b0:	ec06                	sd	ra,24(sp)
    800009b2:	e822                	sd	s0,16(sp)
    800009b4:	e426                	sd	s1,8(sp)
    800009b6:	1000                	addi	s0,sp,32
    800009b8:	84aa                	mv	s1,a0
  if(sz > 0)
    800009ba:	e989                	bnez	a1,800009cc <uvmfree+0x1e>
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
  freewalk(pagetable);
    800009bc:	8526                	mv	a0,s1
    800009be:	f95ff0ef          	jal	80000952 <freewalk>
}
    800009c2:	60e2                	ld	ra,24(sp)
    800009c4:	6442                	ld	s0,16(sp)
    800009c6:	64a2                	ld	s1,8(sp)
    800009c8:	6105                	addi	sp,sp,32
    800009ca:	8082                	ret
    uvmunmap(pagetable, 0, PGROUNDUP(sz)/PGSIZE, 1);
    800009cc:	6785                	lui	a5,0x1
    800009ce:	17fd                	addi	a5,a5,-1 # fff <_entry-0x7ffff001>
    800009d0:	95be                	add	a1,a1,a5
    800009d2:	4685                	li	a3,1
    800009d4:	00c5d613          	srli	a2,a1,0xc
    800009d8:	4581                	li	a1,0
    800009da:	e01ff0ef          	jal	800007da <uvmunmap>
    800009de:	bff9                	j	800009bc <uvmfree+0xe>

00000000800009e0 <uvmcopy>:
{
  pte_t *pte;
  uint64 pa, i;
  uint flags;

  for(i = 0; i < sz; i += PGSIZE){
    800009e0:	c665                	beqz	a2,80000ac8 <uvmcopy+0xe8>
{
    800009e2:	7119                	addi	sp,sp,-128
    800009e4:	fc86                	sd	ra,120(sp)
    800009e6:	f8a2                	sd	s0,112(sp)
    800009e8:	f4a6                	sd	s1,104(sp)
    800009ea:	f0ca                	sd	s2,96(sp)
    800009ec:	ecce                	sd	s3,88(sp)
    800009ee:	e8d2                	sd	s4,80(sp)
    800009f0:	e4d6                	sd	s5,72(sp)
    800009f2:	e0da                	sd	s6,64(sp)
    800009f4:	fc5e                	sd	s7,56(sp)
    800009f6:	f862                	sd	s8,48(sp)
    800009f8:	f466                	sd	s9,40(sp)
    800009fa:	f06a                	sd	s10,32(sp)
    800009fc:	ec6e                	sd	s11,24(sp)
    800009fe:	0100                	addi	s0,sp,128
    80000a00:	8caa                	mv	s9,a0
    80000a02:	8d2e                	mv	s10,a1
    80000a04:	8c32                	mv	s8,a2
  for(i = 0; i < sz; i += PGSIZE){
    80000a06:	4901                	li	s2,0
    // update parent PTE to CoW
    // increase reference count
    // Note: we update them after the mapping successed
    // so that only need to clean up child if err
    if((flags & PTE_C) && !(flags & PTE_W)){
      *pte = PA2PTE(pa) | flags;
    80000a08:	77fd                	lui	a5,0xfffff
    80000a0a:	8389                	srli	a5,a5,0x2
    80000a0c:	f8f43423          	sd	a5,-120(s0)
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000a10:	6b85                	lui	s7,0x1
    if((flags & PTE_C) && !(flags & PTE_W)){
    80000a12:	10000d93          	li	s11,256
    80000a16:	a02d                	j	80000a40 <uvmcopy+0x60>
    flags = PTE_FLAGS(*pte);
    80000a18:	3ffafb13          	andi	s6,s5,1023
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000a1c:	875a                	mv	a4,s6
    80000a1e:	86d2                	mv	a3,s4
    80000a20:	865e                	mv	a2,s7
    80000a22:	85ca                	mv	a1,s2
    80000a24:	856a                	mv	a0,s10
    80000a26:	be7ff0ef          	jal	8000060c <mappages>
    80000a2a:	e939                	bnez	a0,80000a80 <uvmcopy+0xa0>
    if((flags & PTE_C) && !(flags & PTE_W)){
    80000a2c:	104afa93          	andi	s5,s5,260
    80000a30:	07ba8163          	beq	s5,s11,80000a92 <uvmcopy+0xb2>
      sfence_vma();
    }
    kincref(pa);
    80000a34:	8552                	mv	a0,s4
    80000a36:	ffeff0ef          	jal	80000234 <kincref>
  for(i = 0; i < sz; i += PGSIZE){
    80000a3a:	995e                	add	s2,s2,s7
    80000a3c:	07897663          	bgeu	s2,s8,80000aa8 <uvmcopy+0xc8>
    if((pte = walk(old, i, 0)) == 0)
    80000a40:	4601                	li	a2,0
    80000a42:	85ca                	mv	a1,s2
    80000a44:	8566                	mv	a0,s9
    80000a46:	af3ff0ef          	jal	80000538 <walk>
    80000a4a:	84aa                	mv	s1,a0
    80000a4c:	d57d                	beqz	a0,80000a3a <uvmcopy+0x5a>
    if((*pte & PTE_V) == 0)
    80000a4e:	00053983          	ld	s3,0(a0)
    80000a52:	0019f793          	andi	a5,s3,1
    80000a56:	d3f5                	beqz	a5,80000a3a <uvmcopy+0x5a>
    pa = PTE2PA(*pte);
    80000a58:	00a9da13          	srli	s4,s3,0xa
    80000a5c:	0a32                	slli	s4,s4,0xc
    flags = PTE_FLAGS(*pte);
    80000a5e:	00098a9b          	sext.w	s5,s3
    if(flags & PTE_W){
    80000a62:	0049f793          	andi	a5,s3,4
    80000a66:	dbcd                	beqz	a5,80000a18 <uvmcopy+0x38>
      flags &= ~PTE_W;
    80000a68:	3fbafb13          	andi	s6,s5,1019
      flags |= PTE_C;
    80000a6c:	100b6b13          	ori	s6,s6,256
    if(mappages(new, i, PGSIZE, (uint64)pa, flags) != 0){
    80000a70:	875a                	mv	a4,s6
    80000a72:	86d2                	mv	a3,s4
    80000a74:	865e                	mv	a2,s7
    80000a76:	85ca                	mv	a1,s2
    80000a78:	856a                	mv	a0,s10
    80000a7a:	b93ff0ef          	jal	8000060c <mappages>
    80000a7e:	c911                	beqz	a0,80000a92 <uvmcopy+0xb2>
  }
  return 0;

 err:
  uvmunmap(new, 0, i / PGSIZE, 1);
    80000a80:	4685                	li	a3,1
    80000a82:	00c95613          	srli	a2,s2,0xc
    80000a86:	4581                	li	a1,0
    80000a88:	856a                	mv	a0,s10
    80000a8a:	d51ff0ef          	jal	800007da <uvmunmap>
  return -1;
    80000a8e:	557d                	li	a0,-1
    80000a90:	a829                	j	80000aaa <uvmcopy+0xca>
      *pte = PA2PTE(pa) | flags;
    80000a92:	f8843783          	ld	a5,-120(s0)
    80000a96:	00f9f9b3          	and	s3,s3,a5
    80000a9a:	013b6b33          	or	s6,s6,s3
    80000a9e:	0164b023          	sd	s6,0(s1)
    80000aa2:	12000073          	sfence.vma
}
    80000aa6:	b779                	j	80000a34 <uvmcopy+0x54>
  return 0;
    80000aa8:	4501                	li	a0,0
}
    80000aaa:	70e6                	ld	ra,120(sp)
    80000aac:	7446                	ld	s0,112(sp)
    80000aae:	74a6                	ld	s1,104(sp)
    80000ab0:	7906                	ld	s2,96(sp)
    80000ab2:	69e6                	ld	s3,88(sp)
    80000ab4:	6a46                	ld	s4,80(sp)
    80000ab6:	6aa6                	ld	s5,72(sp)
    80000ab8:	6b06                	ld	s6,64(sp)
    80000aba:	7be2                	ld	s7,56(sp)
    80000abc:	7c42                	ld	s8,48(sp)
    80000abe:	7ca2                	ld	s9,40(sp)
    80000ac0:	7d02                	ld	s10,32(sp)
    80000ac2:	6de2                	ld	s11,24(sp)
    80000ac4:	6109                	addi	sp,sp,128
    80000ac6:	8082                	ret
  return 0;
    80000ac8:	4501                	li	a0,0
}
    80000aca:	8082                	ret

0000000080000acc <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void
uvmclear(pagetable_t pagetable, uint64 va)
{
    80000acc:	1141                	addi	sp,sp,-16
    80000ace:	e406                	sd	ra,8(sp)
    80000ad0:	e022                	sd	s0,0(sp)
    80000ad2:	0800                	addi	s0,sp,16
  pte_t *pte;
  
  pte = walk(pagetable, va, 0);
    80000ad4:	4601                	li	a2,0
    80000ad6:	a63ff0ef          	jal	80000538 <walk>
  if(pte == 0)
    80000ada:	c901                	beqz	a0,80000aea <uvmclear+0x1e>
    panic("uvmclear");
  *pte &= ~PTE_U;
    80000adc:	611c                	ld	a5,0(a0)
    80000ade:	9bbd                	andi	a5,a5,-17
    80000ae0:	e11c                	sd	a5,0(a0)
}
    80000ae2:	60a2                	ld	ra,8(sp)
    80000ae4:	6402                	ld	s0,0(sp)
    80000ae6:	0141                	addi	sp,sp,16
    80000ae8:	8082                	ret
    panic("uvmclear");
    80000aea:	00006517          	auipc	a0,0x6
    80000aee:	65650513          	addi	a0,a0,1622 # 80007140 <etext+0x140>
    80000af2:	677040ef          	jal	80005968 <panic>

0000000080000af6 <copyinstr>:
copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
  uint64 n, va0, pa0;
  int got_null = 0;

  while(got_null == 0 && max > 0){
    80000af6:	cac5                	beqz	a3,80000ba6 <copyinstr+0xb0>
{
    80000af8:	715d                	addi	sp,sp,-80
    80000afa:	e486                	sd	ra,72(sp)
    80000afc:	e0a2                	sd	s0,64(sp)
    80000afe:	fc26                	sd	s1,56(sp)
    80000b00:	f84a                	sd	s2,48(sp)
    80000b02:	f44e                	sd	s3,40(sp)
    80000b04:	f052                	sd	s4,32(sp)
    80000b06:	ec56                	sd	s5,24(sp)
    80000b08:	e85a                	sd	s6,16(sp)
    80000b0a:	e45e                	sd	s7,8(sp)
    80000b0c:	0880                	addi	s0,sp,80
    80000b0e:	8aaa                	mv	s5,a0
    80000b10:	84ae                	mv	s1,a1
    80000b12:	8bb2                	mv	s7,a2
    80000b14:	89b6                	mv	s3,a3
    va0 = PGROUNDDOWN(srcva);
    80000b16:	7b7d                	lui	s6,0xfffff
    pa0 = walkaddr(pagetable, va0);
    if(pa0 == 0)
      return -1;
    n = PGSIZE - (srcva - va0);
    80000b18:	6a05                	lui	s4,0x1
    80000b1a:	a82d                	j	80000b54 <copyinstr+0x5e>
      n = max;

    char *p = (char *) (pa0 + (srcva - va0));
    while(n > 0){
      if(*p == '\0'){
        *dst = '\0';
    80000b1c:	00078023          	sb	zero,0(a5) # fffffffffffff000 <end+0xffffffff7fdbe408>
        got_null = 1;
    80000b20:	4785                	li	a5,1
      dst++;
    }

    srcva = va0 + PGSIZE;
  }
  if(got_null){
    80000b22:	0017c793          	xori	a5,a5,1
    80000b26:	40f0053b          	negw	a0,a5
    return 0;
  } else {
    return -1;
  }
}
    80000b2a:	60a6                	ld	ra,72(sp)
    80000b2c:	6406                	ld	s0,64(sp)
    80000b2e:	74e2                	ld	s1,56(sp)
    80000b30:	7942                	ld	s2,48(sp)
    80000b32:	79a2                	ld	s3,40(sp)
    80000b34:	7a02                	ld	s4,32(sp)
    80000b36:	6ae2                	ld	s5,24(sp)
    80000b38:	6b42                	ld	s6,16(sp)
    80000b3a:	6ba2                	ld	s7,8(sp)
    80000b3c:	6161                	addi	sp,sp,80
    80000b3e:	8082                	ret
    80000b40:	fff98713          	addi	a4,s3,-1 # fff <_entry-0x7ffff001>
    80000b44:	9726                	add	a4,a4,s1
      --max;
    80000b46:	40b709b3          	sub	s3,a4,a1
    srcva = va0 + PGSIZE;
    80000b4a:	01490bb3          	add	s7,s2,s4
  while(got_null == 0 && max > 0){
    80000b4e:	04e58463          	beq	a1,a4,80000b96 <copyinstr+0xa0>
{
    80000b52:	84be                	mv	s1,a5
    va0 = PGROUNDDOWN(srcva);
    80000b54:	016bf933          	and	s2,s7,s6
    pa0 = walkaddr(pagetable, va0);
    80000b58:	85ca                	mv	a1,s2
    80000b5a:	8556                	mv	a0,s5
    80000b5c:	a77ff0ef          	jal	800005d2 <walkaddr>
    if(pa0 == 0)
    80000b60:	cd0d                	beqz	a0,80000b9a <copyinstr+0xa4>
    n = PGSIZE - (srcva - va0);
    80000b62:	417906b3          	sub	a3,s2,s7
    80000b66:	96d2                	add	a3,a3,s4
    if(n > max)
    80000b68:	00d9f363          	bgeu	s3,a3,80000b6e <copyinstr+0x78>
    80000b6c:	86ce                	mv	a3,s3
    while(n > 0){
    80000b6e:	ca85                	beqz	a3,80000b9e <copyinstr+0xa8>
    char *p = (char *) (pa0 + (srcva - va0));
    80000b70:	01750633          	add	a2,a0,s7
    80000b74:	41260633          	sub	a2,a2,s2
    80000b78:	87a6                	mv	a5,s1
      if(*p == '\0'){
    80000b7a:	8e05                	sub	a2,a2,s1
    while(n > 0){
    80000b7c:	96a6                	add	a3,a3,s1
    80000b7e:	85be                	mv	a1,a5
      if(*p == '\0'){
    80000b80:	00f60733          	add	a4,a2,a5
    80000b84:	00074703          	lbu	a4,0(a4)
    80000b88:	db51                	beqz	a4,80000b1c <copyinstr+0x26>
        *dst = *p;
    80000b8a:	00e78023          	sb	a4,0(a5)
      dst++;
    80000b8e:	0785                	addi	a5,a5,1
    while(n > 0){
    80000b90:	fed797e3          	bne	a5,a3,80000b7e <copyinstr+0x88>
    80000b94:	b775                	j	80000b40 <copyinstr+0x4a>
    80000b96:	4781                	li	a5,0
    80000b98:	b769                	j	80000b22 <copyinstr+0x2c>
      return -1;
    80000b9a:	557d                	li	a0,-1
    80000b9c:	b779                	j	80000b2a <copyinstr+0x34>
    srcva = va0 + PGSIZE;
    80000b9e:	6b85                	lui	s7,0x1
    80000ba0:	9bca                	add	s7,s7,s2
    80000ba2:	87a6                	mv	a5,s1
    80000ba4:	b77d                	j	80000b52 <copyinstr+0x5c>
  int got_null = 0;
    80000ba6:	4781                	li	a5,0
  if(got_null){
    80000ba8:	0017c793          	xori	a5,a5,1
    80000bac:	40f0053b          	negw	a0,a5
}
    80000bb0:	8082                	ret

0000000080000bb2 <ismapped>:
  return mem;
}

int
ismapped(pagetable_t pagetable, uint64 va)
{
    80000bb2:	1141                	addi	sp,sp,-16
    80000bb4:	e406                	sd	ra,8(sp)
    80000bb6:	e022                	sd	s0,0(sp)
    80000bb8:	0800                	addi	s0,sp,16
  pte_t *pte = walk(pagetable, va, 0);
    80000bba:	4601                	li	a2,0
    80000bbc:	97dff0ef          	jal	80000538 <walk>
  if (pte == 0) {
    80000bc0:	c119                	beqz	a0,80000bc6 <ismapped+0x14>
    return 0;
  }
  if (*pte & PTE_V){
    80000bc2:	6108                	ld	a0,0(a0)
    80000bc4:	8905                	andi	a0,a0,1
    return 1;
  }
  return 0;
}
    80000bc6:	60a2                	ld	ra,8(sp)
    80000bc8:	6402                	ld	s0,0(sp)
    80000bca:	0141                	addi	sp,sp,16
    80000bcc:	8082                	ret

0000000080000bce <iscowmapped>:

// Return 1 and set p = pte if the va is COW mapped
// Otherwise, return 0
int
iscowmapped(pagetable_t pagetable, uint64 va, pte_t **p)
{
    80000bce:	1101                	addi	sp,sp,-32
    80000bd0:	ec06                	sd	ra,24(sp)
    80000bd2:	e822                	sd	s0,16(sp)
    80000bd4:	e426                	sd	s1,8(sp)
    80000bd6:	1000                	addi	s0,sp,32
    80000bd8:	84b2                	mv	s1,a2
  pte_t *pte = walk(pagetable, va, 0);
    80000bda:	4601                	li	a2,0
    80000bdc:	95dff0ef          	jal	80000538 <walk>
  if (pte == 0) {
    80000be0:	c115                	beqz	a0,80000c04 <iscowmapped+0x36>
    80000be2:	87aa                	mv	a5,a0
    return 0;
  }
  if (!(*pte & PTE_W) && (*pte & PTE_C) && (*pte & PTE_V)) {
    80000be4:	6118                	ld	a4,0(a0)
    80000be6:	10577713          	andi	a4,a4,261
    80000bea:	10100693          	li	a3,257
    *p = pte;
    return 1;
  }
  return 0;
    80000bee:	4501                	li	a0,0
  if (!(*pte & PTE_W) && (*pte & PTE_C) && (*pte & PTE_V)) {
    80000bf0:	00d70763          	beq	a4,a3,80000bfe <iscowmapped+0x30>
}
    80000bf4:	60e2                	ld	ra,24(sp)
    80000bf6:	6442                	ld	s0,16(sp)
    80000bf8:	64a2                	ld	s1,8(sp)
    80000bfa:	6105                	addi	sp,sp,32
    80000bfc:	8082                	ret
    *p = pte;
    80000bfe:	e09c                	sd	a5,0(s1)
    return 1;
    80000c00:	4505                	li	a0,1
    80000c02:	bfcd                	j	80000bf4 <iscowmapped+0x26>
    return 0;
    80000c04:	4501                	li	a0,0
    80000c06:	b7fd                	j	80000bf4 <iscowmapped+0x26>

0000000080000c08 <vmfault>:
{
    80000c08:	715d                	addi	sp,sp,-80
    80000c0a:	e486                	sd	ra,72(sp)
    80000c0c:	e0a2                	sd	s0,64(sp)
    80000c0e:	fc26                	sd	s1,56(sp)
    80000c10:	f44e                	sd	s3,40(sp)
    80000c12:	f052                	sd	s4,32(sp)
    80000c14:	0880                	addi	s0,sp,80
    80000c16:	89aa                	mv	s3,a0
    80000c18:	84ae                	mv	s1,a1
    80000c1a:	8a32                	mv	s4,a2
  pte_t *pte = 0;
    80000c1c:	fa043c23          	sd	zero,-72(s0)
  struct proc *p = myproc();
    80000c20:	40e000ef          	jal	8000102e <myproc>
  if (va >= p->sz)
    80000c24:	653c                	ld	a5,72(a0)
    80000c26:	0ef4f963          	bgeu	s1,a5,80000d18 <vmfault+0x110>
    80000c2a:	f84a                	sd	s2,48(sp)
    80000c2c:	892a                	mv	s2,a0
  va = PGROUNDDOWN(va);
    80000c2e:	77fd                	lui	a5,0xfffff
    80000c30:	8cfd                	and	s1,s1,a5
  if(read == 0 && iscowmapped(pagetable, va, &pte) && *pte != 0) { // is store page fault?
    80000c32:	020a1163          	bnez	s4,80000c54 <vmfault+0x4c>
    80000c36:	fb840613          	addi	a2,s0,-72
    80000c3a:	85a6                	mv	a1,s1
    80000c3c:	854e                	mv	a0,s3
    80000c3e:	f91ff0ef          	jal	80000bce <iscowmapped>
    80000c42:	c909                	beqz	a0,80000c54 <vmfault+0x4c>
    80000c44:	ec56                	sd	s5,24(sp)
    80000c46:	fb843783          	ld	a5,-72(s0)
    80000c4a:	8a3e                	mv	s4,a5
    80000c4c:	639c                	ld	a5,0(a5)
    80000c4e:	8abe                	mv	s5,a5
    80000c50:	eb91                	bnez	a5,80000c64 <vmfault+0x5c>
    80000c52:	6ae2                	ld	s5,24(sp)
  if(ismapped(pagetable, va)) {
    80000c54:	85a6                	mv	a1,s1
    80000c56:	854e                	mv	a0,s3
    80000c58:	f5bff0ef          	jal	80000bb2 <ismapped>
    return 0;
    80000c5c:	4a01                	li	s4,0
  if(ismapped(pagetable, va)) {
    80000c5e:	c159                	beqz	a0,80000ce4 <vmfault+0xdc>
    80000c60:	7942                	ld	s2,48(sp)
    80000c62:	a865                	j	80000d1a <vmfault+0x112>
    80000c64:	e85a                	sd	s6,16(sp)
    pa = PTE2PA(*pte);
    80000c66:	83a9                	srli	a5,a5,0xa
    80000c68:	07b2                	slli	a5,a5,0xc
    80000c6a:	8b3e                	mv	s6,a5
    if(kref(pa) == 1){ 
    80000c6c:	853e                	mv	a0,a5
    80000c6e:	e10ff0ef          	jal	8000027e <kref>
    80000c72:	4785                	li	a5,1
    80000c74:	04f50363          	beq	a0,a5,80000cba <vmfault+0xb2>
      mem = (uint64) kalloc(); // allocate a new page
    80000c78:	d1eff0ef          	jal	80000196 <kalloc>
    80000c7c:	89aa                	mv	s3,a0
        return 0;
    80000c7e:	4a01                	li	s4,0
      if(mem == 0)
    80000c80:	c54d                	beqz	a0,80000d2a <vmfault+0x122>
      mem = (uint64) kalloc(); // allocate a new page
    80000c82:	8a2a                	mv	s4,a0
      memmove((void *)mem, (void *)pa, PGSIZE); // copy old page to new page
    80000c84:	6605                	lui	a2,0x1
    80000c86:	85da                	mv	a1,s6
    80000c88:	e7cff0ef          	jal	80000304 <memmove>
      uvmunmap(p->pagetable, va, 1, 1);         // unmap CoW page
    80000c8c:	4685                	li	a3,1
    80000c8e:	8636                	mv	a2,a3
    80000c90:	85a6                	mv	a1,s1
    80000c92:	05093503          	ld	a0,80(s2) # 1050 <_entry-0x7fffefb0>
    80000c96:	b45ff0ef          	jal	800007da <uvmunmap>
      flags &= ~PTE_C; 
    80000c9a:	2ffaf713          	andi	a4,s5,767
      if (mappages(p->pagetable, va, PGSIZE, mem, flags) != 0) { // map copied page
    80000c9e:	00476713          	ori	a4,a4,4
    80000ca2:	86ce                	mv	a3,s3
    80000ca4:	6605                	lui	a2,0x1
    80000ca6:	85a6                	mv	a1,s1
    80000ca8:	05093503          	ld	a0,80(s2)
    80000cac:	961ff0ef          	jal	8000060c <mappages>
    80000cb0:	e115                	bnez	a0,80000cd4 <vmfault+0xcc>
    80000cb2:	7942                	ld	s2,48(sp)
    80000cb4:	6ae2                	ld	s5,24(sp)
    80000cb6:	6b42                	ld	s6,16(sp)
    80000cb8:	a08d                	j	80000d1a <vmfault+0x112>
      *pte &= ~PTE_C;
    80000cba:	000a3783          	ld	a5,0(s4) # 1000 <_entry-0x7ffff000>
    80000cbe:	eff7f793          	andi	a5,a5,-257
      *pte |= PTE_W;
    80000cc2:	0047e793          	ori	a5,a5,4
    80000cc6:	00fa3023          	sd	a5,0(s4)
      return pa;
    80000cca:	8a5a                	mv	s4,s6
    80000ccc:	7942                	ld	s2,48(sp)
    80000cce:	6ae2                	ld	s5,24(sp)
    80000cd0:	6b42                	ld	s6,16(sp)
    80000cd2:	a0a1                	j	80000d1a <vmfault+0x112>
          kfree((void *)mem);
    80000cd4:	854e                	mv	a0,s3
    80000cd6:	b46ff0ef          	jal	8000001c <kfree>
          return 0;
    80000cda:	4a01                	li	s4,0
    80000cdc:	7942                	ld	s2,48(sp)
    80000cde:	6ae2                	ld	s5,24(sp)
    80000ce0:	6b42                	ld	s6,16(sp)
    80000ce2:	a825                	j	80000d1a <vmfault+0x112>
  mem = (uint64) kalloc();
    80000ce4:	cb2ff0ef          	jal	80000196 <kalloc>
    80000ce8:	89aa                	mv	s3,a0
  if(mem == 0)
    80000cea:	c521                	beqz	a0,80000d32 <vmfault+0x12a>
  mem = (uint64) kalloc();
    80000cec:	8a2a                	mv	s4,a0
  memset((void *) mem, 0, PGSIZE);
    80000cee:	6605                	lui	a2,0x1
    80000cf0:	4581                	li	a1,0
    80000cf2:	db2ff0ef          	jal	800002a4 <memset>
  if (mappages(p->pagetable, va, PGSIZE, mem, PTE_W|PTE_U|PTE_R) != 0) {
    80000cf6:	4759                	li	a4,22
    80000cf8:	86ce                	mv	a3,s3
    80000cfa:	6605                	lui	a2,0x1
    80000cfc:	85a6                	mv	a1,s1
    80000cfe:	05093503          	ld	a0,80(s2)
    80000d02:	90bff0ef          	jal	8000060c <mappages>
    80000d06:	e119                	bnez	a0,80000d0c <vmfault+0x104>
    80000d08:	7942                	ld	s2,48(sp)
    80000d0a:	a801                	j	80000d1a <vmfault+0x112>
    kfree((void *)mem);
    80000d0c:	854e                	mv	a0,s3
    80000d0e:	b0eff0ef          	jal	8000001c <kfree>
    return 0;
    80000d12:	4a01                	li	s4,0
    80000d14:	7942                	ld	s2,48(sp)
    80000d16:	a011                	j	80000d1a <vmfault+0x112>
    return 0;
    80000d18:	4a01                	li	s4,0
}
    80000d1a:	8552                	mv	a0,s4
    80000d1c:	60a6                	ld	ra,72(sp)
    80000d1e:	6406                	ld	s0,64(sp)
    80000d20:	74e2                	ld	s1,56(sp)
    80000d22:	79a2                	ld	s3,40(sp)
    80000d24:	7a02                	ld	s4,32(sp)
    80000d26:	6161                	addi	sp,sp,80
    80000d28:	8082                	ret
    80000d2a:	7942                	ld	s2,48(sp)
    80000d2c:	6ae2                	ld	s5,24(sp)
    80000d2e:	6b42                	ld	s6,16(sp)
    80000d30:	b7ed                	j	80000d1a <vmfault+0x112>
    80000d32:	7942                	ld	s2,48(sp)
    80000d34:	b7dd                	j	80000d1a <vmfault+0x112>

0000000080000d36 <copyout>:
  while(len > 0){
    80000d36:	cacd                	beqz	a3,80000de8 <copyout+0xb2>
{
    80000d38:	711d                	addi	sp,sp,-96
    80000d3a:	ec86                	sd	ra,88(sp)
    80000d3c:	e8a2                	sd	s0,80(sp)
    80000d3e:	e4a6                	sd	s1,72(sp)
    80000d40:	e0ca                	sd	s2,64(sp)
    80000d42:	fc4e                	sd	s3,56(sp)
    80000d44:	f852                	sd	s4,48(sp)
    80000d46:	f456                	sd	s5,40(sp)
    80000d48:	f05a                	sd	s6,32(sp)
    80000d4a:	ec5e                	sd	s7,24(sp)
    80000d4c:	e862                	sd	s8,16(sp)
    80000d4e:	e466                	sd	s9,8(sp)
    80000d50:	e06a                	sd	s10,0(sp)
    80000d52:	1080                	addi	s0,sp,96
    80000d54:	8baa                	mv	s7,a0
    80000d56:	8a2e                	mv	s4,a1
    80000d58:	8b32                	mv	s6,a2
    80000d5a:	8ab6                	mv	s5,a3
    va0 = PGROUNDDOWN(dstva);
    80000d5c:	7d7d                	lui	s10,0xfffff
    if(va0 >= MAXVA)
    80000d5e:	5cfd                	li	s9,-1
    80000d60:	01acdc93          	srli	s9,s9,0x1a
    n = PGSIZE - (dstva - va0);
    80000d64:	6c05                	lui	s8,0x1
    80000d66:	a80d                	j	80000d98 <copyout+0x62>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000d68:	4601                	li	a2,0
    80000d6a:	85ca                	mv	a1,s2
    80000d6c:	855e                	mv	a0,s7
    80000d6e:	e9bff0ef          	jal	80000c08 <vmfault>
    80000d72:	84aa                	mv	s1,a0
    80000d74:	ed29                	bnez	a0,80000dce <copyout+0x98>
        return -1;
    80000d76:	557d                	li	a0,-1
    80000d78:	a89d                	j	80000dee <copyout+0xb8>
    memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000d7a:	412a0533          	sub	a0,s4,s2
    80000d7e:	0009861b          	sext.w	a2,s3
    80000d82:	85da                	mv	a1,s6
    80000d84:	9526                	add	a0,a0,s1
    80000d86:	d7eff0ef          	jal	80000304 <memmove>
    len -= n;
    80000d8a:	413a8ab3          	sub	s5,s5,s3
    src += n;
    80000d8e:	9b4e                	add	s6,s6,s3
    dstva = va0 + PGSIZE;
    80000d90:	01890a33          	add	s4,s2,s8
  while(len > 0){
    80000d94:	040a8863          	beqz	s5,80000de4 <copyout+0xae>
    va0 = PGROUNDDOWN(dstva);
    80000d98:	01aa7933          	and	s2,s4,s10
    if(va0 >= MAXVA)
    80000d9c:	052ce863          	bltu	s9,s2,80000dec <copyout+0xb6>
    pa0 = walkaddr(pagetable, va0);
    80000da0:	85ca                	mv	a1,s2
    80000da2:	855e                	mv	a0,s7
    80000da4:	82fff0ef          	jal	800005d2 <walkaddr>
    80000da8:	84aa                	mv	s1,a0
    if(pa0 == 0) {
    80000daa:	e901                	bnez	a0,80000dba <copyout+0x84>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000dac:	4601                	li	a2,0
    80000dae:	85ca                	mv	a1,s2
    80000db0:	855e                	mv	a0,s7
    80000db2:	e57ff0ef          	jal	80000c08 <vmfault>
    80000db6:	84aa                	mv	s1,a0
    80000db8:	c929                	beqz	a0,80000e0a <copyout+0xd4>
    pte = walk(pagetable, va0, 0);
    80000dba:	4601                	li	a2,0
    80000dbc:	85ca                	mv	a1,s2
    80000dbe:	855e                	mv	a0,s7
    80000dc0:	f78ff0ef          	jal	80000538 <walk>
    80000dc4:	89aa                	mv	s3,a0
    flags = PTE_FLAGS(*pte);
    80000dc6:	611c                	ld	a5,0(a0)
    if(flags & PTE_C){
    80000dc8:	1007f793          	andi	a5,a5,256
    80000dcc:	ffd1                	bnez	a5,80000d68 <copyout+0x32>
    if((*pte & PTE_W) == 0)
    80000dce:	0009b783          	ld	a5,0(s3)
    80000dd2:	8b91                	andi	a5,a5,4
    80000dd4:	cf8d                	beqz	a5,80000e0e <copyout+0xd8>
    n = PGSIZE - (dstva - va0);
    80000dd6:	414909b3          	sub	s3,s2,s4
    80000dda:	99e2                	add	s3,s3,s8
    if(n > len)
    80000ddc:	f93affe3          	bgeu	s5,s3,80000d7a <copyout+0x44>
    80000de0:	89d6                	mv	s3,s5
    80000de2:	bf61                	j	80000d7a <copyout+0x44>
  return 0;
    80000de4:	4501                	li	a0,0
    80000de6:	a021                	j	80000dee <copyout+0xb8>
    80000de8:	4501                	li	a0,0
}
    80000dea:	8082                	ret
      return -1;
    80000dec:	557d                	li	a0,-1
}
    80000dee:	60e6                	ld	ra,88(sp)
    80000df0:	6446                	ld	s0,80(sp)
    80000df2:	64a6                	ld	s1,72(sp)
    80000df4:	6906                	ld	s2,64(sp)
    80000df6:	79e2                	ld	s3,56(sp)
    80000df8:	7a42                	ld	s4,48(sp)
    80000dfa:	7aa2                	ld	s5,40(sp)
    80000dfc:	7b02                	ld	s6,32(sp)
    80000dfe:	6be2                	ld	s7,24(sp)
    80000e00:	6c42                	ld	s8,16(sp)
    80000e02:	6ca2                	ld	s9,8(sp)
    80000e04:	6d02                	ld	s10,0(sp)
    80000e06:	6125                	addi	sp,sp,96
    80000e08:	8082                	ret
        return -1;
    80000e0a:	557d                	li	a0,-1
    80000e0c:	b7cd                	j	80000dee <copyout+0xb8>
      return -1;
    80000e0e:	557d                	li	a0,-1
    80000e10:	bff9                	j	80000dee <copyout+0xb8>

0000000080000e12 <copyin>:
  while(len > 0){
    80000e12:	c6c9                	beqz	a3,80000e9c <copyin+0x8a>
{
    80000e14:	715d                	addi	sp,sp,-80
    80000e16:	e486                	sd	ra,72(sp)
    80000e18:	e0a2                	sd	s0,64(sp)
    80000e1a:	fc26                	sd	s1,56(sp)
    80000e1c:	f84a                	sd	s2,48(sp)
    80000e1e:	f44e                	sd	s3,40(sp)
    80000e20:	f052                	sd	s4,32(sp)
    80000e22:	ec56                	sd	s5,24(sp)
    80000e24:	e85a                	sd	s6,16(sp)
    80000e26:	e45e                	sd	s7,8(sp)
    80000e28:	e062                	sd	s8,0(sp)
    80000e2a:	0880                	addi	s0,sp,80
    80000e2c:	8baa                	mv	s7,a0
    80000e2e:	8aae                	mv	s5,a1
    80000e30:	8932                	mv	s2,a2
    80000e32:	8a36                	mv	s4,a3
    va0 = PGROUNDDOWN(srcva);
    80000e34:	7c7d                	lui	s8,0xfffff
    n = PGSIZE - (srcva - va0);
    80000e36:	6b05                	lui	s6,0x1
    80000e38:	a035                	j	80000e64 <copyin+0x52>
    80000e3a:	412984b3          	sub	s1,s3,s2
    80000e3e:	94da                	add	s1,s1,s6
    if(n > len)
    80000e40:	009a7363          	bgeu	s4,s1,80000e46 <copyin+0x34>
    80000e44:	84d2                	mv	s1,s4
    memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000e46:	413905b3          	sub	a1,s2,s3
    80000e4a:	0004861b          	sext.w	a2,s1
    80000e4e:	95aa                	add	a1,a1,a0
    80000e50:	8556                	mv	a0,s5
    80000e52:	cb2ff0ef          	jal	80000304 <memmove>
    len -= n;
    80000e56:	409a0a33          	sub	s4,s4,s1
    dst += n;
    80000e5a:	9aa6                	add	s5,s5,s1
    srcva = va0 + PGSIZE;
    80000e5c:	01698933          	add	s2,s3,s6
  while(len > 0){
    80000e60:	020a0163          	beqz	s4,80000e82 <copyin+0x70>
    va0 = PGROUNDDOWN(srcva);
    80000e64:	018979b3          	and	s3,s2,s8
    pa0 = walkaddr(pagetable, va0);
    80000e68:	85ce                	mv	a1,s3
    80000e6a:	855e                	mv	a0,s7
    80000e6c:	f66ff0ef          	jal	800005d2 <walkaddr>
    if(pa0 == 0) {
    80000e70:	f569                	bnez	a0,80000e3a <copyin+0x28>
      if((pa0 = vmfault(pagetable, va0, 0)) == 0) {
    80000e72:	4601                	li	a2,0
    80000e74:	85ce                	mv	a1,s3
    80000e76:	855e                	mv	a0,s7
    80000e78:	d91ff0ef          	jal	80000c08 <vmfault>
    80000e7c:	fd5d                	bnez	a0,80000e3a <copyin+0x28>
        return -1;
    80000e7e:	557d                	li	a0,-1
    80000e80:	a011                	j	80000e84 <copyin+0x72>
  return 0;
    80000e82:	4501                	li	a0,0
}
    80000e84:	60a6                	ld	ra,72(sp)
    80000e86:	6406                	ld	s0,64(sp)
    80000e88:	74e2                	ld	s1,56(sp)
    80000e8a:	7942                	ld	s2,48(sp)
    80000e8c:	79a2                	ld	s3,40(sp)
    80000e8e:	7a02                	ld	s4,32(sp)
    80000e90:	6ae2                	ld	s5,24(sp)
    80000e92:	6b42                	ld	s6,16(sp)
    80000e94:	6ba2                	ld	s7,8(sp)
    80000e96:	6c02                	ld	s8,0(sp)
    80000e98:	6161                	addi	sp,sp,80
    80000e9a:	8082                	ret
  return 0;
    80000e9c:	4501                	li	a0,0
}
    80000e9e:	8082                	ret

0000000080000ea0 <proc_mapstacks>:
// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void
proc_mapstacks(pagetable_t kpgtbl)
{
    80000ea0:	715d                	addi	sp,sp,-80
    80000ea2:	e486                	sd	ra,72(sp)
    80000ea4:	e0a2                	sd	s0,64(sp)
    80000ea6:	fc26                	sd	s1,56(sp)
    80000ea8:	f84a                	sd	s2,48(sp)
    80000eaa:	f44e                	sd	s3,40(sp)
    80000eac:	f052                	sd	s4,32(sp)
    80000eae:	ec56                	sd	s5,24(sp)
    80000eb0:	e85a                	sd	s6,16(sp)
    80000eb2:	e45e                	sd	s7,8(sp)
    80000eb4:	e062                	sd	s8,0(sp)
    80000eb6:	0880                	addi	s0,sp,80
    80000eb8:	8a2a                	mv	s4,a0
  struct proc *p;
  
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eba:	00227497          	auipc	s1,0x227
    80000ebe:	e8648493          	addi	s1,s1,-378 # 80227d40 <proc>
    char *pa = kalloc();
    if(pa == 0)
      panic("kalloc");
    uint64 va = KSTACK((int) (p - proc));
    80000ec2:	8c26                	mv	s8,s1
    80000ec4:	000a57b7          	lui	a5,0xa5
    80000ec8:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80000ecc:	07b2                	slli	a5,a5,0xc
    80000ece:	fa578793          	addi	a5,a5,-91
    80000ed2:	4fa50937          	lui	s2,0x4fa50
    80000ed6:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80000eda:	1902                	slli	s2,s2,0x20
    80000edc:	993e                	add	s2,s2,a5
    80000ede:	040009b7          	lui	s3,0x4000
    80000ee2:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000ee4:	09b2                	slli	s3,s3,0xc
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000ee6:	4b99                	li	s7,6
    80000ee8:	6b05                	lui	s6,0x1
  for(p = proc; p < &proc[NPROC]; p++) {
    80000eea:	0022da97          	auipc	s5,0x22d
    80000eee:	856a8a93          	addi	s5,s5,-1962 # 8022d740 <tickslock>
    char *pa = kalloc();
    80000ef2:	aa4ff0ef          	jal	80000196 <kalloc>
    80000ef6:	862a                	mv	a2,a0
    if(pa == 0)
    80000ef8:	c121                	beqz	a0,80000f38 <proc_mapstacks+0x98>
    uint64 va = KSTACK((int) (p - proc));
    80000efa:	418485b3          	sub	a1,s1,s8
    80000efe:	858d                	srai	a1,a1,0x3
    80000f00:	032585b3          	mul	a1,a1,s2
    80000f04:	05b6                	slli	a1,a1,0xd
    80000f06:	6789                	lui	a5,0x2
    80000f08:	9dbd                	addw	a1,a1,a5
    kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000f0a:	875e                	mv	a4,s7
    80000f0c:	86da                	mv	a3,s6
    80000f0e:	40b985b3          	sub	a1,s3,a1
    80000f12:	8552                	mv	a0,s4
    80000f14:	faeff0ef          	jal	800006c2 <kvmmap>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f18:	16848493          	addi	s1,s1,360
    80000f1c:	fd549be3          	bne	s1,s5,80000ef2 <proc_mapstacks+0x52>
  }
}
    80000f20:	60a6                	ld	ra,72(sp)
    80000f22:	6406                	ld	s0,64(sp)
    80000f24:	74e2                	ld	s1,56(sp)
    80000f26:	7942                	ld	s2,48(sp)
    80000f28:	79a2                	ld	s3,40(sp)
    80000f2a:	7a02                	ld	s4,32(sp)
    80000f2c:	6ae2                	ld	s5,24(sp)
    80000f2e:	6b42                	ld	s6,16(sp)
    80000f30:	6ba2                	ld	s7,8(sp)
    80000f32:	6c02                	ld	s8,0(sp)
    80000f34:	6161                	addi	sp,sp,80
    80000f36:	8082                	ret
      panic("kalloc");
    80000f38:	00006517          	auipc	a0,0x6
    80000f3c:	13050513          	addi	a0,a0,304 # 80007068 <etext+0x68>
    80000f40:	229040ef          	jal	80005968 <panic>

0000000080000f44 <procinit>:

// initialize the proc table.
void
procinit(void)
{
    80000f44:	7139                	addi	sp,sp,-64
    80000f46:	fc06                	sd	ra,56(sp)
    80000f48:	f822                	sd	s0,48(sp)
    80000f4a:	f426                	sd	s1,40(sp)
    80000f4c:	f04a                	sd	s2,32(sp)
    80000f4e:	ec4e                	sd	s3,24(sp)
    80000f50:	e852                	sd	s4,16(sp)
    80000f52:	e456                	sd	s5,8(sp)
    80000f54:	e05a                	sd	s6,0(sp)
    80000f56:	0080                	addi	s0,sp,64
  struct proc *p;
  
  initlock(&pid_lock, "nextpid");
    80000f58:	00006597          	auipc	a1,0x6
    80000f5c:	1f858593          	addi	a1,a1,504 # 80007150 <etext+0x150>
    80000f60:	00227517          	auipc	a0,0x227
    80000f64:	9b050513          	addi	a0,a0,-1616 # 80227910 <pid_lock>
    80000f68:	419040ef          	jal	80005b80 <initlock>
  initlock(&wait_lock, "wait_lock");
    80000f6c:	00006597          	auipc	a1,0x6
    80000f70:	1ec58593          	addi	a1,a1,492 # 80007158 <etext+0x158>
    80000f74:	00227517          	auipc	a0,0x227
    80000f78:	9b450513          	addi	a0,a0,-1612 # 80227928 <wait_lock>
    80000f7c:	405040ef          	jal	80005b80 <initlock>
  for(p = proc; p < &proc[NPROC]; p++) {
    80000f80:	00227497          	auipc	s1,0x227
    80000f84:	dc048493          	addi	s1,s1,-576 # 80227d40 <proc>
      initlock(&p->lock, "proc");
    80000f88:	00006b17          	auipc	s6,0x6
    80000f8c:	1e0b0b13          	addi	s6,s6,480 # 80007168 <etext+0x168>
      p->state = UNUSED;
      p->kstack = KSTACK((int) (p - proc));
    80000f90:	8aa6                	mv	s5,s1
    80000f92:	000a57b7          	lui	a5,0xa5
    80000f96:	fa578793          	addi	a5,a5,-91 # a4fa5 <_entry-0x7ff5b05b>
    80000f9a:	07b2                	slli	a5,a5,0xc
    80000f9c:	fa578793          	addi	a5,a5,-91
    80000fa0:	4fa50937          	lui	s2,0x4fa50
    80000fa4:	a4f90913          	addi	s2,s2,-1457 # 4fa4fa4f <_entry-0x305b05b1>
    80000fa8:	1902                	slli	s2,s2,0x20
    80000faa:	993e                	add	s2,s2,a5
    80000fac:	040009b7          	lui	s3,0x4000
    80000fb0:	19fd                	addi	s3,s3,-1 # 3ffffff <_entry-0x7c000001>
    80000fb2:	09b2                	slli	s3,s3,0xc
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fb4:	0022ca17          	auipc	s4,0x22c
    80000fb8:	78ca0a13          	addi	s4,s4,1932 # 8022d740 <tickslock>
      initlock(&p->lock, "proc");
    80000fbc:	85da                	mv	a1,s6
    80000fbe:	8526                	mv	a0,s1
    80000fc0:	3c1040ef          	jal	80005b80 <initlock>
      p->state = UNUSED;
    80000fc4:	0004ac23          	sw	zero,24(s1)
      p->kstack = KSTACK((int) (p - proc));
    80000fc8:	415487b3          	sub	a5,s1,s5
    80000fcc:	878d                	srai	a5,a5,0x3
    80000fce:	032787b3          	mul	a5,a5,s2
    80000fd2:	07b6                	slli	a5,a5,0xd
    80000fd4:	6709                	lui	a4,0x2
    80000fd6:	9fb9                	addw	a5,a5,a4
    80000fd8:	40f987b3          	sub	a5,s3,a5
    80000fdc:	e0bc                	sd	a5,64(s1)
  for(p = proc; p < &proc[NPROC]; p++) {
    80000fde:	16848493          	addi	s1,s1,360
    80000fe2:	fd449de3          	bne	s1,s4,80000fbc <procinit+0x78>
  }
}
    80000fe6:	70e2                	ld	ra,56(sp)
    80000fe8:	7442                	ld	s0,48(sp)
    80000fea:	74a2                	ld	s1,40(sp)
    80000fec:	7902                	ld	s2,32(sp)
    80000fee:	69e2                	ld	s3,24(sp)
    80000ff0:	6a42                	ld	s4,16(sp)
    80000ff2:	6aa2                	ld	s5,8(sp)
    80000ff4:	6b02                	ld	s6,0(sp)
    80000ff6:	6121                	addi	sp,sp,64
    80000ff8:	8082                	ret

0000000080000ffa <cpuid>:
// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int
cpuid()
{
    80000ffa:	1141                	addi	sp,sp,-16
    80000ffc:	e406                	sd	ra,8(sp)
    80000ffe:	e022                	sd	s0,0(sp)
    80001000:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80001002:	8512                	mv	a0,tp
  int id = r_tp();
  return id;
}
    80001004:	2501                	sext.w	a0,a0
    80001006:	60a2                	ld	ra,8(sp)
    80001008:	6402                	ld	s0,0(sp)
    8000100a:	0141                	addi	sp,sp,16
    8000100c:	8082                	ret

000000008000100e <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu*
mycpu(void)
{
    8000100e:	1141                	addi	sp,sp,-16
    80001010:	e406                	sd	ra,8(sp)
    80001012:	e022                	sd	s0,0(sp)
    80001014:	0800                	addi	s0,sp,16
    80001016:	8792                	mv	a5,tp
  int id = cpuid();
  struct cpu *c = &cpus[id];
    80001018:	2781                	sext.w	a5,a5
    8000101a:	079e                	slli	a5,a5,0x7
  return c;
}
    8000101c:	00227517          	auipc	a0,0x227
    80001020:	92450513          	addi	a0,a0,-1756 # 80227940 <cpus>
    80001024:	953e                	add	a0,a0,a5
    80001026:	60a2                	ld	ra,8(sp)
    80001028:	6402                	ld	s0,0(sp)
    8000102a:	0141                	addi	sp,sp,16
    8000102c:	8082                	ret

000000008000102e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc*
myproc(void)
{
    8000102e:	1101                	addi	sp,sp,-32
    80001030:	ec06                	sd	ra,24(sp)
    80001032:	e822                	sd	s0,16(sp)
    80001034:	e426                	sd	s1,8(sp)
    80001036:	1000                	addi	s0,sp,32
  push_off();
    80001038:	38f040ef          	jal	80005bc6 <push_off>
    8000103c:	8792                	mv	a5,tp
  struct cpu *c = mycpu();
  struct proc *p = c->proc;
    8000103e:	2781                	sext.w	a5,a5
    80001040:	079e                	slli	a5,a5,0x7
    80001042:	00227717          	auipc	a4,0x227
    80001046:	8ce70713          	addi	a4,a4,-1842 # 80227910 <pid_lock>
    8000104a:	97ba                	add	a5,a5,a4
    8000104c:	7b9c                	ld	a5,48(a5)
    8000104e:	84be                	mv	s1,a5
  pop_off();
    80001050:	3ff040ef          	jal	80005c4e <pop_off>
  return p;
}
    80001054:	8526                	mv	a0,s1
    80001056:	60e2                	ld	ra,24(sp)
    80001058:	6442                	ld	s0,16(sp)
    8000105a:	64a2                	ld	s1,8(sp)
    8000105c:	6105                	addi	sp,sp,32
    8000105e:	8082                	ret

0000000080001060 <forkret>:

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void
forkret(void)
{
    80001060:	7179                	addi	sp,sp,-48
    80001062:	f406                	sd	ra,40(sp)
    80001064:	f022                	sd	s0,32(sp)
    80001066:	ec26                	sd	s1,24(sp)
    80001068:	1800                	addi	s0,sp,48
  extern char userret[];
  static int first = 1;
  struct proc *p = myproc();
    8000106a:	fc5ff0ef          	jal	8000102e <myproc>
    8000106e:	84aa                	mv	s1,a0

  // Still holding p->lock from scheduler.
  release(&p->lock);
    80001070:	42f040ef          	jal	80005c9e <release>

  if (first) {
    80001074:	00007797          	auipc	a5,0x7
    80001078:	83c7a783          	lw	a5,-1988(a5) # 800078b0 <first.1>
    8000107c:	cf95                	beqz	a5,800010b8 <forkret+0x58>
    // File system initialization must be run in the context of a
    // regular process (e.g., because it calls sleep), and thus cannot
    // be run from main().
    fsinit(ROOTDEV);
    8000107e:	4505                	li	a0,1
    80001080:	37b010ef          	jal	80002bfa <fsinit>

    first = 0;
    80001084:	00007797          	auipc	a5,0x7
    80001088:	8207a623          	sw	zero,-2004(a5) # 800078b0 <first.1>
    // ensure other cores see first=0.
    __sync_synchronize();
    8000108c:	0330000f          	fence	rw,rw

    // We can invoke kexec() now that file system is initialized.
    // Put the return value (argc) of kexec into a0.
    p->trapframe->a0 = kexec("/init", (char *[]){ "/init", 0 });
    80001090:	00006797          	auipc	a5,0x6
    80001094:	0e078793          	addi	a5,a5,224 # 80007170 <etext+0x170>
    80001098:	fcf43823          	sd	a5,-48(s0)
    8000109c:	fc043c23          	sd	zero,-40(s0)
    800010a0:	fd040593          	addi	a1,s0,-48
    800010a4:	853e                	mv	a0,a5
    800010a6:	4d3020ef          	jal	80003d78 <kexec>
    800010aa:	6cbc                	ld	a5,88(s1)
    800010ac:	fba8                	sd	a0,112(a5)
    if (p->trapframe->a0 == -1) {
    800010ae:	6cbc                	ld	a5,88(s1)
    800010b0:	7bb8                	ld	a4,112(a5)
    800010b2:	57fd                	li	a5,-1
    800010b4:	02f70d63          	beq	a4,a5,800010ee <forkret+0x8e>
      panic("exec");
    }
  }

  // return to user space, mimicing usertrap()'s return.
  prepare_return();
    800010b8:	2b1000ef          	jal	80001b68 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    800010bc:	68a8                	ld	a0,80(s1)
    800010be:	8131                	srli	a0,a0,0xc
  uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    800010c0:	04000737          	lui	a4,0x4000
    800010c4:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    800010c6:	0732                	slli	a4,a4,0xc
    800010c8:	00005797          	auipc	a5,0x5
    800010cc:	fd478793          	addi	a5,a5,-44 # 8000609c <userret>
    800010d0:	00005697          	auipc	a3,0x5
    800010d4:	f3068693          	addi	a3,a3,-208 # 80006000 <_trampoline>
    800010d8:	8f95                	sub	a5,a5,a3
    800010da:	97ba                	add	a5,a5,a4
  ((void (*)(uint64))trampoline_userret)(satp);
    800010dc:	577d                	li	a4,-1
    800010de:	177e                	slli	a4,a4,0x3f
    800010e0:	8d59                	or	a0,a0,a4
    800010e2:	9782                	jalr	a5
}
    800010e4:	70a2                	ld	ra,40(sp)
    800010e6:	7402                	ld	s0,32(sp)
    800010e8:	64e2                	ld	s1,24(sp)
    800010ea:	6145                	addi	sp,sp,48
    800010ec:	8082                	ret
      panic("exec");
    800010ee:	00006517          	auipc	a0,0x6
    800010f2:	08a50513          	addi	a0,a0,138 # 80007178 <etext+0x178>
    800010f6:	073040ef          	jal	80005968 <panic>

00000000800010fa <allocpid>:
{
    800010fa:	1101                	addi	sp,sp,-32
    800010fc:	ec06                	sd	ra,24(sp)
    800010fe:	e822                	sd	s0,16(sp)
    80001100:	e426                	sd	s1,8(sp)
    80001102:	1000                	addi	s0,sp,32
  acquire(&pid_lock);
    80001104:	00227517          	auipc	a0,0x227
    80001108:	80c50513          	addi	a0,a0,-2036 # 80227910 <pid_lock>
    8000110c:	2ff040ef          	jal	80005c0a <acquire>
  pid = nextpid;
    80001110:	00006797          	auipc	a5,0x6
    80001114:	7a478793          	addi	a5,a5,1956 # 800078b4 <nextpid>
    80001118:	4384                	lw	s1,0(a5)
  nextpid = nextpid + 1;
    8000111a:	0014871b          	addiw	a4,s1,1
    8000111e:	c398                	sw	a4,0(a5)
  release(&pid_lock);
    80001120:	00226517          	auipc	a0,0x226
    80001124:	7f050513          	addi	a0,a0,2032 # 80227910 <pid_lock>
    80001128:	377040ef          	jal	80005c9e <release>
}
    8000112c:	8526                	mv	a0,s1
    8000112e:	60e2                	ld	ra,24(sp)
    80001130:	6442                	ld	s0,16(sp)
    80001132:	64a2                	ld	s1,8(sp)
    80001134:	6105                	addi	sp,sp,32
    80001136:	8082                	ret

0000000080001138 <proc_pagetable>:
{
    80001138:	1101                	addi	sp,sp,-32
    8000113a:	ec06                	sd	ra,24(sp)
    8000113c:	e822                	sd	s0,16(sp)
    8000113e:	e426                	sd	s1,8(sp)
    80001140:	e04a                	sd	s2,0(sp)
    80001142:	1000                	addi	s0,sp,32
    80001144:	892a                	mv	s2,a0
  pagetable = uvmcreate();
    80001146:	e6eff0ef          	jal	800007b4 <uvmcreate>
    8000114a:	84aa                	mv	s1,a0
  if(pagetable == 0)
    8000114c:	cd05                	beqz	a0,80001184 <proc_pagetable+0x4c>
  if(mappages(pagetable, TRAMPOLINE, PGSIZE,
    8000114e:	4729                	li	a4,10
    80001150:	00005697          	auipc	a3,0x5
    80001154:	eb068693          	addi	a3,a3,-336 # 80006000 <_trampoline>
    80001158:	6605                	lui	a2,0x1
    8000115a:	040005b7          	lui	a1,0x4000
    8000115e:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    80001160:	05b2                	slli	a1,a1,0xc
    80001162:	caaff0ef          	jal	8000060c <mappages>
    80001166:	02054663          	bltz	a0,80001192 <proc_pagetable+0x5a>
  if(mappages(pagetable, TRAPFRAME, PGSIZE,
    8000116a:	4719                	li	a4,6
    8000116c:	05893683          	ld	a3,88(s2)
    80001170:	6605                	lui	a2,0x1
    80001172:	020005b7          	lui	a1,0x2000
    80001176:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    80001178:	05b6                	slli	a1,a1,0xd
    8000117a:	8526                	mv	a0,s1
    8000117c:	c90ff0ef          	jal	8000060c <mappages>
    80001180:	00054f63          	bltz	a0,8000119e <proc_pagetable+0x66>
}
    80001184:	8526                	mv	a0,s1
    80001186:	60e2                	ld	ra,24(sp)
    80001188:	6442                	ld	s0,16(sp)
    8000118a:	64a2                	ld	s1,8(sp)
    8000118c:	6902                	ld	s2,0(sp)
    8000118e:	6105                	addi	sp,sp,32
    80001190:	8082                	ret
    uvmfree(pagetable, 0);
    80001192:	4581                	li	a1,0
    80001194:	8526                	mv	a0,s1
    80001196:	819ff0ef          	jal	800009ae <uvmfree>
    return 0;
    8000119a:	4481                	li	s1,0
    8000119c:	b7e5                	j	80001184 <proc_pagetable+0x4c>
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    8000119e:	4681                	li	a3,0
    800011a0:	4605                	li	a2,1
    800011a2:	040005b7          	lui	a1,0x4000
    800011a6:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011a8:	05b2                	slli	a1,a1,0xc
    800011aa:	8526                	mv	a0,s1
    800011ac:	e2eff0ef          	jal	800007da <uvmunmap>
    uvmfree(pagetable, 0);
    800011b0:	4581                	li	a1,0
    800011b2:	8526                	mv	a0,s1
    800011b4:	ffaff0ef          	jal	800009ae <uvmfree>
    return 0;
    800011b8:	4481                	li	s1,0
    800011ba:	b7e9                	j	80001184 <proc_pagetable+0x4c>

00000000800011bc <proc_freepagetable>:
{
    800011bc:	1101                	addi	sp,sp,-32
    800011be:	ec06                	sd	ra,24(sp)
    800011c0:	e822                	sd	s0,16(sp)
    800011c2:	e426                	sd	s1,8(sp)
    800011c4:	e04a                	sd	s2,0(sp)
    800011c6:	1000                	addi	s0,sp,32
    800011c8:	84aa                	mv	s1,a0
    800011ca:	892e                	mv	s2,a1
  uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    800011cc:	4681                	li	a3,0
    800011ce:	4605                	li	a2,1
    800011d0:	040005b7          	lui	a1,0x4000
    800011d4:	15fd                	addi	a1,a1,-1 # 3ffffff <_entry-0x7c000001>
    800011d6:	05b2                	slli	a1,a1,0xc
    800011d8:	e02ff0ef          	jal	800007da <uvmunmap>
  uvmunmap(pagetable, TRAPFRAME, 1, 0);
    800011dc:	4681                	li	a3,0
    800011de:	4605                	li	a2,1
    800011e0:	020005b7          	lui	a1,0x2000
    800011e4:	15fd                	addi	a1,a1,-1 # 1ffffff <_entry-0x7e000001>
    800011e6:	05b6                	slli	a1,a1,0xd
    800011e8:	8526                	mv	a0,s1
    800011ea:	df0ff0ef          	jal	800007da <uvmunmap>
  uvmfree(pagetable, sz);
    800011ee:	85ca                	mv	a1,s2
    800011f0:	8526                	mv	a0,s1
    800011f2:	fbcff0ef          	jal	800009ae <uvmfree>
}
    800011f6:	60e2                	ld	ra,24(sp)
    800011f8:	6442                	ld	s0,16(sp)
    800011fa:	64a2                	ld	s1,8(sp)
    800011fc:	6902                	ld	s2,0(sp)
    800011fe:	6105                	addi	sp,sp,32
    80001200:	8082                	ret

0000000080001202 <freeproc>:
{
    80001202:	1101                	addi	sp,sp,-32
    80001204:	ec06                	sd	ra,24(sp)
    80001206:	e822                	sd	s0,16(sp)
    80001208:	e426                	sd	s1,8(sp)
    8000120a:	1000                	addi	s0,sp,32
    8000120c:	84aa                	mv	s1,a0
  if(p->trapframe)
    8000120e:	6d28                	ld	a0,88(a0)
    80001210:	c119                	beqz	a0,80001216 <freeproc+0x14>
    kfree((void*)p->trapframe);
    80001212:	e0bfe0ef          	jal	8000001c <kfree>
  p->trapframe = 0;
    80001216:	0404bc23          	sd	zero,88(s1)
  if(p->pagetable)
    8000121a:	68a8                	ld	a0,80(s1)
    8000121c:	c501                	beqz	a0,80001224 <freeproc+0x22>
    proc_freepagetable(p->pagetable, p->sz);
    8000121e:	64ac                	ld	a1,72(s1)
    80001220:	f9dff0ef          	jal	800011bc <proc_freepagetable>
  p->pagetable = 0;
    80001224:	0404b823          	sd	zero,80(s1)
  p->sz = 0;
    80001228:	0404b423          	sd	zero,72(s1)
  p->pid = 0;
    8000122c:	0204a823          	sw	zero,48(s1)
  p->parent = 0;
    80001230:	0204bc23          	sd	zero,56(s1)
  p->name[0] = 0;
    80001234:	14048c23          	sb	zero,344(s1)
  p->chan = 0;
    80001238:	0204b023          	sd	zero,32(s1)
  p->killed = 0;
    8000123c:	0204a423          	sw	zero,40(s1)
  p->xstate = 0;
    80001240:	0204a623          	sw	zero,44(s1)
  p->state = UNUSED;
    80001244:	0004ac23          	sw	zero,24(s1)
}
    80001248:	60e2                	ld	ra,24(sp)
    8000124a:	6442                	ld	s0,16(sp)
    8000124c:	64a2                	ld	s1,8(sp)
    8000124e:	6105                	addi	sp,sp,32
    80001250:	8082                	ret

0000000080001252 <allocproc>:
{
    80001252:	1101                	addi	sp,sp,-32
    80001254:	ec06                	sd	ra,24(sp)
    80001256:	e822                	sd	s0,16(sp)
    80001258:	e426                	sd	s1,8(sp)
    8000125a:	e04a                	sd	s2,0(sp)
    8000125c:	1000                	addi	s0,sp,32
  for(p = proc; p < &proc[NPROC]; p++) {
    8000125e:	00227497          	auipc	s1,0x227
    80001262:	ae248493          	addi	s1,s1,-1310 # 80227d40 <proc>
    80001266:	0022c917          	auipc	s2,0x22c
    8000126a:	4da90913          	addi	s2,s2,1242 # 8022d740 <tickslock>
    acquire(&p->lock);
    8000126e:	8526                	mv	a0,s1
    80001270:	19b040ef          	jal	80005c0a <acquire>
    if(p->state == UNUSED) {
    80001274:	4c9c                	lw	a5,24(s1)
    80001276:	cb91                	beqz	a5,8000128a <allocproc+0x38>
      release(&p->lock);
    80001278:	8526                	mv	a0,s1
    8000127a:	225040ef          	jal	80005c9e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    8000127e:	16848493          	addi	s1,s1,360
    80001282:	ff2496e3          	bne	s1,s2,8000126e <allocproc+0x1c>
  return 0;
    80001286:	4481                	li	s1,0
    80001288:	a089                	j	800012ca <allocproc+0x78>
  p->pid = allocpid();
    8000128a:	e71ff0ef          	jal	800010fa <allocpid>
    8000128e:	d888                	sw	a0,48(s1)
  p->state = USED;
    80001290:	4785                	li	a5,1
    80001292:	cc9c                	sw	a5,24(s1)
  if((p->trapframe = (struct trapframe *)kalloc()) == 0){
    80001294:	f03fe0ef          	jal	80000196 <kalloc>
    80001298:	892a                	mv	s2,a0
    8000129a:	eca8                	sd	a0,88(s1)
    8000129c:	cd15                	beqz	a0,800012d8 <allocproc+0x86>
  p->pagetable = proc_pagetable(p);
    8000129e:	8526                	mv	a0,s1
    800012a0:	e99ff0ef          	jal	80001138 <proc_pagetable>
    800012a4:	892a                	mv	s2,a0
    800012a6:	e8a8                	sd	a0,80(s1)
  if(p->pagetable == 0){
    800012a8:	c121                	beqz	a0,800012e8 <allocproc+0x96>
  memset(&p->context, 0, sizeof(p->context));
    800012aa:	07000613          	li	a2,112
    800012ae:	4581                	li	a1,0
    800012b0:	06048513          	addi	a0,s1,96
    800012b4:	ff1fe0ef          	jal	800002a4 <memset>
  p->context.ra = (uint64)forkret;
    800012b8:	00000797          	auipc	a5,0x0
    800012bc:	da878793          	addi	a5,a5,-600 # 80001060 <forkret>
    800012c0:	f0bc                	sd	a5,96(s1)
  p->context.sp = p->kstack + PGSIZE;
    800012c2:	60bc                	ld	a5,64(s1)
    800012c4:	6705                	lui	a4,0x1
    800012c6:	97ba                	add	a5,a5,a4
    800012c8:	f4bc                	sd	a5,104(s1)
}
    800012ca:	8526                	mv	a0,s1
    800012cc:	60e2                	ld	ra,24(sp)
    800012ce:	6442                	ld	s0,16(sp)
    800012d0:	64a2                	ld	s1,8(sp)
    800012d2:	6902                	ld	s2,0(sp)
    800012d4:	6105                	addi	sp,sp,32
    800012d6:	8082                	ret
    freeproc(p);
    800012d8:	8526                	mv	a0,s1
    800012da:	f29ff0ef          	jal	80001202 <freeproc>
    release(&p->lock);
    800012de:	8526                	mv	a0,s1
    800012e0:	1bf040ef          	jal	80005c9e <release>
    return 0;
    800012e4:	84ca                	mv	s1,s2
    800012e6:	b7d5                	j	800012ca <allocproc+0x78>
    freeproc(p);
    800012e8:	8526                	mv	a0,s1
    800012ea:	f19ff0ef          	jal	80001202 <freeproc>
    release(&p->lock);
    800012ee:	8526                	mv	a0,s1
    800012f0:	1af040ef          	jal	80005c9e <release>
    return 0;
    800012f4:	84ca                	mv	s1,s2
    800012f6:	bfd1                	j	800012ca <allocproc+0x78>

00000000800012f8 <userinit>:
{
    800012f8:	1101                	addi	sp,sp,-32
    800012fa:	ec06                	sd	ra,24(sp)
    800012fc:	e822                	sd	s0,16(sp)
    800012fe:	e426                	sd	s1,8(sp)
    80001300:	1000                	addi	s0,sp,32
  p = allocproc();
    80001302:	f51ff0ef          	jal	80001252 <allocproc>
    80001306:	84aa                	mv	s1,a0
  initproc = p;
    80001308:	00006797          	auipc	a5,0x6
    8000130c:	5ca7b423          	sd	a0,1480(a5) # 800078d0 <initproc>
  p->cwd = namei("/");
    80001310:	00006517          	auipc	a0,0x6
    80001314:	e7050513          	addi	a0,a0,-400 # 80007180 <etext+0x180>
    80001318:	61d010ef          	jal	80003134 <namei>
    8000131c:	14a4b823          	sd	a0,336(s1)
  p->state = RUNNABLE;
    80001320:	478d                	li	a5,3
    80001322:	cc9c                	sw	a5,24(s1)
  release(&p->lock);
    80001324:	8526                	mv	a0,s1
    80001326:	179040ef          	jal	80005c9e <release>
}
    8000132a:	60e2                	ld	ra,24(sp)
    8000132c:	6442                	ld	s0,16(sp)
    8000132e:	64a2                	ld	s1,8(sp)
    80001330:	6105                	addi	sp,sp,32
    80001332:	8082                	ret

0000000080001334 <growproc>:
{
    80001334:	1101                	addi	sp,sp,-32
    80001336:	ec06                	sd	ra,24(sp)
    80001338:	e822                	sd	s0,16(sp)
    8000133a:	e426                	sd	s1,8(sp)
    8000133c:	e04a                	sd	s2,0(sp)
    8000133e:	1000                	addi	s0,sp,32
    80001340:	892a                	mv	s2,a0
  struct proc *p = myproc();
    80001342:	cedff0ef          	jal	8000102e <myproc>
    80001346:	84aa                	mv	s1,a0
  sz = p->sz;
    80001348:	652c                	ld	a1,72(a0)
  if(n > 0){
    8000134a:	01204c63          	bgtz	s2,80001362 <growproc+0x2e>
  } else if(n < 0){
    8000134e:	02094463          	bltz	s2,80001376 <growproc+0x42>
  p->sz = sz;
    80001352:	e4ac                	sd	a1,72(s1)
  return 0;
    80001354:	4501                	li	a0,0
}
    80001356:	60e2                	ld	ra,24(sp)
    80001358:	6442                	ld	s0,16(sp)
    8000135a:	64a2                	ld	s1,8(sp)
    8000135c:	6902                	ld	s2,0(sp)
    8000135e:	6105                	addi	sp,sp,32
    80001360:	8082                	ret
    if((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0) {
    80001362:	4691                	li	a3,4
    80001364:	00b90633          	add	a2,s2,a1
    80001368:	6928                	ld	a0,80(a0)
    8000136a:	d3eff0ef          	jal	800008a8 <uvmalloc>
    8000136e:	85aa                	mv	a1,a0
    80001370:	f16d                	bnez	a0,80001352 <growproc+0x1e>
      return -1;
    80001372:	557d                	li	a0,-1
    80001374:	b7cd                	j	80001356 <growproc+0x22>
    sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001376:	00b90633          	add	a2,s2,a1
    8000137a:	6928                	ld	a0,80(a0)
    8000137c:	ce8ff0ef          	jal	80000864 <uvmdealloc>
    80001380:	85aa                	mv	a1,a0
    80001382:	bfc1                	j	80001352 <growproc+0x1e>

0000000080001384 <kfork>:
{
    80001384:	7139                	addi	sp,sp,-64
    80001386:	fc06                	sd	ra,56(sp)
    80001388:	f822                	sd	s0,48(sp)
    8000138a:	f426                	sd	s1,40(sp)
    8000138c:	e456                	sd	s5,8(sp)
    8000138e:	0080                	addi	s0,sp,64
  struct proc *p = myproc();
    80001390:	c9fff0ef          	jal	8000102e <myproc>
    80001394:	8aaa                	mv	s5,a0
  if((np = allocproc()) == 0){
    80001396:	ebdff0ef          	jal	80001252 <allocproc>
    8000139a:	0e050a63          	beqz	a0,8000148e <kfork+0x10a>
    8000139e:	e852                	sd	s4,16(sp)
    800013a0:	8a2a                	mv	s4,a0
  if(uvmcopy(p->pagetable, np->pagetable, p->sz) < 0){
    800013a2:	048ab603          	ld	a2,72(s5)
    800013a6:	692c                	ld	a1,80(a0)
    800013a8:	050ab503          	ld	a0,80(s5)
    800013ac:	e34ff0ef          	jal	800009e0 <uvmcopy>
    800013b0:	04054863          	bltz	a0,80001400 <kfork+0x7c>
    800013b4:	f04a                	sd	s2,32(sp)
    800013b6:	ec4e                	sd	s3,24(sp)
  np->sz = p->sz;
    800013b8:	048ab783          	ld	a5,72(s5)
    800013bc:	04fa3423          	sd	a5,72(s4)
  *(np->trapframe) = *(p->trapframe);
    800013c0:	058ab683          	ld	a3,88(s5)
    800013c4:	87b6                	mv	a5,a3
    800013c6:	058a3703          	ld	a4,88(s4)
    800013ca:	12068693          	addi	a3,a3,288
    800013ce:	6388                	ld	a0,0(a5)
    800013d0:	678c                	ld	a1,8(a5)
    800013d2:	6b90                	ld	a2,16(a5)
    800013d4:	e308                	sd	a0,0(a4)
    800013d6:	e70c                	sd	a1,8(a4)
    800013d8:	eb10                	sd	a2,16(a4)
    800013da:	6f90                	ld	a2,24(a5)
    800013dc:	ef10                	sd	a2,24(a4)
    800013de:	02078793          	addi	a5,a5,32
    800013e2:	02070713          	addi	a4,a4,32 # 1020 <_entry-0x7fffefe0>
    800013e6:	fed794e3          	bne	a5,a3,800013ce <kfork+0x4a>
  np->trapframe->a0 = 0;
    800013ea:	058a3783          	ld	a5,88(s4)
    800013ee:	0607b823          	sd	zero,112(a5)
  for(i = 0; i < NOFILE; i++)
    800013f2:	0d0a8493          	addi	s1,s5,208
    800013f6:	0d0a0913          	addi	s2,s4,208
    800013fa:	150a8993          	addi	s3,s5,336
    800013fe:	a831                	j	8000141a <kfork+0x96>
    freeproc(np);
    80001400:	8552                	mv	a0,s4
    80001402:	e01ff0ef          	jal	80001202 <freeproc>
    release(&np->lock);
    80001406:	8552                	mv	a0,s4
    80001408:	097040ef          	jal	80005c9e <release>
    return -1;
    8000140c:	54fd                	li	s1,-1
    8000140e:	6a42                	ld	s4,16(sp)
    80001410:	a885                	j	80001480 <kfork+0xfc>
  for(i = 0; i < NOFILE; i++)
    80001412:	04a1                	addi	s1,s1,8
    80001414:	0921                	addi	s2,s2,8
    80001416:	01348963          	beq	s1,s3,80001428 <kfork+0xa4>
    if(p->ofile[i])
    8000141a:	6088                	ld	a0,0(s1)
    8000141c:	d97d                	beqz	a0,80001412 <kfork+0x8e>
      np->ofile[i] = filedup(p->ofile[i]);
    8000141e:	2d2020ef          	jal	800036f0 <filedup>
    80001422:	00a93023          	sd	a0,0(s2)
    80001426:	b7f5                	j	80001412 <kfork+0x8e>
  np->cwd = idup(p->cwd);
    80001428:	150ab503          	ld	a0,336(s5)
    8000142c:	4a4010ef          	jal	800028d0 <idup>
    80001430:	14aa3823          	sd	a0,336(s4)
  safestrcpy(np->name, p->name, sizeof(p->name));
    80001434:	4641                	li	a2,16
    80001436:	158a8593          	addi	a1,s5,344
    8000143a:	158a0513          	addi	a0,s4,344
    8000143e:	fbbfe0ef          	jal	800003f8 <safestrcpy>
  pid = np->pid;
    80001442:	030a2483          	lw	s1,48(s4)
  release(&np->lock);
    80001446:	8552                	mv	a0,s4
    80001448:	057040ef          	jal	80005c9e <release>
  acquire(&wait_lock);
    8000144c:	00226517          	auipc	a0,0x226
    80001450:	4dc50513          	addi	a0,a0,1244 # 80227928 <wait_lock>
    80001454:	7b6040ef          	jal	80005c0a <acquire>
  np->parent = p;
    80001458:	035a3c23          	sd	s5,56(s4)
  release(&wait_lock);
    8000145c:	00226517          	auipc	a0,0x226
    80001460:	4cc50513          	addi	a0,a0,1228 # 80227928 <wait_lock>
    80001464:	03b040ef          	jal	80005c9e <release>
  acquire(&np->lock);
    80001468:	8552                	mv	a0,s4
    8000146a:	7a0040ef          	jal	80005c0a <acquire>
  np->state = RUNNABLE;
    8000146e:	478d                	li	a5,3
    80001470:	00fa2c23          	sw	a5,24(s4)
  release(&np->lock);
    80001474:	8552                	mv	a0,s4
    80001476:	029040ef          	jal	80005c9e <release>
  return pid;
    8000147a:	7902                	ld	s2,32(sp)
    8000147c:	69e2                	ld	s3,24(sp)
    8000147e:	6a42                	ld	s4,16(sp)
}
    80001480:	8526                	mv	a0,s1
    80001482:	70e2                	ld	ra,56(sp)
    80001484:	7442                	ld	s0,48(sp)
    80001486:	74a2                	ld	s1,40(sp)
    80001488:	6aa2                	ld	s5,8(sp)
    8000148a:	6121                	addi	sp,sp,64
    8000148c:	8082                	ret
    return -1;
    8000148e:	54fd                	li	s1,-1
    80001490:	bfc5                	j	80001480 <kfork+0xfc>

0000000080001492 <scheduler>:
{
    80001492:	715d                	addi	sp,sp,-80
    80001494:	e486                	sd	ra,72(sp)
    80001496:	e0a2                	sd	s0,64(sp)
    80001498:	fc26                	sd	s1,56(sp)
    8000149a:	f84a                	sd	s2,48(sp)
    8000149c:	f44e                	sd	s3,40(sp)
    8000149e:	f052                	sd	s4,32(sp)
    800014a0:	ec56                	sd	s5,24(sp)
    800014a2:	e85a                	sd	s6,16(sp)
    800014a4:	e45e                	sd	s7,8(sp)
    800014a6:	e062                	sd	s8,0(sp)
    800014a8:	0880                	addi	s0,sp,80
    800014aa:	8792                	mv	a5,tp
  int id = r_tp();
    800014ac:	2781                	sext.w	a5,a5
  c->proc = 0;
    800014ae:	00779b13          	slli	s6,a5,0x7
    800014b2:	00226717          	auipc	a4,0x226
    800014b6:	45e70713          	addi	a4,a4,1118 # 80227910 <pid_lock>
    800014ba:	975a                	add	a4,a4,s6
    800014bc:	02073823          	sd	zero,48(a4)
        swtch(&c->context, &p->context);
    800014c0:	00226717          	auipc	a4,0x226
    800014c4:	48870713          	addi	a4,a4,1160 # 80227948 <cpus+0x8>
    800014c8:	9b3a                	add	s6,s6,a4
        p->state = RUNNING;
    800014ca:	4c11                	li	s8,4
        c->proc = p;
    800014cc:	079e                	slli	a5,a5,0x7
    800014ce:	00226a17          	auipc	s4,0x226
    800014d2:	442a0a13          	addi	s4,s4,1090 # 80227910 <pid_lock>
    800014d6:	9a3e                	add	s4,s4,a5
        found = 1;
    800014d8:	4b85                	li	s7,1
    800014da:	a83d                	j	80001518 <scheduler+0x86>
      release(&p->lock);
    800014dc:	8526                	mv	a0,s1
    800014de:	7c0040ef          	jal	80005c9e <release>
    for(p = proc; p < &proc[NPROC]; p++) {
    800014e2:	16848493          	addi	s1,s1,360
    800014e6:	03248563          	beq	s1,s2,80001510 <scheduler+0x7e>
      acquire(&p->lock);
    800014ea:	8526                	mv	a0,s1
    800014ec:	71e040ef          	jal	80005c0a <acquire>
      if(p->state == RUNNABLE) {
    800014f0:	4c9c                	lw	a5,24(s1)
    800014f2:	ff3795e3          	bne	a5,s3,800014dc <scheduler+0x4a>
        p->state = RUNNING;
    800014f6:	0184ac23          	sw	s8,24(s1)
        c->proc = p;
    800014fa:	029a3823          	sd	s1,48(s4)
        swtch(&c->context, &p->context);
    800014fe:	06048593          	addi	a1,s1,96
    80001502:	855a                	mv	a0,s6
    80001504:	5ba000ef          	jal	80001abe <swtch>
        c->proc = 0;
    80001508:	020a3823          	sd	zero,48(s4)
        found = 1;
    8000150c:	8ade                	mv	s5,s7
    8000150e:	b7f9                	j	800014dc <scheduler+0x4a>
    if(found == 0) {
    80001510:	000a9463          	bnez	s5,80001518 <scheduler+0x86>
      asm volatile("wfi");
    80001514:	10500073          	wfi
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001518:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    8000151c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001520:	10079073          	csrw	sstatus,a5
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001524:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001528:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    8000152a:	10079073          	csrw	sstatus,a5
    int found = 0;
    8000152e:	4a81                	li	s5,0
    for(p = proc; p < &proc[NPROC]; p++) {
    80001530:	00227497          	auipc	s1,0x227
    80001534:	81048493          	addi	s1,s1,-2032 # 80227d40 <proc>
      if(p->state == RUNNABLE) {
    80001538:	498d                	li	s3,3
    for(p = proc; p < &proc[NPROC]; p++) {
    8000153a:	0022c917          	auipc	s2,0x22c
    8000153e:	20690913          	addi	s2,s2,518 # 8022d740 <tickslock>
    80001542:	b765                	j	800014ea <scheduler+0x58>

0000000080001544 <sched>:
{
    80001544:	7179                	addi	sp,sp,-48
    80001546:	f406                	sd	ra,40(sp)
    80001548:	f022                	sd	s0,32(sp)
    8000154a:	ec26                	sd	s1,24(sp)
    8000154c:	e84a                	sd	s2,16(sp)
    8000154e:	e44e                	sd	s3,8(sp)
    80001550:	1800                	addi	s0,sp,48
  struct proc *p = myproc();
    80001552:	addff0ef          	jal	8000102e <myproc>
    80001556:	84aa                	mv	s1,a0
  if(!holding(&p->lock))
    80001558:	642040ef          	jal	80005b9a <holding>
    8000155c:	c935                	beqz	a0,800015d0 <sched+0x8c>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000155e:	8792                	mv	a5,tp
  if(mycpu()->noff != 1)
    80001560:	2781                	sext.w	a5,a5
    80001562:	079e                	slli	a5,a5,0x7
    80001564:	00226717          	auipc	a4,0x226
    80001568:	3ac70713          	addi	a4,a4,940 # 80227910 <pid_lock>
    8000156c:	97ba                	add	a5,a5,a4
    8000156e:	0a87a703          	lw	a4,168(a5)
    80001572:	4785                	li	a5,1
    80001574:	06f71463          	bne	a4,a5,800015dc <sched+0x98>
  if(p->state == RUNNING)
    80001578:	4c98                	lw	a4,24(s1)
    8000157a:	4791                	li	a5,4
    8000157c:	06f70663          	beq	a4,a5,800015e8 <sched+0xa4>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001580:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001584:	8b89                	andi	a5,a5,2
  if(intr_get())
    80001586:	e7bd                	bnez	a5,800015f4 <sched+0xb0>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001588:	8792                	mv	a5,tp
  intena = mycpu()->intena;
    8000158a:	00226917          	auipc	s2,0x226
    8000158e:	38690913          	addi	s2,s2,902 # 80227910 <pid_lock>
    80001592:	2781                	sext.w	a5,a5
    80001594:	079e                	slli	a5,a5,0x7
    80001596:	97ca                	add	a5,a5,s2
    80001598:	0ac7a983          	lw	s3,172(a5)
    8000159c:	8792                	mv	a5,tp
  swtch(&p->context, &mycpu()->context);
    8000159e:	2781                	sext.w	a5,a5
    800015a0:	079e                	slli	a5,a5,0x7
    800015a2:	07a1                	addi	a5,a5,8
    800015a4:	00226597          	auipc	a1,0x226
    800015a8:	39c58593          	addi	a1,a1,924 # 80227940 <cpus>
    800015ac:	95be                	add	a1,a1,a5
    800015ae:	06048513          	addi	a0,s1,96
    800015b2:	50c000ef          	jal	80001abe <swtch>
    800015b6:	8792                	mv	a5,tp
  mycpu()->intena = intena;
    800015b8:	2781                	sext.w	a5,a5
    800015ba:	079e                	slli	a5,a5,0x7
    800015bc:	993e                	add	s2,s2,a5
    800015be:	0b392623          	sw	s3,172(s2)
}
    800015c2:	70a2                	ld	ra,40(sp)
    800015c4:	7402                	ld	s0,32(sp)
    800015c6:	64e2                	ld	s1,24(sp)
    800015c8:	6942                	ld	s2,16(sp)
    800015ca:	69a2                	ld	s3,8(sp)
    800015cc:	6145                	addi	sp,sp,48
    800015ce:	8082                	ret
    panic("sched p->lock");
    800015d0:	00006517          	auipc	a0,0x6
    800015d4:	bb850513          	addi	a0,a0,-1096 # 80007188 <etext+0x188>
    800015d8:	390040ef          	jal	80005968 <panic>
    panic("sched locks");
    800015dc:	00006517          	auipc	a0,0x6
    800015e0:	bbc50513          	addi	a0,a0,-1092 # 80007198 <etext+0x198>
    800015e4:	384040ef          	jal	80005968 <panic>
    panic("sched RUNNING");
    800015e8:	00006517          	auipc	a0,0x6
    800015ec:	bc050513          	addi	a0,a0,-1088 # 800071a8 <etext+0x1a8>
    800015f0:	378040ef          	jal	80005968 <panic>
    panic("sched interruptible");
    800015f4:	00006517          	auipc	a0,0x6
    800015f8:	bc450513          	addi	a0,a0,-1084 # 800071b8 <etext+0x1b8>
    800015fc:	36c040ef          	jal	80005968 <panic>

0000000080001600 <yield>:
{
    80001600:	1101                	addi	sp,sp,-32
    80001602:	ec06                	sd	ra,24(sp)
    80001604:	e822                	sd	s0,16(sp)
    80001606:	e426                	sd	s1,8(sp)
    80001608:	1000                	addi	s0,sp,32
  struct proc *p = myproc();
    8000160a:	a25ff0ef          	jal	8000102e <myproc>
    8000160e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001610:	5fa040ef          	jal	80005c0a <acquire>
  p->state = RUNNABLE;
    80001614:	478d                	li	a5,3
    80001616:	cc9c                	sw	a5,24(s1)
  sched();
    80001618:	f2dff0ef          	jal	80001544 <sched>
  release(&p->lock);
    8000161c:	8526                	mv	a0,s1
    8000161e:	680040ef          	jal	80005c9e <release>
}
    80001622:	60e2                	ld	ra,24(sp)
    80001624:	6442                	ld	s0,16(sp)
    80001626:	64a2                	ld	s1,8(sp)
    80001628:	6105                	addi	sp,sp,32
    8000162a:	8082                	ret

000000008000162c <sleep>:

// Sleep on channel chan, releasing condition lock lk.
// Re-acquires lk when awakened.
void
sleep(void *chan, struct spinlock *lk)
{
    8000162c:	7179                	addi	sp,sp,-48
    8000162e:	f406                	sd	ra,40(sp)
    80001630:	f022                	sd	s0,32(sp)
    80001632:	ec26                	sd	s1,24(sp)
    80001634:	e84a                	sd	s2,16(sp)
    80001636:	e44e                	sd	s3,8(sp)
    80001638:	1800                	addi	s0,sp,48
    8000163a:	89aa                	mv	s3,a0
    8000163c:	892e                	mv	s2,a1
  struct proc *p = myproc();
    8000163e:	9f1ff0ef          	jal	8000102e <myproc>
    80001642:	84aa                	mv	s1,a0
  // Once we hold p->lock, we can be
  // guaranteed that we won't miss any wakeup
  // (wakeup locks p->lock),
  // so it's okay to release lk.

  acquire(&p->lock);  //DOC: sleeplock1
    80001644:	5c6040ef          	jal	80005c0a <acquire>
  release(lk);
    80001648:	854a                	mv	a0,s2
    8000164a:	654040ef          	jal	80005c9e <release>

  // Go to sleep.
  p->chan = chan;
    8000164e:	0334b023          	sd	s3,32(s1)
  p->state = SLEEPING;
    80001652:	4789                	li	a5,2
    80001654:	cc9c                	sw	a5,24(s1)

  sched();
    80001656:	eefff0ef          	jal	80001544 <sched>

  // Tidy up.
  p->chan = 0;
    8000165a:	0204b023          	sd	zero,32(s1)

  // Reacquire original lock.
  release(&p->lock);
    8000165e:	8526                	mv	a0,s1
    80001660:	63e040ef          	jal	80005c9e <release>
  acquire(lk);
    80001664:	854a                	mv	a0,s2
    80001666:	5a4040ef          	jal	80005c0a <acquire>
}
    8000166a:	70a2                	ld	ra,40(sp)
    8000166c:	7402                	ld	s0,32(sp)
    8000166e:	64e2                	ld	s1,24(sp)
    80001670:	6942                	ld	s2,16(sp)
    80001672:	69a2                	ld	s3,8(sp)
    80001674:	6145                	addi	sp,sp,48
    80001676:	8082                	ret

0000000080001678 <wakeup>:

// Wake up all processes sleeping on channel chan.
// Caller should hold the condition lock.
void
wakeup(void *chan)
{
    80001678:	7139                	addi	sp,sp,-64
    8000167a:	fc06                	sd	ra,56(sp)
    8000167c:	f822                	sd	s0,48(sp)
    8000167e:	f426                	sd	s1,40(sp)
    80001680:	f04a                	sd	s2,32(sp)
    80001682:	ec4e                	sd	s3,24(sp)
    80001684:	e852                	sd	s4,16(sp)
    80001686:	e456                	sd	s5,8(sp)
    80001688:	0080                	addi	s0,sp,64
    8000168a:	8a2a                	mv	s4,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++) {
    8000168c:	00226497          	auipc	s1,0x226
    80001690:	6b448493          	addi	s1,s1,1716 # 80227d40 <proc>
    if(p != myproc()){
      acquire(&p->lock);
      if(p->state == SLEEPING && p->chan == chan) {
    80001694:	4989                	li	s3,2
        p->state = RUNNABLE;
    80001696:	4a8d                	li	s5,3
  for(p = proc; p < &proc[NPROC]; p++) {
    80001698:	0022c917          	auipc	s2,0x22c
    8000169c:	0a890913          	addi	s2,s2,168 # 8022d740 <tickslock>
    800016a0:	a801                	j	800016b0 <wakeup+0x38>
      }
      release(&p->lock);
    800016a2:	8526                	mv	a0,s1
    800016a4:	5fa040ef          	jal	80005c9e <release>
  for(p = proc; p < &proc[NPROC]; p++) {
    800016a8:	16848493          	addi	s1,s1,360
    800016ac:	03248263          	beq	s1,s2,800016d0 <wakeup+0x58>
    if(p != myproc()){
    800016b0:	97fff0ef          	jal	8000102e <myproc>
    800016b4:	fe950ae3          	beq	a0,s1,800016a8 <wakeup+0x30>
      acquire(&p->lock);
    800016b8:	8526                	mv	a0,s1
    800016ba:	550040ef          	jal	80005c0a <acquire>
      if(p->state == SLEEPING && p->chan == chan) {
    800016be:	4c9c                	lw	a5,24(s1)
    800016c0:	ff3791e3          	bne	a5,s3,800016a2 <wakeup+0x2a>
    800016c4:	709c                	ld	a5,32(s1)
    800016c6:	fd479ee3          	bne	a5,s4,800016a2 <wakeup+0x2a>
        p->state = RUNNABLE;
    800016ca:	0154ac23          	sw	s5,24(s1)
    800016ce:	bfd1                	j	800016a2 <wakeup+0x2a>
    }
  }
}
    800016d0:	70e2                	ld	ra,56(sp)
    800016d2:	7442                	ld	s0,48(sp)
    800016d4:	74a2                	ld	s1,40(sp)
    800016d6:	7902                	ld	s2,32(sp)
    800016d8:	69e2                	ld	s3,24(sp)
    800016da:	6a42                	ld	s4,16(sp)
    800016dc:	6aa2                	ld	s5,8(sp)
    800016de:	6121                	addi	sp,sp,64
    800016e0:	8082                	ret

00000000800016e2 <reparent>:
{
    800016e2:	7179                	addi	sp,sp,-48
    800016e4:	f406                	sd	ra,40(sp)
    800016e6:	f022                	sd	s0,32(sp)
    800016e8:	ec26                	sd	s1,24(sp)
    800016ea:	e84a                	sd	s2,16(sp)
    800016ec:	e44e                	sd	s3,8(sp)
    800016ee:	e052                	sd	s4,0(sp)
    800016f0:	1800                	addi	s0,sp,48
    800016f2:	892a                	mv	s2,a0
  for(pp = proc; pp < &proc[NPROC]; pp++){
    800016f4:	00226497          	auipc	s1,0x226
    800016f8:	64c48493          	addi	s1,s1,1612 # 80227d40 <proc>
      pp->parent = initproc;
    800016fc:	00006a17          	auipc	s4,0x6
    80001700:	1d4a0a13          	addi	s4,s4,468 # 800078d0 <initproc>
  for(pp = proc; pp < &proc[NPROC]; pp++){
    80001704:	0022c997          	auipc	s3,0x22c
    80001708:	03c98993          	addi	s3,s3,60 # 8022d740 <tickslock>
    8000170c:	a029                	j	80001716 <reparent+0x34>
    8000170e:	16848493          	addi	s1,s1,360
    80001712:	01348b63          	beq	s1,s3,80001728 <reparent+0x46>
    if(pp->parent == p){
    80001716:	7c9c                	ld	a5,56(s1)
    80001718:	ff279be3          	bne	a5,s2,8000170e <reparent+0x2c>
      pp->parent = initproc;
    8000171c:	000a3503          	ld	a0,0(s4)
    80001720:	fc88                	sd	a0,56(s1)
      wakeup(initproc);
    80001722:	f57ff0ef          	jal	80001678 <wakeup>
    80001726:	b7e5                	j	8000170e <reparent+0x2c>
}
    80001728:	70a2                	ld	ra,40(sp)
    8000172a:	7402                	ld	s0,32(sp)
    8000172c:	64e2                	ld	s1,24(sp)
    8000172e:	6942                	ld	s2,16(sp)
    80001730:	69a2                	ld	s3,8(sp)
    80001732:	6a02                	ld	s4,0(sp)
    80001734:	6145                	addi	sp,sp,48
    80001736:	8082                	ret

0000000080001738 <kexit>:
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
  struct proc *p = myproc();
    8000174a:	8e5ff0ef          	jal	8000102e <myproc>
    8000174e:	89aa                	mv	s3,a0
  if(p == initproc)
    80001750:	00006797          	auipc	a5,0x6
    80001754:	1807b783          	ld	a5,384(a5) # 800078d0 <initproc>
    80001758:	0d050493          	addi	s1,a0,208
    8000175c:	15050913          	addi	s2,a0,336
    80001760:	00a79b63          	bne	a5,a0,80001776 <kexit+0x3e>
    panic("init exiting");
    80001764:	00006517          	auipc	a0,0x6
    80001768:	a6c50513          	addi	a0,a0,-1428 # 800071d0 <etext+0x1d0>
    8000176c:	1fc040ef          	jal	80005968 <panic>
  for(int fd = 0; fd < NOFILE; fd++){
    80001770:	04a1                	addi	s1,s1,8
    80001772:	01248963          	beq	s1,s2,80001784 <kexit+0x4c>
    if(p->ofile[fd]){
    80001776:	6088                	ld	a0,0(s1)
    80001778:	dd65                	beqz	a0,80001770 <kexit+0x38>
      fileclose(f);
    8000177a:	7bd010ef          	jal	80003736 <fileclose>
      p->ofile[fd] = 0;
    8000177e:	0004b023          	sd	zero,0(s1)
    80001782:	b7fd                	j	80001770 <kexit+0x38>
  begin_op();
    80001784:	38f010ef          	jal	80003312 <begin_op>
  iput(p->cwd);
    80001788:	1509b503          	ld	a0,336(s3)
    8000178c:	2fc010ef          	jal	80002a88 <iput>
  end_op();
    80001790:	3f3010ef          	jal	80003382 <end_op>
  p->cwd = 0;
    80001794:	1409b823          	sd	zero,336(s3)
  acquire(&wait_lock);
    80001798:	00226517          	auipc	a0,0x226
    8000179c:	19050513          	addi	a0,a0,400 # 80227928 <wait_lock>
    800017a0:	46a040ef          	jal	80005c0a <acquire>
  reparent(p);
    800017a4:	854e                	mv	a0,s3
    800017a6:	f3dff0ef          	jal	800016e2 <reparent>
  wakeup(p->parent);
    800017aa:	0389b503          	ld	a0,56(s3)
    800017ae:	ecbff0ef          	jal	80001678 <wakeup>
  acquire(&p->lock);
    800017b2:	854e                	mv	a0,s3
    800017b4:	456040ef          	jal	80005c0a <acquire>
  p->xstate = status;
    800017b8:	0349a623          	sw	s4,44(s3)
  p->state = ZOMBIE;
    800017bc:	4795                	li	a5,5
    800017be:	00f9ac23          	sw	a5,24(s3)
  release(&wait_lock);
    800017c2:	00226517          	auipc	a0,0x226
    800017c6:	16650513          	addi	a0,a0,358 # 80227928 <wait_lock>
    800017ca:	4d4040ef          	jal	80005c9e <release>
  sched();
    800017ce:	d77ff0ef          	jal	80001544 <sched>
  panic("zombie exit");
    800017d2:	00006517          	auipc	a0,0x6
    800017d6:	a0e50513          	addi	a0,a0,-1522 # 800071e0 <etext+0x1e0>
    800017da:	18e040ef          	jal	80005968 <panic>

00000000800017de <kkill>:
// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int
kkill(int pid)
{
    800017de:	7179                	addi	sp,sp,-48
    800017e0:	f406                	sd	ra,40(sp)
    800017e2:	f022                	sd	s0,32(sp)
    800017e4:	ec26                	sd	s1,24(sp)
    800017e6:	e84a                	sd	s2,16(sp)
    800017e8:	e44e                	sd	s3,8(sp)
    800017ea:	1800                	addi	s0,sp,48
    800017ec:	892a                	mv	s2,a0
  struct proc *p;

  for(p = proc; p < &proc[NPROC]; p++){
    800017ee:	00226497          	auipc	s1,0x226
    800017f2:	55248493          	addi	s1,s1,1362 # 80227d40 <proc>
    800017f6:	0022c997          	auipc	s3,0x22c
    800017fa:	f4a98993          	addi	s3,s3,-182 # 8022d740 <tickslock>
    acquire(&p->lock);
    800017fe:	8526                	mv	a0,s1
    80001800:	40a040ef          	jal	80005c0a <acquire>
    if(p->pid == pid){
    80001804:	589c                	lw	a5,48(s1)
    80001806:	01278b63          	beq	a5,s2,8000181c <kkill+0x3e>
        p->state = RUNNABLE;
      }
      release(&p->lock);
      return 0;
    }
    release(&p->lock);
    8000180a:	8526                	mv	a0,s1
    8000180c:	492040ef          	jal	80005c9e <release>
  for(p = proc; p < &proc[NPROC]; p++){
    80001810:	16848493          	addi	s1,s1,360
    80001814:	ff3495e3          	bne	s1,s3,800017fe <kkill+0x20>
  }
  return -1;
    80001818:	557d                	li	a0,-1
    8000181a:	a819                	j	80001830 <kkill+0x52>
      p->killed = 1;
    8000181c:	4785                	li	a5,1
    8000181e:	d49c                	sw	a5,40(s1)
      if(p->state == SLEEPING){
    80001820:	4c98                	lw	a4,24(s1)
    80001822:	4789                	li	a5,2
    80001824:	00f70d63          	beq	a4,a5,8000183e <kkill+0x60>
      release(&p->lock);
    80001828:	8526                	mv	a0,s1
    8000182a:	474040ef          	jal	80005c9e <release>
      return 0;
    8000182e:	4501                	li	a0,0
}
    80001830:	70a2                	ld	ra,40(sp)
    80001832:	7402                	ld	s0,32(sp)
    80001834:	64e2                	ld	s1,24(sp)
    80001836:	6942                	ld	s2,16(sp)
    80001838:	69a2                	ld	s3,8(sp)
    8000183a:	6145                	addi	sp,sp,48
    8000183c:	8082                	ret
        p->state = RUNNABLE;
    8000183e:	478d                	li	a5,3
    80001840:	cc9c                	sw	a5,24(s1)
    80001842:	b7dd                	j	80001828 <kkill+0x4a>

0000000080001844 <setkilled>:

void
setkilled(struct proc *p)
{
    80001844:	1101                	addi	sp,sp,-32
    80001846:	ec06                	sd	ra,24(sp)
    80001848:	e822                	sd	s0,16(sp)
    8000184a:	e426                	sd	s1,8(sp)
    8000184c:	1000                	addi	s0,sp,32
    8000184e:	84aa                	mv	s1,a0
  acquire(&p->lock);
    80001850:	3ba040ef          	jal	80005c0a <acquire>
  p->killed = 1;
    80001854:	4785                	li	a5,1
    80001856:	d49c                	sw	a5,40(s1)
  release(&p->lock);
    80001858:	8526                	mv	a0,s1
    8000185a:	444040ef          	jal	80005c9e <release>
}
    8000185e:	60e2                	ld	ra,24(sp)
    80001860:	6442                	ld	s0,16(sp)
    80001862:	64a2                	ld	s1,8(sp)
    80001864:	6105                	addi	sp,sp,32
    80001866:	8082                	ret

0000000080001868 <killed>:

int
killed(struct proc *p)
{
    80001868:	1101                	addi	sp,sp,-32
    8000186a:	ec06                	sd	ra,24(sp)
    8000186c:	e822                	sd	s0,16(sp)
    8000186e:	e426                	sd	s1,8(sp)
    80001870:	e04a                	sd	s2,0(sp)
    80001872:	1000                	addi	s0,sp,32
    80001874:	84aa                	mv	s1,a0
  int k;
  
  acquire(&p->lock);
    80001876:	394040ef          	jal	80005c0a <acquire>
  k = p->killed;
    8000187a:	549c                	lw	a5,40(s1)
    8000187c:	893e                	mv	s2,a5
  release(&p->lock);
    8000187e:	8526                	mv	a0,s1
    80001880:	41e040ef          	jal	80005c9e <release>
  return k;
}
    80001884:	854a                	mv	a0,s2
    80001886:	60e2                	ld	ra,24(sp)
    80001888:	6442                	ld	s0,16(sp)
    8000188a:	64a2                	ld	s1,8(sp)
    8000188c:	6902                	ld	s2,0(sp)
    8000188e:	6105                	addi	sp,sp,32
    80001890:	8082                	ret

0000000080001892 <kwait>:
{
    80001892:	715d                	addi	sp,sp,-80
    80001894:	e486                	sd	ra,72(sp)
    80001896:	e0a2                	sd	s0,64(sp)
    80001898:	fc26                	sd	s1,56(sp)
    8000189a:	f84a                	sd	s2,48(sp)
    8000189c:	f44e                	sd	s3,40(sp)
    8000189e:	f052                	sd	s4,32(sp)
    800018a0:	ec56                	sd	s5,24(sp)
    800018a2:	e85a                	sd	s6,16(sp)
    800018a4:	e45e                	sd	s7,8(sp)
    800018a6:	0880                	addi	s0,sp,80
    800018a8:	8baa                	mv	s7,a0
  struct proc *p = myproc();
    800018aa:	f84ff0ef          	jal	8000102e <myproc>
    800018ae:	892a                	mv	s2,a0
  acquire(&wait_lock);
    800018b0:	00226517          	auipc	a0,0x226
    800018b4:	07850513          	addi	a0,a0,120 # 80227928 <wait_lock>
    800018b8:	352040ef          	jal	80005c0a <acquire>
        if(pp->state == ZOMBIE){
    800018bc:	4a15                	li	s4,5
        havekids = 1;
    800018be:	4a85                	li	s5,1
    for(pp = proc; pp < &proc[NPROC]; pp++){
    800018c0:	0022c997          	auipc	s3,0x22c
    800018c4:	e8098993          	addi	s3,s3,-384 # 8022d740 <tickslock>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    800018c8:	00226b17          	auipc	s6,0x226
    800018cc:	060b0b13          	addi	s6,s6,96 # 80227928 <wait_lock>
    800018d0:	a869                	j	8000196a <kwait+0xd8>
          pid = pp->pid;
    800018d2:	0304a983          	lw	s3,48(s1)
          if(addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    800018d6:	000b8c63          	beqz	s7,800018ee <kwait+0x5c>
    800018da:	4691                	li	a3,4
    800018dc:	02c48613          	addi	a2,s1,44
    800018e0:	85de                	mv	a1,s7
    800018e2:	05093503          	ld	a0,80(s2)
    800018e6:	c50ff0ef          	jal	80000d36 <copyout>
    800018ea:	02054a63          	bltz	a0,8000191e <kwait+0x8c>
          freeproc(pp);
    800018ee:	8526                	mv	a0,s1
    800018f0:	913ff0ef          	jal	80001202 <freeproc>
          release(&pp->lock);
    800018f4:	8526                	mv	a0,s1
    800018f6:	3a8040ef          	jal	80005c9e <release>
          release(&wait_lock);
    800018fa:	00226517          	auipc	a0,0x226
    800018fe:	02e50513          	addi	a0,a0,46 # 80227928 <wait_lock>
    80001902:	39c040ef          	jal	80005c9e <release>
}
    80001906:	854e                	mv	a0,s3
    80001908:	60a6                	ld	ra,72(sp)
    8000190a:	6406                	ld	s0,64(sp)
    8000190c:	74e2                	ld	s1,56(sp)
    8000190e:	7942                	ld	s2,48(sp)
    80001910:	79a2                	ld	s3,40(sp)
    80001912:	7a02                	ld	s4,32(sp)
    80001914:	6ae2                	ld	s5,24(sp)
    80001916:	6b42                	ld	s6,16(sp)
    80001918:	6ba2                	ld	s7,8(sp)
    8000191a:	6161                	addi	sp,sp,80
    8000191c:	8082                	ret
            release(&pp->lock);
    8000191e:	8526                	mv	a0,s1
    80001920:	37e040ef          	jal	80005c9e <release>
            release(&wait_lock);
    80001924:	00226517          	auipc	a0,0x226
    80001928:	00450513          	addi	a0,a0,4 # 80227928 <wait_lock>
    8000192c:	372040ef          	jal	80005c9e <release>
            return -1;
    80001930:	59fd                	li	s3,-1
    80001932:	bfd1                	j	80001906 <kwait+0x74>
    for(pp = proc; pp < &proc[NPROC]; pp++){
    80001934:	16848493          	addi	s1,s1,360
    80001938:	03348063          	beq	s1,s3,80001958 <kwait+0xc6>
      if(pp->parent == p){
    8000193c:	7c9c                	ld	a5,56(s1)
    8000193e:	ff279be3          	bne	a5,s2,80001934 <kwait+0xa2>
        acquire(&pp->lock);
    80001942:	8526                	mv	a0,s1
    80001944:	2c6040ef          	jal	80005c0a <acquire>
        if(pp->state == ZOMBIE){
    80001948:	4c9c                	lw	a5,24(s1)
    8000194a:	f94784e3          	beq	a5,s4,800018d2 <kwait+0x40>
        release(&pp->lock);
    8000194e:	8526                	mv	a0,s1
    80001950:	34e040ef          	jal	80005c9e <release>
        havekids = 1;
    80001954:	8756                	mv	a4,s5
    80001956:	bff9                	j	80001934 <kwait+0xa2>
    if(!havekids || killed(p)){
    80001958:	cf19                	beqz	a4,80001976 <kwait+0xe4>
    8000195a:	854a                	mv	a0,s2
    8000195c:	f0dff0ef          	jal	80001868 <killed>
    80001960:	e919                	bnez	a0,80001976 <kwait+0xe4>
    sleep(p, &wait_lock);  //DOC: wait-sleep
    80001962:	85da                	mv	a1,s6
    80001964:	854a                	mv	a0,s2
    80001966:	cc7ff0ef          	jal	8000162c <sleep>
    havekids = 0;
    8000196a:	4701                	li	a4,0
    for(pp = proc; pp < &proc[NPROC]; pp++){
    8000196c:	00226497          	auipc	s1,0x226
    80001970:	3d448493          	addi	s1,s1,980 # 80227d40 <proc>
    80001974:	b7e1                	j	8000193c <kwait+0xaa>
      release(&wait_lock);
    80001976:	00226517          	auipc	a0,0x226
    8000197a:	fb250513          	addi	a0,a0,-78 # 80227928 <wait_lock>
    8000197e:	320040ef          	jal	80005c9e <release>
      return -1;
    80001982:	59fd                	li	s3,-1
    80001984:	b749                	j	80001906 <kwait+0x74>

0000000080001986 <either_copyout>:
// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int
either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001986:	7179                	addi	sp,sp,-48
    80001988:	f406                	sd	ra,40(sp)
    8000198a:	f022                	sd	s0,32(sp)
    8000198c:	ec26                	sd	s1,24(sp)
    8000198e:	e84a                	sd	s2,16(sp)
    80001990:	e44e                	sd	s3,8(sp)
    80001992:	e052                	sd	s4,0(sp)
    80001994:	1800                	addi	s0,sp,48
    80001996:	84aa                	mv	s1,a0
    80001998:	8a2e                	mv	s4,a1
    8000199a:	89b2                	mv	s3,a2
    8000199c:	8936                	mv	s2,a3
  struct proc *p = myproc();
    8000199e:	e90ff0ef          	jal	8000102e <myproc>
  if(user_dst){
    800019a2:	cc99                	beqz	s1,800019c0 <either_copyout+0x3a>
    return copyout(p->pagetable, dst, src, len);
    800019a4:	86ca                	mv	a3,s2
    800019a6:	864e                	mv	a2,s3
    800019a8:	85d2                	mv	a1,s4
    800019aa:	6928                	ld	a0,80(a0)
    800019ac:	b8aff0ef          	jal	80000d36 <copyout>
  } else {
    memmove((char *)dst, src, len);
    return 0;
  }
}
    800019b0:	70a2                	ld	ra,40(sp)
    800019b2:	7402                	ld	s0,32(sp)
    800019b4:	64e2                	ld	s1,24(sp)
    800019b6:	6942                	ld	s2,16(sp)
    800019b8:	69a2                	ld	s3,8(sp)
    800019ba:	6a02                	ld	s4,0(sp)
    800019bc:	6145                	addi	sp,sp,48
    800019be:	8082                	ret
    memmove((char *)dst, src, len);
    800019c0:	0009061b          	sext.w	a2,s2
    800019c4:	85ce                	mv	a1,s3
    800019c6:	8552                	mv	a0,s4
    800019c8:	93dfe0ef          	jal	80000304 <memmove>
    return 0;
    800019cc:	8526                	mv	a0,s1
    800019ce:	b7cd                	j	800019b0 <either_copyout+0x2a>

00000000800019d0 <either_copyin>:
// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int
either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019d0:	7179                	addi	sp,sp,-48
    800019d2:	f406                	sd	ra,40(sp)
    800019d4:	f022                	sd	s0,32(sp)
    800019d6:	ec26                	sd	s1,24(sp)
    800019d8:	e84a                	sd	s2,16(sp)
    800019da:	e44e                	sd	s3,8(sp)
    800019dc:	e052                	sd	s4,0(sp)
    800019de:	1800                	addi	s0,sp,48
    800019e0:	8a2a                	mv	s4,a0
    800019e2:	84ae                	mv	s1,a1
    800019e4:	89b2                	mv	s3,a2
    800019e6:	8936                	mv	s2,a3
  struct proc *p = myproc();
    800019e8:	e46ff0ef          	jal	8000102e <myproc>
  if(user_src){
    800019ec:	cc99                	beqz	s1,80001a0a <either_copyin+0x3a>
    return copyin(p->pagetable, dst, src, len);
    800019ee:	86ca                	mv	a3,s2
    800019f0:	864e                	mv	a2,s3
    800019f2:	85d2                	mv	a1,s4
    800019f4:	6928                	ld	a0,80(a0)
    800019f6:	c1cff0ef          	jal	80000e12 <copyin>
  } else {
    memmove(dst, (char*)src, len);
    return 0;
  }
}
    800019fa:	70a2                	ld	ra,40(sp)
    800019fc:	7402                	ld	s0,32(sp)
    800019fe:	64e2                	ld	s1,24(sp)
    80001a00:	6942                	ld	s2,16(sp)
    80001a02:	69a2                	ld	s3,8(sp)
    80001a04:	6a02                	ld	s4,0(sp)
    80001a06:	6145                	addi	sp,sp,48
    80001a08:	8082                	ret
    memmove(dst, (char*)src, len);
    80001a0a:	0009061b          	sext.w	a2,s2
    80001a0e:	85ce                	mv	a1,s3
    80001a10:	8552                	mv	a0,s4
    80001a12:	8f3fe0ef          	jal	80000304 <memmove>
    return 0;
    80001a16:	8526                	mv	a0,s1
    80001a18:	b7cd                	j	800019fa <either_copyin+0x2a>

0000000080001a1a <procdump>:
// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void
procdump(void)
{
    80001a1a:	715d                	addi	sp,sp,-80
    80001a1c:	e486                	sd	ra,72(sp)
    80001a1e:	e0a2                	sd	s0,64(sp)
    80001a20:	fc26                	sd	s1,56(sp)
    80001a22:	f84a                	sd	s2,48(sp)
    80001a24:	f44e                	sd	s3,40(sp)
    80001a26:	f052                	sd	s4,32(sp)
    80001a28:	ec56                	sd	s5,24(sp)
    80001a2a:	e85a                	sd	s6,16(sp)
    80001a2c:	e45e                	sd	s7,8(sp)
    80001a2e:	0880                	addi	s0,sp,80
  [ZOMBIE]    "zombie"
  };
  struct proc *p;
  char *state;

  printf("\n");
    80001a30:	00005517          	auipc	a0,0x5
    80001a34:	64050513          	addi	a0,a0,1600 # 80007070 <etext+0x70>
    80001a38:	385030ef          	jal	800055bc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a3c:	00226497          	auipc	s1,0x226
    80001a40:	45c48493          	addi	s1,s1,1116 # 80227e98 <proc+0x158>
    80001a44:	0022c917          	auipc	s2,0x22c
    80001a48:	e5490913          	addi	s2,s2,-428 # 8022d898 <bcache+0x140>
    if(p->state == UNUSED)
      continue;
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a4c:	4b15                	li	s6,5
      state = states[p->state];
    else
      state = "???";
    80001a4e:	00005997          	auipc	s3,0x5
    80001a52:	7a298993          	addi	s3,s3,1954 # 800071f0 <etext+0x1f0>
    printf("%d %s %s", p->pid, state, p->name);
    80001a56:	00005a97          	auipc	s5,0x5
    80001a5a:	7a2a8a93          	addi	s5,s5,1954 # 800071f8 <etext+0x1f8>
    printf("\n");
    80001a5e:	00005a17          	auipc	s4,0x5
    80001a62:	612a0a13          	addi	s4,s4,1554 # 80007070 <etext+0x70>
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a66:	00006b97          	auipc	s7,0x6
    80001a6a:	d32b8b93          	addi	s7,s7,-718 # 80007798 <states.0>
    80001a6e:	a829                	j	80001a88 <procdump+0x6e>
    printf("%d %s %s", p->pid, state, p->name);
    80001a70:	ed86a583          	lw	a1,-296(a3)
    80001a74:	8556                	mv	a0,s5
    80001a76:	347030ef          	jal	800055bc <printf>
    printf("\n");
    80001a7a:	8552                	mv	a0,s4
    80001a7c:	341030ef          	jal	800055bc <printf>
  for(p = proc; p < &proc[NPROC]; p++){
    80001a80:	16848493          	addi	s1,s1,360
    80001a84:	03248263          	beq	s1,s2,80001aa8 <procdump+0x8e>
    if(p->state == UNUSED)
    80001a88:	86a6                	mv	a3,s1
    80001a8a:	ec04a783          	lw	a5,-320(s1)
    80001a8e:	dbed                	beqz	a5,80001a80 <procdump+0x66>
      state = "???";
    80001a90:	864e                	mv	a2,s3
    if(p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a92:	fcfb6fe3          	bltu	s6,a5,80001a70 <procdump+0x56>
    80001a96:	02079713          	slli	a4,a5,0x20
    80001a9a:	01d75793          	srli	a5,a4,0x1d
    80001a9e:	97de                	add	a5,a5,s7
    80001aa0:	6390                	ld	a2,0(a5)
    80001aa2:	f679                	bnez	a2,80001a70 <procdump+0x56>
      state = "???";
    80001aa4:	864e                	mv	a2,s3
    80001aa6:	b7e9                	j	80001a70 <procdump+0x56>
  }
}
    80001aa8:	60a6                	ld	ra,72(sp)
    80001aaa:	6406                	ld	s0,64(sp)
    80001aac:	74e2                	ld	s1,56(sp)
    80001aae:	7942                	ld	s2,48(sp)
    80001ab0:	79a2                	ld	s3,40(sp)
    80001ab2:	7a02                	ld	s4,32(sp)
    80001ab4:	6ae2                	ld	s5,24(sp)
    80001ab6:	6b42                	ld	s6,16(sp)
    80001ab8:	6ba2                	ld	s7,8(sp)
    80001aba:	6161                	addi	sp,sp,80
    80001abc:	8082                	ret

0000000080001abe <swtch>:
# Save current registers in old. Load from new.	


.globl swtch
swtch:
        sd ra, 0(a0)
    80001abe:	00153023          	sd	ra,0(a0)
        sd sp, 8(a0)
    80001ac2:	00253423          	sd	sp,8(a0)
        sd s0, 16(a0)
    80001ac6:	e900                	sd	s0,16(a0)
        sd s1, 24(a0)
    80001ac8:	ed04                	sd	s1,24(a0)
        sd s2, 32(a0)
    80001aca:	03253023          	sd	s2,32(a0)
        sd s3, 40(a0)
    80001ace:	03353423          	sd	s3,40(a0)
        sd s4, 48(a0)
    80001ad2:	03453823          	sd	s4,48(a0)
        sd s5, 56(a0)
    80001ad6:	03553c23          	sd	s5,56(a0)
        sd s6, 64(a0)
    80001ada:	05653023          	sd	s6,64(a0)
        sd s7, 72(a0)
    80001ade:	05753423          	sd	s7,72(a0)
        sd s8, 80(a0)
    80001ae2:	05853823          	sd	s8,80(a0)
        sd s9, 88(a0)
    80001ae6:	05953c23          	sd	s9,88(a0)
        sd s10, 96(a0)
    80001aea:	07a53023          	sd	s10,96(a0)
        sd s11, 104(a0)
    80001aee:	07b53423          	sd	s11,104(a0)

        ld ra, 0(a1)
    80001af2:	0005b083          	ld	ra,0(a1)
        ld sp, 8(a1)
    80001af6:	0085b103          	ld	sp,8(a1)
        ld s0, 16(a1)
    80001afa:	6980                	ld	s0,16(a1)
        ld s1, 24(a1)
    80001afc:	6d84                	ld	s1,24(a1)
        ld s2, 32(a1)
    80001afe:	0205b903          	ld	s2,32(a1)
        ld s3, 40(a1)
    80001b02:	0285b983          	ld	s3,40(a1)
        ld s4, 48(a1)
    80001b06:	0305ba03          	ld	s4,48(a1)
        ld s5, 56(a1)
    80001b0a:	0385ba83          	ld	s5,56(a1)
        ld s6, 64(a1)
    80001b0e:	0405bb03          	ld	s6,64(a1)
        ld s7, 72(a1)
    80001b12:	0485bb83          	ld	s7,72(a1)
        ld s8, 80(a1)
    80001b16:	0505bc03          	ld	s8,80(a1)
        ld s9, 88(a1)
    80001b1a:	0585bc83          	ld	s9,88(a1)
        ld s10, 96(a1)
    80001b1e:	0605bd03          	ld	s10,96(a1)
        ld s11, 104(a1)
    80001b22:	0685bd83          	ld	s11,104(a1)
        
        ret
    80001b26:	8082                	ret

0000000080001b28 <trapinit>:

extern int devintr();

void
trapinit(void)
{
    80001b28:	1141                	addi	sp,sp,-16
    80001b2a:	e406                	sd	ra,8(sp)
    80001b2c:	e022                	sd	s0,0(sp)
    80001b2e:	0800                	addi	s0,sp,16
  initlock(&tickslock, "time");
    80001b30:	00005597          	auipc	a1,0x5
    80001b34:	70858593          	addi	a1,a1,1800 # 80007238 <etext+0x238>
    80001b38:	0022c517          	auipc	a0,0x22c
    80001b3c:	c0850513          	addi	a0,a0,-1016 # 8022d740 <tickslock>
    80001b40:	040040ef          	jal	80005b80 <initlock>
}
    80001b44:	60a2                	ld	ra,8(sp)
    80001b46:	6402                	ld	s0,0(sp)
    80001b48:	0141                	addi	sp,sp,16
    80001b4a:	8082                	ret

0000000080001b4c <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void
trapinithart(void)
{
    80001b4c:	1141                	addi	sp,sp,-16
    80001b4e:	e406                	sd	ra,8(sp)
    80001b50:	e022                	sd	s0,0(sp)
    80001b52:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b54:	00003797          	auipc	a5,0x3
    80001b58:	f9c78793          	addi	a5,a5,-100 # 80004af0 <kernelvec>
    80001b5c:	10579073          	csrw	stvec,a5
  w_stvec((uint64)kernelvec);
}
    80001b60:	60a2                	ld	ra,8(sp)
    80001b62:	6402                	ld	s0,0(sp)
    80001b64:	0141                	addi	sp,sp,16
    80001b66:	8082                	ret

0000000080001b68 <prepare_return>:
//
// set up trapframe and control registers for a return to user space
//
void
prepare_return(void)
{
    80001b68:	1141                	addi	sp,sp,-16
    80001b6a:	e406                	sd	ra,8(sp)
    80001b6c:	e022                	sd	s0,0(sp)
    80001b6e:	0800                	addi	s0,sp,16
  struct proc *p = myproc();
    80001b70:	cbeff0ef          	jal	8000102e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b74:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b78:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7a:	10079073          	csrw	sstatus,a5
  // kerneltrap() to usertrap(). because a trap from kernel
  // code to usertrap would be a disaster, turn off interrupts.
  intr_off();

  // send syscalls, interrupts, and exceptions to uservec in trampoline.S
  uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b7e:	04000737          	lui	a4,0x4000
    80001b82:	177d                	addi	a4,a4,-1 # 3ffffff <_entry-0x7c000001>
    80001b84:	0732                	slli	a4,a4,0xc
    80001b86:	00004797          	auipc	a5,0x4
    80001b8a:	47a78793          	addi	a5,a5,1146 # 80006000 <_trampoline>
    80001b8e:	00004697          	auipc	a3,0x4
    80001b92:	47268693          	addi	a3,a3,1138 # 80006000 <_trampoline>
    80001b96:	8f95                	sub	a5,a5,a3
    80001b98:	97ba                	add	a5,a5,a4
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b9a:	10579073          	csrw	stvec,a5
  w_stvec(trampoline_uservec);

  // set up trapframe values that uservec will need when
  // the process next traps into the kernel.
  p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b9e:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001ba0:	18002773          	csrr	a4,satp
    80001ba4:	e398                	sd	a4,0(a5)
  p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001ba6:	6d38                	ld	a4,88(a0)
    80001ba8:	613c                	ld	a5,64(a0)
    80001baa:	6685                	lui	a3,0x1
    80001bac:	97b6                	add	a5,a5,a3
    80001bae:	e71c                	sd	a5,8(a4)
  p->trapframe->kernel_trap = (uint64)usertrap;
    80001bb0:	6d3c                	ld	a5,88(a0)
    80001bb2:	00000717          	auipc	a4,0x0
    80001bb6:	0fc70713          	addi	a4,a4,252 # 80001cae <usertrap>
    80001bba:	eb98                	sd	a4,16(a5)
  p->trapframe->kernel_hartid = r_tp();         // hartid for cpuid()
    80001bbc:	6d3c                	ld	a5,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bbe:	8712                	mv	a4,tp
    80001bc0:	f398                	sd	a4,32(a5)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bc2:	100027f3          	csrr	a5,sstatus
  // set up the registers that trampoline.S's sret will use
  // to get to user space.
  
  // set S Previous Privilege mode to User.
  unsigned long x = r_sstatus();
  x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bc6:	eff7f793          	andi	a5,a5,-257
  x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bca:	0207e793          	ori	a5,a5,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bce:	10079073          	csrw	sstatus,a5
  w_sstatus(x);

  // set S Exception Program Counter to the saved user pc.
  w_sepc(p->trapframe->epc);
    80001bd2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bd4:	6f9c                	ld	a5,24(a5)
    80001bd6:	14179073          	csrw	sepc,a5
}
    80001bda:	60a2                	ld	ra,8(sp)
    80001bdc:	6402                	ld	s0,0(sp)
    80001bde:	0141                	addi	sp,sp,16
    80001be0:	8082                	ret

0000000080001be2 <clockintr>:
  w_sstatus(sstatus);
}

void
clockintr()
{
    80001be2:	1141                	addi	sp,sp,-16
    80001be4:	e406                	sd	ra,8(sp)
    80001be6:	e022                	sd	s0,0(sp)
    80001be8:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    80001bea:	c10ff0ef          	jal	80000ffa <cpuid>
    80001bee:	cd11                	beqz	a0,80001c0a <clockintr+0x28>
  asm volatile("csrr %0, time" : "=r" (x) );
    80001bf0:	c01027f3          	rdtime	a5
  }

  // ask for the next timer interrupt. this also clears
  // the interrupt request. 1000000 is about a tenth
  // of a second.
  w_stimecmp(r_time() + 1000000);
    80001bf4:	000f4737          	lui	a4,0xf4
    80001bf8:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80001bfc:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    80001bfe:	14d79073          	csrw	stimecmp,a5
}
    80001c02:	60a2                	ld	ra,8(sp)
    80001c04:	6402                	ld	s0,0(sp)
    80001c06:	0141                	addi	sp,sp,16
    80001c08:	8082                	ret
    acquire(&tickslock);
    80001c0a:	0022c517          	auipc	a0,0x22c
    80001c0e:	b3650513          	addi	a0,a0,-1226 # 8022d740 <tickslock>
    80001c12:	7f9030ef          	jal	80005c0a <acquire>
    ticks++;
    80001c16:	00006717          	auipc	a4,0x6
    80001c1a:	cc270713          	addi	a4,a4,-830 # 800078d8 <ticks>
    80001c1e:	431c                	lw	a5,0(a4)
    80001c20:	2785                	addiw	a5,a5,1
    80001c22:	c31c                	sw	a5,0(a4)
    wakeup(&ticks);
    80001c24:	853a                	mv	a0,a4
    80001c26:	a53ff0ef          	jal	80001678 <wakeup>
    release(&tickslock);
    80001c2a:	0022c517          	auipc	a0,0x22c
    80001c2e:	b1650513          	addi	a0,a0,-1258 # 8022d740 <tickslock>
    80001c32:	06c040ef          	jal	80005c9e <release>
    80001c36:	bf6d                	j	80001bf0 <clockintr+0xe>

0000000080001c38 <devintr>:
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int
devintr()
{
    80001c38:	1101                	addi	sp,sp,-32
    80001c3a:	ec06                	sd	ra,24(sp)
    80001c3c:	e822                	sd	s0,16(sp)
    80001c3e:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c40:	14202773          	csrr	a4,scause
  uint64 scause = r_scause();

  if(scause == 0x8000000000000009L){
    80001c44:	57fd                	li	a5,-1
    80001c46:	17fe                	slli	a5,a5,0x3f
    80001c48:	07a5                	addi	a5,a5,9
    80001c4a:	00f70c63          	beq	a4,a5,80001c62 <devintr+0x2a>
    // now allowed to interrupt again.
    if(irq)
      plic_complete(irq);

    return 1;
  } else if(scause == 0x8000000000000005L){
    80001c4e:	57fd                	li	a5,-1
    80001c50:	17fe                	slli	a5,a5,0x3f
    80001c52:	0795                	addi	a5,a5,5
    // timer interrupt.
    clockintr();
    return 2;
  } else {
    return 0;
    80001c54:	4501                	li	a0,0
  } else if(scause == 0x8000000000000005L){
    80001c56:	04f70863          	beq	a4,a5,80001ca6 <devintr+0x6e>
  }
}
    80001c5a:	60e2                	ld	ra,24(sp)
    80001c5c:	6442                	ld	s0,16(sp)
    80001c5e:	6105                	addi	sp,sp,32
    80001c60:	8082                	ret
    80001c62:	e426                	sd	s1,8(sp)
    int irq = plic_claim();
    80001c64:	739020ef          	jal	80004b9c <plic_claim>
    80001c68:	872a                	mv	a4,a0
    80001c6a:	84aa                	mv	s1,a0
    if(irq == UART0_IRQ){
    80001c6c:	47a9                	li	a5,10
    80001c6e:	00f50963          	beq	a0,a5,80001c80 <devintr+0x48>
    } else if(irq == VIRTIO0_IRQ){
    80001c72:	4785                	li	a5,1
    80001c74:	00f50963          	beq	a0,a5,80001c86 <devintr+0x4e>
    return 1;
    80001c78:	4505                	li	a0,1
    } else if(irq){
    80001c7a:	eb09                	bnez	a4,80001c8c <devintr+0x54>
    80001c7c:	64a2                	ld	s1,8(sp)
    80001c7e:	bff1                	j	80001c5a <devintr+0x22>
      uartintr();
    80001c80:	699030ef          	jal	80005b18 <uartintr>
    if(irq)
    80001c84:	a819                	j	80001c9a <devintr+0x62>
      virtio_disk_intr();
    80001c86:	3ac030ef          	jal	80005032 <virtio_disk_intr>
    if(irq)
    80001c8a:	a801                	j	80001c9a <devintr+0x62>
      printf("unexpected interrupt irq=%d\n", irq);
    80001c8c:	85ba                	mv	a1,a4
    80001c8e:	00005517          	auipc	a0,0x5
    80001c92:	5b250513          	addi	a0,a0,1458 # 80007240 <etext+0x240>
    80001c96:	127030ef          	jal	800055bc <printf>
      plic_complete(irq);
    80001c9a:	8526                	mv	a0,s1
    80001c9c:	721020ef          	jal	80004bbc <plic_complete>
    return 1;
    80001ca0:	4505                	li	a0,1
    80001ca2:	64a2                	ld	s1,8(sp)
    80001ca4:	bf5d                	j	80001c5a <devintr+0x22>
    clockintr();
    80001ca6:	f3dff0ef          	jal	80001be2 <clockintr>
    return 2;
    80001caa:	4509                	li	a0,2
    80001cac:	b77d                	j	80001c5a <devintr+0x22>

0000000080001cae <usertrap>:
{
    80001cae:	1101                	addi	sp,sp,-32
    80001cb0:	ec06                	sd	ra,24(sp)
    80001cb2:	e822                	sd	s0,16(sp)
    80001cb4:	e426                	sd	s1,8(sp)
    80001cb6:	e04a                	sd	s2,0(sp)
    80001cb8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cba:	100027f3          	csrr	a5,sstatus
  if((r_sstatus() & SSTATUS_SPP) != 0)
    80001cbe:	1007f793          	andi	a5,a5,256
    80001cc2:	e3c1                	bnez	a5,80001d42 <usertrap+0x94>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cc4:	00003797          	auipc	a5,0x3
    80001cc8:	e2c78793          	addi	a5,a5,-468 # 80004af0 <kernelvec>
    80001ccc:	10579073          	csrw	stvec,a5
  struct proc *p = myproc();
    80001cd0:	b5eff0ef          	jal	8000102e <myproc>
    80001cd4:	84aa                	mv	s1,a0
  p->trapframe->epc = r_sepc();
    80001cd6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cd8:	14102773          	csrr	a4,sepc
    80001cdc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cde:	14202773          	csrr	a4,scause
  if(r_scause() == 8){
    80001ce2:	47a1                	li	a5,8
    80001ce4:	06f70563          	beq	a4,a5,80001d4e <usertrap+0xa0>
  } else if((which_dev = devintr()) != 0){
    80001ce8:	f51ff0ef          	jal	80001c38 <devintr>
    80001cec:	892a                	mv	s2,a0
    80001cee:	e161                	bnez	a0,80001dae <usertrap+0x100>
    80001cf0:	14202773          	csrr	a4,scause
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001cf4:	47bd                	li	a5,15
    80001cf6:	0af70063          	beq	a4,a5,80001d96 <usertrap+0xe8>
    80001cfa:	14202773          	csrr	a4,scause
    80001cfe:	47b5                	li	a5,13
    80001d00:	08f70b63          	beq	a4,a5,80001d96 <usertrap+0xe8>
    80001d04:	142025f3          	csrr	a1,scause
    printf("usertrap(): unexpected scause 0x%lx pid=%d\n", r_scause(), p->pid);
    80001d08:	5890                	lw	a2,48(s1)
    80001d0a:	00005517          	auipc	a0,0x5
    80001d0e:	57650513          	addi	a0,a0,1398 # 80007280 <etext+0x280>
    80001d12:	0ab030ef          	jal	800055bc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d16:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d1a:	14302673          	csrr	a2,stval
    printf("            sepc=0x%lx stval=0x%lx\n", r_sepc(), r_stval());
    80001d1e:	00005517          	auipc	a0,0x5
    80001d22:	59250513          	addi	a0,a0,1426 # 800072b0 <etext+0x2b0>
    80001d26:	097030ef          	jal	800055bc <printf>
    printf("            process name=%s\n", p->name);
    80001d2a:	15848593          	addi	a1,s1,344
    80001d2e:	00005517          	auipc	a0,0x5
    80001d32:	5aa50513          	addi	a0,a0,1450 # 800072d8 <etext+0x2d8>
    80001d36:	087030ef          	jal	800055bc <printf>
    setkilled(p);
    80001d3a:	8526                	mv	a0,s1
    80001d3c:	b09ff0ef          	jal	80001844 <setkilled>
    80001d40:	a035                	j	80001d6c <usertrap+0xbe>
    panic("usertrap: not from user mode");
    80001d42:	00005517          	auipc	a0,0x5
    80001d46:	51e50513          	addi	a0,a0,1310 # 80007260 <etext+0x260>
    80001d4a:	41f030ef          	jal	80005968 <panic>
    if(killed(p))
    80001d4e:	b1bff0ef          	jal	80001868 <killed>
    80001d52:	ed15                	bnez	a0,80001d8e <usertrap+0xe0>
    p->trapframe->epc += 4;
    80001d54:	6cb8                	ld	a4,88(s1)
    80001d56:	6f1c                	ld	a5,24(a4)
    80001d58:	0791                	addi	a5,a5,4
    80001d5a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d60:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d64:	10079073          	csrw	sstatus,a5
    syscall();
    80001d68:	240000ef          	jal	80001fa8 <syscall>
  if(killed(p))
    80001d6c:	8526                	mv	a0,s1
    80001d6e:	afbff0ef          	jal	80001868 <killed>
    80001d72:	e139                	bnez	a0,80001db8 <usertrap+0x10a>
  prepare_return();
    80001d74:	df5ff0ef          	jal	80001b68 <prepare_return>
  uint64 satp = MAKE_SATP(p->pagetable);
    80001d78:	68a8                	ld	a0,80(s1)
    80001d7a:	8131                	srli	a0,a0,0xc
    80001d7c:	57fd                	li	a5,-1
    80001d7e:	17fe                	slli	a5,a5,0x3f
    80001d80:	8d5d                	or	a0,a0,a5
}
    80001d82:	60e2                	ld	ra,24(sp)
    80001d84:	6442                	ld	s0,16(sp)
    80001d86:	64a2                	ld	s1,8(sp)
    80001d88:	6902                	ld	s2,0(sp)
    80001d8a:	6105                	addi	sp,sp,32
    80001d8c:	8082                	ret
      kexit(-1);
    80001d8e:	557d                	li	a0,-1
    80001d90:	9a9ff0ef          	jal	80001738 <kexit>
    80001d94:	b7c1                	j	80001d54 <usertrap+0xa6>
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d96:	143025f3          	csrr	a1,stval
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d9a:	14202673          	csrr	a2,scause
            vmfault(p->pagetable, r_stval(), (r_scause() == 13)? 1 : 0) != 0) {
    80001d9e:	164d                	addi	a2,a2,-13 # ff3 <_entry-0x7ffff00d>
    80001da0:	00163613          	seqz	a2,a2
    80001da4:	68a8                	ld	a0,80(s1)
    80001da6:	e63fe0ef          	jal	80000c08 <vmfault>
  } else if((r_scause() == 15 || r_scause() == 13) &&
    80001daa:	f169                	bnez	a0,80001d6c <usertrap+0xbe>
    80001dac:	bfa1                	j	80001d04 <usertrap+0x56>
  if(killed(p))
    80001dae:	8526                	mv	a0,s1
    80001db0:	ab9ff0ef          	jal	80001868 <killed>
    80001db4:	c511                	beqz	a0,80001dc0 <usertrap+0x112>
    80001db6:	a011                	j	80001dba <usertrap+0x10c>
    80001db8:	4901                	li	s2,0
    kexit(-1);
    80001dba:	557d                	li	a0,-1
    80001dbc:	97dff0ef          	jal	80001738 <kexit>
  if(which_dev == 2)
    80001dc0:	4789                	li	a5,2
    80001dc2:	faf919e3          	bne	s2,a5,80001d74 <usertrap+0xc6>
    yield();
    80001dc6:	83bff0ef          	jal	80001600 <yield>
    80001dca:	b76d                	j	80001d74 <usertrap+0xc6>

0000000080001dcc <kerneltrap>:
{
    80001dcc:	7179                	addi	sp,sp,-48
    80001dce:	f406                	sd	ra,40(sp)
    80001dd0:	f022                	sd	s0,32(sp)
    80001dd2:	ec26                	sd	s1,24(sp)
    80001dd4:	e84a                	sd	s2,16(sp)
    80001dd6:	e44e                	sd	s3,8(sp)
    80001dd8:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001dda:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dde:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001de2:	142027f3          	csrr	a5,scause
    80001de6:	89be                	mv	s3,a5
  if((sstatus & SSTATUS_SPP) == 0)
    80001de8:	1004f793          	andi	a5,s1,256
    80001dec:	c795                	beqz	a5,80001e18 <kerneltrap+0x4c>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001dee:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001df2:	8b89                	andi	a5,a5,2
  if(intr_get() != 0)
    80001df4:	eb85                	bnez	a5,80001e24 <kerneltrap+0x58>
  if((which_dev = devintr()) == 0){
    80001df6:	e43ff0ef          	jal	80001c38 <devintr>
    80001dfa:	c91d                	beqz	a0,80001e30 <kerneltrap+0x64>
  if(which_dev == 2 && myproc() != 0)
    80001dfc:	4789                	li	a5,2
    80001dfe:	04f50a63          	beq	a0,a5,80001e52 <kerneltrap+0x86>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001e02:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001e06:	10049073          	csrw	sstatus,s1
}
    80001e0a:	70a2                	ld	ra,40(sp)
    80001e0c:	7402                	ld	s0,32(sp)
    80001e0e:	64e2                	ld	s1,24(sp)
    80001e10:	6942                	ld	s2,16(sp)
    80001e12:	69a2                	ld	s3,8(sp)
    80001e14:	6145                	addi	sp,sp,48
    80001e16:	8082                	ret
    panic("kerneltrap: not from supervisor mode");
    80001e18:	00005517          	auipc	a0,0x5
    80001e1c:	4e050513          	addi	a0,a0,1248 # 800072f8 <etext+0x2f8>
    80001e20:	349030ef          	jal	80005968 <panic>
    panic("kerneltrap: interrupts enabled");
    80001e24:	00005517          	auipc	a0,0x5
    80001e28:	4fc50513          	addi	a0,a0,1276 # 80007320 <etext+0x320>
    80001e2c:	33d030ef          	jal	80005968 <panic>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e30:	14102673          	csrr	a2,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001e34:	143026f3          	csrr	a3,stval
    printf("scause=0x%lx sepc=0x%lx stval=0x%lx\n", scause, r_sepc(), r_stval());
    80001e38:	85ce                	mv	a1,s3
    80001e3a:	00005517          	auipc	a0,0x5
    80001e3e:	50650513          	addi	a0,a0,1286 # 80007340 <etext+0x340>
    80001e42:	77a030ef          	jal	800055bc <printf>
    panic("kerneltrap");
    80001e46:	00005517          	auipc	a0,0x5
    80001e4a:	52250513          	addi	a0,a0,1314 # 80007368 <etext+0x368>
    80001e4e:	31b030ef          	jal	80005968 <panic>
  if(which_dev == 2 && myproc() != 0)
    80001e52:	9dcff0ef          	jal	8000102e <myproc>
    80001e56:	d555                	beqz	a0,80001e02 <kerneltrap+0x36>
    yield();
    80001e58:	fa8ff0ef          	jal	80001600 <yield>
    80001e5c:	b75d                	j	80001e02 <kerneltrap+0x36>

0000000080001e5e <argraw>:
  return strlen(buf);
}

static uint64
argraw(int n)
{
    80001e5e:	1101                	addi	sp,sp,-32
    80001e60:	ec06                	sd	ra,24(sp)
    80001e62:	e822                	sd	s0,16(sp)
    80001e64:	e426                	sd	s1,8(sp)
    80001e66:	1000                	addi	s0,sp,32
    80001e68:	84aa                	mv	s1,a0
  struct proc *p = myproc();
    80001e6a:	9c4ff0ef          	jal	8000102e <myproc>
  switch (n) {
    80001e6e:	4795                	li	a5,5
    80001e70:	0497e163          	bltu	a5,s1,80001eb2 <argraw+0x54>
    80001e74:	048a                	slli	s1,s1,0x2
    80001e76:	00006717          	auipc	a4,0x6
    80001e7a:	95270713          	addi	a4,a4,-1710 # 800077c8 <states.0+0x30>
    80001e7e:	94ba                	add	s1,s1,a4
    80001e80:	409c                	lw	a5,0(s1)
    80001e82:	97ba                	add	a5,a5,a4
    80001e84:	8782                	jr	a5
  case 0:
    return p->trapframe->a0;
    80001e86:	6d3c                	ld	a5,88(a0)
    80001e88:	7ba8                	ld	a0,112(a5)
  case 5:
    return p->trapframe->a5;
  }
  panic("argraw");
  return -1;
}
    80001e8a:	60e2                	ld	ra,24(sp)
    80001e8c:	6442                	ld	s0,16(sp)
    80001e8e:	64a2                	ld	s1,8(sp)
    80001e90:	6105                	addi	sp,sp,32
    80001e92:	8082                	ret
    return p->trapframe->a1;
    80001e94:	6d3c                	ld	a5,88(a0)
    80001e96:	7fa8                	ld	a0,120(a5)
    80001e98:	bfcd                	j	80001e8a <argraw+0x2c>
    return p->trapframe->a2;
    80001e9a:	6d3c                	ld	a5,88(a0)
    80001e9c:	63c8                	ld	a0,128(a5)
    80001e9e:	b7f5                	j	80001e8a <argraw+0x2c>
    return p->trapframe->a3;
    80001ea0:	6d3c                	ld	a5,88(a0)
    80001ea2:	67c8                	ld	a0,136(a5)
    80001ea4:	b7dd                	j	80001e8a <argraw+0x2c>
    return p->trapframe->a4;
    80001ea6:	6d3c                	ld	a5,88(a0)
    80001ea8:	6bc8                	ld	a0,144(a5)
    80001eaa:	b7c5                	j	80001e8a <argraw+0x2c>
    return p->trapframe->a5;
    80001eac:	6d3c                	ld	a5,88(a0)
    80001eae:	6fc8                	ld	a0,152(a5)
    80001eb0:	bfe9                	j	80001e8a <argraw+0x2c>
  panic("argraw");
    80001eb2:	00005517          	auipc	a0,0x5
    80001eb6:	4c650513          	addi	a0,a0,1222 # 80007378 <etext+0x378>
    80001eba:	2af030ef          	jal	80005968 <panic>

0000000080001ebe <fetchaddr>:
{
    80001ebe:	1101                	addi	sp,sp,-32
    80001ec0:	ec06                	sd	ra,24(sp)
    80001ec2:	e822                	sd	s0,16(sp)
    80001ec4:	e426                	sd	s1,8(sp)
    80001ec6:	e04a                	sd	s2,0(sp)
    80001ec8:	1000                	addi	s0,sp,32
    80001eca:	84aa                	mv	s1,a0
    80001ecc:	892e                	mv	s2,a1
  struct proc *p = myproc();
    80001ece:	960ff0ef          	jal	8000102e <myproc>
  if(addr >= p->sz || addr+sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ed2:	653c                	ld	a5,72(a0)
    80001ed4:	02f4f663          	bgeu	s1,a5,80001f00 <fetchaddr+0x42>
    80001ed8:	00848713          	addi	a4,s1,8
    80001edc:	02e7e463          	bltu	a5,a4,80001f04 <fetchaddr+0x46>
  if(copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001ee0:	46a1                	li	a3,8
    80001ee2:	8626                	mv	a2,s1
    80001ee4:	85ca                	mv	a1,s2
    80001ee6:	6928                	ld	a0,80(a0)
    80001ee8:	f2bfe0ef          	jal	80000e12 <copyin>
    80001eec:	00a03533          	snez	a0,a0
    80001ef0:	40a0053b          	negw	a0,a0
}
    80001ef4:	60e2                	ld	ra,24(sp)
    80001ef6:	6442                	ld	s0,16(sp)
    80001ef8:	64a2                	ld	s1,8(sp)
    80001efa:	6902                	ld	s2,0(sp)
    80001efc:	6105                	addi	sp,sp,32
    80001efe:	8082                	ret
    return -1;
    80001f00:	557d                	li	a0,-1
    80001f02:	bfcd                	j	80001ef4 <fetchaddr+0x36>
    80001f04:	557d                	li	a0,-1
    80001f06:	b7fd                	j	80001ef4 <fetchaddr+0x36>

0000000080001f08 <fetchstr>:
{
    80001f08:	7179                	addi	sp,sp,-48
    80001f0a:	f406                	sd	ra,40(sp)
    80001f0c:	f022                	sd	s0,32(sp)
    80001f0e:	ec26                	sd	s1,24(sp)
    80001f10:	e84a                	sd	s2,16(sp)
    80001f12:	e44e                	sd	s3,8(sp)
    80001f14:	1800                	addi	s0,sp,48
    80001f16:	89aa                	mv	s3,a0
    80001f18:	84ae                	mv	s1,a1
    80001f1a:	8932                	mv	s2,a2
  struct proc *p = myproc();
    80001f1c:	912ff0ef          	jal	8000102e <myproc>
  if(copyinstr(p->pagetable, buf, addr, max) < 0)
    80001f20:	86ca                	mv	a3,s2
    80001f22:	864e                	mv	a2,s3
    80001f24:	85a6                	mv	a1,s1
    80001f26:	6928                	ld	a0,80(a0)
    80001f28:	bcffe0ef          	jal	80000af6 <copyinstr>
    80001f2c:	00054c63          	bltz	a0,80001f44 <fetchstr+0x3c>
  return strlen(buf);
    80001f30:	8526                	mv	a0,s1
    80001f32:	cfcfe0ef          	jal	8000042e <strlen>
}
    80001f36:	70a2                	ld	ra,40(sp)
    80001f38:	7402                	ld	s0,32(sp)
    80001f3a:	64e2                	ld	s1,24(sp)
    80001f3c:	6942                	ld	s2,16(sp)
    80001f3e:	69a2                	ld	s3,8(sp)
    80001f40:	6145                	addi	sp,sp,48
    80001f42:	8082                	ret
    return -1;
    80001f44:	557d                	li	a0,-1
    80001f46:	bfc5                	j	80001f36 <fetchstr+0x2e>

0000000080001f48 <argint>:

// Fetch the nth 32-bit system call argument.
void
argint(int n, int *ip)
{
    80001f48:	1101                	addi	sp,sp,-32
    80001f4a:	ec06                	sd	ra,24(sp)
    80001f4c:	e822                	sd	s0,16(sp)
    80001f4e:	e426                	sd	s1,8(sp)
    80001f50:	1000                	addi	s0,sp,32
    80001f52:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f54:	f0bff0ef          	jal	80001e5e <argraw>
    80001f58:	c088                	sw	a0,0(s1)
}
    80001f5a:	60e2                	ld	ra,24(sp)
    80001f5c:	6442                	ld	s0,16(sp)
    80001f5e:	64a2                	ld	s1,8(sp)
    80001f60:	6105                	addi	sp,sp,32
    80001f62:	8082                	ret

0000000080001f64 <argaddr>:
// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void
argaddr(int n, uint64 *ip)
{
    80001f64:	1101                	addi	sp,sp,-32
    80001f66:	ec06                	sd	ra,24(sp)
    80001f68:	e822                	sd	s0,16(sp)
    80001f6a:	e426                	sd	s1,8(sp)
    80001f6c:	1000                	addi	s0,sp,32
    80001f6e:	84ae                	mv	s1,a1
  *ip = argraw(n);
    80001f70:	eefff0ef          	jal	80001e5e <argraw>
    80001f74:	e088                	sd	a0,0(s1)
}
    80001f76:	60e2                	ld	ra,24(sp)
    80001f78:	6442                	ld	s0,16(sp)
    80001f7a:	64a2                	ld	s1,8(sp)
    80001f7c:	6105                	addi	sp,sp,32
    80001f7e:	8082                	ret

0000000080001f80 <argstr>:
// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int
argstr(int n, char *buf, int max)
{
    80001f80:	1101                	addi	sp,sp,-32
    80001f82:	ec06                	sd	ra,24(sp)
    80001f84:	e822                	sd	s0,16(sp)
    80001f86:	e426                	sd	s1,8(sp)
    80001f88:	e04a                	sd	s2,0(sp)
    80001f8a:	1000                	addi	s0,sp,32
    80001f8c:	892e                	mv	s2,a1
    80001f8e:	84b2                	mv	s1,a2
  *ip = argraw(n);
    80001f90:	ecfff0ef          	jal	80001e5e <argraw>
  uint64 addr;
  argaddr(n, &addr);
  return fetchstr(addr, buf, max);
    80001f94:	8626                	mv	a2,s1
    80001f96:	85ca                	mv	a1,s2
    80001f98:	f71ff0ef          	jal	80001f08 <fetchstr>
}
    80001f9c:	60e2                	ld	ra,24(sp)
    80001f9e:	6442                	ld	s0,16(sp)
    80001fa0:	64a2                	ld	s1,8(sp)
    80001fa2:	6902                	ld	s2,0(sp)
    80001fa4:	6105                	addi	sp,sp,32
    80001fa6:	8082                	ret

0000000080001fa8 <syscall>:
[SYS_close]   sys_close,
};

void
syscall(void)
{
    80001fa8:	1101                	addi	sp,sp,-32
    80001faa:	ec06                	sd	ra,24(sp)
    80001fac:	e822                	sd	s0,16(sp)
    80001fae:	e426                	sd	s1,8(sp)
    80001fb0:	e04a                	sd	s2,0(sp)
    80001fb2:	1000                	addi	s0,sp,32
  int num;
  struct proc *p = myproc();
    80001fb4:	87aff0ef          	jal	8000102e <myproc>
    80001fb8:	84aa                	mv	s1,a0

  num = p->trapframe->a7;
    80001fba:	05853903          	ld	s2,88(a0)
    80001fbe:	0a893783          	ld	a5,168(s2)
    80001fc2:	0007869b          	sext.w	a3,a5
  if(num > 0 && num < NELEM(syscalls) && syscalls[num]) {
    80001fc6:	37fd                	addiw	a5,a5,-1
    80001fc8:	4751                	li	a4,20
    80001fca:	00f76f63          	bltu	a4,a5,80001fe8 <syscall+0x40>
    80001fce:	00369713          	slli	a4,a3,0x3
    80001fd2:	00006797          	auipc	a5,0x6
    80001fd6:	80e78793          	addi	a5,a5,-2034 # 800077e0 <syscalls>
    80001fda:	97ba                	add	a5,a5,a4
    80001fdc:	639c                	ld	a5,0(a5)
    80001fde:	c789                	beqz	a5,80001fe8 <syscall+0x40>
    // Use num to lookup the system call function for num, call it,
    // and store its return value in p->trapframe->a0
    p->trapframe->a0 = syscalls[num]();
    80001fe0:	9782                	jalr	a5
    80001fe2:	06a93823          	sd	a0,112(s2)
    80001fe6:	a829                	j	80002000 <syscall+0x58>
  } else {
    printf("%d %s: unknown sys call %d\n",
    80001fe8:	15848613          	addi	a2,s1,344
    80001fec:	588c                	lw	a1,48(s1)
    80001fee:	00005517          	auipc	a0,0x5
    80001ff2:	39250513          	addi	a0,a0,914 # 80007380 <etext+0x380>
    80001ff6:	5c6030ef          	jal	800055bc <printf>
            p->pid, p->name, num);
    p->trapframe->a0 = -1;
    80001ffa:	6cbc                	ld	a5,88(s1)
    80001ffc:	577d                	li	a4,-1
    80001ffe:	fbb8                	sd	a4,112(a5)
  }
}
    80002000:	60e2                	ld	ra,24(sp)
    80002002:	6442                	ld	s0,16(sp)
    80002004:	64a2                	ld	s1,8(sp)
    80002006:	6902                	ld	s2,0(sp)
    80002008:	6105                	addi	sp,sp,32
    8000200a:	8082                	ret

000000008000200c <sys_exit>:
#include "proc.h"
#include "vm.h"

uint64
sys_exit(void)
{
    8000200c:	1101                	addi	sp,sp,-32
    8000200e:	ec06                	sd	ra,24(sp)
    80002010:	e822                	sd	s0,16(sp)
    80002012:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002014:	fec40593          	addi	a1,s0,-20
    80002018:	4501                	li	a0,0
    8000201a:	f2fff0ef          	jal	80001f48 <argint>
  kexit(n);
    8000201e:	fec42503          	lw	a0,-20(s0)
    80002022:	f16ff0ef          	jal	80001738 <kexit>
  return 0;  // not reached
}
    80002026:	4501                	li	a0,0
    80002028:	60e2                	ld	ra,24(sp)
    8000202a:	6442                	ld	s0,16(sp)
    8000202c:	6105                	addi	sp,sp,32
    8000202e:	8082                	ret

0000000080002030 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002030:	1141                	addi	sp,sp,-16
    80002032:	e406                	sd	ra,8(sp)
    80002034:	e022                	sd	s0,0(sp)
    80002036:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002038:	ff7fe0ef          	jal	8000102e <myproc>
}
    8000203c:	5908                	lw	a0,48(a0)
    8000203e:	60a2                	ld	ra,8(sp)
    80002040:	6402                	ld	s0,0(sp)
    80002042:	0141                	addi	sp,sp,16
    80002044:	8082                	ret

0000000080002046 <sys_fork>:

uint64
sys_fork(void)
{
    80002046:	1141                	addi	sp,sp,-16
    80002048:	e406                	sd	ra,8(sp)
    8000204a:	e022                	sd	s0,0(sp)
    8000204c:	0800                	addi	s0,sp,16
  return kfork();
    8000204e:	b36ff0ef          	jal	80001384 <kfork>
}
    80002052:	60a2                	ld	ra,8(sp)
    80002054:	6402                	ld	s0,0(sp)
    80002056:	0141                	addi	sp,sp,16
    80002058:	8082                	ret

000000008000205a <sys_wait>:

uint64
sys_wait(void)
{
    8000205a:	1101                	addi	sp,sp,-32
    8000205c:	ec06                	sd	ra,24(sp)
    8000205e:	e822                	sd	s0,16(sp)
    80002060:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002062:	fe840593          	addi	a1,s0,-24
    80002066:	4501                	li	a0,0
    80002068:	efdff0ef          	jal	80001f64 <argaddr>
  return kwait(p);
    8000206c:	fe843503          	ld	a0,-24(s0)
    80002070:	823ff0ef          	jal	80001892 <kwait>
}
    80002074:	60e2                	ld	ra,24(sp)
    80002076:	6442                	ld	s0,16(sp)
    80002078:	6105                	addi	sp,sp,32
    8000207a:	8082                	ret

000000008000207c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000207c:	7179                	addi	sp,sp,-48
    8000207e:	f406                	sd	ra,40(sp)
    80002080:	f022                	sd	s0,32(sp)
    80002082:	ec26                	sd	s1,24(sp)
    80002084:	1800                	addi	s0,sp,48
  uint64 addr;
  int t;
  int n;

  argint(0, &n);
    80002086:	fd840593          	addi	a1,s0,-40
    8000208a:	4501                	li	a0,0
    8000208c:	ebdff0ef          	jal	80001f48 <argint>
  argint(1, &t);
    80002090:	fdc40593          	addi	a1,s0,-36
    80002094:	4505                	li	a0,1
    80002096:	eb3ff0ef          	jal	80001f48 <argint>
  addr = myproc()->sz;
    8000209a:	f95fe0ef          	jal	8000102e <myproc>
    8000209e:	6524                	ld	s1,72(a0)

  if(t == SBRK_EAGER || n < 0) {
    800020a0:	fdc42703          	lw	a4,-36(s0)
    800020a4:	4785                	li	a5,1
    800020a6:	02f70163          	beq	a4,a5,800020c8 <sys_sbrk+0x4c>
    800020aa:	fd842783          	lw	a5,-40(s0)
    800020ae:	0007cd63          	bltz	a5,800020c8 <sys_sbrk+0x4c>
    }
  } else {
    // Lazily allocate memory for this process: increase its memory
    // size but don't allocate memory. If the processes uses the
    // memory, vmfault() will allocate it.
    if(addr + n < addr)
    800020b2:	97a6                	add	a5,a5,s1
    800020b4:	0297e863          	bltu	a5,s1,800020e4 <sys_sbrk+0x68>
      return -1;
    myproc()->sz += n;
    800020b8:	f77fe0ef          	jal	8000102e <myproc>
    800020bc:	fd842703          	lw	a4,-40(s0)
    800020c0:	653c                	ld	a5,72(a0)
    800020c2:	97ba                	add	a5,a5,a4
    800020c4:	e53c                	sd	a5,72(a0)
    800020c6:	a039                	j	800020d4 <sys_sbrk+0x58>
    if(growproc(n) < 0) {
    800020c8:	fd842503          	lw	a0,-40(s0)
    800020cc:	a68ff0ef          	jal	80001334 <growproc>
    800020d0:	00054863          	bltz	a0,800020e0 <sys_sbrk+0x64>
  }
  return addr;
}
    800020d4:	8526                	mv	a0,s1
    800020d6:	70a2                	ld	ra,40(sp)
    800020d8:	7402                	ld	s0,32(sp)
    800020da:	64e2                	ld	s1,24(sp)
    800020dc:	6145                	addi	sp,sp,48
    800020de:	8082                	ret
      return -1;
    800020e0:	54fd                	li	s1,-1
    800020e2:	bfcd                	j	800020d4 <sys_sbrk+0x58>
      return -1;
    800020e4:	54fd                	li	s1,-1
    800020e6:	b7fd                	j	800020d4 <sys_sbrk+0x58>

00000000800020e8 <sys_pause>:

uint64
sys_pause(void)
{
    800020e8:	7139                	addi	sp,sp,-64
    800020ea:	fc06                	sd	ra,56(sp)
    800020ec:	f822                	sd	s0,48(sp)
    800020ee:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800020f0:	fcc40593          	addi	a1,s0,-52
    800020f4:	4501                	li	a0,0
    800020f6:	e53ff0ef          	jal	80001f48 <argint>
  if(n < 0)
    800020fa:	fcc42783          	lw	a5,-52(s0)
    800020fe:	0607c863          	bltz	a5,8000216e <sys_pause+0x86>
    n = 0;
  acquire(&tickslock);
    80002102:	0022b517          	auipc	a0,0x22b
    80002106:	63e50513          	addi	a0,a0,1598 # 8022d740 <tickslock>
    8000210a:	301030ef          	jal	80005c0a <acquire>
  ticks0 = ticks;
  while(ticks - ticks0 < n){
    8000210e:	fcc42783          	lw	a5,-52(s0)
    80002112:	c3b9                	beqz	a5,80002158 <sys_pause+0x70>
    80002114:	f426                	sd	s1,40(sp)
    80002116:	f04a                	sd	s2,32(sp)
    80002118:	ec4e                	sd	s3,24(sp)
  ticks0 = ticks;
    8000211a:	00005997          	auipc	s3,0x5
    8000211e:	7be9a983          	lw	s3,1982(s3) # 800078d8 <ticks>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002122:	0022b917          	auipc	s2,0x22b
    80002126:	61e90913          	addi	s2,s2,1566 # 8022d740 <tickslock>
    8000212a:	00005497          	auipc	s1,0x5
    8000212e:	7ae48493          	addi	s1,s1,1966 # 800078d8 <ticks>
    if(killed(myproc())){
    80002132:	efdfe0ef          	jal	8000102e <myproc>
    80002136:	f32ff0ef          	jal	80001868 <killed>
    8000213a:	ed0d                	bnez	a0,80002174 <sys_pause+0x8c>
    sleep(&ticks, &tickslock);
    8000213c:	85ca                	mv	a1,s2
    8000213e:	8526                	mv	a0,s1
    80002140:	cecff0ef          	jal	8000162c <sleep>
  while(ticks - ticks0 < n){
    80002144:	409c                	lw	a5,0(s1)
    80002146:	413787bb          	subw	a5,a5,s3
    8000214a:	fcc42703          	lw	a4,-52(s0)
    8000214e:	fee7e2e3          	bltu	a5,a4,80002132 <sys_pause+0x4a>
    80002152:	74a2                	ld	s1,40(sp)
    80002154:	7902                	ld	s2,32(sp)
    80002156:	69e2                	ld	s3,24(sp)
  }
  release(&tickslock);
    80002158:	0022b517          	auipc	a0,0x22b
    8000215c:	5e850513          	addi	a0,a0,1512 # 8022d740 <tickslock>
    80002160:	33f030ef          	jal	80005c9e <release>
  return 0;
    80002164:	4501                	li	a0,0
}
    80002166:	70e2                	ld	ra,56(sp)
    80002168:	7442                	ld	s0,48(sp)
    8000216a:	6121                	addi	sp,sp,64
    8000216c:	8082                	ret
    n = 0;
    8000216e:	fc042623          	sw	zero,-52(s0)
    80002172:	bf41                	j	80002102 <sys_pause+0x1a>
      release(&tickslock);
    80002174:	0022b517          	auipc	a0,0x22b
    80002178:	5cc50513          	addi	a0,a0,1484 # 8022d740 <tickslock>
    8000217c:	323030ef          	jal	80005c9e <release>
      return -1;
    80002180:	557d                	li	a0,-1
    80002182:	74a2                	ld	s1,40(sp)
    80002184:	7902                	ld	s2,32(sp)
    80002186:	69e2                	ld	s3,24(sp)
    80002188:	bff9                	j	80002166 <sys_pause+0x7e>

000000008000218a <sys_kill>:

uint64
sys_kill(void)
{
    8000218a:	1101                	addi	sp,sp,-32
    8000218c:	ec06                	sd	ra,24(sp)
    8000218e:	e822                	sd	s0,16(sp)
    80002190:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002192:	fec40593          	addi	a1,s0,-20
    80002196:	4501                	li	a0,0
    80002198:	db1ff0ef          	jal	80001f48 <argint>
  return kkill(pid);
    8000219c:	fec42503          	lw	a0,-20(s0)
    800021a0:	e3eff0ef          	jal	800017de <kkill>
}
    800021a4:	60e2                	ld	ra,24(sp)
    800021a6:	6442                	ld	s0,16(sp)
    800021a8:	6105                	addi	sp,sp,32
    800021aa:	8082                	ret

00000000800021ac <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800021ac:	1101                	addi	sp,sp,-32
    800021ae:	ec06                	sd	ra,24(sp)
    800021b0:	e822                	sd	s0,16(sp)
    800021b2:	e426                	sd	s1,8(sp)
    800021b4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800021b6:	0022b517          	auipc	a0,0x22b
    800021ba:	58a50513          	addi	a0,a0,1418 # 8022d740 <tickslock>
    800021be:	24d030ef          	jal	80005c0a <acquire>
  xticks = ticks;
    800021c2:	00005797          	auipc	a5,0x5
    800021c6:	7167a783          	lw	a5,1814(a5) # 800078d8 <ticks>
    800021ca:	84be                	mv	s1,a5
  release(&tickslock);
    800021cc:	0022b517          	auipc	a0,0x22b
    800021d0:	57450513          	addi	a0,a0,1396 # 8022d740 <tickslock>
    800021d4:	2cb030ef          	jal	80005c9e <release>
  return xticks;
}
    800021d8:	02049513          	slli	a0,s1,0x20
    800021dc:	9101                	srli	a0,a0,0x20
    800021de:	60e2                	ld	ra,24(sp)
    800021e0:	6442                	ld	s0,16(sp)
    800021e2:	64a2                	ld	s1,8(sp)
    800021e4:	6105                	addi	sp,sp,32
    800021e6:	8082                	ret

00000000800021e8 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800021e8:	7179                	addi	sp,sp,-48
    800021ea:	f406                	sd	ra,40(sp)
    800021ec:	f022                	sd	s0,32(sp)
    800021ee:	ec26                	sd	s1,24(sp)
    800021f0:	e84a                	sd	s2,16(sp)
    800021f2:	e44e                	sd	s3,8(sp)
    800021f4:	e052                	sd	s4,0(sp)
    800021f6:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800021f8:	00005597          	auipc	a1,0x5
    800021fc:	1a858593          	addi	a1,a1,424 # 800073a0 <etext+0x3a0>
    80002200:	0022b517          	auipc	a0,0x22b
    80002204:	55850513          	addi	a0,a0,1368 # 8022d758 <bcache>
    80002208:	179030ef          	jal	80005b80 <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000220c:	00233797          	auipc	a5,0x233
    80002210:	54c78793          	addi	a5,a5,1356 # 80235758 <bcache+0x8000>
    80002214:	00233717          	auipc	a4,0x233
    80002218:	7ac70713          	addi	a4,a4,1964 # 802359c0 <bcache+0x8268>
    8000221c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002220:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002224:	0022b497          	auipc	s1,0x22b
    80002228:	54c48493          	addi	s1,s1,1356 # 8022d770 <bcache+0x18>
    b->next = bcache.head.next;
    8000222c:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    8000222e:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002230:	00005a17          	auipc	s4,0x5
    80002234:	178a0a13          	addi	s4,s4,376 # 800073a8 <etext+0x3a8>
    b->next = bcache.head.next;
    80002238:	2b893783          	ld	a5,696(s2)
    8000223c:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    8000223e:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002242:	85d2                	mv	a1,s4
    80002244:	01048513          	addi	a0,s1,16
    80002248:	328010ef          	jal	80003570 <initsleeplock>
    bcache.head.next->prev = b;
    8000224c:	2b893783          	ld	a5,696(s2)
    80002250:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    80002252:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002256:	45848493          	addi	s1,s1,1112
    8000225a:	fd349fe3          	bne	s1,s3,80002238 <binit+0x50>
  }
}
    8000225e:	70a2                	ld	ra,40(sp)
    80002260:	7402                	ld	s0,32(sp)
    80002262:	64e2                	ld	s1,24(sp)
    80002264:	6942                	ld	s2,16(sp)
    80002266:	69a2                	ld	s3,8(sp)
    80002268:	6a02                	ld	s4,0(sp)
    8000226a:	6145                	addi	sp,sp,48
    8000226c:	8082                	ret

000000008000226e <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    8000226e:	7179                	addi	sp,sp,-48
    80002270:	f406                	sd	ra,40(sp)
    80002272:	f022                	sd	s0,32(sp)
    80002274:	ec26                	sd	s1,24(sp)
    80002276:	e84a                	sd	s2,16(sp)
    80002278:	e44e                	sd	s3,8(sp)
    8000227a:	1800                	addi	s0,sp,48
    8000227c:	892a                	mv	s2,a0
    8000227e:	89ae                	mv	s3,a1
  acquire(&bcache.lock);
    80002280:	0022b517          	auipc	a0,0x22b
    80002284:	4d850513          	addi	a0,a0,1240 # 8022d758 <bcache>
    80002288:	183030ef          	jal	80005c0a <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000228c:	00233497          	auipc	s1,0x233
    80002290:	7844b483          	ld	s1,1924(s1) # 80235a10 <bcache+0x82b8>
    80002294:	00233797          	auipc	a5,0x233
    80002298:	72c78793          	addi	a5,a5,1836 # 802359c0 <bcache+0x8268>
    8000229c:	02f48b63          	beq	s1,a5,800022d2 <bread+0x64>
    800022a0:	873e                	mv	a4,a5
    800022a2:	a021                	j	800022aa <bread+0x3c>
    800022a4:	68a4                	ld	s1,80(s1)
    800022a6:	02e48663          	beq	s1,a4,800022d2 <bread+0x64>
    if(b->dev == dev && b->blockno == blockno){
    800022aa:	449c                	lw	a5,8(s1)
    800022ac:	ff279ce3          	bne	a5,s2,800022a4 <bread+0x36>
    800022b0:	44dc                	lw	a5,12(s1)
    800022b2:	ff3799e3          	bne	a5,s3,800022a4 <bread+0x36>
      b->refcnt++;
    800022b6:	40bc                	lw	a5,64(s1)
    800022b8:	2785                	addiw	a5,a5,1
    800022ba:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800022bc:	0022b517          	auipc	a0,0x22b
    800022c0:	49c50513          	addi	a0,a0,1180 # 8022d758 <bcache>
    800022c4:	1db030ef          	jal	80005c9e <release>
      acquiresleep(&b->lock);
    800022c8:	01048513          	addi	a0,s1,16
    800022cc:	2da010ef          	jal	800035a6 <acquiresleep>
      return b;
    800022d0:	a889                	j	80002322 <bread+0xb4>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022d2:	00233497          	auipc	s1,0x233
    800022d6:	7364b483          	ld	s1,1846(s1) # 80235a08 <bcache+0x82b0>
    800022da:	00233797          	auipc	a5,0x233
    800022de:	6e678793          	addi	a5,a5,1766 # 802359c0 <bcache+0x8268>
    800022e2:	00f48863          	beq	s1,a5,800022f2 <bread+0x84>
    800022e6:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800022e8:	40bc                	lw	a5,64(s1)
    800022ea:	cb91                	beqz	a5,800022fe <bread+0x90>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800022ec:	64a4                	ld	s1,72(s1)
    800022ee:	fee49de3          	bne	s1,a4,800022e8 <bread+0x7a>
  panic("bget: no buffers");
    800022f2:	00005517          	auipc	a0,0x5
    800022f6:	0be50513          	addi	a0,a0,190 # 800073b0 <etext+0x3b0>
    800022fa:	66e030ef          	jal	80005968 <panic>
      b->dev = dev;
    800022fe:	0124a423          	sw	s2,8(s1)
      b->blockno = blockno;
    80002302:	0134a623          	sw	s3,12(s1)
      b->valid = 0;
    80002306:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000230a:	4785                	li	a5,1
    8000230c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000230e:	0022b517          	auipc	a0,0x22b
    80002312:	44a50513          	addi	a0,a0,1098 # 8022d758 <bcache>
    80002316:	189030ef          	jal	80005c9e <release>
      acquiresleep(&b->lock);
    8000231a:	01048513          	addi	a0,s1,16
    8000231e:	288010ef          	jal	800035a6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002322:	409c                	lw	a5,0(s1)
    80002324:	cb89                	beqz	a5,80002336 <bread+0xc8>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002326:	8526                	mv	a0,s1
    80002328:	70a2                	ld	ra,40(sp)
    8000232a:	7402                	ld	s0,32(sp)
    8000232c:	64e2                	ld	s1,24(sp)
    8000232e:	6942                	ld	s2,16(sp)
    80002330:	69a2                	ld	s3,8(sp)
    80002332:	6145                	addi	sp,sp,48
    80002334:	8082                	ret
    virtio_disk_rw(b, 0);
    80002336:	4581                	li	a1,0
    80002338:	8526                	mv	a0,s1
    8000233a:	2e7020ef          	jal	80004e20 <virtio_disk_rw>
    b->valid = 1;
    8000233e:	4785                	li	a5,1
    80002340:	c09c                	sw	a5,0(s1)
  return b;
    80002342:	b7d5                	j	80002326 <bread+0xb8>

0000000080002344 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002344:	1101                	addi	sp,sp,-32
    80002346:	ec06                	sd	ra,24(sp)
    80002348:	e822                	sd	s0,16(sp)
    8000234a:	e426                	sd	s1,8(sp)
    8000234c:	1000                	addi	s0,sp,32
    8000234e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002350:	0541                	addi	a0,a0,16
    80002352:	2d2010ef          	jal	80003624 <holdingsleep>
    80002356:	c911                	beqz	a0,8000236a <bwrite+0x26>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002358:	4585                	li	a1,1
    8000235a:	8526                	mv	a0,s1
    8000235c:	2c5020ef          	jal	80004e20 <virtio_disk_rw>
}
    80002360:	60e2                	ld	ra,24(sp)
    80002362:	6442                	ld	s0,16(sp)
    80002364:	64a2                	ld	s1,8(sp)
    80002366:	6105                	addi	sp,sp,32
    80002368:	8082                	ret
    panic("bwrite");
    8000236a:	00005517          	auipc	a0,0x5
    8000236e:	05e50513          	addi	a0,a0,94 # 800073c8 <etext+0x3c8>
    80002372:	5f6030ef          	jal	80005968 <panic>

0000000080002376 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002376:	1101                	addi	sp,sp,-32
    80002378:	ec06                	sd	ra,24(sp)
    8000237a:	e822                	sd	s0,16(sp)
    8000237c:	e426                	sd	s1,8(sp)
    8000237e:	e04a                	sd	s2,0(sp)
    80002380:	1000                	addi	s0,sp,32
    80002382:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002384:	01050913          	addi	s2,a0,16
    80002388:	854a                	mv	a0,s2
    8000238a:	29a010ef          	jal	80003624 <holdingsleep>
    8000238e:	c125                	beqz	a0,800023ee <brelse+0x78>
    panic("brelse");

  releasesleep(&b->lock);
    80002390:	854a                	mv	a0,s2
    80002392:	25a010ef          	jal	800035ec <releasesleep>

  acquire(&bcache.lock);
    80002396:	0022b517          	auipc	a0,0x22b
    8000239a:	3c250513          	addi	a0,a0,962 # 8022d758 <bcache>
    8000239e:	06d030ef          	jal	80005c0a <acquire>
  b->refcnt--;
    800023a2:	40bc                	lw	a5,64(s1)
    800023a4:	37fd                	addiw	a5,a5,-1
    800023a6:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800023a8:	e79d                	bnez	a5,800023d6 <brelse+0x60>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800023aa:	68b8                	ld	a4,80(s1)
    800023ac:	64bc                	ld	a5,72(s1)
    800023ae:	e73c                	sd	a5,72(a4)
    b->prev->next = b->next;
    800023b0:	68b8                	ld	a4,80(s1)
    800023b2:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800023b4:	00233797          	auipc	a5,0x233
    800023b8:	3a478793          	addi	a5,a5,932 # 80235758 <bcache+0x8000>
    800023bc:	2b87b703          	ld	a4,696(a5)
    800023c0:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800023c2:	00233717          	auipc	a4,0x233
    800023c6:	5fe70713          	addi	a4,a4,1534 # 802359c0 <bcache+0x8268>
    800023ca:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800023cc:	2b87b703          	ld	a4,696(a5)
    800023d0:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800023d2:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800023d6:	0022b517          	auipc	a0,0x22b
    800023da:	38250513          	addi	a0,a0,898 # 8022d758 <bcache>
    800023de:	0c1030ef          	jal	80005c9e <release>
}
    800023e2:	60e2                	ld	ra,24(sp)
    800023e4:	6442                	ld	s0,16(sp)
    800023e6:	64a2                	ld	s1,8(sp)
    800023e8:	6902                	ld	s2,0(sp)
    800023ea:	6105                	addi	sp,sp,32
    800023ec:	8082                	ret
    panic("brelse");
    800023ee:	00005517          	auipc	a0,0x5
    800023f2:	fe250513          	addi	a0,a0,-30 # 800073d0 <etext+0x3d0>
    800023f6:	572030ef          	jal	80005968 <panic>

00000000800023fa <bpin>:

void
bpin(struct buf *b) {
    800023fa:	1101                	addi	sp,sp,-32
    800023fc:	ec06                	sd	ra,24(sp)
    800023fe:	e822                	sd	s0,16(sp)
    80002400:	e426                	sd	s1,8(sp)
    80002402:	1000                	addi	s0,sp,32
    80002404:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002406:	0022b517          	auipc	a0,0x22b
    8000240a:	35250513          	addi	a0,a0,850 # 8022d758 <bcache>
    8000240e:	7fc030ef          	jal	80005c0a <acquire>
  b->refcnt++;
    80002412:	40bc                	lw	a5,64(s1)
    80002414:	2785                	addiw	a5,a5,1
    80002416:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002418:	0022b517          	auipc	a0,0x22b
    8000241c:	34050513          	addi	a0,a0,832 # 8022d758 <bcache>
    80002420:	07f030ef          	jal	80005c9e <release>
}
    80002424:	60e2                	ld	ra,24(sp)
    80002426:	6442                	ld	s0,16(sp)
    80002428:	64a2                	ld	s1,8(sp)
    8000242a:	6105                	addi	sp,sp,32
    8000242c:	8082                	ret

000000008000242e <bunpin>:

void
bunpin(struct buf *b) {
    8000242e:	1101                	addi	sp,sp,-32
    80002430:	ec06                	sd	ra,24(sp)
    80002432:	e822                	sd	s0,16(sp)
    80002434:	e426                	sd	s1,8(sp)
    80002436:	1000                	addi	s0,sp,32
    80002438:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000243a:	0022b517          	auipc	a0,0x22b
    8000243e:	31e50513          	addi	a0,a0,798 # 8022d758 <bcache>
    80002442:	7c8030ef          	jal	80005c0a <acquire>
  b->refcnt--;
    80002446:	40bc                	lw	a5,64(s1)
    80002448:	37fd                	addiw	a5,a5,-1
    8000244a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000244c:	0022b517          	auipc	a0,0x22b
    80002450:	30c50513          	addi	a0,a0,780 # 8022d758 <bcache>
    80002454:	04b030ef          	jal	80005c9e <release>
}
    80002458:	60e2                	ld	ra,24(sp)
    8000245a:	6442                	ld	s0,16(sp)
    8000245c:	64a2                	ld	s1,8(sp)
    8000245e:	6105                	addi	sp,sp,32
    80002460:	8082                	ret

0000000080002462 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002462:	1101                	addi	sp,sp,-32
    80002464:	ec06                	sd	ra,24(sp)
    80002466:	e822                	sd	s0,16(sp)
    80002468:	e426                	sd	s1,8(sp)
    8000246a:	e04a                	sd	s2,0(sp)
    8000246c:	1000                	addi	s0,sp,32
    8000246e:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002470:	00d5d79b          	srliw	a5,a1,0xd
    80002474:	00234597          	auipc	a1,0x234
    80002478:	9c05a583          	lw	a1,-1600(a1) # 80235e34 <sb+0x1c>
    8000247c:	9dbd                	addw	a1,a1,a5
    8000247e:	df1ff0ef          	jal	8000226e <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    80002482:	0074f713          	andi	a4,s1,7
    80002486:	4785                	li	a5,1
    80002488:	00e797bb          	sllw	a5,a5,a4
  bi = b % BPB;
    8000248c:	14ce                	slli	s1,s1,0x33
  if((bp->data[bi/8] & m) == 0)
    8000248e:	90d9                	srli	s1,s1,0x36
    80002490:	00950733          	add	a4,a0,s1
    80002494:	05874703          	lbu	a4,88(a4)
    80002498:	00e7f6b3          	and	a3,a5,a4
    8000249c:	c29d                	beqz	a3,800024c2 <bfree+0x60>
    8000249e:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    800024a0:	94aa                	add	s1,s1,a0
    800024a2:	fff7c793          	not	a5,a5
    800024a6:	8f7d                	and	a4,a4,a5
    800024a8:	04e48c23          	sb	a4,88(s1)
  log_write(bp);
    800024ac:	000010ef          	jal	800034ac <log_write>
  brelse(bp);
    800024b0:	854a                	mv	a0,s2
    800024b2:	ec5ff0ef          	jal	80002376 <brelse>
}
    800024b6:	60e2                	ld	ra,24(sp)
    800024b8:	6442                	ld	s0,16(sp)
    800024ba:	64a2                	ld	s1,8(sp)
    800024bc:	6902                	ld	s2,0(sp)
    800024be:	6105                	addi	sp,sp,32
    800024c0:	8082                	ret
    panic("freeing free block");
    800024c2:	00005517          	auipc	a0,0x5
    800024c6:	f1650513          	addi	a0,a0,-234 # 800073d8 <etext+0x3d8>
    800024ca:	49e030ef          	jal	80005968 <panic>

00000000800024ce <balloc>:
{
    800024ce:	715d                	addi	sp,sp,-80
    800024d0:	e486                	sd	ra,72(sp)
    800024d2:	e0a2                	sd	s0,64(sp)
    800024d4:	fc26                	sd	s1,56(sp)
    800024d6:	0880                	addi	s0,sp,80
  for(b = 0; b < sb.size; b += BPB){
    800024d8:	00234797          	auipc	a5,0x234
    800024dc:	9447a783          	lw	a5,-1724(a5) # 80235e1c <sb+0x4>
    800024e0:	0e078263          	beqz	a5,800025c4 <balloc+0xf6>
    800024e4:	f84a                	sd	s2,48(sp)
    800024e6:	f44e                	sd	s3,40(sp)
    800024e8:	f052                	sd	s4,32(sp)
    800024ea:	ec56                	sd	s5,24(sp)
    800024ec:	e85a                	sd	s6,16(sp)
    800024ee:	e45e                	sd	s7,8(sp)
    800024f0:	e062                	sd	s8,0(sp)
    800024f2:	8baa                	mv	s7,a0
    800024f4:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800024f6:	00234b17          	auipc	s6,0x234
    800024fa:	922b0b13          	addi	s6,s6,-1758 # 80235e18 <sb>
      m = 1 << (bi % 8);
    800024fe:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002500:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    80002502:	6c09                	lui	s8,0x2
    80002504:	a09d                	j	8000256a <balloc+0x9c>
        bp->data[bi/8] |= m;  // Mark block in use.
    80002506:	97ca                	add	a5,a5,s2
    80002508:	8e55                	or	a2,a2,a3
    8000250a:	04c78c23          	sb	a2,88(a5)
        log_write(bp);
    8000250e:	854a                	mv	a0,s2
    80002510:	79d000ef          	jal	800034ac <log_write>
        brelse(bp);
    80002514:	854a                	mv	a0,s2
    80002516:	e61ff0ef          	jal	80002376 <brelse>
  bp = bread(dev, bno);
    8000251a:	85a6                	mv	a1,s1
    8000251c:	855e                	mv	a0,s7
    8000251e:	d51ff0ef          	jal	8000226e <bread>
    80002522:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    80002524:	40000613          	li	a2,1024
    80002528:	4581                	li	a1,0
    8000252a:	05850513          	addi	a0,a0,88
    8000252e:	d77fd0ef          	jal	800002a4 <memset>
  log_write(bp);
    80002532:	854a                	mv	a0,s2
    80002534:	779000ef          	jal	800034ac <log_write>
  brelse(bp);
    80002538:	854a                	mv	a0,s2
    8000253a:	e3dff0ef          	jal	80002376 <brelse>
}
    8000253e:	7942                	ld	s2,48(sp)
    80002540:	79a2                	ld	s3,40(sp)
    80002542:	7a02                	ld	s4,32(sp)
    80002544:	6ae2                	ld	s5,24(sp)
    80002546:	6b42                	ld	s6,16(sp)
    80002548:	6ba2                	ld	s7,8(sp)
    8000254a:	6c02                	ld	s8,0(sp)
}
    8000254c:	8526                	mv	a0,s1
    8000254e:	60a6                	ld	ra,72(sp)
    80002550:	6406                	ld	s0,64(sp)
    80002552:	74e2                	ld	s1,56(sp)
    80002554:	6161                	addi	sp,sp,80
    80002556:	8082                	ret
    brelse(bp);
    80002558:	854a                	mv	a0,s2
    8000255a:	e1dff0ef          	jal	80002376 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    8000255e:	015c0abb          	addw	s5,s8,s5
    80002562:	004b2783          	lw	a5,4(s6)
    80002566:	04faf863          	bgeu	s5,a5,800025b6 <balloc+0xe8>
    bp = bread(dev, BBLOCK(b, sb));
    8000256a:	40dad59b          	sraiw	a1,s5,0xd
    8000256e:	01cb2783          	lw	a5,28(s6)
    80002572:	9dbd                	addw	a1,a1,a5
    80002574:	855e                	mv	a0,s7
    80002576:	cf9ff0ef          	jal	8000226e <bread>
    8000257a:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    8000257c:	004b2503          	lw	a0,4(s6)
    80002580:	84d6                	mv	s1,s5
    80002582:	4701                	li	a4,0
    80002584:	fca4fae3          	bgeu	s1,a0,80002558 <balloc+0x8a>
      m = 1 << (bi % 8);
    80002588:	00777693          	andi	a3,a4,7
    8000258c:	00d996bb          	sllw	a3,s3,a3
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    80002590:	41f7579b          	sraiw	a5,a4,0x1f
    80002594:	01d7d79b          	srliw	a5,a5,0x1d
    80002598:	9fb9                	addw	a5,a5,a4
    8000259a:	4037d79b          	sraiw	a5,a5,0x3
    8000259e:	00f90633          	add	a2,s2,a5
    800025a2:	05864603          	lbu	a2,88(a2)
    800025a6:	00c6f5b3          	and	a1,a3,a2
    800025aa:	ddb1                	beqz	a1,80002506 <balloc+0x38>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800025ac:	2705                	addiw	a4,a4,1
    800025ae:	2485                	addiw	s1,s1,1
    800025b0:	fd471ae3          	bne	a4,s4,80002584 <balloc+0xb6>
    800025b4:	b755                	j	80002558 <balloc+0x8a>
    800025b6:	7942                	ld	s2,48(sp)
    800025b8:	79a2                	ld	s3,40(sp)
    800025ba:	7a02                	ld	s4,32(sp)
    800025bc:	6ae2                	ld	s5,24(sp)
    800025be:	6b42                	ld	s6,16(sp)
    800025c0:	6ba2                	ld	s7,8(sp)
    800025c2:	6c02                	ld	s8,0(sp)
  printf("balloc: out of blocks\n");
    800025c4:	00005517          	auipc	a0,0x5
    800025c8:	e2c50513          	addi	a0,a0,-468 # 800073f0 <etext+0x3f0>
    800025cc:	7f1020ef          	jal	800055bc <printf>
  return 0;
    800025d0:	4481                	li	s1,0
    800025d2:	bfad                	j	8000254c <balloc+0x7e>

00000000800025d4 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800025d4:	7179                	addi	sp,sp,-48
    800025d6:	f406                	sd	ra,40(sp)
    800025d8:	f022                	sd	s0,32(sp)
    800025da:	ec26                	sd	s1,24(sp)
    800025dc:	e84a                	sd	s2,16(sp)
    800025de:	e44e                	sd	s3,8(sp)
    800025e0:	1800                	addi	s0,sp,48
    800025e2:	892a                	mv	s2,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800025e4:	47ad                	li	a5,11
    800025e6:	02b7e363          	bltu	a5,a1,8000260c <bmap+0x38>
    if((addr = ip->addrs[bn]) == 0){
    800025ea:	02059793          	slli	a5,a1,0x20
    800025ee:	01e7d593          	srli	a1,a5,0x1e
    800025f2:	00b509b3          	add	s3,a0,a1
    800025f6:	0509a483          	lw	s1,80(s3)
    800025fa:	e0b5                	bnez	s1,8000265e <bmap+0x8a>
      addr = balloc(ip->dev);
    800025fc:	4108                	lw	a0,0(a0)
    800025fe:	ed1ff0ef          	jal	800024ce <balloc>
    80002602:	84aa                	mv	s1,a0
      if(addr == 0)
    80002604:	cd29                	beqz	a0,8000265e <bmap+0x8a>
        return 0;
      ip->addrs[bn] = addr;
    80002606:	04a9a823          	sw	a0,80(s3)
    8000260a:	a891                	j	8000265e <bmap+0x8a>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000260c:	ff45879b          	addiw	a5,a1,-12
    80002610:	873e                	mv	a4,a5
    80002612:	89be                	mv	s3,a5

  if(bn < NINDIRECT){
    80002614:	0ff00793          	li	a5,255
    80002618:	06e7e763          	bltu	a5,a4,80002686 <bmap+0xb2>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000261c:	08052483          	lw	s1,128(a0)
    80002620:	e891                	bnez	s1,80002634 <bmap+0x60>
      addr = balloc(ip->dev);
    80002622:	4108                	lw	a0,0(a0)
    80002624:	eabff0ef          	jal	800024ce <balloc>
    80002628:	84aa                	mv	s1,a0
      if(addr == 0)
    8000262a:	c915                	beqz	a0,8000265e <bmap+0x8a>
    8000262c:	e052                	sd	s4,0(sp)
        return 0;
      ip->addrs[NDIRECT] = addr;
    8000262e:	08a92023          	sw	a0,128(s2)
    80002632:	a011                	j	80002636 <bmap+0x62>
    80002634:	e052                	sd	s4,0(sp)
    }
    bp = bread(ip->dev, addr);
    80002636:	85a6                	mv	a1,s1
    80002638:	00092503          	lw	a0,0(s2)
    8000263c:	c33ff0ef          	jal	8000226e <bread>
    80002640:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    80002642:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002646:	02099713          	slli	a4,s3,0x20
    8000264a:	01e75593          	srli	a1,a4,0x1e
    8000264e:	97ae                	add	a5,a5,a1
    80002650:	89be                	mv	s3,a5
    80002652:	4384                	lw	s1,0(a5)
    80002654:	cc89                	beqz	s1,8000266e <bmap+0x9a>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002656:	8552                	mv	a0,s4
    80002658:	d1fff0ef          	jal	80002376 <brelse>
    return addr;
    8000265c:	6a02                	ld	s4,0(sp)
  }

  panic("bmap: out of range");
}
    8000265e:	8526                	mv	a0,s1
    80002660:	70a2                	ld	ra,40(sp)
    80002662:	7402                	ld	s0,32(sp)
    80002664:	64e2                	ld	s1,24(sp)
    80002666:	6942                	ld	s2,16(sp)
    80002668:	69a2                	ld	s3,8(sp)
    8000266a:	6145                	addi	sp,sp,48
    8000266c:	8082                	ret
      addr = balloc(ip->dev);
    8000266e:	00092503          	lw	a0,0(s2)
    80002672:	e5dff0ef          	jal	800024ce <balloc>
    80002676:	84aa                	mv	s1,a0
      if(addr){
    80002678:	dd79                	beqz	a0,80002656 <bmap+0x82>
        a[bn] = addr;
    8000267a:	00a9a023          	sw	a0,0(s3)
        log_write(bp);
    8000267e:	8552                	mv	a0,s4
    80002680:	62d000ef          	jal	800034ac <log_write>
    80002684:	bfc9                	j	80002656 <bmap+0x82>
    80002686:	e052                	sd	s4,0(sp)
  panic("bmap: out of range");
    80002688:	00005517          	auipc	a0,0x5
    8000268c:	d8050513          	addi	a0,a0,-640 # 80007408 <etext+0x408>
    80002690:	2d8030ef          	jal	80005968 <panic>

0000000080002694 <iget>:
{
    80002694:	7179                	addi	sp,sp,-48
    80002696:	f406                	sd	ra,40(sp)
    80002698:	f022                	sd	s0,32(sp)
    8000269a:	ec26                	sd	s1,24(sp)
    8000269c:	e84a                	sd	s2,16(sp)
    8000269e:	e44e                	sd	s3,8(sp)
    800026a0:	e052                	sd	s4,0(sp)
    800026a2:	1800                	addi	s0,sp,48
    800026a4:	892a                	mv	s2,a0
    800026a6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800026a8:	00233517          	auipc	a0,0x233
    800026ac:	79050513          	addi	a0,a0,1936 # 80235e38 <itable>
    800026b0:	55a030ef          	jal	80005c0a <acquire>
  empty = 0;
    800026b4:	4981                	li	s3,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800026b6:	00233497          	auipc	s1,0x233
    800026ba:	79a48493          	addi	s1,s1,1946 # 80235e50 <itable+0x18>
    800026be:	00235697          	auipc	a3,0x235
    800026c2:	22268693          	addi	a3,a3,546 # 802378e0 <log>
    800026c6:	a809                	j	800026d8 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    800026c8:	e781                	bnez	a5,800026d0 <iget+0x3c>
    800026ca:	00099363          	bnez	s3,800026d0 <iget+0x3c>
      empty = ip;
    800026ce:	89a6                	mv	s3,s1
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800026d0:	08848493          	addi	s1,s1,136
    800026d4:	02d48563          	beq	s1,a3,800026fe <iget+0x6a>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    800026d8:	449c                	lw	a5,8(s1)
    800026da:	fef057e3          	blez	a5,800026c8 <iget+0x34>
    800026de:	4098                	lw	a4,0(s1)
    800026e0:	ff2718e3          	bne	a4,s2,800026d0 <iget+0x3c>
    800026e4:	40d8                	lw	a4,4(s1)
    800026e6:	ff4715e3          	bne	a4,s4,800026d0 <iget+0x3c>
      ip->ref++;
    800026ea:	2785                	addiw	a5,a5,1
    800026ec:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    800026ee:	00233517          	auipc	a0,0x233
    800026f2:	74a50513          	addi	a0,a0,1866 # 80235e38 <itable>
    800026f6:	5a8030ef          	jal	80005c9e <release>
      return ip;
    800026fa:	89a6                	mv	s3,s1
    800026fc:	a015                	j	80002720 <iget+0x8c>
  if(empty == 0)
    800026fe:	02098a63          	beqz	s3,80002732 <iget+0x9e>
  ip->dev = dev;
    80002702:	0129a023          	sw	s2,0(s3)
  ip->inum = inum;
    80002706:	0149a223          	sw	s4,4(s3)
  ip->ref = 1;
    8000270a:	4785                	li	a5,1
    8000270c:	00f9a423          	sw	a5,8(s3)
  ip->valid = 0;
    80002710:	0409a023          	sw	zero,64(s3)
  release(&itable.lock);
    80002714:	00233517          	auipc	a0,0x233
    80002718:	72450513          	addi	a0,a0,1828 # 80235e38 <itable>
    8000271c:	582030ef          	jal	80005c9e <release>
}
    80002720:	854e                	mv	a0,s3
    80002722:	70a2                	ld	ra,40(sp)
    80002724:	7402                	ld	s0,32(sp)
    80002726:	64e2                	ld	s1,24(sp)
    80002728:	6942                	ld	s2,16(sp)
    8000272a:	69a2                	ld	s3,8(sp)
    8000272c:	6a02                	ld	s4,0(sp)
    8000272e:	6145                	addi	sp,sp,48
    80002730:	8082                	ret
    panic("iget: no inodes");
    80002732:	00005517          	auipc	a0,0x5
    80002736:	cee50513          	addi	a0,a0,-786 # 80007420 <etext+0x420>
    8000273a:	22e030ef          	jal	80005968 <panic>

000000008000273e <iinit>:
{
    8000273e:	7179                	addi	sp,sp,-48
    80002740:	f406                	sd	ra,40(sp)
    80002742:	f022                	sd	s0,32(sp)
    80002744:	ec26                	sd	s1,24(sp)
    80002746:	e84a                	sd	s2,16(sp)
    80002748:	e44e                	sd	s3,8(sp)
    8000274a:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    8000274c:	00005597          	auipc	a1,0x5
    80002750:	ce458593          	addi	a1,a1,-796 # 80007430 <etext+0x430>
    80002754:	00233517          	auipc	a0,0x233
    80002758:	6e450513          	addi	a0,a0,1764 # 80235e38 <itable>
    8000275c:	424030ef          	jal	80005b80 <initlock>
  for(i = 0; i < NINODE; i++) {
    80002760:	00233497          	auipc	s1,0x233
    80002764:	70048493          	addi	s1,s1,1792 # 80235e60 <itable+0x28>
    80002768:	00235997          	auipc	s3,0x235
    8000276c:	18898993          	addi	s3,s3,392 # 802378f0 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002770:	00005917          	auipc	s2,0x5
    80002774:	cc890913          	addi	s2,s2,-824 # 80007438 <etext+0x438>
    80002778:	85ca                	mv	a1,s2
    8000277a:	8526                	mv	a0,s1
    8000277c:	5f5000ef          	jal	80003570 <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002780:	08848493          	addi	s1,s1,136
    80002784:	ff349ae3          	bne	s1,s3,80002778 <iinit+0x3a>
}
    80002788:	70a2                	ld	ra,40(sp)
    8000278a:	7402                	ld	s0,32(sp)
    8000278c:	64e2                	ld	s1,24(sp)
    8000278e:	6942                	ld	s2,16(sp)
    80002790:	69a2                	ld	s3,8(sp)
    80002792:	6145                	addi	sp,sp,48
    80002794:	8082                	ret

0000000080002796 <ialloc>:
{
    80002796:	7139                	addi	sp,sp,-64
    80002798:	fc06                	sd	ra,56(sp)
    8000279a:	f822                	sd	s0,48(sp)
    8000279c:	0080                	addi	s0,sp,64
  for(inum = 1; inum < sb.ninodes; inum++){
    8000279e:	00233717          	auipc	a4,0x233
    800027a2:	68672703          	lw	a4,1670(a4) # 80235e24 <sb+0xc>
    800027a6:	4785                	li	a5,1
    800027a8:	06e7f063          	bgeu	a5,a4,80002808 <ialloc+0x72>
    800027ac:	f426                	sd	s1,40(sp)
    800027ae:	f04a                	sd	s2,32(sp)
    800027b0:	ec4e                	sd	s3,24(sp)
    800027b2:	e852                	sd	s4,16(sp)
    800027b4:	e456                	sd	s5,8(sp)
    800027b6:	e05a                	sd	s6,0(sp)
    800027b8:	8aaa                	mv	s5,a0
    800027ba:	8b2e                	mv	s6,a1
    800027bc:	893e                	mv	s2,a5
    bp = bread(dev, IBLOCK(inum, sb));
    800027be:	00233a17          	auipc	s4,0x233
    800027c2:	65aa0a13          	addi	s4,s4,1626 # 80235e18 <sb>
    800027c6:	00495593          	srli	a1,s2,0x4
    800027ca:	018a2783          	lw	a5,24(s4)
    800027ce:	9dbd                	addw	a1,a1,a5
    800027d0:	8556                	mv	a0,s5
    800027d2:	a9dff0ef          	jal	8000226e <bread>
    800027d6:	84aa                	mv	s1,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    800027d8:	05850993          	addi	s3,a0,88
    800027dc:	00f97793          	andi	a5,s2,15
    800027e0:	079a                	slli	a5,a5,0x6
    800027e2:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    800027e4:	00099783          	lh	a5,0(s3)
    800027e8:	cb9d                	beqz	a5,8000281e <ialloc+0x88>
    brelse(bp);
    800027ea:	b8dff0ef          	jal	80002376 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    800027ee:	0905                	addi	s2,s2,1
    800027f0:	00ca2703          	lw	a4,12(s4)
    800027f4:	0009079b          	sext.w	a5,s2
    800027f8:	fce7e7e3          	bltu	a5,a4,800027c6 <ialloc+0x30>
    800027fc:	74a2                	ld	s1,40(sp)
    800027fe:	7902                	ld	s2,32(sp)
    80002800:	69e2                	ld	s3,24(sp)
    80002802:	6a42                	ld	s4,16(sp)
    80002804:	6aa2                	ld	s5,8(sp)
    80002806:	6b02                	ld	s6,0(sp)
  printf("ialloc: no inodes\n");
    80002808:	00005517          	auipc	a0,0x5
    8000280c:	c3850513          	addi	a0,a0,-968 # 80007440 <etext+0x440>
    80002810:	5ad020ef          	jal	800055bc <printf>
  return 0;
    80002814:	4501                	li	a0,0
}
    80002816:	70e2                	ld	ra,56(sp)
    80002818:	7442                	ld	s0,48(sp)
    8000281a:	6121                	addi	sp,sp,64
    8000281c:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    8000281e:	04000613          	li	a2,64
    80002822:	4581                	li	a1,0
    80002824:	854e                	mv	a0,s3
    80002826:	a7ffd0ef          	jal	800002a4 <memset>
      dip->type = type;
    8000282a:	01699023          	sh	s6,0(s3)
      log_write(bp);   // mark it allocated on the disk
    8000282e:	8526                	mv	a0,s1
    80002830:	47d000ef          	jal	800034ac <log_write>
      brelse(bp);
    80002834:	8526                	mv	a0,s1
    80002836:	b41ff0ef          	jal	80002376 <brelse>
      return iget(dev, inum);
    8000283a:	0009059b          	sext.w	a1,s2
    8000283e:	8556                	mv	a0,s5
    80002840:	e55ff0ef          	jal	80002694 <iget>
    80002844:	74a2                	ld	s1,40(sp)
    80002846:	7902                	ld	s2,32(sp)
    80002848:	69e2                	ld	s3,24(sp)
    8000284a:	6a42                	ld	s4,16(sp)
    8000284c:	6aa2                	ld	s5,8(sp)
    8000284e:	6b02                	ld	s6,0(sp)
    80002850:	b7d9                	j	80002816 <ialloc+0x80>

0000000080002852 <iupdate>:
{
    80002852:	1101                	addi	sp,sp,-32
    80002854:	ec06                	sd	ra,24(sp)
    80002856:	e822                	sd	s0,16(sp)
    80002858:	e426                	sd	s1,8(sp)
    8000285a:	e04a                	sd	s2,0(sp)
    8000285c:	1000                	addi	s0,sp,32
    8000285e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002860:	415c                	lw	a5,4(a0)
    80002862:	0047d79b          	srliw	a5,a5,0x4
    80002866:	00233597          	auipc	a1,0x233
    8000286a:	5ca5a583          	lw	a1,1482(a1) # 80235e30 <sb+0x18>
    8000286e:	9dbd                	addw	a1,a1,a5
    80002870:	4108                	lw	a0,0(a0)
    80002872:	9fdff0ef          	jal	8000226e <bread>
    80002876:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002878:	05850793          	addi	a5,a0,88
    8000287c:	40d8                	lw	a4,4(s1)
    8000287e:	8b3d                	andi	a4,a4,15
    80002880:	071a                	slli	a4,a4,0x6
    80002882:	97ba                	add	a5,a5,a4
  dip->type = ip->type;
    80002884:	04449703          	lh	a4,68(s1)
    80002888:	00e79023          	sh	a4,0(a5)
  dip->major = ip->major;
    8000288c:	04649703          	lh	a4,70(s1)
    80002890:	00e79123          	sh	a4,2(a5)
  dip->minor = ip->minor;
    80002894:	04849703          	lh	a4,72(s1)
    80002898:	00e79223          	sh	a4,4(a5)
  dip->nlink = ip->nlink;
    8000289c:	04a49703          	lh	a4,74(s1)
    800028a0:	00e79323          	sh	a4,6(a5)
  dip->size = ip->size;
    800028a4:	44f8                	lw	a4,76(s1)
    800028a6:	c798                	sw	a4,8(a5)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    800028a8:	03400613          	li	a2,52
    800028ac:	05048593          	addi	a1,s1,80
    800028b0:	00c78513          	addi	a0,a5,12
    800028b4:	a51fd0ef          	jal	80000304 <memmove>
  log_write(bp);
    800028b8:	854a                	mv	a0,s2
    800028ba:	3f3000ef          	jal	800034ac <log_write>
  brelse(bp);
    800028be:	854a                	mv	a0,s2
    800028c0:	ab7ff0ef          	jal	80002376 <brelse>
}
    800028c4:	60e2                	ld	ra,24(sp)
    800028c6:	6442                	ld	s0,16(sp)
    800028c8:	64a2                	ld	s1,8(sp)
    800028ca:	6902                	ld	s2,0(sp)
    800028cc:	6105                	addi	sp,sp,32
    800028ce:	8082                	ret

00000000800028d0 <idup>:
{
    800028d0:	1101                	addi	sp,sp,-32
    800028d2:	ec06                	sd	ra,24(sp)
    800028d4:	e822                	sd	s0,16(sp)
    800028d6:	e426                	sd	s1,8(sp)
    800028d8:	1000                	addi	s0,sp,32
    800028da:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    800028dc:	00233517          	auipc	a0,0x233
    800028e0:	55c50513          	addi	a0,a0,1372 # 80235e38 <itable>
    800028e4:	326030ef          	jal	80005c0a <acquire>
  ip->ref++;
    800028e8:	449c                	lw	a5,8(s1)
    800028ea:	2785                	addiw	a5,a5,1
    800028ec:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    800028ee:	00233517          	auipc	a0,0x233
    800028f2:	54a50513          	addi	a0,a0,1354 # 80235e38 <itable>
    800028f6:	3a8030ef          	jal	80005c9e <release>
}
    800028fa:	8526                	mv	a0,s1
    800028fc:	60e2                	ld	ra,24(sp)
    800028fe:	6442                	ld	s0,16(sp)
    80002900:	64a2                	ld	s1,8(sp)
    80002902:	6105                	addi	sp,sp,32
    80002904:	8082                	ret

0000000080002906 <ilock>:
{
    80002906:	1101                	addi	sp,sp,-32
    80002908:	ec06                	sd	ra,24(sp)
    8000290a:	e822                	sd	s0,16(sp)
    8000290c:	e426                	sd	s1,8(sp)
    8000290e:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002910:	cd19                	beqz	a0,8000292e <ilock+0x28>
    80002912:	84aa                	mv	s1,a0
    80002914:	451c                	lw	a5,8(a0)
    80002916:	00f05c63          	blez	a5,8000292e <ilock+0x28>
  acquiresleep(&ip->lock);
    8000291a:	0541                	addi	a0,a0,16
    8000291c:	48b000ef          	jal	800035a6 <acquiresleep>
  if(ip->valid == 0){
    80002920:	40bc                	lw	a5,64(s1)
    80002922:	cf89                	beqz	a5,8000293c <ilock+0x36>
}
    80002924:	60e2                	ld	ra,24(sp)
    80002926:	6442                	ld	s0,16(sp)
    80002928:	64a2                	ld	s1,8(sp)
    8000292a:	6105                	addi	sp,sp,32
    8000292c:	8082                	ret
    8000292e:	e04a                	sd	s2,0(sp)
    panic("ilock");
    80002930:	00005517          	auipc	a0,0x5
    80002934:	b2850513          	addi	a0,a0,-1240 # 80007458 <etext+0x458>
    80002938:	030030ef          	jal	80005968 <panic>
    8000293c:	e04a                	sd	s2,0(sp)
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    8000293e:	40dc                	lw	a5,4(s1)
    80002940:	0047d79b          	srliw	a5,a5,0x4
    80002944:	00233597          	auipc	a1,0x233
    80002948:	4ec5a583          	lw	a1,1260(a1) # 80235e30 <sb+0x18>
    8000294c:	9dbd                	addw	a1,a1,a5
    8000294e:	4088                	lw	a0,0(s1)
    80002950:	91fff0ef          	jal	8000226e <bread>
    80002954:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002956:	05850593          	addi	a1,a0,88
    8000295a:	40dc                	lw	a5,4(s1)
    8000295c:	8bbd                	andi	a5,a5,15
    8000295e:	079a                	slli	a5,a5,0x6
    80002960:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002962:	00059783          	lh	a5,0(a1)
    80002966:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    8000296a:	00259783          	lh	a5,2(a1)
    8000296e:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002972:	00459783          	lh	a5,4(a1)
    80002976:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    8000297a:	00659783          	lh	a5,6(a1)
    8000297e:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002982:	459c                	lw	a5,8(a1)
    80002984:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002986:	03400613          	li	a2,52
    8000298a:	05b1                	addi	a1,a1,12
    8000298c:	05048513          	addi	a0,s1,80
    80002990:	975fd0ef          	jal	80000304 <memmove>
    brelse(bp);
    80002994:	854a                	mv	a0,s2
    80002996:	9e1ff0ef          	jal	80002376 <brelse>
    ip->valid = 1;
    8000299a:	4785                	li	a5,1
    8000299c:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    8000299e:	04449783          	lh	a5,68(s1)
    800029a2:	c399                	beqz	a5,800029a8 <ilock+0xa2>
    800029a4:	6902                	ld	s2,0(sp)
    800029a6:	bfbd                	j	80002924 <ilock+0x1e>
      panic("ilock: no type");
    800029a8:	00005517          	auipc	a0,0x5
    800029ac:	ab850513          	addi	a0,a0,-1352 # 80007460 <etext+0x460>
    800029b0:	7b9020ef          	jal	80005968 <panic>

00000000800029b4 <iunlock>:
{
    800029b4:	1101                	addi	sp,sp,-32
    800029b6:	ec06                	sd	ra,24(sp)
    800029b8:	e822                	sd	s0,16(sp)
    800029ba:	e426                	sd	s1,8(sp)
    800029bc:	e04a                	sd	s2,0(sp)
    800029be:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    800029c0:	c505                	beqz	a0,800029e8 <iunlock+0x34>
    800029c2:	84aa                	mv	s1,a0
    800029c4:	01050913          	addi	s2,a0,16
    800029c8:	854a                	mv	a0,s2
    800029ca:	45b000ef          	jal	80003624 <holdingsleep>
    800029ce:	cd09                	beqz	a0,800029e8 <iunlock+0x34>
    800029d0:	449c                	lw	a5,8(s1)
    800029d2:	00f05b63          	blez	a5,800029e8 <iunlock+0x34>
  releasesleep(&ip->lock);
    800029d6:	854a                	mv	a0,s2
    800029d8:	415000ef          	jal	800035ec <releasesleep>
}
    800029dc:	60e2                	ld	ra,24(sp)
    800029de:	6442                	ld	s0,16(sp)
    800029e0:	64a2                	ld	s1,8(sp)
    800029e2:	6902                	ld	s2,0(sp)
    800029e4:	6105                	addi	sp,sp,32
    800029e6:	8082                	ret
    panic("iunlock");
    800029e8:	00005517          	auipc	a0,0x5
    800029ec:	a8850513          	addi	a0,a0,-1400 # 80007470 <etext+0x470>
    800029f0:	779020ef          	jal	80005968 <panic>

00000000800029f4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    800029f4:	7179                	addi	sp,sp,-48
    800029f6:	f406                	sd	ra,40(sp)
    800029f8:	f022                	sd	s0,32(sp)
    800029fa:	ec26                	sd	s1,24(sp)
    800029fc:	e84a                	sd	s2,16(sp)
    800029fe:	e44e                	sd	s3,8(sp)
    80002a00:	1800                	addi	s0,sp,48
    80002a02:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002a04:	05050493          	addi	s1,a0,80
    80002a08:	08050913          	addi	s2,a0,128
    80002a0c:	a021                	j	80002a14 <itrunc+0x20>
    80002a0e:	0491                	addi	s1,s1,4
    80002a10:	01248b63          	beq	s1,s2,80002a26 <itrunc+0x32>
    if(ip->addrs[i]){
    80002a14:	408c                	lw	a1,0(s1)
    80002a16:	dde5                	beqz	a1,80002a0e <itrunc+0x1a>
      bfree(ip->dev, ip->addrs[i]);
    80002a18:	0009a503          	lw	a0,0(s3)
    80002a1c:	a47ff0ef          	jal	80002462 <bfree>
      ip->addrs[i] = 0;
    80002a20:	0004a023          	sw	zero,0(s1)
    80002a24:	b7ed                	j	80002a0e <itrunc+0x1a>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002a26:	0809a583          	lw	a1,128(s3)
    80002a2a:	ed89                	bnez	a1,80002a44 <itrunc+0x50>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002a2c:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002a30:	854e                	mv	a0,s3
    80002a32:	e21ff0ef          	jal	80002852 <iupdate>
}
    80002a36:	70a2                	ld	ra,40(sp)
    80002a38:	7402                	ld	s0,32(sp)
    80002a3a:	64e2                	ld	s1,24(sp)
    80002a3c:	6942                	ld	s2,16(sp)
    80002a3e:	69a2                	ld	s3,8(sp)
    80002a40:	6145                	addi	sp,sp,48
    80002a42:	8082                	ret
    80002a44:	e052                	sd	s4,0(sp)
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002a46:	0009a503          	lw	a0,0(s3)
    80002a4a:	825ff0ef          	jal	8000226e <bread>
    80002a4e:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002a50:	05850493          	addi	s1,a0,88
    80002a54:	45850913          	addi	s2,a0,1112
    80002a58:	a021                	j	80002a60 <itrunc+0x6c>
    80002a5a:	0491                	addi	s1,s1,4
    80002a5c:	01248963          	beq	s1,s2,80002a6e <itrunc+0x7a>
      if(a[j])
    80002a60:	408c                	lw	a1,0(s1)
    80002a62:	dde5                	beqz	a1,80002a5a <itrunc+0x66>
        bfree(ip->dev, a[j]);
    80002a64:	0009a503          	lw	a0,0(s3)
    80002a68:	9fbff0ef          	jal	80002462 <bfree>
    80002a6c:	b7fd                	j	80002a5a <itrunc+0x66>
    brelse(bp);
    80002a6e:	8552                	mv	a0,s4
    80002a70:	907ff0ef          	jal	80002376 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002a74:	0809a583          	lw	a1,128(s3)
    80002a78:	0009a503          	lw	a0,0(s3)
    80002a7c:	9e7ff0ef          	jal	80002462 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002a80:	0809a023          	sw	zero,128(s3)
    80002a84:	6a02                	ld	s4,0(sp)
    80002a86:	b75d                	j	80002a2c <itrunc+0x38>

0000000080002a88 <iput>:
{
    80002a88:	1101                	addi	sp,sp,-32
    80002a8a:	ec06                	sd	ra,24(sp)
    80002a8c:	e822                	sd	s0,16(sp)
    80002a8e:	e426                	sd	s1,8(sp)
    80002a90:	1000                	addi	s0,sp,32
    80002a92:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002a94:	00233517          	auipc	a0,0x233
    80002a98:	3a450513          	addi	a0,a0,932 # 80235e38 <itable>
    80002a9c:	16e030ef          	jal	80005c0a <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002aa0:	4498                	lw	a4,8(s1)
    80002aa2:	4785                	li	a5,1
    80002aa4:	02f70063          	beq	a4,a5,80002ac4 <iput+0x3c>
  ip->ref--;
    80002aa8:	449c                	lw	a5,8(s1)
    80002aaa:	37fd                	addiw	a5,a5,-1
    80002aac:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002aae:	00233517          	auipc	a0,0x233
    80002ab2:	38a50513          	addi	a0,a0,906 # 80235e38 <itable>
    80002ab6:	1e8030ef          	jal	80005c9e <release>
}
    80002aba:	60e2                	ld	ra,24(sp)
    80002abc:	6442                	ld	s0,16(sp)
    80002abe:	64a2                	ld	s1,8(sp)
    80002ac0:	6105                	addi	sp,sp,32
    80002ac2:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002ac4:	40bc                	lw	a5,64(s1)
    80002ac6:	d3ed                	beqz	a5,80002aa8 <iput+0x20>
    80002ac8:	04a49783          	lh	a5,74(s1)
    80002acc:	fff1                	bnez	a5,80002aa8 <iput+0x20>
    80002ace:	e04a                	sd	s2,0(sp)
    acquiresleep(&ip->lock);
    80002ad0:	01048793          	addi	a5,s1,16
    80002ad4:	893e                	mv	s2,a5
    80002ad6:	853e                	mv	a0,a5
    80002ad8:	2cf000ef          	jal	800035a6 <acquiresleep>
    release(&itable.lock);
    80002adc:	00233517          	auipc	a0,0x233
    80002ae0:	35c50513          	addi	a0,a0,860 # 80235e38 <itable>
    80002ae4:	1ba030ef          	jal	80005c9e <release>
    itrunc(ip);
    80002ae8:	8526                	mv	a0,s1
    80002aea:	f0bff0ef          	jal	800029f4 <itrunc>
    ip->type = 0;
    80002aee:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002af2:	8526                	mv	a0,s1
    80002af4:	d5fff0ef          	jal	80002852 <iupdate>
    ip->valid = 0;
    80002af8:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002afc:	854a                	mv	a0,s2
    80002afe:	2ef000ef          	jal	800035ec <releasesleep>
    acquire(&itable.lock);
    80002b02:	00233517          	auipc	a0,0x233
    80002b06:	33650513          	addi	a0,a0,822 # 80235e38 <itable>
    80002b0a:	100030ef          	jal	80005c0a <acquire>
    80002b0e:	6902                	ld	s2,0(sp)
    80002b10:	bf61                	j	80002aa8 <iput+0x20>

0000000080002b12 <iunlockput>:
{
    80002b12:	1101                	addi	sp,sp,-32
    80002b14:	ec06                	sd	ra,24(sp)
    80002b16:	e822                	sd	s0,16(sp)
    80002b18:	e426                	sd	s1,8(sp)
    80002b1a:	1000                	addi	s0,sp,32
    80002b1c:	84aa                	mv	s1,a0
  iunlock(ip);
    80002b1e:	e97ff0ef          	jal	800029b4 <iunlock>
  iput(ip);
    80002b22:	8526                	mv	a0,s1
    80002b24:	f65ff0ef          	jal	80002a88 <iput>
}
    80002b28:	60e2                	ld	ra,24(sp)
    80002b2a:	6442                	ld	s0,16(sp)
    80002b2c:	64a2                	ld	s1,8(sp)
    80002b2e:	6105                	addi	sp,sp,32
    80002b30:	8082                	ret

0000000080002b32 <ireclaim>:
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002b32:	00233717          	auipc	a4,0x233
    80002b36:	2f272703          	lw	a4,754(a4) # 80235e24 <sb+0xc>
    80002b3a:	4785                	li	a5,1
    80002b3c:	0ae7fe63          	bgeu	a5,a4,80002bf8 <ireclaim+0xc6>
{
    80002b40:	7139                	addi	sp,sp,-64
    80002b42:	fc06                	sd	ra,56(sp)
    80002b44:	f822                	sd	s0,48(sp)
    80002b46:	f426                	sd	s1,40(sp)
    80002b48:	f04a                	sd	s2,32(sp)
    80002b4a:	ec4e                	sd	s3,24(sp)
    80002b4c:	e852                	sd	s4,16(sp)
    80002b4e:	e456                	sd	s5,8(sp)
    80002b50:	e05a                	sd	s6,0(sp)
    80002b52:	0080                	addi	s0,sp,64
    80002b54:	8aaa                	mv	s5,a0
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002b56:	84be                	mv	s1,a5
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002b58:	00233a17          	auipc	s4,0x233
    80002b5c:	2c0a0a13          	addi	s4,s4,704 # 80235e18 <sb>
      printf("ireclaim: orphaned inode %d\n", inum);
    80002b60:	00005b17          	auipc	s6,0x5
    80002b64:	918b0b13          	addi	s6,s6,-1768 # 80007478 <etext+0x478>
    80002b68:	a099                	j	80002bae <ireclaim+0x7c>
    80002b6a:	85ce                	mv	a1,s3
    80002b6c:	855a                	mv	a0,s6
    80002b6e:	24f020ef          	jal	800055bc <printf>
      ip = iget(dev, inum);
    80002b72:	85ce                	mv	a1,s3
    80002b74:	8556                	mv	a0,s5
    80002b76:	b1fff0ef          	jal	80002694 <iget>
    80002b7a:	89aa                	mv	s3,a0
    brelse(bp);
    80002b7c:	854a                	mv	a0,s2
    80002b7e:	ff8ff0ef          	jal	80002376 <brelse>
    if (ip) {
    80002b82:	00098f63          	beqz	s3,80002ba0 <ireclaim+0x6e>
      begin_op();
    80002b86:	78c000ef          	jal	80003312 <begin_op>
      ilock(ip);
    80002b8a:	854e                	mv	a0,s3
    80002b8c:	d7bff0ef          	jal	80002906 <ilock>
      iunlock(ip);
    80002b90:	854e                	mv	a0,s3
    80002b92:	e23ff0ef          	jal	800029b4 <iunlock>
      iput(ip);
    80002b96:	854e                	mv	a0,s3
    80002b98:	ef1ff0ef          	jal	80002a88 <iput>
      end_op();
    80002b9c:	7e6000ef          	jal	80003382 <end_op>
  for (int inum = 1; inum < sb.ninodes; inum++) {
    80002ba0:	0485                	addi	s1,s1,1
    80002ba2:	00ca2703          	lw	a4,12(s4)
    80002ba6:	0004879b          	sext.w	a5,s1
    80002baa:	02e7fd63          	bgeu	a5,a4,80002be4 <ireclaim+0xb2>
    80002bae:	0004899b          	sext.w	s3,s1
    struct buf *bp = bread(dev, IBLOCK(inum, sb));
    80002bb2:	0044d593          	srli	a1,s1,0x4
    80002bb6:	018a2783          	lw	a5,24(s4)
    80002bba:	9dbd                	addw	a1,a1,a5
    80002bbc:	8556                	mv	a0,s5
    80002bbe:	eb0ff0ef          	jal	8000226e <bread>
    80002bc2:	892a                	mv	s2,a0
    struct dinode *dip = (struct dinode *)bp->data + inum % IPB;
    80002bc4:	05850793          	addi	a5,a0,88
    80002bc8:	00f9f713          	andi	a4,s3,15
    80002bcc:	071a                	slli	a4,a4,0x6
    80002bce:	97ba                	add	a5,a5,a4
    if (dip->type != 0 && dip->nlink == 0) {  // is an orphaned inode
    80002bd0:	00079703          	lh	a4,0(a5)
    80002bd4:	c701                	beqz	a4,80002bdc <ireclaim+0xaa>
    80002bd6:	00679783          	lh	a5,6(a5)
    80002bda:	dbc1                	beqz	a5,80002b6a <ireclaim+0x38>
    brelse(bp);
    80002bdc:	854a                	mv	a0,s2
    80002bde:	f98ff0ef          	jal	80002376 <brelse>
    if (ip) {
    80002be2:	bf7d                	j	80002ba0 <ireclaim+0x6e>
}
    80002be4:	70e2                	ld	ra,56(sp)
    80002be6:	7442                	ld	s0,48(sp)
    80002be8:	74a2                	ld	s1,40(sp)
    80002bea:	7902                	ld	s2,32(sp)
    80002bec:	69e2                	ld	s3,24(sp)
    80002bee:	6a42                	ld	s4,16(sp)
    80002bf0:	6aa2                	ld	s5,8(sp)
    80002bf2:	6b02                	ld	s6,0(sp)
    80002bf4:	6121                	addi	sp,sp,64
    80002bf6:	8082                	ret
    80002bf8:	8082                	ret

0000000080002bfa <fsinit>:
fsinit(int dev) {
    80002bfa:	1101                	addi	sp,sp,-32
    80002bfc:	ec06                	sd	ra,24(sp)
    80002bfe:	e822                	sd	s0,16(sp)
    80002c00:	e426                	sd	s1,8(sp)
    80002c02:	e04a                	sd	s2,0(sp)
    80002c04:	1000                	addi	s0,sp,32
    80002c06:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    80002c08:	4585                	li	a1,1
    80002c0a:	e64ff0ef          	jal	8000226e <bread>
    80002c0e:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    80002c10:	02000613          	li	a2,32
    80002c14:	05850593          	addi	a1,a0,88
    80002c18:	00233517          	auipc	a0,0x233
    80002c1c:	20050513          	addi	a0,a0,512 # 80235e18 <sb>
    80002c20:	ee4fd0ef          	jal	80000304 <memmove>
  brelse(bp);
    80002c24:	8526                	mv	a0,s1
    80002c26:	f50ff0ef          	jal	80002376 <brelse>
  if(sb.magic != FSMAGIC)
    80002c2a:	00233717          	auipc	a4,0x233
    80002c2e:	1ee72703          	lw	a4,494(a4) # 80235e18 <sb>
    80002c32:	102037b7          	lui	a5,0x10203
    80002c36:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002c3a:	02f71263          	bne	a4,a5,80002c5e <fsinit+0x64>
  initlog(dev, &sb);
    80002c3e:	00233597          	auipc	a1,0x233
    80002c42:	1da58593          	addi	a1,a1,474 # 80235e18 <sb>
    80002c46:	854a                	mv	a0,s2
    80002c48:	648000ef          	jal	80003290 <initlog>
  ireclaim(dev);
    80002c4c:	854a                	mv	a0,s2
    80002c4e:	ee5ff0ef          	jal	80002b32 <ireclaim>
}
    80002c52:	60e2                	ld	ra,24(sp)
    80002c54:	6442                	ld	s0,16(sp)
    80002c56:	64a2                	ld	s1,8(sp)
    80002c58:	6902                	ld	s2,0(sp)
    80002c5a:	6105                	addi	sp,sp,32
    80002c5c:	8082                	ret
    panic("invalid file system");
    80002c5e:	00005517          	auipc	a0,0x5
    80002c62:	83a50513          	addi	a0,a0,-1990 # 80007498 <etext+0x498>
    80002c66:	503020ef          	jal	80005968 <panic>

0000000080002c6a <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002c6a:	1141                	addi	sp,sp,-16
    80002c6c:	e406                	sd	ra,8(sp)
    80002c6e:	e022                	sd	s0,0(sp)
    80002c70:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002c72:	411c                	lw	a5,0(a0)
    80002c74:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002c76:	415c                	lw	a5,4(a0)
    80002c78:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002c7a:	04451783          	lh	a5,68(a0)
    80002c7e:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002c82:	04a51783          	lh	a5,74(a0)
    80002c86:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002c8a:	04c56783          	lwu	a5,76(a0)
    80002c8e:	e99c                	sd	a5,16(a1)
}
    80002c90:	60a2                	ld	ra,8(sp)
    80002c92:	6402                	ld	s0,0(sp)
    80002c94:	0141                	addi	sp,sp,16
    80002c96:	8082                	ret

0000000080002c98 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002c98:	457c                	lw	a5,76(a0)
    80002c9a:	0ed7e663          	bltu	a5,a3,80002d86 <readi+0xee>
{
    80002c9e:	7159                	addi	sp,sp,-112
    80002ca0:	f486                	sd	ra,104(sp)
    80002ca2:	f0a2                	sd	s0,96(sp)
    80002ca4:	eca6                	sd	s1,88(sp)
    80002ca6:	e0d2                	sd	s4,64(sp)
    80002ca8:	fc56                	sd	s5,56(sp)
    80002caa:	f85a                	sd	s6,48(sp)
    80002cac:	f45e                	sd	s7,40(sp)
    80002cae:	1880                	addi	s0,sp,112
    80002cb0:	8b2a                	mv	s6,a0
    80002cb2:	8bae                	mv	s7,a1
    80002cb4:	8a32                	mv	s4,a2
    80002cb6:	84b6                	mv	s1,a3
    80002cb8:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002cba:	9f35                	addw	a4,a4,a3
    return 0;
    80002cbc:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002cbe:	0ad76b63          	bltu	a4,a3,80002d74 <readi+0xdc>
    80002cc2:	e4ce                	sd	s3,72(sp)
  if(off + n > ip->size)
    80002cc4:	00e7f463          	bgeu	a5,a4,80002ccc <readi+0x34>
    n = ip->size - off;
    80002cc8:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002ccc:	080a8b63          	beqz	s5,80002d62 <readi+0xca>
    80002cd0:	e8ca                	sd	s2,80(sp)
    80002cd2:	f062                	sd	s8,32(sp)
    80002cd4:	ec66                	sd	s9,24(sp)
    80002cd6:	e86a                	sd	s10,16(sp)
    80002cd8:	e46e                	sd	s11,8(sp)
    80002cda:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002cdc:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002ce0:	5c7d                	li	s8,-1
    80002ce2:	a80d                	j	80002d14 <readi+0x7c>
    80002ce4:	020d1d93          	slli	s11,s10,0x20
    80002ce8:	020ddd93          	srli	s11,s11,0x20
    80002cec:	05890613          	addi	a2,s2,88
    80002cf0:	86ee                	mv	a3,s11
    80002cf2:	963e                	add	a2,a2,a5
    80002cf4:	85d2                	mv	a1,s4
    80002cf6:	855e                	mv	a0,s7
    80002cf8:	c8ffe0ef          	jal	80001986 <either_copyout>
    80002cfc:	05850363          	beq	a0,s8,80002d42 <readi+0xaa>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002d00:	854a                	mv	a0,s2
    80002d02:	e74ff0ef          	jal	80002376 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d06:	013d09bb          	addw	s3,s10,s3
    80002d0a:	009d04bb          	addw	s1,s10,s1
    80002d0e:	9a6e                	add	s4,s4,s11
    80002d10:	0559f363          	bgeu	s3,s5,80002d56 <readi+0xbe>
    uint addr = bmap(ip, off/BSIZE);
    80002d14:	00a4d59b          	srliw	a1,s1,0xa
    80002d18:	855a                	mv	a0,s6
    80002d1a:	8bbff0ef          	jal	800025d4 <bmap>
    80002d1e:	85aa                	mv	a1,a0
    if(addr == 0)
    80002d20:	c139                	beqz	a0,80002d66 <readi+0xce>
    bp = bread(ip->dev, addr);
    80002d22:	000b2503          	lw	a0,0(s6)
    80002d26:	d48ff0ef          	jal	8000226e <bread>
    80002d2a:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002d2c:	3ff4f793          	andi	a5,s1,1023
    80002d30:	40fc873b          	subw	a4,s9,a5
    80002d34:	413a86bb          	subw	a3,s5,s3
    80002d38:	8d3a                	mv	s10,a4
    80002d3a:	fae6f5e3          	bgeu	a3,a4,80002ce4 <readi+0x4c>
    80002d3e:	8d36                	mv	s10,a3
    80002d40:	b755                	j	80002ce4 <readi+0x4c>
      brelse(bp);
    80002d42:	854a                	mv	a0,s2
    80002d44:	e32ff0ef          	jal	80002376 <brelse>
      tot = -1;
    80002d48:	59fd                	li	s3,-1
      break;
    80002d4a:	6946                	ld	s2,80(sp)
    80002d4c:	7c02                	ld	s8,32(sp)
    80002d4e:	6ce2                	ld	s9,24(sp)
    80002d50:	6d42                	ld	s10,16(sp)
    80002d52:	6da2                	ld	s11,8(sp)
    80002d54:	a831                	j	80002d70 <readi+0xd8>
    80002d56:	6946                	ld	s2,80(sp)
    80002d58:	7c02                	ld	s8,32(sp)
    80002d5a:	6ce2                	ld	s9,24(sp)
    80002d5c:	6d42                	ld	s10,16(sp)
    80002d5e:	6da2                	ld	s11,8(sp)
    80002d60:	a801                	j	80002d70 <readi+0xd8>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002d62:	89d6                	mv	s3,s5
    80002d64:	a031                	j	80002d70 <readi+0xd8>
    80002d66:	6946                	ld	s2,80(sp)
    80002d68:	7c02                	ld	s8,32(sp)
    80002d6a:	6ce2                	ld	s9,24(sp)
    80002d6c:	6d42                	ld	s10,16(sp)
    80002d6e:	6da2                	ld	s11,8(sp)
  }
  return tot;
    80002d70:	854e                	mv	a0,s3
    80002d72:	69a6                	ld	s3,72(sp)
}
    80002d74:	70a6                	ld	ra,104(sp)
    80002d76:	7406                	ld	s0,96(sp)
    80002d78:	64e6                	ld	s1,88(sp)
    80002d7a:	6a06                	ld	s4,64(sp)
    80002d7c:	7ae2                	ld	s5,56(sp)
    80002d7e:	7b42                	ld	s6,48(sp)
    80002d80:	7ba2                	ld	s7,40(sp)
    80002d82:	6165                	addi	sp,sp,112
    80002d84:	8082                	ret
    return 0;
    80002d86:	4501                	li	a0,0
}
    80002d88:	8082                	ret

0000000080002d8a <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002d8a:	457c                	lw	a5,76(a0)
    80002d8c:	0ed7eb63          	bltu	a5,a3,80002e82 <writei+0xf8>
{
    80002d90:	7159                	addi	sp,sp,-112
    80002d92:	f486                	sd	ra,104(sp)
    80002d94:	f0a2                	sd	s0,96(sp)
    80002d96:	e8ca                	sd	s2,80(sp)
    80002d98:	e0d2                	sd	s4,64(sp)
    80002d9a:	fc56                	sd	s5,56(sp)
    80002d9c:	f85a                	sd	s6,48(sp)
    80002d9e:	f45e                	sd	s7,40(sp)
    80002da0:	1880                	addi	s0,sp,112
    80002da2:	8aaa                	mv	s5,a0
    80002da4:	8bae                	mv	s7,a1
    80002da6:	8a32                	mv	s4,a2
    80002da8:	8936                	mv	s2,a3
    80002daa:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002dac:	00e687bb          	addw	a5,a3,a4
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002db0:	00043737          	lui	a4,0x43
    80002db4:	0cf76963          	bltu	a4,a5,80002e86 <writei+0xfc>
    80002db8:	0cd7e763          	bltu	a5,a3,80002e86 <writei+0xfc>
    80002dbc:	e4ce                	sd	s3,72(sp)
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002dbe:	0a0b0a63          	beqz	s6,80002e72 <writei+0xe8>
    80002dc2:	eca6                	sd	s1,88(sp)
    80002dc4:	f062                	sd	s8,32(sp)
    80002dc6:	ec66                	sd	s9,24(sp)
    80002dc8:	e86a                	sd	s10,16(sp)
    80002dca:	e46e                	sd	s11,8(sp)
    80002dcc:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002dce:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80002dd2:	5c7d                	li	s8,-1
    80002dd4:	a825                	j	80002e0c <writei+0x82>
    80002dd6:	020d1d93          	slli	s11,s10,0x20
    80002dda:	020ddd93          	srli	s11,s11,0x20
    80002dde:	05848513          	addi	a0,s1,88
    80002de2:	86ee                	mv	a3,s11
    80002de4:	8652                	mv	a2,s4
    80002de6:	85de                	mv	a1,s7
    80002de8:	953e                	add	a0,a0,a5
    80002dea:	be7fe0ef          	jal	800019d0 <either_copyin>
    80002dee:	05850663          	beq	a0,s8,80002e3a <writei+0xb0>
      brelse(bp);
      break;
    }
    log_write(bp);
    80002df2:	8526                	mv	a0,s1
    80002df4:	6b8000ef          	jal	800034ac <log_write>
    brelse(bp);
    80002df8:	8526                	mv	a0,s1
    80002dfa:	d7cff0ef          	jal	80002376 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002dfe:	013d09bb          	addw	s3,s10,s3
    80002e02:	012d093b          	addw	s2,s10,s2
    80002e06:	9a6e                	add	s4,s4,s11
    80002e08:	0369fc63          	bgeu	s3,s6,80002e40 <writei+0xb6>
    uint addr = bmap(ip, off/BSIZE);
    80002e0c:	00a9559b          	srliw	a1,s2,0xa
    80002e10:	8556                	mv	a0,s5
    80002e12:	fc2ff0ef          	jal	800025d4 <bmap>
    80002e16:	85aa                	mv	a1,a0
    if(addr == 0)
    80002e18:	c505                	beqz	a0,80002e40 <writei+0xb6>
    bp = bread(ip->dev, addr);
    80002e1a:	000aa503          	lw	a0,0(s5)
    80002e1e:	c50ff0ef          	jal	8000226e <bread>
    80002e22:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002e24:	3ff97793          	andi	a5,s2,1023
    80002e28:	40fc873b          	subw	a4,s9,a5
    80002e2c:	413b06bb          	subw	a3,s6,s3
    80002e30:	8d3a                	mv	s10,a4
    80002e32:	fae6f2e3          	bgeu	a3,a4,80002dd6 <writei+0x4c>
    80002e36:	8d36                	mv	s10,a3
    80002e38:	bf79                	j	80002dd6 <writei+0x4c>
      brelse(bp);
    80002e3a:	8526                	mv	a0,s1
    80002e3c:	d3aff0ef          	jal	80002376 <brelse>
  }

  if(off > ip->size)
    80002e40:	04caa783          	lw	a5,76(s5)
    80002e44:	0327f963          	bgeu	a5,s2,80002e76 <writei+0xec>
    ip->size = off;
    80002e48:	052aa623          	sw	s2,76(s5)
    80002e4c:	64e6                	ld	s1,88(sp)
    80002e4e:	7c02                	ld	s8,32(sp)
    80002e50:	6ce2                	ld	s9,24(sp)
    80002e52:	6d42                	ld	s10,16(sp)
    80002e54:	6da2                	ld	s11,8(sp)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    80002e56:	8556                	mv	a0,s5
    80002e58:	9fbff0ef          	jal	80002852 <iupdate>

  return tot;
    80002e5c:	854e                	mv	a0,s3
    80002e5e:	69a6                	ld	s3,72(sp)
}
    80002e60:	70a6                	ld	ra,104(sp)
    80002e62:	7406                	ld	s0,96(sp)
    80002e64:	6946                	ld	s2,80(sp)
    80002e66:	6a06                	ld	s4,64(sp)
    80002e68:	7ae2                	ld	s5,56(sp)
    80002e6a:	7b42                	ld	s6,48(sp)
    80002e6c:	7ba2                	ld	s7,40(sp)
    80002e6e:	6165                	addi	sp,sp,112
    80002e70:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002e72:	89da                	mv	s3,s6
    80002e74:	b7cd                	j	80002e56 <writei+0xcc>
    80002e76:	64e6                	ld	s1,88(sp)
    80002e78:	7c02                	ld	s8,32(sp)
    80002e7a:	6ce2                	ld	s9,24(sp)
    80002e7c:	6d42                	ld	s10,16(sp)
    80002e7e:	6da2                	ld	s11,8(sp)
    80002e80:	bfd9                	j	80002e56 <writei+0xcc>
    return -1;
    80002e82:	557d                	li	a0,-1
}
    80002e84:	8082                	ret
    return -1;
    80002e86:	557d                	li	a0,-1
    80002e88:	bfe1                	j	80002e60 <writei+0xd6>

0000000080002e8a <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    80002e8a:	1141                	addi	sp,sp,-16
    80002e8c:	e406                	sd	ra,8(sp)
    80002e8e:	e022                	sd	s0,0(sp)
    80002e90:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    80002e92:	4639                	li	a2,14
    80002e94:	ce4fd0ef          	jal	80000378 <strncmp>
}
    80002e98:	60a2                	ld	ra,8(sp)
    80002e9a:	6402                	ld	s0,0(sp)
    80002e9c:	0141                	addi	sp,sp,16
    80002e9e:	8082                	ret

0000000080002ea0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80002ea0:	711d                	addi	sp,sp,-96
    80002ea2:	ec86                	sd	ra,88(sp)
    80002ea4:	e8a2                	sd	s0,80(sp)
    80002ea6:	e4a6                	sd	s1,72(sp)
    80002ea8:	e0ca                	sd	s2,64(sp)
    80002eaa:	fc4e                	sd	s3,56(sp)
    80002eac:	f852                	sd	s4,48(sp)
    80002eae:	f456                	sd	s5,40(sp)
    80002eb0:	f05a                	sd	s6,32(sp)
    80002eb2:	ec5e                	sd	s7,24(sp)
    80002eb4:	1080                	addi	s0,sp,96
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80002eb6:	04451703          	lh	a4,68(a0)
    80002eba:	4785                	li	a5,1
    80002ebc:	00f71f63          	bne	a4,a5,80002eda <dirlookup+0x3a>
    80002ec0:	892a                	mv	s2,a0
    80002ec2:	8aae                	mv	s5,a1
    80002ec4:	8bb2                	mv	s7,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ec6:	457c                	lw	a5,76(a0)
    80002ec8:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002eca:	fa040a13          	addi	s4,s0,-96
    80002ece:	49c1                	li	s3,16
      panic("dirlookup read");
    if(de.inum == 0)
      continue;
    if(namecmp(name, de.name) == 0){
    80002ed0:	fa240b13          	addi	s6,s0,-94
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80002ed4:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ed6:	e39d                	bnez	a5,80002efc <dirlookup+0x5c>
    80002ed8:	a8b9                	j	80002f36 <dirlookup+0x96>
    panic("dirlookup not DIR");
    80002eda:	00004517          	auipc	a0,0x4
    80002ede:	5d650513          	addi	a0,a0,1494 # 800074b0 <etext+0x4b0>
    80002ee2:	287020ef          	jal	80005968 <panic>
      panic("dirlookup read");
    80002ee6:	00004517          	auipc	a0,0x4
    80002eea:	5e250513          	addi	a0,a0,1506 # 800074c8 <etext+0x4c8>
    80002eee:	27b020ef          	jal	80005968 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80002ef2:	24c1                	addiw	s1,s1,16
    80002ef4:	04c92783          	lw	a5,76(s2)
    80002ef8:	02f4fe63          	bgeu	s1,a5,80002f34 <dirlookup+0x94>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80002efc:	874e                	mv	a4,s3
    80002efe:	86a6                	mv	a3,s1
    80002f00:	8652                	mv	a2,s4
    80002f02:	4581                	li	a1,0
    80002f04:	854a                	mv	a0,s2
    80002f06:	d93ff0ef          	jal	80002c98 <readi>
    80002f0a:	fd351ee3          	bne	a0,s3,80002ee6 <dirlookup+0x46>
    if(de.inum == 0)
    80002f0e:	fa045783          	lhu	a5,-96(s0)
    80002f12:	d3e5                	beqz	a5,80002ef2 <dirlookup+0x52>
    if(namecmp(name, de.name) == 0){
    80002f14:	85da                	mv	a1,s6
    80002f16:	8556                	mv	a0,s5
    80002f18:	f73ff0ef          	jal	80002e8a <namecmp>
    80002f1c:	f979                	bnez	a0,80002ef2 <dirlookup+0x52>
      if(poff)
    80002f1e:	000b8463          	beqz	s7,80002f26 <dirlookup+0x86>
        *poff = off;
    80002f22:	009ba023          	sw	s1,0(s7)
      return iget(dp->dev, inum);
    80002f26:	fa045583          	lhu	a1,-96(s0)
    80002f2a:	00092503          	lw	a0,0(s2)
    80002f2e:	f66ff0ef          	jal	80002694 <iget>
    80002f32:	a011                	j	80002f36 <dirlookup+0x96>
  return 0;
    80002f34:	4501                	li	a0,0
}
    80002f36:	60e6                	ld	ra,88(sp)
    80002f38:	6446                	ld	s0,80(sp)
    80002f3a:	64a6                	ld	s1,72(sp)
    80002f3c:	6906                	ld	s2,64(sp)
    80002f3e:	79e2                	ld	s3,56(sp)
    80002f40:	7a42                	ld	s4,48(sp)
    80002f42:	7aa2                	ld	s5,40(sp)
    80002f44:	7b02                	ld	s6,32(sp)
    80002f46:	6be2                	ld	s7,24(sp)
    80002f48:	6125                	addi	sp,sp,96
    80002f4a:	8082                	ret

0000000080002f4c <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    80002f4c:	711d                	addi	sp,sp,-96
    80002f4e:	ec86                	sd	ra,88(sp)
    80002f50:	e8a2                	sd	s0,80(sp)
    80002f52:	e4a6                	sd	s1,72(sp)
    80002f54:	e0ca                	sd	s2,64(sp)
    80002f56:	fc4e                	sd	s3,56(sp)
    80002f58:	f852                	sd	s4,48(sp)
    80002f5a:	f456                	sd	s5,40(sp)
    80002f5c:	f05a                	sd	s6,32(sp)
    80002f5e:	ec5e                	sd	s7,24(sp)
    80002f60:	e862                	sd	s8,16(sp)
    80002f62:	e466                	sd	s9,8(sp)
    80002f64:	e06a                	sd	s10,0(sp)
    80002f66:	1080                	addi	s0,sp,96
    80002f68:	84aa                	mv	s1,a0
    80002f6a:	8b2e                	mv	s6,a1
    80002f6c:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    80002f6e:	00054703          	lbu	a4,0(a0)
    80002f72:	02f00793          	li	a5,47
    80002f76:	00f70f63          	beq	a4,a5,80002f94 <namex+0x48>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    80002f7a:	8b4fe0ef          	jal	8000102e <myproc>
    80002f7e:	15053503          	ld	a0,336(a0)
    80002f82:	94fff0ef          	jal	800028d0 <idup>
    80002f86:	8a2a                	mv	s4,a0
  while(*path == '/')
    80002f88:	02f00993          	li	s3,47
  if(len >= DIRSIZ)
    80002f8c:	4c35                	li	s8,13
    memmove(name, s, DIRSIZ);
    80002f8e:	4cb9                	li	s9,14

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    80002f90:	4b85                	li	s7,1
    80002f92:	a879                	j	80003030 <namex+0xe4>
    ip = iget(ROOTDEV, ROOTINO);
    80002f94:	4585                	li	a1,1
    80002f96:	852e                	mv	a0,a1
    80002f98:	efcff0ef          	jal	80002694 <iget>
    80002f9c:	8a2a                	mv	s4,a0
    80002f9e:	b7ed                	j	80002f88 <namex+0x3c>
      iunlockput(ip);
    80002fa0:	8552                	mv	a0,s4
    80002fa2:	b71ff0ef          	jal	80002b12 <iunlockput>
      return 0;
    80002fa6:	4a01                	li	s4,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    80002fa8:	8552                	mv	a0,s4
    80002faa:	60e6                	ld	ra,88(sp)
    80002fac:	6446                	ld	s0,80(sp)
    80002fae:	64a6                	ld	s1,72(sp)
    80002fb0:	6906                	ld	s2,64(sp)
    80002fb2:	79e2                	ld	s3,56(sp)
    80002fb4:	7a42                	ld	s4,48(sp)
    80002fb6:	7aa2                	ld	s5,40(sp)
    80002fb8:	7b02                	ld	s6,32(sp)
    80002fba:	6be2                	ld	s7,24(sp)
    80002fbc:	6c42                	ld	s8,16(sp)
    80002fbe:	6ca2                	ld	s9,8(sp)
    80002fc0:	6d02                	ld	s10,0(sp)
    80002fc2:	6125                	addi	sp,sp,96
    80002fc4:	8082                	ret
      iunlock(ip);
    80002fc6:	8552                	mv	a0,s4
    80002fc8:	9edff0ef          	jal	800029b4 <iunlock>
      return ip;
    80002fcc:	bff1                	j	80002fa8 <namex+0x5c>
      iunlockput(ip);
    80002fce:	8552                	mv	a0,s4
    80002fd0:	b43ff0ef          	jal	80002b12 <iunlockput>
      return 0;
    80002fd4:	8a4a                	mv	s4,s2
    80002fd6:	bfc9                	j	80002fa8 <namex+0x5c>
  len = path - s;
    80002fd8:	40990633          	sub	a2,s2,s1
    80002fdc:	00060d1b          	sext.w	s10,a2
  if(len >= DIRSIZ)
    80002fe0:	09ac5463          	bge	s8,s10,80003068 <namex+0x11c>
    memmove(name, s, DIRSIZ);
    80002fe4:	8666                	mv	a2,s9
    80002fe6:	85a6                	mv	a1,s1
    80002fe8:	8556                	mv	a0,s5
    80002fea:	b1afd0ef          	jal	80000304 <memmove>
    80002fee:	84ca                	mv	s1,s2
  while(*path == '/')
    80002ff0:	0004c783          	lbu	a5,0(s1)
    80002ff4:	01379763          	bne	a5,s3,80003002 <namex+0xb6>
    path++;
    80002ff8:	0485                	addi	s1,s1,1
  while(*path == '/')
    80002ffa:	0004c783          	lbu	a5,0(s1)
    80002ffe:	ff378de3          	beq	a5,s3,80002ff8 <namex+0xac>
    ilock(ip);
    80003002:	8552                	mv	a0,s4
    80003004:	903ff0ef          	jal	80002906 <ilock>
    if(ip->type != T_DIR){
    80003008:	044a1783          	lh	a5,68(s4)
    8000300c:	f9779ae3          	bne	a5,s7,80002fa0 <namex+0x54>
    if(nameiparent && *path == '\0'){
    80003010:	000b0563          	beqz	s6,8000301a <namex+0xce>
    80003014:	0004c783          	lbu	a5,0(s1)
    80003018:	d7dd                	beqz	a5,80002fc6 <namex+0x7a>
    if((next = dirlookup(ip, name, 0)) == 0){
    8000301a:	4601                	li	a2,0
    8000301c:	85d6                	mv	a1,s5
    8000301e:	8552                	mv	a0,s4
    80003020:	e81ff0ef          	jal	80002ea0 <dirlookup>
    80003024:	892a                	mv	s2,a0
    80003026:	d545                	beqz	a0,80002fce <namex+0x82>
    iunlockput(ip);
    80003028:	8552                	mv	a0,s4
    8000302a:	ae9ff0ef          	jal	80002b12 <iunlockput>
    ip = next;
    8000302e:	8a4a                	mv	s4,s2
  while(*path == '/')
    80003030:	0004c783          	lbu	a5,0(s1)
    80003034:	01379763          	bne	a5,s3,80003042 <namex+0xf6>
    path++;
    80003038:	0485                	addi	s1,s1,1
  while(*path == '/')
    8000303a:	0004c783          	lbu	a5,0(s1)
    8000303e:	ff378de3          	beq	a5,s3,80003038 <namex+0xec>
  if(*path == 0)
    80003042:	cf8d                	beqz	a5,8000307c <namex+0x130>
  while(*path != '/' && *path != 0)
    80003044:	0004c783          	lbu	a5,0(s1)
    80003048:	fd178713          	addi	a4,a5,-47
    8000304c:	cb19                	beqz	a4,80003062 <namex+0x116>
    8000304e:	cb91                	beqz	a5,80003062 <namex+0x116>
    80003050:	8926                	mv	s2,s1
    path++;
    80003052:	0905                	addi	s2,s2,1
  while(*path != '/' && *path != 0)
    80003054:	00094783          	lbu	a5,0(s2)
    80003058:	fd178713          	addi	a4,a5,-47
    8000305c:	df35                	beqz	a4,80002fd8 <namex+0x8c>
    8000305e:	fbf5                	bnez	a5,80003052 <namex+0x106>
    80003060:	bfa5                	j	80002fd8 <namex+0x8c>
    80003062:	8926                	mv	s2,s1
  len = path - s;
    80003064:	4d01                	li	s10,0
    80003066:	4601                	li	a2,0
    memmove(name, s, len);
    80003068:	2601                	sext.w	a2,a2
    8000306a:	85a6                	mv	a1,s1
    8000306c:	8556                	mv	a0,s5
    8000306e:	a96fd0ef          	jal	80000304 <memmove>
    name[len] = 0;
    80003072:	9d56                	add	s10,s10,s5
    80003074:	000d0023          	sb	zero,0(s10) # fffffffffffff000 <end+0xffffffff7fdbe408>
    80003078:	84ca                	mv	s1,s2
    8000307a:	bf9d                	j	80002ff0 <namex+0xa4>
  if(nameiparent){
    8000307c:	f20b06e3          	beqz	s6,80002fa8 <namex+0x5c>
    iput(ip);
    80003080:	8552                	mv	a0,s4
    80003082:	a07ff0ef          	jal	80002a88 <iput>
    return 0;
    80003086:	4a01                	li	s4,0
    80003088:	b705                	j	80002fa8 <namex+0x5c>

000000008000308a <dirlink>:
{
    8000308a:	715d                	addi	sp,sp,-80
    8000308c:	e486                	sd	ra,72(sp)
    8000308e:	e0a2                	sd	s0,64(sp)
    80003090:	f84a                	sd	s2,48(sp)
    80003092:	ec56                	sd	s5,24(sp)
    80003094:	e85a                	sd	s6,16(sp)
    80003096:	0880                	addi	s0,sp,80
    80003098:	892a                	mv	s2,a0
    8000309a:	8aae                	mv	s5,a1
    8000309c:	8b32                	mv	s6,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    8000309e:	4601                	li	a2,0
    800030a0:	e01ff0ef          	jal	80002ea0 <dirlookup>
    800030a4:	ed1d                	bnez	a0,800030e2 <dirlink+0x58>
    800030a6:	fc26                	sd	s1,56(sp)
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030a8:	04c92483          	lw	s1,76(s2)
    800030ac:	c4b9                	beqz	s1,800030fa <dirlink+0x70>
    800030ae:	f44e                	sd	s3,40(sp)
    800030b0:	f052                	sd	s4,32(sp)
    800030b2:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800030b4:	fb040a13          	addi	s4,s0,-80
    800030b8:	49c1                	li	s3,16
    800030ba:	874e                	mv	a4,s3
    800030bc:	86a6                	mv	a3,s1
    800030be:	8652                	mv	a2,s4
    800030c0:	4581                	li	a1,0
    800030c2:	854a                	mv	a0,s2
    800030c4:	bd5ff0ef          	jal	80002c98 <readi>
    800030c8:	03351163          	bne	a0,s3,800030ea <dirlink+0x60>
    if(de.inum == 0)
    800030cc:	fb045783          	lhu	a5,-80(s0)
    800030d0:	c39d                	beqz	a5,800030f6 <dirlink+0x6c>
  for(off = 0; off < dp->size; off += sizeof(de)){
    800030d2:	24c1                	addiw	s1,s1,16
    800030d4:	04c92783          	lw	a5,76(s2)
    800030d8:	fef4e1e3          	bltu	s1,a5,800030ba <dirlink+0x30>
    800030dc:	79a2                	ld	s3,40(sp)
    800030de:	7a02                	ld	s4,32(sp)
    800030e0:	a829                	j	800030fa <dirlink+0x70>
    iput(ip);
    800030e2:	9a7ff0ef          	jal	80002a88 <iput>
    return -1;
    800030e6:	557d                	li	a0,-1
    800030e8:	a83d                	j	80003126 <dirlink+0x9c>
      panic("dirlink read");
    800030ea:	00004517          	auipc	a0,0x4
    800030ee:	3ee50513          	addi	a0,a0,1006 # 800074d8 <etext+0x4d8>
    800030f2:	077020ef          	jal	80005968 <panic>
    800030f6:	79a2                	ld	s3,40(sp)
    800030f8:	7a02                	ld	s4,32(sp)
  strncpy(de.name, name, DIRSIZ);
    800030fa:	4639                	li	a2,14
    800030fc:	85d6                	mv	a1,s5
    800030fe:	fb240513          	addi	a0,s0,-78
    80003102:	ab0fd0ef          	jal	800003b2 <strncpy>
  de.inum = inum;
    80003106:	fb641823          	sh	s6,-80(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000310a:	4741                	li	a4,16
    8000310c:	86a6                	mv	a3,s1
    8000310e:	fb040613          	addi	a2,s0,-80
    80003112:	4581                	li	a1,0
    80003114:	854a                	mv	a0,s2
    80003116:	c75ff0ef          	jal	80002d8a <writei>
    8000311a:	1541                	addi	a0,a0,-16
    8000311c:	00a03533          	snez	a0,a0
    80003120:	40a0053b          	negw	a0,a0
    80003124:	74e2                	ld	s1,56(sp)
}
    80003126:	60a6                	ld	ra,72(sp)
    80003128:	6406                	ld	s0,64(sp)
    8000312a:	7942                	ld	s2,48(sp)
    8000312c:	6ae2                	ld	s5,24(sp)
    8000312e:	6b42                	ld	s6,16(sp)
    80003130:	6161                	addi	sp,sp,80
    80003132:	8082                	ret

0000000080003134 <namei>:

struct inode*
namei(char *path)
{
    80003134:	1101                	addi	sp,sp,-32
    80003136:	ec06                	sd	ra,24(sp)
    80003138:	e822                	sd	s0,16(sp)
    8000313a:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    8000313c:	fe040613          	addi	a2,s0,-32
    80003140:	4581                	li	a1,0
    80003142:	e0bff0ef          	jal	80002f4c <namex>
}
    80003146:	60e2                	ld	ra,24(sp)
    80003148:	6442                	ld	s0,16(sp)
    8000314a:	6105                	addi	sp,sp,32
    8000314c:	8082                	ret

000000008000314e <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    8000314e:	1141                	addi	sp,sp,-16
    80003150:	e406                	sd	ra,8(sp)
    80003152:	e022                	sd	s0,0(sp)
    80003154:	0800                	addi	s0,sp,16
    80003156:	862e                	mv	a2,a1
  return namex(path, 1, name);
    80003158:	4585                	li	a1,1
    8000315a:	df3ff0ef          	jal	80002f4c <namex>
}
    8000315e:	60a2                	ld	ra,8(sp)
    80003160:	6402                	ld	s0,0(sp)
    80003162:	0141                	addi	sp,sp,16
    80003164:	8082                	ret

0000000080003166 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003166:	1101                	addi	sp,sp,-32
    80003168:	ec06                	sd	ra,24(sp)
    8000316a:	e822                	sd	s0,16(sp)
    8000316c:	e426                	sd	s1,8(sp)
    8000316e:	e04a                	sd	s2,0(sp)
    80003170:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003172:	00234917          	auipc	s2,0x234
    80003176:	76e90913          	addi	s2,s2,1902 # 802378e0 <log>
    8000317a:	01892583          	lw	a1,24(s2)
    8000317e:	02492503          	lw	a0,36(s2)
    80003182:	8ecff0ef          	jal	8000226e <bread>
    80003186:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003188:	02892603          	lw	a2,40(s2)
    8000318c:	cd30                	sw	a2,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000318e:	00c05f63          	blez	a2,800031ac <write_head+0x46>
    80003192:	00234717          	auipc	a4,0x234
    80003196:	77a70713          	addi	a4,a4,1914 # 8023790c <log+0x2c>
    8000319a:	87aa                	mv	a5,a0
    8000319c:	060a                	slli	a2,a2,0x2
    8000319e:	962a                	add	a2,a2,a0
    hb->block[i] = log.lh.block[i];
    800031a0:	4314                	lw	a3,0(a4)
    800031a2:	cff4                	sw	a3,92(a5)
  for (i = 0; i < log.lh.n; i++) {
    800031a4:	0711                	addi	a4,a4,4
    800031a6:	0791                	addi	a5,a5,4
    800031a8:	fec79ce3          	bne	a5,a2,800031a0 <write_head+0x3a>
  }
  bwrite(buf);
    800031ac:	8526                	mv	a0,s1
    800031ae:	996ff0ef          	jal	80002344 <bwrite>
  brelse(buf);
    800031b2:	8526                	mv	a0,s1
    800031b4:	9c2ff0ef          	jal	80002376 <brelse>
}
    800031b8:	60e2                	ld	ra,24(sp)
    800031ba:	6442                	ld	s0,16(sp)
    800031bc:	64a2                	ld	s1,8(sp)
    800031be:	6902                	ld	s2,0(sp)
    800031c0:	6105                	addi	sp,sp,32
    800031c2:	8082                	ret

00000000800031c4 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800031c4:	00234797          	auipc	a5,0x234
    800031c8:	7447a783          	lw	a5,1860(a5) # 80237908 <log+0x28>
    800031cc:	0cf05163          	blez	a5,8000328e <install_trans+0xca>
{
    800031d0:	715d                	addi	sp,sp,-80
    800031d2:	e486                	sd	ra,72(sp)
    800031d4:	e0a2                	sd	s0,64(sp)
    800031d6:	fc26                	sd	s1,56(sp)
    800031d8:	f84a                	sd	s2,48(sp)
    800031da:	f44e                	sd	s3,40(sp)
    800031dc:	f052                	sd	s4,32(sp)
    800031de:	ec56                	sd	s5,24(sp)
    800031e0:	e85a                	sd	s6,16(sp)
    800031e2:	e45e                	sd	s7,8(sp)
    800031e4:	e062                	sd	s8,0(sp)
    800031e6:	0880                	addi	s0,sp,80
    800031e8:	8b2a                	mv	s6,a0
    800031ea:	00234a97          	auipc	s5,0x234
    800031ee:	722a8a93          	addi	s5,s5,1826 # 8023790c <log+0x2c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800031f2:	4981                	li	s3,0
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    800031f4:	00004c17          	auipc	s8,0x4
    800031f8:	2f4c0c13          	addi	s8,s8,756 # 800074e8 <etext+0x4e8>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800031fc:	00234a17          	auipc	s4,0x234
    80003200:	6e4a0a13          	addi	s4,s4,1764 # 802378e0 <log>
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003204:	40000b93          	li	s7,1024
    80003208:	a025                	j	80003230 <install_trans+0x6c>
      printf("recovering tail %d dst %d\n", tail, log.lh.block[tail]);
    8000320a:	000aa603          	lw	a2,0(s5)
    8000320e:	85ce                	mv	a1,s3
    80003210:	8562                	mv	a0,s8
    80003212:	3aa020ef          	jal	800055bc <printf>
    80003216:	a839                	j	80003234 <install_trans+0x70>
    brelse(lbuf);
    80003218:	854a                	mv	a0,s2
    8000321a:	95cff0ef          	jal	80002376 <brelse>
    brelse(dbuf);
    8000321e:	8526                	mv	a0,s1
    80003220:	956ff0ef          	jal	80002376 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003224:	2985                	addiw	s3,s3,1
    80003226:	0a91                	addi	s5,s5,4
    80003228:	028a2783          	lw	a5,40(s4)
    8000322c:	04f9d563          	bge	s3,a5,80003276 <install_trans+0xb2>
    if(recovering) {
    80003230:	fc0b1de3          	bnez	s6,8000320a <install_trans+0x46>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003234:	018a2583          	lw	a1,24(s4)
    80003238:	013585bb          	addw	a1,a1,s3
    8000323c:	2585                	addiw	a1,a1,1
    8000323e:	024a2503          	lw	a0,36(s4)
    80003242:	82cff0ef          	jal	8000226e <bread>
    80003246:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003248:	000aa583          	lw	a1,0(s5)
    8000324c:	024a2503          	lw	a0,36(s4)
    80003250:	81eff0ef          	jal	8000226e <bread>
    80003254:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003256:	865e                	mv	a2,s7
    80003258:	05890593          	addi	a1,s2,88
    8000325c:	05850513          	addi	a0,a0,88
    80003260:	8a4fd0ef          	jal	80000304 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003264:	8526                	mv	a0,s1
    80003266:	8deff0ef          	jal	80002344 <bwrite>
    if(recovering == 0)
    8000326a:	fa0b17e3          	bnez	s6,80003218 <install_trans+0x54>
      bunpin(dbuf);
    8000326e:	8526                	mv	a0,s1
    80003270:	9beff0ef          	jal	8000242e <bunpin>
    80003274:	b755                	j	80003218 <install_trans+0x54>
}
    80003276:	60a6                	ld	ra,72(sp)
    80003278:	6406                	ld	s0,64(sp)
    8000327a:	74e2                	ld	s1,56(sp)
    8000327c:	7942                	ld	s2,48(sp)
    8000327e:	79a2                	ld	s3,40(sp)
    80003280:	7a02                	ld	s4,32(sp)
    80003282:	6ae2                	ld	s5,24(sp)
    80003284:	6b42                	ld	s6,16(sp)
    80003286:	6ba2                	ld	s7,8(sp)
    80003288:	6c02                	ld	s8,0(sp)
    8000328a:	6161                	addi	sp,sp,80
    8000328c:	8082                	ret
    8000328e:	8082                	ret

0000000080003290 <initlog>:
{
    80003290:	7179                	addi	sp,sp,-48
    80003292:	f406                	sd	ra,40(sp)
    80003294:	f022                	sd	s0,32(sp)
    80003296:	ec26                	sd	s1,24(sp)
    80003298:	e84a                	sd	s2,16(sp)
    8000329a:	e44e                	sd	s3,8(sp)
    8000329c:	1800                	addi	s0,sp,48
    8000329e:	84aa                	mv	s1,a0
    800032a0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800032a2:	00234917          	auipc	s2,0x234
    800032a6:	63e90913          	addi	s2,s2,1598 # 802378e0 <log>
    800032aa:	00004597          	auipc	a1,0x4
    800032ae:	25e58593          	addi	a1,a1,606 # 80007508 <etext+0x508>
    800032b2:	854a                	mv	a0,s2
    800032b4:	0cd020ef          	jal	80005b80 <initlock>
  log.start = sb->logstart;
    800032b8:	0149a583          	lw	a1,20(s3)
    800032bc:	00b92c23          	sw	a1,24(s2)
  log.dev = dev;
    800032c0:	02992223          	sw	s1,36(s2)
  struct buf *buf = bread(log.dev, log.start);
    800032c4:	8526                	mv	a0,s1
    800032c6:	fa9fe0ef          	jal	8000226e <bread>
  log.lh.n = lh->n;
    800032ca:	4d30                	lw	a2,88(a0)
    800032cc:	02c92423          	sw	a2,40(s2)
  for (i = 0; i < log.lh.n; i++) {
    800032d0:	00c05f63          	blez	a2,800032ee <initlog+0x5e>
    800032d4:	87aa                	mv	a5,a0
    800032d6:	00234717          	auipc	a4,0x234
    800032da:	63670713          	addi	a4,a4,1590 # 8023790c <log+0x2c>
    800032de:	060a                	slli	a2,a2,0x2
    800032e0:	962a                	add	a2,a2,a0
    log.lh.block[i] = lh->block[i];
    800032e2:	4ff4                	lw	a3,92(a5)
    800032e4:	c314                	sw	a3,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800032e6:	0791                	addi	a5,a5,4
    800032e8:	0711                	addi	a4,a4,4
    800032ea:	fec79ce3          	bne	a5,a2,800032e2 <initlog+0x52>
  brelse(buf);
    800032ee:	888ff0ef          	jal	80002376 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800032f2:	4505                	li	a0,1
    800032f4:	ed1ff0ef          	jal	800031c4 <install_trans>
  log.lh.n = 0;
    800032f8:	00234797          	auipc	a5,0x234
    800032fc:	6007a823          	sw	zero,1552(a5) # 80237908 <log+0x28>
  write_head(); // clear the log
    80003300:	e67ff0ef          	jal	80003166 <write_head>
}
    80003304:	70a2                	ld	ra,40(sp)
    80003306:	7402                	ld	s0,32(sp)
    80003308:	64e2                	ld	s1,24(sp)
    8000330a:	6942                	ld	s2,16(sp)
    8000330c:	69a2                	ld	s3,8(sp)
    8000330e:	6145                	addi	sp,sp,48
    80003310:	8082                	ret

0000000080003312 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003312:	1101                	addi	sp,sp,-32
    80003314:	ec06                	sd	ra,24(sp)
    80003316:	e822                	sd	s0,16(sp)
    80003318:	e426                	sd	s1,8(sp)
    8000331a:	e04a                	sd	s2,0(sp)
    8000331c:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    8000331e:	00234517          	auipc	a0,0x234
    80003322:	5c250513          	addi	a0,a0,1474 # 802378e0 <log>
    80003326:	0e5020ef          	jal	80005c0a <acquire>
  while(1){
    if(log.committing){
    8000332a:	00234497          	auipc	s1,0x234
    8000332e:	5b648493          	addi	s1,s1,1462 # 802378e0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003332:	4979                	li	s2,30
    80003334:	a029                	j	8000333e <begin_op+0x2c>
      sleep(&log, &log.lock);
    80003336:	85a6                	mv	a1,s1
    80003338:	8526                	mv	a0,s1
    8000333a:	af2fe0ef          	jal	8000162c <sleep>
    if(log.committing){
    8000333e:	509c                	lw	a5,32(s1)
    80003340:	fbfd                	bnez	a5,80003336 <begin_op+0x24>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGBLOCKS){
    80003342:	4cd8                	lw	a4,28(s1)
    80003344:	2705                	addiw	a4,a4,1
    80003346:	0027179b          	slliw	a5,a4,0x2
    8000334a:	9fb9                	addw	a5,a5,a4
    8000334c:	0017979b          	slliw	a5,a5,0x1
    80003350:	5494                	lw	a3,40(s1)
    80003352:	9fb5                	addw	a5,a5,a3
    80003354:	00f95763          	bge	s2,a5,80003362 <begin_op+0x50>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003358:	85a6                	mv	a1,s1
    8000335a:	8526                	mv	a0,s1
    8000335c:	ad0fe0ef          	jal	8000162c <sleep>
    80003360:	bff9                	j	8000333e <begin_op+0x2c>
    } else {
      log.outstanding += 1;
    80003362:	00234797          	auipc	a5,0x234
    80003366:	58e7ad23          	sw	a4,1434(a5) # 802378fc <log+0x1c>
      release(&log.lock);
    8000336a:	00234517          	auipc	a0,0x234
    8000336e:	57650513          	addi	a0,a0,1398 # 802378e0 <log>
    80003372:	12d020ef          	jal	80005c9e <release>
      break;
    }
  }
}
    80003376:	60e2                	ld	ra,24(sp)
    80003378:	6442                	ld	s0,16(sp)
    8000337a:	64a2                	ld	s1,8(sp)
    8000337c:	6902                	ld	s2,0(sp)
    8000337e:	6105                	addi	sp,sp,32
    80003380:	8082                	ret

0000000080003382 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003382:	7139                	addi	sp,sp,-64
    80003384:	fc06                	sd	ra,56(sp)
    80003386:	f822                	sd	s0,48(sp)
    80003388:	f426                	sd	s1,40(sp)
    8000338a:	f04a                	sd	s2,32(sp)
    8000338c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000338e:	00234497          	auipc	s1,0x234
    80003392:	55248493          	addi	s1,s1,1362 # 802378e0 <log>
    80003396:	8526                	mv	a0,s1
    80003398:	073020ef          	jal	80005c0a <acquire>
  log.outstanding -= 1;
    8000339c:	4cdc                	lw	a5,28(s1)
    8000339e:	37fd                	addiw	a5,a5,-1
    800033a0:	893e                	mv	s2,a5
    800033a2:	ccdc                	sw	a5,28(s1)
  if(log.committing)
    800033a4:	509c                	lw	a5,32(s1)
    800033a6:	e7b1                	bnez	a5,800033f2 <end_op+0x70>
    panic("log.committing");
  if(log.outstanding == 0){
    800033a8:	04091e63          	bnez	s2,80003404 <end_op+0x82>
    do_commit = 1;
    log.committing = 1;
    800033ac:	00234497          	auipc	s1,0x234
    800033b0:	53448493          	addi	s1,s1,1332 # 802378e0 <log>
    800033b4:	4785                	li	a5,1
    800033b6:	d09c                	sw	a5,32(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800033b8:	8526                	mv	a0,s1
    800033ba:	0e5020ef          	jal	80005c9e <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800033be:	549c                	lw	a5,40(s1)
    800033c0:	06f04463          	bgtz	a5,80003428 <end_op+0xa6>
    acquire(&log.lock);
    800033c4:	00234517          	auipc	a0,0x234
    800033c8:	51c50513          	addi	a0,a0,1308 # 802378e0 <log>
    800033cc:	03f020ef          	jal	80005c0a <acquire>
    log.committing = 0;
    800033d0:	00234797          	auipc	a5,0x234
    800033d4:	5207a823          	sw	zero,1328(a5) # 80237900 <log+0x20>
    wakeup(&log);
    800033d8:	00234517          	auipc	a0,0x234
    800033dc:	50850513          	addi	a0,a0,1288 # 802378e0 <log>
    800033e0:	a98fe0ef          	jal	80001678 <wakeup>
    release(&log.lock);
    800033e4:	00234517          	auipc	a0,0x234
    800033e8:	4fc50513          	addi	a0,a0,1276 # 802378e0 <log>
    800033ec:	0b3020ef          	jal	80005c9e <release>
}
    800033f0:	a035                	j	8000341c <end_op+0x9a>
    800033f2:	ec4e                	sd	s3,24(sp)
    800033f4:	e852                	sd	s4,16(sp)
    800033f6:	e456                	sd	s5,8(sp)
    panic("log.committing");
    800033f8:	00004517          	auipc	a0,0x4
    800033fc:	11850513          	addi	a0,a0,280 # 80007510 <etext+0x510>
    80003400:	568020ef          	jal	80005968 <panic>
    wakeup(&log);
    80003404:	00234517          	auipc	a0,0x234
    80003408:	4dc50513          	addi	a0,a0,1244 # 802378e0 <log>
    8000340c:	a6cfe0ef          	jal	80001678 <wakeup>
  release(&log.lock);
    80003410:	00234517          	auipc	a0,0x234
    80003414:	4d050513          	addi	a0,a0,1232 # 802378e0 <log>
    80003418:	087020ef          	jal	80005c9e <release>
}
    8000341c:	70e2                	ld	ra,56(sp)
    8000341e:	7442                	ld	s0,48(sp)
    80003420:	74a2                	ld	s1,40(sp)
    80003422:	7902                	ld	s2,32(sp)
    80003424:	6121                	addi	sp,sp,64
    80003426:	8082                	ret
    80003428:	ec4e                	sd	s3,24(sp)
    8000342a:	e852                	sd	s4,16(sp)
    8000342c:	e456                	sd	s5,8(sp)
  for (tail = 0; tail < log.lh.n; tail++) {
    8000342e:	00234a97          	auipc	s5,0x234
    80003432:	4dea8a93          	addi	s5,s5,1246 # 8023790c <log+0x2c>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003436:	00234a17          	auipc	s4,0x234
    8000343a:	4aaa0a13          	addi	s4,s4,1194 # 802378e0 <log>
    8000343e:	018a2583          	lw	a1,24(s4)
    80003442:	012585bb          	addw	a1,a1,s2
    80003446:	2585                	addiw	a1,a1,1
    80003448:	024a2503          	lw	a0,36(s4)
    8000344c:	e23fe0ef          	jal	8000226e <bread>
    80003450:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003452:	000aa583          	lw	a1,0(s5)
    80003456:	024a2503          	lw	a0,36(s4)
    8000345a:	e15fe0ef          	jal	8000226e <bread>
    8000345e:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003460:	40000613          	li	a2,1024
    80003464:	05850593          	addi	a1,a0,88
    80003468:	05848513          	addi	a0,s1,88
    8000346c:	e99fc0ef          	jal	80000304 <memmove>
    bwrite(to);  // write the log
    80003470:	8526                	mv	a0,s1
    80003472:	ed3fe0ef          	jal	80002344 <bwrite>
    brelse(from);
    80003476:	854e                	mv	a0,s3
    80003478:	efffe0ef          	jal	80002376 <brelse>
    brelse(to);
    8000347c:	8526                	mv	a0,s1
    8000347e:	ef9fe0ef          	jal	80002376 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003482:	2905                	addiw	s2,s2,1
    80003484:	0a91                	addi	s5,s5,4
    80003486:	028a2783          	lw	a5,40(s4)
    8000348a:	faf94ae3          	blt	s2,a5,8000343e <end_op+0xbc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000348e:	cd9ff0ef          	jal	80003166 <write_head>
    install_trans(0); // Now install writes to home locations
    80003492:	4501                	li	a0,0
    80003494:	d31ff0ef          	jal	800031c4 <install_trans>
    log.lh.n = 0;
    80003498:	00234797          	auipc	a5,0x234
    8000349c:	4607a823          	sw	zero,1136(a5) # 80237908 <log+0x28>
    write_head();    // Erase the transaction from the log
    800034a0:	cc7ff0ef          	jal	80003166 <write_head>
    800034a4:	69e2                	ld	s3,24(sp)
    800034a6:	6a42                	ld	s4,16(sp)
    800034a8:	6aa2                	ld	s5,8(sp)
    800034aa:	bf29                	j	800033c4 <end_op+0x42>

00000000800034ac <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800034ac:	1101                	addi	sp,sp,-32
    800034ae:	ec06                	sd	ra,24(sp)
    800034b0:	e822                	sd	s0,16(sp)
    800034b2:	e426                	sd	s1,8(sp)
    800034b4:	1000                	addi	s0,sp,32
    800034b6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800034b8:	00234517          	auipc	a0,0x234
    800034bc:	42850513          	addi	a0,a0,1064 # 802378e0 <log>
    800034c0:	74a020ef          	jal	80005c0a <acquire>
  if (log.lh.n >= LOGBLOCKS)
    800034c4:	00234617          	auipc	a2,0x234
    800034c8:	44462603          	lw	a2,1092(a2) # 80237908 <log+0x28>
    800034cc:	47f5                	li	a5,29
    800034ce:	04c7cd63          	blt	a5,a2,80003528 <log_write+0x7c>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800034d2:	00234797          	auipc	a5,0x234
    800034d6:	42a7a783          	lw	a5,1066(a5) # 802378fc <log+0x1c>
    800034da:	04f05d63          	blez	a5,80003534 <log_write+0x88>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800034de:	4781                	li	a5,0
    800034e0:	06c05063          	blez	a2,80003540 <log_write+0x94>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800034e4:	44cc                	lw	a1,12(s1)
    800034e6:	00234717          	auipc	a4,0x234
    800034ea:	42670713          	addi	a4,a4,1062 # 8023790c <log+0x2c>
  for (i = 0; i < log.lh.n; i++) {
    800034ee:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800034f0:	4314                	lw	a3,0(a4)
    800034f2:	04b68763          	beq	a3,a1,80003540 <log_write+0x94>
  for (i = 0; i < log.lh.n; i++) {
    800034f6:	2785                	addiw	a5,a5,1
    800034f8:	0711                	addi	a4,a4,4
    800034fa:	fef61be3          	bne	a2,a5,800034f0 <log_write+0x44>
      break;
  }
  log.lh.block[i] = b->blockno;
    800034fe:	060a                	slli	a2,a2,0x2
    80003500:	02060613          	addi	a2,a2,32
    80003504:	00234797          	auipc	a5,0x234
    80003508:	3dc78793          	addi	a5,a5,988 # 802378e0 <log>
    8000350c:	97b2                	add	a5,a5,a2
    8000350e:	44d8                	lw	a4,12(s1)
    80003510:	c7d8                	sw	a4,12(a5)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003512:	8526                	mv	a0,s1
    80003514:	ee7fe0ef          	jal	800023fa <bpin>
    log.lh.n++;
    80003518:	00234717          	auipc	a4,0x234
    8000351c:	3c870713          	addi	a4,a4,968 # 802378e0 <log>
    80003520:	571c                	lw	a5,40(a4)
    80003522:	2785                	addiw	a5,a5,1
    80003524:	d71c                	sw	a5,40(a4)
    80003526:	a815                	j	8000355a <log_write+0xae>
    panic("too big a transaction");
    80003528:	00004517          	auipc	a0,0x4
    8000352c:	ff850513          	addi	a0,a0,-8 # 80007520 <etext+0x520>
    80003530:	438020ef          	jal	80005968 <panic>
    panic("log_write outside of trans");
    80003534:	00004517          	auipc	a0,0x4
    80003538:	00450513          	addi	a0,a0,4 # 80007538 <etext+0x538>
    8000353c:	42c020ef          	jal	80005968 <panic>
  log.lh.block[i] = b->blockno;
    80003540:	00279693          	slli	a3,a5,0x2
    80003544:	02068693          	addi	a3,a3,32
    80003548:	00234717          	auipc	a4,0x234
    8000354c:	39870713          	addi	a4,a4,920 # 802378e0 <log>
    80003550:	9736                	add	a4,a4,a3
    80003552:	44d4                	lw	a3,12(s1)
    80003554:	c754                	sw	a3,12(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003556:	faf60ee3          	beq	a2,a5,80003512 <log_write+0x66>
  }
  release(&log.lock);
    8000355a:	00234517          	auipc	a0,0x234
    8000355e:	38650513          	addi	a0,a0,902 # 802378e0 <log>
    80003562:	73c020ef          	jal	80005c9e <release>
}
    80003566:	60e2                	ld	ra,24(sp)
    80003568:	6442                	ld	s0,16(sp)
    8000356a:	64a2                	ld	s1,8(sp)
    8000356c:	6105                	addi	sp,sp,32
    8000356e:	8082                	ret

0000000080003570 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003570:	1101                	addi	sp,sp,-32
    80003572:	ec06                	sd	ra,24(sp)
    80003574:	e822                	sd	s0,16(sp)
    80003576:	e426                	sd	s1,8(sp)
    80003578:	e04a                	sd	s2,0(sp)
    8000357a:	1000                	addi	s0,sp,32
    8000357c:	84aa                	mv	s1,a0
    8000357e:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003580:	00004597          	auipc	a1,0x4
    80003584:	fd858593          	addi	a1,a1,-40 # 80007558 <etext+0x558>
    80003588:	0521                	addi	a0,a0,8
    8000358a:	5f6020ef          	jal	80005b80 <initlock>
  lk->name = name;
    8000358e:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003592:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003596:	0204a423          	sw	zero,40(s1)
}
    8000359a:	60e2                	ld	ra,24(sp)
    8000359c:	6442                	ld	s0,16(sp)
    8000359e:	64a2                	ld	s1,8(sp)
    800035a0:	6902                	ld	s2,0(sp)
    800035a2:	6105                	addi	sp,sp,32
    800035a4:	8082                	ret

00000000800035a6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800035a6:	1101                	addi	sp,sp,-32
    800035a8:	ec06                	sd	ra,24(sp)
    800035aa:	e822                	sd	s0,16(sp)
    800035ac:	e426                	sd	s1,8(sp)
    800035ae:	e04a                	sd	s2,0(sp)
    800035b0:	1000                	addi	s0,sp,32
    800035b2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800035b4:	00850913          	addi	s2,a0,8
    800035b8:	854a                	mv	a0,s2
    800035ba:	650020ef          	jal	80005c0a <acquire>
  while (lk->locked) {
    800035be:	409c                	lw	a5,0(s1)
    800035c0:	c799                	beqz	a5,800035ce <acquiresleep+0x28>
    sleep(lk, &lk->lk);
    800035c2:	85ca                	mv	a1,s2
    800035c4:	8526                	mv	a0,s1
    800035c6:	866fe0ef          	jal	8000162c <sleep>
  while (lk->locked) {
    800035ca:	409c                	lw	a5,0(s1)
    800035cc:	fbfd                	bnez	a5,800035c2 <acquiresleep+0x1c>
  }
  lk->locked = 1;
    800035ce:	4785                	li	a5,1
    800035d0:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800035d2:	a5dfd0ef          	jal	8000102e <myproc>
    800035d6:	591c                	lw	a5,48(a0)
    800035d8:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800035da:	854a                	mv	a0,s2
    800035dc:	6c2020ef          	jal	80005c9e <release>
}
    800035e0:	60e2                	ld	ra,24(sp)
    800035e2:	6442                	ld	s0,16(sp)
    800035e4:	64a2                	ld	s1,8(sp)
    800035e6:	6902                	ld	s2,0(sp)
    800035e8:	6105                	addi	sp,sp,32
    800035ea:	8082                	ret

00000000800035ec <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800035ec:	1101                	addi	sp,sp,-32
    800035ee:	ec06                	sd	ra,24(sp)
    800035f0:	e822                	sd	s0,16(sp)
    800035f2:	e426                	sd	s1,8(sp)
    800035f4:	e04a                	sd	s2,0(sp)
    800035f6:	1000                	addi	s0,sp,32
    800035f8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800035fa:	00850913          	addi	s2,a0,8
    800035fe:	854a                	mv	a0,s2
    80003600:	60a020ef          	jal	80005c0a <acquire>
  lk->locked = 0;
    80003604:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003608:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000360c:	8526                	mv	a0,s1
    8000360e:	86afe0ef          	jal	80001678 <wakeup>
  release(&lk->lk);
    80003612:	854a                	mv	a0,s2
    80003614:	68a020ef          	jal	80005c9e <release>
}
    80003618:	60e2                	ld	ra,24(sp)
    8000361a:	6442                	ld	s0,16(sp)
    8000361c:	64a2                	ld	s1,8(sp)
    8000361e:	6902                	ld	s2,0(sp)
    80003620:	6105                	addi	sp,sp,32
    80003622:	8082                	ret

0000000080003624 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003624:	7179                	addi	sp,sp,-48
    80003626:	f406                	sd	ra,40(sp)
    80003628:	f022                	sd	s0,32(sp)
    8000362a:	ec26                	sd	s1,24(sp)
    8000362c:	e84a                	sd	s2,16(sp)
    8000362e:	1800                	addi	s0,sp,48
    80003630:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003632:	00850913          	addi	s2,a0,8
    80003636:	854a                	mv	a0,s2
    80003638:	5d2020ef          	jal	80005c0a <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000363c:	409c                	lw	a5,0(s1)
    8000363e:	ef81                	bnez	a5,80003656 <holdingsleep+0x32>
    80003640:	4481                	li	s1,0
  release(&lk->lk);
    80003642:	854a                	mv	a0,s2
    80003644:	65a020ef          	jal	80005c9e <release>
  return r;
}
    80003648:	8526                	mv	a0,s1
    8000364a:	70a2                	ld	ra,40(sp)
    8000364c:	7402                	ld	s0,32(sp)
    8000364e:	64e2                	ld	s1,24(sp)
    80003650:	6942                	ld	s2,16(sp)
    80003652:	6145                	addi	sp,sp,48
    80003654:	8082                	ret
    80003656:	e44e                	sd	s3,8(sp)
  r = lk->locked && (lk->pid == myproc()->pid);
    80003658:	0284a983          	lw	s3,40(s1)
    8000365c:	9d3fd0ef          	jal	8000102e <myproc>
    80003660:	5904                	lw	s1,48(a0)
    80003662:	413484b3          	sub	s1,s1,s3
    80003666:	0014b493          	seqz	s1,s1
    8000366a:	69a2                	ld	s3,8(sp)
    8000366c:	bfd9                	j	80003642 <holdingsleep+0x1e>

000000008000366e <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    8000366e:	1141                	addi	sp,sp,-16
    80003670:	e406                	sd	ra,8(sp)
    80003672:	e022                	sd	s0,0(sp)
    80003674:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    80003676:	00004597          	auipc	a1,0x4
    8000367a:	ef258593          	addi	a1,a1,-270 # 80007568 <etext+0x568>
    8000367e:	00234517          	auipc	a0,0x234
    80003682:	3aa50513          	addi	a0,a0,938 # 80237a28 <ftable>
    80003686:	4fa020ef          	jal	80005b80 <initlock>
}
    8000368a:	60a2                	ld	ra,8(sp)
    8000368c:	6402                	ld	s0,0(sp)
    8000368e:	0141                	addi	sp,sp,16
    80003690:	8082                	ret

0000000080003692 <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    80003692:	1101                	addi	sp,sp,-32
    80003694:	ec06                	sd	ra,24(sp)
    80003696:	e822                	sd	s0,16(sp)
    80003698:	e426                	sd	s1,8(sp)
    8000369a:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    8000369c:	00234517          	auipc	a0,0x234
    800036a0:	38c50513          	addi	a0,a0,908 # 80237a28 <ftable>
    800036a4:	566020ef          	jal	80005c0a <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800036a8:	00234497          	auipc	s1,0x234
    800036ac:	39848493          	addi	s1,s1,920 # 80237a40 <ftable+0x18>
    800036b0:	00235717          	auipc	a4,0x235
    800036b4:	33070713          	addi	a4,a4,816 # 802389e0 <disk>
    if(f->ref == 0){
    800036b8:	40dc                	lw	a5,4(s1)
    800036ba:	cf89                	beqz	a5,800036d4 <filealloc+0x42>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800036bc:	02848493          	addi	s1,s1,40
    800036c0:	fee49ce3          	bne	s1,a4,800036b8 <filealloc+0x26>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    800036c4:	00234517          	auipc	a0,0x234
    800036c8:	36450513          	addi	a0,a0,868 # 80237a28 <ftable>
    800036cc:	5d2020ef          	jal	80005c9e <release>
  return 0;
    800036d0:	4481                	li	s1,0
    800036d2:	a809                	j	800036e4 <filealloc+0x52>
      f->ref = 1;
    800036d4:	4785                	li	a5,1
    800036d6:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    800036d8:	00234517          	auipc	a0,0x234
    800036dc:	35050513          	addi	a0,a0,848 # 80237a28 <ftable>
    800036e0:	5be020ef          	jal	80005c9e <release>
}
    800036e4:	8526                	mv	a0,s1
    800036e6:	60e2                	ld	ra,24(sp)
    800036e8:	6442                	ld	s0,16(sp)
    800036ea:	64a2                	ld	s1,8(sp)
    800036ec:	6105                	addi	sp,sp,32
    800036ee:	8082                	ret

00000000800036f0 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    800036f0:	1101                	addi	sp,sp,-32
    800036f2:	ec06                	sd	ra,24(sp)
    800036f4:	e822                	sd	s0,16(sp)
    800036f6:	e426                	sd	s1,8(sp)
    800036f8:	1000                	addi	s0,sp,32
    800036fa:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    800036fc:	00234517          	auipc	a0,0x234
    80003700:	32c50513          	addi	a0,a0,812 # 80237a28 <ftable>
    80003704:	506020ef          	jal	80005c0a <acquire>
  if(f->ref < 1)
    80003708:	40dc                	lw	a5,4(s1)
    8000370a:	02f05063          	blez	a5,8000372a <filedup+0x3a>
    panic("filedup");
  f->ref++;
    8000370e:	2785                	addiw	a5,a5,1
    80003710:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003712:	00234517          	auipc	a0,0x234
    80003716:	31650513          	addi	a0,a0,790 # 80237a28 <ftable>
    8000371a:	584020ef          	jal	80005c9e <release>
  return f;
}
    8000371e:	8526                	mv	a0,s1
    80003720:	60e2                	ld	ra,24(sp)
    80003722:	6442                	ld	s0,16(sp)
    80003724:	64a2                	ld	s1,8(sp)
    80003726:	6105                	addi	sp,sp,32
    80003728:	8082                	ret
    panic("filedup");
    8000372a:	00004517          	auipc	a0,0x4
    8000372e:	e4650513          	addi	a0,a0,-442 # 80007570 <etext+0x570>
    80003732:	236020ef          	jal	80005968 <panic>

0000000080003736 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003736:	7139                	addi	sp,sp,-64
    80003738:	fc06                	sd	ra,56(sp)
    8000373a:	f822                	sd	s0,48(sp)
    8000373c:	f426                	sd	s1,40(sp)
    8000373e:	0080                	addi	s0,sp,64
    80003740:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003742:	00234517          	auipc	a0,0x234
    80003746:	2e650513          	addi	a0,a0,742 # 80237a28 <ftable>
    8000374a:	4c0020ef          	jal	80005c0a <acquire>
  if(f->ref < 1)
    8000374e:	40dc                	lw	a5,4(s1)
    80003750:	04f05a63          	blez	a5,800037a4 <fileclose+0x6e>
    panic("fileclose");
  if(--f->ref > 0){
    80003754:	37fd                	addiw	a5,a5,-1
    80003756:	c0dc                	sw	a5,4(s1)
    80003758:	06f04063          	bgtz	a5,800037b8 <fileclose+0x82>
    8000375c:	f04a                	sd	s2,32(sp)
    8000375e:	ec4e                	sd	s3,24(sp)
    80003760:	e852                	sd	s4,16(sp)
    80003762:	e456                	sd	s5,8(sp)
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003764:	0004a903          	lw	s2,0(s1)
    80003768:	0094c783          	lbu	a5,9(s1)
    8000376c:	89be                	mv	s3,a5
    8000376e:	689c                	ld	a5,16(s1)
    80003770:	8a3e                	mv	s4,a5
    80003772:	6c9c                	ld	a5,24(s1)
    80003774:	8abe                	mv	s5,a5
  f->ref = 0;
    80003776:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    8000377a:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    8000377e:	00234517          	auipc	a0,0x234
    80003782:	2aa50513          	addi	a0,a0,682 # 80237a28 <ftable>
    80003786:	518020ef          	jal	80005c9e <release>

  if(ff.type == FD_PIPE){
    8000378a:	4785                	li	a5,1
    8000378c:	04f90163          	beq	s2,a5,800037ce <fileclose+0x98>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003790:	ffe9079b          	addiw	a5,s2,-2
    80003794:	4705                	li	a4,1
    80003796:	04f77563          	bgeu	a4,a5,800037e0 <fileclose+0xaa>
    8000379a:	7902                	ld	s2,32(sp)
    8000379c:	69e2                	ld	s3,24(sp)
    8000379e:	6a42                	ld	s4,16(sp)
    800037a0:	6aa2                	ld	s5,8(sp)
    800037a2:	a00d                	j	800037c4 <fileclose+0x8e>
    800037a4:	f04a                	sd	s2,32(sp)
    800037a6:	ec4e                	sd	s3,24(sp)
    800037a8:	e852                	sd	s4,16(sp)
    800037aa:	e456                	sd	s5,8(sp)
    panic("fileclose");
    800037ac:	00004517          	auipc	a0,0x4
    800037b0:	dcc50513          	addi	a0,a0,-564 # 80007578 <etext+0x578>
    800037b4:	1b4020ef          	jal	80005968 <panic>
    release(&ftable.lock);
    800037b8:	00234517          	auipc	a0,0x234
    800037bc:	27050513          	addi	a0,a0,624 # 80237a28 <ftable>
    800037c0:	4de020ef          	jal	80005c9e <release>
    begin_op();
    iput(ff.ip);
    end_op();
  }
}
    800037c4:	70e2                	ld	ra,56(sp)
    800037c6:	7442                	ld	s0,48(sp)
    800037c8:	74a2                	ld	s1,40(sp)
    800037ca:	6121                	addi	sp,sp,64
    800037cc:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    800037ce:	85ce                	mv	a1,s3
    800037d0:	8552                	mv	a0,s4
    800037d2:	348000ef          	jal	80003b1a <pipeclose>
    800037d6:	7902                	ld	s2,32(sp)
    800037d8:	69e2                	ld	s3,24(sp)
    800037da:	6a42                	ld	s4,16(sp)
    800037dc:	6aa2                	ld	s5,8(sp)
    800037de:	b7dd                	j	800037c4 <fileclose+0x8e>
    begin_op();
    800037e0:	b33ff0ef          	jal	80003312 <begin_op>
    iput(ff.ip);
    800037e4:	8556                	mv	a0,s5
    800037e6:	aa2ff0ef          	jal	80002a88 <iput>
    end_op();
    800037ea:	b99ff0ef          	jal	80003382 <end_op>
    800037ee:	7902                	ld	s2,32(sp)
    800037f0:	69e2                	ld	s3,24(sp)
    800037f2:	6a42                	ld	s4,16(sp)
    800037f4:	6aa2                	ld	s5,8(sp)
    800037f6:	b7f9                	j	800037c4 <fileclose+0x8e>

00000000800037f8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    800037f8:	715d                	addi	sp,sp,-80
    800037fa:	e486                	sd	ra,72(sp)
    800037fc:	e0a2                	sd	s0,64(sp)
    800037fe:	fc26                	sd	s1,56(sp)
    80003800:	f052                	sd	s4,32(sp)
    80003802:	0880                	addi	s0,sp,80
    80003804:	84aa                	mv	s1,a0
    80003806:	8a2e                	mv	s4,a1
  struct proc *p = myproc();
    80003808:	827fd0ef          	jal	8000102e <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    8000380c:	409c                	lw	a5,0(s1)
    8000380e:	37f9                	addiw	a5,a5,-2
    80003810:	4705                	li	a4,1
    80003812:	04f76263          	bltu	a4,a5,80003856 <filestat+0x5e>
    80003816:	f84a                	sd	s2,48(sp)
    80003818:	f44e                	sd	s3,40(sp)
    8000381a:	89aa                	mv	s3,a0
    ilock(f->ip);
    8000381c:	6c88                	ld	a0,24(s1)
    8000381e:	8e8ff0ef          	jal	80002906 <ilock>
    stati(f->ip, &st);
    80003822:	fb840913          	addi	s2,s0,-72
    80003826:	85ca                	mv	a1,s2
    80003828:	6c88                	ld	a0,24(s1)
    8000382a:	c40ff0ef          	jal	80002c6a <stati>
    iunlock(f->ip);
    8000382e:	6c88                	ld	a0,24(s1)
    80003830:	984ff0ef          	jal	800029b4 <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003834:	46e1                	li	a3,24
    80003836:	864a                	mv	a2,s2
    80003838:	85d2                	mv	a1,s4
    8000383a:	0509b503          	ld	a0,80(s3)
    8000383e:	cf8fd0ef          	jal	80000d36 <copyout>
    80003842:	41f5551b          	sraiw	a0,a0,0x1f
    80003846:	7942                	ld	s2,48(sp)
    80003848:	79a2                	ld	s3,40(sp)
      return -1;
    return 0;
  }
  return -1;
}
    8000384a:	60a6                	ld	ra,72(sp)
    8000384c:	6406                	ld	s0,64(sp)
    8000384e:	74e2                	ld	s1,56(sp)
    80003850:	7a02                	ld	s4,32(sp)
    80003852:	6161                	addi	sp,sp,80
    80003854:	8082                	ret
  return -1;
    80003856:	557d                	li	a0,-1
    80003858:	bfcd                	j	8000384a <filestat+0x52>

000000008000385a <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    8000385a:	7179                	addi	sp,sp,-48
    8000385c:	f406                	sd	ra,40(sp)
    8000385e:	f022                	sd	s0,32(sp)
    80003860:	e84a                	sd	s2,16(sp)
    80003862:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003864:	00854783          	lbu	a5,8(a0)
    80003868:	cfd1                	beqz	a5,80003904 <fileread+0xaa>
    8000386a:	ec26                	sd	s1,24(sp)
    8000386c:	e44e                	sd	s3,8(sp)
    8000386e:	84aa                	mv	s1,a0
    80003870:	892e                	mv	s2,a1
    80003872:	89b2                	mv	s3,a2
    return -1;

  if(f->type == FD_PIPE){
    80003874:	411c                	lw	a5,0(a0)
    80003876:	4705                	li	a4,1
    80003878:	04e78363          	beq	a5,a4,800038be <fileread+0x64>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    8000387c:	470d                	li	a4,3
    8000387e:	04e78763          	beq	a5,a4,800038cc <fileread+0x72>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003882:	4709                	li	a4,2
    80003884:	06e79a63          	bne	a5,a4,800038f8 <fileread+0x9e>
    ilock(f->ip);
    80003888:	6d08                	ld	a0,24(a0)
    8000388a:	87cff0ef          	jal	80002906 <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    8000388e:	874e                	mv	a4,s3
    80003890:	5094                	lw	a3,32(s1)
    80003892:	864a                	mv	a2,s2
    80003894:	4585                	li	a1,1
    80003896:	6c88                	ld	a0,24(s1)
    80003898:	c00ff0ef          	jal	80002c98 <readi>
    8000389c:	892a                	mv	s2,a0
    8000389e:	00a05563          	blez	a0,800038a8 <fileread+0x4e>
      f->off += r;
    800038a2:	509c                	lw	a5,32(s1)
    800038a4:	9fa9                	addw	a5,a5,a0
    800038a6:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    800038a8:	6c88                	ld	a0,24(s1)
    800038aa:	90aff0ef          	jal	800029b4 <iunlock>
    800038ae:	64e2                	ld	s1,24(sp)
    800038b0:	69a2                	ld	s3,8(sp)
  } else {
    panic("fileread");
  }

  return r;
}
    800038b2:	854a                	mv	a0,s2
    800038b4:	70a2                	ld	ra,40(sp)
    800038b6:	7402                	ld	s0,32(sp)
    800038b8:	6942                	ld	s2,16(sp)
    800038ba:	6145                	addi	sp,sp,48
    800038bc:	8082                	ret
    r = piperead(f->pipe, addr, n);
    800038be:	6908                	ld	a0,16(a0)
    800038c0:	3b0000ef          	jal	80003c70 <piperead>
    800038c4:	892a                	mv	s2,a0
    800038c6:	64e2                	ld	s1,24(sp)
    800038c8:	69a2                	ld	s3,8(sp)
    800038ca:	b7e5                	j	800038b2 <fileread+0x58>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    800038cc:	02451783          	lh	a5,36(a0)
    800038d0:	03079693          	slli	a3,a5,0x30
    800038d4:	92c1                	srli	a3,a3,0x30
    800038d6:	4725                	li	a4,9
    800038d8:	02d76963          	bltu	a4,a3,8000390a <fileread+0xb0>
    800038dc:	0792                	slli	a5,a5,0x4
    800038de:	00234717          	auipc	a4,0x234
    800038e2:	0aa70713          	addi	a4,a4,170 # 80237988 <devsw>
    800038e6:	97ba                	add	a5,a5,a4
    800038e8:	639c                	ld	a5,0(a5)
    800038ea:	c78d                	beqz	a5,80003914 <fileread+0xba>
    r = devsw[f->major].read(1, addr, n);
    800038ec:	4505                	li	a0,1
    800038ee:	9782                	jalr	a5
    800038f0:	892a                	mv	s2,a0
    800038f2:	64e2                	ld	s1,24(sp)
    800038f4:	69a2                	ld	s3,8(sp)
    800038f6:	bf75                	j	800038b2 <fileread+0x58>
    panic("fileread");
    800038f8:	00004517          	auipc	a0,0x4
    800038fc:	c9050513          	addi	a0,a0,-880 # 80007588 <etext+0x588>
    80003900:	068020ef          	jal	80005968 <panic>
    return -1;
    80003904:	57fd                	li	a5,-1
    80003906:	893e                	mv	s2,a5
    80003908:	b76d                	j	800038b2 <fileread+0x58>
      return -1;
    8000390a:	57fd                	li	a5,-1
    8000390c:	893e                	mv	s2,a5
    8000390e:	64e2                	ld	s1,24(sp)
    80003910:	69a2                	ld	s3,8(sp)
    80003912:	b745                	j	800038b2 <fileread+0x58>
    80003914:	57fd                	li	a5,-1
    80003916:	893e                	mv	s2,a5
    80003918:	64e2                	ld	s1,24(sp)
    8000391a:	69a2                	ld	s3,8(sp)
    8000391c:	bf59                	j	800038b2 <fileread+0x58>

000000008000391e <filewrite>:
int
filewrite(struct file *f, uint64 addr, int n)
{
  int r, ret = 0;

  if(f->writable == 0)
    8000391e:	00954783          	lbu	a5,9(a0)
    80003922:	10078f63          	beqz	a5,80003a40 <filewrite+0x122>
{
    80003926:	711d                	addi	sp,sp,-96
    80003928:	ec86                	sd	ra,88(sp)
    8000392a:	e8a2                	sd	s0,80(sp)
    8000392c:	e0ca                	sd	s2,64(sp)
    8000392e:	f456                	sd	s5,40(sp)
    80003930:	f05a                	sd	s6,32(sp)
    80003932:	1080                	addi	s0,sp,96
    80003934:	892a                	mv	s2,a0
    80003936:	8b2e                	mv	s6,a1
    80003938:	8ab2                	mv	s5,a2
    return -1;

  if(f->type == FD_PIPE){
    8000393a:	411c                	lw	a5,0(a0)
    8000393c:	4705                	li	a4,1
    8000393e:	02e78a63          	beq	a5,a4,80003972 <filewrite+0x54>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003942:	470d                	li	a4,3
    80003944:	02e78b63          	beq	a5,a4,8000397a <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003948:	4709                	li	a4,2
    8000394a:	0ce79f63          	bne	a5,a4,80003a28 <filewrite+0x10a>
    8000394e:	f852                	sd	s4,48(sp)
    // the maximum log transaction size, including
    // i-node, indirect block, allocation blocks,
    // and 2 blocks of slop for non-aligned writes.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003950:	0ac05a63          	blez	a2,80003a04 <filewrite+0xe6>
    80003954:	e4a6                	sd	s1,72(sp)
    80003956:	fc4e                	sd	s3,56(sp)
    80003958:	ec5e                	sd	s7,24(sp)
    8000395a:	e862                	sd	s8,16(sp)
    8000395c:	e466                	sd	s9,8(sp)
    int i = 0;
    8000395e:	4a01                	li	s4,0
      int n1 = n - i;
      if(n1 > max)
    80003960:	6b85                	lui	s7,0x1
    80003962:	c00b8b93          	addi	s7,s7,-1024 # c00 <_entry-0x7ffff400>
    80003966:	6785                	lui	a5,0x1
    80003968:	c007879b          	addiw	a5,a5,-1024 # c00 <_entry-0x7ffff400>
    8000396c:	8cbe                	mv	s9,a5
        n1 = max;

      begin_op();
      ilock(f->ip);
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    8000396e:	4c05                	li	s8,1
    80003970:	a8ad                	j	800039ea <filewrite+0xcc>
    ret = pipewrite(f->pipe, addr, n);
    80003972:	6908                	ld	a0,16(a0)
    80003974:	204000ef          	jal	80003b78 <pipewrite>
    80003978:	a04d                	j	80003a1a <filewrite+0xfc>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    8000397a:	02451783          	lh	a5,36(a0)
    8000397e:	03079693          	slli	a3,a5,0x30
    80003982:	92c1                	srli	a3,a3,0x30
    80003984:	4725                	li	a4,9
    80003986:	0ad76f63          	bltu	a4,a3,80003a44 <filewrite+0x126>
    8000398a:	0792                	slli	a5,a5,0x4
    8000398c:	00234717          	auipc	a4,0x234
    80003990:	ffc70713          	addi	a4,a4,-4 # 80237988 <devsw>
    80003994:	97ba                	add	a5,a5,a4
    80003996:	679c                	ld	a5,8(a5)
    80003998:	cbc5                	beqz	a5,80003a48 <filewrite+0x12a>
    ret = devsw[f->major].write(1, addr, n);
    8000399a:	4505                	li	a0,1
    8000399c:	9782                	jalr	a5
    8000399e:	a8b5                	j	80003a1a <filewrite+0xfc>
      if(n1 > max)
    800039a0:	2981                	sext.w	s3,s3
      begin_op();
    800039a2:	971ff0ef          	jal	80003312 <begin_op>
      ilock(f->ip);
    800039a6:	01893503          	ld	a0,24(s2)
    800039aa:	f5dfe0ef          	jal	80002906 <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    800039ae:	874e                	mv	a4,s3
    800039b0:	02092683          	lw	a3,32(s2)
    800039b4:	016a0633          	add	a2,s4,s6
    800039b8:	85e2                	mv	a1,s8
    800039ba:	01893503          	ld	a0,24(s2)
    800039be:	bccff0ef          	jal	80002d8a <writei>
    800039c2:	84aa                	mv	s1,a0
    800039c4:	00a05763          	blez	a0,800039d2 <filewrite+0xb4>
        f->off += r;
    800039c8:	02092783          	lw	a5,32(s2)
    800039cc:	9fa9                	addw	a5,a5,a0
    800039ce:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    800039d2:	01893503          	ld	a0,24(s2)
    800039d6:	fdffe0ef          	jal	800029b4 <iunlock>
      end_op();
    800039da:	9a9ff0ef          	jal	80003382 <end_op>

      if(r != n1){
    800039de:	02999563          	bne	s3,s1,80003a08 <filewrite+0xea>
        // error from writei
        break;
      }
      i += r;
    800039e2:	01448a3b          	addw	s4,s1,s4
    while(i < n){
    800039e6:	015a5963          	bge	s4,s5,800039f8 <filewrite+0xda>
      int n1 = n - i;
    800039ea:	414a87bb          	subw	a5,s5,s4
    800039ee:	89be                	mv	s3,a5
      if(n1 > max)
    800039f0:	fafbd8e3          	bge	s7,a5,800039a0 <filewrite+0x82>
    800039f4:	89e6                	mv	s3,s9
    800039f6:	b76d                	j	800039a0 <filewrite+0x82>
    800039f8:	64a6                	ld	s1,72(sp)
    800039fa:	79e2                	ld	s3,56(sp)
    800039fc:	6be2                	ld	s7,24(sp)
    800039fe:	6c42                	ld	s8,16(sp)
    80003a00:	6ca2                	ld	s9,8(sp)
    80003a02:	a801                	j	80003a12 <filewrite+0xf4>
    int i = 0;
    80003a04:	4a01                	li	s4,0
    80003a06:	a031                	j	80003a12 <filewrite+0xf4>
    80003a08:	64a6                	ld	s1,72(sp)
    80003a0a:	79e2                	ld	s3,56(sp)
    80003a0c:	6be2                	ld	s7,24(sp)
    80003a0e:	6c42                	ld	s8,16(sp)
    80003a10:	6ca2                	ld	s9,8(sp)
    }
    ret = (i == n ? n : -1);
    80003a12:	034a9d63          	bne	s5,s4,80003a4c <filewrite+0x12e>
    80003a16:	8556                	mv	a0,s5
    80003a18:	7a42                	ld	s4,48(sp)
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003a1a:	60e6                	ld	ra,88(sp)
    80003a1c:	6446                	ld	s0,80(sp)
    80003a1e:	6906                	ld	s2,64(sp)
    80003a20:	7aa2                	ld	s5,40(sp)
    80003a22:	7b02                	ld	s6,32(sp)
    80003a24:	6125                	addi	sp,sp,96
    80003a26:	8082                	ret
    80003a28:	e4a6                	sd	s1,72(sp)
    80003a2a:	fc4e                	sd	s3,56(sp)
    80003a2c:	f852                	sd	s4,48(sp)
    80003a2e:	ec5e                	sd	s7,24(sp)
    80003a30:	e862                	sd	s8,16(sp)
    80003a32:	e466                	sd	s9,8(sp)
    panic("filewrite");
    80003a34:	00004517          	auipc	a0,0x4
    80003a38:	b6450513          	addi	a0,a0,-1180 # 80007598 <etext+0x598>
    80003a3c:	72d010ef          	jal	80005968 <panic>
    return -1;
    80003a40:	557d                	li	a0,-1
}
    80003a42:	8082                	ret
      return -1;
    80003a44:	557d                	li	a0,-1
    80003a46:	bfd1                	j	80003a1a <filewrite+0xfc>
    80003a48:	557d                	li	a0,-1
    80003a4a:	bfc1                	j	80003a1a <filewrite+0xfc>
    ret = (i == n ? n : -1);
    80003a4c:	557d                	li	a0,-1
    80003a4e:	7a42                	ld	s4,48(sp)
    80003a50:	b7e9                	j	80003a1a <filewrite+0xfc>

0000000080003a52 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003a52:	7179                	addi	sp,sp,-48
    80003a54:	f406                	sd	ra,40(sp)
    80003a56:	f022                	sd	s0,32(sp)
    80003a58:	ec26                	sd	s1,24(sp)
    80003a5a:	e052                	sd	s4,0(sp)
    80003a5c:	1800                	addi	s0,sp,48
    80003a5e:	84aa                	mv	s1,a0
    80003a60:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003a62:	0005b023          	sd	zero,0(a1)
    80003a66:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003a6a:	c29ff0ef          	jal	80003692 <filealloc>
    80003a6e:	e088                	sd	a0,0(s1)
    80003a70:	c549                	beqz	a0,80003afa <pipealloc+0xa8>
    80003a72:	c21ff0ef          	jal	80003692 <filealloc>
    80003a76:	00aa3023          	sd	a0,0(s4)
    80003a7a:	cd25                	beqz	a0,80003af2 <pipealloc+0xa0>
    80003a7c:	e84a                	sd	s2,16(sp)
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003a7e:	f18fc0ef          	jal	80000196 <kalloc>
    80003a82:	892a                	mv	s2,a0
    80003a84:	c12d                	beqz	a0,80003ae6 <pipealloc+0x94>
    80003a86:	e44e                	sd	s3,8(sp)
    goto bad;
  pi->readopen = 1;
    80003a88:	4985                	li	s3,1
    80003a8a:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003a8e:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003a92:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003a96:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003a9a:	00004597          	auipc	a1,0x4
    80003a9e:	b0e58593          	addi	a1,a1,-1266 # 800075a8 <etext+0x5a8>
    80003aa2:	0de020ef          	jal	80005b80 <initlock>
  (*f0)->type = FD_PIPE;
    80003aa6:	609c                	ld	a5,0(s1)
    80003aa8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003aac:	609c                	ld	a5,0(s1)
    80003aae:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ab2:	609c                	ld	a5,0(s1)
    80003ab4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ab8:	609c                	ld	a5,0(s1)
    80003aba:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003abe:	000a3783          	ld	a5,0(s4)
    80003ac2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ac6:	000a3783          	ld	a5,0(s4)
    80003aca:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ace:	000a3783          	ld	a5,0(s4)
    80003ad2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ad6:	000a3783          	ld	a5,0(s4)
    80003ada:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ade:	4501                	li	a0,0
    80003ae0:	6942                	ld	s2,16(sp)
    80003ae2:	69a2                	ld	s3,8(sp)
    80003ae4:	a01d                	j	80003b0a <pipealloc+0xb8>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ae6:	6088                	ld	a0,0(s1)
    80003ae8:	c119                	beqz	a0,80003aee <pipealloc+0x9c>
    80003aea:	6942                	ld	s2,16(sp)
    80003aec:	a029                	j	80003af6 <pipealloc+0xa4>
    80003aee:	6942                	ld	s2,16(sp)
    80003af0:	a029                	j	80003afa <pipealloc+0xa8>
    80003af2:	6088                	ld	a0,0(s1)
    80003af4:	c10d                	beqz	a0,80003b16 <pipealloc+0xc4>
    fileclose(*f0);
    80003af6:	c41ff0ef          	jal	80003736 <fileclose>
  if(*f1)
    80003afa:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003afe:	557d                	li	a0,-1
  if(*f1)
    80003b00:	c789                	beqz	a5,80003b0a <pipealloc+0xb8>
    fileclose(*f1);
    80003b02:	853e                	mv	a0,a5
    80003b04:	c33ff0ef          	jal	80003736 <fileclose>
  return -1;
    80003b08:	557d                	li	a0,-1
}
    80003b0a:	70a2                	ld	ra,40(sp)
    80003b0c:	7402                	ld	s0,32(sp)
    80003b0e:	64e2                	ld	s1,24(sp)
    80003b10:	6a02                	ld	s4,0(sp)
    80003b12:	6145                	addi	sp,sp,48
    80003b14:	8082                	ret
  return -1;
    80003b16:	557d                	li	a0,-1
    80003b18:	bfcd                	j	80003b0a <pipealloc+0xb8>

0000000080003b1a <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003b1a:	1101                	addi	sp,sp,-32
    80003b1c:	ec06                	sd	ra,24(sp)
    80003b1e:	e822                	sd	s0,16(sp)
    80003b20:	e426                	sd	s1,8(sp)
    80003b22:	e04a                	sd	s2,0(sp)
    80003b24:	1000                	addi	s0,sp,32
    80003b26:	84aa                	mv	s1,a0
    80003b28:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003b2a:	0e0020ef          	jal	80005c0a <acquire>
  if(writable){
    80003b2e:	02090763          	beqz	s2,80003b5c <pipeclose+0x42>
    pi->writeopen = 0;
    80003b32:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003b36:	21848513          	addi	a0,s1,536
    80003b3a:	b3ffd0ef          	jal	80001678 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003b3e:	2204a783          	lw	a5,544(s1)
    80003b42:	e781                	bnez	a5,80003b4a <pipeclose+0x30>
    80003b44:	2244a783          	lw	a5,548(s1)
    80003b48:	c38d                	beqz	a5,80003b6a <pipeclose+0x50>
    release(&pi->lock);
    kfree((char*)pi);
  } else
    release(&pi->lock);
    80003b4a:	8526                	mv	a0,s1
    80003b4c:	152020ef          	jal	80005c9e <release>
}
    80003b50:	60e2                	ld	ra,24(sp)
    80003b52:	6442                	ld	s0,16(sp)
    80003b54:	64a2                	ld	s1,8(sp)
    80003b56:	6902                	ld	s2,0(sp)
    80003b58:	6105                	addi	sp,sp,32
    80003b5a:	8082                	ret
    pi->readopen = 0;
    80003b5c:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003b60:	21c48513          	addi	a0,s1,540
    80003b64:	b15fd0ef          	jal	80001678 <wakeup>
    80003b68:	bfd9                	j	80003b3e <pipeclose+0x24>
    release(&pi->lock);
    80003b6a:	8526                	mv	a0,s1
    80003b6c:	132020ef          	jal	80005c9e <release>
    kfree((char*)pi);
    80003b70:	8526                	mv	a0,s1
    80003b72:	caafc0ef          	jal	8000001c <kfree>
    80003b76:	bfe9                	j	80003b50 <pipeclose+0x36>

0000000080003b78 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003b78:	7159                	addi	sp,sp,-112
    80003b7a:	f486                	sd	ra,104(sp)
    80003b7c:	f0a2                	sd	s0,96(sp)
    80003b7e:	eca6                	sd	s1,88(sp)
    80003b80:	e8ca                	sd	s2,80(sp)
    80003b82:	e4ce                	sd	s3,72(sp)
    80003b84:	e0d2                	sd	s4,64(sp)
    80003b86:	fc56                	sd	s5,56(sp)
    80003b88:	1880                	addi	s0,sp,112
    80003b8a:	84aa                	mv	s1,a0
    80003b8c:	8aae                	mv	s5,a1
    80003b8e:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003b90:	c9efd0ef          	jal	8000102e <myproc>
    80003b94:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003b96:	8526                	mv	a0,s1
    80003b98:	072020ef          	jal	80005c0a <acquire>
  while(i < n){
    80003b9c:	0d405263          	blez	s4,80003c60 <pipewrite+0xe8>
    80003ba0:	f85a                	sd	s6,48(sp)
    80003ba2:	f45e                	sd	s7,40(sp)
    80003ba4:	f062                	sd	s8,32(sp)
    80003ba6:	ec66                	sd	s9,24(sp)
    80003ba8:	e86a                	sd	s10,16(sp)
  int i = 0;
    80003baa:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003bac:	f9f40c13          	addi	s8,s0,-97
    80003bb0:	4b85                	li	s7,1
    80003bb2:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003bb4:	21848d13          	addi	s10,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003bb8:	21c48c93          	addi	s9,s1,540
    80003bbc:	a82d                	j	80003bf6 <pipewrite+0x7e>
      release(&pi->lock);
    80003bbe:	8526                	mv	a0,s1
    80003bc0:	0de020ef          	jal	80005c9e <release>
      return -1;
    80003bc4:	597d                	li	s2,-1
    80003bc6:	7b42                	ld	s6,48(sp)
    80003bc8:	7ba2                	ld	s7,40(sp)
    80003bca:	7c02                	ld	s8,32(sp)
    80003bcc:	6ce2                	ld	s9,24(sp)
    80003bce:	6d42                	ld	s10,16(sp)
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003bd0:	854a                	mv	a0,s2
    80003bd2:	70a6                	ld	ra,104(sp)
    80003bd4:	7406                	ld	s0,96(sp)
    80003bd6:	64e6                	ld	s1,88(sp)
    80003bd8:	6946                	ld	s2,80(sp)
    80003bda:	69a6                	ld	s3,72(sp)
    80003bdc:	6a06                	ld	s4,64(sp)
    80003bde:	7ae2                	ld	s5,56(sp)
    80003be0:	6165                	addi	sp,sp,112
    80003be2:	8082                	ret
      wakeup(&pi->nread);
    80003be4:	856a                	mv	a0,s10
    80003be6:	a93fd0ef          	jal	80001678 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003bea:	85a6                	mv	a1,s1
    80003bec:	8566                	mv	a0,s9
    80003bee:	a3ffd0ef          	jal	8000162c <sleep>
  while(i < n){
    80003bf2:	05495a63          	bge	s2,s4,80003c46 <pipewrite+0xce>
    if(pi->readopen == 0 || killed(pr)){
    80003bf6:	2204a783          	lw	a5,544(s1)
    80003bfa:	d3f1                	beqz	a5,80003bbe <pipewrite+0x46>
    80003bfc:	854e                	mv	a0,s3
    80003bfe:	c6bfd0ef          	jal	80001868 <killed>
    80003c02:	fd55                	bnez	a0,80003bbe <pipewrite+0x46>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003c04:	2184a783          	lw	a5,536(s1)
    80003c08:	21c4a703          	lw	a4,540(s1)
    80003c0c:	2007879b          	addiw	a5,a5,512
    80003c10:	fcf70ae3          	beq	a4,a5,80003be4 <pipewrite+0x6c>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003c14:	86de                	mv	a3,s7
    80003c16:	01590633          	add	a2,s2,s5
    80003c1a:	85e2                	mv	a1,s8
    80003c1c:	0509b503          	ld	a0,80(s3)
    80003c20:	9f2fd0ef          	jal	80000e12 <copyin>
    80003c24:	05650063          	beq	a0,s6,80003c64 <pipewrite+0xec>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003c28:	21c4a783          	lw	a5,540(s1)
    80003c2c:	0017871b          	addiw	a4,a5,1
    80003c30:	20e4ae23          	sw	a4,540(s1)
    80003c34:	1ff7f793          	andi	a5,a5,511
    80003c38:	97a6                	add	a5,a5,s1
    80003c3a:	f9f44703          	lbu	a4,-97(s0)
    80003c3e:	00e78c23          	sb	a4,24(a5)
      i++;
    80003c42:	2905                	addiw	s2,s2,1
    80003c44:	b77d                	j	80003bf2 <pipewrite+0x7a>
    80003c46:	7b42                	ld	s6,48(sp)
    80003c48:	7ba2                	ld	s7,40(sp)
    80003c4a:	7c02                	ld	s8,32(sp)
    80003c4c:	6ce2                	ld	s9,24(sp)
    80003c4e:	6d42                	ld	s10,16(sp)
  wakeup(&pi->nread);
    80003c50:	21848513          	addi	a0,s1,536
    80003c54:	a25fd0ef          	jal	80001678 <wakeup>
  release(&pi->lock);
    80003c58:	8526                	mv	a0,s1
    80003c5a:	044020ef          	jal	80005c9e <release>
  return i;
    80003c5e:	bf8d                	j	80003bd0 <pipewrite+0x58>
  int i = 0;
    80003c60:	4901                	li	s2,0
    80003c62:	b7fd                	j	80003c50 <pipewrite+0xd8>
    80003c64:	7b42                	ld	s6,48(sp)
    80003c66:	7ba2                	ld	s7,40(sp)
    80003c68:	7c02                	ld	s8,32(sp)
    80003c6a:	6ce2                	ld	s9,24(sp)
    80003c6c:	6d42                	ld	s10,16(sp)
    80003c6e:	b7cd                	j	80003c50 <pipewrite+0xd8>

0000000080003c70 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80003c70:	711d                	addi	sp,sp,-96
    80003c72:	ec86                	sd	ra,88(sp)
    80003c74:	e8a2                	sd	s0,80(sp)
    80003c76:	e4a6                	sd	s1,72(sp)
    80003c78:	e0ca                	sd	s2,64(sp)
    80003c7a:	fc4e                	sd	s3,56(sp)
    80003c7c:	f852                	sd	s4,48(sp)
    80003c7e:	f456                	sd	s5,40(sp)
    80003c80:	1080                	addi	s0,sp,96
    80003c82:	84aa                	mv	s1,a0
    80003c84:	892e                	mv	s2,a1
    80003c86:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80003c88:	ba6fd0ef          	jal	8000102e <myproc>
    80003c8c:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80003c8e:	8526                	mv	a0,s1
    80003c90:	77b010ef          	jal	80005c0a <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003c94:	2184a703          	lw	a4,536(s1)
    80003c98:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003c9c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003ca0:	02f71763          	bne	a4,a5,80003cce <piperead+0x5e>
    80003ca4:	2244a783          	lw	a5,548(s1)
    80003ca8:	cf85                	beqz	a5,80003ce0 <piperead+0x70>
    if(killed(pr)){
    80003caa:	8552                	mv	a0,s4
    80003cac:	bbdfd0ef          	jal	80001868 <killed>
    80003cb0:	e11d                	bnez	a0,80003cd6 <piperead+0x66>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80003cb2:	85a6                	mv	a1,s1
    80003cb4:	854e                	mv	a0,s3
    80003cb6:	977fd0ef          	jal	8000162c <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80003cba:	2184a703          	lw	a4,536(s1)
    80003cbe:	21c4a783          	lw	a5,540(s1)
    80003cc2:	fef701e3          	beq	a4,a5,80003ca4 <piperead+0x34>
    80003cc6:	f05a                	sd	s6,32(sp)
    80003cc8:	ec5e                	sd	s7,24(sp)
    80003cca:	e862                	sd	s8,16(sp)
    80003ccc:	a829                	j	80003ce6 <piperead+0x76>
    80003cce:	f05a                	sd	s6,32(sp)
    80003cd0:	ec5e                	sd	s7,24(sp)
    80003cd2:	e862                	sd	s8,16(sp)
    80003cd4:	a809                	j	80003ce6 <piperead+0x76>
      release(&pi->lock);
    80003cd6:	8526                	mv	a0,s1
    80003cd8:	7c7010ef          	jal	80005c9e <release>
      return -1;
    80003cdc:	59fd                	li	s3,-1
    80003cde:	a09d                	j	80003d44 <piperead+0xd4>
    80003ce0:	f05a                	sd	s6,32(sp)
    80003ce2:	ec5e                	sd	s7,24(sp)
    80003ce4:	e862                	sd	s8,16(sp)
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003ce6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003ce8:	faf40c13          	addi	s8,s0,-81
    80003cec:	4b85                	li	s7,1
    80003cee:	5b7d                	li	s6,-1
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003cf0:	05505063          	blez	s5,80003d30 <piperead+0xc0>
    if(pi->nread == pi->nwrite)
    80003cf4:	2184a783          	lw	a5,536(s1)
    80003cf8:	21c4a703          	lw	a4,540(s1)
    80003cfc:	02f70a63          	beq	a4,a5,80003d30 <piperead+0xc0>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80003d00:	0017871b          	addiw	a4,a5,1
    80003d04:	20e4ac23          	sw	a4,536(s1)
    80003d08:	1ff7f793          	andi	a5,a5,511
    80003d0c:	97a6                	add	a5,a5,s1
    80003d0e:	0187c783          	lbu	a5,24(a5)
    80003d12:	faf407a3          	sb	a5,-81(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80003d16:	86de                	mv	a3,s7
    80003d18:	8662                	mv	a2,s8
    80003d1a:	85ca                	mv	a1,s2
    80003d1c:	050a3503          	ld	a0,80(s4)
    80003d20:	816fd0ef          	jal	80000d36 <copyout>
    80003d24:	01650663          	beq	a0,s6,80003d30 <piperead+0xc0>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80003d28:	2985                	addiw	s3,s3,1
    80003d2a:	0905                	addi	s2,s2,1
    80003d2c:	fd3a94e3          	bne	s5,s3,80003cf4 <piperead+0x84>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80003d30:	21c48513          	addi	a0,s1,540
    80003d34:	945fd0ef          	jal	80001678 <wakeup>
  release(&pi->lock);
    80003d38:	8526                	mv	a0,s1
    80003d3a:	765010ef          	jal	80005c9e <release>
    80003d3e:	7b02                	ld	s6,32(sp)
    80003d40:	6be2                	ld	s7,24(sp)
    80003d42:	6c42                	ld	s8,16(sp)
  return i;
}
    80003d44:	854e                	mv	a0,s3
    80003d46:	60e6                	ld	ra,88(sp)
    80003d48:	6446                	ld	s0,80(sp)
    80003d4a:	64a6                	ld	s1,72(sp)
    80003d4c:	6906                	ld	s2,64(sp)
    80003d4e:	79e2                	ld	s3,56(sp)
    80003d50:	7a42                	ld	s4,48(sp)
    80003d52:	7aa2                	ld	s5,40(sp)
    80003d54:	6125                	addi	sp,sp,96
    80003d56:	8082                	ret

0000000080003d58 <flags2perm>:

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

// map ELF permissions to PTE permission bits.
int flags2perm(int flags)
{
    80003d58:	1141                	addi	sp,sp,-16
    80003d5a:	e406                	sd	ra,8(sp)
    80003d5c:	e022                	sd	s0,0(sp)
    80003d5e:	0800                	addi	s0,sp,16
    80003d60:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80003d62:	0035151b          	slliw	a0,a0,0x3
    80003d66:	8921                	andi	a0,a0,8
      perm = PTE_X;
    if(flags & 0x2)
    80003d68:	8b89                	andi	a5,a5,2
    80003d6a:	c399                	beqz	a5,80003d70 <flags2perm+0x18>
      perm |= PTE_W;
    80003d6c:	00456513          	ori	a0,a0,4
    return perm;
}
    80003d70:	60a2                	ld	ra,8(sp)
    80003d72:	6402                	ld	s0,0(sp)
    80003d74:	0141                	addi	sp,sp,16
    80003d76:	8082                	ret

0000000080003d78 <kexec>:
//
// the implementation of the exec() system call
//
int
kexec(char *path, char **argv)
{
    80003d78:	de010113          	addi	sp,sp,-544
    80003d7c:	20113c23          	sd	ra,536(sp)
    80003d80:	20813823          	sd	s0,528(sp)
    80003d84:	20913423          	sd	s1,520(sp)
    80003d88:	21213023          	sd	s2,512(sp)
    80003d8c:	1400                	addi	s0,sp,544
    80003d8e:	892a                	mv	s2,a0
    80003d90:	dea43823          	sd	a0,-528(s0)
    80003d94:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80003d98:	a96fd0ef          	jal	8000102e <myproc>
    80003d9c:	84aa                	mv	s1,a0

  begin_op();
    80003d9e:	d74ff0ef          	jal	80003312 <begin_op>

  // Open the executable file.
  if((ip = namei(path)) == 0){
    80003da2:	854a                	mv	a0,s2
    80003da4:	b90ff0ef          	jal	80003134 <namei>
    80003da8:	cd21                	beqz	a0,80003e00 <kexec+0x88>
    80003daa:	fbd2                	sd	s4,496(sp)
    80003dac:	8a2a                	mv	s4,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80003dae:	b59fe0ef          	jal	80002906 <ilock>

  // Read the ELF header.
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80003db2:	04000713          	li	a4,64
    80003db6:	4681                	li	a3,0
    80003db8:	e5040613          	addi	a2,s0,-432
    80003dbc:	4581                	li	a1,0
    80003dbe:	8552                	mv	a0,s4
    80003dc0:	ed9fe0ef          	jal	80002c98 <readi>
    80003dc4:	04000793          	li	a5,64
    80003dc8:	00f51a63          	bne	a0,a5,80003ddc <kexec+0x64>
    goto bad;

  // Is this really an ELF file?
  if(elf.magic != ELF_MAGIC)
    80003dcc:	e5042703          	lw	a4,-432(s0)
    80003dd0:	464c47b7          	lui	a5,0x464c4
    80003dd4:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80003dd8:	02f70863          	beq	a4,a5,80003e08 <kexec+0x90>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80003ddc:	8552                	mv	a0,s4
    80003dde:	d35fe0ef          	jal	80002b12 <iunlockput>
    end_op();
    80003de2:	da0ff0ef          	jal	80003382 <end_op>
  }
  return -1;
    80003de6:	557d                	li	a0,-1
    80003de8:	7a5e                	ld	s4,496(sp)
}
    80003dea:	21813083          	ld	ra,536(sp)
    80003dee:	21013403          	ld	s0,528(sp)
    80003df2:	20813483          	ld	s1,520(sp)
    80003df6:	20013903          	ld	s2,512(sp)
    80003dfa:	22010113          	addi	sp,sp,544
    80003dfe:	8082                	ret
    end_op();
    80003e00:	d82ff0ef          	jal	80003382 <end_op>
    return -1;
    80003e04:	557d                	li	a0,-1
    80003e06:	b7d5                	j	80003dea <kexec+0x72>
    80003e08:	f3da                	sd	s6,480(sp)
  if((pagetable = proc_pagetable(p)) == 0)
    80003e0a:	8526                	mv	a0,s1
    80003e0c:	b2cfd0ef          	jal	80001138 <proc_pagetable>
    80003e10:	8b2a                	mv	s6,a0
    80003e12:	26050f63          	beqz	a0,80004090 <kexec+0x318>
    80003e16:	ffce                	sd	s3,504(sp)
    80003e18:	f7d6                	sd	s5,488(sp)
    80003e1a:	efde                	sd	s7,472(sp)
    80003e1c:	ebe2                	sd	s8,464(sp)
    80003e1e:	e7e6                	sd	s9,456(sp)
    80003e20:	e3ea                	sd	s10,448(sp)
    80003e22:	ff6e                	sd	s11,440(sp)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003e24:	e8845783          	lhu	a5,-376(s0)
    80003e28:	0e078963          	beqz	a5,80003f1a <kexec+0x1a2>
    80003e2c:	e7042683          	lw	a3,-400(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003e30:	4901                	li	s2,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003e32:	4d01                	li	s10,0
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003e34:	03800d93          	li	s11,56
    if(ph.vaddr % PGSIZE != 0)
    80003e38:	6c85                	lui	s9,0x1
    80003e3a:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80003e3e:	def43423          	sd	a5,-536(s0)

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    if(sz - i < PGSIZE)
    80003e42:	6a85                	lui	s5,0x1
    80003e44:	a085                	j	80003ea4 <kexec+0x12c>
      panic("loadseg: address should exist");
    80003e46:	00003517          	auipc	a0,0x3
    80003e4a:	76a50513          	addi	a0,a0,1898 # 800075b0 <etext+0x5b0>
    80003e4e:	31b010ef          	jal	80005968 <panic>
    if(sz - i < PGSIZE)
    80003e52:	2901                	sext.w	s2,s2
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80003e54:	874a                	mv	a4,s2
    80003e56:	009b86bb          	addw	a3,s7,s1
    80003e5a:	4581                	li	a1,0
    80003e5c:	8552                	mv	a0,s4
    80003e5e:	e3bfe0ef          	jal	80002c98 <readi>
    80003e62:	22a91b63          	bne	s2,a0,80004098 <kexec+0x320>
  for(i = 0; i < sz; i += PGSIZE){
    80003e66:	009a84bb          	addw	s1,s5,s1
    80003e6a:	0334f263          	bgeu	s1,s3,80003e8e <kexec+0x116>
    pa = walkaddr(pagetable, va + i);
    80003e6e:	02049593          	slli	a1,s1,0x20
    80003e72:	9181                	srli	a1,a1,0x20
    80003e74:	95e2                	add	a1,a1,s8
    80003e76:	855a                	mv	a0,s6
    80003e78:	f5afc0ef          	jal	800005d2 <walkaddr>
    80003e7c:	862a                	mv	a2,a0
    if(pa == 0)
    80003e7e:	d561                	beqz	a0,80003e46 <kexec+0xce>
    if(sz - i < PGSIZE)
    80003e80:	409987bb          	subw	a5,s3,s1
    80003e84:	893e                	mv	s2,a5
    80003e86:	fcfcf6e3          	bgeu	s9,a5,80003e52 <kexec+0xda>
    80003e8a:	8956                	mv	s2,s5
    80003e8c:	b7d9                	j	80003e52 <kexec+0xda>
    sz = sz1;
    80003e8e:	df843903          	ld	s2,-520(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80003e92:	2d05                	addiw	s10,s10,1
    80003e94:	e0843783          	ld	a5,-504(s0)
    80003e98:	0387869b          	addiw	a3,a5,56
    80003e9c:	e8845783          	lhu	a5,-376(s0)
    80003ea0:	06fd5e63          	bge	s10,a5,80003f1c <kexec+0x1a4>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80003ea4:	e0d43423          	sd	a3,-504(s0)
    80003ea8:	876e                	mv	a4,s11
    80003eaa:	e1840613          	addi	a2,s0,-488
    80003eae:	4581                	li	a1,0
    80003eb0:	8552                	mv	a0,s4
    80003eb2:	de7fe0ef          	jal	80002c98 <readi>
    80003eb6:	1db51f63          	bne	a0,s11,80004094 <kexec+0x31c>
    if(ph.type != ELF_PROG_LOAD)
    80003eba:	e1842783          	lw	a5,-488(s0)
    80003ebe:	4705                	li	a4,1
    80003ec0:	fce799e3          	bne	a5,a4,80003e92 <kexec+0x11a>
    if(ph.memsz < ph.filesz)
    80003ec4:	e4043483          	ld	s1,-448(s0)
    80003ec8:	e3843783          	ld	a5,-456(s0)
    80003ecc:	1ef4e463          	bltu	s1,a5,800040b4 <kexec+0x33c>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80003ed0:	e2843783          	ld	a5,-472(s0)
    80003ed4:	94be                	add	s1,s1,a5
    80003ed6:	1ef4e263          	bltu	s1,a5,800040ba <kexec+0x342>
    if(ph.vaddr % PGSIZE != 0)
    80003eda:	de843703          	ld	a4,-536(s0)
    80003ede:	8ff9                	and	a5,a5,a4
    80003ee0:	1e079063          	bnez	a5,800040c0 <kexec+0x348>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80003ee4:	e1c42503          	lw	a0,-484(s0)
    80003ee8:	e71ff0ef          	jal	80003d58 <flags2perm>
    80003eec:	86aa                	mv	a3,a0
    80003eee:	8626                	mv	a2,s1
    80003ef0:	85ca                	mv	a1,s2
    80003ef2:	855a                	mv	a0,s6
    80003ef4:	9b5fc0ef          	jal	800008a8 <uvmalloc>
    80003ef8:	dea43c23          	sd	a0,-520(s0)
    80003efc:	1c050563          	beqz	a0,800040c6 <kexec+0x34e>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003f00:	e3842983          	lw	s3,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003f04:	00098863          	beqz	s3,80003f14 <kexec+0x19c>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80003f08:	e2843c03          	ld	s8,-472(s0)
    80003f0c:	e2042b83          	lw	s7,-480(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80003f10:	4481                	li	s1,0
    80003f12:	bfb1                	j	80003e6e <kexec+0xf6>
    sz = sz1;
    80003f14:	df843903          	ld	s2,-520(s0)
    80003f18:	bfad                	j	80003e92 <kexec+0x11a>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80003f1a:	4901                	li	s2,0
  iunlockput(ip);
    80003f1c:	8552                	mv	a0,s4
    80003f1e:	bf5fe0ef          	jal	80002b12 <iunlockput>
  end_op();
    80003f22:	c60ff0ef          	jal	80003382 <end_op>
  p = myproc();
    80003f26:	908fd0ef          	jal	8000102e <myproc>
    80003f2a:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80003f2c:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80003f30:	6985                	lui	s3,0x1
    80003f32:	19fd                	addi	s3,s3,-1 # fff <_entry-0x7ffff001>
    80003f34:	99ca                	add	s3,s3,s2
    80003f36:	77fd                	lui	a5,0xfffff
    80003f38:	00f9f9b3          	and	s3,s3,a5
  if((sz1 = uvmalloc(pagetable, sz, sz + (USERSTACK+1)*PGSIZE, PTE_W)) == 0)
    80003f3c:	4691                	li	a3,4
    80003f3e:	6609                	lui	a2,0x2
    80003f40:	964e                	add	a2,a2,s3
    80003f42:	85ce                	mv	a1,s3
    80003f44:	855a                	mv	a0,s6
    80003f46:	963fc0ef          	jal	800008a8 <uvmalloc>
    80003f4a:	8a2a                	mv	s4,a0
    80003f4c:	e105                	bnez	a0,80003f6c <kexec+0x1f4>
    proc_freepagetable(pagetable, sz);
    80003f4e:	85ce                	mv	a1,s3
    80003f50:	855a                	mv	a0,s6
    80003f52:	a6afd0ef          	jal	800011bc <proc_freepagetable>
  return -1;
    80003f56:	557d                	li	a0,-1
    80003f58:	79fe                	ld	s3,504(sp)
    80003f5a:	7a5e                	ld	s4,496(sp)
    80003f5c:	7abe                	ld	s5,488(sp)
    80003f5e:	7b1e                	ld	s6,480(sp)
    80003f60:	6bfe                	ld	s7,472(sp)
    80003f62:	6c5e                	ld	s8,464(sp)
    80003f64:	6cbe                	ld	s9,456(sp)
    80003f66:	6d1e                	ld	s10,448(sp)
    80003f68:	7dfa                	ld	s11,440(sp)
    80003f6a:	b541                	j	80003dea <kexec+0x72>
  uvmclear(pagetable, sz-(USERSTACK+1)*PGSIZE);
    80003f6c:	75f9                	lui	a1,0xffffe
    80003f6e:	95aa                	add	a1,a1,a0
    80003f70:	855a                	mv	a0,s6
    80003f72:	b5bfc0ef          	jal	80000acc <uvmclear>
  stackbase = sp - USERSTACK*PGSIZE;
    80003f76:	800a0b93          	addi	s7,s4,-2048
    80003f7a:	800b8b93          	addi	s7,s7,-2048
  for(argc = 0; argv[argc]; argc++) {
    80003f7e:	e0043783          	ld	a5,-512(s0)
    80003f82:	6388                	ld	a0,0(a5)
  sp = sz;
    80003f84:	8952                	mv	s2,s4
  for(argc = 0; argv[argc]; argc++) {
    80003f86:	4481                	li	s1,0
    ustack[argc] = sp;
    80003f88:	e9040c93          	addi	s9,s0,-368
    if(argc >= MAXARG)
    80003f8c:	02000c13          	li	s8,32
  for(argc = 0; argv[argc]; argc++) {
    80003f90:	cd21                	beqz	a0,80003fe8 <kexec+0x270>
    sp -= strlen(argv[argc]) + 1;
    80003f92:	c9cfc0ef          	jal	8000042e <strlen>
    80003f96:	0015079b          	addiw	a5,a0,1
    80003f9a:	40f907b3          	sub	a5,s2,a5
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80003f9e:	ff07f913          	andi	s2,a5,-16
    if(sp < stackbase)
    80003fa2:	13796563          	bltu	s2,s7,800040cc <kexec+0x354>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80003fa6:	e0043d83          	ld	s11,-512(s0)
    80003faa:	000db983          	ld	s3,0(s11)
    80003fae:	854e                	mv	a0,s3
    80003fb0:	c7efc0ef          	jal	8000042e <strlen>
    80003fb4:	0015069b          	addiw	a3,a0,1
    80003fb8:	864e                	mv	a2,s3
    80003fba:	85ca                	mv	a1,s2
    80003fbc:	855a                	mv	a0,s6
    80003fbe:	d79fc0ef          	jal	80000d36 <copyout>
    80003fc2:	10054763          	bltz	a0,800040d0 <kexec+0x358>
    ustack[argc] = sp;
    80003fc6:	00349793          	slli	a5,s1,0x3
    80003fca:	97e6                	add	a5,a5,s9
    80003fcc:	0127b023          	sd	s2,0(a5) # fffffffffffff000 <end+0xffffffff7fdbe408>
  for(argc = 0; argv[argc]; argc++) {
    80003fd0:	0485                	addi	s1,s1,1
    80003fd2:	008d8793          	addi	a5,s11,8
    80003fd6:	e0f43023          	sd	a5,-512(s0)
    80003fda:	008db503          	ld	a0,8(s11)
    80003fde:	c509                	beqz	a0,80003fe8 <kexec+0x270>
    if(argc >= MAXARG)
    80003fe0:	fb8499e3          	bne	s1,s8,80003f92 <kexec+0x21a>
  sz = sz1;
    80003fe4:	89d2                	mv	s3,s4
    80003fe6:	b7a5                	j	80003f4e <kexec+0x1d6>
  ustack[argc] = 0;
    80003fe8:	00349793          	slli	a5,s1,0x3
    80003fec:	f9078793          	addi	a5,a5,-112
    80003ff0:	97a2                	add	a5,a5,s0
    80003ff2:	f007b023          	sd	zero,-256(a5)
  sp -= (argc+1) * sizeof(uint64);
    80003ff6:	00349693          	slli	a3,s1,0x3
    80003ffa:	06a1                	addi	a3,a3,8
    80003ffc:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004000:	ff097913          	andi	s2,s2,-16
  sz = sz1;
    80004004:	89d2                	mv	s3,s4
  if(sp < stackbase)
    80004006:	f57964e3          	bltu	s2,s7,80003f4e <kexec+0x1d6>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000400a:	e9040613          	addi	a2,s0,-368
    8000400e:	85ca                	mv	a1,s2
    80004010:	855a                	mv	a0,s6
    80004012:	d25fc0ef          	jal	80000d36 <copyout>
    80004016:	f2054ce3          	bltz	a0,80003f4e <kexec+0x1d6>
  p->trapframe->a1 = sp;
    8000401a:	058ab783          	ld	a5,88(s5) # 1058 <_entry-0x7fffefa8>
    8000401e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004022:	df043783          	ld	a5,-528(s0)
    80004026:	0007c703          	lbu	a4,0(a5)
    8000402a:	cf11                	beqz	a4,80004046 <kexec+0x2ce>
    8000402c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000402e:	02f00693          	li	a3,47
    80004032:	a029                	j	8000403c <kexec+0x2c4>
  for(last=s=path; *s; s++)
    80004034:	0785                	addi	a5,a5,1
    80004036:	fff7c703          	lbu	a4,-1(a5)
    8000403a:	c711                	beqz	a4,80004046 <kexec+0x2ce>
    if(*s == '/')
    8000403c:	fed71ce3          	bne	a4,a3,80004034 <kexec+0x2bc>
      last = s+1;
    80004040:	def43823          	sd	a5,-528(s0)
    80004044:	bfc5                	j	80004034 <kexec+0x2bc>
  safestrcpy(p->name, last, sizeof(p->name));
    80004046:	4641                	li	a2,16
    80004048:	df043583          	ld	a1,-528(s0)
    8000404c:	158a8513          	addi	a0,s5,344
    80004050:	ba8fc0ef          	jal	800003f8 <safestrcpy>
  oldpagetable = p->pagetable;
    80004054:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004058:	056ab823          	sd	s6,80(s5)
  p->sz = sz;
    8000405c:	054ab423          	sd	s4,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = ulib.c:start()
    80004060:	058ab783          	ld	a5,88(s5)
    80004064:	e6843703          	ld	a4,-408(s0)
    80004068:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000406a:	058ab783          	ld	a5,88(s5)
    8000406e:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004072:	85ea                	mv	a1,s10
    80004074:	948fd0ef          	jal	800011bc <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004078:	0004851b          	sext.w	a0,s1
    8000407c:	79fe                	ld	s3,504(sp)
    8000407e:	7a5e                	ld	s4,496(sp)
    80004080:	7abe                	ld	s5,488(sp)
    80004082:	7b1e                	ld	s6,480(sp)
    80004084:	6bfe                	ld	s7,472(sp)
    80004086:	6c5e                	ld	s8,464(sp)
    80004088:	6cbe                	ld	s9,456(sp)
    8000408a:	6d1e                	ld	s10,448(sp)
    8000408c:	7dfa                	ld	s11,440(sp)
    8000408e:	bbb1                	j	80003dea <kexec+0x72>
    80004090:	7b1e                	ld	s6,480(sp)
    80004092:	b3a9                	j	80003ddc <kexec+0x64>
    80004094:	df243c23          	sd	s2,-520(s0)
    proc_freepagetable(pagetable, sz);
    80004098:	df843583          	ld	a1,-520(s0)
    8000409c:	855a                	mv	a0,s6
    8000409e:	91efd0ef          	jal	800011bc <proc_freepagetable>
  if(ip){
    800040a2:	79fe                	ld	s3,504(sp)
    800040a4:	7abe                	ld	s5,488(sp)
    800040a6:	7b1e                	ld	s6,480(sp)
    800040a8:	6bfe                	ld	s7,472(sp)
    800040aa:	6c5e                	ld	s8,464(sp)
    800040ac:	6cbe                	ld	s9,456(sp)
    800040ae:	6d1e                	ld	s10,448(sp)
    800040b0:	7dfa                	ld	s11,440(sp)
    800040b2:	b32d                	j	80003ddc <kexec+0x64>
    800040b4:	df243c23          	sd	s2,-520(s0)
    800040b8:	b7c5                	j	80004098 <kexec+0x320>
    800040ba:	df243c23          	sd	s2,-520(s0)
    800040be:	bfe9                	j	80004098 <kexec+0x320>
    800040c0:	df243c23          	sd	s2,-520(s0)
    800040c4:	bfd1                	j	80004098 <kexec+0x320>
    800040c6:	df243c23          	sd	s2,-520(s0)
    800040ca:	b7f9                	j	80004098 <kexec+0x320>
  sz = sz1;
    800040cc:	89d2                	mv	s3,s4
    800040ce:	b541                	j	80003f4e <kexec+0x1d6>
    800040d0:	89d2                	mv	s3,s4
    800040d2:	bdb5                	j	80003f4e <kexec+0x1d6>

00000000800040d4 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800040d4:	7179                	addi	sp,sp,-48
    800040d6:	f406                	sd	ra,40(sp)
    800040d8:	f022                	sd	s0,32(sp)
    800040da:	ec26                	sd	s1,24(sp)
    800040dc:	e84a                	sd	s2,16(sp)
    800040de:	1800                	addi	s0,sp,48
    800040e0:	892e                	mv	s2,a1
    800040e2:	84b2                	mv	s1,a2
  int fd;
  struct file *f;

  argint(n, &fd);
    800040e4:	fdc40593          	addi	a1,s0,-36
    800040e8:	e61fd0ef          	jal	80001f48 <argint>
  if(fd < 0 || fd >= NOFILE || (f=myproc()->ofile[fd]) == 0)
    800040ec:	fdc42703          	lw	a4,-36(s0)
    800040f0:	47bd                	li	a5,15
    800040f2:	02e7ea63          	bltu	a5,a4,80004126 <argfd+0x52>
    800040f6:	f39fc0ef          	jal	8000102e <myproc>
    800040fa:	fdc42703          	lw	a4,-36(s0)
    800040fe:	00371793          	slli	a5,a4,0x3
    80004102:	0d078793          	addi	a5,a5,208
    80004106:	953e                	add	a0,a0,a5
    80004108:	611c                	ld	a5,0(a0)
    8000410a:	c385                	beqz	a5,8000412a <argfd+0x56>
    return -1;
  if(pfd)
    8000410c:	00090463          	beqz	s2,80004114 <argfd+0x40>
    *pfd = fd;
    80004110:	00e92023          	sw	a4,0(s2)
  if(pf)
    *pf = f;
  return 0;
    80004114:	4501                	li	a0,0
  if(pf)
    80004116:	c091                	beqz	s1,8000411a <argfd+0x46>
    *pf = f;
    80004118:	e09c                	sd	a5,0(s1)
}
    8000411a:	70a2                	ld	ra,40(sp)
    8000411c:	7402                	ld	s0,32(sp)
    8000411e:	64e2                	ld	s1,24(sp)
    80004120:	6942                	ld	s2,16(sp)
    80004122:	6145                	addi	sp,sp,48
    80004124:	8082                	ret
    return -1;
    80004126:	557d                	li	a0,-1
    80004128:	bfcd                	j	8000411a <argfd+0x46>
    8000412a:	557d                	li	a0,-1
    8000412c:	b7fd                	j	8000411a <argfd+0x46>

000000008000412e <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000412e:	1101                	addi	sp,sp,-32
    80004130:	ec06                	sd	ra,24(sp)
    80004132:	e822                	sd	s0,16(sp)
    80004134:	e426                	sd	s1,8(sp)
    80004136:	1000                	addi	s0,sp,32
    80004138:	84aa                	mv	s1,a0
  int fd;
  struct proc *p = myproc();
    8000413a:	ef5fc0ef          	jal	8000102e <myproc>
    8000413e:	862a                	mv	a2,a0

  for(fd = 0; fd < NOFILE; fd++){
    80004140:	0d050793          	addi	a5,a0,208
    80004144:	4501                	li	a0,0
    80004146:	46c1                	li	a3,16
    if(p->ofile[fd] == 0){
    80004148:	6398                	ld	a4,0(a5)
    8000414a:	cb19                	beqz	a4,80004160 <fdalloc+0x32>
  for(fd = 0; fd < NOFILE; fd++){
    8000414c:	2505                	addiw	a0,a0,1
    8000414e:	07a1                	addi	a5,a5,8
    80004150:	fed51ce3          	bne	a0,a3,80004148 <fdalloc+0x1a>
      p->ofile[fd] = f;
      return fd;
    }
  }
  return -1;
    80004154:	557d                	li	a0,-1
}
    80004156:	60e2                	ld	ra,24(sp)
    80004158:	6442                	ld	s0,16(sp)
    8000415a:	64a2                	ld	s1,8(sp)
    8000415c:	6105                	addi	sp,sp,32
    8000415e:	8082                	ret
      p->ofile[fd] = f;
    80004160:	00351793          	slli	a5,a0,0x3
    80004164:	0d078793          	addi	a5,a5,208
    80004168:	963e                	add	a2,a2,a5
    8000416a:	e204                	sd	s1,0(a2)
      return fd;
    8000416c:	b7ed                	j	80004156 <fdalloc+0x28>

000000008000416e <create>:
  return -1;
}

static struct inode*
create(char *path, short type, short major, short minor)
{
    8000416e:	715d                	addi	sp,sp,-80
    80004170:	e486                	sd	ra,72(sp)
    80004172:	e0a2                	sd	s0,64(sp)
    80004174:	fc26                	sd	s1,56(sp)
    80004176:	f84a                	sd	s2,48(sp)
    80004178:	f44e                	sd	s3,40(sp)
    8000417a:	f052                	sd	s4,32(sp)
    8000417c:	ec56                	sd	s5,24(sp)
    8000417e:	e85a                	sd	s6,16(sp)
    80004180:	0880                	addi	s0,sp,80
    80004182:	892e                	mv	s2,a1
    80004184:	8a2e                	mv	s4,a1
    80004186:	8ab2                	mv	s5,a2
    80004188:	8b36                	mv	s6,a3
  struct inode *ip, *dp;
  char name[DIRSIZ];

  if((dp = nameiparent(path, name)) == 0)
    8000418a:	fb040593          	addi	a1,s0,-80
    8000418e:	fc1fe0ef          	jal	8000314e <nameiparent>
    80004192:	84aa                	mv	s1,a0
    80004194:	10050763          	beqz	a0,800042a2 <create+0x134>
    return 0;

  ilock(dp);
    80004198:	f6efe0ef          	jal	80002906 <ilock>

  if((ip = dirlookup(dp, name, 0)) != 0){
    8000419c:	4601                	li	a2,0
    8000419e:	fb040593          	addi	a1,s0,-80
    800041a2:	8526                	mv	a0,s1
    800041a4:	cfdfe0ef          	jal	80002ea0 <dirlookup>
    800041a8:	89aa                	mv	s3,a0
    800041aa:	c131                	beqz	a0,800041ee <create+0x80>
    iunlockput(dp);
    800041ac:	8526                	mv	a0,s1
    800041ae:	965fe0ef          	jal	80002b12 <iunlockput>
    ilock(ip);
    800041b2:	854e                	mv	a0,s3
    800041b4:	f52fe0ef          	jal	80002906 <ilock>
    if(type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800041b8:	4789                	li	a5,2
    800041ba:	02f91563          	bne	s2,a5,800041e4 <create+0x76>
    800041be:	0449d783          	lhu	a5,68(s3)
    800041c2:	37f9                	addiw	a5,a5,-2
    800041c4:	17c2                	slli	a5,a5,0x30
    800041c6:	93c1                	srli	a5,a5,0x30
    800041c8:	4705                	li	a4,1
    800041ca:	00f76d63          	bltu	a4,a5,800041e4 <create+0x76>
  ip->nlink = 0;
  iupdate(ip);
  iunlockput(ip);
  iunlockput(dp);
  return 0;
}
    800041ce:	854e                	mv	a0,s3
    800041d0:	60a6                	ld	ra,72(sp)
    800041d2:	6406                	ld	s0,64(sp)
    800041d4:	74e2                	ld	s1,56(sp)
    800041d6:	7942                	ld	s2,48(sp)
    800041d8:	79a2                	ld	s3,40(sp)
    800041da:	7a02                	ld	s4,32(sp)
    800041dc:	6ae2                	ld	s5,24(sp)
    800041de:	6b42                	ld	s6,16(sp)
    800041e0:	6161                	addi	sp,sp,80
    800041e2:	8082                	ret
    iunlockput(ip);
    800041e4:	854e                	mv	a0,s3
    800041e6:	92dfe0ef          	jal	80002b12 <iunlockput>
    return 0;
    800041ea:	4981                	li	s3,0
    800041ec:	b7cd                	j	800041ce <create+0x60>
  if((ip = ialloc(dp->dev, type)) == 0){
    800041ee:	85ca                	mv	a1,s2
    800041f0:	4088                	lw	a0,0(s1)
    800041f2:	da4fe0ef          	jal	80002796 <ialloc>
    800041f6:	892a                	mv	s2,a0
    800041f8:	cd15                	beqz	a0,80004234 <create+0xc6>
  ilock(ip);
    800041fa:	f0cfe0ef          	jal	80002906 <ilock>
  ip->major = major;
    800041fe:	05591323          	sh	s5,70(s2)
  ip->minor = minor;
    80004202:	05691423          	sh	s6,72(s2)
  ip->nlink = 1;
    80004206:	4785                	li	a5,1
    80004208:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    8000420c:	854a                	mv	a0,s2
    8000420e:	e44fe0ef          	jal	80002852 <iupdate>
  if(type == T_DIR){  // Create . and .. entries.
    80004212:	4705                	li	a4,1
    80004214:	02ea0463          	beq	s4,a4,8000423c <create+0xce>
  if(dirlink(dp, name, ip->inum) < 0)
    80004218:	00492603          	lw	a2,4(s2)
    8000421c:	fb040593          	addi	a1,s0,-80
    80004220:	8526                	mv	a0,s1
    80004222:	e69fe0ef          	jal	8000308a <dirlink>
    80004226:	06054263          	bltz	a0,8000428a <create+0x11c>
  iunlockput(dp);
    8000422a:	8526                	mv	a0,s1
    8000422c:	8e7fe0ef          	jal	80002b12 <iunlockput>
  return ip;
    80004230:	89ca                	mv	s3,s2
    80004232:	bf71                	j	800041ce <create+0x60>
    iunlockput(dp);
    80004234:	8526                	mv	a0,s1
    80004236:	8ddfe0ef          	jal	80002b12 <iunlockput>
    return 0;
    8000423a:	bf51                	j	800041ce <create+0x60>
    if(dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000423c:	00492603          	lw	a2,4(s2)
    80004240:	00003597          	auipc	a1,0x3
    80004244:	39058593          	addi	a1,a1,912 # 800075d0 <etext+0x5d0>
    80004248:	854a                	mv	a0,s2
    8000424a:	e41fe0ef          	jal	8000308a <dirlink>
    8000424e:	02054e63          	bltz	a0,8000428a <create+0x11c>
    80004252:	40d0                	lw	a2,4(s1)
    80004254:	00003597          	auipc	a1,0x3
    80004258:	38458593          	addi	a1,a1,900 # 800075d8 <etext+0x5d8>
    8000425c:	854a                	mv	a0,s2
    8000425e:	e2dfe0ef          	jal	8000308a <dirlink>
    80004262:	02054463          	bltz	a0,8000428a <create+0x11c>
  if(dirlink(dp, name, ip->inum) < 0)
    80004266:	00492603          	lw	a2,4(s2)
    8000426a:	fb040593          	addi	a1,s0,-80
    8000426e:	8526                	mv	a0,s1
    80004270:	e1bfe0ef          	jal	8000308a <dirlink>
    80004274:	00054b63          	bltz	a0,8000428a <create+0x11c>
    dp->nlink++;  // for ".."
    80004278:	04a4d783          	lhu	a5,74(s1)
    8000427c:	2785                	addiw	a5,a5,1
    8000427e:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    80004282:	8526                	mv	a0,s1
    80004284:	dcefe0ef          	jal	80002852 <iupdate>
    80004288:	b74d                	j	8000422a <create+0xbc>
  ip->nlink = 0;
    8000428a:	04091523          	sh	zero,74(s2)
  iupdate(ip);
    8000428e:	854a                	mv	a0,s2
    80004290:	dc2fe0ef          	jal	80002852 <iupdate>
  iunlockput(ip);
    80004294:	854a                	mv	a0,s2
    80004296:	87dfe0ef          	jal	80002b12 <iunlockput>
  iunlockput(dp);
    8000429a:	8526                	mv	a0,s1
    8000429c:	877fe0ef          	jal	80002b12 <iunlockput>
  return 0;
    800042a0:	b73d                	j	800041ce <create+0x60>
    return 0;
    800042a2:	89aa                	mv	s3,a0
    800042a4:	b72d                	j	800041ce <create+0x60>

00000000800042a6 <sys_dup>:
{
    800042a6:	7179                	addi	sp,sp,-48
    800042a8:	f406                	sd	ra,40(sp)
    800042aa:	f022                	sd	s0,32(sp)
    800042ac:	1800                	addi	s0,sp,48
  if(argfd(0, 0, &f) < 0)
    800042ae:	fd840613          	addi	a2,s0,-40
    800042b2:	4581                	li	a1,0
    800042b4:	4501                	li	a0,0
    800042b6:	e1fff0ef          	jal	800040d4 <argfd>
    return -1;
    800042ba:	57fd                	li	a5,-1
  if(argfd(0, 0, &f) < 0)
    800042bc:	02054363          	bltz	a0,800042e2 <sys_dup+0x3c>
    800042c0:	ec26                	sd	s1,24(sp)
    800042c2:	e84a                	sd	s2,16(sp)
  if((fd=fdalloc(f)) < 0)
    800042c4:	fd843483          	ld	s1,-40(s0)
    800042c8:	8526                	mv	a0,s1
    800042ca:	e65ff0ef          	jal	8000412e <fdalloc>
    800042ce:	892a                	mv	s2,a0
    return -1;
    800042d0:	57fd                	li	a5,-1
  if((fd=fdalloc(f)) < 0)
    800042d2:	00054d63          	bltz	a0,800042ec <sys_dup+0x46>
  filedup(f);
    800042d6:	8526                	mv	a0,s1
    800042d8:	c18ff0ef          	jal	800036f0 <filedup>
  return fd;
    800042dc:	87ca                	mv	a5,s2
    800042de:	64e2                	ld	s1,24(sp)
    800042e0:	6942                	ld	s2,16(sp)
}
    800042e2:	853e                	mv	a0,a5
    800042e4:	70a2                	ld	ra,40(sp)
    800042e6:	7402                	ld	s0,32(sp)
    800042e8:	6145                	addi	sp,sp,48
    800042ea:	8082                	ret
    800042ec:	64e2                	ld	s1,24(sp)
    800042ee:	6942                	ld	s2,16(sp)
    800042f0:	bfcd                	j	800042e2 <sys_dup+0x3c>

00000000800042f2 <sys_read>:
{
    800042f2:	7179                	addi	sp,sp,-48
    800042f4:	f406                	sd	ra,40(sp)
    800042f6:	f022                	sd	s0,32(sp)
    800042f8:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    800042fa:	fd840593          	addi	a1,s0,-40
    800042fe:	4505                	li	a0,1
    80004300:	c65fd0ef          	jal	80001f64 <argaddr>
  argint(2, &n);
    80004304:	fe440593          	addi	a1,s0,-28
    80004308:	4509                	li	a0,2
    8000430a:	c3ffd0ef          	jal	80001f48 <argint>
  if(argfd(0, 0, &f) < 0)
    8000430e:	fe840613          	addi	a2,s0,-24
    80004312:	4581                	li	a1,0
    80004314:	4501                	li	a0,0
    80004316:	dbfff0ef          	jal	800040d4 <argfd>
    8000431a:	87aa                	mv	a5,a0
    return -1;
    8000431c:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    8000431e:	0007ca63          	bltz	a5,80004332 <sys_read+0x40>
  return fileread(f, p, n);
    80004322:	fe442603          	lw	a2,-28(s0)
    80004326:	fd843583          	ld	a1,-40(s0)
    8000432a:	fe843503          	ld	a0,-24(s0)
    8000432e:	d2cff0ef          	jal	8000385a <fileread>
}
    80004332:	70a2                	ld	ra,40(sp)
    80004334:	7402                	ld	s0,32(sp)
    80004336:	6145                	addi	sp,sp,48
    80004338:	8082                	ret

000000008000433a <sys_write>:
{
    8000433a:	7179                	addi	sp,sp,-48
    8000433c:	f406                	sd	ra,40(sp)
    8000433e:	f022                	sd	s0,32(sp)
    80004340:	1800                	addi	s0,sp,48
  argaddr(1, &p);
    80004342:	fd840593          	addi	a1,s0,-40
    80004346:	4505                	li	a0,1
    80004348:	c1dfd0ef          	jal	80001f64 <argaddr>
  argint(2, &n);
    8000434c:	fe440593          	addi	a1,s0,-28
    80004350:	4509                	li	a0,2
    80004352:	bf7fd0ef          	jal	80001f48 <argint>
  if(argfd(0, 0, &f) < 0)
    80004356:	fe840613          	addi	a2,s0,-24
    8000435a:	4581                	li	a1,0
    8000435c:	4501                	li	a0,0
    8000435e:	d77ff0ef          	jal	800040d4 <argfd>
    80004362:	87aa                	mv	a5,a0
    return -1;
    80004364:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    80004366:	0007ca63          	bltz	a5,8000437a <sys_write+0x40>
  return filewrite(f, p, n);
    8000436a:	fe442603          	lw	a2,-28(s0)
    8000436e:	fd843583          	ld	a1,-40(s0)
    80004372:	fe843503          	ld	a0,-24(s0)
    80004376:	da8ff0ef          	jal	8000391e <filewrite>
}
    8000437a:	70a2                	ld	ra,40(sp)
    8000437c:	7402                	ld	s0,32(sp)
    8000437e:	6145                	addi	sp,sp,48
    80004380:	8082                	ret

0000000080004382 <sys_close>:
{
    80004382:	1101                	addi	sp,sp,-32
    80004384:	ec06                	sd	ra,24(sp)
    80004386:	e822                	sd	s0,16(sp)
    80004388:	1000                	addi	s0,sp,32
  if(argfd(0, &fd, &f) < 0)
    8000438a:	fe040613          	addi	a2,s0,-32
    8000438e:	fec40593          	addi	a1,s0,-20
    80004392:	4501                	li	a0,0
    80004394:	d41ff0ef          	jal	800040d4 <argfd>
    return -1;
    80004398:	57fd                	li	a5,-1
  if(argfd(0, &fd, &f) < 0)
    8000439a:	02054163          	bltz	a0,800043bc <sys_close+0x3a>
  myproc()->ofile[fd] = 0;
    8000439e:	c91fc0ef          	jal	8000102e <myproc>
    800043a2:	fec42783          	lw	a5,-20(s0)
    800043a6:	078e                	slli	a5,a5,0x3
    800043a8:	0d078793          	addi	a5,a5,208
    800043ac:	953e                	add	a0,a0,a5
    800043ae:	00053023          	sd	zero,0(a0)
  fileclose(f);
    800043b2:	fe043503          	ld	a0,-32(s0)
    800043b6:	b80ff0ef          	jal	80003736 <fileclose>
  return 0;
    800043ba:	4781                	li	a5,0
}
    800043bc:	853e                	mv	a0,a5
    800043be:	60e2                	ld	ra,24(sp)
    800043c0:	6442                	ld	s0,16(sp)
    800043c2:	6105                	addi	sp,sp,32
    800043c4:	8082                	ret

00000000800043c6 <sys_fstat>:
{
    800043c6:	1101                	addi	sp,sp,-32
    800043c8:	ec06                	sd	ra,24(sp)
    800043ca:	e822                	sd	s0,16(sp)
    800043cc:	1000                	addi	s0,sp,32
  argaddr(1, &st);
    800043ce:	fe040593          	addi	a1,s0,-32
    800043d2:	4505                	li	a0,1
    800043d4:	b91fd0ef          	jal	80001f64 <argaddr>
  if(argfd(0, 0, &f) < 0)
    800043d8:	fe840613          	addi	a2,s0,-24
    800043dc:	4581                	li	a1,0
    800043de:	4501                	li	a0,0
    800043e0:	cf5ff0ef          	jal	800040d4 <argfd>
    800043e4:	87aa                	mv	a5,a0
    return -1;
    800043e6:	557d                	li	a0,-1
  if(argfd(0, 0, &f) < 0)
    800043e8:	0007c863          	bltz	a5,800043f8 <sys_fstat+0x32>
  return filestat(f, st);
    800043ec:	fe043583          	ld	a1,-32(s0)
    800043f0:	fe843503          	ld	a0,-24(s0)
    800043f4:	c04ff0ef          	jal	800037f8 <filestat>
}
    800043f8:	60e2                	ld	ra,24(sp)
    800043fa:	6442                	ld	s0,16(sp)
    800043fc:	6105                	addi	sp,sp,32
    800043fe:	8082                	ret

0000000080004400 <sys_link>:
{
    80004400:	7169                	addi	sp,sp,-304
    80004402:	f606                	sd	ra,296(sp)
    80004404:	f222                	sd	s0,288(sp)
    80004406:	1a00                	addi	s0,sp,304
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004408:	08000613          	li	a2,128
    8000440c:	ed040593          	addi	a1,s0,-304
    80004410:	4501                	li	a0,0
    80004412:	b6ffd0ef          	jal	80001f80 <argstr>
    return -1;
    80004416:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004418:	0c054e63          	bltz	a0,800044f4 <sys_link+0xf4>
    8000441c:	08000613          	li	a2,128
    80004420:	f5040593          	addi	a1,s0,-176
    80004424:	4505                	li	a0,1
    80004426:	b5bfd0ef          	jal	80001f80 <argstr>
    return -1;
    8000442a:	57fd                	li	a5,-1
  if(argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000442c:	0c054463          	bltz	a0,800044f4 <sys_link+0xf4>
    80004430:	ee26                	sd	s1,280(sp)
  begin_op();
    80004432:	ee1fe0ef          	jal	80003312 <begin_op>
  if((ip = namei(old)) == 0){
    80004436:	ed040513          	addi	a0,s0,-304
    8000443a:	cfbfe0ef          	jal	80003134 <namei>
    8000443e:	84aa                	mv	s1,a0
    80004440:	c53d                	beqz	a0,800044ae <sys_link+0xae>
  ilock(ip);
    80004442:	cc4fe0ef          	jal	80002906 <ilock>
  if(ip->type == T_DIR){
    80004446:	04449703          	lh	a4,68(s1)
    8000444a:	4785                	li	a5,1
    8000444c:	06f70663          	beq	a4,a5,800044b8 <sys_link+0xb8>
    80004450:	ea4a                	sd	s2,272(sp)
  ip->nlink++;
    80004452:	04a4d783          	lhu	a5,74(s1)
    80004456:	2785                	addiw	a5,a5,1
    80004458:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    8000445c:	8526                	mv	a0,s1
    8000445e:	bf4fe0ef          	jal	80002852 <iupdate>
  iunlock(ip);
    80004462:	8526                	mv	a0,s1
    80004464:	d50fe0ef          	jal	800029b4 <iunlock>
  if((dp = nameiparent(new, name)) == 0)
    80004468:	fd040593          	addi	a1,s0,-48
    8000446c:	f5040513          	addi	a0,s0,-176
    80004470:	cdffe0ef          	jal	8000314e <nameiparent>
    80004474:	892a                	mv	s2,a0
    80004476:	cd21                	beqz	a0,800044ce <sys_link+0xce>
  ilock(dp);
    80004478:	c8efe0ef          	jal	80002906 <ilock>
  if(dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0){
    8000447c:	854a                	mv	a0,s2
    8000447e:	00092703          	lw	a4,0(s2)
    80004482:	409c                	lw	a5,0(s1)
    80004484:	04f71263          	bne	a4,a5,800044c8 <sys_link+0xc8>
    80004488:	40d0                	lw	a2,4(s1)
    8000448a:	fd040593          	addi	a1,s0,-48
    8000448e:	bfdfe0ef          	jal	8000308a <dirlink>
    80004492:	02054b63          	bltz	a0,800044c8 <sys_link+0xc8>
  iunlockput(dp);
    80004496:	854a                	mv	a0,s2
    80004498:	e7afe0ef          	jal	80002b12 <iunlockput>
  iput(ip);
    8000449c:	8526                	mv	a0,s1
    8000449e:	deafe0ef          	jal	80002a88 <iput>
  end_op();
    800044a2:	ee1fe0ef          	jal	80003382 <end_op>
  return 0;
    800044a6:	4781                	li	a5,0
    800044a8:	64f2                	ld	s1,280(sp)
    800044aa:	6952                	ld	s2,272(sp)
    800044ac:	a0a1                	j	800044f4 <sys_link+0xf4>
    end_op();
    800044ae:	ed5fe0ef          	jal	80003382 <end_op>
    return -1;
    800044b2:	57fd                	li	a5,-1
    800044b4:	64f2                	ld	s1,280(sp)
    800044b6:	a83d                	j	800044f4 <sys_link+0xf4>
    iunlockput(ip);
    800044b8:	8526                	mv	a0,s1
    800044ba:	e58fe0ef          	jal	80002b12 <iunlockput>
    end_op();
    800044be:	ec5fe0ef          	jal	80003382 <end_op>
    return -1;
    800044c2:	57fd                	li	a5,-1
    800044c4:	64f2                	ld	s1,280(sp)
    800044c6:	a03d                	j	800044f4 <sys_link+0xf4>
    iunlockput(dp);
    800044c8:	854a                	mv	a0,s2
    800044ca:	e48fe0ef          	jal	80002b12 <iunlockput>
  ilock(ip);
    800044ce:	8526                	mv	a0,s1
    800044d0:	c36fe0ef          	jal	80002906 <ilock>
  ip->nlink--;
    800044d4:	04a4d783          	lhu	a5,74(s1)
    800044d8:	37fd                	addiw	a5,a5,-1
    800044da:	04f49523          	sh	a5,74(s1)
  iupdate(ip);
    800044de:	8526                	mv	a0,s1
    800044e0:	b72fe0ef          	jal	80002852 <iupdate>
  iunlockput(ip);
    800044e4:	8526                	mv	a0,s1
    800044e6:	e2cfe0ef          	jal	80002b12 <iunlockput>
  end_op();
    800044ea:	e99fe0ef          	jal	80003382 <end_op>
  return -1;
    800044ee:	57fd                	li	a5,-1
    800044f0:	64f2                	ld	s1,280(sp)
    800044f2:	6952                	ld	s2,272(sp)
}
    800044f4:	853e                	mv	a0,a5
    800044f6:	70b2                	ld	ra,296(sp)
    800044f8:	7412                	ld	s0,288(sp)
    800044fa:	6155                	addi	sp,sp,304
    800044fc:	8082                	ret

00000000800044fe <sys_unlink>:
{
    800044fe:	7151                	addi	sp,sp,-240
    80004500:	f586                	sd	ra,232(sp)
    80004502:	f1a2                	sd	s0,224(sp)
    80004504:	1980                	addi	s0,sp,240
  if(argstr(0, path, MAXPATH) < 0)
    80004506:	08000613          	li	a2,128
    8000450a:	f3040593          	addi	a1,s0,-208
    8000450e:	4501                	li	a0,0
    80004510:	a71fd0ef          	jal	80001f80 <argstr>
    80004514:	14054d63          	bltz	a0,8000466e <sys_unlink+0x170>
    80004518:	eda6                	sd	s1,216(sp)
  begin_op();
    8000451a:	df9fe0ef          	jal	80003312 <begin_op>
  if((dp = nameiparent(path, name)) == 0){
    8000451e:	fb040593          	addi	a1,s0,-80
    80004522:	f3040513          	addi	a0,s0,-208
    80004526:	c29fe0ef          	jal	8000314e <nameiparent>
    8000452a:	84aa                	mv	s1,a0
    8000452c:	c955                	beqz	a0,800045e0 <sys_unlink+0xe2>
  ilock(dp);
    8000452e:	bd8fe0ef          	jal	80002906 <ilock>
  if(namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004532:	00003597          	auipc	a1,0x3
    80004536:	09e58593          	addi	a1,a1,158 # 800075d0 <etext+0x5d0>
    8000453a:	fb040513          	addi	a0,s0,-80
    8000453e:	94dfe0ef          	jal	80002e8a <namecmp>
    80004542:	10050b63          	beqz	a0,80004658 <sys_unlink+0x15a>
    80004546:	00003597          	auipc	a1,0x3
    8000454a:	09258593          	addi	a1,a1,146 # 800075d8 <etext+0x5d8>
    8000454e:	fb040513          	addi	a0,s0,-80
    80004552:	939fe0ef          	jal	80002e8a <namecmp>
    80004556:	10050163          	beqz	a0,80004658 <sys_unlink+0x15a>
    8000455a:	e9ca                	sd	s2,208(sp)
  if((ip = dirlookup(dp, name, &off)) == 0)
    8000455c:	f2c40613          	addi	a2,s0,-212
    80004560:	fb040593          	addi	a1,s0,-80
    80004564:	8526                	mv	a0,s1
    80004566:	93bfe0ef          	jal	80002ea0 <dirlookup>
    8000456a:	892a                	mv	s2,a0
    8000456c:	0e050563          	beqz	a0,80004656 <sys_unlink+0x158>
    80004570:	e5ce                	sd	s3,200(sp)
  ilock(ip);
    80004572:	b94fe0ef          	jal	80002906 <ilock>
  if(ip->nlink < 1)
    80004576:	04a91783          	lh	a5,74(s2)
    8000457a:	06f05863          	blez	a5,800045ea <sys_unlink+0xec>
  if(ip->type == T_DIR && !isdirempty(ip)){
    8000457e:	04491703          	lh	a4,68(s2)
    80004582:	4785                	li	a5,1
    80004584:	06f70963          	beq	a4,a5,800045f6 <sys_unlink+0xf8>
  memset(&de, 0, sizeof(de));
    80004588:	fc040993          	addi	s3,s0,-64
    8000458c:	4641                	li	a2,16
    8000458e:	4581                	li	a1,0
    80004590:	854e                	mv	a0,s3
    80004592:	d13fb0ef          	jal	800002a4 <memset>
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004596:	4741                	li	a4,16
    80004598:	f2c42683          	lw	a3,-212(s0)
    8000459c:	864e                	mv	a2,s3
    8000459e:	4581                	li	a1,0
    800045a0:	8526                	mv	a0,s1
    800045a2:	fe8fe0ef          	jal	80002d8a <writei>
    800045a6:	47c1                	li	a5,16
    800045a8:	08f51863          	bne	a0,a5,80004638 <sys_unlink+0x13a>
  if(ip->type == T_DIR){
    800045ac:	04491703          	lh	a4,68(s2)
    800045b0:	4785                	li	a5,1
    800045b2:	08f70963          	beq	a4,a5,80004644 <sys_unlink+0x146>
  iunlockput(dp);
    800045b6:	8526                	mv	a0,s1
    800045b8:	d5afe0ef          	jal	80002b12 <iunlockput>
  ip->nlink--;
    800045bc:	04a95783          	lhu	a5,74(s2)
    800045c0:	37fd                	addiw	a5,a5,-1
    800045c2:	04f91523          	sh	a5,74(s2)
  iupdate(ip);
    800045c6:	854a                	mv	a0,s2
    800045c8:	a8afe0ef          	jal	80002852 <iupdate>
  iunlockput(ip);
    800045cc:	854a                	mv	a0,s2
    800045ce:	d44fe0ef          	jal	80002b12 <iunlockput>
  end_op();
    800045d2:	db1fe0ef          	jal	80003382 <end_op>
  return 0;
    800045d6:	4501                	li	a0,0
    800045d8:	64ee                	ld	s1,216(sp)
    800045da:	694e                	ld	s2,208(sp)
    800045dc:	69ae                	ld	s3,200(sp)
    800045de:	a061                	j	80004666 <sys_unlink+0x168>
    end_op();
    800045e0:	da3fe0ef          	jal	80003382 <end_op>
    return -1;
    800045e4:	557d                	li	a0,-1
    800045e6:	64ee                	ld	s1,216(sp)
    800045e8:	a8bd                	j	80004666 <sys_unlink+0x168>
    panic("unlink: nlink < 1");
    800045ea:	00003517          	auipc	a0,0x3
    800045ee:	ff650513          	addi	a0,a0,-10 # 800075e0 <etext+0x5e0>
    800045f2:	376010ef          	jal	80005968 <panic>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    800045f6:	04c92703          	lw	a4,76(s2)
    800045fa:	02000793          	li	a5,32
    800045fe:	f8e7f5e3          	bgeu	a5,a4,80004588 <sys_unlink+0x8a>
    80004602:	89be                	mv	s3,a5
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004604:	4741                	li	a4,16
    80004606:	86ce                	mv	a3,s3
    80004608:	f1840613          	addi	a2,s0,-232
    8000460c:	4581                	li	a1,0
    8000460e:	854a                	mv	a0,s2
    80004610:	e88fe0ef          	jal	80002c98 <readi>
    80004614:	47c1                	li	a5,16
    80004616:	00f51b63          	bne	a0,a5,8000462c <sys_unlink+0x12e>
    if(de.inum != 0)
    8000461a:	f1845783          	lhu	a5,-232(s0)
    8000461e:	ebb1                	bnez	a5,80004672 <sys_unlink+0x174>
  for(off=2*sizeof(de); off<dp->size; off+=sizeof(de)){
    80004620:	29c1                	addiw	s3,s3,16
    80004622:	04c92783          	lw	a5,76(s2)
    80004626:	fcf9efe3          	bltu	s3,a5,80004604 <sys_unlink+0x106>
    8000462a:	bfb9                	j	80004588 <sys_unlink+0x8a>
      panic("isdirempty: readi");
    8000462c:	00003517          	auipc	a0,0x3
    80004630:	fcc50513          	addi	a0,a0,-52 # 800075f8 <etext+0x5f8>
    80004634:	334010ef          	jal	80005968 <panic>
    panic("unlink: writei");
    80004638:	00003517          	auipc	a0,0x3
    8000463c:	fd850513          	addi	a0,a0,-40 # 80007610 <etext+0x610>
    80004640:	328010ef          	jal	80005968 <panic>
    dp->nlink--;
    80004644:	04a4d783          	lhu	a5,74(s1)
    80004648:	37fd                	addiw	a5,a5,-1
    8000464a:	04f49523          	sh	a5,74(s1)
    iupdate(dp);
    8000464e:	8526                	mv	a0,s1
    80004650:	a02fe0ef          	jal	80002852 <iupdate>
    80004654:	b78d                	j	800045b6 <sys_unlink+0xb8>
    80004656:	694e                	ld	s2,208(sp)
  iunlockput(dp);
    80004658:	8526                	mv	a0,s1
    8000465a:	cb8fe0ef          	jal	80002b12 <iunlockput>
  end_op();
    8000465e:	d25fe0ef          	jal	80003382 <end_op>
  return -1;
    80004662:	557d                	li	a0,-1
    80004664:	64ee                	ld	s1,216(sp)
}
    80004666:	70ae                	ld	ra,232(sp)
    80004668:	740e                	ld	s0,224(sp)
    8000466a:	616d                	addi	sp,sp,240
    8000466c:	8082                	ret
    return -1;
    8000466e:	557d                	li	a0,-1
    80004670:	bfdd                	j	80004666 <sys_unlink+0x168>
    iunlockput(ip);
    80004672:	854a                	mv	a0,s2
    80004674:	c9efe0ef          	jal	80002b12 <iunlockput>
    goto bad;
    80004678:	694e                	ld	s2,208(sp)
    8000467a:	69ae                	ld	s3,200(sp)
    8000467c:	bff1                	j	80004658 <sys_unlink+0x15a>

000000008000467e <sys_open>:

uint64
sys_open(void)
{
    8000467e:	7131                	addi	sp,sp,-192
    80004680:	fd06                	sd	ra,184(sp)
    80004682:	f922                	sd	s0,176(sp)
    80004684:	0180                	addi	s0,sp,192
  int fd, omode;
  struct file *f;
  struct inode *ip;
  int n;

  argint(1, &omode);
    80004686:	f4c40593          	addi	a1,s0,-180
    8000468a:	4505                	li	a0,1
    8000468c:	8bdfd0ef          	jal	80001f48 <argint>
  if((n = argstr(0, path, MAXPATH)) < 0)
    80004690:	08000613          	li	a2,128
    80004694:	f5040593          	addi	a1,s0,-176
    80004698:	4501                	li	a0,0
    8000469a:	8e7fd0ef          	jal	80001f80 <argstr>
    8000469e:	87aa                	mv	a5,a0
    return -1;
    800046a0:	557d                	li	a0,-1
  if((n = argstr(0, path, MAXPATH)) < 0)
    800046a2:	0a07c363          	bltz	a5,80004748 <sys_open+0xca>
    800046a6:	f526                	sd	s1,168(sp)

  begin_op();
    800046a8:	c6bfe0ef          	jal	80003312 <begin_op>

  if(omode & O_CREATE){
    800046ac:	f4c42783          	lw	a5,-180(s0)
    800046b0:	2007f793          	andi	a5,a5,512
    800046b4:	c3dd                	beqz	a5,8000475a <sys_open+0xdc>
    ip = create(path, T_FILE, 0, 0);
    800046b6:	4681                	li	a3,0
    800046b8:	4601                	li	a2,0
    800046ba:	4589                	li	a1,2
    800046bc:	f5040513          	addi	a0,s0,-176
    800046c0:	aafff0ef          	jal	8000416e <create>
    800046c4:	84aa                	mv	s1,a0
    if(ip == 0){
    800046c6:	c549                	beqz	a0,80004750 <sys_open+0xd2>
      end_op();
      return -1;
    }
  }

  if(ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV)){
    800046c8:	04449703          	lh	a4,68(s1)
    800046cc:	478d                	li	a5,3
    800046ce:	00f71763          	bne	a4,a5,800046dc <sys_open+0x5e>
    800046d2:	0464d703          	lhu	a4,70(s1)
    800046d6:	47a5                	li	a5,9
    800046d8:	0ae7ee63          	bltu	a5,a4,80004794 <sys_open+0x116>
    800046dc:	f14a                	sd	s2,160(sp)
    iunlockput(ip);
    end_op();
    return -1;
  }

  if((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0){
    800046de:	fb5fe0ef          	jal	80003692 <filealloc>
    800046e2:	892a                	mv	s2,a0
    800046e4:	c561                	beqz	a0,800047ac <sys_open+0x12e>
    800046e6:	ed4e                	sd	s3,152(sp)
    800046e8:	a47ff0ef          	jal	8000412e <fdalloc>
    800046ec:	89aa                	mv	s3,a0
    800046ee:	0a054b63          	bltz	a0,800047a4 <sys_open+0x126>
    iunlockput(ip);
    end_op();
    return -1;
  }

  if(ip->type == T_DEVICE){
    800046f2:	04449703          	lh	a4,68(s1)
    800046f6:	478d                	li	a5,3
    800046f8:	0cf70363          	beq	a4,a5,800047be <sys_open+0x140>
    f->type = FD_DEVICE;
    f->major = ip->major;
  } else {
    f->type = FD_INODE;
    800046fc:	4789                	li	a5,2
    800046fe:	00f92023          	sw	a5,0(s2)
    f->off = 0;
    80004702:	02092023          	sw	zero,32(s2)
  }
  f->ip = ip;
    80004706:	00993c23          	sd	s1,24(s2)
  f->readable = !(omode & O_WRONLY);
    8000470a:	f4c42783          	lw	a5,-180(s0)
    8000470e:	0017f713          	andi	a4,a5,1
    80004712:	00174713          	xori	a4,a4,1
    80004716:	00e90423          	sb	a4,8(s2)
  f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    8000471a:	0037f713          	andi	a4,a5,3
    8000471e:	00e03733          	snez	a4,a4
    80004722:	00e904a3          	sb	a4,9(s2)

  if((omode & O_TRUNC) && ip->type == T_FILE){
    80004726:	4007f793          	andi	a5,a5,1024
    8000472a:	c791                	beqz	a5,80004736 <sys_open+0xb8>
    8000472c:	04449703          	lh	a4,68(s1)
    80004730:	4789                	li	a5,2
    80004732:	08f70d63          	beq	a4,a5,800047cc <sys_open+0x14e>
    itrunc(ip);
  }

  iunlock(ip);
    80004736:	8526                	mv	a0,s1
    80004738:	a7cfe0ef          	jal	800029b4 <iunlock>
  end_op();
    8000473c:	c47fe0ef          	jal	80003382 <end_op>

  return fd;
    80004740:	854e                	mv	a0,s3
    80004742:	74aa                	ld	s1,168(sp)
    80004744:	790a                	ld	s2,160(sp)
    80004746:	69ea                	ld	s3,152(sp)
}
    80004748:	70ea                	ld	ra,184(sp)
    8000474a:	744a                	ld	s0,176(sp)
    8000474c:	6129                	addi	sp,sp,192
    8000474e:	8082                	ret
      end_op();
    80004750:	c33fe0ef          	jal	80003382 <end_op>
      return -1;
    80004754:	557d                	li	a0,-1
    80004756:	74aa                	ld	s1,168(sp)
    80004758:	bfc5                	j	80004748 <sys_open+0xca>
    if((ip = namei(path)) == 0){
    8000475a:	f5040513          	addi	a0,s0,-176
    8000475e:	9d7fe0ef          	jal	80003134 <namei>
    80004762:	84aa                	mv	s1,a0
    80004764:	c11d                	beqz	a0,8000478a <sys_open+0x10c>
    ilock(ip);
    80004766:	9a0fe0ef          	jal	80002906 <ilock>
    if(ip->type == T_DIR && omode != O_RDONLY){
    8000476a:	04449703          	lh	a4,68(s1)
    8000476e:	4785                	li	a5,1
    80004770:	f4f71ce3          	bne	a4,a5,800046c8 <sys_open+0x4a>
    80004774:	f4c42783          	lw	a5,-180(s0)
    80004778:	d3b5                	beqz	a5,800046dc <sys_open+0x5e>
      iunlockput(ip);
    8000477a:	8526                	mv	a0,s1
    8000477c:	b96fe0ef          	jal	80002b12 <iunlockput>
      end_op();
    80004780:	c03fe0ef          	jal	80003382 <end_op>
      return -1;
    80004784:	557d                	li	a0,-1
    80004786:	74aa                	ld	s1,168(sp)
    80004788:	b7c1                	j	80004748 <sys_open+0xca>
      end_op();
    8000478a:	bf9fe0ef          	jal	80003382 <end_op>
      return -1;
    8000478e:	557d                	li	a0,-1
    80004790:	74aa                	ld	s1,168(sp)
    80004792:	bf5d                	j	80004748 <sys_open+0xca>
    iunlockput(ip);
    80004794:	8526                	mv	a0,s1
    80004796:	b7cfe0ef          	jal	80002b12 <iunlockput>
    end_op();
    8000479a:	be9fe0ef          	jal	80003382 <end_op>
    return -1;
    8000479e:	557d                	li	a0,-1
    800047a0:	74aa                	ld	s1,168(sp)
    800047a2:	b75d                	j	80004748 <sys_open+0xca>
      fileclose(f);
    800047a4:	854a                	mv	a0,s2
    800047a6:	f91fe0ef          	jal	80003736 <fileclose>
    800047aa:	69ea                	ld	s3,152(sp)
    iunlockput(ip);
    800047ac:	8526                	mv	a0,s1
    800047ae:	b64fe0ef          	jal	80002b12 <iunlockput>
    end_op();
    800047b2:	bd1fe0ef          	jal	80003382 <end_op>
    return -1;
    800047b6:	557d                	li	a0,-1
    800047b8:	74aa                	ld	s1,168(sp)
    800047ba:	790a                	ld	s2,160(sp)
    800047bc:	b771                	j	80004748 <sys_open+0xca>
    f->type = FD_DEVICE;
    800047be:	00e92023          	sw	a4,0(s2)
    f->major = ip->major;
    800047c2:	04649783          	lh	a5,70(s1)
    800047c6:	02f91223          	sh	a5,36(s2)
    800047ca:	bf35                	j	80004706 <sys_open+0x88>
    itrunc(ip);
    800047cc:	8526                	mv	a0,s1
    800047ce:	a26fe0ef          	jal	800029f4 <itrunc>
    800047d2:	b795                	j	80004736 <sys_open+0xb8>

00000000800047d4 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800047d4:	7175                	addi	sp,sp,-144
    800047d6:	e506                	sd	ra,136(sp)
    800047d8:	e122                	sd	s0,128(sp)
    800047da:	0900                	addi	s0,sp,144
  char path[MAXPATH];
  struct inode *ip;

  begin_op();
    800047dc:	b37fe0ef          	jal	80003312 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0){
    800047e0:	08000613          	li	a2,128
    800047e4:	f7040593          	addi	a1,s0,-144
    800047e8:	4501                	li	a0,0
    800047ea:	f96fd0ef          	jal	80001f80 <argstr>
    800047ee:	02054363          	bltz	a0,80004814 <sys_mkdir+0x40>
    800047f2:	4681                	li	a3,0
    800047f4:	4601                	li	a2,0
    800047f6:	4585                	li	a1,1
    800047f8:	f7040513          	addi	a0,s0,-144
    800047fc:	973ff0ef          	jal	8000416e <create>
    80004800:	c911                	beqz	a0,80004814 <sys_mkdir+0x40>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004802:	b10fe0ef          	jal	80002b12 <iunlockput>
  end_op();
    80004806:	b7dfe0ef          	jal	80003382 <end_op>
  return 0;
    8000480a:	4501                	li	a0,0
}
    8000480c:	60aa                	ld	ra,136(sp)
    8000480e:	640a                	ld	s0,128(sp)
    80004810:	6149                	addi	sp,sp,144
    80004812:	8082                	ret
    end_op();
    80004814:	b6ffe0ef          	jal	80003382 <end_op>
    return -1;
    80004818:	557d                	li	a0,-1
    8000481a:	bfcd                	j	8000480c <sys_mkdir+0x38>

000000008000481c <sys_mknod>:

uint64
sys_mknod(void)
{
    8000481c:	7135                	addi	sp,sp,-160
    8000481e:	ed06                	sd	ra,152(sp)
    80004820:	e922                	sd	s0,144(sp)
    80004822:	1100                	addi	s0,sp,160
  struct inode *ip;
  char path[MAXPATH];
  int major, minor;

  begin_op();
    80004824:	aeffe0ef          	jal	80003312 <begin_op>
  argint(1, &major);
    80004828:	f6c40593          	addi	a1,s0,-148
    8000482c:	4505                	li	a0,1
    8000482e:	f1afd0ef          	jal	80001f48 <argint>
  argint(2, &minor);
    80004832:	f6840593          	addi	a1,s0,-152
    80004836:	4509                	li	a0,2
    80004838:	f10fd0ef          	jal	80001f48 <argint>
  if((argstr(0, path, MAXPATH)) < 0 ||
    8000483c:	08000613          	li	a2,128
    80004840:	f7040593          	addi	a1,s0,-144
    80004844:	4501                	li	a0,0
    80004846:	f3afd0ef          	jal	80001f80 <argstr>
    8000484a:	02054563          	bltz	a0,80004874 <sys_mknod+0x58>
     (ip = create(path, T_DEVICE, major, minor)) == 0){
    8000484e:	f6841683          	lh	a3,-152(s0)
    80004852:	f6c41603          	lh	a2,-148(s0)
    80004856:	458d                	li	a1,3
    80004858:	f7040513          	addi	a0,s0,-144
    8000485c:	913ff0ef          	jal	8000416e <create>
  if((argstr(0, path, MAXPATH)) < 0 ||
    80004860:	c911                	beqz	a0,80004874 <sys_mknod+0x58>
    end_op();
    return -1;
  }
  iunlockput(ip);
    80004862:	ab0fe0ef          	jal	80002b12 <iunlockput>
  end_op();
    80004866:	b1dfe0ef          	jal	80003382 <end_op>
  return 0;
    8000486a:	4501                	li	a0,0
}
    8000486c:	60ea                	ld	ra,152(sp)
    8000486e:	644a                	ld	s0,144(sp)
    80004870:	610d                	addi	sp,sp,160
    80004872:	8082                	ret
    end_op();
    80004874:	b0ffe0ef          	jal	80003382 <end_op>
    return -1;
    80004878:	557d                	li	a0,-1
    8000487a:	bfcd                	j	8000486c <sys_mknod+0x50>

000000008000487c <sys_chdir>:

uint64
sys_chdir(void)
{
    8000487c:	7135                	addi	sp,sp,-160
    8000487e:	ed06                	sd	ra,152(sp)
    80004880:	e922                	sd	s0,144(sp)
    80004882:	e14a                	sd	s2,128(sp)
    80004884:	1100                	addi	s0,sp,160
  char path[MAXPATH];
  struct inode *ip;
  struct proc *p = myproc();
    80004886:	fa8fc0ef          	jal	8000102e <myproc>
    8000488a:	892a                	mv	s2,a0
  
  begin_op();
    8000488c:	a87fe0ef          	jal	80003312 <begin_op>
  if(argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0){
    80004890:	08000613          	li	a2,128
    80004894:	f6040593          	addi	a1,s0,-160
    80004898:	4501                	li	a0,0
    8000489a:	ee6fd0ef          	jal	80001f80 <argstr>
    8000489e:	04054363          	bltz	a0,800048e4 <sys_chdir+0x68>
    800048a2:	e526                	sd	s1,136(sp)
    800048a4:	f6040513          	addi	a0,s0,-160
    800048a8:	88dfe0ef          	jal	80003134 <namei>
    800048ac:	84aa                	mv	s1,a0
    800048ae:	c915                	beqz	a0,800048e2 <sys_chdir+0x66>
    end_op();
    return -1;
  }
  ilock(ip);
    800048b0:	856fe0ef          	jal	80002906 <ilock>
  if(ip->type != T_DIR){
    800048b4:	04449703          	lh	a4,68(s1)
    800048b8:	4785                	li	a5,1
    800048ba:	02f71963          	bne	a4,a5,800048ec <sys_chdir+0x70>
    iunlockput(ip);
    end_op();
    return -1;
  }
  iunlock(ip);
    800048be:	8526                	mv	a0,s1
    800048c0:	8f4fe0ef          	jal	800029b4 <iunlock>
  iput(p->cwd);
    800048c4:	15093503          	ld	a0,336(s2)
    800048c8:	9c0fe0ef          	jal	80002a88 <iput>
  end_op();
    800048cc:	ab7fe0ef          	jal	80003382 <end_op>
  p->cwd = ip;
    800048d0:	14993823          	sd	s1,336(s2)
  return 0;
    800048d4:	4501                	li	a0,0
    800048d6:	64aa                	ld	s1,136(sp)
}
    800048d8:	60ea                	ld	ra,152(sp)
    800048da:	644a                	ld	s0,144(sp)
    800048dc:	690a                	ld	s2,128(sp)
    800048de:	610d                	addi	sp,sp,160
    800048e0:	8082                	ret
    800048e2:	64aa                	ld	s1,136(sp)
    end_op();
    800048e4:	a9ffe0ef          	jal	80003382 <end_op>
    return -1;
    800048e8:	557d                	li	a0,-1
    800048ea:	b7fd                	j	800048d8 <sys_chdir+0x5c>
    iunlockput(ip);
    800048ec:	8526                	mv	a0,s1
    800048ee:	a24fe0ef          	jal	80002b12 <iunlockput>
    end_op();
    800048f2:	a91fe0ef          	jal	80003382 <end_op>
    return -1;
    800048f6:	557d                	li	a0,-1
    800048f8:	64aa                	ld	s1,136(sp)
    800048fa:	bff9                	j	800048d8 <sys_chdir+0x5c>

00000000800048fc <sys_exec>:

uint64
sys_exec(void)
{
    800048fc:	7105                	addi	sp,sp,-480
    800048fe:	ef86                	sd	ra,472(sp)
    80004900:	eba2                	sd	s0,464(sp)
    80004902:	1380                	addi	s0,sp,480
  char path[MAXPATH], *argv[MAXARG];
  int i;
  uint64 uargv, uarg;

  argaddr(1, &uargv);
    80004904:	e2840593          	addi	a1,s0,-472
    80004908:	4505                	li	a0,1
    8000490a:	e5afd0ef          	jal	80001f64 <argaddr>
  if(argstr(0, path, MAXPATH) < 0) {
    8000490e:	08000613          	li	a2,128
    80004912:	f3040593          	addi	a1,s0,-208
    80004916:	4501                	li	a0,0
    80004918:	e68fd0ef          	jal	80001f80 <argstr>
    8000491c:	87aa                	mv	a5,a0
    return -1;
    8000491e:	557d                	li	a0,-1
  if(argstr(0, path, MAXPATH) < 0) {
    80004920:	0e07c063          	bltz	a5,80004a00 <sys_exec+0x104>
    80004924:	e7a6                	sd	s1,456(sp)
    80004926:	e3ca                	sd	s2,448(sp)
    80004928:	ff4e                	sd	s3,440(sp)
    8000492a:	fb52                	sd	s4,432(sp)
    8000492c:	f756                	sd	s5,424(sp)
    8000492e:	f35a                	sd	s6,416(sp)
    80004930:	ef5e                	sd	s7,408(sp)
  }
  memset(argv, 0, sizeof(argv));
    80004932:	e3040a13          	addi	s4,s0,-464
    80004936:	10000613          	li	a2,256
    8000493a:	4581                	li	a1,0
    8000493c:	8552                	mv	a0,s4
    8000493e:	967fb0ef          	jal	800002a4 <memset>
  for(i=0;; i++){
    if(i >= NELEM(argv)){
    80004942:	84d2                	mv	s1,s4
  memset(argv, 0, sizeof(argv));
    80004944:	89d2                	mv	s3,s4
    80004946:	4901                	li	s2,0
      goto bad;
    }
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004948:	e2040a93          	addi	s5,s0,-480
      break;
    }
    argv[i] = kalloc();
    if(argv[i] == 0)
      goto bad;
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000494c:	6b05                	lui	s6,0x1
    if(i >= NELEM(argv)){
    8000494e:	02000b93          	li	s7,32
    if(fetchaddr(uargv+sizeof(uint64)*i, (uint64*)&uarg) < 0){
    80004952:	00391513          	slli	a0,s2,0x3
    80004956:	85d6                	mv	a1,s5
    80004958:	e2843783          	ld	a5,-472(s0)
    8000495c:	953e                	add	a0,a0,a5
    8000495e:	d60fd0ef          	jal	80001ebe <fetchaddr>
    80004962:	02054663          	bltz	a0,8000498e <sys_exec+0x92>
    if(uarg == 0){
    80004966:	e2043783          	ld	a5,-480(s0)
    8000496a:	c7a1                	beqz	a5,800049b2 <sys_exec+0xb6>
    argv[i] = kalloc();
    8000496c:	82bfb0ef          	jal	80000196 <kalloc>
    80004970:	85aa                	mv	a1,a0
    80004972:	00a9b023          	sd	a0,0(s3)
    if(argv[i] == 0)
    80004976:	cd01                	beqz	a0,8000498e <sys_exec+0x92>
    if(fetchstr(uarg, argv[i], PGSIZE) < 0)
    80004978:	865a                	mv	a2,s6
    8000497a:	e2043503          	ld	a0,-480(s0)
    8000497e:	d8afd0ef          	jal	80001f08 <fetchstr>
    80004982:	00054663          	bltz	a0,8000498e <sys_exec+0x92>
    if(i >= NELEM(argv)){
    80004986:	0905                	addi	s2,s2,1
    80004988:	09a1                	addi	s3,s3,8
    8000498a:	fd7914e3          	bne	s2,s7,80004952 <sys_exec+0x56>
    kfree(argv[i]);

  return ret;

 bad:
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000498e:	100a0a13          	addi	s4,s4,256
    80004992:	6088                	ld	a0,0(s1)
    80004994:	cd31                	beqz	a0,800049f0 <sys_exec+0xf4>
    kfree(argv[i]);
    80004996:	e86fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000499a:	04a1                	addi	s1,s1,8
    8000499c:	ff449be3          	bne	s1,s4,80004992 <sys_exec+0x96>
  return -1;
    800049a0:	557d                	li	a0,-1
    800049a2:	64be                	ld	s1,456(sp)
    800049a4:	691e                	ld	s2,448(sp)
    800049a6:	79fa                	ld	s3,440(sp)
    800049a8:	7a5a                	ld	s4,432(sp)
    800049aa:	7aba                	ld	s5,424(sp)
    800049ac:	7b1a                	ld	s6,416(sp)
    800049ae:	6bfa                	ld	s7,408(sp)
    800049b0:	a881                	j	80004a00 <sys_exec+0x104>
      argv[i] = 0;
    800049b2:	0009079b          	sext.w	a5,s2
    800049b6:	e3040593          	addi	a1,s0,-464
    800049ba:	078e                	slli	a5,a5,0x3
    800049bc:	97ae                	add	a5,a5,a1
    800049be:	0007b023          	sd	zero,0(a5)
  int ret = kexec(path, argv);
    800049c2:	f3040513          	addi	a0,s0,-208
    800049c6:	bb2ff0ef          	jal	80003d78 <kexec>
    800049ca:	892a                	mv	s2,a0
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800049cc:	100a0a13          	addi	s4,s4,256
    800049d0:	6088                	ld	a0,0(s1)
    800049d2:	c511                	beqz	a0,800049de <sys_exec+0xe2>
    kfree(argv[i]);
    800049d4:	e48fb0ef          	jal	8000001c <kfree>
  for(i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800049d8:	04a1                	addi	s1,s1,8
    800049da:	ff449be3          	bne	s1,s4,800049d0 <sys_exec+0xd4>
  return ret;
    800049de:	854a                	mv	a0,s2
    800049e0:	64be                	ld	s1,456(sp)
    800049e2:	691e                	ld	s2,448(sp)
    800049e4:	79fa                	ld	s3,440(sp)
    800049e6:	7a5a                	ld	s4,432(sp)
    800049e8:	7aba                	ld	s5,424(sp)
    800049ea:	7b1a                	ld	s6,416(sp)
    800049ec:	6bfa                	ld	s7,408(sp)
    800049ee:	a809                	j	80004a00 <sys_exec+0x104>
  return -1;
    800049f0:	557d                	li	a0,-1
    800049f2:	64be                	ld	s1,456(sp)
    800049f4:	691e                	ld	s2,448(sp)
    800049f6:	79fa                	ld	s3,440(sp)
    800049f8:	7a5a                	ld	s4,432(sp)
    800049fa:	7aba                	ld	s5,424(sp)
    800049fc:	7b1a                	ld	s6,416(sp)
    800049fe:	6bfa                	ld	s7,408(sp)
}
    80004a00:	60fe                	ld	ra,472(sp)
    80004a02:	645e                	ld	s0,464(sp)
    80004a04:	613d                	addi	sp,sp,480
    80004a06:	8082                	ret

0000000080004a08 <sys_pipe>:

uint64
sys_pipe(void)
{
    80004a08:	7139                	addi	sp,sp,-64
    80004a0a:	fc06                	sd	ra,56(sp)
    80004a0c:	f822                	sd	s0,48(sp)
    80004a0e:	f426                	sd	s1,40(sp)
    80004a10:	0080                	addi	s0,sp,64
  uint64 fdarray; // user pointer to array of two integers
  struct file *rf, *wf;
  int fd0, fd1;
  struct proc *p = myproc();
    80004a12:	e1cfc0ef          	jal	8000102e <myproc>
    80004a16:	84aa                	mv	s1,a0

  argaddr(0, &fdarray);
    80004a18:	fd840593          	addi	a1,s0,-40
    80004a1c:	4501                	li	a0,0
    80004a1e:	d46fd0ef          	jal	80001f64 <argaddr>
  if(pipealloc(&rf, &wf) < 0)
    80004a22:	fc840593          	addi	a1,s0,-56
    80004a26:	fd040513          	addi	a0,s0,-48
    80004a2a:	828ff0ef          	jal	80003a52 <pipealloc>
    return -1;
    80004a2e:	57fd                	li	a5,-1
  if(pipealloc(&rf, &wf) < 0)
    80004a30:	0a054763          	bltz	a0,80004ade <sys_pipe+0xd6>
  fd0 = -1;
    80004a34:	fcf42223          	sw	a5,-60(s0)
  if((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0){
    80004a38:	fd043503          	ld	a0,-48(s0)
    80004a3c:	ef2ff0ef          	jal	8000412e <fdalloc>
    80004a40:	fca42223          	sw	a0,-60(s0)
    80004a44:	08054463          	bltz	a0,80004acc <sys_pipe+0xc4>
    80004a48:	fc843503          	ld	a0,-56(s0)
    80004a4c:	ee2ff0ef          	jal	8000412e <fdalloc>
    80004a50:	fca42023          	sw	a0,-64(s0)
    80004a54:	06054263          	bltz	a0,80004ab8 <sys_pipe+0xb0>
      p->ofile[fd0] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a58:	4691                	li	a3,4
    80004a5a:	fc440613          	addi	a2,s0,-60
    80004a5e:	fd843583          	ld	a1,-40(s0)
    80004a62:	68a8                	ld	a0,80(s1)
    80004a64:	ad2fc0ef          	jal	80000d36 <copyout>
    80004a68:	00054e63          	bltz	a0,80004a84 <sys_pipe+0x7c>
     copyout(p->pagetable, fdarray+sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0){
    80004a6c:	4691                	li	a3,4
    80004a6e:	fc040613          	addi	a2,s0,-64
    80004a72:	fd843583          	ld	a1,-40(s0)
    80004a76:	95b6                	add	a1,a1,a3
    80004a78:	68a8                	ld	a0,80(s1)
    80004a7a:	abcfc0ef          	jal	80000d36 <copyout>
    p->ofile[fd1] = 0;
    fileclose(rf);
    fileclose(wf);
    return -1;
  }
  return 0;
    80004a7e:	4781                	li	a5,0
  if(copyout(p->pagetable, fdarray, (char*)&fd0, sizeof(fd0)) < 0 ||
    80004a80:	04055f63          	bgez	a0,80004ade <sys_pipe+0xd6>
    p->ofile[fd0] = 0;
    80004a84:	fc442783          	lw	a5,-60(s0)
    80004a88:	078e                	slli	a5,a5,0x3
    80004a8a:	0d078793          	addi	a5,a5,208
    80004a8e:	97a6                	add	a5,a5,s1
    80004a90:	0007b023          	sd	zero,0(a5)
    p->ofile[fd1] = 0;
    80004a94:	fc042783          	lw	a5,-64(s0)
    80004a98:	078e                	slli	a5,a5,0x3
    80004a9a:	0d078793          	addi	a5,a5,208
    80004a9e:	97a6                	add	a5,a5,s1
    80004aa0:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004aa4:	fd043503          	ld	a0,-48(s0)
    80004aa8:	c8ffe0ef          	jal	80003736 <fileclose>
    fileclose(wf);
    80004aac:	fc843503          	ld	a0,-56(s0)
    80004ab0:	c87fe0ef          	jal	80003736 <fileclose>
    return -1;
    80004ab4:	57fd                	li	a5,-1
    80004ab6:	a025                	j	80004ade <sys_pipe+0xd6>
    if(fd0 >= 0)
    80004ab8:	fc442783          	lw	a5,-60(s0)
    80004abc:	0007c863          	bltz	a5,80004acc <sys_pipe+0xc4>
      p->ofile[fd0] = 0;
    80004ac0:	078e                	slli	a5,a5,0x3
    80004ac2:	0d078793          	addi	a5,a5,208
    80004ac6:	97a6                	add	a5,a5,s1
    80004ac8:	0007b023          	sd	zero,0(a5)
    fileclose(rf);
    80004acc:	fd043503          	ld	a0,-48(s0)
    80004ad0:	c67fe0ef          	jal	80003736 <fileclose>
    fileclose(wf);
    80004ad4:	fc843503          	ld	a0,-56(s0)
    80004ad8:	c5ffe0ef          	jal	80003736 <fileclose>
    return -1;
    80004adc:	57fd                	li	a5,-1
}
    80004ade:	853e                	mv	a0,a5
    80004ae0:	70e2                	ld	ra,56(sp)
    80004ae2:	7442                	ld	s0,48(sp)
    80004ae4:	74a2                	ld	s1,40(sp)
    80004ae6:	6121                	addi	sp,sp,64
    80004ae8:	8082                	ret
    80004aea:	0000                	unimp
    80004aec:	0000                	unimp
	...

0000000080004af0 <kernelvec>:
.globl kerneltrap
.globl kernelvec
.align 4
kernelvec:
        # make room to save registers.
        addi sp, sp, -256
    80004af0:	7111                	addi	sp,sp,-256

        # save caller-saved registers.
        sd ra, 0(sp)
    80004af2:	e006                	sd	ra,0(sp)
        # sd sp, 8(sp)
        sd gp, 16(sp)
    80004af4:	e80e                	sd	gp,16(sp)
        sd tp, 24(sp)
    80004af6:	ec12                	sd	tp,24(sp)
        sd t0, 32(sp)
    80004af8:	f016                	sd	t0,32(sp)
        sd t1, 40(sp)
    80004afa:	f41a                	sd	t1,40(sp)
        sd t2, 48(sp)
    80004afc:	f81e                	sd	t2,48(sp)
        sd a0, 72(sp)
    80004afe:	e4aa                	sd	a0,72(sp)
        sd a1, 80(sp)
    80004b00:	e8ae                	sd	a1,80(sp)
        sd a2, 88(sp)
    80004b02:	ecb2                	sd	a2,88(sp)
        sd a3, 96(sp)
    80004b04:	f0b6                	sd	a3,96(sp)
        sd a4, 104(sp)
    80004b06:	f4ba                	sd	a4,104(sp)
        sd a5, 112(sp)
    80004b08:	f8be                	sd	a5,112(sp)
        sd a6, 120(sp)
    80004b0a:	fcc2                	sd	a6,120(sp)
        sd a7, 128(sp)
    80004b0c:	e146                	sd	a7,128(sp)
        sd t3, 216(sp)
    80004b0e:	edf2                	sd	t3,216(sp)
        sd t4, 224(sp)
    80004b10:	f1f6                	sd	t4,224(sp)
        sd t5, 232(sp)
    80004b12:	f5fa                	sd	t5,232(sp)
        sd t6, 240(sp)
    80004b14:	f9fe                	sd	t6,240(sp)

        # call the C trap handler in trap.c
        call kerneltrap
    80004b16:	ab6fd0ef          	jal	80001dcc <kerneltrap>

        # restore registers.
        ld ra, 0(sp)
    80004b1a:	6082                	ld	ra,0(sp)
        # ld sp, 8(sp)
        ld gp, 16(sp)
    80004b1c:	61c2                	ld	gp,16(sp)
        # not tp (contains hartid), in case we moved CPUs
        ld t0, 32(sp)
    80004b1e:	7282                	ld	t0,32(sp)
        ld t1, 40(sp)
    80004b20:	7322                	ld	t1,40(sp)
        ld t2, 48(sp)
    80004b22:	73c2                	ld	t2,48(sp)
        ld a0, 72(sp)
    80004b24:	6526                	ld	a0,72(sp)
        ld a1, 80(sp)
    80004b26:	65c6                	ld	a1,80(sp)
        ld a2, 88(sp)
    80004b28:	6666                	ld	a2,88(sp)
        ld a3, 96(sp)
    80004b2a:	7686                	ld	a3,96(sp)
        ld a4, 104(sp)
    80004b2c:	7726                	ld	a4,104(sp)
        ld a5, 112(sp)
    80004b2e:	77c6                	ld	a5,112(sp)
        ld a6, 120(sp)
    80004b30:	7866                	ld	a6,120(sp)
        ld a7, 128(sp)
    80004b32:	688a                	ld	a7,128(sp)
        ld t3, 216(sp)
    80004b34:	6e6e                	ld	t3,216(sp)
        ld t4, 224(sp)
    80004b36:	7e8e                	ld	t4,224(sp)
        ld t5, 232(sp)
    80004b38:	7f2e                	ld	t5,232(sp)
        ld t6, 240(sp)
    80004b3a:	7fce                	ld	t6,240(sp)

        addi sp, sp, 256
    80004b3c:	6111                	addi	sp,sp,256

        # return to whatever we were doing in the kernel.
        sret
    80004b3e:	10200073          	sret
    80004b42:	00000013          	nop
    80004b46:	00000013          	nop
    80004b4a:	00000013          	nop

0000000080004b4e <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    80004b4e:	1141                	addi	sp,sp,-16
    80004b50:	e406                	sd	ra,8(sp)
    80004b52:	e022                	sd	s0,0(sp)
    80004b54:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80004b56:	0c000737          	lui	a4,0xc000
    80004b5a:	4785                	li	a5,1
    80004b5c:	d71c                	sw	a5,40(a4)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80004b5e:	c35c                	sw	a5,4(a4)
}
    80004b60:	60a2                	ld	ra,8(sp)
    80004b62:	6402                	ld	s0,0(sp)
    80004b64:	0141                	addi	sp,sp,16
    80004b66:	8082                	ret

0000000080004b68 <plicinithart>:

void
plicinithart(void)
{
    80004b68:	1141                	addi	sp,sp,-16
    80004b6a:	e406                	sd	ra,8(sp)
    80004b6c:	e022                	sd	s0,0(sp)
    80004b6e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004b70:	c8afc0ef          	jal	80000ffa <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80004b74:	0085171b          	slliw	a4,a0,0x8
    80004b78:	0c0027b7          	lui	a5,0xc002
    80004b7c:	97ba                	add	a5,a5,a4
    80004b7e:	40200713          	li	a4,1026
    80004b82:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80004b86:	00d5151b          	slliw	a0,a0,0xd
    80004b8a:	0c2017b7          	lui	a5,0xc201
    80004b8e:	97aa                	add	a5,a5,a0
    80004b90:	0007a023          	sw	zero,0(a5) # c201000 <_entry-0x73dff000>
}
    80004b94:	60a2                	ld	ra,8(sp)
    80004b96:	6402                	ld	s0,0(sp)
    80004b98:	0141                	addi	sp,sp,16
    80004b9a:	8082                	ret

0000000080004b9c <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80004b9c:	1141                	addi	sp,sp,-16
    80004b9e:	e406                	sd	ra,8(sp)
    80004ba0:	e022                	sd	s0,0(sp)
    80004ba2:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80004ba4:	c56fc0ef          	jal	80000ffa <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80004ba8:	00d5151b          	slliw	a0,a0,0xd
    80004bac:	0c2017b7          	lui	a5,0xc201
    80004bb0:	97aa                	add	a5,a5,a0
  return irq;
}
    80004bb2:	43c8                	lw	a0,4(a5)
    80004bb4:	60a2                	ld	ra,8(sp)
    80004bb6:	6402                	ld	s0,0(sp)
    80004bb8:	0141                	addi	sp,sp,16
    80004bba:	8082                	ret

0000000080004bbc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    80004bbc:	1101                	addi	sp,sp,-32
    80004bbe:	ec06                	sd	ra,24(sp)
    80004bc0:	e822                	sd	s0,16(sp)
    80004bc2:	e426                	sd	s1,8(sp)
    80004bc4:	1000                	addi	s0,sp,32
    80004bc6:	84aa                	mv	s1,a0
  int hart = cpuid();
    80004bc8:	c32fc0ef          	jal	80000ffa <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80004bcc:	00d5179b          	slliw	a5,a0,0xd
    80004bd0:	0c201737          	lui	a4,0xc201
    80004bd4:	97ba                	add	a5,a5,a4
    80004bd6:	c3c4                	sw	s1,4(a5)
}
    80004bd8:	60e2                	ld	ra,24(sp)
    80004bda:	6442                	ld	s0,16(sp)
    80004bdc:	64a2                	ld	s1,8(sp)
    80004bde:	6105                	addi	sp,sp,32
    80004be0:	8082                	ret

0000000080004be2 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80004be2:	1141                	addi	sp,sp,-16
    80004be4:	e406                	sd	ra,8(sp)
    80004be6:	e022                	sd	s0,0(sp)
    80004be8:	0800                	addi	s0,sp,16
  if(i >= NUM)
    80004bea:	479d                	li	a5,7
    80004bec:	04a7ca63          	blt	a5,a0,80004c40 <free_desc+0x5e>
    panic("free_desc 1");
  if(disk.free[i])
    80004bf0:	00234797          	auipc	a5,0x234
    80004bf4:	df078793          	addi	a5,a5,-528 # 802389e0 <disk>
    80004bf8:	97aa                	add	a5,a5,a0
    80004bfa:	0187c783          	lbu	a5,24(a5)
    80004bfe:	e7b9                	bnez	a5,80004c4c <free_desc+0x6a>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80004c00:	00451693          	slli	a3,a0,0x4
    80004c04:	00234797          	auipc	a5,0x234
    80004c08:	ddc78793          	addi	a5,a5,-548 # 802389e0 <disk>
    80004c0c:	6398                	ld	a4,0(a5)
    80004c0e:	9736                	add	a4,a4,a3
    80004c10:	00073023          	sd	zero,0(a4) # c201000 <_entry-0x73dff000>
  disk.desc[i].len = 0;
    80004c14:	6398                	ld	a4,0(a5)
    80004c16:	9736                	add	a4,a4,a3
    80004c18:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80004c1c:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80004c20:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80004c24:	97aa                	add	a5,a5,a0
    80004c26:	4705                	li	a4,1
    80004c28:	00e78c23          	sb	a4,24(a5)
  wakeup(&disk.free[0]);
    80004c2c:	00234517          	auipc	a0,0x234
    80004c30:	dcc50513          	addi	a0,a0,-564 # 802389f8 <disk+0x18>
    80004c34:	a45fc0ef          	jal	80001678 <wakeup>
}
    80004c38:	60a2                	ld	ra,8(sp)
    80004c3a:	6402                	ld	s0,0(sp)
    80004c3c:	0141                	addi	sp,sp,16
    80004c3e:	8082                	ret
    panic("free_desc 1");
    80004c40:	00003517          	auipc	a0,0x3
    80004c44:	9e050513          	addi	a0,a0,-1568 # 80007620 <etext+0x620>
    80004c48:	521000ef          	jal	80005968 <panic>
    panic("free_desc 2");
    80004c4c:	00003517          	auipc	a0,0x3
    80004c50:	9e450513          	addi	a0,a0,-1564 # 80007630 <etext+0x630>
    80004c54:	515000ef          	jal	80005968 <panic>

0000000080004c58 <virtio_disk_init>:
{
    80004c58:	1101                	addi	sp,sp,-32
    80004c5a:	ec06                	sd	ra,24(sp)
    80004c5c:	e822                	sd	s0,16(sp)
    80004c5e:	e426                	sd	s1,8(sp)
    80004c60:	e04a                	sd	s2,0(sp)
    80004c62:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80004c64:	00003597          	auipc	a1,0x3
    80004c68:	9dc58593          	addi	a1,a1,-1572 # 80007640 <etext+0x640>
    80004c6c:	00234517          	auipc	a0,0x234
    80004c70:	e9c50513          	addi	a0,a0,-356 # 80238b08 <disk+0x128>
    80004c74:	70d000ef          	jal	80005b80 <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004c78:	100017b7          	lui	a5,0x10001
    80004c7c:	4398                	lw	a4,0(a5)
    80004c7e:	2701                	sext.w	a4,a4
    80004c80:	747277b7          	lui	a5,0x74727
    80004c84:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    80004c88:	14f71863          	bne	a4,a5,80004dd8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004c8c:	100017b7          	lui	a5,0x10001
    80004c90:	43dc                	lw	a5,4(a5)
    80004c92:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80004c94:	4709                	li	a4,2
    80004c96:	14e79163          	bne	a5,a4,80004dd8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004c9a:	100017b7          	lui	a5,0x10001
    80004c9e:	479c                	lw	a5,8(a5)
    80004ca0:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80004ca2:	12e79b63          	bne	a5,a4,80004dd8 <virtio_disk_init+0x180>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    80004ca6:	100017b7          	lui	a5,0x10001
    80004caa:	47d8                	lw	a4,12(a5)
    80004cac:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80004cae:	554d47b7          	lui	a5,0x554d4
    80004cb2:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    80004cb6:	12f71163          	bne	a4,a5,80004dd8 <virtio_disk_init+0x180>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004cba:	100017b7          	lui	a5,0x10001
    80004cbe:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80004cc2:	4705                	li	a4,1
    80004cc4:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004cc6:	470d                	li	a4,3
    80004cc8:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    80004cca:	10001737          	lui	a4,0x10001
    80004cce:	4b18                	lw	a4,16(a4)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80004cd0:	c7ffe6b7          	lui	a3,0xc7ffe
    80004cd4:	75f68693          	addi	a3,a3,1887 # ffffffffc7ffe75f <end+0xffffffff47dbdb67>
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    80004cd8:	8f75                	and	a4,a4,a3
    80004cda:	100016b7          	lui	a3,0x10001
    80004cde:	d298                	sw	a4,32(a3)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ce0:	472d                	li	a4,11
    80004ce2:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    80004ce4:	07078793          	addi	a5,a5,112
  status = *R(VIRTIO_MMIO_STATUS);
    80004ce8:	439c                	lw	a5,0(a5)
    80004cea:	0007891b          	sext.w	s2,a5
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80004cee:	8ba1                	andi	a5,a5,8
    80004cf0:	0e078a63          	beqz	a5,80004de4 <virtio_disk_init+0x18c>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80004cf4:	100017b7          	lui	a5,0x10001
    80004cf8:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80004cfc:	43fc                	lw	a5,68(a5)
    80004cfe:	2781                	sext.w	a5,a5
    80004d00:	0e079863          	bnez	a5,80004df0 <virtio_disk_init+0x198>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80004d04:	100017b7          	lui	a5,0x10001
    80004d08:	5bdc                	lw	a5,52(a5)
    80004d0a:	2781                	sext.w	a5,a5
  if(max == 0)
    80004d0c:	0e078863          	beqz	a5,80004dfc <virtio_disk_init+0x1a4>
  if(max < NUM)
    80004d10:	471d                	li	a4,7
    80004d12:	0ef77b63          	bgeu	a4,a5,80004e08 <virtio_disk_init+0x1b0>
  disk.desc = kalloc();
    80004d16:	c80fb0ef          	jal	80000196 <kalloc>
    80004d1a:	00234497          	auipc	s1,0x234
    80004d1e:	cc648493          	addi	s1,s1,-826 # 802389e0 <disk>
    80004d22:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80004d24:	c72fb0ef          	jal	80000196 <kalloc>
    80004d28:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    80004d2a:	c6cfb0ef          	jal	80000196 <kalloc>
    80004d2e:	87aa                	mv	a5,a0
    80004d30:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    80004d32:	6088                	ld	a0,0(s1)
    80004d34:	0e050063          	beqz	a0,80004e14 <virtio_disk_init+0x1bc>
    80004d38:	00234717          	auipc	a4,0x234
    80004d3c:	cb073703          	ld	a4,-848(a4) # 802389e8 <disk+0x8>
    80004d40:	cb71                	beqz	a4,80004e14 <virtio_disk_init+0x1bc>
    80004d42:	cbe9                	beqz	a5,80004e14 <virtio_disk_init+0x1bc>
  memset(disk.desc, 0, PGSIZE);
    80004d44:	6605                	lui	a2,0x1
    80004d46:	4581                	li	a1,0
    80004d48:	d5cfb0ef          	jal	800002a4 <memset>
  memset(disk.avail, 0, PGSIZE);
    80004d4c:	00234497          	auipc	s1,0x234
    80004d50:	c9448493          	addi	s1,s1,-876 # 802389e0 <disk>
    80004d54:	6605                	lui	a2,0x1
    80004d56:	4581                	li	a1,0
    80004d58:	6488                	ld	a0,8(s1)
    80004d5a:	d4afb0ef          	jal	800002a4 <memset>
  memset(disk.used, 0, PGSIZE);
    80004d5e:	6605                	lui	a2,0x1
    80004d60:	4581                	li	a1,0
    80004d62:	6888                	ld	a0,16(s1)
    80004d64:	d40fb0ef          	jal	800002a4 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    80004d68:	100017b7          	lui	a5,0x10001
    80004d6c:	4721                	li	a4,8
    80004d6e:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80004d70:	4098                	lw	a4,0(s1)
    80004d72:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80004d76:	40d8                	lw	a4,4(s1)
    80004d78:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    80004d7c:	649c                	ld	a5,8(s1)
    80004d7e:	0007869b          	sext.w	a3,a5
    80004d82:	10001737          	lui	a4,0x10001
    80004d86:	08d72823          	sw	a3,144(a4) # 10001090 <_entry-0x6fffef70>
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80004d8a:	9781                	srai	a5,a5,0x20
    80004d8c:	08f72a23          	sw	a5,148(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    80004d90:	689c                	ld	a5,16(s1)
    80004d92:	0007869b          	sext.w	a3,a5
    80004d96:	0ad72023          	sw	a3,160(a4)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80004d9a:	9781                	srai	a5,a5,0x20
    80004d9c:	0af72223          	sw	a5,164(a4)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    80004da0:	4785                	li	a5,1
    80004da2:	c37c                	sw	a5,68(a4)
    disk.free[i] = 1;
    80004da4:	00f48c23          	sb	a5,24(s1)
    80004da8:	00f48ca3          	sb	a5,25(s1)
    80004dac:	00f48d23          	sb	a5,26(s1)
    80004db0:	00f48da3          	sb	a5,27(s1)
    80004db4:	00f48e23          	sb	a5,28(s1)
    80004db8:	00f48ea3          	sb	a5,29(s1)
    80004dbc:	00f48f23          	sb	a5,30(s1)
    80004dc0:	00f48fa3          	sb	a5,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80004dc4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80004dc8:	07272823          	sw	s2,112(a4)
}
    80004dcc:	60e2                	ld	ra,24(sp)
    80004dce:	6442                	ld	s0,16(sp)
    80004dd0:	64a2                	ld	s1,8(sp)
    80004dd2:	6902                	ld	s2,0(sp)
    80004dd4:	6105                	addi	sp,sp,32
    80004dd6:	8082                	ret
    panic("could not find virtio disk");
    80004dd8:	00003517          	auipc	a0,0x3
    80004ddc:	87850513          	addi	a0,a0,-1928 # 80007650 <etext+0x650>
    80004de0:	389000ef          	jal	80005968 <panic>
    panic("virtio disk FEATURES_OK unset");
    80004de4:	00003517          	auipc	a0,0x3
    80004de8:	88c50513          	addi	a0,a0,-1908 # 80007670 <etext+0x670>
    80004dec:	37d000ef          	jal	80005968 <panic>
    panic("virtio disk should not be ready");
    80004df0:	00003517          	auipc	a0,0x3
    80004df4:	8a050513          	addi	a0,a0,-1888 # 80007690 <etext+0x690>
    80004df8:	371000ef          	jal	80005968 <panic>
    panic("virtio disk has no queue 0");
    80004dfc:	00003517          	auipc	a0,0x3
    80004e00:	8b450513          	addi	a0,a0,-1868 # 800076b0 <etext+0x6b0>
    80004e04:	365000ef          	jal	80005968 <panic>
    panic("virtio disk max queue too short");
    80004e08:	00003517          	auipc	a0,0x3
    80004e0c:	8c850513          	addi	a0,a0,-1848 # 800076d0 <etext+0x6d0>
    80004e10:	359000ef          	jal	80005968 <panic>
    panic("virtio disk kalloc");
    80004e14:	00003517          	auipc	a0,0x3
    80004e18:	8dc50513          	addi	a0,a0,-1828 # 800076f0 <etext+0x6f0>
    80004e1c:	34d000ef          	jal	80005968 <panic>

0000000080004e20 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80004e20:	711d                	addi	sp,sp,-96
    80004e22:	ec86                	sd	ra,88(sp)
    80004e24:	e8a2                	sd	s0,80(sp)
    80004e26:	e4a6                	sd	s1,72(sp)
    80004e28:	e0ca                	sd	s2,64(sp)
    80004e2a:	fc4e                	sd	s3,56(sp)
    80004e2c:	f852                	sd	s4,48(sp)
    80004e2e:	f456                	sd	s5,40(sp)
    80004e30:	f05a                	sd	s6,32(sp)
    80004e32:	ec5e                	sd	s7,24(sp)
    80004e34:	e862                	sd	s8,16(sp)
    80004e36:	1080                	addi	s0,sp,96
    80004e38:	89aa                	mv	s3,a0
    80004e3a:	8b2e                	mv	s6,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80004e3c:	00c52b83          	lw	s7,12(a0)
    80004e40:	001b9b9b          	slliw	s7,s7,0x1
    80004e44:	1b82                	slli	s7,s7,0x20
    80004e46:	020bdb93          	srli	s7,s7,0x20

  acquire(&disk.vdisk_lock);
    80004e4a:	00234517          	auipc	a0,0x234
    80004e4e:	cbe50513          	addi	a0,a0,-834 # 80238b08 <disk+0x128>
    80004e52:	5b9000ef          	jal	80005c0a <acquire>
  for(int i = 0; i < NUM; i++){
    80004e56:	44a1                	li	s1,8
      disk.free[i] = 0;
    80004e58:	00234a97          	auipc	s5,0x234
    80004e5c:	b88a8a93          	addi	s5,s5,-1144 # 802389e0 <disk>
  for(int i = 0; i < 3; i++){
    80004e60:	4a0d                	li	s4,3
    idx[i] = alloc_desc();
    80004e62:	5c7d                	li	s8,-1
    80004e64:	a095                	j	80004ec8 <virtio_disk_rw+0xa8>
      disk.free[i] = 0;
    80004e66:	00fa8733          	add	a4,s5,a5
    80004e6a:	00070c23          	sb	zero,24(a4)
    idx[i] = alloc_desc();
    80004e6e:	c19c                	sw	a5,0(a1)
    if(idx[i] < 0){
    80004e70:	0207c563          	bltz	a5,80004e9a <virtio_disk_rw+0x7a>
  for(int i = 0; i < 3; i++){
    80004e74:	2905                	addiw	s2,s2,1
    80004e76:	0611                	addi	a2,a2,4 # 1004 <_entry-0x7fffeffc>
    80004e78:	05490c63          	beq	s2,s4,80004ed0 <virtio_disk_rw+0xb0>
    idx[i] = alloc_desc();
    80004e7c:	85b2                	mv	a1,a2
  for(int i = 0; i < NUM; i++){
    80004e7e:	00234717          	auipc	a4,0x234
    80004e82:	b6270713          	addi	a4,a4,-1182 # 802389e0 <disk>
    80004e86:	4781                	li	a5,0
    if(disk.free[i]){
    80004e88:	01874683          	lbu	a3,24(a4)
    80004e8c:	fee9                	bnez	a3,80004e66 <virtio_disk_rw+0x46>
  for(int i = 0; i < NUM; i++){
    80004e8e:	2785                	addiw	a5,a5,1
    80004e90:	0705                	addi	a4,a4,1
    80004e92:	fe979be3          	bne	a5,s1,80004e88 <virtio_disk_rw+0x68>
    idx[i] = alloc_desc();
    80004e96:	0185a023          	sw	s8,0(a1)
      for(int j = 0; j < i; j++)
    80004e9a:	01205d63          	blez	s2,80004eb4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004e9e:	fa042503          	lw	a0,-96(s0)
    80004ea2:	d41ff0ef          	jal	80004be2 <free_desc>
      for(int j = 0; j < i; j++)
    80004ea6:	4785                	li	a5,1
    80004ea8:	0127d663          	bge	a5,s2,80004eb4 <virtio_disk_rw+0x94>
        free_desc(idx[j]);
    80004eac:	fa442503          	lw	a0,-92(s0)
    80004eb0:	d33ff0ef          	jal	80004be2 <free_desc>
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80004eb4:	00234597          	auipc	a1,0x234
    80004eb8:	c5458593          	addi	a1,a1,-940 # 80238b08 <disk+0x128>
    80004ebc:	00234517          	auipc	a0,0x234
    80004ec0:	b3c50513          	addi	a0,a0,-1220 # 802389f8 <disk+0x18>
    80004ec4:	f68fc0ef          	jal	8000162c <sleep>
  for(int i = 0; i < 3; i++){
    80004ec8:	fa040613          	addi	a2,s0,-96
    80004ecc:	4901                	li	s2,0
    80004ece:	b77d                	j	80004e7c <virtio_disk_rw+0x5c>
  }

  // format the three descriptors.
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004ed0:	fa042503          	lw	a0,-96(s0)
    80004ed4:	00451693          	slli	a3,a0,0x4

  if(write)
    80004ed8:	00234797          	auipc	a5,0x234
    80004edc:	b0878793          	addi	a5,a5,-1272 # 802389e0 <disk>
    80004ee0:	00451713          	slli	a4,a0,0x4
    80004ee4:	0a070713          	addi	a4,a4,160
    80004ee8:	973e                	add	a4,a4,a5
    80004eea:	01603633          	snez	a2,s6
    80004eee:	c710                	sw	a2,8(a4)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80004ef0:	00072623          	sw	zero,12(a4)
  buf0->sector = sector;
    80004ef4:	01773823          	sd	s7,16(a4)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80004ef8:	6398                	ld	a4,0(a5)
    80004efa:	9736                	add	a4,a4,a3
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80004efc:	0a868613          	addi	a2,a3,168 # 100010a8 <_entry-0x6fffef58>
    80004f00:	963e                	add	a2,a2,a5
  disk.desc[idx[0]].addr = (uint64) buf0;
    80004f02:	e310                	sd	a2,0(a4)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    80004f04:	6390                	ld	a2,0(a5)
    80004f06:	00d60833          	add	a6,a2,a3
    80004f0a:	4741                	li	a4,16
    80004f0c:	00e82423          	sw	a4,8(a6)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80004f10:	4585                	li	a1,1
    80004f12:	00b81623          	sh	a1,12(a6)
  disk.desc[idx[0]].next = idx[1];
    80004f16:	fa442703          	lw	a4,-92(s0)
    80004f1a:	00e81723          	sh	a4,14(a6)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80004f1e:	0712                	slli	a4,a4,0x4
    80004f20:	963a                	add	a2,a2,a4
    80004f22:	05898813          	addi	a6,s3,88
    80004f26:	01063023          	sd	a6,0(a2)
  disk.desc[idx[1]].len = BSIZE;
    80004f2a:	0007b883          	ld	a7,0(a5)
    80004f2e:	9746                	add	a4,a4,a7
    80004f30:	40000613          	li	a2,1024
    80004f34:	c710                	sw	a2,8(a4)
  if(write)
    80004f36:	001b3613          	seqz	a2,s6
    80004f3a:	0016161b          	slliw	a2,a2,0x1
    disk.desc[idx[1]].flags = 0; // device reads b->data
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    80004f3e:	8e4d                	or	a2,a2,a1
    80004f40:	00c71623          	sh	a2,12(a4)
  disk.desc[idx[1]].next = idx[2];
    80004f44:	fa842603          	lw	a2,-88(s0)
    80004f48:	00c71723          	sh	a2,14(a4)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80004f4c:	00451813          	slli	a6,a0,0x4
    80004f50:	02080813          	addi	a6,a6,32
    80004f54:	983e                	add	a6,a6,a5
    80004f56:	577d                	li	a4,-1
    80004f58:	00e80823          	sb	a4,16(a6)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80004f5c:	0612                	slli	a2,a2,0x4
    80004f5e:	98b2                	add	a7,a7,a2
    80004f60:	03068713          	addi	a4,a3,48
    80004f64:	973e                	add	a4,a4,a5
    80004f66:	00e8b023          	sd	a4,0(a7)
  disk.desc[idx[2]].len = 1;
    80004f6a:	6398                	ld	a4,0(a5)
    80004f6c:	9732                	add	a4,a4,a2
    80004f6e:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    80004f70:	4689                	li	a3,2
    80004f72:	00d71623          	sh	a3,12(a4)
  disk.desc[idx[2]].next = 0;
    80004f76:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80004f7a:	00b9a223          	sw	a1,4(s3)
  disk.info[idx[0]].b = b;
    80004f7e:	01383423          	sd	s3,8(a6)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    80004f82:	6794                	ld	a3,8(a5)
    80004f84:	0026d703          	lhu	a4,2(a3)
    80004f88:	8b1d                	andi	a4,a4,7
    80004f8a:	0706                	slli	a4,a4,0x1
    80004f8c:	96ba                	add	a3,a3,a4
    80004f8e:	00a69223          	sh	a0,4(a3)

  __sync_synchronize();
    80004f92:	0330000f          	fence	rw,rw

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80004f96:	6798                	ld	a4,8(a5)
    80004f98:	00275783          	lhu	a5,2(a4)
    80004f9c:	2785                	addiw	a5,a5,1
    80004f9e:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80004fa2:	0330000f          	fence	rw,rw

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80004fa6:	100017b7          	lui	a5,0x10001
    80004faa:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80004fae:	0049a783          	lw	a5,4(s3)
    sleep(b, &disk.vdisk_lock);
    80004fb2:	00234917          	auipc	s2,0x234
    80004fb6:	b5690913          	addi	s2,s2,-1194 # 80238b08 <disk+0x128>
  while(b->disk == 1) {
    80004fba:	84ae                	mv	s1,a1
    80004fbc:	00b79a63          	bne	a5,a1,80004fd0 <virtio_disk_rw+0x1b0>
    sleep(b, &disk.vdisk_lock);
    80004fc0:	85ca                	mv	a1,s2
    80004fc2:	854e                	mv	a0,s3
    80004fc4:	e68fc0ef          	jal	8000162c <sleep>
  while(b->disk == 1) {
    80004fc8:	0049a783          	lw	a5,4(s3)
    80004fcc:	fe978ae3          	beq	a5,s1,80004fc0 <virtio_disk_rw+0x1a0>
  }

  disk.info[idx[0]].b = 0;
    80004fd0:	fa042903          	lw	s2,-96(s0)
    80004fd4:	00491713          	slli	a4,s2,0x4
    80004fd8:	02070713          	addi	a4,a4,32
    80004fdc:	00234797          	auipc	a5,0x234
    80004fe0:	a0478793          	addi	a5,a5,-1532 # 802389e0 <disk>
    80004fe4:	97ba                	add	a5,a5,a4
    80004fe6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80004fea:	00234997          	auipc	s3,0x234
    80004fee:	9f698993          	addi	s3,s3,-1546 # 802389e0 <disk>
    80004ff2:	00491713          	slli	a4,s2,0x4
    80004ff6:	0009b783          	ld	a5,0(s3)
    80004ffa:	97ba                	add	a5,a5,a4
    80004ffc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005000:	854a                	mv	a0,s2
    80005002:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005006:	bddff0ef          	jal	80004be2 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000500a:	8885                	andi	s1,s1,1
    8000500c:	f0fd                	bnez	s1,80004ff2 <virtio_disk_rw+0x1d2>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    8000500e:	00234517          	auipc	a0,0x234
    80005012:	afa50513          	addi	a0,a0,-1286 # 80238b08 <disk+0x128>
    80005016:	489000ef          	jal	80005c9e <release>
}
    8000501a:	60e6                	ld	ra,88(sp)
    8000501c:	6446                	ld	s0,80(sp)
    8000501e:	64a6                	ld	s1,72(sp)
    80005020:	6906                	ld	s2,64(sp)
    80005022:	79e2                	ld	s3,56(sp)
    80005024:	7a42                	ld	s4,48(sp)
    80005026:	7aa2                	ld	s5,40(sp)
    80005028:	7b02                	ld	s6,32(sp)
    8000502a:	6be2                	ld	s7,24(sp)
    8000502c:	6c42                	ld	s8,16(sp)
    8000502e:	6125                	addi	sp,sp,96
    80005030:	8082                	ret

0000000080005032 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005032:	1101                	addi	sp,sp,-32
    80005034:	ec06                	sd	ra,24(sp)
    80005036:	e822                	sd	s0,16(sp)
    80005038:	e426                	sd	s1,8(sp)
    8000503a:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    8000503c:	00234497          	auipc	s1,0x234
    80005040:	9a448493          	addi	s1,s1,-1628 # 802389e0 <disk>
    80005044:	00234517          	auipc	a0,0x234
    80005048:	ac450513          	addi	a0,a0,-1340 # 80238b08 <disk+0x128>
    8000504c:	3bf000ef          	jal	80005c0a <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005050:	100017b7          	lui	a5,0x10001
    80005054:	53bc                	lw	a5,96(a5)
    80005056:	8b8d                	andi	a5,a5,3
    80005058:	10001737          	lui	a4,0x10001
    8000505c:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    8000505e:	0330000f          	fence	rw,rw

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005062:	689c                	ld	a5,16(s1)
    80005064:	0204d703          	lhu	a4,32(s1)
    80005068:	0027d783          	lhu	a5,2(a5) # 10001002 <_entry-0x6fffeffe>
    8000506c:	04f70863          	beq	a4,a5,800050bc <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005070:	0330000f          	fence	rw,rw
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005074:	6898                	ld	a4,16(s1)
    80005076:	0204d783          	lhu	a5,32(s1)
    8000507a:	8b9d                	andi	a5,a5,7
    8000507c:	078e                	slli	a5,a5,0x3
    8000507e:	97ba                	add	a5,a5,a4
    80005080:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005082:	00479713          	slli	a4,a5,0x4
    80005086:	02070713          	addi	a4,a4,32 # 10001020 <_entry-0x6fffefe0>
    8000508a:	9726                	add	a4,a4,s1
    8000508c:	01074703          	lbu	a4,16(a4)
    80005090:	e329                	bnez	a4,800050d2 <virtio_disk_intr+0xa0>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005092:	0792                	slli	a5,a5,0x4
    80005094:	02078793          	addi	a5,a5,32
    80005098:	97a6                	add	a5,a5,s1
    8000509a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000509c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    800050a0:	dd8fc0ef          	jal	80001678 <wakeup>

    disk.used_idx += 1;
    800050a4:	0204d783          	lhu	a5,32(s1)
    800050a8:	2785                	addiw	a5,a5,1
    800050aa:	17c2                	slli	a5,a5,0x30
    800050ac:	93c1                	srli	a5,a5,0x30
    800050ae:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    800050b2:	6898                	ld	a4,16(s1)
    800050b4:	00275703          	lhu	a4,2(a4)
    800050b8:	faf71ce3          	bne	a4,a5,80005070 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    800050bc:	00234517          	auipc	a0,0x234
    800050c0:	a4c50513          	addi	a0,a0,-1460 # 80238b08 <disk+0x128>
    800050c4:	3db000ef          	jal	80005c9e <release>
}
    800050c8:	60e2                	ld	ra,24(sp)
    800050ca:	6442                	ld	s0,16(sp)
    800050cc:	64a2                	ld	s1,8(sp)
    800050ce:	6105                	addi	sp,sp,32
    800050d0:	8082                	ret
      panic("virtio_disk_intr status");
    800050d2:	00002517          	auipc	a0,0x2
    800050d6:	63650513          	addi	a0,a0,1590 # 80007708 <etext+0x708>
    800050da:	08f000ef          	jal	80005968 <panic>

00000000800050de <timerinit>:
}

// ask each hart to generate timer interrupts.
void
timerinit()
{
    800050de:	1141                	addi	sp,sp,-16
    800050e0:	e406                	sd	ra,8(sp)
    800050e2:	e022                	sd	s0,0(sp)
    800050e4:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mie" : "=r" (x) );
    800050e6:	304027f3          	csrr	a5,mie
  // enable supervisor-mode timer interrupts.
  w_mie(r_mie() | MIE_STIE);
    800050ea:	0207e793          	ori	a5,a5,32
  asm volatile("csrw mie, %0" : : "r" (x));
    800050ee:	30479073          	csrw	mie,a5
  asm volatile("csrr %0, 0x30a" : "=r" (x) );
    800050f2:	30a027f3          	csrr	a5,0x30a
  
  // enable the sstc extension (i.e. stimecmp).
  w_menvcfg(r_menvcfg() | (1L << 63)); 
    800050f6:	577d                	li	a4,-1
    800050f8:	177e                	slli	a4,a4,0x3f
    800050fa:	8fd9                	or	a5,a5,a4
  asm volatile("csrw 0x30a, %0" : : "r" (x));
    800050fc:	30a79073          	csrw	0x30a,a5
  asm volatile("csrr %0, mcounteren" : "=r" (x) );
    80005100:	306027f3          	csrr	a5,mcounteren
  
  // allow supervisor to use stimecmp and time.
  w_mcounteren(r_mcounteren() | 2);
    80005104:	0027e793          	ori	a5,a5,2
  asm volatile("csrw mcounteren, %0" : : "r" (x));
    80005108:	30679073          	csrw	mcounteren,a5
  asm volatile("csrr %0, time" : "=r" (x) );
    8000510c:	c01027f3          	rdtime	a5
  
  // ask for the very first timer interrupt.
  w_stimecmp(r_time() + 1000000);
    80005110:	000f4737          	lui	a4,0xf4
    80005114:	24070713          	addi	a4,a4,576 # f4240 <_entry-0x7ff0bdc0>
    80005118:	97ba                	add	a5,a5,a4
  asm volatile("csrw 0x14d, %0" : : "r" (x));
    8000511a:	14d79073          	csrw	stimecmp,a5
}
    8000511e:	60a2                	ld	ra,8(sp)
    80005120:	6402                	ld	s0,0(sp)
    80005122:	0141                	addi	sp,sp,16
    80005124:	8082                	ret

0000000080005126 <start>:
{
    80005126:	1141                	addi	sp,sp,-16
    80005128:	e406                	sd	ra,8(sp)
    8000512a:	e022                	sd	s0,0(sp)
    8000512c:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    8000512e:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005132:	7779                	lui	a4,0xffffe
    80005134:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7fdbdc07>
    80005138:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    8000513a:	6705                	lui	a4,0x1
    8000513c:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005140:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005142:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005146:	ffffb797          	auipc	a5,0xffffb
    8000514a:	31478793          	addi	a5,a5,788 # 8000045a <main>
    8000514e:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005152:	4781                	li	a5,0
    80005154:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005158:	67c1                	lui	a5,0x10
    8000515a:	17fd                	addi	a5,a5,-1 # ffff <_entry-0x7fff0001>
    8000515c:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005160:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005164:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE);
    80005168:	2207e793          	ori	a5,a5,544
  asm volatile("csrw sie, %0" : : "r" (x));
    8000516c:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005170:	57fd                	li	a5,-1
    80005172:	83a9                	srli	a5,a5,0xa
    80005174:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005178:	47bd                	li	a5,15
    8000517a:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    8000517e:	f61ff0ef          	jal	800050de <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005182:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005186:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005188:	823e                	mv	tp,a5
  asm volatile("mret");
    8000518a:	30200073          	mret
}
    8000518e:	60a2                	ld	ra,8(sp)
    80005190:	6402                	ld	s0,0(sp)
    80005192:	0141                	addi	sp,sp,16
    80005194:	8082                	ret

0000000080005196 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005196:	7119                	addi	sp,sp,-128
    80005198:	fc86                	sd	ra,120(sp)
    8000519a:	f8a2                	sd	s0,112(sp)
    8000519c:	f4a6                	sd	s1,104(sp)
    8000519e:	0100                	addi	s0,sp,128
  char buf[32];
  int i = 0;

  while(i < n){
    800051a0:	06c05b63          	blez	a2,80005216 <consolewrite+0x80>
    800051a4:	f0ca                	sd	s2,96(sp)
    800051a6:	ecce                	sd	s3,88(sp)
    800051a8:	e8d2                	sd	s4,80(sp)
    800051aa:	e4d6                	sd	s5,72(sp)
    800051ac:	e0da                	sd	s6,64(sp)
    800051ae:	fc5e                	sd	s7,56(sp)
    800051b0:	f862                	sd	s8,48(sp)
    800051b2:	f466                	sd	s9,40(sp)
    800051b4:	f06a                	sd	s10,32(sp)
    800051b6:	8b2a                	mv	s6,a0
    800051b8:	8bae                	mv	s7,a1
    800051ba:	8a32                	mv	s4,a2
  int i = 0;
    800051bc:	4481                	li	s1,0
    int nn = sizeof(buf);
    if(nn > n - i)
    800051be:	02000c93          	li	s9,32
    800051c2:	02000d13          	li	s10,32
      nn = n - i;
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800051c6:	f8040a93          	addi	s5,s0,-128
    800051ca:	5c7d                	li	s8,-1
    800051cc:	a025                	j	800051f4 <consolewrite+0x5e>
    if(nn > n - i)
    800051ce:	0009099b          	sext.w	s3,s2
    if(either_copyin(buf, user_src, src+i, nn) == -1)
    800051d2:	86ce                	mv	a3,s3
    800051d4:	01748633          	add	a2,s1,s7
    800051d8:	85da                	mv	a1,s6
    800051da:	8556                	mv	a0,s5
    800051dc:	ff4fc0ef          	jal	800019d0 <either_copyin>
    800051e0:	03850d63          	beq	a0,s8,8000521a <consolewrite+0x84>
      break;
    uartwrite(buf, nn);
    800051e4:	85ce                	mv	a1,s3
    800051e6:	8556                	mv	a0,s5
    800051e8:	017000ef          	jal	800059fe <uartwrite>
    i += nn;
    800051ec:	009904bb          	addw	s1,s2,s1
  while(i < n){
    800051f0:	0144d963          	bge	s1,s4,80005202 <consolewrite+0x6c>
    if(nn > n - i)
    800051f4:	409a07bb          	subw	a5,s4,s1
    800051f8:	893e                	mv	s2,a5
    800051fa:	fcfcdae3          	bge	s9,a5,800051ce <consolewrite+0x38>
    800051fe:	896a                	mv	s2,s10
    80005200:	b7f9                	j	800051ce <consolewrite+0x38>
    80005202:	7906                	ld	s2,96(sp)
    80005204:	69e6                	ld	s3,88(sp)
    80005206:	6a46                	ld	s4,80(sp)
    80005208:	6aa6                	ld	s5,72(sp)
    8000520a:	6b06                	ld	s6,64(sp)
    8000520c:	7be2                	ld	s7,56(sp)
    8000520e:	7c42                	ld	s8,48(sp)
    80005210:	7ca2                	ld	s9,40(sp)
    80005212:	7d02                	ld	s10,32(sp)
    80005214:	a821                	j	8000522c <consolewrite+0x96>
  int i = 0;
    80005216:	4481                	li	s1,0
    80005218:	a811                	j	8000522c <consolewrite+0x96>
    8000521a:	7906                	ld	s2,96(sp)
    8000521c:	69e6                	ld	s3,88(sp)
    8000521e:	6a46                	ld	s4,80(sp)
    80005220:	6aa6                	ld	s5,72(sp)
    80005222:	6b06                	ld	s6,64(sp)
    80005224:	7be2                	ld	s7,56(sp)
    80005226:	7c42                	ld	s8,48(sp)
    80005228:	7ca2                	ld	s9,40(sp)
    8000522a:	7d02                	ld	s10,32(sp)
  }

  return i;
}
    8000522c:	8526                	mv	a0,s1
    8000522e:	70e6                	ld	ra,120(sp)
    80005230:	7446                	ld	s0,112(sp)
    80005232:	74a6                	ld	s1,104(sp)
    80005234:	6109                	addi	sp,sp,128
    80005236:	8082                	ret

0000000080005238 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005238:	711d                	addi	sp,sp,-96
    8000523a:	ec86                	sd	ra,88(sp)
    8000523c:	e8a2                	sd	s0,80(sp)
    8000523e:	e4a6                	sd	s1,72(sp)
    80005240:	e0ca                	sd	s2,64(sp)
    80005242:	fc4e                	sd	s3,56(sp)
    80005244:	f852                	sd	s4,48(sp)
    80005246:	f05a                	sd	s6,32(sp)
    80005248:	ec5e                	sd	s7,24(sp)
    8000524a:	1080                	addi	s0,sp,96
    8000524c:	8b2a                	mv	s6,a0
    8000524e:	8a2e                	mv	s4,a1
    80005250:	89b2                	mv	s3,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005252:	8bb2                	mv	s7,a2
  acquire(&cons.lock);
    80005254:	0023c517          	auipc	a0,0x23c
    80005258:	8cc50513          	addi	a0,a0,-1844 # 80240b20 <cons>
    8000525c:	1af000ef          	jal	80005c0a <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005260:	0023c497          	auipc	s1,0x23c
    80005264:	8c048493          	addi	s1,s1,-1856 # 80240b20 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005268:	0023c917          	auipc	s2,0x23c
    8000526c:	95090913          	addi	s2,s2,-1712 # 80240bb8 <cons+0x98>
  while(n > 0){
    80005270:	0b305b63          	blez	s3,80005326 <consoleread+0xee>
    while(cons.r == cons.w){
    80005274:	0984a783          	lw	a5,152(s1)
    80005278:	09c4a703          	lw	a4,156(s1)
    8000527c:	0af71063          	bne	a4,a5,8000531c <consoleread+0xe4>
      if(killed(myproc())){
    80005280:	daffb0ef          	jal	8000102e <myproc>
    80005284:	de4fc0ef          	jal	80001868 <killed>
    80005288:	e12d                	bnez	a0,800052ea <consoleread+0xb2>
      sleep(&cons.r, &cons.lock);
    8000528a:	85a6                	mv	a1,s1
    8000528c:	854a                	mv	a0,s2
    8000528e:	b9efc0ef          	jal	8000162c <sleep>
    while(cons.r == cons.w){
    80005292:	0984a783          	lw	a5,152(s1)
    80005296:	09c4a703          	lw	a4,156(s1)
    8000529a:	fef703e3          	beq	a4,a5,80005280 <consoleread+0x48>
    8000529e:	f456                	sd	s5,40(sp)
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    800052a0:	0023c717          	auipc	a4,0x23c
    800052a4:	88070713          	addi	a4,a4,-1920 # 80240b20 <cons>
    800052a8:	0017869b          	addiw	a3,a5,1
    800052ac:	08d72c23          	sw	a3,152(a4)
    800052b0:	07f7f693          	andi	a3,a5,127
    800052b4:	9736                	add	a4,a4,a3
    800052b6:	01874703          	lbu	a4,24(a4)
    800052ba:	00070a9b          	sext.w	s5,a4

    if(c == C('D')){  // end-of-file
    800052be:	4691                	li	a3,4
    800052c0:	04da8663          	beq	s5,a3,8000530c <consoleread+0xd4>
      }
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    800052c4:	fae407a3          	sb	a4,-81(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    800052c8:	4685                	li	a3,1
    800052ca:	faf40613          	addi	a2,s0,-81
    800052ce:	85d2                	mv	a1,s4
    800052d0:	855a                	mv	a0,s6
    800052d2:	eb4fc0ef          	jal	80001986 <either_copyout>
    800052d6:	57fd                	li	a5,-1
    800052d8:	04f50663          	beq	a0,a5,80005324 <consoleread+0xec>
      break;

    dst++;
    800052dc:	0a05                	addi	s4,s4,1
    --n;
    800052de:	39fd                	addiw	s3,s3,-1

    if(c == '\n'){
    800052e0:	47a9                	li	a5,10
    800052e2:	04fa8b63          	beq	s5,a5,80005338 <consoleread+0x100>
    800052e6:	7aa2                	ld	s5,40(sp)
    800052e8:	b761                	j	80005270 <consoleread+0x38>
        release(&cons.lock);
    800052ea:	0023c517          	auipc	a0,0x23c
    800052ee:	83650513          	addi	a0,a0,-1994 # 80240b20 <cons>
    800052f2:	1ad000ef          	jal	80005c9e <release>
        return -1;
    800052f6:	557d                	li	a0,-1
    }
  }
  release(&cons.lock);

  return target - n;
}
    800052f8:	60e6                	ld	ra,88(sp)
    800052fa:	6446                	ld	s0,80(sp)
    800052fc:	64a6                	ld	s1,72(sp)
    800052fe:	6906                	ld	s2,64(sp)
    80005300:	79e2                	ld	s3,56(sp)
    80005302:	7a42                	ld	s4,48(sp)
    80005304:	7b02                	ld	s6,32(sp)
    80005306:	6be2                	ld	s7,24(sp)
    80005308:	6125                	addi	sp,sp,96
    8000530a:	8082                	ret
      if(n < target){
    8000530c:	0179fa63          	bgeu	s3,s7,80005320 <consoleread+0xe8>
        cons.r--;
    80005310:	0023c717          	auipc	a4,0x23c
    80005314:	8af72423          	sw	a5,-1880(a4) # 80240bb8 <cons+0x98>
    80005318:	7aa2                	ld	s5,40(sp)
    8000531a:	a031                	j	80005326 <consoleread+0xee>
    8000531c:	f456                	sd	s5,40(sp)
    8000531e:	b749                	j	800052a0 <consoleread+0x68>
    80005320:	7aa2                	ld	s5,40(sp)
    80005322:	a011                	j	80005326 <consoleread+0xee>
    80005324:	7aa2                	ld	s5,40(sp)
  release(&cons.lock);
    80005326:	0023b517          	auipc	a0,0x23b
    8000532a:	7fa50513          	addi	a0,a0,2042 # 80240b20 <cons>
    8000532e:	171000ef          	jal	80005c9e <release>
  return target - n;
    80005332:	413b853b          	subw	a0,s7,s3
    80005336:	b7c9                	j	800052f8 <consoleread+0xc0>
    80005338:	7aa2                	ld	s5,40(sp)
    8000533a:	b7f5                	j	80005326 <consoleread+0xee>

000000008000533c <consputc>:
{
    8000533c:	1141                	addi	sp,sp,-16
    8000533e:	e406                	sd	ra,8(sp)
    80005340:	e022                	sd	s0,0(sp)
    80005342:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005344:	10000793          	li	a5,256
    80005348:	00f50863          	beq	a0,a5,80005358 <consputc+0x1c>
    uartputc_sync(c);
    8000534c:	746000ef          	jal	80005a92 <uartputc_sync>
}
    80005350:	60a2                	ld	ra,8(sp)
    80005352:	6402                	ld	s0,0(sp)
    80005354:	0141                	addi	sp,sp,16
    80005356:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005358:	4521                	li	a0,8
    8000535a:	738000ef          	jal	80005a92 <uartputc_sync>
    8000535e:	02000513          	li	a0,32
    80005362:	730000ef          	jal	80005a92 <uartputc_sync>
    80005366:	4521                	li	a0,8
    80005368:	72a000ef          	jal	80005a92 <uartputc_sync>
    8000536c:	b7d5                	j	80005350 <consputc+0x14>

000000008000536e <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    8000536e:	1101                	addi	sp,sp,-32
    80005370:	ec06                	sd	ra,24(sp)
    80005372:	e822                	sd	s0,16(sp)
    80005374:	e426                	sd	s1,8(sp)
    80005376:	1000                	addi	s0,sp,32
    80005378:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    8000537a:	0023b517          	auipc	a0,0x23b
    8000537e:	7a650513          	addi	a0,a0,1958 # 80240b20 <cons>
    80005382:	089000ef          	jal	80005c0a <acquire>

  switch(c){
    80005386:	47d5                	li	a5,21
    80005388:	08f48d63          	beq	s1,a5,80005422 <consoleintr+0xb4>
    8000538c:	0297c563          	blt	a5,s1,800053b6 <consoleintr+0x48>
    80005390:	47a1                	li	a5,8
    80005392:	0ef48263          	beq	s1,a5,80005476 <consoleintr+0x108>
    80005396:	47c1                	li	a5,16
    80005398:	10f49363          	bne	s1,a5,8000549e <consoleintr+0x130>
  case C('P'):  // Print process list.
    procdump();
    8000539c:	e7efc0ef          	jal	80001a1a <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    800053a0:	0023b517          	auipc	a0,0x23b
    800053a4:	78050513          	addi	a0,a0,1920 # 80240b20 <cons>
    800053a8:	0f7000ef          	jal	80005c9e <release>
}
    800053ac:	60e2                	ld	ra,24(sp)
    800053ae:	6442                	ld	s0,16(sp)
    800053b0:	64a2                	ld	s1,8(sp)
    800053b2:	6105                	addi	sp,sp,32
    800053b4:	8082                	ret
  switch(c){
    800053b6:	07f00793          	li	a5,127
    800053ba:	0af48e63          	beq	s1,a5,80005476 <consoleintr+0x108>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    800053be:	0023b717          	auipc	a4,0x23b
    800053c2:	76270713          	addi	a4,a4,1890 # 80240b20 <cons>
    800053c6:	0a072783          	lw	a5,160(a4)
    800053ca:	09872703          	lw	a4,152(a4)
    800053ce:	9f99                	subw	a5,a5,a4
    800053d0:	07f00713          	li	a4,127
    800053d4:	fcf766e3          	bltu	a4,a5,800053a0 <consoleintr+0x32>
      c = (c == '\r') ? '\n' : c;
    800053d8:	47b5                	li	a5,13
    800053da:	0cf48563          	beq	s1,a5,800054a4 <consoleintr+0x136>
      consputc(c);
    800053de:	8526                	mv	a0,s1
    800053e0:	f5dff0ef          	jal	8000533c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800053e4:	0023b717          	auipc	a4,0x23b
    800053e8:	73c70713          	addi	a4,a4,1852 # 80240b20 <cons>
    800053ec:	0a072683          	lw	a3,160(a4)
    800053f0:	0016879b          	addiw	a5,a3,1
    800053f4:	863e                	mv	a2,a5
    800053f6:	0af72023          	sw	a5,160(a4)
    800053fa:	07f6f693          	andi	a3,a3,127
    800053fe:	9736                	add	a4,a4,a3
    80005400:	00970c23          	sb	s1,24(a4)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005404:	ff648713          	addi	a4,s1,-10
    80005408:	c371                	beqz	a4,800054cc <consoleintr+0x15e>
    8000540a:	14f1                	addi	s1,s1,-4
    8000540c:	c0e1                	beqz	s1,800054cc <consoleintr+0x15e>
    8000540e:	0023b717          	auipc	a4,0x23b
    80005412:	7aa72703          	lw	a4,1962(a4) # 80240bb8 <cons+0x98>
    80005416:	9f99                	subw	a5,a5,a4
    80005418:	08000713          	li	a4,128
    8000541c:	f8e792e3          	bne	a5,a4,800053a0 <consoleintr+0x32>
    80005420:	a075                	j	800054cc <consoleintr+0x15e>
    80005422:	e04a                	sd	s2,0(sp)
    while(cons.e != cons.w &&
    80005424:	0023b717          	auipc	a4,0x23b
    80005428:	6fc70713          	addi	a4,a4,1788 # 80240b20 <cons>
    8000542c:	0a072783          	lw	a5,160(a4)
    80005430:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005434:	0023b497          	auipc	s1,0x23b
    80005438:	6ec48493          	addi	s1,s1,1772 # 80240b20 <cons>
    while(cons.e != cons.w &&
    8000543c:	4929                	li	s2,10
    8000543e:	02f70863          	beq	a4,a5,8000546e <consoleintr+0x100>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005442:	37fd                	addiw	a5,a5,-1
    80005444:	07f7f713          	andi	a4,a5,127
    80005448:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    8000544a:	01874703          	lbu	a4,24(a4)
    8000544e:	03270263          	beq	a4,s2,80005472 <consoleintr+0x104>
      cons.e--;
    80005452:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005456:	10000513          	li	a0,256
    8000545a:	ee3ff0ef          	jal	8000533c <consputc>
    while(cons.e != cons.w &&
    8000545e:	0a04a783          	lw	a5,160(s1)
    80005462:	09c4a703          	lw	a4,156(s1)
    80005466:	fcf71ee3          	bne	a4,a5,80005442 <consoleintr+0xd4>
    8000546a:	6902                	ld	s2,0(sp)
    8000546c:	bf15                	j	800053a0 <consoleintr+0x32>
    8000546e:	6902                	ld	s2,0(sp)
    80005470:	bf05                	j	800053a0 <consoleintr+0x32>
    80005472:	6902                	ld	s2,0(sp)
    80005474:	b735                	j	800053a0 <consoleintr+0x32>
    if(cons.e != cons.w){
    80005476:	0023b717          	auipc	a4,0x23b
    8000547a:	6aa70713          	addi	a4,a4,1706 # 80240b20 <cons>
    8000547e:	0a072783          	lw	a5,160(a4)
    80005482:	09c72703          	lw	a4,156(a4)
    80005486:	f0f70de3          	beq	a4,a5,800053a0 <consoleintr+0x32>
      cons.e--;
    8000548a:	37fd                	addiw	a5,a5,-1
    8000548c:	0023b717          	auipc	a4,0x23b
    80005490:	72f72a23          	sw	a5,1844(a4) # 80240bc0 <cons+0xa0>
      consputc(BACKSPACE);
    80005494:	10000513          	li	a0,256
    80005498:	ea5ff0ef          	jal	8000533c <consputc>
    8000549c:	b711                	j	800053a0 <consoleintr+0x32>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    8000549e:	f00481e3          	beqz	s1,800053a0 <consoleintr+0x32>
    800054a2:	bf31                	j	800053be <consoleintr+0x50>
      consputc(c);
    800054a4:	4529                	li	a0,10
    800054a6:	e97ff0ef          	jal	8000533c <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    800054aa:	0023b797          	auipc	a5,0x23b
    800054ae:	67678793          	addi	a5,a5,1654 # 80240b20 <cons>
    800054b2:	0a07a703          	lw	a4,160(a5)
    800054b6:	0017069b          	addiw	a3,a4,1
    800054ba:	8636                	mv	a2,a3
    800054bc:	0ad7a023          	sw	a3,160(a5)
    800054c0:	07f77713          	andi	a4,a4,127
    800054c4:	97ba                	add	a5,a5,a4
    800054c6:	4729                	li	a4,10
    800054c8:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    800054cc:	0023b797          	auipc	a5,0x23b
    800054d0:	6ec7a823          	sw	a2,1776(a5) # 80240bbc <cons+0x9c>
        wakeup(&cons.r);
    800054d4:	0023b517          	auipc	a0,0x23b
    800054d8:	6e450513          	addi	a0,a0,1764 # 80240bb8 <cons+0x98>
    800054dc:	99cfc0ef          	jal	80001678 <wakeup>
    800054e0:	b5c1                	j	800053a0 <consoleintr+0x32>

00000000800054e2 <consoleinit>:

void
consoleinit(void)
{
    800054e2:	1141                	addi	sp,sp,-16
    800054e4:	e406                	sd	ra,8(sp)
    800054e6:	e022                	sd	s0,0(sp)
    800054e8:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    800054ea:	00002597          	auipc	a1,0x2
    800054ee:	23658593          	addi	a1,a1,566 # 80007720 <etext+0x720>
    800054f2:	0023b517          	auipc	a0,0x23b
    800054f6:	62e50513          	addi	a0,a0,1582 # 80240b20 <cons>
    800054fa:	686000ef          	jal	80005b80 <initlock>

  uartinit();
    800054fe:	4aa000ef          	jal	800059a8 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005502:	00232797          	auipc	a5,0x232
    80005506:	48678793          	addi	a5,a5,1158 # 80237988 <devsw>
    8000550a:	00000717          	auipc	a4,0x0
    8000550e:	d2e70713          	addi	a4,a4,-722 # 80005238 <consoleread>
    80005512:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005514:	00000717          	auipc	a4,0x0
    80005518:	c8270713          	addi	a4,a4,-894 # 80005196 <consolewrite>
    8000551c:	ef98                	sd	a4,24(a5)
}
    8000551e:	60a2                	ld	ra,8(sp)
    80005520:	6402                	ld	s0,0(sp)
    80005522:	0141                	addi	sp,sp,16
    80005524:	8082                	ret

0000000080005526 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(long long xx, int base, int sign)
{
    80005526:	7139                	addi	sp,sp,-64
    80005528:	fc06                	sd	ra,56(sp)
    8000552a:	f822                	sd	s0,48(sp)
    8000552c:	f04a                	sd	s2,32(sp)
    8000552e:	0080                	addi	s0,sp,64
  char buf[20];
  int i;
  unsigned long long x;

  if(sign && (sign = (xx < 0)))
    80005530:	c219                	beqz	a2,80005536 <printint+0x10>
    80005532:	08054163          	bltz	a0,800055b4 <printint+0x8e>
    x = -xx;
  else
    x = xx;
    80005536:	4301                	li	t1,0

  i = 0;
    80005538:	fc840913          	addi	s2,s0,-56
    x = xx;
    8000553c:	86ca                	mv	a3,s2
  i = 0;
    8000553e:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005540:	00002817          	auipc	a6,0x2
    80005544:	35080813          	addi	a6,a6,848 # 80007890 <digits>
    80005548:	88ba                	mv	a7,a4
    8000554a:	0017061b          	addiw	a2,a4,1
    8000554e:	8732                	mv	a4,a2
    80005550:	02b577b3          	remu	a5,a0,a1
    80005554:	97c2                	add	a5,a5,a6
    80005556:	0007c783          	lbu	a5,0(a5)
    8000555a:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000555e:	87aa                	mv	a5,a0
    80005560:	02b55533          	divu	a0,a0,a1
    80005564:	0685                	addi	a3,a3,1
    80005566:	feb7f1e3          	bgeu	a5,a1,80005548 <printint+0x22>

  if(sign)
    8000556a:	00030c63          	beqz	t1,80005582 <printint+0x5c>
    buf[i++] = '-';
    8000556e:	fe060793          	addi	a5,a2,-32
    80005572:	00878633          	add	a2,a5,s0
    80005576:	02d00793          	li	a5,45
    8000557a:	fef60423          	sb	a5,-24(a2)
    8000557e:	0028871b          	addiw	a4,a7,2

  while(--i >= 0)
    80005582:	02e05463          	blez	a4,800055aa <printint+0x84>
    80005586:	f426                	sd	s1,40(sp)
    80005588:	377d                	addiw	a4,a4,-1
    8000558a:	00e904b3          	add	s1,s2,a4
    8000558e:	197d                	addi	s2,s2,-1
    80005590:	993a                	add	s2,s2,a4
    80005592:	1702                	slli	a4,a4,0x20
    80005594:	9301                	srli	a4,a4,0x20
    80005596:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000559a:	0004c503          	lbu	a0,0(s1)
    8000559e:	d9fff0ef          	jal	8000533c <consputc>
  while(--i >= 0)
    800055a2:	14fd                	addi	s1,s1,-1
    800055a4:	ff249be3          	bne	s1,s2,8000559a <printint+0x74>
    800055a8:	74a2                	ld	s1,40(sp)
}
    800055aa:	70e2                	ld	ra,56(sp)
    800055ac:	7442                	ld	s0,48(sp)
    800055ae:	7902                	ld	s2,32(sp)
    800055b0:	6121                	addi	sp,sp,64
    800055b2:	8082                	ret
    x = -xx;
    800055b4:	40a00533          	neg	a0,a0
  if(sign && (sign = (xx < 0)))
    800055b8:	4305                	li	t1,1
    x = -xx;
    800055ba:	bfbd                	j	80005538 <printint+0x12>

00000000800055bc <printf>:
}

// Print to the console.
int
printf(char *fmt, ...)
{
    800055bc:	7131                	addi	sp,sp,-192
    800055be:	fc86                	sd	ra,120(sp)
    800055c0:	f8a2                	sd	s0,112(sp)
    800055c2:	f0ca                	sd	s2,96(sp)
    800055c4:	0100                	addi	s0,sp,128
    800055c6:	892a                	mv	s2,a0
    800055c8:	e40c                	sd	a1,8(s0)
    800055ca:	e810                	sd	a2,16(s0)
    800055cc:	ec14                	sd	a3,24(s0)
    800055ce:	f018                	sd	a4,32(s0)
    800055d0:	f41c                	sd	a5,40(s0)
    800055d2:	03043823          	sd	a6,48(s0)
    800055d6:	03143c23          	sd	a7,56(s0)
  va_list ap;
  int i, cx, c0, c1, c2;
  char *s;

  if(panicking == 0)
    800055da:	00002797          	auipc	a5,0x2
    800055de:	3067a783          	lw	a5,774(a5) # 800078e0 <panicking>
    800055e2:	cf9d                	beqz	a5,80005620 <printf+0x64>
    acquire(&pr.lock);

  va_start(ap, fmt);
    800055e4:	00840793          	addi	a5,s0,8
    800055e8:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    800055ec:	00094503          	lbu	a0,0(s2)
    800055f0:	22050663          	beqz	a0,8000581c <printf+0x260>
    800055f4:	f4a6                	sd	s1,104(sp)
    800055f6:	ecce                	sd	s3,88(sp)
    800055f8:	e8d2                	sd	s4,80(sp)
    800055fa:	e4d6                	sd	s5,72(sp)
    800055fc:	e0da                	sd	s6,64(sp)
    800055fe:	fc5e                	sd	s7,56(sp)
    80005600:	f862                	sd	s8,48(sp)
    80005602:	f06a                	sd	s10,32(sp)
    80005604:	ec6e                	sd	s11,24(sp)
    80005606:	4a01                	li	s4,0
    if(cx != '%'){
    80005608:	02500993          	li	s3,37
      printint(va_arg(ap, uint64), 10, 1);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
      printint(va_arg(ap, uint64), 10, 1);
      i += 2;
    } else if(c0 == 'u'){
    8000560c:	07500c13          	li	s8,117
      printint(va_arg(ap, uint64), 10, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
      printint(va_arg(ap, uint64), 10, 0);
      i += 2;
    } else if(c0 == 'x'){
    80005610:	07800d13          	li	s10,120
      printint(va_arg(ap, uint64), 16, 0);
      i += 1;
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
      printint(va_arg(ap, uint64), 16, 0);
      i += 2;
    } else if(c0 == 'p'){
    80005614:	07000d93          	li	s11,112
      printint(va_arg(ap, uint64), 10, 0);
    80005618:	4b29                	li	s6,10
    if(c0 == 'd'){
    8000561a:	06400b93          	li	s7,100
    8000561e:	a015                	j	80005642 <printf+0x86>
    acquire(&pr.lock);
    80005620:	0023b517          	auipc	a0,0x23b
    80005624:	5a850513          	addi	a0,a0,1448 # 80240bc8 <pr>
    80005628:	5e2000ef          	jal	80005c0a <acquire>
    8000562c:	bf65                	j	800055e4 <printf+0x28>
      consputc(cx);
    8000562e:	d0fff0ef          	jal	8000533c <consputc>
      continue;
    80005632:	84d2                	mv	s1,s4
  for(i = 0; (cx = fmt[i] & 0xff) != 0; i++){
    80005634:	2485                	addiw	s1,s1,1
    80005636:	8a26                	mv	s4,s1
    80005638:	94ca                	add	s1,s1,s2
    8000563a:	0004c503          	lbu	a0,0(s1)
    8000563e:	1c050663          	beqz	a0,8000580a <printf+0x24e>
    if(cx != '%'){
    80005642:	ff3516e3          	bne	a0,s3,8000562e <printf+0x72>
    i++;
    80005646:	001a079b          	addiw	a5,s4,1
    8000564a:	84be                	mv	s1,a5
    c0 = fmt[i+0] & 0xff;
    8000564c:	00f90733          	add	a4,s2,a5
    80005650:	00074a83          	lbu	s5,0(a4)
    if(c0) c1 = fmt[i+1] & 0xff;
    80005654:	200a8963          	beqz	s5,80005866 <printf+0x2aa>
    80005658:	00174683          	lbu	a3,1(a4)
    if(c1) c2 = fmt[i+2] & 0xff;
    8000565c:	1e068c63          	beqz	a3,80005854 <printf+0x298>
    if(c0 == 'd'){
    80005660:	037a8863          	beq	s5,s7,80005690 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005664:	f94a8713          	addi	a4,s5,-108
    80005668:	00173713          	seqz	a4,a4
    8000566c:	f9c68613          	addi	a2,a3,-100
    80005670:	ee05                	bnez	a2,800056a8 <printf+0xec>
    80005672:	cb1d                	beqz	a4,800056a8 <printf+0xec>
      printint(va_arg(ap, uint64), 10, 1);
    80005674:	f8843783          	ld	a5,-120(s0)
    80005678:	00878713          	addi	a4,a5,8
    8000567c:	f8e43423          	sd	a4,-120(s0)
    80005680:	4605                	li	a2,1
    80005682:	85da                	mv	a1,s6
    80005684:	6388                	ld	a0,0(a5)
    80005686:	ea1ff0ef          	jal	80005526 <printint>
      i += 1;
    8000568a:	002a049b          	addiw	s1,s4,2
    8000568e:	b75d                	j	80005634 <printf+0x78>
      printint(va_arg(ap, int), 10, 1);
    80005690:	f8843783          	ld	a5,-120(s0)
    80005694:	00878713          	addi	a4,a5,8
    80005698:	f8e43423          	sd	a4,-120(s0)
    8000569c:	4605                	li	a2,1
    8000569e:	85da                	mv	a1,s6
    800056a0:	4388                	lw	a0,0(a5)
    800056a2:	e85ff0ef          	jal	80005526 <printint>
    800056a6:	b779                	j	80005634 <printf+0x78>
    if(c1) c2 = fmt[i+2] & 0xff;
    800056a8:	97ca                	add	a5,a5,s2
    800056aa:	8636                	mv	a2,a3
    800056ac:	0027c683          	lbu	a3,2(a5)
    800056b0:	a2c9                	j	80005872 <printf+0x2b6>
      printint(va_arg(ap, uint64), 10, 1);
    800056b2:	f8843783          	ld	a5,-120(s0)
    800056b6:	00878713          	addi	a4,a5,8
    800056ba:	f8e43423          	sd	a4,-120(s0)
    800056be:	4605                	li	a2,1
    800056c0:	45a9                	li	a1,10
    800056c2:	6388                	ld	a0,0(a5)
    800056c4:	e63ff0ef          	jal	80005526 <printint>
      i += 2;
    800056c8:	003a049b          	addiw	s1,s4,3
    800056cc:	b7a5                	j	80005634 <printf+0x78>
      printint(va_arg(ap, uint32), 10, 0);
    800056ce:	f8843783          	ld	a5,-120(s0)
    800056d2:	00878713          	addi	a4,a5,8
    800056d6:	f8e43423          	sd	a4,-120(s0)
    800056da:	4601                	li	a2,0
    800056dc:	85da                	mv	a1,s6
    800056de:	0007e503          	lwu	a0,0(a5)
    800056e2:	e45ff0ef          	jal	80005526 <printint>
    800056e6:	b7b9                	j	80005634 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    800056e8:	f8843783          	ld	a5,-120(s0)
    800056ec:	00878713          	addi	a4,a5,8
    800056f0:	f8e43423          	sd	a4,-120(s0)
    800056f4:	4601                	li	a2,0
    800056f6:	85da                	mv	a1,s6
    800056f8:	6388                	ld	a0,0(a5)
    800056fa:	e2dff0ef          	jal	80005526 <printint>
      i += 1;
    800056fe:	002a049b          	addiw	s1,s4,2
    80005702:	bf0d                	j	80005634 <printf+0x78>
      printint(va_arg(ap, uint64), 10, 0);
    80005704:	f8843783          	ld	a5,-120(s0)
    80005708:	00878713          	addi	a4,a5,8
    8000570c:	f8e43423          	sd	a4,-120(s0)
    80005710:	4601                	li	a2,0
    80005712:	45a9                	li	a1,10
    80005714:	6388                	ld	a0,0(a5)
    80005716:	e11ff0ef          	jal	80005526 <printint>
      i += 2;
    8000571a:	003a049b          	addiw	s1,s4,3
    8000571e:	bf19                	j	80005634 <printf+0x78>
      printint(va_arg(ap, uint32), 16, 0);
    80005720:	f8843783          	ld	a5,-120(s0)
    80005724:	00878713          	addi	a4,a5,8
    80005728:	f8e43423          	sd	a4,-120(s0)
    8000572c:	4601                	li	a2,0
    8000572e:	45c1                	li	a1,16
    80005730:	0007e503          	lwu	a0,0(a5)
    80005734:	df3ff0ef          	jal	80005526 <printint>
    80005738:	bdf5                	j	80005634 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    8000573a:	f8843783          	ld	a5,-120(s0)
    8000573e:	00878713          	addi	a4,a5,8
    80005742:	f8e43423          	sd	a4,-120(s0)
    80005746:	45c1                	li	a1,16
    80005748:	6388                	ld	a0,0(a5)
    8000574a:	dddff0ef          	jal	80005526 <printint>
      i += 1;
    8000574e:	002a049b          	addiw	s1,s4,2
    80005752:	b5cd                	j	80005634 <printf+0x78>
      printint(va_arg(ap, uint64), 16, 0);
    80005754:	f8843783          	ld	a5,-120(s0)
    80005758:	00878713          	addi	a4,a5,8
    8000575c:	f8e43423          	sd	a4,-120(s0)
    80005760:	4601                	li	a2,0
    80005762:	45c1                	li	a1,16
    80005764:	6388                	ld	a0,0(a5)
    80005766:	dc1ff0ef          	jal	80005526 <printint>
      i += 2;
    8000576a:	003a049b          	addiw	s1,s4,3
    8000576e:	b5d9                	j	80005634 <printf+0x78>
    80005770:	f466                	sd	s9,40(sp)
      printptr(va_arg(ap, uint64));
    80005772:	f8843783          	ld	a5,-120(s0)
    80005776:	00878713          	addi	a4,a5,8
    8000577a:	f8e43423          	sd	a4,-120(s0)
    8000577e:	0007ba83          	ld	s5,0(a5)
  consputc('0');
    80005782:	03000513          	li	a0,48
    80005786:	bb7ff0ef          	jal	8000533c <consputc>
  consputc('x');
    8000578a:	07800513          	li	a0,120
    8000578e:	bafff0ef          	jal	8000533c <consputc>
    80005792:	4a41                	li	s4,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005794:	00002c97          	auipc	s9,0x2
    80005798:	0fcc8c93          	addi	s9,s9,252 # 80007890 <digits>
    8000579c:	03cad793          	srli	a5,s5,0x3c
    800057a0:	97e6                	add	a5,a5,s9
    800057a2:	0007c503          	lbu	a0,0(a5)
    800057a6:	b97ff0ef          	jal	8000533c <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800057aa:	0a92                	slli	s5,s5,0x4
    800057ac:	3a7d                	addiw	s4,s4,-1
    800057ae:	fe0a17e3          	bnez	s4,8000579c <printf+0x1e0>
    800057b2:	7ca2                	ld	s9,40(sp)
    800057b4:	b541                	j	80005634 <printf+0x78>
    } else if(c0 == 'c'){
      consputc(va_arg(ap, uint));
    800057b6:	f8843783          	ld	a5,-120(s0)
    800057ba:	00878713          	addi	a4,a5,8
    800057be:	f8e43423          	sd	a4,-120(s0)
    800057c2:	4388                	lw	a0,0(a5)
    800057c4:	b79ff0ef          	jal	8000533c <consputc>
    800057c8:	b5b5                	j	80005634 <printf+0x78>
    } else if(c0 == 's'){
      if((s = va_arg(ap, char*)) == 0)
    800057ca:	f8843783          	ld	a5,-120(s0)
    800057ce:	00878713          	addi	a4,a5,8
    800057d2:	f8e43423          	sd	a4,-120(s0)
    800057d6:	0007ba03          	ld	s4,0(a5)
    800057da:	000a0d63          	beqz	s4,800057f4 <printf+0x238>
        s = "(null)";
      for(; *s; s++)
    800057de:	000a4503          	lbu	a0,0(s4)
    800057e2:	e40509e3          	beqz	a0,80005634 <printf+0x78>
        consputc(*s);
    800057e6:	b57ff0ef          	jal	8000533c <consputc>
      for(; *s; s++)
    800057ea:	0a05                	addi	s4,s4,1
    800057ec:	000a4503          	lbu	a0,0(s4)
    800057f0:	f97d                	bnez	a0,800057e6 <printf+0x22a>
    800057f2:	b589                	j	80005634 <printf+0x78>
        s = "(null)";
    800057f4:	00002a17          	auipc	s4,0x2
    800057f8:	f34a0a13          	addi	s4,s4,-204 # 80007728 <etext+0x728>
      for(; *s; s++)
    800057fc:	02800513          	li	a0,40
    80005800:	b7dd                	j	800057e6 <printf+0x22a>
    } else if(c0 == '%'){
      consputc('%');
    80005802:	8556                	mv	a0,s5
    80005804:	b39ff0ef          	jal	8000533c <consputc>
    80005808:	b535                	j	80005634 <printf+0x78>
    8000580a:	74a6                	ld	s1,104(sp)
    8000580c:	69e6                	ld	s3,88(sp)
    8000580e:	6a46                	ld	s4,80(sp)
    80005810:	6aa6                	ld	s5,72(sp)
    80005812:	6b06                	ld	s6,64(sp)
    80005814:	7be2                	ld	s7,56(sp)
    80005816:	7c42                	ld	s8,48(sp)
    80005818:	7d02                	ld	s10,32(sp)
    8000581a:	6de2                	ld	s11,24(sp)
    }

  }
  va_end(ap);

  if(panicking == 0)
    8000581c:	00002797          	auipc	a5,0x2
    80005820:	0c47a783          	lw	a5,196(a5) # 800078e0 <panicking>
    80005824:	c38d                	beqz	a5,80005846 <printf+0x28a>
    release(&pr.lock);

  return 0;
}
    80005826:	4501                	li	a0,0
    80005828:	70e6                	ld	ra,120(sp)
    8000582a:	7446                	ld	s0,112(sp)
    8000582c:	7906                	ld	s2,96(sp)
    8000582e:	6129                	addi	sp,sp,192
    80005830:	8082                	ret
    80005832:	74a6                	ld	s1,104(sp)
    80005834:	69e6                	ld	s3,88(sp)
    80005836:	6a46                	ld	s4,80(sp)
    80005838:	6aa6                	ld	s5,72(sp)
    8000583a:	6b06                	ld	s6,64(sp)
    8000583c:	7be2                	ld	s7,56(sp)
    8000583e:	7c42                	ld	s8,48(sp)
    80005840:	7d02                	ld	s10,32(sp)
    80005842:	6de2                	ld	s11,24(sp)
    80005844:	bfe1                	j	8000581c <printf+0x260>
    release(&pr.lock);
    80005846:	0023b517          	auipc	a0,0x23b
    8000584a:	38250513          	addi	a0,a0,898 # 80240bc8 <pr>
    8000584e:	450000ef          	jal	80005c9e <release>
  return 0;
    80005852:	bfd1                	j	80005826 <printf+0x26a>
    if(c0 == 'd'){
    80005854:	e37a8ee3          	beq	s5,s7,80005690 <printf+0xd4>
    } else if(c0 == 'l' && c1 == 'd'){
    80005858:	f94a8713          	addi	a4,s5,-108
    8000585c:	00173713          	seqz	a4,a4
    80005860:	8636                	mv	a2,a3
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005862:	4781                	li	a5,0
    80005864:	a00d                	j	80005886 <printf+0x2ca>
    } else if(c0 == 'l' && c1 == 'd'){
    80005866:	f94a8713          	addi	a4,s5,-108
    8000586a:	00173713          	seqz	a4,a4
    c1 = c2 = 0;
    8000586e:	8656                	mv	a2,s5
    80005870:	86d6                	mv	a3,s5
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'd'){
    80005872:	f9460793          	addi	a5,a2,-108
    80005876:	0017b793          	seqz	a5,a5
    8000587a:	8ff9                	and	a5,a5,a4
    8000587c:	f9c68593          	addi	a1,a3,-100
    80005880:	e199                	bnez	a1,80005886 <printf+0x2ca>
    80005882:	e20798e3          	bnez	a5,800056b2 <printf+0xf6>
    } else if(c0 == 'u'){
    80005886:	e58a84e3          	beq	s5,s8,800056ce <printf+0x112>
    } else if(c0 == 'l' && c1 == 'u'){
    8000588a:	f8b60593          	addi	a1,a2,-117
    8000588e:	e199                	bnez	a1,80005894 <printf+0x2d8>
    80005890:	e4071ce3          	bnez	a4,800056e8 <printf+0x12c>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'u'){
    80005894:	f8b68593          	addi	a1,a3,-117
    80005898:	e199                	bnez	a1,8000589e <printf+0x2e2>
    8000589a:	e60795e3          	bnez	a5,80005704 <printf+0x148>
    } else if(c0 == 'x'){
    8000589e:	e9aa81e3          	beq	s5,s10,80005720 <printf+0x164>
    } else if(c0 == 'l' && c1 == 'x'){
    800058a2:	f8860613          	addi	a2,a2,-120
    800058a6:	e219                	bnez	a2,800058ac <printf+0x2f0>
    800058a8:	e80719e3          	bnez	a4,8000573a <printf+0x17e>
    } else if(c0 == 'l' && c1 == 'l' && c2 == 'x'){
    800058ac:	f8868693          	addi	a3,a3,-120
    800058b0:	e299                	bnez	a3,800058b6 <printf+0x2fa>
    800058b2:	ea0791e3          	bnez	a5,80005754 <printf+0x198>
    } else if(c0 == 'p'){
    800058b6:	ebba8de3          	beq	s5,s11,80005770 <printf+0x1b4>
    } else if(c0 == 'c'){
    800058ba:	06300793          	li	a5,99
    800058be:	eefa8ce3          	beq	s5,a5,800057b6 <printf+0x1fa>
    } else if(c0 == 's'){
    800058c2:	07300793          	li	a5,115
    800058c6:	f0fa82e3          	beq	s5,a5,800057ca <printf+0x20e>
    } else if(c0 == '%'){
    800058ca:	02500793          	li	a5,37
    800058ce:	f2fa8ae3          	beq	s5,a5,80005802 <printf+0x246>
    } else if(c0 == 0){
    800058d2:	f60a80e3          	beqz	s5,80005832 <printf+0x276>
      consputc('%');
    800058d6:	02500513          	li	a0,37
    800058da:	a63ff0ef          	jal	8000533c <consputc>
      consputc(c0);
    800058de:	8556                	mv	a0,s5
    800058e0:	a5dff0ef          	jal	8000533c <consputc>
    800058e4:	bb81                	j	80005634 <printf+0x78>

00000000800058e6 <printfinit>:
    ;
}

void
printfinit(void)
{
    800058e6:	1141                	addi	sp,sp,-16
    800058e8:	e406                	sd	ra,8(sp)
    800058ea:	e022                	sd	s0,0(sp)
    800058ec:	0800                	addi	s0,sp,16
  initlock(&pr.lock, "pr");
    800058ee:	00002597          	auipc	a1,0x2
    800058f2:	e4258593          	addi	a1,a1,-446 # 80007730 <etext+0x730>
    800058f6:	0023b517          	auipc	a0,0x23b
    800058fa:	2d250513          	addi	a0,a0,722 # 80240bc8 <pr>
    800058fe:	282000ef          	jal	80005b80 <initlock>
}
    80005902:	60a2                	ld	ra,8(sp)
    80005904:	6402                	ld	s0,0(sp)
    80005906:	0141                	addi	sp,sp,16
    80005908:	8082                	ret

000000008000590a <backtrace>:

void
backtrace(void)
{
    8000590a:	7179                	addi	sp,sp,-48
    8000590c:	f406                	sd	ra,40(sp)
    8000590e:	f022                	sd	s0,32(sp)
    80005910:	e84a                	sd	s2,16(sp)
    80005912:	1800                	addi	s0,sp,48
  printf("backtrace:\n");
    80005914:	00002517          	auipc	a0,0x2
    80005918:	e2450513          	addi	a0,a0,-476 # 80007738 <etext+0x738>
    8000591c:	ca1ff0ef          	jal	800055bc <printf>
  asm volatile("mv %0, s0" : "=r" (x) );
    80005920:	8922                	mv	s2,s0
  uint64 fp = r_fp();                    // current frame pointer (s0)

  // Remember which page this stack lives on
  uint64 stack_page = PGROUNDDOWN(fp);

  while (fp != 0 && PGROUNDDOWN(fp) == stack_page) {
    80005922:	02090a63          	beqz	s2,80005956 <backtrace+0x4c>
    80005926:	ec26                	sd	s1,24(sp)
    80005928:	e44e                	sd	s3,8(sp)
    8000592a:	e052                	sd	s4,0(sp)
  uint64 fp = r_fp();                    // current frame pointer (s0)
    8000592c:	84ca                	mv	s1,s2
    uint64 ra = *(uint64*)(fp - 8);
    // print the saved return address
    printf("%p\n", (void *)ra);
    8000592e:	00002997          	auipc	s3,0x2
    80005932:	e1a98993          	addi	s3,s3,-486 # 80007748 <etext+0x748>
  while (fp != 0 && PGROUNDDOWN(fp) == stack_page) {
    80005936:	6a05                	lui	s4,0x1
    printf("%p\n", (void *)ra);
    80005938:	ff84b583          	ld	a1,-8(s1)
    8000593c:	854e                	mv	a0,s3
    8000593e:	c7fff0ef          	jal	800055bc <printf>

    // move to the previous frame
    fp = *(uint64*)(fp - 16);
    80005942:	ff04b483          	ld	s1,-16(s1)
  while (fp != 0 && PGROUNDDOWN(fp) == stack_page) {
    80005946:	cc89                	beqz	s1,80005960 <backtrace+0x56>
    80005948:	0124c7b3          	xor	a5,s1,s2
    8000594c:	ff47e6e3          	bltu	a5,s4,80005938 <backtrace+0x2e>
    80005950:	64e2                	ld	s1,24(sp)
    80005952:	69a2                	ld	s3,8(sp)
    80005954:	6a02                	ld	s4,0(sp)
  }
}
    80005956:	70a2                	ld	ra,40(sp)
    80005958:	7402                	ld	s0,32(sp)
    8000595a:	6942                	ld	s2,16(sp)
    8000595c:	6145                	addi	sp,sp,48
    8000595e:	8082                	ret
    80005960:	64e2                	ld	s1,24(sp)
    80005962:	69a2                	ld	s3,8(sp)
    80005964:	6a02                	ld	s4,0(sp)
    80005966:	bfc5                	j	80005956 <backtrace+0x4c>

0000000080005968 <panic>:
{
    80005968:	1101                	addi	sp,sp,-32
    8000596a:	ec06                	sd	ra,24(sp)
    8000596c:	e822                	sd	s0,16(sp)
    8000596e:	e426                	sd	s1,8(sp)
    80005970:	e04a                	sd	s2,0(sp)
    80005972:	1000                	addi	s0,sp,32
    80005974:	892a                	mv	s2,a0
  panicking = 1;
    80005976:	4485                	li	s1,1
    80005978:	00002797          	auipc	a5,0x2
    8000597c:	f697a423          	sw	s1,-152(a5) # 800078e0 <panicking>
  printf("panic: ");
    80005980:	00002517          	auipc	a0,0x2
    80005984:	dd050513          	addi	a0,a0,-560 # 80007750 <etext+0x750>
    80005988:	c35ff0ef          	jal	800055bc <printf>
  printf("%s\n", s);
    8000598c:	85ca                	mv	a1,s2
    8000598e:	00002517          	auipc	a0,0x2
    80005992:	dca50513          	addi	a0,a0,-566 # 80007758 <etext+0x758>
    80005996:	c27ff0ef          	jal	800055bc <printf>
  panicked = 1; // freeze uart output from other CPUs
    8000599a:	00002797          	auipc	a5,0x2
    8000599e:	f497a123          	sw	s1,-190(a5) # 800078dc <panicked>
  backtrace();
    800059a2:	f69ff0ef          	jal	8000590a <backtrace>
  for(;;)
    800059a6:	a001                	j	800059a6 <panic+0x3e>

00000000800059a8 <uartinit>:
extern volatile int panicking; // from printf.c
extern volatile int panicked; // from printf.c

void
uartinit(void)
{
    800059a8:	1141                	addi	sp,sp,-16
    800059aa:	e406                	sd	ra,8(sp)
    800059ac:	e022                	sd	s0,0(sp)
    800059ae:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800059b0:	100007b7          	lui	a5,0x10000
    800059b4:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800059b8:	10000737          	lui	a4,0x10000
    800059bc:	f8000693          	li	a3,-128
    800059c0:	00d701a3          	sb	a3,3(a4) # 10000003 <_entry-0x6ffffffd>

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800059c4:	468d                	li	a3,3
    800059c6:	10000637          	lui	a2,0x10000
    800059ca:	00d60023          	sb	a3,0(a2) # 10000000 <_entry-0x70000000>

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800059ce:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800059d2:	00d701a3          	sb	a3,3(a4)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800059d6:	8732                	mv	a4,a2
    800059d8:	461d                	li	a2,7
    800059da:	00c70123          	sb	a2,2(a4)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800059de:	00d780a3          	sb	a3,1(a5)

  initlock(&tx_lock, "uart");
    800059e2:	00002597          	auipc	a1,0x2
    800059e6:	d7e58593          	addi	a1,a1,-642 # 80007760 <etext+0x760>
    800059ea:	0023b517          	auipc	a0,0x23b
    800059ee:	1f650513          	addi	a0,a0,502 # 80240be0 <tx_lock>
    800059f2:	18e000ef          	jal	80005b80 <initlock>
}
    800059f6:	60a2                	ld	ra,8(sp)
    800059f8:	6402                	ld	s0,0(sp)
    800059fa:	0141                	addi	sp,sp,16
    800059fc:	8082                	ret

00000000800059fe <uartwrite>:
// transmit buf[] to the uart. it blocks if the
// uart is busy, so it cannot be called from
// interrupts, only from write() system calls.
void
uartwrite(char buf[], int n)
{
    800059fe:	715d                	addi	sp,sp,-80
    80005a00:	e486                	sd	ra,72(sp)
    80005a02:	e0a2                	sd	s0,64(sp)
    80005a04:	fc26                	sd	s1,56(sp)
    80005a06:	ec56                	sd	s5,24(sp)
    80005a08:	0880                	addi	s0,sp,80
    80005a0a:	8aaa                	mv	s5,a0
    80005a0c:	84ae                	mv	s1,a1
  acquire(&tx_lock);
    80005a0e:	0023b517          	auipc	a0,0x23b
    80005a12:	1d250513          	addi	a0,a0,466 # 80240be0 <tx_lock>
    80005a16:	1f4000ef          	jal	80005c0a <acquire>

  int i = 0;
  while(i < n){ 
    80005a1a:	06905063          	blez	s1,80005a7a <uartwrite+0x7c>
    80005a1e:	f84a                	sd	s2,48(sp)
    80005a20:	f44e                	sd	s3,40(sp)
    80005a22:	f052                	sd	s4,32(sp)
    80005a24:	e85a                	sd	s6,16(sp)
    80005a26:	e45e                	sd	s7,8(sp)
    80005a28:	8a56                	mv	s4,s5
    80005a2a:	9aa6                	add	s5,s5,s1
    while(tx_busy != 0){
    80005a2c:	00002497          	auipc	s1,0x2
    80005a30:	ebc48493          	addi	s1,s1,-324 # 800078e8 <tx_busy>
      // wait for a UART transmit-complete interrupt
      // to set tx_busy to 0.
      sleep(&tx_chan, &tx_lock);
    80005a34:	0023b997          	auipc	s3,0x23b
    80005a38:	1ac98993          	addi	s3,s3,428 # 80240be0 <tx_lock>
    80005a3c:	00002917          	auipc	s2,0x2
    80005a40:	ea890913          	addi	s2,s2,-344 # 800078e4 <tx_chan>
    }   
      
    WriteReg(THR, buf[i]);
    80005a44:	10000bb7          	lui	s7,0x10000
    i += 1;
    tx_busy = 1;
    80005a48:	4b05                	li	s6,1
    80005a4a:	a005                	j	80005a6a <uartwrite+0x6c>
      sleep(&tx_chan, &tx_lock);
    80005a4c:	85ce                	mv	a1,s3
    80005a4e:	854a                	mv	a0,s2
    80005a50:	bddfb0ef          	jal	8000162c <sleep>
    while(tx_busy != 0){
    80005a54:	409c                	lw	a5,0(s1)
    80005a56:	fbfd                	bnez	a5,80005a4c <uartwrite+0x4e>
    WriteReg(THR, buf[i]);
    80005a58:	000a4783          	lbu	a5,0(s4) # 1000 <_entry-0x7ffff000>
    80005a5c:	00fb8023          	sb	a5,0(s7) # 10000000 <_entry-0x70000000>
    tx_busy = 1;
    80005a60:	0164a023          	sw	s6,0(s1)
  while(i < n){ 
    80005a64:	0a05                	addi	s4,s4,1
    80005a66:	015a0563          	beq	s4,s5,80005a70 <uartwrite+0x72>
    while(tx_busy != 0){
    80005a6a:	409c                	lw	a5,0(s1)
    80005a6c:	f3e5                	bnez	a5,80005a4c <uartwrite+0x4e>
    80005a6e:	b7ed                	j	80005a58 <uartwrite+0x5a>
    80005a70:	7942                	ld	s2,48(sp)
    80005a72:	79a2                	ld	s3,40(sp)
    80005a74:	7a02                	ld	s4,32(sp)
    80005a76:	6b42                	ld	s6,16(sp)
    80005a78:	6ba2                	ld	s7,8(sp)
  }

  release(&tx_lock);
    80005a7a:	0023b517          	auipc	a0,0x23b
    80005a7e:	16650513          	addi	a0,a0,358 # 80240be0 <tx_lock>
    80005a82:	21c000ef          	jal	80005c9e <release>
}
    80005a86:	60a6                	ld	ra,72(sp)
    80005a88:	6406                	ld	s0,64(sp)
    80005a8a:	74e2                	ld	s1,56(sp)
    80005a8c:	6ae2                	ld	s5,24(sp)
    80005a8e:	6161                	addi	sp,sp,80
    80005a90:	8082                	ret

0000000080005a92 <uartputc_sync>:
// interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80005a92:	1101                	addi	sp,sp,-32
    80005a94:	ec06                	sd	ra,24(sp)
    80005a96:	e822                	sd	s0,16(sp)
    80005a98:	e426                	sd	s1,8(sp)
    80005a9a:	1000                	addi	s0,sp,32
    80005a9c:	84aa                	mv	s1,a0
  if(panicking == 0)
    80005a9e:	00002797          	auipc	a5,0x2
    80005aa2:	e427a783          	lw	a5,-446(a5) # 800078e0 <panicking>
    80005aa6:	cf95                	beqz	a5,80005ae2 <uartputc_sync+0x50>
    push_off();

  if(panicked){
    80005aa8:	00002797          	auipc	a5,0x2
    80005aac:	e347a783          	lw	a5,-460(a5) # 800078dc <panicked>
    80005ab0:	ef85                	bnez	a5,80005ae8 <uartputc_sync+0x56>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80005ab2:	10000737          	lui	a4,0x10000
    80005ab6:	0715                	addi	a4,a4,5 # 10000005 <_entry-0x6ffffffb>
    80005ab8:	00074783          	lbu	a5,0(a4)
    80005abc:	0207f793          	andi	a5,a5,32
    80005ac0:	dfe5                	beqz	a5,80005ab8 <uartputc_sync+0x26>
    ;
  WriteReg(THR, c);
    80005ac2:	0ff4f513          	zext.b	a0,s1
    80005ac6:	100007b7          	lui	a5,0x10000
    80005aca:	00a78023          	sb	a0,0(a5) # 10000000 <_entry-0x70000000>

  if(panicking == 0)
    80005ace:	00002797          	auipc	a5,0x2
    80005ad2:	e127a783          	lw	a5,-494(a5) # 800078e0 <panicking>
    80005ad6:	cb91                	beqz	a5,80005aea <uartputc_sync+0x58>
    pop_off();
}
    80005ad8:	60e2                	ld	ra,24(sp)
    80005ada:	6442                	ld	s0,16(sp)
    80005adc:	64a2                	ld	s1,8(sp)
    80005ade:	6105                	addi	sp,sp,32
    80005ae0:	8082                	ret
    push_off();
    80005ae2:	0e4000ef          	jal	80005bc6 <push_off>
    80005ae6:	b7c9                	j	80005aa8 <uartputc_sync+0x16>
    for(;;)
    80005ae8:	a001                	j	80005ae8 <uartputc_sync+0x56>
    pop_off();
    80005aea:	164000ef          	jal	80005c4e <pop_off>
}
    80005aee:	b7ed                	j	80005ad8 <uartputc_sync+0x46>

0000000080005af0 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80005af0:	1141                	addi	sp,sp,-16
    80005af2:	e406                	sd	ra,8(sp)
    80005af4:	e022                	sd	s0,0(sp)
    80005af6:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & LSR_RX_READY){
    80005af8:	100007b7          	lui	a5,0x10000
    80005afc:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005b00:	8b85                	andi	a5,a5,1
    80005b02:	cb89                	beqz	a5,80005b14 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80005b04:	100007b7          	lui	a5,0x10000
    80005b08:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
  } else {
    return -1;
  }
}
    80005b0c:	60a2                	ld	ra,8(sp)
    80005b0e:	6402                	ld	s0,0(sp)
    80005b10:	0141                	addi	sp,sp,16
    80005b12:	8082                	ret
    return -1;
    80005b14:	557d                	li	a0,-1
    80005b16:	bfdd                	j	80005b0c <uartgetc+0x1c>

0000000080005b18 <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    80005b18:	1101                	addi	sp,sp,-32
    80005b1a:	ec06                	sd	ra,24(sp)
    80005b1c:	e822                	sd	s0,16(sp)
    80005b1e:	e426                	sd	s1,8(sp)
    80005b20:	1000                	addi	s0,sp,32
  ReadReg(ISR); // acknowledge the interrupt
    80005b22:	100007b7          	lui	a5,0x10000
    80005b26:	0027c783          	lbu	a5,2(a5) # 10000002 <_entry-0x6ffffffe>

  acquire(&tx_lock);
    80005b2a:	0023b517          	auipc	a0,0x23b
    80005b2e:	0b650513          	addi	a0,a0,182 # 80240be0 <tx_lock>
    80005b32:	0d8000ef          	jal	80005c0a <acquire>
  if(ReadReg(LSR) & LSR_TX_IDLE){
    80005b36:	100007b7          	lui	a5,0x10000
    80005b3a:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80005b3e:	0207f793          	andi	a5,a5,32
    80005b42:	ef99                	bnez	a5,80005b60 <uartintr+0x48>
    // UART finished transmitting; wake up sending thread.
    tx_busy = 0;
    wakeup(&tx_chan);
  }
  release(&tx_lock);
    80005b44:	0023b517          	auipc	a0,0x23b
    80005b48:	09c50513          	addi	a0,a0,156 # 80240be0 <tx_lock>
    80005b4c:	152000ef          	jal	80005c9e <release>

  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80005b50:	54fd                	li	s1,-1
    int c = uartgetc();
    80005b52:	f9fff0ef          	jal	80005af0 <uartgetc>
    if(c == -1)
    80005b56:	02950063          	beq	a0,s1,80005b76 <uartintr+0x5e>
      break;
    consoleintr(c);
    80005b5a:	815ff0ef          	jal	8000536e <consoleintr>
  while(1){
    80005b5e:	bfd5                	j	80005b52 <uartintr+0x3a>
    tx_busy = 0;
    80005b60:	00002797          	auipc	a5,0x2
    80005b64:	d807a423          	sw	zero,-632(a5) # 800078e8 <tx_busy>
    wakeup(&tx_chan);
    80005b68:	00002517          	auipc	a0,0x2
    80005b6c:	d7c50513          	addi	a0,a0,-644 # 800078e4 <tx_chan>
    80005b70:	b09fb0ef          	jal	80001678 <wakeup>
    80005b74:	bfc1                	j	80005b44 <uartintr+0x2c>
  }
}
    80005b76:	60e2                	ld	ra,24(sp)
    80005b78:	6442                	ld	s0,16(sp)
    80005b7a:	64a2                	ld	s1,8(sp)
    80005b7c:	6105                	addi	sp,sp,32
    80005b7e:	8082                	ret

0000000080005b80 <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    80005b80:	1141                	addi	sp,sp,-16
    80005b82:	e406                	sd	ra,8(sp)
    80005b84:	e022                	sd	s0,0(sp)
    80005b86:	0800                	addi	s0,sp,16
  lk->name = name;
    80005b88:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80005b8a:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80005b8e:	00053823          	sd	zero,16(a0)
}
    80005b92:	60a2                	ld	ra,8(sp)
    80005b94:	6402                	ld	s0,0(sp)
    80005b96:	0141                	addi	sp,sp,16
    80005b98:	8082                	ret

0000000080005b9a <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80005b9a:	411c                	lw	a5,0(a0)
    80005b9c:	e399                	bnez	a5,80005ba2 <holding+0x8>
    80005b9e:	4501                	li	a0,0
  return r;
}
    80005ba0:	8082                	ret
{
    80005ba2:	1101                	addi	sp,sp,-32
    80005ba4:	ec06                	sd	ra,24(sp)
    80005ba6:	e822                	sd	s0,16(sp)
    80005ba8:	e426                	sd	s1,8(sp)
    80005baa:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80005bac:	691c                	ld	a5,16(a0)
    80005bae:	84be                	mv	s1,a5
    80005bb0:	c5efb0ef          	jal	8000100e <mycpu>
    80005bb4:	40a48533          	sub	a0,s1,a0
    80005bb8:	00153513          	seqz	a0,a0
}
    80005bbc:	60e2                	ld	ra,24(sp)
    80005bbe:	6442                	ld	s0,16(sp)
    80005bc0:	64a2                	ld	s1,8(sp)
    80005bc2:	6105                	addi	sp,sp,32
    80005bc4:	8082                	ret

0000000080005bc6 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80005bc6:	1101                	addi	sp,sp,-32
    80005bc8:	ec06                	sd	ra,24(sp)
    80005bca:	e822                	sd	s0,16(sp)
    80005bcc:	e426                	sd	s1,8(sp)
    80005bce:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005bd0:	100027f3          	csrr	a5,sstatus
    80005bd4:	84be                	mv	s1,a5
    80005bd6:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80005bda:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005bdc:	10079073          	csrw	sstatus,a5

  // disable interrupts to prevent an involuntary context
  // switch while using mycpu().
  intr_off();

  if(mycpu()->noff == 0)
    80005be0:	c2efb0ef          	jal	8000100e <mycpu>
    80005be4:	5d3c                	lw	a5,120(a0)
    80005be6:	cb99                	beqz	a5,80005bfc <push_off+0x36>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80005be8:	c26fb0ef          	jal	8000100e <mycpu>
    80005bec:	5d3c                	lw	a5,120(a0)
    80005bee:	2785                	addiw	a5,a5,1
    80005bf0:	dd3c                	sw	a5,120(a0)
}
    80005bf2:	60e2                	ld	ra,24(sp)
    80005bf4:	6442                	ld	s0,16(sp)
    80005bf6:	64a2                	ld	s1,8(sp)
    80005bf8:	6105                	addi	sp,sp,32
    80005bfa:	8082                	ret
    mycpu()->intena = old;
    80005bfc:	c12fb0ef          	jal	8000100e <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80005c00:	0014d793          	srli	a5,s1,0x1
    80005c04:	8b85                	andi	a5,a5,1
    80005c06:	dd7c                	sw	a5,124(a0)
    80005c08:	b7c5                	j	80005be8 <push_off+0x22>

0000000080005c0a <acquire>:
{
    80005c0a:	1101                	addi	sp,sp,-32
    80005c0c:	ec06                	sd	ra,24(sp)
    80005c0e:	e822                	sd	s0,16(sp)
    80005c10:	e426                	sd	s1,8(sp)
    80005c12:	1000                	addi	s0,sp,32
    80005c14:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80005c16:	fb1ff0ef          	jal	80005bc6 <push_off>
  if(holding(lk))
    80005c1a:	8526                	mv	a0,s1
    80005c1c:	f7fff0ef          	jal	80005b9a <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005c20:	4705                	li	a4,1
  if(holding(lk))
    80005c22:	e105                	bnez	a0,80005c42 <acquire+0x38>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    80005c24:	87ba                	mv	a5,a4
    80005c26:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80005c2a:	2781                	sext.w	a5,a5
    80005c2c:	ffe5                	bnez	a5,80005c24 <acquire+0x1a>
  __sync_synchronize();
    80005c2e:	0330000f          	fence	rw,rw
  lk->cpu = mycpu();
    80005c32:	bdcfb0ef          	jal	8000100e <mycpu>
    80005c36:	e888                	sd	a0,16(s1)
}
    80005c38:	60e2                	ld	ra,24(sp)
    80005c3a:	6442                	ld	s0,16(sp)
    80005c3c:	64a2                	ld	s1,8(sp)
    80005c3e:	6105                	addi	sp,sp,32
    80005c40:	8082                	ret
    panic("acquire");
    80005c42:	00002517          	auipc	a0,0x2
    80005c46:	b2650513          	addi	a0,a0,-1242 # 80007768 <etext+0x768>
    80005c4a:	d1fff0ef          	jal	80005968 <panic>

0000000080005c4e <pop_off>:

void
pop_off(void)
{
    80005c4e:	1141                	addi	sp,sp,-16
    80005c50:	e406                	sd	ra,8(sp)
    80005c52:	e022                	sd	s0,0(sp)
    80005c54:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80005c56:	bb8fb0ef          	jal	8000100e <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005c5a:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80005c5e:	8b89                	andi	a5,a5,2
  if(intr_get())
    80005c60:	e39d                	bnez	a5,80005c86 <pop_off+0x38>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80005c62:	5d3c                	lw	a5,120(a0)
    80005c64:	02f05763          	blez	a5,80005c92 <pop_off+0x44>
    panic("pop_off");
  c->noff -= 1;
    80005c68:	37fd                	addiw	a5,a5,-1
    80005c6a:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80005c6c:	eb89                	bnez	a5,80005c7e <pop_off+0x30>
    80005c6e:	5d7c                	lw	a5,124(a0)
    80005c70:	c799                	beqz	a5,80005c7e <pop_off+0x30>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80005c72:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80005c76:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80005c7a:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80005c7e:	60a2                	ld	ra,8(sp)
    80005c80:	6402                	ld	s0,0(sp)
    80005c82:	0141                	addi	sp,sp,16
    80005c84:	8082                	ret
    panic("pop_off - interruptible");
    80005c86:	00002517          	auipc	a0,0x2
    80005c8a:	aea50513          	addi	a0,a0,-1302 # 80007770 <etext+0x770>
    80005c8e:	cdbff0ef          	jal	80005968 <panic>
    panic("pop_off");
    80005c92:	00002517          	auipc	a0,0x2
    80005c96:	af650513          	addi	a0,a0,-1290 # 80007788 <etext+0x788>
    80005c9a:	ccfff0ef          	jal	80005968 <panic>

0000000080005c9e <release>:
{
    80005c9e:	1101                	addi	sp,sp,-32
    80005ca0:	ec06                	sd	ra,24(sp)
    80005ca2:	e822                	sd	s0,16(sp)
    80005ca4:	e426                	sd	s1,8(sp)
    80005ca6:	1000                	addi	s0,sp,32
    80005ca8:	84aa                	mv	s1,a0
  if(!holding(lk))
    80005caa:	ef1ff0ef          	jal	80005b9a <holding>
    80005cae:	c105                	beqz	a0,80005cce <release+0x30>
  lk->cpu = 0;
    80005cb0:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    80005cb4:	0330000f          	fence	rw,rw
  __sync_lock_release(&lk->locked);
    80005cb8:	0310000f          	fence	rw,w
    80005cbc:	0004a023          	sw	zero,0(s1)
  pop_off();
    80005cc0:	f8fff0ef          	jal	80005c4e <pop_off>
}
    80005cc4:	60e2                	ld	ra,24(sp)
    80005cc6:	6442                	ld	s0,16(sp)
    80005cc8:	64a2                	ld	s1,8(sp)
    80005cca:	6105                	addi	sp,sp,32
    80005ccc:	8082                	ret
    panic("release");
    80005cce:	00002517          	auipc	a0,0x2
    80005cd2:	ac250513          	addi	a0,a0,-1342 # 80007790 <etext+0x790>
    80005cd6:	c93ff0ef          	jal	80005968 <panic>
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
